import React from "react";
import { Header, Form, Message, Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import { Link } from "react-router-dom";

const style = StyleSheet.create({
  container: {
    maxWidth: 300,
    marginTop: 30
  },
  loaderContainer: {
    display: "flex",
    justifyContent: "center"
  }
});

class _AccountUsersForm extends React.Component {
  componentWillMount() {
    const { fetchUsers, account, isLoadingUsers } = this.props;
    if (!isLoadingUsers) {
      fetchUsers(account.id);
    }
  }

  render() {
    const { account, users } = this.props;
    const { isLoadingUsers, loadUsersErrors } = account;
    return (
      <Form className={css(style.container)} error={!!loadUsersErrors}>
        <Header>Account users</Header>
        <p>View individual members of an account</p>
        <div className={css(style.loaderContainer)}>
          <Loader active={isLoadingUsers} inline />
        </div>
        <Message error>{loadUsersErrors}</Message>
        {users.map(user => (
          <div key={user.id}>
            <Link to={`/accounts/${account.id}/users/${user.id}`}>
              {user.email}
            </Link>
          </div>
        ))}
        {!!!users && !isLoadingUsers && <p>No users</p>}
      </Form>
    );
  }
}

const getUsers = (state, props) => {
  const ids = props.account.userIds || [];
  return ids
    .map(id => {
      return (state.users.users || {})[parseInt(id)];
    })
    .filter(user => !!user);
};

const mapStateToProps = (state, props) => ({
  users: getUsers(state, props)
});
const mapDispatchToProps = dispatch => ({
  fetchUsers: id => dispatch({ type: "FETCH_ACCOUNT_USERS", id })
});

export const AccountUsersForm = connect(mapStateToProps, mapDispatchToProps)(
  _AccountUsersForm
);
