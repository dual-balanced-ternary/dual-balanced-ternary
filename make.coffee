
require 'shelljs/make'

station = require 'devtools-reloader-station'
station.start()

fs = require 'fs'

{renderer} = require 'cirru-html'

target.reload = ->
  station.reload 'dual-balanced'

target.html = ->
  file = 'cirru/index.cirru'
  render = renderer (cat file), {}
  render().to 'index.html'
  target.reload()

target.coffee = ->
  exec 'coffee -o js/ -wbc coffee', async: yes

target.browserify = ->
  exec 'browserify -o build/build.js -d js/main.js', ->
    target.reload()

target.watch = ->
  fs.watch 'cirru', interva: 200, target.html
  fs.watch 'coffee', interva: 200, target.coffee
  fs.watch 'js', interva: 200, target.browserify