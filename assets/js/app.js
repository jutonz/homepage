import "semantic-ui-less/semantic.less";

import "./../css/app.less";

// React stuff
import MainNav from './components/MainNav.jsx';
import Timer from './components/Timer.jsx';
import Hello from './components/Hello.jsx';
import Login from './components/Login.jsx';
import Signup from './components/Signup.jsx';
import TextField from './components/TextField.jsx';
import Button from './components/Button.jsx';

window.Components = {
  MainNav,
  Timer,
  Hello,
  Login,
  TextField,
  Button,
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

