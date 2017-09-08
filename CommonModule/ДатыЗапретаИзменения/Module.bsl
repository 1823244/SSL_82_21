﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Даты запрета изменения".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Проверяет наличие запрета изменения элемента данных.
//  Для работы функции требуется настройка
// процедуры ДанныеДляПроверкиЗапретаИзменения
// модуля ДатыЗапретаИзмененияПереопределяемый.
//
//  Если Данные - полное имя объекта метаданных,
// тогда данные для проверки будут получены
// из базы данных через ИдентификаторДанных.
//  Если Данные - объект, тогда данные для проверки
// будут получены из экземпляра объекта или
// набора записей.
//  Если Данные - объект и задан ИдентификаторДанных,
// тогда будут выполнены две проверки, причем
// данные будут получены и из объекта/набора записей,
// и из базы данных через ИдентификаторДанных.
//
// Параметры:
//  Данные              - Строка (полное имя объекта метаданных),
//                        СправочникОбъект.<Имя>,
//                        ДокументОбъект.<Имя>,
//                        ПланВидовХарактеристикОбъект.<Имя>,
//                        ПланСчетовОбъект.<Имя>,
//                        ПланВидовРасчетаОбъект.<Имя>,
//                        БизнесПроцессОбъект.<Имя>,
//                        ЗадачаОбъект.<Имя>,
//                        ПланОбменаОбъект.<Имя>,
//                        РегистрСведенийНаборЗаписей.<Имя>,
//                        РегистрНакопленияНаборЗаписей.<Имя>,
//                        РегистрБухгалтерииНаборЗаписей.<Имя>,
//                        РегистрРасчетаНаборЗаписей.<Имя>.
//
//  ИдентификаторДанных - СправочникСсылка.<Имя>,
//                        ДокументСсылка.<Имя>,
//                        ПланВидовХарактеристикСсылка.<Имя>,
//                        ПланСчетовСсылка.<Имя>,
//                        ПланВидовРасчетаСсылка.<Имя>,
//                        БизнесПроцессСсылка.<Имя>,
//                        ЗадачаСсылка.<Имя>,
//                        ПланОбменаСсылка.<Имя>,
//                        РегистрСведенийНаборЗаписей.<Имя>.Отбор,
//                        РегистрНакопленияНаборЗаписей.<Имя>.Отбор,
//                        РегистрБухгалтерииНаборЗаписей.<Имя>.Отбор,
//                        РегистрРасчетаНаборЗаписей.<Имя>.Отбор.
//
//  СообщитьОЗапрете    - Булево, если передать Ложь, сообщение пользователю
//                        о запрете изменения данных не будет отправлено.
//
// Возвращаемое значение:
//  Булево.
//
Функция ИзменениеЗапрещено(Знач Данные,
                           Знач ИдентификаторДанных  = Неопределено,
                           Знач СообщитьОЗапрете     = Истина,
                           // Устарели. Следующие параметры устарели и будут удалены
                           // в следующей редакции БСП. Вместо используется функция ЗагрузкаЗапрещена.
                           Знач СтандартнаяОбработка = Истина,
                           Знач УзелПланаОбмена      = Неопределено,
                                НайденныеЗапреты     = Неопределено) Экспорт
	
	Возврат ДатыЗапретаИзмененияСлужебный.ИзменениеИлиЗагрузкаЗапрещена(
		Данные,
		ИдентификаторДанных,
		СообщитьОЗапрете,
		СтандартнаяОбработка,
		УзелПланаОбмена,
		НайденныеЗапреты);
	
КонецФункции

// Проверяет наличие запрета загрузки элемента данных.
//  Для работы функции требуется настройка
// процедуры ДанныеДляПроверкиЗапретаИзменения
// модуля ДатыЗапретаИзмененияПереопределяемый.
//
//  Данные              - СправочникОбъект.<Имя>,
//                        ДокументОбъект.<Имя>,
//                        ПланВидовХарактеристикОбъект.<Имя>,
//                        ПланСчетовОбъект.<Имя>,
//                        ПланВидовРасчетаОбъект.<Имя>,
//                        БизнесПроцессОбъект.<Имя>,
//                        ЗадачаОбъект.<Имя>,
//                        ПланОбменаОбъект.<Имя>,
//                        РегистрСведенийНаборЗаписей.<Имя>,
//                        РегистрНакопленияНаборЗаписей.<Имя>,
//                        РегистрБухгалтерииНаборЗаписей.<Имя>,
//                        РегистрРасчетаНаборЗаписей.<Имя>.
//
//  УзелПланаОбмена     - ПланыОбменаСсылка.<Имя плана обмена> узел,
//                        для которого будет выполнена проверка.
//
//  СообщениеОбОшибке   - Строка (возвращаемое значение) - описание запрета загрузки.
//
// Возвращаемое значение:
//  Булево.
//
Функция ЗагрузкаЗапрещена(Данные, УзелПланаОбмена, СообщениеОбОшибке = "") Экспорт
	
	ОбъектМетаданных = Данные.Метаданные();
	
	ИсточникиДанных = ДатыЗапретаИзмененияПовтИсп.ИсточникиДанныхДляПроверкиЗапретаИзменения(
		).НайтиСтроки(Новый Структура("Таблица", ОбъектМетаданных.ПолноеИмя()));
	
	Если ИсточникиДанных.Количество() = 0 Тогда
		Возврат Ложь; // Для текущего типа объекта не определены запреты по датам.
	КонецЕсли;
	
	Отказ = Ложь;
	НайденныеЗапреты = Новый Структура;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Данные,
		Отказ,
		ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных),
		,
		,
		Ложь,
		Ложь,
		УзелПланаОбмена,
		НайденныеЗапреты);
	
	Если Отказ Тогда
		СообщениеОбОшибке = НайденныеЗапреты.НайденЗапретЗагрузкиДанных;
	КонецЕсли;
	
	Возврат Отказ;
	
КонецФункции


// Обработчик события формы ПриЧтенииНаСервере, который
// встраивается в формы элементов данных
// (элементов справочников, документов, записей регистров, и др.),
// чтобы заблокировать форму при наличии запрета изменения.
//
// Параметры:
//  Форма               - УправляемаяФорма,
//
//  ИдентификаторДанных - СправочникСсылка.<Имя>,
//                        ДокументСсылка.<Имя>,
//                        ПланВидовХарактеристикСсылка.<Имя>,
//                        ПланСчетовСсылка.<Имя>,
//                        ПланВидовРасчетаСсылка.<Имя>,
//                        БизнесПроцессСсылка.<Имя>,
//                        ЗадачаСсылка.<Имя>,
//                        ПланОбменаСсылка.<Имя>,
//                        РегистрСведенийНаборЗаписей.Отбор,
//                        РегистрНакопленияНаборЗаписей.Отбор,
//                        РегистрБухгалтерииНаборЗаписей.Отбор,
//                        РегистрРасчетаНаборЗаписей.Отбор.
//
Функция ОбъектПриЧтенииНаСервере(Форма, ТекущийОбъект) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(ТекущийОбъект));
	ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
	
	Если ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных) Тогда
		// Приведение менеджера записи к набору записей с одной записью.
		МенеджерДанных = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		Источник = МенеджерДанных.СоздатьНаборЗаписей();
		Для каждого ЭлементОтбора Из Источник.Отбор Цикл
			ЭлементОтбора.Установить(ТекущийОбъект[ЭлементОтбора.Имя], Истина);
		КонецЦикла;
		ИдентификаторДанных = Источник.Отбор;
		ЗаполнитьЗначенияСвойств(Источник.Добавить(), ТекущийОбъект);
	Иначе
		Источник = ТекущийОбъект;
		ИдентификаторДанных = ТекущийОбъект.Ссылка;
	КонецЕсли;
	
	Если ДатыЗапретаИзмененияСлужебный.ПропуститьПроверкуДатЗапрета(
	         Источник, Ложь, Истина, Неопределено) Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Если ИзменениеЗапрещено(ПолноеИмя, ИдентификаторДанных, Ложь) Тогда
		Форма.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецФункции

// Добавляет строку описание источников данных для проверки запрета изменения.
// 
// Параметры:
//  Таблица     - Строка.
//  ПолеДаты    - Строка.
//  Раздел      - Строка.
//  ПолеОбъекта - Строка.
//
Процедура ДобавитьСтроку(Данные, Таблица, ПолеДаты, Раздел = "", ПолеОбъекта = "") Экспорт
	
	НоваяСтрока = Данные.Добавить();
	НоваяСтрока.Таблица     = Таблица;
	НоваяСтрока.ПолеДаты    = ПолеДаты;
	НоваяСтрока.Раздел      = Раздел;
	НоваяСтрока.ПолеОбъекта = ПолеОбъекта;
	
КонецПроцедуры

// Выполняет поиск дат запрета по проверяемым данным
// для авторизованного пользователя и/или узла плана обмена.
//
// Параметры:
//  ДанныеДляПроверки    - таблица, возвращаемая функцией
//                         ДатыЗапретаИзменения.ШаблонДанныхДляПроверки().
//
//  СообщитьОЗапрете     - Булево, выводит сообщение о найденных запретах
//                         при проверке данных.
//
//  ИдентификаторДанных  - Ссылка на объект данных для получения представления,
//                         используемого в сообщении о запрете.
//
//  СтандартнаяОбработка - Булево, если Ложь, проверка запрета изменения (для пользователей)
//                        будет пропущена.
//
//  УзелПланаОбмена      - Неопределено, ПланыОбменаСсылка.<Имя плана обмена> -
//                         если задать узел будет выполнена проверка запрета загрузки.
//
//  НайденныеЗапреты     - Структура (возвращаемое значение).
//                         Если найден запрет изменения данных, значит есть
//                         свойство НайденЗапретИзмененияДанных, если найден запрет
//                         загрузки данных, значит есть свойство НайденЗапретЗагрузкиДанных.
//
// Возвращаемое значение:
//  Булево
//
Функция НайденЗапретИзмененияДанных(Знач ДанныеДляПроверки,
                                    Знач СообщитьОЗапрете,
                                    Знач ИдентификаторДанных  = Неопределено,
                                    Знач СтандартнаяОбработка = Истина,
                                    Знач УзелПланаОбмена      = Неопределено,
                                         НайденныеЗапреты     = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТипЗнч(ДанныеДляПроверки) = Тип("Структура") Тогда
		ИдентификаторДанных = ДанныеДляПроверки.ИдентификаторДанных;
		ТаблицаДанных       = ДанныеДляПроверки.Таблица;
		ДанныеДляПроверки = ПолучитьДанныеДляПроверки(ДанныеДляПроверки);
	Иначе
		Если ИдентификаторДанных = Неопределено Тогда
			ТаблицаДанных = Неопределено;
		Иначе
			ТаблицаДанных = ИдентификаторДанных.Метаданные().ПолноеИмя();
		КонецЕсли;
	КонецЕсли;
	
	// Приведение пустых ссылок объектов к единому значению Неопределено.
	Для каждого Строка Из ДанныеДляПроверки Цикл
		Если НЕ ЗначениеЗаполнено(Строка.Объект) Тогда
			Строка.Объект = Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	// Свертка лишних строк, чтобы сократить число проверок и сообщений.
	ДанныеДляПроверки.Свернуть("Дата, Раздел, Объект");
	// Назначение ключей для отдельных проверок.
	ДанныеДляПроверки.Колонки.Добавить("КлючСтроки", Новый ОписаниеТипов("Число"));
	ТекущийКлючСтроки = 0;
	Для каждого Строка Из ДанныеДляПроверки Цикл
		Строка.КлючСтроки = ТекущийКлючСтроки;
		ТекущийКлючСтроки = ТекущийКлючСтроки + 1;
	КонецЦикла;
	
	СвойстваВстраивания = ДатыЗапретаИзмененияПовтИсп.СвойстваРазделов();
	
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ДанныеДляПроверки",     ДанныеДляПроверки);
		Запрос.УстановитьПараметр("БезРазделовИОбъектов",  СвойстваВстраивания.БезРазделовИОбъектов);
		Запрос.УстановитьПараметр("ВсеРазделыБезОбъектов", СвойстваВстраивания.ВсеРазделыБезОбъектов);
		Запрос.УстановитьПараметр("ЕдинственныйРаздел",    СвойстваВстраивания.ЕдинственныйРаздел);
		Запрос.УстановитьПараметр("ПервыйРаздел",          ?(СвойстваВстраивания.ЕдинственныйРаздел,
		                                                     СвойстваВстраивания.ТипыОбъектовРазделов[0].Раздел,
		                                                     Неопределено));
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ДанныеДляПроверки.Раздел,
		|	ДанныеДляПроверки.Объект,
		|	ДанныеДляПроверки.Дата,
		|	ДанныеДляПроверки.КлючСтроки
		|ПОМЕСТИТЬ НачальныеДанные
		|ИЗ
		|	&ДанныеДляПроверки КАК ДанныеДляПроверки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Данные.Раздел,
		|	Данные.Объект,
		|	МИНИМУМ(Данные.Дата) КАК Дата,
		|	МИНИМУМ(Данные.КлючСтроки) КАК КлючСтроки
		|ПОМЕСТИТЬ ДанныеДляПроверки
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВЫБОР
		|			КОГДА &БезРазделовИОбъектов
		|				ТОГДА ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
		|			КОГДА &ЕдинственныйРаздел
		|				ТОГДА &ПервыйРаздел
		|			ИНАЧЕ НачальныеДанные.Раздел
		|		КОНЕЦ КАК Раздел,
		|		ВЫБОР
		|			КОГДА &БезРазделовИОбъектов
		|				ТОГДА ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
		|			ИНАЧЕ ВЫБОР
		|					КОГДА &ВсеРазделыБезОбъектов
		|							ИЛИ НачальныеДанные.Объект = НЕОПРЕДЕЛЕНО
		|						ТОГДА ВЫБОР
		|								КОГДА &ЕдинственныйРаздел
		|									ТОГДА &ПервыйРаздел
		|								ИНАЧЕ НачальныеДанные.Раздел
		|							КОНЕЦ
		|					ИНАЧЕ НачальныеДанные.Объект
		|				КОНЕЦ
		|		КОНЕЦ КАК Объект,
		|		НачальныеДанные.Дата КАК Дата,
		|		НачальныеДанные.КлючСтроки КАК КлючСтроки
		|	ИЗ
		|		НачальныеДанные КАК НачальныеДанные) КАК Данные
		|
		|СГРУППИРОВАТЬ ПО
		|	Данные.Раздел,
		|	Данные.Объект
		|
		|ИМЕЮЩИЕ
		|	(НЕ(Данные.Объект <> Данные.Раздел
		|			И ТИПЗНАЧЕНИЯ(Данные.Объект) = ТИП(ПланВидовХарактеристик.РазделыДатЗапретаИзменения))) И
		|	(НЕ(Данные.Объект <> Данные.Раздел
		|			И Данные.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)))";
		Запрос.Выполнить();
		
		НайденныеЗапреты = Новый Структура;
		Запрос.УстановитьПараметр("ПустыеСсылкиУзловПлановОбмена", СвойстваВстраивания.ПустыеСсылкиУзловПлановОбмена);
		Сообщение = "";
		
		Если СтандартнаяОбработка Тогда
			
			Запрос.УстановитьПараметр("ВидНазначенияДатЗапретаДляВсех",
				Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей);
			
			Запрос.УстановитьПараметр("Пользователь", Пользователи.АвторизованныйПользователь());
			
			Если НайденЗапретИзмененияИлиЗагрузкиДанных(
					Запрос,
					СообщитьОЗапрете,
					ИдентификаторДанных,
					ТаблицаДанных,
					СвойстваВстраивания,
					Ложь,
					Сообщение) Тогда
					
				НайденныеЗапреты.Вставить("НайденЗапретИзмененияДанных", Сообщение);
			КонецЕсли;
		КонецЕсли;
		
		Если УзелПланаОбмена <> Неопределено Тогда
			
			Запрос.УстановитьПараметр("ВидНазначенияДатЗапретаДляВсех",
				Перечисления.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз);
			
			Запрос.УстановитьПараметр("Пользователь", УзелПланаОбмена);
			
			Если НайденЗапретИзмененияИлиЗагрузкиДанных(
					Запрос,
					СообщитьОЗапрете,
					ИдентификаторДанных,
					ТаблицаДанных,
					СвойстваВстраивания,
					Истина,
					Сообщение) Тогда
					
				НайденныеЗапреты.Вставить("НайденЗапретЗагрузкиДанных", Сообщение);
			КонецЕсли;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат НайденныеЗапреты.Количество() > 0;
	
КонецФункции

// Возвращает готовую пустую таблицу значений (с колонками Дата, Раздел, Объект)
// для заполнения и последующей передачи в функцию
// ДатыЗапретаИзменения.НайденЗапретИзмененияДанных().
//
Функция ШаблонДанныхДляПроверки() Экспорт
	
	Возврат ДатыЗапретаИзмененияПовтИсп.ШаблонДанныхДляПроверки().Скопировать();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики подписок на события

// Обработчик подписки на событие ПередЗаписью для типов:
//  СправочникОбъект,
//  ПланВидовХарактеристикОбъект,
//  ПланСчетовОбъект,
//  ПланВидовРасчетаОбъект,
//  БизнесПроцессОбъект,
//  ЗадачаОбъект,
//  ПланОбменаОбъект.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для типа ДокументОбъект.
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюДокумента(
		Источник,
		Отказ,
		РежимЗаписи,
		РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для типов:
//  РегистрСведенийНаборЗаписей,
//  РегистрНакопленияНаборЗаписей.
//
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписей(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для типа РегистрБухгалтерииНаборЗаписей.
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраБухгалтерии(
		Источник,
		Отказ,
		РежимЗаписи) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ, Истина);
	
КонецПроцедуры

// Обработчик подписки на событие ПередЗаписью для типа РегистрРасчетаНаборЗаписей.
Процедура ПроверитьДатуЗапретаИзмененияПередЗаписьюНабораЗаписейРегистраРасчета(
		Источник,
		Отказ,
		Замещение,
		ТолькоЗапись,
		ЗаписьФактическогоПериодаДействия,
		ЗаписьПерерасчетов) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ, Истина, Замещение);
	
КонецПроцедуры

// Обработчик подписки на событие ПередУдалением для типов:
//  СправочникОбъект,
//  ДокументОбъект,
//  ПланВидовХарактеристикОбъект,
//  ПланСчетовОбъект,
//  ПланВидовРасчетаОбъект,
//  БизнесПроцессОбъект,
//  ЗадачаОбъект,
//  ПланОбменаОбъект.
//
Процедура ПроверитьДатуЗапретаИзмененияПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	
	ДатыЗапретаИзмененияСлужебный.ПроверитьДатыЗапретаИзмененияЗагрузкиДанных(
		Источник, Отказ, , , Истина);
	
КонецПроцедуры

// Устарела. Будет удалена в следующей редакции БСП.
// Следует использовать функции ЗагрузкаЗапрещена и ИзменениеЗапрещено.
//
Процедура ВыполнитьПроверкуДатыЗапретаИзменения(Источник, Отказ) Экспорт
	
	Если ИзменениеЗапрещено(Источник) Тогда
		Отказ = Истина;
	ИначеЕсли ЗагрузкаЗапрещена(Источник, Неопределено) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьДанныеДляПроверки(ПредварительныеДанные)
	
	ДанныеДляПроверки = ШаблонДанныхДляПроверки();
	
	ИсточникиДанныхТаблиц = ДатыЗапретаИзмененияПовтИсп.ИсточникиДанныхДляПроверкиЗапретаИзменения();
	
	Отбор = Новый Структура("Таблица", ПредварительныеДанные.Таблица);
	ИсточникиДанных = ИсточникиДанныхТаблиц.НайтиСтроки(Отбор);
	
	Если ИсточникиДанных.Количество() = 0 Тогда
		ВызватьИсключение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для проверки запрета изменения не найдены
			           |источники данных для таблицы ""%1"".'"),
			Отбор.Таблица));
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПредварительныеДанные.Таблица);
	
	ЭтоНаборЗаписей = ОбщегоНазначения.ЭтоРегистр(ОбъектМетаданных);
	КлассОМ = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Отбор.Таблица, ".")[0];
	
	ЗначенияПолей = Неопределено;
	
	НачатьТранзакцию();
	Попытка
		Если ПредварительныеДанные.ИдентификаторДанных <> Неопределено Тогда
			
			Если ЭтоНаборЗаписей Тогда
				// Заполнение значений полей из базы данных.
				Поля = ДатыЗапретаИзмененияСлужебный.ПолучитьПоляРегистра(
					ИсточникиДанных, Отбор.Таблица);
				
				Запрос = Новый Запрос;
				Запрос.Текст =
				"ВЫБРАТЬ
				|	&Поля
				|ИЗ
				|	&Таблица КАК Таблица
				|ГДЕ
				|	&УсловиеОтбора";
				ВставитьПараметрыИУсловиеОтбора(Запрос, ПредварительныеДанные.ИдентификаторДанных);
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Поля",    Поля);
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", Отбор.Таблица);
				ЗначенияПолей = Запрос.Выполнить().Выгрузить();
				ЗначенияПолей.Свернуть(Поля);
				
			ИначеЕсли ЗначениеЗаполнено(ПредварительныеДанные.ИдентификаторДанных) Тогда
				// Заполнение значений полей из базы данных.
				ЗначенияПолей = ДатыЗапретаИзмененияСлужебный.ПолучитьСтруктуруПолейОбъекта(
					ОбъектМетаданных, ИсточникиДанных, Отбор.Таблица);
				// Установка значений полей.
				Поля = "";
				Для каждого Поле Из ЗначенияПолей Цикл
					Если ОбъектМетаданных.ТабличныеЧасти.Найти(Поле.Ключ) <> Неопределено Тогда
						Поля = Поля + Поле.Ключ + ".(" + Поле.Значение + "),";
					Иначе
						Поля = Поля + Поле.Ключ + ",";
					КонецЕсли;
				КонецЦикла;
				Поля = Лев(Поля, СтрДлина(Поля)-1);
				Запрос = Новый Запрос;
				Запрос.Текст =
				"ВЫБРАТЬ
				|	&Поля
				|ИЗ
				|	&Таблица КАК Таблица
				|ГДЕ
				|	Таблица.Ссылка = &Ссылка";
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Поля",    Поля);
				Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Таблица", Отбор.Таблица);
				Запрос.УстановитьПараметр("Ссылка", ПредварительныеДанные.ИдентификаторДанных);
				ДанныеИзБазы = Запрос.Выполнить().Выгрузить();
				Для каждого Поле Из ЗначенияПолей Цикл
					Если ОбъектМетаданных.ТабличныеЧасти.Найти(Поле.Ключ) <> Неопределено Тогда
						Поля = Поле.Значение;
						ЗначенияПолей[Поле.Ключ] = ДанныеИзБазы[0][Поле.Ключ].Скопировать(, Поля);
						ЗначенияПолей[Поле.Ключ].Свернуть(Поля);
					Иначе
						ЗначенияПолей[Поле.Ключ] = ДанныеИзБазы[0][Поле.Ключ];
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
		
		Если ПредварительныеДанные.ЗначенияПолейИзОбъекта <> Неопределено Тогда
			ДобавитьДанныеДляПроверки(
				ДанныеДляПроверки,
				ИсточникиДанных,
				ПредварительныеДанные.ЗначенияПолейИзОбъекта,
				ЭтоНаборЗаписей,
				ОбъектМетаданных);
		КонецЕсли;
		
		Если ЗначенияПолей <> Неопределено Тогда
			ДобавитьДанныеДляПроверки(
				ДанныеДляПроверки,
				ИсточникиДанных,
				ЗначенияПолей,
				ЭтоНаборЗаписей,
				ОбъектМетаданных);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат ДанныеДляПроверки;
	
КонецФункции

Процедура ДобавитьДанныеДляПроверки(Знач ДанныеДляПроверки,
                                    Знач ИсточникиДанных,
                                    Знач ЗначенияПолей,
                                    Знач ЭтоНаборЗаписей,
                                    Знач ОбъектМетаданных)
	
	Для каждого ИсточникДанных Из ИсточникиДанных Цикл
		Если ЭтоНаборЗаписей Тогда
			Для каждого Строка Из ЗначенияПолей Цикл
				ДобавитьСтрокуДанных(Строка, Строка, ИсточникДанных, ДанныеДляПроверки);
			КонецЦикла;
		Иначе
			ДопИсточникДанных = Новый Структура("ПолеДаты, Раздел, ПолеОбъекта, Таблица");
			ЗаполнитьЗначенияСвойств(ДопИсточникДанных, ИсточникДанных);
			ТЧПоляДаты = "";
			ПозицияТочки = Найти(ДопИсточникДанных.ПолеДаты, ".");
			Если ПозицияТочки <> 0 Тогда
				ТЧПоляДаты = Лев( ДопИсточникДанных.ПолеДаты, ПозицияТочки-1);
				Если ОбъектМетаданных.ТабличныеЧасти.Найти(ТЧПоляДаты) = Неопределено Тогда
					ТЧПоляДаты = "";
				Иначе
					ДопИсточникДанных.ПолеДаты = Сред(ДопИсточникДанных.ПолеДаты, ПозицияТочки+1);
				КонецЕсли;
			КонецЕсли;
			ТЧПоляОбъекта = "";
			ПолеОбъекта = "";
			Если ЗначениеЗаполнено(ДопИсточникДанных.ПолеОбъекта) Тогда
				ПозицияТочки = Найти(ДопИсточникДанных.ПолеОбъекта, ".");
				Если ПозицияТочки <> 0 Тогда
					ТЧПоляОбъекта = Лев( ДопИсточникДанных.ПолеОбъекта, ПозицияТочки-1);
					Если ОбъектМетаданных.ТабличныеЧасти.Найти(ТЧПоляОбъекта) = Неопределено Тогда
						ТЧПоляОбъекта = "";
					Иначе
						ДопИсточникДанных.ПолеОбъекта = Сред(
							ДопИсточникДанных.ПолеОбъекта, ПозицияТочки + 1);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			Если ЗначениеЗаполнено(ТЧПоляДаты) И ЗначениеЗаполнено(ТЧПоляОбъекта) Тогда
				Если ТЧПоляДаты = ТЧПоляОбъекта Тогда
					Для каждого Строка Из ЗначенияПолей[ТЧПоляДаты] Цикл
						ДобавитьСтрокуДанных(Строка, Строка, ДопИсточникДанных, ДанныеДляПроверки);
					КонецЦикла;
				Иначе
					Для каждого СтрокаДаты Из ЗначенияПолей[ТЧПоляДаты] Цикл
						Для каждого СтрокаОбъекта Из ЗначенияПолей[ТЧПоляОбъекта] Цикл
							ДобавитьСтрокуДанных(
								СтрокаДаты, СтрокаОбъекта, ДопИсточникДанных, ДанныеДляПроверки);
						КонецЦикла;
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли ЗначениеЗаполнено(ТЧПоляДаты) Тогда
				Для каждого Строка Из ЗначенияПолей[ТЧПоляДаты] Цикл
					ДобавитьСтрокуДанных(
						Строка, ЗначенияПолей, ДопИсточникДанных, ДанныеДляПроверки);
				КонецЦикла;
			ИначеЕсли ЗначениеЗаполнено(ТЧПоляОбъекта) Тогда
				Для каждого Строка Из ЗначенияПолей[ТЧПоляОбъекта] Цикл
					ДобавитьСтрокуДанных(ЗначенияПолей, Строка, ДопИсточникДанных, ДанныеДляПроверки);
				КонецЦикла;
			Иначе
				ДобавитьСтрокуДанных(ЗначенияПолей, ЗначенияПолей, ДопИсточникДанных, ДанныеДляПроверки);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьСтрокуДанных(Знач СтрокаДаты,
                               Знач СтрокаОбъекта,
                               Знач ИсточникДанных,
                               Знач ДанныеДляПроверки)
	
	НоваяСтрока = ДанныеДляПроверки.Добавить();
	УстановитьЗначениеПоля(СтрокаДаты, НоваяСтрока.Дата, ИсточникДанных.ПолеДаты);
	
	Если ЗначениеЗаполнено(ИсточникДанных.Раздел) Тогда
		НоваяСтрока.Раздел = ПланыВидовХарактеристик.РазделыДатЗапретаИзменения[
			ИсточникДанных.Раздел];
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИсточникДанных.ПолеОбъекта) Тогда
		УстановитьЗначениеПоля(СтрокаОбъекта, НоваяСтрока.Объект, ИсточникДанных.ПолеОбъекта)
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначениеПоля(Знач Строка, ПолеДанных, Знач ПолеИсточника)
	
	ПозицияТочки = Найти(ПолеИсточника, ".");
	Если ПозицияТочки = 0 Тогда
		ПолеДанных = Строка[ПолеИсточника];
	Иначе
		Значение = Строка[Лев(ПолеИсточника, ПозицияТочки-1)];
		Реквизит = Сред(ПолеИсточника, ПозицияТочки+1);
		ПолеДанных = ПолучитьЗначениеРеквизита(Значение, Реквизит);
	КонецЕсли;
	
КонецПроцедуры

Функция НайденЗапретИзмененияИлиЗагрузкиДанных(Запрос,
                                               СообщитьОЗапрете,
                                               ИдентификаторДанных,
                                               ТаблицаДанных,
                                               СвойстваВстраивания,
                                               ПоискЗапретовЗагрузки,
                                               Текст)
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДляПроверки.КлючСтроки,
	|	ДатыЗапретаИзменения.Раздел,
	|	ДатыЗапретаИзменения.Объект,
	|	ДанныеДляПроверки.Дата,
	|	ДатыЗапретаИзменения.Пользователь,
	|	ДатыЗапретаИзменения.ДатаЗапрета,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Перечисление.ВидыНазначенияДатЗапрета)
	|			ТОГДА 0
	|		КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыПользователей)
	|			ТОГДА 1
	|		КОГДА ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|			ТОГДА 1
	|		КОГДА ДатыЗапретаИзменения.Пользователь В (&ПустыеСсылкиУзловПлановОбмена)
	|			ТОГДА 1
	|		ИНАЧЕ 10
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ДатыЗапретаИзменения.Объект = ДатыЗапретаИзменения.Раздел
	|			ТОГДА 0
	|		ИНАЧЕ 100
	|	КОНЕЦ + ВЫБОР
	|		КОГДА ДатыЗапретаИзменения.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
	|			ТОГДА 0
	|		ИНАЧЕ 1000
	|	КОНЕЦ КАК Приоритет
	|ПОМЕСТИТЬ ДатыЗапретаБезУчетаПриоритета
	|ИЗ
	|	ДанныеДляПроверки КАК ДанныеДляПроверки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
	|		ПО (ДатыЗапретаИзменения.Раздел В (ДанныеДляПроверки.Раздел, ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)))
	|			И (ДатыЗапретаИзменения.Объект В (ДанныеДляПроверки.Объект, ДатыЗапретаИзменения.Раздел))
	|			И (ВЫБОР
	|				КОГДА ДатыЗапретаИзменения.Пользователь = &ВидНазначенияДатЗапретаДляВсех
	|					ТОГДА ИСТИНА
	|				КОГДА ДатыЗапретаИзменения.Пользователь = &Пользователь
	|						ИЛИ ДатыЗапретаИзменения.Пользователь В (&ПустыеСсылкиУзловПлановОбмена)
	|							И ТИПЗНАЧЕНИЯ(ДатыЗапретаИзменения.Пользователь) = ТИПЗНАЧЕНИЯ(&Пользователь)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ДатыЗапретаИзменения.Пользователь В
	|						(ВЫБРАТЬ
	|							СоставыГруппПользователей.ГруппаПользователей
	|						ИЗ
	|							РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|						ГДЕ
	|							СоставыГруппПользователей.Пользователь = &Пользователь)
	|			КОНЕЦ)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляПроверки.Раздел,
	|	ДанныеДляПроверки.Объект,
	|	ДанныеДляПроверки.Дата,
	|	ДанныеДляПроверки.КлючСтроки
	|ИЗ
	|	ДанныеДляПроверки КАК ДанныеДляПроверки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДатыЗапрета.КлючСтроки КАК КлючСтроки,
	|	ДатыЗапрета.Раздел,
	|	ДатыЗапрета.Объект,
	|	ДатыЗапрета.Пользователь,
	|	ДатыЗапрета.ДатаЗапрета
	|ИЗ
	|	ДатыЗапретаБезУчетаПриоритета КАК ДатыЗапрета
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ДатыЗапрета.КлючСтроки КАК КлючСтроки,
	|			ДатыЗапрета.Приоритет КАК Приоритет,
	|			МАКСИМУМ(ДатыЗапрета.ДатаЗапрета) КАК ДатаЗапрета
	|		ИЗ
	|			ДатыЗапретаБезУчетаПриоритета КАК ДатыЗапрета
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					ДатыЗапрета.КлючСтроки КАК КлючСтроки,
	|					МАКСИМУМ(ДатыЗапрета.Приоритет) КАК Приоритет
	|				ИЗ
	|					ДатыЗапретаБезУчетаПриоритета КАК ДатыЗапрета
	|				
	|				СГРУППИРОВАТЬ ПО
	|					ДатыЗапрета.КлючСтроки) КАК МаксимальныеПриоритет
	|				ПО ДатыЗапрета.КлючСтроки = МаксимальныеПриоритет.КлючСтроки
	|					И ДатыЗапрета.Приоритет = МаксимальныеПриоритет.Приоритет
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ДатыЗапрета.КлючСтроки,
	|			ДатыЗапрета.Приоритет) КАК ПриоритетныеДатыЗапрета
	|		ПО ДатыЗапрета.КлючСтроки = ПриоритетныеДатыЗапрета.КлючСтроки
	|			И ДатыЗапрета.Приоритет = ПриоритетныеДатыЗапрета.Приоритет
	|			И ДатыЗапрета.ДатаЗапрета = ПриоритетныеДатыЗапрета.ДатаЗапрета
	|ГДЕ
	|	ДатыЗапрета.ДатаЗапрета >= ДатыЗапрета.Дата
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючСтроки
	|ИТОГИ ПО
	|	КлючСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ ДатыЗапретаБезУчетаПриоритета";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ЗапретыДанных = РезультатыЗапроса[2].Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Если ЗапретыДанных.Строки.Количество() > 0 Тогда
		
		Проверки = РезультатыЗапроса[1].Выгрузить();
		Текст = ПолучитьПредставлениеДанных(ИдентификаторДанных, ТаблицаДанных);
		Если ЗначениеЗаполнено(Текст) Тогда
			Если ПоискЗапретовЗагрузки Тогда
				Текст = Текст
					+ НСтр("ru = ' запрещено загружать в запрещенный период.'")
					+ Символы.ПС
					+ Символы.ПС;
			Иначе
				Текст = Текст
					+ НСтр("ru = ' запрещено изменять или перемещать в запрещенный период.'")
					+ Символы.ПС
					+ Символы.ПС;
			КонецЕсли;
		КонецЕсли;
		
		Для каждого ОписаниеЗапретов Из ЗапретыДанных.Строки Цикл
			Запреты  = ОписаниеЗапретов.Строки;
			Проверка = Проверки.Найти(ОписаниеЗапретов.КлючСтроки, "КлючСтроки");
			Если Проверка.Раздел = Проверка.Объект Тогда
				Если Проверка.Раздел = ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка() Тогда
					Текст = Текст + НСтр("ru = 'Дате %1'");
				Иначе
					Текст = Текст + НСтр("ru = 'Дате %1 по разделу ""%2""'");
				КонецЕсли;
			ИначеЕсли СвойстваВстраивания.ЕдинственныйРаздел Тогда
				Текст = Текст + НСтр("ru = 'Дате %1 по объекту ""%3""'");
			Иначе
				Текст = Текст + НСтр("ru = 'Дате %1 по объекту ""%3"" раздела ""%2""'");
			КонецЕсли;
			Текст = Текст + " ";
			Если Запреты.Количество() = 1 Тогда
				Текст = Текст + НСтр("ru = 'соответствует запрет изменения данных'") + " ";
			Иначе
				Текст = Текст + НСтр("ru = 'соответствуют запреты изменения данных:'") + Символы.ПС;
			КонецЕсли;
			Для каждого Запрет Из Запреты Цикл
				Текст = Текст + ?(Запреты.Количество() = 1, "", Символы.ПС + "- ");
				Если Запрет.Пользователь = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей Тогда
					Текст = Текст + НСтр("ru = 'для всех пользователей'");
					
				ИначеЕсли Запрет.Пользователь = Перечисления.ВидыНазначенияДатЗапрета.ДляВсехИнформационныхБаз Тогда
					Текст = Текст + НСтр("ru = 'для всех информационных баз'");
					
				ИначеЕсли ТипЗнч(Запрет.Пользователь) = Тип("СправочникСсылка.ГруппыПользователей")
				      ИЛИ ТипЗнч(Запрет.Пользователь) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
					Текст = Текст + НСтр("ru = 'для группы пользователей ""%4""'");
					
				ИначеЕсли ТипЗнч(Запрет.Пользователь) = Тип("СправочникСсылка.Пользователи")
				      ИЛИ ТипЗнч(Запрет.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
					Текст = Текст + НСтр("ru = 'для пользователя ""%4""'");
					
				ИначеЕсли ЗначениеЗаполнено(Запрет.Пользователь) Тогда
					Текст = Текст + НСтр("ru = 'для информационной базы ""%4""'");
				Иначе
					Текст = Текст + НСтр("ru = 'для всех информационных баз ""%6""'");
				КонецЕсли;
				Текст = Текст + " " + НСтр("ru = 'по %5'");
				Если НЕ СвойстваВстраивания.БезРазделовИОбъектов Тогда
					Если ЗначениеЗаполнено(Запрет.Раздел) Тогда
						Если Запрет.Объект = Запрет.Раздел Тогда
							Текст = Текст + " " + НСтр("ru = '(запрет установлен на раздел ""%2"")'");
						ИначеЕсли СвойстваВстраивания.ЕдинственныйРаздел Тогда
							Текст = Текст + " " + НСтр("ru = '(запрет установлен на объект ""%3"")'");
						Иначе
							Текст = Текст + " " + НСтр("ru = '(запрет установлен на объект ""%3"" раздела ""%2"")'");
						КонецЕсли;
					Иначе
						Текст = Текст + " " + НСтр("ru = '(установлена общая дата запрета)'");
					КонецЕсли;
				КонецЕсли;
				Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						Текст,
						Формат(Проверка.Дата, "ДЛФ=Д"),
						Проверка.Раздел,
						Проверка.Объект,
						Запрет.Пользователь,
						Формат(Запрет.ДатаЗапрета, "ДЛФ=Д"),
						Запрет.Пользователь.Метаданные().Представление()) + Символы.ПС;
			КонецЦикла;
			Текст = Текст + Символы.ПС;
		КонецЦикла;
		
		Если СообщитьОЗапрете Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		КонецЕсли;
		
		Если ТранзакцияАктивна() Тогда
			// Если поиск запретов выполняется в транзакции, а не ПриЧтенииНаСервере,
			// тогда выполняется запись в журнал регистрации.
			ЗаписьЖурналаРегистрации(
				?(ПоискЗапретовЗагрузки,
				  НСтр("ru = 'Даты запрета изменения.Найдены запреты загрузки'",
				       ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				  НСтр("ru = 'Даты запрета изменения.Найдены запреты изменения'",
				       ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				,
				,
				Текст,
				РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		КонецЕсли;
	КонецЕсли;
	
	Возврат ЗапретыДанных.Строки.Количество() > 0;
	
КонецФункции

Функция ПолучитьЗначениеРеквизита(Ссылка, ИмяРеквизита)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ЕстьNULL(" + ИмяРеквизита + ", Неопределено) КАК ЗначениеРеквизита
		|ИЗ
		|	" + Ссылка.Метаданные().ПолноеИмя() + " КАК Таблица
		|ГДЕ
		|	Таблица.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ЗначениеРеквизита;
	
КонецФункции

Функция ПолучитьПредставлениеДанных(ИдентификаторДанных, ТаблицаДанных)
	
	ПредставлениеДанных = "";
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ТаблицаДанных);
	
	Если Метаданные.РегистрыСведений.Содержит(ОбъектМетаданных) Тогда
		ПредставлениеДанных = НСтр("ru = 'Записи регистра сведений ""%1""'");
		
	ИначеЕсли Метаданные.РегистрыНакопления.Содержит(ОбъектМетаданных) Тогда
		ПредставлениеДанных = НСтр("ru = 'Записи регистра накопления ""%1""'");
		
	ИначеЕсли Метаданные.РегистрыБухгалтерии.Содержит(ОбъектМетаданных) Тогда
		ПредставлениеДанных = НСтр("ru = 'Записи регистра бухгалтерии ""%1""'");
		
	ИначеЕсли Метаданные.РегистрыРасчета.Содержит(ОбъектМетаданных) Тогда
		ПредставлениеДанных = НСтр("ru = 'Записи регистра расчета ""%1""'");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПредставлениеДанных) Тогда
		
		КоличествоПолей = 0;
		Для каждого ЭлементОтбора Из ИдентификаторДанных Цикл
			КоличествоПолей = КоличествоПолей + 1;
		КонецЦикла;
		
		Если КоличествоПолей = 1 Тогда
			ПредставлениеДанных = ПредставлениеДанных
				+ " " + НСтр("ru = 'с полем'")  + " " + Строка(ИдентификаторДанных);
			
		ИначеЕсли КоличествоПолей > 1 Тогда
			ПредставлениеДанных = ПредставлениеДанных
				+ " " + НСтр("ru = 'с полями'") + " " + Строка(ИдентификаторДанных);
		КонецЕсли;
	Иначе
		Если Метаданные.Справочники.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'Элемент справочника ""%1""'");
		
		ИначеЕсли Метаданные.Документы.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'Документ'");
		
		ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'План видов характеристик ""%1""'");
			
		ИначеЕсли Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'План счетов ""%1""'");
			
		ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'План видов расчета ""%1""'");
			
		ИначеЕсли Метаданные.БизнесПроцессы.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'Бизнес-процесс'");
			
		ИначеЕсли Метаданные.Задачи.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'Задача'");
			
		ИначеЕсли Метаданные.ПланыОбмена.Содержит(ОбъектМетаданных) Тогда
			ПредставлениеДанных = НСтр("ru = 'План обмена ""%1""'");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПредставлениеДанных) И ЗначениеЗаполнено(ИдентификаторДанных) Тогда
			ПредставлениеДанных = ПредставлениеДанных + " " + Строка(ИдентификаторДанных);
		Иначе
			ПредставлениеДанных = "";
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеДанных = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ПредставлениеДанных, ОбъектМетаданных.Синоним);
	
	Возврат ПредставлениеДанных;
	
КонецФункции

// Функция преобразует Отбор в условие на языке запросов и вставляет в запрос.
//
// Параметры:
//  Запрос             - Запрос.
//
//  Отбор              - РегистрСведенийНаборЗаписей.Отбор,
//                       РегистрНакопленияНаборЗаписей.Отбор,
//                       РегистрБухгалтерииНаборЗаписей.Отбор,
//                       РегистрРасчетаНаборЗаписей.Отбор.
//
//  ПсевдонимТаблицы   - Строка - псевдоним регистра в запросе.
//
//  МестоУсловияОтбора - Строка - Идентификатор места условия в запросе,
//                       например, &УсловиеОтбора.
//
// Возвращаемое значение:
//  Строка.
//
Процедура ВставитьПараметрыИУсловиеОтбора(Запрос,
                                          Отбор,
                                          ПсевдонимТаблицы = "Таблица",
                                          МестоУсловияОтбора = "&УсловиеОтбора")
	
	Условие = "";
	Для каждого ЭлементОтбора Из Отбор Цикл
		
		Если ЭлементОтбора.Использование Тогда
			Если НЕ ПустаяСтрока(Условие) Тогда
				Условие = Условие + Символы.ПС + "И ";
			КонецЕсли;
			Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
			Условие = Условие
				+ ПсевдонимТаблицы + "." + ЭлементОтбора.Имя + " = &" + ЭлементОтбора.Имя;
		КонецЕсли;
	КонецЦикла;
	Условие = ?(ЗначениеЗаполнено(Условие), Условие, "Истина");
	Запрос.Текст = СтрЗаменить(Запрос.Текст, МестоУсловияОтбора, Условие);
	
КонецПроцедуры

