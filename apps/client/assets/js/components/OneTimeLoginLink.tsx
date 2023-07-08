import Button from "@mui/material/Button";
import FormControl from "@mui/material/FormControl";
import InputAdornment from "@mui/material/InputAdornment";
import InputLabel from "@mui/material/InputLabel";
import OutlinedInput from "@mui/material/OutlinedInput";
import { enqueueSnackbar } from "notistack";
import React, { useCallback } from "react";
import { useQuery } from "urql";

import { graphql } from "../gql";

const GET_LINK = graphql(`
  query GetOneTimeLoginLink {
    getOneTimeLoginLink
  }
`);

export function OneTimeLoginLink() {
  const [{ fetching, data }, getLink] = useQuery({
    query: GET_LINK,
    pause: true,
  });
  const link = data?.getOneTimeLoginLink;

  const copy = useCallback(() => {
    try {
      navigator.clipboard.writeText(link).then(
        () => enqueueSnackbar("Copied", { variant: "success" }),
        () => enqueueSnackbar("Press Ctrl+C to copy", { variant: "info" }),
      );
    } catch (_e) {
      enqueueSnackbar("Press Ctrl+C to copy", { variant: "info" });
    }
  }, [link]);

  return (
    <div className="w-80 mt-5 p-2.5 border-gray-300 border">
      <h3 className="text-lg mb-3">One-time login link</h3>
      <p>
        Generate a one-time login link for passwordless authentication. This
        link is valid for only 24 hours.
      </p>

      <Button
        fullWidth
        className="mt-3"
        disabled={fetching}
        onClick={() => getLink()}
      >
        Generate
      </Button>

      {link && (
        <FormControl variant="outlined" className="mt-3">
          <InputLabel htmlFor="login-link">Link</InputLabel>
          <OutlinedInput
            value={link}
            id="login-link"
            fullWidth
            disabled
            endAdornment={
              <InputAdornment position="end">
                <Button onClick={copy}>Copy</Button>
              </InputAdornment>
            }
          />
        </FormControl>
      )}
    </div>
  );
}
