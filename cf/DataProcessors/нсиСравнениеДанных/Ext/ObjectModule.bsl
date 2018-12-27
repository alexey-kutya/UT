﻿#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СРАВНЕНИЕ ДАННЫХ (справочников)

// Процедура - создает СКД для справочника и заполняет, инициализирует компановщик.
//
Процедура ЗаполнениеКомпоновщикаНастроек(ИмяТаблицыСправочника, АдресКомпоновки, КомпоновщикНастроек,
	УникальныйИдентификаторФормы = Неопределено) Экспорт 
	
	Если ТипЗнч(ИмяТаблицыСправочника) = Тип("Строка") Тогда 
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ Ссылка ИЗ Справочник."+ИмяТаблицыСправочника;
	Иначе
		пМетаданные = нсиУниверсальноеХранилище.ПолучитьМетаданные(ИмяТаблицыСправочника);
		ТекстЗапроса = нсиУниверсальноеХранилищеФормыСервер.ПолучитьТекстЗапроса(пМетаданные);
	КонецЕсли;
	
	СхемаКомпоновкиДанных 	= Новый СхемаКомпоновкиДанных;
	
	// новый источник данных
	ИсточникиДанных 	= СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникиДанных.Имя 				= "ИсточникиДанных1";
	ИсточникиДанных.ТипИсточникаДанных 	= "Local";
	
	// новый запрос по источнику
	НаборДанныхЗапрос 	= СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанныхЗапрос.ИсточникДанных 	= "ИсточникиДанных1";
	НаборДанныхЗапрос.Имя 				= "Запрос";
	НаборДанныхЗапрос.Запрос 			= ТекстЗапроса;
	
	АдресКомпоновки = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификаторФормы);	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресКомпоновки));
	
КонецПроцедуры	

// Функция - возвращает массив ссылок на похожие элементы поиска по справочнику.
//
Функция НайтиДанные(ИмяТаблицыСправочника, КомпоновщикНастроек, ПараметрыПоиска, МаксимальноеКоличество = Неопределено) Экспорт 
	
	СтруктуруПоиска = СоздатьСтруктуруПоискаДанных(ИмяТаблицыСправочника, КомпоновщикНастроек, ПараметрыПоиска);
		
	ЗаполнитьКомпоновщикНастроек_Первичный(СтруктуруПоиска);
	
	ЗаполнитьМассивСтрок(СтруктуруПоиска);
	
	ЗаполнитьКомпоновщикНастроек_Конечный(СтруктуруПоиска);
	
	ПолучитьРезультатСравнения(СтруктуруПоиска);
	
	Возврат СтруктуруПоиска.МассивСсылок;
	
КонецФункции	

Функция СоздатьСтруктуруПоискаДанных(ИмяТаблицыСправочника, КомпоновщикНастроек, ПараметрыПоиска, МаксимальноеКоличество = Неопределено)
	
	СтруктуруПоискаДанных = Новый Структура;
	СтруктуруПоискаДанных.Вставить("ИмяТаблицыСправочника", ИмяТаблицыСправочника);
	СтруктуруПоискаДанных.Вставить("КомпоновщикНастроек", 	КомпоновщикНастроек);
	СтруктуруПоискаДанных.Вставить("ПараметрыПоиска", 		ПараметрыПоиска.Скопировать());
	
	СтруктуруПоискаДанных.ПараметрыПоиска.Колонки.Добавить("Значение");      
	Для Каждого СтрокаТЧ Из СтруктуруПоискаДанных.ПараметрыПоиска Цикл 
			
		Если ТипЗнч(СтруктуруПоискаДанных.КомпоновщикНастроек) = Тип("НастройкиКомпоновкиДанных") Тогда 
			ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению(
				СтрокаТЧ.Поле, 
				СтруктуруПоискаДанных.КомпоновщикНастроек.Отбор.Элементы
			);
			Если ЭлементОтбора <> Неопределено Тогда 
				СтрокаТЧ.Значение = ЭлементОтбора.ПравоеЗначение;
			КонецЕсли;
		Иначе 
			ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению(
				СтрокаТЧ.Поле, 
				СтруктуруПоискаДанных.КомпоновщикНастроек.Настройки.Отбор.Элементы
			);
			Если ЭлементОтбора <> Неопределено Тогда 
				СтрокаТЧ.Значение = ЭлементОтбора.ПравоеЗначение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
		
	СтруктуруПоискаДанных.Вставить("СхемаКомпоновкиДанных", 		Новый СхемаКомпоновкиДанных);
	СтруктуруПоискаДанных.Вставить("КомпоновщикНастроек_Первичный", Новый КомпоновщикНастроекКомпоновкиДанных);
	СтруктуруПоискаДанных.Вставить("КомпоновщикНастроек_Конечный", 	Новый КомпоновщикНастроекКомпоновкиДанных);

	
	СхемаКомпоновкиДанных = СтруктуруПоискаДанных.СхемаКомпоновкиДанных;
	
	ТекстЗапросаПервые = "";
	Если ЗначениеЗаполнено(МаксимальноеКоличество) Тогда 
		ТекстЗапросаПервые = "ПЕРВЫЕ "+Формат(МаксимальноеКоличество,"ЧГ = 0");
	КонецЕсли;
	
	Если  ТипЗнч(ИмяТаблицыСправочника) = Тип("Строка") Тогда 
		ТекстЗапроса = 
		"ВЫБРАТЬ "+ТекстЗапросаПервые+" РАЗРЕШЕННЫЕ Ссылка ИЗ Справочник."+СтруктуруПоискаДанных.ИмяТаблицыСправочника;
	Иначе
		пМетаданные = нсиУниверсальноеХранилище.ПолучитьМетаданные(ИмяТаблицыСправочника);
		ТекстЗапроса = СтрЗаменить(нсиУниверсальноеХранилищеФормыСервер.ПолучитьТекстЗапроса(пМетаданные),"ВЫБРАТЬ", "ВЫБРАТЬ "+ТекстЗапросаПервые);
		
	КонецЕсли;
	
	// новый источник данных
	ИсточникиДанных 	= СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникиДанных.Имя 				= "ИсточникиДанных1";
	ИсточникиДанных.ТипИсточникаДанных 	= "Local";
	
	// новый запрос по источнику
	НаборДанныхЗапрос 	= СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанныхЗапрос.ИсточникДанных 	= "ИсточникиДанных1";
	НаборДанныхЗапрос.Имя 				= "Запрос";
	НаборДанныхЗапрос.Запрос 			= ТекстЗапроса;
	
	СтруктуруПоискаДанных.КомпоновщикНастроек_Первичный.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	СтруктуруПоискаДанных.КомпоновщикНастроек_Конечный.Инициализировать(
		Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	СтруктуруПоискаДанных.Вставить("МассивыСтрок", 					Новый Соответствие);	
	СтруктуруПоискаДанных.Вставить("МассивСсылок", 					Неопределено);	
	
	Возврат СтруктуруПоискаДанных;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// ПОЛУЧЕНИЕ "ПРЕДВАРИТЕЛЬНЫХ" ДАННЫХ

Процедура ЗаполнитьКомпоновщикНастроек_Первичный(СтруктуруПоискаДанных)
	
	КомпоновщикНастроек = СтруктуруПоискаДанных.КомпоновщикНастроек_Первичный;	
	
	Если ТипЗнч(СтруктуруПоискаДанных.КомпоновщикНастроек) = Тип("НастройкиКомпоновкиДанных") Тогда 
		ЗаполнитьОтборСКД_Первичный(СтруктуруПоискаДанных, 
			СтруктуруПоискаДанных.КомпоновщикНастроек.Отбор.Элементы);
	Иначе 
		ЗаполнитьОтборСКД_Первичный(СтруктуруПоискаДанных, 
			СтруктуруПоискаДанных.КомпоновщикНастроек.Настройки.Отбор.Элементы);
	КонецЕсли;	
	
КонецПроцедуры	

Процедура ЗаполнитьОтборСКД_Первичный(СтруктуруПоискаДанных, ПоляОтбора)
	
	КомпоновщикНастроек = СтруктуруПоискаДанных.КомпоновщикНастроек_Первичный;	
	
		// коллекция отбора
	Если ТипЗнч(ПоляОтбора) = Тип("КоллекцияЭлементовОтбораКомпоновкиДанных") Тогда 
		Для Каждого ЭлементОтбора Из ПоляОтбора Цикл 
			ЗаполнитьОтборСКД_Первичный(СтруктуруПоискаДанных, ЭлементОтбора);
		КонецЦикла;
		
		// группа "И" отбора	
	ИначеЕсли ТипЗнч(ПоляОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		Если ПоляОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда 
			Для Каждого ЭлементОтбора Из ПоляОтбора.Элементы Цикл 
				ЗаполнитьОтборСКД_Первичный(СтруктуруПоискаДанных, ЭлементОтбора);
			КонецЦикла;
		КонецЕсли;
		
		// элемент отбора
	ИначеЕсли ТипЗнч(ПоляОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Если СтруктуруПоискаДанных.ПараметрыПоиска.Найти(ПоляОтбора.ЛевоеЗначение,"Поле") = Неопределено Тогда 
			ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(ЭлементОтбора, ПоляОтбора);
		КонецЕсли;
		
	КонецЕсли;	
		
КонецПроцедуры	

Процедура ЗаполнитьМассивСтрок(СтруктуруПоискаДанных)
	
	// инициализация переменных
	
	КомпоновщикМакета   		= Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных 	= Новый ПроцессорКомпоновкиДанных;
	ПроцессорВывода             = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	КомпоновщикНастроек 		= Новый КомпоновщикНастроекКомпоновкиДанных;	
	ТаблицаРезультата   		= Новый ТаблицаЗначений;    
	
	// получение СКД для поиска, заполнение настроек в компановщике
	
	АдресСКД = СтруктуруПоискаДанных.СхемаКомпоновкиДанных;  	
	
	
	пМетаданные = Неопределено;
	Если ТипЗнч(СтруктуруПоискаДанных.ИмяТаблицыСправочника) = Тип("СправочникСсылка.нсиВидыСправочников") Тогда 
		пМетаданные = нсиУниверсальноеХранилище.ПолучитьМетаданные(СтруктуруПоискаДанных.ИмяТаблицыСправочника);
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из СтруктуруПоискаДанных.ПараметрыПоиска Цикл 
	
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
		КомпоновщикНастроек.ЗагрузитьНастройки(СтруктуруПоискаДанных.КомпоновщикНастроек_Первичный.ПолучитьНастройки());
		
		Если ТипЗнч(СтруктуруПоискаДанных.ИмяТаблицыСправочника) = Тип("СправочникСсылка.нсиВидыСправочников") Тогда 
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВидСправочника",СтруктуруПоискаДанных.ИмяТаблицыСправочника);
			Для каждого КлючИЗначение Из пМетаданные.Реквизиты Цикл
				Имя = КлючИЗначение.Ключ;
				пРеквизит = КлючИЗначение.Значение;
				КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Р"+Имя, пРеквизит.Идентификатор);
			КонецЦикла;
		КонецЕсли;
		
		Структура 			= КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		ВыбранноеПоле 		= Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));	
		ПолеГруппировки 	= Структура.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ВыбранноеПоле.Поле 	= СтрокаТЧ.Поле;
		ПолеГруппировки.Поле= СтрокаТЧ.Поле;
		
		// выполнение запроса
		
		МакетКомпоновкиДанных         = КомпоновщикМакета.Выполнить(
			АдресСКД, КомпоновщикНастроек.Настройки,,,
			Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);     
		ПроцессорВывода.УстановитьОбъект(ТаблицаРезультата);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
			
		Результат = СравнитьСтрокиНаСовпадение(
			СтрокаТЧ.Значение, 
			ТаблицаРезультата.ВыгрузитьКолонку(ТаблицаРезультата.Колонки[0]), 
			СтрокаТЧ.ПроцентСовпадения, 
			СтрокаТЧ.МетодСравнения);
			
		СтруктуруПоискаДанных.МассивыСтрок.Вставить(СтрокаТЧ.Поле, Результат);
		
	КонецЦикла;

КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПОЛУЧЕНИЕ "ИТОГОВЫХ" ДАННЫХ

Процедура ЗаполнитьКомпоновщикНастроек_Конечный(СтруктуруПоискаДанных)
	
	КомпоновщикНастроек = СтруктуруПоискаДанных.КомпоновщикНастроек_Конечный;	
	
	Структура 			= КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ВыбранноеПоле 		= Структура.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));	
	ВыбранноеПоле.Поле 	= Новый ПолеКомпоновкиДанных("Ссылка");
	
	Если ТипЗнч(СтруктуруПоискаДанных.КомпоновщикНастроек) = Тип("НастройкиКомпоновкиДанных") Тогда 
		ЗаполнитьОтборСКД_Конечный(СтруктуруПоискаДанных, 
			СтруктуруПоискаДанных.КомпоновщикНастроек.Отбор.Элементы);
	Иначе 
		ЗаполнитьОтборСКД_Конечный(СтруктуруПоискаДанных, 
			СтруктуруПоискаДанных.КомпоновщикНастроек.Настройки.Отбор.Элементы);
	КонецЕсли;	
	
КонецПроцедуры	

Процедура ЗаполнитьОтборСКД_Конечный(СтруктуруПоискаДанных, ПоляОтбора, ГруппаОтбора = Неопределено)
	
	КомпоновщикНастроек = СтруктуруПоискаДанных.КомпоновщикНастроек_Конечный;	
	
		// коллекция отбора
	Если ТипЗнч(ПоляОтбора) = Тип("КоллекцияЭлементовОтбораКомпоновкиДанных") Тогда 
		Для Каждого ЭлементОтбора Из ПоляОтбора Цикл 
			ЗаполнитьОтборСКД_Конечный(СтруктуруПоискаДанных, ЭлементОтбора);
		КонецЦикла;
		
		// группа отбора	
	ИначеЕсли ТипЗнч(ПоляОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
		Если Не ГруппаОтбора = Неопределено Тогда 
			НоваяГруппаОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		Иначе 
			НоваяГруппаОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		КонецЕсли;	
		ЗаполнитьЗначенияСвойств(НоваяГруппаОтбора, ПоляОтбора);
		Для Каждого ЭлементОтбора Из ПоляОтбора.Элементы Цикл 
			ЗаполнитьОтборСКД_Конечный(СтруктуруПоискаДанных, ЭлементОтбора, НоваяГруппаОтбора);
		КонецЦикла;
		
		// элемент отбора
	ИначеЕсли ТипЗнч(ПоляОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Если Не ГруппаОтбора = Неопределено Тогда 
			ЭлементОтбора = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Иначе 
			ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		КонецЕсли;	
		ЗаполнитьЗначенияСвойств(ЭлементОтбора, ПоляОтбора);
		
		// заполнение списка совпадений для неточного сравнения
		Если Не СтруктуруПоискаДанных.ПараметрыПоиска.Найти(ПоляОтбора.ЛевоеЗначение,"Поле") = Неопределено Тогда 
			ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.ВСписке;
			ЭлементОтбора.ПравоеЗначение 	= СтруктуруПоискаДанных.МассивыСтрок.Получить(ЭлементОтбора.ЛевоеЗначение);
		КонецЕсли;
		
	КонецЕсли;	
		
КонецПроцедуры	

Процедура ПолучитьРезультатСравнения(СтруктуруПоискаДанных)
	
	// инициализация переменных
	
	КомпоновщикМакета   		= Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных 	= Новый ПроцессорКомпоновкиДанных;
	ПроцессорВывода             = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	КомпоновщикНастроек 		= Новый КомпоновщикНастроекКомпоновкиДанных;	
	ТаблицаРезультата   		= Новый ТаблицаЗначений;    
	
	// получение СКД для поиска, заполнение настроек в компановщике
	
	АдресСКД = СтруктуруПоискаДанных.СхемаКомпоновкиДанных;  	
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД));
	КомпоновщикНастроек.ЗагрузитьНастройки(СтруктуруПоискаДанных.КомпоновщикНастроек_Конечный.ПолучитьНастройки());
	
	Если ТипЗнч(СтруктуруПоискаДанных.ИмяТаблицыСправочника) = Тип("СправочникСсылка.нсиВидыСправочников") Тогда 
		пМетаданные = нсиУниверсальноеХранилище.ПолучитьМетаданные(СтруктуруПоискаДанных.ИмяТаблицыСправочника);
		КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ВидСправочника",СтруктуруПоискаДанных.ИмяТаблицыСправочника);
		
		Для каждого КлючИЗначение Из пМетаданные.Реквизиты Цикл
			Имя = КлючИЗначение.Ключ;
			пРеквизит = КлючИЗначение.Значение;
			КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Р"+Имя, пРеквизит.Идентификатор);
		КонецЦикла;
		
	КонецЕсли;
	
	// выполнение запроса
	МакетКомпоновкиДанных         = КомпоновщикМакета.Выполнить(
		АдресСКД, КомпоновщикНастроек.Настройки,,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных);     
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультата);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	СтруктуруПоискаДанных.МассивСсылок = ТаблицаРезультата.ВыгрузитьКолонку(ТаблицаРезультата.Колонки[0]);

КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ СРАВНЕНИЯ СТРОК

// Функция - возвращает результат сравнения строки с массивом строк.
//
Функция СравнитьСтрокиНаСовпадение(СтрокаСравнения1, МассивСтрок2, 
	ПроцентСовпадения, МетодСравнения = Неопределено, РезультатВВидеМассива = Истина) Экспорт 
	
	// инициализация данных
	
	ПризнакДляСвязи = Новый УникальныйИдентификатор;
	Если МетодСравнения = Неопределено Тогда 
		МетодСравнения = Константы.нсиМетодСравненияСтроковыхДанных.Получить();
	КонецЕсли;	
	
	// неточное сравнение данных
	
	Если (Не Найти(Врег(СтрокаСоединенияИнформационнойБазы()), "FILE=") = 1)
		И Константы.нсиКоличествоФоновыхЗаданийПриПоиске.Получить() > 1 Тогда 
			ФоновыеЗаданияСравнения = СравнитьСтрокиНаСовпадениеВФоне(
				ПризнакДляСвязи, СтрокаСравнения1, МассивСтрок2, ПроцентСовпадения, МетодСравнения);
			ФоновыеЗадания.ОжидатьЗавершения(ФоновыеЗаданияСравнения);
	Иначе 
			СравнитьСтрокиНаСовпадениеЛинейно(
				ПризнакДляСвязи, СтрокаСравнения1, МассивСтрок2, ПроцентСовпадения, МетодСравнения);
	КонецЕсли;	
	
	// возврат данных
	
	Если РезультатВВидеМассива Тогда 
		// считываем данные, очищаем буфер
		Результат = РегистрыСведений.нсиБуферФоновыхЗаданий.ПрочитатьДанные(ПризнакДляСвязи);
		РегистрыСведений.нсиБуферФоновыхЗаданий.ОчиститьДанные(ПризнакДляСвязи);
		Возврат Результат;
	Иначе 
		// возвращаем ссылку на данные
		Возврат ПризнакДляСвязи;
	КонецЕсли;
	
КонецФункции	

// Функция - разбивает исходный массив строк на "по 100" и запускает фоновое задание.
//
Функция СравнитьСтрокиНаСовпадениеВФоне(ПризнакДляСвязи, СтрокаСравнения1, МассивСтрок2, 
	ПроцентСовпадения, МетодСравнения) Экспорт
	
	// инициализация данных
	
	нсиКоличествоФоновыхЗаданийПриПоиске = ?(Константы.нсиКоличествоФоновыхЗаданийПриПоиске.Получить() = 0, 1,
		Константы.нсиКоличествоФоновыхЗаданийПриПоиске.Получить()); 
	ИндикаторКонцаМассива 	= Цел(МассивСтрок2.Количество()/нсиКоличествоФоновыхЗаданийПриПоиске);
	МассивФоновыхЗаданий 	= Новый Массив;
	МассивСтрок 			= Новый Массив;
	
	// формирование массива строк по заданиям и его вызов
	
	Для Каждого СтрокаСравнения2 Из МассивСтрок2 Цикл 
		
		МассивСтрок.Добавить(СтрокаСравнения2);  		
		
		Если МассивСтрок.Количество() = ИндикаторКонцаМассива Тогда 
			
			Параметры = Новый Массив;
			Параметры.Добавить(ПризнакДляСвязи);
			Параметры.Добавить(СтрокаСравнения1);
			Параметры.Добавить(МассивСтрок);
			Параметры.Добавить(ПроцентСовпадения);  			
			Параметры.Добавить(МетодСравнения);  			
			ФЗ = ФоновыеЗадания.Выполнить("нсиСравнениеДанныхСервер.СравнитьСтрокиНаСовпадение",Параметры,
			, "СравнениеСтрокиНаСовпадениеВФоне");	
			МассивФоновыхЗаданий.Добавить(ФЗ);
			МассивСтрок.Очистить();
			
		КонецЕсли;
		
	КонецЦикла;
	
	// остаток строк заносится в массив и формируется подзадание
	
	Если Не МассивСтрок.Количество() = 0 Тогда
		
		Параметры = Новый Массив;
		Параметры.Добавить(ПризнакДляСвязи);
		Параметры.Добавить(СтрокаСравнения1);
		Параметры.Добавить(МассивСтрок);
		Параметры.Добавить(ПроцентСовпадения);  		
		Параметры.Добавить(МетодСравнения);  		
		ФЗ = ФоновыеЗадания.Выполнить("нсиСравнениеДанныхСервер.СравнитьСтрокиНаСовпадение",Параметры,
		, "СравнениеСтрокиНаСовпадениеВФоне");	
		МассивФоновыхЗаданий.Добавить(ФЗ);
		
	КонецЕсли;  
	
	Возврат МассивФоновыхЗаданий;
	
КонецФункции	

// Процедура - сравнивает строки с определенным процентом соответствия без разбиения.
//
Процедура СравнитьСтрокиНаСовпадениеЛинейно(ПризнакДляСвязи, СтрокаСравнения1, МассивСтрок2, 
	ПроцентСовпадения, МетодСравнения) Экспорт
	
	МетодыСравнения = Перечисления.нсиМетодыСравненияСтроковыхДанных;
	
	// заполнение данных по первой строке "для методов".
	Если МетодСравнения      = МетодыСравнения.МетодДамерауЛевенштейнаПоСимволам
		Или МетодСравнения   = МетодыСравнения.МетодЛевенштейнаПоСимволам Тогда 
		СтруктураСравнения1 = РазбитьСтрокуНаМассивСимволов(НРег(СтрокаСравнения1));
		МатрицаСравнения 	= СоздатьМатрицуСравнения(СтруктураСравнения1.ДлинаСтроки, 
			Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1));
	ИначеЕсли МетодСравнения = МетодыСравнения.МетодДамерауЛевенштейнаПоСловам
		Или МетодСравнения   = МетодыСравнения.МетодЛевенштейнаПоСловам Тогда 
		СтруктураСравнения1 = РазбитьСтрокуНаМассивСлов(НРег(СтрокаСравнения1));
		МатрицаСравнения 	= СоздатьМатрицуСравнения(СтруктураСравнения1.ДлинаСтроки, 
			Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1));
	ИначеЕсли МетодСравнения = МетодыСравнения.МетодNграмм
		Или МетодСравнения   = МетодыСравнения.МетодБиграмм 
		Или МетодСравнения   = МетодыСравнения.МетодТриграмм Тогда 
		
		ДлинаПодстроки = Константы.нсиРазмерNграмм.Получить(); // МетодСравнения = МетодыСравнения.МетодNграмм
		ДлинаПодстроки = ?(Не МетодСравнения = МетодыСравнения.МетодБиграмм,  ДлинаПодстроки, 2);
		ДлинаПодстроки = ?(Не МетодСравнения = МетодыСравнения.МетодТриграмм, ДлинаПодстроки, 3);
		
		СписокПодстрок1 = РазбитьСтрокуНаСписокПодстрок(НРег(СтрокаСравнения1), ДлинаПодстроки);
		
		ТаблицаСравнения = Новый ТаблицаЗначений;
		ТаблицаСравнения.Колонки.Добавить("ПодСтрока");
		ТаблицаСравнения.Колонки.Добавить("Количество"); 
		
	КонецЕсли;	
		
	// обход массива сравнения.	
	ОбрабатываетсяМассив = (ТипЗнч(МассивСтрок2) = Тип("Массив"));
	Для Каждого ЭлементМассива Из МассивСтрок2 Цикл 
		
		СтрокаСравнения2 = ?(ОбрабатываетсяМассив, ЭлементМассива, ЭлементМассива.Данные);
		Если Не ЗначениеЗаполнено(СтрокаСравнения2) Тогда 
			Продолжить;
		ИначеЕсли  СтрокаСравнения1 = СтрокаСравнения2 Тогда // строки одинаковые
			РегистрыСведений.нсиБуферФоновыхЗаданий.ЗаписьДанных(ПризнакДляСвязи, СтрокаСравнения2);  
		Иначе 	
			Если МетодСравнения = МетодыСравнения.МетодДамерауЛевенштейнаПоСловам
					Или МетодСравнения   = МетодыСравнения.МетодЛевенштейнаПоСловам Тогда
					// заполнение данных по второй строке "для методов".
				СтруктураСравнения2 = РазбитьСтрокуНаМассивСлов(СтрокаСравнения2);
				
				// выполнение сравнения.
				ПолученПроцентСовпадения = 0;
				Если МетодСравнения   = МетодыСравнения.МетодДамерауЛевенштейнаПоСловам Тогда 
					Если СтруктураСравнения2.ДлинаСтроки <= 
						Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1) Тогда
						МатрицаСравнения_ = МатрицаСравнения;
						ПолученПроцентСовпадения = СравнитьМетодомДамерауЛевенштейна(
							СтруктураСравнения1, СтруктураСравнения2, МатрицаСравнения_, ПроцентСовпадения);
					КонецЕсли;	
				ИначеЕсли (МетодСравнения   = МетодыСравнения.МетодЛевенштейнаПоСловам) Тогда 
					Если СтруктураСравнения2.ДлинаСтроки <= 
						Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1) Тогда 
						МатрицаСравнения_ = МатрицаСравнения;
						ПолученПроцентСовпадения = СравнитьМетодомЛевенштейна(
							СтруктураСравнения1, СтруктураСравнения2, МатрицаСравнения_, ПроцентСовпадения);
					КонецЕсли;
				КонецЕсли;
				Если ПолученПроцентСовпадения >= ПроцентСовпадения Тогда    				
					РегистрыСведений.нсиБуферФоновыхЗаданий.ЗаписьДанных(ПризнакДляСвязи, СтрокаСравнения2);
				КонецЕсли;	
			Иначе
				МассивСловСтроки2 = ПолучитьМассивСлов(СтрокаСравнения2);
				Для Каждого Слово Из МассивСловСтроки2 Цикл
					// заполнение данных по второй строке "для методов".
					Если МетодСравнения      = МетодыСравнения.МетодДамерауЛевенштейнаПоСимволам
						Или МетодСравнения   = МетодыСравнения.МетодЛевенштейнаПоСимволам Тогда 
						СтруктураСравнения2 = РазбитьСтрокуНаМассивСимволов(Слово);
					ИначеЕсли МетодСравнения = МетодыСравнения.МетодNграмм
						Или МетодСравнения   = МетодыСравнения.МетодБиграмм 
						Или МетодСравнения   = МетодыСравнения.МетодТриграмм Тогда 
						
						Если МетодСравнения      = МетодыСравнения.МетодNграмм Тогда 
							ДлинаПодстроки = Константы.нсиРазмерNграмм.Получить();
						ИначеЕсли МетодСравнения = МетодыСравнения.МетодБиграмм Тогда
							ДлинаПодстроки = 2;	
						ИначеЕсли МетодСравнения = МетодыСравнения.МетодТриграмм Тогда	
							ДлинаПодстроки = 3;	
						КонецЕсли;        				
						СписокПодстрок2 = РазбитьСтрокуНаСписокПодстрок(Слово, ДлинаПодстроки);
						
					КонецЕсли;	 		
					
					// выполнение сравнения.
					ПолученПроцентСовпадения = 0;
					Если МетодСравнения      = МетодыСравнения.МетодДамерауЛевенштейнаПоСимволам Тогда 
						Если СтруктураСравнения2.ДлинаСтроки <= 
							Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1) Тогда
							МатрицаСравнения_ = МатрицаСравнения;
							ПолученПроцентСовпадения = СравнитьМетодомДамерауЛевенштейна(
								СтруктураСравнения1, СтруктураСравнения2, МатрицаСравнения_, ПроцентСовпадения);
						КонецЕсли;	
					ИначеЕсли МетодСравнения = МетодыСравнения.МетодЛевенштейнаПоСимволам Тогда 
						Если СтруктураСравнения2.ДлинаСтроки <= 
							Цел(СтруктураСравнения1.ДлинаСтроки *( 1 + (100 - ПроцентСовпадения) / 100) + 1) Тогда 
							МатрицаСравнения_ = МатрицаСравнения;
							ПолученПроцентСовпадения = СравнитьМетодомЛевенштейна(
								СтруктураСравнения1, СтруктураСравнения2, МатрицаСравнения_, ПроцентСовпадения);
						КонецЕсли;
					ИначеЕсли МетодСравнения = МетодыСравнения.МетодNграмм
						Или МетодСравнения   = МетодыСравнения.МетодБиграмм 
						Или МетодСравнения   = МетодыСравнения.МетодТриграмм Тогда
						ПолученПроцентСовпадения = СравнитьМетодомNGramm(
							СписокПодстрок1, СписокПодстрок2, ТаблицаСравнения);   	
					КонецЕсли;
					Если ПолученПроцентСовпадения >= ПроцентСовпадения Тогда    				
						РегистрыСведений.нсиБуферФоновыхЗаданий.ЗаписьДанных(ПризнакДляСвязи, СтрокаСравнения2);
						Прервать;
					КонецЕсли;	
				КонецЦикла;
			КонецЕсли;		
			
		КонецЕсли;	
		
	КонецЦикла;
	
КонецПроцедуры	

////////////////////////////////////////////////////////////////////////////////
// ПОДГОТОВКА СТРОК ДЛЯ СРАВНЕНИЯ

Функция ПолучитьМассивСлов(СтрокаСравнения)
	СтрокаСравнения = Нрег(СтрокаСравнения);
	Слова = Новый Массив;
	ЙЙ=1;
	Пока ЙЙ<=СтрДлина(СтрокаСравнения) Цикл
		Слово = "";
		Пока ЙЙ<=СтрДлина(СтрокаСравнения) И Найти("йцукенгшщзхъфывапролджэячсмитьбюёqwertyuiopasdfghjklzxcvbnm0123456789",Сред(СтрокаСравнения,ЙЙ,1))=0 Цикл
			ЙЙ=ЙЙ+1
		КонецЦикла;
		Пока ЙЙ<=СтрДлина(СтрокаСравнения) И Найти("йцукенгшщзхъфывапролджэячсмитьбюёqwertyuiopasdfghjklzxcvbnm0123456789",Сред(СтрокаСравнения,ЙЙ,1))>0 Цикл
			Слово = Слово + Сред(СтрокаСравнения,ЙЙ,1);
			ЙЙ=ЙЙ+1
		КонецЦикла;
		Если Не ПустаяСтрока(Слово) Тогда
			Слова.Добавить(Слово);
		КонецЕсли;
	КонецЦикла;
	Возврат Слова;
КонецФункции

Функция РазбитьСтрокуНаМассивСимволов(СтрокаСравнения)
	
	ДлинаСтроки 	= СтрДлина(СтрокаСравнения);
	МатрицаСимволов = Новый Массив();
	
	Для ii = 1 По ДлинаСтроки Цикл
		МатрицаСимволов.Добавить(Сред(СтрокаСравнения, ii, 1));
	КонецЦикла;
	
	СтруктураСтроки = Новый Структура("ДлинаСтроки,Матрица", ДлинаСтроки, МатрицаСимволов);
	
	Возврат СтруктураСтроки;
	
КонецФункции	

Функция РазбитьСтрокуНаМассивСлов(СтрокаСравнения)
	
	СтрокаСравнения1 	= СокрЛП(СтрокаСравнения);
	ДлинаСтроки 		= СтрДлина(СтрокаСравнения1);
	МатрицаСлов			= Новый Массив;
	СтрокаРазделителей 	= " .,!?;()[]{}-=+*\/¶"+Символы.ПС+Символы.Таб;
	
	ИндексСлова = 0;
	ПредыдущийСимволРазделитель = Ложь;
	МатрицаСлов.Добавить();
	Для ii = 1 По ДлинаСтроки Цикл
		ПолученСимвол = Сред(СтрокаСравнения1, ii, 1);
		Если Не Найти(СтрокаРазделителей, ПолученСимвол) = 0 Тогда 
			Если Не ПредыдущийСимволРазделитель Тогда 
				ИндексСлова = ИндексСлова + 1;
				МатрицаСлов.Добавить();
			КонецЕсли;
			ПредыдущийСимволРазделитель = Истина;        
		Иначе 	
			МатрицаСлов[ИндексСлова] = "" + МатрицаСлов[ИндексСлова] + ПолученСимвол;
			ПредыдущийСимволРазделитель = Ложь;
		КонецЕсли;	
	КонецЦикла;
	Если МатрицаСлов[ИндексСлова] = Неопределено Тогда 
		МатрицаСлов.Удалить(ИндексСлова);
	КонецЕсли;	
	
	СтруктураСтроки = Новый Структура("ДлинаСтроки,Матрица", МатрицаСлов.Количество(), МатрицаСлов);
	
	Возврат СтруктураСтроки;
	
КонецФункции	

Функция СоздатьМатрицуСравнения(Длина1, Длина2)
	
	// Для сравнения 2х строк - размер выделяемой памяти не существенен.
	// Для сравнения массива строк с оригиналом - общий статический массив (даже излишний) работает быстрее
	// 		нежели буфер, содержащий только последние строки матрицы.
	
	МатрицаСравнения = Новый Массив(Длина2 + 1, Длина1 + 1);    
	Для ii = 0 По Длина1 Цикл
		МатрицаСравнения[0][ii] = ii;
	КонецЦикла; 
	Для jj = 0 По Длина2 Цикл
		МатрицаСравнения[jj][0] = jj;
	КонецЦикла; 
	
	Возврат МатрицаСравнения;
	
КонецФункции	

// Функция - разбивает исходную строку на список подстрок заданной длины.
//
Функция РазбитьСтрокуНаСписокПодстрок(СтрокаПоиска, ДлинаПодстроки) Экспорт
	
	СписокПодстрок  = Новый СписокЗначений;
	ДлинаСтроки 	= СтрДлина(СтрокаПоиска);
	
	Для Индекс = 1 По ДлинаСтроки - ДлинаПодстроки + 1 Цикл 
		СписокПодстрок.Добавить(Сред(СтрокаПоиска, Индекс, ДлинаПодстроки));
	КонецЦикла;
	
	Возврат СписокПодстрок;
	
КонецФункции	

////////////////////////////////////////////////////////////////////////////////
// МЕТОДЫ СРАВНЕНИЯ
//
// Функция - сравнивает строки методом Левенштейна по матрице сравнения.
// Параметры:
// СтрокаСравнения1        - Структура, содержащая параметры первой строки;
// СтрокаСравнения1        - Структура, содержащая параметры второй строки;
// МатрицаСравнения        - Массив для сравнения двух строк;
// ОграничитьРезультат     - Число, ограничивающие процент совпадения двух строк.
// Возвращаемое значение:
// Число        			  - процент совпадения двух строк.
//
Функция СравнитьМетодомЛевенштейна(СтрокаСравнения1, СтрокаСравнения2, МатрицаСравнения, 
	ОграничитьРезультат = 0) Экспорт

	// инициализация переменных
	ДлинаСтроки1 	= СтрокаСравнения1.ДлинаСтроки;
	ДлинаСтроки2 	= СтрокаСравнения2.ДлинаСтроки;
	ДлинаСтрокиМакс	= Макс(ДлинаСтроки1, ДлинаСтроки2);
	ДельтаДлины 	= Макс(ДлинаСтроки1,ДлинаСтроки2) - Мин(ДлинаСтроки1,ДлинаСтроки2);
	
	// обход матрицы   	
	Для ii = 1 По ДлинаСтроки1 Цикл
		СимволСтроки1_1 = СтрокаСравнения1.Матрица[ii - 1];  	
		Для jj = 1 По ДлинаСтроки2 Цикл 
			СимволСтроки2_1 = СтрокаСравнения2.Матрица[jj - 1];
			
			РасстояниеСимвола1 = ?(СимволСтроки1_1 = СимволСтроки2_1, 0, 1); 
			
			МатрицаСравнения[jj][ii] = Мин(
				МатрицаСравнения[jj    ][ii - 1] + 1,                   
				МатрицаСравнения[jj - 1][ii    ] + 1, 
				МатрицаСравнения[jj - 1][ii - 1] + РасстояниеСимвола1);
				
		КонецЦикла;   	
		
		// основная диагональ "от конца" содержит промежуточные результаты
		Если Не ОграничитьРезультат = 0 Тогда 
			СмещениеРезультата = ?(ii - ДельтаДлины < 1, 1, ii - ДельтаДлины);
			Если ДлинаСтроки1 = ДлинаСтроки2 Тогда 
				Результат = МатрицаСравнения[ii][ii];
			ИначеЕсли ДлинаСтроки1 > ДлинаСтроки2 Тогда 
				Результат = МатрицаСравнения[СмещениеРезультата][ii];
			Иначе  	
				Результат = МатрицаСравнения[ii][СмещениеРезультата];
			КонецЕсли;
			Если Результат > ОграничитьРезультат Тогда 
				Возврат 0;
			КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;  
	
	Результат = МатрицаСравнения[ДлинаСтроки2][ДлинаСтроки1];
	Возврат (ДлинаСтрокиМакс - Результат) * 100 / ДлинаСтрокиМакс;
	
КонецФункции

// Функция - сравнивает строки методом Дамерау-Левенштейна по матрице сравнения.
// Параметры:
// СтрокаСравнения1        - Структура, содержащая параметры первой строки;
// СтрокаСравнения1        - Структура, содержащая параметры второй строки;
// МатрицаСравнения        - Массив для сравнения двух строк;
// ОграничитьРезультат     - Число, ограничивающие процент совпадения двух строк.
// Возвращаемое значение:
// Число        			  - процент совпадения двух строк.
//
Функция СравнитьМетодомДамерауЛевенштейна(СтрокаСравнения1, СтрокаСравнения2, МатрицаСравнения, 
	ОграничитьРезультат = 0) Экспорт


	// инициализация переменных
	ДлинаСтроки1 	= СтрокаСравнения1.ДлинаСтроки;
	ДлинаСтроки2 	= СтрокаСравнения2.ДлинаСтроки;
	ДлинаСтрокиМакс	= Макс(ДлинаСтроки1, ДлинаСтроки2);
	ДельтаДлины 	= Макс(ДлинаСтроки1,ДлинаСтроки2) - Мин(ДлинаСтроки1,ДлинаСтроки2);
		
	// обход матрицы   	
	Для ii = 1 По ДлинаСтроки1 Цикл
		СимволСтроки1_1 	= СтрокаСравнения1.Матрица[ii - 1];  	
		Если ii > 1 Тогда 
			СимволСтроки1_2 = СтрокаСравнения1.Матрица[ii - 2];
		КонецЕсли;
		
		Для jj = 1 По ДлинаСтроки2 Цикл 
			СимволСтроки2_1 	= СтрокаСравнения2.Матрица[jj - 1];
			Если jj > 1 Тогда 
				СимволСтроки2_2 = СтрокаСравнения2.Матрица[jj - 2];
			КонецЕсли;
			
			РасстояниеСимвола1  = ?(СимволСтроки1_1 = СимволСтроки2_1, 0, 1); 
			
			Если (jj > 1 И ii > 1) И (СимволСтроки1_1 = СимволСтроки2_2) И (СимволСтроки1_1 = СимволСтроки2_2) Тогда 
				МатрицаСравнения[jj][ii] = Мин(
					МатрицаСравнения[jj    ][ii - 1] + 1,
					МатрицаСравнения[jj - 1][ii    ] + 1, 
					МатрицаСравнения[jj - 1][ii - 1] + РасстояниеСимвола1, 
					МатрицаСравнения[jj - 2][ii - 2] + РасстояниеСимвола1);
 			Иначе 	
				МатрицаСравнения[jj][ii] = Мин(
					МатрицаСравнения[jj    ][ii - 1] + 1,
					МатрицаСравнения[jj - 1][ii    ] + 1, 
					МатрицаСравнения[jj - 1][ii - 1] + РасстояниеСимвола1); 				
			КонецЕсли;	
				
		КонецЦикла; 
					
		// основная диагональ "от конца" содержит промежуточные результаты
		Если Не ОграничитьРезультат = 0 Тогда 
			СмещениеРезультата = ?(ii - ДельтаДлины < 1, 1, ii - ДельтаДлины);
			Если ДлинаСтроки1 = ДлинаСтроки2 Тогда 
				Результат = МатрицаСравнения[ii][ii];
			ИначеЕсли ДлинаСтроки1 > ДлинаСтроки2 Тогда 
				Результат = МатрицаСравнения[СмещениеРезультата][ii];
			Иначе  	
				Результат = МатрицаСравнения[ii][СмещениеРезультата];
			КонецЕсли;
			Если Результат > ОграничитьРезультат Тогда 
				Возврат 0;
			КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;  
	
	Результат = МатрицаСравнения[ДлинаСтроки2][ДлинаСтроки1];
	Возврат (ДлинаСтрокиМакс - Результат) * 100 / ДлинаСтрокиМакс;
	
КонецФункции

Функция СравнитьМетодомNGramm(СписокПодстрок1, СписокПодстрок2, ТаблицаСравнения)
	
	// формирование промежуточных итогов по подстрокам
	ТаблицаСравнения.Очистить();
	Для Каждого СтрокаСпискаПодстрок Из СписокПодстрок1 Цикл 
		СтрокаТЧ = ТаблицаСравнения.Добавить();
		СтрокаТЧ.ПодСтрока  = СтрокаСпискаПодстрок.Значение;
		СтрокаТЧ.Количество = 1;
	КонецЦикла;	
	Для Каждого СтрокаСпискаПодстрок Из СписокПодстрок2 Цикл 
		СтрокаТЧ = ТаблицаСравнения.Добавить();
		СтрокаТЧ.ПодСтрока  = СтрокаСпискаПодстрок.Значение;
		СтрокаТЧ.Количество = -1;
	КонецЦикла;	
	ТаблицаСравнения.Свернуть("ПодСтрока","Количество");
	
	// вычисление показателей
	КоличествоРазличных = 0;
	Для Каждого СтрокаТЧ Из ТаблицаСравнения Цикл 
		КоличествоРазличных = КоличествоРазличных +
			?(СтрокаТЧ.Количество >0 ,СтрокаТЧ.Количество, -1 * СтрокаТЧ.Количество);  			
	КонецЦикла;	  	
	ОбщееЧислоКомбинаций = (СписокПодстрок1.Количество() + СписокПодстрок2.Количество() + КоличествоРазличных) / 2;
	
	// результат   	
	Если ОбщееЧислоКомбинаций = 0 Тогда
		Возврат 0;
	Иначе 	
		Возврат 100 - КоличествоРазличных / ОбщееЧислоКомбинаций * 100;
	КонецЕсли;
	
КонецФункции

#КонецОбласти


