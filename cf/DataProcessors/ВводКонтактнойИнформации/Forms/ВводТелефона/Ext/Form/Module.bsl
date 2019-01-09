﻿// Форма параметризуется:
//
//      Заголовок     - Строка  - заголовок формы.
//      ЗначенияПолей - Строка  - сериализованное значение контактной информации или пустая строка для 
//                                ввода нового.
//      Представление - Строка  - представление адреса (используется только при работе со старыми данными).
//      ВидКонтактнойИнформации - СправочникСсылка.ВидыКонтактнойИнформации, Структура - описание того, что мы
//                                редактируем.
//      Комментарий  - Строка   - необязательный комментарий, для подстановки в поле "Комментарий".
//
//      ВозвращатьСписокЗначений - Булево - необязательный флаг того, что возвращаемое значение поля.
//                                 КонтактнаяИнформация будет иметь тип СписокЗначений (совместимость).
//
//  Результат выбора:
//      Структура - поля:
//          * КонтактнаяИнформация   - Строка - XML контактной информации.
//          * Представление          - Строка - Представление.
//          * Комментарий            - Строка - Комментарий.
//
// -------------------------------------------------------------------------------------------------

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ВозвращатьСписокЗначений", ВозвращатьСписокЗначений);
	
	// Разбор параметров в реквизиты.
	Если ТипЗнч(Параметры.ВидКонтактнойИнформации) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда 
		ВидКонтактнойИнформации = Параметры.ВидКонтактнойИнформации;
		ТипКонтактнойИнформации = ВидКонтактнойИнформации.Тип;
	Иначе
		СтруктураВидКонтактнойИнформации = Параметры.ВидКонтактнойИнформации;
		ТипКонтактнойИнформации = СтруктураВидКонтактнойИнформации.Тип;
	КонецЕсли;
	
	ПроверятьКорректность      = ВидКонтактнойИнформации.ПроверятьКорректность;
	
	Заголовок = ?(ПустаяСтрока(Параметры.Заголовок), Строка(ВидКонтактнойИнформации), Параметры.Заголовок);
	
	Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(Параметры.ЗначенияПолей) Тогда
		РезультатыЧтения = Новый Структура;
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияИзXML(Параметры.ЗначенияПолей, ТипКонтактнойИнформации, РезультатыЧтения);
		Если РезультатыЧтения.Свойство("ТекстОшибки") Тогда
			// Распознали с ошибками, сообщим при открытии.
			ТекстПредупрежденияПриОткрытии = РезультатыЧтения.ТекстОшибки;
			XDTOКонтактная.Представление   = Параметры.Представление;
		КонецЕсли;
		
	ИначеЕсли ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияТелефона(Параметры.ЗначенияПолей, Параметры.Представление, ТипКонтактнойИнформации);
		
	Иначе
		XDTOКонтактная = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияФакса(Параметры.ЗначенияПолей, Параметры.Представление, ТипКонтактнойИнформации);
		
	КонецЕсли;
	
	Если Параметры.Комментарий <> Неопределено Тогда
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(XDTOКонтактная, Параметры.Комментарий);
	КонецЕсли;
	
	//Кутья АА ITRR
	КонтактнаяИнформацияУПП = Параметры.КонтактнаяИнформацияУПП;
	
	ЗначениеРеквизитовПоКонтактнойИнформации(XDTOКонтактная);
	Элементы.Добавочный.Видимость = ВидКонтактнойИнформации.ТелефонCДобавочнымНомером;
	
	// Группа команд "все действия" зависит от интерфейса.
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Такси Тогда
		Элементы.ФормаВсеДействия.Видимость = Ложь;
	Иначе
		Элементы.ОчиститьТелефон.Видимость = Ложь;
		Элементы.ИзменитьФорму.Видимость   = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПиктограммуКомментария();

	Если Не ПустаяСтрока(ТекстПредупрежденияПриОткрытии) Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПредупредитьПослеОткрытияФормы", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Оповещение = Новый ОписаниеОповещения("ПодтвердитьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КодСтраныПриИзменении(Элемент)
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура КодГородаПриИзменении(Элемент)
	
	Если (КодСтраны = "+7" ИЛИ КодСтраны = "8") И СтрНачинаетсяС(КодГорода, "9") И СтрДлина(КодГорода) <> 3 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Кода мобильных телефонов начинающиеся на цифру 9 имеют фиксированную длину в 3 цифры, например - 916.'"),, "КодГорода");
	КонецЕсли;
	
	ЗаполнитьПредставлениеТелефона();
КонецПроцедуры

&НаКлиенте
Процедура НомерТелефонаПриИзменении(Элемент)
	
//	КутьяАА I-402260
	НомерТелефона = ПривестиНомераТелефоновКШаблону(НомерТелефона);
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавочныйПриИзменении(Элемент)
	
//	КутьяАА I-402260
	Добавочный = ПривестиНомерТелефонаКШаблону(Добавочный);
	
	ЗаполнитьПредставлениеТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийПриИзменении(Элемент)
	
	ПодключитьОбработчикОжидания("УстановитьПиктограммуКомментария", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	ПодтвердитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТелефон(Команда)
	
	ОчиститьТелефонСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПредупредитьПослеОткрытияФормы()
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупрежденияПриОткрытии);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПиктограммуКомментария()
	Элементы.ТелефонСтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Комментарий);
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	// При немодифицированности работает "отмена".
	
	Если Модифицированность Тогда
		// Изменено значение адреса 
		
		ЕстьОшибкиЗаполнения = Ложь;
		// Смотрим, надо ли проверять на корректность.
		Если ПроверятьКорректность Тогда
			СписокОшибок = ОшибкиЗаполненияТелефонаСервер();
			ЕстьОшибкиЗаполнения = СписокОшибок.Количество()>0;
		КонецЕсли;
		Если ЕстьОшибкиЗаполнения Тогда
			СообщитьОбОшибкахЗаполнения(СписокОшибок);
			Возврат;
		КонецЕсли;
		Результат = РезультатВыбора();
		
		//Кутья АА ITRR
		ЗаписатьТелефонУПП();
		Результат.Вставить("КонтактнаяИнформацияУПП", КонтактнаяИнформацияУПП);
	
		СброситьМодифицированностьПриВыборе();
		ОповеститьОВыборе(Результат);
		
	ИначеЕсли Комментарий<>КопияКомментария Тогда
		// Изменен только комментарий, пробуем вернуть обновленное.
		Результат = РезультатВыбораТолькоКомментария();
		
		СброситьМодифицированностьПриВыборе();
		ОповеститьОВыборе(Результат);
		
	Иначе
		Результат = Неопределено;
		
	КонецЕсли;
	
	Если (МодальныйРежим Или ЗакрыватьПриВыборе) И Открыта() Тогда
		СброситьМодифицированностьПриВыборе();
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьМодифицированностьПриВыборе()
	
	Модифицированность = Ложь;
	КопияКомментария   = Комментарий;
	
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	XDTOИнформация = КонтактнаяИнформацияПоЗначениюРеквизитов();
	
	Если ВозвращатьСписокЗначений Тогда
		ДанныеВыбора = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияВСтаруюСтруктуру(XDTOИнформация);
		ДанныеВыбора = ДанныеВыбора.ЗначенияПолей;
	Иначе
		ДанныеВыбора = УправлениеКонтактнойИнформациейСлужебный.КонтактнаяИнформацияXDTOВXML(XDTOИнформация);
	КонецЕсли;
		
	Возврат Новый Структура("КонтактнаяИнформация, Представление, Комментарий",
		ДанныеВыбора,
		XDTOИнформация.Представление, 
		XDTOИнформация.Комментарий);
КонецФункции

&НаСервере
Функция РезультатВыбораТолькоКомментария()
	
	КонтактнаяИнфо = Параметры.ЗначенияПолей;
	Если ПустаяСтрока(КонтактнаяИнфо) Тогда
		Если ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			КонтактнаяИнфо = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияТелефона("", "", ТипКонтактнойИнформации);
		Иначе
			КонтактнаяИнфо = УправлениеКонтактнойИнформациейСлужебный.ДесериализацияФакса("", "", ТипКонтактнойИнформации);
		КонецЕсли;
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(КонтактнаяИнфо, Комментарий);
		КонтактнаяИнфо = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВXML(КонтактнаяИнфо);
		
	ИначеЕсли УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(КонтактнаяИнфо) Тогда
		УправлениеКонтактнойИнформацией.УстановитьКомментарийКонтактнойИнформации(КонтактнаяИнфо, Комментарий);
	КонецЕсли;
	
	Возврат Новый Структура("КонтактнаяИнформация, Представление, Комментарий",
		КонтактнаяИнфо, Параметры.Представление, Комментарий);
КонецФункции

// Заполняет реквизиты формы из XTDO объекта типа "Контактная информация".
&НаСервере
Процедура ЗначениеРеквизитовПоКонтактнойИнформации(РедактируемаяИнформация)
	
	Телефон = РедактируемаяИнформация.Состав;
	
	//КутьяАА ITRR <<
	СоставТелефонаУПП = Новый Структура;
	СоставТелефонаУПП.Вставить("КодСтраны", КонтактнаяИнформацияУПП.Поле1);
	СоставТелефонаУПП.Вставить("КодГорода", КонтактнаяИнформацияУПП.Поле2);
	СоставТелефонаУПП.Вставить("Номер", КонтактнаяИнформацияУПП.Поле3);
	СоставТелефонаУПП.Вставить("Добавочный", КонтактнаяИнформацияУПП.Поле4);
	
	Для каждого ЭлементНомераУПП Из СоставТелефонаУПП Цикл
		Если НЕ ЗначениеЗаполнено(Телефон[ЭлементНомераУПП.Ключ]) 
			И ЗначениеЗаполнено(ЭлементНомераУПП.Значение) Тогда
			Модифицированность = Истина;
			Телефон[ЭлементНомераУПП.Ключ] = ЭлементНомераУПП.Значение;
		КонецЕсли; 
	КонецЦикла;
	
	ПредставлениеКомментарийУПП = Новый Структура;
	ПредставлениеКомментарийУПП.Вставить("Представление", КонтактнаяИнформацияУПП.Представление);
	ПредставлениеКомментарийУПП.Вставить("Комментарий", КонтактнаяИнформацияУПП.Комментарий);
	
	Для каждого ЭлементПредставлениеКомментарийУПП Из ПредставлениеКомментарийУПП Цикл
		Если НЕ ЗначениеЗаполнено(РедактируемаяИнформация[ЭлементПредставлениеКомментарийУПП.Ключ]) 
			И ЗначениеЗаполнено(ЭлементПредставлениеКомментарийУПП.Значение) Тогда
			Модифицированность = Истина;
			РедактируемаяИнформация[ЭлементПредставлениеКомментарийУПП.Ключ] = ЭлементПредставлениеКомментарийУПП.Значение;
		КонецЕсли; 
	КонецЦикла;
	//>>
	
	// Общие реквизиты
	Представление = РедактируемаяИнформация.Представление;
	Комментарий   = РедактируемаяИнформация.Комментарий;
	
	// Копия комментария для анализа измененности.
	КопияКомментария = Комментарий;
	
	КодСтраны     = Телефон.КодСтраны;
	КодГорода     = Телефон.КодГорода;
	НомерТелефона = Телефон.Номер;
	Добавочный    = Телефон.Добавочный;
	
КонецПроцедуры

// Возвращает XTDO объект типа "Контактная информация" по значению реквизитов.
&НаСервере
Функция КонтактнаяИнформацияПоЗначениюРеквизитов()
	ПространствоИмен = УправлениеКонтактнойИнформациейКлиентСервер.ПространствоИмен();
	
	Результат = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "КонтактнаяИнформация") );
	
	Если ТипКонтактнойИнформации = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		Данные = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "НомерТелефона") );
		Данные.КодСтраны  = КодСтраны;
		Данные.КодГорода  = КодГорода;
		Данные.Номер      = НомерТелефона;
		Данные.Добавочный = Добавочный;
		Результат.Представление = УправлениеКонтактнойИнформациейСлужебный.ПредставлениеТелефона(Данные);
	Иначе        
		Данные = ФабрикаXDTO.Создать( ФабрикаXDTO.Тип(ПространствоИмен, "НомерФакса") );
		Данные.КодСтраны  = КодСтраны;
		Данные.КодГорода  = КодГорода;
		Данные.Номер      = НомерТелефона;
		Данные.Добавочный = Добавочный;
		Результат.Представление = УправлениеКонтактнойИнформациейСлужебный.ПредставлениеФакса(Данные);
	КонецЕсли;
	
	Результат.Состав      = Данные;
	Результат.Комментарий = Комментарий;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПредставлениеТелефона()
	
//	ПодключитьОбработчикОжидания("ЗаполнитьПредставлениеТелефонаСейчас", 0.1, Истина);

	ЗаполнитьПредставлениеТелефонаСейчас();	
	
КонецПроцедуры    

&НаКлиенте
Процедура ЗаполнитьПредставлениеТелефонаСейчас()
	
	ЗаполнитьПредставлениеТелефонаСервер();
	
КонецПроцедуры    

&НаСервере
Процедура ЗаполнитьПредставлениеТелефонаСервер(XDTOКонтактная = Неопределено)
	
	Инфо = ?(XDTOКонтактная = Неопределено, КонтактнаяИнформацияПоЗначениюРеквизитов(), XDTOКонтактная);
	Представление = Инфо.Представление;
	
КонецПроцедуры    

// Возвращает список ошибок заполнения в виде списка значений:
//      Представление   - описание ошибки.
//      Значение        - XPath для поля.
&НаСервере
Функция ОшибкиЗаполненияТелефонаСервер() 
	Возврат Новый СписокЗначений();
КонецФункции    

// Сообщает об ошибках заполнения по результату функции ОшибкиЗаполненияТелефонаСервер.
&НаКлиенте
Процедура СообщитьОбОшибкахЗаполнения(СписокОшибок)
	
	Если СписокОшибок.Количество()=0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Телефон введен корректно.'"));
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	// Значение - XPath, представление - описание ошибки.
	Для Каждого Элемент Из СписокОшибок Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Элемент.Представление,,,
		ПутьКДаннымФормыПоПутиXPath(Элемент.Значение));
	КонецЦикла;
	
КонецПроцедуры    

&НаКлиенте 
Функция ПутьКДаннымФормыПоПутиXPath(ПутьXPath) 
	Возврат ПутьXPath;
КонецФункции

&НаСервере
Процедура ОчиститьТелефонСервер()
	КодСтраны     = "";
	КодГорода     = "";
	НомерТелефона = "";
	Добавочный    = "";
	Комментарий   = "";
	
	ЗаполнитьПредставлениеТелефонаСервер();
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТелефонУПП()

	КонтактнаяИнформацияУПП.Вставить("Представление", Представление);
	КонтактнаяИнформацияУПП.Вставить("Поле1", КодСтраны);
	КонтактнаяИнформацияУПП.Вставить("Поле2", КодГорода);
	КонтактнаяИнформацияУПП.Вставить("Поле3", НомерТелефона);
	КонтактнаяИнформацияУПП.Вставить("Поле4", Добавочный);
	КонтактнаяИнформацияУПП.Вставить("Комментарий", Комментарий);

КонецПроцедуры // ЗаписатьАдресУПП()

//	КутьяАА I-402260 <<

// Функция приводит телефонный номер к одному из указанных в настройке шаблонов
//
// Параметры
//  НомерТЛФ – строка, номер телефона, который надо преобразовывать
//
// Возвращаемое значение:
//   Приведенный номер – строка, номер, приведенный к одному из шаблонов
//
&НаСервереБезКонтекста
Функция ПривестиНомерТелефонаКШаблону(НомерТЛФ) 
	
	ТолькоЦифрыНомера = "";
	КоличествоЦифрНомера = 0;
	
	Для а=1 По СтрДлина(НомерТЛФ) Цикл
		Если СтрЧислоВхождений("1234567890",Сред(НомерТЛФ,а,1)) > 0 Тогда
			КоличествоЦифрНомера = КоличествоЦифрНомера + 1;
			ТолькоЦифрыНомера = ТолькоЦифрыНомера + Сред(НомерТЛФ,а,1);
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоЦифрНомера = 0 Тогда
		Возврат НомерТЛФ;
	КонецЕсли;
	
//	СтруктураШаблонов = Константы.ШаблоныТелефонныхНомеров.Получить().Получить();
	//Если ТипЗнч(СтруктураШаблонов) <> Тип("Соответствие") Тогда
	//	Возврат НомерТЛФ;
	//КонецЕсли; 
	
	СтруктураШаблонов = Новый Соответствие;
	СтруктураШаблонов.Вставить(4, "99-99");
	СтруктураШаблонов.Вставить(5, "9-99-99");
	СтруктураШаблонов.Вставить(6, "99-99-99");
	СтруктураШаблонов.Вставить(7, "999-99-99");
	
	ПолученныйШаблон = СтруктураШаблонов.Получить(КоличествоЦифрНомера);
	
	Если ПолученныйШаблон = Неопределено Тогда
		Возврат НомерТЛФ;
	КонецЕсли;
	
	ПриведенныйНомер = "";
	НомерЦифры = 0;
	
	Для а=1 По СтрДлина(ПолученныйШаблон) Цикл
		Если Сред(ПолученныйШаблон,а,1) = "9" Тогда
			НомерЦифры = НомерЦифры + 1;
			ПриведенныйНомер = ПриведенныйНомер + Сред(ТолькоЦифрыНомера,НомерЦифры,1);
		Иначе
			ПриведенныйНомер = ПриведенныйНомер + Сред(ПолученныйШаблон,а,1);
		КонецЕсли;
	КонецЦикла; 

	Возврат ПриведенныйНомер;
	
КонецФункции // ПривестиКШаблону()

&НаСервереБезКонтекста
Функция ПривестиНомераТелефоновКШаблону(НомераТелефонов)

	СтрокаНомеровТелефонов = "";
	Если ЗначениеЗаполнено(НомераТелефонов) Тогда
		
		МассивНомеровТелефонов = Новый Массив;
		
		Указатель = 1;
		ПозицияРазделителя = СтрНайти(НомераТелефонов, ",");
		Пока ПозицияРазделителя > 0 Цикл
			НомерТелефона = Сред(НомераТелефонов, Указатель, ПозицияРазделителя-Указатель);
			МассивНомеровТелефонов.Добавить(СокрЛП(НомерТелефона));
			Указатель = ПозицияРазделителя+1;
			ПозицияРазделителя = СтрНайти(НомераТелефонов, ",",,Указатель);
		КонецЦикла;
		
		НомерТелефона = Сред(НомераТелефонов, Указатель, СтрДлина(НомераТелефонов)-ПозицияРазделителя);
		МассивНомеровТелефонов.Добавить(СокрЛП(НомерТелефона));
		
		Для каждого НомерТЛФ Из МассивНомеровТелефонов Цикл
			СтрокаНомеровТелефонов = СтрокаНомеровТелефонов+ПривестиНомерТелефонаКШаблону(НомерТЛФ)+", ";
		КонецЦикла;
		
		СтрокаНомеровТелефонов = Лев(СтрокаНомеровТелефонов, СтрДлина(СтрокаНомеровТелефонов)-2);
		
	КонецЕсли;
	
	Возврат СтрокаНомеровТелефонов;
	
КонецФункции // ПривестиНомераТелефоновКШаблону()
// >>

#КонецОбласти
