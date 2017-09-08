﻿&НаКлиенте
Перем ПараметрыОбработчика;

&НаКлиенте
Перем ВыполняемаяКоманда;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("РежимОткрытияОкна") Тогда
		ЭтаФорма.РежимОткрытияОкна = Параметры.РежимОткрытияОкна;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИмяРаздела)
		И Параметры.ИмяРаздела <> ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола() Тогда
		СсылкаРаздела = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Подсистемы.Найти(Параметры.ИмяРаздела));
	КонецЕсли;
	
	ВидОбработок = ДополнительныеОтчетыИОбработки.ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(Параметры.Вид);
	
	Если ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды заполнения объектов'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		ЭтоНазначаемыеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = НСтр("ru = 'Отчеты'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Дополнительные печатные формы'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		ЭтоНазначаемыеОбработки = Истина;
		Заголовок = НСтр("ru = 'Команды создания связанных объектов'");
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
		ЭтоГлобальныеОбработки = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные обработки (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	ИначеЕсли ВидОбработок = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		ЭтоГлобальныеОбработки = Истина;
		ЭтоОтчеты = Истина;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Дополнительные отчеты (%1)'"), 
			ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СсылкаРаздела));
	КонецЕсли;
	
	Если ЭтоНазначаемыеОбработки Тогда
		Элементы.НастроитьСписок.Видимость = Ложь;
		
		ОбъектыНазначения.ЗагрузитьЗначения(Параметры.ОбъектыНазначения.ВыгрузитьЗначения());
		
		ИмяФормыВладельца = Параметры.ИмяФормы;
		ИнформацияОВладельце = ДополнительныеОтчетыИОбработкиПовтИсп.ПараметрыФормыНазначаемогоОбъекта(ИмяФормыВладельца);
		
		Если ТипЗнч(ИнформацияОВладельце) = Тип("ФиксированнаяСтруктура") Тогда
			СсылкаРодителя  = ИнформацияОВладельце.СсылкаРодителя;
			ЭтоФормаОбъекта = ИнформацияОВладельце.ЭтоФормаОбъекта;
		Иначе
			МетаданныеРодителя = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектыНазначения[0].Значение));
			СсылкаРодителя  = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеРодителя);
			ЭтоФормаОбъекта = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТаблицуОбработок();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВыбранноеЗначение = "ВыполненаНастройкаМоихОтчетовИОбработок" Тогда
		ЗаполнитьТаблицуОбработок();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ФоновоеЗаданиеПроверитьВыполнениеПриЗакрытии Тогда
		ФоновоеЗаданиеПроверитьВыполнениеПриЗакрытии = Ложь;
		ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
		
		Результат = ПроверитьВыполнениеФоновогоЗаданияНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, Истина);
		Если Результат.Выполнено ИЛИ Результат.ВызваноИсключение Тогда
			ПоказатьРезультатВыполненияОбработки(Результат, Ложь);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ ТаблицаКоманд

&НаКлиенте
Процедура ТаблицаКомандВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыполнитьОбработкуПоПараметрам();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыполнитьОбработку(Команда)
	
	ВыполнитьОбработкуПоПараметрам()
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьСписок(Команда)
	Открытие = Новый Структура("Имя, Параметры, Владелец, Уникальность, Окно");
	
	Открытие.Имя = "ОбщаяФорма.НастройкаМоихОтчетовИОбработок";
	Открытие.Владелец = ЭтаФорма;
	Открытие.Уникальность = Ложь;
	
	Открытие.Параметры = Новый Структура("ВидОбработок, ЭтоГлобальныеОбработки, ТекущийРаздел");
	Открытие.Параметры.ВидОбработок           = ВидОбработок;
	Открытие.Параметры.ЭтоГлобальныеОбработки = ЭтоГлобальныеОбработки;
	Открытие.Параметры.ТекущийРаздел          = СсылкаРаздела;
	
	ОткрытьФорму(Открытие.Имя, Открытие.Параметры, Открытие.Владелец, Открытие.Уникальность, Открытие.Окно);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыполнениеОбработки(Команда)
	Закрыть();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьТаблицуОбработок()
	Запрос = ДополнительныеОтчетыИОбработки.НовыйЗапросПоДоступнымКомандам(ВидОбработок, ?(ЭтоГлобальныеОбработки, СсылкаРаздела, СсылкаРодителя), ЭтоФормаОбъекта);
	
	ТаблицаРезультат = Запрос.Выполнить().Выгрузить();
	
	ЗначениеВРеквизитФормы(ТаблицаРезультат, "ТаблицаКоманд");
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработкуПоПараметрам()
	ДанныеОбработки = Элементы.ТаблицаКоманд.ТекущиеДанные;
	Если ДанныеОбработки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполняемаяКоманда = Новый Структура(
		"Ссылка, Представление, 
		|Идентификатор, ВариантЗапуска, ПоказыватьОповещение, 
		|Модификатор, ОбъектыНазначения, ЭтоОтчет, Вид");
	ЗаполнитьЗначенияСвойств(ВыполняемаяКоманда, ДанныеОбработки);
	Если НЕ ЭтоГлобальныеОбработки Тогда
		ВыполняемаяКоманда.ОбъектыНазначения = ОбъектыНазначения.ВыгрузитьЗначения();
	КонецЕсли;
	ВыполняемаяКоманда.ЭтоОтчет = ЭтоОтчеты;
	ВыполняемаяКоманда.Вид = ВидОбработок;
	
	Если ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеФормыОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода") Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьКлиентскийМетодОбработки(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ВидОбработок = ПредопределенноеЗначение("Перечисление.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма")
		И ДанныеОбработки.Модификатор = "ПечатьMXL" Тогда
		
		ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьОткрытиеПечатнойФормы(ВыполняемаяКоманда, ВладелецФормы, ВыполняемаяКоманда.ОбъектыНазначения);
		Закрыть();
		
	ИначеЕсли ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода")
		Или ДанныеОбработки.ВариантЗапуска = ПредопределенноеЗначение("Перечисление.СпособыВызоваДополнительныхОбработок.СценарийВБезопасномРежиме") Тогда
		
		// Изменение элементов формы
		Элементы.ПоясняющаяДекорация.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Выполняется команда ""%1""...'"),
			ДанныеОбработки.Представление);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВыполненияОбработки;
		Элементы.СтраницыКомандныеПанели.ТекущаяСтраница = Элементы.СтраницаКоманднаяПанельСтраницыВыполненияОбработки;
		
		// Вызов сервера только после перехода формы в консистентное состояние
		ПодключитьОбработчикОжидания("ВыполнитьСерверныйМетодОбработки", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСерверныйМетодОбработки()
	ФоновоеЗаданиеПроверитьВыполнениеПриЗакрытии = Истина;
	
	ПараметрыВызоваСервера = Новый Структура("ДополнительнаяОбработкаСсылка, ИдентификаторКоманды, ОбъектыНазначения");
	ПараметрыВызоваСервера.ДополнительнаяОбработкаСсылка = ВыполняемаяКоманда.Ссылка;
	ПараметрыВызоваСервера.ИдентификаторКоманды   = ВыполняемаяКоманда.Идентификатор;
	ПараметрыВызоваСервера.ОбъектыНазначения      = ВыполняемаяКоманда.ОбъектыНазначения;
	
	Результат = ВыполнитьСерверныйМетодОбработкиНаСервере(ПараметрыВызоваСервера);
	
	Если Результат.Выполнено ИЛИ Результат.ВызваноИсключение Тогда
		ПоказатьРезультатВыполненияОбработки(Результат, Истина);
	Иначе
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 1, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ВыполнитьСерверныйМетодОбработкиНаСервере(ПараметрыВызоваСервера)
	Результат = Новый Структура("Выполнено, ВызваноИсключение, Значение", Ложь, Ложь, Неопределено);
	
	Попытка
		Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
			Результат.Значение  = ДополнительныеОтчетыИОбработки.ВыполнитьКоманду(ПараметрыВызоваСервера, Неопределено);
			Результат.Выполнено = Истина;
		Иначе
			РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
				УникальныйИдентификатор,
				"ДополнительныеОтчетыИОбработки.ВыполнитьКоманду", 
				ПараметрыВызоваСервера, 
				НСтр("ru = 'Дополнительные отчеты и обработки: Выполнение серверного метода обработки'"));
			
			Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
				Результат.Выполнено = Истина;
				Результат.Значение  = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресХранилища);
			Иначе
				ФоновоеЗаданиеИдентификатор  = РезультатФоновогоЗадания.ИдентификаторЗадания;
				ФоновоеЗаданиеАдресХранилища = РезультатФоновогоЗадания.АдресХранилища;
			КонецЕсли;
		КонецЕсли;
	Исключение
		Результат.ВызваноИсключение = Истина;
		ДополнительныеОтчетыИОбработки.ЗаписатьОшибку(
			ПараметрыВызоваСервера.ДополнительнаяОбработкаСсылка,
			НСтр("ru = 'Команда %1: Ошибка выполнения:%2'"),
			ПараметрыВызоваСервера.ИдентификаторКоманды,
			Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПоказатьРезультатВыполненияОбработки(Результат, ЗакрытьЭтуФорму)
	// Добавление оповещения в результат выполнения (если требуется).
	РезультатВыполнения = ?(Результат = Неопределено, Неопределено, Результат.Значение);
	Если ВыполняемаяКоманда.ПоказыватьОповещение Тогда
		Если РезультатВыполнения = Неопределено Тогда
			РезультатВыполнения = СтандартныеПодсистемыКлиентСервер.НовыйРезультатВыполнения();
		КонецЕсли;
		Если НЕ РезультатВыполнения.Свойство("ВыводОповещения") Тогда
			РезультатВыполнения.Вставить("ВыводОповещения", Новый Структура("Использование, Заголовок, Текст, Картинка", Ложь));
		КонецЕсли;
		Если РезультатВыполнения.ВыводОповещения.Использование <> Истина Тогда
			РезультатВыполнения.ВыводОповещения.Использование = Истина;
			РезультатВыполнения.ВыводОповещения.Заголовок = НСтр("ru = 'Команда выполнена'");
			РезультатВыполнения.ВыводОповещения.Текст = ВыполняемаяКоманда.Представление;
		КонецЕсли;
	КонецЕсли;
	
	Если Результат <> Неопределено И Результат.ВызваноИсключение Тогда
		// Изменение элементов формы
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаОткрытьОбработку;
		Элементы.СтраницыКомандныеПанели.ТекущаяСтраница = Элементы.СтраницаКоманднаяПанельСтраницыОткрытьОбработку;
		// Вывод сообщения об ошибке
		Предупреждение(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось выполнить команду ""%1"".
				|Подробности см. в журнале регистрации.'"),
				ВыполняемаяКоманда.Представление));
	КонецЕсли;
	
	// Вывод результата выполнения.
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ВладелецФормы, РезультатВыполнения);
	
	// Обновить форму владельца
	Если ЭтоФормаОбъекта Тогда
		Попытка
			ВладелецФормы.Прочитать();
		Исключение
			// Действие не требуется.
		КонецПопытки;
	КонецЕсли;
	
	// Фоновое задание уже завершилось.
	ФоновоеЗаданиеПроверитьВыполнениеПриЗакрытии = Ложь;
	
	// Закрыть текущую форму
	Если ЗакрытьЭтуФорму = Истина Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Результат = ПроверитьВыполнениеФоновогоЗаданияНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища);
	Если Результат.Выполнено ИЛИ Результат.ВызваноИсключение Тогда
		ПоказатьРезультатВыполненияОбработки(Результат, Истина);
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", ПараметрыОбработчика.ТекущийИнтервал, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВыполнениеФоновогоЗаданияНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, Отменить = Ложь)
	Результат = Новый Структура("Выполнено, ВызваноИсключение, Значение", Ложь, Ложь, Неопределено);
	Попытка
		Если ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор) Тогда
			Результат.Выполнено = Истина;
			Результат.Значение  = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
		КонецЕсли;
	Исключение
		Результат.ВызваноИсключение = Истина;
	КонецПопытки;
	Если Отменить Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ФоновоеЗаданиеИдентификатор);
	КонецЕсли;
	Возврат Результат;
КонецФункции

