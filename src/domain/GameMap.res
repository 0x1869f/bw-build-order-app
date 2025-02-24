module New = {
  type t = {
    name: string,
  }
}

type t = {
  ...New.t,
  image: option<string>,
  id: Id.t,
}
