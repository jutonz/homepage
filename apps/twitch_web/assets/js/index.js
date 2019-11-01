import "phoenix_html";

import LiveSocket from "phoenix_live_view";
import "./../css/index.scss";
import "phoenix_html";

let liveSocket = new LiveSocket("/live");
liveSocket.connect();

import "./chat-autoscroll";
