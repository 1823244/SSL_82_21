﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияБСП.Форма.Органайзер",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияБСП.Форма.Органайзер" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
