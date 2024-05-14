(* ::Package:: *)

(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection:: *)
(*Sample History Cards*)


(* Map of Sample History Card to Keys in the card: *)
$SampleHistoryCardKeys=<|
	Initialized->{Date,ResponsibleParty,Amount,Composition,Model,Container,ContainerModel,Position},
	ExperimentStarted->{Date,Protocol,Subprotocol,Role},
	ExperimentEnded->{Date,Protocol,Subprotocol,StorageCondition,Location},
	Centrifuged->{Date,Protocol,InstrumentModel,Force,Rate,Time,Temperature},
	Incubated->{Date,Protocol,InstrumentModel,MixType,Time,Temperature,NumberOfMixes,MixVolume,Amplitude,DutyCycle,Rate},
	Evaporated->{Date,Protocol,InstrumentModel,EvaporationType,Temperature,Pressure,Time,PressureRampTime,FlowRateProfile,RotationRate},
	FlashFrozen->{Date,Protocol,InstrumentModel,Time},
	Degassed->{Date,Protocol,InstrumentModel,DegasType,FreezeTime,PumpTime,ThawTime,NumberOfCycles,VacuumTime,VacuumSonicate,ThawTemperature,SpargingGas,SpargingTime},
	Desiccated->{Date,Protocol,InstrumentModel,Method},
	Filtered->{Date,InstrumentModel,Type,PoreSize,MembraneMaterial,Temperature,Time},
	Restricted->{Date,ResponsibleParty},
	Unrestricted->{Date,ResponsibleParty},
	SetStorageCondition->{Date,ResponsibleParty,StorageCondition},
	Measured->{Amount,pH,Appearance,Density,Conductivity,Data,Protocol},
	StateChanged->{Date, Protocol, Handling, State},
	Sterilized->{Date, Protocol},
	Transferred->{Date,Direction,Source,Destination,Amount,Protocol},
	AcquiredData->{Date,Data,Protocol},
	Shipped->{Date,Source,Destination,ResponsibleParty,Transaction},
	DefinedComposition->{Date,Composition,ResponsibleParty},
	Lysed->{
		Date,Protocol,LysisSolution,SecondaryLysisSolution,TertiaryLysisSolution,LysisTemperature,
		SecondaryLysisTemperature,TertiaryLysisTemperature,LysisTime,SecondaryLysisTime,TertiaryLysisTime
	},
	Washed->{
		Date,Protocol,WashSolution, ResuspensionMedia, CellIsolationTime, WashIsolationTime, WashMixTime, ResuspensionMixTime, WashSolutionEquilibrationTime, ResuspensionMediaEquilibrationTime, WashSolutionTemperature, WashTemperature, ResuspensionMediaTemperature, ResuspensionTemperature
	}
|>;

(* Map of Sample History Card to their icons. *)
$SampleHistoryCardIcons=<|
	Initialized->"Initialized",
	ExperimentStarted->"Experiment",
	ExperimentEnded->"Experiment",
	Centrifuged->"Centrifuged",
	Incubated->"Incubated",
	Evaporated->"Experiment",
	FlashFrozen->"Experiment",
	Degassed->"Experiment",
	Desiccated->"Experiment",
	Filtered->"Filtered",
	Restricted->"Restrict",
	Unrestricted->"Restrict",
	SetStorageCondition->"StorageCondition",
	Measured->"Measured",
	StateChanged->"StateChanged",
	Sterilized->"Sterilized",
	Transferred->"Transferred",
	AcquiredData->"AcquiredData",
	Shipped->"Shipped",
	DefinedComposition->"Analysis",
	Lysed->"LyseCells",
	Washed->"WashCells"
|>;


installSampleHistoryCards[]:=KeyValueMap[
	Function[{head,keys},
		(* Install an Icon function that caches the import of the icon: *)
		With[{
					iconFunctionSymbol=ToExpression[ToLowerCase[ToString[head]]<>"Icon"],
					(* We show 4 keys for Transferred instead of 3 because it will EITHER have Destination or Source, so it's effectively 3. *)
					numKeysToShow=If[MatchQ[head,Transferred],4,3]
				},

			iconFunctionSymbol[]:=iconFunctionSymbol[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","sample_history",Lookup[$SampleHistoryCardIcons,head]<>".png"}]];

			(* Unprotect before installing. *)
			Unprotect[head];

			(* Install the MakeBoxes upvalue: *)
			head/:MakeBoxes[summary:head[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
				head,
				summary,
				iconFunctionSymbol[],

				(* Only show the key in the itai blob if it isn't Null: *)

				(* Main itai blob: *)
				(If[MatchQ[Lookup[assoc,#,Null],Null],
					Nothing,
					BoxForm`SummaryItem[{ToString[#]<>": ", Lookup[assoc,#,Null]}]
				]&)/@Take[keys,UpTo[numKeysToShow]],

				(* Collapsed keys: *)
				If[Length[keys]>numKeysToShow,
					(If[MatchQ[Lookup[assoc,#,Null],Null],
						Nothing,
						BoxForm`SummaryItem[{ToString[#]<>": ", Lookup[assoc,#,Null]}]
					]&)/@keys[[numKeysToShow+1;;-1]],
					{}
				],
				StandardForm
			];
		];
	],
	$SampleHistoryCardKeys
];

(* Shortcut to make an association for the heads. *)

(* Install the first time the package is loaded: *)
installSampleHistoryCards[];
OverloadSummaryHead/@Keys[$SampleHistoryCardKeys];

(* Ensure that reloading the package will re-initialize sample history card generation: *)
OnLoad[
	installSampleHistoryCards[];
	OverloadSummaryHead/@Keys[$SampleHistoryCardKeys];
];
