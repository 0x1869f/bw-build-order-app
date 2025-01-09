type userPayload = {
  login: string,
  password: string,
}

let schema = S.object(s => {
  login: s.field("login", S.string),
  password: s.field("password", S.string),
})
