(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

Error::CannotFindUploadFunction = "Function was not able to find one single Upload function for the input(s) `1`. This is either because the Upload function is not defined in $ObjectBuilders, or the input objects have multiple Types which requires different Upload functions. Please double check your input.";
Error::CannotFindVerificationFunction = "Function was not able to find verification function for the input(s) `1`. This is either because the Verification function is not yet defined, or it's not present in $VerificationFunctionLookupAssoc. Please check the code base and make changes accordingly.";
Error::ObjectFailedPreCheck = "Because the input object(s) `1` failed the pre-checks, your changes will not be uploaded. Please check other error messages and address the problems accordingly. If you believe the pre-check failures no longer applies, Re-run the function with BypassVerificationPreCheck -> True.";

(* ::Subsubsection::Closed:: *)
(* VerifyObjects *)
Authors[VerifyObjects] := {"hanming.yang"};

(* Define the association that converts Upload function to verification function *)
$VerificationFunctionLookupAssoc = <|
	UploadMolecule -> ECL`UploadVerifiedMolecule,
	UploadSampleModel -> ECL`UploadVerifiedSampleModel,
	UploadContainerModel -> ECL`UploadVerifiedContainerModel
|>;

(* DefineOption call. We want AllowNull -> True for all options, because we'll assign Null value for all irrelevent options *)

DefineOptions[
	VerifyObjects,
	Options :> {
		ExternalUploadHiddenOptions,
		VerifyOption,
		AllowWarningsOption,
		SimulationOption,
		{
			OptionName -> BypassVerificationPreCheck,
			Default -> False,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description->"Indicates if pre-checks on the input objects should be skipped. Pre-checks are a series of tests run before running the verification function. If pre-checks fail, your changes will not be uploaded.",
			Category -> "General"
		}
	},
	SharedOptions :> {
		ModifyOptions[UploadVerifiedContainerModel, AllowNull -> True, HideNull -> True],
		ModifyOptions[UploadVerifiedMolecule, AllowNull -> True, HideNull -> True],
		ModifyOptions[UploadVerifiedSampleModel, AllowNull -> True, HideNull -> True]
	}
];

(* Source code *)
VerifyObjects[myObject:ListableP[ObjectP[]], ops:OptionsPattern[]] := Module[
	{
		verificationFunction, inputType, modelUploadFunction, listedOps, validOptions,
		preview, options, result, outputSpecification, verify, correctedOptions, safeOptions,
		safeOpsWithIrrelevantOptionsNulled, preCheckResult, bypassPreCheckQ
	},

	(* Prevent external user from using this function *)
	If[!MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
		Message[Error::InternalOnlyFunction, verificationFunctionSymbol, myFunction];
		Return[$Failed]
	];

	inputType = Download[myObject, Type];
	(* Read input options *)
	listedOps = ToList[ops];
	safeOptions = SafeOptions[VerifyObjects, listedOps];

	(* Read Verify and Output option values *)
	{verify, bypassPreCheckQ} = Lookup[safeOptions, {Verify, BypassVerificationPreCheck}];

	outputSpecification = Lookup[listedOps, Output, If[verify, Result, Options]];

	(* Find the upload function that will be used for input *)
	modelUploadFunction = identifyUploadFunction[inputType];

	(* If we didn't find the Upload function, return $Failed now *)
	If[NullQ[modelUploadFunction],
		Message[Error::CannotFindUploadFunction, myObject];
		Return[outputSpecification /. {
			Preview -> $Failed,
			Options -> $Failed,
			Result -> $Failed
		}]
	];

	(* Find the individual verification function symbol from the upload function *)
	verificationFunction = Lookup[$VerificationFunctionLookupAssoc, modelUploadFunction, Null];

	(* If we didn't find the verification function, return $Failed now *)
	If[NullQ[verificationFunction],
		Message[Error::CannotFindVerificationFunction, myObject];
		Return[outputSpecification /. {
			Preview -> $Failed,
			Options -> $Failed,
			Result -> $Failed
		}]
	];

	(* Run pre-check first *)
	preCheckResult = If[bypassPreCheckQ,
		True,
		VerificationPreCheck[myObject]
	];

	If[!TrueQ[preCheckResult],
		Message[Error::ObjectFailedPreCheck, myObject];
		Return[outputSpecification /. {
			Preview -> $Failed,
			Options -> $Failed,
			Result -> $Failed
		}]
	];

	(* Find options that are defined for the individual verification function *)
	validOptions = Lookup[OptionDefinition[verificationFunction], "OptionSymbol"];

	(* Run the Verification function. Always run with Output -> {Preview, Options, Result} *)
	{preview, options, result} = verificationFunction[myObject,
		ReplaceRule[listedOps, {Output -> {Preview, Options, Result}}]
	];

	(* If Options failed, return early *)
	If[FailureQ[options],
		Return[outputSpecification /. {
			Preview -> $Failed,
			Options -> $Failed,
			Result -> $Failed
		}]
	];

	(* Our VerifyObjects function contains options for all individual verification functions, a lot of them are not relevant to the current input *)
	(* Therefore, set all these option values to Null *)
	safeOpsWithIrrelevantOptionsNulled = Map[
		Function[{singleOption},
			Which[
				(* If the option is valid but the value is Null, change it to $Failed in CCD so that they are still displayed in command builder, not hidden *)
				MatchQ[$ECLApplication, CommandCenter] && MemberQ[validOptions, Keys[singleOption]] && NullQ[Values[singleOption]],
					Keys[singleOption] -> $Failed,
				(* Otherwise, if the option is valid, keep it as is *)
				MemberQ[validOptions, Keys[singleOption]],
					singleOption,
				(* If the option is not relevent, set to Null *)
				True,
					Keys[singleOption] -> Null
			]
		],
		safeOptions
	];

	(* Apply the options from individual verification function run *)
	correctedOptions = ReplaceRule[
		safeOpsWithIrrelevantOptionsNulled,
		options
	];

	outputSpecification /. {
		Preview -> preview,
		Options -> correctedOptions,
		Result -> result
	}

];

(* ::Subsubsection::Closed:: *)
(* Define object types that need verification *)

$VerificationRequiredTypes = {
	Model[Sample],
	Model[Molecule],
	Object[Product]
};

$VerificationAndParameterizationRequiredTypes = {
	Model[Container],
	Model[Item, Cap],
	Model[Item, Lid],
	Model[Item, PlateSeal]
};

(* ::Subsubsection::Closed:: *)
(* PlotUnverifiedObjects *)

DefineOptions[PlotUnverifiedObjects,
	Options :> {
		{PrivateOnly -> False, BooleanP, "Indicate if function will only find unverified objects that belong to customer."},
		{MaxResults -> 15, Infinity | _Integer, "The maximum number of objects that will be displayed."}
	}
];

PlotUnverifiedObjects[ops:OptionsPattern[]] := Module[
	{
		allPendingVerificationObjects, verificationClause, verifyAndParameterizationClause, safeOps,
		privateOnly, maxResults, allNotebook, allTeam, allCreatedBy, verifyAndCompletedParameterizationClause,
		objectDontNeedParameterization, objectsNotYetParameterized, objectParameterized, parameterizationStatus,
		teamName, notebookName, creatorFirstName, creatorLastName, creatorName, notebookColumn, formatColumn,
		teamColumn, creatorColumn, objectColumn, pendingVerificationObjectsNamed, rowColors
	},

	(* Lookup options *)
	safeOps = SafeOptions[PlotUnverifiedObjects, ToList[ops]];

	{privateOnly, maxResults} = Lookup[safeOps, {PrivateOnly, MaxResults}];

	(* Construct search clauses *)
	verificationClause = If[privateOnly,
		Notebook != Null && Verified != True,
		Verified != True
	];
	(* When new objects are created, if PendingParameterization field applies, we should have PendingParameterization == Null *)
	verifyAndParameterizationClause = If[privateOnly,
		Notebook != Null && Verified != True && PendingParameterization == Null,
		Verified != True && PendingParameterization == Null
	];
	(* When the model has been parameterized in lab, it should set PendingParameterization == False *)
	verifyAndCompletedParameterizationClause = If[privateOnly,
		Notebook != Null && Verified != True && PendingParameterization == False,
		Verified != True && PendingParameterization == False
	];

	(* Do the search *)
	{objectDontNeedParameterization, objectsNotYetParameterized, objectParameterized} = Search[{$VerificationRequiredTypes, $VerificationAndParameterizationRequiredTypes, $VerificationAndParameterizationRequiredTypes},
		{
			Evaluate[verificationClause],
			Evaluate[verifyAndParameterizationClause],
			Evaluate[verifyAndCompletedParameterizationClause]
		},
		(* Since overall we want at most X results, that means we want X/3 results per category, Set the minimum to 1 *)
		MaxResults -> Max[1, Floor[maxResults / 3]]
	];

	(* Combine search result *)
	allPendingVerificationObjects = Flatten[{objectParameterized, objectDontNeedParameterization, objectsNotYetParameterized}];

	parameterizationStatus = Flatten[
		MapThread[
			ConstantArray[#1, Length[#2]]&,
			{{"Completed", "Not Applicable", "Not started"}, {objectParameterized, objectDontNeedParameterization, objectsNotYetParameterized}}
		]
	];

	{allNotebook, allTeam, allCreatedBy, teamName, notebookName, creatorFirstName, creatorLastName} = Quiet[
		Transpose[
			Download[allPendingVerificationObjects,
				{
					Notebook[Object], 
					Notebook[Financers][[1]][Object], 
					CreatedBy[Object], 
					Notebook[Financers][[1]][Name],
					Notebook[Name],
					CreatedBy[FirstName],
					CreatedBy[LastName]
				}
			]
		],
		{Download::ObjectDoesNotExist, Download::FieldDoesntExist}
	];
	(* Construct the Name of creator. Usually it's FirstName LastName, but in case one of them are missing, use the other *)
	(* If both are missing, use the object ID *)
	creatorName = MapThread[
		Switch[{#1, #2},
			{_String, _String}, #1<>" "<>#2,
			{_String, _}, #1,
			{_, _String}, #2,
			{_, _}, #3
		]&,
		{creatorFirstName, creatorLastName, allCreatedBy}
	];

	(* Convert the objects from ID form to named form for display *)
	pendingVerificationObjectsNamed = NamedObject[allPendingVerificationObjects];

	(* Here we want to define customized tooltips instead of the default functionality of PlotTable. Basically, for team, notebook and creator *)
	(* We want to display the name, but when clicked, we want to copy the object ID into clipboard, not the name *)
	formatColumn[text_List, objects_List] := MapThread[
		Function[{name, object},
			Tooltip[
				Button[
					Style[ToString[name], FontSize -> 11],
					CopyToClipboard[object],
					Appearance -> None,
					Evaluator -> Automatic,
					Method -> "Queued"
				],
				"Copy Object ID",
				TooltipStyle -> "TextStyling"
			]
		],
		{text, objects}
	];
	(* Construct each columns using the helper above. This allows us to set the copy to clipboard value to be different from displayed value *)
	{notebookColumn, teamColumn, creatorColumn, objectColumn} = MapThread[
		formatColumn[#1, #2]&,
		{
			{notebookName, teamName, creatorName, pendingVerificationObjectsNamed},
			{allNotebook, allTeam, allCreatedBy, allPendingVerificationObjects}
		}
	];

	(* Construct background colors for each row *)
	rowColors = Join[
		(* Table heading row. Set to 50% gray *)
		{1 -> GrayLevel[0.5]},
		(* Objects that completed parameterization. Set to pink color. Use lighter and darker ones per alternating rows *)
		(# -> RGBColor[1, 0.5, 0.5])& /@ Range[2, 1 + Length[objectParameterized], 2],
		(# -> RGBColor[1, 0.7, 0.7])& /@ Range[3, 1 + Length[objectParameterized], 2],
		(* Objects that either don't need parameterization or need but haven't done. set to 30% or 10% gray per alternating rows *)
		(# -> GrayLevel[0.7])& /@ Range[2 + Length[objectParameterized], 1 + Length[allPendingVerificationObjects], 2],
		(# -> GrayLevel[0.9])& /@ Range[3 + Length[objectParameterized], 1 + Length[allPendingVerificationObjects], 2]
	];

	(* Here's how an example table would look like *)
	(* |   "Object need Verification"    |       "Notebook"      |   "Team"   | "CreatedBy" | "Parameterization Status" | *)
	(* | Model[Container, Vessel, "xxx"] | xx company Onboarding | xx company | John Smith  |         Completed         | *)
	(* | Model[Container, Vessel, "xxy"] | xx company Onboarding | xx company | John Smith  |         Completed         | *)
	(* | Model[Sample, "xxy"]            | A1 company Onboarding | A1 company | First Last  |       Not Applicable      | *)
	(* | Model[Molecule, "molecule 1"]   | ECL internal training |    ECL     | Manager 1   |       Not Applicable      | *)
	(* | Model[Container, Vessel, "yyy"] | xx company Onboarding | xx company | John Smith  |        Not Started        | *)
	(* | Model[Item, Cap, "yyy Cap"]     | xx company Onboarding | xx company | John Smith  |        Not Started        | *)

	(* Basically, all objects in column 1 will show as named objects; column 2 through 4 will show the names, but clicking on it *)
	(* Should copy the object ID onto clip board. Column 5 is pure text *)
	(* Rows with "Parameterization Status" == Completed are shown upfront and will have pink background for highlighting *)

	PlotTable[
		Transpose[{objectColumn, notebookColumn, teamColumn, creatorColumn, parameterizationStatus}],
		TableHeadings -> {Automatic, {"Object need Verification", "Notebook", "Team", "CreatedBy", "Parameterization Status"}},
		Tooltips -> False,
		Background -> {None, rowColors}
	]

];

(* ::Subsubsection::Closed:: *)
(* VerificationPreCheck *)

(* Define the verification pre-check function dictionary for each upload functions *)
$PreCheckFunctionLookupAssoc = <|
	UploadContainerModel -> containerModelVerificationPreCheck,
	UploadCoverModel -> coverModelVerificationPreCheck
|>;

VerificationPreCheck[myObjects:ListableP[ObjectP[]]] := Module[
	{
		inputType, modelUploadFunction, preCheckFunction, preCheckResult
	},
	inputType = Download[myObjects, Type];

	(* Find the upload function that will be used for input *)
	modelUploadFunction = identifyUploadFunction[inputType];

	(* If we didn't find the Upload function, return $Failed now *)
	If[NullQ[modelUploadFunction],
		Message[Error::CannotFindUploadFunction, myObjects];
		Return[False]
	];

	preCheckFunction = Lookup[$PreCheckFunctionLookupAssoc, modelUploadFunction, Null];

	(* If the PreCheck function for the given Type exists, call it *)
	(* If the PreCheck function does not exist, return True *)
	preCheckResult = If[NullQ[preCheckFunction],
		True,
		preCheckFunction[myObjects]
	]

];