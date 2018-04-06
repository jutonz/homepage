import { GraphQLError } from "graphql";

export default function(error) {
  const graphQLErrors = error.graphQLErrors;
  let errors;
  if (graphQLErrors && graphQLErrors.length > 0) {
    errors = graphQLErrors.map(error => error.message);
  } else if (error.networkError) {
    errors = error.networkError.result.errors.map(e => e.message);
  } else if (error.message) {
    errors = [error.message];
  } else {
    errors = ["Unable to perform request"];
  }
  return errors;
}
