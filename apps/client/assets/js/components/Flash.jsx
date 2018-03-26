import React from "react";
import { Message } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";

const style = StyleSheet.create({
  message: {
    minWidth: "300px",
    margin: "5px 0",
    width: "auto"
  }
});

export const Flash = props => (
  <Message
    content={props.message.message}
    className={css(style.message)}
    {...styleForTone(props.message)}
  />
);

const styleForTone = message => {
  switch (message.tone) {
    case "warning":
      return { icon: "warning circle", warning: true };
    case "error":
      return { icon: "warning sign", error: true };
    case "success":
      return { icon: "check circle", success: true };
    case "info":
    default:
      return { icon: "info circle", info: true };
  }
};
