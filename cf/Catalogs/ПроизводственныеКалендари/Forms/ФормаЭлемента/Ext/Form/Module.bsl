﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Функция ВидыДнейПроизводственногоКалендаря()
	
	ВидыДнейПроизводственногоКалендаря = Новый Соответствие;
	
	Для Каждого СтрокаТаблицы Из ДанныеПроизводственногоКалендаря Цикл
		ВидыДнейПроизводственногоКалендаря.Вставить(СтрокаТаблицы.Дата, СтрокаТаблицы.ВидДня);
	КонецЦикла;
	
	Возврат ВидыДнейПроизводственногоКалендаря;
	
КонецФункции

// Читает данные производственного календаря за указанный год
//
&НаСервере
Процедура ПрочитатьДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода)
	
	ДанныеПроизводственногоКалендаря.Загрузить(Справочники.ПроизводственныеКалендари.ДанныеПроизводственногоКалендаря(ПроизводственныйКалендарь, НомерГода));
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейПроизводственногоКалендаря());
	
КонецПроцедуры

// Записывает данные производственного календаря за указанный год
//
&НаСервере
Процедура ЗаписатьДанныеПроизводственногоКалендаря(Знач НомерГода, Знач ТекущийОбъект = Неопределено)
	
	Если ТекущийОбъект = Неопределено Тогда
		ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	КонецЕсли;
	
	Справочники.ПроизводственныеКалендари.ЗаписатьДанныеПроизводственногоКалендаря(ТекущийОбъект.Ссылка, НомерГода, ДанныеПроизводственногоКалендаря);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьВидыДней(ДатыДней, ВидДня)
	
	ВидыДнейПроизводственногоКалендаря = Новый Соответствие;
	Для Каждого КлючИЗначение Из ВидыДней Цикл
		ВидыДнейПроизводственногоКалендаря.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Для Каждого ВыбраннаяДата Из ДатыДней Цикл
		НайденныеСтроки = ДанныеПроизводственногоКалендаря.НайтиСтроки(Новый Структура("Дата", ВыбраннаяДата));
		Если НайденныеСтроки.Количество() = 0 Тогда
			СтрокаДанных = ДанныеПроизводственногоКалендаря.Добавить();
			СтрокаДанных.Дата = ВыбраннаяДата;
		Иначе
			СтрокаДанных = НайденныеСтроки[0];
		КонецЕсли;
		СтрокаДанных.ВидДня = ВидДня;
		ВидыДнейПроизводственногоКалендаря.Вставить(ВыбраннаяДата, ВидДня);
	КонецЦикла;
	
	ВидыДней = Новый ФиксированноеСоответствие(ВидыДнейПроизводственногоКалендаря);
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиВидДня(ПереносимыйДень, ДатаПереноса, ВидДня)
	
	ВидДняДатыПереноса = ВидыДней.Получить(ДатаПереноса);
	
	ИзменитьВидыДней(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДатаПереноса), ВидДня);
	ИзменитьВидыДней(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПереносимыйДень), ВидДняДатыПереноса);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту(ЗначениеКопирования = Неопределено)
	
	Если НомерТекущегоГода = 0 Тогда
		НомерТекущегоГода = Год(ТекущаяДата());
	КонецЕсли;
	НомерПредыдущегоГода	= НомерТекущегоГода;
	
	Элементы.Календарь.НачалоПериодаОтображения	= Дата(НомерТекущегоГода, 1, 1);
	Элементы.Календарь.КонецПериодаОтображения	= Дата(НомерТекущегоГода, 12, 31);
	
	Если ЗначениеЗаполнено(ЗначениеКопирования) Тогда
		СсылкаНаКалендарь = ЗначениеКопирования;
	Иначе
		СсылкаНаКалендарь = Объект.Ссылка;
	КонецЕсли;
	
	ПрочитатьДанныеПроизводственногоКалендаря(СсылкаНаКалендарь, НомерТекущегоГода);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		ЗаполнитьФормуПоОбъекту(Параметры.ЗначениеКопирования);
	КонецЕсли;
	
	ЦветаВидовДней = Новый ФиксированноеСоответствие(Справочники.ПроизводственныеКалендари.ЦветаОформленияВидовДнейПроизводственногоКалендаря());
	
	ЦветОформленияДняПоУмолчанию = ЦветаВидовДней.Получить(Перечисления.ВидыДнейПроизводственногоКалендаря.ПустаяСсылка());
	
	СписокВидовДня = Справочники.ПроизводственныеКалендари.СписокВидовДня();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Перем НомерГода;
	
	Если Не ПараметрыЗаписи.Свойство("НомерГода", НомерГода) Тогда
		НомерГода = НомерТекущегоГода;
	КонецЕсли;
	
	ЗаписатьДанныеПроизводственногоКалендаря(НомерГода, ТекущийОбъект);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

&НаКлиенте
Процедура ИзменитьДень(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() > 0 И Год(ВыделенныеДаты[0]) = НомерТекущегоГода Тогда
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаВыбораВидаДня",ЭтаФорма);
		ПоказатьВыборИзСписка(ОписаниеОповещения,СписокВидовДня, , СписокВидовДня.НайтиПоЗначению(ВидыДней.Получить(ВыделенныеДаты[0])));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВидаДня(ВыбранныйЭлемент,ДП) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
		ИзменитьВидыДней(ВыделенныеДаты, ВыбранныйЭлемент.Значение);
		Элементы.Календарь.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДень(Команда)
	
	ВыделенныеДаты = Элементы.Календарь.ВыделенныеДаты;
	
	Если ВыделенныеДаты.Количество() = 0 Или Год(ВыделенныеДаты[0]) <> НомерТекущегоГода Тогда
		Возврат;
	КонецЕсли;
		
	ПереносимыйДень = ВыделенныеДаты[0];
	ВидДня = ВидыДней.Получить(ПереносимыйДень);
	
	ПараметрыВыбораДаты = Новый Структура;
	ПараметрыВыбораДаты.Вставить("НачальноеЗначение",			ПереносимыйДень);
	ПараметрыВыбораДаты.Вставить("НачалоПериодаОтображения",	НачалоГода(Календарь));
	ПараметрыВыбораДаты.Вставить("КонецПериодаОтображения",		КонецГода(Календарь));
	ПараметрыВыбораДаты.Вставить("Заголовок",					НСтр("ru = 'Выбор даты переноса'"));
	ПараметрыВыбораДаты.Вставить("ПоясняющийТекст",				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
																НСтр("ru = 'Выберите дату, на которую будет осуществлен перенос дня %1 %2'"), 
																Формат(ПереносимыйДень, "ДФ='д ММММ'"), 
																"(" + ВидДня + ")"));
	
	ОписаниеОповещения = новый ОписаниеОповещения(
		"ОбработкаВыбораДаты",ЭтаФорма,
		новый Структура("ПереносимыйДень,ВидДня",ПереносимыйДень,ВидДня)
	);
	ОткрытьФорму("ОбщаяФорма.ВыборДаты", ПараметрыВыбораДаты,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораДаты(ВыбраннаяДата,ДП) Экспорт
	Если ВыбраннаяДата <> Неопределено Тогда
		ПеренестиВидДня(ДП.ПереносимыйДень, ВыбраннаяДата, ДП.ВидДня);
		Элементы.Календарь.Обновить();
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура НомерТекущегоГодаПриИзменении(Элемент)
	
	Если Модифицированность Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Записать измененные данные за %1 год?'"), Формат(НомерПредыдущегоГода, "ЧГ=0"));
		
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаОтветаЗаписатьИзмененныеДанныеЗаГод",ЭтаФорма);
		ПоказатьВопрос(ОписаниеОповещения,ТекстСообщения, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФормуПоОбъекту();	
	Модифицированность = Ложь;
	Элементы.Календарь.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаЗаписатьИзмененныеДанныеЗаГод(Результат,ДП) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Объект.Ссылка.Пустая() Тогда
			Записать(Новый Структура("НомерГода", НомерПредыдущегоГода));
		Иначе
			ЗаписатьДанныеПроизводственногоКалендаря(НомерПредыдущегоГода);
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьФормуПоОбъекту();	
	Модифицированность = Ложь;
	Элементы.Календарь.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура КалендарьПриВыводеПериода(Элемент, ОформлениеПериода)
	
	Для Каждого СтрокаОформленияПериода Из ОформлениеПериода.Даты Цикл
		ЦветОформленияДня = ЦветаВидовДней.Получить(ВидыДней.Получить(СтрокаОформленияПериода.Дата));
		СтрокаОформленияПериода.ЦветТекста = ?(ЦветОформленияДня = Неопределено, ЦветОформленияДняПоУмолчанию, ЦветОформленияДня);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОтветаЗаполнитьКалендарь",ЭтаФорма);
	ПоказатьВопрос(
		ОписаниеОповещения,
		"Текущие данные будут потеряны. Заполнить календарь?",
		РежимДиалогаВопрос.ДаНет,,
		КодВозвратаДиалога.Нет,
		"Внимание"
	);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаЗаполнитьКалендарь(Результат,ДП) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда 
		
		ЗаполнитьНаСервере();
		Элементы.Календарь.Обновить();
	КонецЕсли;
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьНаСервере()
	ТекДата = Дата(НомерТекущегоГода,1,1);
	КонецГода = КонецГода(ТекДата);
	МассивРабочихДней = Новый Массив;
	МассивСуббот = Новый Массив;
	МассивВоскресений = Новый Массив;
	Пока ТекДата<КонецГода Цикл 
		ДН = ДеньНедели(ТекДата);
		Если ДН = 6 Тогда 
			МассивСуббот.Добавить(ТекДата);
		ИначеЕсли ДН = 7 Тогда 
			МассивВоскресений.Добавить(ТекДата);
		Иначе
			МассивРабочихДней.Добавить(ТекДата);
		КонецЕсли;
		ТекДата = ТекДата+24*3600;
	КонецЦикла;
	
	ИзменитьВидыДней(МассивРабочихДней, Перечисления.ВидыДнейПроизводственногоКалендаря.Рабочий);
	ИзменитьВидыДней(МассивСуббот, Перечисления.ВидыДнейПроизводственногоКалендаря.Суббота);
	ИзменитьВидыДней(МассивВоскресений, Перечисления.ВидыДнейПроизводственногоКалендаря.Воскресенье);
	
	СписокПраздников = ПолучитьСписокПраздниковРФ(НомерТекущегоГода);
	МассивПраздников = СписокПраздников.ВыгрузитьЗначения();
	ИзменитьВидыДней(МассивПраздников, Перечисления.ВидыДнейПроизводственногоКалендаря.Праздник);
	
	МассивПредпраздничных = Новый Массив;
	Для Каждого День Из СписокПраздников Цикл 
		Дт = НачалоДня(НачалоДня(День.Значение)-1);
		Если МассивСуббот.Найти(Дт) = Неопределено И МассивВоскресений.Найти(Дт) = Неопределено И МассивПраздников.Найти(Дт) = Неопределено Тогда 
			МассивПредпраздничных.Добавить(Дт);
		КонецЕсли;
		
		Если МассивСуббот.Найти(День.Значение) <> Неопределено ИЛИ МассивВоскресений.Найти(День.Значение) <> Неопределено Тогда 
			ТекстСообщения = "Праздник "+День.Представление+" попадает на выходной день. Перенесите выходной день.";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
	КонецЦикла;
	ИзменитьВидыДней(МассивПредпраздничных, Перечисления.ВидыДнейПроизводственногоКалендаря.Предпраздничный);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокПраздниковРФ(КалендарныйГод) 

	СписокПраздников = Новый СписокЗначений();
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,1), "Новогодние каникулы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,2), "Новогодние каникулы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,3), "Новогодние каникулы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,4), "Новогодние каникулы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,5), "Новогодние каникулы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,1,7), "Рождество Христово");
	СписокПраздников.Добавить(Дата(КалендарныйГод,2,23), "День защитника Отечества");
	СписокПраздников.Добавить(Дата(КалендарныйГод,3,8), "Международный женский день");
	СписокПраздников.Добавить(Дата(КалендарныйГод,5,1), "Праздник Весны и Труда");
	СписокПраздников.Добавить(Дата(КалендарныйГод,5,9), "День Победы");
	СписокПраздников.Добавить(Дата(КалендарныйГод,6,12), "День России");
	СписокПраздников.Добавить(Дата(КалендарныйГод,11,4), "День народного единства");

	Возврат СписокПраздников

КонецФункции // ПолучитьСписокПраздниковРФ()


&НаКлиенте
Процедура Печать(Команда)
	ТабДок = Новый ТабличныйДокумент;
	ПечатьНаСервере(ТабДок);
	ТабДок.Показать();
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере(ТабДок)
	Справочники.ПроизводственныеКалендари.Печать(ТабДок,Объект.Ссылка,НомерТекущегоГода);
КонецПроцедуры

