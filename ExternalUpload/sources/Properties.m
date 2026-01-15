(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*UploadSampleProperties*)

(* ::Subsection::Closed:: *)
(*UploadSampleProperties Options and Messages*)

DefineOptions[UploadSampleProperties,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Density,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterP[0 Gram / Liter]),Units -> {Gram / Liter,{Gram / Liter,Milligram / Milliliter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "Known density of samples of this model at room temperature. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> pH,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Number,Pattern :> RangeP[0,14]],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The logarithmic concentration of hydrogen ions of the substance at room temperature. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Concentration,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Molar]),Units -> {Molar,{Micromolar,Millimolar,Molar}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The concentration to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> MassConcentration,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Gram / Liter]),Units -> {Gram / Liter,{Milligram / Liter,Gram / Liter,Milligram / Milliliter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The mass concentration to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> TotalProteinConcentration,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Gram / Liter]),Units -> {Gram / Liter,{Milligram / Liter,Gram / Liter,Milligram / Milliliter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The total protein concentration to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> SurfaceTension,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Milli Newton / Meter]),Units -> Milli Newton / Meter],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The surface tension of the substance in pure form at room temperature. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Mass,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Gram]),Units -> {Gram,{Milligram,Gram,Kilogram}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The weight to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Volume,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 Milliliter]),Units -> {Milliliter,{Microliter,Milliliter,Liter}}],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The volume to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Count,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Number,Pattern :> (GreaterEqualP[0,1])],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The count to which the sample should be set. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Conductivity,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Expression,Pattern :> DistributionP[Micro Siemens / Centimeter],Size -> Line],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The conductivity of the substance. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Viscosity,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Quantity,Pattern :> ( GreaterEqualP[0 (Milli * Pascal * Second)]),Units -> (Milli * Pascal * Second)],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The viscosity of the substance in pure form at room temperature. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> RefractiveIndex,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					Widget[Type -> Expression,Pattern :> (GreaterP[1] | DistributionP[]),Size -> Line],
					Widget[Type -> Enumeration,Pattern :> Alternatives[None]]
				],
				Description -> "The refractive index of the substance at 20 degree Celsius. If None is specified, the field value will be set to Null.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> RefractiveIndexReadingMode,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Widget[Type -> Enumeration,Pattern :> ( FixedMeasurement | TemperatureScan | TimeScan)],
				Description -> "The refractive index reading mode of the sample.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Temperature,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Alternatives[
					"Distribution" -> Widget[Type -> Expression,Pattern :> DistributionP,Size -> Line],
					"Temperature" -> Widget[Type -> Quantity,Pattern :> GreaterP[0 Celsius],Units -> {Celsius,{Celsius,Kelvin,Fahrenheit}}]
				],
				Description -> "The temperature setting used to measure refractive index of the sample.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Trajectories,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Adder[{
					"Time" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 * Minute,$MaxExperimentTime],
						Units -> {1,{Minute,{Minute,Second,Hour}}}
					],
					"Refractive Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[1]
					]
				}],
				Description -> "The time trajectories of refractive index of the sample.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> TemperatureProfiles,
				Default -> Null,
				AllowNull -> True,
				HideNull -> False,
				Widget -> Adder[{
					"Temperature" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Celsius],
						Units -> {Celsius,{Celsius,Kelvin,Fahrenheit}}
					],
					"Refractive Index" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[1]
					]
				}],
				Description -> "The temperature profiles of refractive index of the sample as the temperature changes.",
				Category -> "Physical Properties"
			}
		],
		{
			OptionName -> Date,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Widget[Type -> Date,Pattern :> _?DateObjectQ,TimeSelector -> False],
			Description -> "Indicates the timestamp at which the property of the sample(s) changes should be logged.",
			Category -> "Hidden"
		},
		{
			OptionName -> UpdatedBy,
			Default -> $PersonID,
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Flatten@{Object[User],ProtocolTypes[]}]],
			Description -> "The person or protocol responsible for uploading the new samples. The directly responsible protocol should provided; the root protocol will be automatically fetched for any updates requiring it.",
			Category -> "Hidden"
		},
		SimulationOption,
		UploadOption,
		OutputOption
	}
];

UploadSampleProperties::CannotUploadSimulation = "Upload cannot be specified as True when Simulation option is not Null.";

(* Singleton overload *)
UploadSampleProperties[mySample : ObjectP[{Object[Sample],Object[Item]}],ops : OptionsPattern[]] := Module[
	{safeOps,output,uploadQ,returnValue},

	(*pull out the options*)
	safeOps = SafeOptions[UploadSampleProperties,ToList[ops]];
	{output,uploadQ} = Lookup[safeOps,{Output,Upload}];

	(*call the core listable function*)
	returnValue = UploadSampleProperties[{mySample},ops];

	(*pull out the return as if we had a singleton function instead of the listable function*)
	Which[
		MatchQ[returnValue,$Failed],
		$Failed,
		
		(*De-listablize output if it didn't fail*)
		MatchQ[uploadQ,False],
		returnValue,

		uploadQ,
		First[returnValue],

		(*in all other cases - return as is, we can not automatically strip things down; no idea how we can get here but just be safe*)
		True,
		returnValue
	]
];

(* Core, listed overload *)
UploadSampleProperties[myInputObjects : {ObjectP[{Object[Sample],Object[Item]}]...},ops : OptionsPattern[]] := Module[
	{
		outputSpecification,listedInputs,listedOptions,safeOptionsNamed,safeOpsTests,safeInputs,inputUpdates,
		safeOps,uploadQ,dateOption,date,updatedBy,inputPackets,indexMatchedOptions,expandedOptions,
		resolvedOptions,simulation,uploadPacketsWithValid,intensivePropertyUpdates,output,gatherTests,
		validLengths,validLengthTests,fieldValuesToDownload,mapThreadFriendlyOptions,result,resolvedOptionsAssociations,
		collapsedResolvedOptions
	},

	(* If no samples were passed in, do not update anything *)
	If[Length[myInputObjects] == 0,
		Return[{}]
	];

	(*we don't have safe options yet, but we need to know if we are gatherting tests, so pull things out now*)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output,Tests];

	(* Make sure we're working with a list of options and samples, and remove all temporal links *)
	{listedInputs,listedOptions} = Experiment`Private`removeLinks[ToList[myInputObjects],ToList[ops]];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed,safeOpsTests} = If[gatherTests,
		SafeOptions[UploadSampleProperties,listedOptions,AutoCorrect -> False,Output -> {Result,Tests}],
		{SafeOptions[UploadSampleProperties,listedOptions,AutoCorrect -> False],{}}
	];

	(* Lookup and set user defined options to local variables *)
	simulation = Lookup[safeOptionsNamed,Simulation];

	(* Replace all objects referenced by Name to ID *)
	{safeInputs,safeOps} = Experiment`Private`sanitizeInputs[listedInputs,safeOptionsNamed,Simulation -> simulation];

	(*pull out options into the variables*)
	{uploadQ,dateOption,updatedBy} = Lookup[safeOps,{Upload,Date,UpdatedBy}];

	(* If dateOption is a proper date object, use that. Else, use Now as the default *)
	date = If[DateObjectQ[dateOption],dateOption,Now];

	(* No upload if simulation is provided *)
	If[MatchQ[{uploadQ,simulation},{True,_Simulation}],
		Message[UploadSampleProperties::CannotUploadSimulation];
		Return[$Failed]
	];

	(*we assume here that all of the index-matched options that we have will be named the same as the field names with small differences*)
	fieldValuesToDownload = Module[{fieldsFromOptions},
		fieldsFromOptions = OptionsHandling`Private`extractIndexMatchingOptions[UploadSampleProperties];
		Packet @@ Flatten@{
			fieldsFromOptions,
			(*we always need composition for intensive properties updates as well as refractive index log - we parse it later on*)
			{Composition,RefractiveIndexLog, Notebook}
		}
	];

	(* Download the composition field from our samples. Also get the notebook *)
	inputPackets = Quiet[
		Download[safeInputs,fieldValuesToDownload,Simulation -> simulation],
		{Download::FieldDoesntExist, Download::MissingField}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[UploadSampleProperties,{safeInputs},safeOps,Output -> {Result,Tests}],
		{ValidInputLengthsQ[UploadSampleProperties,{safeInputs},safeOps],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests,validLengthTests}],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* These options need to be already index-matching or expanded to index match safeSamples *)
	indexMatchedOptions = {Density,pH,Concentration,MassConcentration,Mass,Volume,Count,TotalProteinConcentration,SurfaceTension,Conductivity,Viscosity,RefractiveIndexReadingMode,RefractiveIndex,Temperature,Trajectories,TemperatureProfiles};

	(* expand our options *)
	expandedOptions = Last@ExpandIndexMatchedInputs[UploadSampleProperties,{safeInputs},safeOps];

	(*convert the options to the map-thread-firendly format*)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[UploadSampleProperties,expandedOptions];

	(*construct the update to the fields of the samples and intensive properties*)
	{inputUpdates,intensivePropertyUpdates,resolvedOptionsAssociations} = Transpose@MapThread[Function[{packet,options},Module[
		{
			inputUpdate,intensivePropertyUpdate,
			specifiedDensity,specifiedpH,specifiedConcentration,specifiedMassConcentration,specifiedTotalProteinConcentration,
			specifiedSurfaceTension,specifiedConductivity,specifiedViscosity,specifiedMass,specifiedVolume,specifiedCount,
			specifiedRefractiveIndexReadingMode,specifiedRefractiveIndex,specifiedTemperature,specifiedTrajectories,specifiedTemperatureProfiles,
			densityUpdate,pHUpdate,concentrationUpdate,massConcentrationUpdate,totalProteinConcentrationUpdate,
			surfaceTensionUpdate,conductivityUpdate,viscosityUpdate,massUpdate,volumeUpdate,countUpdate,
			refractiveIndexUpdate,densityIntensivePropertyUpdate,pHIntensivePropertyUpdate,totalProteinConcentrationIntensivePropertyUpdate,
			surfaceTensionIntensivePropertyUpdate,conductivityIntensivePropertyUpdate,viscosityIntensivePropertyUpdate,refractiveIndexIntensivePropertyUpdate,
			resolvedOptionsLocalAssociation
		},

		(*pull out all the options that are specified*)
		{
			specifiedDensity,specifiedpH,specifiedConcentration,specifiedMassConcentration,specifiedTotalProteinConcentration,
			specifiedSurfaceTension,specifiedConductivity,specifiedViscosity,specifiedMass,specifiedVolume,specifiedCount,
			specifiedRefractiveIndexReadingMode,specifiedRefractiveIndex,specifiedTemperature,specifiedTrajectories,specifiedTemperatureProfiles
		} =
			Lookup[options,{
				Density,pH,Concentration,MassConcentration,TotalProteinConcentration,
				SurfaceTension,Conductivity,Viscosity,Mass,Volume,Count,
				RefractiveIndexReadingMode,RefractiveIndex,Temperature,Trajectories,TemperatureProfiles
			}];

		(* Build density update *)
		densityUpdate = Switch[specifiedDensity,
			None,
			Association[
				Density -> Null,
				Append[DensityLog] -> {{date,Null,Link[updatedBy]}}
			],
			DensityP,
			Association[
				Density -> specifiedDensity,
				Append[DensityLog] -> {{date,specifiedDensity,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		densityIntensivePropertyUpdate = uploadIntensiveProperty[packet,Density,specifiedDensity];

		(* Build pH update *)
		pHUpdate = Switch[specifiedpH,
			None,
			Association[
				pH -> Null,
				Append[pHLog] -> {{date,Null,Link[updatedBy]}}
			],
			pHP,
			Association[
				pH -> specifiedpH,
				Append[pHLog] -> {{date,specifiedpH,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		pHIntensivePropertyUpdate = uploadIntensiveProperty[packet,pH,specifiedpH];

		(* Build Concentration update *)
		concentrationUpdate = Switch[specifiedConcentration,
			None,
			Association[
				Concentration -> Null,
				Append[ConcentrationLog] -> {{date,Null,Link[updatedBy]}}
			],
			ConcentrationP,
			Association[
				Concentration -> specifiedConcentration,
				Append[ConcentrationLog] -> {{date,specifiedConcentration,Link[updatedBy]}}
			],
			_,
			Association[]
		];

		(* Build MassConcentration update *)
		massConcentrationUpdate = Switch[specifiedMassConcentration,
			None,
			Association[
				MassConcentration -> Null,
				Append[MassConcentrationLog] -> {{date,Null,Link[updatedBy]}}
			],
			MassConcentrationP,
			Association[
				MassConcentration -> specifiedMassConcentration,
				Append[MassConcentrationLog] -> {{date,specifiedMassConcentration,Link[updatedBy]}}
			],
			_,
			Association[]
		];

		(* Build TotalProteinConcentration update *)
		totalProteinConcentrationUpdate = Switch[specifiedTotalProteinConcentration,
			None,
			Association[
				TotalProteinConcentration -> Null,
				Append[TotalProteinConcentrationLog] -> {{date,Null,Link[updatedBy]}}
			],
			MassConcentrationP,
			Association[
				TotalProteinConcentration -> specifiedTotalProteinConcentration,
				Append[TotalProteinConcentrationLog] -> {{date,specifiedTotalProteinConcentration,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		totalProteinConcentrationIntensivePropertyUpdate = uploadIntensiveProperty[packet,TotalProteinConcentration,specifiedTotalProteinConcentration];

		(* Build SurfaceTension update *)
		surfaceTensionUpdate = Switch[specifiedSurfaceTension,
			None,
			Association[
				SurfaceTension -> Null,
				Append[SurfaceTensionLog] -> {{date,Null,Link[updatedBy]}}
			],
			GreaterEqualP[0 * Milli Newton / Meter],
			Association[
				SurfaceTension -> specifiedSurfaceTension,
				Append[SurfaceTensionLog] -> {{date,specifiedSurfaceTension,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		surfaceTensionIntensivePropertyUpdate = uploadIntensiveProperty[packet,SurfaceTension,specifiedSurfaceTension];

		(* Build Conductivity update *)
		conductivityUpdate = Switch[specifiedConductivity,
			None,
			Association[
				Conductivity -> Null,
				Append[ConductivityLog] -> {{date,Null,Link[updatedBy]}}
			],
			DistributionP[Micro Siemens / Centimeter],
			Association[
				Conductivity -> specifiedConductivity,
				Append[ConductivityLog] -> {{date,specifiedConductivity,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		conductivityIntensivePropertyUpdate = uploadIntensiveProperty[packet,Conductivity,specifiedConductivity];

		(* Build Mass update *)
		massUpdate = Switch[specifiedMass,
			None,
			Association[
				Mass -> Null,
				Append[MassLog] -> {{date,Null,Link[updatedBy],ComputedWeight}}
			],
			MassP,
			Association[
				Mass -> specifiedMass,
				Append[MassLog] -> {{date,specifiedMass,Link[updatedBy],ComputedWeight}}
			],
			_,
			Association[]
		];

		(* Build Volume update *)
		volumeUpdate = Switch[specifiedVolume,
			None,
			Association[
				Volume -> Null,
				Append[VolumeLog] -> {{date,Null,Link[updatedBy],ComputedVolume}}
			],
			VolumeP,
			Association[
				Volume -> specifiedVolume,
				Append[VolumeLog] -> {{date,specifiedVolume,Link[updatedBy],ComputedVolume}}
			],
			_,
			Association[]
		];

		(* Build Count update *)
		countUpdate = Switch[specifiedCount,
			None,
			Association[
				Count -> Null,
				Append[CountLog] -> {{date,Null,Link[updatedBy]}}
			],
			_Integer,
			Association[
				Count -> specifiedCount,
				Append[CountLog] -> {{date,specifiedCount,Link[updatedBy]}}
			],
			_,
			Association[]
		];

		(* Build Viscosity update *)
		viscosityUpdate = Switch[specifiedViscosity,
			None,
			Association[
				Viscosity -> Null,
				Append[ViscosityLog] -> {{date,Null,Link[updatedBy]}}
			],
			GreaterEqualP[0 (Milli * Pascal) * Second],
			Association[
				Viscosity -> specifiedViscosity,
				Append[ViscosityLog] -> {{date,specifiedViscosity,Link[updatedBy]}}
			],
			_,
			Association[]
		];
		viscosityIntensivePropertyUpdate = uploadIntensiveProperty[packet,Viscosity,specifiedViscosity];

		(* Build RefractiveIndex update *)
		refractiveIndexUpdate = Switch[specifiedRefractiveIndex,
			None,
			Association[
				RefractiveIndex -> Null,
				Append[RefractiveIndexLog] -> {{date,Null,Null,Link[updatedBy]}}
			],
			DistributionP[] | GreaterP[1],
			Association[
				RefractiveIndex -> specifiedRefractiveIndex,
				Append[RefractiveIndexLog] -> Switch[specifiedRefractiveIndexReadingMode,
					FixedMeasurement,{{date,specifiedTemperature,specifiedRefractiveIndex,Link[updatedBy]}},
					TemperatureScan,{date,#[[1]],#[[2]],Link[updatedBy]}& /@ specifiedTemperatureProfiles,
					TimeScan,{date + #[[1]],specifiedTemperature,#[[2]],Link[updatedBy]}& /@ specifiedTrajectories
				]
			],
			_,
			Association[]
		];
		refractiveIndexIntensivePropertyUpdate = uploadIntensiveProperty[packet,RefractiveIndex,specifiedRefractiveIndex];

		(* Combine all updates for this sample *)
		inputUpdate = Join[
			<|Object -> Lookup[packet,Object]|>,
			densityUpdate,pHUpdate,concentrationUpdate,massConcentrationUpdate,totalProteinConcentrationUpdate,
			surfaceTensionUpdate,conductivityUpdate,viscosityUpdate,massUpdate,volumeUpdate,countUpdate,refractiveIndexUpdate
		];

		(* Combine all intensive property updates for this sample *)
		intensivePropertyUpdate = Flatten@{
			densityIntensivePropertyUpdate,pHIntensivePropertyUpdate,totalProteinConcentrationIntensivePropertyUpdate,
			surfaceTensionIntensivePropertyUpdate,conductivityIntensivePropertyUpdate,viscosityIntensivePropertyUpdate,refractiveIndexIntensivePropertyUpdate
		};

		(*construct our resolved options - they are just values we lookup from the current packets*)
		resolvedOptionsLocalAssociation = Association@Flatten@{
			Map[
				Rule[#,Lookup[packet,#] /. x : LinkP[] :> Download[x,Object]]&,
				{Density,pH,Concentration,MassConcentration,TotalProteinConcentration,SurfaceTension,Conductivity,Viscosity,Mass,Volume,Count,RefractiveIndex}
			],
			(*for refractive index-rerived values, we have to go look through some logs*)
			Module[{refractiveIndexLog},
				refractiveIndexLog = Lookup[packet,RefractiveIndexLog];
				If[Length[refractiveIndexLog] == 0,
					Return[
						{
							RefractiveIndexReadingMode -> Null,
							Temperature -> Null,
							TemperatureProfiles -> Null,
							Trajectories -> Null
						},
						Module
					],
					(*this is a weird heuristic that we are trying to use to determine what reading mode we used*)
					Module[{logBySource,lastLogEntry},
						logBySource = SplitBy[refractiveIndexLog /. x : LinkP[] :> Download[x,Object],Last];
						lastLogEntry = logBySource[[-1]];
						Which[

							(*we have only one value - it had to be FixedPoint*)
							Length[lastLogEntry] == 1,
							{
								RefractiveIndexReadingMode -> FixedPoint,
								Temperature -> lastLogEntry[[1,2]],
								TemperatureProfiles -> Null,
								Trajectories -> Null
							},

							(*trajectory - multiple entries of the same UpdatedBy and Temperature at the end*)
							MatchQ[lastLogEntry[[All,2]],{(a_) ..}],
							{
								RefractiveIndexReadingMode -> FixedPoint,
								Temperature -> lastLogEntry[[1,2]],
								TemperatureProfiles -> Null,
								Trajectories -> (lastLogEntry[[All,2]] - Min[lastLogEntry[[All,2]]])
							},

							(*temperature profile - multiple entries of the same UpdatedBy and different Temperature at the end*)
							And[
								!MatchQ[lastLogEntry[[All,2]],{(a_) ..}],
								{}
							],
							{
								RefractiveIndexReadingMode -> FixedPoint,
								Temperature -> lastLogEntry[[1,2]],
								TemperatureProfiles -> Null,
								Trajectories -> (lastLogEntry[[All,2]] - Min[lastLogEntry[[All,2]]])
							}
						]
					]];
				{RefractiveIndexReadingMode,Temperature,TemperatureProfiles,Trajectories}
			]
		};

		{inputUpdate,intensivePropertyUpdate,resolvedOptionsLocalAssociation}
	]],
		{inputPackets,mapThreadFriendlyOptions}
	];
	resolvedOptions = Normal[Merge[resolvedOptionsAssociations,Identity],Association];
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		UploadSampleProperties,
		resolvedOptions,
		Messages -> False
	];

	(*pool the intensive property updates together in one list*)
	intensivePropertyUpdates = Flatten[intensivePropertyUpdates];

	(*combine all upload packets together and flip the Valid switch on everything we updated*)
	uploadPacketsWithValid = Map[
		Function[{packet},
			(*we want to have only the packets where we are doing any actual updates intead of just ghost packets with Object->XXX and nothing else*)
			If[And[Length[packet] > 1,KeyExistsQ[packet,Object]],
				Append[packet,Valid -> False],
				packet
			]
		],
		Flatten[{inputUpdates,intensivePropertyUpdates}]
	];

	(* If we are not told to upload, return change packets, otherwise persist updates *)
	result = If[uploadQ,
		Upload[uploadPacketsWithValid],
		uploadPacketsWithValid
	];

	(*we are doing a bit of a weird check here, but in case we have requested _only_ the Result, strip a layer of list from the function to maintain backwards compatability*)
	If[MatchQ[output,{Result}],
		output = output[[1]]
	];

	output /. {
		Result -> result,
		Options -> collapsedResolvedOptions,
		Preview -> Null
	}
];

(* Helper function that returns a packet for an IntensiveProperty object. *)
uploadIntensiveProperty[packet:PacketP[],field_Symbol,fieldValue_] := Module[{sortedComposition,sortedIdentityModels,intensivePropertyObjects,intensivePropertyObject},
	If[MatchQ[fieldValue,Null],
		Return[Nothing];
	];

	(* Get rid of link heads. *)
	sortedComposition = SortBy[
		Transpose[{
			Lookup[packet,Composition][[All,1]],
			Download[Lookup[packet,Composition][[All,2]],Object]
		}],
		(#[[2]]&)
	];
	sortedIdentityModels = sortedComposition[[All,2]];

	(* We need to exit without creating intensive property packets if we have a Null anywhere in the composition *)
	If[MemberQ[Flatten[sortedComposition],NullP],
		Return[Nothing]
	];

	(* Search for all density intensive properties. *)
	intensivePropertyObjects = Search[Object[IntensiveProperty,field],Exactly[Models == sortedIdentityModels]];

	(* Create an object ID if one doesn't already exist. *)
	intensivePropertyObject = If[Length[intensivePropertyObjects] > 0,
		First[intensivePropertyObjects],
		CreateID[Object[IntensiveProperty,field]]
	];

	(* If there were no objects created, upload an object so that we don't double upload if we have the same composition. *)
	(* Note: We should probably gather these uploads so we don't map upload. *)
	If[Length[intensivePropertyObjects] == 0,
		Block[{$Notebook = Lookup[packet, Notebook, Null]/.{Link[x_,_]:>x}},
			Upload[<|
				Object -> intensivePropertyObject,
				Replace[Models] -> Link /@ sortedIdentityModels
			|>]
		]
	];

	(* Return packet. *)
	(* NOTE: When appending to the composition field, we have to wrap in another list to make sure it gets appended to the *)
	(* multiple field as an intact list. *)
	Association[
		Object -> intensivePropertyObject,
		Append[Compositions] -> {(sortedComposition[[All,1]])},
		Append[field] -> fieldValue
	]
];