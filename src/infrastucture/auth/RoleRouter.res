external toVerificationPayload: {"id": string, "role": string} => UserRepository.payload = "%identity"

let extractJWTandVerify = (header: string) => {
  switch header -> Js.String2.split(" ") {
    | ["Bearer", token] => try {
      let result = JWT.verify(token, ~privateKey=Env.jwtKey)
      let payload = toVerificationPayload(result)
      Some(payload)
    } catch {
      | _ => None
    }
    | _ => None
  }
}

let make = (role: User.role) => {
  let router = Express.Router.make()

  router -> Express.Router.use((req, res, next) => {
    switch req -> Express.getRequestHeader("Authorization") {
      | Some(value) => {
        switch value -> extractJWTandVerify {
          | Some(payload) => {
            req -> Express.Req.setId(payload.id)
            req -> Express.Req.setRole(payload.role)

            let isMatch = switch role {
              | Root => payload.role === User.Root
              | Admin => payload.role === User.Admin || payload.role === User.Root
              | User => true
            }

            isMatch
              ? next()
              : res -> Express.sendStatus(401) -> ignore

          }
          | None => res -> Express.sendStatus(401) -> ignore
        }
      }
      | None => {
        res -> Express.sendStatus(403) -> ignore
      }
    }
  })

  router
}
