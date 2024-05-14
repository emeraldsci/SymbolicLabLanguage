(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,NMR], {
	Description->"A protocol that verifies the functionality of the NMR target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TubeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Rack]|Object[Container,Rack],
			Description -> "The NMR tube rack used to hold the NMR tubes when they aren't on the instrument.",
			Category -> "General"
		},
		SensitivityTests -> {
			Format -> Multiple,
			Class -> {Sample->Link, Nucleus->String, MinSignalToNoise->Real, SignalToNoise->Real, Passing->Boolean},
			Pattern :> {Sample->_Link, Nucleus->NucleusP, MinSignalToNoise->GreaterP[0], SignalToNoise->GreaterP[0], Passing->BooleanP},
			Relation -> {Sample->(Model[Sample]|Object[Sample]), Nucleus->Null, MinSignalToNoise->Null, SignalToNoise->Null, Passing->Null},
			Description -> "The measured signal to noise ratios when detecting specific nuclei and whether or not they meet the minimum signal to noise criteria.",
			Category -> "Experimental Results"
		},
		LineshapeTests -> {
			Format -> Multiple,
			Class -> {Sample->Link, Nucleus->String, SpinningFrequency->Integer, PercentPeakHeight->Real, MaxWidth->Real, Width->Real, Passing->Boolean},
			Pattern :> {Sample->_Link, Nucleus->NucleusP, SpinningFrequency->GreaterEqualP[0], PercentPeakHeight->RangeP[0,100,Inclusive->Right], MaxWidth->GreaterP[0], Width->GreaterP[0], Passing->BooleanP},
			Relation -> {Sample->(Model[Sample]|Object[Sample]), Nucleus->Null, SpinningFrequency->Null, PercentPeakHeight->Null, MaxWidth->Null, Width->Null, Passing->Null},
			Units -> {Sample->None, Nucleus->None, SpinningFrequency->Hertz, PercentPeakHeight->Percent, MaxWidth->Hertz, Width->Hertz, Passing->None},
			Description -> "The widths of detected peaks at various percentages of the peaks' heights and whether or not they are narrower than the maximum width criteria.",
			Category -> "Experimental Results"
		}
		
	}
}];
