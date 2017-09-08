﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// Описание обработки
// Табличная часть Операции - содержит набор информации, описывающей изменения.
// Одна запись при этом описывает одно изменение.
// Реквизиты табличной части:
//		ВидОперации - число - описывает ЧТО делать:
//								1 - изменение реквизита
//								2 - изменение дополнительного реквизита
//								3 - изменение дополнительного свойства
//		ИмяРеквизита - строка - имя изменяемого реквизита (вид операции = 1)
//		Свойство	- ПВХ - ссылка на изменяемое свойство (вид операции = 2 или 3)
//		Представление - строка - представление операции для пользователя,
//					при ВидОперации = 1 - синоним реквизита
//					при ВидОперации - 2 и 3 - наименование свойства
//		Изменять - Булево - индикатор того, что операция должна быть совершена
//					единственный способ очистки значений
//		Значение - Новое значение
//		ЗаблокированныйРеквизит - Булево - это заблокированный реквизит
//		ДопустимыеТипы - Строка - содержит перечисление названий типов (через ";")
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ОПИСАНИЯ ПЕРЕМЕННЫХ

Перем УправлениеСвойствамиМодуль;

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура заполняет таблицу операций объекта:
// 1. Реквизиты
// 2. Свойства
//
Процедура ЗаполнитьТаблицуОперацийСОбъектом() Экспорт
	
	Перем 
		ИспользуетсяЗапретРедактированияРеквизитов;
		
	ПервыйИзменяемый = ОбъектыДляИзменения[0].СсылкаНаОбъект;
	
	ОбъектМетаданных = ПервыйИзменяемый.Метаданные();
	
	// Получаем менеджер объекта для получения массивов не редактируемых
	// интерактивно и блокируемых реквизитов
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
	
	БлокируемыеРеквизиты = Новый Массив;
	
	// Пытаемся определить, есть ли у объекта блокируемые реквизиты (подсистема запрета редактирования
	// реквизитов объектов). Для этого в блоке Попытка .. Исключение пытаемся позвать у объекта метод
	// ПолучитьБлокируемыеРеквизитыОбъекта.
	Попытка
		БлокируемыеРеквизитыОписание = МенеджерОбъекта.ПолучитьБлокируемыеРеквизитыОбъекта();
		Для Каждого БлокируемыйРеквизитОписание Из БлокируемыеРеквизитыОписание Цикл
			БлокируемыеРеквизиты.Добавить( СокрЛП (
				СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
					БлокируемыйРеквизитОписание, ";")[0] ) );
		КонецЦикла;
	Исключение
	КонецПопытки;
	
	ФильтруемыеРеквизиты = ПолучитьФильтрРедактированияПоТипу(ОбъектМетаданных);
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Фильтрация по отключенным функциональными опциями
	
	ЗакрытыеФункциональнымиОпциями = Новый ТаблицаЗначений;
	ЗакрытыеФункциональнымиОпциями.Колонки.Добавить("ИмяРеквизита",  Новый ОписаниеТипов("Строка"));
	
	Для Каждого ОписаниеФО Из Метаданные.ФункциональныеОпции Цикл
		
		Если СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОписаниеФО.Хранение.ПолноеИмя(), ".")[0] = "Константа" Тогда
			ЗначениеФО = ПолучитьФункциональнуюОпцию(ОписаниеФО.Имя);
			Если ТипЗнч(ЗначениеФО) = Тип("Булево") И ЗначениеФО = Истина Тогда
				Продолжить;
			КонецЕсли;
		Иначе
			// не фильтруем реквизиты, которые входят в параметризуемые функциональные опции
			Продолжить;
		КонецЕсли;
		
		Для Каждого РеквизитОМ Из ОбъектМетаданных.Реквизиты Цикл
			Если ОписаниеФО.Состав.Содержит(РеквизитОМ) Тогда
				НоваяСтрока = ЗакрытыеФункциональнымиОпциями.Добавить();
				НоваяСтрока.ИмяРеквизита = РеквизитОМ.Имя;
			КонецЕСли;
		КонецЦикла;
		
	КонецЦикла;
	
	ЗакрытыеФункциональнымиОпциями.Свернуть("ИмяРеквизита");
	
	Для Каждого ЗакрытыйФО Из ЗакрытыеФункциональнымиОпциями Цикл
		ФильтруемыеРеквизиты.Добавить(ЗакрытыйФО.ИмяРеквизита);
	КонецЦикла;
	
	// Фильтрация по отключенным функциональными опциями
	//////////////////////////////////////////////////////////////////////////////////////////
	
	Операции.Очистить();
	
	Попытка
		НеРедактируемые = МенеджерОбъекта.РеквизитыНеРедактируемыеВГрупповойОбработке();
	Исключение
		НеРедактируемые = Новый Массив;
	КонецПопытки;
	
	Если НеРедактируемые.Количество() = 0 Тогда
		Попытка
			Редактируемые = МенеджерОбъекта.РеквизитыРедактируемыеВГрупповойОбработке();
			
			Для Каждого ОписаниеРеквизита Из ОбъектМетаданных.СтандартныеРеквизиты Цикл
				НеРедактируемые.Добавить(ОписаниеРеквизита.Имя);
			КонецЦикла;
			
			Для Каждого ОписаниеРеквизита Из ОбъектМетаданных.Реквизиты Цикл
				НеРедактируемые.Добавить(ОписаниеРеквизита.Имя);
			КонецЦикла;
			
			Для Каждого ИмяРедактируемого Из Редактируемые Цикл
				Индекс = НеРедактируемые.Найти(ИмяРедактируемого);
				Если Индекс = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				НеРедактируемые.Удалить(Индекс);
			КонецЦикла;
			
		Исключение
			// Если не определены ни редактируемые, ни не редактируемые реквизиты - ничего не делаем
		КонецПопытки;
	КонецЕсли;
	
	ДобавитьРеквизитыВНабор(ОбъектМетаданных.СтандартныеРеквизиты,
							НеРедактируемые,
							ФильтруемыеРеквизиты,
							БлокируемыеРеквизиты,
							ОбъектМетаданных);
	
	ДобавитьРеквизитыВНабор(ОбъектМетаданных.Реквизиты,
							НеРедактируемые,
							ФильтруемыеРеквизиты,
							БлокируемыеРеквизиты,
							ОбъектМетаданных);
	
	Операции.Сортировать("Представление Возр");
	
	Если УправлениеСвойствамиМодуль <> Неопределено Тогда
		ИспользуютсяДопРеквизиты = УправлениеСвойствамиМодуль.ИспользоватьДопРеквизиты(ОбъектыДляИзменения[0].СсылкаНаОбъект);
		ИспользуютсяДопСведения  = УправлениеСвойствамиМодуль.ИспользоватьДопСведения (ОбъектыДляИзменения[0].СсылкаНаОбъект);
		
		Если УправлениеСвойствамиМодуль <> Неопределено И (ИспользуютсяДопРеквизиты ИЛИ ИспользуютсяДопСведения) Тогда
			ДобавитьДополнительныеРеквизитыИСведенияВНабор();
		КонецЕсли;
	Иначе
		ИспользуютсяДопРеквизиты = Ложь;
		ИспользуютсяДопСведения = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьДополнительныеРеквизитыИСведенияВНабор()
	
	ТаблицаДопРеквизитов = Новый ТаблицаЗначений;
	ТаблицаДопРеквизитов.Колонки.Добавить("Свойство",  Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"));
	ТаблицаДопРеквизитов.Колонки.Добавить("Наименование",  Новый ОписаниеТипов("Строка"));
	ТаблицаДопРеквизитов.Колонки.Добавить("ТипЗначения",  Новый ОписаниеТипов("ОписаниеТипов"));
	
	ТаблицаДопСведений = Новый ТаблицаЗначений;
	ТаблицаДопСведений.Колонки.Добавить("Свойство",  Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ДополнительныеРеквизитыИСведения"));
	ТаблицаДопСведений.Колонки.Добавить("Наименование",  Новый ОписаниеТипов("Строка"));
	ТаблицаДопСведений.Колонки.Добавить("ТипЗначения",  Новый ОписаниеТипов("ОписаниеТипов"));
	
	Для Каждого ОбъектДляИзменения Из ОбъектыДляИзменения Цикл
		
		ВидОбъектаПоСсылке = ОбщегоНазначения.ВидОбъектаПоСсылке(ОбъектДляИзменения.СсылкаНаОбъект);
		Если (ВидОбъектаПоСсылке = "Справочник" ИЛИ ВидОбъектаПоСсылке = "ПланВидовХарактеристик")
		   И ОбщегоНазначения.ОбъектЯвляетсяГруппой(ОбъектДляИзменения.СсылкаНаОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
			ДопРеквизиты = УправлениеСвойствамиМодуль.ПолучитьСписокСвойств(ОбъектДляИзменения.СсылкаНаОбъект, , Ложь);
			
			Для Каждого СвойствоСсылка Из ДопРеквизиты Цикл
				ОбъектДляИзменения.СоставДопРеквизитов = ОбъектДляИзменения.СоставДопРеквизитов + Строка(СвойствоСсылка.УникальныйИдентификатор()) + Символы.ПС;
				НоваяСтрока = ТаблицаДопРеквизитов.Добавить();
				
				ОбъектСвойство = СвойствоСсылка.ПолучитьОбъект();
				
				НоваяСтрока.Свойство	= ОбъектСвойство.Ссылка;;
				НоваяСтрока.Наименование= ОбъектСвойство.Наименование;
				НоваяСтрока.ТипЗначения	= ОбъектСвойство.ТипЗначения;
			КонецЦикла;
			
			ДопСведения = УправлениеСвойствамиМодуль.ПолучитьСписокСвойств(ОбъектДляИзменения.СсылкаНаОбъект, Ложь);
			
			Для Каждого СвойствоСсылка Из ДопСведения Цикл
				ОбъектДляИзменения.СоставДопСведений = ОбъектДляИзменения.СоставДопСведений + Строка(СвойствоСсылка.УникальныйИдентификатор()) + Символы.ПС;
				НоваяСтрока = ТаблицаДопСведений.Добавить();
				
				ОбъектСвойство = СвойствоСсылка.ПолучитьОбъект();
				
				НоваяСтрока.Свойство	= ОбъектСвойство.Ссылка;;
				НоваяСтрока.Наименование= ОбъектСвойство.Наименование;
				НоваяСтрока.ТипЗначения	= ОбъектСвойство.ТипЗначения;
			КонецЦикла;
		
	КонецЦикла;
	
	ТаблицаДопРеквизитов.Свернуть("Свойство,Наименование,ТипЗначения");
	ТаблицаДопРеквизитов.Сортировать("Наименование Возр");
	ТаблицаДопСведений.Свернуть("Свойство,Наименование,ТипЗначения");
	ТаблицаДопСведений.Сортировать("Наименование Возр");
	
	ДобавитьСвойствоВТаблицуОпераций(ТаблицаДопРеквизитов);
	ДобавитьСвойствоВТаблицуОпераций(ТаблицаДопСведений, Ложь);
	
КонецПроцедуры

Процедура ДобавитьСвойствоВТаблицуОпераций(ТаблицаДопСвойств, ЭтоДопРеквизит = Истина)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДопСвойств Цикл
		НоваяОперация = Операции.Добавить();
		НоваяОперация.ВидОперации = ?(ЭтоДопРеквизит, 2, 3);
		НоваяОперация.Свойство		= СтрокаТаблицы.Свойство;
		НоваяОперация.Представление = СтрокаТаблицы.Наименование;
		НоваяОперация.ДопустимыеТипы = XMLСтрока(Новый ХранилищеЗначения(СтрокаТаблицы.ТипЗначения));
	КонецЦикла;
	
КонецПроцедуры

// Добавляет в набор операций (фактически набор реквизитов и свойств) те,
// которые могут быть отредактированы
// В него не попадают:
//  не редактируемые - зависят от настроек самого объекта метаданных
//  фильтруемые - задаются для класса объектов метаданных
// В него попадают с исключением:
//  БлокируемыеРеквизиты - реквизиты, которые могут редактироваться
//  только при наличии у пользователя роли РедактированиеРеквизитовОбъектов
// Передаваемые параметры:
// Реквизиты - коллекция реквизитов (стандартных реквизитов) объекта метаданных
// НеРедактируемые, ФильтруемыеРеквизиты - массив - фильтр по реквизитам
// БлокируемыеРеквизиты - массив - блокируемые реквизиты
//
Процедура ДобавитьРеквизитыВНабор(Реквизиты,
								НеРедактируемые,
								ФильтруемыеРеквизиты,
								БлокируемыеРеквизиты,
								ОбъектМетаданных)
	
	Для Каждого ОписаниеРеквизита Из Реквизиты Цикл
	
		Если ТипЗнч(ОписаниеРеквизита) = Тип("ОписаниеСтандартногоРеквизита") Тогда
			Если НЕ ПравоДоступа("Редактирование", ОбъектыДляИзменения[0].СсылкаНаОбъект.Метаданные(), , ОписаниеРеквизита.Имя) Тогда
				Продолжить;
			КонецЕсли;
		Иначе
			Если НЕ ПравоДоступа("Редактирование", ОписаниеРеквизита) Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если НеРедактируемые.Найти(ОписаниеРеквизита.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ФильтруемыеРеквизиты.Найти(ОписаниеРеквизита.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ВыборГруппИЭлементов = "";
		
		Если ТипЗнч(ОписаниеРеквизита) = Тип("ОписаниеСтандартногоРеквизита") Тогда
			
			Если    ОписаниеРеквизита.Имя = "Родитель"
				ИЛИ ОписаниеРеквизита.Имя = "Parent" Тогда
				
				ВыборГруппИЭлементов = "Группы";
				
			ИначеЕсли ОписаниеРеквизита.Имя = "Владелец"
				ИЛИ   ОписаниеРеквизита.Имя = "Owner" Тогда
				
				Если ОбъектМетаданных.ИспользованиеПодчинения = Метаданные.СвойстваОбъектов.ИспользованиеПодчинения.Элементам Тогда
					
					ВыборГруппИЭлементов = "Элементы";
					
				ИначеЕсли ОбъектМетаданных.ИспользованиеПодчинения = Метаданные.СвойстваОбъектов.ИспользованиеПодчинения.ГруппамИЭлементам Тогда
					
					ВыборГруппИЭлементов = "ГруппыИЭлементы";
					
				ИначеЕсли ОбъектМетаданных.ИспользованиеПодчинения = Метаданные.СвойстваОбъектов.ИспользованиеПодчинения.Группам Тогда
					
					ВыборГруппИЭлементов = "Группы";
					
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			ЭтоСсылка = Ложь;
			Для Каждого Тип Из ОписаниеРеквизита.Тип.Типы() Цикл
				Если ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
					ЭтоСсылка = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ЭтоСсылка Тогда
				Если ОписаниеРеквизита.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Группы Тогда
					ВыборГруппИЭлементов = "Группы";
				ИначеЕсли ОписаниеРеквизита.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы Тогда
					ВыборГруппИЭлементов = "ГруппыИЭлементы";
				ИначеЕсли ОписаниеРеквизита.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы Тогда
					ВыборГруппИЭлементов = "Элементы";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ДопустимыеТипыСтрока = XMLСтрока(Новый ХранилищеЗначения(ОписаниеРеквизита.Тип));
		
		ПараметрыВыбораСтрока = "";
		
		Для Каждого ОписаниеПараметраВыбора Из ОписаниеРеквизита.ПараметрыВыбора Цикл
			
			ТекущийПВСтрока = "[ПолеОтбора];[ТипСтрока];[ЗначениеСтрока]";
			
			ТипЗначения = ТипЗнч(ОписаниеПараметраВыбора.Значение);
			
			Если ТипЗначения = Тип("ФиксированныйМассив") Тогда
				
				СтроковоеПредставлениеТипа = "ФиксированныйМассив";
				ЗначениеСтрока = "";
				
				Для Каждого Элемент Из ОписаниеПараметраВыбора.Значение Цикл
					
					ЗначениеСтрокаШаблон = "[Тип]%[Значение]";
					ЗначениеСтрокаШаблон = СтрЗаменить(ЗначениеСтрокаШаблон, "[Тип]", ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗнч(Элемент)));
					ЗначениеСтрокаШаблон = СтрЗаменить(ЗначениеСтрокаШаблон, "[Значение]", XMLСтрока(Элемент));
					ЗначениеСтрока = ЗначениеСтрока + ?(ПустаяСтрока(ЗначениеСтрока), "", "%%") + ЗначениеСтрокаШаблон;
					
				КонецЦикла;
				
			Иначе
				СтроковоеПредставлениеТипа = ОбщегоНазначения.СтроковоеПредставлениеТипа(ТипЗначения);
				ЗначениеСтрока = XMLСтрока(ОписаниеПараметраВыбора.Значение);
			КонецЕсли;
			
			Если Не ПустаяСтрока(ЗначениеСтрока) Тогда
				
				ТекущийПВСтрока = СтрЗаменить(ТекущийПВСтрока, "[ПолеОтбора]", ОписаниеПараметраВыбора.Имя);
				ТекущийПВСтрока = СтрЗаменить(ТекущийПВСтрока, "[ТипСтрока]", СтроковоеПредставлениеТипа);
				ТекущийПВСтрока = СтрЗаменить(ТекущийПВСтрока, "[ЗначениеСтрока]", ЗначениеСтрока);
				
				ПараметрыВыбораСтрока = ПараметрыВыбораСтрока + ТекущийПВСтрока + Символы.ПС;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыВыбораСтрока = Лев(ПараметрыВыбораСтрока, СтрДлина(ПараметрыВыбораСтрока)-1);
		
		СвязиПараметровВыбораСтрока = "";
		
		Для Каждого ОписаниеСвязиПараметровВыбора Из ОписаниеРеквизита.СвязиПараметровВыбора Цикл
			ТекущаяСПВСтрока = "[ИмяПараметра];[ИмяРеквизита]";
			ТекущаяСПВСтрока = СтрЗаменить(ТекущаяСПВСтрока, "[ИмяПараметра]", ОписаниеСвязиПараметровВыбора.Имя);
			ТекущаяСПВСтрока = СтрЗаменить(ТекущаяСПВСтрока, "[ИмяРеквизита]", ОписаниеСвязиПараметровВыбора.ПутьКДанным);
			СвязиПараметровВыбораСтрока = СвязиПараметровВыбораСтрока + ТекущаяСПВСтрока + Символы.ПС;
		КонецЦикла;
		
		СвязиПараметровВыбораСтрока = Лев(СвязиПараметровВыбораСтрока, СтрДлина(СвязиПараметровВыбораСтрока)-1);
		
		НоваяОперация = Операции.Добавить();
		НоваяОперация.ИмяРеквизита = ОписаниеРеквизита.Имя;
		НоваяОперация.Представление = ?(ПустаяСтрока(ОписаниеРеквизита.Синоним), ОписаниеРеквизита.Имя, ОписаниеРеквизита.Синоним);
		НоваяОперация.ВидОперации = 1; // реквизит
		НоваяОперация.ДопустимыеТипы = ДопустимыеТипыСтрока;
		НоваяОперация.ПараметрыВыбора = ПараметрыВыбораСтрока;
		НоваяОперация.СвязиПараметровВыбора = СвязиПараметровВыбораСтрока;
		НоваяОперация.ВыборГруппИЭлементов = ВыборГруппИЭлементов;
		
		Если БлокируемыеРеквизиты.Найти(ОписаниеРеквизита.Имя) <> Неопределено Тогда
			НоваяОперация.ЗаблокированныйРеквизит = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Получает массив реквизитов, редактирование которых не предусмотрено
// на уровне конфигурации
//
Функция ПолучитьФильтрРедактированияПоТипу(ОбъектМетаданных)
	
	ФильтрXML = Обработки.ГрупповоеИзменениеОбъектов.ПолучитьМакет("ФильтрРеквизитов").ПолучитьТекст();
	
	ФильтрТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ФильтрXML).Данные;
	
	// Реквизиты, блокируемые для любого типа объектов метаданных
	ОбщийФильтр = ФильтрТаблица.НайтиСтроки(Новый Структура("ObjectType", "*"));
	
	// Реквизиты, блокируемые для указанного типа объектов метаданных
	ФильтрПоТипуОМ = ФильтрТаблица.НайтиСтроки(
							Новый Структура("ObjectType", 
							ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(ОбъектМетаданных)) );
	
	ФильтруемыеРеквизиты = Новый Массив;
	
	Для Каждого СтрокаОписание Из ОбщийФильтр Цикл
		ФильтруемыеРеквизиты.Добавить(СтрокаОписание.Attribute);
	КонецЦикла;
	
	Для Каждого СтрокаОписание Из ФильтрПоТипуОМ Цикл
		ФильтруемыеРеквизиты.Добавить(СтрокаОписание.Attribute);
	КонецЦикла;
	
	Возврат ФильтруемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// РАЗДЕЛ ИНИЦИАЛИЗАЦИИ

// Для использования обработки без подсистемы свойств, связь с модулем УправлениеСвойствами
// вычисляется в режиме предприятия, а не на этапе компиляции
УправлениеСвойствамиМодуль =
	?(Метаданные.НайтиПоПолномуИмени("ОбщийМодуль.УправлениеСвойствами") = Неопределено,
				Неопределено,
				Вычислить("УправлениеСвойствами"));

#КонецЕсли