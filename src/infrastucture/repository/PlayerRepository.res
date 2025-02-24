module StoredPlayer = {
  type t = {
    id: string,
    creator: Id.t,
    race: Race.t,
    nickname: string,
    twitch: nullable<string>,
    soop: nullable<string>,
    liquipedia: nullable<string>,
    youtube: nullable<string>,
    avatar: nullable<string>,
  }

  let toPlayer = (player: t): Player.t => {
    id: player.id,
    creator: player.creator,
    race: player.race,
    nickname: player.nickname,
    twitch: player.twitch -> Nullable.toOption,
    soop: player.soop -> Nullable.toOption,
    liquipedia: player.liquipedia -> Nullable.toOption,
    youtube: player.youtube -> Nullable.toOption,
    avatar: player.avatar -> Nullable.toOption,
  }
}

let getAll = async (): State.t<array<Player.t>> => {
  try {
    let result: Pg.Result.t<StoredPlayer.t> = await Db.client -> Pg.Client.query("SELECT * FROM player")

    result
      -> Pg.Result.rows
      -> Array.map(StoredPlayer.toPlayer)
      -> State.Exists
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let create = async (player: Player.New.t, creator: Id.t) => {
  try {
    let result: Pg.Result.t<StoredPlayer.t> = await Db.client -> Pg.Client.queryWithParam7(
      "INSERT into player (creator, race, nickname, twitch, soop, liquipedia, youtube) VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING id, creator, race, nickname, twitch, soop, liquipedia, youtube", (
      creator,
      player.race,
      player.nickname,
      player.twitch -> Nullable.fromOption,
      player.soop -> Nullable.fromOption,
      player.liquipedia -> Nullable.fromOption,
      player.youtube -> Nullable.fromOption
    ))
    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> StoredPlayer.toPlayer
      -> State.Created
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let addAvatar = async (path: string, id: Id.t) => {
  try {
    let replay: Pg.Result.t<Replay.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from player WHERE id = $1;", [id])

    if replay -> Pg.Result.rowCount -> Nullable.getOr(0) > 0 {
      let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE player SET avatar = $1 WHERE id = $2;", (path, id))

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
