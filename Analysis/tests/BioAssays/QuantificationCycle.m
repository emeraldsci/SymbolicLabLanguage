(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*QuantificationCycle: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCycle*)


DefineTests[AnalyzeQuantificationCycle,
	{
		(*===Basic examples===*)
		Example[{Basic,"Given a qPCR protocol object, creates analysis object(s) for each linked qPCR data object:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"]
			],
			ConstantArray[ObjectP[Object[Analysis,QuantificationCycle]],3]
		],
		Example[{Basic,"Given a qPCR data object, creates analysis object(s) for the data object:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"]
			],
			ObjectP[Object[Analysis,QuantificationCycle]]
		],
		Example[{Basic,"Given multiple qPCR data objects, creates analysis object(s) for each data object:"},
			AnalyzeQuantificationCycle[
				{
					Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"],
					Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
					Object[Data,qPCR,"Test qPCR data2 for AnalyzeQuantificationCycle target2"]
				}
			],
			ConstantArray[ObjectP[Object[Analysis,QuantificationCycle]],3]
		],


		(*===Options tests===*)
		Example[{Options,Method,"Method can be specified:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Method->InflectionPoint,
				Output->Options
			];
			Lookup[options,Method],
			InflectionPoint,
			Variables:>{options}
		],
		Example[{Options,Domain,"Domain is automatically set to the first and last cycle from qPCR data:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Output->Options
			];
			Lookup[options,Domain],
			{1 Cycle,40 Cycle},
			Variables:>{options}
		],
		Example[{Options,BaselineDomain,"BaselineDomain is automatically set to {'the larger of 3 Cycles and the first cycle of Domain', 15 Cycle}:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Domain->{5 Cycle,40 Cycle},
				Output->Options
			];
			Lookup[options,BaselineDomain],
			{5 Cycle,15 Cycle},
			Variables:>{options}
		],
		Example[{Options,SmoothingRadius,"SmoothingRadius is automatically set to 2 cycles if Method is set to InflectionPoint:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Method->InflectionPoint,
				Output->Options
			];
			Lookup[options,SmoothingRadius],
			2 Cycle,
			Variables:>{options}
		],
		Example[{Options,ForwardPrimer,"ForwardPrimer is automatically set to unique forward primers from qPCR data if Method is set to Threshold:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Output->Options
			];
			Lookup[options,ForwardPrimer],
			{ObjectP[Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"]],ObjectP[Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycle"]]},
			Variables:>{options}
		],
		Example[{Options,ReversePrimer,"ReversePrimer is automatically set to unique reverse primers from qPCR data if Method is set to Threshold:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Output->Options
			];
			Lookup[options,ReversePrimer],
			{ObjectP[Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"]],ObjectP[Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycle"]]},
			Variables:>{options}
		],
		Example[{Options,Probe,"Probe is automatically set to unique probes from qPCR data if Method is set to Threshold:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Output->Options
			];
			Lookup[options,Probe],
			{ObjectP[Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycle"]],Null},
			Variables:>{options}
		],
		Example[{Options,Threshold,"Threshold is automatically set to 10 standard deviations above the mean fluorescence value in BaselineDomain if Method is set to Threshold:"},
			options=AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Output->Options
			];
			Lookup[options,Threshold],
			{FluorescenceUnitP,FluorescenceUnitP},
			Variables:>{options}
		],


		(*===Error messages tests===*)
		Example[{Messages,"MethodMismatch","If Method->Threshold, SmoothingRadius cannot be specified and Threshold cannot be Null; if Method->InflectionPoint, SmoothingRadius cannot be Null and Threshold cannot be specified:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				SmoothingRadius->2 Cycle
			],
			$Failed,
			Messages:>{
				Error::MethodMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ThresholdMethodTargetMissing","If Method->Threshold, ForwardPrimer and ReversePrimer cannot be Null:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				ForwardPrimer->Null,
				ReversePrimer->Null,
				Probe->Null
			],
			$Failed,
			Messages:>{
				Error::ThresholdMethodTargetMissing,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InflectionPointMethodTargetSpecified","If Method->InflectionPoint, ForwardPrimer, ReversePrimer, and Probe must be Null:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Method->InflectionPoint,
				ForwardPrimer->Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"],
				Probe->Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycle"]
			],
			$Failed,
			Messages:>{
				Error::InflectionPointMethodTargetSpecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidDomainRange","If Domain is specified, Analysis End Cycle must be greater than Analysis Start Cycle and less than or equal to the minimum end cycle among all the amplification curves for analysis:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Domain->{1 Cycle,50 Cycle}
			],
			$Failed,
			Messages:>{
				Error::InvalidDomainRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidBaselineDomainRange","If BaselineDomain is specified, Baseline End Cycle must be greater than Baseline Start Cycle and less than or equal to either Analysis End Cycle or the minimum end cycle among all the amplification curves for analysis, and Baseline Start Cycle must be greater than or equal to Analysis Start Cycle:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Domain->{5 Cycle,40 Cycle},
				BaselineDomain->{3 Cycle,15 Cycle}
			],
			$Failed,
			Messages:>{
				Error::InvalidBaselineDomainRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PrimerPairMismatch","ForwardPrimer and ReversePrimer must both be either specified or Null:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				ForwardPrimer->Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"]
			],
			$Failed,
			Messages:>{
				Error::PrimerPairMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PrimersProbeMismatch","If ForwardPrimer and ReversePrimer are specified, Probe must be either specified or Null; if ForwardPrimer and ReversePrimer are Null, Probe must also be Null:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				ForwardPrimer->Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"]
			],
			$Failed,
			Messages:>{
				Error::PrimersProbeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ProbePrimersRequired","If Probe is specified, ForwardPrimer and ReversePrimer must also be specified:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Probe->Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycle"]
			],
			$Failed,
			Messages:>{
				Error::ProbePrimersRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ForwardPrimerMissingFromqPCRData","If ForwardPrimer is specified, the primer sample(s) must exist in the qPCR data inputs:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
				ForwardPrimer->Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycle"],
				Probe->Null
			],
			$Failed,
			Messages:>{
				Error::ForwardPrimerMissingFromqPCRData,
				Error::QuantificationCycleTargetMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ReversePrimerMissingFromqPCRData","If ReversePrimer is specified, the primer sample(s) must exist in the qPCR data inputs:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
				ForwardPrimer->Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"],
				Probe->Null
			],
			$Failed,
			Messages:>{
				Error::ReversePrimerMissingFromqPCRData,
				Error::QuantificationCycleTargetMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ProbeMissingFromqPCRData","If Probe is specified, the probe sample(s) must exist in the qPCR data inputs:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
				ForwardPrimer->Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycle"],
				Probe->Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycle"]
			],
			$Failed,
			Messages:>{
				Error::ProbeMissingFromqPCRData,
				Error::QuantificationCycleTargetMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuantificationCycleTargetMismatch","If a target (ForwardPrimer, ReversePrimer, Probe) is specified, the reagents must belong in the same set:"},
			AnalyzeQuantificationCycle[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				ForwardPrimer->Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"],
				ReversePrimer->Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"],
				Probe->Null
			],
			$Failed,
			Messages:>{
				Error::QuantificationCycleTargetMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidThresholdLength","If Threshold is specified, it must be either a singleton or a list matching the number of unique targets in the qPCR data:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
				Threshold->{2 RFU,3 RFU}
			],
			$Failed,
			Messages:>{
				Error::InvalidThresholdLength,
				Error::InvalidOption
			}
		],
		Example[{Messages,"QuantificationCycleNotFound","If no quantification cycle within the amplification range is found, a warning is thrown:"},
			AnalyzeQuantificationCycle[
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"]
			],
			ObjectP[Object[Analysis,QuantificationCycle]],
			SetUp:>(
				Upload[<|
					Object->Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"],
					Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.01},{2,0},{3,0.02},{4,-0.01},{5,0.01},{6,0},{7,-0.02},{8,0.02},{9,0.02},{10,0.01},{11,0},{12,-0.02},{13,0.02},{14,0.01},{15,0},{16,0.02},{17,0},{18,0.02},{19,0},{20,-0.01},{21,0.02},{22,0},{23,0.01},{24,0},{25,0.03},{26,0.02},{27,0},{28,0.03},{29,0},{30,0.01},{31,-0.02},{32,0},{33,0.01},{34,0.02},{35,0.005},{36,0.01},{37,0.02},{38,0},{39,0.01},{40,0.01}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}]
				|>];
			),
			TearDown:>(
				Upload[<|
					Object->Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"],
					Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}]
				|>];
			),
			Messages:>{
				Warning::QuantificationCycleNotFound
			}
		],
		Test["Given a protocol started from an ArrayCard, thresholding groups by Model instead of by Sample, since multiple samples may have the same probes+primers:",
			Lookup[
				stripAppendReplaceKeyHeads@AnalyzeQuantificationCycle[
					Object[Protocol,qPCR,"Test protocol with array card for AnalyzeQuantificationCycle"],
    			Upload -> False
				],
				{ForwardPrimer,ReversePrimer,Probe,Threshold}
			]/.{lnk:_Link:>lnk[Object]},
			{
				{
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"][Object],
					Quantity[0.982228, IndependentUnit["Rfus"]]
				},
				{
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"][Object],
					Quantity[0.982228, IndependentUnit["Rfus"]]
				},
				{
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"][Object],
					Model[Molecule, Oligomer, "Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"][Object],
					Quantity[0.982228, IndependentUnit["Rfus"]]
				},
				{
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"][Object],
					Object[Sample, "Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"][Object],
					Model[Molecule, Oligomer, "Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"][Object],
					Quantity[1.00914, IndependentUnit["Rfus"]]
				}
			},
			EquivalenceFunction->RoundMatchQ[4]
		],
		Test["Given a protocol started from an ArrayCard, resolved options reflect threshold grouping by identity-model with duplicates removed:",
			Lookup[
				AnalyzeQuantificationCycle[
					Object[Protocol,qPCR,"Test protocol with array card for AnalyzeQuantificationCycle"],
					Output->Options,
    			Upload -> False
				],
				{ForwardPrimer,ReversePrimer,Probe,Threshold}
			]/.{lnk:_Link:>lnk[Object]},
			{
				Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"][Object],
				{
					Model[Molecule, Oligomer, "Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"][Object],
					Object[Sample, "Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"][Object]
				},
				Model[Molecule, Oligomer, "Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"][Object],
				{
					Quantity[0.982228, IndependentUnit["Rfus"]],
					Quantity[1.00914, IndependentUnit["Rfus"]]
				}
			},
			EquivalenceFunction->RoundMatchQ[4]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"],
				Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],
				Object[Data,qPCR,"Test qPCR data2 for AnalyzeQuantificationCycle target2"],
				Object[Sample,"Test Sample 1 for AnalyzeQuantificationCycle protocol with ArrayCard"],
				Object[Sample,"Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"],
				Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"],
				Object[Data,qPCR,"Test qPCR data 1 for AnalyzeQuantificationCycle protocol with ArrayCard"],
				Object[Data,qPCR,"Test qPCR data 2 for AnalyzeQuantificationCycle protocol with ArrayCard"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(*Make test samples and protocols*)
		InternalExperiment`Private`qPCRTestProtocolSetup["AnalyzeQuantificationCycle"];

		(* Make some extra test samples for ArrayCard tests. Sample 2 is missing the reverse primer. *)
		Upload[{
			<|
					Type->Object[Sample],
					Name->"Test Sample 1 for AnalyzeQuantificationCycle protocol with ArrayCard",
					Replace[Composition]->{
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"]], Now},
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"]], Now},
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"]], Now}
					},
					DeveloperObject->True
			|>,
			<|
					Type->Object[Sample],
					Name->"Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard",
					Replace[Composition]->{
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"]], Now},
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"]], Now}
					},
					DeveloperObject->True
			|>,
			<|
					Type->Object[Sample],
					Name->"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard",
					Replace[Composition]->{
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Primer Oligo Molecule 1 Forward for AnalyzeQuantificationCycle"]], Now},
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Primer Oligo Molecule 1 Reverse for AnalyzeQuantificationCycle"]], Now},
						{0.1 Molar, Link[Model[Molecule,Oligomer,"Test Probe Oligo Molecule 1 for AnalyzeQuantificationCycle"]], Now}
					},
					DeveloperObject->True
			|>
		}];

		(*Make test data objects*)
		Upload[{
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for AnalyzeQuantificationCycle target1",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for AnalyzeQuantificationCycle"],Data],
				Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycle"]],Link[Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycle"]]}},ConstantArray[{Null,Null},20]],
				Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycle"]]},21,Null],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:XnlV5jKAO6YN"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data1 for AnalyzeQuantificationCycle target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for AnalyzeQuantificationCycle"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycle"]],Link[Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycle"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:54n6evLRWZaY"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.46907},{2,0.493398},{3,0.505747},{4,0.511516},{5,0.515978},{6,0.521776},{7,0.523798},{8,0.534346},{9,0.536489},{10,0.543179},{11,0.548984},{12,0.564136},{13,0.587953},{14,0.635332},{15,0.716437},{16,0.873038},{17,1.14659},{18,1.55494},{19,2.03587},{20,2.51818},{21,2.97565},{22,3.39742},{23,3.7925},{24,4.14796},{25,4.46212},{26,4.7039},{27,4.97237},{28,5.2066},{29,5.38272},{30,5.54788},{31,5.73191},{32,5.85828},{33,6.01228},{34,6.1128},{35,6.21402},{36,6.32745},{37,6.42922},{38,6.47589},{39,6.56295},{40,6.61548}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data2 for AnalyzeQuantificationCycle target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for AnalyzeQuantificationCycle"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycle"]],Link[Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycle"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data 1 for AnalyzeQuantificationCycle protocol with ArrayCard",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for AnalyzeQuantificationCycle"],Data],
				Replace[Primers]->{
					{Link[Object[Sample,"Test Sample 1 for AnalyzeQuantificationCycle protocol with ArrayCard"]], Link[Object[Sample,"Test Sample 1 for AnalyzeQuantificationCycle protocol with ArrayCard"]]},
					{Link[Object[Sample,"Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"]], Link[Object[Sample,"Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"]]}
				},
				Replace[Probes]->{
					Link[Object[Sample,"Test Sample 1 for AnalyzeQuantificationCycle protocol with ArrayCard"]],
					Link[Object[Sample,"Test Sample 2 for AnalyzeQuantificationCycle protocol with ArrayCard"]]
				},
				Replace[ExcitationWavelengths]->{470.,470.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.} Nanometer,
				Replace[AmplificationCurveTypes]->{Unused,PrimaryAmplicon},
				Replace[AmplificationCurves]->{
					QuantityArray[
						{#[[1]],#[[2]]+1.0}&/@{
							{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},
							{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},
							{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}
						},
						{None,RFU}
					],
					QuantityArray[
						{#[[1]],#[[2]]-0.2}&/@{
							{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},
							{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},
							{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}
						},
						{None,RFU}
					]
				},
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data 2 for AnalyzeQuantificationCycle protocol with ArrayCard",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for AnalyzeQuantificationCycle"],Data],
				Replace[Primers]->{
					{Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]], Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]]},
					{Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]], Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]]}
				},
				Replace[Probes]->{
					Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]],
					Link[Object[Sample,"Test Sample 3 for AnalyzeQuantificationCycle protocol with ArrayCard"]]
				},
				Replace[ExcitationWavelengths]->{470.,470.} Nanometer,
				Replace[EmissionWavelengths]->{520.,520.} Nanometer,
				Replace[AmplificationCurveTypes]->{Unused,Unused},
				Replace[AmplificationCurves]->{
					QuantityArray[
						{
							{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},
							{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},
							{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}
						},
						{None,RFU}
					],
					QuantityArray[
						{
							{1,0.444124},{2,0.460555},{3,0.465152},{4,0.471081},{5,0.475303},{6,0.479624},{7,0.480211},{8,0.487465},{9,0.490427},{10,0.504163},{11,0.519415},{12,0.53833},{13,0.582165},{14,0.663417},{15,0.816901},
							{16,1.09213},{17,1.52884},{18,2.06853},{19,2.63047},{20,3.14602},{21,3.65078},{22,4.12188},{23,4.52009},{24,4.86981},{25,5.19369},{26,5.46031},{27,5.72132},{28,5.93092},{29,6.14026},{30,6.29707},
							{31,6.44814},{32,6.59431},{33,6.71977},{34,6.80241},{35,6.91043},{36,6.97861},{37,7.08597},{38,7.15183},{39,7.24419},{40,7.27548}
						},
						{None,RFU}
					]
				},
				DeveloperObject->True
			|>
		}];

		Upload[{
			<|
				Object->Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycle"],
				Replace[Data]->{
					Link[Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycle target1"],Protocol],
					Link[Object[Data,qPCR,"Test qPCR data1 for AnalyzeQuantificationCycle target2"],Protocol],
					Link[Object[Data,qPCR,"Test qPCR data2 for AnalyzeQuantificationCycle target2"],Protocol]
				}
			|>,
			<|
				Object->Object[Protocol,qPCR,"Test protocol with array card for AnalyzeQuantificationCycle"],
				Replace[Data]->{
					Link[Object[Data,qPCR,"Test qPCR data 1 for AnalyzeQuantificationCycle protocol with ArrayCard"],Protocol],
					Link[Object[Data,qPCR,"Test qPCR data 2 for AnalyzeQuantificationCycle protocol with ArrayCard"],Protocol]
				}
			|>
		}];
	),


	SymbolTearDown:>(
		Module[{existingObjs},
			existingObjs = PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]];
			(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
			EraseObject[DeleteCases[existingObjs, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		]
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCycleOptions*)


DefineTests[AnalyzeQuantificationCycleOptions,
	{
		Example[{Basic,"Given a qPCR protocol object, returns the options in table form:"},
			AnalyzeQuantificationCycleOptions[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycleOptions"]
			],
			_Grid
		],
		Example[{Basic,"Given a qPCR data object, returns the options in table form:"},
			AnalyzeQuantificationCycleOptions[
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycleOptions target1"]
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat->List, returns the options as a list of rules:"},
			AnalyzeQuantificationCycleOptions[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycleOptions"],
				OutputFormat->List
			],
			{_Rule..}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycleOptions target1"],
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycleOptions target2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(*Make test samples and protocols*)
		InternalExperiment`Private`qPCRTestProtocolSetup["AnalyzeQuantificationCycleOptions"];

		(*Make test data objects*)
		Upload[{
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for AnalyzeQuantificationCycleOptions target1",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for AnalyzeQuantificationCycleOptions"],Data],
				Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCycleOptions"]],Link[Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCycleOptions"]]}},ConstantArray[{Null,Null},20]],
				Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for AnalyzeQuantificationCycleOptions"]]},21,Null],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:XnlV5jKAO6YN"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for AnalyzeQuantificationCycleOptions target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for AnalyzeQuantificationCycleOptions"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCycleOptions"]],Link[Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCycleOptions"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:R8e1PjpVYNAn"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.493786},{2,0.502046},{3,0.499624},{4,0.501586},{5,0.498051},{6,0.501054},{7,0.501221},{8,0.500282},{9,0.501595},{10,0.506033},{11,0.504592},{12,0.507292},{13,0.514335},{14,0.52336},{15,0.541361},{16,0.582574},{17,0.650975},{18,0.7928},{19,1.04501},{20,1.41341},{21,1.82388},{22,2.21441},{23,2.58961},{24,2.94192},{25,3.27823},{26,3.58216},{27,3.83189},{28,4.09429},{29,4.31557},{30,4.49915},{31,4.68479},{32,4.85591},{33,5.00987},{34,5.15585},{35,5.27472},{36,5.38572},{37,5.48713},{38,5.57658},{39,5.67275},{40,5.76248}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>
		}];

		Upload[<|
			Object->Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCycleOptions"],
			Replace[Data]->{
				Link[Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycleOptions target1"],Protocol],
				Link[Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCycleOptions target2"],Protocol]
			}
		|>];
	),


	SymbolTearDown:>(
		Module[{existingObjs},
			existingObjs = PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]];
			(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
			EraseObject[DeleteCases[existingObjs, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeQuantificationCyclePreview*)


DefineTests[AnalyzeQuantificationCyclePreview,
	{
		Example[{Basic,"Given a qPCR protocol object, returns the graphical preview:"},
			AnalyzeQuantificationCyclePreview[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCyclePreview"]
			],
			ValidGraphicsP[]
		],
		Example[{Basic,"Given a qPCR data object, returns the graphical preview:"},
			AnalyzeQuantificationCyclePreview[
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCyclePreview target1"]
			],
			ValidGraphicsP[]
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCyclePreview target1"],
				Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCyclePreview target2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(*Make test samples and protocols*)
		InternalExperiment`Private`qPCRTestProtocolSetup["AnalyzeQuantificationCyclePreview"];

		(*Make test data objects*)
		Upload[{
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for AnalyzeQuantificationCyclePreview target1",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for AnalyzeQuantificationCyclePreview"],Data],
				Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for AnalyzeQuantificationCyclePreview"]],Link[Object[Sample,"Test Primer 1 Reverse for AnalyzeQuantificationCyclePreview"]]}},ConstantArray[{Null,Null},20]],
				Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for AnalyzeQuantificationCyclePreview"]]},21,Null],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:XnlV5jKAO6YN"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for AnalyzeQuantificationCyclePreview target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for AnalyzeQuantificationCyclePreview"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for AnalyzeQuantificationCyclePreview"]],Link[Object[Sample,"Test Primer 2 Reverse for AnalyzeQuantificationCyclePreview"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:R8e1PjpVYNAn"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.493786},{2,0.502046},{3,0.499624},{4,0.501586},{5,0.498051},{6,0.501054},{7,0.501221},{8,0.500282},{9,0.501595},{10,0.506033},{11,0.504592},{12,0.507292},{13,0.514335},{14,0.52336},{15,0.541361},{16,0.582574},{17,0.650975},{18,0.7928},{19,1.04501},{20,1.41341},{21,1.82388},{22,2.21441},{23,2.58961},{24,2.94192},{25,3.27823},{26,3.58216},{27,3.83189},{28,4.09429},{29,4.31557},{30,4.49915},{31,4.68479},{32,4.85591},{33,5.00987},{34,5.15585},{35,5.27472},{36,5.38572},{37,5.48713},{38,5.57658},{39,5.67275},{40,5.76248}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>
		}];

		Upload[<|
			Object->Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for AnalyzeQuantificationCyclePreview"],
			Replace[Data]->{
				Link[Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCyclePreview target1"],Protocol],
				Link[Object[Data,qPCR,"Test qPCR data for AnalyzeQuantificationCyclePreview target2"],Protocol]
			}
		|>];
	),


	SymbolTearDown:>(
		Module[{existingObjs},
			existingObjs = PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]];
			(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
			EraseObject[DeleteCases[existingObjs, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeQuantificationCycleQ*)


DefineTests[ValidAnalyzeQuantificationCycleQ,
	{
		Example[{Basic,"Given a qPCR protocol object, returns a Boolean indicating the validity of the analysis setup:"},
			ValidAnalyzeQuantificationCycleQ[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for ValidAnalyzeQuantificationCycleQ"]
			],
			True
		],
		Example[{Basic,"Given a qPCR data object, returns a Boolean indicating the validity of the analysis setup:"},
			ValidAnalyzeQuantificationCycleQ[
				Object[Data,qPCR,"Test qPCR data for ValidAnalyzeQuantificationCycleQ target1"]
			],
			True
		],
		Example[{Options,Verbose,"If Verbose->True, returns the passing and failing tests:"},
			ValidAnalyzeQuantificationCycleQ[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for ValidAnalyzeQuantificationCycleQ"],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat->TestSummary, returns a test summary instead of a Boolean:"},
			ValidAnalyzeQuantificationCycleQ[
				Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for ValidAnalyzeQuantificationCycleQ"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Data,qPCR,"Test qPCR data for ValidAnalyzeQuantificationCycleQ target1"],
				Object[Data,qPCR,"Test qPCR data for ValidAnalyzeQuantificationCycleQ target2"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		(*Make test samples and protocols*)
		InternalExperiment`Private`qPCRTestProtocolSetup["ValidAnalyzeQuantificationCycleQ"];

		(*Make test data objects*)
		Upload[{
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for ValidAnalyzeQuantificationCycleQ target1",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 1 for ValidAnalyzeQuantificationCycleQ"],Data],
				Replace[Primers]->Join[{{Link[Object[Sample,"Test Primer 1 Forward for ValidAnalyzeQuantificationCycleQ"]],Link[Object[Sample,"Test Primer 1 Reverse for ValidAnalyzeQuantificationCycleQ"]]}},ConstantArray[{Null,Null},20]],
				Replace[Probes]->PadRight[{Link[Object[Sample,"Test Probe 1 for ValidAnalyzeQuantificationCycleQ"]]},21,Null],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:XnlV5jKAO6YN"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[{{1,0.838366},{2,0.867461},{3,0.882255},{4,0.887922},{5,0.8991},{6,0.908386},{7,0.915779},{8,0.922756},{9,0.929573},{10,0.93254},{11,0.941931},{12,0.954241},{13,0.963869},{14,0.966802},{15,0.979435},{16,0.993327},{17,1.02214},{18,1.06643},{19,1.14886},{20,1.29975},{21,1.56968},{22,1.95918},{23,2.38847},{24,2.78532},{25,3.16301},{26,3.53637},{27,3.89258},{28,4.20981},{29,4.47358},{30,4.7301},{31,4.96325},{32,5.17179},{33,5.33801},{34,5.50773},{35,5.65007},{36,5.77216},{37,5.92374},{38,6.01616},{39,6.12867},{40,6.21872}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Data,qPCR],
				Name->"Test qPCR data for ValidAnalyzeQuantificationCycleQ target2",
				Replace[SamplesIn]->Link[Object[Sample,"Test Template 2 for ValidAnalyzeQuantificationCycleQ"],Data],
				Replace[Primers]->PadRight[{{Null,Null},{Link[Object[Sample,"Test Primer 2 Forward for ValidAnalyzeQuantificationCycleQ"]],Link[Object[Sample,"Test Primer 2 Reverse for ValidAnalyzeQuantificationCycleQ"]]}},21,{{Null,Null}}],
				Replace[Probes]->ConstantArray[Null,21],
				Replace[ExcitationWavelengths]->{470.,470.,470.,470.,470.,470.,520.,520.,520.,520.,520.,550.,550.,550.,550.,580.,580.,580.,640.,640.,662.} Nanometer,
				Replace[EmissionWavelengths]->{520.,558.,586.,623.,682.,711.,558.,586.,623.,682.,711.,586.,623.,682.,711.,623.,682.,711.,682.,711.,711.} Nanometer,
				Replace[AmplificationCurveTypes]->PadRight[{Unused,PrimaryAmplicon},21,Unused],
				(*Object[Data,qPCR,"id:R8e1PjpVYNAn"]*)
				Replace[AmplificationCurves]->PadRight[{QuantityArray[ConstantArray[{1,1},40],{None,RFU}],QuantityArray[{{1,0.493786},{2,0.502046},{3,0.499624},{4,0.501586},{5,0.498051},{6,0.501054},{7,0.501221},{8,0.500282},{9,0.501595},{10,0.506033},{11,0.504592},{12,0.507292},{13,0.514335},{14,0.52336},{15,0.541361},{16,0.582574},{17,0.650975},{18,0.7928},{19,1.04501},{20,1.41341},{21,1.82388},{22,2.21441},{23,2.58961},{24,2.94192},{25,3.27823},{26,3.58216},{27,3.83189},{28,4.09429},{29,4.31557},{30,4.49915},{31,4.68479},{32,4.85591},{33,5.00987},{34,5.15585},{35,5.27472},{36,5.38572},{37,5.48713},{38,5.57658},{39,5.67275},{40,5.76248}},{None,RFU}]},21,{QuantityArray[ConstantArray[{1,1},40],{None,RFU}]}],
				DeveloperObject->True
			|>
		}];

		Upload[<|
			Object->Object[Protocol,qPCR,"Test protocol without RT, activation, annealing, and melting curve for ValidAnalyzeQuantificationCycleQ"],
			Replace[Data]->{
				Link[Object[Data,qPCR,"Test qPCR data for ValidAnalyzeQuantificationCycleQ target1"],Protocol],
				Link[Object[Data,qPCR,"Test qPCR data for ValidAnalyzeQuantificationCycleQ target2"],Protocol]
			}
		|>];
	),


	SymbolTearDown:>(
		Module[{existingObjs},
			existingObjs = PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]];
			(* doing this because a primary cause of flaky tests is these Irregular plates showing up momentarily in other searches, and then them subsequently trying to Download from them but you can't because they've been erased already.  So just don't erase them and it'll be fine *)
			EraseObject[DeleteCases[existingObjs, ObjectP[Model[Container, Plate, Irregular]]],Force->True,Verbose->False];
		];
	)
];


(* ::Section:: *)
(*End Test Package*)
