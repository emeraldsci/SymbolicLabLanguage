(* ::Section:: *)
(*PlotSyringe*)

DefineUsage[PlotSyringe,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotSyringe[Syringe]", "Graphic"},
				Description -> "plots a 'Graphic' representing a syringe according to the input 'Syringe'.",
				Inputs :> {
					{
						InputName -> "Syringe",
						Description -> "A syringe object or model that is used as the basis for the syringe portion of the graphic.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]]
					}
				},
				Outputs :> {
					{
						OutputName -> "Graphic",
						Description -> "A visual representation of the syringe.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotSyringe[Syringe, Volume]", "Graphic"},
				Description -> "plots 'Graphic' according to the input 'Syringe' filled to 'Volume'.",
				Inputs :> {
					{
						InputName -> "Syringe",
						Description -> "A syringe object.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, Syringe], Object[Container, Syringe]}]]
					},
					{
						InputName -> "Volume",
						Description -> "The amount of liquid to display in the syringe.",
						Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milliliter], Units -> Alternatives[Milliliter, Liter]]
					}
				},
				Outputs :> {
					{
						OutputName -> "Graphic",
						Description -> "A visual representation of the syringe.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFillToVolume",
			"ExperimentTransfer",
			"PlotSerologicalPipette",
			"PlotGraduatedCylinder",
			"PlotObject"
		},
		Author -> {"megan.vanhorn"}
	}
];