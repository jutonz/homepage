import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";
import "./../static-css/index.scss";
import "phoenix_html";

import Hooks from "./hooks";

let liveSocket = new LiveSocket("/live", Socket, { hooks: Hooks });
liveSocket.connect();

import "./chat-autoscroll";
