type paylod = {
  race: Race.t,
  nickname: string,
  bio: option<string>,
  twitch: option<string>,
  soop: option<string>,
  liquipedia: option<string>,
}

let schema = S.object(s => {
  race: s.field(
    "race",
    S.union([
      S.literal(Race.Protoss),
      S.literal(Race.Terran),
      S.literal(Race.Zerg),
    ])
  ),
  nickname: s.field("nickname", S.string),
  bio: s.field("bio", S.option(S.string)),
  twitch: s.field("twitch", S.option(S.string)),
  soop: s.field("soop", S.option(S.string)),
  liquipedia: s.field("liquipedia", S.option(S.string)),
})
