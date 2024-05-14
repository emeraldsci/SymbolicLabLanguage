(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentIonChromatography: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentIonChromatography*)


(* ::Subsubsection:: *)
(*ExperimentIonChromatography*)

DefineTests[ExperimentIonChromatography,
    {
        (* --- Basic Tests --- *)
        Example[
            {Basic,"Automatically resolve all options for a set of samples:"},
            packet=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Upload->False,
                Output->Options
            ];
            packet,
            OptionsPattern[],
            Variables:>{packet},
            TimeConstraint->240
        ],
        Example[
            {Basic,"Automatically generate a protocol for a set of samples:"},
            protocol=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel
            ];
            protocol,
            ObjectP[Object[Protocol,IonChromatography]],
            Variables:>{protocol},
            TimeConstraint->240
        ],
        Example[
            {Basic,"Automatically resolve of all options for samples with a defined AnionInjectionTable:"},

            customAnionInjectionTable={
                {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
            };
            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->customAnionInjectionTable,
                Upload->False,
                Output->Options
            ];
            Lookup[options,Instrument],
            ObjectP[Model[Instrument, IonChromatography, "id:M8n3rx0K7LJG"]],
            TimeConstraint->240,
            Variables:>{customAnionInjectionTable,options}
        ],
        Example[
            {Basic,"Automatically resolve of all options for samples with a defined CationInjectionTable:"},

            customCationInjectionTable={
                {ColumnPrime,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]}
            };
            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->customCationInjectionTable,
                Upload->False,
                Output->Options
            ];
            Lookup[options,Instrument],
            ObjectP[Model[Instrument, IonChromatography, "id:M8n3rx0K7LJG"]],
            TimeConstraint->240,
            Variables:>{customCationInjectionTable,options}
        ],
        Example[
            {Basic,"Automatically resolve of all options for samples with a defined ElectrochemicalInjectionTable:"},

            customElectrochemicalInjectionTable={
                {ColumnPrime,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Blank,Model[Sample,"Milli-Q water"],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null}
            };
            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                ElectrochemicalInjectionTable->customElectrochemicalInjectionTable,
                Upload->False,
                Output->Options
            ];
            Lookup[options,Instrument],
            ObjectP[Model[Instrument,IonChromatography,"id:9RdZXv1R0Pkl"]],
            TimeConstraint->240,
            Variables:>{customElectrochemicalInjectionTable,options}
        ],

        (* --- Additional Tests --- *)
        Example[{Additional,"Automatically resolve AnalysisChannel if any AnionSamples or CationSamples are specified:"},
            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,AnalysisChannel],
            {AnionChannel,AnionChannel,CationChannel},
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Additional,"Automatically resolves to the appropriate column based on the analysis channel:"},
            options=ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionSamples->Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,AnionColumn],
            ListableP[Model[Item,Column,"Dionex IonPac AS18-Fast IC Analytical Column"]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Additional,"Automatically resolve the gradient from the specification of GradientStart, GradientEnd, and GradientDuration:"},
            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradientStart->10*Percent,
                CationGradientEnd->25*Percent,
                CationGradientDuration->15*Minute,
                Output->Options
            ];
            Lookup[options,CationGradientA],
            {{0. Minute,90. Percent},{15 Minute,75. Percent}},
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Additional,"Automatically assumes a Standard sample if any of the standard options were specified:"},
            options=ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandardColumnTemperature->25 Celsius,
                Upload->False,
                Output->Options
            ];
            Lookup[options,Standard],
            ListableP[ObjectP[]],
            TimeConstraint->240,
            Variables:>{options},
            SetUp:>{ClearMemoization[];}
        ],
        Example[{Additional,"Automatically assumes a Blank sample if any of the blank options were specified:"},
            options=ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlankSuppressorMode->DynamicMode,
                Upload->False,
                Output->Options
            ];
            Lookup[options,Blank],
            ListableP[ObjectP[]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Additional,"Specify many options simultaneously (similar to qualification procedures):"},
            protocol=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferA->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                BufferB->Model[Sample,"Milli-Q water"],
                BufferC->Model[Sample,"Milli-Q water"],
                BufferD->Model[Sample,"Milli-Q water"],
                AnionGradient->ConstantArray[Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],2],
                CationGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                CationInjectionVolume->10 Microliter,
                AnionInjectionVolume->10 Microliter,
                AnionSuppressorVoltage->5 Volt
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Variables:>{protocol},
            TimeConstraint->240
        ],
        Example[
            {Additional,"A custom anion injection table can be partially resolved, and Automatic entries will be resolved:"},

            customAnionInjectionTable={
                {ColumnPrime,AnionChannel,Automatic},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Automatic,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],AnionChannel,10 Microliter,Automatic},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Automatic,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Automatic,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Automatic}
            };

            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->customAnionInjectionTable,
                Output->Options
            ];
            Flatten@Lookup[options,AnionInjectionTable],
            {Except[Automatic]..},
            Variables:>{customAnionInjectionTable,options},
            TimeConstraint->240
        ],
        Example[
            {Additional,"A custom cation injection table can be partially resolved, and Automatic entries will be resolved:"},

            customCationInjectionTable={
                {ColumnPrime,CationChannel,Automatic},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Automatic,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],CationChannel,10 Microliter,Automatic},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Automatic,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Automatic,Automatic,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Automatic}
            };

            options=ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->customCationInjectionTable,
                Output->Options
            ];
            Flatten@Lookup[options,CationInjectionTable],
            {Except[Automatic]..},
            Variables:>{customCationInjectionTable,options},
            TimeConstraint->240
        ],


        (* --- Message tests --- *)
        Example[{Messages,"ObjectDoesNotExist","Return a warning when any specific object does not exist in the database:"},
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 10"],Object[Sample,"ExperimentIC Test Sample 11"],Object[Sample,"ExperimentIC Test Sample 12"]}
            ],
            $Failed,
            Messages:>{
                Error::ObjectDoesNotExist,
                Error::InvalidInput
            }
        ],
        Example[{Messages,"DuplicateName","Specified protocol Name does not already exist in SLL:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Name->"Test IonChromatography option template protocol" <> $SessionUUID
            ],
            $Failed,
            Messages:>{
                Error::DuplicateName,
                Error::InvalidOption
            }
        ],

        Example[{Messages,"ContainerlessSamples","Input samples each has associated container:"},
            ExperimentIonChromatography[containerlessSample],
            $Failed,
            Messages:>{
                Error::ContainerlessSamples,
                Error::InvalidInput
            },
            SetUp:>(
                $CreatedObjects={};
                containerlessSample=Upload[
                    Association[
                        Type->Object[Sample],
                        Model->Link[Model[Sample,"Milli-Q water"],Objects],
                        Volume->100 Microliter,
                        DeveloperObject -> True
                    ]
                ];
            ),
            Variables:>{containerlessSamples}
        ],
        Example[{Messages,"DiscardedSamples","The status of all input samples are not discarded:"},
            ExperimentIonChromatography[discardedSample],
            $Failed,
            Messages:>{
                Error::DiscardedSamples,
                Error::InvalidInput
            },
            SetUp:>(
                $CreatedObjects={};

                discardedSamplePlate=Upload[
                    Association[
                        Type->Object[Container,Plate],
                        Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects]
                    ]
                ];
                discardedSample=UploadSample[
                    Model[Sample,"Milli-Q water"],
                    {"A1",discardedSamplePlate},
                    InitialAmount->500 Microliter
                ];
                UploadSampleStatus[discardedSample,Discarded,FastTrack->True];
            ),
            Variables:>{discardedSample}
        ],
        Example[{Messages,"RetiredInstrument","Error if specified Instrument is Retired:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Instrument->retiredInstrument
            ],
            $Failed,
            Messages:>{
                Error::RetiredChromatographyInstrument,
                Error::InvalidOption
            },
            SetUp:>(
                retiredInstrument=Upload[
                    Association[
                        Type->Object[Instrument,IonChromatography],
                        Model->Link[Model[Instrument,IonChromatography,"Dionex ICS 6000"],Objects]
                    ]
                ];

                UploadInstrumentStatus[retiredInstrument,Retired,FastTrack->True];
            ),
            Variables:>{retiredInstrument}
        ],

        Example[{Messages,"DeprecatedInstrumentModel","The specified Instrument model is not Deprecated:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Instrument->deprecatedInstrument
            ],
            $Failed,
            Messages:>{
                Error::DeprecatedInstrumentModel,
                Error::InvalidOption
            },
            SetUp:>(
                deprecatedInstrument=Upload[
                    Association[
                        Type->Model[Instrument,IonChromatography],
                        Deprecated->True
                    ]
                ];
            ),
            Variables:>{deprecatedInstrument}
        ],
        Example[{Messages,"IncompatibleICInstrument","The specified Instrument supports the analysis channel specified:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Instrument->Object[Instrument,IonChromatography,"id:WNa4ZjK6d8Jq"]
            ],
            $Failed,
            Messages:>{
                Error::IncompatibleICInstrument,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"IncompatibleICDetector","The specified Detector is a subset of the compatible detectors for the specified analysis channel:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Detector->{SuppressedConductivity,UVVis,ElectrochemicalDetector}
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::IncompatibleICDetector
            }
        ],
        Example[{Messages,"HPICConflictingDetectionOptions","The specified detection options are not conflicting with the specified Detector option value:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                AbsorbanceWavelength->{200 Nanometer,300 Nanometer,400 Nanometer}
            ],
            $Failed,
            Messages:>{
                Error::HPICConflictingDetectionOptions,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidAnalysisChannelSpecification","A protocol either uses Anion/CationChannel or ElectrochemicalChannel:"},
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                StandardAnalysisChannel->ElectrochemicalChannel
            ],
            $Failed,
            Messages:>{
                Error::InvalidAnalysisChannelSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"ImbalancedAnionCationGrouping","If AnionSamples/Standards/Blanks and CationSamples/Standards/Blanks are specified, the object samples from these options should be the same as the input samples/specified Standard/specified Blanks respectively:"},
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]}
            ],
            $Failed,
            Messages:>{
                Error::ImbalancedAnionCationGrouping,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InconsistentAnalysisChannelSpecification","If AnionSamples/Standards/Blanks, CationSamples/Standards/Blanks and AnalysisChannel/StandardAnalysisChannel/BlankAnalysis are both specified, the analysis channel assignment between these two options should match:"},
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                CationSamples->Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->AnionChannel
            ],
            $Failed,
            Messages:>{
                Error::InconsistentAnalysisChannelSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"SampleOptionConflict","If AnionSamples or CationSamples are specified, relevant options cannot be set to Null:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionSamples->Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionDetectionTemperature->Null
            ],
            $Failed,
            Messages:>{
                Error::SampleOptionConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"StandardOptionConflict","If Standard is specified, neither of the following options are nulled out: StandardAnalysisChannel and StandardStorageCondition:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                StandardAnalysisChannel->Null
            ],
            $Failed,
            Messages:>{
                Error::StandardOptionConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"HPICNullStandardOption","If Standard is nulled out, standard related options should not have values other than Null or Automatic:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Null,
                StandardAnalysisChannel->ElectrochemicalChannel
            ],
            $Failed,
            Messages:>{
                Error::HPICNullStandardOption,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"BlankOptionConflict","If Blank is specified, neither of the following options are nulled out: BlankAnalysisChannel and BlankStorageCondition:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Blank->Model[Sample,"Milli-Q water"],
                BlankAnalysisChannel->Null
            ],
            $Failed,
            Messages:>{
                Error::BlankOptionConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"BlankOptionConflict","If ColumnPrime is being run, relevant detection and gradient options cannot be set to Null:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                ColumnRefreshFrequency->FirstAndLast,
                ColumnPrimeGradientA->Null
            ],
            $Failed,
            Messages:>{
                Error::ColumnRefreshOptionConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"HPICNullBlankOption","If Blank is nulled out, blank related options should not have values other than Null or Automatic:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Null,
                BlankAnalysisChannel->ElectrochemicalChannel
            ],
            $Failed,
            Messages:>{
                Error::HPICNullBlankOption,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"IncompatibleColumnTechnique","If either AnionColumn or CationColumn is specified, the column's chromatography technique is IonChromatography:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumn->Model[Item,Column,"id:o1k9jAGmWnjx"]
            ],
            $Failed,
            Messages:>{
                Error::IncompatibleColumnTechnique,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"IncompatibleColumnAnalysisChannel","If either AnionColumn or CationColumn is specified, the column's analysis channel matches the channel the column is used:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumn->Model[Item,Column,"id:Z1lqpMz94jlL"]
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::IncompatibleColumnAnalysisChannel
            }
        ],
        Example[{Messages,"InvalidGuardColumn","If either AnionColumn or CationColumn is specified, the column's analysis channel matches the channel the column is used:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionGuardColumn->Model[Item,Column,"id:6V0npvm3W4za"]
            ],
            $Failed,
            Messages:>{
                Error::InvalidGuardColumn,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"HPICGradientStartEndConflict","GradientStart/End options are specified or nulled out together:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                GradientStart->5 Percent
            ],
            $Failed,
            Messages:>{
                Error::HPICGradientStartEndConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"HPICGradientShortcutConflict","If GradientDuration is specified, either GradientA/B/C/D or GradientStart/End are specified:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                GradientDuration->25 Minute
            ],
            $Failed,
            Messages:>{
                Error::HPICGradientShortcutConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"HPICGradientShortcutAmbiguity","The gradient durations specified in GradientDuration and GradientA/B/C/D are consistent:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                GradientDuration->5 Minute,
                GradientA->{{0 Minute,25 Percent},{5 Minute,75 Percent}},
                GradientStart->74 Percent,
                GradientEnd->25 Percent
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::HPICGradientShortcutAmbiguity
            }
        ],
        Example[{Messages,"InconsistentGradientSpecification","If gradient is specified as a method object, it is consistent between the gradient option and the injection table:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                AnionInjectionTable->{
                    {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 2" <> $SessionUUID]}
                }
            ],
            $Failed,
            Messages:>{
                Error::InconsistentGradientSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidAnionGradientComposition","If AnionGradient is specified, the eluent concentration is less than the maximum concentration of the eluent generator:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Invalid Anion Gradient Object 1" <> $SessionUUID]
            ],
            $Failed,
            Messages:>{
                Error::InvalidAnionGradientComposition,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidGradientComposition","If AnionGradient is specified, the buffer composition sums up to 100 percent:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationGradient->{{0 Minute,25 Percent,50 Percent,50 Percent,0 Percent,1 Milliliter/Minute},{20 Minute,75 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute}}
            ],
            $Failed,
            Messages:>{
                Error::InvalidGradientComposition,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"OverwritingGradient","Return a warning when the gradient is overwritten by specified flow rates, gradient A, etc:"},
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                AnionFlowRate->0.5 Milliliter/Minute
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::OverwritingGradient
            }
        ],
        Example[{Messages,"ConflictingSuppressorMode","If one or more Suppressor related options are specified, they should not be contradictory:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionSuppressorMode->DynamicMode,
                AnionSuppressorVoltage->Null
            ],
            $Failed,
            Messages:>{
                Error::ConflictingSuppressorMode,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InconsistentRefreshGradientSpecification","Gradients specified in AnionInjectionTable/CationInjection table and the gradient options are consistent for column refresh:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                AnionInjectionTable->{
                    {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 2" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
                }
            ],
            $Failed,
            Messages:>{
                Error::InconsistentRefreshGradientSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidAnionRefreshGradientComposition","If AnionColumnPrimeGradient/AnionColumnFlushGradient is specified, the eluent concentration is less than the maximum concentration of the eluent generator:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Invalid Anion Gradient Object 1" <> $SessionUUID]
            ],
            $Failed,
            Messages:>{
                Error::InvalidAnionRefreshGradientComposition,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidRefreshGradientComposition","If CationColumnPrimeGradient/CationColumnFlushGradient/ColumnPrimeGradient/ColumnFlushGradient is specified, the buffe composition sum up to 100 percent:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Invalid Cation Gradient Object 1" <> $SessionUUID]
            ],
            $Failed,
            Messages:>{
                Error::InvalidRefreshGradientComposition,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"ConflictingColumnRefreshSuppressorMode","If one or more Suppressor related options are specified for column refresh, they should not be contradictory:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorMode->DynamicMode,
                AnionColumnPrimeSuppressorVoltage->Null
            ],
            $Failed,
            Messages:>{
                Error::ConflictingColumnRefreshSuppressorMode,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"FlowRateAboveMax","Specified FlowRate is not within the supported range of the instrument, and(or) the column:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionFlowRate->8 Milliliter/Minute
            ],
            $Failed,
            Messages:>{
                Error::FlowRateAboveMax,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"OverwritingSamplelessChannelOptions","If any options are specified for the analysis channel where no samples are wrong, throw this warning about overwriting option value:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                CationDetectionTemperature->30 Celsius
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::OverwritingSamplelessChannelOptions
            }
        ],
        Example[{Messages,"NoAnalyteInAnalysisChannel","If standard or blank is specified for a channel, samples injected into the channel will be check. Warning will be thrown if there's no analyte sample in that channel:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::NoAnalyteInAnalysisChannel
            }
        ],
        Example[{Messages,"InvalidAbsorbanceOption","Absorbance options are specified or Nulled out simultaneously:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                AbsorbanceWavelength->280 Nanometer,
                AbsorbanceSamplingRate->Null
            ],
            $Failed,
            Messages:>{
                Error::InvalidAbsorbanceOption,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidElectrochemicalOption","Electrochemical options are all specified or left as Automatic if Detector is set to includ ElectrochemicalDetector:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                DetectionTemperature->Null
            ],
            $Failed,
            Messages:>{
                Error::InvalidElectrochemicalOption,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidElectrochemicalDetectionModeOption","ElectrochemicalDetectionMode options are specified correctly with either VoltageProfile or WaveformProfile:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalDetectionMode->DCAmperometricDetection,
                VoltageProfile->Null
            ],
            $Failed,
            Messages:>{
                Error::InvalidElectrochemicalDetectionModeOption,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"ConflictingElectrochemicalDetectionModes","The specified ElectrochemicalDetectionMode is consistent with that of the specified waveform:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                ElectrochemicalDetectionMode->IntegratedPulsedAmperometricDetection
            ],
            $Failed,
            Messages:>{
                Error::ConflictingElectrochemicalDetectionModes,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidTimeSpecification","The time specified in voltage profile is monotonically increasing:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{{0 Minute,0.1 Volt},{5 Minute,0.5 Volt},{4 Minute,0.3 Volt}}
            ],
            $Failed,
            Messages:>{
                Error::InvalidTimeSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"InvalidTimeSpecification","The time specified in waveform profile is monotonically increasing:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{
                    {0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},
                    {5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},
                    {4 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}
                }
            ],
            $Failed,
            Messages:>{
                Error::InvalidTimeSpecification,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"MultipleWaveformDuration","The specified waveforms have different durations:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{
                    {0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},
                    {5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 3" <> $SessionUUID]}
                }
            ],
            $Failed,
            Messages:>{
                Error::MultipleWaveformDuration,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"ColumnRefreshMultipleWaveformDuration","The specified waveforms have different durations for column refreshes:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{
                    {0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},
                    {5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 3" <> $SessionUUID]}
                }
            ],
            $Failed,
            Messages:>{
                Error::ColumnRefreshMultipleWaveformDuration,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"MultipleElectrochemicalDetectionModes","The specified waveforms have different electrochemical detection modes:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{
                    {0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},
                    {5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 2" <> $SessionUUID]}
                }
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::MultipleElectrochemicalDetectionModes
            }
        ],
        Example[{Messages,"pHCalibrationOptionConflict","If pHCalibration is turned on, relevant calibration options should not be Null:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                pHCalibration->True,
                NeutralpHCalibrationBuffer->Null
            ],
            $Failed,
            Messages:>{
                Error::pHCalibrationOptionConflict,
                Error::InvalidOption
            }
        ],
        Example[{Messages,"pHCalibrationTarget","If the target pH of the calibration buffer is specified, it matches that in the buffer model:"},
            ExperimentIonChromatography[
                Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                pHCalibration->True,
                SecondarypHCalibrationBuffer->Model[Sample,"id:1ZA60vwjbbV8"],
                SecondarypHCalibrationBufferTarget->4
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            Messages:>{
                Warning::pHCalibrationTarget
            }
        ],


        (* = Injection table related messages = *)
        Example[{Messages,"InjectionTableForeignSamples","Return an error when the anion injection table is specified but has a different order and repetition to that of the resolved or specified anion samples:"},
            customAnionInjectionTable={
                {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                (*removed sample 1 here*)
                {Blank,Model[Sample,"Milli-Q water"],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],AnionChannel,2 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->customAnionInjectionTable
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignSamples,
                Error::InvalidOption
            },
            Variables:>{customAnionInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignSamples","Return an error when the cation injection table is specified but has a different order and repetition to that of the input samples:"},
            customCationInjectionTable={
                {ColumnPrime,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                (*removed sample 1 here*)
                {Blank,Model[Sample,"Milli-Q water"],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multi Cation Standard 1 for IC"],CationChannel,2 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->customCationInjectionTable
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignSamples,
                Error::InvalidOption
            },
            Variables:>{customCationInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignSamples","Return an error when the electrochemical injection table is specified but has a different order and repetition to that of the input samples:"},
            customElectrochemicalInjectionTable={
                {ColumnPrime,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                (* Removed sample 1 here *)
                {Blank,Model[Sample,"Milli-Q water"],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalInjectionTable->customElectrochemicalInjectionTable
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignSamples,
                Error::InvalidOption
            },
            Variables:>{customElectrochemicalInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignBlanks","Return an error when the anion injection table is specified and conflicts with a specified AnionBlank:"},
            customAnionInjectionTable={
                {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],AnionChannel,2 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->customAnionInjectionTable,
                AnionBlank->Model[Sample,"Acetonitrile, LCMS grade"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignBlanks,
                Error::InvalidOption
            },
            Variables:>{customAnionInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignBlanks","Return an error when the cation injection table is specified and conflicts with a specified CationBlank:"},
            customCationInjectionTable={
                {ColumnPrime,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multi Cation Standard 1 for IC"],CationChannel,2 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->customCationInjectionTable,
                CationBlank->Model[Sample,"Acetonitrile, LCMS grade"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignBlanks,
                Error::InvalidOption
            },
            Variables:>{customCationInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignBlanks","Return an error when the electrochemical injection table is specified and conflicts with a specified Blank:"},
            customElectrochemicalInjectionTable={
                {ColumnPrime,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {Blank,Model[Sample,"Milli-Q water"],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalInjectionTable->customElectrochemicalInjectionTable,
                Blank->Model[Sample,"Acetonitrile, LCMS grade"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignBlanks,
                Error::InvalidOption
            },
            Variables:>{customElectrochemicalInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignStandards","Return an error when the anion injection table is specified and conflicts with a specified AnionStandard:"},
            customAnionInjectionTable={
                {ColumnPrime,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->customAnionInjectionTable,
                AnionStandard->Model[Sample,"Chloride Standard for IC"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignStandards,
                Error::InvalidOption
            },
            Variables:>{customAnionInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignStandards","Return an error when the cation injection table is specified and conflicts with a specified CationStandard:"},
            customCationInjectionTable={
                {ColumnPrime,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Blank,Model[Sample,"Milli-Q water"],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Standard,Model[Sample,"Multi Cation Standard 1 for IC"],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->customCationInjectionTable,
                CationStandard->Model[Sample,"Sodium Standard for IC"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignStandards,
                Error::InvalidOption
            },
            Variables:>{customCationInjectionTable}
        ],
        Example[{Messages,"InjectionTableForeignStandards","Return an error when the electrochemical injection table is specified and conflicts with a specified Standard:"},
            customElectrochemicalInjectionTable={
                {ColumnPrime,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {Standard,Model[Sample,"Milli-Q water"],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],25 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"id:dORYzZJOGLZD"],Null}
            };
            ExperimentIonChromatography[
                {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalInjectionTable->customElectrochemicalInjectionTable,
                Standard->Model[Sample,"Acetonitrile, LCMS grade"]
            ],
            $Failed,
            Messages:>{
                Error::InjectionTableForeignStandards,
                Error::InvalidOption
            },
            Variables:>{customElectrochemicalInjectionTable}
        ],

        (* --- Experiment options tests --- *)
        Example[
            {Options,Instrument,"Specify the measurement device on which the protocol is to be run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Instrument->Model[Instrument,IonChromatography,"Dionex ICS 6000"],
                Output->Options
            ];
            Lookup[options,Instrument],
            Model[Instrument,IonChromatography,"Dionex ICS 6000"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Instrument,"Specify the measurement device on which the protocol is to be run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Instrument->Object[Instrument, IonChromatography, "id:GmzlKjPmo4W4"],
                Output->Options
            ];
            Lookup[options,Instrument],
            Object[Instrument, IonChromatography, "id:GmzlKjPmo4W4"],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnalysisChannel,"Specify the flow path into which the sample is injected. Cation channel employs negatively-charged stationary phase to separate positively charged species, whereas anion channel employs positively-charged stationary phase to separate negatively charge species:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->{AnionChannel,CationChannel,CationChannel,AnionChannel}
            ];
            Download[protocol,AnalysisChannels],
            {AnionChannel,CationChannel,CationChannel,AnionChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnalysisChannel,"Specify the flow path into which the sample is injected. Samples injected into AnionChannel should match resolved AnionSamples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->{AnionChannel,CationChannel,CationChannel,AnionChannel},
                Output->Options
            ];
            Lookup[options,AnionSamples],
            {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnalysisChannel,"Specify the flow path into which the sample is injected. ElectrochemicalChannel employs UVVis and electrochemical detection:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel
            ];
            Download[protocol,AnalysisChannels],
            {ElectrochemicalChannel,ElectrochemicalChannel,ElectrochemicalChannel,ElectrochemicalChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnalysisChannel,"If samples are injected into ElectrochemicalChannel, AnionSamples/CationSamples options will be Null:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel
            ];
            Download[protocol,{AnionSamples,CationSamples}],
            {{Null},{Null}},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSamples,"Specify a list of samples to be injected into the flow path of anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,AnionSamples],
            {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionSamples,"Specify a list of samples to be injected into the flow path of anion channel. Input samples that are not AnionSamples should match resolved CationSamples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,CationSamples],
            {Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionSamples,"Specify a list of samples to be injected into the flow path of anion channel. Resolved AnalysisChannel should match Anion/CationSamples specification:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]}
            ];
            Download[protocol,AnalysisChannels],
            {AnionChannel,AnionChannel,CationChannel,CationChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSamples,"Specify a list of samples to be injected into the flow path of cation channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,CationSamples],
            {Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationSamples,"Specify a list of samples to be injected into the flow path of cation channel. Input samples that are not CationSamples should match resolved AnionSamples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,AnionSamples],
            {Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationSamples,"Specify a list of samples to be injected into the flow path of cation channel. Resolved AnalysisChannel should match Anion/CationSamples specification:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]}
            ];
            Download[protocol,AnalysisChannels],
            {CationChannel,CationChannel,AnionChannel,AnionChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,Detector,"Specify a list of Detectors to use in the experiment:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
               AnalysisChannel->ElectrochemicalChannel
            ];
            Download[protocol,Detectors],
            {ElectrochemicalDetector,UVVis},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,Detector,"If any of the UV detection options is Nulled out, this option resolves to ElectrochemicalDetector only:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->Null
            ];
            Download[protocol,Detectors],
            {ElectrochemicalDetector},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,Detector,"If any of the electrochemical detection options is Nulled out, this option resolves to UVVis only:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalDetectionMode->Null
            ];
            Download[protocol,Detectors],
            {UVVis},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionColumn,"Specify a device with positively-charged resin through which the buffer and anion samples flow:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionColumn->Model[Item,Column,"Dionex IonPac AS18-Fast IC Analytical Column"],
                Output->Options
            ];
            Lookup[options,AnionColumn],
            Model[Item,Column,"Dionex IonPac AS18-Fast IC Analytical Column"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionColumn,"If there are no AnionSamples/AnionStandard/AnionBlank, AnionColumn is resolved to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->Null,
                CationBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,AnionColumn],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationColumn,"Specify a device with negatively-charged resin through which the buffer and input samples flow:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                CationColumn->Model[Item,Column,"Dionex IonPac CS16 4Micron IC Analytical Column"],
                Output->Options
            ];
            Lookup[options,CationColumn],
            Model[Item,Column,"Dionex IonPac CS16 4Micron IC Analytical Column"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationColumn,"If there are no CationSamples/CationStandard/CationBlank, CationColumn is resolved to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->Null,
                AnionBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,CationColumn],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Column,"Specify a device through which the buffer and input samples flow in ElectrochemicalChannel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Column->Model[Item, Column, "Dionex CarboPack PA10 BioLC Analytical 4 x 250 mm"],
                Output->Options
            ];
            Lookup[options,Column],
            Model[Item, Column, "Dionex CarboPack PA10 BioLC Analytical 4 x 250 mm"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Column,"If there are no Samples for the ElectrochemicalChannel, Column is resolved to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,Column],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGuardColumn,"Specify a protective device placed in the flow path before the AnionColumn in order to adsorb fouling contaminants and, thus, preserve the AnionColumn lifetime:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionGuardColumn->Model[Item,Column,"Dionex IonPac AS18 IC Guard Column"],
                Output->Options
            ];
            Lookup[options,AnionGuardColumn],
            Model[Item,Column,"Dionex IonPac AS18 IC Guard Column"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGuardColumn,"If AnionColumn resolves to Null, AnionGuardColumn also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,AnionGuardColumn],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGuardColumn,"Specify a protective device placed in the flow path before the CationColumn in order to adsorb fouling contaminants and, thus, preserve the CationColumn lifetime:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                CationGuardColumn->Model[Item,Column,"Dionex IonPac CS16 4Micron IC Guard Column"],
                Output->Options
            ];
            Lookup[options,CationGuardColumn],
            Model[Item,Column,"Dionex IonPac CS16 4Micron IC Guard Column"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGuardColumn,"If CationColumn resolves to Null, CationGuardColumn also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Output->Options
            ];
            Lookup[options,CationGuardColumn],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,GuardColumn,"Specify a protective device placed in the flow path before the Column in order to adsorb fouling contaminants and, thus, preserve the Column lifetime:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GuardColumn->Model[Item,Column,"Dionex CarboPack PA10 BioLC Guard 4 x 50 mm"],
                Output->Options
            ];
            Lookup[options,GuardColumn],
            Model[Item,Column,"Dionex CarboPack PA10 BioLC Guard 4 x 50 mm"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,GuardColumn,"If Column resolves to Null, GuardColumn also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,GuardColumn],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionColumnTemperature,"Specify the temperature the AnionColumn is held to throughout the separation and measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionColumnTemperature->50 Celsius
            ];
            Download[protocol,AnionColumnTemperature],
            {50. Celsius,50. Celsius,50. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionColumnTemperature,"If AnionColumn resolves to Null, AnionColumnTemperature also resolves to Null:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}
            ];
            Download[protocol,AnionColumnTemperature],
            {},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnTemperature,"Specify the temperature the CationColumn is held to throughout the separation and measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationColumnTemperature->25 Celsius
            ];
            Download[protocol,CationColumnTemperature],
            {25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnTemperature,"If CationColumn resolves to Null, CationColumnTemperature also resolves to Null:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}
            ];
            Download[protocol,CationColumnTemperature],
            {},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnTemperature,"Specify the temperature the Column is held to throughout the separation and measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnTemperature->25 Celsius
            ];
            Download[protocol,ColumnTemperature],
            {25. Celsius,25. Celsius,25. Celsius,25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnTemperature,"If Column resolves to Null, ColumnTemperature also resolves to Null:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}
            ];
            Download[protocol,ColumnTemperature],
            {},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,NumberOfReplicates,"Specify the number of times to repeat measurements on each provided sample(s). If Aliquot->True, this also indicates the number of times each provided sample will be aliquoted:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"],
                NumberOfReplicates->2
            ];
            Type/.Download[protocol,AnionInjectionTable],
            {ColumnPrime,Blank,Standard,Sample,Sample,Sample,Sample,Blank,Standard,ColumnFlush},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,SampleTemperature,"Specify the temperature at which the samples, Standard, and Blank are kept in the autosampler:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                SampleTemperature->4 Celsius
            ];
            Download[protocol,SampleTemperature],
            4. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionInjectionVolume,"Specify the physical quantity of sample loaded into the anion flow path for measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionInjectionVolume->{5 Microliter,5 Microliter,10 Microliter,5 Microliter},
                AnionColumnRefreshFrequency->None
            ];
            InjectionVolume/.Download[protocol,AnionInjectionTable],
            {5. Microliter,5. Microliter,10. Microliter,5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationInjectionVolume,"Specify the physical quantity of sample loaded into the cation flow path for measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationInjectionVolume->{5 Microliter,5 Microliter,10 Microliter,5 Microliter},
                CationColumnRefreshFrequency->None
            ];
            InjectionVolume/.Download[protocol,CationInjectionTable],
            {5. Microliter,5. Microliter,10. Microliter,5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,InjectionVolume,"Specify the physical quantity of sample loaded into the ElectrochemicalChannel for measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                InjectionVolume->{5 Microliter,5 Microliter,10 Microliter,5 Microliter},
                ColumnRefreshFrequency->None
            ];
            InjectionVolume/.Download[protocol,ElectrochemicalInjectionTable],
            {5. Microliter,5. Microliter,10. Microliter,5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BufferA,"Specify the solvent pumped through channel A of the flow path in cation channel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferA->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Output->Options
            ];
            Lookup[options,BufferA],
            Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferA,"Specify the solvent pumped through channel A of the flow path in cation channel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Output->Options
            ];
            Lookup[options,BufferA],
            Model[Sample,"Milli-Q water"],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferA,"If not specified, BufferA/B/C/D are automatically resolved to 50 mM MSA and Milli-Q water for CationChannel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,{BufferA,BufferB,BufferC,BufferD}],
            {
                Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Model[Sample,"Milli-Q water"],
                Model[Sample,"Milli-Q water"],
                Model[Sample,"Milli-Q water"]
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferA,"If not specified, BufferA/B/C/D are automatically resolved to Milli-Q water and 200 mM NaOH for Electrochemical detection:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Output->Options
            ];
            Lookup[options,{BufferA,BufferB,BufferC,BufferD}],
            {
                Model[Sample,"Milli-Q water"],
                Model[Sample,StockSolution,"Sodium Hydroxide Solution, 0.1M in Water, LCMS Grade"],
                Model[Sample,"Milli-Q water"],
                Model[Sample,"Milli-Q water"]
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferA,"If there are no CationSamples/CationStandard/CationBlank or any sample for ElectrochemicalChannel, BufferA/B/C/D resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{BufferA,BufferB,BufferC,BufferD}],
            {Null,Null,Null,Null},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferA,"BufferA can be resolved from specified cation gradient objects:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,{BufferA,BufferB,BufferC,BufferD}],
            Download[Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],{BufferA,BufferB,BufferC,BufferD}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferB,"Specify the solvent pumped through channel B of the flow path in cation channel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferB->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Output->Options
            ];
            Lookup[options,BufferB],
            Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferC,"Specify the solvent pumped through channel C of the flow path in cation channel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferC->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Output->Options
            ];
            Lookup[options,BufferC],
            Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferD,"Specify the solvent pumped through channel D of the flow path in cation channel:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferD->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Output->Options
            ];
            Lookup[options,BufferD],
            Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,EluentGradient,"Specify the concentration of the eluent, potassium hydroxide, over time as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                EluentGradient->{{0 Minute,10 Millimolar},{10 Minute,10 Millimolar},{20 Minute,40 Millimolar},{20.1 Minute,40 Millimolar},{30 Minute,10 Millimolar},{35 Minute,10 Millimolar}},
                Output->Options
            ];
            Lookup[options,EluentGradient],
            {{0 Minute,10 Millimolar},{10 Minute,10 Millimolar},{20 Minute,40 Millimolar},{20.1 Minute,40 Millimolar},{30 Minute,10 Millimolar},{35 Minute,10 Millimolar}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,EluentGradient,"Specify an isocratic eluent gradient by giving a constant concentration:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                EluentGradient->50 Millimolar
            ];
            Download[protocol,EluentGradient],
            {50 Millimolar,50 Millimolar},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionFlowRate,"Specify the speed of the fluid through the pump for anion channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionFlowRate->0.2 Milliliter/Minute
            ];
            Download[protocol,AnionFlowRate],
            {0.2 Milliliter/Minute,0.2 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionGradientStart,"Specify a shorthand option for the starting eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradientStart->5 Millimolar,
                AnionGradientEnd->50 Millimolar,
                AnionGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionGradientStart,AnionGradientEnd,AnionGradientDuration}],
            {
                5 Millimolar,50 Millimolar,10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradientStart,"Specify a list of index-matched AnionGradientStart:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradientStart->{5 Millimolar,20 Millimolar},
                AnionGradientEnd->{50 Millimolar,25 Millimolar},
                AnionGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionGradientStart,AnionGradientEnd,AnionGradientDuration}],
            {
                {5 Millimolar,20 Millimolar},
                {50 Millimolar,25 Millimolar},
                10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradientEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradientStart->5 Millimolar,
                AnionGradientEnd->55 Millimolar,
                AnionGradientDuration->20 Minute,
                Output->Options
            ];
            Lookup[options,{AnionGradientStart,AnionGradientEnd,AnionGradientDuration}],
            {
                5 Millimolar,55 Millimolar,20 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradientDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradientStart->5 Millimolar,
                AnionGradientEnd->55 Millimolar,
                AnionGradientDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{AnionGradientStart,AnionGradientEnd,AnionGradientDuration}],
            {
                5 Millimolar,55 Millimolar,2 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionEquilibrationTime,"Specify a shorthand option for the duration of equilibration for anion channel at the starting eluent concentration at the onset of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionEquilibrationTime->5 Minute,
                Output->Options
            ];
            Lookup[options,AnionEquilibrationTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionFlushTime,"Specify a shorthand option for the duration of buffer flush for anion channel at the end of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionFlushTime->5 Minute,
                Output->Options
            ];
            Lookup[options,AnionFlushTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradient,"Specify the concentration of the eluent, potassium hydroxide, over time in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradient->{{0 Minute,20 Millimolar,0.16 Milliliter/Minute},{5 Minute,50 Millimolar,0.16 Milliliter/Minute},{20 Minute,20 Millimolar,0.16 Milliliter/Minute}},
                Output->Options
            ];
            Lookup[options,AnionGradient],
            {{0 Minute,20 Millimolar,0.16 Milliliter/Minute},{5 Minute,50 Millimolar,0.16 Milliliter/Minute},{20 Minute,20 Millimolar,0.16 Milliliter/Minute}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradient,"Specify AnionGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,AnionGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object],
            TimeConstaint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionGradient,"All anion gradient options resolve to Null if there are no AnionSamples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->CationChannel,
                Output->Options
            ];
            Lookup[options,{EluentGradient,AnionFlowRate,AnionGradientStart,AnionGradientEnd,AnionGradientDuration,AnionEquilibrationTime,AnionFlushTime,AnionGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradientA,"Specify the composition of Buffer A within the flow in cation channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradientA->25 Percent,
                CationGradientB->25 Percent,
                CationGradientC->25 Percent,
                CationGradientD->25 Percent
            ];
            Download[protocol,{CationGradientA,CationGradientB,CationGradientC,CationGradientD}],
            {
                {25 Percent,25 Percent},
                {25 Percent,25 Percent},
                {25 Percent,25 Percent},
                {25 Percent,25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationGradientB,"Specify the composition of Buffer B within the flow in cation channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradientA->25 Percent,
                CationGradientB->50 Percent,
                CationGradientC->25 Percent,
                CationGradientD->0 Percent
            ];
            Download[protocol,{CationGradientA,CationGradientB,CationGradientC,CationGradientD}],
            {
                {25 Percent,25 Percent},
                {50 Percent,50 Percent},
                {25 Percent,25 Percent},
                {0 Percent,0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationGradientC,"Specify the composition of Buffer C within the flow in cation channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradientA->0 Percent,
                CationGradientB->50 Percent,
                CationGradientC->50 Percent,
                CationGradientD->0 Percent
            ];
            Download[protocol,{CationGradientA,CationGradientB,CationGradientC,CationGradientD}],
            {
                {0 Percent,0 Percent},
                {50 Percent,50 Percent},
                {50 Percent,50 Percent},
                {0 Percent,0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationGradientD,"Specify the composition of Buffer D within the flow in cation channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradientA->0 Percent,
                CationGradientB->0 Percent,
                CationGradientC->25 Percent,
                CationGradientD->75 Percent
            ];
            Download[protocol,{CationGradientA,CationGradientB,CationGradientC,CationGradientD}],
            {
                {0 Percent,0 Percent},
                {0 Percent,0 Percent},
                {25 Percent,25 Percent},
                {75 Percent,75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationFlowRate,"Specify the speed of the fluid through the pump for cation channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationFlowRate->0.2 Milliliter/Minute
            ];
            Download[protocol,CationFlowRate],
            {0.2 Milliliter/Minute,0.2 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationGradientStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for cation channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->CationChannel,
                CationGradientStart->25 Percent,
                CationGradientEnd->50 Percent,
                CationGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationGradientStart,CationGradientEnd,CationGradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradientEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for cation channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->CationChannel,
                CationGradientStart->75 Percent,
                CationGradientEnd->50 Percent,
                CationGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationGradientStart,CationGradientEnd,CationGradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradientDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for cation channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->CationChannel,
                CationGradientStart->75 Percent,
                CationGradientEnd->50 Percent,
                CationGradientDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{CationGradientStart,CationGradientEnd,CationGradientDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationEquilibrationTime,"Specify a shorthand option for the duration of equilibration for cation channel at the starting buffer composition at the onset of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationEquilibrationTime->5 Minute,
                Output->Options
            ];
            Lookup[options,CationEquilibrationTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationFlushTime,"Specify a shorthand option for the duration of buffer flush for cation channel at the end of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationFlushTime->5 Minute,
                Output->Options
            ];
            Lookup[options,CationFlushTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradient,"Specify the buffer composition over time in the fluid flow for cation channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,0.25 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,0.25 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,0.25 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,0.25 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,CationGradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,0.25 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,0.25 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,0.25 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,0.25 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradient,"Specify CationGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,CationGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationGradient,"All cation gradient options resolve to Null if there are no CationSamples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{CationGradientA,CationGradientB,CationGradientC,CationGradientD,CationFlowRate,CationGradientStart,CationGradientEnd,CationGradientDuration,CationEquilibrationTime,CationFlushTime,CationGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionInjectionTable,"Specify The order of sample, Standard, and Blank sample loading into the anion channel of the Instrument during measurement. Also includes the flushing and priming of the column:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionInjectionTable->{
                    {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]},
                    {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]}
                },
                Output->Options
            ];
            Lookup[options,AnionInjectionTable],
            {
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID][Object],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID][Object],AnionChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID][Object],AnionChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]},
                {ColumnFlush,AnionChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationInjectionTable,"Specify the order of sample, Standard, and Blank sample loading into the cation channel of the Instrument during measurement. Also includes the flushing and priming of the column:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionTable->{
                    {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]},
                    {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]}
                },
                Output->Options
            ];
            Lookup[options,CationInjectionTable],
            {
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID][Object],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID][Object],CationChannel,10 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID][Object],CationChannel,5 Microliter,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]},
                {ColumnFlush,CationChannel,Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalInjectionTable,"Specify the order of sample, Standard, and Blank sample loading into the electrochemical channel of the Instrument during measurement. Also includes the flushing and priming of the column:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalInjectionTable->{
                    {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],10 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],10 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                    {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],5 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null},
                    {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],Null}
                },
                Output->Options
            ];
            Lookup[options,ElectrochemicalInjectionTable],
            {
                {Sample,Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID][Object],10 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID][Object],10 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],Null},
                {Sample,Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID][Object],5 Microliter,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],Null},
                {ColumnFlush,Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],Null}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,NeedleWashSolution,"Specify the solvent used to wash the injection needle before each sample measurement:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                NeedleWashSolution->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,NeedleWashSolution],
            Model[Sample,"Milli-Q water"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionSuppressorMode,"Specify the mode of operation for anion suppressor:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionSuppressorMode],
            {DynamicMode,DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorMode,"AnionSuppressorMode automatically resolves to LegacyMode if AnionSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionSuppressorMode],
            {LegacyMode,LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorMode,"AnionSuppressorMode automatically resolves to DynamicMode if AnionSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorVoltage->5 Volt
            ];
            Download[protocol,AnionSuppressorMode],
            {DynamicMode,DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorVoltage,"Specify the potential difference across the anion supressor:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorVoltage->3 Volt
            ];
            Download[protocol,AnionSuppressorVoltage],
            {3. Volt,3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorVoltage,"AnionSuppressorVoltage automatically resolves to Null if AnionSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorMode->LegacyMode
            ];
            Download[protocol,AnionSuppressorVoltage],
            ListableP[Null],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionSuppressorCurrent],
            {35. Milliampere,35. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionSuppressorCurrent,"AnionSuppressorCurrent automatically resolves to Null if AnionSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionSuppressorCurrent],
            ListableP[Null],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionDetectionTemperature,"Specify the temperature of the cell where conductivity of the anion sample is measured:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionDetectionTemperature->25 Celsius
            ];
            Download[protocol,AnionDetectionTemperature],
            {25. Celsius,25. Celsius,25. Celsius,25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionDetectionTemperature,"All anion detection parameters resolve to Null if there's no AnionSamples:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}
            ];
            Download[protocol,{AnionSuppressorMode,AnionSuppressorVoltage,AnionSuppressorCurrent,AnionDetectionTemperature}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorMode,"Specify the mode of operation for cation suppressor:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorMode->DynamicMode
            ];
            Download[protocol,CationSuppressorMode],
            {DynamicMode,DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorMode,"CationSuppressorMode automatically resolves to LegacyMode if CationSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationSuppressorMode],
            {LegacyMode,LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorMode,"CationSuppressorMode automatically resolves to DynamicMode if CationSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorVoltage->5 Volt
            ];
            Download[protocol,CationSuppressorMode],
            {DynamicMode,DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorVoltage,"Specify the potential difference across the cation supressor:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorVoltage->3 Volt
            ];
            Download[protocol,CationSuppressorVoltage],
            {3. Volt,3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorVoltage,"CationSuppressorVoltage automatically resolves to Null if CationSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorMode->LegacyMode
            ];
            Download[protocol,CationSuppressorVoltage],
            ListableP[Null],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in cation channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationSuppressorCurrent],
            {25. Milliampere,25. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationSuppressorCurrent,"CationSuppressorCurrent automatically resolves to Null if CationSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSuppressorMode->DynamicMode
            ];
            Download[protocol,CationSuppressorCurrent],
            ListableP[Null],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationDetectionTemperature,"Specify the temperature of the cell where conductivity of the cation sample is measured:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationDetectionTemperature->25 Celsius
            ];
            Download[protocol,CationDetectionTemperature],
            {25. Celsius,25. Celsius,25. Celsius,25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationDetectionTemperature,"All cation detection parameters resolve to Null if there's no CationSamples:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]}
            ];
            Download[protocol,{CationSuppressorMode,CationSuppressorVoltage,CationSuppressorCurrent,CationDetectionTemperature}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        Example[
            {Options,GradientA,"Specify the composition of Buffer A within the flow in electrochemical channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientA->25 Percent,
                GradientB->25 Percent,
                GradientC->25 Percent,
                GradientD->25 Percent
            ];
            Download[protocol,{GradientA,GradientB,GradientC,GradientD}],
            {
                {25 Percent,25 Percent},
                {25 Percent,25 Percent},
                {25 Percent,25 Percent},
                {25 Percent,25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,GradientB,"Specify the composition of Buffer B within the flow in electrochemical channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientA->25 Percent,
                GradientB->50 Percent,
                GradientC->25 Percent,
                GradientD->0 Percent
            ];
            Download[protocol,{GradientA,GradientB,GradientC,GradientD}],
            {
                {25 Percent,25 Percent},
                {50 Percent,50 Percent},
                {25 Percent,25 Percent},
                {0 Percent,0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,GradientC,"Specify the composition of Buffer C within the flow in electrochemical channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientA->0 Percent,
                GradientB->50 Percent,
                GradientC->50 Percent,
                GradientD->0 Percent
            ];
            Download[protocol,{GradientA,GradientB,GradientC,GradientD}],
            {
                {0 Percent,0 Percent},
                {50 Percent,50 Percent},
                {50 Percent,50 Percent},
                {0 Percent,0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,GradientD,"Specify the composition of Buffer D within the flow in electrochemical channel as a constant percentage:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientA->0 Percent,
                GradientB->0 Percent,
                GradientC->25 Percent,
                GradientD->75 Percent
            ];
            Download[protocol,{GradientA,GradientB,GradientC,GradientD}],
            {
                {0 Percent,0 Percent},
                {0 Percent,0 Percent},
                {25 Percent,25 Percent},
                {75 Percent,75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,FlowRate,"Specify the speed of the fluid through the pump for electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                FlowRate->0.2 Milliliter/Minute
            ];
            Download[protocol,FlowRate],
            {0.2 Milliliter/Minute,0.2 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,GradientStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientStart->25 Percent,
                GradientEnd->50 Percent,
                GradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{GradientStart,GradientEnd,GradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,GradientEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientStart->75 Percent,
                GradientEnd->50 Percent,
                GradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{GradientStart,GradientEnd,GradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,GradientDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                GradientStart->75 Percent,
                GradientEnd->50 Percent,
                GradientDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{GradientStart,GradientEnd,GradientDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,EquilibrationTime,"Specify a shorthand option for the duration of equilibration for electrochemical channel at the starting buffer composition at the onset of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                EquilibrationTime->5 Minute,
                Output->Options
            ];
            Lookup[options,EquilibrationTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,FlushTime,"Specify a shorthand option for the duration of buffer flush for electrochemical channel at the end of the gradient:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                FlushTime->5 Minute,
                Output->Options
            ];
            Lookup[options,FlushTime],
            5 Minute,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Gradient,"Specify the buffer composition over time in the fluid flow for electrochemical channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Gradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,Gradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Gradient,"Specify Gradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Gradient->Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,Gradient],
            Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Gradient,"All electrochemical gradient options resolve to Null if there are no samples in the electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{GradientA,GradientB,GradientC,GradientD,FlowRate,GradientStart,GradientEnd,GradientDuration,EquilibrationTime,FlushTime,Gradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceWavelength,"The physical properties of light passed through the flow for the UVVis Detector:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,AbsorbanceWavelength],
            {500 Nanometer,500 Nanometer,500 Nanometer,500 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceWavelength,"Specifying multiple AbsorbanceWavelengths for an experiment:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->{{500 Nanometer,280 Nanometer},{200 Nanometer,400 Nanometer}},
                Output->Options
            ];
            Lookup[options,AbsorbanceWavelength],
            {{500 Nanometer,280 Nanometer},{200 Nanometer,400 Nanometer}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceWavelength,"If UVVis detector is not used, AbsorbanceWavelength resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,AbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceWavelength,"If AbsorbanceSamplingRate is set to Null, AbsorbanceWavelength also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceSamplingRate->Null,
                Output->Options
            ];
            Lookup[options,AbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceSamplingRate,"Specifying the frequency of absorbance measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceSamplingRate->50/Second,
                Output->Options
            ];
            Lookup[options,AbsorbanceSamplingRate],
            50/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceSamplingRate,"When multiple AbsorbanceWavelength is specified, AbsorbanceSamplingRate resolves to 1/Second if left unspecified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->{{500 Nanometer,280 Nanometer},{200 Nanometer,400 Nanometer}},
                Output->Options
            ];
            Lookup[options,AbsorbanceSamplingRate],
            1/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AbsorbanceSamplingRate,"If UVVis detector is not used, AbsorbanceSamplingRate resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,AbsorbanceSamplingRate],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalDetectionMode,"Specifies the mode of operation for the electrochemical detector:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalDetectionMode->PulsedAmperometricDetection,
                Output->Options
            ];
            Lookup[options,ElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalDetectionMode,"If VoltageProfile is populated, ElectrochemicalDetectionMode resolves to DCAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->0.2 Volt,
                Output->Options
            ];
            Lookup[options,ElectrochemicalDetectionMode],
            DCAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalDetectionMode,"If WaveformProfile is populated, ElectrochemicalDetectionMode resolves to PulsedAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalDetectionMode,"If electrochemical detector is not used in a protocol, ElectrochemicalDetectionMode resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,ElectrochemicalDetectionMode],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,pHCalibration,"Indicates whether the reference electrode needs to be calibrated against standard pH solutions before samples are injected:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                pHCalibration->True,
                Output->Options
            ];
            Lookup[options,pHCalibration],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,pHCalibration,"If any pH calibration related options are specified, pHCalibration autoamtically resolves to True:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                NeutralpHCalibrationBuffer->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,pHCalibration],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,pHCalibration,"If electrochemical detector is not used in a protocol, pHCalibration should be Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,pHCalibration],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,NeutralpHCalibrationBuffer,"Specifies the solution with a neutral pH (pH=7) used during the pH electrode calibration:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                NeutralpHCalibrationBuffer->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,NeutralpHCalibrationBuffer],
            Model[Sample,"Milli-Q water"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,SecondarypHCalibrationBuffer,"Specifies the solution with a non-neutral pH used during the pH electrode calibration:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                SecondarypHCalibrationBuffer->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,SecondarypHCalibrationBuffer],
            Model[Sample,"Milli-Q water"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,SecondarypHCalibrationBufferTarget,"Specifies the target pH of the secondary pH calibration buffer:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                SecondarypHCalibrationBufferTarget->10,
                Output->Options
            ];
            Lookup[options,SecondarypHCalibrationBufferTarget],
            10,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,SecondarypHCalibrationBufferTarget,"If a pH reference solution is used with a target pH already, SecondarypHCalibrationBufferTarget should automatically resolve to that target pH:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                SecondarypHCalibrationBuffer->Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
                Output->Options
            ];
            Lookup[options,SecondarypHCalibrationBufferTarget],
            4.01,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WorkingElectrode,"Specify the electrode where the analytes undergo reduction or oxidation recations due to the potential difference applied:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WorkingElectrode->Model[Item,Electrode,"Dionex Disposable on Polyester Electrode"],
                Output->Options
            ];
            Lookup[options,WorkingElectrode],
            Model[Item,Electrode,"Dionex Disposable on Polyester Electrode"][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WorkingElectrodeStorageCondition,"Specifies the conditions under which the WorkingElectrode used by this experiment should be stored after the protocol is completed:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WorkingElectrodeStorageCondition->AmbientStorage,
                Output->Options
            ];
            Lookup[options,WorkingElectrodeStorageCondition],
            AmbientStorage,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WorkingElectrodeStorageCondition,"If electrochemical detector is not used in a protocol, both WorkingElectrode and WorkingElectrodeStorageCondition resolve to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,{WorkingElectrode,WorkingElectrodeStorageCondition}],
            {Null,Null},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ReferenceElectrodeMode->pH,
                Output->Options
            ];
            Lookup[options,ReferenceElectrodeMode],
            pH,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode in the generated Waveform object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ReferenceElectrodeMode->pH
            ];
            Download[protocol,WaveformObjects][ReferenceElectrodeMode],
            {pH},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,VoltageProfile,"Specifies the time-dependent voltage setting throughout the measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->0.5 Volt,
                Output->Options
            ];
            Lookup[options,VoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,VoltageProfile,"Specify VoltageProfile as a list of tuples in the form of {Time, Voltage}...:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
                Output->Options
            ];
            Lookup[options,VoltageProfile],
            {{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,VoltageProfile,"VoltageProfile resolves to Null if WaveformProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,VoltageProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the analysis:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
                Output->Options
            ];
            Lookup[options,WaveformProfile],
            {{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the analysis:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
                Output->Options
            ];
            Lookup[options,WaveformProfile],
            {{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WaveformProfile,"Specify WaveformProfile as a waveform method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,WaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WaveformProfile,"Specify WaveformProfile as multiple waveform method objects:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}},
                Output->Options
            ];
            Lookup[options,WaveformProfile],
            {{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,WaveformProfile,"New waveform objects will be created and uploaded if WaveformProfile is not specified directly as a method object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}
            ];
            Download[protocol,WaveformObjects],
            {ObjectP[Object[Method,Waveform]]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,WaveformProfile,"If multiple waveforms are used, separate waveform method objects will be uploaded:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}}
            ];
            Download[protocol,WaveformObjects],
            {ObjectP[Object[Method,Waveform]]...},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,WaveformProfile,"WaveformProfile resolves to Null if VoltageProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->0.1 Volt,
                Output->Options
            ];
            Lookup[options,WaveformProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ElectrochemicalSamplingRate,"Indicates the frequency of amperometric measurement:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ElectrochemicalSamplingRate->2/Second
            ];
            Download[protocol,ElectrochemicalSamplingRate],
            {2./Second,2./Second,2./Second,2./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ElectrochemicalSamplingRate,"ElectrochemicalSamplingRate is automatically set based on the specified Waveform:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"id:o1k9jAG1DRRa"]
            ];
            Download[protocol,ElectrochemicalSamplingRate],
            {1./Second,1./Second,1./Second,1./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,DetectionTemperature,"Specify the temperature of the detection oven where the eletrochemical detection takes place:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                DetectionTemperature->30 Celsius,
                Output->Options
            ];
            Lookup[options,DetectionTemperature],
            30 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,DetectionTemperature,"All electrochemical detector related options resolve to Null if electrochemical detector is not used:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,{ElectrochemicalDetectionMode,WorkingElectrode,ReferenceElectrodeMode,VoltageProfile,WaveformProfile,ElectrochemicalSamplingRate,DetectionTemperature}],
            {Null...},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BufferAStorageCondition,"Specify the conditions under which BufferA used by this experiment should be stored after the protocol is completed:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                BufferAStorageCondition->Disposal
            ];
            Download[protocol,BufferAStorageCondition],
            Disposal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BufferBStorageCondition,"Specify the conditions under which BufferB used by this experiment should be stored after the protocol is completed:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                BufferBStorageCondition->AmbientStorage
            ];
            Download[protocol,BufferBStorageCondition],
            AmbientStorage,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BufferCStorageCondition,"Specify the conditions under which BufferC used by this experiment should be stored after the protocol is completed:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                BufferCStorageCondition->Refrigerator
            ];
            Download[protocol,BufferCStorageCondition],
            Refrigerator,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BufferDStorageCondition,"Specify the conditions under which BufferD used by this experiment should be stored after the protocol is completed:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                BufferAStorageCondition->Disposal,
                BufferBStorageCondition->AmbientStorage,
                BufferCStorageCondition->Refrigerator,
                BufferDStorageCondition->Disposal
            ];
            Download[protocol,{BufferAStorageCondition,BufferBStorageCondition,BufferCStorageCondition,BufferDStorageCondition}],
            {Disposal,AmbientStorage,Refrigerator,Disposal},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,Standard,"Specify a reference compound to inject to the instrument, often used for quantification or to check internal measurement consistency:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                Output->Options
            ];
            Lookup[options,Standard],
            {Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Standard,"Specify standard through Anion/CationStandard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                Output->Options
            ];
            Lookup[options,Standard],
            {Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],Model[Sample,"Multi Cation Standard 1 for IC"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAnalysisChannel,"Specify the flow path into which the standard sample is injected, either Anion or Cation channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                StandardAnalysisChannel->{CationChannel,AnionChannel}
            ];
            Download[protocol,StandardAnalysisChannels],
            {CationChannel,AnionChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardAnalysisChannel,"Specify the flow path into which the standard sample is injected, either Anion or Cation channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Milli-Q water"]},
                StandardAnalysisChannel->ElectrochemicalChannel
            ];
            Download[protocol,StandardAnalysisChannels],
            {ElectrochemicalChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardAnalysisChannel,"Specify the flow path into which the standard sample is injected. Standards injected into AnionChannel should match resolved AnionStandard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                StandardAnalysisChannel->{CationChannel,AnionChannel},
                Output->Options
            ];
            Lookup[options,AnionStandard],
            {Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandard,"Specify a list of reference compounds to be injected into the anion channel of the instrument:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                Output->Options
            ];
            Lookup[options,AnionStandard],
            {Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandard,"Specify a list of reference compounds to be injected into the anion channel of the instrument. Input Standard that are not AnionStandard will automatically be resolved as CationStandard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                Output->Options
            ];
            Lookup[options,CationStandard],
            {Model[Sample,"Multi Cation Standard 1 for IC"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandard,"Specify a list of reference compounds to be injected into the anion channel of the instrument. Resolved StandardAnalysisChannel should match Anion/CationStandard specification:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                Output->Options
            ];
            Lookup[options,StandardAnalysisChannel],
            {CationChannel,AnionChannel},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardFrequency,"Specify the frequency at which AnionStandard measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnRefreshFrequency->None,
                AnionStandardFrequency->FirstAndLast,
                Output->Options
            ];
            First/@Lookup[options,AnionInjectionTable],
            {Standard,Sample,Standard},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardFrequency,"Specify the frequency at which AnionStandard measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionColumnRefreshFrequency->None,
                AnionStandardFrequency->1,
                Output->Options
            ];
            First/@Lookup[options,AnionInjectionTable],
            {Standard,Sample,Standard,Sample,Standard,Sample,Standard,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandard,"Specify a list of reference compounds to be injected into the cation channel of the instrument:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                Output->Options
            ];
            Lookup[options,CationStandard],
            {Model[Sample,"Multi Cation Standard 1 for IC"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandard,"Specify a list of reference compounds to be injected into the cation channel of the instrument. Input Standard that are not CationStandard will automatically be resolved as AnionStandard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                Output->Options
            ];
            Lookup[options,AnionStandard],
            {Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandardFrequency,"Specify the frequency at which CationStandard measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnRefreshFrequency->None,
                CationStandardFrequency->FirstAndLast,
                Output->Options
            ];
            First/@Lookup[options,CationInjectionTable],
            {Standard,Sample,Standard},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandardFrequency,"Specify the frequency at which CationStandard measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationStandardFrequency->1,
                CationColumnRefreshFrequency->None,
                Output->Options
            ];
            First/@Lookup[options,CationInjectionTable],
            {Standard,Sample,Standard,Sample,Standard,Sample,Standard,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardFrequency,"Specify the frequency at which Standard measurements will be inserted among samples for electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnRefreshFrequency->None,
                StandardFrequency->1,
                Output->Options
            ];
            First/@Lookup[options,ElectrochemicalInjectionTable],
            {Standard,Sample,Standard,Sample,Standard,Sample,Standard,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardInjectionVolume,"Specify the physical quantity of each AnionStandard to inject into the system:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->{Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                AnionStandardInjectionVolume->{7 Microliter},
                AnionStandardFrequency->First
            ];
            Cases[Download[protocol,AnionInjectionTable],KeyValuePattern[Type->Standard]][[All,4]],
            {7. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardInjectionVolume,"If AnionStandardInjectionVolume is not specified, this option should resolve to the first value of AnionInjectionVolume:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionInjectionVolume->2 Microliter,
                Standard->{Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                AnionStandardFrequency->First,
                AnionStandardInjectionVolume->Automatic
            ];
            Cases[Download[protocol,AnionInjectionTable],KeyValuePattern[Type->Standard]][[All,4]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardInjectionVolume,"Specify the physical quantity of each CationStandard to inject into the system:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"]},
                CationStandardInjectionVolume->{7 Microliter},
                CationStandardFrequency->First
            ];
            Cases[Download[protocol,CationInjectionTable],KeyValuePattern[Type->Standard]][[All,4]],
            {7. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardInjectionVolume,"If CationStandardInjectionVolume is not specified, this option should resolve to the first value of CationInjectionVolume:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionVolume->2 Microliter,
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"]},
                CationStandardFrequency->First,
                CationStandardInjectionVolume->Automatic
            ];
            Cases[Download[protocol,CationInjectionTable],KeyValuePattern[Type->Standard]][[All,4]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardInjectionVolume,"Specify the physical quantity of each Standard to inject into the electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->{Model[Sample,"Milli-Q water"]},
                StandardInjectionVolume->{7 Microliter},
                StandardFrequency->First
            ];
            Cases[Download[protocol,ElectrochemicalInjectionTable],KeyValuePattern[Type->Standard]][[All,3]],
            {7. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardInjectionVolume,"If StandardInjectionVolume is not specified, this option should resolve to the first value of InjectionVolume:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                InjectionVolume->2 Microliter,
                Standard->{Model[Sample,"Milli-Q water"]},
                StandardFrequency->First,
                StandardInjectionVolume->Automatic
            ];
            Cases[Download[protocol,ElectrochemicalInjectionTable],KeyValuePattern[Type->Standard]][[All,3]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardColumnTemperature,"Specify the temperature the AnionColumn is held to throughout the AnionStandard run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardColumnTemperature->55 Celsius
            ];
            Download[protocol,AnionStandardColumnTemperature],
            {55. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardColumnTemperature,"AnionStandardColumnTemperature resolves to Null if there is no AnionStandard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"]
            ];
            Download[protocol,AnionStandardColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardColumnTemperature,"Specify the temperature the CationColumn is held to throughout the CationStandard run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardColumnTemperature->70 Celsius
            ];
            Download[protocol,CationStandardColumnTemperature],
            {70. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardColumnTemperature,"CationStandardColumnTemperature resolves to Null if there is no CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,CationStandardColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardColumnTemperature,"Specify the temperature the Column is held to throughout the Standard run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                Standard->Model[Sample,"Milli-Q water"],
                StandardAnalysisChannel->ElectrochemicalChannel,
                StandardColumnTemperature->70 Celsius
            ];
            Download[protocol,StandardColumnTemperature],
            {70. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardColumnTemperature,"StandardColumnTemperature resolves to Null if there is no Standard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,StandardColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardEluentGradient,"Specify the concentration of the eluent, potassium hydroxide, that is automatically generated within the flow path for AnionStandard samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                StandardEluentGradient->{{0 Minute,10 Millimolar},{10 Minute,10 Millimolar},{20 Minute,40 Millimolar},{20.1 Minute,40 Millimolar},{30 Minute,10 Millimolar},{35 Minute,10 Millimolar}}
            ];
            Download[protocol,StandardEluentGradient],
            {{{0 Minute,10 Millimolar},{10 Minute,10 Millimolar},{20 Minute,40 Millimolar},{20.1 Minute,40 Millimolar},{30 Minute,10 Millimolar},{35 Minute,10 Millimolar}}},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardEluentGradient,"Specify an isocratic eluent gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                StandardEluentGradient->50 Millimolar
            ];
            Download[protocol,StandardEluentGradient],
            {50 Millimolar},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardFlowRate,"Specify the speed of the fluid through the system for AnionStandard samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardFlowRate->0.25 Milliliter/Minute
            ];
            Download[protocol,AnionStandardFlowRate],
            {0.25 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardGradientStart,"Specify a shorthand option for the starting eluent concentration in the fluid flow for anion channel for Standard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardGradientStart->5 Millimolar,
                AnionStandardGradientEnd->50 Millimolar,
                AnionStandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionStandardGradientStart,AnionStandardGradientEnd,AnionStandardGradientDuration}],
            {
                5 Millimolar,50 Millimolar,10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardGradientStart,"Specify a list of index-matched AnionStandardGradientStart:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionStandard->{Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],Model[Sample,"Milli-Q water"]},
                AnionStandardGradientStart->{5 Millimolar,20 Millimolar},
                AnionStandardGradientEnd->{50 Millimolar,25 Millimolar},
                AnionStandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionStandardGradientStart,AnionStandardGradientEnd,AnionStandardGradientDuration}],
            {
                {5 Millimolar,20 Millimolar},
                {50 Millimolar,25 Millimolar},
                10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardGradientEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardGradientStart->5 Millimolar,
                AnionStandardGradientEnd->55 Millimolar,
                AnionStandardGradientDuration->20 Minute,
                Output->Options
            ];
            Lookup[options,{AnionStandardGradientStart,AnionStandardGradientEnd,AnionStandardGradientDuration}],
            {
                5 Millimolar,55 Millimolar,20 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardGradientDuration,"Specify a shorthand option for the total time it takes to run the AnionStandard gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                StandardEluentGradient->50 Millimolar,
                AnionStandardGradientDuration->45 Minute
            ];
            First@Last@Last@Download[protocol,AnionStandardGradientMethods][AnionGradient],
            45. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardGradient,"Specify the concentration of the eluent, potassium hydroxide, over time in the fluid flow for AnionStandard samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardGradient->{{0 Minute,10 Millimolar,0.16 Milliliter/Minute},{10 Minute,10 Millimolar,0.16 Milliliter/Minute},{20 Minute,40 Millimolar,0.16 Milliliter/Minute},{20.1 Minute,40 Millimolar,0.16 Milliliter/Minute},{30 Minute,10 Millimolar,0.16 Milliliter/Minute},{35 Minute,10 Millimolar,0.16 Milliliter/Minute}},
                AnionStandardFrequency->First
            ];
            Download[protocol,AnionStandardGradientMethods][AnionGradient],
            {
                {
                    {0. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {10. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {20. Minute,40. Millimolar,0.16 Milliliter/Minute},
                    {20.1 Minute,40. Millimolar,0.16 Milliliter/Minute},
                    {30. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {35. Minute,10. Millimolar,0.16 Milliliter/Minute}
                }
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardGradient,"Specify AnionStandardGradient as a method object:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,AnionStandardGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionStandardGradient,"All anion standard related options resolve to Null if there is no AnionStandard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"]
            ];
            Download[protocol,{AnionStandardColumnTemperature,StandardEluentGradient,AnionStandardFlowRate}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorMode,"Specify the mode of operation for anion suppressor during standard injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionStandardSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorMode,"AnionStandardSuppressorMode automatically resolves to LegacyMode if AnionStandardSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionStandardSuppressorMode],
            {LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorMode,"AnionStandardSuppressorMode automatically resolves to DynamicMode if AnionStandardSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorVoltage->5 Volt
            ];
            Download[protocol,AnionStandardSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorVoltage,"Specify the potential difference across the anion supressor during standard injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorVoltage->3 Volt
            ];
            Download[protocol,AnionStandardSuppressorVoltage],
            {3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorVoltage,"AnionStandardSuppressorVoltage automatically resolves to Null if AnionStandardSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorMode->LegacyMode
            ];
            Download[protocol,AnionStandardSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionStandardSuppressorCurrent],
            {35. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionStandardSuppressorCurrent,"AnionStandardSuppressorCurrent automatically resolves to Null if AnionStandardSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionStandardSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardDetectionTemperature,"Specify the temperature of the cell where conductivity of the AnionStandard sample is measured:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionStandardDetectionTemperature->25 Celsius
            ];
            Download[protocol,AnionStandardDetectionTemperature],
            {25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardDetectionTemperature,"All anion detection parameters resolve to Null if there's no AnionStandards:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->Model[Sample,"Multi Cation Standard 1 for IC"]
            ];
            Download[protocol,{AnionStandardSuppressorMode,AnionStandardSuppressorVoltage,AnionStandardSuppressorCurrent,AnionStandardDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionStandardDetectionTemperature,"If AnionStandardDetectionTemperature is not specified, it will automatically resolve to the first value of specified AnionDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionDetectionTemperature->35 Celsius,
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,AnionStandardDetectionTemperature],
            {35. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradientA,"Specify the composition of Buffer A within the flow in cation channel as constant percentages for CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientA->25 Percent,
                CationStandardGradientB->25 Percent,
                CationStandardGradientC->25 Percent,
                CationStandardGradientD->25 Percent
            ];
            Download[protocol,{CationStandardGradientA,CationStandardGradientB,CationStandardGradientC,CationStandardGradientD}],
            {
                {25 Percent},
                {25 Percent},
                {25 Percent},
                {25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradientB,"Specify the composition of Buffer B within the flow in cation channel as a constant percentage for CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientA->25 Percent,
                CationStandardGradientB->50 Percent,
                CationStandardGradientC->25 Percent,
                CationStandardGradientD->0 Percent
            ];
            Download[protocol,{CationStandardGradientA,CationStandardGradientB,CationStandardGradientC,CationStandardGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradientC,"Specify the composition of Buffer C within the flow in cation channel as a constant percentage for CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientA->0 Percent,
                CationStandardGradientB->50 Percent,
                CationStandardGradientC->50 Percent,
                CationStandardGradientD->0 Percent
            ];
            Download[protocol,{CationStandardGradientA,CationStandardGradientB,CationStandardGradientC,CationStandardGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradientD,"Specify the composition of Buffer D within the flow in cation channel as a constant percentage for CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientA->0 Percent,
                CationStandardGradientB->0 Percent,
                CationStandardGradientC->25 Percent,
                CationStandardGradientD->75 Percent
            ];
            Download[protocol,{CationStandardGradientA,CationStandardGradientB,CationStandardGradientC,CationStandardGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardFlowRate,"Specify the speed of the fluid through the system for CationStandard samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardFlowRate->0.55 Milliliter/Minute
            ];
            Download[protocol,CationStandardFlowRate],
            {0.55 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradientStart,"Specify a shorthand option for the starting BufferB concentration in the CationStandard gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandardGradientStart->25 Percent,
                CationStandardGradientEnd->50 Percent,
                CationStandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationStandardGradientStart,CationStandardGradientEnd,CationStandardGradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandardGradientEnd,"Specify a shorthand option for the final BufferB concentration in the CationStandard gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientStart->75 Percent,
                CationStandardGradientEnd->50 Percent,
                CationStandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationStandardGradientStart,CationStandardGradientEnd,CationStandardGradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandardGradientDuration,"Specify a shorthand option for the total time it takes to run the CationStandard gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradientA->27 Percent,
                CationStandardGradientDuration->33 Minute
            ];
            First@Last@Last@Download[protocol,CationStandardGradientMethods][CationGradient],
            33. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradient,"Specify the buffer composition over time in the fluid flow for CationStandard samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,0.25 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,0.25 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,0.25 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,0.25 Milliliter/Minute}
                },
                CationStandardFrequency->First
            ];
            Download[protocol,CationStandardGradientMethods][CationGradient],
            {{
                {0. Minute,25. Percent,50. Percent,25. Percent,0. Percent,0.25 Milliliter/Minute},
                {0.1 Minute,50. Percent,50. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                {10. Minute,10. Percent,20. Percent,30. Percent,40. Percent,0.25 Milliliter/Minute},
                {20. Minute,40. Percent,30. Percent,20. Percent,10. Percent,0.25 Milliliter/Minute},
                {30. Minute,25. Percent,25. Percent,25. Percent,25. Percent,0.25 Milliliter/Minute}
            }},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationStandardGradient,"Specify CationStandardGradient as a method object:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,CationStandardGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationStandardGradient,"All cation standard related options resolve to Null if there is no CationStandard:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,{CationStandardColumnTemperature,CationStandardGradientA,CationStandardGradientB,CationStandardGradientC,CationStandardGradientD,CationStandardFlowRate}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardSuppressorMode,"Specify the mode of operation for cation suppressor during standard injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorMode->DynamicMode
            ];
            Download[protocol,CationStandardSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardSuppressorMode,"CationStandardSuppressorMode automatically resolves to LegacyMode CationStandardSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationStandardSuppressorMode],
            {LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardSuppressorMode,"CationStandardSuppressorMode automatically resolves to DynamicMode if CationStandardSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorVoltage->5 Volt];
            Download[protocol,CationStandardSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        Example[{Options,CationStandardSuppressorVoltage,"Specify the potential difference across the cation supressor during standard injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorVoltage->3 Volt];
            Download[protocol,CationStandardSuppressorVoltage],
            {3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardSuppressorVoltage,"CationStandardSuppressorVoltage automatically resolves to Null if CationStandardSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorMode->LegacyMode
            ];
            Download[protocol,CationStandardSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        Example[{Options,CationStandardSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in cation channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationStandardSuppressorCurrent],
            {25. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardSuppressorCurrent,"CationStandardSuppressorCurrent automatically resolves to Null if CationStandardSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardSuppressorMode->DynamicMode
            ];
            Download[protocol,CationStandardSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        Example[{Options,CationStandardDetectionTemperature,"Specify the temperature of the cell where conductivity of the CationStandard sample is measured:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationStandardDetectionTemperature->25 Celsius
            ];
            Download[protocol,CationStandardDetectionTemperature],
            {25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardDetectionTemperature,"All anion detection parameters resolve to Null if there's no CationStandards:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Standard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,{CationStandardSuppressorMode,CationStandardSuppressorVoltage,CationStandardSuppressorCurrent,CationStandardDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationStandardDetectionTemperature,"If CationStandardDetectionTemperature is not specified, it will automatically resolve to the first value of specified CationDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationDetectionTemperature->35 Celsius,
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"]
            ];
            Download[protocol,CationStandardDetectionTemperature],
            {35. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardGradientA,"Specify the composition of Buffer A within the flow in electrochemical channel as a constant percentage for Standard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->Model[Sample,"Milli-Q water"],
                StandardAnalysisChannel->ElectrochemicalChannel,
                StandardGradientA->25 Percent,
                StandardGradientB->25 Percent,
                StandardGradientC->25 Percent,
                StandardGradientD->25 Percent
            ];
            Download[protocol,{StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD}],
            {
                {25 Percent},
                {25 Percent},
                {25 Percent},
                {25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardGradientB,"Specify the composition of Buffer B within the flow in electrochemical channel as a constant percentage for Standard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->Model[Sample,"Milli-Q water"],
                StandardAnalysisChannel->ElectrochemicalChannel,
                StandardGradientA->25 Percent,
                StandardGradientB->50 Percent,
                StandardGradientC->25 Percent,
                StandardGradientD->0 Percent
            ];
            Download[protocol,{StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardGradientC,"Specify the composition of Buffer C within the flow in electrochemical channel as a constant percentage for Standard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->Model[Sample,"Milli-Q water"],
                StandardAnalysisChannel->ElectrochemicalChannel,
                StandardGradientA->0 Percent,
                StandardGradientB->50 Percent,
                StandardGradientC->50 Percent,
                StandardGradientD->0 Percent
            ];
            Download[protocol,{StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardGradientD,"Specify the composition of Buffer D within the flow in electrochemical channel as a constant percentage for Standard:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->Model[Sample,"Milli-Q water"],
                StandardAnalysisChannel->ElectrochemicalChannel,
                StandardGradientA->0 Percent,
                StandardGradientB->0 Percent,
                StandardGradientC->25 Percent,
                StandardGradientD->75 Percent
            ];
            Download[protocol,{StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardFlowRate,"Specify the speed of the fluid through the pump for Standards in electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardFlowRate->0.2 Milliliter/Minute
            ];
            Download[protocol,StandardFlowRate],
            {0.2 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardGradientStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for Standards in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardGradientStart->25 Percent,
                StandardGradientEnd->50 Percent,
                StandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{StandardGradientStart,StandardGradientEnd,StandardGradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardGradientEnd,"Specify a shorthand option for the final BufferB composition in the fluid flow for Standards in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardGradientStart->75 Percent,
                StandardGradientEnd->50 Percent,
                StandardGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{StandardGradientStart,StandardGradientEnd,StandardGradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardGradientDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for Standards in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardGradientStart->75 Percent,
                StandardGradientEnd->50 Percent,
                StandardGradientDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{StandardGradientStart,StandardGradientEnd,StandardGradientDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardGradient,"Specify the buffer composition over time in the fluid flow for Standards in electrochemical channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,StandardGradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardGradient,"Specify StandardGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardGradient->Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,StandardGradient],
            Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardGradient,"All electrochemical gradient options resolve to Null if there are no Standards in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD,StandardFlowRate,StandardGradientStart,StandardGradientEnd,StandardGradientDuration,StandardGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceWavelength,"The physical properties of light passed through the flow for the UVVis Detector during Standard run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardAbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceWavelength],
            {500 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceWavelength,"Specifying multiple StandardAbsorbanceWavelengths for an experiment during Standard run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardAbsorbanceWavelength->{{500 Nanometer,280 Nanometer}},
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceWavelength],
            {{500 Nanometer,280 Nanometer}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceWavelength,"If UVVis detector is not used, StandardAbsorbanceWavelength resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceWavelength,"If StandardAbsorbanceSamplingRate is set to Null, StandardAbsorbanceWavelength also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardAbsorbanceSamplingRate->Null,
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceWavelength,"If StandardAbsorbanceWavelength is not specified, it will resolve to the first value of AbsorbanceWavelength:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                AbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceWavelength],
            {500 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceSamplingRate,"Specifying the frequency of absorbance measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardAbsorbanceSamplingRate->50/Second,
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceSamplingRate],
            50/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceSamplingRate,"When multiple StandardAbsorbanceWavelength is specified, StandardAbsorbanceSamplingRate resolves to 1/Second if left unspecified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardAbsorbanceWavelength->{{500 Nanometer,280 Nanometer}},
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceSamplingRate],
            1/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardAbsorbanceSamplingRate,"If UVVis detector is not used, StandardAbsorbanceSamplingRate resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,StandardAbsorbanceSamplingRate],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardElectrochemicalDetectionMode,"Specifies the mode of operation for the electrochemical detector for Standard runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardElectrochemicalDetectionMode->PulsedAmperometricDetection,
                Output->Options
            ];
            Lookup[options,StandardElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardElectrochemicalDetectionMode,"If StandardVoltageProfile is populated, StandardElectrochemicalDetectionMode resolves to DCAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardVoltageProfile->0.2 Volt,
                Output->Options
            ];
            Lookup[options,StandardElectrochemicalDetectionMode],
            DCAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardElectrochemicalDetectionMode,"If StandardWaveformProfile is populated, StandardElectrochemicalDetectionMode resolves to PulsedAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,StandardElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardElectrochemicalDetectionMode,"If electrochemical detector is not used in a protocol, StandardElectrochemicalDetectionMode resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,StandardElectrochemicalDetectionMode],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode during Standard run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardReferenceElectrodeMode->pH,
                Output->Options
            ];
            Lookup[options,StandardReferenceElectrodeMode],
            pH,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode in the generated Waveform object for Standards:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardReferenceElectrodeMode->pH
            ];
            Download[protocol,StandardWaveformObjects][ReferenceElectrodeMode],
            {pH},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardVoltageProfile,"Specifies the time-dependent voltage setting throughout the measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardVoltageProfile->0.5 Volt,
                Output->Options
            ];
            Lookup[options,StandardVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardVoltageProfile,"Specify VoltageProfile as a list of tuples in the form of {Time, Voltage}...:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardVoltageProfile->{{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
                Output->Options
            ];
            Lookup[options,StandardVoltageProfile],
            {{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardVoltageProfile,"StandardVoltageProfile resolves to Null if WaveformProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,StandardVoltageProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardVoltageProfile,"If StandardVoltageProfile is not specified, it will resolve to the first value of VoltageProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{0.5 Volt,0.1 Volt,0.2 Volt,0.4 Volt},
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,StandardVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the Standard runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            {{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"Specify multiple waveforms that will be repeated over the duration of the Standard runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            {{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"Specify StandardWaveformProfile as a waveform method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"Specify StandardWaveformProfile as multiple waveform method objects:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->{{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}},
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            {{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"New waveform objects will be created and uploaded if StandardWaveformProfile is not specified directly as a method object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}
            ];
            Download[protocol,StandardWaveformObjects],
            {ObjectP[Object[Method,Waveform]]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardWaveformProfile,"If multiple waveforms are used, separate waveform method objects will be uploaded:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}}
            ];
            Download[protocol,StandardWaveformObjects],
            {ObjectP[Object[Method,Waveform]]...},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardWaveformProfile,"StandardWaveformProfile resolves to Null if StandardVoltageProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardVoltageProfile->0.1 Volt,
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardWaveformProfile,"If StandardWaveformProfile is not specified, it will resolve to the first value of WaveformProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,StandardWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardElectrochemicalSamplingRate,"Indicates the frequency of amperometric measurement during Standard runs:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardElectrochemicalSamplingRate->2/Second
            ];
            Download[protocol,StandardElectrochemicalSamplingRate],
            {2./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardElectrochemicalSamplingRate,"StandardElectrochemicalSamplingRate is automatically set based on the specified StandardWaveform:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardWaveformProfile->Object[Method,Waveform,"id:o1k9jAG1DRRa"]
            ];
            Download[protocol,StandardElectrochemicalSamplingRate],
            {1./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,StandardDetectionTemperature,"Specify the temperature of the detection oven where the eletrochemical detection takes place during Standard runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Standard->Model[Sample,"Milli-Q water"],
                StandardDetectionTemperature->30 Celsius,
                Output->Options
            ];
            Lookup[options,StandardDetectionTemperature],
            30 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardDetectionTemperature,"If StandardDetectionTemperature is not specified, it will resolve to the first value of DetectionTemperature:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                DetectionTemperature->29 Celsius,
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,StandardDetectionTemperature],
            29 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,StandardDetectionTemperature,"All Standard electrochemical detector related options resolve to Null if electrochemical detector is not used:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Standard->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,{StandardElectrochemicalDetectionMode,StandardReferenceElectrodeMode,StandardVoltageProfile,StandardWaveformProfile,StandardElectrochemicalSamplingRate,StandardDetectionTemperature}],
            {Null...},
            TimeConstraint->240,
            Variables:>{options}
        ],

        Example[
            {Options,StandardStorageCondition,"Specify the conditions under which any Standard used by this experiment should be stored after the protocol is completed. If this option is set to Null when Standard samples are specified, the Standard samples will be stored according to their Models' DefaultStorageCondition:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Standard->{Model[Sample,"Multi Cation Standard 1 for IC"],Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]},
                StandardStorageCondition->Disposal
            ];
            Download[protocol,StandardsStorageConditions],
            {Disposal,Disposal},
            Variables:>{protocol},
            TimeConstraint->240
        ],
        Example[{Options,Blank,"Specify a compound to inject typically as negative controls:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                Output->Options
            ];
            Lookup[options,Blank],
            {Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,Blank,"Specify blank through Anion/CationBlank:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnionBlank->Model[Sample,"Milli-Q water"],
                CationBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,Blank],
            {Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],

        Example[{Options,BlankAnalysisChannel,"Specify the flow path into which the blank sample is injected, either Anion or Cation channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                BlankAnalysisChannel->{CationChannel,AnionChannel}
            ];
            Download[protocol,BlankAnalysisChannels],
            {AnionChannel,CationChannel},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankAnalysisChannel,"Specify the flow path into which the blank sample is injected. Blanks injected into AnionChannel should match resolved AnionStandard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                BlankAnalysisChannel->{CationChannel,AnionChannel},
                Output->Options
            ];
            Lookup[options,AnionBlank],
            {Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],

        Example[{Options,AnionBlank,"Specify a list of negative control compounds to be injected into the anion channel of the instrument:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,AnionBlank],
            {Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlank,"Specify a list of negative control compounds to be injected into the anion channel of the instrument. Input Blank that are not AnionBlank will automatically be resolved as CationBlank:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                AnionBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,CationBlank],
            {Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlank,"Specify a list of negative control compounds to be injected into the anion channel of the instrument. Resolved BlankAnalysisChannel should match Anion/CationBlank specification:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                AnionBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankAnalysisChannel],
            {AnionChannel,CationChannel},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlankFrequency,"Specify the frequency at which AnionBlank measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnRefreshFrequency->None,
                AnionBlankFrequency->FirstAndLast,
                Output->Options
            ];
            First/@Lookup[options,AnionInjectionTable],
            {Blank,Sample,Blank},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlankFrequency,"Specify the frequency at which AnionStandard measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnionColumnRefreshFrequency->None,
                AnionBlankFrequency->1,
                Output->Options
            ];
            First/@Lookup[options,AnionInjectionTable],
            {Blank,Sample,Blank,Sample,Blank,Sample,Blank,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlank,"Specify a list of negative control compounds to be injected into the cation channel of the instrument:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,CationBlank],
            {Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlank,"Specify a list of negative control compounds to be injected into the cation channel of the instrument. Input Blank that are not CationBlank will automatically be resolved as AnionBlank:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"]},
                CationBlank->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                Output->Options
            ];
            Lookup[options,AnionBlank],
            {Model[Sample,"Milli-Q water"]}[Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlankFrequency,"Specify the frequency at which CationBlank measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnRefreshFrequency->None,
                CationBlankFrequency->FirstAndLast,
                Output->Options
            ];
            First/@Lookup[options,CationInjectionTable],
            {Blank,Sample,Blank},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlankFrequency,"Specify the frequency at which CationBlank measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationSamples->{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                CationBlankFrequency->1,
                CationColumnRefreshFrequency->None,
                Output->Options
            ];
            First/@Lookup[options,CationInjectionTable],
            {Blank,Sample,Blank,Sample,Blank,Sample,Blank,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,BlankFrequency,"Specify the frequency at which Blank measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                BlankFrequency->FirstAndLast,
                ColumnRefreshFrequency->None,
                Output->Options
            ];
            First/@Lookup[options,ElectrochemicalInjectionTable],
            {Blank,Sample,Blank},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,BlankFrequency,"Specify the frequency at which Blank measurements will be inserted among samples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                BlankFrequency->1,
                ColumnRefreshFrequency->None,
                Output->Options
            ];
            First/@Lookup[options,ElectrochemicalInjectionTable],
            {Blank,Sample,Blank,Sample,Blank,Sample,Blank,Sample},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlankInjectionVolume,"Specify the physical quantity of each AnionBlank to inject into the system:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->{Model[Sample,"Milli-Q water"]},
                AnionBlankInjectionVolume->{5 Microliter},
                AnionBlankFrequency->First
            ];
            Cases[Download[protocol,AnionInjectionTable],KeyValuePattern[Type->Blank]][[All,4]],
            {5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionBlankInjectionVolume,"If AnionBlankInjectionVolume is not specified, this option should resolve to the first value of AnionInjectionVolume:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionInjectionVolume->2 Microliter,
                AnionBlank->{Model[Sample,"Milli-Q water"]},
                AnionBlankFrequency->First,
                AnionBlankInjectionVolume->Automatic
            ];
            Cases[Download[protocol,AnionInjectionTable],KeyValuePattern[Type->Blank]][[All,4]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankInjectionVolume,"Specify the physical quantity of each CationBlank to inject into the system:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->{Model[Sample,"Milli-Q water"]},
                CationBlankInjectionVolume->{5 Microliter},
                CationBlankFrequency->First
            ];
            Cases[Download[protocol,CationInjectionTable],KeyValuePattern[Type->Blank]][[All,4]],
            {5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationBlankInjectionVolume,"If CationBlankInjectionVolume is not specified, this option should resolve to the first value of CationInjectionVolume:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationInjectionVolume->2 Microliter,
                CationBlank->{Model[Sample,"Milli-Q water"]},
                CationBlankFrequency->First,
                CationBlankInjectionVolume->Automatic
            ];
            Cases[Download[protocol,CationInjectionTable],KeyValuePattern[Type->Blank]][[All,4]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankInjectionVolume,"Specify the physical quantity of each Blank to inject into the electrochemical channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Blank->{Model[Sample,"Milli-Q water"]},
                BlankInjectionVolume->{5 Microliter},
                BlankFrequency->First
            ];
            Cases[Download[protocol,ElectrochemicalInjectionTable],KeyValuePattern[Type->Blank]][[All,3]],
            {5. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankInjectionVolume,"If BlankInjectionVolume is not specified, this option should resolve to the first value of InjectionVolume:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                InjectionVolume->2 Microliter,
                Blank->{Model[Sample,"Milli-Q water"]},
                BlankFrequency->First,
                BlankInjectionVolume->Automatic
            ];
            Cases[Download[protocol,ElectrochemicalInjectionTable],KeyValuePattern[Type->Blank]][[All,3]],
            {2. Microliter},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankColumnTemperature,"Specify the temperature the AnionColumn is held to throughout the AnionBlank run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankColumnTemperature->55 Celsius
            ];
            Download[protocol,AnionBlankColumnTemperature],
            {55. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankColumnTemperature,"AnionBlankColumnTemperature resolves to Null if there is no AnionBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,AnionBlankColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankColumnTemperature,"Specify the temperature the CationColumn is held to throughout the CationBlank run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankColumnTemperature->70 Celsius
            ];
            Download[protocol,CationBlankColumnTemperature],
            {70. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankColumnTemperature,"CationBlankColumnTemperature resolves to Null if there is no CationBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,CationBlankColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankColumnTemperature,"Specify the temperature the Column is held to throughout the Blank run and measurement:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankColumnTemperature->70 Celsius
            ];
            Download[protocol,BlankColumnTemperature],
            {70. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankColumnTemperature,"BlankColumnTemperature resolves to Null if there is no Blank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,BlankColumnTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankEluentGradient,"Specify the concentration of the eluent, potassium hydroxide, that is automatically generated within the flow path for AnionBlank samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->{Model[Sample,"Milli-Q water"]},
                BlankEluentGradient->{{0 Minute,10 Millimolar},{10 Minute,10 Millimolar},{20 Minute,40 Millimolar},
                    {20.1 Minute,40 Millimolar},{30 Minute,10 Millimolar},{35 Minute,10 Millimolar}},
                AnionBlankFrequency->First
            ];
            Download[protocol,BlankEluentGradient],
            {
                {{0 Minute,10 Millimolar},
                    {10 Minute,10 Millimolar},
                    {20 Minute,40 Millimolar},
                    {20.1 Minute,40 Millimolar},
                    {30 Minute,10 Millimolar},
                    {35 Minute,10 Millimolar}}
            },
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,BlankEluentGradient,"Specify an isocratic eluent gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->{Model[Sample,"Milli-Q water"]},
                BlankEluentGradient->50 Millimolar,
                AnionBlankFrequency->Last
            ];
            Download[protocol,BlankEluentGradient],
            {50 Millimolar},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankFlowRate,"Specify the speed of the fluid through the system for AnionBlank samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Blank->{Model[Sample,"Milli-Q water"]},
                AnionBlankFlowRate->0.25 Milliliter/Minute];
            Download[protocol,AnionBlankFlowRate],
            {0.25 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionBlankGradientStart,"Specify a shorthand option for the starting eluent concentration in the fluid flow for anion channel for Standard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                AnionBlankGradientStart->5 Millimolar,
                AnionBlankGradientEnd->50 Millimolar,
                AnionBlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionBlankGradientStart,AnionBlankGradientEnd,AnionBlankGradientDuration}],
            {
                5 Millimolar,50 Millimolar,10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionBlankGradientStart,"Specify a list of index-matched AnionBlankGradientStart:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionBlank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                AnionBlankGradientStart->{5 Millimolar,20 Millimolar},
                AnionBlankGradientEnd->{50 Millimolar,25 Millimolar},
                AnionBlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionBlankGradientStart,AnionBlankGradientEnd,AnionBlankGradientDuration}],
            {
                {5 Millimolar,20 Millimolar},
                {50 Millimolar,25 Millimolar},
                10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionBlankGradientEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                AnionBlankGradientStart->5 Millimolar,
                AnionBlankGradientEnd->55 Millimolar,
                AnionBlankGradientDuration->20 Minute,
                Output->Options
            ];
            Lookup[options,{AnionBlankGradientStart,AnionBlankGradientEnd,AnionBlankGradientDuration}],
            {
                5 Millimolar,55 Millimolar,20 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlankGradientDuration,"Specify a shorthand option for the total time it takes to run the AnionBlank gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Blank->{Model[Sample,"Milli-Q water"]},
                BlankEluentGradient->50 Millimolar,
                AnionBlankGradientDuration->45 Minute
            ];
            First@Last@Last@Download[protocol,AnionBlankGradientMethods][AnionGradient],
            45. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankGradient,"Specify the concentration of the eluent, potassium hydroxide, over time in the fluid flow for AnionBlank samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Blank->Model[Sample,"Milli-Q water"],
                AnionBlankGradient->{
                    {0 Minute,10 Millimolar,0.16 Milliliter/Minute},
                    {10 Minute,10 Millimolar,0.16 Milliliter/Minute},
                    {20 Minute,40 Millimolar,0.16 Milliliter/Minute},
                    {20.1 Minute,40 Millimolar,0.16 Milliliter/Minute},
                    {30 Minute,10 Millimolar,0.16 Milliliter/Minute},
                    {35 Minute,10 Millimolar,0.16 Milliliter/Minute}
                },
                AnionBlankFrequency->First
            ];
            Download[protocol,AnionBlankGradientMethods][AnionGradient],
            {
                {{0. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {10. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {20. Minute,40. Millimolar,0.16 Milliliter/Minute},
                    {20.1 Minute,40. Millimolar,0.16 Milliliter/Minute},
                    {30. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {35. Minute,10. Millimolar,0.16 Milliliter/Minute}}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankGradient,"Specify AnionBlankGradient as a method object:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Blank->Model[Sample,"Milli-Q water"],
                AnionBlankGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                AnionBlankFrequency->Last,
                Output->Options
            ];
            Lookup[options,AnionBlankGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionBlankGradient,"All anion blank related options resolve to Null if there is no AnionBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{AnionBlankColumnTemperature,BlankEluentGradient,AnionBlankFlowRate}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorMode,"Specify the mode of operation for anion suppressor during blank injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionBlankSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorMode,"AnionBlankSuppressorMode automatically resolves to LegacyMode if AnionBlankSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionBlankSuppressorMode],
            {LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorMode,"AnionBlankSuppressorMode automatically resolves to DynamicMode if AnionBlankSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorVoltage->5 Volt
            ];
            Download[protocol,AnionBlankSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorVoltage,"Specify the potential difference across the anion supressor during blank injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorVoltage->3 Volt
            ];
            Download[protocol,AnionBlankSuppressorVoltage],
            {3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorVoltage,"AnionBlankSuppressorVoltage automatically resolves to Null if AnionBlankSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorMode->LegacyMode
            ];
            Download[protocol,AnionBlankSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorCurrent->35 Milliampere
            ];
            Download[protocol,AnionBlankSuppressorCurrent],
            {35. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankSuppressorCurrent,"AnionBlankSuppressorCurrent automatically resolves to Null if AnionBlankSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionBlankSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankDetectionTemperature,"Specify the temperature of the cell where conductivity of the AnionBlank sample is measured:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                AnionBlankDetectionTemperature->25 Celsius
            ];
            Download[protocol,AnionBlankDetectionTemperature],
            {25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankDetectionTemperature,"All anion detection parameters resolve to Null if there's no AnionBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{AnionBlankSuppressorMode,AnionBlankSuppressorVoltage,AnionBlankSuppressorCurrent,AnionBlankDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionBlankDetectionTemperature,"If AnionBlankDetectionTemperature is not specified, it will automatically resolve to the first value of specified AnionDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionDetectionTemperature->35 Celsius,
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,AnionBlankDetectionTemperature],
            {35. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankGradientA,"Specify the composition of Buffer A within the flow for CationBlank as constant percentages:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientA->25 Percent,
                CationBlankGradientB->25 Percent,
                CationBlankGradientC->25 Percent,
                CationBlankGradientD->25 Percent,
                CationBlankFrequency->First
            ];
            Download[protocol,{CationBlankGradientA,CationBlankGradientB,CationBlankGradientC,CationBlankGradientD}],
            {{25 Percent},{25 Percent},{25 Percent},{25 Percent}},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationBlankGradientB,"Specify the composition of Buffer B within the flow in cation channel as a constant percentage for CationBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientA->25 Percent,
                CationBlankGradientB->50 Percent,
                CationBlankGradientC->25 Percent,
                CationBlankGradientD->0 Percent
            ];
            Download[protocol,{CationBlankGradientA,CationBlankGradientB,CationBlankGradientC,CationBlankGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationBlankGradientC,"Specify the composition of Buffer C within the flow in cation channel as a constant percentage for CationBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientA->0 Percent,
                CationBlankGradientB->50 Percent,
                CationBlankGradientC->50 Percent,
                CationBlankGradientD->0 Percent
            ];
            Download[protocol,{CationBlankGradientA,CationBlankGradientB,CationBlankGradientC,CationBlankGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationBlankGradientD,"Specify the composition of Buffer D within the flow in cation channel as a constant percentage for CationBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientA->0 Percent,
                CationBlankGradientB->0 Percent,
                CationBlankGradientC->25 Percent,
                CationBlankGradientD->75 Percent
            ];
            Download[protocol,{CationBlankGradientA,CationBlankGradientB,CationBlankGradientC,CationBlankGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankFlowRate,"Specify the speed of the fluid through the system for CationBlank samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankFlowRate->0.55 Milliliter/Minute
            ];
            Download[protocol,CationBlankFlowRate],
            {0.55 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationBlankGradientStart,"Specify a shorthand option for the starting BufferB concentration in the CationBlank gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlankGradientStart->25 Percent,
                CationBlankGradientEnd->50 Percent,
                CationBlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationBlankGradientStart,CationBlankGradientEnd,CationBlankGradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationBlankGradientEnd,"Specify a shorthand option for the final BufferB concentration in the CationBlank gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientStart->75 Percent,
                CationBlankGradientEnd->50 Percent,
                CationBlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationBlankGradientStart,CationBlankGradientEnd,CationBlankGradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlankGradientDuration,"Specify a shorthand option for the total time it takes to run the CationBlank gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradientA->27 Percent,
                CationBlankGradientDuration->33 Minute
            ];
            First@Last@Last@Download[protocol,CationBlankGradientMethods][CationGradient],
            33. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankGradient,"Specify the buffer composition over time in the fluid flow for CationBlank samples:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,0.25 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,0.25 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,0.25 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,0.25 Milliliter/Minute}
                },
                CationBlankFrequency->First
            ];
            Download[protocol,CationBlankGradientMethods][CationGradient],
            {
                {
                    {0. Minute,25. Percent,50. Percent,25. Percent,0. Percent,0.25 Milliliter/Minute},
                    {0.1 Minute,50. Percent,50. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                    {10. Minute,10. Percent,20. Percent,30. Percent,40. Percent,0.25 Milliliter/Minute},
                    {20. Minute,40. Percent,30. Percent,20. Percent,10. Percent,0.25 Milliliter/Minute},
                    {30. Minute,25. Percent,25. Percent,25. Percent,25. Percent,0.25 Milliliter/Minute}
                }
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankGradient,"Specify CationBlankGradient as a method object:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,CationBlankGradient],
            Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationBlankGradient,"All cation blank related options resolve to Null if there is no CationBlank:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"]
            ];
            Download[protocol,{CationBlankColumnTemperature,CationBlankGradientA,CationBlankGradientB,CationBlankGradientC,CationBlankGradientD,CationBlankFlowRate}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorMode,"Specify the mode of operation for anion suppressor during blank injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorMode->DynamicMode
            ];
            Download[protocol,CationBlankSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorMode,"CationBlankSuppressorMode automatically resolves to LegacyMode if CationBlankSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationBlankSuppressorMode],
            {LegacyMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorMode,"CationBlankSuppressorMode automatically resolves to DynamicMode if CationBlankSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorVoltage->5 Volt
            ];
            Download[protocol,CationBlankSuppressorMode],
            {DynamicMode},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorVoltage,"Specify the potential difference across the anion supressor during blank injections:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorVoltage->3 Volt
            ];
            Download[protocol,CationBlankSuppressorVoltage],
            {3. Volt},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorVoltage,"CationBlankSuppressorVoltage automatically resolves to Null if CationBlankSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorMode->LegacyMode
            ];
            Download[protocol,CationBlankSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationBlankSuppressorCurrent],
            {25. Milliampere},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankSuppressorCurrent,"CationBlankSuppressorCurrent automatically resolves to Null if CationBlankSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankSuppressorMode->DynamicMode
            ];
            Download[protocol,CationBlankSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankDetectionTemperature,"Specify the temperature of the cell where conductivity of the CationBlank sample is measured:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationBlankDetectionTemperature->25 Celsius
            ];
            Download[protocol,CationBlankDetectionTemperature],
            {25. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankDetectionTemperature,"All cation detection parameters resolve to Null if there's no CationBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{CationBlankSuppressorMode,CationBlankSuppressorVoltage,CationBlankSuppressorCurrent,CationBlankDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationBlankDetectionTemperature,"If CationBlankDetectionTemperature is not specified, it will automatically resolve to the first value of specified CationDetectionTemperature:"},
            protocol=ExperimentIonChromatography[ Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationDetectionTemperature->35 Celsius,
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,CationBlankDetectionTemperature],
            {35. Celsius},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankGradientA,"Specify the composition of Buffer A within the flow in electrochemical channel as a constant percentage for Blank:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                BlankAnalysisChannel->ElectrochemicalChannel,
                BlankGradientA->25 Percent,
                BlankGradientB->25 Percent,
                BlankGradientC->25 Percent,
                BlankGradientD->25 Percent
            ];
            Download[protocol,{BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD}],
            {
                {25 Percent},
                {25 Percent},
                {25 Percent},
                {25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankGradientB,"Specify the composition of Buffer B within the flow in electrochemical channel as a constant percentage for Blank:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                BlankAnalysisChannel->ElectrochemicalChannel,
                BlankGradientA->25 Percent,
                BlankGradientB->50 Percent,
                BlankGradientC->25 Percent,
                BlankGradientD->0 Percent
            ];
            Download[protocol,{BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankGradientC,"Specify the composition of Buffer C within the flow in electrochemical channel as a constant percentage for Blank:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                BlankAnalysisChannel->ElectrochemicalChannel,
                BlankGradientA->0 Percent,
                BlankGradientB->50 Percent,
                BlankGradientC->50 Percent,
                BlankGradientD->0 Percent
            ];
            Download[protocol,{BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankGradientD,"Specify the composition of Buffer D within the flow in electrochemical channel as a constant percentage for Blank:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Blank->Model[Sample,"Milli-Q water"],
                BlankAnalysisChannel->ElectrochemicalChannel,
                BlankGradientA->0 Percent,
                BlankGradientB->0 Percent,
                BlankGradientC->25 Percent,
                BlankGradientD->75 Percent
            ];
            Download[protocol,{BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankFlowRate,"Specify the speed of the fluid through the pump for Blanks in electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankFlowRate->0.2 Milliliter/Minute
            ];
            Download[protocol,BlankFlowRate],
            {0.2 Milliliter/Minute},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankGradientStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for Blanks in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankGradientStart->25 Percent,
                BlankGradientEnd->50 Percent,
                BlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{BlankGradientStart,BlankGradientEnd,BlankGradientDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankGradientEnd,"Specify a shorthand option for the final BufferB composition in the fluid flow for Blanks in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankGradientStart->75 Percent,
                BlankGradientEnd->50 Percent,
                BlankGradientDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{BlankGradientStart,BlankGradientEnd,BlankGradientDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankGradientDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for Blanks in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankGradientStart->75 Percent,
                BlankGradientEnd->50 Percent,
                BlankGradientDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{BlankGradientStart,BlankGradientEnd,BlankGradientDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankGradient,"Specify the buffer composition over time in the fluid flow for Blanks in electrochemical channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,BlankGradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankGradient,"Specify BlankGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankGradient->Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,BlankGradient],
            Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankGradient,"All electrochemical gradient options resolve to Null if there are no Blanks in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{BlankGradientA,BlankGradientB,BlankGradientC,BlankGradientD,BlankFlowRate,BlankGradientStart,BlankGradientEnd,BlankGradientDuration,BlankGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceWavelength,"The physical properties of light passed through the flow for the UVVis Detector during Blank run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankAbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceWavelength],
            {500 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceWavelength,"Specifying multiple BlankAbsorbanceWavelengths for an experiment during Blank run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankAbsorbanceWavelength->{{500 Nanometer,280 Nanometer}},
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceWavelength],
            {{500 Nanometer,280 Nanometer}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceWavelength,"If UVVis detector is not used, BlankAbsorbanceWavelength resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceWavelength,"If BlankAbsorbanceSamplingRate is set to Null, BlankAbsorbanceWavelength also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankAbsorbanceSamplingRate->Null,
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceWavelength,"If BlankAbsorbanceWavelength is not specified, it will resolve to the first value of AbsorbanceWavelength:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                AbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceWavelength],
            {500 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceSamplingRate,"Specifying the frequency of absorbance measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankAbsorbanceSamplingRate->50/Second,
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceSamplingRate],
            50/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceSamplingRate,"When multiple BlankAbsorbanceWavelength is specified, BlankAbsorbanceSamplingRate resolves to 1/Second if left unspecified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankAbsorbanceWavelength->{{500 Nanometer,280 Nanometer}},
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceSamplingRate],
            1/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankAbsorbanceSamplingRate,"If UVVis detector is not used, BlankAbsorbanceSamplingRate resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankAbsorbanceSamplingRate],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankElectrochemicalDetectionMode,"Specifies the mode of operation for the electrochemical detector for Blank runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankElectrochemicalDetectionMode->PulsedAmperometricDetection,
                Output->Options
            ];
            Lookup[options,BlankElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankElectrochemicalDetectionMode,"If BlankVoltageProfile is populated, BlankElectrochemicalDetectionMode resolves to DCAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankVoltageProfile->0.2 Volt,
                Output->Options
            ];
            Lookup[options,BlankElectrochemicalDetectionMode],
            DCAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankElectrochemicalDetectionMode,"If BlankWaveformProfile is populated, BlankElectrochemicalDetectionMode resolves to PulsedAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,BlankElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankElectrochemicalDetectionMode,"If electrochemical detector is not used in a protocol, BlankElectrochemicalDetectionMode resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,BlankElectrochemicalDetectionMode],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode during Blank run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankReferenceElectrodeMode->pH,
                Output->Options
            ];
            Lookup[options,BlankReferenceElectrodeMode],
            pH,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode in the generated Waveform object for Blanks:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankReferenceElectrodeMode->pH
            ];
            Download[protocol,BlankWaveformObjects][ReferenceElectrodeMode],
            {pH},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankVoltageProfile,"Specifies the time-dependent voltage setting throughout the measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankVoltageProfile->0.5 Volt,
                Output->Options
            ];
            Lookup[options,BlankVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankVoltageProfile,"Specify VoltageProfile as a list of tuples in the form of {Time, Voltage}...:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankVoltageProfile->{{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
                Output->Options
            ];
            Lookup[options,BlankVoltageProfile],
            {{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankVoltageProfile,"BlankVoltageProfile resolves to Null if WaveformProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,BlankVoltageProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankVoltageProfile,"If BlankVoltageProfile is not specified, it will resolve to the first value of VoltageProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{0.5 Volt,0.1 Volt,0.2 Volt,0.4 Volt},
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the Blank runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            {{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"Specify multiple waveforms that will be repeated over the duration of the Blank runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            {{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"Specify BlankWaveformProfile as a waveform method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"Specify BlankWaveformProfile as multiple waveform method objects:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->{{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}},
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            {{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"New waveform objects will be created and uploaded if BlankWaveformProfile is not specified directly as a method object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}
            ];
            Download[protocol,BlankWaveformObjects],
            {ObjectP[Object[Method,Waveform]]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankWaveformProfile,"If multiple waveforms are used, separate waveform method objects will be uploaded:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}}
            ];
            Download[protocol,BlankWaveformObjects],
            {ObjectP[Object[Method,Waveform]]...},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankWaveformProfile,"BlankWaveformProfile resolves to Null if BlankVoltageProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankVoltageProfile->0.1 Volt,
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankWaveformProfile,"If BlankWaveformProfile is not specified, it will resolve to the first value of WaveformProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankElectrochemicalSamplingRate,"Indicates the frequency of amperometric measurement during Blank runs:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankElectrochemicalSamplingRate->2/Second
            ];
            Download[protocol,BlankElectrochemicalSamplingRate],
            {2./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankElectrochemicalSamplingRate,"BlankElectrochemicalSamplingRate is automatically set based on the specified BlankWaveform:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankWaveformProfile->Object[Method,Waveform,"id:o1k9jAG1DRRa"]
            ];
            Download[protocol,BlankElectrochemicalSamplingRate],
            {1./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,BlankDetectionTemperature,"Specify the temperature of the detection oven where the eletrochemical detection takes place during Blank runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Blank->Model[Sample,"Milli-Q water"],
                BlankDetectionTemperature->30 Celsius,
                Output->Options
            ];
            Lookup[options,BlankDetectionTemperature],
            30 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankDetectionTemperature,"If BlankDetectionTemperature is not specified, it will resolve to the first value of DetectionTemperature:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                DetectionTemperature->29 Celsius,
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,BlankDetectionTemperature],
            29 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankDetectionTemperature,"All Blank electrochemical detector related options resolve to Null if electrochemical detector is not used:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Blank->Model[Sample,"Milli-Q water"],
                Output->Options
            ];
            Lookup[options,{BlankElectrochemicalDetectionMode,BlankReferenceElectrodeMode,BlankVoltageProfile,BlankWaveformProfile,BlankElectrochemicalSamplingRate,BlankDetectionTemperature}],
            {Null...},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,BlankStorageCondition,"Specify the conditions under which any Blank sample used by this experiment should be stored after the protocol is completed. If this option is set to Null when Blank samples are specified, the Blank samples will be stored according to their Models' DefaultStorageCondition:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Blank->{Model[Sample,"Milli-Q water"],Model[Sample,"Milli-Q water"]},
                BlankAnalysisChannel->{AnionChannel,CationChannel},
                BlankStorageCondition->Disposal
            ];
            Download[protocol,BlanksStorageConditions],
            {Disposal,Disposal},
            Variables:>{protocol},
            TimeConstraint->240
        ],
        Example[
            {Options,AnionColumnRefreshFrequency,"Specify the frequency at which procedures to clear out and re-prime the AnionColumn will be inserted into the order of sample injections:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID]},
                AnionColumnRefreshFrequency->FirstAndLast
            ];
            Type/.Download[protocol,AnionInjectionTable],
            {ColumnPrime,Sample,ColumnFlush},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeTemperature,"Specify The temperature the AnionColumn is held to throughout the anion column prime gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeTemperature->55 Celsius
            ];
            Download[protocol,AnionColumnPrimeTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeTemperature,"AnionColumnPrimeTemperature resolves to Null if there is no AnionSamples/AnionStandard/AnionBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,AnionColumnPrimeTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnPrimeEluentGradient,"Specify the concentration of eluent, potassium hydroxide, that is automatically generated within the flow during Anion Column Prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnPrimeEluentGradient->{{0 Minute,10 Millimolar},{10 Minute,50 Millimolar},{30 Minute,50 Millimolar},
                    {40 Minute,10 Millimolar}},
                AnionColumnRefreshFrequency->FirstAndLast
            ];
            Download[protocol,ColumnPrimeEluentGradients],
            {
                {
                    {0 Minute,10 Millimolar},
                    {10 Minute,50 Millimolar},
                    {30 Minute,50 Millimolar},
                    {40 Minute,10 Millimolar}
                }
            },
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnPrimeEluentGradient,"Specify an isocratic eluent gradient for anion column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnPrimeEluentGradient->50 Millimolar
            ];
            Download[protocol,ColumnPrimeEluentGradients],
            {50 Millimolar},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeFlowRate,"Specify the speed of the fluid through the system during anion column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeFlowRate->0.45 Milliliter/Minute];
            (First@Download[protocol,AnionColumnPrimeGradients][AnionGradient])[[All,3]],
            ListableP[0.45 Milliliter/Minute],
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionColumnPrimeStart,"Specify a shorthand option for the starting eluent concentration in the fluid flow for anion channel for Standard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionColumnPrimeStart->5 Millimolar,
                AnionColumnPrimeEnd->50 Millimolar,
                AnionColumnPrimeDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionColumnPrimeStart,AnionColumnPrimeEnd,AnionColumnPrimeDuration}],
            {
                5 Millimolar,50 Millimolar,10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionColumnPrimeEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionColumnPrimeStart->5 Millimolar,
                AnionColumnPrimeEnd->55 Millimolar,
                AnionColumnPrimeDuration->20 Minute,
                Output->Options
            ];
            Lookup[options,{AnionColumnPrimeStart,AnionColumnPrimeEnd,AnionColumnPrimeDuration}],
            {
                5 Millimolar,55 Millimolar,20 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionColumnPrimeDuration,"Specify a shorthand option for the total time it takes to run the AnionColumnPrime gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnPrimeEluentGradient->50 Millimolar,
                AnionColumnPrimeDuration->45 Minute
            ];
            First@Last@Last@Download[protocol,AnionColumnPrimeGradients][AnionGradient],
            45. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeGradient,"Specify the concentration of the eluent, potassium hydroxide, over time in the fluid flow during anion column prime:"},
            protocol=ExperimentIonChromatography[ Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeGradient->{
                    {0 Minute,10 Millimolar,0.16 Milliliter/Minute},
                    {10 Minute,50 Millimolar,0.16 Milliliter/Minute},
                    {30 Minute,50 Millimolar,0.16 Milliliter/Minute},
                    {40 Minute,10 Millimolar,0.16 Milliliter/Minute}
                }
            ];
            Download[protocol,AnionColumnPrimeGradients][AnionGradient],
            {
                {{0. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {10. Minute,50. Millimolar,0.16 Milliliter/Minute},
                    {30. Minute,50. Millimolar,0.16 Milliliter/Minute},
                    {40. Minute,10. Millimolar,0.16 Milliliter/Minute}}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeGradient,"Specify AnionColumnPrimeGradient as a method object:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]
            ];
            Download[protocol,AnionColumnPrimeGradients][Object],
            {Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeGradient,"All anion column prime related options resolve to Null if anion column is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{AnionColumnPrimeTemperature,ColumnPrimeEluentGradients,AnionColumnPrimeGradients}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorMode,"Specify the mode of operation for anion suppressor during anion column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionColumnPrimeSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorMode,"AnionColumnPrimeSuppressorMode automatically resolves to LegacyMode if AnionColumnPrimeSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorCurrent->70 Milliampere
            ];
            Download[protocol,AnionColumnPrimeSuppressorMode],
            LegacyMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorMode,"AnionColumnPrimeSuppressorMode automatically resolves to DynamicMode if AnionColumnPrimeSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorVoltage->5 Volt
            ];
            Download[protocol,AnionColumnPrimeSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorVoltage,"Specify the potential difference across the anion supressor during column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorVoltage->3 Volt
            ];
            Download[protocol,AnionColumnPrimeSuppressorVoltage],
            3. Volt,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorVoltage,"AnionColumnPrimeSuppressorVoltage automatically resolves to Null if AnionColumnPrimeSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorMode->LegacyMode
            ];
            Download[protocol,AnionColumnPrimeSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel during column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorCurrent->70 Milliampere
            ];
            Download[protocol,AnionColumnPrimeSuppressorCurrent],
            70. Milliampere,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeSuppressorCurrent,"AnionColumnPrimeSuppressorCurrent automatically resolves to Null if AnionColumnPrimeSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionColumnPrimeSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeDetectionTemperature,"Specify the temperature of the conductivity cell during anion column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnPrimeDetectionTemperature->25 Celsius
            ];
            Download[protocol,AnionColumnPrimeDetectionTemperature],
            25. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeDetectionTemperature,"All anion detection parameters resolve to Null if there's no anion column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnRefreshFrequency->None
            ];
            Download[protocol,{AnionColumnPrimeSuppressorMode,AnionColumnPrimeSuppressorVoltage,AnionColumnPrimeSuppressorCurrent,AnionColumnPrimeDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnPrimeDetectionTemperature,"If AnionColumnPrimeDetectionTemperature is not specified, it will automatically resolve to the first value of specified AnionDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionDetectionTemperature->35 Celsius
            ];
            Download[protocol,AnionColumnPrimeDetectionTemperature],
            35. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnRefreshFrequency,"Specify the frequency at which procedures to clear out and re-prime the CationColumn will be inserted into the order of sample injections:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                CationColumnRefreshFrequency->FirstAndLast
            ];
            Type/.Download[protocol,CationInjectionTable],
            {ColumnPrime,Sample,ColumnFlush},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeTemperature,"Specify The temperature the CationColumn is held to throughout the cation column prime gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeTemperature->55 Celsius
            ];
            Download[protocol,CationColumnPrimeTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeTemperature,"CationColumnPrimeTemperature resolves to Null if there is no CationSamples/CationStandard/CationBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,CationColumnPrimeTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeGradientA,"Specify the composition of Buffer A within the flow during column prime as constant percentages:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnPrimeGradientA->25 Percent,
                CationColumnPrimeGradientB->25 Percent,
                CationColumnPrimeGradientC->25 Percent,
                CationColumnPrimeGradientD->25 Percent
            ];
            Download[protocol,{CationColumnPrimeGradientA,CationColumnPrimeGradientB,CationColumnPrimeGradientC,CationColumnPrimeGradientD}],
            {{25 Percent},{25 Percent},{25 Percent},{25 Percent}},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnPrimeGradientB,"Specify the composition of Buffer B within the flow in cation channel as a constant percentage for CationColumnPrime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnPrimeGradientA->25 Percent,
                CationColumnPrimeGradientB->50 Percent,
                CationColumnPrimeGradientC->25 Percent,
                CationColumnPrimeGradientD->0 Percent
            ];
            Download[protocol,{CationColumnPrimeGradientA,CationColumnPrimeGradientB,CationColumnPrimeGradientC,CationColumnPrimeGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnPrimeGradientC,"Specify the composition of Buffer C within the flow in cation channel as a constant percentage for CationColumnPrime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnPrimeGradientA->0 Percent,
                CationColumnPrimeGradientB->50 Percent,
                CationColumnPrimeGradientC->50 Percent,
                CationColumnPrimeGradientD->0 Percent
            ];
            Download[protocol,{CationColumnPrimeGradientA,CationColumnPrimeGradientB,CationColumnPrimeGradientC,CationColumnPrimeGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnPrimeGradientD,"Specify the composition of Buffer D within the flow in cation channel as a constant percentage for CationColumnPrime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnPrimeGradientA->0 Percent,
                CationColumnPrimeGradientB->0 Percent,
                CationColumnPrimeGradientC->25 Percent,
                CationColumnPrimeGradientD->75 Percent
            ];
            Download[protocol,{CationColumnPrimeGradientA,CationColumnPrimeGradientB,CationColumnPrimeGradientC,CationColumnPrimeGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeFlowRate,"Specify the speed of the fluid through the system during cation column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeFlowRate->0.55 Milliliter/Minute
            ];
            (First@Download[protocol,CationColumnPrimeGradients][CationGradient])[[All,6]],
            ListableP[0.55 Milliliter/Minute],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnPrimeStart,"Specify a shorthand option for the starting BufferB concentration in the CationColumnPrime gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeStart->25 Percent,
                CationColumnPrimeEnd->50 Percent,
                CationColumnPrimeDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationColumnPrimeStart,CationColumnPrimeEnd,CationColumnPrimeDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationColumnPrimeEnd,"Specify a shorthand option for the final BufferB concentration in the CationColumnPrime gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeStart->75 Percent,
                CationColumnPrimeEnd->50 Percent,
                CationColumnPrimeDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationColumnPrimeStart,CationColumnPrimeEnd,CationColumnPrimeDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationColumnPrimeDuration,"Specify a shorthand option for the total time it takes to run the CationColumnPrime gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeGradientA->27 Percent,
                CationColumnPrimeDuration->33 Minute
            ];
            First@Last@Last@Download[protocol,CationColumnPrimeGradients][CationGradient],
            33. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeGradient,"Specify the buffer composition over time in the fluid flow during cation column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeGradient->{
                    {0 Minute,100 Percent,0 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {10 Minute,0 Percent,100 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {20 Minute,0 Percent,0 Percent,100 Percent,0 Percent,0.25 Milliliter/Minute},
                    {30 Minute,0 Percent,0 Percent,0 Percent,100 Percent,0.25 Milliliter/Minute},
                    {40 Minute,0 Percent,0 Percent,0 Percent,100 Percent,0.25 Milliliter/Minute}
                },
                CationColumnRefreshFrequency->FirstAndLast
            ];
            Download[protocol,CationColumnPrimeGradients][CationGradient],
            {
                {
                    {0. Minute,100. Percent,0. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                    {10. Minute,0. Percent,100. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                    {20. Minute,0. Percent,0. Percent,100. Percent,0. Percent,0.25 Milliliter/Minute},
                    {30. Minute,0. Percent,0. Percent,0. Percent,100. Percent,0.25 Milliliter/Minute},
                    {40. Minute,0. Percent,0. Percent,0. Percent,100. Percent,0.25 Milliliter/Minute}
                }
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeGradient,"Specify CationColumnPrimeGradient as a method object:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]
            ];
            Download[protocol,CationColumnPrimeGradients][Object],
            {Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeGradient,"All cation column prime related options resolve to Null if CationColumn is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{CationColumnPrimeTemperature,ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorMode,"Specify the mode of operation for cation suppressor during cation column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorMode->DynamicMode
            ];
            Download[protocol,CationColumnPrimeSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorMode,"CationColumnPrimeSuppressorMode automatically resolves to LegacyMode if CationColumnPrimeSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationColumnPrimeSuppressorMode],
            LegacyMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorMode,"CationColumnPrimeSuppressorMode automatically resolves to DynamicMode if CationColumnPrimeSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorVoltage->5 Volt
            ];
            Download[protocol,CationColumnPrimeSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorVoltage,"Specify the potential difference across the cation supressor during column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorVoltage->3 Volt
            ];
            Download[protocol,CationColumnPrimeSuppressorVoltage],
            3. Volt,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorVoltage,"CationColumnPrimeSuppressorVoltage automatically resolves to Null if CationColumnPrimeSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorMode->LegacyMode
            ];
            Download[protocol,CationColumnPrimeSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in cation channel during column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationColumnPrimeSuppressorCurrent],
            25. Milliampere,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeSuppressorCurrent,"CationColumnPrimeSuppressorCurrent automatically resolves to Null if CationColumnPrimeSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeSuppressorMode->DynamicMode
            ];
            Download[protocol,CationColumnPrimeSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeDetectionTemperature,"Specify the temperature of the conductivity cell during cation column prime:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnPrimeDetectionTemperature->25 Celsius
            ];
            Download[protocol,CationColumnPrimeDetectionTemperature],
            25. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeDetectionTemperature,"All cation detection parameters resolve to Null if CationColumn is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                CationColumnRefreshFrequency->None
            ];
            Download[protocol,{CationColumnPrimeSuppressorMode,CationColumnPrimeSuppressorVoltage,CationColumnPrimeSuppressorCurrent,CationColumnPrimeDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnPrimeDetectionTemperature,"If CationColumnPrimeDetectionTemperature is not specified, it will automatically resolve to the first value of specified CationDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationDetectionTemperature->35 Celsius
            ];
            Download[protocol,CationColumnPrimeDetectionTemperature],
            35. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnRefreshFrequency,"Specify the frequency at which procedures to clear out and re-prime the Column will be inserted into the order of sample injections:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnRefreshFrequency->FirstAndLast
            ];
            Type/.Download[protocol,ElectrochemicalInjectionTable],
            {ColumnPrime,Sample,ColumnFlush},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnPrimeTemperature,"Specify The temperature the Column is held to throughout the column prime gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeTemperature->55 Celsius
            ];
            Download[protocol,ColumnPrimeTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnPrimeTemperature,"ColumnPrimeTemperature resolves to Null if there is no Samples/Standard/Blanks for electrochemical channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,ColumnPrimeTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeGradientA,"Specify the composition of Buffer A within the flow in electrochemical channel as a constant percentage for ColumnPrime:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradientA->25 Percent,
                ColumnPrimeGradientB->25 Percent,
                ColumnPrimeGradientC->25 Percent,
                ColumnPrimeGradientD->25 Percent
            ];
            Download[protocol,{ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD}],
            {
                {25 Percent},
                {25 Percent},
                {25 Percent},
                {25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeGradientB,"Specify the composition of Buffer B within the flow in electrochemical channel as a constant percentage for ColumnPrime:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradientA->25 Percent,
                ColumnPrimeGradientB->50 Percent,
                ColumnPrimeGradientC->25 Percent,
                ColumnPrimeGradientD->0 Percent
            ];
            Download[protocol,{ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeGradientC,"Specify the composition of Buffer C within the flow in electrochemical channel as a constant percentage for ColumnPrime:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradientA->0 Percent,
                ColumnPrimeGradientB->50 Percent,
                ColumnPrimeGradientC->50 Percent,
                ColumnPrimeGradientD->0 Percent
            ];
            Download[protocol,{ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeGradientD,"Specify the composition of Buffer D within the flow in electrochemical channel as a constant percentage for ColumnPrime:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradientA->0 Percent,
                ColumnPrimeGradientB->0 Percent,
                ColumnPrimeGradientC->25 Percent,
                ColumnPrimeGradientD->75 Percent
            ];
            Download[protocol,{ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeFlowRate,"Specify the speed of the fluid through the pump for ColumnPrime in electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeFlowRate->0.2 Milliliter/Minute
            ];
            First@(First[Download[protocol,ColumnPrimeGradients]][Gradient][[All,-1]]),
            0.2 Milliliter/Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for ColumnPrime in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeStart->25 Percent,
                ColumnPrimeEnd->50 Percent,
                ColumnPrimeDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnPrimeStart,ColumnPrimeEnd,ColumnPrimeDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeEnd,"Specify a shorthand option for the final BufferB composition in the fluid flow for ColumnPrime in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeStart->75 Percent,
                ColumnPrimeEnd->50 Percent,
                ColumnPrimeDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnPrimeStart,ColumnPrimeEnd,ColumnPrimeDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for ColumnPrime in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeStart->75 Percent,
                ColumnPrimeEnd->50 Percent,
                ColumnPrimeDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnPrimeStart,ColumnPrimeEnd,ColumnPrimeDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeGradient,"Specify the buffer composition over time in the fluid flow for ColumnPrime in electrochemical channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,ColumnPrimeGradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeGradient,"Specify ColumnPrimeGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeGradient->Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnPrimeGradient],
            Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeGradient,"All electrochemical gradient options resolve to Null if there are no ColumnPrime in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD,ColumnPrimeFlowRate,ColumnPrimeStart,ColumnPrimeEnd,ColumnPrimeDuration,ColumnPrimeGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceWavelength,"The physical properties of light passed through the flow for the UVVis Detector during ColumnPrime run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeAbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceWavelength],
            500 Nanometer,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceWavelength,"Specifying multiple ColumnPrimeAbsorbanceWavelengths for an experiment during ColumnPrime run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeAbsorbanceWavelength->{500 Nanometer,280 Nanometer},
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceWavelength],
            {500 Nanometer,280 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceWavelength,"If UVVis detector is not used, ColumnPrimeAbsorbanceWavelength resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceWavelength,"If ColumnPrimeAbsorbanceSamplingRate is set to Null, ColumnPrimeAbsorbanceWavelength also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeAbsorbanceSamplingRate->Null,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceWavelength,"If ColumnPrimeAbsorbanceWavelength is not specified, it will resolve to the first value of AbsorbanceWavelength:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceWavelength],
            500 Nanometer,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceSamplingRate,"Specifying the frequency of absorbance measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeAbsorbanceSamplingRate->50/Second,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceSamplingRate],
            50/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceSamplingRate,"When multiple ColumnPrimeAbsorbanceWavelength is specified, ColumnPrimeAbsorbanceSamplingRate resolves to 1/Second if left unspecified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeAbsorbanceWavelength->{500 Nanometer,280 Nanometer},
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceSamplingRate],
            1/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeAbsorbanceSamplingRate,"If UVVis detector is not used, ColumnPrimeAbsorbanceSamplingRate resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,ColumnPrimeAbsorbanceSamplingRate],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalDetectionMode,"Specifies the mode of operation for the electrochemical detector for ColumnPrime runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeElectrochemicalDetectionMode->PulsedAmperometricDetection,
                Output->Options
            ];
            Lookup[options,ColumnPrimeElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalDetectionMode,"If ColumnPrimeVoltageProfile is populated, ColumnPrimeElectrochemicalDetectionMode resolves to DCAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeVoltageProfile->0.2 Volt,
                Output->Options
            ];
            Lookup[options,ColumnPrimeElectrochemicalDetectionMode],
            DCAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalDetectionMode,"If ColumnPrimeWaveformProfile is populated, ColumnPrimeElectrochemicalDetectionMode resolves to PulsedAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnPrimeElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalDetectionMode,"If electrochemical detector is not used in a protocol, ColumnPrimeElectrochemicalDetectionMode resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,ColumnPrimeElectrochemicalDetectionMode],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode during ColumnPrime run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeReferenceElectrodeMode->pH,
                Output->Options
            ];
            Lookup[options,ColumnPrimeReferenceElectrodeMode],
            pH,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode in the generated Waveform object for ColumnPrime:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeReferenceElectrodeMode->pH
            ];
            Download[protocol,ColumnPrimeWaveformObjects][ReferenceElectrodeMode],
            {pH},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeVoltageProfile,"Specifies the time-dependent voltage setting throughout the measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeVoltageProfile->0.5 Volt,
                Output->Options
            ];
            Lookup[options,ColumnPrimeVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeVoltageProfile,"Specify VoltageProfile as a list of tuples in the form of {Time, Voltage}...:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeVoltageProfile->{{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
                Output->Options
            ];
            Lookup[options,ColumnPrimeVoltageProfile],
            {{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeVoltageProfile,"ColumnPrimeVoltageProfile resolves to Null if WaveformProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnPrimeVoltageProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeVoltageProfile,"If ColumnPrimeVoltageProfile is not specified, it will resolve to the first value of VoltageProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{0.5 Volt,0.1 Volt,0.2 Volt,0.4 Volt},
                Output->Options
            ];
            Lookup[options,ColumnPrimeVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the ColumnPrime runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            {{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"Specify multiple waveforms that will be repeated over the duration of the ColumnPrime runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            {{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"Specify ColumnPrimeWaveformProfile as a waveform method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"Specify ColumnPrimeWaveformProfile as multiple waveform method objects:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}},
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            {{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"New waveform objects will be created and uploaded if ColumnPrimeWaveformProfile is not specified directly as a method object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}
            ];
            Download[protocol,ColumnPrimeWaveformObjects],
            {ObjectP[Object[Method,Waveform]]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"If multiple waveforms are used, separate waveform method objects will be uploaded:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}}
            ];
            Download[protocol,ColumnPrimeWaveformObjects],
            {ObjectP[Object[Method,Waveform]]...},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"ColumnPrimeWaveformProfile resolves to Null if ColumnPrimeVoltageProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeVoltageProfile->0.1 Volt,
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeWaveformProfile,"If ColumnPrimeWaveformProfile is not specified, it will resolve to the first value of WaveformProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnPrimeWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalSamplingRate,"Indicates the frequency of amperometric measurement during ColumnPrime runs:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeElectrochemicalSamplingRate->2/Second
            ];
            Download[protocol,ColumnPrimeElectrochemicalSamplingRate],
            {2./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeElectrochemicalSamplingRate,"ColumnPrimeElectrochemicalSamplingRate is automatically set based on the specified ColumnPrimeWaveform:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeWaveformProfile->Object[Method,Waveform,"id:o1k9jAG1DRRa"]
            ];
            Download[protocol,ColumnPrimeElectrochemicalSamplingRate],
            {1./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnPrimeDetectionTemperature,"Specify the temperature of the detection oven where the eletrochemical detection takes place during ColumnPrime runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnPrimeDetectionTemperature->30 Celsius,
                Output->Options
            ];
            Lookup[options,ColumnPrimeDetectionTemperature],
            30 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeDetectionTemperature,"If ColumnPrimeDetectionTemperature is not specified, it will resolve to the first value of DetectionTemperature:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                DetectionTemperature->29 Celsius,
                Output->Options
            ];
            Lookup[options,ColumnPrimeDetectionTemperature],
            29 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnPrimeDetectionTemperature,"All ColumnPrime electrochemical detector related options resolve to Null if electrochemical detector is not used:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,{ColumnPrimeElectrochemicalDetectionMode,ColumnPrimeReferenceElectrodeMode,ColumnPrimeVoltageProfile,ColumnPrimeWaveformProfile,ColumnPrimeElectrochemicalSamplingRate,ColumnPrimeDetectionTemperature}],
            {Null...},
            TimeConstraint->240,
            Variables:>{options}
        ],

        Example[{Options,AnionColumnFlushTemperature,"Specify the temperature the AnionColumn is held to throughout the anion column flush gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushTemperature->55 Celsius
            ];
            Download[protocol,AnionColumnFlushTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushTemperature,"AnionColumnFlushTemperature resolves to Null if there is no AnionSamples/AnionStandard/AnionBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,AnionColumnFlushTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnFlushEluentGradient,"Specify the concentration of eluent, potassium hydroxide, that is automatically generated within the flow during AnionColumn Flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnFlushEluentGradient->{{0 Minute,10 Millimolar},{10 Minute,50 Millimolar},{30 Minute,50 Millimolar},
                    {40 Minute,10 Millimolar}}
            ];
            Download[protocol,ColumnFlushEluentGradients],
            {
                {{0 Minute,10 Millimolar},
                    {10 Minute,50 Millimolar},
                    {30 Minute,50 Millimolar},
                    {40 Minute,10 Millimolar}}
            },
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnFlushEluentGradient,"Specify an isocratic eluent gradient for anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnFlushEluentGradient->50 Millimolar
            ];
            Download[protocol,ColumnFlushEluentGradients],
            {50 Millimolar},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushFlowRate,"Specify the speed of the fluid through the system during anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushFlowRate->0.45 Milliliter/Minute];
            (First@Download[protocol,AnionColumnFlushGradients][AnionGradient])[[All,3]],
            ListableP[0.45 Milliliter/Minute],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,AnionColumnFlushStart,"Specify a shorthand option for the starting eluent concentration in the fluid flow for anion channel for Standard:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionColumnFlushStart->5 Millimolar,
                AnionColumnFlushEnd->50 Millimolar,
                AnionColumnFlushDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{AnionColumnFlushStart,AnionColumnFlushEnd,AnionColumnFlushDuration}],
            {
                5 Millimolar,50 Millimolar,10 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,AnionColumnFlushEnd,"Specify a shorthand option for the final eluent concentration in the fluid flow for anion channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnionColumnFlushStart->5 Millimolar,
                AnionColumnFlushEnd->55 Millimolar,
                AnionColumnFlushDuration->20 Minute,
                Output->Options
            ];
            Lookup[options,{AnionColumnFlushStart,AnionColumnFlushEnd,AnionColumnFlushDuration}],
            {
                5 Millimolar,55 Millimolar,20 Minute
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnionColumnFlushDuration,"Specify a shorthand option for the total time it takes to run the AnionColumnFlush gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ColumnFlushEluentGradient->50 Millimolar,
                AnionColumnFlushDuration->45 Minute
            ];
            First@Last@Last@Download[protocol,AnionColumnFlushGradients][AnionGradient],
            45. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushGradient,"Specify the concentration of the eluent, potassium hydroxide, over time in the fluid flow during anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushGradient->{
                    {0 Minute,10 Millimolar,0.16 Milliliter/Minute},
                    {10 Minute,50 Millimolar,0.16 Milliliter/Minute},
                    {30 Minute,50 Millimolar,0.16 Milliliter/Minute},
                    {40 Minute,10 Millimolar,0.16 Milliliter/Minute}
                }
            ];
            Download[protocol,AnionColumnFlushGradients][AnionGradient],
            {
                {{0. Minute,10. Millimolar,0.16 Milliliter/Minute},
                    {10. Minute,50. Millimolar,0.16 Milliliter/Minute},
                    {30. Minute,50. Millimolar,0.16 Milliliter/Minute},
                    {40. Minute,10. Millimolar,0.16 Milliliter/Minute}}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushGradient,"Specify AnionColumnFlushGradient as a method object:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID]
            ];
            Download[protocol,AnionColumnFlushGradients][Object],
            {Object[Method,IonChromatographyGradient,"ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID][Object]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushGradient,"All anion column flush related options resolve to Null if anion column is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationStandard->Model[Sample,"Multi Cation Standard 1 for IC"],
                CationBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{AnionColumnFlushTemperature,ColumnFlushEluentGradients,AnionColumnFlushGradients}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorMode,"Specify the mode of operation for anion suppressor during anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionColumnFlushSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorMode,"AnionColumnFlushSuppressorMode automatically resolves to LegacyMode if AnionColumnFlushSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorCurrent->70 Milliampere
            ];
            Download[protocol,AnionColumnFlushSuppressorMode],
            LegacyMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorMode,"AnionColumnFlushSuppressorMode automatically resolves to DynamicMode if AnionColumnFlushSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorVoltage->5 Volt
            ];
            Download[protocol,AnionColumnFlushSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorVoltage,"Specify the potential difference across the anion supressor during column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorVoltage->3 Volt
            ];
            Download[protocol,AnionColumnFlushSuppressorVoltage],
            3. Volt,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorVoltage,"AnionColumnFlushSuppressorVoltage automatically resolves to Null if AnionColumnFlushSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorMode->LegacyMode
            ];
            Download[protocol,AnionColumnFlushSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in anion channel during column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorCurrent->70 Milliampere
            ];
            Download[protocol,AnionColumnFlushSuppressorCurrent],
            70. Milliampere,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushSuppressorCurrent,"AnionColumnFlushSuppressorCurrent automatically resolves to Null if AnionColumnFlushSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushSuppressorMode->DynamicMode
            ];
            Download[protocol,AnionColumnFlushSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushDetectionTemperature,"Specify the temperature of the conductivity cell during anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnFlushDetectionTemperature->25 Celsius
            ];
            Download[protocol,AnionColumnFlushDetectionTemperature],
            25. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushDetectionTemperature,"All anion detection parameters resolve to Null if there's no anion column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionColumnRefreshFrequency->None
            ];
            Download[protocol,{AnionColumnFlushSuppressorMode,AnionColumnFlushSuppressorVoltage,AnionColumnFlushSuppressorCurrent,AnionColumnFlushDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,AnionColumnFlushDetectionTemperature,"If AnionColumnFlushDetectionTemperature is not specified, it will automatically resolve to the first value of specified AnionDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionDetectionTemperature->35 Celsius
            ];
            Download[protocol,AnionColumnFlushDetectionTemperature],
            35. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        Example[{Options,CationColumnFlushTemperature,"Specify The temperature the CationColumn is held to throughout the cation column flush gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushTemperature->55 Celsius
            ];
            Download[protocol,CationColumnFlushTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushTemperature,"CationColumnFlushTemperature resolves to Null if there is no CationSamples/CationStandard/CationBlanks:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,CationColumnFlushTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushGradientA,"Specify the composition of Buffer A within the flow during column prime as constant percentages:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnFlushGradientA->25 Percent,
                CationColumnFlushGradientB->25 Percent,
                CationColumnFlushGradientC->25 Percent,
                CationColumnFlushGradientD->25 Percent
            ];
            Download[protocol,{CationColumnFlushGradientA,CationColumnFlushGradientB,CationColumnFlushGradientC,CationColumnFlushGradientD}],
            {{25 Percent},{25 Percent},{25 Percent},{25 Percent}},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnFlushGradientB,"Specify the composition of Buffer B within the flow in cation channel as a constant percentage for CationColumnFlush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnFlushGradientA->25 Percent,
                CationColumnFlushGradientB->50 Percent,
                CationColumnFlushGradientC->25 Percent,
                CationColumnFlushGradientD->0 Percent
            ];
            Download[protocol,{CationColumnFlushGradientA,CationColumnFlushGradientB,CationColumnFlushGradientC,CationColumnFlushGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnFlushGradientC,"Specify the composition of Buffer C within the flow in cation channel as a constant percentage for CationColumnFlush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnFlushGradientA->0 Percent,
                CationColumnFlushGradientB->50 Percent,
                CationColumnFlushGradientC->50 Percent,
                CationColumnFlushGradientD->0 Percent
            ];
            Download[protocol,{CationColumnFlushGradientA,CationColumnFlushGradientB,CationColumnFlushGradientC,CationColumnFlushGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnFlushGradientD,"Specify the composition of Buffer D within the flow in cation channel as a constant percentage for CationColumnFlush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationBlank->Model[Sample,"Milli-Q water"],
                CationColumnFlushGradientA->0 Percent,
                CationColumnFlushGradientB->0 Percent,
                CationColumnFlushGradientC->25 Percent,
                CationColumnFlushGradientD->75 Percent
            ];
            Download[protocol,{CationColumnFlushGradientA,CationColumnFlushGradientB,CationColumnFlushGradientC,CationColumnFlushGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushFlowRate,"Specify the speed of the fluid through the system during cation column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushFlowRate->0.55 Milliliter/Minute
            ];
            (First@Download[protocol,CationColumnFlushGradients][CationGradient])[[All,6]],
            ListableP[0.55 Milliliter/Minute],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,CationColumnFlushStart,"Specify a shorthand option for the starting BufferB concentration in the CationColumnFlush gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushStart->25 Percent,
                CationColumnFlushEnd->50 Percent,
                CationColumnFlushDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationColumnFlushStart,CationColumnFlushEnd,CationColumnFlushDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,CationColumnFlushEnd,"Specify a shorthand option for the final BufferB concentration in the CationColumnFlush gradient:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushStart->75 Percent,
                CationColumnFlushEnd->50 Percent,
                CationColumnFlushDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{CationColumnFlushStart,CationColumnFlushEnd,CationColumnFlushDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,CationColumnFlushDuration,"Specify a shorthand option for the total time it takes to run the CationColumnFlush gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushGradientA->27 Percent,
                CationColumnFlushDuration->33 Minute
            ];
            First@Last@Last@Download[protocol,CationColumnFlushGradients][CationGradient],
            33. Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushGradient,"Specify the buffer composition over time in the fluid flow during cation column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushGradient->{
                    {0 Minute,100 Percent,0 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {10 Minute,0 Percent,100 Percent,0 Percent,0 Percent,0.25 Milliliter/Minute},
                    {20 Minute,0 Percent,0 Percent,100 Percent,0 Percent,0.25 Milliliter/Minute},
                    {30 Minute,0 Percent,0 Percent,0 Percent,100 Percent,0.25 Milliliter/Minute},
                    {40 Minute,0 Percent,0 Percent,0 Percent,100 Percent,0.25 Milliliter/Minute}
                }
            ];
            Download[protocol,CationColumnFlushGradients][CationGradient],
            {
                {{0. Minute,100. Percent,0. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                    {10. Minute,0. Percent,100. Percent,0. Percent,0. Percent,0.25 Milliliter/Minute},
                    {20. Minute,0. Percent,0. Percent,100. Percent,0. Percent,0.25 Milliliter/Minute},
                    {30. Minute,0. Percent,0. Percent,0. Percent,100. Percent,0.25 Milliliter/Minute},
                    {40. Minute,0. Percent,0. Percent,0. Percent,100. Percent,0.25 Milliliter/Minute}}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushGradient,"Specify CationColumnFlushGradient as a method object:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushGradient->Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID]
            ];
            Download[protocol,CationColumnFlushGradients][Object],
            {Object[Method,IonChromatographyGradient,"ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID][Object]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushGradient,"All cation column flush related options resolve to Null if CationColumn is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,{CationColumnFlushTemperature,ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD}],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorMode,"Specify the mode of operation for cation suppressor during cation column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorMode->DynamicMode
            ];
            Download[protocol,CationColumnFlushSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorMode,"CationColumnFlushSuppressorMode automatically resolves to LegacyMode if CationColumnFlushSuppressorCurrent is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationColumnFlushSuppressorMode],
            LegacyMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorMode,"CationColumnFlushSuppressorMode automatically resolves to DynamicMode if CationColumnFlushSuppressorVoltage is specified:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorVoltage->5 Volt
            ];
            Download[protocol,CationColumnFlushSuppressorMode],
            DynamicMode,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorVoltage,"Specify the potential difference across the cation supressor during column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorVoltage->3 Volt
            ];
            Download[protocol,CationColumnFlushSuppressorVoltage],
            3. Volt,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorVoltage,"CationColumnFlushSuppressorVoltage automatically resolves to Null if CationColumnFlushSuppressorMode is LegacyMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorMode->LegacyMode
            ];
            Download[protocol,CationColumnFlushSuppressorVoltage],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorCurrent,"Specify the electrical current supplied to the suppressor module in cation channel during column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorCurrent->25 Milliampere
            ];
            Download[protocol,CationColumnFlushSuppressorCurrent],
            25. Milliampere,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushSuppressorCurrent,"CationColumnFlushSuppressorCurrent automatically resolves to Null if CationColumnFlushSuppressorMode is DynamicMode:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushSuppressorMode->DynamicMode
            ];
            Download[protocol,CationColumnFlushSuppressorCurrent],
            ListableP[Null|{}|{Null}],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushDetectionTemperature,"Specify the temperature of the conductivity cell during cation column flush:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationColumnFlushDetectionTemperature->25 Celsius
            ];
            Download[protocol,CationColumnFlushDetectionTemperature],
            25. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,CationColumnFlushDetectionTemperature,"All cation detection parameters resolve to Null if CationColumn is not used:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionBlank->Model[Sample,"Milli-Q water"],
                CationColumnRefreshFrequency->None
            ];
            Download[protocol,{CationColumnFlushSuppressorMode,CationColumnFlushSuppressorVoltage,CationColumnFlushSuppressorCurrent,CationColumnFlushDetectionTemperature}],
            ListableP[Null|{}|{Null}],
            Variables:>{protocol},
            TimeConstraint->300
        ],
        Example[{Options,CationColumnFlushDetectionTemperature,"If CationColumnFlushDetectionTemperature is not specified, it will automatically resolve to the first value of specified CationDetectionTemperature:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                CationDetectionTemperature->35 Celsius
            ];
            Download[protocol,CationColumnFlushDetectionTemperature],
            35. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnFlushTemperature,"Specify The temperature the Column is held to throughout the column flush gradient:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushTemperature->55 Celsius
            ];
            Download[protocol,ColumnFlushTemperature],
            55. Celsius,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ColumnFlushTemperature,"ColumnFlushTemperature resolves to Null if there is no Samples/Standard/Blanks for electrochemical channel:"},
            protocol=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnionStandard->Model[Sample,"Multielement Ion Chromatography Anion Standard Solution"],
                AnionBlank->Model[Sample,"Milli-Q water"]
            ];
            Download[protocol,ColumnFlushTemperature],
            Null|{},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushGradientA,"Specify the composition of Buffer A within the flow in electrochemical channel as a constant percentage for ColumnFlush:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradientA->25 Percent,
                ColumnFlushGradientB->25 Percent,
                ColumnFlushGradientC->25 Percent,
                ColumnFlushGradientD->25 Percent
            ];
            Download[protocol,{ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD}],
            {
                {25 Percent},
                {25 Percent},
                {25 Percent},
                {25 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushGradientB,"Specify the composition of Buffer B within the flow in electrochemical channel as a constant percentage for ColumnFlush:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradientA->25 Percent,
                ColumnFlushGradientB->50 Percent,
                ColumnFlushGradientC->25 Percent,
                ColumnFlushGradientD->0 Percent
            ];
            Download[protocol,{ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD}],
            {
                {25 Percent},
                {50 Percent},
                {25 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushGradientC,"Specify the composition of Buffer C within the flow in electrochemical channel as a constant percentage for ColumnFlush:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradientA->0 Percent,
                ColumnFlushGradientB->50 Percent,
                ColumnFlushGradientC->50 Percent,
                ColumnFlushGradientD->0 Percent
            ];
            Download[protocol,{ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD}],
            {
                {0 Percent},
                {50 Percent},
                {50 Percent},
                {0 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushGradientD,"Specify the composition of Buffer D within the flow in electrochemical channel as a constant percentage for ColumnFlush:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradientA->0 Percent,
                ColumnFlushGradientB->0 Percent,
                ColumnFlushGradientC->25 Percent,
                ColumnFlushGradientD->75 Percent
            ];
            Download[protocol,{ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD}],
            {
                {0 Percent},
                {0 Percent},
                {25 Percent},
                {75 Percent}
            },
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushFlowRate,"Specify the speed of the fluid through the pump for ColumnFlush in electrochemical channel:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushFlowRate->0.2 Milliliter/Minute
            ];
            First@(First[Download[protocol,ColumnFlushGradients]][Gradient][[All,-1]]),
            0.2 Milliliter/Minute,
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushStart,"Specify a shorthand option for the starting BufferB composition in the fluid flow for ColumnFlush in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushStart->25 Percent,
                ColumnFlushEnd->50 Percent,
                ColumnFlushDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnFlushStart,ColumnFlushEnd,ColumnFlushDuration}],
            {25 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushEnd,"Specify a shorthand option for the final BufferB composition in the fluid flow for ColumnFlush in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushStart->75 Percent,
                ColumnFlushEnd->50 Percent,
                ColumnFlushDuration->10 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnFlushStart,ColumnFlushEnd,ColumnFlushDuration}],
            {75 Percent,50 Percent,10 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushDuration,"Specify a shorthand option for the duration of the gradient in the fluid flow for ColumnFlush in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushStart->75 Percent,
                ColumnFlushEnd->50 Percent,
                ColumnFlushDuration->2 Minute,
                Output->Options
            ];
            Lookup[options,{ColumnFlushStart,ColumnFlushEnd,ColumnFlushDuration}],
            {75 Percent,50 Percent,2 Minute},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushGradient,"Specify the buffer composition over time in the fluid flow for ColumnFlush in electrochemical channel as a list of tuples:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradient->{
                    {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                    {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                    {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                    {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                    {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
                },
                Output->Options
            ];
            Lookup[options,ColumnFlushGradient],
            {
                {0 Minute,25 Percent,50 Percent,25 Percent,0 Percent,1 Milliliter/Minute},
                {0.1 Minute,50 Percent,50 Percent,0 Percent,0 Percent,1 Milliliter/Minute},
                {10 Minute,10 Percent,20 Percent,30 Percent,40 Percent,1 Milliliter/Minute},
                {20 Minute,40 Percent,30 Percent,20 Percent,10 Percent,1 Milliliter/Minute},
                {30 Minute,25 Percent,25 Percent,25 Percent,25 Percent,1 Milliliter/Minute}
            },
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushGradient,"Specify ColumnFlushGradient as a method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushGradient->Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnFlushGradient],
            Object[Method,Gradient,"ExperimentIC Test Gradient Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushGradient,"All electrochemical gradient options resolve to Null if there are no ColumnFlush in electrochemical channel:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->AnionChannel,
                Output->Options
            ];
            Lookup[options,{ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD,ColumnFlushFlowRate,ColumnFlushStart,ColumnFlushEnd,ColumnFlushDuration,ColumnFlushGradient}],
            ListableP[Null|{}],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceWavelength,"The physical properties of light passed through the flow for the UVVis Detector during ColumnFlush run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushAbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceWavelength],
            500 Nanometer,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceWavelength,"Specifying multiple ColumnFlushAbsorbanceWavelengths for an experiment during ColumnFlush run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushAbsorbanceWavelength->{500 Nanometer,280 Nanometer},
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceWavelength],
            {500 Nanometer,280 Nanometer},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceWavelength,"If UVVis detector is not used, ColumnFlushAbsorbanceWavelength resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceWavelength,"If ColumnFlushAbsorbanceSamplingRate is set to Null, ColumnFlushAbsorbanceWavelength also resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushAbsorbanceSamplingRate->Null,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceWavelength],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceWavelength,"If ColumnFlushAbsorbanceWavelength is not specified, it will resolve to the first value of AbsorbanceWavelength:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                AbsorbanceWavelength->500 Nanometer,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceWavelength],
            500 Nanometer,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceSamplingRate,"Specifying the frequency of absorbance measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushAbsorbanceSamplingRate->50/Second,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceSamplingRate],
            50/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceSamplingRate,"When multiple ColumnFlushAbsorbanceWavelength is specified, ColumnFlushAbsorbanceSamplingRate resolves to 1/Second if left unspecified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushAbsorbanceWavelength->{500 Nanometer,280 Nanometer},
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceSamplingRate],
            1/Second,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushAbsorbanceSamplingRate,"If UVVis detector is not used, ColumnFlushAbsorbanceSamplingRate resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->ElectrochemicalDetector,
                Output->Options
            ];
            Lookup[options,ColumnFlushAbsorbanceSamplingRate],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalDetectionMode,"Specifies the mode of operation for the electrochemical detector for ColumnFlush runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushElectrochemicalDetectionMode->PulsedAmperometricDetection,
                Output->Options
            ];
            Lookup[options,ColumnFlushElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalDetectionMode,"If ColumnFlushVoltageProfile is populated, ColumnFlushElectrochemicalDetectionMode resolves to DCAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushVoltageProfile->0.2 Volt,
                Output->Options
            ];
            Lookup[options,ColumnFlushElectrochemicalDetectionMode],
            DCAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalDetectionMode,"If ColumnFlushWaveformProfile is populated, ColumnFlushElectrochemicalDetectionMode resolves to PulsedAmperometricDetection:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnFlushElectrochemicalDetectionMode],
            PulsedAmperometricDetection,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalDetectionMode,"If electrochemical detector is not used in a protocol, ColumnFlushElectrochemicalDetectionMode resolves to Null:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,ColumnFlushElectrochemicalDetectionMode],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode during ColumnFlush run:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushReferenceElectrodeMode->pH,
                Output->Options
            ];
            Lookup[options,ColumnFlushReferenceElectrodeMode],
            pH,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushReferenceElectrodeMode,"Specifies the mode of operation for the reference electrode in the generated Waveform object for ColumnFlush:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushReferenceElectrodeMode->pH
            ];
            Download[protocol,ColumnFlushWaveformObjects][ReferenceElectrodeMode],
            {pH},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushVoltageProfile,"Specifies the time-dependent voltage setting throughout the measurement:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushVoltageProfile->0.5 Volt,
                Output->Options
            ];
            Lookup[options,ColumnFlushVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushVoltageProfile,"Specify VoltageProfile as a list of tuples in the form of {Time, Voltage}...:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushVoltageProfile->{{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
                Output->Options
            ];
            Lookup[options,ColumnFlushVoltageProfile],
            {{0 Minute, 0.1 Volt},{2 Minute, 0.5 Volt}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushVoltageProfile,"ColumnFlushVoltageProfile resolves to Null if WaveformProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnFlushVoltageProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushVoltageProfile,"If ColumnFlushVoltageProfile is not specified, it will resolve to the first value of VoltageProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                VoltageProfile->{0.5 Volt,0.1 Volt,0.2 Volt,0.4 Volt},
                Output->Options
            ];
            Lookup[options,ColumnFlushVoltageProfile],
            0.5 Volt,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"Specify a series of time-dependent voltage setting (waveform) that will be repeated over the duration of the ColumnFlush runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            {{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"Specify multiple waveforms that will be repeated over the duration of the ColumnFlush runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            {{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"Specify ColumnFlushWaveformProfile as a waveform method object:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"Specify ColumnFlushWaveformProfile as multiple waveform method objects:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->{{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID]}},
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            {{0 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]},{5 Minute,Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object]}},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"New waveform objects will be created and uploaded if ColumnFlushWaveformProfile is not specified directly as a method object:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}
            ];
            Download[protocol,ColumnFlushWaveformObjects],
            {ObjectP[Object[Method,Waveform]]},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"If multiple waveforms are used, separate waveform method objects will be uploaded:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->{{0 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.1 Volt,True,True},{0.3 Second,0.5 Volt,True,False}}},{5 Minute,{{0 Second,0.1 Volt,True,False},{0.2 Second,-0.5 Volt,True,True},{0.3 Second,0.3 Volt,True,False}}}}
            ];
            Download[protocol,ColumnFlushWaveformObjects],
            {ObjectP[Object[Method,Waveform]]...},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"ColumnFlushWaveformProfile resolves to Null if ColumnFlushVoltageProfile is specified:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushVoltageProfile->0.1 Volt,
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            Null,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushWaveformProfile,"If ColumnFlushWaveformProfile is not specified, it will resolve to the first value of WaveformProfile:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                WaveformProfile->Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,ColumnFlushWaveformProfile],
            Object[Method,Waveform,"ExperimentIC Test Waveform Object 1" <> $SessionUUID][Object],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalSamplingRate,"Indicates the frequency of amperometric measurement during ColumnFlush runs:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushElectrochemicalSamplingRate->2/Second
            ];
            Download[protocol,ColumnFlushElectrochemicalSamplingRate],
            {2./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushElectrochemicalSamplingRate,"ColumnFlushElectrochemicalSamplingRate is automatically set based on the specified ColumnFlushWaveform:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushWaveformProfile->Object[Method,Waveform,"id:o1k9jAG1DRRa"]
            ];
            Download[protocol,ColumnFlushElectrochemicalSamplingRate],
            {1./Second},
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,ColumnFlushDetectionTemperature,"Specify the temperature of the detection oven where the eletrochemical detection takes place during ColumnFlush runs:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                ColumnFlushDetectionTemperature->30 Celsius,
                Output->Options
            ];
            Lookup[options,ColumnFlushDetectionTemperature],
            30 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushDetectionTemperature,"If ColumnFlushDetectionTemperature is not specified, it will resolve to the first value of DetectionTemperature:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                DetectionTemperature->29 Celsius,
                Output->Options
            ];
            Lookup[options,ColumnFlushDetectionTemperature],
            29 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,ColumnFlushDetectionTemperature,"All ColumnFlush electrochemical detector related options resolve to Null if electrochemical detector is not used:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                AnalysisChannel->ElectrochemicalChannel,
                Detector->UVVis,
                Output->Options
            ];
            Lookup[options,{ColumnFlushElectrochemicalDetectionMode,ColumnFlushReferenceElectrodeMode,ColumnFlushVoltageProfile,ColumnFlushWaveformProfile,ColumnFlushElectrochemicalSamplingRate,ColumnFlushDetectionTemperature}],
            {Null...},
            TimeConstraint->240,
            Variables:>{options}
        ],

        (* --- Shared options tests --- *)

        (* == ExperimentIncubate tests == *)
        Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Incubate->True,
                Output->Options
            ];
            Lookup[options,Incubate],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                IncubationTemperature->40*Celsius,
                Output->Options
            ];
            Lookup[options,IncubationTemperature],
            40*Celsius,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                IncubationTime->40*Minute,
                Output->Options
            ];
            Lookup[options,IncubationTime],
            40*Minute,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                MaxIncubationTime->40*Minute,
                Output->Options
            ];
            Lookup[options,MaxIncubationTime],
            40*Minute,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                IncubationInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],
                Output->Options
            ];
            Lookup[options,IncubationInstrument],
            ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AnnealingTime->40*Minute,
                Output->Options
            ];
            Lookup[options,AnnealingTime],
            40*Minute,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                IncubateAliquot->50 Microliter,
                Output->Options
            ];
            Lookup[options,IncubateAliquot],
            50 Microliter,
            EquivalenceFunction->Equal,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                IncubateAliquotContainer->Model[Container,Plate,"96-well 2mL Deep Well Plate"],
                Output->Options
            ];
            Lookup[options,IncubateAliquotContainer],
            {1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Mix->True,
                Output->Options
            ];
            Lookup[options,Mix],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        (* Note: You CANNOT be in a plate for the following test. *)
        Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Large Test Sample 1" <> $SessionUUID],
                MixType->Shake,
                Output->Options
            ];
            Lookup[options,MixType],
            Shake,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                MixUntilDissolved->True,
                Output->Options
            ];
            Lookup[options,MixUntilDissolved],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,IncubateAliquotDestinationWell,"Specify the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                IncubateAliquotDestinationWell->"A1",
                Output->Options
            ];
            Lookup[options,IncubateAliquotDestinationWell],
            "A1",
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{protocol}
        ],

        (* == ExperimentCentrifuge == *)
        Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                Centrifuge->True,Output->Options
            ];
            Lookup[options,Centrifuge],
            True,
            Variables:>{options},
            TimeConstraint->240
        ],
        (* Note: Put your sample in a 2mL tube for the following test. *)
        Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options
            ];
            Lookup[options,CentrifugeInstrument],
            ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeIntensity->1000*RPM,Output->Options
            ];
            Lookup[options,CentrifugeIntensity],
            1000*RPM,
            EquivalenceFunction->Equal,
            Variables:>{options},
            TimeConstraint->240
        ],
        (* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
        Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeTime->5*Minute,Output->Options
            ];
            Lookup[options,CentrifugeTime],
            5*Minute,
            EquivalenceFunction->Equal,
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeTemperature->10*Celsius,Output->Options
            ];
            Lookup[options,CentrifugeTemperature],
            10*Celsius,
            EquivalenceFunction->Equal,
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeAliquot->500*Microliter,Output->Options
            ];
            Lookup[options,CentrifugeAliquot],
            500*Microliter,
            EquivalenceFunction->Equal,
            Variables:>{options},
            TimeConstraint->240,
            Messages:>{Warning::AliquotRequired}
        ],
        Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
            options=ExperimentIonChromatography[Object[Container,Plate,"Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options
            ];
            Lookup[options,CentrifugeAliquotContainer],
            {
                {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
                {2,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
                {3,ObjectP[Model[Container,Vessel,"2mL Tube"]]}
            },
            Variables:>{options},
            TimeConstraint->240,
            Messages:>{Warning::AliquotRequired}
        ],
        Example[
            {Options,CentrifugeAliquotDestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                CentrifugeAliquotDestinationWell->"A1",
                Output->Options
            ];
            Lookup[options,CentrifugeAliquotDestinationWell],
            "A1",
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],

        (* == ExperimentFilter == *)
        Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Filtration->True,
                Output->Options
            ];
            Lookup[options,Filtration],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FiltrationType->Syringe,
                Output->Options
            ];
            Lookup[options,FiltrationType],
            Syringe,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],
                Output->Options
            ];
            Lookup[options,FilterInstrument],
            ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],
                Output->Options
            ];
            Lookup[options,Filter],
            ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Large Test Sample 1" <> $SessionUUID],
                FilterMaterial->PES,
                Output->Options
            ];
            Lookup[options,FilterMaterial],
            PES,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,PrefilterMaterial,"The membrane material of the pre-filter that should be used to remove impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"Test sample for invalid container for ExperimentIC tests" <> $SessionUUID],
                PrefilterMaterial->GxF,
                Output->Options
            ];
            Lookup[options,PrefilterMaterial],
            GxF,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterPoreSize->0.22*Micrometer,
                Output->Options
            ];
            Lookup[options,FilterPoreSize],
            0.22*Micrometer,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,PrefilterPoreSize,"The pore size of the pre-filter that should be used when removing impurities from the SamplesIn prior to starting the experiment or any aliquoting:"},
            options=ExperimentIonChromatography[Object[Sample,"Test sample for invalid container for ExperimentIC tests" <> $SessionUUID],
                PrefilterPoreSize->1.`*Micrometer,
                Output->Options
            ];
            Lookup[options,PrefilterPoreSize],
            1.`*Micrometer,
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FiltrationType->Syringe,
                FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
                Output->Options
            ];
            Lookup[options,FilterSyringe],
            ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Large Test Sample 1" <> $SessionUUID],
                FiltrationType->PeristalticPump,
                FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],
                Output->Options
            ];
            Lookup[options,FilterHousing],
            ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options
            ];
            Lookup[options,FilterIntensity],
            1000*RPM,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options
            ];
            Lookup[options,FilterTime],
            20*Minute,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options
            ];
            Lookup[options,FilterTemperature],
            10*Celsius,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterSterile->True,
                Output->Options
            ];
            Lookup[options,FilterSterile],
            True,
            TimeConstraint->240,
            Messages:>{Warning::AliquotRequired},
            Variables:>{options}
        ],
        Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterAliquot->0.3*Milliliter,Output->Options
            ];
            Lookup[options,FilterAliquot],
            0.3*Milliliter,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options
            ];
            Lookup[options,FilterAliquotContainer],
            {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterContainerOut->Model[Container,Vessel,"2mL Tube"],
                Output->Options
            ];
            Lookup[options,FilterContainerOut],
            {1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
            Messages:>{Warning::AliquotRequired},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,FilterAliquotDestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                FilterAliquotDestinationWell->"A1",
                Output->Options
            ];
            Lookup[options,FilterAliquotDestinationWell],
            "A1",
            TimeConstraint->240,
            Variables:>{options}
        ],

        (* == ExperimentAliquot == *)
        Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AliquotAmount->0.08 Milliliter,
                Output->Options
            ];
            Lookup[options,{Aliquot,AliquotAmount}],
            {True,0.08*Milliliter},
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AliquotAmount->0.08*Milliliter,
                Output->Options
            ];
            Lookup[options,AliquotAmount],
            0.08*Milliliter,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AssayVolume->0.08*Milliliter,
                Output->Options
            ];
            Lookup[options,AssayVolume],
            0.08*Milliliter,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                TargetConcentration->10*Micromolar,
                Output->Options
            ];
            Lookup[options,TargetConcentration],
            10*Micromolar,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,TargetConcentrationAnalyte,"The analyte whose desired final concentration is specified:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                TargetConcentrationAnalyte->Model[Molecule,"Uracil"],
                TargetConcentration->45 Micromolar,
                Output->Options
            ];
            Lookup[options,TargetConcentrationAnalyte],
            ObjectP[Model[Molecule,"Uracil"]],
            Variables:>{options}
        ],
        Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ConcentratedBuffer->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                BufferDilutionFactor->3,
                BufferDiluent->Model[Sample,"Milli-Q water"],
                AssayVolume->1000 Microliter,
                AliquotAmount->100 Microliter,
                Output->Options
            ];
            Lookup[options,ConcentratedBuffer],
            ObjectP[Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                BufferDilutionFactor->2,
                ConcentratedBuffer->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                AssayVolume->1000 Microliter,
                AliquotAmount->100 Microliter,
                Output->Options
            ];
            Lookup[options,BufferDilutionFactor],
            2,
            EquivalenceFunction->Equal,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                BufferDiluent->Model[Sample,"Milli-Q water"],
                BufferDilutionFactor->2,
                ConcentratedBuffer->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                AssayVolume->1000 Microliter,
                AliquotAmount->100 Microliter,
                Output->Options
            ];
            Lookup[options,BufferDiluent],
            ObjectP[Model[Sample,"Milli-Q water"]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AssayBuffer->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                AssayVolume->1000 Microliter,
                AliquotAmount->100 Microliter,
                Output->Options
            ];
            Lookup[options,AssayBuffer],
            ObjectP[Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"]],
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AliquotSampleStorageCondition->Refrigerator,
                Output->Options
            ];
            Lookup[options,AliquotSampleStorageCondition],
            Refrigerator,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ConsolidateAliquots->True,
                Output->Options
            ];
            Lookup[options,ConsolidateAliquots],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                Aliquot->True,
                AliquotPreparation->Manual,
                Output->Options
            ];
            Lookup[options,AliquotPreparation],
            Manual,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                AliquotContainer->Model[Container,Plate,"In Situ-1 Crystallization Plate"],
                Output->Options
            ];
            Lookup[options,AliquotContainer],
            {1,ObjectP[Model[Container,Plate,"In Situ-1 Crystallization Plate"]]},
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,DestinationWell,"Specify The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                DestinationWell->"A1",
                Output->Options
            ];
            Lookup[options,DestinationWell],
            "A1",
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[{Options,ImageSample,"Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
            options=ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],
                ImageSample->True,
                Output->Options
            ];
            Lookup[options,ImageSample],
            True,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
            Download[
                ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],MeasureVolume->True],
                MeasureVolume
            ],
            True,
            TimeConstraint->240
        ],
        Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
            Download[
                ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],MeasureWeight->True],
                MeasureWeight
            ],
            True,
            TimeConstraint->240
        ],


        (* == Other shared options == *)
        Example[{Options,Name,"Name the protocol for IonChromatography:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Name->"A brilliant test protocol" <> $SessionUUID,
                Output->Options
            ];
            Lookup[options,Name],
            "A brilliant test protocol" <> $SessionUUID,
            Variables:>{options},
            TimeConstraint->240
        ],
        Example[{Options,Template,"Inherit options from a previously run protocol:"},
            options=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID]},
                Template->Object[Protocol,IonChromatography,"Test IonChromatography option template protocol" <> $SessionUUID],
                Output->Options
            ];
            Lookup[options,AnionDetectionTemperature],
            35 Celsius,
            TimeConstraint->240,
            Variables:>{options}
        ],
        Example[
            {Options,Operator,"Specify the operator or model of operator who may run this protocol:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Operator->Model[User,Emerald,Operator,"id:E8zoYvN6kN8A"]
            ];
            Download[protocol,Operator],
            ObjectP[Model[User,Emerald,Operator,"id:E8zoYvN6kN8A"]],
            Variables:>{protocol},
            TimeConstraint->240
        ],
        Example[
            {Options,Upload,"Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
            ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Upload->True
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            TimeConstraint->240
        ],
        Example[
            {Options,Output,"Specify Indicate what the function should return:"},
            ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                Output->Result
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            TimeConstraint->240
        ],
        Example[
            {Options,PreparatoryPrimitives,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
            ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferA->"My Buffer",
                PreparatoryPrimitives->{
                    Define[
                        Name->"My Buffer",
                        Sample->{Model[Container,Vessel,"2L Glass Bottle"],"A1"}
                    ],
                    Transfer[
                        Source->Model[Sample,"Milli-Q water"],
                        Destination->"My Buffer",
                        Amount->500 Milliliter
                    ],
                    Transfer[
                        Source->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                        Destination->"My Buffer",
                        Amount->500 Milliliter
                    ]
                }
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSampleManipulation:"},
            ExperimentIonChromatography[Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],
                BufferA->"My Buffer",
                PreparatoryUnitOperations->{
                    LabelContainer[
                        Label->"My Buffer Container",
                        Container->Model[Container,Vessel,"2L Glass Bottle"]
                    ],
                    Transfer[
                        Source->Model[Sample,"Milli-Q water"],
                        Destination->"My Buffer Container",
                        Amount->500 Milliliter
                    ],
                    Transfer[
                        Source->Model[Sample,StockSolution,"50 mM MSA (Methanesulfonic Acid)"],
                        Destination->"My Buffer Container",
                        Amount->500 Milliliter
                    ],
                    LabelSample[
                        Label->"My Buffer",
                        Sample->{"A1","My Buffer Container"}
                    ]
                }
            ],
            ObjectP[Object[Protocol,IonChromatography]],
            TimeConstraint->240,
            Variables:>{protocol}
        ],
        Example[
            {Options,SamplesInStorageCondition,"Specify The non-default conditions under which the SamplesIn of this experiment should be stored after the protocol is completed. If left unset, SamplesIn will be stored according to their current StorageCondition:"},
            protocol=ExperimentIonChromatography[{Object[Sample,"ExperimentIC Test Sample 1" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 2" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 3" <> $SessionUUID],Object[Sample,"ExperimentIC Test Sample 4" <> $SessionUUID]},
                SamplesInStorageCondition->{Disposal,Disposal,Disposal,AmbientStorage}

            ];
            Download[protocol,SamplesInStorage],
            {Disposal,Disposal,Disposal,AmbientStorage},
            TimeConstraint->240,
            Variables:>{protocol}
        ]
    },
    TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance, Warning::DeprecatedProduct},
    Parallel -> True,
    SetUp :> (
        $CreatedObjects = {};
        ClearMemoization[];
        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];
        Off[Warning::DeprecatedProduct];
        Off[Warning::NoModelNameGiven];
    ),
    TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		On[Warning::NoModelNameGiven];
	),
    HardwareConfiguration->HighRAM,
    SymbolSetUp :> (

        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];

        (* Module for deleting created objects *)
        Module[{objects, existingObjects},
            objects = {
                (* Bench *)
                Object[Container, Bench, "Test bench for ExperimentIonChromatography tests " <> $SessionUUID],
                (* Containers *)
                Object[Container, Plate, "Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Plate, "Test plate 2 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test large container 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test invalid container 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test HPLC vial 1 for ExperimentIC tests" <> $SessionUUID],
                (* Samples *)
                Object[Sample, "ExperimentIC Test Sample 1" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 2" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 3" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 4" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 5" <> $SessionUUID],
                Object[Sample, "ExperimentIC Large Test Sample 1" <> $SessionUUID],
                Object[Sample, "Test sample for invalid container for ExperimentIC tests" <> $SessionUUID],
                (* Methods *)
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Anion Gradient Object 2" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Invalid Anion Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Invalid Cation Gradient Object 1" <> $SessionUUID],
                Object[Method, Gradient, "ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 2" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 3" <> $SessionUUID],
                (* Protocols *)
                Object[Protocol, IonChromatography, "Test IonChromatography option template protocol" <> $SessionUUID],
                Object[Protocol, IonChromatography, "A brilliant test protocol" <> $SessionUUID]
            };

            (* Pull out only the objects that currently exist in the database *)
            existingObjects = PickList[objects, DatabaseMemberQ[objects]];

            (* Erase those objects that exist *)
            EraseObject[existingObjects, Force -> True, Verbose -> False]

        ];

        (* Module for creating objects *)
        Module[
            {
                (* Bench *)
                fakeBench,
                (* Containers *)
                containerPackets,
                (* Samples *)
                samplePackets,
                (* Gradients *)
                gradientOne, gradientTwo, gradientThree, gradientFour, gradientFive, gradientSix, gradientPackets,
                (* Waveforms *)
                waveformPackets
            },

            fakeBench = Upload[
                <|
                    Type -> Object[Container, Bench],
                    Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
                    Name -> "Test bench for ExperimentIonChromatography tests " <> $SessionUUID,
                    Site -> Link[$Site]
                |>
            ];

            containerPackets = UploadSample[
                {
                    Model[Container, Plate, "96-well 2mL Deep Well Plate"],
                    Model[Container, Plate, "96-well 2mL Deep Well Plate"],
                    Model[Container, Vessel, "2L Glass Bottle"],
                    Model[Container, Vessel, "2mL Tube"],
                    Model[Container, Vessel, "HPLC vial (high recovery)"]
                },
                {
                    {"Work Surface", fakeBench},
                    {"Work Surface", fakeBench},
                    {"Work Surface", fakeBench},
                    {"Work Surface", fakeBench},
                    {"Work Surface", fakeBench}
                },
                Name -> {
                    "Test plate 1 for ExperimentIC tests" <> $SessionUUID,
                    "Test plate 2 for ExperimentIC tests" <> $SessionUUID,
                    "Test large container 1 for ExperimentIC tests" <> $SessionUUID,
                    "Test invalid container 1 for ExperimentIC tests" <> $SessionUUID,
                    "Test HPLC vial 1 for ExperimentIC tests" <> $SessionUUID
                },
                Status -> Available
            ];

            gradientOne = {
                {0 Minute, 10 Millimolar, 0.25 Milliliter/Minute},
                {0.1 Minute, 10 Millimolar, 0.25 Milliliter/Minute},
                {12 Minute, 22 Millimolar, 0.25 Milliliter/Minute},
                {20 Minute, 50 Millimolar, 0.25 Milliliter/Minute},
                {20.5 Minute, 50 Millimolar, 0.25 Milliliter/Minute},
                {20.6 Minute, 10 Millimolar, 0.25 Milliliter/Minute},
                {27 Minute, 10 Millimolar, 0.25Milliliter/Minute}
            };

            gradientTwo = {
                {0 Minute, 20 Percent, 80 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {0.1 Minute, 20 Percent, 80 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {12 Minute, 44 Percent, 56 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {20 Minute, 100 Percent, 0 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {20.5 Minute, 100 Percent, 0 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {20.6 Minute, 20 Percent, 80 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {27 Minute, 20 Percent, 80 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute}
            };

            gradientThree = {
                {0 Minute, 10 Millimolar, 0.25 Milliliter/Minute},
                {20 Minute, 10 Millimolar, 0.25 Milliliter/Minute}
            };

            gradientFour = {
                {0 Minute, 20 Percent, 80 Percent, 0 Percent, 0 Percent, 0.16 Milliliter/Minute},
                {27 Minute, 20 Percent, 80 Percent, 20 Percent, 0 Percent, 0.16 Milliliter/Minute}
            };

            gradientFive = {
                {0 Minute, 500 Millimolar, 0.25 Milliliter/Minute},
                {20 Minute, 500 Millimolar, 0.25 Milliliter/Minute}
            };

            gradientSix = {
                {0 Minute, 50 Percent, 25 Percent, 25 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
                {10 Minute, 50 Percent, 25 Percent, 25 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute}
            };

            gradientPackets = {
                Association[
                    Type -> Object[Method, IonChromatographyGradient],
                    Replace[AnionGradient] -> gradientOne,
                    EluentGeneratorInletSolution -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, IonChromatographyGradient],
                    Replace[CationGradient] -> gradientTwo,
                    BufferA -> Link[Model[Sample, StockSolution, "50 mM MSA (Methanesulfonic Acid)"]],
                    BufferB -> Link[Model[Sample, "Milli-Q water"]],
                    BufferC -> Link[Model[Sample, "Milli-Q water"]],
                    BufferD -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, IonChromatographyGradient],
                    Replace[AnionGradient] -> gradientThree,
                    EluentGeneratorInletSolution -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Anion Gradient Object 2" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, IonChromatographyGradient],
                    Replace[CationGradient] -> gradientFour,
                    BufferA -> Link[Model[Sample, StockSolution, "50 mM MSA (Methanesulfonic Acid)"]],
                    BufferB -> Link[Model[Sample, "Milli-Q water"]],
                    BufferC -> Link[Model[Sample, "Milli-Q water"]],
                    BufferD -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Invalid Cation Gradient Object 1" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, IonChromatographyGradient],
                    Replace[AnionGradient] -> gradientFive,
                    EluentGeneratorInletSolution -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Invalid Anion Gradient Object 1" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, Gradient],
                    Replace[Gradient] -> gradientSix,
                    BufferA -> Link[Model[Sample, "Milli-Q water"]],
                    BufferB -> Link[Model[Sample, "Milli-Q water"]],
                    BufferC -> Link[Model[Sample, "Milli-Q water"]],
                    BufferD -> Link[Model[Sample, "Milli-Q water"]],
                    Name -> "ExperimentIC Test Gradient Object 1" <> $SessionUUID
                ]
            };

            waveformPackets = {
                Association[
                    Type -> Object[Method, Waveform],
                    ElectrochemicalDetectionMode -> PulsedAmperometricDetection,
                    ReferenceElectrodeMode -> AgCl,
                    WaveformDuration -> 0.5 Second,
                    Replace[Waveform] -> {
                        <|Time -> Quantity[0., "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.2, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.4, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.41, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.42, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.43, "Seconds"], Voltage -> Quantity[0.6, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.44, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.5, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>
                    },
                    Name -> "ExperimentIC Test Waveform Object 1" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, Waveform],
                    ElectrochemicalDetectionMode -> IntegratedPulsedAmperometricDetection,
                    ReferenceElectrodeMode -> AgCl,
                    WaveformDuration -> 0.5 Second,
                    Replace[Waveform] -> {
                        <|Time -> Quantity[0., "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.2, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True,Integration -> True|>,
                        <|Time -> Quantity[0.4, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.41, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.42, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.43, "Seconds"], Voltage -> Quantity[0.6, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.44, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.5, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>
                    },
                    Name -> "ExperimentIC Test Waveform Object 2" <> $SessionUUID
                ],
                Association[
                    Type -> Object[Method, Waveform],
                    ElectrochemicalDetectionMode -> PulsedAmperometricDetection,
                    ReferenceElectrodeMode -> AgCl,
                    WaveformDuration -> 0.6 Second,
                    Replace[Waveform] -> {
                        <|Time -> Quantity[0., "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.2, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.4, "Seconds"], Voltage -> Quantity[0.1, "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.41, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> True|>,
                        <|Time -> Quantity[0.42, "Seconds"], Voltage -> Quantity[-2., "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.43, "Seconds"], Voltage -> Quantity[0.6, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.44, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>,
                        <|Time -> Quantity[0.6, "Seconds"], Voltage -> Quantity[-0.1, "Volts"], Interpolation -> True, Integration -> False|>
                    },
                    Name -> "ExperimentIC Test Waveform Object 3" <> $SessionUUID
                ]
            };

            Upload[Join[gradientPackets, waveformPackets]];

            samplePackets = UploadSample[
                {
                    Model[Sample, "Multielement Ion Chromatography Anion Standard Solution"],
                    Model[Sample, "Multielement Ion Chromatography Anion Standard Solution"],
                    Model[Sample, "Multi Cation Standard 1 for IC"],
                    Model[Sample, "Multi Cation Standard 1 for IC"],
                    Model[Sample, "Milli-Q water"],
                    Model[Sample, "Milli-Q water"],
                    Model[Sample, "Multi Cation Standard 1 for IC"]
                },
                {
                    {"A1", Object[Container, Plate, "Test plate 1 for ExperimentIC tests" <> $SessionUUID]},
                    {"A2", Object[Container, Plate, "Test plate 1 for ExperimentIC tests" <> $SessionUUID]},
                    {"A3", Object[Container, Plate, "Test plate 1 for ExperimentIC tests" <> $SessionUUID]},
                    {"A1", Object[Container, Plate, "Test plate 2 for ExperimentIC tests" <> $SessionUUID]},
                    {"A1", Object[Container, Vessel, "Test HPLC vial 1 for ExperimentIC tests" <> $SessionUUID]},
                    {"A1", Object[Container, Vessel, "Test large container 1 for ExperimentIC tests" <> $SessionUUID]},
                    {"A1", Object[Container, Vessel, "Test invalid container 1 for ExperimentIC tests" <> $SessionUUID]}
                },
                InitialAmount -> {
                        500 Microliter,
                        500 Microliter,
                        500 Microliter,
                        500 Microliter,
                        1.8 Milliliter,
                        2 Liter,
                        2000 Microliter
                    },
                Name -> {
                    "ExperimentIC Test Sample 1" <> $SessionUUID,
                    "ExperimentIC Test Sample 2" <> $SessionUUID,
                    "ExperimentIC Test Sample 3" <> $SessionUUID,
                    "ExperimentIC Test Sample 4" <> $SessionUUID,
                    "ExperimentIC Test Sample 5" <> $SessionUUID,
                    "ExperimentIC Large Test Sample 1" <> $SessionUUID,
                    "Test sample for invalid container for ExperimentIC tests" <> $SessionUUID
                },
                Upload -> False
            ];

            Upload[samplePackets];

            (* Sever the link to the model *)
            Upload[
                {
                    Association[
                        Object -> Object[Sample, "ExperimentIC Test Sample 1" <> $SessionUUID],
                        Replace[Composition] -> {
                            {100 VolumePercent, Link[Model[Molecule, "Water"]]},
                            {5 Millimolar,Link[Model[Molecule, "Acetone"]]}
                        }
                    ],
                    Association[
                        Object -> Object[Sample, "ExperimentIC Test Sample 4" <> $SessionUUID],
                        Model -> Null
                    ],
                    Association[
                        Object -> Object[Sample, "ExperimentIC Test Sample 1" <> $SessionUUID],
                        Replace[Composition] -> {
                            {100 VolumePercent, Link[Model[Molecule, "Water"]]},
                            {450 Micromolar, Link[Model[Molecule, "Uracil"]]}
                        },
                        Replace[Analytes] -> {Link[Model[Molecule, "Uracil"]]}
                    ]
                }
            ];

            Upload[
                {
                    <|
                        Type -> Object[Protocol, IonChromatography],
                        DeveloperObject -> True,
                        Name -> "Test IonChromatography option template protocol" <> $SessionUUID,
                        ResolvedOptions -> {AnionDetectionTemperature -> 35 Celsius}
                    |>
                }
            ];

        ]

    ),

    SymbolTearDown :> (
        Module[{objects, existingObjects},
            objects = {
                (* Bench *)
                Object[Container, Bench, "Test bench for ExperimentIonChromatography tests " <> $SessionUUID],
                (* Containers *)
                Object[Container, Plate, "Test plate 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Plate, "Test plate 2 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test large container 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test invalid container 1 for ExperimentIC tests" <> $SessionUUID],
                Object[Container, Vessel, "Test HPLC vial 1 for ExperimentIC tests" <> $SessionUUID],
                (* Samples *)
                Object[Sample, "ExperimentIC Test Sample 1" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 2" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 3" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 4" <> $SessionUUID],
                Object[Sample, "ExperimentIC Test Sample 5" <> $SessionUUID],
                Object[Sample, "ExperimentIC Large Test Sample 1" <> $SessionUUID],
                Object[Sample, "Test sample for invalid container for ExperimentIC tests" <> $SessionUUID],
                (* Methods *)
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Anion Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Anion Gradient Object 2" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Invalid Anion Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Cation Gradient Object 1" <> $SessionUUID],
                Object[Method, IonChromatographyGradient, "ExperimentIC Test Invalid Cation Gradient Object 1" <> $SessionUUID],
                Object[Method, Gradient, "ExperimentIC Test Gradient Object 1" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 1" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 2" <> $SessionUUID],
                Object[Method, Waveform, "ExperimentIC Test Waveform Object 3" <> $SessionUUID],
                (* Protocols *)
                Object[Protocol, IonChromatography, "Test IonChromatography option template protocol" <> $SessionUUID],
                Object[Protocol, IonChromatography, "A brilliant test protocol" <> $SessionUUID]
            };

            existingObjects = PickList[objects, DatabaseMemberQ[objects]];

            EraseObject[existingObjects, Force -> True, Verbose -> False];

            On[Warning::SamplesOutOfStock];
            On[Warning::InstrumentUndergoingMaintenance];
        ]
    ),
    Stubs :> {
        $PersonID = Object[User, "Test user for notebook-less test protocols"],
        $AllowPublicObjects = True,
        $DeveloperUpload = True
    }
];


(* ::Subsubsection:: *)
(*ExperimentIonChromatographyOptions*)

DefineTests[
    ExperimentIonChromatographyOptions,
    {
        Example[
            {Basic, "Automatically resolve all options for a samples: "},
            ExperimentIonChromatographyOptions[Object[Sample, "ExperimentICOptions Test Sample 1 " <> $SessionUUID],
                OutputFormat -> List
            ],
            {Rule[_Symbol, Except[Automatic | $Failed]]..},
            TimeConstraint -> 240
        ],
        Example[
            {Basic, "Specify the injection volume for each sample: "},
            ExperimentIonChromatographyOptions[Object[Sample, "ExperimentICOptions Test Sample 1 " <> $SessionUUID],
                AnionInjectionVolume -> 10 Microliter,
                OutputFormat -> List
            ],
            {Rule[_Symbol, Except[Automatic | $Failed]]..},
            TimeConstraint -> 240
        ],
        Example[
            {Options, OutputFormat, "Return the resolved options for each sample as a list: "},
            ExperimentIonChromatographyOptions[Object[Sample, "ExperimentICOptions Test Sample 1 " <> $SessionUUID],
                OutputFormat -> List
            ],
            {Rule[_Symbol, Except[Automatic | $Failed]]..},
            TimeConstraint -> 240
        ],
        Example[
            {Options, OutputFormat, "Return the resolved options for each sample as a table: "},
            ExperimentIonChromatographyOptions[Object[Sample, "ExperimentICOptions Test Sample 1 " <> $SessionUUID]],
            Graphics_,
            TimeConstraint -> 240
        ]
    },
    SymbolSetUp :> (
        $CreatedObjects = {};
        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];
        (* Module for deleting created objects *)
        Module[{objects, existingObjects},
            objects = {
                Object[Container, Bench, "Test bench for ExperimentICOptions tests " <> $SessionUUID],
                Object[Sample, "ExperimentICOptions Test Sample 1 " <> $SessionUUID],
                Object[Container, Plate, "Test plate 1 for ExperimentICOptions tests " <> $SessionUUID]
            };

            existingObjects = PickList[objects, DatabaseMemberQ[objects]];
            EraseObject[existingObjects, Force -> True, Verbose -> False]

        ];

        (* Module for creating objects *)
        Module[{fakeBench, containerPackets, samplePackets},
            fakeBench = Upload[
                <|
                    Type -> Object[Container, Bench],
                    Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
                    Name -> "Test bench for ExperimentICOptions tests " <> $SessionUUID,
                    Site -> Link[$Site]
                |>
            ];

            containerPackets = UploadSample[
                {
                    Model[Container, Plate, "96-well 2mL Deep Well Plate"]
                },
                {
                    {"Work Surface", fakeBench}
                },
                Name -> {
                    "Test plate 1 for ExperimentICOptions tests " <> $SessionUUID
                }
            ];

            Upload[containerPackets];

            samplePackets = UploadSample[
                {
                    Model[Sample, "Multielement Ion Chromatography Anion Standard Solution"]
                },
                {
                    {"A1", Object[Container, Plate, "Test plate 1 for ExperimentICOptions tests " <> $SessionUUID]}
                },
                InitialAmount -> 500 Microliter,
                Name -> {
                    "ExperimentICOptions Test Sample 1 " <> $SessionUUID
                },
                Upload -> False
            ];

            Upload[samplePackets];

        ]

    ),
    SymbolTearDown :> (
        On[Warning::SamplesOutOfStock];
        On[Warning::InstrumentUndergoingMaintenance];
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    ),
    Stubs :> {
        $PersonID = Object[User, "Test user for notebook-less test protocols"],
        $AllowPublicObjects = True,
        $DeveloperUpload = True
    }
];

(* ::Subsubsection:: *)
(*ValidExperimentIonChromatographyQ*)

DefineTests[
    ValidExperimentIonChromatographyQ,

    {
        Example[{Basic, "Verify that the experiment can be run without issues: "},
            ValidExperimentIonChromatographyQ[Object[Sample, "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID]],
            True,
            TimeConstraint -> 240
        ],
        Example[{Basic, "Return False if there are problems with the inputs or options, specifically the eluent gradient cannot exceed 100 mM: "},
            ValidExperimentIonChromatographyQ[Object[Sample, "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID],
                EluentGradient -> 150 Millimoar
            ],
            False,
            TimeConstraint -> 240
        ],
        Example[{Options, OutputFormat, "Return a test summary:"},
            ValidExperimentIonChromatographyQ[
                Object[Sample, "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID],
                OutputFormat -> TestSummary
            ],
            _EmeraldTestSummary,
            TimeConstraint -> 240
        ],
        Example[{Options, Verbose, "Print verbose messages reporting test passage/failure: "},
            ValidExperimentIonChromatographyQ[
                Object[Sample, "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID],
                Verbose -> True]
            ,
            True,
            TimeConstraint -> 240
        ]
    },

    SymbolSetUp :> (
        $CreatedObjects = {};

        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];

        (* Module for deleting created objects *)
        Module[{objects, existingObjects},
            (* Create a list of all objects that will be uploaded in the SymbolSetUp *)
            objects = {
                (* Bench *)
                Object[Container, Bench, "Test bench for ValidExperimentIonChromatographyQ tests " <> $SessionUUID],
                (* Container *)
                Object[Container, Plate, "Test plate 1 for ValidExperimentIonChromatographyQ tests " <> $SessionUUID],
                (* Sample *)
                Object[Sample, "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID]
            };

            (* Pull those objects that already exist in the database *)
            existingObjects = PickList[objects, DatabaseMemberQ[objects]];

            (* Erase the objects that already exist from the database *)
            EraseObject[existingObjects, Force -> True, Verbose -> False]

        ];

        (* Module for creating objects *)
        Module[{testBench, containerPackets, samplePackets},

            (* Create an imaginary bench to put test containers on *)
            testBench = Upload[
                <|
                    Type -> Object[Container, Bench],
                    Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
                    Name -> "Test bench for ValidExperimentIonChromatographyQ tests " <> $SessionUUID,
                    Site -> Link[$Site],
                    DeveloperObject -> True
                |>
            ];

            (* Create test container and put it on the test bench *)
            containerPackets = UploadSample[
                {
                    Model[Container, Plate, "96-well 2mL Deep Well Plate"]
                },
                {
                    {"Work Surface", testBench}
                },
                Name -> {
                    "Test plate 1 for ValidExperimentIonChromatographyQ tests " <> $SessionUUID
                },
                Status -> Available(*,
                Upload -> False*)
            ];

            (*Upload[containerPackets];*)

            (* Create test sample and put it in the container *)
            samplePackets = UploadSample[
                {
                    Model[Sample, "Multielement Ion Chromatography Anion Standard Solution"]
                },
                {
                    {"A1", Object[Container, Plate, "Test plate 1 for ValidExperimentIonChromatographyQ tests " <> $SessionUUID]}
                },
                Name -> {
                    "ValidExperimentIonChromatographyQ Test Sample 1 " <> $SessionUUID
                },
                InitialAmount -> 500 Microliter(*,
                Upload -> False*)
            ](*;

            Upload[samplePackets];*)
        ]
    ),

    SymbolTearDown :> (
        On[Warning::SamplesOutOfStock];
        On[Warning::InstrumentUndergoingMaintenance];
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    ),

    Stubs :> {
        $PersonID = Object[User, "Test user for notebook-less test protocols"],
        $AllowPublicObjects = True,
        $DeveloperUpload = True
    }
];

(* ::Subsubsection:: *)
(* ExperimentIonChromatographyPreview *)

DefineTests[
    ExperimentIonChromatographyPreview,
    {
        Example[{Basic, "No preview is currently available for ExperimentIonChromatography:"},
            ExperimentIonChromatographyPreview[Object[Sample, "ExperimentICPreview Test Sample 1 " <> $SessionUUID]],
            Null,
            TimeConstraint -> 240
        ],
        Example[{Additional, "If you wish to understand how the experiment will be performed, try using ExperimentIonChromatographyOptions: "},
            ExperimentIonChromatographyOptions[Object[Sample, "ExperimentICPreview Test Sample 1 " <> $SessionUUID]],
            _Grid,
            TimeConstraint -> 240
        ],
        Example[{Additional, "The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentIonChromatographyQ: "},
            ValidExperimentIonChromatographyQ[Object[Sample, "ExperimentICPreview Test Sample 1 " <> $SessionUUID]],
            True,
            TimeConstraint -> 240
        ]
    },

    SymbolSetUp :> (
        $CreatedObjects = {};
        Off[Warning::SamplesOutOfStock];
        Off[Warning::InstrumentUndergoingMaintenance];
        (* Module for deleting created objects *)
        Module[{objects, existingObjects},
            objects = {
                Object[Container, Bench, "Test bench for ExperimentICPreview tests " <> $SessionUUID],
                Object[Sample, "ExperimentICPreview Test Sample 1 " <> $SessionUUID],
                Object[Container, Plate, "Test plate 1 for ExperimentICPreview tests " <> $SessionUUID]
            };

            existingObjects = PickList[objects, DatabaseMemberQ[objects]];
            EraseObject[existingObjects, Force -> True, Verbose -> False]

        ];
        (* Module for creating objects *)
        Module[{fakeBench, containerPackets, samplePackets},

            fakeBench = Upload[
                <|
                    Type -> Object[Container, Bench],
                    Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
                    Name -> "Test bench for ExperimentICPreview tests " <> $SessionUUID,
                    Site -> Link[$Site],
                    DeveloperObject -> True
                |>
            ];

            containerPackets = UploadSample[
                {
                    Model[Container, Plate, "96-well 2mL Deep Well Plate"]
                },
                {
                    {"Work Surface", fakeBench}
                },
                Name -> {
                    "Test plate 1 for ExperimentICPreview tests " <> $SessionUUID
                },
                Status -> {
                    Available
                }
            ];

            Upload[containerPackets];

            samplePackets = UploadSample[
                {
                    Model[Sample, "Multielement Ion Chromatography Anion Standard Solution"]
                },
                {
                    {"A1", Object[Container, Plate, "Test plate 1 for ExperimentICPreview tests " <> $SessionUUID]}
                },
                InitialAmount -> 500 Microliter,
                Name -> {
                    "ExperimentICPreview Test Sample 1 " <> $SessionUUID
                },
                Upload -> False
            ];

            Upload[samplePackets];

        ]

    ),
    SymbolTearDown :> (
        On[Warning::SamplesOutOfStock];
        On[Warning::InstrumentUndergoingMaintenance];
        EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
    ),
    Stubs :> {
        $PersonID = Object[User, "Test user for notebook-less test protocols"],
        $AllowPublicObjects = True,
        $DeveloperUpload = True
    }
];
