﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
	ВидыСвойствНабора = УправлениеСвойствамиСлужебный.ВидыСвойствНабора(Объект.Ссылка);
	ИспользоватьДопРеквизиты = ВидыСвойствНабора.ДополнительныеРеквизиты;
	ИспользоватьДопСведения  = ВидыСвойствНабора.ДополнительныеСведения;
	
	Если ИспользоватьДопРеквизиты И ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных реквизитов и сведений)'")
		
	ИначеЕсли ИспользоватьДопРеквизиты Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных реквизитов)'")
		
	ИначеЕсли ИспользоватьДопСведения Тогда
		Заголовок = Объект.Наименование + " " + НСтр("ru = '(Набор дополнительных сведений)'")
	КонецЕсли;
	
	Если НЕ ИспользоватьДопРеквизиты И Объект.ДополнительныеРеквизиты.Количество() = 0 Тогда
		Элементы.ДополнительныеРеквизиты.Видимость = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьДопСведения И Объект.ДополнительныеСведения.Количество() = 0 Тогда
		Элементы.ДополнительныеСведения.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
