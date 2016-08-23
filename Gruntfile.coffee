# Grunt Configuration
# http://gruntjs.com/getting-started#an-example-gruntfile

module.exports = (grunt) ->

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
					'./src/raw/vendor/likely/likely.js':'./bower_components/Likely/release/likely.js'
				]

		less:
			dev:
				options:
					sourceMap: true
				files: [
					'out/css/template.css': 'src/raw/css/template.less'
					'out/fonts/webfonts.css': 'src/raw/fonts/webfonts.less'
				]

		postcss:
			options:
				# map: true # inline sourcemaps

				# or
				map:
					inline: false # save all sourcemaps as separate files...
					annotation: 'out/css/maps/' # ...to the specified directory

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
				]
			dist:
				src: 'out/css/template.css'

		#minify css
		cssmin:
			combine:
				files:
					'out/css/template.css':'out/css/template.css'
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
						'out/vendor/jquery.sticky.js'
						'out/vendor/bootstrap/js/bootstrap.min.js'
						'out/js/script.js'
						'out/vendor/likely/likely.js'
					]
					'out/js/isotope-settings.js':'out/js/isotope-settings.js'
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

	# Build the available Grunt tasks.
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-htmlmin'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-compress'
	grunt.loadNpmTasks 'grunt-contrib-jshint'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-modernizr'
	grunt.loadNpmTasks 'grunt-shell-spawn'
	grunt.loadNpmTasks 'grunt-ftp-deploy'
	grunt.loadNpmTasks 'grunt-gh-pages'
	grunt.loadNpmTasks 'grunt-postcss'
	grunt.loadNpmTasks 'grunt-pagespeed'

	# Register our Grunt tasks.
	grunt.registerTask 'ghpages',       ['shell:clean', 'shell:ghpages', 'production', 'gh-pages']
	grunt.registerTask 'deploy',        ['shell:clean', 'shell:docpad', 'production', 'ftp-deploy']
	grunt.registerTask 'production',    ['less', 'postcss', 'cssmin', 'htmlmin', 'uglify', 'compress', 'clean']
	grunt.registerTask 'run',           ['shell:run', 'less', 'postcss', 'watch:less']
	grunt.registerTask 'cdn',           ['shell:clean', 'shell:docpad', 'production']
	grunt.registerTask 'default',       ['run']
