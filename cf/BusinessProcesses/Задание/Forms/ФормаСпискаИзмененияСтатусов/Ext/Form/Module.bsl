﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.Предмет) Тогда 
		ЭтаФорма.ТолькоПросмотр = Истина;
		
		Список.Отбор.Элементы.Очистить();
		ГруппаОтбора = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных")); 
		ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаОтбора.Использование = Истина;
		
		ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")); 
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Предмет"); 
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно; 
		ЭлементОтбора.Использование = Истина; 
		ЭлементОтбора.ПравоеЗначение = Параметры.Предмет;

	КонецЕсли;
	
КонецПроцедуры
