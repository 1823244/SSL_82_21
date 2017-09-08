﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма,Параметры);
	Если ТипСтрокиДерева = "Раздел" Тогда
		
		Элементы.ГруппаВысотаОбязательный.Видимость = Ложь;
		Элементы.ЭлементарныйВопрос.Видимость       = Ложь;
		Элементы.Формулировка.Заголовок             = НСтр("ru = 'Имя раздела'");
		Заголовок                                   = НСтр("ru = 'Раздел шаблона анкеты'");
		
	КонецЕсли;
	
	Если НЕ ЭлементарныйВопрос.Пустая() Тогда
		Элементы.Формулировка.СписокВыбора.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЭлементарныйВопрос,"Формулировка"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ЭлементарныйВопросНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") Тогда
		
		СтандартнаяОбработка = ЛОЖЬ;
		
		МассивОтбора = Новый Массив;
		МассивОтбора.Добавить(АнкетированиеКлиент.СоздатьСтруктуруПараметраОтбора(Тип("ЭлементОтбораКомпоновкиДанных"),"ТипОтвета",ВидСравненияКомпоновкиДанных.Равно,ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Булево")));
		МассивОтбора.Добавить(АнкетированиеКлиент.СоздатьСтруктуруПараметраОтбора(Тип("ЭлементОтбораКомпоновкиДанных"),"ПометкаУдаления",ВидСравненияКомпоновкиДанных.Равно,ЛОЖЬ));
		
		ОткрытьФорму("ПланВидовХарактеристик.ВопросыДляАнкетирования.Форма.ФормаВыбора",Новый Структура("МассивОтбора",МассивОтбора),Элемент);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлементарныйВопросОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РеквизитыВопрос = РеквизитыВопроса(ВыбранноеЗначение);
	
	Если РеквизитыВопрос.ЭтоГруппа Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	Если ТипВопроса = ПредопределенноеЗначение("Перечисление.ТипыВопросовШаблонаАнкеты.ВопросСУсловием") 
		И РеквизитыВопрос.ТипОтвета <> ПредопределенноеЗначение("Перечисление.ТипыОтветовНаВопрос.Булево")  Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СформироватьАвтоФормулировку(РеквизитыВопрос.Формулировка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПеренестиВШаблон(Команда)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Формулировка) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = ' Не заполнена формулировка'"),,"Формулировка");
	КонецЕсли;
	
	Если ТипСтрокиДерева = "Вопрос" И (Не ЗначениеЗаполнено(ЭлементарныйВопрос)) Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = ' Не указан элементарный вопрос'"),,"ЭлементарныйВопрос");
	КонецЕсли; 
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("ОкончаниеРедактированияПараметровСтрокиШаблонаАнкеты",СформироватьСтруктуруПараметровДляПередачиВладельцу());
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Формирует структуру параметров для передачи в форму владельца
&НаКлиенте
Функция СформироватьСтруктуруПараметровДляПередачиВладельцу()

	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Обязательный",Обязательный);
	СтруктураВозврата.Вставить("Формулировка",Формулировка);
	СтруктураВозврата.Вставить("ЭлементарныйВопрос",ЭлементарныйВопрос);
	СтруктураВозврата.Вставить("ВысотаЭлементаФормулировкиВопроса",ВысотаЭлементаФормулировкиВопроса);
	
	Возврат СтруктураВозврата;

КонецФункции

// Получает значение формулировки элементарного вопроса и заполняет список выбора поля Формулировка
&НаКлиенте
Функция СформироватьАвтоФормулировку(ФормулировкаЭлементарногоВопроса)

	Элементы.Формулировка.СписокВыбора.Очистить();
	
	Если ПустаяСтрока(Формулировка) Тогда
		Формулировка = ФормулировкаЭлементарногоВопроса;
	КонецЕсли;
	
	Элементы.Формулировка.СписокВыбора.Добавить(ФормулировкаЭлементарногоВопроса);
	
	Возврат ФормулировкаЭлементарногоВопроса;

КонецФункции

&НаСервере
Функция РеквизитыВопроса(Вопрос)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Вопрос,"ЭтоГруппа,ТипОтвета,Формулировка");
	
КонецФункции