
module type S = sig
  type t [@@deriving sexp, bin_io, compare, equal]

  val whole_days : t -> int
  val fractional_days : t -> float
  val fractional_days_precise : t -> Bigdecimal.t

  val of_bigdecimal : Bigdecimal.t -> t
  val to_bigdecimal : t -> Bigdecimal.t
end
