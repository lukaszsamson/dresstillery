'use strict';

require('./index.html');
require('bootstrap-loader');
require("./App.scss");

const Elm = require('./Main');
const app = Elm.Main.fullscreen({
  backendUrl: process.env.BACKEND_URL
});
