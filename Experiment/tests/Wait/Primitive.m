DefineTests[
  resolveWaitPrimitive,
  {
    Example[
      {Basic,"Resolve a basic wait request:"},
			resolveWaitPrimitive[
				10 Minute,
				Preparation -> Robotic, 
				Output -> {Options, Simulation, Result}
			],
      {
        {},
        SimulationP,
				AssociationMatchP[Association[Duration -> 10 Minute],AllowForeignKeys -> True]
      }
    ],
		Example[
      {Basic,"Get the resulting resolved primitive:"},
			resolveWaitPrimitive[
				10 Minute,
				Preparation -> Robotic, 
				Output -> Result
			],
      AssociationMatchP[Association[Duration -> 10 Minute],AllowForeignKeys -> True]
    ]
	}
];


DefineTests[
	Wait,
	{
		Example[
			{Basic, "Resolve a basic wait request:"},
			Experiment[{
				Wait[Duration -> 11 Minute],
				Transfer[
					Source -> Model[Sample, "Milli-Q water"],
					Destination -> Model[Container, Vessel, "50mL Tube"],
					Amount -> 20 Milliliter,
					DestinationLabel -> "my sample"
				],
				Transfer[
					Source -> Model[Sample, "Methanol"],
					Destination -> Model[Container, Vessel, "50mL Tube"],
					Amount -> 1 Milliliter,
					DestinationLabel -> "my sample 2"
				]
			}],
			ObjectP[Object[Protocol]]
		]
	}
];

