type pgTypes = 
| @as(16) BOOL
| @as(17) BYTEA
| @as(18) CHAR
| @as(20) INT8
| @as(21) INT2
| @as(23) INT4
| @as(24) REGPROC
| @as(25) TEXT
| @as(26) OID
| @as(27) TID
| @as(28) XID
| @as(29) CID
| @as(114) JSON
| @as(142) XML
| @as(194) PG_NODE_TREE
| @as(210) SMGR
| @as(602) PATH
| @as(604) POLYGON
| @as(650) CIDR
| @as(700) FLOAT4
| @as(701) FLOAT8
| @as(702) ABSTIME
| @as(703) RELTIME
| @as(704) TINTERVAL
| @as(718) CIRCLE
| @as(774) MACADDR8
| @as(790) MONEY
| @as(829) MACADDR
| @as(869) INET
| @as(1033) ACLITEM
| @as(1042) BPCHAR
| @as(1043) VARCHAR
| @as(1082) DATE
| @as(1083) TIME
| @as(1114) TIMESTAMP
| @as(1184) TIMESTAMPTZ
| @as(1186) INTERVAL
| @as(1266) TIMETZ
| @as(1560) BIT
| @as(1562) VARBIT
| @as(1700) NUMERIC
| @as(1790) REFCURSOR
| @as(2202) REGPROCEDURE
| @as(2203) REGOPER
| @as(2204) REGOPERATOR
| @as(2205) REGCLASS
| @as(2206) REGTYPE
| @as(2950) UUID
| @as(2970) TXID_SNAPSHOT
| @as(3220) PG_LSN
| @as(3361) PG_NDISTINCT
| @as(3402) PG_DEPENDENCIES
| @as(3614) TSVECTOR
| @as(3615) TSQUERY
| @as(3642) GTSVECTOR
| @as(3734) REGCONFIG
| @as(3769) REGDICTIONARY
| @as(3802) JSONB
| @as(4089) REGNAMESPACE
| @as(4096) REGROLE

@unboxed type parserValue = String(string) | Buffer(NodeJs.Buffer.t)

type getTypeParser<'a> = (pgTypes) => (parserValue) => 'a

@unboxed type queryParam = String(string) | Int(int) | Bool(bool) | Null | Buffer(NodeJs.Buffer.t) | Date(Date.t)

type queryConfig<'a> = {
  text: string,
  // an array of query parameters
  values?: array<queryParam>,
  // name of the query - used for prepared statements
  name?: string,
  // by default rows come out as a key/value pair for each row
  // pass the string 'array' here to receive rows as an array of values
  rowMode?: string,
  // custom type parsers just for this query result
  types?: option<getTypeParser<'a>>,
  // TODO: document
  queryMode?: string,
}


module Result = {
  type t<'a>

  type commandType = | @as("INSERT") Insert | @as("UPDATE") Update | @as("CREATE") Create | @as("SELECT") Select

  @get external rows: t<'a> => array<'a> = "rows"
  @get external rowCount: t<'a> => Nullable.t<int> = "rowCount"
  @get external command: t<'a> => commandType = "comamnd"
}

module Client = {
  // type config<'a> = {
  type config = {
    user?: string, // default process.env.PGUSER || process.env.USER
    password?: string, // or function, default process.env.PGPASSWORD
    host?: string, // default process.env.PGHOST
    port?: int, // default process.env.PGPORT
    database?: string, // default process.env.PGDATABASE || user
    connectionString?: string, // e.g. postgres://user:password@host:5432/database
    // ssl?: any, // passed directly to node.TLSSocket, supports all tls.connect options
    // types?: getTypeParser<'a>, // custom type parsers
    statement_timeout?: int, // number of milliseconds before a statement in query will time out, default is no timeout
    query_timeout?: int, // number of milliseconds before a query call will timeout, default is no timeout
    lock_timeout?: int, // number of milliseconds a query is allowed to be en lock state before it's cancelled due to lock timeout
    application_name?: string, // The name of the application that created this Client instance
    connectionTimeoutMillis?: int, // number of milliseconds to wait for connection, default is no timeout
    idle_in_transaction_session_timeout?: int // number of milliseconds before terminating any session with an open idle transaction, default is no timeout
  }

  type t

  @module("pg") @scope("default") @new
  external make: config => t = "Client"

  @send external query: (t, string) => promise<Result.t<'b>> = "query" 
  @send external queryWithParam: (t, string, ('a)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam2: (t, string, ('a, 'b)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam3: (t, string, ('a, 'b, 'c)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam4: (t, string, ('a, 'b, 'c, 'd)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam5: (t, string, ('a, 'b, 'c, 'd, 'e)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam6: (t, string, ('a, 'b, 'c, 'd, 'e, 'f)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam7: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam8: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam9: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam10: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i, 'j)) => promise<Result.t<'x>> = "query" 
  @send external queryWithParam11: (t, string, ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i, 'j, 'k)) => promise<Result.t<'x>> = "query" 

  @send external queryWithConfig: (t, queryConfig<'a>) => promise<Result.t<'b>> = "query"

  @send external release: t => unit = "release"
  @send external connect: t => promise<unit> = "connect"
  @send external end: t => promise<unit> = "end"
}

module Pool = {
  // type config<'a> = {
  type config = {
    // all valid client config options are also valid here
    // in addition here are the pool specific configuration parameters:
   
    // int of milliseconds to wait before timing out when connecting a new client
    // by default this is 0 which means no timeout
    connectionTimeoutMillis?: int,
   
    // int of milliseconds a client must sit idle in the pool and not be checked out
    // before it is disconnected from the backend and discarded
    // default is 10000 (10 seconds) - set to 0 to disable auto-disconnection of idle clients
    idleTimeoutMillis?: int,
   
    // maximum int of clients the pool should contain
    // by default this is set to 10.
    max?: int,
   
    // Default behavior is the pool will keep clients open & connected to the backend
    // until idleTimeoutMillis expire for each client and node will maintain a ref
    // to the socket on the client, keeping the event loop alive until all clients are closed
    // after being idle or the pool is manually shutdown with `pool.end()`.
    //
    // Setting `allowExitOnIdle: true` in the config will allow the node event loop to exit
    // as soon as all clients in the pool are idle, even if their socket is still open
    // to the postgres server.  This can be handy in scripts & tests
    // where you don't want to wait for your clients to go idle before your process exits.

    allowExitOnIdle?: bool,
    user?: string, // default process.env.PGUSER || process.env.USER
    password?: string, // or function, default process.env.PGPASSWORD
    host?: string, // default process.env.PGHOST
    port?: int, // default process.env.PGPORT
    database?: string, // default process.env.PGDATABASE || user
    connectionString?: string, // e.g. postgres://user:password@host:5432/database
    // ssl?: any, // passed directly to node.TLSSocket, supports all tls.connect options
    // types?: getTypeParser<'a>, // custom type parsers
    statement_timeout?: int, // number of milliseconds before a statement in query will time out, default is no timeout
    query_timeout?: int, // number of milliseconds before a query call will timeout, default is no timeout
    lock_timeout?: int, // number of milliseconds a query is allowed to be en lock state before it's cancelled due to lock timeout
    application_name?: string, // The name of the application that created this Client instance
    idle_in_transaction_session_timeout?: int // number of milliseconds before terminating any session with an open idle transaction, default is no timeout
  }

  type t

  @module("pg")
  @new external make: config => t = "Pool"

  @send external query: (t, string) => promise<Result.t<'b>> = "query" 
  @send external queryWithParams: (t, string, array<queryParam>) => promise<Result.t<'b>> = "query" 
  @send external queryWithConfig: (t, queryConfig<'a>) => promise<Result.t<'b>> = "query"
}
