type storedBuilding = {
  name: string,
  race: Race.t,
  type_: int, // unit type: 0 - worker, 1 - battle unit 
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
      -> State.Exists
  } catch {
    | _ => Error(State.OperationHasFailed)
  }
}
