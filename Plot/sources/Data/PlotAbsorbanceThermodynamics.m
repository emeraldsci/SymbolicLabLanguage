(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceThermodynamics*)


(* ::Subsubsection:: *)
(*PlotAbsorbanceThermodynamics Options*)

(* get all the shared options that AllowNull->False *)
$optionsToAllowNull:=optionsToAllowNull=ToExpression[Lookup[Cases[OptionDefinition[EmeraldListLinePlot],KeyValuePattern["AllowNull"->False]],"OptionName"]];
DefineOptions[PlotAbsorbanceThermodynamics,
	optionsJoin[
		generateSharedOptions[
			Object[Data,MeltingCurve],
			{CoolingCurve,MeltingCurve},
			PlotTypes->{LinePlot},
			DefaultUpdates->{OptionFunctions->{arrowEpilog}}
		],
		Options:>{
			{
				OptionName->PlotType,
				Default->Automatic,
				AllowNull->False,
				Description->"Indicates how the data should be presented.",
				Widget->Widget[
					Type->Enumeration,
					Pattern:>Alternatives[Automatic,ListLinePlot,ListPlot3D]
				],
				Category->"Primary Data"
			},
			{
				OptionName->ArrowheadSize,
				Default->Medium,
				AllowNull->False,
				Widget->Alternatives[
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[Tiny,Small,Medium,Large]
					],
					Widget[
						Type->Number,
						Pattern:>GreaterP[0]
					]
				],
				Description->"The size of the arrows to lay atop the traces indicating the direction of the data.",
				Category->"Plot Style"
			},
			{
				OptionName->Wavelength,
				Default->Null,
				AllowNull->True,
				Widget->Widget[
					Type->Quantity,
					Pattern:>RangeP[0 Nanometer,1000 Nanometer],
					Units->Nanometer
				],
				Description->"Indicates the wavelength for which data should be plotted.",
				Category->"Data Specifications"
			}
		}],
	SharedOptions:>{
		ModifyOptions["Shared",
			EmeraldListLinePlot,
			$optionsToAllowNull,
			AllowNull->True
		],
		EmeraldListLinePlot
	}
];


(* ::Subsubsection:: *)
(*PlotAbsorbanceThermodynamics Messages*)
Error::UnresolvablePlotType="The provided data objects do not contain data of similar dimensionality. To create a 2D plot, please make sure that all inputs are of type Object[Data,MeltingCurve] with MeltingCurve3D Field populated. To create a 3D plot, please make sure that all inputs are of type Object[Data,MeltingCurve] with MeltingCurve3D -> Null.";
Error::MismatchedPlotType="The requested PlotType, `1`, does not match with the allowed PlotType, `2`, which is determined from the dimensionality of the provided data. Please change the value of PlotType to `2` or leave it unspecified to be set automatically.";
Error::Invalid3DPlotOptions="Since a 3D plot was requested, All of the provided EmeraldListLinePlot options must be Null. Please change the option values accordingly, or leave them unspecified to be set automatically.";


(* ::Subsubsection:: *)
(*PlotAbsorbanceThermodynamics Main Function*)


(* Raw Definition *)
PlotAbsorbanceThermodynamics[primaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAbsorbanceThermodynamics]]:=Module[
	{listedOptions,plotOutputs},

	(* Convert the original options into a list *)
	listedOptions=ToList[inputOptions];

	(* Call plot function *)
	plotOutputs=rawToPacket[
		primaryData,
		Object[Data,MeltingCurve],
		PlotAbsorbanceThermodynamics,
		SafeOptions[PlotAbsorbanceThermodynamics,listedOptions]
	];

	(* Return rawToPacket output, adding any missing options *)
	processELLPOutput[plotOutputs,SafeOptions[PlotAbsorbanceThermodynamics,listedOptions]]
];


(* Raw Definition for 2 data sets *)
PlotAbsorbanceThermodynamics[primaryData:rawPlotInputP,secondaryData:rawPlotInputP,inputOptions:OptionsPattern[PlotAbsorbanceThermodynamics]]:=PlotAbsorbanceThermodynamics[{primaryData,secondaryData},inputOptions];


(* Packet Definition *)
(* PlotAbsorbanceThermodynamics[infs:plotInputP,inputOptions:OptionsPattern[PlotAbsorbanceThermodynamics]]:= *)
PlotAbsorbanceThermodynamics[infs:ListableP[ObjectP[Object[Data,MeltingCurve]],2],inputOptions:OptionsPattern[PlotAbsorbanceThermodynamics]]:=Module[
	{
		listedOptions,safeOps,outputSpecification,packetsWithCoordinates,packets3D,packets2D,allowedPlotType,requestedPlotType,
		resolvedPlotType,options3DtoReturn,plots,mostlyResolvedOps,finalResolvedOps
	},

	(* Convert the original options into a list *)
	listedOptions=ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotAbsorbanceThermodynamics,ToList[listedOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	outputSpecification=Lookup[safeOps,Output];

	(* Pass down our wavelength option so that we can give back the correct data to plot. *)
	packetsWithCoordinates=ToList[addCoordinatesToAbsThermoPackets[infs,listedOptions]];

	(* Get the packets with 3D data and 2D data. *)
	packets3D=Select[packetsWithCoordinates,(!MatchQ[Lookup[#,MeltingCurve3D,Null],Null]&)];
	packets2D=Select[packetsWithCoordinates,(MatchQ[Lookup[#,MeltingCurve3D,Null],Null]&)];

	(* Check if all supplied data can be plotted in either 2D or 3D *)
	allowedPlotType=Switch[{packets2D,packets3D},
		(* No 3D packets *)
		{_List,{}},ListLinePlot,
		(* No 2D packets *)
		{{},_List},ListPlot3D,
		(* 2D and 3D packets *)
		_,Null
	];

	(* If both 2D and 3D data are present, throw an error message and return $Failed *)
	If[NullQ[allowedPlotType],
		Message[Error::UnresolvablePlotType];
		Return[$Failed];
	];

	(* Get the requested PlotType *)
	requestedPlotType=OptionDefault[OptionValue[PlotType]];

	(* Resolve PlotType based on the raw data and supplied option value *)
	resolvedPlotType=If[MatchQ[requestedPlotType,Alternatives[Automatic,allowedPlotType]],
		allowedPlotType,
		Message[Error::MismatchedPlotType,requestedPlotType,allowedPlotType];
		Return[$Failed];
	];

	(* If resolved PlotType is 3D, check if all ELLP options are Null since we are passing any options to EmeraldListPlot3D *)
	options3DtoReturn=If[MatchQ[resolvedPlotType,ListPlot3D],
		Module[{ellpOptionNames,ellpOptionValues},
			(* Get the EmeraldListLinePlot option names *)
			ellpOptionNames=DeleteCases[ToExpression[Keys[Options[EmeraldListLinePlot]]],Output];
			(* Get the supplie EmeraldListLinePlot option values *)
			ellpOptionValues=Lookup[listedOptions,ellpOptionNames,Null];
			(* Check if any option value is not Null *)
			If[!NullQ[ellpOptionValues],
				(
					Message[Error::Invalid3DPlotOptions];
					Return[$Failed]
				),
				(* generate a list of Nulled ELLP options to return *)
				Normal@AssociationThread[ellpOptionNames,ellpOptionValues]
			]
		]
	];

	(* Create our plots and get the resolved options *)
	{plots,mostlyResolvedOps}=If[MatchQ[resolvedPlotType,ListLinePlot],
		With[{plotOutputs=packetToELLP[packets2D,PlotAbsorbanceThermodynamics,ReplaceRule[listedOptions,Output->{Result,Options}]]},
			processELLPOutput[plotOutputs,SafeOptions[PlotAbsorbanceThermodynamics,ReplaceRule[listedOptions,Output->{Result,Options}]]]
		],
		{packetToELP3D[packets3D],options3DtoReturn}
	];

	(* Any special resolutions specific to your plot (which are not covered by underlying plot function) *)
	finalResolvedOps=ReplaceRule[safeOps,
		(* Any custom options which need special resolution *)
		Flatten[{
			PlotType->resolvedPlotType,
			Normal@KeyDrop[mostlyResolvedOps,Output]
		}],
		Append->False
	];

	(* Return our result based on outputSpecification *)
	outputSpecification/.{
		Result->plots,
		Preview->plots,
		Options->finalResolvedOps,
		Tests->{}
	}
];


(* ::Subsubsection:: *)
(*PlotAbsorbanceThermodynamics Helper Function*)


packetToELP3D[packets_]:=Module[
	{},
	(* Get the object IDs. *)
	objectIDs=Lookup[packets,Object];

	(* Get the curves. *)
	meltingCurves=Lookup[packets,MeltingCurve3D];
	coolingCurves=Lookup[packets,CoolingCurve3D];
	secondaryMeltingCurve=Lookup[packets,SecondaryMeltingCurve3D];
	secondaryCoolingCurve=Lookup[packets,SecondaryCoolingCurve3D];
	tertiaryMeltingCurve=Lookup[packets,TertiaryMeltingCurve3D];
	tertiaryCoolingCurve=Lookup[packets,TertiaryCoolingCurve3D];
	quaternaryMeltingCurve=Lookup[packets,QuaternaryMeltingCurve3D];
	quaternaryCoolingCurve=Lookup[packets,QuaternaryCoolingCurve3D];
	quinaryMeltingCurve=Lookup[packets,QuinaryMeltingCurve3D];
	quinaryCoolingCurve=Lookup[packets,QuinaryCoolingCurve3D];

	curves=Join[
		meltingCurves,
		coolingCurves,
		secondaryMeltingCurve,
		secondaryCoolingCurve,
		tertiaryMeltingCurve,
		tertiaryCoolingCurve,
		quaternaryMeltingCurve,
		quaternaryCoolingCurve,
		quinaryMeltingCurve,
		quinaryCoolingCurve
	];

	(* Create labels. *)
	(* If a curve is Null, don't create a label because we will filter out this curve. *)
	labels=Join[
		MapThread[
			Function[{curve,stringName},
				MapThread[
					(If[!MatchQ[#2,Null],
						ToString[#1]<>" "<>stringName,
						Nothing
					]&),
					{objectIDs,curve}
				]
			],
			{
				{meltingCurves,coolingCurves,secondaryMeltingCurve,secondaryCoolingCurve,tertiaryMeltingCurve,tertiaryCoolingCurve,quaternaryMeltingCurve,quaternaryCoolingCurve,quinaryMeltingCurve,quinaryCoolingCurve},
				{"Melting Curve","Cooling Curve","Secondary Melting Curve","Secondary Cooling Curve","Tertiary Melting Curve","Tertiary Cooling Curve","Quaternary Melting Curve","Quaternary Cooling Curve","Quinary Melting Curve","Quinary Cooling Curve"}
			}
		]
	];

	EmeraldListPlot3D[
		Join[
			meltingCurves,
			coolingCurves,
			secondaryMeltingCurve,
			secondaryCoolingCurve,
			tertiaryMeltingCurve,
			tertiaryCoolingCurve,
			quaternaryMeltingCurve,
			quaternaryCoolingCurve,
			quinaryMeltingCurve,
			quinaryCoolingCurve
		]/.{Null->Nothing},
		Mesh->None,
		ShowPoints->True,
		PlotLegends->Flatten[labels],
		PlotLabel->If[Length[objectIDs]==1,
			ToString[First[objectIDs]],
			"Melting Curve Data"
		]
	]
];
