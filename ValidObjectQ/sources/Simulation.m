(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validSimulationQTests*)


validSimulationQTests[packet:PacketP[Object[Simulation]]] := {
	NotNullFieldTest[
		packet,
		{
			Status,
			DateConfirmed,
			Author,
			ResolvedOptions
		}
	],


	Test["If Status is Running, DateConfirmed/DateStarted must all be informed. DateCompleted/DateCanceled must all be Null:",
		If[MatchQ[Lookup[packet,Status],Running],
			Lookup[packet,{DateConfirmed,DateStarted,DateCompleted,DateCanceled}]
		],
		{Except[NullP],Except[NullP],Null,Null}|Null
	],

(*	Test["If Status is Completed, DateConfirmed/DateStarted/DateCompleted must all be informed. DateCanceled must be Null:",
		If[MatchQ[Lookup[packet,Status],Completed],
			Lookup[packet,{DateConfirmed,DateStarted,DateCompleted,DateCanceled}]
		],
		{Except[NullP],Except[NullP],Except[NullP],Null}|Null
	],*)

	Test["If Status is Canceled, DateConfirmed/DateStarted/DateCanceled must all be informed. DateCompleted must be Null:",
		If[MatchQ[Lookup[packet,Status],Canceled],
			Lookup[packet,{DateConfirmed,DateStarted,DateCompleted,DateCanceled}]
		],
		{Except[NullP],Except[NullP],Null,Except[NullP]}|Null
	],

	Test["If Status is Aborted, DateConfirmed/DateStarted must all be informed. DateCanceled/DateCompleted must be Null:",
		If[MatchQ[Lookup[packet,Status],Aborted],
			Lookup[packet,{DateConfirmed,DateStarted,DateCompleted,DateCanceled}]
		],
		{Except[NullP],Except[NullP],Null,Null}|Null
	],

	(* If informed, all dates (DateConfirmed,DateOrdered,DateShipped,DateDelivered,DateCanceled) are in the past *)
	Test["If DateConfirmed is informed, it is in the past:",
		Lookup[packet, DateConfirmed],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],
	Test["If DateStarted is informed, it is in the past:",
		Lookup[packet, DateStarted],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],
	Test["If DateCompleted is informed, it is in the past:",
		Lookup[packet, DateCompleted],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],
	Test["If DateCanceled is informed, it is in the past:",
		Lookup[packet, DateCanceled],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	(* Date orders *)
	FieldComparisonTest[packet,{DateCompleted,DateStarted},GreaterEqual],
	FieldComparisonTest[packet,{DateCompleted,DateConfirmed},GreaterEqual],

	FieldComparisonTest[packet,{DateCanceled,DateStarted},GreaterEqual],
	FieldComparisonTest[packet,{DateCanceled,DateConfirmed},GreaterEqual],

	FieldComparisonTest[packet,{DateStarted,DateConfirmed},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validSimulationEnthalpyQTests*)


validSimulationEnthalpyQTests[packet:PacketP[Object[Simulation,Enthalpy]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			Reactants,
			Products,
			Reaction
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,Enthalpy}],

	(* sync tests *)
	Test["Reaction matches ReactionModel, if it exists:",
		If[!MatchQ[Lookup[packet,ReactionModel],Null],
			MatchQ[Lookup[packet,Reaction],Download[Lookup[packet,ReactionModel],Reaction]],
			True
		],
		True
	],
	Test["Reactants contains any existing ReactantModels, if it exists:",
		If[!MatchQ[Lookup[packet,ReactantModels],{}],
			ContainsAll[Lookup[packet,Reactants],Download[Lookup[packet,ReactantModels],Molecule]],
			True
		],
		True
	],
	Test["Products contains any existing ProductModels, if it exists:",
		If[!MatchQ[Lookup[packet,ProductModels],{}],
			ContainsAll[Lookup[packet,Products],Download[Lookup[packet,ProductModels],Molecule]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationEntropyQTests*)


validSimulationEntropyQTests[packet:PacketP[Object[Simulation,Entropy]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			Reactants,
			Products,
			Reaction
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,Entropy}],

	(* sync tests *)
	Test["Reaction matches ReactionModel, if it exists:",
		If[!MatchQ[Lookup[packet,ReactionModel],Null],
			MatchQ[Lookup[packet,Reaction],Download[Lookup[packet,ReactionModel],Reaction]],
			True
		],
		True
	],
	Test["Reactants contains any existing ReactantModels, if it exists:",
		If[!MatchQ[Lookup[packet,ReactantModels],{}],
			ContainsAll[Lookup[packet,Reactants],Download[Lookup[packet,ReactantModels],Molecule]],
			True
		],
		True
	],
	Test["Products contains any existing ProductModels, if it exists:",
		If[!MatchQ[Lookup[packet,ProductModels],{}],
			ContainsAll[Lookup[packet,Products],Download[Lookup[packet,ProductModels],Molecule]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationEquilibriumConstantQTests*)


validSimulationEquilibriumConstantQTests[packet:PacketP[Object[Simulation,EquilibriumConstant]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			Temperature
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,EquilibriumConstant}],
	RequiredTogetherTest[packet,{Reactants,Products,Reaction}],

	(* sync tests *)
	Test["Reaction matches ReactionModel, if it exists:",
		If[!MatchQ[Lookup[packet,ReactionModel],Null],
			MatchQ[Lookup[packet,Reaction],Download[Lookup[packet,ReactionModel],Reaction]],
			True
		],
		True
	],
	Test["Reactants contains any existing ReactantModels, if it exists:",
		If[!MatchQ[Lookup[packet,ReactantModels],{}],
			ContainsAll[Lookup[packet,Reactants],Download[Lookup[packet,ReactantModels],Molecule]],
			True
		],
		True
	],
	Test["Products contains any existing ProductModels, if it exists:",
		If[!MatchQ[Lookup[packet,ProductModels],{}],
			ContainsAll[Lookup[packet,Products],Download[Lookup[packet,ProductModels],Molecule]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationFreeEnergyQTests*)


validSimulationFreeEnergyQTests[packet:PacketP[Object[Simulation,FreeEnergy]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			Temperature
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,FreeEnergy}],
	RequiredTogetherTest[packet,{Reactants,Products,Reaction}],

	(* sync tests *)
	Test["Reaction matches ReactionModel, if it exists:",
		If[!MatchQ[Lookup[packet,ReactionModel],Null],
			MatchQ[Lookup[packet,Reaction],Download[Lookup[packet,ReactionModel],Reaction]],
			True
		],
		True
	],
	Test["Reactants contains any existing ReactantModels, if it exists:",
		If[!MatchQ[Lookup[packet,ReactantModels],{}],
			ContainsAll[Lookup[packet,Reactants],Download[Lookup[packet,ReactantModels],Molecule]],
			True
		],
		True
	],
	Test["Products contains any existing ProductModels, if it exists:",
		If[!MatchQ[Lookup[packet,ProductModels],{}],
			ContainsAll[Lookup[packet,Products],Download[Lookup[packet,ProductModels],Molecule]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationEquilibriumQTests*)


validSimulationEquilibriumQTests[packet:PacketP[Object[Simulation,Equilibrium]]] :=
{
	(* not null shared fields *)
	NotNullFieldTest[
		packet,
		{
			Temperature,
			ReactionMechanism,
			InitialState,
			Species
		}
	],

	(* completion tests *)
	RequiredTogetherTest[packet,{DateCompleted,EquilibriumState}]
};


(* ::Subsection::Closed:: *)
(*validSimulationFoldingQTests*)


validSimulationFoldingQTests[packet:PacketP[Object[Simulation,Folding]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			InitialStructure,
			Method,
			Temperature
		}
	],

	(* FoldingInterval checks *)
	Test["Folding Interval is well formed:",
		If[!MatchQ[Lookup[packet,FoldingInterval],{Null, Null, Null}],
			Less@@Lookup[packet,FoldingInterval][[2;;]],
			True
		],
		True
	],
	Test["Folding Interval exists in InitialStructure:",
		If[!MatchQ[Lookup[packet,FoldingInterval],{Null, Null, Null}],
			Module[
				{strInd,baseStart,baseEnd},
				{strInd,baseStart,baseEnd} = Lookup[packet,FoldingInterval];
				And[
					strInd <= Length[Lookup[packet,InitialStructure][Strands]],
					Unitless[baseEnd]<= StrandLength[Lookup[packet,InitialStructure][Strands][[strInd]]]
				]
			],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationHybridizationQTests*)


validSimulationHybridizationQTests[packet:PacketP[Object[Simulation,Hybridization]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			InitialStructure,
			Depth,
			MinLevel
		}
	],

	(* HybridizedNumberOfBonds check *)
	Test["HybridizedNumberOfBonds has correct numbers:",
		If[!MatchQ[Lookup[packet, HybridizedNumberOfBonds],Null] &&
		   Lookup[packet, MaxMismatch]==0,
			And@@(#>=Lookup[packet, MinLevel]&/@Lookup[packet, HybridizedNumberOfBonds]),
			True
		],
		True
	],

	(* HybridizedStructures check *)
	Test["HybridizedStructures has no duplicates and is a single list:",
		If[MatchQ[Lookup[packet, HybridizedStructures],Null],
			MatchQ[Lookup[packet, HybridizedStructures], {StructureP..}] &&
			SameQ[DeleteDuplicates[StructureSort/@Lookup[packet, HybridizedStructures]],
				  Lookup[packet, HybridizedStructures]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationKineticsQTests*)


validSimulationKineticsQTests[packet:PacketP[Object[Simulation,Kinetics]]]:=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			ObservedSpecies,
			ReactionMechanism,
			InitialState,
			Method,
			Species,
			SimulationTime
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,Trajectory,FinalState,TemperatureProfile}],
	RequiredTogetherTest[packet,{InitialVolume,VolumeProfile}],

	Test["Temperature or TemperatureFunction must be informed:",
		Lookup[packet,{Temperature,TemperatureFunction}],
		Except[{Null,Null}]
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationReactionMechanismQTests*)


validSimulationReactionMechanismQTests[packet:PacketP[Object[Simulation,ReactionMechanism]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			InitialState
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,ReactionMechanism}]
};


(* ::Subsection::Closed:: *)
(*validSimulationMeltingTemperatureQTests*)


validSimulationMeltingTemperatureQTests[packet:PacketP[Object[Simulation,MeltingTemperature]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			Concentration
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{DateCompleted,MeltingTemperature}],
	RequiredTogetherTest[packet,{Reactants,Products,Reaction}],

	(* sync tests *)
	Test["Reaction matches ReactionModel, if it exists:",
		If[!MatchQ[Lookup[packet,ReactionModel],Null],
			MatchQ[Lookup[packet,Reaction],Download[Lookup[packet,ReactionModel],Reaction]],
			True
		],
		True
	],
	Test["Reactants contains any existing ReactantModels, if it exists:",
		If[!MatchQ[Lookup[packet,ReactantModels],{}],
			ContainsAll[Lookup[packet,Reactants],Download[Lookup[packet,ReactantModels],Molecule]],
			True
		],
		True
	],
	Test["Products contains any existing ProductModels, if it exists:",
		If[!MatchQ[Lookup[packet,ProductModels],{}],
			ContainsAll[Lookup[packet,Products],Download[Lookup[packet,ProductModels],Molecule]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationPrimerSetQTests*)


validSimulationPrimerSetQTests[packet:PacketP[Object[Simulation,PrimerSet]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			TargetSequence,
			MinPrimerLength,
			MaxPrimerLength,
			MinAmpliconLength,
			MaxAmpliconLength,
			NumberOfCandidates,
			PrimerConcentration,
			ProbeConcentration,
			TargetConcentration,
			AnnealingTime,
			AnnealingTemperature,
			Orientation
		}
	],

	(* misc *)
	RequiredTogetherTest[packet,{MinBeaconStemLength,MaxBeaconStemLength,Beacons,TopBeacons,BeaconSequences,BeaconPositions,BeaconConcentrations}],
	RequiredTogetherTest[packet,{Target,TargetName}],

	(* if simulation is complete, must have these *)
	RequiredTogetherTest[packet,{DateCompleted,ForwardPrimers,TopForwardPrimers,PrimerPairs,ForwardPrimerSequences,ForwardPrimerPositions,ForwardPrimerConcentrations,ReversePrimerConcentrations,ReversePrimerSequences,ReversePrimerPositions}],

	FieldComparisonTest[packet,{MinBeaconStemLength,MaxBeaconStemLength},LessEqual],
	FieldComparisonTest[packet,{MinPrimerLength,MaxPrimerLength},LessEqual],
	FieldComparisonTest[packet,{MinAmpliconLength,MaxAmpliconLength},LessEqual],

	(* target name and sequence synced with target model *)
	Test["TargetName matches Name from Target model:",
		If[!NullQ[Lookup[packet,Target]],
			MatchQ[Lookup[packet,TargetName],Download[Lookup[packet,Target],Name]],
			True
		],
		True
	],
	Test["TargetSequence matches Sequence from Target model:",
		If[!NullQ[Lookup[packet,Target]],
			MatchQ[ToList[Lookup[packet,TargetSequence]],ToDNA[ToSequence[Download[Lookup[packet,Target],Molecule]]]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validSimulationMeltingCurveQTests*)


validSimulationMeltingCurveQTests[packet:PacketP[Object[Simulation,MeltingCurve]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			HighTemperature,
			LowTemperature,
			TemperatureStep,
			TemperatureRampRate,
			EquilibrationTime,
			StepEquilibriumTime,
			UnboundState,
			ReactionMechanism
		}
	],

	(* misc *)
	FieldComparisonTest[packet,{LowTemperature,HighTemperature},LessEqual],
	RequiredTogetherTest[packet,{DateCompleted,MeltingCurve,CoolingCurve}]
};



(* ::Subsection::Closed:: *)
(*validSimulationProbeSelectionQTests*)


validSimulationProbeSelectionQTests[packet:PacketP[Object[Simulation,ProbeSelection]]] :=
{
	(* not null *)
	NotNullFieldTest[
		packet,
		{
			TargetSequence,
			Time,
			Temperature,
			ProbeLength,
			TargetConcentration,
			ProbeConcentration
		}
	],

	(* misc *)
	Test["ProbeLength must be less than TargetSequence length:",
		If[!MatchQ[Lookup[packet,TargetSequence],Null],
			With[{probelen = Lookup[packet,ProbeLength]},
				Switch[probelen,
					_Integer, probelen,
					_List, Min[probelen]
				] <= SequenceLength[Lookup[packet,TargetSequence], FastTrack->True]
			],
			True
		],
		True
	],

	RequiredTogetherTest[packet,{ProbeConcentration,TargetConcentration,Temperature,Time}]
};


(* ::Subsection::Closed:: *)
(*Test Registration *)


registerValidQTestFunction[Object[Simulation],validSimulationQTests];
registerValidQTestFunction[Object[Simulation, Hybridization],validSimulationQTests];
registerValidQTestFunction[Object[Simulation, Enthalpy],validSimulationEnthalpyQTests];
registerValidQTestFunction[Object[Simulation, Entropy],validSimulationEntropyQTests];
registerValidQTestFunction[Object[Simulation, EquilibriumConstant],validSimulationEquilibriumConstantQTests];
registerValidQTestFunction[Object[Simulation, FreeEnergy],validSimulationFreeEnergyQTests];
registerValidQTestFunction[Object[Simulation, Equilibrium],validSimulationEquilibriumQTests];
registerValidQTestFunction[Object[Simulation, Folding],validSimulationFoldingQTests];
registerValidQTestFunction[Object[Simulation, Hybridization],validSimulationHybridizationQTests];
registerValidQTestFunction[Object[Simulation, Kinetics],validSimulationKineticsQTests];
registerValidQTestFunction[Object[Simulation, ReactionMechanism],validSimulationReactionMechanismQTests];
registerValidQTestFunction[Object[Simulation, MeltingTemperature],validSimulationMeltingTemperatureQTests];
registerValidQTestFunction[Object[Simulation, PrimerSet],validSimulationPrimerSetQTests];
registerValidQTestFunction[Object[Simulation, MeltingCurve],validSimulationMeltingCurveQTests];
registerValidQTestFunction[Object[Simulation, ProbeSelection],validSimulationProbeSelectionQTests];
