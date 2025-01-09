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

          Ok({"token": token})
        } else {
          Error(AppError.IncorrectData)
        }
      }
      | _ => Error(AppError.IncorrectData)
    }
  } catch {
    | _ =>  Error(AppError.OperationHasFailed)
  }
}

let getAdminList = async () => {
  try {
    let result: Pg.Result.t<User.t> = await Db.client -> Pg.Client.query("SELECT id, nickname, role FROM app_user WHERE role = 1")

    Ok(result -> Pg.Result.rows)
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let getInfo = async (id: string) => {
  try {
    let result: Pg.Result.t<User.t> = await Db.client -> Pg.Client.queryWithParam("SELECT id, nickname, role FROM app_user WHERE id = $1", [id])

    switch result -> Pg.Result.rowCount -> Nullable.getOr(0) {
      | 1 => result
        -> Pg.Result.rows
        -> Array.get(0)
        -> Ok
      | _ => Error(AppError.EntityDoesNotExist)
    }
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let changePassword = async (id: string, oldPassword: string, newPassword: string) => {
  try {
    let result: Pg.Result.t<storedUser> = await Db.client -> Pg.Client.queryWithParam("SELECT id, password FROM app_user WHERE id = $1", [id])

    switch result -> Pg.Result.rowCount -> Nullable.getOr(0) {
      | 1 => let user = result -> Pg.Result.rows -> Array.getUnsafe(0)

      if Encription.validate(oldPassword, user.password) {
        let newPasswordHash = Encription.generate(newPassword)
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam2("UPDATE user WHERE id = $1 SET password = $2", (id, newPasswordHash))
        Ok()
      } else {
        Error(AppError.OperationHasFailed)
      }
    | _ => Error(AppError.EntityDoesNotExist)
    }
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let create = async (login: string, nickname: string, password: string, role: User.role) => {
  try {
    let passwordHash = Encription.generate(password)
    let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam5(
      "INSERT into user (login, nickname, password, role, registered_at) VALUES ($1, $2, $3, $4, $5)",
      (login, nickname, passwordHash, role, Time.getCurrentStoredTime())
    )
    Ok()
  } catch {
    | _ => Error(AppError.OperationHasFailed)
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
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam5(
          "INSERT into app_user (login, nickname, password, role, registered_at) VALUES ($1, $2, $3, $4, $5) ON CONFLICT DO NOTHING",
          (root -> String.toLowerCase, root, passwordHash, User.Root, Time.getCurrentStoredTime())
        )
      } catch {
        | e => Console.log(e)
      }
    }
    | None => ()
  }
}
