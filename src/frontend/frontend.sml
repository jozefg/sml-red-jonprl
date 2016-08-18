structure Frontend =
struct
  open Sum
  open AstSignatureDecl

  val paramsToString =
    ListSpine.pretty
      (fn (u, tau) => Symbol.toString u ^ " : " ^ RedPrlAtomicSort.toString tau)
      ","

  val argsToString =
    ListSpine.pretty
      (fn (m, vl) => Metavariable.toString m ^ " : " ^ RedPrlAtomicValence.toString vl)
      ";"

  fun defToString (lbl, {parameters, arguments, definiens, sort}) =
    "Def "
       ^ Symbol.toString lbl
       ^ "[" ^ paramsToString parameters ^ "]"
       ^ "(" ^ argsToString arguments ^ ")"
       ^ " : " ^ RedPrlAtomicSort.toString sort
       ^ " = ["
       ^ RedPrlAbtSyntax.toString definiens
       ^ "].\n"

  fun printDef (lbl, d) =
    print (defToString (lbl, d))

  fun symToString (lbl, tau) =
    "Sym "
       ^ Symbol.toString lbl
       ^ " : "
       ^ RedPrlAtomicSort.toString tau
       ^ ".\n"

  fun printSymDcl (lbl, tau) =
    print (symToString (lbl, tau))


  local
    open AbtSignature
    open AbtSignature.Telescope
  in
    fun signToString sign =
      case ConsView.out sign of
          ConsView.CONS (l, dcl, sign') =>
            ((case dcl of
                 Decl.DEF d => defToString (l, d)
               | Decl.SYM_DECL tau => symToString (l, tau)) ^ signToString sign')
        | ConsView.EMPTY => ""

    fun printSign sign = print (signToString sign)

    fun dumpSignJson sign =
      let
        val json = encode sign
      in
        print (Json.toString json)
      end
  end

  fun processFile fileName =
    let
      val input = TextIO.inputAll (TextIO.openIn fileName)
      val stream = CoordinatedStream.coordinate (fn x => Stream.hd x = #"\n" handle Stream.Empty => false) (Coord.init fileName) (Stream.fromString input)
      val parsed = CharParser.parseChars SignatureParser.parseSigExp stream
    in
      (case parsed of
          INL s =>
            let
              val pos = Pos.pos (Coord.init fileName) (Coord.init fileName)
            in
              raise RedPrlExn.RedPrlExn (SOME pos, "Parsing of " ^ fileName ^ " has failed: " ^ s)
            end
        | INR sign =>
            let
              val elab = RefineElab.transport o ValidationElab.transport o BindSignatureElab.transport
              val sign' = elab sign
              val _ = printSign sign'
            in
              ()
            end)
        handle exn =>
          (TextIO.output (TextIO.stdErr, RedPrlExn.toString exn);
           OS.Process.exit OS.Process.failure)
    end
end
