signature MINI_SIGNATURE =
sig
  type metavar = RedPrlAbt.metavariable
  type symbol = RedPrlAbt.symbol
  type opid = RedPrlAbt.symbol
  type abt = RedPrlAbt.abt
  type valence = RedPrlAbt.valence
  type sort = RedPrlAbt.sort
  type psort = RedPrlAbt.psort
  type src_opid = string
  type jdg = RedPrlJudgment.jdg

  type 'a arguments = ('a * valence) list
  type 'a params = ('a * psort) list

  type sign
  type entry =
    {sourceOpid : src_opid,
     params : symbol params,
     arguments : metavar arguments,
     sort : sort,
     spec : jdg option,
     state : Lcf.jdg Lcf.state}

  val lookup : sign -> opid -> entry

  val unifyCustomOperator : entry -> RedPrlAbt.param list -> abt RedPrlAbt.bview list -> RedPrlAbt.metaenv * RedPrlAbt.symenv
  val resuscitateTheorem : sign -> opid -> RedPrlAbt.param list -> abt RedPrlAbt.bview list -> jdg * Lcf.jdg Lcf.state
  val extract : Lcf.jdg Lcf.state -> abt
end

(* Signatures are the central structure in a redprl development: a file defines
 * a signature and the process of checking a proof is equivalent to simply
 * checking a signature.
 *
 * A signature is best thought of as a telescope of declarations
 * interspersed with commands. Accordingly, the main operations on a signature
 * are to add new declarations or commands or look up a previously entered item.
 *
 * There is also a massive [check] function which can be used to check the
 * validity of the entire signature. The overall execution of RedPRL may be
 * summarized as
 *
 *  - Parse the incoming signature from the file.
 *  - Loop over it and gradually insert it into the "main signature".
 *  - Run check on the signature to ensure that it is well-formed.
 *)
signature SIGNATURE =
sig
  type ast = RedPrlAst.ast

  include MINI_SIGNATURE

  type src_catjdg = ast RedPrlCategoricalJudgment.jdg
  type src_seqhyp = string * src_catjdg
  type src_sequent = src_seqhyp list * src_catjdg
  type src_genjdg = (string * psort) list * src_sequent
  type src_rulespec = src_genjdg list * src_sequent

  datatype src_decl =
     DEF of {arguments : string arguments, params : string params, sort : sort, definiens : ast}
   | THM of {arguments : string arguments, params : string params, goal : src_sequent, script : ast}
   | RULE of {arguments : string arguments, params : string params, spec : src_rulespec, script : ast}
   | TAC of {arguments : string arguments, params : string params, script : ast}

  datatype 'opid cmd =
     PRINT of 'opid
   | EXTRACT of 'opid

  type src_cmd = src_opid cmd

  datatype src_elt =
     DECL of string * src_decl * Pos.t
   | CMD of src_cmd * Pos.t

  val empty : sign
  val insert : sign -> src_opid -> src_decl * Pos.t option -> sign
  val command : sign -> src_opid cmd * Pos.t -> sign

  val check : sign -> bool
  val toString : sign -> string
end
