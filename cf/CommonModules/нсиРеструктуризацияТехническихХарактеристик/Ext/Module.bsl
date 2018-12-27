﻿
#Область ПрограммныйИнтерфейс

// Функция формирует текст вопроса при необходимости реструктуризации типов характеритик.
//
Функция СформироватьТекстВопросаРеструктуризацииДанных(КоличествоСвязанныхКлассов, КоличествоСвязанныхЭлементов) Экспорт
	
	ТекстВопроса = НСтр("ru = 'Изменен тип значения характристики. С ней связаны:%1%2. 
						|Продолжить запись с реструктуризацией связанных данных?'");	
	
	Если КоличествоСвязанныхКлассов > 0 тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", " классов - " + КоличествоСвязанныхКлассов);  		
	Иначе 	
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", "");
	КонецЕсли;
	
	Если КоличествоСвязанныхЭлементов > 0 тогда
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%2", 
			?(КоличествоСвязанныхКлассов > 0, ", ", " ") + "элементов справочников - " + КоличествоСвязанныхЭлементов);	
	Иначе 	
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%2", "");	
	КонецЕсли;	
	
	Возврат ТекстВопроса
	
КонецФункции	

// Процедура проверяет наличие связанных с ПВХ нсиНаименованиеХарактеристик[МТР|Услуг|УниверсальногоСправочника] 
// классов и элементов справочников.
//
Процедура ПроверкаСвязанныхДанных(Ссылка, ИмяСправочника, ИмяПВХ, КоличествоСвязанныхКлассов, КоличествоСвязанныхЭлементов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ нсиХарактеристики.Класс) КАК КоличествоСвязанныхКлассов
		|ИЗ
		|	ПланВидовХарактеристик."+ИмяПВХ+" КАК нсиХарактеристики
		|ГДЕ
		|	нсиХарактеристики.НаименованиеПоКлассификатору = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ТехническиеХарактеристики.Ссылка) КАК КоличествоСвязанныхЭлементов
		|ИЗ
		|	Справочник."+ИмяСправочника+".ТехническиеХарактеристики КАК ТехническиеХарактеристики
		|ГДЕ
		|	ТехническиеХарактеристики.НаименованиеХарактеристики = &Ссылка
		|   	ИЛИ ТехническиеХарактеристики.Характеристика.НаименованиеПоКлассификатору = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если Не РезультатЗапроса[0].Пустой() тогда
		Выборка = РезультатЗапроса[0].Выбрать();
		Выборка.Следующий();
		КоличествоСвязанныхКлассов = Выборка.КоличествоСвязанныхКлассов
	КонецЕсли;
	
	Если Не РезультатЗапроса[1].Пустой() тогда
		Выборка = РезультатЗапроса[1].Выбрать();
		Выборка.Следующий();
		КоличествоСвязанныхЭлементов = Выборка.КоличествоСвязанныхЭлементов
	КонецЕсли;
	
КонецПроцедуры	

// Процедура выполняет изменение типов значений элементов ПВХ ИмяПВХ 
// и приведение значений технических характеристик элементов справочников ИмяСправочника к типу ТипЗначения.
//
Процедура РеструктуризацияСвязанныхДанных(Ссылка, ИмяСправочника, ИмяПВХ, ТипЗначения, Отказ = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	нсиХарактеристики.Ссылка КАК Характеристика
		|ИЗ
		|	ПланВидовХарактеристик."+ИмяПВХ+" КАК нсиХарактеристики
		|ГДЕ
		|	нсиХарактеристики.НаименованиеПоКлассификатору = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТехническиеХарактеристики.Ссылка КАК Объект
		|ИЗ
		|	Справочник."+ИмяСправочника+".ТехническиеХарактеристики КАК ТехническиеХарактеристики
		|ГДЕ
		|	ТехническиеХарактеристики.НаименованиеХарактеристики = &Ссылка
		|   	ИЛИ ТехническиеХарактеристики.Характеристика.НаименованиеПоКлассификатору = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	// Реструктуризация ПВХ нсиХарактеристикиМТР.
	Если Не РезультатЗапроса[0].Пустой() тогда
		Выборка = РезультатЗапроса[0].Выбрать();
		Пока Выборка.Следующий() цикл
			Если Отказ тогда
				Прервать;
			КонецЕсли;	
			ИзменитьТипЗначенияХарактеристики(Выборка.Характеристика, ТипЗначения, Отказ);		
		КонецЦикла;
	КонецЕсли;
	
	// Реструктуризация ТЧ ТехническиеХарактеристики справочника нсиМТР.
	Если Не РезультатЗапроса[1].Пустой() тогда
		Выборка = РезультатЗапроса[1].Выбрать();
		Пока Выборка.Следующий() цикл
			Если Отказ тогда
				Прервать;
			КонецЕсли;	
			ПривестиЗначенияХарактеристикКНовомуТипу(Выборка.Объект, Ссылка, ТипЗначения, Отказ);	
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИзменитьТипЗначенияХарактеристики(Характеристика, ТипЗначения, Отказ)
	
	ХарактеристикаОбъект = Характеристика.ПолучитьОбъект();
	ХарактеристикаОбъект.ТипЗначения = ТипЗначения;
	Попытка
		ХарактеристикаОбъект.Записать();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось изменить тип значения характеристики %1, причина: %2.'"),
			Строка(Характеристика),	СтандартныеПодсистемыКлиентСервер.ИсходнаяПричинаОшибки(ИнформацияОбОшибке)),,,, Отказ);
	КонецПопытки;	
	
КонецПроцедуры

Процедура ПривестиЗначенияХарактеристикКНовомуТипу(СсылкаНаЭлемент, НаименованиеХарактеристики, НовыйТип, Отказ)
	
	ЕстьИзменения = Ложь;
	
	ЭлементОбъект = СсылкаНаЭлемент.ПолучитьОбъект();
	Для Каждого СтрокаТехническиеХарактеристики Из ЭлементОбъект.ТехническиеХарактеристики Цикл
		НаименованиеПоКлассификатору = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(СтрокаТехническиеХарактеристики.Характеристика, "НаименованиеПоКлассификатору");
		
		ЗначениеДоИзменения = СтрокаТехническиеХарактеристики.Значение;
		
		Если НаименованиеХарактеристики = НаименованиеПоКлассификатору тогда
			СтрокаТехническиеХарактеристики.Значение = НовыйТип.ПривестиЗначение(СтрокаТехническиеХарактеристики.Значение);
			
			Если Не ЗначениеДоИзменения = СтрокаТехническиеХарактеристики.Значение тогда
				ЕстьИзменения = Истина;	
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	
	Если ЕстьИзменения тогда
		Попытка
			ЭлементОбъект.Записать();
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось привести значения характеристик в %1, причина: %2.'"),
			Строка(СсылкаНаЭлемент), СтандартныеПодсистемыКлиентСервер.ИсходнаяПричинаОшибки(ИнформацияОбОшибке)), СсылкаНаЭлемент,,, Отказ);
		КонецПопытки;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти