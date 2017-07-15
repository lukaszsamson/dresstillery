'use strict';

import './index.html';
import "./App.scss";

import Elm from './Main';

const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL
});
