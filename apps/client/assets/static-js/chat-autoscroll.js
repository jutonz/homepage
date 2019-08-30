const autoscrollChatPane = chatScrollPane => {
  const messages = chatScrollPane.getElementsByClassName("chat__messages")[0];
  new MutationObserver((mutationsList, observer) => {
    for (let mutation of mutationsList) {
      if (mutation.type === "childList") {
        chatScrollPane.scrollTop = chatScrollPane.scrollHeight;
      }
    }
  }).observe(messages, { childList: true });
};

(function() {
  const chatScrollPanes = document.getElementsByClassName("chat");
  if (chatScrollPanes.length > 0) {
    for (let i = 0; i < chatScrollPanes.length; i++) {
      autoscrollChatPane(chatScrollPanes[i]);
    }
  }
})();
