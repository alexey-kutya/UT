﻿
#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////
// Выделение изменений

Функция СписокРеквизитовВыделенияИзменений() Экспорт
	Возврат Неопределено	
КонецФункции	

Функция СписокРеквизитовИсключенийВыделенияИзменений() Экспорт
	Возврат "Код"
КонецФункции	

Функция НастройкиОформленияВыделенияИзмененийТабличныхЧастей() Экспорт
	
	Настройки_ДополнительнаяКлассификация = Новый Структура;
	Настройки_ДополнительнаяКлассификация.Вставить("КлючСтроки", "ВидКлассификатора,Класс");
	Настройки_ДополнительнаяКлассификация.Вставить("Реквизиты" , "");
	Настройки_ДополнительнаяКлассификация.Вставить("Элемент"   , "ДополнительнаяКлассификация");
	
	НастройкиОформления = Новый Структура;
	НастройкиОформления.Вставить("ДополнительнаяКлассификация"   , Настройки_ДополнительнаяКлассификация);
	
	Возврат НастройкиОформления
	
КонецФункции

#КонецОбласти
