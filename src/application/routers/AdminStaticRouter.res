open Express

let router = RoleRouter.make(User.Admin)

router -> Router.patchAsync("/replay-file/:id", async (req, res) => {
  let parser = Multiparty.makeWithConfig({
    maxFilesSize: "200KB",
    autoFiles: true,
  })

  switch (await parser -> Multiparty.parseAsync(req)).files -> Dict.get("file") {
    | Some(file) => {
      Console.log(file)     
    }
    | None => res -> jsonError("A replay has not been loaded")
  }
})

router -> Router.patchAsync("/player-avatar", async (req, res) => {
  let parser = Multiparty.makeWithConfig({
    maxFilesSize: "2MB",
    autoFiles: true,
  })

  switch (await parser -> Multiparty.parseAsync(req)).files -> Dict.get("file") {
    | Some(file) => {
      Console.log(file)     
    }
    | None => res -> jsonError("An avatar has not been loaded")
  }
})

router -> Router.patchAsync("/map-image", async (req, res) => {
  let parser = Multiparty.makeWithConfig({
    maxFilesSize: "2MB",
    autoFiles: true,
  })

  switch (await parser -> Multiparty.parseAsync(req)).files -> Dict.get("file") {
    | Some(file) => {
      Console.log(file)     
    }
    | None => res -> jsonError("A map image has not been loaded")
  }
})
