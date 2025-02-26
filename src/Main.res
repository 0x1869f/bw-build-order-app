open Express

module Https = {
  module Server = {
    type t

    @send
    external listen: (t, int, ~callback: unit => unit) => t = "listen"
  }

  type options = {
      key: string,
      cert: string,
  }

  @module("node:https")
  external make: (options, Express.express) => Server.t = "createServer"
}

let port = 8080

let app = express()

app -> use(urlencodedMiddlewareWithOptions({
  "extended": true
}))
app -> use(Express.cors("*"))

app -> Express.useRouterWithPath("/root", RootRouter.router)
app -> Express.useRouterWithPath("/admin", AdminRouter.router)
app -> Express.useRouterWithPath("/admin-static", AdminStaticRouter.router)
app -> Express.useRouterWithPath("/user", UserRouter.router)
app -> Express.useRouterWithPath("/", UnauthorizedRouter.router)

Db.client -> Pg.Client.connect -> ignore

switch Env.mode {
  | Prod => {
    let httpsServer = Https.make({
      key: NodeJs.Fs.readFileSync(`${Env.certDir -> Option.getOr("")}/privkey.pem`) -> NodeJs.Buffer.toString,
      cert: NodeJs.Fs.readFileSync(`${Env.certDir -> Option.getOr("")}/fullchain.pem`) -> NodeJs.Buffer.toString,
    }, app)
    
    let _ = httpsServer -> Https.Server.listen(port, ~callback=() => {
      Js.Console.log(`Listening on ${port -> Belt.Int.toString}`)
    })
  }
  | Dev => {
    let _ = app->listenWithCallback(port, _ => {
      Js.Console.log(`Listening on ${port -> Belt.Int.toString}`)
    })
  }
}

Process.process -> Process.Events.onBeforeExit((_) => {
  Db.client -> Pg.Client.end -> ignore
}) -> ignore
