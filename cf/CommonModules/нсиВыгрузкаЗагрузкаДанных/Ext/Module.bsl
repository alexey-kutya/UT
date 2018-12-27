﻿#Область ПрограммныйИнтерфейс

// Создает и заполняет пакет данными элемент, 
// предназначенный для выгрузки в файл.
//
// Параметры:
//   ДанныеЭлемента - Структура со свойствами:
//      * Реквизиты      - Массив     - имена реквизитов для выгрузки
//      * Характерситики - Массив     - имена характерситик для выгрузки
//      * ТЧ             - Структура  - в качестве ключа передается
//                                       имя табличной части, а в качестве значения
//                                       массив с именами реквезитов табличной части.
//   Ссылка         - ЛюбаяСсылка     - объект, значения реквизитов которого 
//                                      необходимо выгрузить.
//
// Возвращаемое значение:
//  Структура - содержит следующие свойства:
//    Реквизиты		  - Структура - в качестве ключа используется имя реквизита
//                                  а в качестве значения, значения реквизта в
//                                  выгружаемом элементе.
//    Характерситики  - Массив    - содержит струкутру характеристик со значениями
//                                  ссылки, наименования и кода характеристики.
//    ТЧ			  - Структура - в качестве ключа используется 
//                                  имя табличной части, а в качестве значения
//                                  массив с элементами структуры имя реквизта - значение.
//
// Пример: 
// 
//   ДанныеЭлемента = Новый Структура("Реквизиты, Характерситики, ТЧ",
//                                    Новый Массив(), Новый Массив(), Новый Структура);
//   РекТч = Новый Массив();
//   РекТч.Добавить("Значение");
//   ДанныеЭлемента.Реквизиты.Добавить("ПризнакИспользования");
//   ДанныеЭлемента.Реквизиты.Добавить("Артикул");
//   ДанныеЭлемента.ТЧ.Вставить("ТехническиеХарактеристики",РекТч);
//   ДанныеЭлемента.Характерситики.Добавить("гост на тех. условия");
// 
// Варианты вызова:
//   ПакетАтрибутов = нсиВыгрузкаЗагрузкаДанных.ЗаполнитьСтруктуруПакетаДляВыгрузки(ДанныеЭлемента,Ссылка);
//
Функция ЗаполнитьСтруктуруПакетаДляВыгрузки(ДанныеЭлемента, Ссылка) Экспорт
	
	ПакетАтрибутов 	= Новый Структура("Реквизиты, Характерситики, ТЧ",
										Новый Структура,Новый Массив, Новый Структура);
	
	Спр = Ссылка.Метаданные();
		
	Если ДанныеЭлемента.Реквизиты.Количество() > 0 Тогда
		ЗаполнитьРеквизитыПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов);			
	КонецЕсли;
	
	Если ДанныеЭлемента.ТЧ.Количество() > 0 Тогда
		ЗаполнитьТЧПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов);	
	КонецЕсли;
	
	Если ДанныеЭлемента.Характерситики.Количество() > 0 Тогда
		ЗаполнитьХарактеристикиПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов);	
	КонецЕсли;
	
	Возврат ПакетАтрибутов;
	
КонецФункции

// Создает и заполняет пакет данными элемент,
//
// Возвращаемое значение:
//  Структура - содержит следующие свойства:
//    Реквизиты		  - Структура - в качестве ключа используется имя реквизита
//                                  а в качестве значения, значения реквизта в
//                                  выгружаемом элементе.
//    Характерситики  - Массив    - содержит струкутру характеристик со значениями
//                                  ссылки, наименования и кода характеристики.
//    ТЧ			  - Структура - в качестве ключа используется 
//                                  имя табличной части, а в качестве значения
//                                  массив с элементами структуры имя реквизта - значение.
//
Функция ПолучитьСтруктурыТелаИнформационногоПакета() Экспорт
	Возврат Новый Структура("Реквизиты, Характерситики, ТЧ",Новый Массив(), Новый Массив(), Новый Структура)
КонецФункции

// Загружает данные в элемент справочника
// предназначенный для выгрузки в файл.
//
// Параметры:
//   xdtoОбъект - ОбъектXDT содержит следующие элементы:
//    * Реквизиты      - ОбъектXDTO - содержит имена и значения реквизитов.
//    * ТЧ             - ОбъектXDTO - содержит имена тч и их строки.
//    * Характерситики - ОбъектXDTO - содержит имя и значение характеристик.
//   Ссылка 	- ЛюбаяСсылка	- ссылка на элемент, данные в который
//								  будут записаны.
//
Функция ЗагрузитьЭлементСправочника(xdtoОбъект, Ссылка) Экспорт
	
	Спр = Ссылка.Метаданные();
	спрОбъект = Ссылка.ПолучитьОбъект();
	
	ЗагрузитьРеквизиты(спрОбъект, Спр, xdtoОбъект);
	ЗагрузитьТЧ(спрОбъект, Спр, xdtoОбъект);
	спрОбъект.ОбменДанными.Загрузка = Истина;
	Попытка 
		спрОбъект.Записать();
		Возврат Истина;
	Исключение
		информацияОшибка = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации("ESB. Обработка сообщения", УровеньЖурналаРегистрации.Ошибка,,, информацияОшибка);
		Возврат Ложь;
	КонецПопытки;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ВыгрузкаДанных

Процедура ЗаполнитьРеквизитыПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов)
	
	МассивСтандартныхРеквизитов = Новый Массив;
	Для Каждого Реквизит из Спр.СтандартныеРеквизиты Цикл
		МассивСтандартныхРеквизитов.Добавить(Реквизит.Имя);	
	КонецЦикла;

	
	СтрРеквизитов = "";
	Для Каждого ИмяРеквизита Из ДанныеЭлемента.Реквизиты Цикл
		Реквизит = ?(Спр.Реквизиты.Найти(ИмяРеквизита) = Неопределено,
						МассивСтандартныхРеквизитов.Найти(ИмяРеквизита),
						Спр.Реквизиты.Найти(ИмяРеквизита));
						
		Если Реквизит = Неопределено Тогда
			Продолжить;	
		КонецЕсли;
		
		СтрРеквизитов = СтрРеквизитов + ?(СтрРеквизитов = "","",", ") + ИмяРеквизита;
	КонецЦикла;

	ЗначенияРеквизитовЭлемента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, СтрРеквизитов);
	
	Для Каждого Реквизит Из ЗначенияРеквизитовЭлемента Цикл
		Значение = Реквизит.Значение;  
		ПакетАтрибутов.Реквизиты.Вставить(Реквизит.Ключ,ПолучитьЗначениеРеквизита(Значение));
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТЧПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов)
	
	Для Каждого Стр Из ДанныеЭлемента.ТЧ Цикл
		ИмяТч = Стр.Ключ;
		ОбТч = Спр.ТабличныеЧасти.Найти(ИмяТч);
		Если ОбТч = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ПакетАтрибутов.ТЧ.Вставить(ИмяТч);

		СтрРеквизитов = "";
		Для Каждого ИмяРеквизита Из Стр.Значение Цикл
			Если ОбТч.Реквизиты.Найти(ИмяРеквизита) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрРеквизитов = СтрРеквизитов + ?(СтрРеквизитов = "","",",") + ИмяРеквизита;
		КонецЦикла;
		Выборка = ВернутьВыборкуПоТч(Ссылка, ИмяТч, СтрРеквизитов);
		
		МассивТч = Новый Массив;
		Пока Выборка.Следующий() Цикл
			стрТч = Новый Структура(СтрРеквизитов);
			Для Каждого Реквизит Из стрТч Цикл
				ИмяРеквизита 		= Реквизит.Ключ;
				ЗначениеРеквизита 	= Выборка[ИмяРеквизита];
				стрТч[ИмяРеквизита] = ПолучитьЗначениеРеквизита(ЗначениеРеквизита);	
			КонецЦикла;
			МассивТч.Добавить(стрТч);
		КонецЦикла;
		ПакетАтрибутов.ТЧ[ИмяТч] = МассивТч;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьХарактеристикиПакета(Ссылка, Спр, ДанныеЭлемента, ПакетАтрибутов)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	нсиХарактеристикиМТР.Ссылка,
		|	нсиХарактеристикиМТР.Код,
		|	нсиХарактеристикиМТР.Наименование
		|ИЗ
		|	ПланВидовХарактеристик.нсиХарактеристикиМТР КАК нсиХарактеристикиМТР
		|ГДЕ
		|	нсиХарактеристикиМТР.Класс В
		|			(ВЫБРАТЬ
		|				Спр.Класс
		|			ИЗ
		|				" + Ссылка.Метаданные().ПолноеИмя() + " КАК Спр
		|			ГДЕ
		|				Спр.Ссылка = &Ссылка)
		|	И нсиХарактеристикиМТР.Наименование В(&Наименование)";
	
	Запрос.УстановитьПараметр("Ссылка", 		Ссылка);
	Запрос.УстановитьПараметр("Наименование", 	ДанныеЭлемента.Характерситики);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Ссылка = ВернутьСтруктуруСсылки();
		ЗаполнитьЗначенияСвойств(Ссылка,Выборка);
		Ссылка.Guid = Выборка.Ссылка.УникальныйИдентификатор();
		ПакетАтрибутов.Характерситики.Добавить(Ссылка);	
	КонецЦикла;

КонецПроцедуры

Функция ВернутьВыборкуПоТч(Ссылка, ИмяТч, Знач СтрРеквизитов)
	
	СтрРеквизитов = СтрРазделить(СтрРеквизитов, ",", Ложь);
	ТекстПолей = "";
	Для Каждого Реквизит Из СтрРеквизитов Цикл
		ТекстПолей = ТекстПолей + ?(ТекстПолей = "","",", ")+"таб."+Реквизит;			
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|" + ТекстПолей + "
	|ИЗ
	|	" + Ссылка.Метаданные().ПолноеИмя() + "." + ИмяТч + " КАК таб 
	|ГДЕ
	|	таб.Ссылка = &Ссылка";
	
	Возврат(Запрос.Выполнить().Выбрать());

КонецФункции

Функция ПолучитьЗначениеРеквизита(Значение)
	
	Тип = ТипЗнч(Значение);
	
	Если Не ОбщегоНазначения.ЭтоСсылка(Тип) Тогда  
		Возврат Строка(Значение);
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Тип) Тогда
		Возврат ОбщегоНазначения.ИмяЗначенияПеречисления(Значение);
	КонецЕсли;
	
	Ссылка 				= ВернутьСтруктуруСсылки();	
	Ссылка.Guid 		= Значение.УникальныйИдентификатор();
	Реквизиты 			= ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Значение, "Код, Наименование");
	Ссылка.Код 			= Реквизиты.Код;
	Ссылка.Наименование	= Реквизиты.Наименование;
	
	Возврат Ссылка;
	
КонецФункции

Функция ВернутьСтруктуруСсылки()
	Возврат Новый Структура("Guid, Код, Наименование");	
КонецФункции

#КонецОбласти

#Область ЗагрузкаДанных

Процедура ЗагрузитьРеквизиты(спрОбъект, Спр, xdtoОбъект)
	
	МассивСтандартныхРеквизитов = Новый Массив;
	Для Каждого Реквизит из Спр.СтандартныеРеквизиты Цикл
		МассивСтандартныхРеквизитов.Добавить(Реквизит.Имя);	
	КонецЦикла;
	
	Для Каждого Свойство из xdtoОбъект.Реквизиты.Свойства() Цикл
		ИмяРеквизита = Свойство.Имя;
		
		СтандарныйРеквизит = ?(МассивСтандартныхРеквизитов.Найти(ИмяРеквизита) = Неопределено,
								Неопределено,
								Спр.СтандартныеРеквизиты[ИмяРеквизита]);
								
		Реквизит = ?(Спр.Реквизиты.Найти(ИмяРеквизита) = Неопределено,
						СтандарныйРеквизит,
						Спр.Реквизиты.Найти(ИмяРеквизита));
						
		Если Реквизит = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТипЭлемента 		= Реквизит.Тип.Типы()[0];
		ЗначениеЭлемента 	= xdtoОбъект.Получить("/Реквизиты/"+ИмяРеквизита); 
		Если ЗначениеЭлемента = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		спрОбъект[ИмяРеквизита] = ПреобразоватьЗначениеРеквизита(ТипЭлемента, ЗначениеЭлемента);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗагрузитьТЧ(спрОбъект, Спр, xdtoОбъект)
	
	Для Каждого Свойство из xdtoОбъект.ТЧ.Свойства() Цикл
		ИмяТч = Свойство.Имя;
		ТЧ = Спр.ТабличныеЧасти.Найти(ИмяТч);
		Если ТЧ = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		xdtoТЧ = xdtoОбъект.Получить("/ТЧ/"+ИмяТч);
		СтрокиТЧ = xdtoТЧ.Row;
		Для Каждого СтрокаТч из СтрокиТЧ Цикл
			НоваяСтрока = спрОбъект[ИмяТч].Добавить();
			Для Каждого СвойствоТЧ Из СтрокаТч.Свойства() Цикл
				ИмяРеквизитаТч = СвойствоТЧ.Имя;
				РеквизитТч = ТЧ.Реквизиты.Найти(ИмяРеквизитаТч);
				Если РеквизитТч = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ТипЭлемента 		= РеквизитТч.Тип.Типы()[0];
				ЗначениеЭлемента 	= СтрокаТч.Получить(ИмяРеквизитаТч);
				Если ЗначениеЭлемента = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				НоваяСтрока[ИмяРеквизитаТч] = ПреобразоватьЗначениеРеквизита(ТипЭлемента, ЗначениеЭлемента);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция ПреобразоватьЗначениеРеквизита(ТипЭлемента, ЗначениеЭлемента)
	
	Если Не ОбщегоНазначения.ЭтоСсылка(ТипЭлемента) Тогда 
		Возврат ПреобразоватьЗначениеПримитивногоТипа(ТипЭлемента,ЗначениеЭлемента);
	КонецЕсли;
	 
	ОбъектМетаданных 	= Метаданные.НайтиПоТипу(ТипЭлемента);
	ИмяОМ 				= ОбъектМетаданных.Имя;
	Если Перечисления.ТипВсеСсылки().СодержитТип(ТипЭлемента) Тогда
		Возврат Перечисления[ИмяОМ][ЗначениеЭлемента];
	ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(ТипЭлемента) Тогда
		КлассОМ = "СПРАВОЧНИК."; 
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(ТипЭлемента) Тогда 
		КлассОМ = "ПЛАНВИДОВХАРАКТЕРИСТИК."; 
	КонецЕсли;
	ПолноеИмя 		= КлассОМ+ИмяОМ; 
	Менеджер 		= ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
	
	Guid = ?(ТипЗнч(ЗначениеЭлемента.Guid)= Тип("ОбъектXDTO"), "", ЗначениеЭлемента.Guid);
	Если Guid <> "" Тогда
		ЗначениеСсылка	= Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Guid));
	Иначе
		ЗначениеСсылка 	= Менеджер.ПустаяСсылка();	
	КонецЕсли;
	
	Если ЗначениеСсылка.Пустая() Тогда
		ЗначениеСсылка = НайтиЭлементСсылочногоТипа(ПолноеИмя,ЗначениеЭлемента.Код,ЗначениеЭлемента.Наименование);	
	КонецЕсли;
	
	Возврат ЗначениеСсылка;	
	
КонецФункции

Функция ПреобразоватьЗначениеПримитивногоТипа(ТипЭлемента, Значение)
	Если ТипЭлемента = Тип("Строка") Тогда
		Возврат Значение;			
	ИначеЕсли ТипЭлемента = Тип("Число") Тогда 
		Возврат Число(Значение);			
	ИначеЕсли ТипЭлемента = Тип("Дата") Тогда
		Возврат Дата(Значение);			
	ИначеЕсли ТипЭлемента = Тип("Булево") Тогда
		Возврат Булево(Значение);			
	КонецЕсли;
КонецФункции

Функция НайтиЭлементСсылочногоТипа(ПолноеИмя, Код, Наименование)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	"+ПолноеИмя+Символы.ПС+
	"ГДЕ
	|	Код = &Код");
	Запрос.УстановитьПараметр("Код",Код);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	"+ПолноеИмя+Символы.ПС+
	"ГДЕ
	|	Наименование = &Наименование");
	Запрос.УстановитьПараметр("Наименование",Наименование);
	
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
	Возврат МенеджерОбъекта.ПустаяСсылка(); 
	
КонецФункции

#КонецОбласти

#КонецОбласти
