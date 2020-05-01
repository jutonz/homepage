import * as React from "react";
import { css, StyleSheet } from "aphrodite";

const style = StyleSheet.create({
  formBox: {
    border: "1px solid #ccc",
    padding: "10px",
  },
});

interface Props {
  children: any;
  styles?: any;
}
export const FormBox = ({ children, styles }: Props) => (
  <div className={css(style.formBox, styles)}>{children}</div>
);
