import * as React from "react";
import { Button } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import gql from "graphql-tag";
import { Mutation } from "react-apollo";

import { FormBox } from "@components/FormBox";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
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

export const TwitchChannel = ({ channel }) => (
  <FormBox styles={style.container}>
    <p>It's a channel! {channel.name}</p>
    {renderUnsubscribeButton(channel)}
  </FormBox>
);

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
