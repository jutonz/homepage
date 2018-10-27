// const thing = { one: { two: :three } };
// dig(thing, ["one", "two"]) => "three"
export const dig = (subject: Object, attrs: Array<string>) => {
  let node = subject;
  attrs.forEach(attr => {
    if (!!!node) return;
    node = node[attr];
  });
  return node;
};
