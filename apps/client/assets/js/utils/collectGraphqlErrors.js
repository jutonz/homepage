import { dig } from "./Dig";

export default function (error) {
  if (!!!error) {
    return "";
  }

  const graphQLErrors = error.graphQLErrors;
  let errors;
  if (dig(error, ["networkError", "result", "errors", "length"]) > 0) {
    errors = dig(error, ["networkError", "result", "errors"]).map(
      (e) => e.message,
    );
  } else if (graphQLErrors && graphQLErrors.length > 0) {
    errors = graphQLErrors.map((error) => error.message);
  } else if (error.message) {
    errors = [error.message];
  } else {
    errors = ["Unable to perform request"];
  }

  return errors;
}
