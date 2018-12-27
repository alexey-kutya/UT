﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.ВидКлассификатора <> Объект.Класс.Владелец Тогда 
		Объект.ВидКлассификатора = Объект.Класс.Владелец;
	КонецЕсли;
	
	РегистрыСведений.нсиСтатусыОбработкиСправочников.ОпределитьДоступКФорме(
		Объект.Класс, ЭтаФорма.ТолькоПросмотр, Ложь);

	Если ТолькоПросмотр
		И Объект.Класс.ЭтоМакет	тогда
		ТолькоПросмотр = Ложь;		
	КонецЕсли;
	
	Если Параметры.Свойство("БезРедактирования") Тогда
		ТолькоПросмотр = Параметры.БезРедактирования;;		
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Если элемент новый, проверим доступность класса для изменений.
	Если Параметры.Ключ.Пустая() тогда
		ДоступЗапрещен = Ложь;
		РегистрыСведений.нсиСтатусыОбработкиСправочников.ОпределитьДоступКФорме(
			Объект.Класс, ДоступЗапрещен, Ложь);
			
		Если ДоступЗапрещен
			И НЕ Объект.Класс.ЭтоМакет тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Характеристика не может быть создана. Класс не доступен для изменений.'"),, "Класс", "Объект", Отказ);	
		КонецЕсли;		
	КонецЕсли;	
	
	ТекущийОбъект.Наименование 		= Объект.НаименованиеПоКлассификатору.Наименование;	
	ТекущийОбъект.ТипЗначения 		= Объект.НаименованиеПоКлассификатору.ТипЗначения;	
	ТекущийОбъект.СклоненияПредмета = Объект.НаименованиеПоКлассификатору.СклоненияПредмета;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассПриИзменении(Элемент)
	Объект.ВидКлассификатора = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Класс,"Владелец");
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПоКлассификаторуОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Объект.НаименованиеПоКлассификатору);
	ПараметрыОткрытия.Вставить("БезРедактирования", Истина);
	
	ОткрытьФорму("ПланВидовХарактеристик.нсиНаименованияХарактеристикУниверсальногоСправочника.Форма.ФормаЭлемента",ПараметрыОткрытия,ЭтаФорма);	

КонецПроцедуры

#КонецОбласти
