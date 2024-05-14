(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDNASequencing*)




Error::PlotDNASequencingObjectNotFound="Specified object `1` cannot be found in the database. Please verify the objects' IDs or names.";
Error::PlotDNASequencingNoAssociatedObject="Specified input `1` is not associated with a `2` object. Please verify the input object `1`, or associate it with a `2` object.";


DefineOptions[PlotDNASequencing,
	Options:>{
		(* Hide these options *)
		ModifyOptions[EmeraldListLinePlot,
			{
				ErrorBars,ErrorType,InterpolationOrder,
				Peaks,PeakLabels,PeakLabelStyle,
				SecondYCoordinates,SecondYColors,SecondYRange,SecondYStyle,SecondYUnit,TargetUnits,
				Fractions,FractionColor,FractionHighlights,FractionHighlightColor,
				Ladder,Display,
				PeakSplitting,PeakPointSize,PeakPointColor,PeakWidthColor,PeakAreaColor
			},
			Category->"Hidden"
		]
	},
	SharedOptions:>{EmeraldListLinePlot}
];

(* Core Overload to plot raw DNA sequencing data *)
PlotDNASequencing[
	myInput:ObjectP[Object[Data,DNASequencing]],
	myOptions:OptionsPattern[PlotDNASequencing]]:=
Module[
	{
		originalOps,safeOps,output,objectExistsQ,downloadFields,downloadedData,protocolObject, wells,
		electropherogramData1, electropherogramData2, electropherogramData3, electropherogramData4,
		baseAssignment1, baseAssignment2, baseAssignment3, baseAssignment4,
		plotLabels,xAxisEndpoints,yAxisEndpoints,plotOptions,plot,mostlyResolvedOps,resolvedOps
	},

	(* Convert the original options into a list *)
	originalOps=ToList[myOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotDNASequencing,originalOps];

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
			Message[Error::PlotDNASequencingObjectNotFound,myInput];
			Return[$Failed]
		]
	];

	(* ----- Check if the objects have an associated protocol object ----- *)

	(* Check the associated object *)
	(* data without associated protocol *)
	If[MatchQ[myInput,ObjectP[Object[Data,DNASequencing]]]&&!MatchQ[Download[myInput,Protocol],ObjectP[Object[Protocol,DNASequencing]]],
	Module[{},
		Message[Error::PlotDNASequencingNoAssociatedObject,myInput,"protocol"];
		Return[$Failed]
	]];

	(* ---------- Download the Data ---------- *)

	(* Figure out what to download based on the input *)
	downloadFields= {
		Protocol,
		Well,
		SequencingElectropherogramChannel1,
		SequencingElectropherogramChannel2,
		SequencingElectropherogramChannel3,
		SequencingElectropherogramChannel4,
		Channel1BaseAssignment,
		Channel2BaseAssignment,
		Channel3BaseAssignment,
		Channel4BaseAssignment
	};

	(* Download the data *)
	downloadedData=Download[myInput,downloadFields];

	(* Split the downloaded data -- data gets an extra list if it was downloaded from a protocol so we have to split in this weird way here *)
	{
		protocolObject,
		wells,
		electropherogramData1,
		electropherogramData2,
		electropherogramData3,
		electropherogramData4,
		baseAssignment1,
		baseAssignment2,
		baseAssignment3,
		baseAssignment4

	}= {
		Download[First[downloadedData],Object],
		downloadedData[[2]],
		{downloadedData[[3]]},
		{downloadedData[[4]]},
		{downloadedData[[5]]},
		{downloadedData[[6]]},
		{downloadedData[[7]]},
		{downloadedData[[8]]},
		{downloadedData[[9]]},
		{Last[downloadedData]}
	};
	 
	(* ---------- Plot the Data ---------- *)

	(* Calculate axis endpoints *)
	(* take the last data point to get the x value, should all be the same for data sets 1-4. Get rid of units so it can be used for the plot range. *)
	xAxisEndpoints = Unitless[First[Last[First[electropherogramData1]]]];

	(* find the Max value of the y data points. Get rid of units so it can be used for the plot range. *)
	yAxisEndpoints = Unitless[Max[First[electropherogramData1][[All, 2]]]];

	(* label the plot with the protocol and corresponding well *)
	plotLabels = ToString[protocolObject]<>", Well "<>ToString[wells];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
	Rule[op,default],
	Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with DNA sequencing specific formatting *)
	plotOptions = ReplaceRule[safeOps,
		{
			(* Set specific defaults *)
			setDefaultOption[PlotLabel,plotLabels],
			setDefaultOption[Legend,{baseAssignment1,baseAssignment2,baseAssignment3,baseAssignment4}],
			setDefaultOption[PlotRange,{{0,xAxisEndpoints},{0,yAxisEndpoints}}],
			setDefaultOption[FrameLabel,{"Scan Number","Relative Fluorescence Units (RFU)"}],
			setDefaultOption[LabelStyle,{10,Bold,FontFamily->"Arial"}],
			setDefaultOption[ImageSize,400]
		}
	];

	(*********************************)

	(* Call EmeraldListLinePlot and get those resolved options *)
	{plot,mostlyResolvedOps} = EmeraldListLinePlot[
		{electropherogramData1, electropherogramData2, electropherogramData3, electropherogramData4},
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
PlotDNASequencing[
	myInputs:{ObjectP[Object[Data,DNASequencing]]..},
	myOptions:OptionsPattern[PlotDNASequencing]]:=

     PlotDNASequencing[#,myOptions]&/@myInputs;


(* Protocol object overload *)
PlotDNASequencing[
	myInputs:ListableP[ObjectP[Object[Protocol,DNASequencing]]],
	myOptions:OptionsPattern[PlotDNASequencing]]:=
Module[{objectExistsQ,dataObjects},

	(* Check if the input exists in the database *)
	objectExistsQ=DatabaseMemberQ[myInputs];

	(* If object doesn't exist, return $Failed with an error *)
	If[
		!objectExistsQ,
		Module[{},
			Message[Error::PlotDNASequencingObjectNotFound,myInputs];
			Return[$Failed]
		]
	];

	(* check if the protocols have associated data objects *)
	If[
		MatchQ[myInputs,ListableP[ObjectP[Object[Protocol,DNASequencing]]]]&&!MatchQ[Download[myInputs,Data],ListableP[ObjectP[Object[Data,DNASequencing]]]],
		Module[{},
			Message[Error::PlotDNASequencingNoAssociatedObject,myInputs,"data"];
			Return[$Failed]
		]
	];

	(* download the data objects from the protocols *)
	dataObjects = Flatten[Download[myInputs,Data]][Object];

	(* send data objects to PlotDNASequencing *)
	PlotDNASequencing[dataObjects,myOptions]

];
