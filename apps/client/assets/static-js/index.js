import LiveSocket from "phoenix_live_view";
import "./../static-css/index.scss";

let liveSocket = new LiveSocket("/live");
liveSocket.connect();

import "./chat-autoscroll";
