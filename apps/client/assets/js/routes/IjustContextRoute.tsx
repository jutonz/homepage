import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import * as React from "react";

import { fetchContext } from "@store/sagas/ijust";

import { IjustContext } from "../components/ijust/IjustContext";
import { MainNav } from "../components/MainNav";
import { fetchAndRenderRecord } from "@utils/fetchAndRenderRecord";

const style = StyleSheet.create({
  routeContainer: { margin: "0 30px" },
  errors: { color: "red" }
});

const _IjustContextRoute = ({ match, context, fetchContext }) => {
  const contextId = match.params.id;

  return (
    <div>
      <MainNav activeItem={"ijust"} />
      {fetchAndRenderRecord({
        record: context,
        fetchRecord: () => fetchContext(contextId),
        renderRecord: renderContext
      })}
    </div>
  );
};

const renderContext = context => (
  <div>
    <div className={css(style.routeContainer)}>
      <IjustContext context={context} />
    </div>
  </div>
);

export const IjustContextRoute = connect(
  (state: any, props: any) => ({
    context: state.ijust.getIn(["contexts", props.match.params.id])
  }),
  dispatch => ({
    fetchContext: id => dispatch(fetchContext(id))
  })
)(_IjustContextRoute);
