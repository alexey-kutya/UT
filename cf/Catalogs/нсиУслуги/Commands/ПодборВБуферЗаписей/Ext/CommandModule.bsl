﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.нсиУслуги.Форма.ФормаОбработкиИсходныхЗаписей", 
		Новый Структура("РежимРаботы", "Подбор в буфер записей"), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти
