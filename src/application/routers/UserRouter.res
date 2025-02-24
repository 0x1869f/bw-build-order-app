open Express

let router = Express.Router.make()
router -> Router.use(jsonMiddleware())

AuthMiddleware.make(User.User)
  -> Router.use(router, _)

router -> Router.getAsync("/get-info", async (req, res: res) => {
  (await UserRepository.getInfo(req -> Req.getId)) -> Express.dataOrErr(res, _)
})

router -> Router.patchAsync("/change-password", async (req, res: res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(NewPasswordSchema.schema) 
    let result = await UserRepository.changePassword(
      req -> Req.getId,
      ~oldPassword=payload.oldPassword,
      ~newPassword=payload.newPassword,
    )

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.patchAsync("/change-nickname", async (req, res: res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(NewNicknameSchema.schema) 
    let result = await UserRepository.changeNickname(req -> Req.getId, payload.nickname)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})
  
router -> Router.use(jsonMiddleware())
  
router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
