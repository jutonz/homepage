import React from "react";
import { Controller } from "react-hook-form";
import TextField from "@mui/material/TextField";
import Alert from "@mui/material/Alert";

import type { Path } from "react-hook-form";
import type { TextFieldProps } from "@mui/material/TextField";

type Props<FormInputs> = TextFieldProps & {
  // control: Control<FormInputs>;
  control: any;
  errors: any;
  name: Path<FormInputs>;
  label: string;
};

export const ControlledTextField = <TFormInputs extends unknown>(
  props: Props<TFormInputs>,
) => {
  const { control, errors, name, label, ...textFieldProps } = props;

  return (
    <>
      <Controller
        control={control as any}
        name={name}
        render={({ field }) => (
          <TextField
            {...field}
            label={label}
            error={!!errors[name]?.message}
            {...textFieldProps}
          />
        )}
      />
      {errors[name]?.message && (
        <Alert color="error">{errors[name].message}</Alert>
      )}
    </>
  );
};
