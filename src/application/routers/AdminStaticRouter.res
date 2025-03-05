open Express

let router = Express.Router.make()
AuthMiddleware.make(User.Admin)
  -> Router.use(router, _)

router -> Router.patchAsync("/replay-file/:id", async (req, res) => {
  try {
    let parser = Multiparty.makeWithConfig({
      maxFilesSize: "200KB",
      autoFiles: true,
      uploadDir: `${Env.staticDir}/tmp/`
    })

    let id = req -> params -> Dict.get("id") -> Option.getUnsafe

    switch (await parser -> Multiparty.parseAsync(req)).files
      -> Dict.get("file")
      -> Option.getOr([])
      -> Array.get(0) {
      | Some(file) => await ReplayRepository.addFile(id, file)
      | None => State.IncorrectData -> Error
    }
  } catch {
    | _ => State.OperationHasFailed
      -> Error
  }
    -> Express.dataOrErr(res, _)
})

router -> Router.patchAsync("/player-avatar/:id", async (req, res) => {
  try {
    let parser = Multiparty.makeWithConfig({
      maxFilesSize: "2MB",
      autoFiles: true,
      uploadDir: `${Env.staticDir}/tmp/`
    })

    let id = req
      -> params
      -> Dict.get("id")
      -> Option.getUnsafe

    switch (await parser -> Multiparty.parseAsync(req)).files
      -> Dict.get("file")
      -> Option.getOr([])
      -> Array.get(0) {
      | Some(file) => await PlayerRepository.addAvatar(id, file)
      | None => State.IncorrectData -> Error
    }
  } catch {
    | _ => State.OperationHasFailed
      -> Error
  }
    -> Express.dataOrErr(res, _)
})

router -> Router.patchAsync("/map-image/:id", async (req, res) => {
  try {
    let parser = Multiparty.makeWithConfig({
      maxFilesSize: "2MB",
      autoFiles: true,
      uploadDir: `${Env.staticDir}/tmp/`
    })

    let id = req
      -> params
      -> Dict.get("id")
      -> Option.getUnsafe

    switch (await parser -> Multiparty.parseAsync(req)).files
      -> Dict.get("file")
      -> Option.getOr([])
      -> Array.get(0) {
      | Some(file) => await MapRepository.addImage(id, file)
      | None => State.IncorrectData -> Error
    }
  } catch {
    | _ => State.OperationHasFailed
      -> Error
  }
    -> Express.dataOrErr(res, _)
})
