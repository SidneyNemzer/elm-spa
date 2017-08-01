import './styles/index.css'

firebase.initializeApp({
  apiKey: "AIzaSyDXYSZuorBMm6bR4mja_l_CvyqH_H7JzjU",
  authDomain: "elm-spa-4d03b.firebaseapp.com",
  databaseURL: "https://elm-spa-4d03b.firebaseio.com",
  projectId: "elm-spa-4d03b",
  storageBucket: "elm-spa-4d03b.appspot.com",
  messagingSenderId: "965313000177"
})

const Elm = require('./elm/Main.elm')

Elm.Main.embed(document.querySelector('div'))
