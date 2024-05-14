(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validTeamQTests*)


validTeamQTests[packet:ObjectP[Object[Team]]]:={
	NotNullFieldTest[packet, {
		Name,
		Status
	}],

	(* Every member of Administrators must also be a member of Members *)
	Test[
		"Every Administrator is also a Member:",
		Apply[ContainsAll, Download[Lookup[packet, {Members, Administrators}], Object]],
		True
	]
};



(* ::Subsection:: *)
(*validTeamFinancingQTests*)


validTeamFinancingQTests[packet:ObjectP[Object[Team,Financing]]]:={
	NotNullFieldTest[packet, {
		MaxThreads,
		MaxComputationThreads,
		MaxUsers,
		NumberOfUsers,
		DefaultMailingAddress,
		BillingAddress
	}],

	(* both fields are needed to not crash billing. Active doesnt really do much now but we dont want to run this on Historical teams *)
	If[MatchQ[Lookup[packet, Status], Active],
		RequiredTogetherTest[packet, {NextBillingCycle, CurrentPriceSchemes}],
		Nothing
	],

  Test["There must always be a team administrator:",
    Length@Lookup[packet, Administrators],
    GreaterP[0]
  ],

	Test["There must not be too many users:",
		Lookup[packet, NumberOfUsers] <= Lookup[packet,MaxUsers],
		True
	],

	Test["Administrators should all be members of the team:",
		Module[{cache, admins, members},
			{admins,members} = Download[packet, { Administrators[Object], Members[Object] }];
			AllTrue[admins, MemberQ[members, #]&]
		],
		True
	],

	Test["The DefaultMailingAddress is a member of Sites:",
		Module[{sites,defaultMailingAddress},
			{sites,defaultMailingAddress}= {Download[Lookup[packet, Sites], Object], Download[Lookup[packet, DefaultMailingAddress], Object]};
			MemberQ[sites,defaultMailingAddress]
		],
		True
	],

	Test["The BillingAddress is a member of Sites:",
		Module[{sites,billing},
			{sites,billing}= {Download[Lookup[packet, Sites], Object], Download[Lookup[packet, BillingAddress], Object]};
			MemberQ[sites,billing]
		],
		True
	],

	Test["The DefaultExperimentSite is a member of ExperimentSites:",
		Module[{sites,default},
			{sites,default}= {Download[Lookup[packet, ExperimentSites], Object], Download[Lookup[packet, DefaultExperimentSite], Object]};
			Or[
				MatchQ[default,Null]&&MatchQ[sites,Null|{}|{Null}],
				MemberQ[sites,default]
				]
		],
		True
	],

	Test["The team must have at least one notebook if not a Historical team:",
		MatchQ[Lookup[packet, NotebooksFinanced], {}] && Not[MatchQ[Lookup[packet, Status], Historical]],
		False
	],

	Test["Active team can not have more CurrentBills than CurrentPriceSchemes:",
		Or[
			!MatchQ[Lookup[packet,Status],Active],
			Length[Lookup[packet,CurrentPriceSchemes]]>=Length[Lookup[packet,CurrentBills]]
		],
		True
	],

	Test["All CurrentPriceSchemes have copacetic site with the team information:",
		Or[
			Length[Lookup[packet,CurrentPriceSchemes]]==0,
			And@@MapThread[MatchQ[#1,ObjectP[#2]]&,
				{
					Lookup[packet,CurrentPriceSchemes][[All,2]],
					Download[Lookup[packet,CurrentPriceSchemes][[All,1]],Site]
				}]
		],
		True
	],

	Test["All CurrentBills have copacetic site with the team information:",
		Or[
			Length[Lookup[packet,CurrentBills]]==0,
			And@@MapThread[MatchQ[#1,ObjectP[#2]]&,
				{
					Lookup[packet,CurrentBills][[All,2]],
					Download[Lookup[packet,CurrentBills][[All,1]],Site]
				}]
		],
		True
	],

	Test["All bills from the BillHistory have copacetic site with the team information:",
		Or[
			Length[Lookup[packet,BillingHistory]]==0,
			And@@MapThread[MatchQ[#1,ObjectP[#2]]&,
				{
					Lookup[packet,BillingHistory][[All,4]],
					Download[Lookup[packet,BillingHistory][[All,2]],Site]
				}]
		],
		True
	],

	Test["All CurrentBills and CurrentPricingSchemes are for the sites in ExperimentSites:",
		Module[{sites,priceSchemes,bills,priceSchemeSites,billSites},
			{sites,priceSchemes,bills}=Lookup[packet,{ExperimentSites,CurrentPriceSchemes,CurrentBills}];
			priceSchemeSites=Download[priceSchemes[[All,2]],Object];
			billSites=Download[bills[[All,2]],Object];
			{Complement[priceSchemeSites,Download[sites,Object]],Complement[billSites,Download[sites,Object]]}
		],
		{{},{}}
	]

	(*
	TODO: once we actually figure out how this mess is supposed to work, update VOQ to be useful (how the threads between sites work for a team)
	Test["If the team has CurrentPriceSchemes, number of threads in both should match:",
		If[!NullQ[Lookup[packet, CurrentPriceScheme]],MatchQ[Lookup[packet, MaxThreads], Download[Lookup[packet, CurrentPriceScheme], NumberOfThreads]], True],
		True
	]
	*)
};



(* ::Subsection:: *)
(*validTeamSharingQTests*)


validTeamSharingQTests[packet:ObjectP[Object[Team,Sharing]]]:={};



(* ::Subsection::Closed:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Team],validTeamQTests];
registerValidQTestFunction[Object[Team,Financing],validTeamFinancingQTests];
registerValidQTestFunction[Object[Team,Sharing],validTeamSharingQTests];
