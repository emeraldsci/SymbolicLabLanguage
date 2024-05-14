(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotELISA*)

DefineOptions[PlotELISA,
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

Error::MixmatchedELISAAssayType="The provided data objects contain different ELISA AssayType (CapillaryELISA and different types of ELISA) but they have incompatible units. Please separate your PlotELISA call into different commands with only CapillaryELISA data or ELISA data.";
Error::MixmatchedCapillaryELISACartridgeType="The provided CapillaryELISA data objects contain different CapillaryELISA cartridge types. The data from Customizable cartridges are provided in the raw Fluorescence intensity values while the data from pre-loaded cartridges are provided in the Concentration values. Please separate your PlotELISA call into different commands with only one type of cartridges.";


(*Function for plotting unanalyzed SurfaceTension data objects*)
PlotELISA[
	objs:ListableP[ObjectReferenceP[Object[Data,ELISA]]|LinkP[Object[Data,ELISA]]|PacketP[Object[Data, ELISA]]],
	ops:OptionsPattern[PlotELISA]
]:=Module[
	{
		originalOps,safeOps,output,
		dataPackets,cartridgeTypeDownload,singleAnalyteNames,multiplexAnalytesNames,assayType,cartridgeType,
		plotOptions,plotData,frameLabel,plotLabels,
		plot,mostlyResolvedOps,resolvedOps,setDefaultOption
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotELISA,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(*********************************)

	(* Resolve the raw numerical data that you will plot and download all relevant information *)
	{dataPackets,cartridgeTypeDownload,singleAnalyteNames,multiplexAnalytesNames}=Transpose@Quiet[
		Download[
			ToList[objs],
			{
				Packet[AssayType, DilutionFactors, Absorbances, Intensities, Analyte, MultiplexAnalytes, AssayConcentrations, MultiplexAssayConcentrations],
				(* Download the type of the Cartridge from the Protocol. This may not exist, for regular ELISA protocol *)
				Protocol[CartridgeType],
				(* Get the names of all analytes *)
				Analyte[Name],
				MultiplexAnalytes[Name]
			}
		],
		{Download::FieldDoesntExist,Download::NotLinkField}
	];

	(* Check the AssayType of the data. We use different fields for CapillaryELISA and the various ELISA types *)
	assayType=Which[
		MatchQ[Flatten@Lookup[dataPackets,AssayType],{CapillaryELISA..}],
		FirstOrDefault[Flatten@Lookup[dataPackets,AssayType]],
		MatchQ[Flatten@Lookup[dataPackets,AssayType],{Except[CapillaryELISA]..}],
		ELISA,
		(* Give error for CapillaryELISA/ELISA mixture *)
		True,
		Message[Error::MixmatchedELISAAssayType];Return[$Failed]
	];

	(* Check if the CapillaryELISA is Customizable or not *)
	cartridgeType=If[MatchQ[assayType,CapillaryELISA],
		If[MemberQ[cartridgeTypeDownload,Customizable]&&MemberQ[cartridgeTypeDownload,Except[Customizable]],
			(* Give error for Customizable/non-Customizable mixture *)
			Message[Error::MixmatchedCapillaryELISACartridgeType];Return[$Failed],
			FirstOrDefault[cartridgeTypeDownload]
		],
		Null
	];

	(* Get the raw data to plot *)
	plotData=Which[
		(* Use fluorescence Intensities for Customizable cartridges *)
		MatchQ[assayType,CapillaryELISA]&&MatchQ[cartridgeType,Customizable],
		MapThread[
			Transpose[{#1,#2}]&,
			{Lookup[dataPackets, DilutionFactors],Lookup[dataPackets, Intensities]}
		],
		(* Use Concentrations for pre-loaded cartridges *)
		MatchQ[assayType,CapillaryELISA],
		Flatten[
			MapThread[
				Function[
					{dilutionFactors,assayConcs,multiplexAssayCons},
					If[MatchQ[assayConcs,{}],
						(* Flatten out Multiplex data *)
						Map[
							Transpose[{dilutionFactors,#}]&,
							multiplexAssayCons[[All,2]]
						],
						{Transpose[{dilutionFactors, assayConcs}]}
					]
				],
				{Lookup[dataPackets, DilutionFactors],Lookup[dataPackets, AssayConcentrations],Lookup[dataPackets, MultiplexAssayConcentrations]}
			],
			1
		],
		True,
		MapThread[
			If[MatchQ[#1,{}],
				{1.,#2[[1]]*AbsorbanceUnit},
				Transpose[{#1,#2*AbsorbanceUnit}]
			]&,
			{Lookup[dataPackets, DilutionFactors],Lookup[dataPackets, Absorbances]}
		]
	];

	(* Get the correct frame label *)
	frameLabel=Which[
		MatchQ[assayType,CapillaryELISA]&&MatchQ[cartridgeType,Customizable],
		{"Dilution Factor","Fluorescence Intensity (RFU)"},
		MatchQ[assayType,CapillaryELISA],
		{"Dilution Factor","Concentration (pg/mL)"},
		True,
		{"Dilution Factor","Absorbance Intensity (Au)"}
	];

	(* Get the correct plot label *)
	plotLabels=Which[
		(* Use ID if we only have one analyte per data *)
		MatchQ[assayType,CapillaryELISA]&&MatchQ[cartridgeType,Customizable],
		Lookup[dataPackets,ID],
		(* Use Concentrations for pre-loaded cartridges *)
		MatchQ[assayType,CapillaryELISA],
		Flatten[
			MapThread[
				Function[
					{id,singleName,multiNames},
					If[MatchQ[singleName,$Failed|Null],
						(* Flatten out Multiplex data *)
						Map[
							StringJoin[id," + ",#]&,
							multiNames
						],
						StringJoin[id," + ",singleName]
					]
				],
				{Lookup[dataPackets, ID],singleAnalyteNames,multiplexAnalytesNames}
			]
		],
		True,
		None
	];

	(* Helper function for setting default options *)
	setDefaultOption[op_Symbol,default_]:=If[MatchQ[Lookup[originalOps,op],_Missing],
		Rule[op,default],
		Rule[op,Lookup[originalOps,op]]
	];

	(* Override unspecified input options with surface tension specific formatting *)
	plotOptions=ReplaceRule[safeOps,
		{
			(* Set specific defaults *)
			setDefaultOption[Joined,False],
			setDefaultOption[Scale,LogLinear],
			setDefaultOption[FrameLabel,frameLabel],
			setDefaultOption[Legend,plotLabels]
		}
	];
	(*********************************)

	(* Call EmeraldListLinePlot and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldListLinePlot[plotData,
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
