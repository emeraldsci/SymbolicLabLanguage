

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*AnyInformedTest*)

DefineUsage[AnyInformedTest,
{
	BasicDefinitions -> {
		{"AnyInformedTest[packet,fields]", "test", "returns a test to be used in RunUnitTest for whether at least one of the values of the given `fields` is non-Null."}
	},
	MoreInformation -> {
		"The test uses NullQ to determine whether the fields are Null or not Null. Please see NullQ for details on what inputs pass or fail NullQ."
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether at least of of the fields is non-Null."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "taylor.hochuli", "josh.kenchel"}
}];


(* ::Subsubsection::Closed:: *)
(*FieldComparisonTest*)

DefineUsage[FieldComparisonTest,
{
	BasicDefinitions -> {
		{"FieldComparisonTest[packet,fields,comparator]", "test", "returns a test to be used in RunUnitTest for the numerical comparison of the values of two or more 'fields'. For index-matched multiple fields, the comparison is made element-wise."}
	},
	AdditionalDefinitions -> {
		
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet on which the test will be run."},
		{"fields", {FieldP[Output->Short], FieldP[Output->Short]..}, "The fields whose contents will be passed to the specified 'comparator' function."},
		{"comparator", Greater | Less | GreaterEqual | LessEqual, "The comparison that will be performed if none of 'fields' are Null."}
	},
	Output :> {
		{"test", TestP, "A test for whether the given comparison passes given inputs in 'fields'."}
	},
	Behaviors -> {
		
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"MultipleFieldQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"yanzhe.zhu", "ben, ryan.bisbey"}
}];


(* ::Subsubsection::Closed:: *)
(*FieldSyncTest*)

DefineUsage[FieldSyncTest,
{
	BasicDefinitions -> {
		{"FieldSyncTest[packets,field]", "test", "returns a test to be used in RunUnitTest for whether the values of the given `field` is the same for all the `packets`."}
	},
	Input :> {
		{"packets", {PacketP[]..}, "The packets to be tested."},
		{"field", FieldP[Output->Short], "The field that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the given field contains the same entry in all packets."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "taylor.hochuli", "josh.kenchel"}
}];


(* ::Subsubsection::Closed:: *)
(*NotNullFieldTest*)

DefineUsage[NotNullFieldTest,
{
	BasicDefinitions -> {
		{"NotNullFieldTest[packet,field]", "test", "returns a test to be used in RunUnitTest for whether the value of the given `field` in the `packet` is not Null."}
	},
	MoreInformation -> {
		"The test uses NullQ to determine whether the field is Null or not Null. Please see NullQ for details on what inputs pass or fail NullQ."
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"field", FieldP[Output->Short], "The field that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the specified field in the packet is not Null."}
	},
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "melanie.reschke", "josh.kenchel"}
}];


(* ::Subsubsection::Closed:: *)
(*NullFieldTest*)

DefineUsage[NullFieldTest,
{
	BasicDefinitions -> {
		{"NullFieldTest[packet,field]", "test", "returns a test to be used in RunUnitTest for whether the value of the given `field` in the `packet` is Null."}
	},
	MoreInformation -> {
		"The test uses NullQ to determine whether the field is Null or not Null. Please see NullQ for details on what inputs pass or fail NullQ."
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"field", FieldP[Output->Short], "The field that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the specified field in the packet is Null."}
	},
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "taylor.hochuli", "josh.kenchel"}
}];


(* ::Subsubsection::Closed:: *)
(*ObjectTypeTest*)

DefineUsage[ObjectTypeTest,
{
	BasicDefinitions -> {
		{"ObjectTypeTest[packet,field]", "test", "returns a test to be used in RunUnitTest that checks any objects in the given field share the same family as the object."}
	},
	AdditionalDefinitions -> {
		
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet on which the test will be run."},
		{"field", FieldP[Output->Short], "The field whose contents will be checked for family correctness."}
	},
	Output :> {
		{"test", TestP, "A test for whether the packet shares the same family with objects in the given field."}
	},
	Behaviors -> {
		
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "taylor.hochuli", "josh.kenchel"}
}];

(* ::Subsubsection::Closed:: *)
(*URLFieldAccessibleTest*)

DefineUsage[URLFieldAccessibleTest,
	{
		BasicDefinitions -> {
			{"URLFieldAccessibleTest[packet, URLfield]","test","returns a test to be used in RunUnitTest for whether, if specified, the URL in 'URLfield' is accessible and not a redirect."},
			{"URLFieldAccessibleTest[packet, URLfields]","test","returns a test to be used in RunUnitTest for whether, if specified, the URLs in 'URLfields' are accessible and not redirects."}
		},
		MoreInformation -> {},
		Input :> {
			{"packet", PacketP[], "The packet to be tested."},
			{"URLfield", FieldP[Output->Short], "The field that the test will check."},
			{"URLfields", {FieldP[Output->Short]..}, "The fields that the test will check."}
		},
		Output :> {
			{"test", TestP, "A test for whether the field(s), if specified, is(/are) accessible."}
		},
		SeeAlso -> {
			"ValidObjectQ",
			"NotNullFieldTest",
			"NullFieldTest",
			"RequiredTogetherTest",
			"FieldSyncTest",
			"ObjectTypeTest",
			"FieldComparisonTest",
			"UniqueFieldTest",
			"AnyInformedTest",
			"UniquelyInformedTest",
			"UniquelyInformedIndexTest",
			"RequiredWhenCompleted",
			"ResolvedWhenCompleted",
			"RequiredAfterCheckpoint",
			"ResolvedAfterCheckpoint"
		},
	Author -> {"ryan.bisbey", "axu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*RequiredAfterCheckpoint*)

DefineUsage[RequiredAfterCheckpoint,
{
	BasicDefinitions -> {
		{"RequiredAfterCheckpoint[packet, checkpoint, fields]", "test", "returns a test to be used in RunUnitTest for whether the values of the given 'fields' are populated in 'packet' if 'checkpoint' has been completed."}
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"checkpoint", _String, "The label of the checkpoint the test will gate on."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the fields are populated if the specificed checkpoint has been completed."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"yanzhe.zhu", "kelmen.low", "taylor.hochuli", "boris.brenerman", "paul", "ben"}
}];


(* ::Subsubsection::Closed:: *)
(*RequiredTogetherTest*)

DefineUsage[RequiredTogetherTest,
{
	BasicDefinitions -> {
		{"RequiredTogetherTest[packet,fields]", "test", "returns a test to be used in RunUnitTest for whether the values of the given `fields` are either all Null or all non-Null."}
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the either none or all of the fields are Null."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"hayley", "mohamad.zandian"}
}];


(* ::Subsubsection::Closed:: *)
(*RequiredWhenCompleted*)

DefineUsage[RequiredWhenCompleted,
{
	BasicDefinitions -> {
		{"RequiredWhenCompleted[packet,fields]", "test", "returns a test to be used in RunUnitTest for whether the values of the given 'fields' are informed if the DateCompleted field has been informed."}
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"fields", ListableP[FieldP[Output->Short]], "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the field(s) are resolved if the DateCompleted field is informed."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"hayley", "mohamad.zandian"}
}];


(* ::Subsubsection::Closed:: *)
(*ResolvedAfterCheckpoint*)

DefineUsage[ResolvedAfterCheckpoint,
{
	BasicDefinitions -> {
		{"ResolvedAfterCheckpoint[packet, checkpoint, fields]", "test", "returns a test to be used in RunUnitTest for whether the values of the given 'fields' in 'packet' are resolved to Objects if 'checkpoint' has been completed."}
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"checkpoint", _String, "The label of the checkpoint the test will gate on."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the fields are resolved if the specified checkpoint has been completed."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"yanzhe.zhu", "kelmen.low", "taylor.hochuli", "boris.brenerman", "paul", "ben"}
}];


(* ::Subsubsection::Closed:: *)
(*ResolvedWhenCompleted*)

DefineUsage[ResolvedWhenCompleted,
{
	BasicDefinitions -> {
		{"ResolvedWhenCompleted[packet,fields]", "test", "returns a test to be used in RunUnitTest for whether the values of the given `fields` are resolved to sample, container, instrument or part if the DateCompleted field is informed."}
	},
	MoreInformation -> {
		
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
	},
	Output :> {
		{"test", TestP, "A test for whether the fields are resolved if the DateCompleted field is informed."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"yanzhe.zhu", "kelmen.low", "taylor.hochuli", "josh.kenchel"}
}];


(* ::Subsubsection::Closed:: *)
(*UniqueFieldTest*)

DefineUsage[UniqueFieldTest,
{
	BasicDefinitions -> {
		{"UniqueFieldTest[packet,field]", "test", "returns a test that checks if no other objects, with the same type as 'packet', store the same value in the specified 'field'."}
	},
	AdditionalDefinitions -> {
		
	},
	MoreInformation -> {

	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"field", FieldP[Output->Short], "The field that the test will check for uniqueness."}
	},
	Output :> {
		{"test", TestP, "A test for whether the packet's field value is unique."}
	},
	Behaviors -> {
		
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"hayley", "mohamad.zandian"}
}];


(* ::Subsubsection::Closed:: *)
(*UniquelyInformedTest*)

DefineUsage[UniquelyInformedTest,
{
	BasicDefinitions -> {
		{"UniquelyInformedTest[packet,fields]", "test", "returns a test to be used in RunUnitTest for whether exactly one of `fields` is non-Null."},
		{"UniquelyInformedTest[packet,fields,parentField,pattern]", "test", "returns a test to be used in RunUnitTest for whether exactly one of `fields` is non-Null if a 'parentField' matches a given 'pattern'.."}
	},
	MoreInformation -> {
		"The test uses NullQ to determine whether the fields are Null or not Null. Please see NullQ for details on what inputs pass or fail NullQ.",
		"The parentField/pattern overload is useful for complex experiments that employ master switches or nested index matching."
	},
	Input :> {
		{"packet", PacketP[], "The packet to be tested."},
		{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."},
		{"parentField", FieldP[Output->Short], "A master switch field that also needs to be specified."},
		{"pattern", _Alternatives, "Alternatives of symbols or patterns for the parentField to match, when the test is applicable."}
	},
	Output :> {
		{"test", TestP, "A test for whether only one of the fields is non-Null."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"ValidObjectQ",
		"NotNullFieldTest",
		"NullFieldTest",
		"RequiredTogetherTest",
		"FieldSyncTest",
		"ObjectTypeTest",
		"FieldComparisonTest",
		"UniqueFieldTest",
		"AnyInformedTest",
		"UniquelyInformedTest",
		"UniquelyInformedIndexTest",
		"RequiredWhenCompleted",
		"ResolvedWhenCompleted",
		"RequiredAfterCheckpoint",
		"ResolvedAfterCheckpoint"
	},
	Author -> {"pnafisi", "taylor.hochuli", "josh.kenchel"}
}];

(* ::Subsubsection::Closed:: *)
(*UniquelyInformedTest*)

DefineUsage[UniquelyInformedIndexTest,
	{
		BasicDefinitions -> {
			{"UniquelyInformedIndexTest[packet, fields]", "test", "returns a test to be used in RunUnitTest for whether at every matching index within `fields` that only one is non-Null."}
		},
		MoreInformation -> {
			"The test will return a failing test if the target fields are not the same length."
		},
		Input :> {
			{"packet", PacketP[], "The packet to be tested."},
			{"fields", {FieldP[Output->Short]..}, "The fields that the test will check."}
		},
		Output :> {
			{"test", TestP, "A test for whether only one of the fields is non-Null."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"ValidObjectQ",
			"NotNullFieldTest",
			"NullFieldTest",
			"RequiredTogetherTest",
			"FieldSyncTest",
			"ObjectTypeTest",
			"FieldComparisonTest",
			"UniqueFieldTest",
			"AnyInformedTest",
			"UniquelyInformedTest",
			"RequiredWhenCompleted",
			"ResolvedWhenCompleted",
			"RequiredAfterCheckpoint",
			"ResolvedAfterCheckpoint"
		},
		Author -> {"ryan.bisbey"}
	}];

(* ::Subsubsection::Closed:: *)
(*registerValidQTestFunction*)

DefineUsage[registerValidQTestFunction,
{
	BasicDefinitions -> {
		{"registerValidQTestFunction[type,testFunction]", "testFunction", "defines the provided ValidObjectQ 'testFunction' that will return a list of tests to be run for objects of the given 'type'."}
	},
	MoreInformation -> {
		"This function is executed on loading of the ValidObjectQ package."
	},
	Input :> {
		{"type", TypeP[], "The type for which a test function is being defined."},
		{"testFunction", _Symbol, "Function to call when generating ValidObjectQ tests for an object of the given type."}
	},
	Output :> {
		{"testFunction", _Symbol, "The function that was registered to produce ValidObjectQ tests for the given type."}
	},
	Sync -> Automatic,
	SeeAlso -> {
		"RegisterProtocolCompiler",
		"ValidObjectQ"
	},
	Author -> {"hayley", "mohamad.zandian"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidObjectQ*)

DefineUsage[ValidObjectQ,
{
	BasicDefinitions -> {
		{"ValidObjectQ[obj]", "results", "runs tests on the integrity of the values stored in 'obj'."},
		{"ValidObjectQ[type]", "results", "runs tests on the integrity of the values stored in recent objects of the given 'type'."},
		{"ValidObjectQ[mixedInput]", "results", "runs tests on the integrity of the values stored in all objects found in 'mixedInput'."}
	},
	AdditionalDefinitions -> {
		
	},
	MoreInformation -> {
		"This function redirects to object type specific ValidObjectQ functions."
	},
	Input :> {
		{"obj", ListableP[ObjectP[]], "Emerald object to be tested for validity."},
		{"type", TypeP[], "The type for which objects will be tested for validity."},
		{"mixedInput", _, "Any arbitrary input which may or may not contain objects."}
	},
	Output :> {
		{"results", ListableP[BooleanP] | KeyValuePattern[(ObjectP[] -> _EmeraldTestSummary)..], "The test results for the tests run on the object."}
	},
	Behaviors -> {
		
	},
	Guides -> {
		
	},
	Tutorials -> {
		
	},
	Sync -> Automatic,
	SeeAlso -> {
		"EmeraldTestSummary",
		"EmeraldTest",
		"EmeraldTestResult",
		"TestSummaryNotebook",
		"ScrapeObjects"
	},
	Author -> {"hayley", "mohamad.zandian", "cheri", "frezza", "alex"}
}];

(* ::Subsubsection::Closed:: *)
(*fetchPacketFromCacheOrDownload*)

DefineUsage[fetchPacketFromCacheOrDownload,
	{
		BasicDefinitions -> {
			{"fetchPacketFromCacheOrDownload[{{fieldList}..}, packet, cache]", "results", "find objects according to the 'packet' and 'fieldList', then either fetch packets from the provided 'cache' if they are available, or download packets from Constellation."},
			{"fetchPacketFromCacheOrDownload[{fieldList}, packet, cache]", "results", "find object according to the 'packet' and 'fieldList', then either fetch packets from the provided 'cache' if they are available, or download packets from Constellation."}
		},
		MoreInformation -> {
			"This function is only supposed to be used in ValidObjectQ framework to fetch packets from provided cache."
		},
		Input :> {
			{"fieldList", {(_Packet | _Symbol | _Field | _Repeated?(MatchQ[First[#1], (_Field | _Symbol)] &))...}, "List of field to travel through from the 'packet' input in order to determine packets from which objects need to be fetched or downloaded."},
			{"packet", PacketP[], "The packet of the main object, in most cases it's the object that's running ValidObjectQ tests."},
			{"cache", {PacketP[]...}, "All cached packets provided. The function will first try to fetch the desired packets from this cache input, whenever possible."}
		},
		Output :> {
			{"results", ListableP[PacketP[]], "The desired packets as indicated by the 'fieldList' input, either from 'cache' or downloaded from Constellation."}
		},
		SeeAlso -> {
			"ValidObjectQ",
			"Experiment`Private`fetchPacketFromFastAssoc",
			"Experiment`Private`fastAssocLookup"
		},
		Author -> {"hanming.yang"}
	}
];