﻿// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция СформироватьИдентификаторНаСервере()
	
	ОбъектBrandКод = Объект.Brand.Код;
	Пока СтрДлина(ОбъектBrandКод)<5 Цикл
		ОбъектBrandКод = ОбъектBrandКод+"_";
	КонецЦикла;
	
	Возврат ДополнитьПустые(Объект.MaterialGroup.Код, "*")+
	ДополнитьПустые(Объект.MaterialType.Код, "*")+
	ДополнитьПустые(ОбъектBrandКод, "*")+
	ДополнитьПустые(Объект.Volume.Код, "*")+
	ДополнитьПустые(Объект.AlcoholContent.Код, "*")+
	ДополнитьПустые(Объект.Packing.Код, "*")+
	ДополнитьПустые(Объект.Amount.Код, "*")+
	ДополнитьПустые(Объект.Label.Код, "*")+
	Строка(Объект.LabelVersion)+
	Формат(Объект.Version, "ЧЦ=2; ЧН=; ЧВН=")+
	ДополнитьПустые(Объект.Factory.Код, "*");

КонецФункции // СформироватьИдентификаторНаСервере()

&НаСервереБезКонтекста
Функция ДополнитьПустые(Значение, СтрокаДополнения)

	Возврат ?(ЗначениеЗаполнено(Значение),Значение,СтрокаДополнения);

КонецФункции // ПроверитьЗаполнение()
 
// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервере
Функция СформироватьИмяНаСервере()
	
	Возврат Строка(ДополнитьПустые(Объект.Brand, "[*]"))	+" "+
	Строка(ДополнитьПустые(Объект.AlcoholContent, "[*]"))	+"% "+
	Строка(ДополнитьПустые(Объект.Volume, "[*]"))			+" x "+
	Строка(ДополнитьПустые(Объект.Amount, "[*]"))			+" "+
	Строка(ДополнитьПустые(Объект.Label.Код, "[*]"))+
	Строка(Объект.LabelVersion);

КонецФункции // СформироватьИдентификаторНаСервере()

// <Описание функции>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
&НаСервереБезКонтекста
Функция ПолучитьВерсиюФормат(Version)

	Возврат формат(Version, "ЧЦ=2; ЧН=; ЧВН=");

КонецФункции // ПолучитьВерсиюФормат()
 
&НаКлиенте
Процедура VersionПриИзменении(Элемент)
	
	Элементы.VersionZero.Заголовок = ПолучитьВерсиюФормат(Объект.Version);
	
КонецПроцедуры

&НаКлиенте
Процедура GetGlobalID(Команда)
	
	Отказ = Ложь;
	Для каждого ИмяСправочникаКиЗ Из ИменаСправочниковGID Цикл
		
		ИмяПоля = ИмяСправочникаКиЗ.Ключ;
		ТипПоляСправочника = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИменаСправочников[ИмяПоля]));
	
		Если НЕ ТипЗнч(Объект[ИмяПоля]) = ТипПоляСправочника Тогда
			Отказ = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		Сообщить(НСтр("ru = 'Невозможно сформировать Global ID, т.к. одно из полей является строкой или числом.'; en = 'It is not possible to generate a Global ID, because one of the fields is a string or a number.'"));
		Возврат;
	КонецЕсли; 
	
	Объект.ID = СформироватьИдентификаторНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура GetGlobalName(Команда)
	
	Объект.Наименование = СформироватьИмяНаСервере();
	ЭтаФорма.Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимЗаявки = Параметры.РежимЗаявки;
	
	Если Параметры.Ключ.Пустая() 
		И РежимЗаявки Тогда
	
		Объект.ЭтоМакет = Истина;
	
	КонецЕсли; 
	
	Если НЕ Объект.Черновик Тогда
		РегистрыСведений.нсиСтатусыОбработкиСправочников.ОпределитьДоступКФорме(
			Объект.Ссылка, ЭтаФорма.ТолькоПросмотр, Объект.ЭтоМакет);
	КонецЕсли; 
		
	нсиВыделениеИзменений.ОформитьВыделениеИзменений(ЭтотОбъект);
	
	Элементы.VersionZero.Заголовок = ПолучитьВерсиюФормат(Объект.Version);
	
	Если Объект.Наименование = НСтр("ru = 'New Product/Material'; en = 'New Product/Material'") Тогда
		Объект.Наименование = "";
	КонецЕсли;
	
	Для каждого ИмяСправочникаКиЗ Из ИменаСправочников Цикл
		
		ИмяПоля = ИмяСправочникаКиЗ.Ключ;
		ИмяСправочника = ИмяСправочникаКиЗ.Значение;
		ТипПоляСправочника = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИмяСправочника));

		Если ЗначениеЗаполнено(Объект[ИмяПоля]) Тогда
			ТипПоля = ТипЗнч(Объект[ИмяПоля]);
		Иначе
			ТипПоля = ТипПоляСправочника;
		КонецЕсли; 
		
		ПривестиЗначениеКТипу(ТипПоля, ИмяПоля);
		
	КонецЦикла;
	
	Элементы.Status.Видимость = Объект.ЭтоМакет;
	
	Элементы.ГруппаЗаписатьИЗакрыть.Видимость = НЕ Параметры.РежимНовойЗаявки;
	Элементы.ГруппаКнопокОтправкиНаСогласование.Видимость = Параметры.РежимНовойЗаявки;
	
	Если Объект.ЭтоМакет
		И ЗначениеЗаполнено(ПараметрыСеанса.ГруппаУправленияНСИ) Тогда
		
		Объект.СтранаОрганизации = ПараметрыСеанса.ГруппаУправленияНСИ.СтранаОрганизации;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСтроку(Команда)
	
	ИмяПоля = КомандыПолейСправочниковСтрока[Команда.Имя];
	ТипПоляСправочника = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИменаСправочников[ИмяПоля]));
	
	Если ТипЗнч(Объект[ИмяПоля]) = ТипПоляСправочника Тогда
		ТипПоля = ТипыПолейСправочников[ИмяПоля];
	Иначе
		ТипПоля = ТипПоляСправочника;
	КонецЕсли; 
	
	ПривестиЗначениеКТипу(ТипПоля, ИмяПоля);
	
	Если ТипПоля = ТипПоляСправочника Тогда
		УстановитьЗначенияСвязанныхПолей(ИмяПоля);
	КонецЕсли; 
	
	УстановитьВидимостьИОформление(ТипПоля, ИмяПоля);

КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЭлемент(Команда)
	
	ИмяПоля = КомандыПолейСправочниковЭлемент[Команда.Имя];
	
	ПараметрыНового = Новый Структура;
	Для каждого ПолеПараметра Из ПоляПараметровНового[ИмяПоля] Цикл
		ПараметрыНового.Вставить(ПолеПараметра.Ключ, Объект[ПолеПараметра.Значение]);
	КонецЦикла; 
	
	ПутьКФорме = СтрЗаменить("Справочник.ИмяСправочника.ФормаОбъекта", "ИмяСправочника", ИменаСправочников[ИмяПоля]);
	ФормаДокумента = ПолучитьФорму(ПутьКФорме, ПараметрыНового,ЭтаФорма, Истина);
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияФормыНовогоЭлемента", ЭтотОбъект, Новый Структура("Форма, ИмяПоля", ФормаДокумента, ИмяПоля));
	ФормаДокумента.ОписаниеОповещенияОЗакрытии = Оповещение;

	ОткрытьФорму(ФормаДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ПривестиЗначениеКТипу(ТипПоля, ИмяПоля)
	
	КвалификаторСтроки = Новый КвалификаторыСтроки(0);
	КвалификаторЧисла = Новый КвалификаторыЧисла(0);
	Если ТипПоля = Тип("Строка") Тогда
		КвалификаторСтроки = Новый КвалификаторыСтроки(ДлинаПолейСправочников[ИмяПоля]);
	ИначеЕсли ТипПоля = Тип("Число") Тогда
		ОписаниеЧисла = ДлинаПолейСправочников[ИмяПоля];
		КвалификаторЧисла = Новый КвалификаторыЧисла(ОписаниеЧисла.Целое,ОписаниеЧисла.Дробное,ОписаниеЧисла.Знак);
	КонецЕсли; 
	
	Массив = Новый Массив();
	Массив.Добавить(ТипПоля);
	НашеОписание = Новый ОписаниеТипов(Массив,,,КвалификаторЧисла,КвалификаторСтроки);
	
	Элементы[ИмяПоля].ОграничениеТипа = НашеОписание;
	Объект[ИмяПоля] = НашеОписание.ПривестиЗначение(Объект[ИмяПоля]);
	
	УстановитьВидимостьИОформление(ТипПоля, ИмяПоля);

КонецПроцедуры // ()
 
&НаСервере
Процедура УстановитьВидимостьИОформление(ТипПоля, ИмяПоля)

	ТипПоляСправочника = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИменаСправочников[ИмяПоля]));
	
	ИмяКнопкиДобавитьСтроку = "ДобавитьСтроку"+ИмяПоля;
	ИмяКнопкиДобавитьЭлемент = "ДобавитьЭлемент"+ИмяПоля;
	
	Элементы[ИмяКнопкиДобавитьЭлемент].Видимость = НЕ РежимЗаявки И НЕ ТипПоля = ТипПоляСправочника;
	
	СвязанныеПоляСтруктура = Новый Структура;
	
	Если ПоляОтображаемыеТолькоВРежимеМакета.Свойство(ИмяПоля, СвязанныеПоляСтруктура) Тогда
		ЭтоМакет = Объект.ЭтоМакет;
		Элементы[ИмяПоля].Видимость = ЭтоМакет;
		Для каждого СвязанноеПоле Из СвязанныеПоляСтруктура Цикл
			ЗависитОтТипа = СвязанноеПоле.Значение;
			Если ЗависитОтТипа Тогда
				Видимость = ЭтоМакет И НЕ ТипПоля = ТипПоляСправочника;
			Иначе
				Видимость = ЭтоМакет;
			КонецЕсли;
			Элементы[СвязанноеПоле.Ключ].Видимость = Видимость;
		КонецЦикла; 
	КонецЕсли;
	
	Если ТипПоля = ТипПоляСправочника Тогда
		Элементы[ИмяКнопкиДобавитьСтроку].Картинка = БиблиотекаКартинок.ПереместитьВправоВниз;
		Элементы[ИмяПоля].ЦветФона = Новый Цвет(255, 255, 255);
		Элементы[ИмяПоля+"ID"].Заголовок = Объект[ИмяПоля][ПоляID[ИмяПоля]];
	Иначе
		Элементы[ИмяКнопкиДобавитьСтроку].Картинка = БиблиотекаКартинок.ПереместитьВлевоВверх;
		Элементы[ИмяПоля].ЦветФона = Новый Цвет(255, 192, 203);
		Элементы[ИмяПоля+"ID"].Заголовок = "";
	КонецЕсли;
	
КонецПроцедуры // УстановитьВидимостьИОформление()
 
&НаКлиенте
Процедура ПослеЗакрытияФормыНовогоЭлемента(Знач Результат, Знач ДополнительныеПараметры) Экспорт 
	
	Если НЕ ДополнительныеПараметры.Форма.Объект.Ссылка.Пустая() Тогда
		
		ИмяПоля = ДополнительныеПараметры.ИмяПоля;
		
		ТипПоля = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИменаСправочников[ИмяПоля]));
		
		ПривестиЗначениеКТипу(ТипПоля, ИмяПоля);
		
		Объект[ИмяПоля] = ДополнительныеПараметры.Форма.Объект.Ссылка;
		
		УстановитьВидимостьИОформление(ТипПоля, ИмяПоля);
		
	КонецЕсли; 
	
КонецПроцедуры // ПослеЗакрытияФормыНовогоЭлемента()

&НаСервереБезКонтекста
Функция ОтправитьНаСогласованиеНаСервере(Ссылка)

	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	БизнесПроцессСсылка = НайтиБизнесПроцесс(Ссылка);
	
	Если БизнесПроцессСсылка.Пустая() Тогда
		
		БизнесПроцесс = БизнесПроцессы.нсиВводНовогоЭлементаСправочника.СоздатьБизнесПроцесс();
		БизнесПроцесс.Автор = Автор;
		БизнесПроцесс.Дата = ТекущаяДата();
		БизнесПроцесс.ИмяСправочника = Ссылка.Метаданные().Имя;
		БизнесПроцесс.Предмет = Ссылка;
		
	Иначе
		БизнесПроцесс = БизнесПроцессСсылка.ПолучитьОбъект();
	КонецЕсли; 
	
	ПредметСтрокой = нсиБизнесПроцессы.ПредметСтрокой(Ссылка);
	
	БизнесПроцесс.Наименование 	= НСтр("ru = 'Создать'; en = 'Create'", "en")+" " 
		+ БизнесПроцесс.Предмет;
	
	БизнесПроцесс.ОписаниеЗадания 	= БизнесПроцесс.Наименование;
		
		
	БизнесПроцесс.ГруппаПользователейБП = нсиБизнеспроцессы.ПолучитьГруппуПользователейБППоУмолчанию(БизнесПроцесс.Автор);
	Если НЕ ЗначениеЗаполнено(БизнесПроцесс.ГруппаПользователейБП) Тогда 
		БизнесПроцесс.ГруппаПользователейБП = Справочники.нсиГруппыПользователейБП.Основная;
	КонецЕсли;
	
	МассивНастроек = нсиБизнесПроцессы.ПолучитьНастройкиБП(
		БизнесПроцесс.ИмяСправочника,
		"нсиВводНовогоЭлементаСправочника",
		Ссылка,
		Автор
	);
	
	Если МассивНастроек.Количество() = 1 Тогда 
		БизнесПроцесс.НастройкаБП = МассивНастроек[0];
	КонецЕсли;
	
	БизнесПроцесс.ЗаполнитьПрохождениеЭтапов();
	
	БизнесПроцесс.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗаявки.НаУтверждении");

	Успех = Ложь;
	Попытка
	
		БизнесПроцесс.Записать();
	
		БизнесПроцесс.Старт();
		
		Успех = Истина;
	
	Исключение
		
		Сообщить(ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
	
	КонецПопытки;
	
	Возврат Успех;

КонецФункции // ОтправитьНаСогласование()

&НаКлиенте
Процедура ОтправитьНаСогласование(Команда)
		
	//сбросим признак черновика
	Объект.Черновик = Ложь;
	
	Если Записать() Тогда
		
		Если ОтправитьНаСогласованиеНаСервере(Объект.Ссылка) Тогда
			
			ЗакрытьЗадачуЧерновик(Объект.Ссылка);
			
			ОповеститьОбИзменении(Тип("БизнесПроцессСсылка.нсиВводНовогоЭлементаСправочника"));
			
			Оповестить("ЗадачаВыполнена");
			
			УправляемоеЗакрытие = Истина;
			
			Закрыть();
			
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗакрытьЗадачуЧерновик(Ссылка)

	БизнесПроцессЧерновик = НайтиБизнесПроцесс(Ссылка);
	
	Если НЕ БизнесПроцессЧерновик.Пустая() Тогда
		
		ЗадачаЧерновик = НайтиЗадачу(БизнесПроцессЧерновик, Ссылка);
		
		Если НЕ ЗадачаЧерновик.Пустая()
			И НЕ ЗадачаЧерновик.Выполнена Тогда
			
			ЗадачаЧерновикОбъект = ЗадачаЧерновик.ПолучитьОбъект();
			ЗадачаЧерновикОбъект.ВыполнитьЗадачу();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры // ЗакрытьЗадачуЧерновик()

&НаКлиенте
Процедура СохранитьЧерновик(Команда)
	
	Объект.Черновик = Истина;
	Объект.ЭтоМакет = Истина;
	
	Если Записать() Тогда
	
		ПроверитьСоздатьЧерновикНаСервере(Объект.Ссылка);
	
		Оповестить("ЗадачаИзменена");
			
		УправляемоеЗакрытие = Истина;
		
		Закрыть();
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиБизнесПроцесс(Предмет)

	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	нсиВводНовогоЭлементаСправочника.Ссылка
		|ИЗ
		|	БизнесПроцесс.нсиВводНовогоЭлементаСправочника КАК нсиВводНовогоЭлементаСправочника
		|ГДЕ
		|	нсиВводНовогоЭлементаСправочника.Автор = &Автор
		|	И нсиВводНовогоЭлементаСправочника.Предмет = &Предмет
		|	И нсиВводНовогоЭлементаСправочника.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявки.Черновик)
		|	И нсиВводНовогоЭлементаСправочника.Завершен = ЛОЖЬ";
	
	Запрос.УстановитьПараметр("Автор", Автор);
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	БизнесПроцессСсылка = БизнесПроцессы.нсиВводНовогоЭлементаСправочника.ПустаяСсылка();
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		БизнесПроцессСсылка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат БизнесПроцессСсылка;

КонецФункции // НайтиБизнесПроцессЧерновик()

&НаСервереБезКонтекста
Функция НайтиЗадачу(БизнесПроцесс, Предмет)
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.Автор = &Автор
	|	И ЗадачаИсполнителя.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявки.Черновик)
	|	И ЗадачаИсполнителя.Предмет = &Предмет
	|	И ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	|	И ЗадачаИсполнителя.Выполнена = ЛОЖЬ
	|	И ЗадачаИсполнителя.Исполнитель = &Исполнитель";
	
	Запрос.УстановитьПараметр("Автор", Автор);
	Запрос.УстановитьПараметр("Исполнитель", Автор);
	Запрос.УстановитьПараметр("БизнесПроцесс", БизнесПроцесс);
	Запрос.УстановитьПараметр("Предмет", Предмет);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ЗадачаСсылка = Задачи.ЗадачаИсполнителя.ПустаяСсылка();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		ЗадачаСсылка = ВыборкаДетальныеЗаписи.Ссылка;
	КонецЕсли;
	
	Возврат ЗадачаСсылка;

КонецФункции // НайтиЗадачуЧерновик()()

&НаСервереБезКонтекста
Процедура ПроверитьСоздатьЧерновикНаСервере(Ссылка)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Автор = ПользователиКлиентСервер.ТекущийПользователь();
	
	БизнесПроцессЧерновик = НайтиБизнесПроцесс(Ссылка);
	
	Если НЕ БизнесПроцессЧерновик.Пустая() Тогда
		
		ЗадачаЧерновик = НайтиЗадачу(БизнесПроцессЧерновик, Ссылка);
		
		Если ЗадачаЧерновик.Пустая() Тогда
			
			НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
			НоваяЗадача.Автор = Автор;
			НоваяЗадача.БизнесПроцесс = БизнесПроцессЧерновик;
			НоваяЗадача.Дата = ТекущаяДата();
			НоваяЗадача.Исполнитель = Автор;
			НоваяЗадача.Наименование = НСтр("ru = 'New Products and Materials (Global)'; en = 'New Products and Materials (Global)'");
			НоваяЗадача.Предмет = Ссылка;
			НоваяЗадача.Статус = Перечисления.СтатусыЗаявки.Черновик;
			НоваяЗадача.Записать();
			
		КонецЕсли;
		
	Иначе
		
		БизнесПроцесс = БизнесПроцессы.нсиВводНовогоЭлементаСправочника.СоздатьБизнесПроцесс();
		БизнесПроцесс.Автор = Автор;
		БизнесПроцесс.Дата = ТекущаяДата();
		БизнесПроцесс.ИмяСправочника = Ссылка.Метаданные().Имя;
		БизнесПроцесс.Предмет = Ссылка;
		БизнесПроцесс.Статус = Перечисления.СтатусыЗаявки.Черновик;
		БизнесПроцесс.Записать();
		
		НоваяЗадача = Задачи.ЗадачаИсполнителя.СоздатьЗадачу();
		НоваяЗадача.Автор = Автор;
		НоваяЗадача.БизнесПроцесс = БизнесПроцесс.Ссылка;
		НоваяЗадача.Дата = ТекущаяДата();
		НоваяЗадача.Исполнитель = Автор;
		НоваяЗадача.Наименование = НСтр("ru = 'New Products and Materials (Global)'; en = 'New Products and Materials (Global)'");
		НоваяЗадача.Предмет = Ссылка;
		НоваяЗадача.Статус = Перечисления.СтатусыЗаявки.Черновик;
		НоваяЗадача.Записать();
		
	КонецЕсли;

КонецПроцедуры // ПроверитьСоздатьЗадачуНаСервере()
 
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.ЭтоМакет Тогда
		
		Ссылка = GlobalMDM.ЭлементСправочникаНайтиПоID(ИмяСправочникаLocal, Объект.LocalID);
		
		Если ТипЗнч(Ссылка) = Тип("Массив") Тогда
			ТекстОшибки = НСтр("ru = 'Существует более чем один элемент с таким локальным идентификатором.'; en = 'There is more than one item with such Local ID.'");
			Сообщить(ТекстОшибки, СтатусСообщения.Важное);
			СтатусТолькоПросмотр(Истина);
		Иначе
			СтатусТолькоПросмотр(ЗначениеЗаполнено(Ссылка));
		КонецЕсли; 
		
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ПолеПриИзменении(Элемент)
	
	ИмяПоля = Элемент.Имя;
	ТипПоляСправочника = Тип(СтрЗаменить("СправочникСсылка.ИмяСправочника", "ИмяСправочника", ИменаСправочников[ИмяПоля]));
	
	ТипПоля = ТипЗнч(Объект[ИмяПоля]);
	
	Если ТипПоля = ТипПоляСправочника Тогда
		УстановитьЗначенияСвязанныхПолей(ИмяПоля);
	КонецЕсли;
	
	УстановитьВидимостьИОформление(ТипПоля, ИмяПоля);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьЗначенияСвязанныхПолей(ИмяПоля)

	СвязанныеПоляСтруктура = Новый Структура;
	
	Если ПоляОтображаемыеТолькоВРежимеМакета.Свойство(ИмяПоля, СвязанныеПоляСтруктура) Тогда
		Для каждого СвязанноеПоле Из СвязанныеПоляСтруктура Цикл
			ЗависитОтТипа = СвязанноеПоле.Значение;
			Если ЗависитОтТипа Тогда
				РеквизитОсновногоПоля = "";
				Если РеквизитыСвязанныхПолей.Свойство(СвязанноеПоле.Ключ, РеквизитОсновногоПоля) Тогда
					Объект[СвязанноеПоле.Ключ] = ПолучитьЗначениеРеквизитаНаСервере(Объект[ИмяПоля], РеквизитОсновногоПоля);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры // УстановитьЗначенияСвязанныхПолей()
 
&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
		Объект.Наименование = СформироватьИмяНаСервере();
	КонецЕсли;
	
	Объект.ID = СформироватьИдентификаторНаСервере();
	
	ТекстОшибки = "";
	
	Если GlobalMDM.СвязьМеждуЭлементамиСуществует(ИмяРегистраСоответствия,ИмяСправочникаLocal,ИмяСправочникаGlobal,Объект.LocalID, Объект.ID, ТекстОшибки, Отказ, Объект.Ссылка) Тогда
	// если связь существует Отказ = Истина	
		Сообщить(ТекстОшибки, СтатусСообщения.Важное);
	
	КонецЕсли;
	
	Если НЕ НеактивныеСтатусы.НайтиПоЗначению(Объект.Status) = Неопределено Тогда
		ТекстОшибки = НСтр("ru = 'Отказ! Статус должен быть ACTIVE или NPD.'; en = 'Failure! The status should be ACTIVE or NPD.'");
		Сообщить(ТекстОшибки, СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура LocalIDАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//
	//Если ЗначениеЗаполнено(Текст) Тогда
	//	
	//	ДанныеВыбора = GlobalMDM.НайтиПоLocalID(ИмяСправочникаLocal, Текст);
	//	
	//КонецЕсли; 
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначениеРеквизитаНаСервере(Ссылка, ИмяРеквизита)

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);

КонецФункции // ПолучитьЗначениеРеквизитаНаСервере()

&НаКлиенте
Процедура СтатусТолькоПросмотр(ЭлементСуществует)

	Если ЗначениеЗаполнено(Объект.LocalID) Тогда
		Элементы.Status.ТолькоПросмотр = ЭлементСуществует;
	Иначе
		Элементы.Status.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры // СтатусТолькоПросмотр()

&НаКлиенте
Процедура LocalIDПриИзменении(Элемент)
	
	Ссылка = GlobalMDM.ЭлементСправочникаНайтиПоID(ИмяСправочникаLocal, Объект.LocalID);
	
	Если ТипЗнч(Ссылка) = Тип("Массив") Тогда
		ТекстОшибки = НСтр("ru = 'Существует более чем один элемент с таким локальным идентификатором.'; en = 'There is more than one item with such Local ID.'");
		Сообщить(ТекстОшибки, СтатусСообщения.Важное);
	Иначе
		
		Если ЗначениеЗаполнено(Ссылка) Тогда
			Объект.Status = ПолучитьЗначениеРеквизитаНаСервере(Ссылка, "Status");
		КонецЕсли;
		
		СтатусТолькоПросмотр(ЗначениеЗаполнено(Ссылка));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСуществованиеПоLocalID(ИмяСправочникаLocal, LocalID)

	ЭлементСсылка = GlobalMDM.ЭлементСправочникаНайтиПоID(ИмяСправочникаLocal, LocalID);
	Если ЗначениеЗаполнено(ЭлементСсылка) Тогда
		СообщениеПользователю = Новый СообщениеПользователю();
		СообщениеПользователю.Текст = НСтр("ru = 'Элемент с Local ID %1 уже существует. Вы не можете его использовать.'; en = 'Item with Local ID %1 already exist. You can''t use it.'");
		СообщениеПользователю.Текст = СтрЗаменить(СообщениеПользователю.Текст, "%1", LocalID);
		СообщениеПользователю.Поле = "Объект.LocalID";
		СообщениеПользователю.Сообщить();
		
		Объект.LocalID = Лев(LocalID, СтрДлина(LocalID)-1);
		
		ПроверитьСуществованиеПоLocalID(ИмяСправочникаLocal, Объект.LocalID)
		
	КонецЕсли;
	
	СтатусТолькоПросмотр(НЕ ЗначениеЗаполнено(Объект.LocalID));
	
КонецПроцедуры
 
&НаКлиенте
Процедура LocalIDОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	ПроверитьСуществованиеПоLocalID(ИмяСправочникаLocal, Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура LocalIDОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ПроверитьСуществованиеПоLocalID(ИмяСправочникаLocal, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Если Параметры.Ключ.Пустая() Тогда
	
		УправляемоеЗакрытие = Истина;
		
		Модифицированность = Ложь;
		
		Закрыть();
	
	КонецЕсли; 
	
	БизнесПроцессЧерновик = НайтиБизнесПроцесс(Объект.Ссылка);
	
	Если НЕ БизнесПроцессЧерновик.Пустая() Тогда
		
		Если НЕ GlobalMDM.ПолучитьРеквизитНаСервере(БизнесПроцессЧерновик, "Стартован") Тогда 
			ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаОтветаУдалитьЧерновик",ЭтаФорма, Новый Структура("БизнесПроцессЧерновик", БизнесПроцессЧерновик));
			ПоказатьВопрос(
			ОписаниеОповещения,
			НСтр("ru = 'Вы уверены, что хотите удалить черновик?'; en = 'Are you sure you want to delete the draft?'"),
			РежимДиалогаВопрос.ДаНет,,,НСтр("ru = 'Подтверждение удаления'; en = 'Confirmation of deletion'")
			);
		Иначе
			ПоказатьПредупреждение(,НСтр("ru = 'Запущенный бизнес-процесс удалить нельзя!'; en = 'The launched business process can not be deleted!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаУдалитьЧерновик(Результат, ДопПараметры) Экспорт 

	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьНаСервере(ДопПараметры.БизнесПроцессЧерновик);
		ОповеститьОбИзменении(Тип("ЗадачаСсылка.ЗадачаИсполнителя"));
		Оповестить("ЗадачаВыполнена");
		Модифицированность = Ложь;
		УправляемоеЗакрытие = Истина;
		Закрыть();
	КонецЕсли;

КонецПроцедуры // ОбработкаОтветаУдалитьЧерновик()

&НаСервере
Процедура УдалитьНаСервере(БизнесПроцессЧерновик)
	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		ЗадачаЧерновик = НайтиЗадачу(БизнесПроцессЧерновик, Объект.Ссылка);
		
		Если НЕ ЗадачаЧерновик.Пустая() Тогда
		
			ЗадачаЧерновик.ПолучитьОбъект().Удалить();
		
		КонецЕсли; 
		
		БизнесПроцессЧерновик.ПолучитьОбъект().Удалить();
		
		Объект.Ссылка.ПолучитьОбъект().Удалить();
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось удалить! "+ОписаниеОшибки());
		ОтменитьТранзакцию();
	КонецПопытки;
	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Объект.Черновик 
		И НЕ УправляемоеЗакрытие Тогда
		Отказ = Истина;
	КонецЕсли; 
КонецПроцедуры

НеактивныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.SKUStatuses.INACTIVE"));
НеактивныеСтатусы.Добавить(ПредопределенноеЗначение("Перечисление.SKUStatuses.DELISTED"));

ИмяРегистраСоответствия = "MappingGlobalAndLocalSKU";
ИмяСправочникаLocal = "нсиМТР";
ИмяСправочникаGlobal = "GlobalSKU";

КомандыПолейСправочниковСтрока = Новый Структура;
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуLocalName", "LocalName");
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуBrand", "Brand");
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуVolume", "Volume");
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуFactory", "Factory");
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуAlcoholContent", "AlcoholContent");
КомандыПолейСправочниковСтрока.Вставить("ДобавитьСтрокуAmount", "Amount");

КомандыПолейСправочниковЭлемент = Новый Структура;
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементLocalName", "LocalName");
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементBrand", "Brand");
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементVolume", "Volume");
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементFactory", "Factory");
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементAlcoholContent", "AlcoholContent");
КомандыПолейСправочниковЭлемент.Вставить("ДобавитьЭлементAmount", "Amount");

ТипыПолейСправочников = Новый Структура;
ТипыПолейСправочников.Вставить("LocalName", Тип("Строка"));
ТипыПолейСправочников.Вставить("Brand", Тип("Строка"));
ТипыПолейСправочников.Вставить("Volume", Тип("Число"));
ТипыПолейСправочников.Вставить("Factory", Тип("Строка"));
ТипыПолейСправочников.Вставить("AlcoholContent", Тип("Число"));
ТипыПолейСправочников.Вставить("Amount", Тип("Строка"));

ТипыПолейСправочниковСсылка = Новый Структура;
ТипыПолейСправочниковСсылка.Вставить("LocalName", Тип("Строка"));
ТипыПолейСправочниковСсылка.Вставить("Brand", Тип("Строка"));
ТипыПолейСправочниковСсылка.Вставить("Volume", Тип("Число"));
ТипыПолейСправочниковСсылка.Вставить("Factory", Тип("Строка"));
ТипыПолейСправочниковСсылка.Вставить("AlcoholContent", Тип("Число"));
ТипыПолейСправочниковСсылка.Вставить("Amount", Тип("Строка"));

ДлинаПолейСправочников = Новый Структура;
ДлинаПолейСправочников.Вставить("LocalName", 150);
ДлинаПолейСправочников.Вставить("Brand", 150);
ДлинаПолейСправочников.Вставить("Volume", Новый Структура("Целое, Дробное, Знак", 5, 3, ДопустимыйЗнак.Неотрицательный));
ДлинаПолейСправочников.Вставить("Factory", 50);
ДлинаПолейСправочников.Вставить("AlcoholContent", Новый Структура("Целое, Дробное, Знак", 3, 1, ДопустимыйЗнак.Неотрицательный));
ДлинаПолейСправочников.Вставить("Amount", 50);

ПоляПараметровНового = Новый Структура;
ПоляПараметровНового.Вставить("Brand", Новый Структура("НаименованиеНового, ГруппаНового", "Brand", "BrandGroup"));
ПоляПараметровНового.Вставить("Volume", Новый Структура("SizeNumberНового", "Volume"));
ПоляПараметровНового.Вставить("Factory", Новый Структура("НаименованиеНового", "Factory"));
ПоляПараметровНового.Вставить("AlcoholContent", Новый Структура("AlcoholContentNumberНового", "AlcoholContent"));
ПоляПараметровНового.Вставить("Amount", Новый Структура("НаименованиеНового", "Amount"));

ИменаСправочников = Новый Структура;
ИменаСправочников.Вставить("LocalName", "нсиМТР");
ИменаСправочников.Вставить("Brand", "GlobalBrand");
ИменаСправочников.Вставить("Volume", "GlobalVolume");
ИменаСправочников.Вставить("Factory", "GlobalFactory");
ИменаСправочников.Вставить("AlcoholContent", "GlobalAlcoholContent");
ИменаСправочников.Вставить("Amount", "GlobalAmount");

ИменаСправочниковGID = Новый Структура;
ИменаСправочниковGID.Вставить("Brand", "GlobalBrand");
ИменаСправочниковGID.Вставить("Volume", "GlobalVolume");
ИменаСправочниковGID.Вставить("Factory", "GlobalFactory");
ИменаСправочниковGID.Вставить("AlcoholContent", "GlobalAlcoholContent");
ИменаСправочниковGID.Вставить("Amount", "GlobalAmount");

ПоляID = Новый Структура;
ПоляID.Вставить("LocalName", "LocalID");
ПоляID.Вставить("Brand", "Код");
ПоляID.Вставить("Volume", "Код");
ПоляID.Вставить("Factory", "Код");
ПоляID.Вставить("AlcoholContent", "Код");
ПоляID.Вставить("Amount", "Код");

//Ключ - элемент формы, Значение - зависимость от типа
СвязанныеПоля = Новый Структура;
//СвязанныеПоля.Вставить("LocalID", Истина);
//СвязанныеПоля.Вставить("ГруппаLocalName", Ложь);

// Ключ - связанное поле формы, Значение - реквизит основного поля
РеквизитыСвязанныхПолей = Новый Структура;
//РеквизитыСвязанныхПолей.Вставить("LocalID", "LocalID");

ПоляОтображаемыеТолькоВРежимеМакета = Новый Структура;
//ПоляОтображаемыеТолькоВРежимеМакета.Вставить("LocalName", СвязанныеПоля); 
//ПоляОтображаемыеТолькоВРежимеМакета.Вставить("LocalID", СвязанныеПоля); 