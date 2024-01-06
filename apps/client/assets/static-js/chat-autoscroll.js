const selectors = {
  scrollPane: "chat__scroll-pane",
  scrollPaneMessages: "chat__scroll-pane__messages",
};

const autoscrollChatPane = (chatScrollPane) => {
  const messages = chatScrollPane.getElementsByClassName(
    selectors.scrollPaneMessages,
  )[0];
  new MutationObserver((mutationsList, _observer) => {
    for (let mutation of mutationsList) {
      if (mutation.type === "childList") {
        chatScrollPane.scrollTop = chatScrollPane.scrollHeight;
      }
    }
  }).observe(messages, { childList: true });
};

(function () {
  const chatScrollPanes = document.getElementsByClassName(selectors.scrollPane);
  if (chatScrollPanes.length > 0) {
    for (let i = 0; i < chatScrollPanes.length; i++) {
      autoscrollChatPane(chatScrollPanes[i]);
    }
  }
})();
