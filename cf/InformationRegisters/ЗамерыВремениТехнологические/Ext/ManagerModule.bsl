﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТопAPDEX(ДатаНачала, ДатаОкончания, ПериодАгрегации, Количество) Экспорт
	Запрос = Новый Запрос;
	
	Если Количество > 0 Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	КлючевыеОперации.Ссылка КАК КлючеваяОперацияСсылка,
		|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	КОЛИЧЕСТВО(*) КАК КоличествоЗамеров,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T
		|ПОМЕСТИТЬ
		|	Выборка
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК КлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = КлючевыеОперации.Ссылка
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	КлючевыеОперации.Ссылка,
		|	КлючевыеОперации.ЦелевоеВремя
		|;
		|ВЫБРАТЬ
		|	СУММА(КоличествоЗамеров) КАК КоличествоЗамеров
		|ПОМЕСТИТЬ
		|	ВсегоЗамеров
		|ИЗ
		|	Выборка
		|;
		|ВЫБРАТЬ ПЕРВЫЕ %Количество
		|	Выборка.КлючеваяОперацияСсылка,
		|	Выборка.ЦелевоеВремя,
		|	Выборка.КоличествоЗамеров,
		|	ВЫРАЗИТЬ((Выборка.N_T + Выборка.N_T_4T/2)/Выборка.КоличествоЗамеров КАК ЧИСЛО(15,3)) КАК APDEX,
		|	ВЫРАЗИТЬ((Выборка.N_4T + Выборка.N_T_4T/2)/ВсегоЗамеров.КоличествоЗамеров КАК ЧИСЛО(15,3)) КАК APDEXВлияние
		|ПОМЕСТИТЬ
		|	ВыборкаХудшиеОперации
		|ИЗ
		|	Выборка
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ВсегоЗамеров
		|ПО
		|	НЕ ВсегоЗамеров.КоличествоЗамеров IS NULL
		|УПОРЯДОЧИТЬ ПО
		|	(Выборка.N_4T + Выборка.N_T_4T/2)/ВсегоЗамеров.КоличествоЗамеров УБЫВ
		|;
		|ВЫБРАТЬ
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Период,
		|	СпрКлючевыеОперации.Наименование КАК КлючеваяОперация,
		|	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения <= КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > КлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > 4 * КлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	ВыборкаХудшиеОперации КАК КлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = КлючевыеОперации.КлючеваяОперацияСсылка
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК СпрКлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = СпрКлючевыеОперации.Ссылка
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
		|	СпрКлючевыеОперации.Наименование,
		|	КлючевыеОперации.ЦелевоеВремя
		|УПОРЯДОЧИТЬ ПО
		|   ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|;";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "%Количество", Формат(Количество, "ЧН=0; ЧГ="));
	Иначе
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200) КАК Период,
		|	СпрКлючевыеОперации.Наименование КАК КлючеваяОперация,
		|	СпрКлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения <= СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > СпрКлючевыеОперации.ЦелевоеВремя И Замеры.ВремяВыполнения <= 4 * СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_T_4T,
		|	СУММА(ВЫБОР
		|		КОГДА Замеры.ВремяВыполнения > 4 * СпрКлючевыеОперации.ЦелевоеВремя ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ) КАК N_4T
		|ИЗ
		|	РегистрСведений.ЗамерыВремениТехнологические КАК Замеры
		|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
		|	Справочник.КлючевыеОперации КАК СпрКлючевыеОперации
		|ПО
		|	Замеры.КлючеваяОперация = СпрКлючевыеОперации.Ссылка
		|ГДЕ
		|	Замеры.ДатаНачалаЗамера МЕЖДУ &ДатаНачала И &ДатаОкончания
		|СГРУППИРОВАТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200),
		|	СпрКлючевыеОперации.Наименование,
		|	СпрКлючевыеОперации.ЦелевоеВремя
		|УПОРЯДОЧИТЬ ПО
		|	ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(2015,1,1),СЕКУНДА, ВЫРАЗИТЬ((РАЗНОСТЬДАТ(ДАТАВРЕМЯ(2015,1,1), Замеры.ДатаНачалаЗамера, СЕКУНДА) + 63555667200)/&ПериодАгрегации - 0.5 КАК ЧИСЛО(11,0)) * &ПериодАгрегации - 63555667200)
		|;";
		Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
		Запрос.УстановитьПараметр("ПериодАгрегации", ПериодАгрегации);
	КонецЕсли;
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
КонецФункции

#КонецОбласти

#КонецЕсли