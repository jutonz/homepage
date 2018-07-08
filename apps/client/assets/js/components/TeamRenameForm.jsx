import React from "react";
import { Button, Header, Form, Message } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
  }
});

const _TeamRenameForm = ({ team, setNewName, renameTeam }) => (
  <Form error={!!team.renameErrors} className={css(style.container)}>
    <Header>Rename team</Header>
    <Message error>{team.renameErrors}</Message>
    <Form.Input
      label="Name"
      value={team.renameName || ""}
      onChange={(_ev, data) => setNewName(team.id, data.value)}
    />
    <Button
      primary
      fluid
      onClick={() => renameTeam(team.id, team.renameName)}
      loading={team.isRenaming}
      disabled={!newNameIsValid(team.renameName)}
    >
      Rename
    </Button>
  </Form>
);

const newNameIsValid = name => !!name;

const getRenameErrors = (state, props) => {
  const team = state.teams.teams[parseInt(props.team.id)];
  return team.renameErrors;
};

const mapDispatchToProps = dispatch => ({
  setNewName: (id, name) =>
    dispatch({ type: "SET_TEAM_RENAME_NAME", id, name }),
  renameTeam: (id, name) => dispatch({ type: "RENAME_TEAM", id, name })
});

export const TeamRenameForm = connect(
  null,
  mapDispatchToProps
)(_TeamRenameForm);
