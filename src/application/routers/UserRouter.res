open Express

let router = RoleRouter.make(User.User)

router -> Router.getAsync("/get-info", async (req, res: res) => {
  (await UserRepository.getInfo(req -> Req.getId)) -> Express.dataOrErr(res, _)
})
  
router -> Router.use(jsonMiddleware())
  
router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
