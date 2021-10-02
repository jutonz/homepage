import React from "react";
import gql from "graphql-tag";
import { connect } from "react-redux";
import { App } from "./../components/App";

class _Index extends React.Component {
  constructor(props) {
    super(props);
    this.state = { checkedSession: false };
  }

  componentWillMount() {
    this.checkSession();
  }

  render() {
    if (!this.state.checkedSession) {
      return <div />;
    }

    return <App />;
  }

  checkSession() {
    window.grapqlClient
      .query({
        query: gql`
          {
            check_session
          }
        `,
      })
      .then((response) => {
        const established = response.data.check_session || false;
        this.props.setSessionEstablished(established);
        this.setState({ checkedSession: true });
      });
  }
}

const mapDispatchToProps = (dispatch) => ({
  setSessionEstablished: (established) =>
    dispatch({ type: "SET_SESSION_ESTABLISHED", established }),
});

export const Index = connect(null, mapDispatchToProps)(_Index);
