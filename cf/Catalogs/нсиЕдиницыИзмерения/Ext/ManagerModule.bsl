﻿
#Область ПрограммныйИнтерфейс

// Получает единицу измерения, если единица измерения одна в справочнике.
//
// Возвращаемое значение:
// СправочникСсылка.ЕдиницыИзмерения - Найденная единица измерения;
// Неопределено - если единиц измерения нет или единиц измерения больше одной.
//
Функция ПолучитьЕдиницуИзмеренияПоУмолчанию() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 2
	                      |	ЕдиницыИзмерения.Ссылка КАК ЕдиницаИзмерения
	                      |ИЗ
	                      |	Справочник.нсиЕдиницыИзмерения КАК ЕдиницыИзмерения
	                      |ГДЕ
	                      |	НЕ ЕдиницыИзмерения.ПометкаУдаления");
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ЕдиницаИзмерения = Выборка.ЕдиницаИзмерения;
	Иначе
		ЕдиницаИзмерения = Неопределено;
	КонецЕсли;
	
	Возврат ЕдиницаИзмерения;

КонецФункции // ЕдиницаИзмерения()

#КонецОбласти
