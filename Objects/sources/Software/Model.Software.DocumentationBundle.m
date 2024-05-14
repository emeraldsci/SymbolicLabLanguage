(* ::Package:: *)
  
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Software,DocumentationBundle], {
        Description->"A complete bundle of the documentation for the symbolic lab language.",
        CreatePrivileges->None,
        Cache->Download,
        Fields -> {
	    (* Inherits Branch, DateCreated, Latest, WolframVersion, OperatingSystem, and DeveloperObject from Model[Software] *)
                DocumentationType -> {
                        Format -> Single,
                        Class -> Expression,
                        Pattern :> Internal | External,
                        Description -> "Indicates whether or not the documentation should be shown to external users or only internal developers at emerald.",
                        Category -> "Organizational Information"
                }
        }
}];
