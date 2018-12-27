﻿#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Сравнение данных"

// Процедура - добавление новой строки через перетаскивание.
//
Процедура ПараметрыНеточногоПоискаПеретаскивание(ИмяСправочника, ПараметрыНеточногоПоиска, 
	ПараметрыПеретаскивания) Экспорт 
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("ДоступноеПолеОтбораКомпоновкиДанных") Тогда 
		Поле = ПараметрыПеретаскивания.Значение[0].Поле;
	Иначе 
		Поле = ПараметрыПеретаскивания.Значение[0].ЛевоеЗначение;
	КонецЕсли;	
	
	Если Не ПараметрыНеточногоПоиска.НайтиСтроки(Новый Структура("Поле", Поле) ).Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("По данному полю уже определен неточный поиск.");	
		Возврат;
	КонецЕсли;		
	
	НоваяСтрока 					= ПараметрыНеточногоПоиска.Добавить();
	НоваяСтрока.Поле 				= Поле;
	НоваяСтрока.МетодСравнения 		= нсиСравнениеДанныхСервер.ПолучитьМетодСравненияПоУмолчанию(); 	
	НоваяСтрока.ПроцентСовпадения 	= 99; 	
	
КонецПроцедуры

// Функция - возвращает сформированную настройку поиска.
//
Функция ПолучитьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника, КомпоновщикНастроек, ПараметрыНеточногоПоиска, НастройкаПоискаДанных) Экспорт
	
 	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("ИмяСправочника",	ИмяСправочника);
	ПередаваемыеПараметры.Вставить("НастройкаПоиска",	КомпоновщикНастроек.Настройки);
	ПередаваемыеПараметры.Вставить("ПараметрыПоиска",	ПараметрыНеточногоПоиска);
	Если ЗначениеЗаполнено(НастройкаПоискаДанных) Тогда 
		ПередаваемыеПараметры.Вставить("Ключ", НастройкаПоискаДанных);
	КонецЕсли;		
	
	ОткрытьФорму("Справочник.нсиНастройкиПоискаДанных.Форма.ФормаНастройки", 
		ПередаваемыеПараметры,,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецФункции

// Функция - возвращает выбранную настройку поиска.
//
Функция ВыбратьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника) Экспорт
	
	ОткрытьФорму("Справочник.нсиНастройкиПоискаДанных.ФормаВыбора",
		Новый Структура("ИмяСправочника", ИмяСправочника),,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
	);
	
КонецФункции


#КонецОбласти

