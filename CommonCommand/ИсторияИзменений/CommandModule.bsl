﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ 

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		Если ПараметрКоманды.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		СсылкаНаОбъект = ПараметрКоманды[0];
	Иначе
		СсылкаНаОбъект = ПараметрКоманды;
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ВыборХранимыхВерсий",
								Новый Структура("Ссылка", СсылкаНаОбъект),
								ПараметрыВыполненияКоманды.Источник,
								ПараметрыВыполненияКоманды.Уникальность,
								ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

