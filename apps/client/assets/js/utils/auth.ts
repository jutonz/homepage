import { authExchange } from "@urql/exchange-auth";

export const homepageAuthExchange = authExchange(async (utils) => {
  return {
    addAuthToOperation(operation) {
      const token = getToken();
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

    async refreshAuth() {
      // either logout or attempt to use refresh token
      // Probably can't do anything here until didAuthError works
    },
  };
});
const JWT_TOKEN = "token";

// TODO: Use cookies for this?

function getToken() {
  return localStorage.getItem(JWT_TOKEN);
}

export function setToken(token: string) {
  localStorage.setItem(JWT_TOKEN, token);
}

export function clearTokens() {
  localStorage.removeItem(JWT_TOKEN);
}
