module New = {
  type t = {
    description: option<string>,
    map: Id.t,
    player: Id.t,
    race: Race.t,
    buildOrder: Id.t,
    secondPlayer: option<Id.t>,
    secondRace: Race.t,
    secondBuildOrder: option<Id.t>,
  }
}

type t = {
  ...New.t,
  id: Id.t,
  creator: Id.t,
  file: option<string>,
}
