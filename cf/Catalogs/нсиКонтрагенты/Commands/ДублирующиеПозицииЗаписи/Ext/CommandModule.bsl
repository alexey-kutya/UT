﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ЭталоннаяПозиция", ПараметрКоманды);
	Форма = ПолучитьФорму("Справочник.нсиКонтрагенты.ФормаСписка", 
		Новый Структура("Отбор", ПараметрыФормы), 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
		
	Форма.Элементы.Список.Отображение = ОтображениеТаблицы.Список;	
	Форма.Открыть();
		
КонецПроцедуры

#КонецОбласти
