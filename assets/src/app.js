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
