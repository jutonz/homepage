import { GraphQLError } from "graphql";

interface ErrorObject {
  graphQLErrors: Array<GraphQLError>;
  message: string;
}

export default function(error: ErrorObject) {
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
