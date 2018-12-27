﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	СписокСправочников = ВидыУниверсальныхСправочников(ПараметрКоманды);
	Если СписокСправочников.Количество() = 0 тогда
		ПоказатьПредупреждение(, "Не найдено справочников, связанных с текущим классификатором.");	
	ИначеЕсли СписокСправочников.Количество() = 1 тогда
		ОбработкаКомандыЗавершение(СписокСправочников[0].Значение, 
			Новый Структура("ПараметрКоманды, ПараметрыВыполненияКоманды", ПараметрКоманды, ПараметрыВыполненияКоманды))	
	Иначе 	
		СписокСправочников.ПоказатьВыборЭлемента(
			Новый ОписаниеОповещения("ОбработкаКомандыЗавершение", ЭтотОбъект, 
			Новый Структура("ПараметрКоманды, ПараметрыВыполненияКоманды", ПараметрКоманды, ПараметрыВыполненияКоманды)),
			"Выберите универсальный справочник");
	КонецЕсли;
	 
КонецПроцедуры

// Процедура - обработчик закрытия формы выбора вида справочника.
// Параметры:
//	Результат - Неопределено или элемент списка значений;
//	ДополнительныеПараметры - структура со свойствами ПараметрКоманды, ПараметрыВыполненияКоманды.
//
&НаКлиенте
Процедура ОбработкаКомандыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если НЕ Результат = Неопределено тогда
		ПараметрКоманды            = ДополнительныеПараметры.ПараметрКоманды;
		ПараметрыВыполненияКоманды = ДополнительныеПараметры.ПараметрыВыполненияКоманды;
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Владелец", Результат.Значение);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Класс", Класс(ПараметрКоманды));
		ПараметрыФормы.Вставить("Отбор", ПараметрыОтбора);
		
		ОткрытьФорму("Справочник.нсиУниверсальныйФункциональныйСправочник.ФормаСписка", 
			ПараметрыФормы, 
			ПараметрыВыполненияКоманды.Источник, 
			ПараметрыВыполненияКоманды.Уникальность, 
			ПараметрыВыполненияКоманды.Окно);
	КонецЕсли;

КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция Класс(Ссылка)
	
	ЭтоМакет = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "ЭтоМакет");
	
	Если ЭтоМакет тогда
		ИзменяемыйОбъект = РегистрыСведений.нсиСтатусыОбработкиСправочников.ИзменяемыйОбъект(Ссылка);
		Если ЗначениеЗаполнено(ИзменяемыйОбъект) тогда
			Возврат ИзменяемыйОбъект
		КонецЕсли;	
	КонецЕсли;	
	
	Возврат Ссылка
	
КонецФункции	

&НаСервере
Функция ВидыУниверсальныхСправочников(Ссылка)
	
	Классификатор = нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Ссылка, "Владелец");
	
	СписокСправочников = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	нсиВидыСправочников.Ссылка,
		|	нсиВидыСправочников.ПредставлениеОбъекта
		|ИЗ
		|	Справочник.нсиВидыСправочников КАК нсиВидыСправочников
		|ГДЕ
		|	нсиВидыСправочников.Классификатор = &Классификатор";
	
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		пМетаданные = нсиУниверсальноеХранилище.ПолучитьМетаданные(Выборка.Ссылка);
		Если пМетаданные.ПраваДоступа.Просмотр = Истина тогда
			СписокСправочников.Добавить(Выборка.Ссылка, Выборка.ПредставлениеОбъекта);	
		КонецЕсли;	
	КонецЦикла;
	
	Возврат СписокСправочников
	
КонецФункции	

#КонецОбласти