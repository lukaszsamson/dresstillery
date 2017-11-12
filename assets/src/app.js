'use strict';

import "./App.scss";

import Elm from './Main';
import o_mnie from '../txt/o_mnie.md';
import home_witamy from '../txt/home_witamy.md';

import aktualna_kolekcja from '../txt/aktualna_kolekcja.md';
import galeria_tkanin from '../txt/galeria_tkanin.md';
import otworz_konfigurator from '../txt/otworz_konfigurator.md';

const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL,
  o_mnie,
  home_witamy,
  aktualna_kolekcja,
  galeria_tkanin,
  otworz_konfigurator,
});

// app.ports.setStorage.subscribe(function(state) {
//   localStorage.setItem('elm-facebook-api', JSON.stringify(state));
// });

function getUserData(loginStatus) {
  FB.api('/me?fields=name,picture', function(me) {
    const userData = JSON.stringify({
      loginStatus,
      me
    });
    app.ports.facebookLoggedIn.send(userData);
  });
}

window.fbAsyncInit = function() {
  FB.Event.subscribe('auth.statusChange', function (response) {
    console.log('auth.statusChange', response)

      if (response.status === 'connected') {
        console.log('FB.getLoginStatus Logged in.');
        getUserData(response)
      } else {
        console.log(response.status);
        app.ports.facebookNotLoggedIn.send(response.status);
      }
  })

  FB.init({
    appId: process.env.FB_APP_ID,
    cookie: false, // Inidcates whether a cookie is created for the session. If enabled, it can be accessed by server-side code. Defaults to false.
    status: true, // Indicates whether the current login status of the user is refreshed on every page load. If this is disabled, that status will have to be manually retrieved using .getLoginStatus(). Defaults to false.
    autoLogAppEvents: true, // Indicates whether app events are logged automatically. Defaults to false.
    xfbml: false,
    version: 'v2.10'
  });

  // FB.AppEvents.logPageView()

  // FB.getLoginStatus(function(response) {
  //   if (response.status === 'connected') {
  //     console.log('FB.getLoginStatus Logged in.');
  //     getUserData()
  //   } else if (response.status === 'not_authorized') {
  //     console.log(response.status);
  //     app.ports.userLoggedOut.send(response.status);
  //   } else if (alreadyAuthed) {
  //     console.log('auto login');
  //     let res = {
  //       authResponse: alreadyAuthed
  //     }
  //     FB.login(function(res) {});
  //   } else {
  //     app.ports.userLoggedOut.send(response.status);
  //   }
  //
  // }, true);
};

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s);
  js.id = id;
  js.async = true;
  js.src = "//connect.facebook.net/pl_PL/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));



app.ports.facebookLogout.subscribe(function() {
  console.log('Logging out');
    FB.logout(function(response) {
      console.log('Loged out ' + response);
      app.ports.facebookNotLoggedIn.send(response.status);
    });
});

app.ports.facebookLogin.subscribe(function() {
  FB.login(function(response) {
    if (response.authResponse) {

      // localStorage.setItem('elm-facebook-api-authResponse', JSON.stringify(response.authResponse));

      getUserData(response)
    } else {
      console.log('User cancelled login or did not fully authorize.');
    }
  });
});
