open Tag.New

let schema = S.object(s => {
  name: s.field("name", S.string),
  race: s.field(
    "race",
    S.enum([
      Race.Protoss,
      Race.Terran,
      Race.Zerg,
    ])
  ),
})
