export function randString(length?: int): string {
  length = length || 6;
  return btoa((Math.random() + 1).toString(36).substring(length));
}

export function randEmail() {
  return `${randString()}@t.co`;
}
