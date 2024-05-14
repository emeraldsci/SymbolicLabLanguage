(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTable*)


With[{
	(* Define a pattern matching various possible styling elements (used in Dividers widget) *)
	stylesP=BooleanP|_Opacity|_Thickness|_RGBColor|_Directive
},

DefineOptions[PlotTable,

	Options:>{
		{
			OptionName -> TableHeadings,
			Default -> Automatic,
			Description -> "Headings (or None) for the rows and columns of the table.",
			ResolutionDescription -> "If Automatic, row headings are objects and column headings are fields for object inputs. No headers when plotting non-objects.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[Automatic]],
						{
							"Rows"->Alternatives[
								Widget[Type->Expression, Pattern:>_List, Size->Line],
								Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]]
							],

							"Columns"->Alternatives[
								Widget[Type->Expression, Pattern:>_List, Size->Line],
								Widget[Type->Enumeration, Pattern:>Alternatives[None,Automatic]]
							]
						}
					],
			Category->"Plot Labeling"
		},
		{
			OptionName -> SecondaryTableHeadings,
			Default -> None,
			Description -> "Secondary headings (or None) for the rows and columns of the table. Secondary headers may span multiple rows/columns. The number of rows/columns each header spans may be specified. Otherwise, spanning will be automatically determined by evenly spanning the headers over the rows/columns.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						{
							"Rows"->Alternatives[
								Widget[Type->Expression, Pattern:>(_List|{{_,GreaterEqualP[1,1]}..}), Size->Line],
								Widget[Type->Enumeration, Pattern:>Alternatives[None]]
							],

							"Columns"->Alternatives[
								Widget[Type->Expression, Pattern:>(_List|{{_,GreaterEqualP[1,1]}..}), Size->Line],
								Widget[Type->Enumeration, Pattern:>Alternatives[None]]
							]
						}
					],
			Category->"Plot Labeling"
		},
		{
			OptionName -> UnitForm,
			Default -> True,
			Description -> "Convert Units in the input matrix to UnitForm.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Category->"Data Specifications"
		},
		{
			OptionName -> Round,
			Default -> False,
			Description -> "Round numbers in the input matrix. When Round->True the value is rounded to $RoundIncrement.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
						Widget[Type->Number, Pattern:>RangeP[-Infinity, Infinity]]
					],
			Category->"Data Specifications"
		},
		{
			OptionName -> ShowNamedObjects,
			Default -> True,
			Description -> "Display object references with Name instead of IDs when a Name exists.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
			Category->"Data Specifications"
		},
		{
			OptionName -> HeaderTextAlignment,
			Default -> Left,
			Description -> "Determines how successive lines of text in TableHeadings are aligned.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Left,Right,Center]],
			Category->"Plot Labeling"
		},
		{
			OptionName -> Title,
			Default -> None,
			Description -> "The text to display above the table.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->String, Pattern:>_String, Size->Line]
					],
			Category->"Plot Labeling"
		},
		{
			OptionName -> Caption,
			Default -> None,
			Description -> "The text to display below the table.",
			AllowNull -> False,
			Widget -> Alternatives[
						Widget[Type->Enumeration, Pattern:>Alternatives[None]],
						Widget[Type->String, Pattern:>_String, Size->Line]
					],
			Category->"Plot Labeling"
		},
		{
			OptionName -> HorizontalScrollBar,
			Default -> Automatic,
			Description -> "Whether the table has a horizontal scroll bar.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Automatic,True,False]],
			Category->"Control"
		},
		{
			OptionName -> Tooltips,
			Default -> True,
			Description -> "Add tooltip buttons to every table element.",
			AllowNull -> False,
			Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[True,False]],
			Category->"Plot Labeling"
		},

		ModifyOptions[GridOption,
			{
				{
					OptionName->BaselinePosition,
					Category->"Hidden"
				},
				{
					OptionName->Dividers,
					Description->"Specifies where to draw lines between cells in the grid.",
					Default->Automatic,
					Widget->Alternatives[
						Widget[Type->Enumeration,Pattern:>Alternatives[Automatic,All,None,False,True,Center]],
						Widget[Type->Expression,Pattern:>ListableP[stylesP|Rule[_,stylesP],2]|{ListableP[stylesP|Rule[_,stylesP],1]..},Size->Line]
					],
					Category->"Plot Style"
				},
				{
					OptionName->FrameStyle,
					Description->"Formats the borders between cells in the table.",
					Category->"Plot Style"
				},
				{
					OptionName->Frame,
					Description->"Draws a border around the Table when set to True. Dividers must also be set to True.",
					Category->"Plot Style"
				},
				{
					OptionName->AllowedDimensions,
					Category->"Hidden"
				}
			}
		],

		GridOption,
		OutputOption
  }

]
];


PlotTable::FieldsPatternMismatch="The input fields are not a field name or a list of field names. Please make sure they are correct field names.";
PlotTable::ColumnLabelMismatch="Column headings are not the proper length. Please make sure it matches the input length.";
PlotTable::RowLabelMismatch="Row headings are not the proper length. Please make sure it matches the input length.";
PlotTable::SecondaryLabelsSpanning="The number cells to span (`1`) does not match the number of `2` in the table (`3`). Secondary headers for `2` have been omitted. Please modify your SecondaryTableHeadings option if you would like to include these headers.";
PlotTable::TooManySecondaryLabels="The number of secondary headers (`1`) exceeds the number of `2` in the table (`3`). Secondary headers for `2` have been omitted. Please modify your SecondaryTableHeadings option if you would like to include these headers.";
PlotTable::SecondaryLabelMismatch="The number of secondary headers (`1`) cannot be evenly divided over the number of `2` in the table (`3`). Spanning of secondary headers for `2` have been adjusted. Please modify your SecondaryTableHeadings option if you would specify a different spanning.";


(*
	Given raw list data
*)
PlotTable[items:{_List..},ops:OptionsPattern[]]:=Module[{
	listedOptions,outputSpecification,output,gatherTests,safeOptions,safeOptionTests,namedItems,
	unresolvedOptions,combinedOptions,resolvedOptionsResult,resolvedOptions, itemsWithHeaders,
	resolvedOptionsTests,outputTable, previewRule, optionsRule, testsRule, resultRule
},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		{SafeOptions[PlotTable,listedOptions,AutoCorrect->False],{}},
		{SafeOptions[PlotTable,listedOptions,AutoCorrect->False],Null}
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

	unresolvedOptions = listedOptions;

	combinedOptions=ReplaceRule[safeOptions,unresolvedOptions];

	(* If we are displaying object references by names, let do that conversion now *)
	namedItems = If[Lookup[combinedOptions, ShowNamedObjects],
		(* True case *)
		NamedObject[items],
		(* False case: let's at least remove any links from objects *)
		ReplaceAll[items, {link_Link:>Download[link, Object]}]
	];


	(* Call resolve<Function>Options *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{{itemsWithHeaders, resolvedOptions}, resolvedOptionsTests}=If[gatherTests,
			resolvePlotTableOptions[namedItems,listedOptions,combinedOptions,Output->{Result,Tests}],
			{resolvePlotTableOptions[namedItems,listedOptions,combinedOptions],Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Generate the table that the function should output *)
	outputTable=If[MatchQ[resolvedOptionsResult,$Failed],
		$Failed,
		generateTable[namedItems, itemsWithHeaders, resolvedOptions]
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview->If[MemberQ[output,Preview],
		outputTable,
		Null
	];

   (* Prepare the Options result if we were asked to do so *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[PlotTable,resolvedOptions],
		Null
	];


	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Join[safeOptionTests,resolvedOptionsTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
		outputTable,
		Null
	];

	(* Return the specified update *)
	outputSpecification/.{previewRule,optionsRule,testsRule,resultRule}
];



(*
	Given objects and fields
*)
PlotTable[objects:ListableP[ObjectP[]],fields_,ops:OptionsPattern[]]:=Module[{
	safeOps,tableHeadings,
	allObjects,listedFields,allVals,
	tableObjects,tableFields,tableVals,table,passingOptions
},

	safeOps = SafeOptions[PlotTable, ToList[ops]];

	(* make sure we have a list of objects *)
	allObjects = ToList[objects];

	(*  Check the pattern - we do not limit the patterns of fields because that will run through a pattern match. Then we may run into Part error *)
	If[!Quiet[MatchQ[fields,ListableP[FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)]],Part::partd],
		Message[PlotTable::FieldsPatternMismatch];
		Return[$Failed]
	];

	(* make sure we have a list of fields, and put object at the beginning (for table headings) *)
	listedFields = If[Quiet[MatchQ[fields,FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)],Part::partd],
		{fields},
		fields
	];

	(* download the fields *)
	allVals = Download[
		{allObjects,allObjects},
		{{Object},listedFields}
	];

	(* pull out the objects, to use for table headings *)
	tableObjects = allVals[[1,;;,1]];

	(* pull out all the values except the objects, to put in the table *)
	tableVals = allVals[[2]];

	(* pull out all fields except the first (object) for table headings *)
	tableFields = listedFields;

	(* resolve TableHeadings option, using object and field names as defaults *)
	tableHeadings = resolveObjectFieldTableHeadings[Lookup[safeOps,TableHeadings],tableObjects,tableFields];

	(* The duplicated options are removed before passing to plotTable *)
	passingOptions=ReplaceRule[ToList[ops],{TableHeadings->tableHeadings}];

	(* pass to raw input case of PlotTable *)
	PlotTable[
		tableVals,
		Evaluate[passingOptions]
	]

];

SetAttributes[PlotTable, HoldRest];


(* ::Subsubsection:: *)
(*resolvePlotTableOptions*)


DefineOptions[resolvePlotTableOptions,
	Options:>{
		{Output->Result,ListableP[Result|Tests],"Indicates the return value of the function."}
	}
];


resolvePlotTableOptions[items_, listedOptions_, myOptions:{(_Rule|_RuleDelayed)..}, ops:OptionsPattern[]]:= Module[
	{output, listedOutput, collectTestsBoolean, messagesBoolean, rowLabels,colLabels,numCols,numRows,headingTestDescriptionRow,headingTestDescriptionCol, headingTest,
	tableHeader, secondaryHeaders,dividers,resolvedDividers,alignment,gridOptions,
	secondTableHeader,resolvedOptions, allTests, itemsWithHeaders},

	(* From resolvePlotTableOptions's options, get Output value *)
	output=OptionDefault[OptionValue[Output]];
	listedOutput=ToList[output];
	collectTestsBoolean=MemberQ[listedOutput,Tests];

	(* Print messages whenever we're not getting tests instead *)
	messagesBoolean=!collectTestsBoolean;

	(* --- resolve TableHeadings option. In this non-object case default is no headings --- *)
	numCols=Max[Length/@items];
	numRows=Length[items];

	tableHeader = Lookup[myOptions,TableHeadings];
	{rowLabels,colLabels} = NamedObject[Quiet[resolveTableHeadings[tableHeader,{numRows,numCols}]]];
	headingTestDescriptionRow=PlotTable::RowLabelMismatch;
	headingTestDescriptionCol=PlotTable::ColumnLabelMismatch;
	headingTest = {
		testOrNull[TableHeadings, collectTestsBoolean, headingTestDescriptionRow, MemberQ[ToList[tableHeader], Automatic|None] || Length[First[tableHeader]]== numRows],
		testOrNull[TableHeadings, collectTestsBoolean, headingTestDescriptionCol, MemberQ[ToList[tableHeader], Automatic|None] || Length[Last[tableHeader]]== numCols]
	};

	(* --- Resolve SecondaryTableHeadings --- *)
	(* Span the secondary headers as required. Also add formatting to them. *)
	secondTableHeader = Lookup[myOptions,SecondaryTableHeadings];
    secondaryHeaders = NamedObject[resolveSecondaryTableHeadings[secondTableHeader,{numRows,numCols},myOptions]];

	(* --- Resolve Dividers --- *)
	dividers = Dividers/.listedOptions;
	resolvedDividers=resolveDividers[dividers,rowLabels,secondaryHeaders[[1]],colLabels,secondaryHeaders[[-1]]];

	(*---  Resolve Alignment   ---*)
	itemsWithHeaders = resolveItemsWithHeaders[items, rowLabels, colLabels, secondaryHeaders, myOptions];
	alignment = resolveAlignment[rowLabels,secondaryHeaders[[1]],colLabels,secondaryHeaders[[-1]],itemsWithHeaders];

	(* Resolve desired unspecified options and append to user-specified grid options *)
	gridOptions=Join[{
		Dividers->resolvedDividers,
		Background->If[MatchQ[Background/.listedOptions,Background],{None,{{RGBColor["#E2E2E2"],None}}},Background/.listedOptions],
		Alignment->If[MatchQ[Alignment/.listedOptions,Alignment],alignment,Alignment/.listedOptions],
		Spacings->If[MatchQ[Spacings/.listedOptions,Spacings],{Automatic,1},Spacings/.listedOptions],
		Frame->If[MatchQ[Frame/.listedOptions,Frame],Directive[RGBColor["#8E8E8E"],Thickness@1],Frame/.listedOptions],
		ItemSize->If[MatchQ[ItemSize/.listedOptions,ItemSize],{{All,All}},ItemSize/.listedOptions]
	},myOptions];

	resolvedOptions = ReplaceRule[myOptions,
		Join[{
			TableHeadings -> {rowLabels,colLabels},
			SecondaryTableHeadings -> secondaryHeaders
		}, gridOptions]
	];

	(* Populate the only test here *)
	allTests=headingTest;

	(* Return requested results *)
	output/.{Tests->allTests,Result->{itemsWithHeaders,resolvedOptions}}
];


testOrNull[option_,makeTest:BooleanP,description_,expression_]:=If[makeTest,
	Test[description,expression,True],
	(* if tests are not requested to be returned, throw an error when fail *)
	If[expression,
		Null,

		plotTableMessages[option, description];
		Message[Error::InvalidOption,option]
	]
];


plotTableMessages[option_, description_]:= Module[
	{},

	If[MatchQ[description, PlotTable::RowLabelMismatch],
		Message[PlotTable::RowLabelMismatch]
	];

	If[MatchQ[description, PlotTable::ColumnLabelMismatch],
		Message[PlotTable::ColumnLabelMismatch]
	];

];


(* ::Subsubsection::Closed:: *)
(*resolveItemsWithHeaders*)


resolveItemsWithHeaders[items_, rowLabels_, colLabels_, secondaryHeaders_, myOptions_]:= Module[
	{processedItems, rowLabelsFormatted, colLabelsFormatted, secondaryRowLabelsFormatted, numCols,numRows,
	secondaryColumnLabelsFormatted, formattedItems,itemsWithRowHeaders, itemsWithHeaders},

	(* round and UnitForm items *)
  processedItems = processItems[items,{2},myOptions];

  (* number of columns is size of longest row *)
	numCols=Max[Length/@items];

	(* number of rows *)
	numRows=Length[items];

  (* format the headers *)
	rowLabelsFormatted = formatTableHeaders[rowLabels,processedItems,myOptions];
	colLabelsFormatted = formatTableHeaders[colLabels,Transpose[PadRight[processedItems, {Length[processedItems], Max[Length /@ processedItems]}, ""]],myOptions];

  (* add formatting to secondary headers *)
	secondaryRowLabelsFormatted = secondaryHeaders[[1]];
  secondaryColumnLabelsFormatted = secondaryHeaders[[-1]];

  (* Format the items. Put them in a button to facilitate copying the un-stylized value. *)
  formattedItems = If[
    MatchQ[Lookup[myOptions,Tooltips],True],
    Map[
     Tooltip[
        Button[
          Style[#,FontSize -> 11],
          CopyToClipboard[#],
          Appearance -> None, Method -> "Queued"
        ],
      "Copy value clipboard"]&,
      processedItems,
      {2}
    ],
    Map[
      Style[#,FontSize -> 11]&,
      processedItems,
      {2}
    ]
  ];

	(* Add the primary and secondary row headers to the data *)
  itemsWithRowHeaders=Switch[{rowLabels, secondaryRowLabelsFormatted},

    (* No primary or secondary row headers *)
    {{"" ..}, None},
    formattedItems,

    (* Primary but no secondary row headers *)
    {Except[{"" ..}], None},
    Flatten /@ Transpose[{rowLabelsFormatted, formattedItems}],

    (* Secondary but no primary row headers *)
    {{"" ..}, Except[None]},
    Flatten /@ Transpose[{Flatten[secondaryRowLabelsFormatted], formattedItems}],

    (* Primary and secondary row headers *)
    {Except[{"" ..}], Except[None]},
    Flatten /@ Transpose[{Flatten[secondaryRowLabelsFormatted], rowLabelsFormatted, formattedItems}]
  ];

	(* add headings to the data unless they were specified as None *)
	itemsWithHeaders=Switch[{colLabels, secondaryColumnLabelsFormatted},

    (*No primary or secondary column headers*)
    {{"" ..}, None},
    itemsWithRowHeaders,

    (*Primary but no secondary column headers *)
    {Except[{"" ..}], None},
    Prepend[itemsWithRowHeaders, PadLeft[colLabelsFormatted, Max[Length /@ itemsWithRowHeaders], ""]],

    (*Secondary but no primary column headers *)
    {{"" ..}, Except[None]},
    Prepend[itemsWithRowHeaders, PadLeft[Flatten[secondaryColumnLabelsFormatted], Max[Length /@ itemsWithRowHeaders], ""]],

    (*Primary and secondary column headers *)
    {Except[{"" ..}], Except[None]},
    Join[{PadLeft[Flatten[secondaryColumnLabelsFormatted], Max[Length /@ itemsWithRowHeaders], ""]}, {PadLeft[colLabelsFormatted, Max[Length /@ itemsWithRowHeaders], ""]}, itemsWithRowHeaders]
  ];

	(* Return items with headers *)
  itemsWithHeaders
];


(* ::Subsubsection:: *)
(*generateTable*)


generateTable[items_, itemsWithHeaders_, resolvedOptions_]:= Module[
	{stripTooltip, filteredOptions, resolvedTitle, styledTitle, styledCaption, gridCells, grid, scrollBarQ},

	(* Quick and dirty helper function for stripping tooltip/buttons *)
	stripTooltip[x_]:=x/.{Tooltip[Button[patt_, ___], ___]:>patt};

	(* filter out some things we don't want to be altered *)
	filteredOptions = FilterRules[{PassOptions[PlotTable,Grid,resolvedOptions]},Except[Editable|Selectable|DeleteWithContents]];

	(* Use the resolved title option, switching None to object name + field given a single object input with single field *)
	resolvedTitle=Lookup[resolvedOptions,Title]/.{
		If[Length[Dimension[items]]>1&&MatchQ[Dimensions[items][[;;2]],{1,1}]&&MatchQ[items[[1,1]],{_Association..}],
			None->Row[{
				stripTooltip@itemsWithHeaders[[-1,1]],
				"[",
				stripTooltip@itemsWithHeaders[[1,-1]],
				"]"
			}],
			Nothing
		]
	};

	(* Stylize the table title *)
	styledTitle=Item[Style[resolvedTitle,Bold,11,FontFamily->"Helvetica",RGBColor["#4A4A4A"]],Alignment->Center];

	(* Stylize the table caption *)
	styledCaption=Item[Style[Lookup[resolvedOptions,Caption],11,FontFamily->"Helvetica",RGBColor["#4A4A4A"]],Alignment->Left];

	(* If the input is a single named multiple field, then use that directly without building ane xtra grid *)
	gridCells=If[Length[Dimension[items]]>1&&MatchQ[Dimensions[items][[;;2]],{1,1}]&&MatchQ[items[[1,1]],{_Association..}],
		itemsWithHeaders[[-1,-1]],
		Grid[itemsWithHeaders,filteredOptions]
	];

	(* make the grid *)
	grid=Switch[{resolvedTitle,Lookup[resolvedOptions,Caption]},
		{Except[None],Except[None]},
			Labeled[gridCells,{styledTitle,styledCaption},{Top,{Bottom,Left}},Editable->False],

		{Except[None],None},
			Labeled[gridCells,{styledTitle},{Top},Editable->False],

		{None,Except[None]},
			Labeled[gridCells,{styledCaption},{Bottom},Editable->False],

		_,
			gridCells
	];

	(* Wrap the output in a Pane for automatic scrollbars, if not explicitly turned off *)
	scrollBarQ=MatchQ[Lookup[resolvedOptions,HorizontalScrollBar],True|Automatic];

  	If[scrollBarQ,
		Pane[
			grid,
			(* We leave this Automatic if not user specified for Pane to determine when to user bar *)
			Scrollbars->{Lookup[resolvedOptions,HorizontalScrollBar],False},
			ImageSize -> {UpTo[Scaled[1]]}
		],
		grid
	]
];


(* ::Subsubsection:: *)
(*helper funcs*)


resolveDividers[dividers_,rowLabels_,secondaryRowLabelsFormatted_,colLabels_,secondaryColumnLabelsFormatted_]:=Module[
	{},

	(* If Dividers was specified or set to something other than Automatic, use it *)
	If[
		!MatchQ[dividers,Dividers|Automatic],
		dividers,

		(* Otherwise, determine the divider formatting based on whether row and column headers are present, or use the specified dividers *)
		{
			(* Vertical dividers *)
			{
				(* The default is light gray *)
				Directive[RGBColor["#CBCBCB"], Thickness@1],
				{
					(* The first divider is always darker *)
					1 -> Directive[RGBColor["#8E8E8E"], Thickness@1],

					(* The last divider is always darker *)
					-1 -> Directive[RGBColor["#8E8E8E"], Thickness@1],

					(* If there are at least one set of row headers, the second divider is darker *)
					If[MatchQ[rowLabels, Except[{"" ..}]] || MatchQ[secondaryRowLabelsFormatted, Except[None]], 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], Nothing],

					(* If there are both primary and secondary row headers, the third divider is darker *)
					If[MatchQ[rowLabels, Except[{"" ..}]] && MatchQ[secondaryRowLabelsFormatted, Except[None]], 3 -> Directive[RGBColor["#8E8E8E"], Thickness@1], Nothing]

				}
			},

			(* Horizontal dividers *)
			{
				(* The default is light gray *)
				Directive[RGBColor["#CBCBCB"], Thickness@1],
				{
					(* The first divider is always darker *)
					1 -> Directive[RGBColor["#8E8E8E"], Thickness@1],

					(* The last divider is always darker *)
					-1 -> Directive[RGBColor["#8E8E8E"], Thickness@1],

					(* If there are at least one set of column headers, the second divider is darker *)
					If[MatchQ[colLabels, Except[{"" ..}]] || MatchQ[secondaryColumnLabelsFormatted, Except[None]], 2 -> Directive[RGBColor["#8E8E8E"], Thickness@1], Nothing],

					(* If there are both primary and secondary column headers, the third divider is darker *)
					If[MatchQ[colLabels, Except[{"" ..}]] && MatchQ[secondaryColumnLabelsFormatted, Except[None]], 3 -> Directive[RGBColor["#8E8E8E"], Thickness@1], Nothing]
				}
			}
		}
	]
];


resolveAlignment[rowLabels_,secondaryRowLabelsFormatted_,colLabels_,secondaryColumnLabelsFormatted_,itemsWithHeaders_]:=Module[
	{},

	(* Assemble header alignment info *)
  {Left, Center, Join[
		Which[

		(* If primary row headers but not secondary row headers *)
    MatchQ[colLabels, Except[{"" ..}]] && MatchQ[secondaryColumnLabelsFormatted, None],
			Table[{1, x} -> {Center,Center}, {x, Length[itemsWithHeaders[[1]]]}],

  (* If secondary row headers but not primary row headers *)
    MatchQ[colLabels, {"" ..}] && MatchQ[secondaryColumnLabelsFormatted, Except[None]],
			Table[{1, x} -> {Left,Center}, {x, Length[itemsWithHeaders[[1]]]}],

  (* If primary and secondary row headers *)
    MatchQ[colLabels, Except[{"" ..}]] && MatchQ[secondaryColumnLabelsFormatted, Except[None]],
			Join[
				Table[{1, x} -> {Center,Center}, {x, Length[itemsWithHeaders[[1]]]}],
				Table[{2, x} -> {Left,Center}, {x, Length[itemsWithHeaders[[2]]]}]
			],

    True,
    Nothing
  ],
    Which[

    (* If primary column headers *)
      MatchQ[rowLabels, Except[{"" ..}]] && MatchQ[secondaryRowLabelsFormatted, None],
			Table[{x, 1} -> {Center,Center}, {x, Length[itemsWithHeaders]}],

    (* If secondary column headers but not primary column headers *)
      MatchQ[rowLabels, {"" ..}] && MatchQ[secondaryRowLabelsFormatted, Except[None]],
      Table[{x, 1} -> {Left,Center}, {x, Length[itemsWithHeaders]}],

    (* If primary and secondary column headers *)
      MatchQ[rowLabels, Except[{"" ..}]] && MatchQ[secondaryRowLabelsFormatted, Except[None]],
			Join[
				Table[{x, 1} -> {Center,Center}, {x, Length[itemsWithHeaders]}],
				Table[{x, 1} -> {Left,Center}, {x, Length[itemsWithHeaders]}]
			],

      True,
      Nothing
    ]]}

];


formatTableHeaders[headerList_,contents_,safeOps_]:=Module[{processedHeaders,backgroundOption,styledHeaders},

	(* format values in headers *)
	processedHeaders = Quiet[processItems[headerList,Infinity,safeOps], {Part::partd,Part::pspec1}];

    (* set style of other things in headers *)
    styledHeaders=Replace[processedHeaders,x_:>Style[x,Bold,11,FontFamily->"Helvetica",RGBColor["#4A4A4A"],TextAlignment->Lookup[safeOps,HeaderTextAlignment]],{1}];

	(* Make each header a button to copy the row/column contents *)
	If[
		MatchQ[Lookup[safeOps,Tooltips],True],
		MapThread[
			Tooltip[
				Button[
					#1,
					CopyToClipboard[#2],
					Appearance -> None, Method -> "Queued"
				],
				"Copy list to clipboard"]&,{styledHeaders,contents}],
		styledHeaders
	]


];




(*
	Replace Automatics with object and field values
*)
resolveObjectFieldTableHeadings[Automatic|{Automatic,Automatic},objects_,fields_]:={objects,fields};
resolveObjectFieldTableHeadings[{Automatic,cols_},objects_,fields_]:={objects,cols};
resolveObjectFieldTableHeadings[{rows_,Automatic},objects_,fields_]:={rows,fields};
resolveObjectFieldTableHeadings[{rows_,cols_},objects_,fields_]:={rows,cols};

(* If Secondary headers are None, result is None for both row and column *)
resolveSecondaryTableHeadings[None|{None,None},{numRows_Integer,numCols_Integer},safeOps_]:={None,None};

(* Pass the rox/column headers on to be resolved separately *)
resolveSecondaryTableHeadings[{rowHeaders_,columnHeaders_},{numRows_Integer,numCols_Integer},safeOps_]:={resolveSecondaryTableHeadings[rowHeaders,numRows,Row,safeOps],resolveSecondaryTableHeadings[columnHeaders,numCols,Column,safeOps]};

(* If Secondary headers are None for the row/column set, result is None *)
resolveSecondaryTableHeadings[None,cellLength_Integer,dimensionSpecification_,safeOps_]:=None;

(* If the secondary headers is given as a list with spanning info *)
resolveSecondaryTableHeadings[headersAndSpan:{{_,_Integer}..},cellLength_Integer,dimensionSpecification_,safeOps_]:=Module[{headers,spans,
  headersCellsRatio,spanningLength,spanningCells,processedHeaders,styledHeaders,spanningDirection},

(* Pull out the headers *)
  headers=headersAndSpan[[All,1]];

  (* Pull out the requested spans for each header *)
  spans=headersAndSpan[[All,2]];

  (* If the spanning specification does not match the number of cells, throw error and return None. *)
  If[Total[spans]=!=cellLength,
    Message[PlotTable::SecondaryLabelsSpanning,Total[spans],ToLowerCase[ToString[dimensionSpecification]] <> "s",cellLength];
    Return[None]
  ];

  (* format values in headers *)
  processedHeaders = Quiet[processItems[headers,Infinity,safeOps], {Part::partd,Part::pspec1}];

  (* set style of other things in headers *)
  styledHeaders=Replace[processedHeaders,x_:>Style[x,Bold,11,FontFamily->"Helvetica",RGBColor["#4A4A4A"],TextAlignment->Lookup[safeOps,HeaderTextAlignment]],{1}];

  (* Row headers span from above, column headers span from left *)
  spanningDirection=If[MatchQ[dimensionSpecification,Row],
    SpanFromAbove,
    SpanFromLeft
  ];

  (* For each header, Make a list of the "SpanFromLeft" fillers. (Subtract 1 from each to leave room for the header itself.) *)
  spanningCells=Table[spanningDirection,#-1]&/@spans;

  (* Insert "SpanFromLeft" cells after each header cell. *)
  MapThread[Join[ToList[#1], #2] &, {styledHeaders,spanningCells}]
];

(* If the secondary headers is given as a list without spanning info *)
resolveSecondaryTableHeadings[headers_List,cellLength_Integer,dimensionSpecification_,safeOps_]:=Module[{headersCellsRatio,spanningLength,spanningCells,
  processedHeaders,styledHeaders,spannedHeaders,spanningDirection},

(* Each header will span the number of cells divided by the number of headers *)
  headersCellsRatio=cellLength/Length[headers];

  (* If number of header cells exceeds number of cells, throw error and return None. *)
  If[Length[headers]>cellLength,
    Message[PlotTable::TooManySecondaryLabels,Length[headers],ToLowerCase[ToString[dimensionSpecification]] <> "s",cellLength];
    Return[None]
  ];

  (* If ratio is not an integer, throw warning message *)
  If[!IntegerQ[headersCellsRatio],
    Message[PlotTable::SecondaryLabelMismatch,Length[headers],ToLowerCase[ToString[dimensionSpecification]] <> "s",cellLength]
  ];

  (* format values in headers *)
  processedHeaders = Quiet[processItems[headers,Infinity,safeOps], {Part::partd,Part::pspec1}];

  (* set style of other things in headers *)
  styledHeaders=Replace[processedHeaders,x_:>Style[x,Bold,11,FontFamily->"Helvetica",RGBColor["#4A4A4A"],TextAlignment->Lookup[safeOps,HeaderTextAlignment]],{1}];

  (* Subtract 1 from the number of cells a header will span to leave space for the header itself *)
  spanningLength=headersCellsRatio-1;

  (* Row headers span from above, column headers span from left *)
  spanningDirection=If[MatchQ[dimensionSpecification,Row],
    SpanFromAbove,
    SpanFromLeft
  ];

  (* Make a list of the "SpanFromLeft" fillers. Table rounds down in the case that headersCellsRatio as not an integer. *)
  spanningCells=Table[spanningDirection,spanningLength];

  (* Insert "SpanFromLeft" cells after each header cell. *)
  spannedHeaders=Map[Join[ToList[#], spanningCells] &, styledHeaders];

  (* Since table rounds down, if the headers couldn't be divided evenly, pad the last header to cover the rest of the table *)
  Append[
    Most[spannedHeaders],
    Flatten[Append[Last[spannedHeaders], Table[spanningDirection, cellLength - Length[Flatten[spannedHeaders]]]]
    ]
  ]
];



(*
	Replace Automatics and lists with invalid lengths with lists of empty strings
*)

(* If the TableHeadings option is Automatic, expand to Automatic for rows and columns *)
resolveTableHeadings[Automatic,{numRows_,numCols_}]:=resolveTableHeadings[{Automatic,Automatic},{numRows,numCols}];

(* If columns is not specified as a list (i.e. it is Automatic or None), make is a list of "" equal to the number of columns *)
resolveTableHeadings[{rows_,Except[_List]},{numRows_,numCols_}]:=resolveTableHeadings[{rows,Table["",numCols]},{numRows,numCols}];

(* If rows is not specified as a list (i.e. it is Automatic or None), make is a list of "" equal to the number of rows *)
resolveTableHeadings[{Except[_List],cols_},{numRows_,numCols_}]:=resolveTableHeadings[{Table["",numRows],cols},{numRows,numCols}];

(* If either rows or columns is a list but does not match the number of row/columns, throw a message and default to automatic. Otherwise, use the rows/columns headers. *)
resolveTableHeadings[{rows_List,cols_List},{numRows_,numCols_}]:=	Which[
	Length[rows]=!=numRows,
	Message[PlotTable::RowLabelMismatch];
	resolveTableHeadings[{Automatic,cols},{numRows,numCols}],

	Length[cols]=!=numCols,
	Message[PlotTable::ColumnLabelMismatch];
	resolveTableHeadings[{rows,Automatic},{numRows,numCols}],

	True,
	{rows,cols}
];


(* processItems rounds and replaces Units with its corresponding UnitForm, depending on the option values for Round and UnitForm *)
processItems[items_,levelSpec_,safeOps_List]:=Module[
	{roundOption,unitFormItems,roundedItems,namedMultipleQ,finalItems},

	(* Get the Round option *)
	roundOption = Lookup[safeOps,Round];

	(* Send any unit-ed values to be converted rounded unit-scaled strings *)
	unitFormItems = If[Lookup[safeOps,UnitForm],
		Replace[items,x:UnitsP[]:>UnitForm[x,Round->roundOption],levelSpec],
		items
	];

	(* Round any remaining items if requested *)
	(* By first converting/rounded units to unitform we avoid any double rounding here *)
	(* UnitsP matches quantities and plain numbers *)
	roundedItems = Which[
		MatchQ[roundOption,UnitsP[]],
		Replace[unitFormItems,x:UnitsP[]:>Round[x,roundOption],levelSpec],

		roundOption,
		Replace[unitFormItems,x:UnitsP[]:>Round[x,$RoundIncrement],levelSpec],

		True,
		unitFormItems
	];

	(* Define a pattern for named multiple fields *)
	namedMultipleQ[vals_]:=And[
		MatchQ[vals, {_Association..}],
		Equal@@Keys[vals]
	];

	(* Replace named multiple associations with table representations *)
	finalItems = Replace[
		roundedItems,
		namedMultipleAssociation_?namedMultipleQ:>namedMultipleTable[namedMultipleAssociation],
		levelSpec
	];

	(* Return the fully processed items *)
	finalItems
];


(* Given a list of associations from a named multiple field, generate a subtable using PlotTable *)
namedMultipleTable[assocList_]:=Module[
	{headers, entries},

	(* We are guaranteed all associations in the input have the same keys in the same order, so take headers from first entry *)
	headers = Keys[FirstOrDefault[assocList]];

	(* Strip entries out of the list of associations *)
	entries = Values/@assocList;

	(* Call PlotTable to generate the subtable *)
	PlotTable[entries, TableHeadings->{None, headers}]
];


(* ::Subsection::Closed:: *)
(*PlotTableOptions*)


DefineOptions[PlotTableOptions,
	SharedOptions :> {PlotTable},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];


PlotTableOptions[items:{_List..},ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = PlotTable[items,Evaluate[Append[noOutputOptions,Output->Options]]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,PlotTable],
		options
	]
];


PlotTableOptions[objects:ListableP[ObjectP[]],fields_,ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(*  Check the pattern - we do not limit the patterns of fields because that will run through a pattern match. Then we may run into Part error *)
	If[!Quiet[MatchQ[fields,ListableP[FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)]],Part::partd],
		Message[PlotTable::FieldsPatternMismatch];
		Return[$Failed]
	];

	listedOptions = ToList[ops];

	(* remove the Output and OutputFormat option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

	options = PlotTable[objects,fields,Evaluate[Append[noOutputOptions,Output->Options]]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,PlotTable],
		options
	]
];

SetAttributes[PlotTableOptions, HoldRest];


(* ::Subsection::Closed:: *)
(*PlotTablePreview*)


DefineOptions[PlotTablePreview,
	SharedOptions :> {PlotTable}
];


PlotTablePreview[items:{_List..},ops:OptionsPattern[]]:=Module[
	{preview},

	preview = PlotTable[items,Evaluate[Append[ToList[ops],Output->Preview]]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];


PlotTablePreview[objects:ListableP[ObjectP[]],fields_,ops:OptionsPattern[]]:=Module[
	{preview},

	(*  Check the pattern - we do not limit the patterns of fields because that will run through a pattern match. Then we may run into Part error *)
	If[!Quiet[MatchQ[fields,ListableP[FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)]],Part::partd],
		Message[PlotTable::FieldsPatternMismatch];
		Return[$Failed]
	];

	preview = PlotTable[objects,fields,Evaluate[Append[ToList[ops],Output->Preview]]];

	If[MatchQ[preview, $Failed|Null],
		Null,
		preview
	]
];

SetAttributes[PlotTablePreview, HoldRest];


(* ::Subsection::Closed:: *)
(*ValidPlotTableQ*)


DefineOptions[ValidPlotTableQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {PlotTable}
];


ValidPlotTableQ[items:{_List..},ops:OptionsPattern[]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=PlotTable[items,Evaluate[preparedOptions]];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},
		functionTests
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* TODO: update to call with options or use different function once that's worked out*)
	(* Run the tests as requested *)
	RunUnitTest[<|"ValidPlotTableQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidPlotTableQ"]
];


ValidPlotTableQ[objects:ListableP[ObjectP[]],fields_,ops:OptionsPattern[]]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

	(*  Check the pattern - we do not limit the patterns of fields because that will run through a pattern match. Then we may run into Part error *)
	If[!Quiet[MatchQ[fields,ListableP[FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)]],Part::partd],
		Message[PlotTable::FieldsPatternMismatch];
		Return[$Failed]
	];

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=PlotTable[objects, fields, Evaluate[preparedOptions]];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBooleans,inputObjs,voqWarnings,testResults},
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			inputObjs = Cases[Flatten[objects,1], _Object | _Model];

			If[!MatchQ[inputObjs, {}],
				validObjectBooleans=ValidObjectQ[inputObjs,OutputFormat->Boolean];

				voqWarnings=MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjs,validObjectBooleans}
				];

				(* Get all the tests/warnings *)
				Join[functionTests,voqWarnings],

				functionTests
			]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat} = OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* TODO: update to call with options or use different function once that's worked out*)
	(* Run the tests as requested *)
	RunUnitTest[<|"ValidPlotTableQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidPlotTableQ"]
];


SetAttributes[ValidPlotTableQ,HoldRest];
