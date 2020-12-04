﻿
Функция НайтиСоздатьТипЗапроса(Данные) Экспорт
	
	Если Данные = Неопределено Тогда
		Возврат Справочники.JIRA_ТипЗапроса.ПустаяСсылка();
	КонецЕсли;
	
	НайденнаяСсылка = Справочники.JIRA_ТипЗапроса.НайтиПоКоду(Данные["id"]);
	Если НЕ ЗначениеЗаполнено(НайденнаяСсылка) Тогда
		НовыйОбъект = Справочники.JIRA_ТипЗапроса.СоздатьЭлемент();
		НовыйОбъект.Код = 			Данные["id"];
		НовыйОбъект.Наименование = 	Данные["name"];
		НовыйОбъект.Описание = 	Данные["description"];
		НовыйОбъект.Подзадача = 	Данные["subtask"];
		
		НовыйОбъект.Записать();
		
		НайденнаяСсылка = НовыйОбъект.Ссылка;
	КонецЕсли;
	
	Возврат НайденнаяСсылка;
	
КонецФункции
