﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВойтиВОбластьДанных(Команда)
	
	ОбновитьИнтерфейс = Ложь;
	
	ВыполнитьВходВОбластьДанных(ОбновитьИнтерфейс);
	
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьВходВОбластьДанных(ОбновитьИнтерфейс)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		
		Отказ = Ложь;
		ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
		СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		
	КонецЕсли;
	
	Если НЕ УказаннаяОбластьДанныхЗаполнена(ОбластьДанных) Тогда
		Ответ = Вопрос(НСтр("ru = 'Выбранная область данных не используется, продолжить вход?'"),
			РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВойтиВОбластьДанныхНаСервере(ОбластьДанных);
	
	ОбновитьИнтерфейс = Истина;
	Отказ = Ложь;
	СтандартныеПодсистемыКлиент.ДействияПередНачаломРаботыСистемы(Отказ);
	
	Если Отказ Тогда
		
		ВыйтиИзОбластиДанныхНаСервере();
		ОбновитьИнтерфейс = Истина;
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		Возврат;
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ДействияПриНачалеРаботыСистемы();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыйтиИзОбластиДанных(Команда)
	
	Если ОсуществленВходВОбластьДанных() Тогда
		
		Отказ = Ложь;
		ПропуститьПредупреждениеПередЗавершениемРаботыСистемы = Истина;
		СтандартныеПодсистемыКлиент.ДействияПередЗавершениемРаботыСистемы(Отказ);
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		ВыйтиИзОбластиДанныхНаСервере();
		СтандартныеПодсистемыКлиент.УстановитьРасширенныйЗаголовокПриложения(Истина);
		ОбновитьИнтерфейс();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Функция УказаннаяОбластьДанныхЗаполнена(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
	ЭлементБлокировки.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбластиДанных.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.ОбластиДанных КАК ОбластиДанных
	|ГДЕ
	|	ОбластиДанных.ОбластьДанныхВспомогательныеДанные = &ОбластьДанных";
	Запрос.УстановитьПараметр("ОбластьДанных", ОбластьДанных);
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Результат = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Если Результат.Пустой() Тогда
		Возврат Ложь;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Статус = Перечисления.СтатусыОбластейДанных.Используется
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ВойтиВОбластьДанныхНаСервере(Знач ОбластьДанных)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	
	НачатьТранзакцию();
	
	Попытка
		
		КлючОбласти = РаботаВМоделиСервиса.СоздатьКлючЗаписиРегистраСведенийВспомогательныхДанных(
			РегистрыСведений.ОбластиДанных,
			Новый Структура(РаботаВМоделиСервиса.РазделительВспомогательныхДанных(), ОбластьДанных));
		ЗаблокироватьДанныеДляРедактирования(КлючОбласти);
		
		Блокировка = Новый БлокировкаДанных;
		Элемент = Блокировка.Добавить("РегистрСведений.ОбластиДанных");
		Элемент.УстановитьЗначение("ОбластьДанныхВспомогательныеДанные", ОбластьДанных);
		Элемент.Режим = РежимБлокировкиДанных.Разделяемый;
		Блокировка.Заблокировать();
		
		МенеджерЗаписи = РегистрыСведений.ОбластиДанных.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗаписи.Прочитать();
		Если Не МенеджерЗаписи.Выбран() Тогда
			МенеджерЗаписи.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
			МенеджерЗаписи.Статус = Перечисления.СтатусыОбластейДанных.Используется;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		РазблокироватьДанныеДляРедактирования(КлючОбласти);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВыйтиИзОбластиДанныхНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Ложь);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОсуществленВходВОбластьДанных()
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат ОбщегоНазначения.ИспользованиеРазделителяСеанса();
	
КонецФункции
