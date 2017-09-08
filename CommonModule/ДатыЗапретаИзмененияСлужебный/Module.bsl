﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ДатыЗапретаИзмененияСлужебный");
		
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииОбработчиковУстановкиПараметровСеанса"].Добавить(
		"ДатыЗапретаИзмененияСлужебный");
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий\ПриПолученииСпискаШаблонов"].Добавить(
			"ДатыЗапретаИзмененияСлужебный");
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаДанных") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.РаботаВМоделиСервиса.ВыгрузкаЗагрузкаДанных\ПриОпределенииСтандартныхТиповОбщихПредопределенныхДанных"].Добавить(
			"ДатыЗапретаИзмененияСлужебный");
	КонецЕсли;
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.12";
	Обработчик.Процедура = "ДатыЗапретаИзмененияСлужебный.ЗаменитьНеопределеноНаЗначениеПеречисления";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.3.2";
	Обработчик.Процедура = "ДатыЗапретаИзмененияСлужебный.УдалитьПустыеДатыЗапретаПоУмолчанию";
	
КонецПроцедуры

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("ПропуститьПроверкуЗапретаИзменения",    "ДатыЗапретаИзмененияСлужебный.УстановкаПараметровСеанса");
	
КонецПроцедуры

// Обработчик события ПриПолученииСпискаШаблонов.
//
// Формирует список шаблонов заданий очереди.
//
// Параметры:
//  Шаблоны - Массив строк. В параметр следует добавить имена предопределенных
//   неразделенных регламентных заданий, которые должны использоваться в качестве
//   шаблонов для заданий очереди.
//
Процедура ПриПолученииСпискаШаблонов(Шаблоны) Экспорт
	
	Шаблоны.Добавить("ПересчетТекущихЗначенийОтносительныхДатЗапретаИзменения");
	
КонецПроцедуры

// Заполняет массив типов неразделенных данных, всегда содержащих только предопределенные элементы.
// Он используется при обновлении ссылок при загрузке-выгрузке данных.
// 
// Параметры:
//  МассивТипов - массив
//
Процедура ПриОпределенииСтандартныхТиповОбщихПредопределенныхДанных(МассивТипов) Экспорт
	
	МассивТипов.Добавить(Тип("ПланВидовХарактеристикСсылка.РазделыДатЗапретаИзменения"));
	
КонецПроцедуры

// Содержит настройки размещения вариантов отчетов в панели отчетов.
//
// Параметры:
//   Настройки (Коллекция) Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации()
//
// Описание:
//   В данной процедуре необходимо указать каким именно образом предопределенные варианты отчетов
//   будут регистрироваться в программе и показываться в панели отчетов.
//
// Вспомогательные функции:
//   НастройкиОтчета   = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.<ИмяОтчета>);
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//
//   Данные функции получают соответственно настройки отчета и настройки варианта отчета следующей структуры:
//       |- Включен (Булево)
//            Если Ложь, то вариант отчета не регистрируется в подсистеме.
//              Используется для удаления технических и контекстных вариантов отчетов из всех интерфейсов.
//              Эти варианты отчета по прежнему можно открывать в форме отчета программно при помощи
//              параметров открытия (см. справку по "Расширение управляемой формы для отчета.КлючВарианта").
//       |- ВидимостьПоУмолчанию (Булево)
//            Если Ложь, то вариант отчета по умолчанию скрыт в панели отчетов.
//              Пользователь может "включить" его в режиме настройки панели отчетов
//              или открыть через форму "Все отчеты".
//       |- Описание (Строка)
//            Дополнительная информация по варианту отчета.
//              В панели отчетов выводится в качестве подсказки.
//              Должно расшифровывать для пользователя содержимое варианта отчета
//              и не должно дублировать наименование варианта отчета.
//       |- Размещение (Соответствие) Настройки размещения варианта отчета в разделах
//           |- Ключ     (ОбъектМетаданных) Подсистема, в которой размещается отчет или вариант отчета
//           |- Значение (Строка)           Необязательный. Настройки размещения в подсистеме.
//               |- ""        - Выводить отчет в своей группе обычным шрифтом.
//               |- "Важный"  - Выводить отчет в своей группе жирным шрифтом.
//               |- "СмТакже" - Выводить отчет в группе "См. также".
//       |- ФункциональныеОпции (Массив) из (Строка)
//            Имена функциональных опций варианта отчета.
//
// Например:
//
//  (1) Добавить в подсистему вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  (2) Отключить вариант отчета.
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "ИмяВарианта1");
//	Вариант.Включен = Ложь;
//
//  (3) Отключить все варианты отчета, кроме требуемого.
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Включен = Ложь;
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта");
//	Вариант.Включен = Истина;
//
//  (4) Результат исполнения 4.1 и 4.2 будет одинаковым:
//  (4.1)
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	Вариант = ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Вариант.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  (4.2)
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	Отчет.Размещение.Удалить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта1");
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта2");
//	ВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, "ИмяВарианта3");
//	Отчет.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
// Важно:
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета. См. примеры 3 и 4.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции вариантов объединяются с функциональными опциями отчетов по следующим правилам:
//     (ФункциональнаяОпция1Отчета ИЛИ ФункциональнаяОпция2Отчета) И (ФункциональнаяОпция3Варианта ИЛИ ФункциональнаяОпция4Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов этого отчета.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	
	Свойства = ДатыЗапретаИзмененияПовтИсп.СвойстваРазделов();
	
	МодульВариантыОтчетов = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ВариантыОтчетов");
	
	// Установка используемых вариантов отчета ДатыЗапретаИзменения.
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДатыЗапретаИзменения);
	Отчет.Включен = Ложь;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаИзмененияПоРазделамОбъектамДляПользователей";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаИзмененияПоРазделамДляПользователей";
	Иначе
		УстановитьВариант = "ДатыЗапретаИзмененияПоОбъектамДляПользователей";
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаИзмененияПоПользователям";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаИзмененияПоПользователямБезОбъектов";
	Иначе
		УстановитьВариант = "ДатыЗапретаИзмененияПоПользователямБезРазделов";
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	
	// Установка используемых вариантов отчета ДатыЗапретаЗагрузки.
	Отчет = МодульВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ДатыЗапретаЗагрузки);
	Отчет.Включен = Ложь;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоРазделамОбъектамДляПользователей";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоРазделамДляПользователей";
	Иначе
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоОбъектамДляПользователей";
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователям";
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователямБезОбъектов";
	Иначе
		УстановитьВариант = "ДатыЗапретаЗагрузкиПоПользователямБезРазделов";
	КонецЕсли;
	Вариант = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, Отчет, УстановитьВариант);
	Вариант.Включен = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов из других подсистем

// Отключает или включает проверку запрета изменения на текущий сеанс
//
Процедура ПропуститьПроверкуЗапретаИзменения(Пропустить = Истина) Экспорт
	
	ПараметрыСеанса.ПропуститьПроверкуЗапретаИзменения = Пропустить;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выполняет пересчет и обновление текущий значений относительных
// дат запрета по состоянию на текущую дату сеанса.
//
// Параметры:
//  ЗаписатьОписаниеРезультатаВЖурналРегистрации - Булево.
//  ОписаниеРезультата - Строка.
//
Процедура ПересчитатьТекущиеЗначенияОтносительныхДатЗапрета(ЗаписатьОписаниеРезультатаВЖурналРегистрации = Истина, ОписаниеРезультата = "") Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДатыЗапретаИзменения.Пользователь,
	|	ДатыЗапретаИзменения.ДатаЗапрета,
	|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекущаяДатаНаСервере = НачалоДня(ТекущаяДатаСеанса());
	МенеджерЗаписи = РегистрыСведений.ДатыЗапретаИзменения.СоздатьМенеджерЗаписи();
	ПредставлениеОшибки = "";
	Отказ = Ложь;
	ЕстьОбновленныеДаты = Ложь;
	НетОтносительныхДат = Истина;
	
	Пока Выборка.Следующий() Цикл
		РассчитаннаяДатаЗапрета = РассчитатьДатуЗапретаПоОписанию(
			ТекущаяДатаНаСервере, Выборка.ОписаниеДатыЗапрета);
		
		Если ЗначениеЗаполнено(РассчитаннаяДатаЗапрета) Тогда
			НетОтносительныхДат = Ложь;
			
			Если Выборка.ДатаЗапрета <> РассчитаннаяДатаЗапрета Тогда
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Выборка);
				
				Блокировка = Новый БлокировкаДанных;
				ЭлементБлокировки = Блокировка.Добавить();
				ЭлементБлокировки.Область = "РегистрСведений.ДатыЗапретаИзменения";
				ЭлементБлокировки.УстановитьЗначение("Раздел",       Выборка.Раздел);
				ЭлементБлокировки.УстановитьЗначение("Объект",       Выборка.Объект);
				ЭлементБлокировки.УстановитьЗначение("Пользователь", Выборка.Пользователь);
				ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
				
				НачатьТранзакцию();
				Попытка
					Блокировка.Заблокировать();
					МенеджерЗаписи.Прочитать();
					Если МенеджерЗаписи.Выбран() Тогда
						Если Выборка.ОписаниеДатыЗапрета <> МенеджерЗаписи.ОписаниеДатыЗапрета Тогда
							РассчитаннаяДатаЗапрета = РассчитатьДатуЗапретаПоОписанию(
								ТекущаяДатаНаСервере, МенеджерЗаписи.ОписаниеДатыЗапрета);
						КонецЕсли;
						Если ЗначениеЗаполнено(РассчитаннаяДатаЗапрета) Тогда
							МенеджерЗаписи.ДатаЗапрета = РассчитаннаяДатаЗапрета;
							МенеджерЗаписи.Записать();
							ЕстьОбновленныеДаты = Истина;
						КонецЕсли;
					КонецЕсли;
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
					Отказ = Истина;
					ПредставлениеОшибки = ПредставлениеОшибки + Символы.ПС + Символы.ПС +
						КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если НетОтносительныхДат Тогда
		ОписаниеРезультата = НСтр("ru = 'Относительные даты запрета не заданы.'");
		
	ИначеЕсли Отказ Тогда
		Если ЕстьОбновленныеДаты Тогда
			ОписаниеРезультата =
				НСтр("ru = 'Пересчитаны некоторые текущие значения относительных дат запрета.
				           |При пересчете возникли ошибки:'");
		Иначе
			ОписаниеРезультата =
				НСтр("ru = 'Не пересчитаны текущие значения дат запрета.
				           |При пересчете возникли ошибки:'");
		КонецЕсли;
		ОписаниеРезультата = ОписаниеРезультата + ПредставлениеОшибки;
	Иначе
		Если ЕстьОбновленныеДаты Тогда
			ОписаниеРезультата =
				НСтр("ru = 'Успешно пересчитаны текущие значения относительных дат запрета.'");
		Иначе
			ОписаниеРезультата =
				НСтр("ru = 'Сегодня уже пересчитаны текущие значения относительных дат запрета.'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗаписатьОписаниеРезультатаВЖурналРегистрации Тогда
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Даты запрета изменения.Пересчет относительных дат'",
			     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			?(Отказ, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация),
			,
			,
			ОписаниеРезультата,
			РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	КонецЕсли;
	
	Если Отказ Тогда
		ВызватьИсключение
			НСтр("ru = 'Не удалось пересчитать все относительные даты запрета.
			           |Подробности в журнале регистрации.'");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик регламентного задания ПересчетТекущихЗначенийОтносительныхДатЗапретаИзменения.
Процедура ПересчетТекущихЗначенийОтносительныхДатЗапретаИзменения() Экспорт
	
	Если ПустаяСтрока(ИмяПользователя()) Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ПересчитатьТекущиеЗначенияОтносительныхДатЗапрета();
	
КонецПроцедуры

// Ищет даты запрета изменения/загрузки данных для объектов типа:
//  СправочникОбъект,
//  ПланВидовХарактеристикОбъект,
//  ПланСчетовОбъект,
//  ПланВидовРасчетаОбъект,
//  БизнесПроцессОбъект,
//  ЗадачаОбъект,
//  ПланОбменаОбъект,
//  ДокументОбъект,
//  РегистрСведенийНаборЗаписей,
//  РегистрНакопленияНаборЗаписей,
//  РегистрБухгалтерииНаборЗаписей,
//  РегистрРасчетаНаборЗаписей.
//
// Параметры:
//  Источник             - один из типов, указанных выше.
//
//  Отказ                - Булево (возвращаемое значение), будет установлено Истина,
//                         если объект не проходит проверки дат запрета.
//
//  ИсточникРегистр      - Булево - Ложь - Источник является регистром, иначе объектом.
//
//  Замещение            - Булево - если источник является регистром и выполняется добавление,
//                         нужно указать Ложь.
//
//  Удаление             - Булево - если источник является объектом и выполняется удаление объекта,
//                         нужно указать Истина.
//
//  СообщитьОЗапрете     - Булево, если Истина, будет отправлено сообщение пользователю
//                         о запрете изменения данных.
//
//  СтандартнаяОбработка - Булево, если Ложь, проверка запрета изменения (для пользователей)
//                         будет пропущена.
//
//  УзелПланаОбмена      - Неопределено, ПланыОбменаСсылка.<Имя плана обмена> -
//                         если задать узел будет выполнена проверка запрета загрузки.
//
//  НайденныеЗапреты     - Структура (возвращаемое значение).
//                         Если найден запрет изменения данных, значит есть
//                         свойство НайденЗапретИзмененияДанных, если найден запрет
//                         загрузки данных, значит есть свойство НайденЗапретЗагрузкиДанных.
//
Процедура ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник,
		Отказ,
		ИсточникРегистр      = Ложь,
		Замещение            = Истина,
		Удаление             = Ложь,
		СообщитьОЗапрете     = Истина,
		СтандартнаяОбработка = Истина,
		УзелПланаОбмена      = Неопределено,
		НайденныеЗапреты     = Неопределено) Экспорт
	
	Если ПропуститьПроверкуДатЗапрета(
	         Источник,
	         СообщитьОЗапрете,
	         СтандартнаяОбработка,
	         УзелПланаОбмена) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ИсточникРегистр
	   И НЕ Источник.ЭтоНовый()
	   И НЕ Удаление Тогда
		
		Если ИзменениеИлиЗагрузкаЗапрещена(
				Источник,
				Источник.Ссылка,
				СообщитьОЗапрете,
				СтандартнаяОбработка,
				УзелПланаОбмена,
				НайденныеЗапреты) Тогда
			
			Отказ = Истина;
		КонецЕсли;
		
	ИначеЕсли ИсточникРегистр И Замещение Тогда
		
		Если ИзменениеИлиЗагрузкаЗапрещена(
				Источник,
				Источник.Отбор,
				СообщитьОЗапрете,
				СтандартнаяОбработка,
				УзелПланаОбмена,
				НайденныеЗапреты) Тогда
			
			Отказ = Истина;
		КонецЕсли;
	Иначе
		//     НЕ ИсточникРегистр И Источник.ЭтоНовый()
		// ИЛИ    ИсточникРегистр И НЕ Замещение
		// ИЛИ НЕ ИсточникРегистр И Удаление
		Если ИзменениеИлиЗагрузкаЗапрещена(
				Источник,
				,
				СообщитьОЗапрете,
				СтандартнаяОбработка,
				УзелПланаОбмена,
				НайденныеЗапреты) Тогда
			
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет необходимость проверки запрета изменения или загрузки данных.
Функция ПропуститьПроверкуДатЗапрета(Источник,
                                     СообщитьОЗапрете,
                                     СтандартнаяОбработка,
                                     УзелПланаОбмена) Экспорт
	
	Если Источник.ДополнительныеСвойства.Свойство("ПропуститьПроверкуЗапретаИзменения") Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ВыполняетсяОтложеннаяОбработкаДанных() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЗапретИзмененияДанныхНеИспользуется() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ОбновлениеИнформационнойБазы.ВыполняетсяОбновлениеИнформационнойБазы() Тогда
		Возврат Истина;
	КонецЕсли;
	
	ДатыЗапретаИзмененияПереопределяемый.ПередПроверкойЗапретаИзменения(
		Источник, СтандартнаяОбработка, УзелПланаОбмена, СообщитьОЗапрете);
	
	Возврат НЕ СтандартнаяОбработка          // НЕ проверять запрет изменения.
	      И УзелПланаОбмена = Неопределено;  // НЕ проверять запрет загрузки.
	
КонецФункции

// Общая функция для поиска запретов изменения и загрузки данных.
Функция ИзменениеИлиЗагрузкаЗапрещена(
		Данные,
		ИдентификаторДанных  = Неопределено,
		СообщитьОЗапрете     = Истина,
		СтандартнаяОбработка = Истина,
		УзелПланаОбмена      = Неопределено,
		НайденныеЗапреты     = Неопределено) Экспорт
	
	ДанныеДляПроверки = Новый Структура;
	ДанныеДляПроверки.Вставить("Таблица",                Данные);
	ДанныеДляПроверки.Вставить("ИдентификаторДанных",    ИдентификаторДанных);
	ДанныеДляПроверки.Вставить("ЗначенияПолейИзОбъекта", Неопределено);
	
	Если ТипЗнч(Данные) <> Тип("Строка") Тогда
		ДанныеДляПроверки.Таблица = Данные.Метаданные().ПолноеИмя();
		ДанныеДляПроверки.ЗначенияПолейИзОбъекта = ИзвлечьЗначенияПолейИзОбъекта(Данные);
	КонецЕсли;
	
	НайденныеЗапреты = Неопределено;
	ЗапретНайден = ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(
		ДанныеДляПроверки, СообщитьОЗапрете, , СтандартнаяОбработка, УзелПланаОбмена, НайденныеЗапреты);
	
	// Устарело. Оставлено для обратной совместимости, начиная с версии 2.1.2.15,
	// так как было заявлено в документации без уточнения, но требовалось
	// только для взаимодействия при обмене данными.
	Если ЗапретНайден И ТипЗнч(Данные) <> Тип("Строка") Тогда
		Для каждого КлючИЗначение Из НайденныеЗапреты Цикл
			Данные.ДополнительныеСвойства.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗапретНайден;
	
КонецФункции

// Только для внутреннего использования.
Функция ПолучитьПоляРегистра(ИсточникиДанных, Таблица) Экспорт
	
	ПоляРегистра = ",";
	
	Для каждого ИсточникДанных Из ИсточникиДанных Цикл
		
		Поля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
			ИсточникДанных.ПолеДаты, ".");
		
		Если Поля.Количество() = 0 Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для проверки запрета изменения 
				           |в источнике данных для таблицы ""%1""
				           |не задано поле даты.'"),
				Таблица));
		ИначеЕсли НЕ ЗначениеЗаполнено(Поля[0]) Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для проверки запрета изменения 
				           |в источнике данных для таблицы ""%1""
				           |неверно задано поле даты: %2.'"),
				Таблица,
				ИсточникДанных.ПолеДаты));
		КонецЕсли;
		Если Найти(ПоляРегистра, "," + Поля[0] + ",") = 0 Тогда
			ПоляРегистра = ПоляРегистра + Поля[0] + ",";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИсточникДанных.ПолеОбъекта) Тогда
			
			Поля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
				ИсточникДанных.ПолеОбъекта, ".");
			
			Если НЕ ЗначениеЗаполнено(Поля[0]) Тогда
				ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Для проверки запрета изменения 
					           |в источнике данных для таблицы ""%1""
					           |неверно задано поле объекта: %2.'"),
					Таблица,
					ИсточникДанных.ПолеОбъекта));
			КонецЕсли;
			Если Найти(ПоляРегистра, "," + Поля[0] + ",") = 0 Тогда
				ПоляРегистра = ПоляРегистра + Поля[0] + ",";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Сред(ПоляРегистра, 2, СтрДлина(ПоляРегистра)-2);
	
КонецФункции

// Только для внутреннего использования.
Функция ПолучитьСтруктуруПолейОбъекта(ОбъектМетаданных, ИсточникиДанных, Таблица) Экспорт
	
	СтруктураПолей = Новый Структура;
	
	Для каждого ИсточникДанных Из ИсточникиДанных Цикл
		
		ДобавитьПоле(ОбъектМетаданных,
		             ИсточникДанных,
		             СтруктураПолей,
		             ИсточникДанных.ПолеДаты,
		             Таблица,
		             НСтр("ru = 'поле даты'"));
		
		Если ЗначениеЗаполнено(ИсточникДанных.ПолеОбъекта) Тогда
			
			ДобавитьПоле(ОбъектМетаданных,
			             ИсточникДанных,
			             СтруктураПолей,
			             ИсточникДанных.ПолеОбъекта,
			             Таблица,
			             НСтр("ru = 'поле объекта'"));
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураПолей;
	
КонецФункции

// Устанавливает параметры сеанса подсистемы обмена данными
//
// Параметры:
//  ИмяПараметра - Строка - имя параметра сеанса, значение которого необходимо установить
//  УстановленныеПараметры - массив - в данный параметр помещается информация об установленных параметрах сеанса
// 
Процедура УстановкаПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	
	ПараметрыСеанса.ПропуститьПроверкуЗапретаИзменения = Ложь;
	УстановленныеПараметры.Добавить("ПропуститьПроверкуЗапретаИзменения");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Обработчик обновления выполняет замену значения Неопределено
// измерения Пользователь регистра сведений ДатыЗапретаИзменения
// на значение Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей.
//
Процедура ЗаменитьНеопределеноНаЗначениеПеречисления() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборЗаписей = РегистрыСведений.ДатыЗапретаИзменения.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Пользователь.Установить(Неопределено);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		Таблица = НаборЗаписей.Выгрузить();
		НаборЗаписей.Отбор.Пользователь.Установить(Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей);
		Таблица.ЗаполнитьЗначения(Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей, "Пользователь");
		НаборЗаписей.Загрузить(Таблица);
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик обновления выполняет удаление пустых дат запрета заданных
// для всех пользователей или всех планов обмена, т.е. "По умолчанию",
// т.к. по умолчанию даты запрета пустые.
//
Процедура УдалитьПустыеДатыЗапретаПоУмолчанию() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПустаяДата", '00000000');
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДатыЗапретаИзменения.Пользователь
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|ГДЕ
	|	ДатыЗапретаИзменения.Пользователь В (ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей), ЗНАЧЕНИЕ(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз))
	|	И ДатыЗапретаИзменения.ДатаЗапрета = &ПустаяДата
	|	И ДатыЗапретаИзменения.ОписаниеДатыЗапрета = """"";
	
	Выгрузка = Запрос.Выполнить().Выгрузить();
	
	Если Выгрузка.Количество() > 0 Тогда
		МенеджерЗаписи = РегистрыСведений.ДатыЗапретаИзменения.СоздатьМенеджерЗаписи();
		НачатьТранзакцию();
		Попытка
			Для каждого Строка Из Выгрузка Цикл
				ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Строка);
				МенеджерЗаписи.Прочитать();
				Если МенеджерЗаписи.Выбран() Тогда
					МенеджерЗаписи.Записать();
				КонецЕсли;
			КонецЦикла;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция РассчитатьДатуЗапретаПоОписанию(ТекущаяДатаНаСервере, ОписаниеДатыЗапрета)
	
	Сутки = 60*60*24;
	ВариантДатыЗапрета = "";
	КоличествоДнейРазрешения = 0;
	
	Если ЗначениеЗаполнено(ОписаниеДатыЗапрета) Тогда
		ВариантДатыЗапрета = СтрПолучитьСтроку(ОписаниеДатыЗапрета, 1);
		Строка2            = СтрПолучитьСтроку(ОписаниеДатыЗапрета, 2);
		Если ЗначениеЗаполнено(Строка2) Тогда
			Попытка
				КоличествоДнейРазрешения = Число(Строка2);
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	Если ВариантДатыЗапрета = "КонецПрошлогоГода" Тогда
		ТекущаяДатаЗапрета    = НачалоГода(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоГода(ТекущаяДатаЗапрета) - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлогоКвартала" Тогда
		ТекущаяДатаЗапрета    = НачалоКвартала(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоКвартала(ТекущаяДатаЗапрета) - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлогоМесяца" Тогда
		ТекущаяДатаЗапрета    = НачалоМесяца(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоМесяца(ТекущаяДатаЗапрета) - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлойНедели" Тогда
		ТекущаяДатаЗапрета    = НачалоНедели(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоНедели(ТекущаяДатаЗапрета) - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "ПредыдущийДень" Тогда
		ТекущаяДатаЗапрета    = НачалоДня(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоДня(ТекущаяДатаЗапрета) - Сутки;
	Иначе
		ТекущаяДатаЗапрета    = '00000000';
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяДатаЗапрета) Тогда
		СрокРазрешения = ТекущаяДатаЗапрета + КоличествоДнейРазрешения * Сутки;
		Если НЕ ТекущаяДатаНаСервере > СрокРазрешения Тогда
			ТекущаяДатаЗапрета = ПредыдущаяДатаЗапрета;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекущаяДатаЗапрета;
	
КонецФункции

Функция ЗапретИзмененияДанныхНеИспользуется()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбновлениеИнформационнойБазыСлужебныйПовтИсп.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения";
	НеИспользуется = Запрос.Выполнить().Пустой();
	
	Возврат НеИспользуется;
	
КонецФункции

Функция ИзвлечьЗначенияПолейИзОбъекта(Знач Данные)
	
	ЗначенияПолей = Новый Структура;
	ОбъектМетаданных = Данные.Метаданные();
	Отбор = Новый Структура("Таблица", ОбъектМетаданных.ПолноеИмя());
	ИсточникиДанных = ПолучитьИсточникиДанных(Отбор);
	
	Если ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		// Заполнение значений полей из набора записей.
		ПоляРегистра = ПолучитьПоляРегистра(ИсточникиДанных, Отбор.Таблица);
		ЗначенияПолей = Данные.Выгрузить(, ПоляРегистра);
		ЗначенияПолей.Свернуть(ПоляРегистра);
	Иначе
		// Заполнение значений полей из объекта.
		ЗначенияПолей = ПолучитьСтруктуруПолейОбъекта(ОбъектМетаданных, ИсточникиДанных, Отбор.Таблица);
		Для каждого Поле Из ЗначенияПолей Цикл
			Если ОбъектМетаданных.ТабличныеЧасти.Найти(Поле.Ключ) <> Неопределено Тогда
				Поля = Поле.Значение;
				ЗначенияПолей[Поле.Ключ] = Данные[Поле.Ключ].Выгрузить(, Поля);
				ЗначенияПолей[Поле.Ключ].Свернуть(Поля);
			Иначе
				ЗначенияПолей[Поле.Ключ] = Данные[Поле.Ключ];
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ЗначенияПолей;
	
КонецФункции

Функция ПолучитьИсточникиДанных(Отбор)
	
	ИсточникиДанныхТаблиц = ДатыЗапретаИзмененияПовтИсп.ИсточникиДанныхДляПроверкиЗапретаИзменения();
	
	ИсточникиДанных = ИсточникиДанныхТаблиц.НайтиСтроки(Отбор);
	
	Если ИсточникиДанных.Количество() = 0 Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для проверки запрета изменения не найдены
			           |источники данных для таблицы ""%1"".'"),
			Отбор.Таблица));
	КонецЕсли;
	
	Возврат ИсточникиДанных;
	
КонецФункции

Процедура ДобавитьПоле(ОбъектМетаданных,
                       ИсточникДанных,
                       СтруктураПолей,
                       Поле,
                       Таблица,
                       ВидПоляДляСообщений)
	
	Поля = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Поле, ".");
	Если Поля.Количество() = 0 Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для проверки запрета изменения 
			           |в источнике данных для таблицы ""%1""
			           |не задано %2.'"),
			Таблица,
			ВидПоляДляСообщений));
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Поля[0]) Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для проверки запрета изменения 
			           |в источнике данных для таблицы ""%1""
			           |неверно задано %2: ""%3""'"),
			Таблица,
			ВидПоляДляСообщений,
			Поле));
	КонецЕсли;
	
	Если НЕ СтруктураПолей.Свойство(Поля[0]) Тогда
		СтруктураПолей.Вставить(Поля[0]);
	КонецЕсли;
	
	Если ОбъектМетаданных.ТабличныеЧасти.Найти(Поля[0]) <> Неопределено Тогда
		Если Поля.Количество() = 1 Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для проверки запрета изменения 
				           |в источнике данных для таблицы ""%1""
				           |неверно задано %2:
				           |не задано поле заданной табличной части ""%3"".'"),
				Таблица,
				ВидПоляДляСообщений,
				Поле));
		ИначеЕсли НЕ ЗначениеЗаполнено(Поля[1]) Тогда
			ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Для проверки запрета изменения 
				           |в источнике данных для таблицы ""%1""
				           |неверно задано %2:
				           |неверно задано поле заданной табличной части ""%3"".'"),
				Таблица,
				ВидПоляДляСообщений,
				Поле));
		КонецЕсли;
		Если СтруктураПолей[Поля[0]] = Неопределено Тогда
			СтруктураПолей[Поля[0]] = Поля[1];
		Иначе
			СтруктураПолей[Поля[0]] = СтруктураПолей[Поле] + "," + Поля[1];
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВыполняетсяОтложеннаяОбработкаДанных()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПропуститьПроверкуЗапретаИзменения;
	
КонецФункции