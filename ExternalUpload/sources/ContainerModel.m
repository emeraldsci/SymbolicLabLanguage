(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2028 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsection::Closed:: *)
(*sharedCoreFunction*)

(* The following two feature flags should be set to False, but in unit test they can be Stubbed to True so that we don't need to specify Force -> True *)
(* This feature flag determines if we attempt to find duplicates based on product information (e.g., ProductURL) *)
$AllowDuplicateProductModel = False;
(* This feature flag determines if we attempt to find duplicates based on properties (e.g., Dimensions, MaxVolume) *)
$IgnorePropertyDuplicateModel = False;

(* ::Subsubsection::Closed:: *)
(*Error messages*)
Error::MissingProductInformation = "Requested `3` model cannot be created or modified due to lack of Product information. Please either specify at least one of the following options: `1` for your input `2`, or change the Stocked option to False.";
Error::InvalidProductDocumentationURL = "The provided ProductDocumentation URL(s) `1` cannot be recognized as pdf file. Please check the URL or try to upload from your PC instead.";
Warning::InvalidProductDocumentationURL = "The provided ProductDocumentation URL(s) `1` cannot be recognized as pdf file. We have automatically transferred this URL to ProductURL option instead.";
Error::InvalidFileDirectory = "The provided `2` file(s) `1` cannot be found in your PC. Please check your spelling, or try other option instead.";
Error::InvalidFileURL = "The provided `2` urls `1` cannot be correctly downloaded and imported. Please check your spelling, or consider manually save it to your PC and use the file path instead.";
Error::UnableToResolveName = "The function was not able to generate a name for `1` automatically due to candidate name(s) are already occupied. Please try to specify this option manually.";
Error::ValidObjectQFailing = "The following tests have failed, resulting in an invalid `2` model: `1`.";
Error::RedundantOptions = "The following options `2` are specified, which are not applicable for inputs `1`. Please leave these options as Automatic.";
Error::ConflictingPositionOptions = "For the following inputs `1`, the Positions option `2` and PositionPlotting option `3` are not compatible with each other; they must either both be Null, or both be Automatic, or both manually specified. Please modify your option accordingly.";
Error::UnableToCalculatePositions = "The function was not able to calculate Position and PositionPlotting options for inputs `1` due to incomplete information provided. Please ensure ALL of the following options are also specified: `2`.";
Error::PotentialExistingModel = "Similar existing model(s) `2` are found for new model(s) you attempted to create in positions `1`. Please check if these existing ones fulfills your purpose. If you are certain the new models are still needed, please set the option Force to True.";
Error::MoreOptionsNeeded = "Since you have set Stocked -> False and didn't provide product-related option when creating a new model, sufficient other options must be provided to fully specify the new model's properties. Please refer to other error messages and add the missing options accordingly, or add product-related option.";
Error::UnableToModifyPublicModel = "You do not have permission to modify `1` because these models are public and belong to all users. If you believe this model belongs to your team, or you believe there's an error on this public model, please contact ECL personnel for support.";
Error::CannotSpecifyTemplate = "Template option should not be provided for inputs `1` because it can only be specified when creating new models. Please set the Template option to Null for these inputs.";
Error::MismatchTemplateType = "The provided Template option(s) `1` does not match the input type(s) `2` you are trying to create. Please use the same type of model as the input for Template option.";
Error::SameProductAlreadyExist = "Container models of Type `1` and ProductInformation `2` already exist in database: `3`. Please check and select one of them which fulfills your purpose. If you are certain a new container model is still needed, please re-run the function with Force -> True.";
Error::NameAlreadyExist = "Container model of Type `1` with Name `2` already exist in database and therefore cannot be set to as the name for the new models you attempted to create. Please change the Name option, or leave it as Automatic.";
Warning::NameAlreadyExist = "Container model of Type `1` with Name `2` already exist in database. New model won't be created and changes will be made on the existing container model(s) `3` according to your options instead.";
Warning::SameProductAlreadyExist = "Container model of Type `1` and ProductInformation `2` already exist in database: `3`. New models won't be created, and changes will be made on `3` instead based on your options. If you are certain a new container model is still needed, please set the option Force to True.";
Error::RequiredOptionsForNoProduct = "Since you did not provide ProductInformation option or input, the following options `1` are needed in order to create a new `2` model. Please specify these options.";

(* ::Subsubsection::Closed:: *)
(*Core function*)
uploadContainerCoverModelCore[myMixedInput:ListableP[Alternatives[TypeP[{Model[Container], Model[Item, Cap], Model[Item, PlateSeal], Model[Item, Lid]}], ObjectP[{Model[Container], Model[Item, Cap], Model[Item, PlateSeal], Model[Item, Lid]}]]], myProductInfo:ListableP[Alternatives[Null, ObjectP[Object[Product]], ObjectP[Object[EmeraldCloudFile]], _String]], myListedOptions:{_Rule...}, myFunction_Symbol]:=Module[
	{
		listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		resolvedOptionsResult, resolvedOptions, expandedSafeOps, modelInputs, downloadedStuff, cacheBall, fastAssoc,
		simulation, cache, upload, sanitizedInput, sanitizedSafeOptions, resolvedOptionTests, specifiedProducts,
		uploadPackets, listedInputs, collapsedResolvedOptions, returnEarlyQ, result, updatedSimulationAfterDownload,
		updatedSimulationAfterOptionResolving, modelsToUpload, finalResult, inputTypes, allModelPackets, newModelPackets,
		newModelTypes, existingModelSearchCriteria, searchResult, newModelIndecies, duplicateExistingModelTest,
		allExistingModelNotebooks, tamperingPublicModelQ, templateModels, sanitizedUnresolvedOptions, expandedUnresolvedOptions,
		listedProductInfo, correctedInputs, docNumber, sanitizedProductInfo
	},

	(* make sure we're working with a list of options and samples, and remove all temporal links *)
	{{listedInputs, listedProductInfo}, listedOptions} = Experiment`Private`removeLinks[{ToList[myMixedInput], ToList[myProductInfo]}, myListedOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[listedOptions, Output, Result];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[myFunction, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[myFunction, listedOptions, AutoCorrect -> False], {}}
	];

	{simulation, cache, upload} = Lookup[safeOptions, {Simulation, Cache, Upload}];

	(* If the specified options do not match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[Lookup[listedOptions, Output] /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	{{sanitizedInput, sanitizedProductInfo}, sanitizedSafeOptions} = Experiment`Private`sanitizeInputs[{listedInputs, listedProductInfo}, safeOptions, Simulation -> simulation];
	sanitizedUnresolvedOptions = Experiment`Private`sanitizeInputs[listedInputs, listedOptions, Simulation -> simulation][[2]];

	(* Here we replace all Objects in inputs to Types and use this for ValidInputLengthsQ and ExpandIndexMatchedInputs. *)
	(* This is because the way we define the usage of this function. In the usage, it takes either pure type or pure object as input *)
	(* So it will run into problem when we have a mixture. Also we will need to direct ValidInputLengthsQ and ExpandIndexMatchedInputs to use different definitions *)
	(* A much easier way around is to temporarily convert all inputs to types *)
	inputTypes = Replace[sanitizedInput, x:ObjectP[] :> Download[x, Type], 1];

	docNumber = 4;
	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = ValidInputLengthsQ[myFunction, {inputTypes, listedProductInfo}, listedOptions, docNumber, Output -> {Result, Tests}];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[myFunction, {inputTypes, listedProductInfo}, sanitizedSafeOptions, docNumber]];
	expandedUnresolvedOptions = Last[ExpandIndexMatchedInputs[myFunction, {inputTypes, listedProductInfo}, sanitizedUnresolvedOptions, docNumber]];

	(* Isolate all Model[Container] or cover model objects (not types) from the inputs, and do a download *)
	modelInputs = Cases[sanitizedInput, ObjectP[Model]];

	(* Find all other objects in the options *)
	specifiedProducts = Cases[Flatten[{Lookup[sanitizedSafeOptions, Product, Null], sanitizedProductInfo}], ObjectP[Object[Product]]];
	templateModels = Cases[ToList[Lookup[sanitizedSafeOptions, Template, Null]], ObjectP[]];

	cacheBall = downloadDuffPackets[
		Join[modelInputs, specifiedProducts, templateModels],
		cache,
		simulation
	];

	(* generate a fast cache association *)
	(* important notice: This fastAssoc must contain packets of the existing model that we are trying to modify *)
	fastAssoc = Experiment`Private`makeFastAssocFromCache[cacheBall];

	(* Error check: we should not allow external users to mess with existing public models *)
	allExistingModelNotebooks = Download[Experiment`Private`fastAssocLookup[fastAssoc, #, Notebook]& /@ modelInputs, Object];

	tamperingPublicModelQ = If[MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
		False,
		MemberQ[allExistingModelNotebooks, Null]
	];

	If[tamperingPublicModelQ,
		Message[Error::UnableToModifyPublicModel, PickList[modelInputs, allExistingModelNotebooks, Null]];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	updatedSimulationAfterDownload = If[MatchQ[simulation, _Simulation],
		UpdateSimulation[simulation, Simulation[cacheBall]],
		Simulation[cacheBall]
	];

	resolvedOptionsResult = Check[
		{resolvedOptions, uploadPackets, modelsToUpload, resolvedOptionTests, correctedInputs} = resolveUploadModelOptions[sanitizedInput, sanitizedProductInfo, expandedSafeOps, expandedUnresolvedOptions, fastAssoc, myFunction],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption, Error::ValidObjectQFailing}
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = RemoveHiddenOptions[
		myFunction,
		CollapseIndexMatchedOptions[
			myFunction,
			resolvedOptions,
			Ignore -> listedOptions,
			Messages -> False
		]
	];

	(* If error is thrown during option resolving, return early *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, resolvedOptionTests}],
			Options -> collapsedResolvedOptions,
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	(* Check if user is trying to create new models that are very similar to existing ones *)

	allModelPackets = Cases[uploadPackets,
		PacketP[{Model[Container], Model[Item]}]
	];

	(* Find the packets of new models trying to create *)
	(* each input should only result in one single model packet; so PickList should function correctly here *)
	newModelPackets = PickList[allModelPackets, correctedInputs, TypeP[]];
	newModelTypes = Cases[correctedInputs, TypeP[]];
	newModelIndecies = Flatten[Position[correctedInputs, TypeP[]]];

	(* Construct search clauses *)
	existingModelSearchCriteria = Map[
		Function[{packet},
			Module[
				{
					minVolume, maxVolume, footprint, sterile, reusability, defaultStorageCondition,
					dimensions, rows, columns, membraneMaterial, poreSize, coverFootprint, coverType,
					productURL, productDoc, tooLittleInfoQ, propertyCriteria, productCriteria, semiFinalSearchClause
				},

				(* Lookup some of the key properties *)
				{
					minVolume,
					maxVolume,
					footprint,
					sterile,
					reusability,
					defaultStorageCondition,
					dimensions,
					rows,
					columns,
					membraneMaterial,
					poreSize,
					coverFootprint,
					coverType,
					productURL,
					productDoc
				} = Lookup[packet, #, Null]& /@ {
					MinVolume,
					MaxVolume,
					Footprint,
					Sterile,
					Reusable,
					DefaultStorageCondition,
					Dimensions,
					Rows,
					Columns,
					MembraneMaterial,
					PoreSize,
					CoverFootprint,
					CoverType,
					Append[ProductURL],
					Append[ProductDocumentationFiles]
				};

				propertyCriteria = And @@ Join[
					(* Construct rough search criteria for Max and Min volume; allow for ~20% variance *)
					MapThread[
						Function[{field, value},
							If[NullQ[value],
								Nothing,
								And[
									field >= value * 0.8,
									field <= value * 1.2
								]
							]
						],
						{{MinVolume, MaxVolume}, {minVolume, maxVolume}}
					],
					(* Construct precise search criteria *)
					MapThread[
						Function[{field, value},
							If[NullQ[value],
								Nothing,
								field == value
							]
						],
						{
							{Footprint, Sterile, Reusable, DefaultStorageCondition, Rows, Columns, MembraneMaterial, PoreSize, CoverFootprint, CoverType},
							{footprint, sterile, reusability, defaultStorageCondition, rows, columns, membraneMaterial, poreSize, coverFootprint, coverType}
						}
					],
					(* Special: construct search criteria for Dimensions. Allow 10% variation on each dimensions *)
					If[NullQ[dimensions],
						{},
						{
							Field[Dimensions[[1]]] >= dimensions[[1]] * 0.8,
							Field[Dimensions[[2]]] >= dimensions[[2]] * 0.8,
							Field[Dimensions[[3]]] >= dimensions[[3]] * 0.8,
							Field[Dimensions[[1]]] <= dimensions[[1]] * 1.2,
							Field[Dimensions[[2]]] <= dimensions[[2]] * 1.2,
							Field[Dimensions[[3]]] <= dimensions[[3]] * 1.2
						}
					]
				];

				(* Check if we have at least 3 properties specified for Containers or at least 2 properties for Covers *)
				(* The idea is that for covers if we have CoverType and CoverFootprint we should definitely start checking duplicates *)
				(* For plates if we have rows, columns and any of MaxVolumn, Reusable or Sterile we should start checking duplicates *)
				(* For filter vessel or plates if we have PoreSize, MembraneMaterial plus any 1 other properties we should start checking duplicates *)
				(* Thus I set the limit for cover to 2, container to 3 *)

				tooLittleInfoQ = TrueQ[
					Count[{minVolume, maxVolume, footprint, sterile, reusability, defaultStorageCondition,
						dimensions, rows, columns, membraneMaterial, poreSize, coverFootprint, coverType}, Except[_?NullQ]] < If[MatchQ[myFunction, UploadContainerModel],
						3,
						2
					]
				];

				semiFinalSearchClause = If[tooLittleInfoQ,
					(* If we have too little information about container/cover properties, we are almost guaranteed to find something in database, which could be a false error *)
					(* Thus in that case let's ignore the property clause, only search according to product *)
					False,
					(* On the other hand, if we have enough info, we want to instead find container models that satisfy EITHER criteria *)
					propertyCriteria
				];

				(* One last tricky thing. If we have absolutely no info (e.g. when user call this function in CCD and haven't modified any options yet) *)
				(* the search clause becomes False, which will cause Search to error out. Change it to some dummy condition that won't match to anything instead *)
				If[MatchQ[semiFinalSearchClause, False],
					ProductURL == CreateUUID[],
					semiFinalSearchClause
				]
			]
		],
		newModelPackets
	];

	searchResult = If[!TrueQ[Lookup[resolvedOptions, Force]] && Length[newModelTypes] > 0 && !TrueQ[$IgnorePropertyDuplicateModel],
		(* Search to see if we have similar existing model in database. Limit MaxResults to 5 just in case user supplied something that would return hundreds of models *)
		Search[newModelTypes, Evaluate[existingModelSearchCriteria], MaxResults -> 5],
		ConstantArray[{}, Length[newModelTypes]]
	];

	If[Length[Flatten[searchResult]] > 0 && !MemberQ[output, Tests],
		Message[Error::PotentialExistingModel, PickList[newModelIndecies, searchResult, Except[{}]], PickList[searchResult, searchResult, Except[{}]]]
	];

	duplicateExistingModelTest = MapThread[
		Test["For new model at input position "<>ToString[#1]<>", No similar existing models are found in database:",
			#2,
			{}
		]&,
		{newModelIndecies, searchResult}
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Or[
		MatchQ[resolvedOptionsResult, $Failed],
		!MemberQ[output, Result],
		Length[Flatten[searchResult]] > 0,
		And[
			gatherTests,
			Not[RunUnitTest[<|"Tests" -> resolvedOptionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]]
		]
	];

	(* If option resolution failed and we aren't asked for the simulation or output, return early. *)
	If[returnEarlyQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, resolvedOptionTests, duplicateExistingModelTest}],
			Options -> collapsedResolvedOptions,
			Preview -> Null,
			Simulation -> Simulation[]
		}]
	];

	finalResult = If[MatchQ[myMixedInput, _List],
		modelsToUpload,
		First[modelsToUpload]
	];

	(* When Upload -> True, we want to make sure the output is a single or list of Model[Container]s that match the input format *)
	result = If[upload,
		Upload[uploadPackets];
		finalResult,
		uploadPackets
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> result,
		Tests -> Flatten[{safeOptionTests, validLengthTests, resolvedOptionTests}],
		Options -> collapsedResolvedOptions,
		Preview -> Null,
		Simulation -> updatedSimulationAfterOptionResolving
	}
];

(* ::Subsubsection::Closed:: *)
(*Option resolver*)
resolveUploadModelOptions[myInput_List, myProductInfo_, myOptions:{_Rule...}, myUserOptions:{_Rule...}, myFastAssocCache_Association, myParentFunctionHead_Symbol] := Module[
	{
		optionsAssociation, developerQ, mapThreadFriendlyOptions, upload, outputSpecification,
		gatherTest, messageQ, uploadRaw, changePackets, product, productURL, productDocumentation,
		name, completeProductOptionQs, validProductDocumentationURLQs,
		validProductDocumentationDirectoryQs, allAccessoryPackets, incompleteProductOptions,
		incompleteProductTests, invalidProductDocumentationURLOptions, invalidProductDocumentationURLTests,
		invalidProductDocumentationDirectoryOptions, invalidProductDocumentationDirectoryTests,
		productModelConflictOptions, productModelConflictTests, duplicatedAutomaticNameOptions, duplicatedAutomaticNameTests,
		invalidOptions, allTests, allPackets, resolvedOptions, containerModels, validImageFileDirectoryQs,
		invalidImageFileDirectoryOptions, invalidImageFileDirectoryTests, imageFile, allIrrelevantFields,
		irrelevantFieldOptions, irrelevantFieldTests, errorTypeString, positions, positionPlotting,
		allMissingPositionInfoFields, compatiblePositionFieldsQs, incompatiblePositionFieldOptions,
		incompatiblePositionFieldTests, missingPositoinInfoFieldsOptions, missingPositionInfoFieldsTests,
		productDocumentationURLTransferredQs, productDocumentationURLTransferredWarnings, productOptionFulfilledQs,
		productOptionFulfilledTests, productOptionUnfulfilledOptions, allFailedVOQTestDescriptions, allVOQFailureMessages,
		validImageFileURLQs, invalidImageFileURLOptions, invalidImageFileURLTests,
		mapThreadFriendlyUserOptions, allTemplateOnNewModelQs, allCorrectTemplateTypeQs,
		invalidTemplateOptions, invalidTemplateTests, mismatchTemplateTypeOptions, mismatchTemplateTypeTests,
		expandedResolvedOptions, voqInvalidOptions, voqTests, splittedMessages, groupedMessages,
		mergedMessage, unresolvedStrict, resolvedStrict, finalRoundedOptions, optionPrecisionTests, preResolvedOptions,
		preResolvedOptionsForPackets, productAccessoryPackets, duplicationCheckSearchClauses, needDuplicationCheckQ,
		flattenedSearchClauses, validSearchClauses, searchTypes, searchResults,
		allDuplicateResults, nameDuplicatePublicObjects, productDuplicatePublicObjects, forceOption, correctedInputs, reasonForInputChange,
		inputsWithMultipleDuplicates, inputsWithNameDuplicate, inputsWithSingleDuplicate, invalidInputs, objectsNeedDownload,
		newCache, updatedFastAssoc, requiredOptions, allMissingRequiredOptions, missingRequiredOptionsNoDup, missingRequiredOptions,
		dateString, potentialOccupiedNamedObjects, nameDuplicatePrivateObjects, productDuplicatePrivateObjects,
		optionsProvidedQ, productDuplicationInputs, nameDuplicationOptions, inputsWithUnresolvableNameDuplicate,
		inputsToNotUpload, changePacketsToUpload
	},
	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	optionsAssociation = Association[myOptions];

	(* Find if a developer or user is running this function. Error checking will be different *)
	developerQ = MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]];

	(* Find the Strict option *)
	unresolvedStrict = Lookup[optionsAssociation, Strict];
	(* Resolve Strict option. Basically If developer running this function, set to True, otherwise set to False *)
	resolvedStrict = If[MatchQ[unresolvedStrict, BooleanP],
		unresolvedStrict,
		developerQ
	];

	(* define a customized string to use in error message. Since UploadContainerModel and UploadCoverModel shares the same resolver *)
	(* we need to clarify what type of model we are working with in certain error messages *)
	errorTypeString = Switch[myParentFunctionHead,
		UploadContainerModel,
			"container",
		UploadCoverModel,
			"cover",
		_,
			""
	];

	(* A variable to record if the user has provided any container related options (i.e., excluding things like Upload, Output, and product-related options) *)
	optionsProvidedQ = TrueQ[
		Length[Complement[
			Keys[myUserOptions],
			Join[{Force, Simulation, Product, ProductDocumentation, ProductURL}, ToExpression /@ Keys[Options[ExternalUploadHiddenOptions]]]
		]] > 0
	];

	(* Convert option association into MapThread friendly version *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[myParentFunctionHead,
		optionsAssociation
	];
	mapThreadFriendlyUserOptions = If[Length[myUserOptions] ==0,
		ConstantArray[<||>, Length[myInput]],
		OptionsHandling`Private`mapThreadOptions[myParentFunctionHead,
			Association[myUserOptions]
		]
	];

	(* extract some resolver-related options *)
	{uploadRaw, outputSpecification} = Lookup[optionsAssociation, {Upload, Output}];

	(* find if we are actually doing Upload or not. Don't be fooled by something like Upload -> True, Output -> Options, we are not doing Upload in this case *)
	upload = And[uploadRaw, MemberQ[ToList[outputSpecification], Result]];

	gatherTest = MemberQ[ToList[outputSpecification], Tests];
	messageQ = Not[gatherTest];

	(* We will do a two-step option resolving. First, resolve only Name and ProductInformation. This is to quickly identify duplicates *)
	(* If there are already a container in database with the same name and/or Product/ProductURL/ProductDocumentation, then instead of creating a new one, just switch to the existing one instead *)
	(* Then after we sort that out and ensure all new objects are going to have unique name/product, we do the second step of option resolution to resolve the rest *)

	(* Step 1: MapThread to resolve Name and ProductInformation *)
	{
		preResolvedOptions,
		preResolvedOptionsForPackets,
		productAccessoryPackets,
		validProductDocumentationURLQs,
		validProductDocumentationDirectoryQs,
		productDocumentationURLTransferredQs,
		duplicationCheckSearchClauses
	} = Transpose[MapThread[
		Function[{input, productInfo, option},
			Module[
				{
					newModelQ, initialPacket, inputType, unresolvedProductInformation, unresolvedProductFromInput,
					unresolvedProductURLFromInput, unresolvedProductDocumentationFromInput, unresolvedProductFromOption,
					unresolvedProductURLFromOption, unresolvedProductDocumentationFromOption, productRelation,
					unresolvedStocked, unresolvedProduct, unresolvedProductDocumentation, unresolvedProductURL,
					resolvedStocked, completeProductOptionQ, productDocumentationFilePath, validProductDocumentationURLQ,
					validProductDocumentationDirectoryQ, documentationUploadPacket, autoUploadProductViaURLQ,
					resolvedProductURL, productDocumentationTransferredToURLQ,
					resolvedProductDocumentation, resolvedProductDocumentationObject, resolvedProduct,
					resolvedProductObject, optionsWithProductInfoResolved, packetWithProductInfoResolved,
					resolvedProductInformation, searchClause
				},

				(* Find are we making a new model *)
				newModelQ = MatchQ[input, TypeP[]];

				(* If we are working on an existing model, pull out its packet for later use *)
				initialPacket = If[newModelQ,
					<||>,
					Experiment`Private`fetchPacketFromFastAssoc[input, myFastAssocCache]
				];

				(* Get the Type of container *)
				inputType = If[newModelQ,
					input,
					Download[input, Type]
				];

				(* Note, since we are just resolving Name and ProductInformation options for duplicate-checking purpose *)
				(* There's no need to apply Template, since we don't inherit these options from Template objects anyway *)

				(* --- Check Product-related options --- *)

				(* Note, there is a ProductInfo input and ProductInformation option, they are really the same thing *)
				(* We made this input to make it easier for users; also that allows user to run the function without failure in CCD without having to change any options *)
				(* In the option resolver, we extract both and select the non-Null one; take the option value instead of input, if both are Null or both not Null *)
				unresolvedProductInformation = productInfo;

				(* Note, there are two possible option sources: either the ProductInformation (input or option), or the individual options. Read from the ProductInformation first *)

				{
					unresolvedProductFromInput,
					unresolvedProductURLFromInput,
					unresolvedProductDocumentationFromInput
				} = Switch[unresolvedProductInformation,
					(* If the ProductInfo input is an Object[Product], that's equivalent as specifying Product option *)
					ObjectP[Object[Product]],
						{unresolvedProductInformation, Null, Null},
					(* Other object input: that's equivalent as specifying ProductDocumentation option *)
					ObjectP[],
						{Null, Null, unresolvedProductInformation},
					(* URL input: this is a bit tricky; if the URL points to a file, then it's ProductDocumentation; otherwise it's ProductURL *)
					URLP,
						Module[{downloadedURL},
							downloadedURL = downloadAndValidateURL[unresolvedProductInformation, "ProductInfo", validatePDF];
							(* If url is a PDF, set ProductDocumentation option; otherwise set ProductURL *)
							If[MatchQ[downloadedURL, $Failed],
								{Null, unresolvedProductInformation, Null},
								{Null, Null, unresolvedProductInformation}
							]
						],

					(* Other string input: this is a local file directory *)
					_String,
						{Null, Null, unresolvedProductInformation},
					(* Null input: no info about product from input *)
					Null,
						{Null, Null, Null},
					(* In theory there shouldn't be any other possibility, but do a catch all *)
					_,
						{Null, Null, Null}
				];

				(* reading the three Product-related options: Product, ProductDocumentation, ProductURL from Options *)
				{
					unresolvedProductFromOption,
					unresolvedProductURLFromOption,
					unresolvedProductDocumentationFromOption,
					standaloneCoverProduct,
					unresolvedStocked
				} = Map[
					Lookup[option, #, Null]&,
					{Product, ProductURL, ProductDocumentation, StandaloneCoverProduct, Stocked}
				];

				(* Combine product info from input and option. Non-null value of option overwrites input *)
				{unresolvedProduct, unresolvedProductURL, unresolvedProductDocumentation} = MapThread[
					If[MatchQ[#2, (Null | Automatic)], #1, #2] /. {Automatic -> Null} &,
					{
						{unresolvedProductFromInput, unresolvedProductURLFromInput, unresolvedProductDocumentationFromInput},
						{unresolvedProductFromOption, unresolvedProductURLFromOption, unresolvedProductDocumentationFromOption}
					}
				];

				(* resolve Stocked. The resolution is simple: change Automatic -> False if and only if we are creating new model *)
				(* When modifying existing model we want to default to the current Stocked field *)
				resolvedStocked = Which[
					MatchQ[unresolvedStocked, BooleanP],
						unresolvedStocked,

					newModelQ,
						False,

					(* catch all. Set to the same as current Stocked field, but change Null to False *)
					True,
						Replace[Lookup[initialPacket, Stocked, False], Null -> False]
				];

				completeProductOptionQ = If[resolvedStrict,
					(* When Strict -> True, check at least one of Product and ProductDocumentation are populated *)
					(* This is because if we have ProductURL, we better actually make an Object[Product] first *)
					!And[
						newModelQ,
						MatchQ[unresolvedProduct, Null],
						MatchQ[unresolvedProductDocumentation, Null]
					],
					(* When function run by user, check that at least one of these three options are informed when trying to set up new model *)
					!And[
						newModelQ,
						MatchQ[unresolvedProductURL, Null],
						MatchQ[unresolvedProduct, Null],
						MatchQ[unresolvedProductDocumentation, Null]
					]
				];

				productDocumentationFilePath = Which[
					(* If user provided URL as documentation, try to download into $TemporaryDirectory *)
					MatchQ[unresolvedProductDocumentation, URLP],
						downloadAndValidateURL[unresolvedProductDocumentation, "product.pdf", MatchQ[FileFormat[#], "PDF"]&],
					(* If user provided a local directory, use it *)
					MatchQ[unresolvedProductDocumentation, FilePathP],
						unresolvedProductDocumentation,
					(* Otherwise don't use anything *)
					True,
						Null
				];

				validProductDocumentationURLQ = Or[
					(* If the documetation is not URL, always se this variable to True *)
					!MatchQ[unresolvedProductDocumentation, URLP],
					(* For documentation in the form of URL, ensure we have successfully downloaded it *)
					MatchQ[productDocumentationFilePath, (FilePathP | _File)]
				];

				(* If a local directory is specified as ProductDocumentation, check whether the file actually exist *)
				(* The second !MatchQ may appear redundant, but actually FilePathP is just any string currently... so URL will also match *)
				validProductDocumentationDirectoryQ = If[MatchQ[unresolvedProductDocumentation, FilePathP] && !MatchQ[unresolvedProductDocumentation, URLP],
					FileExistsQ[productDocumentationFilePath],
					True
				];

				(* Upload the product documentation file *)
				documentationUploadPacket = If[MatchQ[unresolvedProductDocumentation, _String] && validProductDocumentationDirectoryQ && validProductDocumentationURLQ,
					pathToCloudFilePacket[productDocumentationFilePath],
					<||>
				];

				(* It would be nice to automatically upload product object given the url; however, we should not do it here *)
				(* This is because we are checking duplicates and we will potentially switch input to an existing container model *)

				(* now resolve ProductURL first. When running UploadContainerModel we'll just keep it as is *)
				(* However special case for UploadCover: Sometimes user may provide the Product option but note that the cover model is supposed to *)
				(* be the DefaultCoverModel of the product, not ProductModel of it. In this case we don't want to Append[Products] -> product in the upload packet *)
				(* Instead, we are going to upload to ProductURL only *)
				resolvedProductURL = Which[
					(* If the user-provided ProductDocumentation is a non-pdf URL, we will transfer that option to ProductURL instead *)
					NullQ[unresolvedProductURL] && MatchQ[validProductDocumentationURLQ, False],
						unresolvedProductDocumentation,
					MatchQ[myParentFunctionHead, UploadContainerModel],
						unresolvedProductURL,
					(* If ProductURL is specified, keep using it *)
					MatchQ[myParentFunctionHead, UploadCoverModel] && MatchQ[unresolvedProductURL, _String],
						unresolvedProductURL,
					(* If Product is specified and standaloneCoverProduct != True, download the ProductURL from product object instead *)
					MatchQ[myParentFunctionHead, UploadCoverModel] && (!TrueQ[standaloneCoverProduct]) && MatchQ[unresolvedProduct, ObjectP[]],
						Experiment`Private`fastAssocLookup[myFastAssocCache, unresolvedProduct, ProductURL],
					(* Any other cases keep the option as is *)
					True,
						unresolvedProductURL
				];

				(* use a variable to record if we have transferred the ProductDocumentation option to ProductURL instead *)
				productDocumentationTransferredToURLQ = NullQ[unresolvedProductURL] && MatchQ[validProductDocumentationURLQ, False];

				(* If productDocumentationTransferredToURLQ == True, set validProductDocumentationURLQ to True as well, so we throw a warning instead of hard error *)
				validProductDocumentationURLQ = If[TrueQ[productDocumentationTransferredToURLQ],
					True,
					validProductDocumentationURLQ
				];

				(* resolve ProductDocumentation option *)

				resolvedProductDocumentation = If[TrueQ[productDocumentationTransferredToURLQ],
					(* If we have transferred ProductDocumentation option to ProductURL, set ProductDocumentation to Null *)
					Null,
					(* If local directory or URL is specified, do not change the option, keep using what we have *)
					(* This is because user may use the resolved options to run the function again *)
					(* We don't want the resolved option to point to a non-existing object and cause error in the second run *)
					unresolvedProductDocumentation
				];

				(* Find the uploaded ProductDocumentation CloudFile, if it exist *)
				resolvedProductDocumentationObject = Which[
					MatchQ[documentationUploadPacket, PacketP[]],
						Lookup[documentationUploadPacket, Object],

					(* If the option is not specified, set to Null, so that it will be removed later *)
					MatchQ[resolvedProductDocumentation, Null],
						Null,

					(* If resolvedProductDocumentation is an Object, use that *)
					MatchQ[resolvedProductDocumentation, ObjectP[]],
						resolvedProductDocumentation,

					(* All other cases set to Null *)
					True,
						Null
				];

				(* Finally resolve the Product option. Nothing to resolve *)
				resolvedProduct = unresolvedProduct;

				(* Resolve Product for packet construction: Basically just change Automatic -> Null *)
				resolvedProductObject = If[MatchQ[unresolvedProduct, Automatic],
					Null,
					unresolvedProduct
				];

				(* Finally, resolve the ProductInformation option *)
				(* This is a completely user-facing option which do not exist as a field in Model[Container] *)

				resolvedProductInformation = Which[
					(* If we resolved a ProductURL, use that *)
					!NullQ[resolvedProductURL],
						resolvedProductURL,
					(* If we resolved a ProductDocumentation, use that *)
					!NullQ[resolvedProductDocumentation],
						resolvedProductDocumentation,
					(* Finally, if we resolved a product, use that *)
					!NullQ[resolvedProduct],
						resolvedProduct,
					(* All other cases set to Null *)
					True,
						Null
				];

				(* Construct resolved option set *)
				optionsWithProductInfoResolved = ReplaceRule[Normal[option, Association],
					{
						ProductInformation -> resolvedProductInformation,
						ProductURL -> resolvedProductURL,
						ProductDocumentation -> resolvedProductDocumentation,
						Product -> resolvedProduct,
						Stocked -> resolvedStocked
					}
				];

				(* Construct another option set for packet construction *)
				packetWithProductInfoResolved = ReplaceRule[Normal[option, Association],
					{
						ProductURL -> resolvedProductURL,
						ProductDocumentation -> resolvedProductDocumentationObject,
						Product -> resolvedProductObject,
						Stocked -> resolvedStocked
					}
				];

				(* Construct Search clause for duplicate checking *)
				(* Note: We want to search private and public objects separately. If we find a duplicate and auto-switch to the duplicate *)
				(* We want to ensure that we only switch to private objects for user, and don't switch for developer *)
				searchClause = Flatten[
					{
						(* When creating new models, if Name is provided, search for that. Separate Public and Private objects *)
						If[MatchQ[Lookup[option, Name, Null], _String] && newModelQ,
							{
								Name == Lookup[option, Name] && Notebook == Null,
								Name == Lookup[option, Name] && Notebook != Null
							},
							{Null, Null}
						],
						(* When creating new models, search for duplicate product information *)
						If[newModelQ,
							With[
								{
									clause = Or @@ {
										(* Check for Duplicated Product *)
										If[MatchQ[resolvedProduct, ObjectP[]],
											Products == resolvedProduct,
											Nothing
										],
										(* Check for Duplicated ProductURL *)
										If[MatchQ[resolvedProductURL, _String],
											ProductURL == resolvedProductURL,
											Nothing
										],
										(* Check for Duplicated ProductDocumentation *)
										If[MatchQ[resolvedProductDocumentation, ObjectP[]],
											ProductDocumentationFiles == resolvedProductDocumentation,
											Nothing
										]
									}
								},
								{
									clause && Notebook == Null,
									clause && Notebook != Null
								}
							],
							{False, False}
						]
					}
				];

				{
					optionsWithProductInfoResolved,
					packetWithProductInfoResolved,
					documentationUploadPacket,
					validProductDocumentationURLQ,
					validProductDocumentationDirectoryQ,
					productDocumentationTransferredToURLQ,
					searchClause
				}

			]
		],
		{myInput, myProductInfo, mapThreadFriendlyOptions}
	]];

	(* Now check duplicate. First transpose the clauses so that all Name clauses are moved to first half, then flatten *)
	flattenedSearchClauses = Flatten[Transpose[duplicationCheckSearchClauses]];
	(* Label if we have a valid search condition *)
	needDuplicationCheckQ = MatchQ[#, (_Equal | _Or | _And)]& /@ flattenedSearchClauses;

	(* Select valid Search Clauses and types *)
	validSearchClauses = PickList[flattenedSearchClauses, needDuplicationCheckQ];
	searchTypes = ToList /@ PickList[Flatten[{myInput, myInput, myInput, myInput}], needDuplicationCheckQ];

	(* Do the Search *)
	searchResults = If[Length[validSearchClauses] > 0,
		Search[searchTypes, Evaluate[validSearchClauses], MaxResults -> 5, SubTypes -> False],
		{}
	];

	(* Make a list of duplicate index-matching to input. For inputs that don't need to do search, fill in with {} *)
	allDuplicateResults = RiffleAlternatives[searchResults, ConstantArray[{}, Count[needDuplicationCheckQ, False]], needDuplicationCheckQ];

	(* Separate the Duplication from name and product information. Duplication from name is always the first half *)
	{nameDuplicatePublicObjects, nameDuplicatePrivateObjects, productDuplicatePublicObjects, productDuplicatePrivateObjects} = Partition[allDuplicateResults, Length[needDuplicationCheckQ]/4];

	(* extract the force option *)
	forceOption = Lookup[optionsAssociation, Force, False];

	(* Now decide whether we need to switch our input to an existing object *)
	(* The correctedInputs indicates the updated inputs after potential switching *)
	(* reasonForInputChange will be used to differentiate error. In general, single symbol means soft warning and list means hard error *)
	(* In the list, the first element is the actual reason for input change, and the rest are duplication objects *)
	{correctedInputs, reasonForInputChange} = Transpose[
		MapThread[
			Function[{input, publicNameDuplicate, privateNameDuplicate, publicProductDuplicates, privateProductDuplicates},
				Which[
					(* If no duplicates from any criteria, we are good, keep using the input object/type *)
					MatchQ[{publicNameDuplicate, privateNameDuplicate, publicProductDuplicates, privateProductDuplicates}, {{}, {}, {}, {}}],
						{input, Null},
					(* If there exist a name duplicate, since the Search has SubTypes -> False, it's guaranteed to get at most 1 result *)
					(* Take different actions depending on whether the duplicate object is private or public, and if it's user or developer running the function *)
					(* Note: we don't allow Force -> True to bypass this check because the upload will fail anyway *)

					(* If user is running this function and we find a private name duplicate object, switch to that *)
					Length[privateNameDuplicate] > 0 && !developerQ,
						{First[privateNameDuplicate], Name},
					(* If user is running this function and we find a public name duplicate object, do not switch; user won't be able to modify the public model and upload will fail later *)
					(* Therefore instead mark error here, will throw a hard error later *)
					Length[publicNameDuplicate] > 0 && !developerQ,
						{input, {Name, First[publicNameDuplicate]}},
					(* If developer is running this function and we find either public or private name duplicate, don't switch, just throw hard error *)
					developerQ && Or[Length[privateNameDuplicate] > 0, Length[publicNameDuplicate] > 0],
						{input, {Name, First[Join[privateNameDuplicate, publicNameDuplicate]]}},
					(* If the Force option is True, disregard product duplicate, keep using original input *)
					TrueQ[forceOption],
						{input, Null},
					(* If the feature flag $AllowDuplicateProductModel is True, disregard product duplicate, keep using original input *)
					TrueQ[$AllowDuplicateProductModel],
						{input, Null},
					(* If user is running this function and there is one private product duplicate, use the product duplicate *)
					!developerQ && Length[privateProductDuplicates] == 1,
						{First[privateProductDuplicates], ProductInformation},
					(* If the user is running this function and there is one public product duplicate, and the user did not attempt to change any properties, use the product duplicate *)
					!developerQ && Length[publicProductDuplicates] == 1 && !optionsProvidedQ,
						{First[publicProductDuplicates], "Public ProductInformation"},
					(* If the developer is running this function and there is one public product duplicate, switch to that *)
					developerQ && Length[publicProductDuplicates] == 1,
						{First[publicProductDuplicates], ProductInformation},
					(* If the developer is running this function and there is no public product duplicate (i.e., duplicate is private), disregard that duplicate, keep using the same input *)
					developerQ && Length[publicProductDuplicates] == 0,
						{input, Null},
					(* At this point, the only possibility is we found duplicate(s) from product information and we can't/shouldn't switch to that *)
					(* We'll need to throw error. For developers, display only the public duplicates as candidates in the error message to choose from *)
					developerQ,
						{input, Prepend[publicProductDuplicates, ProductInformation]},
					(* For user, display both public and private duplicate candidates *)
					True,
						{input, Prepend[Join[privateProductDuplicates, publicProductDuplicates], ProductInformation]}
				]
			],
			{myInput, nameDuplicatePublicObjects, nameDuplicatePrivateObjects, productDuplicatePublicObjects, productDuplicatePrivateObjects}
		]
	];

	(* Error checking. First find if any input triggered hard error, which will have a List in reasonForInputChange *)
	inputsWithMultipleDuplicates = PickList[myInput, reasonForInputChange, {ProductInformation, ___}];

	(* If there is, throw error *)
	productDuplicationInputs = If[Length[inputsWithMultipleDuplicates] > 0 && messageQ,
		Message[Error::SameProductAlreadyExist,
			inputsWithMultipleDuplicates,
			Lookup[PickList[preResolvedOptions, reasonForInputChange, {ProductInformation, ___}], ProductInformation],
			Rest /@ Select[reasonForInputChange, MatchQ[First[#], ProductInformation]&]
		];
		inputsWithMultipleDuplicates,
		{}
	];

	(* Check for Name duplicates that triggers hard error *)
	inputsWithUnresolvableNameDuplicate = PickList[myInput, reasonForInputChange, {Name, ___}];

	nameDuplicationOptions = If[Length[inputsWithUnresolvableNameDuplicate] > 0 && messageQ,
		Message[Error::NameAlreadyExist,
			inputsWithUnresolvableNameDuplicate,
			Lookup[PickList[preResolvedOptions, reasonForInputChange, {Name, ___}], Name],
			Rest /@ Select[reasonForInputChange, MatchQ[First[#], Name]&]
		];
		{Name},
		{}
	];

	(* Find if there's any name duplicates. If yes, throw warning *)
	inputsWithNameDuplicate = PickList[myInput, reasonForInputChange, Name];
	If[Length[inputsWithNameDuplicate] > 0 && messageQ,
		Message[Warning::NameAlreadyExist,
			inputsWithNameDuplicate,
			Lookup[PickList[preResolvedOptions, reasonForInputChange, Name], Name],
			PickList[correctedInputs, reasonForInputChange, Name]
		]
	];

	(* Find if there's any single product duplicates. If yes, throw warning *)
	inputsWithSingleDuplicate = PickList[myInput, reasonForInputChange, (ProductInformation | "Public ProductInformation")];
	If[Length[inputsWithSingleDuplicate] > 0 && messageQ,
		Message[Warning::SameProductAlreadyExist,
			inputsWithSingleDuplicate,
			Lookup[PickList[preResolvedOptions, reasonForInputChange, (ProductInformation | "Public ProductInformation")], ProductInformation],
			PickList[correctedInputs, reasonForInputChange, (ProductInformation | "Public ProductInformation")]
		]
	];

	(* If we have any "Public ProductInformation" problems, that means 1) it's an external user who is running this function *)
	(* 2) the external user intended to create a new model, but the provided information matches to an existing public model *)
	(* 3) the user did not intend to manually specify any other options *)
	(* In this case we want to ouput the existing public model as the result, but we don't want to include it in the packet, because the upload will fail anyway *)
	inputsToNotUpload = PickList[correctedInputs, reasonForInputChange, "Public ProductInformation"];

	(* If we found duplicates and auto-switched to existing duplicate object, we likely need another download to get cache packet for them *)
	objectsNeedDownload = Cases[PickList[correctedInputs, reasonForInputChange, (Name | ProductInformation | "Public ProductInformation")], ObjectP[]];

	newCache = If[Length[objectsNeedDownload] > 0,
		downloadDuffPackets[objectsNeedDownload, {}, Null],
		{}
	];

	updatedFastAssoc = If[Length[newCache] > 0,
		Join[myFastAssocCache, Experiment`Private`makeFastAssocFromCache[newCache]],
		myFastAssocCache
	];

	(* If user did not specify ProductInformation, we need to define a list of required options that user have to specify instead *)
	requiredOptions = If[MatchQ[myParentFunctionHead, UploadContainerModel],
		{
			Name,
			ContainerMaterials,
			Sterile,
			Reusable,
			MaxVolume
		},
		{
			Name,
			WettedMaterials,
			Sterile,
			Reusable
		}
	];

	(* Note: In the later MapThread we'll try to resolve Name if any of the name options are Automatic *)
	(* we want to ensure that the resolved Name is not already occupied in database. For that purpose, first find names that are already occupied *)

	(* Compute the dateString that will be used when resolving Name *)
	dateString = " created on " <> DateString[Now, {"Month", "Day", "Year"}];
	(* Check to see if we have any inputs which is a type (i.e., need to create new ones) and the Name is Automatic; if we don't, skip the check *)
	potentialOccupiedNamedObjects = If[MemberQ[Transpose[{correctedInputs, Lookup[preResolvedOptions, Name]}], {TypeP[], Automatic}],
		(* If we do, then search for all existing models that match the input type and the name contains dateString, which can potentially cause conflict *)
		Module[
			{typesToSearch, nameCritearia},
			typesToSearch = If[MatchQ[myParentFunctionHead, UploadContainerModel],
				Model[Container],
				{Model[Item, Cap], Model[Item, PlateSeal], Model[Item, Lid]}
			];
			nameCritearia = Quiet[StringContainsQ[Name, dateString]];
			NamedObject[Search[typesToSearch, Evaluate[nameCritearia], SubTypes -> True]]
		],
		{}
	];

	(* MapThread to resolve remaining options and do error-checking *)

	{
		(*1*)changePackets,
		product,
		productURL,
		productDocumentation,
		(*5*)name,
		completeProductOptionQs,
		allAccessoryPackets,
		(*10*)containerModels,
		validImageFileDirectoryQs,
		imageFile,
		allIrrelevantFields,
		positions,
		(*15*)positionPlotting,
		allMissingPositionInfoFields,
		compatiblePositionFieldsQs,
		productOptionFulfilledQs,
		allFailedVOQTestDescriptions,
		(*20*)validImageFileURLQs,
		allTemplateOnNewModelQs,
		allCorrectTemplateTypeQs,
		expandedResolvedOptions,
		allVOQFailureMessages,
		(*25*)voqInvalidOptions,
		allMissingRequiredOptions
	} = Transpose[MapThread[
		Function[{input, option, unresolvedOps, optionForPacket},
			Module[
				{
					completeProductOptionQ, documentationUploadPacket, resolvedProduct,
					resolvedProductURL, resolvedProductDocumentation, resolvedAmpoule, unresolvedReusability,
					resolvedCleaningMethod, resolvedReusability, newModelQ, unresolvedName, semiResolvedName,
					inputType, specifiedNamedObject, resolvedName, automaticNamedObject,
					unresolvedRows, unresolvedColumns, unresolvedNumberOfWells,
					resolvedRows, resolvedColumns, resolvedNumberOfWells, resolvedOptionToConstructPacket,
					preliminaryChangePacket, inputObject, accessoryPackets, resolvedProductDocumentationObject,
					resolvedProductObject, voqPassedQ, voqTests, initialPacket,
					unresolvedImageFile, resolvedImageFileObject, resolvedImageFile,
					validImageFileDirectoryQ, imageFileUploadPacket, previousAuthors,
					nonNullIrrelevantFields, unresolvedPositions, unresolvedPositionPlotting,
					resolvedPositions, resolvedPositionPlotting, compatiblePositionFieldsQ, missingPositionInfo,
					attemptToResolvePositionsQ, unresolvedExposedSurfaces, resolvedExposedSurfaces, unresolvedDefaultStorageCondition,
					resolvedDefaultStorageCondition, resolvedDefaultStickerModel, unresolvedDefaultStickerModel,
					unresolvedPreferredWashBin, resolvedPreferredWashBin,
					unresolvedAspectRatio, resolvedAspectRatio, productOptionFulfilledQ,
					alreadyVerified, voqFailedTestDescriptions, validImageFileURLQ, imageFilePath, template, templatePacket,
					templateOnNewModelQ, correctTemplateTypeQ, templateProvidedQ, templatedOps, allPackets, mainChangePacket,
					auxillaryPackets, resolvedOptionForOptionOutput, finalResolvedOptions, voqMessages, voqFailingOptions,
					correctedUnresolvedOps, optionForExistingModel, roundedPositions, roundedPositionPlotting,
					missingRequiredOptions, dimensions, unresolvedRNAseFree, unresolvedPyrogenFree,
					resolvedRNAseFree, resolvedPyrogenFree, unresolvedMinTemperature, unresolvedMaxTemperature,
					temperatureLimitFromMaterial, material, resolvedMinTemperature, resolvedMaxTemperature,
					unresolvedFragile, resolvedFragile, resolvedInputType, specifiedTypeChange
				},

				(* Find are we making a new model *)
				newModelQ = MatchQ[input, TypeP[]];

				(* If we are working on an existing model, pull out its packet for later use *)
				initialPacket = If[newModelQ,
					<||>,
					Experiment`Private`fetchPacketFromFastAssoc[input, updatedFastAssoc]
				];

				(* If we are working on an existing model, find if this model has already been verified by developers *)
				alreadyVerified = If[newModelQ,
					False,
					TrueQ[Lookup[initialPacket, Verified]]
				];

				(* Get the Type of container *)
				inputType = If[newModelQ,
					input,
					Download[input, Type]
				];

				(* Check if we have specified the ContainerType option *)
				specifiedTypeChange = Lookup[option, ContainerType, Null];

				(* --------------------------------------------- *)
				(* ---- Option resolving and error-checking ---- *)
				(* --------------------------------------------- *)

				(* ---- Apply Template --- *)

				(* read the Template option and find the template packet *)
				template = Lookup[option, Template, Null];
				templateProvidedQ = MatchQ[template, ObjectP[]];
				(* Use the Template packet from cache if Template option is specified. If not, use the initialPacket *)
				templatePacket = If[templateProvidedQ,
					Experiment`Private`fetchPacketFromFastAssoc[template, updatedFastAssoc],
					Null
				];

				(* Check error: Do not allow Template when modifying existing model *)
				templateOnNewModelQ = If[templateProvidedQ,
					newModelQ,
					True
				];

				(* Check error: Type of template must match input type. Allow using of sub types as template *)
				(* e.g. input = Model[Container, Vessel], Template -> Model[Container, Vessel, Filter] should be allowed, but not the opposite *)
				correctTemplateTypeQ = If[templateProvidedQ,
					MatchQ[Download[template, Type], TypeP[inputType]],
					True
				];

				(* Here we do some special treatment for Positions and PositionPlottings option *)
				(* Since for these two options, 'Null' means don't change and 'Automatic' means calculate from other options *)
				(* If the unresolved option is Null, we should overwrite that with template option, i.e., change the option value to Automatic when running resolveTemplateOptions *)
				correctedUnresolvedOps = If[newModelQ,
					DeleteCases[Normal[unresolvedOps, Association],
						Alternatives[
							Positions -> Null,
							PositionPlotting -> Null
						]
					],
					DeleteCases[
						Normal[
							(* For existing model, there is some difference between field name and option name. Change the name before feeding into resolveDefaultUploadFunctionOptions *)
							KeyReplace[unresolvedOps, {
								Product -> Products,
								ProductDocumentation -> ProductDocumentationFiles
							}],
							Association
						],
						Alternatives[
							Positions -> Null,
							PositionPlotting -> Null
						]
					]
				];

				(* For existing model, there is some difference between field name and option name. Change the name before feeding into resolveDefaultUploadFunctionOptions *)
				optionForExistingModel = Normal[
					Join[
						KeyReplace[Association[option],
							{
								Product -> Products,
								ProductDocumentation -> ProductDocumentationFiles
							}
						],
						<| Cache -> {initialPacket} |>
					],
					Association
				];

				(* Apply template *)
				templatedOps = Which[
					(* For new model which Template is provided: use the Template object to apply template *)
					MatchQ[templatePacket, PacketP[]] && newModelQ,
						resolveTemplateOptions[
							myParentFunctionHead,
							templatePacket,
							correctedUnresolvedOps,
							option,
							Exclude -> {
								Name,
								Synonyms,
								ImageFile,
								Products,
								ProductURL,
								ProductDocumentationFiles,
								Stocked,
								StandaloneCoverProduct
							}
						],

					(* For existing model: use resolveDefaultUploadFunctionOptions to apply options from database *)
					!newModelQ,
						KeyReplace[
							Association@resolveDefaultUploadFunctionOptions[inputType,
								input,
								optionForExistingModel,
								correctedUnresolvedOps
							],
							{
								Products -> Product,
								ProductDocumentationFiles -> ProductDocumentation
							}
						],

					True,
						option
				];

				(* Sometimes, user may be unsure of what type of container to create, and therefore use bare Model[Container] as input *)
				(* If that's the case, let's try to resolve the type *)
				resolvedInputType = Which[
					(* If we are creating new model and the input type is just Model[Container], not any of the subtypes, try to resolve the subtype *)
					newModelQ && MatchQ[inputType, Model[Container]],
					(* If Template is provided, simply use the Type of Template object *)
						If[templateProvidedQ,
							Download[template, Type],
							(* Otherwise, try to resolve based on provided options *)
							(* Note, this will only resolve to 1 of the 4 subtypes: Vessel, Plate, VesselFilter, PlateFilter *)
							(* We won't resolve to ExtractionCartridge since it has mutual options to filters. We expect ExtractionCartridge to be less common than Filter *)
							Module[
								{
									containerFields, vesselFields, plateFields, providedOptions, allPossibleContainerFields,
									correctedProvidedFields, ecFields, plateFilterFields, vesselFilterFields
								},

								(* Find all options which value are not Null, Automatic or {} *)
								providedOptions = Keys[Select[templatedOps, !MatchQ[Values[#], (NullP | {} | Automatic)]&]];

								(* Find all fields that belongs to any subtypes of Model[Container]: *)
								allPossibleContainerFields = Fields[Types[Model[Container]], Output -> Short];

								(* remove options that do not belong to any Model[Container] subtypes *)
								correctedProvidedFields = Intersection[providedOptions, allPossibleContainerFields];

								(* find all options that belongs to parent type Model[Container] *)
								containerFields = Fields[Model[Container], Output -> Short];
								(* find all options that belongs to Model[Container, Vessel] but not its parent type *)
								vesselFields = Fields[Model[Container, Vessel], Output -> Short];
								(* find all options that belongs to Model[Container, Plate] but not its parent type *)
								plateFields = Fields[Model[Container, Plate], Output -> Short];
								(* find all options that belongs to Model[Container, Plate, Filter] but not its parent type *)
								plateFilterFields = Fields[Model[Container, Plate, Filter], Output -> Short];
								(* find all options that belongs to Model[Container, Vessel, Filter] but not its parent type *)
								vesselFilterFields = Fields[Model[Container, Vessel, Filter], Output -> Short];

								(* Now check what options user has provided and resolve the Type *)
								Which[
									(* If user only provided options that exists as field in Model[Container], we can't tell what subtype it is. Remain as Model[Container] *)
									Length[Complement[correctedProvidedFields, containerFields]] == 0,
									Model[Container],
									(* If all options belongs to Model[Container, Vessel], set to Model[Container, Vessel] *)
									Length[Complement[correctedProvidedFields, vesselFields]] == 0,
									Model[Container, Vessel],
									(* If all options belongs to Model[Container, Plate], set to Model[Container, Plate] *)
									Length[Complement[correctedProvidedFields, plateFields]] == 0,
									Model[Container, Plate],
									(* Differentiating between Vessel Filter and Plate Filter can be a bit more tricky *)
									(* If user provided vessel-specific fields, and all fields exist in Model[Container, Vessel, Filter], use that *)
									Length[Intersection[correctedProvidedFields, Complement[vesselFields, containerFields]]] > 0 && Length[Complement[correctedProvidedFields, vesselFilterFields]] == 0,
									Model[Container, Vessel, Filter],
									(* If user provided plate-specific fields, and all fields exist in Model[Container, Plate, Filter], use that *)
									Length[Intersection[correctedProvidedFields, Complement[plateFields, containerFields]]] > 0 && Length[Complement[correctedProvidedFields, plateFilterFields]] == 0,
									Model[Container, Plate, Filter],
									(* If we still can't determine type at this point, give up and use Model[Container] *)
									True,
									Model[Container]
								]
							]
						],

					(* If we are not creating new model and the ContainerModel option is specified and a developer is running the function, try to use that *)
					!newModelQ && MatchQ[specifiedTypeChange, TypeP[]],
						specifiedTypeChange,

					(* All other cases don't do anything *)
					True,
						inputType
				];

				(* Read the Product-related options from previous step *)
				{resolvedProduct, resolvedProductURL, resolvedProductDocumentation} = Lookup[templatedOps, {Product, ProductURL, ProductDocumentation}];
				{resolvedProductDocumentationObject, resolvedProductObject} = Lookup[optionForPacket, {ProductDocumentation, Product}];

				(* --- check and resolve cleaning and re-use related options --- *)

				(* Read the relevant options. Note that Ampoule and CleaningMethod needs no resolution *)
				{resolvedAmpoule, unresolvedReusability, resolvedCleaningMethod, unresolvedPreferredWashBin} = Lookup[templatedOps, {Ampoule, Reusable, CleaningMethod, PreferredWashBin}, Null];


				(* Resolve Reusable *)
				resolvedReusability = Which[
					(* If specified, don't change *)
					!MatchQ[unresolvedReusability, Automatic],
						unresolvedReusability,
					(* If Ampoule -> True, set to False. This only applies to Model[Container] *)
					TrueQ[resolvedAmpoule],
						False,
					(* If CleaningMethod or PreferredWashbin set to Non-Null, set to True *)
					MatchQ[resolvedCleaningMethod, CleaningMethodP] || MatchQ[unresolvedPreferredWashBin, ObjectP[]],
						True,
					(* In other cases do not change *)
					True,
						unresolvedReusability
				];

				(* Resolve PreferredWashBin *)
				resolvedPreferredWashBin = Which[
					(* If Option is specified, keep it as is *)
					!MatchQ[unresolvedPreferredWashBin, Automatic],
						unresolvedPreferredWashBin,
					(* If Reusable != True, set to Null *)
					!TrueQ[resolvedReusability],
						Null,
					(* If the container is large (i.e., >20 cm diameter), set to Carboy dishwash bin *)
					MatchQ[Lookup[templatedOps, Dimensions], {GreaterP[20 Centimeter], GreaterP[20 Centimeter], _}],
						Model[Container, WashBin, "id:GmzlKjP4398N"], (* DishwashBin for Carboys *)
					(* Otherwise set to regular dishwash bin unless it's too big (branched above) *)
					True,
						Model[Container, WashBin, "id:mnk9jORX16EO"] (* DishwashBin for Sink *)
				];

				(* Resolve Name *)
				unresolvedName = Lookup[templatedOps, Name];

				(* First check if the user-supplied name is taken by other objects *)
				(* Construct the pseudo object with user-supplied name *)
				specifiedNamedObject = If[StringQ[unresolvedName],
					Join[resolvedInputType, Model[unresolvedName]],
					Null
				];

				(* If Name is not specified and we are creating a new model, try to construct one *)
				semiResolvedName = Which[
					(* Keep the user-supplied name if there's any. Also don't try to resolve any if we are changing existing model *)
					MatchQ[unresolvedName, _String] || (!newModelQ),
						unresolvedName,
					(* for container model, name would be MaxVolume_Material_Type(vessel/plate/cartridge/filter)_on_date *)
					MatchQ[myParentFunctionHead, UploadContainerModel],
						If[MatchQ[Lookup[templatedOps, MaxVolume], VolumeP] || MatchQ[Lookup[templatedOps, ContainerMaterials], {MaterialP..}],
							StringJoin[
								If[MatchQ[Lookup[templatedOps, MaxVolume], VolumeP],
									ToString[Unitless[Lookup[templatedOps, MaxVolume], Milliliter]]<>" mL ",
									""
								],
								If[MatchQ[Lookup[templatedOps, ContainerMaterials], {MaterialP..}],
									StringRiffle[(ToString /@ Lookup[templatedOps, ContainerMaterials]), " and "],
									""
								],
								" ",
								ToString[Last[resolvedInputType]],
								dateString
							],
							Null
						],
					(* For cover model, name would be CoverFootprint_Type(Cap/Lid/PlateSeal)_on_date *)
					MatchQ[myParentFunctionHead, UploadCoverModel],
						If[MatchQ[Lookup[templatedOps, CoverFootprint], CoverFootprintP],
							StringJoin[
								ToString[Lookup[templatedOps, CoverFootprint]],
								" ",
								ToString[Last[resolvedInputType]],
								dateString
							],
							Null
						]
				];

				(* At this point, we have resolved the name, but the auto-resolved name may have been occupied in database. *)
				(* It's undesired that we resolve a name automatically, but then throw an error saying this auto-resolved name can't be used *)
				(* Therefore, we try to modify the resolved name so that it's unique, by adding index *)
				(* e.g. say 50 mL Glass Vessel created on 01012025 is occupied, then change to 50 ml Glass Vessel 2 created on 01012025; and if 2 is also occupied change to 3, etc. *)
				resolvedName = resolveUniqueName[semiResolvedName, resolvedInputType, potentialOccupiedNamedObjects, dateString];

				(* Construct the pseudo object with user-supplied name *)
				automaticNamedObject = Join[resolvedInputType, Model[resolvedName]];

				(* Append the newly created object in the NamedObject form into potentialOccupiedNamedObjects *)
				(* So that in the next iteration, we have guarantee that we won't end up resolving the same name for different inputs *)
				If[MatchQ[resolvedName, _String],
					AppendTo[potentialOccupiedNamedObjects, automaticNamedObject]
				];

				(* Check and resolve Rows, Columns, NumberOfWells and AspectRatio options for UploadContainerModel *)
				(* For UploadCoverModel there's a similar set of options, except it's NumberOfRings, not NumberOfWells *)
				{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells, unresolvedAspectRatio} = If[MatchQ[myParentFunctionHead, UploadContainerModel],
					Lookup[templatedOps, #, Null]& /@ {Rows, Columns, NumberOfWells, AspectRatio},
					Lookup[templatedOps, #, Null]& /@ {Rows, Columns, NumberOfRings, AspectRatio}
				];

				(* Idea here is that if user specified 2 out of these 3, calculate the unspecified one *)
				(* if all are specified or more than 1 unspecified, don't try to resolve, keep them as they were *)
				{resolvedRows, resolvedColumns, resolvedNumberOfWells} = If[Count[{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells}, Automatic] == 1 && !MemberQ[{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells}, Null],
					Switch[{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells},
						{Automatic, _Integer, _Integer},
							{unresolvedNumberOfWells / unresolvedColumns, unresolvedColumns, unresolvedNumberOfWells},
						{_Integer, Automatic, _Integer},
							{unresolvedRows, unresolvedNumberOfWells / unresolvedRows, unresolvedNumberOfWells},
						{_Integer, _Integer, Automatic},
							{unresolvedRows, unresolvedColumns, unresolvedRows * unresolvedColumns},
						_,
							{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells}
					],
					{unresolvedRows, unresolvedColumns, unresolvedNumberOfWells}
				];

				(* Attempt to resolve AspectRatio if we know Rows and Columns *)
				resolvedAspectRatio = Which[
					(* If not Automatic, don't resolve *)
					!MatchQ[unresolvedAspectRatio, Automatic],
						unresolvedAspectRatio,
					(* Otherwise if we know Rows and Columns, use Columns/Rows *)
					MatchQ[{resolvedRows, resolvedColumns}, {_Integer, _Integer}],
						resolvedColumns / resolvedRows,
					(* All other cases set to Null *)
					True,
						Null
				];

				(* resolve ImageFile *)
				unresolvedImageFile = Lookup[templatedOps, ImageFile, Null];

				imageFilePath = Which[
					(* If user provided URL as documentation, try to download into $TemporaryDirectory *)
					MatchQ[unresolvedImageFile, URLP],
						downloadAndValidateURL[unresolvedImageFile, "image.jpg", ImageQ[Import[#]]&],
					(* If user provided local file path, use that *)
					MatchQ[unresolvedImageFile, FilePathP],
						unresolvedImageFile,
					(* Otherwise set to Null *)
					True,
						Null
				];

				(* Check if the provided image url is valid *)
				validImageFileURLQ = If[MatchQ[unresolvedImageFile, URLP],
					MatchQ[imageFilePath, (FilePathP | _File)],
					True
				];

				validImageFileDirectoryQ = If[MatchQ[imageFilePath, FilePathP],
					FileExistsQ[unresolvedImageFile],
					True
				];

				imageFileUploadPacket = If[MatchQ[unresolvedImageFile, _String] && validImageFileDirectoryQ && validImageFileURLQ,
					pathToCloudFilePacket[unresolvedImageFile],
					<||>
				];

				(* For ImageFile option, do not change what we supplied *)
				resolvedImageFile = unresolvedImageFile;

				(* In the upload packet however, use the cloud file object if we have one, otherwise set to Null *)
				resolvedImageFileObject = Which[
					(* If we uploaded a new file, use new file *)
					MatchQ[imageFileUploadPacket, PacketP[]],
						Lookup[imageFileUploadPacket, Object],
					(* If provided option is an Object, use that *)
					MatchQ[resolvedImageFile, ObjectP[Object[EmeraldCloudFile]]],
						resolvedImageFile,
					(* If option is not provided set to Null *)
					MatchQ[resolvedImageFile, Null],
						Null,
					(* All other cases set to Null *)
					True,
						Null
				];

				(* Resolve DefaultStickerModel. For Large enough containers auto set to Large, others Small *)
				(* Then convert Small/Large to corresponding sticker model *)
				dimensions = Lookup[templatedOps, Dimensions];

				unresolvedDefaultStickerModel = Lookup[templatedOps, DefaultStickerModel, Null];

				resolvedDefaultStickerModel = Switch[{unresolvedDefaultStickerModel, dimensions},
					(* For large containers (> 1.5 in height and >2*1.25 in length*width), set to large sticker model *)
					{Automatic, ({GreaterP[1.25 Inch], GreaterP[2 Inch], GreaterP[1.5 Inch]} | {GreaterP[2 Inch], GreaterP[1.25 Inch], GreaterP[1.5 Inch]})},
						Model[Item, Sticker, "id:WNa4ZjRDwv1V"],
					(* Everything else set to small sticker model *)
					{Automatic, _},
						Model[Item, Sticker, "id:mnk9jO3dexZY"],
					(* If already set, Convert Small/Large to model *)
					{_, _},
						Replace[unresolvedDefaultStickerModel,
							{
								Small -> Model[Item, Sticker, "id:mnk9jO3dexZY"],
								Large -> Model[Item, Sticker, "id:WNa4ZjRDwv1V"]
							}
						]
				];

				(* ------------------------------------------------------ *)
				(* ---- Compute Positions and PositionPlotting field ---- *)
				(* ------------------------------------------------------ *)

				{unresolvedPositions, unresolvedPositionPlotting} = Lookup[templatedOps, #, Null] &/@ {Positions, PositionPlotting};

				{attemptToResolvePositionsQ, compatiblePositionFieldsQ} = Which[
					(* first we want to check if the user-specified Positions and PositionPlotting field are compatible *)
					(* what we allow: both Null, both Automatic, or both specified. anything else is not allowed *)
					NullQ[unresolvedPositions] && NullQ[unresolvedPositionPlotting],
						{False, True},
					MatchQ[unresolvedPositions, ListableP[{_String, _, _Quantity, _Quantity, _Quantity}]] && MatchQ[unresolvedPositionPlotting, ListableP[{_String, _Quantity, _Quantity, _Quantity, _, _}]],
						{False, True},
					(* For covers: never try to resolve Positions or PositionPlotting. I know we have that defined for sparge caps *)
					(* But these would be very rare cases that I would argue we should just use raw upload to update that *)
					MatchQ[resolvedInputType, TypeP[{Model[Item, Cap], Model[Item, Lid], Model[Item, PlateSeal]}]],
						{False, True},
					(* If both are automatic, will need to resolve them. Set the attemptToResolvePositionsQ flag to True *)
					MatchQ[unresolvedPositions, Automatic] && MatchQ[unresolvedPositionPlotting, Automatic],
						{True, True},
					(* If the supplied option doesn't match one of the allowed combination, throw error *)
					True,
						{False, False}
				];

				(* now resolve Positions and PositionPlotting based on other options *)
				{resolvedPositions, resolvedPositionPlotting, missingPositionInfo} = If[attemptToResolvePositionsQ,
					If[MatchQ[resolvedInputType, TypeP[Model[Container, Plate]]],
						(* Go through the following code block for Plates *)
						Module[
							{
								wellDimensions, wellDiameter, wellDepth, wellPitchX, wellPitchY, wellOffsetX,
								wellOffsetY, wellOffsetZ, wellShape, correctedWellDimensions, missingInfoQs, missingInfoFields,
								fieldsAutogenerated, resolvedPositionsField, resolvedPositionPlottingField, finalResolvedPositions,
								finalResolvedPositionPlotting
							},
							(* First lookup parameters *)
							{wellDimensions, wellDiameter, wellDepth, wellPitchX, wellPitchY, wellOffsetX, wellOffsetY, wellOffsetZ, wellShape} = Lookup[templatedOps,
								{WellDimensions, WellDiameter, WellDepth, HorizontalPitch, VerticalPitch, HorizontalMargin, VerticalMargin, DepthMargin, CavityCrossSectionalShape}
							];

							(* If supplied WellDimensions is Null, use WellDiameter instead *)
							correctedWellDimensions = If[MemberQ[ToList[wellDimensions], (Null | Automatic)],
								{wellDiameter, wellDiameter},
								wellDimensions
							];

							(* Check if we have all necessary information to compute Positions and PositionPlotting field *)
							missingInfoQs = Or[
								MatchQ[#, (Null | Automatic)],
								MemberQ[ToList[#], (Null | Automatic)]
							]& /@ {
								dimensions, correctedWellDimensions, wellDepth, wellPitchX, wellPitchY, wellOffsetX, wellOffsetY, wellOffsetZ, wellShape, resolvedRows, resolvedColumns
							};

							missingInfoFields = PickList[
								{Dimensions, WellDimensions, WellDepth, HorizontalPitch, VerticalPitch, HorizontalMargin, VerticalMargin, DepthMargin, CavityCrossSectionalShape, Rows, Columns},
								missingInfoQs
							];

							(* If we don't have enough info to calculate the Positions and PositionPlotting field, return early *)
							If[MemberQ[missingInfoQs, True],
								Return[{Null, Null, missingInfoFields}, Module]
							];

							(* This function generates an association similar to upload packet which contains the Replace[Positions] and Replace[PositionPlotting] keys *)
							(* Essentially, it auto-calculates entries of Positions and PositionPlotting for rack or plate type of containers *)
							fieldsAutogenerated = Locations`Private`generateRegularRackPositions[
								resolvedRows,
								resolvedColumns,
								Sequence @@ dimensions,
								Sequence @@ correctedWellDimensions,
								wellDepth,
								wellPitchX,
								wellPitchY,
								wellOffsetX,
								wellOffsetY,
								wellOffsetZ,
								0 Meter,
								wellShape,
								Null
							];

							{resolvedPositionsField, resolvedPositionPlottingField} = Lookup[fieldsAutogenerated, #]& /@ {
								Replace[Positions], Replace[PositionPlotting]
							};

							(* A little bit annoying here that we can't just use the field value because we are resolving option *)
							(* and the option value format is indexed-multiple, instead of named-multiple. Need to correct that *)

							finalResolvedPositions = Lookup[#, {Name, Footprint, MaxWidth, MaxDepth, MaxHeight}]& /@ resolvedPositionsField;
							finalResolvedPositionPlotting = Lookup[#, {Name, XOffset, YOffset, ZOffset, CrossSectionalShape, Rotation}]& /@ resolvedPositionPlottingField;

							(* output final result *)
							{finalResolvedPositions, finalResolvedPositionPlotting, missingInfoFields}
							
						],
						(* Everything else go through a different code block *)
						Module[
							{
								internalDimensions, internalDiameter, internalDepth, wellOffsetZ, wellShape,
								correctedInternalDimensions, missingInfoQs, missingInfoFields, finalResolvedPositions,
								finalResolvedPositionPlotting
							},
							(* First lookup parameters *)
							{internalDimensions, internalDiameter, internalDepth, wellOffsetZ, wellShape} = Lookup[templatedOps,
								{Dimensions, InternalDimensions, InternalDiameter, InternalDepth, DepthMargin, CavityCrossSectionalShape}
							];

							(* If supplied InternalDimensions is Null, use InternalDiameter instead *)
							correctedInternalDimensions = If[MemberQ[ToList[internalDimensions], Null],
								{internalDiameter, internalDiameter},
								internalDimensions
							];

							(* Check if we have all necessary information to compute Positions and PositionPlotting field *)
							missingInfoQs = Or[
								NullQ[#],
								MemberQ[ToList[#], Null]
							]& /@ {
								dimensions, correctedInternalDimensions, internalDepth, wellOffsetZ, wellShape
							};

							missingInfoFields = PickList[
								{Dimensions, InternalDimensions, InternalDepth, DepthMargin, CavityCrossSectionalShape},
								missingInfoQs,
								True
							];

							(* If we don't have enough info to calculate the Positions and PositionPlotting field, return early *)
							If[MemberQ[missingInfoQs, True],
								Return[{Null, Null, missingInfoFields}, Module]
							];

							finalResolvedPositions = {
								"A1",
								Null,
								correctedInternalDimensions[[1]],
								correctedInternalDimensions[[2]],
								internalDepth
							};

							finalResolvedPositionPlotting = {
								"A1",
								dimensions[[1]] / 2,
								dimensions[[2]] / 2,
								wellOffsetZ,
								wellShape,
								0
							};

							(* output final result *)
							{finalResolvedPositions, finalResolvedPositionPlotting, missingInfoFields}

						]
					],
					{unresolvedPositions, unresolvedPositionPlotting, {}}
				];

				(* Round all the Offset and length values in Positions and PositionPlotting options to 0.1 mm *)
				roundedPositions = ReplaceAll[resolvedPositions, x:DistanceP :> RoundOptionPrecision[x, 0.01 Millimeter]];
				roundedPositionPlotting = ReplaceAll[resolvedPositionPlotting, x:DistanceP :> RoundOptionPrecision[x, 0.01 Millimeter]];

				(* Resolve ExposedSurfaces: default to False for new objects *)
				unresolvedExposedSurfaces = Lookup[templatedOps, ExposedSurfaces, Automatic];

				resolvedExposedSurfaces = If[MatchQ[unresolvedExposedSurfaces, Automatic],
					False,
					unresolvedExposedSurfaces
				];

				(* Resolve DefaultStorageCondition: conditional on ExposedSurfaces *)
				unresolvedDefaultStorageCondition = Lookup[templatedOps, DefaultStorageCondition];

				resolvedDefaultStorageCondition = If[!MatchQ[unresolvedDefaultStorageCondition, Automatic],
					(* If the user specified a value, use it (convert symbols to objects if needed) *)
					Replace[unresolvedDefaultStorageCondition, nonSampleStorageConditionLookup["memoization"]],

					(* Otherwise, resolve based on ExposedSurfaces *)
					If[TrueQ[resolvedExposedSurfaces],
						Model[StorageCondition, "Ambient Storage, Lined Enclosed"],
						Model[StorageCondition, "Ambient Storage"]
					]
				];

				(* Resolve RNAseFree and PyrogenFree: default to False  *)
				{unresolvedRNAseFree, unresolvedPyrogenFree} = Lookup[templatedOps, {RNaseFree, PyrogenFree}, Null];

				resolvedRNAseFree = If[MatchQ[unresolvedRNAseFree, Automatic] && MatchQ[myParentFunctionHead, UploadContainerModel],
					(* Default RNAseFree to False for container model *)
					False,
					(* Do not change for CoverModel. RNAseFree is not an option for UploadCoverModel so this has to be Null, otherwise it will trigger Error::RedundantOption *)
					unresolvedRNAseFree
				];
				resolvedPyrogenFree = If[MatchQ[unresolvedPyrogenFree, Automatic],
					False,
					unresolvedPyrogenFree
				];

				(* ---Resolve Material-dependent properties--- *)

				(* Read the material and find the temperature limit corresponding to that material *)
				material = If[MatchQ[myParentFunctionHead, UploadContainerModel],
					Lookup[templatedOps, ContainerMaterials] /. {Automatic -> {}},
					Lookup[templatedOps, WettedMaterials] /. {Automatic -> Null}
				];

				(* First read the current MinTemperature and MaxTemperature option *)
				{unresolvedMinTemperature, unresolvedMaxTemperature} = Lookup[templatedOps, {MinTemperature, MaxTemperature}];

				(* Find Temperature limits from material *)
				temperatureLimitFromMaterial = resolveMaterialTemperatureLimits[material];

				(* resolve option *)
				resolvedMinTemperature = If[MatchQ[unresolvedMinTemperature, Automatic],
					First[temperatureLimitFromMaterial],
					unresolvedMinTemperature
				];

				resolvedMaxTemperature = If[MatchQ[unresolvedMaxTemperature, Automatic],
					Last[temperatureLimitFromMaterial],
					unresolvedMaxTemperature
				];

				(* read the Fragile option *)
				unresolvedFragile = Lookup[templatedOps, Fragile];

				(* resolve the option *)
				resolvedFragile = If[MatchQ[unresolvedFragile, Automatic],
					fragileMaterialQ[material],
					unresolvedFragile
				];

				(* ---------------------------------------------------- *)
				(* ---- Construct a rough change packet for upload ---- *)
				(* ---------------------------------------------------- *)

				(* Find previous authors to decide if we want to Append $PersonID into the Authors field *)
				previousAuthors = If[newModelQ,
					{},
					Download[Lookup[initialPacket, Authors], Object]
				];
				(* Construct option rule for this input that will be uploaded to object *)
				resolvedOptionToConstructPacket = ReplaceRule[
					(* Remove the Product and ProductDocumentation from old options. This is because in the packet the field name needs to be Products and ProductDocumentationFiles instead *)
					DeleteCases[Normal[templatedOps, Association],
						Alternatives[
							Product -> _,
							ProductDocumentation -> _
						]
					],
					{
						Products -> If[NullQ[resolvedProductObject], Automatic, resolvedProductObject],
						ProductDocumentationFiles -> If[NullQ[resolvedProductDocumentationObject], Automatic, resolvedProductDocumentationObject],
						Reusable -> resolvedReusability,
						Name -> resolvedName,
						Rows -> resolvedRows,
						Columns -> resolvedColumns,
						If[MatchQ[myParentFunctionHead, UploadContainerModel],
							NumberOfWells -> resolvedNumberOfWells,
							NumberOfRings -> resolvedNumberOfWells
						],
						AspectRatio -> resolvedAspectRatio,
						Synonyms -> {resolvedName},
						Authors -> If[MemberQ[previousAuthors, Download[$PersonID, Object]],
							Automatic,
							Link[$PersonID]
						],
						ImageFile -> resolvedImageFileObject,
						Positions -> roundedPositions,
						PositionPlotting -> roundedPositionPlotting,
						DefaultStorageCondition -> resolvedDefaultStorageCondition,
						ExposedSurfaces -> resolvedExposedSurfaces,
						DefaultStickerModel -> resolvedDefaultStickerModel,
						PreferredWashBin -> resolvedPreferredWashBin,
						If[MatchQ[myParentFunctionHead, UploadContainerModel],
							RNaseFree -> resolvedRNAseFree,
							Nothing
						],
						PyrogenFree -> resolvedPyrogenFree,
						MinTemperature -> resolvedMinTemperature,
						MaxTemperature -> resolvedMaxTemperature,
						Fragile -> resolvedFragile,
						(* This will effectively remove the following fields from the packet in later steps *)
						StandaloneCoverProduct -> Automatic,
						CavityCrossSectionalShape -> Automatic
					}
				];

				(* Construct the option rules for Option output. It's slightly different than the change packet *)
				resolvedOptionForOptionOutput = DeleteCases[
					ReplaceRule[
						Normal[templatedOps, Association],
						{
							Reusable -> resolvedReusability,
							Name -> resolvedName,
							Rows -> resolvedRows,
							Columns -> resolvedColumns,
							If[MatchQ[myParentFunctionHead, UploadContainerModel],
								NumberOfWells -> resolvedNumberOfWells,
								NumberOfRings -> resolvedNumberOfWells
							],
							AspectRatio -> resolvedAspectRatio,
							ImageFile -> resolvedImageFile,
							Positions -> roundedPositions,
							PositionPlotting -> roundedPositionPlotting,
							DefaultStorageCondition -> resolvedDefaultStorageCondition,
							ExposedSurfaces -> resolvedExposedSurfaces,
							DefaultStickerModel -> resolvedDefaultStickerModel,
							PreferredWashBin -> resolvedPreferredWashBin,
							If[MatchQ[myParentFunctionHead, UploadContainerModel],
								RNaseFree -> resolvedRNAseFree,
								Nothing
							],
							PyrogenFree -> resolvedPyrogenFree,
							MinTemperature -> resolvedMinTemperature,
							MaxTemperature -> resolvedMaxTemperature,
							Fragile -> resolvedFragile
						}
					],
					ProductInformation -> _
				];

				(* When creating new model, change all remaining Automatic to Null *)
				finalResolvedOptions = If[newModelQ,
					Replace[resolvedOptionForOptionOutput, Automatic -> Null, 2],
					resolvedOptionForOptionOutput
				];

				(* Construct the packet using helper. What the helper does: remove fields that are Null, add correct Replace[] or Append[] head for multiple fields, and find whether there are any irrelevant options *)
				{allPackets, nonNullIrrelevantFields} = generateChangePackets[resolvedInputType,
					resolvedOptionToConstructPacket,
					Append -> {Author, Products, ProductDocumentationFiles, ProductURL},
					Output -> {Packet, IrrelevantFields},
					ExistingPacket -> initialPacket
				];

				(* Separate the main and auxillary packets from the results *)
				mainChangePacket = First[allPackets];
				auxillaryPackets = Rest[allPackets];

				(* Find the Object of the input. If our input is a type, call CreateID to generate one *)
				inputObject = If[newModelQ,
					CreateID[resolvedInputType],
					input
				];

				(* Add the Object and Type key *)
				preliminaryChangePacket = Join[
					<|
						Object -> inputObject,
						Type -> resolvedInputType
					|>,
					mainChangePacket
				];

				accessoryPackets = Cases[Flatten[{documentationUploadPacket, imageFileUploadPacket}], PacketP[]];

				(* ------------------------------------------------- *)
				(* ---additional error checking with ValidObjectQ--- *)
				(* ------------------------------------------------- *)

				(* Here we will use ValidObjectQMessages to check if the resulted packet passes VOQ tests *)
				(* However, under certain scenarios we bypass this check. The general idea is external user can make invalid objects, which will be inspected and fixed later by developers *)
				(* When external user create new models: VOQ can be bypassed if product information is provided for the model, so developer can fill in other necessary fields from that info *)
				(* When external user modify existing model: if the model hasn't been verified by developer, user can modify at will. However if the model has already been approved, then the model can't be modified in any way such that VOQ would fail *)
				{voqPassedQ, voqTests, voqMessages, voqFailedTestDescriptions, voqFailingOptions} = If[!resolvedStrict && TrueQ[$AllowUserInvalidObjectUploads] && (!alreadyVerified),
					{False, False, {}, {}, {}},
					Module[
						{
							updatedSimulation, finalizedPacketForVOQ, failedTestDescriptions,
							passed, failingOptions, tests, passedWithoutParamterization,
							failedTestDescriptionsWithoutParameterization, testsWithoutParameterization,
							allowPendingParameterization, changePacketsAssumingNoParameterization,
							changePacketsAssumingNeedParameterization, messagesWithoutParameterization,
							failingOptionsWithoutParameterization, correctedTemplateOptions, messages
						},

						(* need to add Notebook to the finalized packets because otherwise we'll get weird errors about $Notebook missing *)
						(* although only append $Notebook when it is actually an object, otherwise just let raw Upload handles it *)
						changePacketsAssumingNoParameterization = If[MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
							Join[preliminaryChangePacket,
								<|
									Notebook->Link[$Notebook],
									PendingParameterization -> False
								|>
							],
							Append[
								preliminaryChangePacket,
								PendingParameterization -> False
							]
						];
						changePacketsAssumingNeedParameterization = If[MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
							Join[preliminaryChangePacket,
								<|
									Notebook->Link[$Notebook],
									PendingParameterization -> True
								|>
							],
							Append[
								preliminaryChangePacket,
								PendingParameterization -> True
							]
						];

						(* Note that when we modify existing models, we applyed the model as Template to resolve the option *)
						(* we should not include the templated option for RunOptionValidationTests function in this case *)
						correctedTemplateOptions = If[newModelQ,
							Normal[templatedOps, Association],
							{}
						];

						(* Decide if we can still allow a second VOQ test on the packet assuming PendingParameterization -> True *)
						(* If 1) we are working on an existing container and 2) it's already Verified -> True and PendingParameterization -> False, i.e., ready to use in lab *)
						(* we shouldn't allow anyone's change to make the container invalid and have to be parameterized again. If a parameterization is indeed necessary they should just call MaintenanceParameterizeContainer directly *)
						allowPendingParameterization = !MatchQ[Lookup[initialPacket, {Verified, PendingParameterization}, Null], {True, False}];

						(* Now decide if the packet passes VOQ: *)
						{passed, failedTestDescriptions, tests, messages, failingOptions} = RunOptionValidationTests[
							If[allowPendingParameterization,
								changePacketsAssumingNeedParameterization,
								changePacketsAssumingNoParameterization
							],
							ClearMemoization -> False,
							Message -> False,
							UnresolvedOptions -> correctedUnresolvedOps,
							TemplateOptions -> correctedTemplateOptions,
							Cache -> Flatten[{accessoryPackets, Values[updatedFastAssoc]}],
							Output -> {Result, FailedTestDescriptions, Tests, Messages, InvalidOptions},
							InvalidOptionsDetermination -> MessageArguments,
							ParentFunction -> myParentFunctionHead
						];


						{passed, tests, messages, failedTestDescriptions, failingOptions}

					]
				];

				(* TODO modify accordingly later *)
				completeProductOptionQ = True;

				(* If we do not have any product information, we want to ensure we have minimal information *)
				missingRequiredOptions = If[newModelQ && MatchQ[Lookup[templatedOps, ProductInformation], Null],
					PickList[requiredOptions, Lookup[finalResolvedOptions, requiredOptions], (Null | {} | Automatic)],
					{}
				];

				(* ---- Construct the output ---- *)
				{
					(*1*)preliminaryChangePacket,
					resolvedProduct,
					resolvedProductURL,
					resolvedProductDocumentation,
					(*5*)resolvedName,
					completeProductOptionQ,
					accessoryPackets,
					(*10*)inputObject,
					validImageFileDirectoryQ,
					resolvedImageFile,
					DeleteCases[nonNullIrrelevantFields, ProductInformation],
					roundedPositions,
					(*15*)roundedPositionPlotting,
					missingPositionInfo,
					compatiblePositionFieldsQ,
					productOptionFulfilledQ,
					voqFailedTestDescriptions,
					(*20*)validImageFileURLQ,
					templateOnNewModelQ,
					correctTemplateTypeQ,
					finalResolvedOptions,
					voqMessages,
					(*25*)voqFailingOptions,
					missingRequiredOptions
				}

			]
		],
		{correctedInputs, preResolvedOptions, mapThreadFriendlyUserOptions, preResolvedOptionsForPackets}
	]];

	resolvedOptions = ReplaceRule[
		myOptions,
		mergeMapThreadFriendlyOptions[expandedResolvedOptions, myParentFunctionHead, "inputs"]
	];

	(* Do some final rounding *)
	{finalRoundedOptions, optionPrecisionTests} = Switch[{gatherTest, myParentFunctionHead},
		{True, UploadContainerModel},
			RoundOptionPrecision[
				Association@resolvedOptions,
				{
					Dimensions,
					CartridgeLength,
					InternalConicalDepth,
					InternalDepth,
					Aperture,
					InternalDiameter,
					InternalDimensions,
					WellDiameter,
					WellDepth,
					WellDimensions,
					ConicalWellDepth,
					HorizontalMargin,
					VerticalMargin,
					DepthMargin,
					HorizontalPitch,
					VerticalPitch,
					HorizontalOffset,
					VerticalOffset
				},
				{
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter,
					0.01 Millimeter
				},
				Output -> {Result, Tests},
				Messages -> False
			],

			{False, UploadContainerModel},
			{
				RoundOptionPrecision[
					Association@resolvedOptions,
					{
						Dimensions,
						CartridgeLength,
						InternalConicalDepth,
						InternalDepth,
						Aperture,
						InternalDiameter,
						InternalDimensions,
						WellDiameter,
						WellDepth,
						WellDimensions,
						ConicalWellDepth,
						HorizontalMargin,
						VerticalMargin,
						DepthMargin,
						HorizontalPitch,
						VerticalPitch,
						HorizontalOffset,
						VerticalOffset
					},
					{
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter,
						0.01 Millimeter
					},
					Messages -> False
				],
				{}
			},

		{_, _},
			{resolvedOptions, {}}
	];

	(* ---------------------- *)
	(* ----Error checking---- *)
	(* ---------------------- *)

	(* Throw messages from RunOptionValidationTests here *)
	(* Split the hold form of the message into message name and arguments. e.g. Hold[Error::RequiredOptions, 1, 2, 3] -> {Hold[Error::RequiredOptions], {1, 2, 3}} *)
	splittedMessages = Replace[Flatten[allVOQFailureMessages], HoldPattern[Hold[x_, y___]] :> {Hold[x], {y}}, 1];
	(* group the error message by the message name *)
	groupedMessages = GroupBy[splittedMessages, First];
	(* Merge the messages with the same message name, and combine all arguements at the same position *)
	mergedMessage = KeyValueMap[
		Function[{messageName, allMessages},
			Join[
				messageName,
				Hold @@ (DeleteDuplicates /@ Transpose[allMessages[[All, 2]]])
			]
		],
		groupedMessages
	];
	(* Throw all messages *)
	Message @@@ mergedMessage;

	(* For any unparsed error, throw here *)
	If[Length[Flatten[allFailedVOQTestDescriptions]] > 0 && messageQ,
		Message[Error::ValidObjectQFailing, StringRiffle[StringReplace[Flatten[allFailedVOQTestDescriptions], ":" -> ""], {"\"", "\", \"", "\""}], errorTypeString]
	];

	(* Check RequiredOption error *)
	missingRequiredOptionsNoDup = DeleteDuplicates[Flatten[allMissingRequiredOptions]];

	missingRequiredOptions = If[Length[missingRequiredOptionsNoDup] > 0,
		Message[Error::RequiredOptionsForNoProduct, missingRequiredOptionsNoDup, "container"];
		missingRequiredOptionsNoDup,
		{}
	];

	(* Check Template-related error *)
	invalidTemplateOptions = If[MemberQ[allTemplateOnNewModelQs, False] && messageQ,
		Message[Error::CannotSpecifyTemplate, PickList[myInput, allTemplateOnNewModelQs, False]];
		{Template},
		{}
	];

	invalidTemplateTests = If[gatherTest,
		Test["Template option is only specified for Type input, not model input:",
			And @@ allTemplateOnNewModelQs,
			True
		],
		{}
	];

	mismatchTemplateTypeOptions = If[MemberQ[allCorrectTemplateTypeQs, False] && messageQ,
		Message[Error::MismatchTemplateType, PickList[Lookup[myOptions, Template], allCorrectTemplateTypeQs, False], PickList[myInput, allCorrectTemplateTypeQs, False]];
		{Template},
		{}
	];

	mismatchTemplateTypeTests = If[gatherTest,
		MapThread[
			Test["If Template is specified, its type matches input "<>ToString[#2]<>" :",
				#1,
				True
			]&,
			{allCorrectTemplateTypeQs, myInput}
		],
		{}
	];

	(* Have we specified Product-related options *)
	incompleteProductOptions = If[MemberQ[completeProductOptionQs, False] && messageQ,
		Message[Error::MissingProductInformation, If[resolvedStrict, {Product, ProductDocumentation}, {Product, ProductDocumentation, ProductURL}], PickList[myInput, completeProductOptionQs, False], errorTypeString];
		If[resolvedStrict, {Product, ProductDocumentation}, {Product, ProductDocumentation, ProductURL}],
		{}
	];

	incompleteProductTests = If[gatherTest,
		MapThread[
			Test["At least one of the necessary Product-related options are specified for input "<>ToString[#2]<>" :",
				#1,
				True
			]&,
			{completeProductOptionQs, myInput}
		],
		{}
	];

	productOptionUnfulfilledOptions = If[MemberQ[productOptionFulfilledQs, False] && messageQ,
		Message[Error::MoreOptionsNeeded];
		{Stocked},
		{}
	];

	productOptionFulfilledTests = If[gatherTest,
		MapThread[
			Test["When creating a new "<>ToString[#2]<>" if the Stocked option is set to False, sufficient other options must be provided so that the resulted new model passes ValidObjectQ:",
				#1,
				True
			]&,
			{validProductDocumentationURLQs, myInput}
		],
		{}
	];

	invalidProductDocumentationURLOptions = If[MemberQ[validProductDocumentationURLQs, False] && messageQ,
		Message[Error::InvalidProductDocumentationURL, PickList[productDocumentation, validProductDocumentationURLQs, False]];
		{ProductDocumentation},
		{}
	];

	invalidProductDocumentationURLTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" if a URL is provided as ProductDocumentation option, it points to a pdf file that can be downloaded:",
				#1,
				True
			]&,
			{validProductDocumentationURLQs, myInput}
		],
		{}
	];

	invalidProductDocumentationDirectoryOptions = If[MemberQ[validProductDocumentationDirectoryQs, False] && messageQ,
		Message[Error::InvalidFileDirectory, PickList[productDocumentation, validProductDocumentationDirectoryQs, False], "ProductDocumentation"];
		{ProductDocumentation},
		{}
	];

	invalidProductDocumentationDirectoryTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" if a file directory on PC is provided as ProductDocumentation option, that file must exist:",
				#1,
				True
			]&,
			{validProductDocumentationDirectoryQs, myInput}
		],
		{}
	];

	(* Do not throw warning in engine because engine process will suspend when any kind of messages is thrown *)
	(* Function should still work and still upload if this is the only error message *)
	If[MemberQ[productDocumentationURLTransferredQs, True] && messageQ && MatchQ[$ECLApplication, Except[Engine]],
		Message[Warning::InvalidProductDocumentationURL, PickList[productURL, validProductDocumentationDirectoryQs, True]]
	];

	productDocumentationURLTransferredWarnings = If[gatherTest,
		MapThread[
			Warning["For input "<>ToString[#2]<>" if a URL is provided as ProductDocumentation option, it points to a pdf file that can be downloaded:",
				#1,
				False
			]&,
			{productDocumentationURLTransferredQs, myInput}
		],
		{}
	];

	invalidImageFileDirectoryOptions = If[MemberQ[validImageFileDirectoryQs, False] && messageQ,
		Message[Error::InvalidFileDirectory, PickList[imageFile, validImageFileDirectoryQs, False], "ImageFile"];
		{ImageFile},
		{}
	];

	invalidImageFileDirectoryTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" if a file directory on PC is provided as ImageFile option, that file must exist:",
				#1,
				True
			]&,
			{validImageFileDirectoryQs, myInput}
		],
		{}
	];

	invalidImageFileURLOptions = If[MemberQ[validImageFileURLQs, False] && messageQ,
		Message[Error::InvalidFileURL, PickList[imageFile, validImageFileURLQs, False], "ImageFile"];
		{ImageFile},
		{}
	];

	invalidImageFileURLTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" if a URL is provided as ImageFile option, it must point to a downloadable image:",
				#1,
				True
			]&,
			{validImageFileURLQs, myInput}
		],
		{}
	];

	irrelevantFieldOptions = If[Length[Flatten[allIrrelevantFields]] > 0 && messageQ,
		Message[Error::RedundantOptions, PickList[myInput, allIrrelevantFields, Except[{}]], DeleteCases[allIrrelevantFields, {}]];
		DeleteDuplicates[Flatten[allIrrelevantFields]],
		{}
	];

	irrelevantFieldTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" only options that are relevant to its Type are specified:",
				#1,
				{}
			]&,
			{allIrrelevantFields, myInput}
		],
		{}
	];

	incompatiblePositionFieldOptions = If[MemberQ[compatiblePositionFieldsQs, False] && messageQ,
		Message[Error::ConflictingPositionOptions, PickList[myInput, compatiblePositionFieldsQs, False], PickList[positions, compatiblePositionFieldsQs, False], PickList[positionPlotting, compatiblePositionFieldsQs, False]];
		{Positions, PositionPlotting},
		{}
	];

	incompatiblePositionFieldTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" the Positions and PositionPlotting options are either both set to Null, or both set to Automatic, or both manually specified:"],
			#1,
			True
		]&,
		{compatiblePositionFieldsQs, myInput}
	];

	missingPositoinInfoFieldsOptions = If[Length[Flatten[allMissingPositionInfoFields]] > 0 && messageQ,
		Message[Error::UnableToCalculatePositions, PickList[myInput, allMissingPositionInfoFields, Except[{}]], DeleteCases[allMissingPositionInfoFields, {}]];
		Join[DeleteDuplicates[Flatten[allMissingPositionInfoFields]], {Positions, PositionPlotting}],
		{}
	];

	missingPositionInfoFieldsTests = If[gatherTest,
		MapThread[
			Test["For input "<>ToString[#2]<>" if Positions and PositionPlotting options are set to Automatic, all other relevant options must also be set to allow calculation of these two options:",
				#1,
				{}
			]&,
			{allMissingPositionInfoFields, myInput}
		],
		{}
	];

	invalidOptions = DeleteDuplicates[
		Flatten[{
			incompleteProductOptions,
			invalidProductDocumentationURLOptions,
			invalidProductDocumentationDirectoryOptions,
			invalidImageFileDirectoryOptions,
			irrelevantFieldOptions,
			incompatiblePositionFieldOptions,
			missingPositoinInfoFieldsOptions,
			productOptionUnfulfilledOptions,
			invalidTemplateOptions,
			mismatchTemplateTypeOptions,
			voqInvalidOptions,
			missingRequiredOptions,
			nameDuplicationOptions
		}]
	];

	invalidInputs = DeleteDuplicates[
		Flatten[{
			productDuplicationInputs
		}]
	];

	allTests = Cases[
		Flatten[{
			incompleteProductTests,
			invalidProductDocumentationURLTests,
			invalidProductDocumentationDirectoryTests,
			invalidImageFileDirectoryTests,
			irrelevantFieldTests,
			incompatiblePositionFieldTests,
			missingPositionInfoFieldsTests,
			productDocumentationURLTransferredWarnings,
			productOptionFulfilledTests,
			invalidTemplateTests,
			mismatchTemplateTypeTests,
			voqTests
		}],
		TestP
	];

	(* Here, exclude packets that triggered the "Public ProductInformation" warning, i.e., prevent change to existing public models *)
	changePacketsToUpload = If[Length[inputsToNotUpload] > 0,
		DeleteCases[changePackets, Alternatives @@ PacketP /@ inputsToNotUpload],
		changePackets
	];

	allPackets = Cases[
		Flatten[{
			changePacketsToUpload,
			productAccessoryPackets,
			allAccessoryPackets
		}],
		PacketP[]
	];

	If[messageQ && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	If[messageQ && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, invalidInputs]
	];

	{Normal[finalRoundedOptions, Association], allPackets, containerModels, allTests, PickList[correctedInputs, reasonForInputChange, Except["Public ProductInformation"]]}

];

(* ::Subsection::Closed:: *)
(*helper*)

(* ::Subsubsection::Closed:: *)
(*nonSampleStorageConditionLookup*)
(* memoized function to compute and store a lookup table for SampleStorageTypeP -> Model[StorageCondition] *)
nonSampleStorageConditionLookup[labelString_String] := nonSampleStorageConditionLookup[labelString] = Module[{allSCObjects, allSCSymbols},
	If[!MemberQ[$Memoization, ExternalUpload`Private`nonSampleStorageConditionLookup],
		AppendTo[$Memoization, ExternalUpload`Private`nonSampleStorageConditionLookup]
	];
	allSCObjects = Search[Model[StorageCondition], Flammable == Null && Acid == Null && Base == Null && Pyrophoric == Null && AtmosphericCondition == Null && Desiccated == Null];
	allSCSymbols = Download[allSCObjects, StorageCondition];
	MapThread[#1 -> #2&, {allSCSymbols, allSCObjects}]
];

(* ::Subsubsection::Closed:: *)
(*materialInformation*)
(* memoized function to store a quick lookup information for all Materials *)
materialInformation[labelString_String] := materialInformation[labelString] = Module[{allMaterialObjects},
	If[!MemberQ[$Memoization, ExternalUpload`Private`materialInformation],
		AppendTo[$Memoization, ExternalUpload`Private`materialInformation]
	];
	allMaterialObjects = Search[Model[Physics, Material]];
	Download[allMaterialObjects, Packet[Material, MinTemperature, MaxTemperature, Fragile]]
];

(* ::Subsubsection::Closed:: *)
(*resolveMaterialTemperatureLimits*)
(* resolve the MinTemperature and MaxTemperature given a Material or a list of materials *)

(* Single Null overload: set to {Null, Null} *)
resolveMaterialTemperatureLimits[Null] := {Null, Null};

(* Single Material overload: Simply read the MinTemperature and MaxTemperature of corresponding Model[Physics, Material] *)
resolveMaterialTemperatureLimits[myMaterial:MaterialP] := Module[
	{allMaterialInfo, myMaterialPacket},

	allMaterialInfo = materialInformation["Memoization"];

	myMaterialPacket = FirstCase[allMaterialInfo, KeyValuePattern[Material -> myMaterial], <||>];

	Lookup[myMaterialPacket, {MinTemperature, MaxTemperature}, Null]
];

(* Empty list overload: set to {Null, Null} *)
resolveMaterialTemperatureLimits[{}] := {Null, Null};

(* List of materials overload. Find Min and Max Temperature of all materials, then choose the highest MinTemperature and lowest MaxTemperature as output. i.e., use a conservative value if the container is made of multiple materials *)
(* Note: the list overload is meant to find Min and MaxTemperature of a SINGLE item that's made of MULTIPLE materials *)
(* NOT to find a list of Min and MaxTemperature of a list of items. i.e., this function is not listable in the regular way *)
resolveMaterialTemperatureLimits[myMaterials:{(MaterialP | Null)..}] := Module[
	{allTemperatureLimits, allMaxTemperatures, allMinTemperatures, resolvedMinTemp, resolvedMaxTemp},

	allTemperatureLimits = Transpose[resolveMaterialTemperatureLimits /@ myMaterials];

	allMinTemperatures = DeleteCases[First[allTemperatureLimits], Null];

	resolvedMinTemp = If[Length[allMinTemperatures] > 0,
		Max[allMinTemperatures],
		Null
	];

	allMaxTemperatures = DeleteCases[Last[allTemperatureLimits], Null];

	resolvedMaxTemp = If[Length[allMaxTemperatures] > 0,
		Min[allMaxTemperatures],
		Null
	];

	(* If MinTemperature > MaxTemperature, output {Null, Null} instead *)
	If[TrueQ[resolvedMinTemp > resolvedMaxTemp],
		{Null, Null},
		{resolvedMinTemp, resolvedMaxTemp}
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveMaterialTemperatureLimits*)

(* Null overload: set to Null *)
fragileMaterialQ[Null] := Null;
(* Empty list overload: set to Null *)
fragileMaterialQ[{}] := Null;

(* Single Material overload: simply read the Fragile field from corresponding Model[Physics, Material] *)
fragileMaterialQ[myMaterial:MaterialP] := Module[
	{allMaterialInfo, myMaterialPacket},

	allMaterialInfo = materialInformation["Memoization"];

	myMaterialPacket = FirstCase[allMaterialInfo, KeyValuePattern[Material -> myMaterial], <||>];

	Lookup[myMaterialPacket, Fragile, Null]
];

(* List of Materials overload: Find if any material is fragile, if yes set to True, if no set to False *)
(* Note: This function is meant to find if a SINGLE item made of MULTIPLE materials is fragile or not *)
(* NOT to output a list of boolean to indicate if a list of items are fragile or not *)
fragileMaterialQ[myMaterials:{(MaterialP | Null)..}] := Module[
	{allFragileQs},

	allFragileQs = fragileMaterialQ /@ myMaterials;

	Which[
		(* If contain any fragile material, set to True *)
		MemberQ[allFragileQs, True], True,
		(* If no Fragile -> True material and contains Fragile -> False material, set to False *)
		MemberQ[allFragileQs, False], False,
		(* All other cases set to Null (unknown) *)
		True, Null
	]
];

(* ::Subsubsection::Closed:: *)
(*resolveUniqueName*)

(* This helper takes a potential name, check if there's duplicate, and modify the name until there's no more duplicate *)
(* It employs a recursive function, which would become slow if there are a lot of duplicates, but we anticipate this to be extremely rare *)
(* This is because for containers we construct the name based on material, max volume and date; unless the user batch create thousands of container models with the same material, same max volume on the same day, we should be fine *)
(* a quick performance test shows the time of execution for this function scales linearly with number of myExistingNamedObjects (O(n)), and when n=100 it takes 3-6 ms *)

resolveUniqueName[myTempName_, myType:TypeP[], myExistingNamedObjects:{ObjectP[]...}, myNameSuffix_String] := Module[
	(* This "myNameSuffix" input is a piece of string that should always exist in the end of all auto-resolved names *)
	{
		existingObjectTypes, existingObjectsOfSameType, existingObjectNames
	},

	(* Check if we can/need to modify the input name *)
	If[
		Or[
			(* Don't change if the Name is not even a string *)
			!MatchQ[myTempName, _String],
			(* Don't change if there's no existing objects*)
			Length[myExistingNamedObjects] == 0,
			(* Don't change if the input name does not end with desired suffix *)
			!StringMatchQ[myTempName, ___ ~~ myNameSuffix ~~ EndOfString]
		],
		Return[myTempName]
	];

	(* Filter the myExistingNamedObjects list; find objects that are the same type as myType *)
	existingObjectTypes = Most /@ myExistingNamedObjects;
	existingObjectsOfSameType = PickList[myExistingNamedObjects, existingObjectTypes, myType];

	(* If there's no existing object that is of the input type, return early without changing the input name *)
	If[Length[existingObjectsOfSameType] == 0,
		Return[myTempName]
	];

	(* Find the name of the existing objects that are the same type as input type *)
	(* Note, here we don't use Download, because that will need to contact database which is slow; also because myExistingNamedObjects may contain objects that aren't in database yet *)
	(* Because all the objects are deliberately in NamedObject form, Mapping Last will extract the names *)
	existingObjectNames = Last /@ existingObjectsOfSameType;
	
	findUniqueName[myTempName, existingObjectNames, myNameSuffix]
	
];

(* ::Subsubsection::Closed:: *)
(*findUniqueName*)

(* This function checks if myTempName is in myExistingNames; if not, output myTempName, if yes, change the myTempName by adding index before myNameSuffix until that name no longer exist in myExistingNames *)
findUniqueName[myTempName_String, myExistingNames:{_String...}, myNameSuffix_String] := If[MemberQ[myExistingNames, myTempName],
	Module[
		{namePrefix, nameIndex, newNameIndex, newName},

		(* Assume our name is always consist of 2 or 3 components: prefix, optional index, and suffix. Suffix is defined in myNameSuffix input *)
		(* index is an integer number and can be optional. First, try to extract the prefix and index *)
		{namePrefix, nameIndex} = First[
			StringCases[myTempName,
				{
					(* First rule applies to name that has index. e.g., "glass Vessel 2 created today", "2" is the index *)
					prefix__ ~~ " " ~~ index:Repeated[DigitCharacter] ~~ myNameSuffix ~~ EndOfString :> {prefix, index},
					(* First rule applies to name that does not have index. In that case set the index to 1 *)
					prefix__ ~~ myNameSuffix ~~ EndOfString :> {prefix, "1"}
				}
			]
		];

		(* Increment the index by 1, and convert back to string *)
		newNameIndex = ToString[ToExpression[nameIndex] + 1];

		(* Construct the new name *)
		newName = namePrefix <> " " <> newNameIndex <> myNameSuffix;

		(* recursively feed the new name into this function until we find a name that does not exist in myExistingNames *)
		(* We anticipate that the index number is always small so this should be efficient enough *)
		findUniqueName[newName, myExistingNames, myNameSuffix]
	],
	myTempName
];

(* ::Subsection::Closed:: *)
(*UploadContainerModel*)

(* ::Subsubsection::Closed:: *)
(*DefineOptions*)

DefineOptions[UploadContainerModel,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "inputs",
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line
				],
				Description -> "The name is used to refer to the output Model[Container] object in lieu of an automatically generated ID number.",
				ResolutionDescription -> "Automatically construct according MaxVolume and ContainerMaterials.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Stocked,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if this item is a candidate to be kept in stock at the site in which it's being used. As part of object verification, emerald team member will generate an inventory object for this.",
				ResolutionDescription -> "Automatically set to False when creating new models; when modifying existing models, set the option to the same as current Stocked field in the Model[Container] object.",
				Category -> "Product Specifications"
			},
			{
				OptionName -> Template,
				Default -> Null,
				HideNull -> False,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Model[Container, Plate], Model[Container, ExtractionCartridge]}],
					ObjectTypes -> {Model[Container, Vessel], Model[Container, Plate], Model[Container, ExtractionCartridge]}
				],
				Description -> "A template Model[Container] whose values will be used as defaults for any options not specified by the user, except product specifications.",
				Category -> "Product Specifications"
			},
			{
				OptionName -> Ampoule,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model is a sealed vessel containing a measured quantity of substance, meant for single-use. Ampoule will be cracked open to retrieve its contents, and discarded after use.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Ampoule.",
				Category -> "Specialty Container"
			},
			{
				OptionName -> Hermetic,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container has an inner septum that makes it airtight at its aperture, which can be penetrated by a sharp needle and can be resealed multiple times.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Hermetic.",
				Category -> "Specialty Container"
			},
			{
				OptionName -> Squeezable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container are easily deformed and intended to be squeezed to dispense its contents. Squeezable container cannot be aspirated from but can be dispensed directly.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Squeezable.",
				Category -> "Specialty Container"
			},
			{
				OptionName -> Dropper,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this vessel has an attachment in the aperture that allows it to only dispense liquid via drop creation.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Dropper.",
				Category -> "Specialty Container"
			},
			{
				OptionName -> PermanentlySealed,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of container is sealed closed and can not be opened to transfer anything into or out of it.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PermanentlySealed.",
				Category -> "Specialty Container"
			},
			{
				OptionName -> Treatment,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> WellTreatmentP
				],
				Description -> "The surface modification, if any, on the interior of this container. Option include LowBinding, TissueCultureTreated, Glass, GlassFilter, PolyethersulfoneFilter (PES Filter) and HydrophilicPolypropyleneFilter.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Treatment.",
				Category -> "Container Specifications"
			},
			{
				OptionName -> ContainerMaterials,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> MaterialP
						]
					]
				],
				HideNull -> False,
				Category -> "Container Specifications",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of ContainerMaterials.",
				Description -> "The materials of which this container is made that come in direct contact with the samples it contains."
			},
			{
				OptionName -> SelfStanding,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container is capable of staying upright when placed on a stationary flat surface and does not require a rack. Note that SelfStanding containers are not necessarily TransportStable, which requires the container to be able to stay upright while being transported on an operator cart.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of SelfStanding.",
				Category -> "Container Specifications"
			},
			{
				OptionName -> TransportStable,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container is capable of staying upright without assistance when being transported on an operator cart. Containers that are stable for transport can tolerate cart motion and accidental contact without falling, while those that are not must be placed into a rack. TransportStable containers are always SelfStanding, but the opposite is not true.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of TransportStable.",
				Category -> "Container Specifications"
			},
			{
				OptionName -> ExposedSurfaces,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if any sensitive portions of this container are open to the external environment and prone to contamination.",
				ResolutionDescription -> "If creating a new object, resolves to False. For existing objects, Automatic resolves to the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> DefaultStorageCondition,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[StorageCondition]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> SampleStorageTypeP
					]
				],
				Description -> "The environment in which an empty new container of this model is stored when not in use by an experiment; whenever the container has contents, its storage condition will be overwritten by the contents. For reusable containers, when they are emptied and cleaned, their storage condition will be restored to this DefaultStorageCondition.",
				ResolutionDescription -> "If ExposedSurfaces is True, resolves to Model[StorageCondition, \"Ambient Storage, Lined Enclosed\"], otherwise resolves to Model[StorageCondition, \"Ambient Storage\"]. For existing models, Automatic resolves to the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> Fragile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a pile. Fragile objects must be stored upright if they are SelfStanding, or stored in a rack if not.",
				ResolutionDescription -> "When creating new models, automatically set to True if ContainerMaterials contains Glass, otherwise set to Null. When modifying existing models, set the option to match the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> Reusable,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the container is designed for multiple uses or if it is discarded after a single use. Reusable containers typically requiring cleaning and are hand washed or dishwashed after each use. If the container is Reusable, cleaning conditions are set by CleaningMethod and DetergentSensitive options.",
				ResolutionDescription -> "Automatically set to False if Ampoule -> True, and True if CleaningMethod or PreferredWashbin is specified. When modifying existing models, set the option to match the current field value.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> DetergentSensitive,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the container is intended to hold contents that may be used in applications that may be sensitive to cleaning detergents and should be handwashed instead of machine washed. For example containers used in applications in liquid chromatography coupled to mass spectrometry (LCMS) experiments should be handwashed in order to avoid contamination of the LCMS system.",
				ResolutionDescription -> "Automatically set to False unless CleaningMethod is set to Handwash.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> CleaningMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CleaningMethodP
				],
				Description -> "Indicates the type of cleaning that is employed for this model of container before reuse.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CleaningMethod.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> StorageOrientation,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> StorageOrientationP
				],
				Description -> "Indicates how the object is situated while in storage. Upright indicates that at storage the opening of container is pointing up, Side indicates the Depth and Height dimensions are in the XY plane, Face indicates Width and Height are in the XY plane, and Any indicates that there is no preferred orientation during storage.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of StorageOrientation.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> StorageOrientationImage,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Use existing cloud file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Upload from computer" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Paragraph,
						PatternTooltip -> "The complete path to the image file."
					]
				],
				Description -> "A file containing an image showing the designated orientation of this object in storage as defined by the StorageOrientation.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of StorageOrientationImage.",
				Category -> "Storage & Handling"
			},
			{
				OptionName -> ImageFile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Use an uploaded file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Upload from your PC" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Paragraph,
						PatternTooltip -> "The complete path to the image file."
					],
					"Use image URL" -> Widget[
						Type -> String,
						Pattern :> URLP,
						Size -> Paragraph,
						PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
					]
				],
				Description -> "A photo of this model of container. This will be used to help identify this type of container in lab operations. If possible, please provide stock image from manufacturer. If no image is provided, the container model will be imaged by ECL upon receiving in lab.",
				ResolutionDescription -> "If the ModelToUpdate is set, automatically set to match the field value of ImageFile.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> CrossSectionalShape,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CrossSectionalShapeP
				],
				Description -> "The closest match to the type of shape of this container's horizontal cross-section would take. Options include: Circle, Rectangle, Oval and Triangle. CrossSectionalShape is used for diagrammatically plotting the container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CrossSectionalShape.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> Skirted,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container has walls that extend below the vessel's well geometry to allow the vessel to stand upright on a flat surface without use of a rack. In the case of plates, this is used to calculate additional parameters for liquid handler applications. For other containers it's used for identification purpose.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Skirted.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> PlateColor,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> PlateColorP
				],
				Description -> "The color of the main body of the plate, including the wall of wells but not the bottom. This contrast with WellColor, which indicates the color of the well bottom. For example, plates designed for fluorescence measurements usually have clear wells and black body.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PlateColor.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> WellColor,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> PlateColorP
				],
				Description -> "The color of the bottom of the wells of the plate. This contrast with PlateColor, which indicates the color of the main body of the plate. For example, plates designed for fluorescence measurements usually have clear wells and black body.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellColor.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> WellBottom,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> WellShapeP
				],
				Description -> "Shape of the bottom of each well for a plate. This is used to calculate the 3D shape and positions of the wells, which is especially important for application on liquid handlers.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellBottom.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> InternalBottomShape,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> WellShapeP
				],
				Description -> "Shape of the bottom of the vessel's contents holding cavity. This is used to calculate the 3D shape and positions of the wells, which is especially important for application on liquid handlers.",
				Category -> "Physical Appearance"
			},
			{
				OptionName -> MinTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Kelvin],
					Units -> {1, {Celsius, {Kelvin, Celsius, Fahrenheit}}}
				],
				Description -> "Minimum temperature this type of container can be exposed to and maintain structural integrity.",
				ResolutionDescription -> "If the ContainerMaterials option is provided, automatically set to the MinTemperature of the material; if multiple materials are provided, the highest value will be used; if the ModelToUpdate is set, automatically set to match the field value of MinTemperature.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MaxTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Kelvin],
					Units -> {1, {Celsius, {Kelvin, Celsius, Fahrenheit}}}
				],
				Description -> "Maximum temperature this type of container can be exposed to and maintain structural integrity.",
				ResolutionDescription -> "If the ContainerMaterials option is provided, automatically set to the MaxTemperature of the material; if multiple materials are provided, the lowest value will be used; if the ModelToUpdate is set, automatically set to match the field value of MaxTemperature.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MinVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Microliter],
					Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
				],
				Description -> "The minimum volume of water required to create a uniform layer at the bottom of the container, indicating the smallest volume needed to reliably aspirate from the container, measure spectral properties, etc.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MinVolume.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> MaxVolume,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Microliter],
					Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
				],
				Description -> "Maximum volume of fluid the container is designed to hold.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxVolume.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> RecommendedFillVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0*Microliter],
					Units -> {1, {Milliliter, {Microliter, Milliliter, Liter}}}
				],
				Description -> "The largest recommended volume this plate should contain in each well. This option is only relevent for plates and must be less than or equal to MaxVolume option.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of RecommendedFillVolume.",
				Category -> "Operating Limits"
			},
			{
				OptionName -> Opaque,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the exterior of this container blocks the transmission of visible light.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Opaque.",
				Category -> "Optical Information"
			},
			{
				OptionName -> MinTransparentWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[1 Nanometer],
					Units -> {1, {Nanometer, {Angstrom, Nanometer, Micrometer}}}
				],
				Description -> "Minimum wavelength this type of container allows to pass through, thereby allowing measurement of the sample contained using light source with larger wavelength.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MinTransparentWavelength.",
				Category -> "Optical Information"
			},
			{
				OptionName -> MaxTransparentWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[1 Nanometer],
					Units -> {1, {Nanometer, {Angstrom, Nanometer, Micrometer}}}
				],
				Description -> "Maximum wavelength this type of container allows to pass through, thereby allowing measurement of the sample contained using light source with larger wavelength.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxTransparentWavelength.",
				Category -> "Optical Information"
			},
			{
				OptionName -> Sterile,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				HideNull -> False,
				Description -> "Indicates if this model of container arrives free of microbial contamination from the manufacturer or is sterilized upon receiving.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Sterile.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> Sterilized,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of container is sterilized by autoclaving upon receiving and, if it is reusable, after being cleaned before it is reused.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Sterilized.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> RNaseFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this model of container is verified to be free of any enzymes that break down ribonucleic acid (RNA), when received from the manufacturer.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of RNaseFree.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> NucleicAcidFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are verified to be free from ribonucleic acid (RNA) or deoxyribonucleic acid (DNA) when received from manufacturer.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PyrogenFree.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> PyrogenFree,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if samples of this model are verified to be free from compounds that induce fever when introduced into the bloodstream, such as Endotoxins.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PyrogenFree.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> Dimensions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					{
						"Width (left to right, or the longer horizontal dimension)" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Depth (front to back, or the shorter horizontal dimension)" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Height (top to bottom, i.e. the vertical dimension)" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						]
					}
				],
				Description -> "The external length measurements of this model of container when it's standing upright.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Dimensions.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Positions,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Do not update Positions" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					"Compute automatically" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					],
					"Manually add Positions for each well" -> Adder[
						{
							"Name of Position" -> Widget[
								Type -> String,
								Pattern :> LocationPositionP,
								Size -> Line
							],
							"Footprint" -> Widget[
								Type -> Enumeration,
								Pattern :> (FootprintP|Open|Null)
							],
							"Max Width" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Max Depth" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Max Height" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							]
						}
					]
				],
				Description -> "Spatial definitions of the contents-holding cavities that exist in this model of container, where MaxWidth and MaxDepth are the x and y dimensions of the maximum size of object that will fit in this position. MaxHeight is defined as the maximum height of object that can fit in this position without either encountering a barrier or creating a functional impediment to an experiment procedure.",
				ResolutionDescription -> "Automatically calculated based on other relevant options, such as Dimensions, NumberOfWells, etc.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> PositionPlotting,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Do not update PositionPlotting" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					"Compute automatically" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic]
					],
					"Manually add PositionPlotting for each well" -> Adder[
						{
							"Name of Position" -> Widget[
								Type -> String,
								Pattern :> LocationPositionP,
								Size -> Line
							],
							"X Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Y Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Z Offset" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Millimeter],
								Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
							],
							"Cross-sectional shape" -> Widget[
								Type -> Enumeration,
								Pattern :> CrossSectionalShapeP
							],
							"Rotation in degree" -> Widget[
								Type -> Number,
								Pattern :> RangeP[-180, 180]
							]
						}
					]
				],
				Description -> "The parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the container model's dimensions.",
				ResolutionDescription -> "Automatically calculated based on other relevant options, such as Dimensions, NumberOfWells, etc.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> CavityCrossSectionalShape,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CrossSectionalShapeP
				],
				Description -> "The shape of the horizontal cross section of the internal cavity of the container which holds the sample. For plates with multiple sample wells, this refers to the shape of the horizontal cross section of one single well. If there are wells of different shapes on the same plate, please contact ECL to create this plate model manually.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellShape for plates.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Footprint,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> (FootprintP|None)
				],
				Description -> "A standardized symbol representing the shape of exterior bottom portion of this model of container used to seat the container in an open position. In lab operations when a container is to be moved to a destination, if both the container and destination position has Footprint, then the move is only allowed if their Footprint match with each other.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Footprints.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> TopFootprints,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> FootprintP
						]
					]
				],
				Description -> "A list of standardized symbols representing the shape of top portion of this model of container to stack other containers. Stacking of containers is only allowed if the Footprint of top container matches one of the TopFootprints of bottom container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of TopFootprints.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> CoverTypes,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> CoverTypeP
						]
					]
				],
				Description -> "The types of cap, seal or other coverings that are compatible with this container, which can be Crimp, Seal, Screw, Snap, Place, Pry and/or AluminumFoil. Only coverings with matching CoverType will be used to cover this container model in lab operations.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CoverTypes.",
				Category -> "Cover Information"
			},
			{
				OptionName -> CoverFootprints,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> CoverFootprintP
						]
					]
				],
				Description -> "The list of shape and size of cap, seal or other coverings, represented by standardized symbols, that can fit on top of this container. Only coverings with matching CoverFootprint will be used to cover this container model in lab operations.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CoverFootprints.",
				Category -> "Cover Information"
			},
			{
				OptionName -> BuiltInCover,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the container has a cap that is physically attached and cannot be physically separated from the container (e.g. centrifuge tube with tethered cap).",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of BuiltInCover.",
				Category -> "Cover Information"
			},
			{
				OptionName -> DisposableCaps,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if this container uses interchangeable caps, lids, seals or other coverings that are disposable; i.e. the covering on the container could be changed to another equivalent one at any time.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of DisposableCaps.",
				Category -> "Cover Information"
			},
			{
				OptionName -> PreferredCamera,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> CameraCategoryP
				],
				Description -> "Indicates the recommended camera type for taking an image of a sample in this type of container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PreferredCamera.",
				Category -> "Compatibility"
			},
			{
				OptionName -> Rows,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> (Null | Automatic)
					]
				],
				Description -> "The number of wells in the plate from front to back - in the shorter horizontal direction if the plate is not square.",
				ResolutionDescription -> "If both Columns and NumberOfWells are specified, auto calculate from those two options.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Columns,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> (Null | Automatic)
					]
				],
				Description -> "The number of wells in the plate from left to right - in the longer horizontal direction if the plate is not square.",
				ResolutionDescription -> "If both Rows and NumberOfWells are specified, auto calculate from those two options.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> NumberOfWells,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0, 1]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> (Null | Automatic)
					]
				],
				Description -> "Number of individual contents-holding cavities the plate has.",
				ResolutionDescription -> "If both Columns and Rows are specified, auto calculate from those two options.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> AspectRatio,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> GreaterP[0]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> (Null | Automatic)
					]
				],
				Description -> "Ratio of the number of columns of wells vs the number of rows of wells on the plate.",
				ResolutionDescription -> "If both Columns and Rows are specified or can be calculated, autocalculate from those two options.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> DestinationContainerModel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Model[Container, Plate]}],
					ObjectTypes -> {Model[Container, Vessel], Model[Container, Plate]}
				],
				Description -> "If the container model is a filter, the model of container connected to this type of filter used to collect the liquid during filtration.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of DestinationContainerModel.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> DestinationContainerIncluded,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "If the container model is a filter, indicates that this type of filter includes a receiving container (i.e., DestinationContainerModel) as part of a unit upon receiving from manufacturer.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of DestinationContainerIncluded.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> RetentateCollectionContainerModel,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container, Vessel], Model[Container, Plate]}],
					ObjectTypes -> {Model[Container, Vessel], Model[Container, Plate]}
				],
				Description -> "If the container model is a filter, The model of container in which this type of filter can be inverted and centrifuged in order to collect the sample retained on the filter.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of RetentateCollectionContainerModel.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> CartridgeLength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "If the container model is a solid-phase extraction (SPE) cartidge, the internal length of the body. This option do not apply to other type of container models.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of CartridgeLength.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> InternalConicalDepth,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Height of the conical section of the vessel's contents holding cavity. This option is only relevent for Vessels.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of InternalConicalDepth.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> InternalDepth,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "The distance from the aperture to the bottom of vessel's contents-holding cavity.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of InternalDepth.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> Aperture,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "The minimum opening diameter encountered when aspirating from the container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of Aperture.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> InternalDiameter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Diameter of the vessel's contents holding cavity if the cavity is circular. If the cavity is not circular, InternalDimensions option should be used instead.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of InternalDiameter.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> InternalDimensions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					{
						"Width" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Depth" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						]
					}
				],
				Description -> "Interior size of the vessel's contents holding cavity.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of InternalDimensions.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> WellDiameter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Diameter of each round contents holding cavity for a plate. If the cavity is not circular, option WellDimensions should be used instead.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellDiameter.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> WellDepth,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Maximum vertical depth of each contents holding cavity for a plate.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellDepth.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> WellDimensions,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					{
						"Width" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						],
						"Depth" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Centimeter],
							Units -> {1, {Centimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
						]
					}
				],
				Description -> "Internal horizontal size of the each contents holding cavity in this model of plate.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of WellDimensions.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> ConicalWellDepth,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Depth of the conical section of the cavity for plates. Both WellDepth and ConicalWellDepth are used to calculate 3D dimensions of the contents-holding cavity, which is especially important for liquid handler applications.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of ConicalWellDepth.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> HorizontalMargin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Distance from the edge of the plate to the edge of the first column of wells, along the longer horizontal dimension.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalMargin.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalMargin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Distance from the edge of the plate to the edge of the first row of wells, along the shorter horizontal dimension.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalMargin.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> DepthMargin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Vertical height distance from the bottom of the plate to the bottom of the first contents-holding cavity.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of DepthMargin.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> HorizontalPitch,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Center-to-center distance from one well to the next in a given row.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalPitch.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalPitch,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Center-to-center distance from one well to the next in a given column.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalPitch.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> HorizontalOffset,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Distance between the center of well at column 1 row 1 and well at column 1 row 2 in the X direction. Only applies to plates which the wells are staggered or tilted across rows.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of HorizontalOffset.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> VerticalOffset,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Millimeter],
					Units -> {1, {Millimeter, {Millimeter, Centimeter, Inch, Foot, Meter}}}
				],
				Description -> "Distance between the center of well at column 1 row 1 and well at column 2 row 1 in the Y direction. Only applies to plates which the wells are staggered or tilted across columns.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of VerticalOffset.",
				Category -> "Dimensions & Positions"
			},
			{
				OptionName -> MembraneMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FilterMembraneMaterialP
				],
				Description -> "The material of the filter membrane through which the sample travels to remove particles.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MembraneMaterial.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> PrefilterMembraneMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FilterMembraneMaterialP
				],
				Description -> "The material of the prefilter through which the sample travels to remove any large particles prior to passing through the filter membrane.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PrefilterMembraneMaterial.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> MolecularWeightCutoff,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 * Dalton],
					Units -> {1, {Dalton, {Dalton, Kilodalton, Megadalton}}}
				],
				Description -> "The lowest molecular weight of particles which will filtered out by this filter model.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MolecularWeightCutoff.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> PrefilterPoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Micrometer],
					Units -> {1, {Micrometer, {Nanometer, Micrometer}}}
				],
				Description -> "The average size of the pores of this model of filter's prefilter, which will remove any large particles prior to passing through the filter membrane.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PrefilterPoreSize.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> PoreSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Micrometer],
					Units -> {1, {Micrometer, {Nanometer, Micrometer}}}
				],
				Description -> "The average size of the pores of this model of filter, which will filter out any particles above this size.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PoreSize.",
				Category -> "Filter Specifications"
			},
			{
				OptionName -> PackingMaterial,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnPackingMaterialP
				],
				Description -> "If the container model is a solid-phase extraction (SPE) cartridge, indicate the chemical composition of the packing material. This option do not apply to other type of container models.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PackingMaterial.",
				Category -> "Extraction Cartridge Specifications"
			},
			{
				OptionName -> SeparationMode,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SeparationModeP
				],
				Description -> "The type of solid phase extraction (SPE) for which this cartridge model is suitable.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of SeparationMode.",
				Category -> "Extraction Cartridge Specifications"
			},
			{
				OptionName -> FunctionalGroup,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> SolidPhaseExtractionFunctionalGroupP
				],
				Description -> "The chemical functional group presents on the cartridge's stationary phase.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of FunctionalGroup.",
				Category -> "Extraction Cartridge Specifications"
			},
			{
				OptionName -> ParticleSize,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Micrometer],
					Units -> {1, {Micrometer, {Nanometer, Micrometer, Millimeter}}}
				],
				Description -> "The average size of the particles that make up the packing material for solid-phase extraction cartridge.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of ParticleSize.",
				Category -> "Extraction Cartridge Specifications"
			},
			{
				OptionName -> BedWeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram],
					Units -> {1, {Gram, {Milligram, Gram, Kilogram}}}
				],
				Description -> "The dry weight of the packing material in the cartridge.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of BedWeight.",
				Category -> "Extraction Cartridge Specifications"
			},
			{
				OptionName -> MaxBedWeight,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram],
					Units -> {1, {Gram, {Milligram, Gram, Kilogram}}}
				],
				Description -> "The maximum dry weight of the packing material that can be loaded into this size of cartridge.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of MaxBedWeight.",
				Category -> "Extraction Cartridge Specifications"
			},
			(* These legit product-related options are hidden so for users we only show the merged ProductInformation option *)
			(* In the verification function they will be revealed *)
			{
				OptionName -> Product,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Product]]
				],
				Description -> "Product ordering information for this model.",
				ResolutionDescription -> "If the ModelToUpdate is set, automatically set to match the field value of Product.",
				Category -> "Hidden"
			},
			{
				OptionName -> ProductDocumentation,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					"Use an uploaded file" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[EmeraldCloudFile]]
					],
					"Use file from URL" -> Widget[
						Type -> String,
						Pattern :> URLP,
						Size -> Paragraph,
						PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
					],
					"Upload from your PC" -> Widget[
						Type -> String,
						Pattern :> FilePathP,
						Size -> Paragraph,
						PatternTooltip -> "The complete path to the documentation file."
					]
				],
				Description -> "Specification sheets of this product provided by the supplier or manufacturer of this model.",
				ResolutionDescription -> "If the ModelToUpdate is set, automatically set to match the field value of ProductDocumentation.",
				Category -> "Hidden"
			},
			{
				OptionName -> ProductURL,
				Default -> Automatic,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[
					Type -> String,
					Pattern :> URLP,
					Size -> Paragraph,
					PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
				],
				Description -> "Supplier webpage for the product.",
				ResolutionDescription -> "If the ModelToUpdate is set, automatically set to match the field value of ProductURL.",
				Category -> "Hidden"
			},
			{
				OptionName -> DefaultStickerModel,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Alternatives[
					"Sticker size" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Small, Large]
					],
					"Sticker model" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Item, Sticker]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Miscellaneous", "Sticker Models"
							}
						}
					]
				],
				Description -> "The type of sticker applied to containers of this model when they are stickered upon receiving.",
				(* Use dimensions to determine sticker type *)
				ResolutionDescription -> "Automatically set to Small when creating new models; when modifying existing models, set the option to the same as current field in the Model[Container] object.",
				Category -> "Hidden"
			},
			{
				OptionName -> PreferredBalance,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BalanceModeP
				],
				Description -> "Indicates the recommended balance type for weighing a sample in this type of container.",
				ResolutionDescription -> "Automatically set to the Template value if Template is specified; if the ModelToUpdate is set, automatically set to match the field value of PreferredBalance.",
				Category -> "Hidden"
			},
			{
				OptionName -> PreferredWashBin,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container, WashBin]]
				],
				Description -> "Indicates the recommended bin for dishwashing this container.",
				ResolutionDescription -> "If Reusable -> True, automatically set to either regular or carboy washbin depends on the size.",
				Category -> "Hidden"
			},
			{
				OptionName -> ContainerType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives @@ Types[{
						Model[Container, Vessel],
						Model[Container, Plate],
						Model[Container,ExtractionCartridge]
					}]
				],
				Description -> "Developer-only option. Indicates the new subtype of Model[Container] that should be created to replace the current Model[Container] input. This is meant for cases where user did not know what type of container to create, and chose Model[Container] parent type.",
				Category -> "Hidden"
			}

		],
		{
			OptionName -> Force,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicate if new container models will still be uploaded even if similar ones are already found in the database.",
			Category -> "Organizational Information"
		},
		ExternalUploadHiddenOptions,
		SimulationOption
	}
];


(* ::Subsubsection::Closed:: *)
(*Function*)

(* Core overload *)
UploadContainerModel[myMixedInput:ListableP[Alternatives[TypeP[Model[Container]], ObjectP[Model[Container]]]], myProductInfo:ListableP[Alternatives[Null, ObjectP[Object[Product]], ObjectP[Object[EmeraldCloudFile]], _String]], ops:OptionsPattern[]] := uploadContainerCoverModelCore[
	myMixedInput,
	myProductInfo,
	ToList[ops],
	UploadContainerModel
];

(* No Product info overload *)
UploadContainerModel[myMixedInput:ListableP[Alternatives[TypeP[Model[Container]], ObjectP[Model[Container]]]], ops:OptionsPattern[]] := uploadContainerCoverModelCore[
	myMixedInput,
	If[MatchQ[myMixedInput, _List], ConstantArray[Null, Length[myMixedInput]], Null],
	ToList[ops],
	UploadContainerModel
];

$ContainerModelStringToTypeLookup = <|
	"Tube or bottle" -> Model[Container, Vessel],
	"Volumetric flask" -> Model[Container, Vessel, VolumetricFlask],
	"Plate" -> Model[Container, Plate],
	"Tube filter" -> Model[Container, Vessel, Filter],
	"Plate filter" -> Model[Container, Plate, Filter],
	"Solid-phase extraction cartridge" -> Model[Container, ExtractionCartridge],
	"Capillary ELISA plate" -> Model[Container, Plate, Irregular, CapillaryELISA],
	"Others" -> Model[Container]
|>;

(* user-friendly string overload *)
UploadContainerModel[myNewContainer:UploadContainerModelTypeStringP, myProductInfo:Alternatives[Null, ObjectP[Object[Product]], ObjectP[Object[EmeraldCloudFile]], _String], ops:OptionsPattern[]] := With[
	{myContainerType = Lookup[$ContainerModelStringToTypeLookup, myNewContainer]},
	uploadContainerCoverModelCore[
		myContainerType,
		myProductInfo,
		ToList[ops],
		UploadContainerModel
	]
];

(* user-friendly string no-product overload *)
UploadContainerModel[myNewContainer:UploadContainerModelTypeStringP, ops:OptionsPattern[]] := With[
	{myContainerType = Lookup[$ContainerModelStringToTypeLookup, myNewContainer]},
	uploadContainerCoverModelCore[
		myContainerType,
		Null,
		ToList[ops],
		UploadContainerModel
	]
];

installDefaultVerificationFunction[UploadContainerModel,
	"containerModel",
	{Model[Container, Vessel], Model[Container, Plate], Model[Container, ExtractionCartridge]},
	OptionCategoryChange -> {
		<| Options -> Product, Category -> "Product Specifications" |>,
		<| Options -> ProductDocumentation, Category -> "Product Specifications" |>,
		<| Options -> ProductURL, Category -> "Product Specifications" |>,
		<| Options -> DefaultStickerModel, Category -> "Organizational Information" |>,
		<| Options -> PreferredBalance, Category -> "Compatibility" |>,
		<| Options -> PreferredWashBin, Category -> "Storage & Handling" |>
	}
];

(* ::Subsubsection::Closed:: *)
(*Option function: UploadContainerModelOptions*)

DefineOptions[UploadContainerModelOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadContainerModel}
];

(* Single input overload *)
UploadContainerModelOptions[myInput:_, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadContainerModel[myInput, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadProduct],
		options
	]
];

(* Double input overload *)
UploadContainerModelOptions[myInput:_, myProductInfo_, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadContainerModel[myInput, myProductInfo, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadProduct],
		options
	]
];

(* ::Subsubsection::Closed:: *)
(*Valid function: ValidUploadContainerModelQ*)

DefineOptions[ValidUploadContainerModelQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadContainerModel}
];

(* Single input overload *)
ValidUploadContainerModelQ[myInput_, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadContainerModel[myInput, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadProductQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadProductQ"]
];

(* Double input overload *)
ValidUploadContainerModelQ[myInput_, myProductInfo_, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadContainerModel[myInput, myProductInfo, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadProductQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadProductQ"]
];

