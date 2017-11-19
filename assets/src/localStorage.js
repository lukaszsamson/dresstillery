'use strict';

function handleError(e) {
  console.warn('Local storage not working, ', e);
}

function get(key) {
  try {
    return window.localStorage.getItem(key);
  } catch (e) {
    handleError(e);
  }
}

function set(key, value) {
  try {
    return window.localStorage.setItem(key, value);
  } catch (e) {
    handleError(e);
  }
}

function remove(key) {
  try {
    return window.localStorage.removeItem(key);
  } catch (e) {
    handleError(e);
  }
}

const mod = {
  get: get,
  set: set,
  remove: remove,
};

export default mod;
