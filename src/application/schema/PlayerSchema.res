open Player.New

let schema = S.object(s => {
  race: s.field(
    "race",
    S.enum([
      Race.Protoss,
      Race.Terran,
      Race.Zerg,
    ])
  ),
  nickname: s.field("nickname", S.string),
  twitch: s.field("twitch", S.option(S.string)),
  soop: s.field("soop", S.option(S.string)),
  liquipedia: s.field("liquipedia", S.option(S.string)),
  youtube: s.field("youtube", S.option(S.string)),
})
