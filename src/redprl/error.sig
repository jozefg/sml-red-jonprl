(* Redprl, like all programming languages implementations, often must construct
 * errors which intersperse prose description of the errors and terms themselves.
 * This module simplifies the process by creating a type representing a fragment
 * of an error message [frag].
 *
 * To use this, build up a list of terms and prose as a list of fragments and
 * bundle them into a native SML exception using [error]. Upon catching an
 * exception at the top level, [format] will ensure that if it was created
 * by [error] that it is printed is set into a nice string for printing. If
 * the exception you feed to [format] was generated from something else, [format]
 * will use [exnMessage] to create some sort of descriptive message from it.
 *)
signature REDPRL_ERROR =
sig
  datatype 'a frag =
     % of string
   | ! of 'a

  type term

  val error : term frag list -> exn
  val format : exn -> string

  val annotate : Pos.t option -> exn -> exn
  val annotation : exn -> Pos.t option
end
