﻿
Процедура JIRA_ОбновлениеДанных() Экспорт
	
	JQLЗапросОбновленияДанных = Константы.JIRA_JQLЗапросОбновленияДанных.Получить();
	Если ПустаяСтрока(JQLЗапросОбновленияДанных) Тогда
		ВызватьИсключение "Не указан запрос для обновления данных";
	КонецЕсли;
	ОбработкаОбъект = Обработки.JIRA_ЗагрузкаДанныхПоЗапросу.Создать();
	ОбработкаОбъект.JQLЗапрос = JQLЗапросОбновленияДанных;
	ОбработкаОбъект.ВыполнитьЗагрузкуНаСервере();
	
КонецПроцедуры
