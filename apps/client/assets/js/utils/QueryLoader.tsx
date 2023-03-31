import Alert from "@mui/material/Alert";
import React from "react";
import { useQuery } from "urql";

interface Props {
  query: any;
  variables?: any;
  component: any;
}

export function QueryLoader<T>(props: Props) {
  const { query, variables, component: Component } = props;
  const [result, _executeQuery] = useQuery<T>({ query, variables });
  const { fetching: loading, data, error } = result;

  if (loading) {
    return <div className="flex justify-center">Loading...</div>;
  }

  if (error) {
    return <Alert color="error">{error.message}</Alert>;
  }

  return <Component {...{ loading, data, error }} />;
}
