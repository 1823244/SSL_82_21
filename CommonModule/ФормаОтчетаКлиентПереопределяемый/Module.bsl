﻿////////////////////////////////////////////////////////////////////////////////
// Варианты отчетов - Форма отчета (клиент, переопределяемый)
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик расшифровки табличного документа формы отчета.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Элемент  (ПолеФормы)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение поля формы для поля табличного документа" в справке.
//
Процедура ОбработкаРасшифровки(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик дополнительной расшифровки (меню табличного документа формы отчета).
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма)
//   Элемент  (ПолеФормы)
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. события для "Расширение поля формы для поля табличного документа" в справке.
//
Процедура ОбработкаДополнительнойРасшифровки(ЭтаФорма, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Обработчик команд, добавленных динамически.
//
// Параметры:
//   ЭтаФорма  (УправляемаяФорма) Форма отчета.
//   Команда   (КомандаФормы)     Команда, которая была вызвана.
//   Результат (Булево)           Истина, если вызов команды обработан.
//
Процедура ОбработчикКоманды(ЭтаФорма, Команда, Результат) Экспорт
	
КонецПроцедуры

// Обработчик результата выбора подчиненной формы.
//
// Параметры:
//   ЭтаФорма          (УправляемаяФорма) Форма отчета.
//   ВыбранноеЗначение (*)                Результат выбора в подчиненной форме.
//   ИсточникВыбора    (УправляемаяФорма) Форма, где осуществлен выбор. 
//   Результат         (Булево)           Истина, если результат выбора обработан.
//
Процедура ОбработкаВыбора(ЭтаФорма,ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт
	
КонецПроцедуры

// Обработчик широковещательного оповещения формы отчета.
//
// Параметры:
//   ЭтаФорма (УправляемаяФорма) Форма отчета.
//   Остальные параметры передаются из параметров обработчика "как есть",
//       см. "УправляемаяФорма.ОбработкаОповещения" в синтакс-помощнике.
//
Процедура ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник) Экспорт
	
КонецПроцедуры

