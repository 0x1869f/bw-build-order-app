open Express

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

let _ = app->listenWithCallback(port, _ => {
  Js.Console.log(`Listening on ${port -> Belt.Int.toString}`)
})

Process.process -> Process.Events.onBeforeExit((_) => {
  Db.client -> Pg.Client.end -> ignore
}) -> ignore
