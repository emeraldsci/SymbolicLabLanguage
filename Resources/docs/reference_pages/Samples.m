

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*Sample*)


DefineUsage[Sample,
	{
		BasicDefinitions->{
			{"Sample[specifications]","sample","returns a sample construct for the 'specifications'."}
		},
		MoreInformation->{
			"Sample constructs are used to represent the samples an experiment is expected to produce.",
			"Sample constructs use the keys: Model, Container, Volume or Mass and Concentration or MassConcentration.",
			"If the exact amount and/or concentration is unknown this uncertainty can be represented using a distribution.",
			"Container must point to a container construct. As each container construct is unique, it is possible to discern if samples will be in unique containers."
		},
		Input:>{
			{"specifications",Sequence[_Rule..],"A set of rules to specify a Sample."}
		},
		Output:>{
			{"sample",_Sample,"A sample construct representing the specifications."}
		},
		SeeAlso->{
			"Resource",
			"Container"
		},
		Author->{"robert", "alou", "hayley"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Container*)


DefineUsage[Container,
	{
		BasicDefinitions->{
			{"Container[specifications]","container","returns a container construct for the 'specifications'."}
		},
		MoreInformation->{
			"Container constructs are used to uniquely identify the containers an experiment is expected to fill with newly created samples.",
			"Container constructs use the keys: Model and Contents.",
			"A Model key must always be provided.",
			"The Contents key is optional."
		},
		Input:>{
			{"specifications",Sequence[_Rule..],"A set of rules to specify a Container."}
		},
		Output:>{
			{"container",_Container,"A container construct representing the specifications."}
		},
		SeeAlso->{
			"Resource",
			"Sample"
		},
		Author->{"robert", "alou"}
	}
];


(* ::Subsubsection::Closed:: *)
(*toBlob*)


DefineUsage[toBlob,
	{
		BasicDefinitions->{
			{"toBlob[input]","blobs","converts all inputs to Sample or Container blobs."}
		},
		MoreInformation->{
			"Any Sample or Container blobs sent as input will be returned unchanged.",
			"The order of the input list is preserved.",
			"If any objects are supplied that do not exist in the database, the function will return $Failed."
		},
		Input:>{
			{"input",{(ObjectP[{Object[Sample],Object[Container]}]|_Container|_Sample)..},"A list of blobs and/or objects."}
		},
		Output:>{
			{"blobs",{_Container|_Sample..},"A list of sample and/or container blobs."}
		},
		SeeAlso->{
			"Sample",
			"Container"
		},
		Author->{"hayley", "mohamad.zandian", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*toBlob*)


DefineUsage[blobLookup,
	{
		BasicDefinitions->{
			{"blobLookup[blob,key]","value","returns the value associated with the supplied key."}
		},
		MoreInformation->{
			"Any Sample or Container blobs sent as input will be returned unchanged.",
			"The order of the input list is preserved.",
			"If any objects are supplied that do not exist in the database, the function will return $Failed."
		},
		Input:>{
			{"blob",(_Container|_Sample),"A list of sample and/or container blobs."},
			{"key",{(_Symbol)..},"The field which should be looked up in the blob."},
			{"default",_,"The value which should be returned if the key does not exist in the blob."}
		},
		Output:>{
			{"value",_,"The value associated with the key"}
		},
		MoreInformation->{
			"blobLookup was created to replicate Lookup's behavior, since it is not possible to use Lookup when working with blobs."
		},
		SeeAlso->{
			"Resource",
			"Sample",
			"Container"
		},
		Author->{"hayley","mohamad.zandian"}
	}
];