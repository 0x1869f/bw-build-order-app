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

    let getStoredElement = (step: BuildOrder.Step.item) => switch step {
      | BuildOrder.Step.Unit(id) => (Nullable.make(id), Nullable.Null, Nullable.Null)
      | BuildOrder.Step.Building(id) => (Nullable.Null, Nullable.make(id), Nullable.Null)
      | BuildOrder.Step.Upgrade(id) => (Nullable.Null, Nullable.Null, Nullable.make(id))
    }

    let fromBuildOrderStep = (step: BuildOrder.Step.t, bo_id: Id.t): t => {
      let (unit, building, upgrade) = getStoredElement(step.element)

      {
        build_order: bo_id,
        unit,
        building,
        upgrade,
        is_removable: step.isRemovable,
        is_canceled: step.isCanceled,
        supply_limit_up_by: step.supplyLimitUpBy,
        comment: step.comment -> Nullable.fromOption,
      }
    }

    let toBuildOrderStep = (storedStep: t): BuildOrder.Step.t => {
      let element = if !(storedStep.unit -> Nullable.isNullable) {
          BuildOrder.Step.Unit(storedStep.unit -> Nullable.getUnsafe)
        } else {
          if !(storedStep.building -> Nullable.isNullable) {
            BuildOrder.Step.Building(storedStep.building -> Nullable.getUnsafe)
          } else {
            BuildOrder.Step.Building(storedStep.upgrade -> Nullable.getUnsafe)
          }
        }

      {
        element,
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
      name: string,
      race: Race.t,
      opponent_race: Race.t,
    }

    let toBuildOrderInfo = (info: t): BuildOrder.Info.t => {
      {
        name: info.name,
        race: info.race,
        opponentRace: info.opponent_race,
      }
    }
  }

  type t = {
    id: Id.t,
    name: string,
    creator: Id.t,
    race: Race.t,
    opponent_race: Race.t,
    description: Nullable.t<string>
  }

  let toBuildOrder = (bo: t, steps: array<Step.t>, tags: array<Id.t>, links: array<Link.t>): BuildOrder.t => {
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


let getBuildOrderInfoList = async () => {
  try {
    let result: Pg.Result.t<StoredBuildOrder.Info.t> = await Db.client -> Pg.Client.query("SELECT name, race, opponent_race from build_order")

    result
      -> Pg.Result.rows
      -> Array.map(StoredBuildOrder.Info.toBuildOrderInfo)
      -> Ok
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let getBuildOrderSteps= async (id: Id.t): array<BuildOrder.Step.t> => {
  try {
    let result: Pg.Result.t<StoredBuildOrder.Step.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from build_order_step WHERE build_order = $1", (id))
    result -> Pg.Result.rows -> Array.map(StoredBuildOrder.Step.toBuildOrderStep)
  } catch {
    | _ => []
  }
}

let getBuildOrderTags = async (id: Id.t): array<Id.t> => {
  try {
    let result: Pg.Result.t<string> = await Db.client -> Pg.Client.queryWithParam("SELECT tag from build_order_tag WHERE build_order = $1)", (id))
    result -> Pg.Result.rows
  } catch {
    | _ => []
  }
}

let find = async (id: Id.t): result<BuildOrder.t, AppError.t> => {
  try {
    let boList: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam("SELECT * from build_order WHERE id = $1", (id))

    switch boList -> Pg.Result.rows -> Array.get(0) {
      | Some(value) => {
        let steps = await getBuildOrderSteps(id)
        let tags = await getBuildOrderTags(id)

        Ok({
          id: value.id,
          name: value.name,
          creator: value.creator,
          race: value.race,
          opponentRace: value.opponent_race,
          description: value.description -> Nullable.toOption,
          steps,
          tags,
          links: [],
        })
      }
      | None => Error(AppError.EntityDoesNotExist)
    }
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let create = async (buildOrder: BuildOrderSchema.payload, creator: Id.t) => {
  try {
    let _ = await Db.client -> Pg.Client.query("BEGIN")

    let result: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam5(
      "INSERT INTO build_order (name, description, creator, race, opponent_race) VALUES($1, $2, $3, $4, $5)",
      (buildOrder.name, buildOrder.name, creator, buildOrder.race, buildOrder.opponentRace)
    )

    let bo = result -> Pg.Result.rows -> Array.getUnsafe(0)

    buildOrder.steps -> Array.forEach((step) => {
      let (unit, building, upgrade) = StoredBuildOrder.Step.getStoredElement(step.element)

      Db.client -> Pg.Client.queryWithParam7(
        "INSERT INTO build_order_step (build_order, unit, building, upgrade, is_removable, is_canceled, supply_limit_up_by)",
        (bo.id, unit, building, upgrade, step.isRemovable, step.isCanceled, step.supplyLimitUpBy)
      ) -> ignore
    })

    buildOrder.links -> Array.forEach((link) => {
      Db.client -> Pg.Client.queryWithParam2(
        "INSERT INTO build_order_link (build_order, link)",
        (bo.id, link)
      ) -> ignore
    })

    buildOrder.tags -> Array.forEach((tag) => {
      Db.client -> Pg.Client.queryWithParam2(
        "INSERT INTO build_order_link (build_order, tag)",
        (bo.id, tag)
      ) -> ignore
    })
    
    let _ = await Db.client -> Pg.Client.query("COMMIT")
    Ok()
  } catch {
    | _ => Error(AppError.OperationHasFailed)
  }
}

let update = async (buildOrder: BuildOrderSchema.payload, ~id: Id.t, ~creator: Id.t) => {
  try {
    let oldBoRows: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam("SELECT FROM build_order WHERE id = $1", (id))

    if oldBoRows -> Pg.Result.rowCount -> Nullable.getOr(0) ===  1 {
      let oldBo = oldBoRows -> Pg.Result.rows -> Array.getUnsafe(0)

      if oldBo.creator === creator {
        let _ = await Db.client -> Pg.Client.query("BEGIN")
        let _: Pg.Result.t<unit> = await Db.client -> Pg.Client.queryWithParam("DELETE FROM build_order WHERE id = $1", (id))

        let result: Pg.Result.t<StoredBuildOrder.t> = await Db.client -> Pg.Client.queryWithParam5(
          "INSERT INTO build_order (name, description, creator, race, opponent_race) VALUES($1, $2, $3, $4, $5)",
          (buildOrder.name, buildOrder.name, oldBo.creator, buildOrder.race, buildOrder.opponentRace)
        )

        let bo = result -> Pg.Result.rows -> Array.getUnsafe(0)

        buildOrder.steps -> Array.forEach((step) => {
          let (unit, building, upgrade) = StoredBuildOrder.Step.getStoredElement(step.element)

          Db.client -> Pg.Client.queryWithParam7(
            "INSERT INTO build_order_step (build_order, unit, building, upgrade, is_removable, is_canceled, supply_limit_up_by)",
            (bo.id, unit, building, upgrade, step.isRemovable, step.isCanceled, step.supplyLimitUpBy)
          ) -> ignore
        })

        buildOrder.links -> Array.forEach((link) => {
          Db.client -> Pg.Client.queryWithParam2(
            "INSERT INTO build_order_link (build_order, link)",
            (bo.id, link)
          ) -> ignore
        })

        buildOrder.tags -> Array.forEach((tag) => {
          Db.client -> Pg.Client.queryWithParam2(
            "INSERT INTO build_order_link (build_order, tag)",
            (bo.id, tag)
          ) -> ignore
        })
        
        let _ = await Db.client -> Pg.Client.query("COMMIT")
        Ok()
      } else {
        Error(AppError.Forbidden)
      }
    } else {
      Error(AppError.EntityDoesNotExist)
    }
  } catch {
    | _ => {
      let _ = await Db.client -> Pg.Client.query("ROLLBACK")
      Error(AppError.OperationHasFailed)
    }
  }
}
