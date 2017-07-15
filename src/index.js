'use strict';

import './index.html';
import "./App.scss";

import Elm from './Main';
import o_mnie from '../txt/o_mnie.md';

const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL,
  o_mnie
});
