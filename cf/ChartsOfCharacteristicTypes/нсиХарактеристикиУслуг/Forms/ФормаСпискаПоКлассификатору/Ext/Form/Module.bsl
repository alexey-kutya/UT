﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	нсиРаботаСФормами.ОтборВСпискеПоПараметру(ЭтаФорма.Список.Отбор.Элементы, Параметры, 
		"НаименованиеПоКлассификатору", "НаименованиеПоКлассификатору");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ОткрытьФорму("ПланВидовХарактеристик.нсиХарактеристикиУслуг.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", 
			Новый Структура("НаименованиеПоКлассификатору", Параметры.НаименованиеПоКлассификатору))) 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭтаФорма.ЗначенияХарактеристик.Отбор.Элементы, 
		"Владелец", Элементы.Список.ТекущаяСтрока);	
	
	Если ЗначениеЗаполнено(Элементы.Список.ТекущаяСтрока) Тогда 
		Элементы.ЗначенияХарактеристик.Доступность = ДоступенТипЗначенияСвойствОбъектов(Элементы.Список.ТекущаяСтрока);
	Иначе
		Элементы.ЗначенияХарактеристик.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДоступенТипЗначенияСвойствОбъектов(Характеристика)
	Возврат Характеристика.ТипЗначения.СодержитТип(Тип("СправочникСсылка.ЗначенияСвойствОбъектов"));
КонецФункции	

#КонецОбласти