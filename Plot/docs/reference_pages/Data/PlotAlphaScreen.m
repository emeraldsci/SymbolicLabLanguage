(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAlphaScreen*)


DefineUsage[PlotAlphaScreen,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotAlphaScreen[alphaScreenData]", "plot"},
				Description -> "provides a graphical plot the provided luminescence intensities either in the form of a histogram or a box and whisker plot.",
				Inputs :> {
					{
						InputName -> "alphaScreenData",
						Description -> "A list of the AlphaScreen data objects whose intensity readings you wish to plot.",
						Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Data, AlphaScreen]]]]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the distribution(s) of intensities provided.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotAlphaScreen[intensities]", "plot"},
				Description -> "provides a graphical plot the provided luminescence intensities either in the form of a histogram or a box and whisker plot.",
				Inputs :> {
					{
						InputName -> "intensities",
						Description -> "The intensity readings you wish to plot.",
						Widget -> Alternatives[
							Adder[Widget[Type -> Quantity, Pattern :> GreaterP[0RLU], Units->RLU]],
							Adder[Widget[Type-> Number, Pattern:>GreaterP[0] ]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the distribution(s) of intensities provided.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotAlphaScreen[alphaScreenData,secondaryVariables]", "plot"},
				Description -> "provides a graphical plot the provided luminescence intensities (in y-axis) against the values of secondary variable (in x-axis) in the form of a scatter plot.",
				Inputs :> {
					{
						InputName -> "alphaScreenData",
						Description -> "A list of the AlphaScreen data objects whose intensity readings you wish to plot in a scatter plot.",
						Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Data, AlphaScreen]]]]
					},
					{
						InputName -> "secondaryVariables",
						Description -> "A list of secondary variable whose values are plotted against the AlphaScreen intensity readings in a scatter plot.",
						Widget -> Alternatives[
							"Volume" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Microliter],
								Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
							],
							"Mass" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Milligram],
								Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
							],
							"Count" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Unit, 1 Unit],
								Units -> {1, {Unit, {Unit}}}
							],
							"Count" -> Widget[
								Type -> Number,
								Pattern :> GreaterP[0., 1.]
							],
							"Density" -> Widget[
								Type -> Quantity,
								Pattern:>GreaterEqualP[0 Gram/Milliliter],
								Units->CompoundUnit[
									{1,{Gram,{Kilogram,Gram}}},
									Alternatives[
										{-3,{Meter,{Centimeter,Meter}}},
										{-1,{Liter,{Milliliter,Liter}}}
									]
								]
							],
							"Concentration" -> Widget[
								Type -> Quantity,
								Pattern:>GreaterEqualP[0 Molar],
								Units->{1,{Molar,{Micromolar,Millimolar,Molar}}}
							],
							"VolumePercent" -> Widget[
								Type -> Quantity,
								Pattern:>RangeP[0 VolumePercent,100 VolumePercent],
								Units->{1,{VolumePercent,{VolumePercent}}}
							],
							"MassPercent" -> Widget[
								Type -> Quantity,
								Pattern:>RangeP[0 MassPercent,100 MassPercent],
								Units->{1,{MassPercent,{MassPercent}}}
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the distribution(s) of intensities provided against the secondary variables.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotAlphaScreen[intensities,secondaryVariables]", "plot"},
				Description -> "provides a graphical plot the provided luminescence intensities (in y-axis) against the values of secondary variable (in x-axis) in the form of a scatter plot.",
				Inputs :> {
					{
						InputName -> "intensities",
						Description -> "The intensity readings you wish to plot.",
						Widget -> Alternatives[
							Adder[Widget[Type -> Quantity, Pattern :> GreaterP[0RLU], Units->RLU]],
							Adder[Widget[Type-> Number, Pattern:>GreaterP[0] ]]
						]
					},
					{
						InputName -> "secondaryVariables",
						Description -> "A list of secondary variable whose values are plotted against the AlphaScreen intensity readings in a scatter plot.",
						Widget -> Alternatives[
							"Volume" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Microliter],
								Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
							],
							"Mass" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Milligram],
								Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
							],
							"Count" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Unit, 1 Unit],
								Units -> {1, {Unit, {Unit}}}
							],
							"Count" -> Widget[
								Type -> Number,
								Pattern :> GreaterP[0., 1.]
							],
							"Density" -> Widget[
								Type -> Quantity,
								Pattern:>GreaterEqualP[0 Gram/Milliliter],
								Units->CompoundUnit[
									{1,{Gram,{Kilogram,Gram}}},
									Alternatives[
										{-3,{Meter,{Centimeter,Meter}}},
										{-1,{Liter,{Milliliter,Liter}}}
									]
								]
							],
							"Concentration" -> Widget[
								Type -> Quantity,
								Pattern:>GreaterEqualP[0 Molar],
								Units->{1,{Molar,{Micromolar,Millimolar,Molar}}}
							],
							"VolumePercent" -> Widget[
								Type -> Quantity,
								Pattern:>RangeP[0 VolumePercent,100 VolumePercent],
								Units->{1,{VolumePercent,{VolumePercent}}}
							],
							"MassPercent" -> Widget[
								Type -> Quantity,
								Pattern:>RangeP[0 MassPercent,100 MassPercent],
								Units->{1,{MassPercent,{MassPercent}}}
							]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the distribution(s) of intensities provided against the secondary variables.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotFluorescenceIntensity",
			"EmeraldBarChart",
			"EmeraldHistogram",
			"EmeraldBoxWhiskerChart"
		},
		Author -> {"scicomp", "brad", "fan.wu"},
		Preview->True
	}];