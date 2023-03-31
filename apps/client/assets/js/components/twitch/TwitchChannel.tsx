import Alert from "@mui/material/Alert";
import Button from "@mui/material/Button";
import Menu from "@mui/material/Menu";
import MenuItem from "@mui/material/MenuItem";
import { StyleSheet, css } from "aphrodite";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { gql, useMutation } from "urql";

import { FormBox } from "./../FormBox";
import { TwitchChannelLiveChat } from "./TwitchChannelLiveChat";

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
    marginBottom: "1rem",
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
  RedirectToChannelPage,
}

interface Props {
  channel: any;
}

export function TwitchChannel({ channel }: Props) {
  const navigate = useNavigate();
  const [chatMode, setChatMode] = useState(ChatMode.Live);
  const [menuAnchor, setMenuAnchor] = useState<undefined | HTMLElement>();
  const [result, unsubscribe] = useMutation(CHANNEL_UNSUBSCRIBE_MUTATION);
  const menuOpen = Boolean(menuAnchor);

  useEffect(() => {
    if (chatMode == ChatMode.RedirectToChannelPage) {
      const pathname = `/twitch/channels/${channel.name.substr(1)}`;
      navigate(pathname);
    }
  }, [chatMode, navigate]);

  return (
    <FormBox styles={style.container}>
      <div className={css(style.header)}>
        <h3>{channel.name}</h3>
        <Button
          color="secondary"
          id="menu"
          onClick={(ev) => setMenuAnchor(ev.currentTarget)}
        >
          Menu
        </Button>
        <Menu
          id="basic-menu"
          anchorEl={menuAnchor}
          open={menuOpen}
          onClose={() => setMenuAnchor(undefined)}
          MenuListProps={{
            "aria-labelledby": "basic-button",
          }}
        >
          <MenuItem onClick={() => setChatMode(ChatMode.Live)}>
            Live chat
          </MenuItem>
          <MenuItem onClick={() => setChatMode(ChatMode.RedirectToChannelPage)}>
            Expand
          </MenuItem>
        </Menu>
      </div>
      <div className={css(style.body)}>
        <TwitchChannelLiveChat channel={channel} />
      </div>
      <div className={css(style.unsubButtonContainer)}>
        {result.error?.message && (
          <Alert color="error">{result.error.message}</Alert>
        )}
        <Button
          fullWidth
          disabled={result.fetching}
          onClick={() => unsubscribe({ name: channel.name })}
        >
          Unsubscribe
        </Button>
      </div>
    </FormBox>
  );
}
