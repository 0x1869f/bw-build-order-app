module StoredBuildOrder = {
  module Step  = {
    type t = {
      build_order: Id.t,
      unit: Nullable.t<Id.t>,
      building: Nullable.t<Id.t>,
      upgrade: Nullable.t<Id.t>,
      is_removable: bool,
      is_canceled: bool,
      supply_limit_up_by: int,
      comment: Nullable.t<string>
    }

    let getStoredElement = (step: BuildOrder.Step.t) => switch step.elementType {
      | BuildOrder.Step.Unit => (Nullable.make(step.elementId), Nullable.Null, Nullable.Null)
      | BuildOrder.Step.Building => (Nullable.Null, Nullable.make(step.elementId), Nullable.Null)
      | BuildOrder.Step.Upgrade => (Nullable.Null, Nullable.Null, Nullable.make(step.elementId))
    }

    let toBuildOrderStep = (storedStep: t): BuildOrder.Step.t => {
      let (elementType, elementId) = if !(storedStep.unit -> Nullable.isNullable) {
          (BuildOrder.Step.Unit, storedStep.unit -> Nullable.getUnsafe)
        } else {
          if !(storedStep.building -> Nullable.isNullable) {
            (BuildOrder.Step.Building, storedStep.building -> Nullable.getUnsafe)
          } else {
            (BuildOrder.Step.Building, storedStep.upgrade -> Nullable.getUnsafe)
          }
        }

      {
        elementType,
        elementId,
        isRemovable: storedStep.is_removable,
        isCanceled: storedStep.is_canceled,
        supplyLimitUpBy: storedStep.supply_limit_up_by,
        comment: storedStep.comment -> Nullable.toOption,
      }
    }
  }

  module StoredLink = {
    type t = {
      build_order: Id.t,
      link: Link.t,
    }

    let toLink = (link: t): Link.t => {
      link.link
    }
  }

  module Info = {
    type t = {
      id: Id.t,
      name: string,
      race: Race.t,
      opponent_race: Race.t,
      creator: Id.t,
    }

    type infoWithTags = {
      ...t,
      tags: array<Id.t>,
    }

    let toBuildOrderInfoWithTags = (info: infoWithTags): BuildOrder.Info.t => {
      {
        id: info.id,
        name: info.name,
        race: info.race,
        opponentRace: info.opponent_race,
        tags: info.tags,
        creator: info.creator,
      }
    }

    let toBuildOrderInfo = (info: t, tags: array<Id.t>): BuildOrder.Info.t => {
      {
        id: info.id,
        name: info.name,
        race: info.race,
        opponentRace: info.opponent_race,
        tags,
        creator: info.creator,
      }
    }
  }

  type t = {
    id: Id.t,
    name: string,
    creator: Id.t,
    race: Race.t,
    opponent_race: Race.t,
    description: Nullable.t<string>,
    steps: array<Step.t>,
    tags: array<Id.t>
  }

  let toBuildOrder = (bo: t, ~steps: array<Step.t>, ~tags: array<Id.t>, ~links: array<Link.t>): BuildOrder.t => {
    {
      id: bo.id,
      name: bo.name,
      description: bo.description -> Nullable.toOption,
      creator: bo.creator,
      steps: steps -> Array.map(Step.toBuildOrderStep),
      race: bo.race,
      opponentRace: bo.opponent_race,
      tags,
      links,
    }
  }
}

let getBuildOrderSteps = async (id: Id.t): array<StoredBuildOrder.Step.t> => {
  try {
    let result: Pg.Result.t<StoredBuildOrder.Step.t> = await Db.client -> Pg.Client.queryWithParam(
      "SELECT * from build_order_step WHERE build_order = $1;", [id])
    result -> Pg.Result.rows
  } catch {
    | _ => []
  }
}

let getBuildOrderTags = async (id: Id.t): array<Id.t> => {
  try {
    let result: Pg.Result.t<{"tags": Nullable.t<array<Id.t>>}> = await Db.client -> Pg.Client.queryWithParam(
      "SELECT array_agg(tag) as tags from build_order_tag WHERE build_order = $1;", [id]
    )
    switch (result -> Pg.Result.rows -> Array.getUnsafe(0))["tags"] -> Nullable.toOption {
      | Some(v)=> v
      | None => []
    }
  } catch {
    | _ => []
  }
}

let getBuildOrderLinks = async (id: Id.t): array<Id.t> => {
  try {
    let result: Pg.Result.t<{"links": Nullable.t<array<Id.t>>}> = await Db.client -> Pg.Client.queryWithParam(
      "SELECT array_agg(link) as links from build_order_link WHERE build_order = $1;", [id]
    )
    switch (result -> Pg.Result.rows -> Array.getUnsafe(0))["links"] -> Nullable.toOption {
      | Some(v)=> v
      | None => []
    }
  } catch {
    | _ => []
  }
}

let getBuildOrderInfoList = async () => {
  try {
    let result: Pg.Result.t<StoredBuildOrder.Info.infoWithTags> = await Db.client -> Pg.Client.query(
      "select id, name, race, creator, opponent_race, array_remove(array_agg(t.tag), NULL) AS tags from build_order bo LEFT JOIN build_order_tag t ON bo.id = t.build_order GROUP BY bo.id;"
    )

    result
      -> Pg.Result.rows
      -> Array.map(StoredBuildOrder.Info.toBuildOrderInfoWithTags)
      -> State.Exists
  } catch {
    | Exn.Error(obj) => {
      obj -> PgError.toAppState
    }
  }
}

let find = async (id: Id.t): State.t<BuildOrder.t> => {
  try {
    let boList: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam(
      "SELECT * FROM build_order WHERE id = $1;", [id]
    )

    switch boList -> Pg.Result.rows -> Array.get(0) {
      | Some(value) => {
        let tags = await getBuildOrderTags(id)
        let links = await getBuildOrderLinks(id)
        let steps = await getBuildOrderSteps(id)

        value
        -> StoredBuildOrder.toBuildOrder(~tags=tags, ~steps=steps, ~links=links)
        -> State.Exists
      }
      | None => Error(State.EntityDoesNotExist)
    }
  } catch {
    | Exn.Error(obj) => obj -> PgError.toAppState
  }
}

let create = async (buildOrder: BuildOrder.New.t, creator: Id.t): State.t<BuildOrder.Info.t> => {
  try {
    let _ = await Db.client -> Pg.Client.query("BEGIN;")

    let result: Pg.Result.t<StoredBuildOrder.Info.t> = await Db.client -> Pg.Client.queryWithParam5(
      "INSERT INTO build_order (name, description, creator, race, opponent_race) VALUES($1, $2, $3, $4, $5) RETURNING id, name, race, opponent_race, creator;",
      (buildOrder.name, buildOrder.description, creator, buildOrder.race, buildOrder.opponentRace)
    )

    let bo = result -> Pg.Result.rows -> Array.getUnsafe(0)

    buildOrder.steps -> Array.forEach((step) => {
      let (unit, building, upgrade) = StoredBuildOrder.Step.getStoredElement(step)

      Db.client -> Pg.Client.queryWithParam7(
        "INSERT INTO build_order_step (build_order, unit, building, upgrade, is_removable, is_canceled, supply_limit_up_by) VALUES($1, $2, $3, $4, $5, $6, $7);",
        (bo.id, unit, building, upgrade, step.isRemovable, step.isCanceled, step.supplyLimitUpBy)
      ) -> ignore
    })

    buildOrder.links -> Array.forEach((link) => {
      Db.client -> Pg.Client.queryWithParam2(
        "INSERT INTO build_order_link (build_order, link) VALUES ($1, $2);",
        (bo.id, link)
      ) -> ignore
    })

    buildOrder.tags -> Array.forEach((tag) => {
      Db.client -> Pg.Client.queryWithParam2(
        "INSERT INTO build_order_tag (build_order, tag) VALUES($1, $2);",
        (bo.id, tag)
      ) -> ignore
    })
    
    let _ = await Db.client -> Pg.Client.query("COMMIT;")

    let tags = await getBuildOrderTags(bo.id)

    bo
      -> StoredBuildOrder.Info.toBuildOrderInfo(tags)
      -> State.Updated
  } catch {
    | Exn.Error(obj) => {
      Console.log(obj)
      obj -> PgError.toAppState
    }
  }
}

let update = async (buildOrder: BuildOrder.New.t, ~id: Id.t, ~creator: Id.t): State.t<BuildOrder.Info.t> => {
  try {
    let oldBoRows: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * FROM build_order WHERE id = $1;", [id])

    if oldBoRows -> Pg.Result.rowCount -> Nullable.getOr(0) ===  1 {
      let oldBo = oldBoRows -> Pg.Result.rows -> Array.getUnsafe(0)

      if oldBo.creator === creator {
        let _ = await Db.client -> Pg.Client.query("BEGIN")

        let boResult: Pg.Result.t<StoredBuildOrder.Info.t> = await Db.client -> Pg.Client.queryWithParam5(
          "UPDATE build_order SET name = $1, description = $2, race = $3, opponent_race = $4 WHERE id = $5 RETURNING id, name, race, opponent_race, creator;",
          (buildOrder.name, buildOrder.description, buildOrder.race, buildOrder.opponentRace, id)
        )

        let bo = boResult
          -> Pg.Result.rows
          -> Array.getUnsafe(0)

        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam("DELETE FROM build_order_tag WHERE build_order = $1;", [id])
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam("DELETE FROM build_order_step WHERE build_order = $1;", [id])
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam("DELETE FROM build_order_link WHERE build_order = $1;", [id])


        buildOrder.steps -> Array.forEach((step) => {
          let (unit, building, upgrade) = StoredBuildOrder.Step.getStoredElement(step)

          Db.client -> Pg.Client.queryWithParam8(
            "INSERT INTO build_order_step (build_order, unit, building, upgrade, is_removable, is_canceled, supply_limit_up_by, comment) VALUES ($1, $2, $3, $4, $5, $6, $7, $8);",
            (oldBo.id, unit, building, upgrade, step.isRemovable, step.isCanceled, step.supplyLimitUpBy, step.comment)
          ) -> ignore
        })

        buildOrder.links -> Array.forEach((link) => {
          Db.client -> Pg.Client.queryWithParam2(
            "INSERT INTO build_order_link (build_order, link) VALUES ($1, $2);",
            (oldBo.id, link)
          ) -> ignore
        })

        buildOrder.tags -> Array.forEach((tag) => {
          Db.client -> Pg.Client.queryWithParam2(
            "INSERT INTO build_order_tag (build_order, tag) VALUES ($1, $2);",
            (oldBo.id, tag)
          ) -> ignore
        })
        
        let _ = await Db.client -> Pg.Client.query("COMMIT;")

        let tags = await getBuildOrderTags(bo.id)

        bo
          -> StoredBuildOrder.Info.toBuildOrderInfo(tags)
          -> State.Updated
      } else {
        State.Error(State.Forbidden)
      }
    } else {
      State.Error(State.EntityDoesNotExist)
    }
  } catch {
    | Exn.Error(obj) => {
      Console.log(obj)
      let _ = await Db.client -> Pg.Client.query("ROLLBACK")
      obj -> PgError.toAppState
    }
  }
}
