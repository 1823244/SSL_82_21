﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Банки".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Выводит оповещение о необходимости обновления классификатора банков.
//
Процедура РаботаСБанкамиВывестиОповещениеОНеактуальности() Экспорт
	РаботаСБанкамиКлиент.ОповеститьКлассификаторУстарел();
КонецПроцедуры
