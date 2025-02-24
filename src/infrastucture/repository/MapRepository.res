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
      -> State.Exists
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let create = async (name) => {
  try {
    let result: Pg.Result.t<StoredMap.t> = await Db.client -> Pg.Client.queryWithParam("INSERT INTO map (name) VALUES ($1) RETURNING id, name, image", [name])
    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> StoredMap.toGameMap
      -> State.Created
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let addImage = async (path: string, id: Id.t) => {
  try {
    let replay: Pg.Result.t<Replay.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from map WHERE id = $1;", [id])

    if replay -> Pg.Result.rowCount -> Nullable.getOr(0) > 0 {
      let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE map SET image = $1 WHERE id = $2;", (path, id))

      State.Updated(path)
    } else {
      State.EntityDoesNotExist -> Error
    }
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}
