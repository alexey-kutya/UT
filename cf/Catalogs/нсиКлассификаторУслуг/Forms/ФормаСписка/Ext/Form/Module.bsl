﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Сравнение данных"
	ИмяСправочника 										= "нсиКлассификаторУслуг";
	ПроцентСовпадения 									= 100;
	Элементы.ГруппаПоиска.Видимость 					= Ложь;
	Элементы.ГруппаПолнотекстовогоПоиска.Видимость 		= Ложь;
	
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(ИмяСправочника, 
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);  	
	
	// @Комментарий: Вызовем процедуру установки функциональных опций.
	нсиРаботаСФормамиСервер.УправлениеВидимостьюОбработкиЗаявок(ЭтаФорма);
	
	// @Комментарий: Отключим кнопки добавления и пометки удаления для пользователей с недостаточными правами.
	Элементы.ФормаСоздать.Видимость						= нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ИмяСправочника);
	Элементы.ФормаУстановитьПометкуУдаления.Видимость	= нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБезЗаявок(ИмяСправочника);
	
	Элементы.ГруппаОтборДляПоискаДубля.Видимость = Параметры.РежимПоискаДубля;
	Элементы.ГруппаОтбораСписка.Видимость = НЕ Параметры.РежимПоискаДубля;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


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
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ПоказатьПредупреждение(,"Настройка поиска недоступна в режиме обычного приложения!");
		Возврат;
	#Иначе
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаПолученияНастройкиПоиска",ЭтотОбъект);
		Результат = нсиСравнениеДанныхКлиент.ПолучитьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника, 
			КомпоновщикНастроек, ПараметрыНеточногоПоиска, НастройкаПоискаДанных);	
	#КонецЕсли
		
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
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		ПоказатьПредупреждение(,"Настройка поиска недоступна в режиме обычного приложения!");
		Возврат;
	#Иначе
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВыбораНастройкиПоиска",ЭтотОбъект);
		нсиСравнениеДанныхКлиент.ВыбратьНастройкуПоиска(ОписаниеОповещения, ИмяСправочника);	
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНастройкиПоиска(Результат,ДП) Экспорт
	Если ЗначениеЗаполнено(Результат) Тогда 
		НастройкаПоискаДанных = Результат;
		ЗаполнитьФорму(Результат);
	КонецЕсли;	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Сравнение данных"

&НаКлиенте
// Событие - открывает форму пакетного ввода новых элементов справочника (заявки).
//
Процедура ПакетныйВводЭлементовСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиПакетныйВводЭлементовСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", ИмяСправочника)) ); 
	
КонецПроцедуры

&НаКлиенте
// Процедура - поиск элементам по первым символам наименование.
Процедура БыстрыйПоиск(Команда)
	СсылкаНаЭлемент = нсиОбщегоНазначенияВызовСервера.ПолучитьСсылкуНаЭлементСервер(СтрокаБыстрогоПоиска, ИмяСправочника);
	Если ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
		Элементы.Список.ТекущаяСтрока = СсылкаНаЭлемент;	
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

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
// Процедура - вызывает общий метод УстановитьОтборВСпискеПоНайденнымДанным.
// вызов сервера в контексте формы
//
Процедура УстановитьОтборВСпискеПоНайденнымДанным()
	
	// Обработчик подсистемы "Сравнение данных"
	нсиСравнениеДанныхСервер.УстановитьОтборВСпискеПоНайденнымДанным(Список, ИмяСправочника, 
		КомпоновщикНастроек, ПараметрыНеточногоПоиска);
	
КонецПроцедуры

&НаСервере
// Процедура - заполняет АдресКомпоновки, ПараметрыНеточногоПоиска и КомпоновщикНастроек. 
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
