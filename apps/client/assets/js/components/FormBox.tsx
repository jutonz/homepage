import * as React from "react";
import { css, StyleSheet } from "aphrodite";

const style = StyleSheet.create({
  formBox: {
    border: "1px solid #ccc",
    padding: "10px"
  }
});

export const FormBox = ({ children, styles }) => (
  <div className={css(style.formBox, ...styles)}>{children}</div>
);
