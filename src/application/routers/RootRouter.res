open Express

let router = RoleRouter.make(User.Root)

router -> Router.postAsync("/admin", async (req, res) => {
  switch req -> body -> S.parseWith(UserSchema.schema) {
    | Ok(body) => (await UserRepository.createAdmin(body.login, body.nickname, body.password)) -> Express.dataOrErr(res, _)
    | Error(e) => res -> jsonError(e -> S.Error.message)
  }
})
  
router -> Router.use(jsonMiddleware())
  
router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
