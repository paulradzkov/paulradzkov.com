const { src, dest, series, parallel, watch } = require('gulp')
const del = require('delete')
const less = require('gulp-less')
const sass = require('gulp-sass')
const cssmin = require('gulp-csso')
const rename = require('gulp-rename')
const sourcemaps = require('gulp-sourcemaps')
const postcss = require('gulp-postcss')
const autoprefixer = require('autoprefixer')
const gulpStylelint = require('gulp-stylelint')
const readConfig = require('read-config')
const svgSprite = require('gulp-svg-sprite')
const standard = require('gulp-standard')
const concat = require('gulp-concat')
var exec = require('child_process').exec
var spawn = require('child_process').spawn

// const pug = require('gulp-pug');

sass.compiler = require('node-sass')

function cleanout (cb) {
  del(['out/ui/'], cb)
}

function cleansrc (cb) {
  del(['src/ui/**/*.map'], cb)
}

function copyvendors () {
  return src([
    './node_modules/svgxuse/*.{js,md}'
  ], { base: 'node_modules' })
    .pipe(dest('./out/ui/'))
}

function copyui () {
  return src([
    'src/ui/**/*'
  ])
    .pipe(dest('./out/ui/'))
}


// function html() {
//  return src('client/templates/*.pug')
//    .pipe(pug())
//    .pipe(dest('build/html'))
// }

function renderless () {
  return src(['src/ui/**/*.less', '!src/ui/**/_*.less'])
    .pipe(sourcemaps.init())
    .pipe(less())
    .pipe(sourcemaps.write('.'))
    .pipe(dest('src/ui'))
}

function renderscss () {
  return src('src/ui/**/*.scss', 'src/ui/**/*.sass')
    .pipe(sourcemaps.init())
    .pipe(sass().on('error', sass.logError))
    .pipe(sourcemaps.write('.'))
    .pipe(dest('src/ui'))
}

function csspost () {
  var plugins = [
    autoprefixer()
  ]
  return src(['src/ui/**/*.css', '!src/ui/**/*.min.css'])
    .pipe(sourcemaps.init({ loadMaps: true }))
    .pipe(postcss(plugins))
    .pipe(cssmin())
    .pipe(sourcemaps.write('.'))
    .pipe(dest('out/ui'))
}

function lintcss () {
  return src('src/ui/**/*.less')
    .pipe(gulpStylelint({
      failAfterError: false,
      reportOutputDir: './reports/stylelint',
      reporters: [
        { formatter: 'verbose', console: true },
        { formatter: 'json', save: 'report.json' }
      ]
    }))
}

function lintjs () {
  return src(['src/ui/**/*.js', '*.js'])
    .pipe(standard())
    .pipe(standard.reporter('default', {
      breakOnError: false,
      quiet: true
    }))
}

function createsvgsprite () {
  return src('**/*.svg', { cwd: 'src/ui/icons' })
    .pipe(svgSprite(readConfig('src/ui/icons/default.config.yml')))
    .pipe(dest('out/ui/icons'))
}

function buildjs() {
  return src([
    'src/ui/jquery-sticky/jquery.sticky.js',
    'src/ui/bootstrap/js/bootstrap.min.js',
    'src/ui/script.js'
  ])
    .pipe(sourcemaps.init())
    .pipe(concat('article.min.js'))
    .pipe(sourcemaps.write('.'))
    .pipe(dest('out/ui'))
}

function watchsrc () {
  watch(['src/ui/**/*.less'], series(renderless, csspost))
  watch(['src/ui/**/*.scss', 'src/ui/**/*.sass'], series(renderscss, csspost))
  watch(['src/ui/**/*.js'], buildjs)
}

function jekyllbuild (cb) {
  exec('bundle exec jekyll build', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
}

function jekyllserve (cb) {
  exec('bundle exec jekyll serve', function (err, stdout, stderr) {
    console.log(stdout);
    console.log(stderr);
    cb(err);
  });
}


// chaining tasks

const clean = parallel(cleanout, cleansrc)
const assets = parallel(createsvgsprite, copyvendors, copyui)
const rendercss = parallel(renderless, renderscss)
const build = series(clean, rendercss, csspost, buildjs, cleansrc, assets)
const checks = series(lintcss)

exports.cleanout = cleanout
exports.cleansrc = cleansrc
exports.copyvendors = copyvendors
exports.buildjs = buildjs
exports.renderless = renderless
exports.renderscss = renderscss
exports.csspost = csspost
exports.lintcss = lintcss
exports.lintjs = lintjs
exports.createsvgsprite = createsvgsprite
// exports.html = html;
exports.watchsrc = watchsrc
exports.jekyllbuild = jekyllbuild
exports.jekyllserve = jekyllserve

exports.build = build
exports.clean = clean
exports.dev = series(build, watchsrc)
exports.checks = checks
exports.default = build
