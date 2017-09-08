﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтоЭтотУзел = (Объект.Ссылка = ОбменСообщениямиВнутренний.ЭтотУзел());
	
	Элементы.ГруппаИнформационныхСообщений.Видимость = Не ЭтоЭтотУзел;
	
	Если Не ЭтоЭтотУзел Тогда
		
		Если Объект.Заблокирована Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка заблокирована.'");
		ИначеЕсли Объект.Ведущая Тогда
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка является ведущей, т.е. инициирует отправку и получение сообщений обмена для текущей информационной системы.'");
		Иначе
			Элементы.ИнформационноеСообщение.Заголовок
				= НСтр("ru = 'Эта конечная точка является ведомой, т.е. выполняет отправку и получение сообщений обмена только по требованию текущей информационной системы.'");
		КонецЕсли;
		
		Элементы.СделатьЭтуКонечнуюТочкуВедомой.Видимость = Объект.Ведущая И Не Объект.Заблокирована;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Оповестить(ОбменСообщениямиКлиент.ИмяСобытияЗакрытаФормаКонечнойТочки());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = ОбменСообщениямиКлиент.ИмяСобытияУстановленаВедущаяКонечнаяТочка() Тогда
		
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СделатьЭтуКонечнуюТочкуВедомой(Команда)
	
	ПараметрыФормы = Новый Структура("КонечнаяТочка", Объект.Ссылка);
	
	ОткрытьФорму("ОбщаяФорма.УстановкаВедущейКонечнойТочки", ПараметрыФормы, ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры


