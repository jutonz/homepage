import React from "react";
import { connect } from "react-redux";
import { StyleSheet, css } from "aphrodite";
import { Loader } from "semantic-ui-react";
import { MainNav } from "@components/MainNav";

const style = StyleSheet.create({
  routeContainer: {
    margin: "0 30px"
  },
  errors: {
    color: "red"
  }
});

const _IjustRoute = ({ context, fetchContext, fetchingContext, fetchErrors }) => {
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
        <div className={css(style.errors)}>
          {fetchErrors}
        </div>
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
        {context.name}
      </div>
    </div>
  );
};

export const IjustRoute = connect(
  (state, props) => ({
    fetchingContext: state.ijust.get("fetchingContext"),
    fetchErrors: state.ijust.get("fetchErrors"),
    context: state.ijust.get("context")
  }),
  dispatch => ({
    fetchContext: () => dispatch({ type: "FETCH_IJUST_CONTEXT" })
  })
)(_IjustRoute);
