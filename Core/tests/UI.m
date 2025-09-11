(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*UI: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ItemSelector*)


DefineTests[ItemSelector,
	{
		Example[{Basic, "Creates an interface containing an item selection pane:"},
			ItemSelector[Range[5]],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can only select one option:"},
			ItemSelector[
				Range[5],
				SelectionType -> Single
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can select multiple options:"},
			ItemSelector[
				Range[5],
				SelectionType -> Multiple
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can select a single option and the dialog automatically closes on selection:"},
			ItemSelector[
				Range[5],
				SelectionType -> Automatic
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, "Specify the title of the dialog:"},
			ItemSelector[
				Range[5],
				WindowTitle -> "Select an item..."
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, Selection, "Specify which option is pre-selected for a single select dialog:"},
			ItemSelector[
				Range[5],
				SelectionType -> Single,
				Selection -> 2
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, Selection, "Specify which options are pre-selected for a multiple select dialog:"},
			ItemSelector[
				Range[5],
				SelectionType -> Multiple,
				Selection -> {2, 4}
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, AllowNull, "Allow a user to click ok without selecting an item from the list:"},
			ItemSelector[
				Range[5],
				AllowNull -> True
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, Sort, "Sort the items in the list before displaying to the user:"},
			ItemSelector[
				Range[5],
				Sort -> True
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		],
		Example[{Options, Pagination, "Restrict the number of items initially displayed to improve load performance:"},
			ItemSelector[
				Range[1000],
				Pagination -> 100
			],
			Column[
				{
					(* Scrolling panel *)
					DynamicModule[__],

					(* Selection button row *)
					Row[___]
				},
				___
			]
		]
	},
	Stubs :> {
		(* Don't open a new dialog during testing *)
		DialogInput[x_, ___] := x
	}
];


(* ::Subsection::Closed:: *)
(*ItemSelectorPanel*)


DefineTests[ItemSelectorPanel,
	{
		Example[{Basic, "Creates an interface containing an item selection pane:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5]
			],
			DynamicModule[__]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can only select one option:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				SelectionType -> Single
			],
			DynamicModule[__]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can select multiple options:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				SelectionType -> Multiple
			],
			DynamicModule[__]
		],
		Example[{Options, SelectionType, "Creates an interface containing an item selection pane where a user can select a single option and the enclosing dialog automatically closes on selection:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				SelectionType -> Automatic
			],
			DynamicModule[__]
		],
		Example[{Options, Selection, "Specify which option is pre-selected for a single select dialog:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				SelectionType -> Single,
				Selection -> 2
			],
			DynamicModule[__]
		],
		Example[{Options, Selection, "Specify which options are pre-selected for a multiple select dialog:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				SelectionType -> Multiple,
				Selection -> {2, 4}
			],
			DynamicModule[__]
		],
		Example[{Options, Sort, "Sort the items in the list before displaying to the user:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[5],
				Sort -> True
			],
			DynamicModule[__]
		],
		Example[{Options, Pagination, "Restrict the number of items initially displayed to improve load performance:"},
			ItemSelectorPanel[
				myTestVariableForItemSelectorPanelUnitTests,
				Range[1000],
				Pagination -> 100
			],
			DynamicModule[__]
		]
	},
	Stubs :> {
		(* Variable to update *)
		myTestVariableForItemSelectorPanelUnitTests = Null
	}
];


(* ::Subsection::Closed:: *)
(* DynamicTooltip *)

DefineTests[DynamicTooltip,
	{
		Example[{Basic, "Create an interactive tooltip containing a dynamic progress indicator over a displayed string:"},
			DynamicTooltip["Test string", ProgressIndicator[Appearance -> "Necklace"]],
			_DynamicModule
		],
		Example[{Additional, "Create a tooltip that displays the current time, as the second argument is held:"},
			DynamicTooltip["Test string", Now],
			_DynamicModule
		]
	}
];


(* ::Subsection::Closed:: *)
(* DynamicImageImport *)

DefineTests[DynamicImageImport,
	{
		Example[{Basic, "Display an interactive grid of images where progress indicators are replaced by the images as they are downloaded:"},
			DynamicImageImport[
				{
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage","1d0ad1d7eea6790c8538549d1ab031f7.jpg"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage","77d4ff2a629018015f6d8e45ef102548.jpg"],
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage","f55a0a0ee0fa6aef661c110676959b29.jpg"]
				}
			],
			_DynamicModule
		],
		Example[{Additional, "Download a single image with progress indicator:"},
			DynamicImageImport[
				EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage","1d0ad1d7eea6790c8538549d1ab031f7.jpg"]
			],
			_DynamicModule
		],
		Example[{Additional, "Create a tooltip that displays a grid of progress indicators that are replaced with images as they are downloaded:"},
			DynamicTooltip[
				"Download my images!",
				DynamicImageImport[
					EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage","1d0ad1d7eea6790c8538549d1ab031f7.jpg"]
				]
			],
			_DynamicModule
		]
	}
];