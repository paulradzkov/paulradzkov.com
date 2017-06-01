# Grunt Configuration
# http://gruntjs.com/getting-started#an-example-gruntfile

module.exports = (grunt) ->
	require('time-grunt')(grunt);
	require('load-grunt-tasks')(grunt);

	# Initiate the Grunt configuration.
	grunt.initConfig

		# Allow use of the package.json data.
		pkg: grunt.file.readJSON('package.json')

		# docpad variables
		docpad:
			files: [ './src/**/*.*' ]
			out: ['out']

		copy:
			main:
				files: [
					'./src/raw/vendor/ilyabirman-likely/likely.js':'./node_modules/ilyabirman-likely/release/likely.js'
				]
			ogimages:
				files: [
					expand: true
					cwd: 'src/raw/i/og/'
					src: ['*']
					dest: 'src/raw/i/og/'
					rename: (dest, src) ->
						dest + src.replace('127.0.0.1!8080!','paulradzkov-').replace('!','-')
				]

		less:
			dev:
				options:
					sourceMap: true
				files: [
					'out/css/homepage.css': 'src/raw/css/homepage.less'
					'out/css/template.css': 'src/raw/css/template.less'
					'out/css/article.css': 'src/raw/css/article.less'
					'out/ui/screenshot/screenshot.css': 'src/raw/ui/screenshot/screenshot.less'
					'out/fonts/webfonts.css': 'src/raw/fonts/webfonts.less'
				]

		postcss:
			options:
				# map: true # inline sourcemaps

				# or
				map:
					inline: false # save all sourcemaps as separate files...
					annotation: 'out/css/' # ...to the specified directory

				processors: [
					require('pixrem')() # add fallbacks for rem units
					require('autoprefixer-core')({browsers: [
						'Android 2.3'
						'Android >= 4'
						'Chrome >= 20'
						'Firefox >= 24'
						'Explorer >= 8'
						'iOS >= 6'
						'Opera >= 12'
						'Safari >= 6'
					]}) # add vendor prefixes
					# require('cssnano')() # minify the result
					#require('postcss-base64')({
					#	extensions: ['.png']
					#	root: 'src/raw/ui/screenshot/'
					#	})
				]
			dist:
				src: [
						'out/css/homepage.css'
						'out/css/template.css'
						'out/css/article.css'
						'out/ui/screenshot/screenshot.css'
					]

		#minify css
		cssmin:
			combine:
				files:
					'out/css/homepage.css':'out/css/homepage.css'
					'out/css/template.css':'out/css/template.css'
					'out/css/article.css':'out/css/article.css'
					'out/css/caniuse.css':'out/css/caniuse.css'
					'out/fonts/webfonts.css':'out/fonts/webfonts.css'

		#minify html
		htmlmin:
			out:
				options:
					removeComments: true
					collapseWhitespace: false
					minifyJS: true
					minifyCSS: false
				files: [
					expand: true
					cwd: 'out/'
					src: [
						'20*/**/*.html'
						'!2014/markdown_cheatsheet/*.html'
						'tags/**/*.html'
						'search/**/*.html'
						'*.html'
						'!google*.html'
						'!yandex*.html'
					]
					dest: 'out/'
				]

		#minify js
		uglify:
			out:
				files:
					'out/js/output.min.js':[
						'src/raw/vendor/ilyabirman-likely/likely.js'
					]
					'out/js/article.min.js':[
						'src/raw/vendor/jquery.sticky.js'
						'src/raw/vendor/bootstrap/js/bootstrap.min.js'
						'src/raw/js/script.js'
					]
		compress:
			main:
				options:
					mode: 'gzip'
				files: [
					expand: true
					cwd: 'out/'
					src: [
						'**/*.{html,css,js,xml,svg,ttf}'
						'!google*.html'
						'!yandex*.html'
					]
					dest: 'out/'
					rename: (dest, src) ->
						dest + src + '.gz'
				]

		# optimize images if possible
		imagemin:
			src:
				options:
					optimizationLevel: 3,
				files: [
					expand: true,
					cwd: 'src/',
					src: ['**/*.{png,jpg,jpeg,gif}'],
					dest: 'src/'
				]

		#clean files
		clean:
			less:
				'out/css/*.less'
			ogimages:
				'src/raw/i/og/og-127.0.0.1*'
			ogimagestemp:
				'src/raw/i/og/*.{png,jpg}.*'

		modernizr:
			dist:
				# [REQUIRED] Path to the build you're using for development.
				devFile: "bower_components/modernizr/modernizr.js"

				# Path to save out the built file.
				outputFile: "src/files/vendor/modernizr.js"

				# Based on default settings on http://modernizr.com/download/
				extra:
					shiv: true
					printshiv: false
					load: true
					mq: true
					cssclasses: true

				# Based on default settings on http://modernizr.com/download/
				extensibility:
					addtest: false
					prefixed: false
					teststyles: false
					testprops: false
					testallprops: false
					hasevents: false
					prefixes: false
					domprefixes: false
					cssclassprefix: ""

				# By default, source is uglified before saving
				uglify: true

				# Define any tests you want to implicitly include.
				tests: []

				# By default, this task will crawl your project for references to Modernizr tests.
				# Set to false to disable.
				parseFiles: true

				# When parseFiles = true, this task will crawl all *.js, *.css, *.scss and *.sass files,
				# except files that are in node_modules/.
				# You can override this by defining a "files" array below.
				files:
					src: [
						'src/documents/**/*.less'
						'src/documents/**/*.css'
						'src/documents/**/*.js'
					]

				# This handler will be passed an array of all the test names passed to the Modernizr API, and will run after the API call has returned
				# handler: function (tests) {},

				# When parseFiles = true, matchCommunityTests = true will attempt to
				# match user-contributed tests.
				matchCommunityTests: true

				# Have custom Modernizr tests? Add paths to their location here.
				customTests: []

		watch:
			less:
				files: ['src/raw/**/*.less']
				tasks: ['less', 'postcss']

		# generate development
		shell:
			clean:
				options:
					stdout: true
				command: 'docpad clean'
			docpad:
				options:
					stdout: true
				command: 'docpad generate --env static'
			ghpages:
				options:
					stdout: true
				command: 'docpad generate --env ghpages'
			run:
				options:
					stdout: true
					async: true
				command: 'docpad run'
			server:
				options:
					stdout: true
					async: true
				command: 'http-server ./out'

		# to remove unused in markup classes from css
		uncss:
			homepage:
				options:
					timeout: 5000
					ignore: [
						/\.likely([-a-zA-Z0-9_:>\*\s\[=\]])*/
					]
					stylesheets: [
						'css/homepage.css'
					]
				src: [
						'out/index.html'
						'out/2012/index.html'
						'out/2013/index.html'
						'out/2014/index.html'
						'out/2016/index.html'
						'out/demo/index.html'
						'out/tags/index.html'
						'out/search/index.html'
					]
				dest: 'out/css/homepage.css'

		'gh-pages':
			options:
				base: 'out'
				branch: 'master'
				repo: 'https://github.com/paulradzkov/paulradzkov.github.io.git'
			src: ['**/*']

		'ftp-deploy':
			build:
				auth:
					host: 'paulradzkov.com'
					port: 21
					authPath: '.ftppass'
					authKey: 'primary'
				src: 'out/'
				dest: '/www/paulradzkov.com'
				exclusions: [
					'out/**/.DS_Store'
					'out/**/Thumbs.db'
				]

		pagespeed:
			options:
				nokey: true
				url: "http://paulradzkov.com"
				locale: "ru_RU"
			prod:
				options:
					url: "http://paulradzkov.com"
					strategy: "desktop"
					threshold: 90
			paths:
				options:
					paths: [
						"/2016/code_review/"
						]
					strategy: "desktop"
					threshold: 80
		pageres:
			ogimages:
				options:
					urls: [
						'http://127.0.0.1:8080/2017/local_variables/'
						'http://127.0.0.1:8080/2016/code_review/'
						'http://127.0.0.1:8080/2014/web-fonts_license/'
						'http://127.0.0.1:8080/2014/free_substitution_for_helvetica_neue/'
						'http://127.0.0.1:8080/2014/deploy_docpad_site_to_github_pages/'
						'http://127.0.0.1:8080/2014/markdown_cheatsheet/'
						'http://127.0.0.1:8080/2014/designer-superstar/'
						'http://127.0.0.1:8080/2014/capture_screen_to_gif/'
						'http://127.0.0.1:8080/2014/font-weight_bolder/'
						'http://127.0.0.1:8080/2014/mailto_parameters/'
						'http://127.0.0.1:8080/2014/visited_link_on_hover/'
						'http://127.0.0.1:8080/2014/negation_css_selector/'
						'http://127.0.0.1:8080/2013/lists_and_floats/'
						'http://127.0.0.1:8080/2012/pointer-events/'
						'http://127.0.0.1:8080/2012/chrome_dev_tools/'
						'http://127.0.0.1:8080/2012/crosswise/'
						'http://127.0.0.1:8080/2012/mobile_developing/'
						'http://127.0.0.1:8080/2012/photoshop_next_and_previous_layer/'
						'http://127.0.0.1:8080/2012/html-entities_and_utf_codes/'
						'http://127.0.0.1:8080/2012/photoshop_new_layer_based_slice/'
						'http://127.0.0.1:8080/2012/autocomplete/'
						]
					sizes: ['1500x788']
					dest: 'src/raw/i/og'
					#filename: 'og-{{url}}-{{size}}{{crop}}'
					filename: 'og-{{url}}'
					crop: true
					css: 'out/ui/screenshot/screenshot.css'
					delay: 5 #seconds
					timeout: 120 #seconds
					scale: 0.8 #scales images down to 1200x630
					format: 'png' #jpg smaller, png looks better

	# Register our Grunt tasks.
	grunt.registerTask 'ogimages',      ['shell:server', 'pageres', 'copy:ogimages', 'clean:ogimages', 'imagemin' ]
	grunt.registerTask 'testnow',       ['shell:clean', 'shell:ghpages', 'production']
	grunt.registerTask 'ghpages',       ['shell:clean', 'shell:ghpages', 'production', 'gh-pages']
	grunt.registerTask 'deploy',        ['shell:clean', 'shell:ghpages', 'production', 'gh-pages']
	grunt.registerTask 'production',    ['less', 'uncss', 'postcss', 'cssmin', 'htmlmin', 'uglify', 'compress', 'clean']
	grunt.registerTask 'run',           ['shell:run', 'less', 'postcss', 'uglify', 'watch:less']
	grunt.registerTask 'cdn',           ['shell:clean', 'shell:docpad', 'production']
	grunt.registerTask 'default',       ['run']
