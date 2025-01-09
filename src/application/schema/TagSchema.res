type payload = {
  name: string
}

let schema = S.object(s => {
  name: s.field("name", S.string),
})
