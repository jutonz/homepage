import * as React from "react";
import gql from "graphql-tag";
import { Button, Grid } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";

import { MainNav } from "@components/MainNav";
import { TwitchChannel } from "@components/twitch/TwitchChannel";
import { TwitchChannelSubscription } from "@components/twitch/TwitchChannelSubscription";
import { QueryLoader } from "@utils/QueryLoader";

const GET_CURRENT_USER_QUERY = gql`
  query GetTwitchUser {
    getTwitchUser {
      id
      display_name
    }
  }
`;

const GET_CHANNELS_QUERY = gql`
  query GetTwitchChannels {
    getTwitchChannels {
      id
      name
      userId
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

export const TwitchRoute = () => (
  <div>
    <MainNav activeItem={"twitch"} />
    <QueryLoader
      query={GET_CURRENT_USER_QUERY}
      component={({ data }) => {
        const user = data.getTwitchUser;
        return renderTwitchUser(user);
      }}
    />
  </div>
);

const renderTwitchUser = (twitchUser: any) => {
  if (twitchUser) {
    return (
      <div className={css(style.routeContainer)}>
        <p>Hey {twitchUser.display_name}</p>
        <TwitchChannelSubscription />
        {renderTwitchChannels()}
      </div>
    );
  } else {
    return (
      <div className={css(style.routeContainer)}>
        <p>
          Connect your Twitch account to view chat, track metrics, and more!
        </p>
        <a href="/twitch/login">
          <Button primary>Connect Twitch</Button>
        </a>
      </div>
    );
  }
};

const renderTwitchChannels = () => (
  <div>
    <QueryLoader
      query={GET_CHANNELS_QUERY}
      component={({ data }) => {
        const channels = data.getTwitchChannels;
        return (
          <Grid
            columns={2}
            relaxed
            stackable
            className={css(style.channelGrid)}
          >
            {channels &&
              channels.map((channel) => (
                <TwitchChannel key={channel.id} channel={channel} />
              ))}
          </Grid>
        );
      }}
    />
  </div>
);
