export default function IsValidPassword(password: string): boolean {
  return password && password.length > 3;
}
