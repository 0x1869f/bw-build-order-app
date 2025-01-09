open Express

let router = RoleRouter.make(User.Admin)

router -> Router.postAsync("/tag", async (req, res) => {
  switch req -> body -> S.parseWith(TagSchema.schema) {
    | Ok(body) => (await TagRepository.create(body, req -> Req.getId))
      -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Express.Router.postAsync("/build-order", async (req, res) => {
  switch req -> body -> S.parseWith(BuildOrderSchema.schema) {
    | Ok(body) => (await BuildOrderRepository.create(body, req -> Req.getId))
      -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.putAsync("/build-order/:id", async (req, res) => {
  switch req -> body -> S.parseWith(BuildOrderSchema.schema) {
    | Ok(body) => (await BuildOrderRepository.update(
        body,
        ~creator=req -> Req.getId,
        ~id=req -> params -> Dict.get("id") -> Option.getUnsafe
      )
    ) -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/player", async (req, res) => {
  switch req -> body -> S.parseWith(PlayerSchema.schema) {
    | Ok(body) => (await PlayerRepository.create(body, req -> Req.getId)) -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/map", async (req, res) => {
  switch req -> body -> S.parseWith(MapSchema.schema) {
    | Ok(body) => (await MapRepository.create(body.name)) -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})

router -> Router.postAsync("/replay", async (req, res) => {
  switch req -> body -> S.parseWith(ReplaySchema.schema) {
    | Ok(body) => (await ReplayRepository.create(body, req -> Req.getId)) -> Express.dataOrErr(res, _)
    | Error(e) =>  res -> jsonError(e -> S.Error.message)
  }
})
   
router -> Router.use(jsonMiddleware())

router -> Router.post("*", (_, res: res) => {
  res -> sendStatus(404) -> ignore
})
