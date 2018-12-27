﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Регламентные задания".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс


// Вызывается при интерактивном начале работы пользователя с областью данных.
// Соответствует событию ПриНачалеРаботыСистемы модулей приложения.
//
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиентаПриЗапуске.ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры
	
// Только для внутреннего использования.
Процедура ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами(Параметры, ДополнительныеПараметры) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияОкнаБлокировкиРаботыСВнешнимиРесурсами", ЭтотОбъект, Параметры);
	Форма = ОткрытьФорму("ОбщаяФорма.БлокировкаРаботыСВнешнимиРесурсами",,,,,, Оповещение);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ПослеОткрытияОкнаБлокировкиРаботыСВнешнимиРесурсами(Результат, Параметры) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

#КонецОбласти