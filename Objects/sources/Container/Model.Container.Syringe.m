

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, Syringe], {
	Description->"A model for a device/part designed to aspirate and dispense liquid by moving a plunger inside a sealed cylinder.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "Indicates the manner in which the syringe is connected to a needle.",
			Category -> "Physical Properties"
		},
		Resolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter*Micro],
			Units -> Liter Milli,
			Description -> "The smallest volume increment between MinVolume and MaxVolume that can be measured by this syringe.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		DeadVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Microliter,
			Description -> "The volume of fluid that will remain in the syringe even when the plunger is fully depressed.",
			Category -> "Operating Limits"
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The inner diameter of the cylindrical, fluid-containing portion of this syringe.",
			Category -> "Physical Properties",
			Abstract->True
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The outer diameter of the cylindrical, fluid-containing portion of this syringe.",
			Category ->"Physical Properties",
			Abstract->True
		},
		MaxVolumeLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Centimeter,
			Description -> "The length of the syringe when holding the maximum allowed volumen,measured from the end of the plunger to the tip of needle adapter.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		GCInjectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (LiquidInjection|HeadspaceInjection|LiquidHandling),
			Description -> "The GC sampling method with which this syringe is compatible.",
			Category -> "Physical Properties"
		},
		GCAutosamplerIdentifier -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The syringe geometry ID number used to instruct the GC autosampler how to handle this syringe.",
			Category -> "Physical Properties",
			Developer -> True
		},
		SelfStandingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern :> _Link,
			Relation->Model[Container,Rack],
			Description->"Model of a container capable of holding this type of syringe upright.",
			Category->"Compatibility"
		},
		Graduations->{
			Format->Multiple,
			Class->Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The markings on this syringe model used to indicate the fluid's fill level.",
			Abstract->True,
			Category -> "Container Specifications"
		},
		GraduationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> GraduationTypeP,
			Description -> "For each member of Graduations, indicates if the graduation is labeled with a number, a long unlabeled line, or a short unlabeled line.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations
		},
		GraduationLabels -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Graduations, if GraduationTypes is Labeled, exactly matches the labeling text. Otherwise, Null.",
			Category -> "Container Specifications",
			IndexMatching -> Graduations,
			Developer -> True
		}
	}
}];
