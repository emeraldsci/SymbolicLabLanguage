(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometryKinetics*)


DefineOptions[PlotNephelometryKinetics,
	Options :> {

		(* Primary data *)
		{
			OptionName->PlotType,
			Default->Automatic,
			AllowNull->False,
			Description->"Indicates how the data should be presented.",
			Widget->Widget[Type->Enumeration,Pattern:>Automatic|ListLinePlot|ContourPlot|DensityPlot|ListPlot3D],
			Category->"Primary Data"
		},
		{
			OptionName->DataType,
			Description->"The type of data to display on the plot. Temperature will plot temperature v. time. TurbidityTrajectory will plot turbidity v. time. UnblankedTurbidityTrajectory will plot unblanked turbidity v. time. DilutedConcentrationTurbidity will plot turbidity v. input concentration if dilutions were specified in the experiment. DilutedConcentrationUnblankedTurbidity will plot unblanked turbidity v. input concentration if dilutions were specified in the experiment. DilutedConcentrationTurbidityTrajectory will plot turbidity v. time v. input concentration in a 3D plot if dilutions were specified in the experiment. DilutedConcentrationUnblankedTurbidityTrajectory will plot unblanked turbidity v. time v. input concentration in a 3D plot if dilutions were specified in the experiment.",
			Default->TurbidityTrajectory,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Temperature|TurbidityTrajectory|UnblankedTurbidityTrajectory|DilutedConcentrationTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory|DilutedConcentrationTurbidity|DilutedConcentrationUnblankedTurbidity],
			Category->"Raw Data"
		}

	},
	SharedOptions :> {
		EmeraldListLinePlot
	}
];


(* ::Subsection::Closed:: *)
(*Messages*)


Warning::Data2D="Since the data is two dimensional, PlotType will be set to ListLinePlot.";
Error::PlotNephelometryKineticsDataTypeNotAvailable = "There is no non-null data for `1` for the data objects `2`, so the DataType `3` cannot be specified. Please choose a different data type.";
Error::PlotNephelometryKineticsObjectNotFound="Specified object `1` cannot be found in the database. Please verify the objects' IDs or names.";
Error::PlotNephelometryKineticsNoAssociatedObject="Specified input `1` is not associated with a `2` object. Please verify the input object `1`, or associate it with a `2` object.";



(* Raw Definition *)
PlotNephelometryKinetics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotNephelometryKinetics]]:=rawToPacket[
	primaryData,
	Object[Data,NephelometryKinetics],
	PlotNephelometryKinetics,
	SafeOptions[PlotNephelometryKinetics, ToList[inputOptions]]
];


PlotNephelometryKinetics[input:ListableP[ObjectP[Object[Data,NephelometryKinetics]]],inputOptions:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,outputOptions,safeOptions,safeOptionTests,objectExistsQ,dataObjects,dataType,plotType,
		objects, turbidities, unblankedTurbidities, inputConcentration, inputDilutedConcentrations, tempData, dilutions,dilutionsQ,
		xData,yData,zData,xAxisEndpoints,yAxisEndpoints,zAxisEndpoints,plotLabels,blank,
		setDefaultOption,plotTypes3D,xLabel,yLabel,zlabel,plotOptions,plot,mostlyResolvedOps,resolvedPlotType,
		resolvedOps
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[inputOptions];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[OptionValue[Output]];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Determine if we should output the resolved options *)
	outputOptions = MemberQ[output, Options];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[PlotNephelometryKinetics,listedOptions,Output->{Result,Test},AutoCorrect->False],
		{SafeOptions[PlotNephelometryKinetics,listedOptions,AutoCorrect->False],Null}
	];

	If[MatchQ[safeOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* ----- Check if the inputs are valid ----- *)

	(* Check if the input exists in the database *)
	objectExistsQ=DatabaseMemberQ[input];

	(* If object doesn't exist, return $Failed with an error *)
	If[
		!objectExistsQ,
		Module[{},
			Message[Error::PlotNephelometryKineticsObjectNotFound,input];
			Return[$Failed]
		]
	];

	(* ----- Check if the objects have an associated protocol object ----- *)

	(* Check the associated object *)
	(* data without associated protocol *)
	If[MatchQ[input,ObjectP[Object[Data,NephelometryKinetics]]]&&!MatchQ[Download[input,Protocol],ObjectP[Object[Protocol,NephelometryKinetics]]],
		Module[{},
			Message[Error::PlotNephelometryKineticsNoAssociatedObject,input,"protocol"];
			Return[$Failed]
		]
	];

	dataObjects = ToList[input];

	dataType = Lookup[safeOptions,DataType];

	plotType = Lookup[safeOptions,PlotType];

	plotTypes3D = ContourPlot|DensityPlot|ListPlot3D;

	(* Download data *)
	{
		objects,
		turbidities,
		unblankedTurbidities,
		inputConcentration,
		inputDilutedConcentrations,
		tempData,
		dilutions,
		blank
	} =Transpose@Quiet[
		Download[dataObjects,
			{
				Object,
				TurbidityTrajectories,
				UnblankedTurbidityTrajectories,
				InputConcentration,
				InputDilutedConcentrations,
				Temperatures,
				Dilutions,
				Protocol[Blanks]
			}
		],
		{Download::MissingField,Download::FieldDoesntExist}
	];



	(* determine if dilutions were performed in the experiment. *)
	dilutionsQ = If[MatchQ[dilutions, {{}...}],False,True];

	(* if dilutions were not done, dilution data types cannot be chosen *)
	If[!dilutionsQ&&MatchQ[dataType,DilutedConcentrationTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory|DilutedConcentrationTurbidity|DilutedConcentrationUnblankedTurbidity],
		Block[{},
			Message[Error::PlotNephelometryKineticsDataTypeNotAvailable,"Dilutions",input,dataType];
			Return[$Failed]
		]
	];

	(* if blanks were not measured, unblanked data types cannot be chosen *)
	If[MatchQ[blank, {{}...}]&&MatchQ[dataType,UnblankedTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory|DilutedConcentrationUnblankedTurbidity],
		Module[{},
			Message[Error::PlotNephelometryKineticsDataTypeNotAvailable,"Blanks",input,dataType];
			Return[$Failed]
		]
	];

	(* if temperature was not measured, Temperature data type cannot be chosen *)
	If[(MatchQ[tempData,Null|{}|ListableP[{}]|ListableP[Null]]||NullQ[QuantityMagnitude[Map[Last,tempData,{3}]]])&&MatchQ[dataType,Temperature],
		Module[{},
			Message[Error::PlotNephelometryKineticsDataTypeNotAvailable,"Temperatures",input,dataType];
			Return[$Failed]
		]
	];

	(* -- Resolve PlotType -- *)
	resolvedPlotType = Which[
		(* Resolve Automatic *)
		MatchQ[plotType,Automatic]&&MatchQ[dataType,DilutedConcentrationTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory],ContourPlot,
		MatchQ[plotType,Automatic],ListLinePlot,

		(* No dilutions data, can't do a 3D plot, roll on and do a 2D plot. *)
		!dilutionsQ && MatchQ[plotType,plotTypes3D],Block[{},
			Message[Warning::Data2D];
			ListLinePlot
		],

		True,plotType
	];



	(* can only have 3D plot if dilutions and diluted inputConcentration blanked/unblanked turbidity trajectory *)
	(*DilutedConcentrationTurbidityTrajectory: turbidity v time v inputConcentration
	DilutedConcentrationUnblankedTurbidityTrajectory: unblanked turbidity v time v inputConcentration *)

	(* all others are 2D plots *)
	(*Temperature: temp v time
	TurbidityTrajectory: turbidity v time
	UnblankedTurbidityTrajectory: unblanked turbidity v time
	 DilutedConcentrationTurbidity: turbidity v inputConcentration
	 DilutedConcentrationUnblankedTurbidity: unblanked turbidity v inputConcentration *)

	(* determine what type of x data to plot. time is in the first position of the quantity array *)
	xData = Switch[dataType,
		TurbidityTrajectory|DilutedConcentrationTurbidity|DilutedConcentrationTurbidityTrajectory,Map[First,turbidities,{3}],
		UnblankedTurbidityTrajectory|DilutedConcentrationUnblankedTurbidity|DilutedConcentrationUnblankedTurbidityTrajectory,Map[First,unblankedTurbidities,{3}],
		Temperature,Map[First,tempData,{3}]
	];

	(* determine y data. turbidities are in second position in quantity array *)
	yData = Switch[dataType,
		TurbidityTrajectory|DilutedConcentrationTurbidityTrajectory,Map[Last,turbidities,{3}],
		DilutedConcentrationTurbidity|DilutedConcentrationUnblankedTurbidity,MapThread[ConstantArray[#1,Length[First[#2]]]&,{inputDilutedConcentrations, xData}],
		UnblankedTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory,Map[Last,unblankedTurbidities,{3}],
		Temperature,Map[Last,tempData,{3}]
	];

	(* inputConcentration always on z if 3D plot *)
	zData = MapThread[ConstantArray[#1,Length[First[#2]]]&,{inputDilutedConcentrations, xData}];

	(* Calculate axis endpoints *)
	(* find the Max value of the y data points. Get rid of units so it can be used for the plot range. *)
	xAxisEndpoints = Unitless[Max[Flatten@xData]];

	(* find the Max value of the y data points. Get rid of units so it can be used for the plot range. *)
	yAxisEndpoints = Unitless[Max[Flatten@yData]];

	(* find the Max value of the z data points. Get rid of units so it can be used for the plot range. *)
	zAxisEndpoints = Unitless[Max[Flatten@zData]];

	(* label the plot with the data object *)
	plotLabels = ToString[objects];

	(* get axis labels *)
	xLabel = Switch[dataType,
		TurbidityTrajectory|UnblankedTurbidityTrajectory|Temperature|DilutedConcentrationTurbidityTrajectory|DilutedConcentrationUnblankedTurbidityTrajectory,"Time (Second)",
		DilutedConcentrationTurbidity|DilutedConcentrationUnblankedTurbidity,"Input Concentration ("<>ToString[Units[First[inputDilutedConcentrations]]]<>")"
	];

	yLabel = Switch[dataType,
		TurbidityTrajectory|DilutedConcentrationTurbidity|DilutedConcentrationUnblankedTurbidity|DilutedConcentrationTurbidityTrajectory|UnblankedTurbidityTrajectory|DilutedConcentrationUnblankedTurbidity|DilutedConcentrationUnblankedTurbidityTrajectory,"Turbidity (RNU)",
		Temperature,"Temperature (Celsius)"
	];

	zlabel = If[MatchQ[resolvedPlotType,ListLinePlot],Null,"Input Concentration ("<>ToString[Units[First[inputDilutedConcentrations]]]<>")"];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[listedOptions,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[listedOptions,op]]
	];

	(* Override unspecified input options with nephelometry specific formatting *)
	plotOptions = Normal@KeyDrop[
		ReplaceRule[safeOptions,
			If[MatchQ[resolvedPlotType,plotTypes3D],
				{
					(* Set specific defaults *)
					setDefaultOption[PlotLabel,plotLabels],
					setDefaultOption[PlotRange,{{0,xAxisEndpoints},{0,yAxisEndpoints},{0,zAxisEndpoints}}],
					setDefaultOption[FrameLabel,{xLabel,yLabel,zlabel}],
					setDefaultOption[LabelStyle,{10,Bold,FontFamily->"Arial"}],
					setDefaultOption[ImageSize,400]
				},
				{
					(* Set specific defaults *)
					setDefaultOption[PlotLabel,plotLabels],
					setDefaultOption[PlotRange,{{0,xAxisEndpoints},{0,yAxisEndpoints}}],
					setDefaultOption[FrameLabel,{xLabel,yLabel}],
					setDefaultOption[LabelStyle,{10,Bold,FontFamily->"Arial"}],
					setDefaultOption[ImageSize,400]
				}
			]
		],
		{DataType,PlotType}
	];

	(*********************************)

	(* Call EmeraldListLinePlot and get those resolved options *)
	{plot,mostlyResolvedOps} = If[MatchQ[resolvedPlotType,ListLinePlot],

		EmeraldListLinePlot[
			MapThread[{#1, #2}&,{xData,yData},3],
			ReplaceRule[plotOptions, {Output->{Result,Options}}]
		],

		Module[{plots,plotListCorrect,zoomablePlot,allResolvedOptions,validResolvedOptions},
			plots = Switch[resolvedPlotType,
				ContourPlot, EmeraldListContourPlot[MapThread[{#1, #2, #3}&,{xData,yData,zData},3],PassOptions[EmeraldListContourPlot,plotOptions]],
				DensityPlot, ListDensityPlot[MapThread[{#1, #2, #3}&,{xData,yData,zData},3],PassOptions[ListDensityPlot,plotOptions]],
				(* Sending in full options from PassOptions makes the plot appear bizarre *)
				ListPlot3D, ListPlot3D[MapThread[{#1, #2, #3}&,{xData,yData,zData},3],Normal@KeyTake[plotOptions,Keys[Options[ListPlot3D]]]]
			];

			(*plotListCorrect = If[MatchQ[input,ObjectP[]],
				First[plots],
				plots
			];*)

			zoomablePlot=If[TrueQ[OptionDefault[OptionValue[Zoomable]]],
				Zoomable[plots],
				plots
			];

			(* Get the resolved options from the plot. *)
			allResolvedOptions=Normal[Join[Association[plotOptions],Association[Quiet[AbsoluteOptions[plots]]]]];
			validResolvedOptions=(ToExpression[#[[1]]]->#[[2]]&)/@ToList[PassOptions[PlotNephelometryKinetics,allResolvedOptions]];

			(* Force output of Result and Options *)
			{zoomablePlot,validResolvedOptions}

		]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOptions,mostlyResolvedOps,Append->False];

	(* Return the requested outputs *)
	outputSpecification/.{
		Result->plot,
		Options->resolvedOps,
		Preview->plot/.If[MemberQ[listedOptions,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
		Tests->{}
	}
];
