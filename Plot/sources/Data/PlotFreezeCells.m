(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


Error::PlotFreezeCellsObjectNotFound="Specified object `1` cannot be found in the database. Please verify the objects' IDs or names.";
Error::PlotFreezeCellsNoAssociatedObject="Specified input `1` is not associated with a `2` object. Please verify the input object `1`, or associate it with a `2` object.";

DefineOptions[PlotFreezeCells,
	Options:>{
		OutputOption
	}
];

(* List overload *)
PlotFreezeCells[myInputs:{ObjectP[{Object[Protocol,FreezeCells],Object[Data,FreezeCells]}]..},myOptions:OptionsPattern[PlotFreezeCells]]:=PlotFreezeCells[#,myOptions]&/@myInputs;

(* Core Overload *)
PlotFreezeCells[myInput:ObjectP[{Object[Protocol,FreezeCells],Object[Data,FreezeCells]}],myOptions:OptionsPattern[PlotFreezeCells]]:=Module[
	{
		safeOps,outputSpecification,output,objectExistsQ,downloadFields,downloadedData,methods,expectedTemperatureData,measuredTemperatureData,rawPlots,tabbedPlots,previews
	},
	
	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotFreezeCells,ToList[myOptions]];
	
	(* Get the options *)
	outputSpecification=Lookup[safeOps,Output];
	output=ToList[outputSpecification];
	
	(* ---------- Initial Error Checks -----------*)
	
	(* ----- Check if the inputs are valid ----- *)
	
	(* Check if the input exists in the database *)
	objectExistsQ=DatabaseMemberQ[myInput];
	
	(* If object doesn't exist, return $Failed with an error *)
	If[
		!objectExistsQ,
		Module[{},
			Message[Error::PlotFreezeCellsObjectNotFound,myInput];
			Return[$Failed]
		]
	];
	
	(* ----- Check if the objects have an associated protocol/data object ----- *)
	
	(* Check the associated object *)
	Which[
		
		(* If object is protocol without associated data *)
		MatchQ[myInput,ObjectP[Object[Protocol,FreezeCells]]]&&MatchQ[Download[myInput,Data],{}],
		Module[{},
			Message[Error::PlotFreezeCellsNoAssociatedObject,myInput,"data"];
			Return[$Failed]
		],
		
		(* If object is protocol without associated data *)
		MatchQ[myInput,ObjectP[Object[Data,FreezeCells]]]&&!MatchQ[Download[myInput,Protocol],ObjectP[Object[Protocol,FreezeCells]]],
		Module[{},
			Message[Error::PlotFreezeCellsNoAssociatedObject,myInput,"protocol"];
			Return[$Failed]
		]
	];
	
	(* ---------- Download the Data ---------- *)
	
	(* Figure out what to download based on the input *)
	downloadFields=If[
		MatchQ[myInput,ObjectP[Object[Protocol,FreezeCells]]],
		{
			FreezingMethods,
			Data[ExpectedTemperatureData],
			Data[MeasuredTemperatureData]
		},
		{
			FreezingMethods,
			ExpectedTemperatureData,
			MeasuredTemperatureData
		}
	];
	
	(* Download the data *)
	downloadedData=Download[myInput,downloadFields];
	
	(* Split the downloaded data -- data gets an extra list if it was downloaded from a protocol so we have to split in this weird way here *)
	{
		methods,
		{expectedTemperatureData},
		{measuredTemperatureData}
	}=If[
		MatchQ[myInput,ObjectP[Object[Protocol,FreezeCells]]],
		downloadedData,
		{First[downloadedData],{downloadedData[[2]]},{Last[downloadedData]}}
	];
	
	(* ---------- Plot the Data ---------- *)
	
	(* Plot the data for controlled rate freezer batches -- insulated cooler batches generate no data so if we only have them, return Null *)
	rawPlots=If[
		MemberQ[methods,ControlledRateFreezer],
		MapThread[
			Function[
				{expectedData,measuredData},
				If[
					NullQ[measuredData],
					Null,
					EmeraldListLinePlot[
						{expectedData,measuredData},
						Legend->{"Expected Temperature","Measured Temperature"},
						Zoomable->True,
						LabelStyle->Directive[Bold,GrayLevel[0.3]]
					]
				]
			],
			{expectedTemperatureData,measuredTemperatureData}
		]
	];
	
	(* Put the requested data into tabs *)
	tabbedPlots=If[
		MemberQ[output,Result],
		TabView[
			MapThread[
				Function[
					{batchNumber,method,plot},
					"Batch "<>ToString[batchNumber]->Which[
						
						(* If we are doing an InsulatedCooler batch, say no data is recorded *)
						MatchQ[method,InsulatedCooler],"No data is recorded for InsulatedCooler batches.",
						
						(* If the plot is missing, say we don't have data -- this will happen for cases where we do not have measured data since we eliminated Null coming from InsulatedCooler batches above *)
						NullQ[plot],"No data available",
						
						(* Otherwise, put the plot in the tab *)
						True,plot
					]
				],
				{Range[Length[rawPlots]],methods,rawPlots}
			]
		]
	];
	
	(* If we are doing a preview, generate it *)
	previews=If[
		MemberQ[output,Preview],
		SlideView[
			Flatten[MapThread[
				Function[
					{method,plot},
					Which[
						
						(* If we are doing an InsulatedCooler batch, say no data is recorded *)
						MatchQ[method,InsulatedCooler],"No data is recorded for InsulatedCooler batches.",
						
						(* If the plot is missing, say we don't have data -- this will happen for cases where we do not have measured data since we eliminated Null coming from InsulatedCooler batches above *)
						NullQ[plot],"No data available",
						
						(* Otherwise, put the plot in the tab *)
						True,plot
					]
				],
				{methods,rawPlots}
			]
		]]
	];
	
	(* Return the result *)
	outputSpecification/.{
		Result->tabbedPlots,
		Options->{},
		Preview->previews,
		Tests->{}
	}
];