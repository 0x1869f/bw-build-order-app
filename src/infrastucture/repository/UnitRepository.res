type storedUnit = {
  name: string,
  race: Race.t,
  type_: Unit.unitType,
  image: string,
  supply: int,
  supply_cost: int,
}

let mapper = (v: storedUnit): Unit.t => {
  race: v.race,
  name: v.name,
  type_: v.type_,
  supplyCost: v.supply_cost,
  image: v.image,
  supply: v.supply,
}

let get = async () => {
  try {
    let result: Pg.Result.t<storedUnit> = await Db.client -> Pg.Client.query("SELECT name, race, type as type_, image, supply, supply_cost from unit")
    result
      -> Pg.Result.rows
      -> Array.map(mapper)
      -> State.Exists
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}
