import gql from "graphql-tag";

import { urqlClient } from "./../index";
import collectGraphqlErrors from "./../utils/collectGraphqlErrors";

export const createIjustEventMuation = (variables: {
  ijustContextId: string;
  name: string;
}) => {
  const mutation = gql`
    mutation CreateIjustEvent($ijustContextId: ID!, $name: String!) {
      createIjustEvent(ijustContextId: $ijustContextId, name: $name) {
        id
        name
        count
        insertedAt
        updatedAt
        ijustContextId
      }
    }
  `;

  return new Promise((resolve, reject) => {
    urqlClient
      .mutation(mutation, variables)
      .toPromise()
      .then((response) => resolve(response.data.createIjustEvent))
      .catch((error) => {
        console.error(error);
        reject(collectGraphqlErrors(error));
      });
  });
};
