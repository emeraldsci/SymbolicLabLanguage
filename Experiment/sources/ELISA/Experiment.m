(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentELISA Primitives*)
installELISAPrimitives[]:={

	installELISAWashPlatePrimitive[];
	installELISAReadPlatePrimitive[];
	installELISAIncubatePlatePrimitive[];
};
installELISAPrimitives[];
Unprotect/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
OverloadSummaryHead/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
Protect/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
(* ensure that reloading the package will re-initialize primitive generation *)
OnLoad[
	installELISAPrimitives[];
	Unprotect/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
	OverloadSummaryHead/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
	Protect/@{ELISAReadPlate,ELISAWashPlate,ELISAIncubatePlate};
];

(*Primitive images*)
elisaWashPlateIcon[]:=swellIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ELISAWashPlate.png"}]];
elisaIncubatePlateIcon[]:=swellIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ELISAIncubatePlate.png"}]];
elisaReadPlateIcon[]:=swellIcon[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ELISAReadPlate.png"}]];

(*Install primitives*)
installELISAWashPlatePrimitive[]:=MakeBoxes[summary:ELISAWashPlate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	ELISAWashPlate,
	summary,
	elisaWashPlateIcon[],
	{
		If[MatchQ[assoc[Sample],_Missing], Nothing, BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[WashVolume],_Missing],Nothing,BoxForm`SummaryItem[{"WashVolume: ",assoc[WashVolume][[1]]}]],
		If[MatchQ[assoc[NumberOfWashes],_Missing],Nothing,BoxForm`SummaryItem[{"Number Of Washes ",assoc[NumberOfWashes][[1]]}]]
	},
	StandardForm
];


installELISAIncubatePlatePrimitive[]:=MakeBoxes[summary:ELISAIncubatePlate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	ELISAIncubatePlate,
	summary,
	elisaIncubatePlateIcon[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[IncubationTime],_Missing],Nothing,BoxForm`SummaryItem[{"Incubate Time: ",assoc[IncubationTime]}]],
		If[MatchQ[assoc[IncubationTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"Incubate Temperature: ",assoc[IncubationTemperature]}]],
		If[MatchQ[assoc[ShakingFrequency],_Missing],Nothing,BoxForm`SummaryItem[{"Shaking Frequency: ",assoc[ShakingFrequency]}]]
	},
	StandardForm
];

installELISAReadPlatePrimitive[]:=MakeBoxes[summary:ELISAReadPlate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	ELISAReadPlate,
	summary,
	elisaReadPlateIcon[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[MeasurementWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Measurement Wavelength: ",assoc[MeasurementWavelength]}]],
		If[MatchQ[assoc[ReferenceWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Reference Wavelength: ",assoc[ReferenceWavelength]}]],
		If[MatchQ[assoc[DataFilePath],_Missing],Nothing,BoxForm`SummaryItem[{"Data File Path: ",assoc[DataFilePath]}]]
	},
	StandardForm
];


(* ::Subsection::Closed:: *)
(*ExperimentELISA Options*)

DefineOptions[ExperimentELISA,
	Options:>{

		(*===============================================*)
		(*============MATERIAL PREPARATION===============*)
		(*===============================================*)

		(* ================Experiment Method================ *)
		{
			OptionName->Method,
			Default->DirectELISA,
			Description->"Defines the type of ELISA experiment to be performed. Types include DirectELISA, IndirectELISA, DirectSandwichELISA, IndirectSandwichELISA, DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA. Compared with the Direct methods where the primary antibody is conjugated with an enzyme (such as Horse Radish Peroxidase/HRP or Alkaline Phosphatas/AP) for detection, in all Indirect methods a secondary antibody is, instead, conjugated with this enzyme. In Indirect methods, an additional step of SecondaryAntibody incubation is added to the corresponding Direct methods. In a DirectELISA experiment, the Sample is coated on the ELISAPlate, and then a primary antibody is used to detect the target antigen. In a DirectSandwichELISA experiment, a capture antibody is coated onto the ELISAPlate to pull down the target antigen from the sample. Then a primary antibody is used to detect the target antigen. In a DirectCompetitiveELISA experiment, a reference antigen is used to coat the ELISAPlate. Samples are incubated with the primary antibody. Then, when the Sample-Antibody-Complex solution is loaded on the ELISAPlate, the remaining free primary antibody binds to the reference antigen. In a FastELISA experiment, a coating antibody against a tag is coated to the ELISAPlate. A capture antibody containing this tag and a primary antibody for antigen detection is incubated with the sample to form a CaptureAntibody-TargetAntigen-PrimaryAntibody complex. Then this complex is pulled down by the coating antibody to the surface of the plate (See Figure 1.1).",
			Category->"General",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>ELISAMethodP
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->TargetAntigen,
				Default->Automatic,
				Description->"The Analyte molecule (e.g., peptide, protein, and hormone) detected and quantified in the samples by Antibodies in the ELISA experiment. This option is used to automatically set sample Antibodies and the corresponding experiment conditions of Standards and Blanks.",
				ResolutionDescription->"Automatically set to the Model[Molecule] in the Analyte field of the sample.",
				Category->"General",
				AllowNull->True,
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Molecule]}]
				]
			}
		],
		{
			OptionName->NumberOfReplicates,
			Default->Automatic,
			Description->"The number of times an ELISA assay will be repeated in parallel wells. Samples, Standards, or Blanks will be loaded this number of times in the plates. Replications are conducted at the same time, and if possible, in the same ELISAPlate. If set to Null, each Sample, Standard, or Blank will be assayed once.",
			ResolutionDescription->"Automatically set to 2 unless method is DirectELISA or IndirectELISA and Coating is False, in which case it is set to Null.",
			Category->"General",
			AllowNull->True,
			Widget->Widget[
				Type->Number,
				Pattern:>RangeP[2,192,1]
			]
		},
		{
			OptionName->WashingBuffer,
			Default->Model[Sample, StockSolution, "Phosphate Buffered Saline with 0.05% TWEEN 20, pH 7.4"],
			Description->"The solution used to rinse off unbound molecules from the assay plate.",
			AllowNull->False,
			Category->"General",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},



		IndexMatching[
			IndexMatchingInput->"experiment samples",

			(*===========SampleSpiking and dilution==========*)
			{
				OptionName->Spike,
				Default->Null,
				Description->"The sample with a known concentration of analyte. Spike is to be mixed with the input sample. The purpose of spiking is to perform a spike-and-recovery assessment to determine whether the ELISA can accurately test the concentration of analyte within the context of the sample. If the recovery observed for the spiked sample is identical to the analyte prepared in standard diluent, the sample is considered not to interfere with the assay. For example, if molecules in the sample inhibits the binding between the antibody and TargetAntigen, the results from the ELISA becomes inaccurate. In a Spike-and-Recovery experiment,an aliquot of a sample is mixed with Spike. ELISA is performed on the Sample alone (also called Neat Sample) and the Spiked Sample at the same time, where the Spike concentration in the sample can be measured. This measured Spike concentration can be then compared with the known Spike concentration. Typically a 20% difference between measured Spike concentration and the known Spike concentration is acceptable. Spiked sample can be further diluted to perform linearity-of-dilution assessment. The plate used for sample spiking and dilution will be discarded after the experiment.",
				AllowNull->True,
				Category->"Sample Assembly",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->SpikeDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio by which the Spike is mixed with the input sample before further dilution is performed.",
				ResolutionDescription->"Automatically set to 0.1 if Spike is not Null.",
				AllowNull->True,
				Category->"Sample Assembly",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->SpikeStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of spike should be stored.",
				ResolutionDescription->"Automatically set to Refrigerator if Spike is not Null.",
				AllowNull->True,
				Category->"Sample Assembly",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},
			{
				OptionName->SampleSerialDilutionCurve,
				Default->Automatic,
				Description->"The collection of serial dilutions that will be performed on each sample: if spiking was performed, the dilution will be performed on the spiked sample; otherwise, the dilutions will be performed on the sample. This Linearity-of-Dilution step assesses whether the ELISA experiment can reliably measure TargetAntigen concentration at different concentration ranges. For example, a sample with TargetAntigen concentration of 100ng/ul, if diluted 1:2, 1:4, and 1:8, should yield ELISA measurements of 50ng/ul, 25ng/ul, and 12.5ng/ul (or should follow a concentration ratio of 4:2:1). Typically a 20% difference between the measured and expected concentrations is considered acceptable. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor should be 1 or Diluent Volume should be 0 Microliter to include the original sample. For example, if a Spike-and-Recovery assay is to be performed, the first dilution factor must be 1 in order to include the original spiked sample. During experiment, an 5% extra volume than specified is going to be prepared in order to offset pipetting errors. Therefore, the total volume for each well specified in this option should be equal or greater than the volume needed for the experiment. Because the dilution of each assay (well) is prepared independently, the Number of Replications should not be considered when determining the Spike Volume. The plate used for sample dilutions will be discarded after the experiment. Note: if spike or antibodies are to be mixed with samples, their volumes are counted towards diluent volume.",
				ResolutionDescription->"The option is automatically set Null if or a SampleDilutionCurve is specified.",
				AllowNull->True,
				Category->"Sample Assembly",
				Widget->Alternatives[
					"Serial Dilution Factor"->
						{
							"Assay Volume"->Widget[Type->Quantity,Pattern:>RangeP[10 Microliter,1500Milliliter],Units->{1,{Microliter,{Microliter}}}],
							"Dilution Factors" ->
								Alternatives[
									"Constant"->{"Constant Dilution Factor" ->
										Widget[Type->Number, Pattern :> RangeP[0, 1]],
										"Number Of Dilutions" ->
											Widget[Type->Number, Pattern :> GreaterP[0, 1]]},
									"Variable" ->
										Adder[Widget[Type->Number, Pattern :> RangeP[0, 1]]]]
						},
					"Serial Dilution Volumes"->
						{
							"Transfer Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Number Of Dilutions"->Widget[Type->Number,Pattern :> GreaterP[0,1]]
						}

				]
			},
			{
				OptionName->SampleDilutionCurve,
				Default->Automatic,
				Description->"The collection of dilutions that will be performed on each sample: the dilutions will be performed on the sample. Spiked samples should only be further diluted with serial dilution. This Linearity-of-Dilution step assesses whether the ELISA experiment can reliably measure TargetAntigen concentration at different concentration ranges. For example, a sample with TargetAntigen concentration of 100ng/ul, if diluted 1:2, 1:4, and 1:8, should yield ELISA measurements of 50ng/ul, 25ng/ul, and 12.5ng/ul (or should follow a concentration ratio of 8:4:2:1). Typically a 20% difference between the measured and expected concentrations is considered acceptable. Linearity-of-Dilution experiment can be done with Spiked or non-Spiked samples. For Fixed Dilution Volume Dilution Curves, the Spike Amount is the volume of the sample that will be mixed the Diluent Volume of the Diluent to create a desired concentration. The Assay Volume is the TOTAL volume of the sample that will be created after being diluted by the Dilution Factor. IMPORTANT: because the dilution curve does not intrinsically include the original sample, in the case of sample dilution the first diluting factor must be 1, or Diluent Volume should be 0 to include the original sample. During experiment, an 5% extra volume than specified is going to be prepared in order to offset pipetting errors. Therefore, the total volume for each well specified in this option should be equal or greater than the volume needed for the experiment. Because the dilution of each assay (well) is prepared independently, the Number of Replications should not be considered when determining the Spike Volume. The plate used for sample dilutions will be discarded after the experiment. Note: if spike or antibodies are to be mixed with samples, their volumes are counted towards diluent volume.",
				ResolutionDescription->"The option is automatically set Null if or a SampleSerialDilutionCurve is specified.",
				AllowNull->True,
				Category->"Sample Assembly",
				Widget->Alternatives[
					"Fixed Dilution Factor"->Adder[
						{
							"Assay Volume"->Widget[Type->Quantity,Pattern:>RangeP[10 Microliter,1500Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Dilution Factor"->Widget[Type->Number,Pattern:>RangeP[0,1]]
						}
					],
					"Fixed Dilution Volume"->Adder[
						{
							"Sample Amount"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}]
						}
					]
				]
			}
		],
		{
			OptionName->SampleDiluent,
			Default->Automatic,
			Description->"The buffer used to perform multiple dilutions of samples or spiked samples.",
			ResolutionDescription->"If SampleDilutionCurve and SampleSerialDilutionCurve are not both Null, in the case when Method is set to DirectELISA and IndirectELISA, the option is automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"]; in all other cases, the option is automatically set to Model[Sample,\"ELISA Blocker Blocking Buffer\"].",
			AllowNull->True,
			Category->"Sample Assembly",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},



		(*============Antibody Antigen Preparation==============*)
		(* Error if user force not null on hidden Antibodies.
				IF Method == DirectELISA      THEN  show PrimaryAntibody.                       Others Null out.
				IF Method == IndirectELISA    THEN  show PrimaryAntibody  && SecondaryAntibody. Others Null out.
				IF Method == SandwichELISA    THEN  show CaptureAntibody  && PrimaryAntibody.   Others Null out.
				IF Method == CompetitiveELISA THEN  show ReferenceAntigen && PrimaryAntibody.   Others Null out.
				IF Method == FastELISA         THEN show CaptureAntibody  && PrimaryAntibody.   Others Null out.
				*)

		(* Coating Antibody *)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->CoatingAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used for coating in FastELISA.",
				ResolutionDescription->"If Method is FastELISA, automatically set to an antibody against a tag which is conjugated to a the CaptureAntibody.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->CoatingAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of CoatingAntibody. CoatingAntibody is diluted with CoatingAntibodyDiluent. Either CoatingAntibodyDilutionFactor or CoatingAntibodyVolume should be provided but not both.",
				ResolutionDescription->"Automatically set to 0.001 (1:1,000) for FastELISA.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->CoatingAntibodyVolume,
				Default->Null,
				Description->"The volume of undiluted CoatingAntibody added into the corresponding well of the assay plate. CoatingAntibody is diluted with CoatingAntibodyDiluent. CoatingAntibodyVolume is used as an alternative to CoatingAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->CoatingAntibodyDiluent,
			Default->Automatic,
			Description->"The buffer used to dilute CoatingAntibodies.",
			ResolutionDescription->"If Method is set to FastELISA, the option is automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"].",
			AllowNull->True,
			Category->"Antibody Antigen Preparation",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->CoatingAntibodyStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Coating Antibody stock sample should be stored.",
				ResolutionDescription->"Automatically set to Refrigerator if Method is set to FastELISA.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Capture Antibody *)
			{
				OptionName->CaptureAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used to pull down the antigen from sample solution to the surface of the assay plate wells in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA.",
				ResolutionDescription->"If Method is FastELISA, automatically set to an antibody containing an affinity tag and against the TargetAntigen. If Method is DirectSandwichELISA or IndirectSandwichELISA, automatically set to an un-tagged antibody against TargetAntigen.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->CaptureAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of CaptureAntibody. For DirectSandwichELISA and IndirectSandwichELISA, CaptureAntibody is diluted with CaptureAntibodyDiluent. For FastELISA, CaptureAntibody is diluted in the corresponding sample. Either CaptureAntibodyDilutionFactor or CaptureAntibodyVolume should be provided but not both.",
				ResolutionDescription->"For DirectSandwichELISA and IndirectSandwichELISA, automatically set to 0.001 (1:1,000). For FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->CaptureAntibodyVolume,
				Default->Null,
				Description->"The volume of undiluted CaptureAntibody added into the corresponding well of the assay plate. CaptureAntibodyVolume is used as an alternative to CaptureAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->CaptureAntibodyDiluent,
			Default->Automatic,
			Description->"The buffer used to dilute CaptureAntibodies. Set to Null when CapturaAntibody should be diluted into samples (in FastELISA).",
			ResolutionDescription->"If Method is set to DirectSandwichELISA or IndirectSandwichELISA, the option is automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"].",
			AllowNull->True,
			Category->"Antibody Antigen Preparation",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",

			{
				OptionName->CaptureAntibodyStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Capture Antibody stock sample should be stored.",
				ResolutionDescription->"If Method is set to DirectSandwichELISA, IndirectSandwichELISA, or FastELISA, Automatically set to Refrigerator.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Reference Antigen *)
			{
				OptionName->ReferenceAntigen,
				Default->Automatic,
				Description->"The sample containing the antigen that is used in DirectCompetitiveELISA or IndirectCompetitiveELISA. The ReferenceAntigen competes with TargetAntigen in the samples for the binding of the PrimaryAntibody. Reference Antigen is also referred to as Inhibitor Antigen.",
				ResolutionDescription->"Automatically set to a sample containing known amount of TargetAntigen when Method is set to DirectCompetitiveELISA or IndirectCompetitiveELISA.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->ReferenceAntigenDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of ReferenceAntigen. The ReferenceAntigenSample is always diluted in ReferenceAntigenDiluent. Either ReferenceAntigenDilutionFactor or ReferenceAntigenVolume should be provided but not both.",
				ResolutionDescription->"If Method is DirectCompetitiveELISA or IndirectCompetitiveELISA, automatically set to 0.001 (1:1,000).",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->ReferenceAntigenVolume,
				Default->Null,
				Description->"The volume of undiluted ReferenceAntigen added into the corresponding well of the assay plate. ReferenceAntigenVolume is used as an alternative to ReferenceAntigenDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->ReferenceAntigenDiluent,
			Default->Automatic,
			Description->"The buffer used to dilute the ReferenceAntigen.",
			ResolutionDescription->"Method is DirectCompetitiveELISA and IndirectCompetitiveELISA, the option is automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"].",
			AllowNull->True,
			Category->"Antibody Antigen Preparation",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},

		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->ReferenceAntigenStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Reference Antigen stock sample should be stored.",
				ResolutionDescription->"Automatically set to Refrigerator if Method is DirectCompetitiveELISA and IndirectCompetitiveELISA.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Primary Antibody *)
			{
				OptionName->PrimaryAntibody,
				Default->Automatic,
				Description->"The antibody that directly binds with the TargetAntigen (analyte).",
				ResolutionDescription->"The option will be automatically set to an antibody against the TargetAntigen.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->PrimaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of PrimaryAntibody. For DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, the antibody is diluted with PrimaryAntibodyDiluent. For DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA, the antibody is diluted with the corresponding sample. Either PrimaryAntibodyDilutionFactor or PrimaryAntibodyVolume should be provided but not both.",
				ResolutionDescription->"If used for DirectELISA, IndirectELISA, DirectSandwichELISA, IndirectSandwichELISA, automatically set to 0.001 (1:1,000). If used for DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->PrimaryAntibodyVolume,
				Default->Null,
				Description->"The volume of undiluted PrimaryAntibody added into the corresponding well of the assay plate. PrimaryAntibodyVolume is used as an alternative to PrimaryAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->PrimaryAntibodyDiluent,
			Default->Automatic,
			Description->"The buffer used to dilute the PrimaryAntibody.Set to Null when PrimaryAntibody should be diluted into samples (in DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA).",
			ResolutionDescription->"If Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, IndirectSandwichELISA, the options will be automatically set to Model[Sample,\"ELISA Blocker Blocking Buffer\"].",
			AllowNull->True,
			Category->"Antibody Antigen Preparation",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->PrimaryAntibodyStorageCondition,
				Default->Refrigerator,
				Description->"The condition under which the unused portion of PrimaryAntibody stock sample should be stored.",
				AllowNull->False,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Secondary Antibody *)
			{
				OptionName->SecondaryAntibody,
				Default->Automatic,
				Description->"The antibody that binds to the primary antibody.",
				ResolutionDescription->"If Method is IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA, the option is automatically set to a stocked secondary antibody for the primary antibody. ",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName -> SecondaryAntibodyDilutionFactor,
				Default -> Automatic,
				Description -> "The dilution ratio of SecondaryAntibody. SecondaryAntibody is always diluted in the SecondaryAntibodyDiluent. For example, if SecondaryAntibodyDilutionFactor is 0.8 and SecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted SecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				ResolutionDescription -> "For IndirectELISA, IndirectSandwichELISA, IndirectCompetitiveELISA, automatically set to 0.001 (1:1,000).",
				AllowNull -> True,
				Category -> "Antibody Antigen Preparation",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0,1]
				]
			},
			{
				OptionName -> SecondaryAntibodyVolume,
				Default -> Automatic,
				Description -> "The volume of SecondaryAntibody added into the SampleAssemblyPlate during dilution to prepare a master mix. For example, if SecondaryAntibodyDilutionFactor is 0.8 and SecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted SecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				ResolutionDescription -> "If SecondaryAntibodyDilutionFactor is specified, automatically set to 1.1*SecondaryAntibodyDilutionFactor*SecondaryAntibodyImmunosorbentVolume.",
				AllowNull -> True,
				Category -> "Antibody Antigen Preparation",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 200 Microliter],
					Units -> Alternatives[Microliter]
				]
			}
		],
		{
			OptionName -> SecondaryAntibodyDilutionOnDeck,
			Default -> Automatic,
			Description -> "Indicates whether the SecondaryAntibody and SecondaryAntibodyDiluent are mixed prior to being added to the assay plate(s) on deck during the immunosorbent step instead of during sample assembly. Currently, due to the limited deck space on NIMBUS, we do not allow SecondaryAntibodyDilutionOnDeck is set to True when Coating is also set to True. If SecondaryAntibodyDilutionOnDeck is set to False, SecondaryAntibody dilution is performed before blocking step.",
			ResolutionDescription -> "Automatically set to False for indirect ELISA methods when any SecondaryAntibodyDilutionFactor is specified.",
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Antibody Antigen Preparation"
		},
		{
			OptionName->SecondaryAntibodyDiluent,
			Default->Automatic,
			Description->"The buffer used to dilute SecondaryAntibody.",
			ResolutionDescription->"If Method is set to IndirectELISA, IndirectSandwichELISA, IndirectCompetitiveELISA, the option will automatically set to Model[Sample,\"ELISA Blocker Blocking Buffer\"].",
			AllowNull->True,
			Category->"Antibody Antigen Preparation",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SecondaryAntibodyStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Secondary Antibody stock sample should be stored.",
				ResolutionDescription->"If method is IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA, the option is automatically set to Refrigerator.",
				AllowNull->True,
				Category->"Antibody Antigen Preparation",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			}
		],


		(*===============================================*)
		(*==========EXPERIMENTAL PROCEDURE===============*)
		(*===============================================*)



		(*==========Antibody Complex Incubation==============*)
		{
			OptionName->SampleAntibodyComplexIncubation,
			Default->Automatic,
			Description->"Indicates if the pre-mixed samples and antibodies should be incubated before loaded into the assay plate. The plate used for sample-antibody mixing will be discarded after the experiment.",
			ResolutionDescription->"Automatically set to True if Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA.",
			AllowNull->False,
			Category->"Sample Antibody Complex Incubation",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[BooleanP]
			]
		},
		{
			OptionName->SampleAntibodyComplexIncubationTime,
			Default->Automatic,
			Description->"The duration of sample-antibody complex incubation (If needed). In DirectCompetitiveELISA and IndirectCompetitiveELISA, PrimaryAntibody is incubated with the sample. In FastELISA, PrimaryAntibody and CaptureAntibody is incubated with the sample. If Null, the prepared sample-antibody complex will be kept at 4 degree Celsius till ready to use.",
			ResolutionDescription-> "If the Method is set to  DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 2 Hours.",
			AllowNull->True,
			Category->"Sample Antibody Complex Incubation",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->SampleAntibodyComplexIncubationTemperature,
			Default->Automatic,
			Description->"The temperature at which sample mixed with Antibodies are incubated. In DirectCompetitiveELISA and IndirectCompetitiveELISA, PrimaryAntibody is incubated with the sample. In FastELISA, PrimaryAntibody and CaptureAntibody are incubated with the sample. If Null, the prepared sample-antibody complex will be used directly.",
			ResolutionDescription-> "If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to Ambient.",
			AllowNull->True,
			Category->"Sample Antibody Complex Incubation",
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient]
				],
				Widget[
					Type->Quantity,
					Pattern:>RangeP[4Celsius,50Celsius],
					Units->Alternatives[Celsius]
				]
			]
		},

		(*============Coating==============*)


		{
			OptionName->Coating,
			Default->True,
			Description->"Indicates if Coating is required. Coating is a procedure to non-specifically adsorb protein molecules to the surface of wells of the assay plate.",
			AllowNull->False,
			Category->"Coating",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[BooleanP]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleCoatingVolume,
				Default->Automatic,
				Description->"The amount of Sample that is aliquoted into the assay plate, in order for the Sample to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectELISA or IndirectELISA, CoatingVolume is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Coating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},

			{
				OptionName->CoatingAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted CoatingAntibody that is aliquoted into the assay plate, in order for the CoatingAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is FastELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Coating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,300 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->ReferenceAntigenCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted ReferenceAntigen that is aliquoted into the assay plate, in order for the ReferenceAntigen to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectCompetitiveELISA or IndirectCompetitiveELISA, CoatingVolume is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Coating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->CaptureAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted CaptureAntibody that is aliquoted into the assay plate, in order for the CaptureAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectSandwichELISA or IndirectSandwichELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Coating",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->CoatingTemperature,
			Default->Automatic,
			Description->"The temperature at which the Coating Solution is kept in the assay plate, in order for the coating molecules to be adsorbed to the surface of the well.",
			ResolutionDescription->"If Coating is set to True, the option is automatically set to 4 degree Celsius.",
			AllowNull->True,
			Category->"Coating",
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient]
				],
				Widget[
					Type->Quantity,
					Pattern:>RangeP[4Celsius,50Celsius],
					Units->Alternatives[Celsius]
				]
			]
		},
		{
			OptionName->CoatingTime,
			Default->Automatic,
			Description->"The duration when the Coating Solution is kept in the assay plate, in order for the coating molecules to be adsorbed to the surface of the well.",
			ResolutionDescription->"If Coating is set to True, the option is automatically set to 16 Hours.",
			AllowNull->True,
			Category->"Coating",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Hour,20 Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->CoatingWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added to rinse off unbound molecule. When Coating is False but Blocking is True, the pre-coated plate must be washed at least once to ensure no liquid is left in the plate.",
			ResolutionDescription->"If Coating is set to True, or Coating is False but Blocking is True, the option is automatically set to 250 Microliters.",
			Category->"Coating",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->CoatingNumberOfWashes,
			Default->Automatic,
			Description->"The number of washes performed after coating. When Coating is False but Blocking is True, the pre-coated plate must be washed at least once to ensure no liquid is left in the plate.",
			ResolutionDescription->"If Coating is set to True,or Coating is False but Blocking is True, the option is automatically set to 3.",
			AllowNull->True,
			Category->"Coating",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},
		(*============Blocking==============*)
		{
			OptionName->Blocking,
			Default->True,
			Description->"Indicates if a protein solution should be incubated with the assay plate to prevent non-specific binding of molecules to the assay plate.",
			AllowNull->False,
			Category->"Blocking",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[BooleanP]
			]
		},
		{
			OptionName->BlockingBuffer,
			Default->Automatic	,
			Description->"The protein-containing solution used to prevent non-specific binding of antigen or antibody to the surface of the assay plate.",
			ResolutionDescription->"If Blocking is True, automatically set to Model[Sample,\"ELISA Blocker Blocking Buffer\"].",
			AllowNull->True,
			Category->"Blocking",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->BlockingVolume,
				Default->Automatic,
				Description->"The amount of BlockingBuffer that is aliquoted into the appropriate wells of the assay plate, in order to prevent non-specific binding of molecules to the assay plate.",
				ResolutionDescription->"If Blocking is True, the option is automatically set to 100 Microliters.",
				AllowNull->True,
				Category->"Blocking",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[25 Microliter,300 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->BlockingTime,
			Default->Automatic,
			Description->"The duration when the BlockingBuffer is kept with the assay plate, in order to prevent non-specific binding of molecules to the assay plate.",
			ResolutionDescription->"If Blocking is True, the option is automatically set to 1 Hour.",
			AllowNull->True,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0 Hour,20 Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->BlockingTemperature,
			Default->Automatic,
			Description->"The duration of time when the BlockingBuffer is kept with the assay plate, in order to prevent non-specific binding of molecules to the assay plate.",
			ResolutionDescription->"If Blocking is True, the option is automatically set to 25 degree Celsius.",
			AllowNull->True,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25Celsius,50Celsius],
				Units->Alternatives[Celsius]
			]
		},
		{
			OptionName->BlockingMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during Blocking incubation. Mixing is not recommended when incubation volume is high, in which case the option should be set to Null.",
			AllowNull->True,
			Category->"Blocking",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName->BlockingWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added after Blocking, in order to rinse off the unbound molecules from the surface of the wells. If Coating and Blocking are both False, at least one blocking wash is required to ensure no liquid is remaining in the assay plate.",
			ResolutionDescription->"If Blocking is True, or Coating and Blocking are both False, the option is automatically set to 250 Microliters.",
			Category->"Blocking",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->BlockingNumberOfWashes,
			Default->Automatic,
			Description->"The number of washes performed after Blocking, in order to rinse off the unbound molecules from the surface of the wells.",
			ResolutionDescription->"If Blocking is True, or Coating and Blocking are both False, the option is automatically set to 3.",
			AllowNull->True,
			Category->"Blocking",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},
		(*============Immunosorbent Step==============*)
		(*
		IF Method == DirectELISA              THEN PrimaryAntibody
		IF Method == IndirectELISA            THEN PrimaryAntibody         && SecondaryAntibody
		IF Method == DirectSandwichELISA      THEN Sample                  && PrimaryAntibody
		IF Method == IndirectSandwichELISA    THEN Sample                  && PrimaryAntibody    && SecondaryAntibody
		IF Method == DirectCompetitiveELISA   THEN Antibody-Sample Complex
		IF Method == IndirectCompetitiveELISA THEN Antibody-Sample Complex && SecondaryAntibody
		IF Method == FastELISA                THEN Antibody-Sample Complex
		*)


		(*Sample-Antibody Complex*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleAntibodyComplexImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the sample-antibody complex to be loaded on each well of the ELISAPlate. In DirectCompetitiveELISA and IndirectCompetitiveELISA, this step enables the free primary antibody to bind to the ReferenceAntigen coated on the plate. In FastELISA, this step enables the PrimaryAntibody-TargetAntigen-CaptureAntibody complex to bind to the CoatingAntibody on the plate.",
				ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Immunosorbent Step",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->SampleAntibodyComplexImmunosorbentTime,
			Default->Automatic,
			Description->"The duration of sample-antibody complex incubation.",
			ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 2 Hour.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->SampleAntibodyComplexImmunosorbentTemperature,
			Default->Automatic,
			Description->"The temperature of the sample-antibody complex incubation.",
			ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 25 Celsius.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Ambient]
				],
				Widget[
					Type->Quantity,
					Pattern:>RangeP[4Celsius,50Celsius],
					Units->Alternatives[Celsius]
				]
			]
		},
		{
			OptionName->SampleAntibodyComplexImmunosorbentMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during SampleAntibody mixture incubation in the assay plate. Mixing is not recommended when incubation volume is higher than 200 Microliters, in which case the options should be set to Null.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName->SampleAntibodyComplexImmunosorbentWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added to rinse off the unbound primary antibody after sample-antibody complex incubation.",
			ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 250 Microliter.",
			Category->"Immunosorbent Step",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->SampleAntibodyComplexImmunosorbentNumberOfWashes,
			Default->Automatic,
			Description->"The number of rinses performed after sample-antibody complex incubation.",
			ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 4.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SampleImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the Sample to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
				ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 100 Microliters.",
				AllowNull->True,
				Category->"Immunosorbent Step",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->SampleImmunosorbentTime,
			Default->Automatic,
			Description->"The duration of Sample incubation.",
			ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 2 Hour.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->SampleImmunosorbentTemperature,
			Default->Automatic,
			Description->"The temperature of the Sample incubation.",
			ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 25 Celsius.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25Celsius,50Celsius],
				Units->Alternatives[Celsius]
			]
		},
		{
			OptionName->SampleImmunosorbentMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during Sample incubation. Mixing is not recommended when incubation volume is higher than 200 Microliters, in which case the options should be set to Null.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName->SampleImmunosorbentWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added to rinse off the unbound Sample after Sample incubation.",
			ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 250 Microliters.",
			Category->"Immunosorbent Step",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->SampleImmunosorbentNumberOfWashes,
			Default->Automatic,
			Description->"The number of rinses performed after Sample incubation.",
			ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 4.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->PrimaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the PrimaryAntibody to be loaded on the ELISA Plate for immunosorbent step.",
				ResolutionDescription->"If",
				AllowNull->True,
				Category->"Immunosorbent Step",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->PrimaryAntibodyImmunosorbentTime,
			Default->Automatic,
			Description->"The duration of PrimaryAntibody incubation.",
			ResolutionDescription->"If the Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA, the option is automatically set to 2 Hour.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->PrimaryAntibodyImmunosorbentTemperature,
			Default->Automatic,
			Description->"The temperature of the PrimaryAntibody incubation.",
			ResolutionDescription->"If the Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA, the option is automatically set to 25 Celsius.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25Celsius,50Celsius],
				Units->Alternatives[Celsius]
			]
		},
		{
			OptionName->PrimaryAntibodyImmunosorbentMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during PrimaryAntibody incubation. Mixing is not recommended when incubation volume is higher than 200 Microliters, in which case the options should be set to Null.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName -> PrimaryAntibodyImmunosorbentWashing,
			Default -> Automatic,
			Description -> "Indicates if a final washing step is performed at the end of PrimaryAntibodyImmunosorbent incubation to wash off unbound PrimaryAntibody. Performing this washing step is generally recommended. However, some specialized commercial pre-blocked plates are designed with detection chemistry specific to the bound complex, in which case the washing step may be optional.",
			ResolutionDescription -> "If Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA, automatically set to True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[BooleanP]
			],
			Category -> "Immunosorbent Step"
		},
		{
			OptionName->PrimaryAntibodyImmunosorbentWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added to rinse off the unbound primary antibody after PrimaryAntibody incubation.",
			ResolutionDescription->"If PrimaryAntibodyImmunosorbentWashing is True, the option is automatically set to 250 Microliters.",
			Category->"Immunosorbent Step",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->PrimaryAntibodyImmunosorbentNumberOfWashes,
			Default->Automatic,
			Description->"The number of rinses performed after PrimaryAntibody incubation.",
			ResolutionDescription->"If PrimaryAntibodyImmunosorbentWashing is True, the option is automatically set to 4.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},

		(*Secondary Antibody Immunosorbent*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SecondaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the Secondary Antibody to be loaded on the ELISAPlate for the immunosorbent step.",
				ResolutionDescription->"If the Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Immunosorbent Step",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		{
			OptionName->SecondaryAntibodyImmunosorbentTime,
			Default->Automatic,
			Description->"The duration of Secondary Antibody incubation.",
			ResolutionDescription-> "If the Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, the option is automatically set to 1 Hour.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->SecondaryAntibodyImmunosorbentTemperature,
			Default->Automatic,
			Description->"The temperature of the Secondary Antibody incubation.",
			ResolutionDescription-> "If the Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, the option is automatically set to 25 Celsius.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25Celsius,50Celsius],
				Units->Alternatives[Celsius]
			]
		},
		{
			OptionName->SecondaryAntibodyImmunosorbentMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during Secondary Antibody incubation. Mixing is not recommended when incubation volume is higher than 200 Microliters, in which case the options should be set to Null.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName -> SecondaryAntibodyImmunosorbentWashing,
			Default -> Automatic,
			Description -> "Indicates if a final washing step is performed at the end of SecondaryAntibodyImmunosorbent incubation to wash off unbound SecondaryAntibody.  Performing this washing step is generally recommended. However, some specialized commercial pre-blocked plates are designed with detection chemistry specific to the bound complex, in which case the washing step may be optional.",
			ResolutionDescription -> "If Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, automatically set to True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> Alternatives[BooleanP]
			],
			Category -> "Immunosorbent Step"
		},
		{
			OptionName->SecondaryAntibodyImmunosorbentWashVolume,
			Default->Automatic,
			Description->"The volume of WashBuffer added to rinse off the unbound Secondary antibody after SecondaryAntibody incubation.",
			ResolutionDescription->"If SecondaryAntibodyImmunosorbentWashing is set to True, the option is automatically set to 250 Microliters.",
			Category->"Immunosorbent Step",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25 Microliter, 300 Microliter],
				Units->Alternatives[Microliter]
			]
		},
		{
			OptionName->SecondaryAntibodyImmunosorbentNumberOfWashes,
			Default->Automatic,
			Description->"The number of rinses performed after SecondaryAntibody incubation.",
			ResolutionDescription->"If SecondaryAntibodyImmunosorbentWashing is set to True, the option is automatically set to 4.",
			AllowNull->True,
			Category->"Immunosorbent Step",
			Widget->Widget[
				Type->Number,
				Pattern:>GreaterP[0,1]
			]
		},

		(*============Detection==============*)
		IndexMatching[
			IndexMatchingInput->"experiment samples",
			{
				OptionName->SubstrateSolution,
				Default->Automatic,
				Description->"Defines the substrate solution to the enzyme conjugated to the antibody.",
				ResolutionDescription->"If enzyme is Horseredish Peroxidase, the option will be automatically set to Model[Sample,\"ELISA TMB Stabilized Chromogen\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate PNPP Solution\"].",
				AllowNull->False,
				Category->"Detection",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StopSolution,
				Default->Automatic,
				Description->"The reagent that is used to stop the reaction between the enzyme and its substrate.",
				ResolutionDescription->"If enzyme is Horseradish Peroxidase, then the option is automatically set to Model[Sample,\"ELISA HRP-TMB Stop Solution\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate Stop Solution\"].",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->SubstrateSolutionVolume,
				Default->Automatic,
				Description->"The volume of substrate to be added to the corresponding well.",
				ResolutionDescription->"If SubstrateSolution is populated, then the option is automatically set to 100ul.",
				AllowNull->False,
				Category->"Detection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter, Milliliter]
				]
			},
			{
				OptionName->StopSolutionVolume,
				Default->Automatic,
				Description->"The volume of StopSolution to be added to the corresponding well.",
				ResolutionDescription->"If StopSolution is selected, the StopSolutionVolume is automatically set to 100ul.",
				AllowNull->True,
				Category->"Detection",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter, 200 Microliter],
					Units->Alternatives[Microliter, Milliliter]
				]
			}
		],
		{
			OptionName->SubstrateIncubationTime,
			Default->30 Minute,
			Description->"The time during which the colorimetric reaction occurs.",
			AllowNull->False,
			Category->"Detection",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[0*Minute, 24*Hour],
				Units->Alternatives[Minute, Hour]
			]
		},
		{
			OptionName->SubstrateIncubationTemperature,
			Default->25 Celsius,
			Description->"The temperature of the Substrate incubation, in order for the detection reaction to take place where the antibody-conjugated enzyme (such as Horseradish Peroxidase or Alkaline Phosphatase) catalyzes the colorimetric reaction.",
			AllowNull->False,
			Category->"Detection",
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[25Celsius,50Celsius],
				Units->Alternatives[Celsius]
			]
		},
		{
			OptionName->SubstrateIncubationMixRate,
			Default->Null,
			Description->"The speed at which the plate is shaken (orbitally, at a radius of 2 mm) during Substrate incubation. Mixing is not recommended when incubation volume is higher than 200 Microliters, in which case the options should be set to Null.",
			Category->"Detection",
			AllowNull->True,
			Widget->Widget[
				Type->Quantity,
				Pattern:>RangeP[40RPM, 1000RPM],
				Units->Alternatives[RPM]
			]
		},
		{
			OptionName->AbsorbanceWavelength,
			Default->450 Nanometer,
			Description->"The wavelength used to detect the absorbance of light by the product of the detection reaction.",
			AllowNull->False,
			Category->"Detection",
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[405 Nanometer|450 Nanometer|492 Nanometer|620 Nanometer]
				],
				Adder[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[405 Nanometer|450 Nanometer|492 Nanometer|620 Nanometer]
					]
				]
			]
		},
		{
			OptionName->PrereadBeforeStop,
			Default->Automatic,
			Description->"Indicate if colorimetric reactions between the enzyme and its substrate will be checked by the plate reader before the stopping reagent was added to terminate the reaction.",
			ResolutionDescription->"Is set automatically to True if either or both of PrereadTimepoints and PrereadAbsorbanceWavelength are specified. Otherwise is set to False.",
			Category->"Detection",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>BooleanP
			]
		},
		{
			OptionName->PrereadTimepoints,
			Default->Automatic,
			Description->"The list of time points when absorbance intensitied at each PreparedAbsorbanceWavelength during the Preread process (before the colorimetric reaction was terminated).",
			ResolutionDescription->"If PrereadBeforeStop is True, this option is set to one single value: the half of the SubstrateIncubationTime. Otherwise is set to Null.",
			Category->"Detection",
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,$MaxExperimentTime],
					Units->{1,{Hour,{Second,Minute,Hour}}}
				],
				Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Minute,$MaxExperimentTime],
						Units->{1,{Hour,{Second,Minute,Hour}}}
					]
				]
			]
		},
		{
			OptionName->PrereadAbsorbanceWavelength,
			Default->Automatic,
			Description->"The wavelength used to detect the absorbance of light during the Preread process (before the colorimetric reaction was terminated).",
			ResolutionDescription->"If PrereadBeforeStop is True, this option is set to {450 Nanometer}. Otherwise is set to Null.",
			Category->"Detection",
			AllowNull->True,
			Widget->Alternatives[
				Widget[
					Type->Enumeration,
					Pattern:>Alternatives[405 Nanometer|450 Nanometer|492 Nanometer|620 Nanometer]
				],
				Adder[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[405 Nanometer|450 Nanometer|492 Nanometer|620 Nanometer]
					]
				]
			]
		},
		{
			OptionName->SignalCorrection,
			Default->False,
			Description->"The absorbance reading that is used to eliminate the interference of background absorbance (such as from ELISAPlate material and dust). If True, a reading at 620 nm is read at the same time of the AbsorbanceWavelength. The correction is done by subtracting the reading at 620nm from that at the AbsorbanceWavelength.",
			AllowNull->True,
			Category->"Detection",
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[BooleanP]
			]
		},

		(*===============================================*)
		(*==============STANDARD OPTIONS=================*)
		(*===============================================*)


		IndexMatching[
			IndexMatchingParent->Standard,
			{
				OptionName->Standard,
				Default->Automatic,
				Description->"A sample containing known amount of TargetAntigen molecule. Standard is used for the quantification of Standard analyte.",
				ResolutionDescription->"If TargetAntigen is specified, standard will be automatically set to the DefaultSampleModel of the target antigen.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardTargetAntigen,
				Default->Automatic,
				Description->"The Analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the Standard samples by Antibodies in the ELISA experiment. This option is used to automatically set sample Antibodies and the corresponding experiment conditions of Standards and Blanks.",
				ResolutionDescription->"Automatically set to the Model[Molecule] in the Analyte field of the sample.",
				Category->"Standard",
				AllowNull->True,
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Molecule]}]
				]
			},
			{
				OptionName->StandardSerialDilutionCurve,
				Default->Automatic,
				Description->"The collection of serial dilutions that will be performed on sample. StandardLoadingVolume of each dilution will be transferred to the ELISAPlate. For Serial Dilution Volumes, the Transfer Volume is taken out of the sample and added to a second well with the Diluent Volume of the Diluent. It is mixed, then the Transfer Volume is taken out of that well to be added to a third well. This is repeated to make Number Of Dilutions diluted samples. For example, if a 100 ug/ ml sample with a Transfer Volume of 20 Microliters, a Diluent Volume of 60 Microliters and a Number of Dilutions of 3 is used, it will create a DilutionCurve of 25 ug/ ml, 6.25 ug/ ml, and 1.5625 ug/ ml with each dilution having a volume of 60 Microliters. For Serial Dilution Factors, the sample will be diluted by the dilution factor at each transfer step. IMPORTANT: because the dilution curve does not intrinsically include the original sample, if the original standard solution is to be included in the dilution curve, the first diluting factor should be set to 1 or Diluent Volume should be 0 Microliters.  During experiment, an 5% extra volume than specified is going to be prepared in order to offset pipetting errors. Therefore, the total volume for each well specified in this option should be equal or greater than the volume needed for the experiment. Because the dilution of each assay (well) is prepared independently, the NumberOfReplications should not be considered when determining the Standard Volume. The plate used for sample dilutions will be discarded after the experiment. Note: if spike or antibodies are to be mixed with samples, their volumes are counted towards diluent volume.",
				ResolutionDescription->"Automatically set to Null if the StandardDilutionCurve is specified or when Method is DirectELISA or IndirectELISA and Coating is False. In all other cases it is automatically set to a Standard Volume of 100 Microliters and a Constant Dilution Factor of 0.5. The Number Of Dilutions is automatically set to 6.",
				AllowNull->True,
				Category->"Standard",
				Widget->Alternatives[
					"Serial Dilution Factor"->
						{
							"Standard Assay Volume"->Widget[
								Type->Quantity,
								Pattern:>GreaterEqualP[0 Microliter],
								Units->Alternatives[Microliter]
							],
							"Dilution Factors" ->
								Alternatives[
									"Constant"->{
										"Constant Dilution Factor" ->
											Widget[Type->Number,
												Pattern :> RangeP[0, 1]],
										"Number Of Dilutions" ->
											Widget[Type->Number,
												Pattern :> GreaterP[0, 1]
											]},
									"Variable" ->
										Adder[Widget[Type->Number, Pattern :> RangeP[0, 1]]]]
						},
					"Serial Dilution Volumes"->
						{
							"Transfer Volume"->Widget[
								Type->Quantity,
								Pattern:>RangeP[0 Microliter,1000 Microliter],
								Units->{1,{Microliter,{Microliter}}}],
							"Diluent Volume"->Widget[
								Type->Quantity,
								Pattern:>RangeP[40 Microliter, 1000 Microliter],
								Units->Alternatives[Microliter]
							],
							"Number Of Dilutions"->Widget[
								Type->Number,
								Pattern :> GreaterP[0,1]
							]
						}
				]
			},
			{
				OptionName->StandardDilutionCurve,
				Default->Automatic,
				Description->"The collection of dilutions that will be performed on each sample. For Fixed Dilution Volume Dilution Curves, the Standard Amount is the volume of the sample that will be mixed the Diluent Volume of the Diluent to create a desired concentration. The Standard Volume is the TOTAL volume of the sample that will created after being diluted by the Dilution Factor. For example, a 1 ug/ ml sample with a dilution factor of 0.7 will be diluted to a concentration 0.7 ug/ ml. IMPORTANT: because the dilution curve does not intrinsically include the original sample, if the original standard solution is to be included in the dilution curve, the first diluting factor should be set to 1 or Diluent Volume must be 0 Microliter. During experiment, an 5% extra volume than specified is going to be prepared in order to offset pipetting errors. Therefore, the total volume for each well specified in this option should be equal or greater than the volume needed for the experiment. Because the dilution of each assay (well) is prepared independently, the NumberOfReplications should not be considered when determining the Standard Volume. The plate used for sample dilutions will be discarded after the experiment. Note: if spike or antibodies are to be mixed with samples, their volumes are counted towards diluent volume.",
				ResolutionDescription->"Automatically set to Null if the SerialDilutionCurve is specified or when Method is DirectELISA or IndirectELISA and Coating is False. Otherwise, then automatically set Standard Assay Volume to 100ul, dilution factor to 0.5, 0,25, 0.125, 0.0625, 0.03125, 0.015625.",
				AllowNull->True,
				Category->"Standard",
				Widget->Alternatives[
					"Fixed Dilution Volume"->Adder[
						{
							"Standard Amount"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Diluent Volume"->Widget[Type->Quantity,Pattern:>RangeP[0 Microliter,1000 Microliter],Units->{1,{Microliter,{Microliter}}}]
						}
					],
					"Fixed Dilution Factor"->Adder[
						{
							"Standard Assay Volume"->Widget[Type->Quantity,Pattern:>RangeP[40 Microliter, 1500Microliter],Units->{1,{Microliter,{Microliter}}}],
							"Dilution Factors"->Widget[Type->Number,Pattern:>RangeP[0,1]]
						}
					]
				]
			}
		],
		{
			OptionName->StandardDiluent,
			Default->Automatic,
			Description->"The buffer used to perform multiple dilutions on Standards.",
			ResolutionDescription->"If StandardDilutionCurve and StandardSerialDilutionCurve are not both Null, in the case when Method is set to DirectELISA and IndirectELISA, the option is automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"]; in all other cases, the option is automatically set to Model[Sample,\"ELISA Blocker Blocking Buffer\"].",
			AllowNull->True,
			Category->"Standard",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
			]
		},
		IndexMatching[
			IndexMatchingParent->Standard,

			{
				OptionName->StandardStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Standard stock sample should be stored.",
				ResolutionDescription->"If Standard is Specified, the option is automatically set to Freezer.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Standard Coating Antibody *)
			{
				OptionName->StandardCoatingAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used for coating in FastELISA.",
				ResolutionDescription->"If Method is FastELISA and Standard is not Null, automatically set to an antibody against a tag which is conjugated to a the StandardCaptureAntibody.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardCoatingAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of StandardCoatingAntibody. StandardCoatingAntibody is diluted with CoatingAntibodyDiluent. Either StandardCoatingAntibodyDilutionFactor or StandardCoatingAntibodyVolume should be provided but not both.",
				ResolutionDescription->"If Method is FastELISA and Standard is not Null, automatically set to 0.001 (1:1,000)",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->StandardCoatingAntibodyVolume,
				Default->Null,
				Description->"The volume of undiluted StandardCoatingAntibody added into the corresponding well of the assay plate. StandardCoatingAntibody is diluted with CoatingAntibodyDiluent. StandardCoatingAntibodyVolume is used as an alternative to StandardCoatingAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},


			(* Standard Capture Antibody *)
			{
				OptionName->StandardCaptureAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used to pull down the antigen from sample solution to the plate in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA.",
				ResolutionDescription->"Automatically set to Null is Standard is Null. If Method is FastELISA, automatically set to an antibody containing an affinity tag and against the TargetAntigen. If Method is DirectSandwichELISA or IndirectSandwichELISA, automatically set to an un-tagged antibody against TargetAntigen.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardCaptureAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of StandardCaptureAntibody. For DirectSandwichELISA and IndirectSandwichELISA, StandardCaptureAntibody is diluted with CaptureAntibodyDiluent. For FastELISA, StandardCaptureAntibody is diluted in the corresponding standard. Either StandardCaptureAntibodyDilutionFactor or StandardCaptureAntibodyVolume should be provided but not both.",
				ResolutionDescription->"When Standard is not Null, if Method is DirectSandwichELISA or IndirectSandwichELISA, automatically set to 0.001 (1:1,000). If Method is FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->StandardCaptureAntibodyVolume,
				Default->Null,
				Description->"The volume of undiluted CaptureAntibody added into the corresponding well of the assay plate. StandardCaptureAntibodyVolume is used as an alternative to StandardCaptureAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},


			(* Standard Reference Antigen *)
			{
				OptionName->StandardReferenceAntigen,
				Default->Automatic,
				Description->"The sample containing the antigen that is used in DirectCompetitiveELISA or IndirectCompetitiveELISA. The StandardReferenceAntigen competes with sample antigen for the binding of the StandardPrimaryAntibody. Reference antigen is sometimes also referred to as inhibitor antigen.",
				ResolutionDescription->"Automatically set to a sample containing known amount of TargetAntigen when Method is set to DirectCompetitiveELISA or IndirectCompetitiveELISA and Standard is not Null.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardReferenceAntigenDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of StandardReferenceAntigen. For DirectCompetitiveELISA and IndirectCompetitiveELISA, the StandardReferenceAntigenStandard is diluted in ReferenceAntigenDiluent. Either StandardReferenceAntigenDilutionFactor or StandardReferenceAntigenVolume should be provided but not both.",
				ResolutionDescription->"Automatically set to 0.001 (1:1,000) if Method is DirectCompetitiveELISA or IndirectCompetitiveELISA.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->StandardReferenceAntigenVolume,
				Default->Null,
				Description->"The volume of ReferenceAntigen added into the corresponding well of the assay plate. StandardReferenceAntigenVolume is used as an alternative to StandardReferenceAntigenDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},

			(* Standard Primary Antibody *)
			{
				OptionName->StandardPrimaryAntibody,
				Default->Automatic,
				Description->"The antibody that directly binds to the analyte.",
				ResolutionDescription->"If Standard is not Null, the option will be automatically set to an antibody against the TargetAntigen.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardPrimaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of StandardPrimaryAntibody. For DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, the antibody is diluted with PrimaryAntibodyDiluent. For DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA, the antibody is diluted in the corresponding sample. Either StandardPrimaryAntibodyDilutionFactor or StandardPrimaryAntibodyVolume should be provided but not both.",
				ResolutionDescription->"When Standard is not Null, if used for DirectELISA, IndirectELISA, DirectSandwichELISA, IndirectSandwichELISA, automatically set to 0.001 (1:1,000). If used for DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->StandardPrimaryAntibodyVolume,
				Default->Null,
				Description->"The volume of PrimaryAntibody added into the corresponding well of the assay plate. StandardPrimaryAntibodyVolume is used as an alternative to StandardPrimaryAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},

			(* Standard Secondary Antibody *)
			{
				OptionName->StandardSecondaryAntibody,
				Default->Automatic,
				Description->"The antibody that binds to the primary antibody.",
				ResolutionDescription->"If Method is IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA, the option is automatically set to a stocked secondary antibody for the primary antibody.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardSecondaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of StandardSecondaryAntibody. StandardSecondaryAntibody is always diluted in the SecondaryAntibodyDiluent. For example, if StandardSecondaryAntibodyDilutionFactor is 0.8 and StandardSecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted StandardSecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				ResolutionDescription->"If Standard is not Null, for IndirectELISA, IndirectSandwichELISA, IndirectCompetitiveELISA, automatically set to 0.001 (1:1,000).",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->StandardSecondaryAntibodyVolume,
				Default->Automatic,
				Description->"The volume of StandardSecondaryAntibody added into the SampleAssemblyPlate during dilution to prepare a master mix. For example, if StandardSecondaryAntibodyDilutionFactor is 0.8 and StandardSecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted StandardSecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				ResolutionDescription -> "If StandardSecondaryAntibodyDilutionFactor is specified, automatically set to 1.1*StandardSecondaryAntibodyDilutionFactor*StandardSecondaryAntibodyImmunosorbentVolume.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->StandardCoatingVolume,
				Default->Automatic,
				Description->"The amount of Standard that is aliquoted into the ELISAPlate, in order for the Standard to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectELISA or IndirectELISA, StandardCoatingVolume is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->StandardReferenceAntigenCoatingVolume,
				Default->Automatic,
				Description->"The amount of StandardReferenceAntigen that is aliquoted into the assay plate, in order for the StandardReferenceAntigen to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectCompetitiveELISA or IndirectCompetitiveELISA, CoatingVolume is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->StandardCoatingAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted StandardCoatingAntibody that is aliquoted into the ELISAPlate, in order for the StandardCoatingAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is FastELISA, the option is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardCaptureAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted StandardCaptureAntibody that is aliquoted into the ELISAPlate, in order for the StandardCaptureAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectSandwichELISA or IndirectSandwichELISA, the option is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardBlockingVolume,
				Default->Automatic,
				Description->"The amount of BlockingBuffer that is aliquoted into the appropriate wells of the ELISAPlate.",
				ResolutionDescription->"If Blocking is True, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,300 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardAntibodyComplexImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the standard-antibody complex to be loaded on the ELISAPlate. In DirectCompetitiveELISA and IndirectCompetitiveELISA, this step enables the free StandardPrimaryAntibody to bind to the StandardReferenceAntigen coated on the plate. In FastELISA, this step enables the PrimaryAntibody-TargetAntigen-CaptureAntibody complex to bind to the CoatingAntibody on the plate.",
				ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the Standard to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
				ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardPrimaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the StandarPrimaryAntibody to be loaded on the ELISAPlate for Immunosorbent assay.",
				ResolutionDescription->"If the Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardSecondaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the StandardSecondaryAntibody to be loaded on the ELISAPlate for immunosorbent step.",
				ResolutionDescription->"If the Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardSubstrateSolution,
				Default->Automatic,
				Description->"Defines the substrate solution for the standard solution.",
				ResolutionDescription->"If enzyme is Horseredish Peroxidase, the option will be automatically set to Model[Sample,\"ELISA TMB Stabilized Chromogen\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate PNPP Solution\"].",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardStopSolution,
				Default->Automatic,
				Description->"The reagent that is used to stop the reaction between the enzyme and its substrate.",
				ResolutionDescription->"If enzyme is Horseradish Peroxidase, then the option is automatically set to Model[Sample,\"ELISA HRP-TMB Stop Solution\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate Stop Solution\"].",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->StandardSubstrateSolutionVolume,
				Default->Automatic,
				Description->"The volume of StandardSubstrateSolution to be added to the corresponding well.",
				ResolutionDescription->"If StandardSubstrateSolution is populated and Standard is not Null, then the option is automatically set to 100ul.",

				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->StandardStopSolutionVolume,
				Default->Automatic,
				Description->"The volume of StopSolution to be added to the corresponding well.",
				ResolutionDescription->"If Model[Sample,\"ELISA TMB Stabilized Chromogen\"] or Model[Sample,\"ELISA HRP-TMB Stop Solution\"] is selected for StandardSubstrateSolution, the StopSolutionVolume is automatically set to 100ul.",
				AllowNull->True,
				Category->"Standard",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			}
		],
		(*===============================================*)
		(*================Blank OPTIONS==================*)
		(*===============================================*)

		IndexMatching[
			IndexMatchingParent->Blank,
			{
				OptionName->Blank,
				Default->Automatic,
				Description->"A sample containing no TargetAntigen, used as a baseline or negative control for the ELISA.",
				ResolutionDescription->"If In DirectELISA and IndirectELISA, the option will be automatically set to Model[Sample, StockSolution, \"1x Carbonate-Bicarbonate Buffer pH10\"]. Otherwise, the option will be automatically set to Model[Sample, \"ELISA Blocker Blocking Buffer\"].",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankTargetAntigen,
				Default->Automatic,
				Description->"The Analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the blanks by Antibodies in the ELISA experiment. This option is used to automatically set Antibodies and the corresponding experiment conditions.",
				ResolutionDescription->"Automatically set to the Model[Molecule] in the Analyte field of the sample.",
				Category->"Blank",
				AllowNull->True,
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Molecule]}]
				]
			},
			{
				OptionName->BlankStorageCondition,
				Default->Automatic,
				Description->"The condition under which the unused portion of Blank should be stored.",
				ResolutionDescription->"Automatically set to Refrigerator if Blank is not Null.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[SampleStorageTypeP,Disposal]
				]
			},

			(* Blank Coating Antibody *)
			{
				OptionName->BlankCoatingAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used for coating in FastELISA.",
				ResolutionDescription->"If Method is FastELISA and Blank is not Null, automatically set to an antibody against a tag which is conjugated to a the StandardCaptureAntibody.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankCoatingAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of BlankCoatingAntibody. BlankCoatingAntibody is diluted with CoatingAntibodyDiluent. Either BlankCoatingAntibodyDilutionFactor or BlankCoatingAntibodyVolume should be provided but not both.",
				ResolutionDescription->"If Method is FastELISA and Blank is not Null, automatically set to 0.001 (1:1,000)",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->BlankCoatingAntibodyVolume,
				Default->Null,
				Description->"The volume of BlankCoatingAntibody added into the corresponding well of the assay plate. BlankCoatingAntibody is diluted with CoatingAntibodyDiluent. BlankCoatingAntibodyVolume is used as an alternative to BlankCoatingAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},


			(* Blank Capture Antibody *)
			{
				OptionName->BlankCaptureAntibody,
				Default->Automatic,
				Description->"The sample containing the antibody that is used to pull down the antigen from sample solution to the plate in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA.",
				ResolutionDescription->"Automatically set to Null is Blank is Null. If Method is FastELISA, automatically set to an antibody containing an affinity tag and against the TargetAntigen. If Method is DirectSandwichELISA or IndirectSandwichELISA, automatically set to an un-tagged antibody against TargetAntigen.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankCaptureAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of BlankCaptureAntibody. For DirectSandwichELISA and IndirectSandwichELISA, BlankCaptureAntibody is diluted with CaptureAntibodyDiluent. For FastELISA, BlankCaptureAntibody is diluted in the corresponding sample. Either BlankCaptureAntibodyDilutionFactor or BlankCaptureAntibodyVolume should be provided but not both.",
				ResolutionDescription->"If Method is DirectSandwichELISA or IndirectSandwichELISA, automatically set to 0.001 (1:1,000). If Method is FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->BlankCaptureAntibodyVolume,
				Default->Null,
				Description->"The volume of CaptureAntibody added into the corresponding well of the assay plate. BlankCaptureAntibodyVolume is used as an alternative to BlankCaptureAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},


			(* Blank Reference Antigen *)
			{
				OptionName->BlankReferenceAntigen,
				Default->Automatic,
				Description->"The Sample containing the antigen that is used in DirectCompetitiveELISA or IndirectCompetitiveELISA. The BlankReferenceAntigen competes with sample antigen for the binding of the BlankPrimaryAntibody. Reference antigen is sometimes also referred to as inhibitor antigen.",
				ResolutionDescription->"Automatically set to a sample containing known amount of TargetAntigen when Method is set to DirectCompetitiveELISA or IndirectCompetitiveELISA and Blank is not Null.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankReferenceAntigenDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of BlankReferenceAntigen. For DirectCompetitiveELISA and IndirectCompetitiveELISA, the BlankReferenceAntigenBlank is diluted in ReferenceAntigenDiluent. Either BlankReferenceAntigenDilutionFactor or BlankReferenceAntigenVolume should be provided but not both.",
				ResolutionDescription->"Automatically set to 0.001 (1:1,000) if Method is DirectCompetitiveELISA or IndirectCompetitiveELISA.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->BlankReferenceAntigenVolume,
				Default->Null,
				Description->"The volume of ReferenceAntigen added into the corresponding well of the assay plate. BlankReferenceAntigenVolume is used as an alternative to BlankReferenceAntigenDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},

			(* Blank Primary Antibody *)
			{
				OptionName->BlankPrimaryAntibody,
				Default->Automatic,
				Description->"The antibody that directly binds with the analyte.",
				ResolutionDescription->"The option will be automatically set to an antibody against the BlankTargetAntigen if Blank is not Null.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankPrimaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of BlankPrimaryAntibody. For DirectELISA, IndirectELISA, DirectSandwichELISA, and IndirectSandwichELISA, the antibody is diluted with PrimaryAntibodyDiluent. For DirectCompetitiveELISA, IndirectCompetitiveELISA, and FastELISA, the antibody is diluted in the corresponding sample. Either BlankPrimaryAntibodyDilutionFactor or BlankPrimaryAntibodyVolume should be provided but not both.",
				ResolutionDescription->"When Blank is not Null, if used for DirectELISA, IndirectELISA, DirectSandwichELISA, IndirectSandwichELISA, automatically set to 0.001 (1:1,000). If used for DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, automatically set to 0.01 (1:100).",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->BlankPrimaryAntibodyVolume,
				Default->Null,
				Description->"The volume of PrimaryAntibody added into the corresponding well of the assay plate. BlankPrimaryAntibodyVolume is used as an alternative to BlankPrimaryAntibodyDilutionFactor. During antibody preparation, a master mix will be made for antibody dilution, and the diluted Antibodies will be aliquoted into each well.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},

			(* Blank Secondary Antibody *)
			{
				OptionName->BlankSecondaryAntibody,
				Default->Automatic,
				Description->"The antibody that binds to the primary antibody.",
				ResolutionDescription->"If Method is IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA and Blank is not Null, the option is automatically set to an stocked secondary antibody for the primary antibody.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankSecondaryAntibodyDilutionFactor,
				Default->Automatic,
				Description->"The dilution ratio of BlankSecondaryAntibody. BlankSecondaryAntibody is always diluted in the SecondaryAntibodyDiluent. For example, if BlankSecondaryAntibodyDilutionFactor is 0.8 and BlankSecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted BlankSecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				ResolutionDescription->"If Blank is not Null, for IndirectELISA, IndirectSandwichELISA, IndirectCompetitiveELISA, automatically set to 0.001 (1:1,000).",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Number,
					Pattern:>RangeP[0,1]
				]
			},
			{
				OptionName->BlankSecondaryAntibodyVolume,
				Default->Automatic,
				Description->"The volume of BlankSecondaryAntibody added into the SampleAssemblyPlate during dilution to prepare a master mix. For example, if BlankSecondaryAntibodyDilutionFactor is 0.8 and BlankSecondaryAntibodyVolume is 100 Microliters, the master mix is mixed by 100 Microliters undiluted BlankSecondaryAntibody and 25 Microliters SecondaryAntibodyDiluent.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankCoatingVolume,
				Default->Automatic,
				Description->"The amount of Blank that is aliquoted into the ELISAPlate.",
				ResolutionDescription->"If Blank is not Null, and Method is DirectELISA or IndirectELISA, CoatingVolume is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankReferenceAntigenCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted BlankReferenceAntigen that is aliquoted into the assay plate, in order for the BlankReferenceAntigen to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectCompetitiveELISA or IndirectCompetitiveELISA, CoatingVolume is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankCoatingAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted BlankCoatingAntibody that is aliquoted into the ELISAPlate, in order for the BlankCoatingAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is FastELISA, the Option is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankCaptureAntibodyCoatingVolume,
				Default->Automatic,
				Description->"The amount of diluted BlankCaptureAntibody that is aliquoted into the ELISAPlate, in order for the BlankCaptureAntibody to be adsorbed to the surface of the well.",
				ResolutionDescription->"If Method is DirectSandwichELISA or IndirectSandwichELISA, the option is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankBlockingVolume,
				Default->Automatic,
				Description->"The amount of BlankBlockingBuffer that is aliquoted into the appropriate wells of the ELISAPlate.",
				ResolutionDescription->"If Blocking is True, the option is automatically set to 200 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,300 Microliter],
					Units->Microliter
				]
			},
			{
				OptionName->BlankAntibodyComplexImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the BlankAntibodyComplex to be loaded on the ELISAPlate. In DirectCompetitiveELISA and IndirectCompetitiveELISA, this step enables the free primary antibody to bind to the ReferenceAntigen coated on the plate. In FastELISA, this step enables the PrimaryAntibody-TargetAntigen-CaptureAntibody complex to bind to the CoatingAntibody on the plate.",
				ResolutionDescription->"If the Method is set to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->BlankImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the Blank to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in DirectSandwichELISA and IndirectSandwichELISA.",
				ResolutionDescription->"If the Method is set to DirectSandwichELISA and IndirectSandwichELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->BlankPrimaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the BlankPrimaryAntibody to be loaded on the ELISAPlate for Immunosorbent assay.",
				ResolutionDescription->"If the Method is set to DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwichELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->BlankSecondaryAntibodyImmunosorbentVolume,
				Default->Automatic,
				Description->"The volume of the Secondary Antibody to be loaded on the ELISAPlate for immunosorbent step.",
				ResolutionDescription->"If the Method is set to IndirectELISA, IndirectSandwichELISA, and IndirectCompetitiveELISA, the option is automatically set to 100 Microliter.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter]
				]
			},
			{
				OptionName->BlankSubstrateSolution,
				Default->Automatic,
				Description->"Defines the substrate solution for the Blank.",
				ResolutionDescription->"If enzyme is Horseredish Peroxidase, the option will be automatically set to Model[Sample,\"ELISA TMB Stabilized Chromogen\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate PNPP Solution\"].",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankStopSolution,
				Default->Automatic,
				Description->"The reagent that is used to stop the reaction between the enzyme and its substrate.",
				ResolutionDescription->"If enzyme is Horseradish Peroxidase, then the option is automatically set to Model[Sample,\"ELISA HRP-TMB Stop Solution\"]. If enzyme is Alkaline Phosphatase, then the option is automatically set to Model[Sample,\"AP Substrate Stop Solution\"].",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[{Model[Sample],Object[Sample]}]
				]
			},
			{
				OptionName->BlankSubstrateSolutionVolume,
				Default->Automatic,
				Description->"The volume of BlankSubstrateSolution to be added to the corresponding well.",
				ResolutionDescription->"If SubstrateSolution is populated, then the option is automatically set to 100ul.",

				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter, Milliliter]
				]
			},
			{
				OptionName->BlankStopSolutionVolume,
				Default->Automatic,
				Description->"The volume of BlankStopSolution to be added to the corresponding well.",
				ResolutionDescription->"If Model[Sample,\"ELISA TMB Stabilized Chromogen\"] or Model[Sample,\"ELISA HRP-TMB Stop Solution\"] is selected, the StopSolutionVolume is automatically set to 100ul.",
				AllowNull->True,
				Category->"Blank",
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Microliter,200 Microliter],
					Units->Alternatives[Microliter, Milliliter]
				]
			}

		],

		(*===============================================*)
		(*=========ELISA Plate And Assignment============*)
		(*===============================================*)
		{
			OptionName->ELISAPlate,
			Default->Automatic,
			Description->"The assay plate each sample, standard, and blank will be loaded into and the immunosorbent assay will take place. This plate can be pre-coated and blocked in advance.",
			ResolutionDescription->"The option will be automatically set to an optical, flat-bottom 96 well plate made with polystyrene. If Samples are pre-coated to the a plate, the option will be automatically set to this plate.",
			AllowNull->False,
			Category->"Assay Plate",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Container,Plate],Object[Container,Plate]}]
			]
		},
		{
			OptionName->SecondaryELISAPlate,
			Default->Automatic,
			Description->"The second assay plate, if needed.",
			ResolutionDescription->"If the total number of Sample (including spiked samples and dilutions), standards, and blanks, times NumberOfReplications exceeds 96, then the option will be automatically set to an optical, flat-bottom 96 well plate made with polystyrene. If Samples are pre-coated to two plates, the option will be automatically set to the second plate.",
			AllowNull->True,
			Category->"Assay Plate",
			Widget->Widget[
				Type->Object,
				Pattern:>ObjectP[{Model[Container,Plate],Object[Container,Plate]}]
			]
		},
		{
			OptionName->ELISAPlateAssignment,
			Default->Automatic,
			Description->"Specifies the placement of samples and their corresponding spikes, dilutions, and antibodies in the first ELISAPlate.",
			ResolutionDescription->"Samples are automatically assigned according to the input sequence (UnknownSamples,Standards,Blanks), to the ELISAPlate from the A1 position, consecutively, in a column-wise fashion. Each sample and their dilution curve will be placed next to each other, then each replicates are placed next to each other. When samples are pre-coated onto the plate, they are arranged from the A1 position, consequtively, in a column-wise fashion,regardless of the input sequence. If the first plate cannot accommodate all the samples, the samples will automatically be assigned to the SecondaryELISAPlate. Due to possible plate-to-plate variations, when two plates are needed, users are recommended to rearrange the samples so that the samples, standards, and blanks that are detected using the same conditions (i.e. same experiment) should be placed in the same plate. If impossible, additional standards and blanks should be included so that each sample has a corresponding set of standards and blanks on the same plate.",
			AllowNull->False,
			Category->"Assay Plate",
			Widget->Adder[
				{
					"Type"->Widget[
						Type->Enumeration,
						Pattern:>Unknown|Spike|Standard|Blank
					],
					"Sample"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"Spike"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SpikeDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleDilutionFactors"->Adder[
						Widget[Type->Number,Pattern:>RangeP[0,1]]
					],
					"CoatingAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CoatingAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CaptureAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CaptureAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"ReferenceAntigen"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"ReferenceAntigenDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"PrimaryAntibody"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"PrimaryAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CoatingVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"BlockingVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,300Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleAntibodyComplexImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"PrimaryAntibodyImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibodyImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SubstrateSolution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"StopSolution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"SubstrateSolutionVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"StopSolutionVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					]
				}
			]
		},
		{
			OptionName->SecondaryELISAPlateAssignment,
			Default->Automatic,
			Description->"Specifies the placement of samples and their corresponding spikes, dilutions, and antibodies in the second ELISAPlate.",
			ResolutionDescription->"Samples are automatically assigned according to the input sequence (UnknownSamples,Standards,Blanks), to the ELISAPlate from the A1 position, consecutively, in a column-wise fashion. Each sample and their dilution curve will be placed next to each other, then each replicates are placed next to each other. When samples are pre-coated onto the plate, they are arranged from the A1 position, consequtively, in a column-wise fashion,regardless of the input sequence. If the first plate cannot accommodate all the samples, the samples will automatically be assigned to the SecondaryELISAPlate. Due to possible plate-to-plate variations, when two plates are needed, users are recommended to rearrange the samples so that the samples, standards, and blanks that are detected using the same conditions (i.e. same experiment) should be placed in the same plate. If impossible, additional standards and blanks should be included so that each sample has a corresponding set of standards and blanks on the same plate.",
			AllowNull->True,
			Category->"Assay Plate",
			Widget->Adder[
				{
					"Type"->Widget[
						Type->Enumeration,
						Pattern:>Unknown|Spike|Standard|Blank
					],
					"Sample"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"Spike"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SpikeDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleDilutionFactors"->Adder[
						Widget[Type->Number,Pattern:>RangeP[0,1]]
					],
					"CoatingAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CoatingAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CaptureAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CaptureAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"ReferenceAntigen"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"ReferenceAntigenDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"PrimaryAntibody"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"PrimaryAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibody"->Alternatives[
						Widget[Type->Object,Pattern:>ObjectP[{Model[Sample], Object[Sample]}],ObjectTypes->{Model[Sample], Object[Sample]}],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibodyDilutionFactor"->Alternatives[
						Widget[Type->Number,Pattern:>RangeP[0,1]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"CoatingVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"BlockingVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,300Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleAntibodyComplexImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SampleImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"PrimaryAntibodyImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SecondaryAntibodyImmunosorbentVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"SubstrateSolution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"StopSolution"->Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Sample], Object[Sample]}],
						ObjectTypes->{Model[Sample], Object[Sample]}
					],
					"SubstrateSolutionVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					],
					"StopSolutionVolume"->Alternatives[
						Widget[Type->Quantity,Units->Alternatives[Microliter],Pattern:>RangeP[0 Microliter,200Microliter]],
						Widget[Type->Enumeration,Pattern:>Alternatives[Null]]
					]
				}
			]
		},
		(* ================Shared options================ *)
		ModelInputOptions,
		QueuePositionOption,
		PriorityOption,
		HoldOrderOption,
		StartDateOption,
		NonBiologyFuntopiaSharedOptions,
		SamplesInStorageOptions,
		SimulationOption
		(*No SampleOut*)
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentELISA Errors and Warnings*)
Error::ELISANoneLiquidSample="The sample `1` are not in liquid form. Please resuspend them before proceeding to experiment.";
Error::MasterConflictingUnullOptions="When `1`, options `2` must be Null.";
Error::MasterConflictingNullOptions="When `1`, options `2` must Not be Null.";
Error::IndexedSameNullConflictingOptions="For options `1`, each value IndexMatched to the same sample must be specified as all Null or all Unull at the same time.";
Error::EitherOrConflictingOptions="Among options `1`, not more than one can be specified as an Unull value, and they cannot be all Null either.";
Error::NotMoreThanOneConflictingOptions="Among options `1`,  not more than one can be specified as an Unull value, but they can be all Null.";
Error::MethodConflictingSampleAntibodyIncubationSwitch="The specified ELISA Method is not compatible with SampleAntibodyIncubation. Please set it to False or change Method to DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA.";
Error::SpecifyDiluentAndDilutionCurveTogether="If one of `1` is specified, `2` must be specified. If `1` are both Null, `2` must also be Null.";
Error::DilutionCurveOptionsTotalVolumeTooLarge="SampleSerialDilutionCurve option values corresponding to samples `1`, SampleDilutionCurve option values corresponding to sample `2`, StandardSerialDilutionCurve option values corresponding to standard samples `3`, StandardDilutionCurve option values corresponding to standard samples `4` are too large for the dilution container. Please limit the total volume within the container to 1.9ML.";
Error::SecondaryAntibodyDilutionVolumeTooLarge="When SecondaryAntibodyDilutionOnDeck is set to True, the final diluted SecondaryAntibodies must be able to fit in a single SecondaryAntibodyContainer which is set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]. Currently, `1` well(s) are needed with a max volume at `2` which is beyond SecondaryAntibodyDilutionOnDeck dilution capacity. Please lower the SecondaryAntibodyVolume or increase the SecondaryAntibodyDilutionFactor to submit a valid experiment or set SecondaryAntibodyDilutionOnDeck to False.";
Error::AntibodyVolumeIncompatibility="`1` should be equal to or larger than `2`. Option values corresponding to samples `3` do not conform to this rule.";
Error::SampleVolumeShouldNotBeLargerThan50ml="The total working capacity of two 96 well plates is 48 ml. Please do not provide more than that volume of samples.";
Error::ElisaIncompatibleContainer="ELISAPlate And SecondaryELISAPlate must both be 96-well optical microplates that are compatible with the NIMBUS.";
Error::UnresolvableIndexMatchedOptions="We are unable to automatically resolve these options: `1`, but it is required for your experiment. Please provide specified Model[Sample] or Object[Sample] manually.";
Warning::ElisaImproperContainers="Polypropylene and Cycloolefine are low protein-binding materials. Choosing these as ELISA plate is likely to affect your results. Consider using a PolyStyrene or other high-protein-binding plate instead. We recommend `2`.";
Warning::ELISANoStandardForExperiment="Typically standard is needed for a quantitative ELISA experiment but the current value is Null. If desired, please specify one or more Model[Sample] or Object[Sample] as Standard.";
Warning::ELISANoBlankForExperiment="Typically blank is needed for a quantitative ELISA experiment but the current value is Null. If desired, please specify one or more Model[Sample] or Object[Sample] as Blank.";
Warning::CoatingButNoBlocking="Coating is True but Blocking is False. We recommend setting Blocking to True for the best ELISA result.";
Error::PrimaryAntibodyPipettingVolumeTooLow="After combining all the same primary antibodies with the same dilution rate. Primary antibodies with dilution factors `1` still require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antibodies using ExperimentSamplePreparation or increase the working concentration of the antibodies.";
Error::SecondaryAntibodyPipettingVolumeTooLow="After combining all the same secondary antibodies with the same dilution rate. Secondary antibodies with dilution factors `1` still require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antibodies using ExperimentSamplePreparation or increase the working concentration of the antibodies.";
Error::CoatingAntibodyPipettingVolumeTooLow="After combining all the same coating antibodies with the same dilution rate. Coating antibodies with dilution factors `1` still require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antibodies using ExperimentSamplePreparation or increase the working concentration of the antibodies.";
Error::CaptureAntibodyPipettingVolumeTooLow="After combining all the same capture antibodies with the same dilution rate. Capture antibodies with dilution factors `1` still require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antibodies using ExperimentSamplePreparation or increase the working concentration of the antibodies.";
Error::ReferenceAntigenPipettingVolumeTooLow="After combining all the same reference antigens with the same dilution rate. Reference antigens with dilution factors `1` still require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antigens using ExperimentSamplePreparation or increase the working concentration of the antigens.";
Error::DilutionCurvesPipettingVolumeTooLow="The dilution curves corresponding to `1` at dilution `2` require pipetting volumes of less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on your antibodies using ExperimentSamplePreparation or increase the working concentration of the antibodies.";
Error::SpikePipettingVolumeTooLow="The pipetting volume(s) of the spike sample(s) `1` is less than 1 Microliter, which cannot be performed accurately. We recommend performing an intermediate dilution on the spike sample(s) using ExperimentSamplePreparation.";
Error::PlateAssignmentExceedsAvailableWells="The `1` exceeds the number of wells available in this plate (96). Please note that the plate assignment will be expanded to include the number of replicates and dilution curves. Reduce the number of samples or number of replicates or consider submitting an additional protocol.";
Error::PlateAssignmentDoesNotMatchOptions="The `1` does not match the options given for each object.";
Error::PlateAssignmentIsNotColumnWise="The ELISAPlateAssignment and SecondaryELISAPlateAssignment do not follow an column-wise order, which is mandatory when samples are pre-coated onto the ELISA plate(s).";
Error::PrecoatedSamplesCannotBeAliquoted="When samples are coated onto ELISA plates, no aliquot should be performed for sample preparation. Please check the specifications of `1`.";
Error::SpecifySpikeWithFixedDilutionCurve="When spike is specified, spiked sample cannot be diluted using SampleDilutionCurve. Please use SampleSerialDilutionCurve instead.";
Error::TooManyContainersForELISADeck="The experiment can only accept up to 32 unique 2mL tubes and up to 8 unique 50mL tubes due to the limited space on the liquid handler deck. Please use fewer numbers of unique antibody samples in this experiment or consider submit another protocol.";
Error::ContainerlessSamples="The samples `1` are not in a container. Please make sure their containers are accurately uploaded.";
Error::SamplesWithoutVolume="The samples `1` do have no volume or 0 Liter recorded as volume. Please make sure correct sample volumes are uploaded for these samples.";
Warning::NegativeDiluentVolume="A diluent volume is calculated to be negative in your sample or standard dilution. This is typically cause by the total volumes of concentrated spike, primary antibody, or capture antibody exceeding the diluent volume specified in your dilution curves. Note that the volumes of these additives to your samples count towards the volume of diluent. If you think these volumes are too small to make a difference in the total volume, you can ignore this message and the diluent volume will be rounded up to 0 Microliters and your specified volumes of spike, primary antibodies, and capture antibodies to be mixed with samples will not be changed.";
Error::SameSampleDifferentSorage="Objects `1` in options `2` are specified multiple times with different storage conditions. The same object must have the same storage condition for proper storage after experiment.";
Error::StandardOrBlankReagentsNotForSample="Options `1` used in Standard and Blanks contain objects that are not found in options for samples. Please double check and be sure to only included reagents for Standard and Blanks that are also used for samples.";
Error::PreCoatedSamplesIncompatiblePlates="Pre-coated Samples `1` are not in compatible containers. This is either because sample containers are not in liquid-handler-compatible 96 well microplates, or because the total number of plates is more than 2. Please double check your sample containers and try again.";
Error::ObjectAndCorrespondingModelMustNotCoexist="Objects `1` and their corresponding Model[Sample] are both specified in the same options `2`. Please make sure an object and their Model do not co-exist in the same option.";
Error::ELISAInvalidPrereadTimepoints="The `1` timepoints for PrereadTimepoints are either less equals to 0 Minute or is larger than SubstrateIncubationTime, `2`. Please only specified number less than SubstrateIncubationTime, `2`.";
Error::ELISAInvalidPrereadOptions="The following options `2` are not consistent with PrereadBeforeStop, if PrereadBeforeStop is `1`, make sure `3`.";
Warning::Measure620WithCorrection="620 Nanometer is specified in AbsorbanceWavelength or PrereadAbsorbanceWavelength while SignalCorrection is True. Note that, if continue, the correction wavelength (which is is always 620 Nanometers) will be turned off when reading an AbsorbanceWavelength or PrereadAbsorbanceWavelength at 620 Nanometers. Other wavelengths, if specified, will not be affected.";

(* ::Subsection::Closed:: *)
(*ExperimentELISA Main Function*)

(* ::Subsubsection::Closed:: *)
(*ExperimentELISA Main Function Samples as Object[Sample]*)

ExperimentELISA[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[ExperimentELISA]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,cacheBall,
		resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,protocolObject,resourcePackets,resourcePacketTests,suppliedStandard,
		suppliedBlank,listedStandard,listedBlank,processedListedOptions,listedIndexMatchingParentOptions,objectSampleFields,modelSampleFields,analyteFields,
		antibodyFields,objectSampleAllFields,modelSampleAllFields,optionsWithObjects,allObjects,moleculeObjects,sampleObjects,modelSampleObjects,
		modelContainerFields,objectContainerFields,allOptionObjects,modelContainerObjects,objectContainerObjects,allOptical96WellMicroplates,
		modelMoleculeAllFields,modelContainerAllFields,objectContainerAllFields,stockedItems,allLHCompatibleOptical96WellMicroplates,resolverPassDownAssociation,
		listedSamples,mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,safeOpsNamed, cache
	},

	(* Make sure we're working with a list of options *)
	{listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];
	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Add a special step here to make sure we are working on a list of Standard because they are index matching parents in ExperimentELISA. If they are not in a list, the ValidInputLengthsQ may not be able to catch the length conflict in the options. Also the ExpandIndexMatchedInputs cannot successfully expand the options into a list either.
For example, if we have Standard->Model[Sample,"Milli-Q water"],StandardResuspension->{True,False}, ValidInputLengthsQ cannot recognize the issue.
Another example, if we have Standard->Model[Sample,"Milli-Q water"],StandardResuspension->True, we are not getting a list after ExpandIndexMatchedInputs. If we do Standard->{Model[Sample,"Milli-Q water"]},StandardResuspension->True, we will automatically get StandardResuspension->{True}. Then we don't need to worry about working with an option that is not a list.
We do not worry about input samples because our option is from myOptionsWithPreparedSamples and our function simulateSamplePreparationPacketsNew takes in ToList[mySamples].

 Note that we have kept Standard as Null if they are specified as so. We check in our resolver that when they are Null, the options that are index matched to these options must also be Null. We don't check them here.*)

	suppliedStandard=Lookup[listedOptions,Standard,Automatic];
	listedStandard=ToList[suppliedStandard];
	suppliedBlank=Lookup[listedOptions,Blank,Automatic];
	listedBlank=ToList[suppliedBlank];
	listedIndexMatchingParentOptions={Standard->listedStandard,Blank->listedBlank};

	processedListedOptions=Normal[Join[Association[listedOptions],Association[listedIndexMatchingParentOptions]]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentELISA,
			listedSamples,
			processedListedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];


	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTests,
		SafeOptions[ExperimentELISA,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentELISA,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	{mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOpsNamed,myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOpsTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentELISA,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentELISA,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],{}}
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
		ApplyTemplateOptions[ExperimentELISA,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentELISA,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],{}}
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

	(* Expand index-matching options. This also includes the expansion of Standard and Blank related options with
	Standard and Blank as IndexMatchingParent *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentELISA,{ToList[mySamplesWithPreparedSamples]},
		inheritedOptions]];

	cache = Lookup[expandedSafeOps,Cache,{}];



	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)


	(* Fields to download from all samples - include mySamples, Standard samples, Spike samples, Antibody samples and other reagents *)
	(* Define all the fields that we want *)
	modelSampleFields=SamplePreparationCacheFields[Model[Sample]];
	objectSampleFields=Join[SamplePreparationCacheFields[Object[Sample]],{RequestedResources}];
	analyteFields={Name,Object,Antibodies,DefaultSampleModel,State,MolecularWeight};
	antibodyFields={Name,Object,Targets,Organism,SecondaryAntibody,DefaultSampleModel,State,AffinityLabels,DetectionLabels,MolecularWeight};
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];

	(* Fields to download from analytes or other molecules *)
	modelMoleculeAllFields={
		Packet[Sequence@@analyteFields],
		Packet[Sequence@@antibodyFields],
		Packet[DefaultSampleModel[modelSampleFields]],
		Packet[Antibodies[antibodyFields]],
		Packet[Antibodies[DefaultSampleModel][modelSampleFields]],
		Packet[AffinityLabels[Antibodies][antibodyFields]],
		Packet[Antibodies[AffinityLabels][Antibodies][antibodyFields]],
		Packet[Targets[Antibodies][AffinityLabels][Antibodies][antibodyFields]]

	};
	(* Fields to download from all sample models (not including mySamples, which cannot be Model[Sample]) *)
	modelSampleAllFields={
		Packet[Sequence@@objectSampleFields],
		Packet[Analytes[analyteFields]],
		Packet[Analytes[antibodyFields]],
		Packet[Analytes[DefaultSampleModel][modelSampleFields]],
		Packet[Analytes[Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][DefaultSampleModel][modelSampleFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][AffinityLabels][analyteFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][DefaultSampleModel][modelSampleFields]]
	};
	(* Fields to download for all sample objects*)
	objectSampleAllFields={
		Packet[Sequence@@objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Analytes[analyteFields]],
		Packet[Analytes[DefaultSampleModel][modelSampleFields]],
		Packet[Analytes[Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][DefaultSampleModel][modelSampleFields]],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][AffinityLabels][analyteFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][DefaultSampleModel][modelSampleFields]]

	};
	(* Model container fields *)
	modelContainerAllFields={
		Packet[Sequence@@modelContainerFields]
	};
	(* Object container fields*)
	objectContainerAllFields={
		Packet[Sequence@@objectContainerFields],
		Packet[Model[modelContainerFields]],
		(* Coating is a computable field so don't need to download from object too, just get from Model *)
		(*Packet[Coating[analyteFields]],
		Packet[Coating[antibodyFields]],
		Packet[Coating[DefaultSampleModel][modelSampleFields]],
		Packet[Coating[Antibodies][antibodyFields]],
		Packet[Coating[Antibodies][DefaultSampleModel][modelSampleFields]],
		Packet[Coating[Antibodies][AffinityLabels][Antibodies][antibodyFields]],
		Packet[Coating[Antibodies][AffinityLabels][analyteFields]],
		Packet[Coating[Antibodies][AffinityLabels][Antibodies][DefaultSampleModel][modelSampleFields]],*)
		Packet[Model[Coating][analyteFields]],
		Packet[Model[Coating][antibodyFields]],
		Packet[Model[Coating][DefaultSampleModel][modelSampleFields]],
		Packet[Model[Coating][Antibodies][antibodyFields]],
		Packet[Model[Coating][Antibodies][DefaultSampleModel][modelSampleFields]],
		Packet[Model[Coating][Antibodies][AffinityLabels][Antibodies][antibodyFields]],
		Packet[Model[Coating][Antibodies][AffinityLabels][analyteFields]],
		Packet[Model[Coating][Antibodies][AffinityLabels][Antibodies][DefaultSampleModel][modelSampleFields]]

	};



	(* Any options whose values could be an object and whose fields will be used for resolving other options *)
	optionsWithObjects={
		TargetAntigen, Spike,
		CoatingAntibody, CaptureAntibody,
		ReferenceAntigen,PrimaryAntibody, SecondaryAntibody,
		Standard,
		StandardTargetAntigen, StandardCoatingAntibody,
		StandardCaptureAntibody, StandardReferenceAntigen,
		StandardPrimaryAntibody, StandardSecondaryAntibody,
		Blank,
		BlankTargetAntigen, BlankCoatingAntibody, BlankCaptureAntibody,
		BlankReferenceAntigen, BlankPrimaryAntibody, BlankSecondaryAntibody,
		ELISAPlate,SecondaryELISAPlate,ELISAPlateAssignment,SecondaryELISAPlateAssignment,
		(* These should be checked for existence as well *)
		WashingBuffer,SampleDiluent,CoatingAntibodyDiluent,CaptureAntibodyDiluent,ReferenceAntigenDiluent,PrimaryAntibodyDiluent,SecondaryAntibodyDiluent,BlockingBuffer,SubstrateSolution,StopSolution,StandardDiluent,StandardSubstrateSolution,StandardStopSolution,BlankSubstrateSolution,BlankStopSolution
	};
	allOptionObjects=Lookup[expandedSafeOps,optionsWithObjects];

	(*Stock secondary antibodies*)
	stockedItems={

		Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"],
		Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Rabbit-IgG Secondary Antibody"],
		Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Rat-IgG Secondary Antibody"],
		Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Chicken-IgY Secondary Antibody"],
		Model[Molecule,Protein,Antibody,"HRP-Conjugated Donkey-Anti-Goat-IgG Secondary Antibody"],
		Model[Molecule,Protein,Antibody,"HRP-Conjugated Rabbit-Anti-Human-IgG Secondary Antibody"]

	};

	(* Pull out all 96 well microplate Models*)
	allOptical96WellMicroplates=Search[Model[Container, Plate],
		NumberOfWells === 96 && Footprint === Plate &&
			Dimensions[[3]] >= 0.014 Meter && Dimensions[[3]] <= 0.016 Meter &&
			WellColor === Clear && KitProducts === {}&&DeveloperObject==(False|Null), SubTypes -> False];
	allLHCompatibleOptical96WellMicroplates =Cases[allOptical96WellMicroplates,
		Alternatives @@ Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling]
	];



	(* Flatten and merge all possible objects needed into a list *)
	allObjects=DeleteDuplicates[
		Cases[
			Flatten@Join[
				listedSamples,
				mySamplesWithPreparedSamples,
				allLHCompatibleOptical96WellMicroplates,
				allOptionObjects,
				stockedItems
			],
			ObjectP[]
		]
	];


	(* Isolate objects of particular types so we can build an indexed-download call *)
	moleculeObjects=Cases[allObjects,ObjectP[Model[Molecule]]];
	sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];
	modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
	modelContainerObjects=Cases[allObjects,ObjectP[Model[Container,Plate]]];
	objectContainerObjects=Cases[allObjects,ObjectP[Object[Container,Plate]]];

	(* Make one download for all possible parameters needed *)
	cacheBall=Quiet[
		FlattenCachePackets[
			{
				cache,
				Download[
					{
						moleculeObjects,
						sampleObjects,
						modelSampleObjects,
						modelContainerObjects,
						objectContainerObjects
					},
					{
						modelMoleculeAllFields,
						objectSampleAllFields,
						modelSampleAllFields,
						modelContainerAllFields,
						objectContainerAllFields
					},
					Cache->cache,
					Simulation -> updatedSimulation,
					Date->Now
				]
			}
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{{resolvedOptions,resolvedOptionsTests},resolverPassDownAssociation}=resolveExperimentELISAOptions[listedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation, Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolverPassDownAssociation,resolvedOptionsTests}=Append[resolveExperimentELISAOptions[listedSamples,expandedSafeOps,Cache->cacheBall,Simulation -> updatedSimulation],{}],
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentELISA,
		resolvedOptions,
		Ignore->ToList[myOptions],
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentELISA,collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTests,
		elisaResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,resolverPassDownAssociation,Cache->cacheBall, Simulation -> updatedSimulation, Output->{Result,Tests}],
		{elisaResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,resolverPassDownAssociation,Cache->cacheBall, Simulation -> updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result->Null,
			Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options->RemoveHiddenOptions[ExperimentELISA,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[resolvedOptions,Upload],
			Confirm->Lookup[resolvedOptions,Confirm],
			CanaryBranch->Lookup[resolvedOptions,CanaryBranch],
			ParentProtocol->Lookup[resolvedOptions,ParentProtocol],
			Priority->Lookup[resolvedOptions,Priority],
			StartDate->Lookup[resolvedOptions,StartDate],
			HoldOrder->Lookup[resolvedOptions,HoldOrder],
			QueuePosition->Lookup[resolvedOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,ELISA],
			Cache->cacheBall,
			Simulation -> updatedSimulation
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result->protocolObject,
		Tests->Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options->RemoveHiddenOptions[ExperimentELISA,collapsedResolvedOptions],
		Preview->Null,
		Simulation->Null
	}
];


(* ::Subsubsection::Closed:: *)
(*Experiment function overload that takes container as input*)
(* Note: The container overload should come after the sample overload. *)
ExperimentELISA[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,containerToSampleResult,containerToSampleOutput,sampleCache,samples,sampleOptions,containerToSampleTests,listedContainers, updatedSimulation, containerToSampleSimulation},

	(* Make sure we're working with a list of options *)
	{listedContainers, listedOptions}= {ToList[myContainers], ToList[myOptions]};

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentELISA,
			listedContainers,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		Return[$Failed]
	];


	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentELISA,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleSampleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation}=containerToSampleOptions[
				ExperimentELISA,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output->{Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result->$Failed,
			Tests->containerToSampleTests,
			Options->$Failed,
			Preview->Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentELISA[samples,ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
	]
];



(*==============================================================================*)
(*==========================Option Resolver=====================================*)
(*==============================================================================*)


(* ::Subsection::Closed:: *)
(* resolveExperimentELISAOptions Helper Function*)

DefineOptions[
	resolveExperimentELISAOptions,
	Options:>{HelperOutputOption,CacheOption, SimulationOption}
];

resolveExperimentELISAOptions[
	mySamples:{ObjectP[Object[Sample]]...},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification, output, gatherTests, messages, cache,samplePrepOptions, elisaOptions, simulatedSamples,
		resolvedSamplePrepOptions, simulatedSamplePackets,simulatedSampleContainers, simulatedSampleContainerModels,
		samplePackets, discardedSamplePackets, discardedTests, rawoptionsWithSamples, optionsWithSamples,objectsFromOptions, objectsFromOptionsPackets,
		nonLiquidSamplePackets, nonLiquidSampleInvalidInputs,nonLiquidSampleTests, samplePrepTests, elisaOptionsAssociation,
		invalidInputs, invalidOptions, targetContainers,resolvedAliquotOptions, aliquotTests,aliquotOptionsToBeRounded,aliquotPrecisions,
		roundedAliquotOptions,transformedStandardDilutionCurve, transformedStandardSerialDilutionCurve,transformedSampleSerialDilutionCurve,
		transformedSampleDilutionCurve, elisaOptionsAssociationCurvesFixed, optionsToBeRounded,roundedExperimentOptions, precisionTests,
		roundedExperimentOptionsList, suppliedMethod, suppliedTargetAntigen,suppliedNumberOfReplicates,suppliedSampleDiluent, suppliedWashingBuffer,
		suppliedCoatingAntibody, suppliedCoatingAntibodyDilutionFactor,suppliedCoatingAntibodyVolume, suppliedCoatingAntibodyDiluent,
		suppliedCoatingAntibodyStorageCondition, suppliedCaptureAntibody,suppliedCaptureAntibodyDilutionFactor, suppliedCaptureAntibodyVolume,
		suppliedCaptureAntibodyDiluent,suppliedCaptureAntibodyStorageCondition, suppliedReferenceAntigen,suppliedReferenceAntigenDilutionFactor,
		suppliedReferenceAntigenVolume, suppliedReferenceAntigenDiluent,suppliedReferenceAntigenStorageCondition, suppliedPrimaryAntibody,
		suppliedPrimaryAntibodyDilutionFactor, suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyStorageCondition,
		suppliedSecondaryAntibody,suppliedSecondaryAntibodyDilutionFactor,suppliedSecondaryAntibodyVolume, suppliedSecondaryAntibodyDiluent,
		suppliedSecondaryAntibodyStorageCondition,suppliedSampleAntibodyComplexIncubation,suppliedSampleAntibodyComplexIncubationTime,
		suppliedSampleAntibodyComplexIncubationTemperature, suppliedCoating,suppliedSampleCoatingVolume, suppliedCoatingAntibodyCoatingVolume,
		suppliedReferenceAntigenCoatingVolume,suppliedCaptureAntibodyCoatingVolume, suppliedCoatingTemperature,suppliedCoatingTime,
		suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes, suppliedBlocking,suppliedBlockingBuffer, suppliedBlockingVolume,
		suppliedBlockingTemperature, suppliedBlockingTime,suppliedBlockingWashVolume, suppliedBlockingNumberOfWashes,
		suppliedSampleAntibodyComplexImmunosorbentVolume,suppliedSampleAntibodyComplexImmunosorbentTime,suppliedSampleAntibodyComplexImmunosorbentTemperature,
		suppliedSampleAntibodyComplexImmunosorbentWashVolume,suppliedSampleAntibodyComplexImmunosorbentNumberOfWashes,suppliedSampleImmunosorbentVolume,
		suppliedSampleImmunosorbentTime,suppliedSampleImmunosorbentTemperature,suppliedSampleImmunosorbentMixRate,suppliedSampleImmunosorbentWashVolume,
		suppliedSampleImmunosorbentNumberOfWashes,suppliedPrimaryAntibodyImmunosorbentVolume,suppliedPrimaryAntibodyImmunosorbentTime,
		suppliedPrimaryAntibodyImmunosorbentTemperature,suppliedPrimaryAntibodyImmunosorbentMixRate,suppliedPrimaryAntibodyImmunosorbentWashVolume,
		suppliedPrimaryAntibodyImmunosorbentNumberOfWashes,suppliedSecondaryAntibodyImmunosorbentVolume,suppliedSecondaryAntibodyImmunosorbentTime,
		suppliedSecondaryAntibodyImmunosorbentTemperature,suppliedSecondaryAntibodyImmunosorbentMixRate,suppliedSecondaryAntibodyImmunosorbentWashVolume,
		suppliedSecondaryAntibodyImmunosorbentNumberOfWashes,suppliedSubstrateSolution, suppliedStopSolution,suppliedSubstrateSolutionVolume,
		suppliedStopSolutionVolume,suppliedSubstrateIncubationTime,suppliedSubstrateIncubationTemperature,suppliedSubstrateIncubationMixRate,
		suppliedAbsorbanceWavelength,suppliedSignalCorrection, suppliedStandard,suppliedStandardTargetAntigen, suppliedStandardDilutionCurve,
		suppliedStandardSerialDilutionCurve, suppliedStandardDiluent,suppliedStandardStorageCondition, suppliedStandardCoatingAntibody,
		suppliedStandardCoatingAntibodyDilutionFactor,suppliedStandardCoatingAntibodyVolume,suppliedStandardCoatingAntibodyStorageCondition,
		suppliedStandardCaptureAntibody,suppliedStandardCaptureAntibodyDilutionFactor,suppliedStandardCaptureAntibodyVolume,
		suppliedStandardCaptureAntibodyStorageCondition,suppliedStandardReferenceAntigen,suppliedStandardReferenceAntigenDilutionFactor,
		suppliedStandardReferenceAntigenVolume,suppliedStandardReferenceAntigenStorageCondition,suppliedStandardPrimaryAntibody,
		suppliedStandardPrimaryAntibodyDilutionFactor,suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyStorageCondition,
		suppliedStandardSecondaryAntibody,suppliedStandardSecondaryAntibodyDilutionFactor,suppliedStandardSecondaryAntibodyVolume,
		suppliedStandardSecondaryAntibodyStorageCondition,suppliedStandardCoatingVolume,suppliedStandardReferenceAntigenCoatingVolume,
		suppliedStandardCoatingAntibodyCoatingVolume,suppliedStandardCaptureAntibodyCoatingVolume,suppliedStandardBlockingVolume,
		suppliedStandardAntibodyComplexImmunosorbentVolume,suppliedStandardImmunosorbentVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume,
		suppliedStandardSecondaryAntibodyImmunosorbentVolume,suppliedStandardSubstrateSolution,suppliedStandardStopSolution,suppliedStandardSubstrateSolutionVolume,
		suppliedStandardStopSolutionVolume, suppliedBlank,suppliedBlankTargetAntigen, suppliedBlankCoatingAntibody,suppliedBlankCoatingAntibodyDilutionFactor,
		suppliedBlankCoatingAntibodyVolume,suppliedBlankCoatingAntibodyStorageCondition,suppliedBlankCaptureAntibody,suppliedBlankCaptureAntibodyDilutionFactor,
		suppliedBlankCaptureAntibodyVolume,suppliedBlankCaptureAntibodyStorageCondition,suppliedBlankReferenceAntigen,suppliedBlankReferenceAntigenDilutionFactor,
		suppliedBlankReferenceAntigenVolume,suppliedBlankReferenceAntigenStorageCondition,suppliedBlankPrimaryAntibody,suppliedBlankPrimaryAntibodyDilutionFactor,
		suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyStorageCondition,suppliedBlankSecondaryAntibody,suppliedBlankSecondaryAntibodyDilutionFactor,
		suppliedBlankSecondaryAntibodyVolume,suppliedBlankSecondaryAntibodyStorageCondition,suppliedBlankCoatingVolume,suppliedBlankReferenceAntigenCoatingVolume,
		suppliedBlankCoatingAntibodyCoatingVolume,suppliedBlankCaptureAntibodyCoatingVolume,suppliedBlankBlockingVolume,suppliedBlankAntibodyComplexImmunosorbentVolume,
		suppliedBlankImmunosorbentVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume,suppliedBlankSecondaryAntibodyImmunosorbentVolume,
		suppliedBlankSubstrateSolution, suppliedBlankStopSolution,suppliedBlankSubstrateSolutionVolume,suppliedBlankStopSolutionVolume, suppliedSpike,
		suppliedSpikeDilutionFactor, suppliedSampleDilutionCurve,suppliedSampleSerialDilutionCurve, suppliedELISAPlate,suppliedSecondaryELISAPlate,
		combinedSampleDilutionCurve,combinedSampleDilutionFactorCurve,combinedStandardDilutionCurve,sampleDilutionNumbers, dilutionExpandedSamples,
		resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment,suppliedELISAPlateAssignment,suppliedSecondaryELISAPlateAssignment,resolvedSecondaryELISAPlate,
		standardIndexSwitchedOptions,standardConflictingUnullOptions, standardConflictingUnullTests,blankIndexSwitchedOptions, blankConflictingUnullOptions,blankConflictingUnullTests,
		directELISAMustNullSingleSampleOptions,directELISAMustNullIndexedOptions,indirectELISAMustNullSingleSampleOptions,indirectELISAMustNullIndexedOptions,
		directSandwichELISAMustNullSingleSampleOptions,directSandwichELISAMustNullIndexedOptions,indirectSandwichELISAMustNullSingleSampleOptions,indirectSandwichELISAMustNullIndexedOptions,
		directCompetitiveELISAMustNullSingleSampleOptions,directCompetitiveELISAMustNullIndexedOptions,indirectCompetitiveELISAMustNullSingleSampleOptions,
		indirectCompetitiveELISAMustNullIndexedOptions,fastELISAMustNullSingleSampleOptions, fastELISAMustNullIndexedOptions,directELISAMustUnullSingleSampleOptions,
		directELISAMustUnullIndexedOptions,indirectELISAMustUnullSingleSampleOptions,indirectELISAMustUnullIndexedOptions,directSandwichELISAMustUnullSingleSampleOptions,
		directSandwichELISAMustUnullIndexedOptions,indirectSandwichELISAMustUnullSingleSampleOptions,indirectSandwichELISAMustUnullIndexedOptions,
		directCompetitiveELISAMustUnullSingleSampleOptions,directCompetitiveELISAMustUnullIndexedOptions,indirectCompetitiveELISAMustUnullSingleSampleOptions,
		indirectCompetitiveELISAMustUnullIndexedOptions,fastELISAMustUnullSingleSampleOptions, fastELISAMustUnullIndexedOptions,methodConflictingUnullOptionsAll,
		methodConflictingNullOptionsAll,methodConflictingUnullTests, methodConflictingNullTests,directELISAEitherOrOptionGroups, indirectELISAEitherOrOptionGroups,
		indirectSandwichELISAEitherOrOptionGroups,directCompetitiveELISAEitherOrOptionGroups,indirectCompetitiveELISAEitherOrOptionGroup,fastELISAEitherOrOptionGroups,
		directELISAStandardEitherOrOptionGroups,indirectELISAStandardEitherOrOptionGroups,indirectSandwichELISAStandardEitherOrOptionGroups,
		directCompetitiveELISAStandardEitherOrOptionGroups,indirectCompetitiveELISAStandardEitherOrOptionGroup,fastELISStandardAEitherOrOptionGroups,
		directELISABlankEitherOrOptionGroups,indirectELISABlankEitherOrOptionGroups,indirectSandwichELISABlankEitherOrOptionGroups,directCompetitiveELISABlankEitherOrOptionGroups,
		indirectCompetitiveELISABlankEitherOrOptionGroup,fastELISABlankEitherOrOptionGroups, methodEitherOrConflictingOptions,methodEitherOrConflictingTests,
		methodEitherOrStandardConflictingOptions,methodEitherOrStandardConflictingTests,methodEitherOrBlankConflictingOptions,methodEitherOrBlankConflictingTests,
		methodConflictingSampleAntibodyIncubationConflictingOption,methodConflictingSampleAntibodyIncubationTest,sampleAntibodyComplexIncubationSwitchConflictingOptions,
		sampleAntibodyComplexIncubationSwitchConflictingTests,coatingSingleSampleOptions, blockingIncubationSingleSampleOptions,
		blockingWashingSingleSampleOptions, blockingIndexedOptions,coatingBlockingConflictingUnullOptions,coatingBlockingConflictingNullOptions,
		coatingBlockingConflictingUnullTests,coatingBlockingConflictingNullTests,coatingSwichedDirectELISASingleSampleOptions,
		coatingSwichedDirectELISAIndexedOptions,coatingSwichedSandwichELISASingleSampleOptions,coatingSwichedSandwichELISAIndexedOptions,
		coatingSwichedCompetitiveELISASingleSampleOptions,coatingSwichedCompetitiveELISAIndexedOptions,coatingSwichedfastELISASingleSampleOptions,
		coatingSwichedDirectELISAStandardSingleSampleOptions,coatingSwichedfastELISAIndexedOptions,coatingSwichedDirectELISAStandardIndexedOptions,
		coatingSwichedSandwichELISAStandardIndexedOptions,coatingSwichedCompetitiveELISAStandardIndexedOptions,coatingSwichedfastELISAStandardIndexedOptions,
		coatingSwichedDirectELISABlankIndexedOptions,coatingSwichedSandwichELISABlankIndexedOptions,coatingSwichedCompetitiveELISABlankIndexedOptions,
		coatingSwichedfastELISABlankIndexedOptions,coatingAndMethodConflictingUnullOptions, elisaVolumeIncompatibility,coatingAndMethodConflictingNullOptions,
		coatingAndMethodConflictingUnullTests,coatingAndMethodConflictingNullTests,coatingAndMethodConflictingStandardUnullOptions,
		coatingAndMethodConflictingStandardNullOptions,coatingAndMethodConflictingStandardUnullTests,coatingAndMethodConflictingStandardNullTests,
		coatingAndMethodConflictingBlankUnullOptions,coatingAndMethodConflictingBlankNullOptions,coatingAndMethodConflictingBlankUnullTests,
		coatingAndMethodConflictingBlankNullTests,coatingSwitchedFastELISABlankADilutionOptionGroup,coatingSwitchedCompetitiveELISABlankDilutionOptionGroup,
		coatingSwitchedSandwichELISABlankDilutionOptionGroup,coatingSwitchedFastELISAStandardADilutionOptionGroup,coatingSwitchedCompetitiveELISAStandardDilutionOptionGroup,
		coatingSwitchedSandwichELISAStandardDilutionOptionGroup,coatingSwitchedFastELISADilutionOptionGroup,coatingSwitchedCompetitiveELISADilutionOptionGroup,
		coatingSwitchedSandwichELISADilutionOptionGroup,coatingAndMethodConflictingDilutionOptions,coatingAndMethodConflictingDilutionOptionTests,
		coatingAndMethodConflictingDilutionStandardOptions,coatingAndMethodConflictingDilutionStandardOptionTests,coatingAndMethodConflictingDilutionBlankOptions,
		coatingAndMethodConflictingDilutionBlankOptionTests, substrateSameNullOptionNames,substrateSameNullOptionValues,
		substrateSolutionSameNullSameNullConflictingOptions,substrateSolutionSameNullConflictingTest,stopSolutionSameNullConflictingOptions,
		stopSolutionSameNullConflictingTest,standardSubstrateSolutionSameNullConflictingOptions,standardSubstrateSolutionSameNullConflictingTest,
		standardStopSolutionSameNullConflictingOptions,standardStopSolutionSameNullConflictingTest,blankSubstrateSolutionSameNullConflictingOptions,
		blankSubstrateSolutionSameNullConflictingTest,blankStopSolutionSameNullConflictingOptions,blankStopSolutionSameNullConflictingTest,
		standardDilutionCurveConflictingOptions,standardDilutionCurveConflictingTests,standardDiluentConflictingOptions, standardDiluentConflictingQ,
		StandardDilutionCurveDiluentConflictingTest,sampleDilutionCurveConflictingOptions,sampleDilutionCurveConflictingTests,
		SampleDiluentConflictingOptions,SampleDiluentConflictingQ,SampleDiluentConflictingTest, totalVolume,
		sampleSerialDilutionCurveOverflowBoolean,sampleDilutionCurveOverflowBoolean,standardSerialDilutionCurveOverflowBoolean,
		standardDilutionCurveOverflowBoolean,serialDilutionCurveOverflowSamples, dilutionCurveOverflowSamples,serialDilutionCurveOverflowStandards,
		dilutionCurveOverflowStandards,sampleSerialDilutionCurveOverflowQ, sampleDilutionCurveOverflowQ,standardSerialDilutionCurveOverflowQ,
		standardDilutionCurveOverflowQ,dilutionCurveOverflowOptions, dilutionCurveContainedOptions,directELISAVolumeCompatibilitySet,indirectELISAVolumeCompatibilitySet,
		directSandwichELISAVolumeCompatibilitySet,indirectSandwichELISAVolumeCompatibilitySet,directCompetitiveELISAVolumeCompatibilitySet,
		indirectCompetitiveELISAVolumeCompatibilitySet,fastELISAVolumeCompatibilitySet,DilutionCurveOptionsTotalVolumeTests,
		volumeIncompatibilityreturns,volumeIncompatibleOptions, volumeIncompatibleTests,defaultCoatingBuffer, defaultBlockingBuffer,
		methodSwitchedSuppliedSingleSampleOptions,directELISASwitchedAutoSingleSampleOptions,indirectELISASwitchedAutoSingleSampleOptions,
		directSandwichELISASwitchedAutoSingleSampleOptions,indirectSandwichELISASwitchedAutoSingleSampleOptions,directCompetitiveELISASwitchedAutoSingleSampleOptions,
		indirectCompetitiveELISASwitchedAutoSingleSampleOptions,FastELISASwitchedAutoSingleSampleOptions,resolvedSampleDiluent,
		resolvedStandardDiluent,resolvedCoatingAntibodyDiluent, resolvedCaptureAntibodyDiluent,resolvedReferenceAntigenDiluent, resolvedPrimaryAntibodyDiluent,
		resolvedSecondaryAntibodyDiluent,resolvedSampleAntibodyComplexIncubation,resolvedSampleAntibodyComplexImmunosorbentTime,
		resolvedSampleAntibodyComplexImmunosorbentTemperature,resolvedSampleAntibodyComplexImmunosorbentWashVolume,
		resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,resolvedSampleImmunosorbentTime,resolvedSampleImmunosorbentTemperature,
		resolvedSampleImmunosorbentWashVolume,resolvedSampleImmunosorbentNumberOfWashes,resolvedPrimaryAntibodyImmunosorbentTime,
		resolvedPrimaryAntibodyImmunosorbentTemperature,resolvedPrimaryAntibodyImmunosorbentWashVolume,resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,
		resolvedPrimaryAntibodyImmunosorbentWashing, resolvedSecondaryAntibodyImmunosorbentWashing,
		resolvedSecondaryAntibodyImmunosorbentTime,resolvedSecondaryAntibodyImmunosorbentTemperature,resolvedSecondaryAntibodyImmunosorbentWashVolume,
		resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,suppliedSampleChildrenValues, suppliedStandardChildrenValues,suppliedBlankChildrenValues,
		sampleChildrenNames,sampleMapThreadFriends, standardChildrenNames, blankMapThreadFriends,blankChildrenNames, standardMapThreadFriends,
		resolvedTargetAntigen,resolvedCoatingAntibody, resolvedCoatingAntibodyDilutionFactor,resolvedCoatingAntibodyStorageCondition, resolvedCaptureAntibody,
		resolvedCaptureAntibodyDilutionFactor,resolvedCaptureAntibodyStorageCondition, resolvedReferenceAntigen,resolvedReferenceAntigenDilutionFactor,
		resolvedReferenceAntigenStorageCondition, resolvedPrimaryAntibody,resolvedSecondaryAntibody, resolvedSecondaryAntibodyDilutionFactor,resolvedSecondaryAntibodyDilutionOnDeck,
		resolvedSecondaryAntibodyStorageCondition,resolvedSampleCoatingVolume, resolvedCoatingAntibodyCoatingVolume,resolvedReferenceAntigenCoatingVolume,
		resolvedCaptureAntibodyCoatingVolume, resolvedBlockingVolume,resolvedSampleAntibodyComplexImmunosorbentVolume,resolvedSampleImmunosorbentVolume,
		resolvedPrimaryAntibodyImmunosorbentVolume,resolvedSecondaryAntibodyImmunosorbentVolume,resolvedSubstrateSolution, resolvedStopSolution,
		resolvedSubstrateSolutionVolume, resolvedStopSolutionVolume,resolvedSampleDilutionCurve, resolvedSampleSerialDilutionCurve,resolvedStandard,
		resolvedStandardTargetAntigen,resolvedStandardCoatingAntibody,resolvedStandardCoatingAntibodyDilutionFactor,resolvedStandardCaptureAntibody,
		resolvedStandardCaptureAntibodyDilutionFactor,resolvedStandardReferenceAntigen,resolvedStandardReferenceAntigenDilutionFactor,
		resolvedStandardPrimaryAntibody,resolvedStandardPrimaryAntibodyDilutionFactor,resolvedStandardSecondaryAntibody,resolvedStandardSecondaryAntibodyDilutionFactor,
		resolvedStandardCoatingVolume,resolvedStandardCoatingAntibodyCoatingVolume,resolvedStandardReferenceAntigenCoatingVolume,resolvedStandardCaptureAntibodyCoatingVolume,
		resolvedStandardBlockingVolume,resolvedStandardAntibodyComplexImmunosorbentVolume,resolvedStandardImmunosorbentVolume,
		resolvedStandardPrimaryAntibodyImmunosorbentVolume,resolvedStandardSecondaryAntibodyImmunosorbentVolume,resolvedStandardSubstrateSolution,resolvedStandardStopSolution,
		resolvedStandardSubstrateSolutionVolume,resolvedStandardStopSolutionVolume, resolvedStandardDilutionCurve,resolvedStandardSerialDilutionCurve, resolvedBlank,
		resolvedBlankTargetAntigen, resolvedBlankCoatingAntibody,resolvedBlankCoatingAntibodyDilutionFactor,resolvedBlankCaptureAntibody,resolvedBlankCaptureAntibodyDilutionFactor,
		resolvedBlankReferenceAntigen,resolvedBlankReferenceAntigenDilutionFactor,resolvedBlankPrimaryAntibody,resolvedBlankPrimaryAntibodyDilutionFactor,
		resolvedBlankSecondaryAntibody,resolvedBlankSecondaryAntibodyDilutionFactor,resolvedBlankCoatingVolume,resolvedBlankCoatingAntibodyCoatingVolume,
		resolvedBlankReferenceAntigenCoatingVolume,resolvedBlankCaptureAntibodyCoatingVolume,resolvedBlankBlockingVolume,resolvedBlankAntibodyComplexImmunosorbentVolume,
		resolvedBlankImmunosorbentVolume,resolvedBlankPrimaryAntibodyImmunosorbentVolume,resolvedBlankSecondaryAntibodyImmunosorbentVolume,resolvedBlankSubstrateSolution,
		resolvedBlankStopSolution,resolvedBlankSubstrateSolutionVolume,resolvedBlankStopSolutionVolume, assayVolumeList,liquidHandlerCompatibleContainers,
		dilutionExpandedSpikeDilutionFactors, spikeDilutionFactorNullToZero,resolvedSampleAntibodyComplexIncubationTime,resolvedSampleAntibodyComplexIncubationTemperature,
		resolvedStandardStorageCondition, resolvedBlockingBuffer,resolvedCoatingTemperature, resolvedCoatingTime,resolvedCoatingWashVolume, resolvedCoatingNumberOfWashes,
		resolvedBlockingTemperature, resolvedBlockingTime,resolvedBlockingWashVolume, resolvedBlockingNumberOfWashes,unresolvablePrimaryAntibodyList,
		unresolvableSecondaryAntibodyList,unresolvableCaptureAntibodyList, unresolvableCoatingAntibodyList,unresolvableReferenceAntigenList, unresolvableSubstrateSolutionList,
		unresolvableStopSolutionList,unresolvableSubstrateSolutionVolumeList,unresolvableStopSolutionVolumeList, unresolvableStandardList,unresolvableStandardPrimaryAntibodyList,
		unresolvableStandardSecondaryAntibodyList,unresolvableStandardCaptureAntibodyList,unresolvableStandardCoatingAntibodyList,unresolvableStandardReferenceAntigenList,
		unresolvableStandardSubstrateSolutionList,unresolvableStandardStopSolutionList,unresolvableStandardSubstrateSolutionVolumeList,unresolvableStandardStopSolutionVolumeList,
		unresolvableBlankList,unresolvableBlankPrimaryAntibodyList,unresolvableBlankSecondaryAntibodyList,unresolvableBlankCaptureAntibodyList,unresolvableBlankCoatingAntibodyList,
		unresolvableBlankReferenceAntigenList,unresolvableBlankSubstrateSolutionList,unresolvableBlankStopSolutionList,unresolvableBlankSubstrateSolutionVolumeList,
		unresolvableBlankStopSolutionVolumeList,resolvedPostProcessingOptions,unresolvableIndexMatchedOptionsTests,sampleIndexedOptionResolvedPool,
		standardIndexedOptionResolvedPool,blankIndexedOptionResolvedPool,allPotentialUnresolvableIndexMatchedOptions,unresolvableIndexMatchedOptionBoolean,
		unresolvableOptionList,discardedInvalidInputs,suppliedELISAPlateModel,suppliedSecondaryELISAPlateModel,elisaIncompatibleContainerConflictingOptions,
		elisaIncompatibleContainerConflictingTest,suppliedELISAPlateMaterials,suppliedSecondaryELISAPlateMaterials,elisaImproperContainerOptions,coatedSampleQ,
		originalStandardDilutionCurve,originalStandardSerialDilutionCurve,originalSampleSerialDilutionCurve,originalSampleDilutionCurve,roundedOriginalStandardDilutionCurve,
		roundedOriginalStandardSerialDilutionCurve,roundedOriginalSampleSerialDilutionCurve,roundedOriginalSampleDilutionCurve,roundedTransformedStandardDilutionCurve,
		roundedTransformedStandardSerialDilutionCurve,roundedTransformedSampleSerialDilutionCurve,roundedTransformedSampleDilutionCurve,allOptionNames,allOptions,
		allTests,resolvableOptionList,allOptionsRounded,updatedSimulation,pipettingError,emptyStandardQ,emptyBlankQ,joinedSamples,samplePrimaryAntibodyDilutionFactors,
		samplePrimaryAntibodyAssayVolumes,samplePrimaryAntibodyVolumes,samplePrimaryAntibodies,standardPrimaryAntibodyDilutionFactors,standardPrimaryAntibodyAssayVolumes,
		standardPrimaryAntibodyVolumes,standardPrimaryAntibodies,blankPrimaryAntibodyDilutionFactors,blankPrimaryAntibodyAssayVolumes,blankPrimaryAntibodyVolumes,
		blankPrimaryAntibodies,joinedPrimaryAntibodyDilutionFactors,joinedPrimaryAntibodyAssayVolumes,joinedPrimaryAntibodyVolumes,joinedPrimaryAntibodies,
		combinedPrimaryAntibodyVolumes,combinedPrimaryAntibodyFactors,combinedPrimaryAntibodyWithFactors,combinedPrimaryAntibodyWithFactorsDeDuplications,
		insufficientPrimaryAntibodyVolumes,primaryAntibodyErrorIdentifier,afterDilutionPrimaryAntibodyVolumes,totalPrimaryAntibodyVolumes,allOptionsRoundedAssociation,
		primaryAntibodyIntermediateDilutionRates,sampleSecondaryAntibodyVolumes,resolvedBlankSecondaryAntibodyVolumes,resolvedStandardSecondaryAntibodyVolumes,
		joinedSecondaryAntibodyDilutionFactors,joinedSecondaryAntibodyAssayVolumes,joinedSecondaryAntibodyVolumes,joinedSecondaryAntibodies,combinedSecondaryAntibodyVolumes,
		combinedSecondaryAntibodyFactors,combinedSecondaryAntibodyWithFactors,combinedSecondaryAntibodyWithFactorsDeDuplications,totalSecondaryAntibodyVolumes,insufficientSecondaryAntibodyVolumes,secondaryAntibodyErrorIdentifier,secondaryAntibodyIntermediateDilutionRates,afterDilutionSecondaryAntibodyVolumes,sampleCoatingAntibodyDilutionFactors,sampleCoatingAntibodyAssayVolumes,sampleCoatingAntibodyVolumes,sampleCoatingAntibodies,standardCoatingAntibodyDilutionFactors,standardCoatingAntibodyAssayVolumes,standardCoatingAntibodyVolumes,standardCoatingAntibodies,blankCoatingAntibodyDilutionFactors,blankCoatingAntibodyAssayVolumes,blankCoatingAntibodyVolumes,blankCoatingAntibodies,joinedCoatingAntibodyDilutionFactors,joinedCoatingAntibodyAssayVolumes,joinedCoatingAntibodyVolumes,joinedCoatingAntibodies,combinedCoatingAntibodyVolumes,combinedCoatingAntibodyFactors,combinedCoatingAntibodyWithFactors,combinedCoatingAntibodyWithFactorsDeDuplications,totalCoatingAntibodyVolumes,insufficientCoatingAntibodyVolumes,coatingAntibodyErrorIdentifier,coatingAntibodyIntermediateDilutionRates,afterDilutionCoatingAntibodyVolumes,sampleCaptureAntibodyDilutionFactors,sampleCaptureAntibodyAssayVolumes,sampleCaptureAntibodyVolumes,sampleCaptureAntibodies,standardCaptureAntibodyDilutionFactors,standardCaptureAntibodyAssayVolumes,standardCaptureAntibodyVolumes,standardCaptureAntibodies,blankCaptureAntibodyDilutionFactors,blankCaptureAntibodyAssayVolumes,blankCaptureAntibodyVolumes,blankCaptureAntibodies,joinedCaptureAntibodyDilutionFactors,joinedCaptureAntibodyAssayVolumes,joinedCaptureAntibodyVolumes,joinedCaptureAntibodies,combinedCaptureAntibodyVolumes,combinedCaptureAntibodyFactors,combinedCaptureAntibodyWithFactors,combinedCaptureAntibodyWithFactorsDeDuplications,insufficientCaptureAntibodyVolumes,captureAntibodyErrorIdentifier,captureAntibodyIntermediateDilutionRates,afterDilutionCaptureAntibodyVolumes,totalCaptureAntibodyVolumes,sampleReferenceAntigenDilutionFactors,sampleReferenceAntigenAssayVolumes,sampleReferenceAntigenVolumes,sampleReferenceAntigens,standardReferenceAntigenDilutionFactors,standardReferenceAntigenAssayVolumes,standardReferenceAntigenVolumes,standardReferenceAntigens,blankReferenceAntigenDilutionFactors,blankReferenceAntigenAssayVolumes,blankReferenceAntigenVolumes,blankReferenceAntigens,joinedReferenceAntigenDilutionFactors,joinedReferenceAntigenAssayVolumes,joinedReferenceAntigenVolumes,joinedReferenceAntigens,combinedReferenceAntigenVolumes,combinedReferenceAntigenFactors,combinedReferenceAntigenWithFactors,combinedReferenceAntigenWithFactorsDeDuplications,totalReferenceAntigenVolumes,insufficientReferenceAntigenVolumes,referenceAntigenErrorIdentifier,referenceAntigenIntermediateDilutionRates,afterDilutionReferenceAntigenVolumes,sampleVolumes,spikeVolumes,insufficientSpikeVolumes,spikeErrorIdentifier,spikeIntermediateDilutionRates,afterDilutionSpikeVolumes,dilutionCurveSufficientPipettingVolumesTests,joinedCombinedDilutionCurvesReplicatedErrored,curvesSufficientVolumeBooleans,insufficientVolumeCurves,insufficientVolumePositions,joinedSampleAndStandard,samplesAndStandardsWithInsufficientVolumes,samplesAndStandardsWithSufficientVolumes,elisaMasterSwitch,elisaSameNullIndexedOptions,elisaEitherOr,elisaNotMoreThanOne,singleDilutionCurveTransformation,elisaSetAuto,elisaMakeMapThreadFriends,resolvedEmail,resolvedELISAPlate,recommendedELISAPlates,resolverPassDowns,resolverAllOptical96WellMicroplates,allLHCompatibleOptical96WellMicroplates,resolverAllRecommendedMicroplates,suppliedSpikeStorageCondition,spikeSameNullConflictingOptions,spikeSameNullConflictingTest,resolvedSpikeDilutionFactor,resolvedSpikeStorageCondition,primaryAntibodyPipettingConflictOptions,primaryAntibodySufficientPipettingVolumesTest,secondaryAntibodyPipettingConflictOptions,secondaryAntibodySufficientPipettingVolumesTest,coatingAntibodyPipettingConflictOptions,coatingAntibodySufficientPipettingVolumesTest,captureAntibodyPipettingConflictOptions,captureAntibodySufficientPipettingVolumesTest,referenceAntigenPipettingConflictOptions,referenceAntigenSufficientPipettingVolumesTest,spikePipettingConflictOptions,spikeSufficientPipettingVolumesTest,dilutionCurvesConflictingOptions,resolvedNumberOfReplicatesNullToOne,joinedAssignmentTable,assignmentSamples,assignmentSpikes,assignmentSpikeDilutionFactors,assignmentCoatingAntibodies,assignmentCoatingAntibodyDilutionFactors,assignmentCaptureAntibodies,assignmentCaptureAntibodyDilutionFactors,assignmentReferenceAntigens,assignmentReferenceAntigenDilutionFactors,assignmentPrimaryAntibodies,assignmentPrimaryAntibodyDilutionFactors,assignmentSecondaryAntibodies,assignmentSecondaryAntibodyDilutionFactors,assignmentCoatingVolume,assignmentBlockingVolume,assignmentSampleAntibodyComplexImmunosorbentVolume,assignmentSampleImmunosorbentVolume,assignmentPrimaryAntibodyImmunosorbentVolume,assignmentSecondaryAntibodyImmunosorbentVolume,assignmentSubstrate,assignmentSubstrateVolume,assignmentStop,assignmentStopVolume,standardObjectNumber,blankObjectNumber,totalObjectNumber,elisaWellCounter,joinedAssignmentTableCounts,joinedAssignmentTableLessEqual96Q,primaryPlateExceeds96Q,secondaryPlateExceeds96Q,wellNumberConflictOptions,numberWellsTest,sortedJoinedResolvedAssignments,sortedJoinedAssignmentTable,assignmentTableMatchQ,assignmentMatchingConflictOptions,assginmentMatchesTest,resolvedOptions,resolvedPrimaryAssignmentTableCounts,	resolvedSecondaryAssignmentTableCounts,suppliedBlockingMixRate,precisions,suppliedSampleAntibodyComplexImmunosorbentMixRate,assignmentDilutionFactors,joinedFixedDilutionCurves,joinedSerialDilutionCurves,assignmentTypesRaw,assignmentTypesSpiked,sampleCurveExpansionParams,standardCurveExpansionParams,joinedCurveExpansionParams,curveExpandedJoinedSamples,numberOfSamples,numberOfCurveExpandedSamples,curveExpandedJoinedPrimaryAntibodyDilutionFactors,curveExpandedJoinedPrimaryAntibodyAssayVolumes,curveExpandedJoinedPrimaryAntibodyVolumes,curveExpandedJoinedPrimaryAntibodies,curveExpandedCombinedPrimaryAntibodyVolumes,curveExpandedCombinedPrimaryAntibodyFactors,curveExpandedCombinedPrimaryAntibodyWithFactors,curveExpandedJoinedSecondaryAntibodyDilutionFactors,curveExpandedJoinedSecondaryAntibodyAssayVolumes,curveExpandedJoinedSecondaryAntibodyVolumes,curveExpandedJoinedSecondaryAntibodies,curveExpandedCombinedSecondaryAntibodyVolumes,curveExpandedCombinedSecondaryAntibodyFactors,curveExpandedCombinedSecondaryAntibodyWithFactors,curveExpandedJoinedCoatingAntibodyDilutionFactors,curveExpandedJoinedCoatingAntibodyAssayVolumes,curveExpandedJoinedCoatingAntibodyVolumes,curveExpandedJoinedCoatingAntibodies,curveExpandedCombinedCoatingAntibodyVolumes,curveExpandedCombinedCoatingAntibodyFactors,curveExpandedCombinedCoatingAntibodyWithFactors,curveExpandedJoinedCaptureAntibodyDilutionFactors,curveExpandedJoinedCaptureAntibodyAssayVolumes,curveExpandedJoinedCaptureAntibodyVolumes,curveExpandedJoinedCaptureAntibodies,curveExpandedCombinedCaptureAntibodyVolumes,curveExpandedCombinedCaptureAntibodyFactors,curveExpandedCombinedCaptureAntibodyWithFactors,curveExpandedJoinedReferenceAntigenDilutionFactors,curveExpandedJoinedReferenceAntigenAssayVolumes,curveExpandedJoinedReferenceAntigenVolumes,curveExpandedJoinedReferenceAntigens,curveExpandedCombinedReferenceAntigenVolumes,curveExpandedCombinedReferenceAntigenFactors,curveExpandedCombinedReferenceAntigenWithFactors,suppliedBlankStorageCondition,resolvedBlankStorageCondition,optionNamesToString,volumePerSamplesIn,coatingIndexedOptions,elisaResolveIndexMatchedSampleOptions,elisaResolveIndexMatchedStandardOptions,elisaResolveIndexMatchedBlankOptions,resolvedNumberOfReplicates,sampleLengthNull,sampleLengthFalse,resolvedAliquotAmount,resolvedTargetConcentration,resolvedTargetConcentrationAnalyte,resolvedAssayVolume,resolvedAliquotContainer,resolvedDestinationWell,resolvedConcentratedBuffer,resolvedBufferDilutionFactor,resolvedBufferDiluent,resolvedAssayBuffer,resolvedAliquotSampleStorageCondition,resolvedAliquot,resolvedConsolidateAliquots,resolvedAliquotPreparation,suppliedAliquotAmount,suppliedTargetConcentration,suppliedTargetConcentrationAnalyte,suppliedAssayVolume,suppliedAliquotContainer,suppliedDestinationWell,suppliedConcentratedBuffer,suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAssayBuffer,suppliedAliquotSampleStorageCondition,suppliedAliquot,suppliedConsolidateAliquots,suppliedAliquotPreparation,preCoatedSampleConflictingAliquotOptions,allPrecoatedPlates,plateContentsRaw,secondaryPlateContentRaw,primaryPlateContentRaw,primaryPlateIndexConverted,secondaryPlateIndexConverted,primaryPlateContentSorted,secondaryPlateContentSorted,primaryPlateSortedSamples,secondaryPlateSortedSamples,resolvedPrimaryAntibodyDilutionFactor,spikeDilutionCurveConformingBooleans,spikeDilutionCurveConflictingQ,spikeDilutionCurveConflictingOption,spikedSampleDilutionCurveConflictingTest,volumeTooLargeOptions,columnwiseELISAPlateAssignment,columnwiseSecondaryELISAPlateAssignment,joinedResolvedAssignments,joinedColumnwiseAssignment,coatedAssignmentTableMatchQ,coatedAssignmentMatchingConflictOptions,coatedAssignmentMatchesTest,containerlessSamplePackets,containerlessInvalidInputs,containerlessTests,noVolumeSamplePackets,noVolumeInvalidInputs,noVolumeTests,sampleReagentTable,sampleTargetAntigenToReagentLookupTable,defaultLookup,semiresolvedStandard,standardBlankReagentSampleSublistConflictingOptions,sampleReagenObjectedDoubled,standardBlankReagentObjected,reagentTableOptionNames,unresolvableStandardBlankReagentsQ,standardBlankReagentSampleSublistConflictingTests,reagentsObjected,reagentsObjectedFlattened,reagentsStorageConditionFlattened,reagentStoragePairsDeDup,reagentsDeDupped,objectTally,sampleStorageConflictingObjects,sampleStorageConflictingOptionsBoolean,sampleStorageConflictingOptions,sampleStorageConflictingTests,incompatibleContainerSamples,allSampleContainers,allSampleContainersDeDup,allSampleContainerModels,incompatibleContainerBooleans,precoatedSamplesIncompatibleContainersTests,allReagents,allReagentsOptionNames,findModelObjectDuplicates,ojbectModelMutualExclusiveConflictingObjects,objectModelMutualExclusiveConflictingOptions,ojbectModelMutualExclusiveConflictingTests,
		suppliedPrereadBeforeStop, suppliedPrereadTimepoints, suppliedPrereadAbsorbanceWavelength, resolvedPrereadBeforeStop, resolvedPrereadTimepoints,
		resolvedPrereadAbsorbanceWavelength, invalidPreparedTimepoints, invalidPreparedTimepointsOptions,invalidPreparedTimepointTests,invalidPrereadOptions,invalidPreparedTests,measure620Q,signalCorrectionQ, simulation, simulatedCache, allDownloadValues, modelSampleFields, objectSampleFields, analyteFields, antibodyFields, modelContainerFields,objectContainerFields,  objectSampleAllFields
	},

	(*==================================================*)
	(*==============Helper Functions====================*)
	(*==================================================*)



	(*The elisaMasterSwitch function is used to do option conflict checks. When a master switch is turned on or off,
	this functions can check if a list of options are all specified as Nulls or Unulls. Non-indexmatched and indexmatched
	options should be input separately as lists and conflicting options, errors, and tests are thrown together. Must-null and must-unnll options
	 should be input separately and outputs are separated. For indexmatched options, it doe not matter what the indexmatching
	 parents are or if thery are the same across the list of options.*)
	elisaMasterSwitch[masterSwitchString_String,
		mustNullSingleSampleOptions_List, mustNullIndexedOptions_List,
		mustUnullSingleSampleOptions_List, mustUnullIndexedOptions_List]:=Module[
		{mustNullAutoOptions,mustNullIndexedOptionValues,mustUnullAutoOptions,mustUnullIndexedOptionValues,
			masterConflictingUnullSingleSampleOptions, masterConflictingUnullIndexedBoolean, masterConflictingUnullSampleIndexedOptions,
			masterConflictingUnullOptionsAll, mustNullOptionsAll,masterConflictingUnullTests,
			masterConflictingNullSingleSampleOptions, masterConflictingNullIndexedBoolean, masterConflictingNullSampleIndexedOptions,
			masterConflictingNullOptionsAll, mustUnullOptionsAll, masterConflictingNullTests},

		(*Get values of all the specified options*)
		mustNullAutoOptions = Lookup[allOptionsRoundedAssociation, mustNullSingleSampleOptions];
		mustNullIndexedOptionValues = Lookup[allOptionsRoundedAssociation, mustNullIndexedOptions];
		mustUnullAutoOptions = Lookup[allOptionsRoundedAssociation, mustUnullSingleSampleOptions];
		mustUnullIndexedOptionValues = Lookup[allOptionsRoundedAssociation, mustUnullIndexedOptions];

		(*Collect Wrongfully Unull SingleSample Option Names*)
		masterConflictingUnullSingleSampleOptions = If[!MatchQ[Lookup[allOptionsRoundedAssociation,#], Null|Automatic], #, Nothing]&
			/@mustNullSingleSampleOptions;

		(*Setup boolean tracking variables for index matched options, True means RIGHTFULLY Null*)
		masterConflictingUnullIndexedBoolean =
			Function[oneOption, If[MatchQ[#, Null|Automatic], True, False]&/@oneOption]/@ mustNullIndexedOptionValues;
		(*Pick out Option names with wrongfully UNULLED values*)
		masterConflictingUnullSampleIndexedOptions=
			Pick[mustNullIndexedOptions, (And@@#)&/@masterConflictingUnullIndexedBoolean, False];

		(*Put single and indexed conflicting options together*)
		masterConflictingUnullOptionsAll = Join[masterConflictingUnullSingleSampleOptions,masterConflictingUnullSampleIndexedOptions];
		mustNullOptionsAll = Join[mustNullSingleSampleOptions, mustNullIndexedOptions];

		(*Error Messages*)
		If[Length[masterConflictingUnullOptionsAll]!=0 && messages,
			Message[Error::MasterConflictingUnullOptions,
				masterSwitchString,
				ToString[masterConflictingUnullOptionsAll]
			],Nothing
		];

		(*Test*)
		masterConflictingUnullTests = If[gatherTests,
			Module[{passingTest, failingTest},
				passingTest = If[Length[masterConflictingUnullOptionsAll]!=Length[mustNullOptionsAll],
					Test["If Medthod is set to "<>masterSwitchString<>", "
						<> optionNamesToString[DeleteCases[mustNullOptionsAll,Alternatives@@masterConflictingUnullOptionsAll]]
						<>" must be Null.",
						True,True
					], Nothing];
				failingTest = If[Length[masterConflictingUnullOptionsAll]!=0,
					Test["If Medthod is set to "<>masterSwitchString<>", "
						<> optionNamesToString[masterConflictingUnullOptionsAll]<>" must be Null.",
						True,False
					], Nothing];
				{passingTest, failingTest}
			],
			{}
		];

		(*Collect Wrongfully Nulled SingleSample Option Names*)
		masterConflictingNullSingleSampleOptions = If[MatchQ[Lookup[allOptionsRoundedAssociation, #], Null], #, Nothing]&
			/@mustUnullSingleSampleOptions;

		(*Setup boolean tracking variables for index matched options. True means rightfully Specified*)
		masterConflictingNullIndexedBoolean =
			Function[oneOption, If[MatchQ[#, Null], False, True]&/@oneOption]/@mustUnullIndexedOptionValues;

		(*Pick out Option names with wrongfully Null values*)
		masterConflictingNullSampleIndexedOptions=
			Pick[mustUnullIndexedOptions, (And@@#)&/@masterConflictingNullIndexedBoolean, False];

		masterConflictingNullOptionsAll = Join[masterConflictingNullSingleSampleOptions,masterConflictingNullSampleIndexedOptions];
		mustUnullOptionsAll = Join[mustUnullSingleSampleOptions, mustUnullIndexedOptions];

		(*Error Messages*)
		If[Length[masterConflictingNullOptionsAll]!=0 && messages,
			Message[Error::MasterConflictingNullOptions,
				masterSwitchString,
				optionNamesToString[masterConflictingNullOptionsAll]
			], Nothing
		];

		(*Test*)
		masterConflictingNullTests = If[gatherTests,
			Module[{passingTest, failingTest},
				passingTest = If[Length[masterConflictingNullOptionsAll]!=Length[mustUnullOptionsAll],
					Test["If "<>masterSwitchString<>", "
						<> optionNamesToString[DeleteCases[mustUnullOptionsAll,Alternatives@@masterConflictingNullOptionsAll]]
						<>" must not be Null.",
						True,True
					], Nothing];
				failingTest = If[Length[masterConflictingNullOptionsAll]!=0,
					Test["If "<>masterSwitchString<>", "
						<> optionNamesToString[masterConflictingNullOptionsAll]<>" must not be Null.",
						True,False
					], Nothing];
				{passingTest, failingTest}
			],
			{}
		];

		{masterConflictingUnullOptionsAll,masterConflictingNullOptionsAll,masterConflictingUnullTests, masterConflictingNullTests}
	];


	optionNamesToString[optionName_List]:=StringRiffle[ToString[#]&/@optionName, ", "];


	(*elisaSameNullIndexedOptions:Takes in a series of Index-Matched options and see if these options index-matched to the same parents are Null or Unull at the same time.*)
	elisaSameNullIndexedOptions[sameNullOptionNames_List, sameNullOptionValues:{_List..}]:=Module[
		{categorizedOptionValues,sameNullQ,sameNullConflictingOptions,sameNullConflictingTest},
		(*Catagorize each option*)
		categorizedOptionValues = Map[Which[
			MatchQ[#,Null], True,
			MatchQ[#,Except[Null|Automatic]],False,
			MatchQ[#,Automatic],Nothing
		]&, sameNullOptionValues//Transpose,{2}];

		sameNullQ = And@@Map[SameQ@@#&,categorizedOptionValues,{1}];
		sameNullConflictingOptions = If[sameNullQ==False, sameNullOptionNames, {}];

		(*Error Messages*)
		If[sameNullQ==False && messages,
			Message[Error::IndexedSameNullConflictingOptions,
				StringTake[ObjectToString[sameNullOptionNames],{2,-2}]
			],Nothing
		];

		(*Test*)
		sameNullConflictingTest= If[gatherTests,
			Test["For options "<>StringTake[ObjectToString[sameNullOptionNames],{2,-2}]
				<>", each value IndexMatched to the same sample must be specified as Null or Unull at the same time.",
				True, sameNullQ],
			{}
		];
		{sameNullConflictingOptions,sameNullConflictingTest}
	];


	(* elisaEitherOr takes option groups and confirm that one and only one option within the option group is specified
	as an Unull value AND DOES NOT PERMIT ALL NULL VALUES.
	It takes in a list of single option groups, and a list of indexed option groups. It doesn't matter who
	these indexmatched options are indexmatched to, as long as within the option group, the options are of the same length.
	The function returns a list of option groups (list of list) which do not satisfy one and only one unull, and a list consisting
	of a passing test and a failing test: {{OptionGroup_List..}, {PassingTest, FailingTest}} *)

	elisaEitherOr[singleOptionGroups:{_List ..}, indexedOptionGroups:{_List ..}]:=Module[
		{singleOptionValues,indexedOptionValues,
			singleOptionValuesBooleans,EitherOrConflictingSingleSampleOptions,EitherOrConflictingIndexedOptions,
			EitherOrConflictingOptions,EitherOrConflictingOptionsString,
			optionGroupsAll,EitherOrConflictingOptionsTests,indexedOptionValuesFixed,indexedOptionValuesSingleSampleBooleans,indexedOptionValuesCombinedBooleans,EitherOrConformingOptionsString},

		(*Get values of all the specified options*)
		singleOptionValues = Lookup[allOptionsRoundedAssociation, #]&/@singleOptionGroups;
		indexedOptionValues = Lookup[allOptionsRoundedAssociation, #]&/@indexedOptionGroups;
		(*For single options, check each group to see if one an only one option is specified as unull*)
		(*Convert the singleOptionValues list so that more than one specified Unull or all Null are false*)
		singleOptionValuesBooleans = Map[If[MatchQ[#, {Null..}|{Except[Null|Automatic],Except[Null|Automatic]..,___}], False, True]&, singleOptionValues,{1}];
		EitherOrConflictingSingleSampleOptions = Pick[singleOptionGroups,singleOptionValuesBooleans, False];

		(*For IndexMatched options, *)
		indexedOptionValuesFixed=Map[(#//Transpose)&,indexedOptionValues, {1}];
		indexedOptionValuesSingleSampleBooleans=Map[If[MatchQ[#, {Null..}|{Except[Null|Automatic],Except[Null|Automatic]..,___}], False, True]&, indexedOptionValuesFixed,{2}];
		indexedOptionValuesCombinedBooleans=Map[And@@#&,indexedOptionValuesSingleSampleBooleans,{1}];
		EitherOrConflictingIndexedOptions = Pick[indexedOptionGroups,indexedOptionValuesCombinedBooleans, False];

		(*Join single And indexed Conflicting options*)
		EitherOrConflictingOptions = Join[EitherOrConflictingSingleSampleOptions,EitherOrConflictingIndexedOptions];
		(*Prepare conflicting option list in string*)
		EitherOrConflictingOptionsString = StringTake[EitherOrConflictingOptions//ToString, {2,-2}];
		(*Error Messages*)
		If[Length[EitherOrConflictingOptions]!=0 && messages,
			Message[Error::EitherOrConflictingOptions,
				EitherOrConflictingOptionsString
			],Nothing
		];

		(*Test*)
		optionGroupsAll = Join[singleOptionGroups,indexedOptionGroups];
		EitherOrConformingOptionsString = StringTake[DeleteCases[optionGroupsAll,Alternatives@@EitherOrConflictingOptions]//ToString, {2,-2}];

		EitherOrConflictingOptionsTests = If[gatherTests,
			Module[{passingTest, failingTest},
				passingTest = If[Length[EitherOrConflictingOptions]!=Length[optionGroupsAll],
					Test["Among each of the following option groups "
						<> EitherOrConformingOptionsString
						<>", only one of them can be specified and not Null. They can not be both Null either:",
						True,True
					], Nothing];
				failingTest = If[Length[EitherOrConflictingOptions]!=0,
					Test["Among each of the following option groups "
						<> EitherOrConflictingOptionsString
						<>", only one of them can be specified and not Null. They can not be both Null either:",
						True,False
					], Nothing];
				{passingTest, failingTest}
			],
			{}
		];

		{EitherOrConflictingOptions,EitherOrConflictingOptionsTests}
	];
	(*elisaNotMoreThanOne behaves similar to elisaEitherOr except that it DOES permit all options to be Null.*)
	elisaNotMoreThanOne[singleOptionGroups:{_List ..}, indexedOptionGroups:{_List ..}]:=Module[
		{singleOptionValues,indexedOptionValues,
			singleOptionValuesBooleans,notMoreThanOneConflictingSingleSampleOptions,notMoreThanOneConflictingIndexedOptions,
			notMoreThanOneConflictingOptions,
			optionGroupsAll,notMoreThanOneConflictingOptionsTests,indexedOptionValuesFixed,indexedOptionValuesSingleSampleBooleans,indexedOptionValuesCombinedBooleans,
			notMoreThanOneConflictingOptionsString,notMoreThanOneConformingOptionsString
		},

		(*Get values of all the specified options*)
		singleOptionValues = Lookup[allOptionsRoundedAssociation, #]&/@singleOptionGroups;
		indexedOptionValues = Lookup[allOptionsRoundedAssociation, #]&/@indexedOptionGroups;
		(*For single options, check each group to see if one an only one option is specified as unull*)
		(*Convert the singleOptionValues list so that more than one specified Unull are false*)
		singleOptionValuesBooleans = Map[If[MatchQ[#, {Except[Null|Automatic],Except[Null|Automatic]..,___}], False, True]&, singleOptionValues,{1}];
		notMoreThanOneConflictingSingleSampleOptions = Pick[singleOptionGroups,singleOptionValuesBooleans, False];

		(*For IndexMatched options, *)
		indexedOptionValuesFixed=Map[(#//Transpose)&,indexedOptionValues, {1}];
		indexedOptionValuesSingleSampleBooleans=Map[If[MatchQ[#, {Except[Null|Automatic],Except[Null|Automatic]..,___}], False, True]&, indexedOptionValuesFixed,{2}];
		indexedOptionValuesCombinedBooleans=Map[And@@#&,indexedOptionValuesSingleSampleBooleans,{1}];
		notMoreThanOneConflictingIndexedOptions = Pick[indexedOptionGroups,indexedOptionValuesCombinedBooleans, False];

		(*Join single And indexed Conflicting options*)
		notMoreThanOneConflictingOptions = Join[notMoreThanOneConflictingSingleSampleOptions,notMoreThanOneConflictingIndexedOptions];
		(*Prepare conflicting option list in string*)
		notMoreThanOneConflictingOptionsString = StringTake[notMoreThanOneConflictingOptions//ToString, {2,-2}];
		(*Error Messages*)
		If[Length[notMoreThanOneConflictingOptions]!=0 && messages,
			Message[Error::NotMoreThanOneConflictingOptions,
				notMoreThanOneConflictingOptionsString
			],Nothing
		];

		(*Test*)
		optionGroupsAll = Join[singleOptionGroups,indexedOptionGroups];
		notMoreThanOneConformingOptionsString = StringTake[DeleteCases[optionGroupsAll,Alternatives@@notMoreThanOneConflictingOptions]//ToString, {2,-2}];

		notMoreThanOneConflictingOptionsTests = If[gatherTests,
			Module[{passingTest, failingTest},
				passingTest = If[Length[notMoreThanOneConflictingOptions]!=Length[optionGroupsAll],
					Test["Among each of the following option groups "
						<> notMoreThanOneConformingOptionsString
						<>", they cannot both be specified as a value that is not Null:",
						True,True
					], Nothing];
				failingTest = If[Length[notMoreThanOneConflictingOptions]!=0,
					Test["Among each of the following option groups "
						<> notMoreThanOneConflictingOptionsString
						<>", they cannot both be specified as a value that is not Null:",
						True,False
					], Nothing];
				{passingTest, failingTest}
			],
			{}
		];

		{notMoreThanOneConflictingOptions,notMoreThanOneConflictingOptionsTests}
	];

	(*singleDilutionCurveTransformation uniforms the dilution curve options. The unified form is as such. For each option IndexMatched to
	one sample, the option looks like {{ConcentrateVolume,DiluentVolume}..}. For serial dilutions, the concentrate is the
	diluted solution in the previous tube. For fixed dilution, the concentrate is the original solutions. The Function deals with a dilution curve indexMatched to a single sample.*)

	singleDilutionCurveTransformation[singleDilutionOption_]:=Module[{assayVolume,transferVolumeList,diluentVolumeList},
		Which[
			(*For "Serial Dilution Factor" inputs.*)
			MatchQ[singleDilutionOption,({GreaterEqualP[0 Microliter], {RangeP[0, 1]..}}|{GreaterEqualP[0 Microliter], {RangeP[0, 1], GreaterP[0,1]}})],
			dilutionRateList=If[
				MatchQ[singleDilutionOption,{GreaterEqualP[0 Microliter], {RangeP[0, 1], GreaterP[0,1]}}],
				ConstantArray[singleDilutionOption[[2]][[1]],singleDilutionOption[[2]][[2]]],
				singleDilutionOption[[2]]
			];
			assayVolume=singleDilutionOption[[1]];
			transferVolumeList=Function[{start},assayVolume*Plus@@FoldList[Times[##] &,dilutionRateList[[start ;;]]]] /@Range[Length[dilutionRateList]];
			diluentVolumeList=MapThread[(1 - #1)/#1*#2 &, {dilutionRateList, transferVolumeList}];
			MapThread[{#1,#2}&,{transferVolumeList,diluentVolumeList}],


			(*For "Serial Dilution Volumes" inputs."*)
			MatchQ[singleDilutionOption,{GreaterEqualP[0 Microliter],GreaterEqualP[0 Microliter], GreaterP[0,1]}],
			ConstantArray[{singleDilutionOption[[1]], singleDilutionOption[[2]]},singleDilutionOption[[3]]],

			(*For "Fixed Dilution Factor" inputs.*)
			MatchQ[singleDilutionOption,{{GreaterEqualP[0 Microliter], RangeP[0, 1]}..}],
			{#[[1]]*#[[2]], #[[1]]*(1-#[[2]])}&/@singleDilutionOption,

			(*For "Fixed Dilution Volume" inputs.*)
			MatchQ[singleDilutionOption,{{GreaterEqualP[0 Microliter], GreaterEqualP[0 Microliter]}..}],
			singleDilutionOption,

			MatchQ[singleDilutionOption, (Null|Automatic)],
			singleDilutionOption
		]
	];


	(*Assign option. Takes a list of suppliedOptionValues and a list of autoResolvedOptionValues and replace the Automatic values
	in the suppliedOptionValueList with autoResolvedOptionValues*)
	elisaSetAuto[suppliedOptionValueList_List,autoResolvedOptionValueList_List]:=
		MapThread[Which[MatchQ[#1,Automatic],#2,MatchQ[#1,{Automatic..}],ToList[#2],True,#1]&,{suppliedOptionValueList, autoResolvedOptionValueList}];


	(*Generates MapThread Friendly options. The function takes in all the supplied IndexMatchingParent values (including samples),
	 children option values (as a list of lists), and children names and return a list of association in the form of <|"Parent"->parentValue, Option1->Option1Value, Option2->Option2Value..|>*)
	elisaMakeMapThreadFriends[suppliedParentValues_List,suppliedChildrenValues:{_List..}, childrenNames_List]:=Module[
		{transformedValues,transformedNames},
		transformedValues = Prepend[suppliedChildrenValues, suppliedParentValues]//Transpose;
		transformedNames = Prepend[childrenNames,"parent"];
		Map[Function[valueOneParent, MapThread[#1->#2 &, {transformedNames, valueOneParent}] // Association],transformedValues,{1}]
	];





	(*==================================================*)
	(*==============Resolver Starts=====================*)
	(*==================================================*)

	(* ::Subsubsection::Closed:: *)
	(*Resolver*)
	(*set up pipetting error*)
	pipettingError=1.1;

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)


	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Fetch our cache and simulation from the parent function. *)
	cache=Lookup[ToList[myResolutionOptions],Cache,{}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our elisa options from our Sample Prep options. *)
	{samplePrepOptions,elisaOptions}=splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples,resolvedSamplePrepOptions,updatedSimulation},samplePrepTests}=If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentELISA,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation, Output->{Result,Tests}],
		{resolveSamplePrepOptionsNew[ExperimentELISA,mySamples,samplePrepOptions,Cache->cache,Simulation -> simulation, Output->Result],{}}
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	elisaOptionsAssociation = Association[elisaOptions];


	(* we need to update the cache to be the simulated cache *)
	(* Fields to download from all samples - include mySamples, Standard samples, Spike samples, Antibody samples and other reagents *)
	(* Define all the fields that we want *)
	modelSampleFields=SamplePreparationCacheFields[Model[Sample]];
	objectSampleFields=Join[SamplePreparationCacheFields[Object[Sample]],{RequestedResources}];
	analyteFields={Name,Object,Antibodies,DefaultSampleModel,State,MolecularWeight};
	antibodyFields={Name,Object,Targets,Organism,SecondaryAntibody,DefaultSampleModel,State,AffinityLabels,DetectionLabels,MolecularWeight};
	modelContainerFields=SamplePreparationCacheFields[Model[Container]];
	objectContainerFields=SamplePreparationCacheFields[Object[Container]];

	(* Fields to download for all sample objects*)
	objectSampleAllFields={
		Packet[Sequence@@objectSampleFields],
		Packet[Container[objectContainerFields]],
		Packet[Analytes[analyteFields]],
		Packet[Analytes[DefaultSampleModel][modelSampleFields]],
		Packet[Analytes[Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][DefaultSampleModel][modelSampleFields]],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][antibodyFields]],
		Packet[Analytes[Antibodies][AffinityLabels][analyteFields]],
		Packet[Analytes[Antibodies][AffinityLabels][Antibodies][DefaultSampleModel][modelSampleFields]]

	};
	(* Download some values that we'll need below *)
	allDownloadValues = Quiet[Download[
		DeleteDuplicates[Join[mySamples, simulatedSamples]],
		objectSampleAllFields,
		Cache -> cache,
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist}];

	(* having a simulatedCache here helps with ObjectToString below *)
	simulatedCache = FlattenCachePackets[{cache, allDownloadValues}];


	(* Extract the packets that we need from our downloaded cache. *)
	(* Remember to download from simulatedSamples, using our updatedSimulation *)
	(* Quiet[Download[...],Download::FieldDoesntExist]. An alternative method to Download from Cache - fetchPacketFromCache function - in shared Experiment Framework - to get information from cache *)
	(* Fetch simulated samples *)
	simulatedSamplePackets=Experiment`Private`fetchPacketFromCache[#,simulatedCache]&/@simulatedSamples;

	(* Get information about the containers of the simulated samples *)
	simulatedSampleContainers=Lookup[simulatedSamplePackets,Container];
	(* original code mapping Download: simulatedSampleContainerModels=Download[#,Model[Object],Cache->simulatedCache]&/@simulatedSampleContainers;*)
	simulatedSampleContainerModels=Download[simulatedSampleContainers,Model[Object],Simulation -> updatedSimulation, Cache->simulatedCache];

	(* Extract downloaded mySamples packets *)
	samplePackets=Experiment`Private`fetchPacketFromCache[#,cache]&/@mySamples;


	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)
	(* 1 - Discarded Sample Test *)
	(* Get the samples from mySamples that are discarded. *)
	discardedSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Status->Discarded]];

	(* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
	discardedInvalidInputs=If[MatchQ[discardedSamplePackets,{}],
		{},
		Lookup[discardedSamplePackets,Object]
	];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[discardedInvalidInputs]>0&&!gatherTests,
		Message[Error::DiscardedSamples,ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	discardedTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[discardedInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[discardedInvalidInputs,Simulation->updatedSimulation]<>" are not discarded:",True,False]
			];
			passingTest=If[Length[discardedInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,discardedInvalidInputs],Simulation->updatedSimulation]<>" are not discarded:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* 2 - Solid Sample Test *)
	(* Get the samples that are not liquids. If DirectELISA or IndirectELISA and no coating, then sample is already coated on plate and we won't be throwing error on this. *)
	(* Any options with samples that must be liquid *)
	(* Note that we don't include plate assignment options here. If they don't match the provided options, we will throw an error for it. No need to check status. *)
	rawoptionsWithSamples={
		Spike, CoatingAntibody, CaptureAntibody, ReferenceAntigen,PrimaryAntibody, SecondaryAntibody,
		Standard, StandardCoatingAntibody, StandardCaptureAntibody, StandardReferenceAntigen, StandardPrimaryAntibody, StandardSecondaryAntibody,
		Blank, BlankCoatingAntibody, BlankCaptureAntibody, BlankReferenceAntigen, BlankPrimaryAntibody, BlankSecondaryAntibody,
		WashingBuffer,SampleDiluent,CoatingAntibodyDiluent,CaptureAntibodyDiluent,ReferenceAntigenDiluent,PrimaryAntibodyDiluent,SecondaryAntibodyDiluent,BlockingBuffer,SubstrateSolution,StopSolution,
		StandardDiluent,StandardSubstrateSolution,StandardStopSolution,BlankSubstrateSolution,BlankStopSolution
	};
	optionsWithSamples = If[MatchQ[Lookup[elisaOptionsAssociation,Coating],False]&&MatchQ[Lookup[elisaOptionsAssociation,Method],DirectELISA|IndirectELISA],
		DeleteCases[rawoptionsWithSamples,Standard|Blank],
		rawoptionsWithSamples
	];

	objectsFromOptions = DeleteCases[Flatten[Lookup[elisaOptionsAssociation,optionsWithSamples]],Null|Automatic];

	objectsFromOptionsPackets = Experiment`Private`fetchPacketFromCache[#,simulatedCache]&/@objectsFromOptions;

	nonLiquidSampleInvalidInputs=If[
		MatchQ[Lookup[elisaOptionsAssociation,Coating],False]&&MatchQ[Lookup[elisaOptionsAssociation,Method],DirectELISA|IndirectELISA],
		nonLiquidSamplePackets=Map[
			If[!MatchQ[Lookup[#1,State],Alternatives[Liquid,Null]],
				#1,
				Nothing]&,
			objectsFromOptionsPackets
		],
		(*ELSE*)
		nonLiquidSamplePackets=Map[
			If[!MatchQ[Lookup[#1,State],Alternatives[Liquid,Null]],
				#1,
				Nothing]&,
			Join[simulatedSamplePackets,objectsFromOptionsPackets]
		];
		(* Keep track of samples that are not liquid *)
		If[MatchQ[nonLiquidSamplePackets,{}],
			{},
			Lookup[nonLiquidSamplePackets,Object]
		]
	];

	(* If there are invalid inputs and we are throwing messages,do so *)
	If[Length[nonLiquidSampleInvalidInputs]>0&&messages,
		Message[Error::ELISANoneLiquidSample,ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	nonLiquidSampleTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonLiquidSampleInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[nonLiquidSampleInvalidInputs,Simulation->updatedSimulation]<>" are not in solid state:",True,False]
			];
			passingTest=If[Length[nonLiquidSampleInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,nonLiquidSampleInvalidInputs],Simulation->updatedSimulation]<>" are not in solid state:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* 3 - Containerless Sample Test *)
	(* Get the samples from mySamples that are containerless. *)
	containerlessSamplePackets=Cases[Flatten[samplePackets],KeyValuePattern[Container->Null]];

	(* Set containerlessInvalidInputs to the input objects whose statuses are containerless *)
	containerlessInvalidInputs=If[MatchQ[containerlessSamplePackets,{}],
		{},
		Lookup[containerlessSamplePackets,Object]
	];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[containerlessInvalidInputs]>0&&!gatherTests,
		Message[Error::containerlessSamples,ObjectToString[containerlessInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerlessTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[containerlessInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[containerlessInvalidInputs,Simulation->updatedSimulation]<>" are containerless:",True,False]
			];
			passingTest=If[Length[containerlessInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,containerlessInvalidInputs],Simulation->updatedSimulation]<>" arecontainerless:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* 4 - NoVolume Sample Test *)
	(* Get the samples from mySamples that are noVolume-- we only check this when sample is not coated onto the plate.*)
	noVolumeSamplePackets=If[MatchQ[Lookup[elisaOptionsAssociation,Coating],False]&&MatchQ[Lookup[elisaOptionsAssociation,Method],DirectELISA|IndirectELISA],
		{},
		Cases[Flatten[samplePackets],KeyValuePattern[{Volume->Null,Volume->0Liter}]]
	];

	(* Set noVolumeInvalidInputs to the input objects whose statuses are noVolume *)
	noVolumeInvalidInputs=If[MatchQ[noVolumeSamplePackets,{}],
		{},
		Lookup[noVolumeSamplePackets,Object]
	];
	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[noVolumeInvalidInputs]>0&&!gatherTests,
		Message[Error::SamplesWithoutVolume,ObjectToString[noVolumeInvalidInputs,Simulation->updatedSimulation]]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	noVolumeTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[noVolumeInvalidInputs]==0,
				Nothing,
				Test["Our input samples "<>ObjectToString[noVolumeInvalidInputs,Simulation->updatedSimulation]<>" have volumes specified:",True,False]
			];
			passingTest=If[Length[noVolumeInvalidInputs]==Length[mySamples],
				Nothing,
				Test["Our input samples "<>ObjectToString[Complement[mySamples,noVolumeInvalidInputs],Simulation->updatedSimulation]<>" do not have volumes specified:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(* 5 - Pre-Coated Samples must be in microplate Test *)

	(* Pull out all 96 well microplate Models*)
	allLHCompatibleOptical96WellMicroplates = Search[
		Model[Container, Plate],
		And[
			NumberOfWells === 96,
			Footprint === Plate,
			Dimensions[[3]] >= 0.013 Meter && Dimensions[[3]] <= 0.016 Meter,
			WellColor === Clear,
			WellBottom == FlatBottom,
			LiquidHandlerPrefix != Null
		],
		SubTypes -> False
	];

	incompatibleContainerSamples=If[

		MatchQ[{Lookup[elisaOptionsAssociation,Method],Lookup[elisaOptionsAssociation,Coating]},{Alternatives[DirectELISA,IndirectELISA],False}],

		allSampleContainers=Lookup[Flatten[samplePackets],Container]/.x:LinkP[]:>Download[x,Object]; (*strip link here for delete duplicates next*)
		allSampleContainersDeDup=DeleteDuplicates[allSampleContainers];
		If[Length[allSampleContainersDeDup]>2,
			mySamples, (*If samples are distributed in more than two containers, then error*)

			(*Else, check if all the container models belong to the compatible containers*)
			allSampleContainerModels=elisaGetPacketValue[#,Model,1,simulatedCache]&/@allSampleContainers;
			incompatibleContainerBooleans=MemberQ[allLHCompatibleOptical96WellMicroplates,#]&/@allSampleContainerModels;
			PickList[mySamples,incompatibleContainerBooleans,False]
		],

		(*If samples are not pre-coated, then we don't need to check nata.*)
		{}
	];

	(* If there are invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs.*)
	If[Length[incompatibleContainerSamples]>0&&!gatherTests,
		Message[
			Error::PreCoatedSamplesIncompatiblePlates,
			ObjectToString[incompatibleContainerSamples,Simulation->updatedSimulation]
		]
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	precoatedSamplesIncompatibleContainersTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[incompatibleContainerSamples]==0,
				Nothing,
				Test["Our pre-coated input samples "<>ObjectToString[incompatibleContainerSamples,Simulation->updatedSimulation]<>" are in compatible containers:",True,False]
			];
			passingTest=If[Length[incompatibleContainerSamples]==Length[mySamples],
				Nothing,
				Test["Our pre-coated input samples "<>ObjectToString[Complement[mySamples,incompatibleContainerSamples],Simulation->updatedSimulation]<>" are in compatible containers:",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];

	(*-- OPTION PRECISION CHECKS --*)

	(*Transform and round dilution curve options*)
	{originalStandardDilutionCurve,originalStandardSerialDilutionCurve,originalSampleDilutionCurve,originalSampleSerialDilutionCurve} =
		Lookup[elisaOptionsAssociation, {StandardDilutionCurve,StandardSerialDilutionCurve,SampleDilutionCurve,SampleSerialDilutionCurve}];

	(*These are for user return*)
	{roundedOriginalStandardDilutionCurve,roundedOriginalStandardSerialDilutionCurve,roundedOriginalSampleDilutionCurve,roundedOriginalSampleSerialDilutionCurve} =
		Map[RoundOptionPrecision[#,10^-5Microliter]&, {originalStandardDilutionCurve,originalStandardSerialDilutionCurve,originalSampleDilutionCurve,originalSampleSerialDilutionCurve}, {3}];


	(*Replace the original dilution curve options with the new ones*)
	elisaOptionsAssociationCurvesFixed = elisaOptionsAssociation;
	elisaOptionsAssociationCurvesFixed[StandardDilutionCurve]=roundedOriginalStandardDilutionCurve;
	elisaOptionsAssociationCurvesFixed[StandardSerialDilutionCurve]=roundedOriginalStandardSerialDilutionCurve;
	elisaOptionsAssociationCurvesFixed[SampleDilutionCurve]=roundedOriginalSampleDilutionCurve;
	elisaOptionsAssociationCurvesFixed[SampleSerialDilutionCurve]=roundedOriginalSampleSerialDilutionCurve;

	(*Round and precision check for other options*)
	optionsToBeRounded = {CoatingAntibodyVolume,CaptureAntibodyVolume,ReferenceAntigenVolume,PrimaryAntibodyVolume,SecondaryAntibodyVolume,SampleCoatingVolume,CoatingAntibodyCoatingVolume,ReferenceAntigenCoatingVolume,CaptureAntibodyCoatingVolume,CoatingTemperature,CoatingTime,CoatingWashVolume,BlockingVolume,BlockingTemperature,BlockingTime,BlockingWashVolume,SampleAntibodyComplexImmunosorbentVolume,SampleAntibodyComplexImmunosorbentTime,SampleAntibodyComplexImmunosorbentTemperature,BlockingMixRate,SampleAntibodyComplexImmunosorbentWashVolume,SampleImmunosorbentVolume,SampleImmunosorbentTime,SampleImmunosorbentTemperature,SampleImmunosorbentMixRate,SampleImmunosorbentWashVolume,PrimaryAntibodyImmunosorbentVolume,PrimaryAntibodyImmunosorbentTime,PrimaryAntibodyImmunosorbentTemperature,PrimaryAntibodyImmunosorbentMixRate,PrimaryAntibodyImmunosorbentWashVolume,SecondaryAntibodyImmunosorbentVolume,SecondaryAntibodyImmunosorbentTime,SecondaryAntibodyImmunosorbentTemperature,SecondaryAntibodyImmunosorbentMixRate,SecondaryAntibodyImmunosorbentWashVolume,SubstrateSolutionVolume,StopSolutionVolume,SubstrateIncubationTime,SubstrateIncubationTemperature,SubstrateIncubationMixRate,StandardCoatingAntibodyVolume,StandardCaptureAntibodyVolume,StandardReferenceAntigenVolume,StandardPrimaryAntibodyVolume,StandardSecondaryAntibodyVolume,StandardCoatingVolume,StandardReferenceAntigenCoatingVolume,StandardCoatingAntibodyCoatingVolume,StandardCaptureAntibodyCoatingVolume,StandardBlockingVolume,StandardAntibodyComplexImmunosorbentVolume,StandardImmunosorbentVolume,StandardPrimaryAntibodyImmunosorbentVolume,StandardSecondaryAntibodyImmunosorbentVolume,StandardSubstrateSolutionVolume,StandardStopSolutionVolume,BlankCoatingAntibodyVolume,BlankCaptureAntibodyVolume,BlankReferenceAntigenVolume,BlankPrimaryAntibodyVolume,BlankSecondaryAntibodyVolume,BlankCoatingVolume,BlankReferenceAntigenCoatingVolume,BlankCoatingAntibodyCoatingVolume,BlankCaptureAntibodyCoatingVolume,BlankBlockingVolume,BlankAntibodyComplexImmunosorbentVolume,BlankImmunosorbentVolume,BlankPrimaryAntibodyImmunosorbentVolume,BlankSecondaryAntibodyImmunosorbentVolume,BlankSubstrateSolutionVolume,BlankStopSolutionVolume,SampleAntibodyComplexImmunosorbentMixRate};

	precisions = {10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^0 Celsius,1 Minute,10^-1 Microliter,10^-1 Microliter,10^0 Celsius,1 Minute,10^-1 Microliter,10^-1 Microliter,1 Minute,10^0 Celsius,10^0 RPM,10^-1 Microliter,10^-1 Microliter,1 Minute,10^0 Celsius,10^0 RPM,10^-1 Microliter,10^-1 Microliter,1 Minute,10^0 Celsius,10^0 RPM,10^-1 Microliter,10^-1 Microliter,1 Minute,10^0 Celsius,10^0 RPM,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,1 Minute,10^0 Celsius,10^0 RPM,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^-1 Microliter,10^0 RPM};

	{roundedExperimentOptions,precisionTests}=If[gatherTests,
		RoundOptionPrecision[elisaOptionsAssociationCurvesFixed,optionsToBeRounded,precisions,Output->{Result,Tests}],
		{RoundOptionPrecision[elisaOptionsAssociationCurvesFixed,optionsToBeRounded,precisions],{}}
	];


	(* Turn the output of RoundOptionPrecision[experimentOptionsAssociation] into a list *)
	roundedExperimentOptionsList=Normal[roundedExperimentOptions];

	(* Replace the rounded options in myOptions *)
	allOptionsRounded=ReplaceRule[
		myOptions,
		roundedExperimentOptionsList,
		Append->False
	];

	allOptionsRoundedAssociation = Association[allOptionsRounded];

	allOptionNames={Method,TargetAntigen,NumberOfReplicates,WashingBuffer,CoatingAntibody,CoatingAntibodyDilutionFactor,CoatingAntibodyVolume,CoatingAntibodyDiluent,CoatingAntibodyStorageCondition,CaptureAntibody,CaptureAntibodyDilutionFactor,CaptureAntibodyVolume,CaptureAntibodyDiluent,CaptureAntibodyStorageCondition,ReferenceAntigen,ReferenceAntigenDilutionFactor,ReferenceAntigenVolume,ReferenceAntigenDiluent,ReferenceAntigenStorageCondition,PrimaryAntibody,PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyStorageCondition,SecondaryAntibody,SecondaryAntibodyDilutionFactor,SecondaryAntibodyVolume,SecondaryAntibodyDiluent,SecondaryAntibodyStorageCondition,SampleAntibodyComplexIncubation,SampleAntibodyComplexIncubationTime,SampleAntibodyComplexIncubationTemperature,Coating,SampleCoatingVolume,CoatingAntibodyCoatingVolume,ReferenceAntigenCoatingVolume,CaptureAntibodyCoatingVolume,CoatingTemperature,CoatingTime,CoatingWashVolume,CoatingNumberOfWashes,Blocking,BlockingBuffer,BlockingVolume,BlockingTemperature,BlockingTime,BlockingMixRate,BlockingWashVolume,BlockingNumberOfWashes,SampleAntibodyComplexImmunosorbentVolume,SampleAntibodyComplexImmunosorbentTime,SampleAntibodyComplexImmunosorbentTemperature,SampleAntibodyComplexImmunosorbentMixRate,SampleAntibodyComplexImmunosorbentWashVolume,SampleAntibodyComplexImmunosorbentNumberOfWashes,SampleImmunosorbentVolume,SampleImmunosorbentTime,SampleImmunosorbentTemperature,SampleImmunosorbentMixRate,SampleImmunosorbentWashVolume,SampleImmunosorbentNumberOfWashes,PrimaryAntibodyImmunosorbentVolume,PrimaryAntibodyImmunosorbentTime,PrimaryAntibodyImmunosorbentTemperature,PrimaryAntibodyImmunosorbentMixRate,PrimaryAntibodyImmunosorbentWashVolume,PrimaryAntibodyImmunosorbentNumberOfWashes,SecondaryAntibodyImmunosorbentVolume,SecondaryAntibodyImmunosorbentTime,SecondaryAntibodyImmunosorbentTemperature,SecondaryAntibodyImmunosorbentMixRate,SecondaryAntibodyImmunosorbentWashVolume,SecondaryAntibodyImmunosorbentNumberOfWashes,SubstrateSolution,StopSolution,SubstrateSolutionVolume,StopSolutionVolume,SubstrateIncubationTime,SubstrateIncubationTemperature,SubstrateIncubationMixRate,AbsorbanceWavelength,PrereadBeforeStop,PrereadTimepoints,PrereadAbsorbanceWavelength,SignalCorrection,Standard,StandardTargetAntigen,StandardDilutionCurve,StandardSerialDilutionCurve,StandardDiluent,StandardStorageCondition,StandardCoatingAntibody,StandardCoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume,StandardCoatingAntibodyStorageCondition,StandardCaptureAntibody,StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume,StandardCaptureAntibodyStorageCondition,StandardReferenceAntigen,StandardReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume,StandardReferenceAntigenStorageCondition,StandardPrimaryAntibody,StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyStorageCondition,StandardSecondaryAntibody,StandardSecondaryAntibodyDilutionFactor,StandardSecondaryAntibodyVolume,StandardSecondaryAntibodyStorageCondition,StandardCoatingVolume,StandardReferenceAntigenCoatingVolume,StandardCoatingAntibodyCoatingVolume,StandardCaptureAntibodyCoatingVolume,StandardBlockingVolume,StandardAntibodyComplexImmunosorbentVolume,StandardImmunosorbentVolume,StandardPrimaryAntibodyImmunosorbentVolume,StandardSecondaryAntibodyImmunosorbentVolume,StandardSubstrateSolution,StandardStopSolution,StandardSubstrateSolutionVolume,StandardStopSolutionVolume,Blank,BlankTargetAntigen,BlankStorageCondition,BlankCoatingAntibody,BlankCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume,BlankCoatingAntibodyStorageCondition,BlankCaptureAntibody,BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume,BlankCaptureAntibodyStorageCondition,BlankReferenceAntigen,BlankReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume,BlankReferenceAntigenStorageCondition,BlankPrimaryAntibody,BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyStorageCondition,BlankSecondaryAntibody,BlankSecondaryAntibodyDilutionFactor,BlankSecondaryAntibodyVolume,BlankSecondaryAntibodyStorageCondition,BlankCoatingVolume,BlankReferenceAntigenCoatingVolume,BlankCoatingAntibodyCoatingVolume,BlankCaptureAntibodyCoatingVolume,BlankBlockingVolume,BlankAntibodyComplexImmunosorbentVolume,BlankImmunosorbentVolume,BlankPrimaryAntibodyImmunosorbentVolume,BlankSecondaryAntibodyImmunosorbentVolume,BlankSubstrateSolution,BlankStopSolution,BlankSubstrateSolutionVolume,BlankStopSolutionVolume,Spike,SpikeDilutionFactor,SpikeStorageCondition,SampleDilutionCurve,SampleSerialDilutionCurve,SampleDiluent,ELISAPlate,SecondaryELISAPlate,ELISAPlateAssignment,SecondaryELISAPlateAssignment,AliquotAmount,TargetConcentration,TargetConcentrationAnalyte,AssayVolume,AliquotContainer,DestinationWell,ConcentratedBuffer,BufferDilutionFactor,BufferDiluent,AssayBuffer,AliquotSampleStorageCondition,Aliquot,ConsolidateAliquots,AliquotPreparation
	};

	(*Get option values upfront.*)
	{suppliedMethod,suppliedTargetAntigen,suppliedNumberOfReplicates,suppliedWashingBuffer,suppliedCoatingAntibody,suppliedCoatingAntibodyDilutionFactor,suppliedCoatingAntibodyVolume,suppliedCoatingAntibodyDiluent,suppliedCoatingAntibodyStorageCondition,suppliedCaptureAntibody,suppliedCaptureAntibodyDilutionFactor,suppliedCaptureAntibodyVolume,suppliedCaptureAntibodyDiluent,suppliedCaptureAntibodyStorageCondition,suppliedReferenceAntigen,suppliedReferenceAntigenDilutionFactor,suppliedReferenceAntigenVolume,suppliedReferenceAntigenDiluent,suppliedReferenceAntigenStorageCondition,suppliedPrimaryAntibody,suppliedPrimaryAntibodyDilutionFactor,suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyDiluent,suppliedPrimaryAntibodyStorageCondition,suppliedSecondaryAntibody,suppliedSecondaryAntibodyDilutionFactor,suppliedSecondaryAntibodyVolume,suppliedSecondaryAntibodyDiluent,suppliedSecondaryAntibodyStorageCondition,suppliedSampleAntibodyComplexIncubation,suppliedSampleAntibodyComplexIncubationTime,suppliedSampleAntibodyComplexIncubationTemperature,suppliedCoating,suppliedSampleCoatingVolume,suppliedCoatingAntibodyCoatingVolume,suppliedReferenceAntigenCoatingVolume,suppliedCaptureAntibodyCoatingVolume,suppliedCoatingTemperature,suppliedCoatingTime,suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes,suppliedBlocking,suppliedBlockingBuffer,suppliedBlockingVolume,suppliedBlockingTemperature,suppliedBlockingTime,suppliedBlockingMixRate,suppliedBlockingWashVolume,suppliedBlockingNumberOfWashes,suppliedSampleAntibodyComplexImmunosorbentVolume,suppliedSampleAntibodyComplexImmunosorbentTime,suppliedSampleAntibodyComplexImmunosorbentTemperature,suppliedSampleAntibodyComplexImmunosorbentMixRate,suppliedSampleAntibodyComplexImmunosorbentWashVolume,suppliedSampleAntibodyComplexImmunosorbentNumberOfWashes,suppliedSampleImmunosorbentVolume,suppliedSampleImmunosorbentTime,suppliedSampleImmunosorbentTemperature,suppliedSampleImmunosorbentMixRate,suppliedSampleImmunosorbentWashVolume,suppliedSampleImmunosorbentNumberOfWashes,suppliedPrimaryAntibodyImmunosorbentVolume,suppliedPrimaryAntibodyImmunosorbentTime,suppliedPrimaryAntibodyImmunosorbentTemperature,suppliedPrimaryAntibodyImmunosorbentMixRate,suppliedPrimaryAntibodyImmunosorbentWashVolume,suppliedPrimaryAntibodyImmunosorbentNumberOfWashes,suppliedSecondaryAntibodyImmunosorbentVolume,suppliedSecondaryAntibodyImmunosorbentTime,suppliedSecondaryAntibodyImmunosorbentTemperature,suppliedSecondaryAntibodyImmunosorbentMixRate,suppliedSecondaryAntibodyImmunosorbentWashVolume,suppliedSecondaryAntibodyImmunosorbentNumberOfWashes,suppliedSubstrateSolution,suppliedStopSolution,suppliedSubstrateSolutionVolume,suppliedStopSolutionVolume,suppliedSubstrateIncubationTime,suppliedSubstrateIncubationTemperature,suppliedSubstrateIncubationMixRate,suppliedAbsorbanceWavelength,suppliedPrereadBeforeStop,suppliedPrereadTimepoints,suppliedPrereadAbsorbanceWavelength,suppliedSignalCorrection,suppliedStandard,suppliedStandardTargetAntigen,suppliedStandardDilutionCurve,suppliedStandardSerialDilutionCurve,suppliedStandardDiluent,suppliedStandardStorageCondition,suppliedStandardCoatingAntibody,suppliedStandardCoatingAntibodyDilutionFactor,suppliedStandardCoatingAntibodyVolume,suppliedStandardCoatingAntibodyStorageCondition,suppliedStandardCaptureAntibody,suppliedStandardCaptureAntibodyDilutionFactor,suppliedStandardCaptureAntibodyVolume,suppliedStandardCaptureAntibodyStorageCondition,suppliedStandardReferenceAntigen,suppliedStandardReferenceAntigenDilutionFactor,suppliedStandardReferenceAntigenVolume,suppliedStandardReferenceAntigenStorageCondition,suppliedStandardPrimaryAntibody,suppliedStandardPrimaryAntibodyDilutionFactor,suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyStorageCondition,suppliedStandardSecondaryAntibody,suppliedStandardSecondaryAntibodyDilutionFactor,suppliedStandardSecondaryAntibodyVolume,suppliedStandardSecondaryAntibodyStorageCondition,suppliedStandardCoatingVolume,suppliedStandardReferenceAntigenCoatingVolume,suppliedStandardCoatingAntibodyCoatingVolume,suppliedStandardCaptureAntibodyCoatingVolume,suppliedStandardBlockingVolume,suppliedStandardAntibodyComplexImmunosorbentVolume,suppliedStandardImmunosorbentVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume,suppliedStandardSecondaryAntibodyImmunosorbentVolume,suppliedStandardSubstrateSolution,suppliedStandardStopSolution,suppliedStandardSubstrateSolutionVolume,suppliedStandardStopSolutionVolume,suppliedBlank,suppliedBlankTargetAntigen,suppliedBlankStorageCondition,suppliedBlankCoatingAntibody,suppliedBlankCoatingAntibodyDilutionFactor,suppliedBlankCoatingAntibodyVolume,suppliedBlankCoatingAntibodyStorageCondition,suppliedBlankCaptureAntibody,suppliedBlankCaptureAntibodyDilutionFactor,suppliedBlankCaptureAntibodyVolume,suppliedBlankCaptureAntibodyStorageCondition,suppliedBlankReferenceAntigen,suppliedBlankReferenceAntigenDilutionFactor,suppliedBlankReferenceAntigenVolume,suppliedBlankReferenceAntigenStorageCondition,suppliedBlankPrimaryAntibody,suppliedBlankPrimaryAntibodyDilutionFactor,suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyStorageCondition,suppliedBlankSecondaryAntibody,suppliedBlankSecondaryAntibodyDilutionFactor,suppliedBlankSecondaryAntibodyVolume,suppliedBlankSecondaryAntibodyStorageCondition,suppliedBlankCoatingVolume,suppliedBlankReferenceAntigenCoatingVolume,suppliedBlankCoatingAntibodyCoatingVolume,suppliedBlankCaptureAntibodyCoatingVolume,suppliedBlankBlockingVolume,suppliedBlankAntibodyComplexImmunosorbentVolume,suppliedBlankImmunosorbentVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume,suppliedBlankSecondaryAntibodyImmunosorbentVolume,suppliedBlankSubstrateSolution,suppliedBlankStopSolution,suppliedBlankSubstrateSolutionVolume,suppliedBlankStopSolutionVolume,suppliedSpike,suppliedSpikeDilutionFactor,suppliedSpikeStorageCondition,suppliedSampleDilutionCurve,suppliedSampleSerialDilutionCurve,suppliedSampleDiluent,suppliedELISAPlate,suppliedSecondaryELISAPlate,suppliedELISAPlateAssignment,suppliedSecondaryELISAPlateAssignment,suppliedAliquotAmount,suppliedTargetConcentration,suppliedTargetConcentrationAnalyte,suppliedAssayVolume,suppliedAliquotContainer,suppliedDestinationWell,suppliedConcentratedBuffer,suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAssayBuffer,suppliedAliquotSampleStorageCondition,suppliedAliquot,suppliedConsolidateAliquots,suppliedAliquotLiquidHandlingScale
	}=Lookup[allOptionsRoundedAssociation,allOptionNames];

	(*Resolve NumberOfReplicates*)
	resolvedNumberOfReplicates=If[suppliedNumberOfReplicates===Automatic,
		If[MatchQ[{suppliedMethod,suppliedCoating},{(DirectELISA|IndirectELISA),False}],Null,2],
		suppliedNumberOfReplicates
	];

	(*NumberOfReplicates being Null means 1*)
	resolvedNumberOfReplicatesNullToOne=resolvedNumberOfReplicates/.Null->1;

	(*=========================================CONFLICTING OPTIONS CHECKS======================================*)
	(* Standard related options--switched off by standard->Null*)
	(*Standard related options are all IndexMatched to Standards, EXCEPT for standard diluent.*)
	(*Get unNull StandardDiluent when standard is Null*)
	standardIndexSwitchedOptions = {
		StandardDilutionCurve,
		StandardSerialDilutionCurve,
		StandardStorageCondition,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		
		StandardPrimaryAntibody,
		StandardPrimaryAntibodyDilutionFactor,
		StandardPrimaryAntibodyVolume,
		
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		
		StandardCoatingVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardBlockingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		StandardSubstrateSolutionVolume,
		StandardStopSolutionVolume
	};

	{standardConflictingUnullOptions, standardConflictingUnullTests} = If[MatchQ[suppliedStandard, Null|{Null..}],
		elisaMasterSwitch["Standard is Null", {StandardDiluent}, standardIndexSwitchedOptions, {}, {}][[{1, 3}]],
		{{},{}}
	];

	(* Blank related options--switched off by blank->Null*)
	(*All optiones IndexMatched blank and switched off by blank being null/{}*)
	blankIndexSwitchedOptions = {
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		BlankReferenceAntigenVolume,
		BlankPrimaryAntibody,
		BlankPrimaryAntibodyDilutionFactor,
		BlankPrimaryAntibodyVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankBlockingVolume,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume,
		BlankSubstrateSolutionVolume,
		BlankStopSolutionVolume
	};

	{blankConflictingUnullOptions, blankConflictingUnullTests} = If[MatchQ[Lookup[allOptionsRoundedAssociation, Blank], Null|{Null..}],
		elisaMasterSwitch["Blank is Null", {}, blankIndexSwitchedOptions, {}, {}][[{1, 3}]],
		{{},{}}
	];

	(* ELISA MethodsConflictingOptions--Must Null or Must Unull options*)
	(*setup conflicting options lists*)
	directELISAMustNullSingleSampleOptions= {
		CoatingAntibodyDiluent,
		CaptureAntibodyDiluent,
		ReferenceAntigenDiluent,
		SecondaryAntibodyDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes,
		SampleAntibodyComplexImmunosorbentMixRate,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentMixRate,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentMixRate,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	directELISAMustNullIndexedOptions = {
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		CaptureAntibody,
		CaptureAntibodyDilutionFactor,
		CaptureAntibodyVolume,
		CaptureAntibodyStorageCondition,
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyDilutionFactor,
		SecondaryAntibodyVolume,
		SecondaryAntibodyStorageCondition,
		CoatingAntibodyCoatingVolume,
		ReferenceAntigenCoatingVolume,
		CaptureAntibodyCoatingVolume,
		SampleAntibodyComplexImmunosorbentVolume,
		SampleImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	indirectELISAMustNullSingleSampleOptions={
		CoatingAntibodyDiluent,
		CaptureAntibodyDiluent,
		ReferenceAntigenDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes,
		SampleAntibodyComplexImmunosorbentMixRate,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentMixRate,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes
	};
	indirectELISAMustNullIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		CaptureAntibody,
		CaptureAntibodyDilutionFactor,
		CaptureAntibodyVolume,
		CaptureAntibodyStorageCondition,
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		CoatingAntibodyCoatingVolume,
		ReferenceAntigenCoatingVolume,
		CaptureAntibodyCoatingVolume,
		SampleAntibodyComplexImmunosorbentVolume,
		SampleImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankImmunosorbentVolume
	};
	directSandwichELISAMustNullSingleSampleOptions={
		CoatingAntibodyDiluent,
		ReferenceAntigenDiluent,
		SecondaryAntibodyDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentMixRate,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentMixRate,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	directSandwichELISAMustNullIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyDilutionFactor,
		SecondaryAntibodyVolume,
		SecondaryAntibodyStorageCondition,
		SampleCoatingVolume,
		CoatingAntibodyCoatingVolume,
		ReferenceAntigenCoatingVolume,
		SampleAntibodyComplexImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		StandardCoatingVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	indirectSandwichELISAMustNullSingleSampleOptions={
		CoatingAntibodyDiluent,
		ReferenceAntigenDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentMixRate,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes
	};
	indirectSandwichELISAMustNullIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		SampleCoatingVolume,
		CoatingAntibodyCoatingVolume,
		ReferenceAntigenCoatingVolume,
		SampleAntibodyComplexImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardCoatingVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankAntibodyComplexImmunosorbentVolume
	};
	directCompetitiveELISAMustNullSingleSampleOptions={
		CoatingAntibodyDiluent,
		CaptureAntibodyDiluent,
		SecondaryAntibodyDiluent,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentMixRate,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentMixRate,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentMixRate,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	directCompetitiveELISAMustNullIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		CaptureAntibody,
		CaptureAntibodyDilutionFactor,
		CaptureAntibodyVolume,
		CaptureAntibodyStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyDilutionFactor,
		SecondaryAntibodyVolume,
		SecondaryAntibodyStorageCondition,
		SampleCoatingVolume,
		CoatingAntibodyCoatingVolume,
		CaptureAntibodyCoatingVolume,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		StandardCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	indirectCompetitiveELISAMustNullSingleSampleOptions={
		CoatingAntibodyDiluent,
		CaptureAntibodyDiluent,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentMixRate,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentMixRate,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes
	};
	indirectCompetitiveELISAMustNullIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		CaptureAntibody,
		CaptureAntibodyDilutionFactor,
		CaptureAntibodyVolume,
		CaptureAntibodyStorageCondition,
		SampleCoatingVolume,
		CoatingAntibodyCoatingVolume,
		CaptureAntibodyCoatingVolume,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		StandardCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume
	};
	fastELISAMustNullSingleSampleOptions={
		ReferenceAntigenDiluent,
		SecondaryAntibodyDiluent,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentMixRate,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentMixRate,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentMixRate,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	fastELISAMustNullIndexedOptions={
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyDilutionFactor,
		SecondaryAntibodyVolume,
		SecondaryAntibodyStorageCondition,
		SampleCoatingVolume,
		ReferenceAntigenCoatingVolume,
		CaptureAntibodyCoatingVolume,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		StandardCoatingVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		BlankReferenceAntigenVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	directELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes
	};
	directELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		PrimaryAntibodyImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardPrimaryAntibodyImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankPrimaryAntibodyImmunosorbentVolume
	};
	indirectELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		SecondaryAntibodyDiluent,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	indirectELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyStorageCondition,
		PrimaryAntibodyImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankSecondaryAntibody,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	directSandwichELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes
	};
	directSandwichELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume
	};
	indirectSandwichELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		SecondaryAntibodyDiluent,
		SampleImmunosorbentTime,
		SampleImmunosorbentTemperature,
		SampleImmunosorbentWashVolume,
		SampleImmunosorbentNumberOfWashes,
		PrimaryAntibodyImmunosorbentTime,
		PrimaryAntibodyImmunosorbentTemperature,
		PrimaryAntibodyImmunosorbentWashVolume,
		PrimaryAntibodyImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	indirectSandwichELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyStorageCondition,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankSecondaryAntibody,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	directCompetitiveELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes
	};
	directCompetitiveELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SampleAntibodyComplexImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardAntibodyComplexImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankAntibodyComplexImmunosorbentVolume
	};
	indirectCompetitiveELISAMustUnullSingleSampleOptions={
		PrimaryAntibodyDiluent,
		SecondaryAntibodyDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes,
		SecondaryAntibodyImmunosorbentTime,
		SecondaryAntibodyImmunosorbentTemperature,
		SecondaryAntibodyImmunosorbentWashVolume,
		SecondaryAntibodyImmunosorbentNumberOfWashes
	};
	indirectCompetitiveELISAMustUnullIndexedOptions={
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SecondaryAntibody,
		SecondaryAntibodyStorageCondition,
		SampleAntibodyComplexImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		BlankPrimaryAntibody,
		BlankSecondaryAntibody,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume
	};
	fastELISAMustUnullSingleSampleOptions={
		CaptureAntibodyDiluent,
		PrimaryAntibodyDiluent,
		SampleAntibodyComplexImmunosorbentTime,
		SampleAntibodyComplexImmunosorbentTemperature,
		SampleAntibodyComplexImmunosorbentWashVolume,
		SampleAntibodyComplexImmunosorbentNumberOfWashes
	};
	fastELISAMustUnullIndexedOptions={
		CaptureAntibody,
		CaptureAntibodyStorageCondition,
		PrimaryAntibody,
		PrimaryAntibodyStorageCondition,
		SampleAntibodyComplexImmunosorbentVolume,
		StandardCaptureAntibody,
		StandardPrimaryAntibody,
		StandardAntibodyComplexImmunosorbentVolume,
		BlankCaptureAntibody,
		BlankPrimaryAntibody,
		BlankAntibodyComplexImmunosorbentVolume
	};



	{methodConflictingUnullOptionsAll,methodConflictingNullOptionsAll,
		methodConflictingUnullTests, methodConflictingNullTests} =If[
		!MatchQ[suppliedStandard,{Null}|Null]&&!MatchQ[suppliedBlank,{Null}|Null],
		Which[
			suppliedMethod===DirectELISA,
			elisaMasterSwitch["Method is DirectELISA",
				directELISAMustNullSingleSampleOptions, directELISAMustNullIndexedOptions,
				directELISAMustUnullSingleSampleOptions, directELISAMustUnullIndexedOptions
			],
			suppliedMethod===IndirectELISA,
			elisaMasterSwitch["Method is IndirectELISA",
				indirectELISAMustNullSingleSampleOptions, indirectELISAMustNullIndexedOptions,
				indirectELISAMustUnullSingleSampleOptions, indirectELISAMustUnullIndexedOptions
			],
			suppliedMethod===DirectSandwichELISA,
			elisaMasterSwitch["Method is DirectSandwichELISA",
				directSandwichELISAMustNullSingleSampleOptions, directSandwichELISAMustNullIndexedOptions,
				directSandwichELISAMustUnullSingleSampleOptions, directSandwichELISAMustUnullIndexedOptions
			],
			suppliedMethod===IndirectSandwichELISA,
			elisaMasterSwitch["Method is IndirectSandwichELISA",
				indirectSandwichELISAMustNullSingleSampleOptions, indirectSandwichELISAMustNullIndexedOptions,
				indirectSandwichELISAMustUnullSingleSampleOptions, indirectSandwichELISAMustUnullIndexedOptions
			],
			suppliedMethod===DirectCompetitiveELISA,
			elisaMasterSwitch["Method is DirectCompetitiveELISA",
				directCompetitiveELISAMustNullSingleSampleOptions, directCompetitiveELISAMustNullIndexedOptions,
				directCompetitiveELISAMustUnullSingleSampleOptions, directCompetitiveELISAMustUnullIndexedOptions
			],
			suppliedMethod===IndirectCompetitiveELISA,
			elisaMasterSwitch["Method is IndirectCompetitiveELISA",
				indirectCompetitiveELISAMustNullSingleSampleOptions, indirectCompetitiveELISAMustNullIndexedOptions,
				indirectCompetitiveELISAMustUnullSingleSampleOptions, indirectCompetitiveELISAMustUnullIndexedOptions
			],
			suppliedMethod===FastELISA,
			elisaMasterSwitch["Method is FastELISA",
				fastELISAMustNullSingleSampleOptions, fastELISAMustNullIndexedOptions,
				fastELISAMustUnullSingleSampleOptions, fastELISAMustUnullIndexedOptions
			]
		],
		{{}, {}, {}, {}}
	];


	
	(* ELISA MethodsConflictingOptions--EitherOr*)

	(*Some options were taken away because they also take into account of the Coating switch.*)
	directELISAEitherOrOptionGroups={
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume}
	};
	indirectELISAEitherOrOptionGroups={
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume}
	};
	indirectSandwichELISAEitherOrOptionGroups={
		{}
	};
	directCompetitiveELISAEitherOrOptionGroups={
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume}
	};
	indirectCompetitiveELISAEitherOrOptionGroup ={
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume}
	};
	fastELISAEitherOrOptionGroups={
		{CaptureAntibodyDilutionFactor,CaptureAntibodyVolume},
		{PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume}
	};
	directELISAStandardEitherOrOptionGroups={
		{StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume}
	};
	indirectELISAStandardEitherOrOptionGroups={
		{StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume}
	};
	indirectSandwichELISAStandardEitherOrOptionGroups={
		{}
	};
	directCompetitiveELISAStandardEitherOrOptionGroups={
		{StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume}
	};
	indirectCompetitiveELISAStandardEitherOrOptionGroup ={
		{StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume}
	};
	fastELISStandardAEitherOrOptionGroups={
		{StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume},
		{StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume}
	};
	directELISABlankEitherOrOptionGroups={
		{BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume}
	};
	indirectELISABlankEitherOrOptionGroups={
		{BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume}
	};
	indirectSandwichELISABlankEitherOrOptionGroups={
		{}
	};
	directCompetitiveELISABlankEitherOrOptionGroups={
		{BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume}
	};
	indirectCompetitiveELISABlankEitherOrOptionGroup ={
		{BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume}
	};
	fastELISABlankEitherOrOptionGroups={
		{BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume},
		{BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume}
	};

	{methodEitherOrConflictingOptions, methodEitherOrConflictingTests}=
		Which[
			suppliedMethod===DirectELISA,
			elisaEitherOr[{{}},directELISAEitherOrOptionGroups],
			suppliedMethod===IndirectELISA,
			elisaEitherOr[{{}},indirectELISAEitherOrOptionGroups],
			suppliedMethod===IndirectSandwichELISA,
			elisaEitherOr[{{}},indirectSandwichELISAEitherOrOptionGroups],
			suppliedMethod===DirectCompetitiveELISA,
			elisaEitherOr[{{}},directCompetitiveELISAEitherOrOptionGroups],
			suppliedMethod===IndirectCompetitiveELISA,
			elisaEitherOr[{{}},indirectCompetitiveELISAEitherOrOptionGroup],
			suppliedMethod===FastELISA,
			elisaEitherOr[{{}},fastELISAEitherOrOptionGroups],

			True,{{},{}}
		];

	{methodEitherOrStandardConflictingOptions, methodEitherOrStandardConflictingTests}=
		If[suppliedStandard=!={Null},
			Which[
				suppliedMethod===DirectELISA,
				elisaEitherOr[{{}},directELISAStandardEitherOrOptionGroups],
				suppliedMethod===IndirectELISA,
				elisaEitherOr[{{}},indirectELISAStandardEitherOrOptionGroups],
				suppliedMethod===IndirectSandwichELISA,
				elisaEitherOr[{{}},indirectSandwichELISAStandardEitherOrOptionGroups],
				suppliedMethod===DirectCompetitiveELISA,
				elisaEitherOr[{{}},directCompetitiveELISAStandardEitherOrOptionGroups],
				suppliedMethod===IndirectCompetitiveELISA,
				elisaEitherOr[{{}},indirectCompetitiveELISAStandardEitherOrOptionGroup],
				suppliedMethod===FastELISA,
				elisaEitherOr[{{}},fastELISAEitherOrOptionGroups],

				True,{{},{}}
			],
			{{},{}}];

	{methodEitherOrBlankConflictingOptions, methodEitherOrBlankConflictingTests}=
		If[suppliedBlank=!={Null},
			Which[
				suppliedMethod===DirectELISA,
				elisaEitherOr[{{}},directELISABlankEitherOrOptionGroups],
				suppliedMethod===IndirectELISA,
				elisaEitherOr[{{}},indirectELISABlankEitherOrOptionGroups],
				suppliedMethod===IndirectSandwichELISA,
				elisaEitherOr[{{}},indirectSandwichELISABlankEitherOrOptionGroups],
				suppliedMethod===DirectCompetitiveELISA,
				elisaEitherOr[{{}},directCompetitiveELISABlankEitherOrOptionGroups],
				suppliedMethod===IndirectCompetitiveELISA,
				elisaEitherOr[{{}},indirectCompetitiveELISABlankEitherOrOptionGroup],
				suppliedMethod===FastELISA,
				elisaEitherOr[{{}},fastELISABlankEitherOrOptionGroups],
				True,{{},{}}
			],
			{{},{}}];

	(* ELISA Method-SampleAntibodyComplexIncubation*)

	methodConflictingSampleAntibodyIncubationConflictingOption = If[
		MemberQ[{DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwich},suppliedMethod]&&TrueQ[suppliedSampleAntibodyComplexIncubation],
		{SampleAntibodyComplexIncubation},
		{}];

	If[methodConflictingSampleAntibodyIncubationConflictingOption=!={}&&messages,
		Message[Error::MethodConflictingSampleAntibodyIncubationSwitch]
	];

	methodConflictingSampleAntibodyIncubationTest=If[gatherTests,
		Test["When Method is DirectELISA, IndirectELISA, DirectSandwichELISA, or IndirectSandwich, SampleAntibodyComplexInbuation is False:",
			True,
			Length[methodConflictingSampleAntibodyIncubationConflictingOption]===0
		]
	];

	(* SampleAntibodyComplexIncubation switch*)

	(* resolve minor master switch - SampleAntibodyComplexIncubate boolean *)
	resolvedSampleAntibodyComplexIncubation=Which[
		!MatchQ[suppliedSampleAntibodyComplexIncubation,Automatic],suppliedSampleAntibodyComplexIncubation,
		(* Check if the child options are set *)
		MatchQ[{suppliedSampleAntibodyComplexIncubationTime,suppliedSampleAntibodyComplexIncubationTemperature},{Except[Null|Automatic],Except[Null]}|{Except[Null],Except[Null|Automatic]}],True,
		(* Otherwise go with the Method *)
		MatchQ[suppliedMethod,DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA],True,
		True,False
	];

	{sampleAntibodyComplexIncubationSwitchConflictingOptions,sampleAntibodyComplexIncubationSwitchConflictingTests}=If[TrueQ[resolvedSampleAntibodyComplexIncubation],
		elisaMasterSwitch["SampleAntibodyComplexIncubation is True",
			{},{},{SampleAntibodyComplexIncubationTime,SampleAntibodyComplexIncubationTemperature},{}][[{2,4}]],
		elisaMasterSwitch["SampleAntibodyComplexIncubation is False",
			{SampleAntibodyComplexIncubationTime,SampleAntibodyComplexIncubationTemperature},{},{},{}][[{1,3}]]
	];

	(* Coating and Blocking*)
	coatingSingleSampleOptions={CoatingTemperature, CoatingTime, CoatingWashVolume, CoatingNumberOfWashes};
	coatingIndexedOptions=Switch[suppliedMethod,
		(DirectELISA|IndirectELISA),{SampleCoatingVolume,StandardCoatingVolume,BlankCoatingVolume},
		(DirectSandwichELISA|IndirectSandwichELISA),{CaptureAntibodyCoatingVolume,StandardCaptureAntibodyCoatingVolume,BlankCaptureAntibodyCoatingVolume},
		(DirectCompetitiveELISA|IndirectCompetitiveELISA),{ReferenceAntigenCoatingVolume,StandardReferenceAntigenCoatingVolume,BlankReferenceAntigenCoatingVolume},
		FastELISA,{CoatingAntibodyCoatingVolume,StandardCoatingAntibodyCoatingVolume,BlankCoatingAntibodyCoatingVolume}
	];
	
	blockingIncubationSingleSampleOptions={BlockingTemperature,BlockingTime};
	blockingWashingSingleSampleOptions={BlockingWashVolume,BlockingNumberOfWashes};
	blockingIndexedOptions={BlockingVolume,StandardBlockingVolume,BlankBlockingVolume};


	{
		coatingBlockingConflictingUnullOptions,
		coatingBlockingConflictingNullOptions,
		coatingBlockingConflictingUnullTests,
		coatingBlockingConflictingNullTests
	} = Which[
		suppliedCoating&&suppliedBlocking,
		elisaMasterSwitch[
			"Coating is True and Blocking is True",
			{},(*must null options*)
			{},(*must null options*)
			Join[coatingSingleSampleOptions, blockingIncubationSingleSampleOptions, blockingWashingSingleSampleOptions],(*mustunnull*)
			Join[coatingIndexedOptions,blockingIndexedOptions](*mustunnull*)
		],

		suppliedCoating&&!suppliedBlocking,
		Message[Warning::CoatingButNoBlocking];
		elisaMasterSwitch[
			"Coating is True and Blocking is False",
			Join[blockingIncubationSingleSampleOptions, blockingWashingSingleSampleOptions],(*must null options*)
			blockingIndexedOptions,(*must null options*)
			coatingSingleSampleOptions, (*mustunnull*)
			coatingIndexedOptions (*mustunnull*)
		],

		(* Even when coating is False, we can still wash precoated plates *)
		!suppliedCoating&&suppliedBlocking,
		elisaMasterSwitch[
			"Coating is False and Blocking is True",
			DeleteCases[coatingSingleSampleOptions, CoatingWashVolume|CoatingNumberOfWashes],(*must null options*)
			coatingIndexedOptions,(*must null options*)
			{Join[blockingIncubationSingleSampleOptions,blockingWashingSingleSampleOptions]},(*mustunnull*)
			blockingIndexedOptions(*mustunnull*)
		],

		(* Even when coating is False, we can still wash precoated plates *)
		!suppliedCoating&&!suppliedBlocking,
		elisaMasterSwitch[
			"Coating is False and Blocking is False",
			Join[DeleteCases[coatingSingleSampleOptions, CoatingWashVolume|CoatingNumberOfWashes],blockingIncubationSingleSampleOptions],(*must null options*)
			Join[coatingIndexedOptions,blockingIndexedOptions],(*must null options*)
			{},(*mustunnull*)
			{}(*mustunnull*)
		]
	];

	(* Coating and Method--MustNull and MustUnull*)
	coatingSwichedDirectELISASingleSampleOptions={
		SampleDiluent
	};
	coatingSwichedDirectELISAIndexedOptions={
		SampleCoatingVolume
	};
	coatingSwichedSandwichELISASingleSampleOptions={
		CaptureAntibodyDiluent
	};
	coatingSwichedSandwichELISAIndexedOptions={
		CaptureAntibody,
		CaptureAntibodyStorageCondition,
		CaptureAntibodyCoatingVolume
	};
	coatingSwichedCompetitiveELISASingleSampleOptions={
		ReferenceAntigenDiluent
	};
	coatingSwichedCompetitiveELISAIndexedOptions={
		ReferenceAntigen,
		ReferenceAntigenStorageCondition,
		ReferenceAntigenCoatingVolume
	};
	coatingSwichedfastELISASingleSampleOptions={
		CoatingAntibodyDiluent
	};
	coatingSwichedfastELISAIndexedOptions={
		CoatingAntibody,
		CoatingAntibodyStorageCondition,
		CoatingAntibodyCoatingVolume
	};
	
	
	coatingSwichedDirectELISAStandardSingleSampleOptions={
		StandardDiluent
	};
	coatingSwichedfastELISAStandardIndexedOptions={
		StandardCoatingAntibody,
		StandardCoatingAntibodyCoatingVolume
	};
	coatingSwichedDirectELISAStandardIndexedOptions={
		StandardCoatingVolume
	};
	coatingSwichedSandwichELISAStandardIndexedOptions={
		StandardCaptureAntibody,
		StandardCaptureAntibodyCoatingVolume
	};
	coatingSwichedCompetitiveELISAStandardIndexedOptions={
		StandardReferenceAntigen,
		StandardReferenceAntigenCoatingVolume
	};
	coatingSwichedfastELISAStandardIndexedOptions={
		StandardCoatingAntibody,
		StandardCoatingAntibodyCoatingVolume
	};
	
	coatingSwichedDirectELISABlankIndexedOptions={
		BlankCoatingVolume
	};
	coatingSwichedSandwichELISABlankIndexedOptions={
		BlankCaptureAntibody,
		BlankCaptureAntibodyCoatingVolume
	};
	coatingSwichedCompetitiveELISABlankIndexedOptions={
		BlankReferenceAntigen,
		BlankReferenceAntigenCoatingVolume
	};
	coatingSwichedfastELISABlankIndexedOptions={
		BlankCoatingAntibody,
		BlankCoatingAntibodyCoatingVolume
	};

	{coatingAndMethodConflictingUnullOptions,coatingAndMethodConflictingNullOptions,
		coatingAndMethodConflictingUnullTests,coatingAndMethodConflictingNullTests} =Switch[
		{suppliedMethod,suppliedCoating},

		{(DirectELISA|IndirectELISA),True},
		elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is True",
			{},{},{},coatingSwichedDirectELISAIndexedOptions
		],

		{(DirectELISA|IndirectELISA),False},
		elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is False",
			coatingSwichedDirectELISASingleSampleOptions,
			Flatten[{coatingSwichedDirectELISAIndexedOptions,{SampleDilutionCurve,SampleSerialDilutionCurve,Spike,SpikeDilutionFactor}}],
			{},{}
		],

		{(DirectSandwichELISA|IndirectSandwichELISA),True},
		elisaMasterSwitch["Method is DirecSandwichtELISA or IndirectSandwichELISA and Coating is True",
			{},{},{},coatingSwichedSandwichELISAIndexedOptions
		],

		{(DirectSandwichELISA|IndirectSandwichELISA),False},
		elisaMasterSwitch["Method is DirectSandwichELISA or IndirectSandwichELISA and Coating is False",
			coatingSwichedSandwichELISASingleSampleOptions,coatingSwichedSandwichELISAIndexedOptions,{},{}
		],

		{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
		elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is True",
			{},{},{},coatingSwichedCompetitiveELISAIndexedOptions
		],

		{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
		elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is False",
			coatingSwichedCompetitiveELISASingleSampleOptions,coatingSwichedCompetitiveELISAIndexedOptions,{},{}
		],

		{FastELISA,True},
		elisaMasterSwitch["Method is FastELISA and Coating is True",
			{},{},{},coatingSwichedfastELISAIndexedOptions
		],

		{FastELISA,False},
		elisaMasterSwitch["Method is FastELISA and Coating is False",
			coatingSwichedfastELISASingleSampleOptions,coatingSwichedfastELISAIndexedOptions,{},{}
		]
	];

	{coatingAndMethodConflictingStandardUnullOptions,coatingAndMethodConflictingStandardNullOptions,
		coatingAndMethodConflictingStandardUnullTests,coatingAndMethodConflictingStandardNullTests} =
		If[!MatchQ[suppliedStandard,Null|{Null..}|{}],
			Switch[
				{suppliedMethod,suppliedCoating},

				{(DirectELISA|IndirectELISA),True},
				elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is True",
					{},{},{},coatingSwichedDirectELISAStandardIndexedOptions
				],
				
				{(DirectELISA|IndirectELISA),False},
				elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is False",
					coatingSwichedDirectELISAStandardSingleSampleOptions,Flatten[{coatingSwichedDirectELISAStandardIndexedOptions,{StandardDilutionCurve,StandardSerialDilutionCurve}}],{},{}
				],
				
				{(DirectSandwichELISA|IndirectSandwichELISA),True},
				elisaMasterSwitch["Method is DirectSandwichELISA or IndirectSandwichELISA and Coating is True",
					{},{},{},coatingSwichedSandwichELISAStandardIndexedOptions
				],

				{(DirectSandwichELISA|IndirectSandwichELISA),False},
				elisaMasterSwitch["Method is DirectSandwichELISA or IndirectSandwichELISA and Coating is False",
					{},coatingSwichedSandwichELISAStandardIndexedOptions,{},{}
				],
				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
				elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is True",
					{},{},{},coatingSwichedCompetitiveELISAStandardIndexedOptions
				],
				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
				elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is False",
					{},coatingSwichedCompetitiveELISAStandardIndexedOptions,{},{}
				],
				{FastELISA,True},
				elisaMasterSwitch["Method is FastELISA and Coating is True",
					{},{},{},coatingSwichedfastELISAStandardIndexedOptions
				],
				{FastELISA,False},
				elisaMasterSwitch["Method is FastELISA and Coating is False",
					{},coatingSwichedfastELISAStandardIndexedOptions,{},{}
				]
			],
			{{},{},{},{}}
		];
	{coatingAndMethodConflictingBlankUnullOptions,coatingAndMethodConflictingBlankNullOptions,
		coatingAndMethodConflictingBlankUnullTests,coatingAndMethodConflictingBlankNullTests} =
		If[!MatchQ[suppliedBlank,Null|{Null..}|{}],
			Switch[
				{suppliedMethod,suppliedCoating},

				{(DirectELISA|IndirectELISA),True},
				elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is True",
					{},{},{},coatingSwichedDirectELISABlankIndexedOptions
				],

				{(DirectELISA|IndirectELISA),False},
				elisaMasterSwitch["Method is DirectELISA or IndirectELISA and Coating is False",
					{},coatingSwichedDirectELISABlankIndexedOptions,{},{}
				],

				{(DirectSandwichELISA|IndirectSandwichELISA),True},
				elisaMasterSwitch["Method is DirectSandwichELISA or IndirectSandwichELISA and Coating is True",
					{},{},{},coatingSwichedSandwichELISABlankIndexedOptions
				],

				{(DirectSandwichELISA|IndirectSandwichELISA),False},
				elisaMasterSwitch["Method is DirectSandwichELISA or IndirectSandwichELISA and Coating is False",
					{},coatingSwichedSandwichELISABlankIndexedOptions,{},{}
				],
				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
				elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is True",
					{},{},{},coatingSwichedCompetitiveELISABlankIndexedOptions
				],
				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
				elisaMasterSwitch["Method is DirectCompetitiveELISA or IndirectCompetitiveELISA and Coating is False",
					{},coatingSwichedCompetitiveELISABlankIndexedOptions,{},{}
				],
				{FastELISA,True},
				elisaMasterSwitch["Method is FastELISA and Coating is True",
					{},{},{},coatingSwichedfastELISABlankIndexedOptions
				],
				{FastELISA,False},
				elisaMasterSwitch["Method is FastELISA and Coating is False",
					{},coatingSwichedfastELISABlankIndexedOptions,{},{}
				]
			],
			{{},{},{},{}}
		];
	

	(* Coating and Method--One and only one Unull if Coating is True. Both Null if Coating is False*)

	coatingSwitchedSandwichELISADilutionOptionGroup={
		{CaptureAntibodyDilutionFactor,CaptureAntibodyVolume}
	};
	coatingSwitchedCompetitiveELISADilutionOptionGroup={
		{ReferenceAntigenDilutionFactor,ReferenceAntigenVolume}
	};
	coatingSwitchedFastELISADilutionOptionGroup={
		{CoatingAntibodyDilutionFactor,CoatingAntibodyVolume}
	};
	coatingSwitchedSandwichELISAStandardDilutionOptionGroup={
		{StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume}
	};
	coatingSwitchedCompetitiveELISAStandardDilutionOptionGroup={
		{StandardReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume}
	};
	coatingSwitchedFastELISAStandardADilutionOptionGroup={
		{StandardCoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume}
	};
	coatingSwitchedSandwichELISABlankDilutionOptionGroup={
		{BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume}
	};
	coatingSwitchedCompetitiveELISABlankDilutionOptionGroup={
		{BlankReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume}
	};
	coatingSwitchedFastELISABlankADilutionOptionGroup={
		{BlankCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume}
	};

	{coatingAndMethodConflictingDilutionOptions,coatingAndMethodConflictingDilutionOptionTests} =Switch[
		{suppliedMethod,suppliedCoating},

		{(DirectSandwichELISA|IndirectSandwichELISA),True},
		elisaEitherOr[{{}},coatingSwitchedSandwichELISADilutionOptionGroup],

		{(DirectSandwichELISA|IndirectSandwichELISA),False},
		elisaMasterSwitch["Coating is False and Method is DirectSandwichELISA or IndirectSandwichELISA",
			{},Flatten[coatingSwitchedSandwichELISADilutionOptionGroup],{},{}
		][[{1, 3}]],

		{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
		elisaEitherOr[{{}},coatingSwitchedCompetitiveELISADilutionOptionGroup],

		{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
		elisaMasterSwitch["Coating is False and Method is DirectCompetitiveELISA or IndirectCompetitiveELISA",
			{},Flatten[coatingSwitchedCompetitiveELISADilutionOptionGroup],{},{}
		][[{1, 3}]],

		{FastELISA,True},
		elisaEitherOr[{{}},coatingSwitchedFastELISADilutionOptionGroup],

		{FastELISA,False},
		elisaMasterSwitch["Coating is False and Method is FastELISA",
			{},Flatten[coatingSwitchedFastELISADilutionOptionGroup],{},{}
		][[{1, 3}]],

		_,{{},{}}
	];

	{coatingAndMethodConflictingDilutionStandardOptions,coatingAndMethodConflictingDilutionStandardOptionTests} =
		If[!MatchQ[suppliedStandard,Null|{Null..}|{}],

			Switch[{suppliedMethod,suppliedCoating},
				
				{(DirectSandwichELISA|IndirectSandwichELISA),True},
				elisaEitherOr[{{}},coatingSwitchedSandwichELISAStandardDilutionOptionGroup],

				{(DirectSandwichELISA|IndirectSandwichELISA),False},
				elisaMasterSwitch["Coating is False and Method is DirectSandwichELISA or IndirectSandwichELISA",
					{},Flatten[coatingSwitchedSandwichELISAStandardDilutionOptionGroup],{},{}
				][[{1, 3}]],

				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
				elisaEitherOr[{{}},coatingSwitchedCompetitiveELISAStandardDilutionOptionGroup],

				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
				elisaMasterSwitch["Coating is False and Method is DirectCompetitiveELISA or IndirectCompetitiveELISA",
					{},Flatten[coatingSwitchedCompetitiveELISAStandardDilutionOptionGroup],{},{}
				][[{1, 3}]],

				{FastELISA,True},
				elisaEitherOr[{{}},coatingSwitchedFastELISAStandardADilutionOptionGroup],

				{FastELISA,False},
				elisaMasterSwitch["Coating is False and Method is FastELISA",
					{},Flatten[coatingSwitchedFastELISAStandardADilutionOptionGroup],{},{}
				][[{1, 3}]],

				_, {{},{}}
			],
			{{},{}}
		];

	{coatingAndMethodConflictingDilutionBlankOptions,coatingAndMethodConflictingDilutionBlankOptionTests} =
		If[!MatchQ[suppliedBlank,Null|{Null..}|{}],

			Switch[{suppliedMethod,suppliedCoating},

				{(DirectSandwichELISA|IndirectSandwichELISA),True},
				elisaEitherOr[{{}},coatingSwitchedSandwichELISABlankDilutionOptionGroup],

				{(DirectSandwichELISA|IndirectSandwichELISA),False},
				elisaMasterSwitch["Coating is False and Method is DirectSandwichELISA or IndirectSandwichELISA",
					{},Flatten[coatingSwitchedSandwichELISABlankDilutionOptionGroup],{},{}
				][[{1, 3}]],

				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True},
				elisaEitherOr[{{}},coatingSwitchedCompetitiveELISABlankDilutionOptionGroup],

				{(DirectCompetitiveELISA|IndirectCompetitiveELISA),False},
				elisaMasterSwitch["Coating is False and Method is DirectCompetitiveELISA or IndirectCompetitiveELISA",
					{},Flatten[coatingSwitchedCompetitiveELISABlankDilutionOptionGroup],{},{}
				][[{1, 3}]],

				{FastELISA,True},
				elisaEitherOr[{{}},coatingSwitchedFastELISABlankADilutionOptionGroup],

				{FastELISA,False},
				elisaMasterSwitch["Coating is False and Method is FastELISA",
					{},Flatten[coatingSwitchedFastELISABlankADilutionOptionGroup],{},{}
				][[{1, 3}]],

				_, {{},{}}
			],
			{{},{}}
		];


	(* Substrate options--SameNull options*)
	substrateSameNullOptionNames={
		{SubstrateSolution,SubstrateSolutionVolume},
		{StopSolution,StopSolutionVolume},
		{StandardSubstrateSolution,StandardSubstrateSolutionVolume},
		{StandardStopSolution,StandardStopSolutionVolume},
		{BlankSubstrateSolution,BlankSubstrateSolutionVolume},
		{BlankStopSolution,BlankStopSolutionVolume}
	};
	substrateSameNullOptionValues={
		{suppliedSubstrateSolution,suppliedSubstrateSolutionVolume},
		{suppliedStopSolution,suppliedStopSolutionVolume},
		{suppliedStandardSubstrateSolution,suppliedStandardSubstrateSolutionVolume},
		{suppliedStandardStopSolution,suppliedStandardStopSolutionVolume},
		{suppliedBlankSubstrateSolution,suppliedBlankSubstrateSolutionVolume},
		{suppliedBlankStopSolution,suppliedBlankStopSolutionVolume}
	};
	{
		{substrateSolutionSameNullSameNullConflictingOptions,substrateSolutionSameNullConflictingTest},
		{stopSolutionSameNullConflictingOptions,stopSolutionSameNullConflictingTest},
		{standardSubstrateSolutionSameNullConflictingOptions,standardSubstrateSolutionSameNullConflictingTest},
		{standardStopSolutionSameNullConflictingOptions,standardStopSolutionSameNullConflictingTest},
		{blankSubstrateSolutionSameNullConflictingOptions,blankSubstrateSolutionSameNullConflictingTest},
		{blankStopSolutionSameNullConflictingOptions,blankStopSolutionSameNullConflictingTest}
	}=MapThread[
		elisaSameNullIndexedOptions[#1,#2]&,{substrateSameNullOptionNames,substrateSameNullOptionValues},1];


	(* Spike same null, *)
	{spikeSameNullConflictingOptions,spikeSameNullConflictingTest}=elisaSameNullIndexedOptions[{Spike,SpikeDilutionFactor,SpikeStorageCondition},{suppliedSpike,suppliedSpikeDilutionFactor,suppliedSpikeStorageCondition}];


	(*SampleDilutionCurve should not be specified when Spike is specified*)
	spikeDilutionCurveConformingBooleans=MapThread[If[MatchQ[{#1,#2},{Except[Null|Automatic],Except[Null|Automatic]}],False,True]&,{suppliedSampleDilutionCurve,suppliedSpike}];
	spikeDilutionCurveConflictingQ=And@@spikeDilutionCurveConformingBooleans;

	spikeDilutionCurveConflictingOption=If[spikeDilutionCurveConflictingQ===False&&messages,
		Message[Error::SpecifySpikeWithFixedDilutionCurve];{SampleDilutionCurve},
		{}
	];

	spikedSampleDilutionCurveConflictingTest =
		If[gatherTests,
			Test[
				"If Spike is specified, SampleDilutionCurve cannot be specified:",
				spikeDilutionCurveConflictingQ,
				True
			],
			{}
		];

	(* DilutionCurve options must coordinate with Diluent option--Other dilution and diluent pairs are controled by Method master switch so we don't have to checke them here.*)
	(* Standard DilutionCurve*)

	{standardDilutionCurveConflictingOptions,standardDilutionCurveConflictingTests}=
		elisaNotMoreThanOne[{{}},{{StandardDilutionCurve,StandardSerialDilutionCurve}}];

	{standardDiluentConflictingOptions,standardDiluentConflictingQ}=
		If[Or[MatchQ[{suppliedStandardDilutionCurve,suppliedStandardSerialDilutionCurve}, {{Null..},{Null..}}]
			&&!MatchQ[suppliedStandardDiluent,(Automatic|Null)],
			!MatchQ[{suppliedStandardDilutionCurve,suppliedStandardSerialDilutionCurve}, {{Null|Automatic..},{Null|Automatic..}}]
				&& MatchQ[suppliedStandardDiluent,(Null)]
		],
			{{StandardDilutionCurve,StandardSerialDilutionCurve, StandardDiluent},True},
			{{},False}
		];

	If[standardDiluentConflictingQ===True&&messages,
		Message[Error::SpecifyDiluentAndDilutionCurveTogether,
			"StandardDilutionCurve,StandardSerialDilutionCurve",
			"StandardDiluent"
		]
	];

	StandardDilutionCurveDiluentConflictingTest =
		If[gatherTests,
			Test[
				"If within StandardDilutionCurve and StnadardSerialDilutionCurve, one is specified and not Null, StandardDiluent
		must not be Null. If within StandardDilutionCurve and StnadardSerialDilutionCurve, both are specified as Null,
		StandardDiluent, if specified must also be Null:",
				True,
				!standardDiluentConflictingQ
			],
			{}
		];

	(* Sample/SpikedSample dilutioncurve*)

	{sampleDilutionCurveConflictingOptions,sampleDilutionCurveConflictingTests}=
		elisaNotMoreThanOne[{{}},{{SampleDilutionCurve,SampleSerialDilutionCurve}}];

	{SampleDiluentConflictingOptions,SampleDiluentConflictingQ}=
		If[
			Or[
				MatchQ[{suppliedSampleDilutionCurve,suppliedSampleSerialDilutionCurve}, {{Null..},{Null..}}]
					&&!MatchQ[suppliedSampleDiluent,(Automatic|Null)],
				!MatchQ[{suppliedSampleDilutionCurve,suppliedSampleSerialDilutionCurve}, {{Null|Automatic..},{Null|Automatic..}}]
					&& MatchQ[suppliedSampleDiluent,(Null)]
			],
			{{SampleDilutionCurve,SampleSerialDilutionCurve, SampleDiluent},True},
			{{},False}
		];

	If[SampleDiluentConflictingQ===True&&messages,
		Message[Error::SpecifyDiluentAndDilutionCurveTogether,
			"SampleDilutionCurve,SampleSerialDilutionCurve",
			"SampleDiluent"
		]
	];

	SampleDiluentConflictingTest =
		If[gatherTests,
			Test[
				"If within SampleDilutionCurve and SampleSerialDilutionCurve, one is specified and not Null, SampleDiluent
		must not be Null. If within SampleDilutionCurve and SampleSerialDilutionCurve, both are specified as Null,
		SampleDiluent, if specified must also be Null:",
				False,
				SampleDiluentConflictingQ
			],
			Nothing
		];

	(*Antibody/ReferenceAntigen volumes should not be larger than assay volumes*)
	(*elisaVolumeIncompatibility function takes in an input in the form of {{optionName1,optionName2},{optionValue1,optionValue2},indexMatchingParentsValues} and checks if optionValue1 is smaller than optionValue2*)
	elisaVolumeIncompatibility[input_]:=Module[{optionNames,optionValues,parentValues,volumeIncompatibleBooleans,volumeIncompatibileParents,volumeIncompatibleOptions,test},

		optionNames=input[[1]];
		optionValues=input[[2]];
		parentValues=input[[3]];

		volumeIncompatibleBooleans=MapThread[If[MatchQ[#1,Except[Null|Automatic]]&&MatchQ[#2,Except[Null|Automatic]],
			(*only check scienarios when both options are specified*)
			#1>=#2, (*True means INcompatible options*)
			False
		]&,optionValues,1];
		volumeIncompatibileParents=Pick[parentValues,volumeIncompatibleBooleans];


		If[messages&&Length[volumeIncompatibileParents]=!=0,
			Message[Error::AntibodyVolumeIncompatibility,
				optionNames[[1]]//ToString,
				optionNames[[2]]//ToString,
				volumeIncompatibileParents//ToString
			]
		];
		test=If[gatherTests,
			Test[ToString[optionNames[[1]]]<>" is not larger than "<>ToString[optionNames[[2]]]<>" :",
				True,
				Length[volumeIncompatibileParents]===0
			],
			{}
		];
		volumeIncompatibleOptions=If[Length[volumeIncompatibileParents]=!=0,optionNames,{}];
		{volumeIncompatibleOptions,test}
	];

	directELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,PrimaryAntibodyImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume},suppliedBlank}
	};
	indirectELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,PrimaryAntibodyImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume},suppliedBlank}
	};
	directSandwichELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,PrimaryAntibodyImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume},suppliedBlank},
		{{CaptureAntibodyVolume,CaptureAntibodyCoatingVolume},
			{suppliedCaptureAntibodyVolume,suppliedCaptureAntibodyCoatingVolume},mySamples},
		{{StandardCaptureAntibodyVolume,StandardCaptureAntibodyCoatingVolume},
			{suppliedStandardCaptureAntibodyVolume,suppliedStandardCaptureAntibodyCoatingVolume},suppliedStandard},
		{{BlankCaptureAntibodyVolume,BlankCaptureAntibodyCoatingVolume},
			{suppliedBlankCaptureAntibodyVolume,suppliedBlankCaptureAntibodyCoatingVolume},suppliedBlank}
	};
	indirectSandwichELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,PrimaryAntibodyImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedPrimaryAntibodyImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardPrimaryAntibodyImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankPrimaryAntibodyImmunosorbentVolume},suppliedBlank},
		{{CaptureAntibodyVolume,CaptureAntibodyCoatingVolume},
			{suppliedCaptureAntibodyVolume,suppliedCaptureAntibodyCoatingVolume},mySamples},
		{{StandardCaptureAntibodyVolume,StandardCaptureAntibodyCoatingVolume},
			{suppliedStandardCaptureAntibodyVolume,suppliedStandardCaptureAntibodyCoatingVolume},suppliedStandard},
		{{BlankCaptureAntibodyVolume,BlankCaptureAntibodyCoatingVolume},
			{suppliedBlankCaptureAntibodyVolume,suppliedBlankCaptureAntibodyCoatingVolume},suppliedBlank}
	};
	directCompetitiveELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,SampleAntibodyComplexImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedSampleAntibodyComplexImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardAntibodyComplexImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardAntibodyComplexImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankAntibodyComplexImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankAntibodyComplexImmunosorbentVolume},suppliedBlank},
		{{ReferenceAntigenVolume,ReferenceAntigenCoatingVolume},
			{suppliedReferenceAntigenVolume,suppliedReferenceAntigenCoatingVolume},mySamples},
		{{StandardReferenceAntigenVolume,StandardReferenceAntigenCoatingVolume},
			{suppliedStandardReferenceAntigenVolume,suppliedStandardReferenceAntigenCoatingVolume},suppliedStandard},
		{{BlankReferenceAntigenVolume,BlankReferenceAntigenCoatingVolume},
			{suppliedBlankReferenceAntigenVolume,suppliedBlankReferenceAntigenCoatingVolume},suppliedBlank}
	};
	indirectCompetitiveELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,SampleAntibodyComplexImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedSampleAntibodyComplexImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardAntibodyComplexImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardAntibodyComplexImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankAntibodyComplexImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankAntibodyComplexImmunosorbentVolume},suppliedBlank},
		{{ReferenceAntigenVolume,ReferenceAntigenCoatingVolume},
			{suppliedReferenceAntigenVolume,suppliedReferenceAntigenCoatingVolume},mySamples},
		{{StandardReferenceAntigenVolume,StandardReferenceAntigenCoatingVolume},
			{suppliedStandardReferenceAntigenVolume,suppliedStandardReferenceAntigenCoatingVolume},suppliedStandard},
		{{BlankReferenceAntigenVolume,BlankReferenceAntigenCoatingVolume},
			{suppliedBlankReferenceAntigenVolume,suppliedBlankReferenceAntigenCoatingVolume},suppliedBlank}
	};
	fastELISAVolumeCompatibilitySet={
		{{PrimaryAntibodyVolume,SampleAntibodyComplexImmunosorbentVolume},
			{suppliedPrimaryAntibodyVolume,suppliedSampleAntibodyComplexImmunosorbentVolume},mySamples},
		{{StandardPrimaryAntibodyVolume,StandardAntibodyComplexImmunosorbentVolume},
			{suppliedStandardPrimaryAntibodyVolume,suppliedStandardAntibodyComplexImmunosorbentVolume},suppliedStandard},
		{{BlankPrimaryAntibodyVolume,BlankAntibodyComplexImmunosorbentVolume},
			{suppliedBlankPrimaryAntibodyVolume,suppliedBlankAntibodyComplexImmunosorbentVolume},suppliedBlank},
		{{CaptureAntibodyVolume,SampleAntibodyComplexImmunosorbentVolume},
			{suppliedCaptureAntibodyVolume,suppliedSampleAntibodyComplexImmunosorbentVolume},mySamples},
		{{StandardCaptureAntibodyVolume,StandardAntibodyComplexImmunosorbentVolume},
			{suppliedStandardCaptureAntibodyVolume,suppliedStandardAntibodyComplexImmunosorbentVolume},suppliedStandard},
		{{BlankCaptureAntibodyVolume,BlankAntibodyComplexImmunosorbentVolume},
			{suppliedBlankCaptureAntibodyVolume,suppliedBlankAntibodyComplexImmunosorbentVolume},suppliedBlank},
		{{CoatingAntibodyVolume,CoatingAntibodyCoatingVolume},
			{suppliedCoatingAntibodyVolume,suppliedCoatingAntibodyCoatingVolume},mySamples},
		{{StandardCoatingAntibodyVolume,StandardCoatingAntibodyCoatingVolume},
			{suppliedStandardCoatingAntibodyVolume,suppliedStandardCoatingAntibodyCoatingVolume},suppliedStandard},
		{{BlankCoatingAntibodyVolume,BlankCoatingAntibodyCoatingVolume},
			{suppliedBlankCoatingAntibodyVolume,suppliedBlankCoatingAntibodyCoatingVolume},suppliedBlank}
	};

	volumeIncompatibilityreturns=Which[
		suppliedMethod===DirectELISA,
		Map[elisaVolumeIncompatibility[#]&,directELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===IndirectELISA,
		Map[elisaVolumeIncompatibility[#]&,indirectELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===DirectSandwichELISA,
		Map[elisaVolumeIncompatibility[#]&,directSandwichELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===IndirectSandwichELISA,
		Map[elisaVolumeIncompatibility[#]&,indirectSandwichELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===DirectCompetitiveELISA,
		Map[elisaVolumeIncompatibility[#]&,directCompetitiveELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===IndirectCompetitiveELISA,
		Map[elisaVolumeIncompatibility[#]&,indirectCompetitiveELISAVolumeCompatibilitySet,{1}],

		suppliedMethod===FastELISA,
		Map[elisaVolumeIncompatibility[#]&,fastELISAVolumeCompatibilitySet,{1}]
	];

	{volumeIncompatibleOptions,volumeIncompatibleTests}=
		{volumeIncompatibilityreturns[[All,1]],volumeIncompatibilityreturns[[All,2]]};


	(* ELISA Plate compatibility check*)
	(*Convert suppliedELISAPlate and suppliedSecondaryELISAPlate to Model with ID, not name. If they are Null or Automatic, Null will be returned.*)
	suppliedELISAPlateModel=If[MatchQ[suppliedELISAPlate,ObjectP[Model[Container]]],elisaGetPacketValue[suppliedELISAPlate,Object,1,simulatedCache],elisaGetPacketValue[suppliedELISAPlate,Model,1,simulatedCache]];
	suppliedSecondaryELISAPlateModel=If[MatchQ[suppliedSecondaryELISAPlate,ObjectP[Model[Container]]],elisaGetPacketValue[suppliedSecondaryELISAPlate,Object,1,simulatedCache],elisaGetPacketValue[suppliedSecondaryELISAPlate,Model,1,simulatedCache]];


	elisaIncompatibleContainerConflictingOptions=Map[
		Which[
			MatchQ[#,ObjectP[allLHCompatibleOptical96WellMicroplates]],Nothing,
			MatchQ[#,Null],Nothing,
			True,#
		]&,
		{suppliedELISAPlateModel,suppliedSecondaryELISAPlateModel}
	];

	If[messages&&Length[elisaIncompatibleContainerConflictingOptions]>0,
		Message[Error::ElisaIncompatibleContainer
		]
	];
	elisaIncompatibleContainerConflictingTest=If[gatherTests,
		Test["ELISAPlate And SecondaryELISAPlate must both be 96 well optical microplates that are compatible with the NIMBUS:",
			True,
			Length[elisaIncompatibleContainerConflictingOptions]==0
		],Nothing
	];

	(*Get plate materials and throw warning sign if it is Polypropylene or Cycloolefine.*)
	suppliedELISAPlateMaterials=elisaGetPacketValue[suppliedELISAPlate,ContainerMaterials,All,simulatedCache];
	suppliedSecondaryELISAPlateMaterials=elisaGetPacketValue[suppliedSecondaryELISAPlate,ContainerMaterials,All,simulatedCache];

	resolverAllRecommendedMicroplates=Search[Model[Container, Plate],
		NumberOfWells === 96 && Footprint === Plate &&
			Dimensions[[3]] >= 0.014 Meter && Dimensions[[3]] <= 0.016 Meter &&
			WellColor === Clear && KitProducts === {} &&
			ContainerMaterials === {Polystyrene} && WellBottom === FlatBottom&&Treatment=!=(LowBinding|TissueCultureTreated)&&DeveloperObject==(False|Null),
		SubTypes -> False];

	recommendedELISAPlates =Cases[resolverAllRecommendedMicroplates,
		Alternatives @@ Experiment`Private`compatibleSampleManipulationContainers[MicroLiquidHandling]
	];

	elisaImproperContainerOptions=MapThread[
		If[MemberQ[#1,(Polypropylene | Cycloolefine)],#2,Nothing]&,
		{{suppliedELISAPlateMaterials,suppliedSecondaryELISAPlateMaterials},{suppliedELISAPlate,suppliedSecondaryELISAPlate}}
	];
	(*Here if the container is incompatible then there's no need to throw a warning anymore.*)
	If[messages&&Length[elisaImproperContainerOptions]>0&&Length[elisaIncompatibleContainerConflictingOptions]===0,
		Message[Warning::ElisaImproperContainers,
			StringTake[ToString[elisaImproperContainerOptions],{2,-2}],
			StringTake[ToString[recommendedELISAPlates],{2,-2}]
		]
	];

	(*Throw warning if SignalCorrection is True and MeasurementWavelength has 620*)
	measure620Q=MemberQ[Flatten[{suppliedAbsorbanceWavelength,suppliedPrereadAbsorbanceWavelength}],620 Nanometer];
	signalCorrectionQ=TrueQ[suppliedSignalCorrection];

	If[messages&&measure620Q&&signalCorrectionQ,
		Message[Warning::Measure620WithCorrection]
	];


	(*======================================================*)
	(*========== RESOLVE EXPERIMENT OPTIONS ================*)
	(*======================================================*)

	(*---------Resolve non-IndexMatched options--------------*)
	defaultCoatingBuffer = 	Model[Sample, StockSolution, "1x Carbonate-Bicarbonate Buffer pH10"];
	defaultBlockingBuffer = Model[Sample, "ELISA Blocker Blocking Buffer"];

	(*Coating and Blocking*)
	{resolvedCoatingTemperature,resolvedCoatingTime,resolvedCoatingWashVolume,resolvedCoatingNumberOfWashes,
		resolvedBlockingBuffer,resolvedBlockingTemperature,resolvedBlockingTime,resolvedBlockingWashVolume,resolvedBlockingNumberOfWashes}=Which[
		!suppliedCoating&&!suppliedBlocking,
		elisaSetAuto[{suppliedCoatingTemperature,suppliedCoatingTime,suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes,
			suppliedBlockingBuffer,suppliedBlockingTemperature,suppliedBlockingTime,suppliedBlockingWashVolume,suppliedBlockingNumberOfWashes},
			{Null,Null,Null,Null,Null,Null,Null,250Microliter,3}
		],
		suppliedCoating&&suppliedBlocking,
		elisaSetAuto[{suppliedCoatingTemperature,suppliedCoatingTime,suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes,
			suppliedBlockingBuffer,suppliedBlockingTemperature,suppliedBlockingTime,suppliedBlockingWashVolume,suppliedBlockingNumberOfWashes},
			{4Celsius,16Hour,250Microliter,3,defaultBlockingBuffer,25Celsius,1Hour,250Microliter,3}
		],
		suppliedCoating&&!suppliedBlocking,
		elisaSetAuto[
			{suppliedCoatingTemperature,suppliedCoatingTime,suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes,
				suppliedBlockingBuffer,suppliedBlockingTemperature,suppliedBlockingTime,suppliedBlockingWashVolume,suppliedBlockingNumberOfWashes},
			{4Celsius,16Hour,250Microliter,3, Null,Null,Null,Null,Null}
		],
		!suppliedCoating&&suppliedBlocking,
		elisaSetAuto[
			{suppliedCoatingTemperature,suppliedCoatingTime,suppliedCoatingWashVolume,suppliedCoatingNumberOfWashes,
				suppliedBlockingBuffer,suppliedBlockingTemperature,suppliedBlockingTime,suppliedBlockingWashVolume,suppliedBlockingNumberOfWashes},
			{Null,Null,250Microliter,3,defaultBlockingBuffer,25Celsius,16Hour,250Microliter,3}
		]
	];

	(*Method-switched singles*)

	methodSwitchedSuppliedSingleSampleOptions =
		{
			suppliedSampleAntibodyComplexImmunosorbentTime,
			suppliedSampleAntibodyComplexImmunosorbentTemperature,
			suppliedSampleAntibodyComplexImmunosorbentWashVolume,
			suppliedSampleAntibodyComplexImmunosorbentNumberOfWashes,
			suppliedSampleImmunosorbentTime,
			suppliedSampleImmunosorbentTemperature,
			suppliedSampleImmunosorbentWashVolume,
			suppliedSampleImmunosorbentNumberOfWashes,
			suppliedPrimaryAntibodyImmunosorbentTime,
			suppliedPrimaryAntibodyImmunosorbentTemperature,
			suppliedPrimaryAntibodyImmunosorbentWashVolume,
			suppliedPrimaryAntibodyImmunosorbentNumberOfWashes,
			suppliedSecondaryAntibodyImmunosorbentTime,
			suppliedSecondaryAntibodyImmunosorbentTemperature,
			suppliedSecondaryAntibodyImmunosorbentWashVolume,
			suppliedSecondaryAntibodyImmunosorbentNumberOfWashes
		};

	resolvedPrimaryAntibodyImmunosorbentWashing = Which[
		MatchQ[Lookup[allOptionsRoundedAssociation, PrimaryAntibodyImmunosorbentWashing], Except[Automatic]],
			Lookup[allOptionsRoundedAssociation, PrimaryAntibodyImmunosorbentWashing],
		MatchQ[suppliedMethod, DirectELISA|IndirectELISA|DirectSandwichELISA|IndirectSandwichELISA],
			True,
		True,
			Null
	];
	resolvedSecondaryAntibodyImmunosorbentWashing = Which[
		MatchQ[Lookup[allOptionsRoundedAssociation, SecondaryAntibodyImmunosorbentWashing], Except[Automatic]],
			Lookup[allOptionsRoundedAssociation, SecondaryAntibodyImmunosorbentWashing],
		MatchQ[suppliedMethod, IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA],
			True,
		True,
			Null
	];
	directELISASwitchedAutoSingleSampleOptions = If[MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null},
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,Null,Null,Null,Null,Null,Null}
	];
	indirectELISASwitchedAutoSingleSampleOptions = Which[
		MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,1 Hour,25Celsius,250 Microliter,4},
		MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && !MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,1 Hour,25Celsius,Null,Null},
		!MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,Null,Null,1 Hour,25Celsius,250 Microliter,4},
		True,
		{Null,Null,Null,Null,Null,Null,Null,Null,2 Hour,25Celsius,Null,Null,1 Hour,25Celsius,Null,Null}
	];
	directSandwichELISASwitchedAutoSingleSampleOptions = If[MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null},
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,Null,Null,Null,Null,Null,Null}
	];
	indirectSandwichELISASwitchedAutoSingleSampleOptions = Which[
		MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,250 Microliter,4,1 Hour,25Celsius,250 Microliter,4},
		MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && !MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,250 Microliter,4,1 Hour,25Celsius,Null,Null},
		!MatchQ[resolvedPrimaryAntibodyImmunosorbentWashing, True] && MatchQ[resolvedSecondaryAntibodyImmunosorbentWashing, True],
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,Null,Null,1 Hour,25Celsius,250 Microliter,4},
		True,
		{Null,Null,Null,Null,2 Hour,25Celsius,250 Microliter,4,2 Hour,25Celsius,Null,Null,1 Hour,25Celsius,Null,Null}
	];
	directCompetitiveELISASwitchedAutoSingleSampleOptions = {2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null};
	indirectCompetitiveELISASwitchedAutoSingleSampleOptions = If[TrueQ[resolvedSecondaryAntibodyImmunosorbentWashing],
		{2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null,Null,Null,Null,Null,1 Hour,25Celsius,250 Microliter,4},
		{2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null,Null,Null,Null,Null,1 Hour,25Celsius,Null,Null}
	];
	FastELISASwitchedAutoSingleSampleOptions = {2 Hour,25Celsius,250 Microliter,4,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,Null};

	{
		resolvedSampleAntibodyComplexImmunosorbentTime,
		resolvedSampleAntibodyComplexImmunosorbentTemperature,
		resolvedSampleAntibodyComplexImmunosorbentWashVolume,
		resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,
		resolvedSampleImmunosorbentTime,
		resolvedSampleImmunosorbentTemperature,
		resolvedSampleImmunosorbentWashVolume,
		resolvedSampleImmunosorbentNumberOfWashes,
		resolvedPrimaryAntibodyImmunosorbentTime,
		resolvedPrimaryAntibodyImmunosorbentTemperature,
		resolvedPrimaryAntibodyImmunosorbentWashVolume,
		resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,
		resolvedSecondaryAntibodyImmunosorbentTime,
		resolvedSecondaryAntibodyImmunosorbentTemperature,
		resolvedSecondaryAntibodyImmunosorbentWashVolume,
		resolvedSecondaryAntibodyImmunosorbentNumberOfWashes
	}=Which[
		suppliedMethod===DirectELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,directELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===IndirectELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,indirectELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===DirectSandwichELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,directSandwichELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===IndirectSandwichELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,indirectSandwichELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===DirectCompetitiveELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,directCompetitiveELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===IndirectCompetitiveELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,indirectCompetitiveELISASwitchedAutoSingleSampleOptions],
		suppliedMethod===FastELISA,
		elisaSetAuto[methodSwitchedSuppliedSingleSampleOptions,FastELISASwitchedAutoSingleSampleOptions]
	];


	resolvedCoatingAntibodyDiluent=Which[
		MatchQ[suppliedCoatingAntibodyDiluent,Except[Null|Automatic]],
		suppliedCoatingAntibodyDiluent,
		
		MatchQ[{suppliedMethod,suppliedCoating,suppliedCoatingAntibodyDilutionFactor},{FastELISA,True,Except[{EqualP[1]..}|EqualP[1]]}],
		defaultCoatingBuffer,
		
		True,
		Null
	];

	resolvedCaptureAntibodyDiluent=Which[
		MatchQ[suppliedCaptureAntibodyDiluent,Except[Null|Automatic]],
		suppliedCaptureAntibodyDiluent,

		MatchQ[{suppliedMethod,suppliedCoating,suppliedCaptureAntibodyDilutionFactor},{(DirectSandwichELISA|IndirectSandwichELISA),True,Except[{EqualP[1]..}|EqualP[1]]}],
		defaultCoatingBuffer,

		True,
		Null
	];

	resolvedReferenceAntigenDiluent=Which[
		MatchQ[suppliedReferenceAntigenDiluent,Except[Null|Automatic]],
		suppliedReferenceAntigenDiluent,

		MatchQ[{suppliedMethod,suppliedCoating,suppliedReferenceAntigenDilutionFacotr},{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True,Except[{EqualP[1]..}|EqualP[1]]}],
		defaultCoatingBuffer,

		True,
		Null
	];
	resolvedPrimaryAntibodyDiluent=Which[
		MatchQ[suppliedPrimaryAntibodyDiluent,Except[Null|Automatic]],
		suppliedPrimaryAntibodyDiluent,

		MatchQ[{suppliedMethod,suppliedPrimaryAntibodyDilutionFactor},{DirectELISA|IndirectELISA|DirectSandwichELISA|IndirectSandwichELISA,Except[{EqualP[1]..}|EqualP[1]]}],
		defaultBlockingBuffer,

		True,
		Null
	];
	resolvedSecondaryAntibodyDiluent=Which[
		MatchQ[suppliedSecondaryAntibodyDiluent,Except[Null|Automatic]],
		suppliedSecondaryAntibodyDiluent,

		MatchQ[{suppliedMethod,suppliedSecondaryAntibodyDilutionFactor},{IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA,Except[{EqualP[1]..}|EqualP[1]]}],
		defaultBlockingBuffer,

		True,
		Null
	];

	(*SampleDiluent depends on method and if there is sample dilution curve specified*)
	resolvedSampleDiluent=If[
		suppliedSampleDiluent=!=Automatic,
		suppliedSampleDiluent,

		If[MatchQ[suppliedSampleSerialDilutionCurve,Except[Null|Automatic|{Null..}|{Automatic..}]]||MatchQ[suppliedSampleDilutionCurve,Except[Null|Automatic|{Null..}|{Automatic..}]],
			Which[
				MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)],
				defaultCoatingBuffer,

				True,
				defaultBlockingBuffer
			],
			Null
		]
	];

	(*SampleAntibodyIncubation-switched: For Sample-antibody incubation, we set automatic to Ambient, as we are calling ExperimentIncubate for this.*)
	{resolvedSampleAntibodyComplexIncubationTime,resolvedSampleAntibodyComplexIncubationTemperature}=
		If[
			resolvedSampleAntibodyComplexIncubation,
			elisaSetAuto[{suppliedSampleAntibodyComplexIncubationTime,suppliedSampleAntibodyComplexIncubationTemperature},
				{2 Hour, Ambient}
			],
			elisaSetAuto[{suppliedSampleAntibodyComplexIncubationTime,suppliedSampleAntibodyComplexIncubationTemperature},
				{Null, Null}
			]
		];


	(*========Convert options into a MapThread friendly version============*)
	suppliedSampleChildrenValues = {
		suppliedTargetAntigen,
		suppliedCoatingAntibody,
		suppliedCoatingAntibodyDilutionFactor,
		suppliedCoatingAntibodyVolume,
		suppliedCoatingAntibodyStorageCondition,
		suppliedCaptureAntibody,
		suppliedCaptureAntibodyDilutionFactor,
		suppliedCaptureAntibodyVolume,
		suppliedCaptureAntibodyStorageCondition,
		suppliedReferenceAntigen,
		suppliedReferenceAntigenDilutionFactor,
		suppliedReferenceAntigenVolume,
		suppliedReferenceAntigenStorageCondition,
		suppliedPrimaryAntibody,
		suppliedPrimaryAntibodyDilutionFactor,
		suppliedPrimaryAntibodyVolume,
		suppliedSecondaryAntibody,
		suppliedSecondaryAntibodyDilutionFactor,
		suppliedSecondaryAntibodyVolume,
		suppliedSecondaryAntibodyStorageCondition,
		suppliedSampleCoatingVolume,
		suppliedCoatingAntibodyCoatingVolume,
		suppliedReferenceAntigenCoatingVolume,
		suppliedCaptureAntibodyCoatingVolume,
		suppliedBlockingVolume,
		suppliedSampleAntibodyComplexImmunosorbentVolume,
		suppliedSampleImmunosorbentVolume,
		suppliedPrimaryAntibodyImmunosorbentVolume,
		suppliedSecondaryAntibodyImmunosorbentVolume,
		suppliedSubstrateSolution,
		suppliedStopSolution,
		suppliedSubstrateSolutionVolume,
		suppliedStopSolutionVolume,
		suppliedSampleDilutionCurve,
		suppliedSampleSerialDilutionCurve,
		suppliedSpike,
		suppliedSpikeDilutionFactor,
		suppliedSpikeStorageCondition
	};

	suppliedStandardChildrenValues = {
		suppliedStandardStorageCondition,
		suppliedStandardTargetAntigen,
		suppliedStandardDilutionCurve,
		suppliedStandardSerialDilutionCurve,
		suppliedStandardCoatingAntibody,
		suppliedStandardCoatingAntibodyDilutionFactor,
		suppliedStandardCoatingAntibodyVolume,
		suppliedStandardCaptureAntibody,
		suppliedStandardCaptureAntibodyDilutionFactor,
		suppliedStandardCaptureAntibodyVolume,
		suppliedStandardReferenceAntigen,
		suppliedStandardReferenceAntigenDilutionFactor,
		suppliedStandardReferenceAntigenVolume,
		suppliedStandardPrimaryAntibody,
		suppliedStandardPrimaryAntibodyDilutionFactor,
		suppliedStandardPrimaryAntibodyVolume,
		suppliedStandardSecondaryAntibody,
		suppliedStandardSecondaryAntibodyDilutionFactor,
		suppliedStandardSecondaryAntibodyVolume,
		suppliedStandardCoatingVolume,
		suppliedStandardReferenceAntigenCoatingVolume,
		suppliedStandardCoatingAntibodyCoatingVolume,
		suppliedStandardCaptureAntibodyCoatingVolume,
		suppliedStandardBlockingVolume,
		suppliedStandardAntibodyComplexImmunosorbentVolume,
		suppliedStandardImmunosorbentVolume,
		suppliedStandardPrimaryAntibodyImmunosorbentVolume,
		suppliedStandardSecondaryAntibodyImmunosorbentVolume,
		suppliedStandardSubstrateSolution,
		suppliedStandardStopSolution,
		suppliedStandardSubstrateSolutionVolume,
		suppliedStandardStopSolutionVolume
	};
	suppliedBlankChildrenValues = {
		suppliedBlankStorageCondition,
		suppliedBlankTargetAntigen,
		suppliedBlankCoatingAntibody,
		suppliedBlankCoatingAntibodyDilutionFactor,
		suppliedBlankCoatingAntibodyVolume,
		suppliedBlankCaptureAntibody,
		suppliedBlankCaptureAntibodyDilutionFactor,
		suppliedBlankCaptureAntibodyVolume,
		suppliedBlankReferenceAntigen,
		suppliedBlankReferenceAntigenDilutionFactor,
		suppliedBlankReferenceAntigenVolume,
		suppliedBlankPrimaryAntibody,
		suppliedBlankPrimaryAntibodyDilutionFactor,
		suppliedBlankPrimaryAntibodyVolume,
		suppliedBlankSecondaryAntibody,
		suppliedBlankSecondaryAntibodyDilutionFactor,
		suppliedBlankSecondaryAntibodyVolume,
		suppliedBlankCoatingVolume,
		suppliedBlankReferenceAntigenCoatingVolume,
		suppliedBlankCoatingAntibodyCoatingVolume,
		suppliedBlankCaptureAntibodyCoatingVolume,
		suppliedBlankBlockingVolume,
		suppliedBlankAntibodyComplexImmunosorbentVolume,
		suppliedBlankImmunosorbentVolume,
		suppliedBlankPrimaryAntibodyImmunosorbentVolume,
		suppliedBlankSecondaryAntibodyImmunosorbentVolume,
		suppliedBlankSubstrateSolution,
		suppliedBlankStopSolution,
		suppliedBlankSubstrateSolutionVolume,
		suppliedBlankStopSolutionVolume
	};

	sampleChildrenNames = {
		TargetAntigen,
		CoatingAntibody,
		CoatingAntibodyDilutionFactor,
		CoatingAntibodyVolume,
		CoatingAntibodyStorageCondition,
		CaptureAntibody,
		CaptureAntibodyDilutionFactor,
		CaptureAntibodyVolume,
		CaptureAntibodyStorageCondition,
		ReferenceAntigen,
		ReferenceAntigenDilutionFactor,
		ReferenceAntigenVolume,
		ReferenceAntigenStorageCondition,
		PrimaryAntibody,
		PrimaryAntibodyDilutionFactor,
		PrimaryAntibodyVolume,
		SecondaryAntibody,
		SecondaryAntibodyDilutionFactor,
		SecondaryAntibodyVolume,
		SecondaryAntibodyStorageCondition,
		SampleCoatingVolume,
		CoatingAntibodyCoatingVolume,
		ReferenceAntigenCoatingVolume,
		CaptureAntibodyCoatingVolume,
		BlockingVolume,
		SampleAntibodyComplexImmunosorbentVolume,
		SampleImmunosorbentVolume,
		PrimaryAntibodyImmunosorbentVolume,
		SecondaryAntibodyImmunosorbentVolume,
		SubstrateSolution,
		StopSolution,
		SubstrateSolutionVolume,
		StopSolutionVolume,
		SampleDilutionCurve,
		SampleSerialDilutionCurve,
		Spike,
		SpikeDilutionFactor,
		SpikeStorageCondition
	};

	standardChildrenNames = {
		StandardStorageCondition,
		StandardTargetAntigen,
		StandardDilutionCurve,
		StandardSerialDilutionCurve,
		StandardCoatingAntibody,
		StandardCoatingAntibodyDilutionFactor,
		StandardCoatingAntibodyVolume,
		StandardCaptureAntibody,
		StandardCaptureAntibodyDilutionFactor,
		StandardCaptureAntibodyVolume,
		StandardReferenceAntigen,
		StandardReferenceAntigenDilutionFactor,
		StandardReferenceAntigenVolume,
		StandardPrimaryAntibody,
		StandardPrimaryAntibodyDilutionFactor,
		StandardPrimaryAntibodyVolume,
		StandardSecondaryAntibody,
		StandardSecondaryAntibodyDilutionFactor,
		StandardSecondaryAntibodyVolume,
		StandardCoatingVolume,
		StandardReferenceAntigenCoatingVolume,
		StandardCoatingAntibodyCoatingVolume,
		StandardCaptureAntibodyCoatingVolume,
		StandardBlockingVolume,
		StandardAntibodyComplexImmunosorbentVolume,
		StandardImmunosorbentVolume,
		StandardPrimaryAntibodyImmunosorbentVolume,
		StandardSecondaryAntibodyImmunosorbentVolume,
		StandardSubstrateSolution,
		StandardStopSolution,
		StandardSubstrateSolutionVolume,
		StandardStopSolutionVolume
	};
	blankChildrenNames = {
		BlankStorageCondition,
		BlankTargetAntigen,
		BlankCoatingAntibody,
		BlankCoatingAntibodyDilutionFactor,
		BlankCoatingAntibodyVolume,
		BlankCaptureAntibody,
		BlankCaptureAntibodyDilutionFactor,
		BlankCaptureAntibodyVolume,
		BlankReferenceAntigen,
		BlankReferenceAntigenDilutionFactor,
		BlankReferenceAntigenVolume,
		BlankPrimaryAntibody,
		BlankPrimaryAntibodyDilutionFactor,
		BlankPrimaryAntibodyVolume,
		BlankSecondaryAntibody,
		BlankSecondaryAntibodyDilutionFactor,
		BlankSecondaryAntibodyVolume,
		BlankCoatingVolume,
		BlankReferenceAntigenCoatingVolume,
		BlankCoatingAntibodyCoatingVolume,
		BlankCaptureAntibodyCoatingVolume,
		BlankBlockingVolume,
		BlankAntibodyComplexImmunosorbentVolume,
		BlankImmunosorbentVolume,
		BlankPrimaryAntibodyImmunosorbentVolume,
		BlankSecondaryAntibodyImmunosorbentVolume,
		BlankSubstrateSolution,
		BlankStopSolution,
		BlankSubstrateSolutionVolume,
		BlankStopSolutionVolume
	};


	(*========Resolve Sample IndexMatched Options============*)

	sampleMapThreadFriends = elisaMakeMapThreadFriends[mySamples,suppliedSampleChildrenValues,sampleChildrenNames];

	elisaResolveIndexMatchedSampleOptions[singlePacket_]:=Module[{singleSample,suppliedSingleSampleTargetAntigen,suppliedSingleSampleCoatingAntibody,suppliedSingleSampleCoatingAntibodyDilutionFactor,suppliedSingleSampleCoatingAntibodyVolume,suppliedSingleSampleCoatingAntibodyStorageCondition,suppliedSingleSampleCaptureAntibody,suppliedSingleSampleCaptureAntibodyDilutionFactor,suppliedSingleSampleCaptureAntibodyVolume,suppliedSingleSampleCaptureAntibodyStorageCondition,suppliedSingleSampleReferenceAntigen,suppliedSingleSampleReferenceAntigenDilutionFactor,suppliedSingleSampleReferenceAntigenVolume,suppliedSingleSampleReferenceAntigenStorageCondition,suppliedSingleSamplePrimaryAntibody,suppliedSingleSampleSecondaryAntibody,suppliedSingleSampleSecondaryAntibodyDilutionFactor,suppliedSingleSampleSecondaryAntibodyVolume,suppliedSingleSampleSecondaryAntibodyStorageCondition,suppliedSingleSampleSampleCoatingVolume,suppliedSingleSampleCoatingAntibodyCoatingVolume,suppliedSingleSampleReferenceAntigenCoatingVolume,suppliedSingleSampleCaptureAntibodyCoatingVolume,suppliedSingleSampleBlockingVolume,suppliedSingleSampleSampleAntibodyComplexImmunosorbentVolume,suppliedSingleSampleSampleImmunosorbentVolume,suppliedSingleSamplePrimaryAntibodyImmunosorbentVolume,suppliedSingleSampleSecondaryAntibodyImmunosorbentVolume,suppliedSingleSampleSubstrateSolution,suppliedSingleSampleStopSolution,suppliedSingleSampleSubstrateSolutionVolume,suppliedSingleSampleStopSolutionVolume,suppliedSingleSampleSampleDilutionCurve,suppliedSingleSampleSampleSerialDilutionCurve,resolvedSingleSampleTargetAntigen,resolvedSingleSampleCoatingAntibody,resolvedSingleSampleCoatingAntibodyDilutionFactor,resolvedSingleSampleCoatingAntibodyStorageCondition,resolvedSingleSampleCaptureAntibody,resolvedSingleSampleCaptureAntibodyDilutionFactor,resolvedSingleSampleCaptureAntibodyStorageCondition,resolvedSingleSampleReferenceAntigen,resolvedSingleSampleReferenceAntigenDilutionFactor,resolvedSingleSampleReferenceAntigenStorageCondition,resolvedSingleSamplePrimaryAntibody,resolvedSingleSampleSecondaryAntibody,resolvedSingleSampleSecondaryAntibodyDilutionFactor,resolvedSingleSampleSecondaryAntibodyStorageCondition,resolvedSingleSampleSampleCoatingVolume,resolvedSingleSampleCoatingAntibodyCoatingVolume,resolvedSingleSampleReferenceAntigenCoatingVolume,resolvedSingleSampleCaptureAntibodyCoatingVolume,resolvedSingleSampleBlockingVolume,resolvedSingleSampleSampleAntibodyComplexImmunosorbentVolume,resolvedSingleSampleSampleImmunosorbentVolume,resolvedSingleSamplePrimaryAntibodyImmunosorbentVolume,resolvedSingleSampleSecondaryAntibodyImmunosorbentVolume,resolvedSingleSampleSubstrateSolution,resolvedSingleSampleStopSolution,resolvedSingleSampleSubstrateSolutionVolume,resolvedSingleSampleStopSolutionVolume,resolvedSingleSampleSampleDilutionCurve,resolvedSingleSampleSampleSerialDilutionCurve,unresolvableSingleSamplePrimaryAntibody,unresolvableSingleSampleSecondaryAntibody,unresolvableSingleSampleCaptureAntibody,unresolvableSingleSampleCoatingAntibody,unresolvableSingleSampleReferenceAntigen,unresolvableSingleSampleSubstrateSolution,unresolvableSingleSampleStopSolution,unresolvableSingleSampleSubstrateSolutionVolume,unresolvableSingleSampleStopSolutionVolume,autoPrimaryAntibodyCandidates,primaryAntibodyCandidateConjugations,primaryAntibodyCandidateConjugationHRPAPQ,autoPrimaryAntibodyCandidatesNoConjugation,autoPrimaryAntibodyCandidatesNoConjugationSpecies,primaryAntibodySpecies,captureAntibodyCandidates,captureAntibodyCandidateConjugations,captureAntibodyCandidateConjugationHRPAPQ,captureAntibodyNoConjugation,primaryAntibdySpecies,captureAntibodyNoConjSpeciesList,nonPrimaryAntibodySpecies,captureAntibodyCandidateAffinityTags,coatingAntibodyCandidates,coatingAntibodyCandidateConjugations,assayEnzyme,resolvedSingleSamplePrimaryAntibodyMolecule,resolvedSingleSampleCaptureAntibodyMolecule,resolvedSingleSampleCoatingAntibodyMolecule,allDetectionLabels,autoFlatDilutionFactorOptions,autoFlatOptions,resolvedSingleSampleSecondaryAntibodyMolecule,captureAntibodyAffinityLabel,resolvedSinlgeSpikeDilutionFactor,resolvedSingleSpikeStorageCondition,suppliedSingleSpike,suppliedSingleSpikeDilutionFactor,suppliedSingleSpikeStorageCondition,autoSingleSampleSubstrateList,primaryAntibodyMolecule,suppliedSingleSamplePrimaryAntibodyDilutionFactor,suppliedSingleSamplePrimaryAntibodyVolume,resolvedSingleSamplePrimaryAntibodyDilutionFactor
	},
		(*Setup*)
		{
			unresolvableSingleSamplePrimaryAntibody,
			unresolvableSingleSampleSecondaryAntibody,
			unresolvableSingleSampleCaptureAntibody,
			unresolvableSingleSampleCoatingAntibody,
			unresolvableSingleSampleReferenceAntigen,
			unresolvableSingleSampleSubstrateSolution,
			unresolvableSingleSampleStopSolution,
			unresolvableSingleSampleSubstrateSolutionVolume,
			unresolvableSingleSampleStopSolutionVolume}=ConstantArray[False,9];

		{
			singleSample,
			suppliedSingleSampleTargetAntigen,
			suppliedSingleSampleCoatingAntibody,
			suppliedSingleSampleCoatingAntibodyDilutionFactor,
			suppliedSingleSampleCoatingAntibodyVolume,
			suppliedSingleSampleCoatingAntibodyStorageCondition,
			suppliedSingleSampleCaptureAntibody,
			suppliedSingleSampleCaptureAntibodyDilutionFactor,
			suppliedSingleSampleCaptureAntibodyVolume,
			suppliedSingleSampleCaptureAntibodyStorageCondition,
			suppliedSingleSampleReferenceAntigen,
			suppliedSingleSampleReferenceAntigenDilutionFactor,
			suppliedSingleSampleReferenceAntigenVolume,
			suppliedSingleSampleReferenceAntigenStorageCondition,
			suppliedSingleSamplePrimaryAntibody,
			suppliedSingleSamplePrimaryAntibodyDilutionFactor,
			suppliedSingleSamplePrimaryAntibodyVolume,
			suppliedSingleSampleSecondaryAntibody,
			suppliedSingleSampleSecondaryAntibodyDilutionFactor,
			suppliedSingleSampleSecondaryAntibodyVolume,
			suppliedSingleSampleSecondaryAntibodyStorageCondition,
			suppliedSingleSampleSampleCoatingVolume,
			suppliedSingleSampleCoatingAntibodyCoatingVolume,
			suppliedSingleSampleReferenceAntigenCoatingVolume,
			suppliedSingleSampleCaptureAntibodyCoatingVolume,
			suppliedSingleSampleBlockingVolume,
			suppliedSingleSampleSampleAntibodyComplexImmunosorbentVolume,
			suppliedSingleSampleSampleImmunosorbentVolume,
			suppliedSingleSamplePrimaryAntibodyImmunosorbentVolume,
			suppliedSingleSampleSecondaryAntibodyImmunosorbentVolume,
			suppliedSingleSampleSubstrateSolution,
			suppliedSingleSampleStopSolution,
			suppliedSingleSampleSubstrateSolutionVolume,
			suppliedSingleSampleStopSolutionVolume,
			suppliedSingleSampleSampleDilutionCurve,
			suppliedSingleSampleSampleSerialDilutionCurve,
			suppliedSingleSpike,
			suppliedSingleSpikeDilutionFactor,
			suppliedSingleSpikeStorageCondition
		}= Lookup[singlePacket,{
			"parent",
			TargetAntigen,
			CoatingAntibody,
			CoatingAntibodyDilutionFactor,
			CoatingAntibodyVolume,
			CoatingAntibodyStorageCondition,
			CaptureAntibody,
			CaptureAntibodyDilutionFactor,
			CaptureAntibodyVolume,
			CaptureAntibodyStorageCondition,
			ReferenceAntigen,
			ReferenceAntigenDilutionFactor,
			ReferenceAntigenVolume,
			ReferenceAntigenStorageCondition,
			PrimaryAntibody,
			PrimaryAntibodyDilutionFactor,
			PrimaryAntibodyVolume,
			SecondaryAntibody,
			SecondaryAntibodyDilutionFactor,
			SecondaryAntibodyVolume,
			SecondaryAntibodyStorageCondition,
			SampleCoatingVolume,
			CoatingAntibodyCoatingVolume,
			ReferenceAntigenCoatingVolume,
			CaptureAntibodyCoatingVolume,
			BlockingVolume,
			SampleAntibodyComplexImmunosorbentVolume,
			SampleImmunosorbentVolume,
			PrimaryAntibodyImmunosorbentVolume,
			SecondaryAntibodyImmunosorbentVolume,
			SubstrateSolution,
			StopSolution,
			SubstrateSolutionVolume,
			StopSolutionVolume,
			SampleDilutionCurve,
			SampleSerialDilutionCurve,
			Spike,
			SpikeDilutionFactor,
			SpikeStorageCondition
		}];



		resolvedSingleSampleBlockingVolume = If[suppliedBlocking,
			elisaSetAuto[{suppliedSingleSampleBlockingVolume},{100 Microliter}],
			elisaSetAuto[{suppliedSingleSampleBlockingVolume},{Null}]
		][[1]];

		(*Resolve TargetAntigen*)

		resolvedSingleSampleTargetAntigen = If[suppliedSingleSampleTargetAntigen=!=Automatic,
			suppliedSingleSampleTargetAntigen,

			FirstCase[{
				elisaGetPacketValue[singleSample,Analytes,1,simulatedCache],
				elisaGetPacketValue[elisaGetPacketValue[singleSample,Model,1,simulatedCache],Analytes,1,simulatedCache],
				elisaGetPacketValue[elisaGetPacketValue[suppliedSingleSamplePrimaryAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
				elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleSamplePrimaryAntibody,Model,1,simulatedCache],Analytes,1,simulatedCache],Targets,1,simulatedCache],
				elisaGetPacketValue[elisaGetPacketValue[suppliedSingleSampleCaptureAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
				elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleSampleCaptureAntibody,Model,1,simulatedCache],Analytes,1,simulatedCache],Targets,1,simulatedCache]
			},ObjectP[Model[Molecule]],Null]
		];



		(*resolve primary antibody*)

		If[!MatchQ[suppliedSingleSamplePrimaryAntibody,Automatic],
			resolvedSingleSamplePrimaryAntibodyMolecule=elisaGetPacketValue[suppliedSingleSamplePrimaryAntibody,Analytes,1,simulatedCache];
			resolvedSingleSamplePrimaryAntibody=suppliedSingleSamplePrimaryAntibody;
			(*We'll need this to resolve capture antibody*)
			primaryAntibodyCandidateConjugations = ToList[elisaGetPacketValue[resolvedSingleSamplePrimaryAntibodyMolecule,DetectionLabels,All,simulatedCache]],

			(*ELSE*)
			If[MatchQ[resolvedSingleSampleTargetAntigen,Null],
				resolvedSingleSamplePrimaryAntibodyMolecule=Null;
				resolvedSingleSamplePrimaryAntibody=Null,

				(*ELSE-2*) (*TODO:change logic*)
				(*If there is a Target antigen, resolve primary antibody based on the target antigen*)
				(*All primary Antibodies against the target antigen*)
				autoPrimaryAntibodyCandidates = elisaGetPacketValue[resolvedSingleSampleTargetAntigen,Antibodies,All,simulatedCache];
				(*For each antibody candidate, find out its conjugations in a list.*)
				primaryAntibodyCandidateConjugations = ToList[elisaGetPacketValue[#,DetectionLabels,All,simulatedCache]]&/@autoPrimaryAntibodyCandidates;
				(*For each antibody candidate, does the conjugation include HRP or AP?*)
				primaryAntibodyCandidateConjugationHRPAPQ = Map[
					MemberQ[#,ObjectP[Model[Molecule, Protein, "Horseradish Peroxidase"]] |
						ObjectP[Model[Molecule, Protein, "Alkaline Phosphatase"]]]&,
					primaryAntibodyCandidateConjugations,{1}];
				(*If no primary antibody candidate is available, then unresolvable,
				  If DirectELISAs, and at least one antibody is HRP/AP conjugated, then pick the first HRP or AP conjugated antibody.SecondaryAntibody is resolved to Null)
				  If IndirectELISAs, and at least one antibody is non-conjugated, then pick the first non-conjugated antibody that
				  is from the stocked species.*)
				resolvedSingleSamplePrimaryAntibodyMolecule=Which[
					(*Which-1*)
					autoPrimaryAntibodyCandidates==={},
					Null,

					(*Which-2*)
					MemberQ[{DirectELISA,DirectSandwichELISA,DirectCompetitiveELISA,FastELISA},suppliedMethod]
						&&MemberQ[primaryAntibodyCandidateConjugationHRPAPQ,True],
					Pick[autoPrimaryAntibodyCandidates,primaryAntibodyCandidateConjugationHRPAPQ]//FirstOrDefault,

					(*Which-3*)
					MemberQ[{IndirectELISA,IndirectSandwichELISA,IndirectCompetitiveELISA},suppliedMethod]
						&&MemberQ[primaryAntibodyCandidateConjugations,{Null}],
					autoPrimaryAntibodyCandidatesNoConjugation=
						PickList[autoPrimaryAntibodyCandidates,primaryAntibodyCandidateConjugations,{Null}];
					If[!MatchQ[autoPrimaryAntibodyCandidatesNoConjugation,{}],
						autoPrimaryAntibodyCandidatesNoConjugationSpecies = elisaGetPacketValue[#,Organism,1,simulatedCache]&/@autoPrimaryAntibodyCandidatesNoConjugation;
						If[MemberQ[{Mouse,Rabbit,Rat,Chicken,Goat,Human},Alternatives@@autoPrimaryAntibodyCandidatesNoConjugationSpecies],
							(*If species is stocked, set to the first primary antibody with stocked species, secondary set to the corresponding HRP conjugated secondary*)
							Pick[autoPrimaryAntibodyCandidatesNoConjugation,autoPrimaryAntibodyCandidatesNoConjugationSpecies,
								Alternatives[Mouse,Rabbit,Rat,Chicken,Goat,Human]]//FirstOrDefault,
							autoPrimaryAntibodyCandidatesNoConjugation//FirstOrDefault,
							Null
						],
						Null
					]
				];
				resolvedSingleSamplePrimaryAntibody=elisaGetPacketValue[resolvedSingleSamplePrimaryAntibodyMolecule,DefaultSampleModel,1,simulatedCache]
			]
		];

		If[MatchQ[resolvedSingleSamplePrimaryAntibody,Null],unresolvableSingleSamplePrimaryAntibody=True];
		
		
		(*Resolve Secondary Antibody*)
		{resolvedSingleSampleSecondaryAntibody,resolvedSingleSampleSecondaryAntibodyMolecule}=
			If[suppliedSingleSampleSecondaryAntibody=!=Automatic,
				{suppliedSingleSampleSecondaryAntibody,elisaGetPacketValue[suppliedSingleSampleSecondaryAntibody,Analytes,1,simulatedCache]},

				Which[
					MemberQ[{DirectELISA,DirectSandwichELISA,DirectCompetitiveELISA,FastELISA},suppliedMethod],
					{Null,Null},

					MemberQ[{IndirectELISA,IndirectSandwichELISA,IndirectCompetitiveELISA},suppliedMethod]&&resolvedSingleSamplePrimaryAntibody=!=Null,
					primaryAntibodyMolecule= elisaGetPacketValue[resolvedSingleSamplePrimaryAntibody,Analytes,1,simulatedCache];
					primaryAntibodySpecies = elisaGetPacketValue[primaryAntibodyMolecule,Organism,1,simulatedCache];
					If[
						MemberQ[{Mouse,Rabbit,Rat,Chicken,Goat,Human},primaryAntibodySpecies],
						Which[
							primaryAntibodySpecies==Mouse,
							{Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]},
							primaryAntibodySpecies==Rabbit,
							{Model[Sample,"HRP-Conjugated Goat-Anti-Rabbit-IgG Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Rabbit-IgG Secondary Antibody"]},
							primaryAntibodySpecies==Rat,
							{Model[Sample,"HRP-Conjugated Goat-Anti-Rat-IgG Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Rat-IgG Secondary Antibody"]},
							primaryAntibodySpecies==Chicken,
							{Model[Sample,"HRP-Conjugated Goat-Anti-Chicken-IgY Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Chicken-IgY Secondary Antibody"]},
							primaryAntibodySpecies==Goat,
							{Model[Sample,"HRP-Conjugated Donkey-Anti-Goat-IgG Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Donkey-Anti-Goat-IgG Secondary Antibody"]},
							primaryAntibodySpecies==Human,
							{Model[Sample,"HRP-Conjugated Rabbit-Anti-Human-IgG Secondary Antibody"],Model[Molecule,Protein,Antibody,"HRP-Conjugated Rabbit-Anti-Human-IgG Secondary Antibody"]}
						],

						unresolvableSingleSampleSecondaryAntibody=True;
						{Null,Null}
					],

					True,
					unresolvableSingleSampleSecondaryAntibody=True;
					{Null,Null}
				]
			];



		(*Resolve Capture Antibody*)

		If[suppliedSingleSampleCaptureAntibody===Automatic,

			If[MemberQ[{DirectELISA,IndirectELISA,DirectCompetitiveELISA,IndirectCompetitiveELISA},suppliedMethod]||MatchQ[{suppliedMethod,suppliedCoating},{(DirectSandwichELISA|IndirectSandwichELISA),False}],
				resolvedSingleSampleCaptureAntibodyMolecule=Null,

				resolvedSingleSampleCaptureAntibodyMolecule=If[resolvedSingleSampleTargetAntigen=!=Null,
					captureAntibodyCandidates = elisaGetPacketValue[resolvedSingleSampleTargetAntigen,Antibodies,All,simulatedCache];
					captureAntibodyCandidateConjugations = ToList[elisaGetPacketValue[#,DetectionLabels,All,simulatedCache]]&/@captureAntibodyCandidates;
					captureAntibodyCandidateConjugationHRPAPQ = Map[
						MemberQ[#,ObjectP[{Model[Molecule,Protein,"Horseradish Peroxidase"],Model[Molecule,Protein,"Alkaline Phosphatase"]}]]&,
						captureAntibodyCandidateConjugations,{1}];
					Which[
						(*If Method is SandwichELISA and no Coating, then set to Null.
					  If DirectSandwichELISA and among candidates exists non-conjugated Antibodies, pick the first unconjugated antibody;
					  If DirectSandwichELISA and among candidates exists non-conjugated Antibodies, pick the first unconjugated antibody sans Primary antibody;
					  If FastELISA, in candidate list and conjugation list, remove HRP/AP conjugated. Use these lists to pick out conjugated Antibodies and get the first one in the list
					*)
						MemberQ[{DirectSandwichELISA,IndirectSandwichELISA},suppliedMethod]&&suppliedCoating===False,
						Null,

						MatchQ[suppliedMethod,DirectSandwichELISA]&&MemberQ[captureAntibodyCandidateConjugations,{Null}],
						PickList[captureAntibodyCandidates,captureAntibodyCandidateConjugations,{Null}]//FirstOrDefault,

						MatchQ[suppliedMethod,IndirectSandwichELISA]&&MemberQ[captureAntibodyCandidateConjugations,{Null}],
						captureAntibodyNoConjugation=PickList[captureAntibodyCandidates,captureAntibodyCandidateConjugations,{Null}];
						primaryAntibdySpecies=elisaGetPacketValue[resolvedPrimaryAntibody,Organism,1,simulatedCache];
						captureAntibodyNoConjSpeciesList=elisaGetPacketValue[#,Organism,1,simulatedCache]&/@captureAntibodyNoConjugation;
						nonPrimaryAntibodySpecies=DeleteCases[captureAntibodyNoConjSpeciesList,primaryAntibdySpecies];
						captureAntibodyNoConjugation=PickList[captureAntibodyNoConjugation,captureAntibodyNoConjSpeciesList,Alternatives@@nonPrimaryAntibodySpecies]//FirstOrDefault,

						MatchQ[suppliedMethod,FastELISA],
						captureAntibodyCandidateAffinityTags = ToList[elisaGetPacketValue[#,AffinityLabels,All,simulatedCache]]&/@captureAntibodyCandidates;
						PickList[captureAntibodyCandidates,captureAntibodyCandidateAffinityTags,Except[{Null}]]//FirstOrDefault
					],
					Null
				]
			]
		];
		resolvedSingleSampleCaptureAntibody=
			If[suppliedSingleSampleCaptureAntibody=!=Automatic,
				resolvedSingleSampleCaptureAntibodyMolecule=suppliedSingleSampleCaptureAntibody,
				elisaGetPacketValue[resolvedSingleSampleCaptureAntibodyMolecule,DefaultSampleModel,1,simulatedCache]];

		If[(MatchQ[suppliedMethod,FastELISA]||
      MatchQ[{suppliedMethod,suppliedCoating},{(DirectSandwichELISA|IndirectSandwichELISA),True}])&&
          resolvedSingleSampleCaptureAntibody===Null,

			unresolvableSingleSampleCaptureAntibody=True
		];


		(*Resolve Coating Antibody*)
		resolvedSingleSampleCoatingAntibodyMolecule=If[suppliedSingleSampleCoatingAntibody===Automatic,
			(*Coating antbody only exists in FastELISA when Coating is True*)
			If[suppliedMethod=!=FastELISA||suppliedCoating===False,
				Null,

				If[unresolvableSingleSampleCaptureAntibody===False,
					captureAntibodyAffinityLabel=elisaGetPacketValue[resolvedSingleSampleCaptureAntibodyMolecule,AffinityLabels,1,simulatedCache];
					coatingAntibodyCandidates=elisaGetPacketValue[captureAntibodyAffinityLabel,Antibodies,All,simulatedCache];
					coatingAntibodyCandidateConjugations = ToList[elisaGetPacketValue[#,DetectionLabels,All,simulatedCache]]&/@coatingAntibodyCandidates;
					PickList[coatingAntibodyCandidates,coatingAntibodyCandidateConjugations,{Null}]//FirstOrDefault
				]
			]
		];
		resolvedSingleSampleCoatingAntibody=If[suppliedSingleSampleCoatingAntibody=!=Automatic,
			suppliedSingleSampleCoatingAntibody,
			elisaGetPacketValue[resolvedSingleSampleCoatingAntibodyMolecule,DefaultSampleModel,All,simulatedCache]
		];

		If[MatchQ[{suppliedMethod,suppliedCoating},{FastELISA,True}]&&resolvedSingleSampleCoatingAntibody===Null,
			unresolvableSingleSampleCoatingAntibody=True];


		(*Resolve ReferenceAntigen*)

		If[suppliedSingleSampleReferenceAntigen=!=Automatic,
			resolvedSingleSampleReferenceAntigen=suppliedSingleSampleReferenceAntigen,

			If[(!MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)])||(suppliedCoating===False),
				resolvedSingleSampleReferenceAntigen=Null,

				resolvedSingleSampleReferenceAntigen=If[resolvedSingleSampleTargetAntigen=!=Null,
					elisaGetPacketValue[resolvedSingleSampleTargetAntigen,DefaultSampleModel,1,simulatedCache],
					Null
				];
				If[resolvedSingleSampleReferenceAntigen===Null,unresolvableSingleSampleReferenceAntigen=True]
			]
		];


		(*Resolve SubstrateSolutionVolume, SubstrateSolutionVolume*)
		(*Get conjugation for the PrimaryAntibodies in Direct methods, and SecondaryAntibody in Indirect methods.*)

		allDetectionLabels=Which[
			MemberQ[{DirectELISA,DirectSandwichELISA,DirectCompetitiveELISA,FastELISA},suppliedMethod]
				&&unresolvableSingleSamplePrimaryAntibody===False,
			elisaGetPacketValue[resolvedSingleSamplePrimaryAntibodyMolecule,DetectionLabels,All,simulatedCache],

			MemberQ[{IndirectELISA,IndirectSandwichELISA,IndirectCompetitiveELISA},suppliedMethod]
				&&unresolvableSingleSampleSecondaryAntibody===False,
			elisaGetPacketValue[resolvedSingleSampleSecondaryAntibodyMolecule,DetectionLabels,All,simulatedCache],

			True,Null
		];
		assayEnzyme = Which[
			MemberQ[allDetectionLabels,ObjectP[Model[Molecule,Protein,"Horseradish Peroxidase"]]],Model[Molecule,Protein,"Horseradish Peroxidase"],
			MemberQ[allDetectionLabels,ObjectP[Model[Molecule,Protein,"Alkaline Phosphatase"]]],Model[Molecule,Protein,"Alkaline Phosphatase"],
			True,Null
		];

		autoSingleSampleSubstrateList=
			If[MatchQ[assayEnzyme,ObjectP[]],
				Which[
					MatchQ[assayEnzyme, ObjectP[Model[Molecule,Protein,"Horseradish Peroxidase"]]],
					{Model[Sample,"ELISA TMB Stabilized Chromogen"],Model[Sample,"ELISA HRP-TMB Stop Solution"]},

					MatchQ[assayEnzyme,ObjectP[Model[Molecule,Protein,"Alkaline Phosphatase"]]],
					{Model[Sample,"AP Substrate PNPP Solution"],Model[Sample, StockSolution, "Sodium Hydroxide 2M"]}
				],

				Module[{},
					(* Mark our errors *)
					If[MatchQ[suppliedSingleSampleSubstrateSolution,Automatic],
						unresolvableSingleSampleSubstrateSolution=True;
						unresolvableSingleSampleSubstrateSolutionVolume=True;
					];

					If[MatchQ[suppliedSingleSampleStopSolution,Automatic],
						unresolvableSingleSampleStopSolution=True;
						unresolvableSingleSampleStopSolutionVolume=True;
					];

					(* Return water as a default so we don't crash *)
					ConstantArray[Model[Sample, "Milli-Q water"],2]
				]
			];
		{
			resolvedSingleSampleSubstrateSolution,
			resolvedSingleSampleStopSolution
		}=elisaSetAuto[
			{
				suppliedSingleSampleSubstrateSolution,
				suppliedSingleSampleStopSolution
			},
			autoSingleSampleSubstrateList];

		resolvedSingleSampleSubstrateSolutionVolume=If[MatchQ[suppliedSingleSampleSubstrateSolutionVolume,Automatic],
			100Microliter,
			suppliedSingleSampleSubstrateSolutionVolume
		];
		resolvedSingleSampleStopSolutionVolume=If[MatchQ[suppliedSingleSampleStopSolutionVolume,Automatic],
			100Microliter,
			suppliedSingleSampleStopSolutionVolume
		];



		(*resolve method-dependent flat options. The logic of dilution factor is more complicated because we need to see if the volume is provided, list them separately*)
		autoFlatDilutionFactorOptions = Which[
			suppliedMethod===DirectELISA&&suppliedCoating==True,
			{Null,Null,Null,Null},

			suppliedMethod===DirectELISA&&suppliedCoating==False,
			{Null,Null,Null,Null},

			suppliedMethod===IndirectELISA&&suppliedCoating==True,
			{Null,Null,Null,0.001},

			suppliedMethod===IndirectELISA&&suppliedCoating==False,
			{Null,Null,Null,0.001},

			suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
			{Null,0.001,Null,Null},

			suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
			{Null,Null,Null,Null},

			suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
			{Null,0.001,Null,0.001},

			suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
			{Null,Null,Null,0.001},

			suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
			{Null,Null,0.001,Null},

			suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
			{Null,Null,Null,Null},

			suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
			{Null,Null,0.001,0.001},

			suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
			{Null,Null,Null,0.001},

			suppliedMethod===FastELISA&&suppliedCoating==True,
			{0.001,0.01,Null,Null},

			suppliedMethod===FastELISA&&suppliedCoating==False,
			{Null,0.01,Null,Null}
		];

		autoFlatOptions = Which[
			suppliedMethod===DirectELISA&&suppliedCoating==True,
			{Null,Null,Null,Null,100Microliter,Null,Null,Null,Null,Null,100Microliter,Null},

			suppliedMethod===DirectELISA&&suppliedCoating==False,
			{Null,Null,Null,Null,Null,Null,Null,Null,Null,Null,100Microliter,Null},

			suppliedMethod===IndirectELISA&&suppliedCoating==True,
			{Null,Null,Null,Refrigerator,100Microliter,Null,Null,Null,Null,Null,100Microliter,100Microliter},

			suppliedMethod===IndirectELISA&&suppliedCoating==False,
			{Null,Null,Null,Refrigerator,Null,Null,Null,Null,Null,Null,100Microliter,100Microliter},

			suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
			{Null,Refrigerator,Null,Null,Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,Null},

			suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
			{Null,Null,Null,Null,Null,Null,Null,Null,Null,100Microliter,100Microliter,Null},

			suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
			{Null,Refrigerator,Null,Refrigerator,Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,100Microliter},

			suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
			{Null,Null,Null,Refrigerator,Null,Null,Null,Null,Null,100Microliter,100Microliter,100Microliter},

			suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
			{Null,Null,Refrigerator,Null,Null,Null,100Microliter,Null,100Microliter,Null,Null,Null},

			suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
			{Null,Null,Null,Null,Null,Null,Null,Null,100Microliter,Null,Null,Null},

			suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
			{Null,Null,Refrigerator,Refrigerator,Null,Null,100Microliter,Null,100Microliter,Null,Null,100Microliter},

			suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
			{Null,Null,Null,Refrigerator,Null,Null,Null,Null,100Microliter,Null,Null,100Microliter},

			suppliedMethod===FastELISA&&suppliedCoating==True,
			{Refrigerator,Refrigerator,Null,Null,Null,100Microliter,Null,Null,100Microliter,Null,Null,Null},

			suppliedMethod===FastELISA&&suppliedCoating==False,
			{Null,Refrigerator,Null,Null,Null,Null,Null,Null,100Microliter,Null,Null,Null}
		];

		(* Depending on if the volume is specified, set dilution factor to the default value or Null to make sure only one of the two is not Null *)
		resolvedSingleSampleCoatingAntibodyDilutionFactor=If[NullQ[suppliedSingleSampleCoatingAntibodyVolume],
			elisaSetAuto[{suppliedSingleSampleCoatingAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[1]]}][[1]],
			elisaSetAuto[{suppliedSingleSampleCoatingAntibodyDilutionFactor}, {Null}][[1]]
		];

		resolvedSingleSampleCaptureAntibodyDilutionFactor=If[NullQ[suppliedSingleSampleCaptureAntibodyVolume],
			elisaSetAuto[{suppliedSingleSampleCaptureAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[2]]}][[1]],
			elisaSetAuto[{suppliedSingleSampleCaptureAntibodyDilutionFactor}, {Null}][[1]]
		];

		resolvedSingleSampleReferenceAntigenDilutionFactor=If[NullQ[suppliedSingleSampleReferenceAntigenVolume],
			elisaSetAuto[{suppliedSingleSampleReferenceAntigenDilutionFactor}, {autoFlatDilutionFactorOptions[[3]]}][[1]],
			elisaSetAuto[{suppliedSingleSampleReferenceAntigenDilutionFactor}, {Null}][[1]]
		];

		(* If SampleSecondaryAntibodyVolume is Null, we do not dilute it at all *)
		resolvedSingleSampleSecondaryAntibodyDilutionFactor=If[!NullQ[suppliedSingleSampleSecondaryAntibodyVolume],
			elisaSetAuto[{suppliedSingleSampleSecondaryAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[4]]}][[1]],
			elisaSetAuto[{suppliedSingleSampleSecondaryAntibodyDilutionFactor}, {Null}][[1]]
		];

		{
			resolvedSingleSampleCoatingAntibodyStorageCondition,
			resolvedSingleSampleCaptureAntibodyStorageCondition,
			resolvedSingleSampleReferenceAntigenStorageCondition,
			resolvedSingleSampleSecondaryAntibodyStorageCondition,
			resolvedSingleSampleSampleCoatingVolume,
			resolvedSingleSampleCoatingAntibodyCoatingVolume,
			resolvedSingleSampleReferenceAntigenCoatingVolume,
			resolvedSingleSampleCaptureAntibodyCoatingVolume,
			resolvedSingleSampleSampleAntibodyComplexImmunosorbentVolume,
			resolvedSingleSampleSampleImmunosorbentVolume,
			resolvedSingleSamplePrimaryAntibodyImmunosorbentVolume,
			resolvedSingleSampleSecondaryAntibodyImmunosorbentVolume
		}=elisaSetAuto[
			{
				suppliedSingleSampleCoatingAntibodyStorageCondition,
				suppliedSingleSampleCaptureAntibodyStorageCondition,
				suppliedSingleSampleReferenceAntigenStorageCondition,
				suppliedSingleSampleSecondaryAntibodyStorageCondition,
				suppliedSingleSampleSampleCoatingVolume,
				suppliedSingleSampleCoatingAntibodyCoatingVolume,
				suppliedSingleSampleReferenceAntigenCoatingVolume,
				suppliedSingleSampleCaptureAntibodyCoatingVolume,
				suppliedSingleSampleSampleAntibodyComplexImmunosorbentVolume,
				suppliedSingleSampleSampleImmunosorbentVolume,
				suppliedSingleSamplePrimaryAntibodyImmunosorbentVolume,
				suppliedSingleSampleSecondaryAntibodyImmunosorbentVolume
			},autoFlatOptions
		];

		(*standrd primary antibodies.*)
		{resolvedSingleSamplePrimaryAntibodyDilutionFactor}=If[
			!NullQ[resolvedSingleSamplePrimaryAntibody]&&NullQ[suppliedSingleSamplePrimaryAntibodyVolume],
			If[MatchQ[suppliedMethod,Alternatives[DirectCompetitiveELISA,IndirectCompetitiveELISA,FastELISA]],
				(*When sample is mixed with samples*)
				elisaSetAuto[{suppliedSingleSamplePrimaryAntibodyDilutionFactor},{0.01}],
				(*When sample is diluted in diluents*)
				elisaSetAuto[{suppliedSingleSamplePrimaryAntibodyDilutionFactor},{0.001}]
			],
			elisaSetAuto[{suppliedSingleSamplePrimaryAntibodyDilutionFactor},{Null}]
		];

		(*Resolve spike options*)
		{resolvedSinlgeSpikeDilutionFactor,resolvedSingleSpikeStorageCondition}=
      If[!MatchQ[suppliedSingleSpike,Null],
			elisaSetAuto[{suppliedSingleSpikeDilutionFactor,suppliedSingleSpikeStorageCondition},{0.1,Refrigerator}],
			elisaSetAuto[{suppliedSingleSpikeDilutionFactor,suppliedSingleSpikeStorageCondition},{Null,Null}]
		];

		(*Resolve SampleDilutionCurve options*)

		{resolvedSingleSampleSampleSerialDilutionCurve,resolvedSingleSampleSampleDilutionCurve}=Switch[

			{suppliedSingleSampleSampleSerialDilutionCurve,suppliedSingleSampleSampleDilutionCurve},
			(* If neither is not Automatic, respect them *)
			{Except[Automatic],Except[Automatic]},{suppliedSingleSampleSampleSerialDilutionCurve,suppliedSingleSampleSampleDilutionCurve},

			(* If one is automatic and the other is not, set to Null no matter what *)
			{Null,Automatic},
			{Null,Null},

			{Except[Automatic|Null],Automatic},
			{suppliedSingleSampleSampleSerialDilutionCurve,Null},

			{Automatic,Null},
			{Null,Null},

			{Automatic,Except[Automatic|Null]},
			{Null,suppliedSingleSampleSampleDilutionCurve},

			(* Both are automatic - Check if user wants dilution by giving diluent *)
			{Automatic,Automatic},
			If[MatchQ[resolvedSampleDiluent,ObjectP[]],
				{{100Microliter,{0.5,6}},Null},
				{Null,Null}
			]
		];



		{
			{
				resolvedSingleSampleTargetAntigen,
				resolvedSingleSampleCoatingAntibody,
				resolvedSingleSampleCoatingAntibodyDilutionFactor,
				resolvedSingleSampleCoatingAntibodyStorageCondition,
				resolvedSingleSampleCaptureAntibody,
				resolvedSingleSampleCaptureAntibodyDilutionFactor,
				resolvedSingleSampleCaptureAntibodyStorageCondition,
				resolvedSingleSampleReferenceAntigen,
				resolvedSingleSampleReferenceAntigenDilutionFactor,
				resolvedSingleSampleReferenceAntigenStorageCondition,
				resolvedSingleSamplePrimaryAntibody,
				resolvedSingleSamplePrimaryAntibodyDilutionFactor,
				resolvedSingleSampleSecondaryAntibody,
				resolvedSingleSampleSecondaryAntibodyDilutionFactor,
				resolvedSingleSampleSecondaryAntibodyStorageCondition,
				resolvedSingleSampleSampleCoatingVolume,
				resolvedSingleSampleCoatingAntibodyCoatingVolume,
				resolvedSingleSampleReferenceAntigenCoatingVolume,
				resolvedSingleSampleCaptureAntibodyCoatingVolume,
				resolvedSingleSampleBlockingVolume,
				resolvedSingleSampleSampleAntibodyComplexImmunosorbentVolume,
				resolvedSingleSampleSampleImmunosorbentVolume,
				resolvedSingleSamplePrimaryAntibodyImmunosorbentVolume,
				resolvedSingleSampleSecondaryAntibodyImmunosorbentVolume,
				resolvedSingleSampleSubstrateSolution,
				resolvedSingleSampleStopSolution,
				resolvedSingleSampleSubstrateSolutionVolume,
				resolvedSingleSampleStopSolutionVolume,
				resolvedSingleSampleSampleDilutionCurve,
				resolvedSingleSampleSampleSerialDilutionCurve,
				resolvedSinlgeSpikeDilutionFactor,
				resolvedSingleSpikeStorageCondition
			},

			{
				unresolvableSingleSamplePrimaryAntibody,
				unresolvableSingleSampleSecondaryAntibody,
				unresolvableSingleSampleCaptureAntibody,
				unresolvableSingleSampleCoatingAntibody,
				unresolvableSingleSampleReferenceAntigen,
				unresolvableSingleSampleSubstrateSolution,
				unresolvableSingleSampleStopSolution,
				unresolvableSingleSampleSubstrateSolutionVolume,
				unresolvableSingleSampleStopSolutionVolume
			}
		}


	];
	(*Use the function to MapThread out sample Index-matched options*)
	sampleIndexedOptionResolvedPool = Map[elisaResolveIndexMatchedSampleOptions[#]&, sampleMapThreadFriends];

	(*Parse out the pool to get resolved options and unresolvable booleans*)
	{
		resolvedTargetAntigen,
		resolvedCoatingAntibody,
		resolvedCoatingAntibodyDilutionFactor,
		resolvedCoatingAntibodyStorageCondition,
		resolvedCaptureAntibody,
		resolvedCaptureAntibodyDilutionFactor,
		resolvedCaptureAntibodyStorageCondition,
		resolvedReferenceAntigen,
		resolvedReferenceAntigenDilutionFactor,
		resolvedReferenceAntigenStorageCondition,
		resolvedPrimaryAntibody,
		resolvedPrimaryAntibodyDilutionFactor,
		resolvedSecondaryAntibody,
		resolvedSecondaryAntibodyDilutionFactor,
		resolvedSecondaryAntibodyStorageCondition,
		resolvedSampleCoatingVolume,
		resolvedCoatingAntibodyCoatingVolume,
		resolvedReferenceAntigenCoatingVolume,
		resolvedCaptureAntibodyCoatingVolume,
		resolvedBlockingVolume,
		resolvedSampleAntibodyComplexImmunosorbentVolume,
		resolvedSampleImmunosorbentVolume,
		resolvedPrimaryAntibodyImmunosorbentVolume,
		resolvedSecondaryAntibodyImmunosorbentVolume,
		resolvedSubstrateSolution,
		resolvedStopSolution,
		resolvedSubstrateSolutionVolume,
		resolvedStopSolutionVolume,
		resolvedSampleDilutionCurve,
		resolvedSampleSerialDilutionCurve,
		resolvedSpikeDilutionFactor,
		resolvedSpikeStorageCondition
	}=Transpose[sampleIndexedOptionResolvedPool[[All,1]]];

	{
		unresolvablePrimaryAntibodyList,
		unresolvableSecondaryAntibodyList,
		unresolvableCaptureAntibodyList,
		unresolvableCoatingAntibodyList,
		unresolvableReferenceAntigenList,
		unresolvableSubstrateSolutionList,
		unresolvableStopSolutionList,
		unresolvableSubstrateSolutionVolumeList,
		unresolvableStopSolutionVolumeList}=sampleIndexedOptionResolvedPool[[All,2]]//Transpose;


	(*Before resolving standard and blank index-matched options, make a sample TargetAntigen-to-reagent lookup table containing an key-values of TargetAntigen->{PrimaryAntibody,SecondaryAntibody,CaptureAntibody,CoatingAntibody,ReferenceAntigen,SubstrateSolution,StopSolution}. This will combine all keys and include one situation where TargetAntigen==Null, if any. Because we require that the antibodies for standards and blanks to be a sublist of sample antibodies, after resolving StandardTargetAntigen/BlankTargetAntigen, we will proceed resolving the antibodies directly by picking from the sample lookup table.*)
	sampleReagentTable=Transpose[{resolvedPrimaryAntibody,resolvedSecondaryAntibody,resolvedCaptureAntibody,resolvedCoatingAntibody,resolvedReferenceAntigen,resolvedSubstrateSolution,resolvedStopSolution}];
	(*AssociationThread will delete duplicated keys and keep the last key-value pattern*)
	sampleTargetAntigenToReagentLookupTable=AssociationThread[resolvedTargetAntigen,sampleReagentTable];
	defaultLookup=Lookup[sampleTargetAntigenToReagentLookupTable,resolvedTargetAntigen[[1]]];


	(*=============Resolve standard IndexMatched options=================*)
	semiresolvedStandard = Which[
		MatchQ[ToList@suppliedStandard, Except[{Automatic}]],
			suppliedStandard,
		(*If method is DirectELISA or IndirectELISA and coating is false, then all samples were provided as SamplesIn (or ContainersIn transformed to samplesIn). There won't be any explicit standards unless a precoated standard is specified. *)
		MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)]&&MatchQ[suppliedCoating,False],
			{Null},
		True,
			suppliedStandard
	];
	If[MatchQ[semiresolvedStandard, ListableP[Null]],
		{
			resolvedStandard,
			resolvedStandardStorageCondition,
			resolvedStandardTargetAntigen,
			resolvedStandardCoatingAntibody,
			resolvedStandardCoatingAntibodyDilutionFactor,
			resolvedStandardCaptureAntibody,
			resolvedStandardCaptureAntibodyDilutionFactor,
			resolvedStandardReferenceAntigen,
			resolvedStandardReferenceAntigenDilutionFactor,
			resolvedStandardPrimaryAntibody,
			resolvedStandardPrimaryAntibodyDilutionFactor,
			resolvedStandardSecondaryAntibody,
			resolvedStandardSecondaryAntibodyDilutionFactor,
			resolvedStandardCoatingVolume,
			resolvedStandardCoatingAntibodyCoatingVolume,
			resolvedStandardReferenceAntigenCoatingVolume,
			resolvedStandardCaptureAntibodyCoatingVolume,
			resolvedStandardBlockingVolume,
			resolvedStandardAntibodyComplexImmunosorbentVolume,
			resolvedStandardImmunosorbentVolume,
			resolvedStandardPrimaryAntibodyImmunosorbentVolume,
			resolvedStandardSecondaryAntibodyImmunosorbentVolume,
			resolvedStandardSubstrateSolution,
			resolvedStandardStopSolution,
			resolvedStandardSubstrateSolutionVolume,
			resolvedStandardStopSolutionVolume,
			resolvedStandardDilutionCurve,
			resolvedStandardSerialDilutionCurve
		}=elisaSetAuto[
			{
				semiresolvedStandard,
				suppliedStandardStorageCondition,
				suppliedStandardTargetAntigen,
				suppliedStandardCoatingAntibody,
				suppliedStandardCoatingAntibodyDilutionFactor,
				suppliedStandardCaptureAntibody,
				suppliedStandardCaptureAntibodyDilutionFactor,
				suppliedStandardReferenceAntigen,
				suppliedStandardReferenceAntigenDilutionFactor,
				suppliedStandardPrimaryAntibody,
				suppliedStandardPrimaryAntibodyDilutionFactor,
				suppliedStandardSecondaryAntibody,
				suppliedStandardSecondaryAntibodyDilutionFactor,
				suppliedStandardCoatingVolume,
				suppliedStandardCoatingAntibodyCoatingVolume,
				suppliedStandardReferenceAntigenCoatingVolume,
				suppliedStandardCaptureAntibodyCoatingVolume,
				suppliedStandardBlockingVolume,
				suppliedStandardAntibodyComplexImmunosorbentVolume,
				suppliedStandardImmunosorbentVolume,
				suppliedStandardPrimaryAntibodyImmunosorbentVolume,
				suppliedStandardSecondaryAntibodyImmunosorbentVolume,
				suppliedStandardSubstrateSolution,
				suppliedStandardStopSolution,
				suppliedStandardSubstrateSolutionVolume,
				suppliedStandardStopSolutionVolume,
				suppliedStandardDilutionCurve,
				suppliedStandardSerialDilutionCurve
			},
			ConstantArray[{Null},28]
		];
		(*We do not throw this warning if sample is coated*)
		If[MatchQ[resolvedStandard,ListableP[Null]]&&!(MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)]&&MatchQ[suppliedCoating,False]),
			Message[Warning::ELISANoStandardForExperiment]
		];
		{
			unresolvableStandardList,
			unresolvableStandardPrimaryAntibodyList,
			unresolvableStandardSecondaryAntibodyList,
			unresolvableStandardCaptureAntibodyList,
			unresolvableStandardCoatingAntibodyList,
			unresolvableStandardReferenceAntigenList,
			unresolvableStandardSubstrateSolutionList,
			unresolvableStandardStopSolutionList,
			unresolvableStandardSubstrateSolutionVolumeList,
			unresolvableStandardStopSolutionVolumeList
		}=ConstantArray[{False},10],
		
		(*BELOW IS A BIG ELSE: Otherwise, we resolve each index-matched standard and options individually.*)
		standardMapThreadFriends = elisaMakeMapThreadFriends[semiresolvedStandard,suppliedStandardChildrenValues,standardChildrenNames];

		elisaResolveIndexMatchedStandardOptions[singlePacket_]:=Module[{singleStandard,suppliedSingleStandardTargetAntigen,suppliedSingleStandardCoatingAntibody,suppliedSingleStandardCoatingAntibodyDilutionFactor,suppliedSingleStandardCoatingAntibodyVolume,suppliedSingleStandardCoatingAntibodyStorageCondition,suppliedSingleStandardCaptureAntibody,suppliedSingleStandardCaptureAntibodyDilutionFactor,suppliedSingleStandardCaptureAntibodyVolume,suppliedSingleStandardCaptureAntibodyStorageCondition,suppliedSingleStandardReferenceAntigen,suppliedSingleStandardReferenceAntigenDilutionFactor,suppliedSingleStandardReferenceAntigenVolume,suppliedSingleStandardReferenceAntigenStorageCondition,suppliedSingleStandardPrimaryAntibody,suppliedSingleStandardSecondaryAntibody,suppliedSingleStandardSecondaryAntibodyDilutionFactor,suppliedSingleStandardSecondaryAntibodyVolume,suppliedSingleStandardSecondaryAntibodyStorageCondition,suppliedSingleStandardCoatingVolume,suppliedSingleStandardCoatingAntibodyCoatingVolume,suppliedSingleStandardReferenceAntigenCoatingVolume,suppliedSingleStandardCaptureAntibodyCoatingVolume,suppliedSingleStandardBlockingVolume,suppliedSingleStandardAntibodyComplexImmunosorbentVolume,suppliedSingleStandardImmunosorbentVolume,suppliedSingleStandardPrimaryAntibodyImmunosorbentVolume,suppliedSingleStandardSecondaryAntibodyImmunosorbentVolume,suppliedSingleStandardSubstrateSolution,suppliedSingleStandardStopSolution,suppliedSingleStandardSubstrateSolutionVolume,suppliedSingleStandardStopSolutionVolume,suppliedSingleStandardDilutionCurve,suppliedSingleStandardSerialDilutionCurve,resolvedSingleStandardTargetAntigen,resolvedSingleStandardCoatingAntibody,resolvedSingleStandardCoatingAntibodyDilutionFactor,resolvedSingleStandardCoatingAntibodyStorageCondition,resolvedSingleStandardCaptureAntibody,resolvedSingleStandardCaptureAntibodyDilutionFactor,resolvedSingleStandardCaptureAntibodyStorageCondition,resolvedSingleStandardReferenceAntigen,resolvedSingleStandardReferenceAntigenDilutionFactor,resolvedSingleStandardReferenceAntigenStorageCondition,resolvedSingleStandardPrimaryAntibody,resolvedSingleStandardSecondaryAntibody,resolvedSingleStandardSecondaryAntibodyDilutionFactor,resolvedSingleStandardSecondaryAntibodyStorageCondition,resolvedSingleStandardCoatingVolume,resolvedSingleStandardCoatingAntibodyCoatingVolume,resolvedSingleStandardReferenceAntigenCoatingVolume,resolvedSingleStandardCaptureAntibodyCoatingVolume,resolvedSingleStandardBlockingVolume,resolvedSingleStandardAntibodyComplexImmunosorbentVolume,resolvedSingleStandardImmunosorbentVolume,resolvedSingleStandardPrimaryAntibodyImmunosorbentVolume,resolvedSingleStandardSecondaryAntibodyImmunosorbentVolume,resolvedSingleStandardSubstrateSolution,resolvedSingleStandardStopSolution,resolvedSingleStandardSubstrateSolutionVolume,resolvedSingleStandardStopSolutionVolume,resolvedSingleStandardDilutionCurve,resolvedSingleStandardSerialDilutionCurve,unresolvableSingleStandardPrimaryAntibody,unresolvableSingleStandardSecondaryAntibody,unresolvableSingleStandardCaptureAntibody,unresolvableSingleStandardCoatingAntibody,unresolvableSingleStandardReferenceAntigen,unresolvableSingleStandardSubstrateSolution,unresolvableSingleStandardStopSolution,unresolvableSingleStandardSubstrateSolutionVolume,unresolvableSingleStandardStopSolutionVolume,autoPrimaryAntibodyCandidates,primaryAntibodyCandidateConjugations,primaryAntibodyCandidateConjugationHRPAPQ,autoPrimaryAntibodyCandidatesNoConjugation,autoPrimaryAntibodyCandidatesNoConjugationSpecies,primaryAntibodySpecies,captureAntibodyCandidates,captureAntibodyCandidateConjugations,captureAntibodyCandidateConjugationHRPAPQ,captureAntibodyNoConjugation,coatingAntibodyCandidates,coatingAntibodyCandidateConjugations,suppliedSingleStandardPrimaryAntibodyDilutionFactor,suppliedSingleStandardPrimaryAntibodyVolume,suppliedSingleStandardPrimaryAntibodyStorageCondition,resolvedSingleStandardPrimaryAntibodyDilutionFactor,resolvedSingleStandardPrimaryAntibodyStorageCondition,resolvedSingleStandard,unresolvableSingleStandard,suppliedStandardSingleStandardChildValues,assayEnzyme,suppliedSingleStandardStorageCondition,resolvedSingleStandardStorageCondition,resolvedSingleStandardCaptureAntibodyMolecule,primaryAntibdySpecies,captureAntibodyNoConjSpeciesList,nonPrimaryAntibodySpecies,captureAntibodyCandidateAffinityTags,resolvedSingleStandardCoatingAntibodyMolecule,captureAntibodyAffinityLabel,allDetectionLabels,autoFlatDilutionFactorOptions,autoFlatOptions,autoSingleStandardSubstrateList,autoSingleBlankSubstrateList,primaryAntibodyMolecule,resolvedSingleStandardPrimaryAntibodyMolecule,resolvedSingleStandardSecondaryAntibodyMolecule,reagentTransferFromSampleToStandard
		},
			(*Setup Error-tracking Booleans*)
			{
				unresolvableSingleStandard,
				unresolvableSingleStandardPrimaryAntibody,
				unresolvableSingleStandardSecondaryAntibody,
				unresolvableSingleStandardCaptureAntibody,
				unresolvableSingleStandardCoatingAntibody,
				unresolvableSingleStandardReferenceAntigen,
				unresolvableSingleStandardSubstrateSolution,
				unresolvableSingleStandardStopSolution,
				unresolvableSingleStandardSubstrateSolutionVolume,
				unresolvableSingleStandardStopSolutionVolume}=ConstantArray[False,10];
			(*Compare to samples, standard has more auto: StandardPrimaryAntibodyDilutionFactor*)
			{
				singleStandard,
				suppliedSingleStandardStorageCondition,
				suppliedSingleStandardTargetAntigen,
				suppliedSingleStandardCoatingAntibody,
				suppliedSingleStandardCoatingAntibodyDilutionFactor,
				suppliedSingleStandardCoatingAntibodyVolume,
				suppliedSingleStandardCaptureAntibody,
				suppliedSingleStandardCaptureAntibodyDilutionFactor,
				suppliedSingleStandardCaptureAntibodyVolume,
				suppliedSingleStandardReferenceAntigen,
				suppliedSingleStandardReferenceAntigenDilutionFactor,
				suppliedSingleStandardReferenceAntigenVolume,
				suppliedSingleStandardPrimaryAntibody,
				suppliedSingleStandardSecondaryAntibody,
				suppliedSingleStandardSecondaryAntibodyDilutionFactor,
				suppliedSingleStandardSecondaryAntibodyVolume,
				suppliedSingleStandardCoatingVolume,
				suppliedSingleStandardCoatingAntibodyCoatingVolume,
				suppliedSingleStandardReferenceAntigenCoatingVolume,
				suppliedSingleStandardCaptureAntibodyCoatingVolume,
				suppliedSingleStandardBlockingVolume,
				suppliedSingleStandardAntibodyComplexImmunosorbentVolume,
				suppliedSingleStandardImmunosorbentVolume,
				suppliedSingleStandardPrimaryAntibodyImmunosorbentVolume,
				suppliedSingleStandardSecondaryAntibodyImmunosorbentVolume,
				suppliedSingleStandardSubstrateSolution,
				suppliedSingleStandardStopSolution,
				suppliedSingleStandardSubstrateSolutionVolume,
				suppliedSingleStandardStopSolutionVolume,
				suppliedSingleStandardDilutionCurve,
				suppliedSingleStandardSerialDilutionCurve,
				suppliedSingleStandardPrimaryAntibodyDilutionFactor,
				suppliedSingleStandardPrimaryAntibodyVolume
			}= Lookup[singlePacket,{
				"parent",
				StandardStorageCondition,
				StandardTargetAntigen,
				StandardCoatingAntibody,
				StandardCoatingAntibodyDilutionFactor,
				StandardCoatingAntibodyVolume,
				StandardCaptureAntibody,
				StandardCaptureAntibodyDilutionFactor,
				StandardCaptureAntibodyVolume,
				StandardReferenceAntigen,
				StandardReferenceAntigenDilutionFactor,
				StandardReferenceAntigenVolume,
				StandardPrimaryAntibody,
				StandardSecondaryAntibody,
				StandardSecondaryAntibodyDilutionFactor,
				StandardSecondaryAntibodyVolume,
				StandardCoatingVolume,
				StandardCoatingAntibodyCoatingVolume,
				StandardReferenceAntigenCoatingVolume,
				StandardCaptureAntibodyCoatingVolume,
				StandardBlockingVolume,
				StandardAntibodyComplexImmunosorbentVolume,
				StandardImmunosorbentVolume,
				StandardPrimaryAntibodyImmunosorbentVolume,
				StandardSecondaryAntibodyImmunosorbentVolume,
				StandardSubstrateSolution,
				StandardStopSolution,
				StandardSubstrateSolutionVolume,
				StandardStopSolutionVolume,
				StandardDilutionCurve,
				StandardSerialDilutionCurve,
				StandardPrimaryAntibodyDilutionFactor,
				StandardPrimaryAntibodyVolume
			}];



			(**resolve standard**)
			suppliedStandardSingleStandardChildValues={
				suppliedSingleStandardStorageCondition,
				suppliedSingleStandardTargetAntigen,
				suppliedSingleStandardCoatingAntibody,
				suppliedSingleStandardCoatingAntibodyDilutionFactor,
				suppliedSingleStandardCaptureAntibody,
				suppliedSingleStandardCaptureAntibodyDilutionFactor,
				suppliedSingleStandardReferenceAntigen,
				suppliedSingleStandardReferenceAntigenDilutionFactor,
				suppliedSingleStandardPrimaryAntibody,
				suppliedSingleStandardSecondaryAntibody,
				suppliedSingleStandardSecondaryAntibodyDilutionFactor,
				suppliedSingleStandardCoatingVolume,
				suppliedSingleStandardCoatingAntibodyCoatingVolume,
				suppliedSingleStandardReferenceAntigenCoatingVolume,
				suppliedSingleStandardCaptureAntibodyCoatingVolume,
				suppliedSingleStandardBlockingVolume,
				suppliedSingleStandardAntibodyComplexImmunosorbentVolume,
				suppliedSingleStandardImmunosorbentVolume,
				suppliedSingleStandardPrimaryAntibodyImmunosorbentVolume,
				suppliedSingleStandardSecondaryAntibodyImmunosorbentVolume,
				suppliedSingleStandardSubstrateSolution,
				suppliedSingleStandardStopSolution,
				suppliedSingleStandardSubstrateSolutionVolume,
				suppliedSingleStandardStopSolutionVolume,
				suppliedSingleStandardDilutionCurve,
				suppliedSingleStandardSerialDilutionCurve,
				suppliedSingleStandardPrimaryAntibodyDilutionFactor
			};
			
			(**Resolve TargetAntigen**)
			resolvedSingleStandardTargetAntigen = Which[
				suppliedSingleStandardTargetAntigen=!=Automatic,suppliedSingleStandardTargetAntigen,
				(* Set target antigen to Null if standard is not available *)
				NullQ[singleStandard],Null,
				True,
				FirstCase[{
					elisaGetPacketValue[singleStandard,Analytes,1,simulatedCache],
					elisaGetPacketValue[elisaGetPacketValue[singleStandard,Model,1,simulatedCache],Analytes,1,simulatedCache],
					elisaGetPacketValue[elisaGetPacketValue[suppliedSingleStandardPrimaryAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
					elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleStandardPrimaryAntibody,Model,1,simulatedCache],Analytes,1],Targets,1,simulatedCache],
					elisaGetPacketValue[elisaGetPacketValue[suppliedSingleStandardCaptureAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
					elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleStandardCaptureAntibody,Model,1,simulatedCache],Analytes,1,simulatedCache],Targets,1,simulatedCache],
					FirstOrDefault[ToList[resolvedTargetAntigen]]
				},ObjectP[Model[Molecule]],Null]
			];

			(*Resolve standard, if all of the child options are Null, then Standard is Null.If any of them is  not Null, standard will resolve based on potentially available TargetAntigen, PrimaryAntibody, or SecondaryAntibody*)
			resolvedSingleStandard =If[
				!MatchQ[singleStandard,Automatic],
				singleStandard,

				If[MatchQ[suppliedStandardSingleStandardChildValues,{Null..}],
					Null,
					elisaGetPacketValue[resolvedSingleStandardTargetAntigen,DefaultSampleModel,1,simulatedCache]
				]
			];
			(* Only track unresolvable error when standard is resolved to Null but not provided by the user *)
			If[MemberQ[suppliedStandardSingleStandardChildValues,Except[Null|Automatic]&&resolvedSingleStandard===Null&&!MatchQ[singleStandard,Null]],
				unresolvableSingleStandard=True
			];(**It is allowed that no standard is used for the experiment, but here some of the standard child options are specified as not null, indicating that the user intends to have standard**)

			If[MatchQ[resolvedSingleStandard,Null],
				{
					resolvedSingleStandardStorageCondition,
					resolvedSingleStandardCoatingAntibody,
					resolvedSingleStandardCoatingAntibodyDilutionFactor,
					resolvedSingleStandardCaptureAntibody,
					resolvedSingleStandardCaptureAntibodyDilutionFactor,
					resolvedSingleStandardReferenceAntigen,
					resolvedSingleStandardReferenceAntigenDilutionFactor,
					resolvedSingleStandardPrimaryAntibody,
					resolvedSingleStandardSecondaryAntibody,
					resolvedSingleStandardSecondaryAntibodyDilutionFactor,
					resolvedSingleStandardCoatingVolume,
					resolvedSingleStandardCoatingAntibodyCoatingVolume,
					resolvedSingleStandardReferenceAntigenCoatingVolume,
					resolvedSingleStandardCaptureAntibodyCoatingVolume,
					resolvedSingleStandardBlockingVolume,
					resolvedSingleStandardAntibodyComplexImmunosorbentVolume,
					resolvedSingleStandardImmunosorbentVolume,
					resolvedSingleStandardPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleStandardSecondaryAntibodyImmunosorbentVolume,
					resolvedSingleStandardSubstrateSolution,
					resolvedSingleStandardStopSolution,
					resolvedSingleStandardSubstrateSolutionVolume,
					resolvedSingleStandardStopSolutionVolume,
					resolvedSingleStandardDilutionCurve,
					resolvedSingleStandardSerialDilutionCurve,
					resolvedSingleStandardPrimaryAntibodyDilutionFactor}=elisaSetAuto[
					{
						suppliedSingleStandardStorageCondition,
						suppliedSingleStandardCoatingAntibody,
						suppliedSingleStandardCoatingAntibodyDilutionFactor,
						suppliedSingleStandardCaptureAntibody,
						suppliedSingleStandardCaptureAntibodyDilutionFactor,
						suppliedSingleStandardReferenceAntigen,
						suppliedSingleStandardReferenceAntigenDilutionFactor,
						suppliedSingleStandardPrimaryAntibody,
						suppliedSingleStandardSecondaryAntibody,
						suppliedSingleStandardSecondaryAntibodyDilutionFactor,
						suppliedSingleStandardCoatingVolume,
						suppliedSingleStandardCoatingAntibodyCoatingVolume,
						suppliedSingleStandardReferenceAntigenCoatingVolume,
						suppliedSingleStandardCaptureAntibodyCoatingVolume,
						suppliedSingleStandardBlockingVolume,
						suppliedSingleStandardAntibodyComplexImmunosorbentVolume,
						suppliedSingleStandardImmunosorbentVolume,
						suppliedSingleStandardPrimaryAntibodyImmunosorbentVolume,
						suppliedSingleStandardSecondaryAntibodyImmunosorbentVolume,
						suppliedSingleStandardSubstrateSolution,
						suppliedSingleStandardStopSolution,
						suppliedSingleStandardSubstrateSolutionVolume,
						suppliedSingleStandardStopSolutionVolume,
						suppliedSingleStandardDilutionCurve,
						suppliedSingleStandardSerialDilutionCurve,
						suppliedSingleStandardPrimaryAntibodyDilutionFactor}, ConstantArray[Null,26]],

				(*---------The following is a big else: scenario when standard is not Null.----------*)

				(*resolve StandardStorageCondition*)
				resolvedSingleStandardStorageCondition=elisaSetAuto[{suppliedSingleStandardStorageCondition},{Refrigerator}][[1]];

				(*Resolve Blocking Volume: Return is a list. Head must be stripped.*)

				resolvedSingleStandardBlockingVolume = If[suppliedBlocking,
					elisaSetAuto[{suppliedSingleStandardBlockingVolume},{100 Microliter}],
					elisaSetAuto[{suppliedSingleStandardBlockingVolume},{Null}]
				][[1]];

				(* Lookup all the reagents based on TargetAntigen matching between standard and sample*)
				reagentTransferFromSampleToStandard=Lookup[sampleTargetAntigenToReagentLookupTable,resolvedSingleStandardTargetAntigen,defaultLookup];

				(*resolve primary antibody*)

				resolvedSingleStandardPrimaryAntibody=If[!MatchQ[suppliedSingleStandardPrimaryAntibody,Automatic],
					suppliedSingleStandardPrimaryAntibody,
					reagentTransferFromSampleToStandard[[1]]

				];

				(*We don't need to discuss the situation where no standard is needed and primary antibody being Null, as this is under that big ELSE above.*)
				If[MatchQ[resolvedSingleStandardPrimaryAntibody,Null],unresolvableSingleStandardPrimaryAntibody=True];


				(*Resolve Secondary Antibody*)
				resolvedSingleStandardSecondaryAntibody=If[!MatchQ[suppliedSingleStandardSecondaryAntibody,Automatic],
					suppliedSingleStandardSecondaryAntibody,
					reagentTransferFromSampleToStandard[[2]]
				];
				If[MatchQ[{suppliedMethod,resolvedSingleStandardSecondaryAntibody},{(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA),Null}],unresolvableSingleStandardSecondaryAntibody=True];


				
				(*Resolve Capture Antibody*)
				resolvedSingleStandardCaptureAntibody=If[!MatchQ[suppliedSingleStandardCaptureAntibody,Automatic],
					suppliedSingleStandardCaptureAntibody,
					reagentTransferFromSampleToStandard[[3]]
				];
				If[(MatchQ[{suppliedMethod,resolvedSingleStandardCaptureAntibody},{FastELISA,Null}]||MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleStandardCaptureAntibody},{(DirectSandwichELISA|IndirectSandwichELISA),True,Null}]),
					unresolvableSingleStandardCaptureAntibody=True];


				(*Resolve Coating Antibody*)
				resolvedSingleStandardCoatingAntibody=If[!MatchQ[suppliedSingleStandardCoatingAntibody,Automatic],
					suppliedSingleStandardCoatingAntibody,
					reagentTransferFromSampleToStandard[[4]]
				];
				If[MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleStandardCoatingAntibody},{FastELISA,True,Null}],
					unresolvableSingleStandardCoatingAntibody=True];



				(*Resolve ReferenceAntigen*)
				resolvedSingleStandardReferenceAntigen=If[!MatchQ[suppliedSingleStandardReferenceAntigen,Automatic],
					suppliedSingleStandardReferenceAntigen,
					reagentTransferFromSampleToStandard[[5]]
				];
				If[MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleStandardReferenceAntigen},{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True,Null}],
					unresolvableSingleStandardReferenceAntigen=True];


				(*Resolve SubstrateSolutionVolume, SubstrateSolutionVolume*)
				(*Get conjugation for the PrimaryAntibodies in Direct methods, and SecondaryAntibody in Indirect methods.*)
				resolvedSingleStandardSubstrateSolution=If[!MatchQ[suppliedSingleStandardSubstrateSolution,Automatic],
					suppliedSingleStandardSubstrateSolution,
					reagentTransferFromSampleToStandard[[6]]
				];
				resolvedSingleStandardStopSolution=If[!MatchQ[suppliedSingleStandardStopSolution,Automatic],
					suppliedSingleStandardStopSolution,
					reagentTransferFromSampleToStandard[[7]]
				];
				
				resolvedSingleStandardSubstrateSolutionVolume=If[MatchQ[resolvedSingleStandardSubstrateSolution,ObjectP[]],
					If[MatchQ[suppliedSingleStandardSubstrateSolutionVolume,Automatic], 100Microliter,suppliedSingleStandardSubstrateSolutionVolume],
					Null
				];
				resolvedSingleStandardStopSolutionVolume=If[MatchQ[resolvedSingleStandardStopSolution,ObjectP[]],
					If[MatchQ[suppliedSingleStandardStopSolutionVolume,Automatic], 100Microliter,suppliedSingleStandardStopSolutionVolume],
					Null
				];

				If[MatchQ[suppliedSingleStandardSubstrateSolution,Automatic]&&(!MatchQ[resolvedSingleStandardSubstrateSolution,ObjectP[]]),
					unresolvableSingleStandardSubstrateSolution=True;
					unresolvableSingleStandardSubstrateSolutionVolume=True
				];
				If[
					MatchQ[suppliedSingleStandardStopSolution,Automatic]&&MatchQ[resolvedSingleStandardStopSolution,Except[ObjectP[]]]&&MatchQ[reagentTransferFromSampleToStandard[[7]],Except[Null]],
					unresolvableSingleStandardStopSolution=True;
					unresolvableSingleStandardStopSolutionVolume=True
				];

				(*resolve method-dependent flat options. The logic of dilution factor is more complicated because we need to see if the volume is provided, list them separately*)
				autoFlatDilutionFactorOptions = Which[
					suppliedMethod===DirectELISA&&suppliedCoating==True,
					{Null,Null,Null,Null},

					suppliedMethod===DirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectELISA&&suppliedCoating==True,
					{Null,Null,Null,0.001},

					suppliedMethod===IndirectELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
					{Null,0.001,Null,Null},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
					{Null,0.001,Null,0.001},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,0.001,Null},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,0.001,0.001},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===FastELISA&&suppliedCoating==True,
					{0.001,0.01,Null,Null},

					suppliedMethod===FastELISA&&suppliedCoating==False,
					{Null,0.01,Null,Null}
				];


				(*resolve method-dependent flat options*)
				autoFlatOptions = Which[
					suppliedMethod===DirectELISA&&suppliedCoating==True,
					{100Microliter,Null,Null,Null,Null,Null,100Microliter,Null},

					suppliedMethod===DirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,Null,100Microliter,Null},

					suppliedMethod===IndirectELISA&&suppliedCoating==True,
					{100Microliter,Null,Null,Null,Null,Null,100Microliter,100Microliter},

					suppliedMethod===IndirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,Null,100Microliter,100Microliter},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
					{Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,Null},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,100Microliter,100Microliter,Null},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
					{Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,100Microliter},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,100Microliter,100Microliter,100Microliter},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,100Microliter,Null,100Microliter,Null,Null,Null},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,Null},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,100Microliter,Null,100Microliter,Null,Null,100Microliter},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,100Microliter},

					suppliedMethod===FastELISA&&suppliedCoating==True,
					{Null,100Microliter,Null,Null,100Microliter,Null,Null,Null},

					suppliedMethod===FastELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,Null}
				];

				(* Depending on if the volume is specified, set dilution factor to the default value or Null to make sure only one of the two is not Null *)
				resolvedSingleStandardCoatingAntibodyDilutionFactor=If[NullQ[suppliedSingleStandardCoatingAntibodyVolume],
					elisaSetAuto[{suppliedSingleStandardCoatingAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[1]]}][[1]],
					elisaSetAuto[{suppliedSingleStandardCoatingAntibodyDilutionFactor}, {Null}][[1]]
				];

				resolvedSingleStandardCaptureAntibodyDilutionFactor=If[NullQ[suppliedSingleStandardCaptureAntibodyVolume],
					elisaSetAuto[{suppliedSingleStandardCaptureAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[2]]}][[1]],
					elisaSetAuto[{suppliedSingleStandardCaptureAntibodyDilutionFactor}, {Null}][[1]]
				];

				resolvedSingleStandardReferenceAntigenDilutionFactor=If[NullQ[suppliedSingleStandardReferenceAntigenVolume],
					elisaSetAuto[{suppliedSingleStandardReferenceAntigenDilutionFactor}, {autoFlatDilutionFactorOptions[[3]]}][[1]],
					elisaSetAuto[{suppliedSingleStandardReferenceAntigenDilutionFactor}, {Null}][[1]]
				];

				(* If StandardSecondaryAntibodyVolume is Null, we do not dilute it at all *)
				resolvedSingleStandardSecondaryAntibodyDilutionFactor=If[!NullQ[suppliedSingleStandardSecondaryAntibodyVolume],
					elisaSetAuto[{suppliedSingleStandardSecondaryAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[4]]}][[1]],
					elisaSetAuto[{suppliedSingleStandardSecondaryAntibodyDilutionFactor}, {Null}][[1]]
				];
				
				
				{
					resolvedSingleStandardCoatingVolume,
					resolvedSingleStandardCoatingAntibodyCoatingVolume,
					resolvedSingleStandardReferenceAntigenCoatingVolume,
					resolvedSingleStandardCaptureAntibodyCoatingVolume,
					resolvedSingleStandardAntibodyComplexImmunosorbentVolume,
					resolvedSingleStandardImmunosorbentVolume,
					resolvedSingleStandardPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleStandardSecondaryAntibodyImmunosorbentVolume
				}=elisaSetAuto[
					{
						suppliedSingleStandardCoatingVolume,
						suppliedSingleStandardCoatingAntibodyCoatingVolume,
						suppliedSingleStandardReferenceAntigenCoatingVolume,
						suppliedSingleStandardCaptureAntibodyCoatingVolume,
						suppliedSingleStandardAntibodyComplexImmunosorbentVolume,
						suppliedSingleStandardImmunosorbentVolume,
						suppliedSingleStandardPrimaryAntibodyImmunosorbentVolume,
						suppliedSingleStandardSecondaryAntibodyImmunosorbentVolume
					},autoFlatOptions
				];
				(*standrd primary antibodies.*)
				{resolvedSingleStandardPrimaryAntibodyDilutionFactor}=If[
					!NullQ[resolvedSingleStandardPrimaryAntibody]&&NullQ[suppliedSingleStandardPrimaryAntibodyVolume],
					If[MatchQ[suppliedMethod,Alternatives[DirectCompetitiveELISA,IndirectCompetitiveELISA,FastELISA]],
						(*When standard is mixed with samples*)
						elisaSetAuto[{suppliedSingleStandardPrimaryAntibodyDilutionFactor},{0.01}],
						(*When standard is diluted in diluents*)
						elisaSetAuto[{suppliedSingleStandardPrimaryAntibodyDilutionFactor},{0.001}]
					],
					elisaSetAuto[{suppliedSingleStandardPrimaryAntibodyDilutionFactor},{Null}]
				];

				(*Resolve StandardDilutionCurve options*)

				{resolvedSingleStandardSerialDilutionCurve,resolvedSingleStandardDilutionCurve}=If[MatchQ[suppliedMethod,DirectELISA|IndirectELISA] && suppliedCoating==False,
					{Null,Null},
					Switch[{suppliedSingleStandardSerialDilutionCurve,suppliedSingleStandardDilutionCurve},
						(* If neither is not Automatic, respect them *)
						{Except[Automatic],Except[Automatic]},{suppliedSingleStandardSerialDilutionCurve,suppliedSingleStandardDilutionCurve},

						(* If one is automatic and the other is not, set the Automatic one depending on the provided sample diluent value *)
						{Null,Automatic},
						{Null,Null},

						{Except[Automatic|Null],Automatic},
						{suppliedSingleStandardSerialDilutionCurve,Null},

						{Automatic,Null},
						{Null,Null},

						{Automatic,Except[Automatic|Null]},
						{Null,suppliedSingleStandardDilutionCurve},

						(* Both are automatic - Check if user wants dilution by giving diluent *)
						{Automatic,Automatic},
						If[MatchQ[suppliedStandardDiluent,Null],
							{Null,Null},
							{{100Microliter,{0.5,6}},Null}
						]
					]
				]

			]; (*END IF'*)

			{
				{
					resolvedSingleStandard,
					resolvedSingleStandardStorageCondition,
					resolvedSingleStandardTargetAntigen,
					resolvedSingleStandardCoatingAntibody,
					resolvedSingleStandardCoatingAntibodyDilutionFactor,
					resolvedSingleStandardCaptureAntibody,
					resolvedSingleStandardCaptureAntibodyDilutionFactor,
					resolvedSingleStandardReferenceAntigen,
					resolvedSingleStandardReferenceAntigenDilutionFactor,
					resolvedSingleStandardPrimaryAntibody,
					resolvedSingleStandardPrimaryAntibodyDilutionFactor,
					resolvedSingleStandardSecondaryAntibody,
					resolvedSingleStandardSecondaryAntibodyDilutionFactor,
					resolvedSingleStandardCoatingVolume,
					resolvedSingleStandardCoatingAntibodyCoatingVolume,
					resolvedSingleStandardReferenceAntigenCoatingVolume,
					resolvedSingleStandardCaptureAntibodyCoatingVolume,
					resolvedSingleStandardBlockingVolume,
					resolvedSingleStandardAntibodyComplexImmunosorbentVolume,
					resolvedSingleStandardImmunosorbentVolume,
					resolvedSingleStandardPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleStandardSecondaryAntibodyImmunosorbentVolume,
					resolvedSingleStandardSubstrateSolution,
					resolvedSingleStandardStopSolution,
					resolvedSingleStandardSubstrateSolutionVolume,
					resolvedSingleStandardStopSolutionVolume,
					resolvedSingleStandardDilutionCurve,
					resolvedSingleStandardSerialDilutionCurve
				},
				{
					unresolvableSingleStandard,
					unresolvableSingleStandardPrimaryAntibody,
					unresolvableSingleStandardSecondaryAntibody,
					unresolvableSingleStandardCaptureAntibody,
					unresolvableSingleStandardCoatingAntibody,
					unresolvableSingleStandardReferenceAntigen,
					unresolvableSingleStandardSubstrateSolution,
					unresolvableSingleStandardStopSolution,
					unresolvableSingleStandardSubstrateSolutionVolume,
					unresolvableSingleStandardStopSolutionVolume
				}
			}
		];

		(*======Use the function to MapThread out Standard Index-matched options=======*)
		standardIndexedOptionResolvedPool=
			Map[elisaResolveIndexMatchedStandardOptions[#]&,standardMapThreadFriends];

		(*Parse out the pool to get resolved options and unresolvable booleans*)
		{
			resolvedStandard,
			resolvedStandardStorageCondition,
			resolvedStandardTargetAntigen,
			resolvedStandardCoatingAntibody,
			resolvedStandardCoatingAntibodyDilutionFactor,
			resolvedStandardCaptureAntibody,
			resolvedStandardCaptureAntibodyDilutionFactor,
			resolvedStandardReferenceAntigen,
			resolvedStandardReferenceAntigenDilutionFactor,
			resolvedStandardPrimaryAntibody,
			resolvedStandardPrimaryAntibodyDilutionFactor,
			resolvedStandardSecondaryAntibody,
			resolvedStandardSecondaryAntibodyDilutionFactor,
			resolvedStandardCoatingVolume,
			resolvedStandardCoatingAntibodyCoatingVolume,
			resolvedStandardReferenceAntigenCoatingVolume,
			resolvedStandardCaptureAntibodyCoatingVolume,
			resolvedStandardBlockingVolume,
			resolvedStandardAntibodyComplexImmunosorbentVolume,
			resolvedStandardImmunosorbentVolume,
			resolvedStandardPrimaryAntibodyImmunosorbentVolume,
			resolvedStandardSecondaryAntibodyImmunosorbentVolume,
			resolvedStandardSubstrateSolution,
			resolvedStandardStopSolution,
			resolvedStandardSubstrateSolutionVolume,
			resolvedStandardStopSolutionVolume,
			resolvedStandardDilutionCurve,
			resolvedStandardSerialDilutionCurve
		}=standardIndexedOptionResolvedPool[[All,1]]//Transpose;

		{
			unresolvableStandardList,
			unresolvableStandardPrimaryAntibodyList,
			unresolvableStandardSecondaryAntibodyList,
			unresolvableStandardCaptureAntibodyList,
			unresolvableStandardCoatingAntibodyList,
			unresolvableStandardReferenceAntigenList,
			unresolvableStandardSubstrateSolutionList,
			unresolvableStandardStopSolutionList,
			unresolvableStandardSubstrateSolutionVolumeList,
			unresolvableStandardStopSolutionVolumeList
		}=standardIndexedOptionResolvedPool[[All,2]]//Transpose;

		(*We do not throw this warning if sample is coated*)
		If[MatchQ[resolvedStandard,ListableP[Null]]&&MatchQ[unresolvableStandardList,{False..}],Message[Warning::ELISANoStandardForExperiment]]
		(*END IF*)
	];

	(*We've got one more non-index-matched Standard option to resolve. Must be resolved after we know what the resolved Standards are*)
	resolvedStandardDiluent=If[
		Or[
			(* No Standard *)
			MatchQ[resolvedStandard,(Null|{Null..})],
			(* Both Standard serial dilution curves and dilution curves are all Null *)
			And[
				MatchQ[resolvedStandardSerialDilutionCurve,ListableP[Null]],
				MatchQ[resolvedStandardDilutionCurve,ListableP[Null]]
			]
		],
		Null,

		If[suppliedStandardDiluent=!=Automatic,
			suppliedStandardDiluent,
			Which[
				MatchQ[suppliedMethod,DirectELISA|IndirectELISA],defaultCoatingBuffer,

				MatchQ[suppliedMethod,DirectSandwichELISA|IndirectSandwichELISA],defaultBlockingBuffer,

				MatchQ[suppliedMethod,DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA],defaultBlockingBuffer
			]
		]
	];






	(*=======Resolve blank index matched options==========*)

	If[
		(*If method is DirectELISA or IndirectELISA and coating is false, then all samples were provided as SamplesIn (or ContainersIn transformed to samplesIn). There won't be any explicit blanks. All blank indexMAtched options will be {Null}*)
		MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)]&&MatchQ[suppliedCoating,False],
		{
			resolvedBlank,
			resolvedBlankStorageCondition,
			resolvedBlankTargetAntigen,
			resolvedBlankCoatingAntibody,
			resolvedBlankCoatingAntibodyDilutionFactor,
			resolvedBlankCaptureAntibody,
			resolvedBlankCaptureAntibodyDilutionFactor,
			resolvedBlankReferenceAntigen,
			resolvedBlankReferenceAntigenDilutionFactor,
			resolvedBlankPrimaryAntibody,
			resolvedBlankPrimaryAntibodyDilutionFactor,
			resolvedBlankSecondaryAntibody,
			resolvedBlankSecondaryAntibodyDilutionFactor,
			resolvedBlankCoatingVolume,
			resolvedBlankCoatingAntibodyCoatingVolume,
			resolvedBlankReferenceAntigenCoatingVolume,
			resolvedBlankCaptureAntibodyCoatingVolume,
			resolvedBlankBlockingVolume,
			resolvedBlankAntibodyComplexImmunosorbentVolume,
			resolvedBlankImmunosorbentVolume,
			resolvedBlankPrimaryAntibodyImmunosorbentVolume,
			resolvedBlankSecondaryAntibodyImmunosorbentVolume,
			resolvedBlankSubstrateSolution,
			resolvedBlankStopSolution,
			resolvedBlankSubstrateSolutionVolume,
			resolvedBlankStopSolutionVolume
			
		}=elisaSetAuto[
			{
				suppliedBlank,
				suppliedBlankStorageCondition,
				suppliedBlankTargetAntigen,
				suppliedBlankCoatingAntibody,
				suppliedBlankCoatingAntibodyDilutionFactor,
				suppliedBlankCaptureAntibody,
				suppliedBlankCaptureAntibodyDilutionFactor,
				suppliedBlankReferenceAntigen,
				suppliedBlankReferenceAntigenDilutionFactor,
				suppliedBlankPrimaryAntibody,
				suppliedBlankPrimaryAntibodyDilutionFactor,
				suppliedBlankSecondaryAntibody,
				suppliedBlankSecondaryAntibodyDilutionFactor,
				suppliedBlankCoatingVolume,
				suppliedBlankCoatingAntibodyCoatingVolume,
				suppliedBlankReferenceAntigenCoatingVolume,
				suppliedBlankCaptureAntibodyCoatingVolume,
				suppliedBlankBlockingVolume,
				suppliedBlankAntibodyComplexImmunosorbentVolume,
				suppliedBlankImmunosorbentVolume,
				suppliedBlankPrimaryAntibodyImmunosorbentVolume,
				suppliedBlankSecondaryAntibodyImmunosorbentVolume,
				suppliedBlankSubstrateSolution,
				suppliedBlankStopSolution,
				suppliedBlankSubstrateSolutionVolume,
				suppliedBlankStopSolutionVolume
			},
			ConstantArray[{Null},26]
		];

		{
			unresolvableBlankList,
			unresolvableBlankPrimaryAntibodyList,
			unresolvableBlankSecondaryAntibodyList,
			unresolvableBlankCaptureAntibodyList,
			unresolvableBlankCoatingAntibodyList,
			unresolvableBlankReferenceAntigenList,
			unresolvableBlankSubstrateSolutionList,
			unresolvableBlankStopSolutionList,
			unresolvableBlankSubstrateSolutionVolumeList,
			unresolvableBlankStopSolutionVolumeList}=
       ConstantArray[{False},10],

		(*BELOW IS A BIG ELSE: Resolve blank indexMatched options*)
		blankMapThreadFriends = elisaMakeMapThreadFriends[suppliedBlank,suppliedBlankChildrenValues,blankChildrenNames];
		elisaResolveIndexMatchedBlankOptions[singlePacket_]:=Module[{singleBlank,suppliedSingleBlankTargetAntigen,suppliedSingleBlankCoatingAntibody,suppliedSingleBlankCoatingAntibodyDilutionFactor,suppliedSingleBlankCoatingAntibodyVolume,suppliedSingleBlankCoatingAntibodyStorageCondition,suppliedSingleBlankCaptureAntibody,suppliedSingleBlankCaptureAntibodyDilutionFactor,suppliedSingleBlankCaptureAntibodyVolume,suppliedSingleBlankCaptureAntibodyStorageCondition,suppliedSingleBlankReferenceAntigen,suppliedSingleBlankReferenceAntigenDilutionFactor,suppliedSingleBlankReferenceAntigenVolume,suppliedSingleBlankReferenceAntigenStorageCondition,suppliedSingleBlankPrimaryAntibody,suppliedSingleBlankSecondaryAntibody,suppliedSingleBlankSecondaryAntibodyDilutionFactor,suppliedSingleBlankSecondaryAntibodyVolume,suppliedSingleBlankSecondaryAntibodyStorageCondition,suppliedSingleBlankCoatingVolume,suppliedSingleBlankCoatingAntibodyCoatingVolume,suppliedSingleBlankReferenceAntigenCoatingVolume,suppliedSingleBlankCaptureAntibodyCoatingVolume,suppliedSingleBlankBlockingVolume,suppliedSingleBlankAntibodyComplexImmunosorbentVolume,suppliedSingleBlankImmunosorbentVolume,suppliedSingleBlankPrimaryAntibodyImmunosorbentVolume,suppliedSingleBlankSecondaryAntibodyImmunosorbentVolume,suppliedSingleBlankSubstrateSolution,suppliedSingleBlankStopSolution,suppliedSingleBlankSubstrateSolutionVolume,suppliedSingleBlankStopSolutionVolume,resolvedSingleBlankTargetAntigen,resolvedSingleBlankCoatingAntibody,resolvedSingleBlankCoatingAntibodyDilutionFactor,resolvedSingleBlankCoatingAntibodyStorageCondition,resolvedSingleBlankCaptureAntibody,resolvedSingleBlankCaptureAntibodyDilutionFactor,resolvedSingleBlankCaptureAntibodyStorageCondition,resolvedSingleBlankReferenceAntigen,resolvedSingleBlankReferenceAntigenDilutionFactor,resolvedSingleBlankReferenceAntigenStorageCondition,resolvedSingleBlankPrimaryAntibody,resolvedSingleBlankSecondaryAntibody,resolvedSingleBlankSecondaryAntibodyDilutionFactor,resolvedSingleBlankSecondaryAntibodyStorageCondition,resolvedSingleBlankCoatingVolume,resolvedSingleBlankCoatingAntibodyCoatingVolume,resolvedSingleBlankReferenceAntigenCoatingVolume,resolvedSingleBlankCaptureAntibodyCoatingVolume,resolvedSingleBlankBlockingVolume,resolvedSingleBlankAntibodyComplexImmunosorbentVolume,resolvedSingleBlankImmunosorbentVolume,resolvedSingleBlankPrimaryAntibodyImmunosorbentVolume,resolvedSingleBlankSecondaryAntibodyImmunosorbentVolume,resolvedSingleBlankSubstrateSolution,resolvedSingleBlankStopSolution,resolvedSingleBlankSubstrateSolutionVolume,resolvedSingleBlankStopSolutionVolume,unresolvableSingleBlankPrimaryAntibody,unresolvableSingleBlankSecondaryAntibody,unresolvableSingleBlankCaptureAntibody,unresolvableSingleBlankCoatingAntibody,unresolvableSingleBlankReferenceAntigen,unresolvableSingleBlankSubstrateSolution,unresolvableSingleBlankStopSolution,unresolvableSingleBlankSubstrateSolutionVolume,unresolvableSingleBlankStopSolutionVolume,autoPrimaryAntibodyCandidates,primaryAntibodyCandidateConjugations,primaryAntibodyCandidateConjugationHRPAPQ,autoPrimaryAntibodyCandidatesNoConjugation,autoPrimaryAntibodyCandidatesNoConjugationSpecies,primaryAntibodySpecies,captureAntibodyCandidates,captureAntibodyCandidateConjugations,captureAntibodyCandidateConjugationHRPAPQ,captureAntibodyNoConjugation,coatingAntibodyCandidates,coatingAntibodyCandidateConjugations,suppliedSingleBlankPrimaryAntibodyDilutionFactor,suppliedSingleBlankPrimaryAntibodyVolume,suppliedSingleBlankPrimaryAntibodyStorageCondition,resolvedSingleBlankPrimaryAntibodyDilutionFactor,resolvedSingleBlankPrimaryAntibodyStorageCondition,resolvedSingleBlank,unresolvableSingleBlank,assayEnzyme,suppliedBlankSingleBlankChildValues,resolvedSingleBlankPrimaryAntibodyMolecule,resolvedSingleBlankSecondaryAntibodyMolecule,resolvedSingleBlankCaptureAntibodyMolecule,primaryAntibdySpecies,captureAntibodyNoConjSpeciesList,nonPrimaryAntibodySpecies,captureAntibodyCandidateAffinityTags,resolvedSingleBlankCoatingAntibodyMolecule,captureAntibodyAffinityLabel,allDetectionLabels,autoFlatDilutionFactorOptions,autoFlatOptions,autoSingleBlankSubstrateList,suppliedSingleBlankStorageCondition,resolvedSingleBlankStorageCondition,primaryAntibodyMolecule,reagentTransferFromSampleToBlank
		},

			(*Setup Error-tracking Booleans*)
			{
				unresolvableSingleBlank,
				unresolvableSingleBlankPrimaryAntibody,
				unresolvableSingleBlankSecondaryAntibody,
				unresolvableSingleBlankCaptureAntibody,
				unresolvableSingleBlankCoatingAntibody,
				unresolvableSingleBlankReferenceAntigen,
				unresolvableSingleBlankSubstrateSolution,
				unresolvableSingleBlankStopSolution,
				unresolvableSingleBlankSubstrateSolutionVolume,
				unresolvableSingleBlankStopSolutionVolume
			}=ConstantArray[False,10];
			(*Compare to Blanks and standards, blanks do not have dilution curve options*)
			{
				singleBlank,
				suppliedSingleBlankStorageCondition,
				suppliedSingleBlankTargetAntigen,
				suppliedSingleBlankCoatingAntibody,
				suppliedSingleBlankCoatingAntibodyDilutionFactor,
				suppliedSingleBlankCoatingAntibodyVolume,
				suppliedSingleBlankCaptureAntibody,
				suppliedSingleBlankCaptureAntibodyDilutionFactor,
				suppliedSingleBlankCaptureAntibodyVolume,
				suppliedSingleBlankReferenceAntigen,
				suppliedSingleBlankReferenceAntigenDilutionFactor,
				suppliedSingleBlankReferenceAntigenVolume,
				suppliedSingleBlankPrimaryAntibody,
				suppliedSingleBlankSecondaryAntibody,
				suppliedSingleBlankSecondaryAntibodyDilutionFactor,
				suppliedSingleBlankSecondaryAntibodyVolume,
				suppliedSingleBlankCoatingVolume,
				suppliedSingleBlankCoatingAntibodyCoatingVolume,
				suppliedSingleBlankReferenceAntigenCoatingVolume,
				suppliedSingleBlankCaptureAntibodyCoatingVolume,
				suppliedSingleBlankBlockingVolume,
				suppliedSingleBlankAntibodyComplexImmunosorbentVolume,
				suppliedSingleBlankImmunosorbentVolume,
				suppliedSingleBlankPrimaryAntibodyImmunosorbentVolume,
				suppliedSingleBlankSecondaryAntibodyImmunosorbentVolume,
				suppliedSingleBlankSubstrateSolution,
				suppliedSingleBlankStopSolution,
				suppliedSingleBlankSubstrateSolutionVolume,
				suppliedSingleBlankStopSolutionVolume,
				suppliedSingleBlankPrimaryAntibodyDilutionFactor,
				suppliedSingleBlankPrimaryAntibodyVolume

			}= Lookup[singlePacket,
				{
					"parent",
					BlankStorageCondition,
					BlankTargetAntigen,
					BlankCoatingAntibody,
					BlankCoatingAntibodyDilutionFactor,
					BlankCoatingAntibodyVolume,
					BlankCaptureAntibody,
					BlankCaptureAntibodyDilutionFactor,
					BlankCaptureAntibodyVolume,
					BlankReferenceAntigen,
					BlankReferenceAntigenDilutionFactor,
					BlankReferenceAntigenVolume,
					BlankPrimaryAntibody,
					BlankSecondaryAntibody,
					BlankSecondaryAntibodyDilutionFactor,
					BlankSecondaryAntibodyVolume,
					BlankCoatingVolume,
					BlankCoatingAntibodyCoatingVolume,
					BlankReferenceAntigenCoatingVolume,
					BlankCaptureAntibodyCoatingVolume,
					BlankBlockingVolume,
					BlankAntibodyComplexImmunosorbentVolume,
					BlankImmunosorbentVolume,
					BlankPrimaryAntibodyImmunosorbentVolume,
					BlankSecondaryAntibodyImmunosorbentVolume,
					BlankSubstrateSolution,
					BlankStopSolution,
					BlankSubstrateSolutionVolume,
					BlankStopSolutionVolume,
					BlankPrimaryAntibodyDilutionFactor,
					BlankPrimaryAntibodyVolume

				}];




			(*resolve Blank*)
			suppliedBlankSingleBlankChildValues={
				suppliedSingleBlankStorageCondition,
				suppliedSingleBlankTargetAntigen,
				suppliedSingleBlankCoatingAntibody,
				suppliedSingleBlankCoatingAntibodyDilutionFactor,
				suppliedSingleBlankCaptureAntibody,
				suppliedSingleBlankCaptureAntibodyDilutionFactor,
				suppliedSingleBlankReferenceAntigen,
				suppliedSingleBlankReferenceAntigenDilutionFactor,
				suppliedSingleBlankPrimaryAntibody,
				suppliedSingleBlankSecondaryAntibody,
				suppliedSingleBlankSecondaryAntibodyDilutionFactor,
				suppliedSingleBlankCoatingVolume,
				suppliedSingleBlankCoatingAntibodyCoatingVolume,
				suppliedSingleBlankReferenceAntigenCoatingVolume,
				suppliedSingleBlankCaptureAntibodyCoatingVolume,
				suppliedSingleBlankBlockingVolume,
				suppliedSingleBlankAntibodyComplexImmunosorbentVolume,
				suppliedSingleBlankImmunosorbentVolume,
				suppliedSingleBlankPrimaryAntibodyImmunosorbentVolume,
				suppliedSingleBlankSecondaryAntibodyImmunosorbentVolume,
				suppliedSingleBlankSubstrateSolution,
				suppliedSingleBlankStopSolution,
				suppliedSingleBlankSubstrateSolutionVolume,
				suppliedSingleBlankStopSolutionVolume,
				suppliedSingleBlankPrimaryAntibodyDilutionFactor

			};
			resolvedSingleBlank=If[
				!MatchQ[singleBlank,Automatic],
				resolvedSingleBlank = singleBlank,

				If[MatchQ[suppliedBlankSingleBlankChildValues,{Null..}],Null,
					If[
						MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)],
						defaultCoatingBuffer,
						defaultBlockingBuffer
					]
				] (*Unlike standard, blank is always resolvable.*)
			];


			If[resolvedSingleBlank===Null,
				{
					resolvedSingleBlankStorageCondition,
					resolvedSingleBlankTargetAntigen,
					resolvedSingleBlankCoatingAntibody,
					resolvedSingleBlankCoatingAntibodyDilutionFactor,
					resolvedSingleBlankCaptureAntibody,
					resolvedSingleBlankCaptureAntibodyDilutionFactor,
					resolvedSingleBlankReferenceAntigen,
					resolvedSingleBlankReferenceAntigenDilutionFactor,
					resolvedSingleBlankPrimaryAntibody,
					resolvedSingleBlankSecondaryAntibody,
					resolvedSingleBlankSecondaryAntibodyDilutionFactor,
					resolvedSingleBlankCoatingVolume,
					resolvedSingleBlankCoatingAntibodyCoatingVolume,
					resolvedSingleBlankReferenceAntigenCoatingVolume,
					resolvedSingleBlankCaptureAntibodyCoatingVolume,
					resolvedSingleBlankBlockingVolume,
					resolvedSingleBlankAntibodyComplexImmunosorbentVolume,
					resolvedSingleBlankImmunosorbentVolume,
					resolvedSingleBlankPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleBlankSecondaryAntibodyImmunosorbentVolume,
					resolvedSingleBlankSubstrateSolution,
					resolvedSingleBlankStopSolution,
					resolvedSingleBlankSubstrateSolutionVolume,
					resolvedSingleBlankStopSolutionVolume,
					resolvedSingleBlankPrimaryAntibodyDilutionFactor
				}=elisaSetAuto[
					{
						suppliedSingleBlankStorageCondition,
						suppliedSingleBlankTargetAntigen,
						suppliedSingleBlankCoatingAntibody,
						suppliedSingleBlankCoatingAntibodyDilutionFactor,
						suppliedSingleBlankCaptureAntibody,
						suppliedSingleBlankCaptureAntibodyDilutionFactor,
						suppliedSingleBlankReferenceAntigen,
						suppliedSingleBlankReferenceAntigenDilutionFactor,
						suppliedSingleBlankPrimaryAntibody,
						suppliedSingleBlankSecondaryAntibody,
						suppliedSingleBlankSecondaryAntibodyDilutionFactor,
						suppliedSingleBlankCoatingVolume,
						suppliedSingleBlankCoatingAntibodyCoatingVolume,
						suppliedSingleBlankReferenceAntigenCoatingVolume,
						suppliedSingleBlankCaptureAntibodyCoatingVolume,
						suppliedSingleBlankBlockingVolume,
						suppliedSingleBlankAntibodyComplexImmunosorbentVolume,
						suppliedSingleBlankImmunosorbentVolume,
						suppliedSingleBlankPrimaryAntibodyImmunosorbentVolume,
						suppliedSingleBlankSecondaryAntibodyImmunosorbentVolume,
						suppliedSingleBlankSubstrateSolution,
						suppliedSingleBlankStopSolution,
						suppliedSingleBlankSubstrateSolutionVolume,
						suppliedSingleBlankStopSolutionVolume,
						suppliedSingleBlankPrimaryAntibodyDilutionFactor
					}, ConstantArray[Null,25]],

				(*-------------The following is scenario is a big ELSE: when Blank is not Null.--------------*)

				(*resolve StandardStorageCondition*)
				resolvedSingleBlankStorageCondition=elisaSetAuto[{suppliedSingleBlankStorageCondition},{Refrigerator}][[1]];

				(*Resolve Blocking Volume*)
				resolvedSingleBlankBlockingVolume = If[suppliedBlocking,
					elisaSetAuto[{suppliedSingleBlankBlockingVolume},{100 Microliter}],
					elisaSetAuto[{suppliedSingleBlankBlockingVolume},{Null}]
				][[1]];

				(*Resolve TargetAntigen*)

				resolvedSingleBlankTargetAntigen = If[suppliedSingleBlankTargetAntigen=!=Automatic,
					suppliedSingleBlankTargetAntigen,

					FirstCase[{
						elisaGetPacketValue[elisaGetPacketValue[suppliedSingleBlankPrimaryAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
						elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleBlankPrimaryAntibody,Model,1,simulatedCache],Analytes,1,simulatedCache],Targets,1,simulatedCache],
						elisaGetPacketValue[elisaGetPacketValue[suppliedSingleBlankCaptureAntibody,Analytes,1,simulatedCache],Targets,1,simulatedCache],
						elisaGetPacketValue[elisaGetPacketValue[elisaGetPacketValue[suppliedSingleBlankCaptureAntibody,Model,1,simulatedCache],Analytes,1,simulatedCache],Targets,1,simulatedCache],
						resolvedTargetAntigen//FirstOrDefault (*Take the first target antigen from sample*)
					},ObjectP[Model[Molecule]],Null]
				];


				(* Lookup all the reagents based on TargetAntigen matching between blank and sample*)
				reagentTransferFromSampleToBlank=Lookup[sampleTargetAntigenToReagentLookupTable,resolvedSingleBlankTargetAntigen,defaultLookup];

				(*resolve primary antibody*)

				resolvedSingleBlankPrimaryAntibody=If[!MatchQ[suppliedSingleBlankPrimaryAntibody,Automatic],
					suppliedSingleBlankPrimaryAntibody,
					reagentTransferFromSampleToBlank[[1]]

				];

				(*We don't need to discuss the situation where no blank is needed and primary antibody being Null, as this is under that big ELSE above.*)
				If[MatchQ[resolvedSingleBlankPrimaryAntibody,Null],unresolvableSingleBlankPrimaryAntibody=True];


				(*Resolve Secondary Antibody*)
				resolvedSingleBlankSecondaryAntibody=If[!MatchQ[suppliedSingleBlankSecondaryAntibody,Automatic],
					suppliedSingleBlankSecondaryAntibody,
					reagentTransferFromSampleToBlank[[2]]
				];
				If[MatchQ[{suppliedMethod,resolvedSingleBlankSecondaryAntibody},{(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA),Null}],unresolvableSingleBlankSecondaryAntibody=True];



				(*Resolve Capture Antibody*)
				resolvedSingleBlankCaptureAntibody=If[!MatchQ[suppliedSingleBlankCaptureAntibody,Automatic],
					suppliedSingleBlankCaptureAntibody,
					reagentTransferFromSampleToBlank[[3]]
				];
				If[(MatchQ[{suppliedMethod,resolvedSingleBlankCaptureAntibody},{FastELISA,Null}]||MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleBlankCaptureAntibody},{(DirectSandwichELISA|IndirectSandwichELISA),True,Null}]),
					unresolvableSingleBlankCaptureAntibody=True];


				(*Resolve Coating Antibody*)
				resolvedSingleBlankCoatingAntibody=If[!MatchQ[suppliedSingleBlankCoatingAntibody,Automatic],
					suppliedSingleBlankCoatingAntibody,
					reagentTransferFromSampleToBlank[[4]]
				];
				If[MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleBlankCoatingAntibody},{FastELISA,True,Null}],
					unresolvableSingleBlankCoatingAntibody=True];



				(*Resolve ReferenceAntigen*)
				resolvedSingleBlankReferenceAntigen=If[!MatchQ[suppliedSingleBlankReferenceAntigen,Automatic],
					suppliedSingleBlankReferenceAntigen,
					reagentTransferFromSampleToBlank[[5]]
				];
				If[MatchQ[{suppliedMethod,suppliedCoating,resolvedSingleBlankReferenceAntigen},{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True,Null}],
					unresolvableSingleBlankReferenceAntigen=True];


				(*Resolve SubstrateSolutionVolume, SubstrateSolutionVolume*)
				(*Get conjugation for the PrimaryAntibodies in Direct methods, and SecondaryAntibody in Indirect methods.*)
				resolvedSingleBlankSubstrateSolution=If[!MatchQ[suppliedSingleBlankSubstrateSolution,Automatic],
					suppliedSingleBlankSubstrateSolution,
					reagentTransferFromSampleToBlank[[6]]
				];
				resolvedSingleBlankStopSolution=If[!MatchQ[suppliedSingleBlankStopSolution,Automatic],
					suppliedSingleBlankStopSolution,
					reagentTransferFromSampleToBlank[[7]]
				];

				resolvedSingleBlankSubstrateSolutionVolume=If[MatchQ[resolvedSingleBlankSubstrateSolution,ObjectP[]],
					If[MatchQ[suppliedSingleBlankSubstrateSolutionVolume,Automatic], 100Microliter,suppliedSingleBlankSubstrateSolutionVolume],
					Null
				];
				resolvedSingleBlankStopSolutionVolume=If[MatchQ[resolvedSingleBlankStopSolution,ObjectP[]],
					If[MatchQ[suppliedSingleBlankStopSolutionVolume,Automatic], 100Microliter,suppliedSingleBlankStopSolutionVolume],
					Null
				];

				If[MatchQ[suppliedSingleBlankSubstrateSolution,Automatic]&&(!MatchQ[resolvedSingleBlankSubstrateSolution,ObjectP[]]),
					unresolvableSingleBlankSubstrateSolution=True;
					unresolvableSingleBlankSubstrateSolutionVolume=True
				];
				If[MatchQ[suppliedSingleBlankStopSolution,Automatic]&&MatchQ[resolvedSingleBlankStopSolution,Except[ObjectP[]]]&&MatchQ[reagentTransferFromSampleToBlank[[7]],Except[Null]],
					unresolvableSingleBlankStopSolution=True;
					unresolvableSingleBlankStopSolutionVolume=True
				];

				(*resolve method-dependent flat options. The logic of dilution factor is more complicated because we need to see if the volume is provided, list them separately*)
				autoFlatDilutionFactorOptions = Which[
					suppliedMethod===DirectELISA&&suppliedCoating==True,
					{Null,Null,Null,Null},

					suppliedMethod===DirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectELISA&&suppliedCoating==True,
					{Null,Null,Null,0.001},

					suppliedMethod===IndirectELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
					{Null,0.001,Null,Null},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
					{Null,0.001,Null,0.001},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,0.001,Null},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,0.001,0.001},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,0.001},

					suppliedMethod===FastELISA&&suppliedCoating==True,
					{0.001,0.01,Null,Null},

					suppliedMethod===FastELISA&&suppliedCoating==False,
					{Null,0.01,Null,Null}
				];

				autoFlatOptions = Which[
					suppliedMethod===DirectELISA&&suppliedCoating==True,
					{100Microliter,Null,Null,Null,Null,Null,100Microliter,Null},

					suppliedMethod===DirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,Null,100Microliter,Null},

					suppliedMethod===IndirectELISA&&suppliedCoating==True,
					{100Microliter,Null,Null,Null,Null,Null,100Microliter,100Microliter},

					suppliedMethod===IndirectELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,Null,100Microliter,100Microliter},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==True,
					{Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,Null},

					suppliedMethod===DirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,100Microliter,100Microliter,Null},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==True,
					{Null,Null,Null,100Microliter,Null,100Microliter,100Microliter,100Microliter},

					suppliedMethod===IndirectSandwichELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,Null,100Microliter,100Microliter,100Microliter},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,100Microliter,Null,100Microliter,Null,Null,Null},

					suppliedMethod===DirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,Null},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==True,
					{Null,Null,100Microliter,Null,100Microliter,Null,Null,100Microliter},

					suppliedMethod===IndirectCompetitiveELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,100Microliter},

					suppliedMethod===FastELISA&&suppliedCoating==True,
					{Null,100Microliter,Null,Null,100Microliter,Null,Null,Null},

					suppliedMethod===FastELISA&&suppliedCoating==False,
					{Null,Null,Null,Null,100Microliter,Null,Null,Null}
				];

				(* Depending on if the volume is specified, set dilution factor to the default value or Null to make sure only one of the two is not Null *)
				resolvedSingleBlankCoatingAntibodyDilutionFactor=If[NullQ[suppliedSingleBlankCoatingAntibodyVolume],
					elisaSetAuto[{suppliedSingleBlankCoatingAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[1]]}][[1]],
					elisaSetAuto[{suppliedSingleBlankCoatingAntibodyDilutionFactor}, {Null}][[1]]
				];

				resolvedSingleBlankCaptureAntibodyDilutionFactor=If[NullQ[suppliedSingleBlankCaptureAntibodyVolume],
					elisaSetAuto[{suppliedSingleBlankCaptureAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[2]]}][[1]],
					elisaSetAuto[{suppliedSingleBlankCaptureAntibodyDilutionFactor}, {Null}][[1]]
				];

				resolvedSingleBlankReferenceAntigenDilutionFactor=If[NullQ[suppliedSingleBlankReferenceAntigenVolume],
					elisaSetAuto[{suppliedSingleBlankReferenceAntigenDilutionFactor}, {autoFlatDilutionFactorOptions[[3]]}][[1]],
					elisaSetAuto[{suppliedSingleBlankReferenceAntigenDilutionFactor}, {Null}][[1]]
				];

				resolvedSingleBlankSecondaryAntibodyDilutionFactor=If[!NullQ[suppliedSingleBlankSecondaryAntibodyVolume],
					elisaSetAuto[{suppliedSingleBlankSecondaryAntibodyDilutionFactor}, {autoFlatDilutionFactorOptions[[4]]}][[1]],
					elisaSetAuto[{suppliedSingleBlankSecondaryAntibodyDilutionFactor}, {Null}][[1]]
				];


				{
					resolvedSingleBlankCoatingVolume,
					resolvedSingleBlankCoatingAntibodyCoatingVolume,
					resolvedSingleBlankReferenceAntigenCoatingVolume,
					resolvedSingleBlankCaptureAntibodyCoatingVolume,
					resolvedSingleBlankAntibodyComplexImmunosorbentVolume,
					resolvedSingleBlankImmunosorbentVolume,
					resolvedSingleBlankPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleBlankSecondaryAntibodyImmunosorbentVolume
				}=elisaSetAuto[
					{
						suppliedSingleBlankCoatingVolume,
						suppliedSingleBlankCoatingAntibodyCoatingVolume,
						suppliedSingleBlankReferenceAntigenCoatingVolume,
						suppliedSingleBlankCaptureAntibodyCoatingVolume,
						suppliedSingleBlankAntibodyComplexImmunosorbentVolume,
						suppliedSingleBlankImmunosorbentVolume,
						suppliedSingleBlankPrimaryAntibodyImmunosorbentVolume,
						suppliedSingleBlankSecondaryAntibodyImmunosorbentVolume},autoFlatOptions

				];

				(*blank primary antibodies.*)
				{resolvedSingleBlankPrimaryAntibodyDilutionFactor}=If[
					!NullQ[resolvedSingleBlankPrimaryAntibody]&&NullQ[suppliedSingleBlankPrimaryAntibodyVolume],
					If[MatchQ[suppliedMethod,Alternatives[DirectCompetitiveELISA,IndirectCompetitiveELISA,FastELISA]],
						(*When blank is mixed with samples*)
						elisaSetAuto[{suppliedSingleBlankPrimaryAntibodyDilutionFactor},{0.01}],
						(*When blank is diluted in diluents*)
						elisaSetAuto[{suppliedSingleBlankPrimaryAntibodyDilutionFactor},{0.001}]
					],
					elisaSetAuto[{suppliedSingleBlankPrimaryAntibodyDilutionFactor},{Null}]
				]

			];(*END IF'*)


			{
				{
					resolvedSingleBlank,
					resolvedSingleBlankStorageCondition,
					resolvedSingleBlankTargetAntigen,
					resolvedSingleBlankCoatingAntibody,
					resolvedSingleBlankCoatingAntibodyDilutionFactor,
					resolvedSingleBlankCaptureAntibody,
					resolvedSingleBlankCaptureAntibodyDilutionFactor,
					resolvedSingleBlankReferenceAntigen,
					resolvedSingleBlankReferenceAntigenDilutionFactor,
					resolvedSingleBlankPrimaryAntibody,
					resolvedSingleBlankPrimaryAntibodyDilutionFactor,
					resolvedSingleBlankSecondaryAntibody,
					resolvedSingleBlankSecondaryAntibodyDilutionFactor,
					resolvedSingleBlankCoatingVolume,
					resolvedSingleBlankCoatingAntibodyCoatingVolume,
					resolvedSingleBlankReferenceAntigenCoatingVolume,
					resolvedSingleBlankCaptureAntibodyCoatingVolume,
					resolvedSingleBlankBlockingVolume,
					resolvedSingleBlankAntibodyComplexImmunosorbentVolume,
					resolvedSingleBlankImmunosorbentVolume,
					resolvedSingleBlankPrimaryAntibodyImmunosorbentVolume,
					resolvedSingleBlankSecondaryAntibodyImmunosorbentVolume,
					resolvedSingleBlankSubstrateSolution,
					resolvedSingleBlankStopSolution,
					resolvedSingleBlankSubstrateSolutionVolume,
					resolvedSingleBlankStopSolutionVolume
				},
				{
					unresolvableSingleBlank,
					unresolvableSingleBlankPrimaryAntibody,
					unresolvableSingleBlankSecondaryAntibody,
					unresolvableSingleBlankCaptureAntibody,
					unresolvableSingleBlankCoatingAntibody,
					unresolvableSingleBlankReferenceAntigen,
					unresolvableSingleBlankSubstrateSolution,
					unresolvableSingleBlankStopSolution,
					unresolvableSingleBlankSubstrateSolutionVolume,
					unresolvableSingleBlankStopSolutionVolume
				}
			}

		];

		(*=======Use the function to MapThread out sample Index-matched options=======*)

		blankIndexedOptionResolvedPool=
			Map[elisaResolveIndexMatchedBlankOptions[#]&,blankMapThreadFriends];


		(*Parse out the pool to get resolved options and unresolvable booleans*)
		{
			resolvedBlank,
			resolvedBlankStorageCondition,
			resolvedBlankTargetAntigen,
			resolvedBlankCoatingAntibody,
			resolvedBlankCoatingAntibodyDilutionFactor,
			resolvedBlankCaptureAntibody,
			resolvedBlankCaptureAntibodyDilutionFactor,
			resolvedBlankReferenceAntigen,
			resolvedBlankReferenceAntigenDilutionFactor,
			resolvedBlankPrimaryAntibody,
			resolvedBlankPrimaryAntibodyDilutionFactor,
			resolvedBlankSecondaryAntibody,
			resolvedBlankSecondaryAntibodyDilutionFactor,
			resolvedBlankCoatingVolume,
			resolvedBlankCoatingAntibodyCoatingVolume,
			resolvedBlankReferenceAntigenCoatingVolume,
			resolvedBlankCaptureAntibodyCoatingVolume,
			resolvedBlankBlockingVolume,
			resolvedBlankAntibodyComplexImmunosorbentVolume,
			resolvedBlankImmunosorbentVolume,
			resolvedBlankPrimaryAntibodyImmunosorbentVolume,
			resolvedBlankSecondaryAntibodyImmunosorbentVolume,
			resolvedBlankSubstrateSolution,
			resolvedBlankStopSolution,
			resolvedBlankSubstrateSolutionVolume,
			resolvedBlankStopSolutionVolume
		}=blankIndexedOptionResolvedPool[[All,1]]//Transpose;

		{
			unresolvableBlankList,
			unresolvableBlankPrimaryAntibodyList,
			unresolvableBlankSecondaryAntibodyList,
			unresolvableBlankCaptureAntibodyList,
			unresolvableBlankCoatingAntibodyList,
			unresolvableBlankReferenceAntigenList,
			unresolvableBlankSubstrateSolutionList,
			unresolvableBlankStopSolutionList,
			unresolvableBlankSubstrateSolutionVolumeList,
			unresolvableBlankStopSolutionVolumeList
		}=blankIndexedOptionResolvedPool[[All,2]]//Transpose;

		If[MatchQ[resolvedBlank,Null|{Null..}],Message[Warning::ELISANoBlankForExperiment]];
	]; (*END IF*)


	(*Conflict check: *)
	(*Checking if Standard and Blank reagents are a sub-list of Sample reagents. We are checking here because this is when all the options are map-thread friendly and we have that convenient sampleReagentTable*)

	(*If any of the reagent options is unresolvable, don't even bother checking-- the extra error messages is only going to confuse users.*)
	unresolvableStandardBlankReagentsQ=Or@@Flatten[{
		unresolvableStandardList,
		unresolvableStandardPrimaryAntibodyList,
		unresolvableStandardSecondaryAntibodyList,
		unresolvableStandardCaptureAntibodyList,
		unresolvableStandardCoatingAntibodyList,
		unresolvableStandardReferenceAntigenList,
		unresolvableStandardSubstrateSolutionList,
		unresolvableStandardStopSolutionList,
		unresolvableBlankList,
		unresolvableBlankPrimaryAntibodyList,
		unresolvableBlankSecondaryAntibodyList,
		unresolvableBlankCaptureAntibodyList,
		unresolvableBlankCoatingAntibodyList,
		unresolvableBlankReferenceAntigenList,
		unresolvableBlankSubstrateSolutionList,
		unresolvableBlankStopSolutionList}];



	
	(*If any of the reagent options is unresolvable, don't even bother checking-- the extra error messages is only going to confuse users anyways.*)

	(*Reference list from sample: doubled for standard and blank*)
	sampleReagenObjectedDoubled={resolvedPrimaryAntibody,resolvedSecondaryAntibody,resolvedCaptureAntibody,resolvedCoatingAntibody,resolvedReferenceAntigen,resolvedSubstrateSolution,resolvedStopSolution,resolvedPrimaryAntibody,resolvedSecondaryAntibody,resolvedCaptureAntibody,resolvedCoatingAntibody,resolvedReferenceAntigen,resolvedSubstrateSolution,resolvedStopSolution}/.x:ObjectP[]:>Download[x,Object];
	(*Standard/Blank list--get rid of links and Nulls*)
	standardBlankReagentObjected={resolvedStandardPrimaryAntibody,resolvedStandardSecondaryAntibody,resolvedStandardCaptureAntibody,resolvedStandardCoatingAntibody,resolvedStandardReferenceAntigen,resolvedStandardSubstrateSolution,resolvedStandardStopSolution,resolvedBlankPrimaryAntibody,resolvedBlankSecondaryAntibody,resolvedBlankCaptureAntibody,resolvedBlankCoatingAntibody,resolvedBlankReferenceAntigen,resolvedBlankSubstrateSolution,resolvedBlankStopSolution}/.{x:ObjectP[]:>Download[x,Object],Null->Nothing};
	(*Name list*)
	reagentTableOptionNames={StandardPrimaryAntibody,StandardSecondaryAntibody,StandardCaptureAntibody,StandardCoatingAntibody,StandardReferenceAntigen,StandardSubstrateSolution,StandardStopSolution,BlankPrimaryAntibody,BlankSecondaryAntibody,BlankCaptureAntibody,BlankCoatingAntibody,BlankReferenceAntigen,BlankSubstrateSolution,BlankStopSolution};

	standardBlankReagentSampleSublistConflictingOptions=If[unresolvableStandardBlankReagentsQ,{},

		MapThread[
			If[SubsetQ[#1,#2],Nothing,#3]&,
			{sampleReagenObjectedDoubled,standardBlankReagentObjected,reagentTableOptionNames},
			1
		]
	];

	If[Length[standardBlankReagentSampleSublistConflictingOptions]>0&&messages,
		Message[Error::StandardOrBlankReagentsNotForSample,
			ToString[standardBlankReagentSampleSublistConflictingOptions]
		]
	];

	standardBlankReagentSampleSublistConflictingTests= If[gatherTests,
		Test["Standard and Blank reagents must be a sublist of sample reagents",
			True,
			Length[standardBlankReagentSampleSublistConflictingOptions]===0
		]
	];

	(*Conflict check: same sample shall not have different storage conditions. We are including Standard and spike here as they may clash with ReferenceAntigen*)

	reagentsObjected={resolvedPrimaryAntibody,resolvedSecondaryAntibody,resolvedCaptureAntibody,resolvedCoatingAntibody,resolvedReferenceAntigen,resolvedStandard,resolvedBlank,suppliedSpike}/.x:ObjectP[]:>Download[x,Object];
	reagentsObjectedFlattened=reagentsObjected//Flatten;
	reagentsStorageConditionFlattened=Flatten[{suppliedPrimaryAntibodyStorageCondition,resolvedSecondaryAntibodyStorageCondition,resolvedCaptureAntibodyStorageCondition,resolvedCoatingAntibodyStorageCondition,resolvedReferenceAntigenStorageCondition,resolvedStandardStorageCondition,resolvedBlankStorageCondition,resolvedSpikeStorageCondition}];
	reagentStoragePairsDeDup=Transpose[{reagentsObjectedFlattened,reagentsStorageConditionFlattened}]//DeleteDuplicates;
	(*After DeDup the {Object,StorageCondition} pairs, extract the Objets. At this point, if non of the same objects have the same storage conditions, this reagent list should be duplication free*)
	reagentsDeDupped=Transpose[reagentStoragePairsDeDup][[1]];

	(*Count number of occurance with Tally, Sort by counts, delete the ones counted 1.*)
	objectTally=DeleteCases[Tally[reagentsDeDupped],{_,1}];
	(*Take the actual objects beding counted and flatten. There will be a bunch of Nulls so delete anything that are not ObjectP[]*)
	sampleStorageConflictingObjects=DeleteCases[objectTally[[All,1]]//Flatten,Except[ObjectP[]]];
	sampleStorageConflictingOptionsBoolean=Map[IntersectingQ[#,sampleStorageConflictingObjects]&,reagentsObjected,1];
	sampleStorageConflictingOptions=PickList[{PrimaryAntibody,SecondaryAntibody,CaptureAntibody,CoatingAntibody,ReferenceAntigen,Standard,Blank,Spike},sampleStorageConflictingOptionsBoolean,True];

	If[Length[sampleStorageConflictingOptions]>0&&messages,
		Message[Error::SameSampleDifferentSorage,
			ObjectToString[sampleStorageConflictingObjects,Simulation->updatedSimulation],
			ObjectToString[sampleStorageConflictingOptions,Simulation->updatedSimulation]
		]
	];

	sampleStorageConflictingTests= If[gatherTests,
		Test["Same sample objects given in the options should alway have the same storage conditions",
			True,
			Length[sampleStorageConflictingOptions]===0
		]
	];
	
	
	(*Conflict check: Model[Sample] and Object[Sample] of the same model must not coexist*)

	allReagents=Join[reagentsObjected,standardBlankReagentObjected];
	allReagentsOptionNames={PrimaryAntibody,SecondaryAntibody,CaptureAntibody,CoatingAntibody,ReferenceAntigen,Standard,Blank,Spike,StandardPrimaryAntibody,StandardSecondaryAntibody,StandardCaptureAntibody,StandardCoatingAntibody,StandardReferenceAntigen,StandardSubstrateSolution,StandardStopSolution,BlankPrimaryAntibody,BlankSecondaryAntibody,BlankCaptureAntibody,BlankCoatingAntibody,BlankReferenceAntigen,BlankSubstrateSolution,BlankStopSolution};

	(*Helper function to inspect one option to see of Object[Sample] and its correspondent Model[Sample] coexist*)
	findModelObjectDuplicates[objectList_List]:=Module[
		{objectSampleList,objectSampleModelList,modelSampleList,conflictingObjects,conflictingOptions},
		(*Pick out Object[Sample] in the list*)
		objectSampleList=Cases[objectList,ObjectP[Object[Sample]]];
		(*Get their Model[Sample]. Delete Null's in case some obejct[sample] somehow do not hvae models*)
		objectSampleModelList=DeleteCases[elisaGetPacketValue[#,Model,1,simulatedCache]&/@objectSampleList,Null];
		(*Pick out*)
		modelSampleList=Cases[objectList,ObjectP[Model[Sample]]];

		conflictingObjects=If[MemberQ[modelSampleList,#],#,Nothing]&/@objectSampleModelList
	];

	ojbectModelMutualExclusiveConflictingObjects=Map[findModelObjectDuplicates,allReagents,1];
	objectModelMutualExclusiveConflictingOptions=PickList[allReagentsOptionNames,ojbectModelMutualExclusiveConflictingObjects,{ObjectP[]..}];
	

	If[Length[objectModelMutualExclusiveConflictingOptions]>0&&messages,
		Message[Error::ObjectAndCorrespondingModelMustNotCoexist,
			ObjectToString[DeleteCases[objectModelMutualExclusiveConflictingOptions,{}]],
			ObjectToString[objectModelMutualExclusiveConflictingOptions]
		]
	];

	ojbectModelMutualExclusiveConflictingTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[objectModelMutualExclusiveConflictingOptions]==0,
				Nothing,
				Test["Object[Sample] and it's corresponding Model[Sample] are not specified in the same options "<>ToString[objectModelMutualExclusiveConflictingOptions]<>":",True,False]
			];
			passingTest=If[Length[objectModelMutualExclusiveConflictingOptions]==Length[mySamples],
				Nothing,
				Test["Object[Sample] and it's corresponding Model[Sample] are not specified in the same options "<>ToString[Complement[allReagentsOptionNames,objectModelMutualExclusiveConflictingOptions]]<>":",True,True]
			];
			{failingTest,passingTest}
		],
		{}
	];
	

	(* Conflict check ELISA plate wells. Only consider the scenario where dilution curve options have passed conflict checks*)

	(*The singleDilutionCurveTransformation works on a single dilution curve index-mapped to a single sample, Map should happen on the second level.*)
	{transformedStandardDilutionCurve,transformedStandardSerialDilutionCurve,transformedSampleDilutionCurve,transformedSampleSerialDilutionCurve} =
		Map[singleDilutionCurveTransformation, {resolvedStandardDilutionCurve,resolvedStandardSerialDilutionCurve,resolvedSampleDilutionCurve,resolvedSampleSerialDilutionCurve}, {2}];

	(*These are for internal calculations*)
	{roundedTransformedStandardDilutionCurve,roundedTransformedStandardSerialDilutionCurve,roundedTransformedSampleDilutionCurve,roundedTransformedSampleSerialDilutionCurve} =
		Map[RoundOptionPrecision[#,10^-1Microliter]&, {transformedStandardDilutionCurve,transformedStandardSerialDilutionCurve,transformedSampleDilutionCurve,transformedSampleSerialDilutionCurve}, {3}];

	(* Total Volume Check*)
	(*Each DilutionCurve entry total volume should not be larger than 2ml*)
	(*Because roundedSampleSerialDilutionCurve is already transformed into {{{Vtransfer,Vdiluent}..}..} format. The total volume in each dilution is Vtransfer+Vdilutnet. If the dilution is Null or Automatic, then False (not an invalid option), else, if total volume is larger than 20000Microliter, then True.*)
	totalVolume[vtvd_]:=If[MatchQ[vtvd,Null|Automatic],False,Plus@@vtvd>1900Microliter];

	sampleSerialDilutionCurveOverflowBoolean=(Or@@#&)/@Map[totalVolume, transformedSampleSerialDilutionCurve,{2}];
	sampleDilutionCurveOverflowBoolean=(Or@@#&)/@Map[totalVolume, transformedSampleDilutionCurve,{2}];
	standardSerialDilutionCurveOverflowBoolean=(Or@@#&)/@Map[totalVolume, transformedStandardSerialDilutionCurve,{2}];
	standardDilutionCurveOverflowBoolean=(Or@@#&)/@Map[totalVolume, transformedStandardDilutionCurve,{2}];

	serialDilutionCurveOverflowSamples=Pick[mySamples, sampleSerialDilutionCurveOverflowBoolean];
	dilutionCurveOverflowSamples=Pick[mySamples, sampleDilutionCurveOverflowBoolean];
	serialDilutionCurveOverflowStandards=Pick[suppliedStandard, standardSerialDilutionCurveOverflowBoolean];
	dilutionCurveOverflowStandards=Pick[suppliedStandard, standardDilutionCurveOverflowBoolean];

	sampleSerialDilutionCurveOverflowQ=MemberQ[sampleSerialDilutionCurveOverflowBoolean,True];
	sampleDilutionCurveOverflowQ=MemberQ[sampleDilutionCurveOverflowBoolean,True];
	standardSerialDilutionCurveOverflowQ=MemberQ[standardSerialDilutionCurveOverflowBoolean,True];
	standardDilutionCurveOverflowQ=MemberQ[standardDilutionCurveOverflowBoolean,True];

	If[messages&&Or[sampleSerialDilutionCurveOverflowQ,sampleDilutionCurveOverflowQ,standardSerialDilutionCurveOverflowQ,standardDilutionCurveOverflowQ],
		Message[Error::DilutionCurveOptionsTotalVolumeTooLarge,
			ObjectToString[serialDilutionCurveOverflowSamples,Simulation->updatedSimulation],
			ObjectToString[dilutionCurveOverflowSamples,Simulation->updatedSimulation],
			ObjectToString[serialDilutionCurveOverflowStandards,Simulation->updatedSimulation],
			ObjectToString[dilutionCurveOverflowStandards,Simulation->updatedSimulation]
		]
	];

	dilutionCurveOverflowOptions=Pick[{SampleSerialDilutionCurve,SampleDilutionCurve,StandardSerialDilutionCurve,StandardDilutionCurve},{sampleSerialDilutionCurveOverflowQ,sampleDilutionCurveOverflowQ,standardSerialDilutionCurveOverflowQ,standardDilutionCurveOverflowQ}];

	dilutionCurveContainedOptions=Pick[{SampleSerialDilutionCurve,SampleDilutionCurve,StandardSerialDilutionCurve,StandardDilutionCurve},{sampleSerialDilutionCurveOverflowQ,sampleDilutionCurveOverflowQ,standardSerialDilutionCurveOverflowQ,standardDilutionCurveOverflowQ},False];

	DilutionCurveOptionsTotalVolumeTests=If[gatherTests,
		Module[{passingTest,failingTest},
			passingTest=If[Length[dilutionCurveContainedOptions]=!=0,
				Test["The total volume for each dilution in "<>StringTake[ToString[dilutionCurveContainedOptions],{2,-2}]<>" must be smaller than 2ml:",True,True]];
			failingTest=If[Length[dilutionCurveOverflowOptions]=!=0,
				Test["The total volume for each dilution in "<>StringTake[ToString[dilutionCurveOverflowOptions],{2,-2}]<>" must be smaller than 2ml:",True,False]];
			{passingTest,failingTest}],
		Nothing
	];


	(*Combine SampleDilutionCurve option and SampleSerialDilutionCurveOption. Go with DilutionCurve if there is a conflict*)
	combinedSampleDilutionCurve = MapThread[Which[
		MatchQ[#1,Except[Null|{}|Automatic]], #1,
		MatchQ[#2,Except[Null|{}|Automatic]], #2,
		True, {{Null}}
	]&, {roundedTransformedSampleDilutionCurve,roundedTransformedSampleSerialDilutionCurve}];

	(* Go with DilutionCurve if there is a conflict*)
	combinedStandardDilutionCurve = MapThread[Which[
		MatchQ[#1,Except[Null|{}|Automatic]], #1,
		MatchQ[#2,Except[Null|{}|Automatic]], #2,
		True, {{Null}}
	]&, {roundedTransformedStandardDilutionCurve,roundedTransformedStandardSerialDilutionCurve}];

	(*For next step: calculate how many dilution is conducted on each sample/standard.*)
	sampleCurveExpansionParams=Map[Length,combinedSampleDilutionCurve,1];
	standardCurveExpansionParams=If[MatchQ[resolvedStandard,Null|{Null..}|{}],{},Map[Length,combinedStandardDilutionCurve,1]];
	joinedCurveExpansionParams=Join[sampleCurveExpansionParams,standardCurveExpansionParams,If[MatchQ[resolvedBlank,Null|{Null..}|{}],{},ConstantArray[1,Length[resolvedBlank]]]];

	(*------Check if antibody, antigen, spike, sample dilutions require pipetting sub-1ul liquid-----*)
	

	emptyStandardQ=MatchQ[resolvedStandard,({Null..}|Null|{})];
	emptyBlankQ=MatchQ[resolvedBlank,({Null..}|Null|{})];
	joinedSamples=DeleteCases[Join[simulatedSamples,ToList[resolvedStandard],ToList[resolvedBlank]],(Null|{Null..}|{})]; (*DeleteCases is to deal with the situation where standards and/or samples are {Null}*)
	curveExpandedJoinedSamples=Flatten[MapThread[ConstantArray[#1,#2]&,{joinedSamples,joinedCurveExpansionParams}],1];
	(*number of samples, antibodies, and blanks, before expanded by dilution curves and number of replicates*)
	numberOfSamples=Length[joinedSamples];
	numberOfCurveExpandedSamples=Length[curveExpandedJoinedSamples];


	(*Primary antibody*)
	(*Because Primary antibody is alwaay present no matter what, PrimaryAntibodyDilutionFactor is not an automatic option.*)
	samplePrimaryAntibodyDilutionFactors=resolvedPrimaryAntibodyDilutionFactor;
	samplePrimaryAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
		resolvedPrimaryAntibodyImmunosorbentVolume,
		resolvedSampleAntibodyComplexImmunosorbentVolume
	];
	samplePrimaryAntibodyVolumes=suppliedPrimaryAntibodyVolume;
	samplePrimaryAntibodies=resolvedPrimaryAntibody;

	{standardPrimaryAntibodyDilutionFactors,standardPrimaryAntibodyAssayVolumes,standardPrimaryAntibodyVolumes,standardPrimaryAntibodies}=
		If[emptyStandardQ,
			{{},{},{},{}},

			Module[{primaryAntibodyDilutionFactors,primaryAntibodyAssayVolumes,primaryAntibodyVolumes,primaryAntibodies},
				primaryAntibodyDilutionFactors=resolvedStandardPrimaryAntibodyDilutionFactor;
				primaryAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
					resolvedStandardPrimaryAntibodyImmunosorbentVolume,
					resolvedStandardAntibodyComplexImmunosorbentVolume
				];
				primaryAntibodyVolumes=suppliedStandardPrimaryAntibodyVolume;
				primaryAntibodies=resolvedStandardPrimaryAntibody;

				{primaryAntibodyDilutionFactors,primaryAntibodyAssayVolumes,primaryAntibodyVolumes,primaryAntibodies}
			]

		];
	{blankPrimaryAntibodyDilutionFactors,blankPrimaryAntibodyAssayVolumes,blankPrimaryAntibodyVolumes,blankPrimaryAntibodies}=
		If[emptyBlankQ,
			{{},{},{},{}},

			Module[{primaryAntibodyDilutionFactors,primaryAntibodyAssayVolumes,primaryAntibodyVolumes,primaryAntibodies},
				primaryAntibodyDilutionFactors=resolvedBlankPrimaryAntibodyDilutionFactor;
				primaryAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
					resolvedBlankPrimaryAntibodyImmunosorbentVolume,
					resolvedBlankAntibodyComplexImmunosorbentVolume
				];
				primaryAntibodyVolumes=suppliedBlankPrimaryAntibodyVolume;
				primaryAntibodies=resolvedBlankPrimaryAntibody;

				{primaryAntibodyDilutionFactors,primaryAntibodyAssayVolumes,primaryAntibodyVolumes,primaryAntibodies}
			]
		];

	{joinedPrimaryAntibodyDilutionFactors,joinedPrimaryAntibodyAssayVolumes,joinedPrimaryAntibodyVolumes,joinedPrimaryAntibodies}=
		Map[(Join@@#&),{
			{samplePrimaryAntibodyDilutionFactors,standardPrimaryAntibodyDilutionFactors,blankPrimaryAntibodyDilutionFactors},
			{samplePrimaryAntibodyAssayVolumes,standardPrimaryAntibodyAssayVolumes,blankPrimaryAntibodyAssayVolumes},
			{samplePrimaryAntibodyVolumes,standardPrimaryAntibodyVolumes,blankPrimaryAntibodyVolumes},
			{samplePrimaryAntibodies,standardPrimaryAntibodies,blankPrimaryAntibodies}
		},1];

	combinedPrimaryAntibodyVolumes=(*For PrimaryAntibodyImmunosorbentVolume: this is the list to be picked*)
		MapThread[If[!MatchQ[#1,Null],#1*#2,#3]&, {joinedPrimaryAntibodyDilutionFactors,joinedPrimaryAntibodyAssayVolumes,joinedPrimaryAntibodyVolumes}];
	combinedPrimaryAntibodyFactors=
		MapThread[If[!MatchQ[#1,Null],#1,#3/#2]&, {joinedPrimaryAntibodyDilutionFactors,joinedPrimaryAntibodyAssayVolumes,joinedPrimaryAntibodyVolumes}];
	combinedPrimaryAntibodyWithFactors=(*For PrimaryAntibodyImmunosorbentVolume:this is picklist map*)
		MapThread[{#1,#2}&, {joinedPrimaryAntibodies,combinedPrimaryAntibodyFactors}];

	{
		curveExpandedJoinedPrimaryAntibodyDilutionFactors,
		curveExpandedJoinedPrimaryAntibodyAssayVolumes,
		curveExpandedJoinedPrimaryAntibodyVolumes,
		curveExpandedJoinedPrimaryAntibodies,
		curveExpandedCombinedPrimaryAntibodyVolumes,
		curveExpandedCombinedPrimaryAntibodyFactors,
		curveExpandedCombinedPrimaryAntibodyWithFactors
	}={
		Flatten[MapThread[ConstantArray[#1,#2]&,{joinedPrimaryAntibodyDilutionFactors,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{joinedPrimaryAntibodyAssayVolumes,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{joinedPrimaryAntibodyVolumes,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{joinedPrimaryAntibodies,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{combinedPrimaryAntibodyVolumes,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{combinedPrimaryAntibodyFactors,joinedCurveExpansionParams}],1],
		Flatten[MapThread[ConstantArray[#1,#2]&,{combinedPrimaryAntibodyWithFactors,joinedCurveExpansionParams}],1]

	};


	If[
		MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
		(*PrimaryAntibodyImmunosorbentVolume:thesea are picklist keys--Map through them*)
		combinedPrimaryAntibodyWithFactorsDeDuplications=combinedPrimaryAntibodyWithFactors//DeleteDuplicates;
		(*Pick the Volumes with the same antibodies and dilution rates, add them up and times number of replicates.Because diluent is not indexmatched option, there's no problems with diluent being different in each dilution.*)
		totalPrimaryAntibodyVolumes=Map[
			Plus@@PickList[curveExpandedCombinedPrimaryAntibodyVolumes,curveExpandedCombinedPrimaryAntibodyWithFactors,#]&,
			combinedPrimaryAntibodyWithFactorsDeDuplications,{1}
		]*resolvedNumberOfReplicatesNullToOne*pipettingError;(*A 10% margin of error for pipetting is added here*)
		insufficientPrimaryAntibodyVolumes=Cases[totalPrimaryAntibodyVolumes,_?(# < 1 Microliter &)];

		If[Length[insufficientPrimaryAntibodyVolumes]>0,

			primaryAntibodyErrorIdentifier=PickList[combinedPrimaryAntibodyWithFactorsDeDuplications,totalPrimaryAntibodyVolumes,_?(# <1 Microliter &)];
			primaryAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientPrimaryAntibodyVolumes;
			afterDilutionPrimaryAntibodyVolumes=MapThread[#1*#2&,{insufficientPrimaryAntibodyVolumes,primaryAntibodyIntermediateDilutionRates}];
			primaryAntibodyPipettingConflictOptions={PrimaryAntibodyVolume,PrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyDilutionFactor},
			(*ELSE*)
			primaryAntibodyPipettingConflictOptions={}

		],

		(*ELSE: for the rest of ELISA methods, primary antibody is directly diluted into samples, therefore even if the same antibodies have the same dilution rate, their dilutions cannot be combined.*)
		(*totalPrimaryAntibodyVolumes do not account for replicates either since I'm planning on preparing them separately. These volumes are indexmatched to individual samples, not unique antibodies.*)
		totalPrimaryAntibodyVolumes=curveExpandedCombinedPrimaryAntibodyVolumes*pipettingError; (*A 10% margin of error for pipetting is added here*)
		insufficientPrimaryAntibodyVolumes=Cases[totalPrimaryAntibodyVolumes,_?(# < 1 Microliter &)];
		
		If[Length[insufficientPrimaryAntibodyVolumes]>0,
			primaryAntibodyErrorIdentifier=PickList[curveExpandedJoinedSamples,totalPrimaryAntibodyVolumes,_?(# <1 Microliter &)];
			primaryAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientPrimaryAntibodyVolumes;
			afterDilutionPrimaryAntibodyVolumes=MapThread[#1*#2&,{insufficientPrimaryAntibodyVolumes,primaryAntibodyIntermediateDilutionRates}];
			primaryAntibodyPipettingConflictOptions={PrimaryAntibodyVolume,PrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume,StandardPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume,BlankPrimaryAntibodyDilutionFactor},
			(*ELSE*)
			primaryAntibodyPipettingConflictOptions={}
		]
	];
	If[messages&&Length[primaryAntibodyPipettingConflictOptions]>0,
		Message[Error::PrimaryAntibodyPipettingVolumeTooLow,
			ObjectToString[primaryAntibodyErrorIdentifier,Simulation->updatedSimulation](*,
					ToString[primaryAntibodyIntermediateDilutionRates],
					ToString[afterDilutionPrimaryAntibodyVolumes]*)
		]
	];
	primaryAntibodySufficientPipettingVolumesTest=If[gatherTests,
		Test["PrimaryAntibody dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,Length[primaryAntibodyPipettingConflictOptions]===0
		],{}
	];
	

	(*Secondary antibody*)
	(*Secondary antibody only participate in immunosorbent step and  they are not altered by immunosorbent.*)
	If[MatchQ[suppliedMethod, Alternatives[IndirectELISA, IndirectSandwichELISA, IndirectCompetitiveELISA]],
		Module[
			{
				sampleSecondaryAntibodyDilutionFactors, sampleSecondaryAntibodyAssayVolumes, sampleSecondaryAntibodies,
				standardSecondaryAntibodyDilutionFactors, standardSecondaryAntibodyAssayVolumes, standardSecondaryAntibodyVolumes,
				standardSecondaryAntibodies, blankSecondaryAntibodyDilutionFactors, blankSecondaryAntibodyAssayVolumes,
				blankSecondaryAntibodyVolumes, blankSecondaryAntibodies
			},

			sampleSecondaryAntibodyDilutionFactors = resolvedSecondaryAntibodyDilutionFactor;
			sampleSecondaryAntibodyAssayVolumes = resolvedSecondaryAntibodyImmunosorbentVolume;
			(* We can prepare way more diluted SecondaryAntibody than required assay volume(immunosorbent volume), default to only prepare 10% more *)
			sampleSecondaryAntibodyVolumes = If[!MatchQ[suppliedSecondaryAntibodyVolume, ListableP[Automatic]],
				suppliedSecondaryAntibodyVolume,
				MapThread[
					If[MatchQ[#1, Except[Null | EqualP[1]]] && MatchQ[#2, VolumeP],
						SafeRound[pipettingError*#1*#2, 0.1 Microliter],
						Null
					]&,
					{sampleSecondaryAntibodyDilutionFactors, sampleSecondaryAntibodyAssayVolumes}
				]
			];
			sampleSecondaryAntibodies = resolvedSecondaryAntibody;

			resolvedStandardSecondaryAntibodyVolumes = If[!MatchQ[suppliedStandardSecondaryAntibodyVolume, ListableP[Automatic]],
				suppliedStandardSecondaryAntibodyVolume,
				MapThread[
					If[MatchQ[#1, Except[Null | EqualP[1]]] && MatchQ[#2, VolumeP],
						SafeRound[pipettingError*#1*#2, 0.1 Microliter],
						Null
					]&,
					{resolvedStandardSecondaryAntibodyDilutionFactor, resolvedStandardSecondaryAntibodyImmunosorbentVolume}
				]
			];
			resolvedBlankSecondaryAntibodyVolumes = If[!MatchQ[suppliedBlankSecondaryAntibodyVolume, ListableP[Automatic]],
				suppliedBlankSecondaryAntibodyVolume,
				MapThread[
					If[MatchQ[#1, Except[Null | EqualP[1]]] && MatchQ[#2, VolumeP],
						SafeRound[pipettingError*#1*#2, 0.1 Microliter],
						Null
					]&,
					{resolvedBlankSecondaryAntibodyDilutionFactor, resolvedBlankSecondaryAntibodyImmunosorbentVolume}
				]
			];

			{
				standardSecondaryAntibodyDilutionFactors,
				standardSecondaryAntibodyAssayVolumes,
				standardSecondaryAntibodyVolumes,
				standardSecondaryAntibodies
			}= If[emptyStandardQ,
				{{},{},{},{}},
				{
					resolvedStandardSecondaryAntibodyDilutionFactor,
					resolvedStandardSecondaryAntibodyImmunosorbentVolume,
					resolvedStandardSecondaryAntibodyVolumes,
					resolvedStandardSecondaryAntibody
				}
			];
			{
				blankSecondaryAntibodyDilutionFactors,
				blankSecondaryAntibodyAssayVolumes,
				blankSecondaryAntibodyVolumes,
				blankSecondaryAntibodies
			} = If[emptyBlankQ,
				{{},{},{},{}},
				{
					resolvedBlankSecondaryAntibodyDilutionFactor,
					resolvedBlankSecondaryAntibodyImmunosorbentVolume,
					resolvedBlankSecondaryAntibodyVolumes,
					resolvedBlankSecondaryAntibody
				}
			];

			(* Join the results in the order of sample, standard, blank *)
			{joinedSecondaryAntibodyDilutionFactors,joinedSecondaryAntibodyAssayVolumes,joinedSecondaryAntibodyVolumes,joinedSecondaryAntibodies}=
				Map[(Join@@#&),{
					{sampleSecondaryAntibodyDilutionFactors,standardSecondaryAntibodyDilutionFactors,blankSecondaryAntibodyDilutionFactors},
					{sampleSecondaryAntibodyAssayVolumes,standardSecondaryAntibodyAssayVolumes,blankSecondaryAntibodyAssayVolumes},
					{sampleSecondaryAntibodyVolumes,standardSecondaryAntibodyVolumes,blankSecondaryAntibodyVolumes},
					{sampleSecondaryAntibodies,standardSecondaryAntibodies,blankSecondaryAntibodies}
				},1];
			resolvedSecondaryAntibodyDilutionOnDeck = Which[
				(* Overwrite any user option when Coating is required. We resolve to SuperSTAR on feature branch for SecondaryAntibodyDilutionOnDeck but stable only has Nimbus. When coating, there won't be enough room to place all tubes and plates on NIMBUS. *)
				MatchQ[suppliedCoating, True],
					False,
				MatchQ[Lookup[allOptionsRoundedAssociation, SecondaryAntibodyDilutionOnDeck], Except[Automatic]],
					Lookup[allOptionsRoundedAssociation, SecondaryAntibodyDilutionOnDeck],
				MemberQ[joinedSecondaryAntibodyVolumes, VolumeP],
					False,
				True,
					Null
			];
			(* If there is no dilution, we require the assay volume amount of undiluted secondary antibody. Otherwise, requires SecondaryAntibodyVolume amount *)
			combinedSecondaryAntibodyVolumes = MapThread[
				If[MatchQ[#1, Null|EqualP[1]], #2, #3]&,
				{joinedSecondaryAntibodyDilutionFactors,joinedSecondaryAntibodyAssayVolumes,joinedSecondaryAntibodyVolumes}
			];
			combinedSecondaryAntibodyFactors = MapThread[
				If[!MatchQ[#1, Null], #1, 1]&,
				{joinedSecondaryAntibodyDilutionFactors,joinedSecondaryAntibodyAssayVolumes,joinedSecondaryAntibodyVolumes}
			];
			combinedSecondaryAntibodyWithFactors = MapThread[
				{#1, #2}&,
				{joinedSecondaryAntibodies,combinedSecondaryAntibodyFactors}
			];

			{
				curveExpandedJoinedSecondaryAntibodyDilutionFactors,
				curveExpandedJoinedSecondaryAntibodyAssayVolumes,
				curveExpandedJoinedSecondaryAntibodyVolumes,
				curveExpandedJoinedSecondaryAntibodies,
				curveExpandedCombinedSecondaryAntibodyVolumes,
				curveExpandedCombinedSecondaryAntibodyFactors,
				curveExpandedCombinedSecondaryAntibodyWithFactors
			}={
				Flatten[MapThread[ConstantArray[#1,#2]&,{joinedSecondaryAntibodyDilutionFactors,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{joinedSecondaryAntibodyAssayVolumes,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{joinedSecondaryAntibodyVolumes,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{joinedSecondaryAntibodies,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{combinedSecondaryAntibodyVolumes,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{combinedSecondaryAntibodyFactors,joinedCurveExpansionParams}],1],
				Flatten[MapThread[ConstantArray[#1,#2]&,{combinedSecondaryAntibodyWithFactors,joinedCurveExpansionParams}],1]

			};

			(*secondaryAntibodyImmunosorbentVolume:these are picklist keys--Map through them*)
			combinedSecondaryAntibodyWithFactorsDeDuplications=combinedSecondaryAntibodyWithFactors//DeleteDuplicates;
			(*Pick the Volumes with the same antibodies and dilution rates, add them up and times number of replicates.Because diluent is not indexmatched option, there's no problems with diluent being different in each dilution.*)
			totalSecondaryAntibodyVolumes=resolvedNumberOfReplicatesNullToOne*pipettingError*Map[
				Plus@@PickList[curveExpandedCombinedSecondaryAntibodyVolumes,curveExpandedCombinedSecondaryAntibodyWithFactors,#]&,
				combinedSecondaryAntibodyWithFactorsDeDuplications,{1}
			];(*A 10% margin of error for pipetting is added here*)
			insufficientSecondaryAntibodyVolumes=Cases[totalSecondaryAntibodyVolumes,_?(# <1 Microliter &)];
		],
		(*ELSE: secondary antibody is not used*)
		joinedSecondaryAntibodies=ConstantArray[Null,numberOfSamples];
		joinedSecondaryAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedSecondaryAntibodyVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedSecondaryAntibodyFactors=ConstantArray[0,numberOfSamples];
		combinedSecondaryAntibodyWithFactors=ConstantArray[{Null,0},numberOfSamples];
		curveExpandedJoinedSecondaryAntibodies=ConstantArray[Null,numberOfCurveExpandedSamples];
		curveExpandedJoinedSecondaryAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedSecondaryAntibodyVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedSecondaryAntibodyFactors=ConstantArray[0,numberOfCurveExpandedSamples];
		curveExpandedCombinedSecondaryAntibodyWithFactors=ConstantArray[{Null,0},numberOfCurveExpandedSamples];
		sampleSecondaryAntibodyVolumes=suppliedSecondaryAntibodyVolume/.Automatic->Null;
		resolvedStandardSecondaryAntibodyVolumes=suppliedStandardSecondaryAntibodyVolume/.Automatic->Null;
		resolvedBlankSecondaryAntibodyVolumes=suppliedBlankSecondaryAntibodyVolume/.Automatic->Null;
		resolvedSecondaryAntibodyDilutionOnDeck=Null;
		insufficientSecondaryAntibodyVolumes={}

	];
	If[
		Length[insufficientSecondaryAntibodyVolumes]>0,

		secondaryAntibodyErrorIdentifier=PickList[combinedSecondaryAntibodyWithFactorsDeDuplications,totalSecondaryAntibodyVolumes,_?(# <=1 Microliter &)];
		secondaryAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientSecondaryAntibodyVolumes;
		afterDilutionSecondaryAntibodyVolumes=MapThread[#1*#2&,{insufficientSecondaryAntibodyVolumes,secondaryAntibodyIntermediateDilutionRates}];
		secondaryAntibodyPipettingConflictOptions={SecondaryAntibodyVolume,SecondaryAntibodyDilutionFactor,StandardSecondaryAntibodyVolume,StandardSecondaryAntibodyDilutionFactor,BlankSecondaryAntibodyVolume,BlankSecondaryAntibodyDilutionFactor};
		If[messages,
			Message[Error::SecondaryAntibodyPipettingVolumeTooLow,
				ObjectToString[secondaryAntibodyErrorIdentifier,Simulation->updatedSimulation](*,
					ToString[secondaryAntibodyIntermediateDilutionRates],
					ToString[afterDilutionSecondaryAntibodyVolumes]*)
			]
		],
		secondaryAntibodyPipettingConflictOptions={}
	];
	secondaryAntibodySufficientPipettingVolumesTest=If[gatherTests,
		Test["SecondaryAntibody dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,Length[secondaryAntibodyPipettingConflictOptions]===0
		],{}
	];

	(*Coating antibody: used for coating when FastELISA and Coating===True. Not used at all in any other cases. This is similar to SecondaryAntibody*)
	If[MatchQ[suppliedMethod,FastELISA]&&MatchQ[suppliedCoating,True],
		
		sampleCoatingAntibodyDilutionFactors=resolvedCoatingAntibodyDilutionFactor;
		sampleCoatingAntibodyAssayVolumes=resolvedCoatingAntibodyCoatingVolume;
		sampleCoatingAntibodyVolumes=suppliedCoatingAntibodyVolume;
		sampleCoatingAntibodies=resolvedCoatingAntibody;

		{standardCoatingAntibodyDilutionFactors,standardCoatingAntibodyAssayVolumes,standardCoatingAntibodyVolumes,standardCoatingAntibodies}=
			If[emptyStandardQ,
				{{},{},{},{}},
				{resolvedStandardCoatingAntibodyDilutionFactor,resolvedStandardCoatingAntibodyCoatingVolume,suppliedStandardCoatingAntibodyVolume,resolvedStandardCoatingAntibody}
			];
		{blankCoatingAntibodyDilutionFactors,blankCoatingAntibodyAssayVolumes,blankCoatingAntibodyVolumes,blankCoatingAntibodies}=
			If[emptyBlankQ,
				{{},{},{},{}},
				{resolvedBlankCoatingAntibodyDilutionFactor,resolvedBlankCoatingAntibodyCoatingVolume,suppliedBlankCoatingAntibodyVolume,resolvedBlankCoatingAntibody}
			];


		{joinedCoatingAntibodyDilutionFactors,joinedCoatingAntibodyAssayVolumes,joinedCoatingAntibodyVolumes,joinedCoatingAntibodies}=
			Map[(Join@@#&),{
				{sampleCoatingAntibodyDilutionFactors,standardCoatingAntibodyDilutionFactors,blankCoatingAntibodyDilutionFactors},
				{sampleCoatingAntibodyAssayVolumes,standardCoatingAntibodyAssayVolumes,blankCoatingAntibodyAssayVolumes},
				{sampleCoatingAntibodyVolumes,standardCoatingAntibodyVolumes,blankCoatingAntibodyVolumes},
				{sampleCoatingAntibodies,standardCoatingAntibodies,blankCoatingAntibodies}
			},1];

		combinedCoatingAntibodyVolumes=(*For coatingAntibodyCoatingVolume: this is the list to be picked*)
			MapThread[If[!MatchQ[#1,Null],#1*#2,#3]&, {joinedCoatingAntibodyDilutionFactors,joinedCoatingAntibodyAssayVolumes,joinedCoatingAntibodyVolumes}];
		combinedCoatingAntibodyFactors=
			MapThread[If[!MatchQ[#1,Null],#1,#3/#2]&, {joinedCoatingAntibodyDilutionFactors,joinedCoatingAntibodyAssayVolumes,joinedCoatingAntibodyVolumes}];
		combinedCoatingAntibodyWithFactors=(*For coatingAntibodyCoatingVolume:this is picklist map*)
			MapThread[{#1,#2}&, {joinedCoatingAntibodies,combinedCoatingAntibodyFactors}];

		{
			curveExpandedJoinedCoatingAntibodyDilutionFactors,
			curveExpandedJoinedCoatingAntibodyAssayVolumes,
			curveExpandedJoinedCoatingAntibodyVolumes,
			curveExpandedJoinedCoatingAntibodies,
			curveExpandedCombinedCoatingAntibodyVolumes,
			curveExpandedCombinedCoatingAntibodyFactors,
			curveExpandedCombinedCoatingAntibodyWithFactors
		}={
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCoatingAntibodyDilutionFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCoatingAntibodyAssayVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCoatingAntibodyVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCoatingAntibodies,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCoatingAntibodyVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCoatingAntibodyFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCoatingAntibodyWithFactors,joinedCurveExpansionParams}],1]

		};


		(*coatingAntibodyCoatingVolume:thesea are picklist keys--Map through them*)
		combinedCoatingAntibodyWithFactorsDeDuplications=combinedCoatingAntibodyWithFactors//DeleteDuplicates;
		(*Pick the Volumes with the same antibodies and dilution rates, add them up and times number of replicates.Because diluent is not indexmatched option, there's no problems with diluent being different in each dilution.*)
		totalCoatingAntibodyVolumes=Map[
			Plus@@PickList[curveExpandedCombinedCoatingAntibodyVolumes,curveExpandedCombinedCoatingAntibodyWithFactors,#]&,
			combinedCoatingAntibodyWithFactorsDeDuplications,{1}
		]*resolvedNumberOfReplicatesNullToOne*pipettingError;  (*A 10% margin of error for pipetting is added here*)
		insufficientCoatingAntibodyVolumes=Cases[totalCoatingAntibodyVolumes,_?(# <1 Microliter &)],



		(*ELSE: coating antibody is not used*)
		insufficientCoatingAntibodyVolumes={};
		joinedCoatingAntibodies=ConstantArray[Null,numberOfSamples];
		joinedCoatingAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedCoatingAntibodyVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedCoatingAntibodyFactors=ConstantArray[0,numberOfSamples];
		combinedCoatingAntibodyWithFactors=ConstantArray[{Null,0},numberOfSamples];
		curveExpandedJoinedCoatingAntibodies=ConstantArray[Null,numberOfCurveExpandedSamples];
		curveExpandedJoinedCoatingAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedCoatingAntibodyVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedCoatingAntibodyFactors=ConstantArray[0,numberOfCurveExpandedSamples];
		curveExpandedCombinedCoatingAntibodyWithFactors=ConstantArray[{Null,0},numberOfCurveExpandedSamples];

	];
	If[
		Length[insufficientCoatingAntibodyVolumes]>0,

		coatingAntibodyErrorIdentifier=PickList[combinedCoatingAntibodyWithFactorsDeDuplications,totalCoatingAntibodyVolumes,_?(# <=1 Microliter &)];
		coatingAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientCoatingAntibodyVolumes;
		afterDilutionCoatingAntibodyVolumes=MapThread[#1*#2&,{insufficientCoatingAntibodyVolumes,coatingAntibodyIntermediateDilutionRates}];
		coatingAntibodyPipettingConflictOptions={CoatingAntibodyVolume,CoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume,StandardCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume,BlankCoatingAntibodyDilutionFactor};
		If[messages,
			Message[Error::CoatingAntibodyPipettingVolumeTooLow,
				ObjectToString[coatingAntibodyErrorIdentifier,Simulation->updatedSimulation](*,
					ToString[coatingAntibodyIntermediateDilutionRates],
					ToString[afterDilutionCoatingAntibodyVolumes]*)
			]
		],
		coatingAntibodyPipettingConflictOptions={}
	];
	coatingAntibodySufficientPipettingVolumesTest=If[gatherTests,
		Test["CoatingAntibody dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,Length[insufficientCoatingAntibodyVolumes]===0
		],{}
	];

	(*Capture antibody: a combination of primary antibody and coating antibody: mixed with samples, diluted with diluent  for coating or not used at all.*)
	If[(MatchQ[suppliedMethod,(DirectSandwichELISA|IndirectSandwichELISA)]&&MatchQ[suppliedCoating,True])||MatchQ[suppliedMethod,FastELISA],

		sampleCaptureAntibodyDilutionFactors=resolvedCaptureAntibodyDilutionFactor;
		sampleCaptureAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
			resolvedCaptureAntibodyCoatingVolume,
			resolvedSampleAntibodyComplexImmunosorbentVolume
		];
		sampleCaptureAntibodyVolumes=suppliedCaptureAntibodyVolume;
		sampleCaptureAntibodies=resolvedCaptureAntibody;

		{standardCaptureAntibodyDilutionFactors,standardCaptureAntibodyAssayVolumes,standardCaptureAntibodyVolumes,standardCaptureAntibodies}=
			If[emptyStandardQ,
				{{},{},{},{}},

				Module[{captureAntibodyDilutionFactors,captureAntibodyAssayVolumes,captureAntibodyVolumes,captureAntibodies},
					captureAntibodyDilutionFactors=resolvedStandardCaptureAntibodyDilutionFactor;
					captureAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
						resolvedStandardCaptureAntibodyCoatingVolume,
						resolvedStandardAntibodyComplexImmunosorbentVolume
					];
					captureAntibodyVolumes=suppliedStandardCaptureAntibodyVolume;
					captureAntibodies=resolvedStandardCaptureAntibody;

					{captureAntibodyDilutionFactors,captureAntibodyAssayVolumes,captureAntibodyVolumes,captureAntibodies}
				]

			];
		{blankCaptureAntibodyDilutionFactors,blankCaptureAntibodyAssayVolumes,blankCaptureAntibodyVolumes,blankCaptureAntibodies}=
			If[emptyBlankQ,
				{{},{},{},{}},

				Module[{captureAntibodyDilutionFactors,captureAntibodyAssayVolumes,captureAntibodyVolumes,captureAntibodies},
					captureAntibodyDilutionFactors=resolvedBlankCaptureAntibodyDilutionFactor;
					captureAntibodyAssayVolumes=If[MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA]],
						resolvedBlankCaptureAntibodyCoatingVolume,
						resolvedBlankAntibodyComplexImmunosorbentVolume
					];
					captureAntibodyVolumes=suppliedBlankCaptureAntibodyVolume;
					captureAntibodies=resolvedBlankCaptureAntibody;

					{captureAntibodyDilutionFactors,captureAntibodyAssayVolumes,captureAntibodyVolumes,captureAntibodies}
				]
			];

		{joinedCaptureAntibodyDilutionFactors,joinedCaptureAntibodyAssayVolumes,joinedCaptureAntibodyVolumes,joinedCaptureAntibodies}=
			Map[(Join@@#&),{
				{sampleCaptureAntibodyDilutionFactors,standardCaptureAntibodyDilutionFactors,blankCaptureAntibodyDilutionFactors},
				{sampleCaptureAntibodyAssayVolumes,standardCaptureAntibodyAssayVolumes,blankCaptureAntibodyAssayVolumes},
				{sampleCaptureAntibodyVolumes,standardCaptureAntibodyVolumes,blankCaptureAntibodyVolumes},
				{sampleCaptureAntibodies,standardCaptureAntibodies,blankCaptureAntibodies}
			},1];

		combinedCaptureAntibodyVolumes=(*For CaptureAntibodyCoatingVolume: this is the list to be picked*)
			MapThread[If[!MatchQ[#1,Null],#1*#2,#3]&, {joinedCaptureAntibodyDilutionFactors,joinedCaptureAntibodyAssayVolumes,joinedCaptureAntibodyVolumes}];
		combinedCaptureAntibodyFactors=
			MapThread[If[!MatchQ[#1,Null],#1,#3/#2]&, {joinedCaptureAntibodyDilutionFactors,joinedCaptureAntibodyAssayVolumes,joinedCaptureAntibodyVolumes}];
		combinedCaptureAntibodyWithFactors=(*For CaptureAntibodyCoatingVolume:this is picklist map*)
			MapThread[{#1,#2}&, {joinedCaptureAntibodies,combinedCaptureAntibodyFactors}];

		{
			curveExpandedJoinedCaptureAntibodyDilutionFactors,
			curveExpandedJoinedCaptureAntibodyAssayVolumes,
			curveExpandedJoinedCaptureAntibodyVolumes,
			curveExpandedJoinedCaptureAntibodies,
			curveExpandedCombinedCaptureAntibodyVolumes,
			curveExpandedCombinedCaptureAntibodyFactors,
			curveExpandedCombinedCaptureAntibodyWithFactors
		}={
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCaptureAntibodyDilutionFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCaptureAntibodyAssayVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCaptureAntibodyVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedCaptureAntibodies,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCaptureAntibodyVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCaptureAntibodyFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedCaptureAntibodyWithFactors,joinedCurveExpansionParams}],1]

		};

		(*This condition implies coating is true as it is a nested if.*)
		If[
			MatchQ[suppliedMethod,Alternatives[DirectSandwichELISA,IndirectSandwichELISA]],
			(*CaptureAntibodyCoatingVolume:thesea are picklist keys--Map through them*)
			combinedCaptureAntibodyWithFactorsDeDuplications=combinedCaptureAntibodyWithFactors//DeleteDuplicates;
			(*Pick the Volumes with the same antibodies and dilution rates, add them up and times number of replicates.Because diluent is not indexmatched option, there's no problems with diluent being different in each dilution.*)
			totalCaptureAntibodyVolumes=Map[
				Plus@@PickList[curveExpandedCombinedCaptureAntibodyVolumes,curveExpandedCombinedCaptureAntibodyWithFactors,#]&,
				combinedCaptureAntibodyWithFactorsDeDuplications,{1}
			]*resolvedNumberOfReplicatesNullToOne*pipettingError;(*A 10% margin of error for pipetting is added here*)
			insufficientCaptureAntibodyVolumes=Cases[totalCaptureAntibodyVolumes,_?(# < 1 Microliter &)];

			If[
				Length[insufficientCaptureAntibodyVolumes]>0,

				captureAntibodyErrorIdentifier=PickList[combinedCaptureAntibodyWithFactorsDeDuplications,totalCaptureAntibodyVolumes,_?(# <1 Microliter &)];
				captureAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientCaptureAntibodyVolumes;
				afterDilutionCaptureAntibodyVolumes=MapThread[#1*#2&,{insufficientCaptureAntibodyVolumes,captureAntibodyIntermediateDilutionRates}];
				captureAntibodyPipettingConflictOptions={CaptureAntibodyVolume,CaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume,StandardCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume,BlankCaptureAntibodyDilutionFactor},
				
				captureAntibodyPipettingConflictOptions={}
			],

			(*ELSE: for FastELISA, capture antibody is directly diluted into samples, therefore even if the same antibodies have the same dilution rate, their dilutions cannot be combined.*)
			totalCaptureAntibodyVolumes=curveExpandedCombinedCaptureAntibodyVolumes*pipettingError; (*A 10% margin of error for pipetting is added here*)
			insufficientCaptureAntibodyVolumes=Cases[totalCaptureAntibodyVolumes,_?(# <1 Microliter &)];

			If[
				Length[insufficientCaptureAntibodyVolumes]>0,

				captureAntibodyErrorIdentifier=PickList[curveExpandedJoinedSamples,totalCaptureAntibodyVolumes,_?(# <1 Microliter &)];
				captureAntibodyIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientCaptureAntibodyVolumes;
				afterDilutionCaptureAntibodyVolumes=MapThread[#1*#2&,{insufficientCaptureAntibodyVolumes,captureAntibodyIntermediateDilutionRates}];
				captureAntibodyPipettingConflictOptions={CaptureAntibodyVolume,CaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume,StandardCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume,BlankCaptureAntibodyDilutionFactor},
				
				captureAntibodyPipettingConflictOptions={}
			]
		],
		(*ELSE: when capture antibody is not used*)
		captureAntibodyPipettingConflictOptions={};
		joinedCaptureAntibodies=ConstantArray[Null,numberOfSamples];
		joinedCaptureAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedCaptureAntibodyVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedCaptureAntibodyFactors=ConstantArray[0,numberOfSamples];
		combinedCaptureAntibodyWithFactors=ConstantArray[{Null,0},numberOfSamples];
		curveExpandedJoinedCaptureAntibodies=ConstantArray[Null,numberOfCurveExpandedSamples];
		curveExpandedJoinedCaptureAntibodyAssayVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedCaptureAntibodyVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedCaptureAntibodyFactors=ConstantArray[0,numberOfCurveExpandedSamples];
		curveExpandedCombinedCaptureAntibodyWithFactors=ConstantArray[{Null,0},numberOfCurveExpandedSamples]
	];



	If[messages&&Length[captureAntibodyPipettingConflictOptions]>0,
		Message[Error::CaptureAntibodyPipettingVolumeTooLow,
			ObjectToString[captureAntibodyErrorIdentifier,Simulation->updatedSimulation](*,
						ToString[captureAntibodyIntermediateDilutionRates],
						ToString[afterDilutionCaptureAntibodyVolumes]*)
		]
	];
	captureAntibodySufficientPipettingVolumesTest=If[gatherTests,
		Test["CaptureAntibody dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,Length[captureAntibodyPipettingConflictOptions]===0
		],{}
	];

	(*Reference antigen: either used for coating or not used at all.*)
	If[MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)]&&MatchQ[suppliedCoating,True],
		
		sampleReferenceAntigenDilutionFactors=resolvedReferenceAntigenDilutionFactor;
		sampleReferenceAntigenAssayVolumes=resolvedReferenceAntigenCoatingVolume;
		sampleReferenceAntigenVolumes=suppliedReferenceAntigenVolume;
		sampleReferenceAntigens=resolvedReferenceAntigen;

		{standardReferenceAntigenDilutionFactors,standardReferenceAntigenAssayVolumes,standardReferenceAntigenVolumes,standardReferenceAntigens}=
			If[emptyStandardQ,
				{{},{},{},{}},
				{resolvedStandardReferenceAntigenDilutionFactor,resolvedStandardReferenceAntigenCoatingVolume,suppliedStandardReferenceAntigenVolume,resolvedStandardReferenceAntigen}
			];
		{blankReferenceAntigenDilutionFactors,blankReferenceAntigenAssayVolumes,blankReferenceAntigenVolumes,blankReferenceAntigens}=
			If[emptyBlankQ,
				{{},{},{},{}},
				{resolvedBlankReferenceAntigenDilutionFactor,resolvedBlankReferenceAntigenCoatingVolume,suppliedBlankReferenceAntigenVolume,resolvedBlankReferenceAntigen}
			];


		{joinedReferenceAntigenDilutionFactors,joinedReferenceAntigenAssayVolumes,joinedReferenceAntigenVolumes,joinedReferenceAntigens}=
			Map[(Join@@#&),{
				{sampleReferenceAntigenDilutionFactors,standardReferenceAntigenDilutionFactors,blankReferenceAntigenDilutionFactors},
				{sampleReferenceAntigenAssayVolumes,standardReferenceAntigenAssayVolumes,blankReferenceAntigenAssayVolumes},
				{sampleReferenceAntigenVolumes,standardReferenceAntigenVolumes,blankReferenceAntigenVolumes},
				{sampleReferenceAntigens,standardReferenceAntigens,blankReferenceAntigens}
			},1];

		combinedReferenceAntigenVolumes=(*For referenceAntigenCoatingVolume: this is the list to be picked*)
			MapThread[If[!MatchQ[#1,Null],#1*#2,#3]&, {joinedReferenceAntigenDilutionFactors,joinedReferenceAntigenAssayVolumes,joinedReferenceAntigenVolumes}];
		combinedReferenceAntigenFactors=
			MapThread[If[!MatchQ[#1,Null],#1,#3/#2]&, {joinedReferenceAntigenDilutionFactors,joinedReferenceAntigenAssayVolumes,joinedReferenceAntigenVolumes}];
		combinedReferenceAntigenWithFactors=(*For referenceAntigenCoatingVolume:this is picklist map*)
			MapThread[{#1,#2}&, {joinedReferenceAntigens,combinedReferenceAntigenFactors}];

		{
			curveExpandedJoinedReferenceAntigenDilutionFactors,
			curveExpandedJoinedReferenceAntigenAssayVolumes,
			curveExpandedJoinedReferenceAntigenVolumes,
			curveExpandedJoinedReferenceAntigens,
			curveExpandedCombinedReferenceAntigenVolumes,
			curveExpandedCombinedReferenceAntigenFactors,
			curveExpandedCombinedReferenceAntigenWithFactors
		}={
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedReferenceAntigenDilutionFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedReferenceAntigenAssayVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedReferenceAntigenVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{joinedReferenceAntigens,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedReferenceAntigenVolumes,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedReferenceAntigenFactors,joinedCurveExpansionParams}],1],
			Flatten[MapThread[ConstantArray[#1,#2]&,{combinedReferenceAntigenWithFactors,joinedCurveExpansionParams}],1]

		};

		(*referenceAntigenCoatingVolume:these are picklist keys--Map through them*)
		combinedReferenceAntigenWithFactorsDeDuplications=combinedReferenceAntigenWithFactors//DeleteDuplicates;
		(*Pick the Volumes with the same antibodies and dilution rates, add them up and times number of replicates.Because diluent is not indexmatched option, there's no problems with diluent being different in each dilution.*)
		totalReferenceAntigenVolumes=Map[
			Plus@@PickList[curveExpandedCombinedReferenceAntigenVolumes,curveExpandedCombinedReferenceAntigenWithFactors,#]&,
			combinedReferenceAntigenWithFactorsDeDuplications,{1}
		]*resolvedNumberOfReplicatesNullToOne*pipettingError;(*A 10% margin of error for pipetting is added here*)
		insufficientReferenceAntigenVolumes=Cases[totalReferenceAntigenVolumes,_?(# <1 Microliter &)],


		(*ELSE: reference antigen is not used*)

		insufficientReferenceAntigenVolumes={};
		joinedReferenceAntigens=ConstantArray[Null,numberOfSamples];
		joinedReferenceAntigenAssayVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedReferenceAntigenVolumes=ConstantArray[0Microliter,numberOfSamples];
		combinedReferenceAntigenFactors=ConstantArray[0,numberOfSamples];
		combinedReferenceAntigenWithFactors=ConstantArray[{Null,0},numberOfSamples];
		curveExpandedJoinedReferenceAntigens=ConstantArray[Null,numberOfCurveExpandedSamples];
		curveExpandedJoinedReferenceAntigenAssayVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedReferenceAntigenVolumes=ConstantArray[0Microliter,numberOfCurveExpandedSamples];
		curveExpandedCombinedReferenceAntigenFactors=ConstantArray[0,numberOfCurveExpandedSamples];
		curveExpandedCombinedReferenceAntigenWithFactors=ConstantArray[{Null,0},numberOfCurveExpandedSamples];
	];
	If[
		Length[insufficientReferenceAntigenVolumes]>0,

		referenceAntigenErrorIdentifier=PickList[combinedReferenceAntigenWithFactorsDeDuplications,totalReferenceAntigenVolumes,_?(# <=1 Microliter &)];
		referenceAntigenIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientReferenceAntigenVolumes;
		afterDilutionReferenceAntigenVolumes=MapThread[#1*#2&,{insufficientReferenceAntigenVolumes,referenceAntigenIntermediateDilutionRates}];
		referenceAntigenPipettingConflictOptions={ReferenceAntigenVolume,ReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume,StandardReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume,BlankReferenceAntigenDilutionFactor};
		If[messages,
			Message[Error::ReferenceAntigenPipettingVolumeTooLow,
				ObjectToString[referenceAntigenErrorIdentifier,Simulation->updatedSimulation](*,
					ToString[referenceAntigenIntermediateDilutionRates],
					ToString[afterDilutionReferenceAntigenVolumes]*)
			]
		],
		referenceAntigenPipettingConflictOptions={}
	];
	referenceAntigenSufficientPipettingVolumesTest=If[gatherTests,
		Test["ReferenceAntigen dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,Length[insufficientReferenceAntigenVolumes]===0
		],{}
	];

	(*Spike: Spike is only added to the original sample. Se we are not expanding it by dilution curves*)
	If[!MatchQ[resolvedSpikeDilutionFactor,{Null..}|{}|Null],
		(*only samples will be spiked*)
		sampleVolumes=Which[
			(*Not considering directELISA, IndirectELISA and Coating is False because SpikeDilutionFactor will be Null*)
			MatchQ[suppliedMethod,Alternatives[DirectELISA,IndirectELISA]],
			resolvedSampleCoatingVolume,
			MatchQ[suppliedMethod,Alternatives[DirectSandwichELISA,IndirectSandwichELISA]],
			resolvedSampleImmunosorbentVolume,
			MatchQ[suppliedMethod,Alternatives[DirectCompetitiveELISA,DirectCompetitiveELISA,FastELISA]],
			resolvedSampleAntibodyComplexImmunosorbentVolume
		]*pipettingError;
		spikeVolumes=MapThread[#1*#2&,{resolvedSpikeDilutionFactor/.(Null->0),sampleVolumes}];
		insufficientSpikeVolumes=Cases[spikeVolumes,_?((# <1 Microliter)&&(# >0 Microliter) &)];
		If[
			Length[insufficientSpikeVolumes]>0,
			(*Standard and Blank will not be spiked so picklist is done towards simulatedSamples.*)
			spikeErrorIdentifier=PickList[simulatedSamples,sampleVolumes,_?((# <1 Microliter)&&(# >0 Microliter) &)];
			spikeIntermediateDilutionRates=(10^Ceiling[-Log10[#//QuantityMagnitude]])&/@insufficientSpikeVolumes;
			afterDilutionSpikeVolumes=MapThread[#1*#2&,{insufficientSpikeVolumes,spikeIntermediateDilutionRates}];
			spikePipettingConflictOptions={SpikeDilutionFactor};
			If[messages,
				Message[Error::SpikePipettingVolumeTooLow,
					ObjectToString[spikeErrorIdentifier,Simulation->updatedSimulation](*,
					ToString[spikeIntermediateDilutionRates],
					ToString[afterDilutionReferenceAntigenVolumes]*)
				]
			],
			spikePipettingConflictOptions={}
		],
		(*ELSE*)
		spikePipettingConflictOptions={}
	];

	spikeSufficientPipettingVolumesTest=If[gatherTests,
		Test["Spike dilutions do not require pipetting a volume smaller than 1 microliter.",
			True,spikePipettingConflictOptions==={}
		],{}
	];



	(*Plates And Assignments: These options must be resolved in the end because they depend on DilutionCurve options and Standard and Blank to resolve first.*)



	(*Assignment checks*)
	(*Number of standard and blank objects not expanded by dilution curves or number of replicates*)
	standardObjectNumber=Length[DeleteCases[resolvedStandard//ToList, Null]];
	blankObjectNumber=Length[DeleteCases[resolvedBlank//ToList, Null]];
	totalObjectNumber=Length[simulatedSamples]+standardObjectNumber+blankObjectNumber;

	(* assignmentSamples is different from joinedSamples. To make sure we don't have conflict between our coated sample and simulated sample - which is a conflict that is dealt with PrecoatedSamplesCannotBeAliquoted later - when Coating->False, we use mySamples instead of simulatedSamples
	assignmentSamples=If[MatchQ[{suppliedMethod,suppliedCoating},{(DirectELISA|IndirectELISA),False}],
		DeleteCases[Join[mySamples,ToList[resolvedStandard],ToList[resolvedBlank]],(Null|{Null..}|{})],
		DeleteCases[Join[simulatedSamples,ToList[resolvedStandard],ToList[resolvedBlank]],(Null|{Null..}|{})]
	];
	*)

	(* we have to use mySamples instead of simulatedSamples, otherwise it won't be successfully replaced in rescource packets -- will have different ID fromsamplesInResources *)
	assignmentSamples = DeleteCases[Join[mySamples,ToList[resolvedStandard],ToList[resolvedBlank]],(Null|{Null..}|{})];

	assignmentSpikes={
		suppliedSpike,ConstantArray[Null,standardObjectNumber],ConstantArray[Null,blankObjectNumber]
	}//Flatten;
	(*Make an initial {Sample..,Standard..,Blank..} list*)
	assignmentTypesRaw={
		ConstantArray[Unknown,Length[simulatedSamples]],
		ConstantArray[Standard,standardObjectNumber],
		ConstantArray[Blank,blankObjectNumber]
	}//Flatten;
	(*Change the AssignmentTypes list so that if the sample is spiked, its type is Spike.*)
	assignmentTypesSpiked=MapThread[
		If[MatchQ[#1,Except[Null]],
			Spike,
			#2
		]&,
		{assignmentSpikes,assignmentTypesRaw}
	];
	assignmentSpikeDilutionFactors={
		resolvedSpikeDilutionFactor,ConstantArray[Null,standardObjectNumber],ConstantArray[Null,blankObjectNumber]
	}//Flatten;
	(*Join dilution curves. This should eliminate Nulls in the scienarios when there is no Standard or Blank*)
	joinedFixedDilutionCurves=Flatten[{
		roundedTransformedSampleDilutionCurve,
		If[MatchQ[resolvedStandard,Null|{Null..}|{}],{},roundedTransformedStandardDilutionCurve],
		ConstantArray[Null,blankObjectNumber]
	},1];
	joinedSerialDilutionCurves=Flatten[{
		roundedTransformedSampleSerialDilutionCurve,
		If[MatchQ[resolvedStandard,Null|{Null..}|{}],{},roundedTransformedStandardSerialDilutionCurve],
		ConstantArray[Null,blankObjectNumber]
	},1];
	(*We are combining dilution curves and serial dilution curves into (ABSOLUTE) dilution factors.*)
	assignmentDilutionFactors=MapThread[
		Function[{fixedCurve,serialCurve},
			Which[
				MatchQ[fixedCurve,Except[Null|{Null..}|{}]],fixedCurve[[All,1]]/(fixedCurve[[All,1]]+fixedCurve[[All,2]]),
				MatchQ[serialCurve,Except[Null|{Null..}|{}]],FoldList[Times,(serialCurve[[All,1]]/(serialCurve[[All,1]]+serialCurve[[All,2]]))],
				True,{1}
			]
		],{joinedFixedDilutionCurves,joinedSerialDilutionCurves},1];


	assignmentCoatingAntibodies=If[MatchQ[suppliedMethod,FastELISA],
		joinedCoatingAntibodies,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentCoatingAntibodyDilutionFactors=If[MatchQ[suppliedMethod,FastELISA],
		combinedCoatingAntibodyFactors,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentCaptureAntibodies=If[MatchQ[suppliedMethod,(DirectSandwichELISA|IndirectSandwichELISA|FastELISA)],
		joinedCaptureAntibodies,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentCaptureAntibodyDilutionFactors=If[MatchQ[suppliedMethod,(DirectSandwichELISA|IndirectSandwichELISA|FastELISA)],
		combinedCaptureAntibodyFactors,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentReferenceAntigens=If[MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)],
		joinedReferenceAntigens,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentReferenceAntigenDilutionFactors=If[MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)],
		combinedReferenceAntigenFactors,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentPrimaryAntibodies=joinedPrimaryAntibodies;
	
	assignmentPrimaryAntibodyDilutionFactors=combinedPrimaryAntibodyFactors;
	
	assignmentSecondaryAntibodies=If[MatchQ[suppliedMethod,(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA)],
		joinedSecondaryAntibodies,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentSecondaryAntibodyDilutionFactors=If[MatchQ[suppliedMethod,(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA)],
		combinedSecondaryAntibodyFactors,
		ConstantArray[Null,totalObjectNumber]
	];

	(* It may be possible that some of the following options are not automatically resolved and come back as Null. We cannot simply Delete-Null to get the options *)
	assignmentCoatingVolume=Which[
		MatchQ[suppliedCoating,False],
		ConstantArray[Null,totalObjectNumber],

		MatchQ[suppliedMethod,(DirectELISA|IndirectELISA)],
		{
			resolvedSampleCoatingVolume,
			If[standardObjectNumber===0,{},resolvedStandardCoatingVolume],
			If[blankObjectNumber===0,{},resolvedBlankCoatingVolume]
		}//Flatten,

		MatchQ[suppliedMethod,(DirectSandwichELISA|IndirectSandwichELISA)],
		{
			resolvedCaptureAntibodyCoatingVolume,
			If[standardObjectNumber===0,{},resolvedStandardCaptureAntibodyCoatingVolume],
			If[blankObjectNumber===0,{},resolvedBlankCaptureAntibodyCoatingVolume]
		}//Flatten,

		MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)],
		{
			resolvedReferenceAntigenCoatingVolume,
			If[standardObjectNumber===0,{},resolvedStandardReferenceAntigenCoatingVolume],
			If[blankObjectNumber===0,{},resolvedBlankReferenceAntigenCoatingVolume]
		}//Flatten,

		MatchQ[suppliedMethod,FastELISA],
		{
			resolvedCoatingAntibodyCoatingVolume,
			If[standardObjectNumber===0,{},resolvedStandardCoatingAntibodyCoatingVolume],
			If[blankObjectNumber===0,{},resolvedBlankCoatingAntibodyCoatingVolume]
		}//Flatten
	];
	assignmentBlockingVolume=If[suppliedBlocking,
		{
			resolvedBlockingVolume,
			If[standardObjectNumber===0,{},resolvedStandardBlockingVolume],
			If[blankObjectNumber===0,{},resolvedBlankBlockingVolume]
		}//Flatten,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentSampleAntibodyComplexImmunosorbentVolume=If[MatchQ[suppliedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],
		{
			resolvedSampleAntibodyComplexImmunosorbentVolume,
			If[standardObjectNumber===0,{},resolvedStandardAntibodyComplexImmunosorbentVolume],
			If[blankObjectNumber===0,{},resolvedBlankAntibodyComplexImmunosorbentVolume]
		}//Flatten,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentSampleImmunosorbentVolume=If[MatchQ[suppliedMethod,(DirectSandwichELISA|IndirectSandwichELISA)],
		{
			resolvedSampleImmunosorbentVolume,
			If[standardObjectNumber===0,{},resolvedStandardImmunosorbentVolume],
			If[blankObjectNumber===0,{},resolvedBlankImmunosorbentVolume]
		}//Flatten,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentPrimaryAntibodyImmunosorbentVolume=If[MatchQ[suppliedMethod,(DirectELISA|IndirectELISA|DirectSandwichELISA|IndirectSandwichELISA)],
		{
			resolvedPrimaryAntibodyImmunosorbentVolume,
			If[standardObjectNumber===0,{},resolvedStandardPrimaryAntibodyImmunosorbentVolume],
			If[blankObjectNumber===0,{},resolvedBlankPrimaryAntibodyImmunosorbentVolume]
		}//Flatten,
		ConstantArray[Null,totalObjectNumber]
	];
	assignmentSecondaryAntibodyImmunosorbentVolume=If[MatchQ[suppliedMethod,(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA)],
		{
			resolvedSecondaryAntibodyImmunosorbentVolume,
			If[standardObjectNumber===0,{},resolvedStandardSecondaryAntibodyImmunosorbentVolume],
			If[blankObjectNumber===0,{},resolvedBlankSecondaryAntibodyImmunosorbentVolume]
		}//Flatten,
		ConstantArray[Null,totalObjectNumber]
	];

	assignmentSubstrate={
		resolvedSubstrateSolution,
		If[standardObjectNumber===0,{},resolvedStandardSubstrateSolution],
		If[blankObjectNumber===0,{},resolvedBlankSubstrateSolution]
	}//Flatten;
	assignmentSubstrateVolume={
		resolvedSubstrateSolutionVolume,
		If[standardObjectNumber===0,{},resolvedStandardSubstrateSolutionVolume],
		If[blankObjectNumber===0,{},resolvedBlankSubstrateSolutionVolume]
	}//Flatten;

	assignmentStop={
		resolvedStopSolution,
		If[standardObjectNumber===0,{},resolvedStandardStopSolution],
		If[blankObjectNumber===0,{},resolvedBlankStopSolution]
	}//Flatten;
	assignmentStopVolume={
		resolvedStopSolutionVolume,
		If[standardObjectNumber===0,{},resolvedStandardStopSolutionVolume],
		If[blankObjectNumber===0,{},resolvedBlankStopSolutionVolume]
	}//Flatten;

	joinedAssignmentTable={
		assignmentTypesSpiked,
		assignmentSamples,
		assignmentSpikes,
		assignmentSpikeDilutionFactors,
		assignmentDilutionFactors,
		assignmentCoatingAntibodies,
		assignmentCoatingAntibodyDilutionFactors,
		assignmentCaptureAntibodies,
		assignmentCaptureAntibodyDilutionFactors,
		assignmentReferenceAntigens,
		assignmentReferenceAntigenDilutionFactors,
		assignmentPrimaryAntibodies,
		assignmentPrimaryAntibodyDilutionFactors,
		assignmentSecondaryAntibodies,
		assignmentSecondaryAntibodyDilutionFactors,
		assignmentCoatingVolume,
		assignmentBlockingVolume,
		assignmentSampleAntibodyComplexImmunosorbentVolume,
		assignmentSampleImmunosorbentVolume,
		assignmentPrimaryAntibodyImmunosorbentVolume,
		assignmentSecondaryAntibodyImmunosorbentVolume,
		assignmentSubstrate,
		assignmentStop,
		assignmentSubstrateVolume,
		assignmentStopVolume
	}//Transpose;


	(*-----Rearrangement/Split assignment to its corresponding position------*)

	(*Help function that counts number of wells a list of samples with their dilution curves and number of replicates will occupy*)
	elisaWellCounter[dilutionFactors_List,numReps_]:=
		Module[{numDilutionsPerSample},
			numDilutionsPerSample=Map[Length,dilutionFactors,{1}];
			FoldList[Plus,numDilutionsPerSample]*numReps
		];

	If[MatchQ[{suppliedMethod,suppliedCoating},{(DirectELISA|IndirectELISA),False}],
		(*If samples are precoated, samples should be arranged so that it matches their original well. But sample should also be arranged column-wise*)
		allPrecoatedPlates=DeleteDuplicates[Flatten[elisaGetPacketValue[#,Container,All,simulatedCache]&/@mySamples]];
		(*Get the contents of each plate at their input order*)
		plateContentsRaw=elisaGetPacketValue[#,Contents,All,simulatedCache]&/@allPrecoatedPlates;
		(*Split up the two plates*)
		If[Length[allPrecoatedPlates]===2,
			primaryPlateContentRaw=plateContentsRaw[[1]];
			secondaryPlateContentRaw=plateContentsRaw[[2]],

			primaryPlateContentRaw=plateContentsRaw[[1]];
			secondaryPlateContentRaw={} (*{} is immune to all the following operations and yield {}*)
		];
		(*Convert the well number into index at a transposed/column-wise sequence*)
		primaryPlateIndexConverted=Map[{ConvertWell[#[[1]],OutputFormat->TransposedIndex],#[[2]]}&,primaryPlateContentRaw];
		secondaryPlateIndexConverted=Map[{ConvertWell[#[[1]],OutputFormat->TransposedIndex],#[[2]]}&,secondaryPlateContentRaw];
		(*SORT will be based on the converted index number*)
		primaryPlateContentSorted=primaryPlateIndexConverted//Sort;
		secondaryPlateContentSorted=secondaryPlateIndexConverted//Sort;
		(*Get the samples-- use this as a sorting table*)
		primaryPlateSortedSamples=primaryPlateContentSorted[[All,2]];
		secondaryPlateSortedSamples=secondaryPlateContentSorted[[All,2]];
		(*pick each assignment at the order of the sorted samples. Select adds a layer of list. We'll have to Flatten that too.*)
		columnwiseELISAPlateAssignment=Flatten[(Function[{sample},Select[joinedAssignmentTable,MatchQ[#[[2]],ObjectP[sample]]&]]/@primaryPlateSortedSamples),1];
		columnwiseSecondaryELISAPlateAssignment=Flatten[(Function[{sample},Select[joinedAssignmentTable,MatchQ[#[[2]],ObjectP[sample]]&]]/@secondaryPlateSortedSamples),1];
		{resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment}=elisaSetAuto[{suppliedELISAPlateAssignment,suppliedSecondaryELISAPlateAssignment},{columnwiseELISAPlateAssignment,columnwiseSecondaryELISAPlateAssignment}],

		(*ELSE*)
		joinedAssignmentTableCounts=elisaWellCounter[assignmentDilutionFactors,resolvedNumberOfReplicatesNullToOne];
		(*Break up the table where counts exceeds 96: sometimes the first plate is not fully occupied before the split, as number of replicates and dilution curves cannot be broken into two plates. This makes sense scientifically too as results from two plates should not be compared in ELISA experiments.*)
		(*In the very rare case that the first element already leads to more than 96 samples, we still want to put it into the first plate to avoid an empty first plate but a full second plate. Set the first to True always *)
		joinedAssignmentTableLessEqual96Q=Prepend[Map[#<=96&,joinedAssignmentTableCounts[[2;;-1]]],True];
		resolvedELISAPlateAssignment=elisaSetAuto[{suppliedELISAPlateAssignment},{Pick[joinedAssignmentTable,joinedAssignmentTableLessEqual96Q,True]}]//FirstOrDefault;
		resolvedSecondaryELISAPlateAssignment=FirstOrDefault[elisaSetAuto[{suppliedSecondaryELISAPlateAssignment},{Pick[joinedAssignmentTable,joinedAssignmentTableLessEqual96Q,False]}]];
	];


	(*Check if assignment per plate exceeds 96*)
	resolvedPrimaryAssignmentTableCounts=elisaWellCounter[resolvedELISAPlateAssignment[[All,5]],resolvedNumberOfReplicatesNullToOne];
	resolvedSecondaryAssignmentTableCounts=elisaWellCounter[resolvedSecondaryELISAPlateAssignment[[All,5]],resolvedNumberOfReplicatesNullToOne];

	primaryPlateExceeds96Q=resolvedPrimaryAssignmentTableCounts[[-1]]>96;
	secondaryPlateExceeds96Q=LastOrDefault[resolvedSecondaryAssignmentTableCounts]>96; (*Use LastOrDefault in case SecondaryELISAPlate is empty*)
	wellNumberConflictOptions=Pick[{ELISAPlateAssignment,SecondaryELISAPlateAssignment},{primaryPlateExceeds96Q,secondaryPlateExceeds96Q},True];
	If[Length[wellNumberConflictOptions]>0&&messages,
		Message[
			Error::PlateAssignmentExceedsAvailableWells,
			ToString[wellNumberConflictOptions]
		]resolvedPrimaryAssignmentTableCounts
	];
	numberWellsTest=If[gatherTests,
		Test["ELISA plate and secondary ELISA Plate assignments requires less or equals to 96 wells:",
			True,
			wellNumberConflictOptions=0
		]
	];

	(*Check if assignment total list is the same as auto-resolved-- the user altered input can only be an rearrangment of the auto-resolved*)
	(*Combine assignment lists*)
	(*The resolved assignment is user altered if the user altered it. Is auto-resolved if user set it to automatic*)
	sortedJoinedResolvedAssignments=Join[resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment]//Sort;
	sortedJoinedAssignmentTable=joinedAssignmentTable//Sort;
	(* Here we need to compare using not only MatchQ because we have Objects in name or ID, Quantity that may be different because of the precision *)
	assignmentTableMatchQ=And@@Flatten[
		MapThread[
			Function[{assignment,assignmentTable},
				Which[
					MatchQ[assignment,ObjectP[]],SameObjectQ[assignment,assignmentTable],
					MatchQ[assignment,_Real|_Quantity],EqualQ[assignment,assignmentTable],
					MatchQ[assignment,ListableP[_Real]],MapThread[EqualQ[#1,#2]&,{assignment,assignmentTable}],
					True,MatchQ[assignment,assignmentTable]
				]
			],
			{sortedJoinedResolvedAssignments,sortedJoinedAssignmentTable},
			2
		]
	];

	assignmentMatchingConflictOptions=If[assignmentTableMatchQ,{},{ELISAPlateAssignment,SecondaryELISAPlateAssignment}];
	If[!assignmentTableMatchQ&&messages,
		Message[Error::PlateAssignmentDoesNotMatchOptions,ToString[assignmentMatchingConflictOptions]]
	];
	assginmentMatchesTest=If[gatherTests,
		Test["ELISA plate and secondary ELISA Plate assignments match all the option inputs:",
			True,
			assignmentTableMatchQ
		]
	];

	(*When samples are precoated, Users cannot even rearrange the samples.*)
	If[MatchQ[{suppliedMethod,suppliedCoating},{(DirectELISA|IndirectELISA),False}],
		(*We are using resolved assignments here to avoid having to discuss possibilities when supplied options are automatic*)
		joinedResolvedAssignments=Join[resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment];
		(*This is auto-resolved assignments*)
		joinedColumnwiseAssignment=Join[columnwiseELISAPlateAssignment,columnwiseSecondaryELISAPlateAssignment];
		(* Here we need to compare using not only MatchQ because we have Objects in name or ID, Quantity that may be different because of the precision *)
		coatedAssignmentTableMatchQ=And@@Flatten[
			MapThread[
				Function[{assignment,assignmentTable},
					Which[
						MatchQ[assignment,ObjectP[]],SameObjectQ[assignment,assignmentTable],
						MatchQ[assignment,_Real|_Quantity],EqualQ[assignment,assignmentTable],
						MatchQ[assignment,ListableP[_Real]],MapThread[EqualQ[#1,#2]&,{assignment,assignmentTable}],
						True,MatchQ[assignment,assignmentTable]
					]
				],
				{joinedResolvedAssignments,joinedColumnwiseAssignment},
				2
			]
		],

		(*ELSE*)
		coatedAssignmentTableMatchQ=True
	];

	coatedAssignmentMatchingConflictOptions=If[coatedAssignmentTableMatchQ,{},{ELISAPlateAssignment,SecondaryELISAPlateAssignment}];
	If[!coatedAssignmentTableMatchQ&&messages,
		Message[Error::PlateAssignmentIsNotColumnWise,ToString[coatedAssignmentMatchingConflictOptions]]
	];
	coatedAssignmentMatchesTest=If[gatherTests,
		Test["ELISA plate and secondary ELISA Plate assignments match all the option inputs:",
			True,
			coatedAssignmentTableMatchQ
		]
	];
	(*------ELISAPlates------*)

	If[MatchQ[{suppliedMethod,suppliedCoating},{(DirectELISA|IndirectELISA),False}],
		(*When samples are precoated: mySamples sequence should follow myContainers sequence so we'll end up with myContainers at its input sequence*)

		resolvedELISAPlate =If[suppliedELISAPlate===Automatic,
			allPrecoatedPlates//FirstOrDefault,
			suppliedELISAPlate
		];

		resolvedSecondaryELISAPlate =
			If[suppliedSecondaryELISAPlate===Automatic,
				If[Length[allPrecoatedPlates]===2,allPrecoatedPlates[[2]],Null],
				suppliedSecondaryELISAPlate
			],

		(*ELSE: when samples are not coated on plate*)
		resolvedELISAPlate =If[suppliedELISAPlate===Automatic,
			Model[Container, Plate, "id:rea9jlRLlqYr"],
			suppliedELISAPlate
		];
		resolvedSecondaryELISAPlate =
			If[suppliedSecondaryELISAPlate===Automatic,
				If[joinedAssignmentTableCounts[[-1]]<=96,
					Null,
					Model[Container, Plate, "id:rea9jlRLlqYr"]
				],
				suppliedSecondaryELISAPlate
			]
	];


	(*-- UNRESOLVABLE OPTION CHECKS --*)
	allPotentialUnresolvableIndexMatchedOptions =
		{
			unresolvablePrimaryAntibodyList,
			unresolvableSecondaryAntibodyList,
			unresolvableCaptureAntibodyList,
			unresolvableCoatingAntibodyList,
			unresolvableReferenceAntigenList,
			unresolvableSubstrateSolutionList,
			unresolvableStopSolutionList,
			unresolvableSubstrateSolutionVolumeList,
			unresolvableStopSolutionVolumeList,
			unresolvableStandardList,
			unresolvableStandardPrimaryAntibodyList,
			unresolvableStandardSecondaryAntibodyList,
			unresolvableStandardCaptureAntibodyList,
			unresolvableStandardCoatingAntibodyList,
			unresolvableStandardReferenceAntigenList,
			unresolvableStandardSubstrateSolutionList,
			unresolvableStandardStopSolutionList,
			unresolvableStandardSubstrateSolutionVolumeList,
			unresolvableStandardStopSolutionVolumeList,
			unresolvableBlankList,
			unresolvableBlankPrimaryAntibodyList,
			unresolvableBlankSecondaryAntibodyList,
			unresolvableBlankCaptureAntibodyList,
			unresolvableBlankCoatingAntibodyList,
			unresolvableBlankReferenceAntigenList,
			unresolvableBlankSubstrateSolutionList,
			unresolvableBlankStopSolutionList,
			unresolvableBlankSubstrateSolutionVolumeList,
			unresolvableBlankStopSolutionVolumeList
		};

	unresolvableIndexMatchedOptionBoolean=Or@@#&/@allPotentialUnresolvableIndexMatchedOptions;

	unresolvableOptionList = Pick[{
		PrimaryAntibody,
		SecondaryAntibody,
		CaptureAntibody,
		CoatingAntibody,
		ReferenceAntigen,
		SubstrateSolution,
		StopSolution,
		SubstrateSolutionVolume,
		StopSolutionVolume,
		Standard,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		StandardCaptureAntibody,
		StandardCoatingAntibody,
		StandardReferenceAntigen,
		StandardSubstrateSolution,
		StandardStopSolution,
		StandardSubstrateSolutionVolume,
		StandardStopSolutionVolume,
		Blank,
		BlankPrimaryAntibody,
		BlankSecondaryAntibody,
		BlankCaptureAntibody,
		BlankCoatingAntibody,
		BlankReferenceAntigen,
		BlankSubstrateSolution,
		BlankStopSolution,
		BlankSubstrateSolutionVolume,
		BlankStopSolutionVolume},unresolvableIndexMatchedOptionBoolean,True];

	resolvableOptionList = Pick[{
		PrimaryAntibody,
		SecondaryAntibody,
		CaptureAntibody,
		CoatingAntibody,
		ReferenceAntigen,
		SubstrateSolution,
		StopSolution,
		SubstrateSolutionVolume,
		StopSolutionVolume,
		Standard,
		StandardPrimaryAntibody,
		StandardSecondaryAntibody,
		StandardCaptureAntibody,
		StandardCoatingAntibody,
		StandardReferenceAntigen,
		StandardSubstrateSolution,
		StandardStopSolution,
		StandardSubstrateSolutionVolume,
		StandardStopSolutionVolume,
		Blank,
		BlankPrimaryAntibody,
		BlankSecondaryAntibody,
		BlankCaptureAntibody,
		BlankCoatingAntibody,
		BlankReferenceAntigen,
		BlankSubstrateSolution,
		BlankStopSolution,
		BlankSubstrateSolutionVolume,
		BlankStopSolutionVolume},unresolvableIndexMatchedOptionBoolean,False];

	If[Length[unresolvableOptionList]=!=0&&messages,
		Message[Error::UnresolvableIndexMatchedOptions,
			StringTake[ToString[unresolvableOptionList], {2,-2}]
		]
	];

	unresolvableIndexMatchedOptionsTests=If[gatherTests,
		Module[{passingTest,failingTest},
			passingTest=If[Length[resolvableOptionList]=!=0,
				Test["IndexMatchedOptions"<>StringTake[ToString[resolvableOptionList], {2,-2}] <>" are resolvable:",
					True,True]];
			failingTest=If[Length[unresolvableOptionList]=!=0,
				Test["IndexMatchedOptions"<>StringTake[ToString[unresolvableOptionList], {2,-2}] <>" are resolvable:",
					True,False]];
			{passingTest,failingTest}],
		{}
	];

	(*Dilution curves insufficient pipetting volume-- broken away from other insufficient pipetting volume checks because it depends on the combined dilution curves*)
	(*We got combined sample dilution curve and combined standard dilution curve. We are putting them together here.*)
	(*We ain't deleting any Null cases here as it may confuse Standard=={Null} with a sample that is not being diluted*)
	joinedCombinedDilutionCurvesReplicatedErrored=Map[If[MatchQ[#,Null|{Null}|{}],{{Null}},#*(resolvedNumberOfReplicatesNullToOne*pipettingError)]&,Join[combinedSampleDilutionCurve,combinedStandardDilutionCurve],1];

	If[!MatchQ[joinedCombinedDilutionCurvesReplicatedErrored,{Null..}],
		curvesSufficientVolumeBooleans=Map[If[#[[1]]>=1Microliter||(!VolumeQ[#[[1]]]),True,False]&,joinedCombinedDilutionCurvesReplicatedErrored,{2}];
		sampleCurveSufficientVolumeBooleans = (And@@#)&/@curvesSufficientVolumeBooleans;
		insufficientVolumeCurves=Select[curvesSufficientVolumeBooleans,(And@@#===False&)];
		If[Length[insufficientVolumeCurves]>0,
			insufficientVolumePositions=Position[insufficientVolumeCurves,False];
			joinedSampleAndStandard=Join[simulatedSamples,ToList[resolvedStandard]];

			samplesAndStandardsWithInsufficientVolumes=PickList[joinedSampleAndStandard,sampleCurveSufficientVolumeBooleans,False];
			dilutionCurvesConflictingOptions={SampleDilutionCurve,SampleSerialDilutionCurve,StandardDilutionCurve,StandardSerialDilutionCurve};
			If[messages,
				Message[Error::DilutionCurvesPipettingVolumeTooLow,
					ObjectToString[samplesAndStandardsWithInsufficientVolumes,Simulation->updatedSimulation],
					ToString[insufficientVolumePositions]
				]
			],
			dilutionCurvesConflictingOptions={}
		],
		dilutionCurvesConflictingOptions={}
	];

	dilutionCurveSufficientPipettingVolumesTests=If[gatherTests,
		samplesAndStandardsWithSufficientVolumes=DeleteCases[joinedSampleAndStandard,Alternatives@@samplesAndStandardsWithInsufficientVolumes];
		Module[{passingTest,failingTest},
			passingTest=If[Length[samplesAndStandardsWithSufficientVolumes]>0,
				Test["DilutionCurves or SerialDilutionCurves for "
					<>ObjectToString[samplesAndStandardsWithSufficientVolumes,Simulation->updatedSimulation]
					<>" do not require pipetting a volume smaller than 1 microliter.",
					True,True
				],
				{}
			];
			failingTest=If[Length[samplesAndStandardsWithInsufficientVolumes]>0,
				Test["DilutionCurves or SerialDilutionCurves for "
					<>ObjectToString[samplesAndStandardsWithInsufficientVolumes,Simulation->updatedSimulation]
					<>" do not require pipetting a volume smaller than 1 microliter.",
					True,False
				],
				{}
			]
		]
	];






	(*-- CONTAINER GROUPING RESOLUTION --*)
	(* Resolve RequiredAliquotContainers *)
	(*Calculated dilutionExpandedSpikeDilutionFactors*)
	spikeDilutionFactorNullToZero=resolvedSpikeDilutionFactor/.Null->0;
	combinedSampleDilutionFactorCurve=Map[If[MatchQ[#,Null|{}|{Null..}],{1},{#[[1]]/(#[[1]]+#[[2]])}]&,combinedSampleDilutionCurve,{2}];
	sampleDilutionNumbers=Length/@combinedSampleDilutionCurve;
	dilutionExpandedSpikeDilutionFactors=MapThread[ConstantArray[#1,#2]&, {spikeDilutionFactorNullToZero,sampleDilutionNumbers}]//Flatten;
	dilutionExpandedSamples=MapThread[ConstantArray[#1,#2]&,{simulatedSamples,sampleDilutionNumbers}]//Flatten;

	(*Calculate in each dilution, how much Sample is needed: AssayVolume*(1-SpikeDilutionFactor)*SampleDilutionFactor  *)
	(*If sample is precoated, then no sample volume*)
	If[MatchQ[suppliedMethod,DirectELISA|IndirectELISA]&&suppliedCoating===False,
		(* No aliquot shall be performed when sample is coated onto the plate*)
		sampleLengthNull=ConstantArray[Null,Length[mySamples]];
		sampleLengthFalse=ConstantArray[False,Length[mySamples]];
		{
			resolvedAliquotAmount,resolvedTargetConcentration,resolvedTargetConcentrationAnalyte,resolvedAssayVolume,resolvedAliquotContainer,resolvedDestinationWell,resolvedConcentratedBuffer,resolvedBufferDilutionFactor,resolvedBufferDiluent,resolvedAssayBuffer,resolvedAliquotSampleStorageCondition,resolvedAliquot,resolvedConsolidateAliquots,resolvedAliquotLiquidHandlingScale
		}=elisaSetAuto[{
			suppliedAliquotAmount,suppliedTargetConcentration,suppliedTargetConcentrationAnalyte,suppliedAssayVolume,suppliedAliquotContainer,suppliedDestinationWell,suppliedConcentratedBuffer,suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAssayBuffer,suppliedAliquotSampleStorageCondition,suppliedAliquot,suppliedConsolidateAliquots,suppliedAliquotLiquidHandlingScale
		},{
			sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthNull,sampleLengthFalse,Null,Null
		}];

		resolvedAliquotOptions=
			{
				AliquotAmount -> resolvedAliquotAmount,
				TargetConcentration -> resolvedTargetConcentration,
				TargetConcentrationAnalyte -> resolvedTargetConcentrationAnalyte,
				AssayVolume -> resolvedAssayVolume,
				AliquotContainer -> resolvedAliquotContainer,
				DestinationWell -> resolvedDestinationWell,
				ConcentratedBuffer -> resolvedConcentratedBuffer,
				BufferDilutionFactor -> resolvedBufferDilutionFactor,
				BufferDiluent -> resolvedBufferDiluent,
				AssayBuffer -> resolvedAssayBuffer,
				AliquotSampleStorageCondition -> resolvedAliquotSampleStorageCondition,
				Aliquot -> resolvedAliquot,
				ConsolidateAliquots -> resolvedConsolidateAliquots,
				AliquotPreparation -> resolvedAliquotLiquidHandlingScale
			};

		preCoatedSampleConflictingAliquotOptions=Map[If[MatchQ[#,{Null..}|Null|{False..}|False|{Automatic..}|Automatic],Nothing,#]&,{suppliedAliquotAmount,suppliedTargetConcentration,suppliedTargetConcentrationAnalyte,suppliedAssayVolume,suppliedAliquotContainer,suppliedDestinationWell,suppliedConcentratedBuffer,suppliedBufferDilutionFactor,suppliedBufferDiluent,suppliedAssayBuffer,suppliedAliquotSampleStorageCondition,suppliedAliquot,suppliedConsolidateAliquots,suppliedAliquotLiquidHandlingScale
		}];
		volumeTooLargeOptions={};
		If[Length[preCoatedSampleConflictingAliquotOptions]>0&&messages,
			Message[Error::PrecoatedSamplesCannotBeAliquoted,
				ObjectToString[preCoatedSampleConflictingAliquotOptions]
			]
		];
		aliquotTests=If[gatherTests,
			Test["When samples are coated onto ELISA plates, no aliquot should be performed for sample preparation.",
				True,
				Length[preCoatedSampleConflictingAliquotOptions]===0
			],
			{}
		],

		(*ELSE*)
		assayVolumeList=Which[
			MatchQ[suppliedMethod,DirectELISA|IndirectELISA],
			resolvedSampleCoatingVolume,

			MatchQ[suppliedMethod,DirectSandwichELISA|IndirectSandwichELISA],
			resolvedSampleImmunosorbentVolume,

			MatchQ[suppliedMethod,DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA],
			resolvedSampleAntibodyComplexImmunosorbentVolume
		];

		(*Here we calculate, PER ONE REPLICATION,how much of each SamplesIn is needed. resolveAliquotOptions will time this number by the number of replication.*)
		volumePerSamplesIn=MapThread[
			Function[{roundedDilutionCurve, roundedSerialDilutionCurve, assayVolume},
				Module[{volumePerSampleIn, correctedVolumePerSampleIn},
					volumePerSampleIn = Which[
						(*IF fixed dilution, then take the first of every dilution tuple and add them together*)
						MatchQ[roundedDilutionCurve, Except[Null | {} | {Null..}]],
						Plus @@ (ToList[roundedDilutionCurve][[All, 1]]),
						(*IF serial dilution, then take the first of the first dilution tuple*)
						MatchQ[roundedSerialDilutionCurve, Except[Null | {} | {Null..}]],
						roundedSerialDilutionCurve[[1, 1]],
						(*ELSE, take the assay volume*)
						MatchQ[assayVolume, Except[Null]],
						assayVolume,
						(* In case we are given Null volume, an error should have been thrown for the specific option. Use our default value here for aliquot option resolving *)
						True, 200Microliter
					];
					(* Correct with pipetting error and round to precision required by ExperimentAliquot *)
					correctedVolumePerSampleIn = SafeRound[volumePerSampleIn * pipettingError, 10^-1 Microliter]
				]
			],
			{roundedTransformedSampleDilutionCurve,roundedTransformedSampleSerialDilutionCurve,assayVolumeList}
		];


		(* Get all the possible liquid handler compatible containers *)
		liquidHandlerCompatibleContainers=PreferredContainer[All,LiquidHandlerCompatible->True,Type->All,All->True];
		coatedSampleQ=MatchQ[suppliedMethod,DirectELISA|IndirectELISA]&&suppliedCoating===False;

		(* Define the target containers and also track volume too large error. Only dilution curve can lead to this error *)
		volumeTooLargeOptions = DeleteDuplicates[Flatten[
			MapThread[
				Function[{container,volume},
					Which[
						(* No need to transfer if already in a compatible container or sample is already coated to the plate. No error for this case *)
						MemberQ[liquidHandlerCompatibleContainers,ObjectP[container]]||coatedSampleQ,Nothing,

						(* No error for smaller than 50 mL *)
						volume<50Milliliter,Nothing,

						True,{SampleDilutionCurve,SampleSerialDilutionCurve}
					]
				],
				{simulatedSampleContainerModels,volumePerSamplesIn*resolvedNumberOfReplicatesNullToOne}
			]
		]];

		If[Length[volumeTooLargeOptions]>0,
			Message[Error::SampleVolumeShouldNotBeLargerThan50ml]
		];

		targetContainers=MapThread[
			Function[{container,volume},
				Which[
					(* No need to transfer if already in a compatible container or sample is already coated to the plate*)
					MemberQ[liquidHandlerCompatibleContainers,ObjectP[container]]||coatedSampleQ,
					Null,

					(* Use 2ml tube if total sample volume is <= 1.9ml*)
					volume<=1.9Milliliter,
					PreferredContainer[1.9Milliliter,LiquidHandlerCompatible->True],

					(* Use 50ml tube is total sample volume is larger than 2ml tube. Since the total working volume (250ul per well) for 2*96 well plates is less than 50ml, it is not possible for the needed sample volume to exceed the capacity of a 50ml tube.*)
					volume>1.9Milliliter&&volume<50Milliliter,
					PreferredContainer[50Milliliter,LiquidHandlerCompatible->True],

					(* If the volume is too large, an error was thrown earlier. We don't bother aliquotting *)
					True,Null
				]
			],
			{simulatedSampleContainerModels,volumePerSamplesIn}
		];





		(* Resolve Aliquot Options *)
		{resolvedAliquotOptions,aliquotTests}=If[gatherTests,
			(* We are allowing solid sample here because of coated samples. We have a separate solid sample check.*)
			resolveAliquotOptions[ExperimentELISA,mySamples,simulatedSamples,ReplaceRule[myOptions,Flatten[{resolvedSamplePrepOptions,NumberOfReplicates->resolvedNumberOfReplicates}]],Cache->simulatedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->volumePerSamplesIn,Output->{Result,Tests},AllowSolids->True],
			{resolveAliquotOptions[ExperimentELISA,mySamples,simulatedSamples,ReplaceRule[myOptions,Flatten[{resolvedSamplePrepOptions,NumberOfReplicates->resolvedNumberOfReplicates}]],Cache->simulatedCache,Simulation->updatedSimulation,RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->volumePerSamplesIn,Output->{Result},AllowSolids->True],{}}
		];

		preCoatedSampleConflictingAliquotOptions={}
	]; (*END IF*)

	(* Post Process the aliquot options *)
	(* Define the aliquot options to be rounded *)
	aliquotOptionsToBeRounded = {
		AssayVolume,
		AliquotAmount
	};

	(* Define the aliquot precisions *)
	aliquotPrecisions = {10^-1 Microliter,10^-1 Microliter};

	(* Round the aliquot options *)
	roundedAliquotOptions = Normal[RoundOptionPrecision[Association@resolvedAliquotOptions,aliquotOptionsToBeRounded,aliquotPrecisions],Association];
	
	(*---Resolve Preread Options ---*)


	(* First check if user implied Preread *)
	resolvedPrereadBeforeStop=If[
		MatchQ[suppliedPrereadBeforeStop,Except[Automatic]],
		
		(* if user specified a value, we use what user specified *)
		suppliedPrereadBeforeStop,
		
		(* else if user specified either or both PrereadTimepoints and PrereadAbsorbanceWavelength, we resolve this to true*)
		Or[MatchQ[suppliedPrereadTimepoints,Except[Automatic|Null]],MatchQ[suppliedPrereadAbsorbanceWavelength,Except[Automatic|Null]]]
	];

	(* resolve PrereadTimepoints*)
	resolvedPrereadTimepoints=If[
		MatchQ[suppliedPrereadTimepoints,Except[Automatic]],
		
		(* use user specified value if user specified non Null or Automatic value *)
		suppliedPrereadTimepoints,
		
		(* Else resolved based on substrate incubate time *)
		If[
			resolvedPrereadBeforeStop,
			{suppliedSubstrateIncubationTime/2},
			Null
		]
		
	];
	
	(* resolve PrereadTimepoints*)
	resolvedPrereadAbsorbanceWavelength=If[
		MatchQ[suppliedPrereadAbsorbanceWavelength,Except[Automatic]],
		
		(* use user specified value if user specified non Null or Automatic value *)
		suppliedPrereadAbsorbanceWavelength,
		
		(* Else resolved based on substrate incubate time *)
		If[
			resolvedPrereadBeforeStop,
			{450 Nanometer},
			Null
		]
	];
	
	(* check if PrereadTimepoits are within the SubstrateIncubation time *)
	invalidPreparedTimepoints=Cases[resolvedPrereadTimepoints,(GreaterP[suppliedSubstrateIncubationTime]|LessEqualP[0Minute])];
	
	(* Through message if we have invalid PrereadTimepoints *)
	invalidPreparedTimepointsOptions=If[Length[invalidPreparedTimepoints]>0,
		Message[Error::ELISAInvalidPrereadTimepoints,invalidPreparedTimepoints, suppliedSubstrateIncubationTime];{PrereadTimepoints}
	];
	
	(* Throw a test for PrereadTimepoints if gather test*)
	invalidPreparedTimepointTests=If[
		gatherTests,
		Test["The Prereadpoints before the addition of the StopSolution are valid:",(Length[invalidPreparedTimepoints]==0),True]
	];
	
	(* Inconsistent PrereadBeforeStop with related options *)
	invalidPrereadOptions=If[
		resolvedPrereadBeforeStop,
		
		(* for Preresolved options, if the master switch if true, the two options cannot be null*)
		PickList[{PrereadTimepoints,PrereadAbsorbanceWavelength},{resolvedPrereadTimepoints,resolvedPrereadAbsorbanceWavelength},Null],
		
		PickList[{PrereadTimepoints,PrereadAbsorbanceWavelength},{resolvedPrereadTimepoints,resolvedPrereadAbsorbanceWavelength},Except[Null]]
	
	];
	
	
	(* Through message if we have invalid PrereadTimepoints *)
	If[Length[invalidPrereadOptions]>0,
		Message[
			Error::ELISAInvalidPrereadOptions,
			resolvedPrereadBeforeStop,
			invalidPrereadOptions,
			If[
				resolvedPrereadBeforeStop,
				" PrereadTimepoints and PrereadAbsorbanceWavelength are not Null",
				" PrereadTimepoints and PrereadAbsorbanceWavelength are both Null or Automatic"
			]
		]
	];
	
	(* Throw a test for PrereadTimepoints if gather test*)
	invalidPreparedTests=If[
		gatherTests,
		Test["The Preread options are consistent with PrereadBeforeStop:",(Length[invalidPrereadOptions]==0),True]
	];
	
	
	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* resolve the Email option if Automatic *)
	resolvedEmail=If[!MatchQ[Lookup[allOptionsRoundedAssociation,Email],Automatic],
		(* If Email!=Automatic, use the supplied value *)
		Lookup[allOptionsRoundedAssociation,Email],
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[TrueQ[Lookup[allOptionsRoundedAssociation,Upload]],MemberQ[outputSpecification,Result]],
			True,
			False
		]
	];

	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs=DeleteCases[DeleteDuplicates[Flatten[{discardedInvalidInputs,nonLiquidSampleInvalidInputs,containerlessInvalidInputs,noVolumeInvalidInputs,incompatibleContainerSamples}]],Null];

	invalidOptions=DeleteCases[
		DeleteDuplicates[
			Flatten[
				{
					standardConflictingUnullOptions,
					blankConflictingUnullOptions,
					methodConflictingUnullOptionsAll,
					methodConflictingNullOptionsAll,
					methodEitherOrConflictingOptions,
					methodEitherOrStandardConflictingOptions,
					methodEitherOrBlankConflictingOptions,
					methodConflictingSampleAntibodyIncubationConflictingOption,
					sampleAntibodyComplexIncubationSwitchConflictingOptions,
					coatingBlockingConflictingUnullOptions,
					coatingBlockingConflictingNullOptions,
					coatingAndMethodConflictingUnullOptions,
					coatingAndMethodConflictingNullOptions,
					coatingAndMethodConflictingStandardUnullOptions,
					coatingAndMethodConflictingStandardNullOptions,
					coatingAndMethodConflictingBlankUnullOptions,
					coatingAndMethodConflictingBlankNullOptions,
					coatingAndMethodConflictingDilutionOptions,
					coatingAndMethodConflictingDilutionStandardOptions,
					coatingAndMethodConflictingDilutionBlankOptions,
					substrateSolutionSameNullSameNullConflictingOptions,
					stopSolutionSameNullConflictingOptions,
					standardSubstrateSolutionSameNullConflictingOptions,
					standardStopSolutionSameNullConflictingOptions,
					blankSubstrateSolutionSameNullConflictingOptions,
					blankStopSolutionSameNullConflictingOptions,
					standardDilutionCurveConflictingOptions,
					standardDiluentConflictingOptions,
					sampleDilutionCurveConflictingOptions,
					SampleDiluentConflictingOptions,
					unresolvableOptionList,
					elisaIncompatibleContainerConflictingOptions,
					spikeSameNullConflictingOptions,
					spikeDilutionCurveConflictingOption,
					primaryAntibodyPipettingConflictOptions,
					secondaryAntibodyPipettingConflictOptions,
					coatingAntibodyPipettingConflictOptions,
					captureAntibodyPipettingConflictOptions,
					referenceAntigenPipettingConflictOptions,
					spikePipettingConflictOptions,
					dilutionCurvesConflictingOptions,
					wellNumberConflictOptions,
					assignmentMatchingConflictOptions,
					preCoatedSampleConflictingAliquotOptions,
					dilutionCurveOverflowOptions,
					volumeIncompatibleOptions,
					volumeTooLargeOptions,
					coatedAssignmentMatchingConflictOptions,
					standardBlankReagentSampleSublistConflictingOptions,
					objectModelMutualExclusiveConflictingOptions,
					invalidPreparedTimepointsOptions,
					invalidPrereadOptions
				}
			]
		],
		Null
	];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation->updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*--------Gather options and tests-------------*)

	(* Return resolved options and/or tests. *)
	resolvedOptions = ReplaceRule[
		myOptions,
		Flatten[{
			Method->suppliedMethod,
			TargetAntigen->resolvedTargetAntigen,
			NumberOfReplicates->resolvedNumberOfReplicates,
			WashingBuffer->suppliedWashingBuffer,
			Spike->suppliedSpike,
			SpikeDilutionFactor->resolvedSpikeDilutionFactor,
			SpikeStorageCondition->resolvedSpikeStorageCondition,
			SampleSerialDilutionCurve->resolvedSampleSerialDilutionCurve,
			SampleDilutionCurve->resolvedSampleDilutionCurve,
			SampleDiluent->resolvedSampleDiluent,
			CoatingAntibody->resolvedCoatingAntibody,
			CoatingAntibodyDilutionFactor->resolvedCoatingAntibodyDilutionFactor,
			CoatingAntibodyVolume->suppliedCoatingAntibodyVolume,
			CoatingAntibodyDiluent->resolvedCoatingAntibodyDiluent,
			CoatingAntibodyStorageCondition->resolvedCoatingAntibodyStorageCondition,
			CaptureAntibody->resolvedCaptureAntibody,
			CaptureAntibodyDilutionFactor->resolvedCaptureAntibodyDilutionFactor,
			CaptureAntibodyVolume->suppliedCaptureAntibodyVolume,
			CaptureAntibodyDiluent->resolvedCaptureAntibodyDiluent,
			CaptureAntibodyStorageCondition->resolvedCaptureAntibodyStorageCondition,
			ReferenceAntigen->resolvedReferenceAntigen,
			ReferenceAntigenDilutionFactor->resolvedReferenceAntigenDilutionFactor,
			ReferenceAntigenVolume->suppliedReferenceAntigenVolume,
			ReferenceAntigenDiluent->resolvedReferenceAntigenDiluent,
			ReferenceAntigenStorageCondition->resolvedReferenceAntigenStorageCondition,
			PrimaryAntibody->resolvedPrimaryAntibody,
			PrimaryAntibodyDilutionFactor->resolvedPrimaryAntibodyDilutionFactor,
			PrimaryAntibodyVolume->suppliedPrimaryAntibodyVolume,
			PrimaryAntibodyDiluent->resolvedPrimaryAntibodyDiluent,
			PrimaryAntibodyStorageCondition->suppliedPrimaryAntibodyStorageCondition,
			SecondaryAntibody->resolvedSecondaryAntibody,
			SecondaryAntibodyDilutionFactor->resolvedSecondaryAntibodyDilutionFactor,
			SecondaryAntibodyVolume->sampleSecondaryAntibodyVolumes,
			SecondaryAntibodyDiluent->resolvedSecondaryAntibodyDiluent,
			SecondaryAntibodyDilutionOnDeck -> resolvedSecondaryAntibodyDilutionOnDeck,
			SecondaryAntibodyStorageCondition->resolvedSecondaryAntibodyStorageCondition,
			SampleAntibodyComplexIncubation->resolvedSampleAntibodyComplexIncubation,
			SampleAntibodyComplexIncubationTime->resolvedSampleAntibodyComplexIncubationTime,
			SampleAntibodyComplexIncubationTemperature->resolvedSampleAntibodyComplexIncubationTemperature,
			Coating->suppliedCoating,
			SampleCoatingVolume->resolvedSampleCoatingVolume,
			CoatingAntibodyCoatingVolume->resolvedCoatingAntibodyCoatingVolume,
			ReferenceAntigenCoatingVolume->resolvedReferenceAntigenCoatingVolume,
			CaptureAntibodyCoatingVolume->resolvedCaptureAntibodyCoatingVolume,
			CoatingTemperature->resolvedCoatingTemperature,
			CoatingTime->resolvedCoatingTime,
			CoatingWashVolume->resolvedCoatingWashVolume,
			CoatingNumberOfWashes->resolvedCoatingNumberOfWashes,
			Blocking->suppliedBlocking,
			BlockingBuffer->resolvedBlockingBuffer,
			BlockingVolume->resolvedBlockingVolume,
			BlockingTemperature->resolvedBlockingTemperature,
			BlockingTime->resolvedBlockingTime,
			BlockingMixRate->suppliedBlockingMixRate,
			BlockingWashVolume->resolvedBlockingWashVolume,
			BlockingNumberOfWashes->resolvedBlockingNumberOfWashes,
			SampleAntibodyComplexImmunosorbentVolume->resolvedSampleAntibodyComplexImmunosorbentVolume,
			SampleAntibodyComplexImmunosorbentTime->resolvedSampleAntibodyComplexImmunosorbentTime,
			SampleAntibodyComplexImmunosorbentTemperature->resolvedSampleAntibodyComplexImmunosorbentTemperature,
			SampleAntibodyComplexImmunosorbentMixRate->suppliedSampleAntibodyComplexImmunosorbentMixRate,
			SampleAntibodyComplexImmunosorbentWashVolume->resolvedSampleAntibodyComplexImmunosorbentWashVolume,
			SampleAntibodyComplexImmunosorbentNumberOfWashes->resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,
			SampleImmunosorbentVolume->resolvedSampleImmunosorbentVolume,
			SampleImmunosorbentTime->resolvedSampleImmunosorbentTime,
			SampleImmunosorbentTemperature->resolvedSampleImmunosorbentTemperature,
			SampleImmunosorbentMixRate->suppliedSampleImmunosorbentMixRate,
			SampleImmunosorbentWashVolume->resolvedSampleImmunosorbentWashVolume,
			SampleImmunosorbentNumberOfWashes->resolvedSampleImmunosorbentNumberOfWashes,
			PrimaryAntibodyImmunosorbentVolume->resolvedPrimaryAntibodyImmunosorbentVolume,
			PrimaryAntibodyImmunosorbentTime->resolvedPrimaryAntibodyImmunosorbentTime,
			PrimaryAntibodyImmunosorbentTemperature->resolvedPrimaryAntibodyImmunosorbentTemperature,
			PrimaryAntibodyImmunosorbentMixRate->suppliedPrimaryAntibodyImmunosorbentMixRate,
			PrimaryAntibodyImmunosorbentWashing->resolvedPrimaryAntibodyImmunosorbentWashing,
			PrimaryAntibodyImmunosorbentWashVolume->resolvedPrimaryAntibodyImmunosorbentWashVolume,
			PrimaryAntibodyImmunosorbentNumberOfWashes->resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,
			SecondaryAntibodyImmunosorbentVolume->resolvedSecondaryAntibodyImmunosorbentVolume,
			SecondaryAntibodyImmunosorbentTime->resolvedSecondaryAntibodyImmunosorbentTime,
			SecondaryAntibodyImmunosorbentTemperature->resolvedSecondaryAntibodyImmunosorbentTemperature,
			SecondaryAntibodyImmunosorbentMixRate->suppliedSecondaryAntibodyImmunosorbentMixRate,
			SecondaryAntibodyImmunosorbentWashing->resolvedSecondaryAntibodyImmunosorbentWashing,
			SecondaryAntibodyImmunosorbentWashVolume->resolvedSecondaryAntibodyImmunosorbentWashVolume,
			SecondaryAntibodyImmunosorbentNumberOfWashes->resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,
			SubstrateSolution->resolvedSubstrateSolution,
			StopSolution->resolvedStopSolution,
			SubstrateSolutionVolume->resolvedSubstrateSolutionVolume,
			StopSolutionVolume->resolvedStopSolutionVolume,
			SubstrateIncubationTime->suppliedSubstrateIncubationTime,
			SubstrateIncubationTemperature->suppliedSubstrateIncubationTemperature,
			SubstrateIncubationMixRate->suppliedSubstrateIncubationMixRate,
			PrereadBeforeStop->resolvedPrereadBeforeStop,
			PrereadTimepoints->resolvedPrereadTimepoints,
			PrereadAbsorbanceWavelength->resolvedPrereadAbsorbanceWavelength,
			AbsorbanceWavelength->suppliedAbsorbanceWavelength,
			SignalCorrection->suppliedSignalCorrection,
			Standard->resolvedStandard,
			StandardTargetAntigen->resolvedStandardTargetAntigen,
			StandardSerialDilutionCurve->resolvedStandardSerialDilutionCurve,
			StandardDilutionCurve->resolvedStandardDilutionCurve,
			StandardDiluent->resolvedStandardDiluent,
			StandardStorageCondition->resolvedStandardStorageCondition,
			StandardCoatingAntibody->resolvedStandardCoatingAntibody,
			StandardCoatingAntibodyDilutionFactor->resolvedStandardCoatingAntibodyDilutionFactor,
			StandardCoatingAntibodyVolume->suppliedStandardCoatingAntibodyVolume,
			StandardCaptureAntibody->resolvedStandardCaptureAntibody,
			StandardCaptureAntibodyDilutionFactor->resolvedStandardCaptureAntibodyDilutionFactor,
			StandardCaptureAntibodyVolume->suppliedStandardCaptureAntibodyVolume,
			StandardReferenceAntigen->resolvedStandardReferenceAntigen,
			StandardReferenceAntigenDilutionFactor->resolvedStandardReferenceAntigenDilutionFactor,
			StandardReferenceAntigenVolume->suppliedStandardReferenceAntigenVolume,
			StandardPrimaryAntibody->resolvedStandardPrimaryAntibody,
			StandardPrimaryAntibodyDilutionFactor->resolvedStandardPrimaryAntibodyDilutionFactor,
			StandardPrimaryAntibodyVolume->suppliedStandardPrimaryAntibodyVolume,
			StandardSecondaryAntibody->resolvedStandardSecondaryAntibody,
			StandardSecondaryAntibodyDilutionFactor->resolvedStandardSecondaryAntibodyDilutionFactor,
			StandardSecondaryAntibodyVolume->resolvedStandardSecondaryAntibodyVolumes,
			StandardCoatingVolume->resolvedStandardCoatingVolume,
			StandardReferenceAntigenCoatingVolume->resolvedStandardReferenceAntigenCoatingVolume,
			StandardCoatingAntibodyCoatingVolume->resolvedStandardCoatingAntibodyCoatingVolume,
			StandardCaptureAntibodyCoatingVolume->resolvedStandardCaptureAntibodyCoatingVolume,
			StandardBlockingVolume->resolvedStandardBlockingVolume,
			StandardAntibodyComplexImmunosorbentVolume->resolvedStandardAntibodyComplexImmunosorbentVolume,
			StandardImmunosorbentVolume->resolvedStandardImmunosorbentVolume,
			StandardPrimaryAntibodyImmunosorbentVolume->resolvedStandardPrimaryAntibodyImmunosorbentVolume,
			StandardSecondaryAntibodyImmunosorbentVolume->resolvedStandardSecondaryAntibodyImmunosorbentVolume,
			StandardSubstrateSolution->resolvedStandardSubstrateSolution,
			StandardStopSolution->resolvedStandardStopSolution,
			StandardSubstrateSolutionVolume->resolvedStandardSubstrateSolutionVolume,
			StandardStopSolutionVolume->resolvedStandardStopSolutionVolume,
			Blank->resolvedBlank,
			BlankTargetAntigen->resolvedBlankTargetAntigen,
			BlankStorageCondition->resolvedBlankStorageCondition,
			BlankCoatingAntibody->resolvedBlankCoatingAntibody,
			BlankCoatingAntibodyDilutionFactor->resolvedBlankCoatingAntibodyDilutionFactor,
			BlankCoatingAntibodyVolume->suppliedBlankCoatingAntibodyVolume,
			BlankCaptureAntibody->resolvedBlankCaptureAntibody,
			BlankCaptureAntibodyDilutionFactor->resolvedBlankCaptureAntibodyDilutionFactor,
			BlankCaptureAntibodyVolume->suppliedBlankCaptureAntibodyVolume,
			BlankReferenceAntigen->resolvedBlankReferenceAntigen,
			BlankReferenceAntigenDilutionFactor->resolvedBlankReferenceAntigenDilutionFactor,
			BlankReferenceAntigenVolume->suppliedBlankReferenceAntigenVolume,
			BlankPrimaryAntibody->resolvedBlankPrimaryAntibody,
			BlankPrimaryAntibodyDilutionFactor->resolvedBlankPrimaryAntibodyDilutionFactor,
			BlankPrimaryAntibodyVolume->suppliedBlankPrimaryAntibodyVolume,
			BlankSecondaryAntibody->resolvedBlankSecondaryAntibody,
			BlankSecondaryAntibodyDilutionFactor->resolvedBlankSecondaryAntibodyDilutionFactor,
			BlankSecondaryAntibodyVolume->resolvedBlankSecondaryAntibodyVolumes,
			BlankCoatingVolume->resolvedBlankCoatingVolume,
			BlankReferenceAntigenCoatingVolume->resolvedBlankReferenceAntigenCoatingVolume,
			BlankCoatingAntibodyCoatingVolume->resolvedBlankCoatingAntibodyCoatingVolume,
			BlankCaptureAntibodyCoatingVolume->resolvedBlankCaptureAntibodyCoatingVolume,
			BlankBlockingVolume->resolvedBlankBlockingVolume,
			BlankAntibodyComplexImmunosorbentVolume->resolvedBlankAntibodyComplexImmunosorbentVolume,
			BlankImmunosorbentVolume->resolvedBlankImmunosorbentVolume,
			BlankPrimaryAntibodyImmunosorbentVolume->resolvedBlankPrimaryAntibodyImmunosorbentVolume,
			BlankSecondaryAntibodyImmunosorbentVolume->resolvedBlankSecondaryAntibodyImmunosorbentVolume,
			BlankSubstrateSolution->resolvedBlankSubstrateSolution,
			BlankStopSolution->resolvedBlankStopSolution,
			BlankSubstrateSolutionVolume->resolvedBlankSubstrateSolutionVolume,
			BlankStopSolutionVolume->resolvedBlankStopSolutionVolume,
			ELISAPlate->resolvedELISAPlate,
			SecondaryELISAPlate->resolvedSecondaryELISAPlate,
			ELISAPlateAssignment->resolvedELISAPlateAssignment,
			SecondaryELISAPlateAssignment->resolvedSecondaryELISAPlateAssignment/.{}->Null,
			SamplesInStorageCondition->Lookup[allOptionsRoundedAssociation,SamplesInStorageCondition],
			Cache->Lookup[allOptionsRoundedAssociation,Cache],
			FastTrack->Lookup[allOptionsRoundedAssociation,FastTrack],
			Template->Lookup[allOptionsRoundedAssociation,Template],
			ParentProtocol->Lookup[allOptionsRoundedAssociation,ParentProtocol],
			Operator->Lookup[allOptionsRoundedAssociation,Operator],
			Confirm->Lookup[allOptionsRoundedAssociation,Confirm],
			CanaryBranch->Lookup[allOptionsRoundedAssociation,CanaryBranch],
			Name->Lookup[allOptionsRoundedAssociation,Name],
			Upload->Lookup[allOptionsRoundedAssociation,Upload],
			Output->Lookup[allOptionsRoundedAssociation,Output],
			ParentProtocol->Lookup[allOptionsRoundedAssociation,ParentProtocol],
			Priority->Lookup[allOptionsRoundedAssociation,Priority],
			StartDate->Lookup[allOptionsRoundedAssociation,StartDate],
			HoldOrder->Lookup[allOptionsRoundedAssociation,HoldOrder],
			QueuePosition->Lookup[allOptionsRoundedAssociation,QueuePosition],
			PreparatoryUnitOperations->Lookup[allOptionsRoundedAssociation,PreparatoryUnitOperations],
			Email->resolvedEmail,
			resolvedSamplePrepOptions,
			roundedAliquotOptions,
			resolvedPostProcessingOptions
		}]
	];



	(*A bunch of variables to pass down to the resource packet*)
	resolverPassDowns=Association[
		"passDownPipettingError"->pipettingError,
		"passDownSampleTotalVolumes"->volumePerSamplesIn,
		"passDownRoundedTransformedStandardDilutionCurve"->roundedTransformedStandardDilutionCurve,
		"passDownRoundedTransformedStandardSerialDilutionCurve"->roundedTransformedStandardSerialDilutionCurve,
		"passDownRoundedTransformedSampleDilutionCurve"->roundedTransformedSampleDilutionCurve,
		"passDownRoundedTransformedSampleSerialDilutionCurve"->roundedTransformedSampleSerialDilutionCurve,
		"passDownSpikeVolumes"->spikeVolumes,
		"passDownJoinedPrimaryAntibodies"->curveExpandedJoinedPrimaryAntibodies,
		"passDownJoinedPrimaryAntibodyAssayVolumes"->curveExpandedJoinedPrimaryAntibodyAssayVolumes,
		"passDownCombinedPrimaryAntibodyVolumes"->curveExpandedCombinedPrimaryAntibodyVolumes,
		"passDownCombinedPrimaryAntibodyWithFactors"->curveExpandedCombinedPrimaryAntibodyWithFactors,
		"passDownJoinedSecondaryAntibodies"->curveExpandedJoinedSecondaryAntibodies,
		"passDownJoinedSecondaryAntibodyAssayVolumes"->curveExpandedJoinedSecondaryAntibodyAssayVolumes,
		"passDownCombinedSecondaryAntibodyVolumes"->curveExpandedCombinedSecondaryAntibodyVolumes,
		"passDownCombinedSecondaryAntibodyWithFactors"->curveExpandedCombinedSecondaryAntibodyWithFactors,
		"passDownJoinedCoatingAntibodies"->curveExpandedJoinedCoatingAntibodies,
		"passDownJoinedCoatingAntibodyAssayVolumes"->curveExpandedJoinedCoatingAntibodyAssayVolumes,
		"passDownCombinedCoatingAntibodyVolumes"->curveExpandedCombinedCoatingAntibodyVolumes,
		"passDownCombinedCoatingAntibodyWithFactors"->curveExpandedCombinedCoatingAntibodyWithFactors,
		"passDownJoinedCaptureAntibodies"->curveExpandedJoinedCaptureAntibodies,
		"passDownJoinedCaptureAntibodyAssayVolumes"->curveExpandedJoinedCaptureAntibodyAssayVolumes,
		"passDownCombinedCaptureAntibodyVolumes"->curveExpandedCombinedCaptureAntibodyVolumes,
		"passDownCombinedCaptureAntibodyWithFactors"->curveExpandedCombinedCaptureAntibodyWithFactors,
		"passDownJoinedReferenceAntigens"->curveExpandedJoinedReferenceAntigens,
		"passDownJoinedReferenceAntigenAssayVolumes"->curveExpandedJoinedReferenceAntigenAssayVolumes,
		"passDownCombinedReferenceAntigenVolumes"->curveExpandedCombinedReferenceAntigenVolumes,
		"passDownCombinedReferenceAntigenWithFactors"->curveExpandedCombinedReferenceAntigenWithFactors,
		"passDownRequiredAliquotAmounts"->volumePerSamplesIn,
		"passDownResolvedPrimaryAssignmentTableCounts"->resolvedPrimaryAssignmentTableCounts,
		"passDownResolvedSecondaryAssignmentTableCounts"->resolvedSecondaryAssignmentTableCounts,
		"passDownJoinedAssignmentTable"->joinedAssignmentTable,
		"passDownJoinedCurveExpansionParams"->joinedCurveExpansionParams
	];


	allTests=DeleteCases[
		Flatten[
			{
				samplePrepTests,
				discardedTests,
				nonLiquidSampleTests,
				precisionTests,
				standardConflictingUnullTests,
				blankConflictingUnullTests,
				methodConflictingUnullTests,
				methodConflictingNullTests,
				methodEitherOrConflictingTests,
				methodEitherOrStandardConflictingTests,
				methodEitherOrBlankConflictingTests,
				coatingBlockingConflictingUnullTests,
				coatingBlockingConflictingNullTests,
				coatingAndMethodConflictingUnullTests,
				coatingAndMethodConflictingNullTests,
				coatingAndMethodConflictingStandardUnullTests,
				coatingAndMethodConflictingStandardNullTests,
				coatingAndMethodConflictingBlankUnullTests,
				coatingAndMethodConflictingBlankNullTests,
				coatingAndMethodConflictingDilutionOptionTests,
				coatingAndMethodConflictingDilutionStandardOptionTests,
				coatingAndMethodConflictingDilutionStandardOptionTests,
				coatingAndMethodConflictingDilutionBlankOptionTests,
				standardDilutionCurveConflictingTests,
				sampleDilutionCurveConflictingTests,
				SampleDiluentConflictingTest,
				unresolvableIndexMatchedOptionsTests,
				aliquotTests,
				dilutionCurveSufficientPipettingVolumesTests,
				spikeSameNullConflictingTest,
				primaryAntibodySufficientPipettingVolumesTest,
				secondaryAntibodySufficientPipettingVolumesTest,
				coatingAntibodySufficientPipettingVolumesTest,
				captureAntibodySufficientPipettingVolumesTest,
				referenceAntigenSufficientPipettingVolumesTest,
				spikeSufficientPipettingVolumesTest,
				spikedSampleDilutionCurveConflictingTest,
				coatedAssignmentMatchesTest,
				containerlessTests,
				noVolumeTests,
				standardBlankReagentSampleSublistConflictingTests,
				precoatedSamplesIncompatibleContainersTests,
				ojbectModelMutualExclusiveConflictingTests,
				invalidPreparedTimepointTests,
				invalidPreparedTests
			}
		],
		(Null|{}|{Null..})
	];

	{
		outputSpecification/.{Result->resolvedOptions,Tests->allTests},
		resolverPassDowns
	}
];



(*=========================================================*)
(*================Generate Resource Packet=================*)
(*=========================================================*)
(* ::Subsubsection::Closed:: *)
DefineOptions[
	elisaResourcePackets,
	Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

elisaResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule},resolverPassDowns_Association,ops:OptionsPattern[]]:=Module[
	{
		expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,outputSpecification,output,gatherTests,messages,inheritedCache,simulation, resolvedMethod,resolvedTargetAntigen,resolvedNumberOfReplicates,resolvedWashingBuffer,resolvedCoatingAntibody,resolvedCoatingAntibodyDilutionFactor,resolvedCoatingAntibodyVolume,resolvedCoatingAntibodyDiluent,resolvedCoatingAntibodyStorageCondition,resolvedCaptureAntibody,resolvedCaptureAntibodyDilutionFactor,resolvedCaptureAntibodyVolume,resolvedCaptureAntibodyDiluent,resolvedCaptureAntibodyStorageCondition,resolvedReferenceAntigen,resolvedReferenceAntigenDilutionFactor,resolvedReferenceAntigenVolume,resolvedReferenceAntigenDiluent,resolvedReferenceAntigenStorageCondition,resolvedPrimaryAntibody,resolvedPrimaryAntibodyDilutionFactor,resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDiluent,resolvedPrimaryAntibodyStorageCondition,resolvedSecondaryAntibody,resolvedSecondaryAntibodyDilutionFactor,resolvedSecondaryAntibodyVolume,resolvedSecondaryAntibodyDiluent,resolvedSecondaryAntibodyStorageCondition,resolvedSampleAntibodyComplexIncubation,resolvedSampleAntibodyComplexIncubationTime,resolvedSampleAntibodyComplexIncubationTemperature,resolvedCoating,resolvedSampleCoatingVolume,resolvedCoatingAntibodyCoatingVolume,resolvedReferenceAntigenCoatingVolume,resolvedCaptureAntibodyCoatingVolume,resolvedCoatingTemperature,resolvedCoatingTime,resolvedCoatingWashVolume,resolvedCoatingNumberOfWashes,resolvedBlocking,resolvedBlockingBuffer,resolvedBlockingVolume,resolvedBlockingTemperature,resolvedBlockingTime,resolvedBlockingWashVolume,resolvedBlockingNumberOfWashes,resolvedSampleAntibodyComplexImmunosorbentVolume,resolvedSampleAntibodyComplexImmunosorbentTime,resolvedSampleAntibodyComplexImmunosorbentTemperature,resolvedSampleAntibodyComplexImmunosorbentWashVolume,resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,resolvedSampleImmunosorbentVolume,resolvedSampleImmunosorbentTime,resolvedSampleImmunosorbentTemperature,resolvedSampleImmunosorbentMixRate,resolvedSampleImmunosorbentWashVolume,resolvedSampleImmunosorbentNumberOfWashes,resolvedPrimaryAntibodyImmunosorbentVolume,resolvedPrimaryAntibodyImmunosorbentTime,resolvedPrimaryAntibodyImmunosorbentTemperature,resolvedPrimaryAntibodyImmunosorbentMixRate,resolvedPrimaryAntibodyImmunosorbentWashVolume,resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,resolvedSecondaryAntibodyImmunosorbentVolume,resolvedSecondaryAntibodyImmunosorbentTime,resolvedSecondaryAntibodyImmunosorbentTemperature,resolvedSecondaryAntibodyImmunosorbentMixRate,resolvedSecondaryAntibodyImmunosorbentWashVolume,resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,resolvedSubstrateSolution,resolvedStopSolution,resolvedSubstrateSolutionVolume,resolvedStopSolutionVolume,resolvedSubstrateIncubationTime,resolvedSubstrateIncubationTemperature,resolvedSubstrateIncubationMixRate,resolvedAbsorbanceWavelength,resolvedSignalCorrection,resolvedStandard,resolvedStandardTargetAntigen,resolvedStandardDilutionCurve,resolvedStandardSerialDilutionCurve,resolvedStandardDiluent,resolvedStandardStorageCondition,resolvedStandardCoatingAntibody,resolvedStandardCoatingAntibodyDilutionFactor,resolvedStandardCoatingAntibodyVolume,resolvedStandardCaptureAntibody,resolvedStandardCaptureAntibodyDilutionFactor,resolvedStandardCaptureAntibodyVolume,resolvedStandardReferenceAntigen,resolvedStandardReferenceAntigenDilutionFactor,resolvedStandardReferenceAntigenVolume,resolvedStandardPrimaryAntibody,resolvedStandardPrimaryAntibodyDilutionFactor,resolvedStandardPrimaryAntibodyVolume,resolvedStandardSecondaryAntibody,resolvedStandardSecondaryAntibodyDilutionFactor,resolvedStandardSecondaryAntibodyVolume,resolvedStandardCoatingVolume,resolvedStandardReferenceAntigenCoatingVolume,resolvedStandardCoatingAntibodyCoatingVolume,resolvedStandardCaptureAntibodyCoatingVolume,resolvedStandardBlockingVolume,resolvedStandardAntibodyComplexImmunosorbentVolume,resolvedStandardImmunosorbentVolume,resolvedStandardPrimaryAntibodyImmunosorbentVolume,resolvedStandardSecondaryAntibodyImmunosorbentVolume,resolvedStandardSubstrateSolution,resolvedStandardStopSolution,resolvedStandardSubstrateSolutionVolume,resolvedStandardStopSolutionVolume,resolvedBlank,resolvedBlankTargetAntigen,resolvedBlankCoatingAntibody,resolvedBlankCoatingAntibodyDilutionFactor,resolvedBlankCoatingAntibodyVolume,resolvedBlankCaptureAntibody,resolvedBlankCaptureAntibodyDilutionFactor,resolvedBlankCaptureAntibodyVolume,resolvedBlankReferenceAntigen,resolvedBlankReferenceAntigenDilutionFactor,resolvedBlankReferenceAntigenVolume,resolvedBlankPrimaryAntibody,resolvedBlankPrimaryAntibodyDilutionFactor,resolvedBlankPrimaryAntibodyVolume,resolvedBlankSecondaryAntibody,resolvedBlankSecondaryAntibodyDilutionFactor,resolvedBlankSecondaryAntibodyVolume,resolvedBlankCoatingVolume,resolvedBlankReferenceAntigenCoatingVolume,resolvedBlankCoatingAntibodyCoatingVolume,resolvedBlankCaptureAntibodyCoatingVolume,resolvedBlankBlockingVolume,resolvedBlankAntibodyComplexImmunosorbentVolume,resolvedBlankImmunosorbentVolume,resolvedBlankPrimaryAntibodyImmunosorbentVolume,resolvedBlankSecondaryAntibodyImmunosorbentVolume,resolvedBlankSubstrateSolution,resolvedBlankStopSolution,resolvedBlankSubstrateSolutionVolume,resolvedBlankStopSolutionVolume,resolvedSpike,resolvedSpikeDilutionFactor,resolvedSampleDilutionCurve,resolvedSampleSerialDilutionCurve,resolvedSampleDiluent,resolvedELISAPlate,resolvedSecondaryELISAPlate,resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment,resolverPipettingError,resolverRoundedTransformedStandardDilutionCurve,resolverRoundedTransformedStandardSerialDilutionCurve,resolverRoundedTransformedSampleDilutionCurve,resolverRoundedTransformedSampleSerialDilutionCurve,resolverSpikeVolumes,resolverAllPrimaryAntibodies,resolverAllPrimaryAntibodyAssayVolumes,resolverAllPrimaryAntibodyVolumes,resolverAllSecondaryAntibodies,resolverAllSecondaryAntibodyAssayVolumes,resolverAllSecondaryAntibodyVolumes,resolverAllCoatingAntibodies,resolverAllCoatingAntibodyAssayVolumes,resolverAllCoatingAntibodyVolumes,resolverAllCaptureAntibodies,resolverAllCaptureAntibodyAssayVolumes,resolverAllCaptureAntibodyVolumes,resolverAllReferenceAntigens,resolverAllReferenceAntigenAssayVolumes,resolverAllReferenceAntigenVolumes,
		resolvedPrimaryAntibodyImmunosorbentWashing,resolvedSecondaryAntibodyImmunosorbentWashing,resolvedSecondaryAntibodyDilutionOnDeck,volumeLarger,sampleDiluentResource,sampleDiluentVolumeList,sampleDiluentVolume,spikeVolumesCombined,spikesDeDuplicates,spikeResources,standardResources,standardVolumeList,standardVolumesCombined,standardsDeDuplicates,standardDiluentResource,standardDiluentVolume,primaryAntibodyVolumesCombined,primaryAntibodyDeDuplicates,primaryAntibodyResources,primaryAntibodyDiluentResource,primaryAntibodyDiluentVolumeCombined,secondaryAntibodyVolumesCombined,secondaryAntibodyDeDuplicates,secondaryAntibodyResources,secondaryAntibodyDiluentVolumeCombined,secondaryAntibodyDiluentResource,captureAntibodyVolumesCombined,captureAntibodyDeDuplicates,captureAntibodyResources,captureAntibodyDiluentResource,captureAntibodyDiluentVolumeCombined,coatingAntibodyVolumesCombined,coatingAntibodyDeDuplicates,coatingAntibodyResources,coatingAntibodyDiluentResource,coatingAntibodyDiluentVolumeCombined,referenceAntigenVolumesCombined,referenceAntigenDeDuplicates,referenceAntigenResources,referenceAntigenDiluentResource,referenceAntigenDiluentVolumeCombined,blockingBufferResource,totalBlockingVolume,washVolumeList,TotalWashVolume,washingBufferResource,joinedDeNulledSubstrate,substrateVolumesCombined,substrateDeDuplicates,substrateResources,joinedDeNulledStopVolumes,joinedDeNulledStop,stopVolumesCombined,stopResources,stopDeDuplicates,elisaPlateResource,secondaryELISAPlateResource,sampleAssemblyQ,numAssemblyPlate,sampleAssemblyContainerResource,sampleAssemblyPlate,elisaListMerge,resolvedAliquotAmount,blankVolumes,blankResources,blankPrimaryAntibodyVolumes,blankCaptureAntibodyVolumes,standardDiluentVolumeList,joinedDeNulledSubstrateVolumes,resolverRequiredAliquotAmount,elisaContainerPicker,primaryAntibodyDilutionContainerResources,primaryAntibodyAssayVolumeCombined,primaryAntibodyAssayVolumeCombinedUndilutionToNull,secondaryAntibodyAssayVolumeCombined,secondaryAntibodyAssayVolumeCombinedUndilutionToNull,secondaryAntibodyDilutionContainerResources,captureAntibodyAssayVolumeCombined,captureAntibodyAssayVolumeCombinedUndilutionToNull,captureAntibodyDilutionContainerResources,coatingAntibodyAssayVolumeCombined,coatingAntibodyAssayVolumeCombinedUndilutionToNull,coatingAntibodyDilutionContainerResources,referenceAntigenAssayVolumeCombined,referenceAntigenAssayVolumeCombinedUndilutionToNull,referenceAntigenDilutionContainerResources,primaryAntibodyWorkingResources,secondaryAntibodyWorkingResources,captureAntibodyWorkingResources,coatingAntibodyWorkingResources,referenceAntigenWorkingResources,resolvedNumberOfReplicatesNullToOne,secondarySampleAssemblyContainerResource,runTime,resolverAllPrimaryAntibodiesWithFactors,resolverAllSecondaryAntibodiesWithFactors,resolverAllCoatingAntibodiesWithFactors,resolverAllCaptureAntibodiesWithFactors,resolverAllReferenceAntigensWithFactors,primaryAntibodiesWithFactorsDeDuplicates,primaryAntibodyWithFactorToWorkingResourceLookupTable,secondaryAntibodiesWithFactorsDeDuplicates,secondaryAntibodyWithFactorToWorkingResourceLookupTable,captureAntibodiesWithFactorsDeDuplicates,captureAntibodyWithFactorToWorkingResourceLookupTable,referenceAntigensWithFactorsDeDuplicates,referenceAntigenWithFactorToWorkingResourceLookupTable,elisaExtractResources,primaryAntibodyWorkingResourcesSampleIndexed,secondaryAntibodyWorkingResourcesSampleIndexed,coatingAntibodyWorkingResourcesSampleIndexed,captureAntibodyWorkingResourcesSampleIndexed,referenceAntigenWorkingResourcesSampleIndexed,primaryAntibodyWorkingResourcesStandardIndexed,secondaryAntibodyWorkingResourcesStandardIndexed,coatingAntibodyWorkingResourcesStandardIndexed,captureAntibodyWorkingResourcesStandardIndexed,referenceAntigenWorkingResourcesStandardIndexed,primaryAntibodyWorkingResourcesBlankIndexed,secondaryAntibodyWorkingResourcesBlankIndexed,coatingAntibodyWorkingResourcesBlankIndexed,captureAntibodyWorkingResourcesBlankIndexed,referenceAntigenWorkingResourcesBlankIndexed,sampleNumber,standardNumber,blankNumber,sampleRange,standardRange,blankRange,primaryAntibodyResourcesSampleIndexed,primaryAntibodyResourcesStandardIndexed,primaryAntibodyResourcesBlankIndexed,primaryAntibodyWorkingResourcesAllIndexed,secondaryAntibodyResourcesSampleIndexed,secondaryAntibodyResourcesStandardIndexed,secondaryAntibodyResourcesBlankIndexed,secondaryAntibodyWorkingResourcesAllIndexed,captureAntibodyResourcesSampleIndexed,captureAntibodyResourcesStandardIndexed,captureAntibodyResourcesBlankIndexed,captureAntibodyWorkingResourcesAllIndexed,coatingAntibodyResourcesSampleIndexed,coatingAntibodyResourcesStandardIndexed,coatingAntibodyResourcesBlankIndexed,referenceAntigenResourcesSampleIndexed,referenceAntigenResourcesStandardIndexed,referenceAntigenResourcesBlankIndexed,referenceAntigenWorkingResourcesAllIndexed,resolverPrimaryAssignmentTableCounts,resolverSecondaryAssignmentTableCounts,resolverAutoJoinedAssignmentTable,spikeResourcesSampleIndexed,joinedSamples,joinedAssayVolumes,joinedSpikeDilutionFactors,joinedSpikeVolumes,combinedDilutionCurves,serialDilutionQ,joinedSampleAssemblyVolumes,expandingParams,expanededJoinedAssayVolumes,expandedJoinedSamples,expandedJoinedDiluents,expandedJoinedSpikes,expandedJoinedSampleAssemblyVolumes,erroredExpandedJoinedSampleAssemblyVolumes,joinedAssignment,joinedAssemblyPositions,experimentPositionsLookupTable,joinedSampleAssemblyPositionsExpanded,joinedAssayPlatePositionsExpanded,serialQExpandingParams,expandedSerialQ,joinedPrimaryAntibodyWorkingResources,expandedPrimaryAntibodyWorkingResources,joinedSecondaryAntibodyWorkingResources,expandedSecondaryAntibodyWorkingResources,joinedCaptureAntibodyWorkingResources,expandedCaptureAntibodyWorkingResources,joinedCoatingAntibodyWorkingResources,expandedCoatingAntibodyWorkingResources,joinedReferenceAntigenWorkingResources,expandedReferenceAntigenWorkingResources,joinedSampleCoatingVolumes,expandedSampleCoatingVolumes,joinedCoatingAntibodyCoatingVolumes,expandedCoatingAntibodyCoatingVolumes,joinedReferenceAntigenCoatingVolumes,expandedReferenceAntigenCoatingVolumes,joinedSampleImmunosorbentVolumes,expandedSampleImmunosorbentVolumes,joinedSampleAntibodyComplexImmunosorbentVolumes,expandedSampleAntibodyComplexImmunosorbentVolumes,joinedPrimaryAntibodyImmunosorbentVolumes,expandedPrimaryAntibodyImmunosorbentVolumes,joinedSecondaryAntibodyImmunosorbentVolumes,expandedSecondaryAntibodyImmunosorbentVolumes,joinedSubstrates,expandedSubstrates,joinedStops,expandedStops,joinedSubstrateVolumes,expandedSubstrateVolumes,joinedStopVolumes,expandedStopVolumes,joinedBlockVolumes,expandedBlockVolumes,antibodyAntigenDilutionQ,substrateResourcesSampleIndexed,substrateResourcesStandardIndexed,substrateResourcesBlankIndexed,stopResourcesSampleIndexed,stopResourcesStandardIndexed,stopResourcesBlankIndexed,stopResourcesStandardIndexedEmptyNull,stopResourcesBlankIndexedEmptyNull,elisaExpand,stopVolumesStandardIndexedEmptyNull,stopVolumesBlankIndexedEmptyNull,coatingAntibodiesWithFactorsDeDuplicates,coatingAntibodyWithFactorToWorkingResourceLookupTable,coatingAntibodyWorkingResourcesAllIndexed,primaryAssemblyPlatePositions,primaryPlateSampleStartCounts,primaryPlateSameSampleRanges,primaryPlateSamplePositions,secondaryPlateSamplePositions,secondaryAssemblyPlatePositions,secondaryPlateSampleStartCounts,secondaryPlateSameSampleRanges,resolvedSampleAntibodyComplexImmunosorbentMixRate,resolvedBlockingMixRate,assignTypes,assignSamples,assignSpikes,assignSpikeDilutionFactors,assignSampleDilutionFactors,assignCoatingAntibodies,assignCoatingAntibodyDilutionFactors,assignCaptureAntibodies,assignCaptureAntibodyDilutionFactors,assignReferenceAntigens,assignReferenceAntigenDilutionFactors,assignPrimaryAntibodies,assignPrimaryAntibodyDilutionFactors,assignSecondaryAntibodies,assignSecondaryAntibodyDilutionFactors,assignCoatingVolumes,assignBlockingVolumes,assignSampleAntibodyComplexImmunosorbentVolumes,assignSampleImmunosorbentVolumes,assignPrimaryAntibodyImmunosorbentVolumes,assignSecondaryAntibodyImmunosorbentVolumes,assignSubstrateSolutions,assignStopSolutions,assignSubstrateSolutionVolumes,assignStopSolutionVolumes,assignSpikesResourcesLinked,assignCoatingAntibodiesResourcesLinked,assignCaptureAntibodiesResourcesLinked,assignReferenceAntigensResourcesLinked,assignPrimaryAntibodiesResourcesLinked,assignSecondaryAntibodiesResourcesLinked,assignSubstrateSolutionsResourcesLinked,assignStopSolutionsResourcesLinked,assignTypesExpanded,assignSamplesExpanded,assignSpikesExpanded,assignSpikeDilutionFactorsExpanded,assignSampleDilutionFactorsExpanded,assignCoatingAntibodiesExpanded,assignCoatingAntibodyDilutionFactorsExpanded,assignCaptureAntibodiesExpanded,assignCaptureAntibodyDilutionFactorsExpanded,assignReferenceAntigensExpanded,assignReferenceAntigenDilutionFactorsExpanded,assignPrimaryAntibodiesExpanded,assignPrimaryAntibodyDilutionFactorsExpanded,assignSecondaryAntibodiesExpanded,assignSecondaryAntibodyDilutionFactorsExpanded,assignCoatingVolumesExpanded,assignBlockingVolumesExpanded,assignSampleAntibodyComplexImmunosorbentVolumesExpanded,assignSampleImmunosorbentVolumesExpanded,assignPrimaryAntibodyImmunosorbentVolumesExpanded,assignSecondaryAntibodyImmunosorbentVolumesExpanded,assignSubstrateSolutionsExpanded,assignStopSolutionsExpanded,assignSubstrateSolutionVolumesExpanded,assignStopSolutionVolumesExpanded,assignDataExpanded,processedELISAPlateAssignment,elisaExpandByNoR,secAssignTypes,secAssignSamples,secAssignSpikes,secAssignSpikeDilutionFactors,secAssignSampleDilutionFactors,secAssignCoatingAntibodies,secAssignCoatingAntibodyDilutionFactors,secAssignCaptureAntibodies,secAssignCaptureAntibodyDilutionFactors,secAssignReferenceAntigens,secAssignReferenceAntigenDilutionFactors,secAssignPrimaryAntibodies,secAssignPrimaryAntibodyDilutionFactors,secAssignSecondaryAntibodies,secAssignSecondaryAntibodyDilutionFactors,secAssignCoatingVolumes,secAssignBlockingVolumes,secAssignSampleAntibodyComplexImmunosorbentVolumes,secAssignSampleImmunosorbentVolumes,secAssignPrimaryAntibodyImmunosorbentVolumes,secAssignSecondaryAntibodyImmunosorbentVolumes,secAssignSubstrateSolutions,secAssignStopSolutions,secAssignSubstrateSolutionVolumes,secAssignStopSolutionVolumes,secAssignSpikesResourcesLinked,secAssignCoatingAntibodiesResourcesLinked,secAssignCaptureAntibodiesResourcesLinked,secAssignReferenceAntigensResourcesLinked,secAssignPrimaryAntibodiesResourcesLinked,secAssignSecondaryAntibodiesResourcesLinked,secAssignSubstrateSolutionsResourcesLinked,secAssignStopSolutionsResourcesLinked,secAssignTypesExpanded,secAssignSamplesExpanded,secAssignSpikesExpanded,secAssignSpikeDilutionFactorsExpanded,secAssignSampleDilutionFactorsExpanded,secAssignCoatingAntibodiesExpanded,secAssignCoatingAntibodyDilutionFactorsExpanded,secAssignCaptureAntibodiesExpanded,secAssignCaptureAntibodyDilutionFactorsExpanded,secAssignReferenceAntigensExpanded,secAssignReferenceAntigenDilutionFactorsExpanded,secAssignPrimaryAntibodiesExpanded,secAssignPrimaryAntibodyDilutionFactorsExpanded,secAssignSecondaryAntibodiesExpanded,secAssignSecondaryAntibodyDilutionFactorsExpanded,secAssignCoatingVolumesExpanded,secAssignBlockingVolumesExpanded,secAssignSampleAntibodyComplexImmunosorbentVolumesExpanded,secAssignSampleImmunosorbentVolumesExpanded,secAssignPrimaryAntibodyImmunosorbentVolumesExpanded,secAssignSecondaryAntibodyImmunosorbentVolumesExpanded,secAssignSubstrateSolutionsExpanded,secAssignStopSolutionsExpanded,secAssignSubstrateSolutionVolumesExpanded,secAssignStopSolutionVolumesExpanded,associatedELISAPlateAssignment,secAssignDataExpanded,joinedSampleResources,assignSampleResourcesLinked,secAssignSampleResourcesLinked,processedSecondaryELISAPlateAssignment,associatedSecondaryELISAPlateAssignment,samplesInResources,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,joinedSerialDilutionCurve,joinedDilutionCurve,elisaExpandOrShrink,standardResourcesStandardIndexMatched,resolverJoinedCurveExpansionParams,curveExpandedJoinedSubstrate,curveExpandedJoinedSubstrateVolumes,curveExpandedJoinedStop,curveExpandedJoinedStopVolumes,paddedSpikeVolumes,flattenedCombinedDilutionCurves,joinedSpikes,paddedSpikes,joinedCaptureAntibodyCoatingVolumes,expandedCaptureAntibodyCoatingVolumes,numWellsToWash,numberOfWells,numberOfBlocking,numberOfStopping,methodSteps,tipNumber,tipResource,protocolID,protocolKey,primaryAntibodiesToDilute,primaryAntibodyDilutionVolumes,primaryAntibodyDiluentDilutionVolumes,primaryAntibodyDilutionContainers,secondaryAntibodiesToDilute,secondaryAntibodyDilutionVolumes,secondaryAntibodyDiluentDilutionVolumes,secondaryAntibodyDilutionContainers,captureAntibodiesToDilute,captureAntibodyDilutionVolumes,captureAntibodyDiluentDilutionVolumes,captureAntibodyDilutionContainers,coatingAntibodiesToDilute,coatingAntibodyDilutionVolumes,coatingAntibodyDiluentDilutionVolumes,coatingAntibodyDilutionContainers,referenceAntigensToDilute,referenceAntigenDilutionVolumes,referenceAntigenDiluentDilutionVolumes,referenceAntigenDilutionContainers,elisaExtractDilutionParams,coatingAntibodiesToDiluteStorage,captureAntibodiesToDiluteStorage,referenceAntigensToDiluteStorage,primaryAntibodiesToDiluteStorage,secondaryAntibodiesToDiluteStorage,resolvedBlankStorageCondition,primaryAntibodyDiluentVolumeForEachDilution,secondaryAntibodyDiluentVolumeForEachDilution,captureAntibodyDiluentVolumeForEachDilution,coatingAntibodyDiluentVolumeForEachDilution,referenceAntigenDiluentVolumeForEachDilution,resolvedSpikeStorageCondition,primaryAntibodyStorageConditionCombined,secondaryAntibodyStorageConditionCombined,captureAntibodyStorageConditionCombined,coatingAntibodyStorageConditionCombined,referenceAntigenStorageConditionCombined,primaryAntibodyVolumeForEachDilution,secondaryAntibodyVolumeForEachDilution,captureAntibodyVolumeForEachDilution,coatingAntibodyVolumeForEachDilution,referenceAntigenVolumeForEachDilution,primaryAntibodyConcentrateResources,secondaryAntibodyConcentrateResources,secondaryAntibodyTransferVolumeCombined,captureAntibodyConcentrateResources,coatingAntibodyConcentrateResources,referenceAntigenConcentrateResources,blankResourcesBlankIndexMatched,blanksDeDup,blankVolumesCombined,
		joinedSampleStandardDiluents,joinedSampleStandardDiluentVolumes,sampleStandardDiluentDeDup,sampleStandardVolumesDedup,sampleStandardDiluentResources,joinedAntibodyDiluents,joinedAntibodyDiluentVolumes,antibodyDiluentsDeDup,antibodyDiluentVolumesDeDup,antibodyDiluentResources,secondaryAntibodyOnDeckError,
		blockingVolumeList,expandedBlockingVolumeList,curveGroupParams,curveGroupPartitionHeads,curveGroupPartitionTails,curveGroupPartitionRanges,groupedSampleAssemblyVolumes,wholeStackNumber,partialStackTipNumber,wholeStackTipResources,partialStackTipResource,expandedConcentrateVolumes,expandedDiluentVolumes,expandedSpikeVolumes,expandedPrimaryAntibodySampleMixingVolumes,expandedCaptureAntibodySampleMixingVolumes,containersInResources,pipettingTime,numberOfSamplesPrimaryPlate,numberOfSamplesSecondaryPlate,tooLargeVolumeQ,allDeckResources,allDeckResourceContainer,tooMany2mLTubeQ,tooMany50mLTubeQ,tooManyContainersTests,resolvedSecondaryELISAPlateAssignmentNullToEmpty,lookupAndDelete,initalLookupTableWithPlaceholderValue,valuesWithFoldedLookupTable,negativediluentVolume,sampleVolumeList,groupedSpikes
	},
	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentELISA, {mySamples}, myResolvedOptions];

	(* Get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
		ExperimentELISA,
		RemoveHiddenOptions[ExperimentELISA,myResolvedOptions],
		Ignore->myUnresolvedOptions,
		Messages->False
	];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionDefault[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = Not[gatherTests];

	(* Get the inherited cache *)
	inheritedCache = Lookup[ToList[ops],Cache];
	simulation = Lookup[ToList[ops], Simulation, Simulation[]];

	(* Set error tracking boolean to False *)
	tooLargeVolumeQ = False;


	(* --- Make all the resources needed in the experiment --- *)

	(*get all resolved options*)

	{
		resolvedMethod,resolvedTargetAntigen,resolvedNumberOfReplicates,resolvedWashingBuffer,resolvedCoatingAntibody,resolvedCoatingAntibodyDilutionFactor,resolvedCoatingAntibodyVolume,resolvedCoatingAntibodyDiluent,resolvedCoatingAntibodyStorageCondition,resolvedCaptureAntibody,resolvedCaptureAntibodyDilutionFactor,resolvedCaptureAntibodyVolume,resolvedCaptureAntibodyDiluent,resolvedCaptureAntibodyStorageCondition,resolvedReferenceAntigen,resolvedReferenceAntigenDilutionFactor,resolvedReferenceAntigenVolume,resolvedReferenceAntigenDiluent,resolvedReferenceAntigenStorageCondition,resolvedPrimaryAntibody,resolvedPrimaryAntibodyDilutionFactor,resolvedPrimaryAntibodyVolume,resolvedPrimaryAntibodyDiluent,resolvedPrimaryAntibodyStorageCondition,resolvedSecondaryAntibody,resolvedSecondaryAntibodyDilutionFactor,resolvedSecondaryAntibodyVolume,resolvedSecondaryAntibodyDiluent,resolvedSecondaryAntibodyStorageCondition,resolvedSampleAntibodyComplexIncubation,resolvedSampleAntibodyComplexIncubationTime,resolvedSampleAntibodyComplexIncubationTemperature,resolvedCoating,resolvedSampleCoatingVolume,resolvedCoatingAntibodyCoatingVolume,resolvedReferenceAntigenCoatingVolume,resolvedCaptureAntibodyCoatingVolume,resolvedCoatingTemperature,resolvedCoatingTime,resolvedCoatingWashVolume,resolvedCoatingNumberOfWashes,resolvedBlocking,resolvedBlockingBuffer,resolvedBlockingVolume,resolvedBlockingTemperature,resolvedBlockingTime,resolvedBlockingMixRate,resolvedBlockingWashVolume,resolvedBlockingNumberOfWashes,resolvedSampleAntibodyComplexImmunosorbentVolume,resolvedSampleAntibodyComplexImmunosorbentTime,resolvedSampleAntibodyComplexImmunosorbentTemperature,resolvedSampleAntibodyComplexImmunosorbentMixRate,resolvedSampleAntibodyComplexImmunosorbentWashVolume,resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,resolvedSampleImmunosorbentVolume,resolvedSampleImmunosorbentTime,resolvedSampleImmunosorbentTemperature,resolvedSampleImmunosorbentMixRate,resolvedSampleImmunosorbentWashVolume,resolvedSampleImmunosorbentNumberOfWashes,resolvedPrimaryAntibodyImmunosorbentVolume,resolvedPrimaryAntibodyImmunosorbentTime,resolvedPrimaryAntibodyImmunosorbentTemperature,resolvedPrimaryAntibodyImmunosorbentMixRate,resolvedPrimaryAntibodyImmunosorbentWashVolume,resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,resolvedSecondaryAntibodyImmunosorbentVolume,resolvedSecondaryAntibodyImmunosorbentTime,resolvedSecondaryAntibodyImmunosorbentTemperature,resolvedSecondaryAntibodyImmunosorbentMixRate,resolvedSecondaryAntibodyImmunosorbentWashVolume,resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,resolvedSubstrateSolution,resolvedStopSolution,resolvedSubstrateSolutionVolume,resolvedStopSolutionVolume,resolvedSubstrateIncubationTime,resolvedSubstrateIncubationTemperature,resolvedSubstrateIncubationMixRate,resolvedAbsorbanceWavelength,resolvedSignalCorrection,resolvedStandard,resolvedStandardTargetAntigen,resolvedStandardDilutionCurve,resolvedStandardSerialDilutionCurve,resolvedStandardDiluent,resolvedStandardStorageCondition,resolvedStandardCoatingAntibody,resolvedStandardCoatingAntibodyDilutionFactor,resolvedStandardCoatingAntibodyVolume,resolvedStandardCaptureAntibody,resolvedStandardCaptureAntibodyDilutionFactor,resolvedStandardCaptureAntibodyVolume,resolvedStandardReferenceAntigen,resolvedStandardReferenceAntigenDilutionFactor,resolvedStandardReferenceAntigenVolume,resolvedStandardPrimaryAntibody,resolvedStandardPrimaryAntibodyDilutionFactor,resolvedStandardPrimaryAntibodyVolume,resolvedStandardSecondaryAntibody,resolvedStandardSecondaryAntibodyDilutionFactor,resolvedStandardSecondaryAntibodyVolume,resolvedStandardCoatingVolume,resolvedStandardReferenceAntigenCoatingVolume,resolvedStandardCoatingAntibodyCoatingVolume,resolvedStandardCaptureAntibodyCoatingVolume,resolvedStandardBlockingVolume,resolvedStandardAntibodyComplexImmunosorbentVolume,resolvedStandardImmunosorbentVolume,resolvedStandardPrimaryAntibodyImmunosorbentVolume,resolvedStandardSecondaryAntibodyImmunosorbentVolume,resolvedStandardSubstrateSolution,resolvedStandardStopSolution,resolvedStandardSubstrateSolutionVolume,resolvedStandardStopSolutionVolume,resolvedBlank,resolvedBlankTargetAntigen,resolvedBlankStorageCondition,resolvedBlankCoatingAntibody,resolvedBlankCoatingAntibodyDilutionFactor,resolvedBlankCoatingAntibodyVolume,resolvedBlankCaptureAntibody,resolvedBlankCaptureAntibodyDilutionFactor,resolvedBlankCaptureAntibodyVolume,resolvedBlankReferenceAntigen,resolvedBlankReferenceAntigenDilutionFactor,resolvedBlankReferenceAntigenVolume,resolvedBlankPrimaryAntibody,resolvedBlankPrimaryAntibodyDilutionFactor,resolvedBlankPrimaryAntibodyVolume,resolvedBlankSecondaryAntibody,resolvedBlankSecondaryAntibodyDilutionFactor,resolvedBlankSecondaryAntibodyVolume,resolvedBlankCoatingVolume,resolvedBlankReferenceAntigenCoatingVolume,resolvedBlankCoatingAntibodyCoatingVolume,resolvedBlankCaptureAntibodyCoatingVolume,resolvedBlankBlockingVolume,resolvedBlankAntibodyComplexImmunosorbentVolume,resolvedBlankImmunosorbentVolume,resolvedBlankPrimaryAntibodyImmunosorbentVolume,resolvedBlankSecondaryAntibodyImmunosorbentVolume,resolvedBlankSubstrateSolution,resolvedBlankStopSolution,resolvedBlankSubstrateSolutionVolume,resolvedBlankStopSolutionVolume,resolvedSpike,resolvedSpikeDilutionFactor,resolvedSpikeStorageCondition,resolvedSampleDilutionCurve,resolvedSampleSerialDilutionCurve,resolvedSampleDiluent,resolvedELISAPlate,resolvedSecondaryELISAPlate,resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignment,resolvedAliquotAmount,resolvedPrimaryAntibodyImmunosorbentWashing,resolvedSecondaryAntibodyImmunosorbentWashing,resolvedSecondaryAntibodyDilutionOnDeck
	}
		=Lookup[expandedResolvedOptions,
		{
			Method,TargetAntigen,NumberOfReplicates,WashingBuffer,CoatingAntibody,CoatingAntibodyDilutionFactor,CoatingAntibodyVolume,CoatingAntibodyDiluent,CoatingAntibodyStorageCondition,CaptureAntibody,CaptureAntibodyDilutionFactor,CaptureAntibodyVolume,CaptureAntibodyDiluent,CaptureAntibodyStorageCondition,ReferenceAntigen,ReferenceAntigenDilutionFactor,ReferenceAntigenVolume,ReferenceAntigenDiluent,ReferenceAntigenStorageCondition,PrimaryAntibody,PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyStorageCondition,SecondaryAntibody,SecondaryAntibodyDilutionFactor,SecondaryAntibodyVolume,SecondaryAntibodyDiluent,SecondaryAntibodyStorageCondition,SampleAntibodyComplexIncubation,SampleAntibodyComplexIncubationTime,SampleAntibodyComplexIncubationTemperature,Coating,SampleCoatingVolume,CoatingAntibodyCoatingVolume,ReferenceAntigenCoatingVolume,CaptureAntibodyCoatingVolume,CoatingTemperature,CoatingTime,CoatingWashVolume,CoatingNumberOfWashes,Blocking,BlockingBuffer,BlockingVolume,BlockingTemperature,BlockingTime,BlockingMixRate,BlockingWashVolume,BlockingNumberOfWashes,SampleAntibodyComplexImmunosorbentVolume,SampleAntibodyComplexImmunosorbentTime,SampleAntibodyComplexImmunosorbentTemperature,SampleAntibodyComplexImmunosorbentMixRate,SampleAntibodyComplexImmunosorbentWashVolume,SampleAntibodyComplexImmunosorbentNumberOfWashes,SampleImmunosorbentVolume,SampleImmunosorbentTime,SampleImmunosorbentTemperature,SampleImmunosorbentMixRate,SampleImmunosorbentWashVolume,SampleImmunosorbentNumberOfWashes,PrimaryAntibodyImmunosorbentVolume,PrimaryAntibodyImmunosorbentTime,PrimaryAntibodyImmunosorbentTemperature,PrimaryAntibodyImmunosorbentMixRate,PrimaryAntibodyImmunosorbentWashVolume,PrimaryAntibodyImmunosorbentNumberOfWashes,SecondaryAntibodyImmunosorbentVolume,SecondaryAntibodyImmunosorbentTime,SecondaryAntibodyImmunosorbentTemperature,SecondaryAntibodyImmunosorbentMixRate,SecondaryAntibodyImmunosorbentWashVolume,SecondaryAntibodyImmunosorbentNumberOfWashes,SubstrateSolution,StopSolution,SubstrateSolutionVolume,StopSolutionVolume,SubstrateIncubationTime,SubstrateIncubationTemperature,SubstrateIncubationMixRate,AbsorbanceWavelength,SignalCorrection,Standard,StandardTargetAntigen,StandardDilutionCurve,StandardSerialDilutionCurve,StandardDiluent,StandardStorageCondition,StandardCoatingAntibody,StandardCoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume,StandardCaptureAntibody,StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume,StandardReferenceAntigen,StandardReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume,StandardPrimaryAntibody,StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyDilutionFactor,StandardSecondaryAntibodyVolume,StandardCoatingVolume,StandardReferenceAntigenCoatingVolume,StandardCoatingAntibodyCoatingVolume,StandardCaptureAntibodyCoatingVolume,StandardBlockingVolume,StandardAntibodyComplexImmunosorbentVolume,StandardImmunosorbentVolume,StandardPrimaryAntibodyImmunosorbentVolume,StandardSecondaryAntibodyImmunosorbentVolume,StandardSubstrateSolution,StandardStopSolution,StandardSubstrateSolutionVolume,StandardStopSolutionVolume,Blank,BlankTargetAntigen,BlankStorageCondition,BlankCoatingAntibody,BlankCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume,BlankCaptureAntibody,BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume,BlankReferenceAntigen,BlankReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume,BlankPrimaryAntibody,BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume,BlankSecondaryAntibody,BlankSecondaryAntibodyDilutionFactor,BlankSecondaryAntibodyVolume,BlankCoatingVolume,BlankReferenceAntigenCoatingVolume,BlankCoatingAntibodyCoatingVolume,BlankCaptureAntibodyCoatingVolume,BlankBlockingVolume,BlankAntibodyComplexImmunosorbentVolume,BlankImmunosorbentVolume,BlankPrimaryAntibodyImmunosorbentVolume,BlankSecondaryAntibodyImmunosorbentVolume,BlankSubstrateSolution,BlankStopSolution,BlankSubstrateSolutionVolume,BlankStopSolutionVolume,Spike,SpikeDilutionFactor,SpikeStorageCondition,SampleDilutionCurve,SampleSerialDilutionCurve,SampleDiluent,ELISAPlate,SecondaryELISAPlate,ELISAPlateAssignment,SecondaryELISAPlateAssignment,AliquotAmount,PrimaryAntibodyImmunosorbentWashing,SecondaryAntibodyImmunosorbentWashing,SecondaryAntibodyDilutionOnDeck
		}
	]/.x:ObjectP[]:>Download[x,Object]; (*Make sure we are converting any named version of objects to id version*)

	resolvedNumberOfReplicatesNullToOne=resolvedNumberOfReplicates/.Null->1;

	(*get resolver passdown values: these are intermediate variables in resolver that are useful for calculations in the resource packet*)
	{
		resolverPipettingError,
		resolverRoundedTransformedStandardDilutionCurve,
		resolverRoundedTransformedStandardSerialDilutionCurve,
		resolverRoundedTransformedSampleDilutionCurve,
		resolverRoundedTransformedSampleSerialDilutionCurve,
		resolverSpikeVolumes,
		resolverAllPrimaryAntibodies,
		resolverAllPrimaryAntibodyAssayVolumes,
		resolverAllPrimaryAntibodyVolumes,
		resolverAllPrimaryAntibodiesWithFactors,
		resolverAllSecondaryAntibodies,
		resolverAllSecondaryAntibodyAssayVolumes,
		resolverAllSecondaryAntibodyVolumes,
		resolverAllSecondaryAntibodiesWithFactors,
		resolverAllCoatingAntibodies,
		resolverAllCoatingAntibodyAssayVolumes,
		resolverAllCoatingAntibodyVolumes,
		resolverAllCoatingAntibodiesWithFactors,
		resolverAllCaptureAntibodies,
		resolverAllCaptureAntibodyAssayVolumes,
		resolverAllCaptureAntibodyVolumes,
		resolverAllCaptureAntibodiesWithFactors,
		resolverAllReferenceAntigens,
		resolverAllReferenceAntigenAssayVolumes,
		resolverAllReferenceAntigenVolumes,
		resolverAllReferenceAntigensWithFactors,
		resolverRequiredAliquotAmount,
		resolverPrimaryAssignmentTableCounts,
		resolverSecondaryAssignmentTableCounts,
		resolverAutoJoinedAssignmentTable,
		resolverJoinedCurveExpansionParams


	}=Lookup[resolverPassDowns,
		{
			"passDownPipettingError",
			"passDownRoundedTransformedStandardDilutionCurve",
			"passDownRoundedTransformedStandardSerialDilutionCurve",
			"passDownRoundedTransformedSampleDilutionCurve",
			"passDownRoundedTransformedSampleSerialDilutionCurve",
			"passDownSpikeVolumes",
			"passDownJoinedPrimaryAntibodies",
			"passDownJoinedPrimaryAntibodyAssayVolumes",
			"passDownCombinedPrimaryAntibodyVolumes",
			"passDownCombinedPrimaryAntibodyWithFactors",
			"passDownJoinedSecondaryAntibodies",
			"passDownJoinedSecondaryAntibodyAssayVolumes",
			"passDownCombinedSecondaryAntibodyVolumes",
			"passDownCombinedSecondaryAntibodyWithFactors",
			"passDownJoinedCoatingAntibodies",
			"passDownJoinedCoatingAntibodyAssayVolumes",
			"passDownCombinedCoatingAntibodyVolumes",
			"passDownCombinedCoatingAntibodyWithFactors",
			"passDownJoinedCaptureAntibodies",
			"passDownJoinedCaptureAntibodyAssayVolumes",
			"passDownCombinedCaptureAntibodyVolumes",
			"passDownCombinedCaptureAntibodyWithFactors",
			"passDownJoinedReferenceAntigens",
			"passDownJoinedReferenceAntigenAssayVolumes",
			"passDownCombinedReferenceAntigenVolumes",
			"passDownCombinedReferenceAntigenWithFactors",
			"passDownRequiredAliquotAmounts",
			"passDownResolvedPrimaryAssignmentTableCounts",
			"passDownResolvedSecondaryAssignmentTableCounts",
			"passDownJoinedAssignmentTable",
			"passDownJoinedCurveExpansionParams"
			
		}
	]/.x:ObjectP[]:>Download[x,Object]; (*Make sure we are converteing any named version of objects to id version*)

	(*A little Helper function: does the same thing as Merge for two lists instead of an association. It also combines samples in the id form and name form*)
	elisaListMerge[key_List,target_List,rule_Function]:=Module[{list,mergedAssoc,mergedAssocDeNull,mergedAssocDeZero},
		list=MapThread[#1->#2&,{key/.x:ObjectP[]:>Download[x,Object],target}];
		mergedAssoc=Merge[list,rule];
		(*Get rid of Null keys and values of 0 microliters*)
		mergedAssocDeNull=KeyDrop[mergedAssoc,Null];
		mergedAssocDeZero=DeleteCases[mergedAssocDeNull,0Microliter];
		{Keys[mergedAssocDeZero],Values[mergedAssocDeZero]}
	];

	elisaContainerPicker[volume_]:=
	Which[
		(* Use 2ml tube if total sample volume is <= 1.9ml*)
		volume<=1.9Milliliter,
		PreferredContainer[1.9Milliliter,LiquidHandlerCompatible->True],

		(* Use 50ml tube is total sample volume is larger than 2ml tube. Since the total working volume (200ul per well) for 2*96 well plates is less than 50ml, it is not possible for the needed sample volume to exceed the capacity of a 50ml tube.*)
		volume>1.9Milliliter&&volume<50Milliliter,
		PreferredContainer[50Milliliter,LiquidHandlerCompatible->True],
		
		MatchQ[volume,Null|0Milliliter],Null,

		True,
		(* Track large volume error *)
		Message[Error::SampleVolumeShouldNotBeLargerThan50ml];tooLargeVolumeQ=True;PreferredContainer[volume]
	];


	(*Helper function to pick resources from a pool based on Sample*)
	elisaExtractResources[resourceList_,obj_]:=If[
		MatchQ[resourceList,{Null..}|Null|{}]||MatchQ[obj,Null],
		Null,
		(* First available resource or if not found, keep whatever obj is *)
		FirstOrDefault[Select[resourceList,MatchQ[#[Sample],ObjectP[obj]]&],obj]
	];

	(* -- Generate resources for the SamplesIn and diluent-- *)
	sampleVolumeList=MapThread[
		Which[MatchQ[#1,Null|{Null..}|{}]&&MatchQ[#2,Null|{Null..}|{}],
			FirstCase[{#3,#4},GreaterP[0Microliter],0Microliter],

			!MatchQ[#1,Null|{Null..}|{}],Plus @@ (#1[[All, 1]]),
			!MatchQ[#2,Null|{Null..}|{}],#2[[1, 1]]
		]&,
		{
			resolverRoundedTransformedSampleDilutionCurve,
			resolverRoundedTransformedSampleSerialDilutionCurve,
			resolvedSampleImmunosorbentVolume,
			resolvedSampleCoatingVolume
		},1];

	{samplesInResources,containersInResources} =
		If[MatchQ[resolvedMethod,DirectELISA|IndirectELISA]&&resolvedCoating===False,
			(*If sample is coated, include ContainersIn *)
			{MapThread[Resource[Sample->#1, Name->ToString[Unique[]],Amount->(#2*resolverPipettingError*resolvedNumberOfReplicatesNullToOne)]&,{mySamples,sampleVolumeList}],
				If[MatchQ[resolvedSecondaryELISAPlate,ObjectP[]],
					{
						Resource[Sample->resolvedELISAPlate, Name->ToString[Unique[]]],
						Resource[Sample->resolvedSecondaryELISAPlate, Name->ToString[Unique[]]]
					},
					{Resource[Sample->resolvedELISAPlate, Name->ToString[Unique[]]]}
				]
			},


			volumeLarger=MapThread[FirstOrDefault[TakeLargest[{#1,#2},1]]&,{resolverRequiredAliquotAmount*resolvedNumberOfReplicatesNullToOne,(ToList[resolvedAliquotAmount]/.Null->0Microliter)}];
			{
				MapThread[Resource[Sample->#1, Name->ToString[Unique[]], Amount->#2]&,{mySamples, volumeLarger}],
				{}
			}
		];


	(*We are not timing number of replicates and pipetting errors here. We are doing that when combining buffers.*)
	sampleDiluentVolume=If[resolvedSampleDiluent===Null,Null,
		sampleDiluentVolumeList=MapThread[
			Which[MatchQ[#1,Null|{Null..}|{}]&&MatchQ[#2,Null|{Null..}|{}],0 Microliter,
				MatchQ[#1,Null|{Null}|{}],#2[[All,2]],
				MatchQ[#2,Null|{Null}|{}],#1[[All,2]]
			]&,
			{
				resolverRoundedTransformedSampleDilutionCurve,
				resolverRoundedTransformedSampleSerialDilutionCurve
			},
			1
		];
		Plus@@Flatten[sampleDiluentVolumeList]
	];

	(* -- Generate resources for spike -- *)
	spikeResources=If[MatchQ[resolvedSpike,Null|{Null..}],Null,
		(*ELSE*)
		{spikesDeDuplicates,spikeVolumesCombined}=elisaListMerge[resolvedSpike,resolverSpikeVolumes,(Total[#]*resolvedNumberOfReplicatesNullToOne*resolverPipettingError&)];
		MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,{spikesDeDuplicates,spikeVolumesCombined}]
	];
	spikeResourcesSampleIndexed=If[MatchQ[resolvedSpike,Null|{Null..}],
		ConstantArray[Null,Length[mySamples//ToList]],
		Map[elisaExtractResources[spikeResources,#]&,resolvedSpike]
	];


		(* -- Generate resources for Standard and diluent -- *)

	standardResourcesStandardIndexMatched=If[MatchQ[resolvedStandard,{Null..}],
		{},
		(*ELSE*)
		standardVolumeList=MapThread[
			Which[MatchQ[#1,Null|{Null..}|{}]&&MatchQ[#2,Null|{Null..}|{}],
				FirstCase[{#3,#4},GreaterP[0Microliter],0Microliter],

				!MatchQ[#1,Null|{Null..}|{}],Plus @@ (#1[[All, 1]]),
				!MatchQ[#2,Null|{Null..}|{}],#2[[1, 1]]
			]&,
			{
				resolverRoundedTransformedStandardDilutionCurve,
				resolverRoundedTransformedStandardSerialDilutionCurve,
				resolvedStandardImmunosorbentVolume,
				resolvedStandardCoatingVolume
			},1];
		{standardsDeDuplicates,standardVolumesCombined}=elisaListMerge[resolvedStandard,standardVolumeList,
			Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&];
		standardResources=If[MatchQ[{resolvedMethod,resolvedCoating},{(DirectELISA|IndirectELISA),False}],
			MapThread[
				Resource[Sample->#1, Name->ToString[Unique[]]]&,
				{standardsDeDuplicates, standardVolumesCombined}
			],
			MapThread[
				Resource[Sample->#1, Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
				{standardsDeDuplicates, standardVolumesCombined}
			]
		];
		(*To indexMatch resources to each entry of standard.*)
		elisaExtractResources[standardResources,#]&/@resolvedStandard
	];


	standardDiluentVolume=If[MatchQ[resolvedStandard,{Null..}|Null]||MatchQ[resolvedStandardDiluent,Null],
		Null,
		(*ELSE*)
		standardDiluentVolumeList=MapThread[
			Which[MatchQ[#1,Null|{Null}|{}]&&MatchQ[#2,Null|{Null}|{}],0 Microliter,
				MatchQ[#1,Null|{Null}|{}],#2[[All,2]],
				MatchQ[#2,Null|{Null}|{}],#1[[All,2]]
			]&,
			{
				resolverRoundedTransformedStandardDilutionCurve,
				resolverRoundedTransformedStandardSerialDilutionCurve
			},
			1
		];
		Plus@@Flatten[standardDiluentVolumeList]
	];


	(* -- Blank -- *)
		blankVolumes=If[MatchQ[resolvedBlank,{Null..}|Null|{}],
			Null,
			(*ELSE*)
			Which[
				MatchQ[resolvedMethod,DirectELISA|IndirectELISA]&&MatchQ[resolvedCoating,True],
				resolvedBlankCoatingVolume,

				MatchQ[resolvedMethod,DirectSandwichELISA|IndirectSandwichELISA],
				resolvedBlankImmunosorbentVolume,

				MatchQ[resolvedMethod,DirectCompetitiveELISA|IndirectCompetitiveELISA],
				blankPrimaryAntibodyVolumes=MapThread[If[#1=!=Null,#1,#2*#3]&,{resolvedBlankPrimaryAntibodyVolume,resolvedBlankPrimaryAntibodyDilutionFactor,resolvedBlankAntibodyComplexImmunosorbentVolume}];
				MapThread[(#1-#2)&,{resolvedBlankAntibodyComplexImmunosorbentVolume,blankPrimaryAntibodyVolumes}],

				MatchQ[resolvedMethod,FastELISA],
				blankPrimaryAntibodyVolumes=MapThread[If[#1=!=Null,#1,#2*#3]&,{resolvedBlankPrimaryAntibodyVolume,resolvedBlankPrimaryAntibodyDilutionFactor,resolvedBlankAntibodyComplexImmunosorbentVolume}];
				blankCaptureAntibodyVolumes=MapThread[If[#1=!=Null,#1,#2*#3]&,{resolvedBlankCaptureAntibodyVolume,resolvedBlankCaptureAntibodyDilutionFactor,resolvedBlankAntibodyComplexImmunosorbentVolume}];
				MapThread[(#1-#2-#3)&,{resolvedBlankAntibodyComplexImmunosorbentVolume,blankPrimaryAntibodyVolumes,blankCaptureAntibodyVolumes}]
			]
		];

		blankResourcesBlankIndexMatched=If[MatchQ[resolvedBlank,{Null..}|Null|{}],
			{},
			{blanksDeDup,blankVolumesCombined}=elisaListMerge[resolvedBlank,blankVolumes,(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];

			blankResources=MapThread[
				Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
				{blanksDeDup,blankVolumesCombined}
			];

			elisaExtractResources[blankResources,#]&/@resolvedBlank
		];



		(* -- Primary antibody and diluent -- *)
	sampleNumber=Length[mySamples//ToList];
	standardNumber=Length[DeleteCases[resolvedStandard//ToList, Null]];
	blankNumber=Length[DeleteCases[resolvedBlank//ToList, Null]];
	sampleRange={1,sampleNumber};
	standardRange={sampleNumber+1,sampleNumber+standardNumber};
	blankRange={sampleNumber+standardNumber+1,sampleNumber+standardNumber+blankNumber};
	
	(*All of the resolver pass-down values have been expanded by dilution curves. We only need to multiply volumes by number of replicates and pipetting error*)

	{primaryAntibodyDeDuplicates,primaryAntibodyVolumesCombined}=elisaListMerge[resolverAllPrimaryAntibodies,resolverAllPrimaryAntibodyVolumes,
		(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
	primaryAntibodyResources=MapThread[
		Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
		{primaryAntibodyDeDuplicates,primaryAntibodyVolumesCombined}];
	primaryAntibodyResourcesSampleIndexed=elisaExtractResources[primaryAntibodyResources,#]&/@resolvedPrimaryAntibody;
	primaryAntibodyResourcesStandardIndexed=elisaExtractResources[primaryAntibodyResources,#]&/@resolvedStandardPrimaryAntibody;
	primaryAntibodyResourcesBlankIndexed=elisaExtractResources[primaryAntibodyResources,#]&/@resolvedBlankPrimaryAntibody;
	(*total volume of Primary antibody diluent needed for all primary antibody dilution*)
	primaryAntibodyDiluentVolumeCombined=If[MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],
		Null,
		(*We are not timing this by number of replicates and pipetting error yet. This will be done later*)
		(Total[resolverAllPrimaryAntibodyAssayVolumes]-Total[resolverAllPrimaryAntibodyVolumes])
	];


	If[MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],
		primaryAntibodyWorkingResources=primaryAntibodyResources;
		primaryAntibodyDiluentVolumeCombined=Null;
		primaryAntibodyDiluentVolumeForEachDilution=Null;
		primaryAntibodyDilutionContainerResources=Null;
		primaryAntibodyWorkingResourcesSampleIndexed=primaryAntibodyResourcesSampleIndexed;
		primaryAntibodyWorkingResourcesStandardIndexed=primaryAntibodyResourcesStandardIndexed;
		primaryAntibodyWorkingResourcesBlankIndexed=primaryAntibodyResourcesBlankIndexed;
		primaryAntibodyStorageConditionCombined=Null,
		
		(*ELSE: when primary antibody is not mixed with samples: only same antibodies with same dilution factor can be combined into the same working resource*)
		(*Because same antibodies with different dilution factors must be diluted in different containers, all of the following are "IndexMatched" to AntibodyWithFactorsDeDuplicated*)
		{primaryAntibodiesWithFactorsDeDuplicates,primaryAntibodyAssayVolumeCombined}=elisaListMerge[resolverAllPrimaryAntibodiesWithFactors,resolverAllPrimaryAntibodyAssayVolumes,
			(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		
		primaryAntibodyAssayVolumeCombinedUndilutionToNull=MapThread[If[MatchQ[#1[[2]],1],Null,#2]&,{primaryAntibodiesWithFactorsDeDuplicates,primaryAntibodyAssayVolumeCombined}];
		primaryAntibodyWorkingResources=MapThread[
			If[MatchQ[#1,Null],elisaExtractResources[primaryAntibodyResources,#2[[1]]],Resource[Sample->elisaContainerPicker[#1],Name->ToString[Unique[]]]]&,
			{primaryAntibodyAssayVolumeCombinedUndilutionToNull,primaryAntibodiesWithFactorsDeDuplicates}];
		(*In this situation primary antibodies are diluted first before immunosorbence. Same antibody may be different working resources because of dilution factor. So we have to use antibody+ dilution factor to locate working resources.*)
		primaryAntibodyWithFactorToWorkingResourceLookupTable=MapThread[#1->#2&,{primaryAntibodiesWithFactorsDeDuplicates,primaryAntibodyWorkingResources}]//Association;
		primaryAntibodyWorkingResourcesAllIndexed=primaryAntibodyWithFactorToWorkingResourceLookupTable[#]&/@resolverAllPrimaryAntibodiesWithFactors;
		primaryAntibodyWorkingResourcesSampleIndexed=Take[primaryAntibodyWorkingResourcesAllIndexed,sampleRange];
		primaryAntibodyWorkingResourcesStandardIndexed=Take[primaryAntibodyWorkingResourcesAllIndexed,standardRange];
		primaryAntibodyWorkingResourcesBlankIndexed=Take[primaryAntibodyWorkingResourcesAllIndexed,blankRange];
		primaryAntibodyDilutionContainerResources=primaryAntibodyWorkingResources/.{Alternatives@@ToList[primaryAntibodyResources]->Null}; (*Undilution->Null*)
		primaryAntibodyConcentrateResources=Map[elisaExtractResources[primaryAntibodyResources,#]&,primaryAntibodiesWithFactorsDeDuplicates[[All,1]]];
		primaryAntibodyVolumeForEachDilution=MapThread[#1*#2&,{primaryAntibodyAssayVolumeCombined,primaryAntibodiesWithFactorsDeDuplicates[[All,2]]}];
		primaryAntibodyDiluentVolumeForEachDilution=MapThread[#1*(1-#2)&,{primaryAntibodyAssayVolumeCombined,primaryAntibodiesWithFactorsDeDuplicates[[All,2]]}];
		primaryAntibodyStorageConditionCombined=FirstOrDefault[PickList[ToList[resolvedPrimaryAntibodyStorageCondition],ToList[primaryAntibodyResourcesSampleIndexed],#]]&/@primaryAntibodiesWithFactorsDeDuplicates[[All,1]]
	];




	(* -- Secondary antibody and diluent -- *)

	If[MatchQ[resolvedMethod, Alternatives[IndirectELISA,IndirectSandwichELISA,IndirectCompetitiveELISA]], (*Secondary antibodies are only used for immunosorbence*)
		{secondaryAntibodyDeDuplicates, secondaryAntibodyVolumesCombined} = elisaListMerge[
			resolverAllSecondaryAntibodies,
			resolverAllSecondaryAntibodyVolumes,
			(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)
		];
		secondaryAntibodyResources = MapThread[
			Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
			{secondaryAntibodyDeDuplicates,secondaryAntibodyVolumesCombined}
		];
		secondaryAntibodyResourcesSampleIndexed = elisaExtractResources[secondaryAntibodyResources,#]&/@resolvedSecondaryAntibody;
		secondaryAntibodyResourcesStandardIndexed = elisaExtractResources[secondaryAntibodyResources,#]&/@resolvedStandardSecondaryAntibody;
		secondaryAntibodyResourcesBlankIndexed = elisaExtractResources[secondaryAntibodyResources,#]&/@resolvedBlankSecondaryAntibody;

		(* Calculate how much required volume for each unique diluted SecondaryAntibody or original SecondaryAntibody when dilution is not required *)
		{secondaryAntibodiesWithFactorsDeDuplicates, secondaryAntibodyAssayVolumeCombined} = elisaListMerge[
			resolverAllSecondaryAntibodiesWithFactors,
			resolverAllSecondaryAntibodyAssayVolumes,
			(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)
		];
		(* When DilutionFactor is 1, there is no dilution at all *)
		(* Calculate how much required volume for each unique diluted SecondaryAntibody *)
		secondaryAntibodyAssayVolumeCombinedUndilutionToNull = MapThread[
			If[MatchQ[#1[[2]],1],Null,#2]&,
			{secondaryAntibodiesWithFactorsDeDuplicates,secondaryAntibodyAssayVolumeCombined}
		];
		(*We are not timing this by number of replicates and pipetting error yet. This will be done later*)
		secondaryAntibodyDiluentVolumeCombined = Total[MapThread[#1*((1-#2)/#2)&,{resolverAllSecondaryAntibodyVolumes,resolverAllSecondaryAntibodiesWithFactors[[All, 2]]}]];

		secondaryAntibodyWorkingResources = MapThread[
			(*If we are diluting secondary antibody in immunosorbent step, the working resource is the undiluted secondary antibody *)
			If[TrueQ[resolvedSecondaryAntibodyDilutionOnDeck] || MatchQ[#1,Null],
				elisaExtractResources[secondaryAntibodyResources,#2],
				Resource[Sample->elisaContainerPicker[#1],Name->ToString[Unique[]]]
			]&,
			{secondaryAntibodyAssayVolumeCombinedUndilutionToNull,secondaryAntibodiesWithFactorsDeDuplicates[[All,1]]}
		];
		(* For each unique concentration of secondary antibody, map it to the working resource *)
		secondaryAntibodyWithFactorToWorkingResourceLookupTable=Association@MapThread[
			#1->#2&,
			{secondaryAntibodiesWithFactorsDeDuplicates,secondaryAntibodyWorkingResources}
		];
		(* Now indexmatching the consolidated working resources back as the order in SamplesIn *)
		secondaryAntibodyWorkingResourcesAllIndexed=secondaryAntibodyWithFactorToWorkingResourceLookupTable[#]&/@resolverAllSecondaryAntibodiesWithFactors;
		secondaryAntibodyWorkingResourcesSampleIndexed=Take[secondaryAntibodyWorkingResourcesAllIndexed,sampleRange];
		secondaryAntibodyWorkingResourcesStandardIndexed=Take[secondaryAntibodyWorkingResourcesAllIndexed,standardRange];
		secondaryAntibodyWorkingResourcesBlankIndexed=Take[secondaryAntibodyWorkingResourcesAllIndexed,blankRange];
		(*If we are diluting secondary antibody in immunosorbent step, no need to set up dilution container resource which is used for AntibodyAntigen dilution subprotocol *)
		secondaryAntibodyDilutionContainerResources=secondaryAntibodyWorkingResources/.{Alternatives@@ToList[secondaryAntibodyResources]->Null};
		secondaryAntibodyConcentrateResources=Map[elisaExtractResources[secondaryAntibodyResources,#]&,secondaryAntibodiesWithFactorsDeDuplicates[[All,1]]];
		(* Since the total dilution amount is different than assay amount, recalculate how much dilution transfer volume and diluent volume is *)
		(* Calculate how much required volume for each unique diluted SecondaryAntibody or original SecondaryAntibody when dilution is not required *)
		secondaryAntibodyTransferVolumeCombined = elisaListMerge[
			resolverAllSecondaryAntibodiesWithFactors,
			resolverAllSecondaryAntibodyVolumes,
			(Total[#]*resolvedNumberOfReplicatesNullToOne&)
		][[2]];
		secondaryAntibodyVolumeForEachDilution=secondaryAntibodyTransferVolumeCombined;
		secondaryAntibodyDiluentVolumeForEachDilution=MapThread[#1*(1/#2-1)&,{secondaryAntibodyTransferVolumeCombined,secondaryAntibodiesWithFactorsDeDuplicates[[All,2]]}];
		secondaryAntibodyStorageConditionCombined=FirstOrDefault[PickList[ToList[resolvedSecondaryAntibodyStorageCondition],ToList[secondaryAntibodyResourcesSampleIndexed],#]]&/@secondaryAntibodiesWithFactorsDeDuplicates[[All,1]],

		(*ELSE: not used at all.*)
		secondaryAntibodyResourcesSampleIndexed=Null;
		secondaryAntibodyResourcesStandardIndexed=Null;
		secondaryAntibodyResourcesBlankIndexed=Null;
		secondaryAntibodyResources=Null;
		secondaryAntibodyVolumesCombined=Null;
		secondaryAntibodyConcentrateResources=Null;
		secondaryAntibodyDiluentVolumeForEachDilution=Null;
		secondaryAntibodyVolumeForEachDilution=Null;
		secondaryAntibodyDiluentVolumeCombined=Null;
		secondaryAntibodyDilutionContainerResources=Null;
		secondaryAntibodyWorkingResources=Null;
		secondaryAntibodyWorkingResourcesSampleIndexed=Null;
		secondaryAntibodyWorkingResourcesStandardIndexed=Null;
		secondaryAntibodyWorkingResourcesBlankIndexed=Null;
		secondaryAntibodyStorageConditionCombined=Null
	];

	(* -- Capture antibody and diluent: Mix with samples, mixed with diluent, or not used -- *)

	If[(MatchQ[resolvedMethod, Alternatives[DirectSandwichELISA,IndirectSandwichELISA]]&&resolvedCoating===True)||MatchQ[resolvedMethod, FastELISA],

		{captureAntibodyDeDuplicates,captureAntibodyVolumesCombined}=elisaListMerge[resolverAllCaptureAntibodies,resolverAllCaptureAntibodyVolumes,(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		captureAntibodyResources=MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,{captureAntibodyDeDuplicates,captureAntibodyVolumesCombined}];
		captureAntibodyResourcesSampleIndexed=elisaExtractResources[captureAntibodyResources,#]&/@resolvedCaptureAntibody;
		captureAntibodyResourcesStandardIndexed=elisaExtractResources[captureAntibodyResources,#]&/@resolvedStandardCaptureAntibody;
		captureAntibodyResourcesBlankIndexed=elisaExtractResources[captureAntibodyResources,#]&/@resolvedBlankCaptureAntibody;

		(*Split Methods from the first If*)
		If[MatchQ[resolvedMethod, FastELISA],(*If FastELISA, antibody is diluted in sample, no diluent and working resource is the original capture antibody.*)
			captureAntibodyDiluentVolumeCombined=Null;
			captureAntibodyDiluentVolumeForEachDilution=Null;
			captureAntibodyDilutionContainerResources=Null;
			captureAntibodyWorkingResources=captureAntibodyResources;
			captureAntibodyWorkingResourcesSampleIndexed=captureAntibodyResourcesSampleIndexed;
			captureAntibodyWorkingResourcesStandardIndexed=captureAntibodyResourcesStandardIndexed;
			captureAntibodyWorkingResourcesBlankIndexed=captureAntibodyResourcesBlankIndexed;
			captureAntibodyStorageConditionCombined=Null,


			(*ELSE: SandwichELISA+Coating===True. Capture antibody is diluted for coating. Similar to immunosorbence, dilution factor matters.*)
			{captureAntibodiesWithFactorsDeDuplicates,captureAntibodyAssayVolumeCombined}=elisaListMerge[resolverAllCaptureAntibodiesWithFactors,resolverAllCaptureAntibodyAssayVolumes,(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
			captureAntibodyDiluentVolumeCombined=(Total[resolverAllCaptureAntibodyAssayVolumes]-Total[resolverAllCaptureAntibodyVolumes]);
			captureAntibodyAssayVolumeCombinedUndilutionToNull=MapThread[If[MatchQ[#1[[2]],1],Null,#2]&,{captureAntibodiesWithFactorsDeDuplicates,captureAntibodyAssayVolumeCombined}];
			captureAntibodyWorkingResources=MapThread[
				If[MatchQ[#1,Null],elisaExtractResources[captureAntibodyResources,#2[[1]]],Resource[Sample->elisaContainerPicker[#1],Name->ToString[Unique[]]]]&,{captureAntibodyAssayVolumeCombinedUndilutionToNull,captureAntibodiesWithFactorsDeDuplicates}];
			captureAntibodyWithFactorToWorkingResourceLookupTable=MapThread[#1->#2&,{captureAntibodiesWithFactorsDeDuplicates,captureAntibodyWorkingResources}]//Association;
			captureAntibodyWorkingResourcesAllIndexed=captureAntibodyWithFactorToWorkingResourceLookupTable[#]&/@resolverAllCaptureAntibodiesWithFactors;
			captureAntibodyWorkingResourcesSampleIndexed=Take[captureAntibodyWorkingResourcesAllIndexed,sampleRange];
			captureAntibodyWorkingResourcesStandardIndexed=Take[captureAntibodyWorkingResourcesAllIndexed,standardRange];
			captureAntibodyWorkingResourcesBlankIndexed=Take[captureAntibodyWorkingResourcesAllIndexed,blankRange];
			captureAntibodyDilutionContainerResources=captureAntibodyWorkingResources/.{Alternatives@@ToList[captureAntibodyResources]->Null};
			captureAntibodyConcentrateResources=Map[elisaExtractResources[captureAntibodyResources,#]&,captureAntibodiesWithFactorsDeDuplicates[[All,1]]];
			captureAntibodyVolumeForEachDilution=MapThread[#1*#2&,{captureAntibodyAssayVolumeCombined,captureAntibodiesWithFactorsDeDuplicates[[All,2]]}];
			captureAntibodyDiluentVolumeForEachDilution=MapThread[#1*(1-#2)&,{captureAntibodyAssayVolumeCombined,captureAntibodiesWithFactorsDeDuplicates[[All,2]]}];
			captureAntibodyStorageConditionCombined=FirstOrDefault[PickList[ToList[resolvedCaptureAntibodyStorageCondition],ToList[captureAntibodyResourcesSampleIndexed],#]]&/@captureAntibodiesWithFactorsDeDuplicates[[All,1]]
		],


		(*ELSE for the first IF: not used at all*)
		captureAntibodyResourcesSampleIndexed=Null;
		captureAntibodyResourcesStandardIndexed=Null;
		captureAntibodyResourcesBlankIndexed=Null;
		captureAntibodyResources=Null;
		captureAntibodyVolumesCombined=Null;
		captureAntibodyDiluentVolumeCombined=Null;
		captureAntibodyConcentrateResources=Null;
		captureAntibodyDiluentVolumeForEachDilution=Null;
		captureAntibodyVolumeForEachDilution=Null;
		captureAntibodyDilutionContainerResources=Null;
		captureAntibodyWorkingResources=Null;
		captureAntibodyWorkingResourcesSampleIndexed=Null;
		captureAntibodyWorkingResourcesStandardIndexed=Null;
		captureAntibodyWorkingResourcesBlankIndexed=Null;
		captureAntibodyStorageConditionCombined=Null

	];

	(* -- Coating antibody and diluent: similar to secondary antibodies--either diluted into diluent or not used at all -- *)

		If[MatchQ[resolvedMethod, FastELISA]&&resolvedCoating===True,
			{coatingAntibodyDeDuplicates,coatingAntibodyVolumesCombined}=elisaListMerge[resolverAllCoatingAntibodies,resolverAllCoatingAntibodyVolumes,
				(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
			coatingAntibodyResources=MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
				{coatingAntibodyDeDuplicates,coatingAntibodyVolumesCombined}];
			coatingAntibodyResourcesSampleIndexed=elisaExtractResources[coatingAntibodyResources,#]&/@resolvedCoatingAntibody;
			coatingAntibodyResourcesStandardIndexed=elisaExtractResources[coatingAntibodyResources,#]&/@resolvedStandardCoatingAntibody;
			coatingAntibodyResourcesBlankIndexed=elisaExtractResources[coatingAntibodyResources,#]&/@resolvedBlankCoatingAntibody;

			{coatingAntibodiesWithFactorsDeDuplicates,coatingAntibodyAssayVolumeCombined}=elisaListMerge[resolverAllCoatingAntibodiesWithFactors,resolverAllCoatingAntibodyAssayVolumes,
				(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];

			coatingAntibodyDiluentVolumeCombined=(Total[resolverAllCoatingAntibodyAssayVolumes]-Total[resolverAllCoatingAntibodyVolumes]);

			coatingAntibodyAssayVolumeCombinedUndilutionToNull=MapThread[If[MatchQ[#1[[2]],1],Null,#2]&,{coatingAntibodiesWithFactorsDeDuplicates,coatingAntibodyAssayVolumeCombined}];
			coatingAntibodyWorkingResources=MapThread[
				If[MatchQ[#1,Null],elisaExtractResources[coatingAntibodyResources,#2[[1]]],Resource[Sample->elisaContainerPicker[#1],Name->ToString[Unique[]]]]&,
				{coatingAntibodyAssayVolumeCombinedUndilutionToNull,coatingAntibodiesWithFactorsDeDuplicates}];
			coatingAntibodyWithFactorToWorkingResourceLookupTable=MapThread[#1->#2&,{coatingAntibodiesWithFactorsDeDuplicates,coatingAntibodyWorkingResources}]//Association;
			coatingAntibodyWorkingResourcesAllIndexed=coatingAntibodyWithFactorToWorkingResourceLookupTable[#]&/@resolverAllCoatingAntibodiesWithFactors;
			coatingAntibodyWorkingResourcesSampleIndexed=Take[coatingAntibodyWorkingResourcesAllIndexed,sampleRange];
			coatingAntibodyWorkingResourcesStandardIndexed=Take[coatingAntibodyWorkingResourcesAllIndexed,standardRange];
			coatingAntibodyWorkingResourcesBlankIndexed=Take[coatingAntibodyWorkingResourcesAllIndexed,blankRange];
			coatingAntibodyDilutionContainerResources=coatingAntibodyWorkingResources/.{Alternatives@@ToList[coatingAntibodyResources]->Null};

			coatingAntibodyConcentrateResources=Map[elisaExtractResources[coatingAntibodyResources,#]&,coatingAntibodiesWithFactorsDeDuplicates[[All,1]]];
			coatingAntibodyVolumeForEachDilution=MapThread[#1*#2&,{coatingAntibodyAssayVolumeCombined,coatingAntibodiesWithFactorsDeDuplicates[[All,2]]}];
			coatingAntibodyDiluentVolumeForEachDilution=MapThread[#1*(1-#2)&,{coatingAntibodyAssayVolumeCombined,coatingAntibodiesWithFactorsDeDuplicates[[All,2]]}];
			coatingAntibodyStorageConditionCombined=FirstOrDefault[PickList[ToList[resolvedCoatingAntibodyStorageCondition],ToList[coatingAntibodyResourcesSampleIndexed],#]]&/@coatingAntibodiesWithFactorsDeDuplicates[[All,1]],

			(*ELSE: not used at all.*)
			coatingAntibodyResourcesSampleIndexed=Null;
			coatingAntibodyResourcesStandardIndexed=Null;
			coatingAntibodyResourcesBlankIndexed=Null;
			coatingAntibodyResources=Null;
			coatingAntibodyVolumesCombined=Null;
			coatingAntibodyConcentrateResources=Null;
			coatingAntibodyDiluentVolumeForEachDilution=Null;
			coatingAntibodyVolumeForEachDilution=Null;
			coatingAntibodyDiluentVolumeCombined=Null;
			coatingAntibodyDilutionContainerResources=Null;
			coatingAntibodyWorkingResources=Null;
			coatingAntibodyWorkingResourcesSampleIndexed=Null;
			coatingAntibodyWorkingResourcesStandardIndexed=Null;
			coatingAntibodyWorkingResourcesBlankIndexed=Null;
			coatingAntibodyStorageConditionCombined=Null
		];
	
	(* -- Reference antigen and diluent: similar to secondary antibodies--either diluted into diluent or not used at all -- *)

	If[(MatchQ[resolvedMethod, Alternatives[DirectCompetitiveELISA,IndirectCompetitiveELISA]]&&resolvedCoating===True),

		{referenceAntigenDeDuplicates,referenceAntigenVolumesCombined}=elisaListMerge[resolverAllReferenceAntigens,resolverAllReferenceAntigenVolumes,
			(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		referenceAntigenResources=MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
			{referenceAntigenDeDuplicates,referenceAntigenVolumesCombined}];
		referenceAntigenResourcesSampleIndexed=elisaExtractResources[referenceAntigenResources,#]&/@resolvedReferenceAntigen;
		referenceAntigenResourcesStandardIndexed=elisaExtractResources[referenceAntigenResources,#]&/@resolvedStandardReferenceAntigen;
		referenceAntigenResourcesBlankIndexed=elisaExtractResources[referenceAntigenResources,#]&/@resolvedBlankReferenceAntigen;

		{referenceAntigensWithFactorsDeDuplicates,referenceAntigenAssayVolumeCombined}=elisaListMerge[resolverAllReferenceAntigensWithFactors,resolverAllReferenceAntigenAssayVolumes,
			(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		referenceAntigenDiluentVolumeCombined=(Total[resolverAllReferenceAntigenAssayVolumes]-Total[resolverAllReferenceAntigenVolumes]);

		referenceAntigenAssayVolumeCombinedUndilutionToNull=MapThread[If[MatchQ[#1[[2]],1],Null,#2]&,{referenceAntigensWithFactorsDeDuplicates,referenceAntigenAssayVolumeCombined}];
		referenceAntigenWorkingResources=MapThread[
			If[MatchQ[#1,Null],elisaExtractResources[referenceAntigenResources,#2[[1]]],Resource[Sample->elisaContainerPicker[#1],Name->ToString[Unique[]]]]&,
			{referenceAntigenAssayVolumeCombinedUndilutionToNull,referenceAntigensWithFactorsDeDuplicates}];
		referenceAntigenWithFactorToWorkingResourceLookupTable=MapThread[#1->#2&,{referenceAntigensWithFactorsDeDuplicates,referenceAntigenWorkingResources}]//Association;
		referenceAntigenWorkingResourcesAllIndexed=referenceAntigenWithFactorToWorkingResourceLookupTable[#]&/@resolverAllReferenceAntigensWithFactors;
		referenceAntigenWorkingResourcesSampleIndexed=Take[referenceAntigenWorkingResourcesAllIndexed,sampleRange];
		referenceAntigenWorkingResourcesStandardIndexed=Take[referenceAntigenWorkingResourcesAllIndexed,standardRange];
		referenceAntigenWorkingResourcesBlankIndexed=Take[referenceAntigenWorkingResourcesAllIndexed,blankRange];
		referenceAntigenDilutionContainerResources=referenceAntigenWorkingResources/.{Alternatives@@ToList[referenceAntigenResources]->Null};
		referenceAntigenConcentrateResources=Map[elisaExtractResources[referenceAntigenResources,#]&,referenceAntigensWithFactorsDeDuplicates[[All,1]]];
		referenceAntigenVolumeForEachDilution=MapThread[#1*#2&,{referenceAntigenAssayVolumeCombined,referenceAntigensWithFactorsDeDuplicates[[All,2]]}];
		referenceAntigenDiluentVolumeForEachDilution=MapThread[#1*(1-#2)&,{referenceAntigenAssayVolumeCombined,referenceAntigensWithFactorsDeDuplicates[[All,2]]}];
		referenceAntigenStorageConditionCombined=FirstOrDefault[PickList[ToList[resolvedReferenceAntigenStorageCondition],ToList[referenceAntigenResourcesSampleIndexed],#]]&/@referenceAntigensWithFactorsDeDuplicates[[All,1]],
		
		(*ELSE: not used at all.*)
		referenceAntigenResourcesSampleIndexed=Null;
		referenceAntigenResourcesStandardIndexed=Null;
		referenceAntigenResourcesBlankIndexed=Null;
		referenceAntigenResources=Null;
		referenceAntigenVolumesCombined=Null;
		referenceAntigenConcentrateResources=Null;
		referenceAntigenDiluentVolumeForEachDilution=Null;
		referenceAntigenVolumeForEachDilution=Null;
		referenceAntigenDiluentVolumeCombined=Null;
		referenceAntigenDilutionContainerResources=Null;
		referenceAntigenWorkingResources=Null;
		referenceAntigenWorkingResourcesSampleIndexed=Null;
		referenceAntigenWorkingResourcesStandardIndexed=Null;
		referenceAntigenWorkingResourcesBlankIndexed=Null;
		referenceAntigenStorageConditionCombined=Null
	];

	(* -- Figure out Antibodies/Antigens that need to be diluted -- *)
	(*Helper function to extract antibody, antibody volume, diluent volume, and container resources that are needed for dilution*)

	elisaExtractDilutionParams[conc_,concVol_,diluVol_,diluContainer_,storage_]:=Module[
		{concToDilute,concVolToDilute,diluVolToDilute,diluContainerToDilute,concStorage},
		(*If the antibody/antigen is not needed at all or nothing need to be diluted, then return 4 empty lists*)
		If[MatchQ[diluContainer, Null|{}|{Null..}],
			{{},{},{},{},{}},
			(*Otherwise, get rid of the ones where dilution container is Null*)
			concToDilute=PickList[ToList[conc],ToList[diluContainer],Except[Null]];
			concVolToDilute=PickList[ToList[concVol],ToList[diluContainer],Except[Null]];
			diluVolToDilute=PickList[ToList[diluVol],ToList[diluContainer],Except[Null]];
			diluContainerToDilute=DeleteCases[diluContainer,Null];
			concStorage=PickList[ToList[storage],ToList[diluContainer],Except[Null]];
			{concToDilute,concVolToDilute,diluVolToDilute,diluContainerToDilute,concStorage}
		]
	];

	{primaryAntibodiesToDilute,primaryAntibodyDilutionVolumes,primaryAntibodyDiluentDilutionVolumes,primaryAntibodyDilutionContainers,primaryAntibodiesToDiluteStorage}=elisaExtractDilutionParams[primaryAntibodyConcentrateResources,primaryAntibodyVolumeForEachDilution,primaryAntibodyDiluentVolumeForEachDilution,primaryAntibodyDilutionContainerResources,primaryAntibodyStorageConditionCombined];

	secondaryAntibodyOnDeckError = False;
	{
		secondaryAntibodiesToDilute,
		secondaryAntibodyDilutionVolumes,
		secondaryAntibodyDiluentDilutionVolumes,
		secondaryAntibodyDilutionContainers,
		secondaryAntibodiesToDiluteStorage
	} = If[TrueQ[resolvedSecondaryAntibodyDilutionOnDeck],
		(* When resolvedSecondaryAntibodyDilutionOnDeck is True, secondaryAntibodyDilutionContainers is {}. Pick a SBS deep well plate manually here. Otherwise have bunch of 2ml tubes for antibody dilution subprotocols *)
		(* Also check if any dilution volume is beyond 1.8ml or total number of wells beyond 96 *)
		If[GreaterQ[Length[secondaryAntibodyVolumeForEachDilution], 96]||MemberQ[Plus[secondaryAntibodyVolumeForEachDilution,secondaryAntibodyDiluentVolumeForEachDilution],GreaterP[1.8 Milliliter]],
			Message[
				Error::SecondaryAntibodyDilutionVolumeTooLarge,
				ToString[Length[secondaryAntibodyVolumeForEachDilution]],
				ToString@Max[Plus[secondaryAntibodyVolumeForEachDilution,secondaryAntibodyDiluentVolumeForEachDilution]]
			];secondaryAntibodyOnDeckError=True
		];
		{
			secondaryAntibodyConcentrateResources,
			secondaryAntibodyVolumeForEachDilution,
			secondaryAntibodyDiluentVolumeForEachDilution,
			{Resource[Sample->Model[Container, Plate, "id:L8kPEjkmLbvW"], Name->ToString[Unique[]]]},(*Model[Container, Plate, "96-well 2mL Deep Well Plate"]*)
			secondaryAntibodyStorageConditionCombined
		},
		elisaExtractDilutionParams[
			secondaryAntibodyConcentrateResources,
			secondaryAntibodyVolumeForEachDilution,
			secondaryAntibodyDiluentVolumeForEachDilution,
			secondaryAntibodyDilutionContainerResources,
			secondaryAntibodyStorageConditionCombined
		]
	];

	{captureAntibodiesToDilute,captureAntibodyDilutionVolumes,captureAntibodyDiluentDilutionVolumes,captureAntibodyDilutionContainers,captureAntibodiesToDiluteStorage}=elisaExtractDilutionParams[captureAntibodyConcentrateResources,captureAntibodyVolumeForEachDilution,captureAntibodyDiluentVolumeForEachDilution,captureAntibodyDilutionContainerResources,captureAntibodyStorageConditionCombined];
	
	{coatingAntibodiesToDilute,coatingAntibodyDilutionVolumes,coatingAntibodyDiluentDilutionVolumes,coatingAntibodyDilutionContainers,coatingAntibodiesToDiluteStorage}=elisaExtractDilutionParams[coatingAntibodyConcentrateResources,coatingAntibodyVolumeForEachDilution,coatingAntibodyDiluentVolumeForEachDilution,coatingAntibodyDilutionContainerResources,coatingAntibodyStorageConditionCombined];

	{referenceAntigensToDilute,referenceAntigenDilutionVolumes,referenceAntigenDiluentDilutionVolumes,referenceAntigenDilutionContainers,referenceAntigensToDiluteStorage}=elisaExtractDilutionParams[referenceAntigenConcentrateResources,referenceAntigenVolumeForEachDilution,referenceAntigenDiluentVolumeForEachDilution,referenceAntigenDilutionContainerResources,referenceAntigenStorageConditionCombined];


	(* -- Combine diluents-- *)
	(*NOTE: we are only combining resources that will be resource-picked at the same time. If resources are combined and at picked at the separate stages while the previously picked resource is still in cart, the procedure will break.*)
	(* We may have the very extreme case that the dilution is not real - with a dilution factor of 1. Then the required diluent volume is 0. We want to drop these cases as well  *)
	joinedSampleStandardDiluents=MapThread[
		Function[
			{diluent,volume},
			If[MatchQ[diluent,ListableP[Null]]||MatchQ[volume,ListableP[Null]|0Microliter|0],
				Nothing,
				diluent
			]
		],
		{
			Flatten[{resolvedSampleDiluent,resolvedStandardDiluent}],
			Flatten[{sampleDiluentVolume,standardDiluentVolume}]
		}
	];

	joinedSampleStandardDiluentVolumes=DeleteCases[{sampleDiluentVolume,standardDiluentVolume}//Flatten,(Null|{Null..}|0Microliter|0)];

	{sampleStandardDiluentDeDup,sampleStandardVolumesDedup}=elisaListMerge[joinedSampleStandardDiluents,joinedSampleStandardDiluentVolumes,Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&];

	sampleStandardDiluentResources=MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
		{sampleStandardDiluentDeDup,sampleStandardVolumesDedup}];

	sampleDiluentResource=elisaExtractResources[sampleStandardDiluentResources,resolvedSampleDiluent];
	standardDiluentResource=elisaExtractResources[sampleStandardDiluentResources,resolvedStandardDiluent];

	(* If we are diluting secondary antibody in immuosorbent step, do not set the AntibodyAntigenDilutionQ to True *)
	(* When AntibodyAntigenDilutionQ is True, a MSP is spinned out before coating step to dilute antibodies *)
	antibodyAntigenDilutionQ=!MatchQ[
		Flatten[{
			primaryAntibodyDilutionContainers,
			If[TrueQ[resolvedSecondaryAntibodyDilutionOnDeck], {}, secondaryAntibodyDilutionContainers],
			captureAntibodyDilutionContainers,
			coatingAntibodyDilutionContainers,
			referenceAntigenDilutionContainers
		}],
		{}|Null|{Null..}
	];

	joinedAntibodyDiluents=DeleteCases[{
		resolvedPrimaryAntibodyDiluent,resolvedSecondaryAntibodyDiluent,
		resolvedCaptureAntibodyDiluent,resolvedCoatingAntibodyDiluent,resolvedReferenceAntigenDiluent
	}//Flatten,(Null|{Null..})];
	joinedAntibodyDiluentVolumes=DeleteCases[{primaryAntibodyDiluentVolumeCombined,
		secondaryAntibodyDiluentVolumeCombined,captureAntibodyDiluentVolumeCombined,coatingAntibodyDiluentVolumeCombined,
		referenceAntigenDiluentVolumeCombined
	}//Flatten,(Null|0Microliter|0)];

	{antibodyDiluentsDeDup,antibodyDiluentVolumesDeDup}=elisaListMerge[joinedAntibodyDiluents,joinedAntibodyDiluentVolumes,Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&];
	antibodyDiluentResources=MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,
		{antibodyDiluentsDeDup,antibodyDiluentVolumesDeDup}
	];


	primaryAntibodyDiluentResource=elisaExtractResources[antibodyDiluentResources,resolvedPrimaryAntibodyDiluent];
	secondaryAntibodyDiluentResource=elisaExtractResources[antibodyDiluentResources,resolvedSecondaryAntibodyDiluent];
	captureAntibodyDiluentResource=elisaExtractResources[antibodyDiluentResources,resolvedCaptureAntibodyDiluent];
	coatingAntibodyDiluentResource=elisaExtractResources[antibodyDiluentResources,resolvedCoatingAntibodyDiluent];
	referenceAntigenDiluentResource=elisaExtractResources[antibodyDiluentResources,resolvedReferenceAntigenDiluent];



	(* -- Washing buffer: WashVolumes are not indexMatched and cannot be combined with other buffers because of the container -- *)
	(*NOTE: we are doing whole plate wash*)
	numWellsToWash=If[MatchQ[resolvedSecondaryELISAPlate,Null],96,192];
	(*NumWells=Ceiling[Length[resolvedELISAPlateAssignment],8]+Ceiling[Length[resolvedSecondaryELISAPlateAssignment],8]; *)(*This accounted for NumberOfReplicates. Because a column of wells must be washed together, the number of wells in each plate must be rounded up to the multiply of 8.*)
	washVolumeList=DeleteCases[
		{
			resolvedCoatingWashVolume*resolvedCoatingNumberOfWashes,
			resolvedBlockingWashVolume*resolvedBlockingNumberOfWashes,
			resolvedSampleAntibodyComplexImmunosorbentWashVolume*resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,
			resolvedSampleImmunosorbentWashVolume*resolvedSampleImmunosorbentNumberOfWashes,
			resolvedPrimaryAntibodyImmunosorbentWashVolume*resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,
			resolvedSecondaryAntibodyImmunosorbentWashVolume*resolvedSecondaryAntibodyImmunosorbentNumberOfWashes
		},
		(Null|{Null}|{}|Null^2)
	];
	(*Total wash volume add 200ml of dead volume*)
	TotalWashVolume=Total[washVolumeList]*numWellsToWash*resolverPipettingError+200Milliliter;
	washingBufferResource=Resource[Sample->resolvedWashingBuffer,Name->ToString[Unique[]], Amount->TotalWashVolume,Container->Model[Container, Vessel, "id:3em6Zv9Njjbv"]];


	(* -- Substrate: SubstrateSolution and volumes are both indexMatched -- *)
	(*NOTE all antibodies took resolver passdown variables, which were expanded by dilution curves. Substrate and Stop have not been expanded. So here we are expanding them.*)
	joinedDeNulledSubstrate=DeleteCases[Join[ToList[resolvedSubstrateSolution],ToList[resolvedStandardSubstrateSolution],ToList[resolvedBlankSubstrateSolution]],Null];
	curveExpandedJoinedSubstrate=Flatten[MapThread[ConstantArray[#1,#2]&,{joinedDeNulledSubstrate,resolverJoinedCurveExpansionParams}],1];
	
	substrateResources=If[MatchQ[joinedDeNulledSubstrate,{}],Null,
		(*Else*)
		joinedDeNulledSubstrateVolumes=DeleteCases[Join[
			ToList[resolvedSubstrateSolutionVolume],
			ToList[resolvedStandardSubstrateSolutionVolume],
			ToList[resolvedBlankSubstrateSolutionVolume]
		],Null];
		curveExpandedJoinedSubstrateVolumes=Flatten[MapThread[ConstantArray[#1,#2]&,{joinedDeNulledSubstrateVolumes,resolverJoinedCurveExpansionParams}],1];
		{substrateDeDuplicates,substrateVolumesCombined}=elisaListMerge[curveExpandedJoinedSubstrate,curveExpandedJoinedSubstrateVolumes,(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,{substrateDeDuplicates,substrateVolumesCombined}]
	];
	
	substrateResourcesSampleIndexed=elisaExtractResources[substrateResources,#]&/@resolvedSubstrateSolution;
	substrateResourcesStandardIndexed=elisaExtractResources[substrateResources,#]&/@resolvedStandardSubstrateSolution;
	substrateResourcesBlankIndexed=elisaExtractResources[substrateResources,#]&/@resolvedBlankSubstrateSolution;
	
	(*Stop Solutions*)
	joinedDeNulledStop=DeleteCases[Join[ToList[resolvedStopSolution],ToList[resolvedStandardStopSolution],ToList[resolvedBlankStopSolution]],Null];
	curveExpandedJoinedStop=Flatten[MapThread[ConstantArray[#1,#2]&,{joinedDeNulledStop,resolverJoinedCurveExpansionParams}],1];

	stopResources=If[MatchQ[joinedDeNulledStop,{}],Null,
		(*Else*)
		joinedDeNulledStopVolumes=DeleteCases[Join[
			ToList[resolvedStopSolutionVolume],
			ToList[resolvedStandardStopSolutionVolume],
			ToList[resolvedBlankStopSolutionVolume]
		],Null];
		curveExpandedJoinedStopVolumes=Flatten[MapThread[ConstantArray[#1,#2]&,{joinedDeNulledStopVolumes,resolverJoinedCurveExpansionParams}],1];
		{stopDeDuplicates,stopVolumesCombined}=elisaListMerge[curveExpandedJoinedStop,curveExpandedJoinedStopVolumes,(Total[#]*resolverPipettingError*resolvedNumberOfReplicatesNullToOne&)];
		MapThread[Resource[Sample->#1,Name->ToString[Unique[]], Amount->#2,Container->elisaContainerPicker[#2]]&,{stopDeDuplicates,stopVolumesCombined}]
	];

	stopResourcesSampleIndexed=elisaExtractResources[stopResources,#]&/@resolvedStopSolution;
	stopResourcesStandardIndexed=elisaExtractResources[stopResources,#]&/@resolvedStandardStopSolution;
	stopResourcesBlankIndexed=elisaExtractResources[stopResources,#]&/@resolvedBlankStopSolution;

	(* --ELISA plates-- *)

	{elisaPlateResource,secondaryELISAPlateResource}=
		If[(*If sample is coated, take ContainersIn*)
			MatchQ[resolvedMethod,DirectELISA|IndirectELISA]&&resolvedCoating===False,
			If[MatchQ[resolvedSecondaryELISAPlate,ObjectP[]],
				containersInResources,
				{containersInResources,Null}// Flatten
			],
			{
				Resource[Sample->resolvedELISAPlate,Name->ToString[Unique[]]],
				If[MatchQ[resolvedSecondaryELISAPlate,ObjectP[]],
					Resource[Sample->resolvedSecondaryELISAPlate,Name->ToString[Unique[]]],
					Null
				]
			}
		];

	(* --Sample assembly plate--*)

	sampleAssemblyQ=If[MatchQ[resolvedMethod,DirectELISA|IndirectELISA]&&MatchQ[resolvedCoating,False],
		False,
		True
	];
	numAssemblyPlate=If[MatchQ[resolvedSecondaryELISAPlate,Null],1,2];

	If[sampleAssemblyQ,
		sampleAssemblyPlate= PreferredContainer[1.5 Milliliter, Type -> Plate, LiquidHandlerCompatible -> True];

		sampleAssemblyContainerResource=Resource[Sample->sampleAssemblyPlate, Name->ToString[Unique[]]];
		secondarySampleAssemblyContainerResource=If[numAssemblyPlate===2,
			Resource[Sample->sampleAssemblyPlate, Name->ToString[Unique[]]],
			Null
		],

		sampleAssemblyContainerResource=Null;
		secondarySampleAssemblyContainerResource=Null
	];

	(* --Lid resource-- Model[Item, Consumable, "id:XnlV5jmbZZ8Z"]*)
	(*lidResource=Resource[Sample->Model[Item, Lid,"id:N80DNj16AaKA"], Name->ToString[Unique[]], Amount->numAssemblyPlate];*)


	(*In resolver an empty SecondaryELISAPlateAssignment is replaced to Null. Here we need it back*)
	resolvedSecondaryELISAPlateAssignmentNullToEmpty=If[NullQ[resolvedSecondaryELISAPlateAssignment],{},resolvedSecondaryELISAPlateAssignment];

	(* -- Sort out Expanded fields for Engine function -- *)
	If[MatchQ[{resolvedMethod,resolvedCoating},{(DirectELISA|IndirectELISA),False}],
		(*When samples and standards are coated on plates*)
		expandingParams=ConstantArray[1,sampleNumber+standardNumber];
		expandedConcentrateVolumes={};
		expandedDiluentVolumes={};
		expandedSpikeVolumes={};
		expandedPrimaryAntibodySampleMixingVolumes={};
		expandedCaptureAntibodySampleMixingVolumes={};
		expanededJoinedAssayVolumes={};
		expandedJoinedDiluents={};
		expandedJoinedSpikes={};
		expandedSerialQ={};

		(*When samples are coated on the plate, the samples must be rearranged so that they are in consecutive, column wise order. But we need to cut off at the number of samples since it is possible not the entire plate is coated*)
		numberOfSamplesPrimaryPlate=Length[resolvedELISAPlateAssignment];
		primaryPlateSamplePositions={{elisaPlateResource,"A1"},{elisaPlateResource,"B1"},{elisaPlateResource,"C1"},{elisaPlateResource,"D1"},{elisaPlateResource,"E1"},{elisaPlateResource,"F1"},{elisaPlateResource,"G1"},{elisaPlateResource,"H1"},{elisaPlateResource,"A2"},{elisaPlateResource,"B2"},{elisaPlateResource,"C2"},{elisaPlateResource,"D2"},{elisaPlateResource,"E2"},{elisaPlateResource,"F2"},{elisaPlateResource,"G2"},{elisaPlateResource,"H2"},{elisaPlateResource,"A3"},{elisaPlateResource,"B3"},{elisaPlateResource,"C3"},{elisaPlateResource,"D3"},{elisaPlateResource,"E3"},{elisaPlateResource,"F3"},{elisaPlateResource,"G3"},{elisaPlateResource,"H3"},{elisaPlateResource,"A4"},{elisaPlateResource,"B4"},{elisaPlateResource,"C4"},{elisaPlateResource,"D4"},{elisaPlateResource,"E4"},{elisaPlateResource,"F4"},{elisaPlateResource,"G4"},{elisaPlateResource,"H4"},{elisaPlateResource,"A5"},{elisaPlateResource,"B5"},{elisaPlateResource,"C5"},{elisaPlateResource,"D5"},{elisaPlateResource,"E5"},{elisaPlateResource,"F5"},{elisaPlateResource,"G5"},{elisaPlateResource,"H5"},{elisaPlateResource,"A6"},{elisaPlateResource,"B6"},{elisaPlateResource,"C6"},{elisaPlateResource,"D6"},{elisaPlateResource,"E6"},{elisaPlateResource,"F6"},{elisaPlateResource,"G6"},{elisaPlateResource,"H6"},{elisaPlateResource,"A7"},{elisaPlateResource,"B7"},{elisaPlateResource,"C7"},{elisaPlateResource,"D7"},{elisaPlateResource,"E7"},{elisaPlateResource,"F7"},{elisaPlateResource,"G7"},{elisaPlateResource,"H7"},{elisaPlateResource,"A8"},{elisaPlateResource,"B8"},{elisaPlateResource,"C8"},{elisaPlateResource,"D8"},{elisaPlateResource,"E8"},{elisaPlateResource,"F8"},{elisaPlateResource,"G8"},{elisaPlateResource,"H8"},{elisaPlateResource,"A9"},{elisaPlateResource,"B9"},{elisaPlateResource,"C9"},{elisaPlateResource,"D9"},{elisaPlateResource,"E9"},{elisaPlateResource,"F9"},{elisaPlateResource,"G9"},{elisaPlateResource,"H9"},{elisaPlateResource,"A10"},{elisaPlateResource,"B10"},{elisaPlateResource,"C10"},{elisaPlateResource,"D10"},{elisaPlateResource,"E10"},{elisaPlateResource,"F10"},{elisaPlateResource,"G10"},{elisaPlateResource,"H10"},{elisaPlateResource,"A11"},{elisaPlateResource,"B11"},{elisaPlateResource,"C11"},{elisaPlateResource,"D11"},{elisaPlateResource,"E11"},{elisaPlateResource,"F11"},{elisaPlateResource,"G11"},{elisaPlateResource,"H11"},{elisaPlateResource,"A12"},{elisaPlateResource,"B12"},{elisaPlateResource,"C12"},{elisaPlateResource,"D12"},{elisaPlateResource,"E12"},{elisaPlateResource,"F12"},{elisaPlateResource,"G12"},{elisaPlateResource,"H12"}}[[;;numberOfSamplesPrimaryPlate]];

		numberOfSamplesSecondaryPlate=Length[resolvedSecondaryELISAPlateAssignmentNullToEmpty];
		secondaryPlateSamplePositions=If[MatchQ[resolvedSecondaryELISAPlateAssignmentNullToEmpty,{}|{Null..}|Null],{},
			{{secondaryELISAPlateResource,"A1"},{secondaryELISAPlateResource,"B1"},{secondaryELISAPlateResource,"C1"},{secondaryELISAPlateResource,"D1"},{secondaryELISAPlateResource,"E1"},{secondaryELISAPlateResource,"F1"},{secondaryELISAPlateResource,"G1"},{secondaryELISAPlateResource,"H1"},{secondaryELISAPlateResource,"A2"},{secondaryELISAPlateResource,"B2"},{secondaryELISAPlateResource,"C2"},{secondaryELISAPlateResource,"D2"},{secondaryELISAPlateResource,"E2"},{secondaryELISAPlateResource,"F2"},{secondaryELISAPlateResource,"G2"},{secondaryELISAPlateResource,"H2"},{secondaryELISAPlateResource,"A3"},{secondaryELISAPlateResource,"B3"},{secondaryELISAPlateResource,"C3"},{secondaryELISAPlateResource,"D3"},{secondaryELISAPlateResource,"E3"},{secondaryELISAPlateResource,"F3"},{secondaryELISAPlateResource,"G3"},{secondaryELISAPlateResource,"H3"},{secondaryELISAPlateResource,"A4"},{secondaryELISAPlateResource,"B4"},{secondaryELISAPlateResource,"C4"},{secondaryELISAPlateResource,"D4"},{secondaryELISAPlateResource,"E4"},{secondaryELISAPlateResource,"F4"},{secondaryELISAPlateResource,"G4"},{secondaryELISAPlateResource,"H4"},{secondaryELISAPlateResource,"A5"},{secondaryELISAPlateResource,"B5"},{secondaryELISAPlateResource,"C5"},{secondaryELISAPlateResource,"D5"},{secondaryELISAPlateResource,"E5"},{secondaryELISAPlateResource,"F5"},{secondaryELISAPlateResource,"G5"},{secondaryELISAPlateResource,"H5"},{secondaryELISAPlateResource,"A6"},{secondaryELISAPlateResource,"B6"},{secondaryELISAPlateResource,"C6"},{secondaryELISAPlateResource,"D6"},{secondaryELISAPlateResource,"E6"},{secondaryELISAPlateResource,"F6"},{secondaryELISAPlateResource,"G6"},{secondaryELISAPlateResource,"H6"},{secondaryELISAPlateResource,"A7"},{secondaryELISAPlateResource,"B7"},{secondaryELISAPlateResource,"C7"},{secondaryELISAPlateResource,"D7"},{secondaryELISAPlateResource,"E7"},{secondaryELISAPlateResource,"F7"},{secondaryELISAPlateResource,"G7"},{secondaryELISAPlateResource,"H7"},{secondaryELISAPlateResource,"A8"},{secondaryELISAPlateResource,"B8"},{secondaryELISAPlateResource,"C8"},{secondaryELISAPlateResource,"D8"},{secondaryELISAPlateResource,"E8"},{secondaryELISAPlateResource,"F8"},{secondaryELISAPlateResource,"G8"},{secondaryELISAPlateResource,"H8"},{secondaryELISAPlateResource,"A9"},{secondaryELISAPlateResource,"B9"},{secondaryELISAPlateResource,"C9"},{secondaryELISAPlateResource,"D9"},{secondaryELISAPlateResource,"E9"},{secondaryELISAPlateResource,"F9"},{secondaryELISAPlateResource,"G9"},{secondaryELISAPlateResource,"H9"},{secondaryELISAPlateResource,"A10"},{secondaryELISAPlateResource,"B10"},{secondaryELISAPlateResource,"C10"},{secondaryELISAPlateResource,"D10"},{secondaryELISAPlateResource,"E10"},{secondaryELISAPlateResource,"F10"},{secondaryELISAPlateResource,"G10"},{secondaryELISAPlateResource,"H10"},{secondaryELISAPlateResource,"A11"},{secondaryELISAPlateResource,"B11"},{secondaryELISAPlateResource,"C11"},{secondaryELISAPlateResource,"D11"},{secondaryELISAPlateResource,"E11"},{secondaryELISAPlateResource,"F11"},{secondaryELISAPlateResource,"G11"},{secondaryELISAPlateResource,"H11"},{secondaryELISAPlateResource,"A12"},{secondaryELISAPlateResource,"B12"},{secondaryELISAPlateResource,"C12"},{secondaryELISAPlateResource,"D12"},{secondaryELISAPlateResource,"E12"},{secondaryELISAPlateResource,"F12"},{secondaryELISAPlateResource,"G12"},{secondaryELISAPlateResource,"H12"}}
		][[;;numberOfSamplesSecondaryPlate]];

		joinedSampleAssemblyPositionsExpanded={};
		joinedAssayPlatePositionsExpanded=Join[primaryPlateSamplePositions,secondaryPlateSamplePositions],(*We are not coating but we need these in compiler*)

		(*---ELSE: when samples are not coated on plates---*)
		joinedSamples=Join[ToList[samplesInResources],ToList[standardResourcesStandardIndexMatched],ToList[blankResourcesBlankIndexMatched]];
		joinedAssayVolumes=Which[
			MatchQ[{resolvedMethod,resolvedCoating},{(DirectELISA|IndirectELISA),True}],
			DeleteCases[{resolvedSampleCoatingVolume,resolvedStandardCoatingVolume,resolvedBlankCoatingVolume}//Flatten,Null|{}|{Null..}],
			MatchQ[{resolvedMethod,resolvedCoating},{(DirectELISA|IndirectELISA),False}],
			ConstantArray[Null,sampleNumber],

			MatchQ[resolvedMethod,(DirectSandwichELISA|IndirectSandwichELISA)],
			DeleteCases[{resolvedSampleImmunosorbentVolume,resolvedStandardImmunosorbentVolume,resolvedBlankImmunosorbentVolume}//Flatten,Null|{}|{Null..}],
			MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],
			DeleteCases[{resolvedSampleAntibodyComplexImmunosorbentVolume,resolvedStandardAntibodyComplexImmunosorbentVolume,resolvedBlankAntibodyComplexImmunosorbentVolume}//Flatten,Null|{}|{Null..}]
		];
		joinedSpikeDilutionFactors=Join[ToList[resolvedSpikeDilutionFactor]/.Null->0,ConstantArray[0,standardNumber+blankNumber]];
		joinedSpikeVolumes=MapThread[#1*#2&,{joinedAssayVolumes,joinedSpikeDilutionFactors}];

		(*These are all arranged in the way of the original/automatic assignment table, AKA Sample-Standards-Blanks at their input sequence.*)

		joinedDilutionCurve=Join[resolverRoundedTransformedSampleDilutionCurve//ToList,
			If[MatchQ[resolvedStandard,Null|{Null..}|{}],{},resolverRoundedTransformedStandardDilutionCurve//ToList],
			ConstantArray[Null,blankNumber]];
		joinedSerialDilutionCurve=Join[resolverRoundedTransformedSampleSerialDilutionCurve//ToList,
			If[MatchQ[resolvedStandard,Null|{Null..}|{}],{},resolverRoundedTransformedStandardSerialDilutionCurve//ToList],
			ConstantArray[Null,blankNumber]];
		{combinedDilutionCurves,serialDilutionQ}=Transpose[
			MapThread[
				Which[
					MatchQ[#1,Except[Null|{}|{Null..}]],{#1,False},
					MatchQ[#2,Except[Null|{}|{Null..}]],{#2,True},
					True,{{{#3,0Microliter}},False} (*if no dilution, then assay volume = sample volume*)
				]&,
				{joinedDilutionCurve,joinedSerialDilutionCurve,joinedAssayVolumes},1]];


		(*The expanding parameter is how many dilution is needed for each sample times number of replicates*)
		expandingParams=Map[Length,combinedDilutionCurves,1]*resolvedNumberOfReplicatesNullToOne;


		(*pad spike volumes with 0Microliter on wells with dilution curves*)
		paddedSpikeVolumes=MapThread[Prepend[ConstantArray[0Microliter,#1-1],#2]&,{resolverJoinedCurveExpansionParams,joinedSpikeVolumes}]//Flatten;
		flattenedCombinedDilutionCurves=Flatten[combinedDilutionCurves,1];
		negativediluentVolume=False;
		(*These volumes has been expanded by dilution curves*)
		joinedSampleAssemblyVolumes=MapThread[
			Function[{dilution,spikeVolume,primaryVolume,captureVolume},
				Module[{sampleVolume,diluentVolume,diluentVolumeRaw},
					sampleVolume=dilution[[1]];
					diluentVolumeRaw=Switch[resolvedMethod,
						(DirectCompetitiveELISA|IndirectCompetitiveELISA),
						dilution[[2]]-spikeVolume-primaryVolume,
						FastELISA,
						dilution[[2]]-spikeVolume-primaryVolume-captureVolume,
						_,
						dilution[[2]]-spikeVolume
					];
					If[diluentVolumeRaw<-2Microliter, (*We are leaving a little grace volume here as 1/20-1/50 of total volume is generally considered neglegable in biochemistry experiments. Otherwise, the following warning triggers way too easy*)
						negativediluentVolume=True;
						Nothing
					];
					diluentVolume=Max[diluentVolumeRaw,0Microliter];
					{sampleVolume,diluentVolume,spikeVolume,primaryVolume,captureVolume}
				]
			],
			{flattenedCombinedDilutionCurves,paddedSpikeVolumes,resolverAllPrimaryAntibodyVolumes,resolverAllCaptureAntibodyVolumes}
		];
		If[negativediluentVolume&&messages, Message[Warning::NegativeDiluentVolume],Nothing];

		(*In the list above dilution curves are not grouped together. This causes problem because when we expand this list by number of replicates, the same dilution curve won't be placed next to each other. For this we have to first group the same dilution curve together, expand them by number of replicates, and then flatten it back again.*)
		curveGroupParams=Map[Length,combinedDilutionCurves,1];
		curveGroupPartitionHeads=FoldList[Plus,1,curveGroupParams[[;;-2]]];
		curveGroupPartitionTails=FoldList[Plus,curveGroupParams];
		curveGroupPartitionRanges={curveGroupPartitionHeads,curveGroupPartitionTails}//Transpose;
		groupedSampleAssemblyVolumes=Take[joinedSampleAssemblyVolumes,#]&/@curveGroupPartitionRanges;

		(*This makes the arrangment of replicates and dilutions like this: {rep1dilu1,rep1dilu2..rep2dilu1,rep2dilu2..}*)
		expandedJoinedSampleAssemblyVolumes=Flatten[ConstantArray[groupedSampleAssemblyVolumes,resolvedNumberOfReplicatesNullToOne]//Transpose,2];
		(*We are leaving half the margin of the regular pipetting error as this is the second transfer.*)
		erroredExpandedJoinedSampleAssemblyVolumes=Map[((resolverPipettingError-1)/2+1)*#&,expandedJoinedSampleAssemblyVolumes,{2}];
		expandedConcentrateVolumes=erroredExpandedJoinedSampleAssemblyVolumes[[All,1]];
		expandedDiluentVolumes=erroredExpandedJoinedSampleAssemblyVolumes[[All,2]];
		expandedSpikeVolumes=erroredExpandedJoinedSampleAssemblyVolumes[[All,3]];
		(*We are converting the priamry antibody and capture antibody sample mixing volumes to empty lists here when they are not mixed with sample. This is redundant though since we also discuss the situations in the Engine function.*)
		expandedPrimaryAntibodySampleMixingVolumes=If[MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],erroredExpandedJoinedSampleAssemblyVolumes[[All,4]],{}];
		expandedCaptureAntibodySampleMixingVolumes=If[MatchQ[resolvedMethod,FastELISA],erroredExpandedJoinedSampleAssemblyVolumes[[All,5]],{}];

		(*Expand joinedAssayVolumes*)
		expanededJoinedAssayVolumes=MapThread[ConstantArray[#1,#2]&,{joinedAssayVolumes,expandingParams}]//Flatten;

		(*Expand joined samples: we are simply expanding samples by params regardless of serialDilutionQ. In Engine whether sampleVolume is taken from original samples or previous well depends on ExpandedSerialDilutionQ*)
		expandedJoinedSamples=MapThread[ConstantArray[#1,#2]&,{joinedSamples,expandingParams}]//Flatten;

		expandedJoinedDiluents=MapThread[ConstantArray[#1,#2]&,{Flatten[{ConstantArray[sampleDiluentResource,sampleNumber],ConstantArray[standardDiluentResource,standardNumber],ConstantArray[Null,blankNumber]}],expandingParams}]//Flatten;

		(*Expand spikes: Spike is only added to the original sample. So it needs to be padded with Nulls*)
		joinedSpikes=Flatten[{spikeResourcesSampleIndexed,ConstantArray[Null,standardNumber+blankNumber]}];
		paddedSpikes=MapThread[Prepend[ConstantArray[Null,#1-1],#2]&,{resolverJoinedCurveExpansionParams,joinedSpikes}]//Flatten;
		(*We do the same grouping as how we do it for SpikeVolumes above to make sure the same dilution curve is placed next to each other. For this we have to first group the same dilution curve together, expand them by number of replicates, and then flatten it back again.*)
		groupedSpikes=Take[paddedSpikes,#]&/@curveGroupPartitionRanges;
		expandedJoinedSpikes=ConstantArray[groupedSpikes,resolvedNumberOfReplicatesNullToOne]//Transpose//Flatten;

		(*PrimaryAntibody and CaptureAntibody expansions appears later.*)


		(*Match each object to its assigned plate and wells*)
		primaryAssemblyPlatePositions={{sampleAssemblyContainerResource,"A1"},{sampleAssemblyContainerResource,"B1"},{sampleAssemblyContainerResource,"C1"},{sampleAssemblyContainerResource,"D1"},{sampleAssemblyContainerResource,"E1"},{sampleAssemblyContainerResource,"F1"},{sampleAssemblyContainerResource,"G1"},{sampleAssemblyContainerResource,"H1"},{sampleAssemblyContainerResource,"A2"},{sampleAssemblyContainerResource,"B2"},{sampleAssemblyContainerResource,"C2"},{sampleAssemblyContainerResource,"D2"},{sampleAssemblyContainerResource,"E2"},{sampleAssemblyContainerResource,"F2"},{sampleAssemblyContainerResource,"G2"},{sampleAssemblyContainerResource,"H2"},{sampleAssemblyContainerResource,"A3"},{sampleAssemblyContainerResource,"B3"},{sampleAssemblyContainerResource,"C3"},{sampleAssemblyContainerResource,"D3"},{sampleAssemblyContainerResource,"E3"},{sampleAssemblyContainerResource,"F3"},{sampleAssemblyContainerResource,"G3"},{sampleAssemblyContainerResource,"H3"},{sampleAssemblyContainerResource,"A4"},{sampleAssemblyContainerResource,"B4"},{sampleAssemblyContainerResource,"C4"},{sampleAssemblyContainerResource,"D4"},{sampleAssemblyContainerResource,"E4"},{sampleAssemblyContainerResource,"F4"},{sampleAssemblyContainerResource,"G4"},{sampleAssemblyContainerResource,"H4"},{sampleAssemblyContainerResource,"A5"},{sampleAssemblyContainerResource,"B5"},{sampleAssemblyContainerResource,"C5"},{sampleAssemblyContainerResource,"D5"},{sampleAssemblyContainerResource,"E5"},{sampleAssemblyContainerResource,"F5"},{sampleAssemblyContainerResource,"G5"},{sampleAssemblyContainerResource,"H5"},{sampleAssemblyContainerResource,"A6"},{sampleAssemblyContainerResource,"B6"},{sampleAssemblyContainerResource,"C6"},{sampleAssemblyContainerResource,"D6"},{sampleAssemblyContainerResource,"E6"},{sampleAssemblyContainerResource,"F6"},{sampleAssemblyContainerResource,"G6"},{sampleAssemblyContainerResource,"H6"},{sampleAssemblyContainerResource,"A7"},{sampleAssemblyContainerResource,"B7"},{sampleAssemblyContainerResource,"C7"},{sampleAssemblyContainerResource,"D7"},{sampleAssemblyContainerResource,"E7"},{sampleAssemblyContainerResource,"F7"},{sampleAssemblyContainerResource,"G7"},{sampleAssemblyContainerResource,"H7"},{sampleAssemblyContainerResource,"A8"},{sampleAssemblyContainerResource,"B8"},{sampleAssemblyContainerResource,"C8"},{sampleAssemblyContainerResource,"D8"},{sampleAssemblyContainerResource,"E8"},{sampleAssemblyContainerResource,"F8"},{sampleAssemblyContainerResource,"G8"},{sampleAssemblyContainerResource,"H8"},{sampleAssemblyContainerResource,"A9"},{sampleAssemblyContainerResource,"B9"},{sampleAssemblyContainerResource,"C9"},{sampleAssemblyContainerResource,"D9"},{sampleAssemblyContainerResource,"E9"},{sampleAssemblyContainerResource,"F9"},{sampleAssemblyContainerResource,"G9"},{sampleAssemblyContainerResource,"H9"},{sampleAssemblyContainerResource,"A10"},{sampleAssemblyContainerResource,"B10"},{sampleAssemblyContainerResource,"C10"},{sampleAssemblyContainerResource,"D10"},{sampleAssemblyContainerResource,"E10"},{sampleAssemblyContainerResource,"F10"},{sampleAssemblyContainerResource,"G10"},{sampleAssemblyContainerResource,"H10"},{sampleAssemblyContainerResource,"A11"},{sampleAssemblyContainerResource,"B11"},{sampleAssemblyContainerResource,"C11"},{sampleAssemblyContainerResource,"D11"},{sampleAssemblyContainerResource,"E11"},{sampleAssemblyContainerResource,"F11"},{sampleAssemblyContainerResource,"G11"},{sampleAssemblyContainerResource,"H11"},{sampleAssemblyContainerResource,"A12"},{sampleAssemblyContainerResource,"B12"},{sampleAssemblyContainerResource,"C12"},{sampleAssemblyContainerResource,"D12"},{sampleAssemblyContainerResource,"E12"},{sampleAssemblyContainerResource,"F12"},{sampleAssemblyContainerResource,"G12"},{sampleAssemblyContainerResource,"H12"}};
		primaryPlateSampleStartCounts=Flatten[{1,(resolverPrimaryAssignmentTableCounts+1)}][[;;-2]];
		primaryPlateSameSampleRanges={primaryPlateSampleStartCounts,resolverPrimaryAssignmentTableCounts}//Transpose;
		primaryPlateSamplePositions=Map[Take[primaryAssemblyPlatePositions,#]&,primaryPlateSameSampleRanges,1];

		(*If no secondary plate, then positions is {}*)
		If[MatchQ[resolverSecondaryAssignmentTableCounts,({}|{Null..}|Null)],
			secondaryPlateSamplePositions={},

			secondaryAssemblyPlatePositions={{secondarySampleAssemblyContainerResource,"A1"},{secondarySampleAssemblyContainerResource,"B1"},{secondarySampleAssemblyContainerResource,"C1"},{secondarySampleAssemblyContainerResource,"D1"},{secondarySampleAssemblyContainerResource,"E1"},{secondarySampleAssemblyContainerResource,"F1"},{secondarySampleAssemblyContainerResource,"G1"},{secondarySampleAssemblyContainerResource,"H1"},{secondarySampleAssemblyContainerResource,"A2"},{secondarySampleAssemblyContainerResource,"B2"},{secondarySampleAssemblyContainerResource,"C2"},{secondarySampleAssemblyContainerResource,"D2"},{secondarySampleAssemblyContainerResource,"E2"},{secondarySampleAssemblyContainerResource,"F2"},{secondarySampleAssemblyContainerResource,"G2"},{secondarySampleAssemblyContainerResource,"H2"},{secondarySampleAssemblyContainerResource,"A3"},{secondarySampleAssemblyContainerResource,"B3"},{secondarySampleAssemblyContainerResource,"C3"},{secondarySampleAssemblyContainerResource,"D3"},{secondarySampleAssemblyContainerResource,"E3"},{secondarySampleAssemblyContainerResource,"F3"},{secondarySampleAssemblyContainerResource,"G3"},{secondarySampleAssemblyContainerResource,"H3"},{secondarySampleAssemblyContainerResource,"A4"},{secondarySampleAssemblyContainerResource,"B4"},{secondarySampleAssemblyContainerResource,"C4"},{secondarySampleAssemblyContainerResource,"D4"},{secondarySampleAssemblyContainerResource,"E4"},{secondarySampleAssemblyContainerResource,"F4"},{secondarySampleAssemblyContainerResource,"G4"},{secondarySampleAssemblyContainerResource,"H4"},{secondarySampleAssemblyContainerResource,"A5"},{secondarySampleAssemblyContainerResource,"B5"},{secondarySampleAssemblyContainerResource,"C5"},{secondarySampleAssemblyContainerResource,"D5"},{secondarySampleAssemblyContainerResource,"E5"},{secondarySampleAssemblyContainerResource,"F5"},{secondarySampleAssemblyContainerResource,"G5"},{secondarySampleAssemblyContainerResource,"H5"},{secondarySampleAssemblyContainerResource,"A6"},{secondarySampleAssemblyContainerResource,"B6"},{secondarySampleAssemblyContainerResource,"C6"},{secondarySampleAssemblyContainerResource,"D6"},{secondarySampleAssemblyContainerResource,"E6"},{secondarySampleAssemblyContainerResource,"F6"},{secondarySampleAssemblyContainerResource,"G6"},{secondarySampleAssemblyContainerResource,"H6"},{secondarySampleAssemblyContainerResource,"A7"},{secondarySampleAssemblyContainerResource,"B7"},{secondarySampleAssemblyContainerResource,"C7"},{secondarySampleAssemblyContainerResource,"D7"},{secondarySampleAssemblyContainerResource,"E7"},{secondarySampleAssemblyContainerResource,"F7"},{secondarySampleAssemblyContainerResource,"G7"},{secondarySampleAssemblyContainerResource,"H7"},{secondarySampleAssemblyContainerResource,"A8"},{secondarySampleAssemblyContainerResource,"B8"},{secondarySampleAssemblyContainerResource,"C8"},{secondarySampleAssemblyContainerResource,"D8"},{secondarySampleAssemblyContainerResource,"E8"},{secondarySampleAssemblyContainerResource,"F8"},{secondarySampleAssemblyContainerResource,"G8"},{secondarySampleAssemblyContainerResource,"H8"},{secondarySampleAssemblyContainerResource,"A9"},{secondarySampleAssemblyContainerResource,"B9"},{secondarySampleAssemblyContainerResource,"C9"},{secondarySampleAssemblyContainerResource,"D9"},{secondarySampleAssemblyContainerResource,"E9"},{secondarySampleAssemblyContainerResource,"F9"},{secondarySampleAssemblyContainerResource,"G9"},{secondarySampleAssemblyContainerResource,"H9"},{secondarySampleAssemblyContainerResource,"A10"},{secondarySampleAssemblyContainerResource,"B10"},{secondarySampleAssemblyContainerResource,"C10"},{secondarySampleAssemblyContainerResource,"D10"},{secondarySampleAssemblyContainerResource,"E10"},{secondarySampleAssemblyContainerResource,"F10"},{secondarySampleAssemblyContainerResource,"G10"},{secondarySampleAssemblyContainerResource,"H10"},{secondarySampleAssemblyContainerResource,"A11"},{secondarySampleAssemblyContainerResource,"B11"},{secondarySampleAssemblyContainerResource,"C11"},{secondarySampleAssemblyContainerResource,"D11"},{secondarySampleAssemblyContainerResource,"E11"},{secondarySampleAssemblyContainerResource,"F11"},{secondarySampleAssemblyContainerResource,"G11"},{secondarySampleAssemblyContainerResource,"H11"},{secondarySampleAssemblyContainerResource,"A12"},{secondarySampleAssemblyContainerResource,"B12"},{secondarySampleAssemblyContainerResource,"C12"},{secondarySampleAssemblyContainerResource,"D12"},{secondarySampleAssemblyContainerResource,"E12"},{secondarySampleAssemblyContainerResource,"F12"},{secondarySampleAssemblyContainerResource,"G12"},{secondarySampleAssemblyContainerResource,"H12"}};
			secondaryPlateSampleStartCounts=Flatten[{1,(resolverSecondaryAssignmentTableCounts+1)}][[;;-2]];
			secondaryPlateSameSampleRanges={secondaryPlateSampleStartCounts,resolverSecondaryAssignmentTableCounts}//Transpose;
			secondaryPlateSamplePositions=Map[Take[secondaryAssemblyPlatePositions,#]&,secondaryPlateSameSampleRanges]
		];


		joinedAssignment=Join[resolvedELISAPlateAssignment,resolvedSecondaryELISAPlateAssignmentNullToEmpty];
		joinedAssemblyPositions=Join[primaryPlateSamplePositions,secondaryPlateSamplePositions];
		experimentPositionsLookupTable=MapThread[#1->#2&,{joinedAssignment,joinedAssemblyPositions}];(*This won't work if we use association because if several assignment entires are completely the same the keys will be combined.*)

		(*At the input order of Samples, Standards, Blanks, (resolverAutoJoinedAssignmentTable) all the wells samples correspond to*)
		(*Helper function to lookup a value from a KeyValuePattern list and return the value with a new lookup table with the KeyValuePattern just used deleted.*)
		lookupAndDelete[lastValueWithLookupTable:{_,{_Rule..}},key:_List]:=Module[
			{lookupTable,value,newLookupTable},
			lookupTable=lastValueWithLookupTable[[2]];
			value=Lookup[lookupTable,{key}][[1]]; (*Because the key is a list. It will treat each element as a separate key unless we wrap it in another list. But then we need to extract the value from the return list*)
			newLookupTable=DeleteCases[lookupTable,key->value];
			{value,newLookupTable}
		];
		initalLookupTableWithPlaceholderValue={Null,experimentPositionsLookupTable};
		valuesWithFoldedLookupTable=FoldList[lookupAndDelete,initalLookupTableWithPlaceholderValue,resolverAutoJoinedAssignmentTable];
		(*Now we have a list of {Value, NewLookupTable}. We just want the values, but not the first one, which is a placeholder only to make the FoldList function to work*)
		joinedSampleAssemblyPositionsExpanded=Flatten[valuesWithFoldedLookupTable[[All,1]][[2;;]],1];
		(*ELISA plates are arranged the same way as sample assembly plates. Just replace the plate resource*)
		joinedAssayPlatePositionsExpanded=joinedSampleAssemblyPositionsExpanded/.{sampleAssemblyContainerResource->elisaPlateResource,secondarySampleAssemblyContainerResource->secondaryELISAPlateResource};

		(*Expand serial dilutions: because in a dilution curve, the first dilution is always taken from the original sample.
		To make it easier to find transfer source in the SM primitives, here we are making the Q as False for all the first dilutions in a serial dilution curve. The arrangement of curves and replicates are as such: {rep1dilu1,rep1dilu2..rep2dilu1,rep2dilu2..}*)
		serialQExpandingParams=Map[Length,combinedDilutionCurves];
		expandedSerialQ=MapThread[
			ConstantArray[{False,ConstantArray[#1,(#2-1)]},resolvedNumberOfReplicatesNullToOne]&,
			{serialDilutionQ,serialQExpandingParams}
		]//Flatten;
	]; (*END IF*)

	(* -- Blocking buffer: Blocking buffer is not indexMatched but volume is -- *)
	(*Blocking buffer volume list is indexmatched to each sample/standard/antibody. We need to expand it by dilution curve and number of replicates for total volume*)
	If[resolvedBlocking===False,
		totalBlockingVolume=Null;
		blockingBufferResource=Null,

		blockingVolumeList=DeleteCases[Join[ToList[resolvedBlockingVolume],ToList[resolvedStandardBlockingVolume],ToList[resolvedBlankBlockingVolume]],Null];
		expandedBlockingVolumeList=MapThread[ConstantArray[#1,#2]&,{blockingVolumeList,expandingParams}]//Flatten;
		totalBlockingVolume=Total[expandedBlockingVolumeList]*resolverPipettingError;
		blockingBufferResource=Resource[Sample->resolvedBlockingBuffer,Name->ToString[Unique[]], Amount->totalBlockingVolume,Container->elisaContainerPicker[totalBlockingVolume]]
	];

	(*Join (Sample-Standard-Blank) and expand (to each well) all Working solutions (Blocking buffer,Antibodies/Antigens,substrates and stops) and their assay volumes*)
	(*Helper function to expand all-indexed values by dilution curve and number of replicates*)
	elisaExpand[allIndexedValue_]:=MapThread[ConstantArray[#1,#2]&,{allIndexedValue,expandingParams}]//Flatten;

	joinedPrimaryAntibodyWorkingResources=Flatten[{primaryAntibodyWorkingResourcesSampleIndexed,primaryAntibodyWorkingResourcesStandardIndexed,primaryAntibodyWorkingResourcesBlankIndexed}]/.Null->Nothing;
	expandedPrimaryAntibodyWorkingResources=elisaExpand[joinedPrimaryAntibodyWorkingResources];

	joinedSecondaryAntibodyWorkingResources=Flatten[{secondaryAntibodyWorkingResourcesSampleIndexed,secondaryAntibodyWorkingResourcesStandardIndexed,secondaryAntibodyWorkingResourcesBlankIndexed}]/.Null->Nothing;
	expandedSecondaryAntibodyWorkingResources=If[MatchQ[resolvedMethod,(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA)],
		elisaExpand[joinedSecondaryAntibodyWorkingResources],
		{}
	];

	joinedCaptureAntibodyWorkingResources=Flatten[{captureAntibodyWorkingResourcesSampleIndexed,captureAntibodyWorkingResourcesStandardIndexed,captureAntibodyWorkingResourcesBlankIndexed}]/.Null->Nothing;
	expandedCaptureAntibodyWorkingResources=If[MatchQ[resolvedMethod,FastELISA]||MatchQ[{resolvedMethod,resolvedCoating},{(DirectSandwichELISA|IndirectSandwichELISA),True}],
		elisaExpand[joinedCaptureAntibodyWorkingResources],
		{}
	];

	joinedCoatingAntibodyWorkingResources=Flatten[{coatingAntibodyWorkingResourcesSampleIndexed,coatingAntibodyWorkingResourcesStandardIndexed,coatingAntibodyWorkingResourcesBlankIndexed}]/.Null->Nothing;
	expandedCoatingAntibodyWorkingResources=If[MatchQ[{resolvedMethod,resolvedCoating},{FastELISA,True}],
		elisaExpand[joinedCoatingAntibodyWorkingResources],
		{}
	];

	joinedReferenceAntigenWorkingResources=Flatten[{referenceAntigenWorkingResourcesSampleIndexed,referenceAntigenWorkingResourcesStandardIndexed,referenceAntigenWorkingResourcesBlankIndexed}]/.Null->Nothing;
	expandedReferenceAntigenWorkingResources=If[MatchQ[{resolvedMethod,resolvedCoating},{(DirectCompetitiveELISA|IndirectCompetitiveELISA),True}],
		elisaExpand[joinedReferenceAntigenWorkingResources],
		{}
	];

	joinedSampleCoatingVolumes=Flatten[{resolvedSampleCoatingVolume,resolvedStandardCoatingVolume,resolvedBlankCoatingVolume}]/.Null->Nothing;
	expandedSampleCoatingVolumes=If[MatchQ[resolvedMethod,DirectELISA|IndirectELISA]&&MatchQ[resolvedCoating,True],
		elisaExpand[joinedSampleCoatingVolumes],
		{}
	];

	joinedCoatingAntibodyCoatingVolumes=Flatten[{resolvedCoatingAntibodyCoatingVolume,resolvedStandardCoatingAntibodyCoatingVolume,resolvedBlankCoatingAntibodyCoatingVolume}]/.Null->Nothing;
	expandedCoatingAntibodyCoatingVolumes=If[MatchQ[resolvedMethod,FastELISA]&&MatchQ[resolvedCoating,True],
		elisaExpand[joinedCoatingAntibodyCoatingVolumes],
		{}
	];

	joinedCaptureAntibodyCoatingVolumes=Flatten[{resolvedCaptureAntibodyCoatingVolume,resolvedStandardCaptureAntibodyCoatingVolume,resolvedBlankCaptureAntibodyCoatingVolume}]/.Null->Nothing;
	expandedCaptureAntibodyCoatingVolumes=If[MatchQ[resolvedMethod,(DirectSandwichELISA|IndirectSandwichELISA)]&&MatchQ[resolvedCoating,True],
		elisaExpand[joinedCaptureAntibodyCoatingVolumes],
		{}
	];

	joinedReferenceAntigenCoatingVolumes=Flatten[{resolvedReferenceAntigenCoatingVolume,resolvedStandardReferenceAntigenCoatingVolume,resolvedBlankReferenceAntigenCoatingVolume}]/.Null->Nothing;
	expandedReferenceAntigenCoatingVolumes=If[MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA)]&&MatchQ[resolvedCoating,True],
		elisaExpand[joinedReferenceAntigenCoatingVolumes],
		{}
	];

	joinedSampleImmunosorbentVolumes=Flatten[{resolvedSampleImmunosorbentVolume,resolvedStandardImmunosorbentVolume,resolvedBlankImmunosorbentVolume}]/.Null->Nothing;
	expandedSampleImmunosorbentVolumes=If[MatchQ[resolvedMethod,(DirectSandwichELISA|IndirectSandwichELISA)],
		elisaExpand[joinedSampleImmunosorbentVolumes],
		{}
	];

	joinedSampleAntibodyComplexImmunosorbentVolumes=Flatten[{resolvedSampleAntibodyComplexImmunosorbentVolume,resolvedStandardAntibodyComplexImmunosorbentVolume,resolvedBlankAntibodyComplexImmunosorbentVolume}]/.Null->Nothing;
	expandedSampleAntibodyComplexImmunosorbentVolumes=If[MatchQ[resolvedMethod,(DirectCompetitiveELISA|IndirectCompetitiveELISA|FastELISA)],
		elisaExpand[joinedSampleAntibodyComplexImmunosorbentVolumes],
		{}
	];

	joinedPrimaryAntibodyImmunosorbentVolumes=Flatten[{resolvedPrimaryAntibodyImmunosorbentVolume,resolvedStandardPrimaryAntibodyImmunosorbentVolume,resolvedBlankPrimaryAntibodyImmunosorbentVolume}]/.Null->Nothing;
	expandedPrimaryAntibodyImmunosorbentVolumes=If[MatchQ[resolvedMethod,(DirectELISA|IndirectELISA|DirectSandwichELISA|IndirectSandwichELISA)],
		elisaExpand[joinedPrimaryAntibodyImmunosorbentVolumes],
		{}
	];

	joinedSecondaryAntibodyImmunosorbentVolumes=Flatten[{resolvedSecondaryAntibodyImmunosorbentVolume,resolvedStandardSecondaryAntibodyImmunosorbentVolume,resolvedBlankSecondaryAntibodyImmunosorbentVolume}]/.Null->Nothing;
	expandedSecondaryAntibodyImmunosorbentVolumes=If[MatchQ[resolvedMethod,(IndirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA)],
		elisaExpand[joinedSecondaryAntibodyImmunosorbentVolumes],
		{}
	];

	joinedSubstrates=Flatten[{substrateResourcesSampleIndexed,substrateResourcesStandardIndexed,substrateResourcesBlankIndexed}]/.Null->Nothing;
	expandedSubstrates=elisaExpand[joinedSubstrates];

	(*Stop: unlike anything else, some wells may have no stop at all while others do. So we cannot simply delete null for empty standards and blanks.*)
	stopResourcesStandardIndexedEmptyNull=If[MatchQ[stopResourcesStandardIndexed,{Null..}|Null],{},stopResourcesStandardIndexed];
	stopResourcesBlankIndexedEmptyNull=If[MatchQ[stopResourcesBlankIndexed,{Null..}|Null],{},stopResourcesBlankIndexed];
	joinedStops=Flatten[{stopResourcesSampleIndexed,stopResourcesStandardIndexedEmptyNull,stopResourcesBlankIndexedEmptyNull}];
	expandedStops=elisaExpand[joinedStops];

	joinedSubstrateVolumes=Flatten[{resolvedSubstrateSolutionVolume,resolvedStandardSubstrateSolutionVolume,resolvedBlankSubstrateSolutionVolume}]/.Null->Nothing;
	expandedSubstrateVolumes=elisaExpand[joinedSubstrateVolumes];

	stopVolumesStandardIndexedEmptyNull=If[MatchQ[resolvedStandardStopSolutionVolume,{Null..}|Null],{},resolvedStandardStopSolutionVolume];
	stopVolumesBlankIndexedEmptyNull=If[MatchQ[resolvedBlankStopSolutionVolume,{Null..}|Null],{},resolvedBlankStopSolutionVolume];
	joinedStopVolumes=Flatten[{resolvedStopSolutionVolume,stopVolumesStandardIndexedEmptyNull,stopVolumesBlankIndexedEmptyNull}];
	expandedStopVolumes=elisaExpand[joinedStopVolumes];

	joinedBlockVolumes=If[MatchQ[resolvedBlocking,True],
		Flatten[{resolvedBlockingVolume,resolvedStandardBlockingVolume,resolvedBlankBlockingVolume}]/.Null->Nothing,
		{}
	];
	expandedBlockVolumes=If[MatchQ[resolvedBlocking,True],
		elisaExpand[joinedBlockVolumes],
		{}
	];



	(*----Reformat plate assignment tables-----*)

	(*Expand Assignment Table by number of replicates*)
	elisaExpandByNoR[input_List]:=Flatten[ConstantArray[input,resolvedNumberOfReplicatesNullToOne]//Transpose,1];

	(*Transpose sample-indexed lists so that each sublist represents one option*)
	{
		assignTypes,
		assignSamples,
		assignSpikes,
		assignSpikeDilutionFactors,
		assignSampleDilutionFactors,
		assignCoatingAntibodies,
		assignCoatingAntibodyDilutionFactors,
		assignCaptureAntibodies,
		assignCaptureAntibodyDilutionFactors,
		assignReferenceAntigens,
		assignReferenceAntigenDilutionFactors,
		assignPrimaryAntibodies,
		assignPrimaryAntibodyDilutionFactors,
		assignSecondaryAntibodies,
		assignSecondaryAntibodyDilutionFactors,
		assignCoatingVolumes,
		assignBlockingVolumes,
		assignSampleAntibodyComplexImmunosorbentVolumes,
		assignSampleImmunosorbentVolumes,
		assignPrimaryAntibodyImmunosorbentVolumes,
		assignSecondaryAntibodyImmunosorbentVolumes,
		assignSubstrateSolutions,
		assignStopSolutions,
		assignSubstrateSolutionVolumes,
		assignStopSolutionVolumes
		
	}=resolvedELISAPlateAssignment//Transpose;
	
	(*Find resources then add Link[] for all of the object-containing sublists*)
	(*Sample resources include samples, standards and blank*)
	joinedSampleResources=Flatten[{samplesInResources,standardResourcesStandardIndexMatched,blankResourcesBlankIndexMatched},1];

	assignSampleResourcesLinked=Map[Link[elisaExtractResources[joinedSampleResources,#]]&,assignSamples];
	assignSpikesResourcesLinked=Map[Link[elisaExtractResources[spikeResources,#]]&,assignSpikes];
	assignCoatingAntibodiesResourcesLinked=Map[Link[elisaExtractResources[coatingAntibodyResources,#]]&,assignCoatingAntibodies];
	assignCaptureAntibodiesResourcesLinked=Map[Link[elisaExtractResources[captureAntibodyResources,#]]&,assignCaptureAntibodies];
	assignReferenceAntigensResourcesLinked=Map[Link[elisaExtractResources[referenceAntigenResources,#]]&,assignReferenceAntigens];
	assignPrimaryAntibodiesResourcesLinked=Map[Link[elisaExtractResources[primaryAntibodyResources,#]]&,assignPrimaryAntibodies];
	assignSecondaryAntibodiesResourcesLinked=Map[Link[elisaExtractResources[secondaryAntibodyResources,#]]&,assignSecondaryAntibodies];
	assignSubstrateSolutionsResourcesLinked=Map[Link[elisaExtractResources[substrateResources,#]]&,assignSubstrateSolutions];
	assignStopSolutionsResourcesLinked=Map[Link[elisaExtractResources[stopResources,#]]&,assignStopSolutions];

	(*Expand by Number of replicates. use the resourced linked list for object-involving lists*)
	assignTypesExpanded=elisaExpandByNoR[assignTypes];
	assignSamplesExpanded=elisaExpandByNoR[assignSampleResourcesLinked];
	assignSpikesExpanded=elisaExpandByNoR[assignSpikesResourcesLinked];
	assignSpikeDilutionFactorsExpanded=elisaExpandByNoR[assignSpikeDilutionFactors];
	assignSampleDilutionFactorsExpanded=elisaExpandByNoR[assignSampleDilutionFactors];
	assignCoatingAntibodiesExpanded=elisaExpandByNoR[assignCoatingAntibodiesResourcesLinked];
	assignCoatingAntibodyDilutionFactorsExpanded=elisaExpandByNoR[assignCoatingAntibodyDilutionFactors];
	assignCaptureAntibodiesExpanded=elisaExpandByNoR[assignCaptureAntibodiesResourcesLinked];
	assignCaptureAntibodyDilutionFactorsExpanded=elisaExpandByNoR[assignCaptureAntibodyDilutionFactors];
	assignReferenceAntigensExpanded=elisaExpandByNoR[assignReferenceAntigensResourcesLinked];
	assignReferenceAntigenDilutionFactorsExpanded=elisaExpandByNoR[assignReferenceAntigenDilutionFactors];
	assignPrimaryAntibodiesExpanded=elisaExpandByNoR[assignPrimaryAntibodiesResourcesLinked];
	assignPrimaryAntibodyDilutionFactorsExpanded=elisaExpandByNoR[assignPrimaryAntibodyDilutionFactors];
	assignSecondaryAntibodiesExpanded=elisaExpandByNoR[assignSecondaryAntibodiesResourcesLinked];
	assignSecondaryAntibodyDilutionFactorsExpanded=elisaExpandByNoR[assignSecondaryAntibodyDilutionFactors];
	assignCoatingVolumesExpanded=elisaExpandByNoR[assignCoatingVolumes];
	assignBlockingVolumesExpanded=elisaExpandByNoR[assignBlockingVolumes];
	assignSampleAntibodyComplexImmunosorbentVolumesExpanded=elisaExpandByNoR[assignSampleAntibodyComplexImmunosorbentVolumes];
	assignSampleImmunosorbentVolumesExpanded=elisaExpandByNoR[assignSampleImmunosorbentVolumes];
	assignPrimaryAntibodyImmunosorbentVolumesExpanded=elisaExpandByNoR[assignPrimaryAntibodyImmunosorbentVolumes];
	assignSecondaryAntibodyImmunosorbentVolumesExpanded=elisaExpandByNoR[assignSecondaryAntibodyImmunosorbentVolumes];
	assignSubstrateSolutionsExpanded=elisaExpandByNoR[assignSubstrateSolutionsResourcesLinked];
	assignStopSolutionsExpanded=elisaExpandByNoR[assignStopSolutionsResourcesLinked];
	assignSubstrateSolutionVolumesExpanded=elisaExpandByNoR[assignSubstrateSolutionVolumes];
	assignStopSolutionVolumesExpanded=elisaExpandByNoR[assignStopSolutionVolumes];
	(*Here we add Data subfield to the list for parser. For now they are a list of Null*)
	assignDataExpanded=ConstantArray[Null,Length[assignTypesExpanded]];
	(*Transpose back*)
	processedELISAPlateAssignment={
		assignTypesExpanded,
		assignSamplesExpanded,
		assignSpikesExpanded,
		assignSpikeDilutionFactorsExpanded,
		assignSampleDilutionFactorsExpanded,
		assignCoatingAntibodiesExpanded,
		assignCoatingAntibodyDilutionFactorsExpanded,
		assignCaptureAntibodiesExpanded,
		assignCaptureAntibodyDilutionFactorsExpanded,
		assignReferenceAntigensExpanded,
		assignReferenceAntigenDilutionFactorsExpanded,
		assignPrimaryAntibodiesExpanded,
		assignPrimaryAntibodyDilutionFactorsExpanded,
		assignSecondaryAntibodiesExpanded,
		assignSecondaryAntibodyDilutionFactorsExpanded,
		assignCoatingVolumesExpanded,
		assignBlockingVolumesExpanded,
		assignSampleAntibodyComplexImmunosorbentVolumesExpanded,
		assignSampleImmunosorbentVolumesExpanded,
		assignPrimaryAntibodyImmunosorbentVolumesExpanded,
		assignSecondaryAntibodyImmunosorbentVolumesExpanded,
		assignSubstrateSolutionsExpanded,
		assignStopSolutionsExpanded,
		assignSubstrateSolutionVolumesExpanded,
		assignStopSolutionVolumesExpanded,
		assignDataExpanded
	}//Transpose;
	(*Make them into a list of associations*)
	associatedELISAPlateAssignment=Map[AssociationThread[
		{
			Type,
			Sample,
			Spike,
			SpikeDilutionFactor,
			SampleDilutionFactors,
			CoatingAntibody,
			CoatingAntibodyDilutionFactor,
			CaptureAntibody,
			CaptureAntibodyDilutionFactor,
			ReferenceAntigen,
			ReferenceAntigenDilutionFactor,
			PrimaryAntibody,
			PrimaryAntibodyDilutionFactor,
			SecondaryAntibody,
			SecondaryAntibodyDilutionFactor,
			CoatingVolume,
			BlockingVolume,
			SampleAntibodyComplexImmunosorbentVolume,
			SampleImmunosorbentVolume,
			PrimaryAntibodyImmunosorbentVolume,
			SecondaryAntibodyImmunosorbentVolume,
			SubstrateSolution,
			StopSolution,
			SubstrateSolutionVolume,
			StopSolutionVolume,
			Data
		}->#
	]&,
		processedELISAPlateAssignment
	];


	(* Secondary Assignment *)
	(*Is there a seoncary plate and it is assigned?*)
	associatedSecondaryELISAPlateAssignment=If[MatchQ[resolvedSecondaryELISAPlate,ObjectP[]]&&MatchQ[resolvedSecondaryELISAPlateAssignmentNullToEmpty,Except[Null|{}|{Null..}]],
		{
			secAssignTypes,
			secAssignSamples,
			secAssignSpikes,
			secAssignSpikeDilutionFactors,
			secAssignSampleDilutionFactors,
			secAssignCoatingAntibodies,
			secAssignCoatingAntibodyDilutionFactors,
			secAssignCaptureAntibodies,
			secAssignCaptureAntibodyDilutionFactors,
			secAssignReferenceAntigens,
			secAssignReferenceAntigenDilutionFactors,
			secAssignPrimaryAntibodies,
			secAssignPrimaryAntibodyDilutionFactors,
			secAssignSecondaryAntibodies,
			secAssignSecondaryAntibodyDilutionFactors,
			secAssignCoatingVolumes,
			secAssignBlockingVolumes,
			secAssignSampleAntibodyComplexImmunosorbentVolumes,
			secAssignSampleImmunosorbentVolumes,
			secAssignPrimaryAntibodyImmunosorbentVolumes,
			secAssignSecondaryAntibodyImmunosorbentVolumes,
			secAssignSubstrateSolutions,
			secAssignStopSolutions,
			secAssignSubstrateSolutionVolumes,
			secAssignStopSolutionVolumes

		}=resolvedSecondaryELISAPlateAssignmentNullToEmpty//Transpose;

		(*Find resources then add Link[] for all of the object-containing sublists*)
		secAssignSampleResourcesLinked=Map[Link[elisaExtractResources[joinedSampleResources,#]]&,secAssignSamples];
		secAssignSpikesResourcesLinked=Map[Link[elisaExtractResources[spikeResources,#]]&,secAssignSpikes];
		secAssignCoatingAntibodiesResourcesLinked=Map[Link[elisaExtractResources[coatingAntibodyResources,#]]&,secAssignCoatingAntibodies];
		secAssignCaptureAntibodiesResourcesLinked=Map[Link[elisaExtractResources[captureAntibodyResources,#]]&,secAssignCaptureAntibodies];
		secAssignReferenceAntigensResourcesLinked=Map[Link[elisaExtractResources[referenceAntigenResources,#]]&,secAssignReferenceAntigens];
		secAssignPrimaryAntibodiesResourcesLinked=Map[Link[elisaExtractResources[primaryAntibodyResources,#]]&,secAssignPrimaryAntibodies];
		secAssignSecondaryAntibodiesResourcesLinked=Map[Link[elisaExtractResources[secondaryAntibodyResources,#]]&,secAssignSecondaryAntibodies];
		secAssignSubstrateSolutionsResourcesLinked=Map[Link[elisaExtractResources[substrateResources,#]]&,secAssignSubstrateSolutions];
		secAssignStopSolutionsResourcesLinked=Map[Link[elisaExtractResources[stopResources,#]]&,secAssignStopSolutions];
		(*Expand by Number of replicates. use the resourced linked list for object-involving lists*)
		secAssignTypesExpanded=elisaExpandByNoR[secAssignTypes];
		secAssignSamplesExpanded=elisaExpandByNoR[secAssignSampleResourcesLinked];
		secAssignSpikesExpanded=elisaExpandByNoR[secAssignSpikesResourcesLinked];
		secAssignSpikeDilutionFactorsExpanded=elisaExpandByNoR[secAssignSpikeDilutionFactors];
		secAssignSampleDilutionFactorsExpanded=elisaExpandByNoR[secAssignSampleDilutionFactors];
		secAssignCoatingAntibodiesExpanded=elisaExpandByNoR[secAssignCoatingAntibodiesResourcesLinked];
		secAssignCoatingAntibodyDilutionFactorsExpanded=elisaExpandByNoR[secAssignCoatingAntibodyDilutionFactors];
		secAssignCaptureAntibodiesExpanded=elisaExpandByNoR[secAssignCaptureAntibodiesResourcesLinked];
		secAssignCaptureAntibodyDilutionFactorsExpanded=elisaExpandByNoR[secAssignCaptureAntibodyDilutionFactors];
		secAssignReferenceAntigensExpanded=elisaExpandByNoR[secAssignReferenceAntigensResourcesLinked];
		secAssignReferenceAntigenDilutionFactorsExpanded=elisaExpandByNoR[secAssignReferenceAntigenDilutionFactors];
		secAssignPrimaryAntibodiesExpanded=elisaExpandByNoR[secAssignPrimaryAntibodiesResourcesLinked];
		secAssignPrimaryAntibodyDilutionFactorsExpanded=elisaExpandByNoR[secAssignPrimaryAntibodyDilutionFactors];
		secAssignSecondaryAntibodiesExpanded=elisaExpandByNoR[secAssignSecondaryAntibodiesResourcesLinked];
		secAssignSecondaryAntibodyDilutionFactorsExpanded=elisaExpandByNoR[secAssignSecondaryAntibodyDilutionFactors];
		secAssignCoatingVolumesExpanded=elisaExpandByNoR[secAssignCoatingVolumes];
		secAssignBlockingVolumesExpanded=elisaExpandByNoR[secAssignBlockingVolumes];
		secAssignSampleAntibodyComplexImmunosorbentVolumesExpanded=elisaExpandByNoR[secAssignSampleAntibodyComplexImmunosorbentVolumes];
		secAssignSampleImmunosorbentVolumesExpanded=elisaExpandByNoR[secAssignSampleImmunosorbentVolumes];
		secAssignPrimaryAntibodyImmunosorbentVolumesExpanded=elisaExpandByNoR[secAssignPrimaryAntibodyImmunosorbentVolumes];
		secAssignSecondaryAntibodyImmunosorbentVolumesExpanded=elisaExpandByNoR[secAssignSecondaryAntibodyImmunosorbentVolumes];
		secAssignSubstrateSolutionsExpanded=elisaExpandByNoR[secAssignSubstrateSolutionsResourcesLinked];
		secAssignStopSolutionsExpanded=elisaExpandByNoR[secAssignStopSolutionsResourcesLinked];
		secAssignSubstrateSolutionVolumesExpanded=elisaExpandByNoR[secAssignSubstrateSolutionVolumes];
		secAssignStopSolutionVolumesExpanded=elisaExpandByNoR[secAssignStopSolutionVolumes];
		(*Here we add Data subfield to the list for parser. For now they are a list of Null*)
		secAssignDataExpanded=ConstantArray[Null,Length[secAssignTypesExpanded]];
		(*Transpose back*)
		processedSecondaryELISAPlateAssignment={
			secAssignTypesExpanded,
			secAssignSamplesExpanded,
			secAssignSpikesExpanded,
			secAssignSpikeDilutionFactorsExpanded,
			secAssignSampleDilutionFactorsExpanded,
			secAssignCoatingAntibodiesExpanded,
			secAssignCoatingAntibodyDilutionFactorsExpanded,
			secAssignCaptureAntibodiesExpanded,
			secAssignCaptureAntibodyDilutionFactorsExpanded,
			secAssignReferenceAntigensExpanded,
			secAssignReferenceAntigenDilutionFactorsExpanded,
			secAssignPrimaryAntibodiesExpanded,
			secAssignPrimaryAntibodyDilutionFactorsExpanded,
			secAssignSecondaryAntibodiesExpanded,
			secAssignSecondaryAntibodyDilutionFactorsExpanded,
			secAssignCoatingVolumesExpanded,
			secAssignBlockingVolumesExpanded,
			secAssignSampleAntibodyComplexImmunosorbentVolumesExpanded,
			secAssignSampleImmunosorbentVolumesExpanded,
			secAssignPrimaryAntibodyImmunosorbentVolumesExpanded,
			secAssignSecondaryAntibodyImmunosorbentVolumesExpanded,
			secAssignSubstrateSolutionsExpanded,
			secAssignStopSolutionsExpanded,
			secAssignSubstrateSolutionVolumesExpanded,
			secAssignStopSolutionVolumesExpanded,
			secAssignDataExpanded
		}//Transpose;
		(*Make them into a list of associations*)
		Map[AssociationThread[
			{
				Type,
				Sample,
				Spike,
				SpikeDilutionFactor,
				SampleDilutionFactors,
				CoatingAntibody,
				CoatingAntibodyDilutionFactor,
				CaptureAntibody,
				CaptureAntibodyDilutionFactor,
				ReferenceAntigen,
				ReferenceAntigenDilutionFactor,
				PrimaryAntibody,
				PrimaryAntibodyDilutionFactor,
				SecondaryAntibody,
				SecondaryAntibodyDilutionFactor,
				CoatingVolume,
				BlockingVolume,
				SampleAntibodyComplexImmunosorbentVolume,
				SampleImmunosorbentVolume,
				PrimaryAntibodyImmunosorbentVolume,
				SecondaryAntibodyImmunosorbentVolume,
				SubstrateSolution,
				StopSolution,
				SubstrateSolutionVolume,
				StopSolutionVolume,
				Data
			}->#
		]&,
			processedSecondaryELISAPlateAssignment
		],
		(*Else: no secondary plate*)
		{}
	];

	(* --Tip resource-- *)
	numberOfWells=expandedPrimaryAntibodyWorkingResources//Length;
	numberOfBlocking=If[MatchQ[resolvedBlocking,True],1,0];
	numberOfStopping=If[Length[DeleteCases[expandedStops,Null|{Null..}|{}]]>0,1,0];
	methodSteps=Switch[resolvedMethod,
		DirectELISA,2,
		IndirectELISA,3,
		DirectSandwichELISA,3,
		IndirectSandwichELISA,4,
		DirectCompetitiveELISA,2,
		IndirectCompetitiveELISA,3,
		FastELISA,1
	];
	(*number of tip boxes to request: give 10% margin, round up to 96, and divide by 96*)
	tipNumber=numberOfWells*(numberOfBlocking+numberOfStopping+methodSteps+If[TrueQ[resolvedSecondaryAntibodyDilutionOnDeck],3,0])*1.1//Round;
	wholeStackNumber=Quotient[tipNumber,384];
	(**)
	partialStackTipNumber=If[Mod[tipNumber,384]<=8, Mod[tipNumber,384]+8, Mod[tipNumber,384]];
	(*If less than 1 whole stack is required, the wholeStackTipResource will be {}*)
	wholeStackTipResources=Map[Resource[Sample->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"], Name->ToString[Unique[]], Amount->384, UpdateCount->False]&,ConstantArray[1,wholeStackNumber]];
	(*adding 8 to tip number less than 8 as hsl is wierd with less than 8 tips.*)
	partialStackTipResource=If[partialStackTipNumber===0,{},{Resource[Sample->Model[Item,Tips,"300 uL Hamilton tips, non-sterile"], Name->ToString[Unique[]], Amount->partialStackTipNumber, UpdateCount->False]}];
	(*Combine whole stacks and partial stacks*)
	tipResource=Join[wholeStackTipResources,partialStackTipResource];

	(* Resource Check - Make sure our resources can fit onto Nimbus deck *)
	allDeckResources = DeleteDuplicates[
		Cases[
			Flatten[{If[TrueQ[resolvedSecondaryAntibodyDilutionOnDeck], {secondaryAntibodyDiluentResource, secondaryAntibodyConcentrateResources}, {}],substrateResources,stopResources,coatingAntibodyWorkingResources,captureAntibodyWorkingResources,primaryAntibodyWorkingResources,secondaryAntibodyWorkingResources,referenceAntigenWorkingResources}],
			_Resource
		]
	];

	(* Get the container out of the resource. First turn the resource into a list. Then depending on if it is a container resource or a sample resource, pick out the container using different keys *)
	allDeckResourceContainer = Map[
		If[MatchQ[Normal[#],KeyValuePattern[{Sample->ObjectP[{Model[Container]}]}]],
			#[Sample],
			#[Container]
		]&,
		allDeckResources
	];

	(* Check if there are too many containers *)
	tooMany2mLTubeQ = TrueQ[Count[allDeckResourceContainer,ObjectP[Model[Container,Vessel,"2mL Tube"]]]>32];
	tooMany50mLTubeQ = TrueQ[Count[allDeckResourceContainer,ObjectP[Model[Container,Vessel,"50mL Tube"]]]>8];

	(* Throw message, track error and generate tests *)
	If[tooMany2mLTubeQ||tooMany50mLTubeQ,
		Message[Error::TooManyContainersForELISADeck]
	];

	tooManyContainersTests = If[gatherTests,
		Test["There are fewer than 32 2mL tubes and 8 50mL tubes for the ELISA experiment due to the limit of the liquid handler deck:",tooMany2mLTubeQ||tooMany2mLTubeQ,False],
		Nothing
	];

	(*ELISA Run time*)
	pipettingTime=tipNumber*0.3Minute;
	runTime=UnitConvert[pipettingTime+Total[DeleteCases[{resolvedBlockingTime,resolvedPrimaryAntibodyImmunosorbentTime,resolvedSecondaryAntibodyImmunosorbentTime,resolvedSampleImmunosorbentTime,resolvedSampleAntibodyComplexImmunosorbentTime},Null]]+Total[DeleteCases[{resolvedBlockingNumberOfWashes,resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,resolvedSampleImmunosorbentNumberOfWashes,resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes},Null]*0.5Minute]+resolvedSubstrateIncubationTime+15Minute,Hour];



	(*In protocol, all IndexMatched parents and children are expanded by number of replicates. Here's a little helper to expand them. The function also recognized not populated multiples {} and {Null..} and turn them into {}*)
	elisaExpandOrShrink[input_List]:=If[MatchQ[input,{}|{Null..}],
		{},
		Flatten[ConstantArray[input,resolvedNumberOfReplicatesNullToOne]//Transpose,1]
	];

	(* -- Generate instrument resources -- *)
	(* Template Note: The time in instrument resources is used to charge customers for the instruNment time so it's important that this estimate is accurate this will probably look like set-up time + time/sample + tear-down time *)

	instrumentTime=Total[DeleteCases[{resolvedSampleAntibodyComplexIncubationTime,resolvedCoatingTime,resolvedBlockingTime,resolvedSampleAntibodyComplexImmunosorbentTime,resolvedSampleImmunosorbentTime,resolvedPrimaryAntibodyImmunosorbentTime,resolvedSecondaryAntibodyImmunosorbentTime,resolvedSubstrateIncubationTime},Null]]+
     Total[DeleteCases[{resolvedCoatingNumberOfWashes,resolvedBlockingNumberOfWashes,resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,resolvedSampleImmunosorbentNumberOfWashes,resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,resolvedSecondaryAntibodyImmunosorbentNumberOfWashes},Null]]*1.5Minute+10Minute;
	instrumentResource = Resource[Instrument->Model[Instrument, LiquidHandler, "id:rea9jlRLr5qb"], Time->instrumentTime, Name->ToString[Unique[]]];
	
	protocolID=CreateID[Object[Protocol,ELISA]];
	protocolKey=ObjectToFilePath[protocolID,FastTrack->True];

		 (* --- Generate the protocol packet --- *)
		 protocolPacket=<|
			 Type->Object[Protocol,ELISA],
			 Object->protocolID,
			 ProtocolKey->protocolKey,
			 Replace[SamplesIn]->elisaExpandOrShrink[Link[#,Protocols]&/@samplesInResources],
			 Replace[ContainersIn]->elisaExpandOrShrink[Link[#,Protocols]&/@containersInResources],
			 MethodFileName->"manipulations.json",
			 UnresolvedOptions->myUnresolvedOptions,
			 ResolvedOptions->myResolvedOptions,
			 Instrument->instrumentResource,
			 Replace[Checkpoints]->{
				 {"Picking Resources",15 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator->$BaselineOperator, Time->15 Minute]]},
				 {"Preparing Samples",10 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator->$BaselineOperator, Time->10 Minute]]},
				 {"Antibodies and Antigens dilution",10 Minute,"The dilution of antibodies and reference antigens using their diluents.",Link[Resource[Operator->$BaselineOperator,Time->30Minute]]},
				 {"Sample Dilution and Mixing",10 Minute,"Mixing samples, standards and blanks with diluents,spikes and antibodies.",Link[Resource[Operator->$BaselineOperator,Time->30Minute]]},
				 {"Coating",10 Minute+(resolvedCoatingTime/.Null->0Minute),"Adding coating reagents to ELISA plates and incubate.",Link[Resource[Operator->$BaselineOperator,Time->10Minute]]},
				 {"ELISA Run",runTime,"The blocking, immunosorbence, and detection steps.",Link[Resource[Operator->$BaselineOperator,Time->10Minute]]},
				 {"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator->$BaselineOperator, Time->1Hour]]},
				 {"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator->$BaselineOperator, Time->10Minute]]}
			 },
			 Method->resolvedMethod,
			 Replace[TargetAntigens]->elisaExpandOrShrink[Link[resolvedTargetAntigen]],
			 NumberOfReplicates->resolvedNumberOfReplicates,
			 WashingBuffer->Link[washingBufferResource],
			 Replace[Spikes]->elisaExpandOrShrink[Map[Link,spikeResourcesSampleIndexed//ToList]],
			 Replace[SpikeDilutionFactors]->elisaExpandOrShrink[N[resolvedSpikeDilutionFactor]],
			 Replace[SpikeStorageConditions]->elisaExpandOrShrink[resolvedSpikeStorageCondition],
			 Replace[SampleDilutionCurves]->elisaExpandOrShrink[resolverRoundedTransformedSampleDilutionCurve],
			 Replace[SampleSerialDilutionCurves]->elisaExpandOrShrink[resolverRoundedTransformedSampleSerialDilutionCurve],
			 SampleDiluent->Link[sampleDiluentResource],
			 Replace[CoatingAntibodies]->elisaExpandOrShrink[Map[Link,coatingAntibodyResourcesSampleIndexed//ToList]],
			 Replace[CoatingAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedCoatingAntibodyDilutionFactor]],
			 Replace[CoatingAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedCoatingAntibodyVolume,0.1Microliter]],
			 CoatingAntibodyDiluent->Link[coatingAntibodyDiluentResource],
			 Replace[CoatingAntibodyStorageConditions]->elisaExpandOrShrink[resolvedCoatingAntibodyStorageCondition],
			 Replace[CaptureAntibodies]->elisaExpandOrShrink[Map[Link,captureAntibodyResourcesSampleIndexed//ToList]],
			 Replace[CaptureAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedCaptureAntibodyDilutionFactor]],
			 Replace[CaptureAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedCaptureAntibodyVolume,0.1Microliter]],
			 CaptureAntibodyDiluent->Link[captureAntibodyDiluentResource],
			 Replace[CaptureAntibodyStorageConditions]->elisaExpandOrShrink[resolvedCaptureAntibodyStorageCondition],
			 Replace[ReferenceAntigens]->elisaExpandOrShrink[Map[Link,referenceAntigenResourcesSampleIndexed//ToList]],
			 Replace[ReferenceAntigenDilutionFactors]->elisaExpandOrShrink[N[resolvedReferenceAntigenDilutionFactor]],
			 Replace[ReferenceAntigenVolumes]->elisaExpandOrShrink[SafeRound[resolvedReferenceAntigenVolume,0.1Microliter]],
			 ReferenceAntigenDiluent->Link[referenceAntigenDiluentResource],
			 Replace[ReferenceAntigenStorageConditions]->elisaExpandOrShrink[resolvedReferenceAntigenStorageCondition],
			 Replace[PrimaryAntibodies]->elisaExpandOrShrink[Map[Link,primaryAntibodyResourcesSampleIndexed//ToList]],
			 Replace[PrimaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedPrimaryAntibodyDilutionFactor]],
			 Replace[PrimaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedPrimaryAntibodyVolume,0.1Microliter]],
			 PrimaryAntibodyDiluent->Link[primaryAntibodyDiluentResource],
			 Replace[PrimaryAntibodyStorageConditions]->elisaExpandOrShrink[resolvedPrimaryAntibodyStorageCondition],
			 Replace[SecondaryAntibodies]->elisaExpandOrShrink[Map[Link,secondaryAntibodyResourcesSampleIndexed//ToList]],
			 Replace[SecondaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedSecondaryAntibodyDilutionFactor]],
			 Replace[SecondaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedSecondaryAntibodyVolume,0.1Microliter]],
			 SecondaryAntibodyDilutionOnDeck->resolvedSecondaryAntibodyDilutionOnDeck,
			 SecondaryAntibodyDiluent->Link[secondaryAntibodyDiluentResource],
			 Replace[SecondaryAntibodyStorageConditions]->elisaExpandOrShrink[resolvedSecondaryAntibodyStorageCondition],
			 SampleAntibodyComplexIncubation->resolvedSampleAntibodyComplexIncubation,
			 SampleAntibodyComplexIncubationTime->resolvedSampleAntibodyComplexIncubationTime,
			 SampleAntibodyComplexIncubationTemperature->resolvedSampleAntibodyComplexIncubationTemperature,
			 Coating->resolvedCoating,
			 Replace[SampleCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedSampleCoatingVolume,0.1Microliter]],
			 Replace[CoatingAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedCoatingAntibodyCoatingVolume,0.1Microliter]],
			 Replace[ReferenceAntigenCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedReferenceAntigenCoatingVolume,0.1Microliter]],
			 Replace[CaptureAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedCaptureAntibodyCoatingVolume,0.1Microliter]],
			 CoatingTemperature->resolvedCoatingTemperature,
			 CoatingTime->resolvedCoatingTime,
			 CoatingWashVolume->SafeRound[resolvedCoatingWashVolume,0.1Microliter],
			 CoatingNumberOfWashes->resolvedCoatingNumberOfWashes,
			 Blocking->resolvedBlocking,
			 BlockingBuffer->Link[blockingBufferResource],
			 Replace[BlockingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlockingVolume,0.1Microliter]],
			 BlockingTemperature->resolvedBlockingTemperature,
			 BlockingTime->resolvedBlockingTime,
			 BlockingMixRate->resolvedBlockingMixRate,
			 BlockingWashVolume->SafeRound[resolvedBlockingWashVolume,0.1Microliter],
			 BlockingNumberOfWashes->resolvedBlockingNumberOfWashes,
			 Replace[SampleAntibodyComplexImmunosorbentVolumes]->elisaExpandOrShrink[resolvedSampleAntibodyComplexImmunosorbentVolume],
			 SampleAntibodyComplexImmunosorbentTime->resolvedSampleAntibodyComplexImmunosorbentTime,
			 SampleAntibodyComplexImmunosorbentTemperature->resolvedSampleAntibodyComplexImmunosorbentTemperature,
			 SampleAntibodyComplexImmunosorbentMixRate->resolvedSampleAntibodyComplexImmunosorbentMixRate,
			 SampleAntibodyComplexImmunosorbentWashVolume->SafeRound[resolvedSampleAntibodyComplexImmunosorbentWashVolume,0.1Microliter],
			 SampleAntibodyComplexImmunosorbentNumberOfWashes->resolvedSampleAntibodyComplexImmunosorbentNumberOfWashes,
			 Replace[SampleImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedSampleImmunosorbentVolume,0.1Microliter]],
			 SampleImmunosorbentTime->resolvedSampleImmunosorbentTime,
			 SampleImmunosorbentTemperature->resolvedSampleImmunosorbentTemperature,
			 SampleImmunosorbentMixRate->resolvedSampleImmunosorbentMixRate,
			 SampleImmunosorbentWashVolume->SafeRound[resolvedSampleImmunosorbentWashVolume,0.1Microliter],
			 SampleImmunosorbentNumberOfWashes->resolvedSampleImmunosorbentNumberOfWashes,
			 Replace[PrimaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[resolvedPrimaryAntibodyImmunosorbentVolume],
			 PrimaryAntibodyImmunosorbentTime->resolvedPrimaryAntibodyImmunosorbentTime,
			 PrimaryAntibodyImmunosorbentTemperature->resolvedPrimaryAntibodyImmunosorbentTemperature,
			 PrimaryAntibodyImmunosorbentMixRate->resolvedPrimaryAntibodyImmunosorbentMixRate,
			 PrimaryAntibodyImmunosorbentWashing->resolvedPrimaryAntibodyImmunosorbentWashing,
			 PrimaryAntibodyImmunosorbentWashVolume->SafeRound[resolvedPrimaryAntibodyImmunosorbentWashVolume,0.1Microliter],
			 PrimaryAntibodyImmunosorbentNumberOfWashes->resolvedPrimaryAntibodyImmunosorbentNumberOfWashes,
			 Replace[SecondaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedSecondaryAntibodyImmunosorbentVolume,0.1Microliter]],
			 SecondaryAntibodyImmunosorbentTime->resolvedSecondaryAntibodyImmunosorbentTime,
			 SecondaryAntibodyImmunosorbentTemperature->resolvedSecondaryAntibodyImmunosorbentTemperature,
			 SecondaryAntibodyImmunosorbentMixRate->resolvedSecondaryAntibodyImmunosorbentMixRate,
			 SecondaryAntibodyImmunosorbentWashing->resolvedSecondaryAntibodyImmunosorbentWashing,
			 SecondaryAntibodyImmunosorbentWashVolume->SafeRound[resolvedSecondaryAntibodyImmunosorbentWashVolume,0.1Microliter],
			 SecondaryAntibodyImmunosorbentNumberOfWashes->resolvedSecondaryAntibodyImmunosorbentNumberOfWashes,
			 Replace[SubstrateSolutions]->elisaExpandOrShrink[Map[Link,substrateResourcesSampleIndexed//ToList]],
			 Replace[StopSolutions]->elisaExpandOrShrink[Map[Link,stopResourcesSampleIndexed//ToList]],
			 Replace[SubstrateSolutionVolumes]->elisaExpandOrShrink[SafeRound[resolvedSubstrateSolutionVolume,0.1Microliter]],
			 Replace[StopSolutionVolumes]->elisaExpandOrShrink[SafeRound[resolvedStopSolutionVolume,0.1Microliter]],
			 SubstrateIncubationTime->resolvedSubstrateIncubationTime,
			 SubstrateIncubationTemperature->resolvedSubstrateIncubationTemperature,
			 SubstrateIncubationMixRate->resolvedSubstrateIncubationMixRate,
			 
			 (* preread options *)
			 Replace[PrereadTimepoints]->Lookup[expandedResolvedOptions,PrereadTimepoints],
			 Replace[PrereadAbsorbanceWavelengths]->Lookup[expandedResolvedOptions,PrereadAbsorbanceWavelength],
			 
			 Replace[AbsorbanceWavelengths]->ToList[resolvedAbsorbanceWavelength], (*Wavelengths is multiple but is not index-Matched*)
			 SignalCorrection->resolvedSignalCorrection,
			 Replace[Standards]->elisaExpandOrShrink[Map[Link,standardResourcesStandardIndexMatched]],
			 Replace[StandardTargetAntigens]->elisaExpandOrShrink[Link[resolvedStandardTargetAntigen//ToList]],
			 Replace[StandardDilutionCurves]->elisaExpandOrShrink[resolverRoundedTransformedStandardDilutionCurve],
			 Replace[StandardSerialDilutionCurves]->elisaExpandOrShrink[resolverRoundedTransformedStandardSerialDilutionCurve],
			 StandardDiluent->Link[standardDiluentResource],
			 Replace[StandardStorageConditions]->elisaExpandOrShrink[resolvedStandardStorageCondition],
			 Replace[StandardCoatingAntibodies]->elisaExpandOrShrink[Map[Link,coatingAntibodyResourcesStandardIndexed//ToList]],
			 Replace[StandardCoatingAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedStandardCoatingAntibodyDilutionFactor]],
			 Replace[StandardCoatingAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardCoatingAntibodyVolume,0.1Microliter]],
			 Replace[StandardCaptureAntibodies]->elisaExpandOrShrink[Map[Link,captureAntibodyResourcesStandardIndexed//ToList]],
			 Replace[StandardCaptureAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedStandardCaptureAntibodyDilutionFactor]],
			 Replace[StandardCaptureAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardCaptureAntibodyVolume,0.1Microliter]],
			 Replace[StandardReferenceAntigens]->elisaExpandOrShrink[Map[Link,referenceAntigenResourcesStandardIndexed//ToList]],
			 Replace[StandardReferenceAntigenDilutionFactors]->elisaExpandOrShrink[N[resolvedStandardReferenceAntigenDilutionFactor]],
			 Replace[StandardReferenceAntigenVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardReferenceAntigenVolume,0.1Microliter]],
			 Replace[StandardPrimaryAntibodies]->elisaExpandOrShrink[Map[Link,primaryAntibodyResourcesStandardIndexed//ToList]],
			 Replace[StandardPrimaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedStandardPrimaryAntibodyDilutionFactor]],
			 Replace[StandardPrimaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardPrimaryAntibodyVolume,0.1Microliter]],
			 Replace[StandardSecondaryAntibodies]->elisaExpandOrShrink[Map[Link,secondaryAntibodyResourcesStandardIndexed//ToList]],
			 Replace[StandardSecondaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedStandardSecondaryAntibodyDilutionFactor]],
			 Replace[StandardSecondaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardSecondaryAntibodyVolume,0.1Microliter]],
			 Replace[StandardCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardCoatingVolume,0.1Microliter]],
			 Replace[StandardReferenceAntigenCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardReferenceAntigenCoatingVolume,0.1Microliter]],
			 Replace[StandardCoatingAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardCoatingAntibodyCoatingVolume,0.1Microliter]],
			 Replace[StandardCaptureAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardCaptureAntibodyCoatingVolume,0.1Microliter]],
			 Replace[StandardBlockingVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardBlockingVolume,0.1Microliter]],
			 Replace[StandardAntibodyComplexImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardAntibodyComplexImmunosorbentVolume,0.1Microliter]],
			 Replace[StandardImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardImmunosorbentVolume,0.1Microliter]],
			 Replace[StandardPrimaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardPrimaryAntibodyImmunosorbentVolume,0.1Microliter]],
			 Replace[StandardSecondaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardSecondaryAntibodyImmunosorbentVolume,0.1Microliter]],
			 Replace[StandardSubstrateSolutions]->elisaExpandOrShrink[Map[Link,substrateResourcesStandardIndexed//ToList]],
			 Replace[StandardStopSolutions]->elisaExpandOrShrink[Map[Link,stopResourcesStandardIndexed//ToList]],
			 Replace[StandardSubstrateSolutionVolumes]->elisaExpandOrShrink[SafeRound[resolvedStandardSubstrateSolutionVolume,0.1Microliter]],
			 Replace[StandardStopSolutionVolumes]->elisaExpandOrShrink[resolvedStandardStopSolutionVolume],
			 Replace[Blanks]->elisaExpandOrShrink[Map[Link,blankResourcesBlankIndexMatched//ToList]],
			 Replace[BlankTargetAntigens]->elisaExpandOrShrink[Link[resolvedBlankTargetAntigen]],
			 Replace[BlankStorageConditions]->elisaExpandOrShrink[resolvedBlankStorageCondition],
			 Replace[BlankCoatingAntibodies]->elisaExpandOrShrink[Map[Link,coatingAntibodyResourcesBlankIndexed//ToList]],
			 Replace[BlankCoatingAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedBlankCoatingAntibodyDilutionFactor]],
			 Replace[BlankCoatingAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankCoatingAntibodyVolume,0.1Microliter]],
			 Replace[BlankCaptureAntibodies]->elisaExpandOrShrink[Map[Link,captureAntibodyResourcesBlankIndexed//ToList]],
			 Replace[BlankCaptureAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedBlankCaptureAntibodyDilutionFactor]],
			 Replace[BlankCaptureAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankCaptureAntibodyVolume,0.1Microliter]],
			 Replace[BlankReferenceAntigens]->elisaExpandOrShrink[Map[Link,referenceAntigenResourcesBlankIndexed//ToList]],
			 Replace[BlankReferenceAntigenDilutionFactors]->elisaExpandOrShrink[N[resolvedBlankReferenceAntigenDilutionFactor]],
			 Replace[BlankReferenceAntigenVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankReferenceAntigenVolume,0.1Microliter]],
			 Replace[BlankPrimaryAntibodies]->elisaExpandOrShrink[Map[Link,primaryAntibodyResourcesBlankIndexed//ToList]],
			 Replace[BlankPrimaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedBlankPrimaryAntibodyDilutionFactor]],
			 Replace[BlankPrimaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankPrimaryAntibodyVolume,0.1Microliter]],
			 Replace[BlankSecondaryAntibodies]->elisaExpandOrShrink[Map[Link,secondaryAntibodyResourcesBlankIndexed//ToList]],
			 Replace[BlankSecondaryAntibodyDilutionFactors]->elisaExpandOrShrink[N[resolvedBlankSecondaryAntibodyDilutionFactor]],
			 Replace[BlankSecondaryAntibodyVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankSecondaryAntibodyVolume,0.1Microliter]],
			 Replace[BlankCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankCoatingVolume,0.1Microliter]],
			 Replace[BlankReferenceAntigenCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankReferenceAntigenCoatingVolume,0.1Microliter]],
			 Replace[BlankCoatingAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankCoatingAntibodyCoatingVolume,0.1Microliter]],
			 Replace[BlankCaptureAntibodyCoatingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankCaptureAntibodyCoatingVolume,0.1Microliter]],
			 Replace[BlankBlockingVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankBlockingVolume,0.1Microliter]],
			 Replace[BlankAntibodyComplexImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankAntibodyComplexImmunosorbentVolume,0.1Microliter]],
			 Replace[BlankImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankImmunosorbentVolume,0.1Microliter]],
			 Replace[BlankPrimaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankPrimaryAntibodyImmunosorbentVolume,0.1Microliter]],
			 Replace[BlankSecondaryAntibodyImmunosorbentVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankSecondaryAntibodyImmunosorbentVolume,0.1Microliter]],
			 Replace[BlankSubstrateSolutions]->elisaExpandOrShrink[Map[Link,substrateResourcesBlankIndexed//ToList]],
			 Replace[BlankStopSolutions]->elisaExpandOrShrink[Map[Link,stopResourcesBlankIndexed//ToList]],
			 Replace[BlankSubstrateSolutionVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankSubstrateSolutionVolume,0.1Microliter]],
			 Replace[BlankStopSolutionVolumes]->elisaExpandOrShrink[SafeRound[resolvedBlankStopSolutionVolume,0.1Microliter]],
			 Replace[BufferContainerPlacements]->{{Link[washingBufferResource],{"Buffer A Slot"}}},
			 ELISAPlate->Link[elisaPlateResource],
			 SecondaryELISAPlate->Link[secondaryELISAPlateResource],
			 Replace[ELISAPlateAssignment]->associatedELISAPlateAssignment,
			 Replace[SecondaryELISAPlateAssignment]->associatedSecondaryELISAPlateAssignment,
			 SampleAssemblyPlate->Link[sampleAssemblyContainerResource],
			 SecondarySampleAssemblyPlate->Link[secondarySampleAssemblyContainerResource],
			 Replace[Tips]->Link/@tipResource,
			 (*Fields for Antibody dilutions: must not be expanded*)
			 Replace[CoatingAntibodyConcentrates]->Map[Link,coatingAntibodiesToDilute],
			 Replace[CoatingAntibodyDilutionVolumes]->SafeRound[coatingAntibodyDilutionVolumes,0.1Microliter],
			 Replace[CoatingAntibodyDiluentDilutionVolumes]->SafeRound[coatingAntibodyDiluentDilutionVolumes,0.1Microliter],
			 Replace[CoatingAntibodyDilutionContainers]->Map[Link,coatingAntibodyDilutionContainers],
			 Replace[CoatingAntibodyConcentrateStorageConditions]->coatingAntibodiesToDiluteStorage,

			 Replace[CaptureAntibodyConcentrates]->Map[Link,captureAntibodiesToDilute],
			 Replace[CaptureAntibodyDilutionVolumes]->SafeRound[captureAntibodyDilutionVolumes,0.1Microliter],
			 Replace[CaptureAntibodyDiluentDilutionVolumes]->SafeRound[captureAntibodyDiluentDilutionVolumes,0.1Microliter],
			 Replace[CaptureAntibodyDilutionContainers]->Map[Link,captureAntibodyDilutionContainers],
			 Replace[CaptureAntibodyConcentrateStorageConditions]->captureAntibodiesToDiluteStorage,

			 Replace[ReferenceAntigenConcentrates]->Map[Link,referenceAntigensToDilute],
			 Replace[ReferenceAntigenDilutionVolumes]->SafeRound[referenceAntigenDilutionVolumes,0.1Microliter],
			 Replace[ReferenceAntigenDiluentDilutionVolumes]->SafeRound[referenceAntigenDiluentDilutionVolumes,0.1Microliter],
			 Replace[ReferenceAntigenDilutionContainers]->Map[Link,referenceAntigenDilutionContainers],
			 Replace[ReferenceAntigenConcentrateStorageConditions]->referenceAntigensToDiluteStorage,

			 Replace[PrimaryAntibodyConcentrates]->Map[Link,primaryAntibodiesToDilute],
			 Replace[PrimaryAntibodyDilutionVolumes]->SafeRound[primaryAntibodyDilutionVolumes,0.1Microliter],
			 Replace[PrimaryAntibodyDiluentDilutionVolumes]->SafeRound[primaryAntibodyDiluentDilutionVolumes,0.1Microliter],
			 Replace[PrimaryAntibodyDilutionContainers]->Map[Link,primaryAntibodyDilutionContainers],
			 Replace[PrimaryAntibodyConcentrateStorageConditions]->primaryAntibodiesToDiluteStorage,

			 Replace[SecondaryAntibodyConcentrates]->Map[Link,secondaryAntibodiesToDilute],
			 Replace[SecondaryAntibodyDilutionVolumes]->SafeRound[secondaryAntibodyDilutionVolumes,0.1Microliter],
			 Replace[SecondaryAntibodyDiluentDilutionVolumes]->SafeRound[secondaryAntibodyDiluentDilutionVolumes,0.1Microliter],
			 Replace[SecondaryAntibodyDilutionContainers]->Map[Link,secondaryAntibodyDilutionContainers],
			 Replace[SecondaryAntibodyConcentrateStorageConditions]->secondaryAntibodiesToDiluteStorage,

			 (*Developer fields: already fully expanded including the dilution curves*)
			 Replace[WorkingCoatingAntibodies]->Map[Link,coatingAntibodyWorkingResources],
			 Replace[WorkingCaptureAntibodies]->Map[Link,captureAntibodyWorkingResources],
			 Replace[WorkingPrimaryAntibodies]->Map[Link,primaryAntibodyWorkingResources],
			 Replace[WorkingSecondaryAntibodies]->Map[Link,secondaryAntibodyWorkingResources],
			 Replace[WorkingReferenceAntigens]->Map[Link,referenceAntigenWorkingResources],
			 Replace[SampleAssemblyWellIDs]->Map[If[MatchQ[#,_Resource],Link[#],#]&,(joinedSampleAssemblyPositionsExpanded),{2}],
			 Replace[AssayPlateAssemblyWellIDs]->Map[If[MatchQ[#,_Resource],Link[#],#]&,(joinedAssayPlatePositionsExpanded),{2}],
			 Replace[ExpandedDiluents]->Map[Link,expandedJoinedDiluents],
			 Replace[ExpandedSpikes]->Map[Link,expandedJoinedSpikes],
			 Replace[ExpandedConcentrateVolumes]->SafeRound[expandedConcentrateVolumes,0.1Microliter],
			 Replace[ExpandedDiluentVolumes]->SafeRound[expandedDiluentVolumes,0.1Microliter],
			 Replace[ExpandedSpikeVolumes]->SafeRound[expandedSpikeVolumes,0.1Microliter],
			 Replace[ExpandedPrimaryAntibodySampleMixingVolumes]->SafeRound[expandedPrimaryAntibodySampleMixingVolumes,0.1Microliter],
			 Replace[ExpandedCaptureAntibodySampleMixingVolumes]->SafeRound[expandedCaptureAntibodySampleMixingVolumes,0.1Microliter],
			 Replace[ExpandedSampleAssemblyTotalVolumes]->SafeRound[expanededJoinedAssayVolumes,0.1Microliter],
			 Replace[ExpandedSerialDilutionQ]->expandedSerialQ,
			 Replace[ExpandedWorkingPrimaryAntibodies]->Map[Link,expandedPrimaryAntibodyWorkingResources],
			 Replace[ExpandedWorkingSecondaryAntibodies]->Map[Link,expandedSecondaryAntibodyWorkingResources],
			 Replace[ExpandedWorkingCaptureAntibodies]->Map[Link,expandedCaptureAntibodyWorkingResources],
			 Replace[ExpandedWorkingCoatingAntibodies]->Map[Link,expandedCoatingAntibodyWorkingResources],
			 Replace[ExpandedWorkingReferenceAntigens]->Map[Link,expandedReferenceAntigenWorkingResources],
			 Replace[ExpandedSampleCoatingVolumes]->SafeRound[expandedSampleCoatingVolumes,0.1Microliter],
			 Replace[ExpandedCoatingAntibodyCoatingVolumes]->SafeRound[expandedCoatingAntibodyCoatingVolumes,0.1Microliter],
			 Replace[ExpandedCaptureAntibodyCoatingVolumes]->SafeRound[expandedCaptureAntibodyCoatingVolumes,0.1Microliter],
			 Replace[ExpandedReferenceAntigenCoatingVolumes]->SafeRound[expandedReferenceAntigenCoatingVolumes,0.1Microliter],
			 Replace[ExpandedSampleImmunosorbentVolumes]->SafeRound[expandedSampleImmunosorbentVolumes,0.1Microliter],
			 Replace[ExpandedSampleAntibodyComplexImmunosorbentVolumes]->SafeRound[expandedSampleAntibodyComplexImmunosorbentVolumes,0.1Microliter],
			 Replace[ExpandedPrimaryAntibodyImmunosorbentVolumes]->SafeRound[expandedPrimaryAntibodyImmunosorbentVolumes,0.1Microliter],
			 Replace[ExpandedSecondaryAntibodyImmunosorbentVolumes]->SafeRound[expandedSecondaryAntibodyImmunosorbentVolumes,0.1Microliter],
			 Replace[ExpandedSubstrateSolutions]->Map[Link,expandedSubstrates],
			 Replace[ExpandedStopSolutions]->Map[Link,expandedStops],
			 Replace[ExpandedSubstrateSolutionVolumes]->SafeRound[expandedSubstrateVolumes,0.1Microliter],
			 Replace[ExpandedStopSolutionVolumes]->SafeRound[expandedStopVolumes,0.1Microliter],
			 Replace[ExpandedBlockingVolumes]->SafeRound[expandedBlockVolumes,0.1Microliter],
			 AntibodyAntigenDilutionQ->antibodyAntigenDilutionQ,
			 ELISARunTime->runTime
		 |>;

		 (* generate a packet with the shared fields *)
		 sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Simulation -> simulation];

		 (* Merge the shared fields with the specific fields *)
		 finalizedPacket = Join[sharedFieldPacket, protocolPacket];

		 (* get all the resource symbolic representations *)
		 (* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
		 allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

		 (* call fulfillableResourceQ on all the resources we created *)
		 {fulfillable, frqTests} = Which[
			 MatchQ[$ECLApplication, Engine], {True, {}},
			 gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output->{Result, Tests}, FastTrack->Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache->inheritedCache, Simulation -> simulation],
			 True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack->Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages->messages, Cache->inheritedCache, Simulation -> simulation], {}}
		 ];

		 (* generate the tests rule *)
		 testsRule = Tests->If[gatherTests,
			 Append[frqTests,tooManyContainersTests],
			 Null
		 ];

		 (* generate the Result output rule *)
		 (* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
		 resultRule = Result->If[MemberQ[output, Result] && TrueQ[fulfillable]&&!TrueQ[tooLargeVolumeQ]&&!TrueQ[tooMany2mLTubeQ]&&!TrueQ[tooMany50mLTubeQ]&&!TrueQ[secondaryAntibodyOnDeckError],
			 finalizedPacket,
			 $Failed
		 ];

		 (* return the output as we desire it *)
		 outputSpecification /. {resultRule, testsRule}
];

(*HELPER: From a Cache, extract part number of the field for an object. For example, elisaGetPacketValue[Model[Sample, Blah], Analytes, 1]
		gets the first value of Analyte field in Model[Sample,Blah]. If packet or field is not populated, returns Null. If the field is single, use All for a listed return and 1 for single return*)

(*If field is single, or multiple needing the first layer*)
elisaGetPacketValue[object_,field_,part_,cache_] := Module[{packet,fieldValue,crudeExtract},
	If[!MatchQ[object,ObjectP[]],Null,
		packet = Experiment`Private`fetchPacketFromCache[object, cache];
		If[MatchQ[packet,Association[]|Null], Null,

			fieldValue = packet[field];
			If[MatchQ[fieldValue,{}| Null|{Null}|_Missing],
				Null,
				crudeExtract=If[!MatchQ[part,All],ToList[fieldValue][[part]],fieldValue];
				(*If link or a list of links, strip Link*)
				Which[
					MatchQ[crudeExtract, LinkP[]],Download[crudeExtract,Object],
					MatchQ[crudeExtract, {LinkP[]..}],Download[#,Object]&/@crudeExtract,
					True,crudeExtract
				]
			]
		]
	]
];


