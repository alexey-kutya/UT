﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Справочник.нсиКонтрагенты.Форма.ФормаОбработкиИсходныхЗаписей",  
		Новый Структура("РежимРаботы", "Комплексная работа с записями"), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
		
КонецПроцедуры

#КонецОбласти
