import type { ButtonProps } from "@mui/material/Button";
import Button from "@mui/material/Button";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import React, { useState } from "react";

interface Props extends ButtonProps {
  children: React.ReactNode;
  onConfirm: () => void;
  confirmTitle?: React.ReactNode;
  confirmText: React.ReactNode;
  confirmButtonText: React.ReactNode;
}

export function ConfirmButton(props: Props) {
  const {
    children,
    onConfirm,
    confirmTitle,
    confirmText,
    confirmButtonText,
    ...buttonProps
  } = props;

  const [showDialog, setShowDialog] = useState<boolean>(false);
  const handleClose = () => setShowDialog(false);

  const onClick = (ev: React.MouseEvent<HTMLButtonElement>) => {
    ev.preventDefault();
    setShowDialog(true);
  };

  return (
    <>
      <Button {...buttonProps} onClick={onClick}>
        {children}
      </Button>

      <Dialog
        open={showDialog}
        onClose={handleClose}
        aria-labelledby="confirm-dialog-title"
        aria-describedby="confirm-dialog-desc"
      >
        <DialogTitle id="confirm-dialog-title">
          {confirmTitle || "Are you sure?"}
        </DialogTitle>
        <DialogContent>
          <DialogContentText id="confirm-dialog-desc">
            {confirmText}
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button color="secondary" onClick={handleClose}>
            Cancel
          </Button>
          <Button color="error" onClick={onConfirm} autoFocus>
            {confirmButtonText}
          </Button>
        </DialogActions>
      </Dialog>
    </>
  );
}
