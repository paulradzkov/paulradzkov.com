--- 
title: "Деплой Docpad сайта на GitHub Pages"
excerpt: ""
description: ""
created_at: 2014-02-10
kind: article
publish: true
disqusid: deploy_docpad_site_to_github_pages
tags: [docpad, github pages]
---

При деплое [докпад]() сайта на [GitHub Pages](https://pages.github.com/) столкнулся с некоторыми проблемами.

1. Проблема с абсолютными путями: докпад по-умолчанию использует пути к ресурсам от корня домена, а на GH Pages url проекта будет выглядеть так `http://username.github.io/repository/` (если у вас нет своего доменного имени). Т.е. сайт находится в папке, а не в корне, и все пути к ресурсам недействительны. Нужно, чтобы на локалхосте url оставались абсолютными, а при деплое заменялись с учетом папки, в которой лежит сайт на хосинге.
2. Плагин для деплоя не заработал сразу и без настроек, как обещал разработчик.

Так как у меня не всё прошло гладко и очевидно, и на случай, если сам забуду, что делал, решил написать этот тьюториал.

<!-- cut -->

## Проблема с абсолютными путями

Сначала разберемся с абсолютными путями в докпаде.

1. Установим плагин [Get Url Plugin for DocPad](https://github.com/Hypercubed/docpad-plugin-geturl/)

2. Создадим в конфиге докпада `@site.url`:

	templateData:
		site:
			# The production url of our website. Used in sitemap and rss feed
			url: "http://interpaul.github.io/docpad-simpleblog"

И отдельную конфигурацию для «development» окружения:

	# =================================
	# Environments

	environments:
		development:
			templateData:
				site:
					url: 'http://localhost:9778'

Эта переменная — `@site.url` — будет подставляться префиксом ко всем путям и ссылкам в зависимости от окружения.

3. Теперь нужно добавить хелпер `@getUrl()` ко всем `href` и `src` в шаблоне, документах — везде-везде.

Например, было:

	<!-- DocPad Styles + Our Own -->
	<%- @getBlock('styles').add(@site.styles).toHTML() %>

	<script src="/vendor/modernizr.js"></script>

Стало:

	<!-- DocPad Styles + Our Own -->
	<%- @getBlock('styles').add(@getUrl(@site.styles)).toHTML() %>

	<script src="<%= @getUrl('/vendor/modernizr.js') %>"></script>

Было:

	<ul class="nav-list">
		<li><a href="/"><span>Blog</span></a></li>
		<li><a href="/docs"><span>Documentation</span></a></li>
		<li><a href="https://github.com/interpaul/docpad-simpleblog/issues"><span>Issues</span></a></li>
		<li><a href="https://github.com/interpaul/docpad-simpleblog"><span>Source Code</span></a></li>
	</ul>

Стало:

	<ul class="nav-list">
		<li><a href="<%= @getUrl('/') %>"><span>Blog</span></a></li>
		<li><a href="<%= @getUrl('/docs') %>"><span>Documentation</span></a></li>
		<li><a href="https://github.com/interpaul/docpad-simpleblog/issues"><span>Issues</span></a></li>
		<li><a href="https://github.com/interpaul/docpad-simpleblog"><span>Source Code</span></a></li>
	</ul>

Было:

	<ul class="meta-data">
		<li class="comments"><a href="<%= @document.path %>#disqus_thread" data-disqus-identifier="<%= @document.disqusid %>" >Комментарии</a></li>
		<li class="tags-list">
			<% for tag in @document.tags : %>
				<a class="label-tag" href="<%= @getTagUrl(tag) %>"><%= tag %></a>
			<% end %>
		</li>
	</ul>

Стало:

	<ul class="meta-data">
		<li class="comments"><a href="<%= @getUrl(@document.path) %>#disqus_thread" data-disqus-identifier="<%= @document.disqusid %>" >Комментарии</a></li>
		<li class="tags-list">
			<% for tag in @document.tags : %>
				<a class="label-tag" href="<%= @getUrl(@getTagUrl(tag)) %>"><%= tag %></a>
			<% end %>
		</li>
	</ul>

И так далее.

Теперь, когда мы запускаем `docpad run`, ко всем путям подставляется `@site.url` из девелоперского окружения — `http://localhost:9778`. А когда `docpad run --env static`, переменная `@site.url` равна нашему продакшен пути.

## Деплой на GitHub Pages

1. Создадим ветку `gh-pages`. По мануалу это должна быть пустая ветка без истории, но об этом в дальнейшем позаботится плагин для деплоя. 

2. Установим [GitHub Pages Deployer Plugin for DocPad](https://github.com/docpad/docpad-plugin-ghpages)

При попытке выполнить `docpad deploy-ghpages --env static` у меня появляется ошибка.

Это значит, что плагин не может соединиться с вашим аккаунтом на гитхабе.

3. Чтобы показать плагину правильный путь, добавим новый «remote» для репозитория. Для этого в консоли git выполните `git remote add deploy https://login:password@github.com/repo_owner/repo_name.git`. Где «deploy» — это название удаленного репозитория (может быть любым, но если выбрать «origin» локальная копия репозитория скорее всего потеряет связь с Гитхабом); 
«login» и «password» — данные вашего аккаунта на Гитхабе; «github.com/repo_owner/repo_name.git» — путь к репозиторию проекта, в котором у вас есть права на запись (т.е. это не обязательно должен быть ваш репозиторий, достаточно быть коллаборатором).

Стоит отметить, что эту процедуру нужно выполнить один раз для каждого локального репозитория.

А в конфире докпада пропишем настройки для плагина:

	# Plugins configurations
	plugins:
		ghpages:
			deployRemote: 'deploy'
			deployBranch: 'gh-pages'

4. Теперь можно выкатывать сайт: `docpad deploy-ghpages --env static`