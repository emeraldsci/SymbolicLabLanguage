(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentVapro5600Training*)

DefineUsage[ExperimentVapro5600Training,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentVapro5600Training[operator]","Protocol"},
				Description->"creates a Vapro5600Training 'Protocol' which verifies that 'operator' can achieve a set repeatability.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"operator",
							Description->"The operator to assess.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[User,Emerald],Object[User,Emerald]}]
							],
							Expandable->False
						},
						IndexName->"operator"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object(s) describing how to run the Vapro5600Training protocol.",
						Pattern:>ListableP[ObjectP[Object[Protocol,Vapro5600Training]]]
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"ExperimentMeasureOsmolality"
		},
		Author->{"david.ascough", "dirk.schild"}
	}
];