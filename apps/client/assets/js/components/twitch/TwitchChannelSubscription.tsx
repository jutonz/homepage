import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import TextField from "@mui/material/TextField";
import { StyleSheet, css } from "aphrodite";
import React, { useState } from "react";
import { gql, useMutation } from "urql";

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
        <h3 className="text-lg mb-3">Subscribe to a channel</h3>
        <p>Observe and record chat events in real time!</p>
        <div>
          {result.error?.message && (
            <Alert color="error">{result.error.message}</Alert>
          )}
          <TextField
            label="Channel name"
            error={!!result.error}
            fullWidth
            onChange={(event) => {
              setChannelName(event.target.value);
            }}
          />
          <Button
            fullWidth
            disabled={result.fetching}
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
