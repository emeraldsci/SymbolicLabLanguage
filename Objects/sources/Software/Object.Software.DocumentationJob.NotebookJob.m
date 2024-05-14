(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software, DocumentationJob, NotebookJob], {
	Description->"A single run of a documentation job that builds Mathematica .nb files.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		TriggerWebDocsRebuild -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "If True, rebuild web docs as well once this job is complete.",
			Category -> "Organizational Information"
		}
	}
}];
