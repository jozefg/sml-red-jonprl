(* The elaboration monad contains the context and utilities necessary to
 * perform elaboration. This includes various wrappers for printing out
 * warnings during the course of elaboration as well as the ability to
 * silence messages in an elaboration subcomputation.
 *
 * This monad is best throught of as lazily building up a computation which
 * generates various messages before finally resulting in
 *)
signature ELAB_MONAD =
sig
  include MONAD_UTIL

  type 'a ann = Pos.t option * 'a

  val delay : (unit -> 'a t) -> 'a t
  val wrap : (unit -> 'a) ann -> 'a t

  val hush : 'a t -> 'a t
  val warn : string ann -> unit t
  val dump : string ann -> unit t
  val info : string ann -> unit t
  val fail : string ann -> 'a t

  type ('a, 'b) alg =
    {warn : string ann * 'b -> 'b,
     dump : string ann * 'b -> 'b,
     info : string ann * 'b -> 'b,
     init : 'b,
     fail : string ann * 'b -> 'b,
     succeed : 'a * 'b -> 'b}

  val fold : ('a, 'b) alg -> 'a t -> 'b
end

signature ELAB_MONAD_UTIL =
sig
  include ELAB_MONAD

  val run : 'a t -> 'a option
end
