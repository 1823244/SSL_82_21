﻿////////////////////////////////////////////////////////////////////////////////
// Форма выбора для полей типа "узел плана обмена".
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработка стандартных параметров
	Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
		РежимПодбора = Истина;
		Если Параметры.Свойство("МножественныйВыбор") И Параметры.МножественныйВыбор = Истина Тогда
			МножественныйВыбор = Истина;
		КонецЕсли;
	КонецЕсли;
	
	// Подготовка списка используемых планов обмена
	Если ТипЗнч(Параметры.ПланыОбменаДляВыбора) = Тип("Массив") Тогда
		Для каждого Элемент Из Параметры.ПланыОбменаДляВыбора Цикл
			Если ТипЗнч(Элемент) = Тип("Строка") Тогда
				// Поиск плана обмена по имени
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоПолномуИмени(Элемент));
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоПолномуИмени("ПланОбмена." + Элемент));
				//
			ИначеЕсли ТипЗнч(Элемент) = Тип("Тип") Тогда
				// Поиск плана обмена по заданному типу
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоТипу(Элемент));
			Иначе
				// Поиск плана обмена по типу заданного узла
				ДобавитьИспользуемыйПланОбмена(Метаданные.НайтиПоТипу(ТипЗнч(Элемент)));
			КонецЕсли;
		КонецЦикла;
	Иначе
		// Все планы обмена участвуют в выборе
		Для каждого ОбъектМетаданных Из Метаданные.ПланыОбмена Цикл
			ДобавитьИспользуемыйПланОбмена(ОбъектМетаданных);
		КонецЦикла;
	КонецЕсли;
	
	УзлыПлановОбмена.Сортировать("ПланОбменаПредставление Возр");
	
	Если РежимПодбора Тогда
		Заголовок = НСтр("ru = 'Подбор узлов планов обмена'");
	КонецЕсли;
	Если МножественныйВыбор Тогда
		Элементы.УзлыПлановОбмена.РежимВыделения = РежимВыделенияТаблицы.Множественный;
	КонецЕсли;
	
	ТекущаяСтрока = Неопределено;
	Параметры.Свойство("ТекущаяСтрока", ТекущаяСтрока);
	
	НайденныеСтроки = УзлыПлановОбмена.НайтиСтроки(Новый Структура("Узел", ТекущаяСтрока));
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		Элементы.УзлыПлановОбмена.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ УзлыПлановОбмена

&НаКлиенте
Процедура УзлыПлановОбменаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если МножественныйВыбор Тогда
		ЗначениеВыбора = Новый Массив;
		ЗначениеВыбора.Добавить(УзлыПлановОбмена.НайтиПоИдентификатору(ВыбраннаяСтрока).Узел);
		ОповеститьОВыборе(ЗначениеВыбора);
	Иначе
		ОповеститьОВыборе(УзлыПлановОбмена.НайтиПоИдентификатору(ВыбраннаяСтрока).Узел);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если МножественныйВыбор Тогда
		ЗначениеВыбора = Новый Массив;
		Для Каждого ВыделеннаяСтрока Из Элементы.УзлыПлановОбмена.ВыделенныеСтроки Цикл
			ЗначениеВыбора.Добавить(УзлыПлановОбмена.НайтиПоИдентификатору(ВыделеннаяСтрока).Узел)
		КонецЦикла;
		ОповеститьОВыборе(ЗначениеВыбора);
	Иначе
		ТекущиеДанные = Элементы.УзлыПлановОбмена.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Предупреждение(НСтр("ru = 'Узел не выбран.'"));
		Иначе
			ОповеститьОВыборе(ТекущиеДанные.Узел);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ДобавитьИспользуемыйПланОбмена(ОбъектМетаданных)
	
	Если ОбъектМетаданных = Неопределено
		ИЛИ НЕ Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли;
	ПланОбмена = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя()).ПустаяСсылка();
	ПланОбменаПредставление = ОбъектМетаданных.Синоним;
	
	// Заполнение узлов используемых планов обмена
	Если Параметры.ВыбиратьВсеУзлы Тогда
		НоваяСтрока = УзлыПлановОбмена.Добавить();
		НоваяСтрока.ПланОбмена              = ПланОбмена;
		НоваяСтрока.ПланОбменаПредставление = ОбъектМетаданных.Синоним;
		НоваяСтрока.Узел                    = ПланОбмена;
		НоваяСтрока.УзелПредставление       = НСтр("ru = '<Все информационные базы>'");
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЭтотУзел", ПланыОбмена[ОбъектМетаданных.Имя].ЭтотУзел());
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаПланаОбмена.Ссылка,
	|	ТаблицаПланаОбмена.Представление КАК Представление
	|ИЗ
	|	&ТаблицаПланаОбмена КАК ТаблицаПланаОбмена
	|ГДЕ
	|	ТаблицаПланаОбмена.Ссылка <> &ЭтотУзел
	|
	|УПОРЯДОЧИТЬ ПО
	|	Представление";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаПланаОбмена", ОбъектМетаданных.ПолноеИмя());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = УзлыПлановОбмена.Добавить();
		НоваяСтрока.ПланОбмена              = ПланОбмена;
		НоваяСтрока.ПланОбменаПредставление = ОбъектМетаданных.Синоним;
		НоваяСтрока.Узел                    = Выборка.Ссылка;
		НоваяСтрока.УзелПредставление       = Выборка.Представление;
	КонецЦикла;
	
КонецПроцедуры

