(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*CriticalMicelleConcentration*)


(* ::Subsubsection:: *)
(*CriticalMicelleConcentration Options and Messages*)


DefineOptions[AnalyzeCriticalMicelleConcentration,
	Options:>{
		{
			OptionName -> TargetMolecules,
			Default -> Automatic,
			Description -> "The target molecules for which the samples concentration will be calculated.",
			ResolutionDescription -> "The TargetMolecules is automatically set to the most common molecule in Analytes field of the samples. If the Analytes field is empty, it is set to the first molecule in the sample's composition field that is not the sample's Solvent or water or the protocol's Diluent.",
			AllowNull -> False,
			Widget -> Adder[
				Widget[
					Type -> Object,
					Pattern :>  ObjectP[List @@ IdentityModelTypeP]
				]
			]
		},
		{
			OptionName -> PreMicellarRange,
			Default -> Automatic,
			Description -> "The surface tension region used to fit the sloped part of the plot where the sample's surface tension decreases with increasing bulk concentration.",
			ResolutionDescription ->"Automatically set to the 10 percent to 60 of the range of surface tensions over 10 MilliNewton/Meter or Null if a PreMicellarDomain is set.",
			AllowNull -> True,
			Widget ->Span[
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Newton/ Meter],
					Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
				],
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Newton/ Meter],
					Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
				]
			]
		},
		{
			OptionName ->PostMicellarRange,
			Default -> Automatic,
			Description -> "The surface tension region used to fit the flat part of the plot where the surface of the sample is saturated with surfactant.",
			ResolutionDescription -> "Automatically set to include the bottom 10 percent of the range of surface tensions over 10 MilliNewton/Meter or Null if a PostMicellarDomain is set.",
			AllowNull -> True,
			Widget ->Span[
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Newton/ Meter],
					Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
				],
				Widget[
					Type->Quantity,
					Pattern:>GreaterEqualP[0 Milli Newton/ Meter],
					Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
				]
			]
		},
		{
			OptionName -> PreMicellarDomain,
			Default -> Null,
			Description -> "The concentration region used to fit the sloped part of the plot where the sample's surface tension decreases with increasing bulk concentration.",
			AllowNull -> True,
			Widget ->Span[
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar],
					Units:>{Molar, {Millimolar, Molar}}
				],
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar],
					Units:>{Molar, {Millimolar, Molar}}
				]
			]
		},
		{
			OptionName ->PostMicellarDomain,
			Default -> Null,
			Description -> "The surface tension region used to fit the flat part of the plot where the surface of the sample is saturated with surfactant.",
			AllowNull -> True,
			Widget ->Span[
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar],
					Units:>{Molar, {Millimolar, Molar}}
				],
				Widget[
					Type->Quantity,
					Pattern:>GreaterP[0 Molar],
					Units:>{Molar, {Millimolar, Molar}}
				]
			]
		},
		{
			OptionName ->Exclude,
			Default -> Automatic,
			Description -> "Samples to be excluded from fitting.",
			ResolutionDescription -> "Set to the samples that have surface tensions lower than 10 Millinewton/Meter.",
			AllowNull -> True,
			Widget ->Adder[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Sample]]
				]
			]
		},
		{
			OptionName ->DiluentSurfaceTension,
			Default -> Automatic,
			Description -> "The surface tension of the diluent used to dilute the sample. This used to calculate the Apparent Partitioning Coefficient.",
			ResolutionDescription -> "Set to the average surface tension of the diluents if they have a populated SurfaceTension field or the surface tension of Model[Sample, \"Milli-Q water\"] otherwise.",
			AllowNull -> False,
			Widget ->Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milli Newton/ Meter,100 Milli Newton/ Meter],
				Units -> CompoundUnit[{1, {Milli Newton, {Milli Newton}}}, {-1, {Meter, {Meter}}}]
			]
		},
		OutputOption,
		UploadOption,
		AnalysisTemplateOption
	}
];

(* Messages *)
Error::MissingTargetMolecules="The TargetMolecules `1` are not present in the measured samples `2`. Please only include molecules that are present in the measured samples in order to specify a valid analysis. To see the molecules that are present in the measured samples, you can look at the Composition field of these samples.";
Error::UnresolvableTargetMolecules="No molecule is present in the composition of the samples. The TargetMolecules cannot be resolved.";

Warning::UnableToConvertConcentration="The concentration of the TargetMolecules `1` in the samples can not be converted to Molar. If you would like to convert the these concentrations, please make sure the MolecularWeight of `1` is uploaded.";

Warning::EmptyPostMicellarRegion="There are no data points the provided post-micellar region `1`. In order to fit this region, please change the PostMicellarRange or PostMicellarDomain. To see the surface tensions of the measured samples, you can look in the SurfaceTension field of the data objects.";
Warning::EmptyPreMicellarRegion="There are no data points the provided pre-micellar region `1`. In order to fit this region, please change the PreMicellarRange or PreMicellarDomain. To see the surface tensions of the measured samples, you can look in the SurfaceTension field of the data objects.";

Error::MissingExcludedSamples="The Excluded samples `1` are not present in the data objects. Please choose objects from AliquotSamples field in the data objects.";
Warning::ConflictingDiluents="The input data objects have conflicting diluents `1`. Please choose data objects with the same diluent for more accurate analysis.";
Error::InsuffientDataPoints="The input data objects only have `1` points. The function needs more points to fit the data";

Error::ConflictingPreMicellarDomain="A PreMicellarDomain `1` and PreMicellarRange `2` are specified. Only one of these options can be set.";
Error::ConflictingPostMicellarDomain="A PostMicellarDomain `1` and PostMicellarRange `2` are specified. Only one of these options can be set.";

Error::MissingPreMicellarDomain="Neither a PreMicellarDomain `1` or a PreMicellarRange `2` are specified. Please set one of these options.";
Error::MissingPostMicellarDomain="Neither a PostMicellarDomain `1` or a PostMicellarRange `2` are specified. Please set one of these options.";

Error::ConflictingPreMicellarDomainUnits="The concentrations of the sample could not be converted into the units of the PreMicellarDomain and the samples in the PreMicellarDomain `1` could not be found. Please specify a PreMicellarRange instead.";
Error::ConflictingPostMicellarDomainUnits="The concentrations of the sample could not be converted into the units of the PostMicellarDomain and the samples in the PostMicellarDomain `1` could not be found. Please specify a PostMicellarRange instead.";


(* ::Subsubsection:: *)
(*CriticalMicelleConcentration Source Code*)
(*Overloads*)
AnalyzeCriticalMicelleConcentration[myDataObj : ObjectP[Object[Data, SurfaceTension]], ops : OptionsPattern[]] := Module[
  {out},

  out = AnalyzeCriticalMicelleConcentration[{myDataObj}, ops];

  If[!MatchQ[out, _List] || Length[out] > 1,
    out,
    First[out]
  ]

];

AnalyzeCriticalMicelleConcentration[myProtocolObj : ObjectP[Object[Protocol, MeasureSurfaceTension]], ops : OptionsPattern[]] := Module[
	{out},

	out = AnalyzeCriticalMicelleConcentration[myProtocolObj[Data], ops]

];

AnalyzeCriticalMicelleConcentration[myProtocolObjs : {ObjectP[Object[Protocol, MeasureSurfaceTension]]..}, ops : OptionsPattern[]] := Module[
	{out},

	out = AnalyzeCriticalMicelleConcentration[Flatten[myProtocolObjs[Data],1], ops]

];

(*Main Function*)
AnalyzeCriticalMicelleConcentration[myDataObjs:{ObjectP[Object[Data,SurfaceTension]]..},ops:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,standardFieldsStart,gatherTests,messages,notInEngine,safeOptions,safeOptionTests,
		unresolvedOptions,templateTests,combinedOptions,combinedOptionsNamed, dataPackets,
		aliquotSamples, samplesIn, diluent, dilutionFactors, temperatures, nonNullTemperatures, surfaceTensions,
		aliquotSamplesObjects, samplesInObjects, aliquotSamplesCompositions,aliquotSamplesMolecules,
		 targetMoleculeTest, excludedSamplesTest,
		diluentSurfaceTensions,targetMoleculeConcentrations, targetMoleculeComposition, targetMoleculeUnits,
		diluentCompositions, samplePackets, sampleAnalytes, sampleAnalytesObjects, solvent,
		resolvedTargetMoleculeTest, samplesInPackets,  compositionNoTarget,
		 targetWeight,targetDensity, solventDensity,
		 resolveddiluentSurfaceTension, sampleMolarity,
		solventCompositions, resolvedpreMicellarRange,resolvedpostMicellarRange,
		conflictingDiluentsTest, diluentPackets, diluentModels, resolvedtargetMolecule, exclude,  upload, resolvedOptions,
		analysisID,analysisPacket,allTests,previewRule,optionsRule,testsRule,analysisObject,resultRule,
		concentrations,concentrationData,surfaceTensionData,preMicellarConcentrationData,preMicellarSurfaceTensionData,
		postMicellarConcentrationData,postMicellarSurfaceTensionData,preMicellarData, preMicellarDerivative,
		postMicellarData,preMicellarFit,postMicellarFit,preMicellarFitExpression,postMicellarFitExpression,criticalMicelleConcentration,
		apparentPartitioningCoefficient, surfaceExcessConcentration,
		crossSectionalArea, temperature,concentrationUnits,surfacePressures, maxSurfacePressure,allData,
		allConcentrationData,allSurfaceTensionData, preMicellarFitUpload,postMicellarFitUpload,
		minConcentration,maxConcentration,minConcentrationUnitless,maxConcentrationUnitless,postMicelleFitMin,postMicelleFitMax,
		preMicelleFitMin,preMicelleFitMax, preMicellarRSquared, postMicellarRSquared,
		emptyPostMicellarRegionTests,emptyPreMicellarRegionTests, emptyPreMicellarRegion,emptyPostMicellarRegion, diluentModelsObjects, aliquotSamplesCompositionsLinks,
		diluentCompositionsLinks, diluentObjects,  postMicellarFitID, preMicellarFitID, preMicellarFitNoID, postMicellarFitNoID, gasConstant,
		cacheBall, resolvedOptionsResult, resolvedOptionsTests, collapsedResolvedOptions, postMicellarDerivative,
		resolvedpreMicellarDomain, resolvedpostMicellarDomain, conflictingPreMicellarDomainUnits, conflictingPreMicellarDomainUnitsTests,
		conflictingPostMicellarDomainUnits, conflictingPostMicellarDomainUnitsTests, additionalinvalidOptions, preMicellarRange,postMicellarRange, objectCache,
		preMicellarDomain,postMicellarDomain, allconcentrations,molarBool, concentrationDataNoZero,surfaceTensionDataNoZero, unableToConvertTests, unableToConvert, optionObjects
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* fixed starting fields *)
	standardFieldsStart = analysisPacketStandardFieldsStart[{ops}];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];
	messages=!gatherTests;

	(* Determine if we are in Engine or not, in Engine we silence warnings *)
	notInEngine=Not[MatchQ[$ECLApplication,Engine]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[AnalyzeCriticalMicelleConcentration, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[AnalyzeCriticalMicelleConcentration, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{unresolvedOptions, templateTests} = If[gatherTests,
		ApplyTemplateOptions[AnalyzeCriticalMicelleConcentration, myDataObjs, listedOptions, Output -> {Result, Tests}],
		{ApplyTemplateOptions[AnalyzeCriticalMicelleConcentration, myDataObjs, listedOptions], Null}
	];

	combinedOptionsNamed = ReplaceRule[safeOptions, unresolvedOptions];


	(* Sanitize the inputs (Convert from Name to Object) *)
	{myDataObjs,combinedOptions} = Experiment`Private`sanitizeInputs[myDataObjs,combinedOptionsNamed];


	(* -- Assemble big download -- *)
	{
		cacheBall
	}=Quiet[Download[
		{
			myDataObjs
		},
		{
			{
				Packet[
					Composition, AliquotSamples, SamplesIn, Diluent, DilutionFactors, Temperatures, SurfaceTensions
				],
				Packet[
					Diluent[{Model,Composition,SurfaceTension}]
				],
				Packet[
				AliquotSamples[{Composition,Analytes,Solvent}]
				],
				Packet[
					AliquotSamples[Solvent][Composition][[All,2]][Object]
				],
				Packet[
					SamplesIn[Composition]
				]
			}
		}
	],Download::FieldDoesntExist];


	(*--Build the resolved options--*)
	resolvedOptionsResult=If[gatherTests,
		(*We are gathering tests. This silences any messages being thrown*)
		{resolvedOptions,resolvedOptionsTests}=resolveAnalyzeCriticalMicelleConcentrationOptions[myDataObjs,combinedOptions,Cache->cacheBall,Output->{Result,Tests}];

		(*Therefore, we have to run the tests to see if we encountered a failure*)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(*We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption*)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveAnalyzeCriticalMicelleConcentrationOptions[myDataObjs,combinedOptions,Cache->cacheBall],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];


	(*Collapse the resolved options*)
	collapsedResolvedOptions=CollapseIndexMatchedOptions[
		AnalyzeCriticalMicelleConcentration,
		resolvedOptions,
		Ignore->listedOptions,
		Messages->False
	];

	allTests=Cases[Flatten[{safeOptionTests,resolvedOptionsTests}],_EmeraldTest];


	(*If option resolution failed, return early*)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->allTests,
			Options->RemoveHiddenOptions[AnalyzeCritcalMicelleConcentration, collapsedResolvedOptions],
			Preview->Null
		}]
	];


	(* --- Main Body of Function ---*)

	(*pull out options*)
	{
		resolvedtargetMolecule,resolveddiluentSurfaceTension, resolvedpreMicellarRange, resolvedpostMicellarRange, resolvedpreMicellarDomain, resolvedpostMicellarDomain, exclude, upload
	}=
     Lookup[resolvedOptions,
			 {
				 TargetMolecules, DiluentSurfaceTension, PreMicellarRange, PostMicellarRange, PreMicellarDomain, PostMicellarDomain, Exclude, Upload
			 }
		 ];

	(*convert spans in that are large to small to small to large *)
	preMicellarRange=If[MatchQ[resolvedpreMicellarRange,Null],resolvedpreMicellarRange,Sort[resolvedpreMicellarRange]];
	postMicellarRange=If[MatchQ[resolvedpostMicellarRange,Null],resolvedpostMicellarRange,Sort[resolvedpostMicellarRange]];
	preMicellarDomain=If[MatchQ[resolvedpreMicellarDomain,Null],resolvedpreMicellarDomain,Sort[resolvedpreMicellarDomain]];
	postMicellarDomain=If[MatchQ[resolvedpostMicellarDomain,Null],resolvedpostMicellarDomain,Sort[resolvedpostMicellarDomain]];

	(*pull out data info*)
	(* Pull out the relevant packets from the listed packets *)
	dataPackets=cacheBall[[All,1]];
	diluentPackets=cacheBall[[All,2]];
	samplePackets=cacheBall[[All,3]];
	solventCompositions=cacheBall[[All,4]];
	samplesInPackets=cacheBall[[All,5]];

	(* - Next, pull our relevant fields from the Data Objects - *)
	{
		samplesIn, aliquotSamples, dilutionFactors, temperatures, surfaceTensions, diluent
	}=Transpose[Lookup[dataPackets,
		{
			SamplesIn, AliquotSamples, DilutionFactors, Temperatures, SurfaceTensions, Diluent
		}
	]];

	(* - Next, pull our relevant fields from the diluent Objects - *)

	diluentModels=(If[MatchQ[#,Null],Null,Lookup[#, Model]]&/@diluentPackets)/. (_?MissingQ :> Null);

	diluentCompositionsLinks =(If[MatchQ[#,Null],Null,Lookup[#, Composition]]&/@diluentPackets)/. (_?MissingQ :> Null);

	diluentSurfaceTensions =(If[MatchQ[#,Null],Null,Lookup[#, SurfaceTension]]&/@diluentPackets)/. (_?MissingQ :> Nothing)/. (Null :> Nothing);

	(* - Next, pull our relevant fields from the aliquot Objects - *)

	aliquotSamplesCompositionsLinks =Lookup[#, Composition]&/@samplePackets/. (_?MissingQ :> Null);

	sampleAnalytes =Lookup[#, Analytes]&/@samplePackets/. (_?MissingQ :> Nothing);


	(*convert the Link[Object] and compositions into Objects*)
	diluentObjects=Download[diluent,Object];
	samplesInObjects=Download[Cases[Flatten[samplesIn,1],ObjectP[]],Object];
	aliquotSamplesObjects=Download[Cases[Flatten[aliquotSamples,1],ObjectP[]],Object];
	diluentModelsObjects=Download[diluentModels,Object];
	sampleAnalytesObjects=Download[Cases[Flatten[sampleAnalytes,2],ObjectP[]],Object];
	diluentCompositions=diluentCompositionsLinks/. {x : LinkP[] :> Link[x]};
	aliquotSamplesCompositions=aliquotSamplesCompositionsLinks/. {x : LinkP[] :> Link[x]};
	aliquotSamplesMolecules=#[[All, 2]]&/@Flatten[aliquotSamplesCompositions,1];


	(* --- Parse the data to build our AnalyzeFit call --- *)

	(*convert surface tensions into surface pressures*)
	surfaceTensions = ReplaceAll[surfaceTensions, Null->0. Milli Newton/Meter];
	surfacePressures=(resolveddiluentSurfaceTension-#)&/@Flatten[surfaceTensions];
	maxSurfacePressure=Max[surfacePressures];

	(*The compositions of each target molecule in the aliquot samples {{conc,Molecule}..}*)
	targetMoleculeComposition =
		Map[
			Function[{compositions},
				Flatten[Cases[compositions, {CompositionP, ObjectP[#]}]] & /@ resolvedtargetMolecule
			], Flatten[aliquotSamplesCompositions, 1]];

	(*Find what units the concentrations are in*)
	targetMoleculeUnits=If[MatchQ[Flatten[targetMoleculeComposition],{}],Null,Units[First[Flatten[targetMoleculeComposition]]]];

	(*Find the Concentration preferably in Molar units of of the target molecule in each data objects composition*)

	(*Find the samples most likely diluent*)
	compositionNoTarget= DeleteCases[
		DeleteCases[
		#,{CompositionP,ObjectP[resolvedtargetMolecule]}
	],
		{_,Null}
	]
		&/@Flatten[aliquotSamplesCompositions,1];

	(*find the solvent of the sample to calculate molar concentration*)
	solvent=If[MatchQ[#,{}],
		Null,
		First[#[[1,2]]]
	]&/@compositionNoTarget;

	(*Get the information needed to convert*)
	targetWeight=Download[resolvedtargetMolecule,MolecularWeight];

	targetDensity=Download[resolvedtargetMolecule,Density];

	solventDensity=Download[solvent,Density]/.(Null->0.997Gram/Milliliter);

	(*The concentrations of the target molecule in each aliquot sample, {conc..}*)
	targetMoleculeConcentrations=Map[
		#[[All, 1]] &,
		targetMoleculeComposition /. ({} -> {0*targetMoleculeUnits, Null})
	];


	(*convert if possible*)
	allconcentrations=MapThread[
		Function[{conc,solventdensity,targetweight,targetdensity},
			Which[
				(*Masspercent->%/100*(g/Liter}*(moles/g}*)
				MatchQ[conc,MassPercentP]&&MatchQ[targetweight,Except[Null]]&&MatchQ[solventdensity,Except[Null]],
				Convert[Unitless[conc]/100*solventdensity/targetweight,Millimolar],
				(*Volumepercent->%/100*(g/Liter)*(moles/g_*)
				MatchQ[conc,VolumePercentP]&&MatchQ[targetweight,Except[Null]]&&MatchQ[targetdensity,Except[Null]],
				Convert[Unitless[conc]/100*targetdensity/targetweight,Millimolar],
				(*MassConcentration->(m/v)**moles/g*)
				MatchQ[conc,MassConcentrationP]&&MatchQ[targetweight,Except[Null]],
				Convert[conc/targetweight,Millimolar],
				(*Molar*)
				MatchQ[conc,ConcentrationP],
				Convert[conc,Millimolar],
				(*could not convert*)
				True,
				conc
			]
		],
			{targetMoleculeConcentrations,Table[#,Length[targetWeight]]&/@solventDensity,Table[targetWeight,Length[targetMoleculeConcentrations]],Table[targetDensity,Length[targetMoleculeConcentrations]]},
			2
		];

	unableToConvert=MatchQ[Quiet[Unitless[allconcentrations,Molar]],$Failed|{$Failed..}|{{$Failed..}..}];

	If[messages&&notInEngine&&unableToConvert,
		Message[Warning::UnableToConvertConcentration,resolvedtargetMolecule]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	unableToConvertTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[unableToConvert,
				Warning["The sample concentration can be converted to Molar:",False,True],
				Nothing
			];
			passingTest=If[!unableToConvert,
				Warning["The sample concentration can be converted to Molar:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*Sum the concentrations if there are multiple surfactants*)
	concentrations=Total[#]&/@allconcentrations;

	(*Error*)
	conflictingPreMicellarDomainUnits=If[MatchQ[preMicellarDomain,Except[Null]]&&MemberQ[concentrations,Except[UnitsP[First[preMicellarDomain]]]],
		{PreMicellarDomain},
		{}
	];

	If[messages&&notInEngine&&Length[conflictingPreMicellarDomainUnits]>0,
		Message[Error::ConflictingPreMicellarDomainUnits,ToString[preMicellarDomain]]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	conflictingPreMicellarDomainUnitsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[conflictingPreMicellarDomainUnits]>1,
				Warning["If a PreMicellarDomain is set, the samples have molar concentrations:",False,True],
				Nothing
			];
			passingTest=If[Length[conflictingPreMicellarDomainUnits]==0,
				Warning["If a PreMicellarDomain is set, the samples have molar concentrations:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	conflictingPostMicellarDomainUnits=If[MatchQ[postMicellarDomain,Except[Null]]&&MemberQ[concentrations,Except[UnitsP[First[postMicellarDomain]]]],
		{PostMicellarDomain},
		{}
	];

	If[messages&&notInEngine&&Length[conflictingPostMicellarDomainUnits]>0,
		Message[Error::ConflictingPostMicellarDomainUnits,ToString[postMicellarDomain]]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	conflictingPostMicellarDomainUnitsTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[conflictingPostMicellarDomainUnits]>1,
				Warning["If a PostMicellarDomain is set, the samples have molar concentrations:",False,True],
				Nothing
			];
			passingTest=If[Length[conflictingPostMicellarDomainUnits]==0,
				Warning["If a PostMicellarDomain is set, the samples have molar concentrations:",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];


	(*Remove any points as specified by user*)
	{concentrationData,surfaceTensionData}=Transpose[
		MapThread[
		If[MemberQ[exclude,#2],Nothing,{#1,#3}]&,
		{Flatten[concentrations,1],aliquotSamplesObjects,Flatten[surfaceTensions,1]}
		]
		];

	(*Remove any points with 0 target concentration*)
	{concentrationDataNoZero,surfaceTensionDataNoZero}=Transpose[
		MapThread[
			If[MatchQ[Unitless[#1],0],Nothing,{#1,#2}]&,
			{concentrationData,surfaceTensionData}
		]
	];

	emptyPreMicellarRegion=Which[
		(*If a surface tension range was given*)
		MatchQ[preMicellarRange,Except[Null]],
		(*True if there are points the range, false otherwise*)
		If[!MemberQ[surfaceTensionDataNoZero,RangeP[
			First[preMicellarRange],
			Last[preMicellarRange]
		]],
			True,
			False
		],
		(*If a concentration domain was given*)
		MatchQ[preMicellarDomain,Except[Null]],
		(*True if there are points the range, false otherwise*)
		If[!MemberQ[concentrationDataNoZero,RangeP[
			First[preMicellarDomain],
			Last[preMicellarDomain]
		]],
			True,
			False
		]
	];

	If[messages&&notInEngine&&emptyPreMicellarRegion,
		Message[Warning::EmptyPreMicellarRegion,If[MatchQ[preMicellarRange,Null],ToString[preMicellarDomain],ToString[preMicellarRange]]]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	emptyPreMicellarRegionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[emptyPreMicellarRegion,
				Warning["There are data points in the PreMicellarRegion, "<>If[MatchQ[preMicellarRange,Null],ToString[preMicellarDomain],ToString[preMicellarRange]]<>":",True,False],
				Nothing
			];
			passingTest=If[!emptyPreMicellarRegion,
				Warning["There are data points in the PreMicellarRegion, "<>If[MatchQ[preMicellarRange,Null],ToString[preMicellarDomain],ToString[preMicellarRange]]<>":",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	emptyPostMicellarRegion=Which[
		(*If a surface tension range was given*)
		MatchQ[postMicellarRange,Except[Null]],
		(*True if there are points the range, false otherwise*)
		If[!MemberQ[surfaceTensionDataNoZero,RangeP[
			First[postMicellarRange],
			Last[postMicellarRange]
		]],
			True,
			False
		],
		(*If a concentration domain was given*)
		MatchQ[postMicellarDomain,Except[Null]],
		(*True if there are points the range, false otherwise*)
		If[!MemberQ[concentrationDataNoZero,RangeP[
			First[postMicellarDomain],
			Last[postMicellarDomain]
		]],
			True,
			False
		]
	];

	If[messages&&notInEngine&&emptyPostMicellarRegion,
		Message[Warning::EmptyPostMicellarRegion,If[MatchQ[postMicellarRange,Null],ToString[postMicellarDomain],ToString[postMicellarRange]]]
	];

	(* If we are gathering tests, gather the passing and failing tests *)
	emptyPostMicellarRegionTests=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[emptyPostMicellarRegion,
				Warning["There are data points in the PostMicellarRegion, "<>If[MatchQ[postMicellarRange,Null],ToString[postMicellarDomain],ToString[postMicellarRange]]<>":",False,True],
				Nothing
			];
			passingTest=If[!emptyPostMicellarRegion,
				Warning["There are data points in the PostMicellarRegion, "<>If[MatchQ[postMicellarRange,Null],ToString[postMicellarDomain],ToString[postMicellarRange]]<>":",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

	(* Define the Invalid Options *)
	additionalinvalidOptions=DeleteDuplicates[Flatten[
		{
			conflictingPostMicellarDomainUnits,conflictingPreMicellarDomainUnits
		}
	]];

	(*Throw Error::InvalidOption if there are invalid options*)
	If[Length[additionalinvalidOptions]>0&&messages,
		Message[Error::InvalidOption,additionalinvalidOptions]
	];

	(*return early if there are invalid options*)
	If[Length[additionalinvalidOptions]>0,
		Return[outputSpecification/.{
			Result->$Failed,
			Tests->allTests,
			Options->RemoveHiddenOptions[AnalyzeCritcalMicelleConcentration, collapsedResolvedOptions],
			Preview->Null
		}]
	];

	(*all the data points*)
	{allConcentrationData,allSurfaceTensionData}=Transpose[
		MapThread[
			{#1,#2}&,
			{Flatten[concentrations,1],Flatten[surfaceTensions,1]}
		]
	];

	(*find the points in each fitting range*)
	{preMicellarConcentrationData,preMicellarSurfaceTensionData}=If[emptyPreMicellarRegion,
		{Null,Null},
		Transpose[
			MapThread[
				Which[
					(*If surface tension range was given*)
					MatchQ[preMicellarRange,Except[Null]],
					(*return points in that range*)
					If[MatchQ[#2,RangeP[
						First[preMicellarRange],
						Last[preMicellarRange]
					]],
						{#1,#2},
						Nothing],
					(*If concentration domain was given*)
					True,
					(*return points in that domain*)
					If[MatchQ[#1,RangeP[
						First[preMicellarDomain],
						Last[preMicellarDomain]
					]],
						{#1,#2},
						Nothing]
				]&, {concentrationData,surfaceTensionData}
			]
		]
	];

	{postMicellarConcentrationData,postMicellarSurfaceTensionData}=If[emptyPostMicellarRegion,
		{Null,Null},
		Transpose[MapThread[
			Which[
				(*If surface tension range was given*)
				MatchQ[postMicellarRange,Except[Null]],
				(*return points in that range*)
				If[MatchQ[#2,RangeP[
					First[postMicellarRange],
					Last[postMicellarRange]
				]],
					{#1,#2},
					Nothing],
				(*If concentration domain was given*)
				True,
				(*return points in that domain*)
				If[MatchQ[#1,RangeP[
					First[postMicellarDomain],
					Last[postMicellarDomain]
					]],
					{#1,#2},
					Nothing]
			]&, {concentrationData,surfaceTensionData}
			]]

	];
	(* --- Call AnalyzeFit on the data *)

	(*first convert the concentration into Ln[concentration]*)
	(*Ln[0] will fail, giving negative infinity*)
	allData=Transpose[{
		If[MatchQ[Quiet[Unitless[allConcentrationData,Molar]],$Failed|{$Failed..}],
			Log[Unitless[allConcentrationData]],
			Log[Unitless[allConcentrationData,Molar]]
		],
		Unitless[allSurfaceTensionData,Milli Newton/ Meter]}]
		/. ({{-Infinity, _Real} -> Nothing, {Indeterminate, _Real} -> Nothing});

	preMicellarData=If[emptyPreMicellarRegion,
		Null,
		Transpose[{
			If[MatchQ[Quiet[Unitless[preMicellarConcentrationData,Molar]],$Failed|{$Failed..}],
				Log[Unitless[preMicellarConcentrationData]],
				Log[Unitless[preMicellarConcentrationData,Molar]]
			],
			Unitless[preMicellarSurfaceTensionData,Milli Newton/ Meter]}]
	]/. ({{-Infinity, _Real} -> Nothing, {Indeterminate, _Real} -> Nothing});

	postMicellarData=If[emptyPostMicellarRegion,
		Null,
		Transpose[{
			If[MatchQ[Quiet[Unitless[postMicellarConcentrationData,Molar]],$Failed|{$Failed..}],
				Log[Unitless[postMicellarConcentrationData]],
				Log[Unitless[postMicellarConcentrationData,Molar]]
			],
			Unitless[postMicellarSurfaceTensionData,Milli Newton/ Meter]}]
	]/. ({{-Infinity, _Real} -> Nothing, {Indeterminate, _Real} -> Nothing});

	(*Keep the units*)
	concentrationUnits=If[MatchQ[Quiet[Unitless[postMicellarConcentrationData,Molar]],$Failed|{$Failed..}],
		Units[postMicellarConcentrationData[[1]]],
		Molar
	];

	(*call the fitting functions*)
	preMicellarFitNoID=If[MatchQ[preMicellarData,Null],
		Null,
		AnalyzeFit[allData,Linear,Exclude->Complement[allData,preMicellarData],Upload->False]
		];

	preMicellarFitID =If[emptyPreMicellarRegion,Null, CreateID[Object[Analysis,Fit]]];

	preMicellarFit=If[MatchQ[preMicellarFitNoID,Except[Null]],
		Join[
			preMicellarFitNoID,
			<|Object->preMicellarFitID|>
		],
		Null
		];

	postMicellarFitNoID=If[MatchQ[postMicellarData,Null],
		Null,
		AnalyzeFit[allData,Linear,Exclude->Complement[allData,postMicellarData], Upload->False]
		];

	postMicellarFitID = If[emptyPostMicellarRegion,Null, CreateID[Object[Analysis,Fit]]];

	postMicellarFit=If[MatchQ[postMicellarFitNoID,Except[Null]],
		Join[
			postMicellarFitNoID,
			<|Object->postMicellarFitID|>
		],
		Null
	];

	(* -- Use the AnalyzeFit object to calculate the CMC and other values-- *)
	{preMicellarFitExpression, preMicellarRSquared}=If[MatchQ[preMicellarFit,Null],
		{Null,Null},
		Lookup[preMicellarFit,{BestFitExpression, RSquared}]
		];

	preMicellarDerivative=If[MatchQ[preMicellarFit,Null],
		Null,
		First[Last[preMicellarFitExpression]]
	];

	{postMicellarFitExpression, postMicellarRSquared}=If[MatchQ[postMicellarFit,Null],
		{Null,Null},
		Lookup[postMicellarFit,{BestFitExpression, RSquared}]
		];

	postMicellarDerivative=If[MatchQ[postMicellarFit,Null],
		Null,
		First[Last[postMicellarFitExpression]]
	];

	(*find intersection of preMicellarFit and postMicellarFit to get CMC*)

	criticalMicelleConcentration=If[
		!MatchQ[preMicellarFit,Null]&&!MatchQ[postMicellarFit,Null]&&!(MatchQ[preMicellarDerivative,0]&&MatchQ[postMicellarDerivative,0]),
		E^First[Lookup[Solve[
			preMicellarFitExpression - postMicellarFitExpression == 0],x]]*concentrationUnits,
		Null
	];

	(*find intersection of preMicellarFit and DiluentSurfaceTension to get ApparentPartitioningCoefficient*)
	apparentPartitioningCoefficient=If[
		(*if there was points to fit the premicellar region*)
		!MatchQ[preMicellarFit,Null]&&!MatchQ[preMicellarDerivative,0],
		Module[{lnintersection,intersection, intersectionunits},
			(*find where the fit intersects with the diluent surface tension, x=*)
			lnintersection=First[
				Lookup[
				Solve[preMicellarFitExpression - Unitless[resolveddiluentSurfaceTension,Milli Newton/Meter] == 0],
				x]
			];
			(*convert from ln[x] to x with x=e^ln[x]*)
			intersection=1/E^lnintersection;
			(*add units back*)
			intersectionunits=intersection/concentrationUnits
		],
		Null
	];



	(* remove the null temperatures from consideration *)
	nonNullTemperatures = ReplaceAll[temperatures, Null->Nothing];

	(*use slope of preMicellarFit to get SurfaceExcessConcentration*)
	temperature=Unitless[Mean[Flatten[nonNullTemperatures]],Kelvin]*Kelvin;
	gasConstant=Convert[MolarGasConstant, Newton*Meter/Kelvin/Mole];

	(*only for molar concentrations*)
	surfaceExcessConcentration=If[MatchQ[concentrationUnits,Molar]&&!MatchQ[preMicellarFit,Null],
		-1/temperature/gasConstant*preMicellarDerivative*Milli*Newton/Meter,
		Null
	];

	(*use the inverse slope of preMicellarFit to get CrossSectionalArea*)

	crossSectionalArea=If[MatchQ[concentrationUnits,Molar]&&!MatchQ[preMicellarFit,Null],
		1/surfaceExcessConcentration/AvogadroConstant,
		Null
	];

	(* --- Build the analysis packet --- *)
	(* Create an Object[Analysis,CriticalMicelleConcentration] id *)
	analysisID=CreateID[Object[Analysis,CriticalMicelleConcentration]];

	(*upload fit objects if we need them. We need them to make the plots*)
	preMicellarFitUpload=If[upload&&MemberQ[output,Result],
		If[MatchQ[Quiet[Upload[DeleteCases[{preMicellarFit},Null]]],{$Failed}],True,False],
		False
	];

	postMicellarFitUpload=If[upload&&MemberQ[output,Result],
		If[MatchQ[Quiet[Upload[DeleteCases[{postMicellarFit},Null]]],{$Failed}],True,False],
		False
	];

	(* Build the packet for the AnalysisObject *)
	analysisPacket=Association@@ReplaceRule[
		standardFieldsStart,
		Join[
			{
				Object->analysisID,
				Replace[ResolvedOptions]->resolvedOptions,
				Replace[SamplesIn] -> Link@samplesInObjects,
				Replace[AliquotSamples]-> Link@aliquotSamplesObjects,
				Replace[DilutionFactors]-> Flatten[dilutionFactors],
				Replace[TargetMolecules]-> (Link[#]&/@resolvedtargetMolecule),
				Replace[Concentrations]-> Flatten[concentrations],
				Replace[SurfaceTensions]-> Flatten[surfaceTensions],
				Replace[Temperatures] -> Flatten[temperatures],
				Replace[SurfacePressures]-> surfacePressures,
				Replace[AssayData]->(Link[#,CriticalMicelleConcentrationAnalyses]&/@myDataObjs),
				PreMicellarFit ->If[Or[MatchQ[preMicellarFit,Null],preMicellarFitUpload],Null,Link[preMicellarFitID,PredictedValues]],
				PostMicellarFit ->If[Or[MatchQ[postMicellarFit,Null],postMicellarFitUpload],Null,Link[postMicellarFitID,PredictedValues]],
				CriticalMicelleConcentration-> criticalMicelleConcentration,
				ApparentPartitioningCoefficient-> apparentPartitioningCoefficient,
				SurfaceExcessConcentration-> surfaceExcessConcentration,
				CrossSectionalArea-> crossSectionalArea,
				MaxSurfacePressure->maxSurfacePressure
			}
		]
	];

	(* --- Output --- *)
	(* -- Define the rules for each possible Output value -- *)
	(* - Preview Rule - *)
	(*If it can be converted to Molar*)
	molarBool=MatchQ[Quiet[Unitless[Flatten[concentrations],Molar]],$Failed|{$Failed..}];

	minConcentrationUnitless=Min[If[
		molarBool,
		Unitless[Select[Flatten[concentrations],MatchQ[First[#],GreaterP[0]]&]],
		Unitless[Flatten[concentrations],Molar]
	]];
	maxConcentrationUnitless=Max[If[molarBool,
		Unitless[Flatten[concentrations]],
		Unitless[Flatten[concentrations],Molar]
	]];


	minConcentration=Min[Select[Flatten[concentrations],MatchQ[First[#],GreaterP[0]]&]];
	maxConcentration=Max[Flatten[concentrations]];

	(*If the region is empty, you return a Null result for the min and max of the fit, because the fit won't work*)
	preMicelleFitMin=If[molarBool,
		If[MatchQ[preMicellarFitExpression,Except[Null]],preMicellarFitExpression /. (x -> Log[Unitless[minConcentration]])],
		If[MatchQ[preMicellarFitExpression,Except[Null]],preMicellarFitExpression /. (x -> Log[Unitless[minConcentration, Molar]])]
	];

	preMicelleFitMax=If[molarBool,
		If[MatchQ[preMicellarFitExpression,Except[Null]],preMicellarFitExpression /. (x -> Log[Unitless[maxConcentration]])],
		If[MatchQ[preMicellarFitExpression,Except[Null]],preMicellarFitExpression /. (x -> Log[Unitless[maxConcentration, Molar]])]
	];


	postMicelleFitMin=If[molarBool,
		If[MatchQ[postMicellarFitExpression,Except[Null]],postMicellarFitExpression /. (x -> If[MatchQ[Units[minConcentration], ConcentrationP],Log[Unitless[minConcentration]],Log[Unitless[minConcentration]]])],
		If[MatchQ[postMicellarFitExpression,Except[Null]],postMicellarFitExpression /. (x -> If[MatchQ[Units[minConcentration], ConcentrationP],Log[Unitless[minConcentration, Molar]],Log[Unitless[minConcentration]]])]
	];

	postMicelleFitMax=If[molarBool,
		If[MatchQ[postMicellarFitExpression,Except[Null]],postMicellarFitExpression /. (x -> If[MatchQ[Units[maxConcentration], ConcentrationP],Log[Unitless[maxConcentration]],Log[Unitless[maxConcentration]]])],
		If[MatchQ[postMicellarFitExpression,Except[Null]],postMicellarFitExpression /. (x -> If[MatchQ[Units[maxConcentration], ConcentrationP],Log[Unitless[maxConcentration, Molar]],Log[Unitless[maxConcentration]]])]
	];

	previewRule=If[MemberQ[output,Preview],
		Preview->
				TabView[
					{
						"Surface Tension Curve"->Zoomable@PlotCriticalMicelleConcentration[
							analysisPacket,
							{preMicellarFit},
							{postMicellarFit}
						],
						"Fit Results"->Zoomable@PlotTable[
							{
								{"Critical Micelle Concentration",criticalMicelleConcentration},
								{"Apparent Partitioning Coefficient", apparentPartitioningCoefficient},
								{"Surface Excess Concentration", surfaceExcessConcentration},
								{"Cross Sectional Area", crossSectionalArea}
							},
							Alignment -> Center,
							Title->"Surface Tension Fit Results"
						],
						"Premicellar Fit"->If[MatchQ[preMicellarFit,Null],
							Null,
							Quiet[Zoomable@PlotFit[
								preMicellarFit,
								PlotLabel->"PreMicellar Fit",
								(*PlotRange->{{Log[minConcentrationUnitless]*1.1,Unitless[Min[Flatten[surfaceTensions]]]*0.9},{Log[maxConcentrationUnitless]*0.9,Unitless[Max[Flatten[surfaceTensions]]]*1.1}},*)
								FrameLabel->{Row@{"Log[Concentration (",concentrationUnits,")]"},"Surface Tension (mNewton/Meter)"}
							]]
						],
						"Fit Information"->Zoomable@PlotTable[
							{
								{"Best Fit Expression",preMicellarFitExpression},
								{"R-Squared",preMicellarRSquared}
							},
							Alignment -> Center,
							Title->"PreMicellar Fit Information"
						],
						"Postmicellar Fit"->If[MatchQ[postMicellarFit,Null],
							Null,
							Quiet[Zoomable@PlotFit[
								postMicellarFit,
								PlotLabel->"PostMicellar Fit",
								(*PlotRange -> {{Log[minConcentrationUnitless]*0.9},{Log[maxConcentrationUnitless]*0.9,Unitless[Max[Flatten[surfaceTensions]]]*1.1}},*)
								FrameLabel->{Row@{"Log[Concentration (",concentrationUnits,")]"},"Surface Tension (mNewton/Meter)"}
							]]
						],
						"Fit Information"->Zoomable@PlotTable[
							{
								{"Best Fit Expression",postMicellarFitExpression},
								{"R-Squared",postMicellarRSquared}
							},
							Alignment -> Center,
							Title->"PostMicellar Fit Information"
						],
						"Aliquot Samples" -> SlideView[
							(PlotTable[
								Prepend[#, {"Aliquot Samples", "Concentrations", "Surface Tensions"}],
								Alignment -> Center,
								Title -> "All Aliquot Samples, concentrations and surface tensions"] &)
									/@ Partition[
								MapThread[{#1, #2, #3} &,
									{aliquotSamplesObjects, Flatten[concentrations, 1], Flatten[surfaceTensions, 1]}
								],
								UpTo[10]
							],
							Alignment -> Center
						]
					},
					Alignment -> Center
				],
		Nothing
	];

	(* - Options Rule - *)
	optionsRule=Options->If[MemberQ[output,Options],
		RemoveHiddenOptions[AnalyzeCriticalMicelleConcentration,resolvedOptions],
		Null
	];

	(* - Tests Rule - *)
	allTests=Cases[
		Flatten[
			{
				safeOptionTests,
				resolvedOptionsTests,
				emptyPreMicellarRegionTests,
				emptyPostMicellarRegionTests,
				conflictingPostMicellarDomainUnitsTests,
				conflictingPreMicellarDomainUnitsTests,
				unableToConvertTests
			}
		],
		_EmeraldTest
	];

	(* Next, define the Tests Rule *)
	testsRule=Tests->If[MemberQ[output,Tests],
		allTests,
		Null
	];

	(* - Result Rule - *)
	(* First, upload the analysis object packet if upload is True *)
	analysisObject=If[upload&&MemberQ[output,Result],
		Upload[analysisPacket],
		{analysisPacket,preMicellarFit,postMicellarFit}
	];

	resultRule=Result->If[MemberQ[output,Result],
		Which[
			(* In the case where upload is True, return the uploaded analysis object *)
			upload,
			analysisObject,
			(* Otherwise, (Upload is false just return the analysis object packet *)
			True,
			{analysisObject}
		],
		Null
	];

	outputSpecification/.{
		optionsRule,
		resultRule,
		testsRule,
		previewRule
	}
];


(* ::Subsection:: *)
(*CriticalMicelleConcentrationPreview*)


DefineOptions[AnalyzeCriticalMicelleConcentrationPreview,
	SharedOptions:>{AnalyzeCriticalMicelleConcentration}
];

AnalyzeCriticalMicelleConcentrationPreview[myData:ObjectP[Object[Data,SurfaceTension]]|{ObjectP[Object[Data,SurfaceTension]]..}|ObjectP[Object[Protocol,MeasureSurfaceTension]]|{ObjectP[Object[Protocol,MeasureSurfaceTension]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions},

	listedOptions=ToList[myOptions];

	AnalyzeCriticalMicelleConcentration[myData,ReplaceRule[listedOptions,Output->Preview]]
];


(* ::Subsection:: *)
(*CriticalMicelleConcentrationOptions*)


DefineOptions[AnalyzeCriticalMicelleConcentrationOptions,
	SharedOptions :> {AnalyzeCriticalMicelleConcentration},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

AnalyzeCriticalMicelleConcentrationOptions[myData:ObjectP[Object[Data,SurfaceTension]]|{ObjectP[Object[Data,SurfaceTension]]..}|ObjectP[Object[Protocol,MeasureSurfaceTension]]|{ObjectP[Object[Protocol,MeasureSurfaceTension]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,noOutputOptions,options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions,Alternatives[Output->_,OutputFormat->_]];

	(* Get only the options for CriticalMicelleConcentration *)
	options=AnalyzeCriticalMicelleConcentration[myData,Append[noOutputOptions,Output->Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,AnalyzeCriticalMicelleConcentration],
		options
	]
];

(* ::Subsubsection:: *)
(*resolveAnalyzeCriticalMicelleConcentrationOptions*)

DefineOptions[resolveAnalyzeCriticalMicelleConcentrationOptions,
	Options:>{
		CacheOption,
		HelperOutputOption
	}
];

resolveAnalyzeCriticalMicelleConcentrationOptions[
	myDataObjs:{ObjectP[Object[Data,SurfaceTension]]..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[resolveAnalyzeCriticalMicelleConcentrationOptions]
]:=Module[
	{
		outputSpecification,output,gatherTests,messages,notInEngine, dataPackets,
		 aliquotSamples, samplesIn, diluent, dilutionFactors, temperatures, surfaceTensions,
		aliquotSamplesObjects, samplesInObjects, aliquotSamplesCompositions,aliquotSamplesMolecules, diluentMolecules,
		invalidTargetMoleculeOptions, targetMoleculeTest,missingExcludedSamples, excludedSamplesTest, mostCommonMoleculesNoWater,
		diluentSurfaceTensions,targetMoleculeConcentrations, targetMoleculeComposition, targetMoleculeUnits,
		diluentCompositions, samplePackets, sampleAnalytes, sampleAnalytesObjects, mostCommonSampleAnalytes,
		resolvedTargetMoleculeTest, samplesInPackets, resolvedExclude,
		smallestConcentrationSurfaceTension, resolveddiluentSurfaceTension, invalidResolvedTargetMoleculeOptions,
		solventCompositions,solventMolecules, sampleMolecules, resolvedpreMicellarRange,resolvedpostMicellarRange, stMin, stMax,
		conflictingDiluents,conflictingDiluentsTest, diluentPackets, diluentModels, resolvedtargetMolecule, unresolvabletargetMoleculeError,
		 targetMolecule, preMicellarRange,postMicellarRange, exclude, diluentSurfaceTension,
		 upload, invalidOptions,resolvedOptions, mostCommonMolecules, invalidDataPointsInputs, invalidInputs,
		allTests, testsRule,resultRule, dataPointsNumber, invalidDataPointsNumber, dataPointsNumberTest,
		emptyPostMicellarRegionTests,emptyPreMicellarRegionTests, emptyPreMicellarRegion,emptyPostMicellarRegion, diluentModelsObjects, aliquotSamplesCompositionsLinks,
		diluentCompositionsLinks, diluentObjects, invalidExcludeOption,lowSurfaceTensionsBools,lowSurfaceTensionsObjects,
		invalidPostmicellarSpan, postmicellarSpan, postmicellarSpanTest, invalidPremicellarSpan, premicellarSpan,
		premicellarSpanTest, myOptionsAssociation, suppliedCache, preMicellarDomain, postMicellarDomain, missingPostmicellarSpan, missingPremicellarSpan,
		missingpostmicellarSpanTest, missingpremicellarSpanTest, dataSamplesMoleculesFlat, dataSamplesMolecules, optionObjects, objectCache, lowSurfaceTensions
	},

	(*---Set up the user-specified options and cache---*)


	(*Determine the requested return value from the function*)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(*Determine if we should keep a running list of tests*)
	gatherTests=MemberQ[output,Tests];
	messages=!gatherTests;

	(*Convert list of rules to Association so we can Lookup, Append, Join as usual*)
	myOptionsAssociation=Association[myOptions];
	suppliedCache=Lookup[Association[myResolutionOptions],Cache,{}];

	optionObjects=DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				Lookup[myOptionsAssociation,{TargetMolecules,Exclude}]
			],
			ObjectP[]
		],
		Object
	];

	(* -- Assemble big download -- *)

		objectCache =Experiment`Private`FlattenCachePackets[{
			suppliedCache,
			Quiet[Download[
				{optionObjects},
				{Packet[Object]}],
				Download::FieldDoesntExist]
		}];

	(* - Pull out the supplied options from myOptionsAssociation - *)
	{
		targetMolecule, preMicellarRange, postMicellarRange, preMicellarDomain, postMicellarDomain,exclude, diluentSurfaceTension, upload
	}=Lookup[myOptionsAssociation,
		{
			TargetMolecules, PreMicellarRange,PostMicellarRange, PreMicellarDomain, PostMicellarDomain,Exclude, DiluentSurfaceTension, Upload
		}
	];


	(* Pull out the relevant packets from the listed packets *)
dataPackets=	suppliedCache[[All,1]];
diluentPackets=	suppliedCache[[All,2]];
samplePackets=	suppliedCache[[All,3]];
solventCompositions=suppliedCache[[All,4]];
samplesInPackets=suppliedCache[[All,5]];

(* - Next, pull our relevant fields from the Data Objects - *)
{
	samplesIn, aliquotSamples, dilutionFactors, temperatures, surfaceTensions, diluent
}=Transpose[Lookup[dataPackets,
	{
		SamplesIn, AliquotSamples, DilutionFactors, Temperatures, SurfaceTensions, Diluent
	}
]];

	(* replace any nulls in surface tension with zeros *)
	surfaceTensions = ReplaceAll[surfaceTensions, Null->0. Milli Newton/Meter];

(* - Next, pull our relevant fields from the diluent Objects - *)
	diluentModels=(If[MatchQ[#,Null],Null,Lookup[#, Model]]&/@diluentPackets)/. (_?MissingQ :> Null);

	diluentCompositionsLinks =(If[MatchQ[#,Null],Null,Lookup[#, Composition]]&/@diluentPackets)/. (_?MissingQ :> Null);

	diluentSurfaceTensions =(If[MatchQ[#,Null],Null,Lookup[#, SurfaceTension]]&/@diluentPackets)/. (_?MissingQ :> Nothing)/. (Null :> Nothing);

(* - Next, pull our relevant fields from the aliquot Objects - *)

aliquotSamplesCompositionsLinks =Lookup[#, Composition]&/@samplePackets/. (_?MissingQ :> Null);

sampleAnalytes =Lookup[#, Analytes]&/@samplePackets/. (_?MissingQ :> Nothing);


(*convert the Link[Object] and compositions into Objects*)
diluentObjects=Download[diluent,Object];
samplesInObjects=Download[Cases[Flatten[samplesIn,1],ObjectP[]],Object];
aliquotSamplesObjects=Download[Cases[Flatten[aliquotSamples,1],ObjectP[]],Object];
diluentModelsObjects=Download[diluentModels,Object];
sampleAnalytesObjects=Download[Cases[Flatten[sampleAnalytes,2],ObjectP[]],Object];
diluentCompositions=diluentCompositionsLinks/. {x : LinkP[] :> Link[x]};
aliquotSamplesCompositions=aliquotSamplesCompositionsLinks/. {x : LinkP[] :> Link[x]};
aliquotSamplesMolecules=#[[All, 2]]&/@Flatten[aliquotSamplesCompositions,1];

	(*Invalid Input checks*)
	(*Error::InsuffientDataPointNumber*)
	dataPointsNumber=Length[Flatten[surfaceTensions]];

	invalidDataPointsInputs=If[dataPointsNumber<3,
		Message[Error::InsuffientDataPoints, ToString[dataPointsNumber]];
		myDataObjs,
		{}
	];

	(* If we are gathering tests, define the passing and failing tests *)
	dataPointsNumberTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[invalidDataPointsInputs]>0,
				Test["There are enough data points present to fit",True,False],
				Nothing
			];
			passingTest=If[Length[invalidDataPointsInputs]==0,
				Test["There are enough data points present to fit",True,True],
				Nothing
			];

			{failingTest,passingTest}
		],
		Nothing
	];

(*Invalid Options Checks*)
(* -- Here, figure out if we need to throw Errors and return failed -- *)
(* - Check to see if the given target molecule is present in the samples, if not, throw error MissingTargetMolecules *)
invalidTargetMoleculeOptions=If[MatchQ[targetMolecule,Except[Automatic]]&&!AnyTrue[aliquotSamplesMolecules,MemberQ[#,ObjectP[targetMolecule]]&],
	{TargetMolecules},
	{}
];

(* If are throwing messages, throw an Error*)
If[messages&&Length[invalidTargetMoleculeOptions]>0,
	Message[Error::MissingTargetMolecules,ECL`InternalUpload`ObjectToString[targetMolecule, Cache->objectCache], ECL`InternalUpload`ObjectToString[PickList[aliquotSamplesObjects,!MemberQ[#,ObjectP[targetMolecule]]&/@aliquotSamplesMolecules]], Cache->objectCache]
];

(* If we are gathering tests, define the passing and failing tests *)
targetMoleculeTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[invalidTargetMoleculeOptions]==0,
			Nothing,
			Test["The TargetMolecules are present in the samples",True,False]
		];
		passingTest=If[Length[invalidTargetMoleculeOptions]>0,
			Nothing,
			Test["The TargetMolecules are present in the samples",True,True]
		];

		{failingTest,passingTest}
	],
	Nothing
];

(*invalid spans, check if the span if only a span or domain was given, not both*)
invalidPremicellarSpan=If[MatchQ[preMicellarRange,Except[Automatic|Null]]&&MatchQ[preMicellarDomain,Except[Null]],
	If[messages,Message[Error::ConflictingPreMicellarDomain,ToString[preMicellarDomain], ToString[preMicellarRange]]];
	{PreMicellarRange, PreMicellarDomain},
	{}
];

premicellarSpanTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[invalidPremicellarSpan]>0,
			Test["Only PreMicellarRange or PreMicellarDomain are set",True,False],
			Nothing
		];
		passingTest=If[Length[invalidPremicellarSpan]==0,
			Test["Only PreMicellarRange or PreMicellarDomain are set",True,True],
			Nothing
		];
		{failingTest,passingTest}
	],
	Nothing
];

invalidPostmicellarSpan=If[MatchQ[postMicellarRange,Except[Automatic|Null]]&&MatchQ[postMicellarDomain,Except[Null]],
	If[messages,Message[Error::ConflictingPostMicellarDomain,ToString[postMicellarDomain], ToString[postMicellarRange]]];
	{PostMicellarRange, PostMicellarDomain},
	{}
];

postmicellarSpanTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[invalidPostmicellarSpan]>0,
			Test["Only PostMicellarRange or PostMicellarDomain are set",True,False],
			Nothing
		];
		passingTest=If[Length[invalidPremicellarSpan]==0,
			Test["Only PostMicellarRange or PostMicellarDomain are set",True,True],
			Nothing
		];
		{failingTest,passingTest}
	],
	Nothing
];

	(*missing spans, check if the span if only a span or domain was given, not both*)
	missingPremicellarSpan=If[MatchQ[preMicellarRange,Null]&&MatchQ[preMicellarDomain,Null],
		If[messages,Message[Error::MissingPreMicellarDomain,ToString[preMicellarDomain], ToString[preMicellarRange]]];
		{PreMicellarRange, PreMicellarDomain},
		{}
	];

	missingpremicellarSpanTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingPremicellarSpan]>0,
				Test["One of PreMicellarRange or PreMicellarDomain are set",True,False],
				Nothing
			];
			passingTest=If[Length[missingPremicellarSpan]==0,
				Test["one of PreMicellarRange or PreMicellarDomain are set",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];

	missingPostmicellarSpan=If[MatchQ[postMicellarRange,Null]&&MatchQ[postMicellarDomain,Null],
		If[messages,Message[Error::MissingPostMicellarDomain,ToString[postMicellarDomain], ToString[postMicellarRange]]];
		{PostMicellarRange, PostMicellarDomain},
		{}
	];

	missingpostmicellarSpanTest=If[gatherTests,
		Module[{failingTest,passingTest},
			failingTest=If[Length[missingPostmicellarSpan]>0,
				Test["Only PostMicellarRange or PostMicellarDomain are set",True,False],
				Nothing
			];
			passingTest=If[Length[missingPostmicellarSpan]==0,
				Test["Only PostMicellarRange or PostMicellarDomain are set",True,True],
				Nothing
			];
			{failingTest,passingTest}
		],
		Nothing
	];


(*If the Excluded samples are not present in the data, throw a warning*)
missingExcludedSamples=If[MatchQ[exclude,Except[Null|Automatic]]&&AnyTrue[exclude,!MemberQ[aliquotSamplesObjects,#]&],
	PickList[exclude,!MemberQ[aliquotSamplesObjects,#]&/@exclude],
	{}
];

invalidExcludeOption=If[Length[missingExcludedSamples]>0,
	Exclude,
	Nothing
];

If[messages&&Length[missingExcludedSamples]>0,
	Message[Error::MissingExcludedSamples, ECL`InternalUpload`ObjectToString[missingExcludedSamples, Cache->objectCache]]
];

(* If we are gathering tests, define the passing and failing tests *)
excludedSamplesTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[missingExcludedSamples]==0,
			Nothing,
			Test["The Exclude samples is present in the data objects",True,False]
		];
		passingTest=If[Length[missingExcludedSamples]>0,
			Nothing,
			Test["The Exclude samples is present in the data objects",True,True]
		];

		{failingTest,passingTest}
	],
	Nothing
];
	lowSurfaceTensionsBools=MatchQ[#,RangeP[0Milli Newton/ Meter,10Milli Newton/ Meter]]&/@Flatten[surfaceTensions];
	lowSurfaceTensions=PickList[Flatten[surfaceTensions],lowSurfaceTensionsBools];
	lowSurfaceTensionsObjects=PickList[aliquotSamplesObjects,lowSurfaceTensionsBools];

	resolvedExclude=Which[
		MatchQ[exclude,Except[Automatic]],
		exclude,
		Length[lowSurfaceTensionsObjects]>0,
		lowSurfaceTensionsObjects,
		True,
		Null
	];


	(*If the inputed data packets have different diluents, throw a warning*)

conflictingDiluents=If[MatchQ[DeleteCases[diluentCompositions,Null],Except[{}]]&&MemberQ[DeleteCases[diluentCompositions,Null],Except[First[DeleteCases[diluentCompositions,Null]]]],
	DeleteCases[diluentObjects,Null],
	{}
];

If[messages&&Length[conflictingDiluents]>0,
	Message[Warning::ConflictingDiluents, ECL`InternalUpload`ObjectToString[conflictingDiluents, Cache->objectCache]]
];

(* If we are gathering tests, define the passing and failing tests *)
conflictingDiluentsTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[conflictingDiluents]==0,
			Nothing,
			Test["The diluent in each data object has the same model",True,False]
		];
		passingTest=If[Length[conflictingDiluents]>0,
			Nothing,
			Test["The diluent in each data object has the same model",True,True]
		];

		{failingTest,passingTest}
	],
	Nothing
];

(* -- Resolve the options -- *)
(*Resolve the Target Molecule*)

(*look for most common at Model[Molecule]s*)
mostCommonMolecules=Sort[
	Tally[DeleteCases[Flatten[aliquotSamplesMolecules],Null]],
	#1[[2]] > #2[[2]] &];

(*remove water*)
mostCommonMoleculesNoWater=DeleteCases[mostCommonMolecules,{ObjectP[Model[Molecule,"id:vXl9j57PmP5D"]],_Integer|Null}];

(*find the diluent and solvent models*)
diluentMolecules=If[Length[#] == 1, #[[1, 2]], Nothing] & /@diluentCompositions;
(* Handle Null Solvent properly *)
solventMolecules=If[Length[#] == 1 && !MatchQ[#,{Null}], #[[1, 2]], Nothing] & /@solventCompositions; (* TODO: Maybe needs to be a flatten *)

(*remove them from list of molecules*)
sampleMolecules=DeleteCases[mostCommonMoleculesNoWater,{Alternatives[ObjectP@Join[diluentMolecules,solventMolecules]],_Integer}];

(*look for most common at Analytes*)

mostCommonSampleAnalytes=Sort[Tally[sampleAnalytesObjects], #1[[2]] > #2[[2]] &];

resolvedtargetMolecule=Download[Which[
	(*If the target molecule was given by the user*)
	MatchQ[targetMolecule,Except[Automatic]],targetMolecule,
	(*look for populated Analytes fields*)
	MatchQ[mostCommonSampleAnalytes,Except[{}]],{mostCommonSampleAnalytes[[1,1]]},
	(*look for molecules that are not water, solvent, or diluent*)
	MatchQ[sampleMolecules,Except[{}]],{sampleMolecules[[1,1]]},
	(*look for any molecules*)
	MatchQ[mostCommonMolecules,Except[{}]],{mostCommonMolecules[[1,1]]},
	(*If there are no molecules*)
	True, Null
],Object];

(*throw an error if the target molecule can't not be resolved*)
unresolvabletargetMoleculeError=MatchQ[mostCommonMolecules,{}];

invalidResolvedTargetMoleculeOptions=If[unresolvabletargetMoleculeError,
	Message[Error::UnresolvableTargetMolecules];
	{TargetMolecules},
	{}
];

resolvedTargetMoleculeTest=If[gatherTests,
	Module[{failingTest,passingTest},
		failingTest=If[Length[invalidResolvedTargetMoleculeOptions]==0,
			Nothing,
			Test["There is a Model[Molecule] in AliquotSamples:",True,False]
		];
		passingTest=If[Length[invalidResolvedTargetMoleculeOptions]>0,
			Nothing,
			Test["There is a Model[Molecule] in AliquotSamples:",True,True]
		];

		{failingTest,passingTest}
	],
	Nothing
];

	dataSamplesMolecules=Map[#[[All, 2]]&,aliquotSamplesCompositions,{2}];

	dataSamplesMoleculesFlat=DeleteDuplicates[Flatten[#,1]]&/@dataSamplesMolecules;


(*The maximum surface tension value*)
stMax=Max[Flatten[surfaceTensions]];

(*The minimum surface tension value*)
stMin=Min[Complement[Flatten[surfaceTensions],lowSurfaceTensions]];

(*Use the min and max surface tension values to resolve the fitting Ranges*)
resolvedpreMicellarRange=Which[
	MatchQ[preMicellarRange,Except[Automatic]],
	preMicellarRange,
	MatchQ[preMicellarDomain,Except[Null]],
	Null,
	True,
	SafeRound[stMin + (stMax - stMin)*0.1,0.001 Milli Newton/Meter];;SafeRound[stMin + (stMax - stMin)*0.6,0.001 Milli Newton/Meter]
];


resolvedpostMicellarRange=Which[
	MatchQ[postMicellarRange,Except[Automatic]],
	postMicellarRange,
	MatchQ[postMicellarDomain,Except[Null]],
	Null,
	True,
	SafeRound[stMin,0.001 Milli Newton/Meter];;SafeRound[stMin + (stMax - stMin)*0.1, 0.001 Milli Newton/Meter]
];


(*Resolve the surface tension of the diluent*)
resolveddiluentSurfaceTension=Which[
	(*user provided*)
	MatchQ[diluentSurfaceTension,Except[Automatic]],diluentSurfaceTension,
	(*Does the diluent have a populated ST value?*)
	(*average diluent ST value*)
	MatchQ[diluentSurfaceTensions,Except[{}|{Null...}|Null]],Mean[ToList[diluentSurfaceTensions]],
	(*ST of water*)
	True,Download[Model[Sample, "Milli-Q water"],SurfaceTension]
];

	(* Define the Invalid Options *)
	invalidInputs=DeleteDuplicates[Flatten[
		{
			invalidDataPointsInputs
		}
	]];

	(*Throw Error::InvalidInput if there are invalid options*)
	If[Length[invalidInputs]>0&&messages,
		Message[Error::InvalidInput,invalidInputss]
	];

	(* Define the Invalid Options *)
	invalidOptions=DeleteDuplicates[Flatten[
		{
			invalidResolvedTargetMoleculeOptions,invalidTargetMoleculeOptions, invalidExcludeOption,invalidPremicellarSpan,invalidPostmicellarSpan, missingPostmicellarSpan, missingPremicellarSpan
		}
	]];

	(*Throw Error::InvalidOption if there are invalid options*)
	If[Length[invalidOptions]>0&&messages,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*Gather the resolved options*)
	resolvedOptions=ReplaceRule[
		myOptions,
		{
			TargetMolecules->resolvedtargetMolecule,
			PostMicellarRange->resolvedpostMicellarRange,
			PreMicellarRange->resolvedpreMicellarRange,
			PostMicellarDomain->postMicellarDomain,
			PreMicellarDomain->preMicellarDomain,
			DiluentSurfaceTension->resolveddiluentSurfaceTension,
			Exclude->resolvedExclude
		}
	];

	(*Gather the tests*)
	allTests=Cases[Flatten[{targetMoleculeTest, excludedSamplesTest, conflictingDiluentsTest,resolvedTargetMoleculeTest,
		premicellarSpanTest,postmicellarSpanTest, dataPointsNumberTest, missingpremicellarSpanTest, missingpostmicellarSpanTest}
	],_EmeraldTest];

	(*Generate the result output rule: if not returning result, result rule is just Null*)
	resultRule=Result->If[MemberQ[output,Result],
		resolvedOptions,
		Null
	];

	(*Generate the tests output rule*)
	testsRule=Tests->If[gatherTests,
		allTests,
		Null
	];


	(*Return the output as we desire it*)
	outputSpecification/.{resultRule,testsRule}
];

(* ::Subsection:: *)
(*ValidAnalyzeCriticalMicelleConcentrationQ*)


DefineOptions[ValidAnalyzeCriticalMicelleConcentrationQ,
	Options:>
			{
				VerboseOption,
				OutputFormatOption
			},
	SharedOptions:>{AnalyzeCriticalMicelleConcentration}
];

ValidAnalyzeCriticalMicelleConcentrationQ[myData:ObjectP[Object[Data,SurfaceTension]]|{ObjectP[Object[Data,SurfaceTension]]..}|ObjectP[Object[Protocol,MeasureSurfaceTension]]|{ObjectP[Object[Protocol,MeasureSurfaceTension]]..},myOptions:OptionsPattern[]]:=Module[
	{listedOptions,preparedOptions,AnalyzeCriticalMicelleConcentrationTests,initialTestDescription,allTests,verbose,outputFormat},

	(* Get the options as a list *)
	listedOptions=ToList[myOptions];

	(* Remove the output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions,(Output|Verbose|OutputFormat)->_];

	(* Return only the tests for AnalyzeCriticalMicelleConcentration *)
	AnalyzeCriticalMicelleConcentrationTests=Quiet[AnalyzeCriticalMicelleConcentration[myData,Append[preparedOptions,Output->Tests]]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* Make a list of all of the tests, including the blanket test *)
	allTests=If[MatchQ[AnalyzeCriticalMicelleConcentrationTests,$Failed],
		{Test[initialTestDescription,False,True]},
		Module[
			{initialTest,validObjectBooleans,voqWarnings},

			(* Generate the initial test, which we know will pass if we got this far (hopefully) *)
			initialTest=Test[initialTestDescription,True,True];

			(* Create warnings for invalid objects *)
			validObjectBooleans=ValidObjectQ[DeleteCases[ToList[myData],_String],OutputFormat->Boolean];

			voqWarnings=MapThread[
				Warning[StringJoin[ToString[#1,InputForm]," is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[ToList[myData],_String],validObjectBooleans}
			];

			(* Get all the tests/warnings *)
			Flatten[{initialTest,AnalyzeCriticalMicelleConcentrationTests,voqWarnings}]
		]
	];


	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose,outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose,OutputFormat}]],OptionValue::nodef];

	(* Run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidAnalyzeCriticalMicelleConcentrationQ"->allTests|>,OutputFormat->outputFormat,Verbose->verbose],"ValidAnalyzeCriticalMicelleConcentrationQ"]
];
