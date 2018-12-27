﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Сообщение = "";
		Если нсиБизнесПроцессы.ОбъектОбрабатывается(Объект.Предмет, Сообщение) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение,,,,Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	нсиБизнесПроцессы.ЗаполнитьСписокДоступныхСправочников(Элементы.ИмяСправочника.СписокВыбора);
	
	Если ЗначениеЗаполнено(Объект.Предмет) И Не ЗначениеЗаполнено(Объект.ИмяСправочника) Тогда 
		Объект.ИмяСправочника = Объект.Предмет.Метаданные().Имя;
	КонецЕсли;	
	
	НачальныйПризнакСтарта = Объект.Стартован;
	ТолькоПросмотр = Объект.Стартован;
	Элементы.ГруппаСостояние.Видимость = Объект.Завершен;
	Если Объект.Завершен Тогда
		ДатаЗавершенияСтрокой = Формат(Объект.ДатаЗавершения, "ДЛФ=DT");
		ТекстСостояния = ?(Объект.Выполнено, 
			НСтр("en='Target complited %1.';ru='Задание выполнено %1.'"), 
			НСтр("en='Task canceled %1.';ru='Задание отменено %1.'"));	
		Элементы.ДекорацияТекст.Заголовок =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСостояния,	
				ДатаЗавершенияСтрокой);
	КонецЕсли;
	
	
	
	Если Не ЗначениеЗаполнено(Объект.Автор) и Не НачальныйПризнакСтарта Тогда 
		Объект.Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Объект.НоваяПометкаУдаления = НЕ Объект.Предмет.ПометкаУдаления;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) Тогда 
		Если Объект.НоваяПометкаУдаления Тогда
			Объект.Наименование 	= "Пометить на удаление " + Объект.Предмет;
			Объект.ОписаниеЗадания 	= "Пометить на удаление " + Объект.Предмет;
		Иначе
			Объект.Наименование 	= "Снять пометку на удаление " + Объект.Предмет;
			Объект.ОписаниеЗадания 	= "Снять пометку на удаление " + Объект.Предмет;
		КонецЕсли;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Объект.ГруппаПользователейБП = нсиБизнеспроцессы.ПолучитьГруппуПользователейБППоУмолчанию(Объект.Автор);
		Если НЕ ЗначениеЗаполнено(Объект.ГруппаПользователейБП) Тогда 
			Объект.ГруппаПользователейБП = Справочники.нсиГруппыПользователейБП.Основная;
		КонецЕсли;
	КонецЕсли;
	
	нсиРаботаСФормамиСервер.УстановитьТипПредмета(Объект.Предмет, Элементы.ПризнакЭлемента);
	УправлениеВидимостьюИДоступом();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ПараметрыЗаписи.Свойство("Старт") Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Отправьте в службу НСИ.",,,,Отказ);
		Возврат;
	КонецЕсли;	
	
	// Проверяем на аналогичный запрос
	Сообщение = "";
	Если нсиБизнесПроцессы.ОбъектОбрабатывается(Объект.Предмет, Сообщение) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение,,,,Отказ);
		Возврат;
	КонецЕсли;
	
	// Проверяем заполнение и в остальных случаях при записи (помимо старта).
	ЗначениеСтарт = Ложь;
	Если ПараметрыЗаписи.Свойство("Старт", ЗначениеСтарт) И НЕ ЗначениеСтарт Тогда
		Отказ = НЕ ТекущийОбъект.ПроверитьЗаполнение();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.НастройкаБП) Тогда 
		ТекстСообщения = 
			"Отправка в службу НСИ невозможна.
			|Не настроен маршрут бизнес-процесса.
			|Обратитесь к администратору.";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.Дата = ТекущаяДата();
	ТекущийОбъект.СрокИсполнения = нсиБизнесПроцессы.ОпределитьДатуОкончанияПоКалендарномуГрафику(
		ТекущаяДата(),
		ТекущийОбъект.НастройкаБП.ОбщееВремяВыполнения,
		Справочники.Пользователи.ПустаяСсылка()
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	НастроитьПолеВыбораПредмета();
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ЭтоСтарт = Ложь;
	Если ПараметрыЗаписи.Свойство("Старт",ЭтоСтарт) Тогда 
		Если ЭтоСтарт Тогда 
			Если нсиБизнесПроцессы.НеВыполняютсяУсловияНаВсехЭтапахОбработки(ТекущийОбъект.Ссылка) Тогда 
				ТекстСообщения = 
					"Не выполняются условия ни на одном этапе шага ""Обработка"".
					|Отправка в службу НСИ не выполнена.";
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ИзменилсяСписокБП");
	Оповестить("ЗадачаИзменена", Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	МассивНастроек = нсиБизнесПроцессы.ПолучитьНастройкиБП(
		Объект.ИмяСправочника,
		"нсиУдалениеЭлементаСправочника",
		Объект.Предмет,
		Объект.Автор
	);
	
	Если МассивНастроек.Количество() = 1 Тогда 
		Объект.НастройкаБП = МассивНастроек[0];
	ИначеЕсли МассивНастроек.Количество() = 0 Тогда 
		ПоказатьПредупреждение(,
			"Отправка в службу НСИ невозможна.
			|Для Вас отсутствует настройка маршрута бизнес-процесса, 
			|соответствующая макету и типу бизнес-процесса
			|Обратитесь к администратору."
		);
		Возврат;
	Иначе
		СЗ = новый СписокЗначений;
		СЗ.ЗагрузитьЗначения(МассивНастроек);
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВыбораНастройкиБП",ЭтаФорма);
		СЗ.ПоказатьВыборЭлемента(ОписаниеОповещения,"Выберите настройку бизнес-процесса");
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПрохождениеЭтапов();
	
	Если ЗаписатьВыполнить() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораНастройкиБП(Результат,ДП) Экспорт
	Если Результат = Неопределено Тогда 
		ПоказатьПредупреждение(,
			"Не выбрана настройка маршрута бизнес-процесса.
			|Отправка в службу НСИ не выполнена"
		);
		Возврат;
	Иначе
		Объект.НастройкаБП = Результат.Значение;
	КонецЕсли;
	
	ЗаполнитьПрохождениеЭтапов();
	Если ЗаписатьВыполнить() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Параметры(Команда)
	НаправленияОбработки = новый СписокЗначений;
	НаправленияОбработки.ЗагрузитьЗначения(нсиБизнеспроцессы.ПолучитьГруппыПользователейБП(Объект.Автор));
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаЗакрытияФормыПараметровБП",ЭтаФорма);
	ОткрытьФорму(
		"ОбщаяФорма.нсиФормаПараметровБП",
		новый Структура("НаправленияОбработки,НаправлениеОбработки",НаправленияОбработки,Объект.ГруппаПользователейБП),
		ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца
	);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗакрытияФормыПараметровБП(Результат,ДП) Экспорт
	Если Результат<>Неопределено Тогда 
		Объект.ГруппаПользователейБП = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	Если НЕ Объект.Стартован Тогда 
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаОтветаУдалитьЗаявку",ЭтаФорма);
		ПоказатьВопрос(
			ОписаниеОповещения,
			"Вы уверены, что хотите удалить заявку?",РежимДиалогаВопрос.ДаНет,,,"Подтверждение удаления"
		);
	Иначе
		ПоказатьПредупреждение(,"Запущенный бизнес-процесс удалить нельзя!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаУдалитьЗаявку(Результат,ДП) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
			УдалитьНаСервере();
			ОповеститьОбИзменении(Тип("БизнесПроцессСсылка.нсиУдалениеЭлементаСправочника"));
			Оповестить("ИзменилсяСписокБП");
			Модифицированность = Ложь;
			Закрыть();
		Иначе
			Модифицированность = Ложь;
			Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяСправочникаПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ИмяСправочника) Тогда 
		Если Объект.Предмет <> Неопределено Тогда 
			Если ТипЗнч(Объект.ИмяСправочника) = Тип("Строка") Тогда 
				Если ТипЗнч(Объект.Предмет) <> Тип("СправочникСсылка."+Объект.ИмяСправочника) Тогда 
					Объект.Предмет = Неопределено;
				КонецЕсли;
			ИначеЕсли ТипЗнч(Объект.ИмяСправочника) = Тип("СправочникСсылка.нсиВидыСправочников") Тогда 
				Если (ТипЗнч(Объект.Предмет) <> Тип("СправочникСсылка.нсиУниверсальныйФункциональныйСправочник")
					И ТипЗнч(Объект.Предмет) <> Тип("СправочникСсылка.нсиУниверсальныйКлассификатор"))
					ИЛИ ТипЗнч(Объект.Предмет.Владелец) <> Объект.ИмяСправочника Тогда 
					Объект.Предмет = Неопределено;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		НастроитьПолеВыбораПредмета();
	Иначе
		Объект.Предмет = Неопределено;
	КонецЕсли;
	
	УправлениеВидимостьюИДоступом();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокЗаданияПриИзменении(Элемент)
	
	Объект.ОписаниеЗадания = Объект.Наименование;
		
КонецПроцедуры

&НаКлиенте
Процедура ПредметПриИзменении(Элемент)
	ПроверитьПредмет();
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда
		Объект.НоваяПометкаУдаления = НЕ нсиОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Предмет,"ПометкаУдаления");
		Если Объект.НоваяПометкаУдаления Тогда
			Объект.Наименование 	= "Пометить на удаление " + Объект.Предмет;
			Объект.ОписаниеЗадания 	= "Пометить на удаление " + Объект.Предмет;
		Иначе
			Объект.Наименование 	= "Снять пометку на удаление " + Объект.Предмет;
			Объект.ОписаниеЗадания 	= "Снять пометку на удаление " + Объект.Предмет;
		КонецЕсли;
	Иначе
		Объект.Наименование 	= "";
		Объект.ОписаниеЗадания 	= "";
	КонецЕсли;
	
	ОбновитьТипПредметаНаСервере();
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЗаписатьВыполнить()
	
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Регистрация заявки на удаление элемента справочника """+Строка(Объект.ИмяСправочника)+""""
	);
	
	ОчиститьСообщения();
	ПараметрСтарт = НЕ НачальныйПризнакСтарта И НЕ Объект.Стартован;
	УспешноЗаписано = Записать(Новый Структура("Старт", ПараметрСтарт));
	
	Если УспешноЗаписано И ПараметрСтарт Тогда
		
		НачальныйПризнакСтарта = Истина;
		ОтобразитьИзменениеДанных(Объект.Ссылка, ВидИзмененияДанных.Добавление);
		Оповестить("ЗадачаИзменена", Объект.Ссылка);
		
	КонецЕсли;
	Возврат УспешноЗаписано;
	
КонецФункции

&НаСервере
Процедура УдалитьНаСервере()
	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Объект.Ссылка.ПолучитьОбъект().Удалить();
		ЗафиксироватьТранзакцию();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось удалить! "+ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

&НаСервере
Процедура УправлениеВидимостьюИДоступом()
	ТолькоПросмотр = ТолькоПросмотр ИЛИ Объект.Стартован;
	Элементы.ЗаписатьИЗакрыть.Доступность = НЕ ТолькоПросмотр И НЕ Объект.Стартован;
	Элементы.Удалить.Доступность = НЕ ТолькоПросмотр И НЕ Объект.Стартован;
	Элементы.Записать.Доступность = НЕ ТолькоПросмотр И НЕ Объект.Стартован;
	Элементы.Предмет.Доступность = ЗначениеЗаполнено(Объект.ИмяСправочника);
	
	Элементы.НастройкаБП.Видимость = 
	Объект.Стартован
	И (РольДоступна("ПолныеПрава") ИЛИ РольДоступна("нсиСтаршийЭксперт"));

КонецПроцедуры

&НаСервере
Процедура ОбновитьТипПредметаНаСервере()
 	нсиРаботаСФормамиСервер.УстановитьТипПредмета(Объект.Предмет, Элементы.ПризнакЭлемента);	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПредмет()
	Если ЗначениеЗаполнено(Объект.Предмет) Тогда 
		Сообщение = "";
		Если нсиБизнесПроцессы.ОбъектОбрабатывается(Объект.Предмет, Сообщение) Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Сообщение);
			Объект.Предмет = Неопределено;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПрохождениеЭтапов()
	БПОбъект = РеквизитФормыВЗначение("Объект");
	БПОбъект.ЗаполнитьПрохождениеЭтапов();
	ЗначениеВРеквизитФормы(БПОбъект,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура НастроитьПолеВыбораПредмета()
	Если ЗначениеЗаполнено(Объект.ИмяСправочника) Тогда 
		Если ТипЗнч(Объект.ИмяСправочника) = Тип("Строка") Тогда 
			Элементы.Предмет.ДоступныеТипы 			= Новый ОписаниеТипов("СправочникСсылка."+Объект.ИмяСправочника);
			Элементы.Предмет.ОграничениеТипа 		= Новый ОписаниеТипов("СправочникСсылка."+Объект.ИмяСправочника);
			ПВ = новый Массив;
			ПВ.Добавить(новый ПараметрВыбора("Отбор.ЭтоМакет",Ложь));
			Элементы.Предмет.ПараметрыВыбора = новый ФиксированныйМассив(ПВ);
		ИначеЕсли ТипЗнч(Объект.ИмяСправочника) = Тип("СправочникСсылка.нсиВидыСправочников") Тогда 
			ИмяСправочникаУХ = нсиУниверсальноеХранилищеПовтИсп.ПолучитьИмяСправочникаХранилища(Объект.ИмяСправочника);
			Элементы.Предмет.ДоступныеТипы 			= Новый ОписаниеТипов("СправочникСсылка."+ИмяСправочникаУХ);
			Элементы.Предмет.ОграничениеТипа 		= Новый ОписаниеТипов("СправочникСсылка."+ИмяСправочникаУХ);
			ПВ = новый Массив;
			ПВ.Добавить(новый ПараметрВыбора("Отбор.ЭтоМакет",Ложь));
			ПВ.Добавить(новый ПараметрВыбора("Отбор.Владелец",Объект.ИмяСправочника));
			Элементы.Предмет.ПараметрыВыбора = новый ФиксированныйМассив(ПВ);
		КонецЕсли;
		Элементы.Предмет.РазрешитьСоставнойТип 	= Ложь;
	КонецЕсли;
КонецПроцедуры


#КонецОбласти
