(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*SimulateMeltingCurve: Tests*)


(* ::Section:: *)
(*Unit Testing*)



(* ::Subsection:: *)
(*MeltingCurve Simulation*)

(* ::Subsubsection:: *)
(*SimulateMeltingCurve*)

DefineTestsWithCompanions[SimulateMeltingCurve,{
	Example[{Basic,"When provided with an oligomer, SimulateThemodynamics simulates the kinetics of a mechanism generated from 'initial' over a range of temperatures (defaults from 5 to 95 celsius):"},
		PlotObject[SimulateMeltingCurve[{"CTGCATGCAGTGACCAATGCAG", 1Micro Molar}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{"CTGCATGCAGTGACCAATGCAG", 1Micro Molar}] =
				SimulateMeltingCurve[{"CTGCATGCAGTGACCAATGCAG", 1Micro Molar}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Basic,"In addition to accepting one oligomer, the function can handle more than one oligomer:"},
		PlotObject[SimulateMeltingCurve[{{"TGCGTCGTGAATCCGAGGATCTAGGGC", 1Micro Molar}, {"ATCATGCTACGTACGACTACGCTC", 0.5Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{"TGCGTCGTGAATCCGAGGATCTAGGGC", 1Micro Molar}, {"ATCATGCTACGTACGACTACGCTC", 0.5Micro Molar}}] = SimulateMeltingCurve[{{"TGCGTCGTGAATCCGAGGATCTAGGGC", 1Micro Molar}, {"ATCATGCTACGTACGACTACGCTC", 0.5Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Basic,"The input oligomers can also be strands or structures:"},
		PlotObject[SimulateMeltingCurve[{{Strand[DNA["CAAATTCAAAATAGCCTTCA"]], 1 Micro Molar}, {Structure[{Strand[DNA["TGAAGGCTATTTTGAATTAAGC"]]}, {}], 0.5 Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{Strand[DNA["CAAATTCAAAATAGCCTTCA"]], 1 Micro Molar}, {Structure[{Strand[DNA["TGAAGGCTATTTTGAATTAAGC"]]}, {}], 0.5 Micro Molar}}] =
				SimulateMeltingCurve[{{Strand[DNA["CAAATTCAAAATAGCCTTCA"]], 1 Micro Molar}, {Structure[{Strand[DNA["TGAAGGCTATTTTGAATTAAGC"]]}, {}], 0.5 Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Basic,"Simulate MeltingCurve for an Object[Sample]:"},
		PlotObject[SimulateMeltingCurve[{Object[Sample, "id:lYq9jRzZKMVO"], 0.25 Micro Molar}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Object[Sample, "id:lYq9jRzZKMVO"], 0.25 Micro Molar}] =
				SimulateMeltingCurve[{Object[Sample, "id:lYq9jRzZKMVO"], 0.25 Micro Molar}, Upload->False]
		},
		TimeConstraint->1000
	],

	(* Additional *)
	Example[{Additional,"The function can handle a list of inputs with the form of {sequence, concentration}:"},
		PlotObject[SimulateMeltingCurve[{{"GCTACCAGCTGACAAGTCAATG", 1 Micro Molar}, {DNA["CATTGACTTGTCAGCTGGTAAATG"], 0.5 Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{"GCTACCAGCTGACAAGTCAATG", 1 Micro Molar}, {DNA["CATTGACTTGTCAGCTGGTAAATG"], 0.5 Micro Molar}}] =
				SimulateMeltingCurve[{{"GCTACCAGCTGACAAGTCAATG", 1 Micro Molar}, {DNA["CATTGACTTGTCAGCTGGTAAATG"], 0.5 Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Additional,"The function can handle a list of inputs with the form of {strand, concentration}:"},
		PlotObject[SimulateMeltingCurve[{{Strand[DNA["GTACGACTACGCTCTAGTCDTAC"]], 1 Micro Molar}, {Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]], 0.5 Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{Strand[DNA["GTACGACTACGCTCTAGTCDTAC"]], 1 Micro Molar}, {Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]], 0.5 Micro Molar}}] =
				SimulateMeltingCurve[{{Strand[DNA["GTACGACTACGCTCTAGTCDTAC"]], 1 Micro Molar}, {Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]], 0.5 Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Additional,"The function can handle a list of inputs with the form of {structure, concentration}:"},
		PlotObject[SimulateMeltingCurve[{{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTCTTCA"]]}, {}], 1 Micro Molar}, {Structure[{Strand[DNA["AGACGAGGTCTCCCTCAAGCTCT"]]}, {}], 0.5 Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTCTTCA"]]}, {}], 1 Micro Molar}, {Structure[{Strand[DNA["AGACGAGGTCTCCCTCAAGCTCT"]]}, {}], 0.5 Micro Molar}}] =
				SimulateMeltingCurve[{{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTCTTCA"]]}, {}], 1 Micro Molar}, {Structure[{Strand[DNA["AGACGAGGTCTCCCTCAAGCTCT"]]}, {}], 0.5 Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Additional,"Simulate a beacon folding on itself:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Additional,"Simulate a beacon binding to its reverse complement:"},
		PlotObject[SimulateMeltingCurve[{{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}, {Structure[{Strand[DNA["AATATGGAGGACAGTTAACA"]]}, {}], 1Micro Molar}}]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}, {Structure[{Strand[DNA["AATATGGAGGACAGTTAACA"]]}, {}], 1Micro Molar}}] =
				SimulateMeltingCurve[{{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar}, {Structure[{Strand[DNA["AATATGGAGGACAGTTAACA"]]}, {}], 1Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Additional, "Determine which field(s) to get:"},
		SimulateMeltingCurve[{{"CCCTTTTAAAGGGG", 1 Micro Molar}, {"AAAATTTTTGGGCCCCC", 1 Micro Molar}}][LabeledStructures],
		{Structure[{Strand[DNA["CCCTTTTAAAGGGG"]]}, {}], Structure[{Strand[DNA["AAAATTTTTGGGCCCCC"]]}, {}], Structure[{Strand[DNA["CCCTTTTAAAGGGG"]]}, {Bond[{1, 1 ;; 5}, {1, 9 ;; 13}]}], Structure[{Strand[DNA["AAAATTTTTGGGCCCCC"]], Strand[DNA["AAAATTTTTGGGCCCCC"]]}, {Bond[{1, 10 ;; 15}, {2, 10 ;; 15}]}]},
		TimeConstraint->1000
	],

	Example[{Additional, "Obtain only MeltingCurve or CoolingCurve if specified:"},
		PlotObject[SimulateMeltingCurve[{{"TGTCAGCAGAGACTT", 1 Micro Molar}, {"CTCCGCGTGTGCAGCTGCGC", 1 Micro Molar}}][MeltingCurve]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{{"TGTCAGCAGAGACTT", 1 Micro Molar}, {"CTCCGCGTGTGCAGCTGCGC", 1 Micro Molar}}] =
				SimulateMeltingCurve[{{"TGTCAGCAGAGACTT", 1 Micro Molar}, {"CTCCGCGTGTGCAGCTGCGC", 1 Micro Molar}}, Upload->False]
		},
		TimeConstraint->1000
	],

	(* Options *)

	Example[{Options, TemperatureStep, "Specify the number of of degrees the temperature changes between each kinetic run:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTC"]]},{}], 1 Micro Molar},TemperatureStep->10 Celsius]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTC"]]},{}], 1 Micro Molar},TemperatureStep->10 Celsius] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["GCTTGAGGGAGACCTCGTC"]]},{}], 1 Micro Molar},TemperatureStep->10 Celsius, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, HighTemperature, "Specify maximum temperature to ramp to and from:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["GCTACCAGCTGACAAGTCAATG"]]}, {}], 1 Micro Molar}, HighTemperature -> 75 Celsius]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["GCTACCAGCTGACAAGTCAATG"]]}, {}], 1 Micro Molar}, HighTemperature -> 75 Celsius] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["GCTACCAGCTGACAAGTCAATG"]]}, {}], 1 Micro Molar}, HighTemperature -> 75 Celsius, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, LowTemperature, "Specify minimum temperature to ramp to and from:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["CTACGGTAGTACGACTACGCTCTGG"]]}, {}], 1 Micro Molar}, LowTemperature -> 25 Celsius]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTACGGTAGTACGACTACGCTCTGG"]]}, {}], 1 Micro Molar}, LowTemperature -> 25 Celsius] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["CTACGGTAGTACGACTACGCTCTGG"]]}, {}], 1 Micro Molar}, LowTemperature -> 25 Celsius, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, TemperatureRampRate, "Specify the rate at which the temperature is ramped:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["CCCCAAGAAATCGATTCGCTAG"]]}, {}], 1 Micro Molar}, TemperatureRampRate->5 Celsius/Second]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CCCCAAGAAATCGATTCGCTAG"]]}, {}], 1 Micro Molar}, TemperatureRampRate->5 Celsius/Second] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["CCCCAAGAAATCGATTCGCTAG"]]}, {}], 1 Micro Molar}, TemperatureRampRate->5 Celsius/Second, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, EquilibrationTime, "Specify the amount of time to equilibrate the system at the min and max temperatures:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, EquilibrationTime->2Minute]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, EquilibrationTime->2Minute] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, EquilibrationTime->2Minute, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, StepEquilibriumTime, "Specify the amount of time to equilibrate the system after each temperature step:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["TGGGCTGTCGACAAACTCAGGAGACCTTCC"]]}, {}], 1 Micro Molar}, StepEquilibriumTime->30Second]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["TGGGCTGTCGACAAACTCAGGAGACCTTCC"]]}, {}], 1 Micro Molar}, StepEquilibriumTime->30Second] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["TGGGCTGTCGACAAACTCAGGAGACCTTCC"]]}, {}], 1 Micro Molar}, StepEquilibriumTime->30Second, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, Method, "If Discrete, the function simulates discrete temperature steps with equilibrium time at each step:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Discrete]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Discrete] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Discrete, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, Method, "If Continuous, continuous temperature changes without equilibrium time at each step is simulated:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Continuous]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Continuous] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Continuous, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, Method, "If 'StepEquilibriumTime' is 0, Continuous temperature change is simulated. Otherwise Discrete temperature change is simulated:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Automatic, StepEquilibriumTime->0 Minute]],
		_?ValidGraphicsQ,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Automatic, StepEquilibriumTime->0 Minute] =
				SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], 1Micro Molar}, Method->Automatic, StepEquilibriumTime->0 Minute, Upload->False]
		},
		TimeConstraint->1000
	],

	Example[{Options, TrackedSpecies, "TrackedSpecies can further specify a subset of species to be returned:"},
		SimulateMeltingCurve[{{"CCCTTTTAAAGGGG", 1 Micro Molar}, {"AAAATTTTTGGGCCCCC", 1 Micro Molar}}, TrackedSpecies -> {MaxPair, MaxFold}][LabeledStructures],
		{Structure[{Strand[DNA["AAAATTTTTGGGCCCCC"]], Strand[DNA["AAAATTTTTGGGCCCCC"]]}, {Bond[{1, 10 ;; 15}, {2, 10 ;; 15}]}], Structure[{Strand[DNA["CCCTTTTAAAGGGG"]]}, {Bond[{1, 1 ;; 5}, {1, 9 ;; 13}]}]},
		TimeConstraint->1000
	],

	Example[{Options, Template, "Inherit options from existing Object[Simulation,MeltingCurve] object reference:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID, ResolvedOptions]]],
		_?ValidGraphicsQ,
		TimeConstraint->300,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID, ResolvedOptions]] = SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID, ResolvedOptions], Upload->False]
		},
		SetUp :> (
			theTemplateObject =
				Upload[<|Type->Object[Simulation, MeltingCurve], UnresolvedOptions->{}, ResolvedOptions->{LowTemperature -> Quantity[5, "DegreesCelsius"], HighTemperature -> Quantity[80, "DegreesCelsius"], TemperatureRampRate -> Quantity[1, ("DegreesCelsius")/("Seconds")], EquilibrationTime -> Quantity[2, "Minutes"], Method -> Discrete, TemperatureStep -> Automatic, StepEquilibriumTime -> Quantity[1, "Minutes"], TrackedSpecies -> {Initial, MaxFold, MaxPair}, Template -> Null, Output -> Result, Upload -> True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Example[{Options, Template, "Inherit options from existing Object[Simulation,MeltingCurve] object:"},
		PlotObject[SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID]]],
		_?ValidGraphicsQ,
		TimeConstraint->300,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID]] = SimulateMeltingCurve[{Structure[{Strand[DNA["GAAATGTATCGAGATTAGAACAC"]]}, {}], 1 Micro Molar}, Template->Object[Simulation, MeltingCurve, theTemplateObjectID], Upload->False]
		},
		SetUp :> (
			theTemplateObject =
				Upload[<|Type->Object[Simulation, MeltingCurve], UnresolvedOptions->{}, ResolvedOptions->{LowTemperature -> Quantity[5, "DegreesCelsius"], HighTemperature -> Quantity[80, "DegreesCelsius"], TemperatureRampRate -> Quantity[1, ("DegreesCelsius")/("Seconds")], EquilibrationTime -> Quantity[2, "Minutes"], Method -> Discrete, TemperatureStep -> Automatic, StepEquilibriumTime -> Quantity[1, "Minutes"], TrackedSpecies -> {Initial, MaxFold, MaxPair}, Template -> Null, Output -> Result, Upload -> True}, DeveloperObject->True|>];
			theTemplateObjectID = theTemplateObject[ID];
		),
		TearDown :> (
			If[DatabaseMemberQ[theTemplateObject], EraseObject[theTemplateObject, Force->True, Verbose->False]];
		)
	],

	Test["Output option preview with primerset shows zoomable plots:",
		SimulateMeltingCurve[Model[PrimerSet, "test primer set model"], Output->Preview],
		Grid[{{_DynamicModule ..}}],
		TimeConstraint->1000
	],

	Test["Output option preview shows zoomable MeltingCurve for an Object[Sample]:",
		SimulateMeltingCurve[{Object[Sample, "id:lYq9jRzZKMVO"], 0.25 Micro Molar}, Output->Preview],
		_DynamicModule,
		TimeConstraint->1000
	],

	Example[{Messages,"InvalidTemperature","Return Failed if the input HighTemperature is lower than the LowTemperature:"},
		SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Micro Molar},HighTemperature->90 Celsius, LowTemperature->120 Celsius],
		$Failed,
		Stubs :> {
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Micro Molar},HighTemperature->90 Celsius, LowTemperature->120 Celsius] =
			SimulateMeltingCurve[{Structure[{Strand[DNA["CTGCATGCAGTGACCAATGCAG"]]}, {}], Micro Molar},HighTemperature->90 Celsius, LowTemperature->120 Celsius, Upload->False]
		},
		Messages:>{Message[Error::InvalidTemperature, 90 Celsius, 120 Celsius],Message[Error::InvalidOption]}
	],

	Test["Insert new object:",
		SimulateMeltingCurve[{{"TGCGTCGTGAATCCGAGGATCTAGGGC", 1Micro Molar}, {"ATCATGCTACGTACGACTACGCTC", 0.5Micro Molar}},TemperatureStep->10 Celsius, Upload->True],
		ObjectReferenceP[Object[Simulation, MeltingCurve]],
		TimeConstraint -> 1000,
		Stubs :> {Print[_] := Null}
	],

	Test["UnresolvedOptions invalid or incorrect options result in failed simulation:",
		SimulateMeltingCurve[
				{Structure[{Strand[DNA["TGTTAACTGTCCTCCATATTTAACA"]]}, {}], 1Micro Molar},Upload->False,
				EquilibrationTime-> -10 Second,StepEquilibriumTime->1Second,LowTemperature->25Celsius,
				HighTemperature->75Celsius,TemperatureStep->10Celsius,TemperatureRampRate->2Celsius/Second,
				TrackedSpecies->{Initial,MaxFold}
			],
		$Failed,
		Messages:>Message[Error::Pattern],
		TimeConstraint->1000
	]
},

	SetUp :> ($CreatedObjects = {};),
	TearDown :> (
		EraseObject[Pick[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]],
			Force -> True, Verbose -> False];
		Unset[$CreatedObjects];
	)
];




(* ::Section:: *)
(*End Test Package*)
