/// <reference types="cypress" />
// ***********************************************
// This example commands.ts shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add('login', (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add('drag', { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add('dismiss', { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This will overwrite an existing command --
// Cypress.Commands.overwrite('visit', (originalFn, url, options) => { ... })
//
// declare global {
//   namespace Cypress {
//     interface Chainable {
//       login(email: string, password: string): Chainable<void>
//       drag(subject: string, options?: Partial<TypeOptions>): Chainable<Element>
//       dismiss(subject: string, options?: Partial<TypeOptions>): Chainable<Element>
//       visit(originalFn: CommandOriginalFn, url: string, options: Partial<VisitOptions>): Chainable<Element>
//     }
//   }
// }

import "@testing-library/cypress/add-commands";

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

Cypress.Commands.add("checkoutSession", async () => {
  const response = await fetch("/sandbox", {
    cache: "no-store",
    method: "POST",
  });

  const metadata = await response.text();

  Cypress.on("window:before:load", (win) => {
    cy.stub(win, "fetch", buildTrackableFetchWithSessionId(fetch));
    win.beamMetadata = metadata;
  });

  return Cypress.env("beamMetadata", metadata);
});

Cypress.Commands.add("dropSession", () => {
  //console.log("metadata is", Cypress.env("beamMetadata"));
  fetch("/sandbox", {
    method: "DELETE",
    headers: { "x-beam-metadata": Cypress.env("beamMetadata") },
  });
});
