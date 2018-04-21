import { Loader } from "semantic-ui-react";
import { Redirect } from "react-router-dom";
import { connect } from "react-redux";
import { css } from "aphrodite";
import React from "react";

import { MainNav } from "@components/MainNav";

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

  if (context.id) {
    const contextRoute = {
      pathname: `ijust/contexts/${context.id}`
    };
    return <Redirect to={contextRoute} />;
  }

  return <Loader active />;
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
