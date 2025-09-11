(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNephelometry*)


Error::PlotNephelometryObjectNotFound="Specified object `1` cannot be found in the database. Please verify the objects' IDs or names.";
Warning::PlotNephelometryNoAssociatedProtocol="Specified input `1` is not associated with a Protocol object. Please verify the input object `1`, or associate it with a Protocol object.";
Error::PlotNephelometryNoData="Specified input `1` is not associated with a Data object and/or it does not have a valid Data field. Please verify the input object `1`, or associate it with a Data object.";
Error::PlotNephelometryNoInputConc="There is no specified concentration, nor are there specified dilutions. As a result, the plot object cannot be constructed; specify either InputConcentration or Dilutions in the Data object and re-plot.";
Error::NephelometryProtocolDataNotPlotted = "The data objects linked to the input protocol were not able to be plotted. The data objects may be missing field values that are required for plotting. Please inspect the data objects to ensure that they contain the data to be plotted, and call PlotNephelometry or PlotObject on an individual data object to identify the missing values.";


DefineOptions[PlotNephelometry,
	Options:>{
		(* Raw data fields *)
		{
			OptionName->DataType,
			Description->"The type of data to display on the plot.",
			Default->Turbidity,
			AllowNull->True,
			Widget->Widget[Type->Enumeration,Pattern:>Temperature|Turbidity|UnblankedTurbidity],
			Category->"Raw Data"
		},

		(* Change default Display options *)
		ModifyOptions[
			DisplayOption,
			Default->{Peaks},
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[{}]],
				Adder[Widget[Type->Enumeration,Pattern:>Peaks|Fractions|Ladder]]
			],
			Category->"General"
		],

		(* Set default Peaks/Fractions/Ladders to {} so widget appears in command builder *)
		ModifyOptions[EmeraldListLinePlot,{Peaks,Fractions},Default->{}],

		(* Hide some of the less useful EmeraldListLinePlot options *)
		ModifyOptions[EmeraldListLinePlot,{FrameUnits,Scale,Prolog,Epilog},Category->"Hidden"]

	},

	SharedOptions :> {
		(* Include additional options without modification *)
		ZoomableOption,
		PlotLabelOption,

		(* Inherit remaining options from EmeraldListLinePlot *)
		EmeraldListLinePlot
	}
];

(* Core Overload to plot raw nephelometry data *)
PlotNephelometry[
	myInput:ObjectP[Object[Data,Nephelometry]],
	myOptions:OptionsPattern[PlotNephelometry]]:=
	Module[
		{
			originalOps,safeOps,output,objectExistsQ,downloadFields,downloadedData, object, dilutionsQ, yData, xData,
			wells, turbidities, unblankedTurbidities, inputDilutedConcentrations, inputConcentration, tempData, dilutions,
			plotLabels,xAxisEndpoints,yAxisEndpoints,plotOptions,plot,mostlyResolvedOps,resolvedOps
		},

		(* Convert the original options into a list *)
		originalOps=ToList[myOptions];

		(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
		safeOps=SafeOptions[PlotNephelometry,originalOps];

		(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
		output=Lookup[safeOps,Output];

		(* ---------- Initial Error Checks -----------*)

		(* ----- Check if the inputs are valid ----- *)

		(* Check if the input exists in the database *)
		objectExistsQ=DatabaseMemberQ[myInput];

		(* If object doesn't exist, return $Failed with an error *)
		If[
			!objectExistsQ,
			Module[{},
				Message[Error::PlotNephelometryObjectNotFound,myInput];
				Return[$Failed]
			]
		];

		(* ----- Check if the objects have an associated protocol object ----- *)

		(* Check the associated object *)
		(* data without associated protocol *)
		If[MatchQ[myInput,ObjectP[Object[Data,Nephelometry]]]&&!MatchQ[Download[myInput,Protocol],ObjectP[Object[Protocol,Nephelometry]]],
			Module[{},
				Message[Warning::PlotNephelometryNoAssociatedProtocol,myInput];
			]];

		(* ---------- Download the Data ---------- *)

		(* Figure out what to download based on the input *)
		downloadFields= {
			Object,
			Wells,
			Turbidities,
			UnblankedTurbidities,
			InputDilutedConcentrations,
			InputConcentration,
			Temperatures,
			Dilutions
		};

		(* Download the data *)
		downloadedData=Download[myInput,downloadFields,Date->Now];

		(* Split the downloaded data -- data gets an extra list if it was downloaded from a protocol so we have to split in this weird way here *)
		{
			object,
			wells,
			turbidities,
			unblankedTurbidities,
			inputDilutedConcentrations,
			inputConcentration,
			tempData,
			dilutions
		}= {
			First[downloadedData],
			downloadedData[[2]],
			downloadedData[[3]],
			downloadedData[[4]],
			downloadedData[[5]],
			downloadedData[[6]],
			downloadedData[[7]],
			Last[downloadedData]
		};


		(* ---------- Plot the Data ---------- *)

		(* determine if we did dilutions or not *)
		dilutionsQ = If[MatchQ[dilutions,{}],False,True];

		(* determine what type of data to plot *)
		yData = Switch[
			Lookup[safeOps,DataType],
			Turbidity,turbidities,
			UnblankedTurbidity,unblankedTurbidities,
			Temperature,tempData
		];

		(* use diluted concentrations if available *)
		xData = If[dilutionsQ,
			inputDilutedConcentrations,
			(* throw error if inputConcentration is Null *)
			If[MatchQ[inputConcentration,Null],
				Message[Error::PlotNephelometryNoInputConc];
				Return[output/.{Result->Null,Tests->{},Options->$Failed,Preview->Null}],
				(* otherwise use inputConcentration as a list for xdata *)
				{inputConcentration}
			]
		];

		(* Calculate axis endpoints *)
		(* find the Max value of the x data points. Get rid of units so it can be used for the plot range. *)
		xAxisEndpoints = Unitless[Max[xData]];

		(* find the Max value of the y data points. Get rid of units so it can be used for the plot range. *)
		yAxisEndpoints = Unitless[Max[yData]];

		(* label the plot with the data object *)
		plotLabels = ToString[object];

		(* Helper function for setting default options *)
		setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
			Rule[op,default],
			Rule[op,Lookup[originalOps,op]]
		];

		(* Override unspecified input options with nephelometry specific formatting *)
		plotOptions = Normal@KeyDrop[
			ReplaceRule[safeOps,
				{
					(* Set specific defaults *)
					setDefaultOption[PlotLabel,plotLabels],
					setDefaultOption[PlotRange,{{0,xAxisEndpoints},{0,yAxisEndpoints}}],
					setDefaultOption[FrameLabel,{"Input Concentration","Turbidity (RNU)"}],
					setDefaultOption[LabelStyle,{10,Bold,FontFamily->"Arial"}],
					setDefaultOption[ImageSize,400]
				}
			],
			DataType
		];

		(*********************************)

		(* Call EmeraldListLinePlot and get those resolved options *)
		{plot,mostlyResolvedOps} = EmeraldListLinePlot[
			Transpose[{xData,yData}],
			ReplaceRule[plotOptions,
				{Output->{Result,Options}}
			]
		];

		(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
		resolvedOps=ReplaceRule[safeOps,mostlyResolvedOps,Append->False];

		(* Return the requested outputs *)
		output/.{
			Result->plot,
			Options->resolvedOps,
			Preview->plot/.If[MemberQ[originalOps,ImageSize->_],{},{Rule[ImageSize,_]:>Rule[ImageSize,Full]}],
			Tests->{}
		}


	];


(* List of data objects overload *)
PlotNephelometry[
	myInputs:{ObjectP[Object[Data,Nephelometry]]..},
	myOptions:OptionsPattern[PlotNephelometry]]:=

	PlotNephelometry[#,myOptions]&/@myInputs;


(* Protocol object overload *)
PlotNephelometry[
	myInputs: ObjectP[Object[Protocol, Nephelometry]],
	myOptions: OptionsPattern[PlotNephelometry]] :=
	Module[{output,objectExistsQ, originalOps, safeOps, data, previewPlot, plots, resolvedOptions, outputPlot, outputOptions, finalResult},

		(* Check if the input exists in the database *)
		objectExistsQ=DatabaseMemberQ[myInputs];

		(* Convert the original options into a list for error handling messages *)
		originalOps=ToList[myOptions];

		(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
		safeOps=SafeOptions[PlotNephelometry,originalOps];

		(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
		output = ToList[Lookup[safeOps, Output]];

		(* If object doesn't exist, return $Failed with an error *)
		If[
			!objectExistsQ,
			Module[{},
				Message[Error::PlotNephelometryObjectNotFound,myInputs];
				Return[$Failed]
			]
		];

		(* Download the data from the input protocol *)
		data = Download[myInputs, Data];

		(* check if the protocols have associated data objects *)
		If[
			MatchQ[myInputs, ObjectP[Object[Protocol,Nephelometry]]] && !MatchQ[data, ListableP[ObjectP[Object[Data, Nephelometry]]]],
			Module[{},
				Message[Error::PlotNephelometryNoData, myInputs];
				Return[$Failed]
			]
		];

		(* If Preview is requested, return a plot with all of the data objects in the protocol overlaid in one plot *)
		previewPlot = If[MemberQ[output, Preview],
			PlotNephelometry[data, Sequence @@ ReplaceRule[safeOps, Output -> Preview]],
			Null
		];

		(* If either Result or Options are requested, map over the data objects. Remove anything that failed from the list of plots to be displayed*)
		{plots, resolvedOptions} = If[MemberQ[output, (Result | Options)],
			Transpose[
				(PlotNephelometry[#, Sequence @@ ReplaceRule[safeOps, Output -> {Result, Options}]]& /@ data) /. $Failed -> Nothing
			],
			{{}, {}}
		];

		(* If all of the data objects failed to plot, return an error *)
		If[MatchQ[plots, (ListableP[{}] | ListableP[Null])] && MatchQ[previewPlot, (Null | $Failed)],
			Message[Error::NephelometryProtocolDataNotPlotted];
			Return[$Failed],
			Nothing
		];

		(* If Result was requested, output the plots in slide view, unless there is only one plot then we can just show it not in slide view. *)
		outputPlot = If[MemberQ[output, Result],
			If[Length[plots] > 1,
				SlideView[plots],
				First[plots]
			]
		];

		(* If Options were requested, just take the first set of options since they are the same for all plots. Make it a List first just in case there is only one option set. *)
		outputOptions = If[MemberQ[output, Options],
			First[ToList[resolvedOptions]]
		];

		(* Prepare our final result *)
		finalResult = output /. {
			Result -> outputPlot,
			Options -> outputOptions,
			Preview -> previewPlot,
			Tests -> {}
		};

		(* Return the result *)
		If[
			Length[finalResult] == 1,
			First[finalResult],
			finalResult
		]

	];
