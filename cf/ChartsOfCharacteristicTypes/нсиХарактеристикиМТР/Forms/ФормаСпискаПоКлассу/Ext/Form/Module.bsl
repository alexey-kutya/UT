﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	нсиРаботаСФормами.ОтборВСпискеПоПараметру(ЭтаФорма.Список.Отбор.Элементы, Параметры, "Класс", "Класс");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	ОткрытьФорму("ПланВидовХарактеристик.нсиХарактеристикиМТР.ФормаОбъекта",
		Новый Структура("ЗначенияЗаполнения", Новый Структура("Класс", Параметры.Класс))) 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ЗначенияХарактеристик, "Владелец", Элементы.Список.ТекущаяСтрока);	
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