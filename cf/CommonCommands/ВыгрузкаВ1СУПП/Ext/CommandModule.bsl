﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВыгрузитьНаСервере();
	Оповестить("ОбновитьЖурналОбмена");
	Оповестить("ИзменениеРегистрацииОбменаДаннымиОбъекта");
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьНаСервере()

	MDMСервер.ВыполнитьОбменДанными_MDM_УПП();

КонецПроцедуры // ВыгрузитьНаСервере()
 
