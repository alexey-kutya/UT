﻿
#Область ОбработчикиКоманд

&НаКлиенте
Процедура ПроверитьРаботу(Команда)
	
	ПроверитьРаботуСервер();
	
КонецПроцедуры

// Процедура - выполняет код алгоритма для проверки.
//
Процедура ПроверитьРаботуСервер()
		
	Попытка
		Выполнить(Объект.КодАлгоритма);
	Исключение
		Ошибка = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не корректно работает алгоритм: "+ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
