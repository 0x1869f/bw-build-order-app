module Hmac = {
  type t = NodeJs.Crypto.Hmac.t
  type digestType = | @as("hex") Hex

  @send
  external stringDigest: (t, digestType) => string = "digest"
}

let generate = (password: string): string => {
  let hmac = NodeJs.Crypto.createHmac("sha512", ~key=Env.salt)
  hmac -> NodeJs.Crypto.Hmac.update(password -> NodeJs.Buffer.fromString)

  hmac -> Hmac.stringDigest(Hex)
}


let validate = (password: string, hash): bool => {
  hash -> String.equal(password -> generate)
}
