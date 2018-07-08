import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Header, Form, Message } from "semantic-ui-react";
import { compose } from "redux";
import { connect } from "react-redux";
import { fetchTeams, setNewTeamName, createTeam } from "@store";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30
  },

  fetchError: {
    color: "red"
  }
});

class _TeamCreationForm extends React.Component {
  render() {
    const {
      newTeamName,
      newNameIsValid,
      creatingNewTeam,
      createNewTeamError
    } = this.props;
    return (
      <div className={css(style.container)}>
        <Form onSubmit={this.createTeam} error={!!createNewTeamError}>
          <Header>Create a team</Header>
          <Message error>{createNewTeamError}</Message>
          <Form.Input
            label="Name"
            value={newTeamName}
            onChange={this.nameChanged}
          />
          <Form.Button
            primary
            fluid
            type="submit"
            disabled={!newNameIsValid}
            loading={creatingNewTeam}
          >
            Create
          </Form.Button>
        </Form>
      </div>
    );
  }

  nameChanged = (_event, data) => {
    this.props.setNewTeamName(data.value);
  };

  createTeam = () => {
    const { newTeamName, createTeam } = this.props;
    createTeam(newTeamName);
  };
}

const mapStateToProps = state => ({
  newTeamName: state.teams.createTeam.newTeamName,
  newNameIsValid: state.teams.createTeam.newTeamNameIsValid,
  creatingNewTeam: state.teams.createTeam.creating,
  createNewTeamError: state.teams.createTeam.error
});

const mapDispatchToProps = dispatch => ({
  fetchTeams: () => dispatch(fetchTeams()),
  setNewTeamName: newName => dispatch(setNewTeamName(newName)),
  createTeam: name => dispatch(createTeam(name))
});

export const TeamCreationForm = compose(
  connect(
    mapStateToProps,
    mapDispatchToProps
  )
)(_TeamCreationForm);
