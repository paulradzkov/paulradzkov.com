---
title: "Параметры subject и body в mailto ссылках"
excerpt: "Как добавить тему письма и текст письма в mailto ссылку"
description: "Как добавить тему письма и текст письма в mailto ссылку"
created_at: 2014-02-04
kind: article
publish: true
disqusid: mailto_parameters
tags: [html, usability]
og_image: '/i/og/og-paulradzkov-2014-mailto_parameters.png'
---

В письмах от сервисов и электронных магазинов, приходящих в ответ на заказ услуги или покупку товара, часто есть подобная фраза:

{% capture example %}

> Если у Вас возникли любые вопросы касательно вашего заказа, пожалуйста, свяжитесь со Службой поддержки по телефону <a href="tel:XXXX XXX XXXX">XXXX XXX XXXX</a> или напишите по адресу <a href="mailto:customerservices@sitename.com?subject=Заказ XXXXX&amp;body=Мой номер заказа XXXXX" class="breakall">customerservices@sitename.com</a>. Не забудьте сообщить ваш номер заказа.

{% endcapture %}
{% include browserframe.html content=example title="Mail" class="space-out-bottom-kilo-xs" relative-url="" %}

Создавая шаблоны для таких писем, не поленитесь прописать этот самый номер заказа (и любую другую нужную службе поддержки информацию) в параметры mailto ссылки:


{% capture codeexample %}
```html
<a href="mailto:customerservices@sitename.com?subject=Заказ XXXXX&amp;body=Мой номер заказа XXXXX">customerservices@sitename.com</a>
```
{% endcapture %}
{% include browserframe.html content=codeexample title="Template" class="space-out-bottom-kilo-xs" relative-url="" %}

Теперь при клике на адрес электронной почты в новом сообщении номер заказа подставится и в тему письма, и в текст сообщения.

Мелочь, но она сэкономит вашим покупателям пару лишних действий. Особенно актуально это для тех, кто пишет письмо с мобильника.
