--- 
title: "Автозаполнение форм в Google Chrome"
excerpt: 'Как перекрасить желтые фоны на инпутах в Google Chrome.'
created_at: 2012-02-12
kind: article
publish: true
disqusid: chromeautocomplete
tags: [css,Chrome,bug]
---

В Google Chrome в user agent stylesheet для полей с автозаполнением прописан желтый фон (#FAFFBD) и черный цвет текста, причем оба правила усилены с помощью <code class="important">!important</code> и переопределить их в своей CSS нельзя. Но есть способы решить эту проблему обходными путями.

<!-- cut -->

В трекере описан этот <a href="http://code.google.com/p/chromium/issues/detail?id=46543">баг</a>, но <time datetime="2012-10-30">пока</time> решения нет.

Автозаполнение можно выключить с помощью <code class="tag"><span class="attribute">autocomplete</span>=<span class="value">"off"</span></code>:

	<form action="…" method="post" autocomplete="off">

**Обновлено 30 октября 2012.**

Поля c автокомплитом можно перекрасить при помощи трюка с <code class="attribute">box-shadow</code>:

	input:-webkit-autofill {
        -webkit-box-shadow: inset 0 0 0 50px white; /* цвет вашего фона */
        -webkit-text-fill-color: black; /* цвет текста */
    }

Если вы для <code class="pseudo">:focus</code> состояния задавали стили с использованием <code class="attribute">box-shadow</code>, то вам придется заново их переопределить:

	input:-webkit-autofill:focus {
        -webkit-box-shadow: 0 0 5px 0 blue,   /* ваш box-shadow для :focus */
                      inset 0 0 0 50px white; /*  цвет вашего фона  */
        -webkit-text-fill-color: black; /* цвет текста */
    }

При помощи нескольких теней можно <a href="/demo/box-shadow_instead_gradient/">имитировать градиент</a>.