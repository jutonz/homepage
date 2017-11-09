import "semantic-ui-less/semantic.less";

import "./../css/app.less";

// React stuff
import Login from './components/Login.jsx';
import Signup from './components/Signup.jsx';

window.Components = {
  Login,
  Signup
};

import "phoenix_html";
import "react-phoenix";

// Utility functions
import BgGrid from './bg_grid.js';
import IsValidEmail from './utils/is_valid_email.js';
import IsValidPassword from './utils/is_valid_password.js';

window.Utils = {
  BgGrid,
  IsValidEmail,
  IsValidPassword
};

// Global configuration (env stuff mostly)
// TODO: fix this with wepback
//import Config from './config';
//window.Config = Config;

