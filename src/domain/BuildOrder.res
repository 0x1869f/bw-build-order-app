module Step = {
  type item = Building(Id.t) | Unit(Id.t) | Upgrade(Id.t)

  type t = {
    element: item,
    isRemovable: bool,
    isCanceled: bool,
    supplyLimitUpBy: int,
    comment: option<string>,
  }
}

module Info = {
  type t = {
    name: string,
    race: Race.t,
    opponentRace: Race.t,
  }
}

type t = {
  id: Id.t,
  name: string,
  description: option<string>,
  creator: Id.t,
  steps: array<Step.t>,
  race: Race.t,
  opponentRace: Race.t,
  links: array<string>, 
  tags: array<Id.t>
}
