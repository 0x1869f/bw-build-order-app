type t

@val external process: t = "process"

module Events = {
  @send external onBeforeExit: (t, @as("beforeExit") _, @uncurry (int => unit)) => t = "on"
}
