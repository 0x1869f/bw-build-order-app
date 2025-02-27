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
    let path = `${Env.staticDir}/replay/${id}.rep`

    switch (await parser -> Multiparty.parseAsync(req)).files
      -> Dict.get("file")
      -> Option.getOr([])
      -> Array.get(0) {
      | Some(file) => switch await ReplayRepository.addFile(path, id) {
        | Ok(p) => {
          try {
            NodeJs.Fs.renameSync(~from=file.path, ~to_=path)
            State.Ok(p)
          } catch {
            | _ => {
              State.OperationHasFailed -> Error
            }
          }
        }
        | e => e
      }
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
      | Some(file) => {
        let path = `${Env.staticDir}/player-avatar/${id}${file.originalFilename -> NodeJs.Path.extname}`

        switch await PlayerRepository.addAvatar(path, id) {
          | Ok(p) => {
            try {
              NodeJs.Fs.renameSync(~from=file.path, ~to_=path)
              State.Ok(p)
            } catch {
              | _ => {
                State.OperationHasFailed -> Error
              }
            }
          }
          | e => e
        }
      }
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
      | Some(file) => {
        let path = `${Env.staticDir}/map-image/${id}${file.originalFilename -> NodeJs.Path.extname}`

        switch await MapRepository.addImage(path, id) {
          | Ok(p) => {
            try {
              NodeJs.Fs.renameSync(~from=file.path, ~to_=path)
              State.Ok(p)
            } catch {
              | _ => {
                State.OperationHasFailed -> Error
              }
            }
          }
          | e => e
        }
      }
      | None => State.IncorrectData -> Error
    }
  } catch {
    | _ => State.OperationHasFailed
      -> Error
  }
    -> Express.dataOrErr(res, _)
})
