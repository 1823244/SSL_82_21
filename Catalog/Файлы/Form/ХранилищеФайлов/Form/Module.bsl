﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Папка") = Истина И Параметры.Папка <> Неопределено Тогда
		ПапкаПриОткрытии = Параметры.Папка;
	Иначе	
		ПапкаПриОткрытии = ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить("ХранилищеФайлов", "ТекущаяПапка");
	КонецЕсли;
	
	Если ПапкаПриОткрытии = Справочники.ПапкиФайлов.ПустаяСсылка() Тогда
		ПапкаПриОткрытии = Справочники.ПапкиФайлов.Шаблоны;
	Иначе
		ПапкаПриОткрытииОбъект = Неопределено;
		Попытка
			ПапкаПриОткрытииОбъект = ПапкаПриОткрытии.ПолучитьОбъект();
		Исключение
		КонецПопытки;
		
		Если ПапкаПриОткрытииОбъект = Неопределено Тогда
			ПапкаПриОткрытии = Справочники.ПапкиФайлов.Шаблоны;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Папки.ТекущаяСтрока = ПапкаПриОткрытии;

	Список.Параметры.УстановитьЗначениеПараметра(
		"Владелец", ПапкаПриОткрытии);
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());

	РаботаСФайламиСлужебныйВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиСлужебныйВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
	
	ИспользоватьИерархию = Истина;
	УстановитьИерархию(ИспользоватьИерархию);
	
	Если РаботаСФайламиСлужебныйВызовСервера.ПолучитьИспользоватьЭлектронныеЦифровыеПодписиИШифрование() = Ложь Тогда
		Элементы.ПодписанЭЦП.Видимость = Ложь;
		Элементы.Зашифрован.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ПапкаПриОткрытии <> Элементы.Папки.ТекущаяСтрока Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		"ХранилищеФайлов", 
		"ТекущаяПапка", 
		Элементы.Папки.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ИмпортКаталоговЗавершен" Тогда
		Элементы.Папки.Обновить();
		Элементы.Список.Обновить();
		
		Если Источник <> Неопределено Тогда
			Элементы.Папки.ТекущаяСтрока = Источник;
		КонецЕсли;
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		
		Если Параметр <> Неопределено Тогда
			ВладелецФайла = Неопределено;
			Если Параметр.Свойство("Владелец", ВладелецФайла) Тогда
				Если ВладелецФайла = Элементы.Папки.ТекущаяСтрока Тогда
					Элементы.Список.Обновить();
					
					ФайлСозданный = Неопределено;
					Если Параметр.Свойство("Файл", ФайлСозданный) Тогда
						Элементы.Список.ТекущаяСтрока = ФайлСозданный;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		УстановитьДоступностьФайловыхКоманд();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.ПапкиФайлов.Форма.ФормаВыбора") Тогда
		
		Если ВыбранноеЗначение = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ВыделенныеСтроки = Элементы.Список.ВыделенныеСтроки;
		РаботаСФайламиСлужебныйКлиент.ПеренестиФайлыВПапку(ВыделенныеСтроки, ВыбранноеЗначение);
		
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			Оповестить("Запись_Файл", Новый Структура("Событие", "ДанныеФайлаИзменены"), ВыделеннаяСтрока);
		КонецЦикла;
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьИерархию(Настройки["ИспользоватьИерархию"]);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	НайтиФайлыИлиПапки();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбраннаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ОткрытьЗначение(ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ИмяКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	Если ИмяКаталога = Неопределено ИЛИ ПустаяСтрока(ИмяКаталога) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		ВыбраннаяСтрока,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	ВыбранныйРежим = РаботаСФайламиКлиент.ВыбратьРежимИРедактироватьФайл(ДанныеФайла, Истина);
	Если ВыбранныйРежим = "Редактировать" Тогда
		УстановитьДоступностьФайловыхКоманд();
		Возврат;
	ИначеЕсли ВыбранныйРежим = "Отмена" Тогда
		Возврат;
	КонецЕсли;	
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, УникальныйИдентификатор); 
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	ВладелецФайла = Элементы.Папки.ТекущаяСтрока;
	ФайлОснование = Элементы.Список.ТекущаяСтрока;
	
	Отказ = Истина;
	
	Если Не Копирование Тогда
		
		Попытка
			РаботаСФайламиКлиент.СозданиеНовогоФайла(ВладелецФайла, ЭтаФорма);
		Исключение
			Предупреждение(ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
				ИнформацияОбОшибке()));
		КонецПопытки;
	Иначе
		РаботаСФайламиКлиент.СкопироватьФайл(ВладелецФайла, ФайлОснование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Если Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	МассивИменФайлов = Новый Массив;
	ЭтоПеретаскиваниеФайловИзвне = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПараметрыПеретаскивания.Значение.ПолноеИмя, Элементы.Папки.ТекущаяСтрока, ЭтаФорма);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда	
		ЭтоПеретаскиваниеФайловИзвне = Истина;
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			ЭтоПеретаскиваниеФайловИзвне = Истина;
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
			КонецЦикла;
			
		ИначеЕсли ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование 
			И ПараметрыПеретаскивания.Значение.Количество() >= 1 
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.Файлы") Тогда
			
			РаботаСФайламиСлужебныйВызовСервера.СкопироватьФайлы(
				ПараметрыПеретаскивания.Значение, Элементы.Папки.ТекущаяСтрока);
			
			Элементы.Папки.Обновить();
			Элементы.Список.Обновить();
			
			Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файл ""%1""
					           |скопирован в папку ""%2""'"),
					ПараметрыПеретаскивания.Значение[0],
					Строка(Элементы.Папки.ТекущаяСтрока));
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Файл скопирован.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			Иначе
				ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Файлы (%1 шт.) скопированы в папку ""%2""'"),
					ПараметрыПеретаскивания.Значение.Количество(),
					Строка(Элементы.Папки.ТекущаяСтрока));
				
				ПоказатьОповещениеПользователя(
					НСтр("ru = 'Файлы скопированы.'"),
					,
					ПолноеОписание,
					БиблиотекаКартинок.Информация32);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПеретаскиваниеФайловИзвне = Истина Тогда
		
		ПараметрыИмпорта = Новый Структура;
		ПараметрыИмпорта.Вставить("ПапкаДляДобавления", Элементы.Папки.ТекущаяСтрока);
		ПараметрыИмпорта.Вставить("МассивИменФайлов",   МассивИменФайлов);
		
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаПеретаскивания", ПараметрыИмпорта);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Папки

&НаКлиенте
Процедура ПапкиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Папки.ТекущаяСтрока = Неопределено ИЛИ Элементы.Папки.ТекущаяСтрока.Пустая() Тогда
		Элементы.СоздатьФайл.Доступность = Ложь;
		Элементы.КонтекстноеМенюСписокСоздать.Доступность = Ложь;
	Иначе
		Элементы.СоздатьФайл.Доступность = Истина;
		Элементы.КонтекстноеМенюСписокСоздать.Доступность = Истина;
	КонецЕсли;
	
	Если Элементы.Папки.ТекущаяСтрока <> Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПапкиПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивИменФайлов = Новый Массив;
	ЭтоПеретаскиваниеФайловИзвне = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") И ПараметрыПеретаскивания.Значение.ЭтоФайл() = Истина Тогда
		РаботаСФайламиКлиент.СоздатьДокументНаОсновеФайла(ПараметрыПеретаскивания.Значение.ПолноеИмя, Элементы.Папки.ТекущаяСтрока, ЭтаФорма);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда	
		ЭтоПеретаскиваниеФайловИзвне = Истина;
		МассивИменФайлов.Добавить(ПараметрыПеретаскивания.Значение.ПолноеИмя);
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			ЭтоПеретаскиваниеФайловИзвне = Истина;
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				МассивИменФайлов.Добавить(ФайлПринятый.ПолноеИмя);
			КонецЦикла;
		КонецЕсли;
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.Файлы") Тогда
			
			Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Копирование Тогда
				
				РаботаСФайламиСлужебныйВызовСервера.СкопироватьФайлы(
					ПараметрыПеретаскивания.Значение, Строка);
				
				Элементы.Папки.Обновить();
				Элементы.Список.Обновить();
				
				Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файл ""%1""
						           |скопирован в папку ""%2""'"),
						ПараметрыПеретаскивания.Значение[0],
						Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Файл скопирован.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				Иначе
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Файлы (%1 шт.) скопированы в папку ""%2""'"),
						ПараметрыПеретаскивания.Значение.Количество(),
						Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Файлы скопированы.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				КонецЕсли;
				Возврат;
				
			Иначе
				
				Если РаботаСФайламиСлужебныйВызовСервера.УстановитьВладельцаФайла(ПараметрыПеретаскивания.Значение, Строка) = Истина Тогда
					Элементы.Папки.Обновить();
					Элементы.Список.Обновить();
					
					Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
						ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файл ""%1""
							           |перенесен в папку ""%2""'"),
							ПараметрыПеретаскивания.Значение[0],
							Строка);
						
						ПоказатьОповещениеПользователя(
							НСтр("ru = 'Файл перенесен.'"),
							,
							ПолноеОписание,
							БиблиотекаКартинок.Информация32);
					Иначе
						ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Файлы (%1 шт.) перенесены в папку ""%2""'"), ПараметрыПеретаскивания.Значение.Количество(), Строка);
						
						ПоказатьОповещениеПользователя(
							НСтр("ru = 'Файлы перенесены.'"),
							,
							ПолноеОписание,
							БиблиотекаКартинок.Информация32);
					КонецЕсли;
				КонецЕсли;
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1 И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			НайденоЗацикливание = Ложь;
			Если РаботаСФайламиСлужебныйВызовСервера.СменитьРодителяПапок(ПараметрыПеретаскивания.Значение, Строка, НайденоЗацикливание) = Истина Тогда
				Элементы.Папки.Обновить();
				Элементы.Список.Обновить();
				
				Если ПараметрыПеретаскивания.Значение.Количество() = 1 Тогда
					Элементы.Папки.ТекущаяСтрока = ПараметрыПеретаскивания.Значение[0];
					
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Папка ""%1""
						           |перенесена в папку ""%2""'"),
						ПараметрыПеретаскивания.Значение[0],
						Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Папка перенесена.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				Иначе
					ПолноеОписание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Папки (%1 шт.) перенесены в папку ""%2""'"),
						ПараметрыПеретаскивания.Значение.Количество(),
						Строка);
					
					ПоказатьОповещениеПользователя(
						НСтр("ru = 'Папки перенесены.'"),
						,
						ПолноеОписание,
						БиблиотекаКартинок.Информация32);
				КонецЕсли;
				
			Иначе
				Если НайденоЗацикливание = Истина Тогда
					Предупреждение(НСтр("ru = 'Зацикливание уровней.'"));
				КонецЕсли;
			КонецЕсли;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПеретаскиваниеФайловИзвне = Истина Тогда
		
		ПараметрыИмпорта = Новый Структура;
		ПараметрыИмпорта.Вставить("ПапкаДляДобавления", Строка);
		ПараметрыИмпорта.Вставить("МассивИменФайлов",   МассивИменФайлов);
		
		ОткрытьФорму("Справочник.Файлы.Форма.ФормаПеретаскивания", ПараметрыИмпорта);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ИмпортФайловВыполнить()
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	РасширениеПодключено = ПодключитьРасширениеРаботыСФайлами();

	Если НЕ РасширениеПодключено Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСФайлами();
	Иначе	
		// заранее выбираем файлы (до открытия диалога импорта)
		Режим = РежимДиалогаВыбораФайла.Открытие;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Истина;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			МассивИменФайлов = Новый Массив;
			
			МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
			Для Каждого ИмяФайла Из МассивФайлов Цикл
				МассивИменФайлов.Добавить(ИмяФайла);
			КонецЦикла;
			
			ПараметрыИмпорта = Новый Структура;
			ПараметрыИмпорта.Вставить("ПапкаДляДобавления", Элементы.Папки.ТекущаяСтрока);
			ПараметрыИмпорта.Вставить("МассивИменФайлов",   МассивИменФайлов);
			
			ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаФайлов", ПараметрыИмпорта);
		КонецЕсли;
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ИмпортПапки(Команда)
	#Если ВебКлиент Тогда
		Предупреждение(
			НСтр("ru = 'В веб-клиенте импорт папок не поддерживается.
			           |Используйте команду ""Создать"" в списке файлов.'"));
	#Иначе
	
		// заранее выбираем каталог на диске (до открытия диалога импорта)
		Каталог = "";
		Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
		
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
		ДиалогОткрытияФайла.Фильтр = Фильтр;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			КаталогНаДиске = ДиалогОткрытияФайла.Каталог;
			
			ПараметрыИмпорта = Новый Структура;
			ПараметрыИмпорта.Вставить("ПапкаДляДобавления", Элементы.Папки.ТекущаяСтрока);
			ПараметрыИмпорта.Вставить("КаталогНаДиске",     КаталогНаДиске);
			
			ОткрытьФорму("Справочник.Файлы.Форма.ФормаИмпортаПапки", ПараметрыИмпорта);
		КонецЕсли;
		
	#КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортПапкиВыполнить()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПапкаЭкспорта", Элементы.Папки.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Файлы.Форма.ФормаЭкспортаПапки", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиВыполнить()
	
	Если СтрокаПоиска = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан текст для поиска.'"), , "СтрокаПоиска");
		Возврат;
	КонецЕсли;
	
	НайтиФайлыИлиПапки();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиФайлыИлиПапки()
	
	Если СтрокаПоиска = "" Тогда
		Возврат;
	КонецЕсли;
	
	Результат = НайтиФайлыИлиПапкиСервер();
	
	Если Результат = "НичегоНеНайдено" Тогда
		Предупреждение(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось найти файл или папку,
			           |наименование или код которых содержит ""%1"".'"),
			СтрокаПоиска ));
	Иначе 
		Если Результат = "НайденФайл" Тогда
			ТекущийЭлемент = Элементы.Список;
		Иначе 
			Если Результат = "НайденаПапка" Тогда
				ТекущийЭлемент = Элементы.Папки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Элементы.Папки.Обновить();
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервере
Функция СтрЗаменитьСпецСимволом(Строка, Символ, СпецСимвол)
	СтрокаНовая = СтрЗаменить(Строка, Символ, СпецСимвол + Символ);
	Возврат СтрокаНовая;
КонецФункции

&НаСервере
Функция НайтиФайлыИлиПапкиСервер()
	
	Перем НайденныйФайл;
	Перем НайденнаяПапка;
	
	Найдено = Ложь;
	
	Запрос = Новый Запрос;
	
	СтрокаПоискаНовая = СтрокаПоиска;
	
	СпецСимвол = "|";
	СтрокаПоискаНовая = СтрЗаменитьСпецСимволом(СтрокаПоискаНовая, "[", СпецСимвол);
	СтрокаПоискаНовая = СтрЗаменитьСпецСимволом(СтрокаПоискаНовая, "]", СпецСимвол);
	
	Запрос.Параметры.Вставить("Строка", "%" + СтрокаПоискаНовая + "%");
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
				   |	Файлы.Ссылка
				   |ИЗ
				   |	Справочник.Файлы КАК Файлы
				   |ГДЕ
				   |	Файлы.ПолноеНаименование ПОДОБНО &Строка СПЕЦСИМВОЛ ""|""";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		НайденныйФайл = Выборка.Ссылка;
		Найдено = Истина;
	КонецЕсли;
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	Файлы.Ссылка
					   |ИЗ
					   |	Справочник.Файлы КАК Файлы
					   |ГДЕ
					   |	Файлы.Код ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденныйФайл = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	ПапкиФайлов.Ссылка
					   |ИЗ
					   |	Справочник.ПапкиФайлов КАК ПапкиФайлов
					   |ГДЕ
					   |	ПапкиФайлов.Наименование ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденнаяПапка = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если Не Найдено Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
					   |	ПапкиФайлов.Ссылка
					   |ИЗ
					   |	Справочник.ПапкиФайлов КАК ПапкиФайлов
					   |ГДЕ
					   |	ПапкиФайлов.Код ПОДОБНО &Строка";
						
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НайденнаяПапка = Выборка.Ссылка;
			Найдено = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Если НайденныйФайл <> Неопределено Тогда 
		Элементы.Папки.ТекущаяСтрока = НайденныйФайл.ВладелецФайла;
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
		Элементы.Список.ТекущаяСтрока = НайденныйФайл.Ссылка;
		Возврат "НайденФайл";
	КонецЕсли;
	
	Если НайденнаяПапка <> Неопределено Тогда
		Элементы.Папки.ТекущаяСтрока = НайденнаяПапка;
		Возврат "НайденаПапка";
	КонецЕсли;	
	
	Возврат "НичегоНеНайдено";
КонецФункции

&НаКлиенте
Процедура СоздатьФайлВыполнить()
	
	Попытка
		РаботаСФайламиКлиент.СозданиеНовогоФайла(Элементы.Папки.ТекущаяСтрока, ЭтаФорма);
	Исключение
		Предупреждение(ФайловыеФункцииСлужебныйКлиентСервер.ОшибкаСозданияНовогоФайла(
			ИнформацияОбОшибке()));
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПапкуВыполнить()
	
	ПараметрыСозданияПапки = Новый Структура("Родитель", Элементы.Папки.ТекущаяСтрока);
	ОткрытьФорму("Справочник.ПапкиФайлов.ФормаОбъекта", ПараметрыСозданияПапки, Элементы.Папки);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьИерархию(Команда)
	
	ИспользоватьИерархию = Не ИспользоватьИерархию;
	Если ИспользоватьИерархию И (Элементы.Список.ТекущиеДанные <> Неопределено) Тогда 
		
		Если Элементы.Список.ТекущиеДанные.Свойство("ВладелецФайла") Тогда 
			Элементы.Папки.ТекущаяСтрока = Элементы.Список.ТекущиеДанные.ВладелецФайла;
		Иначе
			Элементы.Папки.ТекущаяСтрока = Неопределено;
		КонецЕсли;	
		
		Список.Параметры.УстановитьЗначениеПараметра("Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;	
	УстановитьИерархию(ИспользоватьИерархию);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайлВыполнить()
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
	
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.Редактировать(Элементы.Список.ТекущаяСтрока);
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры


// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ЗакончитьРедактирование(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует,
		Элементы.Список.ТекущиеДанные.Автор,
		Элементы.Список.ТекущиеДанные.Кодировка);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура Занять(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;

	РаботаСФайламиКлиент.Занять(Элементы.Список.ТекущаяСтрока);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОсвободитьФайл(
		Элементы.Список.ТекущаяСтрока,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	РаботаСФайламиКлиент.ОпубликоватьФайл(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока,
		Неопределено,
		УникальныйИдентификатор,
		Неопределено,
		ПредыдущийАдресФайла);
		
	РаботаСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	РаботаСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(
		Элементы.Список.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	
	ПараметрыОткрытияФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Справочник.Файлы.ФормаОбъекта", ПараметрыОткрытияФормы);
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиВПапку(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок",    НСтр("ru = 'Выбор папки'"));
	ПараметрыФормы.Вставить("ТекущаяПапка", Элементы.Папки.ТекущаяСтрока);
	ПараметрыФормы.Вставить("РежимВыбора",  Истина);
	
	ОткрытьФорму("Справочник.ПапкиФайлов.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(
			Команды.Найти("Подписать").Заголовок);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(
		Элементы.Список.ТекущаяСтрока);
	
	ДанныеПодписи = Неопределено;
	Если РаботаСФайламиКлиент.СформироватьПодписьФайла(ДанныеФайла, ДанныеПодписи) Тогда
		
		РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОднойПодписи(ДанныеПодписи);
		
		ЭлектроннаяЦифроваяПодписьКлиент.ИнформироватьОПодписанииОбъекта(ДанныеФайла.Ссылка);
		
		Оповестить(
			"Запись_Файл",
			Новый Структура("Событие", "ПрисоединенныйФайлПодписан"),
			ДанныеФайла.Владелец);
		
	КонецЕсли;
		
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура Зашифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если НЕ ПодключитьРасширениеРаботыСКриптографией() Тогда
		ФайловыеФункцииСлужебныйКлиент.ПредупредитьОНеобходимостиРасширенияРаботыСКриптографией(
			Команды.Найти("Зашифровать").Заголовок);
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Список.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	МассивДанныхДляЗанесенияВБазу = Новый Массив;
	МассивОтпечатков = Новый Массив;
	
	ФайлЗашифрован = РаботаСФайламиКлиент.Зашифровать(
		ДанныеФайла, УникальныйИдентификатор, МассивДанныхДляЗанесенияВБазу, МассивОтпечатков);
	
	Если НЕ ФайлЗашифрован Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	ЗашифроватьСервер(
		МассивДанныхДляЗанесенияВБазу,
		МассивОтпечатков,
		МассивФайловВРабочемКаталогеДляУдаления,
		ИмяРабочегоКаталога,
		ОбъектСсылка);
	
	РаботаСФайламиКлиент.ИнформироватьОШифровании(
		МассивФайловВРабочемКаталогеДляУдаления,
		ДанныеФайла.Владелец,
		ОбъектСсылка);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура ЗашифроватьСервер(МассивДанныхДляЗанесенияВБазу, МассивОтпечатков, 
	МассивФайловВРабочемКаталогеДляУдаления,
	ИмяРабочегоКаталога, ОбъектСсылка)
	
	Зашифровать = Истина;
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
КонецПроцедуры

&НаКлиенте
Процедура Расшифровать(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ОбъектСсылка = Элементы.Список.ТекущаяСтрока;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИКоличествоВерсий(ОбъектСсылка);
	
	МассивДанныхДляЗанесенияВБазу = Новый Массив;
	
	ФайлРасшифрован = РаботаСФайламиКлиент.Расшифровать(
		ДанныеФайла, УникальныйИдентификатор, МассивДанныхДляЗанесенияВБазу);
	
	Если НЕ ФайлРасшифрован Тогда
		Возврат;
	КонецЕсли;
	
	ИмяРабочегоКаталога = ФайловыеФункцииСлужебныйКлиент.РабочийКаталогПользователя();
	
	РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, 
		ИмяРабочегоКаталога, ОбъектСсылка);
		
	РаботаСФайламиКлиент.ИнформироватьОРасшифровке(
		ДанныеФайла.Владелец, ОбъектСсылка);
		
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаСервере
Процедура РасшифроватьСервер(МассивДанныхДляЗанесенияВБазу, 
	ИмяРабочегоКаталога, ОбъектСсылка)
	
	Зашифровать = Ложь;
	МассивОтпечатков = Новый Массив;
	МассивФайловВРабочемКаталогеДляУдаления = Новый Массив;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗанестиИнформациюОШифровании(
		ОбъектСсылка,
		Зашифровать,
		МассивДанныхДляЗанесенияВБазу,
		Неопределено,  // УникальныйИдентификатор
		ИмяРабочегоКаталога,
		МассивФайловВРабочемКаталогеДляУдаления,
		МассивОтпечатков);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭЦПИзФайла(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(
		Элементы.Список.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.ДобавитьЭЦПИзФайла(ДанныеФайла);
	
	УстановитьДоступностьФайловыхКоманд();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВместеСЭЦП(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Элементы.Список.ТекущаяСтрока);
	
	РаботаСФайламиКлиент.СохранитьВместеСЭЦП(ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS() Тогда
		Элементы.ФормаЭЦПИШифрование.Видимость = Ложь;
		Элементы.ФормаЭЦПИШифрованиеКонтекстное.Видимость = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ТекущийЭлемент = Элементы.Папки Тогда
		Элементы.Папки.Обновить();
	Иначе		
		Элементы.Список.Обновить();
	КонецЕсли;		
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура обновляет правый список
&НаКлиенте
Процедура ОбработкаОжидания()
	Если Элементы.Папки.ТекущаяСтрока <> Список.Параметры.Элементы.Найти("Владелец").Значение Тогда
		Список.Параметры.УстановитьЗначениеПараметра(
			"Владелец", Элементы.Папки.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьДоступностьКоманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
				Элементы.Список.ТекущиеДанные.Редактирует, Элементы.Список.ТекущиеДанные.ПодписанЭЦП,
				Элементы.Список.ТекущиеДанные.Зашифрован);
			Возврат;	
					
		КонецЕсли;	
			
	КонецЕсли;	
	
	СделатьКомандыНедоступными();
	
КонецПроцедуры

&НаКлиенте
Процедура СделатьКомандыНедоступными()
	
	Элементы.ЗакончитьРедактирование.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = Ложь;
	
	Элементы.СохранитьИзменения.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = Ложь;
	
	Элементы.Освободить.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОсвободить.Доступность = Ложь;
	
	Элементы.Занять.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокЗанять.Доступность = Ложь;
	
	Элементы.Редактировать.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокРедактировать.Доступность = Ложь;
	
	Элементы.ПеренестиВРаздел.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокПеренестиВРаздел.Доступность = Ложь;
	
	Элементы.ФормаПодписать.Доступность = Ложь;
	Элементы.ФормаПодписатьКонтекст.Доступность = Ложь;
	
	Элементы.ФормаСохранитьВместеСЭЦП.Доступность = Ложь;
	Элементы.ФормаСохранитьВместеСЭЦПКонтекст.Доступность = Ложь;
	
	Элементы.ФормаЗашифровать.Доступность = Ложь;
	Элементы.ФормаЗашифроватьКонтекст.Доступность = Ложь;
	
	Элементы.ФормаРасшифровать.Доступность = Ложь;
	Элементы.ФормаРасшифроватьКонтекст.Доступность = Ложь;
	
	Элементы.ФормаДобавитьЭЦПИзФайла.Доступность = Ложь;
	Элементы.ФормаДобавитьЭЦПИзФайлаКонтекст.Доступность = Ложь;
	
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Ложь;
	
	Элементы.СохранитьКак.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Ложь;
	
	Элементы.ОткрытьКаталогФайла.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Ложь;
	
	Элементы.ОткрытьФайл.Доступность = Ложь;
	Элементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует, ПодписанЭЦП, Зашифрован)
	
	РедактируетДругой = Не Редактирует.Пустая() И НЕ РедактируетТекущийПользователь;
	
	Элементы.ЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = РедактируетТекущийПользователь;
	
	Элементы.СохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	Элементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = РедактируетТекущийПользователь;
	
	Элементы.Освободить.Доступность = Не Редактирует.Пустая();
	Элементы.КонтекстноеМенюСписокОсвободить.Доступность = Не Редактирует.Пустая();
	
	Элементы.Занять.Доступность = Редактирует.Пустая() И НЕ ПодписанЭЦП;
	Элементы.КонтекстноеМенюСписокЗанять.Доступность = Редактирует.Пустая() И НЕ ПодписанЭЦП;
	
	Элементы.Редактировать.Доступность = НЕ ПодписанЭЦП И НЕ РедактируетДругой;
	Элементы.КонтекстноеМенюСписокРедактировать.Доступность = НЕ ПодписанЭЦП И НЕ РедактируетДругой;
	
	Элементы.ПеренестиВРаздел.Доступность = НЕ ПодписанЭЦП;
	Элементы.КонтекстноеМенюСписокПеренестиВРаздел.Доступность = НЕ ПодписанЭЦП;
	
	Элементы.ФормаПодписать.Доступность = Редактирует.Пустая();
	Элементы.ФормаПодписатьКонтекст.Доступность = Редактирует.Пустая();
	
	Элементы.ФормаСохранитьВместеСЭЦП.Доступность = ПодписанЭЦП;
	Элементы.ФормаСохранитьВместеСЭЦПКонтекст.Доступность = ПодписанЭЦП;
	
	Элементы.ФормаЗашифровать.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	Элементы.ФормаЗашифроватьКонтекст.Доступность = Редактирует.Пустая() И НЕ Зашифрован;
	
	Элементы.ФормаРасшифровать.Доступность = Зашифрован;
	Элементы.ФормаРасшифроватьКонтекст.Доступность = Зашифрован;
	
	Элементы.ФормаДобавитьЭЦПИзФайла.Доступность = Редактирует.Пустая();
	Элементы.ФормаДобавитьЭЦПИзФайлаКонтекст.Доступность = Редактирует.Пустая();
	
	Элементы.ОбновитьИзФайлаНаДиске.Доступность = Не ПодписанЭЦП;
	Элементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Не ПодписанЭЦП;
	
	Элементы.СохранитьКак.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Истина;
	
	Элементы.ОткрытьКаталогФайла.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Истина;
	
	Элементы.ОткрытьФайл.Доступность = Истина;
	Элементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьИерархию(Отметка)
	
	Если Отметка = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Элементы.ИспользоватьИерархию.Пометка = Отметка;
	Если Отметка = Истина Тогда 
		Элементы.Папки.Видимость = Истина;
	Иначе
		Элементы.Папки.Видимость = Ложь;
	КонецЕсли;
	Список.Параметры.УстановитьЗначениеПараметра("ИспользоватьИерархию", Отметка);
	
КонецПроцедуры	
