import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import "phoenix_html";

import Hooks from "./hooks";

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
const socketOpts = {
  hooks: Hooks,
  params: { _csrf_token: csrfToken },
};
const liveSocket = new LiveSocket("/live", Socket, socketOpts);
liveSocket.connect();
liveSocket.disableDebug();

import "./chat-autoscroll";
