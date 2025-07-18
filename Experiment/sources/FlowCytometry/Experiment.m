(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentFlowCytometry*)

(* ::Subsubsection::Closed:: *)
(*ExperimentFlowCytometry Options and Messages*)


DefineOptions[ExperimentFlowCytometry,
  Options :> {

    (*********************************************** GENERAL OPTIONS *************************************************)

    IndexMatching[
      IndexMatchingInput->"experiment samples",
    {
      OptionName->InjectionMode,
      Default->Individual,
      Description->"The mode in which samples are loaded into the flow cell. In the Individual injection mode, only one sample is inside the line a given time. After data acquisition, the sample pump runs backward to clear the line, then a wash occurs before the probe moves to the next position. The sample can be returned to the originional container if desired. In Continuous mode, samples are aspirated continuously, resulting multiple samples in the sample line. Each sample is separated with a series of air and water boundaries. In this mode, samples cannot be returned and reagent cannot be added to samples.",
      AllowNull->False,
      Category->"General",
      Widget->Widget[Type->Enumeration, Pattern:> FlowCytometerInjectionModeP] (*Individual | Continuous*)
    },
    {
      OptionName -> RecoupSample,
      Default -> Automatic,
      AllowNull->True,
      Widget -> Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
      ],
      Description -> "Indicates if the excess sample in the injection line returns to the into the container that they were in prior to the measurement.",
      ResolutionDescription->"Automatically set to True for Individual InjectionMode and Null for Continuous InjectionMode.",
      Category -> "General"
    },
      {
      OptionName -> SampleVolume,
      Default -> Automatic,
      Description -> "The volume that is taken from each input sample and aliquoted onto the container for measurement.",
      ResolutionDescription -> "Is automatically set to 200 Microliter if MaxVolume is less than 200Microliter for all samples, otheriwise it is set to twice the MaxVolume up to 4Milliliter. If PreparedPlate is True it is set to Null.",
      AllowNull->True,
      Widget -> Widget[Type -> Quantity,Pattern :> RangeP[0.5 Microliter, 4 Milliliter],Units -> {1,{Microliter,{Microliter,Milliliter}}}],
      Category->"General"
    }
    ],
    {
      OptionName -> Instrument,
      Default -> Model[Instrument, FlowCytometer,"ZE5 Cell Analyzer"],
      Description -> "The flow cytometer used for this experiment to count and quantify the cell populations by aligning them in a stream and measuring light scattered off the cells.",
      AllowNull -> False,
      Category->"General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Instrument, FlowCytometer],Model[Instrument, FlowCytometer]}]
      ]
    },
    {
      OptionName -> FlowCytometryMethod,
      Default -> Null,
      Description -> "The flow cytometry method object which describes the optics settings of the instrument. Specific parameters of the object can be overridden by other flow cytometry options.",
      AllowNull -> True,
      Category -> "General",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[Object[Method, FlowCytometry]]
      ]
    },
    {
      OptionName->PreparedPlate,
      Default->False,
      Description->"Indicates if the container containing the samples for the flow cytometry experiment has been previously prepared and will be loaded directly onto the instrument.",
      AllowNull->False,
      Widget->Widget[Type->Enumeration,Pattern:>BooleanP],
      Category->"General"
    },
    {
      OptionName -> Temperature,
      Default -> Ambient,
      AllowNull -> True,
      Widget -> Alternatives[
        Widget[Type -> Quantity, Pattern :> RangeP[4Celsius,37Celsius,1Celsius],Units :> Celsius],
        Widget[Type->Enumeration,Pattern:>Alternatives[Ambient]]
      ],
      Description -> "The temperature of the autosampler where the samples sit prior to being injected into the flow cytometer.",
      Category -> "General"
    },
    IndexMatching[
      IndexMatchingInput->"experiment samples",
      {
        OptionName -> Agitate,
        Default -> Automatic,
        Description -> "Indicates if the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer.",
        ResolutionDescription -> "Resolves to the True for samples every AgitationFrequency samples.",
        AllowNull -> False,
        Category -> "General",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ]
      }
    ],
    {
      OptionName -> AgitationFrequency,
      Default -> Automatic,
      Description -> "The frequency at which the autosampler is shaked to resuspend samples between the injections (with a value of 2 indicating agitating after every 2 samples or First indicating to agitate before the first sample).",
      ResolutionDescription -> "Automatically set to 3 if Agitate is not specified.",
      AllowNull -> True,
      Category -> "General",
      Widget -> Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> Alternatives[First]
        ],
        Widget[
          Type -> Number,
          Pattern :> GreaterP[0,1]
        ]
      ]
    },
    IndexMatching[
      IndexMatchingInput->"experiment samples",
      {
        OptionName -> AgitationTime,
        Default -> Automatic,
        Description -> "The amount of time the autosampler is shaked to the resuspend sample prior to being injected into the flow cytometer.",
        ResolutionDescription -> "Automatically set to to the 5 seconds for samples with Agitate set to True.",
        AllowNull -> True,
        Category -> "General",
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[5 Second,1 Hour],
          Units:>{1,{Second,{Second,Minute,Hour}}}
        ]
      },
      {
        OptionName -> FlowRate,
        Default -> 1 Microliter/Second,
        Description -> "The volume or number of trigger events per time (see diagram) in which the sample is flowed through the flow cytometer.",
        AllowNull -> True,
        Category -> "General",
        Widget->Alternatives[
          Widget[
            Type->Quantity,
            Pattern:>RangeP[0.1Microliter/Second,3.5 Microliter/Second],
            Units:>{1,{Microliter/Second,{Microliter/Second}}}
          ],
          Widget[
            Type->Quantity,
            Pattern:>RangeP[0*Event/Second,100000*Event/Second],
            Units:>{1,{Event/Second,{Event/Second}}} (*make diagram*)
            ]
          ]
      },
      {
        OptionName -> CellCount,
        Default -> False,
        AllowNull->False,
        Widget -> Widget[Type->Enumeration, Pattern:>BooleanP],
        Description -> "Indicates if the number of cells per volume of the sample will be measured. This setting an adddional 5ul is run before aquisition to stabilize flow.",
        Category -> "General"
      }
    ],
    (*--Flushing--*)
    {
      OptionName -> Flush,
      Default -> False,
      Description -> "Indicates if a sample line flush is performed after the FlushFrequency number of samples have been processed.",
      AllowNull -> False,
      Category -> "Flushing",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },
    {
      OptionName -> FlushFrequency,
      Default -> Automatic,
      Description -> "Indicates the frequency at which the flushed after samples have been processed (with a value of 2 indicating flushing after every 2 samples).",
      ResolutionDescription ->  "Automatically set to 5 if Flush is True; otherwise, set to Null.",
      AllowNull -> True,
      Category -> "Flushing",
      Widget -> Widget[
          Type -> Number,
          Pattern :> GreaterP[4,1]
        ]
    },
    {
      OptionName -> FlushSample,
      Default -> Automatic,
      Description -> "The liquid used to flush the instrument between FlushFrequency number of samples to clean the sample line.",
      AllowNull -> True,
      ResolutionDescription ->"Automatically set to Model[Sample,StockSolution\"Filtered PBS, Sterile\"] if Flush is True; otherwise, set to Null.",
      Widget -> Widget[
        Type -> Object,
        Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
      ],
      Category -> "Flushing"
    },
    {
      OptionName -> FlushSpeed,
      Default -> Automatic,
      Description -> "The speed at which the FlushSample is run through the instrument during a Flush.",
      ResolutionDescription -> "Automatically set to 0.5Microliter/Second if Flush is True; otherwise, set to Null.",
      AllowNull -> True,
      Widget->Widget[Type->Enumeration,Pattern:>Alternatives[0.5Microliter/Second,1Microliter/Second,1.5Microliter/Second]],
      Category -> "Flushing"
    },
    IndexMatching[
      IndexMatchingParent->Detector,
      (* --------------------- *)
      (* Optics Settings *)
      {
        OptionName->Detector,
        Default->Automatic,
        Description->"The detectors which should be used to detect light scattered off the samples.",
        ResolutionDescription->"Automatically set to 488 FSC (forward scatter), 488 SSC (side scatter) and the optic modules whose excitation wavelengths and detection wavelengths closet match the excitation and emission spectra of the DetectionLabels. If no DetectionLabel is found 488 525/35 is selected.",
        AllowNull->False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FlowCytometryDetectorP
        ],
        Category->"Optics"
      },
      {
        OptionName->DetectionLabel,
        Default->Automatic,
        AllowNull->True,
        Widget->Widget[
            Type->Object,
            Pattern:>ObjectP[Model[Molecule]]
          ],
        Description->"Indicates the fluorescent tags, attached to the samples that will be analyzed. This is used to automatically determine the Detector used.",
        ResolutionDescription->"Automatically set to the model of the fluorophores in the composition of the sample.",
        Category->"Optics"
      },
      {
        OptionName->NeutralDensityFilter,
        Default->Automatic,
        Description->"Indicates if a neutral density filter with an optical density of 2.0 should be used lower the intensity of scattered light that hits the detector. This will decrease the intensity of the scattered light by blah to reduce the signal to the PMTs dynamic range. This is only applicable for forward scatter detectors.", (*figure*)
        ResolutionDescription -> "Automatically set to the Gain field in the FlowCytometryMethod if provided and False otherwise.",
        AllowNull->False,
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Category->"Optics"
      },
      (* --------------------- *)
      (* Optics Optimization *)
      {
        OptionName->Gain,
        Default->Automatic,
        Description->"The voltage the PhotoMultiplier Tube (PMT) should be set to to detect the scattered light off the sample. When QualityControl is selected, the PMT voltage values are those set at the Quality Control baseline run at the begining of the experiment. When Auto is selected, PMT voltage is optimized at the begining of the experiment. The gain value is set so that the intensity signal from the AdjustmentSample will reach the TargetSaturationPercentage of the PMTs dynamic range. The gain optimization is performed by measuring the AdjustmentSample and increasing or decreasing the gain value until the TargetSaturationPercentage is reached.",
        ResolutionDescription -> "Automatically set to the Gain field in the FlowCytometryMethod if provided and QC otherwise.",
        AllowNull->False,
        Widget->Alternatives[
          Widget[
            Type->Quantity,
            Pattern :> RangeP[0Volt,1000Volt],
            Units:>Volt
          ],
          Widget[Type->Enumeration,Pattern:>Alternatives[Auto,QualityControl]]
        ],
        Category->"Optics"
      },
      {
        OptionName->AdjustmentSample,
        Default->Automatic,
        Description->"When optimizing gain, the sample used for gain optimization. If IncludeCompensationSamples is True, this sample will also be used when creating a compensation matrix.",
        ResolutionDescription->"Automatically set to a sample with the DetectionLabel in the sample's composition if Gain are Auto.",
        AllowNull->True,
        Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
        ],
        Category->"Optics"
      },
      {
        OptionName->TargetSaturationPercentage,
        Default->Automatic,
        Description->"When optimizing gain, the gain is set so that the intensity of positive population is centered around the 'TargetSaturationPercentage' of the PMT's dynamic range.",
        ResolutionDescription->"Automatically set to 75 Percent if any of the gain optimization parameters are specified.",
        AllowNull->True,
        Widget-> Widget[
          Type->Quantity,
          Pattern:>RangeP[1 Percent,99 Percent],
          Units:>Percent],
        Category->"Optics"
      }
    ],
    IndexMatching[
      IndexMatchingParent -> ExcitationWavelength,
      {
        OptionName -> ExcitationWavelength,
        Default -> Automatic,
        Description->"The wavelengths which should be used to excite fluorescence and scatter off the samples.",
        ResolutionDescription->"Automatically set to the wavelengths associated with the Detector. ",
        AllowNull -> False,
        Category -> "Optics",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> FlowCytometryExcitationWavelengthP
        ]
      },
      {
        OptionName -> ExcitationPower,
        Default -> Automatic,
        Description->"The laser powers which should be used to excite fluorescence and scatter off the samples.",
        ResolutionDescription->"Automatically set to the maximum power of the excitation lasers.",
        AllowNull -> False,
        Category -> "Optics",
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0*Milli*Watt,100*Milli*Watt],Units:>Milli*Watt
        ]
      }
    ],
    (* --------------------- *)
    (* Trigger *)
    {
      OptionName->TriggerDetector,
      Default->"488 FSC",
      AllowNull->False,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> FlowCytometryDetectorP
      ],
      Description->"The detector used to determine what signals count as an event. The TriggerDetector, combined with the TriggerThreshold, defines real events that should be detected and analyzed. Typically, a forward scatter detector is selected for the trigger because it identifies all particles above a given size regardless of the fluorescent signal.",
      Category->"Trigger"
    },
    {
      OptionName->TriggerThreshold,
      Default->10Percent,
      AllowNull->False,
      Widget->Widget[
        Type->Quantity,
        Pattern:>RangeP[0.01Percent,100Percent],Units:>Percent
      ],
      Description->"The level of the intensity detected by TriggerDetector must fall above to be classified as an event. The value is reported as a percentage of the total range of signal intensities in that detector.",
      Category->"Trigger"
    },
    {
      OptionName->SecondaryTriggerDetector,
      Default->None,
      AllowNull->True,
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> FlowCytometryDetectorP|None
      ],
      Description->"The additional detector used to determine what signals count as an event. The SecondaryTriggerDetector, combined with the SecondaryTriggerThreshold, defines real events that should be detected and analyzed.",
      Category->"Trigger"
    },
    {
      OptionName->SecondaryTriggerThreshold,
      Default->Automatic,
      AllowNull->True,
      Widget->Widget[
        Type->Quantity,
        Pattern:>RangeP[0.01Percent,100Percent],Units:>Percent
      ],
      Description->"The level of the intensity detected by SecondaryTriggerDetector must fall above to be classified as an event. The value is reported as a percentage of the total range of signal intensities in that detector.",
      ResolutionDescription->"Automatically set to 10 Percent if the SecondaryTriggerDetector is not None; otherwise, set to Null.",
      Category->"Trigger"
    },
    IndexMatching[
      IndexMatchingInput->"experiment samples",
      (* --------------------- *)
      (* Stopping Conditions *)
      {
        OptionName->MaxVolume,
        Default->Automatic,
        AllowNull->False,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[10*Microliter,4000*Microliter],Units:>Microliter
        ],
        Description->"The maximum volume of each sample that will flow through the flow cytometer before it moves on to the next sample. After this volume, the acquisition for this sample will stop and the next sample will begin. If the MaxEvents and/or MaxGateEvents are set, the acquisition will end once it the first maxima is reached.",
        ResolutionDescription->"Automatically set to 10ul if CellCount is True and 40ul otherwise.",
        Category->"Stopping Conditions"
      },
      {
        OptionName->MaxEvents,
        Default->None,
        AllowNull->False,
        Widget->Alternatives[
          Widget[
            Type->Enumeration,
            Pattern:>Alternatives[None]
          ],
          Widget[
          Type -> Number,
          Pattern :> GreaterP[0, 1]
          ]
        ],
        Description->"The maximum number of trigger events that will flow through the flow cytometer. The acquisition for this sample will stop and the next sample will begin once it the first maxima (MaxVolume, MaxEvents or MaxGateEvents) is reached.",
        Category->"Stopping Conditions"
      },
      {
        OptionName->MaxGateEvents,
        Default->None,
        AllowNull->False,
        Widget->Alternatives[
          Widget[
            Type->Enumeration,
            Pattern:>Alternatives[None]
          ],
          Widget[
            Type -> Number,
            Pattern :> GreaterP[0, 1]
          ]
        ],
        Description->"The maximum events falling into a specific Gate that will flow through the instrument. The acquisition for this sample will stop and the next sample will begin once it the first maxima (MaxVolume, MaxEvents or MaxGateEvents) is reached.",
        Category->"Stopping Conditions"
      },
      {
        OptionName->GateRegion,
        Default->Null,
        AllowNull->True,
        Widget->List[
          "X Channel"-> Widget[Type -> Enumeration, Pattern :> ListableP[FlowCytometryDetectorP]],
          "X Range"->Span[
            Widget[Type->Quantity,Pattern:>RangeP[0Percent,100 Percent],Units:>Percent],
            Widget[Type->Quantity,Pattern:>RangeP[0Percent,100 Percent],Units:>Percent]
          ],
          "Y Channel"-> Widget[Type -> Enumeration, Pattern :> ListableP[FlowCytometryDetectorP]],
          "Y Range"->Span[
            Widget[Type->Quantity,Pattern:>RangeP[0Percent,100 Percent],Units:>Percent],
            Widget[Type->Quantity,Pattern:>RangeP[0Percent,100 Percent],Units:>Percent]
          ]
        ],
        Description->"The conditions given to categorize the gate for the MaxGateEvents. Events that fall within the X Range and Y Range of the X Channel (area) by Y Channel (area) plot will count towards the MaxGateEvents.",
        Category->"Stopping Conditions"
      }
    ],
    (* --------------------- *)
    (* Compensation *)
    {
      OptionName -> IncludeCompensationSamples,
      Default -> False,
      Description -> "Indicates if a compensation matrix will be created to compensate for spillover of DetectionLabel into other detectors. The AdjustmentSample for each fluorescent detector will be measured to calculate this matrix.", (*make figure*)
      AllowNull -> True,
      Category -> "Compensation",
      Widget -> Alternatives[
        Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ],
        Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
      ]
    },
    {
      OptionName -> UnstainedSample,
      Default -> None,
      Description -> "A unstained sample to be used as negative control when calculating the background of the compensation matrix for the experiment.  This is needed if any of the AdjustmentSamples do not have negative populations.",
      AllowNull -> True,
      Category -> "Compensation",
      Widget -> Alternatives[
        Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
        ],
        Widget[Type -> Enumeration, Pattern :> Alternatives[None]]
      ]
    },
    (* --------------------- *)
    (* Reagent Addition *)
    IndexMatching[
      IndexMatchingInput->"experiment samples",
      {
        OptionName->AddReagent,
        Default->Automatic,
        Description->"Indicates if a Reagent will be added to the sample prior to measurement.",
        ResolutionDescription->"Automatically set to True when any Reagent options are specified.",
        AllowNull->False,
        Category -> "Reagent Addition",
        Widget -> Widget[
          Type -> Enumeration,
          Pattern :> BooleanP
        ]
      },
      {
        OptionName->Reagent,
        Default->Automatic,
        Description->"The reagent that will be added to the sample prior to measurement.",
        ResolutionDescription->"Automatically set to Model[Sample,\"Milli-Q water\"] when AddReagent is True.",
        AllowNull->True,
        Category -> "Reagent Addition",
        Widget ->Widget[
          Type -> Object,
          Pattern :> ObjectP[{Object[Sample],Model[Sample]}]
        ]
      },
      {
        OptionName->ReagentVolume,
        Default->Automatic,
        Description->"The volume of Reagent that will be added to the sample prior to measurement.",
        ResolutionDescription->"Automatically set to 10 Microliter when AddReagent is True.",
        Category -> "Reagent Addition",
        AllowNull->True,
        Widget->Widget[
          Type->Quantity,
          Pattern:>RangeP[0Microliter,5000Microliter],Units:>Microliter
        ]
      },
      {
        OptionName->ReagentMix,
        Default->Automatic,
        Description->"Indicates if the Reagent and sample will be mixed by aspiration prior to measurement.",
        ResolutionDescription->"Automatically set to True when AddReagent is True.",
        AllowNull->True,
        Category -> "Reagent Addition",
        Widget -> Alternatives[
          Widget[
            Type -> Enumeration,
            Pattern :> BooleanP
          ],
          Widget[Type -> Enumeration, Pattern :> Alternatives[Null]]
        ]
      }
    ],
    (* --------------------- *)
    (* Washing *)
    IndexMatching[
      IndexMatchingInput->"experiment samples",
    {
      OptionName->NeedleWash,
      Default->True,
      Description->"Indicates if sheath fluid will be used to wash the injection needle after the sample measurement. The outside of the needle is washed for 0.25 Second after every sample measurement.",
      AllowNull->False,
      Category -> "Washing",
      Widget ->  Widget[
        Type -> Enumeration,
        Pattern :> BooleanP
      ]
    },
    {
      OptionName->NeedleInsideWashTime,
      Default->Automatic,
      Description->"The amount of time the sheath fluid will be used to wash the inside of the injection needle after every sample measurement.",
      Description->"Automatically set to 1 Second if NeedleWash is True.",
      AllowNull->True,
      Category -> "Washing",
      Widget -> Widget[
        Type -> Enumeration,
        Pattern :> Alternatives[0.5Second,1Second,2Second]
      ]
    }
      ],
    (* --------------------- *)
    (* Blanks *)
    {
      OptionName -> BlankFrequency,
      Default -> Automatic,
      Description -> "The frequency at which Blank samples will be inserted in the measurement sequence. If specified to a number, indicates how often the Blank samples will run among the samples; for example, if 5 input samples are measured and BlankFrequency is 2, then Blank measurement will occur after the first two samples and again after the fourth.",
      ResolutionDescription -> "Automatically set to 5 when any Blank options are specified.",
      AllowNull -> True,
      Category -> "InjectionOrder",
      Widget -> Widget[
        Type -> Number,
        Pattern :> GreaterP[0, 1]
      ]
    },
    IndexMatching[
      IndexMatchingParent -> Blank,
    {
      OptionName -> Blank,
      Default -> Automatic,
      Description -> "A sample containing wash solution used an extra wash between samples. The blank will flow through the instrument like a sample without detecting scattering.",
      ResolutionDescription ->"Automatically set to Model[Sample,StockSolution\"Filtered PBS, Sterile\"] if any other Blank option is selected; otherwise, set to Null.",
      AllowNull -> True,
      Category -> "InjectionOrder",
      Widget -> Widget[
          Type -> Object,
          Pattern :> ObjectP[{Model[Sample],Object[Sample]}]
        ]
    },
    {
      OptionName -> BlankInjectionVolume,
      Default -> Automatic,
      Description -> "The volume of each Blank to inject.",
      ResolutionDescription -> "Automatically resolves to 40 Microliter when any Blank options are specified.",
      AllowNull -> True,
      Category -> "InjectionOrder",
      Widget -> Widget[
        Type -> Quantity,
        Pattern :> RangeP[0 Microliter, 2000 Microliter],
        Units -> Microliter
      ]
    }],
    (* --------------------- *)
    (* General *)
    {
      OptionName -> InjectionTable,
      Default -> Automatic,
      Description -> "The order of Sample, AdjustmentSample, UnstainedSample and Blank sample loading into the flow cytometer.",
      ResolutionDescription -> "Determined to the order of input samples articulated. AdjustmentSamples and UnstainedSample are inserted at the beginning of the experiment followed by samples. The Blank samples are inserted based on the BlankFrequency.",
      AllowNull -> False,
      Widget -> Adder[
          {
            "Type" -> Widget[
              Type -> Enumeration,
              Pattern :> Sample|AdjustmentSample|UnstainedSample|Blank
            ],
            "Sample" -> Alternatives[
              Widget[
                Type -> Object,
                Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
                ObjectTypes -> {Model[Sample], Object[Sample]}
              ]
            ],
            "InjectionVolume" -> Alternatives[
            Widget[
              Type -> Quantity,
              Pattern :> RangeP[0 Microliter, 4 Milliliter],
              Units :> Microliter
            ],
            Widget[
              Type -> Enumeration,
              Pattern :> Alternatives[Automatic]
            ]
          ],
            "AgitationTime" -> Alternatives[
              Widget[
                Type -> Quantity,
                Pattern :> RangeP[5 Second,1 Hour],
                Units :> Second
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[Automatic]
              ],
              Widget[
                Type -> Enumeration,
                Pattern :> Alternatives[0Second]
              ]
            ]
          }
      ],
      Category -> "InjectionOrder"
    },
    {
      OptionName->NumberOfReplicates,
      Default->Null,
      Description->"The number of aliquots to generate from every sample as input to the flow cytometry experiment.",
      AllowNull->True,
      Widget->Widget[Type->Number,Pattern:>RangeP[0,384,1]],
      Category->"General"
    },
    (* label options for manual primitives *)
    IndexMatching[
      IndexMatchingInput->"experiment samples",
      {
        OptionName -> SampleLabel,
        Default->Automatic,
        AllowNull->False,
        NestedIndexMatching->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"A user defined word or phrase used to identify the samples that will be anlayzed, for use in downstream unit operations.",
        Category->"General",
        UnitOperation->True
      },
      {
        OptionName->SampleContainerLabel,
        Default->Automatic,
        AllowNull->False,
        NestedIndexMatching->True,
        Widget->Widget[Type->String,Pattern:>_String,Size->Line],
        Description->"A user defined word or phrase used to identify the containers of the samples that will be anlayzed, for use in downstream unit operations.",
        Category->"General",
        UnitOperation->True
      }
    ],

    (*===Shared Options===*)
    NonBiologyFuntopiaSharedOptions,
    SimulationOption,
    SubprotocolDescriptionOption,
    SamplesInStorageOption,
    SamplesOutStorageOption
  }
];

(* ::Subsubsection::Closed:: *)
(* ExperimentFlowCytometry Source Code *)


(* - Container to Sample Overload - *)

ExperimentFlowCytometry[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
    containerToSampleResult,containerToSampleOutput,updatedCache,samples,sampleOptions,containerToSampleTests,listedContainers,cache,containerToSampleSimulation,
    samplePreparationSimulation},


  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedContainers, listedOptions} = {ToList[myContainers], ToList[myOptions]};

  (* Fetch the cache from listedOptions *)
  cache=ToList[Lookup[listedOptions, Cache, {}]];

  (* First, simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentFlowCytometry,
      listedContainers,
      listedOptions
    ],
    $Failed,
    {Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Convert our given containers into samples and sample index-matched options. *)
  containerToSampleResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {containerToSampleOutput,containerToSampleTests,containerToSampleSimulation}=containerToSampleOptions[
      ExperimentFlowCytometry,
      mySamplesWithPreparedSamples,
      myOptionsWithPreparedSamples,
      Output->{Result,Tests,Simulation},
      Simulation->samplePreparationSimulation
    ];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
      Null,
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {containerToSampleOutput,containerToSampleSimulation}=containerToSampleOptions[
        ExperimentFlowCytometry,
        mySamplesWithPreparedSamples,
        myOptionsWithPreparedSamples,
        Output-> {Result,Simulation},
        Simulation->samplePreparationSimulation
      ],
      $Failed,
      {Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
    ]
  ];


  (* If we were given an empty container, return early. *)
  If[MatchQ[containerToSampleResult, $Failed],
    (* containerToSampleOptions failed - return $Failed *)
    outputSpecification /. {
      Result -> $Failed,
      Tests -> containerToSampleTests,
      Options -> $Failed,
      Preview -> Null,
      Simulation -> Null,
      InvalidInputs -> {},
      InvalidOptions -> {}
    },

    (* Split up our containerToSample result into the samples and sampleOptions. *)
    {samples, sampleOptions} = containerToSampleOutput;

    (* Call our main function with our samples and converted options. *)
    ExperimentFlowCytometry[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
  ]
];

(* -- Main Overload --*)
ExperimentFlowCytometry[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
  {
    listedOptions,outputSpecification,output,gatherTests,listedSamples,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,samplePreparationCache,
    mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,
    safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,inheritedOptions,expandedSafeOps,flowCytometryOptionsAssociation,

    objectSamplePacketFields,modelSamplePacketFields,objectContainerFields,modelContainerFields,safeOptionsNamed,
    optionsWithObjects, allObjects,
    containerObjects, modelContainerObjects, instrumentObjects, modelInstrumentObjects, modelSampleObjects,
    sampleObjects, methodObjects, moleculeObjects, protocolObjects,

    cacheBall,resolvedOptionsResult,resolvedOptions,resolvedOptionsTests,collapsedResolvedOptions,resourcePackets,resourcePacketTests,
    protocolObject,allPackets, cacheOption, currentSimulation,performSimulationQ,
    simulation,simulatedProtocol,updatedSimulation,returnEarlyQ
  },

  (* Determine the requested return value from the function *)
  outputSpecification=Quiet[OptionValue[Output]];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests *)
  gatherTests=MemberQ[output,Tests];

  (* Remove temporal links and named objects. *)
  {listedSamples,listedOptions}=removeLinks[ToList[mySamples],ToList[myOptions]];

  (* Make sure we're working with a list of options *)
  cacheOption=ToList[Lookup[listedOptions,Cache,{}]];

  (* Simulate our sample preparation. *)
  validSamplePreparationResult=Check[
    (* Simulate sample preparation. *)
    {mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation}=simulateSamplePreparationPacketsNew[
      ExperimentFlowCytometry,
      ToList[listedSamples],
      ToList[listedOptions]
    ],
    $Failed,
    {Download::ObjectDoesNotExist,Error::MissingDefineNames,Error::InvalidInput,Error::InvalidOption}
  ];

  (* If we are given an invalid define name, return early. *)
  If[MatchQ[validSamplePreparationResult,$Failed],
    (* Return early. *)
    (* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
    ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
  ];

  (* Call SafeOptions to make sure all options match pattern *)
  {safeOptionsNamed,safeOpsTests}=If[gatherTests,
    SafeOptions[ExperimentFlowCytometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
    {SafeOptions[ExperimentFlowCytometry,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
  ];

  (*change all Names to objects *)
  {mySamplesWithPreparedSamples,safeOps,myOptionsWithPreparedSamples}=sanitizeInputs[mySamplesWithPreparedSamplesNamed,safeOptionsNamed,myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];

  (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
  If[MatchQ[safeOps,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->safeOpsTests,
      Options->$Failed,
      Preview->Null
    }]
  ];
  
  (* Call ValidInputLengthsQ to make sure all options are the right length *)
  {validLengths,validLengthTests}=If[gatherTests,
    ValidInputLengthsQ[ExperimentFlowCytometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ValidInputLengthsQ[ExperimentFlowCytometry,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
  ];

  (* If option lengths are invalid return $Failed (or the tests up to this point) *)
  If[!validLengths,
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->Join[safeOpsTests,validLengthTests],
      Options->$Failed,
      Preview->Null
    }]
  ];

  (* Use any template options to get values for options not specified in myOptions *)
  {templatedOptions,templateTests}=If[gatherTests,
    ApplyTemplateOptions[ExperimentFlowCytometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
    {ApplyTemplateOptions[ExperimentFlowCytometry,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
  ];

  (* Return early if the template cannot be used - will only occur if the template object does not exist. *)
  If[MatchQ[templatedOptions,$Failed],
    Return[outputSpecification/.{
      Result->$Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests],
      Options->$Failed,
      Preview->Null
    }]
  ];

  (* Replace our safe options with our inherited options from our template. *)
  inheritedOptions=ReplaceRule[safeOps,templatedOptions];

  (* Expand index-matching options *)
  expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentFlowCytometry,{ToList[mySamplesWithPreparedSamples]},inheritedOptions]];


  (*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
  (* Turn the expanded safe ops into an association so we can lookup information from it*)
  flowCytometryOptionsAssociation=Association[expandedSafeOps];

  (* Any options whose values could be an object *)
  optionsWithObjects = {
    Instrument,
    FlowCytometryMethod,
    FlushSample,
    DetectionLabel,
    AdjustmentSample,
    UnstainedSample,
    Reagent,
    Blank
  };

  allObjects = DeleteDuplicates@Download[
    Cases[
      Flatten@Join[
        mySamplesWithPreparedSamples,
        (* Default objects *)
        {
          Model[Sample,"Milli-Q water"],
          Model[Sample,StockSolution, "Filtered PBS, Sterile"]
        },
        (* All options that could have an object *)
        Lookup[expandedSafeOps,optionsWithObjects]
      ],
      ObjectP[]
    ],
    Object,
    Date->Now
  ];

  (* Create the Packet Download syntax for our Object and Model samples. *)
  objectSamplePacketFields=Packet@@Flatten[{IncompatibleMaterials,RequestedResources,SamplePreparationCacheFields[Object[Sample]]}];
  modelSamplePacketFields=Packet[Model[Flatten[{IncompatibleMaterials,SamplePreparationCacheFields[Model[Sample]]}]]];
  objectContainerFields=Join[SamplePreparationCacheFields[Object[Container]], {VacuumCentrifugeCompatibility}];
  modelContainerFields=Join[SamplePreparationCacheFields[Model[Container]], {VacuumCentrifugeCompatibility}];

  (*separate the objects to download specific fields*)
  containerObjects= Cases[allObjects,ObjectP[Object[Container]]];
  modelContainerObjects= Cases[allObjects,ObjectP[Model[Container]]];
  instrumentObjects = Cases[allObjects,ObjectP[Object[Instrument]]];
  modelInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument]]];
  modelSampleObjects=Cases[allObjects,ObjectP[Model[Sample]]];
  sampleObjects=Cases[allObjects,ObjectP[Object[Sample]]];
  methodObjects=Cases[allObjects,ObjectP[Object[Method, FlowCytometry]]];
  moleculeObjects=Cases[allObjects,ObjectP[Model[Molecule]]];
  protocolObjects=Cases[allObjects,ObjectP[Object[Protocol]]];

  (* pull out the Cache option *)
  samplePreparationCache = Lookup[safeOps, Cache];

  (* make the up front Download call *)
    allPackets=Quiet[Download[
      {
        sampleObjects,
        modelSampleObjects,
        instrumentObjects,
        modelInstrumentObjects,
        modelContainerObjects,
        containerObjects,
        methodObjects,
        moleculeObjects
      },
      {
        (*Samples*)
        {
          objectSamplePacketFields,
          modelSamplePacketFields,
          Packet[Container[Model][modelContainerFields]],
          Packet[Composition[[All, 2]][{Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DetectionLabels,DefaultSampleModel,MolecularWeight}]]
        },
        {
          Packet[Object,Name,IncompatibleMaterials,Deprecated, Composition],
          Packet[Composition[[All, 2]][{Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DetectionLabels,DefaultSampleModel,MolecularWeight}]],
          Packet[Composition[[All, 2]][DetectionLabels][{Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DefaultSampleModel,MolecularWeight}]]
        },
        (*Instruments*)
        {
          Packet[Object,Name,Status,Model],
          Packet[Model[{Object,Name,WettedMaterials,Detectors,ExcitationLaserPowers,ExcitationLaserWavelengths,QualityControlBeads}]]
        },
        {
          Packet[Object,Name,WettedMaterials,Detectors,ExcitationLaserPowers,ExcitationLaserWavelengths,QualityControlBeads]
        },
        (*Containers*)
        {
          Packet[Sequence[modelContainerFields]]
        },
        {
          Packet[Object,Name,Status,Model],
          Packet[Model[modelContainerFields]]
        },
        (*Method*)
        {
          Packet[Object,Detector,DetectionLabel,ExcitationWavelength,ExcitationPower,Gain,NeutralDensityFilter]
        },
        (*Molecule*)
        {
          Packet[Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DefaultSampleModel]
        }
      },
      Cache->samplePreparationCache,
      Simulation->updatedSimulation,
      Date->Now
    ],Download::FieldDoesntExist];



    (* Return early if objects do not exist *)
    If[MatchQ[allPackets, $Failed],
      Return[$Failed]
    ];

    (* combine all the Download information together  *)
    cacheBall = FlattenCachePackets[{samplePreparationCache,cacheOption, allPackets}];


  (* Build the resolved options *)
  resolvedOptionsResult=If[gatherTests,
    (* We are gathering tests. This silences any messages being thrown. *)
    {resolvedOptions,resolvedOptionsTests}=resolveExperimentFlowCytometryOptions[mySamplesWithPreparedSamples,expandedSafeOps,Simulation->updatedSimulation,Cache->cacheBall,Output->{Result,Tests}];

    (* Therefore, we have to run the tests to see if we encountered a failure. *)
    If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
      {resolvedOptions,resolvedOptionsTests},
      $Failed
    ],

    (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
    Check[
      {resolvedOptions,resolvedOptionsTests}={resolveExperimentFlowCytometryOptions[mySamplesWithPreparedSamples,expandedSafeOps,Simulation->updatedSimulation,Cache->cacheBall],{}},
      $Failed,
      {Error::InvalidInput,Error::InvalidOption}
    ]
  ];

  (* Collapse the resolved options *)

  collapsedResolvedOptions = CollapseIndexMatchedOptions[
    ExperimentFlowCytometry,
    resolvedOptions,
    Ignore->ToList[myOptions],
    Messages->False
  ];

  (* If option resolution failed, return early. *)
  If[MatchQ[resolvedOptionsResult,$Failed],
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentFlowCytometry,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* run all the tests from the resolution; if any of them were False, then we should return early here *)
  (* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
  (* basically, if _not_ all the tests are passing, then we do need to return early *)
  returnEarlyQ = Which[
    MatchQ[resolvedOptionsResult, $Failed], True,
    gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
    True, False
  ];

  (* Figure out if we need to perform our simulation. If so, we can't return early even though we want to because we *)
  (* need to return some type of simulation to our parent function that called us. *)
  performSimulationQ=MemberQ[output, Simulation] || MatchQ[$CurrentSimulation, SimulationP];

  (* If option resolution failed and we aren't asked for the simulation or output, return early. *)
  If[returnEarlyQ && !performSimulationQ,
    Return[outputSpecification/.{
      Result -> $Failed,
      Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
      Options->RemoveHiddenOptions[ExperimentFlowCytometry,collapsedResolvedOptions],
      Preview->Null,
      Simulation->Simulation[]
    }]
  ];

  (* Build packets with resources *)
  {resourcePackets,resourcePacketTests} = If[gatherTests,
    flowCytometryResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Simulation->updatedSimulation,Cache->cacheBall,Output->{Result,Tests}],
    {flowCytometryResourcePackets[ToList[mySamplesWithPreparedSamples],expandedSafeOps,resolvedOptions,Simulation->updatedSimulation,Cache->cacheBall],{}}
  ];

  (* If we were asked for a simulation, also return a simulation. *)
  {simulatedProtocol, simulation} = If[performSimulationQ,
    simulateExperimentFlowCytometry[
      If[MatchQ[resourcePackets, $Failed],
        $Failed,
        resourcePackets[[1]] (* protocolPacket *)
      ],
      If[MatchQ[resourcePackets, $Failed],
        $Failed,
        ToList[resourcePackets[[2]]] (* unitOperationPackets *)
      ],
      ToList[mySamplesWithPreparedSamples],
      resolvedOptions,
      Cache->cacheBall,
      Simulation->updatedSimulation],
    {Null, Null}
  ];


  (* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
  If[!MemberQ[output,Result],
    Return[outputSpecification/.{
      Result -> Null,
      Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
      Options -> RemoveHiddenOptions[ExperimentFlowCytometry,collapsedResolvedOptions],
      Preview -> Null,
      Simulation->simulation
    }]
  ];

  (* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
    protocolObject=Which[
      (* If there was a problem with our resource packets function or option resolver, we can't return a protocol. *)
      MatchQ[resourcePackets,$Failed]||MatchQ[resolvedOptionsResult,$Failed],
      $Failed,

      (* If we want to upload an actual protocol object. *)
      True,
      UploadProtocol[
        resourcePackets[[1]], (* protocolPacket *)
        ToList[resourcePackets[[2]]], (* unitOperationPackets *)
        Priority -> Lookup[safeOps, Priority],
        StartDate -> Lookup[safeOps, StartDate],
        HoldOrder -> Lookup[safeOps, HoldOrder],
        QueuePosition -> Lookup[safeOps, QueuePosition],
        Cache -> cacheBall,
        Upload->Lookup[safeOps,Upload],
        Confirm->Lookup[safeOps,Confirm],
        CanaryBranch->Lookup[safeOps,CanaryBranch],
        ParentProtocol->Lookup[safeOps,ParentProtocol],
        ConstellationMessage->Object[Protocol,FlowCytometry],
        Simulation->updatedSimulation
      ]
    ];

  (* Return requested output *)
  outputSpecification/.{
    Result -> protocolObject,
    Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
    Options -> RemoveHiddenOptions[ExperimentFlowCytometry,collapsedResolvedOptions],
    Preview -> Null
  }

];

DefineOptions[
  resolveExperimentFlowCytometryOptions,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];

Error::FlowCytometryTooManySamples="The number of input samples * NumberOfReplicates (`1`), AdjustmentSamples (`2`), Blanks, (`3`), Reagents (`4`) and Negative Control (`5`) cannot fit onto the instrument in a single protocol.  Please select fewer than `6` samples to run this protocol.";
Error::ConflictingContinuousModeOptions="Continuous injection mode is selected. In this mode CellCount and Recoup Sample must be False. Please change InjectionMode to Individual or `1` to False.";
Error::ConflictingContinuousModeFlowRateOptions="Continuous injection mode is selected. In this mode the flow rate must be the same for each sample and 0.5-2.5 µl/sec.";
Error::ConflictingContinuousModeLimitOptions="Continuous injection mode is selected. In this mode MaxEvents and MaxGateEvents cannot be used. Please change InjectionMode to Individual or `1` to None.";
Error::ConflictingPreparedPlateReagentOptions="A PreparedPlate is selected. In this case, no Reagent addition options can be selected unless the Reagent is in the plate. Please change PrepapredPlate to False or `1` to Null.";
Error::ConflictingPreparedPlateBlankOptions="A PreparedPlate is selected. In this case, no Blank options can be selected unless the blank is in the plate. Please change PrepapredPlate to False or `1` to Null.";
Error::ConflictingAgitationOptions="Agitate (`1`) and  AgitationFrequency (`2`) are both specified. Only one of these options can be specified. Please set one of these options to Automatic or None";
Error::MustSpecifyAgitationTime="Agitate is `1`. The AgitationTime `2` must be specified.";
Error::ConflictingFlushOptions="Flush is `1`, and `2` is Null. Please specify `2` or set it to Automatic.";
Error::ConflictingFlushInjectionOptions="Flush is not available if Continuous injection mode or CellCount is selected.";
(*)Warning::ConflictingDetectorsAndFluorophores="The selected Detector `1` is not designed to measure the fluorescence in any of the fluorophores present in the input samples (`2`).";
Warning::ConflictingDetecorAndDetectionLabel="The selected Detector `1` is not designed to measure the fluorescence DetectionLabel `2`.";*)
Error::ConflictingExcitationWavelengthDetector="The ExcitationWaveLength `1` does not match the detector `2`. Please change the ExcitationWaveLength to `3`.";
Error::ConflictingNeutralDensityFilter="The NeutralDensityFilter can only be used for non-fluoresence scatter detectors. Please change NeutralDensityFilter to False for `1`.";
Error::GainOptimizationOptions="The AdjustmentSample (`1`) or TargetSaturationPercentage (`2`) can only be  Null if Gain (`3`) are not Auto.";
Error::ConflictingSecondaryTriggerOptions="The SecondaryTriggerDetector (`1`) can only be Null if and only if SecondaryTriggerThresold (`2`) is Null.";
Error::ConflictingGateOptions="MaxGateEvents (`1`) can only be None if and only if GateRegion (`2`) is Null";
Error::MustSpecifyAdjustmentSamplesForCompensation="IncludeCompensationSamples is True and AdjustmentSamples are not provided. Please select AdjustmentSample for the `1` Detector or set IncludeCompensationSamples to False.";
Error::ConflictingAddReagentOptions="AddReagent (`1`) is False if and only if Reagent (`2`), ReagentVolume (`3`) and ReagentMix (`4`) are Null";
Error::ConflictingNeedleWashOptions="NeedleWash (`1`) is False if and only if NeedleInsideWashTime (`2`) is Null";
Error::ConflictingBlankOptions="If no injectionTable is provided, Blank is Null if and only if BlankInjectionVolume and BlankFrequency are Null.";
Error::ConflictingFlowInjectionTableBlankOptions="The  Blank and BlankFrequency options do not match the provided InjectionTable.";
Error::ConflictingFlowInjectionTable="The Types and Samples in the provided InjectionTable do not match the Samples, UnstainedSample and AdjustmentSamples.";
Error::ConflictingCellCountMaxEvents="CellCount is True. In this mode only a MaxVolume can be used. Please set MaxGateEvents and MaxEvents to None.";
Warning::UnresolvableFlowCytometryDetector="The provided DetectionLabel (`1`) did not match any of the detectors for this instrument.";
(*)Warning::FlowCytometryDetectorNotRecommended="The provided Detector (`1`) is not recommended for the detection labels (`2`).";*)
Error::UnresolveableAdjustmentSampleError="An AdjustmentSample was not found for Detector `1`, please provide a suitable sample.";
Error::FlowCytometryInvalidPreparedPlateContainer="The samples are not in a container compatible with the instrument. Please change the input container to Model[Container, Plate, \"96-well Round Bottom Plate\"] or  Model[Container, Vessel, \"5mL Tube\"] or set PreparedPlate to False.";
Error::ConflictingPreparedPlateUnstainedSampleOptions="A PreparedPlate is selected. In this case, no UnstainedSample can be selected unless the sample is in the plate. Please change PrepapredPlate to False or `1` to Null.";
Error::ConflictingPreparedPlateAdjustmentSampleOptions="A PreparedPlate is selected. In this case, no AdjustmentSamples can be selected unless the sample is in the plate. Please change PrepapredPlate to False or `1` to Null.";
Error::ConflictingPreparedPlateInjectionOrder="A PreparedPlate is selected and the sample positions in the plate do not match the order in the InjectionTable. Please change InjectionTable to match the sample positions in the plate.";
Error::UnresolvableFlowCytometerInjectionTable="The injection table item `1` was unable to resolve. Please specify these options or leave InjectionTable Automatic.";
Error::FlowCytometerLaserPowerTooHigh="The power `1` for the `2` laser is set above the max power `3` of the laser. Please lower this power.";



resolveExperimentFlowCytometryOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentFlowCytometryOptions]]:=Module[
    {
      outputSpecification,output,gatherTests,inheritedCache,samplePrepOptions,flowCytometryOptions,simulatedSamples,resolvedSamplePrepOptions,samplePrepTests,
      flowCytometryOptionsAssociation,invalidInputs,invalidOptions,targetContainers,resolvedAliquotOptions,aliquotTests,numberOfReplicates,
      messages, fastTrack,allTests,testsRule,resultRule,simulation,updatedSimulation,

      (*download*)
      allInstrumentModelPackets, allOptionSampleModelPackets, samplePackets, containerPackets, sampleContainerModelPackets,
      sampleContainerModels,
      instrumentModelObjects,instrumentObjects, sampleModelObjects,sampleObjects,methodObjects,moleculeObjects,
      allDownloadValues,sampleDownloadValues, instrumentModelPackets, instrumentPackets, optionSampleModelPackets,optionSamplePackets,methodPackets,
      sampleModelPackets,moleculePackets,sampleMoleculePackets,sampleMolecules, sampleMoleculeFluorescenceExcitationMaximums,
    sampleMoleculeFluorescenceEmissionMaximums, detectorExcitation, detectorEmissionMin, detectorEmissionMax, fluorescenceChannels,
      detectorChannels,detectorChannelNames,fluorescenceChannelNames,fluorescenceChannelExcitation,fluorescenceChannelEmissionMin,
      fluorescenceChannelEmissionMax,instrumentExcitationLaserWavelengths,sampleFluorescentMolecules,instExcitationLaserWavelengths,
      instExcitationLaserPowers,sampleVolumeWithReplicates,sampleContainerObjects,containerContents,sampleContainers,sampleOptionContainers,
      sampleOptionContainerRules,cacheBall,

      (*Invalid input tests*)
      discardedSamplePackets,discardedInvalidInputs,discardedTest,modelPacketsToCheckIfDeprecated,deprecatedModelPackets,
      deprecatedInvalidInputs,deprecatedTest, expandedRecoupSample,
      numSamples,tooManySamplesQ,numAdjustmentSamples,numBlanks,numReagents,numUnstainedSamples,tooManySamplesInputs,tooManySamplesTest,

      roundedFlowCytometryOptions, precisionTests, mapThreadFriendlyOptions,engine,

      (*options that are not resolved*)
      injectionMode, instrument, flowCytometryMethod, preparedPlate, temperature,
      flowRate, cellCount, flush, resolvedGain,
      triggerDetector, triggerThreshold, secondaryTriggerDetector, maxEvents, maxGateEvents, gateRegion,
      unstainedSample, needleWash, name, parentProtocol,
      suppliedDetectors, suppliedDetectionLabels, suppliedExcitationWavelengths, suppliedExcitationPowers,
      expandedCellCount,lengthSamples,expandedNeedleWash,expandedFlowRate,expandedInjectionMode,
      expandedMaxGateEvents,expandedMaxEvents,

      (*Invalid option tests*)
      validNameQ,nameInvalidOptions,validNameTest,conflictingContinuousModeOptions,conflictingContinuousModeInvalidOptions,
      conflictingContinuousModeTests,conflictingPreparedPlateReagentOptions,conflictingPreparedPlateReagentInvalidOptions,
      conflictingPreparedPlateReagentTests, conflictingAgitationOptions,conflictingAgitationInvalidOptions,
      conflictingAgitationTests,mustSpecifyAgitationTimeOptions,mustSpecifyAgitationTimeInvalidOptions,mustSpecifyAgitationTimeTests,
      conficitingFlushOptions,conficitingFlushInvalidOptions,conficitingFlushTests,
      excitationMatchBools,emissionMatchBools,onficitingDetectorsAndFluorophoresTests,
      detectionLabelEmissionMatchBools,detectionLabelExcitationMatchBools,detectionLabelExcitation,detectionLabelEmission,conficitingDetecorAndDetectionLabelTests,
      conficitingExcitationWavelengthDetectorInvalidOptions,conficitingExcitationWavelengthDetectorOptions,conficitingExcitationWavelengthDetectorTests,
      conflicitingNeutralDensityFilterOptions,conflicitingNeutralDensityFilterInvalidOptions,conflicitingNeutralDensityFilterTests,
      conflicitingGainOptimizationOptions,conflicitingGainOptimizationInvalidOptions,conflicitingGainOptimizationTests,
      conflicitingSecondaryTriggerOptions,conflicitingSecondaryTriggerInvalidOptions,conflicitingSecondaryTriggerTests,
      conflicitingGateOptions,conflicitingGateInvalidOptions,conflicitingGateTests,
      mustSpecifyAdjustmentSamplesForCompensationOptions,mustSpecifyAdjustmentSamplesForCompensationInvalidOptions,mustSpecifyAdjustmentSamplesForCompensationTests,
      conflicitingAddReagentOptions,conflicitingAddReagentInvalidOptions,conflicitingAddReagentTests,
      conflicitingNeedleWashOptions,conflicitingNeedleWashInvalidOptions,conflicitingNeedleWashTests,
      conflicitingBlankOptions,conflicitingBlankInvalidOptions,conflicitingBlankTests,
      conflictingCellCountMaxEventsOptions,conflictingCellCountMaxEventsInvalidOptions,conflictingCellCountMaxEventsTests,
      conflictingFlowInjectionTableBlankOptions,conflictingFlowInjectionTableBlankInvalidOptions,conflictingFlowInjectionTableBlankTests,
      conflictingFlowInjectionTableOptions,conflictingFlowInjectionTableInvalidOptions,conflictingFlowInjectionTableTests,
      numInputSamples,expandedNeedleInsideWashTime,
      conflictingContinuousModeFlowRateOptions, conflictingContinuousModeFlowRateInvalidOptions,conflictingContinuousModeFlowRateTests,
      conflictingContinuousModeLimitOptions,conflictingContinuousModeLimitInvalidOptions,conflictingContinuousModeLimitTests,
      conflictingFlushInjectionOptions,conflictingFlushInjectionInvalidOptions,conflictingFlushInjectionTests,
      maxSamples,conflictingFlowCytometryInvalidPreparedPlateContainerOptions,
      conflictingFlowCytometryInvalidPreparedPlateContainerInvalidOptions,conflictingFlowCytometryInvalidPreparedPlateContainerTests,
      conflictingPreparedPlateBlankOptions,conflictingPreparedPlateBlankInvalidOptions,conflictingPreparedPlateBlankTests,
      conflictingPreparedPlateUnstainedSampleOptions,conflictingPreparedPlateUnstainedSampleInvalidOptions,conflictingPreparedPlateUnstainedSampleTests,
      conflictingPreparedPlateAdjustmentSampleOptions,conflictingPreparedPlateAdjustmentSampleInvalidOptions,conflictingPreparedPlateAdjustmentSampleTests,
      conflictingLaserPowerOptions, conflictingLaserPowerInvalidOptions,conflictingLaserPowerTests,maxPowerRules,

      (*option resolving*)
      resolvedFlushFrequency,resolvedOptions,resolvedFlushSample,resolvedFlushSpeed,resolvedNeedleInsideWashTime,
      resolvedAgitationFrequency,resolvedDetector,resolvedExcitationWavelength,matchingDetectorsForDetectionLabel,matchingDetectorsForDetectionLabelForFluorophores,
      resolvedDetectionLabel,resolvedExcitationPower,resolvedBlank,resolvedBlankInjectionVolume,resolvedBlankFrequency,
      resolvedRecoupSample,resolvedAgitate,resolvedAgitationTime,resolvedMaxVolume,resolvedAddReagent,resolvedReagent,
      resolvedReagentVolume,resolvedReagentMix,sampleVolumes,detectorMatchedOptions,
      detectorExpendedOptions,resolvedNeutralDensityFilter,resolvedAdjustmentSample,
      resolvedTargetSaturationPercentage,unresolveableAdjustmentSampleError,injectionTable,
      resolvedInjectionTable,mySamplesWithReplicates,resolvedIncludeCompensationSamples,resolvedSecondaryTriggerThreshold,
      expandedExcitationPower,expandedInjectionVolume, requiredSampleVolumes,maxVolumesWithReplicates, resolvedAgitateWithReplicates,
      matchingSamplesForDetector,unresolveableAdjustmentSampleErrorOptions,
      unresolveableAdjustmentSampleInvalidOptions,unresolveableAdjustmentSampleTests,resolvedGainExpanded,
      conflictingPreparedPlateInjectionOrderOptions,conflictingPreparedPlateInjectionOrderInvalidOptions,
      conflictingPreparedPlateInjectionOrderTests,resolvedInjectionTableError,resolvedInjectionTableErrorInValidOptions,
      resolvedInjectionTableErrorTests,resolvedSampleVolume,samplesVolumes,

      (*aliquot and post processing*)
      resolvedPostProcessingOptions,confirm,canaryBranch,template,cache,operator,upload,outputOption,subprotocolDescription,
      samplePreparation,email,samplesInStorage,samplesOutStorage,compatibleMaterialsBool, compatibleMaterialsTests,compatibleMaterialsInvalidOption,
      validContainerStorageConditionBool, validContainerStorageConditionTests,
      validContainerStoragConditionInvalidOptions,requiredAliquotAmounts,imageSample,measureWeight,measureVolume,
      volumes,resolvedSampleLabel,resolvedSampleContainerLabel
    },

  (*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Fetch our cache from the parent function. *)
  inheritedCache = Lookup[ToList[myResolutionOptions], Cache, {}];
  fastTrack = Lookup[ToList[myResolutionOptions], FastTrack, False];
  simulation=Lookup[ToList[myResolutionOptions],Simulation];

  (* Separate out our FlowCytometry options from our Sample Prep options. *)
  {samplePrepOptions,flowCytometryOptions}=splitPrepOptions[myOptions];

  (* Resolve our sample prep options *)

  {{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
    resolveSamplePrepOptionsNew[ExperimentFlowCytometry, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation->simulation,Output -> {Result, Tests}],
    {resolveSamplePrepOptionsNew[ExperimentFlowCytometry, mySamples, samplePrepOptions, Cache -> inheritedCache, Simulation->simulation,Output -> Result], {}}
  ];



  (* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
  flowCytometryOptionsAssociation = Association[flowCytometryOptions];

  (* Get our NumberOfReplicates option. *)
  numberOfReplicates=Lookup[myOptions,NumberOfReplicates]/.{Null->1};

  (* pull out all the objects specified in the user given options *)
  instrumentModelObjects=DeleteDuplicates[Cases[ToList[Lookup[myOptions, Instrument]], ObjectP[Model[Instrument,FlowCytometer]]]];
  instrumentObjects=DeleteDuplicates[Cases[ToList[Lookup[myOptions, Instrument]], ObjectP[Object[Instrument,FlowCytometer]]]];
  sampleModelObjects=DeleteDuplicates[Cases[Flatten[ToList[Lookup[myOptions, {FlushSample,AdjustmentSample,UnstainedSample, Reagent, Blank}]]], ObjectP[Model[Sample]]]];
  sampleObjects=DeleteDuplicates[Cases[Flatten[ToList[Lookup[myOptions, {FlushSample,AdjustmentSample,UnstainedSample, Reagent, Blank}]]], ObjectP[Object[Sample]]]];
  methodObjects=DeleteDuplicates[Cases[ToList[Lookup[myOptions, FlowCytometryMethod]], ObjectP[Object[Method,FlowCytometry]]]];
  moleculeObjects=DeleteDuplicates[Cases[Flatten[ToList[Lookup[myOptions, DetectionLabel]]], ObjectP[Model[Molecule]]]];


  (* Extract the packets that we need from our downloaded cache. *)
  (* Remember to download from simulatedSamples, using our simulatedCache *)
  (* Quiet[Download[...],Download::FieldDoesntExist] *)
  (* Extract the packets that we need from our downloaded cache. *)
  allDownloadValues = Quiet[
    Download[
      {
        Flatten[simulatedSamples],
        instrumentModelObjects,
        instrumentObjects,
        sampleModelObjects,
        sampleObjects,
        methodObjects,
        moleculeObjects
      },
      {
        {
          Packet[Object, Type, Status, Container, Count, Volume, Model, Position, Name, Mass, Sterile, StorageCondition, ThawTime, ThawTemperature, IncompatibleMaterials,Composition],
          Packet[Container[{Model, StorageCondition, Name, Contents, TareWeight, Sterile, Status,Contents}]],
          (* sampleContainerModelPackets *)
          Packet[Container[Model[{MaxVolume,NumberOfWells,VacuumCentrifugeCompatibility,MaxTemperature,Name,DefaultStorageCondition}]]],
          (*needed for the Error::DeprecatedModels testing*)
          Packet[Model[{Name, Deprecated}]],
          Packet[Composition[[All, 2]][{Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DetectionLabels,DefaultSampleModel,MolecularWeight}]],
          Packet[Composition[[All, 2]][DetectionLabels][{Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DefaultSampleModel,MolecularWeight}]]
        },
        (*Instrument*)
        {Packet[Object,Detectors,ExcitationLaserPowers,ExcitationLaserWavelengths,QualityControlBeads]},
        {Packet[Model[{Object,Detectors,ExcitationLaserPowers,ExcitationLaserWavelengths,QualityControlBeads}]]},
        (*blanks etc*)
        {Packet[Object]},
        {
          Packet[Model[{Object}]],
          Packet[Container[{Model}]]
        },
        (*methods*)
        {
          Packet[Object,Detector,DetectionLabel,ExcitationWavelength,ExcitationPower,Gain,CompensationMatrix,NeutralDensityFilter]
        },
        (*molecules*)
        {
          Packet[Object,FluorescenceEmissionMaximums,FluorescenceExcitationMaximums,Fluorescent,DefaultSampleModel]
        }
      },
      Cache -> inheritedCache,
      Date->Now,
      Simulation->updatedSimulation
    ],
    {Download::FieldDoesntExist}
  ];

  (* Combine our downloaded and simulated cache. *)
  cacheBall=FlattenCachePackets[{
    allDownloadValues,inheritedCache
  }];

  (* split out the information *)
  {sampleDownloadValues, instrumentModelPackets, instrumentPackets, optionSampleModelPackets,optionSamplePackets,methodPackets, moleculePackets} = allDownloadValues;

  (*join the separate model/object packets*)
  allInstrumentModelPackets=Flatten[Join[{instrumentModelPackets, instrumentPackets}]];
  allOptionSampleModelPackets=Flatten[Join[{optionSampleModelPackets,optionSamplePackets[[All,1]]}]];

  (* split out the sample packets, container packets, and sample model packets *)
  samplePackets = sampleDownloadValues[[All, 1]];
  sampleVolumes=Lookup[samplePackets,Volume];
  containerPackets = sampleDownloadValues[[All, 2]];
  sampleContainerModelPackets = sampleDownloadValues[[All, 3]];
  sampleModelPackets = sampleDownloadValues[[All, 4]];
  sampleContainerModels=Lookup[containerPackets,Model];
  sampleContainerObjects=Lookup[containerPackets,Object];
  sampleMoleculePackets=sampleDownloadValues[[All, 5;;6]];
  containerContents=DeleteDuplicates[Flatten[Lookup[containerPackets,Contents],1]][[All,2]][Object];
  sampleOptionContainers=Lookup[optionSamplePackets[[All,2]],Model,Null];
  sampleOptionContainerRules=If[MatchQ[sampleOptionContainers,Null],<||>,Association[MapThread[#1->#2[Object]&,{sampleObjects,sampleOptionContainers}]]];

  mySamplesWithReplicates=If[
    MatchQ[numberOfReplicates,1],
    mySamples,
    Flatten[Table[#, numberOfReplicates] & /@ mySamples,1]
  ];

  sampleVolumeWithReplicates=MapThread[
    #1/(Count[simulatedSamples,#2]*numberOfReplicates)&,
    {sampleVolumes,simulatedSamples}
  ];

  sampleMolecules=Lookup[#, Object]&/@Flatten[sampleMoleculePackets];
  sampleMoleculeFluorescenceExcitationMaximums=Lookup[#, FluorescenceExcitationMaximums]&/@Flatten[sampleMoleculePackets]/. {$Failed -> {}};
  sampleMoleculeFluorescenceEmissionMaximums=Lookup[#, FluorescenceEmissionMaximums]&/@Flatten[sampleMoleculePackets]/. {$Failed -> {}};
  sampleFluorescentMolecules=PickList[sampleMolecules,sampleMoleculeFluorescenceExcitationMaximums,{GreaterP[1*Nanometer]}];
  fluorescenceChannels=Flatten[Lookup[allInstrumentModelPackets,Detectors],1];
  instExcitationLaserWavelengths=Flatten[Lookup[allInstrumentModelPackets,ExcitationLaserWavelengths],1];
  instExcitationLaserPowers=Flatten[Lookup[allInstrumentModelPackets,ExcitationLaserPowers],1];
  instrumentExcitationLaserWavelengths=Flatten[Lookup[allInstrumentModelPackets,ExcitationLaserWavelengths],1];

  detectorChannels=Select[
    fluorescenceChannels,
    ContainsAny[#,
      Join[
        ToList[Lookup[myOptions,Detector]]/.Automatic->Nothing,
        If[MatchQ[Lookup[myOptions,FlowCytometryMethod], Except[Null]],Flatten[Lookup[Flatten[methodPackets],Detector]],{Nothing}]
      ]
    ]&
  ];

  detectorChannelNames=detectorChannels[[All,1]];
  detectorExcitation=detectorChannels[[All,2]];
  detectorEmissionMin=detectorChannels[[All,8]];
  detectorEmissionMax=detectorChannels[[All,9]];
  fluorescenceChannelNames=fluorescenceChannels[[All,1]];
  fluorescenceChannelExcitation=fluorescenceChannels[[All,2]];
  fluorescenceChannelEmissionMin=fluorescenceChannels[[All,8]];
  fluorescenceChannelEmissionMax=fluorescenceChannels[[All,9]];

  (* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

  engine=MatchQ[$ECLApplication,Engine];

  (*-- INPUT VALIDATION CHECKS --*)
  (* Get the samples from samplePackets that are discarded. *)
  discardedSamplePackets = Cases[samplePackets, KeyValuePattern[Status -> Discarded]];

  (* Set discardedInvalidInputs to the input objects whose statuses are Discarded *)
  discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {}],
    {},
    Lookup[discardedSamplePackets, Object]
  ];

  (* If there are invalid inputs and we are throwing messages,throw an error message and keep track of the invalid inputs.*)
  If[Length[discardedInvalidInputs] > 0 && messages,
    Message[Error::DiscardedSamples, ObjectToString[discardedInvalidInputs, Cache -> cacheBall]]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  discardedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[discardedInvalidInputs] == 0,
        Nothing,
        Test["Our input samples " <> ObjectToString[discardedInvalidInputs, Cache -> cacheBall] <> " are not discarded:", True, False]
      ];
      passingTest = If[Length[discardedInvalidInputs] == Length[flatSampleList],
        Nothing,
        Test["Our input samples " <> ObjectToString[Complement[flatSampleList, discardedInvalidInputs], Cache -> cacheBall] <> " are not discarded:", True, True]
      ];
      {failingTest, passingTest}
    ],
    Nothing
  ];

  (* --- Check if the input samples have Deprecated inputs --- *)

  (* get all the model packets together that are going to be checked for whether they are deprecated *)
  (* need to only get the packets themselves (and not any Nulls that might have slipped through) *)
  modelPacketsToCheckIfDeprecated = Cases[sampleModelPackets, PacketP[Model[Sample]]];

  (* get the samples that are deprecated; if on the FastTrack, don't bother checking *)
  deprecatedModelPackets = If[Not[fastTrack],
    Select[modelPacketsToCheckIfDeprecated, TrueQ[Lookup[#, Deprecated]]&],
    {}
  ];

  (* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
  deprecatedInvalidInputs = If[MatchQ[deprecatedModelPackets, {PacketP[]..}] && messages,
    (
      Message[Error::DeprecatedModels, Lookup[deprecatedModelPackets, Object, {}]];
      Lookup[deprecatedModelPackets, Object, {}]
    ),
    Lookup[deprecatedModelPackets, Object, {}]
  ];

  (* If we are gathering tests, create a passing and/or failing test with the appropriate result. *)
  deprecatedTest = If[gatherTests,
    Module[{failingTest, passingTest},
      failingTest = If[Length[deprecatedInvalidInputs] == 0,
        Nothing,
        Test["Provided samples have models " <> ObjectToString[deprecatedInvalidInputs, Cache -> cacheBall] <> " that are not deprecated:", True, False]
      ];

      passingTest = If[Length[deprecatedInvalidInputs] == Length[modelPacketsToCheckIfDeprecated],
        Nothing,
        Test["Provided samples have models " <> ObjectToString[Download[Complement[modelPacketsToCheckIfDeprecated, deprecatedInvalidInputs], Object,Date->Now], Cache -> cacheBall] <> " that are not deprecated:", True, True]
      ];

      {failingTest, passingTest}
    ],
    Nothing
  ];

  (*Apply the options from the method*)

  (*-- OPTION PRECISION CHECKS --*)
  (* ensure that all the numerical options have the proper precision *)
  {roundedFlowCytometryOptions, precisionTests} = If[gatherTests,
    RoundOptionPrecision[
      Association[flowCytometryOptions],
      {
        AgitationTime,
        FlowRate,
        ExcitationPower,
        Gain,
        TargetSaturationPercentage, TriggerThreshold, SecondaryTriggerThreshold,
        ReagentVolume, BlankInjectionVolume
      },
      {
        1 Second,
        0.1 Microliter/Second,
        1 Milli*Watt,
        1 Volt,
        5 Percent, 1 Percent, 1 Percent,
        1 Microliter, 1 Microliter
      },
      Output -> {Result, Tests}
    ],
    {
      RoundOptionPrecision[
        Association[flowCytometryOptions],
        {
          AgitationTime,
          FlowRate,
          ExcitationPower,
          Gain,
          TargetSaturationPercentage, TriggerThreshold, SecondaryTriggerThreshold,
          ReagentVolume, BlankInjectionVolume
        },
          {
            1 Second,
            0.1 Microliter/Second,
            1 Milli*Watt,
            1 Volt,
            5 Percent, 1 Percent, 1 Percent,
            1 Microliter, 1 Microliter
          }
      ],
      {}
    }
  ];

  (*-- CONFLICTING OPTIONS CHECKS --*)

  (* pull out the options that are defaulted *)
  {
    injectionMode,
    instrument,
    flowCytometryMethod,
    preparedPlate,
    temperature,
    flowRate,
    cellCount,
    flush,
    triggerDetector,
    triggerThreshold,
    secondaryTriggerDetector,
    maxEvents,
    maxGateEvents,
    gateRegion,
    unstainedSample,
    needleWash,
    name,
    parentProtocol
  } =
      Lookup[roundedFlowCytometryOptions,
        {
          InjectionMode,
          Instrument,
          FlowCytometryMethod,
          PreparedPlate,
          Temperature,
          FlowRate,
          CellCount,
          Flush,
          TriggerDetector,
          TriggerThreshold,
          SecondaryTriggerDetector,
          MaxEvents,
          MaxGateEvents,
          GateRegion,
          UnstainedSample,
          NeedleWash,
          Name,
          ParentProtocol
        }
      ];

  lengthSamples=Length[mySamples];
  (*expand this options to match sample length for mapping if needed*)
  expandedCellCount=If[
    MatchQ[cellCount,_List],
    cellCount,
    Table[cellCount,lengthSamples]
  ];

  expandedNeedleWash=If[
    MatchQ[needleWash,_List],
    needleWash,
    Table[needleWash,lengthSamples]
  ];

  expandedFlowRate=If[
    MatchQ[flowRate,_List],
    flowRate,
    Table[flowRate,lengthSamples]
  ];

  expandedInjectionMode=If[
    MatchQ[injectionMode,_List],
    injectionMode,
    Table[injectionMode,lengthSamples]
  ];

  expandedMaxGateEvents=If[
    MatchQ[maxGateEvents,_List],
    maxGateEvents,
    Table[maxGateEvents,lengthSamples]
  ];

  expandedMaxEvents=If[
    MatchQ[maxEvents,_List],
    maxEvents,
    Table[maxEvents,lengthSamples]
  ];

  (* pull out the options that giving in the method object *)
  {
    suppliedDetectors,
    suppliedDetectionLabels,
    suppliedExcitationWavelengths,
    suppliedExcitationPowers
  }=Which[
    (*user specified*)
    MatchQ[Lookup[roundedFlowCytometryOptions,#],Except[Automatic|{Automatic..}]],
    Lookup[roundedFlowCytometryOptions,#],
    (*method specified*)
    MatchQ[Lookup[myOptions,FlowCytometryMethod], Except[Null]],
    Flatten[Lookup[Flatten[methodPackets],#]],
    (*leave as automatic user specified*)
    True,
    Lookup[roundedFlowCytometryOptions,#]
  ]&/@{
    Detector,
    DetectionLabel,
    ExcitationWavelength,
    ExcitationPower
  };

  resolvedGain=Which[
    (*user specified*)
    MatchQ[Lookup[roundedFlowCytometryOptions,Gain],Except[Automatic|{Automatic..}]],
    Lookup[roundedFlowCytometryOptions,Gain],
    (*method specified*)
    MatchQ[Lookup[myOptions,FlowCytometryMethod], Except[Null]],
    Flatten[Lookup[Flatten[methodPackets],Gain]],
    (*resolve to auto if targerget percentage*)
    MatchQ[Lookup[myOptions,TargetSaturationPercentage], Except[NullP|Automatic|{Automatic..}]],
    Auto,
    (*resolve to auto if adjustment sample and not doing compensation*)
    MatchQ[Lookup[myOptions,AdjustmentSample], Except[NullP|Automatic|{Automatic..}]]&& MatchQ[Lookup[myOptions,IncludeCompensationSamples], False],
    Auto,
    True,
    QualityControl
  ];


  resolvedNeutralDensityFilter=Which[
    (*user specified*)
    MatchQ[ Lookup[roundedFlowCytometryOptions,NeutralDensityFilter],Except[Automatic|{Automatic..}]],
    Lookup[roundedFlowCytometryOptions,NeutralDensityFilter],
    (*method specified*)
    MatchQ[Lookup[myOptions,FlowCytometryMethod], Except[Null]],
    Flatten[Lookup[Flatten[methodPackets],NeutralDensityFilter]],
    (*resolve to False*)
    True,
    False
  ];

  (* --- Make sure the Name isn't currently in use --- *)

  (* If the specified Name is not in the database, it is valid *)
  validNameQ = If[MatchQ[name, _String],
    Not[DatabaseMemberQ[Object[Protocol, FlowCytometry, name]]],
    True
  ];

  (* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
  nameInvalidOptions = If[Not[validNameQ] && messages,
    (
      Message[Error::DuplicateName, "Flow Cytometery protocol"];
      {Name}
    ),
    {}
  ];

  (* Generate Test for Name check *)
  validNameTest = If[gatherTests && MatchQ[name,_String],
    Test["If specified, Name is not already a Flow Cytometry object name:",
      validNameQ,
      True
    ],
    Null
  ];

  expandedRecoupSample=If[
    MatchQ[Lookup[roundedFlowCytometryOptions,RecoupSample],_List],
    Lookup[roundedFlowCytometryOptions,RecoupSample],
    Table[Lookup[roundedFlowCytometryOptions,RecoupSample],lengthSamples]
  ];

  (*Error::ConflictingContinuousModeOptions="Highthoughput injection mode is selected. In this mode CellCount and Recoup Sample must be False. Please change InjectionMode to Individual or `1` to False.";*)
  conflictingContinuousModeOptions=If[
    (*Is the high throughput InjectionMode selected with unsupported options?*)
    Or[
      MemberQ[PickList[expandedInjectionMode,expandedCellCount],Continuous],
      MemberQ[PickList[expandedInjectionMode,expandedRecoupSample],Continuous]
    ],
    (*return a the unsupported options*)
    {If[MemberQ[PickList[expandedInjectionMode,expandedCellCount],Continuous],CellCount,Nothing],If[MemberQ[PickList[expandedInjectionMode,expandedRecoupSample],Continuous],RecoupSample,Nothing]},
    Nothing
  ];

  (*give the corresponding error*)
 conflictingContinuousModeInvalidOptions=If[Length[conflictingContinuousModeOptions]>0&&!gatherTests,
    Message[Error::ConflictingContinuousModeOptions,conflictingContinuousModeOptions];
    Join[{InjectionMode,conflictingContinuousModeOptions}],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingContinuousModeTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingContinuousModeInvalidOptions]==0,
        Test["If a Highthroughput InjectionMode is selected CellCount and RecoupSample are False:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingContinuousModeInvalidOptions]>0,
        Test["If a Highthoughput InjectionMode is selected CellCount and RecoupSample are False:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (* In high-throughput mode, the Event Rate option is not available, and all samples must be assigned the same flow rate. All
samples in a high-throughput run must use the same target flow rate. 0.5-2.5 µl/set*)
  (*Error::ConflictingContinuousModeFlowRateOptions="Continuous injection mode is selected. In this mode the flow rate must be the same for each sample and 0.5-2.5 µl/sec.";*)

  conflictingContinuousModeFlowRateOptions=If[
    (*Is the high throughput InjectionMode selected with unsupported options?*)
    Or[
      MemberQ[PickList[expandedInjectionMode,expandedFlowRate,Except[RangeP[0.5Microliter/Second,2.5Microliter/Second]]],Continuous],
      MatchQ[PickList[expandedFlowRate,expandedInjectionMode,Continuous],Except[{}]]&&MemberQ[PickList[expandedFlowRate,expandedInjectionMode,Continuous],Except[First[PickList[expandedFlowRate,expandedInjectionMode,Continuous]]]]
    ],
    (*return a the unsupported options*)
    {InjectionMode,FlowRate},
    Nothing
  ];

  (*give the corresponding error*)
  conflictingContinuousModeFlowRateInvalidOptions=If[Length[conflictingContinuousModeFlowRateOptions]>0&&!gatherTests,
    Message[Error::ConflictingContinuousModeFlowRateOptions];
    conflictingContinuousModeFlowRateOptions,
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingContinuousModeFlowRateTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingContinuousModeFlowRateOptions]==0,
        Test["If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 ul/sec:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingContinuousModeFlowRateOptions]>0,
        Test["If a Continuous injection mode is selected the flow rate must be the same for each sample and 0.5-2.5 ul/sec:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (* Event limit, gate limit are not allowed for continuos*)

  conflictingContinuousModeLimitOptions=If[
    (*Is the high throughput InjectionMode selected with unsupported options?*)
    Or[
      MemberQ[PickList[expandedInjectionMode,expandedMaxGateEvents,Except[None]],Continuous],
      MemberQ[PickList[expandedInjectionMode,expandedMaxEvents,Except[None]],Continuous]
    ],
    (*return a the unsupported options*)
    {If[ MemberQ[PickList[expandedInjectionMode,expandedMaxEvents,Except[None]],Continuous],MaxEvents,Nothing],If[MemberQ[PickList[expandedInjectionMode,expandedMaxGateEvents,Except[None]],Continuous],MaxGateEvents,Nothing]},
    Nothing
  ];

  (*give the corresponding error*)
  conflictingContinuousModeLimitInvalidOptions=If[Length[conflictingContinuousModeLimitOptions]>0&&!gatherTests,
    Message[Error::ConflictingContinuousModeLimitOptions,conflictingContinuousModeLimitOptions];
    Join[conflictingContinuousModeLimitOptions,{InjectionMode}],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingContinuousModeLimitTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingContinuousModeLimitOptions]==0,
        Test["If a Continuous injection mode is selected the MaxEvent and MaxGateEvents cannot be selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingContinuousModeLimitOptions]>0,
        Test["If a Continuous injection mode is selected the MaxEvent and MaxGateEvents cannot be selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Flush is not available if you selected HighThroughput or Volumetric Counting.*)
  conflictingFlushInjectionOptions=If[
    (*Is the high throughput InjectionMode selected with unsupported options?*)
    Or[
      MatchQ[flush,True]&&MemberQ[expandedInjectionMode,Continuous],
      MatchQ[flush,True]&&MemberQ[ToList[cellCount],True]
    ],
    (*return a the unsupported options*)
    {Flush,If[MemberQ[expandedInjectionMode,Continuous],InjectionMode,Nothing],If[MemberQ[ToList[cellCount],True],CellCount,Nothing]},
    Nothing
  ];

  (*give the corresponding error*)
  conflictingFlushInjectionInvalidOptions=If[Length[conflictingFlushInjectionOptions]>0&&!gatherTests,
    Message[Error::ConflictingFlushInjectionOptions];
    conflictingFlushInjectionOptions,
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingFlushInjectionTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingFlushInjectionOptions]==0,
        Test["If Flush is selected CellCount and Continuous injection mode are not selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingFlushInjectionOptions]>0,
        Test["If Flush is selected CellCount and Continuous injection mode are not selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingPreparedPlateReagentOptions="A PreparedPlate is selected. In this case, Reagent addition options can only be selected if the reagent object is inside the plate. Please change PrepapredPlate to False or `1` to Null.";*)
  conflictingPreparedPlateReagentOptions=If[
    (*Is the prepared plate selected with unsupported options?*)
    MatchQ[preparedPlate,True]&&
        MemberQ[Join[ToList[Lookup[roundedFlowCytometryOptions,Reagent]],ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],ToList[Lookup[roundedFlowCytometryOptions,ReagentVolume]]],Except[False|Null|Automatic]]&&
            And[
              (*its not in the plate*)
              !ContainsAll[containerContents,ToList[Lookup[roundedFlowCytometryOptions,Reagent]]],
              (*its not in facs tubes*)
              !And[
                MatchQ[Lookup[sampleOptionContainerRules,#]&/@ToList[Lookup[roundedFlowCytometryOptions,Reagent]],{ObjectP[Model[Container,Vessel,"5mL Tube"]]..}],
                MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}]
              ]
            ],
    (*return a the unsupported options*)
    {
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,Reagent]],Except[False|Null|Automatic]],Reagent,Nothing],
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],Except[False|Null|Automatic]],AddReagent,Nothing],
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,ReagentVolume]],Except[False|Null|Automatic]],ReagentVolume,Nothing]
    },
    Nothing
  ];

  (*give the corresponding error*)
  conflictingPreparedPlateReagentInvalidOptions=If[Length[conflictingPreparedPlateReagentOptions]>0&&!gatherTests,
    Message[Error::ConflictingPreparedPlateReagentOptions,conflictingPreparedPlateReagentOptions];
    Join[{PreparedPlate,conflictingPreparedPlateReagentOptions}],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedPlateReagentTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingPreparedPlateReagentOptions]==0,
        Test["If a PreparedPlate is given, no Reagent addition options are selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingPreparedPlateReagentOptions]>0,
        Test["If a PreparedPlate is given, no Reagent addition options are selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingPreparedPlateBlankOptions="A PreparedPlate is selected. In this case, Blank addition options can only be selected if the Blank object is inside the plate. Please change PrepapredPlate to False or `1` to Null.";*)
  conflictingPreparedPlateBlankOptions=If[
    (*Is the prepared plate selected with unsupported options?*)
    MatchQ[preparedPlate,True]&&
        MemberQ[Join[ToList[Lookup[roundedFlowCytometryOptions,Blank]],ToList[Lookup[roundedFlowCytometryOptions,BlankFrequency]],ToList[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume]]],Except[False|Null|Automatic]]&&
        And[
          (*its not in the plate*)
          !ContainsAll[containerContents,ToList[Lookup[roundedFlowCytometryOptions,Blank]]],
          (*its not in facs tubes*)
          !And[
            MatchQ[Lookup[sampleOptionContainerRules,#]&/@ToList[Lookup[roundedFlowCytometryOptions,Blank]],{ObjectP[Model[Container,Vessel,"5mL Tube"]]..}],
            MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}]
          ]
        ],
    (*return a the unsupported options*)
    {
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,Blank]],Except[False|Null|Automatic]],Blank,Nothing],
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,BlankFrequency]],Except[False|Null|Automatic]],BlankFrequency,Nothing],
      If[MemberQ[ToList[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume]],Except[False|Null|Automatic]],BlankInjectionVolume,Nothing]
    },
    Nothing
  ];

  (*give the corresponding error*)
  conflictingPreparedPlateBlankInvalidOptions=If[Length[conflictingPreparedPlateBlankOptions]>0&&!gatherTests,
    Message[Error::ConflictingPreparedPlateBlankOptions,conflictingPreparedPlateBlankOptions];
    Join[{PreparedPlate,conflictingPreparedPlateBlankOptions}],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedPlateBlankTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingPreparedPlateBlankOptions]==0,
        Test["If a PreparedPlate is given, no conflicting Blank options are selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingPreparedPlateBlankOptions]>0,
        Test["If a PreparedPlate is given, no conflicting Blank options are selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];


  (*Error::ConflictingPreparedPlateUnstainedSampleOptions="A PreparedPlate is selected. In this case, UnstainedSample options can only be selected if the UnstainedSample object is inside the plate. Please change PrepapredPlate to False or `1` to Null.";*)
  conflictingPreparedPlateUnstainedSampleOptions=If[
    (*Is the prepared plate selected with unsupported options?*)
    MatchQ[preparedPlate,True]&&
        MatchQ[Lookup[roundedFlowCytometryOptions,UnstainedSample],Except[Null|Automatic|None]]&&
        And[
          (*its not in the plate*)
          !ContainsAll[containerContents,ToList[Lookup[roundedFlowCytometryOptions,UnstainedSample]]],
          (*its not in facs tubes*)
          !And[
            MatchQ[Lookup[sampleOptionContainerRules,#]&/@ToList[Lookup[roundedFlowCytometryOptions,UnstainedSample]],{ObjectP[Model[Container,Vessel,"5mL Tube"]]..}],
            MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}]
          ]
        ],
    (*return a the unsupported options*)
    {
      UnstainedSample
    },
    Nothing
  ];

  (*give the corresponding error*)
  conflictingPreparedPlateUnstainedSampleInvalidOptions=If[Length[conflictingPreparedPlateUnstainedSampleOptions]>0&&!gatherTests,
    Message[Error::ConflictingPreparedPlateUnstainedSampleOptions,conflictingPreparedPlateUnstainedSampleOptions];
    Join[{PreparedPlate,conflictingPreparedPlateUnstainedSampleOptions}],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedPlateUnstainedSampleTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingPreparedPlateUnstainedSampleOptions]==0,
        Test["If a PreparedPlate is given, no conflicting UnstainedSample options are selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingPreparedPlateUnstainedSampleOptions]>0,
        Test["If a PreparedPlate is given, no conflicting UnstainedSample options are selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingPreparedPlateAdjustmentSampleOptions="A PreparedPlate is selected. In this case, AdjustmentSample addition options can only be selected if the AdjustmentSample object is inside the plate. Please change PrepapredPlate to False or `1` to Null.";*)
    conflictingPreparedPlateAdjustmentSampleOptions=If[
      (*Is the prepared plate selected with unsupported options?*)
      MatchQ[preparedPlate,True]&&
          MemberQ[ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]],Except[Null|Automatic]]&&
          And[
            (*its not in the plate*)
            !ContainsAll[containerContents,ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]]],
            (*its not in facs tubes*)
            !And[
              MatchQ[Lookup[sampleOptionContainerRules,#]&/@ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]],{ObjectP[Model[Container,Vessel,"5mL Tube"]]..}],
              MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}]
            ]
          ],
      (*return a the unsupported options*)
      {
        AdjustmentSample
      },
      Nothing
    ];

    (*give the corresponding error*)
    conflictingPreparedPlateAdjustmentSampleInvalidOptions=If[Length[conflictingPreparedPlateAdjustmentSampleOptions]>0&&!gatherTests,
      Message[Error::ConflictingPreparedPlateAdjustmentSampleOptions,conflictingPreparedPlateAdjustmentSampleOptions];
      Join[{PreparedPlate,conflictingPreparedPlateAdjustmentSampleOptions}],
      {}
    ];

    (* If we are gathering tests, create tests with the appropriate results. *)
    conflictingPreparedPlateAdjustmentSampleTests=If[gatherTests,
      (* We're gathering tests. Create the appropriate tests. *)
      Module[{passingInputsTest,failingInputsTest},
        (* Create a test for the passing inputs. *)
        passingInputsTest=If[Length[conflictingPreparedPlateAdjustmentSampleOptions]==0,
          Test["If a PreparedPlate is given, no conflicting AdjustmentSample options are selected:",True,True],
          Nothing
        ];
        (* Create a test for the non-passing inputs. *)
        failingInputsTest=If[Length[conflictingPreparedPlateAdjustmentSampleOptions]>0,
          Test["If a PreparedPlate is given, no conflicting AdjustmentSample options are selected:",True,False],
          Nothing
        ];
        (* Return our created tests. *)
        {
          passingInputsTest,
          failingInputsTest
        }
      ],
      (* We aren't gathering tests. No tests to create. *)
      {}
    ];


  (*Error::ConflictingAgitationOptions="Agitation (`1`) and  AgitationFrequency (`2`) are both spreficied. Only one option can be specified. Please set one of these options to Automatic or None,";*)
  conflictingAgitationOptions=If[
    (*Is the high throughput InjectionMode selected with unsupported options?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,AgitationFrequency],Except[None|Automatic|Null]]&&MemberQ[ToList[Lookup[roundedFlowCytometryOptions,Agitate]],Except[Null|Automatic]],
    {Agitate,AgitationFrequency},
    Nothing
  ];

  (*give the corresponding error*)
  conflictingAgitationInvalidOptions=If[Length[conflictingAgitationOptions]>0&&!gatherTests,
    Message[Error::ConflictingAgitationOptions,Lookup[roundedFlowCytometryOptions,Agitate],Lookup[roundedFlowCytometryOptions,AgitationFrequency]];
    conflictingAgitationOptions,
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingAgitationTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingAgitationOptions]==0,
        Test["If a AgitationFrequency is given, Agitation is not selected:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingAgitationOptions]>0,
        Test["If a AgitationFrequency is given, Agitation is not selected:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::MustSpecifyAgitationTime="Agitate is `1`. The AgitationTime `2` must be specified.";*)
  mustSpecifyAgitationTimeOptions=If[
    (*If agation is selected, is AgitationTime Null?*)
    MemberQ[PickList[ToList[Lookup[roundedFlowCytometryOptions,AgitationTime]],ToList[Lookup[roundedFlowCytometryOptions,Agitate]]],Null],
    {Agitate,AgitationTime},
    Nothing
  ];

  (*give the corresponding error*)
  mustSpecifyAgitationTimeInvalidOptions=If[Length[mustSpecifyAgitationTimeOptions]>0&&!gatherTests,
    Message[Error::MustSpecifyAgitationTime,Lookup[roundedFlowCytometryOptions,Agitate],Lookup[roundedFlowCytometryOptions,AgitationTime]];
    mustSpecifyAgitationTimeOptions,
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  mustSpecifyAgitationTimeTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[mustSpecifyAgitationTimeOptions]==0,
        Test["If a Agitate is specified, AgitationTime is not Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[mustSpecifyAgitationTimeOptions]>0,
        Test["If a Agitate is specified, AgitationTime is not Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];
  (* Error::ConflictingFlushOptions="Flush is `1`, and `2` is Null. Please specify `2` or set it to Automatic.";*)
  conficitingFlushOptions=If[
    (*If Flush is selected, is FlushFrequency, FlushSample and FlushSpeed are not Null?*)
    MatchQ[flush,True]&& MemberQ[{Lookup[roundedFlowCytometryOptions,FlushFrequency],Lookup[roundedFlowCytometryOptions,FlushSample],Lookup[roundedFlowCytometryOptions,FlushSpeed]},Null],
    (*return a the unsupported options*)
    {If[MatchQ[Lookup[roundedFlowCytometryOptions,FlushFrequency],Null],FlushFrequency,Nothing],If[MatchQ[Lookup[roundedFlowCytometryOptions,FlushSample],Null],FlushSample,Nothing],If[MatchQ[Lookup[roundedFlowCytometryOptions,FlushSpeed],Null],FlushSpeed,Nothing]},
    Nothing
  ];

  (*give the corresponding error*)
  conficitingFlushInvalidOptions=If[Length[conficitingFlushOptions]>0&&!gatherTests,
    Message[Error::ConflictingFlushOptions,flush,conficitingFlushOptions];
    Join[{Flush},conficitingFlushOptions],
    {}
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conficitingFlushTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conficitingFlushOptions]==0,
        Test["If a Flush is specified, FlushFrequency, FlushSample and FlushSpeed are not Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conficitingFlushOptions]>0,
        Test["If a Flush is specified, FlushFrequency, FlushSample and FlushSpeed are not Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Before we continue error checking we will resolve the IndexMatchingParent options and expand out the options index matched to it*)

  (*Warning::ConflictingDetectorsAndFluorophores="The selected Detector `1` is not designed to measure the fluorescence in any of the fluorophores present in the input samples.";*)
  excitationMatchBools=MemberQ[
    Flatten[sampleMoleculeFluorescenceExcitationMaximums],
    RangeP[# - 20 Nanometer, # + 20 Nanometer]
  ]& /@ PickList[detectorExcitation,detectorChannelNames,Except["488 FSC" | "488 SSC" | "405 FSC"]];

  emissionMatchBools=MapThread[MemberQ[
    Flatten[sampleMoleculeFluorescenceEmissionMaximums],
    RangeP[#1, #2]
  ]&, {PickList[detectorEmissionMin,detectorChannelNames,Except["488 FSC" | "488 SSC" | "405 FSC"]], PickList[detectorEmissionMax,detectorChannelNames,Except["488 FSC" | "488 SSC" | "405 FSC"]]/.Null->Infinity}];
  (*)
  conficitingDetectorsAndFluorophoresOptions=If[
    (*Is the Detector not meant for the Fluorophores in the sample?*)
    MatchQ[ToList[suppliedDetectors],Except[Automatic|{Automatic..}]]&&Or[MemberQ[excitationMatchBools,False],MemberQ[emissionMatchBools,False]],
    (*return a the unsupported options and warning*)
    {Detector},
    Nothing
  ];

  If[Length[conficitingDetectorsAndFluorophoresOptions]>0&&!gatherTests&&!engine,
    Message[Warning::ConflictingDetectorsAndFluorophores,
      DeleteDuplicates[Join[PickList[Cases[detectorChannelNames,Except["488 FSC" | "488 SSC" | "405 FSC"]],excitationMatchBools,False],PickList[Cases[detectorChannelNames,Except["488 FSC" | "488 SSC" | "405 FSC"]],emissionMatchBools,False]]],sampleMolecules],
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conficitingDetectorsAndFluorophoresTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conficitingDetectorsAndFluorophoresOptions]==0,
        Test["The Detector matches the excitation and emission wavelengths of a fuorophore present on an input sample:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conficitingDetectorsAndFluorophoresOptions]>0,
        Test["The Detector matches the excitation and emission wavelengths of a fuorophore present on an input sample:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];
  *)

  (*Warning::ConflictingDetecorAndDetectionLabel="The selected Detector `1` is not designed to measure the fluorescence DetectionLabel `2`.";*)

  {detectionLabelExcitation,detectionLabelEmission}=If[
    MatchQ[ToList[suppliedDetectionLabels],Except[Automatic|{Automatic..}]],
    Transpose[
      If[
        MatchQ[#,Null],
        {Null,Null},
        Flatten[Lookup[fetchPacketFromCache[#[Object],cacheBall],{FluorescenceExcitationMaximums,FluorescenceEmissionMaximums}]]
      ]&/@ToList[suppliedDetectionLabels]
    ],
    {Null,Null}
  ];

  detectionLabelExcitationMatchBools= If[
    MatchQ[ToList[suppliedDetectors],Except[Automatic|{Automatic..}]]&&MatchQ[ToList[suppliedDetectionLabels],Except[Automatic|{Automatic..}]],
    MapThread[MatchQ[
      #1,
      RangeP[#2 - 20 Nanometer, #2 + 20 Nanometer]|Null
    ]&,{detectionLabelExcitation,detectorExcitation}],
    Null
  ];

  detectionLabelEmissionMatchBools=If[
    MatchQ[ToList[suppliedDetectors],Except[Automatic|{Automatic..}]]&&MatchQ[ToList[suppliedDetectionLabels],Except[Automatic|{Automatic..}]],
    MapThread[MatchQ[
      #1,
      RangeP[#2, #3]|Null
    ]&, {detectionLabelEmission,detectorEmissionMin, detectorEmissionMax/.Null->Infinity}],
    Null
  ];
  (*
  conficitingDetecorAndDetectionLabelOptions=If[
    (*Is the Detector not meant for the Fluorophores in the sample?*)
    MatchQ[ToList[suppliedDetectors],Except[Automatic|{Automatic..}]]&&MatchQ[ToList[suppliedDetectionLabels],Except[Automatic|{Automatic..}]]&&Or[MemberQ[detectionLabelExcitationMatchBools,False],MemberQ[detectionLabelEmissionMatchBools,False]],
    (*return a the unsupported options and warning*)
    {Detector,DetectionLabel},
    Nothing
  ];

  If[Length[conficitingDetecorAndDetectionLabelOptions]>0&&!gatherTests&&!engine,
    Message[Warning::ConflictingDetecorAndDetectionLabel,
      DeleteDuplicates[Join[PickList[ToList[suppliedDetectors],detectionLabelExcitationMatchBools,False],PickList[ToList[suppliedDetectors],detectionLabelEmissionMatchBools,False]]],
      DeleteDuplicates[Join[PickList[ToList[suppliedDetectionLabels],detectionLabelExcitationMatchBools,False],PickList[ToList[suppliedDetectionLabels],detectionLabelEmissionMatchBools,False]]]
    ],
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conficitingDetecorAndDetectionLabelTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conficitingDetecorAndDetectionLabelOptions]==0,
        Test["The Detector matches the excitation and emission wavelengths of the DetectionLabel:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conficitingDetecorAndDetectionLabelOptions]>0,
        Test["The Detector matches the excitation and emission wavelengths of the DetectionLabel:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];
  (*Error::ConflictingExcitationWavelengthDetector="The ExcitationWaveLength `1` does not match the detectors `2`. Please change the ExcitationWaveLength to `3`.";*)
*)
  conficitingExcitationWavelengthDetectorOptions=If[
    (*Is the Detector not meant for the Fluorophores in the sample?*)
    MatchQ[ToList[suppliedExcitationWavelengths],Except[{Automatic..}]]&&!ContainsExactly[detectorExcitation, ToList[suppliedExcitationWavelengths], SameTest -> Equal],
    (*return a the unsupported options and warning*)
    {ExcitationWavelength,Detector},
    Nothing
  ];

  conficitingExcitationWavelengthDetectorInvalidOptions=If[Length[conficitingExcitationWavelengthDetectorOptions]>0&&!gatherTests,
    Message[Error::ConflictingExcitationWavelengthDetector,
      suppliedExcitationWavelengths,
      suppliedDetectors,
      detectorExcitation
    ];
    conficitingExcitationWavelengthDetectorOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conficitingExcitationWavelengthDetectorTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conficitingExcitationWavelengthDetectorOptions]==0,
        Test["The ExcitationWaveLengthMatches the detector:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conficitingExcitationWavelengthDetectorOptions]>0,
        Test["The ExcitationWaveLengthMatches the detector:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingNeutralDensityFilter="The NeutralDensityFilter can only be used for non-fluoresence scatter detectors. Please change NeutralDensityFilter to False for `1`.";*)
  conflicitingNeutralDensityFilterOptions=If[
    (*Is NeutralDensityFilter True for a fluorecence channel?*)
    !MatchQ[PickList[If[MatchQ[suppliedDetectors,_List],suppliedDetectors,Table[suppliedDetectors,Length[ToList[resolvedNeutralDensityFilter]]]],If[MatchQ[resolvedNeutralDensityFilter,_List],resolvedNeutralDensityFilter,Table[resolvedNeutralDensityFilter,Length[ToList[suppliedDetectors]]]]],{"488 FSC"|"405 FSC"..}|{}],
    (*return a the unsupported options and warning*)
    {Detector,NeutralDensityFilter},
    Nothing
  ];

  conflicitingNeutralDensityFilterInvalidOptions=If[Length[conflicitingNeutralDensityFilterOptions]>0&&!gatherTests,
    Message[Error::ConflictingNeutralDensityFilter,
      DeleteCases[PickList[ToList[suppliedDetectors],ToList[resolvedNeutralDensityFilter]],"488 FSC"|"405 FSC"]
    ];
  conflicitingNeutralDensityFilterOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingNeutralDensityFilterTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingNeutralDensityFilterOptions]==0,
        Test["The NeutralDensityFilter is only used for non-fluorence scatter detectors:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingNeutralDensityFilterOptions]>0,
        Test["The NeutralDensityFilter is only used for non-fluorence scatter detectors:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::GainOptimizationOptions="The AdjustmentSample (`1`) or TargetSaturationPercentage (`2`) can only be  Null if and only if Gain (`3`) are not Auto.";*)
  conflicitingGainOptimizationOptions=If[
    (*Is OptimizeGain True and True AdjustmentSample or TargetSaturationPercentage Null?*)
    Or[
      MemberQ[
        PickList[
          If[MatchQ[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],_List],Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],Table[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],Length[ToList[resolvedGain]]]],
          If[MatchQ[resolvedGain,_List],resolvedGain,Table[resolvedGain,Length[ToList[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage]]]]],
          Auto],
        Null
      ],
      MemberQ[
        PickList[
          If[MatchQ[Lookup[roundedFlowCytometryOptions,AdjustmentSample],_List],Lookup[roundedFlowCytometryOptions,AdjustmentSample],Table[Lookup[roundedFlowCytometryOptions,AdjustmentSample],Length[ToList[resolvedGain]]]],
          If[MatchQ[resolvedGain,_List],resolvedGain,Table[resolvedGain,Length[ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]]]]],
          Auto],
        Null
      ],
      (*Is OptimizeGain False True AdjustmentSample or TargetSaturationPercentage not Null/Automatic?*)
      MemberQ[
        PickList[
          If[MatchQ[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],_List],Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],Table[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],Length[ToList[resolvedGain]]]],
          If[MatchQ[resolvedGain,_List],resolvedGain,Table[resolvedGain,Length[ToList[Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage]]]]],
          Except[Auto]],
        Except[Null|Automatic]
      ]
    ],
    (*return a the unsupported options and warning*)
    {Gain,TargetSaturationPercentage,AdjustmentSample},
    Nothing
  ];

  conflicitingGainOptimizationInvalidOptions=If[Length[conflicitingGainOptimizationOptions]>0&&!gatherTests,
    Message[Error::GainOptimizationOptions,
      Lookup[roundedFlowCytometryOptions,AdjustmentSample],
      Lookup[roundedFlowCytometryOptions,TargetSaturationPercentage],
      resolvedGain
    ];
    conflicitingGainOptimizationOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingGainOptimizationTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingGainOptimizationOptions]==0,
        Test["AdjustmentSample or TargetSaturationPercentage are Null if and only if Gain are not Auto:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingGainOptimizationOptions]>0,
        Test["AdjustmentSample or TargetSaturationPercentage are Null if and only if Gain are not Auto:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];
  (*Error::ConflictingSecondaryTriggerOptions="The SecondaryTriggerDetector (`1`) can only be Null if and only if SecondaryTriggerThreshold (`2`) is Null.";*)
  conflicitingSecondaryTriggerOptions=If[
    (*Is SecondaryTrigger Detector  Null and Secondary TriggerDetector not Null?*)
    Or[
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,SecondaryTriggerDetector]],
          ToList[Lookup[roundedFlowCytometryOptions,SecondaryTriggerThreshold]],
          Null],
        Except[Null|Automatic]
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,SecondaryTriggerDetector]],
          ToList[Lookup[roundedFlowCytometryOptions,SecondaryTriggerThreshold]],
          Except[Null|Automatic]],
        Null
      ]
    ],
    (*return a the unsupported options and warning*)
    {SecondaryTriggerDetector,SecondaryTriggerThreshold},
    Nothing
  ];

  conflicitingSecondaryTriggerInvalidOptions=If[Length[conflicitingSecondaryTriggerOptions]>0&&!gatherTests,
    Message[Error::ConflictingSecondaryTriggerOptions,
      Lookup[roundedFlowCytometryOptions,SecondaryTriggerDetector],
      Lookup[roundedFlowCytometryOptions,SecondaryTriggerThreshold]
    ];
    conflicitingSecondaryTriggerOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingSecondaryTriggerTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingSecondaryTriggerOptions]==0,
        Test["SecondaryTriggerDetector is Null if and only if SecondaryTriggerThreshold is Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingSecondaryTriggerOptions]>0,
        Test["SecondaryTriggerDetector is Null if and only if SecondaryTriggerThreshold is Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingGateOptions="MaxGateEvents (`1`) can only be None if and only if GateRegion (`2`) is Null";*)
  conflicitingGateOptions=If[
    (*Is MaxGateEvents Set but GateRegio is Null?*)
    Or[
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,GateRegion]],
          ToList[Lookup[roundedFlowCytometryOptions,MaxGateEvents]],
          None|Null],
        Except[Null|Automatic]
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,GateRegion]],
          ToList[Lookup[roundedFlowCytometryOptions,MaxGateEvents]],
          Except[None|Null|Automatic]],
        Null
      ]
    ],
    (*return a the unsupported options and warning*)
    {MaxGateEvents,GateRegion},
    Nothing
  ];

  conflicitingGateInvalidOptions=If[Length[conflicitingGateOptions]>0&&!gatherTests,
    Message[Error::ConflictingGateOptions,
      Lookup[roundedFlowCytometryOptions,MaxGateEvents],
      Lookup[roundedFlowCytometryOptions,GateRegion]
    ];
    conflicitingGateOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingGateTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingGateOptions]==0,
        Test["MaxGateEvents is None if and only if GateRegion is Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingGateOptions]>0,
        Test["MaxGateEvents is None if and only if GateRegion is Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::MustSpecifyAdjustmentSamplesForCompensation="IncludeCompensationSamples is True and AdjustmentSamples are not provided. Please select AdjustmentSample for the `1` Detector or set IncludeCompensationSamples to False.";*)

  mustSpecifyAdjustmentSamplesForCompensationOptions=If[
    (*Is IncludeCompensationSamples True and not enough AdjustmentSamples are given or fluorophore channels?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,IncludeCompensationSamples],True]&&
        MemberQ[PickList[ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]], ToList[suppliedDetectors], Except["488 FSC" | "488 SSC" | "405 FSC"]],Null],
    (*return a the unsupported options and warning*)
    Cases[PickList[ToList[suppliedDetectors], ToList[Lookup[roundedFlowCytometryOptions,AdjustmentSample]], Null],Except["488 FSC" | "488 SSC" | "405 FSC"]],
    Nothing
  ];

  mustSpecifyAdjustmentSamplesForCompensationInvalidOptions=If[Length[mustSpecifyAdjustmentSamplesForCompensationOptions]>0&&!gatherTests,
    Message[Error::MustSpecifyAdjustmentSamplesForCompensation,mustSpecifyAdjustmentSamplesForCompensationOptions];
    {IncludeCompensationSamples,AdjustmentSample},
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  mustSpecifyAdjustmentSamplesForCompensationTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[mustSpecifyAdjustmentSamplesForCompensationOptions]==0,
        Test["If IncludeCompensationSamples is True, AdjustmentSamples are provided:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[mustSpecifyAdjustmentSamplesForCompensationOptions]>0,
        Test["If IncludeCompensationSamples is True, AdjustmentSamples are provided:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingAddReagentOptions="AddReagent (`1`) is False if and only if Reagent (`2`), ReagentVolume (`3`) and ReagentMix (`4`) are Null";*)
  conflicitingAddReagentOptions=If[
    (*Is AddReagent True and Reagent, ReagentVolume, or  ReagentMix Null?*)
    Or[
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,Reagent]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
         False],
        Except[Null|Automatic]
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,ReagentVolume]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
          False],
        Except[Null|Automatic]
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,ReagentMix]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
          False],
        Except[Null|Automatic]
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,Reagent]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
          True],
        Null
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,ReagentVolume]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
          True],
        Null
      ],
      MemberQ[
        PickList[
          ToList[Lookup[roundedFlowCytometryOptions,ReagentMix]],
          ToList[Lookup[roundedFlowCytometryOptions,AddReagent]],
          True],
        Null
      ]
    ],
    (*return a the unsupported options and warning*)
    {AddReagent, Reagent, ReagentVolume, ReagentMix},
    Nothing
  ];

  conflicitingAddReagentInvalidOptions=If[Length[conflicitingAddReagentOptions]>0&&!gatherTests,
    Message[Error::ConflictingAddReagentOptions,
      Lookup[roundedFlowCytometryOptions,AddReagent],
      Lookup[roundedFlowCytometryOptions,Reagent],
      Lookup[roundedFlowCytometryOptions,ReagentVolume],
      Lookup[roundedFlowCytometryOptions,ReagentMix]
    ];
    conflicitingAddReagentOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingAddReagentTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingAddReagentOptions]==0,
        Test["AddReagent is False if and only if  Reagent addition options are Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingAddReagentOptions]>0,
        Test["AddReagent is False if and only if  Reagent addition options are Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];
  (*Error::ConflictingNeedleWashOptions="NeedleWash (`1`) is False if and only if NeedleOutsideWashTime (`2`) and  NeedleInsideWashTime (`3`) are Null";*)

  expandedNeedleInsideWashTime=If[
    MatchQ[Lookup[roundedFlowCytometryOptions,NeedleInsideWashTime],_List],
    Lookup[roundedFlowCytometryOptions,NeedleInsideWashTime],
    Table[Lookup[roundedFlowCytometryOptions,NeedleInsideWashTime],lengthSamples]
  ];

  conflicitingNeedleWashOptions=If[
    (*Is NeedleWash True and NeedleOutsideWashTime or NeedleInsideWashTime Null?*)
    Or[
      MemberQ[PickList[expandedNeedleInsideWashTime,expandedNeedleWash,False],Except[Null|Automatic]],
      MemberQ[PickList[expandedNeedleInsideWashTime,expandedNeedleWash,True],Null]
    ],
    (*return a the unsupported options and warning*)
    {NeedleWash, NeedleInsideWashTime},
    Nothing
  ];

  conflicitingNeedleWashInvalidOptions=If[Length[conflicitingNeedleWashOptions]>0&&!gatherTests,
    Message[Error::ConflictingNeedleWashOptions,
      Lookup[roundedFlowCytometryOptions,NeedleWash],
      Lookup[roundedFlowCytometryOptions,NeedleInsideWashTime]
    ];
    conflicitingNeedleWashOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingNeedleWashTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingNeedleWashOptions]==0,
        Test["NeedleWash is False if and only if  NeedleWash  options are Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingNeedleWashOptions]>0,
        Test["NeedleWash is False if and only if  NeedleWash  options are Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingBlankOptions="If no injectionTable is provided, Blank is Null if and only if BlankInjectionVolume and BlankFrequency are Null.";*)
  conflicitingBlankOptions=If[
    (*Do the Blank and Bkank Options Conflict?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Automatic|Null]&&
    Or[
      MatchQ[Lookup[roundedFlowCytometryOptions,Blank],Null]&&Or[MatchQ[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],Except[Null|Automatic]],MatchQ[Lookup[roundedFlowCytometryOptions,BlankFrequency],Except[Null|Automatic]]],
      MatchQ[Lookup[roundedFlowCytometryOptions,Blank],True]&&Or[MatchQ[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],Null],MatchQ[Lookup[roundedFlowCytometryOptions,BlankFrequency],Null]]
    ],
    (*return a the unsupported options and warning*)
    {Blank, BlankInjectionVolume, BlankFrequency},
    Nothing
  ];

  conflicitingBlankInvalidOptions=If[Length[conflicitingBlankOptions]>0&&!gatherTests,
    Message[Error::ConflictingBlankOptions,
      Lookup[roundedFlowCytometryOptions,Blank],
      Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],
      Lookup[roundedFlowCytometryOptions,BlankFrequency]
    ];
    conflicitingBlankOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflicitingBlankTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflicitingBlankOptions]==0,
        Test["If no InjectionTable is provided, Blank is Null if and only if BlankInjectionVolume and BlankFrequency are Null:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflicitingBlankOptions]>0,
        Test["If no InjectionTable is provided, Blank is Null if and only if BlankInjectionVolume and BlankFrequency are Null:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingCellCountMaxEvents="CellCount is True. In this mode only a MaxVolume can be used. Please set MaxGateEvents and MaxEvents to None.";*)
  conflictingCellCountMaxEventsOptions=If[
    (*Do the a MaxGateEvents or MaxEvents set  CellCount is True?*)
    Or[
      MemberQ[PickList[ToList[Lookup[roundedFlowCytometryOptions,MaxEvents]],ToList[Lookup[roundedFlowCytometryOptions,CellCount]],True],Except[Null|None|Automatic]],
      MemberQ[PickList[ToList[Lookup[roundedFlowCytometryOptions,MaxGateEvents]],ToList[Lookup[roundedFlowCytometryOptions,CellCount]],True],Except[Null|None|Automatic]]
    ],
    (*return a the unsupported options and warning*)
    {CellCount, MaxEvents, MaxGateEvents},
    Nothing
  ];

  conflictingCellCountMaxEventsInvalidOptions=If[Length[conflictingCellCountMaxEventsOptions]>0&&!gatherTests,
    Message[Error::ConflictingCellCountMaxEvents];
    conflictingCellCountMaxEventsOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingCellCountMaxEventsTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingCellCountMaxEventsOptions]==0,
        Test["If CellCount is True, only a MaxVolume can be used:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingCellCountMaxEventsOptions]>0,
        Test["If CellCount is True, only a MaxVolume can be used:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*) Error::FlowCytometryInvalidPreparedPlateContainer="The samples are not in a container compatible with the instrument. Please change the input container to Model[Container, Plate, \"96-well Round Bottom Plate\"] or  Model[Container, Vessel, \"5mL Tube\"] or set PreparedPlate to False.";*)
  conflictingFlowCytometryInvalidPreparedPlateContainerOptions=If[
    (*Is prepared plate true and it's in a bad container?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,PreparedPlate],True]&&
        Or[!MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}|{ObjectP[Model[Container, Plate, "96-well Round Bottom Plate"]]..}],
        !MatchQ[DeleteDuplicates[sampleContainerObjects],{ObjectP[Object[Container, Vessel]]..}|{ObjectP[Object[Container, Plate]]}]],
    (*return a the unsupported options and warning*)
    {PreparedPlate},
    Nothing
  ];

  conflictingFlowCytometryInvalidPreparedPlateContainerInvalidOptions=If[Length[conflictingFlowCytometryInvalidPreparedPlateContainerOptions]>0&&!gatherTests,
    Message[Error::FlowCytometryInvalidPreparedPlateContainer];
    conflictingFlowCytometryInvalidPreparedPlateContainerOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingFlowCytometryInvalidPreparedPlateContainerTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingFlowCytometryInvalidPreparedPlateContainerOptions]==0,
        Test["If PreparedPlate is True, the samples are in an appropriate container:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingFlowCytometryInvalidPreparedPlateContainerOptions]>0,
        Test["If PreparedPlate is True, the samples are in an appropriate container:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*)Error::FlowCytometerLaserPowerTooHigh="The power `1` for the `2` laser is set above the max power `3` of the laser. Please lower this power.";*)

  conflictingLaserPowerOptions=MapThread[
    If[
      MatchQ[#1,Except[Automatic]]&&MatchQ[#2,Except[Automatic]]&&MatchQ[#1,GreaterP[First[PickList[instExcitationLaserPowers,instExcitationLaserWavelengths,EqualP[#2]]]]],
      (*return a the unsupported options and warning*)
      {#1,#2,First[PickList[instExcitationLaserPowers,instExcitationLaserWavelengths,EqualP[#2]]]},
      Nothing
    ]&,
    {ToList[suppliedExcitationPowers],ToList[suppliedExcitationWavelengths]}
  ];

  conflictingLaserPowerInvalidOptions=If[Length[conflictingLaserPowerOptions]>0&&!gatherTests,
    Message[Error::FlowCytometerLaserPowerTooHigh,conflictingLaserPowerOptions[[All,1]],conflictingLaserPowerOptions[[All,2]],conflictingLaserPowerOptions[[All,3]]];
    {ExcitationPower,ExcitationWavelength},
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingLaserPowerTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingLaserPowerOptions]==0,
        Test["The laser power is below the max power of the laser:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingLaserPowerOptions]>0,
        Test["The laser power is below the max power of the laser:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];






  (*-- RESOLVE EXPERIMENT OPTIONS --*)
  (*resolve easy non-index matched options first*)

  (*Flush options*)
  resolvedFlushFrequency=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,FlushFrequency],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,FlushFrequency],
    (*Is Flush True?*)
    MatchQ[flush,True],
    5,
    True,
    Null
  ];

  resolvedSecondaryTriggerThreshold=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,SecondaryTriggerThreshold],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,SecondaryTriggerThreshold],
    (*Is Flush True?*)
    MatchQ[secondaryTriggerDetector,Except[None|Null]],
    10Percent,
    True,
    Null
  ];

  resolvedFlushSample=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,FlushSample],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,FlushSample],
    (*Is Flush True?*)
    MatchQ[flush,True],
    Model[Sample,StockSolution, "Filtered PBS, Sterile"],
    True,
    Null
  ];

  resolvedFlushSpeed=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,FlushSpeed],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,FlushSpeed],
    (*Is Flush True?*)
    MatchQ[flush,True],
    0.5Microliter/Second,
    True,
    Null
  ];

  (*AgitationFrequency options*)

  resolvedAgitationFrequency=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,AgitationFrequency],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,AgitationFrequency],
    (*Is Agitate set for any samples?*)
    MemberQ[Lookup[roundedFlowCytometryOptions,Agitate],Except[Automatic]],
    Null,
    True,
    3
  ];

  resolvedIncludeCompensationSamples=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,IncludeCompensationSamples],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,IncludeCompensationSamples],
    True,
    False
  ];


  (*Detector*)

  (*detectorChannelNames, detectorExcitation,detectorEmissionMin detectorEmissionMax*)

  (*Find a matching detector for any provided detection Labels*)
  matchingDetectorsForDetectionLabel=If[
    MemberQ[ToList[suppliedDetectionLabels],Except[Automatic]],
    MapThread[
      If[
        MatchQ[#1,Null]&&MatchQ[#2,Null],
        {Null,Null,Null,Null},
        If[
          MatchQ[Cases[fluorescenceChannels, {_, EqualP[First[Nearest[instrumentExcitationLaserWavelengths, #1]]],_,_,_,_,_,LessP[#2], GreaterP[#2] | Null,_}],{}],
          {Null,Null,Null,Null},
          First[Cases[fluorescenceChannels, {_, EqualP[First[Nearest[instrumentExcitationLaserWavelengths, #1]]],_,_,_,_,_,LessP[#2], GreaterP[#2] | Null,_}]]
        ]
      ]&,
      {detectionLabelExcitation,detectionLabelEmission}
    ],
    Null
  ];

  (*Find a matching detector for any molecules in the composition and detectorlabels*)
  matchingDetectorsForDetectionLabelForFluorophores=If[
    !MatchQ[Flatten[sampleMoleculeFluorescenceExcitationMaximums],{}],
    MapThread[
      If[
        MatchQ[#1,Null]&&MatchQ[#2,Null],
        {Null,Null,Null,Null},
        First[Cases[fluorescenceChannels, {_, EqualP[First[Nearest[instrumentExcitationLaserWavelengths, #1]]],_,_,_,_,_,LessP[#2], GreaterP[#2] | Null,_}]]
      ]&,
      {Flatten[sampleMoleculeFluorescenceExcitationMaximums],Flatten[sampleMoleculeFluorescenceEmissionMaximums]}
    ],
    Null
  ];


  {resolvedDetector,resolvedDetectionLabel}=Which[
    (*both set by user*)
    MatchQ[suppliedDetectors,Except[Automatic|{Automatic..}]]&&MatchQ[suppliedDetectionLabels,Except[Automatic|{Automatic..}]],
    (*Do the detetction Labels correspond to detectors?*)
    (*If[!MatchQ[Sort[matchingDetectorsForDetectionLabel[[All,1]]],Sort[ToList[suppliedDetectors]/.{"488 FSC"|"488 SSC"|"405 FSC"->Null}]]&&!engine,
      Message[Warning::FlowCytometryDetectorNotRecommended,suppliedDetectors,suppliedDetectionLabels]
    ];*)
    {
      suppliedDetectors,
      suppliedDetectionLabels
    },

    (*only detector set by user and no fluorophes in sample*)
    MatchQ[suppliedDetectors,Except[Automatic|{Automatic..}]]&&MatchQ[matchingDetectorsForDetectionLabelForFluorophores,Null],
    (*)Message[Warning::FlowCytometryDetectorNotRecommended,suppliedDetectors,sampleFluorescentMolecules];*)
    {
      suppliedDetectors,
      Table[Null,Length[suppliedDetectors]]
    },

    (*only detector set by user*)
    MatchQ[suppliedDetectors,Except[Automatic|{Automatic..}]],
    (*If[
      !MatchQ[Sort[matchingDetectorsForDetectionLabelForFluorophores[[All,1]]]/.{"488 FSC"|"488 SSC"|"405 FSC"->Nothing},Sort[ToList[suppliedDetectors]/.{"488 FSC"|"488 SSC"|"405 FSC"->Nothing}]]&&!engine,
      Message[Warning::FlowCytometryDetectorNotRecommended,suppliedDetectors,sampleFluorescentMolecules]
    ];*)
    {
      suppliedDetectors,
      PadLeft[sampleFluorescentMolecules,Length[Join[Cases[suppliedDetectors,"488 FSC"|"488 SSC"],matchingDetectorsForDetectionLabelForFluorophores[[All,1]]]],Null]
    },

    (*Are the DetectionLabel set by user?*)
    MemberQ[ToList[suppliedDetectionLabels],Except[Automatic|{Automatic..}]],
    (*Do the detection Labels correspond to detectors?*)
    If[
      MatchQ[matchingDetectorsForDetectionLabel,{{Null,Null,Null,Null}..}],
      If[!engine,Message[Warning::UnresolvableFlowCytometryDetector,suppliedDetectionLabels]];
      {
        {"488 FSC","488 SSC"},
        PadLeft[DeleteCases[suppliedDetectionLabels,Null],Length[Join[{"488 FSC","488 SSC"},DeleteCases[matchingDetectorsForDetectionLabel[[All,1]],Null]]],Null]
      },
      {
        Join[{"488 FSC","488 SSC"},DeleteCases[matchingDetectorsForDetectionLabel[[All,1]],Null]],
        PadLeft[DeleteCases[suppliedDetectionLabels,Null],Length[Join[{"488 FSC","488 SSC"},DeleteCases[matchingDetectorsForDetectionLabel[[All,1]],Null]]],Null]
      }
    ],

    (*Do the Molecules in the composition have molecules or molecules that have DetectionLabel with Fluorescent == True?*)
    !MatchQ[Flatten[sampleMoleculeFluorescenceExcitationMaximums],{}],
    (*Do the fluorophores correspond to detectors?*)
    If[
      MatchQ[matchingDetectorsForDetectionLabelForFluorophores,{}],
      If[!engine,Message[Warning::UnresolvableFlowCytometryDetector,sampleFluorescentMolecules]];
      {{"488 FSC","488 SSC"},{Null,Null}},
      {
        Join[{"488 FSC","488 SSC"},matchingDetectorsForDetectionLabelForFluorophores[[All,1]]],
        PadLeft[sampleFluorescentMolecules,Length[Join[{"488 FSC","488 SSC"},matchingDetectorsForDetectionLabelForFluorophores[[All,1]]]],Null]
      }
    ],
    (*else*)
    True,
    {{"488 FSC","488 SSC"},{Null,Null}}
  ];

  resolvedGainExpanded=If[MatchQ[resolvedGain,_List],resolvedGain,Table[resolvedGain,Length[resolvedDetector]]];


  (*Find a matching samplesIns for each detector*)
  matchingSamplesForDetector=If[
    MatchQ[Flatten[Position[matchingDetectorsForDetectionLabelForFluorophores,{#,___}]],{}],
    Null,
    simulatedSamples[[First[Flatten[Position[matchingDetectorsForDetectionLabelForFluorophores,{#,___}]]]]]
  ]&/@ToList[resolvedDetector];

  (*)resolvedExcitationWavelength*)
  resolvedExcitationWavelength=Which[
    (*set by user*)
    MatchQ[suppliedExcitationWavelengths,Except[Automatic]],
    suppliedExcitationWavelengths,
    (*excitation wavelengths of all detectors*)
    True,
    Round[DeleteDuplicates[Flatten[Cases[fluorescenceChannels, {#, _,_,_,_,_,_,_, _,_}]&/@ToList[resolvedDetector],1][[All,2]]],1Nanometer]
  ];

  (*expand excitation powers to match length of excitation wavelength*)
  expandedExcitationPower=If[
    MatchQ[suppliedExcitationPowers,_List],
    suppliedExcitationPowers,
    Table[suppliedExcitationPowers,Length[ToList[resolvedExcitationWavelength]]]
  ];

  (*resolvedExcitationPower*)
  resolvedExcitationPower= MapThread[
    Which[
      (*set by user*)
      MatchQ[#1,Except[Automatic]],
      #1,
      (*max power of the excitation laser*)
      True,
      First[PickList[instExcitationLaserPowers,instExcitationLaserWavelengths,EqualP[#2]]]
    ]&,
    {expandedExcitationPower,ToList[resolvedExcitationWavelength]}
  ];

  (*resolved blank*)
  resolvedBlank=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,Blank],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,Blank],
    (*Is an injection table provided*)
    MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
    Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {Blank,___}][[All, 2]],
    (*Are any other index matched blank options specified?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],Except[Automatic|Null]],
    Table[Model[Sample,StockSolution,"Filtered PBS, Sterile"],Length[ToList[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume]]]],
    (*Are any other blank options specified?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,BlankFrequency],Except[Automatic|Null]],
    Model[Sample,StockSolution,"Filtered PBS, Sterile"],
    (*else*)
    True,
    Null
  ];

  (*expand injectionvolume to match blanks*)
  expandedInjectionVolume=If[
    MatchQ[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],_List],
    Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],
    Table[Lookup[roundedFlowCytometryOptions,BlankInjectionVolume],Length[ToList[resolvedBlank]]]
  ];

  resolvedBlankInjectionVolume=MapThread[
    Which[
      (*set by user*)
      MatchQ[#1,Except[Automatic]],
      #1,
      (*Are any other blank options specified?*)
      MatchQ[#2,Except[Null]],
      40*Microliter,
      (*else*)
      True,
      Null
    ]&,
    {expandedInjectionVolume,ToList[resolvedBlank]}
  ];

  resolvedBlankFrequency=Which[
    (*set by user*)
    MatchQ[Lookup[roundedFlowCytometryOptions,BlankFrequency],Except[Automatic]],
    Lookup[roundedFlowCytometryOptions,BlankFrequency],
    (*Are any other blank options specified?*)
    MatchQ[resolvedBlank,Except[Null]],
    5,
    (*else*)
    True,
    Null
  ];


  (* Convert our options into a MapThread friendly version. *)
  mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[ExperimentFlowCytometry, roundedFlowCytometryOptions];

  (* do our first big MapThread to for sample index matched options*)
  {
    resolvedRecoupSample,resolvedNeedleInsideWashTime,resolvedAgitate,resolvedAgitationTime,resolvedMaxVolume,resolvedAddReagent,resolvedReagent,resolvedReagentVolume,resolvedReagentMix
  } = Transpose[MapThread[
    Function[{options, sample, index,injection,needleWashBool},
      Module[
        {recoupSample, needleInsideWashTime, agitate,agitationTime,maxVolume,addReagent,reagent,reagentVolume,reagentMix},

        recoupSample=Which[
          (*set by user*)
          MatchQ[Lookup[options,RecoupSample],Except[Automatic]],
          Lookup[options,RecoupSample],
          (*Are there the injection mode single sample?*)
          MatchQ[injection,Individual],
          True,
          (*else*)
          True,
          Null
        ];

        (*Needle wash options*)

        needleInsideWashTime=Which[
          (*set by user*)
          MatchQ[Lookup[options,NeedleInsideWashTime],Except[Automatic]],
          Lookup[options,NeedleInsideWashTime],
          (*Is NeedleWash True?*)
          MatchQ[needleWashBool,True],
          1*Second,
          True,
          Null
        ];

        (*-----Agatitation options--------*)
        agitate=Which[
          (*set by user*)
          MatchQ[Lookup[options,Agitate],Except[Automatic]],
          Lookup[options,Agitate],
          (*is agitatiton time set*)
          MatchQ[Lookup[options,AgitationTime],GreaterP[0Second]],
          True,
          (*is agitation time set in the injection table*)
          MatchQ[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}],Except[{}]]&&
              MatchQ[First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[4]],Except[Automatic]],
          MatchQ[First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[4]],GreaterP[0Second]],
          (*Is AgitationFrequency None?*)
          MatchQ[resolvedAgitationFrequency,Null],
          False,
          (*Is AgitationFrequency First and its the first sample?*)
          MatchQ[resolvedAgitationFrequency,First]&&MatchQ[index,1],
          True,
          (*Is AgitationFrequency an integer and its a multiple of that number*)
          Divisible[(index-1), resolvedAgitationFrequency],
          True,
          (*else*)
          True,
          False
        ];

        agitationTime=Which[
          (*set by user*)
          MatchQ[Lookup[options,AgitationTime],Except[Automatic]],
          Lookup[options,AgitationTime],
          (*is agitation time set in the injection table*)
          MatchQ[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}],Except[{}]]&&
              MatchQ[First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[4]],Except[Automatic]],
          First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[4]]/. (EqualP[0*Second] -> Null),
          (*Is agitate true?*)
          MatchQ[agitate,True],
          5*Second,
          (*else*)
          True,
          Null
        ];

        (*Stopping Conditions*)
        maxVolume=Which[
          (*set by user*)
          MatchQ[Lookup[options,MaxVolume],Except[Automatic]],
          Lookup[options,MaxVolume],
          (*is agitation time set in the injection table*)
          MatchQ[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}],Except[{}]]&&
              MatchQ[First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[3]],Except[Automatic]],
          First[Cases[Lookup[roundedFlowCytometryOptions, InjectionTable], {_, ObjectP[sample], ___}]][[3]],
          (*Cell Count True*)
          MatchQ[Lookup[options,CellCount],True],
          10Microliter,
          True,
          40*Microliter
        ];

        (*Reagent Addition Options*)
        addReagent=Which[
          (*set by user*)
          MatchQ[Lookup[options,AddReagent],Except[Automatic]],
          Lookup[options,AddReagent],
          (*Is Reagent, ReagentVolume or ReagentMix set?*)
          Or[
            MatchQ[Lookup[options,Reagent],Except[Automatic|Null]],
            MatchQ[Lookup[options,ReagentVolume],Except[Automatic|Null]],
            MatchQ[Lookup[options,ReagentMix],Except[Automatic|Null]]
          ],
          True,
          (*else*)
          True,
          False
        ];

        reagent=Which[
          (*set by user*)
          MatchQ[Lookup[options,Reagent],Except[Automatic]],
          Lookup[options,Reagent],
          (*Is addReagent True?*)
          addReagent,
          Model[Sample,"Milli-Q water"],
          (*else*)
          True,
          Null
        ];

        reagentVolume=Which[
          (*set by user*)
          MatchQ[Lookup[options,ReagentVolume],Except[Automatic]],
          Lookup[options,ReagentVolume],
          (*Is addReagent True?*)
          addReagent,
          10Microliter,
          (*else*)
          True,
          Null
        ];

        reagentMix=Which[
          (*set by user*)
          MatchQ[Lookup[options,ReagentMix],Except[Automatic]],
          Lookup[options,ReagentMix],
          (*Is addReagent True?*)
          addReagent,
          True,
          (*else*)
          True,
          Null
        ];

        (* return the resolved values *)
        {recoupSample,needleInsideWashTime,agitate,agitationTime,maxVolume,addReagent,reagent,reagentVolume,reagentMix}
      ]
    ],
    {mapThreadFriendlyOptions, mySamples, Range[Length[sampleVolumes]],injectionMode,expandedNeedleWash}
  ]];


  (*next do the mapthread over the options index matched to detector*)
  detectorMatchedOptions={DetectionLabel,NeutralDensityFilter,Gain,AdjustmentSample,TargetSaturationPercentage};

  detectorExpendedOptions=Which[
    (*already the right length, keep it the same*)
    MatchQ[Length[Lookup[roundedFlowCytometryOptions,#]],Length[ToList[resolvedDetector]]],
    Lookup[roundedFlowCytometryOptions,#],
    (*single, expand it*)
    MatchQ[Length[ToList[Lookup[roundedFlowCytometryOptions,#]]],1],
    Table[First[ToList[Lookup[roundedFlowCytometryOptions,#]]],Length[ToList[resolvedDetector]]]
  ]&/@detectorMatchedOptions;


  (* do our first big MapThread to for sample index matched options*)
  {
    resolvedAdjustmentSample,resolvedTargetSaturationPercentage,unresolveableAdjustmentSampleError
  } = Transpose[MapThread[
    Function[{detectionLabel,neutralDensityFilter,gain,unresolvedAdjustmentSample,unresolvedTargetSaturationPercentage,resolveddetectionLabel,resolveddetector,matchSample},
      Module[
        {adjustmentSample,targetSaturationPercentage,adjustmentSampleError},

        adjustmentSampleError=False;

        adjustmentSample=Which[
          (*set by user*)
          MatchQ[unresolvedAdjustmentSample,Except[Automatic]],
          unresolvedAdjustmentSample,

          (*Is gain auto?*)
          MatchQ[gain,Auto],
          Which[
            (*If it us a fluorescent detector*)
            MatchQ[resolveddetector,Except["488 FSC" | "488 SSC" | "405 FSC"]],
            Which[
              (*Is an injection table provided, use an adjustment sample from that*)
              MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
              First[PickList[
                Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]],
                Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]][Composition][[All, All, 2]],
                (_? (MemberQ[#, ObjectP[resolveddetectionLabel[Object]]] &))
              ]],
              (* if we need to measure a comp matrix, look for the default sample model of that fluorophore*)
              MatchQ[resolvedIncludeCompensationSamples,True]&&MatchQ[Lookup[fetchPacketFromCache[resolveddetectionLabel[Object],cacheBall],DefaultSampleModel],ObjectP[{Model[Sample]}]],
              Lookup[fetchPacketFromCache[resolveddetectionLabel[Object],cacheBall],DefaultSampleModel][Object],
              (* if we need to measure a com matrix, and couldn't find one*)
              MatchQ[resolvedIncludeCompensationSamples,True],
              adjustmentSampleError=True;
              Null,
              (*If it is for adjusting the PMT values only and a SampleIn has that fluorophore*)
              MatchQ[matchSample,Except[Null]],
              matchSample,
              (*Else*)
              True,
              First[simulatedSamples]
            ],
            (*If it us a non-fluorescent detector it won't have a lable, we can reuse another detector's sample or another sample*)
            True,
            Which[
              (*use unstained sample*)
              MatchQ[unstainedSample,ObjectP[{Model[Sample],Object[Sample]}]],
              unstainedSample[Object],
              (*Is an injection table provided, use the first adjustment sample*)
              MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
              First[Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]]],
              (*reuse another detector's sample if we are measure a comp matrix*)
              MatchQ[resolvedIncludeCompensationSamples,True]&&MatchQ[FirstCase[Lookup[fetchPacketFromCache[#[Object],cacheBall],DefaultSampleModel]&/@ToList[resolvedDetectionLabel],ObjectP[{Model[Sample]}]],ObjectP[{Model[Sample]}]],
              FirstCase[Lookup[fetchPacketFromCache[#[Object],cacheBall],DefaultSampleModel]&/@ToList[resolvedDetectionLabel],ObjectP[{Model[Sample]}]][Object],
              (*can't resolve*)
              True,
              First[simulatedSamples]
            ]
          ],
          (*Is IncludeComensationsamples True?*)
          MatchQ[resolvedIncludeCompensationSamples,True],
          Which[
            (*If it uses a fluorescent detector*)
            MatchQ[resolveddetector,Except["488 FSC" | "488 SSC" | "405 FSC"]],
            Which[
              (*Is an injection table provided, use an adjustment sample from that*)
              MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
              First[PickList[
                Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]],
                Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]][Composition][[All, All, 2]],
                (_? (MemberQ[#, ObjectP[resolveddetectionLabel[Object]]] &))
              ]],
              (* ook for the default sample model of that fluorophore*)
              MatchQ[Lookup[fetchPacketFromCache[resolveddetectionLabel[Object],cacheBall],DefaultSampleModel],ObjectP[{Model[Sample]}]],
              Lookup[fetchPacketFromCache[resolveddetectionLabel[Object],cacheBall],DefaultSampleModel][Object],
              (*If SampleIn has that fluorophore*)
              MatchQ[matchSample,Except[Null]],
              matchSample,
              (* if we need to measure a com matrix, and couldn't find one*)
              True,
              adjustmentSampleError=True;
              Null
            ],
            (*If it us a non-fluorescent detector it won't have a label,we don't need a sample*)
            True,
            Null
          ],
          (*else*)
          True,
          Null
        ];

        targetSaturationPercentage=Which[
          (*set by user*)
          MatchQ[unresolvedTargetSaturationPercentage,Except[Automatic]],
          unresolvedTargetSaturationPercentage,
          (*Is gain auto?*)
          MatchQ[gain,Auto],
          75Percent,
          (*else*)
          True,
          Null
        ];
        (* return the resolved values *)
        {adjustmentSample,targetSaturationPercentage,adjustmentSampleError}
      ]
    ],
    Join[detectorExpendedOptions,{ToList[resolvedDetectionLabel],ToList[resolvedDetector],ToList[matchingSamplesForDetector]}]
  ]];


  (*Error::ConflictingFlowInjectionTableBlankOptions="The Blank and BlankFrequency options do not match the provided InjectionTable.";*)
  unresolveableAdjustmentSampleErrorOptions=If[
    (*Do the a MaxGateEvents or MaxEvents set  CellCount is True?*)
    MemberQ[unresolveableAdjustmentSampleError,True],
    (*return a the unsupported options and warning*)
    {AdjustmentSample},
    Nothing
  ];

  unresolveableAdjustmentSampleInvalidOptions=If[Length[unresolveableAdjustmentSampleErrorOptions]>0&&!gatherTests,
    Message[Error::UnresolveableAdjustmentSampleError,PickList[resolvedDetector,unresolveableAdjustmentSampleError]];
    unresolveableAdjustmentSampleErrorOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  unresolveableAdjustmentSampleTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[unresolveableAdjustmentSampleErrorOptions]==0,
        Test["An adjustment sample was resolved for each detector:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[unresolveableAdjustmentSampleErrorOptions]>0,
        Test["An adjustment sample was resolved for each detector:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];


  maxVolumesWithReplicates=If[
    MatchQ[numberOfReplicates,1],
    resolvedMaxVolume,
    Flatten[Table[#, numberOfReplicates] & /@ resolvedMaxVolume,1]
  ];

  resolvedAgitateWithReplicates=If[
    MatchQ[numberOfReplicates,1],
    resolvedAgitationTime,
    Flatten[Table[#, numberOfReplicates] & /@ resolvedAgitationTime,1]
  ];

  requiredSampleVolumes=Which[
    MatchQ[Max[resolvedMaxVolume],LessEqualP[1Milliliter]],
    Min[SafeRound[#*2,10^0 Microliter],0.2Milliliter],
    True,
    Min[SafeRound[#*2,10^0 Microliter],4Milliliter]
  ]&/@resolvedMaxVolume;


  (*Resolve our InjectionTable*)
  injectionTable=Join[
    (* Run the negative control*)
    If[
      MatchQ[unstainedSample,Null|None],
      {Nothing},
      {{UnstainedSample,unstainedSample,Max[maxVolumesWithReplicates],0Second}}
    ],
    (* Next run the adjustment samples*)
    If[
      MatchQ[resolvedAdjustmentSample,Null|{Null..}],
      {Nothing},
      If[
        MatchQ[resolvedIncludeCompensationSamples,True],
        {AdjustmentSample,#,Max[maxVolumesWithReplicates],0Second}&/@DeleteCases[DeleteDuplicates[resolvedAdjustmentSample],Null|ObjectP[unstainedSample]|ObjectP[simulatedSamples]],
        {AdjustmentSample,#,Max[maxVolumesWithReplicates],0Second}&/@DeleteCases[DeleteDuplicates[resolvedAdjustmentSample],Null|ObjectP[unstainedSample]|ObjectP[simulatedSamples]]
        ]
    ],
    (* Next run the samples with blanks every blankfrequency*)
    If[
      Or[
        MatchQ[resolvedBlankFrequency,Null],
        MatchQ[resolvedBlank,Null],
        MatchQ[resolvedBlankFrequency,GreaterP[Length[mySamplesWithReplicates]]]
      ],
      (*no blanks*)
      Join[{Sample},#]&/@Transpose[{ToList[mySamplesWithReplicates],ToList[maxVolumesWithReplicates],ToList[resolvedAgitateWithReplicates]/.{Null->0Second}}],
      (*blanks*)
      DeleteCases[
        Riffle[
          Join[{Sample},#]&/@Transpose[{ToList[mySamplesWithReplicates],ToList[maxVolumesWithReplicates],ToList[resolvedAgitateWithReplicates]/.{Null->0Second}}],
          PadRight[
            Join[{Blank},#]&/@ If[
              MatchQ[resolvedBlank,_List],
              Transpose[{resolvedBlank,resolvedBlankInjectionVolume,Table[0Second,Length[resolvedBlank]]}],
              Table[{resolvedBlank,First[ToList[resolvedBlankInjectionVolume]],0Second},Length[mySamplesWithReplicates]]
            ],
            Length[mySamplesWithReplicates]
          ],
          (resolvedBlankFrequency+1)
        ],
        0
      ]
    ]
  ];


  {resolvedInjectionTable,resolvedInjectionTableError}=If[
    MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
    (*replace any automatics inside the provided injection table*)
    Transpose[Map[
      Function[
        {table},
        If[
          MemberQ[table, Automatic],
          (*look if we resolved if in the last injection table*)
          If[
            MatchQ[Cases[injectionTable, {_, table[[2]], ___}], {}],
            (*if not throw an error*)
            {table,table},
            (*if yes,use it*)
            {
              ReplacePart[
                table,
                MapThread[
                  #1 -> #2 &,
                  {Flatten[Position[table, Automatic]], First[Cases[injectionTable, {_, table[[2]], ___}]][[Flatten[Position[table, Automatic]]]]}]
              ],
              False
            }
          ],
          {table,False}
        ]
      ],
      Lookup[roundedFlowCytometryOptions,InjectionTable]
    ]],
    {injectionTable,{}}
  ];

  resolvedInjectionTableErrorInValidOptions=If[
    (*Do the a MaxGateEvents or MaxEvents set  CellCount is True?*)
    MatchQ[DeleteCases[resolvedInjectionTableError,False],{}],
    (*return a the unsupported options and warning*)
    Nothing,
    {InjectionTable}
  ];

  If[
    (*Do the a MaxGateEvents or MaxEvents set  CellCount is True?*)
    MatchQ[DeleteCases[resolvedInjectionTableError,False],Except[{}]]&&!gatherTests,
    (*return a the unsupported options and warning*)
    Message[Error::UnresolvableFlowCytometerInjectionTable,DeleteCases[resolvedInjectionTableError,False]],
    Nothing
  ];

  resolvedInjectionTableErrorTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[DeleteCases[resolvedInjectionTableError,False]]==0,
        Test["The automatics are able to resolve in the provided InjectionTable:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[DeleteCases[resolvedInjectionTableError,False]]>0,
        Test["The automatics are able to resolve in the provided InjectionTable:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];


  (*Error::ConflictingFlowInjectionTableBlankOptions="The Blank and BlankFrequency options do not match the provided InjectionTable.";*)
  conflictingFlowInjectionTableBlankOptions=If[
    (*Do The Blank and BlankFrequency options do not match the provided InjectionTable.*)
    !MatchQ[
      Cases[resolvedInjectionTable, {Blank, ___}][[All, 2]]/.{{}->Null},
      If[MatchQ[resolvedBlank,{}],Null,resolvedBlank]|ObjectP[resolvedBlank]|{ObjectP[resolvedBlank]..}
    ],
    (*)MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]]&&
        !MatchQ[
          Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {Blank, ___}][[All, 2]],
          resolvedBlank|ObjectP[resolvedBlank]|{ObjectP[resolvedBlank]..}
          ],*)
    (*return a the unsupported options and warning*)
    {InjectionTable, Blank},
    Nothing
  ];

  conflictingFlowInjectionTableBlankInvalidOptions=If[Length[conflictingFlowInjectionTableBlankOptions]>0&&!gatherTests,
    Message[Error::ConflictingFlowInjectionTableBlankOptions];
    conflictingFlowInjectionTableBlankOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingFlowInjectionTableBlankTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingFlowInjectionTableBlankOptions]==0,
        Test["The Blank and BlankFrequency options do match the provided InjectionTable:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingFlowInjectionTableBlankOptions]>0,
        Test["The Blank and BlankFrequency options do match the provided InjectionTable:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*Error::ConflictingFlowInjectionTable="The Types and Samples in the provided InjectionTable do not match the Samples, UnstainedSample and AdjustmentSamples.";*)
  conflictingFlowInjectionTableOptions=Which[
    (*Do the a MaxGateEvents or MaxEvents set  CellCount is True?*)
    MatchQ[Lookup[roundedFlowCytometryOptions,InjectionTable],Except[Automatic]],
    If[
      Or[
        !MatchQ[
          Sort[Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {Sample, ___}][[All, 2]]],
          Sort[mySamplesWithReplicates]
        ],
        !MatchQ[
          Sort[Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {AdjustmentSample, ___}][[All, 2]]],
          Sort[DeleteCases[DeleteDuplicates[resolvedAdjustmentSample],Null]]
        ],
        !MatchQ[
          Cases[Lookup[roundedFlowCytometryOptions,InjectionTable], {UnstainedSample, ___}][[All, 2]]/.{}->{None},
          {unstainedSample}
        ]
      ],
      (*return a the unsupported options and warning*)
      {InjectionTable, AdjustmentSample,UnstainedSample},
      Nothing
    ],
    True,
    Nothing
  ];

  conflictingFlowInjectionTableInvalidOptions=If[Length[conflictingFlowInjectionTableOptions]>0&&!gatherTests,
    Message[Error::ConflictingFlowInjectionTable];
    conflictingFlowInjectionTableOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingFlowInjectionTableTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingFlowInjectionTableOptions]==0,
        Test["The Types and Samples in the provided InjectionTable match the Samples, UnstainedSample and AdjustmentSamples:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingFlowInjectionTableOptions]>0,
        Test["The Types and Samples in the provided InjectionTable match the Samples, UnstainedSample and AdjustmentSamples:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];

  (*)Error::ConflictingPreparedPlateInjectionOrder="A PreparedPlate is selected and the sample positions in the plate do not match the order in the InjectionTable. Please change InjectionTable to match the sample positions in the plate.";*)
  conflictingPreparedPlateInjectionOrderOptions=If[
    (*are the in a plate out of order?*)
    MatchQ[preparedPlate,True]
        &&!MatchQ[containerContents /. (# -> Nothing & /@ Complement[containerContents, resolvedInjectionTable[[All,2]]]), resolvedInjectionTable[[All,2]]]
        &&MatchQ[sampleContainerModels,{ObjectP[Model[Container,Plate]]..}],
    (*return a the unsupported options and warning*)
    {InjectionTable},
    Nothing
  ];

  conflictingPreparedPlateInjectionOrderInvalidOptions=If[Length[conflictingPreparedPlateInjectionOrderOptions]>0&&!gatherTests,
    Message[Error::ConflictingPreparedPlateInjectionOrder];
    conflictingPreparedPlateInjectionOrderOptions,
    Nothing
  ];

  (* If we are gathering tests, create tests with the appropriate results. *)
  conflictingPreparedPlateInjectionOrderTests=If[gatherTests,
    (* We're gathering tests. Create the appropriate tests. *)
    Module[{passingInputsTest,failingInputsTest},
      (* Create a test for the passing inputs. *)
      passingInputsTest=If[Length[conflictingPreparedPlateInjectionOrderOptions]==0,
        Test["If PreparedPlate is selected and the sample positions in the plate do match the order in the InjectionTable:",True,True],
        Nothing
      ];
      (* Create a test for the non-passing inputs. *)
      failingInputsTest=If[Length[conflictingPreparedPlateInjectionOrderOptions]>0,
        Test["If PreparedPlate is selected and the sample positions in the plate do match the order in the InjectionTable:",True,False],
        Nothing
      ];
      (* Return our created tests. *)
      {
        passingInputsTest,
        failingInputsTest
      }
    ],
    (* We aren't gathering tests. No tests to create. *)
    {}
  ];




  (* get the number of samples *)
  numSamples = Length[resolvedInjectionTable];
  numReagents = Length[DeleteDuplicates[ToList[resolvedReagent]/.{Null|None->Nothing}]];

  numInputSamples=Length[Cases[resolvedInjectionTable, {Sample, ___}]];
  numAdjustmentSamples=Length[Cases[resolvedInjectionTable, {AdjustmentSample, ___}]];
  numBlanks=Length[Cases[resolvedInjectionTable, {Blank, ___}]];
  numUnstainedSamples=Length[Cases[resolvedInjectionTable, {UnstainedSample, ___}]];


  (* if we have more than 96 samples, throw an error *)
  maxSamples=Which[
    (*If can fit in a plate*)
    MatchQ[Max[resolvedMaxVolume],LessEqualP[0.2Milliliter]],
    96,
    (*If can fit in a Tube rack*)
    True,
    40
  ];

  tooManySamplesQ = (numSamples+numReagents) > maxSamples;


  (* if there are more than 96 samples, and we are throwing messages, throw an error message and keep track of the invalid inputs *)
  tooManySamplesInputs = Which[
    TrueQ[tooManySamplesQ] && messages,
    (
      Message[Error::FlowCytometryTooManySamples, numInputSamples,numAdjustmentSamples,numBlanks,numReagents,numUnstainedSamples,96];
      Download[mySamples, Object]
    ),
    TrueQ[tooManySamplesQ], Download[mySamples, Object],
    True, {}
  ];

  (* if we are gathering tests, create a test indicating whether we have too many samples or not *)
  tooManySamplesTest = If[gatherTests,
    Test["The number of samples provided times NumberOfReplicates is not greater than 96:",
      tooManySamplesQ,
      False
    ],
    Nothing
  ];

  (* --- pull out all the shared options from the input options --- *)

  (* get the rest directly *)
  (*Pull out the shared options*)
  {confirm,canaryBranch,template,cache,operator,upload,outputOption,subprotocolDescription,samplePreparation,samplesInStorage,samplesOutStorage}=Lookup[myOptions,{Confirm,CanaryBranch,Template,Cache,Operator,Upload,Output,SubprotocolDescription,PreparatoryUnitOperations,SamplesInStorageCondition,SamplesOutStorageCondition}];

  (* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub *)
  email = Which[
    MatchQ[Lookup[myOptions, Email], Automatic] && NullQ[parentProtocol], True,
    MatchQ[Lookup[myOptions, Email], Automatic] && MatchQ[parentProtocol, ObjectP[ProtocolTypes[]]], False,
    True, Lookup[myOptions, Email]
  ];

  (* Automatic resolves to False for this experiment *)
  imageSample=If[
    MatchQ[Lookup[myOptions, ImageSample], Automatic],
    False,
    Lookup[myOptions, ImageSample]
  ];

  (* Automatic resolves to False for this experiment *)
  measureVolume=If[
    MatchQ[Lookup[myOptions, MeasureVolume], Automatic],
    False,
    Lookup[myOptions, MeasureVolume]
  ];

  measureWeight=If[
    MatchQ[Lookup[myOptions, MeasureWeight], Automatic],
    False,
    Lookup[myOptions, MeasureWeight]
  ];

  (* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)
  (* call CompatibleMaterialsQ and figure out if materials are compatible *)
  {compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTests,
    CompatibleMaterialsQ[instrument, DeleteCases[Join[simulatedSamples,ToList[resolvedBlank],ToList[resolvedReagent],ToList[resolvedAdjustmentSample],ToList[unstainedSample],ToList[resolvedFlushSample]],Null|None], Output -> {Result, Tests}, Cache -> cacheBall, Simulation->updatedSimulation],
    {CompatibleMaterialsQ[instrument, DeleteCases[Join[simulatedSamples,ToList[resolvedBlank],ToList[resolvedReagent],ToList[resolvedAdjustmentSample],ToList[unstainedSample],ToList[resolvedFlushSample]],Null|None], Messages -> messages, Cache -> cacheBall, Simulation->updatedSimulation], {}}
  ];

  (* if the materials are incompatible, then the Instrument is invalid *)
  compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messages,
    {Instrument},
    {}
  ];


  (* Check whether the samples are ok *)
  {validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
    ValidContainerStorageConditionQ[simulatedSamples, samplesInStorage, Output -> {Result, Tests}, Cache -> cacheBall],
    {ValidContainerStorageConditionQ[simulatedSamples, samplesInStorage, Output -> Result, Cache ->cacheBall], {}}
  ];

  validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];


  (*-- UNRESOLVABLE OPTION CHECKS --*)

  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
  (* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)

  (* combine the invalid options together *)
  invalidOptions = DeleteDuplicates[Flatten[{
    nameInvalidOptions,
    conflictingContinuousModeInvalidOptions,
    conflictingPreparedPlateReagentInvalidOptions,
    conflictingAgitationInvalidOptions,
    mustSpecifyAgitationTimeInvalidOptions,
    conficitingFlushInvalidOptions,
    conficitingExcitationWavelengthDetectorInvalidOptions,
    conflicitingNeutralDensityFilterOptions,
    conflicitingGainOptimizationInvalidOptions,
    conflicitingSecondaryTriggerInvalidOptions,
    conflicitingGateInvalidOptions,
    mustSpecifyAdjustmentSamplesForCompensationInvalidOptions,
    conflicitingAddReagentInvalidOptions,
    conflicitingNeedleWashInvalidOptions,
    conflicitingBlankInvalidOptions,
    conflictingCellCountMaxEventsInvalidOptions,
    conflictingFlowInjectionTableBlankInvalidOptions,
    conflictingFlowInjectionTableInvalidOptions,
    compatibleMaterialsInvalidOption,
    validContainerStoragConditionInvalidOptions,
    conflictingContinuousModeFlowRateInvalidOptions,
    conflictingContinuousModeLimitInvalidOptions,
    conflictingFlushInjectionInvalidOptions,
    unresolveableAdjustmentSampleInvalidOptions,
    conflictingFlowCytometryInvalidPreparedPlateContainerInvalidOptions,
    conflictingPreparedPlateBlankInvalidOptions,
    conflictingPreparedPlateAdjustmentSampleInvalidOptions,
    conflictingPreparedPlateUnstainedSampleInvalidOptions,
    conflictingPreparedPlateInjectionOrderInvalidOptions,
    resolvedInjectionTableErrorInValidOptions,
    conflictingLaserPowerInvalidOptions
  }]];

  (* combine the invalid input stogether *)
  invalidInputs = DeleteDuplicates[Flatten[{
    discardedInvalidInputs,
    deprecatedInvalidInputs,
    tooManySamplesInputs
  }]];

  (* Throw Error::InvalidInput if there are invalid inputs. *)
  If[Not[MatchQ[invalidOptions, {}]] && messages,
    Message[Error::InvalidOption, invalidOptions]
  ];

  (* Throw Error::InvalidOption if there are invalid options. *)
  If[Not[MatchQ[invalidInputs, {}]] && messages,
    Message[Error::InvalidInput, invalidInputs]
  ];
  (* gather all the tests together *)
  allTests = Cases[Flatten[{
    samplePrepTests,
    discardedTest,
    conflictingContinuousModeTests,
    conflictingPreparedPlateReagentTests,
    tooManySamplesTest,
    conflictingAgitationTests,
    mustSpecifyAgitationTimeTests,
    conficitingFlushTests,
    conficitingDetecorAndDetectionLabelTests,
    conficitingExcitationWavelengthDetectorTests,
    conflicitingSecondaryTriggerTests,
    conflicitingGateTests,
    mustSpecifyAdjustmentSamplesForCompensationTests,
    conflicitingAddReagentTests,
    conflicitingNeedleWashTests,
    conflicitingBlankTests,
    conflictingCellCountMaxEventsTests,
    conflictingFlowInjectionTableBlankTests,
    conflictingFlowInjectionTableTests,
    compatibleMaterialsTests,
    validContainerStorageConditionTests,
    conflictingContinuousModeFlowRateTests,
    conflictingContinuousModeLimitTests,
    conflictingFlushInjectionTests,
    unresolveableAdjustmentSampleTests,
    conflictingFlowCytometryInvalidPreparedPlateContainerTests,
    conflictingPreparedPlateBlankTests,
    conflictingPreparedPlateAdjustmentSampleTests,
    conflictingPreparedPlateUnstainedSampleTests,
    conflictingPreparedPlateInjectionOrderTests,
    resolvedInjectionTableErrorTests,
    conflictingLaserPowerTests
  }], _EmeraldTest];

  (*-- CONTAINER GROUPING RESOLUTION --*)

  (*check how much we need of each sample, if we are using it to adjust we need more*)
  volumes=MapThread[
    Count[resolvedAdjustmentSample,#1]*20Microliter+#2&,
    {simulatedSamples,resolvedMaxVolume}
  ];

  (* Resolve RequiredAliquotContainers *)
  targetContainers=Which[
    (*If it is already in a good container*)
    MatchQ[sampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}],
    Null,
    (*preffered round bottom plate*)
    MatchQ[Max[resolvedMaxVolume],LessEqualP[0.2Milliliter]],
    Null,
    (*cytometry tubes*)
    True,
    Model[Container, Vessel, "5mL Tube"]
  ]&/@volumes;

  samplesVolumes=If[
    MatchQ[Lookup[roundedFlowCytometryOptions,SampleVolume],_List],
    Lookup[roundedFlowCytometryOptions,SampleVolume],
    Table[Lookup[roundedFlowCytometryOptions,SampleVolume],Length[mySamples]]
  ];

  resolvedSampleVolume=MapThread[
    Which[
      (*set by user*)
      MatchQ[#1,Except[Automatic]],
      #1,
      (*preparedplate*)
      MatchQ[Lookup[roundedFlowCytometryOptions,PreparedPlate],True],
      Null,
      (*fits in a plate*)
      MatchQ[Max[volumes],LessEqualP[0.2Milliliter]],
      0.2Milliliter,
      (*cytometry tubes*)
      True,
      Min[SafeRound[#1*2,10^0 Microliter],4Milliliter]
    ]&,
    {samplesVolumes,volumes}
  ];


  requiredAliquotAmounts=MapThread[
    Which[
      (*not a preparedplate*)
      MatchQ[#2,Except[Null]],
      #2,
      (*preffered round bottom plate*)
      MatchQ[Max[resolvedMaxVolume],LessEqualP[0.2Milliliter]],
      Min[SafeRound[#1*2,10^0 Microliter],0.2Milliliter],
      (*cytometry tubes*)
      True,
      Min[SafeRound[#1*2,10^0 Microliter],4Milliliter]
    ]&,{volumes,resolvedSampleVolume}];

  (* Resolve Aliquot Options *)
  {resolvedAliquotOptions,aliquotTests}=If[gatherTests,
    (* Note: Also include AllowSolids\[Rule]True as an option to this function if your experiment function can take solid samples as input. Otherwise, resolveAliquotOptions will throw an error if solid samples will be given as input to your function. *)
    resolveAliquotOptions[ExperimentFlowCytometry,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache -> cacheBall,Simulation->Simulation[cacheBall],RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->{Result,Tests}],
    {resolveAliquotOptions[ExperimentFlowCytometry,mySamples,simulatedSamples,ReplaceRule[myOptions,resolvedSamplePrepOptions],Cache -> cacheBall,Simulation->Simulation[cacheBall],RequiredAliquotContainers->targetContainers,RequiredAliquotAmounts->requiredAliquotAmounts,Output->Result],{}}
  ];

  (* --- Resolve Label Options *)
  resolvedSampleLabel=Module[{suppliedSampleObjects, uniqueSamples, preResolvedSampleLabels, preResolvedSampleLabelRules},
    suppliedSampleObjects = Download[simulatedSamples, Object];
    uniqueSamples = DeleteDuplicates[suppliedSampleObjects];
    preResolvedSampleLabels = Table[CreateUniqueLabel["flow cytometry sample"], Length[uniqueSamples]];
    preResolvedSampleLabelRules = MapThread[
      (#1 -> #2)&,
      {uniqueSamples, preResolvedSampleLabels}
    ];

    MapThread[
      Function[{object, label},
        Which[
          MatchQ[label, Except[Automatic]],
          label,
          MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
          LookupObjectLabel[updatedSimulation, Download[object, Object]],
          True,
          Lookup[preResolvedSampleLabelRules, Download[object, Object]]
        ]
      ],
      {suppliedSampleObjects, Lookup[roundedFlowCytometryOptions, SampleLabel]}
    ]
  ];

  resolvedSampleContainerLabel=Module[
    {suppliedContainerObjects, uniqueContainers, preresolvedSampleContainerLabels, preResolvedContainerLabelRules},
    suppliedContainerObjects = Download[Lookup[samplePackets, Container, {}], Object];
    uniqueContainers = DeleteDuplicates[suppliedContainerObjects];
    preresolvedSampleContainerLabels = Table[CreateUniqueLabel["flow cytometry sample container"], Length[uniqueContainers]];
    preResolvedContainerLabelRules = MapThread[
      (#1 -> #2)&,
      {uniqueContainers, preresolvedSampleContainerLabels}
    ];

    MapThread[
      Function[{object, label},
        Which[
          MatchQ[label, Except[Automatic]],
          label,
          MatchQ[updatedSimulation, SimulationP] && MatchQ[LookupObjectLabel[updatedSimulation, Download[object, Object]], _String],
          LookupObjectLabel[updatedSimulation, Download[object, Object]],
          True,
          Lookup[preResolvedContainerLabelRules, Download[object, Object]]
        ]
      ],
      {suppliedContainerObjects, Lookup[roundedFlowCytometryOptions , SampleContainerLabel]}
    ]
  ];

  (* Resolve Post Processing Options *)
  resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];


  (* get the final resolved options (pre-collapsed; that is happening outside the function) *)
  resolvedOptions = Flatten[{
    (*non-resolved options*)
    Instrument->instrument,
    NumberOfReplicates -> numberOfReplicates,
    InjectionMode->injectionMode,
    FlowCytometryMethod->flowCytometryMethod,
    PreparedPlate->preparedPlate,
    Temperature->temperature,
    FlowRate->flowRate,
    CellCount->cellCount,
    Flush->flush,
    NeutralDensityFilter->resolvedNeutralDensityFilter,
    TriggerDetector->triggerDetector,
    TriggerThreshold->triggerThreshold,
    SecondaryTriggerDetector->secondaryTriggerDetector,
    MaxEvents->maxEvents,
    MaxGateEvents->maxGateEvents,
    GateRegion->gateRegion,
    UnstainedSample->unstainedSample,
    NeedleWash->needleWash,
    Gain->resolvedGainExpanded,
    SecondaryTriggerThreshold->resolvedSecondaryTriggerThreshold,
    (*resolved options*)
    FlushFrequency-> resolvedFlushFrequency,
    FlushSample->resolvedFlushSample,
    FlushSpeed->resolvedFlushSpeed,
    NeedleInsideWashTime->resolvedNeedleInsideWashTime,
    AgitationFrequency->resolvedAgitationFrequency,
    IncludeCompensationSamples->resolvedIncludeCompensationSamples,
    Detector->resolvedDetector,
    DetectionLabel->resolvedDetectionLabel,
    ExcitationWavelength->resolvedExcitationWavelength,
    ExcitationPower->resolvedExcitationPower,
    Blank->resolvedBlank,
    BlankInjectionVolume->resolvedBlankInjectionVolume,
    BlankFrequency->resolvedBlankFrequency,
    RecoupSample->resolvedRecoupSample,
    Agitate->resolvedAgitate,
    AgitationTime->resolvedAgitationTime,
    MaxVolume->resolvedMaxVolume,
    AddReagent->resolvedAddReagent,
    Reagent->resolvedReagent,
    ReagentVolume->resolvedReagentVolume,
    ReagentMix->resolvedReagentMix,
    AdjustmentSample->resolvedAdjustmentSample,
    TargetSaturationPercentage->resolvedTargetSaturationPercentage,
    InjectionTable->resolvedInjectionTable,
    SampleVolume->resolvedSampleVolume,
    (*framework options*)
    resolvedSamplePrepOptions,
    resolvedAliquotOptions,
    Confirm -> confirm,
    CanaryBranch -> canaryBranch,
    Name -> name,
    Template -> template,
    Email -> email,
    FastTrack -> fastTrack,
    Operator -> operator,
    Output -> outputOption,
    ParentProtocol -> parentProtocol,
    SubprotocolDescription->subprotocolDescription,
    Upload -> upload,
    PreparatoryUnitOperations-> samplePreparation,
    SamplesInStorageCondition -> samplesInStorage,
    SamplesOutStorageCondition -> samplesOutStorage,
    Cache -> inheritedCache,
    Simulation->updatedSimulation,
    ImageSample->imageSample,
    MeasureWeight->measureWeight,
    MeasureVolume->measureVolume,
    SampleContainerLabel->resolvedSampleContainerLabel,
    SampleLabel->resolvedSampleLabel
  }];
  (* generate the tests rule *)
  testsRule = Tests -> If[gatherTests,
    allTests,
    Null
  ];

  (* generate the Result output rule *)
  (* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
  resultRule = Result -> If[MemberQ[output, Result],
    resolvedOptions,
    Null
  ];

  (* return the output as we desire it *)
  outputSpecification /. {resultRule, testsRule}
];

DefineOptions[
  flowCytometryResourcePackets,
  Options:>{HelperOutputOption,CacheOption,SimulationOption}
];


flowCytometryResourcePackets[mySamples:{ObjectP[Object[Sample]]..}, myUnresolvedOptions:{___Rule}, myResolvedOptions:{___Rule}, ops:OptionsPattern[flowCytometryResourcePackets]]:=Module[
  {
    outputSpecification,output,gatherTests,messages,inheritedCache,numReplicates,
    expandedSamplesWithNumReplicates,pairedSamplesInAndVolumes,sampleVolumeRules,
    sampleResourceReplaceRules,samplesInResources,instrumentTime,instrumentResource,protocolPacket,sharedFieldPacket,finalizedPacket,
    allResourceBlobs,fulfillable, frqTests,testsRule,resultRule,requiredSampleVolumes, expandedInputs, expandedResolvedOptions,resolvedOptionsNoHidden,sampleDownload,
    allVolumeRules, uniqueResources,listedSampleContainers, sampleContainersIn,
    uniqueObjectResourceReplaceRules, uniqueObjects, preparedPlate,volumes,optionsWithReplicates,injectionTableUploadNoLink,

    flushSampleResource,flushSampleVolume,numSamples,adjustmentSamplesResources,pairedAdjustmentSamplesAndVolumes,adjustmentSampleRules,flushSampleRule,
    unstainedSampleResource,unstainedSampleRule,reagentResources,pairedReagentAndVolumes,reagentRules,injectionTable,injectionTableUpload,
    blankResources,blankRules,pairedBlankAndVolumes,blankVolumes,blanks,injectionTableWithLinks,linkedSampleInResources,samplePositions, blankPositions,
    adjustmentSamplePositions, unstainedSamplePositions,linkedAdjustmentSampleResources, linkedUnstainedSampleResources, linkedBlankResources,
    containerMaxVolume,pairedUnstainedSamplesAndVolumes,injectionRack,numWells,assayContainerModel,availableWells,numContainers,injectionContainerResources,
    containersIn,adjustmentSamples,adjustmentSamplesInjectionTableResources,rackLifter,listedSampleContainerModels,reagentVolumeRules,reagentuniqueResources,
    reagentuniqueObjects,reagentuniqueObjectResourceReplaceRules,adjustmentVolumeRules,adjustmentuniqueResources,adjustmentuniqueObjects,adjustmentuniqueObjectResourceReplaceRules,
    blankVolumeRules,blankuniqueResources,blankuniqueObjects,blankuniqueObjectResourceReplaceRules,
    unstainedSampleVolumeRules,unstainedSampleuniqueResources,unstainedSampleuniqueObjects,unstainedSampleuniqueObjectResourceReplaceRules,

    unitOperationPacket,rawResourceBlobs,resourcesWithoutName,resourceToNameReplaceRules,resourcesOk,resourceTests,previewRule,optionsRule,
    simulation,updatedSimulation,simulationRule,cache,simulatedSamples,simulatedPrimitiveID,cacheBall

  },
  (* expand the resolved options if they weren't expanded already *)
  {expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentFlowCytometry, {mySamples}, myResolvedOptions];

  (* Get the resolved collapsed index matching options that don't include hidden options *)
  resolvedOptionsNoHidden=CollapseIndexMatchedOptions[
    ExperimentFlowCytometry,
    RemoveHiddenOptions[ExperimentFlowCytometry,myResolvedOptions],
    Ignore->myUnresolvedOptions,
    Messages->False
  ];

  (* Determine the requested output format of this function. *)
  outputSpecification=OptionValue[Output];
  output=ToList[outputSpecification];

  (* lookup cache and simulation *)
  simulation = Lookup[ToList[ops], Simulation];
  cache = Lookup[ToList[ops], Cache];

  (* Determine if we should keep a running list of tests to return to the user. *)
  gatherTests = MemberQ[output,Tests];
  messages = Not[gatherTests];

  (* Get the inherited cache *)
  inheritedCache = Lookup[myResolvedOptions, Cache];
  cacheBall = FlattenCachePackets[{cache, inheritedCache}];

  (* Pull out the number of replicates; make sure all Nulls become 1 *)
  numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

  preparedPlate = Lookup[myResolvedOptions, PreparedPlate];

  (* simulate the samples after they go through all the sample prep *)
  {simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentFlowCytometry, mySamples, myResolvedOptions, Cache -> cacheBall, Simulation -> simulation];

  (* Expand the samples according to the number of replicates *)
  {expandedSamplesWithNumReplicates,optionsWithReplicates}=expandNumberOfReplicates[ExperimentFlowCytometry,mySamples,expandedResolvedOptions];

  (* Make a Download call to get the containers of the input samples *)
  sampleDownload=Quiet[
    Download[
      mySamples,
      Container[{Object,Model}],
      Cache->cacheBall,
      Simulation->updatedSimulation,
      Date->Now
    ],
    {Download::FieldDoesntExist}
  ];

  listedSampleContainers=sampleDownload[[All,1]];
  listedSampleContainerModels=sampleDownload[[All,2]];

  (* Find the list of input sample containers *)
  sampleContainersIn=DeleteDuplicates[Flatten[listedSampleContainers]];

  (* -- Generate resources for the SamplesIn -- *)
  (* Pair the SamplesIn and their Volumes *)
  containerMaxVolume=If[
    MatchQ[Max[Lookup[optionsWithReplicates, SampleVolume]],LessEqualP[0.2Milliliter]],
    0.2Milliliter,
    4Milliliter
  ];

  (*check how much we need of each sample, if we are using it to adjust we need more*)
  volumes=MapThread[
    Count[Lookup[optionsWithReplicates, AdjustmentSample],#1]*20Microliter+#2&,
    {expandedSamplesWithNumReplicates,Lookup[optionsWithReplicates, MaxVolume]}
  ];


  requiredSampleVolumes=MapThread[Which[
    MatchQ[#2,Except[Null]],
    #2,
    (*preffered round bottom plate*)
    MatchQ[Max[Lookup[optionsWithReplicates, MaxVolume]],LessEqualP[0.2Milliliter]],
    Min[SafeRound[#1*2,10^0 Microliter],0.2Milliliter],
    (*cytometry tubes*)
    True,
    Min[SafeRound[#1*2,10^0 Microliter],4Milliliter]
  ]&,{volumes,Lookup[optionsWithReplicates, SampleVolume]}];


  pairedSamplesInAndVolumes = MapThread[
    #1 -> #2&,
    {expandedSamplesWithNumReplicates, requiredSampleVolumes}
  ];

  (* Merge the SamplesIn volumes together to get the total volume of each sample's resource *)
  sampleVolumeRules = Merge[pairedSamplesInAndVolumes, Total];

  (* Make replace rules for the samples and its resources; doing it this way because we only want to make one resource per sample including in replicates *)
  sampleResourceReplaceRules = KeyValueMap[
    Function[{sample, volume},
      If[VolumeQ[volume],
        sample -> Resource[Sample -> sample, Name -> ToString[Unique[]], Amount -> volume],
        sample -> Resource[Sample -> sample, Name -> ToString[Unique[]]]
      ]
    ],
    sampleVolumeRules
  ];

  (*get the assay container resources*)

  {assayContainerModel,availableWells}=Which[
    (*5mL tubes, Model[Container, Vessel, "5mL Tube"], should be aliquoted in these containers*)
    MatchQ[listedSampleContainerModels,{ObjectP[Model[Container, Vessel, "5mL Tube"]]..}],
    {Model[Container, Vessel, "5mL Tube"],1},
    (*prefered round bottom plate*)
    MatchQ[Max[Lookup[optionsWithReplicates, MaxVolume]],LessEqualP[0.2Milliliter]],
    {Model[Container, Plate, "96-well Round Bottom Plate"],96},
    (*5mL tubes, Model[Container, Vessel, "5mL Tube"], should be aliquoted in these containers*)
    True,
    {Model[Container, Vessel, "5mL Tube"],1}
  ];

  (* Use the replace rules to get the sample resources *)
  samplesInResources = Replace[expandedSamplesWithNumReplicates, sampleResourceReplaceRules, {1}];
  numSamples=Length[expandedSamplesWithNumReplicates];

  injectionTable=Lookup[myResolvedOptions, InjectionTable];

  (* pair the adjustmentSamples and their volumes*)
  pairedAdjustmentSamplesAndVolumes = MapThread[
    #1 -> Min[SafeRound[#2*2,10^0 Microliter],containerMaxVolume]&,
    {Cases[injectionTable, {AdjustmentSample, ___}][[All, 2]],Cases[injectionTable, {AdjustmentSample, ___}][[All, 3]]}
  ];

  (* Merge the diluent volumes together to get the total volume of each sample's resource *)
  adjustmentSampleRules = Merge[pairedAdjustmentSamplesAndVolumes, Total];

  (*)(*Pair the flush and its volumes*)
  flushSampleRule=Association[{Lookup[myResolvedOptions, FlushSample]->4Milliliter}];*)

  (* pair the adjustmentSamples and their volumes*)
  pairedUnstainedSamplesAndVolumes = MapThread[
    #1 -> Min[SafeRound[#2*2,10^0 Microliter],containerMaxVolume]&,
    {Cases[injectionTable, {UnstainedSample, ___}][[All, 2]],Cases[injectionTable, {UnstainedSample, ___}][[All, 3]]}
  ];

  (*Pair the calibrant and its volumes*)
  unstainedSampleRule=Merge[pairedUnstainedSamplesAndVolumes, Total];

  pairedReagentAndVolumes = MapThread[
    #1 -> Min[SafeRound[#2*1.1,10^0 Microliter],containerMaxVolume]&,
    {Lookup[optionsWithReplicates, Reagent],Lookup[optionsWithReplicates, ReagentVolume]/.Null->0Microliter}
  ];

  reagentRules=Merge[pairedReagentAndVolumes, Total];

  (*get the blank resources*)
  blanks=Cases[injectionTable, {Blank, ___}][[All, 2]];

  adjustmentSamples=Cases[injectionTable, {AdjustmentSample, ___}][[All, 2]];

  blankVolumes=If[
    MatchQ[Lookup[myResolvedOptions,BlankInjectionVolume],_List],
    Take[Flatten[Table[Lookup[myResolvedOptions,BlankInjectionVolume], Length[ToList[blanks]]]], Length[ToList[blanks]]],
    Table[Lookup[myResolvedOptions,BlankInjectionVolume],Length[ToList[blanks]]]
  ];

  pairedBlankAndVolumes=MapThread[
    #1 -> Min[SafeRound[#2*1.1,10^0 Microliter],containerMaxVolume]&,
    {blanks,blankVolumes}
  ];

  blankRules=Merge[pairedBlankAndVolumes, Total];

  (* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
  allVolumeRules=DeleteCases[KeyDrop[
    Merge[{adjustmentSampleRules,(*flushSampleRule,*)unstainedSampleRule,reagentRules,blankRules},Total],
    {Null,None}],
    0*Microliter
  ];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  uniqueResources= KeyValueMap[
    Module[{amount},
      amount=#2;
      Resource[Sample->#1,Amount->amount,Container->PreferredContainer[amount],Name->ToString[Unique[]]]
    ]&,
    allVolumeRules
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  uniqueObjects=Keys[allVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  uniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {uniqueObjects,uniqueResources}
  ];

  (* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
  reagentVolumeRules=DeleteCases[KeyDrop[
    reagentRules,
    {Null,None}],
    0*Microliter
  ];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  reagentuniqueResources= KeyValueMap[
    Module[{amount},
      amount=#2;
      If[
        MatchQ[preparedPlate,True],
        Resource[Sample->#1,Amount->amount,Name->ToString[Unique[]]],
        Resource[Sample->#1,Amount->amount,Container->Model[Container, Vessel, "5mL Tube"],Name->ToString[Unique[]]]
      ]
    ]&,
    reagentVolumeRules
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  reagentuniqueObjects=Keys[reagentVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  reagentuniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {reagentuniqueObjects,reagentuniqueResources}
  ];

  (* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
  adjustmentVolumeRules=DeleteCases[KeyDrop[
    adjustmentSampleRules,
    {Null,None}],
    0*Microliter
  ];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  adjustmentuniqueResources= KeyValueMap[
    Module[{amount},
      amount=#2;
      If[
        MatchQ[preparedPlate,True],
        Resource[Sample->#1,Amount->amount,Name->ToString[Unique[]]],
        Resource[Sample->#1,Amount->amount,Container->Model[Container, Vessel, "5mL Tube"],Name->ToString[Unique[]]]
      ]
    ]&,
    adjustmentVolumeRules
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  adjustmentuniqueObjects=Keys[adjustmentVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  adjustmentuniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {adjustmentuniqueObjects,adjustmentuniqueResources}
  ];

  (* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
  blankVolumeRules=DeleteCases[KeyDrop[
    blankRules,
    {Null,None}],
    0*Microliter
  ];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  blankuniqueResources= KeyValueMap[
    Module[{amount},
      amount=#2;
      If[
        MatchQ[preparedPlate,True],
        Resource[Sample->#1,Amount->amount,Name->ToString[Unique[]]],
        Resource[Sample->#1,Amount->amount,Container->Model[Container, Vessel, "5mL Tube"],Name->ToString[Unique[]]]
      ]
    ]&,
    blankVolumeRules
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  blankuniqueObjects=Keys[blankVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  blankuniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {blankuniqueObjects,blankuniqueResources}
  ];

  (* - First, join the lists of the rules above, getting rid of any Rules with the pattern Null->_ or __->0*Microliter *)
  unstainedSampleVolumeRules=DeleteCases[KeyDrop[
    unstainedSampleRule,
    {Null,None}],
    0*Microliter
  ];

  (* - Use this association to make Resources for each unique Object or Model Key - *)
  unstainedSampleuniqueResources= KeyValueMap[
    Module[{amount},
      amount=#2;
      If[
        MatchQ[preparedPlate,True],
        Resource[Sample->#1,Amount->amount,Name->ToString[Unique[]]],
        Resource[Sample->#1,Amount->amount,Container->Model[Container, Vessel, "5mL Tube"],Name->ToString[Unique[]]]
      ]
    ]&,
    unstainedSampleVolumeRules
  ];

  (* -- Define a list of replace rules for the unique Model and Objects with the corresponding Resources --*)
  (* - Find a list of the unique Object/Model Keys - *)
  unstainedSampleuniqueObjects=Keys[unstainedSampleVolumeRules];

  (* - Make a list of replace rules, replacing unique objects with their respective Resources - *)
  unstainedSampleuniqueObjectResourceReplaceRules=MapThread[
    (#1->#2)&,
    {unstainedSampleuniqueObjects,unstainedSampleuniqueResources}
  ];

  (* -- Use the unique object replace rules to make lists of the resources of the inputs and the options / fields that are objects -- *)
  (* - For the inputs and options that are lists, Map over replacing the options with the replace rules at level {1} to get the corresponding list of resources - *)
  {
    adjustmentSamplesResources,
    reagentResources,
    blankResources
  }=If[
        Or[MatchQ[assayContainerModel,Model[Container, Vessel, "5mL Tube"]],MatchQ[preparedPlate,True]],
        (*put all the extra samples in tubes or origional containers*)
        {
          Replace[#,adjustmentuniqueObjectResourceReplaceRules]&/@Lookup[optionsWithReplicates, AdjustmentSample],
          Replace[#,reagentuniqueObjectResourceReplaceRules]&/@Lookup[optionsWithReplicates, Reagent],
          Replace[#,blankuniqueObjectResourceReplaceRules]&/@blanks
        },
        (*pool the extra resource samples*)
        Map[
          Replace[#,uniqueObjectResourceReplaceRules,{1}]&,
          {
            Lookup[optionsWithReplicates, AdjustmentSample],
            Lookup[optionsWithReplicates, Reagent],
            blanks
          }
        ]
    ];

  flushSampleResource=If[
    MatchQ[Lookup[myResolvedOptions, FlushSample],Null],
    Null,
    Resource[
      Sample->Lookup[myResolvedOptions, FlushSample],
      Amount->4Milliliter,
      Container -> Model[Container, Vessel, "5mL Tube"]
    ]

  ];
  (*Replace[Lookup[myResolvedOptions, FlushSample],uniqueObjectResourceReplaceRules];*)

  unstainedSampleResource=Which[
    Or[MatchQ[assayContainerModel,Model[Container, Vessel, "5mL Tube"]],MatchQ[preparedPlate,True]],
    Replace[Lookup[myResolvedOptions, UnstainedSample]/.{None->Null},unstainedSampleuniqueObjectResourceReplaceRules],
    True,
    Replace[Lookup[myResolvedOptions, UnstainedSample]/.{None->Null},uniqueObjectResourceReplaceRules]
  ];

  (*Get the injectionTable in uploadable form*)

  injectionTable=Lookup[myResolvedOptions, InjectionTable];

  (*initialize our injectionTable with links*)
  injectionTableWithLinks = injectionTable;

  adjustmentSamplesInjectionTableResources=Replace[
    #,
    If[
      MatchQ[assayContainerModel,Model[Container, Vessel, "5mL Tube"]],
      adjustmentuniqueObjectResourceReplaceRules,
      uniqueObjectResourceReplaceRules]
  ]&/@ adjustmentSamples;

  (*get all of the positions so that it's easy to update the injection table*)
  {samplePositions, blankPositions, adjustmentSamplePositions, unstainedSamplePositions} = Map[
    Flatten[Position[injectionTable, {#, ___}]]&,
    {Sample, Blank,AdjustmentSample, UnstainedSample}
  ];

  (*now let's update everything within our injection table*)
  linkedSampleInResources = Link[#]& /@ samplesInResources;
  linkedAdjustmentSampleResources=Link[#]& /@adjustmentSamplesInjectionTableResources;
  linkedUnstainedSampleResources=Link[#]& /@ToList[unstainedSampleResource];
  linkedBlankResources=Link[#]& /@blankResources;

  (*update all of the samples*)
  injectionTableWithLinks[[samplePositions, 2]] = linkedSampleInResources;
  injectionTableWithLinks[[adjustmentSamplePositions, 2]] = linkedAdjustmentSampleResources;
  injectionTableWithLinks[[unstainedSamplePositions, 2]] = linkedUnstainedSampleResources;
  injectionTableWithLinks[[blankPositions, 2]] = linkedBlankResources;

  injectionTableUpload=MapThread[
    Function[{type, sample,volume,agitate},
      Association[
        Type -> type,
        Sample -> sample,
        InjectionVolume->volume,
        AgitationTime->agitate
      ]
    ],
    Transpose[injectionTableWithLinks]
  ];

  injectionTableUploadNoLink=MapThread[
    Function[{type, sample,volume,agitate},
      {
        type,
        sample /. (x : _Link :> First[x]),
        volume,
        agitate
      }
    ],
    Transpose[injectionTableWithLinks]
  ];

  (*get the containers to put the samples in for measurement*)
  (* First determine what assay plate or assay tubes to use *)
  numWells=Length[injectionTable]+Length[DeleteDuplicates[Lookup[optionsWithReplicates, Reagent]/.Null->Nothing]];

  (*how many do we need*)
  numContainers=Ceiling[numWells/availableWells];

  (*make the resource*)
  injectionContainerResources=Which[
    (*use the prepared plate*)
    MatchQ[preparedPlate,True],
    Null,
    (*it should be aliquoted into the tubes, but we will need resources for the extra samples (adjustment etc)*)
    MatchQ[assayContainerModel,ObjectP[Model[Container, Vessel, "5mL Tube"]]],
    Table[Resource[Sample->assayContainerModel,Name->ToString[Unique[]]],(numContainers-Length[expandedSamplesWithNumReplicates])],
    True,
    Table[Resource[Sample->assayContainerModel,Name->ToString[Unique[]]],numContainers]
  ];

  (*If the samples are not in a plate we need a rack, Model[Container, Rack, "ZE5 Tube Rack 5mL"]*)
  injectionRack=Which[
    (*prepared plate*)
    MatchQ[First[sampleContainersIn],ObjectP[{Model[Container,Plate],Object[Container,Plate]}]]&&MatchQ[preparedPlate,True],
    Null,
    (*prepared tube*)
    MatchQ[First[sampleContainersIn],ObjectP[{Model[Container,Vessel],Object[Container,Vessel]}]]&&MatchQ[preparedPlate,True],
    Resource[Sample-> Model[Container, Rack, "ZE5 Tube Rack 5mL"],Name->ToString[Unique[]],Rent->True],
    (*plate*)
    MatchQ[assayContainerModel,ObjectP[Model[Container,Plate]]],
    Null,
    (*tubes*)
    True,
    Resource[Sample-> Model[Container, Rack, "ZE5 Tube Rack 5mL"],Name->ToString[Unique[]],Rent->True]
  ];

  (* -- Generate instrument resources -- *)
  (* Template Note: The time in instrument resources is used to charge customers for the instrument time so it's important that this estimate is accurate
	  this will probably look like set-up time + time/sample + tear-down time *)
  instrumentTime = (30*Minute+numSamples*5Minute+10*Minute);
  instrumentResource= Resource[Instrument -> Lookup[myResolvedOptions,Instrument], Time -> instrumentTime, Name -> ToString[Unique[]]];
  containersIn=Resource[Sample->#,Name->ToString[Unique[]]]&/@DeleteDuplicates[sampleContainersIn];

  unitOperationPacket=Module[{nonHiddenFlowOptions},

      (* Only include non-hidden options. Exclude prep primitives*)
      nonHiddenFlowOptions=DeleteCases[Lookup[
        Cases[OptionDefinition[ExperimentFlowCytometry], KeyValuePattern["Category"->Except["Hidden"]]],
        "OptionSymbol"
      ],PreparatoryUnitOperations|Name];

      UploadUnitOperation[
        FlowCytometry@@Join[
          {
            Sample->samplesInResources
          },
          ReplaceRule[
            Cases[optionsWithReplicates, Verbatim[Rule][Alternatives@@nonHiddenFlowOptions, _]],
            {
              Instrument -> instrumentResource,
              FlushSample -> flushSampleResource,
              AdjustmentSample->adjustmentSamplesResources,
              UnstainedSample->unstainedSampleResource,
              Reagent->reagentResources,
              Blank->blankResources,
              InjectionContainers->If[MatchQ[injectionContainerResources,{}|Null],containersIn,injectionContainerResources],
              InjectionRack->injectionRack,
              InjectionTable->injectionTableUploadNoLink
            }
          ]
        ],
        Preparation->Manual,
        UnitOperationType->Batched,
        FastTrack->True,
        Upload->False
      ]
  ];

  (* --- Generate the protocol packet --- *)
  protocolPacket=<|
    Type -> Object[Protocol,FlowCytometry],
    Object -> CreateID[Object[Protocol,FlowCytometry]],
    Replace[SamplesIn] -> (Link[#,Protocols]&/@samplesInResources),
    Replace[ContainersIn] -> (Link[#,Protocols]&/@containersIn),
    UnresolvedOptions -> myUnresolvedOptions,
    ResolvedOptions -> myResolvedOptions,
    NumberOfReplicates -> numReplicates,
    Replace[InjectionModes]->Lookup[optionsWithReplicates, InjectionMode],
    Replace[RecoupSamples]->Lookup[optionsWithReplicates, RecoupSample],
    Instrument -> Link[instrumentResource],
    PreparedPlate->Lookup[myResolvedOptions, PreparedPlate],
    Temperature->Lookup[myResolvedOptions, Temperature],
    Replace[Agitate] -> Lookup[optionsWithReplicates, Agitate],
    Replace[AgitationTimes] -> Lookup[optionsWithReplicates, AgitationTime],
    Replace[FlowRates] -> Lookup[optionsWithReplicates, FlowRate],
    Replace[CellCount] -> Lookup[optionsWithReplicates, CellCount],
    FlushFrequency -> Lookup[myResolvedOptions, FlushFrequency],
    FlushSample -> Link@flushSampleResource,
    FlushSpeed -> Lookup[myResolvedOptions, FlushSpeed],
    Replace[Detectors] -> Lookup[optionsWithReplicates, Detector],
    Replace[DetectionLabels] -> Link@Lookup[optionsWithReplicates, DetectionLabel],
    Replace[NeutralDensityFilters]->Lookup[optionsWithReplicates, NeutralDensityFilter],
    Replace[Gains]->Lookup[optionsWithReplicates, Gain],
    Replace[OptimizeGain]->((MatchQ[#,Auto])&/@Lookup[optionsWithReplicates, Gain]),
    Replace[TargetSaturationPercentages]->Lookup[optionsWithReplicates,TargetSaturationPercentage],
    Replace[ExcitationWavelengths]->Lookup[myResolvedOptions,ExcitationWavelength],
    Replace[ExcitationPowers]->Lookup[myResolvedOptions,ExcitationPower],
    Replace[AdjustmentSamples]->(Link[#] & /@adjustmentSamplesResources),
    TriggerDetector->Lookup[myResolvedOptions, TriggerDetector],
    TriggerThreshold->Lookup[myResolvedOptions, TriggerThreshold],
    SecondaryTriggerDetector->Lookup[myResolvedOptions, SecondaryTriggerDetector]/.{None->Null},
    SecondaryTriggerThreshold->Lookup[myResolvedOptions, SecondaryTriggerThreshold],
    Replace[MaxVolume]->Lookup[optionsWithReplicates, MaxVolume],
    Replace[MaxEvents]->Lookup[optionsWithReplicates, MaxEvents]/.{None->Null},
    Replace[MaxGateEvents]->Lookup[optionsWithReplicates, MaxGateEvents]/.{None->Null},
    Replace[GateRegions]->Lookup[optionsWithReplicates, GateRegion]/.{Null->{Null, Null, Null, Null}},
    CompensationSamplesIncluded->Lookup[myResolvedOptions, IncludeCompensationSamples],
    UnstainedSample->If[MatchQ[unstainedSampleResource,Null],Null,First[Link@unstainedSampleResource]],
    Replace[Reagents]->Link@reagentResources,
    Replace[ReagentVolumes]->Lookup[optionsWithReplicates, ReagentVolume],
    Replace[ReagentMix]->Lookup[optionsWithReplicates, ReagentMix],
    Replace[NeedleInsideWashTimes]->Lookup[optionsWithReplicates,NeedleInsideWashTime],
    Replace[InjectionTable]->injectionTableUpload,
    Replace[Blanks]->Link@blankResources,
    Replace[BlankInjectionVolumes]->blankVolumes,
    InjectionRack->Link[injectionRack],
    Replace[SampleVolumes]->Lookup[optionsWithReplicates, SampleVolume],
    Replace[InjectionContainers]->If[MatchQ[injectionContainerResources,{}|Null],Link@containersIn,Link@injectionContainerResources],
    Replace[Checkpoints] -> {
      {"Picking Resources",10 Minute,"Samples required to execute this protocol are gathered from storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10 Minute]]},
      {"Preparing Samples",1 Minute,"Preprocessing, such as incubation, mixing, centrifuging, and aliquoting, is performed.",Link[Resource[Operator -> $BaselineOperator, Time -> 1 Minute]]},
      {"Preparing Plate",2*Hour,"The measurement plates are loaded with the diluted samples and calibrants.",Null},
      {"Acquiring Data",instrumentTime,"The surface tensions of the samples in the plate are acquired.",Link[Resource[Operator -> $BaselineOperator, Time -> instrumentTime]]},
      {"Sample Post-Processing",1 Hour,"Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1*Hour]]},
      {"Returning Materials",10 Minute,"Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 10*Minute]]}
    },
    Replace[SamplesInStorage] -> Lookup[optionsWithReplicates,SamplesInStorageCondition],
    Replace[SamplesOutStorage] -> Lookup[optionsWithReplicates,SamplesOutStorageCondition],
    Operator -> Link[Lookup[myResolvedOptions, Operator]],
    Name -> Lookup[myResolvedOptions, Name],
    Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
      Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
      Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
    ],
    Replace[BatchedUnitOperations]->(Link[#, Protocol]&)/@ToList[Lookup[unitOperationPacket, Object]]
  |>;

  (* generate a packet with the shared fields *)
  sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions,Cache -> cacheBall, Simulation -> updatedSimulation];

  (* Merge the shared fields with the specific fields *)
  finalizedPacket = Join[sharedFieldPacket, protocolPacket];

  (* make list of all the resources we need to check in FRQ *)
  rawResourceBlobs=DeleteDuplicates[Cases[Flatten[{Normal[protocolPacket], Normal[unitOperationPacket]}],_Resource,Infinity]];

  (* Get all resources without a name. *)
  (* NOTE: Don't try to consolidate operator resources. *)
	resourcesWithoutName=DeleteDuplicates[Cases[rawResourceBlobs, Resource[_?(MatchQ[KeyExistsQ[#, Name], False] && !KeyExistsQ[#, Operator]&)]]];

  resourceToNameReplaceRules=MapThread[#1->#2&, {resourcesWithoutName, (Resource[Append[#[[1]], Name->CreateUUID[]]]&)/@resourcesWithoutName}];
  allResourceBlobs=rawResourceBlobs/.resourceToNameReplaceRules;

  (* Verify we can satisfy all our resources *)
  {resourcesOk,resourceTests}=Which[
    MatchQ[$ECLApplication,Engine],
    {True,{}},
    gatherTests,
    Resources`Private`fulfillableResourceQ[allResourceBlobs,Output->{Result,Tests},FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Cache->cacheBall,Simulation -> updatedSimulation],
    True,
    {Resources`Private`fulfillableResourceQ[allResourceBlobs,FastTrack->Lookup[myResolvedOptions,FastTrack],Site->Lookup[myResolvedOptions,Site],Messages->messages,Cache->cacheBall,Simulation -> updatedSimulation],Null}
  ];

  (* --- Output --- *)
  (* Generate the Preview output rule *)
  previewRule=Preview->Null;

  (* Generate the options output rule *)
  optionsRule=Options->If[MemberQ[output,Options],
    resolvedOptionsNoHidden,
    Null
  ];

  (* Generate the tests rule *)
  testsRule=Tests->If[gatherTests,
    resourceTests,
    {}
  ];

  (* generate the Result output rule *)
  (* If not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
  resultRule=Result->If[MemberQ[output,Result]&&TrueQ[resourcesOk],
    {finalizedPacket, unitOperationPacket}/.resourceToNameReplaceRules,
    $Failed
  ];

  (* generate the simulation output rule *)
  simulationRule = Simulation -> If[MemberQ[output, Simulation] && !MemberQ[output, Result],
    finalizedPacket,
    Null
  ];

  (* Return the output as we desire it *)
  outputSpecification/.{previewRule,optionsRule,resultRule,testsRule,simulationRule}
];

(* ::Subsection::Closed:: *)
(*ExperimentFlowCytometryOptions*)

DefineOptions[ExperimentFlowCytometryOptions,
  Options:>{
    {
      OptionName -> OutputFormat,
      Default -> Table,
      AllowNull -> False,
      Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
      Description -> "Determines whether the function returns a table or a list of the options.",
      Category->"General"
    }
  },
  SharedOptions :> {ExperimentFlowCytometry}
];


ExperimentFlowCytometryOptions[myInputs:ListableP[ObjectP[{Object[Container],Object[Sample]}]|_String],myOptions:OptionsPattern[]]:=Module[
  {listedOptions,noOutputOptions,options},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];

  (* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
  noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat->_]];

  (* get only the options *)
  options = ExperimentFlowCytometry[myInputs, Append[noOutputOptions, Output -> Options]];

  (* Return the option as a list or table *)
  If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
    LegacySLL`Private`optionsToTable[options,ExperimentFlowCytometry],
    options
  ]
];



(* ::Subsection::Closed:: *)
(*ExperimentFlowCytometryPreview*)

ExperimentFlowCytometryPreview[myInput:ListableP[ObjectP[{Object[Container]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ExperimentFlowCytometry]]:=
    ExperimentFlowCytometry[myInput,Append[ToList[myOptions],Output->Preview]];



(* ::Subsection::Closed:: *)
(*ValidExperimentFlowCytometryQ*)

DefineOptions[ValidExperimentFlowCytometryQ,
  Options:>{VerboseOption,OutputFormatOption},
  SharedOptions :> {ExperimentFlowCytometry}
];

(* currently we only accept either a list of containers, or a list of samples *)
ValidExperimentFlowCytometryQ[myInput:ListableP[ObjectP[{Object[Container]}]] | ListableP[ObjectP[Object[Sample]]|_String],myOptions:OptionsPattern[ValidExperimentFlowCytometryQ]]:=Module[
  {listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

  (* get the options as a list *)
  listedOptions = ToList[myOptions];
  listedInput = ToList[myInput];

  (* remove the Output option before passing to the core function because it doesn't make sense here *)
  preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

  (* return only the tests for ExperimentFlowCytometry *)
  filterTests = ExperimentFlowCytometry[myInput, Append[preparedOptions, Output -> Tests]];

  (* define the general test description *)
  initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

  (* make a list of all the tests, including the blanket test *)
  allTests = If[MatchQ[filterTests, $Failed],
    {Test[initialTestDescription, False, True]},
    Module[
      {initialTest, validObjectBooleans, voqWarnings, testResults},

      (* generate the initial test, which we know will pass if we got this far (?) *)
      initialTest = Test[initialTestDescription, True, True];

      (* create warnings for invalid objects *)
      validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
      voqWarnings = MapThread[
        Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
          #2,
          True
        ]&,
        {DeleteCases[listedInput, _String], validObjectBooleans}
      ];

      (* get all the tests/warnings *)
      Flatten[{initialTest, filterTests, voqWarnings}]
    ]
  ];

  (* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
  (* like if I ran OptionDefault[OptionValue[ValidExperimentFlowCytometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
  {verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

  (* run all the tests as requested *)
  Lookup[RunUnitTest[<|"ValidExperimentFlowCytometryQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentFlowCytometryQ"]

];

(* Primitive Support*)
(* ::Subsection:: *)
(* resolveFlowCytometryMethod *)

resolveFlowCytometryMethod[]:=Manual;


(* ::Subsection::Closed:: *)
(*Simulation*)

DefineOptions[
  simulateExperimentFlowCytometry,
  Options:>{CacheOption,SimulationOption,ParentProtocolOption}
];

simulateExperimentFlowCytometry[
  myProtocolPacket:(PacketP[Object[Protocol, FlowCytometry], {Object, ResolvedOptions}]|$Failed|Null),
  myUnitOperationPackets:({PacketP[]..}|$Failed),
  mySamples:{ObjectP[Object[Sample]]...},
  myResolvedOptions:{_Rule...},
  myResolutionOptions:OptionsPattern[simulateExperimentFlowCytometry]
]:=Module[
  {protocolObject, mapThreadFriendlyOptions, currentSimulation,simulatedUnitOperationPackets, injectionTable,
    preparedPlate, sampleVolumes, unitOperationField, resolvedPreparation,reagents,injectionContainers,
    numWells,availableWells,containersExpanded,workingSamples,sampleDestinations,
    adjustmentSample, unstainedSample, simulatedSamplePackets,cache,simulation,samplePackets,allSampleObjects,
    injectionTableObjects,sampleWells,adjustmentSampleWells,adjustmentSampleObjects,reagentObjects,
    unstainedSampleObject, unstainedSampleWells,sampleVolumesRules,workingSamplesObjects,
    allSampleVolumes, reagentVolumes,allSampleVolumesRules,sampleTransfers,simulationWithLabels,
    unitOperationObject,sampleUploads,newDestinationSampleObjects,cacheForUST,protocolPacketUpdate,unitOperationPacketUpdate
  },

  (* Lookup our cache and simulation. *)
  cache=Lookup[ToList[myResolutionOptions], Cache, {}];
  simulation=Lookup[ToList[myResolutionOptions], Simulation, Null];

  (* Download containers from our sample packets. *)
  samplePackets=Download[
    mySamples,
    Packet[Container],
    Cache->cache,
    Simulation->simulation
  ];

  (* Get our protocol ID. This should already be in our protocol packet, unless the resource packets failed. *)
  protocolObject=Which[
    (* NOTE: If myProtocolPacket is $Failed, we had a problem in the option resolver. *)
    MatchQ[myProtocolPacket, $Failed],
    SimulateCreateID[Object[Protocol,FlowCytometry]],
    True,
    Lookup[myProtocolPacket, Object]
  ];
  unitOperationObject=If[
    MatchQ[First[ToList[myUnitOperationPackets]], ObjectP[]],
    Lookup[First[ToList[myUnitOperationPackets]], Object],
    SimulateCreateID[Object[UnitOperation,FlowCytometry]]
  ];

  (* Get our map thread friendly options. *)
  mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[
    ExperimentFlowCytometry,
    myResolvedOptions
  ];

  (* Lookup our resolved preparation option. *)
  resolvedPreparation=Manual;

  (* Simulate the fulfillment of all resources by the procedure. *)
  (* NOTE: We won't actually get back a resource packet if there was a problem during option resolution. In that case, *)
  (* just make a shell of a protocol object so that we can return something back. *)
  currentSimulation=Which[
    (* When Preparation->Robotic, we have unit operation packets but not a protocol object. Just make a shell of a *)
    (* Object[Protocol, RoboticSamplePreparation] so that we can call SimulateResources. *)
    MatchQ[myProtocolPacket, Null] && MatchQ[ToList[myUnitOperationPackets], {PacketP[]..}],
    Module[{protocolPacket},
      protocolPacket=<|
        Object->protocolObject,
        Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
        Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[ToList[myUnitOperationPackets], Object],
        (* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
        (* simulate resources will NOT simulate them for you. *)
        (* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
        Replace[RequiredObjects]->DeleteDuplicates[
          Cases[ToList[myUnitOperationPackets], Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
        ],
        Replace[RequiredInstruments]->DeleteDuplicates[
          Cases[ToList[myUnitOperationPackets], Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
        ],
        ResolvedOptions->{}
      |>;

      SimulateResources[protocolPacket, ToList[myUnitOperationPackets], ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->simulation]
    ],

    (* Otherwise, if we have a $Failed for the protocol packet, that means that we had a problem in option resolving *)
    (* and skipped resource packet generation. *)
    MatchQ[myProtocolPacket, $Failed],
    Module[{protocolPacket},
      protocolPacket=<|
        Object->protocolObject,
        Replace[SamplesIn]->(Resource[Sample->#]&)/@mySamples,
        Replace[OutputUnitOperations]->(Link[#, Protocol]&)/@Lookup[ToList[myUnitOperationPackets], Object],
        (* NOTE: If you have accessory primitive packets, you MUST put those resources into the main protocol object, otherwise *)
        (* simulate resources will NOT simulate them for you. *)
        (* DO NOT use RequiredObjects/RequiredInstruments in your regular protocol object. Put these resources in more sensible fields. *)
        Replace[RequiredObjects]->DeleteDuplicates[
          Cases[ToList[myUnitOperationPackets], Resource[KeyValuePattern[Type->Except[Object[Resource, Instrument]]]], Infinity]
        ],
        Replace[RequiredInstruments]->DeleteDuplicates[
          Cases[ToList[myUnitOperationPackets], Resource[KeyValuePattern[Type->Object[Resource, Instrument]]], Infinity]
        ],
        ResolvedOptions->{}
      |>;

      SimulateResources[protocolPacket, ToList[myUnitOperationPackets], ParentProtocol->Lookup[myResolvedOptions, ParentProtocol, Null], Simulation->simulation]
    ],

    (* Otherwise, our resource packets went fine and we have an Object[Protocol, FlowCytometry]. *)
    True,
    SimulateResources[myProtocolPacket, ToList[myUnitOperationPackets], Simulation->simulation]
  ];

  (* Get resource information off of the simulation packets to simulate the compiler *)

  (* Download information from our simulated resources. *)
  simulatedUnitOperationPackets =Quiet[
      Download[
        protocolObject,
        Packet[BatchedUnitOperations[{SampleLink,InjectionTable, PreparedPlate, SampleVolume, Reagent, InjectionContainers, AdjustmentSample, UnstainedSampleLink, ReagentVolume}]],
        Simulation->currentSimulation
    ],
    {Download::NotLinkField, Download::FieldDoesntExist}
  ];

  {
    injectionTable,
    preparedPlate,
    sampleVolumes,
    reagents,
    injectionContainers,
    adjustmentSample,
    unstainedSample,
    workingSamples,
    reagentVolumes
  }=Lookup[
    First[simulatedUnitOperationPackets],
    {
      InjectionTable,
      PreparedPlate,
      SampleVolume,
      Reagent,
      InjectionContainers,
      AdjustmentSample,
      UnstainedSampleLink,
      SampleLink,
      ReagentVolume
    }
  ];

  adjustmentSampleObjects=If[MatchQ[#,Null],Null,#[Object]]&/@adjustmentSample;
  reagentObjects=If[MatchQ[#,Null],Null,#[Object]]&/@reagents;
  unstainedSampleObject=If[MatchQ[#,Null],Null,#[Object]]&/@unstainedSample;
  workingSamplesObjects=If[MatchQ[#,Null],Null,#[Object]]&/@workingSamples;

  (*From Compiler Start*)

  (* ==== Make all of the Primitives ==== *)
  (* ---- SamplePreparationPlate ---- *)
  (* First how many wells to use *)
  numWells=Length[injectionTable]+Length[DeleteDuplicates[reagentObjects/.Null->Nothing]];

  (* Define all available wells *)
  availableWells=If[
    MatchQ[injectionContainers,ObjectP[Object[Container, Vessel]]],
    (*it's going in a rack*)
    Flatten[AllWells[AspectRatio -> 8/5, NumberOfWells -> 40]],
    Flatten[AllWells[]]
  ];

  (* -- Define the Transfers -- *)
  (* If it is in a prepared plate, not transfers,
  If it is already in tubes, no transfers for samples,
  If it is already in a good plate, see if adjustments samples, unstained samples, blanks, reagents etc, need to be added*)

  (*expand the containers to number of wells*)
  containersExpanded=If[
    Or[MatchQ[preparedPlate,True],MatchQ[injectionContainers,ObjectP[Object[Container, Vessel]]]],
    workingSamples[Object],
    Take[
      Flatten[Table[#, Length[availableWells]] & /@ injectionContainers[Object]],
      numWells
    ]
  ];

  (*get the destinations of the samples*)
  sampleDestinations=If[
    Or[MatchQ[preparedPlate,True],MatchQ[injectionContainers,ObjectP[Object[Container, Vessel]]]],
    Null,
    MapThread[
      {#1,#2}&,
      {containersExpanded,Take[Flatten[Table[availableWells, Length[containersExpanded]], 1],numWells]}
    ]
  ];

  allSampleObjects= Join[injectionTable[[All,2]][Object],DeleteDuplicates[reagentObjects/.Null->Nothing]];

  injectionTableObjects=#[All,2][Object] & /@injectionTable;

  sampleWells=Flatten[availableWells[[Flatten[Position[injectionTableObjects,ObjectP[#]]]]]&/@workingSamples[Object]];

  (*since these are index matched to detectors, we need to put in Null values*)
  adjustmentSampleWells=Flatten[If[
    MatchQ[#,Null],
    Null,
    availableWells[[Flatten[Position[injectionTableObjects,ObjectP[#]]]]]
  ]&/@adjustmentSampleObjects];

  unstainedSampleWells=ToList[availableWells[[Flatten[Position[injectionTableObjects,ObjectP[unstainedSampleObject]]]]]];

  protocolPacketUpdate=<|
    Object->protocolObject,
    Replace[SampleWells]->sampleWells,
    Replace[AdjustmentSampleWells]->adjustmentSampleWells,
    Replace[UnstainedSampleWells]->unstainedSampleWells
  |>;
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[protocolPacketUpdate]];

  unitOperationPacketUpdate=<|
    Object->unitOperationObject,
    Replace[SampleWells]->sampleWells,
    Replace[AdjustmentSampleWells]->adjustmentSampleWells,
    Replace[UnstainedSampleWells]->unstainedSampleWells
  |>;
  currentSimulation = UpdateSimulation[currentSimulation, Simulation[unitOperationPacketUpdate]];

  (*Make a lookup association to get the volumes of each sample needed*)
  sampleVolumesRules=If[
    MatchQ[preparedPlate,True],
    {},
    MapThread[#1->#2&,{workingSamplesObjects,sampleVolumes}]
  ];

  (*Make the stuff from the injection table*)
  allSampleVolumes=Join[injectionTable[[All,3]],If[MatchQ[reagentVolumes,NullP],{},{Total[reagentVolumes]}/. {Null} -> Nothing]];
  allSampleVolumesRules= MapThread[#1->#2&,{allSampleObjects,allSampleVolumes}];

  (* Get any samples that we have to initialize in our destinations. *)
  sampleUploads=UploadSample[
    (* NOTE: UploadSample takes in {} instead of Null if there is no model. *)
    (* NOTE: Temporary work around because the way that we're currently calculating the model to simulate is incorrect. *)
    ConstantArray[{}, Length[sampleDestinations]],
    {Last[#], First[#]} & /@sampleDestinations,
    State->ConstantArray[Liquid, Length[sampleDestinations]],
    InitialAmount->ConstantArray[Null, Length[sampleDestinations]],
    UpdatedBy->protocolObject,
    Simulation->currentSimulation,
    FastTrack->True,
    Upload->False,
    SimulationMode -> True
  ];

  newDestinationSampleObjects=(Lookup[#, Object]&)/@Take[sampleUploads, Length[sampleDestinations]];

  (* Update the cache to contain the sampleUploadsPackets *)
  cacheForUST = Experiment`Private`FlattenCachePackets[{cache,sampleUploads}];

  (*move the samples into the wells/vessels*)
  sampleTransfers=If[
    Or[MatchQ[preparedPlate,True],MatchQ[injectionContainers,ObjectP[Object[Container, Vessel]]]],
    {},
    UploadSampleTransfer[
      allSampleObjects,
      newDestinationSampleObjects,
      allSampleObjects/.Join[sampleVolumesRules,allSampleVolumesRules],
      Simulation -> currentSimulation,
      UpdatedBy->protocolObject,
      Cache -> cacheForUST,
      Upload->False
    ]
  ];

  (*From Compiler End*)

  currentSimulation = UpdateSimulation[currentSimulation, Simulation[sampleTransfers]];

  simulationWithLabels=Simulation[
    Labels->Join[
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], mySamples}],
        {_String, ObjectP[]}
      ],
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], Lookup[samplePackets, Container]}],
        {_String, ObjectP[]}
      ]
    ],
    LabelFields->Join[
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleLabel]], (Field[SampleLink[[#]]]&)/@Range[Length[mySamples]]}],
        {_String, _}
      ],
      Rule@@@Cases[
        Transpose[{ToList[Lookup[myResolvedOptions, SampleContainerLabel]], (Field[SampleLink[[#]][Container]]&)/@Range[Length[mySamples]]}],
        {_String, _}
      ]
    ]
  ];
  (* Merge our packets with our labels. *)
  {
    protocolObject,
    UpdateSimulation[currentSimulation, simulationWithLabels]
  }
];

