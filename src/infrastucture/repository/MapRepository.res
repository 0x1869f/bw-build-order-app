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
      -> State.Ok
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

let addImage = async (id: Id.t, file: Multiparty.file) => {
  try {
    let replay: Pg.Result.t<Replay.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from map WHERE id = $1;", [id])

    if replay -> Pg.Result.rowCount -> Nullable.getOr(0) > 0 {
      let dbFile = `${Env.dbStaticPath}/map-image/${id}${file.originalFilename -> NodeJs.Path.extname}`
      let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE map SET image = $1 WHERE id = $2;", (dbFile, id))

      let newLocation = `${Env.staticDir}/map-image/${id}${file.originalFilename -> NodeJs.Path.extname}`

      try {
        NodeJs.Fs.renameSync(~from=file.path, ~to_=newLocation)
        State.Ok(dbFile)
      } catch {
        | _ => State.OperationHasFailed -> Error
      }
    } else {
      State.EntityDoesNotExist -> Error
    }
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}
