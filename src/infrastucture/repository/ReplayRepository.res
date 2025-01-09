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
    file: string,
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
      file: r.file,
    }
  } 
}

let create = async (replay: ReplaySchema.payload, creator: Id.t) => {
  try {
    let result: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.queryWithParam9(
      "INSERT INTO replay (description, map, player, race, build_order, second_player, second_race, second_build_order, creator) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)",
      (
        replay.description,
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
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let addFile = async (path: string, id: Id.t) => {
  try {
    let result: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.queryWithParam2("UPDATE replay SET file = $1 WHERE id = $2", (path, id))

    result
      -> Pg.Result.rows
      -> Array.map((r) => StoredReplay.mapToReplay(r))
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let getAll = async () => {
  try {
    let result: Pg.Result.t<StoredReplay.t> = await Db.client -> Pg.Client.query("SELECT * FROM replay")

    result
      -> Pg.Result.rows
      -> Array.map((r) => StoredReplay.mapToReplay(r))
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}
