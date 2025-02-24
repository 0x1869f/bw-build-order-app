type payload = {
  oldPassword: string,
  newPassword: string,
}

let schema = S.object(s => {
  oldPassword: s.field("oldPassword", S.string),
  newPassword: s.field("newPassword", S.string),
})
