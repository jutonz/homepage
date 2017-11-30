import "semantic-ui-less/semantic.less";
import "phoenix_html";
import "react-phoenix";

import "./../css/app.less";

// React stuff
import * as React from 'react';
import * as ReactDom from 'react-dom';
import App from './components/App';

// Utility functions
import BgGrid from './BgGrid';
import isValidEmail from './utils/isValidEmail';
import isValidPassword from './utils/isValidPassword';

window.Utils = {
  BgGrid,
  isValidEmail,
  isValidPassword
};

declare global {
  interface Window {
    Utils: any;
  }
}

window.addEventListener('load', () => {
  var el = document.getElementById('app-container');
  ReactDom.render(<App />, el);
});
