type error =
  | EntityDoesNotExist
  | OperationHasFailed
  | Forbidden
  | IncorrectData
  | Conflict

type t<'value> = 
  | Ok('value)
  | Success
  | Created('value)
  | Error(error)

