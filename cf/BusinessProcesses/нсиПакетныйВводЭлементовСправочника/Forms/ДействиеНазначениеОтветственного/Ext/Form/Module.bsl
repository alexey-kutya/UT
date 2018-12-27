﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальныйПризнакВыполнения = Объект.Выполнена;
	ЗадачаОбъект = РеквизитФормыВЗначение("Объект");
	Если Не ЗначениеЗаполнено(ЗадачаОбъект.БизнесПроцесс) Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");	
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
		
	СтатусОтозвано = Перечисления.нсиСтатусыОбработкиЗаявок.Отозвано;
		
	УправлениеВидимостьюИДоступом();
	
	нсиРаботаСФормамиСервер.ВывестиСообщениеПриОткрытииФормыЗадачи(ЭтаФорма);
	
	АвторСтрокой = Строка(Объект.Автор) + " ("+Строка(Задание.ГруппаПользователейБП)+")";
	
	Для Каждого Этап Из Задание.ПрохождениеЭтапов Цикл
		
		МассивЭкспертов = нсиБизнесПроцессы.ПолучитьВозможныхИсполнителейЗадач();
		ВозможныеИсполнители = нсиБизнесПроцессы.ПолучитьВозможныхИсполнителей(
																Этап.СпособРаспределения,
																Этап.РольИсполнителя,
																Задание.ГруппаПользователейБП
																				);
		
		Сч = ВозможныеИсполнители.Количество()-1;
		Пока Сч>=0 Цикл
			Если МассивЭкспертов.Найти(ВозможныеИсполнители[Сч]) = Неопределено Тогда 
				ВозможныеИсполнители.Удалить(Сч);
			КонецЕсли;
			Сч=Сч-1;
		КонецЦикла;
	
		Для Каждого возможныйИсполнитель Из ВозможныеИсполнители Цикл
			Этап.СписокИсполнителей.Добавить(возможныйИсполнитель);
		КонецЦикла;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СохранитьЗадание();	
	
	ВыполнитьЗадачу = Ложь;
	Если НЕ (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;  		
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗадачаОбъект = ТекущийОбъект;
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
	ЗаданиеОбъект.Выполнено 		= Задание.Выполнено;
	ЗаданиеОбъект.Предметы.Загрузить(Задание.Предметы.Выгрузить()); 
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АвторНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Автор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗаданиеПредметы

&НаКлиенте
Процедура ЗаданиеПредметыСтатусПриИзменении(Элемент)
	ТД = Элементы.ЗаданиеПредметы.ТекущиеДанные;
	Если НадоОчиститьКомментарий(Задание.Ссылка,ТД.Предмет,ТД.Статус) Тогда 
		ТД.Комментарий = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПредметыПриАктивизацииСтроки(Элемент)
	Элементы.ЗаданиеПредметыСтатус.ТолькоПросмотр = 
		Элементы.ЗаданиеПредметы.ТекущиеДанные.Статус = СтатусОтозвано;
		
	Элементы.ЗаданиеПредметыКомментарий.ТолькоПросмотр = Элементы.ЗаданиеПредметыСтатус.ТолькоПросмотр;
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПрохождениеЭтаповПриАктивизацииСтроки(Элемент)
	
	Элементы.ЗаданиеПрохождениеЭтаповИсполнитель.СписокВыбора.ЗагрузитьЗначения(Элементы.ЗаданиеПрохождениеЭтапов.ТекущиеДанные.СписокИсполнителей.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПрохождениеЭтаповИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПредметыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не Поле.Имя = "ЗаданиеПредметыПредмет" Тогда 
		Возврат;
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(,Элемент.ТекущиеДанные.Предмет);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выполнено(Команда)
	
	Если нсиРаботаСФормами.НеЗаполненыРезультатИКомментарии(ЭтаФорма) Тогда 
		Возврат;
	КонецЕсли;
	
	Задание.Выполнено 		= Истина;
	
	Отклонено = Задание.Предметы.НайтиСтроки(новый Структура("Статус",ПредопределенноеЗначение("Перечисление.нсиСтатусыОбработкиЗаявок.Отклонено"))).Количество() = Задание.Предметы.Количество();
	НадоУточнить = Задание.Предметы.НайтиСтроки(новый Структура("Статус",ПредопределенноеЗначение("Перечисление.нсиСтатусыОбработкиЗаявок.НадоУточнить"))).Количество() <> 0;
	
	Если НадоУточнить Тогда 
		Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.ЗапрошеноУточнение");
	ИначеЕсли Отклонено Тогда 
		Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.Отклонена");
	Иначе
		Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.Выполнена");
	КонецЕсли;
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюИДоступом()
	пТолькоПросмотр = Объект.Выполнена ИЛИ Объект.Исполнитель<>ПараметрыСеанса.ТекущийПользователь;
	
	Элементы.Выполнено.Доступность = Не пТолькоПросмотр;
	Элементы.ОписаниеРезультата.ТолькоПросмотр = пТолькоПросмотр;
	Элементы.ЗаписатьИЗакрыть.Доступность = НЕ пТолькоПросмотр;
	Элементы.Записать.Доступность = НЕ пТолькоПросмотр;
	Элементы.ЗаданиеПредметыСтатус.Доступность = НЕ пТолькоПросмотр;
	Элементы.ЗаданиеПредметыКомментарий.Доступность = НЕ пТолькоПросмотр;
	
	Если Элементы.Найти("ЗадачаЗадачаИсполнителяПеренаправить")<>Неопределено Тогда 
		Элементы.ЗадачаЗадачаИсполнителяПеренаправить.Доступность =  НЕ пТолькоПросмотр ИЛИ РольДоступна("ПолныеПрава");
	КонецЕсли;
	
	Если Элементы.Найти("ЗадачаЗадачаИсполнителяПеренаправитьСтаршемуЭксперту")<>Неопределено Тогда 
		Элементы.ЗадачаЗадачаИсполнителяПеренаправитьСтаршемуЭксперту.Доступность =  НЕ пТолькоПросмотр;
	КонецЕсли;
	
	Если Элементы.Найти("ЗадачаЗадачаИсполнителяВзятьВОбработку")<>Неопределено Тогда 
		Элементы.ЗадачаЗадачаИсполнителяВзятьВОбработку.Доступность =  НЕ Объект.Выполнена;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция НадоОчиститьКомментарий(Задание,Предмет,Статус)
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	нсиПакетныйВводЭлементовСправочникаПредметы.Статус
		|ИЗ
		|	БизнесПроцесс.нсиПакетныйВводЭлементовСправочника.Предметы КАК нсиПакетныйВводЭлементовСправочникаПредметы
		|ГДЕ
		|	нсиПакетныйВводЭлементовСправочникаПредметы.Ссылка = &Ссылка
		|	И нсиПакетныйВводЭлементовСправочникаПредметы.Предмет = &Предмет"
	);
	Запрос.УстановитьПараметр("Ссылка",Задание);
	Запрос.УстановитьПараметр("Предмет",Предмет);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат 
			Выборка.Статус <> Перечисления.нсиСтатусыОбработкиЗаявок.НадоУточнить
			И Выборка.Статус <> Перечисления.нсиСтатусыОбработкиЗаявок.Отклонено
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

&НаСервере
Процедура СохранитьЗадание()
	УстановитьПривилегированныйРежим(Истина);
	ЗаблокироватьДанныеДляРедактирования(Задание.Ссылка);
	ЗаданиеОбъект = РеквизитФормыВЗначение("Задание");
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект,"Задание");
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

#КонецОбласти
