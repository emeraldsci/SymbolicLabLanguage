(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validAnalysisQTests*)


validAnalysisQTests[packet:PacketP[Object[Analysis]]] := {

	(* General fields filled in *)
	NotNullFieldTest[packet,{DateCreated,ResolvedOptions}]

};


(* ::Subsection:: *)
(*validAnalysisAbsorbanceQuantificationQTests*)


validAnalysisAbsorbanceQuantificationQTests[packet:PacketP[Object[Analysis,AbsorbanceQuantification]]] := {

	(* Shared fields - Null *)
	NullFieldTest[packet,ReferenceField],

	(* Unique fields *)
	NotNullFieldTest[packet, {

		(* Shared fields - Not null *)
		Reference,

		(* Unique fields *)
		SamplesIn,
		AbsorbanceSpectra
		}
	](*,


	(* Test that Reference is made up of AbsorbanceSpectraEmpty, AbsorbanceSpectraBlank, AbsorbanceSpectra *)
	Test["Reference includes all of the data objects in AbsorbanceSpectraEmpty, AbsorbanceSpectraBlank, AbsorbanceSpectra and no other:",
		First[ContainsExactly[#[[1]][Object] , Flatten[#[[2 ;; 4]]][Object]] & /@ {Lookup[packet, {Reference, AbsorbanceSpectraEmpty, AbsorbanceSpectraBlank, AbsorbanceSpectra}]}],
		True
	]*)

};

(* ::Subsection::Closed:: *)
(*validAnalysisBindingKineticsQTests*)


validAnalysisBindingKineticsQTests[packet:PacketP[Object[Analysis,BindingKinetics]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)

		(*Unique fields not Null*)
		AssociationRates,
		DissociationRates,
		AssociationRatesDistribution,
		DissociationRateDistribution,
		DissociationConstant,
		PredictedTrajectories,
		FitAnalysis,
		Residual,
		SumSquaredError
	}
	]

};


(* ::Subsection::Closed:: *)
(*validAnalysisBindingQuantitationQTests*)


validAnalysisBindingQuantitationQTests[packet:PacketP[Object[Analysis,BindingQuantitation]]]:={

	NotNullFieldTest[packet,
		{
			(*Shared fields not Null*)

			(*Unique fields not Null*)
			SamplesInFitting,
			SamplesIn
		}
	],

	(*Required together - all the standard curve things*)
	RequiredTogetherTest[packet,
		{
			StandardData,
			StandardDataFitAnalysis,
			StandardConcentrations,
			StandardCurveFitAnalysis
		}
	]

};


(* ::Subsection::Closed:: *)
(*validAnalysisBubbleRadiusQTests*)


validAnalysisBubbleRadiusQTests[packet:PacketP[Object[Analysis,BubbleRadius]]]:={
	(* Fields which must be informed if the analysis was successful *)
	NotNullFieldTest[packet,
		{
			AnalysisVideoFile,
			AnalysisVideoFrames,
			AnalysisVideoPreview,
			VideoTimePoints,
			RadiusDistribution,
			AreaDistribution,
			AbsoluteBubbleCount,
			BubbleCount,
			MeanBubbleArea,
			StandardDeviationBubbleArea,
			AverageBubbleRadius,
			StandardDeviationBubbleRadius,
			MeanSquareBubbleRadius,
			BubbleSauterMeanRadius
		}
	],

	(* Information from the data object that is required together *)
	RequiredTogetherTest[packet,
		{
			CameraHeight,
			FieldOfView
		}
	],

	Test["All quantity array fields have length equal to the number of video frames:",
		SameQ@Join[
			FirstOrDefault[Dimensions[#]]&/@Lookup[packet,{
				BubbleCount,
				MeanBubbleArea,
				StandardDeviationBubbleArea,
				AverageBubbleRadius,
				StandardDeviationBubbleRadius,
				MeanSquareBubbleRadius,
				BubbleSauterMeanRadius
			}],
			Length[packet[VideoTimePoints]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisClustersQTests*)


validAnalysisClustersQTests[packet:PacketP[Object[Analysis,Clusters]]]:={
	(* Fields which must be informed *)
	NotNullFieldTest[packet,{
		NumberOfDimensions,
		DimensionLabels,
		DimensionUnits,
		Normalize,
		Scale,
		Method,
		NumberOfClusters,
		DistanceFunction,
		PreprocessedData,
		ClusteredData,
		ClusteredDataConfidence,
		WithinClusterSumOfSquares
	}],

	Test["If Method is Automatic, ClusteringAlgorithm and ClusteredDimensions are not Null|{}. If Method is Manual, then they are Null|{}:",
		If[MatchQ[Lookup[packet,Method],Automatic],
			And[!MatchQ[Lookup[packet,ClusteringAlgorithm],Null], !MatchQ[Lookup[packet,ClusteredDimensions],{}]],
			And[MatchQ[Lookup[packet,ClusteringAlgorithm],Null], MatchQ[Lookup[packet,ClusteredDimensions],{}]]
		],
		True
	],

	Test["ClusterLabels are keys of the ClusteredData association:",
		SubsetQ[Keys[Lookup[packet,ClusteredData]],Lookup[packet,ClusterLabels]],
		True
	],

	Test["The length of DimensionLabels matches NumberOfDimensions:",
		Or[
			MatchQ[Lookup[packet,DimensionLabels],None],
			Length[Lookup[packet,DimensionLabels]]==Lookup[packet,NumberOfDimensions]
		],
		True
	],

	Test["The length of DimensionUnits matches NumberOfDimensions:",
		Length[Lookup[packet,DimensionUnits]]==Lookup[packet,NumberOfDimensions],
		True
	],

	Test["The length of Scale matches NumberOfDimensions:",
		Length[Lookup[packet,Scale]]==Lookup[packet,NumberOfDimensions],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisCompositionQTests*)


validAnalysisCompositionQTests[packet:PacketP[Object[Analysis,Composition]]]:={

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			StandardSamples,
			StandardData,
			AssaySamples,
			AssayData
		}
	],

	(* Standards peak information is required together *)
	RequiredTogetherTest[packet,
		{
			StandardPositions,
			StandardHeights,
			StandardAreas,
			StandardAdjacentResolutions,
			StandardTailing,
			StandardLabels,
			StandardModels
		}
	],

	(* Assay peak information is required together *)
	RequiredTogetherTest[packet,
		{
			AssayPositions,
			AssayHeights,
			AssayAreas,
			AssayAdjacentResolutions,
			AssayTailing,
			AssayLabels,
			AssayModels
		}
	],

	(* If analysis succeeded, all following fields should be informed together *)
	RequiredTogetherTest[packet,
		{
			StandardCompositions,
			DilutionFactors,
			AliquotCompositions,
			AssayCompositions
		}
	],
	RequiredTogetherTest[packet,
		{
			StandardCurveFitAnalyses,
			StandardCurveFitFunctions
		}
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisDNASequencingQTests*)


validAnalysisDNASequencingQTests[packet:PacketP[Object[Analysis,DNASequencing]]]:={

	(* Shared fields which should be Null *)
	NullFieldTest[packet,ReferenceField],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			PeaksAnalyses,
			SequenceAssignment,
			SequenceBases,
			QualityValues,
			SequencePeakPositions,
			UntrimmedSequenceBases,
			UntrimmedQualityValues,
			UntrimmedSequencePeakPositions,
			SequencingElectropherogramTraceA,
			SequencingElectropherogramTraceC,
			SequencingElectropherogramTraceG,
			SequencingElectropherogramTraceT
		}
	],

	(* Shared fields which should not be null *)
	RequiredTogetherTest[packet,{BaseProbabilities,UntrimmedBaseProbabilities}]
};


(* ::Subsection::Closed:: *)
(*validAnalysisDownsamplingQTests*)


validAnalysisDownsamplingQTests[packet:PacketP[Object[Analysis,Downsampling]]]:={

	(* Shared fields which should be Null *)
	NullFieldTest[packet,LegacyID],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			OriginalDimension,
			DataUnits,
			DownsamplingRate,
			DimensionRange,
			DownsampledDataFile
		}
	],

	(* Shared fields which must both be informed if either is not Null *)
	RequiredTogetherTest[packet,{Reference,ReferenceField}],

	Test["Each original dimension is present in the downsampled data:",
		Sort[packet[OriginalDimension]]==Range[Length[packet[OriginalDimension]]],
		True
	],

	Test["The last entry in SamplingGridPoints is Null:",
		MatchQ[Last@packet[SamplingGridPoints],{Null..}],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisDynamicLightScatteringLoadingQTests*)


validAnalysisDynamicLightScatteringLoadingQTests[packet:PacketP[Object[Analysis,DynamicLightScatteringLoading]]]:={

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			TimeThreshold,
			CorrelationThreshold
		}
	]
};

(* ::Subsection::Closed:: *)
(*validAnalysisEpitopeBinningQTests*)


validAnalysisEpitopeBinningQTests[packet:PacketP[Object[Analysis,EpitopeBinning]]]:={

	NotNullFieldTest[packet,
		{
			(*Shared fields not Null*)

			(*Unique fields not Null*)
			BlockingThreshold,
			PairwiseBlocking,
			BinnedInputs,
			BinnningKey
		}
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisCellCountQTests*)


validAnalysisCellCountQTests[packet:PacketP[Object[Analysis, CellCount]]] := {

	(* null shared fields *)
	NullFieldTest[packet,ReferenceField],

	(* not null unique fields *)
	NotNullFieldTest[packet,{
			ReferenceImage,
			AdjustedImage,
			HighlightedCells,
			Confluency,
			NumberOfCells,
			ImageDataLookup
		}
	]

};


(* ::Subsection::Closed:: *)
(*validAnalysisCompensationMatrixQTests*)


validAnalysisCompensationMatrixQTests[packet:PacketP[Object[Analysis,CompensationMatrix]]]:={
	(* Shared fields which should be Null *)
	NullFieldTest[packet,ReferenceField],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			Detectors,
			AdjustmentSampleData,
			CompensationMatrix
		}
	],

	Test["CompensationMatrix has correct dimensions:",
		MatchQ[Dimensions[Lookup[packet,CompensationMatrix]],{Length@Lookup[packet,Detectors],Length@Lookup[packet,Detectors]}],
		True
	],

	Test["Detectors does not contain duplicates:",
		DuplicateFreeQ[Lookup[packet,Detectors]],
		True
	],

	Test["If UnstainedSampleData is informed, then no thresholds, otherwise there are thresholds:",
		If[MatchQ[Lookup[packet,UnstainedSampleData],ListableP[Null]|{}],
			!MatchQ[Lookup[packet,DetectionThresholds],ListableP[Null]|{}],
			MatchQ[Lookup[packet,DetectionThresholds],ListableP[Null]|{}]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisCopyNumberQTests*)


validAnalysisCopyNumberQTests[packet:PacketP[Object[Analysis,CopyNumber]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		Reference,
		ReferenceField,

		(*Unique fields not Null*)
		Protocol,
		Data,
		Template,
		StandardCurve,
		CopyNumber,
		Efficiency
		}
	],


	(*Required together*)
	RequiredTogetherTest[packet,{
		ForwardPrimer,
		ReversePrimer
		}
	]

};


validAnalysisCrystalStructureQTests[packet:PacketP[Object[Analysis, CrystalStructure]]] := {

	(* Must be linked to a data object *)
	NotNullFieldTest[packet,{Reference}]

};

(* ::Subsection::Closed:: *)
(*validAnalysisDynamicLightScatteringQTests*)


validAnalysisDynamicLightScatteringQTests[packet:PacketP[Object[Analysis,DynamicLightScattering]]]:={

	NotNullFieldTest[packet,{
		(*Unique fields not Null*)
		ZAverageDiameters,
		AverageViscosity,
		RefractiveIndex
	}
	]

};

(* ::Subsection::Closed:: *)
(*validAnalysisColoniesQTests*)


validAnalysisColoniesQTests[packet:PacketP[Object[Analysis,Colonies]]]:={

	NotNullFieldTest[packet,
		{
			(*Unique fields not Null*)
			TotalColonyCount,
			AverageDiameter,
			AverageRegularity
		}
	]

};





(* ::Subsection::Closed:: *)
(*validAnalysisQuantificationCycleQTests*)


validAnalysisQuantificationCycleQTests[packet:PacketP[Object[Analysis,QuantificationCycle]]]:={

	NotNullFieldTest[packet,{
		(*Shared fields not Null*)
		Reference,
		ReferenceField,

		(*Unique fields not Null*)
		Protocol,
		Method,
		Domain,
		BaselineDomain,
		Template,
		FittingDataPoints,
		ExcitationWavelength,
		EmissionWavelength,
		QuantificationCycle
		}
	],


	(*Required together*)
	RequiredTogetherTest[packet,{
		ForwardPrimer,
		ReversePrimer,
		Threshold
		}
	],
	RequiredTogetherTest[packet,{
		SmoothingRadius,
		AmplificationFit
		}
	]

};


(* ::Subsection::Closed:: *)
(*validAnalysisFitQTests*)


validAnalysisFitQTests[packet:PacketP[Object[Analysis,Fit]]]:={

	RequiredTogetherTest[packet,{Reference,ReferenceField}],

	(* unique field which should NOT be null *)
	NotNullFieldTest[packet,{
		BestFitFunction,
		SymbolicExpression,
		ExpressionType,
		BestFitExpression,
		BestFitParameters,
		Response,
		PredictedResponse,
		BestFitResiduals,
		BestFitVariables,
		DataPoints
		}
	],


	Test[
		"DataUnits should match size of DataPoints:",
		SameQ[Length[First[packet[DataPoints]]],Length[packet[DataUnits]]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisFlowCytometryQTests*)


validAnalysisFlowCytometryQTests[packet:PacketP[Object[Analysis,FlowCytometry]]]:={
	(* Shared fields which should be Null *)
	NullFieldTest[packet,ReferenceField],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,
		{
			CellCounts,
			AbsoluteCellCounts,
			NumberOfDimensions,
			DimensionLabels,
			DimensionUnits,
			ClusteredData
		}
	],

	Test["ClusterLabels are keys of the ClusteredData association:",
		SubsetQ[Keys[Lookup[packet,ClusteredData]],Lookup[packet,ClusterLabels]],
		True
	],

	Test["The length of DimensionLabels matches NumberOfDimensions:",
		Or[
			MatchQ[Lookup[packet,DimensionLabels],None],
			Length[Lookup[packet,DimensionLabels]]==Lookup[packet,NumberOfDimensions]
		],
		True
	],

	Test["The length of DimensionUnits matches NumberOfDimensions:",
		Length[Lookup[packet,DimensionUnits]]==Lookup[packet,NumberOfDimensions],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisFractionsQTests*)


validAnalysisFractionsQTests[packet:PacketP[Object[Analysis,Fractions]]]:={
	(* not null *)
	NotNullFieldTest[packet,{FractionatedSamples,Reference}],

	(* null *)
	NullFieldTest[packet,ReferenceField]
};


(* ::Subsection::Closed:: *)
(*validAnalysisGatingQTests*)


validAnalysisGatingQTests[packet: PacketP[Object[Analysis,Gating]]] := {
	(* Null *)
	NullFieldTest[packet, ReferenceField],

	(* Shared field which should NOT be null *)
	NotNullFieldTest[packet, Reference],

	(* not null *)
	NotNullFieldTest[packet, {
		Dimensions,
		Channels,
		DimensionUnits,
		DistanceFunction,
		ClusterMethod,
		NumberOfGroups,
		GroupData
	}
	],

	(* misc *)
	Test["If Quadrant is NotNull, ClusterMethod should be Quadrant:",
		If[
			!NullQ[Lookup[packet,Quadrant]]&&Lookup[packet,Quadrant]!={},
			MatchQ[Lookup[packet,ClusterMethod],Quadrant],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisKineticsQTests*)


validAnalysisKineticsQTests[packet:PacketP[Object[Analysis, Kinetics]]] := {
	(* Null *)
	NullFieldTest[packet,ReferenceField],

	(*Field Tests*)
	NotNullFieldTest[packet, {
		Species,
		FitMechanism,
		Rates,
		ReactionMechanism,
		NumberOfIterations,
		TrainingData,
		Residual
		}
	]
};



(* ::Subsection::Closed:: *)
(*validAnalysisLadderQTests*)


validAnalysisLadderQTests[packet:PacketP[Object[Analysis,Ladder]]] := {
	(* Unique field which should NOT be null *)
	NotNullFieldTest[packet, {
		Sizes,
		SizeUnit,
		PositionUnit,
		FragmentPeaks,
		PeaksAnalysis
		}
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisMeltingPointQTests *)


validAnalysisMeltingPointQTests[packet:PacketP[Object[Analysis,MeltingPoint]]] := {
	(* Shared fields - Null *)
	NullFieldTest[packet,ReferenceField],
	(* Shared fields - Not null *)
	NotNullFieldTest[packet, {MeltingTemperature}],

	RequiredTogetherTest[packet,{TopBaseline,BottomBaseline}],
	RequiredTogetherTest[packet,{MeltingTemperatureStandardDeviation,MeltingTemperatureDistribution}],

	Test[
		"At least one of CoolingCurveFractionBound, MeltingCurveFractionBound, SecondaryCoolingCurveFractionBound, SecondaryMeltingCurveFractionBound,TertiaryCoolingCurveFractionBound, or TertiaryMeltingCurveFractionBound is informed",
	 	Or @@ (Not /@ (NullQ /@ Lookup[packet, {CoolingCurveFractionBound, MeltingCurveFractionBound, SecondaryCoolingCurveFractionBound, SecondaryMeltingCurveFractionBound,TertiaryCoolingCurveFractionBound, TertiaryMeltingCurveFractionBound,MeltingCurveSmoothedDataPoints,AggregationCurveSmoothedDataPoints,SecondaryAggregationCurveSmoothedDataPoints}])),
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisMicroscopeOverlayQTests*)


validAnalysisMicroscopeOverlayQTests[packet:PacketP[Object[Analysis,MicroscopeOverlay]]] := {
	(* Null *)
	NullFieldTest[packet, ReferenceField],

	(* Shared field which should NOT be null *)
	NotNullFieldTest[packet,{Reference, ChannelsOverlaid,Overlay,OverlayFile}]

};


(* ::Subsection::Closed:: *)
(*validAnalysisPeaksQTests*)


validAnalysisPeaksQTests[packet:PacketP[Object[Analysis,Peaks]]]:={
	(* Shared fields which should not be null *)
	RequiredTogetherTest[packet,{Reference,ReferenceField}],

	(* Slicing information must be present together *)
	RequiredTogetherTest[packet,{ReferenceDataSliceDimension,ReferenceDataSlice,SliceReductionFunction}],

	(* NMR information fields must be present together *)
	RequiredTogetherTest[packet,{NMROperatingFrequency,NMRNucleus}],

	(* NMR peak fields must occur together if at least one peak was found *)
	RequiredTogetherTest[packet,{
		NMRSplittingGroup,
		NMRChemicalShift,
		NMRNuclearIntegral,
		NMRMultiplicity,
		NMRJCoupling
	}],

	(* Fields which must be informed *)
	NotNullFieldTest[packet,{BaselineFunction}],

	Test["PeakRange and WidthRange should be valid ranges:",
		If[!MatchQ[Lookup[packet, WidthRangeEnd],{Null...}],First@(Apply[And, NonPositive[(#[[1]] - #[[2]])]] & /@ {Lookup[packet, {WidthRangeEnd, PeakRangeEnd}]}) && First@(Apply[And, Negative[(#[[1]] - #[[2]])]] & /@ {Lookup[packet, {WidthRangeStart, WidthRangeEnd}]}) && First@(Apply[And, NonPositive[(#[[1]] - #[[2]])]] & /@ {Lookup[packet, {WidthRangeEnd, PeakRangeEnd}]}),True],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisStandardCurveQTests*)


validAnalysisStandardCurveQTests[packet:PacketP[Object[Analysis,StandardCurve]]]:={

	(* Ensure the following fields are not Null *)
	NotNullFieldTest[packet,{
		InversePrediction,
		StandardDataPoints,
		StandardDataUnits,
		StandardCurveFit,
		StandardCurveDomain,
		StandardCurveRange
	}],

	Test["There should be one entry in PredictedValues per input:",
		SameQ[Length[packet[InputDataPoints]],Length[packet[PredictedValues]]],
		True
	],

	Test["The linked AnalyzeFit object for the Standard Curve is valid:",
		ValidObjectQ[packet[StandardCurveFit]],
		True
	],

	Test["Shared fields with the linked AnalyzeFit object are identical:",
		Module[{sharedFieldsWithFit,fitPacket},
			(* List of fields that are shared with linked Fit object *)
			sharedFieldsWithFit={
				SymbolicExpression,ExpressionType,BestFitFunction,BestFitExpression,
				BestFitParameters,BestFitParametersDistribution,MarginalBestFitDistribution,BestFitVariables,
				ANOVATable,ANOVAOfModel,ANOVAOfError,ANOVAOfTotal,FStatistic,FCritical,FTestPValue,
				RSquared,AdjustedRSquared,AIC,AICc,BIC,EstimatedVariance,SumSquaredError,StandardDeviation
			};

			(* Download the packet for the linked Fit object *)
			fitPacket=Download[packet[StandardCurveFit]];

			(* Compare the contents of shared fields in the two linked objects *)
			SameQ[Lookup[packet,sharedFieldsWithFit],Lookup[fitPacket,sharedFieldsWithFit]]
		],
		True
	],

	Test["Standard curve domain is a valid range:",
		(Length[packet[StandardCurveDomain]]===2)&&(First[packet[StandardCurveDomain]]<=Last[packet[StandardCurveDomain]]),
		True
	],

	Test["Standard curve range is a valid range:",
		(Length[packet[StandardCurveRange]]===2)&&(First[packet[StandardCurveRange]]<=Last[packet[StandardCurveRange]]),
		True
	],

	Test["Standard Data units are valid:",
		Length[packet[StandardDataUnits]]==2,
		True
	],

	Test["Input data units match the Standard Data Units:",
		Module[{inputUnits,standardXUnits,standardYUnits,inverseQ},
			(* Get necessary fields from the object packet*)
			If[MatchQ[Lookup[packet, InputDataPoints], {}], Return[True]];
			inputUnits=packet[InputDataUnits];
			{standardXUnits,standardYUnits}=packet[StandardDataUnits];
			inverseQ=packet[InversePrediction];

			(* Check for unit consistency *)
			If[inverseQ,
				(inputUnits===standardYUnits)||(inputUnits===1)||(standardYUnits===1),
				(inputUnits===standardXUnits)||(inputUnits===1)||(standardXUnits===1)
			]
		],
		True
	],

	Test["If the InputData field is not populated, then ReferenceStandardCurve field cannot be populated:",
		If[MatchQ[packet[InputData], {}],
			MatchQ[packet[ReferenceStandardCurve], Null],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisTotalProteinQuantificationQTests*)


validAnalysisTotalProteinQuantificationQTests[packet:PacketP[Object[Analysis,TotalProteinQuantification]]] := {

	(* Null field test *)
	NullFieldTest[packet, ReferenceField],

	(* Not Null field test *)
	NotNullFieldTest[packet,{

		(* Shared fields - not Null *)
		Reference,
		(* Unique fields - not Null *)
		SamplesIn,
		AssaySamples,
		LoadingVolume,
		QuantificationReagent,
		QuantificationReagentVolume,
		QuantificationWavelengths,
		StandardCurve,
		QuantificationSamples,
		AssaySamplesProteinConcentrations,
		SamplesInProteinConcentrations,
		SamplesInConcentrationDistributions,
		InputSamplesSpectroscopyData
	}],

	(* The Index-matched fields must be the same length *)
	Test["Length of AssaySamples/AssaySampleDilutionFactors/AssaySamplesProteinConcentrations/SamplesInProteinConcentrations/QuantificationSamples/InputSamplesSpectroscopyData must equal the Length of SamplesIn:",
		And[
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,AssaySamples]],
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,AssaySamplesDilutionFactors]],
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,AssaySamplesProteinConcentrations]],
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,SamplesInProteinConcentrations]],
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,QuantificationSamples]],
			Length[Lookup[packet,SamplesIn]]==Length[Lookup[packet,InputSamplesSpectroscopyData]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validAnalysisThermodynamicsQTests*)


validAnalysisThermodynamicsQTests[packet:PacketP[Object[Analysis,Thermodynamics]]] := {

	(* Null *)
	NullFieldTest[packet,ReferenceField],

	NotNullFieldTest[packet, {

		(* Shared fields which should NOT be null *)
		Reference,

		(* Unique fields which should NOT be null *)
		Enthalpy,
		Entropy,
		AffinityConstants,
		Fit,
		EquilibriumType
		}
	]

};


(* ::Subsection::Closed:: *)
(*validAnalysisFitQTests*)


validAnalysisSmoothingQTests[packet:PacketP[Object[Analysis,Smoothing]]]:={

	(* unique field which should NOT be null *)
	NotNullFieldTest[packet,{
		ResolvedDataPoints,
		SmoothedDataPoints,
		SmoothingLocalStandardDeviation,
		Residuals,
		TotalResidual
		}
	],


	Test[
		"ResolvedDataPoints should match size of SmoothedDataPoints:",
		SameQ[Length[packet[ResolvedDataPoints]],Length[packet[SmoothedDataPoints]]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*Test Registration*)


registerValidQTestFunction[Object[Analysis],validAnalysisQTests];
registerValidQTestFunction[Object[Analysis, AbsorbanceQuantification],validAnalysisAbsorbanceQuantificationQTests];
registerValidQTestFunction[Object[Analysis, BindingKinetics],validAnalysisBindingKineticsQTests];
registerValidQTestFunction[Object[Analysis, BindingQuantitation],validAnalysisBindingQuantitationQTests];
registerValidQTestFunction[Object[Analysis, BubbleRadius],validAnalysisBubbleRadiusQTests];
registerValidQTestFunction[Object[Analysis, CellCount],validAnalysisCellCountQTests];
registerValidQTestFunction[Object[Analysis, Colonies],validAnalysisColoniesQTests];
registerValidQTestFunction[Object[Analysis, Clusters],validAnalysisClustersQTests];
registerValidQTestFunction[Object[Analysis, CompensationMatrix],validAnalysisCompensationMatrixQTests];
registerValidQTestFunction[Object[Analysis, Composition],validAnalysisCompositionQTests];
registerValidQTestFunction[Object[Analysis, CopyNumber],validAnalysisCopyNumberQTests];
registerValidQTestFunction[Object[Analysis, DNASequencing],validAnalysisDNASequencingQTests];
registerValidQTestFunction[Object[Analysis, Downsampling],validAnalysisDownsamplingQTests];
registerValidQTestFunction[Object[Analysis, DynamicLightScatteringLoading],validAnalysisDynamicLightScatteringLoadingQTests];
registerValidQTestFunction[Object[Analysis, DynamicLightScattering],validAnalysisDynamicLightScatteringQTests];
registerValidQTestFunction[Object[Analysis, EpitopeBinning],validAnalysisEpitopeBinningQTests];
registerValidQTestFunction[Object[Analysis, Fit],validAnalysisFitQTests];
registerValidQTestFunction[Object[Analysis, FlowCytometry],validAnalysisFlowCytometryQTests];
registerValidQTestFunction[Object[Analysis, Fractions],validAnalysisFractionsQTests];
registerValidQTestFunction[Object[Analysis, Gating],validAnalysisGatingQTests];
registerValidQTestFunction[Object[Analysis, Kinetics],validAnalysisKineticsQTests];
registerValidQTestFunction[Object[Analysis, Ladder],validAnalysisLadderQTests];
registerValidQTestFunction[Object[Analysis, MeltingPoint],validAnalysisMeltingPointQTests];
registerValidQTestFunction[Object[Analysis, MicroscopeOverlay],validAnalysisMicroscopeOverlayQTests];
registerValidQTestFunction[Object[Analysis, Peaks],validAnalysisPeaksQTests];
registerValidQTestFunction[Object[Analysis, QuantificationCycle],validAnalysisQuantificationCycleQTests];
registerValidQTestFunction[Object[Analysis, StandardCurve],validAnalysisStandardCurveQTests];
registerValidQTestFunction[Object[Analysis, Thermodynamics],validAnalysisThermodynamicsQTests];
registerValidQTestFunction[Object[Analysis, TotalProteinQuantification],validAnalysisTotalProteinQuantificationQTests];
registerValidQTestFunction[Object[Analysis, Smoothing],validAnalysisSmoothingQTests];
