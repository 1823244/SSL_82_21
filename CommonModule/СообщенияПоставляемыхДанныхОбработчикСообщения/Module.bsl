﻿////////////////////////////////////////////////////////////////////////////////
// Подписка на уведомления о поступлении новых поставляемых данных
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ


// Получает список обработчиков сообщений, которые обрабатывает данная подсистема.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - состав полей см. в ОбменСообщениями.НоваяТаблицаОбработчиковСообщений
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики) Экспорт
	
	ДобавитьОбработчикКаналаСообщений("ПоставляемыеДанные\Обновление", СообщенияПоставляемыхДанныхОбработчикСообщения, Обработчики);
	
КонецПроцедуры

// Выполняет обработку тела сообщения из канала в соответствии с алгоритмом текущего канала сообщений
//
// Параметры:
//  <КаналСообщений> (обязательный). Тип:Строка. Идентификатор канала сообщений, из которого получено сообщение.
//  <ТелоСообщения> (обязательный). Тип: Произвольный. Тело сообщения, полученное из канала, которое подлежит обработке.
//  <Отправитель> (обязательный). Тип: ПланОбменаСсылка.ОбменСообщениями. Конечная точка, которая является отправителем сообщения.
//
Процедура ОбработатьСообщение(Знач КаналСообщений, Знач ТелоСообщения, Знач Отправитель) Экспорт
	
	Попытка
		Дескриптор = ДесериализоватьXDTO(ТелоСообщения);
		
		Если КаналСообщений = "ПоставляемыеДанные\Обновление" Тогда
			
			ОбработатьНовыйДескриптор(Дескриптор);
			
		КонецЕсли;
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки сообщения'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор) + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение;
	КонецПопытки;
	
	
КонецПроцедуры

// Обрабатывает новые данные. Вызывается из ОбработатьСообщение и из ПоставляемыеДанные.ЗагрузитьИОбработатьДанные
//
// Параметры
//  Дескриптор - ОбъектXDTO Descriptor
Процедура ОбработатьНовыйДескриптор(Знач Дескриптор) Экспорт
	
	Загружать = Ложь;
	НаборЗаписей = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		
		ОбработчикЗагружать = Ложь;
		
		Обработчик.Обработчик.ДоступныНовыеДанные(Дескриптор, ОбработчикЗагружать);
		
		Если ОбработчикЗагружать Тогда
			НеобработанныеДанные = НаборЗаписей.Добавить();
			НеобработанныеДанные.ИдентификаторФайла = Дескриптор.FileGUID;
			НеобработанныеДанные.КодОбработчика = Обработчик.КодОбработчика;
			Загружать = Истина;
		КонецЕсли;
		
	КонецЦикла; 
	
	Если Загружать Тогда
		УстановитьПривилегированныйРежим(Истина);
		НаборЗаписей.Записать();
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗапланироватьЗагрузкуДанных(Дескриптор);
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Доступны новые данные'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, ,
		, ?(Загружать, НСтр("ru = 'В очередь добавлено задание на загрузку.'"), НСтр("ru = 'Загрузка данных не требуется.'"))
		+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
		

КонецПроцедуры

// Запланировать загрузку данных, соответствующих дескриптору
//
// Параметры
//   Дескриптор - ОбъектXDTO Descriptor.
//
Процедура ЗапланироватьЗагрузкуДанных(Знач Дескриптор) Экспорт
	Перем ДескрипторXML, ПараметрыМетода;
	
	Если Дескриптор.RecommendedUpdateDate = Неопределено Тогда
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата();
	КонецЕсли;
	
	ДескрипторXML = СериализоватьXDTO(Дескриптор);
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ДескрипторXML);

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода"    , "СообщенияПоставляемыхДанныхОбработчикСообщения.ЗагрузитьДанные");
	ПараметрыЗадания.Вставить("Параметры"    , ПараметрыМетода);
	ПараметрыЗадания.Вставить("ОбластьДанных", -1);
	ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", МестноеВремя(Дескриптор.RecommendedUpdateDate));
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	
	УстановитьПривилегированныйРежим(Истина);
	ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);

КонецПроцедуры

// Произвести загрузку данных, соответствующих дескриптору
//
// Параметры
//   Дескриптор - ОбъектXDTO Descriptor.
//
Процедура ЗагрузитьДанные(Знач ДескрипторXML) Экспорт
	Перем Дескриптор, ИмяФайлаВыгрузки;
	
	Попытка
		Дескриптор = ДесериализоватьXDTO(ДескрипторXML);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка работы с XML'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ ДескрипторXML);
		Возврат;
	КонецПопытки;

	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Информация, ,
		, НСтр("ru = 'Загрузка начата'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));

	Если ЗначениеЗаполнено(Дескриптор.FileGUID) Тогда
		ИмяФайлаВыгрузки = ПолучитьФайлИзХранилища(Дескриптор);
	
		Если ИмяФайлаВыгрузки = Неопределено Тогда
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Информация, ,
				, НСтр("ru = 'Файл не может быть загружен'") + Символы.ПС 
				+ ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
		УровеньЖурналаРегистрации.Примечание, ,
		, НСтр("ru = 'Загрузка успешно выполнена'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));

	// РегистрСведений.ПоставляемыеДанныеТребующиеОбработки используется на тот случай, если выполнение
	// цикла было прервано перезагрузкой сервера.
	// В этой ситуации единственный способ сохранить информацию о отработавших обработчиках (если их более 1) - 
	// оперативно записывать их в указанный регистр.
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	БылиОшибки = Ложь;
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		Для каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		Попытка
			Обработчик.Обработчик.ОбработатьНовыеДанные(Дескриптор, ИмяФайлаВыгрузки);
			НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			НаборНеобработанныхДанных.Записать();			
		Исключение
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'", 
				ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, ,
				, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
				+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
				+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
				
			ЗаписьНеобработанныхДанных.КоличествоПопыток = ЗаписьНеобработанныхДанных.КоличествоПопыток + 1;
			Если ЗаписьНеобработанныхДанных.КоличествоПопыток > 3 Тогда
				УведомитьОбОтменеОбработки(Обработчик, Дескриптор);
				НаборНеобработанныхДанных.Удалить(ЗаписьНеобработанныхДанных);
			Иначе
				БылиОшибки = Истина;
			КонецЕсли;
			НаборНеобработанныхДанных.Записать();			
			
		КонецПопытки;
	КонецЦикла; 
	
	Попытка
		УдалитьФайлы(ИмяФайлаВыгрузки);
	Исключение
	КонецПопытки;
	
	Если БылиОшибки Тогда
		//Откладываем загрузку на 5 минут				
		Дескриптор.RecommendedUpdateDate = ТекущаяУниверсальнаяДата() + 5 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка обработки'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация, , ,
			НСтр("ru = 'Обработка данных будет запущена повторно из-за ошибки обработчика.'")
			 + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
	Иначе
		НаборНеобработанныхДанных.Очистить();
		НаборНеобработанныхДанных.Записать();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Загрузка данных'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация, ,
			, НСтр("ru = 'Новые данные обработаны'") + Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));

	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьСведенияОНеобработанныхДанных(Знач Дескриптор)
	
	НаборНеобработанныхДанных = РегистрыСведений.ПоставляемыеДанныеТребующиеОбработки.СоздатьНаборЗаписей();
	НаборНеобработанныхДанных.Отбор.ИдентификаторФайла.Установить(Дескриптор.FileGUID);
	НаборНеобработанныхДанных.Прочитать();
	
	Для каждого Обработчик Из ПолучитьОбработчики(Дескриптор.DataType) Цикл
		ЗаписьНайдена = Ложь;
		
		Для каждого ЗаписьНеобработанныхДанных Из НаборНеобработанныхДанных Цикл
			Если ЗаписьНеобработанныхДанных.КодОбработчика = Обработчик.КодОбработчика Тогда
				ЗаписьНайдена = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла; 
		
		Если Не ЗаписьНайдена Тогда 
			Продолжить;
		КонецЕсли;
			
		УведомитьОбОтменеОбработки(Обработчик, Дескриптор);
		
	КонецЦикла; 
	НаборНеобработанныхДанных.Очистить();
	НаборНеобработанныхДанных.Записать();
	
КонецПроцедуры

Процедура УведомитьОбОтменеОбработки(Знач Обработчик, Знач Дескриптор)
	
	Попытка
		Обработчик.Обработчик.ОбработкаДанныхОтменена(Дескриптор);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Информация, ,
			, ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
			+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Отмена обработки'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор)
			+ Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Код обработчика: %1'"), Обработчик.КодОбработчика));
	КонецПопытки;

КонецПроцедуры

Функция ПолучитьФайлИзХранилища(Знач Дескриптор)
	
	Попытка
		ИмяФайлаВыгрузки = РаботаВМоделиСервиса.ПолучитьФайлИзХранилищаМенеджераСервиса(Дескриптор.FileGUID);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Поставляемые данные.Ошибка хранилища'", 
			ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, ,
			, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			+ Символы.ПС + ПоставляемыеДанные.ПолучитьОписаниеДанных(Дескриптор));
				
		//Откладываем загрузку на час				
		Дескриптор.RecommendedUpdateDate = Дескриптор.RecommendedUpdateDate + 60 * 60;
		ЗапланироватьЗагрузкуДанных(Дескриптор);
		Возврат Неопределено;
	КонецПопытки;
	
	// Если файл был заменен или удален между перезапусками функции - 
	// удалим старый план обновления
	Если ИмяФайлаВыгрузки = Неопределено Тогда
		УдалитьСведенияОНеобработанныхДанных(Дескриптор);
	КонецЕсли;
	
	Возврат ИмяФайлаВыгрузки;

КонецФункции

Функция ПолучитьОбработчики(Знач ВидДанных)
	
	Обработчики = Новый ТаблицаЗначений;
	Обработчики.Колонки.Добавить("ВидДанных");
	Обработчики.Колонки.Добавить("Обработчик");
	Обработчики.Колонки.Добавить("КодОбработчика");
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.РаботаВМоделиСервиса.ПоставляемыеДанные\ПриОпределенииОбработчиковПоставляемыхДанных");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриОпределенииОбработчиковПоставляемыхДанных(Обработчики);
	КонецЦикла;
	
	ПоставляемыеДанныеПереопределяемый.ПолучитьОбработчикиПоставляемыхДанных(Обработчики);
	
	Возврат Обработчики.Скопировать(Новый Структура("ВидДанных", ВидДанных), "Обработчик, КодОбработчика");
	
КонецФункции	

Функция СериализоватьXDTO(Знач XDTOОбъект)
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	ФабрикаXDTO.ЗаписатьXML(Запись, XDTOОбъект, , , , НазначениеТипаXML.Явное);
	Возврат Запись.Закрыть();
КонецФункции

Функция ДесериализоватьXDTO(Знач СтрокаXML)
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(СтрокаXML);
	XDTOОбъект = ФабрикаXDTO.ПрочитатьXML(Чтение);
	Чтение.Закрыть();
	Возврат XDTOОбъект;
КонецФункции


// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ДобавитьОбработчикКаналаСообщений(Знач Канал, Знач ОбработчикКанала, Знач Обработчики)
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Канал = Канал;
	Обработчик.Обработчик = ОбработчикКанала;
	
КонецПроцедуры
