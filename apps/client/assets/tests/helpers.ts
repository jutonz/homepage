import { Page } from "@playwright/test";

export const BASE_URL = "http://localhost:4002";

export async function insert(factory: string, attrs?: any) {
  const response = await fetch(BASE_URL + "/factory/" + factory, {
    method: "POST",
    body: attrs ? JSON.stringify(attrs) : null,
    headers: {
      "content-type": "application/json",
      accept: "application/json",
    },
  });

  if (!response.ok) {
    throw new Error(
      `Factory call failed: ${response.status} ${response.statusText}`,
    );
  }

  return response.json();
}

interface InitSessionOpts {
  password?: string;
  path?: string;
}

export async function initSession(page: Page, opts: InitSessionOpts = {}) {
  const { password = "password123", path } = opts;
  const user = await insert("user", { password });
  let authPath = `/?as=${user.id}`;
  if (path) {
    authPath = authPath + `&to=${encodeURIComponent(path)}`;
  }
  await page.goto(BASE_URL + authPath);
  return user;
}
