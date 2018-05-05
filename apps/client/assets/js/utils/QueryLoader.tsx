import * as React from "react";
import { Query } from "react-apollo";
import { Loader } from "semantic-ui-react";

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
          return <div>{error}</div>;
        }

        return <Component data={data} />;
      }}
    </Query>
  </div>
);
