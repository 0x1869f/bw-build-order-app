open GameMap.New

let schema = S.object(s => {
  name: s.field("name", S.string),
})
