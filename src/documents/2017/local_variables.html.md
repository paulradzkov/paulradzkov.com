---
title: "Используйте локальные переменные в LESS и SASS, чтобы избежать хаоса"
excerpt: "История архитектурной ошибки, её последствия и три правила, благодаря которым вы начнёте писать более стабильный, понятный и легко-поддерживаемый код."
description: "История архитектурной ошибки, её последствия и три правила, благодаря которым вы начнёте писать более стабильный, понятный и легко-поддерживаемый код."
created_at: 2017-06-01
kind: article
publish: false
disqusid: local_variables
tags: []
og_image: '/i/og/og-paulradzkov-2017-local_variables.png'
---

История архитектурной ошибки, её последствия и три правила, благодаря которым вы начнёте писать более стабильный, понятный и легко-поддерживаемый код.

<!-- cut -->

# Предыстория

В 2014 году в компании начали редизайн проекта и в основу вёрстки мы положили свежий на тот момент Bootstrap 3.0.1. Использовали мы его не как отдельную стороннюю библиотеку, а тесно заинтегрировали с нашим собственным кодом: отредактировали переменные под наш дизайн и компилировали кастомизированный Бутстрап из LESS исходников самостоятельно. Проект оброс собственными модулями, которые использовали бутстраповские переменные и добавляли в файл с настройками свои новые переменные.

В тот момент я думал, что это правильный подход. Ведь код сразу компилируется с нужными значениями без переопределения стилей. CSS чистый, компактный и без повторений. Компоненты стилизованы с помощью глобальных настроек.

Через год с небольшим редизайн закончился, проект вышел в продакшн, и мы взялись за технический долг. При попытке обновить Бутстрап до версии 3.6.x выяснилось, что смержить новый variables.less с нашим файлом настроек будет нелегко. В Бутстрапе переименовали или убрали часть переменных, добавили новые. Собственные компоненты Бутстрапа обновились без проблем, а вот наши компоненты падали при компиляции из-за этих изменений.

Мы проанализировали ситуацию и сформулировали проблемы.


# Проблемы

1. **Слишком связанный код.**

  Сами компоненты лежали в отдельных файлах. Это создавало иллюзию, что компоненты независимые. Но компоненты использовали переменные, объявленные в отдельном файле variables.less, и без этого файла не работали. Нельзя было просто так взять и переместить компонент в другой проект. Приходилось тянуть за собой файл с настройками, который со временем превратился в помойку.

2. **Слишком много глобальных переменных**.

  У Бутстрапа было ≈400 переменных. Мы отключили неиспользуемые компоненты Бутстрапа, но переменные оставили в конфиге на случай, если снова понадобятся. Еще мы добавили сотню или полторы своих переменных. Все названия не запомнить, трудно быстро находить нужные. Даже с правилами именования и комментариями ориентироваться в конфиге из 500+ переменных тяжело.

3. **Имена глобальных переменных вышли из-под контроля**.

  Одна и та же переменная могла использоваться в разных файлах и отслеживать все её появления в коде было долго и трудно. Когда меняли значение переменной в одном компоненте, был риск поломать другие компоненты. Разработчики хардкодили, создавали новые переменные с похожими названиями и значениями и уже не следили за логикой именования.


# Что делать

1. **Переменная используется только в том файле, в котором объявлена.**

  Правильно создавать все нужные переменные в файле самого компонента и не использовать переменные из других файлов. Тогда компоненты станут независимыми, их можно будет подключать и перемещать между проектами без поломок при компиляции. У каждого компонента собственный набор переменных, которые запрещено использовать в других компонентах и вызывать в других файлах. Когда переменные не выходят за пределы одного файла, легко увидеть, как они используются и на что влияют.

2. **Все переменные внутри компонента — локальные.**

  Раз у каждого компонента свои переменные, пусть они будут локальными. Это избавит от проблем с именованием: в компонентах можно использовать переменные с одинаковыми именами и разными значениями — они не будут конфликтовать друг с другом.

3. **Глобальные переменные не используются внутри компонентов.**

  Благодаря первым двум правилам мы сильно сократим количество глобальных переменных, но они всё равно нужны. Глобальные переменные объявляются в главном файле проекта или в файле типа config.less. К ним тоже применяется правило №1 — переменные не используются за пределами этого файла. Зато существует способ не нарушая первого правила прокинуть значение глобальной переменной внутрь компонента и не использовать имя этой переменной в другом файле.

Рассмотрим на практике.

# Реализация на LESS

Представим компонент для стилизации страницы:

```css
/* page.css */
.page {
  padding: 40px;
  color: #000;
  background-color: #fff;
}
```

Применим правило №1 и создадим переменные внутри файла компонента:

```less
// page.less

@padding: 40px;
@txt-color: #000;
@bg-color: #fff;

.page {
  padding: @padding;
  color: @txt-color;
  background-color: @bg-color;
}
```

В примере выше мы объявили переменные в глобальной области видимости и из-за этого они подвержены конфликту имён. Если в соседнем компоненте мы создадим переменную с таким же именем, то получим нежелательный результат.


## Локальные переменные

**Область видимости** — это «пространство» между фигурными скобками селектора: { и } . Объявленные внутри фигурных скобок переменные работают только внутри этих скобок и внутри дочерних скобок, но их нельзя использовать снаружи.

Если скобок вокруг нет, то это самый верхний уровень — **глобальная область видимости**.

У переменной из дочерней области видимости приоритет выше, чем у одноименной переменной из родительской области видимости. У глобальных переменных самый низкий приоритет при совпадении имён.

По правилу №2 сделаем переменные локальными —  переместим их внутрь селектора:

```less
// page.less

.page {
  @padding: 40px;
  @txt-color: #000;
  @bg-color: #fff;

  padding: @padding;
  color: @txt-color;
  background-color: @bg-color;
}
```

Теперь конфликта имен с другими компонентами не будет. Мы решили первую и вторую проблемы: получился изолированный сниппет без внешних зависимостей. Но я не знаю способа переопределить локальные переменные компонента в таком виде извне. Поэтому, чтобы кастомизировать компоненты глобальными переменными проекта, придумал другую форму записи.

## Миксины как функции

В LESS можно использовать миксины как функции.
http://lesscss.org/features/#mixins-as-functions-feature

Если внутри миксина создать переменные, а потом вызвать миксин внутри селектора, то переменные будут доступны в области видимости этого селектора.

Вынесем объявление переменных внутрь миксина .page-settings(), а потом вызовем его внутри селектора .page:

```less
// page.less
.page-settings() {
  @padding: 40px;
  @txt-color: #000;
  @bg-color: #fff;
}

.page {
  .page-settings();
  padding: @padding;
  color: @txt-color;
  background-color: @bg-color;
}
```

Переменные локализованы внутри глобального миксина. Когда мы вызвали миксин в коде, переменные стали доступны в области видимости селектора .page, но по прежнему остались локальными.

Такой миксин не генерирует CSS код, его единственная задача — доставить переменные в нужную область видимости. Если вызвать этот миксин в глобальной области видимости, то и переменные станут глобальными. Но  это то же самое, что сразу объявить переменные глобально.

Вместо нескольких глобальных переменных с распространёнными именами мы создали один глобальный миксин. в проекте не должно быть двух одноименных компонентов, значит имя миксина будет уникальным.


## Слияние миксинов

В CSS два одинаковых селектора, написанных в разных местах кода, объединяют свои свойства в CSSOM. в случае одинаковых свойств, у последнего по следованию в коде приоритет выше. Оно переопределяет предыдущее значение этого свойства.

```less
.page {
  padding: 40px;
  color: #000;
  background-color: #fff;
}

// some lines below

.page {
  margin: 0;
  color: white;
  background-color: darkblue;
}
```

↓ эквивалентно

```less
.page {
  margin: 0;
  padding: 40px;
  color: white;
  background-color: darkblue;
}
```

Точно так же ведут себя миксины в LESS. Если два раза объявить миксин с одним и тем же именем, то они объединяют свои внутренности. А если внутри миксинов одинаковые переменные, то второй миксин переопределит значения переменных первого миксина.

Рассмотрим три файла. в главном файле проекта мы импортируем компоненты и файл с конфигурацией:

```less
// projectname.less
@import 'typography.less';
@import 'page.less';
// other files here...

@import 'config.less';
// end of file projectname.less
```

Сам компонент остался без изменений:

```less
// page.less
.page-settings() {
  @padding: 40px;
  @txt-color: #000;
  @bg-color: #fff;
}

.page {
  .page-settings();
  padding: @padding;
  color: @txt-color;
  background-color: @bg-color;
}
// end of file page.less
```

В конфиге мы создали глобальные переменные, повторно объявили миксин настроек нашего компонента, в котором переопределили локальные переменные значениями глобальных:

```less
// config.less

@glob-text-color: white;
@glob-bg-color: darkblue;

// customizing
.page-settings() {
  @txt-color: @glob-text-color;
  @bg-color: @glob-bg-color;
}

// end of file config.less
```

Миксин .page-settings объявлен два раза. Первый раз внутри файла page.less, второй — в файле config.less. На этапе компиляции миксины склеиваются, переменные переопределяются и CSS рендерится с новыми значениями из файла конфигурации.

Обратите внимание, что config.less инклюдится последним в списке. Это нужно, чтобы объявление миксина в конфиге имело больший приоритет, чем исходное объявление в файле самого компонента. Настройки не применятся, если поставить config.less до компонента.

Таким способом мы прокинули значения глобальных переменных внутрь файла компонента, не меняя исходный код компонента. При этом были соблюдены все три правила:

1. переменные использовались только в своём файле, даже глобальные переменные не вызывались за пределами файла config.less;
2. переменные компонента остались локальными и не засорили глобальную область видимости;
3. глобальные переменные не использовались внутри компонента напрямую, но значения глобальных переменных хитрым способом попали внутрь компонента.


## Ограничения

Нельзя, чтобы имя глобальной переменной совпадало с именем локальной, иначе получим рекурсию и CSS не скомпилируется.

```less
// так нельзя
@txt-color: white;

.page-settings() {
  @txt-color: @txt-color; //тут рекурсия и ошибка компиляции
}
```

Чтобы не ошибиться, лучше все глобальные переменные записывать с префиксом:

```less
// правильно — с префиксом
@glob-txt-color: white;

.page-settings() {
  @txt-color: @glob-txt-color; //всё в порядке
}
```

# Реализация в SASS

SASS отличается от LESS и больше похож на скриптовый язык программирования: переменная должна быть объявлена до её использования в коде; переопределять переменные тоже нужно до их использования. Трюк с миксинами, как в LESS, не пройдет. Но есть другие пути решения.


> Я на SASS каждый день не пишу и всех тонкостей языка не знаю, возможно, есть способ реализовать эту методологию более красивым способом.

Наборы переменных для настройки компонента удобно хранить в map-объектах. Это массив из пар «ключ: значение». Метод **map-get** извлекает конкретное значение из массива, метод **map-merge** объединяет два массива в один, дополняя или переписывая исходный массив.

Простейший компонент без возможности переопределения извне будет выглядеть так:

```scss
// page.scss

$page-settings: (
    padding: 40px,
    bg-color: #fff,
    text-color: #000,
);

.page {
    padding:          map-get($page-settings, padding);
    background-color: map-get($page-settings, bg-color);
    color:            map-get($page-settings, text-color);
}
```

Чтобы настраивать компонент из другого файла, нужно предусмотреть возможность смержить внешний конфиг с исходными настройками.

Рассмотрим три файла. в главном файле проекта мы сначала импортируем конфигурацию, а затем файлы компонентов:

```scss
// projectname.scss
@import: 'config';

@import: 'typography';
@import: 'page';
```

В конфиге мы объявляем глобальные переменные, а потом переопределяем ими ключи в массиве настроек компонента:

```scss
// config.scss
$glob-text-color: white;
$glob-bg-color: darkblue;

$page-settings: (
    bg-color: $glob-bg-color,
    text-color: $glob-text-color,
);
// eof config.scss
```

В файл компонента придется добавить чуть больше логики:

```scss
// page.scss

$page-override: ( );

@if variable-exists(page-settings) {
    $page-override: $page-settings;
}

$page-settings:  map-merge((
    padding: 40px,
    bg-color: #fff,
    text-color: #000,
), $page-override);

.page {
    padding:          map-get($page-settings, padding);
    background-color: map-get($page-settings, bg-color);
    color:            map-get($page-settings, text-color);
}
```

Сначала объявили переменную с пустым массивом  `$page-override: ( );`
Потом проверили, а не существует ли уже переменная  `$page-settings`. и если она уже существует,  а именно была объявлена в конфиге, то присвоили её значение переменной `$page-override`.

И потом смержили исходный конфиг и `$page-override` в переменную `$page-settings`.

Если `$page-settings` не был определен ранее, то в переменной `$page-override` будет пустой массив и в результате в настройках останутся исходные значения.

Если `$page-settings` был объявлен ранее в глобальном конфиге, то `$page-override` уже не будет пустым перепишет настройки при слиянии.

В результате мы получаем всё те же преимущества, только нам приходится создавать две глобальные переменные на модуль и переопределять все настройки до их непосредственного использования в коде.


# Выводы

Не важно на чем вы пишете — на LESS, SASS или Javascript — глобальных переменных должно быть как можно меньше.

С CSS препроцессорами используйте три правила, которые помогут избежать хаоса:
  1. Переменная используется только в том файле, в котором объявлена.
  2. Все переменные внутри компонента — локальные.
  3. Использовать глобальные переменные внутри компонентов запрещено.

Третье правило избыточное. Соблюдая первые два, вы автоматически соблюдаете третье. Но в реальной жизни есть очень большой соблазн пойти по простейшему пути, не создавать локальную переменную, а по-быстрому использовать глобальную. Третье правило напоминает, что так делать вредно.

Чтобы прокинуть глобальные настройки внутрь компонента, собирайте переменные в миксин (LESS) или map-объект (SASS).

Переопределяйте настройки в правильном месте: в LESS — после инклюда, в SASS — перед инклюдом.


# Реальные примеры

Я сформулировал эту методологию в декабре 2015 года для LESS и с тех пор применяю её на рабочих и личных проектах.

За полтора года появилось несколько публичных npm-пакетов. Посмотрите исходный код для лучшего понимания, как работает эта методология в реальных ситуациях.

[bettertext.css](https://github.com/paulradzkov/bettertext.css/blob/master/bettertext.less) — типографика для сайтов. Настраивается при помощи 11 переменных, остальные 40 вычисляются по формулам. Вычисления идут отдельными миксином, чтобы была возможность переопределять формулы.  У компонента нет ни одного класса, все стили применяются к тегам. Чтобы создать локальную область видимости, я поместил все селекторы по тегам в переменную — в LESS это называется «detached ruleset».

[links.less](https://github.com/paulradzkov/links.less/blob/master/links.less) — стили для ссылок с фокусом, анимацией и бледным подчеркиванием. У компонента кроме миксина с настройками есть дополнительные глобальные миксины для раскрашивания ссылок внутри ваших собственных селекторов.

[flxgrid.css](https://github.com/paulradzkov/flxgrid.css/blob/master/flxgrid.less) — генератор HTML-сеток на флексах. Настраивается при помощи 5 переменных, генерирует классы для адаптивной сетки с любыми брейкпоинтами и любым количеством колонок. в компоненте вычисления и служебные миксины спрятаны внутрь локальной области видимости. Глобально виден только миксин с настройками.

[space.less](https://github.com/paulradzkov/space.less/blob/master/space.less) — инструмент для управления отступами в вёрстке. Создан, чтобы работать в паре с сеткой flxgrid.css, и адаптивность у них настраивается одинаково. Но space.less использует собственный миксин настройки и собственные локальные переменные — в коде space.less никак не связан с flxgrid.css.


# «Бонус-трек»

Если бы мне сейчас понадобилось использовать на новом проекте Bootstrap 3.x.x — тот, который на LESS, — я бы все импорты Бутстрапа завернул в переменную (это называется «detached ruleset»), а все настройки в миксин bootsrtap-settings. Это сделает все глобальные переменные Бутстрапа изолированными внутри этой переменной, чтобы они не смешивались с переменными проекта и их невозможно было использовать внутри собственного кода. Настройки Бутстрапа я бы кастомизировал по мере необходимости, вызывая миксин bootsrtap-settings в конфиге проекта, как в примерах в этой статье. Тогда при обновлениях Бутстрапа пришлось бы переписать только миксин с кастомизированными настройкам. Вся проблема была бы сосредоточена внутри одного файла.