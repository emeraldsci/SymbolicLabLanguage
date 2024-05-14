(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*KineticRates*)


DefineUsage[KineticRates,
{
	BasicDefinitions -> {
		{"KineticRates[Reaction[reactants,products,reactionType]]", "reaction", "takes a nucleic acid reaction, with a classified reaction type and replaces the 'reactionType' with an estimated rate parameterized from literature precedence."},
		{"KineticRates[Reaction[reactants,products,reactionTypeForward,reactionTypeBackward]]", "reaction", "takes a nucleic acid reaction with classified forward and backward reaction types and replaces the types with estimated rates parameterized from literature precedence."}
	},
	MoreInformation -> {
		"KineticRates calculates the nucleic acid reaction rates for possible nucleic acid reactions of following types: Folding/Melting, Zipping/Unzipping, Hybridization/Dissociation, StrandInvasion/DuplexInvasion and ToeholdMediatedStrandExchange/ToeholdMediatedDuplexExchange/DualToeholdMediatedDuplexExchange (the toehold-mediated process can be referred as two strands with partial or full complementarity hybridize to each other, displacing one or more pre-hybridized strands in the process, more information can be found in Object[Report,Literature,\"id:D8KAEvGxawbO\"]: Zhang, David Yu, and Georg Seelig. \"Dynamic DNA nanotechnology using strand-displacement reactions.\" Nature chemistry 3.2 (2011): 103).",
		"For the reversible reactions, the backward rate Kb is calculated based on the detailed balance method by solving the equation 'Keq==Kf/Kb' with the forward rate Kf known and the Gibbs equilibrium constant Keq of the reaction computed by the EquilibriumConstantFunction option. By default, the function calculates the equilibrium constant by solving the Gibbs free energy deltaG = deltaH - T*deltaS, resulting in Keq = e^[-(deltaH - T*deltaS)/RT] where R is the ideal gas constant in Cal/MoleKelvin, T is the temperature as in Kelvin.",
		"Rate for Folding is considered dependent on temperature and monovalent salt concentration as described by Bonnet, G., Krichevsky, O., & Libchaber, A. (1998) in Object[Report,Literature,\"id:E8zoYvNkERq5\"]: \"Kinetics of conformational fluctuations in DNA hairpin-loops.\" Proceedings of the National Academy of Sciences, 95(15), 8602-8606. The folding rate is fitted by using the kinetics data as a function of 1000/T (K^-1) and monovalent salt concentration (Molar) as described in Object[Analysis,Fit,\"id:AEqRl9Kz9YKw\"].",
		"Rate for Hybridization is dependent on monovalent salt concentration as decribed by James G. Wetmur (1991) in Object[Report,Literature,\"id:wqW9BP7kDBKV\"]: \"DNA probes: applications of the principles of nucleic acid hybridization.\" Critical reviews in biochemistry and molecular biology, 26(3-4), 227-259. In the range of interest ([Na+] >= 0.25 Molar), the hybridization rate is given by Kon = {4.35*Log10[Na+]+3.5}*10^5. When salt concentration is below 0.25 Molar, hybridization starts becoming more stringent as only perfectly matched hybrids will be stable and reactions can hardly carried out in low salt. Temperature also plays a vital role in hybridization rate as described by Chunlai Chen, et al (2007) in Object[Report,Literature,\"id:BYDOjvGNmwNr\"]: \"Influence of secondary structure on kinetics and reaction mechanism of DNA hybridization\" Nucleic acids research, 35(9), 2875-2884. Log[Kon] was fitted as a function of 1/RT (mol*K/cal) where R is the ideal gas constant, the fitted function as described in Object[Analysis,Fit,\"id:01G6nvw7veVE\"] is used to predict the hybridization rate given the temperature.",
		"Rate for ToeholdMediatedStrandExchange uses kinetic data described in Object[Report, Literature, \"id:XnlV5jmalqMZ\"] : B. M. Frezza \"Orchestration of molecular information through higher order chemical recognition.\" (2010). This data was log-normalized and fitted to compute kinetic rates as function of the activation energy normalized by the Temperature and Boltzmann factor in Object[Analysis, Fit, \"id:dORYzZJKnMd5\"] for 3' toehold and Object[Analysis, Fit, \"id:P5ZnEjdL4nkE\"] for 5' toehold.",
		"Rate for ToeholdMediatedDuplexExchange uses kinetic data described in Object[Report, Literature, \"id:XnlV5jmalqMZ\"] : B. M. Frezza \"Orchestration of molecular information through higher order chemical recognition.\" (2010).",
		"Rate for DualToeholdMediatedDuplexExchange is similar to ToeholdMediatedStrandExchange but with a different AnalyzeFit object as in Object[Analysis,Fit,\"id:mnk9jORoVr9w\"].",
		"Rate for StrandInvasion uses kinetic data described in: L. P. Reynaldo et al in Object[Report,Literature,\"id:7X104vnRe98J\"]: \"The kinetics of oligonucleotide replacements.\" J. Mol. Biol. 297 (2000): 511-520. For strand invasion mediated by the sequential displacement pathway, related kinetic data was fitted as a function of the number of displaced bonds and the temperature in Object[Analysis,Fit,\"id:Vrbp1jKDZZzx\"]. For strand invasion mediated by the dissociative pathway, related kinetic data was fitted as a function of the number of dissociated bonds and the temperature in Object[Analysis,Fit,\"id:9RdZXv1W7E9L\"].",
		"Rate for DuplexInvasion is as described in Object[Report, Literature, \"id:XnlV5jmalqMZ\"] : B. M. Frezza \"Orchestration of molecular information through higher order chemical recognition.\" (2010), signal measured was not significant. Thus the duplex invasion rate is set to be 0/Molar/Second."
	},
	Input :> {
		{"reactants", {StructureP..}, "Reactant species to simulate the reaction."},
		{"products", {StructureP..}, "Product species as a result of the reaction."},
		{"reactionType", RateTypeP, "A reaction type on which the kinetic rate depends."},
		{"reactionTypeForward", RateTypeP, "A forward reaction type on which the forward kinetic rate depends."},
		{"reactionTypeBackward", RateTypeP, "A backward reaction type on which the backward kinetic rate depends."}
	},
	Output :> {
		{"reaction", Reaction[{StructureP..},{StructureP..},(_?FirstOrderRateQ | _?SecondOrderRateQ)..], "The reaction with the kinetic rates filled in."}
	},
	SeeAlso -> {
		"SimulateKinetics",
		"ClassifyReaction"
	},
	Author -> {"scicomp", "brad"},
	Tutorials->{"Reactions and Rates"}
}];