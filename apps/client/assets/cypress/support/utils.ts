export function randString(length: int): string {
  return btoa((Math.random() + 1).toString(36).substring(length));
}

export function randEmail() {
  return `${randString()}@t.co`;
}
