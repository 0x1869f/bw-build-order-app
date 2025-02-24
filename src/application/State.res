type error =
  | EntityDoesNotExist
  | OperationHasFailed
  | Forbidden
  | IncorrectData
  | Conflict

type t<'value> = 
  | Exists('value)
  | Updated('value)
  | Created('value)
  | ExistsEmpty
  | UpdatedEmpty
  | CreatedEmpty
  | Error(error)

