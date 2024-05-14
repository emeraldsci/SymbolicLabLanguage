

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Shelf], {
	Description->"A shelf which can hold instruments and other containers (may be wall-mounted, within a cabinet, or a level of a bench).",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		APIShelfNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The unique shelf number used by the Modula software to make API calls.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		}
	}
}];
