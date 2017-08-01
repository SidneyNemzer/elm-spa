const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

/*
This file tells Webpack how to compile the files in /src to /build
*/

// Add 'page' objects to this array to add new files
const pages = [
  // None of these fields are optional; Webpack will probably error if you leave any out
  {
    // Describes the files that will go into this page
    // file paths are relative to ./src/
    input: {
      // Template for the HTML file
      // Useful if you want special <link> or <script> tags
      // '.ejs' file extension is used to prevent other loaders from intercepting this file
      template: 'html/index.ejs',
      // This is the script that imports your Elm, CSS, and any JS libraries
      // DO NOT add the file extension; it is assumed to be '.js'
      entryScript: 'index',
    },

    // Various options for this page
    options: {
      // The <title> of the resulting HTML page
      title: 'Index'
    },

    // Describes the files that will be created
    output: {
      // The HTML file for this page
      html: 'index.html',
      // The build file (compiled version of input.entryScript)
      bundle: 'elm/index'
    }
  }
]

// This is the base config, you probably don't need to modify it
const config = {
  entry: {},
  output: {},

  plugins: [],

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    contentBase: './build',
    inline: true,
    stats: {
      colors: true
    }
  }
}

const generateConfig = (baseConfig, pagesToAdd) => {
  baseConfig.entry = pagesToAdd.reduce(
    (accumulator, page) => (Object.assign(accumulator, {
      [page.output.bundle]: './src/' + page.input.entryScript,
    })),
    {}
  )

  baseConfig.output = {
    path: path.resolve('./build/'),
    filename: '[name].js'
  }

  baseConfig.plugins = pagesToAdd.map(page => (
    new HtmlWebpackPlugin({
      title: page.options.title,
      filename: page.output.html,
      template: 'src/' + page.input.template,
      chunks: [page.output.bundle]
    })
  ))

  return baseConfig
}

module.exports = generateConfig(config, pages);

/* This is a backup config, you can use this if the config generation fails
module.exports = {
  entry: {
    'elm/index': [
      './src/index.js'
    ]
  },
  output: {
    path: path.resolve('./build/'),
    filename: '[name].js'
  },

  plugins: [
    new HtmlWebpackPlugin({
      title: 'Home',
      template: 'src/html/index.ejs'
    })
  ],

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/,
  },

  // Setup webpack-dev-server
  devServer: {
    contentBase: './build',
    inline: true,
    stats: {
      colors: true
    }
  }
}
*/
