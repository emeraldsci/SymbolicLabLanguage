(* ::Package:: *)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotCrossFlowFiltration *)


DefineOptions[PlotCrossFlowFiltration,
	Options:>{
		{
			OptionName->PlottedMeasurementTypes,
			Default->Automatic,
			AllowNull->False,
			Widget->With[
				{insertMe=CrossFlowPlotTypeP},
				Widget[
					Type->MultiSelect,
					Pattern:>DuplicateFreeListableP[insertMe|Absorbance]
				]
			],
			Description->"Select the types of data to be plotted.",
			Category->"General"
		},
		OutputOption,
		CacheOption
	}
];


(* Messages *)
Error::PlotCrossFlowObjectNotFound="Specified object `1` cannot be found in the database. Please verify the objects' IDs or names.";
Error::PlotCrossFlowNoAssociatedObject="Specified input `1` is not associated with a data object. Please verify the input object `1`, or associate it with a data object.";

(* listable - which is mapping on objects because each is a separate experiment *)
PlotCrossFlowFiltration[myInputs:{ObjectP[{Object[Protocol,CrossFlowFiltration],Object[Data,CrossFlowFiltration]}]..},myOptions:OptionsPattern[PlotCrossFlowFiltration]]:=Map[
	Function[input,
		PlotCrossFlowFiltration[input,myOptions]
	], myInputs
];

PlotCrossFlowFiltration[myInput:ObjectP[{Object[Protocol,CrossFlowFiltration]}],myOptions:OptionsPattern[PlotCrossFlowFiltration]]:=Module[
	{dataObjs,dataPackets,optionWithCache, safeOps, cache, cacheBall},

	(* Get the safe options *)
	safeOps=SafeOptions[PlotCrossFlowFiltration,ToList[myOptions]];

	(* Retrieve cache from the options *)
	cache=Lookup[safeOps,Cache];

	(* If object doesn't exist, return $Failed with an error *)
	If[
		!DatabaseMemberQ[myInput],
		Module[{},
			Message[Error::PlotCrossFlowObjectNotFound,myInput];
			Return[$Failed]
		]
	];

	(* Download a list of data and all information in that data packet *)
	{dataObjs, dataPackets}=Download[
		myInput,
		{
			Data[Object],
			Packet[Data[All]]
		},
		Cache->cache
	];
	(* Check if the input protocol has an associated data object *)
	If[
		Length[dataObjs]==0,
		Module[{},
			Message[Error::PlotCrossFlowNoAssociatedObject,myInput,"data"];
			Return[$Failed]
		]
	];

	(* Combined download cache with new cache pass it to every function *)
	cacheBall= Experiment`Private`FlattenCachePackets[{dataPackets,cache}];

	(* Replace the option with new cache *)
	optionWithCache= ReplaceRule[ToList[myOptions],{Cache->ToList[cacheBall]}];

	If[
		Length[dataObjs]==1,
		PlotCrossFlowFiltration[First[dataObjs],optionWithCache],
		Map[
			Function[data,
				PlotCrossFlowFiltration[data,optionWithCache]
			],
			dataObjs
		]
	]
];

PlotCrossFlowFiltration[myInput:ObjectP[{Object[Data,CrossFlowFiltration]}],myOptions:OptionsPattern[PlotCrossFlowFiltration]]:=Module[
	{
		safeOps,output,initialPlottedMeasurementTypes,objectExistsQ,plotTypes,resolvedPlottedMeasurementTypes,
		downloadFields,downloadedData,absorbanceChannel,absorbanceWavelength,inletPressureData,retentatePressureData,
		permeatePressureData,transmembranePressureData,retentateWeightData,permeateWeightData,primaryPumpFlowRateData,
		secondaryPumpFlowRateData,retentateConductivityData,permeateConductivityData,temperatureData,
		permeateAbsorbanceData,retentateAbsorbanceData,filtrationMode,numberOfSteps,pressurePlots,weightPlots,
		flowRatePlots,conductivityPlots,temperaturePlots,absorbancePlots,singleWavelengthQ,paddedRetentateAbsorbanceData,
		paddedPermeateAbsorbanceData,combinedPlots,previews,finalResult,instrumentModel,uPulseQ,diafiltrationWeightData,
		resolvedOptions,cache
	},
	
	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotCrossFlowFiltration,ToList[myOptions]];
	
	(* Get the options *)
	output=ToList[Lookup[safeOps,Output]];
	cache=Lookup[safeOps,Cache];

	initialPlottedMeasurementTypes=ToList[Lookup[safeOps,PlottedMeasurementTypes]];
	
	(* ---------- Initial Error Checks -----------*)
	
	(* ----- Check if the inputs are valid ----- *)
	
	(* Check if the input exists in the database *)
	objectExistsQ=DatabaseMemberQ[myInput];
	
	(* If object doesn't exist, return $Failed with an error *)
	If[
		!objectExistsQ,
		Module[{},
			Message[Error::PlotCrossFlowObjectNotFound,myInput];
			Return[$Failed]
		]
	];
	


	(* ---------- Download the Data ---------- *)

	(* Figure out what to download based on the input *)
	downloadFields={
		(*1*)Protocol[AbsorbanceChannel],
		(*2*)Protocol[AbsorbanceWavelength],
		(*3*)InletPressureData,
		(*4*)RetentatePressureData,
		(*5*)PermeatePressureData,
		(*6*)TransmembranePressureData,
		(*7*)RetentateWeightData,
		(*8*)DiafiltrationWeightData,
		(*9*)PermeateWeightData,
		(*10*)PrimaryPumpFlowRateData,
		(*11*)SecondaryPumpFlowRateData,
		(*12*)RetentateConductivityData,
		(*13*)PermeateConductivityData,
		(*14*)TemperatureData,
		(*15*)PermeateAbsorbanceData,
		(*16*)RetentateAbsorbanceData,
		(*17*)FiltrationMode,
		(*18*)Instrument[Model][Object]
	};

	(* Download the data *)
	downloadedData=Download[myInput,downloadFields,Cache->cache];

	(* Split the downloaded data -- data has different listiness depending on how it was downloaded so we have to have this janky splitting here *)
	{
		(*1*)absorbanceChannel,
		(*2*)absorbanceWavelength,
		(*3*)inletPressureData,
		(*4*)retentatePressureData,
		(*5*)permeatePressureData,
		(*6*)transmembranePressureData,
		(*7*)retentateWeightData,
		(*8*)diafiltrationWeightData,
		(*9*)permeateWeightData,
		(*10*)primaryPumpFlowRateData,
		(*11*)secondaryPumpFlowRateData,
		(*12*)retentateConductivityData,
		(*13*)permeateConductivityData,
		(*14*)temperatureData,
		(*15*)permeateAbsorbanceData,
		(*16*)retentateAbsorbanceData,
		(*17*)filtrationMode,
		(*18*)instrumentModel
	}=downloadedData;


	(* build a boolean to indicate which instrument we are using *)
	uPulseQ = MatchQ[instrumentModel, ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]]];

	(* Find the number of steps we have - which is always 1, but keep it as is so its compatible with old data *)
	numberOfSteps=Max[Length/@{inletPressureData,retentatePressureData,permeatePressureData,transmembranePressureData,retentateWeightData,permeateWeightData,primaryPumpFlowRateData,secondaryPumpFlowRateData,retentateConductivityData,permeateConductivityData,temperatureData,permeateAbsorbanceData,retentateAbsorbanceData, filtrationMode}];

	(* ---------- Resolve Options ---------- *)
	
	(* Make a list of plot types we have *)
	plotTypes={Conductivity, Weight, Pressure, Temperature, FlowRate, Absorbance};

	(* Resolve the plotted measurement types option *)
	resolvedPlottedMeasurementTypes=Which[
		(* Use user specified values *)
		MatchQ[initialPlottedMeasurementTypes,Except[Automatic|{Automatic}]],
		initialPlottedMeasurementTypes,

		(* If uPulse only use weight and pressure as the output data *)
		uPulseQ,
		{Weight, Pressure},

		(* Catch all for all data types *)
		True,
		List@@CrossFlowPlotTypeP
	];

	(* Build the list of resolved options *)
	resolvedOptions =ReplaceRule[safeOps,{PlottedMeasurementTypes->resolvedPlottedMeasurementTypes}];

	(* If output is just options or tests, return now *)
	If[
		Not[Or @@ (MemberQ[output, #] & /@ {Result, Preview})],
		Return[
			ReplaceAll[
				output,
				{
					Options -> resolvedOptions,
					Tests -> {}
				}
			]
		]
	];

	(* ---------- Generate Plots ---------- *)
	(* If we have the pressure data, and we are asked to plot it, do so; otherwise, skip the graph *)
	pressurePlots=If[
		Or[!MemberQ[resolvedPlottedMeasurementTypes,Pressure],AnyTrue[{inletPressureData,retentatePressureData,permeatePressureData,transmembranePressureData},MatchQ[#,{}]&]],
		ConstantArray[Null,numberOfSteps],
		MapThread[
			Function[
				{inletPressure,retentatePressure,permeatePressure,transmembranePressure},
				If[
					NullQ[{inletPressure,retentatePressure,permeatePressure,transmembranePressure}],
					Null,
					EmeraldListLinePlot[
						{inletPressure,retentatePressure,permeatePressure,transmembranePressure},
						Legend->{"Inlet","Retentate","Permeate","Transmembrane Pressure"},
						Zoomable->True,
						PlotRange->{Automatic,{0,Automatic}},
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{inletPressureData,retentatePressureData,permeatePressureData,transmembranePressureData}
		]
	];

	(* If we have the weight data, and we are asked to plot it, do so; otherwise, skip the graph *)
	weightPlots=Which[
		And[
			MemberQ[resolvedPlottedMeasurementTypes,Weight],
			Not[AnyTrue[{retentateWeightData,diafiltrationWeightData},MatchQ[#,{}]&]],
			uPulseQ
		],
		MapThread[
			Function[
				{retentateWeight,diafiltrationWeight},
				If[
					NullQ[{retentateWeight,diafiltrationWeight}],
					Null,
					EmeraldListLinePlot[
						{retentateWeight,diafiltrationWeight},
						Legend->{"Retentate","Diafiltration"},
						Zoomable->True,
						PlotRange->{Automatic,{0,Automatic}},
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{retentateWeightData,diafiltrationWeightData}
		],
		And[
			MemberQ[resolvedPlottedMeasurementTypes,Weight],
			Not[AnyTrue[{retentateWeightData,permeateWeightData},MatchQ[#,{}]&]]
		],
		MapThread[
			Function[
				{retentateWeight,permeateWeight},
				If[
					NullQ[{retentateWeight,permeateWeight}],
					Null,
					EmeraldListLinePlot[
						{retentateWeight,permeateWeight},
						Legend->{"Retentate","Permeate"},
						Zoomable->True,
						PlotRange->{Automatic,{0,Automatic}},
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{retentateWeightData,permeateWeightData}
		],

		(* catch all just for Nulls *)
		True,
		ConstantArray[Null,numberOfSteps]
	];

	(* If we have the flow rate data, and we are asked to plot it, do so; otherwise, skip the graph *)
	flowRatePlots=If[
		Or[!MemberQ[resolvedPlottedMeasurementTypes,FlowRate],AnyTrue[{primaryPumpFlowRateData,secondaryPumpFlowRateData},MatchQ[#,{}]&]],
		ConstantArray[Null,numberOfSteps],
		MapThread[
			Function[
				{primaryPumpFlowRate,secondaryPumpFlowRate},
				If[
					NullQ[{primaryPumpFlowRate,secondaryPumpFlowRate}],
					Null,
					EmeraldListLinePlot[
						{primaryPumpFlowRate,secondaryPumpFlowRate},
						Legend->{"Primary Pump","Secondary Pump"},
						Zoomable->True,
						PlotRange->{Automatic,{0,Automatic}},
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{primaryPumpFlowRateData,secondaryPumpFlowRateData}
		]
	];
	
	(* If we have the conductivity data, and we are asked to plot it, do so; otherwise, skip the graph *)
	conductivityPlots=If[
		Or[!MemberQ[resolvedPlottedMeasurementTypes,Conductivity],AnyTrue[{retentateConductivityData,permeateConductivityData},MatchQ[#,{}]&]],
		ConstantArray[Null,numberOfSteps],
		MapThread[
			Function[
				{retentateConductivity,permeateConductivity},
				If[
					NullQ[{retentateConductivity,permeateConductivity}],
					Null,
					EmeraldListLinePlot[
						{retentateConductivity,permeateConductivity},
						Legend->{"Retentate","Permeate"},
						Zoomable->True,
						PlotRange->{Automatic,{0,Automatic}},
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{retentateConductivityData,permeateConductivityData}
		]
	];
	
	(* If we have the temperature data, and we are asked to plot it, do so; otherwise, skip the graph *)
	temperaturePlots=If[
		Or[!MemberQ[resolvedPlottedMeasurementTypes,Temperature],MatchQ[temperatureData,{}]],
		ConstantArray[Null,numberOfSteps],
		If[
			NullQ[#],
			Null,
			EmeraldListLinePlot[
				#,
				Zoomable->True,
				PlotRange->{Automatic,{0,Automatic}},
				LabelStyle->Directive[Bold,GrayLevel[0.3]]
			]
		]&/@temperatureData
	];
	
	(* Find out if we recorded a single wavelength or a range *)
	singleWavelengthQ=MatchQ[absorbanceWavelength,RangeP[190 Nanometer,800 Nanometer]];
	
	(* Pad the absorbance data so that they are all the right length for the mapthread below *)
	{paddedRetentateAbsorbanceData,paddedPermeateAbsorbanceData}=If[
		MatchQ[absorbanceChannel,Retentate],
		{
			retentateAbsorbanceData,
			PadRight[permeateAbsorbanceData,Length[retentateAbsorbanceData]]
		},
		{
			PadRight[retentateAbsorbanceData,Length[permeateAbsorbanceData]],
			permeateAbsorbanceData
		}
	];
	
	(* If we have the absorbance data, and we are asked to plot it, do so; otherwise, skip the graph *)
	absorbancePlots=If[
		Or[!MemberQ[resolvedPlottedMeasurementTypes,Absorbance],MatchQ[{paddedRetentateAbsorbanceData,paddedPermeateAbsorbanceData},{{},{}}]],
		ConstantArray[Null,numberOfSteps],
		MapThread[
			Function[
				{retentateAbsorbance,permeateAbsorbance},
				Which[
					
					(* If we have no data, skip the plotting *)
					MatchQ[absorbanceChannel,Retentate]&&NullQ[retentateAbsorbance],Null,
					MatchQ[absorbanceChannel,Permeate]&&NullQ[permeateAbsorbance],Null,
					
					(* If data exists, plot it *)
					True,Module[{absorbanceData},
						
						(* Clean up the data -- since the wavelength is constant in single wavelength data, we need to remove wavelength from it. For wavelength ranges, the data contains a list of wavelength scans for each time point, so we need to flatten it into a list of triplets. We are doing this in a peculiar way because some functions will sneakily convert the quantity array to a list of quantities. The list of quantities take forever to plot so we can only use functions that preserve the quantity array at the end *)
						absorbanceData=Switch[{singleWavelengthQ,absorbanceChannel},
							
							(* If we recorded a single wavelength, remove the wavelength from the list *)
							{True,Retentate},Transpose[Drop[Transpose[retentateAbsorbance],{2}]],
							{True,Permeate},Transpose[Drop[Transpose[permeateAbsorbance],{2}]],
							
							(* If we recorded a multiple wavelengths, return the data with the right listiness *)
							{False,Retentate},Apply[Join,retentateAbsorbance],
							{False,Permeate},Apply[Join,permeateAbsorbance]
						];
						
						(* If single wavelength, plot the data over time; otherwise, plot a 3D version with time and absorbance -- we are also skipping data for any steps that are missing data *)
						If[
							singleWavelengthQ,
							EmeraldListLinePlot[
								absorbanceData,
								Legend->If[
									MatchQ[absorbanceChannel,Retentate],
									{"Retentate"},
									{"Permeate"}
								],
								Zoomable->True,
								PlotRange->{Automatic,{0,Automatic}},
								LabelStyle->Directive[Bold,GrayLevel[0.3]]
							],
							Zoomable[EmeraldListPlot3D[
								Unitless[absorbanceData],
								PlotRange->{Automatic,Automatic,{0,Automatic}},
								AxesLabel->{"Time (Min.)","Wavelength (nm)","Absorbance (AU)"},
								LabelStyle->Directive[Bold,GrayLevel[0.3]]
							]]
						]
					]
				]
			],
			{paddedRetentateAbsorbanceData,paddedPermeateAbsorbanceData}
		]
	];


	(* Put the requested data into tabs *)
	combinedPlots=If[
		MemberQ[output,Result],
		TabView[
			MapThread[
				Function[
					{mode,absorbancePlot,conductivityPlot,weightPlot,pressurePlot,temperaturePlot,flowRatePlot},


					With[{(* Build a replacement rule for plot types and plots that we have generated *)
						plotTypeRule = Rule@@@Transpose[
							{
								{Conductivity, Weight, Pressure, Temperature, FlowRate, Absorbance},
								{conductivityPlot,weightPlot,pressurePlot,temperaturePlot,flowRatePlot,absorbancePlot}
							}
						]},

						ToString[mode]->TabView[
							Map[
								Function[
									plotType,
									With[
										{plot = Lookup[plotTypeRule, plotType]},
										If[
											(* If the plot is missing, say we don't have data *)
											NullQ[plot],
											ToString[plotType]->"No data available",

											(* Otherwise, put the plot into the output as a tab *)
											ToString[plotType]->Column[{Style[ToString[Download[myInput,Object]]<>" ("<>ToString[plotType]<>")",Directive[Bold,GrayLevel[0.3]]],plot},Alignment->Center]

										]
									]
								],
								resolvedPlottedMeasurementTypes
							]
						]

					]
				],
				{ToList[filtrationMode],absorbancePlots,conductivityPlots,weightPlots,pressurePlots,temperaturePlots,flowRatePlots}
			]
		]
	];
	
	(* If we are doing a preview, generate it *)
	previews=If[
		MemberQ[output,Preview],
		Module[{allPlots},
			
			(* Prepare all the plots we are asked to make *)
			allPlots=resolvedPlottedMeasurementTypes/.Thread[plotTypes->{absorbancePlots,conductivityPlots,weightPlots,pressurePlots,temperaturePlots,flowRatePlots}];
			
			(* Put all the plots into slides *)
			SlideView[
				Flatten[MapThread[
					Function[
						{plots},
						MapThread[
							Function[
								{plotType,plot},
								If[
									NullQ[plot],
									Nothing,
									Column[{Style[ToString[Download[myInput,Object]]<>" ("<>ToString[plotType]<>")",Directive[Bold,GrayLevel[0.3]]],plot},Alignment->Center]
								]
							],
							{resolvedPlottedMeasurementTypes,plots}
						]
					],
					{Transpose[allPlots]}
				]]
			]
		]
	];
	
	(* Prepare our final result *)
	finalResult=output/.{
		Result->combinedPlots,
		Options->resolvedOptions,
		Preview->previews,
		Tests->{}
	};

	(* Return the result *)
	If[
		Length[finalResult]==1,
		First[finalResult],
		finalResult
	]
];