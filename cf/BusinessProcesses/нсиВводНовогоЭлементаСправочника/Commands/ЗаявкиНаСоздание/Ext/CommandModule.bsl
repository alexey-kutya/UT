﻿#Область ПрограммныйИнтерфейс

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	 ОткрытьФорму("БизнесПроцесс.нсиВводНовогоЭлементаСправочника.ФормаСписка", 
		 Новый Структура("Предмет", ПараметрКоманды), 
		 ПараметрыВыполненияКоманды.Источник, 
		 ПараметрыВыполненияКоманды.Уникальность, 
		 ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
