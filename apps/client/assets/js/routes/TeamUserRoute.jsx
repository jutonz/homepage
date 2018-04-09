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

const _TeamUserRoute = ({ user, fetchUser, match }) => {
  if (!user) {
    const { user_id, team_id } = match.params;
    fetchUser(team_id, user_id);
  }
  const { isFetching, fetchErrors } = user || {};

  return (
    <div>
      <MainNav activeItem={"settings"} />
      <Loader active={isFetching} />
      <div className={css(style.routeContainer)}>
        {user && renderUser(user)}
        {fetchErrors &&
          fetchErrors.map(error => <div key={error}>{error}</div>)}
      </div>
    </div>
  );
};

const renderUser = user => <div>{user.email}</div>;

const getUserFromState = (state, props) => {
  const userId = props.match.params.user_id;
  return state.users.getIn(["users", userId]);
};

export const TeamUserRoute = connect(
  (state, props) => ({
    user: getUserFromState(state, props)
  }),
  dispatch => ({
    fetchUser: (teamId, userId) =>
      dispatch({ type: "FETCH_TEAM_USER", teamId, userId })
  })
)(_TeamUserRoute);
