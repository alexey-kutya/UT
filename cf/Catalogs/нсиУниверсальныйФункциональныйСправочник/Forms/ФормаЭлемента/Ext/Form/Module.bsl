﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	нсиУниверсальноеХранилищеФормыСервер.ПриСозданииНаСервере(ЭтаФорма);
	
	Элементы.Класс.Видимость = пМетаданные.ВидСправочника.ИспользоватьКлассификацию И НЕ Объект.пЭтоГруппа;
	Элементы.ГруппаТехническиеХарактеристики.Видимость = пМетаданные.ВидСправочника.ИспользоватьКлассификацию И НЕ Объект.пЭтоГруппа;
	
	ИспользоватьДопКлассификацию = пМетаданные.ВидСправочника.ИспользоватьДопКлассификацию И НЕ Объект.пЭтоГруппа;
	Если ИспользоватьДопКлассификацию тогда
		НовыйМассив = Новый Массив();
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ИспользуетсяДляСправочника", пМетаданные.ВидСправочника));
		Элементы.ДополнительнаяКлассификацияВидКлассификатора.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
		
		Элементы.ГруппаДополнительнаяКлассификация.Видимость = Истина;
	КонецЕсли;
		
	Элементы.ГруппаНСИ.Видимость = пМетаданные.ВидСправочника.ИспользоватьНормализацию И НЕ Объект.пЭтоГруппа;
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("Класс") Тогда 
		Если пМетаданные.СтандартныеРеквизиты.Класс.Тип.Тип1 = "Хранилище" Тогда 
			Если пМетаданные.СтандартныеРеквизиты.Класс.Тип.Тип2.ВидСправочника = Перечисления.нсиВидыСправочников.Классификатор Тогда 
				ПВ = новый Массив;
				ПВ.Добавить(новый ПараметрВыбора("Отбор.Владелец",пМетаданные.СтандартныеРеквизиты.Класс.Тип.Тип2));
				Элементы.Класс.ПараметрыВыбора = Новый ФиксированныйМассив(ПВ);
			Иначе
				ВызватьИсключение "Неправильный тип классификатора!";
			КонецЕсли;
		Иначе
			ВызватьИсключение "Неправильный тип классификатора!";
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьТехническиеХарактеристики();
	
	РегистрыСведений.нсиСтатусыОбработкиСправочников.ОпределитьДоступКФорме(
		Объект.Ссылка, ЭтотОбъект.ТолькоПросмотр, Объект.ЭтоМакет);
		
	УправлениеВидимостьюИДоступом();
	
	нсиРаботаСФормамиСервер.УправлениеВидимостьюОбработкиЗаявок(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) ИЛИ Объект.ЭтоМакет Тогда
		Если Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.ПустаяСсылка() или Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.Неопределено Тогда
			Объект.ТипПозиции = Перечисления.нсиТипыПозицийСправочников.ЭталоннаяПозиция;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Ссылка) и Объект.ЭтоМакет И пМетаданные.ИспользоватьЗаявки Тогда
		нсиРаботаСФормамиСервер.УстановитьДоступностьПолей(ЭтаФорма, Объект.Ссылка);
	КонецЕсли;	
	
	нсиВыделениеИзменений.ОформитьВыделениеИзменений(ЭтотОбъект);	
	
	нсиРаботаСФормамиСервер.УстановитьВидимостьКодов(ЭтаФорма);
	
	Если Элементы.Найти("ФормаЗаписатьИЗакрыть1") <> Неопределено тогда
		Элементы.ФормаЗаписатьИЗакрыть1.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
	Элементы.ТехническиеХарактеристикиФорма.ТолькоПросмотр = ЭтаФорма.ТолькоПросмотр;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Элементы.Найти("ФормаЗаписатьИЗакрыть1") <> Неопределено тогда
		Элементы.ФормаЗаписатьИЗакрыть1.КнопкаПоУмолчанию = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	нсиУниверсальноеХранилищеФормыСервер.ПередЗаписьюНаСервере(ЭтаФорма,ТекущийОбъект);
	
	ТекущийОбъект.ТехническиеХарактеристики.Загрузить(ТехническиеХарактеристикиФорма.Выгрузить());
	Объект.ТехническиеХарактеристики.Загрузить(ТехническиеХарактеристикиФорма.Выгрузить());

	ЗаполнитьТехническиеХарактеристики();
	
	// + проверки характеристик
	нсиОбщегоНазначенияВызовСервера.ПроверитьТехническиеХарактеристики(Объект.ТехническиеХарактеристики, Отказ);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	нсиУниверсальноеХранилищеФормыСервер.ПриЧтенииНаСервере(ЭтаФорма);
	ЗадаватьВопросПроУстановкуНаименования = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ЭтоМакет Тогда 
		КлючеваяОперация = "Запись макета элемента универсального справочника """+Строка(Объект.Владелец)+"""";
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	Иначе
		КлючеваяОперация = "Запись элемента универсального справочника """+Строка(Объект.Владелец)+"""";
		ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(КлючеваяОперация);
	КонецЕсли;
	
	Если пМетаданные.ИспользоватьКлассификацию Тогда 
		стрНаименования = ПолучитьНаименованиеПоШаблону();
		
		Если пМетаданные.СтандартныеРеквизиты.Свойство("Наименование") Тогда 
			Если НЕ ЗначениеЗаполнено(ЭтаФорма["Наименование"]) Тогда 
				ЭтаФорма["Наименование"] = стрНаименования.Наименование;
			КонецЕсли;
		КонецЕсли;
		
		Если пМетаданные.СтандартныеРеквизиты.Свойство("ПолноеНаименование") И НЕ Объект.пЭтоГруппа Тогда 
			Если НЕ ЗначениеЗаполнено(ЭтаФорма["ПолноеНаименование"]) Тогда 
				ЭтаФорма["ПолноеНаименование"] = стрНаименования.ПолноеНаименование;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("Наименование") Тогда 
		Объект.Наименование = ЭтаФорма["Наименование"];
	КонецЕсли;
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("ПолноеНаименование") И НЕ Объект.пЭтоГруппа  Тогда 
		Объект.ПолноеНаименование = ЭтаФорма["ПолноеНаименование"];
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	нсиУниверсальноеХранилищеФормыСервер.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма,Отказ);
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

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	нсиВыделениеИзменений.ОформитьВыделениеИзменений(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_СтрокуВверх(Команда)
	Имя = Сред(Команда.Имя, 25);
	ТЧ = ЭтаФорма[Имя];
	ТекСтрока = Элементы[Имя].ТекущаяСтрока;
	Если ТекСтрока=Неопределено Тогда
		Возврат;
	КонецЕсли;
	Индекс = ТЧ.Индекс(ТЧ.НайтиПоИдентификатору(ТекСтрока));
	Если Индекс=0 Тогда
		Возврат;
	КонецЕсли;
	Код = ТЧ[Индекс-1].Код;
	ТЧ[Индекс-1].Код = ТЧ[Индекс].Код;
	ТЧ[Индекс].Код = Код;
	ТЧ.Сдвинуть(Индекс, -1);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СтрокуВниз(Команда)
	Имя = Сред(Команда.Имя, 24);
	ТЧ = ЭтаФорма[Имя];
	ТекСтрока = Элементы[Имя].ТекущаяСтрока;
	Если ТекСтрока=Неопределено Тогда
		Возврат;
	КонецЕсли;
	Индекс = ТЧ.Индекс(ТЧ.НайтиПоИдентификатору(ТекСтрока));
	Если Индекс=ТЧ.Количество()-1 Тогда
		Возврат;
	КонецЕсли;
	Код = ТЧ[Индекс+1].Код;
	ТЧ[Индекс+1].Код = ТЧ[Индекс].Код;
	ТЧ[Индекс].Код = Код;
	ТЧ.Сдвинуть(Индекс, 1);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СортироватьВозр(Команда)
	Имя = Сред(Команда.Имя, 29);
	ТЧ = ЭтаФорма[Имя];
	ТекКолонка = Элементы[Имя].ТекущийЭлемент;
	ИмяРеквизита = Сред(ТекКолонка.Имя, СтрДлина(Имя)+1);
	ТЧ.Сортировать(ИмяРеквизита+" Возр");
	Номер = 1;
	Для каждого СтрокаТЧ Из ТЧ Цикл
		СтрокаТЧ.Код = Прав("    "+Формат(Номер, "ЧГ="), 4);
		Номер = Номер+1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СортироватьУбыв(Команда)
	Имя = Сред(Команда.Имя, 29);
	ТЧ = ЭтаФорма[Имя];
	ТекКолонка = Элементы[Имя].ТекущийЭлемент;
	ИмяРеквизита = Сред(ТекКолонка.Имя, СтрДлина(Имя)+1);
	ТЧ.Сортировать(ИмяРеквизита+" Убыв");
	Номер = 1;
	Для каждого СтрокаТЧ Из ТЧ Цикл
		СтрокаТЧ.Код = Прав("    "+Формат(Номер, "ЧГ="), 4);
		Номер = Номер+1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьОтличия(Команда)
	
	ПараметрыСравненияТаблиц = ВыделениеИзменений_ПараметрыСравненияТаблиц(Команда.Имя);
	
	Если ПараметрыСравненияТаблиц = Неопределено тогда
		Возврат
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.нсиФормаСравненияТабличныхЧастей", ПараметрыСравненияТаблиц, ЭтаФорма);
	
КонецПроцедуры	

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Команда)
	ЗаполнениеНаименованийПоШаблонуКласса(Истина);		
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(Команда)
	ЗаполнениеНаименованийПоШаблонуКласса();		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КлассПриИзменении(Элемент)
	КлассПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура КлассПриИзмененииНаСервере()
	ЗаполнитьТехническиеХарактеристики();
КонецПроцедуры

&НаКлиенте
Процедура ТипПозицииПриИзменении(Элемент)
	
	УправлениеВидимостьюИДоступом();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблица

&НаКлиенте
Процедура Подключаемый_ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если Копирование Тогда
		Элемент.ТекущиеДанные.пСсылка = нсиУниверсальноеХранилище.ПолучитьПустойИдентификатор();
	КонецЕсли;
	Если НоваяСтрока Тогда
		ТЧ = ЭтаФорма[Элемент.Имя];
		Элемент.ТекущиеДанные.Код = Прав("    "+Формат(ТЧ.Количество(), "ЧГ="), 4);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаПередУдалением(Элемент, Отказ)
	ТЧ = ЭтаФорма[Элемент.Имя];
	Индекс = ТЧ.Индекс(ТЧ.НайтиПоИдентификатору(Элемент.ТекущаяСтрока))+1;
	Пока Индекс<ТЧ.Количество() Цикл
		ТЧ[Индекс].Код = Прав("    "+Формат(Индекс, "ЧГ="), 4);
		Индекс = Индекс+1;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

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
Функция ПолучитьНаименованиеПоШаблону()
	Возврат нсиФормированиеНаименований.ПолучитьНаименованиеПоШаблонуУниверсальноеХранилище(Объект,ЭтотОбъект,Объект.Класс, ТехническиеХарактеристикиФорма.Выгрузить());
КонецФункции

&НаКлиенте
Процедура ЗаполнениеНаименованийПоШаблонуКласса(Закрыть = Ложь)
	
	стрНаименования = ПолучитьНаименованиеПоШаблону();
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("Наименование") 
		И Не ЗначениеЗаполнено(ЭтотОбъект["Наименование"]) тогда
		
		ЭтотОбъект["Наименование"] = стрНаименования.Наименование;
	КонецЕсли;
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("ПолноеНаименование") И НЕ Объект.пЭтоГруппа
		И Не ЗначениеЗаполнено(ЭтотОбъект["ПолноеНаименование"]) тогда
		
		ЭтотОбъект["ПолноеНаименование"] = стрНаименования.ПолноеНаименование;	
	КонецЕсли;	
	
	ПараметрыВопроса = Новый Структура;
	ПараметрыВопроса.Вставить("Закрыть",  Закрыть);
	
	ЧастиТекстаВопроса = Новый Массив;
	Если пМетаданные.СтандартныеРеквизиты.Свойство("Наименование")
		И ЗначениеЗаполнено(ЭтотОбъект["Наименование"])
		И ЗначениеЗаполнено(стрНаименования.Наименование)
		И Не ЭтотОбъект["Наименование"] = стрНаименования.Наименование тогда
		ЧастиТекстаВопроса.Добавить("наименование """+стрНаименования.Наименование+"""");
		
		ПараметрыВопроса.Вставить("Наименование", стрНаименования.Наименование);
	КонецЕсли;	
	
	Если пМетаданные.СтандартныеРеквизиты.Свойство("ПолноеНаименование") И НЕ Объект.пЭтоГруппа
		И ЗначениеЗаполнено(ЭтотОбъект["ПолноеНаименование"])
		И ЗначениеЗаполнено(стрНаименования.ПолноеНаименование)
		И Не ЭтотОбъект["ПолноеНаименование"] = стрНаименования.ПолноеНаименование тогда
		
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
        ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДополнительныеПараметры);
	КонецЕсли;
	
	Если Записать() Тогда 
		Модифицированность = Ложь;
		
		Если ДополнительныеПараметры.Закрыть тогда
			Закрыть();
		КонецЕсли;	
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
					|	ТекущиеХарактеристики.Значение КАК Значение,
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
	
	ОткрытьФорму("ПланВидовХарактеристик.нсиХарактеристикиУниверсальногоСправочника.Форма.ФормаЭлемента",ПараметрыОткрытия,ЭтаФорма);	

КонецПроцедуры

#КонецОбласти


