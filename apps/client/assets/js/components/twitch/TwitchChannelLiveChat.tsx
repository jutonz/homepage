import * as React from "react";
import { StyleSheet, css } from "aphrodite";
// @ts-ignore
import { Socket } from "phoenix";

const HISTORY_THRESSHOLD = 100;
const HISTORY_BUFFER = 50;

const style = StyleSheet.create({
  list: {
    overflow: "auto",
    maxHeight: 391,
  },
});

interface Props {
  channel: any;
}
interface State {
  messages: Array<any>;
  socket?: any;
  channel?: any;
}
export class TwitchChannelLiveChat extends React.Component<Props, State> {
  list: any = null;

  constructor(props: Props) {
    super(props);
    const { socket, channel } = this.subscribe();
    this.state = { socket, channel, messages: [] };
  }

  componentDidUpdate() {
    const list = this.list;
    if (list) {
      list.scrollTop = list.scrollHeight - list.clientHeight;
    }
  }

  componentDidMount() {
    const { name } = this.props.channel;
    const list = document.querySelectorAll(`[data-channel-name='${name}']`)[0];
    this.list = list;
  }

  render() {
    const { messages } = this.state;

    return (
      <div
        className={css(style.list)}
        data-channel-name={this.props.channel.name}
      >
        {messages.map((message) => (
          <p key={message.id} data-message-id={message.id}>
            {message.display_name}: {message.message}
          </p>
        ))}
      </div>
    );
  }

  componentWillUnmount() {
    this.unsubscribe();
  }

  subscribe() {
    const socket = new Socket("/twitchsocket", {
      params: { twitch_user_id: this.props.channel.user_id },
    });
    socket.connect();

    const { user_id: userId, name } = this.props.channel;
    const channelName = `twitch_channel:${name}`;
    const channel = socket.channel(channelName, {});

    channel.on("PRIVMSG", (message) => this.messageReceived(message));
    channel.on("ACTION", (message) => this.messageReceived(message));

    channel
      .join()
      .receive("ok", () => console.log(`Joined ${channelName}!`))
      .receive("error", (resp) => console.log("Error joining :(", resp));

    return { socket, channel };
  }

  unsubscribe() {
    const { channel } = this.state;
    if (channel) {
      channel.leave();
    }
  }

  messageReceived(message) {
    message.id = Math.random();
    const { messages } = this.state;
    let newMessages = messages.concat(message);

    if (newMessages.length > HISTORY_THRESSHOLD + HISTORY_BUFFER) {
      newMessages = messages.slice(HISTORY_BUFFER);
    }

    this.setState({ messages: newMessages });
  }
}
