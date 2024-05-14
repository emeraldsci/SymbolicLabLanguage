(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeTotalProteinQuantification*)


(* ::Subsubsection:: *)
(*AnalyzeTotalProteinQuantification Options and Messages*)


DefineOptions[AnalyzeTotalProteinQuantification,
	Options:>{
		{
			OptionName->QuantificationWavelengths,
			Default->Automatic,
			Description->"The wavelength(s) at which quantification analysis is performed to determine TotalProteinConcentration. If multiple wavelengths are specified, the absorbance or fluorescence values from the wavelengths are averaged for standard curve determination and quantification analysis.",
			ResolutionDescription->"The QuantificationWavelengths is set to be the input protocol object's QuantificationWavelengths.",
			AllowNull->False,
			Widget->Adder[
				Widget[
					Type ->Quantity,
					Pattern :> RangeP[320*Nanometer,1000*Nanometer],
					Units:>Nanometer
				]
			]
		},
		{
			OptionName->StandardCurve,
			Default->Null,
			Description->"The existing StandardCurve which absorbance or fluorescence data is compared to for TotalProteinConcentration quantification. If the StandardCurve option is set, the data from the input protocol's QuantificationSpectroscopyProtocol is not used to generate a standard curve.",
			AllowNull->True,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Object[Analysis, TotalProteinQuantification],Object[Analysis, Fit]}]
			]
		},
		{
			OptionName->StandardCurveFitType,
			Default->Automatic,
			Description->"The type of mathematical fit used to calculate the StandardCurve from the absorbance or fluorescence data.",
			ResolutionDescription->"The StandardCurveFitType is automatically set to be Tanh if the StandardCurve option is not specified, and to be Null otherwise.",
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[Linear,Sigmoid, Cubic, Tanh]
			]
		},
		{
			OptionName->UploadConcentration,
			Default->False,
			Description->"Indicates if the average calculated TotalProteinConcentrations should be uploaded to each unique SampleIn by calling UploadSampleProperties on the unique SamplesIn and their associated TotalProteinConcentrations.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName -> ParentProtocol,
			Default -> False,
			Description -> "Indicates if this analysis has a parent protocol. If True, then it does not set the author in the upload packet. Otherwise the author is whoever running this analysis.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Hidden"
		},
		OutputOption,
		UploadOption,
		AnalysisTemplateOption
	}
];
(* Messages *)
Error::AnalyzeTPQInvalidProtocol="The input protocol, `1`, has a Status, `2`, that is not Completed. AnalyzeTotalProteinQuantification only accepts Completed protocols as inputs.";
Error::AnalyzeTPQInvalidQuantificationWavelengths="The following members of the QuantificationWavelengths option, `1`, are not within the EmissionWavelengthRange, `2`. Please ensure that the specified QuantificationWavelengths are in the EmissionWavelengthRange.";
Error::AnalyzeTPQConflictingStandardCurveOptions="The StandardCurve and StandardCurveFitType options are in conflict. The options cannot both be Null, or both be specified.";
Error::AnalyzeTPQInvalidStandardCurveUnits="The supplied StandardCurve option, `1`, has a StandardCurve with DataUnits `2`, that are not acceptable for the DetectionMode, `3`. The acceptable DataUnits for Absorbance are {1 milligram per milliliter, 1 AbsorbanceUnit}, and for Fluorescence are {1 milligram per milliliter, 1 Rfus}.";
Warning::AnalyzeTPQConcentrationIncalculable="The TotalProteinConcentration of the following AssaySamples, `1`, which correspond to the SamplesIn, `2`, cannot be calculated. Solutions for x (TotalProteinConcentration) to the following equation, y = `3`, when substituting the associated Absorbance or Fluorescence values as y, `4`, do not exist or are negative. This can occur for Sigmoidal standard curve fitting when the TotalProteinConcentration of the AssaySample is outside of the dynamic range of the assay, or for some Cubic fits. To obtain concentration information, please set the StandardCurveFitType to Linear. Alternatively, the TotalProteinConcentration can be measured by running ExperimentTotalProteinQuantification on input samples that are more dilute.";
Warning::AnalyzeTPQPoorStandardCurveFit="The fit analysis, `1`, has an R-squared value, `2`, which is lower than 0.95. This analysis was performed at the following QuantificationWavelength(s), `3`, using `4` as the StandardCurveFitType. It is possible that the QuantificationWavelength used was not ideal. Please consider trying other QuantificationWavelengths, or changing the StandardCurveFitType.";
Warning::AnalyzeTPQCalculatedConcentrationsExtrapolated="The following members of AssaySamples, `1`, have calculated TotalProteinConcentrations, `2`, that fall outside of the range of concentrations used to create the Standard Curve, between 0 milligrams per milliliter and `3`. The AssaySamples correspond to the InputSamples, `4`, and their calculated TotalProteinConcentrations, `5`. These extrapolated concentrations should be treated with caution, as they are likely to be less accurate than values within the range of the standard curve. If the calculated concentration is larger than `3`, please consider diluting the sample further for future TotalProteinQuantification experiments.";


(* ::Subsubsection:: *)
(*AnalyzeTotalProteinQuantification Source Code*)


AnalyzeTotalProteinQuantification[myProtocol:ObjectP[Object[Protocol,TotalProteinQuantification]],ops:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,standardFieldsStart,gatherTests,messages,notInEngine,safeOptions,safeOptionTests,validLengths,validLengthTests,unresolvedOptions,templateTests,combinedOptions,
		protocolPacket,absorbanceSpectroscopyDataPackets,fluorescenceSpectroscopyDataPackets,spectroscopySamplesInPacket,
		suppliedQuantificationWavelengths,suppliedStandardCurve,suppliedStandardCurveFitType,suppliedParentProtocol,suppliedUploadConcentration,upload,standardCurveDownloadFields,
		listedProtocolAbsorbanceFluorescencePackets,listedStandardCurvePacket,standardCurvePacket,
		detectionMode,emissionWavelengthRange,standardCurveConcentrations,standardCurveReplicates,samplesIn,workingSamples,aliquotSamplePreparation,excitationWavelength,status,
		quantificationReagent,loadingVolume,quantificationReagentVolume,
		samplesInObjects,workingSamplesObjects,assaySamples,quantificationReagentObject,
		quantificationPlateAllSamples,numberOfStandardCurveWells,quantificationPlateStandardSamples,quantificationPlateInputSamples,
		standardCurveOptionRSquared,standardCurveOptionDataPoints,standardCurveOptionDataUnits,standardCurveOptionExpressionType,
		standardCurveOptionFitObject,standardCurveOptionBestFitExpression,invalidProtocolStatusInputs,protocolStatusTests,
		invalidQuantificationWavelengths,validQuantificationWavelengths,invalidQuantificationWavelengthOption,quantificationWavelengthsTests,validStandardCurveUnitsQ,invalidStandardCurveUnitOptions,
		validStandardCurveUnitsTests,invalidStandardCurveOptions,validStandardCurveOptions,standardCurveOptionTests,
		resolvedQuantificationWavelengths,resolvedStandardCurveFitType,invalidOptions,resolvedOptionResult,resolvedOptions,spectroscopyDataPackets,spectroscopyDataObjects,
		standardSpectroscopyDataObjects,sampleSpectroscopyDataObjects,unitlessIntegerQuantificationWavelengths,
		quantificationWavelengthDataPattern,unitlessDataValues,meanUnitlessDataValues,unitlessStandardCurveWellData,expandedStandardCurveConcentrations,
		unitlessInputSampleWellData,standardCurvePointsForAnalyzeFit,fitAnalysisResult,
		fitAnalysisObject,bestFitExpression,rSquared,standardCurveExpressionType,initialUnitlessSampleWellBestFits,unitlessSampleWellBestFitsNoImaginary,
		unitlessSampleWellBestFits,solvedAssaySamples,unsolvedAssaySamples,solvedSamplesIn,unsolvedSamplesIn,
		unsolvedInputSampleWellData,incalculableTests,solvedUnitlessSampleWellBestFits,
		unitlessSampleWellConcentrations,solvedAssaySamplesConcentrations,assaySampleDilutionFactors,solvedAssaySampleDilutionFactors,solvedSamplesInConcentrations,rSquaredTests,
		maxStandardCurveConcentration,extrapolatedAssaySampleConcentrations,extrapolatedAssaySamples,extrapolatedSamplesInConcentrations,extrapolatedSamplesIn,notExtrapolatedAssaySamples,
		extrapolatedAssaySampleConcentrationsTests,
		notExtrapolatedAssaySampleConcentrations,
		samplesInConcentrationRules,uniqueSamplesInConcentrationAndDistributionAssociation,uniqueSamplesIn,uniqueSamplesInTotalProteinConcentrations,
		uniqueSamplesInConcentrationDistributions,uniqueSolvedSamplesInConcentrationRules,unsolvedSamplesInNoSolved,samplesInConcentrationReplaceRules,allSamplesInTotalProteinConcentrations,unsolvedAssaySamplesNoSolved,
		solvedQuantificationPlateInputSamples,unsolvedQuantificationPlateInputSamples,quantificationPlateInputSampleConcentrationReplaceRules,

		assaySamplesConcentrationReplaceRules,allAssaySamplesTotalProteinConcentrations,
		samplesInConcentrationDistributionReplaceRules,
		allSamplesInConcentrationDistributions,uploadSamplePropertiesResult,
		analysisID,standardCurveConcentrationsField,standardSpectroscopyDataField,standardCurveReplicatesField,quantitificationStandardsField,
		analysisPacket,allTests,previewRule,optionsRule,testsRule,analysisObject,resultRule,
		quantifiableOnStandardCurve
	},
	
	(* Make sure we're working with a list of options *)
	listedOptions = ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* fixed starting fields *)
	standardFieldsStart = analysisPacketStandardFieldsStart[{ops}];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[AnalyzeTotalProteinQuantification, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[AnalyzeTotalProteinQuantification, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length; since we have two input options need to have this goofy Switch *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[AnalyzeTotalProteinQuantification, {myProtocol}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[AnalyzeTotalProteinQuantification, {myProtocol}, listedOptions], Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[AnalyzeTotalProteinQuantification, {myProtocol}, listedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[AnalyzeTotalProteinQuantification, {myProtocol}, listedOptions], Null}
	];

	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* - Pull out the supplied options from combinedOptions - *)
	{
		suppliedQuantificationWavelengths,suppliedStandardCurve,suppliedStandardCurveFitType,suppliedParentProtocol,upload,suppliedUploadConcentration
	}=Lookup[combinedOptions,
		{
			QuantificationWavelengths,StandardCurve,StandardCurveFitType,ParentProtocol,Upload,UploadConcentration
		}
	];

	(* -- Assemble big download -- *)
	(* - First, determine which fields, if any, we need to download from the StandardCurve option - *)
	standardCurveDownloadFields=Which[

		(* In the case where the StandardCurve option has been left as Null, we don't need to download anything *)
		MatchQ[suppliedStandardCurve,Null],
			{},

		(* In the case where the StandardCurve option is an Object[Analysis,TotalProteinQuantification], we download fields from the StandardCurve Link Field *)
		MatchQ[suppliedStandardCurve,ObjectP[Object[Analysis,TotalProteinQuantification]]],
			Packet[
				StandardCurve[{RSquared,DataPoints,DataUnits,ExpressionType,BestFitExpression}]
			],

		(* In the case where the StandardCurve option is an Object[Analysis,Fit], we download fields right from this object *)
		MatchQ[suppliedStandardCurve,ObjectP[Object[Analysis,Fit]]],
			Packet[
				RSquared,DataPoints,DataUnits,ExpressionType,BestFitExpression
			]
	];

	{
		listedProtocolAbsorbanceFluorescencePackets,listedStandardCurvePacket
	}=Quiet[Download[
		{
			myProtocol,
			suppliedStandardCurve
		},
		{
			{
				Packet[
					SamplesIn, WorkingSamples, StandardCurveConcentrations, StandardCurveReplicates, NumberOfReplicates, AliquotSamplePreparation, QuantificationWavelengths,
					EmissionWavelengthRange, DetectionMode, ExcitationWavelength, Status,QuantificationReagent,LoadingVolume, QuantificationReagentVolume
				],
				Packet[
					QuantificationSpectroscopyProtocol[Data][{AbsorbanceSpectrum, Well}]
				],
				Packet[
					QuantificationSpectroscopyProtocol[Data][{EmissionSpectrum, Well}]
				],
				Packet[
					QuantificationSpectroscopyProtocol[SamplesIn]
				]
			},
			{standardCurveDownloadFields}
		}
	],Download::FieldDoesntExist];

	(* Pull out the relevant packets from the listed packets *)
	protocolPacket=listedProtocolAbsorbanceFluorescencePackets[[1]];
	absorbanceSpectroscopyDataPackets=listedProtocolAbsorbanceFluorescencePackets[[2]];
	fluorescenceSpectroscopyDataPackets=listedProtocolAbsorbanceFluorescencePackets[[3]];
	spectroscopySamplesInPacket=listedProtocolAbsorbanceFluorescencePackets[[4]];
	standardCurvePacket=If[MatchQ[listedStandardCurvePacket,Null],
		{},
		First[listedStandardCurvePacket]
	];

	(* - Next, pull our relevant fields from the Protocol Object - *)
	{
		detectionMode,emissionWavelengthRange,standardCurveConcentrations,standardCurveReplicates,samplesIn,workingSamples,aliquotSamplePreparation,excitationWavelength,status,
		quantificationReagent,loadingVolume,quantificationReagentVolume
	}=Lookup[Flatten[Normal[protocolPacket]],
		{
			DetectionMode,EmissionWavelengthRange,StandardCurveConcentrations,StandardCurveReplicates,SamplesIn,WorkingSamples,AliquotSamplePreparation,ExcitationWavelength,Status,
			QuantificationReagent,LoadingVolume, QuantificationReagentVolume
		}
	];

	(* Pull out the SamplesIn and WorkingSamples from the TPQ Protocol, and define the AssaySamples *)
	samplesInObjects=Download[samplesIn,Object];
	workingSamplesObjects=Download[workingSamples,Object];
	assaySamples=If[MatchQ[workingSamplesObjects,{}],
		samplesInObjects,
		workingSamplesObjects
	];

	(* Get the QuantificationReagent *)
	quantificationReagentObject=Download[quantificationReagent,Object];

	(* Pull out the Spectroscopy subprotocol's SamplesIn *)
	quantificationPlateAllSamples=Download[Lookup[spectroscopySamplesInPacket,SamplesIn],Object];

	(* - Define how many wells of the QuantificationPlate are taken up with the with the StandardCurve and replicates, and split quantificationPlateAllSamples into StandardCurveSamples and input samples - *)
	numberOfStandardCurveWells=(Length[standardCurveConcentrations]*standardCurveReplicates);

	(* Standard Curve samples in QuantificationPlate *)
	quantificationPlateStandardSamples=Take[quantificationPlateAllSamples,numberOfStandardCurveWells];

	(* Input Samples that are measured in the QuantificationPlate *)
	quantificationPlateInputSamples=Drop[quantificationPlateAllSamples,numberOfStandardCurveWells];

	(* - Next, pull our relevant info from the StandardCurve packet - *)
	{
		standardCurveOptionRSquared,standardCurveOptionDataPoints,standardCurveOptionDataUnits,standardCurveOptionExpressionType,standardCurveOptionFitObject,standardCurveOptionBestFitExpression
	}=Lookup[standardCurvePacket,
		{
			RSquared,DataPoints,DataUnits,ExpressionType,Object,BestFitExpression
		}
	];

	(* -- Here, figure out if we need to throw Errors and return failed -- *)
	(* - Check to see if the input protocol is valid - it must be Completed or Processing - *)
	invalidProtocolStatusInputs=If[MatchQ[status,Alternatives[Completed,Processing]],
		{},
		myProtocol
	];

	(* If are throwing messages, throw an Error if the protocol is not Completed *)
	If[messages&&Length[invalidProtocolStatusInputs]>0,
		Message[Error::AnalyzeTPQInvalidProtocol,ToString[myProtocol],ToString[status]]
	];

	(* If we are gathering tests, define the passing and failing tests *)
	protocolStatusTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidProtocolStatusInputs]==0,
				Nothing,
				Test["The input protocol has a Status of Completed or Processing",True,False]
			];
			passingTest=If[Length[invalidProtocolStatusInputs]>0,
				Nothing,
				Test["The input protocol has a Status of Completed or Processing",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Define the variables that will be empty lists if things are okay and non-empty lists if we need to throw an Error *)
	(* - Check that the QuantificationWavelengths are within the appropriate range (if DetectionMode is Fluorescence) - *)
	invalidQuantificationWavelengths=If[

		(* IF the DetectionMode is Absorbance, and the QuantificationWavelengths option has been specified *)
		MatchQ[detectionMode,Absorbance],

		(* THEN the QuantificationWavelengths option cannot be invalid *)
		{},

		(* ELSE, we need to check if there are any QuantificationWavelengths that are not in the EmissionWavelengthRange, if the option is not automatic *)
		If[MatchQ[suppliedQuantificationWavelengths,Automatic],
			{},
			Cases[suppliedQuantificationWavelengths,Except[RangeP[First[emissionWavelengthRange],Last[emissionWavelengthRange]]]]
		]
	];
	(* The valid QuantificationWavelengths are all of the ones that are not invalid *)
	validQuantificationWavelengths=Cases[suppliedQuantificationWavelengths,Except[Alternatives@@invalidQuantificationWavelengths]];

	(* Define the invalid QuantificationWavelengths option *)
	invalidQuantificationWavelengthOption=If[Length[invalidQuantificationWavelengths]==0,
		{},
		{QuantificationWavelengths}
	];

	(* If we are throwing messages and there are any invalid QuantificationWavelengths, throw an Error *)
	If[Length[invalidQuantificationWavelengths]>0&&messages,
		Message[Error::AnalyzeTPQInvalidQuantificationWavelengths,invalidQuantificationWavelengths,emissionWavelengthRange]
	];

	(* If we are gathering tests, define the passing and failing tests *)
	quantificationWavelengthsTests=If[gatherTests&&MatchQ[detectionMode,Fluorescence]&&MatchQ[suppliedQuantificationWavelengths,Except[Automatic]],
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidQuantificationWavelengths]==0,
				Nothing,
				Test["The following members of the QuantificationWavelength option, "<>ToString[invalidQuantificationWavelengths]<>" are not within the EmissionWavelengthRange, "<>ToString[emissionWavelengthRange]<>":",True,False]
			];
			passingTest=If[Length[validQuantificationWavelengths]==0,
				Nothing,
				Test["The following members of the QuantificationWavelength option, "<>ToString[validQuantificationWavelengths]<>" are not within the EmissionWavelengthRange, "<>ToString[emissionWavelengthRange]<>":",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Check that the StandardCurve option has the right data units, if it doesn't, return failed -- *)
	(* - First, define if the StandardCurve option units are valid - *)
	validStandardCurveUnitsQ=Which[

		(* In the case that the StandardCurve option is Null, the units are not invalid *)
		MatchQ[suppliedStandardCurve,Null],
			True,

		(* In the case that the DetectionMode is Absorbance and the standardCurveOptionDataUnits are {1*mg/mL and 1*AbsorbanceUnit}, the units are not invalid *)
		MatchQ[detectionMode,Absorbance]&&MatchQ[standardCurveOptionDataUnits,{1*Milligram/Milliliter, 1*AbsorbanceUnit}],
			True,

		(* In the case that the DetectionMode is Fluorescence and the standardCurveOptionDataUnits are {1*mg/mL and 1*RFU}, the units are not invalid *)
		MatchQ[detectionMode,Fluorescence]&&MatchQ[standardCurveOptionDataUnits,{1*Milligram/Milliliter, 1*RFU}],
			True,

		(* Otherwise, the StandardCurve option is invalid *)
		True,
			False
	];

	(* Define the invalid standard curve unit options *)
	invalidStandardCurveUnitOptions=If[validStandardCurveUnitsQ,
		{},
		{StandardCurve}
	];

	(* If we are throwing messages and there are any invalid QuantificationWavelengths, throw an Error *)
	If[!validStandardCurveUnitsQ&&messages,
		Message[Error::AnalyzeTPQInvalidStandardCurveUnits,ToString[suppliedStandardCurve],ToString[standardCurveOptionDataUnits],detectionMode]
	];

	(* If we are gathering tests and the StandardCurve option is not Null, define the passing and failing tests *)
	validStandardCurveUnitsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[validStandardCurveUnitsQ,
				Nothing,
				Test["The supplied StandardCurve option, "<>ToString[suppliedStandardCurve]<>", has a StandardCurve with DataUnits, "<>ToString[standardCurveOptionDataUnits]<>", that are not acceptable for the DetectionMode, "<>ToString[detectionMode]<>". The acceptable DataUnits for Absorbance are {1 milligram per milliliter, 1 AbsorbanceUnit}, and for Fluorescence are {1 milligram per milliliter, 1 Rfus}:",True,False]
			];
			passingTest=If[!validStandardCurveUnitsQ,
				Nothing,
				Test["The supplied StandardCurve option, "<>ToString[suppliedStandardCurve]<>", has a StandardCurve with DataUnits, "<>ToString[standardCurveOptionDataUnits]<>", that are acceptable for the DetectionMode, "<>ToString[detectionMode]<>". The acceptable DataUnits for Absorbance are {1 milligram per milliliter, 1 AbsorbanceUnit}, and for Fluorescence are {1 milligram per milliliter, 1 Rfus}:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* - Check that the StandardCurve and StandardCurveFit options are neither both set nor both Null - *)
	invalidStandardCurveOptions=Switch[{suppliedStandardCurve,suppliedStandardCurveFitType},

		(* If both options are Null, the options are invalid *)
		{Null,Null},
			{StandardCurve,StandardCurveFitType},

		(* If both options are specified, the options are invalid *)
		{Except[Null|Automatic],Except[Null|Automatic]},
			{StandardCurve,StandardCurveFitType},

		(* Otherwise, the options are fine *)
		{_,_},
			{}
	];
	validStandardCurveOptions=Cases[{StandardCurve,StandardCurveFitType},Except[Alternatives@@invalidStandardCurveOptions]];

	(* If we are throwing messages and there are any invalid StandardCurveOptions, throw an Error *)
	If[Length[invalidStandardCurveOptions]>0&&messages,
		Message[Error::AnalyzeTPQConflictingStandardCurveOptions]
	];

	(* If we are gathering tests, define the passing and failing tests *)
	standardCurveOptionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidStandardCurveOptions]==0,
				Nothing,
				Test["The StandardCurve and StandardCurveFitType options are in conflict. The options cannot both be Null or both be specified:",True,False]
			];
			passingTest=If[Length[validStandardCurveOptions]==0,
				Nothing,
				Test["The StandardCurve and StandardCurveFitType options are not in conflict. The options cannot both be Null or both be specified:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];
	
	(* -- Resolve the options -- *)
	(* - QuantificationWavelengths - *)
	resolvedQuantificationWavelengths=If[

		(* IF the option has been specified by the user *)
		MatchQ[suppliedQuantificationWavelengths,Except[Automatic]],

		(* THEN we accept it *)
		suppliedQuantificationWavelengths,

		(* ELSE we use the QuantificationWavelengths from the input protocol object *)
		Lookup[protocolPacket,QuantificationWavelengths]
	];

	(* - StandardCurveFitType - *)
	resolvedStandardCurveFitType=If[

		(* IF the option has been specified by the user *)
		MatchQ[suppliedStandardCurveFitType,Except[Automatic]],

		(* THEN we accept it *)
		suppliedStandardCurveFitType,

		(* ELSE, what we set it to depends on if the user has set the StandardCurve Option *)
		(* IF suppliedStandardCurve is Null *)
		If[MatchQ[suppliedStandardCurve,Null],

			(* THEN we set StandardCurveFitType to Tanh *)
			Tanh,

			(* ELSE we set it to Null *)
			Null
		]
	];

	(* Define the Invalid Options *)
	invalidOptions=DeleteDuplicates[Flatten[
		{
			invalidQuantificationWavelengthOption,invalidStandardCurveUnitOptions,invalidStandardCurveOptions
		}
	]];

	resolvedOptionResult=If[gatherTests,
		(* We are gathering tests, define the resolvedOptions *)
		resolvedOptions=ReplaceRule[
			combinedOptions,
			{
				QuantificationWavelengths->resolvedQuantificationWavelengths,
				StandardCurveFitType->resolvedStandardCurveFitType
			}
		];

		(* We are gathering tests, so run the tests to see if we encountered a failure *)
		If[RunUnitTest[<|"Tests"->Cases[Flatten[{quantificationWavelengthsTests,standardCurveOptionTests,validStandardCurveUnitsTests,protocolStatusTests}],_EmeraldTest]|>,OutputFormat->SingleBoolean,Verbose->False],
			resolvedOptions,
			$Failed
		],

		(* We are not gathering tests, check to see if any above Error is thrown (after defining resovledOptions) *)
		Check[
			resolvedOptions=ReplaceRule[
				combinedOptions,
				{
					QuantificationWavelengths->resolvedQuantificationWavelengths,
					StandardCurveFitType->resolvedStandardCurveFitType
				}
			];
			(
				(* Throw Error::InvalidOption if there are invalid options. *)
				If[Length[invalidOptions]>0&&!gatherTests,
					Message[Error::InvalidOption,invalidOptions]
				];
				(* Throw Error::InvalidInput if there are invalid inputs. *)
				If[Length[invalidProtocolStatusInputs]>0&&!gatherTests,
					Message[Error::InvalidInput,ToString[invalidProtocolStatusInputs]]
				];
			),
			$Failed,
			{Error::InvalidOption,Error::InvalidInput}
		]
	];

	(* - If an error was thrown above, or a test failed in the above section, return early. - *)
	If[MatchQ[resolvedOptionResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[Join[safeOptionTests,validLengthTests,{quantificationWavelengthsTests,standardCurveOptionTests,validStandardCurveUnitsTests,protocolStatusTests}]],
			Options->resolvedOptions,
			Preview->Null
		}]
	];

	(* --- Parse the data downloaded from the QuantificationSpectroscopyProtocol to build our AnalyzeFit call --- *)
	(* First, define the variable that chooses the correct packets based on the DetectionMode - if we performed an AbsorbanceSpectroscopy sub vs. a FluorescenceSpectroscopy sub *)
	spectroscopyDataPackets=If[MatchQ[detectionMode,Absorbance],
		absorbanceSpectroscopyDataPackets,
		fluorescenceSpectroscopyDataPackets
	];

	(* Make a list of the Spectroscopy data objects *)
	spectroscopyDataObjects=Lookup[spectroscopyDataPackets,Object];

	(* From this list, make lists of the Data Objects generated from Standards and those generated from the input samples *)
	standardSpectroscopyDataObjects=Take[spectroscopyDataObjects,numberOfStandardCurveWells];
	sampleSpectroscopyDataObjects=Drop[spectroscopyDataObjects,numberOfStandardCurveWells];

	(* - Define the quantificationWavelengths pattern - we use this to pull out the relevant values from the spectroscopyDataPackets - *)
	(* First, make a unitless list of Integers from the resolvedQuantificationWavelengths *)
	unitlessIntegerQuantificationWavelengths=Round[#]&/@Unitless[resolvedQuantificationWavelengths];

	(* Next, define the pattern *)
	quantificationWavelengthDataPattern=Alternatives@@Map[
		{#,_}&,
		unitlessIntegerQuantificationWavelengths
	];

	(* - Use the pattern defined above to find the absorbance or fluorescence values for each data object at the specified quantificationWavelengths - *)
	unitlessDataValues=If[

		(* IF we performed an Absorbance assay *)
		MatchQ[detectionMode,Absorbance],

		(* THEN find the values from the AbsorbanceSpectra of the data packets *)
		Cases[QuantityMagnitude[Lookup[#,AbsorbanceSpectrum]], quantificationWavelengthDataPattern][[All, 2]] & /@spectroscopyDataPackets,

		(* ELSE find the values from the EmissionSpectrum of the data packets *)
		Cases[QuantityMagnitude[Lookup[#,EmissionSpectrum]], quantificationWavelengthDataPattern][[All, 2]] & /@spectroscopyDataPackets
	];

	(* Average these values (the absorbance or fluorescence values in the inner lists of rawUnitlessDataValues) - average all of the various wavelengths together *)
	meanUnitlessDataValues=Mean[#]&/@unitlessDataValues;

	(* -- Define the mean data values that are from the StandardCurve wells versus the input sample wells -- *)
	(* - StandardCurve Wells - *)
	(* First, split the unitless data values into lists from the standard curve wells and the input samples wells *)
	unitlessStandardCurveWellData=Take[meanUnitlessDataValues,numberOfStandardCurveWells];

	(* Expand the StandardCurveConcentrations for the StandardCurveReplicates *)
	expandedStandardCurveConcentrations=Flatten[ConstantArray[#,standardCurveReplicates]&/@standardCurveConcentrations];

	(* Then, partition the list of data values from the standard curve by the number of standard curve replicates (into a list of lists, the inner lists of which have the unitless absorbance or fluorescence values from each StandardCurveConcentration), and take the average of each inner list (averaging the data values from the StandardCurveReplicates) *)

	(* - Input Sample Wells -  *)
	(* First, drop the unitlessStandardCurveWellData from the meanUnitlessDataValues (make a list of the mean unitless data values for the wells that correspond to the input samples) *)
	unitlessInputSampleWellData=Drop[meanUnitlessDataValues,numberOfStandardCurveWells];
	
	(* - Turn the averaged StandardCurveData and the standard curve concentrations into a list of x and y values to send to analyze fit, in the form of {{Concentration,Absorbance/Fluorescence value}..} - *)
	standardCurvePointsForAnalyzeFit=If[

		(* IF the DetectionMode is absorbance *)
		MatchQ[detectionMode,Absorbance],

		(* THEN we make sure that the data points have AbsorbanceUnits *)
		MapThread[
			{#1,#2*AbsorbanceUnit}&,
			{expandedStandardCurveConcentrations,unitlessStandardCurveWellData}
		],

		(* ELSE, we make sure that the data points have Relative Fluorescence Units *)
		MapThread[
			{#1,#2*RFU}&,
			{expandedStandardCurveConcentrations,unitlessStandardCurveWellData}
		]
	];

	(* --- Call AnalyzeFit on the StandardCurve data (if the StandardCurve Option is Null) --- *)
	fitAnalysisResult=Which[

		(* If the StandardCurve option is Null and Upload is True *)
		MatchQ[suppliedStandardCurve,Null]&&upload,
		(* THEN we call AnalyzeFit on the standardCurvePointsForAnalyzeFit *)
		Quiet[
			AnalyzeFit[standardCurvePointsForAnalyzeFit,resolvedStandardCurveFitType],
			NonlinearModelFit::cvmit
		],

		(* If the StandardCurve option is Null and Upload is False *)
		MatchQ[suppliedStandardCurve,Null]&&!upload,
			(* THEN we call AnalyzeFit on the standardCurvePointsForAnalyzeFit with Upload->False *)
			Quiet[
				AnalyzeFit[standardCurvePointsForAnalyzeFit,resolvedStandardCurveFitType,Upload->False],
				NonlinearModelFit::cvmit
			],

		(* ELSE, it is the Analysis object derived from the StandardCurve option  *)
		True,
			standardCurveOptionFitObject
	];

	(* Define the analysis Object for error messages and downloads below *)
	fitAnalysisObject=If[MatchQ[suppliedStandardCurve,Null]&&!upload,
		Lookup[fitAnalysisResult,Type],
		fitAnalysisResult
	];

	(* --- Use the AnalyzeFit object to calculate the Concentration of the WorkingSamples (AssaySamples) --- *)
	(* - Download the BestFitExpression from the analysis object we just created, or use the one given in the StandardCurveOption - *)
	{bestFitExpression,rSquared,standardCurveExpressionType}=If[MatchQ[suppliedStandardCurve,Null],
		Download[fitAnalysisResult,{BestFitExpression,RSquared,ExpressionType}],
		{standardCurveOptionBestFitExpression,standardCurveOptionRSquared,standardCurveOptionExpressionType}
	];

	(* - Apply this expression to the unitless sample well data values - *)
	initialUnitlessSampleWellBestFits=Quiet@Solve[
		#==bestFitExpression,
		x
	]&/@unitlessInputSampleWellData;

	(* -- Because the StandardCurveFitType can both yield no solution (Sigmoid, Tanh) and multiple solutions or imaginary solutions (Cubic) we need to filter the results to the reasonable ones -- *)
	(* First, Get rid of any imaginary solutions and solutions with values lower than 0 *)
	unitlessSampleWellBestFitsNoImaginary=Cases[#, KeyValuePattern[x -> _?(MatchQ[#, _Real] && MatchQ[#, GreaterP[0]] &)]]&/@initialUnitlessSampleWellBestFits;

	(* Then, if there are multiple solutions, take only the larger of the answers (not perfect, but this will not happen much if at all) *)
	unitlessSampleWellBestFits=If[MatchQ[#,{}],
		{},
		{First[Sort[#]]}
	]&/@unitlessSampleWellBestFitsNoImaginary;

	(* -- Here we need to define the AssaySamples, SamplesIn, unitlessSampleWellBestFits, Concentrations, etc for the AssaySamples whose concentrations can actually be solved for (sometimes with Sigmoidal fit, there are absorbance or fluorescence values which have no associated concentration because of asymptotes and such) -- *)
	(* The AssaySamples for which there is a solution to the BestFitExpression *)
	solvedAssaySamples=PickList[assaySamples,unitlessSampleWellBestFits,Except[{}]];

	(* The AssaySamples for which there is not a solution to the BestFitExpression *)
	unsolvedAssaySamples=PickList[assaySamples,unitlessSampleWellBestFits,{}];

	(* The SamplesIn for which the corresponding AssaySamples have a solution to the BestFitExpression *)
	solvedSamplesIn=PickList[samplesInObjects,unitlessSampleWellBestFits,Except[{}]];

	(* The SamplesIn for which the corresponding AssaySamples do not have a solution to the BestFitExpression *)
	unsolvedSamplesIn=PickList[samplesInObjects,unitlessSampleWellBestFits,{}];

	unsolvedInputSampleWellData=If[MatchQ[detectionMode,Absorbance],
		(PickList[unitlessInputSampleWellData,unitlessSampleWellBestFits,Except[{}]]*AbsorbanceUnit),
		(PickList[unitlessInputSampleWellData,unitlessSampleWellBestFits,Except[{}]]*RFU)
	];

	(* If we are throwing warnings, and there are any AssaySamples whose spectroscopy data does not yield a concentration, throw a warning explaining this *)
	If[messages&&notInEngine&&Length[unsolvedAssaySamples]>0,
		Message[Warning::AnalyzeTPQConcentrationIncalculable,ToString[unsolvedAssaySamples],ToString[unsolvedSamplesIn],ToString[bestFitExpression],ToString[unsolvedInputSampleWellData]]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	incalculableTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unsolvedAssaySamples]==0,
				Nothing,
				Warning["The TotalProteinConcentration of the following AssaySamples, "<>ToString[unsolvedAssaySamples]<>", which correspond to the SamplesIn, "<>ToString[unsolvedSamplesIn]<>", cannot be calculated. Solutions for x (TotalProteinConcentration) to the following equation, y = "<>ToString[bestFitExpression]<>", when substituting the associated Absorbance or Fluorescence values as y, "<>ToString[unsolvedInputSampleWellData]<>", do not exist. This can occur for Sigmoidal or Tanh standard curve fitting when the TotalProteinConcentration of the AssaySample is outside of the dynamic range of the assay. To obtain concentration information, please set the StandardCurveFitType to Linear. Alternatively, the TotalProteinConcentration can be measured by running ExperimentTotalProteinQuantification on input samples that are more dilute:",True,False]

			];
			passingTest=If[Length[unsolvedAssaySamples]==0,
				Warning["All of the AssaySamples have calculated TotalProteinConcentrations:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* The solutions to the BestFitExpression that actually exist *)
	solvedUnitlessSampleWellBestFits=Cases[unitlessSampleWellBestFits,Except[{}]];

	(* Pull out the values that were solved for from the nested lists above - if all of the solutions are negative or imaginary, then the list is empty *)
	unitlessSampleWellConcentrations=If[MatchQ[unitlessSampleWellBestFits,{{}..}],
		{},
		RoundOptionPrecision[Lookup[Flatten[unitlessSampleWellBestFits,1],x],10^-5]
	];

	(* Replace any values lower than 0 with 0 (no such thing as negative concentration), and add the mg/mL units back to get the TotalProteinConcentration of the samples actually used in the assay (WorkingSamples/AssaySAmples) *)
	solvedAssaySamplesConcentrations=(unitlessSampleWellConcentrations/.{LessP[0]->0})*(Milligram/Milliliter);

	(* -- Determine how much the input samples were diluted to create the AssaySamples -- *)
	assaySampleDilutionFactors=If[

		(* IF the AliquotSamplePreparation field is an empty list *)
		MatchQ[aliquotSamplePreparation,{}],

		(* THEN there was no Aliquotting and thus no sample dilution, so we make a list of 1's the length of SamplesIn *)
		ConstantArray[1,Length[samplesIn]],

		(* ELSE, we need to calculate the dilution factors for each SampleIn *)
		Module[
			{aliquotAmounts,assayVolumes,dilutionFactors},

			(* First, look up the AliquotAmonts from the AliquotSamplePreparation Field *)
			aliquotAmounts=Lookup[aliquotSamplePreparation,AliquotAmount];

			(* Next, look up the AssayVolume from the AliquotSamplePreparation Field *)
			assayVolumes=Lookup[aliquotSamplePreparation,AssayVolume];

			(* Lastly, use these two volumes (or Null) to calculate the dilution factors *)
			dilutionFactors=MapThread[
				If[

					(* IF the AssayVolume is Null *)
					MatchQ[#1,Null],

					(* THEN there was no aliquotting for this sample and thus no dilution *)
					1,

					(* ELSE, we need to divide the AliquotVolume by the AssayVolume to determine the dilution factor *)
					(#1/#2)
				]&,
				{aliquotAmounts,assayVolumes}
			];
			dilutionFactors
		]
	];

	(* Find the assaySampleDilutionFactors for which we actually solved for the concentration *)
	solvedAssaySampleDilutionFactors=PickList[assaySampleDilutionFactors,unitlessSampleWellBestFits,Except[{}]];

	(* - Use the calculated dilution factors to determine what the TotalProteinConcentrations of the input samples were before dilution - *)
	solvedSamplesInConcentrations=RoundOptionPrecision[(solvedAssaySamplesConcentrations/solvedAssaySampleDilutionFactors),10^-5*(Milligram/Milliliter)];

	(* --- Throw warnings based on the Fit Analysis and the calculated concentrations --- *)
	(* -- Throw a warning if the R-squared value of the fit curve is below 0.95 --*)
	If[messages&&notInEngine&&rSquared<0.95,
		Message[Warning::AnalyzeTPQPoorStandardCurveFit,ToString[fitAnalysisObject],ToString[rSquared],ToString[resolvedQuantificationWavelengths],ToString[resolvedStandardCurveFitType]]
	];

	(* If we are gathering tests, define the associated passing and failing tests *)
	rSquaredTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[rSquared>=0.95,
				Nothing,
				Warning["The fit analysis, "<>ToString[fitAnalysisObject]<>", has an R-squared value, "<>ToString[rSquared]<>", that is less than 0.95:",True,False]
			];
			passingTest=If[rSquared<0.95,
				Nothing,
				Warning["The fit analysis, "<>ToString[fitAnalysisObject]<>", has an R-squared value, "<>ToString[rSquared]<>", that is greater than or equal to 0.95:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- Throw a warning if any of the calculated AssaySampleConcentrations are 0 (which means they were probably a negative number), or are above the largest member of StandardCurveConcentrations -- *)
	(* First, we find the largest concentration that was used to make the StandardCurve *)
	maxStandardCurveConcentration=If[

		(* IF the StandardCurve option is Null *)
		MatchQ[suppliedStandardCurve,Null],

		(* THEN we define this as the largest member of StandardCurveConcentrations *)
		Last[Sort[standardCurveConcentrations]],

		(* ELSE, we take the concentrations from the DataPoints field of the supplied Fit Analysis object of the StandardCurve option, sort them, and take the largest *)
		Last[Sort[
			First[#]&/@standardCurveOptionDataPoints
		]]
	];

	(* - Define the AssaySampleConcentrations that were calculated to be 0, or larger than the maxStandardCurveConcentration - these values were either rounded up to be 0, or extrapolated from the StandardCurve - we will warn about these - *)
	extrapolatedAssaySampleConcentrations=Cases[solvedAssaySamplesConcentrations,Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]];
	extrapolatedAssaySamples=PickList[solvedAssaySamples,solvedAssaySamplesConcentrations,Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]];
	extrapolatedSamplesInConcentrations=PickList[solvedSamplesInConcentrations,solvedAssaySamplesConcentrations,Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]];
	extrapolatedSamplesIn=PickList[solvedSamplesIn,solvedAssaySamplesConcentrations,Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]];

	(* Define variables for the calculated concentrations that are fine, for the passing test *)
	notExtrapolatedAssaySampleConcentrations=Cases[solvedAssaySamplesConcentrations,Except[Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]]];
	notExtrapolatedAssaySamples=PickList[solvedAssaySamples,solvedAssaySamplesConcentrations,Except[Alternatives[0*Milligram/Milliliter,GreaterP[maxStandardCurveConcentration]]]];

	(* If we are throwing messages and there are any extrapolatedAssaySampleConcentrations, throw a Warning *)
	If[messages&&notInEngine&&Length[extrapolatedAssaySampleConcentrations]>0,
		Message[Warning::AnalyzeTPQCalculatedConcentrationsExtrapolated,ToString[extrapolatedAssaySamples],ToString[extrapolatedAssaySampleConcentrations],ToString[maxStandardCurveConcentration],ToString[extrapolatedSamplesIn],ToString[extrapolatedSamplesInConcentrations]]
	];

	(* If we are gathering tests, create the passing and failing tests *)
	extrapolatedAssaySampleConcentrationsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[extrapolatedAssaySampleConcentrations]==0,
				Nothing,
				Warning["The following members of AssaySamples, "<>ToString[extrapolatedAssaySamples]<>", have calculated TotalProteinConcentrations, "<>ToString[extrapolatedAssaySampleConcentrations]<>", that are either 0 milligram per milliliter or larger the largest concentration used to create the StandardCurve, "<>ToString[maxStandardCurveConcentration]<>":",True,False]
			];
			passingTest=If[Length[notExtrapolatedAssaySampleConcentrations]==0,
				Nothing,
				Warning["The following members of AssaySamples, "<>ToString[notExtrapolatedAssaySamples]<>", have calculated TotalProteinConcentrations, "<>ToString[notExtrapolatedAssaySampleConcentrations]<>", that are between 0 milligram per milliliter and the largest concentration used to create the StandardCurve, "<>ToString[maxStandardCurveConcentration]<>":",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* --- Upload the SamplesIn TotalProteinConcentrations if UploadConcentration is True --- *)
	(* -- Create an Association pointing each unique SampleIn to the Mean of the associated samplesInConcentrations -- *)
	(* First, create a list of rules linking the solved SamplesIn to the associated TotalProteinConcentration *)
	samplesInConcentrationRules=MapThread[
		{#1->#2}&,
		{solvedSamplesIn,solvedSamplesInConcentrations}
	];

	(* Next, Merge these rules together, and take the average of the concentrations for each unique SampleIn's TotalProteinConcentration values, and make an EmpiricalDistribution *)
	uniqueSamplesInConcentrationAndDistributionAssociation=Merge[samplesInConcentrationRules,{Mean[#], EmpiricalDistribution[#]}&];

	(* Create lists of the unique solved SamplesIn and the unique solved SamplesIn TotalProteinConcentrations *)
	uniqueSamplesIn=Keys[uniqueSamplesInConcentrationAndDistributionAssociation];
	uniqueSamplesInTotalProteinConcentrations=RoundOptionPrecision[Map[First[#]&,Values[uniqueSamplesInConcentrationAndDistributionAssociation]],10^-5*(Milligram/Milliliter)];

	(* Create a list of the unique solved Samples In Concentration Distributions *)
	uniqueSamplesInConcentrationDistributions=Map[Last[#]&,Values[uniqueSamplesInConcentrationAndDistributionAssociation]];

	(* Create a list of rules linking the unique Solved SamplesIn to the associated MeanTotalProteinConcentration *)
	uniqueSolvedSamplesInConcentrationRules=MapThread[
		{#1->#2}&,
		{uniqueSamplesIn,uniqueSamplesInTotalProteinConcentrations}
	];

	(* -- We want to upload the calculated concentrations to the SamplesInProteinConcentrations Field, which is index matched to SamplesIn, so we must write replace rules that take into account both the solved SamplesIn and the SamplesIn without solutions -- *)
	(* First, need to make a list of the unsolvedSamplesIn that are NOT part of the unique(Solved)SamplesIn *)
	unsolvedSamplesInNoSolved=Cases[unsolvedSamplesIn,Except[Alternatives@@uniqueSamplesIn]];
	(* To create the list of replace rules, we need to join lists of replace rules of the unique samples in that were solved for, and the unsolved samples in *)
	samplesInConcentrationReplaceRules=Flatten[
		Join[
			uniqueSolvedSamplesInConcentrationRules,
			(* Next, create the replace rules for the unsolved Samples In that are not present in UniqueSamplesIn *)
			Map[
				{#->Null}&,
				unsolvedSamplesInNoSolved
			]
		]
	];

	(* Define the TotalProteinConcentration for all SamplesIn, even those that have not been solved *)
	allSamplesInTotalProteinConcentrations=Map[
		Replace[#,samplesInConcentrationReplaceRules]&,
		samplesInObjects
	];

	(* -- We want to upload the calculated concentrations to the AssaySamplesProteinConcentrations Field, which is index matched to SamplesIn -- *)
	(* - Because AssaySamples may not be unique, and we want to have the AssaySamplesProteinConcentrations to have the actual measured values and not the average for each AssaySample, we cannot do the same exact thing as above for input samples - *)
	(* - To get around the duplicate AssaySample issue, we will do the calculations referencing the samples in the QuantificationPlate, which are unique - *)
	(* Define a list of the quantificationPlateInputSamples that have been solved *)
	solvedQuantificationPlateInputSamples=PickList[quantificationPlateInputSamples,unitlessSampleWellBestFits,Except[{}]];

	(* The AssaySamples for which there is not a solution to the BestFitExpression *)
	unsolvedQuantificationPlateInputSamples=PickList[quantificationPlateInputSamples,unitlessSampleWellBestFits,{}];

	(* Create a list of replace rules, with the solvedQuantificationPlateInputSamples (all unique) pointing to the solvedAssaySamplesConcentrations, and the unsolvedQuantificationPlateInputSamples (all unique) pointing to Null *)
	quantificationPlateInputSampleConcentrationReplaceRules=Flatten[
		Join[
			(* First create the replace rules for the quantificationPlateInputSamples that were solved for *)
			MapThread[
				{#1->#2}&,
				{solvedQuantificationPlateInputSamples,solvedAssaySamplesConcentrations}
			],
			(* Next, create the replace rules for the unsolved quantificationPlateInputSamples *)
			Map[
				{#->Null}&,
				unsolvedQuantificationPlateInputSamples
			]
		]
	];

	(* First, need to make a list of the unsolvedSamplesIn that are NOT part of the unique(Solved)SamplesIn *)
	unsolvedAssaySamplesNoSolved=Cases[unsolvedAssaySamples,Except[Alternatives@@solvedAssaySamples]];
	(* To create the list of replace rules, we need to join lists of replace rules of the unique assaySa,[;es that were solved for, and the unsolved assaySamples *)
	assaySamplesConcentrationReplaceRules=Flatten[
		Join[
			(* First create the replace rules for the assaySamples that were solved for *)
			MapThread[
				{#1->#2}&,
				{solvedAssaySamples,solvedAssaySamplesConcentrations}
			],
			(* Next, create the replace rules for the unsolved assaySamples *)
			Map[
				{#->Null}&,
				unsolvedAssaySamplesNoSolved
			]
		]
	];

	(* Define the TotalProteinConcentration for all AssaySamples, even those that have not been solved *)
	allAssaySamplesTotalProteinConcentrations=Map[
		Replace[#,quantificationPlateInputSampleConcentrationReplaceRules]&,
		quantificationPlateInputSamples
	];

	(* -- We want to upload the calculated concentration distributions to the SamplesInConcentrationDistributions field of the analysis object. This is index matched to SamplesIn, so we must write replace rules that take into account both the solved SamplesIn and the SamplesIn without solutions -- *)
	(* To create the list of replace rules, we need to join lists of replace rules of the unique samples in that were solved for, and the unsolved samples in *)
	samplesInConcentrationDistributionReplaceRules=Flatten[
		Join[
			(* First create the replace rules for the uniqueSamplesIn that were solved for *)
			MapThread[
				{#1->#2}&,
				{uniqueSamplesIn,uniqueSamplesInConcentrationDistributions}
			],
			(* Next, create the replace rules for the unsolved Samples In that are not present in UniqueSamplesIn *)
			Map[
				{#->Null}&,
				unsolvedSamplesInNoSolved
			]
		]
	];

	(* Define the ConcentrationDistribution for all SamplesIn, even those that have not been solved *)
	allSamplesInConcentrationDistributions=Map[
		Replace[#,samplesInConcentrationDistributionReplaceRules]&,
		samplesInObjects
	];


	(* If UploadConcentration is True, call UploadSampleProperties *)
	uploadSamplePropertiesResult=Which[
		(* The case where both Upload and UploadConcentration are true, we upload the new SamplesIn TotalProteinConcentrations where *)
		suppliedUploadConcentration&&upload,
			ECL`InternalUpload`UploadSampleProperties[uniqueSamplesIn,TotalProteinConcentration->uniqueSamplesInTotalProteinConcentrations],

		(* The case where UploadConcentration is True but Upload is False, we call UploadSampleProperties with Upload to False to get the change packets that we will return at the end of the function *)
		suppliedUploadConcentration&&!upload,
			ECL`InternalUpload`UploadSampleProperties[uniqueSamplesIn,TotalProteinConcentration->uniqueSamplesInTotalProteinConcentrations,Upload->False],

		(* In all other cases, return Null *)
		True,
			Null
	];

	(* --- Build the protocol packet --- *)
	(* Create an Object[Analysis,TotalProteinQuantification] id *)
	analysisID=CreateID[Object[Analysis,TotalProteinQuantification]];

	(* - Depending on if the user provided a StandardCurve or not, include a few fields in the Upload Packet - *)
	(* StandardCurveConcentrations*)
	standardCurveConcentrationsField=If[MatchQ[standardCurvePacket,{}],
		standardCurveConcentrations,
		{}
	];

	(* StandardsSpectroscopyData *)
	standardSpectroscopyDataField=If[MatchQ[standardCurvePacket,{}],
		standardSpectroscopyDataObjects,
		{}
	];

	(* StandardCurveReplicates *)
	standardCurveReplicatesField=If[MatchQ[standardCurvePacket,{}],
		standardCurveReplicates,
		Null
	];

	(* QuantificationStandards *)
	quantitificationStandardsField=If[MatchQ[standardCurvePacket,{}],
		quantificationPlateStandardSamples,
		{}
	];
	
	(* list of booleans indicating if analysis can be performed (non-Null values) *)
	quantifiableOnStandardCurve = Not[MatchQ[#, Null]]&/@allAssaySamplesTotalProteinConcentrations;

	(* Build the packet for the AnalysisObject *)
	analysisPacket=Association@@ReplaceRule[
		standardFieldsStart,
		Join[
			{
				Object->analysisID,
				ResolvedOptions->resolvedOptions,
				Append[Reference]->{Link[myProtocol,QuantificationAnalyses]},
				Replace[SamplesIn]->Link[samplesInObjects],
				Replace[AssaySamples]->Link[assaySamples],
				Replace[AssaySamplesDilutionFactors]->assaySampleDilutionFactors,
				LoadingVolume->loadingVolume,
				QuantificationReagent->Link[quantificationReagentObject],
				QuantificationReagentVolume->quantificationReagentVolume,
				ExcitationWavelength->excitationWavelength,
				Replace[QuantificationWavelengths]->resolvedQuantificationWavelengths,
				StandardCurve->Link[fitAnalysisObject,PredictedValues],
				Replace[StandardCurveConcentrations]->standardCurveConcentrationsField,
				StandardCurveReplicates->standardCurveReplicatesField,
				Replace[QuantificationStandards]->(Link[#]&/@quantitificationStandardsField),
				Replace[QuantificationSamples]->(Link[#]&/@quantificationPlateInputSamples),
				Replace[AssaySamplesProteinConcentrations]->allAssaySamplesTotalProteinConcentrations,
				Replace[SamplesInProteinConcentrations]->allSamplesInTotalProteinConcentrations,
				Replace[SamplesInConcentrationDistributions]->allSamplesInConcentrationDistributions,
				Replace[StandardsSpectroscopyData]->(Link[#]&/@standardSpectroscopyDataField),
				Replace[InputSamplesSpectroscopyData]->(Link[#]&/@sampleSpectroscopyDataObjects),
				Replace[QuantifiableOnStandardCurve]->quantifiableOnStandardCurve
			},
			(* need to manually say that Author -> Null if ParentProtocol -> True; otherwise it already is automatically $PersonID *)
			If[TrueQ[Lookup[safeOptions, ParentProtocol]],
				{Author -> Null},
				{}
			]
		]
	];

	(* --- Output --- *)
	(* -- Define the rules for each possible Output value -- *)
	(* - Preview Rule - *)
	previewRule=If[upload,
	 Preview->
		TabView[
			{
				"Standard Curve"->Zoomable[PlotFit[fitAnalysisObject,PlotLabel->"Standard Curve"]],
				"Standard Curve Information"->PlotTable[
					{
						{"Expression Type",standardCurveExpressionType},
						{"Best Fit Expression",bestFitExpression},
						{"R-Squared",rSquared}
					},
					Alignment -> Center,
					Title->"Standard Curve Fit Information"
				],
				"Unique Samples In"->PlotTable[
					MapThread[
						{#1,#2,#3}&,
						{Prepend[uniqueSamplesIn,"Unique Samples In"],Prepend[uniqueSamplesInTotalProteinConcentrations,"Average Total Protein Concentrations"],Prepend[uniqueSamplesInConcentrationDistributions,"Total Protein Concentration Distributions"]}
					],
					Alignment -> Center,
					Title->"Unique Samples In and TotalProteinConcentrations",
					Caption->"The TotalProteinConcentrations that are uploaded to the unique SamplesIn when UploadConcentration is True"
				],
				"Samples In"->PlotTable[
					MapThread[
						{#1,#2}&,
						{Prepend[samplesInObjects,"Samples In"],Prepend[allSamplesInTotalProteinConcentrations,"Total Protein Concentrations"]}
					],
					Alignment -> Center,
					Title->"All Samples In and TotalProteinConcentrations"
				],
				"Assay Samples"->PlotTable[
					MapThread[
						{#1,#2}&,
						{Prepend[assaySamples,"Assay Samples"],Prepend[allAssaySamplesTotalProteinConcentrations,"Total Protein Concentrations"]}
					],
					Alignment -> Center,
					Title->"All Assay Samples and TotalProteinConcentrations"
				]
			},
			Alignment -> Center
		],
		Preview->TabView[
			{
				"Unique Samples In"->PlotTable[
					MapThread[
						{#1,#2,#3}&,
						{Prepend[uniqueSamplesIn,"Unique Samples In"],Prepend[uniqueSamplesInTotalProteinConcentrations,"Average Total Protein Concentrations"],Prepend[uniqueSamplesInConcentrationDistributions,"Total Protein Concentration Distributions"]}
					],
					Alignment -> Center,
					Title->"Unique Samples In and TotalProteinConcentrations",
					Caption->"The TotalProteinConcentrations that are uploaded to the unique SamplesIn when UploadConcentration is True"
				],
				"Samples In"->PlotTable[
					MapThread[
						{#1,#2}&,
						{Prepend[samplesInObjects,"Samples In"],Prepend[allSamplesInTotalProteinConcentrations,"Total Protein Concentrations"]}
					],
					Alignment -> Center,
					Title->"All Samples In and TotalProteinConcentrations"
				],
				"Assay Samples"->PlotTable[
					MapThread[
						{#1,#2}&,
						{Prepend[assaySamples,"Assay Samples"],Prepend[allAssaySamplesTotalProteinConcentrations,"Total Protein Concentrations"]}
					],
					Alignment -> Center,
					Title->"All Assay Samples and TotalProteinConcentrations"
				]
			},
			Alignment -> Center
		]
	];


	(* - Options Rule - *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[AnalyzeTotalProteinQuantification,resolvedOptions],
		Null
	];

	(* - Tests Rule - *)
	(* First, define all of the tests *)
	allTests=Cases[
		Flatten[
			{
				safeOptionTests,validLengthTests,templateTests,quantificationWavelengthsTests,standardCurveOptionTests,validStandardCurveUnitsTests,incalculableTests,rSquaredTests,extrapolatedAssaySampleConcentrationsTests
			}
		],
		_EmeraldTest
	];

	(* Next, define the Tests Rule *)
	testsRule=Tests->If[MemberQ[output,Tests],
		allTests,
		Null
	];

	(* - Result Rule - *)
	(* First, upload the analysis object packet if upload is True *)
	analysisObject=If[upload&&MemberQ[output,Result],
		Upload[analysisPacket],
		analysisPacket
	];
	resultRule=Result->If[MemberQ[output,Result],
		Which[
			(* In the case where upload is True, return the uploaded analysis object *)
			upload,
				analysisObject,
			(* In the case that upload is false and UploadConcentration is True, return the analysis object packet and the uploadSamplePropertiesResult (which is a list of packets) *)
			!upload&&suppliedUploadConcentration,
				Flatten[Join[{analysisObject},{uploadSamplePropertiesResult}]],

			(* Otherwise, (Upload is false and UploadConcentration is false, just return the analysis object packet *)
			True,
				{analysisObject}
		],
		Null
	];

	(* -- Return requested output -- *)
	outputSpecification/.{
		resultRule,
		testsRule,
		optionsRule,
		previewRule
	}
];


(* ::Subsection:: *)
(*AnalyzeTotalProteinQuantificationPreview*)


DefineOptions[AnalyzeTotalProteinQuantificationPreview,
	SharedOptions:>{AnalyzeTotalProteinQuantification}
];

AnalyzeTotalProteinQuantificationPreview[myProtocol:ObjectP[Object[Protocol,TotalProteinQuantification]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	AnalyzeTotalProteinQuantification[myProtocol,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*AnalyzeTotalProteinQuantificationOptions*)


DefineOptions[AnalyzeTotalProteinQuantificationOptions,
	SharedOptions :> {AnalyzeTotalProteinQuantification},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

AnalyzeTotalProteinQuantificationOptions[myProtocol:ObjectP[Object[Protocol,TotalProteinQuantification]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for AnalyzeTotalProteinQuantification *)
	options=AnalyzeTotalProteinQuantification[myProtocol,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeTotalProteinQuantification],
		options
	]
];


(* ::Subsection:: *)
(*ValidExperimentTotalProteinDetectionQ*)


DefineOptions[ValidAnalyzeTotalProteinQuantificationQ,
	Options:>
			{
				VerboseOption,
				OutputFormatOption
			},
	SharedOptions:>{AnalyzeTotalProteinQuantification}
];

ValidAnalyzeTotalProteinQuantificationQ[myProtocol:ObjectP[Object[Protocol,TotalProteinQuantification]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,analyzeTotalProteinQuantificationTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentTotalProteinDetection *)
	analyzeTotalProteinQuantificationTests=AnalyzeTotalProteinQuantification[myProtocol,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[analyzeTotalProteinQuantificationTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myProtocol],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myProtocol],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,analyzeTotalProteinQuantificationTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentTotalProteinDetectionQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentTotalProteinDetectionQ"]
];
