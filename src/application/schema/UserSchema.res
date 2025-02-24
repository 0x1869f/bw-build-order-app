type userPayload = {
  login: string,
  nickname: string,
  role: User.role,
  password: string,
}

let schema = S.object(s => {
  login: s.field("login", S.string),
  nickname: s.field("nickname", S.string),
  password: s.field("password", S.string),
  role: s.field(
    "role",
    S.enum([
      User.Root,
      User.Admin,
      User.User,
    ])
  ),

})
