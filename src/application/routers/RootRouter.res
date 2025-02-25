open Express

let router = Express.Router.make()
router -> Router.use(jsonMiddleware())

AuthMiddleware.make(User.Root)
  -> Router.use(router, _)

router -> Router.postAsync("/admin", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(UserSchema.schema)
    let result = await UserRepository.createAdmin(payload.login, payload.nickname, payload.password)
    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) => res -> jsonError(e -> S.Error.message)
  }
})
  
router -> Router.use(jsonMiddleware())
  
router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
