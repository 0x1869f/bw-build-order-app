type error =
  | EntityDoesNotExist
  | OperationHasFailed
  | Forbidden
  | IncorrectData
  | Conflict

type t<'value> = 
  | Ok('value)
  | Created('value)
  | NoValue
  | Error(error)

