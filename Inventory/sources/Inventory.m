(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*CancelTransaction*)


(* ::Subsubsection::Closed:: *)
(*CancelTransaction Options*)


DefineOptions[CancelTransaction,
	Options:>{
		CacheOption,
		UploadOption,
		OutputOption,
		EmailOption
	}
];

Error::CanNotCancel="The following transaction(s) with the associated status cannot be canceled: `1`. Please check the transaction status and request another cancellation.";
Error::ShippingInProgress="The following transaction(s) are already being prepared for shipment and cannot be canceled: `1`. Please check the ShippingPreparation field and request another transaction.";


(* ::Subsubsection::Closed:: *)
(*CancelTransaction*)


(* New Command Builder-compliant version - singleton input *)
CancelTransaction[myOrder:ObjectP[Object[Transaction]],myOptions:OptionsPattern[]]:=Module[
	{canceledOrders, uploadOption, outputOption},

	(* call the core, reverse-listable overload *)
	canceledOrders = CancelTransaction[{myOrder},ToList[myOptions]];

	(* Get defaulted Output and Upload options to allow for proper processing of output from listed function call *)
	outputOption = OptionDefault[OptionValue[Output]];
	uploadOption = OptionDefault[OptionValue[Upload]];

	(* If necesssary, modify Result output to faithfully reflect singleton input *)
	Switch[{outputOption, uploadOption},

		(* If Output->Result and Upload->True, take First of result to reflect singleton input *)
		{Result, True}, First[canceledOrders, canceledOrders],

		(* If Output->Result and Upload->False, return output as-is to allow all upload packets to pass through *)
		{Result, False}, canceledOrders,

		(* If Output is a list and Upload->True, replace any Result indices with their First to reflect singleton input *)
		{_List, True},
			With[{pos = Position[outputOption, Result]},
				ReplacePart[
					canceledOrders,
					AssociationThread[pos, First[#, #]& /@ Extract[canceledOrders, pos]]
				]
			],

		(* If Output is a list and Upload->False, leave any Result indices alone to allow all upload packets to pass through *)
		{_List, False}, canceledOrders,

		(* In any other case, no Result output to modify; return listable version output unmodified *)
		_, canceledOrders
	]

];


(* New Command Builder-compliant version - listed input *)
CancelTransaction[myOrders:{ObjectP[Object[Transaction]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionsTests, suppliedCache,
	allDownloadedPackets, updatedCache, allTransactionPackets, sendingTransactionsPkts, returningTransactionsPkts,
	dropShippingTransactionsPkts, notPendingTransactions, notOrderedTransactions, notCancelledTransactions,
	maintenancedTransactions, orderUpdatePackets,userSpecifiedOptions,
	optionsRule, testsRule, previewRule, resultRule, uncancellableTests, shippingInProgressTests,
	email, upload, resolvedEmail,containerOutPacketsByTransaction,shipToECLContainerPackets,shipToECLContainers,
		shipToECLContents,shipToECLSamplesOut,containerStatusRecords,previousStatusByContainer,statusUpdatePackets,wastePackets,
		sampleDestinationUpdates,preExistingContainers,preExistingContainerStatuses,generatedContainers},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionDefault[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* default any unspecified or incorrectly-specified options *)
	{safeOptions, safeOptionsTests} = If[gatherTests,
		SafeOptions[CancelTransaction, listedOptions, Output->{Result, Tests}, AutoCorrect->False],
		{SafeOptions[CancelTransaction, listedOptions, AutoCorrect->False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Pull Email and Upload options from safeOptions *)
	{email, upload} = Lookup[safeOptions, {Email, Upload}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Extract incoming cache to pass to Download *)
	suppliedCache = Lookup[listedOptions,Cache,{}];

	(* Download required information from the orders, their products, and their suppliers *)
	allDownloadedPackets = Quiet[
		Download[myOrders,
			{
				Packet[OrderQuantities,QuantitiesReceived,Products,Notebook,DateExpected,TrackingNumbers,UserCommunications,InternalCommunications,Creator,Supplier,Status,SamplesOut,ContainersOut,RequestedAutomatically,ShippingPreparation],
				Packet[Products[{ProductModel,Samples,NumberOfItems,Name}]],
				(* Additional packets for UploadNotification *)
				Packet[Notebook[Financers][Members][{FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences}]],
				Packet[Notebook[Editors][Members][{FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences}]],
				Packet[Creator[{FirstName, LastName, Email, TeamEmailPreference, NotebookEmailPreferences}]],
				Packet[Supplier[Name]],
				Packet[UserCommunications[{Headline, Description}]],
				Packet[ContainersOut[{Contents, StatusLog}]]
			},
			Cache->suppliedCache,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField,Download::ObjectDoesNotExist}
	];

	(* Add downloaded information to existing cache *)
	updatedCache = Join[suppliedCache, Cases[allDownloadedPackets, PacketP[]]];

	(* get order packets *)
	allTransactionPackets = allDownloadedPackets[[All,1]];

	(* get packets for sending transactions, returning transactions and drop shipping transactions *)
	sendingTransactionsPkts = Cases[allTransactionPackets,ObjectP[Object[Transaction,ShipToECL]]];
	returningTransactionsPkts = Cases[allTransactionPackets,ObjectP[Object[Transaction,ShipToUser]]];
	dropShippingTransactionsPkts = Cases[allTransactionPackets,ObjectP[Object[Transaction,DropShipping]]];

	(* check whether the transactions are safe to cancel *)
	(* note: for transaction order, ShipToECL, ShipToUser: only pending transactions can be canceled *)
	notPendingTransactions = Map[
		If[!MatchQ[Lookup[#,Status],Pending],
			Lookup[#,{Object,Status}],
			Nothing
		]&,
		Join[sendingTransactionsPkts,returningTransactionsPkts]
	];

	(* note: for drop shipping transaction: only ordered transactions can be canceled *)
	notOrderedTransactions = Map[
		If[!MatchQ[Lookup[#,Status],Ordered],
			Lookup[#,{Object,Status}],
			Nothing
		]&,
		dropShippingTransactionsPkts
	];

	(* Collect all Object[Transaction, Order/ShipToECL/ShipToUser] packets that can not be canceled because of their status *)
	notCancelledTransactions = Join[notPendingTransactions,notOrderedTransactions];

	(* Identify any Object[Transaction, ShipToUser] transactions that cannot be canceled because they already have a maintenance enqueued *)
	maintenancedTransactions = Map[
		If[!MatchQ[Lookup[#,ShippingPreparation],Null],
			Lookup[#,Object],
			Nothing
		]&,
		returningTransactionsPkts
	];

	(* --- Generate tests or display messages if any requests are invalid --- *)

	(* return an error if any of the transaction can not be canceled *)
	uncancellableTests = If[gatherTests,
		MapThread[
			Test[ToString[#] <> " can be canceled because its status is Pending:", True, False]&,
			notCancelledTransactions
		],
		If[Length[notCancelledTransactions] > 0, Message[Error::CanNotCancel,notCancelledTransactions]]
	];

	(* return an error if any of the transaction can not be canceled *)
	shippingInProgressTests = If[gatherTests,
		MapThread[
			Test[ToString[#] <> " can be canceled because shipping has not yet begun:", True, False]&,
			maintenancedTransactions
		],
		If[Length[maintenancedTransactions] > 0, Message[Error::ShippingInProgress,maintenancedTransactions]]
	];

	(* Get the ContainersOut packets of the transactions *)
	containerOutPacketsByTransaction = allDownloadedPackets[[All, -1]];

	(* Filter the ContainersOut packets so we just have the ShipToECL ones *)
	shipToECLContainerPackets = PickList[containerOutPacketsByTransaction, allTransactionPackets, ObjectP[Object[Transaction, ShipToECL]]];

	(* Get the containers of the ShipToECL transactions *)
	shipToECLContainers = Lookup[#, Object,{}] & /@ shipToECLContainerPackets;

	(* Get the contents of each ShipToECL container *)
	shipToECLContents=Download[Lookup[#, Contents,{}][[All, All, 2]], Object] & /@ shipToECLContainerPackets;

	(* Get the samples out of the ShipToECL transactions *)
	shipToECLSamplesOut=Download[Lookup[#, SamplesOut], Object] & /@ sendingTransactionsPkts;

	(* Get the pre-Transit status of the containers. If there was not previous status (i.e., the container was created as part of the transaction), will be {} *)
	containerStatusRecords = Lookup[#, StatusLog,{}][[All, 2]] & /@ Flatten[shipToECLContainerPackets];
	previousStatusByContainer=FirstCase[Reverse[#], Except[Transit],{}] & /@ containerStatusRecords;

	(* Find out which containers existed before the transaction and which didn't *)
	preExistingContainers = PickList[Flatten[shipToECLContainers], previousStatusByContainer, Except[{}]];
	preExistingContainerStatuses=Cases[previousStatusByContainer, Except[{}]];
	generatedContainers = PickList[Flatten[shipToECLContainers], previousStatusByContainer, {}];

	(* If any containers existed before the transaction, reset their statuses instead of discarding them.
		This will also update the contents of the containers. (Unfortunately, this will also update the samples we will be discarding since we only have one upload call.) *)
	statusUpdatePackets=UploadSampleStatus[preExistingContainers,Flatten[preExistingContainerStatuses],Upload->False,FastTrack->True];

	(* Also clear the destination field of the samples *)
	sampleDestinationUpdates=<|Object->#,Destination->Null|>&/@Flatten[shipToECLContents];

	(* Send the samples and containers that were created by the transaction to waste. (We can't erase them, because this is a user-facing function and users can't call EraseObject). *)
	wastePackets=UploadLocation[Flatten[{shipToECLSamplesOut, generatedContainers}],Waste,Upload->False,FastTrack->True];

	(* create update packets for the orders to indicate cancellation *)
	orderUpdatePackets=UploadTransaction[myOrders,Canceled,Upload->False,FastTrack->True,Cache->updatedCache];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result; no resolution required for this function *)

	(* We only return non-Hidden Options *)
	userSpecifiedOptions=RemoveHiddenOptions[CancelTransaction,ReplaceRule[safeOptions, Email->resolvedEmail]];

	optionsRule = Options -> If[MemberQ[output,Options],
		userSpecifiedOptions,
		Null
	];

	(* Preview not applicable to CancelTransaction *)
	previewRule = Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Join[safeOptionsTests, uncancellableTests, shippingInProgressTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so
		Don't need to worry about failure during options resolution since there is none *)
	resultRule = Result -> If[MemberQ[output, Result],
		Module[{cancellationUpdates, allUpdates},

			(* Upload transaction cancellation *)
			cancellationUpdates = UploadTransaction[myOrders, Canceled, Upload->False, Email->resolvedEmail, FastTrack->True, Cache->updatedCache];

			(* Combine updates *)
			allUpdates = Flatten[{cancellationUpdates, statusUpdatePackets, wastePackets,sampleDestinationUpdates}];

			(* Only return a result if input was valid for execution *)
			If[MatchQ[{notCancelledTransactions,maintenancedTransactions},{{},{}}],
				(* upload the order cancellations/inventory updates or return packets depending on Upload option *)
				If[Lookup[safeOptions, Upload],
					(
						(* Execute combined upload *)
						Upload[allUpdates];

						(* return the IDs of the orders that have been canceled *)
						Lookup[allTransactionPackets, Object]
					),
					allUpdates
				],
				(* If execution is impossible due to some inputs being "uncancellable", return $Failed *)
				$Failed
			]
		],
		Null
	];

	ReplaceAll[outputSpecification, {previewRule,optionsRule,testsRule,resultRule}]

];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionOptions Options*)


DefineOptions[CancelTransactionOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{CancelTransaction}
];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionPreview*)


CancelTransactionOptions[myOrders:ListableP[ObjectP[Object[Transaction]]],myOptions:OptionsPattern[]] := Module[
	{listedOps,outOps,options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[SafeOptions[CancelTransactionOptions,listedOps],(OutputFormat->_)| (Output->_)];

	options = CancelTransaction[myOrders, Append[outOps, Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,CancelTransaction],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionPreview Options*)


DefineOptions[CancelTransactionPreview,
	SharedOptions:>{CancelTransaction}
];


(* ::Subsubsection::Closed:: *)
(*CancelTransactionPreview*)


CancelTransactionPreview[myOrders:ListableP[ObjectP[Object[Transaction]]],myOptions:OptionsPattern[]] := CancelTransaction[myOrders, Append[ToList[myOptions], Output->Preview]];


(* ::Subsubsection::Closed:: *)
(*ValidCancelTransactionQ Options*)


DefineOptions[ValidCancelTransactionQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions:>{CancelTransaction}
];


(* ::Subsubsection::Closed:: *)
(*ValidCancelTransactionQ*)


(* Execute CancelTransaction with provided inputs and options and run the resultant tests *)
ValidCancelTransactionQ[myOrders:ListableP[ObjectP[Object[Transaction]]],myOptions:OptionsPattern[]] := Module[
	{listedInput, preparedOptions,cancelTransactionTests,initialTestDescription,allTests, verbose, outputFormat, listedOptions},

	listedInput = ToList[myOrders];
	listedOptions = ToList[myOptions];

	(* Remove the Verbose option and add Output->Tests to get the options ready for CancelTransaction *)
	preparedOptions = Normal@KeyDrop[Append[listedOptions,Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	cancelTransactionTests = CancelTransaction[myOrders, preparedOptions];

	(* Description for test of input and option pattern test *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Assemble a list of tests, first performing a test to see if inputs and options matched the required patterns *)
	allTests = If[MatchQ[cancelTransactionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(* If output of function isn't $Failed, initial test passes *)
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedInput,OutputFormat->Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedInput,validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{initialTest},cancelTransactionTests,voqWarnings]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidRestrictSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidCancelTransactionQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidCancelTransactionQ"]

];


(* ::Subsection::Closed:: *)
(*StoreSamples*)


(* ::Subsubsection::Closed:: *)
(*StoreSamples Options and Messages*)


DefineOptions[StoreSamples,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"main input",
			{
				OptionName->Temperature,
				Default->Automatic,
				AllowNull->True,
				Description->"The temperature at which samples should be stored.",
				ResolutionDescription->"Automatically resolves based on Temperature of samples' DefaultStorageCondition.",
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> StorageTemperatureP
				]
			},
			{
				OptionName->Humidity,
				Default->Automatic,
				AllowNull->True,
				Description->"The constant humidity at which samples should be stored (in an environmental chamber or incubator).",
				ResolutionDescription->"Automatically resolves based on the specifications of Temperature, UVLightIntensity, VisibleLightIntensity and the available Model[StorageCondition].",

				Widget->Widget[
					Type -> Enumeration,
					Pattern :> HumidityP
				]
			},
			{
				OptionName->UVLightIntensity,
				Default->Automatic,
				AllowNull->True,
				Description->"The intensity of ultra-violate light at which samples should be stored (in an environmental chamber).",
				ResolutionDescription->"Automatically resolves based on the specifications of Temperature, Humidity, VisibleLightIntensity and the available Model[StorageCondition].",
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> UVLightIntensityP
				]
			},
			{
				OptionName->VisibleLightIntensity,
				Default->Automatic,
				AllowNull->True,
				Description->"The intensity of visible light at which samples should be stored (in an environmental chamber).",
				ResolutionDescription->"Automatically resolves based on the specifications of Temperature, Humidity, UVLightIntensity and the available Model[StorageCondition].",
				Widget->Widget[
					Type -> Enumeration,
					Pattern :> VisibleLightIntensityP
				]
			},
			{
				OptionName->Desiccated,
				Default->False,
				AllowNull->False,
				Description->"Indicates whether the samples should be stored in a desiccator.",
				ResolutionDescription->"Automatically resolves to the samples' DefaultStorageCondition.",
				Widget-> Widget[Type->Enumeration,Pattern:>BooleanP]
			},
			{
				OptionName->AtmosphericCondition,
				Default->Automatic,
				AllowNull->True,
				Description->"Indicates in which atmosphere the desiccation should occur.",
				ResolutionDescription->"Automatically resolves to Ambient.",
				Widget-> Widget[Type->Enumeration,Pattern:>AtmosphereP]
			},
			{
				OptionName->Date,
				Default->Null,
				Description->"The date at which the sample is going to be stored. If StartDate is specified for certain samples, maintenance protocols for storing these specific samples will be enqueued. Otherwise, the samples will be stored by a general storage update ran every 12 hours in the lab.",
				AllowNull->True,
				Widget->With[{now=Now},
					Widget[Type->Date,Pattern:>GreaterP[now],TimeSelector->True]
				]
			}
		],
		{
			OptionName->Confirm,
			Default->False,
			AllowNull->False,
			Description->"Indicates if the storage update maintenance protocol generated should be confirmed to start at the specified Date upon creation and skip the InCart status.",
			Widget->Widget[Type->Enumeration,Pattern:>BooleanP]
		},
		OutputOption,
		UploadOption

	}
];

Error::IncompatibleInputLength="The input lengths do not match. They should be either the same length or multiples Samples with a single Condition.";

(* ::Subsubsection::Closed:: *)
(*StoreSamples*)


(* ---- Overload 1: Singleton or multiple Sample inputs without StorageCondition-- pass to CORE ---- *)
StoreSamples[mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],myOpts:OptionsPattern[StoreSamples]]:=StoreSamples[mySamples,ConstantArray[None,Length[ToList[mySamples]]],myOpts];

(* ---- CORE: Sample input(s) and StorageCondition input(s) ---- *)
StoreSamples[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],
	myStorages:ListableP[(SampleStorageTypeP|ObjectP[Model[StorageCondition]]|None)],
	myOpts:OptionsPattern[StoreSamples]]:=Module[
	{listedOps,outputSpecification,output,gatherTests,safeOptions,
		safeOptionTests,validLengths,validLengthTests,inputsLengthTest,inputLengthsMismatchQ,
		listedSamples,listedConditions,expandedSafeOptions,dates,upload,maintenancePackets,updatedBys,
		uploadStorageConditionReturnValues,expandedConditions,subbedexpandedConditions,expandedSafeOptionsWithRawOutput,confirm
	},

	(* get listed inputs and options *)
	listedSamples=ToList[mySamples];
	listedConditions=ToList[myStorages];
	listedOps=ToList[myOpts];

	(* determine the requested return value from the function *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	output=ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[StoreSamples,listedOps,Output->{Result, Tests},AutoCorrect->False],
		{SafeOptions[StoreSamples,listedOps,AutoCorrect->False],Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	inputLengthsMismatchQ=Which[
		Length[listedSamples]==Length[listedConditions],False,
		Length[listedConditions]==1,False,
		True,True
	];

	inputsLengthTest=If[TrueQ[gatherTests],
		Test["The provided samples and storage types have the same length or one condition is provided for any number of samples:",
			inputLengthsMismatchQ,
			False
		],
		{}
	];

	(* if the length of the inputs are not the same, return an error; except given one storage type *)
	If[!gatherTests&&inputLengthsMismatchQ,
		Message[Error::IncompatibleInputLength,Length[listedSamples],listedSamples,Length[listedConditions],listedConditions];
	];

	expandedConditions=If[Length[listedConditions]==1,ConstantArray[listedConditions[[1]],Length[listedSamples]],listedConditions];
	(* for some reason None won't work for ValidInputLengthsQ. We replace None's to AmbientStorage here just fo the test. *)
	subbedexpandedConditions=expandedConditions/.None->AmbientStorage;

	{validLengths,validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[StoreSamples,{listedSamples,subbedexpandedConditions},safeOptions,1,Output->{Result,Tests}],
			{ValidInputLengthsQ[StoreSamples,{listedSamples,subbedexpandedConditions},safeOptions,1],{}}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[Or[!validLengths,inputLengthsMismatchQ],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Join[safeOptionTests,validLengthTests],
			Options->$Failed,
			Preview->Null
		}
		]
	];

	(* --- Generate update packets (and resolve options) --- *)

	(* Expand IndexMatched options *)
	expandedSafeOptions=Last[ExpandIndexMatchedInputs[StoreSamples,{listedSamples,expandedConditions},safeOptions]];
	(* Get input options values that we need *)
	{dates,upload}=Lookup[expandedSafeOptions,{Date,Upload}];

	(* Based on Specified dates, generate (and upload) priority maintenance protocols and resolve UpdatedBy for UploadStorageCondition*)
	(* we don't upload here *)
	{maintenancePackets,updatedBys}=If[
		(* If no dates are specified, shortcut to the output *)
		MatchQ[dates,{Null..}],
		{{},ConstantArray[$PersonID,Length[dates]]},
		(* Else *)
		storeSampleMaintenancePackets[listedSamples,dates,expandedSafeOptions]
	];

	(* Call UploadStorageCondition-- we don't upload here*)
	uploadStorageConditionReturnValues=Quiet[
		UploadStorageCondition[listedSamples,expandedConditions,ReplaceRule[
			DeleteCases[expandedSafeOptions,Confirm->_],
			{Output->output,FastTrack->False,Upload->False,QueueStorageUpdate->True,UpdatedBy->updatedBys}
		]],
		{Error::InvalidInput,Error::InvalidOption}
	];


	(* --- Generate output --- *)
	(* we upload together here, if needed*)
	expandedSafeOptionsWithRawOutput=Flatten[{expandedSafeOptions,{Output->outputSpecification}}]//Association//Normal;
	packageStoreSampleOutputs[maintenancePackets,uploadStorageConditionReturnValues,expandedSafeOptionsWithRawOutput]

];


(* ::Subsubsection::Closed:: *)
(* storeSampleMaintenancePackets *)
(* Helper function to return UpdatedBy option values for UploadSampleStorage and Object[Maitenance, StorageUpdate] protocol packets when Date is specified for storage update *)
storeSampleMaintenancePackets[
	mySamples:{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},
	myDates:{Alternatives[_DateObject,Null]..},
	myOptions:OptionsPattern[]]:=Module[{uniqueDates,uniqueDatesDeNull,maintenanceIDs,uniqueDatesWithNullEnd,maintenanceIDsWithPersonEnd,dateToPRRule,
	pRs,samplesGroupedToMaintenanceIDs,maintenanceUploadPackets,maintenanceObjects,nonSelfContainingSamples,nonSelfContainingSampleContainers,
	sampleToContainerRule,mySamplesContainerized,upload
},

	(* We don't generate Object[Maintenance,StorageUpdate] if Date is Null. We also don't need to worry about flag disposal or not enqueue the storage update at all since StoreSamples doe not dispose and always enqueu*)
	uniqueDates=DeleteDuplicates[myDates];
	uniqueDatesDeNull=DeleteCases[uniqueDates,Null];
	maintenanceIDs=CreateID[ConstantArray[Object[Maintenance, StorageUpdate],Length[uniqueDatesDeNull]]];
	(* If there was Null among dates, then attach the Null back to the end of the list *)
	uniqueDatesWithNullEnd=If[Length[uniqueDates]===Length[uniqueDatesDeNull],uniqueDatesDeNull,Append[uniqueDatesDeNull,Null]];
	(* For UpdatedBy, if Date is Null, use $PersonID. *)
	maintenanceIDsWithPersonEnd=If[Length[uniqueDates]===Length[uniqueDatesDeNull],maintenanceIDs,Append[maintenanceIDs,$PersonID]];
	(* Replace rule to associate Date with UpdatedBy *)
	dateToPRRule=AssociationThread[uniqueDatesWithNullEnd->maintenanceIDsWithPersonEnd]//Normal;
	(* use Input index-Matched Date, get index-matched UpdatedBy *)
	pRs=myDates/.dateToPRRule;

	(* get mySamples grouped by, and index-matched to maintenanceIDs *)
	(* but first convert non-self-containing samples to their containers, just like how the typical protocol does it *)
	nonSelfContainingSamples=Cases[mySamples,ObjectP[Object[Sample]]];
	(* TODO: this should probably be grouped into a big cacheball in StoreSamples *)
	nonSelfContainingSampleContainers=Download[nonSelfContainingSamples,Container];
	sampleToContainerRule=AssociationThread[nonSelfContainingSamples,nonSelfContainingSampleContainers]//Normal;
	mySamplesContainerized=mySamples/.sampleToContainerRule;
	samplesGroupedToMaintenanceIDs=PickList[mySamplesContainerized,pRs,#]&/@maintenanceIDs;


	(* make maintenance upload packets for each group *)
	maintenanceUploadPackets=MapThread[
		Function[{maintenanceID,objectList,dates},
			<|
				Object->maintenanceID,
				Type->Object[Maintenance,StorageUpdate],
				Model->Link[Model[Maintenance, StorageUpdate, "id:pZx9jonGJE5E"],Objects],
				If[NullQ[$PersonID],
					Author->Null,
					Author->Link[$PersonID]
				],
				Target->Null,
				(* If object enqueued to move is a Part, need backlink. else it does not *)
				Replace[ScheduledMoves]->(If[MatchQ[#,ObjectReferenceP[Object[Part]]],
					Link[#,Maintenance],
					Link[#]
				]&/@DeleteDuplicates[objectList]),
				StartDate->dates,
				Replace[Checkpoints]->{
					{"Picking Resources",Round[Length[objectList]*(2 Minute)],"Samples required to execute this protocol are gathered from storage.", Null},
					{"Returning Materials",Round[Length[objectList]*(1 Minute)],"Samples are returned to storage.", Null}
				}
			|>
		],
		{maintenanceIDs,samplesGroupedToMaintenanceIDs,uniqueDatesDeNull}
	];

	upload=Lookup[myOptions,Upload];

	(* We are not uploading here. just return packets *)
	maintenanceObjects=MapThread[UploadProtocol[
		#1,
		Upload->False,
		(*We will confirm after we actually upload*)
		Confirm->False,
		StartDate->#2,
		HoldOrder->False,
		ConstellationMessage->Object[Maintenance,StorageUpdate]
	]&,
		{maintenanceUploadPackets,uniqueDatesDeNull}
	];

	{Flatten[maintenanceObjects],pRs}
];


(* ::Subsubsection::Closed:: *)
(* packageStoreSampleOutputs *)
packageStoreSampleOutputs[maintenancePackets:{_Association...},uploadStorageConditionReturnValues_,myOptions:OptionsPattern[]]:=Module[{
	outputSpecification,output,rawOutputRules,userOpsRule,previewRule,testsRule,resultRule,maintenanceObjects
},
	(* determine the requested return value from the function *)
	outputSpecification = Lookup[ToList[myOptions],Output];
	output = ToList[outputSpecification];
	confirm = Lookup[ToList[myOptions],Confirm];


	(* Organize our outputs *)
	rawOutputRules=AssociationThread[output,uploadStorageConditionReturnValues];

	(* Prepare the Options result if we were asked to do so *)
	(* Return resolved options *)
	(* note: only return non-hidden options. such as Temperature *)

	(* get the options rule *)
	userOpsRule = Options->If[MemberQ[output,Options],
		Module[{resolvedUploadStorageConditionOptions,storeSamplesAutoOptions,resolvedOptions,collapsedResolvedOptions},
			resolvedUploadStorageConditionOptions=Lookup[rawOutputRules,Options];

			storeSamplesAutoOptions=Cases[resolvedUploadStorageConditionOptions,Alternatives[Temperature->_,Humidity->_,UVLightIntensity->_,VisibleLightIntensity->_,Desiccated->_,AtmosphericCondition->_]];
			resolvedOptions=Join[Association[myOptions],Association[storeSamplesAutoOptions]]//Normal;


			collapsedResolvedOptions = CollapseIndexMatchedOptions[
				StoreSamples,
				resolvedOptions,
				Messages->False
			];
			RemoveHiddenOptions[StoreSamples,collapsedResolvedOptions]
		],
		Null
	];

	(* Prepare the Preview result; this will always be Null in this case *)
	previewRule = Preview -> Null;

	(* Prepare the Tests result; the only tests here are for SafeOptions *)
	testsRule = Tests -> If[MemberQ[output,Tests],
		Lookup[rawOutputRules,Tests],
		Null
	];

	(* Prepare the standard result if we were asked for it *)
	resultRule = Result -> If[MemberQ[output,Result],
		Module[{uploadStorageConditionUpdates,uploadStorageConditionUpdatesCleaned,allUpdates},

			(* pass to UploadStorageCondition *)
			uploadStorageConditionUpdates=Lookup[rawOutputRules,Result];
			(* only output the sample/container objects for the user aspects *)
			uploadStorageConditionUpdatesCleaned=DeleteDuplicates[Cases[Flatten[ToList[uploadStorageConditionUpdates]],$Failed|ObjectP[Object[Sample]]|ObjectP[Object[Container]]]];
			allUpdates=Flatten[{maintenancePackets,uploadStorageConditionUpdatesCleaned}];
			maintenanceObjects=Cases[Lookup[maintenancePackets,Object],ObjectP[Object[Maintenance,StorageUpdate]]]//DeleteDuplicates;

			Which[
				MatchQ[allUpdates,$Failed|{$Failed}],
				$Failed,

				Lookup[myOptions,Upload],
				Module[{uploadReturn,confirmReturn},
					uploadReturn=Upload[allUpdates];
					(*If we upload we have to immediately confirm because I don't know what to do if user schedules a storage update and don't confirm the protocol. Not much chance to catch it.*)
					confirmReturn=If[Length[maintenanceObjects]>0&&TrueQ[confirm],ConfirmProtocol[maintenanceObjects],{}];
					Flatten[{uploadReturn,confirmReturn}]
				],
				True,
				allUpdates
			]
		],
		Null
	];

	(* return the output based on what was requested *)
	Return[outputSpecification/.{previewRule,userOpsRule,testsRule,resultRule}]
];



(* ::Subsubsection::Closed:: *)
(*StoreSamplesOptions*)


DefineOptions[StoreSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions:>{StoreSamples}
];


(* Overload 1: Singleton Input-- call CORE *)
StoreSamplesOptions[mySamples:ObjectP[{Object[Sample],Object[Item],Object[Container]}]|{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},myOpts:OptionsPattern[]]:=StoreSamplesOptions[mySamples,ConstantArray[None,Length[ToList[mySamples]]],myOpts];


(* CORE: two inputs *)
StoreSamplesOptions[mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],myStorages:ListableP[SampleStorageTypeP|Model[StorageCondition]|None],myOpts:OptionsPattern[]]:=Module[
	{listedOps,safeOps,outOps,returnOps,options,optionsWithConfirm},

	(* get the options as a list *)
	listedOps=ToList[myOpts];

	safeOps=SafeOptions[StoreSamplesOptions,listedOps];

	outOps=ReplaceRule[DeleteCases[safeOps,Alternatives[OutputFormat->_,Confirm->_]],{Output->{Options},QueueStorageUpdate->True}];

	returnOps=Flatten[UploadStorageCondition[ToList[mySamples],ToList[myStorages],outOps]];

	(* only return non-hidden options. and currently filters out QueueStorageUpdate *)
	options=Normal@KeyDrop[RemoveHiddenOptions[UploadStorageCondition,returnOps], QueueStorageUpdate];

	optionsWithConfirm=Join[options,{Confirm->Lookup[safeOps,Confirm,False]}];


	(* Return the option as a list or table *)
	If[MatchQ[Lookup[safeOps,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,StoreSamples],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*StoreSamplesPreview*)


DefineOptions[StoreSamplesPreview,
	SharedOptions :> {StoreSamples}
];

(* Overload 1: Singleton or multiple Inputs *)
StoreSamplesPreview[mySamples:ObjectP[{Object[Sample],Object[Item],Object[Container]}]|{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},ops:OptionsPattern[StoreSamplesPreview]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for StoreSamples *)
	StoreSamples[mySamples, Join[noOutputOptions,{Output ->Preview}]]

];

(* Overload 2: Single Input with Storage Type *)
StoreSamplesPreview[mySample:ObjectP[{Object[Sample],Object[Container]}],
	myStorage:(SampleStorageTypeP|ObjectP[Model[StorageCondition]]),
	myOpts:OptionsPattern[StoreSamplesOptions]]:=StoreSamplesPreview[{mySample},{myStorage},myOpts];


(* Overload 3: Listed Input with Storage Type *)
StoreSamplesPreview[mySamples:{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},myStorage:(SampleStorageTypeP|ObjectP[Model[StorageCondition]]),ops:OptionsPattern[StoreSamplesPreview]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for StoreSamples *)
	StoreSamples[mySamples,myStorage,Join[noOutputOptions,{Output ->Preview}]]

];

(* Overload 4: Listed Inputs *)
StoreSamplesPreview[mySamples:{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},myStorages:{(SampleStorageTypeP|ObjectP[Model[StorageCondition]])..},ops:OptionsPattern[StoreSamplesPreview]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for StoreSamples *)
	StoreSamples[mySamples,myStorages,Join[noOutputOptions,{Output ->Preview}]]

];



(* ::Subsubsection::Closed:: *)
(*ValidStoreSamplesQ*)


DefineOptions[ValidStoreSamplesQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {StoreSamples}
];

ValidStoreSamplesQ[mySamples:ObjectP[{Object[Sample],Object[Item],Object[Container]}]|{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},myOpts:OptionsPattern[]]:=ValidStoreSamplesQ[mySamples,ConstantArray[None,Length[ToList[mySamples]]],myOpts];

(* Overload 4: Listed Inputs *)
ValidStoreSamplesQ[mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],myStorages:ListableP[SampleStorageTypeP|ObjectP[Model[StorageCondition]]|None],myOpts:OptionsPattern[ValidStoreSamplesQ]]:=Module[
	{listedOps, preparedOptions, returnTests, initialTestDescription, allTests, verbose, outputFormat, listedSamples},

(* get the options as a list *)
	listedOps = ToList[myOpts];
	listedSamples = ToList[mySamples];

	(* remove the Output, Verbose option before passing to the core function *)
	preparedOptions = DeleteCases[listedOps, (Output|Verbose|OutputFormat) -> _];

	(* return only the tests for StoreSamples *)
	returnTests = StoreSamples[mySamples,myStorages,Join[preparedOptions,{Output ->{Tests}}]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[returnTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[listedSamples,OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Test[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedSamples,validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, returnTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]],OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidStoreSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidStoreSamplesQ"]

];

(* ::Subsection:: *)
(*ClearSampleStorageSchedule*)

DefineOptions[ClearSampleStorageSchedule,
	Options:>{
		OutputOption,
		UploadOption,
		FastTrackOption
	}
];

Warning::TooLateToCancelMaintenanceStorageUpdate="StorageSchedules for samples `1` contain Object[Maintenance,StorageUpdate] that has already started. We cannot clean this entry of StorageSchedule but have cleaned the rest.";

(* Shortcuts *)
ClearSampleStorageSchedule[]:={};
ClearSampleStorageSchedule[{}]:={};
(* Main function *)
ClearSampleStorageSchedule[mySamples:ListableP[ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]],myOptions:OptionsPattern[]]:=Module[
	{listedSamples,listedOps,idSamples,idOps, outputSpecification,output,gatherTests,messages,safeOptions, safeOptionTests,upload,fastTrack,cache,simulation,sampleDownloadFields,allDownloadedValue,samplesAndRelatedPackets,
		samplesAndRelatedPacketsFlattened,samplesAndRelatedObjects,samplesAndRelatedStorageSchedules,samplesAndRelatedDisposalLogs,locationProvidedStorageConditionLists,
		locationProvidedStorageConditions,allResponsibleParties,maintenanceStorageUpdateToClean,maintenanceScheduledMoves,maintenanceOperationStatus,tooLateMaintenances,
		samplesWithTooLates,samplesAndRelatedObjectsFlattend,cancelQ,maintenanceStorageUpdateToCancel,cancelProtocolPackages,otherProtocols,updatedPackets,updatedCache,
		sampleStatus,roamingSamples,allUpdateProtocols,prsUnableToClear
	},
	(* get listed inputs and options *)
	listedSamples=ToList[mySamples];
	listedOps=ToList[myOptions];


	(* determine the requested return value from the function *)
	outputSpecification=Quiet[OptionDefault[OptionValue[Output]],OptionValue::nodef];
	output=ToList[outputSpecification];

	(* determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];
	messages=!gatherTests;

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[ClearSampleStorageSchedule,listedOps,Output->{Result, Tests},AutoCorrect->False],
		{SafeOptions[ClearSampleStorageSchedule,listedOps,AutoCorrect->False],Null}
	];


	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->safeOptionTests,
			Options->$Failed,
			Preview->Null
		}]
	];

	{upload,fastTrack}=Lookup[safeOptions,{Upload,FastTrack}];

	(* ==== Download samples and its containers/contents ==== *)
	sampleDownloadFields=Map[
		Switch[#,
			TypeP[Object[Container]],
			{
				Packet@@{StorageSchedule,Status, Contents},
				Packet[Repeated[Field[Contents[[All,2]]]][{StorageSchedule}]],
				Packet[Field[StorageSchedule[[All,3]]][{ScheduledMoves,OperationStatus}]]
			},

			TypeP[NonSelfContainedSampleTypes],
			{
				Packet[Container[Field[Contents[[All,2]]]][{StorageSchedule,Status}]],
				Packet[Container[{StorageSchedule}]],
				Packet[Field[StorageSchedule[[All,3]]][{ScheduledMoves,OperationStatus}]]
			},

			TypeP[SelfContainedSampleTypes]|TypeP[{Object[Part],Object[Item],Object[Plumbing],Object[Wiring],Object[Sensor]}],
			{
				Packet@@{StorageSchedule,Status},
				Packet[],
				Packet[Field[StorageSchedule[[All,3]]][{ScheduledMoves,OperationStatus}]]
			}
		]&,
		Download[listedSamples,Type]
	];

	(* MAKE THE DOWNLOAD CALL *)
	allDownloadedValue=Quiet[
		Download[
			listedSamples,
			sampleDownloadFields,
			Date->Now
		],
		{Download::FieldDoesntExist,Download::NotLinkField, Download::ObjectDoesNotExist, Download::MissingField, Download::Part}
	];


	(* get the id form of all the samples to avoid trouble later in MatchQs *)
	idSamples=listedSamples[Object];

	(* get the storage condition-related fields of each sample and their related items such as contents or container or samples in the same container *)
	samplesAndRelatedPackets=allDownloadedValue[[All,{1,2}]];
	(* Flatten the packets under each sample, preserving shape *)
	samplesAndRelatedPacketsFlattened=Experiment`Private`FlattenCachePackets/@samplesAndRelatedPackets;

	(* Get the fields in each samples list of packets, preserving shape *)
	samplesAndRelatedObjects=Download[samplesAndRelatedPacketsFlattened,Object];
	(*The StorageSchedule should be the same among related objects as they are all boundled together*)
	samplesAndRelatedStorageSchedules=Download[samplesAndRelatedPacketsFlattened[[All,1]],StorageSchedule];

	(* -- Deal with ResponsibleParties -- *)
	allResponsibleParties=DeleteDuplicates[Cases[Flatten[samplesAndRelatedStorageSchedules],ObjectP[{Object[Protocol],Object[Qualification],Object[Maintenance],Object[User]}]]];

	(* Theoretically only MaintenanceStorageUpdate can get into the schedule. but just to be safe we filter the RPs *)
	maintenanceStorageUpdateToClean=Cases[allResponsibleParties,ObjectP[Object[Maintenance,StorageUpdate]]];
	(* download needed field *)
	updatedCache=Experiment`Private`FlattenCachePackets[allDownloadedValue];
	{maintenanceScheduledMoves,maintenanceOperationStatus}=If[MatchQ[maintenanceStorageUpdateToClean,{}],
		{{},{}},
		Download[maintenanceStorageUpdateToClean,{ScheduledMoves,OperationStatus},Cache->updatedCache]//Transpose
	]/.x:LinkP[]:>x[Object];



	(* if any of these protocols' OperationStatus are NOT None or OperatorStart, then we are too late to cancel them. Throw an warning and clean the rest*)
	tooLateMaintenances=PickList[maintenanceStorageUpdateToClean,maintenanceOperationStatus,Except[None|OperatorStart]];
	samplesWithTooLates=PickList[listedSamples,samplesAndRelatedStorageSchedules,_?(MemberQ[#,{_,_,ObjectP[tooLateMaintenances]}]&)];
	If[messages&&!fastTrack&&Length[samplesWithTooLates]>0,
		Message[Warning::TooLateToCancelMaintenanceStorageUpdate,samplesWithTooLates]
	];

	(*ScheduledMoves does not include non-self-containing samples-- they are all converted to their containers.
	since samplesAndRelatedObjectsFlattend includes all the containers of non-self-containing samples we just need to DeleteCases of Object[Sample] to achieve that too*)
	samplesAndRelatedObjectsFlattend=DeleteDuplicates[DeleteCases[Flatten[samplesAndRelatedObjects],ObjectP[Object[Sample]]]][Object];
	cancelQ=SubsetQ[samplesAndRelatedObjectsFlattend,#]&/@maintenanceScheduledMoves;

	maintenanceStorageUpdateToCancel=Complement[PickList[maintenanceStorageUpdateToClean,cancelQ],tooLateMaintenances];

	cancelProtocolPackages=UploadProtocolStatus[maintenanceStorageUpdateToCancel,Canceled,Upload->False,FastTrack->fastTrack,UpdatedBy->$PersonID];

	(* -- Update packets -- *)
	updatedPackets=MapThread[
		Function[{groupedObjects,groupedSchedule},
			Module[{InputSample,updatedSchedule,remainingNumbUpdates},

				InputSample=groupedObjects[[1]];
				updatedSchedule=DeleteCases[groupedSchedule,Except[{_,_,ObjectP[tooLateMaintenances]}]];
				remainingNumbUpdates=Length[updatedSchedule];

				Map[
					<|
						Object->#,
						Replace[StorageSchedule]->(updatedSchedule /. {x:LinkP[]:>RemoveLinkID[x]})
					|>&,
					groupedObjects
				]
			]
		],
		{samplesAndRelatedObjects,samplesAndRelatedStorageSchedules}
	];


	(* -- Generate outputs -- *)
	allUpdateProtocols=DeleteCases[Flatten[{cancelProtocolPackages,updatedPackets}],Except[PacketP[]]];

	If[upload,
		Upload[allUpdateProtocols],
		allUpdateProtocols
	]
];





(* ::Subsection::Closed:: *)
(*DiscardSamples*)


(* ::Subsubsection::Closed:: *)
(*DiscardSamples Options and Messages*)


DefineOptions[DiscardSamples,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"main input",
			{
				OptionName -> DiscardContainer,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type->Enumeration, Pattern :> (BooleanP)],
				Description -> "Indicates if the normally reusable container of a sample should be discarded instead of dishwashed or otherwise reused.",
				ResolutionDescription -> "Automatically resolves based on Reusable of container model."
			}
		],
		OutputOption,
		UploadOption,
		CacheOption,
		FastTrackOption,
		SimulationOption
	}
];


Error::ContainerDiscardRequired="The DiscardContainer option is set to False for the following inputs: `1`. However, these containers (or the containers of any samples) are not reusable. Please set the DiscardContainer option to True or Automatic for these inputs.";
Warning::ItemsContainerless="The DiscardContainer option will be ignored for the items `1`, which do not have containers. DiscardContainer will only have effect for samples or containers.";


(* ::Subsubsection::Closed:: *)
(*DiscardSamples*)


(* Singleton Input Overload *)
DiscardSamples[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]),myOptions:OptionsPattern[]]:=DiscardSamples[{mySample},myOptions];


(* Core Overload: Listed Input - Pass to UploadStorageCondition for Disposal *)
DiscardSamples[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..},myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples, listedOptions,
		outputSpecification, output, gatherTests, safeOptions, safeOptionTests,
		validLengths, validLengthTests,
		cache, inputPacketSpecs,inputDownloadTuples, newCache,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, resolvedPackets,
		resolvedOptionsMinusHiddenOptions, simulation,
		optionsRule, previewRule, testsRule, resultRule,
		allDownloadTuples
	},

	(* Make sure we're working with a list of options *)
	listedSamples=ToList[mySamples];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[DiscardSamples,listedOptions,AutoCorrect->False, Output -> {Result, Tests}],
		{SafeOptions[DiscardSamples,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[DiscardSamples,{listedSamples},safeOptions, Output -> {Result, Tests}],
			{ValidInputLengthsQ[DiscardSamples,{listedSamples},safeOptions],Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* ------------------------------ Download call ------------------------------  *)

	(* look up cache *)
	cache = Lookup[safeOptions, Cache];
	simulation = Lookup[safeOptions, Simulation];

	(* create packet specs for downloading from each of the input objects *)
	inputPacketSpecs=Map[
		Which[
			MatchQ[#, ObjectP[Object[User]]],
				{
					Packet[FinancingTeams],
					Packet[FinancingTeams[Notebooks]]
				},
			MatchQ[#,ObjectP[Object[Container]]],
				{
					Packet[Status,Contents,RequestedResources, Notebook],
					Packet[Model[{Reusable}]],
					Packet[RequestedResources[{Status}]],
					Packet[Field[Contents[[All,2]]][{AwaitingDisposal,Status,Container,StorageCondition,RequestedResources, Notebook}]],
					Packet[Field[Contents[[All,2]]][RequestedResources][{Status}]]
				},
			MatchQ[#,NonSelfContainedSampleP],
				{
					Packet[AwaitingDisposal,Status,Container,StorageCondition,RequestedResources, Notebook],
					Packet[Container[Model][{Reusable}]],
					Packet[Field[Container[Contents][[All,2]][{AwaitingDisposal,Status,Container,StorageCondition,RequestedResources, Notebook}]]],
					Packet[RequestedResources[{Status}]]
				},
			MatchQ[#,SelfContainedSampleP],
				{
					Packet[AwaitingDisposal,Status,Container,StorageCondition,RequestedResources, Notebook],
					Packet[RequestedResources[{Status}]]
				}
		]&,
		Join[{$PersonID}, listedSamples]
	];

	(* download information from the input samples according to these packet specs. Pass the cache *)
	allDownloadTuples=Download[Join[{$PersonID}, listedSamples],inputPacketSpecs, Cache -> cache, Simulation -> simulation];

	(* the rest of the download information is purely for UploadStorageCondition's cache; just flatten and remove duplicates on everything *)
	newCache = Flatten[{cache, DeleteDuplicatesBy[Cases[Flatten[allDownloadTuples],PacketP[]],Lookup[#,Object]&]}];

	(* isolate the input packets from $PersonID packet *)
	inputDownloadTuples = Rest[allDownloadTuples];

	(* ------------------------------ resolve all the options ------------------------------  *)

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{{resolvedOptions,resolvedPackets}, resolvedOptionsTests}=If[gatherTests,
			resolveDiscardSamplesOptions[listedSamples, inputDownloadTuples, safeOptions, Output->{Result,Tests}, Cache -> newCache, Simulation->simulation],
			{resolveDiscardSamplesOptions[listedSamples, inputDownloadTuples, safeOptions, Cache -> newCache, Simulation->simulation],{}}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* get all the safe options without the hidden options *)
	resolvedOptionsMinusHiddenOptions = RemoveHiddenOptions[DiscardSamples,resolvedOptions];

	(* ------------------------------ Generate rules for each possible Output value ------------------------------  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptionsMinusHiddenOptions,
		Null
	];

	(* There is nothing to preview, so always return Null *)
	previewRule = (Preview -> Null);

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests}],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result -> If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			discardSamplesResult[listedSamples, resolvedPackets, resolvedOptions]
		],
		Null
	];


	outputSpecification /. {previewRule,optionsRule,testsRule,resultRule}

];


(* ::Subsubsection::Closed:: *)
(*discardSamplesResult*)


(* check result and upload if requested *)
discardSamplesResult[listedSamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, resolvedPackets: {(PacketP[]|$Failed)..}, resolvedOps:OptionsPattern[]]:=Module[
	{

		upload, uploadReturn
	},

	(* assign options of discardSamplesResult to local variables *)
	upload = Lookup[resolvedOps,Upload];

	(* If any packet has $Failed, return $Failed *)
	If[AnyTrue[resolvedPackets, FailureQ],
		$Failed,
		(* return the duplicate-free list of updated objects if we upload, else return packets *)
		If[TrueQ[upload],
			(
				uploadReturn = Upload[resolvedPackets];
				DeleteDuplicates[uploadReturn]
			),
			resolvedPackets
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveDiscardSamplesOptions*)


DefineOptions[resolveDiscardSamplesOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	},
	SharedOptions :> {DiscardSamples}
];


(* resolves the options for DiscardSamples *)
(* NOTE: Output \[Rule] Result will return {options,packets} *)
resolveDiscardSamplesOptions[mySamples:{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},inputDownloadTuples_, myOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		safeOps,
		output, cache, listedOutput, collectTestsBoolean,
		expandedMySamples, expandedOptions, messagesBoolean,
		inputPackets,
		containerModelPackets, discardContainerList, resolvedDiscardContainerList,
		nonReusableNonDiscardTests, incorrectDiscardOptionNonReusableInputs,
		selfContainedSamplesWithDiscardContainerTests, selfContainedSamplesWithDiscardContainer,
		discardUpdatePackets, uniqueDiscardUpdatePackets,
		storageConditionUpdatePackets,storageConditionTests,
		allTests,resolvedOptions,collapsedOptions, uploadPackets, simulation
	},

	(* Make sure the input Options are safe to use *)
	safeOps=SafeOptions[resolveDiscardSamplesOptions, ToList[ops]];

	(* assign options of resolveDiscardSamplesOptions to local variables *)
	{output, cache, simulation} = Lookup[safeOps,{Output, Cache, Simulation}];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* expand options to match mySamples. In this case expandedMySamples is same as mySamples *)
	{{expandedMySamples},expandedOptions} = ExpandIndexMatchedInputs[DiscardSamples,{mySamples},myOptions];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* assign the core input packets (always at index 1 of packet spec) to a sensible local variable *)
	inputPackets=inputDownloadTuples[[All,1]];

	(* assign the container model packets to a sensible local variable; be conscious of self-contained samples not having a container model packet; leave Null *)
	containerModelPackets=MapThread[
		Function[{inputPacket,downloadTuple},
			If[MatchQ[inputPacket,PacketP[SelfContainedSampleTypes]],
				Null,
				downloadTuple[[2]]
			]
		],
		{inputPackets,inputDownloadTuples}
	];

	(* ------------------- Resolve DiscardContainer ------------------- *)

	(* lookup the DiscardContainer option *)
	discardContainerList = Lookup[expandedOptions,DiscardContainer];

	(* resolve the DiscardContainer option; contianerModelPacket is Null for self-contained samples, so set the option to Null in that case *)
	resolvedDiscardContainerList=MapThread[
		Function[{containerModelPacket,discardContainer},
			If[MatchQ[discardContainer,Automatic],
				If[NullQ[containerModelPacket],
					Null,
					!TrueQ[Lookup[containerModelPacket,Reusable]]
				],
				discardContainer
			]
		],
		{containerModelPackets,discardContainerList}
	];

	(* ------------------- Warnings & Tests ------------------- *)

	(* construct a test for each container: to check that if a container is non-resuable, discardContainer cannot be set to False *)
	nonReusableNonDiscardTests = If[collectTestsBoolean,
		MapThread[
			Function[{inputPacket,containerModelPacket,discardContainer},
				Test[ToString[Lookup[inputPacket,Object], InputForm]<>" cannot have the option DiscardContainer -> False unless it's container is Reusable.",
					!( MatchQ[discardContainer,False] && !NullQ[containerModelPacket]&& !TrueQ[Lookup[containerModelPacket,Reusable]] ),
					True
				]
			],
			{inputPackets,containerModelPackets,resolvedDiscardContainerList}
		],
		{}
	];

	(* pick out samples/containers where DiscardContainer is set to False, but Reusable is False; we don't allow this direction *)
	incorrectDiscardOptionNonReusableInputs=MapThread[
		Function[{inputPacket,containerModelPacket,discardContainer},
			If[MatchQ[discardContainer,False]&&!NullQ[containerModelPacket]&&!TrueQ[Lookup[containerModelPacket,Reusable]],
				Lookup[inputPacket,Object],
				Nothing
			]
		],
		{inputPackets,containerModelPackets,resolvedDiscardContainerList}
	];

	(* throw an error message if any inputs are trying to reuse a container that is not reusable *)
	If[MatchQ[incorrectDiscardOptionNonReusableInputs,{ObjectReferenceP[]..}],
		If[messagesBoolean, Message[Error::ContainerDiscardRequired,incorrectDiscardOptionNonReusableInputs];Message[Error::InvalidOption,DiscardContainer]]
	];

	(* construct a warning test for each container: to check that a self-contained sample should not have DiscardContainer set *)
	selfContainedSamplesWithDiscardContainerTests = If[collectTestsBoolean,
		MapThread[
			Function[{inputPacket,discardContainer},
				Warning[ToString[Lookup[inputPacket,Object], InputForm]<>" should not have DiscardContainer -> True if it is a self-contained sample.",
					!( TrueQ[discardContainer] && MatchQ[inputPacket,PacketP[SelfContainedSampleTypes]]),
					True
				]
			],
			{inputPackets,resolvedDiscardContainerList}
		],
		{}
	];

	(* pick out any self-contained samples that have DiscardContainer set; these will be ignored *)
	selfContainedSamplesWithDiscardContainer=MapThread[
		Function[{inputPacket,discardContainer},
			If[TrueQ[discardContainer]&&MatchQ[inputPacket,PacketP[SelfContainedSampleTypes]],
				Lookup[inputPacket,Object],
				Nothing
			]
		],
		{inputPackets,resolvedDiscardContainerList}
	];

	(* throw a soft message to indicate that we are ignoring DiscardContainer for these self-contained things *)
	If[MatchQ[selfContainedSamplesWithDiscardContainer,{ObjectReferenceP[]..}],
		If[messagesBoolean, Message[Warning::ItemsContainerless,selfContainedSamplesWithDiscardContainer]]
	];

	(* generate updates for the items to dispose (just set Reusable to False in the container object) *)
	discardUpdatePackets=MapThread[
		Function[{inputPacket,disposeContainer},
			If[TrueQ[disposeContainer],
				Which[
					MatchQ[inputPacket,PacketP[Object[Container]]],
						<|Object->Lookup[inputPacket,Object],Reusable->False|>,
					MatchQ[inputPacket,PacketP[NonSelfContainedSampleTypes]],
						<|Object->Download[Lookup[inputPacket,Container],Object],Reusable->False|>,
					MatchQ[inputPacket,PacketP[SelfContainedSampleTypes]],
						Nothing
				],
				Nothing
			]
		],
		{inputPackets,resolvedDiscardContainerList}
	];

	(* collapse duplicates, in case we were given many samples in the same container *)
	uniqueDiscardUpdatePackets=DeleteDuplicatesBy[discardUpdatePackets,Lookup[#,Object]&];

	(* Call UploadStorageCondition for disposal *)
	{storageConditionUpdatePackets,storageConditionTests}=If[collectTestsBoolean,
		UploadStorageCondition[expandedMySamples,Disposal,Upload->False,FastTrack->False,UpdatedBy->$PersonID,Cache->cache,Simulation->simulation,Output -> {Result, Tests}],
		{UploadStorageCondition[expandedMySamples,Disposal,Upload->False,FastTrack->False,UpdatedBy->$PersonID,Cache->cache,Simulation->simulation],{}}
	];

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = Flatten[{nonReusableNonDiscardTests,selfContainedSamplesWithDiscardContainerTests, storageConditionTests}];

	(* Update options *)
	resolvedOptions=ReplaceRule[myOptions,
		{
			DiscardContainer->resolvedDiscardContainerList
		}
	];

	(* join together all the change packets *)
	uploadPackets = Flatten[{uniqueDiscardUpdatePackets, storageConditionUpdatePackets}];

	(* collapse listed options if they are just repeating to singletons *)
	collapsedOptions=CollapseIndexMatchedOptions[resolveDiscardSamplesOptions, resolvedOptions,Messages->False,Ignore->ToList[myOptions]];

	output/.{Tests->allTests,Result -> {ReplaceRule[resolvedOptions,collapsedOptions], uploadPackets}}

];


(* ::Subsubsection::Closed:: *)
(*DiscardSamplesOptions*)


DefineOptions[DiscardSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {DiscardSamples}
];


(* Singleton Input Overload *)
DiscardSamplesOptions[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=DiscardSamplesOptions[{mySample}, ops];


(* Core Overload: return the options for this function *)
DiscardSamplesOptions[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, (Output | OutputFormat) -> _];

	(* return only the options for DiscardSamples *)
	options = DiscardSamples[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table unless it returned $Failed*)
	If[FailureQ[options],
		$Failed,
		(* it is not failure. display options according to OutputFormat *)
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[options,DiscardSamples],
			options
		]
	]

];


(* ::Subsubsection::Closed:: *)
(*DiscardSamplesPreview*)


DefineOptions[DiscardSamplesPreview,
	SharedOptions :> {DiscardSamples}
];


(* Singleton Input Overload *)
DiscardSamplesPreview[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=DiscardSamplesPreview[{mySample}, ops];


(* Core Overload: return the options for this function *)
DiscardSamplesPreview[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for DiscardSamples *)
	DiscardSamples[mySamples, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsubsection::Closed:: *)
(*ValidDiscardSamplesQ*)


DefineOptions[ValidDiscardSamplesQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {DiscardSamples}
];


(* Singleton Input Overload *)
ValidDiscardSamplesQ[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=ValidDiscardSamplesQ[{mySample}, ops];


(* Core Overload: return the options for this function *)
ValidDiscardSamplesQ[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, discardSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output, Verbose option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for DiscardSamples *)
	discardSamplesTests = DiscardSamples[mySamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[discardSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[mySamples, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{mySamples,validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, discardSamplesTests, voqWarnings}]
		]
	];


	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidDiscardSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidDiscardSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidDiscardSamplesQ"]

];


(* ::Subsection::Closed:: *)
(*CancelDiscardSamples*)


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamples Options and Messages*)


DefineOptions[CancelDiscardSamples,
	Options:>{
		OutputOption,
		UploadOption,
		CacheOption,
		FastTrackOption
	}
];


Warning::SamplesAlreadyDiscarded="Unfortunately, the samples `1` have already been permanently thrown out and can no longer be undiscarded. These samples have been excluded from these updates.";
Warning::ContainerConflict="Based on the provided input sample(s), all samples in the containers `1` and the container itself will no longer be queued for disposal as it is not possible to update only a subset of samples in a single container. You can run DiscardSamples on these containers if you wish all their samples to be discarded.";


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamples*)


(* Singleton Input Overload *)
CancelDiscardSamples[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), myOptions:OptionsPattern[]]:=CancelDiscardSamples[{mySample},myOptions];


(* Core Overload: Listed Input - Pass to UploadStorageCondition for Disposal *)
CancelDiscardSamples[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples, listedOptions, outputSpecification, output,
		gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		cache, inputPacketSpecs, inputDownloadTuples, newCache,
		resolvedOptionsResult, resolvedOptions,resolvedOptionsTests,
		resolvedOptionsMinusHiddenOptions,
		optionsRule, previewRule, testsRule, resultRule
	},

	(* Make sure we're working with a list of options *)
	listedSamples=ToList[mySamples];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[CancelDiscardSamples,listedOptions,AutoCorrect->False, Output -> {Result, Tests}],
		{SafeOptions[CancelDiscardSamples,listedOptions,AutoCorrect->False],{}}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[CancelDiscardSamples,{listedSamples},safeOptions, Output -> {Result, Tests}],
			{ValidInputLengthsQ[CancelDiscardSamples,{listedSamples},safeOptions],Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* ------------------------------ Download call ------------------------------  *)

	(* look up cache *)
	cache = Lookup[safeOptions, Cache];


	(* create packet specs for downloading from each of the input objects *)
	inputPacketSpecs=Map[
		Which[
			MatchQ[#,ObjectP[Object[Container]]],
				{
					Packet[Status,Contents]
				},
			MatchQ[#,NonSelfContainedSampleP],
				{
					Packet[Status,Container,AwaitingDisposal],
					Packet[Container[{Contents}]]
				},
			MatchQ[#,SelfContainedSampleP],
				{
					Packet[Status]
				}
		]&,
		mySamples
	];

	(* download information from the input samples according to these packet specs. Pass the cache *)
	inputDownloadTuples=Download[mySamples,inputPacketSpecs, Cache -> cache];

	(* the rest of the download information is purely for UploadStorageCondition's cache; just flatten and remove duplicates on everything *)
	newCache = Flatten[{cache, DeleteDuplicatesBy[Cases[Flatten[inputDownloadTuples],PacketP[]],Lookup[#,Object]&]}];

	(* ------------------------------ resolve all the options/errors ------------------------------  *)

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveCancelDiscardSamplesOptions[listedSamples, inputDownloadTuples, safeOptions, Output->{Result,Tests}, Cache -> newCache],
			{resolveCancelDiscardSamplesOptions[listedSamples, inputDownloadTuples, safeOptions, Cache -> newCache],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* get all the safe options without the hidden options *)
	resolvedOptionsMinusHiddenOptions = RemoveHiddenOptions[DiscardSamples,resolvedOptions];

	(* ------------------------------ Generate rules for each possible Output value ------------------------------  *)

		(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options->If[MemberQ[output,Options],
		resolvedOptionsMinusHiddenOptions,
		Null
	];

	(* There is nothing to preview, so always return Null *)
	previewRule = (Preview -> Null);

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests}],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result -> If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			cancelDiscardSamplesResult[listedSamples, inputDownloadTuples, resolvedOptions]
		],
		Null
	];

	outputSpecification /. {previewRule,optionsRule,testsRule,resultRule}

];


(* ::Subsubsection::Closed:: *)
(*cancelDiscardSamplesResult*)


DefineOptions[cancelDiscardSamplesResult,
	(* no need to inherit Output option *)
	SharedOptions :> {{CancelDiscardSamples,{Upload, Cache, FastTrack}}}
];


cancelDiscardSamplesResult[listedSamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, inputDownloadTuples_, resolvedOps:OptionsPattern[]]:=Module[
	{
		expandedOptions, expandedListedSamples,
		upload, cache, fastTrack,
		inputPackets, alreadyDiscardedSamplePackets, nonDiscardedInputDownloadTuples,
		allObjectsToUpdate, uploadPackets, uploadReturn
	},

	(* expand options to match mySamples. In this case expandedMySamples is same as mySamples *)
	{{expandedListedSamples},expandedOptions} = ExpandIndexMatchedInputs[CancelDiscardSamples,{listedSamples},resolvedOps];

	(* assign options to local variables *)
	{upload, cache, fastTrack} = Lookup[expandedOptions,{Upload, Cache, FastTrack}];

	(* assign the core input packets (always at index 1 of packet spec) to a sensible local variable *)
	inputPackets=inputDownloadTuples[[All,1]];

	(* pick out any discarded samples; these will be ignored *)
	alreadyDiscardedSamplePackets = Select[inputPackets,MatchQ[Lookup[#,Status],Discarded]&];

	(* pare down our downloaded tuples to ignore the already discarded stuff *)
	nonDiscardedInputDownloadTuples = Select[inputDownloadTuples,!MemberQ[alreadyDiscardedSamplePackets,#[[1]]]&];

	(*get all the objects we need to update *)
	allObjectsToUpdate=Flatten@Map[
		Function[inputPacket,
			Which[
				MatchQ[inputPacket,PacketP[Object[Container]]],
					Prepend[Download[Lookup[inputPacket,Contents][[All,2]],Object],Lookup[inputPacket,Object]],
				MatchQ[inputPacket,PacketP[NonSelfContainedSampleTypes]], (* Object[Sample] *)
					{Download[Lookup[inputPacket,Container][Contents][[All,2]],Object], Lookup[inputPacket,Container][Object]},
				MatchQ[inputPacket,PacketP[SelfContainedSampleTypes]], (* Object[Item] *)
					Lookup[inputPacket,Object]
			]
		],
		nonDiscardedInputDownloadTuples[[All,1]]
	];

	(*  make update packets *)
	uploadPackets = Map[
		<|
			Object->#,
			AwaitingDisposal->Null,
			Append[DisposalLog]->{{Now,False,Link[$PersonID]}}
		|>&,
		allObjectsToUpdate
	];

	(* return the duplicate-free list of updated objects if we upload, else return packets *)
	If[TrueQ[upload],
		(
			uploadReturn = Upload[uploadPackets];
			DeleteDuplicates[uploadReturn]
		),
		uploadPackets
	]
];


(* ::Subsubsection::Closed:: *)
(*resolveCancelDiscardSamplesOptions*)


DefineOptions[resolveCancelDiscardSamplesOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	},
	SharedOptions :> {CancelDiscardSamples}
];


(* resolves the options/errors for CancelDiscardSamples *)
resolveCancelDiscardSamplesOptions[mySamples:{ObjectP[{Object[Sample],Object[Item],Object[Container]}]..},inputDownloadTuples_, myOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{
		safeOps,
		output, cache, listedOutput, collectTestsBoolean,
		expandedMySamples, expandedOptions, messagesBoolean,
		inputPackets,
		alreadyDiscardedSampleTests, alreadyDiscardedSamplePackets, nonDiscardedInputDownloadTuples,
		nonSelfContainedDownloadTuplesBeingUnmarked, uniqueContainerPacketsBeingUnmarked,
		containerConflictTests, containerPacketsWithConflicts, allTests, resolvedOptions, collapsedOptions
	},

	(* Make sure the input Options are safe to use *)
	safeOps=SafeOptions[resolveCancelDiscardSamplesOptions, ToList[ops]];

	(* assign options of resolveDiscardSamplesOptions to local variables *)
	{output, cache} = Lookup[safeOps,{Output, Cache}];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* expand options to match mySamples. In this case expandedMySamples is same as mySamples *)
	{{expandedMySamples},expandedOptions} = ExpandIndexMatchedInputs[CancelDiscardSamples,{mySamples},myOptions];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* assign the core input packets (always at index 1 of packet spec) to a sensible local variable *)
	inputPackets=inputDownloadTuples[[All,1]];

	(* construct a warning test for each sample: to check if it has already been discarded *)
	alreadyDiscardedSampleTests = If[collectTestsBoolean,
		Warning[ToString[Lookup[#,Object], InputForm]<>" should not be discarded.",
			!MatchQ[Lookup[#,Status],Discarded],
			True
		]& /@ inputPackets,
		{}
	];

	(* pick out any discarded samples; these will be ignored *)
	alreadyDiscardedSamplePackets = Select[inputPackets,MatchQ[Lookup[#,Status],Discarded]&];

	(* throw a soft message to indicate that we are ignoring discarded samples *)
	If[MatchQ[alreadyDiscardedSamplePackets,{PacketP[]..}],
		If[messagesBoolean, Message[Warning::SamplesAlreadyDiscarded,Lookup[alreadyDiscardedSamplePackets,Object]]];
	];

	(* pare down our downloaded tuples to ignore the already discarded stuff *)
	nonDiscardedInputDownloadTuples = Select[inputDownloadTuples,!MemberQ[alreadyDiscardedSamplePackets,#[[1]]]&];

	(* detect all input tuples for non-self-contained samples that are currently actually set for Disposal (i.e. this function will actually change state) *)
	nonSelfContainedDownloadTuplesBeingUnmarked = Select[nonDiscardedInputDownloadTuples,MatchQ[#[[1]],PacketP[NonSelfContainedSampleTypes]]&&TrueQ[Lookup[#[[1]],AwaitingDisposal]]&];

	(* get the container packets at second tuple index; get just the unique packets *)
	uniqueContainerPacketsBeingUnmarked = DeleteDuplicatesBy[nonSelfContainedDownloadTuplesBeingUnmarked[[All,2]],Lookup[#,Object]&];

	(* construct a test for each container: to check that it doesn't have contents that are NOT in the input list to be undiscarded. This is not possible as we will be leaving behind sample in the container that are marked for disposal *)
	containerConflictTests = If[collectTestsBoolean,
		Test[ToString[Lookup[#,Object], InputForm]<>" is not left with some remaining contents still marked for disposal, after this CancelDiscardSamples call is executed.",
			MatchQ[
				Complement[
					Download[Lookup[#,Contents][[All,2]],Object],
					Lookup[nonSelfContainedDownloadTuplesBeingUnmarked[[All,1]],Object]
				],
				{}
			],
			True
		]& /@ uniqueContainerPacketsBeingUnmarked,
		{}
	];

	(* Pick out any containers with conflicts (i.e. left behind some samples that are marked for disposal. A container's contents must all be in same state *)
	containerPacketsWithConflicts = Select[
		uniqueContainerPacketsBeingUnmarked,
		!MatchQ[Complement[Download[Lookup[#,Contents][[All,2]],Object],Lookup[nonSelfContainedDownloadTuplesBeingUnmarked[[All,1]],Object]],{}]&
	];

	(* throw a warning message if any containers with conflicts found *)
	If[MatchQ[containerPacketsWithConflicts,{PacketP[]..}],
		If[messagesBoolean, Message[Warning::ContainerConflict,Lookup[containerPacketsWithConflicts,Object]]];
	];

	(* Gather all the tests (this will be a list of Nulls if !Output->Test) *)
	allTests = Flatten[{alreadyDiscardedSampleTests,containerConflictTests}];

	(* Update options *)
	resolvedOptions=ReplaceRule[myOptions,{}];

	(* collapse any options *)
	collapsedOptions=CollapseIndexMatchedOptions[resolveCancelDiscardSamplesOptions, resolvedOptions, Messages -> False, Ignore -> ToList[myOptions]];

	output/.{Tests->allTests,Result->ReplaceRule[resolvedOptions,collapsedOptions]}
];


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamplesOptions*)


DefineOptions[CancelDiscardSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {CancelDiscardSamples}
];


(* Singleton Input Overload *)
CancelDiscardSamplesOptions[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=CancelDiscardSamplesOptions[{mySample}, ops];


(* Core Overload: return the options for this function *)
CancelDiscardSamplesOptions[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, (Output | OutputFormat) -> _];

	(* return only the options for CancelDiscardSamples *)
	options = CancelDiscardSamples[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table unless it returned $Failed*)
	If[FailureQ[options],
		$Failed,
		(* it is not failure. display options according to OutputFormat *)
		If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
			LegacySLL`Private`optionsToTable[options,CancelDiscardSamples],
			options
		]
	]

];


(* ::Subsubsection::Closed:: *)
(*CancelDiscardSamplesPreview*)


DefineOptions[CancelDiscardSamplesPreview,
	SharedOptions :> {CancelDiscardSamples}
];


(* Singleton Input Overload *)
CancelDiscardSamplesPreview[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=CancelDiscardSamplesPreview[{mySample}, ops];


(* Core Overload: return the options for this function *)
CancelDiscardSamplesPreview[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for CancelDiscardSamples *)
	CancelDiscardSamples[mySamples, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsubsection::Closed:: *)
(*ValidCancelDiscardSamplesQ*)


DefineOptions[ValidCancelDiscardSamplesQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {CancelDiscardSamples}
];


(* Singleton Input Overload *)
ValidCancelDiscardSamplesQ[mySample:(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]]), ops:OptionsPattern[]]:=ValidCancelDiscardSamplesQ[{mySample}, ops];


(* Core Overload: return the options for this function *)
ValidCancelDiscardSamplesQ[mySamples:{(ObjectP[{Object[Sample],Object[Item]}]|ObjectP[Object[Container]])..}, ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, discardSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output, Verbose option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for CancelDiscardSamples *)
	discardSamplesTests = CancelDiscardSamples[mySamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[discardSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[mySamples, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{mySamples,validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, discardSamplesTests, voqWarnings}]
		]
	];


	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidDiscardSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidCancelDiscardSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidCancelDiscardSamplesQ"]

];


(* ::Subsection::Closed:: *)
(*ShipToUser*)

NonShippableTypesP = Alternatives[
	Object[Container,Bench],
	Object[Container,Building],
	Object[Container,Cabinet],
	Object[Container,Deck],
	Object[Container,Enclosure],
	Object[Container,FlammableCabinet],
	Object[Container,Floor],
	Object[Container,Room],
	Object[Container,Safe],
	Object[Container,Shelf],
	Object[Container,ShelvingUnit],
	Object[Container,Shipping],
	Object[Container,Site],
	Object[Container,OperatorCart],
	Object[Container,PortableCooler],
	Object[Container,PortableHeater],
	Object[Container,Rack,Dishwasher],
	Object[Container,Bag,Dishwasher],
	Object[Container,WashBin],
	Object[Container,WasteBin],
	Object[Container,Waste],
	Object[Container,Bench,Receiving],
	Object[Container,CentrifugeBucket],
	Object[Container,CentrifugeRotor],
	Object[Container,DosingHead],
	Object[Container,NMRSpinner],
	Object[Container,SyringeTool],
	Object[Container,Rack,InsulatedCooler],
	Object[Container,ReactionVessel],
	Object[Container,ReactionVessel,ElectrochemicalSynthesis],
	Object[Container,ReactionVessel,Microwave],
	Object[Container,ReactionVessel,SolidPhaseSynthesis],
	Object[Container,GasCylinder]
];

(* ::Subsubsection::Closed:: *)
(*ShipToUser Options and Messages*)


DefineOptions[ShipToUser,
	Options :> {
		IndexMatching[
			(* these options are all indexmatched with the input *)
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ColdPacking,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ColdPackingP],
				Description -> "Indicates if the samples should be shipped with ice or dry ice to keep them cool. Null indicates that the samples will ship at ambient temperature.",
				ResolutionDescription -> "Automatically resolves to Ice if the sample's storage condition is refrigerator, DryIce if the sample's storage condition is Freezer, DeepFreezer, or CryogenicStorage, and Null otherwise.",
				Category -> "Shipment"
			},
			{
				OptionName -> ShippingSpeed,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> ShippingSpeedP],
				Description -> "The delivery speed selected with the shipper of this transaction.",
				ResolutionDescription -> "Automatically resolves to FiveDay if the samples are shipped at ambient temperature, and to NextDay if the samples are shipped cold.",
				Category -> "Shipment"
			},
			{
				OptionName -> Destination,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Container, Site]]],
				Description -> "The site where the samples are being sent.",
				ResolutionDescription -> "Automatically resolves to the site of the financer of the notebook that generated this transaction.",
				Category -> "Shipment"
			},
			{
				OptionName -> Aliquot,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples which should be prepared and used in lieu of the SamplesIn for the transaction.",
				ResolutionDescription -> "Automatically resolves to True if any other aliquot options are set.",
				Category -> "AliquotPrep"
			},
			(* NOTE: This is only used in the primitive framework and is hidden in the standalone functions. *)
			{
				OptionName -> AliquotSampleLabel,
				Default -> Automatic,
				Description -> "The label of the samples, after they are aliquotted.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget->Widget[
					Type->String,
					Pattern:>_String,
					Size->Line
				]
			},
			{
				OptionName -> AliquotAmount,
				Default -> Automatic,
				Description -> "The amount of a sample that should be transferred from the input samples into aliquots.",
				ResolutionDescription -> "Automatically set as the smaller between the current sample volume and the maximum volume of the destination container if a liquid, or the current Mass or Count if a solid or counted item, respectively.",
				AllowNull -> True,
				Category -> "Aliquoting",
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					]
				]
			},
			{
				OptionName -> TargetConcentration,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 * Gram / Liter] | GreaterEqualP[0 * Micromolar],
					Units -> Alternatives[
						CompoundUnit[
							{-1, {Microliter, {Nanoliter, Microliter, Milliliter, Liter}}},
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram}}}
						],
						{Micromolar, {Micromolar, Millimolar, Molar}}
					]
				],
				Description -> "For each member of SamplesIn, the desired final concentration of analyte in the AliquotSamples which should be used in lieu of the SamplesIn for the transaction.",
				ResolutionDescription -> "Automatically resolves from ShipmentVolume and AliquotAmount.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> TargetConcentrationAnalyte,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[IdentityModelTypes],
					ObjectTypes -> IdentityModelTypes,
					PreparedSample -> False,
					PreparedContainer -> False
				],
				Description -> "The substance whose final concentration is attained with the TargetConcentration option.",
				ResolutionDescription -> "Automatically set to the first value in the Analytes field of the input sample, or, if not populated, to the first analyte in the Composition field of the input sample, or if none exist, the first identity model of any kind in the Composition field.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> ShipmentVolume,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.5 * Microliter, 20 * Liter],
					Units -> Alternatives[{Microliter, {Microliter, Milliliter, Liter}}]
				],
				Description -> "For each member of SamplesIn, the desired total volume of the AliquotSamples that will be sent in this transaction. This includes AliquotAmounts plus any buffer that is added to dilute the aliquot.",
				ResolutionDescription -> "Automatically resolves from AliquotAmount.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> ConcentratedBuffer,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample, StockSolution], Object[Sample], Model[Sample], Object[Sample]}]],
				Description -> "The desired concentrated buffer source which should be added to each of the AliquotSamples to obtain 1x buffer concentration after dilution of the AliquotSamples which should be used in lieu of the SamplesIn for the transaction.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> BufferDilutionFactor,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Number, Pattern :> GreaterEqualP[0]],
				Description -> "The dilution factor by which the concentrated buffer should be diluted in preparing the AliquotSamples to obtain a 1x buffer concentration after dilution of the AliquotSamples which should be used in lieu of the SamplesIn for the transaction.",
				ResolutionDescription -> "Automatically resolves from ConcentratedBuffer's dilution factor.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> BufferDiluent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample, StockSolution], Object[Sample], Model[Sample], Object[Sample]}]],
				Description -> "The desired diluent with which the concentrated buffer should be diluted in preparing the AliquotSamples to obtain a 1x buffer concentration after dilution of the AliquotSamples which should be used in lieu of the SamplesIn for the transaction.",
				ResolutionDescription -> "Automatically resolves from ConcentratedBuffer's PreferredDiluent.",
				Category -> "AliquotPrep"
			},
			{
				OptionName -> ShipmentBuffer,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample, StockSolution], Object[Sample], Model[Sample], Object[Sample]}]],
				Description -> "The final desired buffer for the AliquotSamples which should be used in lieu of the SamplesIn for the transaction.",
				Category -> "AliquotPrep"
			},
			(* These options are here for the Aliquot resolver to lookup the OptionDefinition of ShipToUser and figure out that the options are index-matching. *)
			{
				OptionName -> AssayVolume,
				Default -> Automatic,
				Description -> "The desired total volume of the aliquoted sample plus dilution buffer.",
				ResolutionDescription -> "Automatically determined based on Volume and TargetConcentration option values.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {Liter, {Microliter, Milliliter, Liter}}
				]
			},
			{
				OptionName -> AliquotSampleStorageCondition,
				Default -> Automatic,
				Description -> "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
			},
			{
				OptionName -> AssayBuffer,
				Default -> Automatic,
				Description -> "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume.",
				ResolutionDescription -> "Automatically resolves to Model[Sample, \"Milli-Q water\"] if ConcentratedBuffer is not specified; otherwise, resolves to Null.",
				AllowNull -> True,
				Category -> "Hidden",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample, StockSolution], Object[Sample], Model[Sample], Object[Sample]}],
					ObjectTypes -> {Model[Sample, StockSolution], Object[Sample], Model[Sample], Object[Sample]}
				]
			},
			{
				OptionName -> Fragile,
				Default -> Automatic,
				Description -> "Indicates if the item is easily damaged and should be wrapped with a bubble sheet before shipment.",
				ResolutionDescription -> "This is automatically determined by the Fragile field in the shipped container or item.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP | Automatic
				]
			}
		],
		(* these options are not indexmatched with the input *)
		{
			OptionName -> ConsolidateAliquots,
			Default -> Automatic,
			Description -> "Indicates if identical aliquots should be prepared in the same container/position.",
			AllowNull -> True,
			Category -> "Hidden",
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP]
		},
		{
			OptionName -> AliquotPreparation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> PreparationMethodP],
			Description -> "Indicates the desired method by which liquid handling used to generate aliquots will occur.",
			ResolutionDescription -> "Automatic resolution will occur based on manipulation volumes and container types.",
			Category -> "Hidden"
		},
		{
			OptionName -> Creator,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[User]]],
			Description -> "Indicates the person who placed this shipping transaction.",
			ResolutionDescription -> "Automatically resolves to $PersonID.",
			Category -> "Shipment"
		},
		{
			OptionName -> DestinationWell,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives @@ Flatten[AllWells[]],
					PatternTooltip -> "Enumeration must be any well from A1 to H12."
				],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives @@ Flatten[{AllWells[], Automatic, Null}],
						PatternTooltip -> "Enumeration must be any well from A1 to H12."
					]
				],
				Adder[
					Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[{AllWells[], Automatic, Null}],
							PatternTooltip -> "Enumeration must be any well from A1 to H12."
						],
						Adder[
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives @@ Flatten[{AllWells[], Automatic, Null}],
								PatternTooltip -> "Enumeration must be any well from A1 to H12."
							]
						]
					]
				]
			],
			Description -> "The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed.",
			ResolutionDescription -> "Automatically resolves to A1 in containers with only one position.  For plates, fills wells in the order provided by the function AllWells."
		},
		{
			OptionName -> AliquotContainer,
			Default -> Automatic,
			Description -> "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired.",
			ResolutionDescription -> "Automatically set as the PreferredContainer for the ShipmentVolume of the sample.  For plates, attempts to fill all wells of a single plate with the same model before aliquoting into the next.",
			AllowNull -> True,
			Category -> "Aliquoting",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Container], Object[Container]}],
					ObjectTypes -> {Model[Container], Object[Container]}
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Automatic, Null]
				],
				{
					"Index" -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Container" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				},
				Adder[
					Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Container], Object[Container]}],
							ObjectTypes -> {Model[Container], Object[Container]}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				],
				Adder[
					Alternatives[
						{
							"Index" -> Alternatives[
								Widget[
									Type -> Number,
									Pattern :> GreaterEqualP[1, 1]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							],
							"Container" -> Alternatives[
								Widget[
									Type -> Object,
									Pattern :> ObjectP[{Model[Container], Object[Container]}],
									ObjectTypes -> {Model[Container], Object[Container]}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic, Null]
								]
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				]
			]
		},
		{
			OptionName -> Output,
			Default -> Result,
			AllowNull -> False,
			Widget -> Alternatives[
				Adder[Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP]],
				Widget[Type -> Enumeration, Pattern :> CommandBuilderOutputP]
			],
			Category -> "Hidden",
			Description -> "Indicate what the function should return."
		},
		CacheOption,
		UploadOption,
		FastTrackOption,
		EmailOption
	}
];

Error::NoDestination = "Destination could not be resolved from the notebook calling this function. Please ensure that your notebook has an associated financing team and that that team has an associated site, or specify a destination with the Destination option.";
Warning::ContainersSpanShipments = "In order to ship samples with the provided ShippingSpeed and ColdPacking specifications, samples that currently occupy the following containers, will be transferred to separate containers.";
Warning::ContainersIncludeAdditionalSamples = "Your input samples occupy a container that contains other samples that are not designated for shipping: `1`. The samples will be transferred to separate containers.";
Error::SiteNotFound = "No site was found for `1`. Please confirm that the samples are located at a site.";
Error::OwnershipConflict = "The inputs `1` do not belong to the your financing team. Please ensure that all inputs belong to a laboratory notebook financed by your team and try again.";
Error::NotShippable = "The inputs `1` cannot be shipped. Please check the inputs to ensure they can be reasonable shipped to destination and try again.";
Error::NoAvailableSecondaryContainers = "The following inputs `1` cannot be shipped because they are too large and cannot fit in any secondary container used by ECL at this time.  Please divide the sample into multiple smaller containers and try again.";
Error::HazardousSamplesForShipping = "The following input samples are considered hazardous for shipping and require special handling that's not currently available. Please check these samples: \n`1`.\n The following properties prevent these samples from being shipped:\n {`2`}.";

(* ::Subsubsection::Closed:: *)
(*ShipToUser Function*)

ShipToUser[mySamples:ListableP[ObjectP[{Object[Sample],Object[Item]}]], myOptions:OptionsPattern[]]:=shipFromECL[
	mySamples,
	ShipToUser,
	myOptions
];


(*-- Function overload accepting container objects as sample inputs --*)
ShipToUser[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Object[Item]}]], myOptions:OptionsPattern[]]:=Module[
	{
		listedSamples,listedOptions,containerToSampleResult,containerToSampleOutput,containerToSampleTests,
		outputSpecification,output,gatherTests,safeOptions,safeOptionTests,samples,sampleOptions,
		shippableContainerCheck,nonShippableInputs,nonShippableInputsTest,sampleCache
	},

	(* Make sure the samples and the options are in a list *)
	listedSamples=ToList[Download[myContainers,Object]];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(*Call SafeOptions to make sure all options match pattern*)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ShipToUser,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ShipToUser,listedOptions,AutoCorrect->False],Null}];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- Input container type check --*)

	(* If an input is a container, it must be shippable *)
	shippableContainerCheck=Map[
		MatchQ[#,ObjectP[List@@NonShippableTypesP]]&,
		listedSamples
	];

	(* Input objects that cannot be shipped *)
	nonShippableInputs=PickList[listedSamples,shippableContainerCheck,True];

	(* If there are input objects that are not shippable and we are throwing messages, throw an error message *)
	If[Length[nonShippableInputs]>0&&!gatherTests,
		Message[Error::NotShippable,nonShippableInputs]
	];

	(* generate tests if we are collecting them *)
	nonShippableInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[nonShippableInputs,{}],
				Nothing,
				Test["The inputs "<>ObjectToString[nonShippableInputs]<>" can be shipped in a reasonable manner:",True,False]
			];

			passingTest=If[MatchQ[nonShippableInputs,{}],
				Nothing,
				Test["The inputs "<>ObjectToString[Complement[listedSamples,nonShippableInputs]]<>" can be shipped in a reasonable manner:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* If any of the input objects cannot actually be shipped, we need to return early *)
	(* return $Failed for Results, or the options, or all the tests that have been generated so far) *)
	If[!MatchQ[nonShippableInputs,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,nonShippableInputsTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* containerToSampleOptions *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=Experiment`Private`containerToSampleOptions[
			ShipToUser,
			listedSamples,
			listedOptions,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=Experiment`Private`containerToSampleOptions[
				ShipToUser,
				listedSamples,
				listedOptions,
				Output->Result
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early *)
	If[MatchQ[containerToSampleResult,ListableP[$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ShipToUser[
			samples,
			sampleOptions
		]
	]
];



(* ::Subsubsection::Closed:: *)
(*ShipToUserOptions*)


DefineOptions[ShipToUserOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {ShipToUser}
];


(* Core Overload: return the options for this function *)
ShipToUserOptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],
	myOptions:OptionsPattern[ShipToUserOptions]
]:=Module[
	{listedOptions, preparedOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (OutputFormat->_)| (Output->_)];

	(* return only the options for ShipToUser *)
	options = ShipToUser[mySamples, Append[preparedOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ShipToUser],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*ShipToUserPreview*)


DefineOptions[ShipToUserPreview,
	SharedOptions :> {ShipToUser}
];

ShipToUserPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],
	myOptions:OptionsPattern[ShipToUserPreview]
]:=Module[
	{listedOptions, preparedOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for RestrictSamples *)
	ShipToUser[mySamples, Append[preparedOptions, Output -> Preview]]

];



(* ::Subsubsection::Closed:: *)
(*ValidShipToUserQ*)


DefineOptions[ValidShipToUserQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ShipToUser}
];

ValidShipToUserQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container]}]],
	myOptions:OptionsPattern[ValidShipToUserQ]
]:=Module[
	{listedOptions, listedSamples, preparedOptions,shipToUserTests,initialTestDescription,allTests, verbose, outputFormat},

	listedOptions = ToList[myOptions];
	listedSamples = ToList[mySamples];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Call the function to get a list of tests *)
	shipToUserTests=ShipToUser[mySamples,Append[preparedOptions, Output->Tests]];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[shipToUserTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[listedSamples,OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedSamples,validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, shipToUserTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidRestrictSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidShipToUserQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidShipToUserQ"]
];



(* ::Subsection::Closed:: *)
(*ShipBetweenSites*)

(* ::Subsubsection::Closed:: *)
(*ShipBetweenSites Options and Messages*)


DefineOptions[ShipBetweenSites,
	Options:>{
		IndexMatching[
			(* these options are all indexmatched with the input *)
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Amount,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Volume"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count"->Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					]
				],
				Description -> "Indicates the amount of sample shipped.",
				Category->"Protocol"
			},
			{
				OptionName -> Container,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]],
					ObjectTypes -> {Model[Container]}
				],
				Description -> "Indicates the container model that sample will be shipped in.",
				Category->"Protocol"
			},
			{
				OptionName -> DependentProtocol,
				Default -> None,
				Description -> "The protocol (if any) that is dependent on each item being ordered to begin or continue execution.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Hidden"
			},
			{
				OptionName -> DependentResource,
				Default -> None,
				Description -> "The resource (if any) that is dependent on each item being ordered to begin or continue execution.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Resource, Sample]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Hidden"
			}
		]
	},
	(* take all of the shared options from ShipToUser except destination, as this is an argument for ShipBetweenSites *)
	SharedOptions :> {
		{ShipToUser, ToExpression[DeleteCases[Keys[Options[ShipToUser]], Destination]]}
	}
];


(* ::Subsubsection::Closed:: *)
(*ShipBetweenSites Function*)

(* Ship between sites refers to movement of samples from one ECL site to another. This includes any instances of private clouds. *)

ShipBetweenSites[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Model[Item], Model[Sample], Model[Container]}]],
	destinationSite:ObjectP[Object[Container, Site]],
	myOptions:OptionsPattern[]
]:= shipFromECL[
	mySamples,
	ShipBetweenSites,
	ReplaceRule[ToList[myOptions], {Destination -> destinationSite}]
];


(*-- Function overload accepting container objects as sample inputs --*)
ShipBetweenSites[
	myContainers:ListableP[ObjectP[{Object[Sample],Object[Item], Object[Container], Model[Item], Model[Sample], Model[Container]}]],
	destinationSite:ObjectP[Object[Container, Site]],
	myOptions:OptionsPattern[]
]:=Module[
	{
		listedSamples,listedOptions,containerToSampleResult,containerToSampleOutput,containerToSampleTests,
		outputSpecification,output,gatherTests,safeOptions,safeOptionTests,samples,sampleOptions,
		shippableContainerCheck,nonShippableInputs,nonShippableInputsTest,sampleCache
	},

	(* Make sure the samples and the options are in a list *)
	listedSamples=ToList[Download[myContainers,Object]];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(*Call SafeOptions to make sure all options match pattern*)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ShipBetweenSites,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ShipBetweenSites,listedOptions,AutoCorrect->False],Null}];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- Input container type check --*)

	(* If an input is a container, it must be shippable *)
	shippableContainerCheck=Map[
		MatchQ[#,ObjectP[List@@NonShippableTypesP]]&,
		listedSamples
	];

	(* Input objects that cannot be shipped *)
	nonShippableInputs=PickList[listedSamples,shippableContainerCheck,True];

	(* If there are input objects that are not shippable and we are throwing messages, throw an error message *)
	If[Length[nonShippableInputs]>0&&!gatherTests,
		Message[Error::NotShippable,nonShippableInputs]
	];

	(* generate tests if we are collecting them *)
	nonShippableInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[nonShippableInputs,{}],
				Nothing,
				Test["The inputs "<>ObjectToString[nonShippableInputs]<>" can be shipped in a reasonable manner:",True,False]
			];

			passingTest=If[MatchQ[nonShippableInputs,{}],
				Nothing,
				Test["The inputs "<>ObjectToString[Complement[listedSamples,nonShippableInputs]]<>" can be shipped in a reasonable manner:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* If any of the input objects cannot actually be shipped, we need to return early *)
	(* return $Failed for Results, or the options, or all the tests that have been generated so far) *)
	If[!MatchQ[nonShippableInputs,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,nonShippableInputsTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* containerToSampleOptions *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests}=Experiment`Private`containerToSampleOptions[
			ShipBetweenSites,
			listedSamples,
			listedOptions,
			Output->{Result,Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput=Experiment`Private`containerToSampleOptions[
				ShipBetweenSites,
				listedSamples,
				listedOptions,
				Output->Result
			],
			$Failed,
			{Error::EmptyContainer}
		]
	];

	(* If we were given an empty container, return early *)
	If[MatchQ[containerToSampleResult,ListableP[$Failed]],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples,sampleOptions, sampleCache}=containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ShipBetweenSites[
			samples,
			destinationSite,
			sampleOptions
		]
	]
];




(* ::Subsubsection::Closed:: *)
(*ShipBetweenSitesOptions*)


DefineOptions[ShipBetweenSitesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {ShipBetweenSites}
];


(* Core Overload: return the options for this function *)
ShipBetweenSitesOptions[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container], Model[Container], Model[Item], Model[Sample]}]],
	destinationSite:ObjectP[Object[Container, Site]],
	myOptions:OptionsPattern[ShipBetweenSitesOptions]
]:=Module[
	{listedOptions, preparedOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (OutputFormat->_)| (Output->_)];

	(* return only the options for ShipToUser *)
	options = ShipBetweenSites[mySamples, destinationSite, Append[preparedOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ShipBetweenSites],
		options
	]

];



(* ::Subsubsection::Closed:: *)
(*ShipBetweenSitesPreview*)


DefineOptions[ShipBetweenSitesPreview,
	SharedOptions :> {ShipBetweenSites}
];

ShipBetweenSitesPreview[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container], Model[Container], Model[Item], Model[Sample]}]],
	destinationSite:ObjectP[Object[Container, Site]],
	myOptions:OptionsPattern[ShipBetweenSitesPreview]
]:=Module[
	{listedOptions, preparedOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for RestrictSamples *)
	ShipBetweenSites[mySamples, destinationSite, Append[preparedOptions, Output -> Preview]]
];


(* ::Subsubsection::Closed:: *)
(*ValidShipBetweenSitesQ*)


DefineOptions[ValidShipBetweenSitesQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ShipBetweenSites}
];

ValidShipBetweenSitesQ[
	mySamples:ListableP[ObjectP[{Object[Sample],Object[Item],Object[Container], Model[Container], Model[Item], Model[Sample]}]],
	destinationSite:ObjectP[Object[Container, Site]],
	myOptions:OptionsPattern[ValidShipBetweenSitesQ]
]:=Module[
	{listedOptions, listedSamples, preparedOptions,shipToUserTests,initialTestDescription,allTests, verbose, outputFormat},

	listedOptions = ToList[myOptions];
	listedSamples = ToList[mySamples];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* Call the function to get a list of tests *)
	shipToUserTests=ShipBetweenSites[mySamples,destinationSite, Append[preparedOptions, Output->Tests]];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[shipToUserTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[listedSamples,OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{listedSamples,validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, shipToUserTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidShipBetweenSitesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidShipBetweenSitesQ"]
];


(* ::Subsection::Closed:: *)
(*shipFromECL*)

(* ::Subsubsection::Closed:: *)
(*shipFromECL Options*)

DefineOptions[shipFromECL,
	SharedOptions:>{ShipToUser, ShipBetweenSites}
];

(* ::Subsubsection::Closed:: *)
(*shipFromECL Function*)

(*because the behavior is so different, split inputs by model/sample and only resolve the relevant options for each. *)
(* thread things back together for the options, then split apart again by the source/destination *)
(* only resolve options appropriate for the parent input type *)

shipFromECL[mySamples : ListableP[ObjectP[{Object[Sample], Object[Item], Model[Sample], Model[Item], Model[Container]}]], parentFunction : (ShipToUser | ShipBetweenSites), myOptions : OptionsPattern[]] := Module[
	{
		listedSamples, listedOptions, outputSpecification, output, gatherTests, messagesBoolean, safeOptions, safeOptionTests,
		validLengths, validLengthTests, bagsAndBoxes, modelBoxes, modelBags, sampleDeepContainers, sampleLocations, fastTrackOption, uploadOption,
		cacheOption, creator, siteTest, uniqueSampleLocations, downloadedDestination, aliquotContainerPositions, financedNotebooks,
		sampleContainerContents, storageConditions, unflatSamplePackets, unflatContainerPackets, unflatSampleModelPackets,
		unflatContainerModelPackets, unflatAliquotContainerModelPackets, modelBoxInfo, modelBagInfo, iceInfo, dryIceInfo, peanutInfo,
		plateSealInfo, maintenanceShippingModelInfo, samplePackets, containerPackets, sampleModelPackets, containerModelPackets,
		aliquotContainerModelPackets, modelBoxPackets, modelBagPackets, icePackets, dryIcePackets, peanutPackets, plateSealPackets,
		maintenanceShippingModelPackets, sampleImmediateContainers, allContainedSamples, ownedInputsCheck, nonOwnedInputs, ownedInputsTest, inputObjectNotebooks,
		containedSamplesTest, cleanDestination, cleanStorageConditions, templateTests, resolvedTargetConcentrationAnalyte,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, resolvedShippingSpeed, resolvedColdPacking, resolvedAliquotAmount,
		resolvedTargetConcentration, resolvedShipmentVolume, resolvedDestination, samplesWithLocationsOptions,
		partitionedSamplesAndInfo, partitionedSamples, partitionedSites, partitionedShippingSpeed, partitionedColdPacking,
		partitionedContainers, partitionedAliquotAmount, partitionedTargetConcentration, partitionedShipmentVolume,
		partitionedSamplePackets, partitionedContainerPackets, partitionedSampleModelPackets, partitionedContainerModelPackets,
		partitionedDestinations, partitionedContainersIn, containerTallies, splitContainers, splitContainerTestDescription, splitContainerTest,
		frqResultsPerGroup,frqTestsPerGroup, collapsedResolvedOptions, partitionedAliquotOptionSets, transactionPackets, nullBagSamples, nullBagTest,
		reKeyedTransactionPackets, shippingMaterialsPacketsByTransaction, materialsByTransaction, indexGroupingByTransaction,
		groupedContentsByTransaction, groupedContentModelPacketsByTransaction, boxesByTransaction, hazardFieldValuePatterns,
		iceByTransaction, dryIceByTransaction, paddingByTransaction, bagsByTransaction, plateSealsByTransaction,
		transactionMaterialsUpdates, transactionStatusPackets, protocolUpdatePackets, mainFunctionTests, allUploads, resolvedOptionsMinusHiddenOptions,
		optionsRule, previewRule, testsRule, resultRule, samplesWithoutSite, expandedSafeOptions, templatedOptions, inheritedOptions,
		stowawaySamples, cacheBall, partitionedAliquot, partitionedConcentratedBuffer, partitionedBufferDilutionFactor,
		partitionedBufferDiluent, partitionedShipmentBuffer, partitionedAliquotSampleStorageCondition, modelHazardFieldValues,
		partitionedDestinationWell, partitionedAliquotContainer, resolvedAliquot, hazardFields, hazardousSampleRules,
		resolvedConcentratedBuffer, resolvedBufferDilutionFactor, resolvedBufferDiluent, resolvedShipmentBuffer,
		resolvedAliquotSampleStorageCondition, resolvedDestinationWell, resolvedAliquotContainer, exceptionAmounts,
		safeOptionsWithoutAssayVolumeAssayBuffer, transactionPacketsExtraFields, partitionedTargetConcentrationAnalyte,
		resolvedAliquotSampleLabel, partitionedAliquotSampleLabel, resolvedAmount, resolvedContainerModel, partitionedAmount, partitionedContainerModels,
		partitionedDependentProtocol, partitionedDependentResource, resolvedDependentProtocol, resolvedDependentResource, newTransactions, resolvedFragile,
		partitionedFragile, hazardousSampleWithFields, hazardousSamplesTest, listedSampleDownloads, rawUniqueSampleLocationDownloads,
		notebookDownloads, uniqueSampleLocationDownloads, rawSampleContainerContents, rawUnflatSamplePackets, rawUnflatContainerPackets,
		rawUnflatSampleModelPackets, rawUnflatContainerModelPackets, rawIceInfo, rawDryIceInfo, rawPeanutInfo, shipmentAmounts,
		rawPlateSealInfo, rawMaintenanceShippingModelInfo, hazardFieldLookup, objectHazardFieldValues, hazardExceptionPatterns
	},

	(* ------------ *)
	(* -- Set Up -- *)
	(* ------------ *)

	(*Make sure the samples and the options are in a list*)
	listedSamples=ToList[Download[mySamples,Object]];
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messagesBoolean = !gatherTests;

	(*Call SafeOptions to make sure all options match pattern*)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[shipFromECL,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[shipFromECL,listedOptions,AutoCorrect->False],Null}];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* We need to include the AssayVolume and AssayBuffer options to make the shared funtopia functions work (specifically the aliquot resolver,
		which calls the simulated samples function, which looks at the type definition. )
		but we call these options ShipmentVolume and ShipmentBuffer instead, so we make the AssayVolume and AssayBuffer options hidden.
		Remove the AssayVolume and AssayBuffer options here so that we don't double specify them when calling the aliquot resolver
*)
	safeOptionsWithoutAssayVolumeAssayBuffer=Normal[KeyDrop[safeOptions, {AssayVolume, AssayBuffer}]];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[shipFromECL,{listedSamples, parentFunction},listedOptions,Output->{Result,Tests}],
		{ValidInputLengthsQ[shipFromECL,{listedSamples, parentFunction},listedOptions],Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*Use any template options to get values for options not specified in myOptions*)
	{templatedOptions,templateTests}=If[gatherTests,
		ApplyTemplateOptions[shipFromECL,{listedSamples, parentFunction},listedOptions,Output->{Result,Tests}],
		{ApplyTemplateOptions[shipFromECL,{listedSamples, parentFunction},listedOptions],Null}];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests,validLengthTests,templateTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOptionsWithoutAssayVolumeAssayBuffer,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOptions=Last[ExpandIndexMatchedInputs[shipFromECL,{listedSamples, parentFunction},inheritedOptions]];

	(*Pull out non-listable option values*)
	{fastTrackOption,uploadOption,cacheOption,creator} = Lookup[expandedSafeOptions,{FastTrack,Upload,Cache,Creator}];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* ---- Gather information that we want to download from and then make the big download call ---- *)

	(* Find all the boxes and boxes that can be used for shipping *)
	bagsAndBoxes=Search[{Model[Container,Box],Model[Container,Bag]},EngineDefault==True];
	modelBoxes=Cases[bagsAndBoxes,ObjectP[Model[Container,Box]]];
	modelBags=Cases[bagsAndBoxes,ObjectP[Model[Container,Bag]]];

	(*TODO: with the model inputs, we wont know that the Site is until we decide how to fulfill it*)
	(* Get the location for each container *)
	(* It is faster to figure out the source site first and then do a second download with this object known
		than it is to do the download all at once due to the Container.. call *)
	(*model requests do not have a source site*)
	sampleDeepContainers=Quiet[Download[listedSamples,Container.., Date -> Now], Download::FieldDoesntExist];

	(* Figure out the source based on the sample site (its top-level container).
	 	For samples that don't have a container at all, set the Location to Null, we will catch those down below *)
	sampleLocations=MapThread[
		If[MatchQ[#1,{}|$Failed],
			Null,
			Download[Flatten[#1[[-1]]],Object]
		]&,
		{sampleDeepContainers}
	];

	(* Find any object samples that don't have a site. Dont worry about the site for models because it is not resolved until way way when the maintenance shipping this thing is confirmed *)
	samplesWithoutSite = Cases[Transpose[{listedSamples, sampleLocations}], {ObjectP[Object], Except[ObjectP[Object[Container, Site]]]}][[All,1]];

	(* If there are samples without a site and we are throwing messages, throw an error message .*)
	If[Length[samplesWithoutSite]>0&&!gatherTests,
		Message[Error::SiteNotFound, samplesWithoutSite];
		Message[Error::InvalidInput,samplesWithoutSite]
	];

	(* Make tests for samples having site if we are gathering tests *)
	siteTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[samplesWithoutSite,{}],
				Nothing,
				Test["The site of the inputs "<>samplesWithoutSite<>" is known:",True,False]
			];

			passingTest=If[Length[samplesWithoutSite]==Length[listedSamples],
				Nothing,
				Test["The site of the inputs "<>samplesWithoutSite<>" is known:",True,True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(* If the site check returned $Failed, then need to return early here since we can't download the proper information in the big download call below *)
	(* return $Failed for Results, or the ExpandedSafeOptions, or all the tests that have been generated so far) *)
	If[!MatchQ[samplesWithoutSite,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{validLengthTests,safeOptionTests,siteTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* We just want to do the second download on the unique sites to make it faster *)
	uniqueSampleLocations=DeleteDuplicates[sampleLocations];

	(* hazard fields: the samples with hazard field populated need special handling and will return error in this function *)
	(* the format for entering hazard fields values:
	{
		hazard field name,
		hazard value pattern: if the hazard value matches the hazard pattern, an error is thrown, unless it matches exception hazard pattern and sample amount is less than exception amount
		exception hazard pattern: if hazard value matches exception hazard pattern and sample amount is less than exception amount, error is not thrown
		exception amount: the maximum amount of hazardous sample (hazard value matches exception hazard pattern) that can be shipped without special treatment
	}*)
	{hazardFields, hazardFieldValuePatterns, hazardExceptionPatterns, exceptionAmounts} = Transpose[{
		{Pyrophoric, True, None, 0},
		{Flammable, True, True, 100 (* Gram or Milliliter *)},
		{Fuming, True, None, 0},
		{Acid, True, True, 100 (* Gram or Milliliter *)},
		{Base, True, True, 100 (* Gram or Milliliter *)},
		{HazardousBan, True, None, 0},
		{ParticularlyHazardousSubstance, True, None, 0},
		{Radioactive, True, None, 0},
		{
			NFPA,
			KeyValuePattern[(_ -> GreaterEqualP[1])] | KeyValuePattern[(Special -> Except[{Null ...} | Null])],
			KeyValuePattern[(_ -> GreaterEqualP[1])] | KeyValuePattern[(Special -> Acid)],
			100 (* Gram or Milliliter *)
		},
		{
			DOTHazardClass,
			Except["Class 0" | Null],
			"Class 3 Flammable Liquids Hazard",
			100 (* Gram or Milliliter *)
		},
		{BiosafetyLevel, Except["BSL-1" | Null], None, 0}
	}];

	(* Download all needed information.
		Get the notebook's team's site,
		Get the positions of the aliquot container, if one is specified,
		Get the container (all the way up to site) of each sample,
		Get the contents of each sample container,Get the storage condition of each sample and the default storage condition of their models,
		Get the sample models, sample container model, sample model densities, sample container model dimensions,aliquot container model dimensions (needed for predicting packing materials),
		Get info about the packing materials *)

	{
		listedSampleDownloads,
		notebookDownloads,
		aliquotContainerPositions,
		unflatAliquotContainerModelPackets,
		modelBoxInfo,
		modelBagInfo,
		rawUniqueSampleLocationDownloads
	} = Quiet[
		Download[
			{
				(*1*)listedSamples,
				(*2*){$Notebook},
				(*3*)DeleteCases[ToList[Lookup[safeOptions, AliquotContainer]], Automatic | Null],
				(*4*)(ToList[Lookup[safeOptions, AliquotContainer]] /. Automatic -> Null),
				(*5*)modelBoxes,
				(*6*)modelBags,
				(*7*)uniqueSampleLocations
			},
			Evaluate[{
				(*1*)
				{
					Field[Container[Contents[[All, 2]][Object]]],
					Packet[Model, Container, Fragile, WettedMaterials, ContainerMaterials, Mass, Volume, Sequence @@ hazardFields],
					Packet[Container[Model]],
					Packet[Model[Dimensions, Fragile, WettedMaterials, ContainerMaterials, Sequence @@ hazardFields]],
					Packet[Container[Model][Dimensions, Fragile, WettedMaterials, ContainerMaterials]],
					{StorageCondition, Model[DefaultStorageCondition], DefaultStorageCondition},
					{Notebook[Object]}
				},
				(*2*)
				{
					{Financers[DefaultMailingAddress][Object]},
					{Financers[NotebooksFinanced][Object]}
				},
				(*3*){Positions},
				(*4*){Packet[Dimensions]},
				(*5*){Packet[Dimensions, InternalDimensions, Footprint, ContainerMaterials, Positions, AvailableLayouts]},
				(*6*){Packet[MaxVolume, Dimensions]},
				(*7*)
				{
					Packet[Model[ShippingModel[Ice[Dimensions]]]],
					Packet[Model[ShippingModel[DryIce[Density]]]],
					Packet[Model[ShippingModel[Padding[Density]]]],
					Packet[Model[ShippingModel[PlateSeal[Object]]]],
					Packet[Model[ShippingModel[{PackageCapacity, PackingMaterialsCapacity}]]]
				}
			}],
			Cache -> cacheOption,
			Date -> Now
		], {Download::NotLinkField, Download::ObjectDoesNotExist, Download::FieldDoesntExist}
	];

	(* extracting info from download *)
	(* the format of the Download call above was changed to make it faster. this reformating is only for adjusting the download results to match the previous format *)

	(* extract sample info *)
	rawSampleContainerContents = listedSampleDownloads[[All, 1]];
	rawUnflatSamplePackets = listedSampleDownloads[[All, 2]];
	rawUnflatContainerPackets = listedSampleDownloads[[All, 3]];
	rawUnflatSampleModelPackets = listedSampleDownloads[[All, 4]];
	rawUnflatContainerModelPackets = listedSampleDownloads[[All, 5]];
	storageConditions = listedSampleDownloads[[All, 6]];
	inputObjectNotebooks = listedSampleDownloads[[All, 7]];

	(* reformat sample info *)
	{
		sampleContainerContents,
		unflatSamplePackets,
		unflatContainerPackets,
		unflatSampleModelPackets,
		unflatContainerModelPackets
	} = Map[(List /@ #)&, {
		rawSampleContainerContents,
		rawUnflatSamplePackets,
		rawUnflatContainerPackets,
		rawUnflatSampleModelPackets,
		rawUnflatContainerModelPackets
	}];

	(* reformat notebook info *)
	{
		downloadedDestination,
		financedNotebooks
	} = If[!MatchQ[$Notebook, Null],

		{
			notebookDownloads[[All, 1]],
			notebookDownloads[[All, 2]]
		},

		{{Null}, {Null}}
	];

	(* extract sample location info *)
	uniqueSampleLocationDownloads = If[MatchQ[#, Null], ConstantArray[Null, 5], #]& /@ rawUniqueSampleLocationDownloads;

	rawIceInfo = uniqueSampleLocationDownloads[[All, 1]];
	rawDryIceInfo = uniqueSampleLocationDownloads[[All, 2]];
	rawPeanutInfo = uniqueSampleLocationDownloads[[All, 3]];
	rawPlateSealInfo = uniqueSampleLocationDownloads[[All, 4]];
	rawMaintenanceShippingModelInfo = uniqueSampleLocationDownloads[[All, 5]];

	(* reformat sample location info *)
	{
		iceInfo,
		dryIceInfo,
		peanutInfo,
		plateSealInfo,
		maintenanceShippingModelInfo
	} = Map[(List /@ #)&, {
		rawIceInfo,
		rawDryIceInfo,
		rawPeanutInfo,
		rawPlateSealInfo,
		rawMaintenanceShippingModelInfo
	}];

	(* Make a cache ball *)
	cacheBall=Join[(Cache/.safeOptions),Cases[Flatten[{downloadedDestination, aliquotContainerPositions, sampleContainerContents, storageConditions, unflatSamplePackets, unflatContainerPackets, unflatSampleModelPackets, unflatContainerModelPackets, unflatAliquotContainerModelPackets, modelBoxInfo, modelBagInfo, iceInfo, dryIceInfo, peanutInfo, plateSealInfo, maintenanceShippingModelInfo, financedNotebooks}],PacketP[]]];

	(*Flatten packets lists and the downloaded destination *)
	{samplePackets,containerPackets,sampleModelPackets,containerModelPackets,aliquotContainerModelPackets,
		modelBoxPackets,modelBagPackets,icePackets,dryIcePackets,peanutPackets,plateSealPackets,maintenanceShippingModelPackets} =
			Flatten[#]&/@{unflatSamplePackets,unflatContainerPackets,unflatSampleModelPackets,unflatContainerModelPackets,unflatAliquotContainerModelPackets,
				modelBoxInfo,modelBagInfo,iceInfo,dryIceInfo,peanutInfo,plateSealInfo,maintenanceShippingModelInfo};

	(* Figure out the first level container of each sample *)
	sampleImmediateContainers=Download[(sampleDeepContainers/.$Failed -> {Null})[[All,1]],Object];

	(* ------------------------ *)
	(* -- Basic Error Checks -- *)
	(* ------------------------ *)

	(* -- A. Ownership check -- *)
	(* Check that the notebook for each input object is a part of financing team's notebooks. In the case of ShipBetweenSites, a public object is also fine. *)
	ownedInputsCheck=MapThread[
		If[MatchQ[parentFunction, ShipBetweenSites],
			Or[
				(* the object is owned by the requestor *)
				MatchQ[#1,ObjectP[Flatten[financedNotebooks]]],
				(* the object is public, but being shipped as part of model fulfillment *)
				And[MatchQ[#1, Null], MatchQ[#2, ObjectP[]]],
				(* the object is public, and is being shipped by a developer redistributing inventory *)
				And[MatchQ[#1, Null], MatchQ[$Notebook, Null]]
			],
			MatchQ[#1,ObjectP[Flatten[financedNotebooks]]]
		]&,
		{Flatten[inputObjectNotebooks], Lookup[expandedSafeOptions, DependentResource]}
	];

	(* Input objects that do not belong to user's financing team notebooks *)
	nonOwnedInputs = Cases[Transpose[{listedSamples, ownedInputsCheck}], {ObjectP[Object], False}][[All,1]];

	(* If there are input objects that are not owned by the user's financing team and we are throwing messages, throw an error message *)
	If[Length[nonOwnedInputs]>0&&!gatherTests,
		Message[Error::OwnershipConflict,nonOwnedInputs]
	];

	(* generate tests if we are collecting them *)
	ownedInputsTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[nonOwnedInputs]>0,
				Test["The inputs "<>ObjectToString[nonOwnedInputs]<>" belong to a notebook financed by user's financing team:",True,False],
				Nothing
			];

			passingTest=If[Length[Complement[listedSamples,nonOwnedInputs]]>0,
				Test["The inputs "<>ObjectToString[Complement[listedSamples,nonOwnedInputs]]<>" belong to a notebook financed by user's financing team:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* -- B. Stowaway check -- *)
	(*Find all of the non-self contained samples that occupy the same container as the input samples*)
	allContainedSamples=Cases[DeleteDuplicates[Flatten[sampleContainerContents]],ObjectP[NonSelfContainedSampleTypes]];

	(* Find any stowaways (any non-self-contained sample is in a container that contains samples that are not being requested) *)
	stowawaySamples=Complement[allContainedSamples,listedSamples];

	(*If there are stowaways give a warning that we will transfer the samples to different containers.*)
	containedSamplesTest=If[!MatchQ[stowawaySamples,{}],

		(* Give a failing test or throw a message if there are stowaways *)
		If[gatherTests,
			Warning["There are stowaway samples, "<>ObjectToString[stowawaySamples]<>", in the containers being shipped.",False,True],
			Message[Warning::ContainersIncludeAdditionalSamples,stowawaySamples];
			Nothing
		],

		(* Give a passing test or do nothing otherwise. *)
		If[gatherTests,
			Warning["There are no stowaway samples in the containers being shipped.",True,True],
			Nothing
		]
	];


	(* --------------------- *)
	(* -- Resolve Options -- *)
	(* --------------------- *)

	(* get a flat list of all destinations *)
	cleanDestination=Flatten[ToList[downloadedDestination]];

	(* extract a list of all storage conditions *)
	cleanStorageConditions=FirstCase[#,Except[Null|$Failed],Null]&/@storageConditions;

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveShipFromECLOptions[listedSamples,cleanDestination,cleanStorageConditions,expandedSafeOptions,Cache->cacheBall,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveShipFromECLOptions[listedSamples,cleanDestination,cleanStorageConditions,expandedSafeOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];


	(* extract from the resolved Options the ones needed to calculate the partitioning of the samples into separate transactions *)
	{
		resolvedShippingSpeed,
		resolvedColdPacking,
		resolvedAliquotAmount,
		resolvedTargetConcentration,
		resolvedTargetConcentrationAnalyte,
		resolvedShipmentVolume,
		resolvedDestination,
		resolvedAliquot,
		resolvedConcentratedBuffer,
		resolvedBufferDilutionFactor,
		resolvedBufferDiluent,
		resolvedShipmentBuffer,
		resolvedAliquotSampleStorageCondition,
		resolvedDestinationWell,
		resolvedAliquotContainer,
		resolvedAliquotSampleLabel,
		resolvedAmount,
		resolvedContainerModel,
		resolvedDependentProtocol,
		resolvedDependentResource,
		resolvedFragile
	} = Map[
		Lookup[resolvedOptions,#,ConstantArray[Null, Length[listedSamples]]]&,
		{
			ShippingSpeed,
			ColdPacking,
			AliquotAmount,
			TargetConcentration,
			TargetConcentrationAnalyte,

			ShipmentVolume,
			Destination,
			Aliquot,
			ConcentratedBuffer,

			BufferDilutionFactor,
			BufferDiluent,
			ShipmentBuffer,
			AliquotSampleStorageCondition,
			DestinationWell,

			AliquotContainer,
			AliquotSampleLabel,
			Amount,
			Container,
			DependentProtocol,
			DependentResource,
			Fragile
		}
	];

	(* Make sure our resources are valid. We don't need to upload these since they will get created when we go to do the shipment *)
	(* Right now we just want to make sure we error now rather than downstream after transaction is confirmed *)

	(* -- C. Hazard check -- *)
	(* Throw an error if the sample is hazardous and requires specific handling *)
	(* if the input is Model, unflatSampleModelPackets is {$Failed}; if the sample does not have a model, unflatSampleModelPackets is Null. in these cases, return Nulls for modelHazardFieldValues, and hazard fields will be looked up from unflatSamplePackets *)
	modelHazardFieldValues = If[MatchQ[#, {$Failed | Null}],
		ConstantArray[Null, Length[hazardFields]],
		Lookup[#[[1]], hazardFields, {}]
	]& /@ unflatSampleModelPackets;

	objectHazardFieldValues = Lookup[#, hazardFields, {}]& /@ unflatSamplePackets[[All, 1]];

	(* look up sample amounts to ship *)
	shipmentAmounts = MapThread[
		Which[
			(* for ShipToUser, if the user specified ShipmentVolume, use that as the shipment amount *)
			VolumeQ[#1], #1,

			(* for ShipBetweenSites, if Amount is determined, use that as the shipment amount *)
			QuantityQ[#2], #2,

			(* otherwise, lookup mass/volume from sample packet *)
			True, FirstCase[Lookup[#3, {Mass, Volume}], _?QuantityQ, Null]
		]&,
		{resolvedShipmentVolume, resolvedAmount, unflatSamplePackets[[All, 1]]}
	];

	(* a function to look at hazard fields of the shipping samples and determines red flags for each sample *)
	hazardFieldLookup[sample_, modelFieldValues_, objectFieldValues_, amount_] := Module[{fieldValueRules},

		fieldValueRules = MapThread[
			Function[{objectFieldValue, modelFieldValue, hazardField, hazardPattern, hazardExceptionPattern, exceptionAmount},
				Which[
					(* in the sample model, if a hazard field is populated but it is less than the exception amount, don't raise red flag *)
					!MatchQ[hazardExceptionPattern, None] && !MatchQ[modelFieldValue, $Failed] && MatchQ[modelFieldValue, hazardExceptionPattern] && TrueQ[LessEqualQ[amount, exceptionAmount Milliliter] || LessEqualQ[amount, exceptionAmount Gram]],
						Nothing,

					(* same as previous for sample object *)
					!MatchQ[hazardExceptionPattern, None] && !MatchQ[objectFieldValue, $Failed] && MatchQ[objectFieldValue, hazardExceptionPattern] && TrueQ[LessEqualQ[amount, exceptionAmount Milliliter] || LessEqualQ[amount, exceptionAmount Gram]],
						Nothing,

					(* otherwise, determine which hazard fields are populated and what are their values *)
					!MatchQ[modelFieldValue, $Failed] && MatchQ[modelFieldValue, hazardPattern],
						hazardField -> modelFieldValue,

					(*  same as previous for sample objects *)
					!MatchQ[objectFieldValue, $Failed] && MatchQ[objectFieldValue, hazardPattern],
						hazardField -> objectFieldValue,

					(* if hazard field values do not match any hazard field patterns, do not raise red flag *)
					True,
						Nothing
				]
			],
			{modelFieldValues, objectFieldValues, hazardFields, hazardFieldValuePatterns, hazardExceptionPatterns, exceptionAmounts}
		];

		sample -> fieldValueRules
	];

	(* for each sample, find the hazardous fields that is populated *)
	hazardousSampleRules = MapThread[
		hazardFieldLookup[#1, #2, #3, #4]&,
		{listedSamples, modelHazardFieldValues, objectHazardFieldValues, shipmentAmounts}
	];

	(* Throw an error if the sample is hazardous *)
	hazardousSampleWithFields = Cases[hazardousSampleRules, sampleRule : (ObjectP[] -> {__}) :> sampleRule];

	(* If there are any hazardous samples, throw an error *)
	hazardousSamplesTest = If[
		!MatchQ[hazardousSampleWithFields, {}],

		(
			Message[
				Error::HazardousSamplesForShipping,
				ObjectToString[Keys[hazardousSampleWithFields]],
				StringJoin[StringReplace[ObjectToString[#], "->" -> ":"]& /@ Riffle[Values[hazardousSampleWithFields], "\n"]]
			];

			(* Give a failing test or throw a message if there are hazardous samples *)
			If[gatherTests,
				Test["The following samples are considered hazardous: " <> ObjectToString[Keys[hazardousSampleWithFields]] <> ":", False, True],
				Nothing
			]
		),

		(* Give a passing test or do nothing otherwise. *)
		If[gatherTests,
			Test["All samples are safe for shipping:", True, True],
			Nothing
		]
	];

	(* If any of the input objects are hazardous or are not owned by the user's financing team, we need to return early *)
	(* return $Failed for Results, or the options, or all the tests that have been generated so far) *)
	If[
		Or[
			!MatchQ[nonOwnedInputs, {}],
			!MatchQ[hazardousSampleWithFields, {}]
		],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{validLengthTests, safeOptionTests, siteTest, ownedInputsTest, hazardousSamplesTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* ----------------------------- *)
	(* -- Split Into Transactions -- *)
	(* ----------------------------- *)

	(* ---- Using the resolved options and the downloaded information, determine the partitioning of the samples into individual transactions ---- *)

	(* Associate each sample with its site, ShippingSpeed option, cold packing option, container, and other listed options *)
	samplesWithLocationsOptions=Transpose[{
		listedSamples,
		sampleLocations,
		resolvedShippingSpeed,
		resolvedColdPacking,
		sampleImmediateContainers,
		resolvedAliquotAmount,
		resolvedTargetConcentration,
		resolvedTargetConcentrationAnalyte,
		resolvedShipmentVolume,
		samplePackets,
		containerPackets,
		sampleModelPackets,
		containerModelPackets,
		resolvedDestination,
		resolvedAliquot,
		resolvedConcentratedBuffer,
		resolvedBufferDilutionFactor,
		resolvedBufferDiluent,
		resolvedShipmentBuffer,
		resolvedAliquotSampleStorageCondition,
		resolvedDestinationWell,
		resolvedAliquotContainer,
		resolvedAliquotSampleLabel,
		resolvedAmount,
		resolvedContainerModel,
		resolvedDependentProtocol,
		resolvedDependentResource,
		resolvedFragile
	}];

	(*Group samples that have the same site,ShippingSpeed preference,cold packing preference,and shipping info*)
	(*All model requests are separated into different transactions to allow them to choose their site*)
	partitionedSamplesAndInfo=Join[
		{#}&/@Select[samplesWithLocationsOptions, MatchQ[#[[1]], ObjectP[{Model[Item], Model[Sample]}]]&],
		GatherBy[Select[samplesWithLocationsOptions, !MatchQ[#[[1]], ObjectP[{Model[Item], Model[Sample]}]]&],{#[[2]],#[[3]],#[[4]],#[[14]]}&]
	];

	(*Get the partitioned samples and options*)
	(* the partitioned Samples are passed to the resolveOptions helper *)
	{
		partitionedSamples,
		partitionedSites,
		partitionedShippingSpeed,
		partitionedColdPacking,
		partitionedContainers,
		partitionedAliquotAmount,
		partitionedTargetConcentration,
		partitionedTargetConcentrationAnalyte,
		partitionedShipmentVolume,
		partitionedSamplePackets,
		partitionedContainerPackets,
		partitionedSampleModelPackets,
		partitionedContainerModelPackets,
		partitionedDestinations,
		partitionedAliquot,
		partitionedConcentratedBuffer,
		partitionedBufferDilutionFactor,
		partitionedBufferDiluent,
		partitionedShipmentBuffer,
		partitionedAliquotSampleStorageCondition,
		partitionedDestinationWell,
		partitionedAliquotContainer,
		partitionedAliquotSampleLabel,
		partitionedAmount,
		partitionedContainerModels,
		partitionedDependentProtocol,
		partitionedDependentResource,
		partitionedFragile
	} = Map[
		partitionedSamplesAndInfo[[All,All,#1]]&,
		Range[Length[First[samplesWithLocationsOptions]]]
	];


	(* We now have the listed options partitioned and arranged by the shipments. Remake the list of resolved options for each package. *)
	partitionedAliquotOptionSets=MapThread[
		Function[{aliquot,concentratedBuffer,bufferDilutionFactor,bufferDiluent,shipmentBuffer, aliquotSampleStorageCondition,destinationWell,aliquotContainer,aliquotAmount,shipmentVolume,targetConcentration, targetConcentrationAnalyte, aliquotSampleLabel},
			{
				Aliquot->aliquot,
				ConcentratedBuffer->concentratedBuffer,
				BufferDilutionFactor->bufferDilutionFactor,
				BufferDiluent->bufferDiluent,
				ShipmentBuffer->shipmentBuffer,
				AliquotSampleStorageCondition->aliquotSampleStorageCondition,
				DestinationWell->destinationWell,
				AliquotContainer->aliquotContainer,
				AliquotAmount->aliquotAmount,
				ShipmentVolume->shipmentVolume,
				TargetConcentration->targetConcentration,
				TargetConcentrationAnalyte -> targetConcentrationAnalyte,
				AliquotPreparation ->Lookup[resolvedOptions,AliquotPreparation],
				ConsolidateAliquots ->Lookup[resolvedOptions,ConsolidateAliquots],
				AliquotSampleLabel->aliquotSampleLabel
			}

		],
		{
			partitionedAliquot,
			partitionedConcentratedBuffer,
			partitionedBufferDilutionFactor,
			partitionedBufferDiluent,
			partitionedShipmentBuffer,
			partitionedAliquotSampleStorageCondition,
			partitionedDestinationWell,
			partitionedAliquotContainer,
			partitionedAliquotAmount,
			partitionedShipmentVolume,
			partitionedTargetConcentration,
			partitionedTargetConcentrationAnalyte,
			partitionedAliquotSampleLabel
		}
	];

	(*Get the partitioned containersIn,filtering out the containers of self contained samples*)
	partitionedContainersIn=MapThread[PickList[Flatten[#1],#2,ObjectP[NonSelfContainedSampleTypes]]&,{partitionedContainers,partitionedSamples}];

	(*If samples from the same container were partitioned into separate shipments (because of different cold packing/ShippingSpeed specification),give a warning that we will transfer the samples to different containers.*)
	containerTallies=Tally[DeleteCases[Flatten[DeleteDuplicates/@partitionedContainers], Null]];
	splitContainers=Cases[containerTallies,{_,Except[1]}][[All,1]];


	(*  If not collecting Test, and samples from the same need to be split into different containers, throw a warning message *)
	splitContainerTestDescription = "Samples are properly grouped into different packages according to their ShippingSpeed and ColdPacking specifications. If required, samples from the same container are split up into different containers.";
	splitContainerTest = If[!MatchQ[splitContainers,{}],
		If[messagesBoolean,Message[Warning::ContainersSpanShipments,splitContainers]];
		If[gatherTests,Warning[splitContainerTestDescription,False,True]],
		If[gatherTests,Warning[splitContainerTestDescription,True,True]]
	];

	(* -- Valid resource check -- *)
	(* Make sure the model X amounts are valid - otherwise we can get a downstream error when we try to actually create protocols to do the shipments *)
	{frqResultsPerGroup,frqTestsPerGroup} = Transpose@MapThread[
		Function[{samples,amounts,destination},
			Module[{transactionResources},
				transactionResources = MapThread[
					If[MatchQ[#1, ObjectP[Model[Sample]]],
						Resource[Sample -> #1, Amount -> #2, Container -> PreferredContainer[#2]],
						Nothing
					]&,
					{samples, amounts}
				];

				(* Destination is listed out for each sample in the group, but all destinations are the same within each group (safe to take first) *)
				Which[
					(* No destination set - we throw an error elsewhere *)
					!MatchQ[destination[[1]],ObjectP[Object[Container,Site]]], {True, {}},
					TrueQ[gatherTests], Resources`Private`fulfillableResourceQ[transactionResources, Output -> {Result, Tests}, Site -> destination[[1]]],
					True, {Resources`Private`fulfillableResourceQ[transactionResources, Output -> Result, Site -> destination[[1]]], {}}
				]
			]
		],
		{partitionedSamples, partitionedAmount, partitionedDestinations}
	];

	(* If we can't actually ship our requested model FRQ will throw an error. This should only happen if we're calling ShipBetweenSites *)
	(* return $Failed for Results, or the options, or all the tests that have been generated so far) *)
	If[!MatchQ[frqResultsPerGroup,{True..}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{
				validLengthTests,
				safeOptionTests,
				siteTest,
				ownedInputsTest,
				containedSamplesTest,
				resolvedOptionsTests,
				splitContainerTest
			}],
			Options -> $Failed,
			Preview -> Null
		}]
	];


	(* ------------------------- *)
	(* -- Create Transactions -- *)
	(* ------------------------- *)

	(* Collapse the options so that we can extract the collapsed aliquot options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[shipFromECL,resolvedOptions,Messages->False,Ignore->listedOptions];

	(* we don't return options that are of the Category Hidden *)
	resolvedOptionsMinusHiddenOptions=RemoveHiddenOptions[shipFromECL,collapsedResolvedOptions];

	newTransactions = If[MatchQ[parentFunction,ShipToUser],
		CreateID[ConstantArray[Object[Transaction, ShipToUser], Length[partitionedSamples]]],
		CreateID[ConstantArray[Object[Transaction, SiteToSite], Length[partitionedSamples]]]
	];

	(* Generate a transaction packet. If the samples are at different locations or request different cold packing or ShippingSpeed, one packet per location/ShippingSpeed/cold packing set is generated *)
	transactionPackets = MapThread[
		Function[{
			transaction,
			samples,
			sites,
			coldPacking,
			shippingSpeed,
			containersIn,
			destinations,
			aliquotOptionSet,
			amounts,
			containers,
			resources,
			fragile
		},
			Join[
				<|
					Object->transaction,
					Replace[SamplesIn]->Link[samples],
					Replace[ContainersIn]->Link[DeleteDuplicates[Download[containersIn,Object]]],
					Replace[WorkingSamples]->Link[samples],
					Replace[WorkingContainers]->Link[DeleteDuplicates[Download[containersIn,Object]]],
					Creator->Link[Lookup[resolvedOptions, Creator],TransactionsCreated],
					Destination->Link[destinations[[1]]],
					(* for cases where site is not resolved yet, default to ECL-2 as this is a site-to-site model request *)
					(* cases where site is not resolvable for an object already errored above *)
					If[MatchQ[sites[[1]], ObjectP[Object[Container, Site]]],
						Source->Link[sites[[1]]],
						Source->Link[Object[Container, Site, "id:kEJ9mqJxOl63"]] (*ECL-2*)
					],
					ShippingSpeed->First[shippingSpeed],
					ColdPacking->First[coldPacking],
					Replace[Fragile] -> fragile,
					If[MatchQ[parentFunction, ShipBetweenSites],Replace[Amounts] -> Replace[amounts, (x_Integer:>x*Unit), 1], Nothing],
					If[MatchQ[parentFunction, ShipBetweenSites],Replace[ContainerModels] -> Link/@containers, Nothing],
					If[MatchQ[parentFunction, ShipBetweenSites],Replace[Resources]-> Link[resources/.None-> Null, Order], Nothing]
				|>,
				(* Use a shared helper to make the aliquot prep fields for each package*)
				If[MatchQ[samples, {ObjectP[Model]..}],
					<||>,
					Experiment`Private`populateSamplePrepFields[ToList[samples], (aliquotOptionSet/.{(ShipmentVolume -> x_) :> AssayVolume -> x, (ShipmentBuffer -> x_) :> AssayBuffer -> x})]
				]
			]
		],
		{
			newTransactions,
			partitionedSamples,
			partitionedSites,
			partitionedColdPacking,
			partitionedShippingSpeed,
			partitionedContainersIn,
			partitionedDestinations,
			partitionedAliquotOptionSets,
			partitionedAmount,
			partitionedContainerModels,
			partitionedDependentResource,
			partitionedFragile
		}
	];

	(* if there is a dependant protocol, link it *)
	protocolUpdatePackets = If[MatchQ[parentFunction, ShipBetweenSites],
		Map[
			Function[tuple,
				<|
					Object -> tuple[[1,1]],
					Append[ShippingMaterials]-> Map[{Link[tuple[[2]], DependentProtocols], Link[#]}&,tuple[[3]]]
				|>
			],
			Cases[Transpose[{partitionedDependentProtocol, newTransactions, partitionedSamples}], {{ObjectP[]..}, _, _}]
		],
		{}
	];

	(* Get rid of the Replace/Appends so that the change packet can be used in the packing materials calculator *)
	reKeyedTransactionPackets=Association@@#&/@(Normal[transactionPackets]/.Replace[x_Symbol]:>x);

	(* Figure out the shipping material packets for each maintenance based on the source site of the transactions *)
	shippingMaterialsPacketsByTransaction=(First/@partitionedSites)/.AssociationThread[uniqueSampleLocations,Transpose[{icePackets,dryIcePackets,peanutPackets,plateSealPackets,maintenanceShippingModelPackets}]];

	(* Estimate the packing materials that each transaction needs *)
	(* If the packed object is a model, we will need to do this in MaintenanceShipping procedure, after the model has been fulfilled *)
	materialsByTransaction=MapThread[
		Function[
			{transactionPacket,samplePackets,containerPackets,sampleModelPackets,containerModelPackets,icePacket,dryIcePacket,peanutPacket,plateSealPacket,maintenancePacket},
			If[MatchQ[samplePackets, {PacketP[Object]..}],
				calculatePackingMaterials[
					transactionPacket,
					samplePackets,
					containerPackets,
					sampleModelPackets,
					containerModelPackets,
					(aliquotContainerModelPackets/.{Null}->Null),
					modelBoxPackets,
					modelBagPackets,
					icePacket,
					dryIcePacket,
					peanutPacket,
					plateSealPacket,
					maintenancePacket
				],
				(*The grouped content models and indexes, boxes (which are indexed to the content groups), ice/dry ice/padding and amount (which are indexed to the content groups), plate seals (which are indexed to flattened contents), and secondary containers (which are indexed to flattened contents)
					{groupedContentsIndexes,groupedContentsModelPackets,boxPacketByGroup,ice,dryIce,padding,bags,plateSeals}*)
				ConstantArray[{}, 9]
			]
		],
		Join[{reKeyedTransactionPackets,partitionedSamplePackets,partitionedContainerPackets,partitionedSampleModelPackets,partitionedContainerModelPackets},Transpose[shippingMaterialsPacketsByTransaction]]
	];

	(* Organize the packing materials *)
	{indexGroupingByTransaction,groupedContentsByTransaction,groupedContentModelPacketsByTransaction,boxesByTransaction,iceByTransaction,dryIceByTransaction,paddingByTransaction,bagsByTransaction,plateSealsByTransaction}=Transpose[materialsByTransaction];

	(* need to return $Failed and throw a message here if we have no bags that are big enough that we can use for secondary containment *)
	(* this is only for containers proper; for other things, Null is fine here *)
	nullBagSamples = Flatten[MapThread[
		Function[{contents, bags},
			MapThread[
				If[MatchQ[#2, $Failed],
					#1,
					Nothing
				]&,
				{Flatten[contents], bags}
			]
		],
		{groupedContentsByTransaction, bagsByTransaction}
	]];

	If[!MatchQ[nullBagSamples, {}] && !gatherTests,
		Message[Error::NoAvailableSecondaryContainers, ObjectToString[nullBagSamples]];
	];
	nullBagTest = If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[MatchQ[nullBagSamples,{}],
				Nothing,
				Test["The following samples are small enough that they can fit in a secondary containment bag "<>nullBagSamples<>":", True, False]
			];

			passingTest=If[Length[nullBagSamples]==Length[listedSamples],
				Nothing,
				Test["The following samples are small enough that they can fit in a secondary containment bag "<>nullBagSamples<>":", True, True]
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* If we don't have any bags we can use, return early *)
	(* return $Failed for Results, or the options, or all the tests that have been generated so far) *)
	If[!MatchQ[nullBagSamples,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Flatten[{
				validLengthTests,
				safeOptionTests,
				siteTest,
				ownedInputsTest,
				containedSamplesTest,
				resolvedOptionsTests,
				splitContainerTest,
				nullBagTest
			}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Add estimated packing materials to each transaction *)
	(* only do this for objects, models will have to wait *)
	transactionMaterialsUpdates=MapThread[
		Function[{samplePackets, transactionPacket,boxPackets,bagPackets,plateSeals,iceAndAmount,dryIceAndMass,paddingAndMass},
			If[MatchQ[samplePackets, {PacketP[Object]..}],
				<|
					Object->Lookup[transactionPacket,Object],
					Replace[ShippingContainers]->Link[Lookup[DeleteCases[boxPackets,Null],Object,{}]],
					Replace[SecondaryContainers]->Link[Lookup[DeleteCases[bagPackets,Null],Object,{}]],
					Replace[PlateSeals]->Link[DeleteCases[plateSeals,Null]],
					Replace[Ice]->If[MatchQ[iceAndAmount,{}],{},Link[ConstantArray[iceAndAmount[[All,1]][[1]],Total[iceAndAmount[[All,2]]]]]],
					Replace[DryIce]->If[MatchQ[dryIceAndMass,{}],{},Link[dryIceAndMass[[All,1]]]],
					Replace[DryIceMasses]->If[MatchQ[dryIceAndMass,{}],{},dryIceAndMass[[All,2]]],
					Replace[Padding]->If[MatchQ[paddingAndMass,{}],{},Link[paddingAndMass[[All,1]]]],
					Replace[PaddingMasses]->If[MatchQ[paddingAndMass,{}],{},paddingAndMass[[All,2]]]
				|>,
				{}
			]
		],
		{partitionedSamplePackets, transactionPackets,boxesByTransaction,bagsByTransaction,plateSealsByTransaction,iceByTransaction,dryIceByTransaction,paddingByTransaction}
	];

	(* create packets that get passed into UploadTransaction.  The key here is that we're adding the fields that UploadTransaction needs to Download from, but that we don't want to Upload *)
	transactionPacketsExtraFields = Map[
		If[MatchQ[parentFunction, ShipBetweenSites],
			Append[#, {DependentOrder -> Null, Products -> {}, ReceivedItems -> {}, UserCommunications -> {}, Notebook -> $Notebook}],
			Append[#, {DependentOrder -> Null, Products -> {}, ReceivedItems -> {}, UserCommunications -> {}, Notebook -> $Notebook}]
		]&,
		transactionPackets
	];

	(* Use UploadTransaction to update the Status/StatusLog and shipping information.*)
	transactionStatusPackets=UploadTransaction[transactionPacketsExtraFields,Pending,Upload->False,FastTrack->True,Cache->cacheOption,Email->Lookup[collapsedResolvedOptions,Email]];

	(* Pool together the initial packet, the material update packe, and the transaction status packets into one single packet, for a single upload *)
	allUploads=Flatten[{transactionPackets,transactionMaterialsUpdates,transactionStatusPackets, protocolUpdatePackets}];

	mainFunctionTests=Join[{splitContainerTest},{siteTest},{containedSamplesTest},{ownedInputsTest}];

	(* ------------------- *)
	(* -- Format Output -- *)
	(* ------------------- *)

	(*Prepare the Options result if we were asked to do so*)
	(* return only the options appropriate for the parent function *)
	optionsRule=Options->If[MemberQ[output,Options],
		Select[resolvedOptionsMinusHiddenOptions, MatchQ[Keys[#],Alternatives@@(ToExpression/@Keys[Options[parentFunction]])]&],
		Null
	];

	(*Prepare the Preview result if we were asked to do so*)
	previewRule=Preview->If[MemberQ[output,Preview],
		Module[{transaction, samples, aliquot, source, destination, shippingSpeed,coldPacking},
			(* extract useful information from the transaction packet *)
			{transaction,samples,aliquot,source,destination,shippingSpeed,coldPacking} = Lookup[transactionPackets,#]& /@ {Object,Replace[SamplesIn],Aliquot,Source,Destination,ShippingSpeed,ColdPacking};
			(* Construct a Table with the information to show as a Preview *)
			Quiet[PlotTable[Transpose[{transaction, Download[samples, Object], aliquot,coldPacking, shippingSpeed, Download[destination, Object]}],
				ItemSize -> Automatic,
				TableHeadings -> {Automatic, {"Transaction ID", "Samples shipped in Package", "Aliquotting Performed", "Shipping Temperature", "Shipment Speed", "Destination ID"}}],
				PlotTable::RowLabelMismatch]
		],
		Null
	];

	(*Prepare the Test result if we were asked to do so*)
	testsRule=Tests->If[MemberQ[output,Tests],
		(*Join all exisiting tests generated by the top level function and helper functions*)
		Flatten[{safeOptionTests,validLengthTests,templateTests,resolvedOptionsTests,mainFunctionTests,frqTestsPerGroup}],
		Null
	];

	(*Prepare the standard result if we were asked for it and we can safely do so*)
	resultRule=Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
			Module[{},
				If[uploadOption,
					Upload[allUploads];Lookup[transactionPackets,Object,{}],
					allUploads]
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}

];

DefineOptions[
	resolveShipFromECLOptions,
	Options:>{HelperOutputOption,CacheOption}
];

resolveShipFromECLOptions[
	mySamples:{ObjectP[{Object[Sample],Object[Item], Model[Sample], Model[Item]}]..},
	myDestination:{ObjectP[{Object[Container]}]..|Null},
	myStorageConditions:{(ObjectP[{Model[StorageCondition]}] | Null | $Failed) ...},
	myOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]]:=Module[
	{
		listedOptions,output,listedOutput,collectTestsBoolean,messagesBoolean,expandedInputs,expandedOptions,creator,resolvedCreator,expandedDestinations,
		resolvedDestinations,destinationTestDescription,destinationTest,expandedColdPacking,resolvedColdPacking,expandedShippingSpeed,resolvedShippingSpeed,
		renamedAliquotingOptions,resolvedRenamedAliquotOptions,aliquotTest,resolvedAliquotOptions,allTests,resolvedOptions, email, upload,resolvedEmail,
		myObjectSamplePosition, samplesOnlyRenamedAliquotingOptions, mySampleObjects, resolvedRenamedAliquotOptionsRaw, fullResolvedAliquotOptions, resolvedContainerModel,
		expandedFragile, cache, resolvedAliquotContainers, sampleFragileInfoPackets, aliquotContainerFragileInfoPackets, sampleFragileDownloadField, downloadedFragileResult, resolvedFragile,
		containerModelFragileInfoPackets
	},

	(* -------------------------- *)
	(* -- Set up for MapThread -- *)
	(* -------------------------- *)

	(* From resolveShipToUserOptions' options, get Output value *)
	listedOptions = ToList[ops];
	output = OptionDefault[OptionValue[Output]];
	listedOutput = ToList[output];
	cache = Lookup[listedOptions, Cache];

	(* determine whether to collect Tests *)
	collectTestsBoolean = MemberQ[listedOutput,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messagesBoolean=!collectTestsBoolean;

	(* Expand any index-matched options from OptionName A to OptionName {A,A,A,...} so that it's safe to MapThread over several options *)
	(* Note: shipFromECL is a helper and the second argument could be ShipToUser or ShipBetweenSites depending on which function is calling it. However, it shouldn't matter here for expanding index-matching option purpose *)
	(* Thus I am not going to try pass the value from parent function, just use ShipToUser as a placeholder *)
	{expandedInputs, expandedOptions} = ExpandIndexMatchedInputs[shipFromECL, {mySamples, ShipToUser}, myOptions];

	(* ----------------------- *)
	(* -- 1. Shared Options -- *)
	(* ----------------------- *)

	(* === A. Resolve Email === *)

	(* Pull Email and Upload options from the expanded Options *)
	{email, upload} = Lookup[expandedOptions, {Email, Upload}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* === B. Resolve Creator === *)

	(* If set to Automatic, creator is $PersonID. Otherwise, it is the specified creator *)
	creator = Lookup[expandedOptions, Creator];
	resolvedCreator = Switch[creator,
		Automatic,$PersonID,
		_,Download[creator,Object]
	];


	(* === C. Resolve Destination === *)

	(* If destination is not specified, the site of the financer of the notebook calling this function is considered the destination. If this is not called from CommandCenter, Notebook (and therefore destination) is Null.*)(* Eventually,there will only be one financer per notebook but for now it is still a multiple*)
	expandedDestinations = Lookup[expandedOptions,Destination];
	resolvedDestinations = If[MatchQ[#,Automatic],FirstOrDefault[myDestination],#]&/@expandedDestinations;

	(* If Destination is null (e.g. this function is not called from a notebook and destination option is not specified),throw an error message *)
	destinationTestDescription = "Destination is specified or could be resolved from the notebook calling this function in which case the site of the notebook's associated financing team was used.";

	(* If collecting Tests, make a Test that passes unless Destination is Null *)
	destinationTest = If[MemberQ[resolvedDestinations,Null],
		If[messagesBoolean,Message[Error::NoDestination];Message[Error::InvalidOption,Destination]];
		If[collectTestsBoolean,Test[destinationTestDescription,False,True]],
		If[collectTestsBoolean,Test[destinationTestDescription,True,True]]
	];

	(* === D. Resolve Cold Packing === *)

	(* Resolve any Automatic ColdPacking options *)
	expandedColdPacking=Lookup[expandedOptions,ColdPacking];
	resolvedColdPacking=MapThread[
		Switch[{#1,#2},

			(* If the user specified something in the ColdPacking option, use that *)
			{Except[Automatic],_},#1,

			(* If the option is Automatic and the sample storage condition is refrigerator, resolve to Ice *)
			{Automatic,ObjectP[{Model[StorageCondition,"Refrigerator"],Model[StorageCondition,"Refrigerator, Flammable"],Model[StorageCondition,"Refrigerator, Flammable Acid"],Model[StorageCondition,"Refrigerator, Flammable Base"],Model[StorageCondition,"Refrigerator, Base"],Model[StorageCondition,"Refrigerator, Acid"],Model[StorageCondition,"Refrigerator, Flammable Pyrophoric"]}]},Ice,

			(* If the option is Automatic and the sample storage condition is freezer,resolve to DryIce *)
			{Automatic,ObjectP[{Model[StorageCondition,"Freezer"],Model[StorageCondition,"Deep Freezer"],Model[StorageCondition,"Cryogenic Storage"]}]},DryIce,

			(* Otherwise,resolve to None *)
			___,None

		]&,
		{expandedColdPacking,myStorageConditions}
	];


	(* === E. Resolve Shipping Speed === *)

	(* Resolve any Automatic ShippingSpeed options *)
	expandedShippingSpeed = Lookup[expandedOptions,ShippingSpeed];
	resolvedShippingSpeed = MapThread[
		Switch[{#1,#2},
			(* If the user specified something in the ShippingSpeed option, use that *)
			{Except[Automatic],_},#1,

			(* If the option is Automatic and the ColdPacking option is DryIce or Ice, resolve to NextDay *)
			{Automatic,Ice|DryIce},NextDay,

			(* Otherwise, resolve to FiveDay *)
			___,FiveDay
		]&,
		{expandedShippingSpeed,resolvedColdPacking}
	];


	(* === F. Resolve Aliquot Options === *)

	(* This is a little tricky because at this point, we may have a mixed list of Models and Objects. We do not want to try to resolveAliquotOptions for models since they are going to be prepared.  *)
	(* The aliquot options are index matched, so we need to make sure that each option has been resolved for objects, not for models. There is an error earlier sayign that you cannot use aliquot options for a model request. *)

	(* Swap out the transaction aliquoting option names to match the names that resolveAliquotOptions expects *)
	renamedAliquotingOptions = Normal[expandedOptions]/.{(ShipmentVolume->x_):>AssayVolume->x,(ShipmentBuffer->x_):>AssayBuffer->x};

	(* determine which elements are an object and resolve aliquot options for them *)
	(* track the index of the objects so that we can recombine these *)
	myObjectSamplePosition = Flatten@Position[mySamples, ObjectP[Object]];
	mySampleObjects = Cases[mySamples, ObjectP[Object]];

	(* get an option set in the form {OptionName -> {values only for objects}..} *)
	samplesOnlyRenamedAliquotingOptions = Map[
		If[And[MatchQ[Values[#], _List], MatchQ[Length[Values[#]], Length[mySamples]]],
			Keys[#]-> Values[#][[myObjectSamplePosition]],
			#
		]&,
		renamedAliquotingOptions
	];


	(* for objects only, resolve the aliquot options *)
	(* note that this function only outputs aliquot options. It drops the rest. *)
	{resolvedRenamedAliquotOptionsRaw,aliquotTest}=If[MatchQ[mySampleObjects,{}],
		{renamedAliquotingOptions,{}},
		If[collectTestsBoolean,
			Experiment`Private`resolveAliquotOptions[shipFromECL,mySampleObjects,mySampleObjects,samplesOnlyRenamedAliquotingOptions,RequiredAliquotAmounts->Null,AllowSolids->True,Output->{Result,Tests}],
			{
				Experiment`Private`resolveAliquotOptions[shipFromECL,mySampleObjects,mySampleObjects,samplesOnlyRenamedAliquotingOptions,RequiredAliquotAmounts->Null,AllowSolids->True,Output->Result],
				{}
			}
		]
	];

	(* update the aliquot options for the samples only options *)
	fullResolvedAliquotOptions = If[MatchQ[mySampleObjects, {}],
		resolvedRenamedAliquotOptionsRaw,
		ReplaceRule[renamedAliquotingOptions, resolvedRenamedAliquotOptionsRaw]
	];


	(* add in Null at all of the Model positions *)
	(* we have a set of rules for options for each sample input. We want to put those values in their correct place in the original list *)
	(* we now need to thread back in the model results at the appropriate position. Doing this with replace part since we have the list of the original positions *)

	(* for each option, determine if the value could have changed *)
	resolvedRenamedAliquotOptions = If[MatchQ[mySampleObjects, {}],
		resolvedRenamedAliquotOptionsRaw,
		Map[
			Function[originalOptionRule,
				Module[{updatedValue},

					(* look up the updated value after aliquot resolution. Non aliquot related options are unchanged  *)
					updatedValue = Lookup[fullResolvedAliquotOptions, Keys[originalOptionRule]];

					(* only update if we have a list matching the length of the number of objects - this will encapsulate all of the index matched options *)
					(* for any non index matched options or index matched options that are not aliquot related, just take the updated value *)
					If[
						And[
							MatchQ[updatedValue, _List],
							MatchQ[Length[updatedValue], Length[mySampleObjects]],
							MemberQ[Keys[resolvedRenamedAliquotOptionsRaw], Keys[originalOptionRule]]
						],
						Keys[originalOptionRule] -> ReplacePart[
							Values[originalOptionRule],
							MapThread[(#1 -> #2)&,{myObjectSamplePosition, updatedValue}]
						],
						(* some of the aliquot options are not index matched, they still need to be updated. *)
						Keys[originalOptionRule]->updatedValue
					]
				]
			],
			renamedAliquotingOptions
		]
	];

	(*Replace the assay aliquot option names with the transaction aliquot option names*)
	resolvedAliquotOptions = resolvedRenamedAliquotOptions/.{(AssayVolume->x_):>ShipmentVolume->x,(AssayBuffer->x_):>ShipmentBuffer->x};

	(* ------------------------------ *)
	(* -- 2. ShipBetweenSites only -- *)
	(* ------------------------------ *)

	(* Resolve a ContainerModel for any model inputs given a resource*)
	resolvedContainerModel = If[Or[!MemberQ[mySamples, ObjectP[{Model[Sample], Model[Item]}]], !MemberQ[Lookup[expandedOptions,DependentResource], ObjectP[Object[Resource, Sample]]]],
		ConstantArray[Null, Length[mySamples]],
		Module[{dependentResources, containerModelPerResource},
			(* look up the containerModel from the resource, replace anything that is not an object with Null *)
			dependentResources = Lookup[expandedOptions,DependentResource]/.None-> Null;
			containerModelPerResource = Download[dependentResources, ContainerModels[Object]]/.{x:{ObjectP[]..} :> x[[1]], {} -> Null};

			(* do not replace anything that has already been specified *)
			MapThread[If[MatchQ[#1, ObjectP[]],
				#1,
				#2
			]&,
				{Lookup[expandedOptions, Container], containerModelPerResource}
			]
		]
	];

	(* ------------------------------- *)
	(* -- 3. Resolve Fragile option -- *)
	(* ------------------------------- *)

	expandedFragile = Lookup[expandedOptions, Fragile];
	resolvedAliquotContainers = Lookup[resolvedAliquotOptions, AliquotContainer] /. {{_Integer, x:ObjectP[Model[Container]]} :> x, {Automatic, Automatic} -> Null,Automatic -> Null};

	(* Determine which field to download to determine the Fragile boolean of input sample *)
	sampleFragileDownloadField = Join[
		Map[
			Switch[#,
				(* For Object[Sample], download the Container[Model][Fragile] field *)
				ObjectP[Object[Sample]],
					{Packet[Container[Model][{Fragile, ContainerMaterials}]]},
				(* For Other Objects, download the Model[Fragile] field *)
				ObjectP[Object],
					{Packet[Model[{Fragile, ContainerMaterials, WettedMaterials}]]},
				(* For Model input, download the Fragile field *)
				(* For Model[Sample] input this download is meaningless anyway since we'll need to look at Fragile field of the resolvedContainerModel *)
				_,
					{Packet[Fragile, ContainerMaterials, WettedMaterials]}
			]&,
			mySamples
		],
		ConstantArray[{Packet[Fragile, ContainerMaterials, WettedMaterials]}, Length[resolvedAliquotContainers]],
		ConstantArray[{Packet[Fragile, ContainerMaterials, WettedMaterials]}, Length[resolvedContainerModel]]
	];

	downloadedFragileResult = Quiet[
		Download[
			Join[mySamples, resolvedAliquotContainers, resolvedContainerModel],
			Evaluate[sampleFragileDownloadField],
			Cache -> cache
		],
		{Download::FieldDoesntExist}
	];

	{sampleFragileInfoPackets, aliquotContainerFragileInfoPackets, containerModelFragileInfoPackets} = Partition[downloadedFragileResult, Length[mySamples]];

	resolvedFragile = MapThread[
		Function[{unresolvedFragile, sampleFragileInfoPacket, aliquotContainerPacket, aliquotContainer, containerModelPacket, modelSampleContainer},
			Which[
				(* If user supplied this option, use it as is *)
				BooleanQ[unresolvedFragile],
					unresolvedFragile,
				(* Otherwise, if we are not doing aliquot and we are not requesting Model[Sample] (i.e., resolvedContainerModel is Null) , use Fragile field from sample container *)
				NullQ[aliquotContainer] && NullQ[modelSampleContainer],
					determineFragileFromPacket[sampleFragileInfoPacket],
				(* If we are doing aliquot and we will use Fragile field from the resolved aliquot container *)
				NullQ[modelSampleContainer],
					determineFragileFromPacket[aliquotContainerPacket],
				(* Lastly, we are requesting Model[Sample], thus we determine from the resolvedContainerModels*)
				True,
					determineFragileFromPacket[containerModelPacket]
			]
		],
		{expandedFragile, sampleFragileInfoPackets, aliquotContainerFragileInfoPackets, resolvedAliquotContainers, containerModelFragileInfoPackets, resolvedContainerModel}
	];

	(* ----------------------------------- *)
	(* -- Gather Test and Format Output -- *)
	(* ----------------------------------- *)

	(*Gather all the tests (this will be a list of Nulls if!Output\[Rule]Test)*)
	allTests = Flatten[{destinationTest,aliquotTest}];

	(* Update options with the resolved options *)
	resolvedOptions = ReplaceRule[myOptions,
		Join[
			Normal[KeyDrop[resolvedAliquotOptions, {Email, Creator, Destination, ShippingSpeed, ColdPacking, Fragile}]],
			{
				ColdPacking->resolvedColdPacking,
				ShippingSpeed->resolvedShippingSpeed,
				Destination->resolvedDestinations,
				Creator->resolvedCreator,
				Email->resolvedEmail,
				Container -> resolvedContainerModel,
				Fragile -> resolvedFragile
			}
		]
	];

	(* collapsedOptions = CollapseIndexMatchedOptions[ShipToUser,resolvedOptions,Messages\[Rule]False]; *)
	(* Note: do not collapse before passing the options back to the main function since we'll need the expanded aliquot options *)
	output/.{Tests->allTests,Result->resolvedOptions}

];

(* ==calculatePackingMaterials== *)
(* Helper function to group the samples of each transaction and to determine the boxes, secondary containers, ice/dry ice/padding, and plate seals needed to package the samples for shipment.

Inputs:
	myTransactionPacket: the transaction to calculate packing materials for
	mySamplePackets: the SamplesIn packets of the transaction
	myContainerPackets: any ContainersIn packets of the transaction
	mySampleModelPackets: the model packets of the SamplesIn of the transaction
	myContainerModelPackets: the model packets of any ContainersIn of the transaction
	myAliquotContainerModelPackets: the packets of any AliquotContainer models of the transaction
	myModelBoxPackets: the packets of any boxes that may be used to pack the samples/items
	myModelBagPackets: the packets of any bags that may be used as secondary containment for the sample containers
	myIcePackPacket: the packet of the ice that may be used to keep samples cool during shipment
	myDryIcePacket: the packet of the dry ice that may be used to keep samples cool during shipment
	myPeanutPacket: the packet of the peanuts that may be used to pad the samples during shipment
	myPlateSealPacket: the packet of the plate seal that may be used to seal plates more securely during shipment

Output:
	The grouped content models and indexes, boxes (which are indexed to the content groups), ice/dry ice/padding and amount (which are indexed to the content groups), plate seals (which are indexed to flattened contents), and secondary containers (which are indexed to flattened contents)
{groupedContentsIndexes,groupedContentsModelPackets,boxPacketByGroup,ice,dryIce,padding,bags,plateSeals}

*)


calculatePackingMaterials[
	myTransactionPacket:PacketP[{Object[Transaction, ShipToUser], Object[Transaction, SiteToSite]}, {SamplesIn,ContainersIn,ColdPacking}],
	mySamplePackets:{PacketP[{Object[Sample],Object[Item]},{Model}]..},
	myContainerPackets:{PacketP[Object[Container],{Model}]...}|Null,
	mySampleModelPackets:{(PacketP[{Model[Sample],Model[Item]},{Dimensions}]|Null)..},
	myContainerModelPackets:{PacketP[Model[Container],{Dimensions}]...}|Null,
	myAliquotContainerModelPackets:{PacketP[Model[Container],{Dimensions}]...}|Null,
	myModelBoxPackets:{PacketP[Model[Container,Box],{ContainerMaterials,InternalDimensions,Dimensions}]..},
	myModelBagPackets:{PacketP[Model[Container,Bag],{MaxVolume,Dimensions}]..},
	myIcePackPacket:PacketP[Model[Item,Consumable],{Dimensions}],
	myDryIcePacket:PacketP[Model[Sample],{Density}],
	myPeanutPacket:PacketP[Model[Item,Consumable],{Density}],
	myPlateSealPacket:PacketP[Model[Item]],
	myMaintenanceShippingModelPacket:PacketP[Model[Maintenance,Shipping],{PackageCapacity, PackingMaterialsCapacity}]
]:=Module[
	{contents,contentsModels,contentsDimensions,contentsVolumes,groupedContentsModelsVolumes,
	contentsModelsPackets,groupedContentsIndexes,groupedContentsModelPackets,groupedContents,
	groupedContentsDimensions,groupedContentsVolumes,groupedContentsTotalVolume,boxPacketByGroup,ice,dryIce,padding,plateSeals,bags,aliquotBoolsByContainer,
	styrofoamModelBoxPackets,cardboardModelBoxPackets,largestStyrofoamBoxPacket,largestCarboardBoxPacket,largestCardboardBoxVolume,largestStyrofoamBoxVolume},

	(* Separate the styrofoam and cardboard boxes *)
	styrofoamModelBoxPackets=Cases[myModelBoxPackets,KeyValuePattern[{ContainerMaterials->Alternatives[{Cardboard, Styrofoam}, {Styrofoam, Cardboard}]}]];
	cardboardModelBoxPackets=Cases[myModelBoxPackets,KeyValuePattern[{ContainerMaterials->{Cardboard}}]];

	(* Find the largest cardboard box and largest styrofoam box *)
	largestStyrofoamBoxPacket=LastOrDefault[SortBy[styrofoamModelBoxPackets, Times@@Lookup[#,InternalDimensions]&]];
	largestCarboardBoxPacket=LastOrDefault[SortBy[cardboardModelBoxPackets, Times@@Lookup[#,InternalDimensions]&]];

	(* Get the volume of the largest cardboard box and largest styrofoam box *)
	largestCardboardBoxVolume = Times @@ Lookup[largestCarboardBoxPacket, InternalDimensions];
	largestStyrofoamBoxVolume = Times @@ Lookup[largestStyrofoamBoxPacket, InternalDimensions];

	aliquotBoolsByContainer=If[MatchQ[Lookup[myTransactionPacket, AliquotSamplePreparation, {}],{}],
		ConstantArray[False,Length[Lookup[myTransactionPacket, SamplesIn]]],
		Lookup[Lookup[myTransactionPacket, AliquotSamplePreparation, {}],Aliquot]
	];

	(* Get the physical things that we plan to ship the transaction *)
	contents= Module[{itemsToShip, aliquotContainersToShip, allNonSelfContainedSampleOriginalContainers, nonAliquottedContainersToShip},

		(* Get the items that can be shipped directly from the transaction packet *)
		(* SelfContainedSampleP replaced by Except[ObjectP[Object[Sample]]] in order to allow shipping of empty containers*)
		itemsToShip = Cases[Download[Lookup[myTransactionPacket, SamplesIn], Object], ObjectP[{Object[Item],Object[Container]}]];

		(* Get the aliquot containers that need to be considered for transaction packets where aliquotting needs to be performed *)
		aliquotContainersToShip = Download[GatherBy[DeleteCases[Lookup[Lookup[myTransactionPacket, AliquotSamplePreparation, {}], AliquotContainer, {}], Null], First][[All, 1, 2]], Object];

		(* Get any containers for samples not being aliquoted but Exclude SelfContainedSampleTypes from being considered here so they can be shipped directly without their current containers *)
		(* When no aliquotting is done, get all the non-self contained sample original containers*)
		allNonSelfContainedSampleOriginalContainers = DeleteDuplicates[Download[Cases[Lookup[myTransactionPacket, SamplesIn], ObjectP[Object[Sample]]], Container[Object]]];

		(* If no aliquotting is done, then take all non-self contained sample containers. Otherwise, only take the containers of the subset of samples not being aliquotted*)
		nonAliquottedContainersToShip= If[MatchQ[Lookup[myTransactionPacket, AliquotSamplePreparation, {}], {}],
			allNonSelfContainedSampleOriginalContainers,
			DeleteDuplicates[
				Download[
					PickList[
						Download[Cases[Lookup[myTransactionPacket, SamplesIn], ObjectP[Object[Sample]]], Container, Date -> Now],
						Lookup[
							PickList[
								Lookup[myTransactionPacket, AliquotSamplePreparation, {}],
								MatchQ[#, ObjectP[Object[Sample]]]& /@ Lookup[myTransactionPacket, SamplesIn],
								True
							],
							Aliquot],
						False
					],
					Object
				]
			]
		];


		Join[
			itemsToShip,
			aliquotContainersToShip,
			nonAliquottedContainersToShip
		]
	];

	(* Get the models packets for any objects that were found (which will be anything that is not an aliquot container pre-Aliquot protocols), and the packets of any models that were found. *)
	contentsModels=If[MatchQ[#,ObjectP[{Object[Container],Object[Sample],Object[Item]}]],
		Download[Lookup[FirstCase[Flatten[DeleteCases[{mySamplePackets,myContainerPackets},Null]],KeyValuePattern[{Object->#}]],Model],Object],
		#
	]&/@contents;
	contentsModelsPackets=FirstCase[Flatten[DeleteCases[{mySampleModelPackets,myContainerModelPackets,myAliquotContainerModelPackets},Null]],KeyValuePattern[{Object-> #}]]&/@contentsModels;

	(* Get the dimensions and the volume of each thing being shipped *)
	contentsDimensions=Lookup[#,Dimensions]&/@contentsModelsPackets;
	contentsVolumes=Times@@#&/@contentsDimensions;

	(* Partition the samples into groups that are less than the a fraction, PackageCapacity, of volume of the largest box. (We don't need highly optimized packing since we want to leave room for packaging materials).
	 Using the label overload of GroupByTotal (which requires unique labels, so also including the index) since order is not conserved.
	 Also catching GroupByTotal error message if there is no box large enough to fir the largest sample. MaintenanceShipping will throw its own message that a box couldn't be found (since this isn't really something we want to expose to the user). *)
	groupedContentsModelsVolumes= Quiet[
		Check[
			(*The GroupByTotal call *)
			GroupByTotal[
				Transpose[{Transpose[{Range[1, Length[contentsModels]], contentsModelsPackets,contents}], contentsVolumes}],
				UnitSimplify[Lookup[myMaintenanceShippingModelPacket,PackageCapacity]*If[MatchQ[Lookup[myTransactionPacket, ColdPacking], (DryIce | Ice)], largestStyrofoamBoxVolume, largestCardboardBoxVolume]]
			],
			(* The list we will return if a sample was too large to group *)
			{Transpose[{Transpose[{Range[1, Length[contentsModels]], contentsModelsPackets,contents}], contentsVolumes}]},
			(* The error message we will catch *)
			GroupByTotal::IncompatibleValues
		],
		(* The error message we will quiet *)
		GroupByTotal::IncompatibleValues
	];
	groupedContentsIndexes = groupedContentsModelsVolumes[[All, All, 1]][[All, All, 1]];
	groupedContentsModelPackets = groupedContentsModelsVolumes[[All, All, 1]][[All, All, 2]];
	groupedContents = groupedContentsModelsVolumes[[All, All, 1]][[All, All, 3]];
	groupedContentsDimensions=Lookup[#,Dimensions]&/@groupedContentsModelPackets;
	groupedContentsVolumes=groupedContentsModelsVolumes[[All,All,2]];
	groupedContentsTotalVolume = Plus @@ # & /@ groupedContentsVolumes;

	(* For each group of samples, figure out the boxes of the appropriate material that are large enough, and pick the smallest of those boxes *)
	(* Because we are leaving space for ice/padding, we don't need a highly accurate packing estimation. Just make sure that the volume of the contents is less than the 60% of volume of the box (to leave room for error and ice/padding) and that no single content dimension exceeds the box internal dimensions *)
	boxPacketByGroup=MapThread[
		Function[{totalVolume,dimensionsByContents},
			If[MatchQ[Lookup[myTransactionPacket,ColdPacking],DryIce|Ice],
				(* Choose the largest styrofoam box to make sure we have enough ice *)
				(* Empirically medium box full of ice packs melts after just 1 day *)
				largestStyrofoamBoxPacket,
				(* Otherwise chose the smallest box that will fit our samples *)
				FirstOrDefault[
					SortBy[
						Select[
							(* Choose from cardboard box depending on if shipping room temp *)
							cardboardModelBoxPackets,
							And[
								(* volume of the contents is less than the 60% of volume of the box *)
								MatchQ[Lookup[myMaintenanceShippingModelPacket,PackageCapacity]*(Times@@Lookup[#,InternalDimensions]),GreaterP[totalVolume]],

								(* The largest X/Y dimension of the contents is smaller than the largest internal X/Y dimension of the box *)
								MatchQ[Max[Lookup[#,InternalDimensions][[1;;2]]],GreaterP[Max[Join[dimensionsByContents[[All,1]],dimensionsByContents[[All,2]]]]]],

								(* The largest Z dimension of the contents is smaller than the internal Z dimension of the box *)
								MatchQ[Lookup[#,InternalDimensions][[3]],GreaterP[Max[dimensionsByContents[[All,3]]]]]
							]&
						],
						(* Sort the selected boxes by volume *)
						Times@@Lookup[#,Dimensions]&
					]
				]
			]
		],
		{groupedContentsTotalVolume,groupedContentsDimensions}
	];

	(* Determine how many ice packs will be used in each box. (Aiming to fill a fraction, PackingMaterialsCapacity, (to leave space for packing inefficiency) of the unused box volume with ice). If a box wasn't found, returns 0 for that index.*)
	ice=If[MatchQ[Lookup[myTransactionPacket,ColdPacking],Ice],
		MapThread[
			{
				Lookup[myIcePackPacket,Object],
				If[NullQ[#2],
					0,
					Module[{calculated},
						calculated=Round[(Lookup[myMaintenanceShippingModelPacket,PackingMaterialsCapacity]*((Times@@Lookup[#2,InternalDimensions])-#1))/(Times@@Lookup[myIcePackPacket,Dimensions])];
						(* Empirically max of 9 8oz packets fit in medium, 26 in large so make sure not to add more than that if dimensions work out funny *)
						Switch[#2,
							(* Medium *) PacketP[Model[Container, Box, "id:dORYzZJVbkmG"]], Min[9, calculated],
							(* Large *) PacketP[Model[Container, Box, "id:eGakldJ4KnD1"]], Min[26, calculated],
							_,  calculated
						]
					]
				]
			}&,
			{groupedContentsTotalVolume,boxPacketByGroup}
		],
		{}
	];

	(* Determine how much dry ice will be used in each box. (Aiming to fill a fraction, PackingMaterialsCapacity, (to leave space for packing inefficiency) of the unused box volume with dry ice). If a box wasn't found, returns 0 for that index. *)
	dryIce=If[MatchQ[Lookup[myTransactionPacket,ColdPacking],DryIce],
		MapThread[
			{Lookup[myDryIcePacket,Object], If[NullQ[#2],0Gram, UnitConvert[(Lookup[myMaintenanceShippingModelPacket,PackingMaterialsCapacity]*((Times@@Lookup[#2,InternalDimensions])-#1)),"Liters"]*Lookup[myDryIcePacket,Density]]}&,
			{groupedContentsTotalVolume,boxPacketByGroup}
		],
		{}
	];

	(* Determine how much peanuts will be used in each box. (Aiming to fill a fraction, PackingMaterialsCapacity, (to leave space for packing inefficiency) of the unused box volume with peanuts). If a box wasn't found, returns 0 for that index. *)
	padding=If[MatchQ[Lookup[myTransactionPacket,ColdPacking],None|Null],
		MapThread[{Lookup[myPeanutPacket,Object], If[NullQ[#2],0Gram, UnitConvert[(Lookup[myMaintenanceShippingModelPacket,PackingMaterialsCapacity]*((Times@@Lookup[#2,InternalDimensions])-#1)),"Liters"]*Lookup[myPeanutPacket,Density]]}&,{groupedContentsTotalVolume,boxPacketByGroup}],
		{}
	];

	(* For each plate, need a more secure plate seal. Use Null for samples that are not plates so that we can index to the transaction contents *)
	plateSeals=Map[
		If[MatchQ[#,ObjectP[Model[Container,Plate]]],
			Lookup[myPlateSealPacket,Object],
			Null
		]&,Flatten[groupedContentsModelPackets]
	];

	(* For each sample container, need a secondary container bag. Choose a bag that that is at least twice as big as the container volume. We may decide that we want to pool multiple containers into a single bag, and/or that we only want bags for come containers/contents. In this case, would also want another contents grouping list. *)
	bags=MapThread[
		Function[{modelPackets,dimensions},
			If[MatchQ[modelPackets,ObjectP[Model[Container]]],
				FirstOrDefault[
					SortBy[
						Select[
							myModelBagPackets,

							(* volume of the contents is less than the 70% of volume of the bag *)
							(MatchQ[0.7*Lookup[#,MaxVolume],GreaterP[Times@@dimensions]])&&

									(* The largest dimension of the contents is smaller than the largest dimension of the bag *)
									(MatchQ[Max[Lookup[#,Dimensions]],GreaterP[Max[Lookup[modelPackets,Dimensions]]]])&
						],
						(* Sort the selected bags by volume *)
						Lookup[#,MaxVolume]&
					],
					(* note here that the default is $Failed; we only get this far if we _should_ have a bag but actually do not have a bag *)
					(* when this happens, we throw an error later *)
					$Failed
				],
				Null
			]],{Flatten[groupedContentsModelPackets],Lookup[Flatten[groupedContentsModelPackets],Dimensions]}
	];

	(* Return the grouped content indexes, objects, and model packets, the boxes (which are indexed to the content groups), ice/dry ice/padding and amount (which are indexed to the content groups), plate seals (which are indexed to flattened contents), and secondary containers (which are indexed to flattened contents) *)
	{groupedContentsIndexes,groupedContents,groupedContentsModelPackets,boxPacketByGroup,ice,dryIce,padding,bags,plateSeals}

];




(* ::Subsection::Closed:: *)
(*ShipToECL*)


(* ::Subsubsection::Closed:: *)
(*Options*)


ShippingContainerTypeP=Plate|Vessel;


DefineOptions[ShipToECL,
	Options :> {
		IndexMatching[
			IndexMatchingInput->"input",
			{
				OptionName->Volume,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterP[0 Milliliter],Units->Alternatives[Microliter,Milliliter,Liter]],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				],
				Description->"The volume of each sample being sent."
			},
			{
				OptionName->Mass,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Quantity,Pattern :> GreaterP[0 Gram],Units->Alternatives[Microgram,Gram,Kilogram]],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				],
				Description->"The mass of each sample being sent."
			},
			{
				OptionName->Count,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Number, Pattern :> GreaterP[0, 1]],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				],
				Description->"The count of each sample being sent if the sample is in tablet form."
			},
			{
				OptionName -> Position,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> WellPositionP, Size -> Word, PatternTooltip->"A well position in a plate, specified in the form of a letter character followed by a non-zero digit, for example A1"],
				Description -> "The position of the sample in the container that is being sent to an ECL facility.",
				ResolutionDescription -> "Automatically set to A1 for containers with only one position or Null for items.",
				Category->"Container Information"
			},
			{
				OptionName->ContainerType,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Enumeration,Pattern:>ShippingContainerTypeP]
				],
				Description->"Indicates if samples are being sent in a multi-well container (Plate), a tube or bottle (Vessel). Use Null when items rather than fluid samples are being sent.",
				Category->"Container Information"
			},
			{
				OptionName->EmptyContainerSent,
				Default->False,
				AllowNull->False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description->"Indicates if an empty container for use in parameterization is being sent for this sample. Only one empty container is needed for each unique container model. It's not necessary to provide an empty container if you don't wish samples to be robotically handeled in their current container or if the container model is known.",
				Category->"Container Information"
			},
			{
				OptionName->ContainerDocumentation,
				Default->Automatic,
				AllowNull->True,
				Widget -> Alternatives[
					"File Path" -> Widget[Type->String,Pattern:> FilePathP,Size->Line],
					"Product URL" -> Widget[Type->String,Pattern:> URLP,Size->Line],
					"Cloud File" -> Widget[Type->Object,Pattern:> ObjectP[Object[EmeraldCloudFile]]],
					Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]]
				],
				Description->"A product listing or specification sheet for the the model of container being sent.",
				Category->"Container Information"
			},
			{
				OptionName->ContainerModel,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Existing Object" -> Widget[
						Type->Object,
						Pattern:>ObjectP[{Model[Container,Vessel],Model[Container,Plate]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Containers"
							}
						}
					],
					"Identifier" -> Widget[Type->String,Pattern:> _String,Size->Line]
				],
				Description->"The model of the container of the sample that is being sent to an ECL facility. If the container model is not known, you can use an identifier to indicate which sample are in the same model of container.",
				ResolutionDescription -> "Required for samples. Automatically set to Null for items.",
				Category->"Container Information"
			},
			{
				OptionName -> NumberOfWells,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Number, Pattern :> RangeP[1,384,1]],
				Description -> "The number of total positions in the sample's container.",
				ResolutionDescription -> "Automatically set to 1 when samples are in a vessel and 96 when they're in a plate.",
				Category->"Container Information"
			},
			{
				OptionName -> PlateFillOrder,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Row,Column]],
				Description -> "Indicates how samples are arranged in the sample's container.",
				ResolutionDescription -> "Automatically set to Row when samples are in plate.",
				Category->"Container Information"
			},
			{
				OptionName->CoverModel,
				Default->Automatic,
				AllowNull->True,
				Widget->Alternatives[
					"Existing Object" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Item, Lid], Model[Item, PlateSeal], Model[Item, Cap]}]],
					"Identifier" -> Widget[Type->String,Pattern:> _String,Size->Line]
				],
				Description->"The model of the cover that seals the container in which the sample is being sent to an ECL facility.",
				ResolutionDescription -> "Required for samples. Automatically set to Null for items.",
				Category->"Container Information"
			},
			{
				OptionName->StorageCondition,
				Default->Automatic,
				AllowNull->False,
				Widget->Widget[
					Type->Enumeration,
					Pattern :> SampleStorageTypeP
				],
				Description->"Storage condition of each sample being sent.",
				ResolutionDescription->"Automatically determined from the default storage conditions of the samples' models.",
				Category->"Sample Properties"
			},
			{
				OptionName->NumberOfUses,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Number,Pattern :> GreaterEqualP[0,1]],
				Description->"For columns, the number of times sample has been injected onto the column.",
				Category->"Sample Properties"
			},
			{
				OptionName->Product,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern :> ObjectP[Object[Product]],ObjectTypes->{Object[Product]}],
				Description->"For commercial samples, the product corresponding to this sample.",
				Category->"Sample Properties"
			}
		],
		{
			OptionName->Source,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern :> ObjectP[Object[Container,Site]],ObjectTypes->{Object[Container,Site]}(*,ContainerToSamples->False*)],
			Description->"The site from which samples are being shipped.",
			ResolutionDescription->"If unspecified, the DefaultMailingAddress of the team requesting this transaction is used.",
			Category->"Shipping Information"
		},
		{
			OptionName -> ReceivingTolerance,
			Default -> 1*Percent,
			Description -> "Defines the allowable difference between ordered amount and received amount for every item in the transaction. Any difference greater than the ReceivingTolerance will not be received, and will instead by investigated by our Scientific Operations teams.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0Percent,100Percent],
				Units :> Alternatives[Percent]
			],
			Category -> "Hidden"
		},
		(* All options below except shipped rack can be shared with DropShipSamples *)
		{
			OptionName->Destination,
			Default->Automatic,
			AllowNull->False,
			Widget->Widget[Type->Object,Pattern :> ObjectP[Object[Container,Site]],ObjectTypes->{Object[Container,Site]},PreparedContainer->False],
			Description->"The ECL site the samples are being sent to."
		},
		IndexMatching[
			IndexMatchingInput->"input",
			{
				OptionName->DateShipped,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Date,Pattern :> _?DateObjectQ,TimeSelector->False],
				Description->"The date the package was picked up by the shipping company.",
				ResolutionDescription->"Set to Null when creating a new transaction, to Now when updating a transaction with shipping info for the first time, to the existing DateShipped value when updating a transaction.",
				Category->"Shipping Information"
			},
			{
				OptionName->ExpectedDeliveryDate,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->Date,Pattern :> _?DateObjectQ,TimeSelector->False],
				Description->"The date that the samples are expected to arrive at the ECL facility.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing DateExpected value when updating a transaction.",
				Category->"Shipping Information"
			},
			{
				OptionName->TrackingNumber,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[Type->String,Pattern :> _String,Size->Word],
				Description->"The tracking number(s) of the package(s) being shipped to the ECL facility.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing TrackingNumbers value when updating a transaction.",
				Category->"Shipping Information"
			},
			{
				OptionName->Shipper,
				Default->Automatic,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern :> ObjectP[Object[Company,Shipper]],ObjectTypes->{Object[Company,Shipper]},
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Shipping Companies"
						}
					}
				],
				Description->"The shipping company responsible for transporting the samples to ECL.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing Shipper value when updating a transaction.",
				Category->"Shipping Information"
			},
			{
				OptionName->ShippedRack,
				Default->Null,
				AllowNull->True,
				Widget->Widget[Type->Object,Pattern:>ObjectP[Model[Container, Rack]],PreparedContainer->False],
				Description->"The rack that is shipped holding other items in this order. Only specify the number of racks that are physically shipped.",
				Category->"Container Information"
			},
			{
				OptionName->ContainerOut,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Model[Container]],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Containers"
						}
					},
					PreparedContainer->False
				],
				Description->"The type of container to transfer the sample into upon receipt.",
				Category->"Sample Storage"
			}
		],
		{
			OptionName->Output,
			Default->Result,
			AllowNull->False,
			Widget->Alternatives[
				Adder[Widget[Type->Enumeration,Pattern:>CommandBuilderOutputP]],
				Widget[Type->Enumeration,Pattern:>CommandBuilderOutputP]
			],
			Category->"Hidden",
			Description->"Indicate what the function should return."
		},
		EmailOption,
		UploadOption,
		CacheOption,
		FastTrackOption,
		NameOption
	}
];



(* ::Subsubsection::Closed:: *)
(*Errors*)


Error::NumberOfUsesNotRequired="The NumberOfUses option is not required for `1` because it is not an item for which number of injections is tracked (e.g. columns). Please set it to Null or leave it blank.";
Error::IncompatibleCoverModel="The CoverModel option must not be set when the ContainerModel is self-covering, meaning that either Ampoule or BuiltInCover is True.";
Error::PositionNotRequired="The Position option is not required for `1` because it is not a sample (and therefore is not in a container). Please set it to Null or leave it blank.";
Error::PositionRequired="Position could not be determined for `1`. If position is not specified for any samples in a container it will be determined automatically by assuming the plate wells are filled according to the specified plate fill order.";
Error::CountNotRequired="Count is not required for `1` because it is not a tablet.";
Error::ShippingOptionNotRequired="The option `1` is not required for `2`. Please set it to Null or leave it unspecified.";
Error::ShippingOptionRequired="The option `1` must be specified for `2`. Please specify `1` for this sample.";
Error::InvalidPosition="The position specified for the input does not exist in the specified container: `1`.";
Warning::AmountWillBeMeasured="No amount information was provided for `1`. The amount will be measured upon arrival at the ECL site. This may involve transferring or thawing samples. If you prefer to determine the sample amount yourself, please specify Mass, Volume or Count.";
Error::ReusedPosition="The inputs `1` appear with other samples in the same positions of the same containers (e.g. both in multiple samples in well A1 of plate 1). Please make sure to specify a unique position for each sample. An input with the same container model, position, and name is considered to be in the same position.";
Error::InsufficientContainerSpace="The containers `1` do not have sufficient space to hold the indicated samples. If these containers should have sufficient space adjust the ContainerModel or NumberOfWells. Alternatively, modify your container labels to indicate samples are in distinct containers.";
Error::ContainerOutNotRequired="The ContainerOut option is not required for `1` because it is not a sample (and therefore will not be put into a container). Please set it to Null or leave it blank.";
Error::ContainersMayNotSpanShipments="Multiple sets of shipping information is specified for each of these containers: `1`, Please specify only one set of shipping information (TrackingNumber, Shipper, DateShipped, DateExpected) for a container. Alternatively, a single value may be specified for each of these options. ";
Error::NoNotebook = "The notebook could not be found. Please call this function from a notebook so that the financing team, the source of the transaction, and the location of items can be determined.";
Error::ShipToECLDuplicateName="These names, `1`, are specified more that once for these models, `2`. Please make sure any specified names are unique between any input items or vessels.";
Error::AmountNotRequired="Volume and Mass are not required for `1` because it is not a sample.";
Error::InvalidDates = "The DateShipped `1` is later than the ExpectedDeliveryDate `2`. Please make sure that the shipment date is earlier than the expected delivery date.";
Error::TrackingNumberAndShipperRequiredTogether = "Tracking number and shipper must always be provided together. Please set these tracking number/shipper pairs both to a value or to Null: `1`.";
Error::NameInUse="These names, `1`, are already in use for types `2`. Use DatabaseMemberQ to verify that a name has not been taken or, alternatively, do not specify a name.";
Error::VolumeExceedsContainerOut="The specified container out, `1`, is too small for the specified volume `2` for input samples `3`.";
Warning::ContainerOutNotValidated="The volume of `1` is not known. If the volume of the sample exceeds the volume of the specified container out, `2`, the sample will be transferred to a different container.";
Error::ContainerOutInconsistent="The inputs `1` have different ContainerOut specifications `2`. Please specify only one ContainerOut per unique input, or do not specify ContainerOut.";
Error::IncompatibleCoverModelType = "The ContainerModels `1` have CoverTypes and/or CoverFootprints fields that do not match the CoverModels `1`. If you are using a new type of cover, set CoverModel -> Automatic to allow for the creation of a new model during receiving.";
Error::ContainerSpecificationConflict = "Container information must be consistent across all samples in the same container. Please check samples marked as being in the same containers (`1`), and provide additional unique labels to indicate these samples are actually in distinct containers or check `2` for consistency across this container.";
Error::NoCompatibleRack = "The non-self standing ContainerModels `1` do not have any compatible rack models in the database. Please create a new rack model, order one to the lab, or correct the SelfStanding field of your ContainerModel if you believe that the container is capable of standing unsupported without invalidating results pertaining to the sample contained inside.";
Error::IncompatibleProvidedRackModel = "The provided rack models `1` are not capable of holding containers of model `2` in an upright orientation. Please check the dimensions of the positions in this rack and ensure they are larger than the sample container but small enough to hold the sample securely or provide a different rack.";
Error::TransactionStatus = "Once a transaction has been Received or Canceled it can no longer be updated. Please check the Status of `1`.";

Error::ContainerModelTypeMismatch = "When specifying the ContainerModel option, ContainerType is determined automatically and cannot conflict with the type of model provided. Please check `1` and allow ContainerType to be determined automatically or ensure it matches with the provided model.";
Error::NumberOfWellsMismatch = "The specified number of wells must match the recorded number of wells in the ContainerModel. Please allow number of wells to resolve automatically or don't specify the ContainerModel option in order to parameterize a new container during the receiving process.";
Error::NonstandardWellNumber = "The samples `1` indicate they are in a vessel, but the NumberOfWells is greater than 1. Please set this to 1 or indicate samples are in a plate.";
Error::ContainerInformationNotRequired="No information about the container model should be provided for `1` because it is not a sample (and therefore is not in a container). Please don't specify `2` for these items.";
Error::NoPlateFillOrder= "Samples appear to be in a vessel and therefore PlateFillOrder cannot be specified. Please use ContainerType or ContainerModel to provide more container information or allow PlateFillOrder to be set automatically.";
Error::ContainerInformationRequired="Information about the container is required for samples. Please check `1` and make sure `2` are not set to Null.";
Warning::EmptyContainerUnneeded = "The specified container model for `1` has already been parameterized so you don't need to send an empty container, though there is no harm in doing so.";
Warning::ContainerTransferForRoboticUse = "No model information was provided for the following containers: `1`. If you wish to guarantee use of these samples in a robotic process without having them automatically transferred into a new container, please provide container documentation. Note if your samples are already in an Emerald supported container, this can be determined during the receiving process and no information will be needed.";
Error::PlateOptionsRequired = "As there are multiple samples in `1`, options describing the plate cannot be Null. Please provide unique labels to indicate these samples are actually in vessels or specify `2`.";
Warning::UnneededContainerDocumentation = "No container documentation is needed for `1` as they are already in a known container model. This documentation will not be used. If a new container model should be created please set ContainerModel to a unique label or leave it unspecified.";
Error::ConflictingContainerDocumentation = "Container documentation cannot be reused for containers with different properties. If providing documentation please make sure to specify a unique file for each unique type of plate and/or vessel being sent. Check `1`.";
Error::ContainerDocumentationFiles = "Files specified for container documentation could not be found. Please check `1` and make sure these files exist on your local machine.";

(* ::Subsubsection::Closed:: *)
(*ShipToECL (model overload)*)


(* --- ShipToECL transaction creation ---- *)

(* Empty list case *)
ShipToECL[{},myOptions:OptionsPattern[ShipToECL]]:={};


(* Creates a transaction object for sending samples to user *)
ShipToECL[myModels:ListableP[ObjectP[{Model[Item],Model[Sample]}]], myContainerLabels:ListableP[_String],myOptions:OptionsPattern[ShipToECL]]:=Module[
	{
		safeOptions, requestor, sampleObjects,optionPackets, allPackets, modelFields, downloadPackets,cache,newCache,
		transactionStatuses,sourcePosition, team,sampleSourcePackets, cleanedInputModels, namedSafeOptions,
		samplesAndShippingInfo,transactionInfoGroupedByShipping,containerTallies,splitContainers,transactionPackets,
		partitionedSamples, partitionedContainers, partitionedDateExpected, partitionedTrackingNumber, partitionedShipper,
		partitionedDateShipped,transactionStatusPackets,notebookTest,
		outputSpecification,output,listedOptions,resolvedOptionsForDisplay,gatherTests,safeOptionTests,validLengths,validLengthTests,
		resolvedOptions,resolvedOptionsTests,resolvedOptionsResult,itemsToMake,itemStorageConditions,newItemPackets,itemObjects,
		previewRule,optionsRule,testsRule, resultRule,splitContainerTest,messagesBoolean, storageConditionsFields,storageConditions,nameOption,
		sampleDestinationPackets, modelContainerFields, containerSourcePackets, partitionedContainerOut,
		expandedOptions, expandedModelSamples, expandedNames,listedModels, listedNames,specifiedContainerModels,specifiedRackModels, rackModelFields,
		resolvedContainerModels, containersAndCoverModels,newCapTuples,newLidTuples,newCapsModels,newLidsModels,
		coverModelIDLookup,updatedCoverModels,newCoverModelPackets,coverModelIDs,sampleCoversTuples,sampleCoversToCreate,coveredContainers,
		emptyCoverTuples,emptyCoverModels,coveredEmptyContainers,allNewCoverModels,newCoverUploadPackets,cleanedCoverPackets,
		newSampleCoverPackets,newSampleCoverObjects,resolvedContainerTypes,containerDocumentationFiles,resolvedNumberOfWells,
		newUserDocFiles,userDocWebsites,urlFilePaths,newUserDocsUploadPacket,userDocsLookup,
		mergedUserDocs,containerTypesAndModels,newVesselModelsNeeded,requiredPositionsLookup,
		newPlateModelsNeeded,newVesselModels,newPlateModels,containerModelIDLookup,updatedContainerModels,newContainerModelPackets,containerModelIDs,
		desiredContainerModels,desiredContainerNames,nonDuplicateContainerModelsAndNames,nonDuplicateContainerModels,
		nonDuplicateContainerNames, emptiesSent,nonDuplicateEmptyContainerModelsAndNames,nonDuplicateEmptyContainerModels,
		nonDuplicateEmptyContainerNames,allNewContainerModels,newContainerUploadPackets,
		newContainerPackets,newSampleContainerPackets,newEmptyContainerPackets, indexMatchedSampleContainers,
		samplesToMake,samplePositions,sampleContainers,sampleLocations,sampleStorageConditions,newSamplePackets,
		itemIndexes,sampleIndexes,indexObjectRules,indexedCreatedObjects,sampleToContainerRules,indexedCreatedContainers,
		allObjectSampleEHSFields, specifiedCoverModels, modelCoverFields, resolvedCoverModels, newCoverPackets,
		uploadCoverPackets, newEmptyContainerCoverPackets,
		newEmptyContainerCoverObjects, partitionedRacks, newRackObjects, newRackPackets, formatCachePacket
	},

	(* ------------------------ *)
	(* -- Set up and options -- *)
	(* ------------------------ *)

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messagesBoolean = !gatherTests;

	(* Call SafeOptions to make sure all options match pattern *)
	{namedSafeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ShipToECL,listedOptions,AutoCorrect->False, Output->{Result,Tests}],
		{SafeOptions[ShipToECL,listedOptions,AutoCorrect->False],Null}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[namedSafeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* if not gathering tests, then throw an error if notebook is null *)
	If[!gatherTests && NullQ[$Notebook],
		Message[Error::NoNotebook];
	];

	(* test to make sure that there is a notebook *)
	notebookTest=If[gatherTests,
		If[NullQ[$Notebook],
			Test["The notebook could be found.",True,False],
			Test["The notebook could be found.",True,True]
		],
		{}
	];

	If[NullQ[$Notebook],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> {notebookTest},
			Options -> namedSafeOptions,
			Preview -> Null
		}]
	];

	(* If Null of the inputs are listed, list them (otherwise ExpandIndexMatchedInputs doesn't expand them)*)
	{listedModels, listedNames}=If[MatchQ[{myModels,myContainerLabels}, {Except[_List], Except[_List]}],
		ToList/@{myModels,myContainerLabels},
		{myModels,myContainerLabels}
	];

	(* Expand any single inputs *)
	{{expandedModelSamples, expandedNames}, expandedOptions}=ExpandIndexMatchedInputs[ShipToECL, {listedModels, listedNames}, namedSafeOptions, 1];

	(* replace all objects referenced by Name to ID and verify IDs exist *)
	{cleanedInputModels, safeOptions} = Experiment`Private`sanitizeInputs[expandedModelSamples, namedSafeOptions];

	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> safeOptions,
			Preview -> Null
		}]
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests}=Quiet[If[MemberQ[ToList[outputSpecification],Tests],
		ValidInputLengthsQ[ShipToECL,{cleanedInputModels, expandedNames},safeOptions,1,Output->{Result,Tests}],
		{ValidInputLengthsQ[ShipToECL,{cleanedInputModels, expandedNames},safeOptions,1],Null}
	],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Get the current user. The person who is logged in is the person making the transaction *)
	requestor=$PersonID;

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Assemble the fields to download for the any model containers in the options *)
	specifiedContainerModels = DeleteDuplicates[Cases[Lookup[safeOptions, ContainerModel], ObjectP[]]];
	specifiedRackModels = DeleteDuplicates[Cases[Lookup[safeOptions, ShippedRack], ObjectP[]]];

	rackModelFields = ConstantArray[{Packet[Positions]}, Length[specifiedRackModels]];
	modelContainerFields=ConstantArray[
		{
			Packet[
				Positions,
				Dimensions,
				VerifiedContainerModel,
				BuiltInCover,
				Ampoule,
				CoverFootprints,
				CoverTypes,
				Footprint,
				SelfStanding,
				NumberOfWells,
				AspectRatio
			]
		},
		Length[specifiedContainerModels]
	];

	(* Assemble fields to download for any covers *)
	specifiedCoverModels = DeleteDuplicates[Cases[Lookup[safeOptions, CoverModel], ObjectP[]]];
	modelCoverFields = ConstantArray[{Packet[CoverType, CoverFootprint, VerifiedCoverModel]}, Length[specifiedContainerModels]];

	(* Get all of the safety fields that need to be copied over from the Model[Sample] to the Object[Sample]. *)
	allObjectSampleEHSFields=Intersection[
		ToExpression/@Options[ExternalUpload`Private`ObjectSampleHealthAndSafetyOptions][[All,1]],
		Fields[Model[Sample],Output->Short]
	];

	(* Assemble the fields to download for the input models *)
	modelFields=ConstantArray[
		{
			Packet[
				DefaultStorageCondition,
				State,
				Flammable,
				Acid,
				Base,
				Pyrophoric,
				Dimensions,
				Tablet,
				SolidUnitWeight,
				Density,
				Composition,
				Solvent,
				Sequence@@allObjectSampleEHSFields,
				Products]
		},
		Length[cleanedInputModels]
	];

	(* Get the model storage conditions and assemble fields we want to download from them *)
	storageConditions=Search[Model[StorageCondition]];
	storageConditionsFields=ConstantArray[
		{
			Packet[
				Temperature,
				Flammable,
				Acid,
				Base,
				Pyrophoric,
				PricingRate,
				Flammable,
				StorageCondition,
				Desiccated,
				AtmosphericCondition]
		},
		Length[storageConditions]
	];

	cache = Lookup[safeOptions,Cache];

	(* Download Call *)
	downloadPackets=Quiet[
		Download[
			Flatten[{
				$Notebook,
				$Notebook,
				$Notebook,
				{Lookup[safeOptions,Source] /. Automatic -> Null},
				cleanedInputModels,
				storageConditions,
				specifiedContainerModels,
				specifiedRackModels
			}],
			Evaluate[Join[
				{{Financers[DefaultMailingAddress][Object]}},
				{{Financers[DefaultMailingAddress][Model][Positions]}},
				{{Financers[Object]}},
				{{Model[Positions]}},
				modelFields,
				storageConditionsFields,
				modelContainerFields,
				rackModelFields
			]],
			Cache->cache,
			Date -> Now
		],
		Download::FieldDoesntExist
	];

	(* Get the financer of the notebook *)
	(* Eventually, there will only be one financer per notebook, but for now it is still a multiple *)
	team=FirstOrDefault[Flatten[{downloadPackets[[3]]}]];

	(* Combine the downloaded packets with the old cache to get the new cache. *)
	newCache = Cases[Flatten[{Lookup[safeOptions,Cache], downloadPackets}], PacketP[]];

	(* --------------------- *)
	(* -- resolve options -- *)
	(* --------------------- *)

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveShipToECLOptions[cleanedInputModels,expandedNames,expandedOptions,Cache->newCache,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveShipToECLOptions[cleanedInputModels,expandedNames,expandedOptions,Cache->newCache],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	resolvedOptionsForDisplay=If[MatchQ[resolvedOptions,{(_Rule|_RuleDelayed)..}],
		CollapseIndexMatchedOptions[
			ShipToECL,
			RemoveHiddenOptions[ShipToECL, resolvedOptions],
			Messages -> False
		],
		resolvedOptions
	];

	(* If option resolution failed, return here *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,resolvedOptionsTests],
			Options -> resolvedOptionsForDisplay,
			Preview -> Null
		}]
	];

	(* For speed, we don't want to create all the upload packets if we aren't asking for a result *)
	(* If these uploads are throwing any errors we need to add to our resolver checks to avoid, but we don't expect that *)
	If[!MemberQ[ToList[outputSpecification],Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Join[safeOptionTests,validLengthTests,resolvedOptionsTests],
			Options -> resolvedOptionsForDisplay,
			Preview -> Null
		}]
	];

	(* ------------------------ *)
	(* -- Create new objects -- *)
	(* ------------------------ *)

	(* We want to upload all our packets at the same time. We will need to send in new packets using the cache option to certain functions *)
	(* In order to use a packet for a cache any Append/Replace heads must be removed. This is safe since we're only using this for new objects *)
	formatCachePacket[packet_Association]:=KeyMap[Replace[#, {Replace[field_] :> field, Append[field_] :> field}]&,packet];

	(* We will use the first position of the source site as the container for any items *)
	sourcePosition = If[MatchQ[Lookup[safeOptions,Source],ObjectP[Object[Container,Site]]],
		First[Lookup[downloadPackets[[4]][[1]], Name]],
		First[Lookup[downloadPackets[[2]][[1]][[1]], Name]]
	];

	(* ------------------------------ *)
	(* -- Make the new containers --  *)
	(* ------------------------------ *)

	{resolvedContainerModels,resolvedContainerTypes,containerDocumentationFiles,resolvedNumberOfWells} = Lookup[
		resolvedOptions,
		{ContainerModel, ContainerType, ContainerDocumentation, NumberOfWells}
	];

	(* Prepare user documentation files. FilePathP can match URLs so pull those out first *)
	userDocWebsites = DeleteDuplicates[Cases[containerDocumentationFiles, URLP]];
	newUserDocFiles = DeleteDuplicates[Complement[Cases[containerDocumentationFiles, FilePathP],userDocWebsites]];

	(* If the user sent us a url for now we will just stash that in a file. Ultimately we should try to download this, but just URLDownload is unreliable  *)
	urlFilePaths = FileNameJoin[{$TemporaryDirectory, ToString[CreateUUID[]] <> ".txt"}] & /@ userDocWebsites;
	MapThread[Export[#1, #2] &, {urlFilePaths, userDocWebsites}];

	(* Create our unique cloud files and then restore index-matching *)
	newUserDocsUploadPacket = UploadCloudFile[Join[newUserDocFiles,urlFilePaths], Upload->False];
	userDocsLookup = AssociationThread[Join[newUserDocFiles,userDocWebsites], Lookup[newUserDocsUploadPacket,Object]];

	(* Re-index our docs. We leave this option as a long Automatic so it's not a hidden Null but don't want to try to put that in a field *)
	mergedUserDocs = Map[
		Lookup[userDocsLookup, #, #/.Automatic->Null]&,
		containerDocumentationFiles
	];

	(* Make new container models - one for each unique string provided *)
	containerTypesAndModels = Transpose[{resolvedContainerTypes, resolvedContainerModels}];

	(* Get the unique vessel and plate models needed *)
	newVesselModelsNeeded = DeleteDuplicates[Cases[containerTypesAndModels, {Vessel, _String}]];
	newPlateModelsNeeded = DeleteDuplicates[Cases[containerTypesAndModels, {Plate, _String}]];

	newVesselModels = CreateID[ConstantArray[Model[Container,Vessel],Length[newVesselModelsNeeded]]];
	newPlateModels = CreateID[ConstantArray[Model[Container,Plate],Length[newPlateModelsNeeded]]];

	(* Make a lookup to link container model info to their new IDs *)
	containerModelIDLookup = AssociationThread[
		Join[newVesselModelsNeeded, newPlateModelsNeeded],
		Join[newVesselModels, newPlateModels]
	];

	(* Positions needed in plate - format container model/position info as <|model -> {position, ...}|> *)
	requiredPositionsLookup = GroupBy[Transpose[Lookup[resolvedOptions, {ContainerModel, Position}]], First -> Last];

	(* Create our packets. We're preserving index matching here so we will end up with some duplicate packets with the same IDs and info *)
	updatedContainerModels = MapThread[
		Function[{containerModel, newContainerType, userDocs},
			If[MatchQ[containerModel, _String],
				Module[{requiredPositions},

					(* Just make positions for the wells that we know have sample, can't really trust anything beyond that *)
					(* ValidUploadLocationQ will check that our containers have these positions when we go to make samples *)
					requiredPositions=Lookup[requiredPositionsLookup,containerModel];

					<|
						Object -> Lookup[containerModelIDLookup, Key[{newContainerType, containerModel}]],
						Replace[ProductDocumentationFiles] -> Link[userDocs],
						ParameterizationPlaceholder -> True,
						VerifiedContainerModel -> False,
						Replace[Positions] -> (
							Map[
								<|
									Name -> #,
									Footprint -> Null,
									MaxWidth -> Null, MaxDepth -> Null, MaxHeight -> Null
								|>&,
								requiredPositions
							]
						),
						(* We add dummy dimensions here so we can store our containers before parameterization *)
						(* These should get updated during the receive *)
						(* This is the same strategy used in compileReceiveInventory for products with new containers *)
						Dimensions -> {1 Millimeter, 1 Millimeter, 1 Millimeter}
					|>
				],
				containerModel
			]
		],
		{resolvedContainerModels, resolvedContainerTypes, mergedUserDocs}
	];

	(* Get our list of container models to upload *)
	newContainerModelPackets=DeleteDuplicates[Cases[updatedContainerModels,PacketP[]]];

	containerModelIDs = Map[
		If[MatchQ[#, PacketP[]],
			Lookup[#, Object],
			#
		]&,
		updatedContainerModels
	];

	(* -- Prepare to create the containers holding the samples being shipped  -- *)
	desiredContainerModels = Cases[containerModelIDs,ObjectP[]];
	desiredContainerNames = PickList[expandedNames,containerModelIDs,ObjectP[]];

	nonDuplicateContainerModelsAndNames = DeleteDuplicates[Transpose[{desiredContainerModels, desiredContainerNames}]];
	nonDuplicateContainerModels = nonDuplicateContainerModelsAndNames[[All,1]];
	nonDuplicateContainerNames = nonDuplicateContainerModelsAndNames[[All,2]];

	(* -- Prepare to create the empty containers -- *)
	emptiesSent = Lookup[resolvedOptions, EmptyContainerSent];
	nonDuplicateEmptyContainerModelsAndNames = Cases[DeleteDuplicates[Transpose[{emptiesSent, containerModelIDs, expandedNames}]], {True,_,_}];
	nonDuplicateEmptyContainerModels = nonDuplicateEmptyContainerModelsAndNames[[All,2]];
	nonDuplicateEmptyContainerNames = "Empty Container for "<>#&/@nonDuplicateEmptyContainerModelsAndNames[[All,3]];

	allNewContainerModels=Join[nonDuplicateContainerModels,nonDuplicateEmptyContainerModels];

	newContainerUploadPackets = UploadSample[
		allNewContainerModels,
		ConstantArray[
			{sourcePosition, Lookup[resolvedOptions, Source]},
			Length[allNewContainerModels]
		],
		Name -> Join[nonDuplicateContainerNames,nonDuplicateEmptyContainerNames],
		Status -> Transit, Upload -> False, FastTrack -> True, Cache -> (formatCachePacket/@Cases[updatedContainerModels,PacketP[]]),
		StorageCondition -> Join[
			ConstantArray[Automatic,Length[nonDuplicateContainerModels]],
			ConstantArray[AmbientStorage,Length[nonDuplicateEmptyContainerModels]]
		]
	];

	(* Upload sample will return all modified objects, including the Site. We only want the containers created, which are
	 the first N objects returned, where N is the number of models we generated a container for *)
	newContainerPackets = Take[newContainerUploadPackets, Length[allNewContainerModels]];
	{newSampleContainerPackets, newEmptyContainerPackets} = TakeDrop[newContainerPackets, Length[nonDuplicateContainerModels]];

	(* Reindex the container object packets to our inputs *)
	indexMatchedSampleContainers = MapThread[
		Function[{containerModel,containerName},
			If[MatchQ[containerModel,ObjectP[]],
				FirstCase[newSampleContainerPackets,KeyValuePattern[{Name->containerName,Model->LinkP[containerModel]}]],
				Null
			]
		],
		{containerModelIDs,expandedNames}
	];

	(* ------------------- *)
	(* -- Upload Covers -- *)
	(* ------------------- *)

	resolvedCoverModels = Lookup[resolvedOptions, CoverModel];

	(* Get a list of all sample covers needed *)
	(* Make a new container models - one for each unique string provided *)
	containersAndCoverModels = Transpose[{resolvedContainerTypes, resolvedCoverModels}];

	(* Get the unique vessel and plate models needed *)
	newCapTuples = DeleteDuplicates[Cases[containersAndCoverModels, {Vessel, _String}]];
	newLidTuples = DeleteDuplicates[Cases[containersAndCoverModels, {Plate, _String}]];

	newCapsModels = CreateID[ConstantArray[Model[Item, Cap],Length[newCapTuples]]];
	newLidsModels = CreateID[ConstantArray[Model[Item, PlateSeal],Length[newLidTuples]]];

	(* Make a lookup to link cover model info to their new IDs *)
	coverModelIDLookup = AssociationThread[
		Join[newCapTuples, newLidTuples],
		Join[newCapsModels, newLidsModels]
	];

	(* Note we may end up with duplicate packets here since each plate only needs one lid but we'll have unique ID *)
	updatedCoverModels = MapThread[
		Function[{containerType, coverModel},
			If[StringQ[coverModel],
				<|
					Object -> Lookup[coverModelIDLookup, Key[{containerType, coverModel}]],
					VerifiedCoverModel -> False
				|>,
				coverModel
			]
		],
		{resolvedContainerTypes, resolvedCoverModels}
	];

	(* Get our list of container models to upload *)
	newCoverModelPackets=DeleteDuplicates[Cases[updatedCoverModels,PacketP[]]];

	(* Pull out cover model IDs from any packets in the list *)
	coverModelIDs = Map[
		If[MatchQ[#, PacketP[]],
			Lookup[#, Object],
			#
		]&,
		updatedCoverModels
	];



	(* Need one cover per unique sample container (e.g. one lid per plate) *)
	sampleCoversTuples = DeleteDuplicates[Cases[Transpose[{coverModelIDs, indexMatchedSampleContainers}], {ObjectP[], _}]];
	sampleCoversToCreate = sampleCoversTuples[[All,1]];
	coveredContainers = sampleCoversTuples[[All,2]];

	(* Assume that if our sample container is covered our empty container is also covered with the same model *)
	emptyCoverTuples = Cases[DeleteDuplicates[Transpose[{emptiesSent, coverModelIDs, indexMatchedSampleContainers}]], {True,_, _}];
	emptyCoverModels = emptyCoverTuples[[All,2]];
	coveredEmptyContainers = Transpose[{newEmptyContainerPackets,emptyCoverTuples}][[All,1]];

	allNewCoverModels = Join[sampleCoversToCreate, emptyCoverModels];

	newCoverUploadPackets = UploadSample[
		allNewCoverModels,
		ConstantArray[{sourcePosition, Lookup[resolvedOptions, Source]}, Length[allNewCoverModels]],
		Status -> Transit,
		Upload -> False,
		FastTrack -> True,
		Cache -> (formatCachePacket/@Cases[updatedCoverModels,PacketP[]])
	];

	(* remove any packets that deal with location, as these caps are going straight on to the container *)
	cleanedCoverPackets = DeleteCases[newCoverUploadPackets, (KeyValuePattern[Append[Contents]->_]|KeyValuePattern[Container -> _])];

	(* First N packets gives us our new cover object packets  *)
	newCoverPackets = Take[cleanedCoverPackets, Length[allNewCoverModels]];

	{newSampleCoverPackets,newEmptyContainerCoverPackets} = TakeDrop[newCoverPackets, Length[sampleCoversToCreate]];

	(* get the object to make this a bit easier *)
	newSampleCoverObjects = Lookup[newSampleCoverPackets, Object, {}];
	newEmptyContainerCoverObjects = Lookup[newEmptyContainerCoverPackets, Object, {}];

	(* Upload cover, sending in cache for upload packets so far  *)
	uploadCoverPackets = If[MatchQ[{newSampleCoverObjects,newEmptyContainerCoverObjects}, {{},{}}],
		{},
		UploadCover[
			Join[Lookup[coveredContainers, Object, {}],Lookup[coveredEmptyContainers, Object, {}]],
			Cover -> Join[newSampleCoverObjects,newEmptyContainerCoverObjects],
			Upload ->False,
			Cache -> (formatCachePacket/@Join[
				Map[
					<|Object -> Lookup[#, Object], Cover ->Null|>&,
					newContainerPackets
				],
				newCoverPackets,
				Cases[updatedCoverModels,PacketP[]]
			])
		]
	];

	(* ----------------- *)
	(* -- Make racks --  *)
	(* ----------------- *)

	(* make racks into objects, preserve any ordering so that they will partition correctly  *)
	{newRackPackets, newRackObjects} =
		Module[{shippedRacks, rackModels, modelPositions, rackObjectPackets, indexMatchedRackPackets, matchedRackObjects, transposedRackPackets},
			shippedRacks = Lookup[resolvedOptions, ShippedRack];
			rackModels = Cases[shippedRacks, ObjectP[Model[Container, Rack]]];

			(* early return if we don't have any racks *)
			If[MatchQ[rackModels, {}],
				Return[{{}, shippedRacks}, Module]
			];

			(* get the positions that the racks are in  *)
			modelPositions = Flatten[Position[shippedRacks, ObjectP[Model[Container, Rack]]]];
			rackObjectPackets = UploadSample[rackModels, ConstantArray[{sourcePosition, Lookup[resolvedOptions, Source]}, Length[rackModels]],Status->Transit, StorageCondition->Model[StorageCondition, "Ambient Storage"],Upload->False,FastTrack->True,Cache->newCache];
			transposedRackPackets = Transpose[Partition[rackObjectPackets, Length[rackModels]]];
			indexMatchedRackPackets =ReplacePart[shippedRacks, MapThread[(#1->#2)&,{modelPositions, transposedRackPackets}]];

			(* get the rack objects out of the packets *)
			matchedRackObjects = Map[
				If[MatchQ[#, Null],
					Null,
					FirstCase[Lookup[#, Object], ObjectP[Object[Container, Rack]]]
				]&,
				indexMatchedRackPackets
			];

			{Flatten[rackObjectPackets], matchedRackObjects}
		];

	(* ------------------------ *)
	(* -- Upload new samples -- *)
	(* ------------------------ *)

	(* Call UploadSample to make the samples. Put each sample in the appropriate container (from above) and position *)
	samplesToMake = Cases[cleanedInputModels, ObjectP[Model[Sample]]];
	samplePositions = PickList[Lookup[resolvedOptions,Position], cleanedInputModels, ObjectP[Model[Sample]]];
	sampleContainers = PickList[indexMatchedSampleContainers, cleanedInputModels, ObjectP[Model[Sample]]];
	sampleLocations = Transpose[{samplePositions,sampleContainers}];
	sampleStorageConditions = PickList[Lookup[resolvedOptions,StorageCondition], cleanedInputModels, ObjectP[Model[Sample]]];

	newSamplePackets = UploadSample[
		samplesToMake,
		sampleLocations,
		Status->Transit,
		StorageCondition->sampleStorageConditions,
		Upload->False,
		FastTrack->True,
		Cache->(formatCachePacket/@Experiment`Private`FlattenCachePackets[
			{newCache, newContainerPackets, updatedContainerModels}
		])
	];

	(* The first packets output by UploadSample are the initial sample packets and they are ordered to match the model input. *)
	sampleObjects=Lookup[Take[newSamplePackets, Length[samplesToMake]], Object];

	(* - Make the items - *)
	(* Call UploadSample to make the items. Put each item in the source site. *)
	itemsToMake = Cases[cleanedInputModels, ObjectP[Model[Item]]];
	itemStorageConditions = PickList[Lookup[resolvedOptions,StorageCondition], cleanedInputModels, ObjectP[Model[Item]]];

	newItemPackets = UploadSample[
		itemsToMake,
		ConstantArray[{sourcePosition, Lookup[resolvedOptions, Source]}, Length[itemsToMake]],
		Status->Transit,
		StorageCondition->itemStorageConditions,
		Upload->False,FastTrack->True,
		Cache->Experiment`Private`FlattenCachePackets[{newCache}]
	];

	(* The first packets output by UploadSample are the initial sample packets and they are ordered to match the model input. *)
	itemObjects=Lookup[Take[newItemPackets, Length[itemsToMake]], Object];

	(* Get the sample and item objects indexed to the input *)
	itemIndexes=Flatten[Position[cleanedInputModels, ObjectP[Model[Item]], {1}]];
	sampleIndexes=Flatten[Position[cleanedInputModels, ObjectP[Model[Sample]], {1}]];
	indexObjectRules=Join[AssociationThread[sampleIndexes, sampleObjects],AssociationThread[itemIndexes, itemObjects]];
	indexedCreatedObjects=Values[KeySort[indexObjectRules]];

	(* Get the sample containers indexed to the input *)
	sampleToContainerRules = Flatten[{Download[Lookup[#, Append[Contents]][[All, 2]][[1]], Object] -> Lookup[#, Object]} & /@ Cases[newSamplePackets, KeyValuePattern[Append[Contents] -> _]]];
	indexedCreatedContainers = indexedCreatedObjects /. Join[sampleToContainerRules, {ObjectP[Object[Item]] -> Null}];

	(* prepare updates for the samples*)
	optionPackets=MapThread[
		Function[{object,validatedVolume,validatedMass,validatedCount, validatedProduct,validedNumberOfUses},
			<|
				Object->object,
				If[NullQ[validatedVolume],Nothing,Volume->validatedVolume],
				If[NullQ[validatedVolume],Nothing,Replace[VolumeLog]->{{Now,validatedVolume,Link[requestor], InitialManufacturerVolume}}],
				If[NullQ[validatedMass],Nothing,Mass->validatedMass],
				If[NullQ[validatedMass],Nothing,Replace[MassLog]->{{Now,validatedMass,Link[requestor], InitialManufacturerWeight}}],
				If[NullQ[validatedCount],Nothing,Count->validatedCount],
				If[NullQ[validatedCount],Nothing,Replace[CountLog]->{{Now,validatedCount,Link[requestor]}}],
				If[NullQ[validatedProduct],Nothing,Product->Link[validatedProduct,Samples]],
				If[NullQ[validedNumberOfUses],Nothing,NumberOfUses->validedNumberOfUses]
			|>
		],
		{
			indexedCreatedObjects,
			(* Volume, Mass, Count are left automatic in the option resolver to indicate they will be measured *)
			(Lookup[resolvedOptions,Volume]/.Automatic->Null),
			(Lookup[resolvedOptions,Mass]/.Automatic->Null),
			(Lookup[resolvedOptions,Count]/.Automatic->Null),
			Lookup[resolvedOptions,Product],
			Lookup[resolvedOptions,NumberOfUses]
		}
	];

	(* ------------------------- *)
	(* -- Clean up for upload -- *)
	(* ------------------------- *)

	(* Associate each sample with its shipping info *)
	samplesAndShippingInfo = Transpose[{
		indexedCreatedObjects,
		indexedCreatedContainers,
		Lookup[resolvedOptions,ExpectedDeliveryDate],
		Lookup[resolvedOptions,TrackingNumber],
		Lookup[resolvedOptions,Shipper],
		Lookup[resolvedOptions,DateShipped],
		Lookup[resolvedOptions,ContainerOut],
		newRackObjects
	}];

	(* Group samples that have the same shipping info *)
	transactionInfoGroupedByShipping = GatherBy[samplesAndShippingInfo, {#[[3]], #[[4]], #[[5]], #[[6]]} &];

	(* Get the partitioned samples, containers, and shipping options *)
	{
		partitionedSamples,
		partitionedContainers,
		partitionedDateExpected,
		partitionedTrackingNumber,
		partitionedShipper,
		partitionedDateShipped,
		partitionedContainerOut,
		partitionedRacks
	} = Map[
		transactionInfoGroupedByShipping[[All, All, #1]]&,
		Range[Length[First[samplesAndShippingInfo]]]
	];

	(* If samples from the same container were partitioned into separate shipments (because of different shipping info), give a message and return $Failed. *)
	containerTallies = DeleteCases[Tally[Flatten[DeleteDuplicates /@ partitionedContainers]], {Null, _}];
	splitContainers = Cases[containerTallies, {_, Except[1]}][[All, 1]];

	(* test to make sure that there are no split containers *)
	splitContainerTest=If[And[gatherTests, !MatchQ[splitContainers,{}]],
		{Test[ToString[splitContainers,InputForm] <> " containers cannot have multiple sets of shipping information specified", splitContainers, {}]},
		{}
	];

	(* if not gathering tests, then throw some error messages about not allowing split contaienrs *)
	If[!gatherTests && !MatchQ[splitContainers,{}],
		Message[Error::ContainersMayNotSpanShipments,splitContainers];
		Message[Error::InvalidInput,"Container"];
	];

	If[!MatchQ[splitContainers,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,resolvedOptionsTests,splitContainerTest],
			Options -> resolvedOptionsForDisplay,
			Preview -> Null
		}]
	];

	(* Get the name option *)
	nameOption=Name/.safeOptions;

	(* Create a transaction packet for each set of shipping info *)
	transactionPackets=MapThread[
		Function[{samples,containers,index,containerOuts, racks},
			<|
				Type -> Object[Transaction,ShipToECL],
				Object-> CreateID[Object[Transaction,ShipToECL]],

				(* If there is more than one transaction being made, append an index to the name, otherwise just use the given name. *)
				Name->Which[
					NullQ[nameOption],Null,
					Length[partitionedSamples]==1,nameOption,
					True,nameOption<>"_"<>ToString[index]
				],

				(* The samples being sent by the user (i.e. the samples/items we will receive). This is different from SamplesOut if any transfers are requested. *)
				Replace[ReceivedSamples]->Link[samples],

				(* The containers being sent by the user (i.e. the containers we will receive). This is different from ContainersOut if any transfers are requested. *)
				(* Delete any Sites so that maintenance receive inventory can run: *)
				Replace[ReceivedContainers]->Link[DeleteDuplicates[DeleteCases[containers,ObjectP[Object[Container, Site]]]]],

				(* upload our covers *)
				Replace[ReceivedCovers] -> Link[Lookup[newSampleCoverPackets, Object,{}]],

				(* Get the subset of samples that will be transferred *)
				Replace[TransferSamples] -> Link[Flatten[MapThread[If[MatchQ[#1, Null], Nothing, #2] &, {containerOuts, samples}]]],

				(* Get the destination containers for things that will be transferred *)
				Replace[TransferContainers] -> Link[DeleteCases[containerOuts, Null]],

				Replace[EmptyContainers] -> Link[Lookup[newEmptyContainerPackets, Object,{}]],

				Creator ->Link[requestor, TransactionsCreated],
				Destination -> Link[Lookup[resolvedOptions, Destination]],
				Source -> Link[Lookup[resolvedOptions, Source]],
				ReceivingTolerance -> Lookup[resolvedOptions,ReceivingTolerance],
				Replace[ShippedRacks]-> Link[racks]
			|>
		],
		{partitionedSamples,partitionedContainers,Range[Length[partitionedSamples]],partitionedContainerOut, partitionedRacks}
	];

	(* Now that we know which samples are in which transaction, populate the source field of the samples *)
	sampleSourcePackets=Flatten[
		MapThread[
			Function[
				{samples, transaction},
				<|Object -> #, Source -> Link[transaction]|>&/@samples
			],
			{partitionedSamples, transactionPackets}
		]
	];

	(* Now that we know which containers are in which transaction, populate the source field of any new containers that were created *)
	containerSourcePackets=Flatten[
		MapThread[
			Function[
				{containers, transaction},
				Map[
					If[MemberQ[Lookup[newContainerPackets, Object],#],
						<|Object -> #, Source -> Link[transaction]|>,
						Nothing
					]&,
					DeleteDuplicates[containers]
				]
			],
			{partitionedContainers, transactionPackets}
		]
	];

	(* Also populate the Destination of any samples being shipped *)
	sampleDestinationPackets=<|Object->#,Destination->Link[Lookup[resolvedOptions,Destination]]|>&/@Flatten[partitionedSamples];

	(* Determine the status of each transaction based on whether a Date Shipped is specified *)
	transactionStatuses=Map[
		If[MatchQ[#,Null|Automatic],
			Pending,
			Shipped
		]&,
		First/@partitionedDateShipped
	];

	(* Use UploadTransaction to update the Status/StatusLog and shipping information. *)
	transactionStatusPackets=UploadTransaction[
		transactionPackets,
		transactionStatuses,
		Timestamp->(First/@partitionedDateShipped/.{Null->Now}),
		TrackingNumber -> Map[
			If[MatchQ[#, Null | Automatic],
				#,
				ToList[#]
			]&,
			((partitionedTrackingNumber[[All, 1]]) /. {Automatic -> Null})
		],
		Shipper -> (First/@partitionedShipper/. {Automatic -> Null}),
		DateExpected -> (First/@partitionedDateExpected/. {Automatic -> Null}),
		Upload->False,
		FastTrack->True,
		Cache->newCache,
		Email->(Email/.resolvedOptions)
	];

	(* Combine the sample packets, the amount packets, and the transaction packet *)
	allPackets=Join[
		newContainerUploadPackets,
		newSamplePackets,
		newItemPackets,
		cleanedCoverPackets,
		optionPackets,
		transactionPackets,
		sampleSourcePackets,
		containerSourcePackets,
		transactionStatusPackets,
		sampleDestinationPackets,
		newEmptyContainerPackets,
		uploadCoverPackets,
		newRackPackets,
		newContainerModelPackets,
		newCoverModelPackets
	];

	(* ------------------------------------------------------ *)
	(* --- Generate rules for each possible Output value ---  *)
	(* ------------------------------------------------------ *)

	(* Prepare the Options result *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsForDisplay,
		Null
	];

	(* Prepare the Preview result *)
	previewRule=Preview->If[MemberQ[output,Preview],Null,Null];

	(* Prepare the Test result *)
	testsRule=Tests->If[MemberQ[output,Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		DeleteCases[Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests,splitContainerTest}],Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	(* If uploading, upload and return the transaction object. Otherwise return all the packets. *)
	(*Currently, EraseCase needs to be in separate Upload calls, so upload the sticker packets separately *)
	resultRule=Result-> If[MemberQ[output,Result],
		If[Lookup[resolvedOptions,Upload],
			Upload[allPackets];
			Lookup[transactionPackets,Object],
			allPackets
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}

];


(* ::Subsubsection::Closed:: *)
(*resolveShipToECLOptions (model overload)*)


DefineOptions[
	resolveShipToECLOptions,
	Options:>{HelperOutputOption,CacheOption}
];


resolveShipToECLOptions[myModels:{ObjectP[{Model[Item],Model[Sample]}]..}, myContainerLabels:{_String..}, myOptions:{(_Rule|_RuleDelayed)..}, ops:OptionsPattern[]]:=Module[{
	objects,states,defaultStorageConditions,output,listedOutput,collectTestsBoolean,
	sampleIDs,friendlyOptions,mapThreadFriendlyOptions,optionsByContainer,resolvedOptions,messagesBoolean,allTests,
	vettedVolumeTuples,resolvedVolumes,volumeTests, vettedMassTuples,resolvedMasses,massTests,vettedCountTuples,
	resolvedCounts,countTests, vettedDates, vettedNumberOfUses,vettedProducts,vettedTrackingNumbers,vettedShippers,
	vettedStorageConditions,destination,testOrEmpty,warningOrNull,sampleOnlyOptions,missingContainerOptionTuples,missingContainerOptions,
	additionalTests,optionDestination, missingContainerOptionTest,containerOnlyOptions,unneededContainerOptionTuples,
	plateOnlyOptions,containerConflictTuples,containerConflict, consistentWellNumberOptions,
	numberOfWellsTest, badVesselWellNumberTuples,badVesselWellNumberSamples,
	badVesselWellNumberTest,existingContainerCounters,existingCoverCounters,coverModelCounter,containerCoverRules,
	containerModelCounter,containerModelIdentifier,containerModelIdentifiers,newContainerModelIdentifiers,
	newContainerModelLabels,containerModelRules,aspectRatioLookup,resolvedWellOptionsByContainer,
	resolvedOptionsWithWellInfo,resolvedPlateFillOrder,resolvedNumberOfWells,unneededDocTuples,unneededDocs,unneededDocsTest,docsAndPropertySets,
	reusedDocs,conflictingDocTest,validShippingTrackingBools,shipperTrackingTests,email,upload,resolvedEmail,containerOutInvalidVolumeBools,
	containerOutInvalidContentBools,containerContentsValidityTests,containerVolumeValidityTests,containerVolumeValidityWarnings,
	containerOutMaxVolumes,downloadedStuff,fastAssoc,tabletBools,solidUnitWeights,densities,products,cache,containerModelPositions,
	containerConflictTest,resolvedContainerModels,resolvedContainerTypes,
	plateOptionTuples,platesMissingOptions,missingPlateOptions,plateOptionsMissingTest,extraPlateOptionsError,noPlateFillOrderTest,
	incompatibleCoverContainerTest,plateNamesWithMultipleSamples,hamiltonWarningContainers,hamiltonWarningContainersTest,
	resolvedCoverModel,selfCoveringTuples,selfCoveredContainerWithCoverSpecified,selfCoveredContainerWithCoverSpecifiedTest,
	containerCoverTuples,incompatibleCoverContainerPairs, specifiedContainerModels, specifiedContainerTypes, emptiesSent,
	specifiedDocuments, specifiedCovers, specifiedWells, specifiedFillOrder, filteredContainerModels,inputsAndSpecifiedContainerInfo,containerModelTypeMismatches,
	containerModelTypeMismatchTest, resolvedPositions, badRacks, noRacksTuples, rackResult, inputsAndPositionAndContainerPositions,itemsWithPositionSpecified,
	itemsWithPositionSpecifiedTest,samplesWithoutPosition,samplesWithoutPositionTest,samplesWithInvalidPosition,samplesWithInvalidPositionTest,
	assembledObjects,nameUsedBools,nameInUseTest,duplicateItems,singlePositionAssembledObjects,duplicateSinglePositionContainers,duplicateNameTest,
	duplicateNameIssue,defaultSite,containerModelTypePackets, sourceOption,resolvedSource,sampleContainerInfoTuples,positionEntries,
	duplicatePositionTuples, containersWithReusedPositions, duplicatePositionsSpecified, insufficientSpace,
	samplesInSamePosition,samplesInSamePositionTest, toMeasureSampleGrowingList,containerModelVerifieds,
	shippingSpecTuples,numberOfShipments,nameOption,nameUniquenessTest,coverModelTypePackets,compatibleRacksPackets, noRacksTest, badRacksTest,
	emptyUnneededTest,emptyContainerUnneededLabels,uniqueContainerCoverPairs,userDocWebsites,newUserDocFiles,badDocFiles,missingDocFilesTest},

	(* From resolveShipToECLOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];
	messagesBoolean=!collectTestsBoolean;

	(* Fetch our cache from the parent function. *)
	cache = Quiet[OptionValue[Cache]];

	(* Reformat our options to a list of associations. Add inputs. Give each input an ID so we can keep track of index-matching even as we re-group *)
	sampleIDs = Range[Length[myModels]];
	friendlyOptions = OptionsHandling`Private`mapThreadOptions[ShipToECL, myOptions];
	mapThreadFriendlyOptions = MapThread[
		Append[#3, {Model->#1,Label->#2,ID->#4}]&,
		{myModels,myContainerLabels,friendlyOptions,sampleIDs}
	];

	(* For certain checks, resolutions we need to consider all samples in a plate at once *)
	(* Format as <container/item label > -> <|option1->value1 ...|> *)
	optionsByContainer = GroupBy[mapThreadFriendlyOptions,#[Label]&];

	(* Download some stuff that will help with option resolution *)
	downloadedStuff=Quiet[Download[
		{
			myModels,
			ToList[Lookup[myOptions, ContainerOut]],
			Replace[ToList[Lookup[myOptions, ContainerModel]], (Null | Automatic | _String) -> Null,{1}],
			Replace[ToList[Lookup[myOptions, ContainerModel]], (Null | Automatic | _String) -> Null,{1}],
			{$Notebook},
			Replace[ToList[Lookup[myOptions, CoverModel]], (Null | Automatic | _String) -> Null,{1}],
			Replace[ToList[Lookup[myOptions, ContainerModel]], (Null | Automatic | _String) -> Null,{1}],
			Lookup[myOptions, ShippedRack]
		},
		{
			{Object, State, DefaultStorageCondition[StorageCondition], Tablet, SolidUnitWeight, Density,Products},
			{MaxVolume},
			{Positions},
			{VerifiedContainerModel},
			{Financers[DefaultMailingAddress][Object]},
			{Packet[CoverType, CoverFootprint, VerifiedCoverModel]},
			{Packet[CoverTypes, CoverFootprints, BuiltInCover, Ampoule, VerifiedContainerModel, Footprint, Dimensions, SelfStanding, NumberOfWells, Positions, AspectRatio]},
			{Packet[Positions]}
		},
		Cache -> cache,
		Date -> Now
	], Download::FieldDoesntExist];

	fastAssoc = Experiment`Private`makeFastAssocFromCache[Cases[Flatten[downloadedStuff],PacketP[]]];

	(* Get the downloaded stuff into usable variables *)
	{objects,states,defaultStorageConditions,tabletBools,solidUnitWeights,densities,products}=Transpose[downloadedStuff[[1]]];
	containerOutMaxVolumes=Flatten[downloadedStuff[[2]]];
	containerModelPositions=Flatten[downloadedStuff[[3]],1];
	containerModelVerifieds = Flatten[downloadedStuff[[4]]];
	defaultSite = FirstOrDefault[Flatten[downloadedStuff[[5]]]];
	coverModelTypePackets = Cases[Flatten[downloadedStuff[[6]]], PacketP[]];
	containerModelTypePackets = Cases[Flatten[downloadedStuff[[7]]], PacketP[]];
	compatibleRacksPackets = Cases[Flatten[downloadedStuff[[8]]], PacketP[]];

	(* testOrEmpty: Simple helper that returns a Test whose expected value is True if makeTest->True, Null otherwise *)
	testOrEmpty[makeTest:BooleanP,description_,expression_]:=If[makeTest,
		Test[description,expression,True],
		{}
	];
	(* warningOrNull: Simple helper that returns a Warning if makeTest->True, Null otherwise *)
	warningOrNull[makeTest:BooleanP,description_,expression_]:=If[makeTest,
		Warning[description,expression,True],
		{}
	];

	(* --------------------------------------- *)
	(* = Container Options Checks = *)
	(* --------------------------------------- *)

	{specifiedContainerModels, specifiedContainerTypes, emptiesSent, specifiedDocuments, specifiedCovers, specifiedWells, specifiedFillOrder} = Lookup[
		myOptions,
		{ContainerModel,ContainerType, EmptyContainerSent, ContainerDocumentation, CoverModel, NumberOfWells, PlateFillOrder}
	];

	(* Check that none of our required container options are set to Null for samples *)
	sampleOnlyOptions = {Position,ContainerModel,ContainerType,EmptyContainerSent};
	missingContainerOptionTuples = Map[
		Function[optionSet,
			Module[{optionValues, nullOptionNames},
				optionValues = Lookup[optionSet,sampleOnlyOptions];
				nullOptionNames = PickList[sampleOnlyOptions,optionValues,Null];

				If[MatchQ[Lookup[optionSet,Model],ObjectP[Model[Sample]]] && !MatchQ[nullOptionNames,{}],
					{Lookup[optionSet,Label],nullOptionNames},
					Nothing
				]
			]
		],
		mapThreadFriendlyOptions
	];

	missingContainerOptions = DeleteDuplicates[Flatten[missingContainerOptionTuples[[All,2]]]];

	If[!MatchQ[missingContainerOptionTuples,{}] && messagesBoolean,
		Message[Error::ContainerInformationRequired, DeleteDuplicates[missingContainerOptionTuples[[All,1]]],missingContainerOptions];
		Message[Error::InvalidOption,missingContainerOptions];
	];

	missingContainerOptionTest = If[!messagesBoolean,
		Test["All samples have the required container information:",MatchQ[missingContainerOptionTuples,{}],True],
		Nothing
	];

	(* throw an error if any items have the container option specified *)
	containerOnlyOptions={ContainerModel,ContainerType,ContainerDocumentation,CoverModel,EmptyContainerSent,NumberOfWells,PlateFillOrder};
	unneededContainerOptionTuples = Map[
		Function[optionSet,
			Module[{optionValues, specifiedOptionNames},
				optionValues = Lookup[optionSet,containerOnlyOptions];
				specifiedOptionNames = PickList[containerOnlyOptions,optionValues,Except[Null|Automatic|False]];

				If[MatchQ[Lookup[optionSet,Model],ObjectP[Model[Item]]] && !MatchQ[specifiedOptionNames,{}],
					{Lookup[optionSet,Label],specifiedOptionNames},
					Nothing
				]
			]
		],
		mapThreadFriendlyOptions
	];

	If[!MatchQ[unneededContainerOptionTuples,{}]&&messagesBoolean,
		Message[Error::ContainerInformationNotRequired, DeleteDuplicates[unneededContainerOptionTuples[[All,1]]],DeleteDuplicates[Flatten[unneededContainerOptionTuples[[All,2]]]]];
		Message[Error::InvalidOption,DeleteDuplicates[Flatten[unneededContainerOptionTuples[[All,2]]]]];
	];

	(* Check that all the samples marked as being in the same plate have the same options describing that plate *)
	plateOnlyOptions = {NumberOfWells,PlateFillOrder,ContainerType,ContainerModel,CoverModel,ContainerDocumentation};
	containerConflictTuples = KeyValueMap[
		Function[{label,optionSets},
			Module[{conflictingSpecifications},
				conflictingSpecifications = Map[
					Length[DeleteDuplicates[DeleteCases[Lookup[optionSets, #], Automatic]]] > 1&,
					plateOnlyOptions
				];

				If[Or@@conflictingSpecifications,
					{label, PickList[plateOnlyOptions,conflictingSpecifications]},
					Nothing
				]
			]
		],
		optionsByContainer
	];

	containerConflict = Length[containerConflictTuples] > 0;

	(* If containers have conflicting specifications, throw an error *)
	If[containerConflict && messagesBoolean,
		Message[Error::ContainerSpecificationConflict,containerConflictTuples[[All,1]],DeleteDuplicates[Flatten[containerConflictTuples[[All,2]],1]]];
		Message[Error::InvalidInput,containerConflictTuples[[All,1]]];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	containerConflictTest=If[!messagesBoolean,
		Test["No containers have conflicting options describing their properties:",containerConflict,False],
		Nothing
	];

	(* If plate model is specified, check that the number of wells option matches field  *)
	consistentWellNumberOptions = And@@Map[
		Module[{containerModel,numberOfWells},
			{containerModel,numberOfWells} = Lookup[#,{ContainerModel,NumberOfWells}];

			If[MatchQ[containerModel,ObjectP[Model[Container]]] && !MatchQ[numberOfWells,Automatic],
				MatchQ[Lookup[Experiment`Private`fetchPacketFromFastAssoc[containerModel, fastAssoc],NumberOfWells],numberOfWells],
				True
			]
		]&,
		mapThreadFriendlyOptions
	];

	If[!consistentWellNumberOptions,
		Message[Error::NumberOfWellsMismatch];
		Message[Error::InvalidOption,NumberOfWells];
	];

	numberOfWellsTest = If[collectTestsBoolean,
		Test["If NumberOfWells and ContainerModel are specified, the container model's number of wells must match the specified number of wells:",consistentWellNumberOptions,True],
		Nothing
	];

	(* If ContainerModel or ContainerType suggests a vessel, WellNumber must be set to 1 *)
	badVesselWellNumberTuples = Cases[
		Lookup[mapThreadFriendlyOptions,{Model,ContainerModel,ContainerType,NumberOfWells}],
		{ObjectP[Model[Sample]],ObjectP[Model[Container,Vessel]],_,GreaterP[1]}|{ObjectP[Model[Sample]],_,Vessel,GreaterP[1]}
	];

	badVesselWellNumberSamples = badVesselWellNumberTuples[[All,1]];

	If[messagesBoolean && !MatchQ[badVesselWellNumberSamples,{}],
		Message[Error::NonstandardWellNumber,badVesselWellNumberSamples];
		Message[Error::InvalidOption,NumberOfWells];
	];

	badVesselWellNumberTest = If[!messagesBoolean,
		Test["NumberOfWells is set to 1 for any samples in a vessel:",MatchQ[badVesselWellNumberSamples,{}],True],
		Nothing
	];

	filteredContainerModels = Replace[specifiedContainerModels,Except[ObjectP[]]->Null,{1}];

	(* Container model and type must match *)
	inputsAndSpecifiedContainerInfo = Transpose[{specifiedContainerModels,specifiedContainerTypes}];

	containerModelTypeMismatches = Cases[inputsAndSpecifiedContainerInfo,{ObjectP[Model[Container,Vessel]],Plate}|{ObjectP[Model[Container,Plate]],Vessel}];

	If[Length[containerModelTypeMismatches]>0&&messagesBoolean,
		Message[Error::ContainerModelTypeMismatch,DeleteDuplicates[containerModelTypeMismatches[[All,1]]]];
		Message[Error::InvalidOption,ContainerModel];
	];

	containerModelTypeMismatchTest = If[!messagesBoolean,
		Test["ContainerModel and ContainerType must match:",MatchQ[containerModelTypeMismatches,{}],True],
		Nothing
	];

	(* check if we actually need the empty container *)
	emptyContainerUnneededLabels=MapThread[
		Function[{model,label,containerModel,emptySent},
			If[
				And[
					MatchQ[model,ObjectP[Model[Sample]]],
					MatchQ[containerModel,ObjectP[]],
					!TrueQ[Lookup[Experiment`Private`fetchPacketFromFastAssoc[containerModel, fastAssoc], ParameterizationPlaceholder]],
					TrueQ[emptySent]
				],
				label,
				Nothing
			]
		],
		{myModels,myContainerLabels,specifiedContainerModels,emptiesSent}
	];

	If[!MatchQ[emptyContainerUnneededLabels,{}]&&messagesBoolean,
		Message[Warning::EmptyContainerUnneeded,DeleteDuplicates[emptyContainerUnneededLabels]]
	];

	emptyUnneededTest = If[!messagesBoolean,
		Warning["An empty container is not sent if an already parameterized container model is provided:",MatchQ[emptyContainerUnneededLabels,{}],True],
		Nothing
	];

	(* cover model can't be specified for self covering containers *)
	selfCoveringTuples = Map[
		If[MatchQ[#,ObjectP[]],
			Lookup[Experiment`Private`fetchPacketFromFastAssoc[#,fastAssoc], {BuiltInCover, Ampoule}],
			Null
		]&,
		specifiedContainerModels
	];

	(* throw an error if the user has specified covers for containers that can't physically have them *)
	selfCoveredContainerWithCoverSpecified = Cases[
		Transpose[{myModels, specifiedCovers, selfCoveringTuples}],
		{
			ObjectP[Model[Sample]],
			ObjectP[],
			({True, _}|{_, True})
		}
	];

	If[!MatchQ[selfCoveredContainerWithCoverSpecified,{}]&&messagesBoolean,
		Message[Error::IncompatibleCoverModel, selfCoveredContainerWithCoverSpecified[[All,1]]];
		Message[Error::InvalidOption,CoverModel];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	selfCoveredContainerWithCoverSpecifiedTest=If[!messagesBoolean,
		Test["Containers that are self covering do not have a CoverModel specified:",MatchQ[selfCoveredContainerWithCoverSpecified,{}],True],
		Nothing
	];

	(* -- Container/Cover Match checking -- *)

	(* get the container cover pairs and the sample with which to throw the error *)
	(* remove an instances where the cover is a placeholder since there is nothing to check here *)
	(*also exclude items since we are throwing a different error for those*)
	containerCoverTuples = Cases[
		Transpose[{myModels, specifiedCovers, specifiedContainerModels}],
		{ObjectP[Model[Sample]], _, ObjectP[]}
	];

	(* at this point we know that all of the models will have packets in the download, so we can go ahead use the cache *)
	incompatibleCoverContainerPairs = If[MatchQ[containerCoverTuples, {}],
		{},
		Map[
			Module[
				{
					selectedModel, selectedCover, selectedContainer, compatibleCoverTypes, compatibleCoverFootprints, coverType, coverFootprint,  builtInCover, ampoule, verifiedCoverBool,verifiedContainerBool
				},

				(* break up the tuple *)
				{selectedModel, selectedCover, selectedContainer}=#;

				(* there may be no cover, if that's the case, use Null *)
				{coverType, coverFootprint, verifiedCoverBool} = If[MatchQ[selectedCover, ObjectP[]],
					Lookup[Experiment`Private`fetchPacketFromFastAssoc[selectedCover, fastAssoc], {CoverType, CoverFootprint, VerifiedCoverModel}],
					{Null, Null, Null}
				];

				{
					compatibleCoverTypes,
					compatibleCoverFootprints,
					builtInCover,
					ampoule,
					verifiedContainerBool
				} = If[MatchQ[selectedContainer, ObjectP[]],
					Lookup[Experiment`Private`fetchPacketFromFastAssoc[selectedContainer, fastAssoc], {CoverTypes, CoverFootprints, BuiltInCover, Ampoule, VerifiedContainerModel}],
					{Null, Null, Null, Null, Null}
				];

				(* determine if we need to throw an error *)
				Which[
					(* if there is no cover, don't bother *)
					!MatchQ[{selectedCover,selectedContainer}, {ObjectP[],ObjectP[]}],
					Nothing,

					(* if the container is not coverable but has a cover, we already threw an error for this so just skip it *)
					MemberQ[{builtInCover, ampoule}, True],
					Nothing,

					(* if the cover is compatible according to CoverType/CoverTypes and CoverFootprint/CompatibleCoverFootprint we are good *)
					And[MemberQ[compatibleCoverTypes, coverType], MemberQ[compatibleCoverFootprints, coverFootprint]],
					Nothing,

					(* if the cover or container is not verified, we don't care if the footprint matches since there that gets populated in receiving/parameterization anyway *)
					(*note that we are not going to check the cover type here either because thats also something we verify and its kind of already pre-enforced since the cover and container are shipped as a set*)
					MemberQ[{verifiedCoverBool, verifiedContainerBool}, Except[True]],
					Nothing,

					(* any other scenario should result in an error ie. a mismatch in the cover type or footprint and no self covered container*)
					True,
					#
				]

			]&,
			containerCoverTuples
		]
	];

	If[Length[incompatibleCoverContainerPairs]>0&&messagesBoolean,
		Message[Error::IncompatibleCoverModelType, incompatibleCoverContainerPairs[[All,2]], incompatibleCoverContainerPairs[[All,3]]];
		Message[Error::InvalidOption,CoverModel];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	incompatibleCoverContainerTest=If[!messagesBoolean,
		Test["Covers have compatible CoverFootprint and CoverType for the ContainerModel they are covering:",Length[incompatibleCoverContainerPairs]>0,False],
		Nothing
	];

	(* -------------------------------------------- *)
	(* -- Container Option Resolutions -- *)
	(* -------------------------------------------- *)

	(* We need to label each of our containers if the user hasn't done so *)
	(* In case they start with our naming scheme but leave many automatic find the highest container they label *)
	(* Find the largest N in any "Container Model N" strings *)
	existingContainerCounters = Map[
		StringCases[#, "Container Model " ~~ count : DigitCharacter .. :> ToExpression[count]]&,
		Cases[Lookup[myOptions, ContainerModel],_String]
	];

	containerModelCounter=Max[existingContainerCounters,1];

	(* Figure out what's giving us info about the container model *)
	(* If user specified model or docs then each unique item here indicates a unique model *)
	(* If no info about the model was provided we have to assume each unique container object has a unique container model *)
	containerModelIdentifier[docs_,model_,label_]:=Which[
		MatchQ[model,Except[Null|Automatic]],{ContainerModel,model},
		MatchQ[docs,Except[Null|Automatic]],{ContainerDocumentation,docs},
		True, {Label,label}
	];

	(* Get the identifier for each container input *)
	containerModelIdentifiers=MapThread[
		Function[{docs,model,label},
			containerModelIdentifier[docs,model,label]
		],
		{specifiedDocuments,specifiedContainerModels,myContainerLabels}
	];

	(* Get the list of identifiers where we need to make a label *)
	(* If the container model is being identified through the ContainerModel option (use provided their own label or existing model) we don't need to generate a label *)
	newContainerModelIdentifiers=DeleteDuplicates[DeleteCases[containerModelIdentifiers, {ContainerModel,_}]];

	(* Generate the list of new labels. We use an ugly Range just to account for the possibility that the user started with our naming scheme but didn't keep going *)
	newContainerModelLabels=Map[
		"Container Model "<>ToString[#]&,
		Range[containerModelCounter,containerModelCounter+Length[newContainerModelIdentifiers]-1]
	];

	(* Link our identifiers to our new labels *)
	containerModelRules = AssociationThread[newContainerModelIdentifiers,newContainerModelLabels];

	(* Create a little look-up from NumberOfWells -> aspect ratio since AllWells is not smart *)
	aspectRatioLookup = <|
		4 -> 1,
		6 -> 3/2,
		12 -> 4/3,
		24 -> 3/2,
		48 -> 4/3,
		96 -> 3/2
	|>;

	(* Resolve NumberOfWells,PlateFillOrder,Position,ContainerModel,ContainerType for each unique container *)
	resolvedWellOptionsByContainer = Map[
		Function[{optionSets},
			Module[{numberOfSamples,standardWellNumber,wellNumberOptions,wellOrderOptions,containerModelOptions,resolvedContainerModel,
				wellOrderDefault,containerType,containerDocs,resolvedContainerType,positionOptions,resolvedWellNumber,resolvedWellOrder,
				containerPositions,arrangedContainerPositions,sampleWells,containerModelPacket},

				(* Don't need to resolve any container options for items *)
				If[MatchQ[Lookup[optionSets,Model],{ObjectP[Model[Item]]..}],
					Return[
						Map[
							Append[#,
								{
									NumberOfWells -> Lookup[#1,NumberOfWells]/.Automatic->Null,
									PlateFillOrder -> Lookup[#1,PlateFillOrder]/.Automatic->Null,
									Position -> Lookup[#1,Position]/.Automatic->Null,
									ContainerModel -> Lookup[#1,ContainerModel]/.Automatic->Null,
									ContainerType -> Lookup[#1,ContainerType]/.Automatic->Null,
									ContainerDocumentation -> Lookup[#1,ContainerDocumentation]/.Automatic->Null
								}
							]&,
							optionSets
						],
						Module
					]
				];

				(* optionSets are grouped by unique container ID so length gives us # of samples in that container *)
				numberOfSamples = Length[optionSets];

				(* All the index-matched options should be the same here since we've grouped by samples in the sample container model *)
				(* Error checking elsewhere looks for conflicts - e.g. where we've said container 1 has model 1 and model 2 at different points *)
				(* For right now we will just take the first actual value we were given that describes our current container *)
				containerType = FirstCase[Lookup[optionSets,ContainerType],Except[Automatic],Automatic];
				containerDocs = FirstCase[Lookup[optionSets,ContainerDocumentation],Except[Automatic],Automatic];

				containerModelOptions = Lookup[optionSets,ContainerModel];
				wellNumberOptions = Lookup[optionSets,NumberOfWells];
				wellOrderOptions = Lookup[optionSets,PlateFillOrder];
				positionOptions = Lookup[optionSets,Position];

				containerModelOptions = Lookup[optionSets,ContainerModel];

				resolvedContainerModel = If[!MatchQ[containerModelOptions,{Automatic..}],
					FirstCase[containerModelOptions,Except[Automatic]],
					Lookup[containerModelRules,Key[containerModelIdentifier[containerDocs,Automatic,First[Lookup[optionSets,Label]]]]]
				];

				resolvedContainerType = Which[
					MatchQ[containerType,Except[Automatic]],
						containerType,
					MatchQ[resolvedContainerModel,ObjectP[Model[Container,Vessel]]],
						Vessel,
					MatchQ[resolvedContainerModel,ObjectP[Model[Container,Plate]]],
						Plate,
					numberOfSamples>1 || MemberQ[wellNumberOptions, GreaterP[1]] || MemberQ[wellOrderOptions, Row|Column],
						Plate,
					True,
						Vessel
				];

				(* Given our number of samples, determine the most likely plate configuration *)
				standardWellNumber = Switch[{numberOfSamples,resolvedContainerType},
					{_, Vessel}, 1,
					{LessEqualP[1], _}, 1,
					{LessEqualP[96], Plate}, 96,
					{LessEqualP[384], Plate}, 384,
					(* Account for the crazy case where we have an even bigger plate but with our standard 1.5 aspect ratio *)
					_, 96*Ceiling[Sqrt[(numberOfSamples/96)]]^2
				];

				wellOrderDefault = If[MatchQ[resolvedContainerType,Vessel],
					Null,
					Row
				];

				(* Get any legit user-specified PlateOrder and WellNumber, otherwise use resolved values *)
				(* We will only replace the automatics below *)
				resolvedWellNumber = FirstCase[wellNumberOptions, Except[Null|Automatic], standardWellNumber];
				resolvedWellOrder = FirstCase[wellOrderOptions, Except[Null|Automatic], wellOrderDefault];

				containerModelPacket=Experiment`Private`fetchPacketFromFastAssoc[resolvedContainerModel, fastAssoc];

				(* Get the specified positions of samples in our container, or if not provided determine all positions in the container *)
				containerPositions = Which[
                	!MatchQ[positionOptions,{Automatic..}],
						positionOptions,
					MatchQ[resolvedContainerModel,ObjectP[Model[Container,Plate]]] && !MemberQ[Lookup[containerModelPacket,{AspectRatio,NumberOfWells}],Null],
						AllWells[containerModelPacket],
					MatchQ[resolvedContainerModel,ObjectP[Model[Container,Vessel]]] && !MatchQ[Lookup[containerModelPacket,Positions], {}],
						Lookup[
							Lookup[containerModelPacket,Positions,{<|Name->"A1"|>}],
							Name
						],
         			MatchQ[resolvedWellNumber,1],
						{{"A1"}},
					True,
						Quiet[
							Check[
								AllWells[NumberOfWells -> resolvedWellNumber, AspectRatio -> Lookup[aspectRatioLookup,resolvedWellNumber,3/2]],
								{ConstantArray[Null, numberOfSamples]}
							],
							ConvertWell::BadRatio
						]
				];

				(* Adjust our container positions based on plate fill specification. Don't adjust if we were given positions *)
				arrangedContainerPositions=If[MatchQ[resolvedWellOrder,Row|Null] || !MatchQ[positionOptions,{Automatic..}],
					Flatten[containerPositions,1],
					Flatten[Transpose[containerPositions],1]
				];

				(* If there aren't enough wells in the container, just loop back. Error elsewhere. *)
				sampleWells=If[Length[arrangedContainerPositions] >= numberOfSamples,
					Take[arrangedContainerPositions,numberOfSamples],
					PadRight[arrangedContainerPositions,numberOfSamples,arrangedContainerPositions]
				];

				(* Update each option with our new resolved value *)
				MapThread[
					Append[#1, {
						NumberOfWells -> Lookup[#1,NumberOfWells]/.Automatic->resolvedWellNumber,
						PlateFillOrder -> Lookup[#1,PlateFillOrder]/.Automatic->resolvedWellOrder,
						(* Filling up the plate well-by-well *)
						Position -> Lookup[#1,Position]/.Automatic->#2,
						ContainerModel -> Lookup[#1,ContainerModel]/.Automatic->resolvedContainerModel,
						ContainerType -> Lookup[#1,ContainerType]/.Automatic->resolvedContainerType
					}
					]&,
					{optionSets,sampleWells}
				]
			]
		],
		optionsByContainer
	];

	resolvedOptionsWithWellInfo = SortBy[Flatten[Values[resolvedWellOptionsByContainer],1],Lookup[#,ID]&];

	resolvedPlateFillOrder = Lookup[resolvedOptionsWithWellInfo,PlateFillOrder];
	resolvedNumberOfWells = Lookup[resolvedOptionsWithWellInfo,NumberOfWells];
	resolvedPositions = Lookup[resolvedOptionsWithWellInfo,Position];
	resolvedContainerModels = Lookup[resolvedOptionsWithWellInfo,ContainerModel];
	resolvedContainerTypes = Lookup[resolvedOptionsWithWellInfo,ContainerType];

	(* - For any samples determined to be in plates make sure NumberOfWells, PlateFillOrder aren't missing - *)
	plateOptionTuples=Transpose[{myModels,myContainerLabels,resolvedContainerTypes,resolvedNumberOfWells,resolvedPlateFillOrder}];

	platesMissingOptions=DeleteDuplicates[Cases[plateOptionTuples,{ObjectP[Model[Sample]],_,Plate,Null,_}|{ObjectP[Model[Sample]],_,Plate,_,Null}][[All,2]]];

	missingPlateOptions={
		If[MemberQ[plateOptionTuples, {_, _, Plate, Null, _}], NumberOfWells, Nothing],
		If[MemberQ[plateOptionTuples, {_, _, Plate, _, Null}], PlateFillOrder, Nothing]
	};

	If[!MatchQ[missingPlateOptions,{}] && messagesBoolean,
		Message[Error::PlateOptionsRequired,platesMissingOptions,missingPlateOptions];
		Message[Error::InvalidOption,missingPlateOptions]
	];

	plateOptionsMissingTest=If[!messagesBoolean,
		Test["Any samples in plates must have NumberOfWells and PlateFillOrder specified",MatchQ[missingPlateOptions,{}],True]
	];

	(* PlateFillOrder only for plates *)
	extraPlateOptionsError=MemberQ[plateOptionTuples, {_, _, Vessel, _, Row|Column}];

	If[extraPlateOptionsError && messagesBoolean,
		Message[Error::NoPlateFillOrder];
		Message[Error::InvalidOption,PlateFillOrder]
	];

	noPlateFillOrderTest=If[!messagesBoolean,
		Test["Any samples in vessels cannot have PlateFillOrder specified",extraPlateOptionsError,False]
	];

	(* - Appropriate Container Documentation - *)
	(* - We don't need container docs when container model is specified - *)
	unneededDocTuples = Cases[Transpose[{myContainerLabels,specifiedContainerModels,specifiedDocuments}],{_,ObjectP[],Except[Null|Automatic]}];

	unneededDocs = Length[unneededDocTuples]>0;

	If[unneededDocs && messagesBoolean && !containerConflict,
		Message[Warning::UnneededContainerDocumentation,DeleteDuplicates[unneededDocTuples[[All,1]]]]
	];

	unneededDocsTest=If[!messagesBoolean,
		Test["Container documentation is not provided for samples in containers with existing models",unneededDocs,False],
		Nothing
	];

	(* - Unique documents must be specified for unique container properties - *)
	(* e.g. customer can't give the same file for a sample in a plate and a sample in a vessel  *)

	(* Get sets of options with the same docs specified *)
	docsAndPropertySets = GatherBy[
		DeleteCases[Transpose[{specifiedDocuments,specifiedWells,resolvedContainerTypes}],{Null|Automatic,_,_}],
		First
	];

	(* Get docs that are being used to describe multiple types of containers *)
	reusedDocs = DeleteCases[
		Map[
			Module[{numberOfUniqueSets},
				numberOfUniqueSets=DeleteDuplicates[#];
				If[Length[numberOfUniqueSets]>1,
					numberOfUniqueSets[[1,1]],
					Nothing
				]
			]&,
			docsAndPropertySets
		],
		Null
	];

	(* Throw an error unless we've already detected a more fundamental problem with our container options *)
	If[Length[reusedDocs]>0 && messagesBoolean && !containerConflict && !unneededDocs,
		Message[Error::ConflictingContainerDocumentation,reusedDocs];
		Message[Error::InvalidOption, ContainerDocumentation]
	];

	conflictingDocTest=If[!messagesBoolean,
		Test["The same container documentation is not used to describe two different types of containers",Length[reusedDocs],0],
		Nothing
	];

	(* - Documentation files must exist - *)
	userDocWebsites = DeleteDuplicates[Cases[specifiedDocuments, URLP]];
	newUserDocFiles = DeleteDuplicates[Complement[Cases[specifiedDocuments, FilePathP],userDocWebsites]];

	badDocFiles = PickList[newUserDocFiles,FileExistsQ/@newUserDocFiles,False];

	(* Throw an error unless we've already detected a more fundamental problem with our container options *)
	If[Length[badDocFiles]>0 && messagesBoolean && Length[reusedDocs]==0 && !containerConflict && !unneededDocs,
		Message[Error::ContainerDocumentationFiles,badDocFiles];
		Message[Error::InvalidOption, ContainerDocumentation]
	];

	missingDocFilesTest=If[!messagesBoolean,
		Test["Any container documentation files were found:",Length[badDocFiles],0],
		Nothing
	];

	(* - Resolve Cover Model - *)

	(* We are going to name our unique cover models. Make sure we don't overlap with any user-specified names *)
	existingCoverCounters = Map[
		StringCases[#, "Cover Model " ~~ count : DigitCharacter .. :> ToExpression[count]]&,
		Cases[Lookup[myOptions, CoverModel],_String]
	];

	coverModelCounter=Max[existingCoverCounters,0];

	(* Get unique tuples for all our container model <> cover model pairs *)
	uniqueContainerCoverPairs = DeleteDuplicates[Transpose[{resolvedContainerModels,specifiedCovers}]];

	(* We want to make a new cover model for each unique container model unless one was already specified  *)
	(* Without any other info we have to assume that if something has a unique container model it must have a corresponding unique cover model *)
	containerCoverRules=MapThread[
		Function[{containerModel, cover},
			Which[
				(* Cover specified *)
				MatchQ[cover,Except[Automatic]], containerModel->cover,

				(* No container model therefore no corresponding cover *)
				MatchQ[containerModel,Null], Null->Null,

				(* Cover built in, no object needed *)
				MatchQ[containerModel,ObjectP[]] && MemberQ[Lookup[Experiment`Private`fetchPacketFromFastAssoc[containerModel,fastAssoc], {BuiltInCover, Ampoule}],True], containerModel->Null,


				(* Otherwise make new cover *)
				True, (coverModelCounter=coverModelCounter+1; containerModel -> "Cover Model " <> ToString[coverModelCounter])
			]
		],
		Transpose[uniqueContainerCoverPairs] (* Convert back to list of containers and list of covers *)
	];

	resolvedCoverModel=MapThread[
		If[MatchQ[#2,Except[Automatic]],
			#2,
			Lookup[containerCoverRules,#1]
		]&,
		{resolvedContainerModels,specifiedCovers}
	];

	(* ----------- *)
	(* -- Racks -- *)
	(* ----------- *)

	(* return the resolved racks as the first argument, and the specific error info: {resolved rack, mismatch:{footprint, dimensions}, no rack found:{footprint, dimensions}, bool for missing rack error} *)
	rackResult = MapThread[
		Function[{container, rack},
			Module[{maxWidth, minWidth, maxDepth, minDepth, modelFootprint, modelDimensions, acceptableDimensionsPattern},
				(*short circuit*)
				Which[
					(* no container model, no rack needed *)
					MatchQ[container, Except[ObjectP[]]],
					Return[{Rack -> rack, BadRack -> Null, NoRacks -> Null}, Module],

					(* container model is self standing *)
					MatchQ[Lookup[Experiment`Private`fetchPacketFromFastAssoc[container, fastAssoc], SelfStanding], True],
					Return[{Rack -> rack, BadRack -> Null, NoRacks -> Null}, Module],

					True,
					Nothing
				];

				(* at this point, we know we have a container that needs a rack so we need the range of acceptable dimensions*)
				{modelDimensions, modelFootprint} = Lookup[FirstCase[containerModelTypePackets, PacketP[container]], {Dimensions, Footprint}];

				(* if the model does not have dimensions, we have to return an error saying that we cant search for  a new rack. Do not error for a provided rack as it may be legit. *)
				If[MatchQ[modelDimensions, Null],
					If[MatchQ[rack, ObjectP[]],
						Return[{Rack -> rack, BadRack -> Null, NoRacks -> Null}, Module],
						Return[{Rack -> Null, BadRack -> Null, NoRacks -> container}, Module]
					]
				];
				{maxWidth, minWidth, maxDepth, minDepth} = Lookup[
					DimensionsWithTolerance[
						modelDimensions,
						$PositionUpperTolerance,
						$PositionLowerTolerance
					],
					{MaxWidth, MinWidth, MaxLength, MinLength}
				];

				acceptableDimensionsPattern = Alternatives[
					{modelFootprint, _,_},
					{_, RangeP[minDepth, maxDepth], RangeP[minWidth,maxWidth]},
					{_, RangeP[minWidth,maxWidth], RangeP[minDepth, maxDepth]}
				];


				(* either check the rack, or find a new one *)
				If[MatchQ[rack, ObjectP[]],
					(* check the rack - don't search for a new one *)
					Module[{positions, positionTuples, workablePositions},
						positions = Lookup[FirstCase[compatibleRacksPackets, PacketP[rack]], Positions];
						positionTuples = Lookup[positions, {Footprint, MaxWidth, MaxDepth}];
						workablePositions = Cases[positionTuples, acceptableDimensionsPattern];
						If[MatchQ[workablePositions, {}],
							{Rack -> rack, BadRack -> {rack, container}, NoRacks -> Null},
							{Rack -> rack, BadRack -> Null, NoRacks -> Null}
						]
					],

					(* find an alternative *)
					Module[{possibleRackPositions, matchingPosition},
						possibleRackPositions = rackFootprintsAndDimensions[];

						matchingPosition = SelectFirst[possibleRackPositions, MatchQ[{#[[2]], #[[3,1]], #[[3,2]]}, acceptableDimensionsPattern]&, {}];
						If[MatchQ[matchingPosition, {}],
							{Rack -> Null, BadRack -> Null, NoRacks -> container},
							{Rack -> matchingPosition[[1]], BadRack -> Null, NoRacks -> Null}
						]

					]
				]

			]
		],
		{resolvedContainerModels, (Lookup[myOptions, ShippedRack]/.Null-> Null)}
	];

	(* racks that were provided but don't actually work *)
	badRacks = DeleteCases[Lookup[rackResult, BadRack], Null];
	(* things we couldnt find a rack for that were automatic *)
	noRacksTuples = DeleteCases[Lookup[rackResult, NoRacks], Null];

	(* throw the errors for incompatible and missing rack pairings *)
	If[Length[badRacks]>0&&messagesBoolean,
		Message[Error::IncompatibleProvidedRackModel, badRacks[[All,1]], badRacks[[All,2]]];
		Message[Error::InvalidOption,ShippedRack];
	];

	If[Length[noRacksTuples]>0&&messagesBoolean,
		Message[Error::NoCompatibleRack, noRacksTuples[[All,2;;]]];
		Message[Error::InvalidOption,ShippedRack];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	badRacksTest=If[!messagesBoolean,
		Test["The provided ShippedRack models are capable of supporting the ContainerModel they are matched with:",Length[badRacks]>0,False],
		Nothing
	];

	noRacksTest=If[!messagesBoolean,
		Test["An appropriate ShippedRack is able to be found for ContainerModels that are not capable of standing unsupported:",Length[noRacksTuples]>0,False],
		Nothing
	];


	(* ------------------------------------ *)
	(* = Position Error Checks = *)
	(* ------------------------------------ *)

	inputsAndPositionAndContainerPositions = Transpose[{myModels,resolvedPositions,containerModelPositions}];

	(* throw an error if any items have the position option specified *)
	itemsWithPositionSpecified = Cases[inputsAndPositionAndContainerPositions,{ObjectP[Model[Item]],_String,_}][[All,1]];

	If[Length[itemsWithPositionSpecified]>0&&messagesBoolean,
		Message[Error::PositionNotRequired, itemsWithPositionSpecified];
		Message[Error::InvalidOption,Position];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	itemsWithPositionSpecifiedTest=If[!messagesBoolean,
		Test["Any input item models do not have Position specified:",False,Length[itemsWithPositionSpecified]>0],
		Nothing
	];

	(* throw an error if any samples don't have the position option *)
	samplesWithoutPosition = Cases[inputsAndPositionAndContainerPositions,{ObjectP[Model[Sample]],Except[_String],_}][[All,1]];

	(* Throw an error about position being Null because we couldn't resolve it unless the issue is that the user set it Null *)
	If[Length[samplesWithoutPosition]>0 && messagesBoolean && !MemberQ[missingContainerOptions, Position],
		Message[Error::PositionRequired, samplesWithoutPosition];
		Message[Error::InvalidOption,Position];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	samplesWithoutPositionTest=If[!messagesBoolean,
		Test["Any input sample models have Position specified or are in single-position containers:",False,Length[samplesWithoutPosition]>0],
		Nothing
	];

	(* throw an error if any samples are in a position that does not exist in the container. *)
	samplesWithInvalidPosition = Map[
		(* If the input is a sample AND the position is specified AND the container is specified AND the specified position is not one of the container positions *)
		If[MatchQ[#[[1]], ObjectP[Model[Sample]]] && MatchQ[#[[2]], _String] && ! NullQ[#[[3]]] && !MemberQ[Name /. #[[3]], #[[2]]],
			<|"Input"->#[[1]], "SpecifiedPosition"->#[[2]], "PossiblePositions"->Lookup[#[[3]],Name]|>,
			Nothing
		]&,
		inputsAndPositionAndContainerPositions
	];

	If[Length[samplesWithInvalidPosition]>0&&messagesBoolean,
		Message[Error::InvalidPosition,samplesWithInvalidPosition];
		Message[Error::InvalidOption,Position];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	samplesWithInvalidPositionTest=If[!messagesBoolean,
		Test["Any input sample models with Position and ModelContainer specified have specified a position that exists inside the container:",Length[samplesWithInvalidPosition]>0,False],
		Nothing
	];

	(* Error if trying to put 2 samples into same position of a plate *)
	(* Consider just plates, where position is not Null for this check *)
	sampleContainerInfoTuples = DeleteCases[
		Transpose[{
			myModels,
			resolvedContainerModels,
			myContainerLabels,
			resolvedPositions
		}],
		{ObjectP[Model[Item]],___} | {_,ObjectP[Model[Container,Vessel]],___} | {___, Null}
	];
	positionEntries = GatherBy[sampleContainerInfoTuples, {#[[2]], #[[3]], #[[4]]} &];
	duplicatePositionTuples = Select[positionEntries, Length[#] > 1 &];
	samplesInSamePosition = Flatten[duplicatePositionTuples[[All, All, 1]]];
	containersWithReusedPositions = DeleteDuplicates[Flatten[duplicatePositionTuples[[All, All, 3]]]];

	(* If samples are in the same well it's either because the user directly specified this
	or because they specified more samples than will fit in the given container and we had no choice but to reuse wells when resolving position *)
	duplicatePositionsSpecified=!MatchQ[Lookup[myOptions,Position],{Automatic..}] && Length[samplesInSamePosition]>0;
	insufficientSpace=MatchQ[Lookup[myOptions,Position],{Automatic..}] && Length[samplesInSamePosition]>0;

	If[duplicatePositionsSpecified&&messagesBoolean,
		Message[Error::ReusedPosition,samplesInSamePosition];
		Message[Error::InvalidOption,Position];
	];

	If[insufficientSpace&&messagesBoolean,
		Message[Error::InsufficientContainerSpace,containersWithReusedPositions];
		Message[Error::InvalidInput,containersWithReusedPositions];
	];

	samplesInSamePositionTest=If[!messagesBoolean,
		Test["No samples are implicitly or explicitly in the same well of a container:",Length[samplesInSamePosition]>0,False],
		Nothing
	];

	(* -------------- *)
	(* = Input Names =*)
	(* -------------- *)

	(* Throw an error if the name already exists in the database. If the input is an item, apply the name to an object of the item type. If the input is a sample, use the specified container instead. *)
	assembledObjects = MapThread[Function[{inputModel, inputName, containerType},
		Which[
			MatchQ[inputModel,ObjectP[Model[Item]]],
				Append[(Download[inputModel,Type] /. Model -> Object), inputName],
			MatchQ[containerType,Plate],
				Append[Object[Container,Plate], inputName],
			MatchQ[containerType,Vessel],
				Append[Object[Container,Vessel], inputName],
			True,
				Null
		]
	], {myModels, myContainerLabels, resolvedContainerTypes}];

	nameUsedBools = DatabaseMemberQ[DeleteDuplicates[assembledObjects]];

	If[MemberQ[nameUsedBools, True]&&messagesBoolean,
		Message[Error::NameInUse, PickList[assembledObjects, nameUsedBools][[All,-1]],Download[PickList[assembledObjects, nameUsedBools],Type]];
		Message[Error::InvalidInput,"name"];
	];

	nameInUseTest=If[!messagesBoolean,
		Test["The input names are not already in use for the objects to which they will be applied:",MemberQ[nameUsedBools, True],False],
		Nothing
	];

	(* Throw an error if a name is used for multiple items or a name is used for multiple single-position containers *)
	duplicateItems = Select[Tally[Cases[assembledObjects, ObjectP[Object[Item]]]], (#[[2]] > 1) &];

	singlePositionAssembledObjects = PickList[assembledObjects, containerModelPositions, _?(Length[#] == 1 &)];
	duplicateSinglePositionContainers = Select[Tally[singlePositionAssembledObjects], (#[[2]] > 1) &];

	duplicateNameIssue = Length[Join[duplicateItems,duplicateSinglePositionContainers]] > 0;

	If[duplicateNameIssue&&messagesBoolean,
		Message[Error::ShipToECLDuplicateName,
			Join[duplicateItems,duplicateSinglePositionContainers][[All, 1]][[All,-1]],
			Download[Join[duplicateItems,duplicateSinglePositionContainers][[All,1]],Type]];
		Message[Error::InvalidInput,"name"];
	];

	duplicateNameTest=If[!messagesBoolean,
		Test["The input names are not used more than once of an item or a single-position container:",duplicateNameIssue,False],
		Nothing
	];

	(* --------- *)
	(* = Source =*)
	(* --------- *)

	(* The site of the financer of the notebook this function is being called from is considered the source (unless source is specified). If this is not called from CommandCenter, Notebook is Null. *)
	(* Eventually, there will only be one financer per notebook, but for now it is still a multiple *)
	sourceOption=Lookup[myOptions,Source];
	resolvedSource=If[MatchQ[sourceOption,ObjectP[Object[Container,Site]]],
		sourceOption,
		defaultSite
	];

	(* -------------- *)
	(* = Destination =*)
	(* -------------- *)

	(* Resolve the destination to ECL-2 *)
	optionDestination=Lookup[myOptions,Destination];
	destination=Switch[optionDestination,
		Alternatives[Automatic,Null,Null], $Site,
		_, optionDestination
	];

	(* = Email = *)

	(* Pull Email and Upload options from the expanded Options *)
	{email, upload} = Lookup[myOptions, {Email, Upload}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
	(* If Email!=Automatic, use the supplied value *)
		email,
	(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* --------- *)
	(* = Volume =*)
	(* --------- *)

	vettedVolumeTuples=MapThread[
		Function[{object,state,volume,mass,density},
			Module[{testDescription},
				testDescription=ToString[object,InputForm]<>" does not require a Volume:";
				Which[
					(* if it has a volume and it a non self containing sample, then it's all cool*)
					MatchQ[volume,VolumeP]&&MatchQ[object,ObjectP[Model[Sample]]],
					{volume,{}},

					(* if it has a volume, but is some other type of sample then there is a problem*)
					MatchQ[volume,VolumeP]&&MatchQ[object,Except[ObjectP[Model[Sample]]]],
					Module[{},
						If[messagesBoolean,
							Message[Error::AmountNotRequired, object];
							Message[Error::InvalidOption,Volume]
						];
						{volume,testOrEmpty[collectTestsBoolean,testDescription,False]}
					],

					(* If it doesn't have a volume but mass and density are known, calculate the volume *)
					MatchQ[volume,Automatic]&&MatchQ[mass,MassP]&&MatchQ[density,_?QuantityQ],
					{RoundOptionPrecision[(mass/density), 10^-1 Microliter],{}},

					(* Sample is not a liquid, no volume expected *)
					!MatchQ[state,Liquid],
					{Null,{}},

					(* in all other cases leave volume automatic indicating we will measure it *)
					True,
					{Automatic,{}}
				]
			]
		],
		{objects,states,Lookup[myOptions,Volume],Lookup[myOptions,Mass],densities}
	];

	resolvedVolumes=vettedVolumeTuples[[All,1]];
	volumeTests=vettedVolumeTuples[[All,2]];


	(* -------- *)
	(* = Mass = *)
	(* -------- *)

	vettedMassTuples=MapThread[
		Function[{object,mass,state,count,solidUnitWeight,density,volume},
			Module[{testDescription},
				testDescription=ToString[object,InputForm]<>" does not require a Mass:";
				Which[
					(* if it has a mass and it a non self containing sample, then it's all cool*)
					MatchQ[mass,MassP]&&MatchQ[object,ObjectP[Model[Sample]]],
					{mass,{}},

					(* if it has a mass, but is some other type of sample then there is a problem*)
					MatchQ[mass,MassP]&&MatchQ[object,Except[ObjectP[Model[Sample]]]],
					Module[{},
						If[messagesBoolean,
							Message[Error::AmountNotRequired, object];
							Message[Error::InvalidOption,Mass]
						];
						{mass,testOrEmpty[collectTestsBoolean,testDescription,False]}
					],

					(* If it doesn't have a mass, but it has tablet weight and a count, calculate the mass *)
					MatchQ[mass,Automatic]&&MatchQ[count,_Integer]&&MatchQ[solidUnitWeight,MassP],
					{count*solidUnitWeight,{}},

					(* If it doesn't have a mass but volume and density are known, calculate the mass *)
					MatchQ[mass,Automatic]&&MatchQ[volume,VolumeP]&&MatchQ[density,_?QuantityQ],
					{RoundOptionPrecision[(volume*density), 10^-1 Milligram],{}},

					(* no need for mass if not a solid *)
					!MatchQ[state,Solid],
					{Null,{}},


					(* in all other cases leave mass automatic indicating we will measure it *)
					True,
					{Automatic,{}}
				]
			]
		],{objects,Lookup[myOptions,Mass],states,Lookup[myOptions,Count],solidUnitWeights,densities,Lookup[myOptions,Volume]}
	];

	resolvedMasses=vettedMassTuples[[All,1]];
	massTests=vettedMassTuples[[All,2]];

	(* -------- *)
	(* = Count = *)
	(* -------- *)

	vettedCountTuples=MapThread[
		Function[{object,tabletBool,count,solidUnitWeight,mass},
			Module[{testDescription},
				testDescription=ToString[object,InputForm]<>" does not require a Count:";
				Which[
					(* if it has a count and it is a tablet, then it's all cool*)
					MatchQ[count,_Integer]&&TrueQ[tabletBool],
					{count,{}},

					(* if it has a count, but is non-tablet then there is a problem*)
					MatchQ[count,_Integer]&&!TrueQ[tabletBool],
					Module[{},
						If[messagesBoolean,
							Message[Error::CountNotRequired, object];
							Message[Error::InvalidOption,Count]
						];
						{count,testOrEmpty[collectTestsBoolean,testDescription,False]}
					],

					(* If it does not have a count but we know the mass and tablet weight, calculate the count *)
					MatchQ[count,Automatic]&&TrueQ[tabletBool]&&MatchQ[solidUnitWeight,MassP]&&MatchQ[mass,MassP],
					{Round[mass/solidUnitWeight], {}},

					(* Leave count as automatic to indicate it will be measured *)
					TrueQ[tabletBool],
					{Automatic,{}},

					(* in all other cases default to Null *)
					True,
					{Null,{}}
				]
			]
		],{objects, tabletBools,Lookup[myOptions,Count],solidUnitWeights,Lookup[myOptions,Mass]}
	];

	resolvedCounts=vettedCountTuples[[All,1]];
	countTests=vettedCountTuples[[All,2]];

	(* - Check if we may want to use on the hamilton now that volume is resolved - *)

	(* If multiple samples in the same plate were sent, and no container info was provided, we need to throw a warning *)
	(* Use 15 as an arbitrary cut-off here. If they're only sending us a few samples in a plate it's fine if we transfer them out *)
	plateNamesWithMultipleSamples = Cases[Tally[myContainerLabels],{_,GreaterP[15]}][[All,1]];

	(* If being sent a sample we might want to use robotically throw a warning if we have no container info*)
	hamiltonWarningContainers = MapThread[
		Function[{model,containerName,containerModel,docs,emptySent,volume,state},
			If[
				And[
					MemberQ[plateNamesWithMultipleSamples,containerName],
					MatchQ[model,ObjectP[Model[Sample]]],
					!MatchQ[containerModel,ObjectP[Model[Container]]],
					MatchQ[docs,Null|Automatic],
					MatchQ[emptySent,False],
					Or[
						MatchQ[state, Liquid],
						VolumeQ[volume]
					]
				],
				containerName,
				Nothing
			]
		],
		{myModels,myContainerLabels,specifiedContainerModels,specifiedDocuments,emptiesSent,resolvedVolumes,states}
	];

	If[!MatchQ[hamiltonWarningContainers,{}] && messagesBoolean,
		Message[Warning::ContainerTransferForRoboticUse, DeleteDuplicates[hamiltonWarningContainers]];
	];

	hamiltonWarningContainersTest = If[!MatchQ[hamiltonWarningContainers,{}] && messagesBoolean,
		Warning["Samples may need to be transferred into a new container for robotic use.",True,MatchQ[hamiltonWarningContainers,{}]],
		Nothing
	];

	(* ----------------- *)
	(* = Container Out = *)
	(* ----------------- *)

	(* If the thing being shipped is an item and container out is specified, mark as invalid *)
	containerOutInvalidContentBools=MapThread[
		Function[{object,containerOut},
			MatchQ[object,ObjectP[Model[Item]]]&&MatchQ[containerOut,ObjectP[Model[Container]]]
		],{objects,Lookup[myOptions,ContainerOut]}
	];

	(* If we are throwing messages, throw message about container out not being allowed for items *)
	If[messagesBoolean&&MemberQ[containerOutInvalidContentBools,True],
		Message[Error::ContainerOutNotRequired,PickList[objects,containerOutInvalidContentBools]];
		Message[Error::InvalidOption,ContainerOut]
	];

	(* If we are collecting tests, assemble test for container out being allowed only for samples *)
	containerContentsValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["ContainerOut is legally specified for "<>ToString[#2]<>". (Samples may have ContainerOut specified, items may not.):",
				#1,
				False
			]&,{containerOutInvalidContentBools,objects}]
	];

	(* Validate that the container out is big enough *)
	containerOutInvalidVolumeBools=MapThread[
		Function[{object,containerOut,volume,containerMaxVolume},
			Which[

				(* If the object is an item, we already gave an error, so don't error again here *)
				MatchQ[object,ObjectP[Model[Item]]],False,

				(* If container out is not specified, valid *)
				MatchQ[containerOut,Except[ObjectP[Model[Container]]]],False,

				(* If volume is not specified, indeterminate *)
				MatchQ[volume,Null|Automatic],Null,

				(* If volume is specified and volume > container volume, invalid *)
				(volume > containerMaxVolume),True,

				(* If volume is specified and volume < container volume, valid *)
				(volume <= containerMaxVolume),False,

				(*Otherwise, valid *)
				True,False
			]
		],{objects,Lookup[myOptions,ContainerOut],resolvedVolumes,containerOutMaxVolumes}
	];

	(* If we are throwing messages, throw message about container out being too small *)
	If[messagesBoolean&&MemberQ[containerOutInvalidVolumeBools,True],
		Message[Error::VolumeExceedsContainerOut,PickList[Lookup[myOptions,ContainerOut],containerOutInvalidVolumeBools],PickList[resolvedVolumes,containerOutInvalidVolumeBools],PickList[objects,containerOutInvalidVolumeBools]];
		Message[Error::InvalidOption,ContainerOut]
	];

	(* If we are throwing messages, throw message about not being able to validate that the container is large enough *)
	If[messagesBoolean&&MemberQ[containerOutInvalidVolumeBools,Null],
		Message[Warning::ContainerOutNotValidated,PickList[objects,containerOutInvalidVolumeBools,Null],PickList[Lookup[myOptions,ContainerOut],containerOutInvalidVolumeBools,Null]]
	];

	(* If we are collecting tests, assemble test for container out being too small *)
	containerVolumeValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Sample volume does not exceed ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|Null
			]&,{containerOutInvalidVolumeBools,objects}]
	];

	(* If we are collecting tests, assemble test for container out being too small *)
	containerVolumeValidityWarnings=If[collectTestsBoolean,
		MapThread[
			Warning["Sample volume is known and crosschecked with ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|True
			]&,{containerOutInvalidVolumeBools,objects}]
	];

	(* --------------------- *)
	(* = Storage Condition = *)
	(* --------------------- *)

	vettedStorageConditions=MapThread[
		Switch[{#1,#2},
			{SampleStorageTypeP,_},{#1,{}},
			{Except[SampleStorageTypeP],_},{#2,{}}
		]&,{Lookup[myOptions,StorageCondition],defaultStorageConditions}
	];

	(* ---------------- *)
	(* = NumberOfUses = *)
	(* ---------------- *)

	vettedNumberOfUses = MapThread[
		Function[{object,numberOfUses},
			Module[{type,numberOfUsesNotRequired,requiresNumberOfUses},
			(* lookup the packet's type*)
				type=Download[object,Type];

				(* check if this type require purity *)
				requiresNumberOfUses=MemberQ[{Model[Item,Column],Object[Item,Column]},type];

				(* message for tests*)
				numberOfUsesNotRequired="The NumberOfUses option for "<>ToString[object,InputForm]<>" is not required:";

				Switch[{numberOfUses,requiresNumberOfUses},
					(* if NumberOfUses is required, but option wasn't specified, Default to 0 (NOTE: This was changed from being an error)  *)
					(* 'ShipToECL should default column NumberOfUses to 0' in Asana *)
					{Except[GreaterEqualP[0,1]],True},
						{0,{}},

					(* if NumberOfUses is required, and it was specified, then everthing is ok*)
					{GreaterEqualP[0,1],True},
						{numberOfUses,testOrEmpty[collectTestsBoolean,numberOfUsesRequired,True]},

					(* if NumberOfUses is not required, but was specified, then throw an error *)
					{GreaterEqualP[0,1],False},
						(
							If[messagesBoolean,
								Message[Error::NumberOfUsesNotRequired,object];
								Message[Error::InvalidOption,NumberOfUses];
							];
							{numberOfUses,testOrEmpty[collectTestsBoolean,numberOfUsesNotRequired,False]}
						),

					(* in all other cases, it doesn't matter*)
					{_,_},
						{Null,{}}
				]
			]
		],{objects,Lookup[myOptions,NumberOfUses]}
	];

	(* ----------- *)
	(* = Product = *)
	(* ----------- *)

	vettedProducts=MapThread[
		Function[{object,product,potentialProducts},
			Module[{type,requiresProduct,productRequired},
				(* lookup the packet's type*)
				type=Download[object,Type];

				(* check if this type require purity *)
				requiresProduct=MemberQ[{Model[Item,Column],Model[Item,Gel],Model[Item,Consumable],Model[Item,Cap], Model[Item,Tips],Object[Item,Column],Object[Item,Gel],Object[Item,Consumable],Object[Item,Cap],Object[Item,Tips]},type];

				(* message for tests*)
				productRequired="The Product option for "<>ToString[object,InputForm]<>" must be specified:";

				Switch[{product,requiresProduct,Length[potentialProducts]},
					(* if Product is required and option was specified, then all set *)
					{ObjectP[Object[Product]],True,_},
						{product,testOrEmpty[collectTestsBoolean,productRequired,True]},

					(* if Product is required and we have 1 in the Model's Products field, then use that *)
					{Except[ObjectP[Object[Product]]],True,1},
						{potentialProducts[[1]],{}},

					(* if Product is required, and it was not specified and the Model has more or fewer than 1 Product, then error out*)
					{Except[ObjectP[Object[Product]]],True,Except[1]},
						If[messagesBoolean,
							Message[Error::ShippingOptionRequired,Product,object];
							Message[Error::InvalidOption,Product];
						];
						{product,testOrEmpty[collectTestsBoolean,productRequired,False]},

					(* in all other cases, it doesn't matter (if there is a product then use it, if there isn't then use Null) *)
					{_,_,_},
						{product/.{Null->Null,Automatic->Null},{}}
				]
			]
		],{objects,Lookup[myOptions,Product],products}
	];

	(* = TrackingNumber = *)
	(* just replace anything that's an Automatic with a Null *)
	vettedTrackingNumbers=ReplaceAll[Lookup[myOptions,TrackingNumber],{Automatic->Null}];

	(* = Shipper = *)
	(* just replace anything that's an Automatic with a Null *)
	vettedShippers=ReplaceAll[Lookup[myOptions,Shipper],{Automatic->Null}];

	(* Shipper and TrackingNumber must be given together *)
	validShippingTrackingBools=MatchQ[#, {Null, Null} | {Except[Null], Except[Null]}] & /@ Transpose[{vettedTrackingNumbers, vettedShippers}];

	(* If we are throwing messages, give a message if any shippers are given without a tracking number or vice versa *)
	If[messagesBoolean&&MemberQ[validShippingTrackingBools,False],
		Message[Error::TrackingNumberAndShipperRequiredTogether,DeleteDuplicates[PickList[Transpose[{vettedTrackingNumbers, vettedShippers}],validShippingTrackingBools,False]]];
		Message[Error::InvalidOption,TrackingNumber];
		Message[Error::InvalidOption,Shipper]
	];

	shipperTrackingTests=If[collectTestsBoolean,
		MapThread[
			Test["Shipper and TrackingNumber are either both provided or are both not provided:",
				#1,
				True
			]&,
			{validShippingTrackingBools}
		]
	];

	(* = DateShipped & ExpectedDeliveryDate = *)
	vettedDates=MapThread[
		Function[{dateShipped, dateExpected},
			Module[{testDescription},
				testDescription="The ExpectedDeliveryDate must be after DateShipped";
				Switch[{dateShipped,dateExpected},
					(* if both dates were filled in, shipped has to come before expected*)
					{_?DateObjectQ,_?DateObjectQ},
						If[Greater[dateShipped,dateExpected],
							If[messagesBoolean,
								Message[Error::InvalidDates, dateShipped, dateExpected];
								Message[Error::InvalidOption,DateShipped];
								Message[Error::InvalidOption,ExpectedDeliveryDate];
							];
							{dateShipped,dateExpected,testOrEmpty[collectTestsBoolean,testDescription,False]},
							{dateShipped,dateExpected,testOrEmpty[collectTestsBoolean,testDescription,True]}
						],
					{_?DateObjectQ,Alternatives[Automatic,Null]},
						{dateShipped,Null,{}},
					{Alternatives[Automatic,Null],_?DateObjectQ},
						{Null,dateExpected,{}},
					{Alternatives[Automatic,Null],Alternatives[Automatic,Null]},
						{Null,Null,{}}
				]
			]
		],{Lookup[myOptions,DateShipped], Lookup[myOptions,ExpectedDeliveryDate]}
	];

	(* -- Validate transaction name -- *)
	(* We'll create a transaction for each unique set of shipping info *)
	shippingSpecTuples=Transpose[Lookup[myOptions, {ExpectedDeliveryDate, TrackingNumber, Shipper, DateShipped}]] /. Automatic -> Null;
	numberOfShipments=Length[DeleteDuplicates[shippingSpecTuples]];

	nameOption=Lookup[myOptions,Name];
	nameUniquenessTest=If[!NullQ[nameOption],
		Module[{resolvedNames,nameInvalidBools},

			(* Get the transaction names. Warning: this convention is used when naming transactions in ShipToECL proper and must match here *)
			resolvedNames=If[numberOfShipments>1,
				nameOption<>"_"<>ToString[#]&/@Range[numberOfShipments],
				{nameOption}
			];

			(* Check if the name is used already *)
			nameInvalidBools=DatabaseMemberQ[Append[Object[Transaction, ShipToECL], #] & /@ resolvedNames];

			(* If we are giving messages, throw a message if the name is not unique *)
			If[messagesBoolean && MemberQ[nameInvalidBools,True],
				Message[Error::NonUniqueName,PickList[resolvedNames,nameInvalidBools],Object[Transaction,ShipToECL]];
				Message[Error::InvalidOption,Name]
			];

			(* If we are collecting tests, assemble tests for name uniqueness *)
			If[!messagesBoolean,
				Test["The name of the transaction(s) is unique:", !MemberQ[nameInvalidBools,True], True]
			]
		]
	];

	(* Mass/Volume *)

	(* add an additional a warning if neither mass nor volume were specified to for samples that needs at least one*)
	toMeasureSampleGrowingList = {};(* Initialize a growing list *)
	additionalTests=MapThread[
		Function[{object, volume, mass, count},
			Module[{type,testDescription},
				type=Download[object,Type];
				testDescription="Mass, Volume or Count were not specified for " <> ToString[object,InputForm] <> " The amount will be measured upon arrival at the ECL site. This may involve transferring or thawing samples.";
				If[MatchQ[volume,Null|Automatic] && MatchQ[mass,Null|Automatic] && MatchQ[count,Null|Automatic] && MatchQ[type, TypeP[NonSelfContainedModelTypes]],
					If[messagesBoolean,
						toMeasureSampleGrowingList = Append[toMeasureSampleGrowingList,object],
						warningOrNull[collectTestsBoolean,testDescription,False]
					],
					{}
				]
			]
		],{objects,resolvedVolumes, resolvedMasses, resolvedCounts}
	];

	If[messagesBoolean && MatchQ[toMeasureSampleGrowingList,{ObjectP[]..}],
		Message[Warning::AmountWillBeMeasured, toMeasureSampleGrowingList]
	];

	(* ---------------------- *)
	(* -- Resolved cleanup -- *)
	(* ---------------------- *)

	resolvedOptions=ReplaceRule[myOptions,{
		Volume->resolvedVolumes,
		Mass->resolvedMasses,
		Count->resolvedCounts,
		StorageCondition->vettedStorageConditions[[All,1]],
		Email->resolvedEmail,

		NumberOfUses->vettedNumberOfUses[[All,1]],

		Product->vettedProducts[[All,1]],
		TrackingNumber->vettedTrackingNumbers,
		Shipper->vettedShippers,
		DateShipped->vettedDates[[All,1]],
		ExpectedDeliveryDate->vettedDates[[All,2]],
		(* this is just handled by option resolution, which has a default *)
		Destination->destination,

		ContainerType -> resolvedContainerTypes,
		ContainerModel -> resolvedContainerModels,
		CoverModel -> resolvedCoverModel,
		Position -> resolvedPositions,
		Source->resolvedSource,

		NumberOfWells -> resolvedNumberOfWells,
		PlateFillOrder -> resolvedPlateFillOrder
	}];

	allTests=Flatten[{
		volumeTests,
		massTests,
		countTests,
		vettedStorageConditions[[All,2]],
		vettedNumberOfUses[[All,2]],
		vettedProducts[[All,2]],
		vettedDates[[All,3]],
		additionalTests,
		shipperTrackingTests,
		containerContentsValidityTests,
		containerVolumeValidityTests,
		containerVolumeValidityWarnings,
		containerConflictTest,
		itemsWithPositionSpecifiedTest,
		samplesWithoutPositionTest,
		samplesWithInvalidPositionTest,
		duplicateNameTest,
		samplesInSamePositionTest,
		selfCoveredContainerWithCoverSpecifiedTest,
		incompatibleCoverContainerTest,
		noRacksTest,
		badRacksTest,
		numberOfWellsTest,
		missingContainerOptionTest,
		badVesselWellNumberTest,
		containerModelTypeMismatchTest,
		hamiltonWarningContainersTest,
		emptyUnneededTest,
		nameUniquenessTest,
		plateOptionsMissingTest,
		noPlateFillOrderTest,
		unneededDocsTest,
		conflictingDocTest,
		missingDocFilesTest
	}];

	output/.{Tests->DeleteCases[allTests,Null],Result->resolvedOptions}
];


(* ::Subsubsection::Closed:: *)
(*Sister Functions (model overloads)*)


DefineOptions[ShipToECLOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
			Description -> "Determines whether the function returns a table or a list of the options."
		}
	},
	SharedOptions :> {ShipToECL}
];


(* Empty list case *)
ShipToECLOptions[{},myOptions:OptionsPattern[ShipToECLOptions]]:={};

(* Generating a transaction overload *)
ShipToECLOptions[myModels:ListableP[ObjectP[{Model[Item],Model[Sample]}]], myContainerLabels:ListableP[_String],myOptions:OptionsPattern[ShipToECLOptions]]:=Module[{
	listedOptions,noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for ShipToECL *)
	options=ShipToECL[myModels,myContainerLabels, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ShipToECLOptions],
		options
	]
];


DefineOptions[ShipToECLPreview,SharedOptions :> {ShipToECL}];


(* Empty list case *)
ShipToECLPreview[{},myOptions:OptionsPattern[ShipToECLPreview]]:=Null;

ShipToECLPreview[myModels:ListableP[ObjectP[{Model[Item],Model[Sample]}]], myContainerLabels:ListableP[_String],myOptions:OptionsPattern[ShipToECLOptions]]:=Module[{},
	ShipToECL[myModels,myContainerLabels,Append[ToList[myOptions],Output->Preview]]
];

DefineOptions[ValidShipToECLQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ShipToECL}
];


(* Empty list case *)
ValidShipToECLQ[{},myOptions:OptionsPattern[ValidShipToECLQ]]:={};

ValidShipToECLQ[myModels:ListableP[ObjectP[{Model[Item],Model[Sample]}]], myContainerLabels:ListableP[_String],myOptions:OptionsPattern[ValidShipToECLQ]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ShipToECL[myModels,myContainerLabels,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[ToList[myModels],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{ToList[myModels],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[functionTests,voqWarnings]
		]
	];

	(* get the verbose and output options*)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidShipToECLQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidShipToECLQ"]
];



(* ::Subsubsection::Closed:: *)
(*Function (transaction overload)*)


(* --- ShipToECL  shipping updates ---- *)

(* Single case: Updates an Object[Transaction,ShipToECL] object with shipping information *)
ShipToECL[myTransaction:ObjectP[Object[Transaction,ShipToECL]], myOptions:OptionsPattern[ShipToECL]]:=FirstOrDefault[ToList[ShipToECL[{myTransaction},myOptions]]];

(* List case: Updates an Object[Transaction,ShipToECL] object with shipping information *)
ShipToECL[myTransactions:{ObjectP[Object[Transaction,ShipToECL]]..},myOptions:OptionsPattern[ShipToECL]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,validLengths,validLengthTests,
		resolvedOptionsResult,resolvedOptionsTests,safeOptionTests,namedSafeOptions,samplesOut,safeOptions,
		fastTrackOption,uploadOption,cacheOption,transactionPackets, resolvedOptions,
		optionsRule,previewRule,testsRule,resultRule,messagesBoolean,listedInputs,
		emailOption,resolvedEmail,collapsedOptions,resolvedOptionsMinusHiddenOptions,allPackets,
		nameOption,nameUpdatePackets,currentStatuses,endStateTransactions,statusTest
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* whenever we are not collecting tests, print messages instead *)
	messagesBoolean = !gatherTests;

	(* Call SafeOptions to make sure all options match pattern *)
	{namedSafeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[ShipToECL,listedOptions,AutoCorrect->False, Output->{Result,Tests}],
		{SafeOptions[ShipToECL,listedOptions,AutoCorrect->False],Null}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[namedSafeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* replace all objects referenced by Name to ID and verify IDs exist *)
	{listedInputs, safeOptions} = Experiment`Private`sanitizeInputs[ToList[myTransactions], namedSafeOptions];

	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> safeOptions,
			Preview -> Null
		}]
	];

	{currentStatuses,samplesOut} = Transpose[Download[myTransactions, {Status,ReceivedSamples[Object]}, Date -> Now]];

	(* Pull out couple of option values *)
	{fastTrackOption,uploadOption,cacheOption,emailOption}=Lookup[safeOptions,{FastTrack,Upload,Cache,Email}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[emailOption, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		emailOption,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[uploadOption, MemberQ[output, emailOption]],
			True,
			False
		]
	];

	(* Call ValidOptionLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengths,validLengthTests}=Quiet[
		If[gatherTests,
			ValidInputLengthsQ[ShipToECL,{listedInputs},listedOptions,2,Output->{Result,Tests}],
			{ValidInputLengthsQ[ShipToECL,{listedInputs},listedOptions,2],Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Pull out the non-listable option values *)
	{fastTrackOption,uploadOption,cacheOption}=Lookup[safeOptions,{FastTrack,Upload,Cache}];

	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveShipToECLOptions[myTransactions,samplesOut,safeOptions,Output->{Result,Tests}],
			{resolveShipToECLOptions[myTransactions,samplesOut,safeOptions],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* get all the safe options without the hidden options *)
	collapsedOptions=CollapseIndexMatchedOptions[ShipToECL,resolvedOptions,Messages->False,Ignore->listedOptions];
	resolvedOptionsMinusHiddenOptions = RemoveHiddenOptions[ShipToECL,collapsedOptions];

	(* Update the Name if given *)
	nameOption=Name/.resolvedOptions;
	nameUpdatePackets=If[NullQ[nameOption],
		{},
		MapThread[
			<|Object->#1,
			(* If there is more than one transaction being updated, append an index to the name, otherwise just use the given name. *)
				Name->If[Length[myTransactions]==1,
					nameOption,
					nameOption<>"_"<>ToString[#2]
				]
			|>&,{myTransactions,Range[Length[myTransactions]]}
		]
	];

	(* Transactions shouldn't be changed once they've reached an end state *)
	endStateTransactions = PickList[myTransactions,currentStatuses,Received|Canceled];

	statusTest=If[gatherTests,
		Test["The transactions being updated are still Pending or Shipping",endStateTransactions,{}],
		Null
	];

	statusTest=If[!MatchQ[endStateTransactions,{}] && !gatherTests,
		Message[Error::TransactionStatus,endStateTransactions]
	];

	If[MemberQ[currentStatuses,Received|Canceled],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,resolvedOptionsTests,statusTest],
			Options -> resolvedOptionsMinusHiddenOptions,
			Preview -> Null
		}]
	];

	(* Leave status as pending if no shipping info provided *)
	(* Move from Pending to Shipped since shipping info was provided *)
	newStatuses=MapThread[
		If[
			MatchQ[#1,Pending] && MatchQ[#2,{(Null|{})..}],
				Pending,
				Shipped
		]&,
		{
			currentStatuses,
			Transpose[Lookup[resolvedOptions,{DateShipped,TrackingNumber,ExpectedDeliveryDate}]]
		}
	];

	(* Use UploadTransaction to update the Status/StatusLog and shipping information. *)
	transactionPackets=UploadTransaction[
		myTransactions,
		newStatuses,
		Upload->False,FastTrack->True,
		Cache->cacheOption,
		Timestamp->Lookup[resolvedOptions,DateShipped]/.{Null->Automatic},
		TrackingNumber -> Replace[Lookup[resolvedOptions,TrackingNumber], {{} -> Null, x_String :> ToList[x]}, 1],
		Shipper -> Lookup[resolvedOptions, Shipper],
		DateExpected -> Lookup[resolvedOptions, ExpectedDeliveryDate],
		Email -> resolvedEmail
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		resolvedOptionsMinusHiddenOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],Null,Null];

	(* Prepare the Test result if we were asked to do so *)
	(* Join all existing tests generated by helper functions with any additional tests *)
	testsRule=Tests->If[MemberQ[output,Tests],
		DeleteCases[Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests}],Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
		If[MatchQ[resolvedOptionsResult,$Failed],
			$Failed,
		(* If uploading, upload and return the transaction objects. Otherwise return the packets. *)
			allPackets=Flatten[{ToList[nameUpdatePackets],ToList[transactionPackets]}];
			If[uploadOption,
				DeleteDuplicates[Upload[allPackets]],
				allPackets
			]
		],
		Null
	];

	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];




(* ::Subsubsection::Closed:: *)
(*resolveShipToECLOptions (transaction overload)*)


resolveShipToECLOptions[myTransactions:{ObjectP[]..},myObjects:{{ObjectP[]..}..},myOptions:{(_Rule|_RuleDelayed)..},ops:OptionsPattern[]]:=Module[
	{output,listedOutput,collectTestsBoolean,expandedOptionsToSamples,expandedOptionsToInput,matchedToSamplesInTransactions,
		matchedToInput,messagesBoolean,notNeededOption,testDescription,vettedVolumes,vettedMasses,
		vettedStorageConditions,vettedNumberOfUses,
		vettedProducts,vettedDestinations,destinationsInObject,resolvedOptions,allTests,
		dateShippedInObjects,dateExpectedInObjects,valueOrNull,shipperInObjects,vettedShippers,
		trackingNumberObjects,testOrEmpty,vettedTrackingNumbers,validShippingTrackingBools,shipperTrackingTests,resolvedDateShippedOption,
		resolvedExpectedDeliveryDateOption,invalidDateOrderBools,invalidDateTests,
		nameUniquenessTests,vettedCounts},

	(* From resolveShipToECLOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* get some info from the objects, will use those to flesh out any automatics*)
	{destinationsInObject,dateShippedInObjects,dateExpectedInObjects,shipperInObjects, trackingNumberObjects}=Transpose[Download[
		myTransactions,
		{Destination[Object],DateShipped,DateExpected,Shipper[Object],TrackingNumbers},
		Date -> Now
	]];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* if the value is Null or Automatic, then replace with with Null*)
	valueOrNull[in_]:=If[MatchQ[in, Alternatives[Null,Automatic]],Null,in];

	(* testOrEmpty: Simple helper that returns a Test whose expected value is True if makeTest->True, {} otherwise *)
	testOrEmpty[makeTest:BooleanP,description_,expression_]:=If[makeTest,
		Test[description,expression,True],
		{}
	];

	(* We need to validate that any listed options match the number of inputs.*)
	matchedToSamplesInTransactions={Volume,Mass,Count,StorageCondition,NumberOfUses,Product,TrackingNumber};

	matchedToInput={TrackingNumber,Shipper,DateShipped,ExpectedDeliveryDate,Destination};

	(* options that are index matched to the samples in in the transactions *)
	expandedOptionsToSamples=Map[
		If[!ListQ[#/.myOptions],
			Rule[#,ConstantArray[#/.myOptions,Length[Flatten[myObjects]]]],
			Rule[#,#/.myOptions]
		]&,
		matchedToSamplesInTransactions
	];

	(* options that are index matched to the input of the function*)
	expandedOptionsToInput=Map[
		If[!ListQ[#/.myOptions],
			Rule[#,ConstantArray[#/.myOptions,Length[myObjects]]],
			Rule[#,#/.myOptions]
		]&,
		matchedToInput
	];

	testDescription[object_]:="A value for " <>ToString[object,InputForm]<>" cannot be set when updating a transaction object with shipping information:";

	(* helper for resolving all the options we would expect not to matter (since they have already been set and should not be changed) for the transaction overload *)
	notNeededOption[testObjects_,testOption_,testOptionValues_]:=MapThread[
		Function[{object,optionValue},
			Switch[optionValue,
				Except[Alternatives[Null,Null,Automatic]],
				If[messagesBoolean,
					Message[Error::ShippingOptionNotRequired,testOption, object];
					Message[Error::InvalidOption,testOption],
					{optionValue,Test[testDescription[optionValue],True,False]}
				],
				_,
				{Null,{}}
			]
		],{Flatten[myObjects],testOptionValues}
	];

	{vettedVolumes,vettedMasses,vettedCounts,vettedStorageConditions,vettedNumberOfUses,vettedProducts}=Map[
		notNeededOption[Flatten[myObjects],#,Lookup[expandedOptionsToSamples,#]]&,
		{Volume,Mass,Count,StorageCondition,NumberOfUses,Product}
	];

	(* = Destination = *)
	vettedDestinations=MapThread[
		Function[{destinationInObject,destinationInOption},
			Switch[destinationInOption,
			(* if they don't touch this option then it doesn't really matter, but return what's in the object*)
				Alternatives[Null,Null,Automatic],
				{destinationInObject,{}},
			(* if they decide to change the option, then warn them that you cannot do that since they've already set the destination when they created the original transaction*)
				Except[Alternatives[Null,Null,Automatic]],
				If[
					messagesBoolean,
					Message[Error::ShippingOptionNotRequired,Destination, myTransactions];
					Message[Error::InvalidOption,Destination],
					{destinationInOption,Test["bob",True,False]}
				]
			]
		],{destinationsInObject,Lookup[expandedOptionsToInput,Destination]}
	];

	(* = Shipped = *)
	(* they are free to change the shipper if they want *)
	vettedShippers=MapThread[
		Function[{shipperInObject,shipperInOption},
			Switch[shipperInOption,
				(* if they don't touch this option then it doesn't really matter, but return what's in the object or if that's null then return a Null*)
				(* Automatic should either give whatever is currently in the field *)
				Alternatives[Null,Automatic],
					{valueOrNull[shipperInObject],{}},
				(* Null should remove the shipper, so leave it as Null *)
				Alternatives[Null],
					{Null,{}},
				(* else just use whatever they give us*)
				_,{shipperInOption,{}}
			]
		],{shipperInObjects,Lookup[expandedOptionsToInput,Shipper]}
	];

	(* = DateShipped & ExpectedDeliveryDate = *)
	resolvedDateShippedOption=MapThread[
		If[MatchQ[#1,Automatic],
			valueOrNull[#2],
			#1]&,{Lookup[expandedOptionsToInput,DateShipped],dateShippedInObjects}
	];

	resolvedExpectedDeliveryDateOption=MapThread[
		If[MatchQ[#1,Automatic],
			valueOrNull[#2],
			#1]&,{Lookup[expandedOptionsToInput,ExpectedDeliveryDate],dateExpectedInObjects}
	];

	(* --- If date shipped and expected delivery date are both specified, make sure the shipment date is earlier than the delivery date --- *)
	(* Find any models that have an earlier date expected than date shipped *)
	invalidDateOrderBools = MapThread[TrueQ[Greater[#1, #2]] &, {resolvedDateShippedOption, resolvedExpectedDeliveryDateOption}];

	(* If we are giving messages, throw a message that dates are invalid *)
	If[messagesBoolean&&MemberQ[invalidDateOrderBools, True],
		Message[Error::InvalidDates, PickList[myTransactions,invalidDateOrderBools]];
		Message[Error::InvalidOption,DateShipped];
		Message[Error::InvalidOption,ExpectedDeliveryDate]
	];

	(* If we are giving tests, generate tests that dates are invalid *)
	invalidDateTests=If[collectTestsBoolean,
		MapThread[
			Test["ExpectedDeliveryDate is later than DateShipped for "<>ToString[#],
				#2,
				False
			]&,{myTransactions,invalidDateOrderBools}]
	];

	(* they are free to change the tracking number if they want if they want *)
	vettedTrackingNumbers=MapThread[
		Function[{trackingNumberInObject,trackingNumberInOption},
			Switch[trackingNumberInOption,
			(* if they don't touch this option then it doesn't really matter, but return what's in the object value or if that's null then return a Null*)
				Alternatives[Null,Automatic],
				{valueOrNull[trackingNumberInObject],{}},
			(* Null should remove the shipper, so leave it as Null *)
				Alternatives[Null],
				{Null,{}},
			(* else just use whatever they give us*)
				_,{valueOrNull[trackingNumberInOption],{}}
			]
		],{trackingNumberObjects,Lookup[expandedOptionsToInput,TrackingNumber]}
	];

	(* Shipper and TrackingNumber must be given together *)
	validShippingTrackingBools=MatchQ[#, {Null | {}, Null} | {Except[Null] | Except[{}], Except[Null]}] & /@ Transpose[{vettedTrackingNumbers[[All, 1]], vettedShippers[[All, 1]]}];

	(* If we are throwing messages, give a message if any shippers are given without a tracking number or vice versa *)
	If[messagesBoolean&&MemberQ[validShippingTrackingBools,False],
		Message[Error::TrackingNumberAndShipperRequiredTogether,DeleteDuplicates[PickList[Transpose[{vettedTrackingNumbers[[All, 1]], vettedShippers[[All, 1]]}],validShippingTrackingBools,False]]];
		Message[Error::InvalidOption,TrackingNumber];
		Message[Error::InvalidOption,Shipper]
	];

	shipperTrackingTests=If[collectTestsBoolean,
		MapThread[
			Test["Shipper and TrackingNumber are either both provided or are both not provided. (If the option value is Automatic or Null, the value in the transaction object is used.):",
				#1,
				True
			]&,{validShippingTrackingBools}]
	];

	(* --- Validate the Name option --- *)
	nameUniquenessTests=If[!NullQ[Lookup[myOptions,Name]],
		Module[{numberOfTransactions,name,expandedNames,nameValidBools},

		(* We need to see how many transaction packets will be made to see what the names will be. Transactions that have different order numbers, service providers, or shipping info are split up   *)
			numberOfTransactions = Length[myTransactions];

			(* Get the name option *)
			name=Lookup[myOptions,Name];

			(* Expand the name if we are updating multiple transaction objects *)
			expandedNames=If[numberOfTransactions==1,
				ToList[name],
				Map[name<>"_"<>ToString[#]&/@Range[numberOfTransactions]]
			];

			(* Check if the name is used already *)
			nameValidBools=DatabaseMemberQ[Append[Object[Transaction, ShipToECL], #] & /@ expandedNames];

			(* If we are giving messages, throw a message if the name is not unique *)
			If[messagesBoolean&&MemberQ[nameValidBools,True],
				Message[Error::NonUniqueName,PickList[expandedNames,nameValidBools],Object[Transaction,ShipToECL]];
				Message[Error::InvalidOption,Name]
			];

			(* If we are collecting tests, assemble tests for name uniquness *)
			If[collectTestsBoolean,
				MapThread[
					Test["The name "<>ToString[#2]<>" is unique for Object[Transaction, DropShipping]:",
						#1,
						False
					]&,{nameValidBools,expandedNames}]
			]
		]
	];

	resolvedOptions=ReplaceRule[myOptions,{
		Volume->vettedVolumes[[All,1]],
		Mass->vettedMasses[[All,1]],
		Count->vettedCounts[[All,1]],
		StorageCondition->vettedStorageConditions[[All,1]],

		NumberOfUses->vettedNumberOfUses[[All,1]],

		Product->vettedProducts[[All,1]],

		TrackingNumber->vettedTrackingNumbers[[All,1]],

		Shipper->vettedShippers[[All,1]],
		DateShipped->resolvedDateShippedOption,
		ExpectedDeliveryDate->resolvedExpectedDeliveryDateOption,
		Destination->vettedDestinations[[All,1]]
	}
	];

	allTests=Flatten[{
		vettedVolumes[[All,2]],
		vettedMasses[[All,2]],
		vettedCounts[[All,2]],
		vettedStorageConditions[[All,2]],
		vettedNumberOfUses[[All,2]],
		vettedProducts[[All,2]],
		vettedTrackingNumbers[[All,2]],
		vettedShippers[[All,2]],
		shipperTrackingTests,
		invalidDateTests,
		nameUniquenessTests
	}];

	output/.{Tests->allTests,Result->resolvedOptions}
];


(* ::Subsubsection::Closed:: *)
(*Sister Functions (transaction overloads)*)


(* Empty list case *)
ShipToECLOptions[{},myOptions:OptionsPattern[ShipToECLOptions]]:={};


(* Single case *)
ShipToECLOptions[myTransaction:ObjectP[Object[Transaction,ShipToECL]],myOptions:OptionsPattern[ShipToECLOptions]]:=ShipToECLOptions[{myTransaction},myOptions];


(* Multiple case*)
ShipToECLOptions[myTransactions:{ObjectP[Object[Transaction,ShipToECL]]..}, myOptions:OptionsPattern[ShipToECLOptions]]:=
    Module[{listedOptions, noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for ShipToECL *)
	options=ShipToECL[myTransactions, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ShipToECLOptions],
		options
	]
];


(* Empty list case *)
ShipToECLPreview[{},myOptions:OptionsPattern[ShipToECLPreview]]:={};


(* Single case *)
ShipToECLPreview[
	myTransaction:ObjectP[Object[Transaction,ShipToECL]],myOptions:OptionsPattern[ShipToECLPreview]]:=ShipToECLPreview[{myTransaction},myOptions];


(* Multiple case*)
ShipToECLPreview[myTransactions:{ObjectP[Object[Transaction,ShipToECL]]..}, myOptions:OptionsPattern[ShipToECLPreview]]:=Module[{},
	ShipToECL[myTransactions,Append[ToList[myOptions],Output->Preview]]
];


(* Empty list case *)
ValidShipToECLQ[{},myOptions:OptionsPattern[ShipToECLOptions]]:={};


(* Single case *)
ValidShipToECLQ[
	myTransaction:ObjectP[Object[Transaction,ShipToECL]],myOptions:OptionsPattern[ValidShipToECLQ]]:=ValidShipToECLQ[{myTransaction},myOptions];


(* Multiple case*)
ValidShipToECLQ[myTransactions:{ObjectP[Object[Transaction,ShipToECL]]..},myOptions:OptionsPattern[ValidShipToECLQ]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=ShipToECL[myTransactions,preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[{initialTest,validObjectBooleans,voqWarnings},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[myTransactions,OutputFormat->Boolean];
			voqWarnings=MapThread[
				Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
					#2,
					True
				]&,
				{myTransactions,validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Join[{},functionTests,voqWarnings]
		]
	];

	(* get the verbose and output options*)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidShipToECLQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidShipToECLQ"]
];

(* ::Subsection:: *)
(*DropShipSamples*)


(* ::Subsubsection::Closed:: *)
(*DropShipSamples Options and Messages*)


DefineOptions[DropShipSamples,
	Options :> {
		{
			OptionName->Destination,
			Default->$Site,
			Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Container, Site]]],
			Description->"The ECL facility where the samples are being delivered.",
			AllowNull->False,
			Category->"Shipping Information"
		},
		IndexMatching[
			IndexMatchingInput->{"Model Input Block","Transaction Input Block"},
			{
				OptionName->Provider,
				Default->Null,
				Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Company, Service],Object[Company, Supplier]}],ObjectBuilderFunctions->{UploadCompanyObject}],
				Description->"The company that is providing the samples. Note that the some companies may have both a supplier and service objects; this option is required to be set to a service object for model sample inputs. If this option is given for product inputs, it must match the supplier of the product.",
				AllowNull->True,
				Category->"Sample Information"
			},
			{
				OptionName->ExpectedDeliveryDate,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Date, Pattern:>_?DateObjectQ, TimeSelector->False],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Description->"The date that the samples are expected to be delivered.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing DateExpected value when updating a transaction.",
				AllowNull->True,
				Category->"Shipping Information"
			},
			{
				OptionName->TrackingNumber,
				Default->Automatic,
				Widget->Alternatives[
					Adder[Widget[Type->String,Pattern:>_String,Size->Word],Orientation->Horizontal],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]],
					Widget[Type->String,Pattern:>_String,Size->Word]
				],
				Description->"The tracking number of the package being shipped by the supplier to the ECL facility.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing TrackingNumber value when updating a transaction.",
				AllowNull->True,
				Category->"Shipping Information"
			},
			{
				OptionName->Shipper,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Object[Company, Shipper]],ObjectBuilderFunctions->{UploadCompanyObject}],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Description->"The company through which the service company is shipping the samples.",
				ResolutionDescription->"Automatic resolves to Null when creating a new transaction, and resolves to the existing Shipper value when updating a transaction.",
				AllowNull->True,
				Category->"Shipping Information"
			},
			{
				OptionName -> DateShipped,
				Default -> Automatic,
				Widget -> Alternatives[
					Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector -> False],
					Widget[Type -> Enumeration, Pattern :> Alternatives[None]]
				],
				Description -> "The date the samples were shipped.",
				ResolutionDescription -> "Automatic resolves to Null when creating a new transaction, to Now when updating a transaction with shipping info for the first time, to the existing DateShipped value when updating a transaction.",
				AllowNull -> True,
				Category->"Shipping Information"
			}
		],
		IndexMatching[
			IndexMatchingInput->{"Model Input Block"},
			{
				OptionName->ContainerOut,
				Default->None,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container]]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Category->"Sample Information",
				Description->"The desired type of container that the sample should be transferred into upon receiving."
			},
			{
				OptionName->Mass,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Quantity, Pattern:>GreaterP[0 Gram], Units -> Alternatives[Microgram,Milligram,Gram,Kilogram]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None,ProductDocumentation,ExperimentallyMeasure]]
				],
				Description->"The amount sent, or directive on how to determine the amount. A mass indicates that that mass should be populated as the initial mass of the sample. ExperimentallyMeasure indicates that the sample mass should be measured upon arrival. ProductDocumentation indicates that the mass should be found on the documents that ship with the sample.",
				ResolutionDescription->"When generating a transaction, for model inputs Automatic resolves to ExperimentallyMeasure for solid samples and to Null for items or for non-solid samples, and for product Automatic resolves to the mass of the product.",
				AllowNull->True,
				Category->"Sample Information"
			},
			{
				OptionName->Quantity,
				Default->Automatic,
				Widget->Widget[Type->Number, Pattern :> GreaterP[0, 1]],
				Description->"The number of tablets sent, or directive on how to determine the count. A integer indicates that that count should be populated as the initial count of the sample. ExperimentallyMeasure indicates that the sample count (and tablet weight if it is not known) should be measured upon arrival. ProductDocumentation indicates that the count should be found on the documents that ship with the sample.",
				ResolutionDescription->"When generating a transaction, for model inputs Automatic resolves to ExperimentallyMeasure for tablet samples and to Null for items or for non-tablet samples, and for product Automatic resolves to the count of the product.",
				AllowNull->False,
				Category->"Sample Information"
			},
			{
				OptionName->Count,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Number, Pattern :> GreaterP[0, 1]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None,ProductDocumentation,ExperimentallyMeasure]]
				],
				Description->"The number of tablets sent, or directive on how to determine the count. A integer indicates that that count should be populated as the initial count of the sample. ExperimentallyMeasure indicates that the sample count (and tablet weight if it is not known) should be measured upon arrival. ProductDocumentation indicates that the count should be found on the documents that ship with the sample.",
				ResolutionDescription->"When generating a transaction, for model inputs Automatic resolves to ExperimentallyMeasure for tablet samples and to Null for items or for non-tablet samples, and for product Automatic resolves to the count of the product.",
				AllowNull->True,
				Category->"Sample Information"
			},
			{
				OptionName->Volume,
				Default->Automatic,
				Widget->Alternatives[
					Widget[Type->Quantity, Pattern:>GreaterP[0 Milliliter], Units -> Alternatives[Microliter,Milliliter,Liter]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None,ProductDocumentation,ExperimentallyMeasure]]
				],
				Description->"The amount sent, or directive on how to determine the amount. A volume indicates that that volume should be populated as the initial volume of the sample. ExperimentallyMeasure indicates that the sample volume should be measured upon arrival. ProductDocumentation indicates that the volume should be found on the documents that ship with the sample.",
				ResolutionDescription->"When generating a transaction, for model inputs Automatic resolves to ExperimentallyMeasure for liquid samples and to Null for items or for non-liquid samples, and for product Automatic resolves to the volume of the product.",
				AllowNull->True,
				Category->"Sample Information"
			},
			{
				OptionName->ShippedRack,
				Default->None,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container, Rack]]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Description->"The model of rack that is shipped holding other items in this order.",
				Category->"Shipment"
			},
			{
				OptionName -> Sterile,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates that samples of this product arrive sterile from the manufacturer.",
				Category -> "Sample Information"
			},
			{
				OptionName -> SealedContainer,
				Default -> Null,
				Description -> "Indicates whether the items of this order arrive as sealed containers with caps or lids. If SealedContainer -> True, no special storage handling will be performed, even if Sterile -> True.",
				AllowNull -> True,
				Category -> "Sample Information",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> AsepticShippingContainerType,
				Default -> Null,
				Description -> "The manner in which an aseptic item is packed and shipped by the manufacturer. A value of None indicates that the product is not shipped in any specifically aseptic packaging, while a value of Null indicates no available information.",
				AllowNull -> True,
				Category -> "Sample Information",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> AsepticShippingContainerTypeP
				]
			},
			{
				OptionName -> AsepticRebaggingContainerType,
				Default -> Null,
				Description -> "Describes the type of container this item will be transferred to if they arrive in a non-resealable aseptic shipping container.",
				AllowNull -> True,
				Category -> "Sample Information",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> AsepticTransportContainerTypeP
				]
			}
		],
		{
			OptionName -> ReceivingTolerance,
			Default -> 1*Percent,
			Description -> "Defines the allowable difference between ordered amount and received amount for every item in the transaction. Any difference greater than the ReceivingTolerance will not be received, and will instead by investigated by Systems Diagnostics.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0Percent,100Percent],
				Units :> Alternatives[Percent]
			],
			Category -> "Hidden"
		},
		OutputOption,
		NameOption,
		UploadOption,
		CacheOption,
		FastTrackOption,
		EmailOption
	}
];

Error::VolumeNotRequired="Volume is not expected for these models as they are not liquid samples, `1`. Please set Volume for these models to Null, or leave them as Automatic.";
Error::MassNotRequired="Mass is not expected for these models as they are not solid samples, `1`. Please set Mass for these models to Null, or leave them as Automatic.";
Error::CountNotRequired="Count is not expected for these models, `1` since they are not tablets. Please set Count for these models to Null, or leave them as Automatic.";
Error::InvalidDates = "The specified DateShipped is later than the ExpectedDeliveryDate in these cases: `1`. Please make sure that the shipment date is earlier than the expected delivery date.";
Error::ModelsHaveConflictingMass="These model inputs `1` were specified multiple times with conflicting Mass options. Because these models are indistinguishable when they arrive at ECL, we will not know which instance of the model goes with which value. If the models will have different values, please specify either ProductDocumentation or ExperimentallyMeasure. If all instances of the model in this transaction will have the same mass, you may alternatively specify numerical amount values that are consistent for all inputs of this model. To help keep options consistent within the same model, you may specify a quantity of that model instead of entering the same model multiple times.";
Error::ModelsHaveConflictingCount="These model inputs `1` were specified multiple times with conflicting Count options. Because these models are indistinguishable when they arrive at ECL, we will not know which instance of the model goes with which value. If the models will have different values, please specify either ProductDocumentation or ExperimentallyMeasure. If all instances of the model in this transaction will have the same count, you may alternatively specify numerical amount values that are consistent for all inputs of this model. To help keep options consistent within the same model, you may specify a quantity of that model instead of entering the same model multiple times.";
Error::ModelsHaveConflictingVolume="These model inputs `1` were specified multiple times with conflicting Volume options. Because these models are indistinguishable when they arrive at ECL, we will not know which instance of the model goes with which value. If the models will have different values, please specify either ProductDocumentation or ExperimentallyMeasure. If all instances of the model in this transaction will have the same volume, you may alternatively specify numerical amount values that are consistent for all inputs of this model. To help keep options consistent within the same model, you may specify a quantity of that model instead of entering the same model multiple times.";
Error::OptionMustMatchModelsInTransactions = "This option's length does not match the length of the transaction samples: `1`. The transaction samples has length `2`; please provide an option list of this length, or, alternatively, supply a single option value to be used for all samples in the transactions.";
Error::ProductSupplierConflict="The input company for these products `1` is `2`, but the supplier of these products is `3`. Please specify check that your company input matches the supplier of the products. Alternatively, you make leave the company unspecified for product inputs (company is only required for model inputs).";
Error::CompanyRequiredForModelInputs="These model inputs `1` must have a service company (Object[Company, Service], not a supplier) specified as the Provider. Alternatively, please input a product instead of a model if you do not want to specify the service company for an input model.";
Error::MassDiscrepancy="The mass for `1` was specified as `2`, but this differs from the Amount field of the product. Please update the amount to reflect the product amount (or to be Null, if the product is a kit), or allow the amount to be automatically determined.";
Error::CountDiscrepancy="The count for `1` was specified as `2`, but this differs from the Amount field of the product. Please update the amount to reflect the product amount (or to be Null, if the product is a kit), or allow the amount to be automatically determined.";
Error::VolumeDiscrepancy="The volume for `1` was specified as `2`, but this differs from the Amount field of the product. Please update the amount to reflect the product amount (or to be Null, if the product is a kit), or allow the amount to be automatically determined.";
Error::MassCountDisagree="Mass and count are both specified for `1` but do not agree based on the known tablet weight. Please make sure that mass and count are in agreement if tablet weight is known, or only specify one of these options and allow the other to be automatically determined.";
Warning::SampleMayBeTransferred="Although a volume was specified for these models, `1`, the density is not known. If the sample arrives in a container that is not parameterized for liquid level detection, your sample will be transferred to another container upon arrival. If this is not desired, please populate the Density of the models.";
Warning::MeasurementMayRequireTransfer="Please be aware that these models, `1`, may be transferred to another container in order to experimentally determine the amount. If this is not desired, please specify an amount or specify ProductDocumentation to indicate that the amount should be found on the documents that ship with the sample.";
Warning::NewServiceProviderForModel="The specified service providers, `2`, are not known for these models, `1`. The model will be updated with this service provider. No action is needed on your part.";



(* ::Subsubsection:: *)
(*DropShipSamples*)


DropShipSamples[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]] := Module[
	{
		safeOptions, newCache, orderNumberInput, modelInputPackets,newProviderModelPairs,quantityOption,
		outputSpecification,output,gatherTests,safeOptionTests, listedOptions,validLengths,validLengthTests,resolvedOptions,
		resolvedOptionsTests,resolvedOptionsResult,optionsRule,testsRule,resultRule, serviceProviderTests,expandedOptions,
		expandedTrackingNumber,downloadedStuff,containerOutMaxVolumes, expandedOptionsWithTrackingNumber,expandedInputs,
		modelInputs,productInputs,productInputPackets,modelCompanies,
		productModelPackets,orderedInputPackets,orderedModelPackets, kitComponentModelPackets,
		modelContainerPackets, productContainerPackets, rackPackets, racks, partitionedSteriles, partitionedSealedContainers,
		partitionedAsepticShippingContainerTypes, partitionedAsepticRebaggingContainerTypes
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[DropShipSamples,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[DropShipSamples,listedOptions,AutoCorrect->False],Null}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[DropShipSamples,{myInputs, myOrderNumbers},safeOptions, 1, Output->{Result,Tests}],
		{ValidInputLengthsQ[DropShipSamples,{myInputs, myOrderNumbers},safeOptions, 1],Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Expand index matched options and inputs. *)
	{{expandedInputs,orderNumberInput},expandedOptions}=ExpandIndexMatchedInputs[DropShipSamples, {ToList[myInputs],myOrderNumbers}, safeOptions, 1];

	(* Because the TrackingNumber pattern allows a list of tracking numbers as well as a nested list of tracking numbers (for the transaction overload), the expander doesn't know how to handle it, so update it here *)
	expandedTrackingNumber=With[{trackingNumber=(TrackingNumber/.safeOptions)},
		If[ListQ[trackingNumber],
			trackingNumber,
			ConstantArray[trackingNumber,Length[expandedInputs]]
		]
	];
	expandedOptionsWithTrackingNumber=ReplaceRule[expandedOptions,TrackingNumber->expandedTrackingNumber];


	(* We want to download different stuff from products vs models, so separate them out here *)
	modelInputs=Cases[expandedInputs,ObjectP[{Model[Sample],Model[Item]}]];
	productInputs=Cases[expandedInputs,ObjectP[Object[Product]]];
	racks = DeleteDuplicates[Cases[Lookup[expandedOptions, ShippedRack], ObjectP[]]];

	(* Download required field information *)
	downloadedStuff = Quiet[Download[
		{
			modelInputs,
			productInputs,
			productInputs,
			(Lookup[expandedOptions, ContainerOut]/. None -> Null),
			productInputs,
			modelInputs,
			modelInputs,
			modelInputs,
			productInputs,
			racks
		},
		{
			{Packet[Deprecated, State, Density, ServiceProviders, Products, Tablet, SolidUnitWeight, KitProducts]},
			{Packet[Supplier,NumberOfItems,ProductModel, Amount,CountPerSample, KitComponents, DefaultContainerModel]},
			{Packet[ProductModel[{Deprecated, State, Density, ServiceProviders, Products,Tablet,SolidUnitWeight}]]},
			{MaxVolume},
			{Packet[KitComponents[[All, ProductModel]][{Deprecated, State, Density, ServiceProviders, Products, Tablet, SolidUnitWeight}]]},
			{Packet[Products[Deprecated]]},
			{Packet[KitProducts[Deprecated]]},
			(* If the input was a model, get the dimensions of the default container and themodel itself if it is a container *)
			{
				Packet[Products[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]],
				Packet[KitProducts[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]]
			},

			(* if the input was a product, get the dimensions of the container *)
			{Packet[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]},

			(* if the ShippedRacks option was populated, check that *)
			{Packet[Positions]}
		},
		Cache -> Lookup[safeOptions, Cache],
		Date -> Now
	],{Download::FieldDoesntExist, Download::NotLinkField}];

	(* Get the downloaded stuff into usable variables *)
	modelInputPackets=Flatten[downloadedStuff[[1]]];
	productInputPackets=Flatten[downloadedStuff[[2]]];
	productModelPackets=Flatten[downloadedStuff[[3]]];
	containerOutMaxVolumes=Flatten[downloadedStuff[[4]]];
	kitComponentModelPackets = Flatten[downloadedStuff[[5]]];
	modelContainerPackets = Flatten[downloadedStuff[[6]]];
	productContainerPackets = Flatten[downloadedStuff[[7]]];
	rackPackets = Flatten[downloadedStuff[[8]]];

	(* Update the cache with these downloaded packets *)
	newCache=Join[Lookup[safeOptions,Cache], Cases[Flatten[Drop[downloadedStuff,{4}]], PacketP[]]];

	(* Get the input packets in order of the inputs so that they are indexed to the options *)
	orderedInputPackets=FirstCase[Join[modelInputPackets, productInputPackets], KeyValuePattern[Object -> Download[#, Object]]] & /@ ToList[myInputs];

	(* Get the model input packets in order of the inputs so that they are indexed to the inputs *)
	(* note that for Kits, the model packets will actually be a list of packets *)
	orderedModelPackets = Map[
		Function[{inputPacket},
			Which[
				MatchQ[inputPacket, ObjectP[{Model[Sample],Model[Item]}]], FirstCase[modelInputPackets, KeyValuePattern[Object -> Download[inputPacket, Object]]],
				MatchQ[inputPacket, ObjectP[Object[Product]]] && Not[NullQ[Lookup[inputPacket, ProductModel]]], FirstCase[productModelPackets, KeyValuePattern[Object -> Download[Lookup[inputPacket, ProductModel], Object]]],
				True, FirstCase[kitComponentModelPackets, KeyValuePattern[Object -> Download[Lookup[#, ProductModel], Object]]]& /@ Lookup[inputPacket, KitComponents]
			]
		],
		orderedInputPackets
	];

	(* Call resolveDropShipSamplesOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveDropShipSamplesOptions[orderedInputPackets,orderedModelPackets,orderNumberInput,containerOutMaxVolumes,ReplaceRule[expandedOptionsWithTrackingNumber, Cache-> newCache],Output->{Result,Tests}],
			{resolveDropShipSamplesOptions[orderedInputPackets,orderedModelPackets,orderNumberInput,containerOutMaxVolumes,ReplaceRule[expandedOptionsWithTrackingNumber, Cache-> newCache]],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];

	(* If option resolution failed, return here *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> DeleteCases[Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests}],Null],
			Options -> resolvedOptions,
			Preview -> Null
		}]
	];

	(* Get the providers that correspond to the model inputs  *)
	modelCompanies=PickList[Lookup[resolvedOptions,Provider],ToList[myInputs],ObjectP[{Model[Sample],Model[Item]}]];

	(* Check if the specified service provider is one of the service providers listed in the model. *)
	{newProviderModelPairs,serviceProviderTests}=If[MatchQ[modelInputPackets,{}],
		{{},{}},
		Transpose[
			MapThread[
			(* Find those that don't have the specified service provider OR that don't have products (since we are already throwing a product message) OR that are null (since we are already throwing a message for Null) *)
				With[{modelProviderLinked=MemberQ[Download[Lookup[#1, ServiceProviders], Object], Download[#2, Object]] || MatchQ[#, KeyValuePattern[{Products -> ListableP[ObjectP[]]}]] || NullQ[#2]},
					{
						If[modelProviderLinked,
							Null,
							{#1, #2}],
						Warning["The service provider "<>ToString[Download[#2, Object]]<>" is known for the model "<>ToString[Lookup[#1,Object]]<>". (The model will be updated with this service provider. No action is needed on your part.):",
							modelProviderLinked,
							True
						]
					}
				]&, {modelInputPackets, modelCompanies}]
		]
	];

	(* If we are throwing messages, throw a warning that we will update the service provider with the models *)
	If[!MemberQ[output,Tests]&&!MatchQ[newProviderModelPairs, {Null...}],
		Message[Warning::NewServiceProviderForModel, Lookup[DeleteCases[newProviderModelPairs, Null][[All,1]],Object], DeleteCases[newProviderModelPairs, Null][[All,2]]]
	];


	(* --- Generate rules for each possible Output value ---  *)



	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		With[{collapsedOptions = CollapseIndexMatchedOptions[DropShipSamples, resolvedOptions, Messages -> False,Ignore->listedOptions]},
			RemoveHiddenOptions[DropShipSamples,ReplaceRule[resolvedOptions,collapsedOptions]]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
	(* Join all exisiting tests generated by helper functions with any additional tests *)
		DeleteCases[Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests,serviceProviderTests}],Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result]&&!MatchQ[resolvedOptionsResult,$Failed],
		Module[{requestor,serviceProviderUpdates,groupedInputsAndInfo,transactionInfoGroupedByShipping,transactionPackets,
			partitionedModelPackets, partitionedOrderNumberInput, partitionedQuantityInput, partitionedValidatedMass,transactionStatuses,
			partitionedValidatedVolume,  partitionedServiceInput,
			partitionedExpandedDateExpected, partitionedExpandedTrackingNumber, partitionedExpandedShipper, partitionedExpandedDateShipped,
			statusPackets, allPackets,expandedMassOption,expandedVolumeOption,
			expandedShipperOption,expandedDateExpectedOption, expandedTrackingNumberOption,expandedDateShippedOption,destination,
			nameOption,partitionedContainerOut,specifiedAndKnownProviders,expandedCountOption,partitionedValidatedCount,
			transactionPacketsExtraFields, expandedRackOption, partitionedShippedRacks, requiresAsepticCertification
		},

			(* Pull out expanded resolved option values *)
			{expandedMassOption,expandedVolumeOption,expandedCountOption,expandedShipperOption,expandedDateExpectedOption,
				expandedTrackingNumberOption,expandedDateShippedOption,destination,nameOption, expandedRackOption}=Lookup[resolvedOptions,{Mass,Volume,Count,Shipper,ExpectedDeliveryDate,TrackingNumber,DateShipped,Destination,Name, ShippedRack}];

			(* The logged in user is the person generating these transactions *)
			requestor = $PersonID;

			(* If the specified service provider is not one of the service providers listed in the model, make a packet to update the model. (We already threw a warning/test that we would do so.) *)
			serviceProviderUpdates=<|Object -> Lookup[#[[1]], Object], Append[ServiceProviders] -> Link[#[[2]],CustomSynthesizes]|> & /@ DeleteCases[newProviderModelPairs, Null];

			(* Provider is only required for model inputs. We already know the provider for product inputs.
				(We have already done error checking to make sure that provider is specified for models and that if provider is specified for products, it matches the product supplier.)
			 	So replace any Null providers with the known product suppliers so that we can group the transaction inputs by provider. *)
			specifiedAndKnownProviders=MapThread[
				If[NullQ[#1],
					#2,
					#1
				] &, {Lookup[resolvedOptions,Provider], Download[Lookup[orderedInputPackets,Supplier,Null],Object]}
			];

			(* Get the quantity option *)
			quantityOption=Lookup[resolvedOptions,Quantity];

			(* We need to ascertain if there is a possibility that we will need to use the biosafety cabinet, and thus require aseptic certification, to receive this. *)
			(* This is true if 1) Sterile is True and 2) AsepticShippingContainerType is not Individual *)
			requiresAsepticCertification = Or@@MapThread[
				Function[{sterile, asepticShippingContainerType},
					MatchQ[sterile, True] && !MatchQ[asepticShippingContainerType, Individual]
				],
				{Lookup[resolvedOptions, Sterile], Lookup[resolvedOptions, AsepticShippingContainerType]}
			];

			(* Group each set of transaction info together *)
			groupedInputsAndInfo = Transpose[{
				orderedInputPackets,
				orderNumberInput,
				quantityOption,
				expandedMassOption,
				expandedVolumeOption,
				specifiedAndKnownProviders,
				expandedDateExpectedOption,
				expandedTrackingNumberOption,
				(expandedShipperOption /. x : ObjectP[] -> Download[x, Object]),
				expandedDateShippedOption,
				Lookup[expandedOptions,ContainerOut],
				expandedCountOption,
				expandedRackOption,
				Lookup[resolvedOptions,Sterile],
				Lookup[resolvedOptions,SealedContainer],
				Lookup[resolvedOptions,AsepticShippingContainerType],
				Lookup[resolvedOptions,AsepticRebaggingContainerType]
			}];

			(* Group inputs that have the same service provider, order number, shipping info *)
			transactionInfoGroupedByShipping = GatherBy[groupedInputsAndInfo, {#[[2]], #[[6]], #[[7]], #[[8]], #[[9]], #[[10]]} &];

			(* Get the partitioned samples, containers, and shipping options *)
			{
				partitionedModelPackets,
				partitionedOrderNumberInput,
				partitionedQuantityInput,
				partitionedValidatedMass,
				partitionedValidatedVolume,
				partitionedServiceInput,
				partitionedExpandedDateExpected,
				partitionedExpandedTrackingNumber,
				partitionedExpandedShipper,
				partitionedExpandedDateShipped,
				partitionedContainerOut,
				partitionedValidatedCount,
				partitionedShippedRacks,
				partitionedSteriles,
				partitionedSealedContainers,
				partitionedAsepticShippingContainerTypes,
				partitionedAsepticRebaggingContainerTypes
			} = Map[
				transactionInfoGroupedByShipping[[All, All, #1]] &,
				Range[Length[First[groupedInputsAndInfo]]]
			];

			(* Construct the drop ship transaction packets *)
			transactionPackets = MapThread[
				Function[{inputPackets, orderNumbers, quantities, masses, volumes,  providers,index,containerOuts,counts, rack,
					sterile, sealedContainer, asepticShippingContainerType, asepticRebaggingContainerType},
					<|
						Object -> CreateID[Object[Transaction, DropShipping]],
						Creator -> Link[requestor, TransactionsCreated],
						Destination -> Link[destination],
						UnresolvedOptions -> safeOptions,
						ResolvedOptions -> resolvedOptions,

						(* If there is more than one transaction being made, append an index to the name, otherwise just use the given name. *)
						Name->Which[
							NullQ[nameOption],Null,
							Length[partitionedModelPackets]==1,nameOption,
							True,nameOption<>"_"<>ToString[index]
						],

						(* We group the transactions by order number and supplier *)
						OrderNumber->First[orderNumbers],
						Provider->Link[First[providers],Transactions],

						(* List out the products/models that the user is having shipped to us *)
						Replace[OrderedItems] -> Link[Lookup[inputPackets,Object]],

						(* Get the subset of models/products that will be transferred *)
						Replace[TransferModels] -> Link[Flatten[MapThread[If[MatchQ[#1, None], Nothing, #3] &, {containerOuts, quantities, Lookup[inputPackets,Object]}]]],

						(* Get the destination containers for things that will be transferred *)
						Replace[TransferContainers] -> Link[(Flatten[containerOuts]/.None -> Nothing)],

						Replace[OrderQuantities] -> quantities,
						Replace[QuantitiesReceived] -> ConstantArray[0, Length[quantities]],
						Replace[QuantitiesOutstanding] -> quantities,

						(* Determine how amounts will be populated. *)
						Replace[MassSource]->Flatten[((Map[If[MatchQ[#,GreaterP[0 Gram]],UserSpecified,#1]&,masses])/. Null -> None)],
						Replace[VolumeSource]->Flatten[((Map[If[MatchQ[#,GreaterP[0 Liter]],UserSpecified,#1]&,volumes])/. Null -> None)],
						Replace[CountSource]->Flatten[((Map[If[MatchQ[#,GreaterP[0]],UserSpecified,#1]&,counts])/. Null -> None)],

						(* If any of the amounts are specified, record it here. If an amount is not specified, use 0 in liu of Null *)
						Replace[Mass]->Flatten[Map[If[MatchQ[#,GreaterP[0 Gram]],#1,0Gram]&,masses]],
						Replace[Volume]->Flatten[Map[If[MatchQ[#,GreaterP[0 Liter]],#1,0Liter]&,volumes]],
						Replace[Count]->Flatten[Map[If[MatchQ[#,GreaterP[0]],#1,0]&,counts]],
						ReceivingTolerance->Lookup[resolvedOptions,ReceivingTolerance],
						Replace[ShippedRacks]-> Link/@(rack/.None-> Null),

						(* Get the sterile fields in here *)
						Replace[Sterile]->sterile,
						Replace[SealedContainer]->sealedContainer,
						Replace[AsepticShippingContainerType]->asepticShippingContainerType,
						Replace[AsepticRebaggingContainerType]->asepticRebaggingContainerType,
						RequiresAsepticCertification -> requiresAsepticCertification
					|>
				],
				{
					partitionedModelPackets, partitionedOrderNumberInput, partitionedQuantityInput, partitionedValidatedMass,partitionedValidatedVolume,partitionedServiceInput,
					Range[Length[partitionedModelPackets]],partitionedContainerOut,partitionedValidatedCount, partitionedShippedRacks,
					partitionedSteriles,partitionedSealedContainers,partitionedAsepticShippingContainerTypes,partitionedAsepticRebaggingContainerTypes
				}
			];

			(* Determine what status to give the drop shipped packets. If a date shipped is specified, status is Shipped. Otherwise, status is ordered. *)
			transactionStatuses=If[MatchQ[#,Null|None], Ordered, Shipped]&/@(partitionedExpandedDateShipped[[All,1]]);

			(* create packets that get passed into UploadTransaction.  The key here is that we're adding the fields that UploadTransaction needs to Download from, but that we don't want to Upload *)
			transactionPacketsExtraFields = Map[
				Append[#, {DependentOrder -> Null, Products -> {}, ReceivedItems -> {}, UserCommunications -> {}, Notebook -> $Notebook}]&,
				transactionPackets
			];

			(* Use UploadTransaction to update the Status/StatusLog and shipping information. *)
			statusPackets=UploadTransaction[transactionPacketsExtraFields,transactionStatuses,Upload->False,FastTrack->True,Cache->newCache,
				Timestamp->((partitionedExpandedDateShipped[[All,1]])/.Null|None->Now),
				TrackingNumber -> Map[If[MatchQ[#, Null | Automatic | None], #, ToList[#]] &, partitionedExpandedTrackingNumber[[All, 1]]],
				Shipper -> partitionedExpandedShipper[[All,1]],
				DateExpected -> partitionedExpandedDateExpected[[All,1]],
				Email -> Lookup[resolvedOptions,Email]
			];

			(* Pool the packets together for upload *)
			allPackets=Join[serviceProviderUpdates,transactionPackets,statusPackets];

			(* Upload the packets and return the transaction objects, or return the packets *)
			If[Lookup[safeOptions,Upload],
				Upload[allPackets];Lookup[transactionPackets,Object,{}],
				allPackets
			]],
		$Failed
	];

	outputSpecification/.{optionsRule,testsRule,resultRule,Preview -> Null}
];


(* --- DropShipSamples shipping updates ---- *)

(* Updates an Object[Transaction,Order] object with shipping information *)
DropShipSamples[myTransactions: ListableP[ObjectP[Object[Transaction, DropShipping]]], myOptions: OptionsPattern[]] := Module[{
	listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,validLengths,validLengthTests,transactionPackets,
	modelPacketsByTransaction,newCache,resolvedOptions,resolvedOptionsTests,resolvedOptionsResult,optionsRule,testsRule,
	resultRule,expandedOptions,expandedTransactions,listedTransactions,modelsProductsPacketsByTransaction, productModelPacketsByTransaction,
	inputsByTransaction,misMatchedAmountOptions,amountValidityTests,partitionedQuantityOption
},

	(* Make sure we're working with a list of options and input *)
	listedOptions=ToList[myOptions];
	listedTransactions=ToList[myTransactions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[DropShipSamples,listedOptions,Output->{Result,Tests},AutoCorrect->False],
		{SafeOptions[DropShipSamples,listedOptions,AutoCorrect->False],Null}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];


	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTests,
		ValidInputLengthsQ[DropShipSamples,{listedTransactions},safeOptions,2,Output->{Result,Tests}],
		{ValidInputLengthsQ[DropShipSamples,{listedTransactions},safeOptions,2],Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	{{expandedTransactions},expandedOptions}=ExpandIndexMatchedInputs[DropShipSamples, {listedTransactions}, safeOptions,2];

	(* Download call *)
	{transactionPackets, modelsProductsPacketsByTransaction, productModelPacketsByTransaction} = Transpose[
		Quiet[
			Download[
				listedTransactions,
				{
					Packet[
						OrderedItems,
						OrderQuantities,
						Mass,
						Volume,
						Count,
						MassSource,
						VolumeSource,
						CountSource,
						Shipper,
						TrackingNumbers,
						DateShipped,
						DateExpected,
						Notebook,
						Creator,
						Status,
						UserCommunications,
						SamplesOut,
						ReceivedItems,
						ReceivingTolerance,
						DateCreated,
						Destination
					],
					Packet[OrderedItems[{State, Density,Tablet,SolidUnitWeight}]],
					Packet[OrderedItems[ProductModel][{State, Density,Tablet,SolidUnitWeight}]]
				},
				Date -> Now
			],
			{Download::NotLinkField,Download::FieldDoesntExist}]
	];

	(* Get the models of the transaction, which are either the inputs or are the models of the input products *)
	modelPacketsByTransaction=MapThread[
		Function[{transactionSamples, productModels},
			MapThread[
				If[MatchQ[#2, $Failed],
					#1,
					#2
				]&,
				{transactionSamples, productModels}
			]
		],
		{modelsProductsPacketsByTransaction, productModelPacketsByTransaction}
	];

	(* Update the cache with these downloaded packets *)
	newCache = Flatten[{Lookup[safeOptions,Cache], transactionPackets, modelPacketsByTransaction}];

	(* --- Validate the amount options lengths --- *)

	(* Pull out the models/products of each transaction *)
	inputsByTransaction=Download[Lookup[transactionPackets, OrderedItems], Object];

	(* check that any amount option values that are a list match the number of models across the input transactions.
	This is a special case where the options are indexed to a value inside the input object, so ValidInputLengthsQ doesn't work. *)
	misMatchedAmountOptions = Map[
		If[ListQ[Lookup[expandedOptions,#]] && !SameLengthQ[Lookup[expandedOptions,#], Flatten[inputsByTransaction]],
			#,
			Nothing
		]&, {Mass,Volume,Count,Quantity}
	];

	(* If we are throwing messages, throw messages about amount invalidities *)
	If[!gatherTests&&MemberQ[misMatchedAmountOptions,Volume],
		Message[Error::OptionMustMatchModelsInTransactions, Volume, Length[Flatten[inputsByTransaction]]];Message[Error::InvalidOption,Volume]
	];
	If[!gatherTests&&MemberQ[misMatchedAmountOptions,Mass],
		Message[Error::OptionMustMatchModelsInTransactions, Mass, Length[Flatten[inputsByTransaction]]];Message[Error::InvalidOption,Mass]
	];
	If[!gatherTests&&MemberQ[misMatchedAmountOptions,Count],
		Message[Error::OptionMustMatchModelsInTransactions, Count, Length[Flatten[inputsByTransaction]]];Message[Error::InvalidOption,Count]
	];
	If[!gatherTests&&MemberQ[misMatchedAmountOptions,Quantity],
		Message[Error::OptionMustMatchModelsInTransactions, Quantity, Length[Flatten[inputsByTransaction]]];Message[Error::InvalidOption,Quantity]
	];

	(* If we are collecting tests, assemble tests for amount/quantity validity *)
	amountValidityTests=If[gatherTests,
		Map[
			Test["The "<>ToString[#]<>" option is either single or a list with length matching the number of samples in the transactions:",
				MemberQ[misMatchedAmountOptions,#1],
				False
			]&,{Mass,Volume,Count,Quantity}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!MatchQ[misMatchedAmountOptions,{}],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOptionTests,validLengthTests,amountValidityTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call resolveDropShipSamplesOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions,resolvedOptionsTests}=If[gatherTests,
			resolveDropShipSamplesOptions[transactionPackets, modelsProductsPacketsByTransaction, modelPacketsByTransaction,expandedOptions,Output->{Result,Tests}],
			{resolveDropShipSamplesOptions[transactionPackets, modelsProductsPacketsByTransaction, modelPacketsByTransaction,expandedOptions],Null}
		],
		$Failed,
		{Error::InvalidInput,Error::InvalidOption}
	];
	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		With[{collapsedOptions = CollapseIndexMatchedOptions[DropShipSamples, resolvedOptions, Messages -> False,Ignore->listedOptions]},
			RemoveHiddenOptions[DropShipSamples,ReplaceRule[resolvedOptions,collapsedOptions]]
		],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
	(* Join all exisiting tests generated by helper functions with any additional tests *)
		DeleteCases[Flatten[{safeOptionTests,validLengthTests,resolvedOptionsTests}],Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result]&&!MatchQ[resolvedOptionsResult,$Failed],
		Module[{massOption,volumeOption,amountUpdatePackets,
			partitionedMassOption,partitionedVolumeOption,
			statuses,shippingUpdates,allPackets,nameOption,nameUpdatePackets,countOption,partitionedCountOption,quantityOption
		},

			(* Update the Name if given *)
			nameOption=Name/.resolvedOptions;
			nameUpdatePackets=If[NullQ[nameOption],
				{},
				MapThread[
					<|Object->#1,
					(* If there is more than one transaction being updated, append an index to the name, otherwise just use the given name. *)
						Name->If[Length[myTransactions]==1,
							nameOption,
							nameOption<>"_"<>ToString[#2]
						]
					|>&,{myTransactions,Range[Length[myTransactions]]}
				]
			];

			(* Get the amount-related options *)
			{massOption,volumeOption,countOption,quantityOption}=Lookup[resolvedOptions, {Mass,Volume,Count,Quantity}];

			(* Partition the amount-related options by transaction *)
			{partitionedMassOption,partitionedVolumeOption,partitionedCountOption,partitionedQuantityOption}=Unflatten[#,modelPacketsByTransaction]&/@{massOption,volumeOption,countOption,quantityOption};

			amountUpdatePackets=MapThread[
				Function[{transactionPacket,mass,volume,count,quantity},
					<|
						Object -> Lookup[transactionPacket,Object],

						(* Update the amount. If the option was Automatic, it is resolved to the original value from when the transaction was created. *)
						Replace[Mass]->mass/.None|ProductDocumentation|ExperimentallyMeasure->0Gram,
						Replace[Volume]->volume/.None|ProductDocumentation|ExperimentallyMeasure->0Liter,
						Replace[Count]->count/.None|ProductDocumentation|ExperimentallyMeasure->0,
						Replace[OrderQuantities]->quantity,

					(* Update the amount sources. If the option was Automatic, it is resolved to the original value from when the transaction was created. *)
					(* If an amount is given, the corresponding source is UserSpecified, if Automatic, it is the existing value, if Null it is None, otherwise it is the given option*)
						Replace[MassSource]->Map[If[MatchQ[#,GreaterP[0 Gram]],UserSpecified,#]&,mass],
						Replace[VolumeSource]->Map[If[MatchQ[#,GreaterP[0 Liter]],UserSpecified,#]&,volume],
						Replace[CountSource]->Map[If[MatchQ[#,GreaterP[0]],UserSpecified,#]&,count]
					|>

				],{transactionPackets,partitionedMassOption,partitionedVolumeOption,partitionedCountOption,partitionedQuantityOption}];

			(* If the DateShipped is explicitly specified as None, set the status to Ordered to allow the user a way to clear the DateShipped/Shipped status *)
			statuses=Map[
				If[MatchQ[#,None],
					Ordered,
					Shipped
				]&,Lookup[resolvedOptions,DateShipped]
			];


			(* Use UploadTransaction to update the Status/StatusLog and shipping information. *)
			shippingUpdates=UploadTransaction[listedTransactions,statuses,
				Upload->False,
				FastTrack->True,
				Cache->newCache,
				Timestamp->(Lookup[resolvedOptions,DateShipped]/.Null|None->Now),
				TrackingNumber -> Replace[Lookup[resolvedOptions,TrackingNumber], x_String :> ToList[x], 1],
				Shipper -> Lookup[resolvedOptions,Shipper],
				DateExpected -> Lookup[resolvedOptions,ExpectedDeliveryDate],
				Email -> Lookup[resolvedOptions,Email]
			];

			(* Pool all the update packets *)
			allPackets=Join[nameUpdatePackets,shippingUpdates,amountUpdatePackets];

			(* If uploading, upload and return the transaction objects. Otherwise return the packets. *)
			If[Lookup[safeOptions,Upload],
				DeleteDuplicates[Upload[allPackets]],
				allPackets
			]
		],
		$Failed
	];

	outputSpecification/.{optionsRule,testsRule,resultRule,Preview -> Null}
];




DefineOptions[resolveDropShipSamplesOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];

(* Resolver overload for when DropShipSamples is generating a transaction *)
resolveDropShipSamplesOptions[
	myInputPackets:{PacketP[{Model[Sample],Model[Item],Object[Product]}]..}, (* The packets of the inputs, which can be models or products *)
	myModelPackets:{ListableP[PacketP[{Model[Sample], Model[Container], Model[Part], Model[Sensor], Model[Plumbing], Model[Wiring], Model[Item]}]]..}, (* The packets of the models that correspond to the inputs; each entry is a list if we are dealing with kits *)
	myOrderNumbers:{_String..},
	myContainerOutMaxVolumes:{(Null|VolumeP)...},
	myOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]]:=Module[
	{
		output,listedOutput,collectTestsBoolean,messagesBoolean, allTests,resolvedOptions,
		resolvedMassOption,resolvedVolumeOption,
		volumeInvalidBools,massInvalidBools,volumeValidityTests,
		massValidityTests,samplesThatWillBeTransferred,
		resolvedShipperOption,resolvedDateExpectedOption,resolvedTrackingNumberOption,resolvedDateShippedOption,
		sampleTransferTests,samplesThatMayBeTransferred,measurementTransferTests,invalidDateOrders,invalidDateTests,
		groupedModelsAndAmounts,
		nameUniquenessTests,modelsWithDifferingMass,modelsWithDifferingVolume,
		conflictingMassTest,conflictingVolumeTest,
		email,upload,resolvedEmail,containerOutInvalidContentBools,
		containerContentsValidityTests,containerOutInvalidVolumeBools,containerVolumeValidityTests,containerVolumeValidityWarnings,
		groupedModelsContainers,containerOutInconsistentIndexes,containerOutInconsistentTests,companyOption,productCompanies,
		modelCompanies,productSupplierValid,productCompanyTests,modelCompanyNullTests,productInputPackets,modelInputPackets,
		massAgreementBools,volumeAgreementBools,massDiscrepancyTests,volumeDiscrepancyTests,countAgreementBools,countDiscrepancyTests,
		resolvedCountOption,countInvalidBools,countValidityTests,modelsWithDifferingCount,conflictingCountTest,massCountAgreeBools,
		massCountAgreeTests, productInputMasses, productInputVolumes, productInputCounts,
		kitQs,resolvedQuantity, cache, allInputContainers, rackResult, noRackRules, invalidRackRules, noRacksTest, invalidRacksTest
	},

	(* From resolveDropShipSamplesOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];

	(* Figure out if we're collecting tests *)
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* Sort the input packets into model vs product inputs *)
	modelInputPackets=Cases[myInputPackets,ObjectP[{Model[Sample],Model[Item]}]];
	productInputPackets=Cases[myInputPackets,ObjectP[Object[Product]]];

	(* === Resolve Email === *)

	(* Pull Email and Upload options from the expanded Options *)
	{email, upload, cache} = Lookup[myOptions, {Email, Upload, Cache}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];

	(* indicate if a given entry is a kit *)
	kitQs = MatchQ[#, {PacketP[]..}]& /@ myModelPackets;

	(* get the product input packets *)
	productInputMasses = PickList[Lookup[myOptions,Mass],myInputPackets,ObjectP[Object[Product]]];
	productInputVolumes = PickList[Lookup[myOptions,Volume],myInputPackets,ObjectP[Object[Product]]];
	productInputCounts = PickList[Lookup[myOptions,Count],myInputPackets,ObjectP[Object[Product]]];

	(* --- Check that, if mass/volume/count are specified for a product, it agrees with the product amount (or if it is a kit, that it is not specified at all) --- *)
	massAgreementBools = MapThread[
		Function[{specifiedMass, packet},
			Which[
				(* if Mass was not specified, then this is always True *)
				Not[MassQ[specifiedMass]], True,
				(* if Mass was NOT specified and we are in a kit, this is always False  *)
				MassQ[specifiedMass] && Not[MatchQ[Lookup[packet, KitComponents], {}]], False,
				(* Otherwise check that the specified mass matches the product amount *)
				True, TrueQ[Equal[specifiedMass, Lookup[packet, Amount]]]
			]
		],
		{productInputMasses, productInputPackets}
	];
	volumeAgreementBools = MapThread[
		Function[{specifiedVolume,packet},
			Which[
				(* if Volume was not specified, then this is always True *)
				Not[VolumeQ[specifiedVolume]], True,
				(* if Volume was NOT specified and we are in a kit, this is always False  *)
				VolumeQ[specifiedVolume] && Not[MatchQ[Lookup[packet, KitComponents], {}]], False,
				(* Otherwise check that the specified volume matches the product amount *)
				True, TrueQ[Equal[specifiedVolume, Lookup[packet, Amount]]]
			]
		],
		{productInputVolumes, productInputPackets}
	];
	countAgreementBools = MapThread[
		Function[{specifiedCount,packet},
			Which[
				(* if Count was not specified, then this is always True *)
				Not[IntegerQ[specifiedCount]], True,
				(* if Count was NOT specified and we are in a kit, this is always False *)
				IntegerQ[specifiedCount] && Not[MatchQ[Lookup[packet, KitComponents], {}]], False,
				(* Otherwise check that the specified count matches the product amount *)
				True, TrueQ[Equal[specifiedCount, Lookup[packet, CountPerSample]]]
			]
		],
		{productInputCounts, productInputPackets}
	];

	(* If we are throwing messages, throw messages about amount discrepancies *)
	If[messagesBoolean&&MemberQ[massAgreementBools,False],
		Message[Error::MassDiscrepancy,
			PickList[Lookup[productInputPackets,Object],massAgreementBools,False],
			PickList[productInputMasses,massAgreementBools,False]
		];Message[Error::InvalidOption,Mass]
	];
	If[messagesBoolean&&MemberQ[volumeAgreementBools,False],
		Message[Error::VolumeDiscrepancy,
			PickList[Lookup[productInputPackets,Object],volumeAgreementBools,False],
			PickList[productInputVolumes,volumeAgreementBools,False]
		];Message[Error::InvalidOption,Volume]
	];
	If[messagesBoolean&&MemberQ[countAgreementBools,False],
		Message[Error::CountDiscrepancy,
			PickList[Lookup[productInputPackets,Object],countAgreementBools,False],
			PickList[productInputCounts,countAgreementBools,False]
		];Message[Error::InvalidOption,Count]
	];

	(* If we are collecting tests, assemble tests for amount discrepancies *)
	massDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If mass is specified for "<>ToString[#2]<>" it agrees with the product amount (or Null for kits):",
				#1,
				True
			]&,
			{massAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];
	volumeDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If volume is specified for "<>ToString[#2]<>" it agrees with the product amount (or Null for kits):",
				#1,
				True
			]&,
			{volumeAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];
	countDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If count is specified for "<>ToString[#2]<>" it agrees with the product count (or Null for kits):",
				#1,
				True
			]&,
			{countAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];

	(* ---  Resolve any Automatic mass options --- *)
	resolvedMassOption=MapThread[
		Function[{countOption,massOption,inputPacket},
			Which[
				(* Products automatically resolve to the product amount if it is populated *)
				MatchQ[massOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Object[Product]]] && MassQ[Lookup[inputPacket,Amount,Null]],
				Lookup[inputPacket,Amount],


				(* Tablet models automatically resolve to a Mass if Count and SolidUnitWeight are known *)
				MatchQ[massOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Model[Sample]]] && TrueQ[Lookup[inputPacket,Tablet,Null]] && IntegerQ[countOption] && MatchQ[Lookup[inputPacket,SolidUnitWeight,Null],MassP],
				Lookup[inputPacket,SolidUnitWeight]*countOption,

				(* Solid NonSelfContainedSampleTypes automatically resolve to ExperimentallyMeasure *)
				MatchQ[massOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Model[Sample]]] && MatchQ[Lookup[inputPacket,State],Solid],
				ExperimentallyMeasure,

				(* All other Automatic cases resolve to None *)
				MatchQ[massOption,Automatic|Null],
				None,

				(* All non-Automatic cases are kept as is *)
				True,
				massOption
			]
		],
		{Lookup[myOptions,Count],Lookup[myOptions,Mass],myInputPackets}
	];

	(* --- Resolve any Automatic volume options --- *)
	resolvedVolumeOption=MapThread[
		Switch[{#1,Lookup[#2,Object],Lookup[#2,State],Lookup[#2,Amount]},

			(* Products automatically resolve to the product amount if it is a volume *)
			{Automatic|Null, ObjectP[Object[Product]], _, _?VolumeQ},Lookup[#2,Amount],

			(* Liquid NonSelfContainedSampleTypes automatically resolve to ExperimentallyMeasure *)
			{Automatic,ObjectP[Model[Sample]],Liquid,_},ExperimentallyMeasure,

			(* All other Automatic cases resolve to None *)
			{Automatic|Null,_,_,_},None,

			(* All non-Automatic cases are kept as is *)
			_,#1
		]&, {Lookup[myOptions,Volume],myInputPackets}
	];

	(* ---  Resolve any Automatic count options --- *)
	resolvedCountOption=MapThread[
		Function[{countOption,massOption,inputPacket},
		Which[
			(* Products automatically resolve to the product count if it is populated *)
			MatchQ[countOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Object[Product]]] && IntegerQ[Lookup[inputPacket,CountPerSample,Null]],
			Lookup[inputPacket,CountPerSample],


			(* Tablet models automatically resolve to a number if Mass and SolidUnitWeight are known *)
			MatchQ[countOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Model[Sample]]] && TrueQ[Lookup[inputPacket,Tablet,Null]] && MatchQ[massOption,MassP] && MatchQ[Lookup[inputPacket,SolidUnitWeight,Null],MassP],
			Round[massOption/Lookup[inputPacket,SolidUnitWeight]],

			(* Tablet models automatically resolve to ExperimentallyMeasure if Mass and SolidUnitWeight are not known*)
			MatchQ[countOption,Automatic|Null] && MatchQ[inputPacket,ObjectP[Model[Sample]]] && TrueQ[Lookup[inputPacket,Tablet,Null]],
			ExperimentallyMeasure,

			(* All other Automatic cases resolve to None *)
			MatchQ[countOption,Automatic|Null],
			None,

			(* All non-Automatic cases are kept as is *)
			True,
			countOption
		]], {Lookup[myOptions,Count],Lookup[myOptions,Mass],myInputPackets}
	];

	(* --- If Mass and Count are both specified, make sure that they are in agreement if tablet weight is known --- *)
	massCountAgreeBools=MapThread[
		Function[{mass,count,modelPackets},
			(* note that if modelPackets is a list of models, then we're dealing with a kit, and so that will just always be True *)
			If[MassQ[mass]&&IntegerQ[count]&&MatchQ[modelPackets, PacketP[]] && MassQ[Lookup[modelPackets, SolidUnitWeight]],
				Equal[Round[mass],(count*Lookup[modelPackets, SolidUnitWeight])],
				True
			]
		],
		{Lookup[myOptions,Mass],Lookup[myOptions,Count],myModelPackets}
	];

	(* If we are throwing messages, throw messages about mass/count disagreement *)
	If[messagesBoolean&&MemberQ[massCountAgreeBools,False],
		Message[Error::MassCountDisagree,PickList[Lookup[myInputPackets,Object],massCountAgreeBools,False]];Message[Error::InvalidOption,Mass];Message[Error::InvalidOption,Count]
	];

	(* If we are collecting tests, assemble tests for mass/count disagreement *)
	massCountAgreeTests=If[collectTestsBoolean,
		MapThread[
			Test["If Mass and count are both specified, they agree based on the tablet weight for "<>ToString[#2]<>":",
				#1,
				True
			]&,{massCountAgreeBools,Lookup[myInputPackets,Object]}]
	];

	(* --- Check that, if mass/volume are specified, they are allowed for the type. --- *)

	(* Check if amount is specified for any items *)
	(* for all of these, if we are working with kits, then we're fine and are automatically OK because we already checked above whether we were allowed to set this or not *)
	volumeInvalidBools=MapThread[
		Function[{volume,modelPackets, kitQ},
			MatchQ[volume, Except[Null|None]]&&Not[kitQ]&&MatchQ[Lookup[modelPackets, Type], TypeP[SelfContainedModelTypes]]],
		{resolvedVolumeOption,myModelPackets, kitQs}
	];
	massInvalidBools=MapThread[
		Function[{mass, modelPackets, kitQ},
			MatchQ[mass, Except[Null|None]]&&Not[kitQ]&&MatchQ[Lookup[modelPackets, Type], TypeP[SelfContainedModelTypes]]],
		{resolvedMassOption,myModelPackets, kitQs}
	];
	countInvalidBools=MapThread[
		Function[{count, modelPackets, kitQ},
			MatchQ[count, Except[Null|None]]&&Not[kitQ]&&!TrueQ[Lookup[modelPackets, Tablet]]],
		{resolvedCountOption,myModelPackets, kitQs}
	];

	(* If we are throwing messages, throw messages about amount invalidities *)
	If[messagesBoolean&&MemberQ[volumeInvalidBools,True],
		Message[Error::VolumeNotRequired,PickList[Lookup[myInputPackets,Object],volumeInvalidBools]];Message[Error::InvalidOption,Volume]
	];
	If[messagesBoolean&&MemberQ[massInvalidBools,True],
		Message[Error::MassNotRequired,PickList[Lookup[myInputPackets,Object],massInvalidBools]];Message[Error::InvalidOption,Mass]
	];
	If[messagesBoolean&&MemberQ[countInvalidBools,True],
		Message[Error::CountNotRequired,PickList[Lookup[myInputPackets,Object],countInvalidBools]];Message[Error::InvalidOption,Count]
	];

	(* If we are collecting tests, assemble tests for amount validity *)
	volumeValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Volume is legally specified for "<>ToString[#2]<>". (Samples may have volume specified, items may not.):",
				#1,
				False
			]&,{volumeInvalidBools,Lookup[myInputPackets,Object]}]
	];
	massValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Mass is legally specified for "<>ToString[#2]<>". (Samples may have mass specified, items may not.):",
				#1,
				False
			]&,{massInvalidBools,Lookup[myInputPackets,Object]}]
	];
	countValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Count is legally specified for "<>ToString[#2]<>". (Tablets may have count specified, items and non-tablet samples may not.):",
				#1,
				False
			]&,{countInvalidBools,Lookup[myInputPackets,Object]}]
	];

	(* --- For any sample (not item) models with a given volume but are liquid and do not have density, give a warning that they may still be transferred if they arrive in a non-liquid-level parameterized container --- *)
	(* Find any sample models that are liquid and have Volume specified as an amount, but that do not have density *)
	(* also if we're dealing with a kit then never transfer *)
	samplesThatWillBeTransferred=MapThread[
		If[MatchQ[#1,GreaterP[0 Milliliter]]&&Not[#3]&&MatchQ[Lookup[#2,State],Liquid]&&MatchQ[Lookup[#2,Density],Null]&&MatchQ[Lookup[#2,Object], ObjectP[Model[Sample]]],
			Lookup[#2,Object],
			Nothing
		]&,
		{resolvedVolumeOption,myModelPackets, kitQs}
	];

	(* If we are giving messages, throw a warning that the sample may need to be transferred if it is not in a parameterized container *)
	If[messagesBoolean&&!MatchQ[samplesThatWillBeTransferred,{}],Message[Warning::SampleMayBeTransferred,samplesThatWillBeTransferred]];

	(* If we are giving tests, generate warning tests that the sample may need to be transferred if it is not in a parameterized container *)
	sampleTransferTests=If[collectTestsBoolean,
		Map[
			Warning["For "<>ToString[#1]<>", if volume is specified as an amount, the density is known. (If the sample arrives in a container that is not parameterized for liquid level detection, your sample will be transferred to another container upon arrival. If this is not desired, please populate the Density of the models):",
				MemberQ[samplesThatWillBeTransferred,#],
				False
			]&,Lookup[myInputPackets,Object]
		]
	];

	(* --- For any sample (not item) models that have Mass/Volume->ExperimentallyMeasure, give a warning that the sample may be transferred --- *)
	(* find any sample models that have mass or volume specified as ExperimentallyMeasure *)
	(* also if we're dealing with a kit then never transfer *)
	samplesThatMayBeTransferred=MapThread[
		Function[{resolvedMass, resolvedVolume, packet, kitQ},
			If[Or[MatchQ[resolvedMass,ExperimentallyMeasure],MatchQ[resolvedVolume,ExperimentallyMeasure]]&&Not[kitQ]&&MatchQ[Lookup[packet,Object],ObjectP[Model[Sample]]],
				Lookup[packet,Object],
				Nothing
			]
		],
		{resolvedMassOption,resolvedVolumeOption,myModelPackets, kitQs}
	];

	(* If we are giving messages, throw a warning that the sample may need to be transferred for measurement *)
	If[messagesBoolean&&!MatchQ[samplesThatMayBeTransferred,{}],Message[Warning::MeasurementMayRequireTransfer,samplesThatMayBeTransferred]];

	(* If we are giving tests, generate warning tests that the sample may need to be transferred for measurement *)
	measurementTransferTests=If[collectTestsBoolean,
		Map[
			Warning[ToString[#1]<>", may be transferred to another container in order to experimentally determine the amount. (If this is not desired, please specify an amount or specify ProductDocumentation to indicate that the amount should be found on the documents that ship with the sample.):",
				MemberQ[samplesThatMayBeTransferred,#],
				False
			]&,
			Lookup[myInputPackets,Object]
		]
	];


	(* --- Container Out --- *)

	(* If the thing being shipped is an item or a kit and container out is specified, mark as invalid *)
	containerOutInvalidContentBools=MapThread[
		Function[{packet,containerOut, kitQ},
			(kitQ || MatchQ[Lookup[packet, Type], TypeP[SelfContainedModelTypes]]) && MatchQ[containerOut,ObjectP[Model[Container]]]
		],
		{myModelPackets,Lookup[myOptions,ContainerOut], kitQs}
	];

	(* If we are throwing messages, throw message about container out not being allowed for items *)
	If[messagesBoolean&&MemberQ[containerOutInvalidContentBools,True],
		Message[Error::ShippingOptionNotRequired,ContainerOut,PickList[Lookup[myInputPackets,Object],containerOutInvalidContentBools]]
	];

	(* If we are collecting tests, assemble test for container out being allowed only for samples *)
	containerContentsValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["ContainerOut is legally specified for "<>ToString[#2]<>". (Samples may have ContainerOut specified, items may not.):",
				#1,
				False
			]&,{containerOutInvalidContentBools,Lookup[myInputPackets,Object]}]
	];

	(* Validate that the container out is big enough *)
	containerOutInvalidVolumeBools=MapThread[
		Function[{packet,containerOut,volume,containerMaxVolume, kitQ},
			Which[

				(* If the object is an item or a kit, we already gave an error, so don't error again here *)
				kitQ || MatchQ[Lookup[packet, Type],TypeP[SelfContainedModelTypes]],False,

				(* If container out is not specified, valid *)
				MatchQ[containerOut,Except[ObjectP[Model[Container]]]],False,

				(* If volume is not specified, indeterminant *)
				MatchQ[volume,Except[VolumeP]],Null,

				(* If volume is specified and volume > container volume, invalid *)
				(volume > containerMaxVolume),True,

				(* If volume is specified and volume < container volume, valid *)
				(volume <= containerMaxVolume),False,

				(*Otherwise, valid *)
				True, False
			]
		],{myModelPackets,Lookup[myOptions,ContainerOut],resolvedVolumeOption,myContainerOutMaxVolumes, kitQs}
	];

	(* If we are throwing messages, throw message about container out being too small *)
	If[messagesBoolean&&MemberQ[containerOutInvalidVolumeBools,True],
		Message[Error::VolumeExceedsContainerOut,PickList[Lookup[myOptions,ContainerOut],containerOutInvalidVolumeBools],PickList[resolvedVolumeOption,containerOutInvalidVolumeBools],PickList[Lookup[myInputPackets,Object],containerOutInvalidVolumeBools]]
	];

	(* If we are throwing messages, throw message about not being able to validate that the container is large enough *)
	If[messagesBoolean&&MemberQ[containerOutInvalidVolumeBools,Null],
		Message[Warning::ContainerOutNotValidated,PickList[Lookup[myInputPackets,Object],containerOutInvalidVolumeBools,Null],PickList[Lookup[myOptions,ContainerOut],containerOutInvalidVolumeBools,Null]]
	];

	(* If we are collecting tests, assemble tests for container out being too small *)
	containerVolumeValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Sample volume does not exceed ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|Null
			]&,
			{containerOutInvalidVolumeBools,Lookup[myInputPackets,Object]}
		]
	];

	(* If we are collecting tests, assemble tests for container out being too small *)
	containerVolumeValidityWarnings=If[collectTestsBoolean,
		MapThread[
			Warning["Sample volume is known and crosschecked with ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|True
			]&,
			{containerOutInvalidVolumeBools,Lookup[myInputPackets,Object]}
		]
	];

	(* Group each model/product-containerOut pair by model/product *)
	groupedModelsContainers = GatherBy[Transpose[{Lookup[myInputPackets,Object], Download[(Lookup[myOptions,ContainerOut]/.None->Null),Object]}], #[[1]] &];

	(* If multiple of the same model/product are being shipped, make sure that they don't point to differing containerOuts, since the samples are indistinguishable upon arrival *)
	containerOutInconsistentIndexes = Flatten[
		MapIndexed[
			If[Length[DeleteDuplicates[#[[All, 2]]]] > 1,
				#2,
				Nothing
			]&,
			groupedModelsContainers
		]
	];

	(* If we are throwing messages, throw message about container out being inconsistent across models *)
	If[messagesBoolean&&!MatchQ[containerOutInconsistentIndexes,{}],
		Message[Error::ContainerOutInconsistent,
			DeleteDuplicates[Flatten[groupedModelsContainers[[containerOutInconsistentIndexes]][[All, All, 1]]]],
			groupedModelsContainers[[containerOutInconsistentIndexes]][[All,All,2]]
		]
	];

	(* If we are collecting tests, test that container out is inconsistent across models *)
	containerOutInconsistentTests=If[collectTestsBoolean,
		Map[
			Test["ContainerOut is consistent across all instances of the product "<>ToString[#[[1,1]]]<>":",
				Length[DeleteDuplicates[#[[All, 2]]]],
				1
			]&,
			groupedModelsContainers
		]
	];

	(* Only throw the invalid ContainerOut option error once regardless of how many ways it is invalid *)
	If[messagesBoolean&&Or[MemberQ[containerOutInvalidContentBools,True],MemberQ[containerOutInvalidVolumeBools,True],!MatchQ[containerOutInconsistentIndexes,{}]],
		Message[Error::InvalidOption,ContainerOut]
	];

	(* --- Resolve any Automatic shipping options to None (The default is Automatic instead of None to work with the transaction overload as well.) --- *)
	resolvedShipperOption=If[MatchQ[#,Automatic],None,#]&/@Lookup[myOptions,Shipper];
	resolvedDateExpectedOption=If[MatchQ[#,Automatic],None,#]&/@Lookup[myOptions,ExpectedDeliveryDate];
	resolvedTrackingNumberOption=If[MatchQ[#,Automatic],None,#]&/@Lookup[myOptions,TrackingNumber];
	resolvedDateShippedOption=If[MatchQ[#,Automatic],None,#]&/@Lookup[myOptions,DateShipped];


	(* --- If date shipped and expected delivery date are both specified, make sure the shipment date is earlier than the delivery date --- *)
	(* Find any models that have an earlier date expected than date shipped *)
	invalidDateOrders =  PickList[Lookup[myInputPackets,Object], MapThread[Greater[#1, #2] &, {resolvedDateShippedOption, resolvedDateExpectedOption}]];

	(* If we are giving messages, throw that dates are invalid *)
	If[messagesBoolean&&!MatchQ[invalidDateOrders, {}],Message[Error::InvalidDates, invalidDateOrders];Message[Error::InvalidOption,DateShipped];Message[Error::InvalidOption,ExpectedDeliveryDate]];

	(* If we are giving tests, generate tests that dates are invalid *)
	invalidDateTests=If[collectTestsBoolean,
		Map[
			Test["ExpectedDeliveryDate is later than DateShipped (if both are specified) for "<>ToString[#],
				MemberQ[invalidDateOrders,#],
				False
			]&,Lookup[myInputPackets,Object]]
	];

	(* --- Validate the Provider ---*)

	(* Pull out the company option *)
	companyOption=Lookup[myOptions,Provider];

	(* Filter the company input by model vs product input *)
	productCompanies=PickList[companyOption,myInputPackets,ObjectP[Object[Product]]];
	modelCompanies=PickList[companyOption,myInputPackets,ObjectP[{Model[Sample],Model[Item]}]];

	(* For product inputs, check that the specified company is the supplier of the product or is Null *)
	productSupplierValid=MapThread[NullQ[#2] || SameObjectQ[Lookup[#1, Supplier], #2] &, {productInputPackets, productCompanies}];

	(* If we are throwing messages, give a message if any of the input companies do not match the product supplier or Null *)
	If[!MemberQ[output,Tests]&&!MatchQ[productSupplierValid,{True...}],
		Message[Error::ProductSupplierConflict,Download[PickList[productInputPackets,productSupplierValid,False],Object],PickList[productCompanies,productSupplierValid,False],PickList[Download[Lookup[productInputPackets, Supplier,{}],Object],productSupplierValid,False]];
		Message[Error::InvalidOption,Download[PickList[productInputPackets,productSupplierValid,False],Object]]
	];

	(* Collect tests for the input companies matching the product supplier or Null *)
	productCompanyTests=MapThread[
		Test["The specified company, "<>ToString[#2]<>", is Null or is the product's supplier, "<>ToString[Download[Lookup[#1,Supplier,Null],Object]]<>":",
			NullQ[#2] || SameObjectQ[Lookup[#1,Supplier], #2],
			True
		]&,
		{productInputPackets,productCompanies}
	];

	(* Company is required input for any models. It must be a Service, not a Supplier. If we are throwing messages, give a message if any input model samples was not specified with a company service *)
	If[
		!MemberQ[output,Tests]&&MemberQ[modelCompanies,Null|ObjectP[Object[Company,Supplier]]],
		Module[{},
			Message[Error::CompanyRequiredForModelInputs,PickList[Lookup[modelInputPackets,Object,{}],modelCompanies,Null|ObjectP[Object[Company,Supplier]]]];
			Message[Error::InvalidOption,PickList[Lookup[modelInputPackets,Object,{}],modelCompanies,Null|ObjectP[Object[Company,Supplier]]]]
		]
	];

	(* Collect tests for checking that input model samples are specified with a company *)
	modelCompanyNullTests=MapThread[
		Test["The specified company is a Object[Company,Service] for the model sample input "<>ToString[#2],
			MatchQ[#1,ObjectP[Object[Company,Service]]],
			True
		]&,
		{modelCompanies,Lookup[modelInputPackets,Object,{}]}
	];


	(* --- Make sure that if the user specified an amount, they did not specify different amounts for the same model.
		This isn't possible if they use the quantity input to specify more than one model, but if they enter the same model twice in the model input, then it is possible for them to specify different amounts.
		This would be problematic for ops during receiving since we don't know which model goes with which amount, especially if they arrive in different shipments. --- *)
	(* Group each unique model with the specified amounts *)
	groupedModelsAndAmounts = GatherBy[Transpose[{Lookup[myInputPackets, Object], resolvedMassOption, resolvedVolumeOption, resolvedCountOption}], First];

	(* Get the models where different amounts were specified *)
	modelsWithDifferingMass = PickList[First /@ groupedModelsAndAmounts[[All, All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, 2]], Except[1]];
	modelsWithDifferingVolume = PickList[First /@ groupedModelsAndAmounts[[All, All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, 3]], Except[1]];
	modelsWithDifferingCount = PickList[First /@ groupedModelsAndAmounts[[All, All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, 4]], Except[1]];

	(* If we are giving messages, give a message if any models have conflicting amounts *)
	If[messagesBoolean&&!MatchQ[modelsWithDifferingMass, {}],Message[Error::ModelsHaveConflictingMass, modelsWithDifferingMass];Message[Error::InvalidOption,Mass]];
	If[messagesBoolean&&!MatchQ[modelsWithDifferingVolume, {}],Message[Error::ModelsHaveConflictingVolume, modelsWithDifferingVolume];Message[Error::InvalidOption,Volume]];
	If[messagesBoolean&&!MatchQ[modelsWithDifferingCount, {}],Message[Error::ModelsHaveConflictingCount, modelsWithDifferingCount];Message[Error::InvalidOption,Count]];

	(* If we are giving tests, generate tests indicating if inputs have conflicting amounts *)
	conflictingMassTest=If[collectTestsBoolean,
		Map[
			Test[ToString[#1]<>" is not specified more than once with conflicting mass. (Please use the quantity input to specify that multiple samples of the same model are being shipped, or specify the same Mass option for identical models.):",
				MemberQ[modelsWithDifferingMass,#],
				False
			]&,Lookup[myInputPackets,Object]]
	];

	conflictingVolumeTest=If[collectTestsBoolean,
		Map[
			Test[ToString[#1]<>" is not specified more than once with conflicting volume. (Please use the quantity input to specify that multiple samples of the same model are being shipped, or specify the same Volume option for identical models.):",
				MemberQ[modelsWithDifferingVolume,#],
				False
			]&,Lookup[myInputPackets,Object]]
	];

	conflictingCountTest=If[collectTestsBoolean,
		Map[
			Test[ToString[#1]<>" is not specified more than once with conflicting count. (Please use the quantity input to specify that multiple samples of the same model are being shipped, or specify the same Count option for identical models.):",
				MemberQ[modelsWithDifferingCount,#],
				False
			]&,Lookup[myInputPackets,Object]]
	];

	(* --- Validate the Name option --- *)
	nameUniquenessTests=If[!NullQ[Lookup[myOptions,Name]],
		Module[{numberOfTransactions,name,expandedNames,nameInvalidBools},

			(* We need to see how many transaction packets will be made to see what the names will be. Transactions that have different order numbers, providers, or shipping info are split up   *)
			numberOfTransactions = Length[Gather[Transpose[{myOrderNumbers,	companyOption, resolvedDateExpectedOption, resolvedTrackingNumberOption, (resolvedShipperOption /. x : ObjectP[] -> Download[x, Object]), resolvedDateShippedOption}]]];

			(* Get the name option *)
			name=Lookup[myOptions,Name];

			(* Expand the name if we are making multiple transaction objects *)
			expandedNames=If[numberOfTransactions==1,
				ToList[name],
				Map[name<>"_"<>ToString[#]&,Range[numberOfTransactions]]
			];

			(* Check if the name is used already *)
			nameInvalidBools=DatabaseMemberQ[Append[Object[Transaction, DropShipping], #] & /@ expandedNames];

			(* If we are giving messages, throw a message if the name is not unique *)
			If[messagesBoolean&&MemberQ[nameInvalidBools,True],
				Message[Error::NonUniqueName,PickList[expandedNames,nameInvalidBools],Object[Transaction,DropShipping]];Message[Error::InvalidOption,Name]
			];

			(* If we are collecting tests, assemble tests for name uniquness *)
			If[collectTestsBoolean,
				MapThread[
					Test["The name "<>ToString[#2]<>" is unique for Object[Transaction, DropShipping]:",
						#1,
						False
					]&,{nameInvalidBools,expandedNames}]
			]
		]
	];

	(* -- Rack error checking -- *)


	allInputContainers = Map[
		Which[
			(* if it was a product use the DefaultContainerModel or DefaultContainerModel of the kit components *)
			MatchQ[#, ObjectP[Object[Product]]],
			Download[
				FirstCase[
					Flatten[{
						Download[#, {DefaultContainerModel}, Cache -> cache],
						Lookup[Replace[Download[#, KitComponents,  Cache -> cache],Null -> {}], DefaultContainerModel, {}]
					}],
					ObjectP[],
					Null
				],
				Object
			],

			(* if it was a model sample, we do not know what the product is, or what container it is in so we cannot check at this time *)
			MatchQ[#, ObjectP[Model[Sample]]],
			Null,

			True,
			Null
		]&,
		Lookup[myInputPackets, Object]
	];

	rackResult = If[MatchQ[allInputContainers, {Null...}],
		{{Rack -> Null, Container -> Null, InvalidRack -> Null, NoRacks -> Null}},
		Module[{modelContainerTuples, dimensions, footprints, selfStandings},

			{dimensions, footprints, selfStandings} = Transpose[Quiet[Download[Cases[allInputContainers, ObjectP[]], {Dimensions, Footprint, SelfStanding}, Cache -> cache], Download::FieldDoesntExist]];
			modelContainerTuples = DeleteDuplicatesBy[Transpose[{Cases[Download[allInputContainers, Object], ObjectP[]], dimensions, footprints, selfStandings, PickList[(Lookup[myOptions, ShippedRack]/.None-> Null),allInputContainers, ObjectP[]]}], First];

			Map[
				Function[
					modelContainerTuple,
					Which[
						(* if there is no container to check or it can stand on its own safe return *)
						Or[MatchQ[modelContainerTuple[[1]], Except[ObjectP[Model[Container]]]], MatchQ[modelContainerTuple[[4]], True]],
						{Rack -> Null, Container -> Null, InvalidRack -> Null, NoRacks -> Null},

						(* if the container is not self standing and there are no dimensions we cant proceed but also cant error *)
						MatchQ[modelContainerTuple[[2]], (Null|{})],
						If[MatchQ[modelContainerTuple[[5]], ObjectP[]],
							{Rack -> Download[modelContainerTuple[[5]], Object], Container -> modelContainerTuple[[1]], InvalidRack -> Null, NoRacks -> Null},
							{Rack -> Null, Container -> modelContainerTuple[[1]], InvalidRack -> Null, NoRacks -> Null}
						],

						(* do the checks *)
						True,
						Module[{containerToCheck, modelDims, modelFootprint, selfStanding, rack,maxWidth, minWidth, maxDepth, minDepth, acceptableDimensionsPattern, goodRackBool},

							(* determine the dimensions acceptable tolerance *)
							{containerToCheck, modelDims, modelFootprint, selfStanding, rack} = modelContainerTuple;

							{maxWidth, minWidth, maxDepth, minDepth} = Lookup[
								DimensionsWithTolerance[
									modelDims,
									$PositionUpperTolerance,
									$PositionLowerTolerance
								],
								{MaxWidth, MinWidth, MaxLength, MinLength}
							];

							acceptableDimensionsPattern = Alternatives[
								{modelFootprint, _,_},
								{_, RangeP[minDepth, maxDepth], RangeP[minWidth,maxWidth]},
								{_, RangeP[minWidth,maxWidth], RangeP[minDepth, maxDepth]}
							];

							If[MatchQ[rack, ObjectP[Model[Container, Rack]]],
								(* 1. verify the current rack *)
								goodRackBool = MatchQ[Length[Cases[Lookup[Download[rack, Positions, Cache -> cache], {Footprint, MaxDepth, MaxWidth}], acceptableDimensionsPattern]], GreaterP[0]];
								If[MatchQ[goodRackBool, True],
									{Rack -> Download[rack, Object], Container -> containerToCheck, InvalidRack -> Null, NoRacks -> Null},
									{Rack -> Download[rack, Object], Container -> containerToCheck, InvalidRack -> True, NoRacks -> Null}
								],

								(* 2. search for another rack that is in lab already *)
								Module[{possibleRackPositions, matchingPosition},
									possibleRackPositions = rackFootprintsAndDimensions[];

									matchingPosition = SelectFirst[possibleRackPositions, MatchQ[{#[[2]], #[[3,1]], #[[3,2]]}, acceptableDimensionsPattern]&, {}];
									If[MatchQ[matchingPosition, {}],
										{Rack -> Null, Container -> containerToCheck, InvalidRack -> Null, NoRacks -> True},
										{Rack -> Null, Container -> containerToCheck, InvalidRack -> Null, NoRacks -> Null}
									]
								]
							]
						]
					]
				],
				modelContainerTuples
			]
		]
	];


	(* entries where a rack was required but the provided value was Null *)
	invalidRackRules = Select[rackResult, MatchQ[Lookup[#, InvalidRack], True]&];
	(* racks that were provided but don't actually work *)
	noRackRules = Select[rackResult, MatchQ[Lookup[#, NoRacks], True]&];


	If[Length[invalidRackRules]>0&&messagesBoolean,
		Message[Error::IncompatibleProvidedRackModel, Lookup[invalidRackRules, Rack], Lookup[invalidRackRules, Container]];
		Message[Error::InvalidOption,ShippedRack];
	];

	If[Length[noRackRules]>0&&messagesBoolean,
		Message[Error::NoCompatibleRack, Lookup[noRackRules, {Rack, Container}]];
		Message[Error::InvalidOption,ShippedRack];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidRacksTest=If[collectTestsBoolean,
		If[Length[invalidRackRules]>0,
			Test["The provided ShippedRack models are capable of supporting the Model[Container] they are matched with:",True,False],
			Test["The provided ShippedRack models are capable of supporting the Model[Container] they are matched with:",True,True]
		],
		Nothing
	];

	noRacksTest=If[collectTestsBoolean,
		If[Length[noRackRules]>0,
			Test["An appropriate Model[Container, Rack] is able to be found for ordered container models that are not capable of standing unsupported:",True,False],
			Test["An appropriate Model[Container, Rack] is able to be found for ordered container models that are not capable of standing unsupported:",True,True]
		],
		Nothing
	];

	(* Resolve quantity to 1 if it is automatic *)
	resolvedQuantity = Lookup[myOptions,Quantity]/.Automatic->1;

	(* Pool all the tests into one list *)
	allTests=DeleteCases[Flatten[{volumeValidityTests,massValidityTests,sampleTransferTests,
		measurementTransferTests,invalidDateTests,conflictingMassTest,conflictingVolumeTest,
		nameUniquenessTests,containerContentsValidityTests,containerVolumeValidityTests,containerVolumeValidityWarnings,
		containerOutInconsistentTests,massDiscrepancyTests,volumeDiscrepancyTests,
		countValidityTests,conflictingCountTest, countDiscrepancyTests,massCountAgreeTests,modelCompanyNullTests,productCompanyTests, noRacksTest, invalidRacksTest}],Null];

	(* Assemble the resolved options *)
	resolvedOptions=ReplaceRule[myOptions,
		{
			Mass -> resolvedMassOption,
			Volume -> resolvedVolumeOption,
			Count -> resolvedCountOption,
			Shipper -> resolvedShipperOption,
			ExpectedDeliveryDate -> resolvedDateExpectedOption,
			TrackingNumber -> resolvedTrackingNumberOption,
			DateShipped-> resolvedDateShippedOption,
			Email -> resolvedEmail,
			Quantity->resolvedQuantity
		}
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];

(* Resolver for when updating a transaction *)
resolveDropShipSamplesOptions[
	myTransactionPackets: {PacketP[Object[Transaction, DropShipping]] ..},
	myTransactionModelsProductsPackets:{{PacketP[{Model[Sample],Model[Item],Object[Product]}]..}..},
	(* the Null case is for the kit case; we don't do any real checks here anyway for the kits and Nulls work way better here *)
	myTransactionModelPackets:{{(Null|PacketP[{Model[Sample],Model[Item]}])..}..},
	myOptions:{(_Rule|_RuleDelayed)..},
	ops:OptionsPattern[]]:=Module[
	{
		output,listedOutput,collectTestsBoolean,messagesBoolean,inputsByTransaction,
		expandedMassOption,expandedVolumeOption,
		volumeInvalidBools,massInvalidBools,volumeValidityTests,
		massValidityTests,samplesThatWillBeTransferred,
		sampleTransferTests,samplesThatMayBeTransferred,measurementTransferTests,
		partitionedMassOption,partitionedVolumeOption,
		resolvedShipperOption,resolvedExpectedDeliveryDateOption,resolvedTrackingNumberOption,resolvedDateShippedOption,
		invalidDateOrders,invalidDateTests,allTests,resolvedOptions,resolvedMassOption,resolvedVolumeOption,
		nameUniquenessTests,modelsWithConflictingMassByTransaction,
		modelsWithConflictingVolumeByTransaction,
		conflictingMassTests,conflictingVolumeTests,email,upload,resolvedEmail,
		productInputPackets,massAgreementBools,volumeAgreementBools,massDiscrepancyTests,volumeDiscrepancyTests,resolvedProviderOption,expandedCountOption,
		countInvalidBools,countValidityTests,countAgreementBools,countDiscrepancyTests,resolvedCountOption,partitionedCountOption,
		modelsWithConflictingCountByTransaction,conflictingCountTests, kitQs, flatModelPackets, flatKitQs,productInputMasses,
		productInputVolumes, productInputCounts,  prodKitQs,
		expandedQuantityOption,resolvedQuantityOption
	},

	(* From resolveDropShipSamplesOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];

	(* Figure out if we're collecting tests *)
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;


	(* --- Resolve Email --- *)

	(* Pull Email and Upload options from the expanded Options *)
	{email, upload} = Lookup[myOptions, {Email, Upload}];

	(* Resolve Email option if Automatic *)
	resolvedEmail = If[!MatchQ[email, Automatic],
		(* If Email!=Automatic, use the supplied value *)
		email,
		(* If BOTH Upload->True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[upload, MemberQ[output, Result]],
			True,
			False
		]
	];


	(* Pull out the models/products of each transaction *)
	inputsByTransaction=Download[Lookup[myTransactionPackets, OrderedItems], Object];

	(* If any of the amount options are singles, expand to a list.
	Again, because theses options are indexed to a value inside the input object, the shared option expansion doesn't work*)
	{expandedMassOption,expandedVolumeOption,expandedCountOption,expandedQuantityOption} = Map[
		If[!ListQ[#],
			ConstantArray[#, Length[Flatten[inputsByTransaction]]],
			#
		]&,
		Lookup[myOptions,{Mass,Volume,Count,Quantity}]
	];

	(* get if we are dealing with a kit or not *)
	kitQs = Map[
		NullQ[#]&,
		myTransactionModelPackets,
		{2}
	];

	(* flatten out the models and the kitQs because we would do that a bunch below anyway *)
	flatModelPackets = Flatten[myTransactionModelPackets];
	flatKitQs = Flatten[kitQs];

	(* --- Check that, if mass/volume/count are specified, they are allowed for the type. --- *)

	(* Check if invalid amount is specified for any items. *)
	volumeInvalidBools=MapThread[
		Function[{volume, packet, kitQ},
			MatchQ[volume, Except[Null|None|Automatic]] && Not[kitQ] && MatchQ[Lookup[packet, Type], TypeP[SelfContainedModelTypes]]
		],
		{expandedVolumeOption,flatModelPackets, flatKitQs}
	];
	massInvalidBools=MapThread[
		Function[{mass, packet, kitQ},
			MatchQ[mass, Except[Null|None|Automatic]] && Not[kitQ] && MatchQ[Lookup[packet, Type], TypeP[SelfContainedModelTypes]]
		],
		{expandedMassOption,flatModelPackets, flatKitQs}
	];
	countInvalidBools=MapThread[
		Function[{count, packet, kitQ},
			MatchQ[count, Except[Null|None|Automatic]] && Not[kitQ] && Not[TrueQ[Lookup[packet, Tablet]]]
		],
		{expandedCountOption, flatModelPackets, flatKitQs}
	];

	(* If we are throwing messages, throw messages about amount invalidities *)
	If[messagesBoolean&&MemberQ[volumeInvalidBools,True],
		Message[Error::VolumeNotRequired,PickList[Flatten[inputsByTransaction],volumeInvalidBools]];Message[Error::InvalidOption,Volume]
	];
	If[messagesBoolean&&MemberQ[massInvalidBools,True],
		Message[Error::MassNotRequired,PickList[Flatten[inputsByTransaction],massInvalidBools]];Message[Error::InvalidOption,Mass]
	];
	If[messagesBoolean&&MemberQ[countInvalidBools,True],
		Message[Error::CountNotRequired,PickList[Flatten[inputsByTransaction],countInvalidBools]];Message[Error::InvalidOption,Count]
	];

	(* If we are collecting tests, assemble tests for amount validity *)
	volumeValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Volume is legally specified for "<>ToString[#2]<>". (Samples may have volume specified, items may not.):",
				#1,
				False
			]&,{volumeInvalidBools,Flatten[inputsByTransaction]}]
	];
	massValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Mass is legally specified for "<>ToString[#2]<>". (Samples may have mass specified, items may not.):",
				#1,
				False
			]&,{massInvalidBools,Flatten[inputsByTransaction]}]
	];
	countValidityTests=If[collectTestsBoolean,
		MapThread[
			Test["Count is legally specified for "<>ToString[#2]<>". (Tablets may have count specified, items and non-tablet samples may not.):",
				#1,
				False
			]&,{countInvalidBools,Flatten[inputsByTransaction]}]
	];

	(* --- Check that, if mass/volume/count are specified for a product, it agrees with the product amount --- *)
	productInputPackets=Cases[Flatten[myTransactionModelsProductsPackets],ObjectP[Object[Product]]];

	(* get the product kitQs *)
	prodKitQs = PickList[Flatten[kitQs], Flatten[myTransactionModelsProductsPackets],ObjectP[Object[Product]]];

	(* get the product input packets *)
	productInputMasses = PickList[expandedMassOption,Flatten[myTransactionModelsProductsPackets],ObjectP[Object[Product]]];
	productInputVolumes = PickList[expandedVolumeOption,Flatten[myTransactionModelsProductsPackets],ObjectP[Object[Product]]];
	productInputCounts = PickList[expandedCountOption,Flatten[myTransactionModelsProductsPackets],ObjectP[Object[Product]]];

	massAgreementBools=MapThread[
		Function[{specifiedMass, packet, kitQ},
			Which[
				(* if Mass was not specified, then this is always True *)
				Not[MassQ[specifiedMass]], True,
				(* if Mass was NOT specified and we are in a kit, this is always False  *)
				MassQ[specifiedMass] && kitQ, False,
				(* Otherwise check that the specified mass matches the product amount *)
				True, TrueQ[Equal[specifiedMass, Lookup[packet, Amount]]]
			]
		],
		{productInputMasses, productInputPackets, prodKitQs}
	];

	volumeAgreementBools = MapThread[
		Function[{specifiedVolume,packet, kitQ},
			Which[
				(* if Volume was not specified, then this is always True *)
				Not[VolumeQ[specifiedVolume]], True,
				(* if Volume was NOT specified and we are in a kit, this is always False  *)
				VolumeQ[specifiedVolume] && kitQ, False,
				(* Otherwise check that the specified volume matches the product amount *)
				True, TrueQ[Equal[specifiedVolume, Lookup[packet, Amount]]]
			]
		],
		{productInputVolumes, productInputPackets, prodKitQs}
	];
	countAgreementBools = MapThread[
		Function[{specifiedCount,packet, kitQ},
			Which[
				(* if Count was not specified, then this is always True *)
				Not[IntegerQ[specifiedCount]], True,
				(* if Count was NOT specified and we are in a kit, this is always False *)
				IntegerQ[specifiedCount] && kitQ, False,
				(* Otherwise check that the specified count matches the product amount *)
				True, TrueQ[Equal[specifiedCount, Lookup[packet, CountPerSample]]]
			]
		],
		{productInputCounts, productInputPackets, prodKitQs}
	];

	(* If we are throwing messages, throw messages about amount discrepancies *)
	If[messagesBoolean&&MemberQ[massAgreementBools,False],
		Message[Error::MassDiscrepancy,
			PickList[Lookup[productInputPackets,Object],massAgreementBools,False],
			PickList[productInputMasses,massAgreementBools,False]
		];Message[Error::InvalidOption,Mass]
	];
	If[messagesBoolean&&MemberQ[volumeAgreementBools,False],
		Message[Error::VolumeDiscrepancy,
			PickList[Lookup[productInputPackets,Object],volumeAgreementBools,False],
			PickList[productInputVolumes,volumeAgreementBools,False]
		];Message[Error::InvalidOption,Volume]
	];
	If[messagesBoolean&&MemberQ[countAgreementBools,False],
		Message[Error::CountDiscrepancy,
			PickList[Lookup[productInputPackets,Object],countAgreementBools,False],
			PickList[productInputCounts,countAgreementBools,False]
		];Message[Error::InvalidOption,Count]
	];

	(* If we are collecting tests, assemble tests for amount discrepancies *)
	massDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If mass is specified for "<>ToString[#2]<>" it agrees with the product amount (or Null for kits):",
				#1,
				True
			]&,
			{massAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];
	volumeDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If volume is specified for "<>ToString[#2]<>" it agrees with the product amount (or Null for kits):",
				#1,
				True
			]&,
			{volumeAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];
	countDiscrepancyTests = If[collectTestsBoolean,
		MapThread[
			Test["If count is specified for "<>ToString[#2]<>" it agrees with the product count (or Null for kits):",
				#1,
				True
			]&,
			{countAgreementBools,Lookup[productInputPackets,Object,{}]}]
	];


	(* --- Resolve any Automatic amount options to the existing values in the transaction.
	Need to reverse engineer the field values to get the corresponding value, which is a bit absurd since we would rather not
	take any action if the option value is Automatic, but we need to return an option value to the CC. --- *)
	resolvedMassOption=MapThread[
		Function[{massOption,existingMass,massSource},
			Which[
				!MatchQ[massOption,Automatic],massOption,
				existingMass==0Gram,massSource,
				True,existingMass]
		],{expandedMassOption,Flatten[Lookup[myTransactionPackets,Mass]],Flatten[Lookup[myTransactionPackets,MassSource]]}
	];
	resolvedVolumeOption=MapThread[
		Function[{volumeOption,existingVolume,volumeSource},
			Which[
				!MatchQ[volumeOption,Automatic],volumeOption,
				existingVolume==0Liter,volumeSource,
				True,existingVolume]
		],{expandedVolumeOption,Flatten[Lookup[myTransactionPackets,Volume]],Flatten[Lookup[myTransactionPackets,VolumeSource]]}
	];
	resolvedCountOption=MapThread[
		Function[{countOption,existingCount,countSource},
			Which[
				!MatchQ[countOption,Automatic],countOption,
				existingCount==0,countSource,
				True,existingCount]
		],{expandedCountOption,Flatten[Lookup[myTransactionPackets,Count]],Flatten[Lookup[myTransactionPackets,CountSource]]}
	];
	resolvedQuantityOption=MapThread[
		Function[{quantityOption,existingQuantity},
			Which[
				!MatchQ[quantityOption,Automatic],quantityOption,
				True,existingQuantity]
		],{expandedQuantityOption,Flatten[Lookup[myTransactionPackets,OrderQuantities]]}
	];

	(* --- For any sample (not item) models with a given volume but are liquid and do not have density, give a warning that they may still be transferred if they arrive in a non-liquid-level parameterized container --- *)
	(* Find any sample models that are liquid and have Volume specified as an amount, but that do not have density *)
	samplesThatWillBeTransferred=MapThread[
		Function[{resolvedVolume, modelPacket, prodPacket, kitQ},
			If[MatchQ[resolvedVolume, GreaterP[0 Milliliter]] && Not[kitQ] && MatchQ[Lookup[modelPacket, State], Liquid] && NullQ[Lookup[modelPacket, Density]] &&MatchQ[modelPacket, ObjectP[Model[Sample]]],
				Lookup[prodPacket, Object],
				Nothing
			]
		],
		{resolvedVolumeOption,flatModelPackets,Flatten[myTransactionModelsProductsPackets], flatKitQs}
	];

	(* If we are giving messages, throw a warning that the sample may need to be transferred if it is not in a parameterized container *)
	If[messagesBoolean&&!MatchQ[samplesThatWillBeTransferred,{}],Message[Warning::SampleMayBeTransferred,samplesThatWillBeTransferred]];

	(* If we are giving tests, generate warning tests that the sample may need to be transferred if it is not in a parameterized container *)
	sampleTransferTests=If[collectTestsBoolean,
		Map[
			Warning["For "<>ToString[#1]<>", if volume is specified as an amount, the density is known. (If the sample arrives in a container that is not parameterized for liquid level detection, your sample will be transferred to another container upon arrival. If this is not desired, please populate the Density of the models):",
				MemberQ[samplesThatWillBeTransferred,#],
				False
			]&,
			Lookup[Flatten[myTransactionModelsProductsPackets],Object]
		]
	];

	(* --- For any sample (not item) models that have Mass/Volume->ExperimentallyMeasure, give a warning that the sample may be transferred --- *)
	(* find any sample models that have mass or volume specified as ExperimentallyMeasure *)
	samplesThatMayBeTransferred=MapThread[
		Function[{resolvedMass, resolvedVolume, modelPacket, prodPacket, kitQ},
			If[Or[MatchQ[resolvedMass,ExperimentallyMeasure],MatchQ[resolvedVolume,ExperimentallyMeasure]]&&Not[kitQ]&&MatchQ[modelPacket,ObjectP[Model[Sample]]],
				Lookup[prodPacket,Object],
				Nothing
			]
		],
		{resolvedMassOption,resolvedVolumeOption,Flatten[myTransactionModelPackets],Flatten[myTransactionModelsProductsPackets], flatKitQs}
	];

	(* If we are giving messages, throw a warning that the sample may need to be transferred for measurement *)
	If[messagesBoolean&&!MatchQ[samplesThatMayBeTransferred,{}],Message[Warning::MeasurementMayRequireTransfer,samplesThatMayBeTransferred]];

	(* If we are giving tests, generate warning tests that the sample may need to be transferred for measurement *)
	measurementTransferTests=If[collectTestsBoolean,
		Map[
			Warning[ToString[#1]<>", may be transferred to another container in order to experimentally determine the amount. (If this is not desired, please specify an amount or specify ProductDocumentation to indicate that the amount should be found on the documents that ship with the sample.):",
				MemberQ[samplesThatMayBeTransferred,#],
				False
			]&,
			Lookup[Flatten[myTransactionModelsProductsPackets],Object]
		]
	];


	(* --- Make sure that if the user specified an amount, they did not specify different amounts for the same model.
		This isn't possible if they use the quantity input to specify more than one model, but if they enter the same model twice in the model input, then it is possible for them to specify different amounts.
		This would be problematic for ops during receiving since we don't know which model goes with which amount, especially if they arrive in different shipments. --- *)
	(* Partition the options by transaction *)
	{partitionedMassOption,partitionedVolumeOption,partitionedCountOption}=Unflatten[#,inputsByTransaction]&/@{resolvedMassOption,resolvedVolumeOption,resolvedCountOption};

	(* Find any models with conflicting amount options *)
	modelsWithConflictingMassByTransaction=MapThread[
		Function[{models,mass},
		(* Group each model sample with its mass option, and group model-mass pairs of the same model together *)
			With[{groupedModelsAndAmounts = GatherBy[Transpose[{models,mass}], First]},

			(* Collect any model samples that were specified with different masss *)
				PickList[groupedModelsAndAmounts[[All, All, 1]][[All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, -1]], Except[1]]
			]
		],{inputsByTransaction,partitionedMassOption}];

	modelsWithConflictingVolumeByTransaction=MapThread[
		Function[{models,volume},
		(* Group each model sample with its volume option, and group model-volume pairs of the same model together *)
			With[{groupedModelsAndAmounts = GatherBy[Transpose[{models,volume}], First]},

			(* Collect any model samples that were specified with different volumes *)
				PickList[groupedModelsAndAmounts[[All, All, 1]][[All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, -1]], Except[1]]
			]
		],{inputsByTransaction,partitionedVolumeOption}];

	modelsWithConflictingCountByTransaction=MapThread[
		Function[{models,count},
		(* Group each model sample with its count option, and group model-count pairs of the same model together *)
			With[{groupedModelsAndAmounts = GatherBy[Transpose[{models,count}], First]},

			(* Collect any model samples that were specified with different counts *)
				PickList[groupedModelsAndAmounts[[All, All, 1]][[All, 1]], Length /@ DeleteDuplicates /@ groupedModelsAndAmounts[[All, All, -1]], Except[1]]
			]
		],{inputsByTransaction,partitionedCountOption}];

	(* If we are giving messages, give a message if any models have conflicting amounts *)
	If[messagesBoolean&&!MatchQ[modelsWithConflictingMassByTransaction, {{}..}],Message[Error::ModelsHaveConflictingMass, DeleteCases[Transpose[{modelsWithConflictingMassByTransaction, Lookup[myTransactionPackets,Object]}], {{}, _}]];Message[Error::InvalidOption,Mass]];
	If[messagesBoolean&&!MatchQ[modelsWithConflictingVolumeByTransaction, {{}..}],Message[Error::ModelsHaveConflictingVolume, DeleteCases[Transpose[{modelsWithConflictingVolumeByTransaction, Lookup[myTransactionPackets,Object]}], {{}, _}]];Message[Error::InvalidOption,Volume]];
	If[messagesBoolean&&!MatchQ[modelsWithConflictingCountByTransaction, {{}..}],Message[Error::ModelsHaveConflictingCount, DeleteCases[Transpose[{modelsWithConflictingCountByTransaction, Lookup[myTransactionPackets,Object]}], {{}, _}]];Message[Error::InvalidOption,Count]];

	conflictingMassTests=Flatten[
		MapThread[
			Function[{conflictedModels, allModels},
				Map[
					Test[ToString[#1]<>" is not specified more than once in a single transaction with conflicting mass:",
						MemberQ[conflictedModels, #],
						False
					]&, allModels]], {modelsWithConflictingMassByTransaction, inputsByTransaction}]
	];
	conflictingVolumeTests=Flatten[
		MapThread[
			Function[{conflictedModels, allModels},
				Map[
					Test[ToString[#1]<>" is not specified more than once in a single transaction with conflicting volume:",
						MemberQ[conflictedModels, #],
						False
					]&, allModels]], {modelsWithConflictingVolumeByTransaction, inputsByTransaction}]
	];
	conflictingCountTests=Flatten[
		MapThread[
			Function[{conflictedModels, allModels},
				Map[
					Test[ToString[#1]<>" is not specified more than once in a single transaction with conflicting count:",
						MemberQ[conflictedModels, #],
						False
					]&, allModels]], {modelsWithConflictingCountByTransaction, inputsByTransaction}]
	];

	(* --- Validate the Name option --- *)
	nameUniquenessTests=If[!NullQ[Lookup[myOptions,Name]],
		Module[{numberOfTransactions,name,expandedNames,nameValidBools},

			(* We need to see how many transaction packets will be made to see what the names will be. Transactions that have different order numbers, service providers, or shipping info are split up   *)
			numberOfTransactions = Length[myTransactionPackets];

			(* Get the name option *)
			name=Lookup[myOptions,Name];

			(* Expand the name if we are making multiple transaction objects *)
			expandedNames=If[numberOfTransactions==1,
				ToList[name],
				Map[name<>"_"<>ToString[#]&/@Range[numberOfTransactions]]
			];

			(* Check if the name is used already *)
			nameValidBools=DatabaseMemberQ[Append[Object[Transaction, DropShipping], #] & /@ expandedNames];

			(* If we are giving messages, throw a message if the name is not unique *)
			If[messagesBoolean&&MemberQ[nameValidBools,True],
				Message[Error::NonUniqueName,PickList[expandedNames,nameValidBools],Object[Transaction,DropShipping]];Message[Error::InvalidOption,Name]
			];

			(* If we are collecting tests, assemble tests for name uniquness *)
			If[collectTestsBoolean,
				MapThread[
					Test["The name "<>ToString[#2]<>" is unique for Object[Transaction, DropShipping]:",
						#1,
						False
					]&,{nameValidBools,expandedNames}]
			]
		]
	];

	(* --- Resolve any Automatic shipping options to the existing value in the transaction. --- *)
	resolvedProviderOption=MapThread[
		If[MatchQ[#1,Automatic],
			Lookup[#2,Provider],
			#1]&,{Lookup[myOptions,Provider],myTransactionPackets}
	];
	resolvedShipperOption=MapThread[
		If[MatchQ[#1,Automatic],
			Lookup[#2,Shipper],
			#1]&,{Lookup[myOptions,Shipper],myTransactionPackets}
	];
	resolvedTrackingNumberOption=MapThread[
		If[MatchQ[#1,Automatic],
			Lookup[#2,TrackingNumbers]/.{}:>None,
			#1]&,{Lookup[myOptions,TrackingNumber],myTransactionPackets}
	];
	resolvedDateShippedOption=MapThread[
		If[MatchQ[#1,Automatic],
			Lookup[#2,DateShipped],
			#1]&,{Lookup[myOptions,DateShipped],myTransactionPackets}
	];

	resolvedExpectedDeliveryDateOption=MapThread[
		If[MatchQ[#1,Automatic],
			Lookup[#2,DateExpected],
			#1]&,{Lookup[myOptions,ExpectedDeliveryDate],myTransactionPackets}
	];


	(* --- If date shipped and expected delivery date are both specified, make sure the shipment date is earlier than the delivery date --- *)
	(* Find any models that have an earlier date expected than date shipped *)
	invalidDateOrders = PickList[Lookup[myTransactionPackets,Object], MapThread[Greater[#1, #2] &, {resolvedDateShippedOption, resolvedExpectedDeliveryDateOption}]];

	(* If we are giving messages, throw that dates are invalid *)
	If[messagesBoolean&&!MatchQ[invalidDateOrders, {}],Message[Error::InvalidDates, invalidDateOrders];Message[Error::InvalidOption,DateShipped];Message[Error::InvalidOption,ExpectedDeliveryDate]];

	(* If we are giving tests, generate tests that dates are invalid *)
	invalidDateTests=If[collectTestsBoolean,
		Map[
			Test["ExpectedDeliveryDate is later than DateShipped for "<>ToString[#],
				MemberQ[invalidDateOrders,#],
				False
			]&,Lookup[myTransactionPackets,Object]]
	];

	(* Pool all the tests into one list *)
	allTests=DeleteCases[Flatten[{volumeValidityTests,massValidityTests,sampleTransferTests,measurementTransferTests,
		conflictingMassTests,conflictingVolumeTests,nameUniquenessTests,invalidDateTests,countValidityTests,
		conflictingCountTests,massDiscrepancyTests,volumeDiscrepancyTests,countDiscrepancyTests}],Null];

	(* Assemble the resolved options *)
	resolvedOptions=ReplaceRule[myOptions,
		{
			Mass -> resolvedMassOption,
			Volume -> resolvedVolumeOption,
			Count -> resolvedCountOption,
			Shipper -> resolvedShipperOption,
			Provider->resolvedProviderOption,
			ExpectedDeliveryDate -> resolvedExpectedDeliveryDateOption,
			TrackingNumber -> resolvedTrackingNumberOption,
			DateShipped-> resolvedDateShippedOption,
			Email->resolvedEmail,
			Quantity->resolvedQuantityOption
		}
	];

	output/.{Tests->allTests,Result->resolvedOptions}
];



(* ::Subsubsection::Closed:: *)
(*DropShipSamplesOptions*)


DefineOptions[DropShipSamplesOptions,
	SharedOptions :> {DropShipSamples},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

(* Models without quantities overload *)
DropShipSamplesOptions[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=DropShipSamplesOptions[myInputs,myOrderNumbers,ConstantArray[1,Length[myInputs]], myOptions];

(* Models core overload *)
DropShipSamplesOptions[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for DropShipSamples *)
	options=DropShipSamples[myInputs,myOrderNumbers, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,DropShipSamples],
		options
	]

];

(* Transaction overload *)
DropShipSamplesOptions[myTransactions: ListableP[ObjectP[Object[Transaction, DropShipping]]], myOptions: OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions,options},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	(* get only the options for DropShipSamples *)
	options=DropShipSamples[myTransactions, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,DropShipSamples],
		options
	]

];



(* ::Subsubsection::Closed:: *)
(*DropShipSamplesPreview*)


DefineOptions[DropShipSamplesPreview,
	SharedOptions :> {DropShipSamples}
];

(* Models without quantities overload *)
DropShipSamplesPreview[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=DropShipSamplesPreview[myInputs,myOrderNumbers,ConstantArray[1,Length[myInputs]], myOptions];

(* Models core overload *)
DropShipSamplesPreview[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for DropShipSamples *)
	DropShipSamples[myInputs,myOrderNumbers, Append[noOutputOptions, Output -> Preview]]

];

(* Transaction overload *)
DropShipSamplesPreview[myTransactions: ListableP[ObjectP[Object[Transaction, DropShipping]]], myOptions: OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the options for DropShipSamples *)
	DropShipSamples[myTransactions, Append[noOutputOptions, Output -> Preview]]

];



(* ::Subsubsection::Closed:: *)
(*ValidDropShipSamplesQ*)


DefineOptions[ValidDropShipSamplesQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {DropShipSamples}
];

(* Models without quantities overload *)
ValidDropShipSamplesQ[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=ValidDropShipSamplesQ[myInputs,myOrderNumbers,ConstantArray[1,Length[myInputs]], myOptions];

(* Models core overload *)
ValidDropShipSamplesQ[myInputs:ListableP[ObjectP[{Model[Sample],Model[Item],Object[Product]}] ..], myOrderNumbers:ListableP[_String..], myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, DropShipSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for DropShipSamples *)
	DropShipSamplesTests = DropShipSamples[myInputs,myOrderNumbers, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[DropShipSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[ToList[myInputs], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{ToList[myInputs], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, DropShipSamplesTests, voqWarnings}]
		]
	];
	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidDropShipSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidDropShipSamplesQ"]
];

(* Transactions overload *)
ValidDropShipSamplesQ[myTransactions: ListableP[ObjectP[Object[Transaction, DropShipping]]], myOptions: OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, DropShipSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for DropShipSamples *)
	DropShipSamplesTests = DropShipSamples[myTransactions, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[DropShipSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[Join[myTransactions], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{Join[myTransactions], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, DropShipSamplesTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidDropShipSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidDropShipSamplesQ"]

];


(* ::Subsection::Closed:: *)
(*OrderSamples*)


(* ::Subsubsection::Closed:: *)
(*OrderSamples Options and Messages*)


DefineOptions[OrderSamples,
	Options:>{
		IndexMatching[
			IndexMatchingInput->"Input Block",
			{
				OptionName->ContainerOut,
				Default->None,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container]],PreparedSample->False],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Description->"The desired type of container that the sample should be transferred into upon receiving.",
				Category->"Order"
			},
			{
				OptionName->Destination,
				Default->Automatic,
				Description->"The site where the samples are being delivered.",
				AllowNull->False,
				Category->"Order",
				Widget->Widget[
					Type->Object,
					Pattern:>ObjectP[Object[Container, Site]],
					PreparedSample->False
				]
			},
			{
				OptionName -> ShippingSpeed,
				Default -> FiveDay,
				Description -> "Indicates the delivery speed which should be requested from the shipper when possible.",
				AllowNull -> False,
				Category->"Order",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ShippingSpeedP
				]
			},
			{
				OptionName -> ShipToUser,
				Default -> False,
				Description -> "Indicates if the samples ordered in this transaction should be shipped directly to the users home site from an ECL location.",
				AllowNull -> False,
				Category->"Order",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> DependentProtocol,
				Default -> None,
				Description -> "The protocol (if any) that is dependent on each item being ordered to begin or continue execution.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Object[Protocol], Object[Qualification], Object[Maintenance]}]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Hidden"
			},
			{
				OptionName -> DependentResource,
				Default -> None,
				Description -> "The resource (if any) that is dependent on each item being ordered to begin or continue execution.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Resource, Sample]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[None]
					]
				],
				Category -> "Hidden"
			},
			{
				OptionName -> Creator,
				Default -> Automatic,
				Description -> "Indicates the person who placed this order.",
				ResolutionDescription -> "Automatically resolves to $PersonID unless Autogenerated is True, in which case Creator resolves to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[User]]
				]
			},
			{
				OptionName->ShippedRack,
				Default->None,
				AllowNull->True,
				Widget->Alternatives[
					Widget[Type->Object,Pattern:>ObjectP[Model[Container, Rack]]],
					Widget[Type->Enumeration,Pattern:>Alternatives[None]]
				],
				Description->"The model of rack that is shipped holding other items in this order.",
				Category->"Container Information"
			}
		],
		{
			OptionName -> Autogenerated,
			Default -> False,
			Description -> "Indicates if the orders were automatically generated based on standing thresholds of inventory to keep samples in stock.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Hidden"
		},
		{
			OptionName -> InternalOrder,
			Default -> Automatic,
			Description -> "Indicates if the products should try to be directly purchased from ECL's in house inventory. If the products are out of stock and could not be directly purchased from ECL's in house inventory, ECL will automatically place an order to the external supplier.",
			ResolutionDescription -> " ally resolves to False when Autogenerated is True, otherwise resolves to True.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> SyncOrders,
			Default -> False,
			Description -> "Determines whether SyncOrders will be run after an Order is generated by OrderSamples.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Hidden"
		},
		{
			OptionName -> ReceivingTolerance,
			Default -> 1*Percent,
			Description -> "Defines the allowable difference between ordered amount and received amount for every item in the transaction. Any difference greater than the ReceivingTolerance will not be received, and will instead by investigated by Systems Diagnostics.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0Percent,100Percent],
				Units :> Alternatives[Percent]
			],
			Category -> "Hidden"
		},
		EmailOption,
		OutputOption,
		UploadOption,
		CacheOption,
		FastTrackOption
	}
];

OrderSamples::OrderMustBeInternal="Because the Emerald Cloud Lab is a Supplier of one or more of the requested Models or Products, InternalOrder must be set to True.";
OrderSamples::NoValidProducts="The models `1` have no products that can be ordered, as those models are either missing product information or their products have been marked as Deprecated. Please create new products for these models so that we may place this order for you.";
OrderSamples::Deprecated="The products `1` have been deprecated and cannot be ordered.";
OrderSamples::InvalidProduct="The product(s): `1` is missing required information for placing an order on it. Please check ValidObjectQ with Verbose->Failures on the product(s).";
OrderSamples::AmountUnit="The specified amount: `1` in the following samples: `2` is not compatible with the associated products. Please check the amount input and sample's products, and place another order.";
OrderSamples::NotForSale="The following products or the products of the samples: `1` are not for sale and cannot be ordered. Please check to see if there is another product listing matching your model that is for sale, or consider generating a new product listing for the model.";
OrderSamples::SyncPermissionDenied="You must be a Developer in the public environment to use the SyncOrders option.";


(* ::Subsubsection::Closed:: *)
(*OrderSamples*)


(* Singleton case *)
OrderSamples[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamples[{myObject},{myOrderAmount},myOptions];

(* Mismatched input case *)
OrderSamples[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=OrderSamples[Table[myObject,{Length[myOrderAmounts]}],myOrderAmounts,myOptions];
OrderSamples[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamples[myObjects,Table[myOrderAmount,{Length[myObjects]}],myOptions];

(* Core overload *)
OrderSamples[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=Module[
	{
		outputSpecification,output,gatherTestsQ,safeOps,safeOpsTests,validLengthsQ,validLengthTests,
		expandedSafeOps,resolvedCreators,resolvedInternalOrderQ,resolvedEmailQ,resolvedOptions,collapsedOptions,
		productPositions,products,productQuantities,expandedProductShippingSpeeds,expandedProductDestinations,
		expandedProductDependentProtocols,expandedProductDependentResources,expandedProductShipToUsers,expandedProductShippedRacks, mergedModelShippedRacks,
		modelPositions,models,modelAmounts,expandedModelShippingSpeeds,expandedModelDestinations,
		expandedModelDependentProtocols,expandedModelDependentResources,expandedModelShipToUsers,expandedModelShippedRacks,
		groupedModelProductTuples,mergedModels,mergedAmounts,mergedModelProductDestinations,
		mergedModelProductShippingSpeeds,mergedModelProductShipToUsers,mergedModelProductDependentResources,
		mergedModelProductDependentProtocols,modelProductQuantityTuples,modelProductTests,modelProducts,
		modelProductQuantities,productOrderPacketsReturn,productOrderPackets,productTests,allTests,modelOrderPackets,
		allOrderPackets,orderStatusUpdates,allUpdates,result,allUploads,downloadedStuff,productPackets,
		containerOutMaxVolumes,containerContentsValidityTests,containerVolumeValidityTests,containerVolumeValidityWarnings,
		containerOutInvalidContentBools,containerOutInvalidVolumeBools,productContainerOuts,expandedModelContainerOuts,
		mergedModelContainerOuts,groupedProductsContainers,containerOutInconsistentIndexes,containerOutInconsistentTests,
		modelProductCheckResults,modelProductCheckTests,doubleResolvedInternalOrderQ,doubleResolvedInternalOrderTest,
		productOnlyPackets,modelProductPackets,containerOutFromProductMaxVolumes,containerOutFromModelProductsMaxVolumes,
		expandedModelContainerOutsMaxVolumes,transactionPacketsExtraFields,cache,reDownloadedObjects,
		listedModelProducts,myProducts,resPacks,containersOutPacks,fullCache,expandedProductNotebooks,expandedModelNotebooks,
		mergedModelProductNotebooks,dependentProtPacks,expandedProductCreators,expandedModelCreators,mergedModelCreators,
		possibleAuthors,
		allInputContainers, modelContainerPackets, productContainerPackets, rackPackets, racks,
		rackResult, invalidRackRules, noRackRules, invalidRacksTest, noRacksTest, resolvedSites
	},

	(* ------------- *)
	(* --  Setup  -- *)
	(* ------------- *)

	(* If no input, return empty list *)
	If[MatchQ[myObjects,{}],
		Return[{}]
	];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps,safeOpsTests} = If[gatherTestsQ,
		SafeOptions[
			OrderSamples,
			ToList[myOptions],
			AutoCorrect->False,
			Output->{Result,Tests}
		],
		{
			SafeOptions[
				OrderSamples,
				ToList[myOptions],
				AutoCorrect->False
			],
			{}
		}
	];

	(*If the specified options don't match their patterns return $Failed*)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	(* Silence the missing option errors *)
	{validLengthsQ,validLengthTests}=Quiet[
		If[gatherTestsQ,
			ValidInputLengthsQ[OrderSamples,{myObjects,myOrderAmounts},ToList[myOptions],Output->{Result,Tests}],
			{ValidInputLengthsQ[OrderSamples,{myObjects,myOrderAmounts},ToList[myOptions]],Null}
		],
		Warning::IndexMatchingOptionMissing
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengthsQ,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[OrderSamples,{myObjects,myOrderAmounts},safeOps]];

	(* Get any provided Cache *)
	cache = Lookup[safeOps,Cache];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Find the input positions for all Product and Model objects *)
	productPositions = Flatten[Position[myObjects,ObjectP[Object[Product]],{1}]];
	modelPositions = Flatten[Position[myObjects,ObjectP[Model],{1}]];

	(* Extract only product and product amounts from input *)
	products = myObjects[[productPositions]];
	productQuantities = myOrderAmounts[[productPositions]];

	(* Extract only model and model amounts from input *)
	models = myObjects[[modelPositions]];
	modelAmounts = myOrderAmounts[[modelPositions]];

	(* get any racks we need to download from *)
	racks = Cases[Lookup[safeOps, ShippedRack], ObjectP[Model[Container, Rack]]];

	(* Download information from all model's products needed to choose the best product  *)
	downloadedStuff = {listedModelProducts,myProducts,resPacks,containersOutPacks,dependentProtPacks, modelContainerPackets, productContainerPackets, rackPackets} = Quiet[
		Download[
		{
			models,
			products,
			Lookup[expandedSafeOps,DependentResource]/.None->Null,
			Lookup[expandedSafeOps,ContainerOut]/.None->Null,
			Lookup[expandedSafeOps,DependentProtocol]/.None->Null,
			models,
			products,
			racks
		},
		{

			(* Info on products associated with the input models *)
			{
				Packet[Products[{Name,CountPerSample,DefaultContainerModel,Stocked,Deprecated,NotForSale,NumberOfItems,Amount,Supplier,ProductModel,KitComponents}]],
				Packet[KitProducts[{Name,CountPerSample,DefaultContainerModel,Stocked,Deprecated,NotForSale,KitComponents,NumberOfItems,Amount,ProductModel,Supplier}]]
			},

			(* Info on input products *)
			{Packet[Deprecated,NotForSale,NumberOfItems,Amount,Supplier,ProductModel,KitComponents,Name,CountPerSample,DefaultContainerModel,Stocked,Sterile,AsepticShippingContainerType]},

			(* Info on resources *)
			{Packet[Object,Amount,Models,Notebook]},

			(* Info on containers *)
			{Packet[MaxVolume]},

			(* Info on dependent protocols *)
			{Packet[Author,Site]},

			(* If the input was a model, get the dimensions of the default container and themodel itself if it is a container *)
			{
				Packet[Dimensions, SelfStanding, Footprint],
				Packet[Products[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]],
				Packet[KitProducts[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]],
				Packet[Products, KitProducts, State]
			},

			(* if the input was a product, get the dimensions of the container *)
			{Packet[DefaultContainerModel[{Dimensions, SelfStanding, Footprint}]]},

			(* if the ShippedRacks option was populated, check that *)
			{Packet[Positions]}
		},
		Cache -> cache
	],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	fullCache = Join[cache,Cases[Flatten[downloadedStuff], PacketP[]]];

	(* ----------------------- *)
	(* -- Option resolution -- *)
	(* ----------------------- *)

	(* -- Creator -- *)

	(* Pull out the authors of our dependent protocols *)
	possibleAuthors = If[!NullQ[#],Download[Lookup[#,Author,Null],Object],Null]&/@Flatten[dependentProtPacks];

	(* Resolve Creator: If set to Automatic, creator is $PersonID unless Autogenerated->True. Otherwise, it is the specified creator *)
	resolvedCreators = MapThread[
		Function[{nextCreator,nextDependentProtocol,nextAuthor},
			Which[
				(* Option was set to a user *)
				MatchQ[nextCreator,ObjectP[Object[User]]],
					Download[nextCreator,Object],

				(* Option was set to a protocol *)
				MatchQ[nextCreator,ObjectP[Object[User]]],
					Null,

				(* Option was set to Null *)
				NullQ[nextCreator],
					nextCreator,

				(* -- Otherwise option was Automatic and we must resolve it -- *)

				(* Autogenerated Option set to true, then Null out the creator to indicate inventory system placed this *)
				Lookup[safeOps,Autogenerated],
					Null,

				(* If we were provided DependentProtocols, set the author of the transaction to that protocol's author *)
				MatchQ[nextDependentProtocol,ProtocolTypeP[]],
					nextAuthor,

				(* If all else fails, default to $PersonID *)
				True,
					$PersonID
			]
		],
		{
			Lookup[expandedSafeOps,Creator]/.None->Null,
			Download[Flatten[dependentProtPacks],Object],
			possibleAuthors
		}
	];

	(* -- InternalOrder -- *)

	(* NOTE: When a DependentProtocol exists, InternalOrder must be False (ie: order from the external supplier)
	since otherwise the protocol would resolve the order at resource picking time.
	Since DependentProtocol is Hidden, we haven't added an error. But... we may want to if that's a thing internal-emerald people are trying to do. *)

	(* Determine if the orders should be from an external supplier or attempt to be fulfilled internally *)
	resolvedInternalOrderQ = If[MatchQ[Lookup[safeOps,InternalOrder],Automatic],
		Which[
			(* if the order is auto-generated, re-set to False *)
			TrueQ[Lookup[safeOps,Autogenerated]],
				False,

			(* If the creator is an Emerald on-site user/developer, set to False *)
			MemberQ[resolvedCreators,ObjectP[Object[User,Emerald]]],
				False,

			(* When a DependentProtocol exists, InternalOrder must be False (ie: order from the external supplier)
			since otherwise the protocol would resolve the order at resource picking time *)
			!MatchQ[Lookup[expandedSafeOps,DependentProtocol],{None..}],
				False,

			True,
				True
		],
		Lookup[safeOps,InternalOrder]
	];

	(* -- Email -- *)

	(* Resolve Email option if Automatic *)
	resolvedEmailQ = If[!MatchQ[Lookup[safeOps,Email], Automatic],
		(* If Email!=Automatic, use the supplied value *)
		Lookup[safeOps,Email],
		(* If both Upload->True and Result is a member of Output, send emails.
		Otherwise, do not send emails *)
		And[Lookup[safeOps,Upload], MemberQ[output, Result]]
	];

	(* -- Site -- *)

	resolvedSites = MapThread[
		Function[{destination, dependentProtocolOption, dependentProtocolPacket},
			Which[
				(*If Site !=Automatic get it from expanded safeOps.*)
				!MatchQ[destination,Automatic], destination,
				(*If a site is not specified in options, use the site of the DependentProtocol*)
				MatchQ[dependentProtocolOption,ObjectP[ProtocolTypes[]]],Download[Lookup[dependentProtocolPacket,Site],Object],
				(*Otherwise use $Site*)
				True, $Site
			]
		],
		(*Note: dependentProtPacks must be downloaded as a flattened list or the site object will be wrapped in  nest list causing a mismatch with the Destination Field of Object[Transaction, Order].*)
		{Lookup[expandedSafeOps,Destination], Lookup[expandedSafeOps,DependentProtocol], Flatten[dependentProtPacks]}
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	resolvedOptions = ReplaceRule[
		expandedSafeOps,
		{
			Creator -> resolvedCreators,
			InternalOrder -> resolvedInternalOrderQ,
			Email -> resolvedEmailQ,
			Destination-> resolvedSites
		}
	];

	(* Collapse any possible index-matched options *)
	collapsedOptions = CollapseIndexMatchedOptions[
		OrderSamples,
		resolvedOptions,
		Messages->False,
		Ignore->ToList[myOptions]
	];


	(* ----------------------------- *)
	(* -- Expand and Merge orders -- *)
	(* ----------------------------- *)

	(* Extract index-matched option values corresponding to product inputs *)
	expandedProductShippingSpeeds = Lookup[expandedSafeOps,ShippingSpeed][[productPositions]];
	expandedProductDestinations = Lookup[resolvedOptions,Destination][[productPositions]];
	expandedProductDependentProtocols = Lookup[expandedSafeOps,DependentProtocol][[productPositions]];
	expandedProductDependentResources = Flatten[resPacks][[productPositions]];
	expandedProductCreators = resolvedCreators[[productPositions]];
	expandedProductShipToUsers = Lookup[expandedSafeOps,ShipToUser][[productPositions]];
	expandedProductShippedRacks = (Lookup[expandedSafeOps,ShippedRack]/.None-> Null)[[productPositions]];
	productContainerOuts = Flatten[containersOutPacks[[productPositions]]];
	(* Extract index-matched option values corresponding to model inputs *)
	expandedModelShippingSpeeds = Lookup[expandedSafeOps,ShippingSpeed][[modelPositions]];
	expandedModelDestinations = Lookup[resolvedOptions,Destination][[modelPositions]];
	expandedModelDependentProtocols = Lookup[expandedSafeOps,DependentProtocol][[modelPositions]];
	expandedModelDependentResources = Flatten[resPacks][[modelPositions]];
	expandedModelCreators = resolvedCreators[[modelPositions]];
	expandedModelShipToUsers = Lookup[expandedSafeOps,ShipToUser][[modelPositions]];
	expandedModelContainerOuts = Flatten[containersOutPacks[[modelPositions]]];
	expandedModelShippedRacks = (Lookup[expandedSafeOps,ShippedRack]/.None-> Null)[[modelPositions]];

	(* Find the notebooks involved with each product/model. If there is no notebook then set it to $Notebook *)
	expandedProductNotebooks = If[MatchQ[#,ObjectP[Object[Resource]]],
		Download[Lookup[#,Notebook],Object],
		$Notebook
	]&/@expandedProductDependentResources;
	(* Find the notebooks involved with each product/model. If there is no notebook then set it to $Notebook *)
	expandedModelNotebooks = If[MatchQ[#,ObjectP[Object[Resource]]],
		Download[Lookup[#,Notebook],Object],
		$Notebook
	]&/@expandedModelDependentResources;

	(* If we're placing an external order, then some models can be merged into a single product order *)
	groupedModelProductTuples = If[Not[resolvedInternalOrderQ],
		GatherBy[
			Transpose[{
				(* 1 *)Download[models,Object],
				(* 2 *)modelAmounts,
				(* 3 *)expandedModelDestinations,
				(* 4 *)expandedModelShippingSpeeds,
				(* 5 *)expandedModelShipToUsers,
				(* 6 *)expandedModelDependentResources,
				(* 7 *)expandedModelNotebooks,
				(* 8 *)expandedModelDependentProtocols,
				(* 9 *)expandedModelContainerOuts,
				(* 10 *)expandedModelCreators,
				(* 11 *)expandedModelShippedRacks
			}],
			(* Group by the same Model, Destination, ShippingSpeed, ShipToUser, Notebook, and ContainerOut *)
			#[[{1,3,4,5,7,9,10}]]&
		],
		{}
	];

	(* Extract values for each distinct model grouping *)
	mergedModels = First/@(groupedModelProductTuples[[All,All,1]]);
	(* Total amounts *)
	mergedAmounts = Total[#]&/@(groupedModelProductTuples[[All,All,2]]);
	mergedModelProductDestinations = First/@(groupedModelProductTuples[[All,All,3]]);
	mergedModelProductShippingSpeeds = First/@(groupedModelProductTuples[[All,All,4]]);
	mergedModelProductShipToUsers = First/@(groupedModelProductTuples[[All,All,5]]);
	(* If an order has no dependent resources/protocols, option value None was converted to Null *)
	mergedModelProductDependentResources = DeleteCases[#,Null]&/@(groupedModelProductTuples[[All,All,6]]);
	mergedModelProductNotebooks = First/@groupedModelProductTuples[[All,All,7]];
	mergedModelProductDependentProtocols = DeleteCases[#,None]&/@(groupedModelProductTuples[[All,All,8]]);
	mergedModelContainerOuts = First/@(groupedModelProductTuples[[All,All,9]]);
	mergedModelCreators = First/@(groupedModelProductTuples[[All,All,10]]);
	mergedModelShippedRacks = First/@(groupedModelProductTuples[[All,All,11]]);

	(* This helper finds the best product to fulfill any request for a certain amount of a model.
	It returns tuples (index-matched to the input) with the form {{preferred product, product quantity required}..} *)
	{modelProductQuantityTuples,modelProductTests} = If[gatherTestsQ,
		preferredProductQuantities[mergedModels,mergedAmounts,DependentResource->mergedModelProductDependentResources,Cache->fullCache,Output->{Result,Tests}],
		{preferredProductQuantities[mergedModels,mergedAmounts,DependentResource->mergedModelProductDependentResources,Cache->fullCache],{}}
	];

	(* If there was a failure finding an appropriate product for a model, return failure
	(an appropriate error message will already be thrown by preferredProductQuantities) *)
	If[MatchQ[modelProductQuantityTuples,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->DeleteCases[Flatten[{safeOpsTests,validLengthTests,modelProductTests}], Null],
			Options->collapsedOptions,
			Preview->Null
		}]
	];

	(* If InternalOrder -> True, and Models are our input, we still must check that the Models have Products associated with them,
		in case we must order products for them later *)
	{modelProductCheckResults,modelProductCheckTests} = If[And[resolvedInternalOrderQ,MatchQ[models,{ObjectP[Model[]]..}]],

		(* Doublecheck that all models have viable products *)
		If[gatherTestsQ,
			preferredProductQuantities[models,modelAmounts,DependentResource->expandedModelDependentResources,Cache->fullCache,Output->{Result,Tests}],
			{preferredProductQuantities[models,modelAmounts,DependentResource->expandedModelDependentResources,Cache->fullCache],{}}
		],

		(* Otherwise this check is unnecessary *)
		{{},{}}
	];

	(* If there was a failure finding an appropriate product for a model, return failure
	(an appropriate error message will already be thrown by preferredProductQuantities) *)
	If[MatchQ[modelProductCheckResults,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests -> DeleteCases[Flatten[{safeOpsTests,validLengthTests,modelProductTests,modelProductCheckTests}], Null],
			Options->collapsedOptions,
			Preview->Null
		}]
	];

	(* -------------------- *)
	(* -- Error Checking -- *)
	(* -------------------- *)


	(* Extract the product and product quantities from tuples *)
	modelProducts = modelProductQuantityTuples[[All,1]];
	modelProductQuantities = modelProductQuantityTuples[[All,2]];

	(* Re-Download the relevant information. We've already cached all this information so no web-request should be required *)
	reDownloadedObjects = Download[
		{
			products,
			modelProducts
		},
		{
			{Packet[Object, ProductModel, KitComponents, Amount, Supplier, DefaultContainerModel]},
			{Packet[Object, ProductModel, KitComponents, Amount, Supplier, DefaultContainerModel]}
		},
		Cache -> fullCache
	];

	(* Split downloaded items into smaller variables *)
	productOnlyPackets = Flatten[reDownloadedObjects[[1]]];
	modelProductPackets = Flatten[reDownloadedObjects[[2]]];
	containerOutFromProductMaxVolumes = Flatten[If[!NullQ[#],Lookup[#,MaxVolume,Null],Null]&/@productContainerOuts];
	containerOutFromModelProductsMaxVolumes = Flatten[If[!NullQ[#],Lookup[#,MaxVolume,Null],Null]&/@mergedModelContainerOuts];
	expandedModelContainerOutsMaxVolumes = Flatten[If[!NullQ[#],Lookup[#,MaxVolume,Null],Null]&/@expandedModelContainerOuts];

	(* Now we need to make sure we're ordering with InternalOrder->False if Emerald is the supplier of any order OR we're ordering a kit *)
	(* The reason we want to place external orders for kit is that kit component assignment is tricky once into the weeds and users should be ordering kits externally *)
	doubleResolvedInternalOrderQ = Which[
		(* If InternalOrder is currently False, Autogenerated->True, and Emerald was the supplier of a product, quietly set InternalOrder->True *)
		And[
			TrueQ[Lookup[safeOps,Autogenerated]],
			Not[resolvedInternalOrderQ],
			MemberQ[Lookup[Join[productOnlyPackets,modelProductPackets],Supplier],LinkP[Object[Company,Supplier,"id:eGakld01qrkB"]]]
		],
			True,

		(*		* If InternalOrder is currently False, the user didn't specify InternalOrder, and the product is a kit, quietly set InternalOrder->False *)(*
		And[
			MatchQ[Lookup[safeOps,InternalOrder],Automatic],
			TrueQ[resolvedInternalOrderQ],
			MemberQ[Lookup[Join[productOnlyPackets,modelProductPackets],Supplier],LinkP[Object[Company,Supplier,"id:eGakld01qrkB"]]]
		],
			True,*)

		(* If Autogenerated is False, the User Specified InternalOrder\[Rule]False, and Emerald is a supplier, throw and Error and return $Failed *)
		And[
			!TrueQ[Lookup[safeOps,Autogenerated]],
			MatchQ[Lookup[safeOps,InternalOrder],False],
			MemberQ[Lookup[Join[productOnlyPackets,modelProductPackets],Supplier],LinkP[Object[Company,Supplier,"id:eGakld01qrkB"]]]
		],
			(
				Message[OrderSamples::OrderMustBeInternal];
				Message[Error::InvalidOption,InternalOrder];
				$Failed
			),

		(* If InternalOrder resolved to false from Automatic but neither of the earlier cases is ture, and Emerald was the supplier of a product, quietly set InternalOrder\[Rule]True *)
		And[
			MatchQ[Lookup[safeOps,InternalOrder],Automatic],
			Not[resolvedInternalOrderQ],
			MemberQ[Lookup[Join[productOnlyPackets,modelProductPackets],Supplier],LinkP[Object[Company,Supplier,"id:eGakld01qrkB"]]]
		],
			True,

		(* If neither of the above cases are true, default to what we resolved to earlier *)
		True,
			resolvedInternalOrderQ
	];

	doubleResolvedInternalOrderTest=Test["If Emerald is the Supplier, InternalOrder wasn't specified as False:",
		!MatchQ[doubleResolvedInternalOrderQ,$Failed],
		True
	];

	(* If there was a failure finding an appropriate product for a model, return failure
	(an appropriate error message will already be thrown by preferredProductQuantities) *)
	If[MatchQ[doubleResolvedInternalOrderQ,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,modelProductTests,modelProductCheckTests,doubleResolvedInternalOrderTest}],
			Options->collapsedOptions,
			Preview->Null
		}]
	];

	(* If we re-resolved InternalOrder to True from False, we need to ignore modelProducts as that will cause double ordering *)
	productPackets=If[doubleResolvedInternalOrderQ,productOnlyPackets,Join[productOnlyPackets,modelProductPackets]];

	(* If we re-resolved InternalOrder to True from False, we need to ignore modelProductsContainerOutsMaxVolumes as that will cause double ordering *)
	containerOutMaxVolumes=If[
		doubleResolvedInternalOrderQ,
		Join[containerOutFromProductMaxVolumes,expandedModelContainerOutsMaxVolumes],
		Join[containerOutFromProductMaxVolumes,containerOutFromModelProductsMaxVolumes]
	];

	(* --- Validate ContainerOut --- *)

	(* Do different validation depending on whether we are ordering models as well via an internal order *)
	(* If the thing being ordered is an item and container out is specified, mark as invalid *)
	containerOutInvalidContentBools=MapThread[
		Function[{model,containerOut},
			MatchQ[model,ObjectP[Model[Item]]]&&MatchQ[containerOut,ObjectP[Model[Container]]]
		],{
			Join[
				Lookup[productPackets,ProductModel,{}],
				If[doubleResolvedInternalOrderQ,models,{}]
			],
			Join[
				productContainerOuts,
				If[doubleResolvedInternalOrderQ,expandedModelContainerOuts,mergedModelContainerOuts]
			]
		}
	];

	(* If we are throwing messages, throw message about container out not being allowed for items *)
	If[!gatherTestsQ&&MemberQ[containerOutInvalidContentBools,True],
		Message[Error::ShippingOptionNotRequired,ContainerOut,PickList[Join[products, modelProducts,If[doubleResolvedInternalOrderQ,models,{}]],containerOutInvalidContentBools]]
	];

	(* If we are collecting tests, assemble test for container out being allowed only for samples *)
	containerContentsValidityTests=If[gatherTestsQ,
		MapThread[
			Test["ContainerOut is legally specified for "<>ToString[#2]<>". (Samples may have ContainerOut specified, items may not.):",
				#1,
				False
			]&,{containerOutInvalidContentBools,Join[products, If[doubleResolvedInternalOrderQ,models,modelProducts]]}]
	];

	(* Validate that the container out is big enough *)
	containerOutInvalidVolumeBools = MapThread[
		Function[{model,containerOut,amount,containerMaxVolume},
			Which[

				(* If the object is an item, we already gave an error, so don't error again here *)
				MatchQ[model,ObjectP[Model[Item]]],False,

				(* If container out is not specified, valid *)
				MatchQ[containerOut,Except[ObjectP[Model[Container]]]],False,

				(* If volume is not known, indeterminant *)
				MatchQ[amount,Except[VolumeP]],Null,

				(* If volume is specified and volume > container volume, invalid *)
				(amount > containerMaxVolume),True,

				(* If volume is specified and volume < container volume, valid *)
				(amount <= containerMaxVolume),False,

				(*Otherwise, valid *)
				True,False
			]
		],{
			Join[Lookup[productPackets,ProductModel,{}],If[doubleResolvedInternalOrderQ,models,{}]],
			Join[productContainerOuts, If[doubleResolvedInternalOrderQ,expandedModelContainerOuts,mergedModelContainerOuts]],
			Join[Lookup[productPackets,Amount,{}],If[doubleResolvedInternalOrderQ,modelAmounts,{}]],
			containerOutMaxVolumes
		}
	];

	(* If we are throwing messages, throw message about container out being too small *)
	If[!gatherTestsQ&&MemberQ[containerOutInvalidVolumeBools,True],
		Message[Error::VolumeExceedsContainerOut,
			PickList[Join[productContainerOuts, mergedModelContainerOuts, If[doubleResolvedInternalOrderQ,expandedModelContainerOuts,{}]],containerOutInvalidVolumeBools],
			PickList[Join[Lookup[productPackets, Amount, {}], If[doubleResolvedInternalOrderQ,Unitless[modelAmounts],{}]],containerOutInvalidVolumeBools],
			PickList[Join[products, modelProducts, If[doubleResolvedInternalOrderQ,models,{}]],containerOutInvalidVolumeBools]]
	];

	(* If we are throwing messages, throw message about not being able to validate that the container is large enough *)
	If[!gatherTestsQ&&MemberQ[containerOutInvalidVolumeBools,Null],
		Message[Warning::ContainerOutNotValidated,
			PickList[Join[products, modelProducts,If[doubleResolvedInternalOrderQ,models,{}]],containerOutInvalidVolumeBools,Null],
			PickList[Join[productContainerOuts, mergedModelContainerOuts, If[doubleResolvedInternalOrderQ,expandedModelContainerOuts,{}]],containerOutInvalidVolumeBools,Null]]
	];

	(* If we are collecting tests, assemble test for container out being too small *)
	containerVolumeValidityTests=If[gatherTestsQ,
		MapThread[
			Test["Sample volume does not exceed ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|Null
			]&,{containerOutInvalidVolumeBools,Join[products, If[doubleResolvedInternalOrderQ,models,modelProducts]]}]
	];

	(* If we are collecting tests, assemble test for container out being too small *)
	containerVolumeValidityWarnings=If[gatherTestsQ,
		MapThread[
			Warning["Sample volume is known and crosschecked with ContainerOut volume for "<>ToString[#2]<>":",
				#1,
				False|True
			]&,{containerOutInvalidVolumeBools,Join[products, If[doubleResolvedInternalOrderQ,models,modelProducts]]}]
	];

	(* If multiple of the same products are being ordered, make sure that they don't point to differing containerOuts, since products get collapsed down *)
	groupedProductsContainers = GatherBy[Transpose[{Download[Join[products, modelProducts],Object], Download[(Join[productContainerOuts, mergedModelContainerOuts]/.None->Null),Object]}], #[[1]] &];

	containerOutInconsistentIndexes =
		  Flatten[
			  MapIndexed[
				  If[Length[DeleteDuplicates[#[[All, 2]]]] > 1,
					  #2,
					  Nothing] &, groupedProductsContainers]
		  ];

	(* If we are throwing messages, throw message about container out being too small *)
	If[!gatherTestsQ&&!MatchQ[containerOutInconsistentIndexes,{}],
		Message[Error::ContainerOutInconsistent,
			DeleteDuplicates[Flatten[groupedProductsContainers[[containerOutInconsistentIndexes]][[All, All, 1]]]],
			groupedProductsContainers[[containerOutInconsistentIndexes]][[All,All,2]]
		]
	];

	containerOutInconsistentTests=If[gatherTestsQ,
		Map[
			Test["ContainerOut is consistent across all instances of the product "<>ToString[#[[1,1]]]<>":",
				Length[DeleteDuplicates[#[[All, 2]]]],
				1
			]&,groupedProductsContainers]
	];

	(* Only throw the invalid ContainerOut option once regardless of how many ways it is invalid *)
	If[!gatherTestsQ&&Or[!MatchQ[containerOutInconsistentIndexes,{}],MemberQ[containerOutInvalidVolumeBools,True],MemberQ[containerOutInvalidContentBools,True]],
		Message[Error::InvalidOption,ContainerOut]
	];

	(* If container out validation returned and error, stop here *)
	If[MemberQ[containerOutInvalidVolumeBools,True]||MemberQ[containerOutInvalidContentBools,True]||!MatchQ[containerOutInconsistentIndexes,{}],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,modelProductTests,containerContentsValidityTests,containerVolumeValidityTests,containerVolumeValidityWarnings,containerOutInconsistentTests}],
			Options->collapsedOptions,
			Preview->Null
		}]
	];

	(* -- rack error checking -- *)


	allInputContainers = Map[
		Which[
			(* if its already a container model, use that *)
		MatchQ[#, ObjectP[Model[Container]]],
			#,

			(* if it was a product use the DefaultContainerModel or DefaultContainerModel of the kit components *)
			MatchQ[#, ObjectP[Object[Product]]],
			Download[
				FirstCase[
					Flatten[{
						Download[#, {DefaultContainerModel}, Cache -> fullCache],
						Lookup[Replace[Download[#, KitComponents,  Cache -> fullCache],Null -> {}], DefaultContainerModel, {}]
					}],
					ObjectP[],
					Null
				],
				Object
			],

			(* if it was a model that could be in a container, check that *)
			MatchQ[#, ObjectP[Model[Sample]]],
			Module[{modelToProductLookup, actualProduct},
				modelToProductLookup = Transpose[{mergedModels,modelProductQuantityTuples[[All,1]]}]/.{mod:(ObjectP[]|Null), prod:(ObjectP[]|Null)}:>(Download[mod, Object]-> Download[prod, Object]);
				actualProduct = Download[#, Object]/.modelToProductLookup;

				If[MatchQ[actualProduct, ObjectP[Object[Product]]],
					Download[
						FirstCase[
							Flatten[{
								Download[actualProduct, DefaultContainerModel, Cache -> fullCache],
								Lookup[Replace[Download[actualProduct, KitComponents, Cache -> fullCache],Null -> {}], DefaultContainerModel, {}]
							}],
							ObjectP[],
							Null
						],
						Object
					],
					Null
				]
			],

			True,
			Null
		]&,
		myObjects
	];

	rackResult = If[Or[MatchQ[allInputContainers, {Null...}], MatchQ[doubleResolvedInternalOrderQ, True]],
		{{Rack -> Null, Container -> Null, InvalidRack -> Null, NoRacks -> Null}},
		Module[{modelContainerTuples, dimensions, footprints, selfStandings},

			(*{dimensions, footprints, selfStandings} = Transpose[Quiet[Download[allInputContainers, {Dimensions, Footprint, SelfStanding}, Cache -> fullCache], Download::FieldDoesntExist]];
			modelContainerTuples = DeleteDuplicatesBy[Transpose[{Download[allInputContainers, Object], dimensions, footprints, selfStandings, Lookup[expandedSafeOps, ShippedRack]}], First];*)

			{dimensions, footprints, selfStandings} = Transpose[Quiet[Download[Cases[allInputContainers, ObjectP[]], {Dimensions, Footprint, SelfStanding}, Cache -> fullCache], Download::FieldDoesntExist]];
			modelContainerTuples = DeleteDuplicatesBy[Transpose[{Cases[Download[allInputContainers, Object], ObjectP[]], dimensions, footprints, selfStandings, PickList[(Lookup[expandedSafeOps,ShippedRack]/.None-> Null),allInputContainers, ObjectP[]]}], First];

			Map[
				Function[
					modelContainerTuple,
					Which[
						(* if there is no container to check or it can stand on its own safe return *)
						Or[MatchQ[modelContainerTuple[[1]], Except[ObjectP[Model[Container]]]], MatchQ[modelContainerTuple[[4]], True]],
						{Rack -> Null, Container -> Null, InvalidRack -> Null, NoRacks -> Null},

						(* if the container model is not verified *)
						Or[MatchQ[modelContainerTuple[[1]], Except[ObjectP[Model[Container]]]], MatchQ[modelContainerTuple[[4]], True]],
						{Rack -> Null, Container -> Null, InvalidRack -> Null, NoRacks -> Null},

						(* if the container is not self standing and there are no dimensions we cant determine if there is a rack or not, if there is no rack this will delay receiving *)
						MatchQ[modelContainerTuple[[2]], (Null|{})],
						If[MatchQ[modelContainerTuple[[5]], ObjectP[]],
							{Rack -> Download[modelContainerTuple[[5]], Object], Container -> modelContainerTuple[[1]], InvalidRack -> Null, NoRacks -> Null},
							{Rack -> Null, Container -> modelContainerTuple[[1]], InvalidRack -> Null, NoRacks -> Null}
						],

						(* do the checks *)
						True,
						Module[{containerToCheck, modelDims, modelFootprint, selfStanding, rack,maxWidth, minWidth, maxDepth, minDepth, acceptableDimensionsPattern, goodRackBool},

							(* determine the dimensions acceptable tolerance *)
							{containerToCheck, modelDims, modelFootprint, selfStanding, rack} = modelContainerTuple;

							{maxWidth, minWidth, maxDepth, minDepth} = Lookup[
								DimensionsWithTolerance[
									modelDims,
									$PositionUpperTolerance,
									$PositionLowerTolerance
								],
								{MaxWidth, MinWidth, MaxLength, MinLength}
							];

							acceptableDimensionsPattern = Alternatives[
								{modelFootprint, _,_},
								{_, RangeP[minDepth, maxDepth], RangeP[minWidth,maxWidth]},
								{_, RangeP[minWidth,maxWidth], RangeP[minDepth, maxDepth]}
							];

							If[MatchQ[rack, ObjectP[Model[Container, Rack]]],
								(* 1. verify the current rack *)
								goodRackBool = MatchQ[Length[Cases[Lookup[Download[rack, Positions, Cache -> Cases[Flatten[rackPackets], PacketP[]]], {Footprint, MaxDepth, MaxWidth}], acceptableDimensionsPattern]], GreaterP[0]];
								If[MatchQ[goodRackBool, True],
									{Rack -> Download[rack, Object], Container -> containerToCheck, InvalidRack -> Null, NoRacks -> Null},
									{Rack -> Download[rack, Object], Container -> containerToCheck, InvalidRack -> True, NoRacks -> Null}
								],

								(* 2. search for another rack that is in lab already *)
								Module[{possibleRackPositions, matchingPosition},
									possibleRackPositions = rackFootprintsAndDimensions[];

									matchingPosition = SelectFirst[possibleRackPositions, MatchQ[{#[[2]], #[[3,1]], #[[3,2]]}, acceptableDimensionsPattern]&, {}];
									If[MatchQ[matchingPosition, {}],
										{Rack -> Null, Container -> containerToCheck, InvalidRack -> Null, NoRacks -> True},
										{Rack -> Null, Container -> containerToCheck, InvalidRack -> Null, NoRacks -> Null}
									]
								]
							]
						]
					]
				],
				modelContainerTuples
			]
		]
	];


	(* entries where a rack was required but the provided value was Null *)
	invalidRackRules = Select[rackResult, MatchQ[Lookup[#, InvalidRack], True]&];
	(* racks that were provided but don't actually work *)
	noRackRules = Select[rackResult, MatchQ[Lookup[#, NoRacks], True]&];


	If[Length[invalidRackRules]>0&&!gatherTestsQ,
		Message[Error::IncompatibleProvidedRackModel, Lookup[invalidRackRules, Rack], Lookup[invalidRackRules, Container]];
		Message[Error::InvalidOption,ShippedRack];
	];

	If[Length[noRackRules]>0&&!gatherTestsQ,
		Message[Error::NoCompatibleRack, Lookup[noRackRules, {Rack, Container}]];
		Message[Error::InvalidOption,ShippedRack];
	];

	(* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
	invalidRacksTest=If[gatherTestsQ,
		If[Length[invalidRackRules]>0,
			Test["The provided ShippedRack models are capable of supporting the Model[Container] they are matched with:",True,False],
			Test["The provided ShippedRack models are capable of supporting the Model[Container] they are matched with:",True,True]
		],
		Nothing
	];

	noRacksTest=If[gatherTestsQ,
		If[Length[noRackRules]>0,
			Test["An appropriate Model[Container, Rack] is able to be found for ordered container models that are not capable of standing unsupported:",True,False],
			Test["An appropriate Model[Container, Rack] is able to be found for ordered container models that are not capable of standing unsupported:",True,True]
		],
		Nothing
	];

	(* If there was an issue with the racks, fail *)
	If[MatchQ[Length[Flatten[{noRackRules, invalidRackRules}]],GreaterP[0]],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->Flatten[{safeOpsTests,validLengthTests,modelProductTests,modelProductCheckTests,doubleResolvedInternalOrderTest, {noRacksTest, invalidRacksTest}}],
			Options->collapsedOptions,
			Preview->Null
		}]
	];


	(* ----------------------------------- *)
	(* -- Generate actual order packets -- *)
	(* ----------------------------------- *)

	(* -- The next block is the real meat of this function -- *)
	(* We now may be in one of the following situations:
		1. InternalOrder -> True
			In this case, we'll generate order packet for the input models and products
		2. InternalOrder -> False
		 	In this case, we'll generate order packets for only products
			(with the input models converted to their preferred product)
	*)

	(* Fetch orders for any products needed
	(if InternalOrder -> True, modelProducts, modelProductQuantities, and modelPositions will be {}) *)
	productOrderPacketsReturn = generateProductOrderPackets[
		Join[products,If[!doubleResolvedInternalOrderQ,modelProducts,{}]],
		Join[productQuantities,If[!doubleResolvedInternalOrderQ,modelProductQuantities,{}]],
		(* Replace index-matched options with re-ordered option values that match
		the new input with models replaced by preferred products *)
		ReplaceRule[
			safeOps,
			{
				ContainerOut -> Join[productContainerOuts, mergedModelContainerOuts],
				Creator -> (Join[expandedProductCreators,mergedModelCreators]),
				InternalOrder -> doubleResolvedInternalOrderQ,
				Destination -> Join[expandedProductDestinations,mergedModelProductDestinations],
				ShippingSpeed -> Join[expandedProductShippingSpeeds,mergedModelProductShippingSpeeds],
				DependentProtocol -> (DeleteCases[ToList[#],None]&/@(Join[expandedProductDependentProtocols,mergedModelProductDependentProtocols])),
				DependentResource -> (DeleteCases[ToList[#],Null]&/@(Join[expandedProductDependentResources,mergedModelProductDependentResources])),
				Notebook -> (DeleteCases[#,Null]&/@(Join[expandedProductNotebooks,mergedModelProductNotebooks])),
				ShipToUser -> Join[expandedProductShipToUsers,mergedModelProductShipToUsers],
				ShippedRack -> Join[expandedProductShippedRacks, mergedModelShippedRacks],
				If[gatherTestsQ,
					Output->{Result,Tests},
					Output->Result
				]
			}
		]
	];

	(* -- set up for Non-Result return -- *)

	(* If gathering tests, productOrderPacketsReturn will be a tuple.
	Otherwise it will only return the result. *)
	{productOrderPackets, productTests} = If[gatherTestsQ,
		productOrderPacketsReturn,
		{productOrderPacketsReturn, {}}
	];

	allTests = Flatten[{
		safeOpsTests, validLengthTests, modelProductTests, modelProductCheckTests, {doubleResolvedInternalOrderTest},
		productTests, containerContentsValidityTests, containerVolumeValidityTests, containerVolumeValidityWarnings, containerOutInconsistentTests, invalidRacksTest, noRacksTest
	}];

	(* If order packet generation fails, return failures *)
	If[MatchQ[productOrderPackets, $Failed],
		Return[outputSpecification /. {Result -> $Failed, Tests -> allTests, Options -> collapsedOptions, Preview -> Null}]
	];

	(* If Result is not a member of the output specification,
	there are no further tests or option resolution (so we can return now). *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {Tests -> allTests, Options -> collapsedOptions, Preview -> Null}]
	];

	(* Model and product orders are distinct because we may be able to fulfill
	 an internal model order with multiple different products that are available in the lab *)
	modelOrderPackets = If[doubleResolvedInternalOrderQ,
		generateModelOrderPackets[
			models,
			modelAmounts,
			ReplaceRule[
				safeOps,
				{
					ContainerOut -> expandedModelContainerOuts,
					Creator -> expandedModelCreators,
					InternalOrder -> doubleResolvedInternalOrderQ,
					Destination -> expandedModelDestinations,
					ShippingSpeed -> expandedModelShippingSpeeds,
					DependentProtocol -> expandedModelDependentProtocols,
					DependentResource -> expandedModelDependentResources,
					Notebook -> expandedModelNotebooks,
					ShipToUser -> expandedModelShipToUsers,
					ShippedRack -> expandedModelShippedRacks
				}
			]
		],
		{}
	];

	(* Case out only the transaction packets because the packet generation functions
	may include change packets updating the dependent protocols *)
	allOrderPackets = Cases[
		Join[productOrderPackets,modelOrderPackets],
		PacketP[Object[Transaction,Order]]
	];

	(* create packets that get passed into UploadTransaction.  The key here is that we're adding the fields that UploadTransaction needs to Download from, but that we don't want to Upload *)
	transactionPacketsExtraFields = Map[
		Append[
			#,
			{
				DependentOrder -> Null,
				Products -> Lookup[#, Replace[Products], {}],
				ReceivedItems -> {},
				UserCommunications -> {},
				Notebook -> Lookup[#, Transfer[Notebook], Null]
			}
		]&,
		allOrderPackets
	];

	(* Set transactions to Pending *)
	orderStatusUpdates = UploadTransaction[
		transactionPacketsExtraFields,
		Pending,
		FastTrack->True,
		Upload->False,
		Email->resolvedEmailQ,
		Cache->fullCache
	];

	(* Join all update packets *)
	allUpdates = Join[productOrderPackets,modelOrderPackets,orderStatusUpdates];

	(* Upload all the packets if Upload -> True and return the order IDs *)
	result = If[TrueQ[Lookup[safeOps,Upload]],
		(
			allUploads = Upload[allUpdates];
			(*Only output order packets with Destinations*)
			DeleteDuplicates[Cases[allUploads,ObjectP[Object[Transaction,Order],Destination]]]
		),
		allUpdates
	];

	(* If a Developer is using OrderSamples outside a notebook and with Dev loaded, they may request we run SyncOrders after the order is placed *)
	If[TrueQ[Lookup[safeOps,SyncOrders]],

		(* Triple-check that we're allowed to do this. SyncOrders requires:
			1) Dev` is loaded
			2) $Notebook == Null
			3) We require the user to be a Developer
		*)
		If[
			And[
				MatchQ[$PersonID,ObjectP[Object[User,Emerald,Developer]]],
				NullQ[$Notebook],
				TrueQ[InternalInventory`Private`$SyncOrdersEnabled]
			],
			SyncOrders[],

			(* If SyncOrders->True but the above conditions weren't meant, throw an error but proceed with making the order *)
			Message[OrderSamples::SyncPermissionDenied]
		]
	];

	(* Return desired output *)
	outputSpecification/.{
		Preview -> Null,
		Options-> RemoveHiddenOptions[OrderSamples,collapsedOptions],
		Tests->allTests,
		Result->result
	}
];


(* ::Subsubsection::Closed:: *)
(*OrderSamplesOptions*)


DefineOptions[OrderSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {OrderSamples}
];


(* Singleton Input Overload *)
OrderSamplesOptions[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamplesOptions[{myObject},{myOrderAmount}, myOptions];

(* Mismatched input case *)
OrderSamplesOptions[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=OrderSamplesOptions[Table[myObject,{Length[myOrderAmounts]}],myOrderAmounts,myOptions];
OrderSamplesOptions[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamplesOptions[myObjects,Table[myOrderAmount,{Length[myObjects]}],myOptions];

(* Core Overload: return the options for this function *)
OrderSamplesOptions[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},ops:OptionsPattern[]]:=Module[
	{listedOps,outOps,options},

	(* get the options as a list *)
	listedOps=ToList[ops];

	outOps=DeleteCases[SafeOptions[OrderSamplesOptions,listedOps],(OutputFormat->_)| (Output->_)];

	options = OrderSamples[myObjects,myOrderAmounts,Join[outOps,{Output->Options}]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,OrderSamples],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*OrderSamplesPreview*)


DefineOptions[OrderSamplesPreview,
	SharedOptions :> {OrderSamples}
];

(* Singleton Input Overload *)
OrderSamplesPreview[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamplesPreview[{myObject},{myOrderAmount}, myOptions];

(* Mismatched input case *)
OrderSamplesPreview[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=OrderSamplesPreview[Table[myObject,{Length[myOrderAmounts]}],myOrderAmounts,myOptions];
OrderSamplesPreview[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=OrderSamplesPreview[myObjects,Table[myOrderAmount,{Length[myObjects]}],myOptions];

(* Core Overload: return the options for this function *)
OrderSamplesPreview[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},ops:OptionsPattern[]]:=Module[
	{listedOps,outOps},

	(* get the options as a list *)
	listedOps=ToList[ops];

	outOps=DeleteCases[SafeOptions[OrderSamplesPreview,listedOps],Output->_];

	OrderSamples[myObjects,myOrderAmounts,Join[outOps,{Output->Preview}]]

];


(* ::Subsubsection::Closed:: *)
(*ValidOrderSamplesQ*)


DefineOptions[ValidOrderSamplesQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {OrderSamples}
];

(* Singleton Input Overload *)
ValidOrderSamplesQ[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=ValidOrderSamplesQ[{myObject},{myOrderAmount}, myOptions];

(* Mismatched input case *)
ValidOrderSamplesQ[myObject:(ObjectP[Object[Product]]|ObjectP[Model]),myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=ValidOrderSamplesQ[Table[myObject,{Length[myOrderAmounts]}],myOrderAmounts,myOptions];
ValidOrderSamplesQ[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmount:(MassP|VolumeP|GreaterP[0,1]),myOptions:OptionsPattern[]]:=ValidOrderSamplesQ[myObjects,Table[myOrderAmount,{Length[myObjects]}],myOptions];

(* Core Overload: return the options for this function *)
ValidOrderSamplesQ[myObjects:{(ObjectP[Object[Product]]|ObjectP[Model])...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, orderSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for OrderSamples *)
	orderSamplesTests = OrderSamples[myObjects, myOrderAmounts, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[orderSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[myObjects, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{myObjects, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, orderSamplesTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidOrderSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidOrderSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidOrderSamplesQ"]

];


(* ::Subsubsection::Closed:: *)
(*preferredProductQuantities*)


DefineOptions[preferredProductQuantities,
	Options:>{
		{DependentResource->{},{}|{(Null|None|{}|ObjectP[Object[Resource,Sample]]|{ObjectP[Object[Resource,Sample]]..})..},"The list of resources dependent on the order this function is resolving products for."},
		CacheOption,
		OutputOption
	},
	SharedOptions :> {OrderSamples}
];

(* Function to decide the best product to order to fulfill a request for a certain amount of a model.
 	Outputs tuples of {preferred product, product quantity} *)
preferredProductQuantities[myModels:{ObjectP[Model]...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},ops:OptionsPattern[]]:=Module[
	{output,outputList,collectTestsQ,printMessagesQ,possibleModelProducts,notDeprecatedProducts,
		deprecatedTests,amountPerSamples,samplesPerItems,totalAmountPerProduct,
		compatibleUnitBooleanMasks,compatibleProducts,compatibleProductsTests,compatibleProductTotalAmounts,
		result,forSaleProducts,notForSaleTests,requiredResources,minNumSampsRequired,
		productQuantityTuples,adjustedProductQuantityTuples,resourcePackets,minAmountsRequired,
		adjustedTrimmedProductTuples,selectedProductTuples,selectLowestTuple,productQuantityTupleP,specifiedResources,
		listedModelProducts,resPacks,amountsAndNumberItemsPerSamples,safeOps,cache,
		modelStates, forSaleProductsCorrected, modelStatesList
	},

	(* Get your safe options *)
	(* call SafeOptions to make sure all options match pattern *)
 	safeOps = SafeOptions[preferredProductQuantities,ToList[ops]];

	(* From resolveTacoPreparationOptions's options, get Output value *)
	output = Lookup[safeOps,Output];
	outputList = ToList[output];
	collectTestsQ = MemberQ[outputList,Tests];
	cache = Lookup[safeOps,Cache];

	(* Print messages whenever we're not getting tests instead *)
	printMessagesQ = !collectTestsQ;

	(* If empty input given, return empty list *)
	If[MatchQ[myModels,{}],
		Return[output/.{Tests->{},Result->{}}]
	];

	(* Get the list of resources provided to the function *)
	specifiedResources = DeleteCases[
		Lookup[safeOps,DependentResource]/.{None->Null},
		Null
	];

	(* Gather any resources that are associated with this order *)
	requiredResources = Flatten@Download[
		specifiedResources,
		Object
	];

	(* Download information from all model's products needed to choose the best product  *)
	{listedModelProducts,resPacks,modelStatesList} = Quiet[Download[
		{myModels,requiredResources, myModels},
		{
			(* Info on products associated with the input models *)
			{
				Packet[Products[{Deprecated,NotForSale,NumberOfItems,Amount, Density}]],
				Packet[KitProducts[{Deprecated,NotForSale,KitComponents,NumberOfItems,Amount}]]
			},

			(* Info on resources *)
			{Packet[Object,Amount,Models]},

			{State}
		},
		Cache->cache
	],{Download::FieldDoesntExist}];

	(* Convert the previously listed packets into their expected shapes *)
	possibleModelProducts = Flatten/@listedModelProducts;
	resourcePackets = Flatten[#,1]&/@resPacks;
	modelStates = Flatten[modelStatesList];

	(* Select the non-deprecated products *)
	notDeprecatedProducts = Map[
		Function[{nextListOfProducts},
			Select[
				Flatten[nextListOfProducts],
				!TrueQ[Lookup[#,Deprecated]]&
			]
		],
		possibleModelProducts
	];

	(* Generate test for product's viability *)
	deprecatedTests = If[collectTestsQ,
		MapThread[
			Test[
				"The model "<>ToString[#1]<>" has products for sale that are not deprecated.",
				Length[#2],
				GreaterP[0]
			]&,
			{myModels,notDeprecatedProducts}
		],
		{}
	];

	(* If a product or a model's products are all deprecated, we cannot order them
	so return output early *)
	If[MemberQ[notDeprecatedProducts,{}],
		If[printMessagesQ,
			Message[OrderSamples::NoValidProducts,PickList[myModels,notDeprecatedProducts,{}]]
		];
		Return[output/.{Tests->deprecatedTests,Result->$Failed}]
	];

	(* Select the non-NotForSale products *)
	forSaleProducts = Map[
		Function[{nextListOfProducts},
			Select[
				nextListOfProducts,
				!TrueQ[Lookup[#,NotForSale]]&
			]
		],
		notDeprecatedProducts
	];

	(* Generate test for product's viability *)
	notForSaleTests = If[collectTestsQ,
		MapThread[
			Test[
				"The model "<>ToString[#1]<>" has products for sale that are not deprecated.",
				Length[#2],
				GreaterP[0]
			]&,
			{myModels,forSaleProducts}
		],
		{}
	];

	(* If a product or a model's products are all NotForSale, we cannot order them so return output early *)
	If[MemberQ[forSaleProducts,{}],
		If[printMessagesQ,
			Message[OrderSamples::NotForSale,PickList[myModels,forSaleProducts,{}]]
		];
		Return[output/.{Tests->Join[deprecatedTests,notForSaleTests],Result->$Failed}]
	];

	(* If we are checking liquid models and products that are sold as mass, replace the Amount in packets to Volume units *)
	forSaleProductsCorrected = MapThread[Function[{listOfProducts, askedAmount, stateX},
		If[
			(* working only with liquid model and Volume asked amount so we save a bit on calculation *)
			VolumeQ[askedAmount] && MatchQ[stateX, Liquid],
			Map[
				Module[{density, amount},
					Function[{product},
						amount = Lookup[product, Amount];
						density = Lookup[product, Density];

						(* if all conditions are met, replace Amount from mass to volume through Density *)
						If[
							MassQ[amount],
							Association[Join[{
								Map[# -> Lookup[product, #]&, DeleteCases[Keys[product], Amount]],
								Amount -> amount / density
							}]],
							(* otherwise, return the product packet as it was specified *)
							product
						]
					]
				],
				listOfProducts
			],
			(* if we are not working with liquid Model with requested Volume, return the packets *)
			listOfProducts
		]
	],
		{forSaleProducts, myOrderAmounts, modelStates}
	];

	(* Determine the minimum amount per model that could be used to satisfy the resources provided *)
	{minNumSampsRequired,minAmountsRequired} = If[MatchQ[resourcePackets,ListableP[PacketP[Object[Resource,Sample]]]],

		(* Find the greatest amount requested by a resource per model type, and default to the matching unit if no amount was found *)
		Module[
			{resourcesPerModel,amountsPerGrouping,maxAmountsRequired},

			(* Get the list of resources per model *)
			resourcesPerModel = Cases[
				resourcePackets,
				AssociationMatchP[<|Models->{___,ObjectP[#],___}|>,AllowForeignKeys->True]
			]&/@DeleteDuplicates[myModels];

			(* Determine the max amount required by any given resource *)
			amountsPerGrouping = Map[
				Function[
					{resourcePack},

					(* Null's in either Amount should default to 1 *)
					Lookup[resourcePack,Amount]/.Null->1
				],
				resourcesPerModel,
				{2}
			];

			(* Go through the list of amounts found. If any didn't have an amount, default to the unit of the amount in myOrderAmounts at the same index *)
			maxAmountsRequired=Table[
				If[
					(* If there were no amounts found for the model at index i *)
					MatchQ[amountsPerGrouping[[i]],{}],

					(* Take the units from myOrderAmounts at position i *)
					Units[myOrderAmounts[[i]]],

					(* Otherwise take the max of the amounts found *)
					Max[amountsPerGrouping[[i]]]
				],
				{i,Length[amountsPerGrouping]}
			];

			(* Return the counts of resource for a given model and the largest amount any resource of the model required *)
			{(Length/@amountsPerGrouping)/.{0->1},maxAmountsRequired}
		],

		(* Default to the units of myOrderAmounts *)
		{
			Table[1,Length[myModels]],
			Units[UnitScale[myOrderAmounts]]
		}
	];

	(* get Amount and NumberOfItems for all the valid products *)
	amountsAndNumberItemsPerSamples = MapThread[
		Function[{listOfProds,modelX},
			Map[
				Function[{prodPack},
					If[
						KeyExistsQ[prodPack,KitComponents],

						(* If the product we're dealing with is a Kit, find entry for the model we're dealing with and pull that out *)
						Module[{componentListing},

							(* Pull out the entry for the model we're looking at from the list of kit components *)
							componentListing = First@Cases[
								Lookup[prodPack,KitComponents],
								KeyValuePattern[ProductModel -> ObjectP[modelX]]
							];

							(* From the information about the amount of our model in this kit, pick out the Amount and NumberOfItems *)
							{
								Lookup[componentListing,Amount],
								Replace[Lookup[componentListing,NumberOfItems],Null->1]
							}
						],

						(* If we're not dealing with a kit, then just pull amount and number of items *)
						{
							Lookup[prodPack,Amount],
							Replace[Lookup[prodPack,NumberOfItems],Null->1]
						}
					]
				],
				listOfProds
			]
		],
		{forSaleProductsCorrected,myModels}
	];
	amountPerSamples = amountsAndNumberItemsPerSamples[[All,All,1]];
	samplesPerItems = amountsAndNumberItemsPerSamples[[All,All,2]];

	(* get the total sample amount in each item e.g: 200g*4 bottles = 800 g/ or if it's item, simply NumberOfItems *)
	totalAmountPerProduct = MapThread[
		MapThread[
			Function[{amountPerSample,numberOfSamples},
			(* If no unit, it is a self-contained sample or container.
			Therefore use the item count. *)
				If[NullQ[amountPerSample],
					numberOfSamples,
					(amountPerSample*numberOfSamples)
				]
			],
			{#1,#2}
		]&,
		{amountPerSamples,samplesPerItems}
	];

	(* Build lists of bools representing indicies for products that have amount units
	compatible with the desired amounts *)
	compatibleUnitBooleanMasks = MapThread[
		Function[{orderAmount,totalProductAmounts},
			CompatibleUnitQ[#,orderAmount]&/@totalProductAmounts
		],
		{myOrderAmounts,totalAmountPerProduct}
	];

	(* Filter out products with incompatible units *)
	compatibleProducts = MapThread[
		Download[PickList[#1,#2,True],Object]&,
		{forSaleProductsCorrected,compatibleUnitBooleanMasks}
	];

	compatibleProductsTests = If[collectTestsQ,
		MapThread[
			Test[
				"The specified amount, "<>ToString[#1]<>", is compatible with "<>ToString[#2]<>"'s associated products.",
				Length[#3],
				GreaterP[0]
			]&,
			{myModels,myOrderAmounts,compatibleProducts}
		],
		{}
	];

	(* check whether the product is valid to order, i,e, the given unit is compatible with the unit specified in the products *)
	If[MemberQ[compatibleProducts,{}],
		If[printMessagesQ,
			Message[OrderSamples::AmountUnit,PickList[myOrderAmounts,compatibleProducts,{}],PickList[myModels,compatibleProducts,{}]];
		];
		Return[output/.{Tests->Join[deprecatedTests,compatibleProductsTests],Result->$Failed}]
	];

	(* Filter out product amounts with incompatible units *)
	compatibleProductTotalAmounts = MapThread[
		PickList[#1,#2,True]&,
		{totalAmountPerProduct,compatibleUnitBooleanMasks}
	];

	(* Build a list of Tuples that are {product,totalAmountPerProduct,samplesPerProduct,amountPerSample} *)
	productQuantityTuples = MapThread[
		Transpose[List[#1,#2,#3,#4,#5]]&,
		{compatibleProducts,compatibleProductTotalAmounts,samplesPerItems,amountPerSamples/.{Null|None->1},totalAmountPerProduct}
	];
	productQuantityTupleP={
		ObjectP[],(* Product *)
		_, (* Original or scaled amount of material *)
		_Integer, (* Original or scaled number of samples *)
		_,(* Amount of material per one sample *)
		_(* Amount of material per one order of the product *)
	};

	(* ----- Must insert check to make sure I didn't just delete every product available *)
	(* This would indicate that there are no products whose samples have enough volume to satisfy a resource that was given to us *)

	(* Below is a tricky helper function designed to re-calculate the minimum amount that could be ordered for each product to satisfy
	the order being placed. This goes through each list of tuples of form {Product, TotalAmountPerProduct,SamplesPerProduct,MinSampleAmount}
	and adjusts the TotalAmountPerProduct and SamplesPerProduct to the minimum orderable amount that will satisfy the order being placed *)
	adjustedProductQuantityTuples[nextTuples:{productQuantityTupleP..},minSampRequired_Integer,minAmountRequired:(MassP|VolumeP|GreaterP[0,1])] := Map[
		Module[{productObj,totalAmountPerOneProduct,sampsPerProduct,amountPerSample,amountPerProduct,scalar},

			{productObj,totalAmountPerOneProduct,sampsPerProduct,amountPerSample,amountPerProduct}=#[[{1,2,3,4,5}]];

			(* Calculate how much we need to scale the tuple in order to have enough materials and samples *)
			(* This scalar is either (whichever is greater):
				- The number of products that would be required to fulfill the requested amount
				- The number of products that would fulfill the number of samples requrested by the dependent resources *)
			scalar = Max[{

				(* If resources were provided, calculate how many products we'd need to satisfy the sample requirement *)
				If[!GreaterEqual[sampsPerProduct,minSampRequired],
					Ceiling[minSampRequired/sampsPerProduct],
					1
				],

				(* Determine how many of the product we'd have to order to satisfy the requested amount *)
				Ceiling[minAmountRequired/totalAmountPerOneProduct]
			}];

			{productObj,totalAmountPerOneProduct*scalar,sampsPerProduct*scalar,amountPerSample,amountPerProduct}
		]&,
		nextTuples
	];

	adjustedTrimmedProductTuples = MapThread[adjustedProductQuantityTuples,{productQuantityTuples,minNumSampsRequired,myOrderAmounts}];

	(* Helper to sort each sublist and pick the one with the lowest required material amount *)
	selectLowestTuple[listOfTuples:{productQuantityTupleP..}]:=Module[
		{selectedTuple},
		(* Get the specific tuple that satisfies this order best *)
		selectedTuple=First[SortBy[listOfTuples,#[[2]]&]];

		(* Return a pair of product and one product's worth of material *)
		{selectedTuple[[1]],selectedTuple[[5]]}
	];

	(* Sort each list of tuples and take the one required ordering the least amount of material (the first one in the list after the Sort) *)
	selectedProductTuples=selectLowestTuple/@adjustedTrimmedProductTuples;

	(* Return tuples of {{preferred product, quantity}..} *)
	result = MapThread[
	(* Use Ceiling to purchase more than one item if needed *)
		{#1[[1]],Ceiling[#2/(#1[[2]])]}&,
		{selectedProductTuples,myOrderAmounts}
	];

	(* Return output in specified form *)
	output/.{Tests->Join[deprecatedTests,notForSaleTests,compatibleProductsTests],Result->result}
];


(* ::Subsubsection::Closed:: *)
(*generateModelOrderPackets*)


DefineOptions[generateModelOrderPackets,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."},
		{DependentProtocol->{},{{ObjectP[]...}...},"The protocols that depend on the ordering of a product."},
		{DependentResource->{},{{ObjectP[]...}...},"The resources that depend on the ordering of a product."},
		{Notebook -> {}, {{ObjectP[Object[LaboratoryNotebook]]...}...}, "The notebook assigned to each product."}
	},
	SharedOptions:>{OrderSamples}
];

(* Helper function to generate order packets when ordering models *)
generateModelOrderPackets[myModels:{ObjectP[Model]...},myOrderAmounts:{(MassP|VolumeP|GreaterP[0,1])...},myOptions:OptionsPattern[]]:=Module[
	{groupedOrderTuples,orderModels,orderAmounts,orderDestinations,orderShippingSpeeds,
		orderShipToUsers,orderDependentResources,containerOuts,orderNotebooks,orderCreators, shippedRacks},

(* If no products, return empty list early *)
	If[MatchQ[myModels,{}],
		Return[{}]
	];

	(* Group by:
		- Destination
		- ShippingSpeed
		- ShipToUser
		- Notebook
	*)
	groupedOrderTuples = GatherBy[
		Transpose[{
			(* 1 *)myModels,
			(* 2 *)myOrderAmounts,
			(* 3 *)Lookup[myOptions,Destination],
			(* 4 *)Lookup[myOptions,ShippingSpeed],
			(* 5 *)Lookup[myOptions,ShipToUser],
			(* 6 *)Lookup[myOptions,DependentResource],
			(* 7 *)Lookup[myOptions,Notebook],
			(* 8 *)Lookup[myOptions,ContainerOut],
			(* 9 *)Lookup[myOptions,Creator],
			(* 10 *)(Lookup[myOptions, ShippedRack]/.None-> Null)
		}],
		#[[{3,4,5,7,9}]]&
	];

	(* Extract values for each distinct order *)
	orderModels = groupedOrderTuples[[All,All,1]];
	(* convert any Integers into Unit *)
	orderAmounts = Map[If[MatchQ[#, _Integer], #*Unit, # ] & , groupedOrderTuples[[All,All,2]],{2}];
	orderDestinations = First/@(groupedOrderTuples[[All,All,3]]);
	orderShippingSpeeds = First/@(groupedOrderTuples[[All,All,4]]);
	orderShipToUsers = First/@(groupedOrderTuples[[All,All,5]]);
	(* If an order has no dependent resources, option value will be None *)
	orderDependentResources = DeleteCases[#,None]&/@(groupedOrderTuples[[All,All,6]]);
	orderNotebooks = First/@groupedOrderTuples[[All,All,7]];
	containerOuts = groupedOrderTuples[[All,All,8]];
	orderCreators = First/@groupedOrderTuples[[All,All,9]];
	shippedRacks = First/@groupedOrderTuples[[All,All,10]];

	(* Construct order packets for model orders *)
	MapThread[
		Function[{models,amounts,destination,speed,shipToUser,dependentResources,containerOut,notebookX,creatorX, rack},
			Association[
				Object->CreateID[Object[Transaction,Order]],
				Type->Object[Transaction,Order],
				Creator->Link[creatorX,TransactionsCreated],
				Transfer[Notebook] -> Link[notebookX,Objects],
				RequestedAutomatically->Lookup[myOptions,Autogenerated],
				Destination->Link[destination],
				ShippingSpeed->speed,
				ShipToUser->shipToUser,
				InternalOrder -> Lookup[myOptions,InternalOrder],
				Replace[Resources] -> Link[dependentResources,Order],
				Replace[OrderedModels] -> Link[models],
				Replace[OrderAmounts]->amounts,
				Replace[TransferObjects]->Link[MapThread[If[MatchQ[#2,Null],Nothing,#1]&,{models,containerOut}]],
				Replace[TransferContainers]->Link[(containerOut/.Null->Nothing)],
				ReceivingTolerance -> Lookup[myOptions,ReceivingTolerance],
				If[MatchQ[rack, ObjectP[]],
					Replace[ShippedRacks]-> {Link[rack/.(None-> Null)]},
					Nothing
				]
			]
		],
		{
			orderModels,
			orderAmounts,
			orderDestinations,
			orderShippingSpeeds,
			orderShipToUsers,
			orderDependentResources,
			containerOuts,
			orderNotebooks,
			orderCreators,
			shippedRacks
		}
	]
];


(* ::Subsubsection::Closed:: *)
(*generateProductOrderPackets*)


DefineOptions[generateProductOrderPackets,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."},
		{DependentProtocol->{},{{ObjectP[]...}...},"The protocols that depend on the ordering of a product."},
		{DependentResource->{},{{ObjectP[]...}...},"The resources that depend on the ordering of a product."},
		{Notebook -> {}, {{ObjectP[Object[LaboratoryNotebook]]...}...}, "The notebook assigned to each product."}
	},
	SharedOptions:>{OrderSamples}
];

(* Helper function to generate order packets when ordering a product *)
generateProductOrderPackets[myProducts:{ObjectP[Object[Product]]...},myOrderQuantities:{GreaterP[0,1]...},myOptions:OptionsPattern[]]:=Module[
	{output,outputList,collectTestsQ,printMessagesQ,productPackets,allTests,productCatalogNumbers,
		suppliers,groupedOrderTuples,orderSuppliers,orderProducts,orderDestinations,orderShippingSpeeds,
		orderShipToUsers,orderDependentResources,orderDependentProtocols,mergedProductTuples,
		orderPackets,protocolUpdatePackets,result,orderDependentNotebooks,orderCreators, shippedRacks},

(* From resolveTacoPreparationOptions's options, get Output value *)
	output = OptionDefault[OptionValue[Output]];
	outputList = ToList[output];
	collectTestsQ = MemberQ[outputList,Tests];

	(* Print messages whenever we're not getting tests instead *)
	printMessagesQ = !collectTestsQ;

	(* If no products, return empty list early *)
	If[MatchQ[myProducts,{}],
		Return[output/.{Tests->{},Result->{}}]
	];

	(* Fetch information required from product objects *)
	productPackets = Download[
		myProducts,
		Packet[CatalogNumber,Supplier,Deprecated,NotForSale],
		Cache -> Lookup[myOptions,Cache]
	];

	(* check the validity of the products before generating orders *)
	If[!Lookup[myOptions,FastTrack],
		Module[
			{uniqueProducts,validObjectQBools,voqTests,invalidProducts,deprecatedTests,deprecatedProducts,
			notForSaleTests,notForSaleProducts},

		(* Remove any duplicate products *)
			uniqueProducts = DeleteDuplicates[myProducts];

			(* Run VOQ against all products *)
			validObjectQBools = ValidObjectQ[uniqueProducts,Verbose->False,OutputFormat->Boolean];

			(* Generate test for product's validity *)
			voqTests = If[collectTestsQ,
				MapThread[
					Test[
						"The product "<>ToString[#1]<>" is a valid object.",
						#2,
						True
					]&,
					{uniqueProducts,validObjectQBools}
				],
				{}
			];

			(* identify any products that do not pass VOQ *)
			invalidProducts = PickList[uniqueProducts,validObjectQBools,False];

			(* If there are any invalid objects, throw a message but still go through with the order *)
			If[MatchQ[invalidProducts,{ObjectP[Object[Product]]..}],
				If[printMessagesQ,
					Message[OrderSamples::InvalidProduct,Download[invalidProducts,Object]];
				];
				Return[output/.{Tests->voqTests,Result->$Failed}]
			];

			(* Generate test for product's viability *)
			deprecatedTests = If[collectTestsQ,
				Map[
					Test[
						"The product "<>ToString[#1]<>" is not deprecated.",
						Lookup[#,Deprecated],
						False|Null
					]&,
					productPackets
				],
				{}
			];

			(* Generate test for the product's purchasibility.*)
			(* Products that have NotForSale -> True cannot be purchased since they are non-commerical and/or for internal use only *)
			notForSaleTests = If[collectTestsQ,
				Map[
					Test[
						"The product "<>ToString[#1]<>" can be purchased from the ECL facility.",
						Lookup[#,NotForSale],
						False|Null
					]&,
					productPackets
				],
				{}
			];

			(* Join all tests *)
			allTests = Join[voqTests,deprecatedTests,notForSaleTests];

			(* identify any deprecated products *)
			deprecatedProducts = Download[
				Select[productPackets,TrueQ[Lookup[#,Deprecated]]&],
				Object
			];

			(* if there are any deprecated products, then throw a message and return $Failed *)
			If[MatchQ[deprecatedProducts,{ObjectP[Object[Product]]..}],
				If[printMessagesQ,
					Message[OrderSamples::Deprecated,deprecatedProducts];
				];
				Return[output/.{Tests->allTests,Result->$Failed}]
			];

			(* identify any NotForSale products *)
			notForSaleProducts = Download[
				Select[productPackets,TrueQ[Lookup[#,NotForSale]]&],
				Object
			];

			(* if there are any NotForSale products, then throw a message and return $Failed *)
			If[MatchQ[notForSaleProducts,{ObjectP[Object[Product]]..}],
				If[printMessagesQ,
					Message[OrderSamples::NotForSale,notForSaleProducts];
				];
				Return[output/.{Tests->allTests,Result->$Failed}]
			]
		]
	];

	(* Extract catalog numbers for the order *)
	productCatalogNumbers = Map[
		If[NullQ[Lookup[#,CatalogNumber]],
			"",
			Lookup[#,CatalogNumber]
		]&,
		productPackets
	];

	(* Fetch supplier from each product *)
	suppliers = Download[Lookup[productPackets,Supplier],Object];

	(* Group by:
		- Supplier (multiple products from the same supplier can be merged into one order)
		- Destination
		- ShippingSpeed
		- ShipToUser
		- Notebook
	*)
	groupedOrderTuples = GatherBy[
		Transpose[{
			(* 1 *)suppliers,
			(* 2 *)Download[myProducts,Object],
			(* 3 *)myOrderQuantities,
			(* 4 *)productCatalogNumbers,
			(* 5 *)Lookup[myOptions,Destination],
			(* 6 *)Lookup[myOptions,ShippingSpeed],
			(* 7 *)Lookup[myOptions,ShipToUser],
			(* 8 *)Lookup[myOptions,DependentProtocol],
			(* 9 *)Lookup[myOptions,DependentResource],
			(* 10 *)Lookup[myOptions,Notebook],
			(* 11 *)Lookup[myOptions,ContainerOut],
			(* 12 *)Lookup[myOptions,Creator],
			(* 13 *)(Lookup[myOptions, ShippedRack]/.None-> Null)
		}],
		#[[{1,5,6,7,10,12}]]&
	];

	(* Extract values for each distinct order *)
	orderSuppliers = First/@(groupedOrderTuples[[All,All,1]]);
	orderProducts = groupedOrderTuples[[All,All,2]];
	orderDestinations = First/@(groupedOrderTuples[[All,All,5]]);
	orderShippingSpeeds = First/@(groupedOrderTuples[[All,All,6]]);
	orderShipToUsers = First/@(groupedOrderTuples[[All,All,7]]);
	orderDependentProtocols = groupedOrderTuples[[All,All,8]];
	orderDependentResources = Flatten/@(groupedOrderTuples[[All,All,9]]);
	orderDependentNotebooks = First/@(groupedOrderTuples[[All,All,10]]);
	orderCreators = First/@(groupedOrderTuples[[All,All,12]]);
	shippedRacks = First/@(groupedOrderTuples[[All,All,13]]);

	(* For each distinct order, merge the quantity of identical products into the form:
	 	{
			order1:{{product1, total amount 1, catalog number 1}, {product2, total amount 2, catalog number 2}},
			order2 ..
		} *)
	mergedProductTuples = MapThread[
		Function[{products,quantities,catalogNumbers,containerOuts},
			Module[{gatheredTuples},

			(* Gather duplicate products into tuples of form:
				 {{product1,amount1, catalognumber1,containerOut},{product1,amount2,catalognumber1,containerOut}} *)
				gatheredTuples = GatherBy[Transpose[{products,quantities,catalogNumbers,containerOuts}],#[[1]]&];

				(* Merge quantities of identical products into tuples of form:
				 	{product1, total-amount, catalog number,containerOuts} *)
				Map[
					{#[[1,1]],Total[#[[All,2]]],#[[1,3]],#[[1,4]]}&,
					gatheredTuples
				]
			]
		],
		{groupedOrderTuples[[All,All,2]],groupedOrderTuples[[All,All,3]],groupedOrderTuples[[All,All,4]],groupedOrderTuples[[All,All,11]]}
	];

	(* Construct order packets from merged products *)
	orderPackets = MapThread[
		Function[{products,quantities,catalogNumbers,supplier,destination,speed,shipToUser,dependentResources,containerOuts,notebookX,creatorX, rack},
			Association[
				Object->CreateID[Object[Transaction,Order]],
				Type->Object[Transaction,Order],
				Creator->Link[creatorX,TransactionsCreated],
				Transfer[Notebook] -> Link[notebookX,Objects],
				RequestedAutomatically->Lookup[myOptions,Autogenerated],
				Destination->Link[destination],
				Supplier->Link[supplier,Transactions],
				Replace[CatalogNumbers]->catalogNumbers,
				Replace[Products]->Link[products,Orders],
				Replace[OrderQuantities]->quantities,
				Replace[QuantitiesOutstanding]->quantities,
				Replace[QuantitiesReceived]->ConstantArray[0,Length[quantities]],
				ShippingSpeed->speed,
				ShipToUser->shipToUser,
				InternalOrder -> Lookup[myOptions,InternalOrder],
				Replace[Resources] -> Link[dependentResources,Order],
				Replace[TransferObjects]->Link[MapThread[If[MatchQ[#2,Null],Nothing,#1]&,{products,containerOuts}]],
				Replace[TransferContainers]->Link[(containerOuts/.Null->Nothing)],
				ReceivingTolerance -> Lookup[myOptions,ReceivingTolerance],
				If[MatchQ[rack, ObjectP[]],
					Replace[ShippedRacks]-> {Link[rack/.(None-> Null)]},
					Nothing
				]
			]
		],
		{
			mergedProductTuples[[All,All,1]],
			mergedProductTuples[[All,All,2]],
			mergedProductTuples[[All,All,3]],
			orderSuppliers,
			orderDestinations,
			orderShippingSpeeds,
			orderShipToUsers,
			orderDependentResources,
			mergedProductTuples[[All,All,4]],
			orderDependentNotebooks,
			orderCreators,
			shippedRacks
		}
	];

	(* For each order, there are multiple products, for each product, there may be a dependent protocols.
	Build a list of updates for each product/order tuple that a protocol depends on *)
	protocolUpdatePackets = Flatten@MapThread[
		Function[{orderObject,products,dependentProtocols},
		(* Map over each product <-> dependentProtocol pair *)
			MapThread[
				Function[{product,protocolsForProduct},
					Map[
						Association[
							Object -> #,
							Append[ShippingMaterials] -> {{Link[orderObject,DependentProtocols],Link[product]}}
						]&,
						protocolsForProduct
					]
				],
				{products,dependentProtocols}
			]
		],
		{Lookup[orderPackets,Object],orderProducts,orderDependentProtocols}
	];

	(* Join all packets *)
	result = Join[orderPackets,protocolUpdatePackets];

	(* Return output in specified form *)
	output/.{Tests->allTests,Result->result}
];


(* ::Subsection::Closed:: *)
(*RestrictSamples*)


(* ::Subsubsection::Closed:: *)
(*RestrictSamples*)


DefineOptions[RestrictSamples,
	Options:>{
		{
			OptionName -> UpdatedBy,
			Default -> Automatic,
			Description -> "The person or protocol responsible for restricting these samples.",
			ResolutionDescription -> "Automatically resolves to whichever user is logged in.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[User], Object[Protocol], Object[Maintenance], Object[Qualification]}]
			]
		},
		OutputOption,
		UploadOption
	}
];

(* Singleton Input Overload *)
RestrictSamples[mySample:ObjectP[{Object[Sample], Object[Container],Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=RestrictSamples[{mySample}, ops];

(* Core Overload: Listed Input - Populate Restricted *)
RestrictSamples[mySamples:{ObjectP[{Object[Sample], Object[Container],Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests,
		optionsRule, previewRule, testsRule, resultRule,safeOptionsMinusHiddenOptions, updatedBy,
		resolvedUpdatedBy, resolvedOptionsNoHidden, upload, changePackets, fluidContainers, fluidContents},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[ops];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[RestrictSamples, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[RestrictSamples, listedOptions, AutoCorrect->False], Null}
	];

	(* If the specified options don't match their patterns, return $Faield*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* pull out the fluid containers from the input *)
	fluidContainers = Cases[mySamples, FluidContainerP];

	(* Download the contents *)
	fluidContents = Download[fluidContainers, Contents[[All, 2]]];

	(* get the Upload option *)
	upload = Lookup[safeOptions, Upload];

	(* get all the safe options without the hidden options *)
	safeOptionsMinusHiddenOptions = RemoveHiddenOptions[RestrictSamples,safeOptions];

	(* pull out the UpdatedBy option *)
	updatedBy = Lookup[safeOptionsMinusHiddenOptions, UpdatedBy];

	(* if UpdatedBy is Automatic, resolve to $PersonID *)
	resolvedUpdatedBy = Download[If[MatchQ[updatedBy, Automatic],
		$PersonID,
		updatedBy
	], Object];

	(* get the resolved options *)
	resolvedOptionsNoHidden = ReplaceRule[safeOptionsMinusHiddenOptions, {UpdatedBy -> resolvedUpdatedBy}];

	(* --- Generate rules for each possible Output value --- *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Prepare the Preview result; this will always be Null in this case *)
	previewRule = Preview -> Null;

	(* Prepare the Tests result; the only tests here are for SafeOptions *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		safeOptionTests,
		Null
	];

	(* put the change packets together *)
	changePackets = Map[
		<|
			Object->#,
			Restricted->True,
			Append[RestrictedLog] -> {{Now, True, Link[resolvedUpdatedBy]}},

			If[MatchQ[#,ObjectP[Object[Sample]]],
				Append[SampleHistory]->{
					Restricted[<|
						Date->Now,
						ResponsibleParty->resolvedUpdatedBy
					|>]
				},
				Nothing
			]
		|>&,
		Download[Flatten[{mySamples, fluidContents}], Object]
	];

	(* Prepare the standard result if we were asked for it *)
	resultRule = Result -> If[MemberQ[output, Result],
		If[upload,
			Upload[changePackets],
			changePackets
		],
		Null
	];

	(* return the output based on what was requested *)
	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}

];


(* ::Subsubsection::Closed:: *)
(*RestrictSamplesOptions*)


DefineOptions[RestrictSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {RestrictSamples}
];

(* Singleton Input Overload *)
RestrictSamplesOptions[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=RestrictSamplesOptions[{mySample}, ops];

(* Core Overload: return the options for this function *)
RestrictSamplesOptions[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions,(OutputFormat->_)| (Output->_)];

	(* return only the options for RestrictSamples *)
	options = RestrictSamples[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,RestrictSamples],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*RestrictSamplesPreview*)


DefineOptions[RestrictSamplesPreview,
	SharedOptions :> {RestrictSamples}
];

(* Singleton Input Overload *)
RestrictSamplesPreview[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=RestrictSamplesPreview[{mySample}, ops];

(* Core Overload: return the options for this function *)
RestrictSamplesPreview[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for RestrictSamples *)
	RestrictSamples[mySamples, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsubsection::Closed:: *)
(*ValidRestrictSamplesQ*)


DefineOptions[ValidRestrictSamplesQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {RestrictSamples}
];

(* Singleton Input Overload *)
ValidRestrictSamplesQ[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=ValidRestrictSamplesQ[{mySample}, ops];

(* Core Overload: return the options for this function *)
ValidRestrictSamplesQ[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, restrictSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for RestrictSamples *)
	restrictSamplesTests = RestrictSamples[mySamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[restrictSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[mySamples, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{mySamples, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, restrictSamplesTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidRestrictSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidRestrictSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidRestrictSamplesQ"]

];


(* ::Subsection::Closed:: *)
(*UnrestrictSamples*)


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamples*)


DefineOptions[UnrestrictSamples,
	Options:>{
		{
			OptionName -> UpdatedBy,
			Default -> Automatic,
			Description -> "The person or protocol responsible for unrestricting these samples.",
			ResolutionDescription -> "Automatically resolves to whichever user is logged in.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[User], Object[Protocol], Object[Maintenance], Object[Qualification]}]
			]
		},
		OutputOption,
		UploadOption
	}
];

(* Singleton Input Overload *)
UnrestrictSamples[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=UnrestrictSamples[{mySample}, ops];

(* Core Overload: Listed Input - Populate Restricted *)
UnrestrictSamples[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests,
		optionsRule, previewRule, testsRule, resultRule, safeOptionsMinusHiddenOptions, updatedBy, resolvedUpdatedBy,
		resolvedOptionsNoHidden, upload, changePackets, fluidContainers, fluidContents},

	(* make sure we're working with a list of options *)
	listedOptions = ToList[ops];

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UnrestrictSamples, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UnrestrictSamples, listedOptions, AutoCorrect->False], Null}
	];

	(* If the specified options don't match their patterns, return $Faield*)
	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* pull out the fluid containers from the input *)
	fluidContainers = Cases[mySamples, FluidContainerP];

	(* Download the contents *)
	fluidContents = Download[fluidContainers, Contents[[All, 2]]];

	(* pull out the Upload option *)
	upload = Lookup[safeOptions, Upload];

	(* get all the safe options without the hidden options *)
	safeOptionsMinusHiddenOptions = RemoveHiddenOptions[UnrestrictSamples,safeOptions];

	(* pull out the UpdatedBy option *)
	updatedBy = Lookup[safeOptionsMinusHiddenOptions, UpdatedBy];

	(* if UpdatedBy is Automatic, resolve to $PersonID *)
	resolvedUpdatedBy = If[MatchQ[updatedBy, Automatic],
		$PersonID,
		updatedBy
	];

	(* get the resolved options *)
	resolvedOptionsNoHidden = ReplaceRule[safeOptionsMinusHiddenOptions, {UpdatedBy -> resolvedUpdatedBy}];

	(* --- Generate rules for each possible Output value --- *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* Prepare the Preview result; this will always be Null in this case *)
	previewRule = Preview -> Null;

	(* Prepare the Tests result; the only tests here are for SafeOptions *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		safeOptionTests,
		Null
	];

	(* gather the change packets *)
	changePackets = Map[
		<|
			Object -> #,
			Restricted -> False,
			Append[RestrictedLog] -> {{Now, False, Link[resolvedUpdatedBy]}},

			If[MatchQ[#,ObjectP[Object[Sample]]],
				Append[SampleHistory]->{
					Unrestricted[<|
						Date->Now,
						ResponsibleParty->resolvedUpdatedBy
					|>]
				},
				Nothing
			]
		|>&,
		Download[Flatten[{mySamples, fluidContents}], Object]
	];

	(* Prepare the standard result if we were asked for it *)
	resultRule = Result -> If[MemberQ[output, Result],
		If[upload,
			Upload[changePackets],
			changePackets
		],
		Null
	];

	(* return the output based on what was requested *)
	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}

];


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamplesOptions*)


DefineOptions[UnrestrictSamplesOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"Protocol"
		}
	},
	SharedOptions :> {UnrestrictSamples}
];

(* Singleton Input Overload *)
UnrestrictSamplesOptions[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=UnrestrictSamplesOptions[{mySample}, ops];

(* Core Overload: return the options for this function *)
UnrestrictSamplesOptions[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions,(OutputFormat->_)| (Output->_)];

	(* return only the options for UnrestrictSamples *)
	options = UnrestrictSamples[mySamples, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,UnrestrictSamples],
		options
	]


];


(* ::Subsubsection::Closed:: *)
(*UnrestrictSamplesPreview*)


DefineOptions[UnrestrictSamplesPreview,
	SharedOptions :> {UnrestrictSamples}
];

(* Singleton Input Overload *)
UnrestrictSamplesPreview[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=UnrestrictSamplesPreview[{mySample}, ops];

(* Core Overload: return the options for this function *)
UnrestrictSamplesPreview[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for UnrestrictSamples *)
	UnrestrictSamples[mySamples, Append[noOutputOptions, Output -> Preview]]

];


(* ::Subsubsection::Closed:: *)
(*ValidUnrestrictSamplesQ*)


DefineOptions[ValidUnrestrictSamplesQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UnrestrictSamples}
];

(* Singleton Input Overload *)
ValidUnrestrictSamplesQ[mySample:ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}], ops:OptionsPattern[]]:=ValidUnrestrictSamplesQ[{mySample}, ops];

(* Core Overload: return the options for this function *)
ValidUnrestrictSamplesQ[mySamples:{ObjectP[{Object[Sample], Object[Container], Object[Item], Object[Part], Object[Sensor], Object[Plumbing], Object[Wiring]}]...}, ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, restrictSamplesTests, initialTestDescription, allTests, verbose, outputFormat},

(* get the options as a list *)
	listedOptions = ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for UnrestrictSamples *)
	restrictSamplesTests = UnrestrictSamples[mySamples, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[restrictSamplesTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

		(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[mySamples, OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{mySamples, validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, restrictSamplesTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidUnrestrictSamplesQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUnrestrictSamplesQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUnrestrictSamplesQ"]

];


(* ::Subsubsection::Closed:: *)
(*rackFootprintsAndDimensions*)

(* generate a list of rack/footprint/position tuples to see if any are valid positions for a given container *)

rackFootprintsAndDimensions[]:= rackFootprintsAndDimensions[] = Module[{searchResult, rackPositions},
	searchResult = Search[Model[Container, Rack], Length[Objects]>0&&Deprecated!=True&&Length[Positions]>0];
	rackPositions = Download[searchResult, Positions];

	(* make tuples of the form {rack, footprint, dimensions}, deleteduplicates *)
	MapThread[
		Module[{footprint, width, depth, height, dimensionTuples},
			{footprint, width, depth, height} = Transpose[Lookup[#2, {Footprint, MaxWidth, MaxDepth, MaxHeight}]];
			dimensionTuples = Transpose[{width, depth, height}];

			Sequence@@DeleteDuplicates[Transpose[{ConstantArray[#1, Length[footprint]], footprint, dimensionTuples}]]
		]&,
		{searchResult, rackPositions}
	]
];

(* ::Subsubsection::Closed:: *)
(*determineFragileFromPacket*)
determineFragileFromPacket[myPacket:Alternatives[Null, {Null}, PacketP[], {PacketP[]}]] := Module[{fragile, wettedMaterials, containerMaterials, packet, type},

	(* If we don't have a packet input, return False. That means we should look at other object anyway *)
	If[NullQ[myPacket],
		Return[False]
	];

	(* Correct the input. It could be {packet} or packet *)
	packet = If[MatchQ[myPacket, {PacketP[]}],
		First[myPacket],
		myPacket
	];

	(* Extract these three field values *)
	{fragile, wettedMaterials, containerMaterials, type} = Lookup[packet, {Fragile, WettedMaterials, ContainerMaterials, Type}];

	Which[
		(* Always treat columns as Fragile and request wrapping *)
		MatchQ[type, TypeP[Model[Item, Column]]],
			True,
		(* If fragile field is populated, use it *)
		BooleanQ[fragile],
			fragile,
		(* If Fragile field is not populated, determine from the ContainerMaterials field for containers *)
		MatchQ[containerMaterials, _List],
			Or@@(MemberQ[containerMaterials, #]& /@ {Glass, SilicateGlass, GlassFiber, BorosilicateGlass, Quartz, Silicone, Silica, GlassyCarbon, Graphite, OpticalGlass, Porcelain, UVQuartz, ESQuartz, FusedQuartz, IRQuartz}),
		(* For other items which ContainerMaterials field doesn't exist, look at WettedMaterials field instead *)
		MatchQ[wettedMaterials, _List],
			Or@@(MemberQ[containerMaterials, #]& /@ {Glass, SilicateGlass, GlassFiber, BorosilicateGlass, Quartz, Silicone, Silica, GlassyCarbon, Graphite, OpticalGlass, Porcelain, UVQuartz, ESQuartz, FusedQuartz, IRQuartz}),
		(* Catch All. Be on the safe side and use True if for any reason we get to this step *)
		True,
			True
	]
];