(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Analysis, Peaks], {
	Description->"Analysis to find and characterize peaks found in connected {x,y} datapoints.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ReferenceDataSliceDimension->{
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "The dimension(s) of the numerical data in the ReferenceField of the Reference object which should be sliced to generate {x,y} data for Peaks analysis.",
			Category -> "General"
		},
		ReferenceDataSlice->{
			Format -> Multiple,
			Class -> {VariableUnit, VariableUnit},
			Headers -> {"Min", "Max"},
			Pattern :> {UnitsP[], UnitsP[]},
			Description -> "For each member of ReferenceDataSliceDimension, the range of values in that dimension which were sliced to produce {x,y} data for Peaks analysis. If the minimum and maximum value are the same, then data was sliced at a singular value in that dimension.",
			Category -> "General",
			IndexMatching -> ReferenceDataSliceDimension
		},
		SliceReductionFunction->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Total|Mean|Max|Min],
			Description -> "For each member of ReferenceDataSliceDimension, the function used to flatten slices in that dimension. For example, Mean indicates that when slicing a range of values, the slice should be flattened by averaging over the ReferenceDataSliceDimension.",
			Category -> "General",
			IndexMatching -> ReferenceDataSliceDimension
		},
		PeakSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample that was used to generate the data on which this analysis was performed.",
			Category -> "General"
		},
		Domain -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {_?NumberQ, _?NumberQ},
			Units -> {None, None},
			Description -> "Peak picking only considers data points that lie within the domains, specified as {minX, maxX}.",
			Category -> "General",
			Headers -> {"Min","Max"}
		},
		AbsoluteThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "A peak's maximum y-value must exceed this threshold.",
			Category -> "General"
		},
		RelativeThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The distance from a peak's maximum y-value to its baseline must exceed this threshold.",
			Category -> "General"
		},
		WidthThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "A peak's half-height width must exceed this threshold.",
			Category -> "General"
		},
		AreaThreshold -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "A peak's area must exceed this threshold.",
			Category -> "General"
		},
		BaselineFunction -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Function,
			Description -> "A pure function describing the baseline for the data.",
			Category -> "General"
		},
		Position -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "A list of the x-coordinates at which the peaks reach their maximum height.",
			Category -> "Analysis & Reports"
		},
		Height -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of Position, the maximum height of the peak at that position, where height is measured as distance from y-coordinate to baseline.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		HalfHeightWidth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of Position, the width of the peak at that position, where width is defined as the x-distance from WidthRangeStart to WidthRangeEnd (the peak width at half height).",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		TangentWidth -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of Position, the base width of the peak at that position, obtained by extrapolating the relatively straight sides of the peak to the baseline.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		TangentWidthLines -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {_Function, _Function},
			Units -> {None, None},
			Description -> "For each member of Position, a linear fit to the relatively straight side of the peak at that position.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position,
			Headers -> {"Left", "Right"}
		},
		TangentWidthLineRanges -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {{NumericP, NumericP}, {NumericP, NumericP}},
			Units -> {None, None},
			Description -> "For each member of Position, the valid range for TangentWidthLines.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position,
			Headers -> {"Left", "Right"}
		},
		Area -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the area of the peak at that position, calculated as the total area from the bottom baseline up to the y-coordinates ranging from PeakRangeStart to PeakRangeEnd .",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		PeakRangeStart -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the x-coordinate where the peak starts, defined as the minimum x-coordinate contained in the peak as determined by the peak picking algorithm.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		PeakRangeEnd -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the x-coordinates where the peak ends, defined as the maximum x-coordinate contained in the peak as determined by the peak picking algorithm.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		WidthRangeStart -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the x-coordinate of the peak where the peak's y-coordinate first reaches half of its maximum height.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		WidthRangeEnd -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the x-coordinate of the peak where the peak's y-coordinate last reaches half of its maximum height.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		BaselineIntercept -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the y-intercept of a linear baseline for the peak, where the linear baseline is fitted either to the start and end of the peak in the local baseline case, or to all the points not included in any peak in the global baseline case.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		BaselineSlope -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the slope of a linear baseline for the peak, where the linear baseline is fitted either to the start and end of the peak in the local baseline case, or to all the points not included in any peak in the global baseline case.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		AsymmetryFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of Position, the asymmetry factor calculated as the ratio of the right distance-to-center by the left distance-to-center, taken at 10 percent of the maximum peak height. Values greater than one indicate right skew, values equal to one indicate symmetry, and values less than one indicate left skew.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		TailingFactor -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "For each member of Position, the USP tailing ratio, where values greater than one indicate right skew, values equal to one indicate symmetry, and values less than one indicate left skew.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		HalfHeightResolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {NumericP..},
			Units -> None,
			Description -> "For each member of Position, a vector of USP peak resolution, indicating the seperation of two peaks, calculated from half height width.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		TangentResolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(NumericP | Null)..},
			Units -> None,
			Description -> "For each member of Position, a vector of USP peak resolution, indicating the seperation of two peaks, calculated from tangent width.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		AdjacentResolution -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, a USP peak resolution indicating the seperation of two adjacent peaks, calculated from half height width.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		HalfHeightNumberOfPlates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the USP plate number for the peak, indicating column efficiency, calculated from half height width.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		TangentNumberOfPlates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the USP plate number for the peak, indicating column efficiency, calculated from tangent width.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		ParentPeak -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Units -> None,
			Description -> "For each member of Position, the label of the parent peak from which relative areas and positions are calculated.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		RelativeArea -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> NumericP,
			Units -> None,
			Description -> "For each member of Position, the ratio between the area of the peak and the area of the reference peak.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		RelativePosition -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "For each member of Position, the ratios between the position of the peak and the position of the reference peak.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		RelativeRetentionTime -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> _?NumericQ,
			Units -> None,
			Description -> "For each member of Position, the ratios between the position of the peak and the position of the standard peak.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		PeakLabel -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Position, the label for the peak at that position.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		PeakAssignment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "For each member of Position, the putative molecule that each identified peak corresponds to.",
			Category -> "Analysis & Reports",
			IndexMatching -> Position
		},
		PeakAssignmentLibrary -> {
			Format -> Multiple,
			Class -> {Label->String, Model->Link, Position->Real, Tolerance->Real},
			Pattern :> {Label->_String, Model->ObjectP[Model[Molecule]], Position->NumericP, Tolerance->NumericP},
			Units -> {Label->None, Model->None, Position->None, Tolerance->None},
			Relation -> {Label->Null, Model->Model[Molecule], Position->Null, Tolerance->Null},
			Description -> "Putative peak assignments consulted to assign peaks in this analysis. These assignments will be used when this analysis is used as a template for future analyses.",
			Headers -> {Label->"Peak Label", Model->"Peak Identity", Position->"Position", Tolerance->"Alignment Tolerance"},
			Category->"Analysis & Reports"
		},
		PeakUnits -> {
			Format -> Computable,
			Expression :> Computables`Private`peakUnits[Field[Reference], Field[ReferenceField], Field[ReferenceDataSliceDimension]],
			Pattern :> {_Rule...},
			Description -> "The Units of the peak parameters as specified in the reference data.",
			Category -> "Analysis & Reports"
		},
		Purity -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurityP,
			Description -> "The purity of the peaks as defined by the total and relative area of each peak with respect to one another and the background, in the form: {Area->{values..},RelativeArea->{percentages..},PeakLabels->{strings..}}.",
			Category -> "Analysis & Reports"
		},
		SequenceAnalysis -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis,DNASequencing][PeaksAnalyses],
			Description -> "The DNA sequencing analysis object relating an identified DNA sequence to this peak-picking analysis.",
			Category -> "Analysis & Reports"
		},
		StandardAnalysis -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Analysis, Ladder][PeaksAnalysis],
			Description -> "The analysis object relating oligomer fragment sizes to the positions of these peaks.",
			Category -> "Analysis & Reports"
		},
		NMROperatingFrequency->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*MegaHertz*Mega],
			Units -> Mega*Hertz,
			Description -> "The resonance frequency at which input NMR data was collected.",
			Category -> "NMR Peak Splitting"
		},
		NMRNucleus -> {
			Format -> Single,
			Class -> String,
			Pattern :> NucleusP,
			Description -> "The nucleus whose spins are being recorded in the input NMR data.",
			Category -> "NMR Peak Splitting"
		},
		NMRSplittingGroup -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Units -> None,
			Description -> "For each member of Position, the index of the peak splitting group to which each peak belongs.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> Position
		},
		NMRChemicalShift->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UnitsP[PPM]|Span[UnitsP[PPM],UnitsP[PPM]],
			Description -> "The chemical shift of each peak splitting group indexed in NMRSplittingGroup.",
			Category -> "NMR Peak Splitting"
		},
		NMRNuclearIntegral->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0.0],
			Units -> None,
			Description -> "For each member of NMRChemicalShift, the total area of all peaks in the corresponding peak group.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> NMRChemicalShift
		},
		NMRMultiplicity->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(_Integer|"m")..},
			Units -> None,
			Description -> "For each member of NMRChemicalShift, the multiplicities of the peak splittings in the corresponding peak group.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> NMRChemicalShift
		},
		NMRJCoupling -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {UnitsP[Hertz]...},
			Description -> "For each member of NMRChemicalShift, the coupling constant(s) describing any peak splittings in the corresponding peak group.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> NMRChemicalShift
		},
		NMRAssignment -> {
			Format -> Multiple,
			Class -> {Expression, Expression},
			Pattern :> {MoleculeP|Unknown,{_Integer...}},
			Description -> "For each member of NMRChemicalShift, the atoms in molecules which contribute to the signal in each peak group.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> NMRChemicalShift,
			Headers -> {"Molecule","Atomic Indices"}
		},
		NMRFunctionalGroup -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _MoleculePattern|MoleculeP|Unknown,
			Description -> "For each member of NMRChemicalShift, the chemical substructure assigned to each peak group.",
			Category -> "NMR Peak Splitting",
			IndexMatching -> NMRChemicalShift
		}
	}
}];
