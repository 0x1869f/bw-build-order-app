open Express

let router = Router.make()
router -> Router.use(jsonMiddleware())

AuthMiddleware.make(User.Admin)
  -> Router.use(router, _)


router -> Router.postAsync("/tag", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(TagSchema.schema) 
    let result = await TagRepository.create(payload, req -> Req.getId)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Express.Router.postAsync("/build-order", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(BuildOrderSchema.schema)
    let result = await BuildOrderRepository.create(payload, req -> Req.getId)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.putAsync("/build-order/:id", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(BuildOrderSchema.schema)
    let result = await BuildOrderRepository.update(
      payload,
      ~creator=req -> Req.getId,
      ~id=req -> params -> Dict.get("id") -> Option.getUnsafe
    )

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/player", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(PlayerSchema.schema)
    let result = await PlayerRepository.create(payload, req -> Req.getId)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/map", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(MapSchema.schema)
    let result = await MapRepository.create(payload.name)

    res -> Express.dataOrErr(result)
  } catch {
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/replay", async (req, res) => {
  try {
    let payload = req -> body -> S.parseOrThrow(ReplaySchema.schema)
    let result = await ReplayRepository.create(payload, req -> Req.getId)

    res -> Express.dataOrErr(result)
  } catch { 
    | S.Raised(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.all("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
