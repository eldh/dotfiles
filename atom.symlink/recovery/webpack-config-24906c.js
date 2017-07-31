const LodashWebpackPlugin = require('lodash-webpack-plugin')
const path = require('path')
const webpack = require('webpack')
const NameAllModulesPlugin = require('name-all-modules-plugin')
const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')
const AssetsPlugin = require('assets-webpack-plugin')
const { existsSync } = require('fs')

const cleanArr = arr => arr.filter(v => !!v)

module.exports = function createConfig ({ cwd = process.cwd(), env, sourceDir, buildDir }) {
  const config = {
    entry: {
      index: path.join(sourceDir, 'index.js'),
      vendor: ['react', 'react-dom']
    },
    resolve: {
      alias: {
        'react': path.resolve(cwd, 'node_modules', 'react'),
        '@dooer/package-info': path.join(__dirname, 'dooer-package-info.js'),
        '@dooer/logging': path.join(__dirname, 'dooer-logging.js')
      },
      modules: [
        'node_modules'
      ]
    },
    output: {
      path: buildDir,
      filename: env === 'production' ? '[name].[chunkhash].js' : '[name].js',
      publicPath: '/',
      sourcePrefix: '',
      sourceMapFilename: '[file].map'
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          loader: 'babel-loader',
          options: {
            presets: [
              '@dooer/babel-preset-dooer'
            ],
            plugins: cleanArr([
              env === 'production' && [path.resolve(cwd, 'node_modules', 'babel-plugin-react-intl'), {
                messagesDir: './dist/messages'
              }]
            ]),
            cacheDirectory: env !== 'production'
          },
          include: [
            path.resolve(sourceDir),
            path.resolve(cwd, 'node_modules', '@dooer', 'apollo-multipart-network-interface'),
            path.resolve(cwd, 'node_modules', 'map-obj')
          ]
        },
        { test: /\.css$/, use: [ { loader: 'style-loader' }, { loader: 'css-loader' } ] },
        { test: /\.png$/, use: 'file-loader' },
        { test: /\.svg$/, use: 'svg-inline-loader' }
      ]
    },
    plugins: [
      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(env),
        'process.env': 'window._dooer_env'
      })
    ],
    node: {
      dns: 'empty',
      fs: 'empty',
      net: 'empty',
      tls: 'empty'
    }
  }

  if (env === 'development') {
    config.devtool = 'eval'
  } else if (env === 'production') {
    config.plugins = [
      ...config.plugins,
      new LodashWebpackPlugin({
        collections: true
      }),
      new webpack.optimize.UglifyJsPlugin({
        compress: {
          screw_ie8: true,
          warnings: false
        },
        mangle: {
          screw_ie8: true
        },
        output: {
          comments: false,
          screw_ie8: true
        },
        sourceMap: true
      }),
      new webpack.optimize.MinChunkSizePlugin({ minChunkSize: 40000 }),
      new webpack.optimize.OccurrenceOrderPlugin(),
      new webpack.LoaderOptionsPlugin({
        minimize: true,
        debug: false
      }),
      new webpack.optimize.CommonsChunkPlugin({
        name: 'vendor',
        chunks: ['vendor', 'index'],
        filename: 'vendor.common.[chunkhash].js',
        minChunks: Infinity
      }),
      new webpack.optimize.CommonsChunkPlugin({
        name: 'runtime'
      }),
      new webpack.NamedModulesPlugin(),
      new webpack.NamedChunksPlugin(),
      new NameAllModulesPlugin(),
      new webpack.optimize.ModuleConcatenationPlugin(),
      new BundleAnalyzerPlugin({
        analyzerMode: 'static',
        openAnalyzer: false
      }),
      new AssetsPlugin({
        filename: 'assets.json',
        path: buildDir,
        processOutput: assets => {
          const filtered = Object.keys(assets).reduce((obj, k) => {
            const v = assets[k]
            const isMain = k.startsWith('index') || k.startsWith('runtime') || k.startsWith('vendor')
            return isMain
              ? Object.assign({}, obj, {[k]: v})
              : obj
          }, {})
          return JSON.stringify(filtered)
        }
      })
    ]
  }

  const configExtenderPath = path.join(cwd, 'dooer-frontend.config.js')

  if (!existsSync(configExtenderPath)) return config

  const configExtender = require(configExtenderPath)

  if (typeof configExtender !== 'function') {
    throw new TypeError(`⚠️ Frontend build configuration found at ${configExtenderPath}, but did not return a function`)
  }

  const extendedConfig = configExtender(config)

  if (!extendedConfig) {
    throw new Error(`⚠️ Frontend build configuration at ${configExtenderPath} didn't return a configuration. Using default configuration`)
  }

  return extendedConfig
}
