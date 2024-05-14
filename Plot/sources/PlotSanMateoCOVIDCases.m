(* ::Subsection:: *)
(* PlotSanMateoCOVIDCases[] *)


Authors[PlotSanMateoCOVIDCases]:={"kevin.hou","hayley"};

DefineOptions[PlotSanMateoCOVIDCases,
	Options:>{
		{Display->WeeklyAverage,ListableP[WeeklyAverage|Thresholds|DailyCases|All],"Indicates which data to overlay on the plot."}
	},
	SharedOptions:>{
		EmeraldDateListPlot
	}
];

PlotSanMateoCOVIDCases::OutOfRange="Please note that the data set used `1` on `2` so your entire window cannot be shown. All available data within the window is presented.";

PlotSanMateoCOVIDCases[timeAgo:TimeP, ops:OptionsPattern[PlotSanMateoCOVIDCases]]:=PlotSanMateoCOVIDCases[Now-timeAgo,Now,ops];

PlotSanMateoCOVIDCases[ops:OptionsPattern[PlotSanMateoCOVIDCases]]:=PlotSanMateoCOVIDCases[Now-3Month,Now,ops];

PlotSanMateoCOVIDCases[startTime_DateObject, endTime_DateObject, ops:OptionsPattern[PlotSanMateoCOVIDCases]]:=Module[
	{safeOps,data2021,data2022,data2023,nytData,sanMateoData,allDates,allCases,allAvgCases,allDateObjs,startPosition,endPosition,
		dates,cases,dateObjs,avgCases,avgCaseCoordinates,dailyCaseCoordinates,barWidth,display,showAll,showAverage,
		showThresholds,showDailyCases,dailyCaseBars,thresholds,yMax,labelEnd,legend,defaultOptions},

	safeOps = SafeOptions[PlotSanMateoCOVIDCases,ToList[ops]];

	data2021 = URLExecute["https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-2021.csv"];
	data2022 = URLExecute["https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-2022.csv"];
	data2023 = URLExecute["https://raw.githubusercontent.com/nytimes/covid-19-data/master/rolling-averages/us-counties-2023.csv"];
	nytData = Join[data2021, Rest[data2022], Rest[data2023]];

	(*Extract data for San Mateo county California*)
	sanMateoData = Select[nytData, (Part[#, 4] == "California" && Part[#, 3] == "San Mateo") &];

	(*Pull out dates, cases, and 7-day avg. cases columns*)
	{allDates,allCases,allAvgCases} = Transpose@Part[sanMateoData, All, {1, 5, 6}];

	(* Convert dates to date objects *)
	allDateObjs=Map[
		DateObject[ToExpression[StringSplit[#,"-"]]]&,
		allDates
	];

	startPosition=First@FirstPosition[allDateObjs,GreaterP[startTime],{1},{1}];
	endPosition=First@FirstPosition[allDateObjs,GreaterP[endTime],{-1},{1}];

	(* Extract the data within our provided plot range *)
	dateObjs=allDateObjs[[startPosition;;endPosition]];
	cases=allCases[[startPosition;;endPosition]];
	avgCases=allAvgCases[[startPosition;;endPosition]];

	If[dateObjs[[1]]-startTime > 2 Day,
		Message[PlotSanMateoCOVIDCases::OutOfRange,"starts",DateString[allDateObjs[[1]]]]
	];

	If[endTime-dateObjs[[-1]] > 2 Day,
		Message[PlotSanMateoCOVIDCases::OutOfRange,"ends",DateString[allDateObjs[[-1]]]]
	];

	avgCaseCoordinates=Transpose[{dateObjs,avgCases}];
	dailyCaseCoordinates=Transpose[{dateObjs,cases}];

	(* Set the bar width dynamically *)
	barWidth=0.95*N[Unitless[dailyCaseCoordinates[[-1,1]]-dailyCaseCoordinates[[1,1]],Second]/Length[dailyCaseCoordinates]];

	(* Extend the plot slightly *)
	avgCaseCoordinates[[1,1]]=avgCaseCoordinates[[1,1]]-(barWidth*Second);
	avgCaseCoordinates[[-1,1]]=avgCaseCoordinates[[-1,1]]+(barWidth*Second);

	display=ToList[Lookup[safeOps,Display]];
	showAll=MemberQ[display,All];
	showAverage=showAll||MemberQ[display,WeeklyAverage];
	showThresholds=showAll||MemberQ[display,Thresholds];
	showDailyCases=showAll||MemberQ[display,DailyCases];

	(* Epilog graphics *)
	dailyCaseBars=MapThread[
		Tooltip[
			Style[
				Rectangle[
					{AbsoluteTime[First[#1]]-barWidth/2,-300},
					{AbsoluteTime[First[#1]]+barWidth/2,Last[#1]}
				],
				Lighter@Gray
			],
			Style[
				StringJoin[
					DateString[First[#1],{"MonthNameShort"," ","Day",", ","Year"}],
					"\nNew cases: "<>ToString[Last[#1]],
					"\n7-day avg: "<>ToString[Round[Last[#2]]]
				],
				Black,
				14
			]
		]&,
		{dailyCaseCoordinates,avgCaseCoordinates}
	];

	(* Threshold *)
	thresholds={{dateObjs[[1]]-barWidth*Second,#},{dateObjs[[-1]]+2*barWidth*Second,#}}&/@{77,46,15};

	yMax=If[showDailyCases,
		Max[dailyCaseCoordinates[[All,-1]]],
		Max[avgCaseCoordinates[[All,-1]]]
	];

	(* If we're showing general case info don't add, otherwise include 7-day average*)
	labelEnd=If[showAll||showDailyCases||showThresholds,
		"",
		"\n(7-Day Average)"
	];

	(* Make a legend only if we have enough stuff to warrant one *)
	legend={
		If[showAll||(showDailyCases&&showThresholds),"Daily New Cases",Nothing],
		If[showAll||(showAverage&&showThresholds),"7 Day Average",Nothing],
		If[showThresholds,"Widespread (77+)",Nothing],
		If[showThresholds,"Substantial (46-77)",Nothing],
		If[showThresholds,"Moderate (15-45)",Nothing]
	}/.{}->None;

	defaultOptions = {
		FrameLabel -> {"Date","Covid Cases Per Day"<>labelEnd},
		LabelStyle -> "Subsubsection",
		PlotStyle->{
			If[showDailyCases,{Lighter@Gray,Thickness[0.2]},Nothing],
			Which[
				showAll||(showAverage&&showThresholds),Black,
				showAverage,Red,
				True,Nothing
			],
			If[showThresholds,{Purple,Dashed},Nothing],
			If[showThresholds,{Red,Dashed},Nothing],
			If[showThresholds,{Darker@Orange,Dashed},Nothing]
		},
		Legend->legend,
		LegendPlacement->Right,
		PlotRange->{
			{AbsoluteTime[dailyCaseCoordinates[[1,1]]]-barWidth/2,AbsoluteTime[dailyCaseCoordinates[[-1,1]]]+barWidth/2},
			{0,yMax}
		},
		FrameLabel->{{"New Cases",None},{None,None}},
		Prolog->If[showDailyCases,
			dailyCaseBars,
			{}
		],
		PlotRange -> Full,
		ImageSize -> 800,
		Frame -> {True, True, False,False},
		Filling -> Bottom,
		Zoomable->True
	};

	(* Make the plot *)
	EmeraldDateListPlot[
		{
			If[showDailyCases,{{dateObjs[[8]],-1000}},Nothing],
			If[showAverage,avgCaseCoordinates,Nothing],
			If[showThresholds,Sequence@@thresholds,Nothing]
		},
		ReplaceRule[defaultOptions,DeleteCases[ToList[ops],Display->_]]
	]
];