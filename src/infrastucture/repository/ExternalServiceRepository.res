type t = {
  name: string,
  icon: string,
}

let get = async () => {
  try {
    let result: Pg.Result.t<t> = await Db.client -> Pg.Client.query("SELECT * FROM external_service;")

    result 
      -> Pg.Result.rows
      -> State.Exists
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

