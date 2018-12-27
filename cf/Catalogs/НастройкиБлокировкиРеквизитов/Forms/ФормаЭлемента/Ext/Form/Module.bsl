﻿
&НаКлиенте
Процедура ЗаполнитьПоля(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Код) Тогда
		Сообщить("Сначала заполните объект метаданных");
		Возврат;
	КонецЕсли;
	
	СвойстваОбъекта = Новый Структура;
	СвойстваОбъекта.Вставить("СтандартныеРеквизиты", "Стандартный реквизит");
	СвойстваОбъекта.Вставить("Реквизиты", "Реквизит");
	СвойстваОбъекта.Вставить("ТабличныеЧасти", "Табличная часть");
	Для каждого СвойствоОбъекта Из СвойстваОбъекта Цикл
		ЗаполнитьСтрокиНаСервере(СвойствоОбъекта);
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокиНаСервере(СвойствоОбъекта)

	Для каждого Реквизит Из Метаданные.Справочники[Объект.Код][СвойствоОбъекта.Ключ] Цикл
		СтрокаРеквизит = Объект.Реквизиты.Добавить();
		СтрокаРеквизит.ВидПоля = СвойствоОбъекта.Значение;
		СтрокаРеквизит.Поле = Реквизит.Имя;
		СтрокаРеквизит.ПолеПредставление = Реквизит.Синоним;
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСтрокиНаСервере()
 