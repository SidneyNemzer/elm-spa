# webpack-elm-boilerplate

This code helps you code!

Use this to get started coding with Elm, without having to setup the build process

## Installing

### 1. Clone

```bash
git clone https://github.com/SidneyNemzer/webpack-elm-boilerplate my-app
```

Change `my-app` at the end of the command to the name of the folder you'd like to put the code in

### 2. Install

```bash
npm install
```

### 3. Make it yours

* Delete the `.git` folder. If you'd like to make your own git repository, run `git init`
* Update the `package.json` and `elm-package.json` with your information
* Update this README ([Here's a template](https://github.com/jehna/readme-best-practices/blob/master/README-default.md))
* Add a license (if you'd like)

## Webpack Config

*TODO* Explain some Webpack config options

## File Structure

```
/                   <- Top level of the app
  README.md         <- The file you're reading right now
  node_modules/     <- Used by Node for saving any libraries and packages that we need
  elm-stuff/        <- Similar to 'node_modules', but used by Elm
  build/            <- This is where Webpack outputs compiled files
  src/              <- The source files for your app
    elm/            <- Elm files
    html/           <- HTML files
    style/          <- CSS files
    script/         <- JavaScript files
    index.js        <- Entry-point; Webpack starts here
  .gitignore        <- Tells git not to save certain files and folders
  elm-package.json  <- Describes your app and the libraries it needs (used by Elm)
  package.json      <- Describes your app and the libraries it needs (used by Node Package Manager)
  webpack.config.js <- Tells Webpack how to transform the /src into /build

```
