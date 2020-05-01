import * as React from "react";
import { Grid, Header } from "semantic-ui-react";
import gql from "graphql-tag";
import { StyleSheet, css } from "aphrodite";

import { MainNav } from "@components/MainNav";
import { TwitchChannel } from "@components/twitch/TwitchChannel";
import { TwitchEmoteWatcher } from "@components/twitch/TwitchEmoteWatcher";
import { QueryLoader } from "@utils/QueryLoader";

const GET_CHANNEL_QUERY = gql`
  query GetTwitchChannel($channelName: String!) {
    getTwitchChannel(channelName: $channelName) {
      name
    }
  }
`;

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px",
  },
  channelGrid: {
    marginLeft: 0,
    marginRight: 0,
  },
});

export const TwitchChannelRoute = ({ match }) => (
  <div>
    <MainNav activeItem={"twitch"} />
    <div className={css(style.routeContainer)}>
      <QueryLoader
        query={GET_CHANNEL_QUERY}
        variables={{ channelName: match.params.channel_name }}
        component={({ data }) => {
          const channel = data.getTwitchChannel;
          return renderChannel(channel);
        }}
      />
    </div>
  </div>
);

const renderChannel = (channel) => (
  <div>
    <Grid columns={2} relaxed stackable className={css(style.channelGrid)}>
      <TwitchChannel channel={channel} />
      <TwitchEmoteWatcher channel={channel} />
    </Grid>
  </div>
);
