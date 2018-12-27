﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(ЭтаФорма,Параметры,
		"ВремяОбработки,
		|ВремяОжидания,
		|ОповещатьПриОбработкеЗа,
		|ОповещатьПриОжиданииЗа"
	);
	ОбщееВремяЭтапа = ВремяОбработки + ВремяОжидания;
КонецПроцедуры


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Если ВремяОбработки<ОповещатьПриОбработкеЗа Тогда 
		ТекстСообщения = "Время обработки не может быть меньше времени, за которое выполняется оповещение!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если ВремяОжидания<ОповещатьПриОжиданииЗа Тогда 
		ТекстСообщения = "Время ожидания не может быть меньше времени, за которое выполняется оповещение!";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ВремяОбработки",ВремяОбработки);
	Результат.Вставить("ВремяОжидания",ВремяОжидания);
	Результат.Вставить("ОповещатьПриОбработкеЗа",ОповещатьПриОбработкеЗа);
	Результат.Вставить("ОповещатьПриОжиданииЗа",ОповещатьПриОжиданииЗа);
	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВремяОжиданияПриИзменении(Элемент)
	ОбщееВремяЭтапа = ВремяОбработки + ВремяОжидания;
КонецПроцедуры

&НаКлиенте
Процедура ВремяОбработкиПриИзменении(Элемент)
	ОбщееВремяЭтапа = ВремяОбработки + ВремяОжидания;
КонецПроцедуры

#КонецОбласти
