---
title: "CSS-селектор :not. Полезные примеры"
excerpt: "CSS3 селектор :not (negation). Примеры использования"
description: "CSS3 селектор :not (negation). Примеры использования"
created_at: 2014-01-19
kind: article
publish: true
disqusid: negation-css-selector
tags: [css]
starred: true
og_image: '/i/og/og-paulradzkov-2014-negation_css_selector.png'
---


В спецификации и блогах про селектор `:not` обычно приводят какие-то искусственные примеры, которые хоть и объясняют синтаксис и принцип действия, но не несут никакой идеи о том, как получить пользу от нового селектора.

<!-- cut -->

Например:

{% capture fig-1 %}
```css
p:not(.classy) {
  color: red;
}
```
{% endcapture %}
{% include browserframe.html content=fig-1 title="styles.css" class="space-out-bottom-kilo-xs" relative-url="" %}


Ну окей, думаю я, в моей практике не встречались такие ситуации. Обходились мы ведь как-то раньше без `:not`. Приходилось немного переписать структуру селекторов или обнулить пару значений.

## Пример 1. Элемент без класса

Селектор `:not` может быть крайне полезен, когда нам нужно застилить контент сгенерированный пользователем (нет возможности расставить в нем классы), или когда у нас контента очень много и расставлять в нем классы слишком трудоёмко.

Например, мы хотим на сайте сделать красивые буллиты для ненумерованных списков `ul li`. Мы пишем код:

{% capture fig-2 %}
```css
ul li { 
  /* наши красивые стили */
}
```
{% endcapture %}
{% include browserframe.html content=fig-2 title="styles.css" class="space-out-bottom-kilo-xs" relative-url="" %}

В результате, наши красивые буллиты появляются не только в контенте, но и, например, в навигации, где тоже используются `ul li`.

Мы ограничиваем область действия селектора:

{% capture fig-3 %}
```css
.content ul li { 
  /* наши красивые стили */
}
```
{% endcapture %}
{% include browserframe.html content=fig-3 title="styles.css" class="space-out-bottom-kilo-xs" relative-url="" %}


Навигацию мы спасли, но ненужные буллиты всё еще вылазят на слайдерах, списках новостей и других конструкциях внутри `.content`, где тоже используются `ul li`.

Далее у нас варианты:

1) обнулить мешающие стили в слайдерах и других местах. Но это противоречит «<abbr title="Don't Repeat Yourself">DRY</abbr>» и является одним из <a href="http://csswizardry.com/2012/11/code-smells-in-css/" target="_blank" rel="noopener">признаков кода «с душком»</a>. К тому же не решает проблему раз и навсегда: добавите, например, аккордеон и списки в нем снова придется обнулять.

2) пойти от обратного и ставить класс всем спискам, которые нужно стилизовать:

```css
.textlist li {
  /* наши красивые стили */
}
```

Это добавляет лишней работы по расстановке классов в контенте. Иногда имеет смысл, но лишнюю работу никто не любит.

3) стилизовать только те `ul li`, у которых нет никаких классов вообще:

```css
ul:not([class]) li {
  /* наши красивые стили */
}
```

Победа! Нам не нужно делать дополнительную работу по расстановке классов в контенте. А на слайдерах, аккордеонах и прочих конструкциях, которые не должны выглядеть как списки, но используют их в своей разметке, в 99% случаев уже будут свои классы, и наши стили их не затронут.

Этот прием — «выбирать только элементы без класса» — очень полезен для оформления пользовательского контента и его можно применять не только к спискам, но и для оформления таблиц, цитат, списков определений.

## Пример 2. Изменение внешнего вида всех элементов, кроме наведенного

<figure>
  <a href="http://cssdeck.com/labs/dlg62kjv" target="_blank" rel="noopener"><img src="sample2.gif" width="600" height="150" alt="Изменение внешнего вида всех элементов, кроме наведенного"/></a>
  <figcaption>
    <p style="text-align: center;"><a href="http://cssdeck.com/labs/dlg62kjv" class="bigbutton" target="_blank" rel="noopener">Пример</a></p>
  </figcaption>
</figure>

Такой эффект можно реализовать без `:not` путем перезаписи значений. И это будет работать в бо́льшем количестве браузеров.

```css
/* с перезаписью свойств */
ul:hover li {
  opacity:0.5;
}
ul:hover li:hover {
  opacity:1;
}
```

Но если придется обнулять слишком много свойств, то есть смысл использовать `:not`.

```css
/* используя :not() */
ul:hover li:not(:hover) {
  opacity:0.5;
}
```

## Пример 3. Меню с разделителями между элементами

<figure>
    <a href="http://cssdeck.com/labs/dlg62kjv" target="_blank" rel="noopener"><img src="sample3.png" width="600" height="200" alt="Меню с разделителями между элементами"/></a>
  <figcaption>
    <p style="text-align: center;"><a href="http://cssdeck.com/labs/dlg62kjv" class="bigbutton" target="_blank" rel="noopener">Пример</a></p>
  </figcaption>
</figure>

Как и в предыдущем примере, желаемого можно добиться несколькими способами.

Через перезапись свойств. Но тут два правила вместо одного, что не есть «<abbr title="Don't Repeat Yourself">DRY</abbr>».

```css
.menu-item:after {
  content: ' | ';
}
.menu-item:last-child:after {
  content: none;
}
```

Через `:nth-last-child()`. Одно правило, но тяжело читается:

```css
.menu-item:nth-last-child(n+2):after {
  content: ' | ';
}
```

Через `:not(:last-child)` — самая короткая и понятная запись:

```css
.menu-item:not(:last-child):after {
  content: ' | ';
}
```

## Пример 4. Debug css

Удобно для отладки и самоконтроля искать/подсвечивать картинки без `alt`, `label` без `for` и другие ошибки.

```css
/* подсвечиваем теги без необходимых атрибутов */
img:not([alt]),
label:not([for]),
input[type=submit]:not([value]) {
  outline:2px solid red;
}

/* тревога, если первый child внутри списка не li и прочие похожие примеры */
ul > *:not(li),
ol > *:not(li),
dl > *:not(dt):not(dd) {
  outline:2px solid red;
}
```

## Пример 5. Поля форм

Раньше текстовых полей форм было не много. Достаточно было написать:

```css
select,
textarea,
[type="text"],
[type="password"] {
    /* стили для текстовых полей ввода */
}
```

С появлением новых типов полей в HTML5 этот список увеличился:

```css
select,
textarea,
[type="text"],
[type="password"],
[type="color"],
[type="date"],
[type="datetime"],
[type="datetime-local"],
[type="email"],
[type="number"],
[type="search"],
[type="tel"],
[type="time"],
[type="url"],
[type="month"],
[type="week"] {
  /* стили для текстовых полей ввода */
}
```

Вместо перечисления 14 типов инпутов можно исключить 8 из них:

```css
select,
textarea,
[type]:not([type="checkbox"]):not([type="radio"]):not([type="button"]):not([type="submit"]):not([type="reset"]):not([type="range"]):not([type="file"]):not([type="image"]) {
  /* стили для текстовых полей ввода */
}
```

Ладно, этот пример не очень красив, и я рекомендую всё же первый вариант с перечислением, он работает с IE8+, а второй вариант с IE9+.

## Поддержка

Следует заметить, что согласно <a href="http://www.w3.org/TR/css3-selectors/#negation" target="_blank" rel="noopener">спецификации</a> в скобках селектора <code class="hljs-pseudo">:not()</code> может стоять только <a href="http://www.w3.org/TR/css3-selectors/#simple-selectors-dfn" target="_blank" rel="noopener">простой селектор</a> и в скобках нельзя использовать сам селектор <code class="hljs-pseudo">:not()</code>. Если нужно исключить несколько элементов, <code class="hljs-pseudo">:not()</code> можно повторить несолько раз, как в примере 5.

<a href="http://caniuse.com/#search=%3Anot" target="_blank" rel="noopener">Поддержка :not() браузерами.</a>

Если очень нужны CSS3-селекторы в браузерах, которые их не поддерживают, можно использовать полифил <a href="http://selectivizr.com/" target="_blank" rel="noopener">selectivizr</a>.
