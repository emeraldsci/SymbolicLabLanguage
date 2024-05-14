(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsubsection:: *)
(*Patterns*)


resuspensionIncubateQ[Incubate[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{MixType})
];
resuspensionIncubateQ[_]:=False;
resuspensionIncubateP:=_?resuspensionIncubateQ;

resuspensionMixQ[Mix[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{MixType})
];
resuspensionMixQ[_]:=False;
resuspensionMixP:=_?resuspensionMixQ;

ResuspensionPrimitiveP:=Alternatives[resuspensionMixP,resuspensionIncubateP];


(* ::Subsubsection::Closed:: *)
(*Primitive Images*)


swellIcon[]:=swellIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","SwellIcon.png"}]];
washIcon[]:=washIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WashIcon.png"}]];
protectIcon[]:=protectIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CapIcon.png"}]];
deprotectIcon[]:=deprotectIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DeprotectIcon.png"}]];
deprotonateIcon[]:=deprotonateIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DeprotonateIcon.png"}]];
coupleIcon[]:=coupleIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoupleIcon.png"}]];
cleaveIcon[]:=cleaveIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CleaveIcon.png"}]];


(* ::Subsubsection::Closed:: *)
(*ValidSynthesisCycleQ*)


Unprotect[SwellingP];
SwellingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->GreaterP[0]
];
Protect[SwellingP];

Unprotect[WashingP];
WashingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->GreaterP[0]
];
Protect[WashingP];

Unprotect[CappingP];
CappingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->GreaterP[0]
];
Protect[CappingP];

Unprotect[DeprotectingP];
DeprotectingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->GreaterP[0]
];
Protect[DeprotectingP];

Unprotect[DeprotonatingP];
DeprotonatingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->GreaterP[0]
];
Protect[DeprotonatingP];

Unprotect[CouplingP];
CouplingP:=Association[
	Monomer->ObjectP[{Object[Sample],Model[Sample]}],
	MonomerVolume->GreaterP[0 Microliter],

	Activator->ObjectP[{Object[Sample],Model[Sample]}],
	ActivatorVolume->GreaterP[0 Microliter],

	ActivationTime->GreaterP[0 Second],
	CouplingTime->GreaterP[0 Second],

	Preactivation->PreactivationTypeP,
	SingleShot->BooleanP,

	NumberOfReplicates->GreaterP[0]
];
Protect[CouplingP];

Unprotect[CleavingP];
CleavingP:=Association[
	Sample->ObjectP[{Object[Sample],Model[Sample]}],
	Volume->GreaterP[0 Microliter],
	Time->GreaterP[0 Second],
	NumberOfReplicates->_Integer
];
Protect[CleavingP];

SynthesisCycleStepP:=_?ValidSynthesisStepQ;

installSynthesisPrimitives[]:={
	MakeBoxes[summary:Swelling[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Swelling,summary,swellIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}]
		},
		{},StandardForm
	];,
	MakeBoxes[summary:Washing[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Washing,summary,washIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		},
		{},StandardForm
	];
	MakeBoxes[summary:Capping[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Capping,summary,protectIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		},
		{},StandardForm
	];,
	MakeBoxes[summary:Deprotecting[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Deprotecting,summary,deprotectIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		},
		{},StandardForm
	];,
	MakeBoxes[summary:Deprotonating[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Deprotonating,summary,deprotonateIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		},
		{},StandardForm
	];,
	MakeBoxes[summary:Coupling[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Coupling,summary,coupleIcon[],
		Flatten[{
			BoxForm`SummaryItem[{"Monomer: ",assoc[Monomer]}],
			BoxForm`SummaryItem[{"MonomerVolume: ",assoc[MonomerVolume]}],
			BoxForm`SummaryItem[{"Activator: ",assoc[Activator]}],
			BoxForm`SummaryItem[{"ActivatorVolume: ",assoc[ActivatorVolume]}],
			BoxForm`SummaryItem[{"ActivationTime: ",assoc[ActivationTime]}],
			BoxForm`SummaryItem[{"CouplingTime: ",assoc[CouplingTime]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		}],
		{
			BoxForm`SummaryItem[{"SingleShot: ",assoc[SingleShot]}],
			BoxForm`SummaryItem[{"Preactivation: ",assoc[Preactivation]}]
		},
		StandardForm
	];,
	MakeBoxes[summary:Cleaving[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
		Cleaving,summary,cleaveIcon[],
		{
			BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}],
			BoxForm`SummaryItem[{"Time: ",assoc[Time]}],
			BoxForm`SummaryItem[{"Volume: ",assoc[Volume]}],
			BoxForm`SummaryItem[{"NumberOfReplicates: ",assoc[NumberOfReplicates]}]
		},
		{},StandardForm
	];
};

installSynthesisPrimitives[];
Unprotect[Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving];
OverloadSummaryHead/@{Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving};
Protect[Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving];

(* ensure that reloading the package will re-initialize primitive generation *)
OnLoad[
	installSynthesisPrimitives[];
	Unprotect[Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving];
	OverloadSummaryHead/@{Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving};
	Protect[Washing,Swelling,Capping,Deprotecting,Deprotonating,Coupling,Cleaving];
];


(* ::Subsection:: *)
(*ExperimentPNASynthesis*)


(* ::Subsubsection:: *)
(*Options*)


DefineOptions[ExperimentPNASynthesis,
	Options :> {
		{
			OptionName->Instrument,
			Default->Model[Instrument, PeptideSynthesizer, "Symphony X"],
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Instrument,PeptideSynthesizer],
				Object[Instrument,PeptideSynthesizer]
			}]],
			Description->"The model or object instrument to be used for this synthesis."
		},
		{
			OptionName->SynthesisStrategy,
			Default->Fmoc,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Fmoc]],
			Description->"The type of N-terminal and side chain protecting group scheme used by this synthesis."
		},
		{
			OptionName->SwellSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample],Model[Sample]}]],
			Description->"The model or sample object to be used to swell the resin prior to the start of the synthesis or resin download.",
			ResolutionDescription->"Automatic will resolve to Model[Sample, \"Dichloromethane, Reagent Grade\"] if SwellResin has been set to True.",
			Category->"Swelling"
		},
		{
			OptionName->WashSolution,
			Default->Model[Sample, "Dimethylformamide, Reagent Grade"],
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or sample object used to wash the resin in between each reagent addition.",
			Category->"Washing"
		},
		{
			OptionName->DeprotectionSolution,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or sample object that represents the deprotection solution that will be used to remove protecting groups from the growing strand during the deprotection step of a synthesis or download resin cycle.",
			ResolutionDescription->"Will resolve to Model[Sample, StockSolution, \"Deprotection Solution (20% piperidine in NMP)\"] for Fmoc synthesis and Model[Sample, StockSolution, \"95% TFA 5% m-cresol\"] for Boc synthesis.",
			Category->"Deprotection"
		},
		{
			OptionName->DeprotonationSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or sample object that represents the DeprotonationSolution that will be used to neutralize the resin prior to the coupling step.",
			ResolutionDescription->"Will automatically resolve to Model[Sample, StockSolution, \"5% DIEA in DCM\"] Deprotonation has been set to True.",
			Category->"Deprotonation"
		},
		{
			OptionName->CappingSolution,
			Default->Model[Sample, StockSolution, "Resin Download Capping Solution"],
			AllowNull->False,
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}]
			],
			Description->"The model or sample objects that represents the solution that will be to cap any remaining uncoupled sites from growing further during the synthesis to aid in later purification of the truncations.",
			Category->"Capping"
		},
		{
			OptionName->ActivationSolution,
			Default->Model[Sample, StockSolution, "90 mM HBTU in NMP w/ 130 mM DIPEA"],
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or object representing the mix of preactivation and base solutions used to activate the monomers prior to coupling during a synthesis cycle.",
			Category->"Monomer Activation"
		},
		{
			OptionName->DownloadActivationSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model of object representing the activation used during the coupling step of resin download.",
			ResolutionDescription->"Will automatically resolve to value specified by ActivationSolution if DownloadResin is set to True.",
			Category->"Download Monomer Activation"
		},
		{
			OptionName->StorageBuffer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The sample or model of solution used to store any uncleaved resin samples.",
			ResolutionDescription->"Will automatically resolve to Model[Sample,\"Dimethylformamide, Reagent Grade\"] if Cleavage is set to False.",
			Category->"SampleStorage"
		},
		{
			OptionName->PrimaryResinShrinkSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or sample object that represents the methanol used to wash and dry the resin after last coupling step.",
			ResolutionDescription->"Will automatically resolve to Model[Sample, \"Methanol\"] if PrimaryResinShrink is set to True.",
			Category->"Cleavage"
		},
		{
			OptionName->SecondaryResinShrinkSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The model or sample object that represents the isopropanol used to wash and dry the resin after last coupling step.",
			ResolutionDescription->"Will automatically resolve to Model[Sample, \"Isopropanol\"] if SecondaryResinShrink is set to True.",
			Category->"Cleavage"
		},
		{
			OptionName->CleavageSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The sample or model object that represents the cleavage cocktail that will be used to cleave the PNA strands from the resin.",
			ResolutionDescription->"Will automatically resolve to Model[Sample,StockSolution,\"95%TFA-TIPS-H2O\"] if Cleavage is set to True.",
			Category->"Cleavage"
		},
		{
			OptionName->TriturationSolution,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The sample or model object that represents the solution that will be used to triturate the PNA strands after cleavage from the resin.",
			ResolutionDescription->"Will automatically resolve to Model[Sample,\"Diethyl ether\"] if Cleavage is set to True.",
			Category->"Trituration"
		},
		{
			OptionName->TriturationVolume,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern :> RangeP[Milliliter,35 Milliliter],
				Units->{Microliter,{Microliter,Milliliter}}
			],
			Description->"The volume of ether that will be used to triturate the PNA strands after cleavage from the resin.",
			ResolutionDescription->"Will automatically resolve to 35 milliliter if Cleavage is set to True.",
			Category->"Trituration"
		},
		{
			OptionName->NumberOfTriturationCycles,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
			Description->"The number of times the cleaved PNA strands will be TriturationSolution with ether.",
			ResolutionDescription->"Will automatically resolve to 3 if Cleavage is set to True.",
			Category->"Trituration"
		},
		{
			OptionName->TriturationTime,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern :> RangeP[Minute,12 Hour],
				Units->{Minute,{Minute, Hour}}
			],
			Description->"The length of time for which the cleaved strands will be incubated in ether.",
			ResolutionDescription->"Will automatically resolve to 5 minutes if Cleavage is set to True.",
			Category->"Trituration"
		},
		{
			OptionName->TriturationTemperature,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[-80 Celsius]
			],
			Description->"The temperature at which the cleaved strands will be incubated while in ether.",
			ResolutionDescription->"Will automatically resolve to -80 Celsius if Cleavage is set to True.",
			Category->"Trituration"
		},
		{
			OptionName->ResuspensionBuffer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object,Pattern:>ObjectP[{
				Model[Sample],
				Object[Sample]
			}]],
			Description->"The sample or model object that represents the object that will be used to resuspend the PNA strands after cleavage from the resin.",
			ResolutionDescription->"Will automatically resolve to Model[Sample,\"Milli-Q water\"] if Cleavage is set to True.",
			Category->"SampleStorage"
		},
		{
			OptionName->Monomers,
			Default->Automatic,
			AllowNull->False,
			Widget->Adder[
				{
					"Monomer Sequence"->Widget[Type -> Expression, Pattern :> SequenceP, Size -> Word],
					"Model"->Widget[
						Type->Object,
						Pattern:>ObjectP[{
							Model[Sample],
							Object[Sample]
						}]
					]
				},
				Orientation->Vertical
			],
			Description->"The model or sample object to use for each of the monomers in the synthesis.",
			ResolutionDescription->"Automatic will resolved to default options for all monomers needed for the synthesis.",
			Category->"Monomer Activation"
		},
		{
			OptionName->RecoupMonomers,
			Default->False,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
			Description->"Indicates if any left over monomer solutions will be stored or discarded at the conclusion of a synthesis.",
			Category->"Monomer Activation"
		},

		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->Scale,
				Default->5 Micromole,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[5*Micromole,100*Micromole,2.5*Micromole],
					(* TODO: remove the increments *)
					Units->{Micromole,{Micromole}}
				],
				Description->"The scale at which the oligomers will be synthesized."
			},
			{
				OptionName->TargetLoading,
				Default->90 Micromole/Gram,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[60 Micromole/Gram,200 Micromole/Gram],
					Units->CompoundUnit[
						{1,{Micromole,{Micromole}}},
						{-1,{Gram,{Gram}}}
					]
				],
				Description->"The desired target loading of the resin to be used for the synthesis."
			},
			{
				OptionName->Resin,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{
						Model[Sample],
						Object[Sample]
					}]],
				Description->"The model or sample object of resin to be used as the solid support for the synthesis.",
				ResolutionDescription->"Will resolve automatically to the undownloaded Resin Model[Sample,\"Rink Amide ChemMatrix\"] if DownloadResin is set to True. If DownloadResin is set to False, the user is required to specify an appropriate downloaded resin."
			},
			{
				OptionName->DownloadResin,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if an undownloaded resin will be used and resin download will be performed as the first cycle of the synthesis."
			},

			(*NOTE: Swelling *)
			{
				OptionName->SwellResin,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the resin will be swelled in SwellSolution before the start of a synthesis.",
				Category->"Swelling"
			},
			{
				OptionName->SwellTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[0.1*Hour,12*Hour],
					Units->{Second,{Second,Minute, Hour}}
				],
				Description->"Specifies the amount of time that the resin is swelled for (per cycle).",
				ResolutionDescription->"Will automatically resolve to 20 Minutes is SwellResin is set to True.",
				Category->"Swelling"
			},
			{
				OptionName->SwellVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[2.5 Milliliter,25 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"Specifies the volume of SwellSolution that the samples will be swelled with.",
				ResolutionDescription->"Will automatically resolve to 10 Milliliter if SwellResin is set to True.",
				Category->"Swelling"
			},
			{
				OptionName->NumberOfSwellCycles,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> GreaterP[0, 1]],
				Description->"Specifies the number of the cycles of swelling of the resin before the start of a synthesis.",
				ResolutionDescription->"Will automatically resolve to 3 if SwellResin is set to True.",
				Category->"Swelling"
			},

			(*NOTE: Washing *)
			{
				OptionName->WashVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of WashSolution to be used to wash the resin in between each reagent addition.",
				ResolutionDescription->"Will automatically resolve to 4 Milliliter plus an additonal .2 Milliliter for each 1 Micromole of synthesis Scale, rounded up to the nearest .5 Milliliter.",
				Category->"Washing"
			},

			(* NOTE: Deprotection *)
			{
				OptionName->InitialDeprotection,
				Default->False,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if an initial deprotection step will be done before the synthesis of the strand begins.",
				ResolutionDescription->"The initial deprotection will only occur if DownloadResin is set to True as all other cycles already include a deprotection step prior to their coupling steps.",
				Category->"Deprotection"
			},
			{
				OptionName->FinalDeprotection,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a final deprotection step is will be done as part of the last synthesis cycle prior to the start of cleavage or resin storage.",
				Category->"Deprotection"
			},
			{
				OptionName->DeprotectionVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of DeprotectionSolution added to each reaction vessel during the deprotection step of a synthesis cycle.",
				ResolutionDescription->"Automatic will resolve to 3 Milliliter plus an additonal .2 Milliliter for each Micromole of synthesis Scale, rounded up to the nearest .5 Milliliter",
				Category->"Deprotection"
			},
			{
				OptionName->DeprotectionTime,
				Default->7 Minute,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Category->"Deprotection",
				Description->"The amount of time that each reaction vessel is exposed to the deprotection solution during each deprotection step of a synthesis cycle."
			},
			{
				OptionName->NumberOfDeprotections,
				Default->2,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of times that each reaction vessel will be deprotected per deprotection step of a synthesis cycle.",
				Category->"Deprotection"
			},
			{
				OptionName->NumberOfDeprotectionWashes,
				Default->5,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of WashSolution washes each reaction vessel will undergo after the deprotection step of the synthesis cycle.",
				Category->"Deprotection"
			},

			(* NOTE: Download Deprotection *)
			{
				OptionName->DownloadDeprotectionVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of deprotection solution added to each reaction vessel during a resin download cycle.",
				ResolutionDescription->"Automatic will resolve to 3 Milliliter plus an additonal .5 Milliliter for each 2.5 umol scale for PeptideSynthesizer syntheses.",
				Category->"Download Deprotection"
			},
			{
				OptionName->DownloadDeprotectionTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Category->"Download Deprotection",
				Description->"The amount of time that each reaction vessel is exposed to the deprotection solution during each deprotection step of a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to the same value as DeprotectionTime is DownloadResin is set to True."
			},
			{
				OptionName->NumberOfDownloadDeprotections,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of times that each reaction vessel will be deprotected per deprotection step of a synthesis cycle.",
				Category->"Download Deprotection"
			},
			{
				OptionName->NumberOfDownloadDeprotectionWashes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the deprotection step of the synthesis cycle.",
				Category->"Download Deprotection"
			},

			(* NOTE: Deprotection *)
			{
				OptionName->Deprotonation,
				Default->False,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if an optional deprotonation step is performed between the deprotection and capping steps of synthesis cycle.",
				Category->"Deprotonation"
			},
			{
				OptionName->DeprotonationVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of DeprotonationSolution added to each reaction vessel during an optional deprotonation step of a synthesis cycle.",
				ResolutionDescription->"Will automatically resolve to 3 Milliliter plus an additonal .2 Milliliter for each 1 Micromole of synthesis Scale, rounded up to the nearest .5 Milliliter.",
				Category->"Deprotonation"
			},
			{
				OptionName->DeprotonationTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12*Hour],
					Units->{Second,{Second, Minute, Hour}}
				],
				Category->"Deprotonation",
				Description->"The amount of time that each reaction vessel is exposed to the DeprotonationSolution during each deprotonation step of a synthesis cycle."
			},
			{
				OptionName->NumberOfDeprotonations,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of repetitions of mixing the resin with the DeprotonationSolution during the deprotonation step of a synthesis cycle.",
				Category->"Deprotonation"
			},
			{
				OptionName->NumberOfDeprotonationWashes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the deprotonation step.",
				Category->"Deprotonation"
			},
			(* NOTE: Download Deprotection *)

			{
				OptionName->DownloadDeprotonationVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of DeprotonationSolution added to each reaction vessel during a deprotonation step of a resin download cycle.",
				Category->"Download Deprotection"
			},
			{
				OptionName->DownloadDeprotonationTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Category->"Download Deprotection",
				Description->"The amount of time for which the resin will be mixed with DeprotonationSolution for each deprotonation step of a resin download cycle."
			},
			{
				OptionName->NumberOfDownloadDeprotonations,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of repetitions of mixing the resin with the DeprotonationSolution during a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to 2 if DownloadResin has been set to True.",
				Category->"Download Deprotection"
			},
			{
				OptionName->NumberOfDownloadDeprotonationWashes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of washes each reaction vessel will undergo after a deprotonation step during a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to 5 if DownloadResin has been set to True.",
				Category->"Download Deprotection"
			},

			(* NOTE: Capping *)
			{
				OptionName->InitialCapping,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if an initial capping step will be done before the synthesis of the strand begins.",
				ResolutionDescription->"Will automatically resolve to True of DownloadResin been set to False or False if DownloadResin has been set to True.",
				Category->"Capping"
			},
			{
				OptionName->FinalCapping,
				Default->False,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if a final capping step will be done as part of the last synthesis cycle before the start of cleavage.",
				Category->"Capping"
			},
			{
				OptionName->CappingVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of CappingSolution added to each reaction vessel during the capping step of a main synthesis cycle.",
				ResolutionDescription->"Will automatically resolve to 3 Milliliter plus an additonal .2 Milliliter for each Micromole of synthesis Scale rounded up to nearest .5 Milliliter",
				Category->"Capping"
			},
			{
				OptionName->CappingTime,
				Default->7 Minute,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Description->"The amount of time that each reaction vessel is exposed to the CappingSolution during each capping step of synthesis cycle.",
				Category->"Capping"
			},
			{
				OptionName->NumberOfCappings,
				Default->1,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of times that each reaction vessel is capped during each capping step of a synthesis cycle.",
				Category->"Capping"
			},
			{
				OptionName->NumberOfCappingWashes,
				Default->5,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the capping step of a main synthesis cycle.",
				Category->"Capping"
			},

			(* NOTE: Download Capping*)

			{
				OptionName->DownloadCappingVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of CappingSolution added to each reaction vessel during the capping step of of a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to 3 Milliliter plus an additonal .2 Milliliter per each umol of Scale.",
				Category->"Download Capping"
			},
			{
				OptionName->DownloadCappingTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12*Hour],
					Units->{Second,{Second, Minute, Hour}}
				],
				Category->"Download Capping",
				Description->"The amount of time for which the resin will be shaken with CappingSolution per capping step of a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to 15 minutes if DownloadResin is set to True."
			},
			{
				OptionName->NumberOfDownloadCappings,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of times that each reaction vessel is capped during each capping step of a resin download cycle.",
				Category->"Download Capping"
			},
			{
				OptionName->NumberOfDownloadCappingWashes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the capping step of a resin download cycle.",
				Category->"Download Capping"
			},
			(* NOTE: Monomer Activation *)
			{
				OptionName->MonomerPreactivation,
				Default->ExSitu,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern:>PreactivationTypeP],
				Description->"Determines if the monomer will be preactivated directly on the resin, in a separate reaction vessel or not at all.",
				ResolutionDescription->"The maximum number of oligomers that can be concurrently synthesis depends on this option. Each ex situ preactivation requires an additional position on the instrument that could be otherwise used for synthesis when no preactivation or in situ preactivation is used.",
				Category->"Monomer Activation"
			},
			{
				OptionName->ActivationVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter, {Microliter, Milliliter, Liter}}
				],
				Description->"The volume of ActivationSolution added to each preactivation vessel.",
				ResolutionDescription->"Will resolve automatically to .2 Milliliter per Micromole of synthesis scale Scale, rounded up to the nearest .5 Milliliter.",
				Category->"Monomer Activation"
			},
			{
				OptionName->ActivationTime,
				Default->1 Minute,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Description->"The duration of the preactivation mixing.",
				Category->"Monomer Activation"
			},
			{
				OptionName->MonomerVolume,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter,{Microliter, Milliliter}}
				],
				Description->"The volume of monomer solution added for each reaction vessel to the preactivation vessel for a micromole scale synthesis.",
				ResolutionDescription->"Will resolve automatically to .2 Milliliter per Micromole of synthesis Scale, rounded up to the nearest .5 Milliliter.",
				Category->"Monomer Activation"
			},

			(* NOTE: Download Monomer Activation *)
			{
				OptionName->DownloadActivationVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter, {Microliter, Milliliter, Liter}}
				],
				Description->"The volume of activator solution added to each preactivation vessel when preactivation monomer for coupling to undownloaded resin.",
				Category->"Download Monomer Activation"
			},
			{
				OptionName->DownloadActivationTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,30*Minute],
					Units->{Second,{Second, Minute, Hour}}
				],
				Description->"The amount of time for which the monomer solution will be mixed with the activation solution prior to a resin download cycle.",
				ResolutionDescription->"Will automatically resolve to 10 minutes if DownloadResin is set to True.",
				Category->"Download Monomer Activation"
			},
			{
				OptionName->DownloadMonomer,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{
					Model[Sample],
					Object[Sample]
				}]],
				Description->"The model or sample object to use for each of the monomers in the download.",
				ResolutionDescription->"Will automatically resolve to a default monomer solution for the monomer being used to download the resin.",
				Category->"Download Monomer Activation"
			},
			{
				OptionName->DownloadMonomerVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[1 Milliliter, 25 Milliliter],
					Units->{Milliliter, {Microliter, Milliliter, Liter}}
				],
				Description->"The volume of download monomer solution added to the preactivation vessel during resin download.",
				ResolutionDescription->"Will automatically resolve to 1 Milliliter. The entire volume of a DownloadMonomer is delivered in a single shot and can be any amount within the accepted range.",
				Category->"Download Monomer Activation"
			},
			(* NOTE: Coupling *)
			{
				OptionName->CouplingTime,
				Default->30 Minute,
				AllowNull->False,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12*Hour],
					Units->{Minute,{Second, Minute, Hour}}
				],
				Description->"The amount of time that each reaction vessel is exposed to the coupling solution during each coupling step of a synthesis cycle.",
				Category->"Coupling"
			},
			{
				OptionName->NumberOfCouplingWashes,
				Default->5,
				AllowNull->False,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the coupling step of a synthesis cycle.",
				Category->"Coupling"
			},
			{
				OptionName->DoubleCoupling,
				Default->99,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> GreaterEqualP[1, 1]],
				Description->"Specifies the cycle at which monomers are double coupled. All couplings will be performed twice following the cycle number specified.",
				Category->"Coupling"
			},

			(* NOTE: Downoad Coupling *)
			{
				OptionName->DownloadCouplingTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12*Hour],
					Units->{Minute,{Second, Minute, Hour}}
				],
				Description->"The amount of time for which the resin mixed be mixed with coupling solution during a coupling step of a resin download cycle.",
				ResolutionDescription->"Automatically resolved to 60 Minutes",
				Category->"Download Coupling"
			},
			{
				OptionName->NumberOfDownloadCouplingWashes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of wash solution washes each reaction vessel undergoes after the coupling step of a resin download cycle.",
				ResolutionDescription->"Automatically resolved to 5.",
				Category->"Download Coupling"
			},

			(* NOTE: Cleavage *)
			{
				OptionName->Cleavage,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the oligomers will be cleaved from the resin at the end of the synthesis using CleavageSolution. Uncleaved strands will be stored as a resin slurry in StorageBuffer.",
				Category->"Cleavage"
			},
			{
				OptionName->StorageVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[.5 Milliliter,25000 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The desired volume of solution in which the uncleaved resin will be stored.",
				ResolutionDescription->"Automatically resolved to Null if all of the resins are cleaved or to 15 Milliliter/Gram with a 5 Milliliter minimum.",
				Category->"SampleStorage"
			},
			{
				OptionName->PrimaryResinShrink,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the resin is shrunk with methanol prior to strand cleavage or storage.",
				Category->"Cleavage"
			},
			{
				OptionName->PrimaryResinShrinkVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Milliliter,25 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of methanol that will be used to wash the resin at the end of the last synthesis cycle.",
				Category->"Cleavage"
			},
			{
				OptionName->PrimaryResinShrinkTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12 Hour],
					Units->{Minute,{Minute, Hour}}
				],
				Description->"The duration of the resin methanol wash at the end of the last synthesis cycle.",
				Category->"Cleavage"
			},

			{
				OptionName->SecondaryResinShrink,
				Default->True,
				AllowNull->False,
				Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
				Description->"Indicates if the resin is shrunk with isopropanol prior to strand cleavage or storage.",
				Category->"Cleavage"
			},
			{
				OptionName->SecondaryResinShrinkVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Milliliter,25 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of isopropanol that will be used to wash the resin at the end of the last synthesis cycle.",
				Category->"Cleavage"
			},
			{
				OptionName->SecondaryResinShrinkTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12 Hour],
					Units->{Minute,{Minute, Hour}}
				],
				Description->"The duration of the resin isopropanol wash at the end of the last synthesis cycle.",
				Category->"Cleavage"
			},
			{
				OptionName->CleavageVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[2.5 Milliliter,25 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of cleavage cocktail that will be used to cleave the PNA strands from the resin.",
				ResolutionDescription->"Will resolve to 5 Milliliter if Cleavage is set to True.",
				Category->"Cleavage"
			},
			{
				OptionName->CleavageTime,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[Minute,12 Hour],
					Units->{Minute,{Minute, Hour}}
				],
				Description->"The length of time for which the strands will be cleaved in cleavage solution.",
				ResolutionDescription->"Will resolve to 30 Minutes per cleavage cycle if Cleavage is set to True.",
				Category->"Cleavage"
			},
			{
				OptionName->NumberOfCleavageCycles,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,10,1]],
				Description->"The number of times the PNA strands on the resin will be incubated with the cleavage cocktail.",
				ResolutionDescription->"Will automatically resolve to 3 if Cleavage is set to True.",
				Category->"Cleavage"
			},

			(* NOTE: Trituration *)
			{
				OptionName->ResuspensionVolume,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern :> RangeP[0 Milliliter,3 Milliliter],
					Units->{Microliter,{Microliter,Milliliter}}
				],
				Description->"The volume of resuspension buffer that will be used to resuspend the PNA strands after cleavage from the resin.",
				ResolutionDescription->"Will automatically resolve to 1 milliliter if Cleavage is set to True.",
				Category->"SampleStorage"
			},
			{
				OptionName->NumberOfResuspensionMixes,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> RangeP[1,30,1]],
				Description->"The number of times the pelleted strands will be mixed with the resuspension buffer.",
				ResolutionDescription->"Will automatically resolve to 10 if Cleavage is set to True.",
				Category->"SampleStorage"
			},
			{
				OptionName -> ResuspensionMixTime,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity,Pattern :> RangeP[Minute, 12 Hour],Units -> {Minute, {Minute, Hour}}],
				Description -> "The length of time for which the pelleted strands will be mixed in resuspension buffer (by sonication or vortexing).",
				ResolutionDescription -> "Will resolve to 5 Minutes if ResuspensionMixType is set to Vortex or Sonicate.",
				Category -> "SampleStorage"
			},
			{
				OptionName->ResuspensionMixType,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Enumeration,Pattern :> (Sonicate|Vortex|Pipette)],
				Description->"The mix type that should be used to resuspend the cleaved, pelleted strands in ResuspensionBuffer.",
				ResolutionDescription->"Will automatically resolve to Pipette if Cleavage is set to True.",
				Category->"SampleStorage"
			},
			{
				OptionName->Primitives,
				Default->Automatic,
				AllowNull->False,
				Widget->
						Adder[
							Adder[
								Widget[
									Type->Primitive,
									Pattern:>SynthesisCycleStepP,
									PrimitiveTypes->{Swelling,Washing,Capping,Deprotecting,Deprotonating,Coupling,Cleaving},
									PrimitiveKeyValuePairs->{
										Swelling->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										},
										Washing->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										},
										Deprotonating->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										},
										Deprotecting->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										},
										Coupling->{
											Monomer->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											MonomerVolume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Activator->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											ActivatorVolume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											ActivationTime->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											CouplingTime->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											SingleShot->Widget[Type->Enumeration,Pattern:>BooleanP],
											Preactivation->Widget[Type->Enumeration,Pattern:>PreactivationTypeP]
										},
										Capping->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										},
										Cleaving->{
											Sample->Widget[Type->Object,Pattern:>ObjectP[{Object[Sample], Model[Sample]}]],
											Volume->Widget[Type->Quantity,Pattern:>(GreaterEqualP[0*Microliter]),Units->Alternatives[{Milliliter, {Microliter, Milliliter, Liter}}]],
											Time->Widget[Type->Quantity, Pattern:>(GreaterEqualP[0*Second]),Units->Alternatives[{Minute, {Second, Minute, Hour}}]],
											NumberOfReplicates->Widget[Type->Number, Pattern:>GreaterEqualP[0, 1]]
										}
									}
								]
							]
						],
				Description->"A complete list of all chemical steps, including resin swelling, resin downloading, coupling and cleavage, used to synthesize a strand.",
				ResolutionDescription->"These are determined from the Swelling, Washing, Deprotonating, Deprotecting, Coupling, Capping, and Cleaving options.",
				Category->"Hidden"
			},
			{
				OptionName->ResuspensionMixPrimitives,
				Default->Automatic,
				AllowNull->True,
				Widget->Adder[Widget[
					Type->Primitive,
					Pattern:>ResuspensionPrimitiveP,(*ResuspensionIncubateP SampleManipulationP *)
					PrimitiveTypes->{Incubate,Mix},
					PrimitiveKeyValuePairs -> {
						Incubate -> {
						(* TODO remove the Sample Key here *)
							Optional[Time] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								]
							],
							Optional[Temperature] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
								]
							],
							Optional[MixRate] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MixType] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Enumeration,Pattern :> MixTypeP],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Enumeration,Pattern :> MixTypeP],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[Instrument] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[NumberOfMixes] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MixVolume] -> Alternatives[
								Adder[
									Alternatives[

										Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MixUntilDissolved] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Enumeration,Pattern :> BooleanP],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Enumeration,Pattern :> BooleanP],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MaxNumberOfMixes] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MaxTime] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[AnnealingTime] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							]
						},
						Mix -> {
							Optional[NumberOfMixes] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MixVolume] -> Alternatives[
								Adder[
									Alternatives[

										Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern:>GreaterEqualP[0*Microliter],Units->{Microliter,{Microliter,Milliliter,Liter}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
						(* Keys that are shared between Micro and Macro *)
							Time -> Alternatives[
								Adder[Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]],
								Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}]
							],
							Optional[Temperature] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient]]
								]
							],
							Optional[MixRate] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
						(* Keys that are specific to Micro *)
							Optional[Preheat] -> Alternatives[
								Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
								Widget[Type -> Enumeration,Pattern :> BooleanP]
							],
							Optional[ResidualIncubation] -> Alternatives[
								Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
								Widget[Type -> Enumeration,Pattern :> BooleanP]
							],
							Optional[ResidualTemperature] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[4 Celsius, 80 Celsius],Units -> Celsius],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Ambient,Null]]
								]
							],
							Optional[ResidualMix] -> Alternatives[
								Adder[Widget[Type -> Enumeration,Pattern :> BooleanP]],
								Widget[Type -> Enumeration,Pattern :> BooleanP]
							],
							Optional[ResidualMixRate] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Quantity,Pattern :> RangeP[30 RPM,2500 RPM],Units -> RPM],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
						(* Keys that are specific to macro *)
							Optional[MixType] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Enumeration,Pattern :> MixTypeP],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Enumeration,Pattern :> MixTypeP],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[Instrument] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Object,Pattern :> ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MixUntilDissolved] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Enumeration,Pattern :> BooleanP],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Enumeration,Pattern :> BooleanP],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MaxNumberOfMixes] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type -> Number,Pattern:>RangeP[1, 50, 1]],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[MaxTime] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern :> RangeP[0 Minute,$MaxExperimentTime],Units -> {Minute,{Minute,Second}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							],
							Optional[AnnealingTime] -> Alternatives[
								Adder[
									Alternatives[
										Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
										Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
									]
								],
								Alternatives[
									Widget[Type->Quantity,Pattern :> GreaterEqualP[0 Minute],Units -> {Minute,{Minute,Second}}],
									Widget[Type -> Enumeration,Pattern :> Alternatives[Null]]
								]
							]
						}
					}
				]],
				Description->"A complete list of all incubate primitives used to resuspend and mix the strands after trituration. Cannot be provided if the options NumberOfResuspensionMixes,ResuspensionMixTime, and/or ResuspensionMixType are informed.",
				ResolutionDescription->"These are determined automatically from the Resuspension options if provided.",
				Category->"SampleStorage"
			}
		],
		ProtocolOptions,
		SamplesOutStorageOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption
	}
];


ExperimentPNASynthesis[myInputs:ListableP[Alternatives[ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],SequenceP,StrandP,StructureP]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,listedInputs,nonModelInputs,moleculeInputs,newModels,structuredNonModelInputs,outputSpecification,output,gatherTests,safeOps,
		newIdentityModelPackets,newIdentityModels,newModelCache,
		newModelsForStrands,newModelsForMoleculesMap,newModelsForMolecules,newModelForStrandsCache,
		newModelForMoleculeCache,downloadCall,safeOpsTests,validLengths,validLengthTests,
		hasNonModelInputs,templatedOptions,templateTests,inheritedOptions,upload,
		confirm,fastTrack,parentProt,cache,resins,cleanResins,cleanInstruments,newCache,download,expandedSafeOps,cacheBall,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,
		resourcePackets,resourcePacketTests,allTests,validQ,previewRule,optionsRule,testsRule,resultRule,
		protocolPacket,accessoryPackets,inputToModelLookup,inputWithGeneratedModels,listedInputsNamed, listedOptionsNamed,safeOpsNamed},

	(* Make sure we're working with a list of options *)
	{listedInputsNamed, listedOptionsNamed}=removeLinks[ToList[myInputs], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* before we go further, will need to make models for any non-model input creating a new oligomer sample *)
	(* pull out all the non model inputs*)
	nonModelInputs=Cases[listedInputsNamed,Except[ObjectP[]]];
	moleculeInputs=Cases[listedInputsNamed,ObjectP[Model[Molecule,Oligomer]]];
	hasNonModelInputs=Not[MatchQ[nonModelInputs,{}]];

	(* if there are any strands provided, convert them to structures (and delete duplicates so we only make one model each) *)
	structuredNonModelInputs=If[!MatchQ[nonModelInputs,{}],DeleteDuplicates[Map[ToStructure[#,Polymer->PNA]&,nonModelInputs]]];

	(* we need to create new Identity Models for the oligomers that were provided as Strands *)
	(* For the names we need to do a StringJoin here for cases that have defined their strand as StrandJoin[strand1, strand2] such that the name reflects the joint sequence and not just the first
		otherwise we run the risk that we don't upload a new one when it's actually needed *)
	newIdentityModelPackets=If[!MatchQ[nonModelInputs,{}],

		MapThread[Function[{newStructure,newPolymerType,newName},

			(* TODO this should be a Search? It produces packets even when the name is in use sometimes, although I could not reproduce this*)
			If[!DatabaseMemberQ[Model[Molecule,Oligomer,newName]],
				(* if the name is not already in use, upload a new model *)
				UploadOligomer[
					newStructure,
					newPolymerType,
					newName,
					Upload->False
				],

				Model[Molecule,Oligomer,newName]
			]
		],
			{
				structuredNonModelInputs,
				Table[PNA,Length[structuredNonModelInputs]],
				StringJoin /@ ToSequence[structuredNonModelInputs][[All, 1]]
			}],
		Null];

	(* we upload the identity model right now if we made new ones *)
	If[!MatchQ[nonModelInputs,{}],
		Upload[Flatten[Cases[newIdentityModelPackets,{_Association}]]]
	];

	(* figure out the object IDs of the Identity Models that we're going to create new samples for *)
	newIdentityModels=If[!MatchQ[nonModelInputs,{}],Flatten[If[MatchQ[#,{PacketP[]}],Lookup[#,Object],#]& /@ newIdentityModelPackets,1],Null];

	(* Now, create new oligomer model packets for the strands *)
	newModelsForStrands=If[!MatchQ[nonModelInputs,{}],
		MapThread[Function[{newIdentityModel,newName},
			(* TODO this should be a Search? *)
			If[!DatabaseMemberQ[Model[Sample,newName]],
				First@UploadSampleModel[
					newName,
					Composition->{{100 MassPercent,newIdentityModel}},
					DefaultStorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"],
					Expires->False,
					ShelfLife->Null,
					UnsealedShelfLife->Null,
					MSDSRequired->False,
					Flammable->False,
					IncompatibleMaterials->{None},
					(* set the state of new oligomer mixture models to liquid for now because it's breaking computed volume and volume checks *)
					State->Liquid,
					BiosafetyLevel->"BSL-1",
					Upload->False
				],
				Model[Sample,newName]
			]
		],
		{
			newIdentityModels,
			StringJoin /@ ToSequence[structuredNonModelInputs][[All, 1]]
		}],
		Null
	];

	(* also create new samples for the input that was provided as Model[Molecule,Oligomer] *)
	(* If we have duplicate inputs, make sure we only prepare one Model[Sample] *)
	newModelsForMoleculesMap=If[!MatchQ[moleculeInputs,{}],
		MapThread[Function[{newIdentityModel,newName},
			(* TODO this should be a Search? *)
			If[!DatabaseMemberQ[Model[Sample,"Sample model for Model[Molecule, Oligomer, "<>newName<>"]"]],
				(
					newIdentityModel->First@UploadSampleModel[
						"Sample model for Model[Molecule, Oligomer, "<>newName<>"]",
						Composition->{{100 MassPercent,newIdentityModel}},
						DefaultStorageCondition -> Model[StorageCondition,"id:N80DNj1r04jW"],
						Expires->False,
						ShelfLife->Null,
						UnsealedShelfLife->Null,
						MSDSRequired->False,
						Flammable->False,
						IncompatibleMaterials->{None},
					(* set the state of new oligomer mixture models to liquid for now because it's breaking computed volume and volume checks *)
						State->Liquid,
						BiosafetyLevel->"BSL-1",
						Upload->False
					]
				),
					(* if the model already exists we take that *)
				(newIdentityModel->Model[Sample,"Sample model for Model[Molecule, Oligomer, "<>newName<>"]"])
				]
			],
			{
				DeleteDuplicates[moleculeInputs],
				ToString/@(DeleteDuplicates[moleculeInputs][[All, -1]])
			}],
		Null
	];

	newModelsForMolecules=If[NullQ[newModelsForMoleculesMap],
		Null,
		Values[newModelsForMoleculesMap]
	];

	(* prep a list of replacement rule to update the user input for the resolver *)
	inputToModelLookup=Join[
		If[!MatchQ[nonModelInputs,{}],
			MapThread[
				Rule[#1,#2]&,
				{DeleteDuplicates[nonModelInputs],Map[If[MatchQ[#,PacketP[]],Lookup[#,Object],#]&,newModelsForStrands]}
			],
			{}
		],
		If[!MatchQ[moleculeInputs,{}],
			MapThread[
				Rule[#1,#2]&,
				{DeleteDuplicates[moleculeInputs],Map[If[MatchQ[Lookup[newModelsForMoleculesMap,#],PacketP[]],Lookup[Lookup[newModelsForMoleculesMap,#],Object],Lookup[newModelsForMoleculesMap,#]]&,DeleteDuplicates[moleculeInputs]]}
			],
			{}
		]
	];

	(* update the input, will only use this internally *)
	inputWithGeneratedModels=listedInputsNamed/.inputToModelLookup;

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentPNASynthesis,listedOptionsNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentPNASynthesis,listedOptionsNamed,AutoCorrect->False],{}}
	];

	(* convert our inputs and samples to the id version *)
	{listedInputs,safeOps,listedOptions} = sanitizeInputs[listedInputsNamed,safeOpsNamed,listedOptionsNamed];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentPNASynthesis,{inputWithGeneratedModels},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentPNASynthesis,{inputWithGeneratedModels},listedOptions],Null}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[ExperimentPNASynthesis,{inputWithGeneratedModels},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentPNASynthesis,{inputWithGeneratedModels},listedOptions],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests],
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* get assorted hidden options *)
	{upload, confirm, fastTrack, parentProt, cache} = Lookup[inheritedOptions, {Upload, Confirm, FastTrack, ParentProtocol, Cache}];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentPNASynthesis,{inputWithGeneratedModels},inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* the upload packets for the new oligomer models have the Replace[x] so we need to strip that before passing it in as cache *)
	newModelForStrandsCache= If[!MatchQ[nonModelInputs,{}],Association /@ (Normal[newModelsForStrands] /. {Replace[x_] :> x}),{}];
	newModelForMoleculeCache= If[!MatchQ[moleculeInputs,{}],Association /@ (Normal[newModelsForMolecules] /. {Replace[x_] :> x}),{}];

	(* gather the new packets, if there are any. We have already uploaded the molecules, so this is only the Model[Sample] packets. *)
	newModels=Cases[Flatten[Join[ToList[newModelsForStrands],ToList[newModelsForMolecules]]],PacketP[]];

	(* we're gonna download from our models plus some stuff we want to pass to the cache for the resolver and the resource packet helper function *)
	(* since for some inputs the resin and the instrument may be still Automatic we'll filter for those that have an object specified *)
	resins = Lookup[expandedSafeOps, Resin];
	cleanResins=Cases[resins,ObjectP[{Object[Sample],Model[Sample]}]];
	cleanInstruments=If[MatchQ[Lookup[expandedSafeOps,Instrument],ObjectP[{Object[Instrument,PeptideSynthesizer],Model[Instrument,PeptideSynthesizer]}]],{Lookup[expandedSafeOps,Instrument]},{}];

	(* compile the cache that we want to pass to the download call including the new model packet and new identity model packets *)
	newCache=FlattenCachePackets[{cache,newModelForMoleculeCache,newModelForStrandsCache,newIdentityModelPackets}];


	(* download to make our cacheball *)
	downloadCall=Quiet[Download[
		{
			inputWithGeneratedModels,
			inputWithGeneratedModels,
			{Model[Container,Vessel,"id:pZx9jonGJJB9"]},
			cleanInstruments,
			cleanResins,
			cleanResins,
			cleanResins
		},
		{
			{Packet[Field[Composition[[All, 2]]][{PolymerType,Molecule}]]},
			{Packet[Field[Composition]]},
			{Packet[MaxVolume]},
			{Packet[DeadVolume]},
			{Packet[Field[Composition[[All, 2]]][{Object, Type, Strand, State}]]},
			{Packet[Field[Composition[[All, 2]]][Strand][Molecule]]},
			{Packet[Composition,State]}
		},
		Cache->newCache,
		Date->Now
	],
		{Download::NotLinkField,Download::FieldDoesntExist}
	];

	(* we may be downloading Strand from Model[Resin] (rather than from Model[Resin,SolidPhaseSupport] which results in $Failed entries *)
	(* remove those before passing as cache *)
	cacheBall=FlattenCachePackets[downloadCall];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentPNASynthesisOptions[inputWithGeneratedModels,expandedSafeOps,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->Boolean,Verbose->False]["Tests"],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentPNASynthesisOptions[inputWithGeneratedModels,expandedSafeOps,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentPNASynthesis,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentPNASynthesis,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		pnaSynthesisResourcePackets[inputWithGeneratedModels,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall,Output->{Result,Tests}],
		{pnaSynthesisResourcePackets[inputWithGeneratedModels,templatedOptions,resolvedOptions,collapsedResolvedOptions,Cache->cacheBall],{}}
	];

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* if the Output option includes Tests _and_ Result, messages will be suppressed. Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed *)
	(* Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		MatchQ[resourcePackets, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[ExperimentPNASynthesis,collapsedResolvedOptions],
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* Upload the resulting protocol/resource objects *)
	resultRule = Result -> If[
		And[MemberQ[output, Result], validQ],
		UploadProtocol[
			resourcePackets,If[MatchQ[newModels,{PacketP[]..}],newModels,Null], (* upload also the newly created Model[Sample] packets for the strand or Model[Molecule] inputs *)
			Confirm -> confirm,
			Upload -> upload,
			ParentProtocol -> parentProt,
			Priority->Lookup[safeOps,Priority],
			StartDate->Lookup[safeOps,StartDate],
			HoldOrder->Lookup[safeOps,HoldOrder],
			QueuePosition->Lookup[safeOps,QueuePosition],
			ConstellationMessage->Object[Protocol,PNASynthesis]
		],
		$Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


DefineOptions[
	resolveExperimentPNASynthesisOptions,
	Options:>{HelperOutputOption,CacheOption}
];


Error::NumberOfInputs="The instrument selected has `1` reaction positions but `2` positions are required for this synthesis. Please split up your synthesis into multiple 6protocols or use the MonomerPreactivation option to perform some of the monomer preactivations InSitu.";
Error::PolymerType="Only oligomer models with a PNA PolymerType can be synthesized using ExperimentPNASynthesis. Please remove `1` from experimental input.";

Error::UnneededSwellOptions="The option(s) `1` is/are only needed for strands for which SwellResin was set to True. Please double check the swell resin aspect of your experiment.";
Error::UnneededShrinkOptions="The option(s) `1` is/are only needed for strands for which `2` was set to True. Please double check the resin shrink aspect of your experiment.";
Error::UnneededDownloadResinOptions="The option(s) `1` is/are only needed for strands for which DownloadResin was set to True. Please double check the download resin aspect of your experiment.";
Error::UnneededCleavageOptions="The option(s) `1` is/are only needed for strands for which Cleavage was set to True. Please double check the cleaving aspect of your experiment.";
Error::UnneededStorageOptions="The option(s) `1` is/are only needed for strands for which Cleavage was set to False. Please double check the cleaving aspect of your experiment.";
Error::UnneededDeprotonationOptions="The option(s) `1` is/are only needed for strands for which Deprotonation was set to True. Please double check the deprotonation aspect of your experiment.";

Error::WrongResin = "For the following input oligomer model(s), `1`, the Resin is specified to a downloaded resin (a sample containing a Model[Resin,SolidPhaseSupport]) while DownloadResin is set or defaults to True. Please set DownloadResin to False or provide an un-downloaded Resin (a sample containing a Model[Resin]).";
Error::ResinNeeded = "For the following input oligomer model(s), `1`, DownloadResin is set to False, but no downloaded Resin is specified. Please set DownloadResin to True, or provide an appropriate downloaded Resin (a sample containing a Model[Resin,SolidPhaseSupport]) if you would like to use an already downloaded resin for your synthesis.";
Error::DownloadedResinNeeded = "For the following input oligomer model(s), `1`, DownloadResin is set to False, but the provided resin is un-downloaded. Please set DownloadResin to True, or provide an appropriate downloaded Resin (a sample containing a Model[Resin,SolidPhaseSupport]) if you would like to use an already downloaded resin for your synthesis.";
Error::MismatchedResinAndStrand="For the following input oligomer model(s), `1` , the preloaded sequence(s) `2` on the specified downloaded resin does not match the 3' base(s) in the strand(s) `3`. Please provide a downloaded resin with matching 3' base(s).";

Error::UnknownMonomer="For the following input oligomer model(s), `1`, the sequence to be synthesized contains the following monomers, `2`, for which default monomers not available and have not been specified explicitly. Please provide monomer(s) to be used in this synthesis by specifying the Monomers option value.";
Error::UnknownDownloadMonomer="For the following input oligomer model(s), `1`, the sequence to be synthesized contains the following download monomers, `2`, for which default monomers are not available and have not been specified explicitly. Please provide monomer(s) to be used in this synthesis by specifying the DownloadMonomers option value.";
Error::TooManyMonomers ="This synthesis requires more unique monomer types then there are available positions for on the instrument. Please use fewer unique monomers in your sequence or synthesize fewer strands.";


Error::RequiredOption="Because `1` option has been resolved to `2`, `3` options cannot be set to Null. Please make sure that `3` are not being set to Null for any oligomer for which `1` has been set to `2`.";
Error::InsufficientSolventVolume="This synthesis requires `1` of `2`, which is currently more then can be provided by the instrument. This is likely due to a large number of inputs or particularly long sequences. Please adjust your synthesis such that only `3` of wash solvent is needed.";

Error::UnneededResuspensionOptions="For the mixing of the cleaved, pelleted strands in resuspension buffer, please provide either a list of mix primitives (via ResuspensionMixPrimitives), or specify the resuspension mix options (ResuspensionMixType, ResuspensionMixTime, NumberOfResuspensionMixes), but not both. Please either set the following options, `1`, to Null or Automatic, or do not provide ResuspensionMixPrimitives.";
Error::IncompatibleResuspensionMixPrimitives="For the following input oligomer models, `1`, the primitives (`2`) provided to specify the resuspension of the pelleted strands are invalid. Please check the error messages and modify the primitives accordingly.";

resolveExperimentPNASynthesisOptions[myInputs:{ObjectP[Model[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentPNASynthesisOptions]]:=Module[
	{outputSpecification,output,gatherTests,messages,cache,mySamplePrepOptions,myPNASynthesisOptions,mySimulatedSamples,
		myResolvedSamplePrepOptions,simulatedCache,pnaSynthesisOptionsAssociation,invalidInputs,invalidOptions,oligomerModelPackets,pnaOptionsAssociation,
		cleanResins,allDownloadPackets,resinCompositionPackets,resinStrandPackets,
		willSwell,willDeprotonate,willCleave,willDownloadResin,willStoreResin,willMethanolShrink,willIsopropanolShrink,resolvedPostProcessingOptions,
		maxNumberOfStrands,tooManyInputsPackets,tooManyInputs,tooManyInputsTest,polymerTypePackets,polymerTypes,polymerTypeInputs,polymerTypeTest,
		topDeliveryVolumePrecisionOptions,topDeliveryVolumePrecisionTest,pnaOptionsWithRoundedTopDeliveryVolumes,
		bottomDeliveryVolumePrecisionOptions,bottomDeliveryVolumePrecisionTest,pnaOptionsWithRoundedBottomDeliveryVolumes,
		allRoundedPNAOptionsAssociation,timePrecisionOptions,timePrecisionTest,upload,confirm,parentProtocol,email,name,fastTrack,operator,template,
		deprotonationSingleOptions,deprotonationMultipleOptions,unneededDeprotonationOptions,unneededDeprotonationOptionsTest,neededDeprotonationOptions,
		neededDeprotonationOptionsTest,downloadResinSingeOptions,downloadResinMultipleOptions,downloadResinSingleOptions,
		unneededDownloadResinOptions,unneededDownloadResinOptionsTest,neededDownloadResinOptions,neededDownloadResinOptionsTest,
		providedResins,providedDownloadResin,wrongResinSamples,needResinSamples,needToValidateResinTuples,needDResinSamples,wrongResinOptions,
		wrongResinInvalidTests,needResinOptions,needResinInvalidTests,wrongDResinOptions,wrongDResinInvalidTests,
		validateSequenceSamplePackets,validateSequenceResinPackets,validateSequenceResinStrandPackets,mismatchDResinResults,mismatchedResinSamples,
		mismatchedResinStrand,mismatchedResinMonomers,mismatchDResinOptions,mismatchDResinTests,cleavageSingleOptions,cleavageMultipleOptions,
		unneededCleavageOptions,unneededCleavageOptionsTest,neededCleavageOptions,neededCleavageOptionsTest,storageSingleOptions,storageMultipleOptions,
		unneededStorageOptions,unneededStorageOptionsTest,neededStorageOptions,neededStorageOptionsTest,swellSingleOptions,swellMultipleOptions,
		unneededSwellOptions,unneededSwellOptionsTest,unneededMethanolShrinkOptions,unneededIsopropanolShrinkOptions,unneededMethanolShrinkOptionsTest,
		unneededIsopropanolShrinkOptionsTest,neededMethanolShrinkOptions,neededIsopropanolShrinkOptions,neededMethanolShrinkOptionsTest,neededIsopropanolShrinkOptionsTest,
		methanolMultipleOpions,isopropanolMultipleOptions,methanolSingleOptions,isopropanolSingleOptions,
		finalCapButNoFinalDeprotectionPackets,finalCapButNoFinalDeprotectionInputs,finalCapButNoFinalDeprotectionTest,instrument,synthesisStrategy,recoupMonomers,
		washSolution,swellSolution,deprotectionSolution,cappingSolution,activationSolution,deprotonationSolution,downloadActivationSolution,
		cleavageSolution,storageBuffer,triturationSolution,resuspensionBuffer,triturationTime,numberOfTriturationCycles,triturationTemperature,triturationVolume,
		methanol,isopropanol,mapThreadFriendlyOptions,scales,targetLoadings,cleavages,downloadResins,resins,initialDeprotections,finalDeprotections,deprotonations,initialCappings,finalCappings,
		swellResins,swellTimes,swellVolumes,numberOfSwellCycless,washVolumes,deprotectionVolumes,deprotectionTimes,numberOfDeprotectionss,numberOfDeprotectionWashess,
		downloadDeprotectionVolumes,downloadDeprotectionTimes,numberOfDownloadDeprotectionss,numberOfDownloadDeprotectionWashess,
		deprotonationVolumes,deprotonationTimes,numberOfDeprotonationss,numberOfDeprotonationWashess,downloadDeprotonationVolumes,
		downloadDeprotonationTimes,numberOfDownloadDeprotonationss,numberOfDownloadDeprotonationWashess,cappingVolumes,cappingTimes,
		numberOfCappingss,numberOfCappingWashess,downloadCappingVolumes,downloadCappingTimes,numberOfDownloadCappingss,numberOfDownloadCappingWashess,
		uniqueBulkMonomers,defaultPNABulkMonomers,providedMonomersOption,monomers,monomerVolumes,activationVolumes,activationTimes,
		downloadMonomers,downloadMonomerVolumes,downloadActivationVolumes,downloadActivationTimes,couplingTimes,numberOfCouplingWashess,doubleCouplings,
		downloadCouplingTimes,numberOfDownloadCouplingWashess,cleavageVolumes,cleavageTimes,numberOfCleavageCycless,
		methanolWashs,methanolWashVolumes,methanolWashTimes,isopropanolWashs,isopropanolWashVolumes,isopropanolWashTimes,
		resuspensionVolumes,storageVolumes,numberOfResuspensionMixess,samplesOutStorageConditions,
		unknowMonomerErrors,unknownDownloadMonomerErrors,unknowDownloadMonomerOptions,unknownMonomerOptions,unknownMonomerErrorsTest,
		resolvedEmail,resolvedOperator,resolvedMonomers,unknownMonomerErrors,unresolvedMonomers,unknownDownloadMonomerErrorsTest,primitives,
		primitivess,preactivation,neededPositions,monomerPreactivations,resuspensionMixTimes,resuspensionMixTypes,
		unneededResuspensionOptions,resuspensionMultipleOptions,providedCleavageOptions,unneededResuspensionOptionsBools,
		unneededResuspensionTest,incompatibleMixPrimitivesOptions,incompatibleMixPrimitivesTest,
		resolvedResuspensionMixPrimitives,reuspensionMixManipulationList,smOptions,smTests
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions],Cache];

	(* Seperate out our <Type> options from our Sample Prep options (but PNASynthesis has no sample prep so only case about the type options). *)
	{mySamplePrepOptions,myPNASynthesisOptions}=splitPrepOptions[myOptions];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. (only PNA options) *)
	pnaSynthesisOptionsAssociation = Association[myPNASynthesisOptions];

	(* Convert the list of rules into an association (all Options) *)
	pnaOptionsAssociation=Association[myOptions];

	(* pull out the indexmatched DownloadResin and Resin option from the provided options *)
	providedResins=Lookup[pnaSynthesisOptionsAssociation,Resin];
	providedDownloadResin=Lookup[pnaSynthesisOptionsAssociation,DownloadResin]; (* this is a boolean *)

	cleanResins=providedResins /. {Automatic->Null};

	(* Extract the packets that we need from our downloaded cache. *)
	(* Since we're traversing through Composition which is a list, we have to take the First to end up with just one packet per sample *)
	allDownloadPackets=Quiet[
		Download[

			{
				myInputs,
				cleanResins,
				cleanResins
			},
			{
				{Packet[Field[Composition[[All, 2]]][{Molecule,PolymerType}]]},
				{Packet[Field[Composition[[All, 2]]][{Strand}]]},
				{Packet[Field[Composition[[All, 2]]][Strand[Molecule]]]}
			},
			Cache->cache,
			Date->Now
		],
		{Download::NotLinkField,Download::FieldDoesntExist}
	];

	(* Since we're traversing through Composition which is a list, we have to take the First to end up with just one packet per sample *)
	(*look for the Model[Molecule, Oligomer], and use that. Fall back on FirstOrDefault in case there isnt one*)
	(* Note that we stay indexmatched here. For resins that were Automatic we have downloaded from Null and will keep a Null entry here instead of a packet -- FirstOrDefault! *)
	oligomerModelPackets=FirstCase[#, PacketP[Model[Molecule, Oligomer]], FirstOrDefault[#]]&/@Flatten[allDownloadPackets[[1]],1];
	resinCompositionPackets=FirstOrDefault/@Flatten[allDownloadPackets[[2]],1];
	resinStrandPackets=FirstOrDefault/@Flatten[allDownloadPackets[[3]],1];

	(* get some common protocol option variables *)
	{upload,confirm,parentProtocol,email,name,fastTrack,operator,template}=Lookup[
		pnaOptionsAssociation,
		{Upload,Confirm,ParentProtocol,Email,Name,FastTrack,Operator,Template}
	];

	(*setting up a couple of variable (if there is at least on True in any of these, will need to relevant options resolved)*)
	primitives=Lookup[pnaOptionsAssociation,Primitives];
	preactivation=Lookup[pnaOptionsAssociation,MonomerPreactivation];

	willSwell=AnyTrue[Lookup[pnaOptionsAssociation,SwellResin],TrueQ];
	willDeprotonate=AnyTrue[Lookup[pnaOptionsAssociation,Deprotonation],TrueQ];
	willCleave=AnyTrue[Lookup[pnaOptionsAssociation,Cleavage],TrueQ];
	willDownloadResin=AnyTrue[Lookup[pnaOptionsAssociation,DownloadResin],TrueQ];
	willStoreResin=AnyTrue[Lookup[pnaOptionsAssociation,Cleavage],MatchQ[#, False]&];
	willMethanolShrink=AnyTrue[Lookup[pnaOptionsAssociation,PrimaryResinShrink],TrueQ];
	willIsopropanolShrink=AnyTrue[Lookup[pnaOptionsAssociation,SecondaryResinShrink],TrueQ];

	(*-- INPUT VALIDATION CHECKS --*)
	(* NOTE: too many input models *)

	(* If the user asked for more strands to be made then the instrument can handle in one run, then throw an error and keep track of of any "extra" strands*)
	maxNumberOfStrands=24;

	(* instrument can do 24 strands, each ExSitu takes up 2 positions, each InSitu takes up 1 position*)
	neededPositions=Total[{Count[preactivation,InSitu],Count[preactivation,None],Count[preactivation,ExSitu],Count[preactivation,ExSitu]}];

	(* get the invalid input objects, if there are any *)
	tooManyInputsPackets=If[neededPositions>maxNumberOfStrands,oligomerModelPackets,{}];
	tooManyInputs=If[Length[tooManyInputsPackets]>0,Lookup[tooManyInputsPackets,Object],{}];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[tooManyInputs]>0 && !gatherTests,Message[Error::NumberOfInputs, maxNumberOfStrands, neededPositions]];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	tooManyInputsTest=If[gatherTests,
		{
			If[Length[tooManyInputs]==0,
				Test["The number ("<>ToString[Length[oligomerModelPackets]]<>") of oligomer(s) being synthesized in one protocol is within the capability of the instrument.",True,True],
				Test["The number ("<>ToString[Length[oligomerModelPackets]]<>") of oligomers(s) being synthesized in one protocol has be to less than the max ("<> ToString[maxNumberOfStrands] <>") the instrument is capable of.",True,False]
			]
		},
		{}
	];

	(* NOTE: wrong polymer type *)
	(* Get the samples from mySamples that have the wrong PolymerType, PNASynthesis can only make PNA *)
	polymerTypes=Lookup[oligomerModelPackets,PolymerType];
	polymerTypePackets=Cases[oligomerModelPackets,
		KeyValuePattern[PolymerType->Except[Alternatives[PNA, GammaLeftPNA, GammaRightPNA]]]
	];

	(* get the invalid inputs *)
	polymerTypeInputs=If[Length[polymerTypePackets]>0,
		Lookup[polymerTypePackets,Object],
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[polymerTypePackets]>0 && !gatherTests,
		Message[Error::PolymerType,ObjectToString[polymerTypeInputs,Cache->cache]]
	];

	polymerTypeTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[polymerTypeInputs]==0,
				Nothing,
				Test["The input oligomer model(s) "<>ToString[myInputs]<>" has/have a PNA polymer type:",True,False]
			];
			passingTest=If[Length[polymerTypeInputs]==Length[myInputs],
				Nothing,
				Test["The input oligomer model(s) "<>ToString[Complement[myInputs,polymerTypeInputs]]<>" has/have a PNA polymer type:",True,True]
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*-- OPTION PRECISION CHECKS --*)
	(* These chemicals are delivered from the top of the RV and can only be deliver in certain amounts 1.mL, 1.5mL, 2.mL...*)
	topDeliveryVolumePrecisionOptions={WashVolume,DeprotectionVolume,DeprotonationVolume,DownloadDeprotonationVolume,ActivationVolume,DownloadActivationVolume,CappingVolume,DownloadCappingVolume,MonomerVolume};
	{pnaOptionsWithRoundedTopDeliveryVolumes, topDeliveryVolumePrecisionTest}=If[gatherTests,
		RoundOptionPrecision[
			pnaOptionsAssociation,
			topDeliveryVolumePrecisionOptions,
			Table[.5 Milliliter,Length[topDeliveryVolumePrecisionOptions]],
			Output->{Result,Tests},Round->Up
		],
		{
			RoundOptionPrecision[
				pnaOptionsAssociation,
				topDeliveryVolumePrecisionOptions,
				Table[.5 Milliliter,Length[topDeliveryVolumePrecisionOptions]],Round->Up
			],Null
		}
	];

	(* These chemicals are deliveredy from the bottom of the RV and can only be deliver in certain amounts 2.5mL, 5.mL, 7.5mL...*)
	bottomDeliveryVolumePrecisionOptions={SwellSolution,CleavageSolution};
	{pnaOptionsWithRoundedBottomDeliveryVolumes, bottomDeliveryVolumePrecisionTest}=If[gatherTests,
		RoundOptionPrecision[
			pnaOptionsWithRoundedTopDeliveryVolumes,
			bottomDeliveryVolumePrecisionOptions,
			Table[2.5 Milliliter,Length[bottomDeliveryVolumePrecisionOptions]],
			Output->{Result,Tests},Round->Up
		],
		{
			RoundOptionPrecision[
				pnaOptionsWithRoundedTopDeliveryVolumes,
				bottomDeliveryVolumePrecisionOptions,
				Table[2.5 Milliliter,Length[bottomDeliveryVolumePrecisionOptions]],Round->Up
			],Null
		}
	];

	(* The precision of any time option is 1 second.*)
	timePrecisionOptions={SwellTime,DeprotectionTime,DownloadDeprotectionTime,DeprotonationTime,DownloadDeprotonationTime,CappingTime,DownloadCappingTime,ActivationTime,DownloadActivationTime,CouplingTime,DownloadCouplingTime,CleavageTime,TriturationTime};

	{allRoundedPNAOptionsAssociation, timePrecisionTest}=If[gatherTests,
		RoundOptionPrecision[
			pnaOptionsWithRoundedBottomDeliveryVolumes,
			timePrecisionOptions,
			Table[1 Second,Length[timePrecisionOptions]],
			Output->{Result,Tests},Round->Up
		],
		{
			RoundOptionPrecision[
				pnaOptionsWithRoundedBottomDeliveryVolumes,
				timePrecisionOptions,
				Table[1 Second,Length[timePrecisionOptions]],Round->Up
			],Null
		}
	];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*== NOTE: uneeded download resin options provided by user *)
	(* list of all options that are only relevant if DownloadResin->True*)
	downloadResinMultipleOptions={
		DownloadDeprotectionVolume,DownloadDeprotectionTime,NumberOfDownloadDeprotections,NumberOfDownloadDeprotectionWashes,
		DownloadDeprotonationVolume,DownloadDeprotonationTime,NumberOfDownloadDeprotonations,NumberOfDownloadDeprotonationWashes,
		DownloadCappingVolume,DownloadCappingTime,NumberOfDownloadCappings,NumberOfDownloadCappingWashes,
		DownloadMonomer,DownloadMonomerVolume,DownloadActivationVolume,DownloadActivationTime,
		DownloadCouplingTime,NumberOfDownloadCouplingWashes
	};
	downloadResinSingleOptions={DownloadActivationSolution};

	(* if we're not downloading, then there is no reason for the user to provide any of the download resin options*)
	unneededDownloadResinOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not downloading*)
			If[Not[#1],
				(* get those options that are not automatic or null (because user specified them) *)
				PickList[downloadResinMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,DownloadResin],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,downloadResinMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required only if at least a single resin is being downloaded*)
		If[Not[willDownloadResin],
			PickList[
				downloadResinSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,downloadResinSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	(*do the oppositve check as well, this is to make sure that the user doesn't set a needed option to Null*)
	neededDownloadResinOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not downloading*)
			If[#1,
				(* get those options that have been set to Null, which is bad becuase we needs them *)
				PickList[downloadResinMultipleOptions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,DownloadResin],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,downloadResinMultipleOptions]]
			}
		],
		(* do the same with single options, they are for sure required if any resin is being downloaded*)
		If[willDownloadResin,
			PickList[
				downloadResinSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,downloadResinSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededDownloadResinOptions]>0, Not[gatherTests]],
		Message[Error::UnneededDownloadResinOptions, unneededDownloadResinOptions]
	];
	If[And[Length[neededDownloadResinOptions]>0, Not[gatherTests]],
		Message[Error::RequiredOption, DownloadResin, True, neededDownloadResinOptions],
		{}
	];

	(* Prepare the tests for unneeded download resin options*)
	unneededDownloadResinOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededDownloadResinOptions]>0,
				Test["The options "<>ToString[unneededDownloadResinOptions]<>" should only be specified for model oligomers for which DownloadResin was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[unneededDownloadResinOptions]==0,
				Test["No unneed download resin options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Prepare the tests for unneeded download resin options*)
	neededDownloadResinOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededDownloadResinOptions]>0,
				Test["The options "<>ToString[neededDownloadResinOptions]<>" cannot be specified as Null for model oligomers for which DownloadResin was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[neededDownloadResinOptions]==0,
				Test["No download resin options have been set to Null for model oligomers for which DownloadResin was set to True:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*== NOTE: Resin option errors *)
	(*
	1) If DownloadResin->True and the Resin contains a Model[Resin,SolidPhaseSupport] then we can't proceed since we're expecting a Model[Resin]
	2) If DownloadResin -> False and Resin is Automatic, then we can't proceed, since we're forcing the user to give us the resin in this case
	3) If DownloadResin is False and Resin is Model[Resin,SolidPhaseSupport], validate that it fits to the strand further down
	4) If DownloadResin is False and Resin is Model[Resin], then we can't proceed since we're expecting a downloaded resin
	*)
	(* Let's do a big switch to extract all the possible error scenarios. *)
	(* In each case, we will collect the bad samples (except in the case of the validation, collect the sample packet and the resin since we need to do further tests below) *)
	{wrongResinSamples,needResinSamples,needToValidateResinTuples,needDResinSamples}=Transpose[MapThread[
		Function[{downloadResin,resin,sampleObject,packet,resinPacket,resinStrandPacket},
			Switch[{downloadResin,resin,If[NullQ[resinPacket],Null,Lookup[resinPacket,Object]]},
				(* If DownloadResin is True (which is default), and the Resin is specified by the user and is Model[Resin,SolidPhaseSupport], we can't proceed since we're expecting a undownloaded resin (without a strand) *)
				{True,Except[Automatic],ObjectP[Model[Resin,SolidPhaseSupport]]},
				{sampleObject,{},{},{}},
				(* If DownloadResin is False and Resin is not specified by the user we can't proceed since we're forcing the user to provide a downloaded resin if they don't want to download as the first synthesis step *)
				{False,Automatic,_},
				{{},sampleObject,{},{}},
				(* If DownloadResin is False and Resin is specified correctly as Model[Resin,SolidPhaseSupport] (with strand), need to check that it matches the strand to be synthesized - do this further down *)
				{False,Except[Automatic],ObjectP[Model[Resin,SolidPhaseSupport]]},
				{{},{},{packet,resinPacket,resinStrandPacket},{}},
				(* If DownloadResin is False and Resin is specified to a undownloaded Resin, we can't proceed since we're expecting a downloaded resin *)
				(* Note that undownloaded Resin will also MatchQ Model[Sample], but we've already encountered that scenario above so all that is left is the non-oligomer resins *)
				{False,Except[Automatic],ObjectP[{Model[Resin]}]},
				{{},{},{},sampleObject},
				(* If DownloadResin is True (default) and Resin is not specificied (Automatic), we're good since we can resolve to the default undownloaded Resin *)
				{True,Automatic,_},
				{{},{},{},{}},
				(* a catch all for all other cases *)
				_,
				{{},{},{},{}}
			]],
		{providedDownloadResin,providedResins,myInputs,oligomerModelPackets,resinCompositionPackets,resinStrandPackets}
	]];

	(* If there are wrongResinSamples and we are throwing messages, throw an error message and keep track of our invalid option for Error::InvalidOptions below *)
	wrongResinOptions=If[(Length[Flatten[wrongResinSamples]]>0 && messages),
		Message[Error::WrongResin,ObjectToString[Flatten[wrongResinSamples],Cache->cache]];
		{Resin,DownloadResin},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	wrongResinInvalidTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,Flatten[wrongResinSamples]];
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[passingInputs,Cache->cache]<>", the option Resin is specified to an undownloaded resin while the option DownloadResin is set to True:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[Flatten[wrongResinSamples]]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[Flatten[wrongResinSamples],Cache->cache]<>", the option Resin is specified to an undownloaded resin while the option DownloadResin is set to True:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If there are needResinSamples and we are throwing messages, throw an error message and keep track of our invalid option for Error::InvalidOptions below *)
	needResinOptions=If[(Length[Flatten[needResinSamples]]>0 && messages),
		Message[Error::ResinNeeded,ObjectToString[Flatten[needResinSamples],Cache->cache]];
		{Resin,DownloadResin},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	needResinInvalidTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,Flatten[needResinSamples]];
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[passingInputs,Cache->cache]<>", DownloadReasin is set to False and an appropriate Resin is provided:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[Flatten[needResinSamples]]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[Flatten[needResinSamples],Cache->cache]<>", DownloadReasin is set to False and a appropriate Resin is provided:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If there are wrongResinSamples and we are throwing messages, throw an error message and keep track of our invalid option for Error::InvalidOptions below *)
	wrongDResinOptions=If[(Length[Flatten[needDResinSamples]]>0 && messages),
		Message[Error::DownloadedResinNeeded,ObjectToString[Flatten[needDResinSamples],Cache->cache]];
		{Resin,DownloadResin},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	wrongDResinInvalidTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,Flatten[needDResinSamples]];
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[passingInputs,Cache->cache]<>", the option Resin is specified to a downloaded resin while the option DownloadResin is set to False:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[Flatten[needDResinSamples]]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[Flatten[needDResinSamples],Cache->cache]<>", the option Resin is specified to a downloaded resin while the option DownloadResin is set to False:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* extract from the needToValidateResinTuples the packets and the resins that we need to validate *)
	validateSequenceSamplePackets=DeleteCases[needToValidateResinTuples,{}][[All,1]];
	validateSequenceResinPackets=DeleteCases[needToValidateResinTuples,{}][[All,2]];
	validateSequenceResinStrandPackets=DeleteCases[needToValidateResinTuples,{}][[All,3]];

	(* for samples with DownloadResin -> False and a provided downloaded resin, we may be good to proceed but we need to validate that the monomers on the resin match to the strand being synthesized *)
	(* for problematic samples we collect both the packet and the resin so we can throw appropriate messages or tests below *)
	mismatchDResinResults=MapThread[
		Function[{packet,resinPacket,resinStrandPacket},
			Module[{strand,monomers,resinStrand,resinMonomers,resinSequenceLength,strandSequenceLength,overlappingStrand},

				(* get the strands we're dealing with *)
				strand=Map[ToStrand[#]&,{Lookup[packet,Molecule]}];

				(* get the monomers of the strand to synthesize, 5' to 3' *)
				monomers = Flatten[Monomers[strand]];

				(* get the strands that are on the resin - we know there are some since we're only here if we needed to validate *)
				resinStrand=Map[ToStrand[#]&,{Lookup[resinStrandPacket,Molecule]}];

				(* get the monomers of the strand on the resin, 5' to 3' *)
				resinMonomers = Flatten[Monomers[resinStrand]];

				(* get the number of monomers on the resin. *)
				resinSequenceLength = Length[resinMonomers];

				(* get the number of monomers of the strand to synthesize *)
				strandSequenceLength=Length[monomers];

				(* If the length of the resin sequence is longer than the length of the strand to be synthesised, we already have a problem *)
				If[resinSequenceLength>strandSequenceLength,
					{packet,resinMonomers},
					(* If the resin monomers don't match the respective monomers of the strand to be syntehsised, we also have a problem *)
					If[!MatchQ[resinMonomers,Take[monomers,-(resinSequenceLength)]],
						{packet,resinMonomers},
						(* if they match, we return Nothing, the MapThread Result will return an empty list therefore if no samples are problematic *)
						Nothing]
				]
			]
		],
		{validateSequenceSamplePackets,validateSequenceResinPackets,validateSequenceResinStrandPackets}
	];

	(* extract from the mismatch results the samples, the strands, and the monomers that we need to throw messages *)
	mismatchedResinSamples=If[MatchQ[Flatten[mismatchDResinResults],{}],{},Lookup[mismatchDResinResults[[All,1]],Object]];
	mismatchedResinStrand=If[MatchQ[Flatten[mismatchDResinResults],{}],{},Lookup[mismatchDResinResults[[All,1]],Strand,{}]];
	mismatchedResinMonomers=If[MatchQ[Flatten[mismatchDResinResults],{}],{},mismatchDResinResults[[All,2]]];

	(* If there are mismatchDResinSamples and we are throwing messages, throw an error message and keep track of our invalid option for Error::InvalidOptions below *)
	mismatchDResinOptions=If[(Length[mismatchedResinSamples]>0 && messages),
		Message[Error::MismatchedResinAndStrand,ObjectToString[mismatchedResinSamples,Cache->cache],ObjectToString[mismatchedResinMonomers,Cache->cache],ObjectToString[mismatchedResinStrand,Cache->cache]];
		{Resin},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	mismatchDResinTests=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{passingInputs,passingInputsTest,failingInputsTest},
			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,mismatchedResinSamples];
			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[passingInputs,Cache->cache]<>", the preloaded sequence on the specified resin matches the 3' base(s) in the strand to be synthesized:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[mismatchedResinSamples]>0,
				Test["For the input oligomer model(s) "<>ObjectToString[mismatchedResinSamples,Cache->cache]<>", the preloaded sequence on the specified resin matches the 3' base(s) in the strand to be synthesized:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];


	(*== NOTE: needed/uneeded cleavage options provided by user *)
	(* list of all options that are only relevant if Cleavage->True*)
	cleavageMultipleOptions = Join[
		{CleavageVolume, CleavageTime, NumberOfCleavageCycles,ResuspensionVolume},
	(* only if we were provided no mix primitives, then we care about the resuspension mix options *)
		If[!MatchQ[Lookup[allRoundedPNAOptionsAssociation, ResuspensionMixPrimitives], {(Automatic |	Null) ..}],
			{ResuspensionMixPrimitives},
			{ResuspensionMixType} (* we can't include ResuspensionMixTime and NumberOfResuspensionMixes because those actually can be Null *)
		]
	];
	cleavageSingleOptions={CleavageSolution,TriturationSolution,TriturationVolume,TriturationTime,NumberOfTriturationCycles,TriturationTemperature,ResuspensionBuffer};

	(* if we're not cleaving, then there is no reason for the user to provide any of the cleavage/trituration options*)
	unneededCleavageOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not cleaving*)
			If[Not[#1],
				(* get those options that are not automatic or null (because user specified them) *)
				PickList[cleavageMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Cleavage],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,cleavageMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required only if at least a single strand is cleaved*)
		If[Not[willCleave],
			PickList[
				cleavageSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,cleavageSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	(*do the oppositve check as well, this is to make sure that the user doesn't set a needed option to Null*)
	neededCleavageOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if cleaving*)
			If[#1,
				(* get those options that have been set to Null, which is bad because we need them *)
				PickList[cleavageMultipleOptions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Cleavage],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,cleavageMultipleOptions]]
			}
		],
		(* do the same with single options, cannot be setting these optoins to Null if we're Cleaving*)
		If[willCleave,
			PickList[
				cleavageSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,cleavageSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededCleavageOptions]>0, Not[gatherTests]],Message[Error::UnneededCleavageOptions, unneededCleavageOptions],{}];
	If[And[Length[neededCleavageOptions]>0, Not[gatherTests]],Message[Error::RequiredOption, Cleavage, True, neededCleavageOptions],{}];

	(* Prepare the tests for unneeded cleavage options *)
	unneededCleavageOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededCleavageOptions]>0,
				Test["The options "<>ToString[unneededCleavageOptions]<>" should only be specified for model oligomers for which Cleavage was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[unneededCleavageOptions]==0,
				Test["No unneed clevage options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Prepare the tests for needed cleavage options *)
	neededCleavageOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededCleavageOptions]>0,
				Test["The options "<>ToString[neededCleavageOptions]<>" cannot be specified as Null for model oligomers for which Cleavage was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[neededCleavageOptions]==0,
				Test["No needed clevage options have been set to Null:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*== NOTE: uneeded deprotonation options provided by user *)
	(* list of all options that are only relevant if Deprotonation->True OR DownloadResin->True (since download has a deprotonation step) *)
	deprotonationMultipleOptions={DeprotonationTime,DeprotonationVolume,NumberOfDeprotonations,NumberOfDeprotonationWashes};
	deprotonationSingleOptions={DeprotonationSolution};

	(* if we're not deprotonating, then there is no reason for the user to provide any of the deprotonation options*)
	unneededDeprotonationOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not cleaving*)
			If[Not[#1],
				(* get those options that are not automatic or null (because user specified them) *)
				PickList[deprotonationMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Deprotonation],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,deprotonationMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required only if at least a single strand is cleaved*)
		(* an exception here is that if we're downloading resin, then we're for sure deprotonating during the download so we will need the solution*)
		If[Or[Not[willDeprotonate],Not[willDownloadResin]],
			PickList[
				deprotonationSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,deprotonationSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	(*do the oppositve check as well, this is to make sure that the user doesn't set a needed option to Null*)
	neededDeprotonationOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not cleaving*)
			If[#1,
				(* make sure that any of the deprotonation option haven't been se to Null is Deprotonation -> True*)
				PickList[deprotonationMultipleOptions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Deprotonation],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,deprotonationMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required only if at least a single strand is deprotected*)
		(* an exception here is that if we're downloading resin, then we're for sure deprotonating during the download so we will need the solution*)
		If[Or[willDeprotonate,willDownloadResin],
			PickList[
				deprotonationSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,deprotonationSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededDeprotonationOptions]>0, Not[gatherTests]],Message[Error::UnneededDeprotonationOptions, unneededDeprotonationOptions],{}];
	If[And[Length[neededDeprotonationOptions]>0, Not[gatherTests]],Message[Error::RequiredOption, Deprotonation, True, neededDeprotonationOptions],{}
	];

	(* Prepare the tests for unneeded deprotonation options *)
	unneededDeprotonationOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededDeprotonationOptions]>0,
				Test["The options "<>ToString[unneededDeprotonationOptions]<>" should only be specified for model oligomers for which Deprotonation was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[unneededDeprotonationOptions]==0,
				Test["No unneed deprotonation options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];
	(* and the tests for the needed deprotonation options*)
	neededDeprotonationOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededDeprotonationOptions]>0,
				Test["The options "<>ToString[neededDeprotonationOptions]<>" cannot be specified as Null for model oligomers for which Deprotonation was set to True :",True,False],
				Nothing
			];
			passingTest=If[Length[neededDeprotonationOptions]==0,
				Test["No need deprotonation options have been set to Null:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*== NOTE: uneeded storage options provided by user *)
	(* list of all options that are only relevant is Cleavage->True*)
	storageMultipleOptions={StorageVolume};
	storageSingleOptions={StorageBuffer};

	(* If all strands are cleaved, then there is no reason for the storageMultipleOptions to be provided by the user *)
	unneededStorageOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if cleaving*)
			If[#1,
				(* get those options that are not automatic or null (because user specified them), because we don't need them *)
				PickList[storageMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Cleavage],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,storageMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required if at least a single strand has not been cleaved *)
		If[Not[willStoreResin],
			PickList[
				storageSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,storageSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	neededStorageOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if cleaving*)
			If[Not[#1],
				(* if at least one strand is not being cleaved, then we need the storage options *)
				PickList[storageMultipleOptions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,Cleavage],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,storageMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required if at least a single strand has been not cleaved *)
		If[willStoreResin,
			PickList[
				storageSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,storageSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededStorageOptions]>0, Not[gatherTests]],Message[Error::UnneededStorageOptions, unneededStorageOptions],{}];
	If[And[Length[neededStorageOptions]>0, Not[gatherTests]],Message[Error::RequiredOption, SwellResin, True, neededStorageOptions],{}];

	(* Prepare the tests for unneeded storage options *)
	unneededStorageOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededStorageOptions]>0,
				Test["The options "<>ToString[unneededStorageOptions]<>" should only be specified for model oligomers for which Cleavage was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[unneededStorageOptions]==0,
				Test["No unneeded storage options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* Prepare the tests for needed storage options *)
	neededStorageOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededStorageOptions]>0,
				Test["The options "<>ToString[neededStorageOptions]<>" cannot be specified for model oligomers for which Cleavage was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[neededStorageOptions]==0,
				Test["No needed storage options have been set to Null:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*== NOTE: uneeded swell options provided by user *)
	(* list of all options that are only relevant is Cleavage->True*)
	swellMultipleOptions={SwellTime,SwellVolume,NumberOfSwellCycles};
	swellSingleOptions={SwellSolution};

	(* If all strands are swolled, then there is no reason for the swellMultipleOptions to be provided by the user *)
	unneededSwellOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if cleaving*)
			If[Not[#1],
				(* get those options that are not automatic or null (because user specified them), because we don't need them *)
				PickList[swellMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,SwellResin],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,swellMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required if at least a single strand has not been cleaved *)
		If[Not[willSwell],
			PickList[
				swellSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,swellSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededSwellOptions]>0, Not[gatherTests]],Message[Error::UnneededSwellOptions, unneededSwellOptions],{}];

	(* Prepare the tests for unneeded options *)
	unneededSwellOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededSwellOptions]>0,
				Test["The options "<>ToString[unneededSwellOptions]<>" should only be specified for model oligomers for which SwellResin was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[unneededSwellOptions]==0,
				Test["No unneeded swell options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(*== NOTE: uneeded resin shrink optoins (methanol/isopropanol washes) *)
	(* list of all options that are only relevant is Cleavage->True*)
	methanolMultipleOpions={PrimaryResinShrinkTime,PrimaryResinShrinkVolume};
	isopropanolMultipleOptions={SecondaryResinShrinkTime,SecondaryResinShrinkVolume};
	methanolSingleOptions={PrimaryResinShrinkSolution};
	isopropanolSingleOptions={SecondaryResinShrinkSolution};


	(* If all strands are shrunk with methanol, then there is no reason for the methanolMultipleOpions to be provided by the user *)
	unneededMethanolShrinkOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not shrinking*)
			If[Not[#1],
				(* get those options methanolMultipleOpions are not automatic or null (because user specified them), because we don't need them *)
				PickList[methanolMultipleOpions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,PrimaryResinShrink],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,methanolMultipleOpions]]
			}
		],
		(* do the same with single options, these are only required willBlah is not True*)
		If[Not[willMethanolShrink],
			PickList[
				methanolSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,methanolSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	unneededIsopropanolShrinkOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not shrinking*)
			If[Not[#1],
				(* get those options isopropanolMultipleOptions are not automatic or null (because user specified them), because we don't need them *)
				PickList[isopropanolMultipleOptions,#2,Except[Alternatives[Automatic, Null]]],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,SecondaryResinShrink],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,isopropanolMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required willBlah is not True*)
		If[Not[willIsopropanolShrink],
			PickList[
				isopropanolSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,isopropanolSingleOptions],
				Except[Alternatives[Automatic, Null]]
			],
			Nothing
		]
	}]];

	neededMethanolShrinkOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not shrinking*)
			If[#1,
				(* get those options methanolMultipleOpions are not automatic or null (because user specified them), because we don't need them *)
				PickList[methanolMultipleOpions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,PrimaryResinShrink],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,methanolMultipleOpions]]
			}
		],
		(* do the same with single options, these are only required willBlah is not True*)
		If[willMethanolShrink,
			PickList[
				methanolSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,methanolSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	neededIsopropanolShrinkOptions=DeleteDuplicates[Flatten[{
		MapThread[
			(* if not shrinking*)
			If[#1,
				(* get those options isopropanolMultipleOptions are not automatic or null (because user specified them), because we don't need them *)
				PickList[isopropanolMultipleOptions,#2,Null],
				(* else we do not care*)
				Nothing
			]&,
			{
				Lookup[allRoundedPNAOptionsAssociation,SecondaryResinShrink],
				Transpose[Lookup[allRoundedPNAOptionsAssociation,isopropanolMultipleOptions]]
			}
		],
		(* do the same with single options, these are only required willBlah is not True*)
		If[willIsopropanolShrink,
			PickList[
				isopropanolSingleOptions,
				Lookup[allRoundedPNAOptionsAssociation,isopropanolSingleOptions],
				Null
			],
			Nothing
		]
	}]];

	(* Prepare resin shrink tests *)
	unneededMethanolShrinkOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededMethanolShrinkOptions]>0,
				Test["The options "<>ToString[unneededMethanolShrinkOptions]<>" should only be specified for model oligomers for which PrimaryResinShrink was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[unneededMethanolShrinkOptions]==0,
				Test["No unneeded methanol shrink options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];
	unneededIsopropanolShrinkOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[unneededIsopropanolShrinkOptions]>0,
				Test["The options "<>ToString[unneededIsopropanolShrinkOptions]<>" should only be specified for model oligomers for which SecondaryResinShrink was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[unneededIsopropanolShrinkOptions]==0,
				Test["No unneeded isopropanol shrink options have been provided:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];
	neededMethanolShrinkOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededMethanolShrinkOptions]>0,
				Test["The options "<>ToString[neededMethanolShrinkOptions]<>" cannot be specified as Null for model oligomers for which PrimaryResinShrink was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[neededMethanolShrinkOptions]==0,
				Test["No needed methanol shrink have been set to Null:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];
	neededIsopropanolShrinkOptionsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[neededIsopropanolShrinkOptions]>0,
				Test["The options "<>ToString[neededIsopropanolShrinkOptions]<>" cannot be specified as Null for model oligomers for which SecondaryResinShrink was set to False:",True,False],
				Nothing
			];
			passingTest=If[Length[neededIsopropanolShrinkOptions]==0,
				Test["No needed isopropanol shrink have been set to Null:",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	(* If there are invalid options and we are throwing messages, throw an error message. *)
	If[And[Length[unneededMethanolShrinkOptions]>0, Not[gatherTests]],Message[Error::UnneededShrinkOptions, unneededMethanolShrinkOptions, PrimaryResinShrink],{}];
	If[And[Length[unneededIsopropanolShrinkOptions]>0, Not[gatherTests]],Message[Error::UnneededShrinkOptions, unneededIsopropanolShrinkOptions, SecondaryResinShrink],{}];
	If[And[Length[neededMethanolShrinkOptions]>0, Not[gatherTests]],Message[Error::RequiredOption, PrimaryResinShrink, True, neededMethanolShrinkOptions],{}];
	If[And[Length[neededIsopropanolShrinkOptions]>0, Not[gatherTests]],Message[Error::RequiredOption, SecondaryResinShrink, True, neededIsopropanolShrinkOptions],{}];


	(*== NOTE: final cap without a final deprotection *)
	(* get a list of *)
	finalCapButNoFinalDeprotectionPackets=MapThread[
		Function[{packet,cap,deprotection},
			If[And[cap,Not[deprotection]],packet,Nothing]
		],
		{
			oligomerModelPackets,
			Lookup[allRoundedPNAOptionsAssociation,FinalCapping],
			Lookup[allRoundedPNAOptionsAssociation,FinalDeprotection]
		}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	finalCapButNoFinalDeprotectionInputs = If[And[Length[finalCapButNoFinalDeprotectionPackets] > 0, Not[gatherTests]],
		With[{objects = Lookup[finalCapButNoFinalDeprotectionPackets, Object]},
			Message[Error::FinalCapWithoutFinalDeprotection, objects];
			objects
		], {}
	];

	finalCapButNoFinalDeprotectionTest = If[gatherTests,
		Module[{failingTest, passingTest},
			failingTest = If[Length[finalCapButNoFinalDeprotectionPackets] == 0,
				Nothing,
				Test["Our input oligomer models " <> ObjectToString[myInputs, Cache -> cache] <> " have FinalDeprotection specified when FinalCapping is requested:", True, False]
			];
			passingTest = If[Length[finalCapButNoFinalDeprotectionPackets] == Length[myInputs],
				Nothing,
				Test["Our input oligomer models " <> ObjectToString[Complement[myInputs, finalCapButNoFinalDeprotectionPackets], Cache -> cache] <> " have FinalDeprotection specified when FinalCapping is requested:", True, True]
			];
			{failingTest, passingTest}
		],
		Nothing
	];

	(*== NOTE: check ResuspensionMixPrimitives vs resuspension options *)

	(* list of all options that are only relevant is Cleavage->True*)
	resuspensionMultipleOptions = {NumberOfResuspensionMixes, ResuspensionMixTime, ResuspensionMixType};

	(* get the resuspension options that are provided *)
	providedCleavageOptions = Map[
	(* get those options that are not automatic or null (because user specified them) *)
		PickList[resuspensionMultipleOptions, #1, Except[Alternatives[Automatic, Null]]]&,
		Transpose[Lookup[allRoundedPNAOptionsAssociation, resuspensionMultipleOptions]]
	];

	(* Figure out whether we have unneeded resuspension options (still indexmatching) -- we only care if we're cleaving *)
	unneededResuspensionOptionsBools = MapThread[
	(* Only if we're cleaving: If there is a mix primitive (neither Null nor Automatic) and we have options provided, then we're in trouble *)
		If[(#1 &&!MatchQ[#2, (Null | Automatic)] && !MatchQ[#3, {}]),
			True,
			False
		]&,
		{Lookup[allRoundedPNAOptionsAssociation, Cleavage],Lookup[allRoundedPNAOptionsAssociation, ResuspensionMixPrimitives],providedCleavageOptions}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid options.*)
	unneededResuspensionOptions = If[And[AnyTrue[unneededResuspensionOptionsBools,TrueQ], Not[gatherTests]],
		Message[Error::UnneededResuspensionOptions,DeleteDuplicates[Flatten[providedCleavageOptions]]];
		DeleteDuplicates[Flatten[providedCleavageOptions]],
		{}
	];

	(* make a test for unneeded resuspesnion options *)
	unneededResuspensionTest=If[gatherTests,
		Test["Either ResuspensionMixPrimitives or Resuspension mix options were provided, when Cleavage is set to True:",AnyTrue[unneededResuspensionOptionsBools,TrueQ],False]
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)
	{instrument,synthesisStrategy,recoupMonomers,washSolution,swellSolution,deprotectionSolution,cappingSolution,activationSolution,deprotonationSolution,cleavageSolution,storageBuffer,triturationSolution,resuspensionBuffer,triturationTime,numberOfTriturationCycles,methanol,isopropanol};

	(* NOTE: single option resolution *)
	instrument=Lookup[allRoundedPNAOptionsAssociation,Instrument];
	synthesisStrategy=Lookup[allRoundedPNAOptionsAssociation,SynthesisStrategy];
	recoupMonomers=Lookup[allRoundedPNAOptionsAssociation,RecoupMonomers];

	(* resolving the wash solution, there can only be one of those per synthesis*)
	washSolution=Lookup[allRoundedPNAOptionsAssociation,WashSolution];
	deprotectionSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,DeprotectionSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[MatchQ[synthesisStrategy,Fmoc],
				Model[Sample, StockSolution, "Deprotection Solution (20% piperidine in NMP)"],
				Model[Sample, StockSolution, "95% TFA 5% m-cresol"]
			]
		]
	];
	cappingSolution=Lookup[allRoundedPNAOptionsAssociation,CappingSolution];
	activationSolution=Lookup[allRoundedPNAOptionsAssociation,ActivationSolution];

	(* resolving the download activation solution, unless otherwise specified by the user it will be the same as the activation solution
		and will actually pull the solution from the same source bottle. if the user specifies something else we'll ultimaterly put it in
		monomer bottles (this feasture was paid for by a user)
	 *)
	downloadActivationSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,DownloadActivationSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willDownloadResin,activationSolution,Null]
		]
	];

	(* resolve the swell solution option, only if we're gonig to swell *)
	swellSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,SwellSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willSwell,Model[Sample, "Dichloromethane, Reagent Grade"],Null]
		]
	];

	(* resolve the DeprotonationSolution, but only if deprotonating in at least one strand *)
	(* not resolving a downloadDeprotonation since there isn't a seperate solution for that*)
	deprotonationSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,DeprotonationSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[Or[willDeprotonate,willDownloadResin],Model[Sample,StockSolution,"5% DIEA in DCM"],Null]
		]
	];

	(* resolve the cleave solution option, only needed if cleaving something*)
	cleavageSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,CleavageSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,Model[Sample,StockSolution,"95% TFA-TIPS-H2O"],Null]
		]
	];

	(* resolve the trituration solution/triturationTime/numberOfTriturationCycles, but only needed if cleaving something*)
	triturationSolution=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,TriturationSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,Model[Sample,"Diethyl ether"],Null]
		]
	];
	triturationTime=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,TriturationTime]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,5 Minute,Null]
		]
	];
	triturationVolume=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,TriturationVolume]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,35 Milliliter,Null]
		]
	];
	triturationTemperature=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,TriturationTemperature]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,-80 Celsius,Null]
		]
	];
	numberOfTriturationCycles=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,NumberOfTriturationCycles]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,3,Null]
		]
	];

	(* resolve the resuspension buffer, but only needed if cleaving*)
	resuspensionBuffer=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,ResuspensionBuffer]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willCleave,Model[Sample, "Milli-Q water"],Null]
		]
	];

	(* resolve the storate solution, but only if storing uncleaved resin*)
	storageBuffer=With[
		{userOption=Lookup[allRoundedPNAOptionsAssociation,StorageBuffer]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[willStoreResin,Model[Sample,"Dimethylformamide, Reagent Grade"],Null]
		]
	];

	(* resolve methanol, but only if methanolwash is true*)
	methanol=With[
		{methanolWashuserOption=AnyTrue[Lookup[allRoundedPNAOptionsAssociation,PrimaryResinShrink],TrueQ],
			userOption=Lookup[allRoundedPNAOptionsAssociation,PrimaryResinShrinkSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[methanolWashuserOption,Model[Sample, "Methanol"],Null]
		]
	];
	(* resolve isopropanol, but only if methanolwash is true*)
	isopropanol=With[
		{methanolWashuserOption=AnyTrue[Lookup[allRoundedPNAOptionsAssociation,SecondaryResinShrink],TrueQ],
			userOption=Lookup[allRoundedPNAOptionsAssociation,SecondaryResinShrinkSolution]},
		If[Not[MatchQ[userOption,Automatic]],
			userOption,
			If[methanolWashuserOption,Model[Sample, "Isopropanol"],Null]
		]
	];

	(* Convert our options into a MapThread friendly version. *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[ExperimentPNASynthesis,allRoundedPNAOptionsAssociation];

	{
		scales,targetLoadings,cleavages,downloadResins,resins,initialDeprotections,finalDeprotections,deprotonations,initialCappings,finalCappings,
		swellResins,swellTimes,swellVolumes,numberOfSwellCycless,washVolumes,
		deprotectionVolumes,deprotectionTimes,numberOfDeprotectionss,numberOfDeprotectionWashess,
		downloadDeprotectionVolumes,downloadDeprotectionTimes,numberOfDownloadDeprotectionss,numberOfDownloadDeprotectionWashess,
		deprotonationVolumes,deprotonationTimes,numberOfDeprotonationss,numberOfDeprotonationWashess,
		downloadDeprotonationVolumes,downloadDeprotonationTimes,numberOfDownloadDeprotonationss,numberOfDownloadDeprotonationWashess,
		cappingVolumes,cappingTimes,numberOfCappingss,numberOfCappingWashess,
		downloadCappingVolumes,downloadCappingTimes,numberOfDownloadCappingss,numberOfDownloadCappingWashess,
		monomerVolumes,activationVolumes,activationTimes,
		downloadMonomers,downloadMonomerVolumes,downloadActivationVolumes,downloadActivationTimes,
		couplingTimes,numberOfCouplingWashess,doubleCouplings,downloadCouplingTimes,numberOfDownloadCouplingWashess,
		cleavageVolumes,cleavageTimes,numberOfCleavageCycless,
		methanolWashs,methanolWashVolumes,methanolWashTimes,isopropanolWashs,isopropanolWashVolumes,isopropanolWashTimes,
		resuspensionVolumes,storageVolumes,numberOfResuspensionMixess,
		samplesOutStorageConditions,unknownDownloadMonomerErrors,unknownMonomerErrors,monomers,unresolvedMonomers,
		primitivess,monomerPreactivations, resuspensionMixTimes, resuspensionMixTypes
	}=Transpose[MapThread[Function[{oligomerPacket,myMapThreadOptions},
		Module[{
			scale,targetLoading,cleavage,downloadResin,resin,initialDeprotection,finalDeprotection,deprotonation,initialCapping,finalCapping,
			swellResin,swellTime,swellVolume,numberOfSwellCycles,washVolume,
			deprotectionVolume,deprotectionTime,numberOfDeprotections,numberOfDeprotectionWashes,
			downloadDeprotectionVolume,downloadDeprotectionTime,numberOfDownloadDeprotections,numberOfDownloadDeprotectionWashes,
			deprotonationVolume,deprotonationTime,numberOfDeprotonations,numberOfDeprotonationWashes,
			downloadDeprotonationVolume,downloadDeprotonationTime,numberOfDownloadDeprotonations,numberOfDownloadDeprotonationWashes,
			cappingVolume,cappingTime,numberOfCappings,numberOfCappingWashes,
			downloadCappingVolume,downloadCappingTime,numberOfDownloadCappings,numberOfDownloadCappingWashes,
			monomers,monomerVolume,defaultDownloadMonomers,activationVolume,activationTime,
			downloadMonomerVolume,downloadActivationVolume,downloadActivationTime,
			couplingTime,numberOfCouplingWashes,doubleCoupling,downloadCouplingTime,numberOfDownloadCouplingWashes,
			cleavageVolume,cleavageTime,numberOfCleavageCycles,
			methanolWash,methanolWashVolume,methanolWashTime,isopropanolWash,isopropanolWashVolume,isopropanolWashTime,
			resuspensionVolume,storageVolume,numberOfResuspensionMixes,
			defaultFmocDownloadMonomers,defaultFmocPNABulkMonomers,defaultBocPNABulkMonomers,defaultBocDownloadMonomers,defaultPeptideBulkMonomers,providedMonomersOption,resolvedMonomers,unresolvableMonomers,
			downloadMonomer,bulkMonomers,resolveAutomatic,allResolvedOptions,
			samplesOutStorageCondition,unknownDownloadMonomerError,downloadMonomerSequence,unknownMonomerError,vettedPrimitives,
			bulkMonomersInAdditionOrder,resolvedPrimitives,unresolvedPrimitives,monomerPreactivation,unresolvedResuspensionIncubatePrimitives,
			resuspensionTime, resuspensionType,	resolvedResupensionType,resolvedResuspensionTime,unresolvedNumberOfResuspensionMixes,
			unresolvedResuspensionMixTime,unresolvedResuspensionMixType,mixPrimitivesProvided
		},

			(* pull out all the options that have a default and have already been handeled by SafeOptions*)
			{
				scale,targetLoading,cleavage,downloadResin,initialDeprotection,finalDeprotection,deprotonation,
				finalCapping,swellResin,
				deprotectionTime,numberOfDeprotections,numberOfDeprotectionWashes,
				cappingTime,numberOfCappings,numberOfCappingWashes,
				activationTime,couplingTime,numberOfCouplingWashes,doubleCoupling,
				methanolWash,isopropanolWash,
				unresolvedPrimitives,monomerPreactivation, unresolvedResuspensionIncubatePrimitives,
				unresolvedResuspensionMixType, unresolvedResuspensionMixTime, unresolvedNumberOfResuspensionMixes
			}=Lookup[myMapThreadOptions,
				{
					Scale,TargetLoading,Cleavage,DownloadResin,InitialDeprotection,FinalDeprotection,Deprotonation,
					FinalCapping,SwellResin,
					DeprotectionTime,NumberOfDeprotections,NumberOfDeprotectionWashes,
					CappingTime,NumberOfCappings,NumberOfCappingWashes,
					ActivationTime,CouplingTime,NumberOfCouplingWashes,DoubleCoupling,
					PrimaryResinShrink,SecondaryResinShrink,
					Primitives,MonomerPreactivation,
					ResuspensionMixPrimitives, ResuspensionMixType, ResuspensionMixTime, NumberOfResuspensionMixes
				}
			];

			(* set up the error variables *)
			unknownDownloadMonomerError=False;
			unknownMonomerError=False;

			(* get the strand (==Molecule post-SampleFest) and split into the first and rest of monomers*)
			(* the first is used for resolving DownloadMonomer, the rest (bulk) is used to resolve Monomers *)
			monomers=First[Monomers[ToStrand[ToStructure[Lookup[oligomerPacket,Molecule]]]]];
			downloadMonomerSequence=Last[monomers];
			bulkMonomers=Most[monomers];
			bulkMonomersInAdditionOrder=Reverse[bulkMonomers];

			(* the default monomer we use for the basic PNA monomers *)
			defaultPNABulkMonomers = Flatten[Physics`Private`lookupModelOligomer[{PNA, GammaLeftPNA, GammaRightPNA, Modification, Peptide},SyntheticMonomers,Head->True, SynthesisStrategy->synthesisStrategy]];

			(* for each unique monomer either take the user provided option, or grab something from the default list *)
			providedMonomersOption=Rule@@@ToList[Lookup[myMapThreadOptions,Monomers]];
			resolvedMonomers=Map[
				If[KeyExistsQ[providedMonomersOption,#],
					{#,Lookup[providedMonomersOption,#]},
					{#,Lookup[defaultPNABulkMonomers,#,Null]}
				]&,DeleteDuplicates[bulkMonomers]
			];

			(* check to make sure we don't have any Null here which means we could not resolve it from the provided monomers or the default bulk monomers *)
			unresolvableMonomers=Cases[resolvedMonomers[[All, 2]], Null];

			(* if we could not resolve all monomers from this strand, we need to throw an error for this oligomer - we will do this below collectively for all oligomers *)
			unknownMonomerError=If[!MatchQ[unresolvableMonomers,{}],True,False];

			(* helper that either takes the user value or resolve the automatic to the automatic value*)
			resolveAutomatic[assoc_,option_,automaticValue_]:=With[{value=Lookup[assoc,option]},
				If[MatchQ[value,Automatic],automaticValue,value]
			];

			(* a helper that helps resolve automatic options that are gated upon another (T/F) option or takes in user provided value *)
			resolveAutomatic[assoc_,option_,gateBool_,trueValue_,falseValue_]:=With[
				{value=Lookup[assoc,option]},
				(* if value is automatic, further resolve based on gateBool, else take the provied value*)
				If[MatchQ[value,Automatic],
					If[gateBool,trueValue,falseValue],
					value
				]
			];

			(* resolve the resin, if Automatic then we resolve to Model[Sample, "Rink Amide AM resin"], otherwise we use what the user specified. *)
			(* we already threw errors above in cases with conflicting DownloadResin values etc so we don't need to worry about this here *)
			resin=resolveAutomatic[myMapThreadOptions,Resin,Model[Sample, "id:n0k9mGk00lD1"]];(*Model[Sample, "Rink Amide AM resin"]*)

			(* resolve options that do not have a default (all of these are gated on another option*)
			(* TODO: download by default swells*)
			swellTime=resolveAutomatic[myMapThreadOptions,SwellTime,swellResin,20 Minute,Null];
			swellVolume=resolveAutomatic[myMapThreadOptions,SwellVolume,swellResin,10 Milliliter,Null];
			numberOfSwellCycles=resolveAutomatic[myMapThreadOptions,NumberOfSwellCycles,swellResin,3,Null];

			initialCapping=resolveAutomatic[myMapThreadOptions,InitialCapping,downloadResin,False,True];

			(* take user volumes for monomer, else resolve automatically for them (this will always be needed)*)
			monomerVolume=resolveAutomatic[myMapThreadOptions,MonomerVolume,
				Ceiling[.200 (Milliliter/Micromole)*scale,.5 Milliliter]
			];

			(* the default monomer we use to download resin *)
			defaultDownloadMonomers = Flatten[Physics`Private`lookupModelOligomer[{PNA, GammaLeftPNA, GammaRightPNA, Modification, Peptide},DownloadMonomers,Head->True, SynthesisStrategy->synthesisStrategy]];

			downloadMonomer=resolveAutomatic[myMapThreadOptions,DownloadMonomer,downloadResin,
				Lookup[defaultDownloadMonomers,downloadMonomerSequence,Null],Null
			];

			(* if we're downloading, and download monomer resolution didn't come up with anything, than this is bad and should throw an error*)
			unknownDownloadMonomerError=If[And[downloadResin,NullQ[downloadMonomer]],True,False];

			downloadMonomerVolume=resolveAutomatic[myMapThreadOptions,DownloadMonomerVolume,
				If[downloadResin,N[scale/(5  Micromole/Milliliter)],Null]
			];

			washVolume=resolveAutomatic[myMapThreadOptions,WashVolume,
				Ceiling[scale*(.1 Milliliter/Micromole)+4 Milliliter, .5 Milliliter]
			];

			activationVolume=resolveAutomatic[myMapThreadOptions,ActivationVolume,
				Ceiling[scale*(.2 Milliliter/Micromole)]
			];
			downloadActivationVolume=resolveAutomatic[myMapThreadOptions,DownloadActivationVolume,
				If[downloadResin,Ceiling[scale*(.2 Milliliter/Micromole)],Null]
			];
			downloadActivationTime=resolveAutomatic[myMapThreadOptions,DownloadActivationTime,
				If[downloadResin,10 Minute,Null]
			];

			downloadCouplingTime=resolveAutomatic[myMapThreadOptions,DownloadCouplingTime,
				If[downloadResin,60 Minute,Null]
			];
			numberOfDownloadCouplingWashes=resolveAutomatic[myMapThreadOptions,NumberOfDownloadCouplingWashes,
				If[downloadResin,numberOfCouplingWashes,Null]
			];

			cappingVolume=resolveAutomatic[myMapThreadOptions,CappingVolume,
				Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter]
			];
			downloadCappingVolume=resolveAutomatic[myMapThreadOptions,DownloadCappingVolume,
				If[downloadResin,Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter],Null]
			];
			downloadCappingTime=resolveAutomatic[myMapThreadOptions,DownloadCappingTime,
				If[downloadResin,15 Minute,Null]
			];
			numberOfDownloadCappings=resolveAutomatic[myMapThreadOptions,NumberOfDownloadCappings,
				If[downloadResin,2,Null]
			];
			numberOfDownloadCappingWashes=resolveAutomatic[myMapThreadOptions,NumberOfDownloadCappingWashes,
				If[downloadResin,numberOfCappingWashes,Null]
			];

			deprotectionVolume=resolveAutomatic[myMapThreadOptions,DeprotectionVolume,
				Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter]
			];
			downloadDeprotectionVolume=resolveAutomatic[myMapThreadOptions,DownloadDeprotectionVolume,
				If[downloadResin,Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter],Null]
			];
			downloadDeprotectionTime=resolveAutomatic[myMapThreadOptions,DownloadDeprotectionTime,
				If[downloadResin,deprotectionTime,Null]
			];
			numberOfDownloadDeprotections=resolveAutomatic[myMapThreadOptions,NumberOfDownloadDeprotections,
				If[downloadResin,2,Null]
			];
			numberOfDownloadDeprotectionWashes=resolveAutomatic[myMapThreadOptions,NumberOfDownloadDeprotectionWashes,
				If[downloadResin,numberOfDeprotectionWashes,Null]
			];

			(* Deprotonation resolution, take the user option no matter one, but resolve to Null if Deprotonation->False*)
			deprotonationVolume=resolveAutomatic[myMapThreadOptions,DeprotonationVolume,
				deprotonation,Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter],Null
			];
			deprotonationTime=resolveAutomatic[myMapThreadOptions,DeprotonationTime,
				deprotonation,5 Minute,Null
			];
			numberOfDeprotonations=resolveAutomatic[myMapThreadOptions,NumberOfDeprotonations,
				deprotonation,2,Null
			];
			numberOfDeprotonationWashes=resolveAutomatic[myMapThreadOptions,NumberOfDeprotonationWashes,
				deprotonation,5,Null
			];

			downloadDeprotonationVolume=resolveAutomatic[myMapThreadOptions,DownloadDeprotonationVolume,
				If[downloadResin,Ceiling[scale*(.2 Milliliter/Micromole)+3 Milliliter, .5 Milliliter],Null]
			];
			downloadDeprotonationTime=resolveAutomatic[myMapThreadOptions,DownloadDeprotonationTime,
				If[downloadResin,5 Minute,Null]
			];
			numberOfDownloadDeprotonations=resolveAutomatic[myMapThreadOptions,NumberOfDownloadDeprotonations,
				If[downloadResin,2,Null]
			];
			numberOfDownloadDeprotonationWashes=resolveAutomatic[
				myMapThreadOptions,NumberOfDownloadDeprotonationWashes,
				If[downloadResin,5,Null] (*5 since Deprotonation might be false in the main synthesis*)
			];

			cleavageVolume=resolveAutomatic[myMapThreadOptions,CleavageVolume,If[cleavage,5 Milliliter,Null]];
			cleavageTime=resolveAutomatic[myMapThreadOptions,CleavageTime,If[cleavage,30 Minute,Null]];
			numberOfCleavageCycles=resolveAutomatic[myMapThreadOptions,NumberOfCleavageCycles,If[cleavage,3,Null]];

			methanolWashVolume=resolveAutomatic[myMapThreadOptions,PrimaryResinShrinkVolume,If[methanolWash,20 Milliliter,Null]];
			isopropanolWashVolume=resolveAutomatic[myMapThreadOptions,SecondaryResinShrinkVolume,If[isopropanolWash,20 Milliliter,Null]];

			methanolWashTime=resolveAutomatic[myMapThreadOptions,PrimaryResinShrinkTime,If[methanolWash,1 Minute,Null]];
			isopropanolWashTime=resolveAutomatic[myMapThreadOptions,SecondaryResinShrinkTime,If[isopropanolWash,1 Minute,Null]];

			storageVolume=resolveAutomatic[myMapThreadOptions,StorageVolume,
				If[Not[cleavage],Max[5 Milliliter,Convert[scale*200 Microliter/Micromole,Milliliter]],Null]
			];
			resuspensionVolume=resolveAutomatic[myMapThreadOptions,ResuspensionVolume,If[cleavage,1 Milliliter,Null]];
			numberOfResuspensionMixes=resolveAutomatic[myMapThreadOptions,NumberOfResuspensionMixes,If[cleavage,3,Null]];

			(*TODO: not sure how to do this yet, might be helper is coming*)
			samplesOutStorageCondition=Lookup[
				myMapThreadOptions,
				SamplesOutStorageCondition
			];

			(* setup the primitives the way they be *)
			resolvedPrimitives= {
				(* -=- SWELL -=- *)
				Flatten[{
					(* Wash with WashSolution*)
					Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->3],
					(* Swell with SwellSolution *)
					If[swellResin,
						{
							Swelling[Sample->swellSolution,Volume->swellVolume,Time->swellTime, NumberOfReplicates->numberOfSwellCycles],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->3]
						},
						Nothing
					]
					(* Wash with WashSolution *)
				}],
				(* -=- DOWNLOAD -=- *)
				If[downloadResin,
					Flatten[{
						If[initialDeprotection,
							{
								Deprotecting[Sample->deprotectionSolution,Volume->downloadDeprotectionVolume,Time->downloadDeprotectionTime, NumberOfReplicates->numberOfDownloadDeprotections],
								Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDownloadDeprotectionWashes]
							},
							{}
						],
						{
							Deprotonating[Sample->deprotonationSolution,Volume->downloadDeprotonationVolume,Time->downloadDeprotonationTime, NumberOfReplicates->numberOfDownloadDeprotonations],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDownloadDeprotonationWashes]
						},
						{
							Coupling[
								Monomer->downloadMonomer,MonomerVolume->downloadMonomerVolume,
								Activator->downloadActivationSolution,ActivatorVolume->downloadActivationVolume,ActivationTime->downloadActivationTime,
								CouplingTime->downloadCouplingTime,
								Preactivation->monomerPreactivation,
								SingleShot->True,
								NumberOfReplicates->1
							],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDownloadCouplingWashes]
						},
						{
							Deprotonating[Sample->deprotonationSolution,Volume->downloadDeprotonationVolume,Time->downloadDeprotonationTime, NumberOfReplicates->numberOfDownloadDeprotonations],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDownloadDeprotonationWashes]
						},
						{
							Capping[Sample->cappingSolution,Volume->downloadCappingVolume,Time->downloadCappingTime, NumberOfReplicates->2],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDownloadCappingWashes]
						}
					}],
					Nothing
				],

				(* -=- INITIAL -=- *)
				Flatten[{
					(* Initial Cap + Wash *)
					If[initialCapping,
						{
							Capping[Sample->cappingSolution,Volume->cappingVolume,Time->cappingTime, NumberOfReplicates->numberOfCappings],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCappingWashes]
						},
						{}
					],
					(* Additional Swell step if synth strat is Boc*)
					If[MatchQ[synthesisStrategy,Boc],
						Swelling[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfSwellCycles],
						Nothing
					],
					(* Deprotection *)
					Deprotecting[Sample->deprotectionSolution,Volume->deprotectionVolume,Time->deprotectionTime, NumberOfReplicates->numberOfDeprotections],
					(* Additional Swell step if synth strat is Boc*)
					If[MatchQ[synthesisStrategy,Boc],
						Swelling[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfSwellCycles],
						Nothing
					],
					(* Post-Deprotection Wash *)
					Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes],

					(* Deprotonation, only if deprotonatin is True *)
					If[deprotonation,
						{
							Deprotonating[Sample->deprotonationSolution,Volume->deprotonationVolume,Time->deprotonationTime, NumberOfReplicates->numberOfDeprotonations],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotonationWashes]
						},
						Nothing
					],

					(* This is going to be the second monomer of the sequence (since the first is either already on the resin, or being added as part of a seperate download cycle *)
					{
						Coupling[
							Monomer->Last[FirstCase[resolvedMonomers, {bulkMonomersInAdditionOrder[[1]], _}]],
							MonomerVolume->monomerVolume,
							Activator->activationSolution,ActivatorVolume->activationVolume,ActivationTime->activationTime,
							CouplingTime->couplingTime,
							Preactivation->monomerPreactivation,
							SingleShot->False,
							NumberOfReplicates->If[Or[NullQ[doubleCoupling],doubleCoupling>=2],1,2]
						],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCouplingWashes]
					},

					(* Capping + Wash*)
					{
						Capping[Sample->cappingSolution,Volume->cappingVolume,Time->cappingTime, NumberOfReplicates->numberOfCappings],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCappingWashes]
					}
				}],

				(* MIDDLE MONOMERS *)
				(* In the rare case that we're making a strand of 2 monomers, we skip this step since the first monomer is taken care of and the last monomer is being taking care of below in "FINAL" *)
				If[Length[bulkMonomersInAdditionOrder]==1,
					{},
					Sequence@@MapIndexed[
					{
						(* Additional Swell step if synth strat is Boc*)
						If[
							MatchQ[synthesisStrategy,Boc],
							Swelling[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->4],
							Nothing
						],

						(* Deprotection *)
						Deprotecting[Sample->deprotectionSolution,Volume->deprotectionVolume,Time->deprotectionTime, NumberOfReplicates->numberOfDeprotections],

						(* Additional Swell step if synth strat is Boc*)
						If[MatchQ[synthesisStrategy,Boc],
							Swelling[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes],
							Nothing
						],

						(* Post-Deprotection Wash *)
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes],

						(* Deprotonation, only if deprotonatin is True *)
						If[deprotonation,
							{
								Deprotonating[Sample->deprotonationSolution,Volume->deprotonationVolume,Time->deprotonationTime, NumberOfReplicates->numberOfDeprotonations],
								Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotonationWashes]
							},
							Nothing
						],

						(* For each monomer of the sequence, make an activate monomer primitive *)
						Coupling[
							Monomer->Last[FirstCase[resolvedMonomers, {#1, _}]],
							MonomerVolume->monomerVolume,
							Activator->activationSolution,ActivatorVolume->activationVolume,ActivationTime->activationTime,
							CouplingTime->couplingTime,
							Preactivation->monomerPreactivation,
							SingleShot->False,
							NumberOfReplicates->If[Or[NullQ[doubleCoupling],doubleCoupling>=(First[#2]+2)],1,2]
						],

						(* Post-Coupling Wash *)
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCouplingWashes],

						(* Capping *)
						Capping[Sample->cappingSolution,Volume->cappingVolume,Time->cappingTime, NumberOfReplicates->numberOfCappings],

						(* Post-Capping Wash *)
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCappingWashes]
					}&,bulkMonomersInAdditionOrder[[2 ;; -2]]
					]
				],
				(* -=- FINAL -=- *)
				Flatten[{
					(* Additional Swell step if synth strat is Boc*)
					If[
						MatchQ[synthesisStrategy,Boc],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->4],
						Nothing
					],

					(* Deprotection *)
					Deprotecting[Sample->deprotectionSolution,Volume->deprotectionVolume,Time->deprotectionTime, NumberOfReplicates->numberOfDeprotections],

					(* Additional Swell step if synth strat is Boc*)
					If[
						MatchQ[synthesisStrategy,Boc],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes],
						Nothing
					],

					(* Post-Deprotection Wash *)
					Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes],

					(* Deprotonation, only if deprotonatin is True *)
					If[deprotonation,
						{
							Deprotonating[Sample->deprotonationSolution,Volume->deprotonationVolume,Time->deprotonationTime, NumberOfReplicates->numberOfDeprotonations],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotonationWashes]
						},
						Nothing
					],

					(* Coupling + Wash *)
					{
						Coupling[
							Monomer->Last[FirstCase[resolvedMonomers, {bulkMonomersInAdditionOrder[[-1]], _}]],
							MonomerVolume->monomerVolume,
							Activator->activationSolution,ActivatorVolume->activationVolume,ActivationTime->activationTime,
							CouplingTime->couplingTime,
							Preactivation->monomerPreactivation,
							SingleShot->False,
							NumberOfReplicates->If[Or[NullQ[doubleCoupling],doubleCoupling>=Length[monomers]],1,2]
						],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCouplingWashes]
					},

					If[finalDeprotection,
						{
							Deprotecting[Sample->deprotectionSolution,Volume->deprotectionVolume,Time->deprotectionTime, NumberOfReplicates->numberOfDeprotections],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfDeprotectionWashes]
						},
						Nothing
					],

					If[finalCapping,
						{
							Capping[Sample->cappingSolution,Volume->cappingVolume,Time->cappingTime, NumberOfReplicates->numberOfCappings],
							Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->numberOfCappingWashes]
						},
						Nothing
					],
					If[methanolWash,Washing[Sample->methanol,Volume->methanolWashVolume,Time->methanolWashTime,NumberOfReplicates->1],Nothing],
					If[isopropanolWash,Washing[Sample->isopropanol,Volume->isopropanolWashVolume,Time->isopropanolWashTime,NumberOfReplicates->1],Nothing]
				}],

				(* -=- CLEAVAGE -=- *)
				If[cleavage,
					{
						(* Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->1], *) (* TODO we're eliminating this wash *)
						Cleaving[Sample->cleavageSolution,Volume->cleavageVolume,Time->cleavageTime, NumberOfReplicates->numberOfCleavageCycles],
						Washing[Sample->washSolution,Volume->washVolume,Time->1 Minute, NumberOfReplicates->3]
					},
					Nothing
				]

			};

			(* reconcile my primitives with user provide ones *)
			vettedPrimitives=If[
				MatchQ[unresolvedPrimitives, Automatic],
				resolvedPrimitives,
				unresolvedPrimitives
			];

			(* check whether we have been provided mix primitives for resuspension *)
			mixPrimitivesProvided=!MatchQ[unresolvedResuspensionIncubatePrimitives,(Automatic|Null)];

			(* we only care about volume if we are cleaving *)
			resuspensionVolume = resolveAutomatic[myMapThreadOptions, ResuspensionVolume, If[cleavage, 1 Milliliter, Null]];

			(* first we resolve the mix type *)
			resolvedResupensionType = resolveAutomatic[myMapThreadOptions, ResuspensionMixType, If[cleavage&&!mixPrimitivesProvided, Pipette, Null]];
			numberOfResuspensionMixes = resolveAutomatic[myMapThreadOptions, NumberOfResuspensionMixes, If[cleavage&&!mixPrimitivesProvided && MatchQ[resolvedResupensionType,Pipette], 10, Null]];
			resolvedResuspensionTime = resolveAutomatic[myMapThreadOptions, ResuspensionMixTime, If[cleavage&&!mixPrimitivesProvided && MatchQ[resolvedResupensionType,Sonicate|Vortex], 5*Minute, Null]];

			allResolvedOptions={
				scale,targetLoading,cleavage,downloadResin,resin,initialDeprotection,finalDeprotection,deprotonation,initialCapping,finalCapping,
				swellResin,swellTime,swellVolume,numberOfSwellCycles,washVolume,
				deprotectionVolume,deprotectionTime,numberOfDeprotections,numberOfDeprotectionWashes,
				downloadDeprotectionVolume,downloadDeprotectionTime,numberOfDownloadDeprotections,numberOfDownloadDeprotectionWashes,
				deprotonationVolume,deprotonationTime,numberOfDeprotonations,numberOfDeprotonationWashes,
				downloadDeprotonationVolume,downloadDeprotonationTime,numberOfDownloadDeprotonations,numberOfDownloadDeprotonationWashes,
				cappingVolume,cappingTime,numberOfCappings,numberOfCappingWashes,
				downloadCappingVolume,downloadCappingTime,numberOfDownloadCappings,numberOfDownloadCappingWashes,
				monomerVolume,activationVolume,activationTime,
				downloadMonomer,downloadMonomerVolume,downloadActivationVolume,downloadActivationTime,
				couplingTime,numberOfCouplingWashes,doubleCoupling,downloadCouplingTime,numberOfDownloadCouplingWashes,
				cleavageVolume,cleavageTime,numberOfCleavageCycles,
				methanolWash,methanolWashVolume,methanolWashTime,isopropanolWash,isopropanolWashVolume,isopropanolWashTime,
				resuspensionVolume,storageVolume,numberOfResuspensionMixes,
				samplesOutStorageCondition,unknownDownloadMonomerError,unknownMonomerError,resolvedMonomers,unresolvableMonomers,vettedPrimitives,
				monomerPreactivation, resolvedResuspensionTime, resolvedResupensionType
			};

			allResolvedOptions
		]
	],{oligomerModelPackets,mapThreadFriendlyOptions}
	]];

	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* If any of the unknownDownloadMonomerErrors returned True, then we need to throw an error here, also collect InvalidOption *)
	unknowDownloadMonomerOptions=If[Or@@unknownDownloadMonomerErrors&&!gatherTests,
		Module[{downloadMonomers,unknownDownloadMonomerOligomerModels,unknownDownloadMonomerOligomerModelsObjects},
			(* Get the models that correspond to this error. *)
			unknownDownloadMonomerOligomerModels=PickList[oligomerModelPackets,unknownDownloadMonomerErrors];
			unknownDownloadMonomerOligomerModelsObjects=Lookup[unknownDownloadMonomerOligomerModels,Object];

			(* Get the relevant strands and then monomers*)
			downloadMonomers=DeleteDuplicates[
				Last[
					Monomers[
						First[
							ToStrand[Lookup[#,Molecule]]
						]
					]
				]&/@unknownDownloadMonomerOligomerModels];

			(* Throw the corresopnding error *)
			Message[Error::UnknownDownloadMonomer,ObjectToString[unknownDownloadMonomerOligomerModelsObjects],ToString[downloadMonomers]];

			(* Return our invalid options. *)
			{DownloadMonomer}
		],
		{}
	];

	(* Create the corresponding test for the unknownDownloadMonomerErrors if we're collecting tests *)
	unknownDownloadMonomerErrorsTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[myInputs,unknownDownloadMonomerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following input oligomer model(s), "<>ObjectToString[failingInputs,Cache->cache]<>", contain(s) download monomers for which a default is available, or DonwloadMonomer is provided:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following input oligomer model(s), "<>ObjectToString[passingInputs,Cache->cache]<>", contain(s) download monomers for which a default is available, or DonwloadMonomer is provided:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* If any of the unknownMonomerErrors returned True, then we need to throw an error for the respective strands here, also collect the InvalidOption *)
	unknownMonomerOptions=If[Or@@unknownMonomerErrors&&!gatherTests,
		Module[{unknownMonomerOligomerPackets,unknownMonomerOligomerModelsObjects,unknownMonomerLists,unknownMonomersFiltered,unknownMonomersFlat},
			(* Get the models that correspond to this error. *)
			unknownMonomerOligomerPackets=PickList[oligomerModelPackets,unknownMonomerErrors];
			unknownMonomerOligomerModelsObjects=Lookup[unknownMonomerOligomerPackets,Object];

			(* get the monomer lists that correspond to this error *)
			unknownMonomerLists=PickList[monomers,unknownMonomerErrors];

			(* map through the lists of monomers and filter for the ones that are unresolved (instead of a stock solution, there will be Null) *)
			(* this results in the  following list: {{{monomer,Null}..}..} *)
			unknownMonomersFiltered = Map[
				Function[{monomersOfStrand},
					Select[monomersOfStrand, #[[2]] == Null &]
				],
				unknownMonomerLists
			];

			(* make a flat list of unresolved monomers from this (since Monomers (the Option) is not indexmatched, it does not make sense here to keep this indexmatched to the samples either when throwing the error message *)
			unknownMonomersFlat = DeleteDuplicates[Flatten[unknownMonomersFiltered, 1][[All, 1]]];

			(* Throw the corresopnding error specifying which strand is the problematic one *)
			Message[Error::UnknownMonomer,ObjectToString[unknownMonomerOligomerModelsObjects],ToString[unknownMonomersFlat]];

			(* Return our invalid options. *)
			{Monomers}
		],
		{}
	];

	(* Create the corresponding test for the unknownMonomerErrors if we're collecting tests *)
	unknownMonomerErrorsTest=If[gatherTests,
		(* We're gathering tests. Create the appropriate tests. *)
		Module[{failingInputs,passingInputs,passingInputsTest,failingInputTest},
			(* Get the inputs that fail this test. *)
			failingInputs=PickList[myInputs,unknownMonomerErrors];

			(* Get the inputs that pass this test. *)
			passingInputs=Complement[myInputs,failingInputs];

			(* Create a test for the non-passing inputs. *)
			failingInputTest=If[Length[failingInputs]>0,
				Test["The following input oligomer model(s), "<>ObjectToString[failingInputs,Cache->cache]<>" contain(s) monomers for which a default is available, or Monomers is provided:",True,False],
				Nothing
			];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["The following input oligomer model(s), "<>ObjectToString[passingInputs,Cache->cache]<>" contain(s) monomers for which a default is available, or Monomers is provided:",True,True],
				Nothing
			];

			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputTest
			}
		],
		(* We aren't gathering tests. No tests to create. *)
		{}
	];

	resolvedResuspensionMixPrimitives=MapThread[
	(* If we're not cleaving, then this should be Null *)
		If[!#1,
			Null,
		(* If the mix type was resolved, then we know we need to construct our primitives *)
			If[!NullQ[#2],
			(* construct the primitive - importantly, we wrap them in a list, because if we were to provide primitives it would be listed as well *)
				If[MatchQ[#2,Sonicate|Vortex],
					{Mix[
						MixType->#2,
						Time->#3
					]},
					{Mix[
						MixType->#2,
						NumberOfMixes->#4
					]}
				],
			(* otherwise we know we can just use the primitive(s) that were provided *)
				#5
			]
		]&,
		{cleavages, resuspensionMixTypes,resuspensionMixTimes,numberOfResuspensionMixess,Lookup[allRoundedPNAOptionsAssociation, ResuspensionMixPrimitives]}];

	(* == check whether the resolved Primitives pass the ExperimentSampleManipulation call *)

	(* mapping over the samples, we make a list of manipulations that we can check with ValidExperimentSampleManipulationQ below *)
	reuspensionMixManipulationList=Map[Function[{primitives},
		If[NullQ[primitives],
			Null,
			Module[{heads,associations,associationsWithSample,primitivesWithSample,mixPrimitivesWithSample,definedResuspendedSample},

			(* extract the heads and the associations from the list of primitives *)
				heads=Head/@primitives;
				associations=First/@primitives;

				(* fix the primitives so we can call ExpSM below - pipette primitives need MaxVolume, and all primitives need Sample keys *)
				associationsWithSample=If[MatchQ[Lookup[#,MixType],Pipette],
					Prepend[#,{Sample->"My Container",MixVolume->0.5*Milliliter}],
					Prepend[#,{Sample->"My Container"}]
				]&/@associations;

				(* wrap the heads back around the associations to get a list of primitives *)
				mixPrimitivesWithSample=MapThread[#1[#2]&,{heads,associationsWithSample}];

				(* construct a Define and Transfer primitive that we can sneak into the list of manipulations *)
				definedResuspendedSample={
				(* we know the pelleted samples are always going to be in 50ml falcon tubes *)
					Define[
						Name -> "My Container",
						Container -> Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample,"Milli-Q water"],
						Destination -> "My Container",
						Amount -> 1 Milliliter
					]
				};

				(* combine the Define and Transfer primitives with the polished mix primitives *)
				Join[definedResuspendedSample,mixPrimitivesWithSample]

			]
		]],resolvedResuspensionMixPrimitives
	];

	(* Call ExperimentSampleManipulation to figure out whether our primitives are OK *)
	(* We only do this check if we haven't already thrown another resuspension or cleavage error *)
	{smOptions,smTests}=Transpose[Map[If[(NullQ[#]||Length[unneededResuspensionOptions]>0||Length[unneededCleavageOptions]>0),{Null,Null},
		If[gatherTests,
			Module[{options,tests},
				{options,tests}=ExperimentSampleManipulation[#,LiquidHandlingScale->MacroLiquidHandling,Output->{Options,Tests}
				];
				If[RunUnitTest[<|"Tests"->tests|>,OutputFormat->SingleBoolean,Verbose->False],
					{options,tests},
					{$Failed,tests}
				]
			],
			{
				Check[
					ExperimentSampleManipulation[#,LiquidHandlingScale->MacroLiquidHandling,Output->Options],
					$Failed
				],
				{}
			}
		]]&,reuspensionMixManipulationList]];

	incompatibleMixPrimitivesOptions=If[MemberQ[smOptions,$Failed]&&messages,
		Message[Error::IncompatibleResuspensionMixPrimitives,PickList[myInputs,smOptions,$Failed],PickList[resolvedResuspensionMixPrimitives,smOptions,$Failed]];
		{ResuspensionMixPrimitives},
		{}
	];

	(* If we are gathering tests, create tests with the appropriate results. *)
	incompatibleMixPrimitivesTest=If[gatherTests,

	(* We're gathering tests. Create the appropriate tests. *)
		Module[{nonPassingInputs,passingInputs,passingInputsTest,failingInputsTest},

		(* Get the inputs that pass this test. *)
			nonPassingInputs=If[!MemberQ[smOptions,$Failed],{},PickList[myInputs,smOptions,$Failed]];
			passingInputs=Complement[myInputs,nonPassingInputs];

			(* Create a test for the passing inputs. *)
			passingInputsTest=If[Length[passingInputs]>0,
				Test["For the inputs "<>ObjectToString[passingInputs,Cache->cache]<>", the primitives describing the mixing steps to resuspend the cleaved peptide strands are valid:",True,True],
				Nothing
			];
			(* Create a test for the non-passing inputs. *)
			failingInputsTest=If[Length[nonPassingInputs]>0,
				Test["For the inputs "<>ObjectToString[nonPassingInputs,Cache->cache]<>", the primitives describing the mixing steps to resuspend the cleaved peptide strands are valid:",True,False],
				Nothing
			];
			(* Return our created tests. *)
			{
				passingInputsTest,
				failingInputsTest
			}
		],
	(* We aren't gathering tests. No tests to create. *)
		{}
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteDuplicates[Flatten[{
		tooManyInputs,polymerTypeInputs,finalCapButNoFinalDeprotectionInputs
	}]];
	invalidOptions=DeleteDuplicates[Flatten[{
		unneededSwellOptions,
		unneededDownloadResinOptions,neededDownloadResinOptions,
		unneededCleavageOptions,neededCleavageOptions,
		unneededDeprotonationOptions,neededDeprotonationOptions,
		unneededMethanolShrinkOptions,unneededIsopropanolShrinkOptions,
		unneededStorageOptions,neededStorageOptions,
		unneededMethanolShrinkOptions,neededMethanolShrinkOptions,
		unneededIsopropanolShrinkOptions,neededIsopropanolShrinkOptions,
		unknowDownloadMonomerOptions,unknownMonomerOptions,
	(* option conflicts revolving around the Resin *)
		wrongResinOptions, needResinOptions, wrongDResinOptions, mismatchDResinOptions,
		unneededResuspensionOptions,
		incompatibleMixPrimitivesOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0,
		Message[Error::InvalidInput,ObjectToString[invalidInputs]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0,
		Message[Error::InvalidOption,invalidOptions]
	];

	(* === CONSTRUCT THE RESOLVED OTPIONS OR TESTS depending on the output specifiction === *)

	(* resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],email,If[And[upload, MemberQ[output, Result]],True,False]];

	(* resolve Operator so that we can use it for making operator resources later *)
	resolvedOperator=If[NullQ[operator],Model[User, Emerald, Operator, "Level 3"],operator];

	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* resolve the monomers: we don't need them indexmatched per sample, we just list them so need to flatten and delete duplicates *)
	resolvedMonomers=DeleteDuplicates[Flatten[monomers,1]];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result->Flatten[{{
			Instrument->instrument,
			SynthesisStrategy->synthesisStrategy,
			Scale->scales,
			TargetLoading->targetLoadings,
			Cleavage->cleavages,
			DownloadResin->downloadResins,
			Resin->resins,
			RecoupMonomers->recoupMonomers,
			InitialDeprotection->initialDeprotections,
			FinalDeprotection->finalDeprotections,
			Deprotonation->deprotonations,
			InitialCapping->initialCappings,
			FinalCapping->finalCappings,
			SwellResin->swellResins,
			SwellSolution->swellSolution,
			SwellTime->swellTimes,
			SwellVolume->swellVolumes,
			NumberOfSwellCycles->numberOfSwellCycless,
			WashSolution->washSolution,
			WashVolume->washVolumes,
			DeprotectionSolution->deprotectionSolution,
			DeprotectionVolume->deprotectionVolumes,
			DeprotectionTime->deprotectionTimes,
			NumberOfDeprotections->numberOfDeprotectionss,
			NumberOfDeprotectionWashes->numberOfDeprotectionWashess,
			DownloadDeprotectionVolume->downloadDeprotectionVolumes,
			DownloadDeprotectionTime->downloadDeprotectionTimes,
			NumberOfDownloadDeprotections->numberOfDownloadDeprotectionss,
			NumberOfDownloadDeprotectionWashes->numberOfDownloadDeprotectionWashess,
			DeprotonationSolution->deprotonationSolution,
			DeprotonationVolume->deprotonationVolumes,
			DeprotonationTime->deprotonationTimes,
			NumberOfDeprotonations->numberOfDeprotonationss,
			NumberOfDeprotonationWashes->numberOfDeprotonationWashess,
			DownloadDeprotonationVolume->downloadDeprotonationVolumes,
			DownloadDeprotonationTime->downloadDeprotonationTimes,
			NumberOfDownloadDeprotonations->numberOfDownloadDeprotonationss,
			NumberOfDownloadDeprotonationWashes->numberOfDownloadDeprotonationWashess,
			CappingSolution->cappingSolution,
			CappingVolume->cappingVolumes,
			CappingTime->cappingTimes,
			NumberOfCappings->numberOfCappingss,
			NumberOfCappingWashes->numberOfCappingWashess,
			DownloadCappingVolume->downloadCappingVolumes,
			DownloadCappingTime->downloadCappingTimes,
			NumberOfDownloadCappings->numberOfDownloadCappingss,
			NumberOfDownloadCappingWashes->numberOfDownloadCappingWashess,
			Monomers->resolvedMonomers,
			MonomerVolume->monomerVolumes,
			ActivationSolution->activationSolution,
			ActivationVolume->activationVolumes,
			ActivationTime->activationTimes,
			DownloadMonomer->downloadMonomers,
			DownloadMonomerVolume->downloadMonomerVolumes,
			DownloadActivationSolution->downloadActivationSolution,
			DownloadActivationVolume->downloadActivationVolumes,
			DownloadActivationTime->downloadActivationTimes,
			CouplingTime->couplingTimes,
			NumberOfCouplingWashes->numberOfCouplingWashess,
			DoubleCoupling->doubleCouplings,
			DownloadCouplingTime->downloadCouplingTimes,
			NumberOfDownloadCouplingWashes->numberOfDownloadCouplingWashess,
			CleavageSolution->cleavageSolution,
			CleavageVolume->cleavageVolumes,
			CleavageTime->cleavageTimes,
			NumberOfCleavageCycles->numberOfCleavageCycless,
			PrimaryResinShrink->methanolWashs,
			PrimaryResinShrinkSolution->methanol,
			PrimaryResinShrinkVolume->methanolWashVolumes,
			PrimaryResinShrinkTime->methanolWashTimes,
			SecondaryResinShrink->isopropanolWashs,
			SecondaryResinShrinkSolution->isopropanol,
			SecondaryResinShrinkVolume->isopropanolWashVolumes,
			SecondaryResinShrinkTime->isopropanolWashTimes,
			TriturationSolution->triturationSolution,
			TriturationVolume->triturationVolume,
			TriturationTime->triturationTime,
			NumberOfTriturationCycles->numberOfTriturationCycles,
			TriturationTemperature->triturationTemperature,
			ResuspensionBuffer->resuspensionBuffer,
			ResuspensionVolume->resuspensionVolumes,
			NumberOfResuspensionMixes->numberOfResuspensionMixess,
			ResuspensionMixPrimitives -> resolvedResuspensionMixPrimitives,
			ResuspensionMixType -> resuspensionMixTypes,
			ResuspensionMixTime -> resuspensionMixTimes,
			StorageBuffer->storageBuffer,
			StorageVolume->storageVolumes,
			SamplesOutStorageCondition->samplesOutStorageConditions,
			MonomerPreactivation->monomerPreactivations,
			Primitives->primitivess,
			Email->resolvedEmail,
			Name->name,
			FastTrack->fastTrack,
			Operator->resolvedOperator,
			Output->output,
			ParentProtocol->parentProtocol,
			Upload->upload,
			Template->template,
			Confirm->confirm
		},
			resolvedPostProcessingOptions
		}],
		Tests->Flatten[{
			tooManyInputsTest,polymerTypeTest,
			unneededSwellOptionsTest,
			unneededDeprotonationOptionsTest,neededDownloadResinOptionsTest,
			unneededDownloadResinOptionsTest,neededDownloadResinOptionsTest,
			unknownMonomerErrorsTest,unknownDownloadMonomerErrorsTest,
			unneededCleavageOptionsTest,neededCleavageOptionsTest,
			unneededMethanolShrinkOptionsTest,neededMethanolShrinkOptionsTest,
			unneededIsopropanolShrinkOptionsTest,neededIsopropanolShrinkOptionsTest,
			unneededStorageOptionsTest,neededStorageOptionsTest,
			finalCapButNoFinalDeprotectionTest,
			(* tests revolving around conflicting Resin specifiction *)
			wrongResinInvalidTests, needResinInvalidTests, wrongDResinInvalidTests, mismatchDResinTests,
		(* tests revolving around the resuspension primitives *)
			smTests,unneededResuspensionTest
		}]
	}
];


(* ::Subsubsection::Closed:: *)
(* pnaSynthesisResourcePackets (private helper)*)


DefineOptions[
	pnaSynthesisResourcePackets,
	Options:>{HelperOutputOption,CacheOption}
];

(* Private function to generate the list of protocol packets containing resource blobs needing for running the procedure *)
pnaSynthesisResourcePackets[
	myStrandModels:{ObjectP[Model[Sample]]...},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	myResourcePacketOptions:OptionsPattern[]
]:=Module[
	{outputSpecification,output,gatherTests,messages,operator,primitives,downloadResinOption,inheritedCache,downloadMonomers,
		downloadMonomerVolumes,strandModelPackets,oligomerMoleculePackets,
		maxBottleVolume,monomerDeadVolume,containerPackets,instrumentPackets,oligoObjects,
		strands,maxStrandLength,synthesisTimeEstimate,synthesisStrategy,downloadResins,deprotonations,initialDeprotections,
		finalDeprotections,finalCaps,synthesisMonomerPartitions,reagentPositions,synthesisMonomerResources,synthCount,
		cleavages,swells,monomerPreactivation,cleavedCount,nonCleavedCount,cleavageHappening,bulkMonomers,bulkMonomerVolumes,
		washVolumes,swellVolumes,swellTimes,methanolWashes,methanolWashVolumes,methanolWashTimes,isopropanolWashes,
		isopropanolWashVolumes,isopropanolWashTimes,cleavageVolumes,cleavageTimes,numberOfCleavageCyclesList,
		numberOfSwellCyclesList,washSolution,swellSolution,monomers,downloadActivationSolution,activationSolution,
		cappingSolution,deprotectionSolution,deprotonationSolution,methanol,isopropanol,cleavageSolution,
		recoupMonomersContainerResources,singleShotMonomerResource,downloadMonomerResources,resinAmounts,resinStates,resinPackets,
		resinByAmount,uniqueResinAmounts,resinResource,resinResourceIndexed,solventVessel,washSolventVolume,
		validTotalWashVolume,insufficientWashVolumeTest,washResource,cappingResource,deprotectionResource,
		activationID,activationResource,deprotonationResource,swellSolventVolume,swellResource,validTotalSwellVolume,
		insufficientSwellVolumeTest,cleavageResource,downloadActivationResource,methanolResource,isopropanolResource,
		containersOutResources,synthesizerResource,fumeHoodModels,fumeHoodResource,solventFumeHoodResource,cleavageFumeHoodResource,cleaningFumeHoodResource,
		vacuumManifoldResource,collectionVesselsResources,
		preactivationVesselsResources,neutralizerResource,reactionVesselsResources,uncleavedReactionVesselsResources,
		cleavedReactionVesselsResources,reactionVesselRackResource,numberOfCaps,septumCapsResource,stopcocksResources,
		triturationSolutionResource,storageSolutionResource,resuspensionBufferResource,triturationBeakerResource,
		cleaningSolutionsResources,bottleReplacements,protocolPacket,resourcePositions,allResources,fulfillable,frqTests,previewRule,
		optionsRule,testsRule,resultRule,synthesisPositions,collapsedFields,expandedFields,validNumberOfReagentPositions,
		validNumberOfReagentPositionsTest
	},

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* get the cache that was passed from the main function *)
	inheritedCache= Lookup[ToList[myResourcePacketOptions],Cache,{}];(* using the inherited cache, download the things we need to create our resource below *)

	{strandModelPackets,oligomerMoleculePackets,containerPackets,instrumentPackets,resinPackets}=Download[
		{
			myStrandModels,
			myStrandModels,
			{Model[Container,Vessel,"id:pZx9jonGJJB9"]},
			{Lookup[myResolvedOptions,Instrument]},
			Lookup[myResolvedOptions,Resin]
		},
		{
			{Packet[Object]},
			{Packet[Field[Composition[[All, 2]]][Molecule]]},
			{Packet[MaxVolume]},
			{Packet[DeadVolume]},
			{Packet[State]} (* both model and object resins have State always populated so we can safely download from whatever the resolved Resin option points to *)
		},
		Cache->inheritedCache,
		Date ->Now
	];

	(* look up some stuff from the download *)
	maxBottleVolume=FirstOrDefault[Lookup[Flatten[containerPackets],MaxVolume]];
	monomerDeadVolume=FirstOrDefault[Lookup[Flatten[instrumentPackets],DeadVolume]];
	oligoObjects=Lookup[Flatten[strandModelPackets],Object];
	strands=Flatten[ToStrand[#]&/@Lookup[Cases[Flatten[oligomerMoleculePackets], ObjectP[Model[Molecule, Oligomer]]],Molecule]];

	(* pull out a bunch of options *)
	{operator,primitives,downloadResinOption,synthesisStrategy,downloadResins,deprotonations,finalDeprotections,finalCaps,washVolumes,swellVolumes,swellTimes,methanolWashes,methanolWashVolumes,methanolWashTimes,isopropanolWashes,isopropanolWashVolumes,isopropanolWashTimes,cleavageVolumes,cleavageTimes,numberOfCleavageCyclesList,numberOfSwellCyclesList,washSolution,swellSolution,monomers,downloadMonomers,downloadActivationSolution,activationSolution,cappingSolution,deprotectionSolution,deprotonationSolution,methanol,isopropanol,cleavageSolution,cleavages,swells,monomerPreactivation}=Lookup[
		myResolvedOptions,
		{Operator,Primitives,DownloadResin,SynthesisStrategy,DownloadResin,Deprotonation,FinalDeprotection,FinalCapping,WashVolume,SwellVolume,SwellTime,PrimaryResinShrink,PrimaryResinShrinkVolume,PrimaryResinShrinkTime,SecondaryResinShrink,SecondaryResinShrinkVolume,SecondaryResinShrinkTime,CleavageVolume,CleavageTime,NumberOfCleavageCycles,NumberOfSwellCycles,WashSolution,SwellSolution,Monomers,DownloadMonomer,DownloadActivationSolution,ActivationSolution,CappingSolution,DeprotectionSolution,DeprotonationSolution,PrimaryResinShrinkSolution,SecondaryResinShrinkSolution,CleavageSolution,Cleavage,SwellResin,MonomerPreactivation}
	];

	(* NOTE: WHEN FIGURING OUT HOW MUCH OF STUFF TO MAKE RESOURCE FOR, USE THE PRIMITIVES AND NOT THE OPTIONS, SINCE THEY TAKE PRIORITY*)

	(* Find the length of the longest strand being made to help determine time to finish the synthesis *)
	maxStrandLength=Max[StrandLength[strands]];
	synthesisTimeEstimate=(1.5 Hour*maxStrandLength);

	(* information about the monomers *)
	synthCount=Length[myStrandModels];
	cleavedCount=Count[cleavages,True];
	nonCleavedCount=Count[cleavages,False];
	cleavageHappening = AnyTrue[cleavages,TrueQ];

	(* NOTE: WHEN FIGURING OUT HOW MUCH OF STUFF TO MAKE RESOURCE FOR, USE THE PRIMITIVES AND NOT THE OPTIONS, SINCE THEY TAKE PRIORITY*)

	(* get the download monomers, if downloading, then the 1st coupling primitive for each strand is the download *)
	{downloadMonomers,downloadMonomerVolumes}=Transpose[MapThread[
		If[#1,
			With[
				{downloadStep=FirstCase[Flatten[#2],_Coupling]},
				Lookup[Last[downloadStep],{Monomer,MonomerVolume}]
			],
			{Null,Null}
		]&,
		{downloadResinOption,primitives}
	]]/.Null:>Nothing;

	(* look at all the other Coupling primitives *)
	bulkMonomerVolumes=Flatten[MapThread[
		Function[{strandIndex,download,steps},
			Module[{onlyRelevantCoupling,monomerReagent,monomerVolume,numberOfCouplings},
				(* grab all coupling primitives (paying attention to whether downloading or not) *)
				(* get either all, or rest of coupling primtivies depending on whether there is a download *)
				onlyRelevantCoupling=With[
					{onlyCoupling=Cases[Flatten[steps],_Coupling]},
					If[download,Rest[onlyCoupling],onlyCoupling]
				];

				(* pull out the monomer and it's volume from each primitives*)
				monomerReagent=Map[#[Monomer]&,onlyRelevantCoupling];
				monomerVolume=Map[#[MonomerVolume]&,onlyRelevantCoupling];
				numberOfCouplings=Map[#[NumberOfReplicates]&,onlyRelevantCoupling];

				Transpose[{
					monomerReagent,
					Table[strandIndex,Length[onlyRelevantCoupling]],
					Range[1, Length[onlyRelevantCoupling]],
					monomerVolume*numberOfCouplings
				}]
			]
		],{Range[1,Length[myStrandModels]],downloadResinOption,primitives}
	],1];

	(* figure out where to put all the monomers - including the single shots (for download monomers) *)
	synthesisMonomerPartitions=partitionSynthesisMonomerVolumes[primitives,maxBottleVolume,monomerDeadVolume];

	(* == add up all the volumes of all the reagents and where they're going to g on the synth, will use this later to make all the resources == *)
	{reagentPositions,validNumberOfReagentPositions,validNumberOfReagentPositionsTest}=Module[{sameActivation,downloadActivationSolutionAdded,methanolAdded,isopropanolAdded,monomerPositions,solventPositions,primitivesAssociation,totalVolume,notEnoughPositions,neededMonomerPositions,neededNonMonomerPositionsm,validNumberOfAAPositions,validNumberOfAAPositionsTest,neededNonMonomerPositions},

		primitivesAssociation=Last[#]&/@Flatten[primitives];
		totalVolume[in_,field_]:=totalVolume[in,field,Volume];
		totalVolume[in_,field_,volumeField_]:=Module[{relevantPrimitives,neededValues},
			relevantPrimitives=Cases[primitivesAssociation,KeyValuePattern[{field->in}]];
			neededValues={
				Lookup[relevantPrimitives,volumeField],
				Lookup[relevantPrimitives,NumberOfReplicates,1]
			};
			Total[neededValues[[1]]*neededValues[[2]]]
		];

		(* determine if the activation and download activation are the same chemical and can be drawn from one bottle, or if they're different and will need two bottles *)
		sameActivation=SameObjectQ[activationSolution,downloadActivationSolution];

		(* if downloading, then add download activation solution to A26, but only if it's a different solution than the activation solution *)
		downloadActivationSolutionAdded=If[
			And[Not[NullQ[downloadActivationSolution]],Not[sameActivation]],
			Rule["AA26",Association["Reagent"->downloadActivationSolution[Object],"Amount"->totalVolume[activationSolution,Activator,ActivatorVolume],"Monomer"->False,"SingleShot"->False]],
			Nothing
		];

		(* if a methanol wash is happening, add methanol to AA27 position*)
		methanolAdded=If[Not[NullQ[methanol]],
			Rule["AA27",Association["Reagent"->methanol[Object],"Amount"->Max[totalVolume[methanol,Sample],100 Milliliter],"Monomer"->False,"SingleShot"->False]],
			Nothing
		];

		(* if isopropnal wash is happening, add isopropanl to AA28 position*)
		isopropanolAdded=If[Not[NullQ[isopropanol]],
			Rule["AA28",Association["Reagent"->isopropanol[Object],"Amount"->Max[totalVolume[isopropanol,Sample],100 Milliliter],"Monomer"->False,"SingleShot"->False]],
			Nothing
		];

		(* Assign a position to the monomers in the order in which they should go on the Symphony *)
		monomerPositions=Map[
			Rule[
				#[[4]],
				Association["Reagent"->#[[6]],"Amount"->#[[5]],"Monomer"->True,"SingleShot"->#[[3]]]
			]&,synthesisMonomerPartitions
		];

		(* list the positions required for monomers (including download monomers), and other solutions (like shrink solutions or download activation solution, if different from default *)
		neededMonomerPositions = DeleteDuplicates[Flatten[{Keys[monomerPositions]}]];
		neededNonMonomerPositions =Keys[Flatten[{downloadActivationSolutionAdded, methanolAdded, isopropanolAdded}]];

		(* we don't have enough positions if we have too many monomers, or if the positions the monomers grabbed are overlapping with the non-monomer solutions *)
		notEnoughPositions=Or[
			Length[neededMonomerPositions] > 28,
			Length[Intersection[neededMonomerPositions,	neededNonMonomerPositions]] > 0
		];

		(* show an error if we need more positions on the instrument then we have *)
		validNumberOfAAPositions =If[
			And[notEnoughPositions,Not[gatherTests]],
			Message[Error::TooManyMonomers]
		];

		(* if we're collecting tests, make sure to add one for too many AA position requred*)
		validNumberOfAAPositionsTest=If[gatherTests,
			Test[
				"The number of monomer positions needed to perform the synthesis cannot exceed the maximum number of positions available on the instrument",
				True,
				Not[notEnoughPositions]
			],
			{}
		];

		solventPositions={
			(* additional 15mL of wash solutiont of wash the PV as part of the preactivation process*)
			"SLVT1"->Association["Reagent"->washSolution[Object],"Amount"->Total[{
				(* for all washes*)
				totalVolume[washSolution,Sample],
				(* for preactivation vessel washes*)
				(15 Milliliter * Length[Cases[Flatten[primitives],_Coupling]]),
				(* for wash*)
				2000 Milliliter
			}]],
			"SLVT2"->Association["Reagent"->cappingSolution[Object],"Amount"->totalVolume[cappingSolution,Sample]],
			"SLVT3"->Association["Reagent"->deprotectionSolution[Object],"Amount"->totalVolume[deprotectionSolution,Sample]],
			"SLVT4"->Association["Reagent"->activationSolution[Object],"Amount"->totalVolume[activationSolution,Activator,ActivatorVolume]],
			(* Deprotonation is an optional step, skip this if the solution field isn't populated*)
			If[Not[NullQ[deprotonationSolution]],
				"SLVT5"->Association["Reagent"->deprotonationSolution[Object],"Amount"->totalVolume[deprotonationSolution,Sample]],
				Nothing
			],
			If[
				AnyTrue[swells,TrueQ],
				"SLVT7"->Association["Reagent"->swellSolution[Object],"Amount"->totalVolume[swellSolution,Sample]],
				Nothing
			],
			(* Cleavage is an optional step, skip this step if the solution field isn't populated*)
			If[AnyTrue[cleavages, TrueQ],
				"SLVT8"->Association["Reagent"->cleavageSolution[Object],"Amount"->totalVolume[cleavageSolution,Sample]],
				Nothing
			]
		};

		(* put it all together into an association and return to be used by the code the generates all of the program files *)
		{
			Association[Join[solventPositions,monomerPositions,{methanolAdded},{isopropanolAdded},{downloadActivationSolutionAdded}]],
			Not[notEnoughPositions],
			validNumberOfAAPositionsTest
		}
	];

	(* prepare the monomer resources, in order they will go on the synthesizer *)
	synthesisMonomerResources=Map[Link[
		Resource[
			Name->ToString[Unique[]],
			Sample->(Lookup[#,"Reagent"]),
			Amount->(Lookup[#,"Amount"]),
			Container->Model[Container,Vessel,"id:pZx9jonGJJB9"],
			RentContainer->True
		]
	]&,Cases[Values[reagentPositions],KeyValuePattern[{"Monomer" -> True, "SingleShot" -> False}]]
	];

	recoupMonomersContainerResources=If[
		Lookup[myResolvedOptions,RecoupMonomers],
		Table[Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Vessel,"50mL Tube"]]],Length[synthesisMonomerResources]],
		{}
	];

	(* prepare the DownloadMonomer resources (if any), these will go in single shot tubes *)
	singleShotMonomerResource=Map[
		Link[Resource[
			Name->ToString[Unique[]],
			Sample->(Lookup[#,"Reagent"]),
			Amount->(Lookup[#,"Amount"]),
			Container->Model[Container,Vessel,"id:pZx9jonGJJB9"],
			RentContainer->True
		]
		]&,
		Cases[Values[reagentPositions],KeyValuePattern[{"Monomer" -> True, "SingleShot" -> True}]]
	];

	(* check which state the resin is. We don't do slurry anymore but have to account for the possibility that the user may buy slurry resin in the future *)
	resinStates=Flatten[Lookup[#,State,Null]&/@resinPackets,1];

	(* prepare the resins resources *)
	(* figure how much resin will be needed for each synthesis (if not downloading, then we use a preloaded resin, which can be a slurry or a solid, else its solid resin*)
	resinAmounts=MapThread[Function[{scale,downloadResinBool,resinState},
	(* If we're not downloading, we use a preloaded resin. Check the state of the resin to determine whether we'll be looking for a volume or a mass (when finding resource) *)
		If[!downloadResinBool,
			If[MatchQ[resinState,Liquid],
				Unitless[scale,Micromole]*(11.25 Milli Gram)*((0.03 Milli Liter)/(1 Milli Gram)),
				Unitless[scale,Micromole]*(11.25 Milli Gram)
			],
		(* If we're downloading we will always start with a solid resin *)
			Unitless[scale,Micromole]*(11.25 Milli Gram)
		]],
		{Lookup[myResolvedOptions,Scale],Lookup[myResolvedOptions,DownloadResin],resinStates}
	];

	(* List of rules relating resin and volume needed for each strand *)
	resinByAmount=MapThread[#1->#2 &,{Lookup[myResolvedOptions,Resin],resinAmounts}];

	(* List of rules relating needed resins and corresponding volumes,pooled across identical resins *)
	uniqueResinAmounts=Merge[resinByAmount,Total];

	(* Make ProgramRequiredResource for each type of resin needed and 110% of the needed amount *)
	resinResource=Map[
		Link[Resource[Name->ToString[Unique[]],
			Sample->First[#],(* resin *)
			Amount->(1.1*Last[#]) (* 110% of needed amount*)
		]]&,
		Normal[uniqueResinAmounts]
	];

	(* Index matched list of RequiredResources matched to the index of each oligomer *)
	resinResourceIndexed=Lookup[myResolvedOptions,Resin]/.AssociationThread[Keys[uniqueResinAmounts],resinResource];

	(* helps determine which bottle we should use for the bulk reagents*)
	solventVessel[amount_]:=Switch[amount,
		LessEqualP[950 Milliliter],
		Model[Container, Vessel, "id:GmzlKjY5EEME"],
		GreaterP[950 Milliliter],
		Model[Container, Vessel, "id:Vrbp1jG800Zm"]
	];

	(* calculate the total wash solvent volume *)
	washSolventVolume=reagentPositions["SLVT1"]["Amount"];

	(* if the total volume exceeds 19 Liters, we set the error boolean and throw an error message but only if we're not collecting tests *)
	validTotalWashVolume=If[washSolventVolume> 19 Liter&&!gatherTests,
		Message[Error::InsufficientSolventVolume, washSolventVolume, washSolution, 19 Liter];
		False,
		True
	];

	(* If we're collecting tests, make the appropriate test *)
	insufficientWashVolumeTest=If[gatherTests,
		Test["The total volume of wash solvent needed, "<>ObjectToString[washSolution]<>", is less than can be currently loaded onto the synthesizer:",True,washSolventVolume < 19 Liter],
		Nothing
	];

	(*SLVT1, the extra 2L is for the clean at the end of the protocol *)
	washResource=Link[
		Resource[
			Name->ToString[Unique[]],
			Sample->washSolution,
			Amount->washSolventVolume,
			Container->If[washSolventVolume<=10 Liter,Model[Container,Vessel,"id:aXRlGnZmOOB9"],Model[Container,Vessel,"id:3em6Zv9NjjkY"]],
			RentContainer->True
		]
	];

	(*SLVT2*)
	cappingResource=With[{volume=(reagentPositions["SLVT2"]["Amount"])+(150 Milliliter)},
		Link[
			Resource[
				Name->ToString[Unique[]],
				Sample->cappingSolution,
				Amount->volume,
				Container->solventVessel[volume],
				RentContainer->True
			]
		]
	];

	(*SLVT3*)
	deprotectionResource=With[{volume=(reagentPositions["SLVT3"]["Amount"])+(225 Milliliter)},
		Link[
			Resource[
				Name->ToString[Unique[]],
				Sample->deprotectionSolution,
				Amount->volume,
				Container->solventVessel[volume],
				RentContainer->True
			]
		]
	];

	activationID=ToString[Unique[]];

	(*SLVT4*)
	activationResource=With[{volume=(reagentPositions["SLVT4"]["Amount"])+(150 Milliliter)},
		Link[
			Resource[
				Name->activationID,
				Sample->activationSolution,
				Amount->volume,
				Container->solventVessel[volume],
				RentContainer->True
			]
		]
	];

	(*SLVT5 - optional*)
	deprotonationResource = If[Not[NullQ[deprotonationSolution]],
		With[{volume=(reagentPositions["SLVT5"]["Amount"])+(150 Milliliter)},
			Link[
				Resource[
					Name->ToString[Unique[]],
					Sample->deprotonationSolution,
					Amount->volume,
					Container->solventVessel[volume],
					RentContainer->True
				]
			]
		],
		Null
	];

	(*SLVT7*)
	swellSolventVolume=If[
		MatchQ[swellSolution,Null],
		0 Milliliter,
		(reagentPositions["SLVT7"]["Amount"])+(600 Milliliter)
	];
	swellResource=If[MatchQ[swellSolution,Null],
		Null,
		Link[
			Resource[
				Name->ToString[Unique[]],
				Sample->swellSolution,
				Amount->swellSolventVolume,
				Container->solventVessel[swellSolventVolume],
				RentContainer->True
			]
		]
	];

	(* throw error if the total volume is above 4 Liters, but only if we're not collecting tests *)
	validTotalSwellVolume=If[swellSolventVolume> 4 Liter&&!gatherTests,
		Message[Error::InsufficientSolventVolume, swellSolventVolume, swellSolution, 4 Liter];
		False,
		True
	];

	(* If we're collecting tests, make the appropriate test *)
	insufficientSwellVolumeTest=If[gatherTests,
		Test["The total volume of swell solvent needed, "<>ObjectToString[swellSolution]<>", is less than can be currently loaded onto the synthesizer:",True,swellSolventVolume < 4 Liter],
		Nothing
	];


	(*SLVT8*)
	cleavageResource=If[cleavageHappening,
		Link[Resource[Name->ToString[Unique[]],
			Sample->cleavageSolution,
			Amount->reagentPositions["SLVT8"]["Amount"]+100 Milliliter,
			Container->Model[Container,Vessel,"id:GmzlKjY5EEME"],
			RentContainer->True
		]],
		Null
	];

	(*AA26*)
	(* if there a AA26 position, then pull out the volume for it (this will only have a thing if we're downloading AND it's a different solution then the bulk activation solution )*)
	downloadActivationResource=If[
		NullQ[downloadActivationSolution],
		Null,
		If[NullQ[Lookup[reagentPositions,"AA26", Null]],
			With[{volume=(reagentPositions["SLVT4"]["Amount"])+(150 Milliliter)},

				Link[Resource[
					Name->activationID,
					Sample->activationSolution,
					Amount->volume,
					Container->solventVessel[volume],
					RentContainer->True
				]
				]

			],
			With[{volume=(reagentPositions["AA26"]["Amount"])+(20 Milliliter)},

				Link[
					Resource[
						Name->ToString[Unique[]],
						Sample->downloadActivationSolution,
						Amount->volume,
						Container->Model[Container, Vessel, "id:pZx9jonGJJB9"],
						RentContainer->True
					]
				]

			]
		]
	];

	(*AA27*)
	methanolResource=If[AnyTrue[Lookup[myResolvedOptions,PrimaryResinShrink],TrueQ],
		Link[
			Resource[Name->ToString[Unique[]],
				Sample->methanol,
				Amount->Min[{(reagentPositions["AA27"]["Amount"])+(100 Milliliter), 400 Milliliter}],
				Container->Model[Container,Vessel,"400mL Reagent Bottle"],
				RentContainer->True
			]
		],
		Null
	];

	(*AA28*)
	(* since SecondaryResinShrink is multiple now, we check whether any of them is true *)
	isopropanolResource=If[AnyTrue[Lookup[myResolvedOptions,SecondaryResinShrink],TrueQ],
		Link[
			Resource[Name->ToString[Unique[]],
				Sample->isopropanol,
				Amount->(reagentPositions["AA28"]["Amount"])+(50 Milliliter),
				Container->Model[Container,Vessel,"400mL Reagent Bottle"],
				RentContainer->True
			]
		],
		Null
	];

	(* for strands that are not cleaved, we use 15mL tubes, for cleaved strands we use 50mL tubes (since the same as collection vessels) *)
	containersOutResources=Map[
		If[#,
			Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Vessel,"50mL Tube"]]],
			Link[Resource[Name->ToString[Unique[]],Sample->Model[Container, Vessel, "id:xRO9n3vk11pw"]]]
		]&,cleavages
	];

	(* collection vessels are the same Resources as the containerOut for all the cleaved strands *)
	collectionVesselsResources=PickList[containersOutResources,cleavages,True];

	(* find all the non-deprecated fume hood models *)
	fumeHoodModels=Search[Model[Instrument,FumeHood],Deprecated != True];

	synthesizerResource=Link[Resource[Name->ToString[Unique[]],Instrument->Lookup[myResolvedOptions,Instrument],Time->synthesisTimeEstimate]];

	fumeHoodResource=Link[Resource[Name->ToString[Unique[]],Instrument->fumeHoodModels,Time->2 Hour]];
	(* fume hood for checking the solvent bottles for damage *)
	solventFumeHoodResource=Link[Resource[Name->ToString[Unique[]],Instrument->fumeHoodModels,Time->15 Minute]];
	(* fume hood for checking the cleavage solution bottle for damage *)
	cleavageFumeHoodResource=Link[Resource[Name->ToString[Unique[]],Instrument->fumeHoodModels,Time->5 Minute]];
	(* fume hood for checking the cleaning solution bottles for damage *)
	cleaningFumeHoodResource=Link[Resource[Name->ToString[Unique[]],Instrument->fumeHoodModels,Time->5 Minute]];

	vacuumManifoldResource=If[ContainsAny[downloadResins,{False}],
		Link[Resource[Name->ToString[Unique[]],Instrument->Model[Instrument,VacuumManifold,"id:aXRlGnZmOdVm"],Time->15 Minute]],
		Null
	];

	preactivationVesselsResources=Map[
		If[MatchQ[#,ExSitu],
			Link[Resource[
				Name->ToString[Unique[]],
				Sample->Model[Container, ReactionVessel, SolidPhaseSynthesis, "id:XnlV5jmaK6ZN"]]
			],
			Null
		]&,monomerPreactivation
	];

	neutralizerResource=If[cleavageHappening,
		Link[Resource[Name->ToString[Unique[]],Sample->Model[Sample,"id:wqW9BP4Y0664"],Amount->45 Gram,Container->Model[Container, Vessel, "100 mL Glass Bottle"]]],
		Null
	];

	reactionVesselsResources=Table[Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,ReactionVessel,SolidPhaseSynthesis,"id:XnlV5jmaK6ZN"]]],synthCount];
	uncleavedReactionVesselsResources=Pick[reactionVesselsResources,cleavages,False];
	cleavedReactionVesselsResources=Pick[reactionVesselsResources,cleavages,True];

	reactionVesselRackResource=If[synthCount>=7,
		{
			Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Rack,"id:J8AY5jwEazxE"], Rent -> True]],
			Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Rack,"id:J8AY5jwEazxE"], Rent -> True]]
		},
		{Link[Resource[Name->ToString[Unique[]],Sample->Model[Container,Rack,"id:J8AY5jwEazxE"], Rent -> True]]}
	];


	(* as many as there are synth monomers + download monomers + iso + meth*)
	(* need to take AnyTrue for iso and meth since they are now multiple *)
	(* changed it from downloadMonomers to downloadMonomers was defined twice in the old code *)
	numberOfCaps=Total[
		{
			Length[synthesisMonomerResources],
			Length[singleShotMonomerResource],
			If[AnyTrue[Lookup[myResolvedOptions,SecondaryResinShrink],TrueQ],1,0],
			If[AnyTrue[Lookup[myResolvedOptions,PrimaryResinShrink],TrueQ],1,0]
		}
	];

	septumCapsResource=Table[Link[Resource[Name->ToString[Unique[]],Sample->Model[Item, Cap, "14/20 Joint Septum, Rubber"]]],numberOfCaps];

	stopcocksResources=Table[Link[Resource[Name->ToString[Unique[]],Sample->Model[Item,Consumable,"id:Z1lqpMGjeYo9"]]],synthCount];

	triturationSolutionResource=If[cleavageHappening,
		Link[
			Resource[
				Name->ToString[Unique[]],
				Sample->Lookup[myResolvedOptions,TriturationSolution],
				Amount->(Lookup[myResolvedOptions,TriturationVolume]*Lookup[myResolvedOptions,NumberOfTriturationCycles]*cleavedCount*1.2),
				RentContainer->True
			]
		],
		Null
	];

	storageSolutionResource=If[ContainsAny[cleavages,{False}],
		Link[Resource[
			Name->ToString[Unique[]],Sample->Lookup[myResolvedOptions,StorageBuffer],
			Amount->Total[DeleteCases[Lookup[myResolvedOptions,StorageVolume],Null]]*1.2,
			Container->Model[Container, Vessel, "500mL Glass Bottle"],
			RentContainer->True
		]
		],
		Null
	];

	resuspensionBufferResource = If[ContainsAny[cleavages,{True}],
		Link[Resource[
			Name->ToString[Unique[]],Sample->Lookup[myResolvedOptions,ResuspensionBuffer],
			Amount->Total[DeleteCases[Lookup[myResolvedOptions,ResuspensionVolume],Null]]*1.2,
			Container->Model[Container, Vessel, "50mL Tube"]
		]
		],
		Null
	];

	triturationBeakerResource = If[cleavageHappening,
		Link[Resource[
			Name->ToString[Unique[]],
			Sample->Model[Container,Vessel,"id:R8e1PjRDbbOv"],
			Rent->True]
		],
		Null
	];

	cleaningSolutionsResources ={
		Link[Resource[Name->ToString[Unique[]],
			Sample->Model[Sample, "Dichloromethane, Reagent Grade"],
			Container->Model[Container,Vessel,"Amber Glass Bottle 4 L"],
			Amount->2.1 Liter,
			RentContainer->True
		]],
		Link[Resource[Name->ToString[Unique[]],
			Sample->Model[Sample, "Dichloromethane, Reagent Grade"],
			Container->Model[Container,Vessel,"1L SymphonyX Bottle"],
			Amount->375 Milliliter,
			RentContainer->True
		]]
	};

	(* helper to sort strands into positions on the instrument *)
	sortStrands[primitives_,preactivations_,cleavages_]:=Module[{uniqueIDs,nonExSituPrimitives,cleanedPrimitives,primitivesWithoutCleavage,nonExSituIDs,taggedPrimitives,sortedPrimitives,groupStrands,groupings,exSituIDs,rvPositions,rvPositionsRules,pvrvPositions,pvrvPositionsRules},

		(*used to keep track of which strand is which *)
		uniqueIDs=Table[Unique[],Length[primitives]];

		(* because cleavages have a seperate program, we don't care about those when comparing between synths*)
		primitivesWithoutCleavage=MapThread[If[#2,Most[#1],#1]&,{primitives,cleavages}];

		(* get all the insitu primitives and ids and the exsitu ids*)
		nonExSituPrimitives=PickList[primitivesWithoutCleavage,preactivations,Alternatives[InSitu,None]];
		nonExSituIDs=PickList[uniqueIDs,preactivations,Alternatives[InSitu,None]];
		exSituIDs=PickList[uniqueIDs,preactivations,ExSitu];

		(* tag the primitives and sort them by length*)
		taggedPrimitives=MapThread[Rule[#1,#2]&,{nonExSituIDs,nonExSituPrimitives}];
		sortedPrimitives=Reverse[SortBy[taggedPrimitives, Length[Values[#]]&]];

		(*will need to sanitize these a bit since them monomer chemical in the coupling
		primitives doesn't matter when comparing between synths *)
		cleanedPrimitives=sortedPrimitives/.{Coupling[d_]:>Coupling[KeyDrop[d,Monomer]]};

		(*entry into the recursive function*)
		groupStrands[]:=groupStrands[{},cleanedPrimitives];
		(*exit from the recursive function*)
		groupStrands[done_,{}]:=done;

		(*
			bin strands into groups based on their prefix similairy
			we're comparing the longest strand to the next longest (or same length) strand, if the part at which they overlap
			at is the same (using hash), they they could be made in tandem
		*)
		groupStrands[done_,toDo_]:=Module[{longest,rest,compatibleMatches},
			(* split toDo into longest and rest*)
			(* this is the one we're trying to find a mate for *)
			longest=First[toDo];
			(* this is the pool from which we can find a mate*)
			rest=Rest[toDo];

			(*now see if the longest has a match by comparing hashes, make sure that if the strand from rest is shorter then
			the longest strand that we trim the longest to match in length *)
			compatibleMatches=Map[
				MatchQ[
					Hash[Take[Values[longest],Length[Values[#]]]],
					Hash[Values[#]]
				]&,
				rest
			];

			(* act differently depending if we found a mate or not... *)
			If[
				AnyTrue[compatibleMatches,TrueQ],
				(*if we did find a matching pair, group it with the longest, then drop it from the rest list *)
				With[{position=First[Position[compatibleMatches,True]]},
					groupStrands[
						Join[done,{Flatten[{longest,Take[rest,position]}]}],
						Drop[rest,position]
					]
				],
				(* if we couldn't find a match, then make this a singelton and pass on the rest to be grouped*)
				groupStrands[
					Join[done,{{longest}}],
					rest
				]
			]
		];

		(*run the recursion here, at the end we only care about the tag IDs*)
		groupings=Keys[#]&/@groupStrands[];

		(*take as my RV positions as we have ExSitu synths*)
		rvPositions=Take[Map["RV"<>ToString[#]&,Range[1,12]],Length[exSituIDs]];

		(*assing an RV positions to each exsitu synth*)
		rvPositionsRules=MapThread[Rule[#1,#2]&,{exSituIDs,rvPositions}];

		(*prep tandem pv-rv positions for all remaining tandem sites*)
		pvrvPositions=Map[{"RV"<>ToString[#],"PV"<>ToString[#]}&,Range[Length[exSituIDs]+1,12]];

		(* assigning all the positions:
		 - for ExSitu, you get the RV position and PV is used for preactivation
		 - for InSitu/None, RV/PV can be used in tandem
		 - if all the InSitu can fit in just the RV position we'll do that since it will cut down on instrument time
		*)
		pvrvPositionsRules=If[Length[Flatten[groupings]]<=Length[pvrvPositions],
			MapThread[
				Rule[#1,#2]&,
				{
					Flatten[groupings],
					Take[pvrvPositions,Length[Flatten[groupings]]][[All, 1]]
				}
			],
			MapThread[
				If[
					(* if it's a pair, assign the RV-PV pair*)
					MatchQ[#1,{_,_}],
					{Rule[#1[[1]],#2[[1]]],Rule[#1[[2]],#2[[2]]]},
					(* else just the RV*)
					Rule[#1[[1]],#2[[1]]]
				]&,
				{
					groupings,
					Take[pvrvPositions,Length[groupings]]
				}
			]
		];

		uniqueIDs/.Flatten[{rvPositionsRules,pvrvPositionsRules}]
	];

	synthesisPositions=sortStrands[
		primitives,
		Lookup[myResolvedOptions,MonomerPreactivation],
		cleavages
	];

	(* this named multiple holds all of the samples that are going to be hooked up in the symphony cabinet that we want to check for bottle damage *)
	bottleReplacements=MapThread[
		If[!NullQ[#1],
			<|Sample->#1,Container->Null,Destination->Null,Funnel->Null,FumeHood->#2|>,
			Nothing
		]&,
		{
			Flatten[{cappingResource,deprotectionResource,deprotonationResource,activationResource,swellResource,cleavageResource,cleaningSolutionsResources}],
			Flatten[{Table[solventFumeHoodResource,5],cleavageFumeHoodResource,Table[cleaningFumeHoodResource,Length[cleaningSolutionsResources]]}]
		}
	];

	(* == Construct the protocol packet == *)

	(* put together the protocol packet *)
	protocolPacket=Association[
		Type->Object[Protocol,PNASynthesis],
		Object->CreateID[Object[Protocol,PNASynthesis]],
		Author->Link[$PersonID,ProtocolsAuthored],
		Replace[ContainersOut]->containersOutResources,
		Replace[SamplesOutStorage] -> Lookup[myResolvedOptions, SamplesOutStorageCondition],
	(* Strand models *)
		Replace[StrandModels]->(Link[#]&/@oligoObjects),
		Replace[Strands]->strands,
		Replace[CleavedStrandModels]->Link[PickList[oligoObjects,cleavages,True]],
		Replace[UncleavedStrandModels]->Link[PickList[oligoObjects,cleavages,False]],
		Replace[DownloadedStrandModels]->Link[PickList[oligoObjects,downloadResins,True]],
		(* cycle related *)
		Replace[Primitives]->primitives,
		Replace[Scale]->Lookup[myResolvedOptions,Scale],
		Replace[TargetLoadings]->Lookup[myResolvedOptions,TargetLoading],
		SynthesisStrategy->Lookup[myResolvedOptions,SynthesisStrategy],
		RunTime->synthesisTimeEstimate,
		RecoupMonomers->Lookup[myResolvedOptions,RecoupMonomers],
		Replace[InitialCapping]->Lookup[myResolvedOptions,InitialCapping],
		Replace[FinalCapping]->Lookup[myResolvedOptions,FinalCapping],
		Replace[DoubleCouplings]->Lookup[myResolvedOptions,DoubleCoupling],
		Replace[InitialDeprotection]->Lookup[myResolvedOptions,InitialDeprotection],
		Replace[FinalDeprotection]->Lookup[myResolvedOptions,FinalDeprotection],
		Replace[Deprotonation]->Lookup[myResolvedOptions,Deprotonation],
		Replace[Cleavage]->cleavages,
		Replace[DownloadResins]->downloadResins,
		Replace[MonomerPreactivations]->Lookup[myResolvedOptions,MonomerPreactivation],
		Replace[SwellResin]->Lookup[myResolvedOptions,SwellResin,{}],
		Replace[CleavageVolumes]->cleavageVolumes,
		Replace[CleavageTimes]->cleavageTimes,
		Replace[NumbersOfCleavageCycles]->numberOfCleavageCyclesList,
		Replace[SwellTimes]->swellTimes,
		Replace[SwellVolumes]->swellVolumes,
		Replace[NumbersOfSwellCycles]->numberOfSwellCyclesList,
		Replace[PrimaryResinShrinks]->Lookup[myResolvedOptions,PrimaryResinShrink,{}],
		Replace[PrimaryResinShrinkVolumes]->methanolWashVolumes,
		Replace[PrimaryResinShrinkTimes]->methanolWashTimes,
		Replace[SecondaryResinShrinks]->Lookup[myResolvedOptions,SecondaryResinShrink,{}],
		Replace[SecondaryResinShrinkVolumes]->isopropanolWashVolumes,
		Replace[SecondaryResinShrinkTimes]->isopropanolWashTimes,
		Replace[SynthesisPositions]->synthesisPositions,
		Replace[BatchLengths]->(Length[#]&/@PartitionRemainder[PickList[oligoObjects,cleavages,True], 12]),

		(* Trituration or Storage *)
		TriturationVolume->Lookup[myResolvedOptions,TriturationVolume,Null],
		TriturationTime->Lookup[myResolvedOptions,TriturationTime,Null],
		TriturationTemperature->Lookup[myResolvedOptions,TriturationTemperature,Null],
		NumberOfTriturationCycles->Lookup[myResolvedOptions,NumberOfTriturationCycles,Null],
		TriturationCentrifugationTime->If[NullQ[Lookup[myResolvedOptions,NumberOfTriturationCycles,Null]],Null,5 Minute],
		TriturationCentrifugationRate->If[NullQ[Lookup[myResolvedOptions,NumberOfTriturationCycles,Null]],Null,3000 RPM],
		TriturationCentrifugationForce->If[NullQ[Lookup[myResolvedOptions,NumberOfTriturationCycles,Null]],Null,2050 GravitationalAcceleration],
		Replace[NumbersOfResuspensionMixes]->Lookup[myResolvedOptions,NumberOfResuspensionMixes,{}],
		Replace[ResuspensionMixPrimitives] -> Lookup[myResolvedOptions,ResuspensionMixPrimitives,{}],
		Replace[ResuspensionVolumes]-> DeleteCases[Lookup[myResolvedOptions,ResuspensionVolume,{}],Null],
		Replace[StorageVolumes]->DeleteCases[Lookup[myResolvedOptions,StorageVolume,{}],Null],

		(* RESOURCES -- These are the created resource blobs *)
		Replace[Resin]->resinResourceIndexed,
		WashSolution->washResource,
		CappingSolution->cappingResource,
		DeprotectionSolution->deprotectionResource,
		DeprotonationSolution->deprotonationResource,
		ActivationSolution->activationResource,
		DownloadActivationSolution->downloadActivationResource,
		SwellSolution->swellResource,
		CleavageSolution->cleavageResource,
		PrimaryResinShrinkSolution->methanolResource,
		SecondaryResinShrinkSolution->isopropanolResource,
		Replace[BottleReplacements]->bottleReplacements,

		Replace[SynthesisMonomers]->synthesisMonomerResources,
		Replace[DownloadMonomers]->singleShotMonomerResource,
		Replace[RecoupedMonomersContainers]->recoupMonomersContainerResources,

		Instrument->synthesizerResource,
		FumeHood->fumeHoodResource,
		VacuumManifold->vacuumManifoldResource,

		Replace[CollectionVessels]->collectionVesselsResources,
		Replace[PreactivationVessels]->preactivationVesselsResources,
		Neutralizer->neutralizerResource,
		Replace[ReactionVessels]->reactionVesselsResources,
		Replace[ReactionVesselRacks]->reactionVesselRackResource,
		Replace[UncleavedReactionVessels]->uncleavedReactionVesselsResources,
		Replace[CleavedReactionVessels]->cleavedReactionVesselsResources,
		Replace[SeptumCaps]->septumCapsResource,

		Replace[ReactionVesselStopcocks]->stopcocksResources,
		TriturationSolution->triturationSolutionResource,

		StorageSolution->storageSolutionResource,
		ResuspensionBuffer->resuspensionBufferResource,
		TriturationBeaker->triturationBeakerResource,
		Replace[CleaningSolutions]->cleaningSolutionsResources,

		UnresolvedOptions->RemoveHiddenOptions[ExperimentPNASynthesis,myUnresolvedOptions],
		ResolvedOptions->RemoveHiddenOptions[ExperimentPNASynthesis,myResolvedOptions],
		Replace[Checkpoints]->{
			{"Picking Resources",1 Hour,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> operator,Time -> 2 Day]]},
			{"Preparing Synthesizer",4 Hour,"A synthesizer is configured for the protocol and all required samples placed on deck.", Link[Resource[Operator -> operator,Time -> 4 Hour]]},
			{"Synthesizing",synthesisTimeEstimate,"Oligomers are synthesized.", Link[Resource[Operator -> operator,Time -> synthesisTimeEstimate]]},
			{"Cleaving",12 Hour,"Oligomers are cleaved from their solid resin supports.", Link[Resource[Operator -> operator,Time -> 12 Hour]]},
			{"Triturating",12 Hour,"Crude oligomers are washed with solvent,pelleted,and the supernatant is removed.", Link[Resource[Operator -> operator,Time -> 12 Hour]]},
			{"Resuspending",4 Hour,"The oligomers are resuspened in buffer.", Link[Resource[Operator -> operator,Time -> 4 Hour]]},
			{"Sample Post-Processing",45 Minute,"Any measuring of volume,weight,or sample imaging post experiment is performed.", Link[Resource[Operator -> operator,Time -> 45 Minute]]},
			{"Cleaning Up Materials",12 Hour,"The synthesizer deck is cleared,and the samples are put into storage.", Link[Resource[Operator -> operator,Time -> 12 Hour]]}
		}

	];

	resourcePositions=Position[protocolPacket,_Resource];
	allResources=Extract[protocolPacket,resourcePositions];


	messages=True;
	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = If[gatherTests,
		Resources`Private`fulfillableResourceQ[allResources, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site]],
		{Resources`Private`fulfillableResourceQ[allResources, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages], Null}
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Rule[Preview,Null];

	(* generate the options output rule *)
	optionsRule = Rule[Options,
		If[
			MemberQ[output, Options],
			RemoveHiddenOptions[ExperimentPNASynthesis,myResolvedOptions],
			Null
		]
	];
	(* generate the tests rule *)
	testsRule = Rule[
		Tests,
		If[gatherTests,Cases[Flatten[Join[frqTests,{insufficientWashVolumeTest},{insufficientSwellVolumeTest},{validNumberOfReagentPositionsTest}]], _EmeraldTest],Null]
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Rule[
		Result,
		If[
			And[
				MemberQ[output, Result],
				TrueQ[fulfillable],
				TrueQ[validTotalSwellVolume],
				TrueQ[validTotalWashVolume],
				TrueQ[validNumberOfReagentPositions]
			],
			protocolPacket,
			$Failed
		]
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule,resultRule,testsRule}

];


(* ::Subsubsection::Closed:: *)
(*partitionSynthesisMonomerVolumes *)

Authors[partitionSynthesisMonomerVolumes]:={"alou", "robert", "waltraud.mair"};
partitionSynthesisMonomerVolumes[myPrimitives_,myTargetVolume:VolumeP,myDeadVolume:VolumeP]:=Module[
	{grouping,solvedKnapsacks,knapsacksFlat,knapsackWBottle,monomerBreakdown,bulkMonomers,singleShotMonomers,knapsackNumber,groupedBulkMonomers},

	monomerBreakdown=Flatten[
		MapIndexed[
			Function[{steps,strandIndex},
				Module[{onlyCoupling,onlyRelevantCoupling,monomerReagent,monomerVolume,singleShot,numberOfReplicates},
					(* grab all coupling primitives (paying attention to whether downloading or not) *)
					(* get either all, or rest of coupling primtivies depending on whether there is a download *)
					onlyCoupling=Last[#]&/@Cases[Flatten[steps],_Coupling];
					(* pull out the monomer and it's volume from each primitives*)
					{monomerReagent,monomerVolume,singleShot,numberOfReplicates}=Transpose[
						Lookup[onlyCoupling,{Monomer,MonomerVolume,SingleShot,NumberOfReplicates}]
					];
					Transpose[{
						monomerReagent,
						singleShot,
						Table[First[strandIndex],Length[onlyCoupling]],
						Range[0, Length[onlyCoupling]-1],
						monomerVolume*numberOfReplicates
					}]
				]
			],myPrimitives
		],1];

	bulkMonomers=Cases[monomerBreakdown,{_,False,_,_,_}];
	singleShotMonomers=Cases[monomerBreakdown,{_,True,_,_,_}];

	(* group things by momomer model {obj->{strandIndx, monomer index, volume}..}*)
	grouping=GroupBy[bulkMonomers,First->Rest];

	(* for each monomer, knapsack solve it {{obj->{knap1, knap2}..}*)
	solvedKnapsacks=Map[
		Function[{in},
			Module[{groupedByAddition},
				(* group things so that we can knapsack it*)
				groupedByAddition=Map[{{#[[1]],#[[2]],#[[3]]},#[[4]]}&,in];
				GroupByTotal[groupedByAddition,myTargetVolume-myDeadVolume]
			]
		],grouping
	];

	(* flatted it out so we can assign bottles {{obj1, knap1},{obj1, kanp2}, {obj2, kanp3}}*)
	knapsacksFlat=Flatten[Map[
		Function[{in},
			Map[
				{in,#}&,
				solvedKnapsacks[in]
			]
		],Keys[solvedKnapsacks]
	],1];

	(* assign a bottle index to each knapsack {{bottle, object, knapsack, totalvolumeinbottle}..} *)
	knapsackWBottle=MapIndexed[
		Function[{kanpsackForMonomerModel, index},
			{
				"AA"<>ToString[First[index]],
				kanpsackForMonomerModel[[1]],
				kanpsackForMonomerModel[[2]],
				Total[kanpsackForMonomerModel[[2]][[All,-1]]]
			}
		],
		knapsacksFlat
	];

	(* determine the number of knaspack, this+1 is the bottle for 1st single shot *)
	knapsackNumber=Length[knapsacksFlat];

	(* flatted in all once more to get {{strand index, monomer index, singleShot, bottle, model, volume in bottle}..}*)
	groupedBulkMonomers=Flatten[
		Map[
			Function[{in},
				Map[
					{#[[1]][[2]], #[[1]][[3]], False, in[[1]], in[[4]]+myDeadVolume, in[[2]]} &,
					in[[3]]
				]
			],knapsackWBottle
		],1
	];

	(* add on any single shot monomers*)
	singleShotMonomers=MapIndexed[
		{#1[[3]],#1[[4]],#1[[2]],"AA"<>ToString[First[#2]+knapsackNumber],#1[[5]],#1[[1]]}&,
		singleShotMonomers
	];

	Join[groupedBulkMonomers,singleShotMonomers]

];


(* ::Subsection::Closed:: *)
(*ValidExperimentPNASynthesisQ*)


DefineOptions[ValidExperimentPNASynthesisQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentPNASynthesis}
];

Authors[ValidExperimentPNASynthesisQ]={"alou", "robert", "waltraud.mair", "paul"};

(* multiple strands core function *)
ValidExperimentPNASynthesisQ[myInputs:ListableP[Alternatives[ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],SequenceP,StrandP,StructureP]], myOptions:OptionsPattern[ValidExperimentPNASynthesisQ]]:=Module[
	{listedOptions, preparedOptions, pnaTests, initialTestDescription, allTests, verbose, outputFormat, listedSamples},

	(* get the options and the input as a list *)
	(* also get the samples as a list *)
	listedOptions = ToList[myOptions];
	listedSamples = ToList[myInputs];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentPNASynthesis *)
	pnaTests = ExperimentPNASynthesis[listedSamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";
	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[pnaTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings, testResults,isSampleQ},
		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];
			isSampleQ = MatchQ[#,ObjectP[]]&/@listedSamples;
			(* create warnings for invalid objects *)
			validObjectBooleans = MapThread[
				If[#1,
					ValidObjectQ[Download[#2, Object], OutputFormat -> Boolean],
					Null
				]&,{isSampleQ,listedSamples}
			];
			voqWarnings = MapThread[
				If[#3,
					Warning[StringJoin[ObjectToString[Download[#1,Object]], " is valid (run ValidObjectQ for more detailed information):"],
						#2,
						True
					],
					Null
				]&,
				{listedSamples, validObjectBooleans,isSampleQ}
			];
			(* get all the tests/warnings *)
			Cases[Flatten[{initialTest, pnaTests, voqWarnings}],_EmeraldTest]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentPNASynthesisQNew, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	(* do NOT use the symbol here because that will force RunUnitTest to call the SymbolSetUp/SymbolTearDown for this function's unit tests  *)
	Lookup[RunUnitTest[<|"ValidExperimentPNASynthesisQNew" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentPNASynthesisQNew"]
];


(* ::Subsection::Closed:: *)
(*ExperimentPNASynthesisOptionsNew*)


DefineOptions[ExperimentPNASynthesisOptions,
	SharedOptions :> {ExperimentPNASynthesis},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* single strand overload *)
Authors[ExperimentPNASynthesisOptions]={"alou", "robert", "waltraud.mair", "paul"};

(* multiple strands core function *)
ExperimentPNASynthesisOptions[myInputs:ListableP[Alternatives[ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],SequenceP,StrandP,StructureP]], myOptions:OptionsPattern[ExperimentPNASynthesisOptions]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for ExperimentPNASynthesis *)
	options = ExperimentPNASynthesis[myInputs, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentPNASynthesis],
		options
	]
];



(* ::Subsection::Closed:: *)
(*ExperimentPNASynthesisPreviewNew*)


DefineOptions[ExperimentPNASynthesisPreview,
	SharedOptions :> {ExperimentPNASynthesis}
];

Authors[ExperimentPNASynthesisPreview]={"alou", "robert", "waltraud.mair", "paul"};

(* multiple strands core function *)
ExperimentPNASynthesisPreview[myInputs:ListableP[Alternatives[ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],SequenceP,StrandP,StructureP]], myOptions:OptionsPattern[ExperimentPNASynthesisPreview]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	ExperimentPNASynthesis[myInputs, Append[noOutputOptions, Output -> Preview]]

];


(* Make a singleton overload *)
singletonValidSynthesisStepQ[myCycle:Alternatives[_Washing,_Swelling,_Capping,_Deprotecting,_Deprotonating,_Coupling,_Cleaving], myOptions:OptionsPattern[]]:=ValidSynthesisStepQ[{myCycle}, myOptions];
singletonValidSynthesisStepQ[___]:=False;

ValidSynthesisStepQ[myCycle:Alternatives[_Washing,_Swelling,_Capping,_Deprotecting,_Deprotonating,_Coupling,_Cleaving], myOptions:OptionsPattern[]]:=ValidSynthesisStepQ[{myCycle}, myOptions];
ValidSynthesisStepQ[myCycles:{Alternatives[_Washing,_Swelling,_Capping,_Deprotecting,_Deprotonating,_Coupling,_Cleaving]..}, myOptions:OptionsPattern[]]:=Module[
	{objects,uniqueObjects,objectStates,prepareTests,tests},
	(* single download to get all the info needed for all the tests *)
	objects=Lookup[Last[#]&/@myCycles,{Sample,Base,Preactivator,Monomer,Activator}];
	uniqueObjects=Cases[DeleteDuplicates[Flatten[objects]],ObjectP[]];
	(* We make a packet with the State. We use the State of the very first entry inside the composition. If we have multiple we simply assume that we're synthesising the first one (we can't synthesize more than one oligomer) *)
	(* Note that we have to construct an association for the Model[Sample] - we can't just use the packet from the identity model since further down we look for the "Sample" which is not an identity model but the actual Model[Sample] used *)
	objectStates=MapThread[<|Object->#1,State->FirstOrDefault[#2]|>&,{Download[uniqueObjects,Object],Download[uniqueObjects,Field[Composition[[All,2]]][State], Date->Now]}];
	(* function to prepare tests for all the cycles*)
	prepareTests[in_]:=Module[{stepType,stepMatter,selectedPattern},
		(*determine the type of synthesis step*)
		stepType=Head[in];
		stepMatter=KeyDrop[Last[in],{Preactivate,Preactivation,SingleShot}];
		(* select the pattern to use for this rescoues *)
		selectedPattern=Switch[stepType,
			Swelling,SwellingP,
			Washing,WashingP,
			Capping,CappingP,
			Deprotecting,DeprotectingP,
			Deprotonating,DeprotonatingP,
			Coupling,CouplingP,
			Cleaving,CleavingP
		];
		tests=Switch[stepType,
			Alternatives[Swelling,Washing,Capping,Deprotecting,Deprotonating,Cleaving],
			{
				Test["The cycle step has to match the appropriate pattern:",
					AssociationMatchQ[stepMatter, selectedPattern],
					True
				],
				Test["The sample has to have a liquid State:",
					MatchQ[
						Lookup[FirstCase[objectStates,KeyValuePattern[Object -> Lookup[stepMatter,Sample][Object]]],State],
						Liquid
					],
					True
				]
			},
			Coupling,
			Module[{allowedKeys,trimmedPattern},
				(* pull out all keys that can be used with this step *)
				allowedKeys=Keys[selectedPattern];
				(* based on the actual keys in the step, trim down the pattern for matching*)
				trimmedPattern=KeyDrop[KeyDrop[selectedPattern,Complement[allowedKeys,Keys[in]]],{Preactivate,Preactivation,SingleShot}];
				{
					Test["The cycle step has to match the appropriate pattern:",
						AssociationMatchQ[stepMatter, trimmedPattern],
						True
					],
					If[
						Not[NullQ[Lookup[stepMatter,Activator, Null]]],
						Test["The activator has to have a liquid State:",
							MatchQ[
								Lookup[FirstCase[objectStates,KeyValuePattern[Object -> Lookup[stepMatter,Activator][Object]]],State],
								Liquid
							],
							True
						],
						Nothing
					],
					If[Not[NullQ[Lookup[stepMatter,Activator, Null]]],
						Test["If Activator key is present, ActivatorVolume key also needs to be present:",
							Lookup[stepMatter,ActivatorVolume, Null],
							Except[NullP]
						],Nothing
					]
				}
			]
		]
	];
	(*run the tests using the usual testing function *)
	RunValidQTest[
		myCycles,
		{prepareTests},
		PassOptions[ValidSynthesisStepQ,RunValidQTest,myOptions]
	]
];


(* ::Subsubsection::Closed:: *)
(*assignReagentPositions*)


(*
	THIS HELPER IS NOT NEEDED ANYMORE SINCE WE ARE USING PRIMITIVES, BUT IT IS USEFUL TO CALCULATE THE POSITIONS OF ALL SOLUTIONS


	assigns a solvent to a specific position, used to prepare the symphony files and by the symphony volume calculator
	assigns a monomer or download monomer to a specific position, used to prepare the symphony files and by the symphony volume calculator

	INPUT:
		myPacket: the protocol packet for which the positions should be assigned
	OUTPUT:
		association that connects a position on the symphony buffer and synthesis decks to the sample that's going to be place there
		==> (solvents (SLVT positions) and monomers (AA positions)

	Note:
	- SLVT1 always has to have the wash solution since it's the main metal solvent tank
	- SLVT8 always has to have the cleave solution since that line can only be primed during cleavage (so that the harsh chemicals don't sit in there during the whole synth)
	- AAs are always dynamically assigned except for AA27 and AA28 which have the two alcohols (methanol/isopropanol) for final washes, and AA26 in case we have download acitivation that is different from default
	*)

Authors[assignReagentPositions]:={"alou","waltraud.mair","paul"};
assignReagentPositions[myPacket:PacketP[Object[Protocol,PNASynthesis]]]:=Module[
	{allReagentPositions,monomers,downloadMonomers,bulkMonomerPositions,singleShotMonomerPositions,numberPositionsFilled,solventPositions,methanol,isopropanol,downloadActivationSolution,activationSolution,sameActivation},

	(* pull the info on the protocol objects, which is all the bulk monomers, single shot monomers and the two alcohols *)
	monomers=myPacket[SynthesisMonomers];

	downloadMonomers=DeleteCases[Lookup[myPacket,DownloadMonomers],Null];
	methanol=Lookup[myPacket,PrimaryResinShrinkSolution];
	isopropanol=Lookup[myPacket,SecondaryResinShrinkSolution];

	activationSolution=Lookup[myPacket,ActivationSolution];
	downloadActivationSolution=Lookup[myPacket,DownloadActivationSolution];

	sameActivation=SameObjectQ[activationSolution,downloadActivationSolution];

	(* if downloading, then add download activation solution to A26, but only if it's a different solution than the activation solution *)
	downloadActivationSolution=If[
		And[Not[NullQ[downloadActivationSolution]],Not[sameActivation]],
		Rule["AA26",Association["Reagent"->downloadActivationSolution[Object],"SingleShot"->False]],
		Nothing
	];

	(* if a methanol wash is happening, add methanol to AA27 position*)
	methanol=If[Not[NullQ[methanol]],
		Rule["AA27",Association["Reagent"->methanol[Object],"SingleShot"->False]],
		Nothing
	];

	(* if isopropnal wash is happening, add isopropanl to AA28 position*)
	isopropanol=If[Not[NullQ[isopropanol]],
		Rule["AA28",Association["Reagent"->isopropanol[Object],"SingleShot"->False]],
		Nothing
	];

	(* Assign a position to the monomers in the order in which they should go on the Symphony *)
	bulkMonomerPositions=MapIndexed[
		Rule[
			StringJoin["AA",ToString[First[#2]]],
			Association["Reagent"->#1[Object],"SingleShot"->False]
		]&,monomers
	];

	(* how many positions have been filled so far by bulk monomers*)
	numberPositionsFilled=Length[bulkMonomerPositions];

	(* The monomer that are going to be in single shot tubes, in the order they're listed in the protocol *)
	singleShotMonomerPositions=MapIndexed[
		Rule[
			"AA" <> ToString[First[#2] + numberPositionsFilled],
			Association["Reagent"->#1[Object],"SingleShot"->True]
		]&,downloadMonomers
	];

	solventPositions={
		"SLVT1"->Association["Reagent"->myPacket[WashSolution][Object]],
		"SLVT2"->Association["Reagent"->myPacket[CappingSolution][Object]],
		"SLVT3"->Association["Reagent"->myPacket[DeprotectionSolution][Object]],
		"SLVT4"->Association["Reagent"->myPacket[ActivationSolution][Object]],
		(* Deprotonation is an optional step, skip this if the solution field isn't populated*)
		If[Not[NullQ[myPacket[DeprotonationSolution]]],
			"SLVT5"->Association["Reagent"->myPacket[DeprotonationSolution][Object]],
			Nothing
		],
		"SLVT7"->Association["Reagent"->myPacket[SwellSolution][Object]],
		(* Cleave is an optional step, skip this step if the solution field isn't populated*)
		If[AnyTrue[myPacket[Cleavage], TrueQ],
			"SLVT8"->Association["Reagent"->myPacket[CleavageSolution][Object]],
			Nothing
		]
	};

	(* put it all together into an association and return to be used by the code the generates all of the program files *)
	Association[Join[solventPositions,bulkMonomerPositions,singleShotMonomerPositions,{methanol},{isopropanol},{downloadActivationSolution}]]
];