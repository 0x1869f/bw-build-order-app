let get = async () => {
  try {
    let result: Pg.Result.t<Upgrade.t> = await Db.client -> Pg.Client.query("SELECT * from upgrade")
    result
      -> Pg.Result.rows
      -> State.Exists
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}
