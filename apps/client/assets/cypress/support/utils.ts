export function randString(length?: number): string {
  length = length || 6;
  return btoa((Math.random() + 1).toString(36).substring(length));
}

export function randEmail() {
  return `${randString()}@t.co`;
}

export type User = {
  id: string;
  email: string;
}

type Extra = (user: User) => any;

export async function setup(extra: Extra) {
  const user = await createUser();
  const initUrl = `/?as=${user.id}`;
  const returns = await extra(user);

  return new Promise((resolve) => {
    resolve({ user, initUrl, ...returns });
  });
}

async function createUser() {
  return insert("user", { password: "password123" });
}

const BASE_URL = "http://localhost:4002";
export async function insert(factory: string, attrs?: any) {
  const opts = {
    method: "POST",
    body: attrs ? JSON.stringify(attrs) : null,
    headers: {
      "content-type": "application/json",
      accept: "application/json",
    },
  };

  try {
    const response = await fetch(BASE_URL + "/factory/" + factory, opts);

    if (response.ok) {
      const json = await response.json();
      return json;
    } else {
      console.error(response);
      throw `Something went wrong when calling factory: ${response}`;
    }
  } catch (e) {
    throw `Something went wrong when calling factory: ${e}`;
  }
}
