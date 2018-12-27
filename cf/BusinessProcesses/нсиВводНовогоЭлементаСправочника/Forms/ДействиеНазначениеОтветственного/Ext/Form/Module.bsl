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
	УстановитьСостояниеЭлементов();
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтаФорма, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
		

	ПредметСтрокой = нсиБизнесПроцессы.ПредметСтрокой(Объект.Предмет);	
	нсиРаботаСФормамиСервер.УстановитьТипПредмета(Объект.Предмет, Элементы.ПризнакЭлемента);
	
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
	
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаданиеОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
	ЗаданиеОбъект.ПрохождениеЭтапов.Загрузить(Задание.ПрохождениеЭтапов.Выгрузить());
	ЗаданиеОбъект.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
	
	ВыполнитьЗадачу = Ложь;
	Если НЕ (ПараметрыЗаписи.Свойство("ВыполнитьЗадачу", ВыполнитьЗадачу) И ВыполнитьЗадачу) Тогда
		Возврат;
	КонецЕсли;  		
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗадачаОбъект = ТекущийОбъект;
	ЗаданиеОбъект = ЗадачаОбъект.БизнесПроцесс.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ЗаданиеОбъект.Ссылка);
	ЗаданиеОбъект.Выполнено 		= Задание.Выполнено;
	ЗаданиеОбъект.ОтозватьЗаявку 	= Задание.ОтозватьЗаявку;
	ЗаданиеОбъект.ОтклонитьЗаявку 	= Задание.ОтклонитьЗаявку;
	ЗаданиеОбъект.НадоУточнить 		= Задание.НадоУточнить;
	ЗаданиеОбъект.ЕстьОшибки 		= Задание.ЕстьОшибки;
	ЗаданиеОбъект.Записать();
	ЗначениеВРеквизитФормы(ЗаданиеОбъект, "Задание");
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выполнено(Команда)
	
	Задание.Выполнено 		= Истина;
	Задание.НадоУточнить 	= Ложь;
	Задание.ОтозватьЗаявку 	= Ложь;
	Задание.ОтклонитьЗаявку	= Ложь;
	Задание.ЕстьОшибки	= Ложь;
	Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.Выполнена");
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьЗаявку(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана причина отмены.",, "РезультатВыполнения", "Объект");
		Возврат;
	КонецЕсли;	
	
	Задание.Выполнено 		= Ложь;
	Задание.НадоУточнить 	= Ложь;
	Задание.ОтозватьЗаявку 	= Ложь;
	Задание.ОтклонитьЗаявку = Истина;
	Задание.ЕстьОшибки	= Ложь;
	Объект.Отклонена 		= Истина;
	Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.Отклонена");
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ТребуетсяУточнение(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.РезультатВыполнения) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указано, что требуется уточнить.",,"РезультатВыполнения","Объект");
		Возврат;
	КонецЕсли;	
	
	Задание.Выполнено 		= Ложь;
	Задание.НадоУточнить 	= Истина;
	Задание.ОтозватьЗаявку 	= Ложь;
	Задание.ОтклонитьЗаявку = Ложь;
	Задание.ЕстьОшибки	= Ложь;
	Объект.Результат = ПредопределенноеЗначение("Перечисление.нсиРезультатыВыполненияЗадач.ЗапрошеноУточнение");
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьЗаданиеВыполнить()
	
	ПоказатьЗначение(,Задание.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура АвторНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Автор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы
&НаКлиенте
Процедура ЗаданиеПрохождениеЭтаповПриАктивизацииСтроки(Элемент)
	
	Элементы.ЗаданиеПрохождениеЭтаповИсполнитель.СписокВыбора.ЗагрузитьЗначения(Элементы.ЗаданиеПрохождениеЭтапов.ТекущиеДанные.СписокИсполнителей.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеПрохождениеЭтаповИсполнительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УправлениеВидимостьюИДоступом()
	ТолькоПросмотр = ТолькоПросмотр 
		ИЛИ Объект.Выполнена 
		ИЛИ Объект.Исполнитель <> ПараметрыСеанса.ТекущийПользователь;
		
	Элементы.Выполнено.Доступность = Не ЭтаФорма.ТолькоПросмотр;
	Элементы.ОтклонитьЗаявку.Доступность = Не ЭтаФорма.ТолькоПросмотр;
	Элементы.ТребуетсяУточнение.Доступность = Не ЭтаФорма.ТолькоПросмотр;
	Элементы.ОписаниеРезультата.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	
	БизнесПроцессы.Задание.УстановитьСостояниеЭлементовФормыЗадачи(ЭтаФорма);
	
КонецПроцедуры	

#КонецОбласти
