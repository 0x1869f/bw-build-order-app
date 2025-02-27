type storedBuilding = {
  name: string,
  race: Race.t,
  image: string,
  supply: int,
  worker_cost: int,
}

let mapper = (v: storedBuilding): Building.t => {
  {
    race: v.race,
    name: v.name,
    image: v.image,
    workerCost: v.worker_cost,
    supply: v.supply,
  }
}

let get = async () => {
  try {
    let result: Pg.Result.t<storedBuilding> = await Db.client -> Pg.Client.query("SELECT * from building")

    result
      -> Pg.Result.rows
      -> Array.map(mapper)
      -> State.Ok
  } catch {
    | _ => Error(State.OperationHasFailed)
  }
}
