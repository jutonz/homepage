import React, { useState } from "react";
import { Button, Dropdown, Header, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { Redirect, RouteComponentProps } from "react-router-dom";
import { gql, useMutation } from "urql";

import { FormBox } from "./../FormBox";
import { TwitchChannelLiveChat } from "./TwitchChannelLiveChat";
import { TwitchChannelArchiveView } from "./TwitchChannelArchiveView";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    minHeight: 500,
    maxHeight: 500,
    marginRight: 30,
    display: "flex",
    flexDirection: "column",
  },
  header: {
    flexGrow: 0,
    flexShrink: 0,
    flexBasis: "auto",
    display: "flex",
    justifyContent: "space-between",
  },
  body: {
    flexGrow: 1,
    maxHeight: "100%",
    overflow: "hidden",
  },
  unsubButtonContainer: {
    marginTop: 20,
  },
});

const CHANNEL_UNSUBSCRIBE_MUTATION = gql`
  mutation TwitchChannelUnsubscribe($name: String!) {
    twitchChannelUnsubscribe(name: $name) {
      id
    }
  }
`;

enum ChatMode {
  Live,
  Archive,
  RedirectToChannelPage,
}

interface _Props {
  channel: any;
}

type Props = Partial<RouteComponentProps<any>> & _Props;

export function TwitchChannel({ channel }: Props) {
  const [chatMode, setChatMode] = useState(ChatMode.Live);

  if (chatMode == ChatMode.RedirectToChannelPage) {
    const pathname = `/twitch/channels/${channel.name.substr(1)}`;
    return <Redirect to={{ pathname }} />;
  }

  const [result, unsubscribe] = useMutation(CHANNEL_UNSUBSCRIBE_MUTATION);

  return (
    <FormBox styles={style.container}>
      <div className={css(style.header)}>
        <Header>{channel.name}</Header>
        <Dropdown icon="setting">
          <Dropdown.Menu>
            <Dropdown.Item
              active={chatMode === ChatMode.Live}
              onClick={() => setChatMode(ChatMode.Live)}
              text="Live chat"
            />
            <Dropdown.Item
              active={chatMode === ChatMode.Archive}
              onClick={() => setChatMode(ChatMode.Archive)}
              text="Chat archive"
            />
            <Dropdown.Item
              onClick={() => setChatMode(ChatMode.RedirectToChannelPage)}
              text="Expand"
            />
          </Dropdown.Menu>
        </Dropdown>
      </div>
      <div className={css(style.body)}>{renderBody(channel, chatMode)}</div>
      <div className={css(style.unsubButtonContainer)}>
        {result.error && <Message error>result.error</Message>}
        <Button
          primary
          fluid
          loading={result.fetching}
          onClick={() => unsubscribe({ name: channel.name })}
        >
          Unsubscribe
        </Button>
      </div>
    </FormBox>
  );
}

function renderBody(channel: any, chatMode: ChatMode) {
  switch (chatMode) {
    case ChatMode.Live:
      return <TwitchChannelLiveChat channel={channel} />;
    case ChatMode.Archive:
      return <TwitchChannelArchiveView />;
  }
}
