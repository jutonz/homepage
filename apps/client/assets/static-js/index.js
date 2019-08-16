import LiveSocket from "phoenix_live_view";
import "./../static-css/index.scss";

let liveSocket = new LiveSocket("/live");
liveSocket.connect();

const chatScrollPane = document.getElementsByClassName("chat")[0];

if (chatScrollPane) {
  const chatList = document.getElementsByClassName("chat__messages")[0];
  new MutationObserver((mutationsList, observer) => {
    for (let mutation of mutationsList) {
      if (mutation.type === 'childList') {
        chatScrollPane.scrollTop = chatScrollPane.scrollHeight;
      }
    }
  }).observe(chatList, { childList: true })
}
