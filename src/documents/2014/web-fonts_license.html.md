--- 
title: "Веб-лицензии для платных шрифтов могут стоить вам дорого"
excerpt: "Веб-лицензия, в отличие от настольной лицензии, подразумевает не покупку файлов шрифта, а аренду @font-face версии этого шрифта, причем стоимость аредны зависит от посещаемости вашего сайта. Самая главная опасность платных шрифтов в том, что это не разовые, а постоянные затраты."
description: "Веб-лицензия, в отличие от настольной лицензии, подразумевает не покупку файлов шрифта, а аренду @font-face версии этого шрифта, причем стоимость аредны зависит от посещаемости вашего сайта. Самая главная опасность платных шрифтов в том, что это не разовые, а постоянные затраты."
created_at: 2014-05-02
kind: article
publish: true
disqusid: web-fonts_license
tags: [fonts, typography]
styles: ["/vendor/fotorama/fotorama.css"]
scripts: ["/vendor/fotorama/fotorama.js"]
---

Использовать платные шрифты в вебе бывает неоправдано дорого. Веб-лицензия, в отличие от настольной лицензии, подразумевает не покупку файлов шрифта, а аренду @font-face версии этого шрифта, причем стоимость аредны зависит от посещаемости вашего сайта. Самая главная опасность платных шрифтов в том, что это не разовые, а _постоянные_ затраты.

<!-- cut -->

## Отличия в лицензиях

**Настольная лицензия** (desktop license):  
Вы один раз покупаете ttf-файлы шрифта, устанавливаете их себе на компьютер и можете неограниченно использовать в графических редакторах или на печати.

Если вы сконвертируете купленный шрифт для использования в вебе, то это будет нарушением настольной лицензии, т.к. файлы шрифта не остаются _только_ на вашем компьютере, а загружаются на компьютер посетителя вашего сайта. Поэтому популярные конвертеры, типа fontsquirrel, блокируют преобразование платных шрифтов.

**Веб-лицензия** (webfont license):  
Вы не покупаете шрифт, вы берете его в аренду. При аренде вам дают ссылку на подключение шрифта к вашей странице (как в Google Fonts) и вы оплачиваете количество обращений по этой ссылке. Существует несколько моделей оплаты:

  * Можно оплатить заранее определённое количество просмотров (pageviews) без ограничений по времени. При такой оплате нужно приобретать каждое начертание шрифта отдельно: например, Normal, Italic, Bold, Bold Italic. Каждая загрузка страницы будет крутить счётчик числа обращений к шрифту. Когда количество оплаченных просмотров будет заканчиваться, вам придет сообщение с просьбой докупить ещё. Если вы не продлили аренду, то шрифт перестанет загружаться — позаботьтесь об адекватной замене системным шрифтом! Но можно настроить автопродление подписки, деньги будут списываться автоматически а посетители вашего сайта всегда будут видеть правильные шрифты. 

    Для сайта с небольшой посещаемостью такой способ подписки вполне приемлем, предоплаченного количества посещений хватит надолго. Но если у вас нагруженный ресурс, то деньги будут улетать с большой скоростью.

  * Можно оплатить ежемесячную подписку на шрифт. Стоимость подписки будет зависеть от максимального количества просмотров вашего сайта в месяц. Например, вы берёте подписку на план c ограничением, например, в 1&thinsp;500&thinsp;000 просмотров в месяц. Если в какой-то месяц количество посещений вашего сайта превысит ограничение, вам будет предложено перейти на более дорогой тарифный план. Для особо нагруженных сайтов существуют планы подписок с возможностью размещения файлов шрифта на своих серверах.

  * Некоторые сервисы предлагают ежемесячные подписки с неограниченным количеством шрифтов и их начертаний для сайта, но с единственным ограничением на количество просмотров в месяц.

Стоит отметить, что если платный шрифт у вас не используется на странице, но объявлен в css, то каждая загрузка такой страницы будет крутить счетчик показов шрифта.

## Цены

Предположим нам нужно купить Helvetica Neue в четырех начертаниях: Normal, Italic, Bold, Bold Italic для сайта с 1,5 млн. просмотров в месяц.

Для сравнения настольной и веб-лицензии: на cайте издательства [Linotype][] по настольной лицензии этот набор обойдется в 116€. Веб-шрифт на 1 500 000 просмотров у Линотайпа обойдется в 309€. В год уже получается 3708€. Это 5133$ в год — невероятно много.

На [MyFonts.com][] уже дешевле — 279$ за 1 500 000, что есть 3348$ в год.

В случае ежемесячной оплаты с ограничением по максимальному количеству [Fonts.com][] просит 78€ (100$) в месяц за 2,5 млн. просмотров.
Уже лучше: мы не ограничены количеством начертаний, у нас есть запас на рост посещаемости и всё это стоит 1200$ в год.

Самым выгодным вариантом является [Adobe Typekit][typekit] c его предложением 40$ в месяц за 2 млн. просмотров. Это 480$ в год. Цена уже более менее адекватная, но на неё всё равно согласится не каждый, учитывая, что можно найти [бесплатный аналог](/2014/free_substitution_for_helvetica_neue/) и избежать этих затрат.

Как видим, цены на одно и то же могут отличаться 10 раз.

[Linotype]: http://www.linotype.com/1266/NeueHelvetica-family.html
[MyFonts.com]: http://www.myfonts.com/fonts/linotype/neue-helvetica/buy.html
[Fonts.com]: http://www.fonts.com/web-fonts/plans-and-pricing
[typekit]: https://typekit.com/plans/business

<div class="fotorama">
	![Настольная лицензия на сайте Linotype стоит 116€](linotype-helvetica-desktop.png)
	![Веб-шрифт на Linotype стоит 309€ за 1,5 млн. просмотров](linotype-helvetica-web.png)
	![Цены на Helvetica на MyFonts.com](myfonts-helvetica-1500000.png)
	![Тарифные планы на Fonts.com](font-com-pricing.png)
	![У Adobe Typekit можно взять недорогой план для сайтов с малым посещением](typekit-annual-pricing.png)
	![Самым выгодным вариантом является Adobe Typekit c его предложением 40$ в месяц за 2 млн. просмотров](typekit-business-pricing.png)
</div>

## Выводы

Стоимость использования платных шрифтов на нагруженных проектах за несколько лет (а то и месяцев) может превысить стоимость создания дизайна самого сайта. 

Так как выбор шрифтов — ответственность дизайнеров, им следует знать, что:

* Использование бесплатных шрифтов упрощает жизнь верстальщикам и владельцам сайта. 

* Настольной лицензии недостаточно. Если вы передаёте заказчику шрифты, купленные по настольной лицензии, то это только для того, чтобы заказчик смог пользоваться вашими исходниками. Заказчик не имеет права конвертировать их в веб-шрифты.

* Если дизайнер хочет использовать платный шрифт, ему следует поинтересоваться у заказчика о посещаемости сайта и предупредить о вероятных затратах на использование платных шрифтов, чтобы потом не было сюрпризов.

* Веб-версии шрифтов дешевле арендовать у крупных шрифтовых порталов, чем напрямую у издательств.