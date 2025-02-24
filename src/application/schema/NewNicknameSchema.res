type payload = {
 nickname: string,
}

let schema = S.object(s => {
  nickname: s.field("nickname", S.string -> S.stringMaxLength(15) -> S.stringMinLength(3)),
})
