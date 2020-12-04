﻿
Функция ВыполнитьJQLЗапрос(JQL, РасширеныеДанные = Ложь) Экспорт 
	
	JQL = СтрЗаменить(JQL, " ", "+");
	
	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	ДопПараметры = ?(РасширеныеДанные, "&expand=changelog", "");
	
	Ответ = Новый Массив();
	startIndex = 0;
	Пока Истина Цикл
		URL = СтроковыеФункцииКлиентСервер._СтрШаблон("%1/rest/api/2/search?jql=%2&startAt=%3%4", JIRA_URL, JQL, Формат(startIndex, "ЧГ="), ДопПараметры);      		
		Результат = JIRA_ВзаимодействиеC_JIRA_Сервер.ВыполнитьGETЗапрос(URL);	
		Если Не ЗначениеЗаполнено(Результат) Тогда
			Прервать;
		КонецЕсли;
		
		ЧтениеJSON = Новый ЧтениеJSON();
		ЧтениеJSON.УстановитьСтроку(Результат);
		ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);                            
		ЧтениеJSON.Закрыть();
		МассивЗадач = ОтветОбъект["issues"];
		ЗадачВсего = ОтветОбъект["total"];
		ЗадачНаСтранице = ОтветОбъект["maxResults"];
		startIndex = startIndex + Число(ЗадачНаСтранице);
		
		Если МассивЗадач = Неопределено ИЛИ МассивЗадач.Количество() = 0 Тогда
			Прервать;	
		КонецЕсли;
		
		Для Каждого З Из МассивЗадач Цикл
			Ответ.Добавить(З);	
		КонецЦикла;
		
		Если Ответ.Количество() >= Число(ЗадачВсего) Тогда
			Прервать;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ответ;
КонецФункции

Функция ПолучитьДанныеПоЗадаче(НомерЗадачи) Экспорт 
	#Если Клиент Тогда
		Состояние(СтроковыеФункцииКлиентСервер._СтрШаблон("Запрашиваем комментарии для задачи ""%1""", НомерЗадачи));
	#КонецЕсли

	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	Результат = JIRA_ВзаимодействиеC_JIRA_Сервер.ВыполнитьGETЗапрос(СтроковыеФункцииКлиентСервер._СтрШаблон("%1/rest/api/2/issue/%2", JIRA_URL, НомерЗадачи));	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер._СтрШаблон("Не удалось получить комментарии по задаче ""%1""", НомерЗадачи);
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Результат);
	ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Возврат ОтветОбъект;
КонецФункции

Функция ПолучитьКомментарииПоЗадаче(НомерЗадачи) Экспорт 
	#Если Клиент Тогда
		Состояние(СтроковыеФункцииКлиентСервер._СтрШаблон("Запрашиваем комментарии для задачи ""%1""", НомерЗадачи));
	#КонецЕсли

	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	Результат = JIRA_ВзаимодействиеC_JIRA_Сервер.ВыполнитьGETЗапрос(СтроковыеФункцииКлиентСервер._СтрШаблон("%1/rest/api/2/issue/%2/comment", JIRA_URL, НомерЗадачи));	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер._СтрШаблон("Не удалось получить комментарии по задаче ""%1""", НомерЗадачи);
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Результат);
	ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Возврат ОтветОбъект["comments"];
КонецФункции


Функция ПолучитьСабтаски(НомерРодительскойЗадачи)
	JQL = СтроковыеФункцииКлиентСервер._СтрШаблон("parent = %1", НомерРодительскойЗадачи);
	Возврат ВыполнитьJQLЗапрос(JQL);
КонецФункции

Процедура ОткрытьЗадачуВБраузере(НомерЗадачи) Экспорт
	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	URL = СтроковыеФункцииКлиентСервер._СтрШаблон("%1/browse/%2", JIRA_URL, НомерЗадачи);
	Если ЗначениеЗаполнено(НомерЗадачи)  Тогда
		#Если Клиент Тогда
			НачатьЗапускПриложения(Новый ОписаниеОповещения("ОткрытьСписокВJIRAЗавершение", ЭтотОбъект), URL);	
		#Иначе
			ЗапуститьПриложение(URL);
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры

Процедура ОткрытьСписокВJIRAЗавершение(КодВозврата, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

Функция ПолучитьДанныеПерехода(НомерЗадачи, ИмяСтатусаНазначения) Экспорт 
	#Если Клиент Тогда
		Состояние(СтроковыеФункцииКлиентСервер._СтрШаблон("Запрашиваем доп. данные для перехода в статус ""%1""", ИмяСтатусаНазначения));
	#КонецЕсли

	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	Результат = JIRA_ВзаимодействиеC_JIRA_Сервер.ВыполнитьGETЗапрос(СтроковыеФункцииКлиентСервер._СтрШаблон("%1/rest/api/2/issue/%2/transitions?expand=transitions.fields", JIRA_URL, НомерЗадачи));	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер._СтрШаблон("Не удалось получить список разрешенных переходов для задачи ""%1""", НомерЗадачи);
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Результат);
	ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Для Каждого Элемент Из ?(ОтветОбъект["transitions"] <> Неопределено, ОтветОбъект["transitions"], Новый Массив()) Цикл
		Если ВРег(Элемент["to"]["name"]) = ВРег(ИмяСтатусаНазначения) Тогда
			Возврат Элемент;
		КонецЕсли;
	КонецЦикла;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер._СтрШаблон("Не удалось установить статус ""%1"" для задачи ""%2"".
		|Данный переход не предусмотрен workflow", ИмяСтатусаНазначения, НомерЗадачи); 
КонецФункции

Функция ПолучитьЛогСписанийПоЗадаче(НомерЗадачи) Экспорт 
	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
	URL = СтроковыеФункцииКлиентСервер._СтрШаблон("%1/rest/api/2/issue/%2/worklog", JIRA_URL, НомерЗадачи);      
	Результат = JIRA_ВзаимодействиеC_JIRA_Сервер.ВыполнитьGETЗапрос(URL);	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Возврат Новый Массив();
	КонецЕсли;
	
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(Результат);
	ОтветОбъект = ПрочитатьJSON(ЧтениеJSON, Истина);                            
	ЧтениеJSON.Закрыть();
	
	Возврат ОтветОбъект["worklogs"];
КонецФункции

//Процедура ИзменитьПоляЗадачи(НомерЗадачи, ДанныеПолей) Экспорт 
//	
//	#Если Клиент Тогда
//		Состояние("Изменяем данные задачи " + НомерЗадачи);
//	#КонецЕсли

//	
//	СтруктураДанных = Новый Структура("fields", ДанныеПолей); 
//	
//	ЗаписьJSON = Новый ЗаписьJSON;
//	ПараметрыJSON = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, " ", Истина);  
//	ЗаписьJSON.УстановитьСтроку(ПараметрыJSON);
//	ЗаписатьJSON(ЗаписьJSON, СтруктураДанных);           
//	ДанныеJSON = ЗаписьJSON.Закрыть();

//	
//	ПараметрыПодключения = JIRA_ВзаимодействиеC_JIRA_Сервер.ПолучитьПараметрыПодключенияJIRA();
//	JIRA_URL = ПараметрыПодключения.Протокол + ПараметрыПодключения.АдресСервера; 
//	URL = СтрШаблон("%1/rest/api/2/issue/%2", JIRA_URL, НомерЗадачи);
//	ВыполнитьPUTЗапрос(URL, ДанныеJSON);
//	
//	JIRA_ВзаимодействиеC_JIRA_Сервер.ОбновитьДанныеЗадач(НомерЗадачи);
//КонецПроцедуры


#region РаботаС_HTTP

Функция ПолучитьЗаголовки() Экспорт 
	Заголовки = Новый Соответствие();
	//Заголовки.Вставить("Connection", "keep-alive");
	//Заголовки.Вставить("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
	Заголовки.Вставить("Content-type", "application/json;charset=utf-8");
	//Заголовки.Вставить("Accept", "application/json, text/javascript, */*; q=0.01");
	//Заголовки.Вставить("Accept-Language", "Accept-Encoding	gzip, deflate");
	//Заголовки.Вставить("X-Requested-With", "XMLHttpRequest");
	//Заголовки.Вставить("Content-Length", "59");
	
	Возврат Заголовки;
КонецФункции

Функция ПолучитьPOSTЗаголовки()
	Заголовки = Новый Соответствие();
	Заголовки.Вставить("Connection", "keep-alive");
	Заголовки.Вставить("Content-Type", "application/x-www-form-urlencoded");
	Заголовки.Вставить("Accept", "text/html, */*; q=0.01");
	Заголовки.Вставить("Accept-Language", "ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3");
	Заголовки.Вставить("X-Requested-With", "XMLHttpRequest");
	Заголовки.Вставить("Referer", "https://jira.bftcom.com/browse/BU-9875");
	Заголовки.Вставить("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:54.0) Gecko/20100101 Firefox/54.0");
	Заголовки.Вставить("Accept-Encoding", "gzip, deflate, br");
	
	Возврат Заголовки;
КонецФункции

Процедура ВыполнитьPUTЗапрос(URL, ДанныеJSON)
	//Куки =  ОбщегоНазначенияСервер.ПолучитьЗначениеПараметраСеанса("JIRA_Cookies");
	//Если Не ЗначениеЗаполнено(Куки) Тогда
	//	Куки = Авторизоваться();
	//КонецЕсли;
	
	Заголовки = ПолучитьЗаголовки();
  //Заголовки.Вставить("Cookie", Куки); 
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	Прокси = Новый ИнтернетПрокси(Истина);
	ssl = Новый ЗащищенноеСоединениеOpenSSL();
	//ssl = Новый ЗащищенноеСоединениеOpenSSL(
	//Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Авто),
	//Новый СертификатыУдостоверяющихЦентровWindows());
	
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост,,,,,, ssl);
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере, Заголовки);      
	HTTPЗапрос.УстановитьТелоИзСтроки(ДанныеJSON, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ФайлОтвет = ПолучитьИмяВременногоФайла();
	Попытка
		Ответ = HTTPСоединение.ВызватьHTTPМетод("PUT", HTTPЗапрос, ФайлОтвет); 
		// Все двухсотые коды это ОК
		Если Окр(Ответ.КодСостояния,-2) <> 200 Тогда
			АнализФайлаОтвета(ФайлОтвет, Ответ.КодСостояния);  // Эта пляска из-за ассинхронных методов
		КонецЕсли;	
		
		УдалитьФайлы(ФайлОтвет);
	Исключение
		УдалитьФайлы(ФайлОтвет);
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

Функция ВыполнитьPOSTЗапрос(URL, ДанныеJSON, ЭтоЗапросАвторизации = Ложь)
	//Куки =  ОбщегоНазначенияСервер.ПолучитьЗначениеПараметраСеанса("JIRA_Cookies");
	//Если Не ЗначениеЗаполнено(Куки) И Не ЭтоЗапросАвторизации Тогда
	//	Куки = Авторизоваться();
	//КонецЕсли;
	//
	Заголовки = ПолучитьЗаголовки();
  //Заголовки.Вставить("Cookie", Куки); 
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(URL);
	
	Прокси = Новый ИнтернетПрокси(Истина);
	ssl = Новый ЗащищенноеСоединениеOpenSSL();
	//ssl = Новый ЗащищенноеСоединениеOpenSSL(
	//Новый СертификатКлиентаWindows(СпособВыбораСертификатаWindows.Авто),
	//Новый СертификатыУдостоверяющихЦентровWindows());
	
	HTTPСоединение = Новый HTTPСоединение(СтруктураURI.Хост,,,,,, ssl);
	HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере, Заголовки);      
	HTTPЗапрос.УстановитьТелоИзСтроки(ДанныеJSON, КодировкаТекста.UTF8, ИспользованиеByteOrderMark.НеИспользовать);
	
	ФайлОтвет = ПолучитьИмяВременногоФайла();
	Попытка
		Ответ = HTTPСоединение.ОтправитьДляОбработки(HTTPЗапрос, ФайлОтвет);
		// Все двухсотые коды это ОК
		Если Окр(Ответ.КодСостояния,-2) <> 200 Тогда
			// Эта пляска из-за ассинхронных методов
			АнализФайлаОтвета(ФайлОтвет, Ответ.КодСостояния);
		КонецЕсли;	
		
		УдалитьФайлы(ФайлОтвет);
		Возврат Ответ;
	Исключение
		УдалитьФайлы(ФайлОтвет);
		ВызватьИсключение;
	КонецПопытки;
КонецФункции


#endregion

Процедура АнализФайлаОтвета(ФайлОтвет, КодСостояния)
	#Если Клиент Тогда
		ДД = Новый Структура("КодСостояния", КодСостояния);
		НачатьПомещениеФайла(Новый ОписаниеОповещения("ЗавершениеПомещениеФайла", ЭтотОбъект, ДД), "", ФайлОтвет, Ложь, Новый УникальныйИдентификатор());
	#Иначе
		JIRA_ВзаимодействиеC_JIRA_Сервер.АнализФайлаОтвета(Неопределено, ФайлОтвет, КодСостояния);
	#КонецЕсли
КонецПроцедуры

Процедура ЗавершениеПомещениеФайла(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт 
	Если Результат Тогда
		JIRA_ВзаимодействиеC_JIRA_Сервер.АнализФайлаОтвета(Адрес, Неопределено, ДополнительныеПараметры.КодСостояния);	
	КонецЕсли;
КонецПроцедуры

Функция ПреобразоватьВДату(Знач ДатаСтрокой) Экспорт 
	ПозицияТочки = СтроковыеФункцииКлиентСервер._СтрНайти(ДатаСтрокой, ".");
	Если ПозицияТочки > 0 Тогда
		ДатаСтрокой = Лев(ДатаСтрокой, СтроковыеФункцииКлиентСервер._СтрНайти(ДатаСтрокой, ".")-1)
	КонецЕсли;
	
	Возврат ?(ДатаСтрокой = Неопределено, Дата("00010101"), XMLЗначение(Тип("Дата"), ДатаСтрокой));
КонецФункции


