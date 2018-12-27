﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Завершение работы пользователей".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Открывает форму ввода параметров администрирования информационной базы и/или кластера.
//
// Параметры:
//	ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - Обработчик, который будет вызван после ввода параметров
//	                                                   администрирования.
//	ЗапрашиватьПараметрыАдминистрированияИБ - Булево - Признак необходимости ввода параметров администрирования
//	                                                   информационной базы.
//	ЗапрашиватьПараметрыАдминистрированияКластера - Булево - Признак необходимости ввода параметров администрирования
//	                                                         кластера.
//	ПараметрыАдминистрирования - Структура - Параметры администрирования, которые были введены ранее.
//	Заголовок - Строка - Заголовок формы, описывающий для чего запрашиваются параметры администрирования.
//	ПоясняющаяНадпись - Строка - Пояснение для выполняемого действия, в контексте которого запрашиваются параметры.
//
Процедура ПоказатьПараметрыАдминистрирования(ОписаниеОповещенияОЗакрытии, ЗапрашиватьПараметрыАдминистрированияИБ,
	ЗапрашиватьПараметрыАдминистрированияКластера, ПараметрыАдминистрирования = Неопределено,
	Заголовок = "", ПоясняющаяНадпись = "") Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗапрашиватьПараметрыАдминистрированияИБ", ЗапрашиватьПараметрыАдминистрированияИБ);
	ПараметрыФормы.Вставить("ЗапрашиватьПараметрыАдминистрированияКластера", ЗапрашиватьПараметрыАдминистрированияКластера);
	ПараметрыФормы.Вставить("ПараметрыАдминистрирования", ПараметрыАдминистрирования);
	ПараметрыФормы.Вставить("Заголовок", Заголовок);
	ПараметрыФормы.Вставить("ПоясняющаяНадпись", ПоясняющаяНадпись);
	
	ОткрытьФорму("ОбщаяФорма.ПараметрыАдминистрированияПрограммы", ПараметрыФормы,,,,,ОписаниеОповещенияОЗакрытии);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет действия перед началом работы системы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если Не ПараметрыКлиента.Свойство("СеансыОбластиДанныхЗаблокированы") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПередНачаломРаботыСистемы", ЭтотОбъект);
	
КонецПроцедуры

// Выполняет действия при начале работы системы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботы.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат;
	КонецЕсли;
	
	Если ПолучитьСкоростьКлиентскогоСоединения() <> СкоростьКлиентскогоСоединения.Обычная Тогда
		Возврат;
	КонецЕсли;
	
	РежимБлокировки = ПараметрыРаботы.ПараметрыБлокировкиСеансов;
	ТекущееВремя = РежимБлокировки.ТекущаяДатаСеанса;
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует.
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);
	
КонецПроцедуры

// Обработать параметры запуска, связанные с завершение и разрешение соединений ИБ.
//
// Параметры:
//  ЗначениеПараметраЗапуска  - Строка - главный параметр запуска.
//  ПараметрыЗапуска          - Массив - дополнительные параметры запуска, разделенные
//                                       символом ";".
//
// Возвращаемое значение:
//   Булево   - Истина, если требуется прекратить выполнение запуска системы.
//
Функция ОбработатьПараметрыЗапуска(Знач ЗначениеПараметраЗапуска, Знач ПараметрыЗапуска)

	ПараметрыРаботы = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если НЕ ПараметрыРаботы.ДоступноИспользованиеРазделенныхДанных Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Обработка параметров запуска программы - 
	// ЗапретитьРаботуПользователей и РазрешитьРаботуПользователей.
	Если ЗначениеПараметраЗапуска = Врег("РазрешитьРаботуПользователей") Тогда
		
		Если НЕ СоединенияИБВызовСервера.РазрешитьРаботуПользователей() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска РазрешитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			ПоказатьПредупреждение(,ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(СоединенияИБКлиентСервер.СобытиеЖурналаРегистрации(),,
			Нстр("ru = 'Выполнен запуск с параметром ""РазрешитьРаботуПользователей"". Работа программы будет завершена.'"), ,Истина);
		ЗавершитьРаботуСистемы(Ложь);
		Возврат Истина;
		
	// Параметр может содержать две дополнительные части, разделенные символом ";" - 
	// имя и пароль администратора ИБ, от имени которого происходит подключение к кластеру серверов
	// в клиент-серверном варианте развертывания системы. Их необходимо передавать в случае, 
	// если текущий пользователь не является администратором ИБ.
	// См. использование в процедуре ЗавершитьРаботуПользователей().
	ИначеЕсли ЗначениеПараметраЗапуска = Врег("ЗавершитьРаботуПользователей") Тогда
		
		// Поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчики ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		
		Если НЕ СоединенияИБВызовСервера.УстановитьБлокировкуСоединений() Тогда
			ТекстСообщения = НСтр("ru = 'Параметр запуска ЗавершитьРаботуПользователей не отработан. Нет прав на администрирование информационной базы.'");
			ПоказатьПредупреждение(,ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
		Возврат Ложь; // Продолжить запуск программы.
		
	КонецЕсли;
	Возврат Ложь;
	
КонецФункции

// Подключить обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей или.
// ЗавершитьРаботуПользователей в зависимости от параметра УстановитьБлокировкуСоединений.
//
Процедура УстановитьОбработчикиОжиданияЗавершенияРаботыПользователей(Знач УстановитьБлокировкуСоединений) Экспорт
	
	УстановитьПризнакРаботаПользователейЗавершается(УстановитьБлокировкуСоединений);
	Если УстановитьБлокировкуСоединений Тогда
		// Поскольку блокировка еще не установлена, то при входе в систему
		// для данного пользователя был подключен обработчик ожидания завершения работы.
		// Отключаем его. Так как для этого пользователя подключается специализированный обработчик ожидания
		// "ЗавершитьРаботуПользователей", который ориентирован на то, что данный пользователь
		// должен быть отключен последним.
		
		ОтключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей");
		ПодключитьОбработчикОжидания("ЗавершитьРаботуПользователей", 60);
		ЗавершитьРаботуПользователей();
	Иначе
		ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
		ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);
	КонецЕсли;
	
КонецПроцедуры

// Завершает работу (последнего) сеанса администратора, который инициировал завершение работы пользователей.
//
Процедура ЗавершитьРаботуЭтогоСеанса(ВыводитьВопрос = Истина) Экспорт
	
	УстановитьПризнакРаботаПользователейЗавершается(Ложь);
	ОтключитьОбработчикОжидания("ЗавершитьРаботуПользователей");
	
	Если ЗавершитьВсеСеансыКромеТекущего() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ВыводитьВопрос Тогда 
		ЗавершитьРаботуСистемы(Ложь);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ЗавершитьРаботуЭтогоСеансаЗавершение", ЭтотОбъект);
	ТекстСообщения = НСтр("ru = 'Работа пользователей с программой запрещена. Завершить работу этого сеанса?'");
	Заголовок = НСтр("ru = 'Завершение работы текущего сеанса'");
	ПоказатьВопрос(Оповещение, ТекстСообщения, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да, Заголовок, КодВозвратаДиалога.Да);
	
КонецПроцедуры

// Устанавливает значение переменной ЗавершитьВсеСеансыКромеТекущего в значение Значение.
//
// Параметры:
//   Значение - Булево - устанавливаемое значение.
//
Процедура УстановитьПризнакЗавершитьВсеСеансыКромеТекущего(Значение) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"].Вставить("ЗавершитьВсеСеансыКромеТекущего", Значение);
	
КонецПроцедуры

// Устанавливает значение переменной РаботаПользователейЗавершается в значение Значение.
//
// Параметры:
//   Значение - Булево - устанавливаемое значение.
//
Процедура УстановитьПризнакРаботаПользователейЗавершается(Значение) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"].Вставить("РаботаПользователейЗавершается", Значение);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в эту подсистему.

// Вызывается при неудачной попытке установить монопольный режим в файловой базе.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - описывает, куда надо передать управление после закрытия формы.
//
Процедура ПриОткрытииФормыОшибкиУстановкиМонопольногоРежима(Оповещение = Неопределено, ПараметрыФормы = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.БлокировкаРаботыПользователей.Форма.ОшибкаУстановкиМонопольногоРежима", ПараметрыФормы,
		, , , , Оповещение);
	
КонецПроцедуры
	
// Открывает форму блокировки работы пользователей
//
Процедура ПриОткрытииФормыБлокировкиРаботыПользователей(Оповещение = Неопределено, ПараметрыФормы = Неопределено) Экспорт
	
	ОткрытьФорму("Обработка.БлокировкаРаботыПользователей.Форма.БлокировкаСоединенийСИнформационнойБазой", ПараметрыФормы,
		, , , , Оповещение);
	
КонецПроцедуры

// Переопределяет стандартное предупреждение открытием произвольной формы активных пользователей.
//
// Параметры:
//  ИмяФормы - Строка (возвращаемое значение).
//
Процедура ПриОпределенииФормыАктивныхПользователей(ИмяФормы) Экспорт
	
	ИмяФормы = "Обработка.АктивныеПользователи.Форма.АктивныеПользователи";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Вызывается при интерактивном начале работы пользователя с областью данных.
//
// Параметры:
//  ПервыйПараметр   - Строка - первое значение параметра запуска,
//                     до первого символа ";" в верхнем регистре.
//  ПараметрыЗапуска - Массив - массив строк разделенных символом ";" в параметре запуска,
//                     переданным в конфигурацию с помощью ключа командной строки /C.
//  Отказ            - Булево (возвращаемое значение), если установить Истина,
//                     обработка события ПриНачалеРаботыСистемы будет прервана.
//
Процедура ПриОбработкеПараметровЗапуска(ПервыйПараметр, ПараметрыЗапуска, Отказ) Экспорт
	
	Отказ = Отказ Или ОбработатьПараметрыЗапуска(ПервыйПараметр, ПараметрыЗапуска);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистемы БазоваяФункциональность.

Функция РаботаПользователейЗавершается() Экспорт
	
	ПараметрыЗавершенияРаботыПользователей = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"];
	
	Возврат ТипЗнч(ПараметрыЗавершенияРаботыПользователей) = Тип("Структура")
		И ПараметрыЗавершенияРаботыПользователей.Свойство("РаботаПользователейЗавершается")
		И ПараметрыЗавершенияРаботыПользователей.РаботаПользователейЗавершается;
	
КонецФункции

Функция ЗавершитьВсеСеансыКромеТекущего()
	
	ПараметрыЗавершенияРаботыПользователей = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"];
	
	Возврат ТипЗнч(ПараметрыЗавершенияРаботыПользователей) = Тип("Структура")
		И ПараметрыЗавершенияРаботыПользователей.Свойство("ЗавершитьВсеСеансыКромеТекущего")
		И ПараметрыЗавершенияРаботыПользователей.ЗавершитьВсеСеансыКромеТекущего;
	
КонецФункции

Функция СохраненныеПараметрыАдминистрирования() Экспорт
	
	ПараметрыЗавершенияРаботыПользователей = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"];
	ПараметрыАдминистрирования = Неопределено;
	
	Если ТипЗнч(ПараметрыЗавершенияРаботыПользователей) = Тип("Структура")
		И ПараметрыЗавершенияРаботыПользователей.Свойство("ПараметрыАдминистрирования") Тогда
		
		ПараметрыАдминистрирования = ПараметрыЗавершенияРаботыПользователей.ПараметрыАдминистрирования;
		
	КонецЕсли;
		
	Возврат ПараметрыАдминистрирования;
	
КонецФункции

Процедура СохранитьПараметрыАдминистрирования(Значение) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	
	ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыЗавершенияРаботыПользователей"].Вставить("ПараметрыАдминистрирования", Значение);

КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений.

// Предлагает снять блокировку и войти или прекратить работу системы.
Процедура ИнтерактивнаяОбработкаПередНачаломРаботыСистемы(Параметры, Неопределен) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	ТекстВопроса   = ПараметрыКлиента.ПредложениеВойти;
	ТекстСообщения = ПараметрыКлиента.СеансыОбластиДанныхЗаблокированы;
	
	Если Не ПустаяСтрока(ТекстВопроса) Тогда
		Кнопки = Новый СписокЗначений();
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Войти'"));
		Если ПараметрыКлиента.ВозможноСнятьБлокировку Тогда
			Кнопки.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Снять блокировку и войти'"));
		КонецЕсли;
		Кнопки.Добавить(КодВозвратаДиалога.Отмена, НСтр("ru = 'Отмена'"));
		
		ОбработкаОтвета = Новый ОписаниеОповещения(
			"ПослеОтветаНаВопросВойтиИлиСнятьБлокировку", ЭтотОбъект, Параметры);
		
		ПоказатьВопрос(ОбработкаОтвета, ТекстВопроса, Кнопки, 15,
			КодВозвратаДиалога.Отмена,, КодВозвратаДиалога.Отмена);
		Возврат;
	Иначе
		Параметры.Отказ = Истина;
		ПоказатьПредупреждение(
			СтандартныеПодсистемыКлиент.ОповещениеБезРезультата(Параметры.ОбработкаПродолжения),
			ТекстСообщения, 15);
	КонецЕсли;
	
КонецПроцедуры

// Продолжение предыдущей процедуры.
Процедура ПослеОтветаНаВопросВойтиИлиСнятьБлокировку(Ответ, Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда // Входим в заблокированное приложение.
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда // Снимаем блокировку и входим в приложение.
		СоединенияИБВызовСервера.УстановитьБлокировкуСеансовОбластиДанных(
			Новый Структура("Установлена", Ложь));
	Иначе
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

Процедура ЗадатьВопросПриЗавершенииРаботы(ТекстСообщения) Экспорт
	
	ТекстВопроса = НСтр("ru = '%1
	|Завершить работу?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ТекстСообщения);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗадатьВопросПриЗавершенииРаботыЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Да);
	
КонецПроцедуры

Процедура ЗадатьВопросПриЗавершенииРаботыЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Истина, Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершитьРаботуЭтогоСеансаЗавершение(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Нет Тогда
		СтандартныеПодсистемыКлиент.ПропуститьПредупреждениеПередЗавершениемРаботыСистемы();
		ЗавершитьРаботуСистемы(Ложь);
	КонецЕсли;
	
КонецПроцедуры	

#КонецОбласти
