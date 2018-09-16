import * as React from "react";
import { Mutation } from "react-apollo";
import gql from "graphql-tag";
import { Header, Button, Input, InputOnChangeData } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";

import { FormBox } from "@components/FormBox";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const CHANNEL_SUBSCRIBE_MUTATION = gql`
  mutation TwitchChannelSubscribe($channel: String!) {
    twitchChannelSubscribe(channel: $channel) {
      id
      name
      userId
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

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
  },
  button: {
    marginTop: "15px"
  }
});

interface Props {
  channelName?: string;
}
export const TwitchChannelSubscription = ({ channelName }: Props) => {
  if (channelName) {
  } else {
    return <SubscribeForm />;
  }
};

interface Props {}
interface State {
  channelName: string;
}
class SubscribeForm extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { channelName: "" };
  }

  render() {
    return (
      <div className={css(style.container)}>
        <FormBox>
          <Header>Subscribe to a channel</Header>
          <p>Observe and record chat events in real time!</p>
          <Mutation
            mutation={CHANNEL_SUBSCRIBE_MUTATION}
            update={(cache, { data }) => {
              const { getTwitchChannels: existingChannels } = cache.readQuery({
                query: GET_TWITCH_CHANNELS
              });

              const newChannel = data.twitchChannelSubscribe;

              cache.writeQuery({
                query: GET_TWITCH_CHANNELS,
                data: { getTwitchChannels: existingChannels.concat([newChannel]) }
              });
            }}
          >
            {(subscribe, { loading, error }) => (
              <div>
                {error && collectGraphqlErrors(error)}
                <Input
                  fluid
                  label="Channel name"
                  value={this.state.channelName}
                  onChange={(_ev, data: InputOnChangeData) => {
                    this.setState({ channelName: data.value });
                  }}
                />
                <Button
                  primary
                  fluid
                  loading={loading}
                  className={css(style.button)}
                  onClick={() => {
                    const { channelName } = this.state;
                    subscribe({
                      variables: { channel: channelName }
                    }).then(() => {
                      this.setState({ channelName: "" });
                    });
                  }}
                >
                  Subscribe
                </Button>
              </div>
            )}
          </Mutation>
        </FormBox>
      </div>
    );
  }
}
