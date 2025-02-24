open BuildOrder.New

let schema = S.object(s => {
  name: s.field("name", S.string -> S.stringMinLength(1)),
  description: s.field("description", S.option(S.string)),
  steps: s.field("steps", S.array(BuildOlderStepSchema.schema)),
  tags: s.field("tags", S.array(S.string)),
  links: s.field("links", S.array(S.string)),
  race: s.field(
    "race",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  ),
  opponentRace: s.field(
    "opponentRace",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  )
})
