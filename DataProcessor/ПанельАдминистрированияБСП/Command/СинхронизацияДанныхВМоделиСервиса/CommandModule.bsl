﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанныхДляАдминистратораАбонента",
			Новый Структура,
			ПараметрыВыполненияКоманды.Источник,
			"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанныхДляАдминистратораАбонента" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
			ПараметрыВыполненияКоманды.Окно);
		
	Иначе
		ОткрытьФорму(
			"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанныхДляАдминистратораСервиса",
			Новый Структура,
			ПараметрыВыполненияКоманды.Источник,
			"Обработка.ПанельАдминистрированияБСП.Форма.СинхронизацияДанныхДляАдминистратораСервиса" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
			ПараметрыВыполненияКоманды.Окно);
		
	КонецЕсли;
	
КонецПроцедуры
