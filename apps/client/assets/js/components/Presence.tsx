import * as React from "react";
import { Socket } from "phoenix";
import gql from "graphql-tag";

import { QueryLoader } from "@utils/QueryLoader";

const GET_CURRENT_USER = gql`
  query GetCurrentUserQuery {
    getCurrentUser {
      id
      email
    }
  }
`;

export class Presence extends React.Component {
  render() {
    return (
      <QueryLoader
        query={GET_CURRENT_USER}
        component={({ data }) => {
          const user = data.getCurrentUser;
          return <PresenceHelper userId={user.id} email={user.email} />;
        }}
      />
    );
  }
}

interface HelperProps {
  userId: string;
  email: string;
}
interface HelperState {
  online: boolean;
}
class PresenceHelper extends React.Component<HelperProps, HelperState> {
  constructor(props: HelperProps) {
    super(props);
    this.state = { online: false };
  }

  componentDidMount() {
    this.doPresence();
  }

  render() {
    const { email } = this.props;
    const { online } = this.state;
    if (online) {
      return <div>{email} (online)</div>;
    } else {
      return <div>{email} (offline)</div>;
    }
  }

  doPresence() {
    const { userId } = this.props;
    let socket = new Socket("/socket", {
      params: { user_id: userId }
    });

    socket.connect();

    let channel = socket.channel(`user:${userId}`, {});

    channel.on("message", state => {
      console.log(state);
      this.setState({ online: true });
    });

    channel.join();
  }
}
