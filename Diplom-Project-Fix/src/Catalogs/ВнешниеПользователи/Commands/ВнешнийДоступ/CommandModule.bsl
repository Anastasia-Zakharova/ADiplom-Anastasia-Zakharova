///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектАвторизации", ПараметрКоманды);
	
	Попытка
		ОткрытьФорму(
			"Справочник.ВнешниеПользователи.ФормаОбъекта",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если СтрНайти(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
		         "ВызватьИсключение" + " " + "ОписаниеОшибкиКакПредупреждения") > 0 Тогда
			
			ПоказатьПредупреждение(, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти
