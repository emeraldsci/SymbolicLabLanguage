(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVolume*)


(* ::Subsubsection::Closed:: *)
(*PlotVolume*)


DefineOptions[PlotVolume,
	Options :> {
		{
			OptionName->TargetUnits,
			Default->Automatic,
			Description->"List of Units to be used in the plot.  If Automatic is on will consult display option to determine if volume (\[CapitalIHat]\.bcL) or distance (mm).",
			AllowNull->False,
			Category->"Data Specifications",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[Automatic]],
				Widget[
					Type->Quantity,
					Pattern:>Alternatives[GreaterEqualP[0 Milliliter],GreaterEqualP[0 Millimeter]],
					Units->Alternatives[{1,{Milliliter, {Microliter, Milliliter, Liter}}}, {1,{Millimeter, {Micrometer, Millimeter, Meter}}}]
				]
			]
		},
		{
			OptionName->PlotType,
			Default->Automatic,
			Description->"Determines if histograms or BoxWiskerCharts are desired for the data.  If Automatic, for a single list of intensities hitogram is assumed, and a list of list assumes BoxWiskerChart.",
			AllowNull->False,
			Category->"Method",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Histogram,BoxWhiskerChart,Automatic]]
		},
		{
			OptionName->Legend,
			Default->None,
			Description->"List of text descriptions of each data set in the plot.",
			AllowNull->True,
			Category->"Legend",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Adder[Widget[Type->String,Pattern:>_String,Size->Word]]
			]
		},
		{
			OptionName->BoxWhiskerType,
			Default->Automatic,
			Description->"Option fed to BoxWiskerPlots should they be used defining the style of plot.",
			AllowNull->True,
			Category->"Method",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives["Notched","Outliers","Median","Basic","Mean","Diamond"]]
		},
		{
			OptionName->ChartLabels,
			Default->None,
			Description->"List of labels to provide for each box catagory in the BoxWisker plot type.",
			AllowNull->False,
			Category->"Plot Labeling",
			Widget->Alternatives[
				Widget[Type->Enumeration,Pattern:>Alternatives[None]],
				Adder[Widget[Type->String,Pattern:>_String,Size->Word]]
			]
		},
		{
			OptionName->Display,
			Default-> Distance,
			Description->"Indicates if the raw distance readings or calculated volumes should be shown.",
			AllowNull->False,
			Category->"Data Specifications",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[Volume,Distance]]
		},
		(* Hidden Options *)
		{
			OptionName->Buffer,
			Default->Automatic,
			Description->"Buffer type for reference of experimental paramaters.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[UVBuffer,Water,ElutionBuffer,Automatic]]
		},
		{
			OptionName->RamanSpectra,
			Default->Span[960 Nanometer,970 Nanometer],
			Description->"Span in nanometers encompasses the portion of the spectra to use for Raman calculations (inclusive).  Must be paramaterized in advance in the Parameters stored in physics.m.",
			AllowNull->False,
			Category->"Hidden",
			Widget->Span[
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Nanometer],Units->Nanometer],
				Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Nanometer],Units->Nanometer]
			]
		},
		{
			OptionName->AutoBlank,
			Default->Automatic,
			Description->"If AutoBlank is on, will subtract a background.  Automatic will leave AutoBlanking on if using Volume, but will be turned on by default if a raw distance is used as an input (assumes that distance referes to a PathLength).",
			AllowNull->False,
			Category->"Hidden",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[BooleanP,Automatic]]
		}
	},
	SharedOptions :> {
		EmeraldBoxWhiskerChart,
		EmeraldHistogram
	}];

plotVolumeRawP = {(_?NumericQ|_?DistanceQ|_?VolumeQ)..}|QuantityArrayP[{Meter..}]|QuantityArrayP[{Liter..}];

Warning::ConflictBoxWhisker="The BoxWhiskerType has been set to Null for Histogram plot. If a BoxWhiskerChart is required, please set PlotType to BoxWhiskerChart.";
PlotVolume[in:ListableP[plotVolumeRawP]|QuantityArrayP[{{Meter..}..}]|QuantityArrayP[{{Liter..}..}],ops:OptionsPattern[]]:=Module[
	{originalOps,safeOps,output,plotType,fullData,boxWhiskerType,resolvedBoxWhiskerType,conflictBoxWhiskerQ,specificOptions,plot,mostlyResolvedOps,resolvedOps,finalResolvedOps},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotVolume, ToList[ops]];

	(* Requested output, either a single value or list of Alternatives[Results, Options, Preview, Tests] *)
	output=Lookup[safeOps,Output];

	plotType = resolveVolumePlotType[in,Lookup[safeOps,PlotType]];
	fullData = resolveVolumeData[in];

	(* Resolve BoxWhiskerType *)
	boxWhiskerType=Lookup[safeOps,BoxWhiskerType];

	resolvedBoxWhiskerType=Which[
		MatchQ[plotType,Histogram],Null,
		MatchQ[boxWhiskerType,Except[Automatic|Null]],boxWhiskerType,
		True,"Outliers"
	];

	(* Throw a warning if a Histogram is plotted, but BoxWhiskerType is not Automatic or Null *)
	conflictBoxWhiskerQ=MatchQ[plotType,Histogram]&&MatchQ[boxWhiskerType,Except[Automatic|Null]];

	If[conflictBoxWhiskerQ,Message[Warning::ConflictBoxWhisker]];

	(* Options specific to the function which do not get passed directly to the underlying plot *)
	specificOptions={PlotType->plotType,BoxWhiskerType->resolvedBoxWhiskerType};

	{plot,mostlyResolvedOps}=Switch[plotType,
		Histogram,
			plotVolumeHistogram[fullData,ReplaceRule[safeOps,BoxWhiskerType->resolvedBoxWhiskerType]],
		BoxWhiskerChart,
			plotVolumeBoxWhiskerChart[fullData,ReplaceRule[safeOps,BoxWhiskerType->resolvedBoxWhiskerType]]
	];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,Prepend[mostlyResolvedOps,Output->output],Append->False];

	(* Any special resolutions specific to the plot (which are not covered by underlying plot function) *)
	finalResolvedOps=ReplaceRule[resolvedOps,
		(* Any custom options which need special resolution *)
		specificOptions,
		Append->False
	];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->finalResolvedOps,
		Preview->plot,
		Tests->{}
	}
];

resolveVolumePlotType[in_,type:(Histogram|BoxWhiskerChart)]:=type;
resolveVolumePlotType[plotVolumeRawP,Automatic]:=Histogram;
resolveVolumePlotType[{plotVolumeRawP..}|QuantityArrayP[{{Meter..}..}]|QuantityArrayP[{{Liter..}..}],Automatic]:=BoxWhiskerChart;

resolveVolumeData[in:plotVolumeRawP]:={in};
resolveVolumeData[in_]:=in;


plotVolumeHistogram[datas_,safeOps_List]:=Module[
	{plot,mostlyResolvedOps},

	(* Plot the data as a histogram *)
	{plot,mostlyResolvedOps}=EmeraldHistogram[datas,
		ReplaceRule[{stringOptionsToSymbolOptions[PassOptions[PlotVolume, EmeraldHistogram, safeOps]]},
			{Output->{Result,Options},ChartLegends->Automatic}
		]
	]

];

plotVolumeBoxWhiskerChart[datas_,safeOps_List]:=Module[
	{dataDims,resolvedData,plot,mostlyResolvedOps},

	(* Dimensions of the input data *)
	dataDims=Dimensions[datas];

	(* Add an extra list if multiple input datasets were provided so they highlight with different colors *)
	resolvedData=Which[
		(* Quantity Array *)
		Length[dataDims]==2,ArrayReshape[datas,Prepend[dataDims,1]],
		(* List of multiple lists *)
		MatchQ[datas,{{UnitsP[]..}..}],{datas},
		(* Default is unchanged *)
		True,datas
	];

	(* Plot the data *)
	{plot,mostlyResolvedOps}=EmeraldBoxWhiskerChart[resolvedData,Lookup[safeOps,BoxWhiskerType],
		ReplaceRule[{stringOptionsToSymbolOptions[PassOptions[PlotVolume, EmeraldBoxWhiskerChart, safeOps]]},
			{Output->{Result,Options},ChartLegends->Automatic}
		]
	]

];


(* --- Objects --- *)
PlotVolume[datas:{ListableP[objectOrLinkP[Object[Data, Volume]]]..},ops:OptionsPattern[]]:=
	PlotVolume[Download[datas],ops];



PlotVolume[infos:{packetOrInfoP[Object[Data,Volume]]..},ops:OptionsPattern[]]:=Module[
	{display,vals},

	display = OptionDefault[OptionValue[Display]];

	vals = Switch[display,
		Distance|{Distance},
			Lookup[infos,LiquidLevel],
		Volume|{Volume},
			Volume/.infos
	];

	PlotVolume[vals,ops]

];


PlotVolume[infos:{{packetOrInfoP[Object[Data,Volume]]..}..},ops:OptionsPattern[]]:=Module[
	{display,vals},

	display = OptionDefault[OptionValue[Display]];

	vals = Switch[display,
		Distance|{Distance},
			Map[Lookup[#,LiquidLevel]&,infos],
		Volume|{Volume},
			Quiet[Map[SampleVolume[#,PassOptions[PlotVolume,SampleVolume,ops]]&,infos]]
	];

	PlotVolume[vals,ops]

];


PlotVolume[blanks:{packetOrInfoP[Object[Data,Volume]]..},infos:{packetOrInfoP[Object[Data,Volume]]..},ops:OptionsPattern[]]:=Module[{vols},

	(* Obtain the volume from the data using the volume function *)
	vols=SampleVolume[blanks,infos,PassOptions[PlotVolume,SampleVolume,ops]];

	(* Plot the volumes as normal *)
	PlotVolume[vols,ops]

]/;MatchQ[Display/.Join[{ops},Options[PlotVolume]],{Volume,___}]
