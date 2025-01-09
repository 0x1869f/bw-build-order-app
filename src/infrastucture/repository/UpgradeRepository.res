let get = async () => {
  try {
    let result: Pg.Result.t<Upgrade.t> = await Db.client -> Pg.Client.query("SELECT * from building")
    result
      -> Pg.Result.rows
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}
