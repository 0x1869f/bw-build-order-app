open BuildOrder.Step

let schema = S.object(s => {
  elementType: s.field(
    "elementType",
    S.union([
      S.literal(Unit),
      S.literal(Building),
      S.literal(Upgrade),
    ]),
  ),
  elementId: s.field("elementId", S.string),
  isRemovable: s.field("isRemovable", S.bool),
  isCanceled: s.field("isCanceled", S.bool),
  supplyLimitUpBy: s.field("supplyLimitUpBy", S.int),
  comment: s.field("comment", S.option(S.string)),
})
