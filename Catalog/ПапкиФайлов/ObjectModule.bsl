﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// СтандартныеПодсистемы.УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения, Добавления, Изменения: Ссылка
	
	// Доступ по папке файлов.
	Строка = Таблица.Добавить();
	Строка.ВидДоступа      = ПланыВидовХарактеристик["ВидыДоступа"].ПапкиФайлов;
	Строка.ЗначениеДоступа = Ссылка;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	ПометкаИБ = ПометкаУдаленияВИБ();
	Если ПометкаУдаления И Не ПометкаИБ Тогда
		
		// Проверка права "Пометка на удаление".
		ПометкаНаУдалениеРазрешена = Истина;
		РаботаСФайламиСлужебный.ПриОпределенииПраваПометкиУдаления(
			Ссылка, ПометкаНаУдалениеРазрешена);
		
		Если НЕ ПометкаНаУдалениеРазрешена Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'У вас нет права ""Пометка на удаление"" папки файлов ""%1"".'"),
				Строка(Ссылка));
		КонецЕсли;
	КонецЕсли;
	
	Если ПометкаУдаления <> ПометкаИБ И Не Ссылка.Пустая() Тогда
		// Отбираем файлы и пытаемся поставить им пометку удаления
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Файлы.Ссылка,
			|	Файлы.Редактирует
			|ИЗ
			|	Справочник.Файлы КАК Файлы
			|ГДЕ
			|	Файлы.ВладелецФайла = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если Не Выборка.Редактирует.Пустая() Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                     НСтр("ru = 'Папку %1 нельзя удалить, т.к. она содержит файл ""%2"", занятый для редактирования.'"),
				                     Строка(Ссылка),
				                     Строка(Выборка.Ссылка));
			КонецЕсли;

			ФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ФайлОбъект.Заблокировать();
			ФайлОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		КонецЦикла;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПрошлыйЭтоНовый", ЭтоНовый());
	
	Если НЕ ЭтоНовый() Тогда
		
		Если Наименование <> Ссылка.Наименование Тогда // переименована папка
			РабочийКаталогПапки         = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка);
			РабочийКаталогРодителяПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка.Родитель);
			Если РабочийКаталогРодителяПапки <> "" Тогда
				
				// Добавляем слэш в конце, если его нет
				РабочийКаталогРодителяПапки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
					РабочийКаталогРодителяПапки, ОбщегоНазначенияПовтИсп.ТипПлатформыСервера());
				
				РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки
					+ Ссылка.Наименование + ОбщегоНазначенияКлиентСервер.РазделительПути();
					
				Если РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогПапки Тогда
					
					НовыйРабочийКаталогПапки = РабочийКаталогРодителяПапки
						+ Наименование + ОбщегоНазначенияКлиентСервер.РазделительПути();
					
					РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, НовыйРабочийКаталогПапки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Родитель <> Ссылка.Родитель Тогда // перенесли папку в другую папку
			РабочийКаталогПапки               = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка);
			РабочийКаталогРодителяПапки       = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка.Родитель);
			РабочийКаталогНовогоРодителяПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Родитель);
			
			Если РабочийКаталогРодителяПапки <> "" ИЛИ РабочийКаталогНовогоРодителяПапки <> "" Тогда
				
				РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки;
				
				Если РабочийКаталогРодителяПапки <> "" Тогда
					РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки
						+ Ссылка.Наименование + ОбщегоНазначенияКлиентСервер.РазделительПути();
				КонецЕсли;
				
				Если РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогПапки Тогда // Рабочий каталог автоформируется от родителя.
					Если РабочийКаталогНовогоРодителяПапки <> "" Тогда
						
						НовыйРабочийКаталогПапки = РабочийКаталогНовогоРодителяПапки
							+ Наименование + ОбщегоНазначенияКлиентСервер.РазделительПути();
						
						РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, НовыйРабочийКаталогПапки);
					Иначе
						РаботаСФайламиСлужебныйВызовСервера.ОчиститьРабочийКаталог(Ссылка);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ПрошлыйЭтоНовый Тогда
		РабочийКаталогПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Родитель);
		Если РабочийКаталогПапки <> "" Тогда
			
			// Добавляем слэш в конце, если его нет
			РабочийКаталогПапки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
				РабочийКаталогПапки, ОбщегоНазначенияПовтИсп.ТипПлатформыСервера());
			
			РабочийКаталогПапки = РабочийКаталогПапки
				+ Наименование + ОбщегоНазначенияКлиентСервер.РазделительПути();
			
			РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, РабочийКаталогПапки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ДатаСоздания = ТекущаяДатаСеанса();
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНайденныхНедопустимыхСимволов = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(Наименование);
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		Отказ = Истина;
		
		Текст = НСтр("ru = 'Наименование папки содержит запрещенные символы ( \ / : * ? "" < > | .. )'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Наименование");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Возвращает текущее значение пометки удаления в информационной базе
Функция ПометкаУдаленияВИБ()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПапкиФайлов.ПометкаУдаления
		|ИЗ
		|	Справочник.ПапкиФайлов КАК ПапкиФайлов
		|ГДЕ
		|	ПапкиФайлов.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);

	Результат = Запрос.Выполнить();

	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.ПометкаУдаления;
	КонецЕсли;	
	
	Возврат Неопределено;
КонецФункции

#КонецЕсли