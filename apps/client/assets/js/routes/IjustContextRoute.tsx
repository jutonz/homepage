import { StyleSheet, css } from "aphrodite";
import { connect } from "react-redux";
import * as React from "react";
import gql from "graphql-tag";

import { fetchContext } from "@store/sagas/ijust";

import { IjustContext } from "../components/ijust/IjustContext";
import { MainNav } from "../components/MainNav";
import { Context } from "@store/reducers/ijust";
import { QueryLoader } from "@utils/QueryLoader";

const style = StyleSheet.create({
  routeContainer: { margin: "0 30px" },
  errors: { color: "red" }
});

const QUERY = gql`
  query GetIjustContextQuery($id: ID!) {
    getIjustContext(id: $id) {
      id
      name
      userId
    }
  }
`;

const _IjustContextRoute = ({ match }) => (
  <div>
    <MainNav activeItem={"ijust"} />
    <QueryLoader
      query={QUERY}
      variables={{ id: match.params.id }}
      component={({ data }) => {
        const context = new Context(data.getIjustContext);
        return renderContext(context);
      }}
    />
  </div>
);

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
