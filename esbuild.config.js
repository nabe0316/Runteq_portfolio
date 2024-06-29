const esbuild = require('esbuild');

esbuild.build({
  entryPoints: ['app/javascript/application.js'],
  bundle: true,
  sourcemap: true,
  outdir: 'app/assets/builds',
  publicPath: 'assets',
  external: ['@hotwired/turbo-rails', '@hotwired/stimulus', '@hotwired/stimulus-loading'],
}).catch(() => process.exit(1));