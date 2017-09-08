﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Перем СтарыеРолиПрофиля; // Роли профиля до изменения для использования
                         // в обработчике события ПриЗаписи.

Перем СтараяПометкаУдаления; // Пометка удаления профиля групп доступа до изменения
                             // для использования в обработчике события ПриЗаписи.

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Получение старых ролей профиля.
	РезультатЗапроса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Роли");
	Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
		СтарыеРолиПрофиля = РезультатЗапроса.Выгрузить();
	Иначе
		СтарыеРолиПрофиля = Роли.Выгрузить(Новый Массив);
	КонецЕсли;

	СтараяПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Ссылка, "ПометкаУдаления");
	
	Если Ссылка = Справочники.ПрофилиГруппДоступа.Администратор Тогда
		Пользователь = Неопределено;
	Иначе
		// Проверка ролей.
		НомерСтроки = Роли.Количество() - 1;
		Пока НомерСтроки >= 0 Цикл
			Если ВРег(Роли[НомерСтроки].Роль) = ВРег("ПолныеПрава")
			 ИЛИ ВРег(Роли[НомерСтроки].Роль) = ВРег("АдминистраторСистемы") Тогда
				
				Роли.Удалить(НомерСтроки);
			КонецЕсли;
			НомерСтроки = НомерСтроки - 1;
		КонецЦикла;
	КонецЕсли;
	
	// Удаление всегда используемых видов доступа.
	Отбор = Новый Структура("ВидДоступаИспользуетсяВсегда", Истина);
	ВидыДоступаИспользуемыеВсегда = УправлениеДоступомСлужебный.СвойстваВидаДоступа().НайтиСтроки(Отбор);
	
	Для каждого СвойстваВидаДоступа Из ВидыДоступаИспользуемыеВсегда Цикл
		Отбор = Новый Структура("ВидДоступа", СвойстваВидаДоступа.ВидДоступа);
		Для каждого Строка Из ВидыДоступа.НайтиСтроки(Отбор) Цикл
			ВидыДоступа.Удалить(Строка);
		КонецЦикла;
	КонецЦикла;
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРеквизитПоставляемыйПрофильИзменен") Тогда
		ПоставляемыйПрофильИзменен =
			Справочники.ПрофилиГруппДоступа.ПоставляемыйПрофильИзменен(ЭтотОбъект);
	КонецЕсли;
	
	ИнтерфейсУпрощенный = УправлениеДоступомПереопределяемый.УпрощенныйИнтерфейсНастройкиПравДоступа();
	
	Если ИнтерфейсУпрощенный Тогда
		// Обновление наименования у персональных групп доступа этого профиля (если есть)
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Профиль",      Ссылка);
		Запрос.УстановитьПараметр("Наименование", Наименование);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	ГруппыДоступа.Профиль = &Профиль
		|	И ГруппыДоступа.Пользователь <> НЕОПРЕДЕЛЕНО
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.Пользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Пользователь <> ЗНАЧЕНИЕ(Справочник.ВнешниеПользователи.ПустаяСсылка)
		|	И ГруппыДоступа.Наименование <> &Наименование";
		ИзмененныеГруппыДоступа = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		Если ИзмененныеГруппыДоступа.Количество() > 0 Тогда
			Для каждого ГруппаДоступаСсылка Из ИзмененныеГруппыДоступа Цикл
				ПерсональнаяГруппаДоступаОбъект = ГруппаДоступаСсылка.ПолучитьОбъект();
				ПерсональнаяГруппаДоступаОбъект.Наименование = Наименование;
				ПерсональнаяГруппаДоступаОбъект.ОбменДанными.Загрузка = Истина;
				ПерсональнаяГруппаДоступаОбъект.Записать();
			КонецЦикла;
			ДополнительныеСвойства.Вставить(
				"ПерсональныеГруппыДоступаСОбновленнымНаименованием", ИзмененныеГруппыДоступа);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка однозначности поставляемых данных.
	Если ИдентификаторПоставляемыхДанных <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		УстановитьПривилегированныйРежим(Истина);
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ИдентификаторПоставляемыхДанных", ИдентификаторПоставляемыхДанных);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ПрофилиГруппДоступа.Ссылка КАК Ссылка,
		|	ПрофилиГруппДоступа.Наименование КАК Наименование
		|ИЗ
		|	Справочник.ПрофилиГруппДоступа КАК ПрофилиГруппДоступа
		|ГДЕ
		|	ПрофилиГруппДоступа.ИдентификаторПоставляемыхДанных = &ИдентификаторПоставляемыхДанных";
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Количество() > 1 Тогда
			
			КраткоеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи профиля ""%1"".
				           |Поставляемый профиль уже существует:'"),
				Наименование);
			
			ПодробноеПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка при записи профиля ""%1"".
				           |Идентификатор поставляемых данных ""%2"" уже используется в профиле:'"),
				Наименование,
				Строка(ИдентификаторПоставляемыхДанных));
			
			Пока Выборка.Следующий() Цикл
				Если Выборка.Ссылка <> Ссылка Тогда
					
					КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """.";
					
					ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки
						+ Символы.ПС + """" + Выборка.Наименование + """ ("
						+ Строка(Выборка.Ссылка.УникальныйИдентификатор())+ ")."
				КонецЕсли;
			КонецЦикла;
			
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Управление доступом.Нарушение однозначности поставляемого профиля'",
				     ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки);
			
			ВызватьИсключение КраткоеПредставлениеОшибки;
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ОбъектыМетаданных = ОбновитьРолиПользователейПриИзмененииРолейПрофиля();
	
	// При установке пометки удаления нужно установить пометку удаления у групп доступа профиля.
	Если ПометкаУдаления И СтараяПометкаУдаления = Ложь Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Профиль", Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГруппыДоступа.Ссылка
		|ИЗ
		|	Справочник.ГруппыДоступа КАК ГруппыДоступа
		|ГДЕ
		|	(НЕ ГруппыДоступа.ПометкаУдаления)
		|	И ГруппыДоступа.Профиль = &Профиль";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ЗаблокироватьДанныеДляРедактирования(Выборка.Ссылка);
			ГруппаДоступаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ГруппаДоступаОбъект.ПометкаУдаления = Истина;
			ГруппаДоступаОбъект.Записать();
		КонецЦикла;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновитьГруппыДоступаПрофиля") Тогда
		Справочники.ГруппыДоступа.ОбновитьГруппыДоступаПрофиля(Ссылка, Истина);
	КонецЕсли;
	
	// Обновление таблиц и значений групп доступа.
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профиль", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГруппыДоступа.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ГруппыДоступа КАК ГруппыДоступа
	|ГДЕ
	|	ГруппыДоступа.Профиль = &Профиль
	|	И (НЕ ГруппыДоступа.ЭтоГруппа)";
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ГруппыДоступаПрофиля = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
		
		РегистрыСведений.ЗначенияГруппДоступа.ОбновитьДанныеРегистра(ГруппыДоступаПрофиля);
		
		Если ОбъектыМетаданных.Количество() > 0 Тогда
			РегистрыСведений.ТаблицыГруппДоступа.ОбновитьДанныеРегистра(
				ГруппыДоступаПрофиля, ОбъектыМетаданных);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
			ПроверяемыеРеквизиты, ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если НЕ ЭтоГруппа Тогда
		ИдентификаторПоставляемыхДанных = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

Функция ОбновитьРолиПользователейПриИзмененииРолейПрофиля()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Профиль", Ссылка);
	Запрос.УстановитьПараметр("СтарыеРолиПрофиля", СтарыеРолиПрофиля);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтарыеРолиПрофиля.Роль
	|ПОМЕСТИТЬ СтарыеРолиПрофиля
	|ИЗ
	|	&СтарыеРолиПрофиля КАК СтарыеРолиПрофиля
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Данные.Роль
	|ПОМЕСТИТЬ ИзмененныеРоли
	|ИЗ
	|	(ВЫБРАТЬ
	|		СтарыеРолиПрофиля.Роль КАК Роль,
	|		-1 КАК ВидИзмененияСтроки
	|	ИЗ
	|		СтарыеРолиПрофиля КАК СтарыеРолиПрофиля
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		НовыеРолиПрофиля.Роль,
	|		1
	|	ИЗ
	|		Справочник.ПрофилиГруппДоступа.Роли КАК НовыеРолиПрофиля
	|	ГДЕ
	|		НовыеРолиПрофиля.Ссылка = &Профиль) КАК Данные
	|
	|СГРУППИРОВАТЬ ПО
	|	Данные.Роль
	|
	|ИМЕЮЩИЕ
	|	СУММА(Данные.ВидИзмененияСтроки) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Данные.Роль";
	
	Запрос.Текст = Запрос.Текст + "
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|" +
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПраваРолей.ОбъектМетаданных
	|ИЗ
	|	РегистрСведений.ПраваРолей КАК ПраваРолей
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИзмененныеРоли КАК ИзмененныеРоли
	|		ПО ПраваРолей.Роль = ИзмененныеРоли.Роль";
	
	РезультатыЗапросов = Запрос.ВыполнитьПакет();
	
	Если НЕ ДополнительныеСвойства.Свойство("НеОбновлятьРолиПользователей")
	   И НЕ РезультатыЗапросов[1].Пустой() Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СоставыГруппПользователей.Пользователь
		|ИЗ
		|	РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|		ПО СоставыГруппПользователей.ГруппаПользователей = ГруппыДоступаПользователи.Пользователь
		|			И (ГруппыДоступаПользователи.Ссылка.Профиль = &Профиль)";
		
		ПользователиДляОбновленияРолей =
			Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
		
		УправлениеДоступом.ОбновитьРолиПользователей(ПользователиДляОбновленияРолей);
	КонецЕсли;
	
	Возврат РезультатыЗапросов[2].Выгрузить().ВыгрузитьКолонку("ОбъектМетаданных");
	
КонецФункции

#КонецЕсли
