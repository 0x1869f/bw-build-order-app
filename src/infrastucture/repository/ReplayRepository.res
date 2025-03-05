module StoredReplay = {
  type new = {
    description: nullable<string>,
    map: Id.t,
    player: Id.t,
    race: Race.t,
    build_order: Id.t,
    second_player: nullable<Id.t>,
    second_race: Race.t,
    second_build_order: nullable<Id.t>,
  }

  type t = {
    id: Id.t,
    creator: Id.t,
    file: Nullable.t<string>,
    ...new,
  }

  let mapToReplay = (r: t): Replay.t => {
    {
      id: r.id,
      description: r.description -> Nullable.toOption,
      map: r.map,
      player: r.player,
      race: r.race,
      buildOrder: r.build_order,
      secondPlayer: r.second_player -> Nullable.toOption,
      secondRace: r.second_race,
      secondBuildOrder: r.second_build_order -> Nullable.toOption,
      creator: r.creator,
      file: r.file -> Nullable.toOption,
    }
  } 
}

let create = async (replay: Replay.New.t, creator: Id.t) => {
  try {
    let result: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.queryWithParam9(
      "INSERT INTO replay (description, map, player, race, build_order, second_player, second_race, second_build_order, creator) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id, description, map, player, race, build_order, second_player, second_race, second_build_order, creator",
      (
        replay.description -> Nullable.fromOption,
        replay.map,
        replay.player,
        replay.race,
        replay.buildOrder,
        replay.secondPlayer -> Nullable.fromOption,
        replay.secondRace,
        replay.secondBuildOrder -> Nullable.fromOption,
        creator,
      )
    )

    result
      -> Pg.Result.rows
      -> Array.get(0)
      -> State.Created
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let addFile = async (id: Id.t, file: Multiparty.file) => {
  try {
    let replay: Pg.Result.t<Replay.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from replay WHERE id = $1;", [id])

    if replay -> Pg.Result.rowCount -> Nullable.getOr(0) > 0 {
      let dbFile = `${Env.dbStaticPath}/replay/${id}.rep`
      let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE replay SET file = $1 WHERE id = $2;", (dbFile, id))

      try {
        let newLocation = `${Env.staticDir}/replay/${id}.rep`
        NodeJs.Fs.renameSync(~from=file.path, ~to_=newLocation)
        State.Ok(dbFile)
      } catch {
        | _ => {
          State.OperationHasFailed -> Error
        }
      }
    } else {
      State.EntityDoesNotExist -> Error
    }
  } catch {
    | Exn.Error(obj) => {
      Console.log2("base err: ", obj)
      obj -> PgError.toAppState
    }
  }
}

let getAll = async () => {
  try {
    let result: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.query("SELECT * FROM replay")

    result
      -> Pg.Result.rows
      -> Array.map((r) => StoredReplay.mapToReplay(r))
      -> State.Ok
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let delete = async (id: Id.t) => {
  try {
    let _: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.queryWithParam("DELETE * FROM replay WHERE id = $1", [id])

    State.Success
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}
