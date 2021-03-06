#! /usr/bin/env node
var acid = require('./')
var path = require('path')
var fs = require('fs')
var createEnv = require('./env')
var resolve = require('./resolve')(
  'node_modules', '.al', JSON.parse, 'package.json'
)
var {
  pretty,stringify,isBuffer,isNumber,readBuffer
} = require('./util')

var fs = require('fs')
function createImport (dir, env) {
  if(!env) env = createEnv()
  return function (require) {
    if(Array.isArray(require)) require = require[0]
    if(Buffer.isBuffer(require))
      require = require.toString()
    else if(isNumber(require))
      require = readBuffer(env.memory, require).toString()
    var target = resolve(require, dir)
    return acid.eval(fs.readFileSync(target, 'utf8'), {
      import: createImport(path.dirname(target), env),
      __proto__: env
    })
  }
}

module.exports = createImport

if(!module.parent) {
  var opts = require('minimist')(process.argv.slice(2))
  var env = createEnv(Buffer.alloc(65536), {0:0})
  var load = createImport(process.cwd(), env)
  var file = process.argv[2]
  if(!file)
    return console.error('acid {relative_path} > out.wat')
  //convert to a relative path
  if(!/^\.\.?\//.test(file)) file = './'+file

  if(opts.parse)
    console.log(pretty(acid.parse(fs.readFileSync(file, 'utf8'))))
  else if(opts.acid)
    console.log(pretty(require('./unroll')(load(file))))
  else if(opts.js)
    console.log(acid.js(load(file)), env)
  else
    console.log(acid.wat(load(file), env))
}
