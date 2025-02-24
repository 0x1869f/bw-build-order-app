module New = {
  type t = {
    race: Race.t,
    name: string,
  }
}

type t = {
  ...New.t,
  id: Id.t,
  creator: Id.t,
}
