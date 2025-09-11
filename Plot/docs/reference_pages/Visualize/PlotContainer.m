(* ::Section:: *)
(*PlotContainer*)

DefineUsage[PlotContainer,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotContainer[Container]", "Graphic"},
				Description -> "plots 'Graphic' according to the input 'Container'.",
				Inputs :> {
					{
						InputName -> "Container",
						Description -> "A container object.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]]
					}
				},
				Outputs :> {
					{
						OutputName -> "Graphic",
						Description -> "A visual representation of the container.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition -> {"PlotContainer[Container, Volume]", "Graphic"},
				Description -> "plots 'Graphic' according to the input 'Container' filled to 'Volume'.",
				Inputs :> {
					{
						InputName -> "Container",
						Description -> "A container object.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Container, Vessel], Object[Container, Vessel]}]]
					},
					{
						InputName -> "Volume",
						Description -> "The amount of liquid to display in the container.",
						Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Milliliter], Units -> Alternatives[Milliliter, Liter]]
					}
				},
				Outputs :> {
					{
						OutputName -> "Graphic",
						Description -> "A visual representation of the container.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentFillToVolume",
			"ExperimentTransfer",
			"PlotSerologicalPipette",
			"PlotContainer",
			"PlotObject"
		},
		Author -> {"lei.tian"}
	}
];