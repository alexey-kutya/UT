﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Параметры.ДопустимыеИсполнители) Тогда 
		ФиксированныйМассивДопустимыхИсполнителей = Новый ФиксированныйМассив(Параметры.ДопустимыеИсполнители);
		ПараметрВыбора = Новый ПараметрВыбора("Отбор.Ссылка",ФиксированныйМассивДопустимыхИсполнителей);
		МассивОтбора = Новый Массив;
		МассивОтбора.Добавить(ПараметрВыбора);
		ФиксированныйМассивОтбора = Новый ФиксированныйМассив(МассивОтбора) ;
		Элементы.Исполнитель.ПараметрыВыбора = ФиксированныйМассивОтбора;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	Если Не ЗначениеЗаполнено(Исполнитель) Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран исполнитель.");
		Возврат;
	КонецЕсли;	
	
	Закрыть(новый Структура("Исполнитель,Комментарий",Исполнитель,Комментарий));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти
