let get = async () => {
  try {
    let result: Pg.Result.t<Tag.t> = await Db.client -> Pg.Client.query("SELECT * FROM tag")

    result
      -> Pg.Result.rows
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let create = async (tag: TagSchema.payload, creator: Id.t) => {
  try {
    let result: Pg.Result.t<Tag.t> = await Db.client -> Pg.Client.queryWithParam2("INSERT INTO tag (name, creator) VALUES ($1, $2)", (tag.name, creator))

    result
      -> Pg.Result.rows
      -> Array.getUnsafe(0)
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}
