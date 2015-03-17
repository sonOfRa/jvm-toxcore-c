open ApiAst


let flip f a b = f b a


let fold_scoped f v uname decls scope =
  SymbolTable.scoped scope uname
    (ApiFold.visit_list f v) decls


let extract decls =
  let open ApiFold in


  let fold_enumerator v scope = function
    | Enum_Name (_, uname) ->
        scope
        |> SymbolTable.add uname

    | Enum_Namespace (uname, enumerators) ->
        scope
        |> SymbolTable.add uname
        |> fold_scoped v.fold_enumerator v uname enumerators
  in


  let fold_parameter v scope = function
    | Param (_, lname) ->
        scope
        |> SymbolTable.add lname
  in


  let fold_decl v scope = function
    | Decl_Function (type_name, lname, parameters, error_list) ->
        scope
        |> SymbolTable.add lname
        |> fold_scoped v.fold_parameter v lname parameters
        |> fold_scoped v.fold_error_list v lname [error_list]

    | Decl_GetSet (_, lname, decls)
    | Decl_Class (lname, decls) ->
        scope
        |> SymbolTable.add lname
        |> fold_scoped v.fold_decl v lname decls

    | Decl_Namespace (lname, decls) ->
        scope
        |> SymbolTable.add ~extend:true lname
        |> fold_scoped v.fold_decl v lname decls

    | Decl_Enum (_, uname, enumerators) ->
        scope
        |> SymbolTable.add uname
        |> fold_scoped v.fold_enumerator v uname enumerators

    | Decl_Error (lname, enumerators) ->
        scope
        |> SymbolTable.add lname
        |> fold_scoped v.fold_enumerator v lname enumerators

    | Decl_Member (_, lname) ->
        scope
        |> SymbolTable.add lname

    | Decl_Const (uname, _) ->
        scope
        |> SymbolTable.add uname

    | Decl_Struct decls ->
        scope
        |> fold_scoped v.fold_decl v "this" decls

    | Decl_Event (lname, decl) ->
        let lname = "event " ^ lname in
        scope
        |> SymbolTable.add lname
        |> fold_scoped v.fold_decl v lname [decl]

    | Decl_Comment _
    | Decl_Static _
    | Decl_Macro _
    | Decl_Typedef _ as decl ->
        ApiFold.visit_decl v scope decl
  in

  let v = {
    default with
    fold_enumerator;
    fold_parameter;
    fold_decl;
  } in
  SymbolTable.make @@ visit_decls v SymbolTable.root decls
