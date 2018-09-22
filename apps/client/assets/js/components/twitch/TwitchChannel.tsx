import * as React from "react";
import { Button, Dropdown, Header, Icon } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";

import { FormBox } from "@components/FormBox";
import { TwitchChannelLiveChat } from "@components/twitch/TwitchChannelLiveChat";
import { TwitchChannelArchiveView } from "@components/twitch/TwitchChannelArchiveView";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    minHeight: 500,
    maxHeight: 500,
    marginRight: 30,
    display: "flex",
    flexDirection: "column"
  },
  header: {
    flexGrow: 0,
    flexShrink: 0,
    flexBasis: "auto",
    display: "flex",
    justifyContent: "space-between"
  },
  body: {
    flexGrow: 1,
    maxHeight: "100%",
    overflow: "hidden"
  },
  unsubButtonContainer: {
    marginTop: 20
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

enum ChatMode {
  Live,
  Archive
}

interface Props {
  channel: any;
}
interface State {
  chatMode: ChatMode;
}
export class TwitchChannel extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { chatMode: ChatMode.Live };
  }

  render() {
    const { channel } = this.props;
    return (
      <FormBox styles={style.container}>
        <div className={css(style.header)}>
          <Header>{channel.name}</Header>
          {this.renderDropdown()}
        </div>
        <div className={css(style.body)}>{this.renderBody()}</div>
        {renderUnsubscribeButton(channel)}
      </FormBox>
    );
  }

  renderDropdown() {
    const { chatMode } = this.state;

    return (
      <Dropdown icon="setting">
        <Dropdown.Menu>
          <Dropdown.Item
            active={chatMode === ChatMode.Live}
            onClick={() => this.switchMode(ChatMode.Live)}
            text="Live chat"
          />
          <Dropdown.Item
            active={chatMode === ChatMode.Archive}
            onClick={() => this.switchMode(ChatMode.Archive)}
            text="Chat archive"
          />
        </Dropdown.Menu>
      </Dropdown>
    );
  }

  renderBody() {
    const { channel } = this.props;
    const { chatMode } = this.state;

    switch (chatMode) {
      case ChatMode.Live:
        return <TwitchChannelLiveChat channel={channel} />;
      case ChatMode.Archive:
        return <TwitchChannelArchiveView />;
    }
  }

  switchMode(chatMode: ChatMode) {
    this.setState({ chatMode });
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
      <div className={css(style.unsubButtonContainer)}>
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
