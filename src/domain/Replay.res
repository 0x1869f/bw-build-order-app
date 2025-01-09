type t = {
  id: Id.t,
  description: option<string>,
  map: Id.t,
  player: Id.t,
  race: Race.t,
  buildOrder: Id.t,
  secondPlayer: option<Id.t>,
  secondRace: Race.t,
  secondBuildOrder: option<Id.t>,
  creator: Id.t,
  file: string,
}
