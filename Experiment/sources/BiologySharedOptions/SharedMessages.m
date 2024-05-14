(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection:: *)
(* BiologySharedMessages *)

Error::InvalidSolidMediaSample = "The following object(s) are in solid media and therefore cannot be used in this experiment: `1`.  Please check the CultureAdhesion field of the samples in question, or provide alternative samples that are not in solid media.";
Warning::RepeatedLysis = "The sample(s), `1`, at indices `2`, have Lyse set to True, but the Living field in the sample is set to False. Cell Lysis is not required if the sample does not contain living cells.";
Warning::UnlysedCellsInput = "The sample(s), `1`, at indices `2` have the Living field set to True, but Lyse is not set to True. It is recommended that Living cells are lysed prior to extracting cellular components.";
(*Error::RoboticInstrumentInvalidCellType*)
(*Warning::RoboticInstrumentCellTypeMismatch*)
Error::LysisConflictingOptions = "For the following input samples: `1`, at the following indices:`2`, the following lysis options are set even though Lyse is set to False: `3`. Either all lysis options must be set to Null or Lyse must be set to True.";
Error::PrecipitationConflictingOptions = "For the input samples `1` at indices `2`, the following precipitation options are set even though Purification does not include Precipitation: `3`. Either all precipitation options must be set to Null or Purification must contain Precipitation.";
Error::MagneticBeadSeparationConflictingOptions = "For the input samples `1` at indices `2`, the following magnetic bead separation options are set even though Purification does not include MagneticBeadSeparation: `3`. Either all magnetic bead separation options must be set to Null or Purification must contain MagneticBeadSeparation.";
Error::SolidPhaseExtractionConflictingOptions = "For the input samples `1` at indices `2`, the following solid phase extraction options are set even though Purification does not include SolidPhaseExtraction: `3`. Either all solid phase extraction options must be set to Null or Purification must contain SolidPhaseExtraction.";
Error::LiquidLiquidExtractionConflictingOptions = "For the input samples `1` at indices `2`, the following liquid-liquid extraction options are set even though Purification does not include LiquidLiquidExtraction: `3`. Either all magnetic bead separation options must be set to Null or Purification must contain LiquidLiquidExtraction.";
Error::ConflictingLysisOutputOptions = "The sample(s), `1`, at indices, `2`, have lysis as the last step in the extraction, but have conflicting output options. Since LysisAliquot is set to, `3`, and ClarifyLysate is set to, `4`, the following options or values, `5`, set to, `6`, should match the following output options, `7`, set to ,`8`. Please make sure that specified options to match to submit a valid experiment.";

(* -- SOLID MEDIA CHECK -- *)
(* NOTE: to test if the Samples are in solid media (and therefore cannot be transferred properly).*)

DefineOptions[
	checkSolidMedia,
	Options:>{CacheOption}
];

checkSolidMedia[mySamplePackets:{PacketP[Object[Sample]]..},messagesQ:BooleanP,myOptions:OptionsPattern[checkSolidMedia]]:=Module[{solidMediaSamplePackets,solidMediaInvalidInputs,solidMediaTest,safeOptions,cache},

	safeOptions = SafeOptions[checkSolidMedia,ToList[myOptions]];

	cache = Lookup[safeOptions,Cache];

	(* Get the samples from samplePackets that are in solid media. *)
	solidMediaSamplePackets = Select[Flatten[mySamplePackets], MatchQ[Lookup[#, CultureAdhesion], SolidMedia]&];

	(* Set solidMediaInvalidInputs to the input objects whose CultureAdhesion are SolidMedia *)
	solidMediaInvalidInputs = Lookup[solidMediaSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[solidMediaInvalidInputs] > 0 && messagesQ,
		Message[Error::InvalidSolidMediaSample, ObjectToString[solidMediaInvalidInputs, Cache -> cache]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	solidMediaTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[solidMediaInvalidInputs] == 0,
				Nothing,
				Test["The input samples "<>ObjectToString[solidMediaInvalidInputs, Cache -> cache]<>" are not in solid media:", True, False]
			];
			passingTest = If[Length[solidMediaInvalidInputs] == Length[mySamplePackets],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamplePackets, solidMediaInvalidInputs], Cache -> cache]<>" are not in solid media:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	{solidMediaInvalidInputs,solidMediaTest}
];


(* -- DISCARDED SAMPLE CHECK -- *)

DefineOptions[
	checkDiscardedSamples,
	Options:>{CacheOption}
];

checkDiscardedSamples[mySamplePackets:{PacketP[Object[Sample]]..},messagesQ:BooleanP,myOptions:OptionsPattern[checkDiscardedSamples]]:=Module[{discardedSamplePackets,discardedSampleInvalidInputs,discardedSampleTest,safeOptions,cache},

	safeOptions = SafeOptions[checkDiscardedSamples,ToList[myOptions]];

	cache = Lookup[safeOptions,Cache];

	(* Get the samples from samplePackets that are in solid media. *)
	discardedSamplePackets = Select[Flatten[mySamplePackets], MatchQ[Lookup[#, Status], Discarded]&];

	(* Set solidMediaInvalidInputs to the input objects whose CultureAdhesion are SolidMedia *)
	discardedSampleInvalidInputs = Lookup[discardedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedSampleInvalidInputs] > 0 && messagesQ,
		Message[Error::DiscardedSamples, ObjectToString[discardedSampleInvalidInputs, Cache -> cache]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	discardedSampleTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[discardedSampleInvalidInputs] == 0,
				Nothing,
				Test["The input samples "<>ObjectToString[discardedSampleInvalidInputs, Cache -> cache]<>" are not discarded:", True, False]
			];
			passingTest = If[Length[discardedSampleInvalidInputs] == Length[mySamplePackets],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySamplePackets, discardedSampleInvalidInputs], Cache -> cache]<>" are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	{discardedSampleInvalidInputs,discardedSampleTest}
];

(* -- DEPRECATED MODEL CHECK -- *)

DefineOptions[
	checkDeprecatedSampleModels,
	Options:>{CacheOption}
];

checkDeprecatedSampleModels[mySampleModelPackets:{PacketP[Model[Sample]]..},messagesQ:BooleanP,myOptions:OptionsPattern[checkDeprecatedSampleModels]]:=Module[{deprecatedSamplePackets,deprecatedInvalidInputs,deprecatedTest,safeOptions,cache},

	safeOptions = SafeOptions[checkDeprecatedSampleModels,ToList[myOptions]];

	cache = Lookup[safeOptions,Cache];

	(* Get the samples from samplePackets that are in solid media. *)
	deprecatedSamplePackets = Select[Flatten[mySampleModelPackets], If[MatchQ[#, Except[Null]], MatchQ[Lookup[#, Deprecated], True]]&];

	(* Set solidMediaInvalidInputs to the input objects whose CultureAdhesion are SolidMedia *)
	deprecatedInvalidInputs = Lookup[deprecatedSamplePackets, Object, {}];

	(* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
	If[Length[deprecatedInvalidInputs] > 0 && messagesQ,
		Message[Error::DeprecatedModels, ObjectToString[deprecatedInvalidInputs, Cache -> cache]];
	];

	(* If we are gathering tests,create a passing and/or failing test with the appropriate result. *)
	deprecatedTest = If[!messagesQ,
		Module[{failingTest, passingTest},
			failingTest = If[Length[deprecatedInvalidInputs] == 0,
				Nothing,
				Test["The input samples "<>ObjectToString[deprecatedInvalidInputs, Cache -> cache]<>" are not discarded:", True, False]
			];
			passingTest = If[Length[deprecatedInvalidInputs] == Length[mySampleModelPackets],
				Nothing,
				Test["The input samples "<>ObjectToString[Complement[mySampleModelPackets, deprecatedInvalidInputs], Cache -> cache]<>" are not discarded:", True, True]
			];
			{failingTest, passingTest}
		],
		Null
	];

	{deprecatedInvalidInputs,deprecatedTest}
];

