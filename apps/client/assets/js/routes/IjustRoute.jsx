import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import React from "react";

import { MainNav } from "@components/MainNav";
import { IjustContext } from "@components/ijust/IjustContext";

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px"
  },
  errors: {
    color: "red"
  }
});

const _IjustRoute = ({
  context,
  fetchContext,
  fetchingContext,
  fetchErrors
}) => {
  if (fetchingContext) {
    return (
      <div>
        <MainNav activeItem={"ijust"} />
        <Loader active />
      </div>
    );
  }

  if (fetchErrors) {
    return (
      <div>
        <MainNav activeItem={"ijust"} />
        <div className={css(style.errors)}>{fetchErrors}</div>
      </div>
    );
  }

  if (!context && !fetchingContext && !fetchErrors) {
    fetchContext();
    return <div />;
  }

  return (
    <div>
      <MainNav activeItem={"ijust"} />
      <div className={css(style.routeContainer)}>
        <IjustContext context={context} />
      </div>
    </div>
  );
};

const extractDefaultContext = state => {
  const id = state.ijust.get("defaultContextId");
  return state.ijust.getIn(["contexts", id]);
};

export const IjustRoute = connect(
  (state, props) => ({
    fetchingContext: state.ijust.get("isFetchingDefaultContext"),
    fetchErrors: state.ijust.get("fetchDefaultContextErrors"),
    context: extractDefaultContext(state)
  }),
  dispatch => ({
    fetchContext: () => dispatch({ type: "IJUST_FETCH_DEFAULT_CONTEXT" })
  })
)(_IjustRoute);
