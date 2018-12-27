﻿&НаСервере
Процедура ПролонгироватьНаСервере(НачалоЭтогоДня)
	
	АктуальнаяТаблицаДоговоров = ПолучитьТаблицуДоговоровНаСервере(НачалоЭтогоДня);
	
	ДоговорыТаблицаЗначение = РеквизитФормыВЗначение("ДоговорыТаблица");
	Для каждого СтрокаДоговора Из ДоговорыТаблицаЗначение Цикл
		
		Если НЕ ЗначениеЗаполнено(СтрокаДоговора.ДатаОкончанияНовая) Тогда
			Сообщить("По договору '"+СтрокаДоговора.Договор+"', код '"+СтрокаДоговора.Договор.Код+"' указана пустая дата окончания действия. Дата окончания действия не установлена!", СтатусСообщения.Внимание);
			Продолжить;
		КонецЕсли;
		
		Отбор = Новый Структура();
		Отбор.Вставить("Договор", СтрокаДоговора.Договор);
		Отбор.Вставить("ДатаОкончанияДействия", СтрокаДоговора.ДатаОкончанияДействия);
		
		СтрокиСовпаденияДоговоров = АктуальнаяТаблицаДоговоров.НайтиСтроки(Отбор);
		
		Если СтрокиСовпаденияДоговоров.Количество() Тогда
			ДоговорОбъект = СтрокаДоговора.Договор.ПолучитьОбъект();
			ДоговорОбъект.ДатаОкончанияДействия = СтрокаДоговора.ДатаОкончанияНовая;
			Попытка
				ДоговорОбъект.Записать();
				Сообщить("Для договора '"+СтрокаДоговора.Договор+"', код '"+СтрокаДоговора.Договор.Код+"' установлена дата окончания действия - "+Формат(СтрокаДоговора.ДатаОкончанияНовая, "ДФ=dd.MM.yyyy"));
				Если РегистрацияИзменений Тогда
					ПланыОбмена.Обмен_МДМ_УПП.ВыполнитьРегистрациюДляУПП(СтрокаДоговора.Договор);
				КонецЕсли; 
			Исключение
				Сообщить(ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
			КонецПопытки;
		Иначе
			Сообщить("С момента последнего обновления таблицы по договору '"+СтрокаДоговора.Договор+"', код '"+СтрокаДоговора.Договор.Код+"' была установлена дата окончания действия "+Формат(СтрокаДоговора.Договор.ДатаОкончанияДействия, "ДФ=dd.MM.yyyy")+". Дата окончания действия "+Формат(СтрокаДоговора.ДатаОкончанияНовая, "ДФ=dd.MM.yyyy")+" не установлена!", СтатусСообщения.Внимание);
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура Пролонгировать(Команда)
	
	ПролонгироватьНаСервере(НачалоДня(ТекущаяДата()));
	ОбновитьНаСервере(НачалоДня(ТекущаяДата()));
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицуДоговоровНаСервере(НачалоЭтогоДня)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Ссылка КАК Договор,
		|	ВЫБОР
		|		КОГДА ДоговорыКонтрагентов.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|		ИНАЧЕ ДОБАВИТЬКДАТЕ(ДоговорыКонтрагентов.ДатаОкончанияДействия, ДЕНЬ, 365)
		|	КОНЕЦ КАК ДатаОкончанияНовая,
		|	ДоговорыКонтрагентов.ДатаОкончанияДействия
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Бессрочный = ИСТИНА
		|	И ДоговорыКонтрагентов.ДатаОкончанияДействия < &ТекущаяДата";
	
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоЭтогоДня);
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ПолучитьТаблицуДоговоровНаСервере()
 
&НаСервере
Процедура ОбновитьНаСервере(НачалоЭтогоДня)
	
	ЗначениеВРеквизитФормы(ПолучитьТаблицуДоговоровНаСервере(НачалоЭтогоДня),"ДоговорыТаблица");
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере(НачалоДня(ТекущаяДата()));
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорыТаблицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ Поле.Имя = "ДоговорыТаблицаДатаОкончанияНовая" Тогда
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта",Новый Структура("Ключ", ДоговорыТаблица[ВыбраннаяСтрока].Договор),ЭтаФорма,ЭтаФорма.УникальныйИдентификатор);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РегистрацияИзменений = Истина;
	ОбновитьНаСервере(НачалоДня(ТекущаяДата()));
	
КонецПроцедуры
