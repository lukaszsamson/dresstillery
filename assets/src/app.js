'use strict';

import "./App.scss";

import Elm from './Main';
import o_mnie from '../txt/o_mnie.md';
import home_witamy from '../txt/home_witamy.md';

const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL,
  o_mnie,
  home_witamy,
});
