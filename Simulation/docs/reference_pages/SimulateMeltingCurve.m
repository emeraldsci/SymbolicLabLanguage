(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*SimulateMeltingCurve*)


thermoMoreInfomration = Sequence[
	"The function simulates the kinetics of a mechanism generated from an initial set of nucleic acids from HighTemperature down to LowTemperature, then back up to HighTemperature.",
	"The kinetic mechanism (as stored in the ReactionMechanism field) is generated by SimulateReactivity considering all possible reaction types in NucleicAcidReactionTypeP applied to the initial species given the initial concentrations, then the concentration of each resulting species is calculated as a function of temperature by SimulateKinetics.",
	"Thermodynamic DNA Nearest Neighbor parameters from Object[Report, Literature, \"id:kEJ9mqa1Jr7P\"]: Allawi, Hatim T., and John SantaLucia. \"MeltingCurve and NMR of internal GT mismatches in DNA.\" Biochemistry 36.34 (1997): 10581-10594.",
	"Thermodynamic RNA Nearest Neighbor parameters from Object[Report, Literature, \"id:M8n3rxYAnNkm\"]: Xia, Tianbing, et al. \"Thermodynamic parameters for an expanded nearest-neighbor model for formation of RNA duplexes with Watson-Crick base pairs.\" Biochemistry 37.42 (1998): 14719-14735."
];


DefineUsageWithCompanions[SimulateMeltingCurve,
{
	BasicDefinitions -> {
		{
			Definition->{"SimulateMeltingCurve[{{initSpecies,initConcentration}..}]", "thermodynamicCurves"},
			Description->"simulates the kinetics of a mechanism generated from a paired set or paired set list of nucleic acids oligomers 'initSpecies' with 'initConcentration' over a range of temperatures specified through options.",
			Inputs:> {
				{
					InputName -> "speciesWithConcentrationPair",
					Widget -> Adder[{
						"initSpecies" -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Object[Sample]}],PreparedSample->False],
							Widget[Type -> Expression, Pattern :> ObjectP[{Model[Sample], Object[Sample]}] | ReactionSpeciesP, PatternTooltip -> "A sequence, strand or structure like 'AAGGCC'", Size -> Line]
						],
						"initConcentration" -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Picomolar], Units -> Picomolar | Nanomolar | Micromolar | Millimolar | Molar]
					}],
					Expandable -> False,
					Description -> "Initial species of the system in the form of a sequence, strand or structure and the initial concentration of that species."
				}
			},
			Outputs:> {
				{
					OutputName -> "thermodynamicCurves",
					Pattern :> Packet | ObjectP[Object[Simulation, SimulateMeltingCurve]],
					Description -> "A Simulate Melting Curve Object containing the simulated Melting and Cooling trajectories."
				}
			}
		},
		{
			Definition->{"SimulateMeltingCurve[primerset]", "thermodynamicCurves"},
			Description->"simulates the kinetics of the molecular beacons that are part of this 'primerset'.",
			Inputs:> {
				{
					InputName -> "primerset",
					Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[PrimerSet]]],
					Expandable -> False,
					Description -> "A set of oligomer primers design to amplify a particular target in PCR."
				}
			},
			Outputs:> {
				{
					OutputName -> "thermodynamicCurves",
					Pattern :> Packet | ObjectP[Object[Simulation, SimulateMeltingCurve]],
					Description -> "A Simulate Melting Curve Object containing the simulated Melting and Cooling trajectories."
				}
			}
		}
	},
	MoreInformation -> {
		thermoMoreInfomration
	},
	Tutorials -> {

	},
	Guides -> {
		"Simulation"
	},
	SeeAlso -> {
		"SimulateKinetics",
		"PlotTrajectory"
	},
	Author -> {
		"brad"
	},
	Preview -> True
}];