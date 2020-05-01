import React from "react";
import { Button, Header, Form, Message } from "semantic-ui-react";
import { connect } from "react-redux";
import { StyleSheet, css } from "aphrodite";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30,
  },
});

class _TeamDeleteButton extends React.Component {
  constructor(props) {
    super(props);
    this.state = { isDeleting: false, errors: null };
  }

  render() {
    const { team } = this.props;
    const { errors, isDeleting } = this.state;
    return (
      <Form error={!!errors} className={css(style.container)}>
        <Header>Delete team</Header>
        <p>Existing users will be removed from the team</p>
        <Message error>{errors}</Message>
        <Button
          primary
          fluid
          onClick={() => this.deleteTeam(team.id)}
          loading={isDeleting}
        >
          Delete
        </Button>
      </Form>
    );
  }

  deleteTeam = (id) => {
    this.setState({ isDeleting: true, errors: null });
    this.props
      .deleteTeam(id)
      .then(() => {
        this.setState({ isDeleting: false });
        this.props.onDelete();
      })
      .catch((errors) => {
        this.setState({ isDeleting: false, errors });
      });
  };
}

const mapDispatchToProps = (dispatch) => ({
  deleteTeam: (id) => {
    // antipattern but worth it?
    return new Promise((resolve, reject) => {
      dispatch({ type: "DELETE_TEAM", id, resolve, reject });
    });
  },
});

export const TeamDeleteButton = connect(
  undefined,
  mapDispatchToProps
)(_TeamDeleteButton);
