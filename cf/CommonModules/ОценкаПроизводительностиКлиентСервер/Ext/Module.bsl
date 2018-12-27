﻿////////////////////////////////////////////////////////////////////////////////
//  Методы, позволяющие начать и закончить замер времени выполнения ключевой операции
//  
////////////////////////////////////////////////////////////////////////////////
#Область ПрограммныйИнтерфейс

#Область ПрограммныйИнтерфейсОценкаПроизводительности

// Создает ключевые операции в случае их отсутствия.
//
// Параметры:
//  КлючевыеОперации - Массив ключевых операций
//		КлючеваяОперация - Структура("ИмяКлючевойОперации, ЦелевоеВремя)
//
#Если Сервер Тогда
Процедура СоздатьКлючевыеОперации(КлючевыеОперации) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	КлючевыеОперации.Ссылка КАК Ссылка
	               |ИЗ
	               |	Справочник.КлючевыеОперации КАК КлючевыеОперации
	               |ГДЕ
	               |	КлючевыеОперации.Имя = &Имя
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка";
				   
	Для Каждого КлючеваяОперация Из КлючевыеОперации Цикл
		Запрос.УстановитьПараметр("Имя", КлючеваяОперация.ИмяКлючевойОперации);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			ОценкаПроизводительностиВызовСервераПолныеПрава.СоздатьКлючевуюОперацию(КлючеваяОперация.ИмяКлючевойОперации, КлючеваяОперация.ЦелевоеВремя);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
#КонецЕсли


// Активизирует замер времени выполнения ключевой операции.
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремени>
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания <ЗакончитьЗамерВремениАвто>.
// Возвращает время начала замера
//
// В случае вызова с сервера функция только возвращает время начала
// Закончить замер нужно явно вызовом процедуры
// <ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено)>
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  При вызове с сервера аргумент игнорируется.
//
// Возвращаемое значение:
//  Число - время начала с точностью до миллисекунд.
//
Функция НачатьЗамерВремени(КлючеваяОперация = Неопределено) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
		
	Возврат ВремяНачала;
КонецФункции

// Активизирует замер времени выполнения ключевой операции с произвольным комментарием
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремени>
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания <ЗакончитьЗамерВремениАвто>.
// Возвращает время начала замера
//
// В случае вызова с сервера функция только возвращает время начала
// Закончить замер нужно явно вызовом процедуры
// <ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено)>
//
// Параметры:
// КлючеваяОперация - 	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  					При вызове с сервера аргумент игнорируется
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера
//  					При вызове с сервера аргумент игнорируется
//
// Возвращаемое значение:
//  Число - время начала с точностью до миллисекунд.
//
Функция НачатьЗамерВремениСКомментарием(КлючеваяОперация, Комментарий) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("Комментарий", Комментарий);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
	
	Возврат ВремяНачала;
КонецФункции

#Если Сервер Тогда
// Процедура завершает замер времени ключевой операции на сервере
// и записывает результат на сервере в <РегистрСведений.ЗамерыВремени>
// Вызывается только с сервера
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
// ВремяНачала - 		Число (Формат ТекущаяУниверсальнаяДатаВМиллисекундах()/1000) или Дата начала замера
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера
Процедура ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено) Экспорт
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда	
		ДатаОкончания = ЗначениеТаймера(Ложь);
		ВремяОкончания = ЗначениеТаймера(Истина);
		Если ТипЗнч(ВремяНачала) = Тип("Число") Тогда
			Длительность = (ВремяОкончания - ВремяНачала);
			ДатаНачала = ДатаОкончания - Длительность;
		Иначе
			Длительность = (ДатаОкончания - ВремяНачала);
			ДатаНачала = ВремяНачала;
		КонецЕсли;
		ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьДлительностьКлючевойОперации(
			КлючеваяОперация,
			Длительность,
			ДатаНачала,
			ДатаОкончания,
			Комментарий);
	КонецЕсли;
КонецПроцедуры
#КонецЕсли

#Если Клиент Тогда
// Активизирует замер времени выполнения ключевой операции. Для завершения замера необходимо
// явно вызвать в общем модуле <ОценкаПроизводительностиКлиентГлобальный>
// процедуру <Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера)>, необходимо передать точно такой же
// УИДЗамера, как и в данной функции.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремени>.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
// УИДЗамера -			Тип("УникальныйИдентификатор") - уникальный идентификатор замера
//						должен обеспечивать уникальность замера, например использовать
//						уникальный идентификатор формы.
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
//
Функция НачатьРучнойЗамерВремени(КлючеваяОперация, УИДЗамера = Неопределено, Комментарий = Неопределено) Экспорт
	Если УИДЗамера = Неопределено Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
	КонецЕсли;	
		
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("УИДЗамера", УИДЗамера);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("АвтоЗавершения", Ложь);
	
	НачатьЗамерВремениСлужебный(Параметры);
	
	Возврат УИДЗамера;
КонецФункции
#КонецЕсли

#Если Клиент Тогда
// Процедура завершает ручной замер времени ключевой операции
// Вызывается только на клиенте
//
// Параметры:
// УИДЗамера -	УникальныйИдентификатор
//
Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера) Экспорт
	ОценкаПроизводительностиКлиент.ЗакончитьРучнойЗамерВремениНеГлобальный(УИДЗамера);
КонецПроцедуры
#КонецЕсли

#КонецОбласти

#Область ПрограммныйИнтерфейсОценкаПроизводительностиТехнологическая

// Активизирует замер времени выполнения технологической ключевой операции.
// Может вызываться как с клиента, так и с сервера.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремениТехнологические>
//
// В случае вызова с клиента, заканчивать замер не нужно, время завершения замера зафиксируется
// через глобальный обработчик ожидания <ЗакончитьЗамерВремениАвто>.
// Возвращает время начала
//
// В случае вызова с сервера функция только возвращает время начала
// Закончить замер нужно явно вызовом процедуры <ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено)>
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  При вызове с сервера аргумент игнорируется.
//	Комментарий - 	Строка(256) для записи произвольной информации
//					при выполнении замера
//
// Возвращаемое значение:
//  Дата или число - время начала с точностью до миллисекунд или секунд в зависимости от версии платформы.
//
Функция НачатьЗамерВремениТехнологический(КлючеваяОперация, Комментарий = Неопределено) Экспорт
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("Технологический", Истина);
	
	ВремяНачала = НачатьЗамерВремениСлужебный(Параметры);
		
	Возврат ВремяНачала;
КонецФункции

#Если Сервер Тогда
// Процедура завершает замер времени технологической ключевой операции на сервере
// и записывает результат на сервере в <РегистрСведений.ЗамерыВремениТехнологические>
// Вызывается только с сервера
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
// ВремяНачала - 		Число (Формат ТекущаяУниверсальнаяДатаВМиллисекундах()/1000) или Дата начала замера
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера
Процедура ЗакончитьЗамерВремениТехнологический(КлючеваяОперация, ВремяНачала, Комментарий = Неопределено) Экспорт
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда	
		ДатаОкончания = ЗначениеТаймера(Ложь);
		ВремяОкончания = ЗначениеТаймера(Истина);
		Если ТипЗнч(ВремяНачала) = Тип("Число") Тогда
			Длительность = (ВремяОкончания - ВремяНачала);
			ДатаНачала = ДатаОкончания - Длительность;
		Иначе
			Длительность = (ДатаОкончания - ВремяНачала);
			ДатаНачала = ВремяНачала;
		КонецЕсли;
		ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьДлительностьКлючевойОперации(
			КлючеваяОперация,
			Длительность,
			ДатаНачала,
			ДатаОкончания,
			Комментарий,
			Истина);
	КонецЕсли;
КонецПроцедуры
#КонецЕсли

// Активизирует замер времени выполнения технологической ключевой операции с явным завершением времени
// длительности ключевой операции. Вызывается только с клиента.
// Для завершения замера необходимо вызвать в общем модуле <ОценкаПроизводительностиКлиентГлобальный>
// процедуру <Процедура ЗакончитьРучнойЗамерВремени(УИДЗамера)>, необходимо передать точно такой же
// УИДЗамера, как и в данную процедуру.
// Результат замера будет записан в <РегистрСведений.ЗамерыВремениТехнологические>.
//
// Параметры:
// КлючеваяОперация -	СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
// УИДЗамера -			Тип("УникальныйИдентификатор") - уникальный идентификатор замера
//						должен обеспечивать уникальность замера, например использовать
//						уникальный идентификатор формы.
// Комментарий - 		Строка(256) для записи произвольной информации
//						при выполнении замера.
//
#Если Клиент Тогда
Функция НачатьРучнойЗамерВремениТехнологический(КлючеваяОперация, УИДЗамера = Неопределено, Комментарий = Неопределено) Экспорт
	Если УИДЗамера = Неопределено Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
	КонецЕсли;
		
	Параметры = Новый Структура;
	Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
	Параметры.Вставить("УИДЗамера", УИДЗамера);
	Параметры.Вставить("Комментарий", Комментарий);
	Параметры.Вставить("АвтоЗавершения", Ложь);
	Параметры.Вставить("Технологический", Истина);
	
	НачатьЗамерВремениСлужебный(Параметры);
КонецФункции
#КонецЕсли

#Если Клиент Тогда
Процедура ЗакончитьРучнойЗамерВремениТехнологический(УИДЗамера) Экспорт
	ОценкаПроизводительностиКлиент.ЗакончитьРучнойЗамерВремениНеГлобальный(УИДЗамера);
КонецПроцедуры
#КонецЕсли

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачатьЗамерВремениСлужебный(Параметры)
	Если Параметры.Свойство("КлючеваяОперация") Тогда
		КлючеваяОперация = Параметры.КлючеваяОперация;
	Иначе
		КлючеваяОперация = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("УИДЗамера") И Параметры.УИДЗамера <> Неопределено Тогда
		УИДЗамера = Параметры.УИДЗамера;
	Иначе
		УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	КонецЕсли;
	
	Если Параметры.Свойство("Комментарий") Тогда
		Комментарий = Параметры.Комментарий;
	Иначе
		Комментарий = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("АвтоЗавершение") И Параметры.АвтоЗавершение <> Неопределено Тогда
		АвтоЗавершение = Параметры.АвтоЗавершение;
	Иначе
		АвтоЗавершение = Истина;
	КонецЕсли;
	
	Если Параметры.Свойство("Технологический") Тогда
		Технологический = Параметры.Технологический;
	Иначе
		Технологический = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(УИДЗамера) <> Тип("УникальныйИдентификатор") Тогда
		ВызватьИсключение НСтр("ru = 'Не верный тип УИДа замера.'");
	КонецЕсли;
	
	ВремяНачала = 0;
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ДатаНачала = ЗначениеТаймера(Ложь);
		ВремяНачала = ЗначениеТаймера();
		
		#Если Клиент И ТолстыйКлиентУправляемоеПриложение И Сервер Тогда
			Если Не ЗначениеЗаполнено(КлючеваяОперация) Тогда
				// Считаем, что вызов пришел с сервера. Возвращаем начало замера
				Возврат ВремяНачала;
			КонецЕсли;
		#КонецЕсли
		
		#Если Клиент Тогда
			Если Не ЗначениеЗаполнено(КлючеваяОперация) Тогда
				ВызватьИсключение НСтр("ru = 'Не указана ключевая операция.'");
			КонецЕсли;
			
			ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
			Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
				ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
				ПараметрыПриложения[ИмяПараметра].Вставить("Замеры", Новый Соответствие);
				
				ТекущийПериодЗаписи = ОценкаПроизводительностиВызовСервераПолныеПрава.ПериодЗаписи();
				ПараметрыПриложения[ИмяПараметра].Вставить("ПериодЗаписи", ТекущийПериодЗаписи);
				
				ДатаИВремяНаСервере = ОценкаПроизводительностиВызовСервераПолныеПрава.ДатаИВремяНаСервере();
				ДатаИВремяНаКлиенте = ТекущаяДата();
				ПараметрыПриложения[ИмяПараметра].Вставить(
				"СмещениеДатыКлиента",
				ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
				
				ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", ТекущийПериодЗаписи, Истина);
			КонецЕсли;
			Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"]; 
			
			БуферКлючевойОперации = Замеры.Получить(КлючеваяОперация);
			Если БуферКлючевойОперации = Неопределено Тогда
				БуферКлючевойОперации = Новый Соответствие;
				Замеры.Вставить(КлючеваяОперация, БуферКлючевойОперации);
			КонецЕсли;
			
			СмещениеДатыКлиента = ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
			ДатаНачала = ДатаНачала + СмещениеДатыКлиента;
			НачатыйЗамер = БуферКлючевойОперации.Получить(ДатаНачала);
			Если НачатыйЗамер = Неопределено Тогда
				БуферЗамера = Новый Соответствие;
				БуферЗамера.Вставить("УИДЗамера", УИДЗамера);
				БуферЗамера.Вставить("ДатаНачала", ДатаНачала);
				БуферЗамера.Вставить("ВремяНачала", ВремяНачала);
				БуферЗамера.Вставить("Комментарий", Комментарий);
				БуферЗамера.Вставить("Технологический", Технологический);
				БуферКлючевойОперации.Вставить(Новый УникальныйИдентификатор(), БуферЗамера);
			КонецЕсли;
			
			Если АвтоЗавершение Тогда
				ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
			КонецЕсли;
		#КонецЕсли
	КонецЕсли;
	
	Возврат ВремяНачала;
	
КонецФункции

// Возвращаемое значение:
// Дата - время начала замера
//
Функция ЗначениеТаймера(ВысокаяТочность = Истина) Экспорт
	Возврат ТекущаяУниверсальнаяДатаВМиллисекундах() / 1000.0;
КонецФункции

// Получает имя дополнительного свойства не проверять приоритеты при записи ключевой операции
//
// Возвращаемое значение:
//  Строка - имя дополнительного свойства
//
Функция НеПроверятьПриоритет() Экспорт
	
	Возврат "НеПроверятьПриоритет";
	
КонецФункции

#Если Сервер Тогда
// Процедура записывает данные в журнал регистрации
//
// Параметры:
//  ИмяСобытия - Строка
//  Уровень - УровеньЖурналаРегистрации
//  ТекстСообщения - Строка
//
Процедура ЗаписатьВЖурналРегистрации(ИмяСобытия, Уровень, ТекстСообщения) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		Уровень,
		,
		НСтр("ru = 'Оценка производительности'"),
		ТекстСообщения);
	
КонецПроцедуры
#КонецЕсли

// Ключ параметра регламентного задания, соответствующий локальному каталогу экспорта
//
Функция ЛокальныйКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "ЛокальныйКаталогЭкспорта";
	
КонецФункции

// Ключ параметра регламентного задания, соответствующий ftp каталогу экспорта
//
Функция FTPКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "FTPКаталогЭкспорта";
	
КонецФункции

#КонецОбласти