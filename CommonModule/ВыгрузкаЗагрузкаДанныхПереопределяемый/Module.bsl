﻿///////////////////////////////////////////////////////////////////////////////////////////////////////////
// ВыгрузкаЗагрузкаДанныхПереопределяемый: обработка событий выгрузки и загрузки данных в области.
// 
///////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик, вызываемый перед стандартным формирования словаря замен
// по очередному файлу общих данных.
//
// Параметры
//  СловарьЗамен - таблица значений, колонки:
//    Тип - Тип - Тип значения заменяемой ссылки
//    СоответствиеСсылок - Соответствие - соответствие новой ссылки исходной
//     Ключ - Идентификатор новой ссылки (на которую требуется заменить)
//     Значение - Идентификатор исходной ссылки (требующая замены)
//    СтандартнаяОбработка - Булево, Неопределено - выполнять стандартную замену ссылок
//     Неопределено - замена будет выполняться если СоответствиеСсылок не содержит записей
//  ИмяФайлаОбщихДанных - Строка - имя текущего обрабатываемого файла выгрузки
//   общих данных
//
Процедура ДополнитьСловарьЗаменПоОбщимДанным(Знач СловарьЗамен, Знач ИмяФайлаОбщихДанных) Экспорт
	
КонецПроцедуры

// Заполняет массив типов неразделенных данных. Он используется при обновлении ссылок 
// при загрузке-выгрузке конфигурации
// 
// Параметры:
//  МассивТипов - массив
//
Процедура ТипыОбщихДанных(МассивТипов) Экспорт
	
	
	
КонецПроцедуры

// Заполняет массив типов неразделенных данных, всегда содержащих только предопределенные элементы.
// Он используется при обновлении ссылок при загрузке-выгрузке данных.
// 
// Параметры:
//  МассивТипов - массив
//
Процедура ТипыОбщихПредопределенныхДанных(МассивТипов) Экспорт
	
	
	
КонецПроцедуры

// Заполняет соответствие типов метаданных, используемых в локальном режиме и в модели сервиса.
//
// Параметры:
//  ТаблицаСоответствия - ТаблицаЗначений, колонки:
//    ОбъектВЛокальномРежиме - ОбъектМетаданных, объект метаданных, используемый в локальном режиме,
//    ОбъектВМоделиСервиса - ОбъектМетаданных, объект метаданных, используемый в модели сервиса.
//
Процедура ЗаполнитьСоответствиеОбъектовМетаданныхВЛокальномРежимеИМоделиСервиса(ТаблицаСоответствия) Экспорт
	
КонецПроцедуры

// Вызывается при определении объектов метаданных, не переносящихся между моделями при выгрузке / загрузке данных.
//
// Параметры
//  Объекты - Массив(ОбъектМетаданных).
//
Процедура ЗаполнитьОбъектыМетаданныхИсключаемыеИзВыгрузкиЗагрузки(Объекты) Экспорт
	
КонецПроцедуры

// Обработчик, вызываемый после выгрузки области в файлы.
//
// Параметры
//  КаталогВыгрузки - Строка - имя каталога с файлами выгрузки области. В каталог можно поместить 
//   дополнительные файлы, они будут доступны в некоторых событиях загрузки.
//
Процедура ПослеВыгрузкиОбласти(Знач КаталогВыгрузки) Экспорт
	
КонецПроцедуры

// Обработчик, вызываемый при окончании стандартного формирования словаря замен
// по очередному файлу общих данных.
//
// Параметры
//  СловарьЗамен - таблица значений, колонки:
//    Тип - Тип - Тип значения заменяемой ссылки
//    СоответствиеСсылок - Соответствие - соответствие новой ссылки исходной
//     Ключ - Идентификатор новой ссылки (на которую требуется заменить)
//     Значение - Идентификатор исходной ссылки (требующая замены)
//    СтандартнаяОбработка - Булево, Неопределено - выполнять стандартную замену ссылок
//     Неопределено - замена будет выполняться если СоответствиеСсылок не содержит записей
//  КаталогВыгрузки - Строка - имя каталога с файлами выгрузки области
//
Процедура ПриФормированииСловаряЗаменПоКаталогуВыгрузки(Знач СловарьЗамен, Знач КаталогВыгрузки) Экспорт
	
КонецПроцедуры
