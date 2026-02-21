import { test, expect } from "@playwright/test";
import { BASE_URL, initSession } from "./helpers";

test.describe("Auth", () => {
  test("allows me to sign up", async ({ page }) => {
    await page.goto(BASE_URL + "/#/login?bg=false");
    await page.getByRole("link", { name: "Or signup" }).click();

    const email = `wee-${Math.random()}@example.com`;
    await page.getByRole("textbox", { name: "Email" }).fill(email);
    await page.getByRole("textbox", { name: "Password" }).fill("password123");
    await page.getByRole("button", { name: "Signup" }).click();

    await expect(page.getByRole("link", { name: "Logout" })).toBeVisible();
  });

  test("allows a user to logout and login", async ({ page }) => {
    const password = "password123";
    const user = await initSession(page, { password });

    await page.getByRole("link", { name: "Logout" }).click();
    await expect(page).toHaveURL(/#\/login/);

    await page.getByRole("textbox", { name: "Email" }).fill(user.email);
    await page.getByRole("textbox", { name: "Password" }).fill(password);
    await page.getByRole("button", { name: "Login" }).click();

    await expect(page.getByRole("link", { name: "Logout" })).toBeVisible();
  });

  test("allows a user to change their password", async ({ page }) => {
    const password = "password123";
    const user = await initSession(page, { password });

    await page.getByRole("link", { name: "Settings" }).click();

    const newPassword = "abc123";
    const form = page.locator("form", { hasText: "Change password" });

    await form.getByLabel("Current password").fill(password);
    await form.getByLabel("New password", { exact: true }).fill(newPassword);
    await form.getByLabel("New password (confirm)").fill(newPassword);
    await form.getByRole("button", { name: "Change password" }).click();

    await expect(page.getByText("Password changed.")).toBeVisible();

    await page.getByRole("link", { name: "Logout" }).click();

    await page.getByRole("textbox", { name: "Email" }).fill(user.email);
    await page.getByRole("textbox", { name: "Password" }).fill(newPassword);
    await page.getByRole("button", { name: "Login" }).click();

    await expect(page.getByRole("link", { name: "Logout" })).toBeVisible();
  });

  test("allows a user to generate a one-time login link", async ({ page }) => {
    await initSession(page, { path: "/#/settings" });

    const section = page.locator("div", { hasText: "One-time login link" });
    await section.getByRole("button", { name: "Generate" }).click();
  });
});
