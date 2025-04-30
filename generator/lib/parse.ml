open! Core
open! Angstrom

module Angstrom_test = struct
  module type Parseable = sig
    type t [@@deriving sexp]

    val parse : t Angstrom.t
  end

  let expect_test_f (module F : Parseable) s =
    let unconsumed_to_sexp (u : Angstrom.Buffered.unconsumed) =
      [%sexp
        { buf : string = Bigstringaf.substring u.buf ~off:u.off ~len:u.len
        ; off : int = u.off
        ; len : int = u.len
        }]
    in
    let state = Angstrom.Buffered.parse F.parse in
    let state = Angstrom.Buffered.feed state (`String s) in
    let state = Angstrom.Buffered.feed state `Eof in
    let sexp =
      match state with
      | Done (unconsumed, result) ->
        [%sexp
          { unconsumed : Sexp.t = unconsumed_to_sexp unconsumed
          ; result : F.t
          }]
      | Partial _ ->
        Sexp.Atom "Partial"
      | Fail (unconsumed, sl, s) ->
        [%sexp
          { unconsumed : Sexp.t = unconsumed_to_sexp unconsumed
          ; sl : string list = sl
          ; s : string = s
          }]
    in
    print_s sexp

end

let with_decimal =
  let* integer_part = take_while1 Char.is_digit in
  let* _ = char '.' in
  let+ fractional_part = take_while1 Char.is_digit in
  Bigdecimal.of_string (integer_part ^ "." ^ fractional_part)

let integer =
  let+ integer_part = take_while1 Char.is_digit in
  Int.of_string integer_part

let spaces = skip_while (function ' ' | '\t' -> true | _ -> false)

module Comment = struct
  type t = unit [@@deriving sexp]

  let parse =
    let* _ = char '#' in
    let+ _ = skip_while (function '\r' | '\n' -> false | _ -> true) in
    ()
end

module Line = struct
  type t =
    { modified_julian_day : Bigdecimal.t
    ; day : int
    ; month : int
    ; year : int
    ; tai_utc_offset : int
    } [@@deriving sexp]

  let parse =
    let* () = spaces in
    let* modified_julian_day = with_decimal in
    let* () = spaces in
    let* day = integer in
    let* () = spaces in
    let* month = integer in
    let* () = spaces in
    let* year = integer in
    let* () = spaces in
    let* tai_utc_offset = integer in
    let+ () = spaces in
    { modified_julian_day; day; month; year; tai_utc_offset }
end

let%expect_test _ =
  Angstrom_test.expect_test_f (module Line) 
    "    41317.0    1  1 1972       10";
  [%expect {|
    ((unconsumed ((buf "") (off 33) (len 0)))
     (result
      ((modified_julian_day 41317) (day 1) (month 1) (year 1972)
       (tai_utc_offset 10))))
    |}]

module Expiration = struct
  type t = Date.t [@@deriving sexp]

  let parse =
    let* _ = char '#' <?> "start_of_comment" in
    let* () = spaces in
    let* _ = string "File expires on" <?> "expiration_header" in
    let* () = spaces in
    let* day = integer in
    let* () = spaces in
    let* month_name = take_while1 Char.is_alpha <?> "month_name" in
    let* () = spaces in
    let* year = integer in
    let+ () = spaces in
    let month =
      match String.lowercase month_name with
      | "january" -> Month.Jan
      | "february" -> Month.Feb
      | "march" -> Month.Mar
      | "april" -> Month.Apr
      | "may" -> Month.May
      | "june" -> Month.Jun
      | "july" -> Month.Jul
      | "august" -> Month.Aug
      | "september" -> Month.Sep
      | "october" -> Month.Oct
      | "november" -> Month.Nov
      | "december" -> Month.Dec
      | _ -> failwithf "Invalid month: %s" month_name ()
    in
    Date.create_exn
      ~y:year
      ~m:month
      ~d:day

end

let%expect_test _ =
  Angstrom_test.expect_test_f (module Expiration) 
    "#  File expires on 28 December 2025";
  [%expect {| ((unconsumed ((buf "") (off 35) (len 0))) (result 2025-12-28)) |}]


module File = struct
  module Element = struct
    type t = 
      | Expiration of Expiration.t
      | Line of Line.t
    [@@deriving sexp]
  end

  let parse =
    let+ lines =
      sep_by1
        (char '\n')
        (choice
           [ (Expiration.parse >>| fun x -> Some (Element.Expiration x))
           ; (Comment.parse >>| fun _ -> None)
           ; (Line.parse >>| fun x -> Some (Element.Line x))
           ])
    in
    List.filter_opt lines
end
