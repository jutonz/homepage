// Brunch automatically concatenates all files in your watched paths. Those
// paths can be configured at config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if explicitly imported. The only
// exception are files in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember to also remove its path
// from "config.paths.watched".
import 'phoenix_html';
import 'react-phoenix';

// Import local files
//
// Local files can be imported directly using relative paths "./socket" or full
// ones "web/static/js/socket".
// import socket from './socket';

// React stuff
import MainNav from './components/MainNav';
import Timer from './components/Timer';
import Hello from './components/Hello';
import Login from './components/Login';
import Signup from './components/Signup';
import TextField from './components/TextField';
import Button from './components/Button';

window.Components = {
  MainNav,
  Timer,
  Hello,
  Login,
  TextField,
  Button,
  Signup
};

// Utility functions
import BgGrid from './bg_grid';
import IsValidEmail from './utils/is_valid_email';
import IsValidPassword from './utils/is_valid_password';

window.Utils = {
  BgGrid,
  IsValidEmail,
  IsValidPassword
};

// Global configuration (env stuff mostly)
import Config from './config';
window.Config = Config;

// Redirect http to https
if (Config.env !== 'development' && window.location.protocol === 'http:') {
  window.location.protocol = 'https:';
}
