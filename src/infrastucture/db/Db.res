let config: Pg.Client.config = {
    user: Env.dbUser, // default process.env.PGUSER || process.env.USER
    password: Env.dbPassword, // or function, default process.env.PGPASSWORD
    database: Env.dbName, // default process.env.PGDATABASE || user
}

let client = Pg.Client.make(config)

let connect = () => client -> Pg.Client.connect
