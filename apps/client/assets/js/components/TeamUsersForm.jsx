import React from "react";
import { Header, Form, Message, Loader } from "semantic-ui-react";
import { Link } from "react-router-dom";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    minWidth: 300,
    marginTop: 30,
    marginRight: 30
  },
  loaderContainer: {
    display: "flex",
    justifyContent: "center"
  }
});

class _TeamUsersForm extends React.Component {
  componentWillMount() {
    const { fetchUsers, team, isLoadingUsers } = this.props;
    if (!isLoadingUsers) {
      fetchUsers(team.id);
    }
  }

  render() {
    const { team, users } = this.props;
    const { isLoadingUsers, loadUsersErrors } = team;
    return (
      <Form className={css(style.container)} error={!!loadUsersErrors}>
        <Header>Team users</Header>
        <p>View individual members of an team</p>
        <div className={css(style.loaderContainer)}>
          <Loader active={isLoadingUsers} inline />
        </div>
        <Message error>{loadUsersErrors}</Message>
        {users.map(user => (
          <div key={user.id}>
            <Link to={`/teams/${team.id}/users/${user.id}`}>{user.email}</Link>
          </div>
        ))}
        {!!!users && !isLoadingUsers && <p>No users</p>}
      </Form>
    );
  }
}

const getUsers = (state, props) => {
  const ids = props.team.userIds || [];
  return ids.map(id => state.users.getIn(["users", id])).filter(user => !!user);
};

export const TeamUsersForm = connect(
  (state, props) => ({
    users: getUsers(state, props)
  }),
  dispatch => ({
    fetchUsers: id => dispatch({ type: "FETCH_TEAM_USERS", id })
  })
)(_TeamUsersForm);
