﻿
Функция НайтиСоздатьПроект(Данные) Экспорт
	
	Если Данные = Неопределено Тогда
		Возврат Справочники.JIRA_Проекты.ПустаяСсылка();
	КонецЕсли;
	
	НайденнаяСсылка = Справочники.JIRA_Проекты.НайтиПоКоду(Данные["id"]);
	Если НЕ ЗначениеЗаполнено(НайденнаяСсылка) Тогда
		НовыйОбъект = Справочники.JIRA_Проекты.СоздатьЭлемент();
		НовыйОбъект.Код = 			Данные["id"];
		НовыйОбъект.Наименование = 	Данные["name"];
		НовыйОбъект.Ключ = 	Данные["key"];
		
		НовыйОбъект.Записать();
		
		НайденнаяСсылка = НовыйОбъект.Ссылка;
	КонецЕсли;
	
	Возврат НайденнаяСсылка;
	
КонецФункции
