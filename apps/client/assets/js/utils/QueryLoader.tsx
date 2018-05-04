import * as React from "react";
import { Query } from "react-apollo";
import { Loader } from "semantic-ui-react";

interface Props {
  query: any;
  variables?: any;
  component: any;
}
const _QueryLoader = ({ query, variables, component: Component }: Props) => {
  return (
    <>
      <Query query={query} variables={variables}>
        {({ loading, error, data }) => {
          if (loading) {
            return <Loader active />;
          }

          if (error) {
            return <div>{error}</div>;
          }

          return <Component data={data} />;
        }}
      </Query>
    </>
  );
};

export const QueryLoader = _QueryLoader;
