import React from "react";
import { connect } from "react-redux";
import { StyleSheet, css } from "aphrodite";
import { Loader } from "semantic-ui-react";
import { MainNav } from "@components/MainNav";

const style = StyleSheet.create({
  routeContainer: {
    margin: "30px"
  }
});

const _AccountUserRoute = ({ user, fetchUser, match }) => {
  if (!user) {
    fetchUser(match.params.user_id);
  }
  const { isFetching, fetchErrors } = (user || {});

  return (
    <div>
      <MainNav activeItem={"settings"} />
      <Loader active={isFetching} />
      <div className={css(style.routeContainer)}>
        {user && renderUser(user)}
        {fetchErrors && fetchErrors.map(error => (
          <div key={error}>{error}</div>
        ))}
      </div>
    </div>
  );
};

const renderUser = user => (
  <div>
    {user.email}
  </div>
);

const getUserFromState = (state, props) => {
  const userId = props.match.params.user_id;
  return state.users.users[parseInt(userId)];
};

const mapStateToProps = (state, props) => ({
  user: getUserFromState(state, props)
});

const mapDispatchToProps = dispatch => ({
  fetchUser: (id) => dispatch({ type: "FETCH_USER", id })
});

export const AccountUserRoute = connect(mapStateToProps, mapDispatchToProps)(_AccountUserRoute);
