(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(*Define function options*)
DefineOptions[AnalyzeDynamicLightScatteringLoading,
    Options :> {
        {
            OptionName -> TimeThreshold,
            Default -> 3 Microsecond,
            Description -> "The point in time before which the average correlation data must exceed the CorrelationThreshold for the sample to be considered properly loaded into the capillary.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[0 Microsecond], Units -> Alternatives[Microsecond|Millisecond|Second]]
        },
        {
            OptionName -> CorrelationThreshold,
            Default -> 0.8,
            Description -> "The value that the average correlation data must exceed before the TimeThreshold for the sample to be considered properly loaded into the capillary.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterP[0]]
        },
        {
            OptionName -> CorrelationMaximum,
            Default -> 1.05,
            Description -> "The value that the average correlation data must be less than before the TimeThreshold for the sample to be considered properly loaded into the capillary.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Widget[Type->Number,Pattern:>GreaterP[0]]
        },
		{
            OptionName -> Include,
            Default -> {},
            Description ->  "The data objects to include as properly loaded that override heuristically excluded data objects.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Alternatives[
                Adder[Widget[Type -> Object, Pattern :> ObjectP[{Object[Data, DynamicLightScattering],Object[Data, MeltingCurve]}], ObjectTypes->{Object[Data, DynamicLightScattering],Object[Data, MeltingCurve]}]],
                Widget[Type->Enumeration, Pattern:>Alternatives[{}]]
            ]
        },
		{
            OptionName -> Exclude,
            Default -> {},
            Description -> "The data objects to exclude as properly loaded that override heuristically selected data objects.",
            AllowNull -> False,
            Category -> "General",
            Widget -> Alternatives[
                Adder[Widget[Type -> Object , Pattern :> ObjectP[{Object[Data, DynamicLightScattering],Object[Data, MeltingCurve]}], ObjectTypes->{Object[Data, DynamicLightScattering],Object[Data, MeltingCurve]}]],
                Widget[Type->Enumeration, Pattern:>Alternatives[{}]]
            ]
        },
        {
            OptionName -> CorrelationTemperature,
            Default -> Automatic,
            Description -> "For ThermalShift Protocols, the correlation curve field used to evaluate the loaded samples.",
            AllowNull -> True,
            Category -> "General",
            Widget -> Widget[Type->Enumeration,Pattern:>Alternatives[Initial|Final]]
        },
        OutputOption,
        UploadOption
    }
];


(*Warnings and errors*)
Warning::AbsentIncludeExclude = "The following Data[Objects] that you attempted to Include or Exclude are not present in the object: `1`.";
Warning::RemovedData = "Non-numeric data was found and removed from the correlation curves for analysis, but the data objects themselves remains unaffected.";
Error::SameIncludeExclude = "You cannot include and exclude the same object: `1`.";
Error::MissingCorrelationThermalShift = "No dynamic light scattering correlation curve detected. For Object[Protocol, ThermalShift], the Object[Data, MeltingCurve] is expected to have an InitialCorrelationCurve of FinalCorrelationCurve field.";
Error::MissingCorrelationDynamicLightScattering = "No dynamic light scattering correlation curve detected. For Object[Protocol, DynamicLightScattering] the Object[Data, DynamicLightScattering] is expected to have a CorrelationCurve or CorrelationCurves field.";


(*Define Analyze Function which breaks down the key steps*)
DefineAnalyzeFunction[
	AnalyzeDynamicLightScatteringLoading,
	<|
		Protocol -> ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]]
	|>,
	{
		analyzeResolveInputDLSL,
		analyzeResolveOptionsDLSL,
		analyzeCalculateDLSL, (* does core computation for Packet *)
		analyzePreviewDLSL (* populates Preview *)
	}

];

(*Resolve inputs*)
analyzeResolveInputDLSL[
	KeyValuePattern[{
		UnresolvedInputs->KeyValuePattern[{
			Protocol -> protocol_
		}],
        ResolvedOptions -> KeyValuePattern[{
    		CorrelationTemperature->correlationTemperature_
    	}]
	}]
]:= Module[
    {
        data,dataField, curve, curveCorrelations, curveConcentrations,
        dataCorrelationCurve, correlationTemperatureOption
    },

    (*Find the name of the correlation dataField and correlation data and assign the CorrelationTemperature option*)
	{
        dataField,
        curve,
        correlationTemperatureOption,
        data
    } = Switch[protocol,
		ObjectP[Object[Protocol,DynamicLightScattering]],

            (* download DLS data *)
			{
                data,
                correlationCurve,
                correlationCurves
            } = Download[
                protocol,
                {
                    Data[Object],
                    Data[CorrelationCurve],
                    Data[CorrelationCurves]
                }
            ];

            (* return the appropriate information from the download *)
			Which[
				Not[MatchQ[correlationCurve,NullP|{}]],
                    {CorrelationCurve,correlationCurve, Null, data},
				Not[MatchQ[correlationCurves,NullP|{}]],
                    {CorrelationCurves,correlationCurves, Null, data},
				True,
                    {$Failed, $Failed, $Failed, $Failed}
			],

		ObjectP[Object[Protocol, ThermalShift]],

            (* If the final tempereaute is requested use that, otherwise default to initial *)
            {dataCorrelationCurve, correlationTemperatureOption}  = If[MatchQ[correlationTemperature,Final],
                {FinalCorrelationCurve, Final},
                {InitialCorrelationCurve, Initial}
            ];

            (* Download thermal shift fields *)
			{
                data,
                correlationCurve
            } = Download[
                protocol,
                {
                    Data[Object],
                    Data[dataCorrelationCurve]
                }
            ];

            (* Error checking to make sure the pulled out data is not empty *)
            If[
                Not[MatchQ[correlationCurve,NullP|{}]],
				    {dataCorrelationCurve, correlationCurve, correlationTemperatureOption, data},
				    {$Failed, $Failed, $Failed, $Failed}
			]

	];

    (*Throw error if no correct data is found*)
	If[MatchQ[dataField, $Failed],
		If[MatchQ[protocol, ObjectP[Object[Protocol,DynamicLightScattering]]],
			Message[Error::MissingCorrelationDynamicLightScattering],
			Message[Error::MissingCorrelationThermalShift]
		];
		Return[$Failed]
	];

	(*Delete any bad data if it exists and give a warning*)
	curve = If[MatchQ[dataField, CorrelationCurves],

		(* For correlation curves look at the second column where individual curves are stored*)
		curveCorrelations = Map[
			dataCheck[#[[;;,2]]]&,
			curve
		];

        (*Pull out curve concentrations from the first column*)
		curveConcentrations = Map[
			#[[;;,1]]&,
			curve
		];

        (*recombine the concentrations and the cleaned up curves*)
		MapThread[
			Transpose[{#1,#2}]&,
			{curveConcentrations, curveCorrelations}
	    ],

		(* InitialCorrelationCurve or CorrelationCurve datafield directly combine them*)
		dataCheck[curve]

	];

	(*Pull out index matched samples to store in the object *)
	samples = If[MatchQ[protocol, ObjectP[Object[Protocol, ThermalShift]]],
    	protocol[NestedIndexMatchingSamplesIn],
    	protocol[SamplesIn]
	];

	<|
		ResolvedInputs-><|
			Data->data,
			DataField->dataField,
			Curve->curve,
            Protocol->protocol
		|>,
        ResolvedOptions -> <|
    		CorrelationTemperature->correlationTemperatureOption
    	|>,
		Tests -> <|
			ResolvedInputTests -> {}
		|>,
        	Packet -> <|
            		Type -> Object[Analysis, DynamicLightScatteringLoading],
            		Protocol->Link[protocol]
        	|>
	|>
]

(*Helper function to check that data is numeric*)
dataCheck[curves_] := Module[{cleanCurves},

    	(*pull out only numeric values*)
	cleanCurves = Map[
		QuantityArray[Cases[QuantityMagnitude[#], {x_,y_} /; MatchQ[{x,y}, {_?NumericQ, _?NumericQ}]], {Microsecond, ArbitraryUnit}]&,
		curves
	];

    	(*compare input to clean curves to see if there are any errors*)
	If[Not[MatchQ[curves, cleanCurves]],
		Message[Warning::RemovedData]
	];

	cleanCurves
];


(*Option Resolution*)
analyzeResolveOptionsDLSL[KeyValuePattern[{
	ResolvedOptions -> KeyValuePattern[{
		Include->include_,
		Exclude->exclude_,
		TimeThreshold->timeThreshold_,
		CorrelationThreshold->correlationThreshold_,
        CorrelationMaximum->correlationMaximum_,
        CorrelationTemperature->correlationTemperature_,
        Output->output_,
        Upload->upload_
	}],
	ResolvedInputs -> KeyValuePattern[{
		Data->data_
	}]
}]]:= Module[
    {
        includeResolved,excludeResolved,timeThresholdResolved,
        intersectionIncludeExclude, includeNonexistant, excludeNonexistant,
        overallNonexistant, InclusionExclusionTest, resolvedOptions
    },

    (*Boolean to handle tests*)
    collectTestsBoolean=MemberQ[ToList[output],Tests];

    (* check min threshold option does not exceed max threshold option *)
    If[correlationThreshold > correlationMaximum,
        Message[
            Error::MinExceedsMax,
            correlationThreshold,
            correlationMaximum
        ];
        Return[$Failed]
    ];

	(*Resolve TimeThreshold by converting to microseconds *)
    timeThresholdResolved = UnitConvert[timeThreshold, Microsecond];

    (*Check that include and exclude options actually exist within the *)
	includeResolved = Select[include,MemberQ[data,#]&];
    excludeResolved = Select[exclude,MemberQ[data,#]&];

    (*Check/Test if include and exclude have overlapping data*)
	intersectionIncludeExclude = Flatten[Intersection[includeResolved, excludeResolved]];

    overlapInclusionExclusionDescription="Check if the include and exclude options contain at least one overlapping member.";
	InclusionExclusionTest = testOrNull[1, collectTestsBoolean, overlapInclusionExclusionDescription, Not[Length[intersectionIncludeExclude]>0], intersectionIncludeExclude];
    If[MatchQ[InclusionExclusionTest, $Failed], Return[$Failed]];

	(*Check/Test if include and exclude data are not actually in the protocol*)
	includeNonexistant = Flatten[Complement[include, includeResolved]];
	excludeNonexistant = Flatten[Complement[exclude, excludeResolved]];
	overallNonexistant = Join[includeNonexistant, excludeNonexistant];
	absentInclusionExclusionDescription="Check that the include and exclude data are not in the protocol.";
	AbsentInclusionExclusionTest = testOrNull[2, collectTestsBoolean, absentInclusionExclusionDescription, Not[Length[overallNonexistant]>0], overallNonexistant];

    (*Create the association early since it is erturned in ResolvedOpions and Packet*)
   	resolvedOptions = <|
    	Include -> includeResolved,
    	Exclude -> excludeResolved,
    	TimeThreshold -> timeThresholdResolved,
    	CorrelationThreshold -> correlationThreshold,
        CorrelationTemperature->correlationTemperature,
        CorrelationMaximum -> correlationMaximum,
    	Output->output,
    	Upload->upload
	|>;

	<|
		ResolvedOptions -> resolvedOptions,
		Packet -> <|
            TimeThreshold -> timeThresholdResolved,
		    CorrelationThreshold -> correlationThreshold,
		    Replace[ManuallyIncludedData] -> includeResolved,
		    Replace[ManuallyExcludedData] -> excludeResolved,
            ResolvedOptions->Normal[resolvedOptions]
        |>,
		Tests -> <|
			ResolvedOptionTests -> {InclusionExclusionTest, AbsentInclusionExclusionTest}
		|>
	|>
];

(* Helper function to handle tests *)
testOrNull[input_,makeTest:BooleanP,description_,expression_, messageTerm_]:=If[makeTest,
	Test[description,expression,True],
	(* if tests are not requested to be returned, throw an error when fail *)

	If[expression,
		Null,
		(*Message[MessageName[AnalyzeFit,"Invalid"<>ToString[option]]];*)
		If[MatchQ[input, 1], Message[Error::SameIncludeExclude, messageTerm]; Return[$Failed]];
        If[MatchQ[input, 2], Message[Warning::AbsentIncludeExclude, messageTerm]]
	]
];

analyzeCalculateDLSL[KeyValuePattern[{
	ResolvedInputs -> KeyValuePattern[{
		Data -> datas_,
		DataField -> dataField_,
		Curve -> curves_,
        Protocol->protocol_
	}],
	ResolvedOptions -> KeyValuePattern[{
		TimeThreshold -> timeThreshold_,
		CorrelationThreshold -> correlationThreshold_,
        CorrelationMaximum -> correlationMaximum_,
        Include -> include_,
		Exclude -> exclude_
	}]
}]]:=Module[
    {
        scores, cumulativeScores, maxBadCurves, excludeData, cutoffData,
        data, excludedData
    },

	cutoffData = If[MatchQ[dataField, CorrelationCurves],

		(*Calculate correlation curves cumulative score since multiple curves per data object*)
		(*Need another function which maps individual data objects to count total valid objects*)
		cumulativeScores = Map[
			cumulativeCurveScore[#, timeThreshold, correlationThreshold, correlationMaximum]&,
			curves
		];

		(*Hard code number of bad curves, potentially make this an option*)
		maxBadCurves = 2;

        (*Indicate which data are valid and which to exclude*)
        Pick[datas, cumulativeScores, _?(#<=maxBadCurves&)],

		(*Directly calculate scores for each correlation curve*)
		scores = Map[
			scoreFromOneCurve[#,timeThreshold]&,
			curves
		];

        (*Indicate which data are valid and which to exclude*)
        Pick[datas, scores, _?(#>correlationThreshold && #<correlationMaximum&)]

	];

	(*Use exclude to move items from data to excludedData*)
	excludeData = DeleteCases[cutoffData, Alternatives@@exclude];

	(*Use include to move items from excludedData to data*)
	data = Join[excludeData, include];

	(*The complement of all the data and included data is the excluded data*)
	excludedData = Complement[datas,data];

	(*Store to different fields based on protocol type, Index match samples in*)
	pooledSamples = {};
	samples = {};

    (*Update values if populated field*)
	If[MatchQ[protocol, ObjectP[Object[Protocol, ThermalShift]]],
   		grabPooledSample = MemberQ[data,#]&/@datas;
        (*If the samples field in the protocol is Null, return null, otherwise return the samples *)
    	pooledSamples = If[MatchQ[protocol[NestedIndexMatchingSamplesIn],Null|{}],
            Null,
            Pick[protocol[NestedIndexMatchingSamplesIn],grabPooledSample]
        ],

        (* Object[Protocol, DynamicLightScattering] *)
    	grabSample = MemberQ[data,#]&/@datas;
        (*If the samples field in the protocol is Null, return null, otherwise return the samples *)
    	samples = If[MatchQ[protocol[SamplesIn], Null|{}],
            Null,
            Pick[protocol[SamplesIn],grabSample]
        ]
	];

	(*return data that is above the starting threshold*)
	<|
    	Packet -> <|
        		Replace[Data]->Map[Link[#]&,data],
        		Replace[ExcludedData]->Map[Link[#]&,excludedData],
        		Replace[PooledSamples]->pooledSamples,
        		Replace[Samples]->Map[Link[#]&,samples],
                Replace[Reference]->Link[protocol,DynamicLightScatteringLoadingAnalyses]
        |>
    |>
];

(*Calculate scores for correlation curves*)
cumulativeCurveScore[curves_,timeThreshold_,correlationThreshold_, correlationMaximum_]:=Module[
	{curveConcentration, concentrationMaximum, concentrationBool, curveData, curveScores, scoresBool, validBool},

	(*Check if concentrations are at 0*)
	curveConcentration = QuantityMagnitude[curves[[;;,1]]];
	concentrationMaximum = 0.1;
	concentrationBool = Map[#<concentrationMaximum&,curveConcentration];

	(*Check if correlation curves are valid*)
	curveScores = Map[
		scoreFromOneCurve[#,timeThreshold]&,
		curves[[;;,2]]
	];

    (* conver scores to a boolean to determine if they were properly loaded *)
	scoresBool = Map[
        (#>correlationThreshold && #<correlationMaximum) &,
        curveScores
    ];

	(*Find how many curves are valid in at least one case, below minimum threshold or above correlationThreshold*)
	validBool = Map[MemberQ[#,True]&,Transpose[{concentrationBool, scoresBool}]];

	(*Return number that are not valid*)
	Count[validBool, False]

];

(*calcualte thresholding score*)
scoreFromOneCurve[curve_, timeThreshold_]:= Module[
	{
        timeThresholdMicroSec, startingValues, meanStartingY
    },

    (*Parameters to decide which data are used*)
	(*Make sure time cutoff is in microseconds*)
    timeThresholdMicroSec = QuantityMagnitude[timeThreshold, Microsecond];

	(*All data  before time cutoff*)
	startingValues = Select[
    	QuantityMagnitude[curve,{Microsecond,ArbitraryUnit}],
    	#[[1]]<=timeThresholdMicroSec&
 	];

	(*Average the second correlation data*)
	meanStartingY = Mean[startingValues[[;;,2]]];

	meanStartingY

];

(*Preview function to plot correlation curves NON-INTERACTIVE*)
analyzePreviewDLSL[KeyValuePattern[{
		Packet->packet_
	}]]:=Module[{fig},

    newPacket = Analysis`Private`stripAppendReplaceKeyHeads[packet];
	fig = PlotObject[newPacket];

	<|
		Preview->fig
	|>
];





(*Companion Functions*)

(*Preview Companion Function*)
DefineOptions[AnalyzeDynamicLightScatteringLoadingPreview,
	SharedOptions :> {AnalyzeDynamicLightScatteringLoading}
];


AnalyzeDynamicLightScatteringLoadingPreview[
    myObject: ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]],
    ops:OptionsPattern
]:=Module[
    {safeOps, noOutputOptions},

    (*Pull out safe options for plotting*)
   	safeOps = safeOptions[AnalyzeDynamicLightScatteringLoading, ToList[ops]];

    (*Ensure that the output option is removed and forced to preview - in the next line*)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

    (*Call ADLSL with output to preview*)
    AnalyzeDynamicLightScatteringLoading[myObject, Sequence@@Append[noOutputOptions,Output->Preview]]

];

(*Options Companion Function*)
DefineOptions[AnalyzeDynamicLightScatteringLoadingOptions,
	SharedOptions :> {AnalyzeDynamicLightScatteringLoading},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type->Enumeration, Pattern:>Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

AnalyzeDynamicLightScatteringLoadingOptions[myObject: ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]], ops:OptionsPattern]:=Module[
	{listedOptions, noOutputOptions, options},

    	(*Pull out options*)
	listedOptions=ToList[ops];

    	(*Remove output and outputformat options from the list*)
	noOutputOptions=DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

    	(*Call ADLSL with output to options*)
	options=AnalyzeDynamicLightScatteringLoading[myObject,Sequence@@Append[noOutputOptions,Output->Options]];

    	(*Return the options in a nice table*)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeDynamicLightScatteringLoading],
		options
	]
];

(*ValidQ Companion Function*)
DefineOptions[ValidAnalyzeDynamicLightScatteringLoadingQ,
	Options:>{
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {AnalyzeDynamicLightScatteringLoading}
];

ValidAnalyzeDynamicLightScatteringLoadingQ[myObject: ObjectP[Object[Protocol, ThermalShift]]|ObjectP[Object[Protocol, DynamicLightScattering]], ops:OptionsPattern]:=Module[
	{preparedOptions,functionTests,initialTestDescription,allTests,verbose, outputFormat},

    (*pull out options*)
	preparedOptions=Normal@KeyDrop[Append[ToList[ops],Output->Tests],{Verbose,OutputFormat}];

    (*Run funciton tests*)
	functionTests=AnalyzeDynamicLightScatteringLoading[myObject,Sequence@@noOutputOptions];

    (*description for options and inputs*)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

    (*pull tests out of ADLSL*)
	allTests=If[MatchQ[functionTests,$Failed],
		{Test[initialTestDescription,False,True]},

		Module[{initialTest,validObjectBooleans,inputObjs,voqWarnings,testResults},
            (*initial test*)
			initialTest=Test[initialTestDescription,True,True];

            (*flatten input obects*)
			inputObjs=Cases[Flatten[myObject,1], _Object | _Model];

            (*check for an empty input*)
			If[!MatchQ[inputObjs, {}],
				validObjectBooleans=ValidObjectQ[inputObjs,OutputFormat->Boolean];

                (*pull VOW warnings*)
				voqWarnings=MapThread[
					Warning[ToString[#1,InputForm]<>" is valid (run ValidObjectQ for more detailed information):",
						#2,
						True
					]&,
					{inputObjs,validObjectBooleans}
				];

               	(*merge tests and warnings and return as list*)
				Join[ToList[functionTests],voqWarnings],

				ToList[functionTests]
			]
		]
	];

    (*use verbose and outputformat to return VOQ in desired format*)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

    (*run the tests*)
	RunUnitTest[<|"ValidAnalyzeDynamicLightScatteringLoadingQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidAnalyzeDynamicLightScatteringLoadingQ"]
];
