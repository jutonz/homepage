import { ReactNode } from "react";
import * as React from "react";
import { Loader } from "semantic-ui-react";
import { StyleSheet, css } from "aphrodite";

const style = StyleSheet.create({
  errors: { color: "red" },
});

export const fetchAndRenderRecord = ({
  record,
  fetchRecord,
  renderRecord,
}): ReactNode => {
  if (!record) {
    fetchRecord();
    return <Loader active />;
  }

  if (record.get("isLoading")) {
    return <Loader active />;
  }

  if (record.get("fetchErrors")) {
    return <div className={css(style.errors)}>{record.get("fetchErrors")}</div>;
  }

  return renderRecord(record);
};
