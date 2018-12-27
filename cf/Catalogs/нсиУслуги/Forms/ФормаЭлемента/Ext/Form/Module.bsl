﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТехническиеХарактеристики();
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеСвойства");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства

		
	РегистрыСведений.нсиСтатусыОбработкиСправочников.ОпределитьДоступКФорме(
		Объект.Ссылка, ЭтаФорма.ТолькоПросмотр, Объект.ЭтоМакет);
		
	УправлениеВидимостьюИДоступом();
	
	// @Комментарий: Вызовем процедуру установки функциональных опций.
	нсиРаботаСФормамиСервер.УправлениеВидимостьюОбработкиЗаявок(ЭтаФорма);
	Если не ЗначениеЗаполнено(Объект.Ссылка) или Параметры.ВременныйЭлемент Тогда
		Если Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.ПустаяСсылка() или Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.Неопределено Тогда
			Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.ЭталоннаяПозиция;
		КонецЕсли;
		Элементы.ГруппаНСИ.Видимость = Ложь;
	КонецЕсли;	
	
	нсиВыделениеИзменений.ОформитьВыделениеИзменений(ЭтотОбъект);
	
	нсиРаботаСФормамиСервер.УстановитьВидимостьКодов(ЭтаФорма);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) и Объект.ЭтоМакет Тогда
		нсиРаботаСФормамиСервер.УстановитьДоступностьПолей(ЭтаФорма, Объект.Ссылка);
	КонецЕсли;
	
	Элементы.ТехническиеХарактеристикиФорма.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	ЗаполнитьСписокНаименованийСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	Если ВладелецФормы = Неопределено Тогда 
		ВедетсяОбработка = Ложь; 
	Иначе 	
		ВедетсяОбработка = 
			(ВладелецФормы.Имя = "СписокБуфера" ИЛИ 
			ВладелецФормы.Имя = "СписокЗагруженных" ИЛИ 
			ВладелецФормы.Имя = "СписокОбработанных");
	КонецЕсли;	
		
	Если ВедетсяОбработка И Не ЗначениеЗаполнено(Объект.ТипПозиции) Тогда 
		Объект.ТипПозиции = ПредопределенноеЗначение("Перечисление.нсиТипыПозицийСправочников.ЭталоннаяПозиция");	
	КонецЕсли;	
	
	Если НЕ Элементы.Найти("ФормаЗаписатьИЗакрыть1") = Неопределено тогда
		Элементы.ФормаЗаписатьИЗакрыть1.КнопкаПоУмолчанию = Истина;
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	нсиРаботаСФормами.СократитьПробелыТекстовыхПолей(ТекущийОбъект);
	
	ТекущийОбъект.ТехническиеХарактеристики.Загрузить(ТехническиеХарактеристикиФорма.Выгрузить());
	Объект.ТехническиеХарактеристики.Загрузить(ТехническиеХарактеристикиФорма.Выгрузить());
	
	ЗаполнитьТехническиеХарактеристики();
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// + проверки характеристик
	нсиОбщегоНазначенияВызовСервера.ПроверитьТехническиеХарактеристики(Объект.ТехническиеХарактеристики, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ПеренестиДублиКНовомуЭталону();
	
	Если ВедетсяОбработка Тогда 
		РегистрыСведений.нсиСтатусыОбработкиСправочников.УстановитьСтатусСправочника(ТекущийОбъект.Ссылка,
			Новый Структура("Пользователь,ОбработкаНачата", ПараметрыСеанса.ТекущийПользователь, Истина) );	
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	нсиВыделениеИзменений.ОформитьВыделениеИзменений(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
	    ОбновитьЭлементыДополнительныхРеквизитов();
	    УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Модифицированность тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			"Данные были изменены. Сохранить изменения?", 
			РежимДиалогаВопрос.ДаНетОтмена);		
			
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да тогда
		ЗаполнениеНаименованийПоШаблонуКласса(Истина);
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.ЭтоМакет Тогда 
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("Запись макета элемента справочника ""Услуги""");
	Иначе
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("Запись элемента справочника ""Услуги""");
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПозицииПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступом();
	
КонецПроцедуры

&НаКлиенте
Процедура КлассПриИзменении(Элемент)
	
	ЗаполнитьТехническиеХарактеристики();
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.ПолноеНаименование) Тогда 
		Объект.ПолноеНаименование = ""+Объект.Наименование;
	КонецЕсли;
	
	ЗаполнитьСписокНаименованийКлиент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
    УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ЗаписатьНаКлиенте(Команда)
	
	ЗаполнениеНаименованийПоШаблонуКласса();		
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Команда)
	
	ЗаполнениеНаименованийПоШаблонуКласса(Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьОтличия(Команда)
	
	ПараметрыСравненияТаблиц = ВыделениеИзменений_ПараметрыСравненияТаблиц(Команда.Имя);
	
	Если ПараметрыСравненияТаблиц = Неопределено тогда
		Возврат
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.нсиФормаСравненияТабличныхЧастей", ПараметрыСравненияТаблиц, ЭтаФорма);
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСписокНаименованийКлиент()
	Элементы.ПолноеНаименование.СписокВыбора.Очистить();
	Элементы.ПолноеНаименование.СписокВыбора.Добавить(""+Объект.Наименование);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНаименованийСервер()
	Элементы.ПолноеНаименование.СписокВыбора.Очистить();
	Элементы.ПолноеНаименование.СписокВыбора.Добавить(""+Объект.Наименование);
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
    УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
    УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура УправлениеВидимостьюИДоступом()
	
	Элементы.ЭталоннаяПозиция.Доступность = 
		(Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.ДублирующаяПозиция);
	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьТехническиеХарактеристики()
	
	пЭтотОбъект = РеквизитФормыВЗначение("Объект");
	ХарактеристикиОбновлены = пЭтотОбъект.ПроверитьЗаполнитьТехническиеХарактеристики();
	ЗначениеВРеквизитФормы(пЭтотОбъект, "Объект");  
	
	//Если ХарактеристикиОбновлены Тогда 
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Обновлены технические характеристики.");
	//КонецЕсли;
	
	ОбновитьТехническиеХарактеристикиНаФорме();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьНаименованиеПоШаблонуНаСервере()
	Возврат нсиФормированиеНаименований.ПолучитьНаименованиеПоШаблону(ЭтотОбъект)
КонецФункции	

&НаКлиенте
Процедура ЗаполнениеНаименованийПоШаблонуКласса(Закрыть = Ложь)
	
	стрНаименования = ПолучитьНаименованиеПоШаблонуНаСервере();
	
	Если Не ЗначениеЗаполнено(Объект.Наименование) тогда
		Объект.Наименование = стрНаименования.Наименование;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект.ПолноеНаименование) тогда
		Объект.ПолноеНаименование = стрНаименования.ПолноеНаименование;	
	КонецЕсли;	
	
	ПараметрыВопроса = Новый Структура;
	ПараметрыВопроса.Вставить("Закрыть",  Закрыть);
	
	ЧастиТекстаВопроса = Новый Массив;
	Если ЗначениеЗаполнено(Объект.Наименование)
		И ЗначениеЗаполнено(стрНаименования.Наименование)
		И Не Объект.Наименование = стрНаименования.Наименование тогда
		ЧастиТекстаВопроса.Добавить("наименование """+стрНаименования.Наименование+"""");
		
		ПараметрыВопроса.Вставить("Наименование", стрНаименования.Наименование);
	КонецЕсли;	
	Если ЗначениеЗаполнено(Объект.ПолноеНаименование)
		И ЗначениеЗаполнено(стрНаименования.ПолноеНаименование)
		И Не Объект.ПолноеНаименование = стрНаименования.ПолноеНаименование тогда
		ЧастиТекстаВопроса.Добавить("полное наименование """+стрНаименования.ПолноеНаименование+"""");
		
		ПараметрыВопроса.Вставить("ПолноеНаименование", стрНаименования.ПолноеНаименование);
	КонецЕсли;	
	
	Если ЧастиТекстаВопроса.ВГраница() > -1 тогда
		ТекстВопроса = "Установить " + ЧастиТекстаВопроса[0];
		Для Инд = 1 по ЧастиТекстаВопроса.ВГраница()  цикл
			ТекстВопроса = ТекстВопроса + " и " + ЧастиТекстаВопроса[Инд];
		КонецЦикла;	
		ТекстВопроса = ТекстВопроса + " согласно шаблону?";
				
        ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнениеНаименованийПоШаблонуКлассаЗавершение", ЭтотОбъект, ПараметрыВопроса);
        ПоказатьВопрос(ОписаниеОповещения, СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1'"), ТекстВопроса), РежимДиалогаВопрос.ДаНет);
	Иначе 
		ЗаполнениеНаименованийПоШаблонуКлассаЗавершение(КодВозвратаДиалога.Нет, ПараметрыВопроса);	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеНаименованийПоШаблонуКлассаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ДополнительныеПараметры.Свойство("Наименование") тогда
			НаименованиеДоИзменения = Объект.Наименование;
			ЗаполнитьЗначенияСвойств(Объект, ДополнительныеПараметры);
			Если НЕ Объект.Наименование = ДополнительныеПараметры.Наименование тогда
				Объект.Наименование = НаименованиеДоИзменения;
				Если ДополнительныеПараметры.Закрыть тогда
					ПоказатьОповещениеПользователя("Информация:",,"Установка наименования по шаблону не выполнена: превышена максимальная длина строки.");	
				Иначе 
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Установка наименования по шаблону не выполнена: превышена максимальная длина строки.");
				КонецЕсли;	
			КонецЕсли;	
		Иначе 
			ЗаполнитьЗначенияСвойств(Объект, ДополнительныеПараметры);
		КонецЕсли;	
	КонецЕсли;
	
	ЗаполнитьСписокНаименованийКлиент();
	
	Записать();
	
	Если ДополнительныеПараметры.Закрыть тогда
		Закрыть();
	КонецЕсли;	
	
КонецПроцедуры	

&НаСервере
Процедура ОбновитьТехническиеХарактеристикиНаФорме()
	
	// Читаем данные не с записанного объекта а с текущего объекта,
	// т.к. при открытии технические характеристики могли быть восстановлены.
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
					|	Тех.Характеристика,	
					|	Тех.Значение	
					|ПОМЕСТИТЬ ТекущиеХарактеристики
					|ИЗ
					|	&ТехническиеХарактеристики КАК Тех
					|;
					|ВЫБРАТЬ
					|	ТекущиеХарактеристики.Характеристика КАК Характеристика,
					|	ТекущиеХарактеристики.Значение	КАК Значение,
					|	ТекущиеХарактеристики.Характеристика.ПометкаУдаления КАК ХарактеристикаПометкаУдаления
					|ИЗ
					|	ТекущиеХарактеристики КАК ТекущиеХарактеристики
					|УПОРЯДОЧИТЬ ПО
					|	ТекущиеХарактеристики.Характеристика.ПорядокСортировки ВОЗР,
					|	ТекущиеХарактеристики.Характеристика.Наименование ВОЗР";
	Запрос.УстановитьПараметр("ТехническиеХарактеристики", Объект.ТехническиеХарактеристики.Выгрузить());
	рез = Запрос.Выполнить();
	Если не рез.Пустой() Тогда
		ТехническиеХарактеристикиФорма.Загрузить(рез.Выгрузить());
	Иначе 
		ТехническиеХарактеристикиФорма.Очистить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТехническиеХарактеристикиФормаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаСервере
Функция ВыделениеИзменений_ПараметрыСравненияТаблиц(ИмяКоманды)
	Возврат нсиВыделениеИзменений.ПараметрыСравненияТаблиц(ЭтотОбъект, ИмяКоманды);
КонецФункции

&НаКлиенте
Процедура ТехническиеХарактеристикиФормаХарактеристикаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элементы.ТехническиеХарактеристикиФорма.ТекущиеДанные.Характеристика);
	ПараметрыОткрытия.Вставить("БезРедактирования", Истина);
	
	ОткрытьФорму("ПланВидовХарактеристик.нсиХарактеристикиУслуг.Форма.ФормаЭлемента",ПараметрыОткрытия,ЭтаФорма);	

КонецПроцедуры

#КонецОбласти

