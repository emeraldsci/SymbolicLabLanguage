(* ::Package:: *)

DefineObjectType[Object[Analysis, Composition], {
	Description->"Analysis to calculate assay compositions of different chemical models through peak picking on HPLC protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		StandardSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Samples with known profiles used to calibrate peak integrations and retention times for a given run.",
			Category -> "Standards"
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, Chromatography][ChromatogramCompositionAnalyses],
				Object[Data, ChromatographyMassSpectra][ChromatogramCompositionAnalyses]
			],
			Description -> "For each standard sample, the chromatography trace generated for the standard's injection.",
			Category -> "Standards"
		},
		StandardPositions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, a list of the x-coordinates at which the peaks reach their maximum height.",
			Category -> "Standards"
		},
		StandardHeights -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the maximum height of the peak, where height is measured as distance from y-coordinate to baseline.",
			Category -> "Standards"
		},
		StandardAreas -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the area of the peak calculated as the total area from the bottom baseline up.",
			Category -> "Standards"
		},
		StandardAdjacentResolutions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the USP peak resolution indicating the seperation of two adjacent peaks, calculated from half height width.",
			Category -> "Standards"
		},
		StandardTailing -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the USP tailing ratio, where values greater than one indicate right skew, values equal to one indicate symmetry, and values less than one indicate left skew.",
			Category -> "Standards"
		},
		StandardLabels -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{_String...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the peak labels to identify different peaks.",
			Category -> "Standards"
		},
		StandardModels -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {{(ObjectP[{Model[Sample],Model[Molecule]}]|Null|Model[Sample,Chemical,_String]|Link[Model[Sample,Chemical,_String],___])...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the model assignments corresponding to the picked peaks.",
			Category -> "Standards"
		},

		AssaySamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "Input samples whose composition is about to be analyzed.",
			Category -> "Analytes"
		},
		AssayData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Data, Chromatography][ChromatogramCompositionAnalyses],
				Object[Data, ChromatographyMassSpectra][ChromatogramCompositionAnalyses]
			],
			Description -> "For each assay sample, the chromatography trace generated for the sample's injection.",
			Category -> "Analytes"
		},
		AssayPositions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, a list of the x-coordinates at which the peaks reach their maximum height.",
			Category -> "Analytes"
		},
		AssayHeights -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the maximum height of the peak, where height is measured as distance from y-coordinate to baseline.",
			Category -> "Analytes"
		},
		AssayAreas -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the area of the peak calculated as the total area from the bottom baseline up.",
			Category -> "Analytes"
		},
		AssayAdjacentResolutions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the USP peak resolution indicating the seperation of two adjacent peaks, calculated from half height width.",
			Category -> "Analytes"
		},
		AssayTailing -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{GreaterEqualP[0]...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the USP tailing ratio, where values greater than one indicate right skew, values equal to one indicate symmetry, and values less than one indicate left skew.",
			Category -> "Analytes"
		},
		AssayLabels -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{_String...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the peak labels to identify different peaks.",
			Category -> "Analytes"
		},
		AssayModels -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {{(ObjectP[{Model[Sample],Model[Molecule]}]|Null|Model[Sample,Chemical,_String])...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the model assignments corresponding to the picked peaks.",
			Category -> "Analytes"
		},

		(* Analysis *)
		StandardCompositions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{(_Quantity|_?NumericQ|_String)...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of StandardData, the chemical model compositions of each standard model in each standard sample.",
			Category -> "Analysis & Reports"
		},
		StandardCurveFitAnalyses -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis][Reference],
			Description -> "The AnalyzeFit objects corresponding to the fitted curve for each chemical model in this analysis.",
			Category -> "Analysis & Reports"
		},
		StandardCurveFitFunctions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _Function|_QuantityFunction,
			Units -> None,
			Description -> "Fit function that calculates the expected composition (mg/ml) as a function of peak area, stored as a pure function.",
			Category -> "Analysis & Reports"
		},
		DilutionFactors -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "Each assay dilution due to aliquoting.",
			Category -> "Analysis & Reports"
		},
		AliquotCompositions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{(_Quantity|_?NumericQ|_String)...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the chemical model compositions of the assay samples after aliquoting.",
			Category -> "Analysis & Reports"
		},
		AssayCompositions -> {
			Format -> Single,
			Class -> Compressed,
			Pattern :> {{(_Quantity|_?NumericQ|_String)...}...}, (* Todo: N-Multiples *)
			Description -> "For each member of AssayData, the chemical model compositions of the assay samples before aliquoting.",
			Category -> "Analysis & Reports"
		}
	}
}];
