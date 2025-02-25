let dbUser = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("DB_USER")
  -> Option.getUnsafe

let dbPassword = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("DB_PASSWORD")
  -> Option.getUnsafe

let dbName = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("DB_NAME")
  -> Option.getUnsafe

let dbHost = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("DB_HOST")
  -> Option.getUnsafe

let salt = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("SALT")
  -> Option.getUnsafe

let jwtKey =  NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("JWT_KEY") -> Option.getUnsafe

let staticDir =  NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("STATIC_DIR") -> Option.getUnsafe

let certDir =  NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("CERT_DIR")

type mode = | @as("dev") Dev | @as("prod") Prod
external stringToMode: string => mode = "%identity"

let mode = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("MODE")
  -> Option.getUnsafe 
  -> stringToMode

// dev env
let rootAdmin = NodeJs.Process.process
  -> NodeJs.Process.env
  -> Dict.get("ROOT_ADMIN")

