type role = | @as(0) Root | @as(1) Admin | @as(2) User

type t = {
  id: string,
  nickname: string,
  role: role,
}
