# [paulradzkov.com](http://paulradzkov.com/) blog built with [Jekyll](https://jekyllrb.com/)


## Getting Started

1. ```npm install -g grunt-cli```

2. Clone the project and run the server

	``` bash
	git clone https://github.com/paulradzkov/paulradzkov.com.git
	cd paulradzkov.com
	npm install
	bundle exec jekyll serve
	```

3. [Open http://localhost:4000/](http://localhost:4000/)


## Automation

## Gulp tasks

`gulp cleanout` — delete `out` folder.  
`gulp cleansrc` — removes `*.map` files srom `src/ui` folder.

`gulp renderless` — compiles `*.less` to `*.css`.  
`gulp renderscss` — compiles `*.scss` to `*.css`.  
`gulp csspost` — postcss processing.  
`gulp lintcss` — lint style sources.

`gulp watcher` — watch changes and recompile.
`gulp build` — clean and build project.  
`gulp dev` — clean, build and watch.  
`gulp` — same as build.

## License

You are free to use code (HTML/JS/CoffeeScript) of this site, but you can’t use design (css, images) and content.
