(* ::Package:: *)
(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)
(* ::Section:: *)
(*Source Code*)
(* ::Subsection:: *)
(*DefineComposition*)
(* ::Subsubsection:: *)
(*Options and Messages*)
DefineOptions[DefineComposition,
	SharedOptions :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Composition,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[{
					"Amount" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> Alternatives[
								GreaterP[0 Molar],
								GreaterP[0 Gram / Liter],
								RangeP[0 VolumePercent, 100 VolumePercent],
								RangeP[0 MassPercent, 100 MassPercent],
								RangeP[0 PercentConfluency, 100 PercentConfluency],
								GreaterP[0 Cell / Liter],
								GreaterP[0 CFU / Liter],
								GreaterP[0 OD600],
								GreaterP[0 Colony]
							],
							Units -> Alternatives[
								{1, {Molar, {Micromolar, Millimolar, Molar}}},
								CompoundUnit[
									{1, {Gram, {Kilogram, Gram, Milligram, Microgram}}},
									{-1, {Liter, {Liter, Milliliter, Microliter}}}
								],
								{1, {VolumePercent, {VolumePercent}}},
								{1, {MassPercent, {MassPercent}}},
								{1, {PercentConfluency, {PercentConfluency}}},
								CompoundUnit[
									{1, {EmeraldCell, {EmeraldCell}}},
									{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
								],
								CompoundUnit[
									{1, {CFU, {CFU}}},
									{-1, {Milliliter, {Liter, Milliliter, Microliter}}}
								],
								{1, {OD600, {OD600}}},
								{1, {Colony, {Colony}}}
							]
						],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					],
					"Identity Model" -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[List @@ IdentityModelTypeP]],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					],
					"Date " -> Alternatives[
						Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector -> False],
						Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
					]
				}],
				Description -> "The various molecular components present in this sample, along with their respective concentrations. The recorded composition is associated with the specific time at which it is defined.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Append,
				Default -> False,
				AllowNull -> False,
				Description -> "Indicates whether the composition provided should be appended to the existing composition.",
				Category -> "Organizational Information",
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
			}
		],
		ExternalUploadHiddenOptions
	}
];
InstallDefaultUploadFunction[DefineComposition, Object[Sample], InstallNameOverload -> False, InstallObjectOverload -> True];
InstallValidQFunction[DefineComposition, Object[Sample]];
InstallOptionsFunction[DefineComposition, Object[Sample]];
