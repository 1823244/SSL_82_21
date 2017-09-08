﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИК КАНАЛОВ СООБЩЕНИЙ ДЛЯ ВЕРСИИ 2.1.2.1 ИНТЕРФЕЙСА СООБЩЕНИЙ
//  КОНТРОЛЯ АДМИНИСТРИРОВАНИЯ ОБМЕНА ДАННЫМИ
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает пространство имен версии интерфейса сообщений
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/ExchangeAdministration/Control";
	
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Возвращает базовый тип для сообщений версии
Функция БазовыйТип() Экспорт
	
	Возврат СообщенияВМоделиСервисаПовтИсп.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//  Сообщение - ОбъектXDTO, входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями, узел плана обмена, соответствующий отправителю сообщения
//  СообщениеОбработано - булево, флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияАдминистрированиеОбменаДаннымиКонтрольИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеНастройкиСинхронизацииДанныхПолучены(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.СохранитьДанныеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаПолученияНастроекСинхронизацииДанных(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОперацииПолученияНастроек());
	ИначеЕсли ТипСообщения = Словарь.СообщениеВключениеСинхронизацииУспешноЗавершено(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияУспешноОтключена(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаВключенияСинхронизации(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеВключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеОшибкаОтключенияСинхронизации(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьНеуспешноеВыполнениеСессии(Сообщение, ПредставлениеОтключениеСинхронизации());
	ИначеЕсли ТипСообщения = Словарь.СообщениеСинхронизацияЗавершена(Пакет()) Тогда
		ОбменДаннымиВМоделиСервиса.ЗафиксироватьУспешноеВыполнениеСессии(Сообщение, ПредставлениеВыполнениеСинхронизации());
	Иначе
		СообщениеОбработано = Ложь;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПредставлениеОперацииПолученияНастроек()
	
	Возврат НСтр("ru = 'Получение настроек синхронизации данных из Менеджера сервиса.'");
	
КонецФункции

Функция ПредставлениеВключениеСинхронизации()
	
	Возврат НСтр("ru = 'Включение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеОтключениеСинхронизации()
	
	Возврат НСтр("ru = 'Отключение синхронизации данных в Менеджере сервиса.'");
	
КонецФункции

Функция ПредставлениеВыполнениеСинхронизации()
	
	Возврат НСтр("ru = 'Выполнение синхронизации данных по запросу пользователя.'");
	
КонецФункции


