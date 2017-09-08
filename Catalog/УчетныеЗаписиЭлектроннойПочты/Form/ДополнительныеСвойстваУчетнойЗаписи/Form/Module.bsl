﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Ссылка = Параметры.Ссылка;
	
	Заполнить_СписокSMTPАутентификация_СП();
	Заполнить_СписокСпособSMTPАутентификации_СП();
	
	УчетнаяЗаписьСтруктура = Параметры.УчетнаяЗаписьСтруктура;
	
	ДлительностьОжиданияСервера = УчетнаяЗаписьСтруктура.ВремяОжидания;
	
	ОставлятьКопииСообщенийНаСервере = УчетнаяЗаписьСтруктура.ОставлятьКопииСообщенийНаСервере;
	ОставлятьКопииСообщенийЧислоДней = УчетнаяЗаписьСтруктура.ПериодХраненияСообщенийНаСервере;
	УдалятьСообщенияССервера		 = ?(ОставлятьКопииСообщенийЧислоДней = 0, Ложь, Истина);
	
	ПортSMTP = УчетнаяЗаписьСтруктура.ПортSMTP;
	ПортPOP3 = УчетнаяЗаписьСтруктура.ПортPOP3;
	
	СпособPOP3Аутентификации = УчетнаяЗаписьСтруктура.СпособPOP3Аутентификации;
	
	СпособSMTPАутентификации = УчетнаяЗаписьСтруктура.СпособSMTPАутентификации;
	ПользовательSMTP         = УчетнаяЗаписьСтруктура.ПользовательSMTP;
	ПарольSMTP               = УчетнаяЗаписьСтруктура.ПарольSMTP;
	
	SMTPАутентификация = УчетнаяЗаписьСтруктура.SMTPАутентификация;
	
	SMTPАутентификацияУстановлена = ?(SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.НеЗадано, Ложь, Истина);
	
	Элементы.ГруппаАутентификацияSMTP.ТекущаяСтраница = ?(SMTPАутентификация = Перечисления.ВариантыSMTPАутентификации.ЗадаетсяПараметрами,
															Элементы.ГруппаПараметры,
															Элементы.ГруппаПустаяСтраница);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик события "при изменении" элемента формы "SMTPАутентификация".
// Вызывает процедуру обновления группы дополнительных параметров
// аутентификации.
//
&НаКлиенте
Процедура SMTPАутентификацияПриИзменении(Элемент)
	
	УстановитьДополнительныеПараметрыПоSMTPАутентификации();
	
КонецПроцедуры

// Обработчик события "при изменении" элемента формы "ТребуетсяДополнительнаяSMTPАутентификация".
// Устанавливает параметры аутентификации "по умолчанию", а так же
// снимает их при снятии флага необходимости дополнительной SMTP аутентификации.
//
&НаКлиенте
Процедура SMTPАутентификацияУстановленаПриИзменении(Элемент)
	
	Если SMTPАутентификацияУстановлена Тогда
		Элементы.SMTPАутентификация.Доступность = Истина;
		СпособSMTPАутентификации = ?(СпособSMTPАутентификации = СпособSMTPАутентификации_БезАутентификации(),
		                             СпособSMTPАутентификации_ПоУмолчанию(),
		                             СпособSMTPАутентификации);
		SMTPАутентификация = SMTPАутентификация_АналогичноPOP3();
	Иначе
		Элементы.SMTPАутентификация.Доступность = Ложь;
		SMTPАутентификация = SMTPАутентификация_НеЗадано();
		СпособSMTPАутентификации = СпособSMTPАутентификации_БезАутентификации();
	КонецЕсли;
	
	УстановитьДополнительныеПараметрыПоSMTPАутентификации();
	
КонецПроцедуры

&НаКлиенте
Процедура ОставлятьКопииСообщенийНаСервереПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалятьСообщенияССервераПриИзменении(Элемент)
	
	УстановитьДоступностьЭлементовФормы();
	
	Если УдалятьСообщенияССервера Тогда
		ОставлятьКопииСообщенийЧислоДней = 1;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура УстановитьПортыПоУмолчаниюВыполнить()
	
	ПортSMTP = 25;
	ПортPOP3 = 110;
	
КонецПроцедуры

// Выполняет проверку корректности значений реквизитов формы и возвращает
// управление в вызывающую среду с дополнительными заполненными параметрами
// учетной записи.
// 
&НаКлиенте
Процедура ЗаполнитьДопПараметрыИВернутьсяВыполнить()
	
	Если SMTPАутентификацияУстановлена
	   И SMTPАутентификация <> SMTPАутентификация_АналогичноPOP3()
	   И SMTPАутентификация <> SMTPАутентификация_ЗадаетсяПараметрами()
	   И SMTPАутентификация <> SMTPАутентификация_POP3ПередSMTP() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		              НСтр("ru = 'Необходимо выбрать способ SMTP аутентификации'"), ,
		              "SMTPАутентификация");
		Возврат;
	КонецЕсли;
	
	Оповестить("УстановкаДополнительныхПараметровУчетнойЗаписи", ЗаполнитьДополнительныеПараметры(), Ссылка);
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Единая процедура для установки доступности элементов формы в зависимости от условий
//
&НаКлиенте
Процедура УстановитьДоступностьЭлементовФормы()
	
	Если ОставлятьКопииСообщенийНаСервере Тогда
		Элементы.УдалятьСообщенияССервера.Доступность = Истина;
		Если УдалятьСообщенияССервера Тогда
			Элементы.ОставлятьКопииСообщенийЧислоДней.Доступность = Истина;
		Иначе
			Элементы.ОставлятьКопииСообщенийЧислоДней.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Элементы.УдалятьСообщенияССервера.Доступность = Ложь;
		Элементы.ОставлятьКопииСообщенийЧислоДней.Доступность = Ложь;
	КонецЕсли;
	
	Если SMTPАутентификацияУстановлена Тогда
		Элементы.SMTPАутентификация.Доступность = Истина;
	Иначе
		Элементы.SMTPАутентификация.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Функция, формирующая параметры настроек перед передачей их в вызывающую среду.
//
// Возвращаемое значение:
// структура
// ключ "ПортSMTP", значение - число, порт SMTP
// ключ "ПортPOP3", значение - число, порт POP3
// ключ "ОставлятьКопииСообщенийНаСервере" - булево - признак того, что необходимо оставлять на сервере сообщения
// ключ "ПериодХраненияСообщенийНаСервере" - число - число дней, которое сообщение должно храниться на сервере
// ключ "ДлительностьОжиданияСервера", значение - число секунд ожидания успешного выполнения операции на сервере
// ключ "SMTPАутентификация", Перечисление.SMTPАутентификация
// ключ "ПользовательSMTP", значение - строка, имя пользователя SMTP аутентификации
// ключ "ПарольSMTP", значение - строка, пароль SMTP аутентификации
// ключ "СпособSMTPАутентификации"*, Перечисление.СпособSMTPАутентификации
//
// ключ "СпособPOP3Аутентификации" - Перечисление.СпособPOP3Аутентификации
//
// *- при аутентификации "АналогичноPOP3" тип аутентификации не устанавливается,
//    тем не менее происходит его копирование
//
// Все поля, при любых параметрах аутентификации заполняются. Таким образом в вызывающей
// среде остается только взять их как есть без дополнительной обработки.
//
&НаКлиенте
Функция ЗаполнитьДополнительныеПараметры()
	
	Результат = Новый Структура;
	
	Результат.Вставить("ПортSMTP", ПортSMTP);
	Результат.Вставить("ПортPOP3", ПортPOP3);
	
	Результат.Вставить("ОставлятьКопииСообщенийНаСервере", ОставлятьКопииСообщенийНаСервере);
	
	Если УдалятьСообщенияССервера Тогда
		ОставлятьКопииСообщенийЧислоДней = ОставлятьКопииСообщенийЧислоДней;
	Иначе
		ОставлятьКопииСообщенийЧислоДней = 0;
	КонецЕсли;
	
	Результат.Вставить("ПериодХраненияСообщенийНаСервере", ОставлятьКопииСообщенийЧислоДней);
	
	Результат.Вставить("ДлительностьОжиданияСервера", ДлительностьОжиданияСервера);
	
	Если SMTPАутентификацияУстановлена Тогда
		Результат.Вставить("SMTPАутентификация", SMTPАутентификация);
		Если SMTPАутентификация = (SMTPАутентификация_ЗадаетсяПараметрами()) Тогда
			Результат.Вставить("ПользовательSMTP", ПользовательSMTP);
			Результат.Вставить("ПарольSMTP", ПарольSMTP);
			Результат.Вставить("СпособSMTPАутентификации", СпособSMTPАутентификации);
		Иначе
			Результат.Вставить("ПользовательSMTP", "");
			Результат.Вставить("ПарольSMTP", "");
			Результат.Вставить("СпособSMTPАутентификации", СпособSMTPАутентификации_БезАутентификации());
		КонецЕсли;
	Иначе
		Результат.Вставить("SMTPАутентификация", SMTPАутентификация_НеЗадано());
		Результат.Вставить("ПользовательSMTP", "");
		Результат.Вставить("ПарольSMTP", "");
		Результат.Вставить("СпособSMTPАутентификации", СпособSMTPАутентификации_БезАутентификации());
	КонецЕсли;
	
	Результат.Вставить("СпособPOP3Аутентификации", СпособPOP3Аутентификации);
	
	Возврат Результат;
	
КонецФункции

// Процедура устанавливает видимость параметров аутентификации
// для выбора способа аутентификации "ЗаданыПараметры".
//
&НаКлиенте
Процедура УстановитьДополнительныеПараметрыПоSMTPАутентификации()
	
	Элементы.ГруппаАутентификацияSMTP.ТекущаяСтраница =
	                  ?(SMTPАутентификация = SMTPАутентификация_ЗадаетсяПараметрами(),
	                   Элементы.ГруппаПараметры,
	                   Элементы.ГруппаПустаяСтраница);
	
КонецПроцедуры

&НаСервере
Функция Заполнить_СписокSMTPАутентификация_СП()
	
	СписокSMTPАутентификация_СП.Добавить(Перечисления.ВариантыSMTPАутентификации.POP3ПередSMTP,
	                                     "POP3ПередSMTP");
	СписокSMTPАутентификация_СП.Добавить(Перечисления.ВариантыSMTPАутентификации.АналогичноPOP3,
	                                     "АналогичноPOP3");
	СписокSMTPАутентификация_СП.Добавить(Перечисления.ВариантыSMTPАутентификации.ЗадаетсяПараметрами,
	                                     "ЗадаетсяПараметрами");
	СписокSMTPАутентификация_СП.Добавить(Перечисления.ВариантыSMTPАутентификации.НеЗадано,
	                                     "НеЗадано");
	
КонецФункции

&НаКлиенте
Функция SMTPАутентификация_POP3ПередSMTP()
	
	Возврат СписокSMTPАутентификация_СП[0].Значение;
	
КонецФункции

&НаКлиенте
Функция SMTPАутентификация_АналогичноPOP3()
	
	Возврат СписокSMTPАутентификация_СП[1].Значение;
	
КонецФункции

&НаКлиенте
Функция SMTPАутентификация_ЗадаетсяПараметрами()
	
	Возврат СписокSMTPАутентификация_СП[2].Значение;
	
КонецФункции

&НаКлиенте
Функция SMTPАутентификация_НеЗадано()
	
	Возврат СписокSMTPАутентификация_СП[3].Значение;
	
КонецФункции

&НаСервере
Функция Заполнить_СписокСпособSMTPАутентификации_СП()
	
	СписокСпособSMTPАутентификации_СП.Добавить(Перечисления.СпособыSMTPАутентификации.CramMD5,
	                                     "CramMD5");
	СписокСпособSMTPАутентификации_СП.Добавить(Перечисления.СпособыSMTPАутентификации.Login,
	                                     "Login");
	СписокСпособSMTPАутентификации_СП.Добавить(Перечисления.СпособыSMTPАутентификации.Plain,
	                                     "Plain");
	СписокСпособSMTPАутентификации_СП.Добавить(Перечисления.СпособыSMTPАутентификации.БезАутентификации,
	                                     "БезАутентификации");
	СписокСпособSMTPАутентификации_СП.Добавить(Перечисления.СпособыSMTPАутентификации.ПоУмолчанию,
	                                     "ПоУмолчанию");
	
КонецФункции

&НаКлиенте
Функция СпособSMTPАутентификации_БезАутентификации()
	
	Возврат СписокСпособSMTPАутентификации_СП[3].Значение;
	
КонецФункции

&НаКлиенте
Функция СпособSMTPАутентификации_ПоУмолчанию()
	
	Возврат СписокСпособSMTPАутентификации_СП[4].Значение;
	
КонецФункции
