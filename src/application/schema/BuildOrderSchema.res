type payload = {
  name: string,
  description: option<string>,
  steps: array<BuildOrder.Step.t>,
  race: Race.t,
  opponentRace: Race.t,
  links: array<string>, 
  tags: array<Id.t>
}

let schema = S.object(s => {
  name: s.field("name", S.string),
  description: s.field("description", S.option(S.string)),
  steps: s.field("step", S.array(BuildOlderStepSchema.schema)),
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
