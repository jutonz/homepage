import * as React from "react";
import { useQuery } from "@apollo/react-hooks";
import { Loader } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";

import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { StyleGlobals } from "@app/style-globals";

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
  const { loading, data, error } = useQuery(query, { variables });

  if (loading) {
    return (
      <div className={css(styles.loaderContainer)}>
        <Loader active inline />
      </div>
    );
  }

  if (error) {
    const errors = collectGraphqlErrors(error);
    return <div className={css(styles.error)}>{errors}</div>;
  }

  return <Component {...{ loading, data, error }} />;
};
