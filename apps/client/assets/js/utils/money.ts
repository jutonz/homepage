interface Money {
  amount: number;
  currency: string;
}

export function formatMoney(money: Money | undefined | null) {
  if (!money) return "-";

  const formatter = new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: money.currency,
  });

  return formatter.format(money.amount);
}
