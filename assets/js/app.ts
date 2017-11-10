import "semantic-ui-less/semantic.less";

import "./../css/app.less";

// React stuff
import Login from './components/Login';
import Signup from './components/Signup';

declare global {
  interface Window {
    Components: any;
    Utils: any;
  }
}

window.Components = {
  Login,
  Signup
};

import "phoenix_html";
import "react-phoenix";

// Utility functions
import BgGrid from './BgGrid';
import isValidEmail from './utils/isValidEmail';
import isValidPassword from './utils/isValidPassword';

window.Utils = {
  BgGrid,
  isValidEmail,
  isValidPassword
};

// Global configuration (env stuff mostly)
// TODO: fix this with wepback
//import Config from './config';
//window.Config = Config;

