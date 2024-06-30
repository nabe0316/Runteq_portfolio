const esbuild = require('esbuild')

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  publicPath: 'assets',
  loader: { '.js': 'jsx' },
  external: ['@hotwired/stimulus-loading']
}).catch(() => process.exit(1))