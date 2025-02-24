open Replay.New

let schema = S.object(s => {
  description: s.field("description", S.option(S.string)),
  map: s.field("map", S.string -> S.uuid),
  player: s.field("player", S.string -> S.uuid),
  race: s.field(
    "race",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  ),
  buildOrder: s.field("buildOrder", S.string -> S.uuid),
  secondPlayer: s.field("secondPlayer", S.option(S.string -> S.uuid)),
  secondRace: s.field(
    "secondRace",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  ),
  secondBuildOrder: s.field("secondBuildOrder", S.option(S.string -> S.uuid)),
})
