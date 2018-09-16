import * as React from "react";
import { Button, Header } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";
import { Socket } from "phoenix";
import ReactList from "react-list";

import { FormBox } from "@components/FormBox";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
  },
  list: {
    overflow: "auto",
    minHeight: "400px",
    maxHeight: "400px"
  }
});

const CHANNEL_UNSUBSCRIBE_MUTATION = gql`
  mutation TwitchChannelUnsubscribe($name: String!) {
    twitchChannelUnsubscribe(name: $name) {
      id
    }
  }
`;

const GET_TWITCH_CHANNELS = gql`
  query GetTwitchChannels {
    getTwitchChannels {
      id
    }
  }
`;

const HISTORY_THRESSHOLD = 100;
const HISTORY_BUFFER = 50;

interface Props {
  channel: any;
}
interface State {
  messages: Array<any>;
}
export class TwitchChannel extends React.Component<Props, State> {
  lastMessageId = null;

  constructor(props: Props) {
    super(props);
    this.state = { messages: [] };
    this.subscribe();
  }

  componentDidUpdate() {
    if (this.lastMessageId) {
      const el = document.querySelectorAll(
        `[data-message-id='${this.lastMessageId}']`
      )[0];
      if (el) {
        el.scrollIntoView({ behavior: "smooth" });
      }
    }
  }

  render() {
    const { channel } = this.props;
    const { messages } = this.state;
    return (
      <FormBox styles={style.container}>
        <Header>
          {channel.name} ({messages.length})
        </Header>
        {this.renderMessages()}
        {renderUnsubscribeButton(channel)}
      </FormBox>
    );
  }

  renderMessages() {
    const { messages } = this.state;

    return (
      <div className={css(style.list)}>
        {messages.map(message => (
          <p key={message.id} data-message-id={message.id}>
            {message.display_name}: {message.message}
          </p>
        ))}
      </div>
    );
  }

  subscribe() {
    const socket = new Socket("/twitchsocket", {
      params: { twitch_user_id: this.props.channel.user_id }
    });
    socket.connect();

    const { user_id: userId, name } = this.props.channel;
    const channel = socket.channel(`twitch_channel:${name}`, {});

    channel.on("PRIVMSG", message => this.messageReceived(message));

    channel
      .join()
      .receive("ok", resp => console.log("Joined!", resp))
      .receive("error", resp => console.log("Error joining :(", resp));
  }

  messageReceived(message) {
    message.id = Math.random();
    this.lastMessageId = message.id;
    const { messages } = this.state;
    let newMessages = messages.concat(message);

    if (newMessages.length > HISTORY_THRESSHOLD + HISTORY_BUFFER) {
      newMessages = messages.slice(HISTORY_BUFFER);
    }

    this.setState({ messages: newMessages });
  }
}

const renderUnsubscribeButton = channel => (
  <Mutation
    mutation={CHANNEL_UNSUBSCRIBE_MUTATION}
    update={(cache, { data }) => {
      const idToRemove = data.twitchChannelUnsubscribe.id;
      const { getTwitchChannels: existingChannels } = cache.readQuery({
        query: GET_TWITCH_CHANNELS
      });

      const newChannelList = existingChannels.filter(
        ch => ch.id !== channel.id
      );

      cache.writeQuery({
        query: GET_TWITCH_CHANNELS,
        data: { getTwitchChannels: newChannelList }
      });
    }}
  >
    {(unsubscribe, { loading, error }) => (
      <div>
        {error && collectGraphqlErrors(error)}
        <Button
          primary
          fluid
          loading={loading}
          onClick={() => {
            unsubscribe({ variables: { name: channel.name } });
          }}
        >
          Unsubscribe
        </Button>
      </div>
    )}
  </Mutation>
);
