let dbUser = NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("DB_USER") -> Option.getUnsafe
let dbPassword = NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("DB_PASSWORD") -> Option.getUnsafe
let dbName = NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("DB_NAME") -> Option.getUnsafe
let salt = NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("SALT") -> Option.getUnsafe
let jwtKey =  NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("JWT_KEY") -> Option.getUnsafe

// dev env
let rootAdmin = NodeJs.Process.process -> NodeJs.Process.env -> Dict.get("ROOT_ADMIN")

