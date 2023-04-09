import { css, StyleSheet } from "aphrodite";
import { format, formatDistanceToNow, parseISO } from "date-fns";
import React from "react";
import { useMutation } from "urql";

import type { IjustOccurrence as OccurrenceType } from "@types";
import { ConfirmButton } from "../ConfirmButton";
import { Constants } from "./../../utils/Constants";
import { graphql } from "../../gql";

const styles = StyleSheet.create({
  relativeDateSpacer: {
    marginLeft: "10px",
  },
});

const DELETE_OCCURRENCE = graphql(`
  mutation IjustDeleteOccurrence($occurrenceId: ID!) {
    ijustDeleteOccurrence(ijustOccurrenceId: $occurrenceId) {
      id
      ijustEventId
    }
  }
`);

interface Props {
  occurrence: OccurrenceType;
}
export const IjustOccurrence = ({ occurrence }: Props) => {
  return (
    <div className="flex flex-row mt-5" data-role="ijust-occurrence">
      <div className="flex flex-row flex-1">
        {format(
          parseISO(occurrence.insertedAt + "Z"),
          Constants.dateTimeFormat
        )}
        <span className={css(styles.relativeDateSpacer)}>
          ({formatDistanceToNow(parseISO(occurrence.insertedAt + "Z"))} ago)
        </span>
      </div>
      <div>{renderDeleteButton(occurrence)}</div>
    </div>
  );
};

const renderDeleteButton = (occurrence: OccurrenceType) => {
  const [{ fetching }, deleteOccurrence] = useMutation(DELETE_OCCURRENCE);
  const variables = { occurrenceId: occurrence.id };

  return (
    <ConfirmButton
      type="submit"
      color="error"
      fullWidth
      disabled={fetching}
      onConfirm={() => deleteOccurrence(variables)}
      confirmButtonText="Delete"
    >
      Delete
    </ConfirmButton>
  );
};
