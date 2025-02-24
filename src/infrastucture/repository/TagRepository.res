let get = async () => {
  try {
    let result: Pg.Result.t<Tag.t> = await Db.client -> Pg.Client.query("SELECT * FROM tag ORDER BY race ASC;")

    result
      -> Pg.Result.rows
      -> State.Exists
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let create = async (tag: Tag.New.t, creator: Id.t) => {
  try {
    let result: Pg.Result.t<Tag.t> = await Db.client
      -> Pg.Client.queryWithParam3(
        "INSERT INTO tag (name, race, creator) VALUES ($1, $2, $3) RETURNING id, name, race, creator",
        (tag.name, tag.race, creator)
      )

    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> State.Created
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}
