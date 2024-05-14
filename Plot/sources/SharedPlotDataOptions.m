(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*Private function references*)


split={};


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Shared By All Plots*)


sharedOptions:=Join[
	List@ModifyOptions[PrimaryDataOption,Category->"Data Specifications",ResolutionDescription->"If set to Automatic, an appropriate field will be inferred from the input data object."],
	List@ModifyOptions[MapOption],
	List@ModifyOptions[ZoomableOption],
	ModifyOptions[ListPlotOptions,{FrameLabel},ResolutionDescription->"If Automatic, the x and y axes will be labeled with the names and units of the x and y values being plotted."],
	ModifyOptions[ListPlotOptions,{PlotLabel},Default->Automatic,ResolutionDescription->"If set to Automatic, the object ID will be used."],
	List@ModifyOptions[OptionFunctionsOption],
	List@ModifyOptions[OutputOption]
];


(* ::Subsection:: *)
(*Shared by 'Real' Plots *)


realOptions:=Join[
	ModifyOptions[ListPlotOptions,{PlotTheme},Default->Null,AllowNull->True],
	List@ModifyOptions[LegendOption],
	List@ModifyOptions[LegendPlacementOption],
	List@ModifyOptions[BoxesOption],
	List@ModifyOptions[IncludeReplicatesOption],
	ModifyOptions[ListPlotOptions,{TargetUnits}],
	List@ModifyOptions[UnitsOption]
];


(* ::Subsection:: *)
(*Shared by List Line Plots*)


lineOptions:=Join[
	List@ModifyOptions[SecondaryDataOption],
	List@ModifyOptions[DisplayOption,
		Widget->Alternatives[
				Adder[Widget[Type->Enumeration, Pattern:>Alternatives[Peaks,Fractions,Ladder]]],
				Widget[Type->Expression,Pattern:>{}|{(Peaks|Fractions|Ladder)..},Size->Line]
			]
	]
];


(* ::Subsection:: *)
(*Shared by Chart Plots*)


chartOptions:={};


(* ::Subsection:: *)
(*Shared by Image Plots*)


imageOptions:={};


(* ::Subsection:: *)
(*Constructing Shared Options*)


(* ::Subsubsection:: *)
(*generateSharedOptions*)


(* generateSharedOptions Usage *)
(*
	BasicDefinitions->
		{
			{"generateSharedOptions[typ,dataField]","opts","generates plot usage options for a type by fetching the appropriate shared options and by appending options which allow direct specification of plot-able fields."}
		},
	MoreInformation->{
		"By default, only the dataField will be shown on the plot. The user should specify defaults for SecondaryData, and/or Display when these should be included on the plots by default.",
		"Options to override values in the object are automatically generated based on the result of evaluating the 'Plot-able Fields' functions for the given type.",
		"If the incorrect option values are being generated, you can overwrite the 'Plot-able Fields' functions for a specific type.",
		"Field options will not only change the default, but also the allowed patterns and description.",
		"When generated options are changed through DefaultUpdates, CategoryUpdates, AllowNullUpdates, or WidgetUpdates, only the specified options are changed."
	},
	Input:>
		{
			{"'typ'",TypeP[],"The type of the object being plotted."},
			{"'dataField'",FieldP[Output->Short]|{FieldP[Output->Short]..},"The primary data field to plot."}
		},
	Output:>
		{
			{"'opts'",_List,"A graphical representation of the spectra."}
		}
*)

Authors[generateSharedOptions]:={"hayley","sebastian.bernasek"};

DefineOptions[generateSharedOptions,
	Options:>
	{
		{PlotTypes->{},{(LinePlot|ChartPlot|ImagePlot)...},"The plot options you wish to inherit."},
		{PrimaryData->{},{_Symbol...},"The primary fields you wish to plot."},
		{SecondaryData->{},Automatic|{_Symbol...},"The secondary fields you wish to plot."},
		{Display->{},{(Peaks|Fractions|Ladder)...},"The epilog fields you wish to include on the plot."},
		{DefaultUpdates->{},{_Rule...},"A list of OptionName->DefaultValue rules used to override the generated defaults."},
		{CategoryUpdates->{},{(_Symbol->_String|_Symbol)...},"A list of OptionName->Category rules used to override the generated option categories."},
		{AllowNullUpdates->{},{(_Symbol->BooleanP)...},"A list of OptionName->BooleanP rules used to override the generated options AllowNull specifications."},
		{WidgetUpdates->{},{(_Symbol->_?ValidWidgetQ)...},"A list of OptionName->_?ValidWidgetQ rules used to override the generated widgets."}
	}
];


generateSharedOptions[typ:TypeP[],dataField:(Automatic|{(FieldP[Output->Short])..}|FieldP[Output->Short]),inputOptions:OptionsPattern[generateSharedOptions]]:=Module[
	{ops,rawInheritedOptions,inheritedOptions,traceFieldAlternatives,secondaryDataPattern,primaryDataOption,secondaryDataOption,displayOption,dataOptions,updatedOptions,valueOptions,unsortedOptions},

	(* Safe Options *)
	ops=Association[SafeOptions[generateSharedOptions, ToList[inputOptions]]];

	(* Get options based on specified plot types *)
	rawInheritedOptions=Join[sharedOptions,Flatten[(ops[PlotTypes]/.{LinePlot->lineOptions,ChartPlot->chartOptions,ImagePlot->imageOptions}),1]];

	(* Chart and line plots will have 'real plot' options *)
	inheritedOptions = If[MemberQ[ops[PlotTypes],(LinePlot|ChartPlot)],
		Join[realOptions,rawInheritedOptions],
		rawInheritedOptions
	];

	traceFieldAlternatives=Alternatives@@linePlotTypeUnits[typ][[All,1]];

	secondaryDataPattern=If[
		MatchQ[ops[SecondaryData],{traceFieldAlternatives...}],
		{traceFieldAlternatives...},
		ops[SecondaryData]|{traceFieldAlternatives...}
	];

	(* Define PrimaryData option specific to the current input data *)
	primaryDataOption=ModifyOptions[PrimaryDataOption,
		Default->dataField,
		Widget->If[

			(* If plottable fields were found, use them as selectable options *)
			Length@traceFieldAlternatives>0,
			Alternatives[
				"Enter field(s):"->With[{pattern=Automatic|{}|traceFieldAlternatives},Widget[Type->Enumeration,Pattern:>pattern]],
				"Select field(s):"->With[{pattern=traceFieldAlternatives},Adder[Widget[Type->Enumeration,Pattern:>pattern]]]
			],

			(* Otherwise, limit selection to Automatic or the data field *)
			With[{pattern=Automatic|dataField},Widget[Type->Enumeration,Pattern:>pattern]]
		]
	];

	(* Define SecondaryData option specific to the current input data *)
	secondaryDataOption=ModifyOptions[SecondaryDataOption,
		Default->ops[SecondaryData],
		Widget->If[

			(* If plottable fields were found, use them as selectable options *)
			Length@traceFieldAlternatives>0,
			Alternatives[
				"Enter field(s):"->With[{pattern={}|secondaryDataPattern},Widget[Type->Expression,Pattern:>pattern,Size->Line]],
				"Select field(s):"->With[{pattern=traceFieldAlternatives},Adder[Widget[Type->Enumeration,Pattern:>pattern]]]
			],

			(* Otherwise, limit selection to Automatic or the data field *)
			With[{pattern=Alternatives[ops[SecondaryData]]},Widget[Type->Enumeration,Pattern:>pattern]]
		]
	];

	(* Define Display option specific to the current input data *)
	displayOption=ModifyOptions[DisplayOption,Default->ops[Display]];

	(* Update PrimaryData, SecondaryData, and Display options in accordance with the input data *)
	updatedOptions=Replace[
		inheritedOptions,
		{
			Rule[g:{_Rule..}/;MemberQ[g,OptionName->PrimaryData],primaryDataOption],
			Rule[g:{_Rule..}/;MemberQ[g,OptionName->SecondaryData],secondaryDataOption],
			Rule[g:{_Rule..}/;MemberQ[g,OptionName->Display],displayOption]
		},
		Infinity
	];

	(* Generate options to specify values *)
	valueOptions=If[MemberQ[ops[PlotTypes],LinePlot],
		generateValueOptions[typ,ops],
		{}
	];

	(* Override generated options in accordance with specified update rules *)
	unsortedOptions=overrideOptionDefinition[#,ops[DefaultUpdates],ops[CategoryUpdates],ops[AllowNullUpdates],ops[WidgetUpdates]]&/@Join[updatedOptions,valueOptions];

	(* Sort options into preferred order *)
	Replace[
		Options :> Evaluate[SortBy[unsortedOptions,FirstPosition[optionOrdering,Replace[OptionName,#],{Infinity}]&]],
		{Hold[a_]:>a},
		{3}
	]
];


(* Define helper function that takes a generated option definition and overrides it with any requested Default, Category, AllowNull, or Widget updates *)
overrideOptionDefinition[optionDefinition:{_Rule..},defaultUpdates:{_Rule...},categoryUpdates:{_Rule...},allowNullUpdates:{_Rule...},widgetUpdates:{_Rule...}]:=Module[
	{optionName},

	(* Extract the option name *)
	optionName=OptionName/.optionDefinition;

	(* If the option appears in each set of update rules, update the appropriate value *)
	ReplaceRule[optionDefinition,
		{
			If[MemberQ[Keys@defaultUpdates,optionName],Default->optionName/.defaultUpdates],
			If[MemberQ[Keys@categoryUpdates,optionName],Category->optionName/.categoryUpdates],
			If[MemberQ[Keys@allowNullUpdates,optionName],AllowNull->optionName/.allowNullUpdates],
			If[MemberQ[Keys@widgetUpdates,optionName],Widget->optionName/.widgetUpdates]
		}
	]
];


(* Define helper function that takes an input data object type and generates options for adding raw data *)
generateValueOptions[typ:TypeP[],ops:_Association]:=Module[{coordinateValueOptions,imageOptions,fractionOptions,peakOptions},

	(* Define coordinate value options *)
	coordinateValueOptions=createLineOptions[linePlotTypeUnits[typ][[All,1]],Hold[NullP|(ListableP[CoordinatesP,2]|ListableP[QuantityArrayP[],2])]];

	(* Define image options *)
	imageOptions=createOtherOptions[imageFields[typ],Hold[NullP|ListableP[_Image,2]]];

	(* Define fraction options *)
	fractionOptions=If[!MatchQ[fractionsFields[typ],{}],
		createOtherOptions[{Fractions},Hold[NullP|ListableP[FractionP|NullP,2]]],
		{}
	];

	(* Define peaks options *)
	peakOptions=If[!MatchQ[peaksFields[typ],{}],
		createOtherOptions[{Peaks},Hold[NullP|ListableP[ObjectP[Object[Analysis,Peaks]]|NullP,2]]],
		{}
	];

	Join[coordinateValueOptions,peakOptions,fractionOptions,imageOptions]

];


ReverseCamelCase[camelCaseSymbol:_Symbol]:=ReverseCamelCase[ToString[camelCaseSymbol]];
ReverseCamelCase[camelCaseString:_String]:=StringTrim[StringReplace[camelCaseString,up_?UpperCaseQ:>" "~~up]];

(* Helper function that generates secondary data options *)
createLineOptions[names:_List,pattern_]:=Map[
	{
		OptionName->#,
		Description->"The "<>ToLowerCase[ReverseCamelCase[#]]<> " trace to display on the plot.",
		Default->Null,
		AllowNull->True,
		Widget->With[{p=ReleaseHold@pattern},Widget[Type->Expression,Pattern:>p,Size->Paragraph]],
		Category->"Hidden"
	}&,
	names
];

(* Helper function that generates other options *)
createOtherOptions[names:_List,pattern_]:=Map[
	{
		OptionName->#,
		Description->"The "<>ToLowerCase[ReverseCamelCase[#]]<> " to display on the plot.",
		Default->Null,
		AllowNull->True,
		Widget->With[{p=ReleaseHold@pattern},Widget[Type->Expression,Pattern:>p,Size->Paragraph]],
		Category->"Hidden"
	}&,
	names
];


(* Define option order *)
optionOrdering:={
	PrimaryData,SecondaryData,Display,IncludeReplicates,TargetUnits,Units,
	PlotTheme,Map,Zoomable,OptionFunctions,
	Legend,LegendPlacement,Boxes,FrameLabel,PlotLabel,Output
};


(* Define helper functions for joining a pair or list of option sets *)
optionsJoin[RuleDelayed[Options, {rhs1___}],RuleDelayed[Options, {rhs2___}]]:=RuleDelayed[Options, {rhs1, rhs2}];
optionsJoin[optionSets_:{RuleDelayed[Options,{_Rule...}]..}]:=Fold[optionsJoin,Options:>{},optionSets];


(* ::Section:: *)
(*End*)
