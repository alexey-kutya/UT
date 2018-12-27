﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ТипЗнч(Параметры.Отбор.Владелец) = Тип("ПланВидовХарактеристикСсылка.нсиХарактеристикиМТР")
		ИЛИ ТипЗнч(Параметры.Отбор.Владелец) = Тип("ПланВидовХарактеристикСсылка.нсиХарактеристикиУслуг")
		ИЛИ ТипЗнч(Параметры.Отбор.Владелец) = Тип("ПланВидовХарактеристикСсылка.нсиХарактеристикиУниверсальногоСправочника")
		Тогда
		Параметры.Отбор.Владелец = Параметры.Отбор.Владелец.НаименованиеПоКлассификатору.ВидСправочника;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидСправочника) Тогда 
		Попытка
			ВидСправочника = Параметры.Отбор.Владелец;        				
		Исключение
			Возврат;
		КонецПопытки;
	КонецЕсли;

	ДопПоля = "";
	ДопСвязи = "";
	
	Если ВидСправочника.ИспользоватьЗаявки ИЛИ ВидСправочника.ИспользоватьНормализацию Тогда 
		ДопПоля = "
			|// Параметры статуса
			|СтатусыОбработки.Пользователь КАК Пользователь,
			|СтатусыОбработки.ВременныйЭлемент КАК ВременныйЭлемент, СтатусыОбработки.СозданаЗаявка КАК СозданаЗаявка,
			|СтатусыОбработки.ОбработкаНачата КАК ОбработкаНачата, СтатусыОбработки.Обработано КАК Обработано,
			|СтатусыОбработки.Обработавший КАК Обработавший";
			
		ДопСвязи = "
			|ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.нсиСтатусыОбработкиСправочников КАК СтатусыОбработки
			|	ПО (СтатусыОбработки.Объект = ОсновнаяТаблица.Ссылка)
			|	// не временные, или временные пользователя или временные по группе доступа
			|	И НЕ СтатусыОбработки.ВременныйЭлемент";
	КонецЕсли;
		
	нсиУниверсальноеХранилищеФормыСервер.ФормаСпискаПриСозданииНаСервере(
		ЭтаФорма,Отказ,ДопПоля,ДопСвязи,
		" И (ВЫБОР КОГДА &СсылкаНеОпределена ТОГДА ИСТИНА ИНАЧЕ ОсновнаяТаблица.Ссылка В (&Ссылка) КОНЕЦ)"
	);
	Если Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	нсиУниверсальноеХранилищеФормыСервер.УстановитьОформлениеСписка(Список.КомпоновщикНастроек.Настройки.УсловноеОформление,пМетаданные);
	
	
	Если пМетаданные.ИспользоватьЗаявки ИЛИ пМетаданные.ИспользоватьНормализацию Тогда 
		нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);  	
		
		Поле = Элементы.Добавить("Пользователь", Тип("ПолеФормы"), Элементы.Список);
		Поле.ПутьКДанным = "Список.Пользователь";
		
	КонецЕсли;
	
	Если пМетаданные.ИспользоватьЗаявки Тогда 
		Поле = Элементы.Добавить("СозданаЗаявка", Тип("ПолеФормы"), Элементы.Список);
		Поле.ПутьКДанным = "Список.СозданаЗаявка";
	КонецЕсли;
	
	Если пМетаданные.ИспользоватьНормализацию Тогда 
		Поле = Элементы.Добавить("ТипПозиции", Тип("ПолеФормы"), Элементы.Список);
		Поле.ПутьКДанным = "Список.ТипПозиции";
		
		Поле = Элементы.Добавить("ЭталоннаяПозиция", Тип("ПолеФормы"), Элементы.Список);
		Поле.ПутьКДанным = "Список.ЭталоннаяПозиция";
		
		Поле = Элементы.Добавить("ЗаписьНеНормализуема", Тип("ПолеФормы"), Элементы.Список);
		Поле.Вид = ВидПоляФормы.ПолеФлажка;
		Поле.ПутьКДанным = "Список.ЗаписьНеНормализуема";
		
		Поле = Элементы.Добавить("ОбработкаНачата", Тип("ПолеФормы"), Элементы.Список);
		Поле.Вид = ВидПоляФормы.ПолеФлажка;
		Поле.ПутьКДанным = "Список.ОбработкаНачата";
		
		Поле = Элементы.Добавить("Обработано", Тип("ПолеФормы"), Элементы.Список);
		Поле.Вид = ВидПоляФормы.ПолеФлажка;
		Поле.ПутьКДанным = "Список.Обработано";
		
		Поле = Элементы.Добавить("Обработавший", Тип("ПолеФормы"), Элементы.Список);
		Поле.Вид = ВидПоляФормы.ПолеФлажка;
		Поле.ПутьКДанным = "Список.Обработавший";
		
		Поле = Элементы.Добавить("ДатаОбработки", Тип("ПолеФормы"), Элементы.Список);
		Поле.Вид = ВидПоляФормы.ПолеФлажка;
		Поле.ПутьКДанным = "Список.Обработавший";
	КонецЕсли;
	
	Если пМетаданные.ИспользоватьЗаявки Тогда 
	
		// @Комментарий: Отключим кнопки добавления и пометки удаления для пользователей с недостаточными правами.
		нсиУниверсальноеХранилищеФормыСервер.УстановитьВидимостьКнопки(ЭтаФорма,
			"ФормаСоздать",
			нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ВидСправочника)
		);
		
		
		Если пМетаданные.Иерархический 
			И пМетаданные.ВидИерархии = Перечисления.нсиВидыИерархииСправочников.ИерархияГруппИЭлементов Тогда 
			
			нсиУниверсальноеХранилищеФормыСервер.УстановитьВидимостьКнопки(ЭтаФорма,
				"ФормаСоздатьГруппу",
				нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ВидСправочника)
			);
		КонецЕсли;
		
		нсиУниверсальноеХранилищеФормыСервер.УстановитьВидимостьКнопки(ЭтаФорма,
			"ФормаУстановитьПометкуУдаления",
			нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБезЗаявок(ВидСправочника)
		);
	КонецЕсли;
	
	
	Элементы.ГруппаКлассификатор.Видимость = Ложь;
	Элементы.ПоказатьГруппуПоискаПоКлассу.Видимость = пМетаданные.ИспользоватьКлассификацию;
	
	Если ВидСправочника.ИспользоватьКлассификацию Тогда 
		Поле = Элементы.Добавить("Класс", Тип("ПолеФормы"), Элементы.Список);
		Поле.ПутьКДанным = "Список.Класс";
		
		нсиРаботаСФормами.ОтборВСпискеПоПараметру(ЭтаФорма.Список.Отбор.Элементы, Параметры, "Класс", "Класс");
		
		ЭлементОтбора = нсиРаботаСФормами.ОтборВСпискеПоЗначению(
			Классификатор.Отбор.Элементы, 
			"Владелец", 
			пМетаданные.Классификатор.Тип.Тип2, 
			ВидСравненияКомпоновкиДанных.ВИерархии, 
			Истина
		);
		ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли;
	
	Элементы.СтатусыОбработкиСправочников.Видимость = 
		пМетаданные.ИспользоватьНормализацию И пМетаданные.ПраваДоступа.Редактирование;
	Элементы.СтатусыОбработкиСправочников1.Видимость = 
		пМетаданные.ИспользоватьНормализацию И пМетаданные.ПраваДоступа.Редактирование;
		
	ИспользоватьБизнесПроцессыИЗадачи = Константы.ИспользоватьБизнесПроцессыИЗадачи.Получить();
	Элементы.ГруппаЗаявок.Видимость = пМетаданные.ИспользоватьЗаявки И ИспользоватьБизнесПроцессыИЗадачи;
	Элементы.ГруппаЗаявок1.Видимость = пМетаданные.ИспользоватьЗаявки И ИспользоватьБизнесПроцессыИЗадачи;
	Элементы.БизнесПроцесснсиИзменениеЭлементаСправочникаСоздатьНаОсновании1.Видимость = пМетаданные.ИспользоватьЗаявки И ИспользоватьБизнесПроцессыИЗадачи;
	Элементы.БизнесПроцесснсиУдалениеЭлементаСправочникаСоздатьНаОсновании1.Видимость = пМетаданные.ИспользоватьЗаявки И ИспользоватьБизнесПроцессыИЗадачи;
	
	ПроцентСовпадения 									= 100;
	Элементы.ГруппаПоиска.Видимость 					= Ложь;
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(Параметры.ВидСправочника,
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);  	
	
КонецПроцедуры
	
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если пМетаданные = Неопределено Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриВыбореВидаСправочника",ЭтаФорма);
		ОткрытьФорму(
			"Справочник.нсиВидыСправочников.ФормаВыбора",
			новый Структура("Отбор",
				новый Структура("ВидСправочника",ПредопределенноеЗначение("Перечисление.нсиВидыСправочников.ФункциональныйСправочник"))
			),
			ЭтаФорма,,,,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
		);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореВидаСправочника(Результат, ДП) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		Отказ = Ложь;
		ВидСправочника = Результат;
		ПриСозданииНаСервере(Отказ,Истина);
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьГруппу(Команда)
	ОткрытьФорму(
		"Справочник.нсиУниверсальныйФункциональныйСправочник.ФормаОбъекта",
		новый Структура("ЗначенияЗаполнения",
			новый Структура("Владелец,пЭтоГруппа",Параметры.ВидСправочника,Истина),
		),
		ЭтаФорма
	);
КонецПроцедуры

&НаКлиенте
// Команда - открывает форму ввода нового элемента справочника (заявки).
//
Процедура ВводНовогоЭлементаСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиВводНовогоЭлементаСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", Параметры.ВидСправочника)) ); 
	
КонецПроцедуры

&НаКлиенте
// Событие - открывает форму пакетного ввода новых элементов справочника (заявки).
//
Процедура ПакетныйВводЭлементовСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиПакетныйВводЭлементовСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", Параметры.ВидСправочника)) ); 
	
КонецПроцедуры

&НаКлиенте
// Процедура - событие, скрывающее/показывающее группу классов.
//
Процедура ПоказатьГруппуПоискаПоКлассу(Команда)
	
	Элементы.ГруппаКлассификатор.Видимость = Не Элементы.ГруппаКлассификатор.Видимость;
	
	Если Не Элементы.ГруппаКлассификатор.Видимость Тогда
		ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению("Класс", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;	
	
	Элементы.ПоказатьГруппуПоискаПоКлассу.Пометка = не Элементы.ПоказатьГруппуПоискаПоКлассу.Пометка;
КонецПроцедуры

&НаКлиенте 
// Процедура - событие, скрывающее/показывающее группу поиска.
//
Процедура ПоказатьГруппуРасширенногоПоиска(Команда)
	Элементы.ГруппаПоиска.Видимость = Не Элементы.ГруппаПоиска.Видимость;
	Элементы.ПоказатьГруппуРасширенногоПоиска.Пометка = не Элементы.ПоказатьГруппуРасширенногоПоиска.Пометка;
КонецПроцедуры

&НаКлиенте
// Процедура - событие, выполняющее поиск данных и отбор списка.
//
Процедура НайтиДанные(Команда)
	
	УстановитьОтборВСпискеПоНайденнымДанным();
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
// Процедура - событие, отменяющее отбор списка по параметрам поиска.
//
Процедура ОтменитьПоиск(Команда)
	
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	
КонецПроцедуры

&НаКлиенте
// Процедура - событие, выполняющее открытие формы настройки поиска.
//
Процедура НастройкаПоиска(Команда)
	
	// Обработчик подсистемы "Сравнение данных"
	ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаПолученияНастройкиПоиска",ЭтотОбъект);
	Результат = нсиСравнениеДанныхКлиент.ПолучитьНастройкуПоиска(ОписаниеОповещения, Параметры.ВидСправочника, 
		КомпоновщикНастроек, ПараметрыНеточногоПоиска, НастройкаПоискаДанных);	
		
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПолученияНастройкиПоиска(Результат,ДП) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		ЗаполнитьФорму(Результат);		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
// Процедура - событие, выполняющее открытие формы выбора настройки поиска.
//
Процедура ВыбратьНастройку(Команда)

	// Обработчик подсистемы "Сравнение данных"
	ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВыбораНастройкиПоиска",ЭтотОбъект);
	нсиСравнениеДанныхКлиент.ВыбратьНастройкуПоиска(ОписаниеОповещения, Параметры.ВидСправочника);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНастройкиПоиска(Результат,ДП) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		НастройкаПоискаДанных = Результат;
		ЗаполнитьФорму(Результат);
	КонецЕсли;	
КонецПроцедуры


#КонецОбласти


#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = НЕ пМетаданные.ПраваДоступа.Добавление;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКлассификатора

&НаКлиенте
// Процедура - отбирает загруженные и обработанные записи по классу.
//
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ЭлементОтбора = нсиРаботаСФормами.ОтборВСпискеПоЗначению(Список.Отбор.Элементы, 
		"Класс", ВыбраннаяСтрока, ВидСравненияКомпоновкиДанных.ВИерархии, ЗначениеЗаполнено(ВыбраннаяСтрока));
	ЭлементОтбора.Представление = "По основному классификатору";	
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование = Истина;
КонецПроцедуры

&НаКлиенте
// Процедура - присваивает выбранным элементам класс.
//
Процедура КлассификаторПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	нсиСравнениеДанныхСервер.УстановкаКлассаПриПеретаскивании(ПараметрыПеретаскивания.Значение, Строка, "нсиУниверсальныйФункциональныйСправочник");
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура - заполняет АдресКомпоновки, ПараметрыНеточногоПоиска и КомпоновщикНастроек. 
// вызов сервера в контексте формы.
//
Процедура ЗаполнитьФорму(ВходящиеДанные)
	
	// Обработчик подсистемы "Сравнение данных"
	ПараметрыНеточногоПоиска.Очистить();
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(Параметры.ВидСправочника, 
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.ЗаполнитьПараметрыИКомпоновщикНастроек(ВходящиеДанные, 
		ПараметрыНеточногоПоиска, КомпоновщикНастроек);
	
КонецПроцедуры
	
&НаСервере
// Процедура - вызывает общий метод УстановитьОтборВСпискеПоНайденнымДанным
// вызов сервера в контексте формы.
//
Процедура УстановитьОтборВСпискеПоНайденнымДанным()
	
	// Обработчик подсистемы "Сравнение данных"
	нсиСравнениеДанныхСервер.УстановитьОтборВСпискеПоНайденнымДанным(Список, Параметры.ВидСправочника, 
		КомпоновщикНастроек, ПараметрыНеточногоПоиска);
	
КонецПроцедуры

#КонецОбласти
