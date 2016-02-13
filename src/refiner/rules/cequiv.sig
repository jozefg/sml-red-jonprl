signature CEQUIV_RULES =
sig
  val TypeEq
    : RefinerKit.ntactic

  val CStep
    : AbtSignature.sign
    -> int
    -> RefinerKit.ntactic

  val CSym
    : RefinerKit.ntactic

  val CEval
    : AbtSignature.sign
    -> RefinerKit.ntactic

end