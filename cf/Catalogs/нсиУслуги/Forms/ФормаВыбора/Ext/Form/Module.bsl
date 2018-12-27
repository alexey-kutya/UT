﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обработчик подсистемы "Сравнение данных"
	ИмяСправочника 										= "нсиУслуги"; 
	ПроцентСовпадения 									= 100;
	Элементы.ГруппаПоиска.Видимость 					= Ложь;
	Элементы.ГруппаПолнотекстовогоПоиска.Видимость 		= Ложь;
	Элементы.ГруппаКлассификаторУслуг.Видимость 	= Ложь;
	Элементы.ГруппаДополнительныеКлассификаторы.Видимость = Ложь;
	
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(ИмяСправочника, 
		АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);  	
	нсиРаботаСФормами.ОтборВСпискеПоПараметру(ЭтаФорма.Список.Отбор.Элементы, Параметры, "Класс", "Класс");
	
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭтаФорма.ДополнительныеКлассификаторы.Отбор.Элементы, 
		"Владелец", ВидДопКлассификатора);
	
	// @Комментарий: Вызовем процедуру установки функциональных опций.
	нсиРаботаСФормамиСервер.УправлениеВидимостьюОбработкиЗаявок(ЭтаФорма);
	
	// @Комментарий: Отключим кнопки добавления и пометки удаления для пользователей с недостаточными правами.
	Элементы.ФормаСоздать.Видимость						= нсиСравнениеДанныхСервер.ПроверитьРедактированиеСправочниковБезЗаявок(ИмяСправочника);
	Элементы.ФормаУстановитьПометкуУдаления.Видимость	= нсиСравнениеДанныхСервер.ПроверитьПометкуНаУдалениеБезЗаявок(ИмяСправочника);
	
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
// ПОДСИСТЕМА "Классификатор услуг"

&НаКлиенте
// Процедура - событие, скрывающее/показывающее группу классов.
//
Процедура ПоказатьГруппуПоискаПоКлассу(Команда)
	
	Элементы.ГруппаКлассификаторУслуг.Видимость = Не Элементы.ГруппаКлассификаторУслуг.Видимость;
	Если Элементы.ГруппаКлассификаторУслуг.Видимость Тогда 
		Элементы.ГруппаДополнительныеКлассификаторы.Видимость = Ложь;
	КонецЕсли;	
	
	Если Не Элементы.ГруппаДополнительныеКлассификаторы.Видимость Тогда 
		ЭлементОтбора = нсиРаботаСФормами.НайтиГруппуОтбораПоПредставлению("По доп. классификатору", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;	
	Если Не Элементы.ГруппаКлассификаторУслуг.Видимость Тогда
		ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению("Класс", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	Элементы.ПоказатьГруппуПоискаПоКлассу.Пометка = не Элементы.ПоказатьГруппуПоискаПоКлассу.Пометка;
	Элементы.ФормаПоказатьГруппуПоискаПоДопКлассу.Пометка = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Дополнительные классификаторы"

&НаКлиенте
// Процедура - событие, скрывающее/показывающее группу доп. классов.
//
Процедура ПоказатьГруппуПоискаПоДопКлассу(Команда)
	
	Элементы.ГруппаДополнительныеКлассификаторы.Видимость = Не Элементы.ГруппаДополнительныеКлассификаторы.Видимость;
	Если Элементы.ГруппаДополнительныеКлассификаторы.Видимость Тогда 
		Элементы.ГруппаКлассификаторУслуг.Видимость = Ложь;
	КонецЕсли;	
	
	Если Не Элементы.ГруппаДополнительныеКлассификаторы.Видимость Тогда 
		ЭлементОтбора = нсиРаботаСФормами.НайтиГруппуОтбораПоПредставлению("По доп. классификатору", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;	
	Если Не Элементы.ГруппаКлассификаторУслуг.Видимость Тогда
		ЭлементОтбора = нсиРаботаСФормами.НайтиЭлементОтбораПоПредставлению("Класс", Список.Отбор.Элементы);
		Если Не ЭлементОтбора = Неопределено Тогда
			ЭлементОтбора.Использование = Ложь;
		КонецЕсли;	
	КонецЕсли;	
	
	Элементы.ФормаПоказатьГруппуПоискаПоДопКлассу.Пометка = не Элементы.ФормаПоказатьГруппуПоискаПоДопКлассу.Пометка;
	Элементы.ПоказатьГруппуПоискаПоКлассу.Пометка = Ложь;
	
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
// ПОДСИСТЕМА "Классификатор услуг"

&НаКлиенте
// Процедура - отбирает загруженные и обработанные записи по классу.
//
Процедура КлассификаторУслугВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ЭлементОтбора = нсиРаботаСФормами.ОтборВСпискеПоЗначению(Список.Отбор.Элементы, 
		"Класс", ВыбраннаяСтрока, ВидСравненияКомпоновкиДанных.ВИерархии, ЗначениеЗаполнено(ВыбраннаяСтрока));
	ЭлементОтбора.Представление = "По основному классификатору";	
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Использование = Истина;
	
	ТекущиеДанные = Элементы.КлассификаторУслуг.ВыделенныеСтроки[0];
	ЗаполнитьДеревоСвойств(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
// Процедура - устанавливает отбор по свойству и его значению.
//
Процедура ДеревоСвойствВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда 
		Возврат;
	КонецЕсли;	
	
	Свойство = Элемент.ТекущиеДанные.ПолучитьРодителя().Значения;
	Значение = Элемент.ТекущиеДанные.Значения;    	
	
	ЭлементОтбора = ЭтаФорма.Список.Отбор.Элементы.Добавить(
		Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ЭлементОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	ЭлементОтбора.Представление = "" + Элемент.ТекущиеДанные.ПолучитьРодителя().СвойствоЗначение + 
		" = " + Элемент.ТекущиеДанные.СвойствоЗначение;
	ЭлементОтбора.Использование = Истина;

	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭлементОтбора.Элементы, 
		"Ссылка.ТехническиеХарактеристики.Характеристика", Свойство);
	нсиРаботаСФормами.ОтборВСпискеПоЗначению(ЭлементОтбора.Элементы, 
		"Ссылка.ТехническиеХарактеристики.Значение", Значение);
		
КонецПроцедуры

&НаКлиенте
// Процедура - присваивает выбранным элементам класс.
//
Процедура КлассификаторУслугПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	нсиСравнениеДанныхСервер.УстановкаКлассаПриПеретаскивании(ПараметрыПеретаскивания.Значение, Строка, ИмяСправочника);
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// ПОДСИСТЕМА "Классификатор услуг"

&НаСервере  
// Процедура - строит дерево свойств и значений по выбранному классу.
//
Процедура ЗаполнитьДеревоСвойств(ТекущиеДанные)
	
	РедактируемоеДеревоСвойств = ДанныеФормыВЗначение(ДеревоСвойств, Тип("ДеревоЗначений"));
	нсиСравнениеДанныхСервер.ЗаполнитьДеревоСвойств(ТекущиеДанные, РедактируемоеДеревоСвойств, ИмяСправочника);
	ЗначениеВДанныеФормы(РедактируемоеДеревоСвойств, ДеревоСвойств);
	
КонецПроцедуры

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

