(* ::Package:: *)

(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*indexMatchingOptions*)

DefineTests[indexMatchingOptions,
	{
		Example[{Basic, "Get the options that are index matching to the input samples for an experiment function:"},
			indexMatchingOptions[ExperimentHPLC],
			(* this is just an option I'm confident won't ever change and not be in HPLC anymore so I figure this is slightly better than just {__Symbol} *)
			_?(MemberQ[#, InjectionVolume]&)
		],
		Example[{Basic, "Get the options index matching to a different option:"},
			indexMatchingOptions[ExperimentHPLC, Standard],
			(* same as above, HPLC having index matching Standard options with a corresponding StandardInjectionVolume feels like it won't ever change *)
			_?(MemberQ[#, StandardInjectionVolume]&)
		],
		Example[{Additional, "Specifying as a string is fine too:"},
			indexMatchingOptions[ExperimentHPLC, "Standard"],
			(* same as above, HPLC having index matching Standard options with a corresponding StandardInjectionVolume feels like it won't ever change *)
			_?(MemberQ[#, StandardInjectionVolume]&)
		],
		Example[{Additional, "If the specified option doesn't even exist, return an empty list:"},
			indexMatchingOptions[PickList, Standard],
			(* PickList will probably never have any options, and if it does get some, it won't be Standard*)
			{}
		],
		Example[{Additional, "If nothing is index matching to a given option, then return an empty list:"},
			{
				indexMatchingOptions[ExperimentNMR, SolventVolume],
				MemberQ[Keys[SafeOptions[ExperimentNMR]], SolventVolume]
			},
			(* NMR will always have a SolventVolume option that is index matching, but it's not an index matching parent:*)
			{{}, True}
		]
	}
];