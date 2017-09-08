﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТаблицаСортировки.Загрузить(Параметры.ТаблицаСортировки.Выгрузить());
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Применить(Команда)
	
	ОповеститьОВыборе(ТаблицаСортировки);
	
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры
