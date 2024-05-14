(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Type Lists*)


(* ::Subsubsection::Closed:: *)
(*FluidContainerTypes*)


DefineUsage[
	FluidContainerTypes,
	{
		BasicDefinitions->{
			{"FluidContainerTypes","types","returns a list of containers capable of directly holding liquid and/or gas samples."}
		},
		MoreInformation->{
		},
		Output:>{
			{"types",{TypeP[Object[Container]]..},"a list of container types."}
		},
		SeeAlso->{
		},
		Author->{"hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*NonSelfContainedSampleTypes*)


DefineUsage[
	NonSelfContainedSampleTypes,
	{
		BasicDefinitions->{
			{"NonSelfContainedSampleTypes","types","returns a list of samples which must always be within a fluid container."}
		},
		MoreInformation->{
		},
		Output:>{
			{"types",{TypeP[Object[Sample]]..},"a list of sample types."}
		},
		SeeAlso->{
		},
		Author->{"hayley"}
	}
];



(* ::Subsubsection::Closed:: *)
(*SelfContainedSampleTypes*)


DefineUsage[
	SelfContainedSampleTypes,
	{
		BasicDefinitions->{
			{"SelfContainedSampleTypes","types","returns a list of samples which can be handled directly (with no intermediate fluid container)."}
		},
		MoreInformation->{
		},
		Output:>{
			{"types",{TypeP[Object[Sample]]..},"a list of sample types."}
		},
		SeeAlso->{
		},
		Author->{"hayley"}
	}
];


(* ::Subsection::Closed:: *)
(*Shared Options*)


(* ::Subsubsection::Closed:: *)
(*FastTrackOption*)


DefineUsage[FastTrackOption,
	{
		BasicDefinitions -> {
			{"FastTrackOption", None, "adds the FastTrack option to a function's list of options."}
		},
		SeeAlso -> {
			"CacheOption",
			"UploadOption",
			"ExportOption"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];



(* ::Subsubsection::Closed:: *)
(*UploadOption*)


DefineUsage[UploadOption,
	{
		BasicDefinitions -> {
			{"UploadOption[]", None, "adds the Upload option to a function's list of options."}
		},
		SeeAlso -> {
			"CacheOption",
			"FastTrackOption",
			"ExportOption"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];



(* ::Subsubsection::Closed:: *)
(*CacheOption*)


DefineUsage[CacheOption,
	{
		BasicDefinitions -> {
			{"CacheOption[]", None, "adds the Cache option to a function's list of options."}
		},
		SeeAlso -> {
			"UploadOption",
			"FastTrackOption",
			"ExportOption"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];


(* ::Subsubsection::Closed:: *)
(*ExportOption*)


DefineUsage[ExportOption,
	{
		BasicDefinitions -> {
			{"ExportOption[]", None, "adds the Export option to a function's list of options."}
		},
		SeeAlso -> {
			"UploadOption",
			"FastTrackOption",
			"CacheOption"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];




(* ::Subsection::Closed:: *)
(*ObjectToFilePath*)


DefineUsage[ObjectToFilePath,
	{
		BasicDefinitions -> {
			{"ObjectToFilePath[objects]","objectStrings", "converts objects to formatted strings compatible for use in unique filepaths."}
		},
		Input :> {
			{"objects", ListableP[ObjectP[]],"A list of objects to convert."}
		},
		Output :> {
			{"objectStrings",ListableP[_String],"The objects as formatted strings."}
		},
		SeeAlso -> {
			"ToString",
			"StringReplace"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}
];


(* ::Subsection::Closed:: *)
(*Patterns and Conversions*)


(* ::Subsubsection::Closed:: *)
(*PDBIDExistsQ*)


DefineUsage[PDBIDExistsQ,
{
	BasicDefinitions -> {
		{"PDBIDExistsQ[string]", "bool", "checks whether the provided string is a valid PDBID."}
	},
	Input :> {
		{"string", _String, "A string to test."}
	},
	Output :> {
		{"bool", BooleanP, "Returns true the string is a valid PDBID."}
	},
	SeeAlso -> {
		"Search",
		"Download"
	},
	Author -> {"daniel.shlian", "tyler.pabst", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*ProtocolTypes*)


DefineUsage[ProtocolTypes,{
	BasicDefinitions->{
		{"ProtocolTypes[]","types","returns a list of `types` that may have an associated procedure that can be run in Rosetta."}
	},
	Input:>{},
	Output:>{
		{"types", {TypeP[]...}, "A list of types."}
	},
	SeeAlso->{"ProtocolTypeP","DefineProcedure"},
	Author->{"robert", "alou", "hayley"}
}];


(* ::Subsubsection::Closed:: *)
(*ProtocolTypeP*)


DefineUsage[ProtocolTypeP,{
	BasicDefinitions->{
		{"ProtocolTypeP[]","pattern","returns a `pattern` that matches an object that may have an associated procedure that can be run in Rosetta."}
	},
	Input:>{},
	Output:>{
		{"pattern", _Alternatives, "A pattern matching objects of a type included in ProtocolTypes."}
	},
	SeeAlso->{"ProtocolTypes","DefineProcedure"},
	Author->{"robert", "alou", "hayley"}
}];



(* ::Subsubsection::Closed:: *)
(*typeUnits*)


DefineUsage[typeUnits,
{
	BasicDefinitions -> {
		{"typeUnits[type]", "unitFields", "returns all fields with Units for a given SLL type in the form of Field->Unit."},
		{"typeUnits[obj]", "unitFields", "returns all fields with Units for the type of the given Object."},
		{"typeUnits[inf]", "unitFields", "returns all fields with Units for the type of the given info packet."}
	},
	Input :> {
		{"type", TypeP[], "A valid SLL type."},
		{"obj", ObjectP[], "A valid SLL object."}
	},
	Output :> {
		{"unitFields", {_Rule...}, "A list of rules of Field->Unit, for all fields that have Units."}
	},
	SeeAlso -> {
		"UnitsQ",
		"Units"
	},
	Author -> {
		"Jonathan",
		"brad"
	}
}];


(* ::Subsubsection::Closed:: *)
(*NamedObject*)


DefineUsage[NamedObject,
	{
		BasicDefinitions -> {
			{"NamedObject[obj]", "namedObj", "returns `obj` with the ID replaced with the Name of `obj`, if it has a name. Otherwise just returns `obj`."},
			{"NamedObject[expr]", "namedExpr", "returns `expr` with all ObjectReferences, Links, and Packets replaced with the ObjectReferences by Name where applicable (to infinite depth)."}
		},
		Input :> {
			{"obj", ObjectP[], "A valid SLL object reference, link, or packet."},
			{"expr", _Expression, "An arbitrary expression."}
		},
		Output :> {
			{"namedObj", ObjectReferenceP[], "A valid SLL object reference, with its ID replaced by its Name."},
			{"namedExpr", _Expression, "An expression in which all ObjectReferences, Links, and Packets have been replaced with ObjectReferences by Name where applicable."}
		},
		SeeAlso -> {
			"Download",
			"Lookup",
			"Inspect",
			"Search"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven", "ben"}
	}
];


(* ::Subsection::Closed:: *)
(*AchievableResolution*)


(* ::Subsubsection::Closed:: *)
(*AchievableResolution*)


DefineUsage[AchievableResolution,
	{
		BasicDefinitions -> {
			{"AchievableResolution[amount, deviceType]", "achievableAmount", "rounds 'amount' to the closest 'achievableAmount' based on the resolution of the most precise ECL measuring device of 'deviceType'."}
		},
		Input :> {
			{"amount",MassP|VolumeP,"The raw amount to be rounded to an amount measurable based on the resolution of the most appropriate ECL measuring device."},
			{"deviceType", All | ListableP[TypeP[{Model[Instrument,Balance],Model[Instrument,Pipette],Model[Item,Tips],Model[Container,Syringe],Model[Container,GraduatedCylinder],Model[Instrument,BottleTopDispenser]}]], "The specific measuring device type to consider when determining the achievable resolution for the amount."}
		},
		Output :> {
			{"achievableAmount", MassP|VolumeP, "An amount that can be measured accurately in the ECL."}
		},
		SeeAlso -> {
			"ExperimentSampleManipulation",
			"ExperimentStockSolution"
		},
		Author -> {"daniel.shlian", "tyler.pabst", "steven"}
	}
];


(* ::Subsection::Closed:: *)
(*TransferDevices*)


(* ::Subsubsection::Closed:: *)
(*TransferDevices*)


DefineUsage[TransferDevices,
	{
		BasicDefinitions -> {
			{"TransferDevices[deviceType,amount]", "{device,minAmount,maxAmount,resolution}", "returns a 'device' that can measure 'amount', along with the 'minAmount' to 'maxAmount' range that the 'device' can measure, and the device's 'resolution'."}
		},
		Input :> {
			{"deviceType", (All|ListableP[TypeP[{Model[Instrument,Balance],Model[Item,Tips],Model[Container,Syringe],Model[Container,GraduatedCylinder],Model[Instrument,BottleTopDispenser]}]]),"Device type(s) to consider."},
			{"amount",(All|MassP|VolumeP),"The amount to be transferred."}
		},
		Output :> {
			{"device",ObjectReferenceP[{Model[Instrument,Balance],Model[Item,Tips],Model[Container,Syringe],Model[Container,GraduatedCylinder],Model[Instrument,BottleTopDispenser]}],"A device model that can measure the provided amount."},
			{"minAmount",MassP|VolumeP,"The smallest amount that the device will be used to measure."},
			{"maxAmount",MassP|VolumeP,"The largest amount that the device will be used to measure."},
			{"resolution",MassP|VolumeP,"The smallest difference which can be measured with this device."}
		},
		SeeAlso -> {
			"AchievableResolution",
			"ExperimentSampleManipulation",
			"ExperimentStockSolution"
		},
		Author -> {"hayley", "mohamad.zandian"}
	}];



(* ::Subsection::Closed:: *)
(*SampleVolumeRangeQ*)


(* ::Subsubsection::Closed:: *)
(*SampleVolumeRangeQ*)


DefineUsage[
	SampleVolumeRangeQ,
	{
		BasicDefinitions->{
			{"SampleVolumeRangeQ[volume]","boolean","returns True if the provided volume can be measured and stored in the lab."}
		},
		MoreInformation->{
			"The low end of this range is determined by our most precise volume measuring instrument",
			"The high end of this range is determined by our largest standardized vessel."
		},
		Input:>{
			{"volume",VolumeP,"The volume which should be considered."}
		},
		Output:>{
			{"boolean",BooleanP,"Indicates if the provided volume can be achieved."}
		},
		SeeAlso->{
			"AchievableResolution",
			"PreferredContainer"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];



(* ::Subsection:: *)
(*optionsToTable*)


DefineUsage[
	optionsToTable,
	{
		BasicDefinitions->{
			{"optionsToTable[myOptions,myFunction]","table","formats 'myOptions' into a table."}
		},
		MoreInformation->{
			"Hidden options are omitted."
		},
		Input:>{
			{"myOptions",{_Rule...},"The options to display."},
			{"myFunction",_Symbol,"The function to which the options belong."}
		},
		Output:>{
			{"table",_Graphics|_Grid,"The formatted table of the options. If no options are being displayed, an empty list."}
		},
		SeeAlso->{
			"DefineOptions",
			"SafeOptions"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];