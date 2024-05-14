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