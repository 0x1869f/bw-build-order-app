module StoredPlayer = {
  type t = {
    id: string,
    creator: Id.t,
    race: Race.t,
    nickname: string,
    bio: nullable<string>,
    twitch: nullable<string>,
    soop: nullable<string>,
    liquipedia: nullable<string>,
    avatar: nullable<string>,
  }

  let toPlayer = (player: t): Player.t => {
    id: player.id,
    creator: player.creator,
    race: player.race,
    nickname: player.nickname,
    bio: player.bio -> Nullable.toOption,
    twitch: player.twitch -> Nullable.toOption,
    soop: player.soop -> Nullable.toOption,
    liquipedia: player.liquipedia -> Nullable.toOption,
    avatar: player.avatar -> Nullable.toOption,
  }
}

let getAll = async () => {
  try {
    let result: Pg.Result.t<Player.t> = await Db.client -> Pg.Client.query("SELECT * FROM player")

    result
      -> Pg.Result.rows
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let create = async (player: PlayerSchema.paylod, creator: Id.t) => {
  try {
    let result: Pg.Result.t<StoredPlayer.t> = await Db.client -> Pg.Client.queryWithParam7("INSERT into player (creator, race, nickname, bio, twitch, soop, liquipedia) VALUES ($1,$2,$3,$4,$5,$6,$7)", (
      creator,
      player.race,
      player.nickname,
      player.bio -> Nullable.fromOption,
      player.twitch -> Nullable.fromOption,
      player.soop -> Nullable.fromOption,
      player.liquipedia -> Nullable.fromOption
    ))
    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> StoredPlayer.toPlayer
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}
