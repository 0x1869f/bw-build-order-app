type t = {
  id: string,
  creator: Id.t,
  race: Race.t,
  nickname: string,
  bio: option<string>,
  twitch: option<string>,
  soop: option<string>,
  liquipedia: option<string>,
  avatar: option<string>,
}
