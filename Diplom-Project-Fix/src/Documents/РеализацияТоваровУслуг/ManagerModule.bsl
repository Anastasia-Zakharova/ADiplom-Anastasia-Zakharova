
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Добавить команду создать на основании.
// 
// Параметры:
//  КомандыСозданияНаОсновании - ТаблицаЗначений - Команды создания на основании
// 
// Возвращаемое значение:
//  Неопределено -  Добавить команду создать на основании
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Добавить команды печати.
// 
// Параметры:
//  КомандыПечати - ТаблицаЗначений - Команды печати
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
//ВКМ_Захарова: Добавляем команды печати
	
	//Реализация товаров и услуг (MXL)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РеализацияТоваровУслуг";
	КомандаПечати.Представление = НСтр("ru = 'Реализация товаров и услуг'");
	КомандаПечати.Порядок = 5;
	
	//Акт об оказанных услугах (Word)
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктУслугиWord";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оказанных услугах (word)'");
	КомандаПечати.Порядок = 15;
	
//ВКМ_Захарова
КонецПроцедуры

// Печать.
// 
// Параметры:
//  МассивОбъектов - ДокументСсылка.РеализацияТоваровУслуг - Массив объектов
//  ПараметрыПечати - Структура - Параметры печати
//  КоллекцияПечатныхФорм - ТаблицаЗначений - Коллекция печатных форм
//  ОбъектыПечати - ОписаниеТипов - Объекты печати
//  ПараметрыВывода - Структура - Параметры вывода
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
//ВКМ_Захарова: Печать документов
	
	// Реализация товаров и услуг (MXL)
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "РеализацияТоваровУслуг");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = ПечатьРеализацияТоваровУслуг(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Реализация товаров и услуг'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_РеализацияТоваровУслуг";
	КонецЕсли;
	
	//Акт об оказанных услугах (Word)
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АктУслугиWord");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ОфисныеДокументы = ПечатьАктУслугиWord(МассивОбъектов);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт об оказанных услугах (word)'");
	КонецЕсли;
	
//ВКМ_Захарова
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать_РеализацияТоваровУслуг

Функция ПечатьРеализацияТоваровУслуг(МассивОбъектов, ОбъектыПечати)
//ВКМ_Захарова: Печать документа "РеализацияТоваровУслуг"
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_РеализацияТоваровУслуг";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ВКМ_ПФ_MXL_РеализацияТоваровУслуг");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	ПервыйДокумент = Истина;
	
	Пока ДанныеДокументов.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			// Все документы нужно выводить на разных страницах.
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		//Вывести области
		ВывестиОбластьЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет);
		ВывестиОбластьТаблица(ДанныеДокументов, ТабличныйДокумент, Макет);
		ВывестиОбластьПодвал(ДанныеДокументов, ТабличныйДокумент, Макет);
		ВывестиОбластьПодписи(ДанныеДокументов, ТабличныйДокумент, Макет);
		
		// В табличном документе необходимо задать имя области, в которую был 
		// выведен объект. Нужно для возможности печати комплектов документов.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,
			ДанныеДокументов.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
//ВКМ_Захарова
КонецФункции

Процедура ВывестиОбластьЗаголовок(ДанныеДокументов, ТабличныйДокумент, Макет)
//ВКМ_Захарова: Вывести область заголовок
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Реализация товаров и услуг №%1 от %2";
	НомерДокумент = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер);
	ДатаДокумент = Формат(ДанныеДокументов.Дата, "ДЛФ=DD");
	Заголовок = СтрШаблон(ШаблонЗаголовка, НомерДокумент, ДатаДокумент);
	ДанныеПечати.Вставить("ЗаголовокРеализация", Заголовок);
	
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.Организация);
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.Контрагент);
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.Договор);
	
	ОбластьЗаголовок.Параметры.Заполнить(ДанныеПечати);
	
	//Логотип
	Если Не ДанныеДокументов.Логотип.Пустая() Тогда
		ДвоичныеДанные = РаботаСФайлами.ДвоичныеДанныеФайла(ДанныеДокументов.Логотип);
		Если ЗначениеЗаполнено(ДвоичныеДанные) Тогда
			КартинкаЛоготипа = Новый Картинка(ДвоичныеДанные, Истина);
			ОбластьЗаголовок.Рисунки.Логотип.Картинка = КартинкаЛоготипа;
		КонецЕсли;
	КонецЕсли;
	//Логотип
	
	//QRКод
	СтрокаГиперСсылка = ПолучитьНавигационнуюСсылку(ДанныеДокументов.Ссылка);
	ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(СтрокаГиперСсылка, 1, 120);
	
	Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		|Технические подробности см. в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	Иначе
		КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		ОбластьЗаголовок.Рисунки.QRКод.Картинка = КартинкаQRКода;
	КонецЕсли;
	//QRКод
	
	ТабличныйДокумент.Вывести(ОбластьЗаголовок);
	
//ВКМ_Захарова
КонецПроцедуры

Процедура ВывестиОбластьТаблица(ДанныеДокументов, ТабличныйДокумент, Макет)
//ВКМ_Захарова: Вывести область таблица
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("СтрокаТаблицы");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ВыборкаТовары = ДанныеДокументов.Товары.Выбрать();
	Пока ВыборкаТовары.Следующий() Цикл
		ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаТовары);
		ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
	КонецЦикла;
	
	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьСтрокаТаблицы.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицы);
	КонецЦикла;
	
//ВКМ_Захарова
КонецПроцедуры

Процедура ВывестиОбластьПодвал(ДанныеДокументов, ТабличныйДокумент, Макет)
//ВКМ_Захарова: Вывести область подвал
	
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("СуммаИтого", ДанныеДокументов.СуммаДокумента);
	
	ПараметрыИсчисления = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	ПрописьСуммы = ЧислоПрописью(ДанныеДокументов.СуммаДокумента,, ПараметрыИсчисления);
	ДанныеПечати.Вставить("СуммаПрописью", ПрописьСуммы);
	
	ОбластьПодвал.Параметры.Заполнить(ДанныеПечати);
	
	ТабличныйДокумент.Вывести(ОбластьПодвал);
	
//ВКМ_Захарова
КонецПроцедуры

Процедура ВывестиОбластьПодписи(ДанныеДокументов, ТабличныйДокумент, Макет)
//ВКМ_Захарова: Вывести область подписи
	
	ОбластьПодписи = Макет.ПолучитьОбласть("Подписи");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("РуководительФИО", ДанныеДокументов.РуководительФИО);
	ОбластьПодписи.Параметры.Заполнить(ДанныеПечати);
	
	ТабличныйДокумент.Вывести(ОбластьПодписи);
	
//ВКМ_Захарова
КонецПроцедуры

#КонецОбласти

#Область Печать_АктУслугиWord

Функция ПечатьАктУслугиWord(МассивОбъектов)
//ВКМ_Захарова: Печать документа "АктУслугиWord"
	
	ОфисныеДокументы = Новый Соответствие;
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ВКМ_ПФ_DOC_АктУслугиWord");
	
	МакетОфисный = УправлениеПечатью.ИнициализироватьМакетОфисногоДокумента(Макет, Неопределено);
	
	//Добавляем описание областей
	ОписаниеОбластей = Новый Структура;
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Заголовок", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ШапкаТаблицы", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "СтрокаТаблицы","СтрокаТаблицы");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "ОбщаяСумма", "Общая");
	УправлениеПечатью.ДобавитьОписаниеОбласти(ОписаниеОбластей, "Подвал", "Общая");
	
	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	
	Пока ДанныеДокументов.Следующий() Цикл 
		
		ПечатнаяФорма = УправлениеПечатью.ИнициализироватьПечатнуюФорму(Неопределено, Неопределено, МакетОфисный);
		
		//Область "Заголовок"
		ЗначенияПараметровЗаголовок = ПолучитьПараметры_Заголовок(ДанныеДокументов);
		ОбластьЗаголовок = УправлениеПечатью.ОбластьМакета(МакетОфисный, ОписаниеОбластей.Заголовок);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьЗаголовок, ЗначенияПараметровЗаголовок);
		
		//Вывести таблицу "Услуги"
		ТаблицаУслуги = ДанныеДокументов.Услуги.Выгрузить();
		
		Если ЗначениеЗаполнено(ТаблицаУслуги) Тогда
			
			//Область "ШапкаТаблицы"
			ОбластьШапкаТаблицы = УправлениеПечатью.ОбластьМакета(МакетОфисный, ОписаниеОбластей.ШапкаТаблицы);
			УправлениеПечатью.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьШапкаТаблицы);
			
			//Область "СтрокаТаблицы"
			ЗначенияПараметровСтрока = Новый Структура;
			Для Каждого СтрокаТаблицы Из ТаблицаУслуги Цикл
				ПолучитьПараметры_СтрокаТаблицы(ЗначенияПараметровСтрока, СтрокаТаблицы);
				ОбластьСтрокаТаблицы = УправлениеПечатью.ОбластьМакета(МакетОфисный, ОписаниеОбластей.СтрокаТаблицы);
				УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьСтрокаТаблицы, ЗначенияПараметровСтрока);
			КонецЦикла;
			
			//Область "ОбщаяСумма"
			ЗначенияПараметровОбщаяСумма = ПолучитьПараметры_ОбщаяСумма(ДанныеДокументов);
			ОбластьОбщаяСумма = УправлениеПечатью.ОбластьМакета(МакетОфисный, ОписаниеОбластей.ОбщаяСумма);
			УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьОбщаяСумма, ЗначенияПараметровОбщаяСумма);
			
		КонецЕсли;
		
		//Обдасть "Подвал"
		ЗначенияПараметровПодвал = ПолучитьПараметры_Подвал(ДанныеДокументов);
		ОбластьПодвал = УправлениеПечатью.ОбластьМакета(МакетОфисный, ОписаниеОбластей.Подвал);
		УправлениеПечатью.ПрисоединитьОбластьИЗаполнитьПараметры(ПечатнаяФорма, ОбластьПодвал, ЗначенияПараметровПодвал);
		
		//Сформированный для печати документ помещаем во Временное хранилище
		АдресХранилищаПечатнойФормы = УправлениеПечатью.СформироватьДокумент(ПечатнаяФорма);
		
		//Временное хранилище привязываем к конкретному документу с помощью соответствия
		ОфисныеДокументы.Вставить(АдресХранилищаПечатнойФормы, Строка(ДанныеДокументов.Ссылка));
		
		//Очищаем Временные файлы
		УправлениеПечатью.ОчиститьСсылки(ПечатнаяФорма);
		
	КонецЦикла;
	
	УправлениеПечатью.ОчиститьСсылки(МакетОфисный);
	
	Возврат ОфисныеДокументы;
	
//ВКМ_Захарова
КонецФункции

Функция ПолучитьПараметры_Заголовок(ДанныеДокументов)
//ВКМ_Захарова: Параметры области "Заголовок"
	
	НомерДокумент = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер);
	МесяцДокумент = НРег(Формат(ДанныеДокументов.Дата, "ДФ=ММММ"));
	
	ЗначенияПараметровЗаголовок = Новый Структура;
	ЗначенияПараметровЗаголовок.Вставить("Номер", НомерДокумент);
	ЗначенияПараметровЗаголовок.Вставить("Месяц", МесяцДокумент);
	ЗначенияПараметровЗаголовок.Вставить("Организация", ДанныеДокументов.Организация);
	ЗначенияПараметровЗаголовок.Вставить("Контрагент", ДанныеДокументов.Контрагент);
	ЗначенияПараметровЗаголовок.Вставить("Договор", ДанныеДокументов.Договор);
	
	Возврат ЗначенияПараметровЗаголовок;
	
//ВКМ_Захарова
КонецФункции

Процедура ПолучитьПараметры_СтрокаТаблицы(ЗначенияПараметровСтрока, СтрокаТаблицы)
//ВКМ_Захарова: Параметры области "СтрокаТаблицы"
	
	ЗначенияПараметровСтрока.Вставить("НС", СтрокаТаблицы.НомерСтроки);
	ЗначенияПараметровСтрока.Вставить("НоменклатураУслуги", СтрокаТаблицы.Номенклатура);
	ЗначенияПараметровСтрока.Вставить("Количество", СтрокаТаблицы.Количество);
	ЗначенияПараметровСтрока.Вставить("Цена", СтрокаТаблицы.Цена);
	ЗначенияПараметровСтрока.Вставить("Сумма", СтрокаТаблицы.Сумма);
	
//ВКМ_Захарова
КонецПроцедуры

Функция ПолучитьПараметры_ОбщаяСумма(ДанныеДокументов)
//ВКМ_Захарова: Параметры области "ОбщаяСумма"
	
	ЗначенияПараметровОбщаяСумма = Новый Структура;
	
	ЗначенияПараметровОбщаяСумма.Вставить("СуммаИтого", ДанныеДокументов.СуммаДокумента);
	
	ПараметрыИсчисления = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	ПрописьСуммы = ЧислоПрописью(ДанныеДокументов.СуммаДокумента,, ПараметрыИсчисления);
	ЗначенияПараметровОбщаяСумма.Вставить("СуммаПрописью", ПрописьСуммы);
	
	Возврат ЗначенияПараметровОбщаяСумма;
	
//ВКМ_Захарова
КонецФункции

Функция ПолучитьПараметры_Подвал(ДанныеДокументов)
//ВКМ_Захарова: Параметры области "Подвал"
	
	ЗначенияПараметровПодвал = Новый Структура;
	
	ЗначенияПараметровПодвал.Вставить("ОрганизацияИНН", ДанныеДокументов.ОрганизацияИНН);
	ЗначенияПараметровПодвал.Вставить("ОрганизацияКПП", ДанныеДокументов.ОрганизацияКПП);
	ТаблицаПредставлениеОрганизации = ДанныеДокументов.ТаблицаОрганизация.Выгрузить();
	Если ЗначениеЗаполнено(ТаблицаПредставлениеОрганизации) Тогда
		ОрганизацияАдрес = ТаблицаПредставлениеОрганизации[0].ОрганизацияПредставление;
		ЗначенияПараметровПодвал.Вставить("ОрганизацияАдрес", ОрганизацияАдрес);
	Иначе
		ЗначенияПараметровПодвал.Вставить("ОрганизацияАдрес", "");
	КонецЕсли;
	ЗначенияПараметровПодвал.Вставить("Ответственный", ДанныеДокументов.Ответственный);
	
	ЗначенияПараметровПодвал.Вставить("КонтрагентИНН", ДанныеДокументов.КонтрагентИНН);
	ЗначенияПараметровПодвал.Вставить("КонтрагентКПП", ДанныеДокументов.КонтрагентКПП);
	ТаблицаПредставлениеКонтрагента = ДанныеДокументов.ТаблицаКонтрагент.Выгрузить();
	Если ЗначениеЗаполнено(ТаблицаПредставлениеКонтрагента) Тогда
		КонтрагентАдрес = ТаблицаПредставлениеКонтрагента[0].КонтрагентПредставление;
		ЗначенияПараметровПодвал.Вставить("КонтрагентАдрес", КонтрагентАдрес);
	Иначе
		ЗначенияПараметровПодвал.Вставить("КонтрагентАдрес", "");
	КонецЕсли;
	
	Возврат ЗначенияПараметровПодвал;
	
//ВКМ_Захарова
КонецФункции

#КонецОбласти

#Область Печать_ДанныеДокументов

Функция ПолучитьДанныеДокументов(МассивОбъектов)
//ВКМ_Захарова Получить данный из документов реализации для печати
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
		|	РеализацияТоваровУслуг.Номер КАК Номер,
		|	РеализацияТоваровУслуг.Дата КАК Дата,
		|	РеализацияТоваровУслуг.Организация КАК Организация,
		|	РеализацияТоваровУслуг.Организация.ИНН КАК ОрганизацияИНН,
		|	РеализацияТоваровУслуг.Организация.КПП КАК ОрганизацияКПП,
		|	РеализацияТоваровУслуг.Организация.КонтактнаяИнформация.(
		|		Представление КАК ОрганизацияПредставление
		|	) КАК ТаблицаОрганизация,
		|	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
		|	РеализацияТоваровУслуг.Контрагент.ИНН КАК КонтрагентИНН,
		|	РеализацияТоваровУслуг.Контрагент.КПП КАК КонтрагентКПП,
		|	РеализацияТоваровУслуг.Контрагент.КонтактнаяИнформация.(
		|		Представление КАК КонтрагентПредставление
		|	) КАК ТаблицаКонтрагент,
		|	РеализацияТоваровУслуг.Договор КАК Договор,
		|	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
		|	РеализацияТоваровУслуг.Ответственный КАК Ответственный,
		|	РеализацияТоваровУслуг.Организация.ВКМ_ОтветственныйСотрудник КАК РуководительФИО,
		|	РеализацияТоваровУслуг.Организация.ВКМ_ФайлКартинкиЛоготип КАК Логотип,
		|	РеализацияТоваровУслуг.Товары.(
		|		Ссылка КАК Ссылка,
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма
		|	) КАК Товары,
		|	РеализацияТоваровУслуг.Услуги.(
		|		Ссылка КАК Ссылка,
		|		НомерСтроки КАК НомерСтроки,
		|		Номенклатура КАК Номенклатура,
		|		Количество КАК Количество,
		|		Цена КАК Цена,
		|		Сумма КАК Сумма
		|	) КАК Услуги
		|ИЗ
		|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		|ГДЕ
		|	РеализацияТоваровУслуг.Ссылка В(&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка;
	
//ВКМ_Захарова
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли