type verifycationError = {
  name: string,
  message: string, 
  expiredAt: int
}

type signOptions = {
  algorithm?: string,
  /*expressed in seconds or a string describing a time span vercel/ms.
     Eg: 60, "2 days", "10h", "7d". A numeric value is interpreted as a seconds count. If you use a string be sure you provide the time units (days, hours, etc), otherwise milliseconds unit is used by default ("120" is equal to "120ms").
    notBefore: expressed in seconds or a string describing a time span vercel/ms.
    Eg: 60, "2 days", "10h", "7d". A numeric value is interpreted as a seconds count. If you use a string be sure you provide the time units (days, hours, etc), otherwise milliseconds unit is used by default ("120" is equal to "120ms").
  */

  expiresIn?: string,
  audience?: string,
  issuer?: string,
  jwtid?: string,
  subject?: string,
  noTimestamp?: string,
  header?: string,
  keyid?: string,
  /* if true, the sign function will modify the payload object directly.
    This is useful if you need a raw reference to the payload after claims have been applied to it but before it has been encoded into a token.
  */
  mutatePayload?: bool,
  /* if true allows private keys with a modulus below 2048 to be used for RSA */
  allowInsecureKeySizes?: bool,
  allowInvalidAsymmetricKeyTypes?: bool, 
}

type verifyOptions = {
  /* List of strings with the names of the allowed algorithms. For instance, ["HS256", "HS384"].
      If not specified a defaults will be used based on the type of key provided
          secret - ['HS256', 'HS384', 'HS512']
          rsa - ['RS256', 'RS384', 'RS512']
          ec - ['ES256', 'ES384', 'ES512']
          default - ['RS256', 'RS384', 'RS512']
  */
  algorithms?: string,
  /* if you want to check audience (aud), provide a value here.
    The audience can be checked against a string, a regular expression or a list of strings and/or regular expressions.
    Eg: "urn:foo", /urn:f[o]{2}/, [/urn:f[o]{2}/, "urn:bar"]
  */
  audience?: string,
  complete?: bool, // return an object with the decoded { payload, header, signature } instead of only the usual content of the payload.
  issuer?: string, // string or array of strings of valid values for the iss field.
  jwtid?: string, // if you want to check JWT ID (jti), provide a string value here.
  ignoreExpiration?: bool, //if true do not validate the expiration of the token.
  ignoreNotBefore?: bool,
  subject?: string, // if you want to check subject (sub), provide a value here
  clockTolerance?: int, // number of seconds to tolerate when checking the nbf and exp claims, to deal with small clock differences among different servers
  /* the maximum allowed age for tokens to still be valid. It is expressed in seconds or a string describing a time span vercel/ms.
    Eg: 1000, "2 days", "10h", "7d". A numeric value is interpreted as a seconds count. If you use a string be sure you provide the time units (days, hours, etc), otherwise milliseconds unit is used by default ("120" is equal to "120ms").
  */
  maxAge?: string,
  clockTimestamp?: string, // the time in seconds that should be used as the current time for all necessary comparisons.
  nonce?: string, // if you want to check nonce claim, provide a string value here. It is used on Open ID for the ID Tokens. (Open ID implementation notes)
  /* if true, allows asymmetric keys which do not match the specified algorithm.
    This option is intended only for backwards compatability and should be avoided.
  */
  allowInvalidAsymmetricKeyTypes?: bool,
}

@module("jsonwebtoken") @scope("default")
external sign: ('a, ~privateKey: string, ~signOptions: signOptions=?) => string = "sign"

@module("jsonwebtoken") @scope("default")
external verify: (string, ~privateKey: string, ~verifyOption: verifyOptions=?) => {..} = "verify"

@module("jsonwebtoken") @scope("default")
external verifyAsync: (string, ~privateKey: string, ~verifyOption: verifyOptions=?, ~callback: (~error: verifycationError, ~value: {..}) => unit) => {..} = "verify"
