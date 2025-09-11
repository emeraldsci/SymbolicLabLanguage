DefineUsage[LookupObjectLabel,
	{
		BasicDefinitions -> {
			{"LookupObjectLabel[mySimulation, myObject]", "label", "returns the 'label' for 'myObject', if it exists in 'mySimulation'. Otherwise, returns Null."}
		},
		Input :> {
			{"mySimulation", SimulationP, "The current simulation."},
			{"myObject", ObjectP[], "The object whose label we want from the simulation."}
		},
		Output :> {
			{"label", _String | Null, "The label of the object, if it exists in the simulation."}
		},
		SeeAlso -> {"Simulation"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[StartUniqueLabelsSession,
	{
		BasicDefinitions -> {
			{"StartUniqueLabelsSession[]", "null", "stashes any existing unique label information and starts a new session."}
		},
		MoreInformation->{},
		Input :> {},
		Output :> {
			{"null", Null, "Returns Null."}
		},
		SeeAlso -> {"Simulation"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[EndUniqueLabelsSession,
	{
		BasicDefinitions -> {
			{"EndUniqueLabelsSession[]", "null", "clears the existing unique label information and revives the old label information if previous information existed and was stashed."}
		},
		MoreInformation->{},
		Input :> {},
		Output :> {
			{"null", Null, "Returns Null."}
		},
		SeeAlso -> {"Simulation"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[CreateUniqueLabel,
	{
		BasicDefinitions -> {
			{"CreateUniqueLabel[baseLabel]", "uniqueLabel", "creates a 'uniqueLabel' by appending a number (that gets incremented) to the 'baseLabel'."}
		},
		Input :> {
			{"baseLabel", _String, "The label template that should be used to create the unique label."}
		},
		Output :> {
			{"uniqueLabel", _String, "The unique label."}
		},
		SeeAlso -> {"LookupObjectLabel"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[EnterSimulation,
	{
		BasicDefinitions -> {
			{"EnterSimulation[]", "boolean", "automatically redirect all Uploads to a local simulation, subsequent Downloads will automatically query the local simulation."}
		},
		Input :> {},
		Output :> {
			{"boolean", BooleanP, "Indicates if a new simulation was successfully created."}
		},
		SeeAlso -> {"ExitSimulation"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[ExitSimulation,
	{
		BasicDefinitions -> {
			{"ExitSimulation[]", "boolean", "ends the redirecting of Uploads to a local simulation."}
		},
		Input :> {},
		Output :> {
			{"boolean", BooleanP, "Indicates if a current simulation was successfully exited."}
		},
		SeeAlso -> {"EnterSimulation"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[Simulation,
	{
		BasicDefinitions -> {
			{"Simulation[myPackets]", "simulation", "creates a 'simulation', given a list of 'myPackets'."},
			{"Simulation[myRules]", "simulation", "creates a 'simulation', given a list of 'myRules'}."}
		},
		Input :> {
			{"myPackets", {PacketP[]..}, "The list of packets to upload to our simulation."},
			{"myRules", {Packets -> {PacketP[]...}, Labels -> {(_String -> ObjectP[])..}, LabelFields -> {(_String -> _LabelField)..}}, "The packets, labels, and label fields to upload to our simulation."}
		},
		Output :> {
			{"simulation", SimulationP, "The resulting simulation."}
		},
		SeeAlso -> {"LookupObjectLabel"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];

DefineUsage[UpdateSimulation,
	{
		BasicDefinitions -> {
			{"UpdateSimulation[existingSimulation, newSimulation]", "resultingSimulation", "merges 'newSimulation' into the 'existingSimulation', creating 'resultingSimulation'."}
		},
		Input :> {
			{"existingSimulation", SimulationP, "The existing simulation that contains the state of our simulated universe."},
			{"newSimulation", SimulationP, "The new simulated packets that we want to upload into our existing simulation."}
		},
		Output :> {
			{"resultingSimulation", SimulationP, "The resulting simulation."}
		},
		SeeAlso -> {"Simulation", "LookupObjectLabel"},
		Author -> {"xu.yi", "hanming.yang", "thomas"}
	}
];