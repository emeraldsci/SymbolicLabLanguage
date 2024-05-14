(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProbeConcentration*)


DefineUsage[PlotProbeConcentration,
{
	BasicDefinitions->{
		{
			Definition->{"PlotProbeConcentration[probeSimulation]", "plot"},
			Description->"plots probe accessibility along the target sequence in the provided 'probeSimulation' object.",
			Inputs:>{
				{
					InputName->"probeSimulation",
					Description->"An Object[Simulation, ProbeSelection] or Object[Simulation, PrimerSet] which contains binding information for selected probes and primers.",
					Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Simulation,ProbeSelection],Object[Simulation,PrimerSet]}]]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A plot showing the concentration of correctly bound probes along the target sequence.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"SimulateProbeSelection",
		"SimulateReactivity"
	},
	Guides -> {
		"Simulation",
		"NucleicAcids"
	},
	Author -> {
		"kevin.hou",
		"brad",
		"qian"
	},
	Preview->True
}];
