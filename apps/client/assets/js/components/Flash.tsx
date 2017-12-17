import * as React from "react";
import { Message, MessageProps } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";
import { FlashMessage, FlashTone } from "./../Store";

const style = StyleSheet.create({
  message: {
    minWidth: "300px",
    margin: "5px 0",
    width: "auto"
  }
});

interface IProps {
  message: FlashMessage;
}

export const Flash = (props: IProps) => (
  <Message
    content={props.message.message}
    className={css(style.message)}
    {...styleForTone(props.message)}
  />
);

const styleForTone = (message: FlashMessage): Partial<MessageProps> => {
  switch (message.tone) {
    case FlashTone.Warning:
      return { icon: "warning circle", warning: true };
    case FlashTone.Error:
      return { icon: "warning sign", error: true };
    case FlashTone.Success:
      return { icon: "check circle", success: true };
    case FlashTone.Info:
    default:
      return { icon: "info circle", info: true };
  }
};
