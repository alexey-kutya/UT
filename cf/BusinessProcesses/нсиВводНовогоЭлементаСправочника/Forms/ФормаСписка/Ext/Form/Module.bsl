﻿#Область ОбработчикиСобытийФормы

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
	
	// @Комментарий: Скроем кнопку установки пометки на удаление, если прав недостаточно.
	ИмяБизнесПроцесса = "нсиВводНовогоЭлементаСправочника";
	текКнопкаФормаУстановитьПометкуУдаления = Элементы.Найти("ФормаУстановитьПометкуУдаления");
	Если текКнопкаФормаУстановитьПометкуУдаления <> Неопределено Тогда
		текКнопкаФормаУстановитьПометкуУдаления.Видимость = нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБизнесПроцессов(БизнесПроцессы[ИмяБизнесПроцесса].ПустаяСсылка());
	КонецЕсли;
	текКнопкаСписокКонтекстноеМенюУстановитьПометкуУдаления = Элементы.Найти("СписокКонтекстноеМенюУстановитьПометкуУдаления");
	Если текКнопкаСписокКонтекстноеМенюУстановитьПометкуУдаления <> Неопределено Тогда
		текКнопкаСписокКонтекстноеМенюУстановитьПометкуУдаления.Видимость = нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБизнесПроцессов(БизнесПроцессы[ИмяБизнесПроцесса].ПустаяСсылка());
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура("Предмет", Параметры.Предмет);
	 ОткрытьФорму("БизнесПроцесс.нсиВводНовогоЭлементаСправочника.ФормаОбъекта", 
		 Новый Структура("ЗначенияЗаполнения", ПараметрыФормы));
	
КонецПроцедуры

#КонецОбласти
