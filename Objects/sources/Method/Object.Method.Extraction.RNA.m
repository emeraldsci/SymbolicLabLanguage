(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* TODO :: add tests to ValidObjectQ *)

DefineObjectType[Object[Method, Extraction, RNA], {
	Description -> "A method specifying conditions and reagents for the extraction and isolation of RNA from a sample containing cells or cell lysate.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TargetRNA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[TotalRNA, mRNA, miRNA, tRNA, rRNA, ViralRNA, ExosomalRNA, CellFreeRNA, Unspecified],
			Description -> "The type of RNA that is purified during the extraction. TotalRNA is extracted from cell lysate. Subsets of cellular RNA (mRNA, miRNA, tRNA, rRNA) are preferentially purified from a cell lysate by varying extraction conditions such as lysis or wash solutions. ViralRNA, ExosomalRNA, or CellFreeRNA are extracted and purified from harvested media or viral particles without lysing cells.",
			Category -> "General"
		},
		HomogenizeLysate -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if lysate samples are disrupted using mechanical forces to shear large subcellular components, after lysis and prior to purification steps. Lysate homogenization can prevent clogging of solid phase extraction cartridges, if SolidPhaseExtraction is employed during Purification.",
			Category -> "Lysate Homogenization"
		},
		HomogenizationDevice -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate, Filter],
				Object[Container, Plate, Filter]
			],
			Description -> "The consumable container with an embedded filter which is used to shear lysate components by flushing the lysate sample through the pores in the filter.",
			Category -> "Lysate Homogenization"
		},
		HomogenizationTechnique -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[AirPressure, Centrifuge],
			Description -> "The type of force used to flush the cell lysate sample through the HomogenizationDevice in order to shear lysate components.",
			Category -> "Lysate Homogenization"
		},
		HomogenizationCentrifugeIntensity -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 RPM], GreaterEqualP[0 GravitationalAcceleration]],
			Units -> None,
			Description -> "The rotational speed or gravitational force at which the sample is centrifuged to flush the lysate through the HomogenizationDevice in order to shear lysate components.",
			Category -> "Lysate Homogenization"
		},
		HomogenizationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The amount of pressure applied to flush the lysate through the HomogenizationDevice in order to shear lysate components.",
			Category -> "Lysate Homogenization"
		},
		HomogenizationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The duration of time for which force is applied to flush the lysate through the HomogenizationDevice by the specified HomogenizationTechnique and HomogenizationInstrument in order to shear lysate components.",
			Category -> "Lysate Homogenization"
		},
		DehydrationSolution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[ObjectP[{Object[Sample], Model[Sample]}], None],
			Description -> "The solution that is added to the sample prior to a purification step in order to promote binding of the analyte to the Sorbent. When Strategy is set to Positive, DehydrationSolution promotes binding of the TargetRNA to the Sorbent.",
			Category -> "Dehydration"
		},
		DehydrationSolutionMixType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Shake | Pipette | None,
			Description->"The manner in which the sample is agitated following addition of DehydrationSolution to the sample. None specifies that no mixing occurs after adding DehydrationSolution to the sample.",
			Category -> "Dehydration"
		},
		NumberOfDehydrationSolutionMixes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[1],
			Units -> None,
			Description->"The number of times that the sample is mixed by pipetting the DehydrationSolutionMixVolume up and down following the addition of DehydrationSolution to the sample.",
			Category->"Dehydration"
		},
		DehydrationSolutionMixRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 RPM],
			Units -> RPM,
			Description->"The number of rotations per minute at which the sample containing DehydrationSolution is shaken in order to fully mix the DehydrationSolution with the sample, during the DehydrationSolutionMixTime.",
			Category->"Dehydration"
		},
		DehydrationSolutionMixTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Second],
			Units -> Second,
			Description -> "The duration for which the sample and DehydrationSolution are mixed by the selected DehydrationSolutionMixType following the combination of the sample and the DehydrationSolution.",
			Category->"Dehydration"
		}
	}
}];