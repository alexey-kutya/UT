﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Свойства"
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Заполняет наборы свойств объекта. Обычно требуется, если наборов более одного.
//
// Параметры:
//  Объект       - Ссылка на владельца свойств.
//                 Объект владельца свойств.
//                 ДанныеФормыСтруктура (по типу объекта владельца свойств).
//
//  ТипСсылки    - Тип - тип ссылки владельца свойств.
//
//  НаборыСвойств - ТаблицаЗначений с колонками:
//                    Набор - СправочникСсылка.НаборыДополнительныхРеквизитовИСведений.
//
//                    // Далее свойства элемента формы типа ГруппаФормы вида обычная группа
//                    // или страница, которая создается, если наборов больше одного без учета
//                    // пустого набора, который описывает свойства группы удаленных реквизитов.
//                    
//                    // Если значение Неопределено, значит использовать значение по умолчанию.
//                    
//                    // Для любой группы управляемой формы.
//                    Высота                   - Число.
//                    Заголовок                - Строка.
//                    Подсказка                - Строка.
//                    РастягиватьПоВертикали   - Булево.
//                    РастягиватьПоГоризонтали - Булево.
//                    ТолькоПросмотр           - Булево.
//                    ЦветТекстаЗаголовка      - Цвет.
//                    Ширина                   - Число.
//                    ШрифтЗаголовка           - Шрифт.
//                    
//                    // Для обычной группы и страницы.
//                    Группировка              - ГруппировкаПодчиненныхЭлементовФормы.
//                    
//                    // Для обычной группы.
//                    Отображение                - ОтображениеОбычнойГруппы.
//                    ШиринаПодчиненныхЭлементов - ШиринаПодчиненныхЭлементовФормы.
//                    
//                    // Для страницы.
//                    Картинка                 - Картинка.
//                    ОтображатьЗаголовок      - Булево.
//
//  СтандартнаяОбработка - Булево - начальное значение Истина. Указывает получать ли
//                         основной набор, когда НаборыСвойств.Количество() равно нулю.
//
//  КлючНазначения   - Неопределено - (начальное значение) - указывает вычислить
//                      ключ назначения автоматически и добавить к значениям свойств
//                      формы КлючНазначенияИспользования и КлючСохраненияПоложенияОкна,
//                      чтобы изменения формы (настройки, положение и размер) сохранялись
//                      отдельно для разного состава наборов.
//                      Например, для каждого вида номенклатуры - свой состав наборов.
//
//                    - Строка - (не более 32 символа) - использовать указанный ключ
//                      назначения для добавления к значениям свойств формы.
//                      Пустая строка - не изменять свойства ключей формы, т.к. они
//                      устанавливается в форме и уже учитывают различия состава наборов.
//
//                    Добавка имеет формат "КлючНаборовСвойств<КлючНазначения>",
//                    чтобы <КлючНазначения> можно было обновлять без повторной добавки.
//                    При автоматическом вычислении <КлючНазначения> содержит хэш
//                    идентификаторов ссылок упорядоченных наборов свойств.
//
Процедура ЗаполнитьНаборыСвойствОбъекта(Объект, ТипСсылки, НаборыСвойств, СтандартнаяОбработка, КлючНазначения) Экспорт
	
	Если ТипСсылки = Тип("СправочникСсылка.нсиБанки") Тогда
        ЗаполнитьНаборСвойствПоВидуНоменклатуры(
            Объект, ТипСсылки, НаборыСвойств);
    КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаборСвойствПоВидуНоменклатуры(Объект, ТипСсылки, НаборыСвойств)
	Если ТипЗнч(Объект) = Тип("ДанныеФормыСтруктура") Тогда
		Возврат;	
	КонецЕсли;
		
	Реквизиты = Объект.Метаданные().Реквизиты;
	ИменаРеквизитов = ""; 
	Для Каждого Реквизит Из Реквизиты Цикл
		ИменаРеквизитов = ИменаРеквизитов+Реквизит.Имя+", ";	
	КонецЦикла;
	ИменаРеквизитов = Лев(ИменаРеквизитов,СтрДлина(ИменаРеквизитов)-2);
	ИменаРеквизитов = "Ссылка, ЭтоГруппа, "+ИменаРеквизитов;  
	
	Если ТипЗнч(Объект) = ТипСсылки Тогда
        Объект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
            Объект, ИменаРеквизитов);
    КонецЕсли;
	
КонецПроцедуры

// Устанавливает отборы для элементов дополнительных реквизитов, имеющие тип универсальное хранилище.
//
// Параметры:
//  Форма       - Форма элемента справочника с добавленными дополнительными реквизитами.
//
Процедура нсиДополнитьОтборамиУниверсальногоХранилища(Форма) Экспорт 
	ОписаниеСвойств = Форма.Свойства_ОписаниеДополнительныхРеквизитов;
	Для каждого ОписаниеСвойства Из ОписаниеСвойств Цикл
		ТипЗначенияСвойства = ОписаниеСвойства.ТипЗначения;
		Если ТипЗначенияСвойства.СодержитТип(Тип("СправочникСсылка.нсиУниверсальныйФункциональныйСправочник"))  
			Или ТипЗначенияСвойства.СодержитТип(Тип("СправочникСсылка.нсиУниверсальныйКлассификатор")) Тогда 
			
			ЭлементФормы = Форма.Элементы[ОписаниеСвойства.ИмяРеквизитаЗначение];
			НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", ОписаниеСвойства.Свойство.нсиВидСправочника);
			МассивПараметрыВыбора = Новый Массив();
			МассивПараметрыВыбора.Добавить(НовыйПараметр);
			ЭлементФормы.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметрыВыбора);

		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
