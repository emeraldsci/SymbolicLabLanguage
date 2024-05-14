
DefineTests[PreviewSymbol, {
	Example[{Basic, "Retrieve the latest preview symbol for AnalyzeFractions:"},
		(
			SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}];
			PreviewSymbol[AnalyzeFractions]
		)
		,
		_Symbol
	],
	Test["Make sure returned value matches logged value:",
		With[{dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			PreviewSymbol[AnalyzeFractions] === dv
		],
		True
	],
	Test["Make sure new preview displaces old logged symbol:",
		With[{dv1 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}],
			dv2 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			{PreviewSymbol[AnalyzeFractions] === dv2, dv1 =!= dv2}
		],
		{True, True}
	]
}
];


DefineTests[DefinePreviewClump,
	{
		Test["Declare a Clump to serve as a translator between the preview state variables and analysis function options.",
			With[{clump =
				Clump[
					{"Domain" :> unitlessToDomain[$This["UnitlessDomain"]],
						"UnitlessDomain" -> domainToUnitless[$This["Domain"]]}
				]
			},
				DefinePreviewClump[AnalyzeFractions, clump]
			],
			Null
		]
	}
];

DefineTests[UpdatePreview, {
	Example[{Basic, "Update the dynamic variable domain option in AnalyzeFractions:"},
		(
			dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}];
			UpdatePreview[dv, Domain -> {-1, 1}];
			dv[Domain]
		),
		{-1, 1}
	],
	Example[{Basic, "Update the dynamic variable with two options at once:"},
		(
			dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}, TopPeaks -> 2}];
			UpdatePreview[dv, {Domain -> {-1, 1}, TopPeaks -> 3}];
			{dv[Domain], dv[TopPeaks]}
		),
		{{-1, 1}, 3}
	],
	Example[{Basic, "Update dynamic variable to include a new option:"},
		(
			dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}];
			UpdatePreview[dv, TopPeaks->5];
			dv[TopPeaks]
		),
		5
	],
	Test["Make sure the returned value matches logged value after update:",
		With[{dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			UpdatePreview[dv, Domain -> {-1, 1}];
			PreviewSymbol[AnalyzeFractions] === dv],
		True
	],
	Test["Make sure the update applies only to the most recent dynamic variable:",
		With[{dv1 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}],
			dv2 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			UpdatePreview[PreviewSymbol[AnalyzeFractions], Domain -> {-1, 3}];
			{PreviewSymbol[AnalyzeFractions][Domain] === {-1, 3}, dv1[Domain] === {3, 4}}],
		{True, True}
	]
}
];


DefineTests[PreviewValue, {
	Example[
		{Basic, "Test PreviewValue can throw the preview of the dynamic value:"},
		Module[{dv},
			dv = SetupPreviewSymbol[
				TestSymbol,
				Null,
				{A -> "First", B -> 233, C -> testExpression, XUnit -> Nanometer, YUnit -> Gram}
			];

			PreviewValue[dv, #] & /@ {A, B, C}
		],
		{"First", 233, testExpression}
	],
	Example[
		{Basic, "Can specified X or Y unit as the 3rd inputs:"},
		Module[{dv},
			dv = SetupPreviewSymbol[
				TestSymbol,
				Null,
				{A -> "First", B -> 233, C -> testExpression, XUnit -> Nanometer, YUnit -> Gram}
			];

			PreviewValue[dv, #, XUnit] & /@ {A, B, C}
		],
		{"First", 233, testExpression}
	],
	Example[
		{Basic, "Use LogPreviewChanges to change the preview values: "},
		Module[{dv},
			dv = SetupPreviewSymbol[
				TestSymbol,
				Null,
				{A -> "First", B -> 233, C -> testExpression, XUnit -> Nanometer, YUnit -> Gram}
			];

			LogPreviewChanges[dv, {A -> "Second", B -> 322}];

			PreviewValue[dv, #] & /@ {A, B, C}
		],
		{"Second", 322, testExpression}
	]
}];



DefineTests[SetupPreviewSymbol, {
	Example[{Basic, "Automatically sets symbol and retrieve the latest preview symbol for AnalyzeFractions:"},
		(
			SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}];
			PreviewSymbol[AnalyzeFractions]
		)
		,
		_Symbol
	],
	Test["Set the symbol to be used:",
		With[{dv = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			PreviewSymbol[AnalyzeFractions] === dv
		],
		True
	],
	Test["Make sure new preview displaces old logged symbol:",
		With[{dv1 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}],
			dv2 = SetupPreviewSymbol[AnalyzeFractions, Null, {Domain -> {3, 4}}]},
			{PreviewSymbol[AnalyzeFractions] === dv2, dv1 =!= dv2}
		],
		{True, True}
	]
}
];

(* ::Subsubsection::Closed:: *)
(*LogPreviewChanges*)

DefineTests[
	LogPreviewChanges,
	{
		Example[{Basic, "Use LogPreviewChanges to change the preview values:"},
			Module[{dv,TestSymbol},
				dv = SetupPreviewSymbol[
					TestSymbol,
					Null,
					{A -> "First", B -> 233, C -> testExpression, XUnit -> Nanometer, YUnit -> Gram}
				];
				LogPreviewChanges[dv, {A -> "Second", B -> 322}];
				PreviewValue[dv, #] & /@ {A, B, C}
			],
			{"Second", 322, testExpression}
		]
	}
];


(* pattern that the mouse guide creates for the attachedcell *)
mouseGuideP = Pane[Toggler[Pane[Column[{Column[{Button["Mouse Guide", ___]}, ___]}, ___], ___],
	{Pane[Column[{Column[{Button["Mouse Guide", ___]}, ___]}, ___], ___],
		Pane[Column[{Column[{Button["Mouse Guide", ___]}, ___],
			Column[{Column[{Style[_String, Bold], ___}],
				Column[{Style[_String, Bold], ___}]}, ___]}, ___], ___]}, ___], ___];


DefineTests[makeMouseGuideToggler,{
	Test["Only descriptions:",
		Analysis`Private`makeMouseGuideToggler[{{Description -> "First description"}, {Description -> "Second description"}}],
		mouseGuideP
	],
	Test["Descriptions and ButtonSets:",
		Analysis`Private`makeMouseGuideToggler[{{Description -> "First description", ButtonSet -> "buttons 1"}, {Description -> "Second description", ButtonSet -> "buttons 2"}}],
		mouseGuideP
	]
}];


DefineTests[addMouseGuideToggler,{
	Test["Add toggler:",
		Module[{func},
			Usage[func] = <|"ButtonActionsGuide" -> {{Description -> "First description", ButtonSet -> "buttons 1"}, {Description -> "Second description", ButtonSet -> "buttons 2"}}|>;
			Analysis`Private`addMouseGuideToggler[Graphics[{Disk[]}], func]
		],
		mouseGuideP
	],
	Test["Don't add toggler:",
		Module[{func},
			Usage[func] = <||>;
			Analysis`Private`addMouseGuideToggler[Graphics[{Disk[]}], func]
		],
		_Graphics
	]

}];


DefineTests[AdjustForCCD,{
	Test["Add toggler in CCD:",
		Block[{$CCD=True},Module[{func},
			Usage[func] = <|"ButtonActionsGuide" -> {{Description -> "First description", ButtonSet -> "buttons 1"}, {Description -> "Second description", ButtonSet -> "buttons 2"}}|>;
			Analysis`Private`AdjustForCCD[Graphics[{Disk[]}],func]
		]];
		(* Check that $PreviewMouseGuide got set *)
		Not[MatchQ[$PreviewMouseGuide, Null]],
		True
	],
	Test["Don't add toggler when not in CCD:",
		Block[{$CCD=False},Module[{func},
			Usage[func] = <|"ButtonActionsGuide" -> {{Description -> "First description", ButtonSet -> "buttons 1"}, {Description -> "Second description", ButtonSet -> "buttons 2"}}|>;
			Analysis`Private`AdjustForCCD[Graphics[{Disk[]}],func]
		]],
		_Graphics
	]
}]


(* ::Section:: *)
(*End Test Package*)
