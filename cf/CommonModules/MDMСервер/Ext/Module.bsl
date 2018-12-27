﻿//КОНТАКТНАЯ ИНФОРМАЦИЯ
Процедура ЗаписатьКИУПП(СтруктураКИ, ВидКИ, ВладелецКИ) Экспорт

	МенеджерЗаписи = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Тип = ВидКИ.Тип;
	МенеджерЗаписи.Вид = ВидКИ;
	МенеджерЗаписи.Объект = ВладелецКИ;
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, СтруктураКИ);
	МенеджерЗаписи.Записать();

КонецПроцедуры // ЗаписатьАдресУППНаСервере()

Функция ПолучитьСтруктуруКИУПП() Экспорт 

	НаборЗаписей = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	КолонкиРС = НаборЗаписей.ВыгрузитьКолонки();
	
	СтруктураКИ = Новый Структура;
	Для каждого КолонкаРС Из КолонкиРС.Колонки Цикл
		СтруктураКИ.Вставить(КолонкаРС.Имя);
	КонецЦикла;
	
	Возврат СтруктураКИ;
	
КонецФункции // ПолучитьСтруктуруКИУПП()

//ОБМЕН

// Точка входа для выполнения обмена данными по сценарию обмена регламентным заданием.
//
// Параметры:
//  КодСценарияОбмена - Строка - код элемента справочника "Сценарии обменов данными", для которого будет выполнен обмен
//                               данными.
// 
Процедура ВыполнитьОбменДанными_MDM_УПП() Экспорт
	
	Запрос=Новый Запрос;
	МВТ=Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц=МВТ;
	Запрос.Текст= "ВЫБРАТЬ
	              |	Обмен_МДМ_УПП.Ссылка КАК Узел,
	              |	Обмен_МДМ_УПП.Организация.BaseID КАК BaseID
	              |ПОМЕСТИТЬ ДанныеУзла
	              |ИЗ
	              |	ПланОбмена.Обмен_МДМ_УПП КАК Обмен_МДМ_УПП
	              |ГДЕ
	              |	НЕ Обмен_МДМ_УПП.ЭтотУзел
	              |	И НЕ Обмен_МДМ_УПП.Организация.BaseID = """"";
	Результат=Запрос.Выполнить();
	
	//получим нужные нам строки подключений
	wsСсылка="http://xdto.rusalcohol.local/UT_W_2014/ws/ConnectionParametersWS.1cws?wsdl";
	wsПользователь="webRusalco";
	wsПароль="webRusalco123";
	
	Определение=Новый WSОпределения(wsСсылка,wsПользователь,wsПароль);
	Прокси=Новый WSПрокси(Определение,"http://www.roust.com/ConnectionParametersWS","ConnectionParametersWS","ConnectionParametersWSSoap");
	Прокси.Пользователь="webRusalco";
	Прокси.Пароль="webRusalco123";
	
	МассивБаз=Новый Массив;

	ПараметрыХДТО=СериализаторXDTO.ЗаписатьXDTO(МассивБаз);
	ПолученныеПараметры=Прокси.GetValueTable(ПараметрыХДТО);
	
	ТЗ=СериализаторXDTO.ПрочитатьXDTO(ПолученныеПараметры);

	УзелMDM = ПланыОбмена.Обмен_МДМ_УПП.ЭтотУзел();
	Если Тип(ТЗ)<>Тип("ТаблицаЗначений") ИЛИ Не ЗначениеЗаполнено(ТЗ) Тогда
		ЗаписатьСведенияВЖурналОбмена(УзелMDM,,,,Истина, "Не удалось получить параметры соединения.");
		Возврат;
	КонецЕсли;
	
	//соединяем данные таблиц
	Запрос=Новый Запрос;
	Запрос.МенеджерВременныхТаблиц=МВТ;
	Запрос.Текст="ВЫБРАТЬ
	             |	ДанныеУзла.Узел,
	             |	ДанныеУзла.BaseID
	             |ПОМЕСТИТЬ ТаблицаУзлов
	             |ИЗ
	             |	ДанныеУзла КАК ДанныеУзла
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТЗ.BaseID,
	             |	ТЗ.LocationWSDL,
	             |	ТЗ.User,
	             |	ТЗ.Password
	             |ПОМЕСТИТЬ ТаблицаПодключений
	             |ИЗ
	             |	&ТЗ КАК ТЗ
	             |;
	             |
	             |////////////////////////////////////////////////////////////////////////////////
	             |ВЫБРАТЬ
	             |	ТаблицаУзлов.Узел,
	             |	ТаблицаПодключений.LocationWSDL,
	             |	ТаблицаПодключений.User,
	             |	ТаблицаПодключений.Password
	             |ИЗ
	             |	ТаблицаУзлов КАК ТаблицаУзлов
	             |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПодключений КАК ТаблицаПодключений
	             |		ПО ТаблицаУзлов.BaseID = ТаблицаПодключений.BaseID";
	Запрос.УстановитьПараметр("ТЗ",ТЗ);
	Результат=Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		ЗаписатьСведенияВЖурналОбмена(УзелMDM,,,,Истина, "Не удалось получить узлы обмена.");
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ПараметрыВыгрузки = ВыгрузитьДанные(Выборка.Узел);
		
		Если ПараметрыВыгрузки = Неопределено 
			ИЛИ ПараметрыВыгрузки.ЧислоВыгруженныхОбъектов = 0 Тогда 
			Продолжить;
		КонецЕсли; 
		
		ПараметрыWS = Новый Структура("WSСсылка, WSПользователь, WSПароль");
		ПараметрыWS.WSСсылка = Выборка.LocationWSDL;
		ПараметрыWS.WSПользователь = Выборка.User;
		ПараметрыWS.WSПароль = Выборка.Password; 
		
		ПередатьНаСервере(ПараметрыВыгрузки.СтрокаXML, ПараметрыВыгрузки.ЧислоВыгруженныхОбъектов, Выборка.Узел, ПараметрыWS);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПередатьНаСервере(СтрокаXML, ЧислоВыгруженныхОбъектов, Узел, ПараметрыWS) Экспорт

	Данные = Новый ХранилищеЗначения(СтрокаXML, Новый СжатиеДанных(9));
	
	Попытка
		Определения = Новый WSОпределения(ПараметрыWS.WSСсылка, ПараметрыWS.WSПользователь, ПараметрыWS.WSПароль);
	Исключение
		ЗаписатьСведенияВЖурналОбмена(Узел,,,,Истина, "Ошибка при создании WSОпределения: "+ОписаниеОшибки());
		Возврат;
	КонецПопытки; 
	
	Попытка
		Прокси = Новый WSПрокси(Определения, "http://www.rusalco.com/xtdo", "WebRusAlco", "WebRusAlcoSoap");
		Прокси.Пользователь = ПараметрыWS.WSПользователь;
		Прокси.Пароль = ПараметрыWS.WSПароль;
	Исключение
		ЗаписатьСведенияВЖурналОбмена(Узел,,,,Истина, "Ошибка при создании WSПрокси: "+ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ТекстОшибки = "";
	Попытка
		ЗагруженоОбъектов = Прокси.ПринятьДанные(Данные, ТекстОшибки);
		Если НЕ ПустаяСтрока(ТекстОшибки) Тогда
			ЗаписатьСведенияВЖурналОбмена(Узел,ЧислоВыгруженныхОбъектов,ЗагруженоОбъектов,Данные,Истина, "Ошибка загрузки данных: "+ТекстОшибки);
		Иначе
			Если ЧислоВыгруженныхОбъектов = ЗагруженоОбъектов Тогда
				ПланыОбмена.УдалитьРегистрациюИзменений(Узел);
			КонецЕсли; 
			ЗаписатьСведенияВЖурналОбмена(Узел, ЧислоВыгруженныхОбъектов, ЗагруженоОбъектов, Данные);
		КонецЕсли; 
	Исключение
		ЗаписатьСведенияВЖурналОбмена(Узел,ЧислоВыгруженныхОбъектов,,Данные,Истина, "Ошибка выполнения веб-сервиса: "+ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Функция ВыгрузитьДанные(Узел) Экспорт
	
	ЗаписьПравилОбмена = РегистрыСведений.ПравилаОбмена.СоздатьМенеджерЗаписи();
	ЗаписьПравилОбмена.ПравилаОбмена = "ExchangeXML";
	ЗаписьПравилОбмена.Прочитать();
	
	Если НЕ ЗначениеЗаполнено(ЗаписьПравилОбмена.ПравилоВыгрузки) Тогда
		ЗаписатьСведенияВЖурналОбмена(Узел,,,,Истина, "Не найдено правило обмена ExchangeXML");
		Возврат Неопределено;
	КонецЕсли;
	
	ПравилаОбмена = ЗаписьПравилОбмена.ПравилоВыгрузки.Получить();
	
	// Инициализация
	Обмен = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	Обмен.РежимОбмена = "Выгрузка";
	ИмяФайлаДанных = ПолучитьИмяВременногоФайла("xml");
	Обмен.ИмяФайлаОбмена = ИмяФайлаДанных;
	
	// Загрузка правил
	ИмяФайлаПравилОбмена = ПолучитьИмяВременногоФайла("xml");
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайлаПравилОбмена);
	ЗаписьТекста.Записать(ПравилаОбмена);
	ЗаписьТекста.Закрыть();
	Обмен.ИмяФайлаПравилОбмена = ИмяФайлаПравилОбмена;
	Обмен.ЗагрузитьПравилаОбмена();
	
	// Правила выгрузки данных
	
	// Сначала все отключаем 
	МассивИменПВД=Новый Массив;

	Для Каждого Строка из Обмен.ТаблицаПравилВыгрузки.Строки Цикл
		Строка.Включить = 0;
		Обмен.УстановитьПометкиПодчиненных(Строка, "Включить"); 
		//фыв++
		Подчиненные = Строка.Строки;
		Если Подчиненные.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого ТекСтрока Из Подчиненные Цикл
			МассивИменПВД.Добавить(ТекСтрока["Имя"]);
		КонецЦикла; //--
	КонецЦикла;
	
	Для каждого ИмяПВД Из МассивИменПВД Цикл
		СтрПравил = Обмен.ТаблицаПравилВыгрузки.Строки.Найти(ИмяПВД, "Имя", Истина);
		Если СтрПравил = Неопределено Тогда
			ВызватьИсключение "ПередатьНаСервере(): не удалось найти правило выгрузки "+ИмяПВД+" в правилах обмена.";
		КонецЕсли; 
		СтрПравил.Включить = 1;
		СтрПравил.СсылкаНаУзелОбмена = Узел;
		Обмен.УстановитьПометкиРодителей(СтрПравил, "Включить");
	КонецЦикла;
	
	// Выгрузка
	Обмен.ВыполнитьВыгрузку();	
	ЧтениеТекста = Новый ЧтениеТекста;
	ЧтениеТекста.Открыть(ИмяФайлаДанных, КодировкаТекста.UTF8);
	СтрокаXML = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяФайлаДанных);
	УдалитьФайлы(ИмяФайлаПравилОбмена);
	
	ПараметрыВозврата = Новый Структура("СтрокаXML, ЧислоВыгруженныхОбъектов");
	ПараметрыВозврата.СтрокаXML = СтрокаXML;
	ПараметрыВозврата.ЧислоВыгруженныхОбъектов = Обмен.мСчетчикВыгруженныхОбъектов;
	
	Возврат ПараметрыВозврата;
	
КонецФункции // ВыгрузитьКонтрагента()

Процедура ЗаписатьСведенияВЖурналОбмена(УзелОбмена, ВыгруженоОбъектов = 0, ЗагруженоОбъектов = 0, ПакетДанных = Неопределено, ОшибкаОбмена = Ложь, ОписаниеОшибкиОбмена = "")

	ЖурналОбменаMDM = РегистрыСведений.ЖурналОбменаMDM.СоздатьМенеджерЗаписи();
	ЖурналОбменаMDM.Период = ТекущаяДата();
	ЖурналОбменаMDM.УзелОбмена = УзелОбмена;
	ЖурналОбменаMDM.ВыгруженоОбъектов = ВыгруженоОбъектов;
	ЖурналОбменаMDM.ЗагруженоОбъектов = ЗагруженоОбъектов;
	ЖурналОбменаMDM.ПакетДанных = ПакетДанных;
	ЖурналОбменаMDM.ОшибкаОбмена = ОшибкаОбмена;
	ЖурналОбменаMDM.ОписаниеОшибкиОбмена = ОписаниеОшибкиОбмена;
	ЖурналОбменаMDM.Записать();
	
КонецПроцедуры // ЗаписатьСведенияВЖурналОбмена()

//РЕГИСТРАЦИЯ
Процедура РегистрацияДляВыгрузкиУПП_ПриЗаписи(Источник, Отказ) Экспорт
	
//	ПланыОбмена.Обмен_МДМ_УПП.ВыполнитьРегистрациюДляУПП(Источник.Ссылка);
	//БуферОбмена = РегистрыСведений.БуферОбмена.СоздатьМенеджерЗаписи();
	//БуферОбмена.Объект = Источник.Ссылка;
	//БуферОбмена.Пользователь = Пользователи.ТекущийПользователь();
	//БуферОбмена.Прочитать();
	//Если НЕ БуферОбмена.Выбран() Тогда
	//	БуферОбмена.Объект = Источник.Ссылка;
	//	БуферОбмена.Пользователь = Пользователи.ТекущийПользователь();
	//	БуферОбмена.Записать();
	//КонецЕсли; 

КонецПроцедуры

Процедура РегистрацияКонтактнойИинформацииПриЗаписи(Источник, Отказ, Замещение) Экспорт
	
//	ПланыОбмена.Обмен_МДМ_УПП.ВыполнитьРегистрациюКонтактнойИнформации(Источник);
		
КонецПроцедуры

Процедура ПриЗаписиОбъектовОбменаAXПриЗаписи(Источник, Отказ) Экспорт
	
	ПланыОбмена.Обмен_MDM_AX.ВыполнитьРегистрациюДляAX(Источник.Ссылка);
	
КонецПроцедуры

//УЧАСТНИКИ ОБМЕНА
Процедура ЗаполнитьУчастниковОбмена(Форма) Экспорт 
	
	Ключ = Форма.Параметры.Ключ;
	
	ПараметрыВыбора = Новый Структура;
	Если Форма.Параметры.Свойство("ПараметрыВыбора", ПараметрыВыбора) 
		И ПараметрыВыбора.Количество()
		И НЕ ПараметрыВыбора.Свойство("Родитель") Тогда
		КонтейнерВладельца = Форма.Параметры.ПараметрыВыбора;
	Иначе	
		КонтейнерВладельца = Форма.Объект;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Обмен_МДМ_УПП.Ссылка КАК УзелОбмена,
		|	ЕСТЬNULL(УчастникиОбмена.ОбъектОбмена, &ОбъектОбмена) КАК ОбъектОбмена,
		|	ЕСТЬNULL(УчастникиОбмена.Обмен, ЛОЖЬ) КАК Обмен,
		|	ЕСТЬNULL(УчастникиОбменаВладелец.Обмен, ЛОЖЬ) КАК ОбменВладелец
		|ИЗ
		|	ПланОбмена.Обмен_МДМ_УПП КАК Обмен_МДМ_УПП
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчастникиОбмена КАК УчастникиОбмена
		|		ПО (УчастникиОбмена.УзелОбмена = Обмен_МДМ_УПП.Ссылка)
		|			И (УчастникиОбмена.ОбъектОбмена = &ОбъектОбмена)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УчастникиОбмена КАК УчастникиОбменаВладелец
		|		ПО (&ДобавитьОбменВладельца)
		|			И (УчастникиОбменаВладелец.УзелОбмена = Обмен_МДМ_УПП.Ссылка)
		|			И (УчастникиОбменаВладелец.ОбъектОбмена = &Владелец)
		|ГДЕ
		|	Обмен_МДМ_УПП.ЭтотУзел = ЛОЖЬ
		|	И Обмен_МДМ_УПП.ПометкаУдаления = ЛОЖЬ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Обмен_МДМ_УПП.Организация.Код";
	
	Запрос.УстановитьПараметр("ОбъектОбмена", Ключ);
	Если ТипЗнч(Ключ) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
		Запрос.УстановитьПараметр("Владелец", КонтейнерВладельца.Владелец);
		Запрос.УстановитьПараметр("ДобавитьОбменВладельца", Истина);
	ИначеЕсли ТипЗнч(Ключ) = Тип("СправочникСсылка.СпецификацииНоменклатуры") Тогда
		Запрос.УстановитьПараметр("Владелец", КонтейнерВладельца.Номенклатура);
		Запрос.УстановитьПараметр("ДобавитьОбменВладельца", Истина);
	Иначе
		Запрос.УстановитьПараметр("Владелец", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
		Запрос.УстановитьПараметр("ДобавитьОбменВладельца", Ложь);
	КонецЕсли; 
	Форма.УчастникиОбмена.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры // ЗаполнитьНаборЗаписейНаСервере()

Процедура ЗаписатьУчастниковОбмена(Форма) Экспорт 

	Ключ = Форма.Параметры.Ключ;
	Если НЕ Ключ.Пустая() Тогда
	
		УчастникиОбменаНЗ = РегистрыСведений.УчастникиОбмена.СоздатьНаборЗаписей();
		УчастникиОбменаНЗ.Отбор.ОбъектОбмена.Установить(Ключ);
		Если Форма.УчастникиОбмена.Количество() Тогда
			Если НЕ ЗначениеЗаполнено(Форма.УчастникиОбмена[0].ОбъектОбмена) Тогда
				Для н=0 По Форма.УчастникиОбмена.Количество()-1 Цикл
					Форма.УчастникиОбмена[н].ОбъектОбмена = Ключ;
				КонецЦикла; 
			КонецЕсли; 
		КонецЕсли; 
		
		Отбор = Новый Структура;
		Отбор.Вставить("ОбъектОбмена", Ключ);
		СтрокиКоллекции = Форма.УчастникиОбмена.НайтиСтроки(Отбор);
		Для каждого СтрокаКоллекции Из СтрокиКоллекции Цикл
			НоваяЗапись = УчастникиОбменаНЗ.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяЗапись,СтрокаКоллекции,"ОбъектОбмена,УзелОбмена,Обмен");
		КонецЦикла;
		УчастникиОбменаНЗ.Записать();
	
	КонецЕсли; 

КонецПроцедуры
 
Процедура УстановитьУсловноеОформление(Форма) Экспорт 

	Ключ = Форма.Параметры.Ключ;
	Элементы = Форма.Элементы;
	Элементы.УчастникиОбменаОбменВладелец.Видимость = Ложь;
	УсловноеОформление = Форма.УсловноеОформление;
	
	ОбъектОбмена = Ключ;
	Если ТипЗнч(ОбъектОбмена) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
		ИЛИ ТипЗнч(ОбъектОбмена) = Тип("СправочникСсылка.СпецификацииНоменклатуры") Тогда
		
		УзелSAP = ПланыОбмена.Обмен_МДМ_УПП.УзелSAP();
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();            
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УчастникиОбмена.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчастникиОбмена.УзелОбмена");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = УзелSAP;
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(128, 128, 128));
		
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();            
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.УчастникиОбмена.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("УчастникиОбмена.ОбменВладелец");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет(128, 128, 128));
		
		Элементы.УчастникиОбменаОбменВладелец.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДоступностьУчастниковОбмена(Форма) Экспорт 

	Если Форма.Параметры.Ключ.Пустая() Тогда
		Форма.Элементы.Страницы.ТекущаяСтраница = Форма.Элементы.ГруппаУчастникиОбмена;
	КонецЕсли; 
	
	Форма.Элементы.ДекорацияУчастникиНедоступны.Видимость = Форма.Параметры.Ключ.Пустая();
	Форма.Элементы.УчастникиОбмена.Доступность = НЕ Форма.Параметры.Ключ.Пустая();
	
КонецПроцедуры
 
//СЛУЖЕБНЫЕ
Процедура ПроверитьСвязанныйСправочник(Ссылка, ИмяСправочника, ИмяРеквизита, ПроверяемыеРеквизиты) Экспорт

	Выборка = Справочники[ИмяСправочника].Выбрать(,Ссылка);
	Если Выборка.Следующий() Тогда
		ПроверяемыеРеквизиты.Добавить(ИмяРеквизита);
	КонецЕсли; 
	
КонецПроцедуры

Функция КодироватьСтрокуВUTF8(СтрокаURL) Экспорт 
	
	Возврат КодироватьСтроку(СтрокаURL,СпособКодированияСтроки.URLВКодировкеURL);
	
КонецФункции // ПреобразоватьСтрокуВUTF8()
