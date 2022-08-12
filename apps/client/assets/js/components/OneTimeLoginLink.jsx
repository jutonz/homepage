import React from "react";
import { css, StyleSheet } from "aphrodite";
import { Form, Header } from "semantic-ui-react";
import Clipboard from "clipboard";
import gql from "graphql-tag";
import { connect } from "react-redux";
import { compose } from "redux";

import { showFlash } from "./../store/store";
import { FormBox } from "./../components/FormBox";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
  },
});

class _OneTimeLoginLink extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  componentDidMount() {
    const clipboard = new Clipboard("#link-cp-trigger", {
      text: (_target) => {
        const ele = document.getElementById("link-cp-target");
        return ele.value;
      },
    });

    clipboard.on("success", () => {
      this.props.showFlash("Copied", "success");
    });
    clipboard.on("error", () => {
      this.props.showFlash("Press Ctrl+C to topy", "info");
    });
    this.setState({ clipboard });
  }

  render() {
    return (
      <div className={css(style.container)}>
        <FormBox>
          <Form>
            <Header>One-time login link</Header>

            <p>
              Generate a one-time login link for passwordless authentication.
              This link is valid for only 24 hours.
            </p>

            {this.renderGeneratedLink()}

            <Form.Button
              type="button"
              primary={true}
              fluid={true}
              onClick={this.generate}
              loading={this.state.loading}
            >
              Generate
            </Form.Button>
          </Form>
        </FormBox>
      </div>
    );
  }

  renderGeneratedLink = () => {
    if (this.state.link) {
      return (
        <Form.Input
          readOnly={true}
          value={this.state.link}
          labelPosition="right"
          id="link-cp-target"
          action={{ icon: "copy", id: "link-cp-trigger", type: "button" }}
        />
      );
    } else {
      return null;
    }
  };

  generate = () => {
    this.setState({ loading: true, link: null });

    const query = gql`
      {
        getOneTimeLoginLink
      }
    `;

    urqlClient
      .query(query)
      .toPromise()
      .then((response) => {
        const link = response.data.getOneTimeLoginLink;
        this.setState({ link: link, loading: false });
      })
      .catch(() => {
        this.setState({ loading: false });
        console.error("oh no");
      });
  };

  componentWillUnmount() {
    if (this.state.clipboard) {
      this.state.clipboard.destroy();
    }
  }
}

//const mapStoreToProps = () => {};
const mapDispatchToProps = (dispatch) => ({
  showFlash: (message, tone = "info") => dispatch(showFlash(message, tone)),
});

export const OneTimeLoginLink = compose(connect(null, mapDispatchToProps))(
  _OneTimeLoginLink
);
