(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(* NMRSharedOptions *)

DefineOptionSet[NMRSharedOptions :> {
	IndexMatching[
		IndexMatchingInput->"experiment samples",
		{
			OptionName -> SolventVolume,
			Default -> Automatic,
			Description -> "The amount of the specified DeuteratedSolvent to add to the sample, the combination of which will be read in the NMR spectrometer. If directly set to 0 uL then neat sample will itself be added to an NMR tube.",
			ResolutionDescription -> "Automatically set to Null if the sample is already in an NMR tube, or a volume such that SampleAmount + SolventVolume = 700 uL if it is not.",
			AllowNull -> True,
			Category -> "Sample Parameters",
			Widget ->
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 1000 Microliter],
					Units -> {1, {Microliter, {Microliter, Milliliter}}}
				]
		},
		{
			OptionName -> SampleAmount,
			Default -> Automatic,
			Description -> "The amount of sample (after aliquoting, if applicable) that will be dissolved in the specified DeuteratedSolvent.",
			ResolutionDescription -> "Automatically set to Null if the sample is already in an NMR tube, or if not, to the smaller of 5 Milligram or the full mass of the sample if a solid, the smaller or 10 Microliter or the full volume of the sample if a liquid, or 1 unit if a counted sample.",
			AllowNull -> True,
			Category -> "Sample Parameters",
			Widget -> Alternatives[
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 1000 Microliter],
					Units -> {1, {Microliter, {Microliter}}}
				],
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Milligram, 3 Gram],
					Units -> {1, {Milligram, {Milligram, Gram}}}
				],
				"Count" ->Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Unit, 1 Unit],
					Units -> {1, {Unit, {Unit}}}
				],
				"Count" -> Widget[
					Type -> Number,
					Pattern :> GreaterP[0., 1.]
				]
			]
		},
		{
			OptionName -> SampleTemperature,
			Default -> Ambient,
			Description -> "The temperature at which the sample will be held prior to and during data collection.",
			AllowNull -> True,
			Category -> "Sample Parameters",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				],
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[-50*Celsius, 60*Celsius],
					Units -> {1,{Celsius,{Celsius, Fahrenheit, Kelvin}}}
				]
			]
		},
		{
			OptionName -> NMRTube,
			Default -> Model[Container, Vessel, "NMR Tube, 5 mm x 103.5 mm"],
			Description -> "The model of NMR tube in which the provided input sample will be placed prior to data collection.",
			AllowNull -> False,
			Category -> "Sample Parameters",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container, Vessel]}]
			]
		}
	],
	{
		OptionName -> NumberOfReplicates,
		Default -> Null,
		Description -> "The number of times to repeat NMR reading on each provided sample. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
		AllowNull -> True,
		Category -> "Protocol",
		Widget -> Widget[
			Type -> Number,
			Pattern :> GreaterEqualP[2, 1]
		]
	}
}];
