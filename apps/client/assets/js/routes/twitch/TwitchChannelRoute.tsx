import * as React from "react";
import gql from "graphql-tag";
import { useParams } from "react-router-dom";

import { MainNav } from "./../../components/MainNav";
import { TwitchChannel } from "./../../components/twitch/TwitchChannel";
import { TwitchEmoteWatcher } from "./../../components/twitch/TwitchEmoteWatcher";
import { QueryLoader } from "./../../utils/QueryLoader";

const GET_CHANNEL_QUERY = gql`
  query GetTwitchChannel($channelName: String!) {
    getTwitchChannel(channelName: $channelName) {
      id
      name
    }
  }
`;

export const TwitchChannelRoute = () => {
  const { channel_name: channelName } = useParams();

  return (
    <div>
      <MainNav />
      <div className="mx-3">
        <QueryLoader
          query={GET_CHANNEL_QUERY}
          variables={{ channelName }}
          component={({ data }) => {
            const channel = data.getTwitchChannel;
            return renderChannel(channel);
          }}
        />
      </div>
    </div>
  );
};

const renderChannel = (channel: any) => (
  <div className="flex">
    <TwitchChannel channel={channel} />
    <TwitchEmoteWatcher channel={channel} />
  </div>
);
