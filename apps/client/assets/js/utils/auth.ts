import { authExchange } from "@urql/exchange-auth";
import { jwtDecode, JwtPayload } from "jwt-decode";
import { graphql } from "../gql/gql";

const REFRESH_TOKEN_MUTATION = graphql(`
  mutation RefreshToken($refreshToken: String!) {
    refreshToken(refreshToken: $refreshToken) {
      result {
        accessToken
        refreshToken
        __typename
      }
    }
  }
`);

const FIELDS_WITHOUT_AUTH = ["login", "signup", "refreshToken"];

export const homepageAuthExchange = authExchange(async (utils) => {
  return {
    addAuthToOperation(operation) {
      const token = getAccessToken();
      if (!token) return operation;
      return utils.appendHeaders(operation, {
        Authorization: `Bearer ${token}`,
      });
    },

    didAuthError(_error, _operation) {
      // Maybe fill this out eventually if there's ever a standard way for
      // requests to indicate that an authorization error occurred. Right now
      // we just lookup the user and each request handles a user being blank
      // differently, so it's not really possible to add a global handler like
      // this.
      return false;
    },

    willAuthError(operation) {
      // See: https://formidable.com/open-source/urql/docs/advanced/authentication/#configuring-willautherror
      if (
        operation.kind === "mutation" &&
        // Here we find any mutation definition with the "login" field
        operation.query.definitions.some((definition) => {
          return (
            definition.kind === "OperationDefinition" &&
            definition.selectionSet.selections.some((node) => {
              // The field name is just an example, since signup may also be an exception
              return (
                node.kind === "Field" &&
                FIELDS_WITHOUT_AUTH.includes(node.name.value)
              );
            })
          );
        })
      ) {
        return false;
      }
      const token = getAccessToken();
      return token && isExpired(token);
    },

    async refreshAuth() {
      const refreshToken = getRefreshToken();
      const response = await utils.mutate(REFRESH_TOKEN_MUTATION, {
        refreshToken,
      });

      const result = response?.data?.refreshToken?.result;
      const newAccess = result?.accessToken;
      const newRefresh = result?.refreshToken;

      if (newAccess && newRefresh) {
        setTokens(newAccess, newRefresh);
      } else {
        clearTokens();
        window.location.reload();
      }
    },
  };
});
const ACCESS_TOKEN = "token";
const REFRESH_TOKEN = "refresh";

// TODO: Use cookies for this?

function getAccessToken() {
  return localStorage.getItem(ACCESS_TOKEN);
}

function getRefreshToken() {
  return localStorage.getItem(REFRESH_TOKEN);
}

export const setTokens = (accessToken: string, refreshToken: string) => {
  localStorage.setItem(ACCESS_TOKEN, accessToken);
  localStorage.setItem(REFRESH_TOKEN, refreshToken);
};

export function clearTokens() {
  localStorage.removeItem(ACCESS_TOKEN);
  localStorage.removeItem(REFRESH_TOKEN);
}

function isExpired(token: string) {
  const { exp } = jwtDecode<JwtPayload>(token);
  return Date.now() >= exp * 1000;
}
