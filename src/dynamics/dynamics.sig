signature DYNAMICS =
sig
  structure SmallStep : SMALL_STEP
  structure Signature : ABT_SIGNATURE

  type abt = Signature.Abt.abt
  type abs = Signature.Abt.abs
  type 'a step = 'a SmallStep.t
  type sign = Signature.sign
  type 'a metaenv = 'a Signature.Abt.MetaCtx.dict
  type 'a varenv = 'a Signature.Abt.VarCtx.dict

  datatype 'a closure = <: of 'a * (abs closure metaenv * abt closure varenv)

  val step : sign -> abt closure -> abt closure step
  exception Stuck of abt closure
end
