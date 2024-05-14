(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

If[$VersionNumber>=12.2,
	 (
		 caloriePerMoleString="ThermochemicalCalories" / ( "Moles");
	 ),
	 (
		 caloriePerMoleString="CaloriesThermochemical" / ( "Moles");
	 )
 ];


(* ::Section:: *)
(*Source Code*)

(* ::Subsection:: *)
(*Messages*)
OnLoad[
	Error::LengthExceedMax = "Input sequence too long in function `1`. Must be shorter than 1000 nt to simulate.";
	Error::InvalidThermoInput = "Input is invalid in function `1`. Check if all input reactants are valid sequence or structure and can form a valid reaction. For samples the reactants are the molecules in the composition field.";
	Warning::InvalidPolymerType = "Polymer->Null is not a valid option value for vague input in function `1`. Polymer will be defaulted to Automatic.";
	Warning::BadPolymerType = "Given polymer type `1` does not match on input in function `2`. Polymer will be defaulted to Automatic.";
	Error::InvalidSaltConcentration = "In function `1`, MonovalentSaltConcentration and DivalentSaltConcentration cannot both be 0 Molar.";
	Error::UnsupportedReactionType = "Reaction type is not supported. Please check input to have no more than two reactants and a known reaction type.";
	Error::UnsupportedMechanism = "ReactionMechanism is too complicated in function `1`. Please check ReactionMechanism only contains one first order or second order reaction.  If input is an Object, you may want to try setting the ReactionType option to Automatic.";
	Warning::ReactionTypeWarning = "Object `1` may not have bonds and option `2` is selected.  You may want to set ReactionType option to Automatic.";
	Warning::ReactionTypeNull = "Input Object `1` should not have ReactionType option set to Null.  Changing ReactionType option to `2`.";
	Error::IncorrectConcentration = "Input concentration is incorrect. Check species matches reactants in input reaction.";
	Warning::AlternativeParameterizationNotAvailable = "The AlternativeParameterization for oligomer `1` does not exist. Setting AlternativeParameterization to False.";
	Error::InvalidThermodynamicsModel="The option ThermodynamicsModel does not match the correct pattern. Please check if the fields Wavelengths and MolarExtinctions are populated and if the MolarExtinctions have the {{_String->x LiterPerCentimeterMole}..} pattern.";
];

(* ::Subsection:: *)
(*Create Tests*)

(* ::Subsubsection:: *)
(*validSaltConcentrationTestOrEmpty*)

validSaltConcentrationTestOrEmpty[functionName_,makeTest:BooleanP,description_,passedQ_]:=If[makeTest,
	Test[description,passedQ,True],
	If[TrueQ[passedQ],
		{},
		Message[Error::InvalidSaltConcentration,functionName];
		Message[Error::InvalidOption,MonovalentSaltConcentration];
	]
];



(* ::Subsubsection::Closed:: *)
(*supportedReactionTypeTestOrEmpty*)

supportedReactionTypeTestOrEmpty[in_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[TrueQ[passedQ],
		{{},{}},
		Message[Error::UnsupportedReactionType];
		{{},{in}}
	]
];



(* ::Subsubsection::Closed:: *)
(*validConcentrationTestOrEmpty*)

validConcentrationTestOrEmpty[in_, makeTest:BooleanP, description_, passedQ_]:=
	If[makeTest,
		{Test[description,passedQ,True],{}},
		If[TrueQ[passedQ],
			{{},{}},
			Message[Error::IncorrectConcentration];
			{{},{in}}
		]
	];



(* ::Subsubsection::Closed:: *)
(*supportedStrandPolymersTestOrEmpty*)

supportedStrandPolymersTestOrEmpty[in_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[TrueQ[passedQ],
		{{},{}},
		{{},{in}}
	]
];



(* ::Subsubsection::Closed:: *)
(*validSequenceTestOrEmpty*)

validSequenceTestOrEmpty[in_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[TrueQ[passedQ],
		{{},{}},
		Message[Error::InvalidSequence,in];
		{{},{in}}
	]
];



(* ::Subsubsection::Closed:: *)
(*validStrandTestOrEmpty*)

validStrandTestOrEmpty[in_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[TrueQ[passedQ],
		{{},{}},
		Message[Error::InvalidStrand,in];
		{{},{in}}
	]
];



(* ::Subsubsection::Closed:: *)
(*validSequenceLengthTestOrEmpty*)

validSequenceLengthTestOrEmpty[functionName_, in_, unresolvedOps_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[MatchQ[Lookup[unresolvedOps, Polymer], Null], Message[Warning::InvalidPolymerType,functionName]];
	If[TrueQ[passedQ],
		{{},{}},
		Message[Error::LengthExceedMax,functionName];
		{{},{in}}
	]
];



(* ::Subsubsection::Closed:: *)
(*validThermoInputTestOrEmpty*)

validThermoInputTestOrEmpty[functionName_, in_, resolvedOps_, makeTest:BooleanP, description_]:=
If[makeTest,
	{Test[description,
		! Quiet@invalidStructureArgumentsQ[functionName,toReactantProductStructures[functionName,in,resolvedOps]],
		True
	],{}},
	If[TrueQ[! Quiet@invalidStructureArgumentsQ[functionName,toReactantProductStructures[functionName, in, resolvedOps]]],
		{{},{}},
		Message[Error::InvalidThermoInput,functionName];
		{{},{in}}
	]
];



validThermoInputTestOrEmpty[functionName_, in:ListableP[StructureP], resolvedOps_, makeTest:BooleanP, description_]:=
If[makeTest,
	{Test[description,
		StructureQ[in],
		True
	],{}},
	If[TrueQ[StructureQ[in]],
		{{},{}},
		Message[Error::InvalidSequence,in];
		{{},{in}}
	]
];



validThermoInputTestOrEmpty[functionName_, in_Plus, resolvedOps_, makeTest:BooleanP, description_]:=Module[
	{anb, structures, prods, passedQ},
	anb = in /. Plus->List;
	structures = getStructure[#, resolvedOps] & /@ anb;
	prods = Quiet @ First[Pairing[Sequence @@ structures]];
	passedQ = MatchQ[prods, StructureP];
	If[makeTest,
		{Test[description,passedQ,True],{}},
		If[TrueQ[passedQ],
			{{},{}},
			Message[Error::InvalidThermoInput,functionName];
			{{},{in}}
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*supportedMechanismTestOrEmpty*)

supportedMechanismTestOrEmpty[functionName_, mechanism_, makeTest:BooleanP, description_, passedQ_]:=
If[makeTest,
	{Test[description,passedQ,True],{}},
	If[TrueQ[passedQ],
		{{},{}},
		Message[Error::UnsupportedMechanism,functionName];
		{{},{mechanism}}
	]
];



(* ::Subsubsection::Closed:: *)
(* ::Subsection::Closed:: *)
(*Local Patterns & constants*)

(* ::Subsubsection::Closed:: *)
(*input patterns*)

tempArgumentP=UnitsP["DegreesCelsius"] | DistributionP["DegreesCelsius"];
concArgumentP= UnitsP["Molar"] | DistributionP["Molar"] | {Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]..};
enthalpyArgumentP=UnitsP[KilocaloriePerMole] | DistributionP[KilocaloriePerMole];
entropyArgumentP=UnitsP[CaloriePerMoleKelvin] | DistributionP[CaloriePerMoleKelvin];
freeEnergyArgumentP=UnitsP[KilocaloriePerMole] | DistributionP[KilocaloriePerMole];


inputPatternThermoCalcP=Alternatives[
	_Integer,
	SequenceP,
	StrandP,
	StructureP,
	ObjectP[Model[Sample]],
	ObjectP[Object[Sample]],
	ObjectP[Model[Reaction]],
	ObjectP[Model[Molecule, Oligomer]],
	ReactionP,
	ReactionMechanismP,
	Rule[StructureP,StructureP],
	Equilibrium[StructureP,StructureP],
	_Plus
];



(* ::Subsubsection::Closed:: *)
(*MolarGasConstantStandardUnits*)


MolarGasConstantStandardUnits = Convert[MolarGasConstant,Joule/(Kelvin*Mole)];


(* ::Subsubsection::Closed:: *)
(*defaultTemperatureValue*)


defaultTemperatureValue=37.0*Celsius;



(* ::Subsubsection:: *)
(*resolveInputsThermoCalculation*)


resolveInputsThermoCalculation[functionName_ ,mechanism_ReactionMechanism, resolvedOps_] := Module[
	{reactions},
	reactions = mechanism[Reactions];
	If[!MatchQ[Length[reactions], 1], Message[Error::UnsupportedMechanism,functionName]; Return[{Null, Null}]];
	resolveInputsThermoCalculation[functionName, First[reactions], resolvedOps]
];

resolveInputsThermoCalculation[functionName_, reaction_Reaction, resolvedOps_]:=Module[
	{structures},
	structures = {
		(* need to SplitReatcion here to only get the forward reaction, otherwise if reversible the reactants and products are always everything *)
		StructureJoin@@NucleicAcids`Private`reactionToReactants[First[SplitReaction[reaction]]],
		StructureJoin@@NucleicAcids`Private`reactionToProducts[First[SplitReaction[reaction]]]
	};
	{reaction,structures}
];

resolveInputsThermoCalculation[functionName_, in_, resolvedOps_]:=Module[
	{structures, reaction},
	structures = toReactantProductStructures[functionName,in,resolvedOps];
	If[invalidStructureArgumentsQ[functionName,structures], Return[{Null, Null}]];
	reaction = resolveInputReaction[in,structures];
	{reaction,structures}
];

resolveInputsThermoCalculation[functionName_, in_Plus, resolvedOps_] := Module[
	{anb, structures, prods, reaction},
	anb = in /. Plus->List;
	structures = getStructure[#, resolvedOps] & /@ anb;
	prods = Quiet @ First[Pairing[Sequence @@ structures]];
	If[!MatchQ[prods, StructureP], Message[Error::InvalidThermoInput,functionName]; Return[{Null, Null}]];
	reaction = resolveInputReaction[structures, {StructureJoin @@ structures, prods}];
	{reaction, {StructureJoin @@ structures, prods}}
];



(* ::Subsubsection::Closed:: *)
(*getStructure*)

getStructure[in: SequenceP, ops_] := If[
	Quiet[SequenceQ[in, Polymer->Lookup[ops, Polymer], Degeneracy->True]],
	ToStructure[ToStrand[in, Polymer->Lookup[ops, Polymer]]],
	Message[functionName::InvalidSequence, in]
];
getStructure[in: ObjectReferenceP[{Object[Sample], Model[Sample]}], ops_] := Download[in, Strand];
getStructure[in_, ops_] := Null;



(* ::Subsubsection::Closed:: *)
(*toReactantProductStructures*)

(* given sequence or length, turn it into a strand and call self *)
toReactantProductStructures[functionName_,length_Integer,safeOps_List]:=Module[
	{ss, polyType},
	If[length > 1000, Message[Error::LengthExceedMax,functionName]; Return[Null]];
	polyType = Lookup[safeOps, Polymer];
	If[MatchQ[polyType, Null], Message[Warning::InvalidPolymerType,functionName]; polyType = Automatic];
	ss = ToStrand[sequenceLengthToTypedSequenceLength[length, polyType]];
	toReactantProductStructures[functionName,ss,safeOps]
];

toReactantProductStructures[functionName_, pol: ((DNA | RNA)[x_Integer]) | ((DNA | RNA)[x_Integer, y_String]), safeOps_List] := toReactantProductStructures[functionName, flattenDegenerate[pol], safeOps];

toReactantProductStructures[functionName_,seq:SequenceP,safeOps_List]:=If[
	Quiet[SequenceQ[seq,Polymer->Lookup[safeOps,Polymer],Degeneracy->True]],
	With[
		{s=ToStrand[seq,Polymer->Lookup[safeOps,Polymer]/. Null->Automatic]},
		toReactantProductStructures[functionName,s,safeOps]
	],
	Message[functionName::InvalidSequence,seq]
];

(* given packet, pull, download all molecules from the composition to get any strands and structures to pass down *)
toReactantProductStructures[functionName_,oligoPacket: PacketP[{Object[Sample],Model[Sample]}],safeOps_List]:=Module[
	{rawStrandsAndStructures},
	rawStrandsAndStructures=Cases[Quiet[Download[oligoPacket,Composition[[All,2]][Molecule]]],StrandP|StructureP];

	(* If we are given ReactionType->Melting, don't convert to strands. *)
	If[!MatchQ[Lookup[safeOps,ReactionType,Null],Melting],
		StructureJoin@@@Transpose[Map[toReactantProductStructures[functionName,#,safeOps]&,Flatten[ToStrand/@rawStrandsAndStructures]]],
		toReactantProductStructures[functionName,First[rawStrandsAndStructures],safeOps]
	]
];


(* given oligomer packet, return the molecules *)
toReactantProductStructures[functionName_,oligoPacket: ObjectP[{Model[Molecule, Oligomer]}],safeOps_List]:=Module[
	{oligoMolecule, reverseComplement},
	
	(* pull out oligo molecule *)
	oligoMolecule=Quiet[Download[oligoPacket,Molecule]];
	
	(* send to single strand overload *)
	toReactantProductStructures[functionName, oligoMolecule, safeOps]
	
];

toReactantProductStructures[functionName_,reacPacket: PacketP[Model[Reaction]],safeOps_List]:=With[
	{reacts=Lookup[reacPacket,Reactants],prods=Lookup[reacPacket,ReactionProducts]},
	{StructureJoin@@reacts,StructureJoin@@prods}
];

(* given object, get download and call self *)
toReactantProductStructures[functionName_,oligoObj: ObjectReferenceP[{Model[Sample],Object[Sample],Model[Reaction]}] | LinkP[], safeOps_List]:=toReactantProductStructures[functionName,Download[oligoObj],safeOps];

(* given structure used as product, structure without bonds used as reactant *)
toReactantProductStructures[functionName_,struct:StructureP,safeOps_List]:=Module[{revcomp},
	{
		ToStructure[ToStrand[struct]],
		struct
	}
];

(* given strand, make revcomp and and stick them together for product, reactant is those two wihtout bonds *)
toReactantProductStructures[functionName_,s_Strand,safeOps_List]:=Module[{ss},
	If[!StrandQ[s],
		Return[Message[functionName::InvalidStrand,s]]
	];
	ss = flattenDegenerate[#] & /@ s;
	toSelfPairingStructures[ss]
];

toReactantProductStructures[functionName_,Rule[a_Structure,b_Structure],safeOps_List]:=
	{ a,b };
toReactantProductStructures[functionName_,Equilibrium[a_Structure,b_Structure],safeOps_List]:=
	{ a,b };


sequenceLengthToTypedSequenceLength[length_Integer,Automatic]:=sequenceLengthToTypedSequenceLength[length,DNA];
sequenceLengthToTypedSequenceLength[length_Integer,pol_]:=pol[StringRepeat["N", length]];



flattenDegenerate[Structure[strands_,bonds_]]:=Structure[Map[flattenDegenerate,strands],bonds];
flattenDegenerate[str_Strand]:=Map[flattenDegenerate,str];
flattenDegenerate[(pol_Symbol)[x_Integer]] := pol[StringRepeat[getWildCardMonomer[pol],x]];
flattenDegenerate[(pol_Symbol)[x_Integer, y_String]] := pol[StringRepeat[getWildCardMonomer[pol],x],y];
flattenDegenerate[in_]:=in;

getWildCardMonomer[pol_]:= getWildCardMonomer[pol] = Physics`Private`modelOligomerParameters[pol][WildcardMonomer];


(* ::Subsubsection::Closed:: *)
(*toSelfPairingStructures*)

toSelfPairingStructures[strand_Strand]:=With[
	{
		n=Length[strand],
		inds=Flatten[Position[strand,Except[_Modification],{1},Heads->False]],
		revcomp=ReverseComplementSequence[strand]
	},
	{
		Structure[{strand,revcomp},{}],
		Structure[{strand,revcomp},Table[Bond[{1,ix},{2,n+1-ix}],{ix,inds}]]
	}
];



(* ::Subsubsection:: *)
(*resolveInputReaction*)

resolveInputReaction[in: ObjectReferenceP[Model[Reaction]] | LinkP[Model[Reaction]],structures:{structureBefore_Structure,structureAfter_Structure}]:=
	resolveInputReaction[Download[in],structures];
resolveInputReaction[in: PacketP[Model[Reaction]],{structureBefore_,structureAfter_}]:=Lookup[in,Reaction];

resolveInputReaction[in_,{structureBefore_Structure,structureAfter_Structure}]:=Module[{reactionType},
	reactionType = ClassifyReaction[{structureBefore}, {structureAfter}];
	Reaction[SplitStructure[structureBefore], SplitStructure[structureAfter], reactionType]
];

resolveInputReaction[in_,structures:{{_Structure,_Structure}..}]:=Module[{},
	Map[resolveInputReaction[in,#]&,structures]
];



(* ::Subsection:: *)
(*Resolving options*)

(* ::Subsubsection:: *)
(*resolveThermoOptions*)

DefineOptions[resolveThermoOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

resolveThermoOptions[functionName_,functionIn_,myOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		pol, resolvedOptions, output, listedOutput, collectTestsBoolean, allTests, reactionType, singleIn, resolvedStrand,

		thermodynamicsModelBase,modelOligomerThermodynamics,thermodynamicsModel
	},

	(* From resolveThermoOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	(* Gather all the tests (this will be a list of {} if !Output->Test) *)
	allTests = validSaltConcentrationTestOrEmpty[
		functionName,
		collectTestsBoolean,
		"The MonovalentSaltConcentration and DivalentSaltConcentration concentrations are valid:",
		!MatchQ[invalidSaltConcentration[functionName, Unitless[Lookup[myOptions, MonovalentSaltConcentration]], Unitless[Lookup[myOptions, DivalentSaltConcentration]]], 1]
	];

	singleIn = First[ToList[functionIn]];
	resolvedStrand = If[MatchQ[singleIn,ObjectP[{Model[Sample],Object[Sample]}]],
		FirstOrDefault[
			Cases[Quiet[Download[singleIn,Composition[[All,2]][Molecule]]],StrandP|StructureP],
			Null
		],
		singleIn
	];

	reactionType = Switch[Lookup[myOptions, ReactionType, Automatic],
		Automatic, If[!MatchQ[resolvedStrand,StrandP|StructureP],
			Null,
			If[Length[resolvedStrand] == 1 || NumberOfBonds[resolvedStrand] == 0,
				Hybridization,
				Melting
			]
		],
		Hybridization, If[!MatchQ[resolvedStrand,StrandP|StructureP],
			Null,
			Hybridization
		],
		Melting, If[MatchQ[resolvedStrand,StrandP|StructureP] && NumberOfBonds[resolvedStrand] == 0,
			Message[Warning::ReactionTypeWarning, resolvedStrand, Melting]; Melting,
			Melting
		],
		Null, If[!MatchQ[resolvedStrand,StrandP|StructureP],
			Null,
			If[Length[resolvedStrand] == 1 || NumberOfBonds[resolvedStrand] == 0,
				Message[Warning::ReactionTypeNull, resolvedStrand, Hybridization]; Hybridization,
				Message[Warning::ReactionTypeNull, resolvedStrand, Melting]; Melting
			]
		]
	];

	pol = resolveThermoPolymer[resolvedStrand,Lookup[myOptions, Polymer]];

	(* Throw error if the polymer is Null but the option Polymer has been specified *)
	If[And[!MatchQ[Lookup[myOptions, Polymer], Automatic], MatchQ[pol, (Null | $Failed) ]],
		Message[Warning::BadPolymerType, Lookup[myOptions, Polymer], functionName]
	];

	(* The base ThermodynamicsModel provided in the option *)
	thermodynamicsModelBase=Lookup[myOptions,ThermodynamicsModel];

	(* The Thermodynamics field in the model oligomer *)
	modelOligomerThermodynamics=Quiet[Download[Model[Physics,Oligomer,SymbolName[pol]],Thermodynamics]];

	(* Resolving the ThermodynamicsModel *)
	thermodynamicsModel=Which[
		(* If Automatic use the Thermodynamics field in the model oligomer *)
		(MatchQ[thermodynamicsModelBase,Automatic] && !MatchQ[modelOligomerThermodynamics,$Failed|Null|{}]),
		modelOligomerThermodynamics,

		(* If Automatic and there is no Thermodynamics field, set it to None and it will be taken care of in the Physics.m functions *)
		(MatchQ[thermodynamicsModelBase,Automatic] && MatchQ[modelOligomerThermodynamics,$Failed|Null|{}]),
		None,

		(* If None it has been set by other function callers *)
		MatchQ[thermodynamicsModelBase,None],
		None,

		(* If not Automatic and the model does not match the valid pattern for ThermodynamicsModel, throw an error *)
		(!MatchQ[thermodynamicsModelBase,Automatic] && !Physics`Private`validThermodynamicsModelQ[thermodynamicsModelBase]),
		(Message[Error::InvalidThermodynamicsModel];Message[Error::InvalidOption,ThermodynamicsModel];Null),

		(* If not Automatic and the model does match the valid pattern for ThermodynamicsModel, use the model provided *)
		True,
		thermodynamicsModelBase
	];

	(* The base AlternativeParameterization provided in the option *)
	alternativeParameterizationBase=Lookup[myOptions,AlternativeParameterization];

	(* The Thermodynamics field in the model oligomer *)
	modelOligomerAlternativeParameterization=Module[
		{parameterization},

		(* The alternativeParameterization field *)
		parameterization=If[!MatchQ[pol,Null],
			Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)],
			{}
		];

		If[!MatchQ[parameterization,{}],
			Quiet[Download[First[parameterization][ReferenceOligomer],Thermodynamics]],
			{}
		]
	];

	(* Resolving the AlternativeParameterization *)
	alternativeParameterization=Which[
		(* If Automatic and the thermo object is avaialble or a model thermodynamics is given use the Thermodynamics and set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && (!MatchQ[modelOligomerThermodynamics,$Failed|Null|{}] || !MatchQ[thermodynamicsModel,$Failed|Null|{}|None]) ),
		False,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is not available use the Thermodynamics field in the reference oligomer and set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		False,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is available use the Thermodynamics field in the reference oligomer and set this to True *)
		(MatchQ[alternativeParameterizationBase,Automatic] && !MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		True,

		(* If Automatic and the thermo object is not avaialble and the AlternativeParameterization field is not available set this to False *)
		(MatchQ[alternativeParameterizationBase,Automatic] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		False,

		(* If polymer is specified and the AlternativeParameterization field is not available set this to False *)
		(MatchQ[alternativeParameterizationBase,True] && !MatchQ[pol,Null] && MatchQ[modelOligomerAlternativeParameterization,$Failed|Null|{}]),
		(Message[Warning::AlternativeParameterizationNotAvailable,pol];False),

		(* If not Automatic and AlternativeParameterization is available use the user option *)
		True,
		alternativeParameterizationBase
	];

	resolvedOptions = If[MatchQ[invalidSaltConcentration[functionName, Unitless[Lookup[myOptions, MonovalentSaltConcentration]], Unitless[Lookup[myOptions, DivalentSaltConcentration]]], 1],
		$Failed,
		ReplaceRule[
			myOptions,
			Join[
				resolveSaltConcentrationOptions[functionName,Lookup[myOptions,{BufferModel,MonovalentSaltConcentration,DivalentSaltConcentration}]],
				{
					Polymer->pol,
					ReactionType->reactionType,
					(* We don't want to use themodynamics model to None if the alternativeParameterization is True *)
					ThermodynamicsModel->If[alternativeParameterization,None,thermodynamicsModel],
					AlternativeParameterization->alternativeParameterization
				}
			]
		]
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];


invalidSaltConcentration[functionName_, mono: 0, di: 0] := 1;
invalidSaltConcentration[functionName_, mono_, di_] := 0;


(* ::Subsubsection::Closed:: *)
(*resolveThermoPolymer*)


resolveThermoPolymer[length_Integer,pol_]:=Replace[pol,Automatic->DNA];
resolveThermoPolymer[seq:SequenceP,pol_]:=Quiet@With[{polymer=PolymerType[seq,Polymer->pol]},If[MatchQ[polymer,$Failed],Null,polymer]];

(** TODO: we are missing the pattern matching for strands - don't we need one ? - otherwise gets Null **)
resolveThermoPolymer[seq_, pol_] := Null;

resolveThermoPolymer[more_Plus, pol_] := Module[
	{reactantRaw, types, type},
	reactantRaw = more /. Plus->List;
	types = Map[resolveThermoPolymer[#, pol] &, reactantRaw];
	type = If[MatchQ[Length[DeleteDuplicates[types]], 1], types[[1]], Null];
	If[MatchQ[type,$Failed],Null,type]
];


(* ::Subsubsection:: *)
(*resolveSaltConcentrationOptions*)


defaultMonoSaltConc = 0.05 * Molar;
defaultDiSaltConc = 0.0 * Molar;
minSaltConc = 0.01 * Molar;
maxSaltConc = 1.0 * Molar;

resolveSaltConcentrationOptions[BindingEnthalpy|SimulateEnthalpy,___]:={};

(* default *)
resolveSaltConcentrationOptions[functionName_,{Automatic|Null,Automatic|Null,Automatic|Null}]:={
	MonovalentSaltConcentration->defaultMonoSaltConc,
	DivalentSaltConcentration->defaultDiSaltConc,
	BufferModel->Null
};

(* Explicit concentrations override BufferModel *)
resolveSaltConcentrationOptions[functionName_,{_,mv:ConcentrationP,dv:ConcentrationP}]:={BufferModel->Null,MonovalentSaltConcentration->mv,DivalentSaltConcentration->dv};
resolveSaltConcentrationOptions[functionName_,{_,mv:ConcentrationP,Automatic|Null}]:={BufferModel->Null,MonovalentSaltConcentration->mv,DivalentSaltConcentration->0.0*Molar};
resolveSaltConcentrationOptions[functionName_,{_,Automatic|Null,dv:ConcentrationP}]:={BufferModel->Null,MonovalentSaltConcentration->0.0*Molar,DivalentSaltConcentration->dv};


(* Parse BufferModel *)
bufferModelPattern = ObjectP[Model[Sample, StockSolution]] | ObjectP[Object[Sample]] | ObjectP[Model[Sample]];
resolveSaltConcentrationOptions[functionName_,{bufferModel:bufferModelPattern,Automatic|Null,Automatic|Null}]:=Module[{mv,dv},
	{mv,dv} = parseSaltConcentrationFromBuffer[bufferModel];
	ReplaceRule[resolveSaltConcentrationOptions[functionName,{Null,mv,dv}],BufferModel->bufferModel]
];



(* ::Subsubsection::Closed:: *)
(*resolveOptionsReactionModel*)

resolveOptionsReactionModel[in: ObjectReferenceP[Model[Reaction]] | LinkP[Model[Reaction]]] := in[Object];
resolveOptionsReactionModel[in: PacketP[Model[Reaction]]] := Lookup[in,Object];
resolveOptionsReactionModel[_]:=Null;



(* ::Subsubsection::Closed:: *)
(*resolveOptionsReactantModels*)

resolveOptionsReactantModels[inf: ObjectP[Object[Sample]]]:=resolveOptionsReactantModels[inf[Model]];
resolveOptionsReactantModels[inf: ObjectP[Model[Sample]]]:=Module[{strands},
	strands  = Cases[Download[inf,Composition[[All,2]][Object]],ObjectP[{Model[Molecule,Oligomer], Model[Molecule, Transcript], Model[Molecule,cDNA]}]];
	Switch[Length[strands],
		1, strands,
		2, {},
		_, {}
	]
];
resolveOptionsReactantModels[inf: ObjectP[Model[Reaction]]]:=With[{temp = inf[ReactantModels]}, If[MatchQ[temp, ListableP[ObjectP[]]], temp[Object], {}]];
resolveOptionsReactantModels[_]:={};



(* ::Subsubsection::Closed:: *)
(*resolveOptionsProductModels*)

resolveOptionsProductModels[inf: ObjectP[Object[Sample]]]:=resolveOptionsProductModels[inf[Model]];
resolveOptionsProductModels[inf: ObjectP[Model[Sample]]]:=Module[{strands},
	strands  = Cases[Download[inf,Composition[[All,2]][Object]],ObjectP[Model[Molecule,Oligomer]]];
	Switch[Length[strands],
		1, {},
		2, {inf[Object]},
		_, {}
	]
];
resolveOptionsProductModels[inf: ObjectP[Model[Reaction]]]:=With[{temp = inf[ProductModels]}, If[MatchQ[temp, ListableP[ObjectP[]]], temp[Object], {}]];
resolveOptionsProductModels[_]:={};



(* ::Subsubsection::Closed:: *)
(*resolveReturn*)

parseConc[conc_List] := Last /@ conc;
parseConc[conc_] := {conc};


isNotDistr[distr: DistributionP[]] := False;
isNotDistr[structure: StructureP] := !AllTrue[structure[Strands], isNotDistr];
isNotDistr[strand: StrandP] := !StrandQ[strand, Degeneracy->False];
isNotDistr[_] := True;


resolveReturnEnt[structures_] := AllTrue[Flatten[structures], isNotDistr];


resolveReturnMT[enth_, entr_, conc_] := AllTrue[Join[{enth, entr}, parseConc[conc]], isNotDistr];
resolveReturnMT[structures_, conc_] := AllTrue[Join[Flatten[structures], parseConc[conc]], isNotDistr];


resolveReturnFE[enth_, entr_, temp_] := AllTrue[{enth, entr, temp}, isNotDistr];
resolveReturnFE[structures_, temp_] := AllTrue[Append[Flatten[structures], temp], isNotDistr];


resolveReturnEC[enth_, entr_, temp_] := AllTrue[{enth, entr, temp}, isNotDistr];
resolveReturnEC[structures_List, temp_] := AllTrue[Append[Flatten[structures], temp], isNotDistr];
resolveReturnEC[fe_, temp_] := AllTrue[{fe, temp}, isNotDistr];



(* ::Subsection:: *)
(*Parameters*)

(* ::Subsubsection:: *)
(*parameter sets*)

(* Helper function to find the stacking information rules from thermodynamicParameters function which returns distribution for degenerate cases *)
ClearAll[];

getThermodynamicParameterRules[polList_List,property_,degeneracy_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{},
	Join@@Map[
		addPolymerTypeToRuleFields[
			getThermodynamicParameterRules[#,property,degeneracy,resolvedOptions],#,resolvedOptions
		]&,DeleteDuplicates[polList]
	]
];

getThermodynamicParameterRules[pol_Symbol,property_,degeneracy_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{degenParams, degenDistr,referenceOligomer},

	degenParams=Physics`Private`thermodynamicParameters[pol,property,Stacking,Unitless->Automatic,Degeneracy->False,Sequence@@resolvedOptions];

	(* take first pairing rule. this is temp.  in future will look at both sides. *)
	degenDistr = Map[toDistributed[takeFirstThermoParam[#]]&,degenParams];

	Join[
		degenDistr,
		junctionHybridParmaeters[pol,property,resolvedOptions],
		{toDistributed[takeFirstThermoParam[2->Lookup[degenParams,"NN"]]]} (* for sequence lengths *)
	]
];


takeFirstThermoParam[Rule[name_,list_List]]:=Rule[name,list[[1,2]]];
takeFirstThermoParam[Rule[name_,val_]]:=Rule[name,val];


toDistributed[in: Rule[left_, right: DistributionP[]]] := Distributed[left, right];
toDistributed[in_] := in;

(* Helper function to add the polymer head to the values coming out of thermodynamicParameters *)
addPolymerTypeToRuleFields[ruleList_,pol_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=addPolymerTypeToRuleFields[ruleList,pol,resolvedOptions]=Module[
	{referenceOligomerRule},

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomerRule[polymer_]:=Module[
		{alternativeParameterizationModel},
		alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[polymer,AlternativeParameterization],(#[Model] == Thermodynamics &)];
		If[Lookup[resolvedOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
			polymer->Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
			{}
		]
	];

	(* If AlternativeParameterization is used and we have the model then use the referenceOligomer head *)
	MapAt[(pol /. referenceOligomerRule[pol]),ruleList,{All,1}]
];

(** NOTE: We need to define these since there is no T in RNA and no U in DNA - look at junctionHybridDimerSubstitutions **)
(** TODO: not sure if i understand this? isn't it just ReverseComplementSequence[]? **)

(* The first dimer that hybridizes with a specific dimer for DNA *)
firstHybridDimer[DNA]:=
	{
		"AT"->"AT",
		"CT"->"AG",
		"GT"->"AC",

		"TA"->"TA",
		"TC"->"GA",
		"TG"->"CA"
	};

(* The first dimer that hybridizes with a specific dimer for DNA *)
firstHybridDimer[RNA]:=
	{
		"UA"->"UA",
		"UC"->"GA",
		"UG"->"CA",

		"AU"->"AU",
		"CU"->"AG",
		"GU"->"AC"
	};

(** TODO: These will inquire unmatched dimer info in the stacking field - only RNA seems to have those **)

junctionHybridParmaeters[pol_,property_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=
	Module[
		{},

		Map[
			#[[1]]->

			Unitless@Switch[{pol,property},
				(* Two strands of DNA *)
				{DNA,\[CapitalDelta]G}|{DNA,\[CapitalDelta]H}|{DNA,\[CapitalDelta]S},
				Cases[
					Physics`Private`lookupModelThermodynamics[pol,property,Stacking,Sequence@@resolvedOptions][[1]],
					{DNA[#[[2]]], DNA[#[[2]]/.firstHybridDimer[DNA]], x_Quantity} :> x
				] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

				(* Binding of DNA to RNA *)
				(** TODO: check -- These can't exist as the #[[2]]/.firstHybridDimer[RNA] is DNA base **)

				(* Two strands of RNA *)
				{RNA,\[CapitalDelta]G}|{RNA,\[CapitalDelta]H}|{RNA,\[CapitalDelta]S},
				Cases[
					Physics`Private`lookupModelThermodynamics[pol,property,Stacking,Sequence@@resolvedOptions][[1]],
					{RNA[#[[2]]], RNA[#[[2]]/.firstHybridDimer[RNA]], x_Quantity} :> x
				] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

				(* Binding of RNA to DNA *)
				(** TODO: check -- These can't exist as the #[[2]]/.firstHybridDimer[RNA] is RNA base **)

				_,
				0.0 Physics`Private`thermoUnit[property]
			]&,

			junctionHybridDimerSubstitutions[pol]
		]
	];


junctionHybridDimerSubstitutions[DNA]={
		"AU"->"AT",
		"CU"->"CT",
		"GU"->"GT",

		"UA"->"TA",
		"UC"->"TC",
		"UG"->"TG"
	};

junctionHybridDimerSubstitutions[RNA]={
		"TA"->"UA",
		"TC"->"UC",
		"TG"->"UG",

		"AT"->"AU",
		"CT"->"CU",
		"GT"->"GU"
	};

junctionHybridDimerSubstitutions[_]={
	};

(* ::Subsubsection::Closed:: *)
(*resolveTemperature*)

resolveTemperature[temp: UnitsP["DegreesCelsius"]] := QuantityDistribution[EmpiricalDistribution[Unitless[UnitConvert[{N[temp]}, "Kelvins"]]], "Kelvins"];
resolveTemperature[temp: DistributionP["DegreesCelsius"]] := UnitConvert[temp, "Kelvins"];



(* ::Subsubsection:: *)
(*resolveConcentration*)

resolveConcentration[conc: UnitsP["Molar"] | DistributionP["Molar"], reaction_, ops_] := Module[
	{concDistr, reactants, concOut, rxnType, concC},
	concDistr = resolveOneConcentration[conc];
	reactants = resolveReactants[reaction];
	concOut = {
		Concentration -> ({#, Mean[concDistr]} & /@ reactants),
		ConcentrationStandardDeviation -> ({#, StandardDeviation[concDistr]} & /@ reactants),
		ConcentrationDistribution -> ({#, concDistr} & /@ reactants)
	};
	rxnType = reactionType[reaction];
	concC = concentrationCorrection[{concDistr}, rxnType];
	{concC, concOut}
];

resolveConcentration[conc_List, reaction_, ops_] := Module[
	{species, distrs, structures, reactants, concDistr, concOut, rxnType, concC},
	If[Length[conc] > 2, Message[Error::IncorrectConcentration]; Return[Null]];
	species = First /@ conc;
	distrs = resolveOneConcentration[Last[#]] & /@ conc;
	structures = getStructure[#, ops] & /@ species;
	reactants = resolveReactants[reaction];
	If[!AllTrue[structures, MemberQ[reactants, #] &], Message[Error::IncorrectConcentration]; Return[Null]];
	concDistr = concentrationCorrection[distrs, Last[reaction]];
	concOut = {
		Concentration->MapThread[{#1, Mean[#2]} &, {structures, distrs}],
		ConcentrationStandardDeviation->MapThread[{#1, StandardDeviation[#2]} &, {structures, distrs}],
		ConcentrationDistribution->MapThread[{#1, #2} &, {structures, distrs}]
	};
	rxnType = reactionType[reaction];
	concC = concentrationCorrection[distrs, rxnType];
	{concC, concOut}
];


reactionType[Null] := "Null";
reactionType[reaction: Reaction[reactant_, product_, Unknown | Unchanged]] := "Null";
reactionType[reaction: Reaction[reactant_, product_, ___, Folding | Melting]] := "Folding";
reactionType[reaction: Reaction[reactant_, product_, ___, Hybridization | Dissociation]] := If[SameQ[Sequence @@ reactant], "Self-complimentary", "Nonself-complimentary"];


resolveOneConcentration[conc: UnitsP["Molar"]] := QuantityDistribution[EmpiricalDistribution[Unitless[UnitConvert[{N[conc]}, "Molar"]]], "Molar"];
resolveOneConcentration[conc: DistributionP["Molar"]] := UnitConvert[conc, "Molar"];


resolveReactants[reaction_Reaction] := NucleicAcids`Private`reactionToReactants[reaction];
resolveReactants[reaction: Null] := {Null};


resolveTwoConcentrations[{distr1_, distr1_}] := PropagateUncertainty[distr1 / 2];
resolveTwoConcentrations[{distr1_, distr2_}] /; Mean[distr1] < Mean[distr2] := PropagateUncertainty[distr2 - distr1 / 2];
resolveTwoConcentrations[{distr1_, distr2_}] /; Mean[distr1] >= Mean[distr2] := PropagateUncertainty[distr1 - distr2 / 2];


concentrationCorrection[{conc_}, "Null"] := conc;
concentrationCorrection[conc: {conc1_}, "Folding"] := QuantityDistribution[EmpiricalDistribution[{1}], Molar]; (* to cancel out the concentration term (RInCt) in melting temperature calculation *)
concentrationCorrection[conc: {conc1_}, rxnType_] := concentrationCorrection[{conc1, conc1}, rxnType];
concentrationCorrection[conc: {conc1_, conc1_}, "Self-complimentary"] := conc1;
concentrationCorrection[conc: {conc1_, conc1_}, "Nonself-complimentary"] := resolveTwoConcentrations[{conc1, conc1}];
concentrationCorrection[conc: {conc1_, conc2_}, "Nonself-complimentary"] := resolveTwoConcentrations[{conc1, conc2}];



(* ::Subsubsection::Closed:: *)
(*resolveEnthalpy*)

resolveEnthalpy[enth: UnitsP[KilocaloriePerMole]] := QuantityDistribution[EmpiricalDistribution[{Unitless[enth, KilocaloriePerMole]}], KilocaloriePerMole];
resolveEnthalpy[enth: DistributionP[KilocaloriePerMole]] := propagateResult[enth, KilocaloriePerMole];



(* ::Subsubsection::Closed:: *)
(*resolveEntropy*)

resolveEntropy[entr: UnitsP[CaloriePerMoleKelvin]] := QuantityDistribution[EmpiricalDistribution[{Unitless[entr, CaloriePerMoleKelvin]}], CaloriePerMoleKelvin];
resolveEntropy[entr: DistributionP[CaloriePerMoleKelvin]] := propagateResult[entr, CaloriePerMoleKelvin];



(* ::Subsubsection::Closed:: *)
(*resolveFreeEnergy*)

resolveFreeEnergy[freeEnergy: UnitsP[KilocaloriePerMole]] := QuantityDistribution[EmpiricalDistribution[{Unitless[freeEnergy, caloriePerMoleString]}], caloriePerMoleString];
resolveFreeEnergy[freeEnergy: DistributionP[KilocaloriePerMole]] := propagateResult[freeEnergy, caloriePerMoleString];



(* ::Subsubsection::Closed:: *)
(*propagateResult*)

propagateResult[quant_, unit_] := Module[
	{scale},
	scale = Unitless[UnitConvert[QuantityUnit[quant], unit]];
	If[
		MatchQ[scale, 1],
		quant,
		QuantityDistribution[PropagateUncertainty[Evaluate[scale * QuantityMagnitude[quant]]], unit]
	]
];



(* ::Subsection::Closed:: *)
(*Parsing Salt Concentration*)

(* ::Subsubsection::Closed:: *)
(*saltConcentrationFromProtocol*)

saltConcentrationFromProtocol[packet:PacketP[Object[Protocol,UVMelting]]]:=Module[{bufferSamples,bufferSamplesAssoc,saltConcAssoc},
	bufferSamples = Lookup[packet,BufferSamples];
	bufferSamplesAssoc = Association[Rule@@@bufferSamples[[All,1;;2]]];
	saltConcAssoc = Map[saltConcentrationFromStockSolution,bufferSamplesAssoc];
	saltConcAssoc
];



(* ::Subsubsection::Closed:: *)
(*satlConcentrationFromOligomerObject*)

satlConcentrationFromOligomerObject[obj:ObjectP[Object[Sample]]]:=With[
	{bufferModel=(obj[BufferModel])},
	If[MatchQ[bufferModel,ObjectP[Model[Sample, StockSolution]]],
		saltConcentrationFromStockSolution[bufferModel],
		Automatic
	]
];



(* ::Subsubsection:: *)
(*saltConcentrationFromStockSolution*)

saltConcentrationFromStockSolution[stockSolSample: ObjectP[Object[Sample]]]:=saltConcentrationFromStockSolution[Download[stockSolSample,Model]];
saltConcentrationFromStockSolution[stockSolModel: ObjectP[Model[Sample, StockSolution]]]:=Module[{formula,saltAmounts,totalVols},
	formula = Download[stockSolModel, Formula];
	saltAmounts = Map[getSaltAmount, formula];
	totalVols = Map[getAllVolume, formula];
	UnitConvert[Total[Flatten[saltAmounts]]/Total[totalVols],"Millimolar"]
];



(* ::Subsubsection:: *)
(*getSaltAmount*)

getSaltAmount[{mass_, obj: Model[Sample, "Dibasic Sodium Phosphate"] | Model[Sample,"id:wqW9BP4Y06oR"]}]:= With[{
		(* Dibasic Sodium Phosphate should always have a single Model[Molecule] in its Composition, so just take the first *)
		weight = First[Download[obj, Composition[[All,2]][MolecularWeight]]]
	},
	mass / weight
];
getSaltAmount[{thisVolume:VolumeP,obj: ObjectP[Model[Sample, StockSolution]]}]:=With[{
		saltAmountComponents = Map[getSaltAmount, Download[obj, Formula]],
		unitSolutionVolume = Total[Map[getAllVolume, Download[obj, Formula]]]
	},
		saltAmountComponents * thisVolume/unitSolutionVolume
];
getSaltAmount[{amount_,link_Link}] := getSaltAmount[{amount, link[Object]}];
getSaltAmount[_]:= 0.0*Mole;



(* ::Subsubsection::Closed:: *)
(*getAllVolume*)

getAllVolume[{amount:VolumeP,obj: ObjectP[Model[Sample]]}]:= amount;
getAllVolume[_]:= 0.0*Liter;



(* ::Subsubsection::Closed:: *)
(*parseSaltConcentrationFromBuffer*)

parseSaltConcentrationFromBuffer[buffer: ObjectP[Model[Sample, StockSolution]] | ObjectP[Object[Sample]]]:={saltConcentrationFromStockSolution[buffer],0.0*Molar};
parseSaltConcentrationFromBuffer[buffer: ObjectP[Model[Sample]]]:={minSaltConc,0.0*Molar};



(* ::Subsection:: *)
(*Thermodynamics*)

(* ::Subsubsection:: *)
(*nearestNeighborThermodynamics*)

nearestNeighborThermodynamics::BadStrand="All strand motifs must be the same polymer type with the exception of one Modification at the beginning or end.";
nearestNeighborThermodynamics::BadParameterSet="Given parameter set `1` is not valid for the given strand `2`";


(* these default values shouldn't really matter because the calling functions always fully specify all options *)
Options[nearestNeighborThermodynamics]=
	{
		Parameters->Automatic,
		MonovalentSaltConcentration->0.05*Molar,
		DivalentSaltConcentration->0.0*Molar,
		Degeneracy->True,
		ThermodynamicsModel->Automatic,
		AlternativeParameterization->Automatic
	};


nearestNeighborThermodynamics[structures:{{_Structure,_Structure}..},property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:=
	Map[nearestNeighborThermodynamics[#,property,ops]&,structures];


nearestNeighborThermodynamics[{structureBefore_Structure,structureAfter_Structure},property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:=
	nearestNeighborThermodynamics[structureBefore,structureAfter,property,ops];


nearestNeighborThermodynamics[reactions:{_Reaction..},property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:=
	Map[nearestNeighborThermodynamics[#,property,ops]&,reactions];

nearestNeighborThermodynamics[reaction_Reaction,property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:=Module[
	{rxnIrr, structureBefore,structureAfter},
	(* reaction must be irreversible here, otherwise this won't work *)
	rxnIrr = toIrreversibleReaction[reaction];
	structureBefore = StructureJoin@@NucleicAcids`Private`reactionToReactants[rxnIrr];
	structureAfter = StructureJoin@@NucleicAcids`Private`reactionToProducts[rxnIrr];
	nearestNeighborThermodynamics[structureBefore,structureAfter,property,ops]
];


nearestNeighborThermodynamics[structureBefore_Structure,structureAfter_Structure,property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:=Module[
	{outBefore,outAfter,bimolecular,OA,OB},

	(* Output of NN thermodynamics for the reactants *)
	outBefore = nearestNeighborThermodynamics[structureBefore,property,ops];

	(* Output of NN thermodynamics for the products *)
	outAfter = nearestNeighborThermodynamics[structureAfter,property,ops];

	PropagateUncertainty[OA - OB, {OA\[Distributed]outAfter, OB\[Distributed]outBefore}]
];


(* memoize these calls *)
nearestNeighborThermodynamics[structure_Structure,property:(\[CapitalDelta]H|\[CapitalDelta]S|\[CapitalDelta]G),ops:OptionsPattern[]]:= nearestNeighborThermodynamics[structure,property,ops] = Module[
	{strs0,strs,monoSaltMolar,diSaltMolar,strandPols,exprs,paramRules,saltRules,stats, strsDe, distrs,
	thermoParamRules,bimolecular, strTerm, faceTypes,
	allMonomers,facesList,faceScores},

	{monoSaltMolar,diSaltMolar}=QuantityMagnitude[UnitConvert[OptionValue[{MonovalentSaltConcentration,DivalentSaltConcentration}],"Molar"]];

	(* if hybridization, use the following calculation *)
	faceTypes = Intersection[Intersection[ToExpression/@First/@StructureFaces[structure], DeleteCases[List@@LoopTypeP,StackingLoop]]];

	(* Only take ThermodynamicsModel and AlternativeParameterization option to send to hybTerm that is eventually used for lookupModelThermodynamics *)
	If[faceTypes==={},Return[hybTerm[structure, monoSaltMolar, diSaltMolar, property, FilterRules[ToList[ops],{ThermodynamicsModel,AlternativeParameterization}]]]];

	(* apply thermo loop parameters to accurate predict deltaG and deltaH, then compute deltaS *)
	strTerm = If[And@@StrandQ[structure[Strands], Degeneracy->False],
		structureTerm[StructureSort[structure], property, FilterRules[ToList[ops],{ThermodynamicsModel,AlternativeParameterization}]],
		EmpiricalDistribution[{0.0}]
	];

	safeConsolidate[{strTerm}, property]

];

(* The function that calculates the property associated with the hybridization - used when there are no faceTypes *)
hybTerm[structure_Structure, monoSaltMolar_, diSaltMolar_, property_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{
		strs0, strandPols, strs, bimolecular, strsDe, thermoParamRules, saltRules, distrs,
		alternativeThermoParamRules
	},

	(* if hybridization, use the following calculation *)
	strs0 = getAllStrs0[structure];

	strandPols = getAllUniqueMotifPols[strs0];

	strs = cleanStrandPolymers[strs0];

	bimolecular = Length[strs];
	strsDe = Map[deDegenerate, strs];

	(* Getting thermodynamic parameter rules from thermodynamicParameters in the physics context so we can evaluate distributions for degenerate alphabet *)
	thermoParamRules = thermodynamicParameterRules[strandPols,strs,property,{monoSaltMolar,diSaltMolar},True,resolvedOptions];

	(* Getting thermodynamic parameter rules from thermodynamicParameters in the physics context so we can evaluate distributions for degenerate alphabet *)
	alternativeThermoParamRules = If[Lookup[resolvedOptions,AlternativeParameterization],
		alternativeThermodynamicParameterRules[strandPols,strs,property,{monoSaltMolar,diSaltMolar},True,resolvedOptions],
		{}
	];

	(* salt correction is dependent on bond length, so get a different salt correction for each bonded region *)
	saltRules = Map[getSaltCorrectionRules[#,property,monoSaltMolar,diSaltMolar]&,strs];

	(* Find the expressions for the NN calculations and calculate based on the rules from thermodynamicParameters *)
	distrs = MapThread[
		calculateFromStrandList[#1, property, bimolecular, Join[thermoParamRules,alternativeThermoParamRules,#2], resolvedOptions] &,
		{strsDe,saltRules}
	];

	safeConsolidate[distrs, property]

];


toIrreversibleReaction[reaction: Reaction[{reactants__}, {products__}, _]] := reaction;
toIrreversibleReaction[reaction: Reaction[{reactants__}, {products__}, _, _]] := Most[reaction];


safeConsolidate[{}, \[CapitalDelta]G] := QuantityDistribution[EmpiricalDistribution[{0.0}], KilocaloriePerMole];
safeConsolidate[{}, \[CapitalDelta]H] := QuantityDistribution[EmpiricalDistribution[{0.0}], KilocaloriePerMole];
safeConsolidate[{}, \[CapitalDelta]S] := QuantityDistribution[EmpiricalDistribution[{0.0}], CaloriePerMoleKelvin];
safeConsolidate[distrs: {DistributionP[]}, \[CapitalDelta]G] := QuantityDistribution[First[distrs], KilocaloriePerMole];
safeConsolidate[distrs: {DistributionP[]}, \[CapitalDelta]H] := QuantityDistribution[First[distrs], KilocaloriePerMole];
safeConsolidate[distrs: {DistributionP[]}, \[CapitalDelta]S] := QuantityDistribution[First[distrs], CaloriePerMoleKelvin];
safeConsolidate[distrs: {DistributionP[]..}, \[CapitalDelta]G] := QuantityDistribution[PropagateUncertainty[Total[distrs]], KilocaloriePerMole];
safeConsolidate[distrs: {DistributionP[]..}, \[CapitalDelta]H] := QuantityDistribution[PropagateUncertainty[Total[distrs]], KilocaloriePerMole];
safeConsolidate[distrs: {DistributionP[]..}, \[CapitalDelta]S] := QuantityDistribution[PropagateUncertainty[Total[distrs]], CaloriePerMoleKelvin];

(* Helper function which calculates the total of terms based on the expressions in exprs and the rules which converts the exprs to values *)
calculateFromStrandList[strs: {_Strand..}, property_, bimolecular_, rules_,resolvedOptions:{(_Rule|_RuleDelayed)..}] := Module[
	{exprs,alternativeExprs,strandPols,referenceOligomerRule,substitutionRules,referenceOligomerRuleList},

	(* The expressions to include in the nearest neighbor thermo calculations *)
	exprs = Map[nearestNeighborThermodynamicsExpression[{{#}},property,bimolecular,resolvedOptions] &, strs];

	(* Polymers associated with the list of strands *)
	strandPols = getAllMotifPolymers[strs];

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomerRule[pol_]:=Module[
		{alternativeParameterizationModel},
		alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)];
		If[Lookup[resolvedOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
			pol->Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
			{}
		]
	];

	(* Find the reference oligomer which is used for alternative parameterization *)
	substitutionRules[pol_]:=Module[
		{alternativeParameterizationModel},
		alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)];
		If[Lookup[resolvedOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
			First[alternativeParameterizationModel][SubstitutionRules],
			{}
		]
	];

	(* The list of reference oligomer rules *)
	referenceOligomerRuleList=Map[referenceOligomerRule[#]&,Flatten@strandPols];

	(* The list of substitution rules *)
	substitutionRulesList=Flatten@Map[substitutionRules[#]&,Flatten@strandPols];

	(* If the result is empty we don't have the information try to search for AlternativeParameterization *)
	EmpiricalDistribution[
		(* Mapping over the expressions *)
		MapIndexed[
			Function[{expression,expressionIndex},
				Module[
					{value},

					(* First look at the rules and see if we have it there *)
					value=(expression /. rules);

					(* Substituting the oligomer if AlternativeParameterization is used and using substitutionRules *)


					(* If you didn't find it, search the alternative rules *)
					alternativeValue=If[Lookup[resolvedOptions,AlternativeParameterization],
						(* If something doesn't exist in the original param set, use the alternative set\= *)
						If[ !NumericQ[value],
							(value /. Join[referenceOligomerRuleList,substitutionRulesList]) /. rules,
							value
						],
						value
					];

					alternativeValue
				]
			],exprs

		] /. {} -> {0.0}

	]


	(* EmpiricalDistribution[
		Map[(# /. rules) &, exprs] /. {} -> {0.0}
	] *)

];


getAllStrs0[structure_]:=NucleicAcids`Private`structureBondsToStrands[NucleicAcids`Private`consolidateBonds[NucleicAcids`Private`reformatBonds[structure,StrandBase]]];
getAllUniqueMotifPols[strs0_]:=DeleteDuplicates[Map[MotifPolymer,Flatten[List@@@Flatten[strs0]]]];

(* Dereference thermodynamic parameter values - add reference oligomers params if AlternativeParameterization is true *)
thermodynamicParameterRules[strandPols_,strs_,property_,{monoSaltMolar_,diSaltMolar_},degeneracy_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{paramRules},

	paramRules = getThermodynamicParameterRules
		[DeleteCases[strandPols,Blank[#]&/@Alternatives@@knownPolymerTypes],property,degeneracy,
		(* Override AlternativeParameterization we don't want to take the referenceOligomer data *)
		ReplaceRule[resolvedOptions,AlternativeParameterization->False]
	];

	paramRules
];

(* Dereference thermodynamic parameter values - add reference oligomers params if AlternativeParameterization is true *)
alternativeThermodynamicParameterRules[strandPols_,strs_,property_,{monoSaltMolar_,diSaltMolar_},degeneracy_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{paramRules},

	paramRules = getThermodynamicParameterRules[
		DeleteCases[strandPols,Blank[#]&/@Alternatives@@knownPolymerTypes],property,degeneracy,
		(* Override AlternativeParameterization we want to take the referenceOligomer data *)
		ReplaceRule[resolvedOptions,AlternativeParameterization->True]
	];

	paramRules
];

cleanStrandPolymers[strs:{{_Strand...}...}]:=Module[{},

	(* delete ignorable things (mods) and then any empty strands *)
	DeleteCases[
		DeleteCases[
			strs,
			Except[Blank[#]&/@supportedPolymerP],
			{3}
		],
		Strand[],
		{2}
	]

];


structureToStrandGraph[structure:Structure[strands_,bonds_]]:=Module[{nodes,edges},
	nodes = Range[Length[strands]];
	edges = DeleteDuplicates[Sort/@(bonds/.{Bond[{a_,___},{b_,___}]:>a<->b})];
	Graph[nodes,edges]
];
numberOfBimolecularInitiations[structure:Structure[strands_,bonds_]]:=Module[{g},
	g = structureToStrandGraph[structure];
	Length[strands] - Length[ConnectedComponents[g]]
];


knownPolymerTypes={DNA,RNA,LRNA,LNAChimera};
ignorablePolymerTypes={Modification};
(* supportedPolymerP = Alternatives@@Join[knownPolymerTypes,ignorablePolymerTypes]; *)
supportedPolymerP = Alternatives@@AllPolymersP;
unsupportedPolymerP = Except[supportedPolymerP];


unsupportedStrandPolymersQ[structure:Structure[strands_,_],functionName_]:=
	unsupportedStrandPolymersQ[{strands},functionName];

unsupportedStrandPolymersQ[strs:ListableP[_Strand,2],functionName_]:=Module[{strandPols},

	strandPols = DeleteDuplicates[Map[MotifPolymer,Flatten[List@@@Flatten[ToList[strs]]]]];

	(* complain and exit if contains any polymers we don't have parameters for *)
	If[MemberQ[strandPols,unsupportedPolymerP],
		(
			Message[Error::UnsupportedPolymers,DeleteDuplicates[DeleteCases[strandPols,supportedPolymerP]]];
			True
		),
		False
	]
];

(*unsupportedStrandPolymersQ[structure:Structure[strands_,_],functionName_]:=False*)

(* ::Subsubsection:: *)
(*nearestNeighborThermodynamicsExpression*)


nearestNeighborThermodynamicsExpression[strs:({{}}|{}),\[CapitalDelta]G,bimolecular_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=0.0;
nearestNeighborThermodynamicsExpression[strs:({{}}|{}),\[CapitalDelta]H,bimolecular_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=0.0;
nearestNeighborThermodynamicsExpression[strs:({{}}|{}),\[CapitalDelta]S,bimolecular_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=0.0;
nearestNeighborThermodynamicsExpression[strs:{{_Strand..}..},property_,bimolecular_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[{expressionList},
	expressionList = Map[thermodynamicsExpressionCore[#,bimolecular,resolvedOptions]&,strs];
	Total[expressionList] + SaltCorrection
];

(* Helper function which creates the expression for thermodynamic terms including initial and terminal corrections *)
thermodynamicsExpressionCore[strs:{_Strand..},bimolecular_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{
		strandPols,middleVals,initVal,startVal,endVal,junctionVals,saltAdjustment,expr,symmVals
	},

	strandPols = getAllMotifPolymers[strs];

	middleVals=Map[thermodynamicsMiddle[#]&,List@@@strs,{2}];

	symmVals = (bimolecular/Length[strs]) * Map[thermodynamicsSymmetry,List@@@strs,{2}];

	initVal = Table[Mean/@Map[thermodynamicsInit[#]&,strandPols,{2}],{1}];

	startVal= MapThread[thermodynamicsTerm[First[#2]@sequenceFirstFast[First[#2],First[#1]]]&,{strs,strandPols}];

	endVal= MapThread[thermodynamicsTerm[Last[#2]@sequenceLastFast[Last[#2],Last[#1]]]&,{strs,strandPols}];

	junctionVals = getAllThermoJunctions[strs];

	expr=getFinalExpression[middleVals,junctionVals,symmVals,initVal,startVal,endVal];

	expr
];


getAllMotifPolymers[strs_]:=Map[MotifPolymer,List@@@strs,{2}];
getAllThermoJunctions[strs_]:=Function[str,Map[thermodynamicsJunction[#]&,strandJunctions[str]]]/@strs;
getFinalExpression[middleVals_,junctionVals_,symmVals_,initVal_,startVal_,endVal_]:=
	Total[Flatten[{middleVals,junctionVals,symmVals,initVal,startVal,endVal}]];


(* ::Subsubsection::Closed:: *)
(*strandJunctions*)


(*
 * Takes in a Strand.
 * Returns a list of junctions. Each junction consists of {the 5' side's type, the junction pair in 5'->3' form, the 3' side's type}
 *)

Authors[strandJunctions]:={"scicomp", "brad"};

strandJunctions[str_Strand]:=MapThread[splitOneJunction,{Most[List@@str],Rest[List@@str]}];

splitOneJunction[polLeft_[seqLeft_String,Repeated[_String,{0,1}]],polRight_[seqRight_String,Repeated[_String,{0,1}]]]:=
		{polLeft,StringJoin[SequenceLast[seqLeft],SequenceFirst[seqRight]],polRight};
splitOneJunction[polLeft_[lengthLeft_Integer,Repeated[_String,{0,1}]],polRight_[seqRight_String,Repeated[_String,{0,1}]]]:=
		{polLeft,StringJoin["N",SequenceFirst[seqRight]],polRight};
splitOneJunction[polLeft_[seqLeft_String,Repeated[_String,{0,1}]],polRight_[lengthRight_Integer,Repeated[_String,{0,1}]]]:=
		{polLeft,StringJoin[SequenceFirst[seqLeft],"N"],polRight};
splitOneJunction[polLeft_[lengthLeft_Integer,Repeated[_String,{0,1}]],polRight_[lengthRight_Integer,Repeated[_String,{0,1}]]]:=
		{polLeft,"NN",polRight};



thermodynamicsMiddle[pol_[seq_String,Repeated[_String,{0,1}]]]:=Total[Map[pol,dimersFast[pol,seq]]];
thermodynamicsMiddle[pol_[length_Integer,Repeated[_String,{0,1}]]]:=(length-1)*pol[2];
thermodynamicsInit[pol_]:=pol[Init];
thermodynamicsTerm[pol_[seq_String,Repeated[_String,{0,1}]]]:=pol[Term]*termCorrection[seq,pol];
thermodynamicsTerm[pol_[length_Integer,Repeated[_String,{0,1}]]]:=pol[Term];
thermodynamicsJunction[{polLeft_,dim_,polRight_}]:=Mean[thermodynamicsMiddle[#]&/@{polLeft[dim],polRight[dim]}];
thermodynamicsSymmetry[pol_[seq_String,Repeated[_String,{0,1}]]]:=If[sequencePalindromeFast[pol,seq],pol[Symmetry],0];
thermodynamicsSymmetry[pol_[length_Integer?OddQ,Repeated[_String,{0,1}]]]:=0;
thermodynamicsSymmetry[pol_[length_Integer?EvenQ,Repeated[_String,{0,1}]]]:=pol[Symmetry]*(4^(length/2)/4^length);

dimersFast[DNA|RNA|PNA,seq_String]:=StringPartition[seq, 2, 1];
dimersFast[pol_,seq_String]:=Dimers[seq,Polymer->pol,FastTrack->True];

sequenceFirstFast[DNA|RNA|PNA,h_[s_String]]:=StringFirst[s];
sequenceFirstFast[DNA|RNA|PNA,other_]:=SequenceFirst[other,ExplicitlyTyped->False];

(* The overload for any valid oligomer type - with the header *)
sequenceFirstFast[oligomer:PolymerP,h_[s_String]]:=SequenceFirst[s];
(* The overload for any valid oligomer type - without the header *)
sequenceFirstFast[oligomer:PolymerP,other_]:=SequenceFirst[other,ExplicitlyTyped->False];

sequenceLastFast[DNA|RNA|PNA,h_[s_String]]:=StringLast[s];
sequenceLastFast[DNA|RNA|PNA,other_]:=SequenceLast[other,ExplicitlyTyped->False];

(* The overload for any valid oligomer type - with the header *)
sequenceLastFast[oligomer:PolymerP,h_[s_String]]:=SequenceLast[s];
(* The overload for any valid oligomer type - without the header *)
sequenceLastFast[oligomer:PolymerP,other_]:=SequenceLast[other,ExplicitlyTyped->False];

sequencePalindromeFast[pol:(DNA|RNA|PNA),seq_String]:=And[
	EvenQ[StringLength[seq]],
	SameQ[seq,sequenceRevCompFast[pol,seq]]
];
sequencePalindromeFast[pol_,seq_]:=SequencePalindromeQ[seq,Polymer->pol,FastTrack->True];



sequenceRevCompFast[pol:(DNA|RNA|PNA),seq_]:=
	StringReplace[
		StringReverse[seq],
		Physics`Private`lookupModelOligomer[pol,Complements]
	];
sequenceRevCompFast[pol_,seq_]:=ReverseComplementSequence[seq,Polymer->pol];



(* ::Subsubsection::Closed:: *)
(*deDegenerate*)

deDegenerate[{strand_Strand}] := If[
	StrandQ[strand] && !StrandQ[strand, Degeneracy->False],
	Flatten[Outer[Strand, Map[deDegenerateOnePolymer, strand] /. Strand->Sequence]],
	{strand}
];

deDegenerateOnePolymer[pol: _DNA | _RNA] := Module[
	{strList, strLen, ruleAll, degRule, degRuleExpanded, degCounts, numOfAllP, replaceRule},

	(* partition sequence string to a list of bases *)
	strList = StringPartition[StringReplace[First[pol], "X" -> ""], 1];

	(* get representation rules of all possible bases *)
	ruleAll = Physics`Private`lookupModelOligomer[PolymerType[pol],DegenerateAlphabet];

	(* count number of baese each letter can represent *)
	degCounts = ruleAll /. Rule[x_, y_List] :> Rule[x, Length[y]];

	(* calculate size of full permutation *)
	numOfAllP = Times @@ (strList /. degCounts);

	(* decide if do full permutation (size no greater than 1024) or sampling *)
	If[numOfAllP > 1024, degenerateSampling[strList, ruleAll], degeneratePermutation[strList, ruleAll]]
];


degeneratePermutation[bp_, ruleAll_] := StringJoin /@ Partition[Flatten[Outer[List, Sequence @@ (bp /. ruleAll)]], Length[bp]];


degenerateSampling[bp_, ruleAll_] := Module[
	{randomN},
	randomN = Table[RandomReal[1, Length[bp]], 1024];
	StringJoin /@ Map[MapThread[decideOneBase[#1, #2 /. ruleAll] &, {#, bp}] & , randomN]
];


decideOneBase[num_, candidates: {a_, b_, c_, d_}] := Which[
	num < 0.25, a,
	num < 0.5, b,
	num < 0.75, c,
	True, d
];
decideOneBase[num_, candidates: {a_, b_, c_}] := Which[
	num < N[1/3], a,
	num < N[2/3], b,
	True, c
];
decideOneBase[num_, candidates: {a_, b_}] := Which[
	num < 0.5, a,
	True, b
];
decideOneBase[num_, candidates: {a_}] := a;



(* ::Subsubsection::Closed:: *)
(*termCorrection*)

(* Helper to find the number of certain monomers to multiply the initial and terminal correction used in the thermodynamicsExpressionCore *)
termCorrection[base_String,type:PolymerP]:=termCorrection[base,type] = Module[{replacements,options},

	(* generate a list of rules that replaces the monome with a list of possibilities *)
	replacements=replacementPolymerRules[type];

	(* generate a list of the possible Monomers that could be represented by the base *)
	options=base/.replacements;

	(* Return the ratio of A's T's or U's that the degenerate base could represent *)
	Switch[type,
		DNA|RNA,
		Count[options,"A"|"T"|"U"]/Length[options],

		(* For LNAChimera, use the monomers that contain any of the A T and U inherently *)
		LRNA|LNAChimera,
		Count[options,_?(StringContainsQ[#,"A"|"T"|"U"] &)]/Length[options],

		(* For now, use the same approach for other oligomers *)
		_,
		Count[options,"A"|"T"|"U"]/Length[options]
	]

];

replacementPolymerRules[type_]:=replacementPolymerRules[type] = Physics`Private`lookupModelOligomer[type,DegenerateAlphabet];


(* ::Subsubsection::Closed:: *)
(*getSaltCorrectionRules*)

minSaltConcValue=0.01;
maxSaltConcValue=1.0;


getSaltCorrectionRules[strs:{{_Strand...}...},\[CapitalDelta]H,monoSaltConcMolar_,diSaltConcMolar_]:={SaltCorrection->0.0};
getSaltCorrectionRules[strs:{{_Strand...}...},\[CapitalDelta]G,monoSaltConcMolar_,diSaltConcMolar_]:={SaltCorrection->0.0};

getSaltCorrectionRules[strs:{_Strand...},property_,monoSaltConcMolar_,diSaltConcMolar_]:=
	getSaltCorrectionRules[{strs},property,monoSaltConcMolar,diSaltConcMolar];

getSaltCorrectionRules[strs:{{_Strand...}...},\[CapitalDelta]S,monoSaltConcMolar_,diSaltConcMolar_]:=Module[{correctionTerm},
	(*saltExtrapolationMessage[\[CapitalDelta]S,monoSaltConcMolar,minSaltConcValue,maxSaltConcValue];*)
	correctionTerm = saltCorrectionTermEntropy[strs,monoSaltConcMolar,diSaltConcMolar];
	{SaltCorrection->correctionTerm}
];


saltCorrectionTermEntropy[strs:{{}}|{},monoSaltMolar_,diSaltMoalr_]:=0.0;
saltCorrectionTermEntropy[strs:{{_Strand...}...},monoSaltMolar:(1|1.0),diSaltMolar:(0|0.0)]:=0.0; (* no correction at 1Molar (correction evaluates to zero, but bypassing is faster *)
saltCorrectionTermEntropy[strs:{{_Strand...}...},monoSaltMolar_,diSaltMolar_]:= Module[{strLength,statsPacket},
	strLength = Total[StrandLength[Flatten[strs]]];
	(* from biophp.org, for Na & K only (not Mg).  *)
	0.368 * (strLength-1)* Log[monoSaltMolar+140*diSaltMolar]

];


(* ::Subsection:: *)
(*structure score related*)

(* ::Subsubsection:: *)
(*structureTerm*)

structureTerm[structure_Structure, property: (\[CapitalDelta]G | \[CapitalDelta]H), resolvedOptions:{(_Rule|_RuleDelayed)..}] := Module[
	{structureFaces, addOn, monomerList, pol, strTerm},

	structureFaces = Quiet@StructureFaces[structure];

	monomerList = Flatten[Monomers[structure[Strands]]];

	pol = PolymerType[First[monomerList]];

	(* check if the structure comes from hybridization to add init/term/symm *)
	addOn = If[Intersection[Intersection[ToExpression/@First/@structureFaces, DeleteCases[List@@LoopTypeP,StackingLoop]]]==={},
		(initTerm[property, pol, resolvedOptions] + termAndSymm[structure, property, pol, resolvedOptions]),
		0.0
	];

	strTerm = PropagateUncertainty[Total[structureFaceScore[#, monomerList, property, resolvedOptions] & /@ structureFaces] + addOn]
];


structureTerm[structure_Structure, \[CapitalDelta]S, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= EmpiricalDistribution[{0.0}];


(* Helper Function: finds the initial adjustment to the property when binding happens betwen two strands *)
initTerm[property_, pol_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{},

	(* This will automatically determine if it needs to take the values from referenceOligomer *)
	Physics`Private`lookupModelThermodynamicsCorrection[pol,property,Initial,Sequence@@resolvedOptions]//Unitless
];

(* Helper Function: finds the terminal and symmetry corrections to the property when binding happens betwen two strands *)
(** NOTE: The function will automatically determine if it needs to take the values from referenceOligomer **)
termAndSymm[structure_Structure, property_, pol_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{seqs, atPenalty, symmetry,referenceOligomer},

	seqs = Flatten[structure[Sequences]];

	If[Length[seqs]!=2, Return[0.0]];

	(* AT penalty *)
	atPenalty =
		If[Sort[{SequenceFirst[First[seqs]], SequenceLast[Last[seqs]]}]==={"A","T"} ||
			 Sort[{SequenceLast[First[seqs]], SequenceFirst[Last[seqs]]}]==={"A","T"},

			(* closing with AT *)
			Physics`Private`lookupModelThermodynamicsCorrection[pol,property,Terminal,Sequence@@resolvedOptions]//Unitless,

			0.0
		];

	(* symmetry *)
	symmetry =
		If[First[seqs]===Last[seqs],

			(* self-complementory *)
			Physics`Private`lookupModelThermodynamicsCorrection[pol,property,Symmetry,Sequence@@resolvedOptions]//Unitless,

			(* non self-complementory *)
			0.0
		];

	atPenalty + symmetry

];


(* ::Subsubsection:: *)
(*StructureToSingleStrandedStructure*)


StructureToSingleStrandedStructure[struct_]:=
	Module[{formattedStruct,strands,bonds,singleStrand,lengthsOfMotifs,lengthsOfStrands,strandOffsets,strandOffsetRules,singleStrandBonds},
		formattedStruct=NucleicAcids`Private`reformatBonds[struct,StrandBase];
		strands=formattedStruct[Strands];
		bonds=formattedStruct[Bonds];
		singleStrand=Strand[Sequence@@Flatten[List@@@strands]];
		lengthsOfMotifs=Function[strand,Function[motif,StringLength[First[motif]]]/@(List@@strand)]/@strands;
		lengthsOfStrands=Function[motifLengths,Total[motifLengths]]/@lengthsOfMotifs;
		strandOffsets=Accumulate[lengthsOfStrands]-lengthsOfStrands;
		strandOffsetRules=MapIndexed[{First[#2],Span[num1_,num2_]}:>{1,Span[num1+#1,num2+#1]}&,strandOffsets];
		singleStrandBonds=
			Map[
				Function[bond,
					Map[
						#/.strandOffsetRules&,
						bond,
						{1}
					]
				],
				bonds
			];
		strands={singleStrand};
		bonds=singleStrandBonds;
		Structure[strands,bonds]
	];

StructureToSingleStrandedStructure[struct_,"OneMotif"->True]:=
	Module[{formattedStruct,strands,bonds,singleStrand,lengthsOfMotifs,lengthsOfStrands,strandOffsets,strandOffsetRules,singleStrandBonds},
		formattedStruct=NucleicAcids`Private`reformatBonds[struct,StrandBase];
		strands=formattedStruct[Strands];
		bonds=formattedStruct[Bonds];
		singleStrand=Strand[StringJoin@@(First/@Flatten[List@@@strands])];
		lengthsOfMotifs=Function[strand,Function[motif,StringLength[First[motif]]]/@(List@@strand)]/@strands;
		lengthsOfStrands=Function[motifLengths,Total[motifLengths]]/@lengthsOfMotifs;
		strandOffsets=Accumulate[lengthsOfStrands]-lengthsOfStrands;
		strandOffsetRules=MapIndexed[{First[#2],Span[num1_,num2_]}:>{1,Span[num1+#1,num2+#1]}&,strandOffsets];
		singleStrandBonds=
			Map[
				Function[bond,
					Map[
						#/.strandOffsetRules&,
						bond,
						{1}
					]
				],
				bonds
			];
		strands={singleStrand};
		bonds=singleStrandBonds;
		Structure[strands,bonds]
	];

StructureToSingleStrandedStructure[struct_,"KeepOriginalStrandNumbers"->True]:=
	Module[{formattedStruct,strands,bonds,singleStrand,lengthsOfMotifs,lengthsOfStrands,strandOffsets,strandOffsetRules,singleStrandBonds},
		formattedStruct=NucleicAcids`Private`reformatBonds[struct,StrandBase];
		strands=formattedStruct[Strands];
		bonds=formattedStruct[Bonds];
		singleStrand=Strand[Sequence@@Flatten[List@@@strands]];
		lengthsOfMotifs=Function[strand,Function[motif,StringLength[First[motif]]]/@(List@@strand)]/@strands;
		lengthsOfStrands=Function[motifLengths,Total[motifLengths]]/@lengthsOfMotifs;
		strandOffsets=Accumulate[lengthsOfStrands]-lengthsOfStrands;
		strandOffsetRules=MapIndexed[{First[#2],Span[num1_,num2_]}:>{First[#2],Span[num1+#1,num2+#1]}&,strandOffsets];
		singleStrandBonds=
			Map[
				Function[bond,
					Map[
						#/.strandOffsetRules&,
						bond,
						{1}
					]
				],
				bonds
			];
		strands={singleStrand};
		bonds=singleStrandBonds;
		Structure[strands,bonds]
	];
StructureToSingleStrandedStructure[struct:Structure[strands_,bonds_],__]:=struct /;Length[strands]===1;


(* ::Subsection:: *)
(*Face characterization & scoring*)


(* ::Subsubsection::Closed:: *)
(*StructureFaces*)


(*
	TODO:
	- MODIFY THIS TO FIND BIMOLECULAR INITIATIONS / DANGLING ENDS / EXTERNAL LOOPS
*)


StructureFaces[struct_]:=
	Module[{strPieces,strands,sequences,strandOffsets,g,faces,rules,allBaseNums,hBondNums,hBonds,
			recGraph,hBondsRemaining,curHBond,startBase,endBase,curFace, facePath},

		(* Convert the nucleic acid structure to Graph form. In this graphical form,
		 * bases will be referred to by number, with the numbering going from 1 to N, where N
		 * is the total number of bases in 'struct'. This is true even if 'struct' is multi-stranded. *)
		g = struct[Graph];

		(* Get a list of edges from the graph. Edges are covalent or hydrogen bonds. *)
		rules=EdgeList[g];

		(* allBaseNums is a list of all base indices involved in the structure. *)
		allBaseNums=Union[Flatten[List@@@rules]];

		(* Extract the Strands from the structure. *)
		strands=First[struct];

		(* Get extra information about each strand.
		 * strPieces will be in the form: {{{motifName_String, True|False, seq_String | numBases_Integer, polymerType_Symbol}..}..}
		 * Each bottom-level List represents information about a single motif. *)
		strPieces=ParseStrand/@strands;

		(* Replace all strands where the bases are specified by a List of the monomers in that strand (explicitly typed).
		 * Replace all strands where the length but not the bases are specified by a List of "N"s to represent
		 * a sequence of any base.
		 * 'sequences' will be of the form: {{{(base: A|G|U|C|N)..}..}..}
		 * Each bottom-level list represents the bases in a single motif *)
		sequences=
			ReplaceAll[
				strPieces,
				{
					{_,_,seq_String,pol_} :> Monomers[seq, Polymer->pol],
					{_,_,n_Integer,pol_} :> Table["N", {n}]
				}
			];

		(* A list of strand offsets, where each strand offset is the number of
		 * bases that came before the corresponding strand with this index in 'strands'. *)
		strandOffsets=
			(* Make sure the first member of the strand offsets list is 0, as no bases
			 * can come before the first strand. *)
			Join[
				{0},
				Most[

					(* A List where each member represents the offset for a given strand.
					 * A strand's offset is the total number of bases in the strands that came
					 * before it in the 'strands' list. *)
					Accumulate[

						(* A List containing the total number of bases in each strand. *)
						Table[
							Total[Length/@sequences[[strandIndex]]],
							{strandIndex,1,Length[strands]}
						]
					]
				]
			];

		(* Extract all hydrogen bonds from the list of edges in the Graph of this structure.
		 * Then, sort each individual edge and then the list of edges. *)
		hBonds=
			Sort[
				Map[
					Sort,
					Cases[
						rules,

						(* All covalent bonds are between bases that have adjacent indices, so any
						 * bond (edge) between bases whose indices differ by more than 1 is a hydrogen bond.
						 * Additionally, any bond where the lowest-indexed base in the bond is the last base
						 * in some strand HAS to be a hydrogen bond, even if the other base in the bond has an
						 * index only one more than the first base (this second base of the bond is therefore
						 * the first base of a different Strand. *)
						UndirectedEdge[x_,y_]/;(Abs[x-y]>1||MemberQ[strandOffsets, First[Sort[{x, y}]]])
					]
				]
			];

		(* A list of the indices of all bases involved in hydrogen bonds. *)
		hBondNums=Union[Flatten[List@@@hBonds]];

		(* Initialize variables before the fateful face-finding While loop. *)
		faces={};
		hBondsRemaining=hBonds;
		recGraph=g;

		(* Find all faces in the graph. This is done by  *)
		While[hBondsRemaining=!={},

			(* Pick the 'most external' hydrogen bond (the one containing the lowest indexed
			 * hydrogen bonding base). The algorithm below will find the one remaining face
			 * that this hydrogen bond is a part of (guaranteed to only be one face because
			 * this is the 'most external' hydrogen bond). *)
			curHBond=First[hBondsRemaining];

			(* These are the two bases you're trying to find a shortest path between,
			 * provided that this shortest path is not simply the hydrogen bond that
			 * connects the two bases. *)
			startBase = First[curHBond];
			endBase = Last[curHBond];

			(* Make a graph that is the previous graph with a hydrogen bond cut out. You're going to
			 * find the face that this hydrogen bond was a part of by using FindShortestPath, so you
			 * removed the hydrogen bond edge from the graph (otherwise the shortest path would have just
			 * been the hydrogen bond). Taking away the hydrogen bond makes FindShortestPath find another
			 * way between the two bases. *)
			recGraph =
				Graph[
					VertexList[recGraph],
					DeleteCases[EdgeList[recGraph], curHBond]
				];

			(* Find the shortest path between the starting base and the end base, using a graph
			 * that does not contain the hydrogen bond between startBase and endBase. *)
			facePath = FindShortestPath[recGraph,startBase,endBase];

			(* Turn the list of base indices involved in the face into a list of undirected edges.
			 * Then, add on the hydrogen bond to close off the open face. *)
			curFace =
				Join[
					{curHBond},
					UndirectedEdge@@@Partition[facePath, 2, 1]
				];

			(* If the face wasn't actually a face (just a single bond tying two separate strands together)
			 * then don't append the fake face to 'faces'. *)
			If[curFace =!= {curHBond},
				faces = Append[faces,curFace]
			];

			(* Drop the hydrogen bond you just used to find a face from the list of remaining hydrogen bonds. *)
			hBondsRemaining = Drop[hBondsRemaining, 1];
		];

		(* Reduce each face to a list of just the hydrogen bonds involved. *)
		faces =
			Map[
				Function[cyc,
					Cases[cyc, edge:UndirectedEdge[x_, y_]/;(MemberQ[hBonds, edge])]
				],
				faces
			];

		(* Turn each hydrogen bond UndirectedEdge into a List. *)
		faces = Apply[List,faces,{2}];

		(* Sort the hydrogen bonds in each face. Also sort each hydrogen bond (lower-indexed base should come first). *)
		faces = Map[Sort,faces,2];

		(* Prepend the face type ("HairpinLoop", "StackingLoop", "BulgeLoop", "InternalLoop", or "MultipleLoop") to each
		 * face (a list of bonds). *)
		faces =
			ReplaceAll[
				faces,
				bonds:{{_Integer,_Integer}..} :> {getFaceType[bonds], Sequence@@bonds}
			];

		(* Sort the final list of faces by type of face. *)
		Sort[faces]

	];


(* ::Subsubsection:: *)
(*getFaceType*)


(* Function: getFaceType
 * -------------------
 * Returns a string telling you what type of face the hydrogen
 * bonds passed in form.
 * Possible face types:
 *   "HairpinLoop", "StackingLoop", "BulgeLoop", "InternalLoop", "MultipleLoop"
 *)
getFaceType[bonds_]:=
	Module[{i,ii,jj,j,iSideLength,jSideLength,numFreeLoopBases},
		Switch[Length[bonds],

			(* If there's only one hydrogen bond in the face, then it's a hairpin. *)
			1,
				"HairpinLoop",

			(* If there are two h-bonds in the face,
			 * it's either a stacking, bulge, or internal loop. These loops are said
			 * to have 4 "sides", where each hydrogen bond is one side and the
			 * other 2 sides form the covalent-bond chains between each h-bond. *)
			2,
				{i,ii,jj,j}=Sort[Flatten[bonds]];
				iSideLength=ii-i-1;
				jSideLength=j-jj-1;
				numFreeLoopBases=iSideLength+jSideLength;
				Which[
					iSideLength===0&&jSideLength===0,
						"StackingLoop",
					iSideLength===0||jSideLength===0,
						"BulgeLoop",
					True,
						"InternalLoop"
				],

			(* If there are more than 2 hydrogen bonds in the loop, then it is a multiloop. *)
			GreaterEqualP[3],
				"MultipleLoop"
		]
	];


(* ::Subsubsection:: *)
(*structureFaceScore*)


(* ::Text:: *)
(*Stacking*)


(*
	STACKING LOOP has ? contributions

	stacking loop looks like, e.g.

	 topL topR
		A    C
	<===-===
		||  ||
	 ===-=\[Equal]=>
		T    G
	 botL botR
*)
structureFaceScore[face:{"StackingLoop", first:{botLInd_,topLInd_},second:{botRInd_,topRInd_}},monomersList_,property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{botL,botR,topL,topR},
	{botL,topL} = monomersList[[first]];
	{botR,topR} = monomersList[[second]];

	Unitless[stackingParameterLookup[{{botL,topL},{botR,topR}}, property, resolvedOptions]]
];


(* ::Text:: *)
(*Hairpin loop*)


(*
	HAIRPIN LOOP has 3 contributions
	- initiation based on loop size
	- correction based on closing loop pair
	- correction based on first mismatch


	hairpin loop looks like, e.g.

	 topL topR
		A    C   G    T
	<===-=\[Equal]-=\[Equal]-=\[Equal]=
		||            |
	 ===-=\[Equal]=-=\[Equal]-=\[Equal]
		T    T   A    C
	 botL botR

*)
structureFaceScore[face:{"HairpinLoop", {startInd_Integer,endInd_Integer}},monomersList_, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[{
		lastMatch,firstMismatch,loopSize,pol,
		loopSizeVal,mismatchVal
	},
	lastMatch = monomersList[[{startInd,endInd}]];
	firstMismatch = monomersList[[{startInd+1,endInd-1}]];
	loopSize = endInd - startInd - 1;

	(* WHAT IF loop has mix polymer types? *)
	pol = PolymerType[First[monomersList]];

	(*  First mismatch in the loop, averaged since no data *)
	mismatchVal = mismatchParameterLookup[lastMatch, firstMismatch, property, resolvedOptions];

	(* Initiation contribution based on loop size *)
	loopSizeVal = hairpinSizeParameterLookup[loopSize, mismatchVal, SequenceJoin[lastMatch, ExplicitlyTyped->False], monomersList[[startInd+1;;endInd-1]], pol, property, resolvedOptions];

	Unitless[loopSizeVal]

];


(* ::Text:: *)
(*Internal loop*)


(*
	INTERNAL LOOP has 3 contributions
	- initiation based on loop sizes
	- correction based on symmetric or not
	- correction based on left and right terminal mismatch

	Internal loop looks like, e.g.

	 topL               topR
		A    C   G    T    G
	<=-===-=\[Equal]-=\[Equal]-=\[Equal]=-===
		|                  |
	=-===-=\[Equal]=-=\[Equal]-=\[Equal]-=\[Equal]-=\[Equal]>
		T    T   A    C    C
	 botL               botR

*)
structureFaceScore[face:{"InternalLoop", {botLInd_,topLInd_}, {botRInd_,topRInd_}}, monomersList_, \[CapitalDelta]G, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{leftMismatch, rightMismatch, leftFirstMatch, rightFirstMatch, topLen, botLen, pol, loopSizeVal, asymPenalty, mismatchVal},

	leftFirstMatch = monomersList[[{botLInd,topLInd}]];
	rightFirstMatch = monomersList[[{botRInd,topRInd}]];

	leftMismatch = monomersList[[{botLInd+1,topLInd-1}]];
	rightMismatch = monomersList[[{botRInd-1,topRInd+1}]];

	topLen = topLInd - topRInd - 1;
	botLen = botRInd - botLInd - 1;

	If[topLen<=0 || botLen<=0, Return[0.0]];

	pol = PolymerType[First[monomersList]];

	(* Initiation contribution based on loop size *)
	loopSizeVal = internalSizeParameterLookup[topLen+botLen, pol, \[CapitalDelta]G, resolvedOptions];

	(* correction based on symmetric or not *)
	asymPenalty = Abs[botLen - topLen]*0.3 KilocaloriesThermochemical/Mole;

	(* correction based on left and right terminal mismatch *)
	mismatchVal = mismatchParameterLookup[leftFirstMatch, leftMismatch, \[CapitalDelta]G, resolvedOptions] + mismatchParameterLookup[rightFirstMatch, rightMismatch, \[CapitalDelta]G, resolvedOptions];


	Unitless[loopSizeVal + asymPenalty + mismatchVal]


];


structureFaceScore[face:{"InternalLoop", {botLInd_,topLInd_}, {botRInd_,topRInd_}}, monomersList_, \[CapitalDelta]H, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= 0.0;


(* ::Text:: *)
(*Bulge loop*)


(*
	BULGE LOOP has 2 contributions
	- initiation based on whether Bulge Loop is size 1 or not
	- closing AT penalty

	Bulge loop looks like, e.g.


				 A
	 topL ===  topR
		A  |   |  C
	<===-    -===
		||
	 ==========\[Equal]=>
		T         G
	 botL      botR

*)
structureFaceScore[face:{"BulgeLoop", {botLInd_,topLInd_}, {botRInd_,topRInd_}}, monomersList_, \[CapitalDelta]G, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{botL,botR,topL,topR,bulgeSize,pol,loopSizeVal,interveningAddOn},

	{botL,topL} = monomersList[[{botLInd,topLInd}]];
	{botR,topR} = monomersList[[{botRInd,topRInd}]];

	bulgeSize = Max[
		topLInd - topRInd - 1,
		botRInd - botLInd - 1
	];

	pol = PolymerType[First[monomersList]];

	(* basic term depending on bulge size *)
	loopSizeVal = bulgeSizeParameterLookup[bulgeSize, pol, \[CapitalDelta]G, resolvedOptions];

	(* if Bulge size is 1, add the Intervening NN term *)
	interveningAddOn = If[bulgeSize==1,
		stackingParameterLookup[{{topR, botR}, {topL, botL}}, \[CapitalDelta]G, resolvedOptions],
		0
	];


	Unitless[loopSizeVal + interveningAddOn + 0.5 KilocaloriesThermochemical/Mole]

];


structureFaceScore[face:{"BulgeLoop", {botLInd_,topLInd_}, {botRInd_,topRInd_}}, monomersList_, \[CapitalDelta]H, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= 0.0;


(* ::Text:: *)
(*Multi loop*)


structureFaceScore[face:{"MultipleLoop", ___}, ___]:= 0.0;

hairpinSizeParameterLookup[size_Integer, mismatchVal_, lastMatch_, loopMonos_, pol_, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{init, bonus, tempVal, hairpinParameterValues, hairpinParameterFunction,alternativeHairpinParameterFunction,loopSeq},

	(* The values of hairpin parameter associated with pol and propery *)
	hairpinParameterValues=Physics`Private`lookupModelThermodynamics[pol,property,HairpinLoop,Sequence@@resolvedOptions][[1]];

	(* The function evaluating the hairpin parameter associated with pol and propery *)
	hairpinParameterFunction=Physics`Private`lookupModelThermodynamics[pol,property,HairpinLoop,Sequence@@resolvedOptions][[2]];

	(* The function evaluating the hairpin parameter associated with pol and propery *)
	alternativeHairpinParameterFunction=If[Lookup[resolvedOptions,AlternativeParameterization],
		Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,HairpinLoop,Sequence@@resolvedOptions][[3]]
	];

	init=If[MemberQ[hairpinParameterValues[[All,1]],size],
		(* Take the values from the lookup table *)
		First@Cases[hairpinParameterValues,{size,x_Quantity}->x],

		(* Use the function to calculate based on size *)
		If[!MatchQ[hairpinParameterFunction,Null],
			hairpinParameterFunction[size],
			alternativeHairpinParameterFunction[size]
		]
	];

	(* if not found, return 0 *)
	If[!QuantityQ[init], Return[0.0 Physics`Private`thermoUnit[property]]];

	(* only do this if polymers match in the loop *)
	loopSeq = If[MatchQ[loopMonos,{polSame_[_String]..}],
		SequenceJoin[loopMonos,ExplicitlyTyped->False],
		Null
	];

	bonus = loopBonus[size, lastMatch, loopSeq, pol, property, resolvedOptions];

	(* add closing AT penalty *)
	tempVal = If[MatchQ[size, 3|4] && StringMatchQ[lastMatch, "AT"|"TA"|"GT"|"TG"],
				init + bonus + 0.5 Physics`Private`thermoUnit[property],
				init + bonus
			];

	(* triloop doesn't have terminal mismatch term *)
	If[size==3,
		tempVal,
		tempVal + mismatchVal
	]

];

(* if loop mismatch are different polymers, then no bonus *)
loopBonus[_Integer,lastMatch_,loopSeq:Null,___]:=	0.0 Physics`Private`thermoUnit[property];


(* tri loop bonus *)
loopBonus[3, lastMatch_, loopSeq_, pol_, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= With[
	{
		result=
			Switch[pol,
				DNA,
				Cases[
					Physics`Private`lookupModelThermodynamics[pol,property,TriLoop,Sequence@@resolvedOptions][[1]],
					{DNA[lastMatch], x_Quantity} :> x
				] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },
				_,
				0.0 Physics`Private`thermoUnit[property]
			]
	},

	(* if not found, return 0 *)
	If[!QuantityQ[result],
		0.0 Physics`Private`thermoUnit[property],
		result
	]

];


(* tetra loop bonus *)
loopBonus[4, lastMatch_, loopSeq_, pol_, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{referenceOligomer,alternativeLastMatch,alternativeLoopSeq},

	(* Find the dimer pairs based on the option AlternativeParameterization - for alternative parameterization we will substitute the dimers *)
	{referenceOligomer,alternativeLastMatch,alternativeLoopSeq}=dimerPairLoopBonus[lastMatch,loopSeq,pol,resolvedOptions];

	result=
		Switch[pol,
			DNA,
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,TetraLoop,Sequence@@resolvedOptions][[1]],
				{DNA[lastMatch], DNA[loopSeq], x_Quantity} :> x
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

			PolymerP,
			(* Searching for both original and alternative oligomers and returning the first one *)
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,TetraLoop,Sequence@@resolvedOptions][[1]],
				Alternatives[{pol[lastMatch], pol[loopSeq], x_Quantity}, {alternativeLastMatch, alternativeLoopSeq, x_Quantity}]
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x:{{_,_,_}..} :> First[x[[All,3]]] },


			_,
			0.0 Physics`Private`thermoUnit[property]
		];

	(* if not found, return 0 *)
	If[!QuantityQ[result],
		0.0 Physics`Private`thermoUnit[property],
		result
	]

];

(** TODO: Make sure the units match *)

loopBonus[___]:= 0.0 KilocaloriePerMole;


(* Helper function to find the dimer pair based on the AlternativeParameterization option *)
dimerPairLoopBonus[bot_String,top_String,pol_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[

	{referenceOligomer},

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[resolvedOptions,AlternativeParameterization],
		Symbol[
			First[
				Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
			][ReferenceOligomer][Name]
		],
		pol
	];

	(* Find the reference oligomer which is used for alternative parameterization *)
	substitutionRules=If[Lookup[resolvedOptions,AlternativeParameterization],
		First[
			Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
		][SubstitutionRules],
		{}
	];

	(* Returning the symbol name of the reference oligomer and the substituted bottom and top dimers *)
	{referenceOligomer,referenceOligomer[bot],referenceOligomer[top]} /. substitutionRules

];


(* ::Subsubsection:: *)
(*internalSizeParameterLookup*)


internalSizeParameterLookup[size_Integer, pol_, \[CapitalDelta]G, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{result,internalParameterValues,internalParameterFunction,alternativeInternalParameterFunction},

	(* The values of hairpin parameter associated with pol and propery *)
	internalParameterValues=Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,InternalLoop,Sequence@@resolvedOptions][[1]];

	(* The function evaluating the hairpin parameter associated with pol and propery *)
	internalParameterFunction=Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,InternalLoop,Sequence@@resolvedOptions][[2]];

	(* The function evaluating the hairpin parameter associated with pol and propery *)
	alternativeInternalParameterFunction=If[Lookup[resolvedOptions,AlternativeParameterization],
		Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,InternalLoop,Sequence@@resolvedOptions][[3]]
	];

	result=If[MemberQ[internalParameterValues[[All,1]],size],
		(* Take the values from the lookup table *)
		First@Cases[internalParameterValues,{size,x_Quantity}->x],

		(* Use the function to calculate based on size *)
		If[!MatchQ[internalParameterFunction,Null],
			internalParameterFunction[size],
			alternativeInternalParameterFunction[size]
		]
	];

	If[!QuantityQ[result],
		0.0 KilocaloriePerMole,
		result
	]

];


internalSizeParameterLookup[size_Integer, pol_, \[CapitalDelta]H, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= 0.0 KilocaloriePerMole;


(* ::Subsubsection:: *)
(*bulgeSizeParameterLookup*)


bulgeSizeParameterLookup[size_Integer, pol_, \[CapitalDelta]G, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{result,bulgeParameterValues,bulgeParameterFunction,alternativeBulgeParameterFunction},

	(* The values of BulgeLoop parameter associated with pol and propery *)
	bulgeParameterValues=Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,BulgeLoop,Sequence@@resolvedOptions][[1]];

	(* The function evaluating the BulgeLoop parameter associated with pol and propery *)
	bulgeParameterFunction=Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,BulgeLoop,Sequence@@resolvedOptions][[2]];

	(* The function evaluating the BulgeLoop parameter associated with pol and propery *)
	alternativeBulgeParameterFunction=If[Lookup[resolvedOptions,AlternativeParameterization],
		Physics`Private`lookupModelThermodynamics[pol,\[CapitalDelta]G,BulgeLoop,Sequence@@resolvedOptions][[3]]
	];

	result=If[MemberQ[bulgeParameterValues[[All,1]],size],
		(* Take the values from the lookup table *)
		First@Cases[bulgeParameterValues,{size,x_Quantity}->x],

		(* Use the function to calculate based on size *)
		If[!MatchQ[bulgeParameterFunction,Null],
			bulgeParameterFunction[size],
			bulgeParameterFunctionAlternative[size]
		]
	];

	(* if not found, return 0 *)
	If[!QuantityQ[result],
		0.0 KilocaloriePerMole,
		result
	]

];

bulgeSizeParameterLookup[size_Integer, pol_, \[CapitalDelta]H, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= 0.0 KilocaloriePerMole;


(* ::Subsubsection:: *)
(*mismatchParameterLookup*)


(*
	mismatch pattern:

	 topL topR
		A    C
	<===-===
		||
	 ===-=\[Equal]=>
		T    A
	 botL botR

*)

mismatchParameterLookup[lastMatch_,mismatch_,pol_, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{result, tmp},

	(**

		TODO: It makes more sense to me to not take information from Stacking if not present in Mismatch.
		In this case, one should use { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] } after ReplaceAll
		For now, I am setting to Missing[] to be able to match with the previous format of the code.
		Example: Structure[{Strand[DNA["AAAAAAAAAAAAAAAA"], DNA["CCCCCCGGGG"], DNA["TTTTT"]]}, {Bond[{1, 1 ;; 4}, {1, 28 ;; 31}]}]

	**)

	(* Find the dimer pairs based on the option AlternativeParameterization - for alternative parameterization we will substitute the dimers *)
	{referenceOligomer,alternativeLastMatch,alternativeMismatchDimer}=dimerPairMismatch[lastMatch,mismatch,pol,resolvedOptions];

	tmp=
		Switch[pol,
			DNA,
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Mismatch,Sequence@@resolvedOptions][[1]],
				{DNA[StringDelete[lastMatch,"-"]], DNA[StringDelete[mismatch,"-"]], x_Quantity} :> x
			] /. { {} :> {}, x_List :> First[x] },

			RNA,
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Mismatch,Sequence@@resolvedOptions][[1]],
				{RNA[StringDelete[lastMatch,"-"]], RNA[StringDelete[mismatch,"-"]], x_Quantity} :> x
			] /. { {} :> {}, x_List :> First[x] },

			PolymerP,
			(* Searching for both original and alternative oligomers and returning the first one *)
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Mismatch,Sequence@@resolvedOptions][[1]],
				Alternatives[{pol[StringDelete[lastMatch,"-"]], pol[StringDelete[mismatch,"-"]], x_Quantity}, {alternativeLastMatch, alternativeMismatchDimer, x_Quantity}]
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x:{{_,_,_}..} :> First[x[[All,3]]] },

			_,
			0.0 Physics`Private`thermoUnit[property]
		];

	(** TODO: the physical meaning of this need to be checked. It will set the energy of two matching pairs to Stacking cause they are not found in mismatch values **)
	result = If[MatchQ[tmp, Missing[__]|{}],
		Quiet[
			stackingParameterLookup[StringFirst[StringDelete[lastMatch,"-"]]<>StringFirst[StringDelete[mismatch,"-"]],
			StringLast[StringDelete[mismatch,"-"]]<>StringLast[StringDelete[lastMatch,"-"]], pol, property, resolvedOptions]
		], (*  if perfectly match, then it's in stacking parameters *)
		tmp
	];

	(* if not found, return 0 *)
	If[!QuantityQ[result],
		0.0 Physics`Private`thermoUnit[property],
		result
	]

];

(* rearrange lists *)
mismatchParameterLookup[{polA_[botL_String],polB_[topL_String]},{polC_[botR_String],polD_[topR_String]}, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= mismatchParameterLookup[{{polA[botL],polB[topL]},{polC[botR],polD[topR]}}, property, resolvedOptions];

(*
	All same polymer
*)
mismatchParameterLookup[{pol_[botL_],pol_[topL_]},{pol_[botR_],pol_[topR_]}, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=
	mismatchParameterLookup[ botL<>"-"<>topL, botR<>"-"<>topR, pol, property, resolvedOptions];

(*
	heterogeneous junction and/or hetergeneous pairing
	Convert to all different polymers present and average across those
*)
mismatchParameterLookup[{{polA_[botL_],polB_[topL_]},{polC_[botR_],polD_[topR_]}}, property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:= Module[
	{lastMatchA,lastMatchB,lastMatchC,lastMatchD,firstMismatchA,firstMismatchB,firstMismatchC,firstMismatchD},

	lastMatchA = convertBase[polA[botL],polA]<>convertBase[polC[topL],polA];
	lastMatchB = convertBase[polA[botL],polB]<>convertBase[polC[topL],polB];
	lastMatchC = convertBase[polA[botL],polC]<>convertBase[polC[topL],polC];
	lastMatchD = convertBase[polA[botL],polD]<>convertBase[polC[topL],polD];

	firstMismatchA = convertBase[polA[botR],polA]<>convertBase[polC[topR],polA];
	firstMismatchB = convertBase[polA[botR],polB]<>convertBase[polC[topR],polB];
	firstMismatchC = convertBase[polA[botR],polC]<>convertBase[polC[topR],polC];
	firstMismatchD = convertBase[polA[botR],polD]<>convertBase[polC[topR],polD];

	Mean[{
		mismatchParameterLookup[lastMatchA,firstMismatchA,polA, property, resolvedOptions],
		mismatchParameterLookup[lastMatchB,firstMismatchB,polB, property, resolvedOptions],
		mismatchParameterLookup[lastMatchC,firstMismatchC,polC, property, resolvedOptions],
		mismatchParameterLookup[lastMatchD,firstMismatchD,polD, property, resolvedOptions]
	}]
];

(* Helper function to find the dimer pair based on the AlternativeParameterization option *)
dimerPairMismatch[bot_String,top_String,pol_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[

	{referenceOligomer},

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[resolvedOptions,AlternativeParameterization],
		Symbol[
			First[
				Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
			][ReferenceOligomer][Name]
		],
		pol
	];

	(* Find the reference oligomer which is used for alternative parameterization *)
	substitutionRules=If[Lookup[resolvedOptions,AlternativeParameterization],
		First[
			Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
		][SubstitutionRules],
		{}
	];

	(* Returning the symbol name of the reference oligomer and the substituted bottom and top dimers *)
	(* Delete - from the name as is provided for mismatch info - TODO: don't make that in the first place in thermodynamicParameters *)
	{referenceOligomer,referenceOligomer[StringDelete[bot,"-"]],referenceOligomer[StringDelete[top,"-"]]} /. substitutionRules

];

(* ::Subsubsection:: *)
(*stackingParameterLookup*)

(** NOTE: the polymer here is the bottom polymer and it is ok if the top polymer is different - we'll return all possible rules **)
stackingParameterLookup[bot_String,top_String,pol_,property_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{result,referenceOligomer,alternativeBottomDimer,alternativeTopDimer},

	(* Find the dimer pairs based on the option AlternativeParameterization - for alternative parameterization we will substitute the dimers *)
	{referenceOligomer,alternativeBottomDimer,alternativeTopDimer}=dimerPair[bot,top,pol,resolvedOptions];

	result=
		Switch[{pol,property},
			(* Two strands of DNA *)
			{DNA,\[CapitalDelta]G}|{DNA,\[CapitalDelta]H}|{DNA,\[CapitalDelta]S},
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Stacking,Sequence@@resolvedOptions][[1]],
				{DNA[bot], DNA[top], x_Quantity} :> x
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

			(* Binding of DNA to RNA *)
			{DNA,RNA\[CapitalDelta]G}|{DNA,RNA\[CapitalDelta]H}|{DNA,RNA\[CapitalDelta]S},
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,Symbol[StringDelete[SymbolName[property],"RNA"]],Stacking,Sequence@@resolvedOptions][[1]],
				{DNA[bot], RNA[top], x_Quantity} :> x
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

			(* Two strands of RNA *)
			{RNA,\[CapitalDelta]G}|{RNA,\[CapitalDelta]H}|{RNA,\[CapitalDelta]S},
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Stacking,Sequence@@resolvedOptions][[1]],
				{RNA[bot], RNA[top], x_Quantity} :> x
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

			(* Binding of RNA to DNA *)
			{RNA,DNA\[CapitalDelta]G}|{RNA,DNA\[CapitalDelta]H}|{RNA,DNA\[CapitalDelta]S},
			First@Cases[
				Physics`Private`lookupModelThermodynamics[pol,Symbol[StringDelete[SymbolName[property],"DNA"]],Stacking,Sequence@@resolvedOptions][[1]],
				{RNA[bot], DNA[top], x_Quantity} :> x
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x_List :> First[x] },

			{PolymerP,\[CapitalDelta]G}|{PolymerP,\[CapitalDelta]H}|{PolymerP,\[CapitalDelta]S},
			Cases[
				Physics`Private`lookupModelThermodynamics[pol,property,Stacking,Sequence@@resolvedOptions][[1]],
				Alternatives[{pol[bot], pol[top], x_Quantity}, {alternativeBottomDimer, alternativeTopDimer, x_Quantity}]
			] /. { {} :> 0.0 Physics`Private`thermoUnit[property], x:{{_,_,_}..} :> First[x[[All,3]]] },

			_,
			0.0 Physics`Private`thermoUnit[property]
		];

	(* if not found, return 0 *)
	If[!QuantityQ[result],
		0.0 Physics`Private`thermoUnit[property],
		result
	]

];

(*
	All same polymer
*)
stackingParameterLookup[{{pol_[botL_],pol_[topR_]},{pol_[botR_],pol_[topL_]}},property_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=
	stackingParameterLookup[ botL<>botR, topL<>topR, pol,property, resolvedOptions];

(*
	heterogeneous junction and/or hetergeneous pairing
	Convert to all different polymers present and average across those
*)
stackingParameterLookup[{{polA_[botL_],polB_[topR_]},{polC_[botR_],polD_[topL_]}},property_, resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[
	{botA,topA,botB,topB,botC,topC,botD,topD},
	botA = convertBase[polA[botL],polA]<>convertBase[polC[botR],polA];
	botB = convertBase[polA[botL],polB]<>convertBase[polC[botR],polB];
	botC = convertBase[polA[botL],polC]<>convertBase[polC[botR],polC];
	botD = convertBase[polA[botL],polD]<>convertBase[polC[botR],polD];
	topA = convertBase[polA[topL],polA]<>convertBase[polC[topR],polA];
	topB = convertBase[polA[topL],polB]<>convertBase[polC[topR],polB];
	topC = convertBase[polA[topL],polC]<>convertBase[polC[topR],polC];
	topD = convertBase[polA[topL],polD]<>convertBase[polC[topR],polD];
	Mean[{
		stackingParameterLookup[botA,topA,polA,property,resolvedOptions],
		stackingParameterLookup[botB,topB,polB,property,resolvedOptions],
		stackingParameterLookup[botC,topC,polC,property,resolvedOptions],
		stackingParameterLookup[botD,topD,polD,property,resolvedOptions]
	}]
];


(* ::Subsubsection:: *)
(*convertBase*)


convertBase[pol_[base_],pol_]:=base;
convertBase[pol_[base_],targetPolymer_]:=Quiet[Check[polConversionFunc[targetPolymer][pol[base],ExplicitlyTyped->False],"X"]];

polConversionFunc[DNA]=ToDNA;
polConversionFunc[RNA]=ToRNA;
polConversionFunc[PNA]=ToDNA;
polConversionFunc[_]=Function[pol,"X"];


(* ::Subsubsection:: *)
(*sameStructureStrandsQ*)


sameStructureStrandsQ[structA:Structure[strandsA_,_],structB:Structure[strandsB_,_]]:= MatchQ[Sort[strandsA], Sort[strandsB]];


(* ::Subsubsection::Closed:: *)
(*invalidStructureArgumentsQ*)


invalidStructureArgumentsQ[functionName_,structures:{{_Structure,_Structure}..}]:=
	AllTrue[structures,invalidStructureArgumentsQ[functionName,#]&];

invalidStructureArgumentsQ[functionName_,before_Structure,after_Structure]:=
	invalidStructureArgumentsQ[functionName,{before,after}];
invalidStructureArgumentsQ[functionName_,{before_Structure,after_Structure}]:=Module[{},
	If[Or[MatchQ[before,Null],MatchQ[after,Null]],
		Message[functionName::Something];
		Return[True]
	];
	If[!sameStructureStrandsQ[before,after],
		Message[functionName::something];
		Return[True]
	];
	(* only have to check one if we've already checked that they have the same strands *)
	If[unsupportedStrandPolymersQ[before,functionName],
		Return[True]
	];
	False
];
invalidStructureArgumentsQ[functionName_,___]:=True;


(* ::Subsubsection::Closed:: *)
(*dimerPair*)

(* Helper function to find the dimer pair based on the AlternativeParameterization option *)
dimerPair[bot_String,top_String,pol_,resolvedOptions:{(_Rule|_RuleDelayed)..}]:=Module[

	{referenceOligomer},

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[resolvedOptions,AlternativeParameterization],
		Symbol[
			First[
				Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
			][ReferenceOligomer][Name]
		],
		pol
	];

	(* Find the reference oligomer which is used for alternative parameterization *)
	substitutionRules=If[Lookup[resolvedOptions,AlternativeParameterization],
		First[
			Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)]
		][SubstitutionRules],
		{}
	];

	(* Returning the symbol name of the reference oligomer and the substituted bottom and top dimers *)
	{referenceOligomer,referenceOligomer[bot],referenceOligomer[top]} /. substitutionRules

];


(* ::Subsection::Closed:: *)
(*Packet construction*)


(* ::Subsubsection::Closed:: *)
(*formatOligomerPacketRules*)


formatOligomerPacketRules[{before_Structure,after_Structure},resolvedOps_List]:=
	Join[
		{
			Append[Reactants] -> SplitStructure[before],
			Append[Products] -> SplitStructure[after]
		}
	];
formatOligomerPacketRules[other_,resolvedOps_List]:={};


(* ::Subsubsection::Closed:: *)
(*resolveThermoInputLinks*)


resolveThermoInputLinks[functionName_,in1_,___]:=Module[
	{reactionModel,reactantModels,productModels},

	reactionModel = resolveOptionsReactionModel[in1];
	reactantModels = resolveOptionsReactantModels[in1];
	productModels = resolveOptionsProductModels[in1];

	{
		ReactionModel->Link[reactionModel,thermoFuncToReactionModelField[functionName]],
		Append[ReactantModels] -> Map[Link[#,Simulations]&,reactantModels],
		Append[ProductModels] -> Map[Link[#,Simulations]&,productModels]
	}
];


thermoFuncToReactionModelField[SimulateEnthalpy]=EnthalpySimulations;
thermoFuncToReactionModelField[SimulateEntropy]=EntropySimulations;
thermoFuncToReactionModelField[SimulateFreeEnergy]=FreeEnergySimulations;
thermoFuncToReactionModelField[SimulateEquilibriumConstant]=EquilibriumConstantSimulations;
thermoFuncToReactionModelField[SimulateMeltingTemperature]=MeltingTemperatureSimulations;

thermoFuncToFieldRules = {SimulateEnthalpy->Enthalpy,SimulateEntropy->Entropy,SimulateFreeEnergy->FreeEnergy};



(* ::Subsection::Closed:: *)
(*Enthalpy*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[SimulateEnthalpy,
	Options :> {
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Alternatives@@AllPolymersP],
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed.",
			Description->"The polymertype that the oligomer is composed of. Automatic will assumes DNA for lengths and will attempt to match the input sequence if provided with one."
		},
		{
			OptionName->ReactionType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Hybridization | Melting],
			ResolutionDescription->"If Automatic and input is not an object, it resolves to Null.  If input includes a Model[Sample], with just one strand or multiple strands with zero bonds, ReactionType is Hybridization.  For an object with multiple strands and bonds, ReactionType is Melting.  If input is an object and option is set to Null, a warning message is displayed and the option is resolved as if set to Automatic.",
			Description->"Given a Model[Sample] input with both strands and structure, Hybridization selects and hybridizes the strands and Melting selects and melts the structure.  A specific option choice should be selected in ambiguous cases such when there is a single folded strand."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Enthalpy]],ObjectTypes->{Object[Simulation,Enthalpy]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,Enthalpy],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template protocol whose methodology should be reproduced in calculating Enthalpy. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this function."
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection::Closed:: *)
(*SimulateEnthalpy*)

inputPatternSimulateEnthalpyP = inputPatternThermoCalcP;


SimulateEnthalpy[in: ListableP[inputPatternSimulateEnthalpyP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, inputLinks, invalidInputs, inputTests, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthSets, validLengthTests, unresolvedOptions,templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionSets, resolvedInputSets, resolvedInputAndOps, resolvedOptionsTests, resolvedOptionSetsAndTests, optionsRule, previewRule, testsRule, resultRule, coreFields, enthalpyPacketList, definitionNumberList, badInputs, primaryInputTests, secondaryInputTests, reactionInputTests},
	
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* lock simulation starting information *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateEnthalpy,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateEnthalpy,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->safeOptionTests,
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Make list of inputs *)
	inList = ToList[in];

	(* we have 6 function definitions *)
	definitionNumberList = Which[
		MatchQ[#, ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], 1,
		MatchQ[#, _Plus], 2,
		MatchQ[#, _Equilibrium], 3,
		MatchQ[#, ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], 4,
		MatchQ[#, _Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}] ], 5,
		MatchQ[#, StructureP], 6,
		True, 7
	]& /@ inList;

	(* Call ValidInputLengthsQ to make sure all options are the right length, but since input is listable and 6 definitions, do one check for each input *)
	(* Silence the missing option errors *)
	validLengthSets = Quiet[
		(* If definition is 7 then function is incorrectly called *)
		MapThread[
			If[#2>6,
				Message[Error::InvalidInput,#1];
				{False,{}},
				If[gatherTests,
					ValidInputLengthsQ[SimulateEnthalpy,{#1},listedOptions,#2,Output->{Result,Tests}],
					{ValidInputLengthsQ[SimulateEnthalpy,{#1},listedOptions,#2],{}}
				]
			]&,
			{inList,definitionNumberList}
		],
		Warning::IndexMatchingOptionMissing
	];
	validLengths = AllTrue[validLengthSets[[All,1]],TrueQ];
	validLengthTests = validLengthSets[[All,2]];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateEnthalpy,{inList},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateEnthalpy,{inList},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[resolvedOptionSetsAndTests = If[gatherTests,
			resolveThermoOptions[SimulateEnthalpy, #, combinedOptions, Output->{Result,Tests}] & /@ inList,
			{resolveThermoOptions[SimulateEnthalpy, #, combinedOptions], {}} & /@ inList
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	resolvedOptionSets = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,1]]
	];
	resolvedOptionsTests = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,2]]
	];

	(* We can use first in resolved ops set if not failed *)
	resolvedOptions = If[MatchQ[resolvedOptionSets,_List],
		First[resolvedOptionSets],
		resolvedOptionSets
	];

	resolvedInputSets = If[MatchQ[resolvedOptionSets,$Failed],
		$Failed,
		(* Quiet errors from subfunctions and test for error conditions below to handle them in the manner required by style guide *)
		MapThread[
			Quiet@resolveInputsThermoCalculation[
				SimulateEnthalpy,
				#1,
				#2
			]&,
			{inList,resolvedOptionSets}
		]
	];

	(* Download any needed inputs *)
	inListD = megaDownload[inList];

	(* Make primary tests for inputs *)
	primaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			Which[
				MatchQ[#4, 1],
					supportedMechanismTestOrEmpty[SimulateEnthalpy, #3, gatherTests, "The input is a valid reaction:", (MatchQ[#3,ObjectP[Model[Reaction]]] || ReactionQ[#3])],
				MatchQ[#4, 4],
					supportedMechanismTestOrEmpty[SimulateEnthalpy, #3, gatherTests, "The input is a valid reaction mechanism:", ((MatchQ[#3,ObjectP[Model[ReactionMechanism]]] || ReactionMechanismQ[#3]) && MatchQ[Length[#3[Reactions]], 1])],
				MatchQ[#3, _Integer],
					validSequenceLengthTestOrEmpty[SimulateEnthalpy, #3, combinedOptions, gatherTests, "The input sequence length is valid:", (#3 <= 1000)],
				MatchQ[#3, SequenceP],
					validSequenceTestOrEmpty[#3, gatherTests, "The input is a valid sequence:", SequenceQ[#3]],
				MatchQ[#3, (StrandP | StructureP)],
					validStrandTestOrEmpty[#3, gatherTests, "The input strands and structures are valid:", Or@@{StructureQ[#3],StrandQ[#3]}],
				True,
					validThermoInputTestOrEmpty[SimulateEnthalpy, #3, #2, gatherTests, "The input is thermodynamically valid:"]
			] &, {resolvedInputSets,resolvedOptionSets,inListD,definitionNumberList}
		]
	];

	(* Make secondary tests for inputs *)
	secondaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			If[MatchQ[#4,5] && MatchQ[#3,(StructureP | ListableP[_Strand])],
				supportedStrandPolymersTestOrEmpty[#3, gatherTests, "The input contains supported strand polymers", !unsupportedStrandPolymersQ[#3,SimulateEnthalpy]],
				{{},{}}
			] &, {resolvedInputSets,resolvedOptionSets,inListD,definitionNumberList}
		]
	];

	(* Make unsupported reaction tests for inputs *)
	reactionInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		supportedReactionTypeTestOrEmpty[First[#], gatherTests, "The input has a supported reaction type:", !(!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"])] & /@ resolvedInputSets
	];

	(* Separate tests from any associated bad inputs and send input message if bad inputs exist *)
	inputTests = Flatten[Join[primaryInputTests[[All,1]],secondaryInputTests[[All,1]],reactionInputTests[[All,1]]]];
	badInputs = DeleteDuplicates[Flatten[Join[primaryInputTests[[All,2]],secondaryInputTests[[All,2]],reactionInputTests[[All,2]]]]];
	If[Length[badInputs] > 0,
		Message[Error::InvalidInput,badInputs];
	];

	(* Check for invalid input data before building resolved inputs and ops *)
	invalidInputs = If[MatchQ[resolvedInputSets,$Failed],
		{},
		Flatten[Position[resolvedInputSets[[All,1]],Null]]
	];

	resolvedInputAndOps = Which[
		Length[invalidInputs] > 0, $Failed,
		MatchQ[resolvedOptionSets,$Failed], $Failed,
		Or@@((!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"]) & /@ resolvedInputSets), $Failed,
		True, MapThread[{#1,#2} &,{resolvedInputSets,resolvedOptionSets}]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate *)
		(* The major simulation fields including the reactants products and enthalpy *)
		coreFields = If[MatchQ[resolvedInputAndOps,$Failed],
			$Failed,
			Map[SimulateEnthalpyCore[#] &, resolvedInputAndOps]
		];

		(* Make input related links for packet *)
		inputLinks = Map[resolveThermoInputLinks[SimulateEnthalpy, #] &, inListD];

		(* Get Entropy data *)
		enthalpyPacketList = If[MatchQ[coreFields,$Failed],
			$Failed,
			MapThread[
				formatOutputSimulateEnthalpy[SimulateEnthalpy,startFields, #1, #2, Last[#3]]&,
				{inputLinks, coreFields, resolvedInputAndOps}
			]
		];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		(* Check for and get preview *)
		If[MemberQ[ToList[enthalpyPacketList],$Failed],
			$Failed,
			Module[{preview, energies, energyDistributions},
				(* get for display entropy or entropy distributions *)
				energies = Lookup[enthalpyPacketList, Enthalpy, $Failed];
				energyDistributions = Lookup[enthalpyPacketList, EnthalpyDistribution, $Failed];

				preview = If[MatchQ[energies,$Failed] || MatchQ[energyDistributions,$Failed],
					$Failed,
					(* Show the energy if the distribution variance is 0 and show the distribution otherwise since it then becomes the better metric *)
					MapThread[If[MatchQ[Unitless[Variance[#2]], 0], #1, #2] &,
						{energies, energyDistributions}
					]
				];

				(* if input is not a list of inputs, display just first element *)
				If[MatchQ[in,inputPatternSimulateEnthalpyP] && MatchQ[preview,_List],
					First[preview],
					preview
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[ToList[enthalpyPacketList],$Failed] || MatchQ[resolvedOptions,$Failed],
			$Failed,
			Module[{result, oligoUpdatePacketList, pairedPackets, packetLists},

				(* make update packets for oligomer objects *)
				oligoUpdatePacketList = MapThread[
					oligomerUpdatePacketThermoCalculation[SimulateEnthalpy,#1,#2]&,
					{inList,coreFields}
				];

				(* Pair energy with oligomers if they exist*)
				pairedPackets = MapThread[If[Length[#2]==0,{#1,{}},{#1,{#2}}] &,
					{enthalpyPacketList,oligoUpdatePacketList}
				];

				If[Lookup[resolvedOptions, Upload],
					(* Upload and show list of uploaded objects *)
					result = Lookup[Flatten[uploadSimulationPackets[pairedPackets]], Object, $Failed];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					If[MatchQ[in,inputPatternSimulateEnthalpyP] && MatchQ[result,_List],
						First[result],
						result
					],

					(* else output packet or packet list *)
					result = uploadSimulationPackets[pairedPackets];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					result = If[MatchQ[in,inputPatternSimulateEnthalpyP] && MatchQ[result,_List],
						If[MatchQ[First[result],_List],Flatten[First[result]],result],
						If[MatchQ[result,_List],Flatten[result],result]
					];

					(* if result is now a list with length 1, just output the packet *)
					If[MatchQ[result,_List] && Length[result]==1,
						First[result],
						result
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*SimulateEnthalpyOptions*)

Authors[SimulateEnthalpyOptions] := {"brad"};

SimulateEnthalpyOptions[inList: ListableP[inputPatternSimulateEnthalpyP], ops : OptionsPattern[SimulateEnthalpy]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateEnthalpy[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];


(* ::Subsubsection::Closed:: *)
(*SimulateEnthalpyPreview*)

Authors[SimulateEnthalpyPreview] := {"brad"};

SimulateEnthalpyPreview[inList: ListableP[inputPatternSimulateEnthalpyP], ops : OptionsPattern[SimulateEnthalpy]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];
	SimulateEnthalpy[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateEnthalpyQ*)

DefineOptions[ValidSimulateEnthalpyQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateEnthalpy}
];

Authors[ValidSimulateEnthalpyQ] := {"brad"};

ValidSimulateEnthalpyQ[myInput: ListableP[inputPatternSimulateEnthalpyP], myOptions:OptionsPattern[ValidSimulateEnthalpyQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateEnthalpy[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateEnthalpyQ" -> allTests|>, OutputFormat->outputFormat, Verbose->verbose]["ValidSimulateEnthalpyQ"]
];




(* ::Subsubsection:: *)
(*bindingEnthalpyFromReaction*)

(* Helper to pass the reaction to the NN calculation algorithm *)
bindingEnthalpyFromReaction[reaction_,resolvedOps_List]:=Module[{enthalpy},
	nearestNeighborThermodynamics[reaction,\[CapitalDelta]H,Sequence@@FilterRules[resolvedOps,Options[nearestNeighborThermodynamics]]]
];



(* ::Subsubsection:: *)
(*SimulateEnthalpyCore*)

SimulateEnthalpyCore[{fail:(Null|$Failed), _}] := fail;
SimulateEnthalpyCore[{{reaction_,structs_},resolvedOps_}]:=Module[
	{enthalpy},

	enthalpy = bindingEnthalpyFromReaction[reaction,resolvedOps];

	Join[
		formatOligomerPacketRules[structs,resolvedOps],
		{
			Enthalpy->Mean[enthalpy],
			EnthalpyStandardDeviation->StandardDeviation[enthalpy],
			EnthalpyDistribution->enthalpy,
			Reaction->reaction
		}
	]
];



(* ::Subsubsection:: *)
(*formatOutputSimulateEnthalpy*)

formatOutputSimulateEnthalpy[functionName_,startFields_,inputLinkFields_, fail:(Null|$Failed), resolvedOps_] := fail;
formatOutputSimulateEnthalpy[functionName_,startFields_,inputLinkFields_,coreFields_,resolvedOps_]:=Module[
	{out, tempOut},

	out=Association[Join[{Type->Object[Simulation, Enthalpy]},
			startFields,
			simulationPacketStandardFieldsFinish[resolvedOps],
			inputLinkFields,
			coreFields
		]
	]
];


oligomerUpdatePacketThermoCalculation[func_,initialInput:ObjectP[Model[Sample]],coreFields:{__Rule}]:=Module[{fieldName,linkedMolecule,modelMolecule},
	(* the field name we're populating *)
	fieldName = Lookup[thermoFuncToFieldRules,func];
	(* Note: Model[Sample, Oligomer] was deprecated and replaced by Model[Molecule, Oligomer]. SimulateEntropy need to be updated to NOT take Model[Sample] as input,
	which meant to be Model[Sample, Oligomer] by the time it was written. The function will be failing at many current Model[Sample] inputs.
	That is also why there are Stubs in the unit tests. E.g. when the input is Model[Sample,"F dsRed1"], the second part of output, which is generated from this
	helper function, will be failed to be uploaded, because the field Entropy belongs to Model[Molecule, Oligomer] not Model[Sample, Oligomer]. To make a quick fix
	we can change the object in the packet to be Model[Molecule, Oligomer]. For long term we need to change the input for SimulateEntropy, and other similar functions.
	*)
	linkedMolecule = FirstOrDefault[initialInput[Composition]][[2]];
	(*convert link to object*)
	modelMolecule = linkedMolecule /. Link[x_, ___]:>x;
	(* find any reactant samples to update *)
	<|Object->modelMolecule,fieldName->Lookup[coreFields,fieldName]|>
];
oligomerUpdatePacketThermoCalculation[func_,linkRules_,coreFields_]:=<||>;


(* ::Subsection:: *)
(*Entropy*)


(* ::Subsubsection:: *)
(*Options*)


DefineOptions[SimulateEntropy,
	Options :> {
		{
			OptionName->MonovalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			ResolutionDescription->"Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0.05 Molar.",
			Description->"Concentration of monovalent salt ions (e.g. Na, K) in sample buffer."
		},
		{
			OptionName->DivalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			ResolutionDescription->"Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0 Molar.",
			Description->"Concentration of divalent salt ions (e.g. Mg) in sample buffer."
		},
		{
			OptionName->BufferModel,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Object, Pattern:> ObjectP[{Model[Sample,StockSolution], Object[Sample], Model[Sample]}]],
			Description->"Model describing sample buffer. Salt concentrations are computed from chemical formula of this model. This option is overridden by MonovalentSaltConcentration and DivalentSaltConcentration options if either of them are explicitly specified."
		},
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Alternatives@@AllPolymersP],
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed.",
			Description->"The polymertype that the oligomer is composed of. Automatic will assumes DNA for lengths and will attempt to match the input sequence if provided with one."
		},
		{
			OptionName->ReactionType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Hybridization | Melting],
			ResolutionDescription->"If Automatic and input is not an object, it resolves to Null.  If input includes a Model[Sample], with just one strand or multiple strands with zero bonds, ReactionType is Hybridization.  For an object with multiple strands and bonds, ReactionType is Melting.  If input is an object and option is set to Null, a warning message is displayed and the option is resolved as if set to Automatic.",
			Description->"Given a Model[Sample] input with both strands and structure, Hybridization selects and hybridizes the strands and Melting selects and melts the structure.  A specific option choice should be selected in ambiguous cases such when there is a single folded strand."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,Entropy]],ObjectTypes->{Object[Simulation,Entropy]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,Entropy],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template protocol whose methodology should be reproduced in calculating Entropy. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this function."
		},
		OutputOption,
		UploadOption
	}
];


(* ::Subsubsection:: *)
(*SimulateEntropy*)

inputPatternSimulateEntropyP = inputPatternThermoCalcP;


SimulateEntropy[in: ListableP[inputPatternSimulateEntropyP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, inputLinks, invalidInputs, inputTests, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthSets, validLengthTests, unresolvedOptions, templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionSets, resolvedInputSets, resolvedInputAndOps, resolvedOptionsTests, resolvedOptionSetsAndTests, optionsRule, previewRule, testsRule, resultRule, coreFields, entropyPacketList, definitionNumberList, badInputs, primaryInputTests, secondaryInputTests, reactionInputTests},
	
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* lock simulation starting information *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateEntropy,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateEntropy,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->safeOptionTests,
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Make list of inputs *)
	inList = ToList[in];

	(* we have 6 function definitions *)
	definitionNumberList = Which[
		MatchQ[#, ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], 1,
		MatchQ[#, _Plus], 2,
		MatchQ[#, _Equilibrium], 3,
		MatchQ[#, ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], 4,
		MatchQ[#, _Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}] ], 5,
		MatchQ[#, StructureP], 6,
		True, 7
	]& /@ inList;
	
	(* Call ValidInputLengthsQ to make sure all options are the right length, but since input is listable and 6 definitions, do one check for each input *)
	(* Silence the missing option errors *)
	validLengthSets = Quiet[
		(* If definition is 7 then function is incorrectly called *)
		MapThread[
			If[#2>6,
				Message[Error::InvalidInput,#1];
				{False,{}},
				If[gatherTests,
					ValidInputLengthsQ[SimulateEntropy,{#1},listedOptions,#2,Output->{Result,Tests}],
					{ValidInputLengthsQ[SimulateEntropy,{#1},listedOptions,#2],{}}
				]
			]&,
			{inList,definitionNumberList}
		],
		Warning::IndexMatchingOptionMissing
	];
	validLengths = AllTrue[validLengthSets[[All,1]],TrueQ];
	validLengthTests = validLengthSets[[All,2]];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateEntropy,{inList},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateEntropy,{inList},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[resolvedOptionSetsAndTests = If[gatherTests,
			resolveThermoOptions[SimulateEntropy, #, combinedOptions, Output->{Result,Tests}] & /@ inList,
			{resolveThermoOptions[SimulateEntropy, #, combinedOptions], {}} & /@ inList
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	resolvedOptionSets = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,1]]
	];
	resolvedOptionsTests = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,2]]
	];

	(* We can use first in resolved sets if not failed *)
	resolvedOptions = If[MatchQ[resolvedOptionSets,_List],
		First[resolvedOptionSets],
		resolvedOptionSets
	];

	resolvedInputSets = If[MatchQ[resolvedOptionSets,$Failed],
		$Failed,
		(* Quiet errors from subfunctions and test for error conditions below to handle them in the manner required by style guide *)
		MapThread[Quiet@resolveInputsThermoCalculation[SimulateEntropy, #1, #2] &, {inList,resolvedOptionSets}]
	];

	(* download any needed inputs *)
	inListD = megaDownload[inList];

	(* Make primary tests for inputs *)
	primaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			Which[
				MatchQ[#4,1],
					supportedMechanismTestOrEmpty[SimulateEntropy, #3, gatherTests, "The input is a valid reaction:", (MatchQ[#3,ObjectP[Model[Reaction]]] || ReactionQ[#3])],
				MatchQ[#4,4],
					supportedMechanismTestOrEmpty[SimulateEntropy, #3, gatherTests, "The input is a valid reaction mechanism:", ((MatchQ[#3,ObjectP[Model[ReactionMechanism]]] || ReactionMechanismQ[#3]) && MatchQ[Length[#3[Reactions]], 1])],
				MatchQ[#3, _Integer],
					validSequenceLengthTestOrEmpty[SimulateEntropy, #3, combinedOptions, gatherTests, "The input sequence length is valid:", (#3 <= 1000)],
				MatchQ[#3, SequenceP],
					validSequenceTestOrEmpty[#3, gatherTests, "The input is a valid sequence:", SequenceQ[#3]],
				MatchQ[#3, (StrandP | StructureP)],
					validStrandTestOrEmpty[#3, gatherTests, "The input strands and structures are valid:", Or@@{StructureQ[#3],StrandQ[#3]}],
				True,
					validThermoInputTestOrEmpty[SimulateEntropy, #3, #2, gatherTests, "The input is thermodynamically valid:"]
			] &, {resolvedInputSets,resolvedOptionSets,inListD,definitionNumberList}
		]
	];

	(* Make secondary tests for inputs *)
	secondaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			If[MatchQ[#4,5] && MatchQ[#3,(StructureP | ListableP[_Strand])],
				supportedStrandPolymersTestOrEmpty[#3, gatherTests, "The input contains supported strand polymers", !unsupportedStrandPolymersQ[#3,SimulateEntropy]],
				{{},{}}
			] &, {resolvedInputSets,resolvedOptionSets,inListD,definitionNumberList}
		]
	];

	(* Make unsupported reaction tests for inputs *)
	reactionInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		supportedReactionTypeTestOrEmpty[First[#], gatherTests, "The input has a supported reaction type:", !(!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"])] & /@ resolvedInputSets
	];

	(* Separate tests from any associated bad inputs and send input message if bad inputs exist *)
	inputTests = Flatten[Join[primaryInputTests[[All,1]],secondaryInputTests[[All,1]],reactionInputTests[[All,1]]]];
	badInputs = DeleteDuplicates[Flatten[Join[primaryInputTests[[All,2]],secondaryInputTests[[All,2]],reactionInputTests[[All,2]]]]];
	If[Length[badInputs] > 0,
		Message[Error::InvalidInput,badInputs];
	];

	(* Check for invalid input data before building resolved inputs and ops *)
	invalidInputs = If[MatchQ[resolvedInputSets,$Failed],
		$Failed,
		Flatten[Position[resolvedInputSets[[All,1]],Null]]
	];

	resolvedInputAndOps = Which[
		Length[invalidInputs] > 0, $Failed,
		MatchQ[resolvedOptionSets,$Failed], $Failed,
		Or@@((!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"]) & /@ resolvedInputSets), $Failed,
		True, MapThread[{#1,#2} &,{resolvedInputSets,resolvedOptionSets}]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate *)
		coreFields = If[MatchQ[resolvedInputAndOps,$Failed],
			$Failed,
			Map[SimulateEntropyCore[#] &, resolvedInputAndOps]
		];


		(* Make input related links for packet *)
		inputLinks = Map[resolveThermoInputLinks[SimulateEntropy, #] &, inListD];

		(* Get Entropy data *)
		entropyPacketList = If[MatchQ[coreFields,$Failed],
			$Failed,
			MapThread[
				formatOutputSimulateEntropy[SimulateEntropy,startFields, #1, #2, Last[#3]]&,
				{inputLinks, coreFields, resolvedInputAndOps}
			]
		];
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		(* Check for and get preview *)
		If[MemberQ[ToList[entropyPacketList],$Failed],
			$Failed,
			Module[{preview, energies, energyDistributions},
				(* get for display entropy or entropy distributions *)
				energies = Lookup[entropyPacketList, Entropy, $Failed];
				energyDistributions = Lookup[entropyPacketList, EntropyDistribution, $Failed];

				preview = If[MatchQ[energies,$Failed] || MatchQ[energyDistributions,$Failed],
					$Failed,
				(* Show the energy if the distribution variance is 0 and show the distribution otherwise since it then becomes the better metric *)
					MapThread[If[MatchQ[Unitless[Variance[#2]], 0], #1, #2] &,
						{energies, energyDistributions}
					]
				];

				(* if input is not a list of inputs, display just first element *)
				If[MatchQ[in,inputPatternSimulateEntropyP] && MatchQ[preview,_List],
					First[preview],
					preview
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];
	
	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[ToList[entropyPacketList],$Failed] || MatchQ[resolvedOptions,$Failed],
			$Failed,
			Module[{result, oligoUpdatePacketList, pairedPackets, packetLists},

				(* make update packets for oligomer objects *)
				oligoUpdatePacketList = MapThread[
					oligomerUpdatePacketThermoCalculation[SimulateEntropy,#1,#2]&,
					{inList,coreFields}
				];

				(* Pair energy with oligomers if they exist*)
				pairedPackets = MapThread[If[Length[#2]==0,{#1,{}},{#1,{#2}}] &,
					{entropyPacketList,oligoUpdatePacketList}
				];

				If[Lookup[resolvedOptions, Upload],
					(* Upload and show list of uploaded objects *)
					result = Lookup[Flatten[uploadSimulationPackets[pairedPackets]], Object, $Failed];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					If[MatchQ[in,inputPatternSimulateEntropyP] && MatchQ[result,_List],
						First[result],
						result
					],

					(* else output packet or packet list *)
					result = uploadSimulationPackets[pairedPackets];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					result = If[MatchQ[in,inputPatternSimulateEntropyP] && MatchQ[result,_List],
						If[MatchQ[First[result],_List],Flatten[First[result]],result],
						If[MatchQ[result,_List],Flatten[result],result]
					];

					(* if result is now a list with length 1, just output the packet *)
					If[MatchQ[result,_List] && Length[result]==1,
						First[result],
						result
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*SimulateEntropyOptions*)

Authors[SimulateEntropyOptions] := {"brad"};

SimulateEntropyOptions[inList: ListableP[inputPatternSimulateEntropyP], ops : OptionsPattern[SimulateEntropy]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateEntropy[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];



(* ::Subsubsection::Closed:: *)
(*SimulateEntropyPreview*)

Authors[SimulateEntropyPreview] := {"brad"};

SimulateEntropyPreview[inList: ListableP[inputPatternSimulateEntropyP], ops : OptionsPattern[SimulateEntropy]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateEntropy[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateEntropyQ*)

DefineOptions[ValidSimulateEntropyQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateEntropy}
];

Authors[ValidSimulateEntropyQ] := {"brad"};

ValidSimulateEntropyQ[myInput: ListableP[inputPatternSimulateEntropyP], myOptions:OptionsPattern[ValidSimulateEntropyQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateEntropy[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateEntropyQ" -> allTests|>, OutputFormat->outputFormat, Verbose->verbose]["ValidSimulateEntropyQ"]
];



(* ::Subsubsection:: *)
(*bindingEntropyFromReaction*)


bindingEntropyFromReaction[reaction:Reaction[{StructureP...}, {StructureP...}, Hybridization],resolvedOps_List]:=Module[{enthalpy},
	nearestNeighborThermodynamics[reaction,\[CapitalDelta]S,Sequence@@FilterRules[resolvedOps,Options[nearestNeighborThermodynamics]]]
];


bindingEntropyFromReaction[reaction_,resolvedOps_List]:=Module[{dH,dG37,DH,DG37},
	dH = nearestNeighborThermodynamics[reaction,\[CapitalDelta]H,Sequence@@FilterRules[resolvedOps,Options[nearestNeighborThermodynamics]]];
	dG37 = nearestNeighborThermodynamics[reaction,\[CapitalDelta]G,Sequence@@FilterRules[resolvedOps,Options[nearestNeighborThermodynamics]]];

	Convert[
		PropagateUncertainty[
			(DH - DG37)/Convert[37Celsius,Kelvin],
			{
				DH\[Distributed]dH,
				DG37\[Distributed]dG37
			}
		],
		CaloriePerMoleKelvin
	]
];



(* ::Subsubsection:: *)
(*SimulateEntropyCore*)

SimulateEntropyCore[{fail:(Null|$Failed), _}] := fail;
SimulateEntropyCore[{{reaction_,structs_},resolvedOps_}]:=Module[
	{entropy},
	entropy = bindingEntropyFromReaction[reaction,resolvedOps];
	Join[
		formatOligomerPacketRules[structs,resolvedOps],
		{
			Entropy->Mean[entropy],
			EntropyStandardDeviation->StandardDeviation[entropy],
			EntropyDistribution->entropy,
			Reaction->reaction
		}
	]

];



(* ::Subsubsection:: *)
(*formatOutputSimulateEntropy*)

formatOutputSimulateEntropy[functionName_,startFields_,inputLinkFields_, fail:(Null|$Failed),resolvedOps_] := fail;
formatOutputSimulateEntropy[functionName_,startFields_,inputLinkFields_,coreFields_,resolvedOps_]:=Module[
	{out, tempOut},

	out=Association[Join[{Type->Object[Simulation, Entropy]},
			startFields,
			simulationPacketStandardFieldsFinish[resolvedOps],
			inputLinkFields,
			coreFields
		]
	]
];


(* ::Subsection:: *)
(*FreeEnergy*)


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[SimulateFreeEnergy,
	Options :> {
		{
			OptionName->MonovalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of monovalent salt ions (e.g. Na, K) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0.05 Molar."
		},
		{
			OptionName->DivalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget-> Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of divalent salt ions (e.g. Mg) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0 Molar."
		},
		{
			OptionName->BufferModel,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object, Pattern:> ObjectP[{Model[Sample,StockSolution], Object[Sample], Model[Sample]}]],
			Description->"Model describing sample buffer. Salt concentrations are computed from chemical formula of this model. This option is overridden by MonovalentSaltConcentration and DivalentSaltConcentration options if either of them are explicitly specified."
		},
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Alternatives@@AllPolymersP],
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed.",
			Description->"The polymertype that the oligomer is composed of. Automatic will assumes DNA for lengths and will attempt to match the input sequence if provided with one."
		},
		{
			OptionName->ReactionType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Hybridization | Melting],
			ResolutionDescription->"If Automatic and input is not an object, it resolves to Null.  If input includes a Model[Sample], with just one strand or multiple strands with zero bonds, ReactionType is Hybridization.  For an object with multiple strands and bonds, ReactionType is Melting.  If input is an object and option is set to Null, a warning message is displayed and the option is resolved as if set to Automatic.",
			Description->"Given a Model[Sample] input with both strands and structure, Hybridization selects and hybridizes the strands and Melting selects and melts the structure.  A specific option choice should be selected in ambiguous cases such when there is a single folded strand."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,FreeEnergy]],ObjectTypes->{Object[Simulation,FreeEnergy]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,FreeEnergy],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template protocol whose methodology should be reproduced in calculating Entropy. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this function."
		},
		OutputOption,
		UploadOption
	}
];


(* ::Subsubsection::Closed:: *)
(*SimulateFreeEnergy*)

listInputPatternSimulateFreeEnergyP = Alternatives[
	{inputPatternThermoCalcP..},
	mappingPermutations[inputPatternThermoCalcP,tempArgumentP],
	mappingPermutations[enthalpyArgumentP,entropyArgumentP],
	mappingPermutations[enthalpyArgumentP,entropyArgumentP,tempArgumentP]
];

inputPatternSimulateFreeEnergyP = Alternatives[
	inputPatternThermoCalcP,
	PatternSequence[inputPatternThermoCalcP,tempArgumentP],
	PatternSequence[enthalpyArgumentP,entropyArgumentP],
	PatternSequence[enthalpyArgumentP,entropyArgumentP,tempArgumentP]
];


SimulateFreeEnergy[in: Alternatives[inputPatternSimulateFreeEnergyP, listInputPatternSimulateFreeEnergyP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, inputLinks, listInputs, inputTests, correctedInput, validInputs, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthSets, validLengthTests, unresolvedOptions, templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionSets, resolvedInputSets, resolvedInputAndOps, resolvedOptionsTests, resolvedOptionSetsAndTests, optionsRule, previewRule, testsRule, resultRule, coreFields, definitionNumber, fePacketList, badInputs, primaryInputTests, secondaryInputTests, reactionInputTests},

	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* lock simulation starting information *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateFreeEnergy,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateFreeEnergy,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->safeOptionTests,
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Make list of inputs--when multiple elements are specified in a single field, break them into separate list elements *)
	inList = If[MatchQ[{in},{inputPatternSimulateFreeEnergyP}],
		{#} & /@ {in},
		{in}
	];

	(* we have 7 function definitions, but if temperature is missing, add 10 to definition number *)
	definitionNumber = Which[
		MatchQ[ToList[in], {ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 1,
		MatchQ[ToList[in], {ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]}], 11,
		MatchQ[ToList[in], {_Plus, ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 2,
		MatchQ[ToList[in], {_Plus}], 12,
		MatchQ[ToList[in], {_Equilibrium, ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 3,
		MatchQ[ToList[in], {_Equilibrium}], 13,
		MatchQ[ToList[in], {ReactionMechanismP | ObjectP[Model[ReactionMechanism]], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 4,
		MatchQ[ToList[in], {ReactionMechanismP | ObjectP[Model[ReactionMechanism]]}], 14,
		MatchQ[ToList[in], {ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]} ], 5,
		MatchQ[ToList[in], ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]]], 15,
		MatchQ[ToList[in], {ListableP[StructureP], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 6,
		MatchQ[ToList[in], ListableP[StructureP]], 16,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(EntropyP | DistributionP[Joule / (Mole Kelvin)])], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 7,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(EntropyP | DistributionP[Joule / (Mole Kelvin)])]}], 17,
		True, 8
	];

	(* definitions above 10 are missing Temperature, so before doing validation, append default temperature *)
	correctedInput = If[definitionNumber>10,
		definitionNumber = definitionNumber - 10;
		Append[inList,defaultTemperatureValue],
		inList
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	(* definitions above 7 are invalid function calls *)
	{validLengths,validLengthTests} = If[definitionNumber>7,
		Message[Error::InvalidInput,ToList[in]];
		{False,{}},
		Quiet[
			If[gatherTests,
				ValidInputLengthsQ[SimulateFreeEnergy,correctedInput,listedOptions,definitionNumber,Output->{Result, Tests}],
				{ValidInputLengthsQ[SimulateFreeEnergy,correctedInput,listedOptions,definitionNumber],{}}
			],
			Warning::IndexMatchingOptionMissing
		]
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateFreeEnergy,correctedInput,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateFreeEnergy,correctedInput,listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* download any needed inputs *)
	inListD = megaDownload[correctedInput];

	(* Sort and pad fields as necessary *)
	listInputs = resolveListInputsSimulateFreeEnergy[Sequence@@inListD];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[resolvedOptionSetsAndTests = If[gatherTests,
			MapThread[resolveThermoOptions[SimulateFreeEnergy, First[ToList[##]], combinedOptions, Output->{Result,Tests}] &, listInputs],
			MapThread[{resolveThermoOptions[SimulateFreeEnergy, First[ToList[##]], combinedOptions], {}} &,listInputs]
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	resolvedOptionSets = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,1]]
	];
	resolvedOptionsTests = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,2]]
	];

	(* we can use first fully resolved ops if not failed *)
	resolvedOptions = If[MatchQ[resolvedOptionSets,_List],
		First[resolvedOptionSets],
		resolvedOptionSets
	];

	resolvedInputSets = If[MatchQ[resolvedOptionSets,$Failed],
		$Failed,
		(* Quiet errors from subfunctions and test for error conditions below to handle them in the manner required by style guide *)
		Quiet@MapThread[resolveInputsSimulateFreeEnergy, Join[listInputs,{resolvedOptionSets}]]
	];

	(* Make primary tests for inputs *)
	primaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			Which[
				MatchQ[definitionNumber, 7], {{},{}},
				MatchQ[definitionNumber, 1], {{},{}},
				MatchQ[definitionNumber, 4],
					supportedMechanismTestOrEmpty[SimulateFreeEnergy, First[ToList[#1]], gatherTests, "The input is a valid reaction mechanism:", ((MatchQ[First[ToList[#1]],ObjectP[Model[ReactionMechanism]]] || ReactionMechanismQ[First[ToList[#1]]]) && MatchQ[Length[First[ToList[#1]][Reactions]], 1])],
				MatchQ[First[ToList[#1]], _Integer],
					validSequenceLengthTestOrEmpty[SimulateFreeEnergy, First[ToList[#1]], combinedOptions, gatherTests, "The input sequence length is valid:", (First[ToList[#1]] <= 1000)],
				MatchQ[First[ToList[#1]], SequenceP],
					validSequenceTestOrEmpty[First[ToList[#1]], gatherTests, "The input is a valid sequence:", SequenceQ[First[ToList[#1]]]],
				MatchQ[First[ToList[#1]], (StrandP | StructureP)],
					validStrandTestOrEmpty[First[ToList[#1]], gatherTests, "The input strands and structures are valid:", Or@@{StructureQ[First[ToList[#1]]],StrandQ[First[ToList[#1]]]}],
				True,
					validThermoInputTestOrEmpty[SimulateFreeEnergy, First[ToList[#1]], ToList[##][[-2]], gatherTests, "The input is thermodynamically valid:"]
			] &, Join[listInputs,{resolvedOptionSets},{resolvedInputSets}]
		]
	];

	(* Make secondary tests for inputs *)
	secondaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			If[MatchQ[definitionNumber,5] && MatchQ[First[ToList[#1]], (StructureP | ListableP[_Strand])],
				supportedStrandPolymersTestOrEmpty[First[ToList[#1]], gatherTests, "The input contains supported strand polymers", !unsupportedStrandPolymersQ[First[ToList[#1]],SimulateFreeEnergy]],
				{{},{}}
			] &, listInputs
		]
	];

	(* Make unsupported reaction tests for inputs *)
	reactionInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		supportedReactionTypeTestOrEmpty[First[#], gatherTests, "The input has a supported reaction type:", !(!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"])] & /@ resolvedInputSets
	];

	(* Separate tests from any associated bad inputs and send input message if bad inputs exist *)
	inputTests = Flatten[Join[primaryInputTests[[All,1]],secondaryInputTests[[All,1]],reactionInputTests[[All,1]]]];
	badInputs = DeleteDuplicates[Flatten[Join[primaryInputTests[[All,2]],secondaryInputTests[[All,2]],reactionInputTests[[All,2]]]]];
	If[Length[badInputs] > 0,
		Message[Error::InvalidInput,badInputs];
	];

	(* Check for valid inputs before making resolved input and ops *)
	validInputs = Module[{reaction, structures, enthalpy, entropy, temperature, returnBoolean, resolvedOps},
		{reaction, structures, enthalpy, entropy, temperature, returnBoolean} = #;
		Which[
			MatchQ[{reaction,enthalpy},{Null,Null}], False,
			MatchQ[temperature, Null], Message[Error::InvalidInput, "temperature"]; False,
			!MatchQ[reaction, Null] && MatchQ[Last[reaction], Unknown | "UnsupportedReaction"], False,
			True, True
		]
	] & /@ resolvedInputSets;

	resolvedInputAndOps = If[!AllTrue[validInputs,TrueQ],
		$Failed,
		If[MatchQ[resolvedOptionSets,$Failed],
			$Failed,
			MapThread[{Most[#1],#2} &,{resolvedInputSets,resolvedOptionSets}]
		]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate *)
		coreFields = If[MatchQ[resolvedInputAndOps,$Failed],
			$Failed,
			Map[SimulateFreeEnergyCore[#] &, resolvedInputAndOps]
		];

		(* Make links for packet *)
		inputLinks = MapThread[resolveThermoInputLinks[SimulateFreeEnergy, ##] &, listInputs];

		(* Get Entropy data *)
		fePacketList = If[MatchQ[coreFields,$Failed],
			$Failed,
			MapThread[
				formatOutputSimulateFreeEnergy[SimulateFreeEnergy,startFields, #1, #2, Last[#3]]&,
				{inputLinks, coreFields, resolvedInputAndOps}
			]
		];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		(* Check for and get preview *)
		If[MemberQ[ToList[fePacketList],$Failed],
			$Failed,
			Module[{preview, energies, energyDistributions},
				(* get for display entropy or entropy distributions *)
				energies = Lookup[fePacketList, FreeEnergy, $Failed];
				energyDistributions = Lookup[fePacketList, FreeEnergyDistribution, $Failed];

				preview = If[MatchQ[energies,$Failed] || MatchQ[energyDistributions,$Failed],
					$Failed,
				(* Show the energy if the distribution variance is 0 and show the distribution otherwise since it then becomes the better metric *)
					MapThread[If[MatchQ[Unitless[Variance[#2]], 0], #1, #2] &,
						{energies, energyDistributions}
					]
				];

				(* if input is not a list of inputs, display just first element *)
				If[MatchQ[{in},{inputPatternSimulateFreeEnergyP}] && MatchQ[preview,_List],
					First[preview],
					preview
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[ToList[fePacketList],$Failed] || MatchQ[resolvedOptions,$Failed],
			$Failed,
			Module[{result, oligoUpdatePacketList, pairedPackets, packetLists},

				(* make update packets for oligomer objects *)
				oligoUpdatePacketList = MapThread[
					oligomerUpdatePacketThermoCalculation[SimulateFreeEnergy,#1,#2]&,
					{listInputs[[1]],coreFields}
				];

				(* Pair energy with oligomers if they exist*)
				pairedPackets = MapThread[If[Length[#2]==0,{#1,{}},{#1,{#2}}] &,
					{fePacketList,oligoUpdatePacketList}
				];

				If[Lookup[resolvedOptions, Upload],
					(* Upload and show list of uploaded objects *)
					result = Lookup[Flatten[uploadSimulationPackets[pairedPackets]], Object, $Failed];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					If[MatchQ[{in},{inputPatternSimulateFreeEnergyP}] && MatchQ[result,_List],
						First[result],
						result
					],

					(* else output packet or packet list *)
					result = uploadSimulationPackets[pairedPackets];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					result = If[MatchQ[{in},{inputPatternSimulateFreeEnergyP}] && MatchQ[result,_List],
						If[MatchQ[First[result],_List],Flatten[First[result]],result],
						If[MatchQ[result,_List],Flatten[result],result]
					];

					(* if result is now a list with length 1, just output the packet *)
					If[MatchQ[result,_List] && Length[result]==1,
						First[result],
						result
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*SimulateFreeEnergyOptions*)

Authors[SimulateFreeEnergyOptions] := {"brad"};

SimulateFreeEnergyOptions[inList: Alternatives[inputPatternSimulateFreeEnergyP, listInputPatternSimulateFreeEnergyP], ops : OptionsPattern[SimulateFreeEnergy]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateFreeEnergy[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];



(* ::Subsubsection::Closed:: *)
(*SimulateFreeEnergyPreview*)

Authors[SimulateFreeEnergyPreview] := {"brad"};

SimulateFreeEnergyPreview[inList: Alternatives[inputPatternSimulateFreeEnergyP, listInputPatternSimulateFreeEnergyP], ops : OptionsPattern[SimulateFreeEnergy]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];
	SimulateFreeEnergy[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateFreeEnergyQ*)

DefineOptions[ValidSimulateFreeEnergyQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateFreeEnergy}
];

Authors[ValidSimulateFreeEnergyQ] := {"brad"};

ValidSimulateFreeEnergyQ[myInput: Alternatives[inputPatternSimulateFreeEnergyP, listInputPatternSimulateFreeEnergyP], myOptions:OptionsPattern[ValidSimulateFreeEnergyQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateFreeEnergy[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateFreeEnergyQ" -> allTests|>, OutputFormat->outputFormat, Verbose->verbose]["ValidSimulateFreeEnergyQ"]
];



(* ::Subsubsection::Closed:: *)
(*resolveInputsSimulateFreeEnergy*)

(* given reaction & structures. will compute enthalpy and entropy later *)
resolveInputsSimulateFreeEnergy[in_, resolvedOps_] := resolveInputsSimulateFreeEnergy[in, defaultTemperatureValue, resolvedOps];
resolveInputsSimulateFreeEnergy[in_, temperature:tempArgumentP,resolvedOps_]:=Module[
	{structures, reaction, enthalpy, entropy, returnBool, inval},
	inval = Switch[Lookup[resolvedOps,ReactionType],
		Null, in,
		Hybridization, in,
		Melting, in,
		_, in
	];
	{reaction, structures} = resolveInputsThermoCalculation[SimulateFreeEnergy, inval, resolvedOps];
	{enthalpy, entropy}= {Null,Null};
	returnBool = Quiet @ resolveReturnFE[structures, temperature];
	{reaction, structures, enthalpy, entropy, N[temperature], returnBool}
];


(* given enthalpy & entropy. structures and reaction not known *)
resolveInputsSimulateFreeEnergy[enthalpy:enthalpyArgumentP,entropy:entropyArgumentP,resolvedOps_]:=
	resolveInputsSimulateFreeEnergy[enthalpy,entropy,defaultTemperatureValue,resolvedOps];
resolveInputsSimulateFreeEnergy[enthalpy:enthalpyArgumentP,entropy:entropyArgumentP,temperature:tempArgumentP,resolvedOps_]:=Module[
	{structures, reaction, returnBool},
	{reaction, structures} = {Null, Null};
	returnBool = Quiet @ resolveReturnFE[enthalpy, entropy, temperature];
	{reaction,structures,resolveEnthalpy[enthalpy],resolveEntropy[entropy],N[temperature], returnBool}
];


(* ::Subsubsection:: *)
(*SimulateFreeEnergyCore*)


SimulateFreeEnergyCore[{fail:(Null|$Failed), _}] := fail;
(* if given reaction and/or structures *)
SimulateFreeEnergyCore[{{reaction_,structs_,enth:Null,entr:Null,temp_},resolvedOps_}]:=Module[
	{entropy, enthalpy, freeEnergyDistr, tempDistr, tempDistrC},
	entropy = bindingEntropyFromReaction[reaction,resolvedOps];
	enthalpy = bindingEnthalpyFromReaction[reaction,resolvedOps];

	tempDistr = resolveTemperature[temp];
	freeEnergyDistr = freeEnergyFromEnthalpyAndEntropy[enthalpy, entropy, tempDistr];
	tempDistrC = UnitConvert[tempDistr, "DegreesCelsius"];
	Join[
		formatOligomerPacketRules[structs,resolvedOps],
		{
			FreeEnergy->Mean[freeEnergyDistr],
			FreeEnergyStandardDeviation->StandardDeviation[freeEnergyDistr],
			FreeEnergyDistribution->freeEnergyDistr,
			Temperature->Mean[tempDistrC],
			TemperatureStandardDeviation->StandardDeviation[tempDistrC],
			TemperatureDistribution->tempDistrC,
			Reaction->reaction
		}
	]
];

(* if given enthalpy and entropy and structures/reaction not known *)
SimulateFreeEnergyCore[{{reaction:Null,structs:Null,enthalpy_,entropy_,temp_},resolvedOps_}]:=Module[
	{freeEnergyDistr, tempDistr, tempDistrC},
	tempDistr = resolveTemperature[temp];
	freeEnergyDistr = freeEnergyFromEnthalpyAndEntropy[enthalpy, entropy, tempDistr];
	tempDistrC = UnitConvert[tempDistr, "DegreesCelsius"];
	Join[{
		FreeEnergy->Mean[freeEnergyDistr],
		FreeEnergyStandardDeviation->StandardDeviation[freeEnergyDistr],
		FreeEnergyDistribution->freeEnergyDistr,
		Temperature->Mean[tempDistrC],
		TemperatureStandardDeviation->StandardDeviation[tempDistrC],
		TemperatureDistribution->tempDistrC
	}]
];



(* freeEnergyExpression = First[\[CapitalDelta]G/.Solve[GibbsFreeEnergy,\[CapitalDelta]G]]; *)
freeEnergyExpression = \[CapitalDelta]H -T \[CapitalDelta]S;
freeEnergyFromEnthalpyAndEntropy[enth_,entr_,temp_]:=Module[
	{freeEnergy, enthU, entrU},
	enthU = safeQuantityMagnitude[enth];
	entrU = PropagateUncertainty[Evaluate[0.001 * safeQuantityMagnitude[entr]]];
	freeEnergy = PropagateUncertainty[Evaluate[freeEnergyExpression], {
		\[CapitalDelta]H \[Distributed] enthU,
		\[CapitalDelta]S \[Distributed] entrU,
		T \[Distributed] QuantityMagnitude[temp]
	}];
	QuantityDistribution[freeEnergy, KilocaloriePerMole]
];


(* this is used to get rates from mechanisms/kinetics *)
unitlessFreeEnergyFromHS[enth_,entr_,temp_]:=Module[{},
	ReplaceAll[freeEnergyExpression,{\[CapitalDelta]H->enth,\[CapitalDelta]S->entr,T-> temp}]
];


safeQuantityMagnitude[in_]:=With[{qm=QuantityMagnitude[in]},If[MatchQ[qm,_QuantityMagnitude],First[qm],qm]];


(* ::Subsubsection::Closed:: *)
(*formatOutputSimulateFreeEnergy*)


formatOutputSimulateFreeEnergy[functionName_,startFields_,inputLinkFields_, fail:(Null|$Failed),resolvedOps_] := fail;
formatOutputSimulateFreeEnergy[functionName_,startFields_,inputLinkFields_,coreFields_,resolvedOps_]:=Module[
	{out, tempOut},

	out=Association[Join[{Type->Object[Simulation, FreeEnergy]},
			startFields,
			simulationPacketStandardFieldsFinish[resolvedOps],
			inputLinkFields,
			coreFields
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveListInputsSimulateFreeEnergy*)


resolveListInputsSimulateFreeEnergy[in:{inputPatternThermoCalcP..}]:={in};
resolveListInputsSimulateFreeEnergy[in1:{inputPatternThermoCalcP..},in2:tempArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateFreeEnergy[in1:inputPatternThermoCalcP,in2:{tempArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateFreeEnergy[in1:{inputPatternThermoCalcP..},in2:{tempArgumentP..}]:={in1,in2};

resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:entropyArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateFreeEnergy[in1:enthalpyArgumentP,in2:{entropyArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..}]:={in1,in2};

resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:tempArgumentP]:={in1,Table[in2,{Length[in1]}],Table[in3,{Length[in1]}]};
resolveListInputsSimulateFreeEnergy[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:tempArgumentP]:={Table[in1,{Length[in2]}],in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{tempArgumentP..}]:={Table[in1,{Length[in3]}],Table[in2,{Length[in3]}],in3};
resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:tempArgumentP]:={in1,in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{tempArgumentP..}]:={in1,Table[in2,{Length[in1]}],in3};
resolveListInputsSimulateFreeEnergy[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:{tempArgumentP..}]:={Table[in1,{Length[in2]}],in2,in3};
resolveListInputsSimulateFreeEnergy[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:{tempArgumentP..}]:={in1,in2,in3};



(* ::Subsection::Closed:: *)
(*SimulateMeltingTemperature*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[SimulateMeltingTemperature,
	Options :> {
		{
			OptionName->MonovalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of monovalent salt ions (e.g. Na, K) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0.05 Molar."
		},
		{
			OptionName->DivalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget-> Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of divalent salt ions (e.g. Mg) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0 Molar."
		},
		{
			OptionName->BufferModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object, Pattern:> ObjectP[{Model[Sample,StockSolution], Object[Sample], Model[Sample]}]],
			Description->"Model describing sample buffer. Salt concentrations are computed from chemical formula of this model. This option is overridden by MonovalentSaltConcentration and DivalentSaltConcentration options if either of them are explicitly specified."
		},
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Alternatives@@AllPolymersP],
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed.",
			Description->"The polymertype that the oligomer is composed of. Automatic will assumes DNA for lengths and will attempt to match the input sequence if provided with one."
		},
		{
			OptionName->ReactionType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Hybridization | Melting],
			ResolutionDescription->"If Automatic and input is not an object, it resolves to Null.  If input includes a Model[Sample], with just one strand or multiple strands with zero bonds, ReactionType is Hybridization.  For an object with multiple strands and bonds, ReactionType is Melting.  If input is an object and option is set to Null, a warning message is displayed and the option is resolved as if set to Automatic.",
			Description->"Given a Model[Sample] input with both strands and structure, Hybridization selects and hybridizes the strands and Melting selects and melts the structure.  A specific option choice should be selected in ambiguous cases such when there is a single folded strand."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,MeltingTemperature]],ObjectTypes->{Object[Simulation,MeltingTemperature]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,MeltingTemperature],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template protocol whose methodology should be reproduced in calculating Entropy. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this function."
		},
		OutputOption,
		UploadOption
	}
];


(* ::Subsubsection::Closed:: *)
(*SimulateMeltingTemperature*)

listInputPatternSimulateMeltingTemperatureP = Alternatives[
	mappingPermutations[inputPatternThermoCalcP,concArgumentP],
	mappingPermutations[enthalpyArgumentP,entropyArgumentP,concArgumentP]
];

inputPatternSimulateMeltingTemperatureP = Alternatives[
	PatternSequence[inputPatternThermoCalcP,concArgumentP],
	PatternSequence[enthalpyArgumentP,entropyArgumentP,concArgumentP]
];


SimulateMeltingTemperature[in: Alternatives[inputPatternSimulateMeltingTemperatureP,listInputPatternSimulateMeltingTemperatureP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, inputLinks, listInputs, inputTests, correctedInput, validInputs, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthSets, validLengthTests, unresolvedOptions, templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionSets, resolvedInputSets, resolvedInputAndOps, resolvedOptionsTests, resolvedOptionSetsAndTests, optionsRule, previewRule, testsRule, resultRule, coreFields, definitionNumber, packetList, badInputs, primaryInputTests, secondaryInputTests, reactionInputTests, concentrationInputTests},

	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* lock simulation starting information *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateMeltingTemperature,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateMeltingTemperature,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->safeOptionTests,
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* we have 7 function definitions which we check against raw in patterns *)
	definitionNumber = Which[
		MatchQ[ToList[in], {ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 1,
		MatchQ[ToList[in], {ListableP[_Plus], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 2,
		MatchQ[ToList[in], {ListableP[_Equilibrium], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 3,
		MatchQ[ToList[in], {ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 4,
		MatchQ[ToList[in], {ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 5,
		MatchQ[ToList[in], {ListableP[StructureP], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 6,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(EntropyP | DistributionP[Joule / (Mole Kelvin)])], ListableP[ConcentrationP | DistributionP["Molar"] | Rule[SequenceP | StrandP | StructureP, UnitsP["Molar"] | DistributionP["Molar"]]]}], 7,
		True, 8
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	(* definitions above 7 are invalid function calls *)
	{validLengths,validLengthTests} = If[definitionNumber>7,
		Message[Error::InvalidInput,ToList[in]];
		{False,{}},
		Quiet[
			If[gatherTests,
				ValidInputLengthsQ[SimulateMeltingTemperature,{in},listedOptions,definitionNumber,Output->{Result, Tests}],
				{ValidInputLengthsQ[SimulateMeltingTemperature,{in},listedOptions,definitionNumber],{}}
			],
			Warning::IndexMatchingOptionMissing
		]
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateMeltingTemperature,{in},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateMeltingTemperature,{in},listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Make list of inputs--when multiple elements are specified in a single field, break them into separate list elements *)
	inList = If[MatchQ[{in},{inputPatternSimulateMeltingTemperatureP}],
		{#} & /@ {in},
		{in}
	];

	(* download any needed inputs *)
	inListD = megaDownload[inList];

	(* Sort and pad fields as necessary *)
	listInputs = resolveListInputsSimulateMeltingTemperature[Sequence@@inListD];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[resolvedOptionSetsAndTests = If[gatherTests,
			MapThread[resolveThermoOptions[SimulateMeltingTemperature, First[ToList[##]], combinedOptions, Output->{Result,Tests}] &, listInputs],
			MapThread[{resolveThermoOptions[SimulateMeltingTemperature, First[ToList[##]], combinedOptions], {}} &, listInputs]
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	resolvedOptionSets = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,1]]
	];
	resolvedOptionsTests = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,2]]
	];

	(* we can use first fully resolved ops if not failed *)
	resolvedOptions = If[MatchQ[resolvedOptionSets,_List],
		First[resolvedOptionSets],
		resolvedOptionSets
	];

	resolvedInputSets = If[MatchQ[resolvedOptionSets,$Failed],
		$Failed,
		(* Quiet errors from subfunctions and test for error conditions below to handle them in the manner required by style guide *)
		Quiet@MapThread[resolveInputsSimulateMeltingTemperature, Join[listInputs,{resolvedOptionSets}]]
	];

	(* Make primary tests for inputs *)
	primaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			Which[
				MatchQ[definitionNumber, 7], {{},{}},
				MatchQ[definitionNumber, 1], {{},{}},
				MatchQ[definitionNumber, 4],
					supportedMechanismTestOrEmpty[SimulateMeltingTemperature, First[ToList[#1]], gatherTests, "The input is a valid reaction mechanism:", ((MatchQ[First[ToList[#1]],ObjectP[Model[ReactionMechanism]]] || ReactionMechanismQ[First[ToList[#1]]]) && MatchQ[Length[First[ToList[#1]][Reactions]], 1])],
				MatchQ[First[ToList[#1]], _Integer],
					validSequenceLengthTestOrEmpty[SimulateMeltingTemperature, First[ToList[#1]], combinedOptions, gatherTests, "The input sequence length is valid:", (First[ToList[#1]] <= 1000)],
				MatchQ[First[ToList[#1]], SequenceP],
					validSequenceTestOrEmpty[First[ToList[#1]], gatherTests, "The input is a valid sequence:", SequenceQ[First[ToList[#1]]]],
				MatchQ[First[ToList[#1]], (StrandP | StructureP)],
					validStrandTestOrEmpty[First[ToList[#1]], gatherTests, "The input strands and structures are valid:", Or@@{StructureQ[First[ToList[#1]]],StrandQ[First[ToList[#1]]]}],
				True,
					validThermoInputTestOrEmpty[SimulateMeltingTemperature, First[ToList[#1]], ToList[##][[-2]], gatherTests, "The input is thermodynamically valid:"]
			] &, Join[listInputs,{resolvedOptionSets},{resolvedInputSets}]
		]
	];

	(* Make secondary tests for inputs *)
	secondaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			If[MatchQ[definitionNumber,5] && MatchQ[First[ToList[#1]], (StructureP | ListableP[_Strand])],
				supportedStrandPolymersTestOrEmpty[First[ToList[#1]], gatherTests, "The input contains supported strand polymers", !unsupportedStrandPolymersQ[First[ToList[#1]],SimulateMeltingTemperature]],
				{{},{}}
			] &, listInputs
		]
	];

	(* Make unsupported reaction tests for inputs *)
	reactionInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		supportedReactionTypeTestOrEmpty[First[#], gatherTests, "The input has a supported reaction type:", !(!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"])] & /@ resolvedInputSets
	];

	(* Make concentration tests for inputs *)
	concentrationInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[validConcentrationTestOrEmpty[Most[ToList[##]], gatherTests, "The input concentration is valid:", !MatchQ[Last[ToList[##]][[5]], Null]] &, Join[listInputs,{resolvedInputSets}]]
	];

	(* Separate tests from any associated bad inputs and send input message if bad inputs exist *)
	inputTests = Flatten[Join[primaryInputTests[[All,1]],secondaryInputTests[[All,1]],reactionInputTests[[All,1]],concentrationInputTests[[All,1]]]];
	badInputs = DeleteDuplicates[Flatten[Join[primaryInputTests[[All,2]],secondaryInputTests[[All,2]],reactionInputTests[[All,2]],concentrationInputTests[[All,2]]]]];
	If[Length[badInputs] > 0,
		Message[Error::InvalidInput,badInputs];
	];

	(* Check for valid inputs before making resolved input and ops *)
	validInputs = Module[{reaction, structures, enthalpy, entropy, concentration, returnBoolean, resolvedOps},
		{reaction, structures, enthalpy, entropy, concentration, returnBoolean} = #;
		Which[
			MatchQ[{reaction,enthalpy},{Null,Null}], False,
			MatchQ[concentration, Null], False,
			!MatchQ[reaction, Null] && MatchQ[Last[reaction], Unknown | "UnsupportedReaction"], False,
			True, True
		]
	] & /@ resolvedInputSets;

	resolvedInputAndOps = If[!AllTrue[validInputs,TrueQ],
		$Failed,
		If[MatchQ[resolvedOptionSets,$Failed],
			$Failed,
			MapThread[{Most[#1],#2} &,{resolvedInputSets,resolvedOptionSets}]
		]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate *)
		coreFields = If[MatchQ[resolvedInputAndOps,$Failed],
			$Failed,
			Map[simulateMeltingTemperatureCore[#] &, resolvedInputAndOps]
		];

		(* Make links for packet *)
		inputLinks = MapThread[resolveThermoInputLinks[SimulateMeltingTemperature, ##] &, listInputs];

		(* Get Entropy data *)
		packetList = If[MatchQ[coreFields,$Failed],
			$Failed,
			MapThread[
				formatOutputSimulateMeltingTemperature[SimulateMeltingTemperature,startFields, #1, #2, First[#3], Last[#3]] &,
				{inputLinks, coreFields, resolvedInputAndOps}
			]
		];
	];


	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		(* Check for and get preview *)
		If[MemberQ[ToList[packetList],$Failed],
			$Failed,
			Module[{preview, temperatures, temperatureDistributions},
				(* get for display temperatures or temperature distributions *)
				temperatures = Lookup[packetList, MeltingTemperature, $Failed];
				temperatureDistributions = Lookup[packetList, MeltingTemperatureDistribution, $Failed];

				preview = If[MatchQ[temperatures,$Failed] || MatchQ[temperatureDistributions,$Failed],
					$Failed,
				(* Show the temperature if the distribution variance is 0 and show the distribution otherwise since it then becomes the better metric *)
					MapThread[If[MatchQ[Unitless[Variance[#2]], 0], #1, #2] &,
						{temperatures, temperatureDistributions}
					]
				];

				(* if input is not a list of inputs, display just first element *)
				If[MatchQ[{in},{inputPatternSimulateMeltingTemperatureP}] && MatchQ[preview,_List],
					First[preview],
					preview
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[ToList[packetList],$Failed] || MatchQ[resolvedOptions,$Failed],
			$Failed,
			Module[{result},

				If[Lookup[resolvedOptions, Upload],
					(* Upload and show list of uploaded objects *)
					result = Lookup[Flatten[uploadSimulationPackets[packetList]], Object, $Failed];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					If[MatchQ[{in},{inputPatternSimulateMeltingTemperatureP}] && MatchQ[result,_List],
						First[result],
						result
					],

					(* else output packet or packet list *)
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					result = If[MatchQ[{in},{inputPatternSimulateMeltingTemperatureP}] && MatchQ[packetList,_List],
						If[MatchQ[First[packetList],_List],Flatten[First[packetList]],packetList],
						If[MatchQ[packetList,_List],Flatten[packetList],result]
					];

					(* if result is now a list with length 1, just output the packet *)
					If[MatchQ[result,_List] && Length[result]==1,
						First[result],
						result
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*SimulateMeltingTemperatureOptions*)

Authors[SimulateMeltingTemperatureOptions] := {"brad"};

SimulateMeltingTemperatureOptions[inList: Alternatives[inputPatternSimulateMeltingTemperatureP, listInputPatternSimulateMeltingTemperatureP], ops : OptionsPattern[SimulateMeltingTemperature]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateMeltingTemperature[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];



(* ::Subsubsection::Closed:: *)
(*SimulateMeltingTemperaturePreview*)

Authors[SimulateMeltingTemperaturePreview] := {"brad"};

SimulateMeltingTemperaturePreview[inList: Alternatives[inputPatternSimulateMeltingTemperatureP, listInputPatternSimulateMeltingTemperatureP], ops : OptionsPattern[SimulateMeltingTemperature]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];
	SimulateMeltingTemperature[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateMeltingTemperatureQ*)

DefineOptions[ValidSimulateMeltingTemperatureQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateMeltingTemperature}
];

Authors[ValidSimulateMeltingTemperatureQ] := {"brad"};

ValidSimulateMeltingTemperatureQ[myInput: Alternatives[inputPatternSimulateMeltingTemperatureP, listInputPatternSimulateMeltingTemperatureP], myOptions:OptionsPattern[ValidSimulateMeltingTemperatureQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateMeltingTemperature[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateMeltingTemperatureQ" -> allTests|>, OutputFormat->outputFormat, Verbose->verbose]["ValidSimulateMeltingTemperatureQ"]
];



(* ::Subsubsection::Closed:: *)
(*resolveOptionsSimulateMeltingTemperature*)

resolveOptionsSimulateMeltingTemperature[in:inputPatternThermoCalcP,_,unresolvedOps_List]:=Module[{},
	resolveThermoOptions[SimulateMeltingTemperature,in,unresolvedOps]
];

resolveOptionsSimulateMeltingTemperature[in__,unresolvedOps_List]:=Module[{},
	resolveThermoOptions[SimulateMeltingTemperature,First[{in}],unresolvedOps]
];



(* ::Subsubsection::Closed:: *)
(*resolveInputsSimulateMeltingTemperature*)

(* given reaction & structures. will compute enthalpy and entropy later *)
resolveInputsSimulateMeltingTemperature[in:inputPatternThermoCalcP,concentration:concArgumentP,resolvedOps_]:=Module[
	{structures, reaction, enthalpy, entropy, returnBool, inval},
	inval = Switch[Lookup[resolvedOps,ReactionType],
		Null, in,
		Hybridization, in,
		Melting, in,
		_, in
	];
	{reaction, structures} = resolveInputsThermoCalculation[SimulateMeltingTemperature,inval,resolvedOps];
	{enthalpy, entropy}={Null,Null};
	returnBool = Quiet[resolveReturnMT[structures, concentration]];
	{reaction, structures, enthalpy, entropy, resolveConcentration[concentration, reaction, resolvedOps], returnBool}
];


(* given enthalpy & entropy. structures and reaction not known *)
resolveInputsSimulateMeltingTemperature[enthalpy:enthalpyArgumentP,entropy:entropyArgumentP,concentration:concArgumentP,resolvedOps_]:=Module[
	{structures, reaction, returnBool},
	{reaction, structures} = {Null,Null};
	returnBool = Quiet[resolveReturnMT[enthalpy, entropy, concentration]];
	{reaction, structures, resolveEnthalpy[enthalpy], resolveEntropy[entropy], resolveConcentration[concentration, reaction, resolvedOps], returnBool}
];



(* ::Subsubsection::Closed:: *)
(*resolveReturnMT*)

resolveReturnMT[enth_, entr_, conc_] := AllTrue[Join[{enth, entr}, parseConc[concentration]], isNotDistr];
resolveReturnMT[structures_, conc_] := AllTrue[Join[Flatten[structures], parseConc[concentration]], isNotDistr];


parseConc[conc_List] := Last /@ conc;
parseConc[conc_] := {conc};


isNotDistr[distr: DistributionP[]] := False;
isNotDistr[structure: StructureP] := !AllTrue[structure[Strands], isNotDistr];
isNotDistr[strand: StrandP] := !StrandQ[strand, Degeneracy->False];
isNotDistr[_] := True;



(* ::Subsubsection:: *)
(*simulateMeltingTemperatureCore*)

simulateMeltingTemperatureCore[{fail:(Null|$Failed), _}] := fail;
(* if given reaction and/or structures *)
simulateMeltingTemperatureCore[{{reaction_,structs_,enth:Null,entr:Null,conc_},resolvedOps_}]:=Module[
	{entropy, enthalpy, mt},
	entropy = bindingEntropyFromReaction[reaction,resolvedOps];
	enthalpy = bindingEnthalpyFromReaction[reaction,resolvedOps];

	mt = mtFromEnthalpyAndEntropy[enthalpy,entropy,First[conc]];

	Join[
		formatOligomerPacketRules[structs,resolvedOps],
		{
			MeltingTemperature->safeMeltingTemperature[Mean[mt]],
			MeltingTemperatureStandardDeviation->StandardDeviation[mt],
			MeltingTemperatureDistribution->mt,
			Reaction->reaction
		}
	]
];

(* if given enthalpy and entropy and structures/reaction not known *)
simulateMeltingTemperatureCore[{{reaction:Null,structs:Null,enthalpy_,entropy_,conc_},resolvedOps_}]:=Module[
	{mt},
	mt = mtFromEnthalpyAndEntropy[enthalpy,entropy,First[conc]];
	Join[
		{
			MeltingTemperature->safeMeltingTemperature[Mean[mt]],
			MeltingTemperatureStandardDeviation->StandardDeviation[mt],
			MeltingTemperatureDistribution->mt,
			Reaction->reaction
		}
	]

];



(* expression contains 1000 to convert Ct from mol/m^3 to standard unit scale mol/L *)
meltingTemperatureExpression=\[CapitalDelta]H/(\[CapitalDelta]S-R Log[1000/Ct]);
mtFromEnthalpyAndEntropy[enth_,entr_,conc_]:= Module[
	{mt, enthU, entrU},
	enthU = PropagateUncertainty[Evaluate[1000 * QuantityMagnitude[enth]]];
	entrU = QuantityMagnitude[entr];
	mt = PropagateUncertainty[Evaluate[meltingTemperatureExpression], {
		\[CapitalDelta]H \[Distributed] enthU,
		\[CapitalDelta]S \[Distributed] entrU,
		Ct \[Distributed] QuantityMagnitude[UnitConvert[conc, "Moles"/("Meters"^3)]],
		R->Unitless[MolarGasConstant, CaloriePerMoleKelvin]
	}];
	UnitConvert[QuantityDistribution[mt, Kelvin], "DegreesCelsius"]
];



safeMeltingTemperature[mt_] := If[MatchQ[Round[Unitless[mt] + 273.15, 10], 0], Quantity[-273.15, "DegreesCelsius"], mt];



(* ::Subsubsection::Closed:: *)
(*formatOutputSimulateMeltingTemperature*)

formatOutputSimulateMeltingTemperature[functionName_,startFields_,inputLinkFields_, fail:(Null|$Failed), concOut_, resolvedOps_] := fail;
formatOutputSimulateMeltingTemperature[functionName_,startFields_,inputLinkFields_,coreFields_, concOut_, resolvedOps_]:=Module[
	{out, tempOut},

	out=Association[Join[{Type->Object[Simulation, MeltingTemperature]},
			startFields,
			simulationPacketStandardFieldsFinish[resolvedOps],
			inputLinkFields,
			coreFields,
			(Last[Last[concOut]] /. Rule[x_, y_] :> Append[x] -> y)
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*resolveListInputsSimulateMeltingTemperature*)

resolveListInputsSimulateMeltingTemperature[in1:{inputPatternThermoCalcP..},in2:concArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateMeltingTemperature[in1:inputPatternThermoCalcP,in2:{concArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateMeltingTemperature[in1:{inputPatternThermoCalcP..},in2:{concArgumentP..}]:={in1,in2};

resolveListInputsSimulateMeltingTemperature[in1:{freeEnergyArgumentP..},in2:concArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateMeltingTemperature[in1:freeEnergyArgumentP,in2:{concArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateMeltingTemperature[in1:{freeEnergyArgumentP..},in2:{concArgumentP..}]:={in1,in2};

resolveListInputsSimulateMeltingTemperature[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:concArgumentP]:={in1,Table[in2,{Length[in1]}],Table[in3,{Length[in1]}]};
resolveListInputsSimulateMeltingTemperature[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:concArgumentP]:={Table[in1,{Length[in2]}],in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateMeltingTemperature[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{concArgumentP..}]:={Table[in1,{Length[in3]}],Table[in2,{Length[in3]}],in3};
resolveListInputsSimulateMeltingTemperature[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:concArgumentP]:={in1,in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateMeltingTemperature[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{concArgumentP..}]:={in1,Table[in2,{Length[in1]}],in3};
resolveListInputsSimulateMeltingTemperature[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:{concArgumentP..}]:={Table[in1,{Length[in2]}],in2,in3};
resolveListInputsSimulateMeltingTemperature[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:{concArgumentP..}]:={in1,in2,in3};



(* ::Subsection::Closed:: *)
(*EquilibriumConstant*)

(* ::Subsubsection::Closed:: *)
(*Options*)

DefineOptions[SimulateEquilibriumConstant,
	Options :> {
		{
			OptionName->MonovalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of monovalent salt ions (e.g. Na, K) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0.05 Molar."
		},
		{
			OptionName->DivalentSaltConcentration,
			Default->Automatic,
			AllowNull->False,
			Widget-> Widget[Type->Quantity, Pattern:> GreaterEqualP[0 Millimolar], Units-> Millimolar | Molar ],
			Description->"Concentration of divalent salt ions (e.g. Mg) in sample buffer. Automatic first attempts to pull the value from the object specified in the BufferModel option, then attempts to compute value from input sample's transfers, and otherwise defaults to 0 Molar."
		},
		{
			OptionName->BufferModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Object, Pattern:> ObjectP[{Model[Sample,StockSolution], Object[Sample], Model[Sample]}]],
			Description->"Model describing sample buffer. Salt concentrations are computed from chemical formula of this model. This option is overridden by MonovalentSaltConcentration and DivalentSaltConcentration options if either of them are explicitly specified."
		},
		{
			OptionName->Polymer,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Alternatives@@AllPolymersP],
			ResolutionDescription->"If Null or Automatic, polymer type is determined from the structure.  When multiple polymer inputs are provided, it resolves to Null which is the preferred choice when multiple inputs with different polymer types are used.  With multiple polymers, the individual polymer types are determined by subfunctions when needed.",
			Description->"The polymertype that the oligomer is composed of. Automatic will assumes DNA for lengths and will attempt to match the input sequence if provided with one."
		},
		{
			OptionName->ReactionType,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> Hybridization | Melting],
			ResolutionDescription->"If Automatic and input is not an object, it resolves to Null.  If input includes a Model[Sample], with just one strand or multiple strands with zero bonds, ReactionType is Hybridization.  For an object with multiple strands and bonds, ReactionType is Melting.  If input is an object and option is set to Null, a warning message is displayed and the option is resolved as if set to Automatic.",
			Description->"Given a Model[Sample] input with both strands and structure, Hybridization selects and hybridizes the strands and Melting selects and melts the structure.  A specific option choice should be selected in ambiguous cases such when there is a single folded strand."
		},
		{
			OptionName->AlternativeParameterization,
			Default->Automatic,
			AllowNull->True,
			Widget->Widget[Type->Enumeration, Pattern:> BooleanP],
			ResolutionDescription->"If Automatic and the Thermodynamics field for the model oligomer is not available and the AlternativeParameterization is populated, it resolves to True. If Automatic and the thermodynamics object is available, it resolves to False.",
			Description->"If True, the thermodynamics object in the ReferenceOligomer field of the AlternativeParameterization field of the oligomer is used for thermodynamic properties."
		},
		{
			OptionName->ThermodynamicsModel,
			Default->Automatic,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object, Pattern:> ObjectP[Model[Physics,Thermodynamics]],ObjectTypes->{Model[Physics,Thermodynamics]}],
				Widget[Type->Expression, Pattern:> None, PatternTooltip->"None leaves the parameter determination up to the lookup functions.", Size->Line]
			],
			ResolutionDescription->"If Automatic, it will be resolved to Thermodynamics field of the model oligomer object. It is resolved to None if there is no model available and the thermodynamic properties are set to zero.",
			Description->"The thermodynamic properties of the polymer that determine the polymer folding structure are stored in this field."
		},
		{
			OptionName->Template,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				Widget[Type->Object,Pattern:>ObjectP[Object[Simulation,EquilibriumConstant]],ObjectTypes->{Object[Simulation,EquilibriumConstant]}],
				Widget[Type->FieldReference,Pattern:>FieldReferenceP[Object[Simulation,EquilibriumConstant],{UnresolvedOptions,ResolvedOptions}]]
			],
			Description->"A template protocol whose methodology should be reproduced in calculating Entropy. Option values will be inherited from the template protocol, but can be individually overridden by directly specifying values for those options to this function."
		},
		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection::Closed:: *)
(*SimulateEquilibriumConstant*)

inputPatternSimulateEquilibriumConstantP = Alternatives[
	inputPatternThermoCalcP,
	PatternSequence[inputPatternThermoCalcP,tempArgumentP],
	freeEnergyArgumentP,
	PatternSequence[freeEnergyArgumentP,tempArgumentP],
	PatternSequence[enthalpyArgumentP,entropyArgumentP],
	PatternSequence[enthalpyArgumentP,entropyArgumentP,tempArgumentP]
];

listInputPatternSimulateEquilibriumConstantP = Alternatives[
	{inputPatternThermoCalcP..},
	mappingPermutations[inputPatternThermoCalcP,tempArgumentP],
	{freeEnergyArgumentP..},
	mappingPermutations[freeEnergyArgumentP,tempArgumentP],
	mappingPermutations[enthalpyArgumentP,entropyArgumentP],
	mappingPermutations[enthalpyArgumentP,entropyArgumentP,tempArgumentP]
];


SimulateEquilibriumConstant[in: Alternatives[inputPatternSimulateEquilibriumConstantP, listInputPatternSimulateEquilibriumConstantP], ops: OptionsPattern[]] := Module[
	{startFields, inList, inListD, inputLinks, listInputs, inputTests, correctedInput, validInputs, outputSpecification, output, listedOptions, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthSets, validLengthTests, unresolvedOptions, templateTests, combinedOptions, resolvedOptionsResult, resolvedOptions, resolvedOptionSets, resolvedInputSets, resolvedInputAndOps, resolvedOptionsTests, resolvedOptionSetsAndTests, optionsRule, previewRule, testsRule, resultRule, coreFields, definitionNumber, packetList, badInputs, primaryInputTests, secondaryInputTests, reactionInputTests},
	
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Get simulation options which account for when Option Object is specified *)
	listedOptions = ToList[ops];

	(* lock simulation starting information *)
	startFields = simulationPacketStandardFieldsStart[listedOptions];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests} = If[gatherTests,
		SafeOptions[SimulateEquilibriumConstant,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[SimulateEquilibriumConstant,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->safeOptionTests,
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* we have 8 function definitions, but if temperature is missing, add 10 to definition number *)
	definitionNumber = Which[
		MatchQ[ToList[in], {ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 1,
		MatchQ[ToList[in], ListableP[ReactionP | ObjectP[Model[Reaction]] | Reaction[{_Structure..}, {_Structure..}, _]]], 11,
		MatchQ[ToList[in], {ListableP[_Plus], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 2,
		MatchQ[ToList[in], ListableP[_Plus]], 12,
		MatchQ[ToList[in], {ListableP[_Equilibrium], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 3,
		MatchQ[ToList[in], ListableP[_Equilibrium]], 13,
		MatchQ[ToList[in], {ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 4,
		MatchQ[ToList[in], ListableP[ReactionMechanismP | ObjectP[Model[ReactionMechanism]]]], 14,
		MatchQ[ToList[in], {ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]} ], 5,
		MatchQ[ToList[in], ListableP[_Integer | SequenceP | StrandP | ObjectP[{Model[Sample], Object[Sample], Model[Molecule, Oligomer]}]]], 15,
		MatchQ[ToList[in], {ListableP[StructureP], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 6,
		MatchQ[ToList[in], ListableP[StructureP]], 16,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(EntropyP | DistributionP[Joule / (Mole Kelvin)])], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 7,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(EntropyP | DistributionP[Joule / (Mole Kelvin)])]}], 17,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])], ListableP[(TemperatureP | DistributionP["DegreesCelsius"])]}], 8,
		MatchQ[ToList[in], {ListableP[(EnergyP | DistributionP[Joule / Mole])]}], 18,
		True, 9
	];

	(* Make list of inputs--when multiple elements are specified in a single field, break them into separate list elements *)
	inList = If[MatchQ[{in},{inputPatternSimulateEquilibriumConstantP}],
		{#} & /@ {in},
		{in}
	];

	(* definitions above 10 are missing Temperature, so before doing validation, append default temperature *)
	correctedInput = If[definitionNumber>10,
		definitionNumber = definitionNumber - 10;
		Append[inList,defaultTemperatureValue],
		inList
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	(* definitions above 8 are invalid function calls *)
	{validLengths,validLengthTests} = If[definitionNumber>8,
		Message[Error::InvalidInput,ToList[in]];
		{False,{}},
		Quiet[
			If[gatherTests,
				ValidInputLengthsQ[SimulateEquilibriumConstant,correctedInput,listedOptions,definitionNumber,Output->{Result, Tests}],
				{ValidInputLengthsQ[SimulateEquilibriumConstant,correctedInput,listedOptions,definitionNumber],{}}
			],
			Warning::IndexMatchingOptionMissing
		]
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed*)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview->Null
		}]
	];

	(* Use any template options to get values for options not specified in listedOptions *)
	{unresolvedOptions,templateTests} = If[gatherTests,
		ApplyTemplateOptions[SimulateEquilibriumConstant,correctedInput,listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[SimulateEquilibriumConstant,correctedInput,listedOptions],{}}
	];
	combinedOptions = ReplaceRule[safeOptions,unresolvedOptions];

	(* Download any needed inputs *)
	inListD = megaDownload[correctedInput];

	(* Sort and pad fields as necessary *)
	listInputs = resolveListInputsSimulateEquilibriumConstant[Sequence@@inListD];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult = Check[resolvedOptionSetsAndTests = If[gatherTests,
			MapThread[resolveThermoOptions[SimulateEquilibriumConstant, First[ToList[##]], combinedOptions, Output->{Result,Tests}] &, listInputs],
			MapThread[{resolveThermoOptions[SimulateEquilibriumConstant, First[ToList[##]], combinedOptions], {}} &, listInputs]
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	resolvedOptionSets = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,1]]
	];
	resolvedOptionsTests = If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		resolvedOptionSetsAndTests[[All,2]]
	];

	(* We can use first in resolved ops set if not failed *)
	resolvedOptions = If[MatchQ[resolvedOptionSets,_List],
		First[resolvedOptionSets],
		resolvedOptionSets
	];

	resolvedInputSets = If[MatchQ[resolvedOptionSets,$Failed],
		$Failed,
		(* Quiet errors from subfunctions and test for error conditions below to handle them in the manner required by style guide *)
		Quiet@MapThread[resolveInputsSimulateEquilibriumConstant, Join[listInputs,{resolvedOptionSets}]]
	];

	(* Make primary tests for inputs *)
	primaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			Which[
				MatchQ[definitionNumber, 8], {{},{}},
				MatchQ[definitionNumber, 7], {{},{}},
				MatchQ[definitionNumber, 1], {{},{}},
				MatchQ[definitionNumber, 4],
					supportedMechanismTestOrEmpty[SimulateEquilibriumConstant, First[ToList[#1]], gatherTests, "The input is a valid reaction mechanism:", ((MatchQ[First[ToList[#1]],ObjectP[Model[ReactionMechanism]]] || ReactionMechanismQ[First[ToList[#1]]]) && MatchQ[Length[First[ToList[#1]][Reactions]], 1])],
				MatchQ[First[ToList[#1]], _Integer],
					validSequenceLengthTestOrEmpty[SimulateEquilibriumConstant, First[ToList[#1]], combinedOptions, gatherTests, "The input sequence length is valid:", (First[ToList[#1]] <= 1000)],
				MatchQ[First[ToList[#1]], SequenceP],
					validSequenceTestOrEmpty[First[ToList[#1]], gatherTests, "The input is a valid sequence:", SequenceQ[First[ToList[#1]]]],
				MatchQ[First[ToList[#1]], (StrandP | StructureP)],
					validStrandTestOrEmpty[First[ToList[#1]], gatherTests, "The input strands and structures are valid:", Or@@{StructureQ[First[ToList[#1]]],StrandQ[First[ToList[#1]]]}],
				True,
					validThermoInputTestOrEmpty[SimulateEquilibriumConstant, First[ToList[#1]], ToList[##][[-2]], gatherTests, "The input is thermodynamically valid:"]
			] &, Join[listInputs,{resolvedOptionSets},{resolvedInputSets}]
		]
	];

	(* Make secondary tests for inputs *)
	secondaryInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		MapThread[
			If[MatchQ[definitionNumber,5] && MatchQ[First[ToList[#1]], (StructureP | ListableP[_Strand])],
				supportedStrandPolymersTestOrEmpty[First[ToList[#1]], gatherTests, "The input contains supported strand polymers", !unsupportedStrandPolymersQ[First[ToList[#1]],SimulateEquilibriumConstant]],
				{{},{}}
			] &, listInputs
		]
	];

	(* Make unsupported reaction tests for inputs *)
	reactionInputTests = If[MatchQ[resolvedOptionsResult,$Failed],
		{{{},{}}},
		supportedReactionTypeTestOrEmpty[First[#], gatherTests, "The input has a supported reaction type:", !(!MatchQ[First[#], Null] && MatchQ[Last[First[#]], Unknown | "UnsupportedReaction"])] & /@ resolvedInputSets
	];

	(* Separate tests from any associated bad inputs and send input message if bad inputs exist *)
	inputTests = Flatten[Join[primaryInputTests[[All,1]],secondaryInputTests[[All,1]],reactionInputTests[[All,1]]]];
	badInputs = DeleteDuplicates[Flatten[Join[primaryInputTests[[All,2]],secondaryInputTests[[All,2]],reactionInputTests[[All,2]]]]];
	If[Length[badInputs] > 0,
		Message[Error::InvalidInput,badInputs];
	];

	(* Check for valid inputs before making resolved input and ops *)
	validInputs = Module[{reaction, structures, enthalpy, entropy, freeEnergy, temperature, returnBoolean, resolvedOps},
		{reaction, structures, enthalpy, entropy, freeEnergy, temperature, returnBoolean} = #;
		Which[
			MatchQ[{reaction,enthalpy,freeEnergy},{Null,Null,Null}], False,
			MatchQ[temperature, Null], Message[Error::InvalidInput, "concentration"]; False,
			!MatchQ[reaction, Null] && MatchQ[Last[reaction], Unknown | "UnsupportedReaction"], False,
			True, True
		]
	] & /@ resolvedInputSets;

	resolvedInputAndOps = If[!AllTrue[validInputs,TrueQ],
		$Failed,
		If[MatchQ[resolvedOptionSets,$Failed],
			$Failed,
			MapThread[{Most[#1],#2} &,{resolvedInputSets,resolvedOptionSets}]
		]
	];

	If[MemberQ[output,Preview] || MemberQ[output,Result],
		(* generate *)
		coreFields = If[MatchQ[resolvedInputAndOps,$Failed],
			$Failed,
			Map[SimulateEquilibriumConstantCore[#] &, resolvedInputAndOps]
		];

		(* Make links for packet *)
		inputLinks = MapThread[resolveThermoInputLinks[SimulateEquilibriumConstant, ##] &, listInputs];

		(* Get Entropy data *)
		packetList = If[MatchQ[coreFields,$Failed],
			$Failed,
			MapThread[
				formatOutputSimulateEquilibriumConstant[SimulateEquilibriumConstant,startFields, #1, #2, Last[#3]]&,
				{inputLinks, coreFields, resolvedInputAndOps}
			]
		];
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule = Preview->If[MemberQ[output,Preview],
		(* Check for and get preview *)
		If[MemberQ[ToList[packetList],$Failed],
			$Failed,
			Module[{preview, constants, constantDistributions},
				(* get for display constants or constant distributions *)
				constants = Lookup[packetList, EquilibriumConstant, $Failed];
				constantDistributions = Lookup[packetList, EquilibriumConstantDistribution, $Failed];

				preview = If[MatchQ[constants,$Failed] || MatchQ[constantDistributions,$Failed],
					$Failed,
				(* Show the constant value if the distribution variance is 0 and show the distribution otherwise since it then becomes the better metric *)
					MapThread[If[MatchQ[Unitless[Variance[#2]], 0], #1, #2] &,
						{constants, constantDistributions}
					]
				];

				(* if input is not a list of inputs, display just first element *)
				If[MatchQ[{in},{inputPatternSimulateEquilibriumConstantP}] && MatchQ[preview,_List],
					First[preview],
					preview
				]
			]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests,validLengthTests,templateTests,ToList[resolvedOptionsTests],ToList[inputTests]]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed] || MemberQ[ToList[packetList],$Failed] || MatchQ[resolvedOptions,$Failed],
			$Failed,
			Module[{result, oligoUpdatePacketList, pairedPackets, packetLists},

				(* make update packets for oligomer objects *)
				oligoUpdatePacketList = MapThread[
					oligomerUpdatePacketThermoCalculation[SimulateEquilibriumConstant,#1,#2]&,
					{listInputs[[1]],coreFields}
				];

				(* Pair energy with oligomers if they exist*)
				pairedPackets = MapThread[If[Length[#2]==0,{#1,{}},{#1,{#2}}] &,
					{packetList,oligoUpdatePacketList}
				];

				If[Lookup[resolvedOptions, Upload],
					(* Upload and show list of uploaded objects *)
					result = Lookup[Flatten[uploadSimulationPackets[pairedPackets]], Object, $Failed];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					If[MatchQ[{in},{inputPatternSimulateEquilibriumConstantP}] && MatchQ[result,_List],
						First[result],
						result
					],

					(* else output packet or packet list *)
					result = uploadSimulationPackets[pairedPackets];
					(* if input is not a list, take first element of packet and flatten any lists which will get rid of nesting and empty packets *)
					result = If[MatchQ[{in},{inputPatternSimulateEquilibriumConstantP}] && MatchQ[result,_List],
						If[MatchQ[First[result],_List],Flatten[First[result]],result],
						If[MatchQ[result,_List],Flatten[result],result]
					];

					(* if result is now a list with length 1, just output the packet *)
					If[MatchQ[result,_List] && Length[result]==1,
						First[result],
						result
					]
				]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(* ::Subsubsection::Closed:: *)
(*SimulateEquilibriumConstantOptions*)

Authors[SimulateEquilibriumConstantOptions] := {"brad"};

SimulateEquilibriumConstantOptions[inList: Alternatives[inputPatternSimulateEquilibriumConstantP, listInputPatternSimulateEquilibriumConstantP], ops : OptionsPattern[SimulateEquilibriumConstant]] :=	Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];

	SimulateEquilibriumConstant[inList, Sequence@@Append[noOutputOptions,Output->Options]]
];



(* ::Subsubsection::Closed:: *)
(*SimulateEquilibriumConstantPreview*)

Authors[SimulateEquilibriumConstantPreview] := {"brad"};

SimulateEquilibriumConstantPreview[inList: Alternatives[inputPatternSimulateEquilibriumConstantP, listInputPatternSimulateEquilibriumConstantP], ops : OptionsPattern[SimulateEquilibriumConstant]] := Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output->_, OutputFormat->_]];
	SimulateEquilibriumConstant[inList, Sequence@@Append[noOutputOptions,Output->Preview]]
];



(* ::Subsubsection:: *)
(*ValidSimulateEquilibriumConstantQ*)

DefineOptions[ValidSimulateEquilibriumConstantQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {SimulateEquilibriumConstant}
];

Authors[ValidSimulateEquilibriumConstantQ] := {"brad"};

ValidSimulateEquilibriumConstantQ[myInput: Alternatives[inputPatternSimulateEquilibriumConstantP, listInputPatternSimulateEquilibriumConstantP], myOptions:OptionsPattern[ValidSimulateEquilibriumConstantQ]]:=Module[
	{listedInput, listedObjects, listedOptions, preparedOptions, functionTests, initialTestDescription, allTests, safeOps, verbose, outputFormat, result},

	listedInput = ToList[myInput];
	listedObjects = Cases[listedInput, ObjectP[], All];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = Join[Normal[KeyDrop[{}, {Verbose, OutputFormat}]], {Output->Tests}];

	(* Call the function to get a list of tests *)
	functionTests = SimulateEquilibriumConstant[myInput,preparedOptions];

	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests = If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings,testResults},
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedObjects,OutputFormat->Boolean];

			If[!MatchQ[listedObjects, {}],
				voqWarnings = MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (if an object, run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{listedObjects,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[{initialTest},functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidSimulateEquilibriumConstantQ" -> allTests|>, OutputFormat->outputFormat, Verbose->verbose]["ValidSimulateEquilibriumConstantQ"]
];



(* ::Subsubsection::Closed:: *)
(*resolveInputsSimulateEquilibriumConstant*)

(* given reaction & structures. will compute enthalpy and entropy later *)
resolveInputsSimulateEquilibriumConstant[in:inputPatternThermoCalcP,resolvedOps_]:=
	resolveInputsSimulateEquilibriumConstant[in,defaultTemperatureValue,resolvedOps];
resolveInputsSimulateEquilibriumConstant[in:inputPatternThermoCalcP,temperature:tempArgumentP,resolvedOps_]:=Module[
	{structures, reaction, enthalpy, entropy, freeEnergy, returnBool, inval},
	inval = Switch[Lookup[resolvedOps,ReactionType],
		Null, in,
		Hybridization, in,
		Melting, in,
		_, in
	];
	{reaction, structures} = resolveInputsThermoCalculation[SimulateEquilibriumConstant,inval,resolvedOps];
	{enthalpy,entropy,freeEnergy}={Null,Null,Null};
	returnBool = resolveReturnEC[structures, temperature];
	{reaction, structures, enthalpy, entropy, freeEnergy, N[temperature], returnBool}
];


(* given enthalpy & entropy. structures and reaction not known *)
resolveInputsSimulateEquilibriumConstant[enthalpy:enthalpyArgumentP,entropy:entropyArgumentP,resolvedOps_]:=
	resolveInputsSimulateEquilibriumConstant[enthalpy,entropy,defaultTemperatureValue,resolvedOps];
resolveInputsSimulateEquilibriumConstant[enthalpy:enthalpyArgumentP,entropy:entropyArgumentP,temperature:tempArgumentP,resolvedOps_]:=Module[
	{structures, reaction, freeEnergy, returnBool},
	{reaction, structures, freeEnergy} = {Null,Null,Null};
	returnBool = resolveReturnEC[enthalpy, entropy, temperature];
	{reaction, structures, resolveEnthalpy[enthalpy], resolveEntropy[entropy], freeEnergy ,N[temperature], returnBool}
];

(* given free energy.  structures and reaction not known *)
resolveInputsSimulateEquilibriumConstant[freeEnergy:freeEnergyArgumentP,resolvedOps_]:=
	resolveInputsSimulateEquilibriumConstant[freeEnergy,defaultTemperatureValue,resolvedOps];
resolveInputsSimulateEquilibriumConstant[freeEnergy:freeEnergyArgumentP,temperature:tempArgumentP,resolvedOps_]:=Module[
	{structures, reaction, enthalpy, entropy, returnBool},
	{structures, reaction, enthalpy, entropy} = {Null,Null,Null,Null};
	returnBool = resolveReturnEC[freeEnergy, temperature];
	{reaction, structures, enthalpy, entropy, resolveFreeEnergy[freeEnergy], N[temperature], returnBool}
];


(* ::Subsubsection:: *)
(*SimulateEquilibriumConstantCore*)


SimulateEquilibriumConstantCore[{fail:(Null|$Failed), _}] := fail;
(* if given reaction and/or structures *)
SimulateEquilibriumConstantCore[{{reaction_,structs_,enth:Null,entr:Null,fe:Null,temp_},resolvedOps_}]:=Module[
	{entropy, enthalpy, tempDistr, tempDistrC, eqc},
	entropy = bindingEntropyFromReaction[reaction,resolvedOps];
	enthalpy = bindingEnthalpyFromReaction[reaction,resolvedOps];
	tempDistr = resolveTemperature[temp];
	eqc = eqcFromEnthalpyAndEntropy[enthalpy, entropy, tempDistr];
	tempDistrC = UnitConvert[tempDistr, "DegreesCelsius"];
	Join[
		formatOligomerPacketRules[structs,resolvedOps],
		{
			EquilibriumConstant->Mean[eqc],
			EquilibriumConstantStandardDeviation->StandardDeviation[eqc],
			EquilibriumConstantDistribution->eqc,
			Temperature->Mean[tempDistrC],
			TemperatureStandardDeviation->StandardDeviation[tempDistrC],
			TemperatureDistribution->tempDistrC,
			Reaction->reaction
		}
	]
];

(* if given enthalpy and entropy and structures/reaction not known *)
SimulateEquilibriumConstantCore[{{reaction:Null,structs:Null,enthalpy_,entropy_,fe:Null,temp_},resolvedOps_}]:=Module[
	{eqc, tempDistr, tempDistrC},
	tempDistr = resolveTemperature[temp];
	eqc = eqcFromEnthalpyAndEntropy[enthalpy, entropy, tempDistr];
	tempDistrC = UnitConvert[tempDistr, "DegreesCelsius"];
	Join[{
		EquilibriumConstant->Mean[eqc],
		EquilibriumConstantStandardDeviation->StandardDeviation[eqc],
		EquilibriumConstantDistribution->eqc,
		Temperature->Mean[tempDistrC],
		TemperatureStandardDeviation->StandardDeviation[tempDistrC],
		TemperatureDistribution->tempDistrC
	}]
];

(* if given free energy *)
SimulateEquilibriumConstantCore[{{reaction:Null,structs:Null,enth:Null,entr:Null,fe_,temp_},resolvedOps_}]:=Module[
	{eqc, tempDistr, tempDistrC},
	tempDistr = resolveTemperature[temp];
	eqc = eqcFromFreeEnergy[fe, tempDistr];
	tempDistrC = UnitConvert[tempDistr, "DegreesCelsius"];
	Join[{
		EquilibriumConstant->Mean[eqc],
		EquilibriumConstantStandardDeviation->StandardDeviation[eqc],
		EquilibriumConstantDistribution->eqc,
		Temperature->Mean[tempDistrC],
		TemperatureStandardDeviation->StandardDeviation[tempDistrC],
		TemperatureDistribution->tempDistrC
	}]
];



(* need all these assumptions to avoid Conditional solution  *)
(* equilibriumConstantExpressionSymbolic=Simplify[Keq/.First[Flatten[Solve[(GibbsEquilibrium),Keq]]],Assumptions->{Element[\[CapitalDelta]G,Reals],Element[R,Reals],Element[T,Reals],T>0,R>0}];
equilibriumConstantExpression = equilibriumConstantExpressionSymbolic /. R->MolarGasConstantStandardUnits;
MolarGasConstantStandardUnitless=Unitless[MolarGasConstantStandardUnits,CaloriePerMoleKelvin];
equilibriumConstantExpressionUnitlessHS=equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnitless/.First[Flatten[Solve[GibbsFreeEnergy,\[CapitalDelta]G]]];
equilibriumConstantExpressionUnitlessG=equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnitless;
equilibriumConstantExpressionHS=equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnits/.First[Flatten[Solve[GibbsFreeEnergy,\[CapitalDelta]G]]];
equilibriumConstantExpressionG=equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnits;*)



equilibriumConstantExpressionSymbolic = E^(-(\[CapitalDelta]G/(R*T)));
MolarGasConstantStandardUnitless = Unitless[MolarGasConstant,CaloriePerMoleKelvin];
equilibriumConstantExpressionUnitlessHS = equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnitless/.First[Flatten[Solve[GibbsFreeEnergy,\[CapitalDelta]G]]];
equilibriumConstantExpressionUnitlessG = equilibriumConstantExpressionSymbolic/.R->MolarGasConstantStandardUnitless;


eqcFromEnthalpyAndEntropy[enth_,entr_,temp_]:=Module[
	{enthU, entrU, eqc},
	enthU = QuantityMagnitude[enth];
	enthU = PropagateUncertainty[Evaluate[1000 * enthU]];
	entrU = QuantityMagnitude[entr];
	eqc = PropagateUncertainty[equilibriumConstantExpressionUnitlessHS, {
		\[CapitalDelta]H \[Distributed] enthU,
		\[CapitalDelta]S \[Distributed] entrU,
		T \[Distributed] QuantityMagnitude[temp]
	}];

	eqc
];


eqcFromFreeEnergy[fe_,temp_]:=Module[
	{feU, eqc},
	feU = QuantityMagnitude[fe];

	eqc = PropagateUncertainty[Evaluate[equilibriumConstantExpressionUnitlessG], {
		\[CapitalDelta]G \[Distributed] feU,
		T \[Distributed] QuantityMagnitude[temp]
	}];

	eqc
];


(* this is used to get rates from mechanisms/kinetics *)
unitlessEquilibriumConstantFromG[fe_,temp_]:=Module[{},
	ReplaceAll[equilibriumConstantExpressionUnitlessG,{\[CapitalDelta]G->fe,T->temp}]
];



(* ::Subsubsection:: *)
(*formatOutputSimulateEquilibriumConstant*)


formatOutputSimulateEquilibriumConstant[functionName_,startFields_,inputLinkFields_, fail:(Null|$Failed), resolvedOps_] := fail;
formatOutputSimulateEquilibriumConstant[functionName_,startFields_,inputLinkFields_,coreFields_,resolvedOps_]:=Module[
	{out, tempOut},

	out=Association[Join[{Type->Object[Simulation, EquilibriumConstant]},
			startFields,
			simulationPacketStandardFieldsFinish[resolvedOps],
			inputLinkFields,
			coreFields
		]
	]
];


(* ::Subsubsection:: *)
(*resolveListInputsSimulateEquilibriumConstant*)


resolveListInputsSimulateEquilibriumConstant[in:{inputPatternThermoCalcP..}]:={in};
resolveListInputsSimulateEquilibriumConstant[in1:{inputPatternThermoCalcP..},in2:tempArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateEquilibriumConstant[in1:inputPatternThermoCalcP,in2:{tempArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateEquilibriumConstant[in1:{inputPatternThermoCalcP..},in2:{tempArgumentP..}]:={in1,in2};

resolveListInputsSimulateEquilibriumConstant[in:{freeEnergyArgumentP..}]:={in};
resolveListInputsSimulateEquilibriumConstant[in1:{freeEnergyArgumentP..},in2:tempArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateEquilibriumConstant[in1:freeEnergyArgumentP,in2:{tempArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateEquilibriumConstant[in1:{freeEnergyArgumentP..},in2:{tempArgumentP..}]:={in1,in2};

resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:entropyArgumentP]:={in1,Table[in2,{Length[in1]}]};
resolveListInputsSimulateEquilibriumConstant[in1:enthalpyArgumentP,in2:{entropyArgumentP..}]:={Table[in1,{Length[in2]}],in2};
resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:tempArgumentP]:={in1,Table[in2,{Length[in1]}],Table[in3,{Length[in1]}]};
resolveListInputsSimulateEquilibriumConstant[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:tempArgumentP]:={Table[in1,{Length[in2]}],in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{tempArgumentP..}]:={Table[in1,{Length[in3]}],Table[in2,{Length[in3]}],in3};
resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:tempArgumentP]:={in1,in2,Table[in3,{Length[in2]}]};
resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:entropyArgumentP,in3:{tempArgumentP..}]:={in1,Table[in2,{Length[in1]}],in3};
resolveListInputsSimulateEquilibriumConstant[in1:enthalpyArgumentP,in2:{entropyArgumentP..},in3:{tempArgumentP..}]:={Table[in1,{Length[in2]}],in2,in3};
resolveListInputsSimulateEquilibriumConstant[in1:{enthalpyArgumentP..},in2:{entropyArgumentP..},in3:{tempArgumentP..}]:={in1,in2,in3};