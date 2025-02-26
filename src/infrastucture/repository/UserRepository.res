type storedUser = {
  id: string,
  password: string,
  login: string,
  nickname: string,
  role: User.role,
}

type payload = {id: string, role: User.role}

let login = async (login: string, password: string) => {
  try {
    let result: Pg.Result.t<storedUser> = await Db.client -> Pg.Client.queryWithParam("SELECT * FROM app_user WHERE login = $1", [login])

    switch result -> Pg.Result.rowCount -> Nullable.getOr(0) {
      | 1 => {
        let user = result -> Pg.Result.rows -> Array.getUnsafe(0)
        if Encription.validate(password, user.password) {
          let token = JWT.sign({"id": user.id, "role": user.role}, ~privateKey=Env.jwtKey, ~signOptions={expiresIn: "30d"})

          State.Exists({"token": token})
        } else {
          Error(State.IncorrectData)
        }
      }
      | _ => Error(State.IncorrectData)
    }
  } catch {
    | _ =>  Error(State.OperationHasFailed)
  }
}

let getAdminList = async () => {
  try {
    let result: Pg.Result.t<User.t> = await Db.client -> Pg.Client.query("SELECT id, nickname, role FROM app_user WHERE role = 1 OR role = 0")

    result
      -> Pg.Result.rows
      -> State.Exists
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let getInfo = async (id: string) => {
  try {
    let result: Pg.Result.t<User.t> = await Db.client -> Pg.Client.queryWithParam("SELECT id, nickname, role FROM app_user WHERE id = $1", [id])

    switch result -> Pg.Result.rowCount -> Nullable.getOr(0) {
      | 1 => result
        -> Pg.Result.rows
        -> Array.get(0)
        -> State.Exists
      | _ => State.Error(State.EntityDoesNotExist)
    }
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let changeNickname = async (id: string, nickname: string) => {
  try {
    let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE app_user SET nickname = $1 WHERE id = $2", (nickname, id))

    State.UpdatedEmpty
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let changePassword = async (id: string, ~oldPassword: string, ~newPassword: string) => {
  try {
    let result: Pg.Result.t<storedUser> = await Db.client -> Pg.Client.queryWithParam("SELECT * FROM app_user WHERE id = $1", [id])

    switch result -> Pg.Result.rows -> Array.get(0) {
      | Some(user) => {
        let oldPasswordHash = Encription.generate(oldPassword)

        if user.password === oldPasswordHash {
          let passwordHash = Encription.generate(newPassword)
          let _ = await Db.client -> Pg.Client.queryWithParam2("UPDATE app_user SET password = $1 WHERE id = $2", (passwordHash, id))

          State.UpdatedEmpty
        } else {
          State.Forbidden -> State.Error
        }
      }
      | None => State.EntityDoesNotExist -> State.Error
    }
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let create = async (login: string, nickname: string, password: string, role: User.role) => {
  try {
    let passwordHash = Encription.generate(password)
    let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam4(
      "INSERT INTO app_user (login, nickname, password, role) VALUES ($1, $2, $3, $4)",
      (login, nickname, passwordHash, role)
    )
    State.Created()
  } catch {
    | _ => State.Error(State.OperationHasFailed)
  }
}

let createUser = (login: string, nickname: string, password: string) => {
  create(login, nickname, password, User.User)
}

let createAdmin = (login: string, nickname: string, password: string) => {
  create(login, nickname, password, User.Admin)
}

// for dev env
let createRoot = async () => {
  switch Env.rootAdmin {
    | Some(root) => {
      try {
        let passwordHash = Encription.generate("abcdskjfskfjasieuwjikjk")
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam4(
          "INSERT into app_user (login, nickname, password, role) VALUES ($1, $2, $3, $4) ON CONFLICT DO NOTHING",
          (root -> String.toLowerCase, root, passwordHash, User.Root)
        )
      } catch {
        | e => Console.log(e)
      }
    }
    | None => ()
  }
}
