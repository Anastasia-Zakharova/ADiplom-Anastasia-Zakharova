
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверитьЗаполениеТаблицыСписокСотрудников(Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвижения_РегистрыРасчета();
	
	СформироватьДвижения_ВзаиморасчетыССотрудниками();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполнения

Процедура ПроверитьЗаполениеТаблицыСписокСотрудников(Отказ)
	
	Если СписокСотрудников.Количество() = 0 Тогда
		ТекстСообщения = "Заполните документ ""Начисление фиксированной премии""";
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,,"Объект.СписокСотрудников");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПроведения

Процедура СформироватьДвижения_РегистрыРасчета()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(НАЧАЛОПЕРИОДА(ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Ссылка.Дата, МЕСЯЦ)) КАК ПериодРегистрации,
	|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник КАК Сотрудник,
	|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник.Категория КАК Категория,
	|	СУММА(ВКМ_НачислениеФиксированнойПремииСписокСотрудников.СуммаПремии) КАК СуммаПремии
	|ИЗ
	|	Документ.ВКМ_НачислениеФиксированнойПремии.СписокСотрудников КАК ВКМ_НачислениеФиксированнойПремииСписокСотрудников
	|ГДЕ
	|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник,
	|	ВКМ_НачислениеФиксированнойПремииСписокСотрудников.Сотрудник.Категория";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_ДополнительныеНачисления.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_ДополнительныеНачисления.ФиксированнаяПремия;
		Движение.ЧасовРаботы = 0;
		Движение.Результат = Выборка.СуммаПремии;
		
		Движение = Движения.ВКМ_Удержания.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, Выборка);
		Движение.ВидРасчета = ПланыВидовРасчета.ВКМ_Удержания.НДФЛ;
		Движение.БазовыйПериодНачало = НачалоМесяца(Дата);
		Движение.БазовыйПериодКонец = КонецМесяца(Дата);
		ПроцентНДФЛ = 13;
		Движение.ПроцентНДФЛ = ПроцентНДФЛ;
		Движение.СовокупныйДоход = Выборка.СуммаПремии;
		Движение.Результат = Выборка.СуммаПремии * ПроцентНДФЛ / 100;
		
	КонецЦикла;
	
	Движения.ВКМ_ДополнительныеНачисления.Записать();
	Движения.ВКМ_Удержания.Записать();
	
КонецПроцедуры

Процедура СформироватьДвижения_ВзаиморасчетыССотрудниками()
	
	//Регистр накопления "Взаиморасчеты с сотрудниками"
	Движения.ВКМ_ВзаиморасчетыССотрудниками.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВКМ_ДополнительныеНачисления.Сотрудник КАК Сотрудник,
	|	ВКМ_ДополнительныеНачисления.Результат КАК РезультатДополнительные,
	|	ВКМ_Удержания.Результат КАК РезультатУдержания
	|ИЗ
	|	РегистрРасчета.ВКМ_ДополнительныеНачисления КАК ВКМ_ДополнительныеНачисления
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрРасчета.ВКМ_Удержания КАК ВКМ_Удержания
	|		ПО ВКМ_ДополнительныеНачисления.Регистратор = ВКМ_Удержания.Регистратор
	|			И ВКМ_ДополнительныеНачисления.Сотрудник = ВКМ_Удержания.Сотрудник
	|ГДЕ
	|	ВКМ_ДополнительныеНачисления.Регистратор = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Движение = Движения.ВКМ_ВзаиморасчетыССотрудниками.ДобавитьПриход();
		Движение.Период = НачалоМесяца(Дата);
		Движение.Сотрудник = Выборка.Сотрудник;
		Движение.Сумма = Выборка.РезультатДополнительные - Выборка.РезультатУдержания;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
