type t

type config = {
  encoding?: string, // sets encoding for the incoming form fields. Defaults to utf8
  maxFieldsSize?: string, // Limits the amount of memory all fields (not files) can allocate in bytes. If this value is exceeded, an error event is emitted. The default size is 2MB.
  maxFields?: int, // Limits the number of fields that will be parsed before emitting an error event. A file counts as a field in this case. Defaults to 1000.
  maxFilesSize?: string, // Only relevant when autoFiles is true. Limits the total bytes accepted for all files combined. If this value is exceeded, an error event is emitted. The default is Infinity.
  autoFields?: bool, // Enables field events and disables part events for fields. This is automatically set to true if you add a field listener.
  autoFiles?: bool, // Enables file events and disables part events for files. This is automatically set to true if you add a file listener.
  uploadDir?: string, // Only relevant when autoFiles is true. The directory for placing file uploads in. You can move them later using fs.rename(). Defaults to os.tmpdir().
}

@module("multiparty")
@scope("default")
@new
external make: unit => t = "Form"

@module("multiparty")
@scope("default")
@new
external makeWithConfig: config => t = "Form"

type err = {
  statusCode: int,
}

type file = {
  fieldName: string, // same as name - the field name for this file
  originalFilename: string, // - the filename that the user reports for the file
  path: string, // - the absolute path of the uploaded file on disk
  headers: string, // - the HTTP headers that were sent along with this file
  size: string, // - size of the file in bytes
}

type callback = (~err: Nullable.t<err>, ~fields: dict<array<string>>, ~files: dict<array<file>>) => unit

@send
external parse: (t, Express.req, callback) => unit = "parse"

type asyncResult = {
  fields: dict<array<string>>,
  files: dict<array<file>>,
}

let parseAsync = (instance: t, req: Express.req) => {
  Promise.make((resolve, reject) => {
    instance -> parse(req, (~err, ~fields, ~files) => {
      switch err -> Nullable.toOption {
        | Some(value) => reject(value)
        | None => resolve({
          fields: fields,
          files: files,
        })
      }
    })
  })
}
