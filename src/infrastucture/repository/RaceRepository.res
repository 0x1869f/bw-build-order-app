module StoredRace = {
  type t = {
    name: Race.t,
    icon: string,
  }
}

let getAll = async () => {
  try {
    let result: Pg.Result.t<StoredRace.t> = await Db.client -> Pg.Client.query("SELECT * FROM race")

    result
      -> Pg.Result.rows
      -> State.Ok
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}
