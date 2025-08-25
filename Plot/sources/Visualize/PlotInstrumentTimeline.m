(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotInstrumentTimeline*)

DefineOptions[PlotInstrumentTimeline,
	Options :> {
		{
			OptionName -> Radius,
			Default -> 1 Week,
			Description -> "The window of time over which the instrument timeline is smoothed.",
			AllowNull -> False,
			Widget -> Widget[Type -> Quantity, Pattern :> GreaterP[0 Week], Units -> (Hour|Day|Week|Month)],
			Category -> "General"
		}
	}
];

(* Default overload plots the full timeline, but shows a pie chart of the last week *)
PlotInstrumentTimeline[
	myInstrument:ObjectP[{Model[Instrument],Object[Instrument]}],
	myOps:OptionsPattern[]
]:=PlotInstrumentTimeline[myInstrument, Week, myOps];

(* Overload that allows the user to specify the time span for the pie chart *)
PlotInstrumentTimeline[
	myInstrument:ObjectP[{Model[Instrument],Object[Instrument]}],
	timeSpan:TimeP,
	myOps:OptionsPattern[]
]:=Module[
	{
		safeOps,radius,parsedLog,allDates,allPoints,sparseTimes,
		myUtilization,myTotals,myUndergoingMaintenance,myRetired,myRunning,myAvailable,myMaintenancePercent,
		utilizationPoints,maintenancePoints,smothedUtilizationPoints,smoothedMaintenancePoints,plotLabel,
		lastDate,lastTwoWeeks,lastDates,lastAvailable,lastRunning,lastMaintenance,secondsPerStep,weights,weightedAverageAvailable,weightedAverageRunning,weightedAverageMaintenance,
		rawPoints,percents,plotPoints,pieData,now,paddedUtilizationPoints,paddedMaintenancePoints,requestedTimes,frameTicks,absoluteTimeStart,shortenedCoordinates
	},

	(* turn off the precision loss message, it doesn't matter *)
	Off[General::munfl];

	safeOps = SafeOptions[PlotInstrumentTimeline, ToList[myOps]];

	(* recursively parse though the logs of all instruments of a given model *)
	parsedLog=processInstrumentModelLogs[myInstrument];

	(* Pull out all the dates points *)
	allDates=First[parsedLog];

	(* Pull out all the utilization data *)
	myUtilization=Last[parsedLog][[All,1]];

	(* Pull out all the maintenance data *)
	myMaintenancePercent=-1*(Last[parsedLog][[All,2]]);

	(* Pull out the points we need for the pie chart *)
	myAvailable=Last[parsedLog][[All,3]];
	myRunning=Last[parsedLog][[All,4]];
	myUndergoingMaintenance=Last[parsedLog][[All,5]];

	(* stitch together the points and there date stamps *)
	utilizationPoints=Transpose[{allDates,myUtilization}];
	maintenancePoints=Transpose[{allDates,myMaintenancePercent}];

	(* Pad all the points for plotting such that the last data point is carrened out to {Now, last data point} *)
	now=Now;
	paddedUtilizationPoints=Append[utilizationPoints,{now,Last[Last[utilizationPoints]]}];
	paddedMaintenancePoints=Append[maintenancePoints,{now,Last[Last[maintenancePoints]]}];

	(* get the radius option from the input *)
	radius = Lookup[safeOps, Radius];

	(* automatically resolve the times for which to evaluate the smoothing function *)
	(* TODO: decide if resolving to every 2 weeks is ok, or if this should be option controlled *)
	sparseTimes = Range[
		AbsoluteTime[Min[allDates]], AbsoluteTime[now-1 Month], Unitless[Convert[2 Week, Second]]
	];
	requestedTimes = Join[sparseTimes,
		Range[AbsoluteTime[now-1 Month], AbsoluteTime[now], Unitless[Convert[0.5 Week, Second]]]
	];

	(* Smooth the data points for more obvious trending *)
	(* If there are less than 10 total points, its hopeless to try and smooth the data, so instead just copy over the unsmoothed points *)
	smothedUtilizationPoints=If[Length[paddedUtilizationPoints]>10,
		(*smoothDateDataPoints[paddedUtilizationPoints],*)
		smoothTimeData[paddedUtilizationPoints, requestedTimes, radius],
		paddedUtilizationPoints
	];
	(* if smoothing failes as it does some times, give up on smoothing *)
	If[MatchQ[smothedUtilizationPoints,$Failed],
		smothedUtilizationPoints=paddedUtilizationPoints
	];
	smoothedMaintenancePoints=If[Length[paddedMaintenancePoints]>10,
		(*smoothDateDataPoints[paddedMaintenancePoints],*)
		smoothTimeData[paddedMaintenancePoints, requestedTimes, radius],
		paddedMaintenancePoints
	];
	(* if smoothing failes as it does some times, give up on smoothing *)
	If[MatchQ[smoothedMaintenancePoints,$Failed],smoothedMaintenancePoints=paddedMaintenancePoints];

	(* download the status log for use in the pie chart this time *)
	pieData=If[MatchQ[myInstrument,ObjectP[Model[Instrument]]],
		Download[myInstrument,{Objects[Object],Objects[Status],Objects[StatusLog]}],
		List/@Download[myInstrument,{Object,Status,StatusLog}]
	];

	(* Calculate the availability for the last week *)
	rawPoints=calculateAvailability[pieData,timeSpan];

	(* Generate the percent Labels for the pie chart*)
	percents=Round[(#/Total[rawPoints])100Percent]&/@rawPoints;
	plotPoints=MapThread[Labeled[#1,#2,"VerticalCallout"]&,{rawPoints,percents}];

	(* Plot information for labeling the chart by name and ModelID for the instrument model *)
	(* If it's an instrument object instead of model show the model name and instrument name *)
	plotLabel=If[MatchQ[myInstrument,ObjectP[Model[Instrument]]],
		Module[{modelID,modelName},
			{modelID,modelName}=Download[myInstrument,{Object,Name}];
			modelName<>"\n"<>ToString[modelID]
		],
		Module[{modelName,instrumentName,instrumentID},
			{modelName,instrumentName,instrumentID}=Download[myInstrument,{Model[Name],Name,Object}];
			modelName<>"\n"<>instrumentName<>"\n"<>ToString[instrumentID]
		]
	];

	frameTicks={Automatic,{
		{0,Style["Available",Cyan,Bold,18]},
		{5*Percent,"",0.0075},
		{10*Percent,"",0.0075},
		{15*Percent,"",0.0075},
		{20*Percent,"",0.0075},
		{25*Percent,Style["25 %",Gray,10]},
		{30*Percent,"",0.0075},
		{35*Percent,"",0.0075},
		{40*Percent,"",0.0075},
		{45*Percent,"",0.0075},
		{50*Percent,Style["50 %",Gray,10]},
		{55*Percent,"",0.0075},
		{60*Percent,"",0.0075},
		{65*Percent,"",0.0075},
		{70*Percent,"",0.0075},
		{75*Percent,Style["75 %",Gray,10]},
		{80*Percent,"",0.0075},
		{85*Percent,"",0.0075},
		{90*Percent,"",0.0075},
		{95*Percent,"",0.0075},
		{100*Percent,Style["100 %",Gray,10]},
		{110*Percent,Style["Running",Blue,Bold,18],0},
		{-5*Percent,"",0.0075},
		{-10*Percent,"",0.0075},
		{-15*Percent,"",0.0075},
		{-20*Percent,"",0.0075},
		{-25*Percent,Style["25 %",Gray,10]},
		{-30*Percent,"",0.0075},
		{-35*Percent,"",0.0075},
		{-40*Percent,"",0.0075},
		{-45*Percent,"",0.0075},
		{-50*Percent,Style["50 %",Gray,10]},
		{-55*Percent,"",0.0075},
		{-60*Percent,"",0.0075},
		{-65*Percent,"",0.0075},
		{-70*Percent,"",0.0075},
		{-75*Percent,Style["75 %",Gray,10]},
		{-80*Percent,"",0.0075},
		{-85*Percent,"",0.0075},
		{-90*Percent,"",0.0075},
		{-95*Percent,"",0.0075},
		{-100*Percent,Style["100 %",Gray,10]},
		{-110*Percent,Style["Maintenance",Red,Bold,18],0}}
	};

	absoluteTimeStart=AbsoluteTime[Now-timeSpan];

	shortenedCoordinates=Map[
		Function[points,
			Module[{startingPosition},
				startingPosition=FirstPosition[points,_?(AbsoluteTime[First[#]]>=absoluteTimeStart&),Null,1,Heads->False];
				If[MatchQ[startingPosition,{_Integer}],
					points[[First[startingPosition];;]],
					{}
				]
			]
		],
		{paddedUtilizationPoints,smothedUtilizationPoints,paddedMaintenancePoints,smoothedMaintenancePoints}
	];

	(* change plot interpolating order to 1 if length of a coords list is 2 *)
	interpolationOrderSetter = Function[{coords, index},
		Switch[{Length[coords], index[[1]]},
		(* length two should have a linear interpolation order = 1 *)
			{2, _?EvenQ}, 1,
		(* length of 1 should have 0 interpolation order *)
			{1, _?EvenQ}, 0,
		(* everything else should be quadratically interpolated *)
			_, 2
		]
	];
	plotInterpolationOrder = MapIndexed[interpolationOrderSetter, shortenedCoordinates];
	(* set data points to 0 interp order *)
	plotInterpolationOrder[[1]]=0;
	plotInterpolationOrder[[3]]=0;

	On[General::munfl];
	(* Generate the main plot *)
	Grid[
		{
			{Style[plotLabel,18,Bold,FontFamily->Arial,TextAlignment->Center]},
			{},
			{Style["Last "<>ToString[timeSpan],18,Italic,FontFamily->Arial]},
			{
				Grid[
					If[MatchQ[shortenedCoordinates,{{}..}],
						{},
						{{
							Zoomable[
								DateListPlot[
									shortenedCoordinates,
									Filling->{1->Axis,2->None,3->Axis,4->None},
									PlotStyle->{Lighter[Blue,0.5],Blue,Lighter[Red,0.5],Red},
									InterpolationOrder->plotInterpolationOrder,
									FrameTicks->frameTicks,
									PlotRange->{{Now-timeSpan,Now},{-112 Percent,112 Percent}},
									ImageSize->800
								]
							],
							PieChart[plotPoints,
								ChartLegends->{"Available","Running","Maintenance"},
								ChartStyle->{Cyan,Blue,Red},
								ImageSize->500,
								LabelStyle->Directive[Bold,18]
							]
						}}
					]
				]
			},
			{Style["Last 2 years",18,Italic,FontFamily->Arial]},
			{
				Zoomable[
					DateListPlot[{paddedUtilizationPoints,smothedUtilizationPoints,paddedMaintenancePoints,smoothedMaintenancePoints},
						Filling->{1->Axis,2->None,3->Axis,4->None},
						PlotStyle->{Lighter[Blue,0.5],Blue,Lighter[Red,0.5],Red},
						InterpolationOrder->{0, 2, 0, 2},
						FrameTicks->frameTicks,
						PlotRange->{{Now-(2Year),Now},{-112 Percent,112 Percent}},
						ImageSize->1500,
						AspectRatio->1/(2*GoldenRatio)
					]
				]
			}
		}
	]

];

$InstrumentPlotSmoothingMethod=Bilateral;

(* helper that shifts y data points to the "right" relative to the x-points *)
(* the shift is necessary to make a 0th order interpolating function that extends points to the right *)
(* currently, 0th order interp extends points to the left *)
shiftData[data_]:=Module[
	{xData,yData, shiftedY},
	(* separate x and y data *)
	{xData, yData}=Transpose[data];

	(* rotate the y data to the right and remove the first element as it's meaningless now *)
	shiftedY = Rest[RotateRight[yData]];

	(* transpose and return the shifted data *)
	Transpose[{Rest[xData],shiftedY}]
];

createInterpolator[times_, utilizations_]:=Module[
	{
		rawAbsoluteUnitlessTimes, minAbsoluteTime, rawUnitlessTimes, addTimes, unitlessTimes,
		function, sortedData, shiftedData, paddedData
	},

	(* make times unitless for performance reasons *)
	rawAbsoluteUnitlessTimes = AbsoluteTime/@times;

	(* find the minimum absolute time and subtract to prevent precision issues *)
	minAbsoluteTime = Min[rawAbsoluteUnitlessTimes];
	rawUnitlessTimes = rawAbsoluteUnitlessTimes - minAbsoluteTime;

	(* add very small time to each point to separate any data points with the exact same x-value *)
	addTimes = Table[i/(1*Length[rawUnitlessTimes]),{i,0,Length[rawUnitlessTimes]-1}];
	unitlessTimes = rawUnitlessTimes + addTimes;

	(* sort the data to make the interpolation faster *)
	sortedData = SortBy[Transpose[{unitlessTimes,utilizations}],First];

	(* It's super dumb, but a critical hack here is to shift the data by one index to the "right" to correctly use the 0th order interpolator *)
	shiftedData = shiftData[sortedData];

	(* pad data to prevent extrapolation artifacts *)
	paddedData = Join[{{1, 0 Percent}}, shiftedData, {{AbsoluteTime[Now+1Day], 0 Percent}}];

	(* create the interpolating function using an interpolation order of 0 *)
	function = Interpolation[Unitless[paddedData],InterpolationOrder->0];

	(* return an association of useful information *)
	<|
		InterpolatingFunction->function,
		DomainMin -> Min[unitlessTimes],
		DomainMax -> Max[unitlessTimes],
		Domain -> unitlessTimes,
		MinAbsoluteTime -> minAbsoluteTime
	|>
];

(* helper that finds a smoothed data point at a given time and radius *)
smoothDataPoint[interpolatorPacket_, time_, radius_]:=Module[
	{
		unitlessTime, unitlessRadius, windowRadius, windowMin, windowMax,
		pdf, integral, normalization, minAbsoluteTime
	},

	(* convert radius to seconds, and time to absolute time *)
	unitlessTime = AbsoluteTime[time] - Lookup[interpolatorPacket, MinAbsoluteTime];
	unitlessRadius = Unitless[Convert[radius,Second]];

	(* multiply radius by 5 to define the window region, which covers most of the gaussian dist *)
	(* equivalent to sampling the gaussian distribution out to 10 sigma, which covers well over 99.9% of the PDF *)
	windowRadius=3*unitlessRadius;

	(* find the window max and min, which is constrained by the domain of the interpolating function *)
	windowMin = Max[interpolatorPacket[DomainMin],unitlessTime-windowRadius];
	windowMax = Min[interpolatorPacket[DomainMax],unitlessTime+windowRadius];

	(* integrate the interpolated function with a gaussian kernel centered at time, with a width of radius *)
	pdf=PDF[NormalDistribution[unitlessTime,unitlessRadius]];
	integral = NIntegrate[
		interpolatorPacket[InterpolatingFunction][x]*pdf[x],
		{x,windowMin,windowMax},
		AccuracyGoal->4,
		Method -> {"LocalAdaptive", Method -> "TrapezoidalRule"}
	];

	(* integration needs to be normalized such that the Gaussian PDF integrates to 1 inside the window *)
	(* this technically changes the prob distribution at the edges of the data, but it's the best we can do with incomplete information *)
	normalization = NIntegrate[
		pdf[x],
		{x,windowMin,windowMax},
		AccuracyGoal->4,
		Method -> "TrapezoidalRule"
	];

	(* return the normalized integral *)
	Quantity[integral / normalization, Percent]
];

(* helper that smooths all time data into a function at the desired time points *)
smoothTimeData[timeData_, desiredTimes_, radius_]:=Module[
	{times, dataPoints, interp},

	(* unpack data *)
	{times, dataPoints}=Transpose[timeData];

	(* create interpolating data structure *)
	interp = createInterpolator[times, dataPoints];

	(* calculated smoothed values for each of the desired times *)
	dataPoints = Map[smoothDataPoint[interp,#,radius]&,desiredTimes];

	(* return the {time, data} pairs, ensuring that the times are date objects *)
	Transpose[{
		Map[DateObject, desiredTimes],
		dataPoints
	}]
];

smoothDateDataPoints[dateData_]:=Module[{sortedDateData,dates,absoluteDates,absoluteTimeSpan,points,pointDistance,smoothedAnalysis,smoothedPoints},

	(* Sort and slice out the date points from all the points *)
	sortedDateData=SortBy[dateData,First];
	dates=sortedDateData[[All,1]];
	absoluteDates=AbsoluteTime/@dates;
	points=sortedDateData[[All,2]];
	absoluteTimeSpan=Max[absoluteDates]-Min[absoluteDates];

	(* Need to figure out the mean distance between points in order to use the smoothing algorithm *)
	pointDistance=Mean[Rest[absoluteDates]-Most[absoluteDates]];

	(* Generate numeric data where the x cordinates are the absolute time (in seconds since Jan 1st 1990) so smoothing can progress with iregularly spaced data *)
	(* The radius is either enough such that there are 100 points in the span, or if that's too high resolution acording to Analyzing smoothing we set it larger such that there are at least 10 points in radius on average for each point *)
	smoothedAnalysis=Quiet@ECL`AnalyzeSmoothing[Transpose[{absoluteDates,points}],EqualSpacing->False,Method->$InstrumentPlotSmoothingMethod,Radius->(Max[absoluteTimeSpan/100,pointDistance*10])];
	If[MatchQ[smoothedAnalysis,$Failed],Return[$Failed]]; (* Sometimes smoothing refuses to procede if points are too sparse *)

	(* Strip off arbitary x cordinates *)
	smoothedPoints=Download[smoothedAnalysis,SmoothedDataPoints][[All,2]];

	(* Add the date values back into the x coordantes *)
	Transpose[{dates,smoothedPoints}]
];

processInstrumentModelLogs[myInstrument:ObjectP[{Model[Instrument],Object[Instrument]}]]:=Module[{allInstruments,allLogs,sortedLog,cleanedLogs,combinedLog,startingStates,startingCounts,allDates},

	(* download all the information from the model we can, if we have an object rather than a model pretend its the same as a model that only has that instrument in it *)
	{allInstruments,allLogs}=If[MatchQ[myInstrument,ObjectP[Model[Instrument]]],
		Download[myInstrument,{Objects[Object],Objects[StatusLog]}],
		List/@Download[myInstrument,{Object,StatusLog}]
	];

	(* Cleaning the log files by removing any entires that are missing information from the logs *)
	cleanedLogs=Cases[#,{_?DateObjectQ,InstrumentStatusP,ObjectP[]}]&/@allLogs;

	(* Stich the logs togeather in the form {{date,status change, instrument}..} *)
	combinedLog=Flatten[MapThread[Function[{instrument,log},{First[#],#[[2]],instrument}&/@log],{allInstruments,cleanedLogs}],1];
	sortedLog=SortBy[Prepend[Rest[#],TimeZoneConvert[First[#],$TimeZone]]&/@combinedLog,First];

	(* Establish the starting counts of all instruments at each state at 0 *)
	startingCounts=<|
		Available->0,
		Running->0,
		UndergoingMaintenance->0,
		Retired->0,
		Total->0,
		Utilization->0 Percent,
		MaintenancePercent->0 Percent
	|>;

	(* Establish the list of which instruments are in which status presently as all empty lists in the form instrument\[Rule]Status *)
	startingStates=<||>;

	(* Slice out all the date points *)
	allDates=sortedLog[[All,1]];

	(* call the imperative fast version *)
	{allDates,processInstrumentModelLogs[startingCounts,startingStates,sortedLog]}

];

processInstrumentModelLogs[statusCounts_,instrumentStates_,combinedLog:{{_?DateObjectQ,InstrumentStatusP,ObjectP[Object[Instrument]]}..}]:=Module[
	{myStatusCounts,myInstrumentStates,utilizationPoints},

	(* assign the lookup tables to a symbol because associations want that sort of thign for us to insert new keys *)
	myStatusCounts=statusCounts;
	myInstrumentStates=instrumentStates;

	Table[Module[{nextDate,nextStatus,nextInstrument,previousStatus},

		(* Slice off each entry from the combined log *)
		{nextDate,nextStatus,nextInstrument}=x;

		(* using the next instrument, figure out what its previous status was (if known) *)
		previousStatus=Lookup[myInstrumentStates,nextInstrument];

		(* Update the status of the instrument in the lookup table of instrument states *)
		myInstrumentStates[nextInstrument]=nextStatus;

		(* Update the counts of everything to decrease from the previous states and add to the new state *)
		(* if there is no previous state then don't decrement the count (since there's nothing to subtract *)
		If[!MatchQ[previousStatus,_Missing],myStatusCounts[previousStatus]=(myStatusCounts[previousStatus]-1)];
		myStatusCounts[nextStatus]=(myStatusCounts[nextStatus]+1);

		(* Update the Total counts (everything not retired) and precent utilization (everything not retired thats either in use or in maintenance *)
		(* Be sure not to crash when calculating the percentages if there just are no workig instruments (so total is 0) by dividing by0 0 *)
		myStatusCounts[Total]=myStatusCounts[Available]+myStatusCounts[Running]+myStatusCounts[UndergoingMaintenance];
		myStatusCounts[Utilization]=If[myStatusCounts[Total]==0,0,Round[N[((myStatusCounts[Running])/myStatusCounts[Total])*100 Percent]]];
		myStatusCounts[MaintenancePercent]=If[myStatusCounts[Total]==0,0,Round[N[((myStatusCounts[UndergoingMaintenance])/myStatusCounts[Total])*100 Percent]]];

		{myStatusCounts[Utilization],myStatusCounts[MaintenancePercent],myStatusCounts[Available],myStatusCounts[Running],myStatusCounts[UndergoingMaintenance]}

	],{x,combinedLog}]

];

calculateAvailability[{objs:{ObjectP[Object[Instrument]]..},presentStatuses_,statusLogs_},timeSpan_]:=Module[{
	startingCounts,startingStates,allDates,combinedLog,cleanedLog,sortedLog,parsedLog,myAvailable,myRunning,myUndergoingMaintenance,parsedDateLog,
	mostRecent,now,endPoint,cutLog,cutPosition,previousPoint,startPoint,paddedLog,paddedDates,paddedAvailable,paddedRunning,paddedMaintenance,endPaddedLog},

	(* Stich the logs togeather in the form {{date,status change, instrument}..} *)
	combinedLog=Flatten[MapThread[Function[{instrument,log},{First[#],#[[2]],instrument}&/@log],{objs[Object],statusLogs}],1];

	(* patch up any missing points *)
	cleanedLog=Cases[combinedLog,{_?DateObjectQ,InstrumentStatusP,ObjectP[Object[Instrument]]}];

	(* Sort the log in time order -- which unfortunatly MM makes you convert to a common timezone or it wont properly sort *)
	sortedLog=SortBy[Prepend[Rest[#],TimeZoneConvert[First[#],$TimeZone]]&/@cleanedLog,First];

	(* Establish the starting counts of all instruments at each state at 0 *)
	startingCounts=<|
		Available->0,
		Running->0,
		UndergoingMaintenance->0,
		Retired->0,
		Total->0,
		Utilization->0 Percent,
		MaintenancePercent->0 Percent
	|>;

	(* Establish the list of which instruments are in which status presently as all empty lists in the form instrument\[Rule]Status *)
	startingStates=<||>;

	(* Slice out all the date points *)
	allDates=sortedLog[[All,1]];

	(* call the imperative fast version *)
	parsedLog=processInstrumentModelLogs[startingCounts,startingStates,sortedLog];

	(* Put the dates back on with the parsed log to get ready for trimming it to size and padding it with a start and end point matching the start and end point of the requested span *)
	parsedDateLog=Transpose[{allDates,parsedLog}];

	(* Freeze a starting moment *)
	now=Now;

	(* build a padded endpoint that caries foward from the last point in the log to the present moment *)
	endPoint={now,Last[Last[parsedDateLog]]};

	(* Staple the new end point to the log *)
	endPaddedLog=Append[parsedDateLog,endPoint];

	(* Slice the log down to size based on the time selection *)
	cutLog=Select[endPaddedLog,First[#]>(now-timeSpan)&];

	(* Find at what point it made the cut based on the timespan so we can take the point right before that.  If that point is the first point, leave us at the last point we have data avaiable for *)
	cutPosition=Which[
		Length[cutLog]==Length[endPaddedLog],1, (* if nothing has been cutoff return the entire datalist *)
		Length[cutLog]>1,First[FirstPosition[endPaddedLog,First[cutLog]]]-1, (*if it has been cut at a given position, return one before that position *)
		Length[cutLog]<=1,Length[endPaddedLog] (* if all the points get cutoff then return the last position *)
	];

	(* grab the point before the cut stated *)
	previousPoint=Part[endPaddedLog,cutPosition];

	(* build a padded point matching the date at the start of the span and cloning the numbers at the previous *)
	startPoint={now-timeSpan,Last[previousPoint]};

	(* Staple on the artifical start ane end point to the clipped log so it starts and ends during the entire requested time span*)
	paddedLog=Prepend[cutLog,startPoint];

	(* Splice out indivual traces for the dates, availbility numbers, running numbers, and maintenance numbers *)
	paddedDates=paddedLog[[All,1]];
	paddedAvailable=(paddedLog[[All,2]])[[All,3]];
	paddedRunning=(paddedLog[[All,2]])[[All,4]];
	paddedMaintenance=(paddedLog[[All,2]])[[All,5]];

	If[Length[paddedDates]>1,
		Module[{secondsPerStep,weights,weightedAverageAvailable,weightedAverageRunning,weightedAverageMaintenance},

			(* get the number of seconds between each time point *)
			secondsPerStep=Unitless[Rest[paddedDates]-Most[paddedDates],Second];

			(* Calculate the weight of each item by getting the fraction of the total time spent dwelling in each state *)
			weights=(#/Total[secondsPerStep]&)/@secondsPerStep;

			(* Using these weights take the weighted average of all the last points *)
			weightedAverageAvailable=Mean[WeightedData[Most[paddedAvailable],weights]];
			weightedAverageRunning=Mean[WeightedData[Most[paddedRunning],weights]];
			weightedAverageMaintenance=Mean[WeightedData[Most[paddedMaintenance],weights]];

			(* Generate the precent Labels for the pie chart*)
			{weightedAverageAvailable,weightedAverageRunning,weightedAverageMaintenance}

		],
		{Count[presentStatuses,Available],Count[presentStatuses,Running],Count[presentStatuses,UndergoingMaintenance]}
	]
];
