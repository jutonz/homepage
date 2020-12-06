import * as React from "react";
import { Button, Confirm as _Confirm, ConfirmProps } from "semantic-ui-react";

interface Props extends ConfirmProps {
  loading: boolean;
}
export const Confirm = (props: Props) => {
  return (
    <_Confirm
      open={props.open}
      onCancel={props.onCancel}
      onConfirm={props.onConfirm}
      confirmButton={<Button loading={props.loading}>Confirm</Button>}
      cancelButton={<Button disabled={props.loading}>Cancel</Button>}
    />
  );
};
