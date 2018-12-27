﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация.
//    УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация", ПоложениеЗаголовкаЭлементаФормы.Лево);
	// КутьяАА ITRR
    УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация");
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация.
	
	// КутьяАА ITRR <<
	НаборЗаписей = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Объект.Ссылка);
	НаборЗаписей.Прочитать();
	
	КонтактнаяИнформацияУПП.Загрузить(НаборЗаписей.Выгрузить());
	
	Для каждого ЭлементКИ Из ЭтотОбъект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов Цикл
		Если ЭлементКИ.Представление = "" Тогда
			Отбор = Новый Структура("Вид", ЭлементКИ.Вид);
			Строки = КонтактнаяИнформацияУПП.НайтиСтроки(Отбор);
			
			Если Строки.Количество() > 0 Тогда
				ДанныеСтрокиУПП = Строки[0];
				Если ЗначениеЗаполнено(ДанныеСтрокиУПП.Представление) Тогда
					ЭтотОбъект[ЭлементКИ.ИмяРеквизита] = ДанныеСтрокиУПП.Представление;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ПолнаяСинхронизацияMDM = Истина;
	КонецЕсли;
	GUID_MDM = Объект.Ссылка.УникальныйИдентификатор();
	//>>
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация.
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация.
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.КонтактнаяИнформация
    УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация.
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// СтандартныеПодсистемы.КонтактнаяИнформация.
    УправлениеКонтактнойИнформацией.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект);
    // Конец СтандартныеПодсистемы.КонтактнаяИнформация.
	
	//КутьяАА ITRR <<
	Для каждого СтрокаКИУПП Из КонтактнаяИнформацияУПП Цикл
		Если НЕ ЗначениеЗаполнено(СтрокаКИУПП.Объект) Тогда
			СтрокаКИУПП.Объект = Объект.Ссылка;
		КонецЕсли; 
	КонецЦикла; 
	
	НаборЗаписейКИ = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	НаборЗаписейКИ.Отбор.Объект.Установить(Объект.Ссылка);
	НаборЗаписейКИ.Загрузить(КонтактнаяИнформацияУПП.Выгрузить());
	НаборЗаписейКИ.Записать(Истина);
	
	УИ = Объект.Ссылка.УникальныйИдентификатор();
	Если НЕ GUID_MDM = УИ Тогда
		GUID_MDM = УИ;
	КонецЕсли; 
	//>>
КонецПроцедуры

// СтандартныеПодсистемы.КонтактнаяИнформация.

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
    УправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация.

// СтандартныеПодсистемы.КонтактнаяИнформация
&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
        УправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
    УправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
    УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	//КутьяАА ITRR <<
	АдресПунктаРазгрузкиВидКИ = Справочники.ВидыКонтактнойИнформации.АдресПунктаРазгрузки;
	АдресДляДекларацийВидКИ = Справочники.ВидыКонтактнойИнформации.АдресДляДеклараций;
	
	МассивСтрок = Этаформа.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("ИмяРеквизита, Вид",Результат.ИмяРеквизита, АдресПунктаРазгрузкиВидКИ));
	Если МассивСтрок.Количество() Тогда
		
		СтрокиАдресПунктаРазгрузкиУПП = КонтактнаяИнформацияУПП.НайтиСтроки(Новый Структура("Вид", АдресПунктаРазгрузкиВидКИ));
		Если СтрокиАдресПунктаРазгрузкиУПП.Количество() Тогда
			СтрокаАдресПунктаРазгрузкиУПП = СтрокиАдресПунктаРазгрузкиУПП[0];
			Объект.АдресДляСопроводительныхДокументов = СтрокаАдресПунктаРазгрузкиУПП.Представление;
			
			АдресУПП = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.ПолучитьАдресУПП(СтрокаАдресПунктаРазгрузкиУПП);
			АдресУПП.АдресУПП_Квартира_Поле9 = "";
			АдресУПП.АдресУПП_ДополнительнаяИнформация_Поле10 = "";
			
			АдресУПП_ПредставлениеДляДекларации = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.ПолучитьПредставлениеАдресаУПП(АдресУПП);
			
			СтрокиАдресДляДекларацийУПП = КонтактнаяИнформацияУПП.НайтиСтроки(Новый Структура("Вид", АдресДляДекларацийВидКИ));
			Если НЕ СтрокиАдресДляДекларацийУПП.Количество() Тогда
				СтрокаАдресДляДекларацийУПП = КонтактнаяИнформацияУПП.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаАдресДляДекларацийУПП, СтрокаАдресПунктаРазгрузкиУПП,,"Вид,Поле9,Поле10,ТипПомещения,Представление");
				СтрокаАдресДляДекларацийУПП.Вид = АдресДляДекларацийВидКИ;
				СтрокаАдресДляДекларацийУПП.Представление = АдресУПП_ПредставлениеДляДекларации;
			КонецЕсли;
			
			СтрокаАдресПунктаРазгрузки = МассивСтрок[0];
			СтрокиАдресДляДеклараций = Этаформа.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Новый Структура("Вид", АдресДляДекларацийВидКИ));
			Если СтрокиАдресДляДеклараций.Количество() 
				И (НЕ ЗначениеЗаполнено(СтрокиАдресДляДеклараций[0].Представление)
				ИЛИ СтрокиАдресДляДеклараций[0].Представление = "Заполнить") Тогда
				СтрокаАдресДляДеклараций = СтрокиАдресДляДеклараций[0];
				ЗаполнитьЗначенияСвойств(СтрокаАдресДляДеклараций, СтрокаАдресПунктаРазгрузки,,"Вид, Тип, ИмяРеквизита,Представление");
				СтрокаАдресДляДеклараций.Представление = АдресУПП_ПредставлениеДляДекларации;
				ЭтаФорма[СтрокаАдресДляДеклараций.ИмяРеквизита] = АдресУПП_ПредставлениеДляДекларации;
			КонецЕсли;
			
		КонецЕсли; 
		
	КонецЕсли; 
	//>>
КонецПроцедуры
// Конец СтандартныеПодсистемы.КонтактнаяИнформация.

//Кутья АА ITRR
&НаКлиенте
Процедура ПроверкаОрфографии(Команда)
	ОткрытьФорму("Обработка.ПроверкаПравописанияЯндексСпеллера.Форма", Новый Структура("ТекстДляПроверки", Объект.АдресДляСопроводительныхДокументов),,,,,Новый ОписаниеОповещения("ОкончаниеПроверкиОрфографии",ЭтаФорма));
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаКлиенте
Процедура ОкончаниеПроверкиОрфографии(Ответ, ДополнительныеПараметры) Экспорт 

	Если НЕ Ответ = Неопределено Тогда
		ОтветТекст = СокрЛП(Ответ.ТекстHTML);
		Если НЕ Объект.АдресДляСопроводительныхДокументов = ОтветТекст Тогда
			Объект.АдресДляСопроводительныхДокументов = ОтветТекст;
			Модифицированность = Истина;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры // ОкончаниеПроверкиОрфографии()
 