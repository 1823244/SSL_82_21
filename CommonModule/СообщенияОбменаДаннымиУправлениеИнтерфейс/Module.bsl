﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК ИНТЕРФЕЙСА СООБЩЕНИЙ УПРАВЛЕНИЯ ОБМЕНОМ ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Manage";
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ExchangeManage";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияОбменаДаннымиУправлениеОбработчикСообщения_2_1_2_1);
	
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
//
// Параметры:
//  МассивОбработчиков - массив.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
	
	
	
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}SetupExchangeStep1
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеНастроитьОбменШаг1(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep1");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}SetupExchangeStep2
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеНастроитьОбменШаг2(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "SetupExchangeStep2");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}DownloadMessage
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеЗагрузитьСообщениеОбмена(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "DownloadMessage");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetData
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПолучитьДанныеКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetData");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetCommonNodsData
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПолучитьОбщиеДанныеУзловКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetCommonNodsData");
	
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/Exchange/Manage/a.b.c.d}GetCorrespondentParams
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипXDTO
//
Функция СообщениеПолучитьПараметрыУчетаКорреспондента(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "GetCorrespondentParams");
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
	
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции


