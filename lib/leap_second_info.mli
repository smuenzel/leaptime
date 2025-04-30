open! Core

type t =
  { date : Date.t
  ; timestamp : Time_ns.Alternate_sexp.t
  ; tai_minus_utc : int
  } [@@deriving sexp]

val expiry_date : Date.t

val table : t array
