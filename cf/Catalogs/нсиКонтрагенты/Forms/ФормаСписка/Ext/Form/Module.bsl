﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Сравнение данных"
	ИмяСправочника 										= "нсиКонтрагенты"; 
	ПроцентСовпадения 									= 100;
	Элементы.ГруппаПоиска.Видимость 					= Ложь;
	Элементы.ГруппаПолнотекстовогоПоиска.Видимость 		= Ложь;
	Элементы.ГруппаДополнительныеКлассификаторы.Видимость = Ложь;
	
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(ИмяСправочника, 
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);  	
	
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭтаФорма.ДополнительныеКлассификаторы.Отбор.Элементы, 
		"Владелец", ВидДопКлассификатора);
	
	// @Комментарий: Вызовем процедуру установки функциональных опций.
	нсиРаботаСФормамиСервер.УправлениеВидимостьюОбработкиЗаявок(ЭтаФорма);
	
	// @Комментарий: Отключим кнопки добавления и пометки удаления для пользователей с недостаточными правами.
	Элементы.ФормаСоздать.Видимость						= нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ИмяСправочника);
	Элементы.ФормаУстановитьПометкуУдаления.Видимость	= нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБезЗаявок(ИмяСправочника);
	
	Элементы.ГруппаОтборДляПоискаДубля.Видимость = Параметры.РежимПоискаДубля;
	Элементы.ГруппаОтбораСписка.Видимость = НЕ Параметры.РежимПоискаДубля;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Команда - отбирает записи по пользователю (захваченные в буфер).
//
Процедура ПоказатьИзБуфера(Команда)
	
	ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению(
		"Пользователь", Список.Отбор.Элементы);
		
	Если Не ЭлементОтбора = Неопределено Тогда
		Если ЭлементОтбора.Использование Тогда
			ЭлементОтбора.Использование = Ложь;
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	ЭлементОтбора = нсиРаботаСФормами.ОтборВСпискеПоЗначению(Список.Отбор.Элементы, 
		"Пользователь", ПользователиКлиентСервер.ТекущийПользователь(), ВидСравненияКомпоновкиДанных.Равно);
	ЭлементОтбора.Представление = "Захваченные в буфере";	
			
КонецПроцедуры

&НаКлиенте
// Событие - открывает форму ввода нового элемента справочника (заявки).
//
Процедура ВводНовогоЭлементаСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиВводНовогоЭлементаСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", ИмяСправочника)) ); 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Дополнительные классификаторы"

&НаКлиенте
// Процедура - событие, скрывающее/показывающее группу доп. классов.
//
Процедура ПоказатьГруппуПоискаПоДопКлассу(Команда)
	
	Элементы.ГруппаДополнительныеКлассификаторы.Видимость = Не Элементы.ГруппаДополнительныеКлассификаторы.Видимость;
	
	Если Не Элементы.ГруппаДополнительныеКлассификаторы.Видимость Тогда 
		ЭлементОтбора = нсиРаботаСФормами.НайтиГруппуОтбораПоПредставлению("По доп. классификатору", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.ФормаПоказатьГруппуПоискаПоДопКлассу.Пометка = не Элементы.ФормаПоказатьГруппуПоискаПоДопКлассу.Пометка;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Полнотекстовый поиск"

&НаКлиенте
// Процедура - событие, скрывающее/показывающее группу полнотекстного поиска.
//
Процедура ПоказатьГруппуПоискаПолнотекстно(Команда)
	
	Элементы.ГруппаПолнотекстовогоПоиска.Видимость = Не Элементы.ГруппаПолнотекстовогоПоиска.Видимость;
	Если Элементы.ГруппаПолнотекстовогоПоиска.Видимость Тогда 
		Элементы.ГруппаПоиска.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ФормаПоказатьГруппуПоискаПолнотекстно.Пометка = не Элементы.ФормаПоказатьГруппуПоискаПолнотекстно.Пометка;
	Элементы.ПоказатьГруппуРасширенногоПоиска.Пометка = Ложь;
	
КонецПроцедуры

&НаКлиенте
// Процедура - событие, выполняющее поиск данных и отбор списка.
//
Процедура НайтиДанныеПолнотекстно(Команда)
	
	НайтиДанныеПолнотекстноНаСервере();

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Сравнение данных"

&НаКлиенте 
// Процедура - событие, скрывающее/показывающее группу поиска.
//
Процедура ПоказатьГруппуРасширенногоПоиска(Команда)
	
	Элементы.ГруппаПоиска.Видимость = Не Элементы.ГруппаПоиска.Видимость;
	Если Элементы.ГруппаПоиска.Видимость Тогда 
		Элементы.ГруппаПолнотекстовогоПоиска.Видимость = Ложь;
	КонецЕсли;	
	
	Элементы.ПоказатьГруппуРасширенногоПоиска.Пометка = не Элементы.ПоказатьГруппуРасширенногоПоиска.Пометка;
	Элементы.ФормаПоказатьГруппуПоискаПолнотекстно.Пометка = Ложь;
	
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
	Результат = нсиСравнениеДанныхКлиент.ПолучитьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника, 
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
	нсиСравнениеДанныхКлиент.ВыбратьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНастройкиПоиска(Результат,ДП) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		НастройкаПоискаДанных = Результат;
		ЗаполнитьФорму(Результат);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
// Событие - открывает форму пакетного ввода новых элементов справочника (заявки).
//
Процедура ПакетныйВводЭлементовСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиПакетныйВводЭлементовСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", ИмяСправочника)) ); 
	
КонецПроцедуры

&НаКлиенте
// Процедура - поиск элементам по первым символам наименование.
//
Процедура БыстрыйПоиск(Команда)
	СсылкаНаЭлемент = нсиОбщегоНазначенияВызовСервера.ПолучитьСсылкуНаЭлементСервер(СтрокаБыстрогоПоиска, ИмяСправочника);
	Если ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
		Элементы.Список.ТекущаяСтрока = СсылкаНаЭлемент;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
// Событие - проверка возможности выполнения.
//
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Не нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ИмяСправочника);
	
КонецПроцедуры

&НаКлиенте
// Событие - проверка возможности выполнения.
//
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Не нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ИмяСправочника);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Дополнительные классификаторы"

&НаКлиенте
// Процедура - отбирает группу доп. классов по виду.
//
Процедура ВидДопКлассификатораПриИзменении(Элемент)
	
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭтаФорма.ДополнительныеКлассификаторы.Отбор.Элементы, 
		"Владелец", ВидДопКлассификатора);
	
КонецПроцедуры

&НаКлиенте
// Процедура - устанавливает записи выбранный классификатор.
//
Процедура ДополнительныеКлассификаторыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Не ЗначениеЗаполнено(ВидДопКлассификатора) Тогда 
		Возврат;
	КонецЕсли;	

	нсиСравнениеДанныхСервер.УстановкаДопКлассаПриПеретаскивании(
		ПараметрыПеретаскивания.Значение, Строка, ИмяСправочника,, ВидДопКлассификатора);
		
КонецПроцедуры

&НаКлиенте
// Процедура - отбирает загруженные и обработанные записи по доп. классу.
//
Процедура ДополнительныеКлассификаторыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ЭлементОтбора = нсиРаботаСФормами.НайтиГруппуОтбораПоПредставлению("По доп. классификатору", Список.Отбор.Элементы);
	Если ЭлементОтбора = Неопределено Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(
			Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
		ЭлементОтбора.Представление = "По доп. классификатору";	
	КонецЕсли;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование = Истина;
	
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭлементОтбора.Элементы, 
		"Ссылка.ДополнительнаяКлассификация.ВидКлассификатора", ВидДопКлассификатора);
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭлементОтбора.Элементы, 
		"Ссылка.ДополнительнаяКлассификация.Класс", ВыбраннаяСтрока);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Сравнение данных"

&НаКлиенте
// Событие - изменение условия поиска данных.
//
Процедура СтрокаБыстрогоПоискаПриИзменении(Элемент)
	СсылкаНаЭлемент = нсиОбщегоНазначенияВызовСервера.ПолучитьСсылкуНаЭлементСервер(СтрокаБыстрогоПоиска, ИмяСправочника);
	Если ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
		Элементы.Список.ТекущаяСтрока = СсылкаНаЭлемент;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Полнотекстовый поиск"

&НаСервере
// Процедура - вызывает общий метод УстановитьОтборВСпискеПоПолнотекстовымДанным.
//
Процедура НайтиДанныеПолнотекстноНаСервере()
	
	нсиСравнениеДанныхСервер.УстановитьОтборВСпискеПоПолнотекстовымДанным(Список, ИмяСправочника, 
		СтрокаПолнотекстовогоПоиска, ПроцентСовпадения);
			
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Сравнение данных"

&НаСервере
// Процедура - вызывает общий метод УстановитьОтборВСпискеПоНайденнымДанным
// вызов сервера в контексте формы.
//
Процедура УстановитьОтборВСпискеПоНайденнымДанным()
	
	// Обработчик подсистемы "Сравнение данных"
	нсиСравнениеДанныхСервер.УстановитьОтборВСпискеПоНайденнымДанным(Список, ИмяСправочника, 
		КомпоновщикНастроек, ПараметрыНеточногоПоиска);
	
КонецПроцедуры

&НаСервере
// Процедура - заполняет АдресКомпоновки, ПараметрыНеточногоПоиска и КомпоновщикНастроек 
// вызов сервера в контексте формы.
//
Процедура ЗаполнитьФорму(ВходящиеДанные)
	
	// Обработчик подсистемы "Сравнение данных"
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(ИмяСправочника, 
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.ЗаполнитьПараметрыИКомпоновщикНастроек(ВходящиеДанные, 
		ПараметрыНеточногоПоиска, КомпоновщикНастроек);
	
КонецПроцедуры

#КонецОбласти


