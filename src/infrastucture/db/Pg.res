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

module Error = {
  type sererity = | @as("Error") Error
  type errorCode =
  //Class 00 — Successful Completion
  | @as("00000") SuccessFullCompletion
  //Class 01 — Warning
  | @as("01000") Warning
  | @as("0100C") DynamicResultSetsReturned
  | @as("01008") ImplicitZeroBitPadding
  | @as("01003") NullValueEliminatedInSetFunction
  | @as("01007") PrivilegeNotGranted
  | @as("01006") PrivilegeNotRevoked
  | @as("01004") StringDataRightTruncation
  | @as("01P01") DeprecatedFeature
  //Class 02 — No Data (this is also a warning class per the SQL standard)
  | @as("02000") NoData
  | @as("02001") NoAdditionalDynamicResultSetsReturned
  //Class 03 — SQL Statement Not Yet Complete
  | @as("03000") SqlStatementNotYetComplete
  //Class 08 — Connection Exception
  | @as("08000") ConnectionException
  | @as("08003") ConnectionDoesNotExist
  | @as("08006") ConnectionFailure
  | @as("08001") SqlClientUnableToEstablishSqlConnection
  | @as("08004") SqlServerRejectedEstablishmentOfSqlConnection
  | @as("08007") TransactionResolutionUnknown
  | @as("08P01") ProtocolViolation
  //Class 09 — Triggered Action Exception
  | @as("09000") TriggeredActionException
  //Class 0A — Feature Not Supported
  | @as("0A000") FeatureNotSupported
  //Class 0B — Invalid Transaction Initiation
  | @as("0B000") InvalidTransactionInitiation
  //Class 0F — Locator Exception
  | @as("0F000") LocatorException
  | @as("0F001") InvalidLocatorSpecification
  //Class 0L — Invalid Grantor
  | @as("0L000") InvalidGrantor
  | @as("0LP01") InvalidGrantOperation
  //Class 0P — Invalid Role Specification
  | @as("0P000") InvalidRoleSpecification
  //Class 0Z — Diagnostics Exception
  | @as("0Z000") DiagnosticsException
  | @as("0Z002") StackedDiagnosticsAccessedWithoutActiveHandler
  //Class 20 — Case Not Found
  | @as("20000") CaseNotFound
  //Class 21 — Cardinality Violation
  | @as("21000") CardinalityViolation
  //Class 22 — Data Exception
  | @as("22000") DataContextion
  | @as("2202E") ArraySubscriptError
  | @as("22021") CharacterNotInRepertoire
  | @as("22008") DatetimeFieldOverflow
  | @as("22012") DivisionByZero
  | @as("22005") ErrorInAssignment
  | @as("2200B") EscapeCharacterConflict
  | @as("22022") IndicatorOverflow
  | @as("22015") IntervalFieldOverflow
  | @as("2201E") InvalidArgumentForLogarithm
  | @as("22014") InvalidArgumentForNtileFunction
  | @as("22016") InvalidArgumentForNthValueFunction
  | @as("2201F") InvalidArgumentForPowerFunction
  | @as("2201G") InvalidArgumentForWidthBucketFunction
  | @as("22018") InvalidCharacterValueForCast
  | @as("22007") InvalidDatetimeFormat
  | @as("22019") InvalidEscapeCharacter
  | @as("2200D") InvalidEscapeOctet
  | @as("22025") InvalidEscapeSequence
  | @as("22P06") NonstandardUseOfEscapeCharacter
  | @as("22010") InvalidIndicatorParameterValue
  | @as("22023") InvalidParameterValue
  | @as("22013") InvalidPrecedingOrFollowingSize
  | @as("2201B") InvalidRegularExpression
  | @as("2201W") InvalidRowCountInLimitClause
  | @as("2201X") InvalidRowCountInResultOffsetClause
  | @as("2202H") InvalidTablesampleArgument
  | @as("2202G") InvalidTablesampleRepeat
  | @as("22009") InvalidTimeZoneDisplacementValue
  | @as("2200C") InvalidUseOfEscapeCharacter
  | @as("2200G") MostSpecificTypeMismatch
  | @as("22004") NullValueNotAllowed
  | @as("22002") NullValueNoIndicatorParameter
  | @as("22003") NumericValueOutOfRange
  | @as("2200H") SequenceGeneratorLimitExceeded
  | @as("22026") StringDataLengthMismatch
  | @as("22001") StringDataRightTruncation2
  | @as("22011") SubstringError
  | @as("22027") TrimError
  | @as("22024") UnterminatedCString
  | @as("2200F") ZeroLengthCharacterString
  | @as("22P01") FloatingPointException
  | @as("22P02") InvalidTextRepresentation
  | @as("22P03") InvalidBinaryRepresentation
  | @as("22P04") BadCopyFileFormat
  | @as("22P05") UntranslatableCharacter
  | @as("2200L") NotAnXmlDocument
  | @as("2200M") InvalidXmlDocument
  | @as("2200N") InvalidXmlContent
  | @as("2200S") InvalidXmlComment
  | @as("2200T") InvalidXmlProcessingInstruction
  | @as("22030") DuplicateJsonValue
  | @as("22031") InvalidArgumentForSqlJsonDatetimeFunction
  | @as("22032") InvalidJsonText
  | @as("22033") InvalidSqlJsonSubscript
  | @as("22034") MoreThanOneSqlJsonItem
  | @as("22035") NoSqlJsonItem
  | @as("22036") NonNumericSqlJsonItem
  | @as("22037") NonUniqueKeysInAJsonObject
  | @as("22038") SingletonSqlJsonItemRequired
  | @as("22039") SqlJsonArrayNotFound
  | @as("2203A") SqlJsonMemberNotFound
  | @as("2203B") SqlJsonNumberNotFound
  | @as("2203C") SqlJsonObjectNotFound
  | @as("2203D") TooManyJsonArrayElements
  | @as("2203E") TooManyJsonObjectMembers
  | @as("2203F") SqlJsonScalarRequired
  | @as("2203G") SqlJsonItemCannotBeCastToTargetType
    //Class 23 — Integrity Constraint Violation
  | @as("23000") IntegrityConstraintViolation
  | @as("23001") RestrictViolation
  | @as("23502") NotNullViolation
  | @as("23503") ForeignKeyViolation
  | @as("23505") UniqueViolation
  | @as("23514") CheckViolation
  | @as("23P01") ExclusionViolation
  //Class 24 — Invalid Cursor State
  | @as("24000") InvalidCursorState
  //Class 25 — Invalid Transaction State
  | @as("25000") InvalidTransactionState
  | @as("25001") ActiveSQLTransaction
  | @as("25002") BranchTransactionAlreadyActive
  | @as("25008") HeldCursorRequiresSameIsolationLevel
  | @as("25003") InappropriateAccessModeForBranchTransaction
  | @as("25004") InappropriateIsolationLevelForBranchTransaction
  | @as("25005") NoActiveSQLTransactionForBranchTransaction
  | @as("25006") ReadOnlySQLTransaction
  | @as("25007") SchemaAndDataStatementMixingNotSupported
  | @as("25P01") NoActiveSQLTransaction
  | @as("25P02") InFailedSQLTransaction
  | @as("25P03") IdleInTransactionSessionTimeout
  | @as("25P04") TransactionTimeout
  //Class 26 — Invalid SQL Statement Name
  | @as("26000") InvalidSQLStatementName
  //Class 27 — Triggered Data Change Violation
  | @as("27000") TriggeredDataChangeViolation
  //Class 28 — Invalid Authorization Specification
  | @as("28000") InvalidAuthorizationSpecification
  | @as("28P01") InvalidPassword
  //Class 2B — Dependent Privilege Descriptors Still Exist
  | @as("2B000") DependentPrivilegeDescriptorsStillExist
  | @as("2BP01") DependentObjectsStillExist
  //Class 2D — Invalid Transaction Termination
  | @as("2D000") InvalidTransactionTermination
  //Class 2F — SQL Routine Exception
  | @as("2F000") SqlRoutineException
  | @as("2F005") FunctionExecutedNoReturnStatement
  | @as("2F002") ModifyingSqlDataNotPermitted
  | @as("2F003") ProhibitedSqlStatementAttempted
  | @as("2F004") ReadingSqlDataNotPermitted
  //Class 34 — Invalid Cursor Name
  | @as("34000") InvalidCursorName
  //Class 38 — External Routine Exception
  | @as("38000") ExternalRoutineException
  | @as("38001") ContainingSqlNotPermitted
  | @as("38002") ModifyingSqlDataNotPermitted2
  | @as("38003") ProhibitedSqlStatementAttempted2
  | @as("38004") ReadingSqlDataNotPermitted2
  //Class 39 — External Routine Invocation Exception
  | @as("39000") ExternalRoutineInvocationException
  | @as("39001") InvalidSqlstateReturned
  | @as("39004") NullValueNotAllowed2
  | @as("39P01") TriggerProtocolViolated
  | @as("39P02") SrfProtocolViolated
  | @as("39P03") EventTriggerProtocolViolated
  //Class 3B — Savepoint Exception
  | @as("3B000") SavepointException
  | @as("3B001") InvalidSavepointSpecification
  //Class 3D — Invalid Catalog Name
  | @as("3D000") InvalidCatalogName
  //Class 3F — Invalid Schema Name
  | @as("3F000") InvalidSchemaName
  //Class 40 — Transaction Rollback
  | @as("40000") TransactionRollback
  | @as("40002") TransactionIntegrityConstraintViolation
  | @as("40001") SerializationFailure
  | @as("40003") StatementCompletionUnknown
  | @as("40P01") DeadlockDetected
  //Class 42 — Syntax Error or Access Rule Violation
  | @as("42000") SyntaxErrorOrAccessRuleViolation
  | @as("42601") SyntaxError
  | @as("42501") InsufficientPrivilege
  | @as("42846") CannotCoerce
  | @as("42803") GroupingError
  | @as("42P20") WindowingError
  | @as("42P19") InvalidRecursion
  | @as("42830") InvalidForeignKey
  | @as("42602") InvalidName
  | @as("42622") NameTooLong
  | @as("42939") ReservedName
  | @as("42804") DatatypeMismatch
  | @as("42P18") IndeterminateDatatype
  | @as("42P21") CollationMismatch
  | @as("42P22") IndeterminateCollation
  | @as("42809") WrongObjectType
  | @as("428C9") GeneratedAlways
  | @as("42703") UndefinedColumn
  | @as("42883") UndefinedFunction
  | @as("42P01") UndefinedTable
  | @as("42P02") UndefinedParameter
  | @as("42704") UndefinedObject
  | @as("42701") DuplicateColumn
  | @as("42P03") DuplicateCursor
  | @as("42P04") DuplicateDatabase
  | @as("42723") DuplicateFunction
  | @as("42P05") DuplicatePreparedStatement
  | @as("42P06") DuplicateSchema
  | @as("42P07") DuplicateTable
  | @as("42712") DuplicateAlias
  | @as("42710") DuplicateObject
  | @as("42702") AmbiguousColumn
  | @as("42725") AmbiguousFunction
  | @as("42P08") AmbiguousParameter
  | @as("42P09") AmbiguousAlias
  | @as("42P10") InvalidColumnReference
  | @as("42611") InvalidColumnDefinition
  | @as("42P11") InvalidCursorDefinition
  | @as("42P12") InvalidDatabaseDefinition
  | @as("42P13") InvalidFunctionDefinition
  | @as("42P14") InvalidPreparedStatementDefinition
  | @as("42P15") InvalidSchemaDefinition
  | @as("42P16") InvalidTableDefinition
  | @as("42P17") InvalidObjectDefinition
  //Class 44 — WITH CHECK OPTION Violation
  | @as("44000") WithCheckOptionViolation
  //Class 53 — Insufficient Resources
  | @as("53000") InsufficientResources
  | @as("53100") DiskFull
  | @as("53200") OutOfMemory
  | @as("53300") TooManyConnections
  | @as("53400") ConfigurationLimitExceeded
  //Class 54 — Program Limit Exceeded
  | @as("54000") ProgramLimitExceeded
  | @as("54001") StatementTooComplex
  | @as("54011") TooManyColumns
  | @as("54023") TooManyArguments
  //Class 55 — Object Not In Prerequisite State
  | @as("55000") ObjectNotInPrerequisiteState
  | @as("55006") ObjectInUse
  | @as("55P02") CantChangeRuntimeParam
  | @as("55P03") LockNotAvailable
  | @as("55P04") UnsafeNewEnumValueUsage
  //Class 57 — Operator Intervention
  | @as("57000") OperatorIntervention
  | @as("57014") QueryCanceled
  | @as("57P01") AdminShutdown
  | @as("57P02") CrashShutdown
  | @as("57P03") CannotConnectNow
  | @as("57P04") DatabaseDropped
  | @as("57P05") IdleSessionTimeout
  //Class 58 — System Error (errors external to PostgreSQL itself)
  | @as("58000") SystemError
  | @as("58030") IoError
  | @as("58P01") UndefinedFile
  | @as("58P02") DuplicateFile
  //Class F0 — Configuration File Error
  | @as("F0000") ConfigFileError
  | @as("F0001") LockFileExists
  //Class HV — Foreign Data Wrapper Error (SQL/MED)
  | @as("HV000") FdwError
  | @as("HV005") FdwColumnNameNotFound
  | @as("HV002") FdwDynamicParameterValueNeeded
  | @as("HV010") FdwFunctionSequenceError
  | @as("HV021") FdwInconsistentDescriptorInformation
  | @as("HV024") FdwInvalidAttributeValue
  | @as("HV007") FdwInvalidColumnName
  | @as("HV008") FdwInvalidColumnNumber
  | @as("HV004") FdwInvalidDataType
  | @as("HV006") FdwInvalidDataTypeDescriptors
  | @as("HV091") FdwInvalidDescriptorFieldIdentifier
  | @as("HV00B") FdwInvalidHandle
  | @as("HV00C") FdwInvalidOptionIndex
  | @as("HV00D") FdwInvalidOptionName
  | @as("HV090") FdwInvalidStringLengthOrBufferLength
  | @as("HV00A") FdwInvalidStringFormat
  | @as("HV009") FdwInvalidUseOfNullPointer
  | @as("HV014") FdwTooManyHandles
  | @as("HV001") FdwOutOfMemory
  | @as("HV00P") FdwNoSchemas
  | @as("HV00J") FdwOptionNameNotFound
  | @as("HV00K") FdwReplyHandle
  | @as("HV00Q") FdwSchemaNotFound
  | @as("HV00R") FdwTableNotFound
  | @as("HV00L") FdwUnableToCreateExecution
  | @as("HV00M") FdwUnableToCreateReply
  | @as("HV00N") FdwUnableToEstablishConnection
  //Class P0 — PL/pgSQL Error
  | @as("P0000") PlpgsqlError
  | @as("P0001") RaiseException
  | @as("P0002") NoDataFound
  | @as("P0003") TooManyRows
  | @as("P0004") AssertFailure
  //Class XX — Internal Error
  | @as("XX000") InternalError
  | @as("XX001") DataCorrupted
  | @as("XX002") IndexCorrupted

  type t = {
    severity: sererity,
    code: errorCode,
    detail: string,
    hint: option<string>,
    position: option<string>,
    // internalPosition: undefined,
    // internalQuery: undefined,
    // where: undefined,
    schema: string,
    table: string,
    column: option<string>,
    // dataType,
    constraint_: option<string>,
    // file: '',
    // line: '',
    // routine: ''
  }

  external fromExn: Exn.t => t = "%identity"
}

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
  @send external queryWithParam: (t, string, (array<'a>)) => promise<Result.t<'x>> = "query" 
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
