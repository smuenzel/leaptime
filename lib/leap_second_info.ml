open! Core

(*$
  open! Core
  open Leaptime_generator

  let elements =
    Angstrom.parse_string
      ~consume:All
      Parse.File.parse
      (In_channel.read_all "../reference/Leap_Second.dat")
    |> Result.ok_or_failwith
*)(*$*)

type t =
  { date : Date.t
  ; timestamp : Time_ns.Alternate_sexp.t
  ; tai_minus_utc : int
  } [@@deriving sexp]

let expiry_date : Date.t =
  (*$
    List.iter elements
      ~f:(function
          | Expiration date ->
            Printf.printf "\n  Date.create_exn ~y:%i ~m:%s ~d:%i\n"
              (Date.year date)
              (Month.to_string (Date.month date))
              (Date.day date)
          | _ -> ())
  *)
  Date.create_exn ~y:2025 ~m:Dec ~d:28
(*$*)

let table : t array =
  [|
(*$
  let () =
    print_endline "";
    List.iter elements
      ~f:(function
          | Line { day; month; year; tai_utc_offset; _} ->
            let month = Month.of_int_exn month in
            let date = Date.create_exn ~y:year ~m:month ~d:day in
            Printf.printf
              "  { date = Date.create_exn ~y:%i ~m:%s ~d:%i\n"
              year
              (Month.to_string month)
              day
            ;
            Printf.printf
              "  ; timestamp = Time_ns.of_int_ns_since_epoch %i\n"
              (Time_ns.Utc.of_date_and_span_since_start_of_day date Time_ns.Span.zero
              |> Time_ns.to_int_ns_since_epoch)
            ;
            Printf.printf "  ; tai_minus_utc = %i };\n" tai_utc_offset
          | _ -> ())
*)
  { date = Date.create_exn ~y:1972 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 63072000000000000
  ; tai_minus_utc = 10 };
  { date = Date.create_exn ~y:1972 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 78796800000000000
  ; tai_minus_utc = 11 };
  { date = Date.create_exn ~y:1973 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 94694400000000000
  ; tai_minus_utc = 12 };
  { date = Date.create_exn ~y:1974 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 126230400000000000
  ; tai_minus_utc = 13 };
  { date = Date.create_exn ~y:1975 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 157766400000000000
  ; tai_minus_utc = 14 };
  { date = Date.create_exn ~y:1976 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 189302400000000000
  ; tai_minus_utc = 15 };
  { date = Date.create_exn ~y:1977 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 220924800000000000
  ; tai_minus_utc = 16 };
  { date = Date.create_exn ~y:1978 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 252460800000000000
  ; tai_minus_utc = 17 };
  { date = Date.create_exn ~y:1979 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 283996800000000000
  ; tai_minus_utc = 18 };
  { date = Date.create_exn ~y:1980 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 315532800000000000
  ; tai_minus_utc = 19 };
  { date = Date.create_exn ~y:1981 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 362793600000000000
  ; tai_minus_utc = 20 };
  { date = Date.create_exn ~y:1982 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 394329600000000000
  ; tai_minus_utc = 21 };
  { date = Date.create_exn ~y:1983 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 425865600000000000
  ; tai_minus_utc = 22 };
  { date = Date.create_exn ~y:1985 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 489024000000000000
  ; tai_minus_utc = 23 };
  { date = Date.create_exn ~y:1988 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 567993600000000000
  ; tai_minus_utc = 24 };
  { date = Date.create_exn ~y:1990 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 631152000000000000
  ; tai_minus_utc = 25 };
  { date = Date.create_exn ~y:1991 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 662688000000000000
  ; tai_minus_utc = 26 };
  { date = Date.create_exn ~y:1992 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 709948800000000000
  ; tai_minus_utc = 27 };
  { date = Date.create_exn ~y:1993 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 741484800000000000
  ; tai_minus_utc = 28 };
  { date = Date.create_exn ~y:1994 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 773020800000000000
  ; tai_minus_utc = 29 };
  { date = Date.create_exn ~y:1996 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 820454400000000000
  ; tai_minus_utc = 30 };
  { date = Date.create_exn ~y:1997 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 867715200000000000
  ; tai_minus_utc = 31 };
  { date = Date.create_exn ~y:1999 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 915148800000000000
  ; tai_minus_utc = 32 };
  { date = Date.create_exn ~y:2006 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 1136073600000000000
  ; tai_minus_utc = 33 };
  { date = Date.create_exn ~y:2009 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 1230768000000000000
  ; tai_minus_utc = 34 };
  { date = Date.create_exn ~y:2012 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 1341100800000000000
  ; tai_minus_utc = 35 };
  { date = Date.create_exn ~y:2015 ~m:Jul ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 1435708800000000000
  ; tai_minus_utc = 36 };
  { date = Date.create_exn ~y:2017 ~m:Jan ~d:1
  ; timestamp = Time_ns.of_int_ns_since_epoch 1483228800000000000
  ; tai_minus_utc = 37 };
(*$*)
  |]
