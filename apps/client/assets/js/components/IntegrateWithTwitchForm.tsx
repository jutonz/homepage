import * as React from "react";
import { StyleSheet, css } from "aphrodite";
import { gql, useMutation } from "urql";
import Button from "@mui/material/Button";
import Alert from "@mui/material/Alert";

import { FormBox } from "./FormBox";
import { QueryLoader } from "./../utils/QueryLoader";

const GET_CURRENT_USER_QUERY = gql`
  query GetTwitchUser {
    getTwitchUser {
      id
      display_name
    }
  }
`;

const REMOVE_TWITCH_MUTATION = gql`
  mutation TwitchRemoveIntegration {
    twitchRemoveIntegration {
      id
    }
  }
`;

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

export const IntegrateWithTwitchForm = () => (
  <div className={css(style.container)}>
    <FormBox>
      <h3>Twitch integration</h3>
      <QueryLoader
        query={GET_CURRENT_USER_QUERY}
        component={({ data }) => {
          return <TwitchUserComponent user={data.getTwitchUser} />;
        }}
      />
    </FormBox>
  </div>
);

interface TwitchUserComponentProps {
  user: any;
}

function TwitchUserComponent({ user }: TwitchUserComponentProps) {
  const [result, removeIntegration] = useMutation(REMOVE_TWITCH_MUTATION);

  if (user) {
    return (
      <div>
        <p>Connected to account {user.display_name} :)</p>
        <div>
          {result.error && <Alert color="error">{result.error}</Alert>}
          <Button
            fullWidth
            disabled={result.fetching}
            onClick={() => removeIntegration()}
          >
            Disconnect account
          </Button>
        </div>
      </div>
    );
  } else {
    return (
      <div>
        <p>
          Connect your Twitch account to view chat, track metrics, and more!
        </p>
        <a href="/twitch/login">
          <Button fullWidth>Connect Twitch</Button>
        </a>
      </div>
    );
  }
}
