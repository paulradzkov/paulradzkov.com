---
title: "Деплой Docpad-сайта на GitHub Pages"
excerpt: "Решение проблемы с абсолютными путями и автоматизация выкладки сайта на хостинг"
description: "Решение проблемы с абсолютными путями и автоматизация выкладки сайта на хостинг"
created_at: 2014-04-25
kind: article
publish: true
disqusid: deploy_docpad_site_to_github_pages
tags: [docpad, github pages]
og_image: '/i/og/og-paulradzkov-2014-deploy_docpad_site_to_github_pages.png'
---

При деплое [Docpad](http://docpad.org/)-сайта на [GitHub Pages](https://pages.github.com/) столкнулся с некоторыми проблемами.

1. Проблема с абсолютными путями: докпад по-умолчанию использует пути к ресурсам от корня домена, а на GH Pages url проекта будет выглядеть так `http://username.github.io/repository/`. Т.е. сайт находится в папке, а не в корне, и все пути к ресурсам недействительны. Конечно, можно купить собственное доменное имя, но это не мой случай. Нужно, чтобы на локалхосте url оставались абсолютными, а при деплое заменялись с учетом папки, в которую сайт деплоится.
2. [Плагин для деплоя](https://github.com/docpad/docpad-plugin-ghpages) не заработал сразу и без настроек, как обещает разработчик.
3. **Добавлено 6 мая 2018**: деплой из командной строки сломался после включения двухфакторной аутентификации на Гитхабе.

Так как у меня не всё прошло гладко и очевидно, решил написать эту инструкцию.

<!-- cut -->

## Проблема с абсолютными путями

Сначала разберёмся с абсолютными путями в докпаде.

Установим плагин [Get Url Plugin for DocPad](https://github.com/Hypercubed/docpad-plugin-geturl/).

Если ещё не создана, сделаем в конфиге докпада переменную `@site.url`:

{% capture fig-1 %}
```coffeescript
templateData:
  site:
    # The production url of our website. Used in sitemap and rss feed
    url: "http://paulradzkov.github.io/docpad-simpleblog"
```
{% endcapture %}
{% include browserframe.html content=fig-1 relative-url="" title="docpad.coffee" class="space-out-bottom-kilo-xs browserframe-scrollable" %}

И добавим отдельную конфигурацию для «development» окружения:

{% capture fig-2 %}
```coffeescript
# =================================
# Environments

environments:
  development:
    templateData:
      site:
        # The development url
        url: 'http://localhost:9778'
```
{% endcapture %}
{% include browserframe.html content=fig-2 relative-url="" title="docpad.coffee" class="space-out-bottom-kilo-xs" %}

Эта переменная — `@site.url` — будет подставляться префиксом ко всем путям и ссылкам в зависимости от того, работаем мы на локалхосте или выкатываем сайт на хостинг.

Теперь нужно добавить хелпер «`@getUrl()`» ко всем «`href`» и «`src`» в шаблоне, в документах — везде, где встречаются абсолютные пути.

Например, было:

{% capture fig-3-before %}
```html
<!-- DocPad Styles + Our Own -->
<%- @getBlock("styles").add(@site.styles).toHTML() %>

<script src="/vendor/modernizr.js"></script>
```
{% endcapture %}
{% include browserframe.html content=fig-3-before relative-url="" title="layout/default.html.eco" class="space-out-bottom-kilo-xs" %}

Стало:

{% capture fig-3-after %}
```html
<!-- DocPad Styles + Our Own -->
<%- @getBlock("styles").add(@getUrl(@site.styles)).toHTML() %>

<script src="<%= @getUrl('/vendor/modernizr.js') %>"></script>
```
{% endcapture %}
{% include browserframe.html content=fig-3-after relative-url="" title="layout/default.html.eco" class="space-out-bottom-kilo-xs" %}

Было:

{% capture fig-4-before %}
```html
<ul class="nav-list">
	<li><a href="/"><span>Blog</span></a></li>
	<li><a href="/docs"><span>Documentation</span></a></li>
	<li><a href="https://github.com/paulradzkov/docpad-simpleblog/issues"><span>Issues</span></a></li>
	<li><a href="https://github.com/paulradzkov/docpad-simpleblog"><span>Source Code</span></a></li>
</ul>
```
{% endcapture %}
{% include browserframe.html content=fig-4-before relative-url="" title="includes/nav.html.eco" class="space-out-bottom-kilo-xs" %}

Стало:

{% capture fig-4-after %}
```html
<ul class="nav-list">
	<li><a href="<%= @getUrl('/') %>"><span>Blog</span></a></li>
	<li><a href="<%= @getUrl('/docs') %>"><span>Documentation</span></a></li>
	<li><a href="https://github.com/paulradzkov/docpad-simpleblog/issues"><span>Issues</span></a></li>
	<li><a href="https://github.com/paulradzkov/docpad-simpleblog"><span>Source Code</span></a></li>
</ul>
```
{% endcapture %}
{% include browserframe.html content=fig-4-after relative-url="" title="includes/nav.html.eco" class="space-out-bottom-kilo-xs" %}

Было:

{% capture fig-5-before %}
```html
<ul class="meta-data">
	<li class="comments">
		<a href="<%= @document.path %>#disqus_thread" data-disqus-identifier="<%= @document.disqusid %>" >Комментарии</a>
	</li>
	<li class="tags-list">
		<% for tag in @document.tags : %>
			<a class="label-tag" href="<%= @getTagUrl(tag) %>"><%= tag %></a>
		<% end %>
	</li>
</ul>
```
{% endcapture %}
{% include browserframe.html content=fig-5-before relative-url="" title="layouts/article.html.eco" class="space-out-bottom-kilo-xs" %}

Стало:

{% capture fig-5-after %}
```html
<ul class="meta-data">
	<li class="comments">
		<a href="<%= @getUrl(@document.path) %>#disqus_thread" data-disqus-identifier="<%= @document.disqusid %>" >Комментарии</a>
	</li>
	<li class="tags-list">
		<% for tag in @document.tags : %>
			<a class="label-tag" href="<%= @getUrl(@getTagUrl(tag)) %>"><%= tag %></a>
		<% end %>
	</li>
</ul>
```
{% endcapture %}
{% include browserframe.html content=fig-5-after relative-url="" title="layouts/article.html.eco" class="space-out-bottom-kilo-xs" %}


И так далее.

Теперь, когда мы запускаем <kbd class="cli" contenteditable="true" >&zwj;<span contenteditable="false">docpad run</span>&zwj;</kbd>, ко всем путям подставляется `@site.url` из девелоперского окружения — `http://localhost:9778`. А когда <kbd class="cli" contenteditable="true" >&zwj;<span contenteditable="false">docpad run --env static</span>&zwj;</kbd>, переменная `@site.url` равна нашему продакшен пути.

## Деплой на GitHub Pages

В репозитории создадим ветку «`gh-pages`». По инструкции это должна быть пустая ветка без истории, но об этом в дальнейшем позаботится плагин для деплоя.

<figure>
	<img src="new_branch_gh-pages.png" alt="В репозитории проекта создадим ветку с именем «gh-pages»">
	<figcaption>В репозитории проекта создадим ветку с именем «<code>gh-pages</code>»</figcaption>
</figure>

Установим [GitHub Pages Deployer Plugin for DocPad](https://github.com/docpad/docpad-plugin-ghpages).

При попытке выполнить <kbd class="cli" contenteditable="true">&zwj;<span contenteditable="false">docpad deploy-ghpages --env static</span>&zwj;</kbd> у меня появляется ошибка:

<figure>
	<img src="gh-pages_deploy_error.png" alt="could not read Username for ’http://github.com’: No such file or directory">
	<figcaption><code>could not read Username for ’http://github.com’: No such file or directory</code></figcaption>
</figure>

Плагин не смог соединиться с моим аккаунтом на гитхабе. Чтобы показать плагину правильный путь с логином и паролем, добавим новый «remote» для репозитория. Для этого в консоли git выполним:

<p><kbd class="cli" contenteditable="true" >&zwj;<span contenteditable="false">git remote add deploy <span>https://</span>login:password@github.com/repo_owner/repo_name.git</span>&zwj;</kbd></p>

Где «`deploy`» — это название удаленного репозитория. Можно выбрать любое, но переопределять «origin» я бы не советовал: у меня от этого локальная копия репозитория потеряла связь с Гитхабом.

«`login`» и «`password`» — данные вашего аккаунта на Гитхабе.

«`github.com/repo_owner/repo_name.git`» — путь к репозиторию проекта, в котором у вас есть права на запись. Это не обязательно должен быть ваш репозиторий, если вы коллаборатор, и у вас есть доступ на запись — вы можете деплоить туда проект.

<figure>
	<img src="adding_another_remote.png" alt="Добавление нового «remote» c логином и паролем">
	<figcaption>Добавление нового «remote» c логином и паролем. Эту процедуру нужно выполнить один раз для каждого локального репозитория</figcaption>
</figure>

А в конфиге докпада пропишем настройки для плагина:

{% capture fig-6 %}
```coffeescript
# Plugins configurations
plugins:
  ghpages:
    deployRemote: 'deploy'
    deployBranch: 'gh-pages'
```
{% endcapture %}
{% include browserframe.html content=fig-6 relative-url="" title="docpad.coffee" class="space-out-bottom-kilo-xs" %}

Теперь можно выкатывать сайт:

<kbd class="cli" contenteditable="true" >&zwj;<span contenteditable="false">docpad deploy-ghpages --env static</span>&zwj;</kbd>

## Двухфакторная аутентификация

**Добавлено 6 мая 2018**

Когда я включил двухфакторную аутентификацию на Гитхабе, деплой из командной строки перестал работать. Чтобы починить, вместо вашего пароля в настройках remote нужно подставить сгенерированный токен. Сгенерируйте его по этой [инструкции](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/). Если кратко:

1. На Гитхабе кликните по вашему аватару, потом **Settings** → **Developer settings** → **Personal access tokens** → **Generate new token**.
2. Дайте токену любое имя, например, «Mac terminal» или «Windows cmd».
3. Поставьте уровень доступа **repo**.
4. Нажмите **Generate token**.
5. Скопируйте полученный токен. Когда вы уйдете с этой страницы, токен уже нельзя будет посмотреть.

Вам нужно добавить новый «remote» (или заменить существующий) с токеном вместо пароля:

<p><kbd class="cli" contenteditable="true" >&zwj;<span contenteditable="false">git remote add deploy <span>https://</span>login:<mark>token</mark>@github.com/repo_owner/repo_name.git</span>&zwj;</kbd></p>

И всё снова заработает.
