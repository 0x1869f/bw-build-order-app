module New = {
  type t = {
    race: Race.t,
    nickname: string,
    twitch: option<string>,
    soop: option<string>,
    liquipedia: option<string>,
    youtube: option<string>,
  }
}

type t = {
  ...New.t,
  id: string,
  creator: Id.t,
  avatar: option<string>,
}
