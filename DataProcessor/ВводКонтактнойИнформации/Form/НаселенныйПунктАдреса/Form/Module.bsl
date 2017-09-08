﻿// Форма параметризуется при помощи:
//      
//  КодНаселенногоПункта (число) - если указано, то код текущего адресного классификатора для 
//                                 определения и редактирования частей формы.
//
//  НаселенныйПунктДетально      - структура, зависящая от адресного  классификатора с 
//                                 описанием частей населенного пункта. Используется, только если 
//                                 указан нулевой КодНаселенногоПункта
//
// СкрыватьНеактуальныеАдреса    - флаг того, что при редактировании неактуальные адреса будут 
//                                 скрываться
//
// -------------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоПлатформа83 = ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83();
	
	МожноЗагружатьКлассификатор = КонтактнаяИнформацияСлужебный.ЕстьВозможностьИзмененияАдресногоКлассификатора();
	
	ПрефиксИмениЧастиАдреса = "Часть";
	
	// Ставим реквизиты формы
	Если Параметры.КодНаселенногоПункта>0 Тогда
		ЧастиАдреса = КонтактнаяИнформацияСлужебный.СписокРеквизитовНаселенныйПункт(Параметры.КодНаселенногоПункта);
	Иначе
		ЧастиАдреса = Параметры.НаселенныйПунктДетально;
	КонецЕсли;
	
	Если ЧастиАдреса=Неопределено Или ЧастиАдреса.Количество()=0 Тогда
		ЧастиАдреса = КонтактнаяИнформацияСлужебный.СписокРеквизитовНаселенныйПункт();
	КонецЕсли;
	
	СкрыватьНеактуальныеАдреса = Параметры.СкрыватьНеактуальныеАдреса;
	ПостроитьФормуПоЧастямАдреса();
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ
//

&НаКлиенте
Процедура КомандаОК(Команда)
	// При немодифицированности работает как "отмена"
	Если Модифицированность Тогда
		Результат = Новый Структура("Код, Представление, НаселенныйПунктДетально", 
			КодНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса), 
			УправлениеКонтактнойИнформациейКлиент.НаименованиеНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса), 
			ЧастиАдреса);
		
#Если ВебКлиент Тогда
		ФлагЗакрытия = ЗакрыватьПриВыборе;
		ЗакрыватьПриВыборе = Ложь;
		ОповеститьОВыборе(Результат);
		ЗакрыватьПриВыборе = ФлагЗакрытия;
#Иначе
		ОповеститьОВыборе(Результат);
#КонецЕсли
		
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда        
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаСервере
Процедура ПостроитьФормуПоЧастямАдреса()
	Добавлять = Новый Массив;
	
	ТипСтрока = Новый ОписаниеТипов("Строка");
	Для Каждого КлючЗначение Из ЧастиАдреса Цикл
		Часть = КлючЗначение.Значение;
		Имя   = КлючЗначение.Ключ;
		Добавлять.Добавить( Новый РеквизитФормы(ПрефиксИмениЧастиАдреса + Имя, ТипСтрока, , Часть.Заголовок));
	КонецЦикла;
	ИзменитьРеквизиты(Добавлять);
	
	Для Каждого КлючЗначение Из ЧастиАдреса Цикл
		Часть = КлючЗначение.Значение;
		Имя   = КлючЗначение.Ключ;
		
		Элемент = Элементы.Добавить(ПрефиксИмениЧастиАдреса + Имя, Тип("ПолеФормы"));
		Элемент.ПутьКДанным = Элемент.Имя;
		Элемент.Вид         = ВидПоляФормы.ПолеВвода;
		Элемент.КнопкаВыбора = Истина;
		
		Часть.Свойство("Подсказка", Элемент.Подсказка);
		Если ПустаяСтрока(Элемент.Подсказка) Тогда
			Элемент.Подсказка = Часть.Заголовок;
		КонецЕсли;
			
		Элемент.УстановитьДействие("ПриИзменении",         "Подключаемый_ПолеПриИзменении");
		Элемент.УстановитьДействие("НачалоВыбора",         "Подключаемый_ПолеНачалоВыбора");
		Элемент.УстановитьДействие("Очистка",              "Подключаемый_Очистка");
		Элемент.УстановитьДействие("ОбработкаВыбора",      "Подключаемый_ПолеОбработкаВыбора");
		Элемент.УстановитьДействие("Автоподбор",           "Подключаемый_ПолеАвтоподбор");
		Элемент.УстановитьДействие("ОкончаниеВводаТекста", "Подключаемый_ПолеОкончаниеВводаТекста");
		
		ЭтаФорма[Элемент.Имя] = Часть.Значение;
	КонецЦикла;
	
КонецПроцедуры

// -------------------------------------------------------------------------------------------------

&НаКлиенте 
Функция ИмяЧастиАдресаЭлемента(Элемент)
	Возврат Сред(Элемент.Имя, 1 + СтрДлина(ПрефиксИмениЧастиАдреса));
КонецФункции

&НаКлиенте 
Функция ЧастьАдресаЭлемента(Элемент)
	Возврат ЧастиАдреса[ИмяЧастиАдресаЭлемента(Элемент)];
КонецФункции

&НаКлиенте
Функция УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение)
	ЧастьАдреса = ЧастьАдресаЭлемента(Элемент);
	
	Если ТипЗнч(ВыбранноеЗначение)=Тип("Структура") Тогда
		СтруктураЧасти = ?(ВыбранноеЗначение.Свойство("Значение"), ВыбранноеЗначение.Значение, ВыбранноеЗначение);
		ЧастьАдреса.КодКлассификатора = СтруктураЧасти.Код;
		ЧастьАдреса.Значение          = СтруктураЧасти.ПолноеНаименование;
		ЧастьАдреса.Наименование      = СтруктураЧасти.Наименование;
		ЧастьАдреса.Сокращение        = СтруктураЧасти.Сокращение;
	Иначе
		ЧастьАдреса.КодКлассификатора = Неопределено;
		ЧастьАдреса.Значение          = СокрЛП(ВыбранноеЗначение);
		
		Части = КонтактнаяИнформацияКлиентСервер.НаименованиеСокращение(ЧастьАдреса.Значение);
		ЧастьАдреса.Наименование      = Части.Наименование;
		ЧастьАдреса.Сокращение        = Части.Сокращение;
	КонецЕсли;
	
	// Ставим в форму, автоматически сгенерированные имена элементов и реквизитов совпадают
	ЭтаФорма[Элемент.Имя] = ЧастьАдреса.Значение;
	
	Возврат ЧастьАдреса.Значение;
КонецФункции

// -------------------------------------------------------------------------------------------------

&НаКлиенте
Процедура Подключаемый_ПолеПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("СкрыватьНеактуальныеАдреса", СкрыватьНеактуальныеАдреса);
	УправлениеКонтактнойИнформациейКлиент.НачалоВыбораЭлементаАдреса(
		Элемент, ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Очистка(Элемент, СтандартнаяОбработка)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Перем МожноЗагружатьРегион;
	
	Если ТипЗнч(ВыбранноеЗначение)=Тип("Структура") Тогда
		
		РегионНеЗагружен = (ВыбранноеЗначение.Свойство("МожноЗагружатьРегион") И ВыбранноеЗначение.МожноЗагружатьРегион)
		               Или (ВыбранноеЗначение.Свойство("СтруктураАдреса") И ВыбранноеЗначение.СтруктураАдреса.МожноЗагружатьРегион);
		
		Если МожноЗагружатьКлассификатор И РегионНеЗагружен Тогда
			// Предлагаем загрузить классификатор
			УправлениеКонтактнойИнформациейКлиент.ПредложениеЗагрузкиКлассификатора(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Данные для ""%1"" не загружены.'"), ВыбранноеЗначение.Представление));
		КонецЕсли;
		
		ВыбранноеЗначение = УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение);
		Модифицированность = Истина;
	ИначеЕсли ТипЗнч(ВыбранноеЗначение)=Тип("Строка") Тогда
		УстановитьЗначениеЧастиАдреса(Элемент, ВыбранноеЗначение);
		Модифицированность = Истина;
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ЭтоПлатформа83 Тогда
		ДанныеВыбора = Новый СписокЗначений;
		
		Если Ожидание=0 Тогда
			// Формирование списка быстрого выбора, стандартную обработку не надо трогать
			Возврат;
		КонецЕсли;

		Если СтрДлина(Текст) < 3 Тогда 
			// Нет вариантов, список пуст, стандартную обработку не надо трогать
			Возврат;
		КонецЕсли;
		
		ДанныеВыбора = СписокАвтоПодбораЭлементаАдреса(Текст, ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, Истина);
		
		// Стандартную обработку отключаем, только если есть наши варианты
		СтандартнаяОбработка = ДанныеВыбора.Количество() = 0;
		Возврат;
	КонецЕсли;
	
	// Совместимость
	
#Если Не ВебКлиент Тогда
	Если Ожидание=0 Тогда
		// Формирование списка быстрого выбора
		Если ПустаяСтрока(Текст) Тогда
			ДанныеВыбора = Новый СписокЗначений;
		КонецЕсли;
		Возврат;
	КонецЕсли;
#КонецЕсли

	СтандартнаяОбработка = Ложь;
	Если СтрДлина(Текст)<3 Тогда 
		Возврат;
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ПредупреждатьОНеактуальных = Ложь;
#Иначе
	ПредупреждатьОНеактуальных = Истина;
#КонецЕсли
	
	ДанныеВыбора = СписокАвтоПодбораЭлементаАдреса(Текст, ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, ПредупреждатьОНеактуальных);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПолеОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	Модифицированность = Истина;
	
	СписокВариантов = СписокВариантовЭлементаАдресаПоТексту(Текст, ИмяЧастиАдресаЭлемента(Элемент), ЧастиАдреса, 50);
	
	Если СписокВариантов<>Неопределено И СписокВариантов.Количество()=1 Тогда
		СтандартнаяОбработка = Ложь;
		Текст = УстановитьЗначениеЧастиАдреса(Элемент, СписокВариантов[0].Значение);
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Текст);
	Иначе
		УстановитьЗначениеЧастиАдреса(Элемент, Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса)
	Возврат КонтактнаяИнформацияСлужебный.КодНаселенногоПунктаПоЧастямАдреса(ЧастиАдреса);
КонецФункции

&НаСервереБезКонтекста
Функция СписокАвтоПодбораЭлементаАдреса(Текст, КодЧастиАдреса, Знач ЧастиАдреса, ПредупреждатьОНеактуальных)
	Возврат КонтактнаяИнформацияСлужебный.СписокАвтоПодбораЭлементаАдреса(
		Текст, КодЧастиАдреса, ЧастиАдреса, ПредупреждатьОНеактуальных);
КонецФункции

&НаСервереБезКонтекста
Функция СписокВариантовЭлементаАдресаПоТексту(Текст, КодЧастиАдреса, ЧастиАдреса, ВыбиратьСтрок)
	Возврат КонтактнаяИнформацияСлужебный.СписокВариантовЭлементаАдресаПоТексту(
		Текст, КодЧастиАдреса, ЧастиАдреса, ВыбиратьСтрок);
КонецФункции
