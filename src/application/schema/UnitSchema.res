open Unit

let schema = S.object(s => {
  race: s.field(
    "race",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  ),
  type_: s.field(
    "type",
    S.union([
      S.literal(Unit.Worker),
      S.literal(Unit.BattleUnit),
    ])
  ),
  name: s.field("name", S.string),
  image: s.field("image", S.string),
  supplyCost:s.field("supply cost", S.int),
  supply: s.field("supply", S.int),
})
