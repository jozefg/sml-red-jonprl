(* Since RedPRL is written in SML it also includes implementations of fun things
 * like a simple logging utility because there are no libraries! The rough
 * hierarchy of priorities for log messages is
 *
 *     TRACE < DUMP < INFO < WARN < FAIL
 *
 *  as a general rule, nothing that the user needs to care about
 * should be reported below [INFO] as we may eventually filter these
 * out in release builds.
 *
 * jozefg: eventually we should just split this out into a higher
 * quality satellite library. It would be a good project for someone
 * just getting started.
 *)

signature REDPRL_LOG =
sig
  datatype level =
     INFO
   | WARN
   | DUMP
   | FAIL
   | TRACE

  val print : level -> Pos.t option * string -> unit
end

signature REDPRL_LOG_UTIL =
sig
  include REDPRL_LOG

  (* Warning, trace currently does nothing. Don't use trace. *)
  val trace : string -> unit
end
