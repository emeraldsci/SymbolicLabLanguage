(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


DefineUsage[PlotFreezeCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotFreezeCells[data]", "plot"},
				Description -> "generates a graphical representation of the freezer environmental temperature 'data' collected during an ExperimentFreezeCells with target temperature info.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "data",
							Description -> "Data object(s) from ExperimentFreezeCells.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object[Data, Temperature]]
							],
							Expandable -> False
						},
						IndexName -> "dataObject"
					]
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "Graphical representation of the data collected with target temperature profile or temperature during ExperimentFreezeCells.",
						Pattern :> Alternatives[_Legended, _TabView]
					}
				}
			},
			{
				Definition -> {"PlotFreezeCells[protocol]", "plot"},
				Description -> "generates a graphical representation of the freezer environmental temperature temperature data collected during an ExperimentFreezeCells 'protocol' with target temperature info.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "Protocol object from a completed ExperimentFreezeCells.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Protocol, FreezeCells]]
						],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "Graphical representation of the data collected with target temperature profile or temperature during ExperimentFreezeCells.",
						Pattern :> Alternatives[_Legended, _TabView]
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentFreezeCells",
			"PlotSensor"
		},
		Author -> {"scicomp", "brad", "lige.tonggu"},
		Preview -> True
	}
];