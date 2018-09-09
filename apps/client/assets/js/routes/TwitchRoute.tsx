import * as React from "react";
import gql from "graphql-tag";
import { Button } from "semantic-ui-react";

import { MainNav } from "@components/MainNav";
import { QueryLoader } from "@utils/QueryLoader";

const GET_CURRENT_USER_QUERY = gql`
  query GetTwitchUser {
    getTwitchUser {
      id
      display_name
    }
  }
`;

export const TwitchRoute = () => (
  <div>
    <MainNav activeItem={"twitch"} />
    <QueryLoader query={GET_CURRENT_USER_QUERY} component={({ data }) => {
      const user = data.getTwitchUser;
      return renderTwitchUser(user);
    }} />
  </div>
);

const renderTwitchUser = (twitchUser: any) => {
  if (twitchUser) {
    return (
      <div>
        <p>Hey {twitchUser.display_name}</p>
      </div>
    );
  } else {
    return (
      <div>
        <p>Connect your Twitch account to view chat, track metrics, and more!</p>
        <a href="/twitch/login">
          <Button primary>Connect Twitch</Button>
        </a>
      </div>
    );
  }
};
