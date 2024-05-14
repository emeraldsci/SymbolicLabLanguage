(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* General Functions *)

(* NOTE: We have to delay the loading of these options until the primitive framework is loaded since we're copying options *)
(* from there. *)
DefineOptions[resolveSolidPhaseExtractionMethod,
	SharedOptions:>{
		ExperimentSolidPhaseExtraction,
		CacheOption,
		SimulationOption
	}
];

DefineUsage[resolveSolidPhaseExtractionMethod,
	{
		BasicDefinitions -> {
			{
				Definition -> {"resolveSolidPhaseExtractionMethod[objects]","potentialMethods"},
				Description -> "based on the given 'objects' and options, generates the 'potentialMethods' that can be used by this protocol, either on the robotic liquid handler or manually (or both).",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objects",
							Description-> "The samples that should be run on solid phase extraction.",
							Widget->Alternatives[
								Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
									}
								],
								Widget[
									Type->Enumeration,
									Pattern:>Alternatives[Automatic]
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName -> "potentialMethods",
						Description -> "The potential methods, robotic or manual, on which this filter operation can be performed.",
						Pattern :> {({RoboticSamplePreparation, ManualSamplePreparation, RoboticCellPreparation, ManualCellPreparation})...}
					}
				}
			}
		},
		SeeAlso -> {
			"resolveSolidPhaseExtractionRoboticPrimitive",
			"ExperimentSolidPhaseExtraction"
		},
		Author -> {
			"nont.kosaisawe"
		}
	}
];

resolveSolidPhaseExtractionMethod[myContainers : ListableP[Automatic|ObjectP[{Object[Container], Object[Sample]}]], myOptions : OptionsPattern[]]:=Module[
	{safeOps, cache, simulation, potentialMethods, outputSpecification, output, gatherTests, speTests, newCache, allPackets, speOptions, listedInputs, expandedSafeOps,
		spePreparation, result, tests},

	(* make sure these are a list *)
	listedInputs = ToList[myContainers];

	(* get the safe options expanded *)
	safeOps = SafeOptions[resolveSolidPhaseExtractionMethod, ToList[myOptions]];
	expandedSafeOps = Last[ExpandIndexMatchedInputs[resolveSolidPhaseExtractionMethod, {listedInputs}, safeOps]];

	(* pull out the cache, simulation, and potential methods *)
	{cache, simulation, potentialMethods} = Lookup[safeOps, {Cache, Simulation, PotentialMethods}];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Download everything we need *)
	allPackets = Flatten[Quiet[Download[
		{
			listedInputs
		},
		{
			{
				Packet[Contents[[All, 2]]]
			}
		},
		Cache -> cache,
		Simulation -> simulation
	], {Download::FieldDoesntExist, Download::NotLinkField}]];

	(* combine everything to make the new cache *)
	newCache = FlattenCachePackets[{cache, allPackets}];

	(* our preparation logic is inside SPE option resolver *)
	{speOptions, speTests} = If[gatherTests,
		ExperimentSolidPhaseExtraction[myContainers, Cache -> newCache, Output -> {Options, Tests}],
		{ExperimentSolidPhaseExtraction[myContainers, Cache -> newCache, Output -> Options], {}}
	];
	spePreparation = Lookup[speOptions, Preparation];

	(* Return our result and tests. *)
	result = spePreparation;

	outputSpecification/.{Result->result, Tests->tests}
];