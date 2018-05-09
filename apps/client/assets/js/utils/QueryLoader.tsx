import * as React from "react";
import { Query } from "react-apollo";
import { Loader } from "semantic-ui-react";
import { css, StyleSheet } from "aphrodite";

import collectGraphqlErrors from "@utils/collectGraphqlErrors";
import { StyleGlobals } from "@app/style-globals";

const styles = StyleSheet.create({
  error: {
    color: StyleGlobals.errorColor
  }
});

interface Props {
  query: any;
  variables?: any;
  component: any;
}
export const QueryLoader = ({
  query,
  variables,
  component: Component
}: Props) => (
  <div>
    <Query query={query} variables={variables}>
      {({ loading, error, data }) => {
        if (loading) {
          return <Loader active />;
        }

        if (error) {
          const errors = collectGraphqlErrors(error);
          return <div className={css(styles.error)}>{errors}</div>;
        }

        return <Component data={data} />;
      }}
    </Query>
  </div>
);
