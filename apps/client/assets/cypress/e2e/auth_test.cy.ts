const buildTrackableFetchWithSessionId =
  (fetch) => (fetchUrl, fetchOptions) => {
    const { headers } = fetchOptions;
    const modifiedHeaders = Object.assign(
      { "x-beam-metadata": Cypress.env("beamMetadata") },
      headers
    );

    const modifiedOptions = Object.assign({}, fetchOptions, {
      headers: modifiedHeaders,
    });

    return fetch(fetchUrl, modifiedOptions);
  };

describe("authorization", () => {
  beforeEach(() => {
    Cypress.on("window:before:load", (win) => {
      cy.stub(win, "fetch", buildTrackableFetchWithSessionId(fetch));
    });

    cy.checkoutSession();
    cy.intercept(`${Cypress.config("baseUrl")}**`, (req) => {
      req.headers["x-beam-metadata"] = Cypress.env("beamMetadata");
    }).as("sandbox");

    //cy.request("POST", "/sandbox").then(({ metadata }) => {
      //cy.wrap(metadata).as("metadata");
      //cy.intercept(`${Cypress.config("baseUrl")}**`, (req) => {
        //req.headers["x-beam-metadata"] = metadata;
      //}).as("sandbox");
    //});
    //const response = await fetch(host + "/sandbox", { method: "POST" });

    //if (!response.ok) {
    //throw "Failed to establish sandbox.";
    //}
    //const metadata = await response.text();

    //cy.intercept(`${host}**`, (req) => {
    //console.log("adding header");
    //req.headers["x-beam-metadata"] = metadata;
    //});
  });

  afterEach(() => {
    cy.dropSession();
  });

  it("allows a user to signup", () => {
    cy.visit("/");

    cy.findByRole("link", { name: "Or signup" }).click();

    cy.findByLabelText("Email").type("testin@example.com");
    cy.findByLabelText("Password").type("password123");

    cy.findByRole("button", { name: "Signup" }).click();

    //cy.url().should("equal", "#/");

    //cy.findByRole("button", { name: "Signup" }).click()
    //cy.url().should('include', '/commands/actions')
  });
});
