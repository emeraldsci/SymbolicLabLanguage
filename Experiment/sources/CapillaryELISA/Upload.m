(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadCapillaryELISACartridge*)

(* ::Subsubsection::Closed:: *)
(*$UploadCapillaryELISACartridgeAsDeveloperObject*)

(* in order for the tests not to mess up other tests, the unit tests are going to set this to True.  This makes the DeveloperObject field be True so that the created objects won't show up in Search *)
$UploadCapillaryELISACartridgeAsDeveloperObject = False;

(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadCapillaryELISACartridge,
	Options:>{
		{
			OptionName->CartridgeType,
			Default->Automatic,
			Description->"The type of capillary ELISA cartridge (SinglePlex72X1, MultiAnalyte32X4, MultiAnalyte16X4 or MultiPlex32X8) that is created.",
			ResolutionDescription->"CartridgeType option is automatically selected based on the number of analytes. For 1 analyte input, SinglePlex72X1 is selected. For input analytes number between 2 and 4, MultiAnalyte32X4 type is automatically selected. For input analytes number between 5 and 8, MultiPlex32X8 is automatically selected.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>Alternatives[SinglePlex72X1,MultiAnalyte32X4,MultiAnalyte16X4,MultiPlex32X8]
			],
			Category->"Organizational Information"
		},
		{
			OptionName->Species,
			Default->Automatic,
			Description->"The organism (human, mouse or rat) origin of the samples that this capillary ELISA cartridge model is used for.",
			ResolutionDescription->"Species option is automatically selected based on the analytes input. If the input analytes contains special analytes of mouse (Macrophage Inflammatory Protein 2 or Cystatin C), then Species is automatically set to Mouse. Otherwise Species option is automatically set to Human.",
			AllowNull->False,
			Widget->Widget[
				Type->Enumeration,
				Pattern:>ELISASpeciesP
			],
			Category->"Organizational Information"
		},

		OutputOption,
		CacheOption,
		UploadOption
	}
];


(* ::Subsubsection::Closed:: *)
(* UploadCapillaryELISACartridge Error Messages *)

(* Most of the options are shared with ExperimentCapillaryELISA and those error messages are used. *)
Warning::CapillaryELISACartridgeExist="The requested Capillary ELISA cartridge already exists. Please use `1` directly in ExperimentCapillaryELISA.";


(* ::Subsubsection::Closed:: *)
(* UploadCapillaryELISACartridge *)

(* Overload - only 1 analyte - change it to our main overload *)
UploadCapillaryELISACartridge[myAnalyte:ObjectP[Model[Molecule]]|CapillaryELISAAnalyteP,myOptions:OptionsPattern[UploadCapillaryELISACartridge]]:=UploadCapillaryELISACartridge[{myAnalyte},myOptions];

UploadCapillaryELISACartridge[myAnalytes:{ObjectP[Model[Molecule]]..}|{CapillaryELISAAnalyteP..},myOptions:OptionsPattern[UploadCapillaryELISACartridge]]:=Module[
	{
		listedInputs,listedOptions,outputSpecification,listedOutput,gatherTests,messages,safeOptions,safeOptionTests,author,cache,manufacturingSpecificationFields,potentialManufacturingSpecifications,cacheBall,
		manufacuringSpecificationPackets,manufacturingSpecificationPacketsByAnalytes,suppliedCartridgeType,suppliedSpecies,analyteMolecules,
		duplicatedAnalyteIdentityModels,duplicatedAnalytes,duplicatedAnalytesInput,duplicatedAnalytesTests,tooManyAnalytesInput,
		tooManyAnalytesTests,tooManyAnalytesForSampleNumberQ,unsupportedAnalytes,supportedAnalytes,unsupportedAnalytesInput,unsupportedAnalytesTests,analyteSpecies,wrongAnalytesSpeciesQ,wrongSpeciesAnalytes,wrongSpeciesAnalytesOption,wrongSpeciesAnalytesTests,analyteCartridgeTypes,analyteMultiPlexQ,wrongCartridgeTypeAnalytes,wrongCartridgeTypeAnalytesInput,wrongCartridgeTypeAnalytesOption,wrongCartridgeTypeAnalytesTests,analyteDiluents,analyteAllDiluents,analyteCommonDiluentQ,analyteMinDilutionFactors,analyteAllMinDilutionFactors,analyteCommonMinDilutionFactorQ,analyteIncompatibleAnalytes,incompatibleAnalyteQ,incompatibleAnalyteDiluentInput,incompatibleAnalyteMinDilutionFactorInput,incompatibleAnalytesInput,incompatibleAnalyteDiluentTests,incompatibleAnalyteDilutionFactorTests,incompatibleAnalytesTests,
		resolvedCartridgeType,resolvedSpecies,resolvedPreLoadedAnalyteMolecules,resolvedPreLoadedAnalyteNames,resolvedPreLoadedAnalyteManuSpecs,resolvedPreLoadedAnalyteManuSpecObjects,emptyCartridgeChannelQ,emptyCartridgeChannelTests,bestDiluent,existingCartridge,existingCartridgeQ,existingCartridgeTest,
		invalidInputs,invalidOptions,resolvedOptions,allTests,resolvedOptionsResult,
		newCartridgeName,newCartridgeValues,newCapillaryELISACartridgeModelPacket,newCartridgeProductSampleNumber,newCartridgeProductDescription,newCartridgeProductPrice,newCartridgeProductEstimatedLeadTime,newCapillaryELISACartridgeProductPacket,
		allSinglePlex72X1Positions,allMultiAnalyte16X4Positions,allMultiAnalyte32X4Positions,allMultiPlex32X8Positions,allSinglePlex72X1PositionPlottings,allMultiAnalyte16X4PositionPlottings,allMultiAnalyte32X4PositionPlottings,allMultiPlex32X8PositionPlottings,singlePlex72X1Values,multiAnalyte16X4Values,multiAnalyte32X4Values,multiPlex32X8Values,
		allTestTestResults,optionsRule,previewRule,testsRule,resultRule, upload
	},

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	listedOutput=ToList[outputSpecification];

	(* determine if we should keep a running list of tests. When we are not getting tests, we throw messages *)
	gatherTests=MemberQ[listedOutput,Tests];
	messages=!gatherTests;

	(* Make sure we're working with a list of inputs and options *)
	(* Remove temporal links and named objects. *)
	{listedInputs,listedOptions}=removeLinks[ToList[myAnalytes],ToList[myOptions]];

	(* default all unspecified or incorrectly-specified options *)
	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[UploadCapillaryELISACartridge,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[UploadCapillaryELISACartridge,listedOptions,AutoCorrect->False], {}}
	];

	(* If the specified options don't match their patterns, allowed to return an early hard failure; make sure to hit up tests if asked *)
	If[MatchQ[safeOptions,$Failed],
		Return[
			outputSpecification /. {
				Result->$Failed,
				Tests->safeOptionTests,
				Preview->Null,
				Options->$Failed
			}
		]
	];

	(* pseudo-resolve the hidden Author option; either it's Null (meaning we're being called by a User, so they are the author); or it's passed via Engine, and is a root protocol Author *)
	author=If[MatchQ[Lookup[safeOptions,Author],ObjectP[Object[User]]],
		Lookup[safeOptions,Author],
		$PersonID
	];

	(* Look up the provided Cache and Upload options. If we are from the ExperimentCapillaryELISA option, we get the cache and there is no need to download again. *)
	{upload, cache} = Lookup[safeOptions,{Upload, Cache}];

	(* Fields to download from all capillary ELISA cartridge manufacturing specification objects *)
	manufacturingSpecificationFields=Packet[Name,AnalyteName,AnalyteMolecule,CartridgeType,Species,RecommendedMinDilutionFactor,RecommendedDiluent,IncompatibleAnalytes,UpperQuantitationLimit,LowerQuantitationLimit,EstimatedLeadTime];

	(* All the available manufacturing specifications. We have to get all of them as it might be possible to resolve to any of these. *)
	potentialManufacturingSpecifications=Flatten[
		DeleteDuplicates[
			Map[
				If[MatchQ[#,ObjectP[Model[Molecule]]],
					Search[Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteMolecule==Download[#,Object]],
					Search[Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteName==#]
				]&,
				listedInputs
			]
		]
	];

	(* Do our big download. We only need information from manufacturing specifications. We can either get everything from passed cache or download. This is important because we have to transfer this into ObjectToString for error messages *)
	cacheBall=If[MatchQ[cache,{}],
		Quiet[
			FlattenCachePackets[
				If[MatchQ[listedInputs,ListableP[ObjectP[Model[Molecule]]]],
					Download[
						{
							listedInputs,
							potentialManufacturingSpecifications
						},
						{
							{Packet[Name,Object]},
							{manufacturingSpecificationFields}
						},
						Cache->cache,
						Date->Now
					],
					Download[
						potentialManufacturingSpecifications,
						{manufacturingSpecificationFields},
						Cache->cache,
						Date->Now
					]
				]
			],
			{Download::FieldDoesntExist}
		],
		cache
	];


	(* We can download all the manufacuring specifications *)
	manufacuringSpecificationPackets=Cases[cacheBall,KeyValuePattern[Type->Object[ManufacturingSpecification,CapillaryELISACartridge]]];

	(* Break them into different sublists based on analytes *)
	manufacturingSpecificationPacketsByAnalytes=Map[
		If[MatchQ[#,ObjectP[Model[Molecule]]],
			Cases[manufacuringSpecificationPackets,KeyValuePattern[AnalyteMolecule->LinkP[#]]],
			Cases[manufacuringSpecificationPackets,KeyValuePattern[AnalyteName->#]]
		]&,
		listedInputs
	];

	(* Get all the option values *)
	suppliedCartridgeType=Lookup[safeOptions,CartridgeType];
	suppliedSpecies=Lookup[safeOptions,Species];


	(* Prepare the analytes for option conflict check *)
	(* Get the identity models of the pre-loaded analytes - This is because we want to make sure there are no duplicates - analytes of different generations cannot be combined in the same cartridge *)
	analyteMolecules=Map[
		If[MatchQ[#,CapillaryELISAAnalyteP],
			Download[
				Lookup[
					FirstCase[
						manufacuringSpecificationPackets,
						KeyValuePattern[{Type->Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteName->#}],
						<||>
					],
					AnalyteMolecule,
					Null
				],
				(* Get rid of the link *)
				Object
			],
			(* Keep the existing identity model *)
			#
		]&,
		listedInputs
	];


	(* Option Conflict Checks *)

	(* Analytes should not have duplicated members *)
	(* Find the duplicated members in the Analytes option. We check the identity models as even different generation assays are available for a certain analyte, they cannot be combined. *)
	duplicatedAnalyteIdentityModels=DeleteDuplicates[
		Select[analyteMolecules,Count[analyteMolecules,#]>1&]
	];

	(* Keep the supplied Analyte Molecules or turn into Analyte Names *)
	duplicatedAnalytes=PickList[listedInputs,analyteMolecules,Alternatives@@duplicatedAnalyteIdentityModels];

	(* If we have duplicated members, throw error message. *)
	duplicatedAnalytesInput=If[!MatchQ[duplicatedAnalytes,{}]&&messages,
		Message[Error::DuplicatedAnalytes,ObjectToString[duplicatedAnalytes,Cache->cacheBall]];duplicatedAnalytes,
		{}
	];

	(* If we need to gather tests, generate tests for duplicated analytes *)
	duplicatedAnalytesTests=If[gatherTests,
		Test["The specified Analytes for a pre-loaded capillary ELISA cartridge do not have duplicated members:",MatchQ[duplicatedAnalytes,{}],True],
		{}
	];

	(* The total number of analytes must be smaller than the capacity of the specified CartridgeType. We do this when CartridgeType is specified, after duplicates are taken out to avoid giving the user too many error messages. *)
	tooManyAnalytesInput=Which[

		(* The total number of analytes should not be larger than 8 *)
		MatchQ[suppliedCartridgeType,Automatic]&&TrueQ[Length[DeleteDuplicates[analyteMolecules]]>8]&&messages,
		Message[Error::TooManyAnalytes,"8"];listedInputs,

		MatchQ[suppliedCartridgeType,Automatic],{},

		(* If CartridgeType is supplied, we should not exceed its capacity *)
		TrueQ[Length[DeleteDuplicates[analyteMolecules]]>First[cartridgeCapacity[suppliedCartridgeType]]]&&messages,
		Message[Error::TooManyAnalytes,ToString[First[cartridgeCapacity[suppliedCartridgeType]]]];listedInputs,
		True,{}
	];

	(* If we need to gather tests, generate tests for too many analytes *)
	tooManyAnalytesTests=If[gatherTests,
		Test["The number of the specified Analytes option is no more than the total allowed number of the specified CartridgeType:",MatchQ[tooManyAnalytesInput,{}],True],
		{}
	];

	(* The specified analytes in the input must be supported by the pre-loaded cartridges *)
	(* Check with the global variable preLoadedCartridgeAnalytes to find a list of unsupported analytes *)
	(* If the analytes are provided as CapillaryELISAAnalyteP, they are definitely supported. We don't worry about turning the identity models back to CapillaryELISAAnalyteP here. *)
	unsupportedAnalytes=If[MatchQ[listedInputs,ListableP[CapillaryELISAAnalyteP]],
		{},
		DeleteCases[analyteMolecules,ObjectP[findPreLoadedCartridgeAnalytes[Cache->cacheBall]]]
	];

	supportedAnalytes=If[MatchQ[listedInputs,ListableP[CapillaryELISAAnalyteP]],
		listedInputs,
		Complement[analyteMolecules,unsupportedAnalytes]
	];

	unsupportedAnalytesInput=If[!MatchQ[unsupportedAnalytes,{}]&&messages,
		Message[Error::UnsupportedAnalytes,ObjectToString[unsupportedAnalytes,Cache->cacheBall]];unsupportedAnalytes,
		{}
	];

	(* If we need to gather tests, generate tests for unsupported analytes *)
	unsupportedAnalytesTests=If[gatherTests,
		Module[{passingTest,failingTest},
			passingTest=If[Length[supportedAnalytes]==0,
				Nothing,
				Test["The specified Analytes "<>ObjectToString[supportedAnalytes,Cache->cacheBall]<>" are supported by the assay developer for pre-loaded capillary ELISA cartridges:",True,True]
			];
			failingTest=If[Length[unsupportedAnalytes]==0,
				Nothing,
				Test["The specified Analytes "<>ObjectToString[unsupportedAnalytes,Cache->cacheBall]<>" are supported by the assay developer for pre-loaded capillary ELISA cartridges:",True,False]
			];
			{passingTest,failingTest}
		],
		{}
	];

	(* The specified analytes must be in accordance with the specified Species. *)
	(* Find the species of each analyte through their manufacturing specifications *)
	analyteSpecies=Map[
		Lookup[#,Species]&,
		manufacturingSpecificationPacketsByAnalytes,
		{2}
	];

	(* Check the Species of each analyte *)
	wrongAnalytesSpeciesQ=Which[

		(* If we are going to have a MultiPlex32X8 cartridge, the species must be Human *)
		MatchQ[suppliedSpecies,Automatic]&&TrueQ[Length[DeleteDuplicates[analyteMolecules]]>4],
		Map[MemberQ[#,Human]&,analyteSpecies],

		MatchQ[suppliedSpecies,Automatic],
		ConstantArray[True,Length[analyteSpecies]],

		True,
		Map[MemberQ[#,suppliedSpecies]&,analyteSpecies]
	];

	(* Get the wrong species analytes out of the manufacturing specifications - either as CapillaryELISAAnalyteP or the identity models *)
	wrongSpeciesAnalytes=PickList[listedInputs,wrongAnalytesSpeciesQ,False];

	(* Track the invalid option and throw messages if we have wrong species analytes *)
	wrongSpeciesAnalytesOption=If[!MatchQ[wrongSpeciesAnalytes,{}]&&messages,
		Message[Error::AnalytesSpeciesUnavailable,ObjectToString[wrongSpeciesAnalytes,Cache->cacheBall]];{Species},
		{}
	];

	(* If we need to gather tests, generate tests for wrong species analytes *)
	wrongSpeciesAnalytesTests=If[gatherTests,
		Module[{passingTest,failingTest},
			passingTest=If[MatchQ[Complement[listedInputs,wrongSpeciesAnalytes],{}],
				Nothing,
				Test["The specified Analytes "<>ObjectToString[Complement[listedInputs,wrongSpeciesAnalytes],Cache->cacheBall]<>" are in accordance with the specified Species:",True,True]
			];
			failingTest=If[MatchQ[wrongSpeciesAnalytes,{}],
				Nothing,
				Test["The specified Analytes "<>ObjectToString[wrongSpeciesAnalytes,Cache->cacheBall]<>" are in accordance with the specified Species:",True,False]
			];
			{passingTest,failingTest}
		],
		{}
	];

	(* The specified analytes must be in Pro-Inflammation and Oncology panel to be used with MultiPlex32X8 cartridge *)
	(* Find the supported CartridgeType for each analyte, considering all the possible cases if available *)
	analyteCartridgeTypes=Map[
		Lookup[#,CartridgeType,{}]&,
		manufacturingSpecificationPacketsByAnalytes,
		{2}
	];

	(* Check whether each analyte can be used with MultiPlex32X8 cartridge type *)
	analyteMultiPlexQ=Map[
		MemberQ[Flatten[#],MultiPlex32X8]&,
		analyteCartridgeTypes
	];

	(* Get a list of wrong cartridge type analytes *)
	wrongCartridgeTypeAnalytes=PickList[listedInputs,analyteMultiPlexQ,False];

	(* Find whether each specified member of Analytes can be used with MultiPlex32X8 cartridge type *)
	wrongCartridgeTypeAnalytesInput=Which[

		(* Check this when MultiPlex32X8 is selected *)
		MemberQ[analyteMultiPlexQ,False]&&MatchQ[suppliedCartridgeType,MultiPlex32X8]&&messages,
		Message[Error::AnalytesIncompatibleWithCartridgeType,ObjectToString[PickList[wrongCartridgeTypeAnalytes,analyteMultiPlexQ,False],Cache->cacheBall]];wrongCartridgeTypeAnalytes,

		(* Also check this when there are more than 4 analytes selected *)
		MemberQ[analyteMultiPlexQ,False]&&MatchQ[suppliedCartridgeType,Automatic]&&TrueQ[Length[DeleteDuplicates[analyteMolecules]]>4]&&messages,
		Message[Error::AnalytesIncompatibleWithCartridgeType,ObjectToString[PickList[wrongCartridgeTypeAnalytes,analyteMultiPlexQ,False],Cache->cacheBall]];wrongCartridgeTypeAnalytes,

		True,{}
	];

	(* Track the invalid option of CartridgeType when necessary *)
	wrongCartridgeTypeAnalytesOption=If[MatchQ[suppliedCartridgeType,MultiPlex32X8]&&TrueQ[Length[DeleteDuplicates[analyteMolecules]]<=4],

		(* When MultiPlex32X8 is selected but not necessary - total analytes <4, give invalid option *)
		{CartridgeType},

		(* Otherwise we think the inputs are invalid *)
		{}
	];

	(* If we need to gather tests, generate tests for wrong cartridge type analytes *)
	wrongCartridgeTypeAnalytesTests=If[gatherTests,
		Module[{passingTest,failingTest},
			passingTest=If[MatchQ[Complement[listedInputs,wrongCartridgeTypeAnalytes],{}],
				Nothing,
				Test["The specified Analytes "<>ObjectToString[Complement[listedInputs,wrongCartridgeTypeAnalytes],Cache->cacheBall]<>" are available for MultiPlex32X8 cartridge:",True,True]
			];
			failingTest=If[MatchQ[wrongCartridgeTypeAnalytes,{}],
				Nothing,
				Test["The specified Analytes "<>ObjectToString[wrongCartridgeTypeAnalytes,Cache->cacheBall]<>" are available for MultiPlex32X8 cartridge:",True,False]
			];
			{passingTest,failingTest}
		],
		{}
	];

	(* Find whether the specified members of Analytes are incompatible with each other. This is a large project as we have to check Diluent, MinDilutionFactor and also special IncompatibleAnalytes. All the information is from manufacturing specifications. *)
	(* It should be noted that for a single analyte, even if different generations of assays are available - like for IL-6, their minimum dilution factor and recommended diluent should be the same because the nature of the analyte is the same - like serum, plasma, etc... *)
	(* The only thing that can be different for different assay generations is whether they can be used for MultiPlex32X8 and we have checked it above *)
	(* TODO The checks we are doing here cannot cover the case that one assay generation share the minimum dilution factor with other analytes but another assay generation share the diluent with other analytes. This should not happen as we mentioned above. In the future cases, we can try to check this by combining all the checks together. It is not quite necessary at this moment. In the worst case, we are turned down by the sales rep during ordering process. *)
	(* Get the Diluents information of each analyte *)
	analyteDiluents=Map[
		Download[Lookup[#,RecommendedDiluent],Object]&,
		manufacturingSpecificationPacketsByAnalytes,
		{2}
	];

	(* For each analyte, flatten the list to combine all the possible analyte assay generations to show all possible diluents *)
	analyteAllDiluents=DeleteCases[
		Map[
			DeleteDuplicates[
				Flatten[#]
			]&,
			analyteDiluents
		],
		(* Delete empty list for the cases that we have unsupported analytes *)
		{}
	];

	(* Check whether the analytes can share the same diluent *)
	analyteCommonDiluentQ=If[MatchQ[analyteAllDiluents,{}],
		True,
		!MatchQ[Intersection@@analyteAllDiluents,{}]
	];

	(* Get the MinDilutionFactor information of each analyte *)
	analyteMinDilutionFactors=DeleteCases[
		Map[
			Lookup[#,RecommendedMinDilutionFactor]&,
			manufacturingSpecificationPacketsByAnalytes,
			{2}
		],
		(* Delete empty list for the cases that we have unsupported analytes *)
		{}
	];

	(* For each analyte, flatten the list to combine all the possible analyte assay generations to show all possible MinDilutionFactor *)
	analyteAllMinDilutionFactors=Map[
		DeleteDuplicates[#]&,
		analyteMinDilutionFactors
	];

	(* Check whether the analytes can share the same MinDilutionFactor *)
	analyteCommonMinDilutionFactorQ=If[MatchQ[analyteMinDilutionFactors,{}],
		True,
		!MatchQ[Intersection@@analyteAllMinDilutionFactors,{}]
	];

	(* Get the IncompatibleAnalytes information of each analyte. Turn the manufacturing specifications into its objec reference so that we can easily compare. *)
	analyteIncompatibleAnalytes=Map[
		Download[
			Lookup[#,IncompatibleAnalytes,{}],
			Object,
			Cache->cacheBall
		]&,
		manufacturingSpecificationPacketsByAnalytes,
		{2}
	];

	(* Check whether each analyte's incompatible analytes have members from the experiment's analytes *)
	incompatibleAnalyteQ=ContainsNone[
		Flatten[analyteIncompatibleAnalytes],
		Lookup[Flatten[manufacturingSpecificationPacketsByAnalytes],Object]
	];

	(* If any of the Diluent, MinDilutionFactor and IncompatibleAnalytes checks failed, throw error messages *)
	(* TODO: If I get more details from ProteinSimple, these messages and tests will be updated*)
	incompatibleAnalyteDiluentInput=If[!analyteCommonDiluentQ&&messages,
		Message[Error::NoCommonDiluentForAnalytes,ObjectToString[Lookup[Flatten[manufacturingSpecificationPacketsByAnalytes],Object,{}],Cache->cacheBall]];listedInputs,
		{}
	];
	incompatibleAnalyteMinDilutionFactorInput=If[!analyteCommonMinDilutionFactorQ&&messages,
		Message[Error::NoCommonMinDilutionFactorForAnalytes,ObjectToString[Lookup[Flatten[manufacturingSpecificationPacketsByAnalytes],Object,{}],Cache->cacheBall]];listedInputs,
		{}
	];
	incompatibleAnalytesInput=If[!incompatibleAnalyteQ&&messages,
		Message[Error::IncompatibleAnalytes,ObjectToString[Lookup[Flatten[manufacturingSpecificationPacketsByAnalytes],Object,{}],Cache->cacheBall]];listedInputs,
		{}
	];

	(* If we need to gather tests, generate tests for incompatible analytes *)
	incompatibleAnalyteDiluentTests=If[gatherTests,
		Test["The specified analytes must be able to share the same diluent to be used together in a single capillary ELISA cartridge:",analyteCommonDiluentQ,True],
		{}
	];
	incompatibleAnalyteDilutionFactorTests=If[gatherTests,
		Test["The specified analytes must be able to share the same minimum dilution factor to be used together in a single capillary ELISA cartridge:",analyteCommonMinDilutionFactorQ,True],
		{}
	];
	incompatibleAnalytesTests=If[gatherTests,
		Test["The specified Analytes should be compatible with each other to be used together in a single capillary ELISA cartridge:",incompatibleAnalyteQ,True],
		{}
	];


	(* Resolve Options *)
	(* The option resolver logic is easy - we always try to resolve to the CartridgeType that can cover all the analytes *)
	resolvedCartridgeType=Which[
		!MatchQ[suppliedCartridgeType,Automatic],suppliedCartridgeType,
		Length[DeleteDuplicates[analyteMolecules]]==1,SinglePlex72X1,
		Length[DeleteDuplicates[analyteMolecules]]<=4,MultiAnalyte32X4,
		True,MultiPlex32X8
	];

	(* Because the species all share the same Species, we can use the first available value *)
	resolvedSpecies=If[MatchQ[suppliedSpecies,Automatic],
		First[Intersection@@analyteSpecies],
		suppliedSpecies
	];

	(* Next we have to find Analyte Names when Analyte Molecules are given. The only issue here is that we must select the Manufacturing Specifications that is compatible with all the option information. We have checked that at least one generation is compatible with the others. Select a good combination *)
	resolvedPreLoadedAnalyteMolecules=If[MatchQ[listedInputs,ListableP[ObjectP[Model[Molecule]]]],

		(* Get rid of the non-qualified analyte molecules and get rid of duplicates *)
		(* This is done to make sure our helper function is happy - there are manufacturing specifications available for every analyte *)
		DeleteDuplicates[supportedAnalytes],

		(* Turn the names into molecules easily through the manufacturing specifications *)
		(* AnalyteName is unique so only one case should be found per analyte pattern *)
		Download[Lookup[DeleteDuplicates[Flatten[manufacturingSpecificationPacketsByAnalytes]],AnalyteMolecule,Null],Object]
	];

	resolvedPreLoadedAnalyteNames=If[MatchQ[listedInputs,ListableP[ObjectP[Model[Molecule]]]],

		(* Turn AnalyteMolecules into AnalyteNames. All errors should have been thrown earlier so it is safe to use our helper function for this purpose. *)
		First[resolvePreLoadedCartridgeAnalytes[resolvedCartridgeType,resolvedSpecies,resolvedPreLoadedAnalyteMolecules,Cache->cacheBall]],

		(* Keep the AnalyteNames *)
		listedInputs

	];

	(* Get the analyte manufacturing specification *)
	resolvedPreLoadedAnalyteManuSpecs=Map[
		FirstCase[
			cacheBall,
			KeyValuePattern[{Type->Object[ManufacturingSpecification,CapillaryELISACartridge],AnalyteName->#}],
			Null
		]&,
		resolvedPreLoadedAnalyteNames
	];

	resolvedPreLoadedAnalyteManuSpecObjects=Lookup[resolvedPreLoadedAnalyteManuSpecs,Object,Null];


	(* Throw warning messages if we don't have enough analytes in the cartridge. This must be done after option resolving. *)
	emptyCartridgeChannelQ=Which[
		(* If we cannot find supported analytes from user input, then no need to throw warning *)
		MatchQ[resolvedPreLoadedAnalyteMolecules,{}],False,
		TrueQ[Length[resolvedPreLoadedAnalyteMolecules]<cartridgeCapacity[resolvedCartridgeType][[1]]]&&!MatchQ[$ECLApplication,Engine],
		Message[Warning::EmptyCartridgeChannel,ToString[cartridgeCapacity[resolvedCartridgeType][[1]]],ToString[Length[resolvedPreLoadedAnalyteMolecules]]];True,
		True,False
	];

	(* make tests for empty cartridge channel warning if we need to do so *)
	emptyCartridgeChannelTests=If[gatherTests,
		Test["Every channel in the pre-loaded capillary ELISA cartridge should provide assay for a distinct analyte:",emptyCartridgeChannelQ,False],
		Nothing
	];


	(* Get the best diluent information - this is for uploading to Object[Product] *)
	bestDiluent=FirstOrDefault[Flatten[analyteAllDiluents],Model[Sample,"Simple Plex Sample Diluent 13"]];

	(* Find whether a Cartridge Model with all the specified information is already available *)
	existingCartridge=Intersection@@(
		Map[
			Search[
				Model[Container, Plate, Irregular, CapillaryELISA],
				AnalyteNames==#&&CartridgeType==resolvedCartridgeType
			]&,
			resolvedPreLoadedAnalyteNames
		]
	);

	(* We should always try to return the existing cartridge model when available *)
	existingCartridgeQ=!MatchQ[existingCartridge,{}];

	(* Throw an error message if we get an existing cartridge *)
	If[existingCartridgeQ&&messages,
		Message[Warning::CapillaryELISACartridgeExist,ObjectToString[existingCartridge[[1]]]]
	];

	existingCartridgeTest=Test["The requested capillary ELISA cartridge does not exist in the database:",existingCartridgeQ,False];

	(* Get the resolving result *)
	invalidInputs=DeleteDuplicates[Flatten[{duplicatedAnalytesInput, tooManyAnalytesInput,unsupportedAnalytesInput,wrongCartridgeTypeAnalytesInput,incompatibleAnalyteDiluentInput,incompatibleAnalyteMinDilutionFactorInput,incompatibleAnalytesInput}]];

	invalidOptions=DeleteDuplicates[Flatten[{wrongSpeciesAnalytesOption, wrongCartridgeTypeAnalytesOption}]];

	resolvedOptions={
		CartridgeType->resolvedCartridgeType,
		Species->resolvedSpecies
	};

	allTests=Flatten[{duplicatedAnalytesTests,tooManyAnalytesTests,unsupportedAnalytesTests,wrongSpeciesAnalytesTests,wrongCartridgeTypeAnalytesTests,incompatibleAnalyteDiluentTests,incompatibleAnalyteDilutionFactorTests,incompatibleAnalytesTests,emptyCartridgeChannelTests,existingCartridgeTest}];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTests,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Cache->simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTests,
		Message[Error::InvalidOption,invalidOptions]
	];

	resolvedOptionsResult=If[Length[invalidInputs]>0||Length[invalidOptions]>0,
		$Failed,
		resolvedOptions
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,allTests],
			Options->resolvedOptions,
			Preview->Null
		}]
	];

	(* Return early if we already have a cartridge *)
	If[existingCartridgeQ&&messages,
		Return[outputSpecification/.{
			Result->existingCartridge[[1]],
			Tests->Join[safeOptionTests,allTests],
			Options->resolvedOptions,
			Preview->Null
		}],
		Nothing
	];

	(* Prepare the packets for uploading *)

	(* Cartridge Name Convention - Species + Analyte Names + Cartridge Type *)
	newCartridgeName=StringJoin[
		Flatten[
			{
				ToString[resolvedSpecies],
				" ",
				{ToString[#]," "}&/@resolvedPreLoadedAnalyteNames,
				ToString[resolvedCartridgeType],
				" Cartridge"
			}
		]
	];

	(* Get the default value packets for different types of cartridges *)
	allSinglePlex72X1Positions=MapThread[
		<|
			Name->#1,
			Footprint->Null,
			MaxWidth->#2,
			MaxDepth->#3,
			MaxHeight->9Millimeter
		|>&,
		{
			{"A1","A2","A3","A4","A5","A6","A7","A8","A9","B1","B2","B3","B4","B5","B6","B7","B8","B9","C1","C2","C3","C4","C5","D1","D2","D3","D4","D5","D6","D7","D8","D9","E1","E2","E3","E4","E5","E6","E7","E8","E9","F1","F2","F3","F4","F5","F6","F7","F8","F9","G1","G2","G3","G4","G5","G6","G7","G8","G9","H1","H2","H3","H4","H5","I1","I2","I3","I4","I5","I6","I7","I8","I9","J1","J2","J3","J4","J5","J6","J7","J8","J9"},
			Join[ConstantArray[4.5Millimeter,18],ConstantArray[4.00Millimeter,5],ConstantArray[4.5Millimeter,36],ConstantArray[4.00Millimeter,5],ConstantArray[4.5Millimeter,18]],
			Join[ConstantArray[4.5Millimeter,18],ConstantArray[31.75Millimeter,5],ConstantArray[4.5Millimeter,36],ConstantArray[31.75Millimeter,5],ConstantArray[4.5Millimeter,18]]
		}
	];

	allMultiAnalyte16X4Positions=MapThread[
		<|
			Name->#1,
			Footprint->Null,
			MaxWidth->#2,
			MaxDepth->#3,
			MaxHeight->9Millimeter
		|>&,
		{
			{"A1","A2","B1","B2","B3","B4","C1","C2","D1","D2","E1","E2","F1","F2","G1","G2","H1","H2","I1","I2","I3","I4","J1","J2"},
			Join[ConstantArray[4.5Millimeter,2],ConstantArray[5.74Millimeter,4],ConstantArray[4.5Millimeter,12],ConstantArray[5.74Millimeter,4],ConstantArray[4.5Millimeter,2]],
			Join[ConstantArray[4.5Millimeter,2],ConstantArray[20.09Millimeter,4],ConstantArray[4.5Millimeter,12],ConstantArray[20.09Millimeter,4],ConstantArray[4.5Millimeter,2]]
		}
	];

	allMultiAnalyte32X4Positions=MapThread[
		<|
			Name->#1,
			Footprint->Null,
			MaxWidth->#2,
			MaxDepth->#3,
			MaxHeight->9Millimeter
		|>&,
		{
			{"A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","C5","C6","C7","C8","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4","H5","H6","H7","H8","I1","I2","I3","I4","J1","J2","J3","J4"},
			Join[ConstantArray[4.5Millimeter,8],ConstantArray[4.47Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[4.47Millimeter,8],ConstantArray[4.5Millimeter,8]],
			Join[ConstantArray[4.5Millimeter,8],ConstantArray[5.64Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[5.64Millimeter,8],ConstantArray[4.5Millimeter,8]]
		}
	];

	allMultiPlex32X8Positions=MapThread[
		<|
			Name->#1,
			Footprint->Null,
			MaxWidth->#2,
			MaxDepth->#3,
			MaxHeight->9Millimeter
		|>&,
		{
			{"A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","C5","C6","C7","C8","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4","H5","H6","H7","H8","I1","I2","I3","I4","J1","J2","J3","J4"},
			Join[ConstantArray[4.5Millimeter,8],ConstantArray[4.47Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[4.47Millimeter,8],ConstantArray[4.5Millimeter,8]],
			Join[ConstantArray[4.5Millimeter,8],ConstantArray[5.64Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[5.64Millimeter,8],ConstantArray[4.5Millimeter,8]]
		}
	];

	allSinglePlex72X1PositionPlottings=MapThread[
		Function[
			{name,xOffset,yOffset,shape},
			<|
				Name->name,
				XOffset->xOffset,
				YOffset->yOffset,
				ZOffset->0.0Millimeter,
				CrossSectionalShape->shape,
				Rotation->0.0
			|>
		],
		{
			{"A1","A2","A3","A4","A5","A6","A7","A8","A9","B1","B2","B3","B4","B5","B6","B7","B8","B9","C1","C2","C3","C4","C5","D1","D2","D3","D4","D5","D6","D7","D8","D9","E1","E2","E3","E4","E5","E6","E7","E8","E9","F1","F2","F3","F4","F5","F6","F7","F8","F9","G1","G2","G3","G4","G5","G6","G7","G8","G9","H1","H2","H3","H4","H5","I1","I2","I3","I4","I5","I6","I7","I8","I9","J1","J2","J3","J4","J5","J6","J7","J8","J9"},
			Flatten[
				Join[ConstantArray[Table[(i*11.5Millimeter+19.31Millimeter),{i,0,8}],2],{Table[(i*23Millimeter+13.56Millimeter),{i,0,4}]},ConstantArray[Table[(i*11.5Millimeter+19.31Millimeter),{i,0,8}],4],{Table[(i*23Millimeter+13.56Millimeter),{i,0,4}]},ConstantArray[Table[(i*11.5Millimeter+19.31Millimeter),{i,0,8}],2]]
			],
			Flatten[
				Join[ConstantArray[#,9]&/@Table[(-i*9Millimeter+74.2Millimeter),{i,0,1}],ConstantArray[60.33Millimeter,5],ConstantArray[#,9]&/@Table[(-i*9Millimeter+74.2Millimeter),{i,2,5}],ConstantArray[25.07Millimeter,5],ConstantArray[#,9]&/@Table[(-i*9Millimeter+74.2Millimeter),{i,6,7}]]
			],
			Join[ConstantArray[Circle,18],ConstantArray[Oval,5],ConstantArray[Circle,36],ConstantArray[Oval,5],ConstantArray[Circle,18]]
		}
	];

	allMultiAnalyte16X4PositionPlottings=MapThread[
		Function[
			{name,xOffset,yOffset,shape},
			<|
				Name->name,
				XOffset->xOffset,
				YOffset->yOffset,
				ZOffset->0.0Millimeter,
				CrossSectionalShape->shape,
				Rotation->0.0
			|>
		],
		{
			{"A1","A2","B1","B2","B3","B4","C1","C2","D1","D2","E1","E2","F1","F2","G1","G2","H1","H2","I1","I2","I3","I4","J1","J2"},
			Flatten[Join[{39.94Millimeter,96.44Millimeter},{26.09Millimeter,53.79Millimeter,82.59Millimeter,110.28Millimeter},ConstantArray[{39.94Millimeter,96.44Millimeter},6],{26.09Millimeter,53.79Millimeter,82.59Millimeter,110.28Millimeter},{39.94Millimeter,96.44Millimeter}]],
			Flatten[Join[ConstantArray[74.21Millimeter,2],ConstantArray[68.71Millimeter,4],ConstantArray[#,2]&/@{65.21Millimeter,56.21Millimeter,47.21Millimeter,38.21Millimeter,29.21Millimeter,20.21Millimeter},ConstantArray[16.71Millimeter,4],ConstantArray[11.21Millimeter,2]]],
			Join[ConstantArray[Circle,2],ConstantArray[Oval,4],ConstantArray[Circle,12],ConstantArray[Oval,4],ConstantArray[Circle,2]]
		}
	];

	allMultiAnalyte32X4PositionPlottings=MapThread[
		Function[
			{name,xOffset,yOffset,shape},
			<|
				Name->name,
				XOffset->xOffset,
				YOffset->yOffset,
				ZOffset->0.0Millimeter,
				CrossSectionalShape->shape,
				Rotation->0.0
			|>
		],
		{
			{"A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","C5","C6","C7","C8","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4","H5","H6","H7","H8","I1","I2","I3","I4","J1","J2","J3","J4"},
			Flatten[Join[ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],2],{17.21Millimeter,29.16Millimeter,44.85Millimeter,56.80Millimeter,72.49Millimeter,84.44Millimeter,100.13Millimeter,112.08Millimeter},ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],4],{17.21Millimeter,29.16Millimeter,44.85Millimeter,56.80Millimeter,72.49Millimeter,84.44Millimeter,100.13Millimeter,112.08Millimeter},ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],2]]],
			Flatten[Join[ConstantArray[#,4]&/@{74.20Millimeter,65.20Millimeter},ConstantArray[60.70Millimeter,8],ConstantArray[#,4]&/@{56.20Millimeter,47.20Millimeter,38.20Millimeter,29.20Millimeter},ConstantArray[24.70Millimeter,8],ConstantArray[#,4]&/@{20.20Millimeter,11.20Millimeter}]],
			Join[ConstantArray[Circle,8],ConstantArray[Triangle,8],ConstantArray[Circle,16],ConstantArray[Triangle,8],ConstantArray[Circle,8]]
		}
	];

	allMultiPlex32X8PositionPlottings=MapThread[
		Function[
			{name,xOffset,yOffset,shape},
			<|
				Name->name,
				XOffset->xOffset,
				YOffset->yOffset,
				ZOffset->0.0Millimeter,
				CrossSectionalShape->shape,
				Rotation->0.0
			|>
		],
		{
			{"A1","A2","A3","A4","B1","B2","B3","B4","C1","C2","C3","C4","C5","C6","C7","C8","D1","D2","D3","D4","E1","E2","E3","E4","F1","F2","F3","F4","G1","G2","G3","G4","H1","H2","H3","H4","H5","H6","H7","H8","I1","I2","I3","I4","J1","J2","J3","J4"},
			Flatten[Join[ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],2],{17.21Millimeter,29.16Millimeter,44.85Millimeter,56.80Millimeter,72.49Millimeter,84.44Millimeter,100.13Millimeter,112.08Millimeter},ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],4],{17.21Millimeter,29.16Millimeter,44.85Millimeter,56.80Millimeter,72.49Millimeter,84.44Millimeter,100.13Millimeter,112.08Millimeter},ConstantArray[Table[(i*27.64Millimeter+23.18Millimeter),{i,0,3}],2]]],
			Flatten@Join[ConstantArray[#,4]&/@{74.20Millimeter,65.20Millimeter},ConstantArray[60.70Millimeter,8],ConstantArray[#,4]&/@{56.20Millimeter,47.20Millimeter,38.20Millimeter,29.20Millimeter},ConstantArray[24.70Millimeter,8],ConstantArray[#,4]&/@{20.20Millimeter,11.20Millimeter}],
			Join[ConstantArray[Circle,8],ConstantArray[Triangle,8],ConstantArray[Circle,16],ConstantArray[Triangle,8],ConstantArray[Circle,8]]
		}
	];

	singlePlex72X1Values={
		CartridgeType->SinglePlex72X1,
		MaxNumberOfSamples->72,
		NumberOfReplicates->3,
		HorizontalMargin->17.06Millimeter,
		VerticalMargin->8.95Millimeter,
		MaxVolume->1Milliliter,
		MinBufferVolume->10.0Milliliter,
		MinVolumes->ConstantArray[0.001Microliter,82],
		MaxVolumes->Join[ConstantArray[90Microliter,18],ConstantArray[1Milliliter,5],ConstantArray[90Microliter,36],ConstantArray[1Milliliter,5],ConstantArray[90Microliter,18]],
		NumberOfWells->82,
		WellTreatments->ConstantArray[NonTreated,82],
		WellColors->ConstantArray[OpaqueBlack,82],
		WellBottoms->ConstantArray[FlatBottom,82],
		WellDiameters->Join[ConstantArray[4.5Millimeter,18],ConstantArray[4.00Millimeter,5],ConstantArray[4.5Millimeter,36],ConstantArray[4.00Millimeter,5],ConstantArray[4.5Millimeter,18]],
		WellDepths->ConstantArray[9Millimeter,82],
		WellContents->Join[ConstantArray[Sample,18],ConstantArray[Buffer,5],ConstantArray[Sample,36],ConstantArray[Buffer,5],ConstantArray[Sample,18]],
		WellPositionDimensions->Join[ConstantArray[{4.5Millimeter,4.5Millimeter},18],ConstantArray[{4.00Millimeter,31.75Millimeter},5],ConstantArray[{4.5Millimeter,4.5Millimeter},36],ConstantArray[{4.00Millimeter,31.75Millimeter},5],ConstantArray[{4.5Millimeter,4.5Millimeter},18]],
		RecommendedFillVolumes->Join[ConstantArray[50Microliter,18],ConstantArray[1Milliliter,5],ConstantArray[90Microliter,36],ConstantArray[1Milliliter,5],ConstantArray[90Microliter,18]],
		ConicalWellDepths->ConstantArray[9Millimeter,82],
		Positions->allSinglePlex72X1Positions,
		PositionPlotting->allSinglePlex72X1PositionPlottings,
		ImageFile->Object[EmeraldCloudFile, "id:AEqRl9K4p1V5"],
		ImageFileScale->200 Pixel/Centimeter,
		MaxCentrifugationForce -> 0 GravitationalAcceleration,
		LiquidHandlerPrefix->"EllaSinglePlex72X1"
	};

	multiAnalyte16X4Values={
		CartridgeType->MultiAnalyte16X4,
		MaxNumberOfSamples->16,
		NumberOfReplicates->3,
		HorizontalMargin->37.69Millimeter,
		VerticalMargin->8.96Millimeter,
		MaxVolume->1Milliliter,
		MinBufferVolume->8.0Milliliter,
		MinVolumes->ConstantArray[0.001Microliter,24],
		MaxVolumes->Join[ConstantArray[90Microliter,2],ConstantArray[1Milliliter,4],ConstantArray[90Microliter,12],ConstantArray[1Milliliter,4],ConstantArray[90Microliter,2]],
		NumberOfWells->24,
		WellTreatments->ConstantArray[NonTreated,24],
		WellColors->ConstantArray[OpaqueBlack,24],
		WellBottoms->ConstantArray[FlatBottom,24],
		WellDiameters->Join[ConstantArray[4.5Millimeter,2],ConstantArray[5.74Millimeter,4],ConstantArray[4.5Millimeter,12],ConstantArray[5.74Millimeter,4],ConstantArray[4.5Millimeter,2]],
		WellDepths->ConstantArray[9Millimeter,24],
		WellContents->Join[ConstantArray[Sample,2],ConstantArray[Buffer,4],ConstantArray[Sample,12],ConstantArray[Buffer,4],ConstantArray[Sample,2]],
		WellPositionDimensions->Join[ConstantArray[{4.5Millimeter,4.5Millimeter},2],ConstantArray[{5.74Millimeter,20.09Millimeter},4],ConstantArray[{4.5Millimeter,4.5Millimeter},12],ConstantArray[{5.74Millimeter,20.09Millimeter},4],ConstantArray[{4.5Millimeter,4.5Millimeter},2]],
		RecommendedFillVolumes->Join[ConstantArray[50Microliter,2],ConstantArray[1Milliliter,4],ConstantArray[50Microliter,12],ConstantArray[1Milliliter,4],ConstantArray[50Microliter,2]],
		ConicalWellDepths->ConstantArray[9Millimeter,24],
		Positions->allMultiAnalyte16X4Positions,
		PositionPlotting->allMultiAnalyte16X4PositionPlottings,
		ImageFile->Object[EmeraldCloudFile,"id:xRO9n3B0o565"],
		ImageFileScale->200 Pixel/Centimeter,
		MaxCentrifugationForce -> 0 GravitationalAcceleration,
		LiquidHandlerPrefix->"EllaMultiAnalyte16X4"
	};

	multiAnalyte32X4Values={
		CartridgeType->MultiAnalyte32X4,
		MaxNumberOfSamples->32,
		NumberOfReplicates->3,
		HorizontalMargin->20.93Millimeter,
		VerticalMargin->8.96Millimeter,
		MaxVolume->1Milliliter,
		MinBufferVolume->16.0Milliliter,
		MinVolumes->ConstantArray[0.001Microliter,48],
		MaxVolumes->Join[ConstantArray[90Microliter,8],ConstantArray[1Milliliter,8],ConstantArray[90Microliter,16],ConstantArray[1Milliliter,8],ConstantArray[90Microliter,8]],
		NumberOfWells->48,
		WellTreatments->ConstantArray[NonTreated,48],
		WellColors->ConstantArray[OpaqueBlack,48],
		WellBottoms->ConstantArray[FlatBottom,48],
		WellDiameters->Join[ConstantArray[4.5Millimeter,8],ConstantArray[3.30Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[3.30Millimeter,8],ConstantArray[4.5Millimeter,8]],
		WellDepths->ConstantArray[9Millimeter,48],
		WellContents->Join[ConstantArray[Sample,8],ConstantArray[Buffer,8],ConstantArray[Sample,16],ConstantArray[Buffer,8],ConstantArray[Sample,8]],
		WellPositionDimensions->Join[ConstantArray[{4.5Millimeter,4.5Millimeter},8],ConstantArray[{4.47Millimeter,5.64Millimeter},8],ConstantArray[{4.5Millimeter,4.5Millimeter},16],ConstantArray[{4.47Millimeter,5.64Millimeter},8],ConstantArray[{4.5Millimeter,4.5Millimeter},8]],
		RecommendedFillVolumes->Join[ConstantArray[50Microliter,8],ConstantArray[1Milliliter,8],ConstantArray[50Microliter,16],ConstantArray[1Milliliter,8],ConstantArray[50Microliter,8]],
		ConicalWellDepths->ConstantArray[9Millimeter,48],
		Positions->allMultiAnalyte32X4Positions,
		PositionPlotting->allMultiAnalyte32X4PositionPlottings,
		ImageFile->Object[EmeraldCloudFile,"id:aXRlGn6vN1Em"],
		ImageFileScale->200 Pixel/Centimeter,
		MaxCentrifugationForce -> 0 GravitationalAcceleration,
		LiquidHandlerPrefix->"EllaMultiAnalyte32X4"
	};

	multiPlex32X8Values={
		CartridgeType->MultiPlex32X8,
		MaxNumberOfSamples->32,
		NumberOfReplicates->2,
		HorizontalMargin->20.93Millimeter,
		VerticalMargin->8.96Millimeter,
		MaxVolume->1Milliliter,
		MinBufferVolume->16.0Milliliter,
		MinVolumes->ConstantArray[0.001Microliter,48],
		MaxVolumes->Join[ConstantArray[90Microliter,8],ConstantArray[1Milliliter,8],ConstantArray[90Microliter,16],ConstantArray[1Milliliter,8],ConstantArray[90Microliter,8]],
		NumberOfWells->48,
		WellTreatments->ConstantArray[NonTreated,48],
		WellColors->ConstantArray[OpaqueBlack,48],
		WellBottoms->ConstantArray[FlatBottom,48],
		WellDiameters->Join[ConstantArray[4.5Millimeter,8],ConstantArray[3.30Millimeter,8],ConstantArray[4.5Millimeter,16],ConstantArray[3.30Millimeter,8],ConstantArray[4.5Millimeter,8]],
		WellDepths->ConstantArray[9Millimeter,48],
		WellContents->Join[ConstantArray[Sample,8],ConstantArray[Buffer,8],ConstantArray[Sample,16],ConstantArray[Buffer,8],ConstantArray[Sample,8]],
		WellPositionDimensions->Join[ConstantArray[{4.5Millimeter,4.5Millimeter},8],ConstantArray[{4.47Millimeter,5.64Millimeter},8],ConstantArray[{4.5Millimeter,4.5Millimeter},16],ConstantArray[{4.47Millimeter,5.64Millimeter},8],ConstantArray[{4.5Millimeter,4.5Millimeter},8]],
		RecommendedFillVolumes->Join[ConstantArray[50Microliter,8],ConstantArray[1Milliliter,8],ConstantArray[50Microliter,16],ConstantArray[1Milliliter,8],ConstantArray[50Microliter,8]],
		ConicalWellDepths->ConstantArray[9Millimeter,48],
		Positions->allMultiPlex32X8Positions,
		PositionPlotting->allMultiPlex32X8PositionPlottings,
		ImageFile->Object[EmeraldCloudFile,"id:01G6nvwAJENE"],
		ImageFileScale->200 Pixel/Centimeter,
		MaxCentrifugationForce -> 0 GravitationalAcceleration,
		LiquidHandlerPrefix->"EllaMultiPlex32X8"
	};

	(* Pick the cartridge default values based on the CartridgeType *)
	newCartridgeValues=Which[
		MatchQ[resolvedCartridgeType,SinglePlex72X1],singlePlex72X1Values,
		MatchQ[resolvedCartridgeType,MultiAnalyte16X4],multiAnalyte16X4Values,
		MatchQ[resolvedCartridgeType,MultiAnalyte32X4],multiAnalyte32X4Values,
		MatchQ[resolvedCartridgeType,MultiPlex32X8],multiPlex32X8Values
	];

	(* Prepare the cartridge model upload packet *)
	newCapillaryELISACartridgeModelPacket=<|
		Type->Model[Container,Plate,Irregular,CapillaryELISA],
		Name->newCartridgeName,
		Replace[Synonyms]->{newCartridgeName},
		Replace[Authors]->{Link[author]},
		If[TrueQ[$UploadCapillaryELISACartridgeAsDeveloperObject],
			DeveloperObject -> True,
			Nothing
		],
		Replace[AnalyteNames]->resolvedPreLoadedAnalyteNames,
		Replace[AnalyteMolecules]->(Link[Download[#,Object]]&/@resolvedPreLoadedAnalyteMolecules),

		(* Hard Code some basic information about all the cartridges *)
		Expires->True,
		ShelfLife->12 Month,
		DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
		Reusable->False,
		CrossSectionalShape->Rectangle,
		Footprint->Plate,
		MinTemperature->-20 Celsius,
		MaxTemperature->40 Celsius,
		DepthMargin->0Millimeter,
		Dimensions->{0.12762Meter,0.08540Meter,0.0932Meter},
		MinVolume->0.001Microliter,
		Opaque->True,
		PlateColor->OpaqueBlack,
		Sterile->False, 
		WellColor->OpaqueBlack,
		WellBottom->FlatBottom,
		WellDepth->9Millimeter,
		SelfStanding->True,
		Replace[CoverTypes]->{Seal, Place},

		(* Values from the certain type of cartridge *)
		CartridgeType->Lookup[newCartridgeValues,CartridgeType],
		MaxNumberOfSamples->Lookup[newCartridgeValues,MaxNumberOfSamples],
		NumberOfReplicates->Lookup[newCartridgeValues,NumberOfReplicates],
		HorizontalMargin->Lookup[newCartridgeValues,HorizontalMargin],
		VerticalMargin->Lookup[newCartridgeValues,VerticalMargin],
		MaxVolume->Lookup[newCartridgeValues,MaxVolume],
		MinBufferVolume->Lookup[newCartridgeValues,MinBufferVolume],
		Replace[MinVolumes]->Lookup[newCartridgeValues,MinVolumes],
		Replace[MaxVolumes]->Lookup[newCartridgeValues,MaxVolumes],
		NumberOfWells->Lookup[newCartridgeValues,NumberOfWells],
		Replace[WellTreatments]->Lookup[newCartridgeValues,WellTreatments],
		Replace[WellColors]->Lookup[newCartridgeValues,WellColors],
		Replace[WellBottoms]->Lookup[newCartridgeValues,WellBottoms],
		Replace[WellDiameters]->Lookup[newCartridgeValues,WellDiameters],
		Replace[WellDepths]->Lookup[newCartridgeValues,WellDepths],
		Replace[WellContents]->Lookup[newCartridgeValues,WellContents],
		Replace[WellPositionDimensions]->Lookup[newCartridgeValues,WellPositionDimensions],
		Replace[RecommendedFillVolumes]->Lookup[newCartridgeValues,RecommendedFillVolumes],
		Replace[ConicalWellDepths]->Lookup[newCartridgeValues,ConicalWellDepths],
		Replace[Positions]->Lookup[newCartridgeValues,Positions],
		Replace[PositionPlotting]->Lookup[newCartridgeValues,PositionPlotting],
		ImageFile->Link[Lookup[newCartridgeValues,ImageFile]],
		LiquidHandlerPrefix->Lookup[newCartridgeValues,LiquidHandlerPrefix]

	|>;

	(* Pick the CatalogDescription for the new product. *)
	newCartridgeProductSampleNumber=Which[
		MatchQ[resolvedCartridgeType,SinglePlex72X1],72,
		MatchQ[resolvedCartridgeType,MultiAnalyte16X4],16,
		MatchQ[resolvedCartridgeType,MultiAnalyte32X4],32,
		MatchQ[resolvedCartridgeType,MultiPlex32X8],32
	];

	newCartridgeProductDescription=StringJoin["Simple Plex Cartridge Kit for ",ToString[newCartridgeProductSampleNumber]," samples, containing ",ToString[resolvedPreLoadedAnalyteNames]," for use with ",ToString[resolvedSpecies]," samples. Includes wash buffer and ",ObjectToString[bestDiluent]];

	(* Define the cartridge product price *)
	newCartridgeProductPrice=Which[
		MatchQ[resolvedCartridgeType,SinglePlex72X1],750USD,
		MatchQ[resolvedCartridgeType,MultiAnalyte16X4],1000USD,
		MatchQ[resolvedCartridgeType,MultiAnalyte32X4],1250USD,
		MatchQ[resolvedCartridgeType,MultiPlex32X8],1500USD
	];

	(* Get the estimated leading time *)
	newCartridgeProductEstimatedLeadTime=If[!MatchQ[Lookup[newCartridgeValues,CartridgeType],SinglePlex72X1],
		14Day,
		FirstOrDefault[
			Download[
				FirstOrDefault[resolvedPreLoadedAnalyteManuSpecObjects],
				EstimatedLeadTime,
				Cache->cacheBall,
				Date->Now
			],
			14Day
		]
	];

	(* Prepare the product upload packet *)
	newCapillaryELISACartridgeProductPacket=<|
		Type->Object[Product,CapillaryELISACartridge],
		Name->StringJoin["CapillaryELISA ",newCartridgeName," Kit"],
		If[TrueQ[$UploadCapillaryELISACartridgeAsDeveloperObject],
			DeveloperObject -> True,
			Nothing
		],
		Replace[Synonyms]->{StringJoin["CapillaryELISA ",newCartridgeName," Kit"]},
		Author->Link[author],
		Supplier->Link[Object[Company,Supplier,"Protein Simple"],Products],
		CatalogNumber->"CapillaryELISACatalogNumber(Temp)",
		CatalogDescription->newCartridgeProductDescription,
		ProductURL->"https://www.proteinsimple.com/ella-single-plex-assays.html",
		Packaging->Single,
		SampleType->Kit,
		CartridgeType->Lookup[newCartridgeValues,CartridgeType],
		Replace[AnalyteNames]->resolvedPreLoadedAnalyteNames,
		Replace[AnalyteMolecules]->(Link[Download[#,Object]]&/@resolvedPreLoadedAnalyteMolecules),
		Replace[ManufacturingSpecifications]->(Link[Download[#,Object],Products]&/@resolvedPreLoadedAnalyteManuSpecObjects),
		Price->newCartridgeProductPrice,
		EstimatedLeadTime->newCartridgeProductEstimatedLeadTime,
		UsageFrequency->Low,

		(* Get the kit components *)
		Replace[KitComponents]->{
			<|
				NumberOfItems->1,
				ProductModel->Link[Model[Container,Plate,Irregular,CapillaryELISA,newCartridgeName],KitProducts],
				DefaultContainerModel->Null,
				Amount->Null,Position->Null,
				ContainerIndex->Null,
				DefaultCoverModel -> Null,
				OpenContainer -> Null
			|>,
			<|
				NumberOfItems->1,
				ProductModel->Link[Download[bestDiluent,Object],KitProducts],
				DefaultContainerModel->Link[Model[Container,Vessel,"id:8qZ1VW0eaZaA"]],
				Amount->Quantity[9,"Milliliters"],
				Position->"A1",
				ContainerIndex->1,
				DefaultCoverModel -> Null,
				OpenContainer -> Null
			|>,
			<|
				NumberOfItems->1,
				ProductModel->
				Link[Model[Sample,"id:4pO6dM50p9kw"],KitProducts],
				DefaultContainerModel->Link[Model[Container,Vessel,"id:8qZ1VW0eaZaA"]],
				Amount->Quantity[12,"Milliliters"],
				Position->"A1",
				ContainerIndex->2,
				DefaultCoverModel -> Null,
				OpenContainer -> Null
			|>
		}
	|>;

	(* run the tests that we have generated to make sure we can go on *)
	allTestTestResults=If[gatherTests,
		RunUnitTest[<|"Tests" ->allTests|>,OutputFormat->SingleBoolean,Verbose->False],
		MatchQ[resolvedOptionsResult,Except[$Failed]]
	];

	optionsRule=(Options->resolvedOptions);

	(* function doesn't have a preview *)
	previewRule=(Preview->Null);

	(* accrue all of the Tests we generated *)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];

	(* prepare the Result rule if asked; do not bother if we hit a failure on any of our above checks *)
	resultRule=Result->If[MemberQ[listedOutput,Result],
		Which[
			Not[TrueQ[allTestTestResults]], $Failed,
			Not[upload], Flatten[{newCapillaryELISACartridgeModelPacket, newCapillaryELISACartridgeProductPacket}],
			True,
				Module[
					{newUploadedCartridgeModel,newUploadedCartridgeProduct},
					(* Upload the Cartridge Model first *)
					newUploadedCartridgeModel=Upload[newCapillaryELISACartridgeModelPacket];
					(* Upload the Cartridge Product then *)
					newUploadedCartridgeProduct=Upload[newCapillaryELISACartridgeProductPacket];
					(* Return the new cartridge model. We want to return the same format with existing cartridge so no need to return the cartridge product *)
					newUploadedCartridgeModel
				]
		],
		Null
	];

	(* return the requested outputs per the non-listed Output option *)
	outputSpecification /. {optionsRule, previewRule, testsRule, resultRule}

];



(* ::Subsubsection::Closed:: *)
(*UploadCapillaryELISACartridgeOptions*)


DefineOptions[UploadCapillaryELISACartridgeOptions,
	Options:>{
		{
			OptionName->OutputFormat,
			Default->Table,
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>(Table|List)],
			Description->"Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{UploadCapillaryELISACartridge}
];


UploadCapillaryELISACartridgeOptions[myAnalytes:ListableP[ObjectP[Model[Molecule]]]|ListableP[CapillaryELISAAnalyteP],myOptions:OptionsPattern[UploadCapillaryELISACartridgeOptions]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=UploadCapillaryELISACartridge[myAnalytes,preparedOptions];

	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];

	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,UploadCapillaryELISACartridge],
		resolvedOptions
	]
];



(* ::Subsection::Closed:: *)
(*ValidUploadCapillaryELISACartridgeQ*)


DefineOptions[ValidUploadCapillaryELISACartridgeQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{UploadCapillaryELISACartridge}
];

ValidUploadCapillaryELISACartridgeQ[myAnalytes:ListableP[ObjectP[Model[Molecule]]]|ListableP[CapillaryELISAAnalyteP],myOptions:OptionsPattern[ValidUploadCapillaryELISACartridgeQ]]:=Module[
	{listedOptions,preparedOptions,uploadCartridgeTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for UploadCapillaryELISACartridge *)
	uploadCartridgeTests=UploadCapillaryELISACartridge[myAnalytes,Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[uploadCartridgeTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings,testResults},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myAnalytes],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myAnalytes],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,uploadCartridgeTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadCapillaryELISACartridgeQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidUploadCapillaryELISACartridgeQ"]

];



(* ::Subsection:: *)
(*ExperimentCapillaryELISAPreview*)

DefineOptions[UploadCapillaryELISACartridgePreview,
	SharedOptions:>{UploadCapillaryELISACartridge}
];

UploadCapillaryELISACartridgePreview[myAnalytes:ListableP[ObjectP[Model[Molecule]]]|ListableP[CapillaryELISAAnalyteP],myOptions:OptionsPattern[UploadCapillaryELISACartridgePreview]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	UploadCapillaryELISACartridge[myAnalytes,ReplaceRule[listedOptions,Output->Preview]]
];
