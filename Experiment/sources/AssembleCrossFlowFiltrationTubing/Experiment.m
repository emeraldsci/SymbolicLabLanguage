(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubing*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAssembleCrossFlowFiltrationTubing Options*)


DefineOptions[ExperimentAssembleCrossFlowFiltrationTubing,
	Options:>{
		(* --- Hidden Options --- *)
		{
			OptionName -> PreparedResources,
			Default -> {},
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ListableP[ObjectP[Object[Resource,Sample]]],ObjectTypes->{Object[Resource,Sample]}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[{}]
				]
			],
			Description -> "Resources in the ParentProtocol that will be satisfied by preparation of the requested reference electrode models.",
			Category -> "Hidden"
		},
		SubprotocolDescriptionOption,
		PriorityOption,
		StartDateOption,
		HoldOrderOption,
		QueuePositionOption,
		UploadOption,
		CacheOption,
		ProtocolOptions
	}
];

(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubing*)

Error::modelCountLengthMismatch="The specified tubing models and the required number for each do not match. Please make sure there each model input has a corresponding number to assemble.";
Error::deprecatedTubingModel="The specified tubing model(s) (`1`) is deprecated. Please make sure to only specify valid models.";


(* No count overload *)
ExperimentAssembleCrossFlowFiltrationTubing[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubing[ToList[tubingModels],ConstantArray[1,Length[ToList[tubingModels]]],myOptions];

(* Single count overload *)
ExperimentAssembleCrossFlowFiltrationTubing[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},count:_Integer,myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubing[ToList[tubingModels],ConstantArray[count,Length[ToList[tubingModels]]],myOptions];

(* Core overload *)
ExperimentAssembleCrossFlowFiltrationTubing[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},counts:{_Integer..},myOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,upload,cache,fastTrack,parentProtocol,confirm,canaryBranch,notebook,author,listedTubingModels,listedCounts,fittingModels,allDownloads,tubingModelPackets,parentTubingModelPackets,fittingModelPackets,notebookPacket,authorPacket,databaseMemberQ,deprecatedQ,parentTubingDiameters,connectors,fittings,fittingResources,uniqueParentTubings,tubingResources,expandedParentTubingModelPackets,finalTubingResources,expandedPrecutTubingPackets,stickerTagResource,protocolID,checkpointEstimates,protocolPacket,newCache,uploadResult,
		outputSpecification, output,gatherTests,unresolvedOptions, applyTemplateOptionTests,messages,sameInputLengthsQ, sameInputLengthTests,
		safeOptions,safeOptionTests,validLengths,validLengthTests,objectsExistTests,expandedSafeOptions,objectsFromOptions,userSpecifiedObjects,objectsExistQs,cacheBall,
		preparedResourcesPackets, resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,
		protocolObject,deprecatedModelsQs, objectsDeprecatedTests
	},

	(* determine the requested return value; careful not to default this as it will throw error; it's Hidden, assume used correctly *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages = !gatherTests;

	(* Get the notebook and Author; this is hard coded as service+lab-infrastructure object *)
	notebook=$Notebook;
	author=Object[User,Emerald,Developer,"service+lab-infrastructure"];

	(* Make sure our inputs are listed *)
	{listedTubingModels,listedCounts, listedOptions}={ToList[tubingModels],ToList[counts], ToList[myOptions]};

	(* Check if the listedSourceReferenceElectrodes and listedTargetReferenceElectrodeModels are of the same length *)
	sameInputLengthsQ = MatchQ[Length[listedTubingModels], Length[listedCounts]];

	(* Build the tests for same length inputs *)
	sameInputLengthTests = If[gatherTests,
		(* If we are gathering tests *)
		{Test["The specified tubing models and counts have the same length.",
			sameInputLengthsQ,
			True
		]},

		(* If we are not gathering tests, set this to {} *)
		{}
	];

	(* If input lists are not of the same length, return failure *)
	If[MatchQ[sameInputLengthsQ, False],
		If[messages,
			Message[Error::modelCountLengthMismatch];
			Message[Error::InvalidInput, ToString[listedTubingModels]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> sameInputLengthTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(***  MANY of the following checks are not really required here, since we don't have any fancy options just yet. but in case we do in the future, we should be safe to work with them  ***)
	(* set a local variable with the user-provided options in list form; make sure to gather tests from here *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentAssembleCrossFlowFiltrationTubing, {listedTubingModels}, listedOptions, 3, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentAssembleCrossFlowFiltrationTubing, {listedTubingModels}, listedOptions, 3], {}}
	];

	(* If some hard error was encountered in getting template, return early with the requested output  *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[
			outputSpecification /. {
				Result -> $Failed,
				Tests -> Join[sameInputLengthTests, applyTemplateOptionTests],
				Preview -> Null,
				Options -> $Failed
			}
		]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ExperimentAssembleCrossFlowFiltrationTubing,unresolvedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentAssembleCrossFlowFiltrationTubing,unresolvedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[ExperimentAssembleCrossFlowFiltrationTubing, {listedTubingModels}, safeOptions, 3,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentAssembleCrossFlowFiltrationTubing, {listedTubingModels}, safeOptions, 3],{}}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Get the options *)
	{upload,cache,fastTrack,parentProtocol,confirm,canaryBranch}=Lookup[safeOptions,{Upload,Cache,FastTrack,ParentProtocol,Confirm,CanaryBranch}];


	(* Expand index-matching options *)
	expandedSafeOptions=Last[ExpandIndexMatchedInputs[ExperimentAssembleCrossFlowFiltrationTubing, {listedTubingModels}, safeOptions, 3]];

	(* Get objects provided in options *)
	objectsFromOptions = Cases[Values[safeOptions], ObjectP[]];

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten[{listedTubingModels, objectsFromOptions}],
		ObjectP[]
	];

	(* Check if the userSpecifiedObjects exist *)
	objectsExistQs = DatabaseMemberQ[userSpecifiedObjects];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1],#2,True]&,
			{userSpecifiedObjects, objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And@@objectsExistQs),
		If[!gatherTests,
			Message[Error::ObjectDoesNotExist,PickList[userSpecifiedObjects ,objectsExistQs, False]];
			Message[Error::InvalidInput,PickList[userSpecifiedObjects, objectsExistQs, False]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests, validLengthTests, objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(** Okay, lets move on. **)
	(* Find all fitting models *)
	fittingModels=Search[Model[Plumbing,Fitting],Name==(___~~"Cross Flow"~~___)];

	(* Download all the objects *)
	allDownloads=Quiet[
		Download[
			{
				listedTubingModels,
				listedTubingModels,
				fittingModels,
				{notebook},
				{author}
			},
			{
				{Packet[Connectors,Gauge,ParentTubing,Size,Deprecated, Name]},
				{Packet[ParentTubing[{Connectors,Name}]]},
				{Packet[Connectors, Name]},
				{Packet[Financers[Members][{FirstName,LastName,Email,TeamEmailPreference,NotebookEmailPreferences}]],Packet[Editors[Members][{FirstName,LastName,Email,TeamEmailPreference,NotebookEmailPreferences}]]},
				{Packet[FirstName,LastName,Email,TeamEmailPreference,NotebookEmailPreferences,Site]}
			},
			Cache->cache,
			Date->Now
		],
		{Download::ObjectDoesNotExist}
	];

	(* Separate the packets *)
	{
		tubingModelPackets,
		parentTubingModelPackets,
		fittingModelPackets,
		notebookPacket,
		authorPacket
	}={
		Flatten[allDownloads[[1]]],
		Flatten[allDownloads[[2]]],
		Flatten[allDownloads[[3]]],
		Flatten[allDownloads[[4]]],
		Flatten[allDownloads[[5]]]
	};

	cacheBall = FlattenCachePackets[allDownloads];

	(* Retrieve the preparedResourcesPackets. This is used for the resource packets *)
	preparedResourcesPackets = Cases[cacheBall, PacketP[Object[Resource, Sample]]];

	(* Check if the any model is deprecated *)
	deprecatedModelsQs = TrueQ[Lookup[fetchPacketFromCache[#,tubingModelPackets], Deprecated]]&/@listedTubingModels;

	(* Build tests for object existence *)
	objectsDeprecatedTests = If[gatherTests,
		MapThread[
			Test[StringTemplate["Specified tubing model `1` is not deprecated:"][#1],#2,False]&,
			{listedTubingModels, deprecatedModelsQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[Or@@deprecatedModelsQs&&!fastTrack,
		If[!gatherTests,
			Message[Error::deprecatedTubingModel,PickList[listedTubingModels ,deprecatedModelsQs, True]];
			Message[Error::InvalidInput,PickList[listedTubingModels, deprecatedModelsQs, True]]
		];

		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[sameInputLengthTests, applyTemplateOptionTests, safeOptionTests, validLengthTests, objectsExistTests,objectsDeprecatedTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* -------------------------- *)
	(* --- RESOLVE THE OPTIONS (but we don't have options, so gonna skip this altogether for now---*)
	(* -------------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTests,

		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentAssembleCrossFlowFiltrationTubingOptions[listedTubingModels,listedCounts, expandedSafeOptions, Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentAssembleCrossFlowFiltrationTubingOptions[listedTubingModels,listedCounts, expandedSafeOptions, Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentAssembleCrossFlowFiltrationTubing,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[
				sameInputLengthTests,
				applyTemplateOptionTests,
				safeOptionTests,
				validLengthTests,
				objectsExistTests,
				objectsDeprecatedTests,
				resolvedOptionsTests
			],
			Options->RemoveHiddenOptions[ExperimentAssembleCrossFlowFiltrationTubing,collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(* ----- Generate Resources ----- *)

	{resourcePackets,resourcePacketTests} = If[gatherTests,
		assembleCrossFlowFiltrationTubingResourcePackets[
			listedTubingModels,
			listedCounts,
			preparedResourcesPackets,
			expandedSafeOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall,
			Output -> {Result,Tests}
		],
		{assembleCrossFlowFiltrationTubingResourcePackets[
			listedTubingModels,
			listedCounts,
			preparedResourcesPackets,
			expandedSafeOptions,
			resolvedOptions,
			collapsedResolvedOptions,
			Cache -> cacheBall
		], {}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests->Flatten[{
				sameInputLengthTests,
				applyTemplateOptionTests,
				safeOptionTests,
				validLengthTests,
				objectsExistTests,
				objectsDeprecatedTests,
				resolvedOptionsTests,
				resourcePacketTests
			}],
			Options -> RemoveHiddenOptions[ExperimentAssembleCrossFlowFiltrationTubing,collapsedResolvedOptions],
			Preview -> Null
		}]
	];


	(* Update the cache *)
	newCache=Experiment`Private`FlattenCachePackets[{cache,tubingModelPackets,parentTubingModelPackets,fittingModelPackets,authorPacket,notebookPacket}];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		UploadProtocol[
			resourcePackets,
			Upload->Lookup[safeOptions,Upload],
			Confirm->Lookup[safeOptions,Confirm],
			CanaryBranch->Lookup[safeOptions,CanaryBranch],
			ParentProtocol->Lookup[safeOptions,ParentProtocol],
			Priority->Lookup[safeOptions,Priority],
			StartDate->Lookup[safeOptions,StartDate],
			HoldOrder->Lookup[safeOptions,HoldOrder],
			QueuePosition->Lookup[safeOptions,QueuePosition],
			ConstellationMessage->Object[Protocol,AssembleCrossFlowFiltrationTubing],
			Cache -> cacheBall
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{
			sameInputLengthTests,
			applyTemplateOptionTests,
			safeOptionTests,
			validLengthTests,
			objectsExistTests,
			objectsDeprecatedTests,
			resolvedOptionsTests,
			resourcePacketTests
		}],
		Options -> RemoveHiddenOptions[ExperimentAssembleCrossFlowFiltrationTubing,collapsedResolvedOptions],
		Preview -> Null
	}
];


(* ::Subsection::Closed:: *)
(* resolveExperimentAssembleCrossFlowFiltrationTubingOptions *)

DefineOptions[
	resolveExperimentAssembleCrossFlowFiltrationTubingOptions,
	Options:>{HelperOutputOption,CacheOption}
];

(* we do not have any options at the moment, but we have a resolver now! its not returning anything for the moment *)
resolveExperimentAssembleCrossFlowFiltrationTubingOptions[
	tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},counts:{_Integer..},
	myOptions:{_Rule...},
	myResolutionOptions:OptionsPattern[resolveExperimentAssembleCrossFlowFiltrationTubingOptions]
]:=Module[{
		outputSpecification,output,inheritedCache,optionsAssociation,resolvedOptions
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];

	optionsAssociation = Association[myOptions];

	resolvedOptions =Flatten[Normal[optionsAssociation]]/.x:ObjectP[]:>Download[x,Object];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result ->resolvedOptions,
		Tests ->{}
	}

];



(* ::Subsection::Closed:: *)
(* assembleCrossFlowFiltrationTubingResourcePackets *)

(* ====================== *)
(* == RESOURCE PACKETS == *)
(* ====================== *)

DefineOptions[assembleCrossFlowFiltrationTubingResourcePackets,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

assembleCrossFlowFiltrationTubingResourcePackets[
	tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},
	counts:{_Integer..},
	myPreparedResourcePackets:{PacketP[Object[Resource,Sample]]...},
	myUnresolvedOptions:{___Rule},
	myResolvedOptions:{___Rule},
	myCollapsedResolvedOptions:{___Rule},
	myOptions:OptionsPattern[]
]:=Module[
	{
		outputSpecification,output,gatherTests,messages,inheritedCache,optionsAssociation,
		tubingModelPackets,parentTubingModelPackets,fittingModelPackets,parentTubingDiameters,connectors,fittings,fittingResources,
		uniqueParentTubings,tubingResources,expandedParentTubingModelPackets,finalTubingResources,expandedPrecutTubingPackets,
		stickerTagResource,protocolID,checkpointEstimates,protocolPacket, allResourceBlobs,fulfillable,frqTests,testsRule,resultRule,cache
	},

	(* Determine the requested output format of this function. *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output,Tests];
	messages = !gatherTests;

	(* Fetch our cache from the parent function. *)
	inheritedCache = Lookup[ToList[myResolvedOptions], Cache, {}];

	(* Fetch our cache from the parent function. *)
	cache = Cases[Lookup[ToList[myOptions],Cache], PacketP[]];

	optionsAssociation = Association[myOptions];

	(* organize packets for tubing *)
	tubingModelPackets = fetchPacketFromCache[#,cache] & /@tubingModels;
	parentTubingModelPackets = fetchPacketFromCache[#,cache] & /@ Lookup[tubingModelPackets, ParentTubing];
	fittingModelPackets = fetchPacketFromCache[#,cache] & /@ Search[Model[Plumbing, Fitting],Name == (___ ~~ "Cross Flow" ~~ ___)];


		(* Find the diameter of the parent tubing -- we are looking this up from the connector so that we can find the right barbed connector for it *)
	parentTubingDiameters=Lookup[parentTubingModelPackets,Connectors][[All,1,4]];

	(* Get the connectors we need on our precut tubes *)
	connectors=Lookup[tubingModelPackets,Connectors];

	(* Find the fittings we need - it looks like 1/32" tubes use 1/16" fittings, let them do that*)
	fittings=MapThread[
		Function[
			{parentTubingDiameter,precutTubingConnectors},
			Module[{connectorPatterns,firstFitting,secondFitting},

				(* Create a connector pattern without the name and thread type *)
				connectorPatterns={_,#[[2]],None|Null,#[[4]],#[[5]],#[[6]]}&/@precutTubingConnectors;

				(* Find the first fitting we need *)
				firstFitting=SelectFirst[
					fittingModelPackets,
					And[
						MemberQ[Lookup[#,Connectors],{_,Barbed,_,parentTubingDiameter,parentTubingDiameter,_}],
						MemberQ[Lookup[#,Connectors],connectorPatterns[[1]]]
					]&
				];

				(* Find the second fitting we need *)
				secondFitting=SelectFirst[
					fittingModelPackets,
					And[
						MemberQ[Lookup[#,Connectors],{_,Barbed,_,parentTubingDiameter,parentTubingDiameter,_}],
						MemberQ[Lookup[#,Connectors],connectorPatterns[[2]]]
					]&
				];

				(* Return the fittings *)
				Lookup[{firstFitting,secondFitting},Object]
			]
		],
		(* replace diameters of 1/32 with 1/16 to find those fittings; at least until we find 1/32s *)
		{parentTubingDiameters/. Quantity[0.03125, "Inches"]->Quantity[0.0625, "Inches"],connectors}
	];

	(* Generate the fitting resources *)
	fittingResources=Flatten[MapThread[
		Function[
			{fittingList,count},
			Table[Link[Resource[Sample->#,Name->ToString[Unique[]]]],count]&/@fittingList
		],
		{fittings,ToList[counts]}
	]];

	(* Find unique parent tubes *)
	uniqueParentTubings=DeleteDuplicates[Lookup[parentTubingModelPackets,Object]];

	(* Generate resources for each unique tubing -- we currently cannot keep track of length of tubing in the procedure framework. The lengths of the tubing are updated in the protocol manually but we have no way of putting that into a resource and force the resource of a certain length to be picked *)
	tubingResources=Link[Resource[Sample->#1,Name->ToString[Unique[]]]]&/@uniqueParentTubings;

	(* Expand the tubing packets with their count *)
	expandedParentTubingModelPackets=Flatten[MapThread[ConstantArray[#1,#2]&,{parentTubingModelPackets,ToList[counts]}]];

	(* Create a list of resources that is index matched to the tubes we are building *)
	finalTubingResources=Lookup[expandedParentTubingModelPackets,Object]/.Thread[uniqueParentTubings->Flatten[tubingResources]];

	(* Expand the precut tubes with their count *)
	expandedPrecutTubingPackets=Flatten[MapThread[ConstantArray[#1,#2]&,{tubingModelPackets,ToList[counts]}]];

	(* Create the sticker tag resource *)
	(* Note that the Sticker Tag is not countable resource so we don't need Amount *)
	stickerTagResource=Link[Resource[Sample->Model[Item,Consumable,"Cabel Label Sticker Tag for stickering small objects"]]];

	(* ----- Build protocol Packet ----- *)

	(* Create a protocol ID *)
	protocolID=CreateID[Object[Protocol, AssembleCrossFlowFiltrationTubing]];

	(* Generate the checkpoint estimates *)
	checkpointEstimates={
		{"Picking Resources",10 Minute,"Materials that are necessary for the protocol are gathered.",Link[Resource[Operator->$BaselineOperator]]},
		{"Building Precut Tubings",10 Minute*Total[ToList[counts]],"Tubings are cut and affixed with fittings.",Link[Resource[Operator->$BaselineOperator]]},
		{"Storing Resources",10 Minute,"Materials are stored.",Link[Resource[Operator->$BaselineOperator]]}
	};

	(* Create the protocol packet *)
	protocolPacket=<|
		Object->protocolID,
		Type->Object[Protocol, AssembleCrossFlowFiltrationTubing],
		Replace[PrecutTubingModels]->Link[expandedPrecutTubingPackets],
		Replace[Fittings]->fittingResources,
		Replace[BatchLengths]->ConstantArray[2,Total[ToList[counts]]],
		Replace[Tubings]->finalTubingResources,
		Replace[TubingLengths]->Lookup[expandedPrecutTubingPackets,Size],
		StickerTag->stickerTagResource,
		Replace[Checkpoints]->checkpointEstimates,
		ResolvedOptions -> myCollapsedResolvedOptions,
		UnresolvedOptions -> myUnresolvedOptions,

		(* this Preparation link is SUUUUUPER important for Engine to finish Resource Picking properly;
		 	assume that if prepared resources was sent in, it indexed to the models*)
		Replace[PreparedResources]->Link[myPreparedResourcePackets,Preparation]

	|>;

	(* get all the resource "symbolic representations" *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs=DeleteDuplicates[Cases[Flatten[Values[protocolPacket]],_Resource,Infinity]];

	(* call fulfillableResourceQ on all resources we created *)
	{fulfillable,frqTests}=Which[
		MatchQ[$ECLApplication,Engine],
		{True,{}},
		gatherTests,
		Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache -> cache],
		True,
		{Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->Result,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->Not[gatherTests],Cache -> cache],Null}
	];

	(* generate the tests rule *)
	testsRule=Tests->If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule=Result->If[MemberQ[output,Result]&&TrueQ[fulfillable],
		protocolPacket,
		$Failed
	];

	(* Return our result. *)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection:: *)
(* Sister functions *)


(* No count overload *)
ExperimentAssembleCrossFlowFiltrationTubingOptions[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubingOptions[ToList[tubingModels],ConstantArray[1,Length[ToList[tubingModels]]],myOptions];

(* Single count overload *)
ExperimentAssembleCrossFlowFiltrationTubingOptions[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},count:_Integer,myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubingOptions[ToList[tubingModels],ConstantArray[count,Length[ToList[tubingModels]]],myOptions];

(* Core overload *)
ExperimentAssembleCrossFlowFiltrationTubingOptions[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},counts:{_Integer..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,resolvedOptions},

	(*Get the options as a list*)
	listedOptions=ToList[myOptions];

	(*Send in the correct Output option and remove the OutputFormat option*)
	preparedOptions=Normal@KeyDrop[Append[listedOptions,Output->Options],{OutputFormat}];

	resolvedOptions=ExperimentAssembleCrossFlowFiltrationTubing[tubingModels,counts,preparedOptions];

	(* If options fail, return failure *)
	If[MatchQ[resolvedOptions,$Failed],
		Return[$Failed]
	];

	(*Return the option as a list or table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[resolvedOptions,ExperimentAssembleCrossFlowFiltrationTubing],
		resolvedOptions
	]
];


(* ::Subsection::Closed:: *)
(*ValidExperimentAssembleCrossFlowFiltrationTubingQ*)

DefineOptions[ValidExperimentAssembleCrossFlowFiltrationTubingQ,
	Options:>{VerboseOption,OutputFormatOption},
	SharedOptions:>{ExperimentAssembleCrossFlowFiltrationTubing}
];
(* No count overload *)

ValidExperimentAssembleCrossFlowFiltrationTubingQ[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},myOptions:OptionsPattern[]]:=ValidExperimentAssembleCrossFlowFiltrationTubingQ[ToList[tubingModels],ConstantArray[1,Length[ToList[tubingModels]]],myOptions];

(* Single count overload *)
ValidExperimentAssembleCrossFlowFiltrationTubingQ[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},count:_Integer,myOptions:OptionsPattern[]]:=ValidExperimentAssembleCrossFlowFiltrationTubingQ[ToList[tubingModels],ConstantArray[count,Length[ToList[tubingModels]]],myOptions];

(* Core overload *)
ValidExperimentAssembleCrossFlowFiltrationTubingQ[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},counts:{_Integer..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,capillaryGelElectrophoresisSDSTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for ExperimentAssembleCrossFlowFiltrationTubing *)
	capillaryGelElectrophoresisSDSTests=ExperimentAssembleCrossFlowFiltrationTubing[ToList[tubingModels],ToList[counts],Append[preparedOptions,Output->Tests]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails).";

	(*Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[capillaryGelElectrophoresisSDSTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[tubingModels],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[tubingModels],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,capillaryGelElectrophoresisSDSTests,voqWarnings}]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentAssembleCrossFlowFiltrationTubingQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidExperimentAssembleCrossFlowFiltrationTubingQ"]

];


(* ::Subsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubingPreview*)

DefineOptions[ExperimentAssembleCrossFlowFiltrationTubingPreview,
	SharedOptions:>{ExperimentAssembleCrossFlowFiltrationTubing}
];

ExperimentAssembleCrossFlowFiltrationTubingPreview[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubingPreview[ToList[tubingModels],ConstantArray[1,Length[ToList[tubingModels]]],myOptions];

(* Single count overload *)
ExperimentAssembleCrossFlowFiltrationTubingPreview[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},count:_Integer,myOptions:OptionsPattern[]]:=ExperimentAssembleCrossFlowFiltrationTubingPreview[ToList[tubingModels],ConstantArray[count,Length[ToList[tubingModels]]],myOptions];

(* Core overload *)
ExperimentAssembleCrossFlowFiltrationTubingPreview[tubingModels:ObjectP[Model[Plumbing,PrecutTubing]]|{ObjectP[Model[Plumbing,PrecutTubing]]..},counts:{_Integer..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	ExperimentAssembleCrossFlowFiltrationTubing[tubingModels,counts,ReplaceRule[listedOptions,Output->Preview]]
];
