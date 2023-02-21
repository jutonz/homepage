import { createTheme } from "@mui/material/styles";

export default createTheme({
  palette: {
    mode: "dark",
    primary: {
      main: "#ac17c6",
    },
  },
  components: {
    MuiButton: {
      defaultProps: {
        variant: "contained",
        disableRipple: true,
      },
      styleOverrides: {
        root: {
          borderRadius: "0px",
          textTransform: "initial",
        },
      },
    },
    MuiOutlinedInput: {
      styleOverrides: {
        root: {
          borderRadius: "0px",
        },
      },
    },
  },
});
