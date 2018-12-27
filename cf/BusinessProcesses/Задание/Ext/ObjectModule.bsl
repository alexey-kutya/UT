﻿
#Область СлужебныеПроцедурыИФункции

Процедура НадоУточнитьПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = НадоУточнить;
КонецПроцедуры

Процедура ОтозватьЗаявкуПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ОтозватьЗадание;
КонецПроцедуры

Процедура УсловиеОтклонитьЗаданиеПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	Результат = ОтклонитьЗадание;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	СтандартнаяОбработка = Ложь;
	Номер = (Формат(нсиБизнесПроцессы.ПолучитьНовыйНомер("НумераторБП"),"ЧЦ=9; ЧВН=; ЧГ=0"));
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И Ссылка.Предмет <> Предмет Тогда
		ИзменитьПредметЗадач();	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") 
		И ДанныеЗаполнения <> Задачи.ЗадачаИсполнителя.ПустаяСсылка() Тогда
		Предмет = ДанныеЗаполнения;
	КонецЕсли;	

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ЗначениеЗаполнено(СрокИсполнения) И Дата>=СрокИсполнения Тогда 
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Срок исполнения не может быть раньше даты формирования задания!",ЭтотОбъект,"СрокИсполнения");
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерИтерации = 0;
	Выполнено = Ложь;
	Подтверждено = Ложь;
	РезультатВыполнения = "";
	ДатаЗавершения = '00010101000000';
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута

Процедура ЗаполнениеПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	Для Каждого Задача Из ФормируемыеЗадачи Цикл
		
//	ITRR Кутья АА		
		Если Задача.БизнесПроцесс.ит_Назначение = 
				ПредопределенноеЗначение("Перечисление.ВидыНазначенийБизнесПроцессов.Уведомление") Тогда
				
			Задача.Автор 			= Автор;
			Задача.Наименование 	= Наименование;
			Задача.Предмет 			= Предмет;
			Задача.ДатаНачала = ТекущаяДата();
			Задача.Важность = Важность;
			Задача.Исполнитель 		= Исполнитель;
			Задача.Описание 		= ОписаниеЗадания;
				
		Иначе
//	ITRR Кутья АА		
		
			Задача.Автор 			= Автор;
			Задача.Наименование 	= ""+ТочкаМаршрутаБизнесПроцесса+": "+Наименование;
			Задача.Предмет 			= Предмет;
			Задача.ДатаНачала = ТекущаяДата();
			Задача.Важность = Важность;
			Задача.СрокИсполнения = СрокИсполнения;
			
			Если ТочкаМаршрутаБизнесПроцесса = БизнесПроцессы.Задание.ТочкиМаршрута.УточнитьЗадание Тогда 
				Задача.Исполнитель 		= Автор;
				Исполнитель = Автор;
				Задача.РольИсполнителя  = Автор;
			Иначе
				Если НЕ ЗначениеЗаполнено(Выполняющий) Тогда 
					Задача.Исполнитель 		= Справочники.Пользователи.ПустаяСсылка();
					Исполнитель = Справочники.Пользователи.ПустаяСсылка();
					Задача.РольИсполнителя  = Справочники.РолиИсполнителей.ОтветственныйЗаКонтрольИсполнения;
					Задача.СпособРаспределения = Перечисления.нсиСпособыРаспределенияЗадач.ПоРоли;
				Иначе
					Задача.Исполнитель 		= Выполняющий;
					Исполнитель = Выполняющий;
					Задача.РольИсполнителя  = Справочники.РолиИсполнителей.ПустаяСсылка();
				КонецЕсли;
			КонецЕсли;
			//Задача.СрокИсполнения 	= СрокИсполнения;
			
			нсиБизнесПроцессы.ОтправитьОповещениеПоЭлектроннойПочте(Задача);
		
//	ITRR Кутья АА		
		КонецЕсли; 
//	ITRR Кутья АА		
		
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Истина);
	Записать();
КонецПроцедуры

Процедура ЗадачаПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	РезультатВыполнения = РезультатВыполненияДляТочек(Задача, ТочкаМаршрутаБизнесПроцесса.Имя) + РезультатВыполнения;
	
	ЗадачаОбъект = Задача.ПолучитьОбъект();
	ЗадачаОбъект.ДатаИсполнения = ТекущаяДата();
	
	ЗадачаОбъект.ДлительностьИсполнения 	= 
		нсиБизнесПроцессы.ОпределитьДлительностьПоГрафику(
			Задача.ДатаНачала,
			Задача.ДатаИсполнения,
			Задача.Исполнитель
	);
	ЗадачаОбъект.Записать();
	
	УстановитьПривилегированныйРежим(Истина);
	Записать();
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = ТекущаяДата();
	нсиБизнесПроцессы.ОтправитьОповещениеОЗавершенииБП(Ссылка);
	Исполнитель = Справочники.Пользователи.ПустаяСсылка();
	
	УстановитьПривилегированныйРежим(Истина);
	Записать();
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс

// Актуализирует значения реквизит невыполненных задач согласно реквизитам бизнес-процесса Задание:
//   Важность, СрокИсполнения, Наименование и Автор.
//
Процедура ИзменитьРеквизитыНевыполненныхЗадач() Экспорт

	УстановитьПривилегированныйРежим(Истина); 
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос( 
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс
			|	И Задачи.ПометкаУдаления = ЛОЖЬ
			|	И Задачи.Выполнена = ЛОЖЬ");
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		Результат = Запрос.Выполнить();
		
		Блокировка = Новый БлокировкаДанных;
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Важность = Важность;
			ЗадачаОбъект.СрокИсполнения = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				СрокИсполненияЗадачиДляВыполнения(), СрокИсполненияЗадачиДляПроверки());
			ЗадачаОбъект.Наименование = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				НаименованиеЗадачиДляВыполнения(), НаименованиеЗадачиДляПроверки());
			ЗадачаОбъект.Автор = Автор;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

// Возвращает строковое представление результата выполнения задачи
// Возвращаемое значение:
//   Строка - описание действий пользователя.
Функция РезультатВыполненияДляТочек(Знач ЗадачаСсылка, ПеренаправитьЗадачи = Неопределено) Экспорт
	
	СтрокаВставки = "обработал(а) задачу:";
	Если ЗадачаСсылка.Результат = Перечисления.нсиРезультатыВыполненияЗадач.Перенаправлена Тогда
		Возврат "";
		//СтрокаВставки = ": задача перенаправлена пользователем "+ПараметрыСеанса.ТекущийПользователь;
	ИначеЕсли ЗадачаСсылка.Результат = Перечисления.нсиРезультатыВыполненияЗадач.ВзятаВОбработку Тогда
		Возврат "";
		//СтрокаВставки = ": задача взята в обработку пользователем "+ПараметрыСеанса.ТекущийПользователь;
	ИначеЕсли ПеренаправитьЗадачи = "ОбработкаЗадания" Тогда
		Если Выполнено Тогда
			СтрокаВставки = "обработано:";
		ИначеЕсли НадоУточнить Тогда
			СтрокаВставки = "отправлено на уточнение:";
		ИначеЕсли ОтклонитьЗадание Тогда
			СтрокаВставки = "отклонено:";
		КонецЕсли;
	ИначеЕсли ПеренаправитьЗадачи = "УточнениеЗадания" Тогда
		Если Выполнено Тогда
			СтрокаВставки = "уточнено:";
		ИначеЕсли ОтозватьЗадание Тогда
			СтрокаВставки = "отозвано:";
		КонецЕсли;
	КонецЕсли;
	
	СтрокаФормат = НСтр("ru = '%1, %2, " + СтрокаВставки + "
		|%3
		|'");
	//--

	ЗадачаДанные = нсиОбщегоНазначения.ПолучитьЗначенияРеквизитов(ЗадачаСсылка, 
		"РезультатВыполнения,ДатаИсполнения,Исполнитель");
	Комментарий = СокрЛП(ЗадачаДанные.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, 
	              ЗадачаДанные.ДатаИсполнения,
	              ЗадачаДанные.Исполнитель,
	              Комментарий);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры

Процедура ИзменитьПредметЗадач()

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");

		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		Результат = Запрос.Выполнить();
		
		Блокировка = Новый БлокировкаДанных;
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
		Блокировка.Заблокировать();
		
		ВыборкаДетальныеЗаписи.Сбросить();
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Предмет = Предмет;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

Функция НаименованиеЗадачиДляВыполнения()
	
	Возврат Наименование;	
	
КонецФункции

Функция СрокИсполненияЗадачиДляВыполнения()
	
	Возврат СрокИсполнения;	
	
КонецФункции

Функция НаименованиеЗадачиДляПроверки()
	
	Возврат БизнесПроцессы.Задание.ТочкиМаршрута.Проверить.НаименованиеЗадачи + ": " + Наименование;
	
КонецФункции

Функция СрокИсполненияЗадачиДляПроверки()
	
	Возврат СрокПроверки;	
	
КонецФункции

Процедура ВнестиИзмененияВНСИОбработка(ТочкаМаршрутаБизнесПроцесса)
	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти


