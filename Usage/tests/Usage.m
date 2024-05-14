(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*DefineUsage*)


DefineTests[
	DefineUsage,
	{
		Example[{Basic,"Set some Usage fields (using the current Command Builder ready format):"},
			Module[{testDropShipSamples},
				DefineUsage[testDropShipSamples,
				{
					BasicDefinitions->{
						{
							Definition->{"DropShipSamples[model, serviceProvider, orderNumber, quantity]","transaction"},
							Description->"generates a 'transaction' to track the user-initiated shipment of 'model' from 'serviceProvider' to ECL.",
							Inputs:>{
								{
									InputName -> "model",
									Description-> "The model sample that a service provider is shipping to ECL on behalf of the user.",
									Widget->Adder[
										Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
									]
								},
								{
									InputName -> "serviceProvider",
									Description-> "The service provider that is shipping samples to ECL on behalf of the user.",
									Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Company,Service]],ObjectTypes->{Model[Sample]}],
									IndexMatching->"model"
								},
								{
									InputName->"orderNumber",
									Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a service provider is shipping to ECL on behalf of the user.",
									Widget->Widget[Type->String,Pattern:>_String,Size->Word],
									IndexMatching->"model"
								},
								{
									InputName->"quantity",
									Description->"The quantity of the model sample that a service provider is shipping to ECL on behalf of the user.",
									Widget->Widget[Type->Number,Pattern:>GreaterP[0,1],Min->0,Increment->1],
									IndexMatching->"model"
								}
							},
							Outputs:>{
						{
									OutputName->"transaction",
									Description->"A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.",
									Pattern:>ListableP[ObjectP[Object[Transaction,ShipToECL]]]
						}
							}
						},
						{
							Definition->{"DropShipSamples[model, serviceProvider, orderNumber]","transaction"},
							Description->"generates a 'transaction' to track the user-initiated shipment of one of each 'model' from 'serviceProvider' to ECL.",
							Inputs:>{
								{
									InputName -> "model",
									Description-> "The model sample that a service provider is shipping to ECL on behalf of the user.",
									Widget->Adder[
										Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
									]
								},
								{
									InputName -> "serviceProvider",
									Description-> "The service provider that is shipping samples to ECL on behalf of the user.",
									Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Company,Service]],ObjectTypes->{Model[Sample]}],
									IndexMatching->"model"
								},
								{
									InputName->"orderNumber",
									Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a service provider is shipping to ECL on behalf of the user.",
									Widget->Widget[Type->String,Pattern:>_String,Size->Word],
									IndexMatching->"model"
								}
							},
							Outputs:>{
						{
									OutputName->"transaction",
									Description->"A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.",
									Pattern:>ListableP[ObjectP[Object[Transaction,ShipToECL]]]
						}
							}
						}
					},
					SeeAlso->{
						"OrderSamples",
						"ShipToUser",
						"ShipToECL"
					},
					Author->{
						"sarah"
					}
				}
			];
			Usage[testDropShipSamples]
			],
			_Association (* UUID Changes each time we run this *)
		],

		Example[{Basic,"Set some Usage fields (using the legacy format):"},
			Module[{f},
				DefineUsage[f,<|
					BasicDefinitions->{{"f[args]","out","description."}},
					Input:>{{"args",_,"Description."}},
					Output:>{{"out",_,"Description."}},
					Author->{"brad"}
				|>];
				Usage[f]
			],
			_Association
		],

		Example[{Basic,"Sets the Information (using the legacy format):"},
			Module[{f},
				DefineUsage[f,{
					BasicDefinitions->{{"f[args]","out","description."}},
					Input:>{{"args",_,"Description."}},
					Output:>{{"out",_,"Description."}},
					Author->{"brad"}
				}];
				Messages[f]
			],
			_?(MatchQ[#[[1,1,1,2]],"usage"]&)
		],

		Example[{Basic,"Set full Usage (using the legacy format):"},
			Module[{fFull},
				DefineUsage[fFull,{
					BasicDefinitions->{{"fFull[args]","out","description."}},
					MoreInformation->{"More Description."},
					Input:>{{"args",_,"Description."}},
					Output:>{{"out",_,"Description."}},
					SeeAlso->{"funcA","funcB"},
					Author->{"brad"}
				}];
				Usage[fFull]
			],
			_Association
		],


		(* Additional *)

		Example[{Additional,"Set some Usage fields (using the current Command Builder ready format):"},
			Module[
				{testAnalyzeFunction},

				DefineUsage[testAnalyzeFunction,{
					BasicDefinitions->{
						{
							Definition->{"AnalyzeFunction[input]","output"},
							Description->"analyzes 'input'.",
							Inputs:>{
								{
									InputName -> "input",
									Description-> "The analysis input.",
									Widget->Widget[Type->Object, Pattern :> ObjectP[Object[Data]]]
								}
							},
							Outputs:>{
								{
											OutputName->"output",
											Description->"The analysis output.",
											Pattern:>ListableP[ObjectP[Object[Analysis]]]
								}
							}
						}
					},
					SeeAlso->{
						"AnalyzeSmoothing"
					},
					Author->{
						"amir.saadat"
					},
					ButtonActionsGuide->{
						{
							Description->" 'Shift' + 'Left Click' to add a point"
						},
						{
							Description->" 'Left click' + 'Mouse Dragged' to zoom in"
						},
						{
							OperatingSystem->MacOSX,
							Description->" 'Shift' + 'CommandKey' + 'Left Click' to remove a selected point"
						}
					}
				}];

				Usage[testAnalyzeFunction]

			],
			_Association (* UUID Changes each time we run this *)
		],


		Example[{Messages,"BadUsageFormat","Specify an illegal Usage Type:"},
			Module[{fEmpty},
				DefineUsage[fEmpty,{Type->NotAValueType}]
			],
			$Failed,
			Messages:>{DefineUsage::MissingField,DefineUsage::MissingField}
		],

		Test["Only specified fields are set:",
			Module[{fFull},
				DefineUsage[fFull,{
					BasicDefinitions->{{"fFull[args]","out","description."}},
					Input:>{{"args",_,"Input Description."}},
					Output:>{{"out",_,"Output Description."}},
					Author->{"brad"}
				}];
				Lookup[Usage[fFull], {"BasicDefinitions", "MoreInformation", "Input", "Output", "Guides", "Tutorials", "Sync", "SeeAlso", "Author"}]
			],
			{
				{
					<|"Definition"->"fFull[args]", "Output"->"out", "Description"->"description."|>
				},
				{},
				{
					<|"Name"->"args", "Pattern"->Hold[_], "Description"->"Input Description."|>
				},
				{
					<|"Name"->"out", "Pattern"->Hold[_], "Description"->"Output Description."|>
				},
				{},
				{},
				Automatic,
				{},
				{"brad"}
			}
		],

		Test["Defaults for optional fields with pattern holds are set:",
			Module[{fPartial},
				DefineUsage[fPartial,{
					BasicDefinitions->{{"fPartial[args]","out","description."}},
					Author->{"james"}
				}];
				Lookup[Usage[fPartial], {"BasicDefinitions", "Input", "Output", "Author"}]
			],
			{
				{
					<|"Definition"->"fPartial[args]", "Output"->"out", "Description"->"description."|>
				},
				{},
				{},
				{"james"}
			}
		],

		Test["All fields are set:",
			Module[{fFull},
				DefineUsage[fFull,{
					BasicDefinitions->{{"fFull[args]","out","description."}},
					MoreInformation->{"More Description."},
					Input:>{{"args",_,"Input Description."}},
					Output:>{{"out",_,"Output Description."}},
					Guides->{"Testing Guide"},
					Tutorials->{"Turnig Machines"},
					Sync->Manual,
					SeeAlso->{"funcA","funcB"},
					Author->{"brad", "james"}
				}];
				Lookup[Usage[fFull], {"BasicDefinitions", "MoreInformation", "Input", "Output", "Guides", "Tutorials", "Sync", "SeeAlso", "Author"}]
			],
			{
				{
					<|"Definition"->"fFull[args]", "Output"->"out", "Description"->"description."|>
				},
				{"More Description."},
				{
					<|"Name"->"args", "Pattern"->Hold[_], "Description"->"Input Description."|>
				},
				{
					<|"Name"->"out", "Pattern"->Hold[_], "Description"->"Output Description."|>
				},
				{"Testing Guide"},
				{"Turnig Machines"},
				Manual,
				{"funcA","funcB"},
				{"brad", "james"}
			}
		],

		(* legacy stuff *)
		Example[{Messages,"DeprecatedForm","FIXME:"},
			True,
			True
		],

		(* internal only? *)
		Example[{Messages,"InvalidUsageField","FIXME:"},
			True,
			True
		],

		(* internal only? *)
		Example[{Messages,"NoDefaultForRequiredUsageFields","FIXME:"},
			True,
			True
		],

		Example[{Messages,"RuleDelayedRequired","Some fields must be RuleDelayed:"},
			DefineUsage[f, <|
				BasicDefinitions -> {{"f[args]", "out", "description."}},
	 			Input :> {{"args", _, "Description."}},
	 			Output -> (* ooops *) {{"out", _, "Description."}},
	 			Author -> {"brad"}
			|>],
			$Failed,
			Messages :> {
				DefineUsage::RuleDelayedRequired
			}
		],

		Example[{Messages,"UnknownUsageField","There are errors given unexpected usage fields:"},
			DefineUsage[f, <|
				BasicDefinitions -> {{"f[args]", "out", "description."}},
	 			Input :> {{"args", _, "Description."}},
	 			Output :> {{"out", _, "Description."}},
				Awkthor -> {"kevin"}, (* awk-thor! can they fly now with the power of thunder? *)
	 			Author -> {"brad"}
			|>],
			$Failed,
			Messages :> {
				DefineUsage::UnknownUsageField
			}
		],

		Example[{Messages,"UsageFieldPatternError","There are errors given things that don't match expected patterns:"},
			DefineUsage[f, <|
				BasicDefinitions -> {{"f[args]", "out", "description."}},
	 			Input :> {{"args", _, "Description."}},
	 			Output :> {{"out", _, "Description."}},
	 			Author -> "brad" (* wrong pattern *)
			|>],
			$Failed,
			Messages :> {
				DefineUsage::UsageFieldPatternError
			}
		],

		Example[{Messages,"MissingField","Some fields are required:"},
			DefineUsage[SomeRandomSymbol, {Author->{"platform"}}],
			$Failed,
			Messages :> {
				DefineUsage::MissingField
			}
		],

		Example[{Attributes,HoldFirst,"Expressions are held before evaluation:"},
			DefineUsage[Quit (* not evaluated, see! *), {Author->{"platform"}}],
			$Failed,
			Messages :> {
				DefineUsage::MissingField
			}
		],
		Test["Provisional->True triggers adding to $ProvisionialFunctions",
			Block[{$ProvisionalFunctions=<||>},
				DefineUsage[Usage`Private`ProvisionalFunctionTest, <|
					BasicDefinitions -> {{"f[args]", "out", "description."}},
	 				Input :> {{"args", _, "Description."}},
	 				Output :> {{"out", _, "Description."}},
					Author -> {"brad"},
					Provisional->True
				|>];
				Keys[$ProvisionalFunctions]
			],
			{Usage`Private`ProvisionalFunctionTest}
		]
	}
];

(* ::Subsubsection:: *)
(*Usage*)


DefineTests[
	Usage,
	{
		Example[{Basic,"Set some Usage fields (using the current Command Builder ready format) and return the Usage in an association:"},
			Module[{testDropShipSamples},
				DefineUsage[testDropShipSamples,
					{
						BasicDefinitions->{
							{
								Definition->{"DropShipSamples[model, serviceProvider, orderNumber, quantity]","transaction"},
								Description->"generates a 'transaction' to track the user-initiated shipment of 'model' from 'serviceProvider' to ECL.",
								Inputs:>{
									{
										InputName -> "model",
										Description-> "The model sample that a service provider is shipping to ECL on behalf of the user.",
										Widget->Adder[
											Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
										]
									},
									{
										InputName -> "serviceProvider",
										Description-> "The service provider that is shipping samples to ECL on behalf of the user.",
										Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Company,Service]],ObjectTypes->{Model[Sample]}],
										IndexMatching->"model"
									},
									{
										InputName->"orderNumber",
										Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a service provider is shipping to ECL on behalf of the user.",
										Widget->Widget[Type->String,Pattern:>_String,Size->Word],
										IndexMatching->"model"
									},
									{
										InputName->"quantity",
										Description->"The quantity of the model sample that a service provider is shipping to ECL on behalf of the user.",
										Widget->Widget[Type->Number,Pattern:>GreaterP[0,1],Min->0,Increment->1],
										IndexMatching->"model"
									}
								},
								Outputs:>{
									{
										OutputName->"transaction",
										Description->"A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.",
										Pattern:>ListableP[ObjectP[Object[Transaction,ShipToECL]]]
									}
								}
							},
							{
								Definition->{"DropShipSamples[model, serviceProvider, orderNumber]","transaction"},
								Description->"generates a 'transaction' to track the user-initiated shipment of one of each 'model' from 'serviceProvider' to ECL.",
								Inputs:>{
									{
										InputName -> "model",
										Description-> "The model sample that a service provider is shipping to ECL on behalf of the user.",
										Widget->Adder[
											Widget[Type->Object,Pattern:>ObjectP[Model[Sample]],ObjectTypes->{Model[Sample]}]
										]
									},
									{
										InputName -> "serviceProvider",
										Description-> "The service provider that is shipping samples to ECL on behalf of the user.",
										Widget -> Widget[Type->Object,Pattern:>ObjectP[Object[Company,Service]],ObjectTypes->{Model[Sample]}],
										IndexMatching->"model"
									},
									{
										InputName->"orderNumber",
										Description->"A unique identifier (e.g. Order Number, Confirmation Number, or Transaction Number) associated with the samples that a service provider is shipping to ECL on behalf of the user.",
										Widget->Widget[Type->String,Pattern:>_String,Size->Word],
										IndexMatching->"model"
									}
								},
								Outputs:>{
									{
										OutputName->"transaction",
										Description->"A transaction object that tracks the user-initiated shipment of samples from a supplier to ECL.",
										Pattern:>ListableP[ObjectP[Object[Transaction,ShipToECL]]]
									}
								}
							}
						},
						SeeAlso->{
							"OrderSamples",
							"ShipToUser",
							"ShipToECL"
						},
						Author->{
							"user"
						}
					}
				];
				Usage[testDropShipSamples]
			],
			_Association (* UUID Changes each time we run this *)
		],

		Example[{Basic,"Set some Usage fields (using the legacy format) and extract the Author information:"},
			Module[{f},
				DefineUsage[f,<|
					BasicDefinitions->{{"f[args]","out","description."}},
					Input:>{{"args",_,"Description."}},
					Output:>{{"out",_,"Description."}},
					Author->{"user"}
				|>];
				Usage[f]["Author"]
			],
			{"user"}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Authors*)


DefineTests[Authors,{
	Example[{Basic,"Authors of a single function:"},
		Authors[Authors],
		{_String...}
	],
	Example[{Basic,"Authors of an SLL object:"},
		Authors[Object[Data]],
		{_String...}
	],
	Example[{Basic,"Authors of a list of functions:"},
		Authors[{Authors,Examples}],
		{{_String...}..}
	],
	Example[{Basic,"Returns empty list if no authors found:"},
		Authors[someSymbolThatIsNotAFunction],
		{}
	],
	Example[{Options,"Default","Deault to brad if no authors found:"},
		Authors[someSymbolThatIsNotAFunction,Default->"brad"],
		{"brad"}
	],
	Example[{Options,Default,"If Default->None, returns empty list when no authors found:"},
		Authors[someSymbolThatIsNotAFunction,Default->None],
		{}
	]
}];



(* ::Subsubsection:: *)
(*PacletMapping*)


DefineTests[
	PacletMapping,
	{
		Example[{Basic,"If there is a mapping file, returns an Association of paclet URI to S3 bucket + key:"},
			PacletMapping[],
			<|
				"paclet:Constellation/ref/Download"-><|
					"bucket"->"example-bucket",
					"key"->"commit-hash/Constellation/Documentation/English/ReferencePages/Symbols/Download.nb"
				|>
			|>,
			Stubs:>{
				ParentDirectory[Evaluate[PackageDirectory["Usage`"]]]:=FileNameJoin[{PackageDirectory["Usage`"],"tests"}],
				PacletMapping[]:=<|
					"paclet:Constellation/ref/Download"-><|
						"bucket"->"example-bucket",
						"key"->"commit-hash/Constellation/Documentation/English/ReferencePages/Symbols/Download.nb"
					|>
				|>
			}
		],

		Example[{Applications,"Construct a cloud file from a paclet URI:"},
			With[
				{data=Lookup[PacletMapping[],"paclet:Constellation/ref/Download"]},
				EmeraldCloudFile["AmazonS3",data["bucket"],data["key"],None]
			],
			EmeraldCloudFile["AmazonS3","example-bucket","commit-hash/Constellation/Documentation/English/ReferencePages/Symbols/Download.nb",None],
			Stubs:>{
				ParentDirectory[Evaluate[PackageDirectory["Usage`"]]]:=FileNameJoin[{PackageDirectory["Usage`"],"tests"}],
				PacletMapping[]:=<|"paclet:Constellation/ref/Download" -> <|"bucket" -> "example-bucket", "key" -> "commit-hash/Constellation/Documentation/English/ReferencePages/Symbols/Download.nb"|>|>
			}
		]
	}
];
