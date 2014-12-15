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

		# add vendor prefixes
		autoprefixer:
			options:
				browsers: [
					'Android 2.3'
					'Android >= 4'
					'Chrome >= 20'
					'Firefox >= 24'
					'Explorer >= 8'
					'iOS >= 6'
					'Opera >= 12'
					'Safari >= 6'
				]
			default:
				options:
					map: false
				src: 'out/css/template.css'

		#minify css
		cssmin:
			combine:
				files:
					'out/css/template.css':'out/css/template.css'
					'out/css/caniuse.css':'out/css/caniuse.css'

		#minify html
		htmlmin:
			out:
				options:
					removeComments: true
					collapseWhitespace: true
					minifyJS: true
					minifyCSS: true
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
						'out/js/script.js'
						'out/vendor/bootstrap/js/bootstrap.min.js'
						'out/js/tooltip.js'
					]
					'out/js/isotope-settings.js':'out/js/isotope-settings.js'

		#clean files
		clean:
			less:
				'out/css/*.less'

	# Build the available Grunt tasks.
	grunt.loadNpmTasks 'grunt-autoprefixer'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-jshint'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-htmlmin'
	grunt.loadNpmTasks 'grunt-contrib-uglify'

	# Register our Grunt tasks.
	grunt.registerTask 'production',    ['default', 'cssmin', 'htmlmin', 'uglify', 'clean']
	grunt.registerTask 'default',       ['autoprefixer']
