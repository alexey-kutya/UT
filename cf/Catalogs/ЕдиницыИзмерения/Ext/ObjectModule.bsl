﻿
Процедура ПередЗаписью(Отказ)
	Если ЕдиницаПоКлассификатору = Владелец.БазоваяЕдиницаИзмерения Тогда
		Если Владелец.LocalMaterialType.ГотоваяПродукция Тогда
			Для каждого СтрокаЕдиницы Из ЕдиницыПроизводителей Цикл
				Если НЕ СтрокаЕдиницы.Коэффициент = 1 Тогда
					Отказ = Истина;
					Сообщить("Единица измерения не записана. Для базовой единицы коэффициент должен равняться 1. Строка № "+СтрокаЕдиницы.НомерСтроки, СтатусСообщения.Важное);
				КонецЕсли; 
			КонецЦикла; 
		Иначе	
			Если НЕ Коэффициент = 1 Тогда
				Отказ = Истина;
				Сообщить("Единица измерения не записана. Для базовой единицы коэффициент должен равняться 1.", СтатусСообщения.Важное);
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
КонецПроцедуры
