(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ReviewExperiment*)


DefineUsage[ReviewExperiment,
{
	BasicDefinitions -> {
		{"ReviewExperiment[protocol]","report","builds a notebook review many aspects of the 'Protocol' that can be used for troubleshooting investigations."}
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"protocol", ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance]}], "The protocol to be investigated/reviewed."}
	},
	Output :> {
		{"report", ObjectP[Object[Report,ReviewExperiment]], "A report object containing all investigation information about this protocol, including a ReviewNotebook."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"RequestSupport",
		"Inspect",
		"OpenCloudFile"
	},
	Author -> {"robert", "alou"}
}];