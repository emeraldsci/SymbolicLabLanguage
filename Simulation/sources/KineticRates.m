(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Kinetic Simulation*)


(* ::Subsubsection::Closed:: *)
(*evaluateUserRateFuction*)


(* Evaluate user-specified pure function for any Rate Model *)

evaluateUserRateFuction::InconsistentNumberOfReactants="Non consistent number of reactants: `1`";
evaluateUserRateFuction::NegativeRateEvaluation="User-specified rate function evaluated is negative: `1`";
evaluateUserRateFuction::InconsistentRateUnits="User-specified rate units (`1`) is non-consistent with number of reactants: `2`";
evaluateUserRateFuction::InvalidRateFunction="User-specified rate function: `1`";

evaluateUserRateFuction[rateFunctionInput:_Function|QuantityFunctionP[]|_?QuantityQ, reactants_, products_, ops_] := Module[

	{rateUnitsInferred,rateUnits,rateFunction,rateFunctionEvaluated,rateFunctionResolved,MonoSaltConc,DiSaltConc},

	(* Find rate units (first/second order) - otherwise, error message and return $Failed *)
	rateUnitsInferred = Switch[ Length[reactants],
		1, 1/Second,
		2, 1/Second/Molar,
		_, Message[evaluateUserRateFuction::InconsistentNumberOfReactants,Length[reactants]]; $Failed
	];

	(* determine input function: QuantityFunction or Function *)
	{rateUnits,rateFunction} = Switch[rateFunctionInput,
		QuantityFunctionP[], {Last[rateFunctionInput], First[rateFunctionInput]},
		_Function, {{}, rateFunctionInput},
		_?QuantityQ, {rateFunctionInput, Function[{},Evaluate[QuantityMagnitude[rateFunctionInput]]]},
		_, Message[evaluateUserRateFuction::InvalidRateFunction,rateFunctionInput]; $Failed
	];

	(* check rate units consistency *)
	If[MatchQ[rateUnits,{}],Nothing,
		If[UnitsQ[rateUnits,rateUnitsInferred],Nothing,
			Message[evaluateUserRateFuction::InconsistentRateUnits,rateUnits,Length[reactants]]; $Failed]
	];

	(* evaluate Temperature, Monovalent and Divalent salt concentrations on user-specified function - this order is assumed by definition *)
	MonoSaltConc = Switch[Lookup[ops,MonovalentSaltConcentration],
						Automatic, 0.05, (* from default thermo parameters in resolveSaltConcentrationOptions *)
						_, Unitless[Lookup[ops,MonovalentSaltConcentration],Molar]
					];

	DiSaltConc = Switch[Lookup[ops,DivalentSaltConcentration],
					Automatic, 0.0, (* from default thermo parameters in resolveSaltConcentrationOptions *)
					_, Unitless[Lookup[ops,DivalentSaltConcentration],Molar]
				];


	rateFunctionEvaluated = rateFunction[
		Unitless[Lookup[ops,Temperature],Kelvin],
		MonoSaltConc,
		DiSaltConc
	];

	(* check if the rate evaluated is non-negative. In case it's a non-numeric expression, then do not evaluate *)
	rateFunctionResolved = Which[
		MatchQ[rateFunctionEvaluated,_Symbol], rateFunctionEvaluated,
		Less[rateFunctionEvaluated,0], Message[evaluateUserRateFuction::NegativeRateEvaluation,rateFunctionEvaluated]; $Failed,
		GreaterEqual[rateFunctionEvaluated,0], N[rateFunctionEvaluated]
	]


];


(* ::Subsubsection::Closed:: *)
(*evaluateInputSpecies*)


evaluateInputSpecies::InvalidNumberSpecies="Number of user-specified species is not consistent with kinetic rate function.";

(* supervise exact number of reactants & products *)
evaluateInputSpecies[reactants_, products_, numberReactants_Integer, numberProducts_Integer] := If[
	Length[reactants]==numberReactants && Length[products]==numberProducts,
	True,
	Message[evaluateInputSpecies::InvalidNumberSpecies]; False
];


(* ::Subsubsection::Closed:: *)
(*equilibriumConstantForRates*)


(* Simulate equilibrium via Detail Balance *)

equilibriumConstantForRates[reactants_,products_,reactionType_,temperature_,monovalentSaltConcentration_,divalentSaltConcentration_,bufferModel_] := Module[

	{expressionEquilibriumConstant,entropy,enthalpy,equilibriumConstant},

	expressionEquilibriumConstant = Simulation`Private`equilibriumConstantExpressionUnitlessHS;

	entropy = Unitless[
				SimulateEntropy[
						Reaction[Flatten[{reactants}],Flatten[{products}],reactionType],
						MonovalentSaltConcentration -> monovalentSaltConcentration,
						DivalentSaltConcentration -> divalentSaltConcentration,
						BufferModel -> bufferModel,
						Upload -> False
				][Entropy],
				Calorie/Kelvin/Mole];

	enthalpy = Unitless[SimulateEnthalpy[Reaction[Flatten[{reactants}],Flatten[{products}],reactionType], Upload -> False][Enthalpy],Calorie/Mole];

	(* evalute expression using entropy and enthalpy *)
	equilibriumConstant = expressionEquilibriumConstant /. {\[CapitalDelta]H->enthalpy,\[CapitalDelta]S->entropy,T->Unitless[temperature,Kelvin]}

];


(* ::Subsubsection::Closed:: *)
(*extractToeHoldDomain*)


(* toehold mediated strand exchange *)
extractToeHoldDomain[{react1_, react2_}, {prod1_, prod2_}, Strand]/;MemberQ[{react1, react2}, _?(#[Bonds]==={}&)]:= Module[
	{react1New, react2New, prod1New, prod2New, splitFunc, combReact, combProd, origStructReact, origStructProd, split2BondMapping = <||>, split2InitMapping = <||>, toeholdIdxReact, toeholdIdxProd, prevBond, currBond, extended},

	(* unify input order *)
	{react1New, react2New} = If[react1[Bonds]==={}, {react2, react1}, {react1, react2}];
	{prod1New, prod2New} = If[prod1[Bonds]==={}, {prod2, prod1}, {prod1, prod2}];

	(* identify which strand in reactant1 binds to the toehold *)
	splitFunc = First/@Last/@(postMeltOneLevel/@Simulation`Private`meltOneLevel[#, True])&;
	{combReact, combProd} = {Tuples[{splitFunc[react1New], {react2New}}], Tuples[{splitFunc[prod1New], {prod2New}}]};

	{origStructReact, origStructProd} = First/@Flatten[Select[Tuples[{combReact, combProd}], Sort[Flatten[First[#]]]===Sort[Flatten[Last[#]]]&], 1];

	(* identify 3p or 5p, and the toehold length *)
	Table[
		With[{allSplit = postMeltOneLevel/@Simulation`Private`meltOneLevel[in, True]},
			AssociateTo[split2BondMapping, Thread[First/@Last/@allSplit -> Last/@Last/@allSplit]];
			AssociateTo[split2InitMapping, Thread[First/@Last/@allSplit -> ConstantArray[in, Length[allSplit]]]]
		],
		{in, {react1New, prod1New}}
	];

	verifyToehold[{origStructReact, origStructProd}, split2BondMapping, split2InitMapping, Strand][[1;;2]]

];

extractToeHoldDomain[{react1_, react2_}, {prod1_, prod2_}, Strand]:= Module[
	{beforeMapping, afterMapping, strandMappingRules, bondChanges, reactionStrands, reactIdx, prodInx, reactBonds, prodBonds, reactsActual, prodsActual},

	{{beforeMapping, afterMapping}, strandMappingRules} = NucleicAcids`Private`strandMapping[{react1, react2}, {prod1, prod2}];

	bondChanges = Cases[
		Map[
			NucleicAcids`Private`bondChange[beforeMapping[#[[2]]], afterMapping[#[[1]]], strandMappingRules, Reverse /@ strandMappingRules]&,
			strandMappingRules
		],
		Except[{_, {}, {}}]
	];

	{reactionStrands, reactIdx, prodInx} = {First/@First/@bondChanges, #[[2]]&/@First/@bondChanges, Last/@First/@bondChanges};
	{reactBonds, prodBonds} = Sort@DeleteDuplicates[Flatten[Rest/@bondChanges]];

	reactsActual = SplitStructure[Structure[reactionStrands, {reactBonds/.Thread[reactIdx->{1,2,3}]}]];
	prodsActual = SplitStructure[Structure[reactionStrands, {prodBonds/.Thread[prodInx->{1,2,3}]}]];

	extractToeHoldDomain[reactsActual, prodsActual, Strand][[1;;2]]

];



(* toehold mediated duplex exchange *)
extractToeHoldDomain[{react1_, react2_}, {prod1_, prod2_}, Duplex]:= Module[
	{splitFunc, combReact, combProd, origStructReact, origStructProd, allPossibleContainsToehold, split2BondMapping = <||>, split2InitMapping = <||>, possibleToehold},

	(* identify which strand in reactant1 binds to the toehold *)
	splitFunc = First/@Last/@(postMeltOneLevel/@Simulation`Private`meltOneLevel[#, True])&;
	{combReact, combProd} = {Tuples[{splitFunc[react1], splitFunc[react2]}], Tuples[{splitFunc[prod1], splitFunc[prod2]}]};

	{origStructReact, origStructProd} = Flatten[Select[Tuples[{combReact, combProd}], Sort[Flatten[First[#]]]===Sort[Flatten[Last[#]]]&], 1];

	(* identify which reactant contains toehold, note that the toehold part is unbounded in reactant and is totally bounded in product*)
	(* assume origStructReact = {A, B},  origStructProd = {C, D}, toehold region must lie in (A,C), (A,D), (B,C) or (B,D), only one out of four possibilities would exist *)
	allPossibleContainsToehold = Tuples[{origStructReact, origStructProd}];

	Table[
		With[{allSplit = postMeltOneLevel/@Simulation`Private`meltOneLevel[in, True]},
			AssociateTo[split2BondMapping, Thread[First/@Last/@allSplit -> Last/@Last/@allSplit]];
			AssociateTo[split2InitMapping, Thread[First/@Last/@allSplit -> ConstantArray[in, Length[allSplit]]]]
		],
		{in, {react1, react2, prod1, prod2}}
	];

	possibleToehold = verifyToehold[#, split2BondMapping, split2InitMapping, Duplex]&/@allPossibleContainsToehold;

	Flatten[DeleteDuplicates[possibleToehold]][[1;;2]]


];


(* make sure the splitted structure order matches the bond indices *)
postMeltOneLevel[original_ -> {{split_}, {}}]:= original -> {{split}, {}};

postMeltOneLevel[original_ -> {{split1_, split2_}, Bond[{i_, span1_}, {j_, span2_}]}]:= Module[
	{origStrands},

	origStrands = original[Strands];

	If[MemberQ[split1[Strands], origStrands[[i]]] && MemberQ[split2[Strands], origStrands[[j]]],
		original -> {{split1, split2}, Bond[{i, span1}, {j, span2}]},
		original -> {{split2, split1}, Bond[{i, span1}, {j, span2}]}
	]

];


verifyToehold[{splitReact_, splitProd_}, split2BondMapping_, split2InitMapping_, strandOrduplex_]:= Module[
	{common, commonIndices},

	common = First[Intersection[splitReact, splitProd]];

	commonIndices = Flatten/@Tuples[{Position[splitReact, common], Position[splitProd, common]}];

	Table[
		veryfyToeholdHelper[{splitReact, splitProd}, split2BondMapping, split2InitMapping, strandOrduplex, Sequence@@index],
		{index, commonIndices}
	]//Flatten

];


veryfyToeholdHelper[{splitReact_, splitProd_}, split2BondMapping_, split2InitMapping_, strandOrduplex_, idxReact_, idxProd_]:= Module[
	{boundReact, boundProd, unboundReactPos, boundProdPos, toeholdInd, toeholdType, prodStrands, toeholdStrand, idxProdBind, BoundReactBind, toeholdBindIndex},

	(* retrieve the bounded index in original structure *)
	boundReact = split2BondMapping[splitReact][[idxReact]][[2]];
	boundProd = split2BondMapping[splitProd][[idxProd]][[2]];

	unboundReactPos = Complement[
						Range[1, StrandLength[split2InitMapping[splitReact][Strands][[split2BondMapping[splitReact][[idxReact]][[1]]]]]],
						Range@@boundReact
					];

	boundProdPos = Range@@boundProd;

	toeholdInd = Switch[strandOrduplex,
					Strand,
						Intersection[unboundReactPos, boundProdPos],
					Duplex,
						If[unboundReactPos=!={} && SubsetQ[boundProdPos, unboundReactPos],
							Intersection[unboundReactPos, boundProdPos],
							{}
						]
				];

	If[toeholdInd==={}, Return[{}]];

	(* for duplex exchange case, double check the toehold part to avoid identical strands issue *)
	If[strandOrduplex===Duplex,
		prodStrands = split2InitMapping[splitProd][Strands];
		toeholdStrand = prodStrands[[split2BondMapping[splitProd][[idxProd]][[1]]]];

		idxProdBind = If[idxProd==1,2,1];
		BoundReactBind = Values[KeySelect[split2BondMapping, MemberQ[#, splitProd[[If[idxProd==1,2,1]]]] && !MatchQ[#, {splitReact, splitProd}]&]];
		toeholdBindIndex = (Range@@split2BondMapping[splitProd][[If[idxProd==1,2,1]]][[2]])[[
						StrandLength[toeholdStrand]-Last@toeholdInd+1;;StrandLength[toeholdStrand]-First@toeholdInd+1
					]];

		If[Intersection[Range@@(First[BoundReactBind][[idxProdBind]][[2]]), toeholdBindIndex]=!={}, Return[{}]]
	];


	(* identify toehold type *)
	toeholdType = Switch[strandOrduplex,
					Strand,
						If[MemberQ[Range@@boundReact, Last[toeholdInd]+1],
							"5p",
							"3p"
						],
					Duplex,
						If[MemberQ[toeholdInd, 1],
							"3p",
							"5p"
						]
				];

	{toeholdType, Length[toeholdInd]}

];


(* ::Subsubsection::Closed:: *)
(*cofactors fitted Boltzmann Constant*)


(* cofactors for Arrhenius equation fitted from experimental data from P. Zhao et al "Predicting secondary structural folding kinetics for nucleic acids" (2010) 98: 1617-1625 *)
cofactorsBoltzmann[basePairs_String] := Which[
	MatchQ[basePairs,"AU" | "UA"], 6.6*10^12/Second,
	MatchQ[basePairs,"CG" | "GC"], 6.6*10^13/Second
];


(* ::Subsubsection::Closed:: *)
(*averageMeltingStabilityBasePairStack*)


averageMeltingStabilityBasePairStack[Gp_] := -1.28 KilocaloriePerMole/BasePair;


(* ::Subsubsection:: *)
(*KineticRates*)

(** NOTE: Temporarily used None to be compatible with hybridizationRate function **)
DefineOptions[KineticRates,
	Options:>{
		{KineticsModel -> Automatic, Automatic | None | ObjectP[Model[Physics,Kinetics]], "The model that is used for extracting the kinetic parameters. Automatic uses the Kinetics field of the public model physics oligomer object."},
		{FoldingRate->1.4*10^4 /Second, GreaterEqualP[0/Second] | _Function, "Folding rate is defaulted to be 10^4 /Second, or it can be input as a pure function of the reaction."},
		{HybridizationRate->Automatic, Automatic | GreaterEqualP[0/Molar/Second] | _Function, "Hybridization rate is defaulted to be 2.1*10^6 /Molar/Second, or it can be input as a pure function of the reaction."},
		{EquilibriumConstantFunction->SimulateEquilibriumConstant, SimulateEquilibriumConstant | _Function, "For reversible reactions, this option provides the way to compute the Equilibrium Constant in detailed balance method. Default approach is to call SimulateEquilibriumConstant, or it can be input as a pure function of the reaction."},
		{Temperature->37Celsius,GreaterP[0 Kelvin] | _Symbol | Null,"Temperature at which to run the simulation. Temperature will affect the kinetic rates of the reactions."},
		{MonovalentSaltConcentration->Automatic,Automatic | GreaterEqualP[0*Molar],"Concentration of monovalent salt ions (e.g. Na, K) in sample buffer. Automatic first attempts to pull value from BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0.05 Molar."},
		{DivalentSaltConcentration->Automatic,Automatic | GreaterEqualP[0*Molar],"Concentration of divalent salt ions (e.g. Mg) in sample buffer. Automatic first attempts to pull value from BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0 Molar."},
		{BufferModel->Null, Null | ObjectReferenceP[{Model[Sample, StockSolution], Object[Sample], Model[Sample]}],"Model describing sample buffer. Salt concentrations are computed from chemical formula of this model. This option is overridden by MonovalentSaltConcentration and DivalentSaltConcentration options if either of them are explicitly specified."}
	}
];


KineticRates::UnrecognizedRateType = "Reaction types Unchanged and Unknown are unrecognized for calculating a corresponding rate. Please make sure the reaction type falls in Folding|Melting|Zipping|Unzipping|DuplexInvasion|StrandInvasion|Hybridization|Dissociation|ToeholdMediatedStrandExchange|ToeholdMediatedDuplexExchange|DualToeholdMediatedDuplexExchange.";
KineticRates::UnmatchingReaction = "The input reaction does not match the given reaction type. Please make sure the input reaction is consistent with the reaction type.";
KineticRates::LowConcentration = "The input salt concentration is too low (<0.01 Molar) for the equation to accurately predict. Please increase the corresponding salt concentration to be greater than 0.01 Molar.";
KineticRates::Extrapolated = "The equations used to calculate the rate of hybridization were parameterized using monovalent salt concentrations greater than or equal to 0.25 Molar, so rate constants extrapolated from these equations must be employed.  Please take note that these predictions, while still reasonable, will likely be less reliable than interpolated rate constants at higher salt concentrations.";
Error::InvalidKineticsModel="The option KineticsModel does not match the correct pattern. Please check if the fields ForwardHybridization, StrandExchange, DuplexExchange, DualToeHoldStrandExchange are populated and with the correct units.";
Warning::SwitchedKineticsModel="The kinetic parameters of the polymer `1` is not available. The parameters of DNA will be used instead.";

KineticRates[Reaction[reactants:{StructureP..}, products:{StructureP..}, reactionType:RateTypeP], ops:OptionsPattern[]]:= Module[
	{
		safeOps, reactionList, reactantsRes, productsRes, resRate,
		hybridizationRateValue,resolvedHybridizationRate,resolvedOptions,kineticsModelBase,modelOligomerKinetics,kineticsModel,
		reactantsType,productsType
	},

	(* resolve options *)
	safeOps = SafeOptions[KineticRates, ToList[ops]];

	(* check if the salt concentration is too low*)
	If[(MonovalentSaltConcentration/.safeOps) <0.01 Molar || (DivalentSaltConcentration/.safeOps)<0.01 Molar, Message[KineticRates::LowConcentration]; Return[$Failed]];

	(* resolve the input reaction *)
	reactionList = resolveReaction[reactants, products, {reactionType}];

	(* The reactants first sequence polymer type *)
	reactantsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@reactants;

	(* The products first sequence polymer type *)
	productsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@products;

	(* Warn that the kinetic parameters of DNA will be used *)
	If[!MatchQ[reactantsType,{DNA..}] || !MatchQ[productsType,{DNA..}],
		Message[Warning::SwitchedKineticsModel,{reactantsType,productsType}]
	];

	(* <<< Resolving the KineticsModel >>> *)

	(* The base KineticsModel provided in the option *)
	kineticsModelBase=Lookup[safeOps,KineticsModel];

	(* The Kinetics field in the model oligomer *)
	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	modelOligomerKinetics=Quiet[Download[Model[Physics,Oligomer,"DNA"],Kinetics]];

	kineticsModel=Which[
		(* If None, keep None and will be taken care of in lookupModelKinetics *)
		MatchQ[kineticsModelBase,None],
		None,

		(* If Automatic use the Kinetics field in the model oligomer *)
		(MatchQ[kineticsModelBase,Automatic] && !MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		modelOligomerKinetics,

		(* If Automatic and there is no Kinetics field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[kineticsModelBase,Automatic] && MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		None,

		(* If not Automatic and the model does not match the valid pattern for KineticsModel, throw an error *)
		(!MatchQ[kineticsModelBase,Automatic] && !Physics`Private`validKineticsModelQ[kineticsModelBase]),
		(Message[Error::InvalidKineticsModel];Message[Error::InvalidOption,KineticsModel];Null),

		(* If not Automatic and the model does match the valid pattern for KineticsModel, use the model provided *)
		True,
		kineticsModelBase
	];

	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	(* The hybridization rate selected at start *)
	hybridizationRateValue=Lookup[safeOps,HybridizationRate];

	(* Resolve Hybridization Rate *)
	resolvedHybridizationRate=
		Switch[hybridizationRateValue,

			(* If Automatic, take the value from model physics kinetics *)
			(** TODO: the units are not matching with the one from the model physics object **)
			(** TODO: generalize to other polymers in the future **)
			Automatic,
			Unitless[Physics`Private`lookupModelKinetics[DNA,ForwardHybridization,KineticsModel->kineticsModel]]/(Molar*Second),

			(* Everything else, takes it from the option default value *)
			_,
			hybridizationRateValue

		];

	(* The resolved options taking the reolved hybridization rate into account *)
	resolvedOptions=ReplaceRule[safeOps,HybridizationRate->resolvedHybridizationRate];

	If[MatchQ[reactionList, $Failed], Return[$Failed]];
	{reactantsRes, productsRes} = Most[List@@First[reactionList]];

	(* call the corresponding rate function *)
	resRate = kineticRates[First@reactionList, reactionType, resolvedOptions];
	(* resRate = kineticRates[First@reactionList, reactionType, safeOps]; *)

	Reaction[reactantsRes, productsRes, resRate]

];


KineticRates[Reaction[reactants:{StructureP..}, products:{StructureP..}, reactionTypeForward:RateTypeP, reactionTypeBackward:RateTypeP], ops:OptionsPattern[]]:= Module[
	{
		safeOps, reactionList, reactantsRes, productsRes, resRateForward, resRateBackward,
		hybridizationRateValue,resolvedHybridizationRate,resolvedOptions,kineticsModelBase,modelOligomerKinetics,kineticsModel,
		reactantsType,productsType
	},

	(* resolve options *)
	safeOps = SafeOptions[KineticRates, ToList[ops]];

	(* check if the salt concentration is too low*)
	If[(MonovalentSaltConcentration/.safeOps) <0.01 Molar || (DivalentSaltConcentration/.safeOps)<0.01 Molar, Message[KineticRates::LowConcentration]; Return[$Failed]];

	(* resolve the input reaction *)
	reactionList = resolveReaction[reactants, products, {reactionTypeForward, reactionTypeBackward}];

	(* The reactants first sequence polymer type *)
	reactantsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@reactants;

	(* The products first sequence polymer type *)
	productsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@products;

	(* Warn that the kinetic parameters of DNA will be used *)
	If[!MatchQ[reactantsType,{DNA..}] || !MatchQ[productsType,{DNA..}],
		Message[Warning::SwitchedKineticsModel,{reactantsType,productsType}]
	];

	(* <<< Resolving the KineticsModel >>> *)

	(* The base KineticsModel provided in the option *)
	kineticsModelBase=Lookup[safeOps,KineticsModel];

	(* The Kinetics field in the model oligomer *)
	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	modelOligomerKinetics=Quiet[Download[Model[Physics,Oligomer,"DNA"],Kinetics]];

	kineticsModel=Which[
		(* If None, keep None and will be taken care of in lookupModelKinetics *)
		MatchQ[kineticsModelBase,None],
		None,

		(* If Automatic use the Kinetics field in the model oligomer *)
		(MatchQ[kineticsModelBase,Automatic] && !MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		modelOligomerKinetics,

		(* If Automatic and there is no Kinetics field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[kineticsModelBase,Automatic] && MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		None,

		(* If not Automatic and the model does not match the valid pattern for KineticsModel, throw an error *)
		(!MatchQ[kineticsModelBase,Automatic] && !Physics`Private`validKineticsModelQ[kineticsModelBase]),
		(Message[Error::InvalidKineticsModel];Message[Error::InvalidOption,KineticsModel];Null),

		(* If not Automatic and the model does match the valid pattern for KineticsModel, use the model provided *)
		True,
		kineticsModelBase
	];

	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	(* The hybridization rate selected at start *)
	hybridizationRateValue=Lookup[safeOps,HybridizationRate];

	(* Resolve Hybridization Rate *)
	resolvedHybridizationRate=
		Switch[hybridizationRateValue,

			(* If Automatic, take the value from model physics kinetics *)
			Automatic,
			Unitless[Physics`Private`lookupModelKinetics[DNA,ForwardHybridization,KineticsModel->kineticsModel]]/(Molar*Second),

			(* Everything else, takes it from the option default value *)
			_,
			hybridizationRateValue

		];

	(* The resolved options taking the reolved hybridization rate into account *)
	resolvedOptions=ReplaceRule[safeOps,HybridizationRate->resolvedHybridizationRate];

	If[MatchQ[reactionList, $Failed], Return[$Failed]];
	{reactantsRes, productsRes} = Most[List@@First[reactionList]];

	(* call the corresponding rate function *)
	resRateForward = kineticRates[First@reactionList, reactionTypeForward, resolvedOptions];
	resRateBackward = kineticRates[Last@reactionList, reactionTypeBackward, resolvedOptions];

	Reaction[reactantsRes, productsRes, resRateForward, resRateBackward]

];


resolveReaction[reactants_, products_, reactionTypeList_]:= Module[
	{reactantsRes, productsRes, reactionList},

	(* Unchanged and Unknown types don't have rates calculated *)
	If[MemberQ[reactionTypeList, Unchanged | Unknown], Message[KineticRates::UnrecognizedRateType]; Return[$Failed]];

	(* resolve structures in the input reaction *)
	reactantsRes = NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[#, StrandBase]]&/@reactants;
	productsRes = NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[#, StrandBase]]&/@products;

	(* validate reaction *)
	reactionList = If[Length[reactionTypeList]==1,
		{Reaction[reactantsRes, productsRes, First[reactionTypeList]]},
		{Reaction[reactantsRes, productsRes, First[reactionTypeList]], Reaction[productsRes, reactantsRes, Last[reactionTypeList]]}
	];

	If[!And@@(ReactionQ/@reactionList), Message[KineticRates::UnmatchingReaction]; Return[$Failed]];

	reactionList

];


kineticRates[reaction_, reactionType_, safeOps_]:= With[
	{funcName = ToExpression["Simulation`Private`"<>Decapitalize[ToString[reactionType]<>"Rate"]]},

	funcName[reaction, Quiet@PassOptions[KineticRates, funcName, safeOps]]
];



(* ::Subsubsection:: *)
(*zippingRate*)


zippingRate[Reaction[{reactant:StructureP},{product:StructureP},Zipping]]:= 8*10^6 / Second;


(* ::Subsubsection:: *)
(*unzippingRate*)


Options[unzippingRate]:= {
	Temperature->37Celsius,
	MonovalentSaltConcentration->Automatic,
	DivalentSaltConcentration->Automatic,
	BufferModel->Automatic,
	EquilibriumConstantFunction->SimulateEquilibriumConstant
};


unzippingRate[rxn:Reaction[{reactant:StructureP},{product:StructureP},Unzipping],ops:OptionsPattern[]] := Module[

	{safeOps,equilibriumConstant,userRate},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[unzippingRate, ToList[ops]];

	equilibriumConstant =
		Switch[Lookup[safeOps, EquilibriumConstantFunction],
			SimulateEquilibriumConstant,
			equilibriumConstantForRates[
				reactant,
				product,
				Unzipping,
				Lookup[safeOps,Temperature],
				Lookup[safeOps,MonovalentSaltConcentration],
				Lookup[safeOps,DivalentSaltConcentration],
				Lookup[safeOps,BufferModel]
			],

			_Function,
			Lookup[safeOps, EquilibriumConstantFunction][rxn]
		];

	zippingRate[Reaction[{product},{reactant},Zipping]] * equilibriumConstant

];


(* ::Subsubsection:: *)
(*foldingRate*)


Options[foldingRate]:= {
	FoldingRate->1.4*10^4 /Second,
	MonovalentSaltConcentration -> 1 Molar,
	Temperature->37Celsius
};


foldingRate[rxn:Reaction[{reactant:StructureP},{product:StructureP},Folding],ops:OptionsPattern[]]:=Module[

	{safeOps,tempSaltFitFunc},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[foldingRate, ToList[ops]]/.{Automatic->1 Molar};

	(* ToDo: find a more proper folding rate estimation, possibly based on MCMC and Arrhenius equation *)

	(* calculate the rate based on FoldingRate *)
	(*tempSaltFitFunc = Object[Analysis,Fit,"id:AEqRl9Kz9YKw"][BestFitFunction];*)
	tempSaltFitFunc = 33772.00158382538` +6755.49450549453` #1-7401.245551601412` #2&;

	Switch[Lookup[safeOps, FoldingRate],

		(* it can be a pure function of the input reaction *)
		_Function,
		(Lookup[safeOps, FoldingRate][rxn]) / Second,

		Except[1.4*10^4 /Second],
		Lookup[safeOps, FoldingRate],

		_,
		(tempSaltFitFunc[Unitless[Lookup[safeOps, MonovalentSaltConcentration], Molar], 1000/Unitless[Lookup[safeOps, Temperature], Kelvin]]-(tempSaltFitFunc[1,3.224246332419797`]-14000)) /Second
	]

];


(* ::Subsubsection:: *)
(*meltingRate*)


Options[meltingRate]:= {
	FoldingRate->1.4*10^4 /Second,
	Temperature->37Celsius,
	MonovalentSaltConcentration->Automatic,
	DivalentSaltConcentration->Automatic,
	BufferModel->Automatic,
	EquilibriumConstantFunction->SimulateEquilibriumConstant
};


meltingRate[rxn:Reaction[{reactant:StructureP},{product:StructureP}, Melting], ops:OptionsPattern[]]:= Module[
	{safeOps,equilibriumConstant,userRate,kAU,kGC,activationEnergy,boltzmanConstant},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[meltingRate, ToList[ops]];

	boltzmanConstant = Convert[MolarGasConstant,Calorie/Mole/Kelvin];

	(* cofactors fitted from data from Arrhenius equation *)
	kAU = cofactorsBoltzmann["AU"];
	kGC = cofactorsBoltzmann["GC"];

	equilibriumConstant =
		Switch[Lookup[safeOps, EquilibriumConstantFunction],
			SimulateEquilibriumConstant,
			equilibriumConstantForRates[
				{reactant},
				product,
				Melting,
				Lookup[safeOps,Temperature],
				Lookup[safeOps,MonovalentSaltConcentration],
				Lookup[safeOps,DivalentSaltConcentration],
				Lookup[safeOps,BufferModel]
			],

			_Function,
			Lookup[safeOps, EquilibriumConstantFunction][rxn]
		];

	foldingRate[Reaction[{product},{reactant},Folding], FoldingRate->Lookup[safeOps,FoldingRate]] * equilibriumConstant

];


(* ::Subsubsection:: *)
(*hybridizationRate*)


Options[hybridizationRate]:= {
	KineticsModel->Automatic,
	HybridizationRate->Automatic,
	MonovalentSaltConcentration -> 1 Molar,
	Temperature->37Celsius
};


hybridizationRate[rxn:Reaction[{reactants:StructureP..},{product:StructureP},Hybridization],ops:OptionsPattern[]]:=Module[

	{
		safeOps,equilibriumConstant,userRate,tempFitFunc,
		hybridizationRateValue,resolvedHybridizationRate,kineticsModelBase,modelOligomerKinetics,kineticsModel,
		reactantsType,productType,replacedAutomatic
	},

	(* validate species and reaction *)
	If[!evaluateInputSpecies[{reactants}, {product}, 2, 1], Return[$Failed]];

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[hybridizationRate, ToList[ops]];

	(* Replace Automatic with 1 Molar *)
	replacedAutomatic = SafeOptions[hybridizationRate, ToList[ops]] /. {Automatic->1 Molar};

	(* The reactants first sequence polymer type *)
	reactantsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@{reactants};

	(* The product first sequence polymer type *)
	productType=PolymerType[(product[Strands][[1]][Motifs][[1]])];

	(* Warn that the kinetic parameters of DNA will be used *)
	If[!MatchQ[reactantsType,{DNA..}] || !MatchQ[productType,DNA],
		Message[Warning::SwitchedKineticsModel,{reactantsType,productType}]
	];

	(* <<< Resolving the KineticsModel >>> *)

	(* The base KineticsModel provided in the option *)
	kineticsModelBase=Lookup[safeOps,KineticsModel];

	(* The Kinetics field in the model oligomer *)
	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	modelOligomerKinetics=Quiet[Download[Model[Physics,Oligomer,"DNA"],Kinetics]];

	kineticsModel=Which[
		(* If None, keep None and will be taken care of in lookupModelKinetics *)
		MatchQ[kineticsModelBase,None],
		None,

		(* If Automatic use the Kinetics field in the model oligomer *)
		(MatchQ[kineticsModelBase,Automatic] && !MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		modelOligomerKinetics,

		(* If Automatic and there is no Kinetics field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[kineticsModelBase,Automatic] && MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		None,

		(* If not Automatic and the model does not match the valid pattern for KineticsModel, throw an error *)
		(!MatchQ[kineticsModelBase,Automatic] && !Physics`Private`validKineticsModelQ[kineticsModelBase]),
		(Message[Error::InvalidKineticsModel];Message[Error::InvalidOption,KineticsModel];Null),

		(* If not Automatic and the model does match the valid pattern for KineticsModel, use the model provided *)
		True,
		kineticsModelBase
	];

	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	(* The hybridization rate selected at start *)
	hybridizationRateValue=Lookup[replacedAutomatic,HybridizationRate];

	(* Resolve Hybridization Rate *)
	resolvedHybridizationRate=
		Switch[hybridizationRateValue,

			(* If Automatic, take the value from model physics kinetics *)
			Automatic,
			Unitless[Physics`Private`lookupModelKinetics[DNA,ForwardHybridization,KineticsModel->kineticsModel]]/(Molar*Second),

			(* Everything else, takes it from the option default value *)
			_,
			hybridizationRateValue

		];

	(* calculate the rate based on salt concentration and temperature *)
	(*tempFitFunc = Object[Analysis,Fit,"id:01G6nvw7veVE"][BestFitFunction];*)
	tempFitFunc = 22.45687888198775` -7937.888198757865` #1&;

	Switch[resolvedHybridizationRate,

		(* it can be a pure function of the input reaction *)
		_Function,
		(resolvedHybridizationRate[rxn]) /Molar/Second,

		Except[3.5*10^5 /Molar /Second],
		resolvedHybridizationRate,

		_,
		With[{rateSalt = If[Lookup[replacedAutomatic, MonovalentSaltConcentration] >= 0.25 Molar,
				(4.35*Log10[Unitless[Lookup[replacedAutomatic, MonovalentSaltConcentration], Molar]] + 3.5) * 10^5,

				(* if salt falls below 0.01 Molar, throw a warning and extrapolate the value *)
				Message[KineticRates::Extrapolated];
				Unitless[Lookup[replacedAutomatic, MonovalentSaltConcentration], Molar] * (4.35*Log10[0.25] + 3.5) * 10^5/0.25
			]},
			Exp[tempFitFunc[1/(1.987*Unitless[Lookup[replacedAutomatic, Temperature], Kelvin])] + Log[rateSalt] - tempFitFunc[1/(1.987*310.15)]] /Molar/Second
		]
	]

];


(* ::Subsubsection:: *)
(*dissociationRate*)


Options[dissociationRate]:= {
	KineticsModel->Automatic,
	HybridizationRate->Automatic,
	Temperature->37Celsius,
	BufferModel->Automatic,
	MonovalentSaltConcentration->Automatic,
	DivalentSaltConcentration->Automatic,
	EquilibriumConstantFunction->SimulateEquilibriumConstant
};


(* available data in Reynaldo et al. JMB 2000 *)
(*reynaldoDissociationDataFunction:=reynaldoDissociationDataFunction=Download[Object[Analysis,Fit,"id:P5ZnEjdLr8ZE"],BestFitFunction];*)

dissociationRate::MultipleProducts="Dssociate one structure into more than two structures cannot be applied with DetailedBalance method. Defaulting to EmpiricalData.";

dissociationRate[rxn:Reaction[{reactant:StructureP},{products:StructureP..},Dissociation],ops:OptionsPattern[]]:=Module[

	{
		safeOps,equilibriumConstant,userRate,bondsDomainDissociated,
		hybridizationRateValue,resolvedHybridizationRate,resolvedOptions,kineticsModelBase,modelOligomerKinetics,kineticsModel,
		reactantType,productsType
	},

	(* The reactants first sequence polymer type *)
	reactantType=PolymerType[(reactant[Strands][[1]][Motifs][[1]])];

	(* The product first sequence polymer type *)
	productsType=PolymerType[(#[Strands][[1]][Motifs][[1]])]&/@{products};

	(* Warn that the kinetic parameters of DNA will be used *)
	If[!MatchQ[reactantType,DNA] || !MatchQ[productsType,{DNA..}],
		Message[Warning::SwitchedKineticsModel,{reactantType,productsType}]
	];

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[dissociationRate, ToList[ops]];

	(* <<< Resolving the KineticsModel >>> *)

	(* The base KineticsModel provided in the option *)
	kineticsModelBase=Lookup[safeOps,KineticsModel];

	(* The Kinetics field in the model oligomer *)
	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	modelOligomerKinetics=Quiet[Download[Model[Physics,Oligomer,"DNA"],Kinetics]];

	kineticsModel=Which[
		(* If None, keep None and will be taken care of in lookupModelKinetics *)
		MatchQ[kineticsModelBase,None],
		None,

		(* If Automatic use the Kinetics field in the model oligomer *)
		(MatchQ[kineticsModelBase,Automatic] && !MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		modelOligomerKinetics,

		(* If Automatic and there is no Kinetics field, set it to Null and it will be taken care of in the Physics.m functions *)
		(MatchQ[kineticsModelBase,Automatic] && MatchQ[modelOligomerKinetics,$Failed|Null|{}]),
		None,

		(* If not Automatic and the model does not match the valid pattern for KineticsModel, throw an error *)
		(!MatchQ[kineticsModelBase,Automatic] && !Physics`Private`validKineticsModelQ[kineticsModelBase]),
		(Message[Error::InvalidKineticsModel];Message[Error::InvalidOption,KineticsModel];Null),

		(* If not Automatic and the model does match the valid pattern for KineticsModel, use the model provided *)
		True,
		kineticsModelBase
	];

	(** TODO: this needs to be updated once we have kinetic parameter data for other polymers **)
	(* The hybridization rate selected at start *)
	hybridizationRateValue=Lookup[safeOps,HybridizationRate];

	(* Resolve Hybridization Rate *)
	resolvedHybridizationRate=
		Switch[hybridizationRateValue,

			(* If Automatic, take the value from model physics kinetics *)
			Automatic,
			Unitless[Physics`Private`lookupModelKinetics[DNA,ForwardHybridization,KineticsModel->kineticsModel]]/(Molar*Second),

			(* Everything else, takes it from the option default value *)
			_,
			hybridizationRateValue

		];

	(* The resolved options taking the resolved hybridization rate into account *)
	resolvedOptions=ReplaceRule[safeOps,HybridizationRate->resolvedHybridizationRate];

	If[Length[{products}]>2,
		Message[dissociationRate::MultipleProducts];
		Return[dissociationRate[Reaction[{reactant}, {products}, Dissociation], ReplaceRule[resolvedOptions, Method->EmpiricalData]]];
	];

	(* Simulate equilibrium *)
	equilibriumConstant =
		Switch[Lookup[safeOps, EquilibriumConstantFunction],
			SimulateEquilibriumConstant,
				equilibriumConstantForRates[
				reactant,
				{products},
				Dissociation,
				Lookup[resolvedOptions,Temperature],
				Lookup[resolvedOptions,MonovalentSaltConcentration],
				Lookup[resolvedOptions,DivalentSaltConcentration],
				Lookup[resolvedOptions,BufferModel]
			],

			_Function,
			Lookup[resolvedOptions, EquilibriumConstantFunction][rxn]
		];

	Unitless[hybridizationRate[Reaction[{products},{reactant},Hybridization], HybridizationRate->Lookup[resolvedOptions,HybridizationRate]]] * equilibriumConstant /Second

];


(* ::Subsubsection:: *)
(*strandInvasionRate*)


Options[strandInvasionRate]:= {
	Temperature->37Celsius
};


(* available data in Reynaldo et al. JMB 2000 *)

(* Displacement case, second order *)
(* reynaldoDisplacementFunc:=reynaldoDisplacementFunc=Download[Object[Analysis,Fit,"id:Vrbp1jKDZZzx"],BestFitFunction]; *)
reynaldoDisplacementFunc:= 2.6378936274375375` -0.026122624506525503` #1^2+#1 (-0.2763779850830168`+ 0.020487363243879213` #2)-0.007882784262943629` #2-0.0023762640596684233` #2^2&;

strandInvasionRate[Reaction[{reactantDoubleStrand:StructureP,reactantSingleStrand:StructureP},{product1:StructureP,product2:StructureP},StrandInvasion],ops:OptionsPattern[]]:=Module[

	{safeOps,productDoubleStrand,productSingleStrand},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[strandInvasionRate, ToList[ops]];

	(* identify single vs double strand reactants/products *)
	{productDoubleStrand,productSingleStrand} = If[product1[Bonds]==={},
		{product2,product1},
		{product1,product2}];

	10^(reynaldoDisplacementFunc[NumberOfBonds[productDoubleStrand],Unitless[Lookup[safeOps,Temperature],Celsius]]) /Molar/Second

];


(* dissociative case, first order *)
(* reynaldoDissociativeFunc:=reynaldoDissociativeFunc=Download[Object[Analysis,Fit,"id:9RdZXv1W7E9L"],BestFitFunction]; *)
reynaldoDissociativeFunc:= -2.7178653687116423`- 0.698907992816782` #1+0.19276193911961786` #2&;

strandInvasionRate[Reaction[{reactant:StructureP},{product:StructureP},StrandInvasion],ops:OptionsPattern[]]:= Module[
	{safeOps, splitFunc, reactSplitMap, prodSplitMap, unintersect, span, dissoLength},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[strandInvasionRate, ToList[ops]];

	(* identify number of bases dissocated *)
	splitFunc = (#[[1]][[2]]->#[[2]])&/@Last/@Simulation`Private`postMeltOneLevel/@Simulation`Private`meltOneLevel[#, True]&;
	{reactSplitMap, prodSplitMap} = splitFunc/@{reactant, product};
	unintersect = Complement[reactSplitMap, prodSplitMap];

	span = Last[First[Last[First[unintersect]]]];

	dissoLength = Last[span]-First[span]+1;

	(* compute the rate from the fitted model *)
	10^(reynaldoDissociativeFunc[dissoLength, Unitless[Lookup[safeOps,Temperature],Celsius]]) /Second
];




(* ::Subsubsection:: *)
(*toeholdMediatedDuplexExchangeRate*)


toeholdMediatedDuplexExchangeRate[Reaction[{StructureP},{StructureP,StructureP},ToeholdMediatedDuplexExchange]]:= 0.00153 / Second; (* averaged from 3p and 5p from Frezza's data *)


(* ::Subsubsection:: *)
(*toeholdMediatedStrandExchangeRate*)


Options[toeholdMediatedStrandExchangeRate]:= {
	Temperature->37Celsius
};


frezza3pToeholdStrandFunction:=frezza3pToeholdStrandFunction = Download[Object[Analysis,Fit,"id:dORYzZJKnMd5"],BestFitFunction];
frezza5pToeholdStrandFunction:=frezza5pToeholdStrandFunction = Download[Object[Analysis,Fit,"id:P5ZnEjdL4nkE"],BestFitFunction];

toeholdMediatedStrandExchangeRate[Reaction[{reactant1:StructureP,reactant2:StructureP},{product1:StructureP,product2:StructureP},ToeholdMediatedStrandExchange],ops:OptionsPattern[]]:=Module[

	{safeOps,userRate,toeholdDomain,Gp,activationEnergyNormalized,boltzmanConstant,logRateFitted,lengthToeholdDomain,
	reactantDoubleStrand,reactantSingleStrand,productDoubleStrand,productSingleStrand,typeToehold},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[toeholdMediatedStrandExchangeRate, ToList[ops]];

	(* resolve input structures *)
	{reactant1, reactant2, product1, product2} = NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[#,StrandBase]]&/@{reactant1, reactant2, product1, product2};

	Gp = averageMeltingStabilityBasePairStack[{}];
	boltzmanConstant = Convert[MolarGasConstant,Joule/Mole/Kelvin];

	(* identify type of toehold *)
	(* distol search: identify toehold mismatches by comparing double strand reactant and product *)
	{typeToehold, lengthToeholdDomain} = extractToeHoldDomain[{reactant1,reactant2}, {product1, product2}, Strand];

	(* empirical function fitted by Frezza's data that returns log-scaled kinetic rate given the activation energy *)
	logRateFitted = Switch[typeToehold,
		(* 3p-toehold *)
		"3p", frezza3pToeholdStrandFunction,
		(* 5p-toehold *)
		"5p", frezza5pToeholdStrandFunction
	];

	(* compute activation energy normalized by temperature and Boltzmann factor *)
	activationEnergyNormalized = Unitless[lengthToeholdDomain * Convert[Gp,Joule/Mole/BasePair] / (boltzmanConstant * Convert[Lookup[safeOps,Temperature],Kelvin])];

	(* step-wise function to fit kinetic data *)
	If[GreaterEqualThan[-20][activationEnergyNormalized],
		Exp[logRateFitted[activationEnergyNormalized]] /Molar /Second,
		Exp[logRateFitted[-20]] /Molar /Second
	]
];


(* ::Subsubsection:: *)
(*duplexInvasionRate*)


duplexInvasionRate[Reaction[{reactantInitial:StructureP,reactantInvade:StructureP},{product1:StructureP,product2:StructureP},DuplexInvasion]]:= Quantity[0, 1/("Molar"*"Seconds")];


(* ::Subsubsection:: *)
(*dualToeholdMediatedDuplexExchangeRate*)


Options[dualToeholdMediatedDuplexExchangeRate]:= {
	Temperature->37Celsius
};


frezzaDualToeholdFunction:=frezzaDualToeholdFunction=Download[Object[Analysis,Fit,"id:mnk9jORoVr9w"],BestFitFunction];

dualToeholdMediatedDuplexExchangeRate[Reaction[{reactant1:StructureP,reactant2:StructureP},{product1:StructureP,product2:StructureP},DualToeholdMediatedDuplexExchange],ops:OptionsPattern[]]:=Module[

	{safeOps,userRate,toeholdDomain,Gp,activationEnergyNormalized,boltzmanConstant,logRateFitted,lengthToeholdDomain},

	(* Resolve 'ops' into 'safeOps' *)
	safeOps = SafeOptions[dualToeholdMediatedDuplexExchangeRate, ToList[ops]];

	Gp = averageMeltingStabilityBasePairStack[{}];
	boltzmanConstant = Convert[MolarGasConstant,Joule/Mole/Kelvin];

	(* distol search: identify toehold mismatches by comparing double strand reactant and product *)
	(* ToDo: check/integrate all reactants and products *)
	lengthToeholdDomain = Total[NumberOfBonds/@{product1, product2} - NumberOfBonds/@{reactant1, reactant2}]BasePair;

	(* empirical function fitted by Frezza's data that returns log-scaled kinetic rate given the activation energy *)
	logRateFitted = frezzaDualToeholdFunction;

	(* compute activation energy normalized by temperature and Boltzmann factor *)
	activationEnergyNormalized = lengthToeholdDomain * Convert[Gp,Joule/Mole/BasePair] / (boltzmanConstant * Convert[Lookup[safeOps,Temperature],Kelvin]);

	(* step-wise function to fit kinetic data *)
	If[GreaterEqualThan[-20][activationEnergyNormalized],
		Exp[logRateFitted[activationEnergyNormalized]] /Molar /Second,
		Exp[logRateFitted[-20]] /Molar /Second
	]

];
