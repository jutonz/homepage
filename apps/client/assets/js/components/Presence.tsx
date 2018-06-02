import * as React from "react";
import { Socket } from "phoenix";
//import gql from "graphql-tag";

//import { QueryLoader } from "@utils/QueryLoader";

//const GET_CURRENT_USER = gql`
//query GetCurrentUserQuery {
//getCurrentUser {
//id
//name
//email
//}
//}
//`;

export class Presence extends React.Component {
  componentDidMount() {
    this.doPresence();
  }

  render() {
    return <div>hi</div>;
  }

  doPresence() {
    const userId = "1";
    let socket = new Socket({
      params: { user_id: userId }
    });

    socket.connect();
  }
}

//export class Presence extends React.Component {
//public render() {
//return (
//<div>
//Presence
//<QueryLoader
//query={GET_CURRENT_USER}
//component={({ data }) => {
//const user = data.getCurrentUser;
//console.log(user);
//return user.email;
//}}
///>
//</div>
//);
//}
//}
