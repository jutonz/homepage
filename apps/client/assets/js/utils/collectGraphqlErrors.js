import { GraphQLError } from "graphql";

export default function(error) {
  if (!!!error) {
    return "";
  }

  const graphQLErrors = error.graphQLErrors;
  let errors;
  if (graphQLErrors && graphQLErrors.length > 0) {
    errors = graphQLErrors.map(error => error.message);
  } else if (error.message) {
    errors = [error.message];
  } else {
    errors = ["Unable to perform request"];
  }

  return errors;
}
