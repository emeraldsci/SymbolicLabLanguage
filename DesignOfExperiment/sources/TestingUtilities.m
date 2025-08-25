(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*Test Objective Functions*)


(* ::Subsubsection::Closed *)
(*Patterns*)


peakDataTypesP = (ObjectP[(Analysis`Private`peakDataTypes)] | {{_?NumericQ,_?NumericQ}..} | QuantityCoordinatesP[]);
peakProtocolsP = ObjectP[Analysis`Private`peakProtocolTypes];


(* ::Subsubsection:: *)
(*PeakObjectiveFunction*)


DefineOptions[PeakObjectiveFunction,
	Options :> {
		{
			OptionName -> Attribute,
			Default -> Area,
			AllowNull -> True,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:> ListableP[Alternatives[
				(* TODO: long term goal is to merge this with the fields of Object[Analysis,Peaks],
				 	 may change this to _Symbol, and add error handling within ObjFunc for bad symbols *)
					Area, Height, HalfHeightWidth, AdjacentResolution, Position
				]]
			],
			Description -> "The attribute (e.g. height, width, area) of a set of peaks in a 1-D dataset that is used as a primary input to construct the objective function."
		},
		{
			OptionName -> Method,
			Default -> Max,
			AllowNull -> True,
			Widget -> Widget[
				Type->Enumeration,
				Pattern:> Alternatives[
					Max, Min, Mean, HarmonicMean, GeometricMean, _Function
				]
			],
			Description -> "The method that is used to collapse the list of basis peak metrics into a scalar."
		},
		{
			OptionName -> SelectPeaks,
			Default -> {All, Area},
			AllowNull -> True,
			Widget -> {
				"Selection function" -> Widget[Type->Enumeration, Pattern:> Alternatives[Max, Min, All, _Function]],
				"Selection attribute" -> Widget[Type->Enumeration, Pattern:> Alternatives[Area, Height, Width, AdjacencyResolution]]
			},
			Description -> "The function and metric combination that determines the basis peak(s) for which we calculate the Metric."
		}
	}
];

(* overload for protocol inputs *)
(* TODO: make objective function reverse listable *)
PeakObjectiveFunction[protocol:peakProtocolsP, myOps:OptionsPattern[]]:=Module[
	{data},

	(* extract protocol data *)
	data = Download[protocol, Data];

	(* map data for now, eventually go to reverse listable paradigm *)
	PeakObjectiveFunction[#, myOps]& /@ data
];


(* ----------- *)
(*  main code  *)
(* ----------- *)
PeakObjectiveFunction[data:peakDataTypesP, myOps:OptionsPattern[]]:=Module[
	{
		safeOps, peakObject, peakPacket, selectedData, method, units, attributes,
		filteredAttributes, attributeUnits, finalUnits, numericEvaluation, listedUnits,
		thresholdOp
	},

	(* get the safe options *)
	safeOps = SafeOptions[PeakObjectiveFunction, ToList[myOps]];

	(* NOTE hardcoded AbsoluteThreshold below, this will likely need to be changed *)
	(* TODO: remember to change this hardcoded option when the time is right *)
	thresholdOp = {0.2};

	(* Call AnalyzePeaks and upload so that we can access computable fields *)
	(* computable fields are necessary to handle units *)
	(* TODO: Make sure that companion functions delete any uploaded objects during their evaluation *)
	(* TODO: think of a way to connect this peaks object to the objective function *)

	(*Hardcode the reference field since the peaks resovler does not work with the SimulateHPLC test objects*)
	peakObject = AnalyzePeaks[data, ReferenceField->Automatic];

	(* Download peak packet to resolve computable fields *)
	peakPacket = Download[peakObject];

	(* get the attribute units *)
	units = Lookup[peakPacket, PeakUnits];
	attributes = Lookup[safeOps, Attribute];

	(* TODO: figure out a way to make this work because some units are not there *)
	filteredAttributes = attributes /. {(AdjacentResolution | HalfHeightWidth)->Width};
	attributeUnits = filteredAttributes /. units;

	(* if attributeUnits is a list, apply the custom function to it, to find the final units *)
	method = Lookup[safeOps, Method];
	finalUnits = If[MatchQ[attributeUnits,_List],
		(* wrap list around the unit elements to match with the expected method function behavior *)
		listedUnits = List /@ attributeUnits;
		Units[method[Sequence@@listedUnits]],
		attributeUnits
	];

	(* select the appropriate peak data from options *)
	selectedData = selectPeakData[peakPacket, safeOps];

	(* selectedData can be a list or a list of lists, and should be matched to appropriate method *)
	(* if it's a list of lists, then the selectedData needs to be input to the method function as a sequence of lists *)
	numericEvaluation = If[MatchQ[selectedData,{{_?NumericQ..}..}],
	(*TRUE: call method on a sequence of selected data *)
		method[Sequence@@selectedData],
	(*ELSE: simply call method on selected data *)
		method[selectedData]
	];

	(* return a quantity version of the evaluation *)
	(* TODO: for now, return ArbitraryUnits if there are no units *)
	Quantity[numericEvaluation, finalUnits]
];


(* helper that creates a selection function that takes a Peaks packet and a primary attribute *)
selectPeakData[packet_Association, myOptions_List]:=Module[
	{
		selectionFunction, selectionAttribute, primaryAttribute, selectionList
	},

	(* get the select peaks option, and split into function and attribute *)
	{selectionFunction, selectionAttribute} = Lookup[myOptions, SelectPeaks];

	(* get the primary attribute from the options *)
	primaryAttribute = Lookup[myOptions, Attribute];

	(* If All is selected, then there is no criteria to select from, simply return a function that looks up the attribute *)
	If[MatchQ[selectionFunction,All],
		Return[Lookup[packet, primaryAttribute]]
	];

	(* create a selection list *)
	selectionList = Lookup[packet, selectionAttribute];

	(* use this function to pick the primary peak attributes based on the select function *)
	If[MatchQ[selectionFunction,_Function],
		(* if function is a pure function, just select on selectionFunction mapped
			 over the list, which gives a list of booleans *)
		PickList[Lookup[packet, primaryAttribute], selectionFunction /@ selectionList],
		(* else the function is either max or min, so apply it the selection list *)
		PickList[Lookup[packet, primaryAttribute], selectionList, selectionFunction[selectionList]]
	]
];


(* ::Subsubsection:: *)
(*AreaOfTallestPeak*)

(* Overload to take in a protocol and map over data objects *)
AreaOfTallestPeak[protocolObject:peakProtocolsP]:= AreaOfTallestPeak/@protocolObject[Data];

(* Main function to process one data object *)
AreaOfTallestPeak[dataObject:peakDataTypesP]:=Module[
	{},

	(* use objective function syntax to extract this quantity *)
	PeakObjectiveFunction[dataObject, Attribute->Area, SelectPeaks->{Max,Height}]
];


(* ::Subsubsection:: *)
(*HarmonicMeanPeakSeparation*)

(* Overload to take in a protocol and map over data objects *)
MeanPeakSeparation[protocolObject:peakProtocolsP]:= MeanPeakSeparation/@protocolObject[Data];

MeanPeakSeparation[dataObject:peakDataTypesP]:=Module[
	{separationFunction},

	(* use objective function syntax to extract *)
	separationFunction = Function[{positions},
		peakSeparationHelper[positions]
	];

	(* use obj function syntax call to return this function *)
	PeakObjectiveFunction[dataObject, Attribute->Position, Method->separationFunction]
];


(* helper to return separation values for data-sets with fewer than 2 peaks *)
peakSeparationHelper[positions:({} | {_?NumericQ})]:=0.;
peakSeparationHelper[positions_]:=HarmonicMean[Differences[positions]];


(* ::Subsubsection:: *)
(*PeakHeightWidthRatio*)

(* Overload to take in a protocol and map over data objects *)
MeanPeakHeightWidthRatio[protocolObject:peakProtocolsP]:= MeanPeakHeightWidthRatio/@protocolObject[Data];

MeanPeakHeightWidthRatio[dataObject:peakDataTypesP]:=Module[
	{heightWidthRatioFcn},

	(* make a custom height width ratio function *)
	heightWidthRatioFcn = Function[{height, width}, Mean[height/width]];

	(* use PeakObjectiveFunction options to resolve the mean of the height-width ratio for all peaks *)
	PeakObjectiveFunction[dataObject, Attribute->{Height, HalfHeightWidth}, Method->heightWidthRatioFcn]

];


(* ::Subsubsection:: *)
(*ResolutionOfTallestPeak*)

(* Overload to take in a protocol and map over data objects *)
ResolutionOfTallestPeak[protocolObject:peakProtocolsP]:= ResolutionOfTallestPeak/@protocolObject[Data];

ResolutionOfTallestPeak[dataObject:peakDataTypesP]:=Module[
	{},

	(* use objective function syntax to retrieve this information *)
	PeakObjectiveFunction[dataObject, Attribute->AdjacentResolution, SelectPeaks->{Max,Height}]
];



DefineOptions[SimulateGaussian,
Options:>{
	{
		OptionName->Parameter1,
		Default->4,
		AllowNull->False,
		Description->"First parameter used by SimulateGaussian to generate simulated chromatography data for DOE testing.",
		Widget->Widget[Type->Number,Pattern:>GreaterP[0]],
		Category->"General Information"
	},
	{
		OptionName->Parameter2,
		Default->2,
		AllowNull->False,
		Description->"Second parameter used by SimulateGaussian to generate simulated chromatography for DOE testing.",
		Widget->Widget[Type->Enumeration,Pattern:>Alternatives@@Range[0,4]],
		Category->"General Information"
	},
	{
		OptionName->Parameter3,
		Default->5,
		AllowNull->False,
		Description->"Third parameter used by MaxPeakHeight to modify height of simulated chromatography peak for DOE testing.",
		Widget->Widget[Type->Number,Pattern:>GreaterP[0]],
		Category->"General Information"
	},
	{
		OptionName->Gradient,
		Default->{{0 Minute, 10 Percent}, {10 Minute, 50 Percent}},
		AllowNull->False,
		Description->"Mock gradient to test that DesignOfExperiment can handle 2-D arrays as variable inputs.",
		Widget->Adder[
			{
				"Time" -> Widget[Type->Quantity, Pattern:>GreaterEqualP[0 Minute], Units->Minute],
				"Percent" -> Widget[Type->Quantity, Pattern:>RangeP[0 Percent, 100 Percent], Units->Percent]
			}
		],
		Category->"General Information"
	}
}];

(* Function to generate simulated chromatography data for DOE testing *)
SimulateGaussian[samples_, myOps:OptionsPattern[]]:=Module[
{safeOps, p1, p2, xy, chromData, prot,p1spec,p2spec,xmin,xmax,dx},
	p1spec={1,6};
	p2spec={0,4};
{xmin,xmax,dx} = {0,10,.1};
	safeOps = SafeOptions[SimulateGaussian,ToList[myOps]];
	{p1,p2} = Lookup[safeOps, {Parameter1,Parameter2}];

	xy = QuantityArray[
		With[{pvec={p1-Mean[p1spec], p2-Mean[p2spec]}},
			Table[{x,Exp[.1*pvec.{{-1,.4},{.2,-1}}.pvec]*Exp[-(x-5-p1/4+p2/3)^2]},{x,xmin,xmax,dx}]
		],
		{Minute,AbsorbanceUnit}
	];

	chromData = Upload[<|Type->Object[Data,Chromatography],Absorbance->xy|>];

	prot = Upload[<|
		Type->Object[Protocol],
		Status->Null,
		Append[Data]->{Link[chromData,Protocol]},
		ResolvedOptions->safeOps,
		UnresolvedOptions -> ToList[myOps]
	|>];

	prot

];

DefineOptions[DesignOfExperiment`Private`SimulateHPLC,
	Options:>{
		{
			OptionName->ColumnTemperature,
			Default->30*Celsius,
			AllowNull->False,
			Description->"Temperature parameter used by DesignOfExperiment`Private`SimulateHPLC to generate simulated chromatography data for DOE testing.",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[
				30 Celsius,
				40 Celsius,
				50 Celsius
			]],
			Category->"General Information"
		},
		{
			OptionName->FlowRate,
			Default->1*Milliliter/Minute,
			AllowNull->False,
			Description->"Flow rate parameter used by DesignOfExperiment`Private`SimulateHPLC to generate simulated chromatography for DOE testing.",
			Widget->Widget[Type->Enumeration,Pattern:>Alternatives[
				0.1 Milli Liter/Minute,
				0.2 Milli Liter/Minute,
				0.3 Milli Liter/Minute,
				0.4 Milli Liter/Minute,
				0.5 Milli Liter/Minute,
				1 Milli Liter/Minute,
				2 Milli Liter/Minute,
				5 Milli Liter/Minute
			]],
			Category->"General Information"
		},
		{
          OptionName -> InjectionVolume,
          Default -> Automatic,
          Description -> "The physical quantity of sample loaded into the flow path for measurement and/or collection.",
          ResolutionDescription -> "If not user set, 10 uL for Analytical measurement or 500 uL for Preparative measurement.",
          AllowNull -> False,
          Widget -> Widget[
            Type -> Quantity,
            Pattern :> RangeP[0 Microliter, 500 Microliter],
            Units -> Microliter
          ],
          Category->"Sample Parameters"
        },
		{
          OptionName -> GradientA,
          Default -> Automatic,
          Description -> "The composition of BufferA within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
          ResolutionDescription -> "Automatically set from the Gradient option or implicitly resolved from the GradientB, GradientC, and GradientD options.",
          AllowNull -> False,
          Category -> "Gradient",
          Widget -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0 Percent, 100 Percent],
              Units -> Percent
            ],
            Adder[
              {
                "Time" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Minute],
                  Units -> {Minute,{Second,Minute}}
                ],
                "Buffer A Composition" -> Widget[
                  Type -> Quantity,
                  Pattern :> RangeP[0 Percent, 100 Percent],
                  Units -> Percent
                ]
              },
              Orientation->Vertical
            ]
          ]
        },
        {
          OptionName -> GradientB,
          Default -> Automatic,
          Description -> "The composition of BufferB within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
          ResolutionDescription -> "Automatically set from the Gradient option or implicitly resolved from the GradientA, GradientC, and GradientD options. If no other gradient options are specified, a BufferB gradient of 10% to 100% over 45 minutes is used.",
          AllowNull -> False,
          Category -> "Gradient",
          Widget -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0 Percent, 100 Percent],
              Units -> Percent
            ],
            Adder[
              {
                "Time" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Minute],
                  Units -> {Minute,{Second,Minute}}
                ],
                "Buffer B Composition" -> Widget[
                  Type -> Quantity,
                  Pattern :> RangeP[0 Percent, 100 Percent],
                  Units -> Percent
                ]
              },
              Orientation->Vertical
            ]
          ]
        },
        {
          OptionName -> GradientC,
          Default -> Automatic,
          Description -> "The composition of BufferC within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
          ResolutionDescription -> "Automatically set from the Gradient option or implicitly resolved from the GradientA, GradientB, and GradientD options.",
          AllowNull -> False,
          Category -> "Gradient",
          Widget -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0 Percent, 100 Percent],
              Units -> Percent
            ],
            Adder[
              {
                "Time" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Minute],
                  Units -> {Minute,{Second,Minute}}
                ],
                "Buffer C Composition" -> Widget[
                  Type -> Quantity,
                  Pattern :> RangeP[0 Percent, 100 Percent],
                  Units -> Percent
                ]
              },
              Orientation->Vertical
            ]
          ]
        },
        {
          OptionName -> GradientD,
          Default -> Automatic,
          Description -> "The composition of BufferD within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
          ResolutionDescription -> "If the specified instrument supports BufferD, automatically resolved from the Gradient option or implicitly resolved from the GradientA, GradientB, and GradientC options.",
          AllowNull -> True,
          Category -> "Gradient",
          Widget -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0 Percent, 100 Percent],
              Units -> Percent
            ],
            Adder[
              {
                "Time" -> Widget[
                  Type -> Quantity,
                  Pattern :> GreaterEqualP[0 Minute],
                  Units -> {Minute,{Second,Minute}}
                ],
                "Buffer D Composition" -> Widget[
                  Type -> Quantity,
                  Pattern :> RangeP[0 Percent, 100 Percent],
                  Units -> Percent
                ]
              },
              Orientation->Vertical
            ]
          ]
        }
}];

SimulateHPLC[samples_, myOps:OptionsPattern[]]:=Module[
	{safeOps, columnTemperature, flowRates, datachromData, prot},
	(*Pull out column temperature and flow rate options*)
	safeOps = SafeOptions[DesignOfExperiment`Private`SimulateHPLC,ToList[myOps]];
	{columnTemperature,flowRates} = Lookup[safeOps, {ColumnTemperature,FlowRate}];

	(*Create data based on the given options*)
	data=DesignOfExperiment`Private`SimulateHPLCData[columnTemperature, flowRates];

	(*upload chromatography data*)
	chromData = Upload[<|
		Type->Object[Data,Chromatography],
		Replace[ColumnTemperature]->data[ColumnTemperature],
		Replace[FlowRates]->{data[FlowRates]},
		Absorbance->data[Absorbance],
		AbsorbanceWavelength->260 Nanometer,
		DeveloperObject->True
	|>];

	(*create a protocol*)
	prot = Upload[<|
		Type->Object[Protocol, HPLC],
		Status->Null,
		Append[Data]->{Link[chromData,Protocol]},
		ResolvedOptions->safeOps,
		UnresolvedOptions -> ToList[myOps],
		DeveloperObject->True
	|>];

	prot

];
