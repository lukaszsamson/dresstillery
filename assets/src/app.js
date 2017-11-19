'use strict';

import "./App.scss";

import storage from './localStorage';
import Elm from './Main';
import o_mnie from '../txt/o_mnie.md';
import home_witamy from '../txt/home_witamy.md';

import aktualna_kolekcja from '../txt/aktualna_kolekcja.md';
import galeria_tkanin from '../txt/galeria_tkanin.md';
import otworz_konfigurator from '../txt/otworz_konfigurator.md';

const LOGIN_TOKEN = 'LOGIN_TOKEN';
const LOGIN_TYPE = 'LOGIN_TYPE';

const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL,
  o_mnie,
  home_witamy,
  aktualna_kolekcja,
  galeria_tkanin,
  otworz_konfigurator,
  initialState: getInitialState()
});

function getInitialState() {
  return {
    token: storage.get(LOGIN_TOKEN),
    loginType: storage.get(LOGIN_TYPE),
  }
}

function getUserData(loginStatus) {
  console.log('getUserData');
  FB.api('/me?fields=name,picture', function(me) {
    const userData = JSON.stringify({
      loginStatus,
      me
    });
    app.ports.facebookLoggedIn.send(userData);
  });
}

window.fbAsyncInit = function() {
  console.log('fbAsyncInit');

  FB.init({
    appId: process.env.FB_APP_ID,
    cookie: false, // Inidcates whether a cookie is created for the session. If enabled, it can be accessed by server-side code. Defaults to false.
    status: false, // Indicates whether the current login status of the user is refreshed on every page load. If this is disabled, that status will have to be manually retrieved using .getLoginStatus(). Defaults to false.
    autoLogAppEvents: false, // Indicates whether app events are logged automatically. Defaults to false.
    xfbml: false,
    version: 'v2.11'
  });

  FB.AppEvents.logPageView()

  FB.getLoginStatus(function(response) {
    console.log('getLoginStatus', response)
    if (response.status === 'connected') {
      console.log('FB.getLoginStatus Logged in.');
      getUserData()
    }

  }, true);
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
  console.log('FB.logout');
  FB.logout(function(response) {
    console.log('FB.logout response: ', response);
  });
});

app.ports.facebookLogin.subscribe(function() {
  console.log('FB.login');
  FB.login(function(response) {
    if (response.authResponse) {
      getUserData(response);
    } else {
      console.log('User cancelled login or did not fully authorize.');
    }
  });
});

app.ports.storeToken.subscribe(function(token) {
  storage.set(LOGIN_TOKEN, token[0]);
  storage.set(LOGIN_TYPE, token[1]);
});

app.ports.deleteToken.subscribe(function() {
  storage.remove(LOGIN_TOKEN);
  storage.remove(LOGIN_TYPE);
});
