open BuildOrder.Step

let schema = S.object(s => {
  element: s.field(
    "element",
    // S.union([
    //   S.literal(Unit(S.string)),
    //   S.literal(Building(S.string)),
    //   S.literal(Upgrade(S.string)),
    // ]),
    S.union([
      S.string -> S.to(str => Unit(str)),
      S.string -> S.to(str => Building(str)),
      S.string -> S.to(str => Upgrade(str)),
    ]),
  ),
  isRemovable: s.field("isRemovable", S.bool),
  isCanceled: s.field("isCanceled", S.bool),
  supplyLimitUpBy: s.field("supplyLimitUpBy", S.int),
  comment: s.field("comment", S.option(S.string)),
})
