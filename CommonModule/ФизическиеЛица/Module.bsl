﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Физические лица"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует фамилию и инициалы либо по наименованию элемента справочника ФизическиеЛица,
// либо по переданным строкам.
// Если передан Объект, то извлеченная из него строка считается совокупностью 
// Фамилия + Имя + Отчество, разделенными пробелами.
//
// Параметры
//  ОбъектИлиСтрока - строка, ссылка или объект элемента справочника ФизическиеЛица.
//  Фамилия		    - фамилия физического лица.
//  Имя		        - имя физического лица.
//  Отчество	    - отчество физического лица.
//
// Возвращаемое значение 
//  Строка - фамилия и инициалы одной строкой. 
//  В параметрах Фамилия, Имя и Отчество записываются вычисленные части.
//
// Пример:
//  Результат = ФамилияИнициалыФизЛица("Иванов Иван Иванович"); // Результат = "Иванов И. И."
//
Функция ФамилияИнициалыФизЛица(ОбъектИлиСтрока = "", Фамилия = " ", Имя = " ", Отчество = " ") Экспорт

	ТипОбъекта = ТипЗнч(ОбъектИлиСтрока);
	Если ТипОбъекта = Тип("Строка") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока), " ");
	ИначеЕсли ТипОбъекта = Тип("СправочникСсылка.ФизическиеЛица") Или ТипОбъекта = Тип("СправочникОбъект.ФизическиеЛица") Тогда
		ФИО = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СокрЛП(ОбъектИлиСтрока.Наименование), " ");
	Иначе
		// используем возможно переданные отдельные строки
		Возврат ?(Не ПустаяСтрока(Фамилия), 
		          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество,1) + ".", ""), ""),
		          "")
	КонецЕсли;
	
	КоличествоПодстрок = ФИО.Количество();
	Фамилия            = ?(КоличествоПодстрок > 0, ФИО[0], "");
	Имя                = ?(КоличествоПодстрок > 1, ФИО[1], "");
	Отчество           = ?(КоличествоПодстрок > 2, ФИО[2], "");
	
	Возврат ?(Не ПустаяСтрока(Фамилия), 
	          Фамилия + ?(Не ПустаяСтрока(Имя), " " + Лев(Имя,1) + "." + ?(Не ПустаяСтрока(Отчество), Лев(Отчество, 1) + ".", ""), ""),
	          "");
	
КонецФункции

// Функция склоняет переданную фразу
// Параметры:
//  ФИО (обязательный), тип строка
//   Параметр должен содержать фамилию имя отчества в именительном падеже, которые необходимо просклонять.
//
//  Падеж (обязательный), тип число
//   Падеж, в который необходимо поставить ФИО.
//   1 - Именительный
//   2 - Родительный
//   3 - Дательный
//   4 - Винительный
//   5 - Творительный
//   6 - Предложный
//
//  Результат (обязательный), тип строка
//   Переменная, в которую будет возвращен результат склонения.
//
//  Пол (необязательный), тип Перечисление.ПолФизическогоЛица
//   Пол физического лица
//
Функция Просклонять(Знач ФИО, Падеж, Результат, Пол = Неопределено) Экспорт
	
	ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаСклоненияФИО", "Decl");
	Компонента = Новый("AddIn.Decl.CNameDecl");
	
	Результат = "";
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИО, " ");
	
	// Выделим первые 3 слова, так как компонента не умеет склонять фразу большую 3х символов
	НомерНесклоняемогоСимвола = 4;
	Для Номер = 1 По Мин(МассивСтрок.Количество(), 3) Цикл
		Если Не ФизическиеЛицаКлиентСервер.ФИОНаписаноВерно(МассивСтрок[Номер-1], Истина) Тогда
			НомерНесклоняемогоСимвола = Номер;
			Прервать;
		КонецЕсли;

		Результат = Результат + ?(Номер > 1, " ", "") + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Если ПустаяСтрока(Результат) Тогда
		Результат = ФИО;
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если Пол = Перечисления.ПолФизическогоЛица.Мужской Тогда
			Результат = Компонента.Просклонять(Результат, Падеж, 1) + " ";
			
		ИначеЕсли Пол = Перечисления.ПолФизическогоЛица.Женский Тогда
			Результат = Компонента.Просклонять(Результат, Падеж, 2) + " ";
			
		Иначе
			Результат = Компонента.Просклонять(Результат, Падеж) + " ";
			
		КонецЕсли;
		
	Исключение
		Результат = ФИО;
		Возврат Ложь;
		
	КонецПопытки;
	
	// Остальные символы добавим без склонения
	Для Номер = НомерНесклоняемогоСимвола По МассивСтрок.Количество() Цикл
		Результат = Результат + " " + МассивСтрок[Номер-1];
	КонецЦикла;
	
	Результат = СокрЛП(Результат);
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ФизическиеЛица");
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииИсключенийПоискаСсылок"].Добавить(
		"ФизическиеЛица");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики служебных событий подсистем БСП

// Заполняет массив списком имен объектов метаданных, данные которых могут содержать ссылки на различные объекты метаданных,
// но при этом эти ссылки не должны учитываться в бизнес-логике приложения.
//
// Параметры:
//  Массив       - массив строк, например, "РегистрСведений.ВерсииОбъектов".
//
Процедура ПриДобавленииИсключенийПоискаСсылок(Массив) Экспорт
	
	Массив.Добавить(Метаданные.РегистрыСведений.ДокументыФизическихЛиц.ПолноеИмя());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.8";
	Обработчик.Процедура = "ФизическиеЛица.ПреобразоватьУдостоверенияЛичностиВДокументы";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.5";
	Обработчик.Процедура = "ФизическиеЛица.ЗаменитьВидыДокументовНаПредопределенные";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.31";
	Обработчик.Процедура = "ФизическиеЛица.УстановитьРеквизитДопУпорядочиванияВидовДокументов";
	
КонецПроцедуры

// Заполняет измерение ВидДокумента по ресурсу УдалитьВидДокумента,
// а также заполняет реквизит ЯвляетсяДокументомУдостоверяющимЛичность для существующих записей
//
Процедура ПреобразоватьУдостоверенияЛичностиВДокументы() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТ_Физлица
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	(НЕ ДокументыФизическихЛиц.УдалитьВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ДокументыФизическихЛиц.УдалитьВидДокумента КАК ВидДокумента,
	|	ДокументыФизическихЛиц.Серия,
	|	ДокументыФизическихЛиц.Номер,
	|	ДокументыФизическихЛиц.ДатаВыдачи,
	|	ДокументыФизическихЛиц.СрокДействия,
	|	ДокументыФизическихЛиц.КемВыдан,
	|	ДокументыФизическихЛиц.КодПодразделения,
	|	ВЫБОР
	|		КОГДА ДокументыФизическихЛиц.УдалитьВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПустаяСсылка)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ЯвляетсяДокументомУдостоверяющимЛичность,
	|	ДокументыФизическихЛиц.Представление
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.Физлицо В
	|			(ВЫБРАТЬ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТ_Физлица КАК Физлица)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо,
	|	Период";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	
	ТекстСерия				= НСтр("ru = ', серия: %1'");
	ТекстНомер				= НСтр("ru = ', № %1'");
	ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1 года'");
	ТекстСрокДействия		= НСтр("ru = ', действует до: %1 года'");
	ТекстКодПодразделения	= НСтр("ru = ', № подр. %1'");
	
	Пока Выборка.СледующийПоЗначениюПоля("Физлицо") Цикл
		НаборЗаписей.Отбор.Физлицо.Установить(Выборка.Физлицо);
		
		Пока Выборка.Следующий() Цикл
			Запись = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(Запись, Выборка);
			
			Если ПустаяСтрока(Запись.Представление) И Не Запись.ВидДокумента.Пустая() Тогда
				Запись.Представление = ""
				+ Запись.ВидДокумента
				+ ?(ЗначениеЗаполнено(Запись.Серия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, Запись.Серия), "")
				+ ?(ЗначениеЗаполнено(Запись.Номер), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, Запись.Номер), "")
				+ ?(ЗначениеЗаполнено(Запись.ДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(Запись.ДатаВыдачи,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(Запись.СрокДействия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСрокДействия, Формат(Запись.СрокДействия,"ДФ='дд ММММ гггг'")), "")
				+ ?(ЗначениеЗаполнено(Запись.КемВыдан), ", " + Запись.КемВыдан, "")
				+ ?(ЗначениеЗаполнено(Запись.КодПодразделения) И Запись.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКодПодразделения, Запись.КодПодразделения), "");
			КонецЕсли;
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		НаборЗаписей.Очистить();
	КонецЦикла;
	
КонецПроцедуры

// Заменяет ссылку на виды документов физических лиц в регистре сведений ДокументыФизическихЛиц
// на добавленные предопределенные документы
//
Процедура ЗаменитьВидыДокументовНаПредопределенные() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо
	|ПОМЕСТИТЬ ВТФизлица
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.ВидДокумента.ПометкаУдаления
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Физлицо
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокументыФизическихЛиц.Период КАК Период,
	|	ДокументыФизическихЛиц.Физлицо КАК Физлицо,
	|	ВЫБОР
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Военный билет""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилет)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Военный билет офицера запаса""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ВоенныйБилетОфицераЗапаса)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Дипломатический паспорт гражданина РФ""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ДипломатическийПаспорт)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Загранпаспорт гражданина РФ""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортРФ)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Загранпаспорт гражданина СССР""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ЗагранпаспортСССР)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт гражданина РФ""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт гражданина СССР""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортСССР)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт Минморфлота""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортМинморфлота)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Паспорт моряка""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортМоряка)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Свидетельство о рождении""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.СвидетельствоОРождении)
	|		КОГДА ДокументыФизическихЛиц.ВидДокумента.Наименование = ""Удостоверение личности офицера""
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.УдостоверениеОфицера)
	|		ИНАЧЕ ДокументыФизическихЛиц.ВидДокумента
	|	КОНЕЦ КАК ВидДокумента,
	|	ДокументыФизическихЛиц.Серия,
	|	ДокументыФизическихЛиц.Номер,
	|	ДокументыФизическихЛиц.ДатаВыдачи,
	|	ДокументыФизическихЛиц.СрокДействия,
	|	ДокументыФизическихЛиц.КемВыдан,
	|	ДокументыФизическихЛиц.КодПодразделения,
	|	ДокументыФизическихЛиц.ЯвляетсяДокументомУдостоверяющимЛичность,
	|	ДокументыФизическихЛиц.Представление,
	|	ДокументыФизическихЛиц.УдалитьВидДокумента
	|ИЗ
	|	РегистрСведений.ДокументыФизическихЛиц КАК ДокументыФизическихЛиц
	|ГДЕ
	|	ДокументыФизическихЛиц.Физлицо В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				Физлица.Физлицо
	|			ИЗ
	|				ВТФизлица КАК Физлица)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Физлицо,
	|	Период";
	Выборка = Запрос.Выполнить().Выбрать();
	
	НаборЗаписей = РегистрыСведений.ДокументыФизическихЛиц.СоздатьНаборЗаписей();
	
	Пока Выборка.СледующийПоЗначениюПоля("Физлицо") Цикл
		НаборЗаписей.Отбор.Физлицо.Установить(Выборка.Физлицо);
		
		Пока Выборка.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(НаборЗаписей.Добавить(), Выборка);
		КонецЦикла;
		
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		НаборЗаписей.Очистить();
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|ГДЕ
	|	(НЕ ВидыДокументовФизическихЛиц.Предопределенный)
	|	И (ВидыДокументовФизическихЛиц.Наименование = ""Военный билет""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Военный билет офицера запаса""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Дипломатический паспорт гражданина РФ""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Загранпаспорт гражданина РФ""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Загранпаспорт гражданина СССР""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт гражданина РФ""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт гражданина СССР""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт Минморфлота""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Паспорт моряка""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Свидетельство о рождении""
	|			ИЛИ ВидыДокументовФизическихЛиц.Наименование = ""Удостоверение личности офицера"")";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ОбновлениеИнформационнойБазы.УдалитьДанные(Выборка.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает РеквизитДопУпорядочивания для элементов справочника ВидыДокументовФизическихЛиц
//
Процедура УстановитьРеквизитДопУпорядочиванияВидовДокументов() Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ПаспортРФ",				Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ);
	Запрос.УстановитьПараметр("СвидетельствоОРождении", Справочники.ВидыДокументовФизическихЛиц.СвидетельствоОРождении);
	Запрос.УстановитьПараметр("УдостоверениеОфицера",	Справочники.ВидыДокументовФизическихЛиц.УдостоверениеОфицера);
	Запрос.УстановитьПараметр("ПаспортМоряка",			Справочники.ВидыДокументовФизическихЛиц.ПаспортМоряка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыДокументовФизическихЛиц.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &ПаспортРФ
	|			ТОГДА 1
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &СвидетельствоОРождении
	|			ТОГДА 2
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &УдостоверениеОфицера
	|			ТОГДА 3
	|		КОГДА ВидыДокументовФизическихЛиц.Ссылка = &ПаспортМоряка
	|			ТОГДА 4
	|		ИНАЧЕ 5
	|	КОНЕЦ КАК Порядок
	|ИЗ
	|	Справочник.ВидыДокументовФизическихЛиц КАК ВидыДокументовФизическихЛиц
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ВидыДокументовФизическихЛиц.Наименование";
	
	Порядок = 1;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка);
		Объект.РеквизитДопУпорядочивания = Порядок;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(Объект);
		
		Порядок = Порядок + 1;
		
	КонецЦикла;
	
КонецПроцедуры
