﻿///////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи в модели сервиса".
// 
///////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверяет содержится ли пользователь ИБ с заданным идентификатором
// в списке неразделенных пользователей.
//
// Параметры:
// ИдентификаторПользователяИБ - УникальныйИдентификатор - идентификатор
// пользователя ИБ принадлежность которого к неразделенным пользователям
// требуется проверить.
//
Функция ЭтоНеразделенныйПользовательИБ(Знач ИдентификаторПользователяИБ) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ИдентификаторПользователяИБ) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИДНеразделенныхПользователей.ИдентификаторПользователяИБ
	|ИЗ
	|	РегистрСведений.НеразделенныеПользователи КАК ИДНеразделенныхПользователей
	|ГДЕ
	|	ИДНеразделенныхПользователей.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НеразделенныеПользователи");
	ЭлементБлокировки.УстановитьЗначение("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции

// При работе в модели сервиса, заносит текущего пользователя в список неразделенных,
// если у него не установлено использование разделителей.
//
Процедура ЗарегистрироватьНеразделенногоПользователя() Экспорт
	
	Если НЕ ПустаяСтрока(ПользователиИнформационнойБазы.ТекущийПользователь().Имя)
		И ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ПользователиИнформационнойБазы.ТекущийПользователь().РазделениеДанных.Количество() = 0 Тогда
		
		НачатьТранзакцию();
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НеразделенныеПользователи");
			Блокировка.Заблокировать();
			
			МенеджерЗаписи = РегистрыСведений.НеразделенныеПользователи.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.ИдентификаторПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
			МенеджерЗаписи.Прочитать();
			Если НЕ МенеджерЗаписи.Выбран() Тогда
				МенеджерЗаписи.ИдентификаторПользователяИБ = ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор;
				МенеджерЗаписи.ПорядковыйНомер = РегистрыСведений.НеразделенныеПользователи.МаксимальныйПорядковыйНомер() + 1;
				МенеджерЗаписи.Записать();
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает флаг доступности действий изменения пользователей.
//
// Возвращаемое значение:
// Булево - Истина, если изменение пользователей доступно, иначе Ложь.
//
Функция ДоступноИзменениеПользователей() Экспорт
	
	Возврат Константы.РежимИспользованияИнформационнойБазы.Получить() 
		<> Перечисления.РежимыИспользованияИнформационнойБазы.Демонстрационный;
	
КонецФункции

// Возвращает доступные текущему пользователю действия с указанным
// пользователем сервиса
//
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи - пользователь, доступные
//   действия с которым требуется получить. Если не указано, проверяются
//   доступные действия с текущим пользователем.
//  ПарольПользователяСервиса - Строка - пароль текущего пользователя для
//   доступа в сервис.
//  
Функция ПолучитьДействияСПользователемСервиса(Знач Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		Возврат ДействияССуществующимПользователемСервиса(Пользователь);
	Иначе
		Если ЕстьПравоДобавленияПользователей() Тогда
			Возврат ДействияСНовымПользователемСервиса();
		Иначе
			ВызватьИсключение(НСтр("ru = 'Недостаточно прав доступа для добавления новых пользователей'"));
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Формирует запрос на изменение адреса электронной почты пользователя
// сервиса.
//
// Параметры:
//  НоваяПочта - Строка - новый адрес электронной почты пользователя
//  Пользователь - СправочникСсылка.Пользователи - пользователь, которому
//   требуется изменить адрес электронной почты
//  ПарольПользователяСервиса - Строка - пароль текущего пользователя
//   для доступа к менеджеру сервиса
//
Процедура СоздатьЗапросНаСменуПочты(Знач НоваяПочта, Знач Пользователь, Знач ПарольПользователяСервиса) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса(ПарольПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
	ИнформацияОбОшибке = Неопределено;
	Прокси.RequestEmailChange(
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяСервиса"), 
		НоваяПочта, 
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
КонецПроцедуры

// Создает / обновляет запись пользователя сервиса.
// 
// Параметры:
//  Пользователь - СправочникСсылка.Пользователи/СправочникОбъект.Пользователи
//  СоздатьПользователяСервиса - Булево - Истина - создать нового пользователя
//   сервиса, Ложь - обновить существующего.
//  ПарольПользователяСервиса - Строка - пароль текущего пользователя
//   для доступа к менеджеру сервиса
//
Процедура ЗаписатьПользователяСервиса(Знач Пользователь, Знач СоздатьПользователяСервиса, Знач ПарольПользователяСервиса) Экспорт
	
	Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
		ПользовательОбъект = Пользователь.ПолучитьОбъект();
	Иначе
		ПользовательОбъект = Пользователь;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса(ПарольПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(ПользовательОбъект.ИдентификаторПользователяИБ) Тогда
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(ПользовательОбъект.ИдентификаторПользователяИБ);
		ДоступРазрешен = ПользовательИБ <> Неопределено;
	Иначе
		ДоступРазрешен = Ложь;
	КонецЕсли;
	
	ПользовательСервиса = Прокси.ФабрикаXDTO.Создать(
		Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ApplicationUsers", "User"));
	ПользовательСервиса.Zone = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	ПользовательСервиса.UserServiceID = ПользовательОбъект.ИдентификаторПользователяСервиса;
	ПользовательСервиса.FullName = ПользовательОбъект.Наименование;
	
	Если ДоступРазрешен Тогда
		ПользовательСервиса.Name = ПользовательИБ.Имя;
		ПользовательСервиса.StoredPasswordValue = ПользовательИБ.СохраняемоеЗначениеПароля;
		ПользовательСервиса.Language = ПолучитьКодЯзыка(ПользовательИБ.Язык);
		ПользовательСервиса.Access = Истина;
		ПользовательСервиса.AdmininstrativeAccess = ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава);
	Иначе
		ПользовательСервиса.Name = "";
		ПользовательСервиса.StoredPasswordValue = "";
		ПользовательСервиса.Language = "";
		ПользовательСервиса.Access = Ложь;
		ПользовательСервиса.AdmininstrativeAccess = Ложь;
	КонецЕсли;
	
	КонтактнаяИнформация = Прокси.ФабрикаXDTO.Создать(
		Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ApplicationUsers", "ContactsList"));
		
	ТипЗаписьКИ = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ApplicationUsers", "ContactsItem");
	
	Для каждого СтрокаКИ Из ПользовательОбъект.КонтактнаяИнформация Цикл
		ВидКИXDTO = РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИПользователяXDTO().Получить(СтрокаКИ.Вид);
		Если ВидКИXDTO = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗаписьКИ = Прокси.ФабрикаXDTO.Создать(ТипЗаписьКИ);
		ЗаписьКИ.ContactType = ВидКИXDTO;
		ЗаписьКИ.Value = СтрокаКИ.Представление;
		ЗаписьКИ.Parts = СтрокаКИ.ЗначенияПолей;
		
		КонтактнаяИнформация.Item.Добавить(ЗаписьКИ);
	КонецЦикла;
	
	ПользовательСервиса.Contacts = КонтактнаяИнформация;
	
	ИнформацияОбОшибке = Неопределено;
	Если СоздатьПользователяСервиса Тогда
		Прокси.CreateUser(ПользовательСервиса, ИнформацияОбОшибке);
	Иначе
		Прокси.UpdateUser(ПользовательСервиса, ИнформацияОбОшибке);
	КонецЕсли;
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Только для внутреннего использования
Процедура ОбновитьОписаниеWebСервисаМенеджераСервиса() Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	// Кэш должен быть заполнен до записи пользователя ИБ
	РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

// Только для внутреннего использования
Процедура ОбновитьПользователяСервиса(ПользовательОбъект, СоздатьПользователяСервиса) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
		ИЛИ ПользовательОбъект.Служебный Тогда
		
		Возврат;
	КонецЕсли;
	
	Если НЕ ПользовательОбъект.ДополнительныеСвойства.Свойство("СинхронизироватьССервисом")
		ИЛИ НЕ ПользовательОбъект.ДополнительныеСвойства.СинхронизироватьССервисом Тогда
		
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаписатьПользователяСервиса(ПользовательОбъект, 
		СоздатьПользователяСервиса, 
		ПользовательОбъект.ДополнительныеСвойства.ПарольПользователяСервиса);
	
КонецПроцедуры

// Только для внутреннего использования
Процедура ОбработкаПолученияФормыПользователя(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка) Экспорт
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидФормы = "ФормаОбъекта"
		И Параметры.Свойство("Ключ") И НЕ Параметры.Ключ.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1
		|ИЗ
		|	РегистрСведений.НеразделенныеПользователи КАК НеразделенныеПользователи
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО НеразделенныеПользователи.ИдентификаторПользователяИБ = Пользователи.ИдентификаторПользователяИБ
		|			И (Пользователи.Ссылка = &Ссылка)";
		Запрос.УстановитьПараметр("Ссылка", Параметры.Ключ);
		Если НЕ Запрос.Выполнить().Пустой() Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = Метаданные.ОбщиеФормы.ИнформацияНеразделенногоПользователя;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования
Функция ЕстьПравоДобавленияПользователей() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбластьДанных = Прокси.ФабрикаXDTO.Создать(
		Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "Zone"));
	ОбластьДанных.Zone = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	
	ИнформацияОбОшибке = Неопределено;
	ПраваДоступаXDTO = Прокси.GetAccessRights(ОбластьДанных, 
		ИдентификаторСервисаТекущегоПользователя(), ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Для каждого ЭлементСпискаПрав Из ПраваДоступаXDTO.Item Цикл
		Если ЭлементСпискаПрав.AccessRight = "CreateUser" Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Только для внутреннего использования
Функция ДействияСНовымПользователемСервиса() Экспорт
	
	ДействияСПользователемСервиса = НовыеДействияСПользователемСервиса();
	ДействияСПользователемСервиса.ИзменениеПароля = Истина;
	ДействияСПользователемСервиса.ИзменениеИмени = Истина;
	ДействияСПользователемСервиса.ИзменениеПолногоИмени = Истина;
	ДействияСПользователемСервиса.ИзменениеДоступа = Истина;
	ДействияСПользователемСервиса.ИзменениеАдминистративногоДоступа = Истина;
	
	ДействияСКИ = ДействияСПользователемСервиса.КонтактнаяИнформация; 
	Для каждого КлючИЗначение Из РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИПользователяXDTO() Цикл
		ДействияСКИ[КлючИЗначение.Ключ].Изменение = Истина;
	КонецЦикла;
	
	Возврат ДействияСПользователемСервиса;
	
КонецФункции

// Только для внутреннего использования
Функция ДействияССуществующимПользователемСервиса(Знач Пользователь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса();
	УстановитьПривилегированныйРежим(Ложь);
	
	ОбъектыДоступа = ПодготовитьОбъектыДоступаПользователя(Прокси.ФабрикаXDTO, Пользователь);
	
	ИнформацияОбОшибке = Неопределено;
	ПраваДоступаОбъектовXDTO = Прокси.GetObjectsAccessRights(ОбъектыДоступа, 
		ИдентификаторСервисаТекущегоПользователя(), ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Возврат ПраваДоступаОбъектовXDTOВДействияСПользователемСервиса(Прокси.ФабрикаXDTO, ПраваДоступаОбъектовXDTO);
	
КонецФункции

// Только для внутреннего использования
Функция ПолучитьПользователейСервиса(Знач ПарольПользователяСервиса) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса(ПарольПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
	ИнформацияОбОшибке = Неопределено;
	СписокПользователей = Прокси.GetUsersList(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), );
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("УникальныйИдентификатор"));
	Результат.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	Результат.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	Результат.Колонки.Добавить("Доступ", Новый ОписаниеТипов("Булево"));
	
	Для каждого ИнформацияОПользователе Из СписокПользователей.Item Цикл
		СтрокаПользователя = Результат.Добавить();
		СтрокаПользователя.Идентификатор = ИнформацияОПользователе.UserServiceID;
		СтрокаПользователя.Имя = ИнформацияОПользователе.Name;
		СтрокаПользователя.ПолноеИмя = ИнформацияОПользователе.FullName;
		СтрокаПользователя.Доступ = ИнформацияОПользователе.Access;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования
Процедура ПредоставитьДоступПользователюСервиса(Знач ИдентификаторПользователяСервиса, Знач ПарольПользователяСервиса) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Прокси = РаботаВМоделиСервиса.ПолучитьПроксиМенеджераСервиса(ПарольПользователяСервиса);
	УстановитьПривилегированныйРежим(Ложь);
	
	ИнформацияОбОшибке = Неопределено;
	Прокси.GrantUserAccess(
		ОбщегоНазначения.ЗначениеРазделителяСеанса(),
		ИдентификаторПользователяСервиса, 
		ИнформацияОбОшибке);
	РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(ИнформацияОбОшибке);
	
КонецПроцедуры

// Только для внутреннего использования
Процедура АннулироватьДоступПользователяСервиса(ПользовательОбъект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПользовательОбъект.ИдентификаторПользователяСервиса) Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияУправленияПриложениямиИнтерфейс.СообщениеАннулироватьДоступПользователя());
		
		Сообщение.Body.Zone = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		Сообщение.Body.UserServiceID = ПользовательОбъект.ИдентификаторПользователяСервиса;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервисаПовтИсп.КонечнаяТочкаМенеджераСервиса());
			
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ИдентификаторСервисаТекущегоПользователя()
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователи.ТекущийПользователь(), "ИдентификаторПользователяСервиса");
	
КонецФункции

Функция НовыеДействияСПользователемСервиса()
	
	ДействияСПользователемСервиса = Новый Структура;
	ДействияСПользователемСервиса.Вставить("ИзменениеПароля", Ложь);
	ДействияСПользователемСервиса.Вставить("ИзменениеИмени", Ложь);
	ДействияСПользователемСервиса.Вставить("ИзменениеПолногоИмени", Ложь);
	ДействияСПользователемСервиса.Вставить("ИзменениеДоступа", Ложь);
	ДействияСПользователемСервиса.Вставить("ИзменениеАдминистративногоДоступа", Ложь);
	
	ДействияСКИ = Новый Соответствие;
	Для каждого КлючИЗначение Из РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИПользователяXDTO() Цикл
		ДействияСКИ.Вставить(КлючИЗначение.Ключ, Новый Структура("Изменение", Ложь));
	КонецЦикла;
	ДействияСПользователемСервиса.Вставить("КонтактнаяИнформация", ДействияСКИ); // Ключ - ВидКИ, Значение - Структура с правами
	
	Возврат ДействияСПользователемСервиса;
	
КонецФункции

Функция ПодготовитьОбъектыДоступаПользователя(Фабрика, Пользователь)
	
	ИнформацияПользователя = Фабрика.Создать(
		Фабрика.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "User"));
	ИнформацияПользователя.Zone = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
	ИнформацияПользователя.UserServiceID = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяСервиса");
	
	СписокОбъектов = Фабрика.Создать(
		Фабрика.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "ObjectsList"));
		
	СписокОбъектов.Item.Добавить(ИнформацияПользователя);
	
	ТипКИПользователя = Фабрика.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "UserContact");
	
	Для каждого КлючИЗначение Из РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИПользователяXDTO() Цикл
		ВидКИ = Фабрика.Создать(ТипКИПользователя);
		ВидКИ.UserServiceID = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяСервиса");
		ВидКИ.ContactType = КлючИЗначение.Значение;
		СписокОбъектов.Item.Добавить(ВидКИ);
	КонецЦикла;
	
	Возврат СписокОбъектов;
	
КонецФункции

Функция ПраваДоступаОбъектовXDTOВДействияСПользователемСервиса(Фабрика, ПраваДоступаОбъектовXDTO)
	
	ТипИнформацияПользователя = Фабрика.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "User");
	ТипКИПользователя = Фабрика.Тип("http://www.1c.ru/SaaS/ApplicationAccess", "UserContact");
	
	ДействияСПользователемСервиса = НовыеДействияСПользователемСервиса();
	ДействияСКИ = ДействияСПользователемСервиса.КонтактнаяИнформация;
	
	Для каждого ПраваДоступаОбъектаXDTO из ПраваДоступаОбъектовXDTO.Item Цикл
		
		Если ПраваДоступаОбъектаXDTO.Object.Тип() = ТипИнформацияПользователя Тогда
			
			Для каждого ЭлементСпискаПрав Из ПраваДоступаОбъектаXDTO.AccessRights.Item Цикл
				ДействиеСПользователем = РаботаВМоделиСервисаПовтИсп.
					СоответствиеПравXDTOДействиямСПользователемСервиса().Получить(ЭлементСпискаПрав.AccessRight);
				ДействияСПользователемСервиса[ДействиеСПользователем] = Истина;
			КонецЦикла;
			
		ИначеЕсли ПраваДоступаОбъектаXDTO.Object.Тип() = ТипКИПользователя Тогда
			ВидКИ = РаботаВМоделиСервисаПовтИсп.СоответствиеВидовКИXDTOВидамКИПользователя().Получить(
				ПраваДоступаОбъектаXDTO.Object.ContactType);
			Если ВидКИ = Неопределено Тогда
				ШаблонСообщения = НСтр("ru = 'Получен неизвестный вид контактной информации: %1'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонСообщения, ПраваДоступаОбъектаXDTO.Object.ContactType);
				ВызватьИсключение(ТекстСообщения);
			КонецЕсли;
			
			ДействияСВидомКИ = ДействияСКИ[ВидКИ];
			
			Для каждого ЭлементСпискаПрав Из ПраваДоступаОбъектаXDTO.AccessRights.Item Цикл
				Если ЭлементСпискаПрав.AccessRight = "Change" Тогда
					ДействияСВидомКИ.Изменение = Истина;
				КонецЕсли;
			КонецЦикла;
		Иначе
			ШаблонСообщения = НСтр("ru = 'Получен неизвестный тип объектов доступа: %1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, ОбщегоНазначения.ПредставлениеТипаXDTO(ПраваДоступаОбъектаXDTO.Object.Тип()));
			ВызватьИсключение(ТекстСообщения);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДействияСПользователемСервиса;
	
КонецФункции

Функция ПолучитьКодЯзыка(Знач Язык)
	
	Если Язык = Неопределено Тогда
		Возврат "";
	Иначе
		Возврат Язык.КодЯзыка;
	КонецЕсли;
	
КонецФункции
