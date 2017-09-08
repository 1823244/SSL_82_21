﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с почтовыми сообщениями".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Интерфейсная клиентская функция, поддерживающая упрощенный вызов формы редактирования
// нового письма.
// Параметры
// Отправитель*  - СписокЗначений, СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - 
//                 учетная запись ,с которой может быть отправлено
//                 почтовое сообщение. Если тип список значений, тогда
//                   представление - наименование учетной записи,
//                   значение - ссылка на учетную запись
//
// Получатель      - СписокЗначений, Строка:
//                   если список значений, то представление - имя получателя
//                                            значение      - почтовый адрес
//                   если строка то список почтовых адресов,
//                   в формате правильного e-mail адреса*
//
// Тема            - Строка - тема письма
// Текст           - Строка - тело письма
//
// СписокФайлов    - СписокЗначений, где
//                   представление - строка - наименование вложения
//                   значение      - ДвоичныеДанные - двоичные данные вложения
//                                 - Строка - адрес файла во временном хранилище
//                                 - Строка - путь к файлу на клиенте
//
// УдалятьФайлыПослеОтправки - булево - удалять временные файлы после отправки сообщения
// ПисьмоДолжноСохраняться   - булево - должно ли письмо сохраняться (используется только
//                                      если встроена подсистема Взаимодействия)
//
Процедура ОткрытьФормуОтправкиПочтовогоСообщения(знач Отправитель = Неопределено,
												знач Получатель = Неопределено,
												знач Тема = "",
												знач Текст = "",
												знач СписокФайлов = Неопределено,
												знач УдалятьФайлыПослеОтправки = Ложь,
												знач ПисьмоДолжноСохраняться = Истина) Экспорт
	
	Если Не ЭлектроннаяПочтаВызовСервера.ЕстьДоступныеУчетныеЗаписиДляОтправки() Тогда
		ТекстСообщения = НСтр("ru = 'Для отправки письма требуется настройка учетной записи электронной почты.'");
		Предупреждение(ТекстСообщения);
		Возврат;
	КонецЕсли;

	Если ОбщегоНазначенияКлиентСервер.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия") 
		И СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИспользоватьПочтовыйКлиент Тогда
			МодульВзаимодействияКлиент = ОбщегоНазначенияКлиентСервер.ОбщийМодуль("ВзаимодействияКлиент");
			МодульВзаимодействияКлиент.ОткрытьФормуОтправкиПочтовогоСообщения(Отправитель,
				Получатель, Тема, Текст, СписокФайлов);
	Иначе
		ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель, Получатель,
			Тема,Текст, СписокФайлов, УдалятьФайлыПослеОтправки);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Интерфейсная клиентская функция, поддерживающая упрощенный вызов простой
// формы редактирования нового письма. При отправке письма через простую
// форму сообщения не сохраняются в информационной базе.
//
// Параметры см. к функции ОткрытьФормуОтправкиПочтовогоСообщения
//
Процедура ОткрытьПростуюФормуОтправкиПочтовогоСообщения(Отправитель,
			Получатель, Тема,Текст, СписокФайлов, УдалятьФайлыПослеОтправки) Экспорт
	
	ПараметрыПисьма = Новый Структура;
	
	ПараметрыПисьма.Вставить("УчетнаяЗапись", Отправитель);
	ПараметрыПисьма.Вставить("Кому", Получатель);
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Вложения", СписокФайлов);
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", УдалятьФайлыПослеОтправки);
	
	ОткрытьФорму("ОбщаяФорма.ОтправкаСообщения", ПараметрыПисьма);
	
КонецПроцедуры

// Выполняет проверку учетной записи.
//
// Параметры
// УчетнаяЗапись - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты - учетная запись,
//					которую нужно проверить.
//
Процедура ПроверитьУчетнуюЗапись(знач УчетнаяЗапись) Экспорт
	
	ОчиститьСообщения();
	
	Состояние(НСтр("ru = 'Проверка учетной записи'"),,НСтр("ru = 'Выполняется проверка учетной записи. Подождите...'"));
	
	Если ЭлектроннаяПочтаВызовСервера.ПарольЗадан(УчетнаяЗапись) Тогда
		ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, Неопределено);
	Иначе
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("УчетнаяЗапись", УчетнаяЗапись);
		ПараметрыФормы.Вставить("ПроверитьВозможностьОтправкиИПолучения", Истина);
		ОткрытьФорму("ОбщаяФорма.ПодтверждениеПароляУчетнойЗаписи", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

// Проверка учетной записи электронной почты.
//
// см. описание процедуры ЭлектроннаяПочта.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты.
//
Процедура ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр) Экспорт
	
	СообщениеОбОшибке = "";
	ДополнительноеСообщение = "";
	ЭлектроннаяПочтаВызовСервера.ПроверитьВозможностьОтправкиИПолученияЭлектроннойПочты(УчетнаяЗапись, ПарольПараметр, СообщениеОбОшибке, ДополнительноеСообщение);
	
	Если ЗначениеЗаполнено(СообщениеОбОшибке) Тогда
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Проверка параметров учетной записи завершилась с ошибками:
								   |%1'"), СообщениеОбОшибке ),,
						НСтр("ru = 'Проверка учетной записи'"));
	Иначе
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Проверка параметров учетной записи завершилась успешно. %1'"),
						ДополнительноеСообщение ),,
						НСтр("ru = 'Проверка учетной записи'"));
	КонецЕсли;
	
КонецПроцедуры
