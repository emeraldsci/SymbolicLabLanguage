(* ::Package:: *)

(* ::Text:: *)
(* \[Copyright] 2011-2023 Emerald Cloud Lab, Inc. *)

(* ::Subsection::Closed:: *)
(* RoboticInstrumentOption *)

DefineOptionSet[
	RoboticInstrumentOption :> {
		{
			OptionName -> RoboticInstrument,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Instrument, LiquidHandler],Model[Instrument, LiquidHandler]}],
				OpenPaths -> {
					{Object[Catalog,"Root"],
						"Instruments",
						"Liquid Handling"}
				}
			],
			Description -> "The robotic liquid handler used (along with integrated instrumentation for heating, mixing, and other functions) to manipulate the cell sample in order to extract and purify targeted cellular components.",
			ResolutionDescription -> "Automatically set to a robotic liquid handler compatible with the specified temperatures, mix types, and mix rates required by the extraction experiment, as well as the container and CellType of the sample. See the function MixDevices for integrated mixing instruments compatible with a given sample. See the function IncubationDevices for integrated heating instruments compatible with a given sample.",
			Category->"General"
		}
	}];

(* ::Subsection::Closed:: *)
(* RoboticMixOptions *)

DefineOptionSet[
	RoboticMixOptions :> {
		{
			OptionName -> Mix,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates whether the input samples are mixed before any downstream operations.",
			ResolutionDescription -> "Automatically set to True if any Robotic Mix options (MixType/MixInstrument/MixTime/MixRate/MixTemperature/NumberOfMixes/MixVolume) are set. Otherwise, set to False.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixType,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> RoboticMixTypeP],
			Description -> "Indicates the style of motion (Shake or Pipette) used to mix the input samples.",
			ResolutionDescription -> "Automatically set to Pipette if any of pipette mixing options (NumberOfMixes/MixVolume) is set. Otherwise, set to Shake.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixInstrument,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, Shaker], Object[Instrument, Shaker]}]
			],
			Description -> "The instrument used to mix the input samples before any downstream operations.",
			ResolutionDescription -> "Automatically set to Model[Instrument, Shaker, \"Inheco ThermoshakeAC\"] if the MixType is set to Shake. Otherwise, set to Null.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixTime,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute, $MaxExperimentTime],
				Units -> {1, {Minute, {Second, Minute, Hour}}}
			],
			Description -> "Duration of time for which the input samples are mixed.",
			ResolutionDescription -> "Automatically set to 1 Minute if MixType is set to Shake. Otherwise, set to Null.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Quantity, Pattern :> RangeP[$MinBioSTARMixRate, $MaxBioSTARMixRate], Units -> RPM],
			Description -> "The frequency of rotation of the mixing instrument used to mix the input samples.",
			ResolutionDescription -> "Automatically set to 200 RPM if MixType is set to Shake. Otherwise, set to Null.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixTemperature,
			Default -> Automatic,
			Description -> "The temperature that the mixing device endeavours to maintain in the samples chamber during mixing.",
			ResolutionDescription -> "Automatically set to Ambient if MixType is specified. Otherwise, set to Null.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[$MinRoboticIncubationTemperature, $MaxRoboticIncubationTemperature],
					Units :> Celsius
				],
				Widget[Type -> Enumeration, Pattern :> Alternatives[Ambient]]
			],
			Category -> "Robotic Mix"
		},
		{
			OptionName -> NumberOfMixes,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type->Number, Pattern :> RangeP[1, $MaxNumberOfMixes, 1]],
			Description -> "The number of pipetting cycles (aspiration/dispense) used to mix the input samples.",
			ResolutionDescription -> "Automatically set to 5 if MixType is set to Pipette. Otherwise, set to Null.",
			Category -> "Robotic Mix"
		},
		{
			OptionName -> MixVolume,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[$MinRoboticTransferVolume, $MaxRoboticSingleTransferVolume],
				Units :> {1, {Microliter, {Microliter, Milliliter}}}
			],
			Description -> "The volume of the sample that is pipetted up and down to mix the input samples.",
			ResolutionDescription -> "Automatically set to the lesser of half of the volume of the input sample or the largest volume that can be pipetted in a single step by the robotic liquid handler (970 Microliters).",
			Category -> "Robotic Mix"
		}
	}
];


(* ::Subsection::Closed:: *)
(* CultureAdhesionOption *)
DefineOptionSet[
	CultureAdhesionOption :> {
		{
			OptionName -> CultureAdhesion,
			Default -> Automatic,
			Description -> "Indicates how the input cell sample physically interacts with its container. Options include Adherent and Suspension (including any microbial liquid media).",
			ResolutionDescription -> "Automatically set to the CultureAdhesion field of the input samples.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> CultureAdhesionP
			],
			Category -> "General"
		}
	}
];

(* ::Subsection::Closed:: *)
(* TargetCellularComponentOption *)
DefineOptionSet[
	TargetCellularComponentOption :> {
		{
			OptionName -> TargetCellularComponent,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[CellularComponentP, Unspecified]],
			Description -> "The class of biomolecule whose purification is desired following lysis of the cell sample and any subsequent extraction operations. Options include CytosolicProtein, PlasmaMembraneProtein, NuclearProtein, SecretoryProtein, TotalProtein, RNA, GenomicDNA, PlasmidDNA, Organelle, Virus and Unspecified.",
			Category -> "General"
		}
	}
];

