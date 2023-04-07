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

import { randEmail } from "./utils";

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

// TODO: This doesn't work. Even when sending sandbox data to the backend, we
// still weren't operating in a sandbox. Maybe something to do with Absinthe
// runs in a separate process outside the sandbox? I could maybe set the db
// connection mode to manual and see if I can find the source of errors.
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

// TODO: This doesn't work. Even when sending sandbox data to the backend, we
// still weren't operating in a sandbox
Cypress.Commands.add("dropSession", () => {
  //console.log("metadata is", Cypress.env("beamMetadata"));
  fetch("/sandbox", {
    method: "DELETE",
    headers: { "x-beam-metadata": Cypress.env("beamMetadata") },
  });
});

interface SignupOpts {
  email?: string;
  password?: string;
}

Cypress.Commands.add("signup", (opts?: SignupOpts) => {
  opts = opts || {};
  const email = opts.email || randEmail();
  const password = opts.password || "password123";

  cy.visit("/");

  cy.findByRole("link", { name: "Or signup" }).click();

  cy.findByLabelText("Email").type(email);
  cy.findByLabelText("Password").type(password);

  cy.findByRole("button", { name: "Signup" }).click();

  cy.location("hash").should("eql", "#/");

  return cy.wrap({ email, password });
});

interface LoginOpts {
  email: string;
  password: string;
}

Cypress.Commands.add("login", ({ email, password }: LoginOpts) => {
  cy.visit("/");

  cy.findByLabelText("Email").type(email);
  cy.findByLabelText("Password").type(password);

  cy.findByRole("button", { name: "Login" }).click();

  cy.location("pathname").should("eql", "/");
});

Cypress.Commands.add("insert", (factory: string, attrs?: any) => {
  attrs = attrs ?? {};
  cy.request("POST", `/factory/${factory}`, attrs).then((response) => {
    return cy.wrap(response.body);
  });
});

interface User {
  id: number;
  email: string;
}

interface InitSessionOpts {
  password?: string;
  path?: string;
}

Cypress.Commands.add("initSession", (opts: InitSessionOpts = {}) => {
  let { password, path } = opts;
  password = password ?? "password123";


  cy.insert("user", { password }).then((user: User) => {
    let authPath = `/?as=${user.id}`;
    if(path) authPath = authPath + `&to=${path}`

    cy.visit(authPath);

    return cy.wrap(user);
  });
});

declare global {
  namespace Cypress {
    interface Chainable {
      checkoutSession(): void;
      dropSession(): void;
      signup(opts?: SignupOpts): Cypress.Chainable<SignupOpts>;
      login(opts: LoginOpts) : void;
      insert(factory: string, attrs?: any): Cypress.Chainable<any>;
      initSession(opts?: InitSessionOpts): Cypress.Chainable<User>;
    }
  }
}
