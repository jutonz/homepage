import React, { useState } from "react";
import { gql, useMutation } from "urql";
import {
  Message,
  Header,
  Button,
  Input,
  InputOnChangeData,
} from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";

import { FormBox } from "./../FormBox";

const CHANNEL_SUBSCRIBE_MUTATION = gql`
  mutation TwitchChannelSubscribe($channel: String!) {
    twitchChannelSubscribe(channel: $channel) {
      id
      name
      userId
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
  button: {
    marginTop: "15px",
  },
});

interface Props {
  channelName?: string;
}
export const TwitchChannelSubscription = ({ channelName }: Props) => {
  if (channelName) {
    return null;
  } else {
    return <SubscribeForm />;
  }
};

function SubscribeForm() {
  const [channelName, setChannelName] = useState<string>("");
  const [result, subscribeToChannel] = useMutation(CHANNEL_SUBSCRIBE_MUTATION);

  return (
    <div className={css(style.container)}>
      <FormBox>
        <Header>Subscribe to a channel</Header>
        <p>Observe and record chat events in real time!</p>
        <div>
          {result.error && <Message error>{result.error}</Message>}
          <Input
            fluid
            label="Channel name"
            value={channelName}
            onChange={(_ev, data: InputOnChangeData) => {
              setChannelName(data.value);
            }}
          />
          <Button
            primary
            fluid
            loading={result.fetching}
            className={css(style.button)}
            onClick={() => {
              subscribeToChannel({
                channel: channelName,
              }).then(() => {
                setChannelName("");
              });
            }}
          >
            Subscribe
          </Button>
        </div>
      </FormBox>
    </div>
  );
}
