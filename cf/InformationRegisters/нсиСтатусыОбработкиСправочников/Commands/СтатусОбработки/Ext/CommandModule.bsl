﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Параметр = Новый Структура("Ключ", ПолучитьКлючЗаписи(ПараметрКоманды));
	ОткрытьФорму("РегистрСведений.нсиСтатусыОбработкиСправочников.ФормаЗаписи",
		Параметр, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьКлючЗаписи(Объект)
	
	НаборЗаписей = РегистрыСведений.нсиСтатусыОбработкиСправочников.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(Объект);
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() = 0 Тогда 
		Запись = НаборЗаписей.Добавить();
		Запись.Объект = Объект;
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
	
	КЗ = РегистрыСведений.нсиСтатусыОбработкиСправочников.СоздатьКлючЗаписи(
		Новый Структура("Объект", Объект));
		
	Возврат КЗ; 
	
КонецФункции

#КонецОбласти
