﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// СтандартныеПодсистемы.Взаимодействия
&НаКлиенте
Процедура ИспользоватьПочтовыйКлиентПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПрочиеВзаимодействияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ОтправлятьПисьмаВФорматеHTMLПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПризнакРассмотреноПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.ЗаметкиПользователя
&НаКлиенте
Процедура ИспользоватьЗаметкиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗаметкиПользователя

// СтандартныеПодсистемы.НапоминанияПользователя
&НаКлиенте
Процедура ИспользоватьНапоминанияПользователяПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.НапоминанияПользователя

// СтандартныеПодсистемы.Анкетирование
&НаКлиенте
Процедура ИспользоватьАнкетированиеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Анкетирование

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
&НаКлиенте
Процедура ИспользоватьБизнесПроцессыИЗадачиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодчиненныеБизнесПроцессыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИзменятьЗаданияЗаднимЧисломПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуНачалаЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьДатуИВремяВСрокахЗадачПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
&НаКлиенте
Процедура ОткрытьРолиИИсполнителиБизнесПроцессов(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсполнителиЗадач.Форма.АдресацияПоОбъекту",,ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если (КонстантаИмя = "ИспользоватьПочтовыйКлиент" ИЛИ КонстантаИмя = "ИспользоватьБизнесПроцессыИЗадачи") И КонстантаЗначение = Ложь Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.Взаимодействия
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПочтовыйКлиент" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьПрочиеВзаимодействия.Доступность = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ИспользоватьПризнакРассмотрено.Доступность   = НаборКонстант.ИспользоватьПочтовыйКлиент;
		Элементы.ОтправлятьПисьмаВФорматеHTML.Доступность     = НаборКонстант.ИспользоватьПочтовыйКлиент;
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Взаимодействия
	
	// СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ОткрытьРолиИИсполнителиБизнесПроцессов.Доступность = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьПодчиненныеБизнесПроцессы.Доступность  = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИзменятьЗаданияЗаднимЧислом.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуНачалаЗадач.Доступность            = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		Элементы.ИспользоватьДатуИВремяВСрокахЗадач.Доступность     = НаборКонстант.ИспользоватьБизнесПроцессыИЗадачи;
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.БизнесПроцессыИЗадачи
	
КонецПроцедуры
