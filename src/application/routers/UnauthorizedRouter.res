open Express

let router = Router.make()

router -> Router.use(jsonMiddleware())

router -> Router.getAsync("/races", async (_, res: res) => {
  (await RaceRepository.getAll()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/building", async (_, res: res) => {
  (await BuildingRepository.get()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/units", async (_, res: res) => {
  (await UnitRepository.get()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/upgrades", async (_, res: res) => {
  (await UpgradeRepository.get()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/tags", async (_, res: res) => {
  (await TagRepository.get()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/maps", async (_, res: res) => {
  (await MapRepository.getMaps()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/admins", async (_, res: res) => {
  (await UserRepository.getAdminList()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/players", async (_, res: res) => {
  (await PlayerRepository.getAll()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/replays", async (_, res: res) => {
  (await ReplayRepository.getAll()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/external-service", async (_, res: res) => {
  (await ExternalServiceRepository.get()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/build-orders", async (_, res: res) => {
  (await BuildOrderRepository.getBuildOrderInfoList()) -> dataOrErr(res, _)
})

router -> Router.getAsync("/build-order/:id", async (req, res: res) => {
  let params: {"id": string} = req -> Express.params
  (await BuildOrderRepository.find(params["id"])) -> dataOrErr(res, _)
})

router -> Router.postAsync("/login", async (req, res: res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(AuthSchema.schema)
    let result = await UserRepository.login(payload.login, payload.password)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})
  
router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
