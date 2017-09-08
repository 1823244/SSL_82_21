﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки в модели сервиса", процедуры и
// функции по управлению заданиями очереди.
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Создает новое задание очереди заданий.
//
// Возвращаемое значение: СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
Функция СоздатьНовоеЗадание() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура();
	ПараметрыЗадания.Вставить("Использование", Ложь);
	ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок.ИмяМетода);
	
	Возврат ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	
КонецФункции

// Возвращает идентификатор задания очереди (для сохранения в данных информационной базы).
//
// Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: УникальныйИдентификатор.
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Задание.УникальныйИдентификатор();
	
КонецФункции

// Устанавливает параметры задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных,
//  Использование - булево, флаг использования регламентного задания,
//  Параметры - Массив(Произвольный), параметры регламентного задания,
//  Расписание - РасписаниеРегламентногоЗадания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, Параметры, Расписание) Экспорт
	
	Если Не Константы.РазрешитьВыполнениеДополнительныхОтчетовИОбработокРегламентнымиЗаданиямиВМоделиСервиса.Получить() Тогда
		ВызватьИсключение НСтр("ru = 'Периодическое выполнение команд дополнительных обработок в качестве заданий запрещено администрацией сервиса!'");
	КонецЕсли;
	
	МинимальныйИнтервал = Константы.МинимальныйИнтервалРегламентныхЗаданийДополнительныхОтчетовИОбработокВМоделиСервиса.Получить();
	ИсходнаяДата = ТекущаяДатаСеанса();
	ПроверяемаяДата = ИсходнаяДата + МинимальныйИнтервал - 1;
	Если Расписание.ТребуетсяВыполнение(ПроверяемаяДата, ИсходнаяДата) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Расписание, задаваемое для выполнения команд дополнительного отчета или обработки в качестве заданий, должно быть не чаще, чем 1 раз в %1 секунд!'"), МинимальныйИнтервал);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура();
	ПараметрыЗадания.Вставить("Использование", Использование);
	ПараметрыЗадания.Вставить("ИмяМетода", Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок.ИмяМетода);
	ПараметрыЗадания.Вставить("Параметры", Параметры);
	ПараметрыЗадания.Вставить("Ключ", Метаданные.РегламентныеЗадания.ЗапускДополнительныхОбработок.Ключ);
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	
	ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
	
КонецПроцедуры

// Возвращает параметры задания очереди заданий.
//
// Параметры:
//  Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
// Возвращаемое значение: Структура, описания ключей - см. описание возвращаемого значения
//  для функции ОчередьЗаданий.ПолучитьЗадания().
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОчередьЗаданий.ПолучитьЗадания(Новый Структура("Идентификатор", Задание))[0];
	
КонецФункции

// Выполняет поиск задания очереди по идентификатору (предположительно, сохраненному в данных
// информационной базы).
//
// Параметры: Идентификатор - УникальныйИдентификатор.
//
// Возвращаемое значение: СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Задание = Справочники.ОчередьЗаданийОбластейДанных.ПолучитьСсылку(Идентификатор);
	Если ОбщегоНазначения.СсылкаСуществует(Задание) Тогда
		Возврат Задание;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Удаляет задание очереди заданий.
//
// Параметры:
// Задание - СправочникСсылка.ОчередьЗаданийОбластейДанных.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(Задание) = Тип("СправочникСсылка.ОчередьЗаданийОбластейДанных") Тогда
		ОчередьЗаданий.УдалитьЗадание(Задание);
	КонецЕсли;
	
КонецПроцедуры
