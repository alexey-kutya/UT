﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработкаКомандыНаСервере(ПараметрКоманды);
	
	Если Не ПараметрыВыполненияКоманды.Источник.Элементы.Найти("СписокЗагруженных") = Неопределено Тогда 
		ПараметрыВыполненияКоманды.Источник.Элементы.СписокЗагруженных.Обновить();
	КонецЕсли;
	Если Не ПараметрыВыполненияКоманды.Источник.Элементы.Найти("СписокБуфера") = Неопределено Тогда 
		ПараметрыВыполненияКоманды.Источник.Элементы.СписокБуфера.Обновить();
	КонецЕсли;
	Если Не ПараметрыВыполненияКоманды.Источник.Элементы.Найти("СписокОбработанных") = Неопределено Тогда 
		ПараметрыВыполненияКоманды.Источник.Элементы.СписокОбработанных.Обновить();
	КонецЕсли;
	
	Оповестить("ИзменениеБуфера",ПараметрКоманды);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработкаКомандыНаСервере(ПараметрКоманды)

	Если Не (ПравоДоступа("Чтение", Метаданные.РегистрыСведений.нсиСтатусыОбработкиСправочников) И ПравоДоступа("Изменение", Метаданные.РегистрыСведений.нсиСтатусыОбработкиСправочников)) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Объект", ПараметрКоманды);
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	нсиСтатусыОбработкиСправочников.Объект
		|ИЗ
		|	РегистрСведений.нсиСтатусыОбработкиСправочников КАК нсиСтатусыОбработкиСправочников
		|ГДЕ
		|	нсиСтатусыОбработкиСправочников.Объект В(&Объект)
		|	И (НЕ(нсиСтатусыОбработкиСправочников.Обработано
		|				ИЛИ нсиСтатусыОбработкиСправочников.Пользователь <> &Пользователь
		|					И нсиСтатусыОбработкиСправочников.ОбработкаНачата))";

	Результат = Запрос.Выполнить();	
	СписокИсключенных = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.нсиСтатусыОбработкиСправочников");
		ЭлементБлокировки.ИсточникДанных = Результат;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Объект","Объект");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();  
		
		Для Каждого ЭлементБуфера из СписокИсключенных Цикл 
			РегистрыСведений.нсиСтатусыОбработкиСправочников.УстановитьСтатусСправочника(ЭлементБуфера,
				Новый Структура("Пользователь,ОбработкаНачата,Обработано", Неопределено, Ложь, Истина) );
		КонецЦикла;	
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

#КонецОбласти
