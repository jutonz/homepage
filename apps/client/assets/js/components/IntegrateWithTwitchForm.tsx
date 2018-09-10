import * as React from "react";
import gql from "graphql-tag";
import { Header, Button } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { Mutation } from "react-apollo";

import { FormBox } from "@components/FormBox";
import { QueryLoader } from "@utils/QueryLoader";
import collectGraphqlErrors from "@utils/collectGraphqlErrors";

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
    marginRight: 30
  }
});

export const IntegrateWithTwitchForm = () => (
  <div className={css(style.container)}>
    <FormBox>
      <Header>Twitch integration</Header>
      <QueryLoader
        query={GET_CURRENT_USER_QUERY}
        component={({ data }) => {
          const user = data.getTwitchUser;
          return renderTwitchUser(user);
        }}
      />
    </FormBox>
  </div>
);

const renderTwitchUser = (twitchUser: any) => {
  if (twitchUser) {
    return (
      <div>
        <p>Connected to account {twitchUser.display_name} :)</p>
        <Mutation
          mutation={REMOVE_TWITCH_MUTATION}
          update={(cache, { data }) => {
            cache.writeQuery({
              query: GET_CURRENT_USER_QUERY,
              data: { getTwitchUser: null }
            });
          }}
        >
          {(removeIntegration, { loading, error }) => (
            <div>
              {error && collectGraphqlErrors(error)}
              <Button
                primary
                fluid
                loading={loading}
                onClick={() => removeIntegration()}
              >
                Disconnect account
              </Button>
            </div>
          )}
        </Mutation>
      </div>
    );
  } else {
    return (
      <div>
        <p>
          Connect your Twitch account to view chat, track metrics, and more!
        </p>
        <a href="/twitch/login">
          <Button primary fluid>
            Connect Twitch
          </Button>
        </a>
      </div>
    );
  }
};
