
type t = Bigdecimal.t [@@deriving sexp, bin_io, compare, equal]

let whole_days t =
  Bigdecimal.round_to_bigint ~dir:`Zero t
  |> Bigint.to_int_exn

let fractional_days_precise t =
  Bigdecimal.(-) t (Bigdecimal.round ~dir:`Zero t)

let fractional_days t =
  Bigdecimal.to_float (fractional_days_precise t)

let of_bigdecimal t = t
let to_bigdecimal t = t

let of_string s = Bigdecimal.of_string s
let to_string t = Bigdecimal.to_string_no_sn t
