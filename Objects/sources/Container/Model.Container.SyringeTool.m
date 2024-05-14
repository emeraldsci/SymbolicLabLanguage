

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, SyringeTool], {
	Description->"A model for a device/part designed to hold and operate a plunger-operated sample preparation tool such as a syringe or extraction fiber.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		SamplingMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GCSamplingMethodP|LiquidHandling,
			Description -> "The gas chromatography sample type that this tool is capable of preparing.",
			Category -> "Compatibility"
		},
		AllowedSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Syringe],
			Description -> "The models of all syringes that are compatible with this sampling tool.",
			Category -> "Compatibility"
		}
	}
}];
