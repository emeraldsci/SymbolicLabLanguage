(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProbeConcentration*)


DefineTests[PlotProbeConcentration,{
	Example[{Basic, "Given the output from SimulateProbeSelection, the funcion plots the probe accessibility along a target, arrows represent selected top probes with their rank indicated:"},
		PlotProbeConcentration[Object[Simulation,ProbeSelection,"id:3em6ZvLD1JG7"]],
		_?ValidGraphicsQ,
		TimeConstraint->200
	],
	Example[{Basic, "The function can also work on Object[Simulation, PrimerSet] by plotting out forward primers (left arrows), reverse primers (right arrows) and Beacons (horizontal lines):"},
		PlotProbeConcentration[Object[Simulation,PrimerSet,"id:9RdZXvKxPBkK"]],
		_?ValidGraphicsQ,
		TimeConstraint->200
	],
	Example[{Options, TopProbes, "Displays the top N number of selected probes based on their correctly bound concentrations, N defaults to 10:"},
		PlotProbeConcentration[Object[Simulation,ProbeSelection,"id:zGj91a7wDxMx"], TopProbes->20],
		_?ValidGraphicsQ,
		TimeConstraint->200
	],
	Example[{Messages,"PrimersNotFound","Return an error if the ForwardPrimers or PrimerProbeSets fields in the input object are empty:"},
		PlotProbeConcentration[Object[Simulation, PrimerSet, "id:Vrbp1jG3q8zm"]],
		$Failed,
		Messages:>{Error::PrimersNotFound,Error::InvalidInput},
		TimeConstraint->200
	]
}];
