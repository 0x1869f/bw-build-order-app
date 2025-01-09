module StoredMap = {
  type t = {
    id: Id.t,
    name: string,
    image: nullable<string>
  }

  let toGameMap = (map: t): GameMap.t => {
    id: map.id,
    name: map.name,
    image: map.image -> Nullable.toOption
  }
}

let getMaps = async () => {
  try {
    let result: Pg.Result.t<StoredMap.t> = await Db.client -> Pg.Client.query("SELECT * FROM map")

    result 
      -> Pg.Result.rows
      -> Array.map(StoredMap.toGameMap)
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let create = async (name) => {
  try {
    let result: Pg.Result.t<StoredMap.t> = await Db.client -> Pg.Client.queryWithParam("INSERT INTO map (name) VALUES ($1)", [name])

    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> StoredMap.toGameMap
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let addImage = async (id: Id.t, image: string) => {
  try {
    let result: Pg.Result.t<StoredMap.t> = await Db.client -> Pg.Client.queryWithParam2("UPDATE map SET image = $2 WHERE id = $1", (id, image))

    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> StoredMap.toGameMap
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}
