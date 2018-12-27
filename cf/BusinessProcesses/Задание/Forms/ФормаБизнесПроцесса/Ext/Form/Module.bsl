﻿
#Область ОбработчикиСобытийФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НачальныйПризнакСтарта = Объект.Стартован;
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = нсиБизнесПроцессы.ПредметСтрокой(Объект.Предмет);	
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
	
	нсиРаботаСФормамиСервер.УстановитьТипПредмета(Объект.Предмет, Элементы.ПризнакЭлемента);
	УправлениеВидимостьюИДоступом();
КонецПроцедуры

Процедура УправлениеВидимостьюИДоступом()
	ТолькоПросмотр = ТолькоПросмотр ИЛИ Объект.Стартован;
	Элементы.ФормаСтартИЗакрыть.Доступность = НЕ ТолькоПросмотр;
	Элементы.ФормаУдалить.Доступность = НЕ ТолькоПросмотр;
	Элементы.ФормаЗаписать.Доступность = НЕ ТолькоПросмотр;
	Элементы.Дата.Видимость = Объект.Стартован;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ПредыдущийИсполнитель = ТекущийОбъект.Автор;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ЗаданиеИзменено", Объект.Ссылка);
	Оповестить("ЗадачаИзменена", Неопределено);
	Оповестить("ИзменилсяСписокБП");
	УправлениеВидимостьюИДоступом();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ


&НаКлиенте
Процедура НаПроверкеПриИзменении(Элемент)
	
	ДоступностьПоля = Объект.НаПроверке;
	
	Элементы.ГруппаПроверяющий.Доступность = ДоступностьПоля;
	Элементы.Проверяющий.АвтоОтметкаНезаполненного = ДоступностьПоля;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	Если ТипЗнч(Объект.Предмет) = Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
		нсиБизнесПроцессыИЗадачиКлиент.ОткрытьФормуВыполненияЗадачи(Объект.Предмет);
	Иначе	
		ПоказатьЗначение(,Объект.Предмет);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СрокПроверкиПриИзменении(Элемент)
	Если Объект.СрокПроверки = НачалоДня(Объект.СрокПроверки) Тогда
		Объект.СрокПроверки = КонецДня(Объект.СрокПроверки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)
	Если НЕ Объект.Стартован Тогда 
		ОписаниеОповещения = новый ОписаниеОповещения("ОбработкаОтветаУдалитьЗадание",ЭтаФорма);
		ПоказатьВопрос(
			ОписаниеОповещения,
			"Вы уверены, что хотите удалить задание?",
			РежимДиалогаВопрос.ДаНет,,,"Подтверждение удаления"
		);
	Иначе
		ПоказатьПредупреждение(,"Запущенный бизнес-процесс удалить нельзя!");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаУдалитьЗадание(Результат,ДП) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
			УдалитьНаСервере();
			ОповеститьОбИзменении(Тип("БизнесПроцессСсылка.Задание"));
			Оповестить("ИзменилсяСписокБП");
			Модифицированность = Ложь;
			Закрыть();
		Иначе
			Модифицированность = Ложь;
			Закрыть();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

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

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	Объект.Дата = ТекущаяДата();
	
	Если ЗаписатьВыполнить() Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ЗаписатьВыполнить()
	
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

#КонецОбласти