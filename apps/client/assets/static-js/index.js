import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import "./../static-css/index.scss";
import "phoenix_html";

let liveSocket = new LiveSocket("/live", Socket, {});
liveSocket.connect();

import "./chat-autoscroll";
