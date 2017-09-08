﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Процедура обновляет данные регистра по результату изменения прав ролей,
// сохраненному при обновлении регистра сведений ПраваРолей.
//
Процедура ОбновитьДанныеРегистраПоИзменениямКонфигурации() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры = УправлениеДоступомСлужебныйПовтИсп.Параметры();
	
	ПоследниеИзменения = СтандартныеПодсистемыСервер.ИзмененияПараметраРаботыПрограммы(
		Параметры, "ОбъектыМетаданныхПравРолей");
	
	Если ПоследниеИзменения = Неопределено Тогда
		ОбновитьДанныеРегистра();
	Иначе
		ОбъектыМетаданных = Новый Массив;
		Для каждого ЧастьИзменений Из ПоследниеИзменения Цикл
			Если ТипЗнч(ЧастьИзменений) = Тип("ФиксированныйМассив") Тогда
				Для каждого ОбъектМетаданных Из ЧастьИзменений Цикл
					Если ОбъектыМетаданных.Найти(ОбъектМетаданных) = Неопределено Тогда
						ОбъектыМетаданных.Добавить(ОбъектМетаданных);
					КонецЕсли;
				КонецЦикла;
			Иначе
				ОбъектыМетаданных = Неопределено;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ОбъектыМетаданных.Количество() > 0 Тогда
			ОбновитьДанныеРегистра(, ОбъектыМетаданных);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура обновляет данные регистра при изменении состава ролей профилей и
// изменении профилей у групп доступа.
// 
// Параметры:
//  ГруппыДоступа - СправочникСсылка.ГруппыДоступа.
//                - Неопределено - без отбора.
//
//  Таблицы       - СправочникСсылка.ИдентификаторыОбъектовМетаданных.
//                - Массив значений указанного выше типа.
//                - Неопределено - без отбора.
//
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьДанныеРегистра(ГруппыДоступа     = Неопределено,
                                 Таблицы           = Неопределено,
                                 ЕстьИзменения     = Неопределено) Экспорт
	
	Если ТипЗнч(Таблицы) = Тип("Массив")
	   И Таблицы.Количество() > 500 Тогда
	
		Таблицы = Неопределено;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапросовВременныхТаблиц =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Профиль КАК Профиль,
	|	ПраваРолей.ОбъектМетаданных КАК Таблица,
	|	ПраваРолей.ОбъектМетаданных.ЗначениеПустойСсылки КАК ТипТаблицы,
	|	МАКСИМУМ(ПраваРолей.Добавление) КАК Добавление,
	|	МАКСИМУМ(ПраваРолей.Изменение) КАК Изменение,
	|	МАКСИМУМ(ПраваРолей.Удаление) КАК Удаление
	|ПОМЕСТИТЬ ТаблицыПрофилей
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК РолиПрофиля
	|		ПО ГруппыДоступа.Профиль = РолиПрофиля.Ссылка
	|			И (&УсловиеОтбораГруппДоступа1)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|			И (НЕ РолиПрофиля.Ссылка.ПометкаУдаления)
	|			И (РолиПрофиля.Ссылка <> ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор))
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПраваРолей КАК ПраваРолей
	|		ПО (&УсловиеОтбораТаблиц1)
	|			И (ПраваРолей.Роль = РолиПрофиля.Роль)
	|			И (НЕ ПраваРолей.Роль.ПометкаУдаления)
	|			И (НЕ ПраваРолей.ОбъектМетаданных.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГруппыДоступа.Профиль,
	|	ПраваРолей.ОбъектМетаданных,
	|	ПраваРолей.ОбъектМетаданных.ЗначениеПустойСсылки
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПраваРолей.ОбъектМетаданных
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицыПрофилей.Таблица,
	|	ГруппыДоступа.Ссылка КАК ГруппаДоступа,
	|	ТаблицыПрофилей.Добавление КАК Добавление,
	|	ТаблицыПрофилей.Изменение КАК Изменение,
	|	ТаблицыПрофилей.Удаление КАК Удаление,
	|	ТаблицыПрофилей.ТипТаблицы КАК ТипТаблицы,
	|	ВЫБОР
	|		КОГДА ТаблицыПрофилей.Добавление
	|			ТОГДА ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПравоДобавления)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка)
	|	КОНЕЦ КАК ВидДоступаПравоДобавления,
	|	ВЫБОР
	|		КОГДА ТаблицыПрофилей.Изменение
	|			ТОГДА ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПравоИзменения)
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыДоступа.ПустаяСсылка)
	|	КОНЕЦ КАК ВидДоступаПравоИзменения
	|ПОМЕСТИТЬ НовыеДанные
	|ИЗ
	|	ТаблицыПрофилей КАК ТаблицыПрофилей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО (&УсловиеОтбораГруппДоступа1)
	|			И (ГруппыДоступа.Профиль = ТаблицыПрофилей.Профиль)
	|			И (НЕ ГруппыДоступа.ПометкаУдаления)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицыПрофилей.Таблица,
	|	ГруппыДоступа.Ссылка";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НовыеДанные.Таблица,
	|	НовыеДанные.ГруппаДоступа,
	|	НовыеДанные.Добавление,
	|	НовыеДанные.Изменение,
	|	НовыеДанные.Удаление,
	|	НовыеДанные.ТипТаблицы,
	|	НовыеДанные.ВидДоступаПравоДобавления,
	|	НовыеДанные.ВидДоступаПравоИзменения,
	|	&ПодстановкаПоляВидИзмененияСтроки
	|ИЗ
	|	НовыеДанные КАК НовыеДанные";
	
	// Подготовка выбираемых полей с необязательным отбором.
	Поля = Новый Массив; 
	Поля.Добавить(Новый Структура("Таблица",       "&УсловиеОтбораТаблиц2"));
	Поля.Добавить(Новый Структура("ГруппаДоступа", "&УсловиеОтбораГруппДоступа2"));
	Поля.Добавить(Новый Структура("Добавление"));
	Поля.Добавить(Новый Структура("Изменение"));
	Поля.Добавить(Новый Структура("Удаление"));
	Поля.Добавить(Новый Структура("ТипТаблицы"));
	Поля.Добавить(Новый Структура("ВидДоступаПравоДобавления"));
	Поля.Добавить(Новый Структура("ВидДоступаПравоИзменения"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = УправлениеДоступомСлужебный.ТекстЗапросаВыбораИзменений(
		ТекстЗапроса, Поля, "РегистрСведений.ТаблицыГруппДоступа", ТекстЗапросовВременныхТаблиц);
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, Таблицы, "Таблицы",
		"&УсловиеОтбораТаблиц1:ПраваРолей.ОбъектМетаданных
		|&УсловиеОтбораТаблиц2:СтарыеДанные.Таблица");
	
	УправлениеДоступомСлужебный.УстановитьУсловиеОтбораВЗапросе(Запрос, ГруппыДоступа, "ГруппыДоступа",
		"&УсловиеОтбораГруппДоступа1:ГруппыДоступа.Ссылка
		|&УсловиеОтбораГруппДоступа2:СтарыеДанные.ГруппаДоступа");
		
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ТаблицыГруппДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Изменения = Запрос.Выполнить().Выгрузить();
		
		Если ГруппыДоступа <> Неопределено
		   И Таблицы        = Неопределено Тогда
			
			ИзмеренияОтбора = "ГруппаДоступа";
		Иначе
			ИзмеренияОтбора = Неопределено;
		КонецЕсли;
		
		УправлениеДоступомСлужебный.ОбновитьРегистрСведений(
			РегистрыСведений.ТаблицыГруппДоступа, Изменения, ЕстьИзменения, , ИзмеренияОтбора);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли