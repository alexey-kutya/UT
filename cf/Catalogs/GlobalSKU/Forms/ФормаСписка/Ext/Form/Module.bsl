﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяСправочника = "GlobalSKU"; 
	Список.Параметры.УстановитьЗначениеПараметра("СсылкаНеОпределена", 	Истина);
	Список.Параметры.УстановитьЗначениеПараметра("Ссылка", Null);
	//нсиСравнениеДанныхСервер.ЗаполнениеКомпоновщикаНастроек(ИмяСправочника, 
	//	АдресКомпоновки, КомпоновщикНастроек, ЭтаФорма.УникальныйИдентификатор);
	нсиСравнениеДанныхСервер.УстановитьПользователяВПараметрыИОформление(Список);
	
	УстановитьИсполнителейРолиВПараметрыИОформление(Список);
	
КонецПроцедуры

// Процедура - заполняет параметр и оформление пользователем.
//
Процедура УстановитьИсполнителейРолиВПараметрыИОформление(Список) 
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не Список.Параметры.Элементы.Найти("ЭтоИсполнительРоли") = Неопределено Тогда 
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("РольИсполнителя", ПредопределенноеЗначение("Справочник.РолиИсполнителей.GlobalMasterDataManager"));
		Запрос.УстановитьПараметр("Исполнитель", ПараметрыСеанса.ТекущийПользователь);
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ИСТИНА КАК ЭтоИсполнительРоли
			|ИЗ
			|	РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
			|ГДЕ
			|	ИсполнителиЗадач.РольИсполнителя = &РольИсполнителя
			|	И ИсполнителиЗадач.Исполнитель = &Исполнитель";
		
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			ЭтоИсполнительРоли = Ложь;
		Иначе	
			ЭтоИсполнительРоли = Истина;
		КонецЕсли; 
		
		Список.Параметры.УстановитьЗначениеПараметра("ЭтоИсполнительРоли", ЭтоИсполнительРоли);
		
	КонецЕсли;	
	
КонецПроцедуры

#Область ОбработчикиКомандФормы

&НаКлиенте
// Событие - открывает форму ввода нового элемента справочника (заявки).
//
Процедура ВводНовогоЭлементаСправочника(Команда)

	ОткрытьФорму("БизнесПроцесс.нсиВводНовогоЭлементаСправочника.ФормаОбъекта", 
	    Новый Структура("ЗначенияЗаполнения", Новый Структура("ИмяСправочника", ИмяСправочника)) ); 
	
КонецПроцедуры

#КонецОбласти
