module Step = {
  type item = | @as(1) Building | @as(2) Unit | @as(3) Upgrade

  type t = {
    elementType: item,
    elementId: Id.t,
    isRemovable: bool,
    isCanceled: bool,
    supplyLimitUpBy: int,
    comment: option<string>,
  }
}

module Info = {
  type t = {
    id: string,
    name: string,
    race: Race.t,
    opponentRace: Race.t,
    tags: array<Id.t>,
    creator: Id.t,
  }
}

module New = {
  type t = {
    name: string,
    description: option<string>,
    steps: array<Step.t>,
    race: Race.t,
    opponentRace: Race.t,
    links: array<string>, 
    tags: array<Id.t>
  }
}

type t = {
  ...New.t,
  id: Id.t,
  creator: Id.t,
}
