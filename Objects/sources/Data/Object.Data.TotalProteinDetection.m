

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, TotalProteinDetection], {
	Description->"Data from a capillary electrophoresis-based total protein labeling and detection experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		MolecularWeightRange -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WesternMolecularWeightRangeP,
			Description -> "The molecular weight range that is inspected in assay which produced these data (LowMolecularWeight = 2-40 kDa; MidMolecularWeight = 12-230 kDa; HighMolecularWeight = 66-440kDa).",
			Category -> "General",
			Abstract -> True
		},
		DetectionMode->{
			Format->Single,
			Class->Expression,
			Pattern:>WesternDetectionP,
			Description->"The physical phenomenon observed as the source of the signal for these data.",
			Category -> "General"
		},
		Denaturing->{
			Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description->"Indicates if the mixture of input sample and loading buffer was heated prior to being run on the western assay.",
			Category -> "General"
		},
		DenaturingTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Celsius],
			Units->Celsius,
			Description->"The temperature which the mixture of input sample and loading buffer was heated to before being run on the western assay.",
			Category -> "General"
		},
		DenaturingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration for which the mixture of input sample and loading buffer was heated to DenaturingTemperature before being run on the western assay.",
			Category -> "General"
		},
		CapillaryNumber -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of the capillary corresponding to these data.",
			Category -> "General",
			Abstract -> True
		},
		SeparatingMatrixLoadTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The duration for which the separating matrix was loaded into the capillary.",
			Category -> "General"
		},
		StackingMatrixLoadTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the stacking matrix was loaded into the capillary.",
			Category -> "General"
		},
		SampleLoadTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Second,
			Description -> "The duration for which the sample was loaded into the capillary.",
			Category -> "General"
		},
		Voltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Volt, 1*Volt],
			Units -> Volt,
			Description -> "The voltage applied to the capillary to separate macromolecules.",
			Category -> "General",
			Abstract -> True
		},
		SeparationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the Voltage was applied across the capillary to separate macromolecules.",
			Category -> "General",
			Abstract->True
		},
		UVExposureTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary was exposed to UV-light for protein cross-linking to the capillary.",
			Category -> "General"
		},
		LabelingReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample,StockSolution],
			Description->"The biotin-containing reagent used to label all proteins present in the input samples.",
			Category -> "General"
		},
		LabelingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary is incubated with the LabelingReagent.",
			Category -> "General"
		},
		WashBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample,StockSolution],
			Description->"The buffer that was incubated with the capillary between blocking and labeling steps to remove excess reagents.",
			Category -> "General"
		},
		BlockingBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample,StockSolution],
			Description->"The buffer that was incubated with the capillary after the LabelingTime to prevent nonspecific interactions during subsequent labeling steps.",
			Category -> "General"
		},
		BlockingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration of the BlockingBuffer incubation after the LabelingTime.",
			Category -> "General"
		},
		BlockWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary was incubated with the WashBuffer after the BlockingBuffer.",
			Category -> "General"
		},
		NumberOfBlockWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary is incubated with the WashBuffer for the BlockWashTime after the BlockingTime.",
			Category -> "General"
		},
		PeroxidaseReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample,StockSolution],
			Description->"The streptavidin-containing HRP solution used to detect the biotinylated ladder.",
			Category -> "General"
		},
		PeroxidaseIncubationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary was incubated with the PeroxidaseReagent.",
			Category -> "General"
		},
		PeroxidaseWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The duration for which the capillary was incubated with the WashBuffer after the PeroxidaseReagent.",
			Category -> "General"
		},
		NumberOfPeroxidaseWashes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0,1],
			Description->"The number of times the capillary was incubated with the WashBuffer for the PeroxidaseWashTime after the PeroxidaseIncubationTime.",
			Category -> "General"
		},
		LuminescenceReagent->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample]|Model[Sample]|Object[Sample]|Model[Sample,StockSolution],
			Description->"The solution that reacted with the PeroxidaseReagent to give off chemiluminesence which was observed during the SignalDetectionTimes.",
			Category -> "General"
		},
		SignalDetectionTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Second],
			Units->Second,
			Description->"The image exposure times for signal detection, with each time corresponding to one image taken by the software.",
			Category -> "General"
		},

		MassSpectrum -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{Kilo*Dalton,Lumen}],
			Units -> {Dalton Kilo, Lumen},
			Description -> "Mass spectra recorded via luminescent visualization of the capillary post separation, fixing, blocking, and staining.",
			Category -> "Experimental Results"
		},

		DataType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[Analyte,Ladder],
			Description -> "Indicates if this data object represents a standard ladder or an analyte sample.",
			Category -> "Analysis & Reports"
		},
		LadderSizes -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Times[Lookup[Download[LastOrDefault[Field[LadderAnalyses]]], Sizes], Lookup[Download[LastOrDefault[Field[LadderAnalyses]]], SizeUnit]]],
			Pattern :> {GreaterEqualP[0*Nucleotide, 1*Nucleotide]..} | {GreaterEqualP[0*Molar, 1*Molar]..},
			Description -> "The sizes of the fragments in the provided ladder.",
			Category -> "Analysis & Reports"
		},
		LadderPeaks -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[LadderAnalyses]}, Computables`Private`ladderPeaks[Field[LadderAnalyses]]],
			Pattern :> {(GreaterP[0*Second, 1*Second] | GreaterP[0*Pixel, 1*Pixel] | GreaterP[0*Meter, 1*Meter] -> GreaterP[0*Nucleotide] | GreaterP[0*Molar])..},
			Description -> "The positions of the peaks in the ladder standard.",
			Category -> "Analysis & Reports"
		},
		LadderAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "A link to the ladder analysis object for these data.",
			Category -> "Analysis & Reports"
		},
		LadderData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, TotalProteinDetection][Analytes],
			Description -> "Data containing the ladder run alongside with this analyte.",
			Category -> "Analysis & Reports"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, TotalProteinDetection][LadderData],
			Description -> "Relations pointing to all of the data run in closest proximity to this ladder.",
			Category -> "Analysis & Reports"
		},
		MassSpectrumPeaksAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Peak-picking analysis conducted on these data.",
			Category -> "Analysis & Reports"
		},
		FitSourceSpectra -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "Fitting analysis conducted on this spectrum.",
			Category -> "Analysis & Reports"
		}
	}
}];
