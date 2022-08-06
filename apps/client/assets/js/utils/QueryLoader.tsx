import * as React from "react";
import { useQuery } from "urql";
import { Loader } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";

import collectGraphqlErrors from "./../utils/collectGraphqlErrors";
import { StyleGlobals } from "./../style-globals";

const styles = StyleSheet.create({
  error: {
    color: StyleGlobals.errorColor,
  },
  loaderContainer: {
    display: "flex",
    justifyContent: "center",
  },
});

interface Props {
  query: any;
  variables?: any;
  component: any;
}

export const QueryLoader = ({
  query,
  variables,
  component: Component,
}: Props) => {
  const [result, _executeQuery] = useQuery({ query, variables });
  const { fetching: loading, data, error } = result;

  if (loading) {
    return (
      <div className={css(styles.loaderContainer)}>
        <Loader active inline />
      </div>
    );
  }

  if (error) {
    return <div className={css(styles.error)}>{error.message}</div>;
  }

  return <Component {...{ loading, data, error }} />;
};
