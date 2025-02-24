let toAppState = (exn: Exn.t) => {
  let err = exn -> Pg.Error.fromExn
  switch err.code {
    | Pg.Error.UniqueViolation => State.Error(State.Conflict)
    | _ => State.Error(State.OperationHasFailed)
  }
}
