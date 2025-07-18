

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Resource, Instrument], {
	Description->"A set of parameters describing the attributes of an instrument required to complete the requesting protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		InstrumentModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "A list of instrument models that can be used to fulfill this resource request.",
			Category -> "Resources"
		},
		RequestedInstrumentModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][RequestedResources],
			Description -> "The requested instrument models that are reserved to fulfill this resource resquest.",
			Category -> "Resources"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instrument picked to fulfill this resource request.",
			Category -> "Resources"
		},
		RequestedInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][RequestedResources],
			Description -> "The instrument that is reserved to fulfill this resource request.",
			Category -> "Resources"
		},
		UnusedIntegratedInstrument -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this resource is for reserving an integrated instrument for the protocol that will not be used. This is vital to allow up to skip UndergoingMaintenance instruments that have this key.",
			Category -> "Resources",
			Developer->True
		},
		DeckLayouts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout],
			IndexMatching -> InstrumentModels,
			Description -> "For each member of InstrumentModels, the specific configuration of containers on the deck of the instrument requested by this resource.",
			Category -> "Resources"
		},
		EstimatedTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time requested for this instrument.",
			Category -> "Resources"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time that this instrument was used by the given protocol.",
			Category -> "Resources"
		},
		MinTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The minimum amount of time required for this instrument.",
			Category -> "Resources"
		},
		MaxTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The maximum amount of time required for this instrument.",
			Category -> "Resources"
		}
	}
}];
