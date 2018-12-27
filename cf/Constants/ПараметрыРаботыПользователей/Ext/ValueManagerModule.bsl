﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Процедура обновляет общие параметры работы пользователей при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьОбщиеПараметры(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	НазначениеРолей = НазначениеРолей();
	ПроверитьНазначениеРолей(НазначениеРолей);
	
	ВсеРоли = ВсеРоли();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыРаботыПользователей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
			"ПараметрыРаботыПользователей");
		
		// Проверка и обновление параметра НазначениеРолей.
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("НазначениеРолей") Тогда
			Сохраненные = Параметры.НазначениеРолей;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(НазначениеРолей, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыРаботыПользователей", "НазначениеРолей", НазначениеРолей);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыРаботыПользователей", "НазначениеРолей");
		
		// Проверка и обновление параметра ВсеРоли.
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ВсеРоли") Тогда
			Сохраненные = Параметры.ВсеРоли;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(ВсеРоли, Сохраненные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыРаботыПользователей",
				"ВсеРоли",
				ВсеРоли);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыРаботыПользователей", "ВсеРоли");
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет корректность заполнения назначения ролей, а также корректность прав в ролях по назначению.
Процедура ПроверитьНазначениеРолей(НазначениеРолей = Неопределено, ПроверитьВсе = Ложь) Экспорт
	
	Если НазначениеРолей = Неопределено Тогда
		НазначениеРолей = НазначениеРолей();
	КонецЕсли;
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ПриОпределенииНазначенияРолей общего модуля ПользователиПереопределяемый.'");
	
	ТекстОшибки = "";
	
	Назначение = Новый Структура;
	Для Каждого ОписаниеНазначенияРолей Из НазначениеРолей Цикл
		Роли = Новый Соответствие;
		Для Каждого КлючИЗначение Из ОписаниеНазначенияРолей.Значение Цикл
			Роль = Метаданные.Роли.Найти(КлючИЗначение.Ключ);
			Если Роль = Неопределено Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В метаданных не найдена роль ""%1"",
					           |указанная в назначении %2.'"),
					Роль.Имя, ОписаниеНазначенияРолей.Ключ);
				Продолжить;
			КонецЕсли;
			Роли.Вставить(Роль, Истина);
			Для Каждого ОписаниеНазначения Из Назначение Цикл
				Если ОписаниеНазначения.Значение.Получить(Роль) = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				ТекстОшибки = ТекстОшибки + Символы.ПС + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Роль ""%1"" указанна более чем в одном назначении:
					           |%2, %3.'"),
					Роль.Имя, ОписаниеНазначенияРолей.Ключ, ОписаниеНазначения.Ключ);
			КонецЦикла;
		КонецЦикла;
		Назначение.Вставить(ОписаниеНазначенияРолей.Ключ, Роли);
	КонецЦикла;
	
	// Проверка ролей внешних пользователей.
	НедоступныеПрава = Новый Массив;
	НедоступныеПрава.Добавить("Администрирование");
	НедоступныеПрава.Добавить("АдминистрированиеРасширенийКонфигурации");
	НедоступныеПрава.Добавить("ОбновлениеКонфигурацииБазыДанных");
	НедоступныеПрава.Добавить("АдминистрированиеДанных");
	
	ПроверитьСоставПравРолей(НедоступныеПрава, Назначение.ТолькоДляВнешнихПользователей, ТекстОшибки,
		НСтр("ru = 'При проверке ролей только для внешних пользователей найдены ошибки:'"));
	
	ПроверитьСоставПравРолей(НедоступныеПрава, Назначение.СовместноДляПользователейИВнешнихПользователей, ТекстОшибки,
		НСтр("ru = 'При проверке ролей совместно для пользователей и внешних пользователей найдены ошибки:'"));
	
	// Проверка ролей пользователей.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Или ПроверитьВсе Тогда
		Роли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			Если Назначение.ТолькоДляАдминистраторовСистемы.Получить(Роль) <> Неопределено
			 Или Назначение.ТолькоДляПользователейСистемы.Получить(Роль) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роли.Вставить(Роль, Истина);
		КонецЦикла;
		НедоступныеПрава = Новый Массив;
		НедоступныеПрава.Добавить("Администрирование");
		НедоступныеПрава.Добавить("АдминистрированиеРасширенийКонфигурации");
		НедоступныеПрава.Добавить("ОбновлениеКонфигурацииБазыДанных");
		НедоступныеПрава.Добавить("ТолстыйКлиент");
		НедоступныеПрава.Добавить("ВнешнееСоединение");
		НедоступныеПрава.Добавить("Automation");
		НедоступныеПрава.Добавить("ИнтерактивноеОткрытиеВнешнихОбработок");
		НедоступныеПрава.Добавить("ИнтерактивноеОткрытиеВнешнихОтчетов");
		НедоступныеПрава.Добавить("РежимВсеФункции");
		
		НеразделенныеДанные = НеразделенныеДанные();
		ПроверитьСоставПравРолей(НедоступныеПрава, Роли, ТекстОшибки,
			НСтр("ru = 'При проверке ролей для пользователей приложения найдены ошибки:'"), НеразделенныеДанные);
	КонецЕсли;
	Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Или ПроверитьВсе Тогда
		Роли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			Если Назначение.ТолькоДляАдминистраторовСистемы.Получить(Роль) <> Неопределено
			 Или Назначение.ТолькоДляВнешнихПользователей.Получить(Роль) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роли.Вставить(Роль, Истина);
		КонецЦикла;
		НедоступныеПрава = Новый Массив;
		НедоступныеПрава.Добавить("Администрирование");
		НедоступныеПрава.Добавить("АдминистрированиеРасширенийКонфигурации");
		НедоступныеПрава.Добавить("ОбновлениеКонфигурацииБазыДанных");
		
		ПроверитьСоставПравРолей(НедоступныеПрава, Роли, ТекстОшибки,
			НСтр("ru = 'При проверке ролей для пользователей найдены ошибки:'"));
		
		ПроверитьСоставПравРолей(НедоступныеПрава, Назначение.СовместноДляПользователейИВнешнихПользователей, ТекстОшибки,
			НСтр("ru = 'При проверке ролей совместно для пользователей и внешних пользователей найдены ошибки:'"));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение ЗаголовокОшибки + ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает назначение ролей, определенное разработчиком.
// См. комментарий к процедуре ПриОпределенииНазначенияРолей общего модуля ПользователиПереопределяемый.
//
// Возвращаемое значение:
//  ФиксированнаяСтруктура - со свойствами:
//   * ТолькоДляАдминистраторовСистемы - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * ТолькоДляПользователейСистемы - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * ТолькоДляВнешнихПользователей - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//   * СовместноДляПользователейИВнешнихПользователей - ФиксированноеСоответствие - со свойствами:
//      * Ключ     - Строка - имя роли.
//      * Значение - Булево - Истина.
//
Функция НазначениеРолей() Экспорт
	
	НазначениеРолей = Новый Структура;
	НазначениеРолей.Вставить("ТолькоДляАдминистраторовСистемы",                Новый Массив);
	НазначениеРолей.Вставить("ТолькоДляПользователейСистемы",                  Новый Массив);
	НазначениеРолей.Вставить("ТолькоДляВнешнихПользователей",                  Новый Массив);
	НазначениеРолей.Вставить("СовместноДляПользователейИВнешнихПользователей", Новый Массив);
	
	ПользователиПереопределяемый.ПриОпределенииНазначенияРолей(НазначениеРолей);
	ИнтеграцияСтандартныхПодсистем.ПриОпределенииНазначенияРолей(НазначениеРолей);
	
	Назначение = Новый Структура;
	Для Каждого ОписаниеНазначенияРолей Из НазначениеРолей Цикл
		Имена = Новый Соответствие;
		Для Каждого Имя Из ОписаниеНазначенияРолей.Значение Цикл
			Имена.Вставить(Имя, Истина);
		КонецЦикла;
		Назначение.Вставить(ОписаниеНазначенияРолей.Ключ, Новый ФиксированноеСоответствие(Имена));
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(Назначение);
	
КонецФункции

Процедура ПроверитьСоставПравРолей(НедоступныеПрава, ОписаниеРолей, ОбщийТекстОшибки, ЗаголовокОшибки, НеразделенныеДанные = Неопределено)
	
	ТекстОшибки = "";
	
	Для Каждого ОписаниеРоли Из ОписаниеРолей Цикл
		Роль = ОписаниеРоли.Ключ;
		Для Каждого НедоступноеПраво Из НедоступныеПрава Цикл
			Если ПравоДоступа(НедоступноеПраво, Метаданные, Роль) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Роль ""%1"" содержит недоступное право %2.'"),
					Роль, НедоступноеПраво);
			КонецЕсли;
		КонецЦикла;
		Если НеразделенныеДанные = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Для Каждого СвойстваДанных Из НеразделенныеДанные Цикл
			ОбъектМетаданных = СвойстваДанных.Значение;
			Если Не ПравоДоступа("Чтение", ОбъектМетаданных, Роль) Тогда
				Продолжить;
			КонецЕсли;
			Если ПравоДоступа("Изменение", ОбъектМетаданных, Роль) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Роль ""%1"" содержит право Изменение неразделенного объекта %2.'"),
					Роль, ОбъектМетаданных.ПолноеИмя());
			КонецЕсли;
			Если СвойстваДанных.Представление = "" Тогда
				Продолжить; // Не ссылочный объект метаданных.
			КонецЕсли;
			Если ПравоДоступа("Добавление", ОбъектМетаданных, Роль) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Роль ""%1"" содержит право Добавление неразделенного объекта %2.'"),
					Роль, ОбъектМетаданных.ПолноеИмя());
			КонецЕсли;
			Если ПравоДоступа("Удаление", ОбъектМетаданных, Роль) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Роль ""%1"" содержит право Удаление неразделенного объекта %2.'"),
					Роль, ОбъектМетаданных.ПолноеИмя());
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщийТекстОшибки = ОбщийТекстОшибки + Символы.ПС + Символы.ПС
			+ ЗаголовокОшибки + ТекстОшибки;
	КонецЕсли;
	
КонецПроцедуры

Функция НеразделенныеДанные()
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.БазоваяФункциональностьВМоделиСервиса") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Список = Новый СписокЗначений;
	
	ВидыМетаданных = Новый Массив;
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыОбмена,             Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Константы,               Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Справочники,             Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Последовательности,      Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Документы,               Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовХарактеристик, Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыСчетов,             Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.ПланыВидовРасчета,       Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.БизнесПроцессы,          Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.Задачи,                  Истина));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыСведений,        Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыНакопления,      Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыБухгалтерии,     Ложь));
	ВидыМетаданных.Добавить(Новый Структура("Вид, Ссылочный" , Метаданные.РегистрыРасчета,         Ложь));
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРаботаВМоделиСервисаПовтИсп = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервисаПовтИсп");
	МодельДанных = МодульРаботаВМоделиСервисаПовтИсп.ПолучитьМодельДанныхОбласти();
	
	РазделенныеОбъектыМетаданных = Новый Соответствие;
	Для Каждого ЭлементМоделиДанных Из МодельДанных Цикл
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ЭлементМоделиДанных.Ключ);
		РазделенныеОбъектыМетаданных.Вставить(ОбъектМетаданных, Истина);
	КонецЦикла;
	
	Для Каждого ОписаниеВида Из ВидыМетаданных Цикл // По видам метаданных.
		Для Каждого ОбъектМетаданных Из ОписаниеВида.Вид Цикл // По объектам вида.
			
			Если РазделенныеОбъектыМетаданных.Получить(ОбъектМетаданных) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Список.Добавить(ОбъектМетаданных, ?(ОписаниеВида.Ссылочный, "Ссылочный", ""));
		КонецЦикла;
	КонецЦикла;
	
	Возврат Список;
	
КонецФункции

Функция ВсеРоли()
	
	Массив = Новый Массив;
	Соответствие = Новый Соответствие;
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));
	
	Для каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;
		
		Массив.Добавить(ИмяРоли);
		Соответствие.Вставить(ИмяРоли, Роль.Синоним);
		Таблица.Добавить().Имя = ИмяРоли;
	КонецЦикла;
	
	ВсеРоли = Новый Структура;
	ВсеРоли.Вставить("Массив",       Новый ФиксированныйМассив(Массив));
	ВсеРоли.Вставить("Соответствие", Новый ФиксированноеСоответствие(Соответствие));
	ВсеРоли.Вставить("Таблица",      Таблица);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ВсеРоли, Ложь);
	
КонецФункции

#КонецОбласти

#КонецЕсли
