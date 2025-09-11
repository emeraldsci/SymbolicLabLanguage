(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTable*)


DefineTests[PlotTable,{

	Example[{Basic,"Create a table containing information about the samples from a protocol:"},
		PlotTable[
			Object[Protocol, Incubate, "id:54n6evKY3Mn7"][SamplesIn],
			{ModelName,Status,Volume,Container}
		],
		_Pane
	],

	Example[{Basic,"Create a table containing fields from sample packets:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status}
		],
		_Pane
	],

	Example[{Basic,"Table of numbers:"},
		PlotTable[RandomInteger[{0,10000},{25,20}]],
		_Pane
	],

	Example[{Basic,"Table a ragged array:"},
		PlotTable[Table[Range[i],{i,5}],TableHeadings->{{1,2,3,4,5},{1,2,3,4,5}}],
		_Pane
	],

	Example[{Additional,"Display some fields from a single object:"},
		PlotTable[
			Object[Analysis,Peaks,"id:R8e1PjRv4elj"],
			{Position,Height,Area,DateCreated,Author}
		],
		_Pane
	],

	Example[{Additional,"Display one field from several objects:"},
		PlotTable[
			{Object[Data,Volume,"id:Vrbp1jGnnBjo"],Object[Data,Volume,"id:XnlV5jmdd8jz"],Object[Data,Volume,"id:qdkmxz0RROz0"],Object[Data,Volume,"id:R8e1PjRvvmjp"],Object[Data,Volume,"id:9RdZXvK88wWL"]},
			DateCreated
		],
		_Pane
	],

	Example[{Additional,"Display a named multiple field in an object:"},
		PlotTable[
			Object[Analysis, Peaks, "id:1ZA60vLKd6XE"],
			PeakAssignmentLibrary
		],
		_Pane
	],

	Example[{Additional,"Display a named multiple field from multiple objects:"},
		PlotTable[
			{Object[Analysis, Peaks, "id:01G6nvwPRb81"], Object[Analysis, Peaks, "id:1ZA60vLP57Ka"]},
			PeakAssignmentLibrary
		],
		_Pane
	],

	Example[{Additional,"Display multiple fields, including a named multiple, from multiple objects:"},
		PlotTable[
			Object[Analysis, Peaks, "id:1ZA60vLKd6XE"],
			{Position, PeakAssignmentLibrary, DateCreated}
		],
		_Pane
	],

	Example[{Options,TableHeadings,"Specify row and column headings:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			TableHeadings->{{"A","B","C"},{"1","2","3","4"}}
		],
		_Pane
	],

	Example[{Options,TableHeadings,"Specify only row headings:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			TableHeadings->{{"A","B","C"},Automatic}
		],
		_Pane
	],

	Example[{Options,TableHeadings,"Specify only column headings:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			TableHeadings->{Automatic,{"1","2","3","4"}}
		],
		_Pane
	],

	Example[{Options,TableHeadings,"Specify row and column headings:"},
		PlotTable[RandomInteger[{0,100000},{20,20}],TableHeadings->{Table["Row "<>ToString[x],{x,Range[20]}],Table["Column "<>ToString[x],{x,Range[20]}]}],
		_Pane
	],

	Example[{Options,TableHeadings,"Automatic row and column headings will default to the objects and fields when plotting objects:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status}
		],
		_Pane
	],

	Example[{Options,TableHeadings,"Automatic row and column headings will default to no headers when plotting non-objects:"},
		PlotTable[RandomInteger[{0, 10000}, {5, 3}]],
		_Pane
	],

	Example[{Options,TableHeadings,"If TableHeadings is specified as None for the rows, no row heading cells are displayed:"},
		PlotTable[RandomInteger[{0, 10000}, {5, 3}],
			TableHeadings -> {None, {"1", "2", "3"}}],
		_Pane
	],

	Example[{Options,TableHeadings,"If TableHeadings is specified as None for the columns, no column heading cells are displayed:"},
		PlotTable[RandomInteger[{0, 10000}, {5, 3}],
			TableHeadings -> {{"A", "B", "C", "D", "E"}, None}],
		_Pane
	],
	Example[{Options,HeaderCopy,"If HeaderCopy is specified as Contents, clicking on the header of a row will copy the contents of the row:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			HeaderCopy -> Contents
		],
	    _Pane
	],
	Example[{Options,HeaderCopy,"If HeaderCopy is specified as Header, clicking on the header of a row will copy the object in the header of the row:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			HeaderCopy -> Header
		],
		_Pane
	],
	Example[{Options,SecondaryTableHeadings,"Specify secondary row and column headings:"},
		PlotTable[
			Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],
			{ModelName,Volume,Concentration,Status},
			SecondaryTableHeadings->{{"A","B","C"},{"1","2","3","4"}}
		],
		_Pane
	],

	Example[{Options, SecondaryTableHeadings,"Specify only secondary row headings:"},
		PlotTable[
			Download[{Object[Sample, "id:pZx9jon410JM"],Object[Sample, "id:n0k9mGz54Ne3"],Object[Sample, "id:D8KAEvdeYOYL"]}],
			{ModelName, Volume, Concentration, Status},
			SecondaryTableHeadings -> {{"A", "B", "C"}, None}
		],
		_Pane
	],

	Example[{Options, SecondaryTableHeadings,"Specify only secondary column headings:"},
		PlotTable[
			Download[{Object[Sample, "id:pZx9jon410JM"],Object[Sample, "id:n0k9mGz54Ne3"],Object[Sample, "id:D8KAEvdeYOYL"]}],
			{ModelName, Volume, Concentration, Status},
			SecondaryTableHeadings -> {None, {"1", "2", "3", "4"}}
		],
		_Pane
	],

	Example[{Options, SecondaryTableHeadings, "Specify secondary row and column headings:"},
		PlotTable[
			RandomInteger[{0, 100000}, {20, 20}],
			SecondaryTableHeadings -> {Table["Row " <> ToString[x], {x, Range[20]}], Table["Column " <> ToString[x], {x, Range[20]}]}
		],
		_Pane
	],

	Example[{Options, SecondaryTableHeadings, "Specify secondary row and column headings that span multiple cells:"},
		PlotTable[
			RandomInteger[{0, 100000}, {20, 20}],
			SecondaryTableHeadings -> {{"Category A","Category B"}, {"Category 1", "Category 2", "Category 3", "Category 4"}},
			TableHeadings -> {Table["Row " <> ToString[x], {x, Range[20]}], Table["Column " <> ToString[x], {x, Range[20]}]}
		],
		_Pane
	],

	Example[{Options, SecondaryTableHeadings,"Specify secondary row and column headings that span a specified number of cells:"},
		PlotTable[
			RandomInteger[{0, 100000}, {20, 20}],
			SecondaryTableHeadings -> {{{"Category A", 3}, {"Category B", 17}}, {{"Category 1", 4}, {"Category 2", 1}, {"Category 3", 6}, {"Category 4", 9}}},
			TableHeadings -> {Table["Row " <> ToString[x], {x, Range[20]}], Table["Column " <> ToString[x], {x, Range[20]}]}
		],
		_Pane
	],

	Example[{Options,AllowedDimensions,"Restrictions on number of rows or columns:"},
		PlotTable[RandomInteger[{0,10},{5,3}], AllowedDimensions->{3,Automatic}],
		_Pane
	],

	Example[{Options,AutoDelete,"Whether to remove the grid structure if only one item remains:"},
		PlotTable[{{100}}, AutoDelete->False],
		_Pane
	],

	Example[{Options,BaselinePosition,"What to align with a surrounding text baseline:"},
		{x,PlotTable[{{"a","b"},{"c","d"}}, BaselinePosition->Top],y},
		{x,_Pane,y}
	],

	Example[{Options,BaseStyle,"Base style specifications for the grid:"},
		PlotTable[{{Graphics[Circle[]],2,3},{4,5,6}},BaseStyle->Blue],
		_Pane
	],

	Example[{Options,DefaultElement,"What element to insert in an empty item:"},
		PlotTable[{{"a","b"},{"c","\[Placeholder]"}}, DefaultElement->"\[HappySmiley]"],
		_Pane
	],

	Example[{Options,Dividers,"Specify where to draw borders between cells in the grid:"},
		PlotTable[Table[x,{10},{10}],Spacings->1,Dividers->#]&/@{True,None,All,Center},
		{_Pane..}
	],

	Example[{Options,Dividers,"Independently format each border in the grid:"},
		PlotTable[Table[x,{10},{10}],Spacings->1,Dividers->{{2->Directive[Dotted]},{1->Blue,2->Directive[Thick,Red]}}],
		_Pane
	],

	Example[{Options,FrameStyle,"Apply global formatting to all borders in the grid:"},
		PlotTable[Table[x,{10},{10}],Spacings->1,Dividers->All,FrameStyle->Directive[Thick,Red]],
		_Pane
	],

	Example[{Options,Frame,"Format the outermost border:"},
		PlotTable[Table[x,{10},{10}],Spacings->1,Dividers->True,FrameStyle->Directive[Thick,Red],Frame->True],
		_Pane
	],

	Example[{Options,ItemSize,"Width and height of each item:"},
		PlotTable[{{30!,50!}},ItemSize->10],
		_Pane
	],

	Example[{Options,ItemStyle,"Style individual elements in the grid:"},
		PlotTable[RandomInteger[{0,10},{5,3}],ItemStyle->{{Red,Blue,Red}}],
		grid_/;MatchQ[grid,_Pane]&&MatchQ[ItemStyle/.grid[[1,2]],{{RGBColor[1, 0, 0],RGBColor[0, 0, 1],RGBColor[1, 0, 0]}}]
	],

	Example[{Options,Alignment,"Specify alignment of rows and columns:"},
		PlotTable[{{Graphics[Circle[]],2,3},{4,5,6}},TableHeadings->{{1,2},{1,2,3}},Alignment->{Right,Bottom}],
		_Pane
	],

	Example[{Options,Dividers,"Specify dividers between rows and columns:"},
		PlotTable[Table[Range[i],{i,5}],TableHeadings->{{1,2,3,4,5},{1,2,3,4,5}},Dividers->{{False,False,True,False,True},True}],
		_Pane
	],

	Example[{Options,Spacings,"Specify spacings between rows and columns:"},
		PlotTable[Table[Range[i],{i,5}],TableHeadings->{{1,2,3,4,5},{1,2,3,4,5}},Spacings->{2,0}],
		_Pane
	],

	Example[{Options,UnitForm,"UnitForm will automatically UnitForm any Units in the input data:"},
		PlotTable[{{1Micro Liter,2Micro Liter,3Micro Liter},{1 Meter, 5 Meter, 1 Milli Meter}},TableHeadings->{{1,2},{1,2,3}},UnitForm->True],
		_Pane
	],

	Example[{Options,Round,"Round will automatically round any numbers in the input data:"},
		PlotTable[{{1.001111Micro Liter,2Micro Liter,3Micro Liter},{1 Meter, 5 Meter, 1 Milli Meter}},TableHeadings->{{1,2},{1,2,3}},Round->True],
		_Pane
	],

	Example[{Options,Round,"Specify the digit to which the quantities should be rounded:"},
		PlotTable[{{1.001111Micro Liter,2Micro Liter,3Micro Liter},{1 Meter, 5 Meter, 1 Milli Meter}},TableHeadings->{{1,2},{1,2,3}},Round->0.002],
		_Pane
	],

	Example[{Options, ShowNamedObjects, "ShowNamedObjects will automatically convert any objects with names to the named versions:"},
		PlotTable[{Object[Sample, "id:pZx9jon410JM"], Object[Sample, "id:n0k9mGz54Ne3"], Object[Sample, "id:D8KAEvdeYOYL"]}, {Object, Volume},ShowNamedObjects->True],
		_Pane
	],

	Test["Automatically convert any objects with names to the named versions:",
		table = PlotTable[{Object[Sample, "id:pZx9jon410JM"], Object[Sample, "id:n0k9mGz54Ne3"], Object[Sample, "id:D8KAEvdeYOYL"]}, {Object, Volume},ShowNamedObjects->True];
		Cases[table[[1, 1, 2 ;;, 2]], target_Style :> First[target], Infinity][[;; , -1]],
		Download[{Object[Sample, "id:pZx9jon410JM"], Object[Sample, "id:n0k9mGz54Ne3"], Object[Sample, "id:D8KAEvdeYOYL"]}, Name],
		Variables :> {table}
	],

	Test["Shows objects with IDs when naming is not desired:",
		table = PlotTable[{Object[Sample, "id:pZx9jon410JM"], Object[Sample, "id:n0k9mGz54Ne3"], Object[Sample, "id:D8KAEvdeYOYL"]}, {Object, Volume},ShowNamedObjects->False];
		Cases[table[[1, 1, 2 ;;, 2]], target_Style :> First[target], Infinity][[;; , -1]],
		Download[{Object[Sample, "id:pZx9jon410JM"], Object[Sample, "id:n0k9mGz54Ne3"], Object[Sample, "id:D8KAEvdeYOYL"]}, ID],
		Variables :> {table}
	],

	Example[{Options,Background,"Background specifies the background of the table:"},
		PlotTable[RandomInteger[{0,100000},{10,10}],TableHeadings->{Range[10],Range[10]},Background->{None,{{White,White,Red}}}],
		_Pane
	],

	Example[{Options,ItemStyle,"Pass other Grid options to PlotTable:"},
		PlotTable[RandomInteger[{0,100000},{10,10}],TableHeadings->{Range[10],Range[10]},ItemStyle->"Section"],
		_Pane
	],

	Example[{Options,HeaderTextAlignment,"Align the text of a header to the right:"},
		PlotTable[{{Graphics[Circle[]],123},{456,789}},TableHeadings->{{"Aligned\nRight","Aligned\nRight"},{"Aligned\nRight","Aligned\nRight"}},HeaderTextAlignment->Right],
		_Pane
	],

	Example[{Options,Title,"Specify a title to dipslay above the table:"},
		PlotTable[RandomInteger[{0,100000},{5,3}],Title->"My Table"],
		_Pane
	],

	Example[{Options,Caption,"Specify a caption to dipslay below the table:"},
		PlotTable[RandomInteger[{0,10},{5,3}],Caption->"Figure 1: Random numbers from 0 to 10."],
		_Pane
	],

	Example[{Options,HorizontalScrollBar,"Specify that the table should have a horizontal scroll bar:"},
		PlotTable[RandomInteger[{0,10},{5,300}],HorizontalScrollBar->True],
		_Pane
	],

	Example[{Options,HorizontalScrollBar,"Specify that the table should not have a horizontal scroll bar:"},
		PlotTable[RandomInteger[{0,10},{5,300}],HorizontalScrollBar->False],
		_Grid
	],

	Example[{Options,Tooltips,"Turn off the tooltip buttons that appear when hovering over each cell:"},
		PlotTable[RandomInteger[{0,10},{5,3}],Tooltips->False],
		_Pane
	],

	Example[{Messages,"FieldsPatternMismatch","Fields input should be correct field names:"},
		PlotTable[{Object[Sample, "id:pZx9jon410JM"],Object[Sample, "id:n0k9mGz54Ne3"],Object[Sample, "id:D8KAEvdeYOYL"]},"My Wrong Field Names"],
		$Failed,
		Messages:>{PlotTable::FieldsPatternMismatch}
	],

	Example[{Messages,"ColumnLabelMismatch","Column labels have the wrong length:"},
		PlotTable[RandomInteger[{0,100000},{5,5}],TableHeadings->{Range[5],Range[6]}],
		$Failed,
		Messages:>{PlotTable::ColumnLabelMismatch, Error::InvalidOption}
	],

	Example[{Messages,"RowLabelMismatch","Row labels have the wrong length:"},
		PlotTable[RandomInteger[{0,100000},{5,5}],TableHeadings->{Range[3],Range[5]}],
		$Failed,
		Messages:>{PlotTable::RowLabelMismatch, Error::InvalidOption}
	],

	Example[{Messages,"SecondaryLabelsSpanning","Secondary labels have invalid spanning specifications:"},
		PlotTable[RandomInteger[{0, 100000}, {10, 10}], SecondaryTableHeadings -> {{{"Category A", 3}, {"Category B", 17}}, None}],
		_Pane,
		Messages:>PlotTable::SecondaryLabelsSpanning
	],

	Example[{Messages,"SecondaryLabelMismatch","Secondary labels cannot be evenly divided over the number of cells:"},
		PlotTable[RandomInteger[{0, 100000}, {3,3}], SecondaryTableHeadings -> {{"Category A", "Category B"}, None}],
		_Pane,
		Messages:>PlotTable::SecondaryLabelMismatch
	],

	Example[{Messages,"TooManySecondaryLabels","Too many secondary labels are specified:"},
		PlotTable[RandomInteger[{0, 100000}, {3,3}], SecondaryTableHeadings -> {{"Category A", "Category B","Category A", "Category B"}, None}],
		_Pane,
		Messages:>PlotTable::TooManySecondaryLabels
	],
	Example[{Attributes,HoldRest,"The subsequent arguments will be passed unevaluated:"},
		PlotTable[Object[Protocol, Incubate, "id:54n6evKY3Mn7"][SamplesIn],Type],
		_Pane
	]
}
];


(* ::Subsubsection:: *)
(*PlotTableOptions*)


DefineTests[PlotTableOptions, {
	Example[{Basic,"Resolve TableHeadings when input objects:"},
		PlotTableOptions[Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],{ModelName,Volume,Concentration,Status}],
		_Grid
	],
	Example[{Basic,"When TableHeadings are provided specifically, they should overwrite object names and fields:"},
		PlotTableOptions[Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],{ModelName,Volume,Concentration,Status},TableHeadings->{{"A","B","C"},{"1","2","3","4"}}],
		_Grid
	],
	Example[{Basic,"Same applies for SecondTableHeadings:"},
		PlotTableOptions[Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],{ModelName,Volume,Concentration,Status},SecondaryTableHeadings->{None,{"1","2","3","4"}}],
		_Grid
	],
	Example[{Options,OutputFormat,"Return the options as a list:"},
		PlotTableOptions[RandomInteger[{0,10000},{25,20}], OutputFormat->List],
		{TableHeadings -> {{"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""},
		   {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""}}, SecondaryTableHeadings -> {None, None}, UnitForm -> True,
		 Round -> False, ShowNamedObjects -> True, HeaderTextAlignment -> Left, Title -> None, Caption -> None, HorizontalScrollBar -> Automatic, Tooltips -> True,
			HeaderCopy -> Contents,
		 Dividers -> Automatic, FrameStyle -> Automatic,
		 Frame -> Directive[RGBColor[0.5568627450980392, 0.5568627450980392, 0.5568627450980392], Thickness[1]],
		 Alignment -> {Left, Center}, AutoDelete -> False,
		 Background -> {None, {{RGBColor[0.8862745098039215, 0.8862745098039215, 0.8862745098039215], None}}}, BaseStyle -> GrayLevel[1],
		 DefaultElement -> "\[Placeholder]", ItemSize -> {{All, All}}, ItemStyle -> None, Spacings -> {Automatic, 1}}
	]
}
];


(* ::Subsubsection:: *)
(*PlotTablePreview*)


DefineTests[PlotTablePreview, {
	Example[{Basic,"Return the table preview:"},
		PlotTablePreview[RandomInteger[{0, 10000}, {5, 3}]],
		_Pane
	],
	Example[{Basic,"Preview an object:"},
		PlotTablePreview[Object[Protocol, Incubate, "id:54n6evKY3Mn7"][SamplesIn],{ModelName,Status,Volume,Container}],
		_Pane
	],
	Example[{Basic,"Preview an object with headings specified:"},
		PlotTablePreview[Download[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]}],{ModelName,Volume,Concentration,Status},TableHeadings->{{"A","B","C"},{"1","2","3","4"}}],
		_Pane
	]
}
];


(* ::Subsubsection:: *)
(*ValidPlotTableQ*)


DefineTests[ValidPlotTableQ, {
	Example[{Basic,"Return test results for all the gathered tests/warning:"},
		ValidPlotTableQ[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]},{ModelName,Volume,Concentration,Status}],
		True
	],
	Example[{Basic,"The function will return False if there is an invalid option:"},
		ValidPlotTableQ[RandomInteger[{0,100000},{5,5}],TableHeadings->{Range[5],Range[6]}],
		False
	],
	Example[{Basic,"Regular list inputs:"},
		ValidPlotTableQ[RandomInteger[{0,10000},{5,3}],TableHeadings->{None,{"1","2","3"}}],
		True
	],
	Example[{Options,OutputFormat,"Specify OutputFormat to be TestSummary:"},
		ValidPlotTableQ[{Object[Sample,"id:pZx9jon410JM"],Object[Sample,"id:n0k9mGz54Ne3"],Object[Sample,"id:D8KAEvdeYOYL"]},{ModelName,Volume,Concentration,Status},OutputFormat->TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options,Verbose,"See what went wrong by Verbose->Failures:"},
		ValidPlotTableQ[RandomInteger[{0,100000},{5,5}],TableHeadings->{Range[5],Range[6]},Verbose->Failures],
		False
	]

}

];
