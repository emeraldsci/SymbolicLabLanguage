(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*AnalyzeAbsorbanceQuantification*)


(* ::Subsubsection:: *)
(*AnalyzeAbsorbanceQuantification*)


DefineOptions[AnalyzeAbsorbanceQuantification,
	Options :> {
		{
			OptionName -> DestinationPlateModel,
			Default -> Automatic,
			Description -> "The model of plate in which the experiment was performed.",
			AllowNull -> False,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Container, Plate]]]
		},
		IndexMatching[
			{
				OptionName -> Wavelength,
				Default -> Automatic,
				Description -> "The wavelength at which the sample absorbs maximally and at which the concentration analysis is to be performed.",
				ResolutionDescription -> "If Automatic, the wavelength is 260nm for oligomers and 280nm for proteins.",
				AllowNull -> False,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Nanometer, Nanometer], Units -> Alternatives[Nanometer]]
			},
			{
				OptionName -> PathLength,
				Default -> Automatic,
				Description -> "The path length of light through a sample of interest, assumed to be in the vertical direction.",
				ResolutionDescription -> "If Automatic, PathLength is calculated by the associated calibration function.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity, Pattern :> GreaterP[0 Meter], Units -> Alternatives[Nanometer, Meter]],
					Widget[Type -> Expression, Pattern :> DistributionP, Size -> Line]
				]
			},
			IndexMatchingInput -> "experiment data"
		],
		{
			OptionName -> MaxAbsorbance,
			Default -> Automatic,
			Description -> "Maximum value at Wavelength to be within dynamic range. Absorbance data out side the range will be excluded.",
			ResolutionDescription -> "If Automatic, MaxAbsorbance is set to be 2.3 AU.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 AbsorbanceUnit], Units -> Alternatives[AbsorbanceUnit]]
		},
		{
			OptionName -> MinAbsorbance,
			Default -> Automatic,
			Description -> "Minimum value at Wavelength to be within dynamic range. Absorbance data out side the range will be excluded.",
			ResolutionDescription -> "If Automatic, MinAbsorbance is set to be 0.8 AU.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 AbsorbanceUnit], Units -> Alternatives[AbsorbanceUnit]]
		},
		{
			OptionName -> PathLengthMethod,
			Default -> Automatic,
			Description -> "The method by which the path length from the plate reader to the sample in the read plate was determined.",
			ResolutionDescription -> "Set automatically to Constant if the data was collected via Lunatic, or Ultrasonic otherwise.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Ultrasonic, Constant]]
		},
		{
			OptionName -> ParentProtocol,
			Default -> False,
			Description -> "Whether or not this analysis has a parent protocol. If True, then it does not set the author in the upload packet. Otherwise the author is whoever running this analysis.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[True, False]],
			Category -> "Hidden"
		},
		{
			OptionName -> OutputAll,
			Default -> False,
			Description -> "If True, also returns any other objects that were created or modified.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[True, False]],
			Category -> "Hidden"
		},
		OutputOption,
		UploadOption,
		AnalysisTemplateOption

	}
];


Warning::AllAbsOutOfRange = "For sample `1`, all the measured absorbance data are out of the recommended linear range {`2`, `3`}. Continued analyzing while considering them as in-range data.";
Error::NoExtinctionCoefficients = "Either the Analyte field is not populated in `1`, or if it is, the ExtinctionCoefficnets field is not populated for that value. Please upload the corresponding values to ExtinctionCoefficients or Analyte fields.";


(* given singleton input, redirect to list definition then take first *)
AnalyzeAbsorbanceQuantification[myDataObj : ObjectP[{Object[Data, AbsorbanceSpectroscopy], Object[Data, AbsorbanceIntensity]}], ops : OptionsPattern[]] := Module[
	{out},

	out = AnalyzeAbsorbanceQuantification[{myDataObj}, ops];

	If[!MatchQ[out, _List] || Length[out] > 1,
		out,
		First[out]
	]

];

(* Given list of inputs *)
AnalyzeAbsorbanceQuantification[myDataObjs : {ObjectP[{Object[Data, AbsorbanceSpectroscopy], Object[Data, AbsorbanceIntensity]}]..}, ops : OptionsPattern[]] := Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		unresolvedOptions, templateTests, combinedOptions, samplesInList, semiResolvedOps,
		prevTests, dataPackets, allDownloadValues, outputConc, groupedOutputConc,
		standardFieldsStart, protocolObj, resolvedWavelength, extCoeffs, resolvedOps, absorbances, calibrationSamplePackets, pathlengths,
		rawConcentrations, concentrations, groupedList, groupedDataObjects, groupedConc, groupedPathlength, groupedAbsorbance,
		groupedDistConc, sampleUniqueList, sampleDilutions, absQuantPackets, analysisIDs,
		inRangePos, minAbs, maxAbs, concentrationsUndiluted, concentrationUndilutedDistr, concSTDs, concDists, plMethod,
		outputConcDiluted, dataUpdates, sampleConcentrations, sampleObjs, sampleUpdates,
		aliquotSampleObjs, aliquotSampleUpdates, groupedAliquotAndConcs, groupedPackets, optionsRule, previewRule,
		testsRule, resultRule, samplePackets, groupedOutputConcLog, instrumentModels, resolvedPathLengthMethod,
		preResolvedPathLength, analytePackets, groupedAnalytes, sampleAnalytes, oldSampleCompositions, groupedCompositions,
		samplesToUpdate, oldCompositionsToUpdate, sampleAnalytesToUpdate, sampleConcsToUpdate, newSampleCompositionReplaceRules,
		newCompositions, concFieldToUpdate, concLogFieldToUpdate, groupedAbsQuantPackets, aliquotPackets, oldAliquotCompositions,
		analytePerAliquotSampleReplaceRules, aliquotAnalytes, newAliquotCompositionReplaceRules, newAliquotCompositions,
		newAliquotCompositionPackets, samplesInPacketsPerDataPacket, nullExtCoeffDataObjs
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

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[AnalyzeAbsorbanceQuantification, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[AnalyzeAbsorbanceQuantification, listedOptions, AutoCorrect -> False], Null}
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
		ValidInputLengthsQ[AnalyzeAbsorbanceQuantification, {myDataObjs}, listedOptions, Output -> {Result, Tests}],
		{ValidInputLengthsQ[AnalyzeAbsorbanceQuantification, {myDataObjs}, listedOptions], Null}
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
		ApplyTemplateOptions[AnalyzeAbsorbanceQuantification, {myDataObjs}, listedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[AnalyzeAbsorbanceQuantification, {myDataObjs}, listedOptions], Null}
	];

	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* Download information about the data objects and the SamplesIn *)
	(* need to Quiet because the PolymerType and Structure fields only exist for oligomers *)
	allDownloadValues = Quiet[Download[
		myDataObjs,
		{
			(* need the Absorbance field for AbsorbanceIntensity objects, and AbsorbanceSpectrum for AbsorbanceSpectroscopy objects *)
			Packet[Protocol, SamplesIn, AbsorbanceSpectrum, AliquotSamples, Analyte, Absorbance],
			Packet[Analyte[{ExtinctionCoefficients, Molecule}]],
			Packet[SamplesIn[{Data, Composition, Position}]],
			Packet[AliquotSamples[{Data, Composition, Volume, Position}]],
			Protocol[Instrument][Model]
		}
	], {Download::FieldDoesntExist, Download::NotLinkField, Download::MissingField}];

	(* split out the data packets from the SamplesIn model packets *)
	dataPackets = allDownloadValues[[All, 1]];
	analytePackets = allDownloadValues[[All, 2]];
	samplePackets = Flatten[allDownloadValues[[All, 3]]];
	aliquotPackets = Flatten[allDownloadValues[[All, 4]]];
	instrumentModels = Flatten[allDownloadValues[[All, 5]]];

	(* pull out the SamplesIn from the data packets *)
	samplesInList = Lookup[dataPackets, SamplesIn];

	(* global variable for field LinearRangeWarning *)
	linearRangeWarning = False;

	(* --- for AbsSpec experiments ---- *)
	protocolObj = First[Lookup[dataPackets, Protocol]];
	prevTests = Flatten[{safeOptionTests, validLengthTests, templateTests}];

	(* get the wavelength option; if it is not specified, then default to 260 *)
	resolvedWavelength = Switch[Lookup[combinedOptions, Wavelength],
		Automatic, ConstantArray[260 Nanometer, Length[myDataObjs]],
		UnitsP[Nanometer], ConstantArray[Lookup[combinedOptions, Wavelength], Length[myDataObjs]],
		_, Lookup[combinedOptions, Wavelength]
	];

	(* resolve the PathLengthMethod by checking whether the lunatic was used or not *)
	(* this is the ID of the Lunatic *)
	resolvedPathLengthMethod = If[MatchQ[First[instrumentModels], ObjectP[{Model[Instrument, PlateReader, "id:N80DNj1lbD66"], Model[Instrument, Spectrophotometer]}]],
		Constant,
		Ultrasonic
	];

	(* pre-resolve the path length; if PathLengthMethod is Constant then resolve to 1 cm; otherwise keep what it is *)
	preResolvedPathLength = If[MatchQ[resolvedPathLengthMethod, Ultrasonic],
		Lookup[combinedOptions, PathLength],
		1.0 Centimeter
	];

	(* determine if output MassConcentration or Concentration depending on ExtCoeff unit *)
	(* if Analyte is populated, that is what we are going to calculate the extinction coefficient for; if not it will be a different one.  They all should have it though *)
	extCoeffs = MapThread[
		Function[{analytePacket, wavelength},
			Which[
				MatchQ[analytePacket, IdentityModelP] && MatchQ[Lookup[analytePacket, ExtinctionCoefficients], {__Association}] && MemberQ[Lookup[Lookup[analytePacket, ExtinctionCoefficients], Wavelength], EqualP[wavelength]],
					Lookup[SelectFirst[Lookup[analytePacket, ExtinctionCoefficients], wavelength == Lookup[#, Wavelength]&], ExtinctionCoefficient],
				MatchQ[analytePacket, IdentityModelP],
					ExtinctionCoefficient[analytePacket],
				True, Null
			]
		],
		{analytePackets, resolvedWavelength}
	];

	(* if ExtinctionCoefficients is Null, throw a message and return $Failed *)
	nullExtCoeffDataObjs = PickList[myDataObjs, extCoeffs, Null];
	If[Length[nullExtCoeffDataObjs] > 0,
		Message[Error::NoExtinctionCoefficients, nullExtCoeffDataObjs];
		Return[$Failed]
	];

	(* decide whether we're dealing with Concentration or MassConcentration; for some reason, ExtinctionCoefficientP _only_ matches Molar units and not mass concentration units *)
	outputConc = Map[
		If[ExtinctionCoefficientQ[#],
			Concentration,
			MassConcentration
		]&,
		extCoeffs
	];

	(* populate resolved options lists (with the caveat that for now, PathLength, MaxAbsorbance, and MinAbsorbance are all still Automatic) *)
	semiResolvedOps = ReplaceRule[combinedOptions,
		{
			DestinationPlateModel -> If[MatchQ[Lookup[combinedOptions, DestinationPlateModel], Automatic],
				Download[Model[Container, Plate, "96-well UV-Star Plate"], Object],
				Download[Lookup[combinedOptions, DestinationPlateModel], Object]
			],
			PathLength -> preResolvedPathLength,
			PathLengthMethod -> resolvedPathLengthMethod,
			Wavelength -> If[MatchQ[DeleteDuplicates[resolvedWavelength], {UnitsP[Nanometer]}], First[resolvedWavelength], resolvedWavelength],
			Output -> Lookup[combinedOptions, Output]
		}
	];

	(* --- compute concentrations --- *)

	(* get the absorbances; pull it out of the spectrum for AbsSpec, or just pull the field directly for AbsInt *)
	absorbances = MapThread[
		Function[{packet, wavelength},
			If[MatchQ[packet, ObjectP[Object[Data, AbsorbanceSpectroscopy]]],
				Absorbance[Lookup[packet, AbsorbanceSpectrum], wavelength],
				Lookup[packet, Absorbance]
			]
		],
		{dataPackets, resolvedWavelength}
	];

	(* get the path length; if it's still Automatic here, then need to calculate it *)
	(* The input of calibratePathlength should be the aliquoted sample, if that is available, or samples in *)
	calibrationSamplePackets = If[MatchQ[aliquotPackets,{}],
		samplePackets,
		aliquotPackets
	];
	pathlengths = Switch[Lookup[semiResolvedOps, PathLength],
		Automatic, calibratePathlength[calibrationSamplePackets],
		GreaterP[0 Meter], ConstantArray[Lookup[semiResolvedOps, PathLength], Length[samplesInList]],
		_List, Lookup[semiResolvedOps, PathLength]
	];

	(* if pathlengths is $Failed, then return $Failed (error already in calibratePathlength function) *)
	If[MatchQ[pathlengths, $Failed],
		Return[$Failed]
	];

	(* get the raw concentrations by calling the Concentration function *)
	(* anything negative goes to zero because negative values don't have physical meaning anyway *)
	rawConcentrations = Concentration[absorbances, pathlengths, extCoeffs] /. {LessP[0 Molar] -> 0 Micro Molar, LessP[0 Gram / Liter] -> 0 Gram / Liter};

	(* scale the concentration values and/or convert them to the correct units *)
	concentrations = Map[
		If[ConcentrationQ[#],
			(* Simplify -> False because simplifying Molar doesn't work anyway and it's slow to do it *)
			UnitScale[#, Simplify -> False],
			UnitConvert[#, "Milligrams" / "Milliliters"]
		]&,
		rawConcentrations
	];

	(* group by samples (so if there are replicates) and analytes (thereby leaving open the option of having different analytes in the same sample) *)
	groupedList = Transpose /@ GatherBy[Transpose[{dataPackets, concentrations, pathlengths, absorbances, outputConc, analytePackets}], {Download[Lookup[First[#], SamplesIn], Object], Last[#]}&];

	(* get the grouped values separated out again *)
	{groupedDataObjects, groupedConc, groupedPathlength, groupedAbsorbance, groupedOutputConc, groupedAnalytes} = {groupedList[[All, 1]], groupedList[[All, 2]], groupedList[[All, 3]], groupedList[[All, 4]], groupedList[[All, 5]], groupedList[[All, 6]]};

	(* get an empirical distribution of the calculated concentrations from the absorbances, grouped by sample *)
	groupedDistConc = EmpiricalDistribution /@ groupedConc;

	(* get the samples corresponding to the concentration distributions *)
	sampleUniqueList = Download[Flatten[Lookup[#, SamplesIn]], Object] & /@ groupedDataObjects;

	(* consider dilution factors *)
	(* NOTE that this function only works if you only have one protocol object; if there are data objects split between multiple it gets hairier and will probably not work *)
	sampleDilutions = calculateAbsSpecDilutions[protocolObj, groupedDataObjects];

	(* --- Make the Analysis packets --- *)

	analysisIDs = CreateID[Table[Object[Analysis, AbsorbanceQuantification], Length[sampleUniqueList]]];

	(* filter out the data that are out of linear absorbance range *)
	{inRangePos, minAbs, maxAbs} = inRangeAbsorbance[groupedAbsorbance, semiResolvedOps, protocolObj, sampleUniqueList];

	(* sample dilutions can also be non-constant *)
	concentrationsUndiluted = groupedConc * sampleDilutions;

	concentrationUndilutedDistr = MapThread[EmpiricalDistribution[#1[[#2]]]&, {concentrationsUndiluted, inRangePos}];

	{concSTDs, concDists} = Transpose[Map[
		If[MatchQ[#, Concentration],
			{ConcentrationStandardDeviation, ConcentrationDistribution},
			{MassConcentrationStandardDeviation, MassConcentrationDistribution}
		]&,
		First /@ groupedOutputConc
	]];

	plMethod = If[MatchQ[Lookup[semiResolvedOps, PathLength], GreaterP[0 Meter]], Constant, Ultrasonic];

	(* fill in Object[Analysis, AbsorbanceQuantification] packets for all the datas *)
	absQuantPackets = MapThread[
		Function[{sp, dg, spDil, distCD, id, pl, concSTD, concDist, concField, groupedAnalytePackets},
			Association[Join[
				standardFieldsStart,
				{
					Object -> id,
					Type -> Object[Analysis, AbsorbanceQuantification],
					Protocol -> Link[protocolObj, QuantificationAnalyses],
					ResolvedOptions -> ReplaceRule[semiResolvedOps, {PathLength -> pl, PathLengthMethod -> plMethod, MaxAbsorbance -> maxAbs, MinAbsorbance -> minAbs}],
					Replace[Reference] -> Link[Flatten[dg], QuantificationAnalyses],
					Replace[SamplesIn] -> Flatten[{Link[sp, QuantificationAnalyses]}],
					Analyte -> Link[FirstOrDefault[groupedAnalytePackets]],
					Replace[AbsorbanceSpectra] -> Link[dg, QuantificationAnalyses],
					First[concField] -> Mean[distCD],
					concSTD -> StandardDeviation[distCD],
					concDist -> distCD,
					PathLengthMethod -> plMethod,
					Replace[PathLength] -> pl,
					LinearRangeWarning -> linearRangeWarning
				},
				If[SameQ @@ spDil,
					{SampleDilution -> First[spDil]},
					{Replace[SampleDilutions] -> spDil}
				],
				(* need to manually say that Author -> Null if ParentProtocol -> True; otherwise it already is automatically $PersonID *)
				If[TrueQ[Lookup[safeOptions, ParentProtocol]],
					{Author -> Null},
					{}
				]
			]]
		],
		{sampleUniqueList, groupedDataObjects, sampleDilutions, concentrationUndilutedDistr, analysisIDs, groupedPathlength, concSTDs, concDists, groupedOutputConc, groupedAnalytes}
	];

	(* --- Update the data packets --- *)

	(* get whether I'm going to be populating DilutedConcentration or DilutedMassConcentration *)
	outputConcDiluted = Map[
		If[MatchQ[#, Concentration],
			DilutedConcentration,
			DilutedMassConcentration
		]&,
		outputConc
	];

	(* populate the data packets with the PathLength and Concentration information *)
	dataUpdates = MapThread[
		Function[{dataPacket, conc, pathLength, dilution, concField, concDilutedField},
			<|
				Object -> Lookup[dataPacket, Object],
				concField -> conc * dilution,
				concDilutedField -> conc,
				PathLength -> pathLength,
				PathLengthMethod -> If[MatchQ[Lookup[semiResolvedOps, PathLength], GreaterP[0 Meter]], Constant, Ultrasonic]
			|>
		],
		Flatten /@ {groupedDataObjects, groupedConc, groupedPathlength, sampleDilutions, groupedOutputConc, outputConcDiluted}
	];

	(* --- Update the sample objects --- *)

	(* get whether I'm going to be populating ConcentrationLog or MassConcentrationLog (both grouped and not) *)
	groupedOutputConcLog = Map[
		If[MatchQ[#, Concentration],
			ConcentrationLog,
			MassConcentrationLog
		]&,
		First /@ groupedOutputConc
	];

	(* pull out the concentrations that are going into the sample packets *)
	sampleConcentrations = MapThread[
		Lookup[#1, First[#2]] /. {LessP[0 Molar] -> 0 Micromolar, LessP[0 Gram / Liter] -> 0 Gram / Liter}&,
		{absQuantPackets, groupedOutputConc}
	];

	(* get the sample objects that we are going to be updating *)
	sampleObjs = Map[
		First[Download[Lookup[#, Replace[SamplesIn]], Object]]&,
		absQuantPackets
	];

	(* get the analytes we're going to use to update the sample's composition field *)
	sampleAnalytes = Lookup[absQuantPackets, Analyte];

	(* get the sample compositions for the SamplesIn *)
	oldSampleCompositions = Map[
		Function[{sample},
			Lookup[SelectFirst[Flatten[samplePackets], MatchQ[Lookup[#, Object], sample]&], Composition]
		],
		sampleObjs
	];

	(* group the samples/analytes/compositions/concentrations together based on if they go with the same sample (i.e., we're going to have to update more than one at once) *)
	groupedCompositions = GatherBy[Transpose[{sampleObjs, sampleAnalytes, oldSampleCompositions, sampleConcentrations, groupedOutputConc, groupedOutputConcLog, absQuantPackets}], First];

	(* pull out the samples to update, their corresponding analytes, compositions, and concentrations  *)
	(* these will always be duplicates so just take the first of each grouping *)
	samplesToUpdate = groupedCompositions[[All, 1, 1]];
	oldCompositionsToUpdate = groupedCompositions[[All, 1, 3]];
	concFieldToUpdate = groupedCompositions[[All, 1, 5]];
	concLogFieldToUpdate = groupedCompositions[[All, 1, 6]];
	groupedAbsQuantPackets = groupedCompositions[[All, 1, 7]];

	(* these three might be different so you have to get everything *)
	sampleAnalytesToUpdate = groupedCompositions[[All, All, 2]];
	sampleConcsToUpdate = groupedCompositions[[All, All, 4]];

	(* create replace rules converting the old composition field into the new one for each sample *)
	newSampleCompositionReplaceRules = MapThread[
		Function[{concs, analytes},
			Append[
				MapThread[
					{_, ObjectP[#2]} -> {#1, Link[#2]}&,
					{concs, analytes}
				],
				(* need this because otherwise we are accidentally keeping the old link ID which we won't be able to Upload *)
				{x_, y:ObjectP[]} :> {x, Link[y]}
			]
		],
		{sampleConcsToUpdate, sampleAnalytesToUpdate}
	];

	(* make new composition fields for each sample *)
	newCompositions = MapThread[
		#1 /. #2&,
		{oldCompositionsToUpdate, newSampleCompositionReplaceRules}
	];

	(* generate the sample packets *)
	sampleUpdates = MapThread[
		Function[{sample, composition},
			<|
				Object -> sample,
				Replace[Composition] -> composition
			|>
		],
		{sampleObjs, newCompositions}
	];

	(* get the SamplesIn packet for each data packet *)
	samplesInPacketsPerDataPacket = Map[
		Function[{dataPacket},
			SelectFirst[sampleUpdates, MatchQ[FirstOrDefault[Lookup[dataPacket, SamplesIn]], ObjectP[Lookup[#, Object]]]&, Null]
		],
		dataPackets
	];

	(* --- Update the aliquot sample objects --- *)

	(* pull out the aliquot samples *)
	aliquotSampleObjs = Map[
		Download[Lookup[#, AliquotSamples], Object]&,
		groupedDataObjects
	];

	(* group the aliquots to have duplicates *)
	groupedAliquotAndConcs = MapThread[
		Function[{aliquotSamples, concs, outputConcs},
			GatherBy[Transpose[{aliquotSamples, concs, outputConcs}], #[[1]]&]
		],
		{aliquotSampleObjs, groupedConc, groupedOutputConc}
	];

	(* make the aliquot sample data packets with the weird gathering above; need to do Mean for if we have replicates *)
	(* note that we are actually NOT going to upload this packet because the Concentration field is gone post-samplefest.  Just need them here for the bonkers code below to actually work and I am afraid of figuring out a better way of doing it *)
	aliquotSampleUpdates = Map[
		Function[{groupedAliquotAndConc},
			Map[
				If[MatchQ[#[[1, 1]], {}],
					Nothing,
					<|
						Object -> Download[#[[1, 1, 1]], Object],
						#[[1, 3]] -> Mean[#[[All, 2]]]
					|>
				]&,
				groupedAliquotAndConc
			]
		],
		groupedAliquotAndConcs
	];

	(* for some reason aliquoting is harder than with samples so doing the composition update differently here from above *)
	oldAliquotCompositions = Map[
		Function[{aliquot},
			Lookup[SelectFirst[Flatten[aliquotPackets], Lookup[#, Object] === aliquot &, {}], Composition, {}]
		],
		Lookup[Flatten[aliquotSampleUpdates], Object, {}]
	];

	(* get the analytes for each aliquot sample *)
	analytePerAliquotSampleReplaceRules = Flatten[Map[
		Alternatives @@ Download[Lookup[#, AliquotSamples], Object] -> Download[Lookup[#, Analyte], Object]&,
		dataPackets
	]];

	(* get the aliquot analytes *)
	aliquotAnalytes = Lookup[Flatten[aliquotSampleUpdates], Object, {}] /. analytePerAliquotSampleReplaceRules;

	(* get the new compositions of the analytes in the aliquot packets *)
	newAliquotCompositionReplaceRules = MapThread[
		With[{conc = If[ConcentrationQ[Lookup[#2, Concentration]], Lookup[#2, Concentration], Lookup[#2, MassConcentration]]},
			{
				{_, ObjectP[#1]} :> {conc, Link[#1]},
				({x_, y : ObjectP[]} :> {x, Link[y]})
			}
		]&,
		{aliquotAnalytes, Flatten[aliquotSampleUpdates]}
	];

	(* get the new compositions *)
	newAliquotCompositions = MapThread[
		#1 /. #2&,
		{oldAliquotCompositions, newAliquotCompositionReplaceRules}
	];

	(* make new upload packets with the new compositions *)
	newAliquotCompositionPackets = MapThread[
		<|Object -> #1, Replace[Composition] -> #2|>&,
		{Lookup[Flatten[aliquotSampleUpdates], Object, {}], newAliquotCompositions}
	];

	(* --- Generate rules for each possible Output value ---  *)

	groupedPackets = {{absQuantPackets, Join[dataUpdates, sampleUpdates, newAliquotCompositionPackets]}};

	(* Prepare the Options result if we were asked to do so *)
	resolvedOps = Lookup[First[Flatten[absQuantPackets]], ResolvedOptions];

	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[AnalyzeAbsorbanceQuantification, resolvedOps],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		prevTests,
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result -> If[MemberQ[output, Result],
		With[{analysisPackets = First[First[uploadAnalyzePackets[groupedPackets]]]},
			If[Lookup[resolvedOps, Upload],
				Lookup[analysisPackets, Object],
				If[Lookup[resolvedOps, OutputAll],
					groupedPackets,
					analysisPackets
				]
			]
		],
		Null
	];

	(Lookup[combinedOptions, Output]) /. {previewRule, optionsRule, testsRule, resultRule}


];


calculateAbsSpecDilutions[protocolObj_, groupedDataObjects_] := Module[
	{sampleVolumes, totalVolumes, samples, dilutions, sample2Dilution, groupedDilutions, aliquotSamples,
		allDataValues, dataSamples, dataAliquots, aliquotSamplesWithNull},

	(* sorry for two downloads here; this function is in bad shape and I'm just trying to make it work *)
	{sampleVolumes, totalVolumes, samples, aliquotSamples} = Download[
		protocolObj,
		{AliquotSamplePreparation[[All, AliquotAmount]], AliquotSamplePreparation[[All, AssayVolume]], SamplesIn[Object], AliquotSamples[Object]}
	];
	allDataValues = Download[
		groupedDataObjects,
		{SamplesIn[Object], AliquotSamples[Object]}
	];

	(* get the null-replaced version of AliquotSamples *)
	(* also if the AliquotSamples are the same as the SamplesIn (which can happen) then that should be Null here since they won't be populated in the data objects *)
	aliquotSamplesWithNull = If[MatchQ[aliquotSamples, {}],
		ConstantArray[Null, Length[samples]],
		MapThread[
			If[MatchQ[#1, ObjectP[#2]],
				Null,
				#2
			]&,
			{samples, aliquotSamples}
		]
	];

	(* pull out the sample and aliquot values from the grouped data objects *)
	(* need to do the weird Null shenanigans for cases where we don't have any AliquotSamples *)
	dataSamples = Join @@@ allDataValues[[All, All, 1]];
	dataAliquots = Join @@@ (allDataValues[[All, All, 2]] /. {{} -> {Null}});

	If[MatchQ[sampleVolumes, {}], Return[ConstantArray[1, Length[#]]& /@ groupedDataObjects]];

	dilutions = totalVolumes / sampleVolumes;

	sample2Dilution = AssociationThread[Transpose[{samples, aliquotSamplesWithNull}] -> dilutions];

	(* correct the well order by the input dataObjects *)
	groupedDilutions = MapThread[
		Lookup[sample2Dilution, Transpose[{#1, #2}]]&,
		{dataSamples, dataAliquots}
	];

	groupedDilutions

];


calibratePathlength[samplesInPackets_] := Module[
	{volData, volumeDownloadValues, listedDataPackets, calibrationPackets, pathlengths},

	volData = Cases[Lookup[#, Data], ObjectP[Object[Data, Volume]]]& /@ samplesInPackets;

	(* Download stuff from the volume data *)
	volumeDownloadValues = Quiet[Download[
		volData,
		{
			Packet[VolumeCalibration, SamplesIn, LiquidLevelDistribution],
			Packet[VolumeCalibration[{EmptyDistanceDistribution, WellEmptyDistanceDistributions, ContainerModels}]]
		}
	], Download::FieldDoesntExist];

	listedDataPackets = volumeDownloadValues[[All, All, 1]];
	calibrationPackets = volumeDownloadValues[[All, All, 2]];

	If[!MatchQ[listedDataPackets, {{ObjectP[Object[Data, Volume]]..}..}],
		Message[Error::PathlengthUnknown];
		Return[$Failed]
	];

	pathlengths = MapThread[
		Function[{sample, dataPackets},
			Module[{volumeDataPacket, liquidLevelDistribution, volumeCalibration, volumeCalibrationPacket, emptyDistance, liquidLevelDistributionRaw},
				(* Find the Object[Data,Volume] packet for the current sample *)
				volumeDataPacket = SelectFirst[dataPackets, MemberQ[Lookup[#, SamplesIn], ObjectP[Lookup[sample, Object]]] && Not[NullQ[Lookup[#, LiquidLevelDistribution]]]&];

				(* Get the liquid level and the volume calibration object *)
				liquidLevelDistributionRaw = Lookup[volumeDataPacket, LiquidLevelDistribution];
				volumeCalibration = Download[Lookup[volumeDataPacket, VolumeCalibration], Object];

				(* for some reason, this can be stored in the database with or without units, so add the units if they're not supplied *)
				liquidLevelDistribution = If[MatchQ[liquidLevelDistributionRaw, DistributionP[Millimeter]],
					liquidLevelDistributionRaw,
					liquidLevelDistributionRaw * Millimeter
				];

				volumeCalibrationPacket = SelectFirst[Flatten[calibrationPackets], MatchQ[Lookup[#, Object], ObjectP[volumeCalibration]]&];

				emptyDistance = InternalExperiment`Private`wellEmptyDistanceDistribution[volumeCalibrationPacket,Lookup[sample,Position,Null]/.Null->"A1",FastTrack->True];

				emptyDistance - liquidLevelDistribution
			]
		],
		{samplesInPackets, listedDataPackets}
	];

	Mean /@ pathlengths

];


inRangeAbsorbance[absorbances_, resolvedOps_, protObj_, sampleUniqueList_] := Module[
	{linearRange, minAbs, maxAbs},

	linearRange = If[MatchQ[protObj, ObjectP[{Object[Protocol, AbsorbanceSpectroscopy], Object[Protocol, AbsorbanceIntensity]}]],
		Download[protObj, Instrument[Model][LinearAbsorbanceRange]],
		Download[protObj, PlateReader[Model][LinearAbsorbanceRange]]
	];
	minAbs = If[MatchQ[Lookup[resolvedOps, MinAbsorbance], Automatic],
		If[MatchQ[linearRange, Null],
			0.8 AbsorbanceUnit,
			First[linearRange]
		],
		Lookup[resolvedOps, MinAbsorbance]
	];

	maxAbs = If[MatchQ[Lookup[resolvedOps, MaxAbsorbance], Automatic],
		If[MatchQ[linearRange, Null],
			2.3 AbsorbanceUnit,
			Last[linearRange]
		],
		Lookup[resolvedOps, MaxAbsorbance]
	];

	(* get positions of in-range data *)
	{
		MapThread[filterOrContinue[#1, minAbs, maxAbs, #2, !Lookup[resolvedOps, ParentProtocol]]&, {absorbances, sampleUniqueList}],
		minAbs,
		maxAbs
	}

];


filterOrContinue[absorbance_, minAbs_, maxAbs_, sample_, throwWarningQ_] := Module[
	{res},

	res = Flatten[Quiet[Position[absorbance, _?((# >= minAbs && # <= maxAbs)&)]]];

	If[res =!= {},
		res,

		If[throwWarningQ, Message[Warning::AllAbsOutOfRange, sample, minAbs, maxAbs]];
		linearRangeWarning = True;
		Range[Length[absorbance]]
	]

];



(* ::Subsection:: *)
(*AnalyzeAbsorbanceQuantificationOptions*)


DefineOptions[AnalyzeAbsorbanceQuantificationOptions,
	SharedOptions :> {AnalyzeAbsorbanceQuantification},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}];


AnalyzeAbsorbanceQuantificationOptions[in : ListableP[ObjectP[{Object[Data, AbsorbanceSpectroscopy], Object[Data, AbsorbanceIntensity]}]], ops : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	options = AnalyzeAbsorbanceQuantification[in, Sequence @@ Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, AnalyzeAbsorbanceQuantification],
		options
	]
];


(* ::Subsection:: *)
(*ValidAnalyzeAbsorbanceQuantificationQ*)


DefineOptions[ValidAnalyzeAbsorbanceQuantificationQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeAbsorbanceQuantification}
];


ValidAnalyzeAbsorbanceQuantificationQ[in : ListableP[ObjectP[{Object[Data, AbsorbanceSpectroscopy], Object[Data, AbsorbanceIntensity]}]], ops : OptionsPattern[]] := Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Normal@KeyDrop[Append[ToList[ops], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests = AnalyzeAbsorbanceQuantification[in, Sequence @@ preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest, validObjectBooleans, inputObjs, voqWarnings},
			initialTest = Test[initialTestDescription, True, True];

			(* Create warnings for invalid objects *)
			inputObjs = Cases[Flatten[{in}], _Object | _Model];

			If[!MatchQ[inputObjs, {}],
				validObjectBooleans = ValidObjectQ[inputObjs, OutputFormat -> Boolean];

				voqWarnings = MapThread[
					Warning[ToString[#1, InputForm] <> " is valid (run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjs, validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[ToList[functionTests], voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidAnalyzeAbsorbanceQuantificationQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidAnalyzeAbsorbanceQuantificationQ"]
];
