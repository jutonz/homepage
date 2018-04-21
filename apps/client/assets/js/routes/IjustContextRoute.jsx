import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import React from "react";

import { IjustContext } from "../components/ijust/IjustContext";
import { MainNav } from "../components/MainNav";

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px"
  },
  errors: {
    color: "red"
  }
});

const _IjustContextRoute = ({ match, context, fetchContext }) => {
  const contextId = match.params.id;

  if (!context) {
    fetchContext(contextId);
    return <div />;
  }

  if (context.get("isLoading")) {
    return (
      <div>
        <MainNav activeItem={"ijust"} />
        <Loader active />
      </div>
    );
  }

  if (context.get("fetchErrors")) {
    return (
      <div>
        <MainNav activeItem={"ijust"} />
        <div className={css(style.errors)}>{context.get("fetchErrors")}</div>
      </div>
    );
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

export const IjustContextRoute = connect(
  (state, props) => ({
    context: state.ijust.getIn(["contexts", props.match.params.id])
  }),
  dispatch => ({
    fetchContext: id => dispatch({ type: "IJUST_FETCH_CONTEXT", id })
  })
)(_IjustContextRoute);
