(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMeasureCount : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMeasureCount*)


(* ::Subsubsection:: *)
(*ExperimentMeasureCount*)

DefineTests[
	ExperimentMeasureCount,

  (* Basic examples *)
	{
		Example[{Basic,"Measure the count of a single sample:"},
			ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the count of a single sample without a model:"},
			ExperimentMeasureCount[Object[Sample,"Special tablet sample without Model for ExperimentMeasureCount testing"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		(* all Invalid Input and Option errors *)
		Example[{Basic,"Measure the count of multiple samples:"},
			ExperimentMeasureCount[
				{
					Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the count of the sample contained in a container:"},
			ExperimentMeasureCount[Object[Container,Vessel,"Empty 50ml container 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
			ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Basic,"Measure the count of samples contained in multiple containers:"},
			ExperimentMeasureCount[
				{
					Object[Container,Vessel,"Empty 50ml container 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Container,Vessel,"Empty 50ml container 7 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Container,Vessel,"Empty 50ml container 8 for ExperimentMeasureCount testing"<>$SessionUUID]
				}
			],
			ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],

    (* Messages *)
		Example[{Messages,"InputContainsTemporalLinks","A Warning is thrown if any inputs or options contain temporal links:"},
			ExperimentMeasureCount[
				Link[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Now]
			],
			ObjectP[Object[Protocol,MeasureCount]],
			Messages :> {
				Warning::InputContainsTemporalLinks
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Messages,"DiscardedSamples","If the given samples are discarded, they cannot be counted:"},
			ExperimentMeasureCount[Object[Sample,"Discarded tablet sample for ExperimentMeasureCount testing"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NonTabletSamples","If the given samples are not tablets, a warning is thrown:"},
			ExperimentMeasureCount[Object[Sample,"Non-tablet sample for ExperimentMeasureCount testing"<>$SessionUUID]],
      ObjectP[Object[Protocol,MeasureCount]],
			Messages:>{
				Warning::NonTabletSamples
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Messages,"InvalidParameterizationOptions","If the option TabletParameterizationReplicates is specified, ParameterizeTablets cannot be False:"},
			(* we're giving it a sample that has TabletWeight so it will also throw a warning since TabletParameterizationReplicates is specified *)
			ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->10,ParameterizeTablets->False],
			$Failed,
			Messages:>{
				Error::InvalidParameterizationOptions,
				Error::InvalidOption,
				Warning::TabletWeightKnown
			}
		],
		Example[{Messages,"ParameterizationReplicatesRequired","If the option ParameterizeTablets is set to True, TabletParameterizationReplicates cannot be Null:"},
			ExperimentMeasureCount[Object[Sample,"Available tablet sample without TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->Null,ParameterizeTablets->True],
			$Failed,
			Messages:>{
				Error::ParameterizationReplicatesRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ParameterizationReplicatesRequired","If the option ParameterizeTablets is Automatic, but TabletWeight is unknown, TabletParameterizationReplicates cannot be Null:"},
			ExperimentMeasureCount[Object[Sample,"Available tablet sample without TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->Null],
			$Failed,
			Messages:>{
				Error::ParameterizationReplicatesRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ParameterizationRequired","If the option ParameterizeTablets is set to False, TabletWeight has to be known:"},
			ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],ParameterizeTablets->False],
			$Failed,
			Messages:>{
				Error::ParameterizationRequired,
				Error::InvalidOption,
				Error::InvalidInput
			}
		],
		Example[{Messages,"TotalWeightRequired","If the option MeasureTotalWeight is set to False, Mass has to be known:"},
			ExperimentMeasureCount[{Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]},MeasureTotalWeight->False],
			$Failed,
			Messages:>{
				Error::TotalWeightRequired,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		(* all Invalid Input and Option warnings *)
		Example[{Messages,"MassKnown","Throws a warning if the option MeasureTotalWeight is set to True, although Mass is known:"},
			ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID],MeasureTotalWeight->True],
			ObjectP[Object[Protocol,MeasureCount]],
			Messages:>{
				Warning::MassKnown
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Messages,"TabletWeightKnown","Throws a warning if the option ParameterizeTablets is set to True, although TabletWeight is known:"},
			ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],ParameterizeTablets->True],
			ObjectP[Object[Protocol,MeasureCount]],
			Messages:>{
				Warning::TabletWeightKnown
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Messages,"TabletWeightKnown","Throws a warning if the option TabletParameterizationReplicates is specified, although TabletWeight is known:"},
			ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->15],
			ObjectP[Object[Protocol,MeasureCount]],
			Messages:>{
				Warning::TabletWeightKnown
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Messages,"IncompatibleContainer","If the sample needs to be weight measured, it needs to be in a container that is compatible with ExperimentMeasureWeight (MeasureWeightContainerP):"},
			ExperimentMeasureCount[Object[Sample,"Tablet sample without Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID]],
			$Failed,
			Messages:>{
				Error::IncompatibleContainer,
				Error::InvalidInput
			}
		],
		Example[{Messages,"IncompatibleContainer","If MeasureTotalWeight is set to True, the sample needs to be in a container that is compatible with ExperimentMeasureWeight (MeasureWeightContainerP) even if the Mass is known:"},
			ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID],MeasureTotalWeight->True],
			$Failed,
			Messages:>{
				Error::IncompatibleContainer,
				Error::InvalidInput,
				(* since MeasureTotalWeight is set to True while Mass is known, we'll also get the MassKnown warning message *)
				Warning::MassKnown
			}
		],

    Example[{Messages,"EmptyContainers","Prints a message and returns $Failed if given any empty containers:"},
      ExperimentMeasureCount[{
        Object[Container,Vessel,"Empty 50ml container 9 for ExperimentMeasureCount testing"<>$SessionUUID],
        Object[Container,Vessel,"Empty 50ml container 10 for ExperimentMeasureCount testing"<>$SessionUUID]
       }
      ],
      $Failed,
      Messages:>{Error::EmptyContainers}
    ],

    (* Option Resolution *)
		Example[{Options,ParameterizeTablets,"ParameterizeTablets resolves to True if TabletParameterizationReplicates is specified by the user:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->15,Output->Options],ParameterizeTablets],
			True
		],
		Example[{Options,ParameterizeTablets,"ParameterizeTablets resolves to False if TabletParameterizationReplicates is not specified by the user and the TabletWeight is known:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],ParameterizeTablets],
			False
		],
		Example[{Options,ParameterizeTablets,"ParameterizeTablets resolves to True if TabletParameterizationReplicates is not specified by the user and the TabletWeight is not known:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],ParameterizeTablets],
			True
		],
		Example[{Options,ParameterizeTablets,"If ParameterizeTablets is set to True and TabletParameterizationReplicates is specified by the user, we will parameterize:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->15,Output->Options],ParameterizeTablets],
			True
		],
		Example[{Options,ParameterizeTablets,"If ParameterizeTablets is set to True and TabletParameterizationReplicates is specified by the user, we will parameterize even if the TabletWeight is known:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],TabletParameterizationReplicates->15,Output->Options],ParameterizeTablets],
			True,
			Messages:>{
				Warning::TabletWeightKnown
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
		],
		Example[{Options,ParameterizeTablets,"If ParameterizeTablets is set to False, we will not parameterize:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],ParameterizeTablets],
			False
		],
		Example[{Options,TabletParameterizationReplicates,"Specify the number of tablets used for parameterization by specifying the option TabletParameterizationReplicates:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options,TabletParameterizationReplicates->20],TabletParameterizationReplicates],
			20
		],
		Example[{Options,TabletParameterizationReplicates,"TabletParameterizationReplicates automatically resolves to 10 if not specified and we need to parameterize:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],TabletParameterizationReplicates],
			10
		],
		Example[{Options,TabletParameterizationReplicates,"TabletParameterizationReplicates automatically resolves to Null if not specified and we don't need to parameterize:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],TabletParameterizationReplicates],
			Null
		],
		Example[{Options,MeasureTotalWeight,"Specify whether the total mass measurement should be performed:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],MeasureTotalWeight->True,Output->Options],MeasureTotalWeight],
			True
		],
		Example[{Options,MeasureTotalWeight,"MeasureTotalWeight automatically resolves to True if the sample's mass is unknown:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],MeasureTotalWeight],
			True
		],
		Example[{Options,MeasureTotalWeight,"MeasureTotalWeight automatically resolves to False if the sample's mass is known:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],MeasureTotalWeight],
			False
		],
		Example[{Options,MeasureTotalWeight,"If MeasureTotalWeight is set to True although the mass is known, the total weight is measured and the previous mass measurement is overwritten:"},
			Lookup[ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID],MeasureTotalWeight->True,Output->Options],MeasureTotalWeight],
			True,
			Messages:>{
				Warning::MassKnown
			}
		],

    Example[{Options,Name,"Give the protocol to be created a unique identifier which can be used instead of its ID:"},
      Download[
        ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],
          Name->"My Favorite MeasureCount protocol"<>$SessionUUID],
        Name
      ],
      "My Favorite MeasureCount protocol"<>$SessionUUID,
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

    Example[{Options,Confirm,"Indicate that the protocol should be moved directly into the queue:"},
      Download[
        ExperimentMeasureCount[Object[Sample, "Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Confirm->True],
        Status
      ],
		Processing|ShippingMaterials|Backlogged,
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False,
				$DeveloperSearch=True
			}
    ],

    Example[{Options,NumberOfReplicates,"Indicate that each measurement should be repeated 3 times and the results should be averaged:"},
      Download[
        ExperimentMeasureCount[
          {
            Object[Sample, "Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
            Object[Sample, "Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]
          },
          NumberOfReplicates->3
        ],
        SamplesIn[Name]
      ],
      {"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID,
        "Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID,
        "Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID,
        "Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID,
        "Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID,
        "Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID
      },
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

    Example[{Options,Template,"Indicate that all the same options used for a previous protocol should be used again for the current protocol:"},
      Module[{templateMCProtocol,repeatProtocol},
      (* Create an initial protocol *)
        templateMCProtocol=ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
          ParameterizeTablets->True,
          TabletParameterizationReplicates->15,
          MeasureTotalWeight->True
        ];

        (* Create another protocol which will exactly repeat the first, for a different sample though *)
        repeatProtocol=ExperimentMeasureCount[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID],Template->templateMCProtocol];

        Lookup[
          Download[{templateMCProtocol,repeatProtocol},ResolvedOptions],
          {ParameterizeTablets,TabletParameterizationReplicates,MeasureTotalWeight}
        ]
      ],
      {
        {True,15,True},
        {True,15,True}
      },
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
      Lookup[ExperimentMeasureCount[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID],
        SamplesInStorageCondition -> Refrigerator, Output->Options],SamplesInStorageCondition],
      Refrigerator
    ],

    (* Test the Output option *)
		Test["Specifying Output->Tests returns a list of tests:",
			ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Tests],
			{_EmeraldTest..}
		],
		Test["Specifying Output->Options returns a list of resolved options:",
			ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],Output->Options],
			{
					OrderlessPatternSequence[
						ParameterizeTablets -> True,
						TabletParameterizationReplicates -> 10,
						MeasureTotalWeight -> True,
						(_ -> False|Null|Last )..
					]
				}
		],

		(* Test the resource packet function *)
		Test["The protocol packet is populated properly for a single sample needing parameterization and total mass measurement :",
			myProtocol=ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]]},
				{LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]]},
				{10},
				{LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]]}

			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
		],

		Test["If no sample needs parameterization, parameterization related fields in the protocol packet are not populated:",
			myProtocol=ExperimentMeasureCount[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{LinkP[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]]},
				{},
				{},
				{LinkP[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]]}

			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],

		Test["If no sample needs total weight measurement, total weight related fields in the protocol packet are not populated:",
			myProtocol=ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID]];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{LinkP[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID]]},
				{LinkP[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID]]},
				{10},
				{}
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],

		Test["The protocol packet is populated properly for multiple samples needing parameterization and total mass measurement:",
			myProtocol=ExperimentMeasureCount[
				{
					Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID]
				}
			];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{10,10,10},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID]]
				}

			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],
		Test["The protocol packet is populated properly for multiple samples needing parameterization and/or total mass measurement :",
			myProtocol=ExperimentMeasureCount[
				{
					Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]
				}
			];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{10,10,10},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]]
				}
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],
		Test["If NumberOfReplicates is specified, the respective fields in the protocol packet are expanded correctly:",
			myProtocol=ExperimentMeasureCount[
				{
					Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]
				},
				NumberOfReplicates->3
			];
			Download[myProtocol,{SamplesIn,TabletWeightParameterizations,TabletParameterizationReplicates,TotalWeightMeasurementSamples}],
			{
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]]
				},
				{10,10,10,10,10,10},
				{
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]],
					LinkP[Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]]
				}

			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],

		Test["The materials resources are populated properly:",
			myProtocol=ExperimentMeasureCount[
				{
					Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
					Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID]
				},
				NumberOfReplicates->2
			];
			Download[myProtocol,{Tweezer,Balance,WeighBoat}],
			{
				LinkP[Model[Item,Tweezer,"id:8qZ1VWNwNDVZ"]],
				LinkP[Model[Instrument, Balance, "id:vXl9j5qEnav7"]],
				LinkP[Model[Item,Consumable,"id:Vrbp1jG80zRw"]]
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
		],

		Test["When no sample needs tablet parameterization, the materials fields for parameterization are empty:",
			myProtocol=ExperimentMeasureCount[
				{
					Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID]
				},
				NumberOfReplicates->3
			];
			Download[myProtocol,{Tweezer,Balance,WeighBoat}],
			{
				Null,
				Null,
				Null
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			},
			Variables:>{myProtocol}
    ],

    Test["If no total weight measurement is performed (for instance because the Mass is known), the sample can be in a container that is incompatible with ExperimentMeasureWeight (MeasureWeightContainerP):",
      ExperimentMeasureCount[Object[Sample,"Tablet sample with Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID]],
      ObjectP[Object[Protocol,MeasureCount]],
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				$EmailEnabled=False
			}
    ],

		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			myOptions = ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[myOptions, ImageSample],
			True,
			Variables:>{myOptions}
    ],

		Test["Does not populate MeasureVolume or MeasureWeight:",
			Download[
				ExperimentMeasureCount[Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID], ImageSample -> True],
				{MeasureVolume,MeasureWeight}
			],
			{Null,Null}
		]

	},
	SymbolSetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects={
				Object[Container,Vessel,"Empty 50ml container 1 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 3 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 4 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 5 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 6 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 7 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 8 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 9 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 10 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 11 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container (with special sample without model) for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 15ml container for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml transfer container for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Vessel,"50ml transfer container with water for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Plate,"Empty 96-well plate for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Plate,"Enormous multiple-position container for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Container,Bag,"Empty bag for tips for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Special tablet sample without Model for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Discarded tablet sample for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Non-chemical sample for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Non-tablet sample for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Water sample in transfer container for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample without Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample with Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Tablet sample in enormous measure weight incompatible container for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Non-tablet sample in plate for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample, "Discarded sample in plate for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[User,Emerald,"Operator for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Sample,"Available tablet sample without TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID],
				Object[Protocol,MeasureCount,"My Favorite MeasureCount protocol"<>$SessionUUID],
				Object[Container,Shelf,"Test Shelf for Weigh boats for ExperimentMeasureCount"<>$SessionUUID],
				Object[Item,Consumable,"Weighboats for MeasureWeight subprotocols 1"<>$SessionUUID]

			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainerSpecial,
			emptyPlate,crazyBigContainer,stockSolutionContainer,operator,fakeShelf,
			availableSample1,discardedSample,specialNoModelSample,nonTabletSample,hasMassSample,hasCountSample,
			hasTabletWeightSample,availableSample2,availableSample3,sampleInPlateWithNoMass,
			sampleInPlateWithMass,sampleInCrazyBigContainer,nonChemicalSample,nonTabletSampleInPlate,
			discardedSampleInPlate,sampleWithoutTabletWeight,fakeWeighBoat1},
			(* Create some empty containers and a test operator *)
			{emptyContainer1,emptyContainer2,emptyContainer3,emptyContainer4,emptyContainer5,emptyContainer6,emptyContainer7,emptyContainer8,emptyContainer9,emptyContainer10,emptyContainerSpecial,
				emptyPlate,crazyBigContainer,stockSolutionContainer,operator,fakeShelf}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 1 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 2 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 3 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 4 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 5 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 6 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 7 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 8 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 9 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 10 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container (with special sample without model) for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 96-well plate for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"25L Polypropylene Carboy for ExperimentMeasureCount testing"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Enormous multiple-position container for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Empty 50ml container 11 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[User,Emerald],Model->Link[Model[User, Emerald, Operator, "Level 1"],Objects],DeveloperObject->True,Name->"Operator for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Type->Object[Container,Shelf],Model->Link[Model[Container, Shelf, "id:qdkmxz0A886V"],Objects],Site->Link[$Site],DeveloperObject->True,Name->"Test Shelf for Weigh boats for ExperimentMeasureCount"<>$SessionUUID|>
			}];

			(* Create some tablet samples *)
			{availableSample1,
				discardedSample,
				specialNoModelSample,
				nonTabletSample,
				hasMassSample,
				hasCountSample,
				hasTabletWeightSample,
				availableSample2,
				availableSample3,
				sampleInPlateWithNoMass,
				sampleInPlateWithMass,
				sampleInCrazyBigContainer,
				nonChemicalSample,
				nonTabletSampleInPlate,
				discardedSampleInPlate,
				sampleWithoutTabletWeight,
				fakeWeighBoat1
			}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 10 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample, "Test Count Model 4 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,StockSolution,"Fake 70% Ethanol model for ExperimentMeasureWeight testing"],
					Model[Sample,"Test Count Model 10 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 13 for MeasureCount"],
					Model[Item,Consumable,"id:Vrbp1jG80zRw"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainerSpecial},
					{"A1",emptyContainer3},
					{"A1",emptyContainer4},
					{"A1",emptyContainer5},
					{"A1",emptyContainer6},
					{"A1",emptyContainer7},
					{"A1",emptyContainer8},
					{"A1",emptyPlate},
					{"A2",emptyPlate},
					{"A1",crazyBigContainer},
					{"A1",stockSolutionContainer},
					{"A3",emptyPlate},
					{"A4",emptyPlate},
					{"A1",emptyContainer10},
					{"A1",fakeShelf}
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->availableSample1,DeveloperObject->True,Status->Available,Name->"Available tablet sample 1 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->availableSample2,DeveloperObject->True,Status->Available,Name->"Available tablet sample 2 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->availableSample3,DeveloperObject->True,Status->Available,Name->"Available tablet sample 3 for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->discardedSample,DeveloperObject->True,Status->Discarded,Name->"Discarded tablet sample for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->specialNoModelSample,DeveloperObject->True,Status->Available,Model->Null,Name->"Special tablet sample without Model for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->nonTabletSample,DeveloperObject->True,Status->Available,Name->"Non-tablet sample for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->hasMassSample,DeveloperObject->True,Status->Available,Mass->2.5*Gram,Name->"Tablet sample with Mass for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->hasCountSample,DeveloperObject->True,Status->Available,Count->50,Name->"Tablet sample with Count for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->hasTabletWeightSample,DeveloperObject->True,Status->Available,Name->"Tablet sample with TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->sampleInPlateWithNoMass,DeveloperObject->True,Status->Available,Name->"Tablet sample without Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->sampleInPlateWithMass,DeveloperObject->True,Status->Available,Mass->5*Gram,Name->"Tablet sample with Mass in plate for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->sampleInCrazyBigContainer,DeveloperObject->True,Status->Available,Name->"Tablet sample in enormous measure weight incompatible container for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->nonChemicalSample,DeveloperObject->True,Status->Available,Name->"Non-chemical sample for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->discardedSampleInPlate,DeveloperObject->True,Status->Discarded,Name->"Discarded sample in plate for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->nonTabletSampleInPlate,DeveloperObject->True,Status->Available,Name->"Non-tablet sample in plate for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->sampleWithoutTabletWeight,DeveloperObject->True,Status->Available,Name->"Available tablet sample without TabletWeight for ExperimentMeasureCount testing"<>$SessionUUID|>,
				<|Object->fakeWeighBoat1,DeveloperObject->True,Count->100,Status->Available,Name->"Weighboats for MeasureWeight subprotocols 1"<>$SessionUUID|>
			}]
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True]
	}
];

(* ::Subsubsection:: *)
(*ExperimentMeasureCountOptions*)

DefineTests[
	ExperimentMeasureCountOptions,
	{
	(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureCount call to measure the count of a single sample:"},
			ExperimentMeasureCountOptions[Object[Sample, "Test Count Sample 1 for MeasureCount options function testing"<>$SessionUUID]],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureCount call to measure the count of multiple samples:"},
			ExperimentMeasureCountOptions[{
				Object[Sample, "Test Count Sample 1 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 2 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 3 for MeasureCount options function testing"<>$SessionUUID]
			}],
			_Grid
		],
		Example[
			{Basic, "Generate a table of resolved options for an ExperimentMeasureCount call to measure the count of a sample in a container:"},
			ExperimentMeasureCountOptions[Object[Container, Vessel, "Test Container 1 for MeasureCount options function testing"<>$SessionUUID]],
			_Grid
		],

	(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Generate a list of resolved options for an ExperimentMeasureCount call to measure the count of multiple samples:"},
			ExperimentMeasureCountOptions[{
				Object[Sample, "Test Count Sample 1 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 2 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 3 for MeasureCount options function testing"<>$SessionUUID]
			}, OutputFormat->List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentMeasureCount, #], $Failed, {Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects={
				Object[Container,Vessel,"Empty 50ml container 1 for MeasureCount options function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for MeasureCount options function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 3 for MeasureCount options function testing"<>$SessionUUID],
				Object[Container,Vessel,"Test Container 1 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 1 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 2 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 3 for MeasureCount options function testing"<>$SessionUUID],
				Object[Sample,"Test Container with sample for MeasureCount options function testing"<>$SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer1,emptyContainer2,emptyContainer3,testContainer,testSample1,testSample2,testSample3,testContainerSample},
			(* Create some empty containers and a test operator *)
			{emptyContainer1,emptyContainer2,emptyContainer3,testContainer}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 1 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 2 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 3 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Test Container 1 for MeasureCount options function testing"<>$SessionUUID|>
			}];

			(* Create some tablet samples *)
			{testSample1,testSample2,testSample3,testContainerSample}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 2 for MeasureCount"],
					Model[Sample,"Test Count Model 3 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",testContainer}
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->testSample1,DeveloperObject->True,Status->Available,Name->"Test Count Sample 1 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Object->testSample2,DeveloperObject->True,Status->Available,Name->"Test Count Sample 2 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Object->testSample3,DeveloperObject->True,Status->Available,Name->"Test Count Sample 3 for MeasureCount options function testing"<>$SessionUUID|>,
				<|Object->testContainerSample,DeveloperObject->True,Status->Available,Name->"Test Container with sample for MeasureCount options function testing"<>$SessionUUID|>
			}]
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True]
	}

];

(* ::Subsubsection:: *)
(*ExperimentMeasureCountPreview*)

DefineTests[
	ExperimentMeasureCountPreview,
	{
	(* --- Basic Examples --- *)
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureCount call to measure count of a single sample (will always be Null):"},
			ExperimentMeasureCountPreview[Object[Sample, "Test Count Sample 1 for MeasureCount preview function testing"<>$SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureCount call to measure count of a multiple sample (will always be Null):"},
			ExperimentMeasureCountPreview[{
				Object[Sample, "Test Count Sample 1 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 2 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 3 for MeasureCount preview function testing"<>$SessionUUID]
			}],
			Null
		],
		Example[
			{Basic, "Generate a preview for an ExperimentMeasureCount call to measure count of a sample in a container (will always be Null):"},
			ExperimentMeasureCountPreview[Object[Container, Vessel, "Test Container 1 for MeasureCount preview function testing"<>$SessionUUID]],
			Null
		]
	},
	SymbolSetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects={
				Object[Container,Vessel,"Empty 50ml container 1 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 3 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Container,Vessel,"Test Container 1 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 1 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 2 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 3 for MeasureCount preview function testing"<>$SessionUUID],
				Object[Sample,"Test Container with sample for MeasureCount preview function testing"<>$SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer1,emptyContainer2,emptyContainer3,testContainer,testSample1,testSample2,testSample3,testContainerSample},
			(* Create some empty containers and a test operator *)
			{emptyContainer1,emptyContainer2,emptyContainer3,testContainer}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 1 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 2 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 3 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Test Container 1 for MeasureCount preview function testing"<>$SessionUUID|>
			}];

			(* Create some tablet samples *)
			{testSample1,testSample2,testSample3,testContainerSample}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 2 for MeasureCount"],
					Model[Sample,"Test Count Model 3 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",testContainer}
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->testSample1,DeveloperObject->True,Status->Available,Name->"Test Count Sample 1 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Object->testSample2,DeveloperObject->True,Status->Available,Name->"Test Count Sample 2 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Object->testSample3,DeveloperObject->True,Status->Available,Name->"Test Count Sample 3 for MeasureCount preview function testing"<>$SessionUUID|>,
				<|Object->testContainerSample,DeveloperObject->True,Status->Available,Name->"Test Container with sample for MeasureCount preview function testing"<>$SessionUUID|>
			}]
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True]
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentMeasureCountQ*)


DefineTests[
	ValidExperimentMeasureCountQ,
	{
	(* --- Basic Examples --- *)
		Example[
			{Basic, "Validate an ExperimentMeasureCount call to measure the count of a single sample:"},
		ValidExperimentMeasureCountQ[Object[Sample, "Test Count Sample 1 for MeasureCount ValidQ function testing"<>$SessionUUID]],
			True
		],
		Example[
			{Basic, "Validate an ExperimentMeasureCount call to measure the count multiple samples:"},
			ValidExperimentMeasureCountQ[{
				Object[Sample, "Test Count Sample 1 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 2 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample, "Test Count Sample 3 for MeasureCount ValidQ function testing"<>$SessionUUID]
			}],
			True
		],
		Example[
			{Basic, "Validate an ExperimentMeasureCount call to filter to measure the count of a sample in a container:"},
			ValidExperimentMeasureCountQ[Object[Container, Vessel, "Test Container 1 for MeasureCount ValidQ function testing"<>$SessionUUID]],
			True
		],

	(* --- Options Examples --- *)
		Example[
			{Options, OutputFormat, "Validate an ExperimentMeasureCount call to measure the count a single sample, returning an ECL Test Summary:"},
			ValidExperimentMeasureCountQ[Object[Sample, "Test Count Sample 2 for MeasureCount ValidQ function testing"<>$SessionUUID], OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[
			{Options, Verbose, "Validate an ExperimentMeasureCount call to measure the count a single sample, printing a verbose summary of tests as they are run:"},
			ValidExperimentMeasureCountQ[Object[Sample, "Test Count Sample 3 for MeasureCount ValidQ function testing"<>$SessionUUID], Verbose->True],
			True
		]
	},
	SymbolSetUp:>{
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects={
				Object[Container,Vessel,"Empty 50ml container 1 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 2 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Container,Vessel,"Empty 50ml container 3 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Container,Vessel,"Test Container 1 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 1 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 2 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample,"Test Count Sample 3 for MeasureCount ValidQ function testing"<>$SessionUUID],
				Object[Sample,"Test Container with sample for MeasureCount ValidQ function testing"<>$SessionUUID]
			};
			(* Check whether the names we want to give below already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[
				PickList[
					objects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]]
		];
		Module[{emptyContainer1,emptyContainer2,emptyContainer3,testContainer,testSample1,testSample2,testSample3,testContainerSample},
			(* Create some empty containers and a test operator *)
			{emptyContainer1,emptyContainer2,emptyContainer3,testContainer}=Upload[{
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 1 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 2 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Empty 50ml container 3 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],DeveloperObject->True,Name->"Test Container 1 for MeasureCount ValidQ function testing"<>$SessionUUID|>
			}];

			(* Create some tablet samples *)
			{testSample1,testSample2,testSample3,testContainerSample}=ECL`InternalUpload`UploadSample[
				{
					Model[Sample,"Test Count Model 1 for MeasureCount"],
					Model[Sample,"Test Count Model 2 for MeasureCount"],
					Model[Sample,"Test Count Model 3 for MeasureCount"],
					Model[Sample,"Test Count Model 1 for MeasureCount"]
				},
				{
					{"A1",emptyContainer1},
					{"A1",emptyContainer2},
					{"A1",emptyContainer3},
					{"A1",testContainer}
				}
			];

			(* Make some changes to our samples for testing purposes *)
			Upload[{
				<|Object->testSample1,DeveloperObject->True,Status->Available,Name->"Test Count Sample 1 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Object->testSample2,DeveloperObject->True,Status->Available,Name->"Test Count Sample 2 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Object->testSample3,DeveloperObject->True,Status->Available,Name->"Test Count Sample 3 for MeasureCount ValidQ function testing"<>$SessionUUID|>,
				<|Object->testContainerSample,DeveloperObject->True,Status->Available,Name->"Test Container with sample for MeasureCount ValidQ function testing"<>$SessionUUID|>
			}]
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True]
	}
];



(* ::Section:: *)
(*End Test Package*)
