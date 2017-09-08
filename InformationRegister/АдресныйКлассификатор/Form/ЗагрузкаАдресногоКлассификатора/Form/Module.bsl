﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОшибкаЗагрузкиДляОС = Ложь;
	
	АдресныеОбъектыПереданные = ?(Параметры.Свойство("АдресныеОбъекты"), Параметры.АдресныеОбъекты, Неопределено);
	
	ЗаполнитьТаблицуАдресныхОбъектов(АдресныеОбъектыПереданные);
	
	ИсточникДанныхДляЗагрузки = 0;
	ПутьКФайламДанныхНаДиске = "";
	ДискИТС = "";
	
	Если АдресныеОбъектыПереданные = Неопределено Тогда
		ЗагрузитьСохраненныеПараметрыЗагрузки();
	Иначе
		ИсточникДанныхДляЗагрузки = 1;
	КонецЕсли;
	
	ОшибкаЗагрузкиДляОС = ПроверитьОшибкуЗагрузкиДляОС();
	
	ЭтоLinuxКлиент = ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент();
	Если ЭтоLinuxКлиент Тогда
		// На ИТС поставляются exe, которые нельзя обрабатывать под Linux
		СписокВыбора = Элементы.СпособЗагрузки.СписокВыбора;
		СписокВыбора.Удалить( СписокВыбора.НайтиПоЗначению(2) );
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
#Если ВебКлиент Тогда
	Предупреждение(НСтр("ru = 'Загрузка адресного классификатора не доступна в веб-клиенте.'"));
	Закрыть();
#КонецЕсли
	
	Если ОшибкаЗагрузкиДляОС Тогда 
		Предупреждение(НСтр("ru = 'Загрузка адресного классификатора не доступна на сервере под управлением Linux/x86-64.'"));
		Закрыть();
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ИдентификаторЗадания<>Неопределено Тогда
		ОтменитьПроцессЗагрузки(ИдентификаторЗадания);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// Обработчик события НачалоВыбора поля ввода формы ПутьКФайламДанныхНаДиске.
// Вызывает диалог выбора  директории, после выбора проверяет, существуют
// ли в выбранной директории файлы данных.
//
&НаКлиенте
Процедура ПутьКФайламДанныхНаДискеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выбор каталога с файлами адресных сведений'");
	ДиалогОткрытияФайла.Каталог = Элементы.ПутьКФайламДанныхНаДиске.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ПутьКФайламДанныхНаДиске = ДиалогОткрытияФайла.Каталог;
		
		ОчиститьСообщения();
		
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			УстановитьИзмененияВИнтерфейсе ();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файлы адресных сведений не найдены в каталоге ""%1"".'"),
				ПутьКФайламДанныхНаДиске);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

// Обработчик события НачалоВыбора поля ввода формы ДискИТС.
// Вызывает диалог выбора директории, после выбора проверяет, существуют
// ли в выбранной директории файлы архивов данных.
//
&НаКлиенте
Процедура ДискИТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
#Если Не ВебКлиент Тогда
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выбор пути к диску 1С:ИТС'");
	ДиалогОткрытияФайла.Каталог = ДискИТС;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ДискИТС = ДиалогОткрытияФайла.Каталог;
		
		ФайлыСуществуют = АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС);
		
		ОчиститьСообщения();
		
		Если ФайлыСуществуют Тогда
			УстановитьИзмененияВИнтерфейсе();
		Иначе
			СообщениеПользователю = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Файлы адресных сведений не найдены: ""%1"".
			               |Проверьте правильность указанного пути к диску 1С:ИТС.'"),
				ДискИТС);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
		КонецЕсли;
	КонецЕсли;
#КонецЕсли
	
КонецПроцедуры

// Обработчик события выбора поля таблицы "ЭлементАдресныйОбъект"
// Изменяет статус загрузки адресного объекта поля на противоположный
//
&НаКлиенте
Процедура ТаблицаАдресныхОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Элемент.ТекущиеДанные.Пометка = Не Элемент.ТекущиеДанные.Пометка;
	ОтметитьОбязательные(ЭтаФорма);
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаАдресныхОбъектовПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОтметитьОбязательные(ЭтаФорма);
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
КонецПроцедуры

// Обработчик события ПриИзменении поля переключателя ИсточникДанныхДляЗагрузки
// Устанавливает параметры видимости элементов (параметров вида загрузки) 
// в зависимости от значения переключателя.
//
&НаКлиенте
Процедура СпособЗагрузкиПриИзменении(Элемент)
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Истина;
	КонецЦикла;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыделитьВсеВыполнить()
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		ЭлементАдресныйОбъект.Пометка = Ложь;
	КонецЦикла;
	
	ОтметитьОбязательные(ЭтаФорма);
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВыполнить()
	
	ОчиститьСообщения();
	
	УстановитьДоступностьКнопокПриЗагрузке(Ложь);
	
	Если ЗагрузитьКЛАДР()<0 Тогда
		// Загружено с ошибкой, сообщения показаны
		УстановитьДоступностьКнопокПриЗагрузке(Истина);
		УстановитьСтатусЗагрузки("");
		ПерейтиНаСтраницуВыбораИсточника();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ОчиститьСообщения();
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Если КоличествоОтмеченныхАдресныхОбъектов() = 0 Тогда
			СообщениеПользователю = НСтр("ru = 'Необходимо выбрать хотя бы один регион для загрузки адресных сведений.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "АдресныеОбъектыДляЗагрузки");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Если ИсточникДанныхДляЗагрузки = 2
		     И (ПустаяСтрока(ДискИТС) Или Не АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС)) Тогда
			СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути к диску 1С:ИТС.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ДискИТС");
			Возврат;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3
		     И (ПустаяСтрока(ПутьКФайламДанныхНаДиске) Или Не АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске)) Тогда
			СообщениеПользователю = НСтр("ru = 'Проверьте правильность указания пути, а также состав файлов КЛАДР.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеПользователю, , "ПутьКФайламДанныхНаДиске");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПерейтиНаСтраницуВыбораИсточника()
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаСервере
Функция ПроверитьОшибкуЗагрузкиДляОС()
	
	// Начиная с 8.3.3 можно работать с DBF на Linux
	ИнформацияОСервере = Новый СистемнаяИнформация;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ИнформацияОСервере.ВерсияПриложения, "8.3.3.1") > 0 Тогда
		Возврат Ложь;
		
	ИначеЕсли ИнформацияОСервере.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда 
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьКнопокПриЗагрузке(Флаг = Истина)
	
	Элементы.Назад.Доступность     = Флаг;
	Элементы.Загрузить.Доступность = Флаг;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыЗагрузки()
	
	МассивЗагружаемыхАО = Новый Массив;
	
	Для Каждого ЭлементАО Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАО.Пометка Тогда
			МассивЗагружаемыхАО.Добавить(Лев(ЭлементАО.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", "ЗагружаемыеРегионы", МассивЗагружаемыхАО);
	
	ИсточникКЛАДР = Новый Структура("ИсточникДанныхДляЗагрузки");
	ИсточникКЛАДР.ИсточникДанныхДляЗагрузки = ИсточникДанныхДляЗагрузки;
	
	Если ИсточникДанныхДляЗагрузки = 2 Тогда
		ИсточникКЛАДР.Вставить("ДискИТС", ДискИТС);
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		ИсточникКЛАДР.Вставить("ПутьКФайламДанныхНаДиске", ПутьКФайламДанныхНаДиске);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПараметрыЗагрузкиАдресногоКлассификатора", "ИсточникКЛАДР", ИсточникКЛАДР);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСохраненныеПараметрыЗагрузки()
	
	ИсточникКЛАДР = ЗагрузитьНастройкуЗагрузкиКЛАДР("ИсточникКЛАДР");
	
	Если ИсточникКЛАДР <> Неопределено Тогда
		ИсточникДанныхДляЗагрузки = ИсточникКЛАДР.ИсточникДанныхДляЗагрузки;
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			ДискИТС = ИсточникКЛАДР.ДискИТС;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			ПутьКФайламДанныхНаДиске = ИсточникКЛАДР.ПутьКФайламДанныхНаДиске;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Получает значение из системного хранилища настроек ИБ
//
&НаСервереБезКонтекста
Функция ЗагрузитьНастройкуЗагрузкиКЛАДР(КлючНастроек)
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПараметрыЗагрузкиАдресногоКлассификатора", КлючНастроек);
	
КонецФункции

// Устанавливает текст статус загрузки
//
&НаКлиенте
Процедура УстановитьСтатусЗагрузки(знач Сообщение = "")
	
	СтатусЗагрузки = НСтр("ru = 'Пожалуйста, подождите...'") + Символы.ПС + Сообщение;
	СтраницаСтатусаЗагрузки = ?(ПустаяСтрока(Сообщение), Элементы.ГруппаПустаяГруппа, Элементы.СтраницаСтатусЗагрузки);
	Элементы.СтраницыЗагрузки.ТекущаяСтраница = СтраницаСтатусаЗагрузки;
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

// Возвращает:
//     -1, если при старте загрузки произошла ошибка,
//      0,  если загружено успешно
//      1,  если запущена фоновая загрузка
//
&НаКлиенте
Функция ЗагрузитьКЛАДР()
	
	// Требуется для аутентификации на пользовательском сайте
	Перем ЗапросФормыАутентификации, ДанныеАутентификации, ПутьКДанным;
	
	ТекстСообщенияОшибки = НСтр("ru = 'Ошибка при загрузке адресных сведений:'") + " ";
	РезультатВыполнения = Истина;
	
	// Получение каталога временного хранилища файлов КЛАДР.
	Попытка
		ПутьКДаннымНаСервере = КаталогВременногоХранилищаФайловКладр();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат -1;
	КонецПопытки;
	
	Если ИсточникДанныхДляЗагрузки = 2 Тогда // загрузка с диска ИТС
		ДискИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДискИТС);
		
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда // загрузка из файлов на диске
		ПутьКФайламДанныхНаДиске = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКФайламДанныхНаДиске);
		
	КонецЕсли;
	
	// Подготавливаем массив адресных объектов для загрузки
	АдресныеОбъекты = Новый Массив;
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			АдресныеОбъекты.Добавить(Лев(ЭлементАдресныйОбъект.НаименованиеАдресногоОбъекта, 2));
		КонецЕсли;
	КонецЦикла;
	
	Если АдресныеОбъекты.Найти("SO") = Неопределено Тогда
		АдресныеОбъекты.Добавить("SO");
	КонецЕсли;
	
	// Первый этап - загрузка адаптированной базы данных КЛАДР на клиент.
	// В зависимости от выбора метода загрузка осуществляется по разному.
	Попытка
		ВерсияЗагружаемогоКЛАДР = Неопределено;
		ДоступныеВерсии			= Неопределено;
		РезультатВыполнения = ЗагрузитьФайлыКЛАДРНаКлиент(ДанныеАутентификации, ЗапросФормыАутентификации, АдресныеОбъекты, ПутьКДанным, ВерсияЗагружаемогоКЛАДР, ДоступныеВерсии);
		Если Не РезультатВыполнения Тогда 
			Возврат -1;
		КонецЕсли;	
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(ПутьКДанным);
		УдалитьФайлыНаСервере();
		Возврат -1;
	КонецПопытки;
	
	УстановитьСтатусЗагрузки(НСтр("ru = 'Выполняется загрузка адресных сведений в программу.'"));
	
	// Второй этап - передача файлов на сервер 1С:Предприятия
	Попытка
		ПомещенныеФайлы = Новый Массив;
		ПередачаФайловКЛАДРСКлиентаНаСервер(ПутьКДанным, АдресныеОбъекты, ПомещенныеФайлы);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщенияОшибки + КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(ПутьКДанным);
		УдалитьФайлыНаСервере();
		Возврат -1;
	КонецПопытки;
	
	// Третий этап - загрузка адресных сведений в регистр сведений.
	СообщениеОбОшибке = "";
	Результат = ЗагрузкаАдресныхСведенийНаСервере(АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ПомещенныеФайлы, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии);
	Если Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Неопределено;
	Иначе        
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		Возврат 1;
	КонецЕсли;
	
	ОбновитьСодержание(Результат);
	
	Возврат 0;
КонецФункции

&НаСервереБезКонтекста
Функция КаталогВременногоХранилищаФайловКладр()
	
	КаталогВременныхФайлов   = ОбщегоНазначенияПовтИсп.КаталогВременногоХранилищаФайлов();
	ПутьККаталогуФайловКЛАДР = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайлов) + Строка(Новый УникальныйИдентификатор);
	
	КаталогФайловКЛАДР     = Новый Файл(ПутьККаталогуФайловКЛАДР);
	Если КаталогФайловКЛАДР.Существует() Тогда 
		УдалитьФайлы(ПутьККаталогуФайловКЛАДР);
	КонецЕсли;
	
	СоздатьКаталог(ПутьККаталогуФайловКЛАДР);
	
	Возврат ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьККаталогуФайловКЛАДР);
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		СостояниеЗагрузки = СостояниеЗадания(ИдентификаторЗадания);
		Если СостояниеЗагрузки=0 Тогда
			// Выполнено успешно
			ИдентификаторЗадания = Неопределено;
			ОбновитьСодержание( Новый Структура("РезультатЗагрузки", ПолучитьИзВременногоХранилища(АдресХранилища)) );
			
		ИначеЕсли СостояниеЗагрузки<0 Тогда
			// Завершено аварийно, сообщения показаны
			ИдентификаторЗадания = Неопределено;
			ПерейтиНаСтраницуВыбораИсточника();
			
		Иначе
			// Процесс продолжается
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры	

// Возвращает:
//     -1, если завершено с ошибкой
//      0,  если завершено или отменено
//      1,  если все еще работает
//
&НаСервереБезКонтекста
Функция СостояниеЗадания(ИдентификаторЗадания)
	
	// Оставим запись в логах
	Попытка
		ФлагВыполнения = ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания)
	Исключение
		// Запись в журнал регистрации уже сделана
		Сообщить( КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
		Возврат -1;
	КонецПопытки;
	
	Если Не ФлагВыполнения Тогда
		Возврат 1
	КонецЕсли;
	
	// Проверим дополнительно
	Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если Задание=Неопределено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.Отменено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.Завершено Тогда
		Возврат 0;
	ИначеЕсли Задание.Состояние=СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Возврат -1;
	КонецЕсли;
	
	Возврат 1;
КонецФункции

&НаКлиенте
Процедура ОбновитьСодержание(Результат)
	
	УстановитьДоступностьКнопокПриЗагрузке();
	
	ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(Результат.РезультатЗагрузки.ПутьКДанным);
	ПутьКДаннымНаСервере = Результат.РезультатЗагрузки.ПутьКДаннымНаСервере;
	УдалитьФайлыНаСервере();
	
	Если Не ПустаяСтрока(Результат.РезультатЗагрузки.СообщениеПользователю) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.РезультатЗагрузки.СообщениеПользователю);
	КонецЕсли;	
	
	Если Результат.РезультатЗагрузки.СтатусВыполнения Тогда 
		Оповестить("Запись_АдресныйКлассификатор", Новый Структура("Событие", "Загрузить"));
		Предупреждение(НСтр("ru = 'Адресный классификатор успешно загружен.'"));
		СохранитьПараметрыЗагрузки();
		Закрыть(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗагрузитьФайлыКЛАДРНаКлиент(ДанныеАутентификации, ЗапросФормыАутентификации, АдресныеОбъекты, ПутьКДанным, ВерсияЗагружаемогоКЛАДР, ДоступныеВерсии)
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		// Загрузка с пользовательского сайта 1С
		Если Не ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
		
		РезультатПолученияДоступныхВерсий = АдресныйКлассификаторКлиентСервер.ПолучитьВерсииДоступныеНаСайте1С();
		Если НЕ РезультатПолученияДоступныхВерсий.Статус Тогда
			Возврат Ложь;
		КонецЕсли;
		ДоступныеВерсии = РезультатПолученияДоступныхВерсий.ДоступныеВерсии;
		
		Результат = ЗагрузитьАдресныеОбъектыССервера(АдресныеОбъекты, ДанныеАутентификации, ПутьКДанным);
		Если Не Результат.Статус И Не ЗапросФормыАутентификации Тогда
			Если Не ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации, Истина) Тогда
				Возврат Ложь;
			КонецЕсли;
			Результат = ЗагрузитьАдресныеОбъектыССервера(АдресныеОбъекты, ДанныеАутентификации, ПутьКДанным);
		КонецЕсли;
		
		Если Не Результат.Статус Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.СообщениеОбОшибке);
			Возврат Ложь;
		КонецЕсли;
		
		ПутьКДанным = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКДанным);
		
	Иначе
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			// Загрузка с диска ИТС
			Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
			УстановитьСтатусЗагрузки(НСтр("ru = 'Выполняется обработка файлов с диска 1С:ИТС.'"));
			ПутьКДанным = АдресныйКлассификаторКлиент.ПреобразоватьФайлыКЛАДРEXEВZIP(ДискИТС);
			Если ПутьКДанным = Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Загрузка адресного классификатора была отменена.'"));
				Возврат Ложь;
			КонецЕсли;
			//
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			// Загрузка из файлов на диске
			Состояние(НСтр("ru = 'Загружается адресный классификатор...'"));
			УстановитьСтатусЗагрузки(НСтр("ru = 'Выполняется загрузка адресных сведений в программу.'"));
			МассивФайловДляЗагрузки = АдресныйКлассификаторКлиент.СписокФайловДанных();
			Для Каждого ИмяФайла Из МассивФайловДляЗагрузки Цикл
				АдресныйКлассификаторКлиент.СжатьФайл(ПутьКФайламДанныхНаДиске, ИмяФайла, ПутьКДанным);
			КонецЦикла;
		КонецЕсли;
		
		ИмяФайла = ?(ЭтоLinuxКлиент, "[Kk][Ll][Aa][Dd][Rr].[Zz][Ii][Pp]", "kladr.zip");
		Кандидаты = НайтиФайлы(ПутьКДанным, ИмяФайла, Ложь);
		Если Кандидаты.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Не найден файл KLADR.ZIP.'"));
			Возврат Ложь;
		КонецЕсли;
		ZipФайл = Новый ЧтениеZipФайла(Кандидаты[0].ПолноеИмя);
		ВерсияЗагружаемогоКЛАДР = НачалоДня(ZipФайл.Элементы[0].ВремяИзменения);
		
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПередачаФайловКЛАДРСКлиентаНаСервер(ПутьКДанным, АдресныеОбъекты, ПомещенныеФайлы)
	
	ПомещаемыеФайлы = Новый Массив;
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		
		Для Каждого АдресныйОбъект Из АдресныеОбъекты Цикл
			
			Если АдресныйОбъект = "SO" Тогда
				ПутьКФайлуАрхива = ПутьКДанным + АдресныйКлассификаторКлиент.ЗаменитьРасширение_DBF_На_ZIP("SOCRBASE.ZIP");
				Описание = Новый ОписаниеПередаваемогоФайла(ПутьКФайлуАрхива);
				ПомещаемыеФайлы.Добавить(Описание);
			Иначе
				ПутьКФайлуАрхива = ПутьКДанным + "BASE" + АдресныйОбъект + ".ZIP";
				Описание = Новый ОписаниеПередаваемогоФайла(ПутьКФайлуАрхива);
				ПомещаемыеФайлы.Добавить(Описание);
			КонецЕсли;
			
		КонецЦикла;
		
		Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь) Тогда 
			ВызватьИсключение НСтр("ru = 'Ошибка передачи файлов данных на сервер.'");
		КонецЕсли;
		
	Иначе
		
		МассивФайловДляЗагрузки = АдресныйКлассификаторКлиент.СписокФайловДанных();
		Для Каждого ИмяФайла Из МассивФайловДляЗагрузки Цикл
			ПутьКФайлуАрхива = ПутьКДанным + АдресныйКлассификаторКлиент.ЗаменитьРасширение_DBF_На_ZIP(ИмяФайла);
			Описание = Новый ОписаниеПередаваемогоФайла(ПутьКФайлуАрхива);
			ПомещаемыеФайлы.Добавить(Описание);
		КонецЦикла;
		
		Если НЕ ПоместитьФайлы(ПомещаемыеФайлы, ПомещенныеФайлы, , Ложь) Тогда 
			ВызватьИсключение НСтр("ru = 'Ошибка передачи файлов данных на сервер.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗагрузкаАдресныхСведенийНаСервере(АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ПомещенныеФайлы, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии)
	
	РазархивироватьФайлыНаСервере(ПомещенныеФайлы, ПутьКДаннымНаСервере);
	
	ПараметрыЗагрузки = Новый Структура(
		"АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии", 
		АдресныеОбъекты, ПутьКДанным, ПутьКДаннымНаСервере, ВерсияЗагружаемогоКЛАДР, ИсточникДанныхДляЗагрузки, ДоступныеВерсии);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда 
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		АдресныйКлассификатор.ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений(ПараметрыЗагрузки, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка адресного классификатора'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"АдресныйКлассификатор.ЗагрузкаАдресныхСведенийИзФайловКЛАДРВРегистрСведений", 
		ПараметрыЗагрузки, 
		НаименованиеЗадания);
		
		АдресХранилища = Результат.АдресХранилища	
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		Результат.Вставить("РезультатЗагрузки", ПолучитьИзВременногоХранилища(АдресХранилища));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Процедура РазархивироватьФайлыНаСервере(ПомещенныеФайлы, ПутьККаталогуНаСервере)
	
	Для Каждого ПомещенныйФайл из ПомещенныеФайлы Цикл 
		
		ИмяФайла            = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПомещенныйФайл.Имя).Имя;
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение);
		АдресныйКлассификатор.СохранитьФайлНаСервереИРаспаковать(ДвоичныеДанныеФайла, ИмяФайла, ПутьККаталогуНаСервере);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьФайлыНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УдалитьКаталогСФайлами(ПутьКДаннымНаСервере);
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьДанныеАутентификации(ДанныеАутентификации, ЗапросФормыАутентификации, знач ЗапросКПользователю = Ложь)
	
	Перем КодПользователя, Пароль;
	
	ЗапросФормыАутентификации = Ложь;
	
	Если ЗапросКПользователю Или Не ПолучитьПараметрыАутентификацииСервер(КодПользователя, Пароль) Тогда
		ЗапросФормыАутентификации = Истина;
		Результат = ОткрытьФормуМодально("РегистрСведений.АдресныйКлассификатор.Форма.АвторизацияНаПользовательскомСайте");
		Если Результат = Неопределено ИЛИ ТипЗнч(Результат) = Тип("КодВозвратаДиалога") Тогда
			Возврат Ложь;
		Иначе
			КодПользователя = Результат.КодПользователя;
			Пароль          = Результат.Пароль;
		КонецЕсли;
	КонецЕсли;
	
	ДанныеАутентификации = Новый Структура("КодПользователя, Пароль", КодПользователя, Пароль);
	Возврат Истина;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПараметрыАутентификацииСервер(КодПользователя, Пароль)
	
	Возврат АдресныйКлассификатор.ПолучитьПараметрыАутентификации(КодПользователя, Пароль);
	
КонецФункции

&НаКлиенте
Функция ЗагрузитьАдресныеОбъектыССервера(знач АдресныеОбъекты, знач ДанныеАутентификации, ПутьКДанным)
	
	Для Каждого АдресныйОбъект Из АдресныеОбъекты Цикл
		АдресныеСведения = АдресныйКлассификаторВызовСервера.ИнформацияПоАдресномуОбъекту(АдресныйОбъект);
		ТекстСтатусаЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файлов адресных сведений с веб-сервера:
			           |%1 %2.'"),
			АдресныеСведения.Наименование, АдресныеСведения.Сокращение);
		УстановитьСтатусЗагрузки(ТекстСтатусаЗагрузки);
		Результат = АдресныйКлассификаторКлиент.ЗагрузитьКЛАДРСВебСервера(АдресныйОбъект, ДанныеАутентификации, ПутьКДанным);
		Если Не Результат.Статус Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Заполняет переданную таблицу значений по значениям таблицы адресных объектов.
// Выбирается код, наименование и сокращение типа объекта.
//
&НаСервере
Процедура ЗаполнитьТаблицуАдресныхОбъектов(ЗаданныеРегионыДляЗагрузки)
	
	МассивЗагружаемыхАО = ЗагрузитьНастройкуЗагрузкиКЛАДР("ЗагружаемыеРегионы");
	
	АдресныеОбъектыДляЗагрузки.Очистить();
	
	КлассификаторАдресныхОбъектовXML =
	РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("КлассификаторАдресныхОбъектовРоссии").ПолучитьТекст();
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторАдресныхОбъектовXML).Данные;
	
	Для Каждого АдресныйОбъект Из КлассификаторТаблица Цикл
		
		Наименование = СокрЛП(Лев(АдресныйОбъект.Code, 2) + " - " + АдресныйОбъект.Name + " " + АдресныйОбъект.Socr);
		
		НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
		НоваяСтрока.НаименованиеАдресногоОбъекта = Наименование;
		
		Если ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
			//
			Если ЗаданныеРегионыДляЗагрузки.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
			//
		ИначеЕсли МассивЗагружаемыхАО <> Неопределено Тогда
			//
			Если МассивЗагружаемыхАО.Найти(Лев(АдресныйОбъект.Code, 2)) <> Неопределено Тогда
				НоваяСтрока.Пометка = Истина;
			Иначе
				НоваяСтрока.Пометка = Ложь;
			КонецЕсли;
		Иначе
			НоваяСтрока.Пометка = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗаданныеРегионыДляЗагрузки <> Неопределено Тогда
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("AL") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("AL");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
		//
		Если ЗаданныеРегионыДляЗагрузки.Найти("SO") <> Неопределено Тогда
			АдресныйОбъект = АдресныйКлассификатор.ИнформацияПоАдресномуОбъекту("SO");
			НоваяСтрока = АдресныеОбъектыДляЗагрузки.Добавить();
			НоваяСтрока.НаименованиеАдресногоОбъекта = СокрЛП(Лев(АдресныйОбъект.КодАдресногоОбъекта, 2) + " - " + АдресныйОбъект.Наименование);
			НоваяСтрока.Пометка = Истина;
			ОбязательныеАдресныеОбъекты.Добавить(НоваяСтрока.ПолучитьИдентификатор());
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает количество помеченных адресных объектов
//
&НаКлиенте
Функция КоличествоОтмеченныхАдресныхОбъектов()
	
	КоличествоОтмеченныхАдресныхОбъектов = 0;
	
	Для Каждого ЭлементАдресныйОбъект Из АдресныеОбъектыДляЗагрузки Цикл
		Если ЭлементАдресныйОбъект.Пометка Тогда
			КоличествоОтмеченныхАдресныхОбъектов = КоличествоОтмеченныхАдресныхОбъектов + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат КоличествоОтмеченныхАдресныхОбъектов;
	
КонецФункции

// В зависимости от текущей страницы устанавливает доступность тех или иных полей для пользователя
//
&НаКлиенте
Процедура УстановитьИзмененияВИнтерфейсе()
	
	ИсточникДанныхДляЗагрузкиВыбран = ИсточникДанныхДляЗагрузкиВыбран();
	ВыбраноРегионовДляЗагрузки = КоличествоОтмеченныхАдресныхОбъектов();
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборАдресныхОбъектов Тогда
		Элементы.Назад.Доступность = Ложь;
		Элементы.Далее.Доступность = Истина;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника Тогда
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Истина;
		
		Если ИсточникДанныхДляЗагрузки = 0 Тогда
			ИсточникДанныхДляЗагрузки = 1;
		КонецЕсли;
		
		Если ИсточникДанныхДляЗагрузки = 2 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаСДискаИТС;
		ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.СтраницаЗагрузкаФайлов;
		Иначе
			Элементы.СтраницыСпособаЗагрузки.ТекущаяСтраница = Элементы.ПустаяСтраница;
		КонецЕсли;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагрузка Тогда
		Элементы.Назад.Доступность = Истина;
		Элементы.Далее.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ИсточникДанныхДляЗагрузкиВыбран()
	
	ИсточникВыбран = Ложь;
	
	Если ИсточникДанныхДляЗагрузки = 1 Тогда
		ИсточникВыбран = Истина;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 2 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловНаДискеИТС(ДискИТС) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	ИначеЕсли ИсточникДанныхДляЗагрузки = 3 Тогда
		Если АдресныйКлассификаторКлиент.ПроверитьНаличиеФайловДанныхВКаталоге(ПутьКФайламДанныхНаДиске) Тогда
			ИсточникВыбран = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ИсточникВыбран;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОтметитьОбязательные(Контекст)
	
	Для каждого Описание Из Контекст.ОбязательныеАдресныеОбъекты Цикл
		Контекст.АдресныеОбъектыДляЗагрузки.НайтиПоИдентификатору(Описание.Значение).Пометка = Истина;
	КонецЦикла
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьПроцессЗагрузки(ИдентификаторЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры


