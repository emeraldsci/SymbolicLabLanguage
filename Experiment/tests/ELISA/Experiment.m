(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentELISA: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentELISA*)


DefineTests[
	ExperimentELISA,
	{

		(* Basic examples *)
		Example[{Basic,"Accepts a sample object:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID]],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts a container with liquid sample:"},
			ExperimentELISA[Object[Container,Vessel,"ExperimentELISA test container 1" <> $SessionUUID]],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic,"Accepts multiple sample objects:"},
			ExperimentELISA[
				{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		(* Additional examples *)
		Example[{Additional,"Specify Method option to perform a desired DirectELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->DirectELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{DirectELISA,{ObjectP[]..},{},{},{}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired IndirectELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->IndirectELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{IndirectELISA,{ObjectP[]..},{ObjectP[]..},{},{}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired DirectSandwichELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->DirectSandwichELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{DirectSandwichELISA,{ObjectP[]..},{},{ObjectP[]..},{}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired IndirectSandwichELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->IndirectSandwichELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{IndirectSandwichELISA,{ObjectP[]..},{ObjectP[]..},{ObjectP[]..},{}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired DirectCompetitiveELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->DirectCompetitiveELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{DirectCompetitiveELISA,{ObjectP[]..},{},{},{ObjectP[]..}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired IndirectCompetitiveELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->IndirectCompetitiveELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{IndirectCompetitiveELISA,{ObjectP[]..},{ObjectP[]..},{},{ObjectP[]..}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Specify Method option to perform a desired FastELISA experiment. All related information is automatically resolved and populated in the protocol:"},
			protocol=ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},Method->FastELISA];
			Download[protocol,{Method,PrimaryAntibodies,SecondaryAntibodies,CaptureAntibodies,ReferenceAntigens}],
			{FastELISA,{ObjectP[]..},{},{ObjectP[]..},{}},
			Variables:>{protocol},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Perform an IndirectELISA experiment with sample coated:"},
			ExperimentELISA[{
				Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
				Object[Container,Plate,"ExperimentELISA test sample-coated plate-2" <> $SessionUUID]
			},Method->IndirectELISA,Coating->False,Blocking->False,
				(* Use larger dilution factor to make sure we have enough pipetting volume *)
				PrimaryAntibodyDilutionFactor->0.1,
				StandardPrimaryAntibodyDilutionFactor->0.1,
				BlankPrimaryAntibodyDilutionFactor->0.1,
				SecondaryAntibodyDilutionFactor->0.1,
				StandardSecondaryAntibodyDilutionFactor->0.1,
				BlankSecondaryAntibodyDilutionFactor->0.1
			],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Additional,"Perform a SandwichELISA experiment with capture antibody coated:"},
			ExperimentELISA[
				{
					Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
					Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
				},
				ELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID],
				SecondaryELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID],
				Method->DirectSandwichELISA,Coating->False,Blocking->False,
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				PrimaryAntibodyDilutionFactor->0.1,
				StandardPrimaryAntibodyDilutionFactor->0.1,
				BlankPrimaryAntibodyDilutionFactor->0.1
			],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(*Options*)

		Example[
			{Options,Method,"Defines the type of ELISA experiment to be performed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->DirectELISA,
				Output->Options
			];
			Lookup[options,Method],
			DirectELISA,
			Variables:>{options}
		],
		Example[
			{Options,TargetAntigen,"Specify the analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the samples by antibodies in the ELISA experiment. This option is used to automatically set sample Antibodies and the corresponding experiment conditions of Standards and Blanks:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				TargetAntigen->Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,{TargetAntigen,PrimaryAntibody}],
			{ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]]},
			Variables:>{options}
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of times an ELISA assay will be repeated in parallel wells:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				NumberOfReplicates->10,
				Output->Options
			];
			Lookup[options,NumberOfReplicates],
			10,
			Variables:>{options}
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of times an ELISA assay will be repeated in parallel wells. Samples, Standards, or Blanks will be loaded this number of times in the plates:"},
			packets=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Standard->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				Blank->Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"],
				NumberOfReplicates->10,
				Upload->False
			][[1]];
			Lookup[packets,{NumberOfReplicates,Replace[SamplesIn],Replace[Standards],Replace[Blanks]}],
			{
				10,
				ConstantArray[ObjectP[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID]],10],
				ConstantArray[ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],10],
				ConstantArray[ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],10]
			},
			Variables:>{options}
		],
		Example[
			{Options,WashingBuffer,"Specify the solution used to rinse off unbound molecules from the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				WashingBuffer->Model[Sample,StockSolution,"Phosphate Buffered Saline with 0.05% TWEEN 20, pH 7.4"],
				Output->Options
			];
			Lookup[options,WashingBuffer],
			ObjectP[Model[Sample,StockSolution,"Phosphate Buffered Saline with 0.05% TWEEN 20, pH 7.4"]],
			Variables:>{options}
		],
		Example[
			{Options,Spike,"Specify the Spike sample with a known concentration of analyte to be mixed with the input sample:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Spike->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]
			];
			Lookup[options,Spike],
			ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,Spike,"Spike sample can be different for each input sample:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Spike->{Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID]}
			];
			Lookup[options,Spike],
			{ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID]]},
			Variables:>{options}
		],
		Example[
			{Options,SpikeDilutionFactor,"Specify the ratio of dilution by which the Spike is mixed with the input sample before further dilution is performed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Spike->{Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]},
				SpikeDilutionFactor->0.01
			];
			Lookup[options,SpikeDilutionFactor],
			0.01,
			Variables:>{options}
		],
		Example[
			{Options,SpikeStorageCondition,"Specify the storage condition of the Spike sample after the experiment is finished:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Spike->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				SpikeStorageCondition->Refrigerator
			];
			Lookup[options,SpikeStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[
			{Options,SampleSerialDilutionCurve,"Specify the collection of step-wise serial dilutions that will be preformed on each sample:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				SampleSerialDilutionCurve->{120Microliter,{1,0.5,0.5,0.5}}
			];
			Lookup[options,{SampleSerialDilutionCurve,SampleDilutionCurve,SampleDiluent}],
			{{120Microliter,{1,0.5,0.5,0.5}},Null,ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]]},
			Variables:>{options}
		],
		Example[
			{Options,SampleDilutionCurve,"Specify the collection of dilutions that will be preformed on each sample:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA,
				SampleDilutionCurve->{{120Microliter,1},{120Microliter,0.1},{120Microliter,0.05}}
			];
			Lookup[options,{SampleSerialDilutionCurve,SampleDilutionCurve,SampleDiluent}],
			{Null,{{120Microliter,1},{120Microliter,0.1},{120Microliter,0.05}},ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]]},
			Variables:>{options}
		],
		Example[
			{Options,SampleDiluent,"Specify the buffer used to perform multiple dilutions of samples or spiked samples:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				SampleDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,SampleDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibody,"CoatingAntibody can be automatically resolved in a FastELISA experiment. The related options are also resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA
			];
			Lookup[options,{
				CoatingAntibody,CoatingAntibodyDilutionFactor,CoatingAntibodyVolume,CoatingAntibodyDiluent,CoatingAntibodyStorageCondition
			}],
			{ObjectP[Model[Sample]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibody,"Specify the sample containing the antibody that is used for coating in FastELISA. The related options are resolved automatically:"},
			(* NOTE: The input list of samples here is necessary to make sure the required antibody object volume is over 1 uL and no error is thrown. *)
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				StandardCoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				BlankCoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID]
			];
			Lookup[options,{
				CoatingAntibody,CoatingAntibodyDilutionFactor,CoatingAntibodyVolume,CoatingAntibodyDiluent,CoatingAntibodyStorageCondition
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],

		Example[
			{Options,CoatingAntibodyDilutionFactor,"Specify CoatingAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibodyDilutionFactor->0.1
			];
			Lookup[options,CoatingAntibodyDilutionFactor],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibodyVolume,"Specify CoatingAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibodyVolume->1Microliter
			];
			Lookup[options,CoatingAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibodyDiluent,"Specify CoatingAntibodyDiluent:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibodyDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,CoatingAntibodyDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibodyStorageCondition,"Specify CoatingAntibodyStorageCondition:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibodyStorageCondition->Disposal
			];
			Lookup[options,CoatingAntibodyStorageCondition],
			Disposal,
			Variables:>{options}
		],

		Example[
			{Options,CaptureAntibody,"CaptureAntibody can be automatically resolved to a sample containing the antibody that is used to pull down the antigen from sample solution to the surface of the assay plate well in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA
			];
			Lookup[options,{
				CaptureAntibody,CaptureAntibodyDilutionFactor,CaptureAntibodyVolume,CaptureAntibodyDiluent,CaptureAntibodyStorageCondition
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibody,"Specify the desired CaptureAntibody containing the antibody that is used to pull down the antigen from sample solution to the surface of the assay plate well in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				CaptureAntibody->Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID]
			];
			Lookup[options,{
				CaptureAntibody,CaptureAntibodyDilutionFactor,CaptureAntibodyVolume,CaptureAntibodyDiluent,CaptureAntibodyStorageCondition
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibodyDilutionFactor,"Specify CaptureAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				CaptureAntibodyDilutionFactor->0.01
			];
			Lookup[options,CaptureAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibodyVolume,"Specify CaptureAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				CaptureAntibodyVolume->1Microliter
			];
			Lookup[options,CaptureAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibodyDiluent,"Specify CaptureAntibodyDiluent:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				CaptureAntibodyDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,CaptureAntibodyDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibodyStorageCondition,"Specify CaptureAntibodyStorageCondition:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				CaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID],
				CaptureAntibodyStorageCondition->Disposal
			];
			Lookup[options,CaptureAntibodyStorageCondition],
			Disposal,
			Variables:>{options}
		],

		Example[
			{Options,ReferenceAntigen,"ReferenceAntigen can be automatically resolved to a sample containing the antigen used to compete with sample for PrimaryAntibody binding in DirectCompetitiveELISA or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectCompetitiveELISA
			];
			Lookup[options,{
				ReferenceAntigen,ReferenceAntigenDilutionFactor,ReferenceAntigenVolume,ReferenceAntigenDiluent,ReferenceAntigenStorageCondition
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigen,"Specify the desired ReferenceAntigen containing the antigen used to compete with sample for PrimaryAntibody binding in DirectCompetitiveELISA or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigen->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]
			];
			Lookup[options,{
				ReferenceAntigen,ReferenceAntigenDilutionFactor,ReferenceAntigenVolume,ReferenceAntigenDiluent,ReferenceAntigenStorageCondition
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigenDilutionFactor,"Specify ReferenceAntigenDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigenDilutionFactor->0.01
			];
			Lookup[options,ReferenceAntigenDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigenVolume,"Specify ReferenceAntigenVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigenVolume->1Microliter
			];
			Lookup[options,ReferenceAntigenVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigenDiluent,"Specify ReferenceAntigenDiluent:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigenDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,ReferenceAntigenDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigenStorageCondition,"Specify ReferenceAntigenStorageCondition:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigenStorageCondition->Disposal,
				StandardStorageCondition->Disposal
			];
			Lookup[options,ReferenceAntigenStorageCondition],
			Disposal,
			Variables:>{options}
		],

		Example[
			{Options,PrimaryAntibody,"PrimaryAntibody can be automatically resolved to a sample containing the antibody that directly binds with the TargetAntigen (analyte). The related options are also resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,{
				PrimaryAntibody,PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyStorageCondition
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibody,"Specify the desired PrimaryAntibody containing the antibody that directly binds with the TargetAntigen (analyte). The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				CaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID]
			];
			Lookup[options,{
				PrimaryAntibody,PrimaryAntibodyDilutionFactor,PrimaryAntibodyVolume,PrimaryAntibodyDiluent,PrimaryAntibodyStorageCondition
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]],
				Refrigerator},
			Variables:>{options}
		],

		Example[
			{Options,PrimaryAntibodyDilutionFactor,"Specify PrimaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,PrimaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyVolume,"Specify PrimaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibodyVolume->1Microliter
			];
			Lookup[options,PrimaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyDiluent,"Specify PrimaryAntibodyDiluent:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibodyDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,PrimaryAntibodyDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyStorageCondition,"Specify PrimaryAntibodyStorageCondition:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibodyStorageCondition->Disposal
			];
			Lookup[options,PrimaryAntibodyStorageCondition],
			Disposal,
			Variables:>{options}
		],

		Example[
			{Options,SecondaryAntibody,"SecondaryAntibody can be automatically resolved to a sample containing the antibody that binds to PrimaryAntibody in IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->IndirectSandwichELISA
			];
			Lookup[options,{
				SecondaryAntibody,SecondaryAntibodyDilutionFactor,SecondaryAntibodyVolume,SecondaryAntibodyDiluent,SecondaryAntibodyStorageCondition
			}],
			{ObjectP[Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]],
				0.001,
				Null,
				ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]],
				Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibody,"Specify the desired SecondaryAntibody containing the antibody that binds to PrimaryAntibody in IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]
			];
			Lookup[options,{
				SecondaryAntibody,SecondaryAntibodyDilutionFactor,SecondaryAntibodyVolume,SecondaryAntibodyDiluent,SecondaryAntibodyStorageCondition
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]],
				0.001,
				Null,
				ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]],
				Refrigerator},
			Variables:>{options}
		],

		Example[
			{Options,SecondaryAntibodyDilutionFactor,"Specify SecondaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,SecondaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyVolume,"Specify SecondaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibodyVolume->1Microliter
			];
			Lookup[options,SecondaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyDiluent,"Specify SecondaryAntibodyDiluent:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibodyDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,SecondaryAntibodyDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyStorageCondition,"Specify SecondaryAntibodyStorageCondition:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibodyStorageCondition->Disposal
			];
			Lookup[options,SecondaryAntibodyStorageCondition],
			Disposal,
			Variables:>{options}
		],

		Example[
			{Options,SampleAntibodyComplexIncubation,"Indicates if the pre-mixed sample and Antibodies should be incubated before loaded into the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				SampleAntibodyComplexIncubation->True
			];
			Lookup[options,{
				SampleAntibodyComplexIncubation,SampleAntibodyComplexIncubationTime,SampleAntibodyComplexIncubationTemperature
			}],
			{True,2Hour,Ambient},
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexIncubationTime,"Specify the duration of SampleAntibodyComplexIncubation:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				SampleAntibodyComplexIncubationTime->12Hour
			];
			Lookup[options,SampleAntibodyComplexIncubationTime],
			12Hour,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,SampleAntibodyComplexIncubationTemperature,"Specify the temperature at which SampleAntibodyComplexIncubation happens:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				SampleAntibodyComplexIncubationTemperature->40Celsius
			];
			Lookup[options,SampleAntibodyComplexIncubationTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,Coating,"Indicates if a procedure to non-specifically adsorb protein molecules to the surface of wells of an assay plate is desired. Other related options are resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True
			];
			Lookup[options,{Coating,CoatingTemperature,CoatingTime,CoatingWashVolume,CoatingNumberOfWashes}],
			{True,4Celsius,16Hour,250Microliter,3},
			Variables:>{options}
		],
		Example[
			{Options,Coating,"Set Coating to False and other related options are resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->False,
				Method->DirectSandwichELISA,
				PrimaryAntibodyDilutionFactor->0.1,
				StandardPrimaryAntibodyDilutionFactor->0.1,
				BlankPrimaryAntibodyDilutionFactor->0.1,
				ELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID]
			];
			Lookup[options,{Coating,CoatingTemperature,CoatingTime,CoatingWashVolume,CoatingNumberOfWashes}],
			{False,Null,Null,250Microliter,3},
			Variables:>{options}
		],
		Example[
			{Options,CoatingTemperature,"Specify CoatingTemperature:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True,
				CoatingTemperature->40Celsius
			];
			Lookup[options,CoatingTemperature],
			40Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CoatingTime,"Specify CoatingTime:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True,
				CoatingTime->30Minute
			];
			Lookup[options,CoatingTime],
			30Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CoatingWashVolume,"Specify CoatingWashVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True,
				CoatingWashVolume->200Microliter
			];
			Lookup[options,CoatingWashVolume],
			200Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,CoatingNumberOfWashes,"Specify CoatingNumberOfWashes:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True,
				CoatingNumberOfWashes->5
			];
			Lookup[options,CoatingNumberOfWashes],
			5,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SampleCoatingVolume,"Specify the desired amount of Sample that is aliquoted into the assay plate, in order for the Sample to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				SampleCoatingVolume->50Microliter
			];
			Lookup[options,SampleCoatingVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,"Sample Antibody/Antigen Coating options","When the type of antibody or reference antibody is applicable to the experiment and Coating is set to True, the related coating volume is automatically resolved:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Coating->True,
				Method->DirectSandwichELISA
			];
			Lookup[options,
				{
					CoatingAntibody,CoatingAntibodyCoatingVolume,ReferenceAntigen,ReferenceAntigenCoatingVolume,CaptureAntibody,CaptureAntibodyCoatingVolume
				}],
			{Null,Null,Null,Null,ObjectP[],100Microliter},
			Variables:>{options}
		],
		Example[
			{Options,CoatingAntibodyCoatingVolume,"Specify the amount of CoatingAntibody that is aliquoted into the assay plate, in order for the CoatingAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				CoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				CoatingAntibodyCoatingVolume->150Microliter,
				CoatingAntibodyDilutionFactor->0.1
			];
			Lookup[options,CoatingAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ReferenceAntigenCoatingVolume,"Specify the amount of ReferenceAntigen that is aliquoted into the assay plate, in order for the ReferenceAntigen to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigenCoatingVolume->150Microliter
			];
			Lookup[options,ReferenceAntigenCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,CaptureAntibodyCoatingVolume,"Specify the amount of diluted CaptureAntibody that is aliquoted into the assay plate, in order for the CaptureAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA,
				CaptureAntibodyCoatingVolume->150Microliter
			];
			Lookup[options,CaptureAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,Blocking,"Indicates if a protein solution should be incubated with the assay plate to prevent non-specific binding of molecules to the assay plate. Other related options are resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Blocking->True
			];
			Lookup[options,{Blocking,BlockingBuffer,BlockingVolume,BlockingTime,BlockingTemperature,BlockingMixRate,BlockingWashVolume,BlockingNumberOfWashes}],
			{True,ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]],100Microliter,1Hour,25Celsius,Null,250Microliter,3},
			Variables:>{options}
		],
		Example[
			{Options,Blocking,"Set Blocking to False and other related options are resolved automatically:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Blocking->False
			];
			Lookup[options,{Blocking,BlockingBuffer,BlockingVolume,BlockingTime,BlockingTemperature,BlockingMixRate,BlockingWashVolume,BlockingNumberOfWashes}],
			{False,Null,Null,Null,Null,Null,Null,Null},
			Variables:>{options},
			Messages:>{
				Warning::CoatingButNoBlocking
			}
		],
		Example[
			{Options,BlockingBuffer,"Specify the protein-containing solution used to prevent non-specific binding of antigen or antibody to the surface of the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Blocking->True,
				BlockingBuffer->Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			];
			Lookup[options,BlockingBuffer],
			ObjectP[Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,BlockingVolume,"Specify the desired amount of BlockingVolume that is aliquoted into the appropriate wells of the assay plate, in order to prevent non-specific binding of molecules to the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlockingVolume->50Microliter
			];
			Lookup[options,BlockingVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlockingTime,"Specify BlockingTime:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlockingTime->3Hour
			];
			Lookup[options,BlockingTime],
			3Hour,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlockingTemperature,"Specify BlockingTemperature:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlockingTemperature->40Celsius
			];
			Lookup[options,BlockingTemperature],
			40Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlockingWashVolume,"Specify BlockingWashVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlockingWashVolume->150Microliter
			];
			Lookup[options,BlockingWashVolume],
			150Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlockingNumberOfWashes,"Specify BlockingNumberOfWashes:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlockingNumberOfWashes->5
			];
			Lookup[options,BlockingNumberOfWashes],
			5,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlockingMixRate,"Specify the desired speed at which the plate is shaken during Blocking incubation if desired:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Blocking->True,
				BlockingMixRate->50RPM
			];
			Lookup[options,BlockingMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentVolume,"Specify the volume of the SampleAntibodyComplex to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentVolume->{100Microliter,150Microliter}
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentTime,"Specify the duration of SampleAntibodyComplex incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentTime->30Minute
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentTime],
			30Minute,
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentTemperature,"Specify the temperature at which the SampleAntibodyComplex incubation should happen:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentTemperature->40Celsius
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentMixRate,"Specify the speed at which the plate is shaken during SampleAntibody mixture incubation in the assay plate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentMixRate->50RPM
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentWashVolume,"Specify the volume of WashBuffer added to rinse off the unbound sample antibody mixture after SampleAntibodyComplex incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentWashVolume->150Microliter
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentWashVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,SampleAntibodyComplexImmunosorbentNumberOfWashes,"Specify the number of rinses performed after SampleAntibodyComplex incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				SampleAntibodyComplexImmunosorbentNumberOfWashes->5
			];
			Lookup[options,SampleAntibodyComplexImmunosorbentNumberOfWashes],
			5,
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentVolume,"Specify the volume of the Sample to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in sandwich ELISA:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentVolume->{100Microliter,150Microliter}
			];
			Lookup[options,SampleImmunosorbentVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentTime,"Specify the duration of Sample incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentTime->30Minute
			];
			Lookup[options,SampleImmunosorbentTime],
			30Minute,
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentTemperature,"Specify the temperature at which the Sample incubation should happen:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentTemperature->40Celsius
			];
			Lookup[options,SampleImmunosorbentTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentMixRate,"Specify the speed at which the plate is shaken during Sample incubation in the assay plate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentMixRate->50RPM
			];
			Lookup[options,SampleImmunosorbentMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentWashVolume,"Specify the volume of WashBuffer added to rinse off the unbound sample after Sample incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentWashVolume->150Microliter
			];
			Lookup[options,SampleImmunosorbentWashVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,SampleImmunosorbentNumberOfWashes,"Specify the number of rinses performed after Sample incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				SampleImmunosorbentNumberOfWashes->5
			];
			Lookup[options,SampleImmunosorbentNumberOfWashes],
			5,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentVolume,"Specify the volume of the PrimaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentVolume->{100Microliter,150Microliter}
			];
			Lookup[options,PrimaryAntibodyImmunosorbentVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentTime,"Specify the duration of PrimaryAntibody incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentTime->30Minute
			];
			Lookup[options,PrimaryAntibodyImmunosorbentTime],
			30Minute,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentTemperature,"Specify the temperature at which the PrimaryAntibody incubation should happen:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentTemperature->40Celsius
			];
			Lookup[options,PrimaryAntibodyImmunosorbentTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentMixRate,"Specify the speed at which the plate is shaken during PrimaryAntibody incubation in the assay plate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentMixRate->50RPM
			];
			Lookup[options,PrimaryAntibodyImmunosorbentMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentWashVolume,"Specify the volume of WashBuffer added to rinse off the unbound PrimaryAntibody after incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentWashVolume->150Microliter
			];
			Lookup[options,PrimaryAntibodyImmunosorbentWashVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryAntibodyImmunosorbentNumberOfWashes,"Specify the number of rinses performed after PrimaryAntibody incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				PrimaryAntibodyImmunosorbentNumberOfWashes->5
			];
			Lookup[options,PrimaryAntibodyImmunosorbentNumberOfWashes],
			5,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentVolume,"Specify the volume of the SecondaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentVolume->{100Microliter,150Microliter}
			];
			Lookup[options,SecondaryAntibodyImmunosorbentVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentTime,"Specify the duration of SecondaryAntibody incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentTime->30Minute
			];
			Lookup[options,SecondaryAntibodyImmunosorbentTime],
			30Minute,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentTemperature,"Specify the temperature at which the SecondaryAntibody incubation should happen:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentTemperature->40Celsius
			];
			Lookup[options,SecondaryAntibodyImmunosorbentTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentMixRate,"Specify the speed at which the plate is shaken during SecondaryAntibody incubation in the assay plate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentMixRate->50RPM
			];
			Lookup[options,SecondaryAntibodyImmunosorbentMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentWashVolume,"Specify the volume of WashBuffer added to rinse off the unbound SecondaryAntibody after incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentWashVolume->150Microliter
			];
			Lookup[options,SecondaryAntibodyImmunosorbentWashVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryAntibodyImmunosorbentNumberOfWashes,"Specify the number of rinses performed after SecondaryAntibody incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				SecondaryAntibodyImmunosorbentNumberOfWashes->5
			];
			Lookup[options,SecondaryAntibodyImmunosorbentNumberOfWashes],
			5,
			Variables:>{options}
		],
		Example[
			{Options,SubstrateSolution,"Specify the substrate solution binding to the enzyme conjugated to the antibody for signal detection:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SubstrateSolution->Model[Sample,"ELISA TMB Stabilized Chromogen"]
			];
			Lookup[options,SubstrateSolution],
			ObjectP[Model[Sample,"ELISA TMB Stabilized Chromogen"]],
			Variables:>{options}
		],
		Example[
			{Options,StopSolution,"Specify the reagent that is used to stop the reaction between the enzyme and its substrate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StopSolution->Model[Sample,"ELISA HRP-TMB Stop Solution"]
			];
			Lookup[options,StopSolution],
			ObjectP[Model[Sample,"ELISA HRP-TMB Stop Solution"]],
			Variables:>{options}
		],
		Example[
			{Options,SubstrateSolutionVolume,"Specify the volume of the SubstrateSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SubstrateSolutionVolume->{100Microliter,150Microliter}
			];
			Lookup[options,SubstrateSolutionVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,StopSolutionVolume,"Specify the volume of StopSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StopSolutionVolume->{100Microliter,150Microliter}
			];
			Lookup[options,StopSolutionVolume],
			{100Microliter,150Microliter},
			Variables:>{options}
		],
		Example[
			{Options,SubstrateIncubationTime,"Specify the time during which the colorimetric reaction occurs:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SubstrateIncubationTime->3Hour
			];
			Lookup[options,SubstrateIncubationTime],
			3Hour,
			Variables:>{options}
		],
		Example[
			{Options,SubstrateIncubationTemperature,"Specify the temperature of the Substrate incubation, in order for the detection reaction to take place where the antibody-conjugated enzyme (such as Horseradish Peroxidase or Alkaline Phosphatase) catalyzes the colorimetric reaction:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SubstrateIncubationTemperature->40Celsius
			];
			Lookup[options,SubstrateIncubationTemperature],
			40Celsius,
			Variables:>{options}
		],
		Example[
			{Options,SubstrateIncubationMixRate,"Specify the speed at which the plate is shaken during Substrate incubation:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SubstrateIncubationMixRate->50RPM
			];
			Lookup[options,SubstrateIncubationMixRate],
			50RPM,
			Variables:>{options}
		],
		Example[
			{Options,PrereadBeforeStop,"Specify if we read the absorbance intensities before the reaction will be quenched by StopSolution:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				PrereadBeforeStop->True
			];
			Lookup[options,{PrereadBeforeStop,PrereadTimepoints,PrereadAbsorbanceWavelength}],
			{True, {Quantity[15, "Minutes"]}, {Quantity[450, "Nanometers"]}},
			Variables:>{options}
		],
		Example[
			{Options,PrereadTimepoints,"Specify the wavelength used to detect the absorbance of light by the product of the detection reaction:"},
			protocol=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				PrereadTimepoints->{10Minute,20Minute}
			];
			Download[protocol,PrereadTimepoints],
			{Quantity[10.`, "Minutes"], Quantity[20.`, "Minutes"]},
			Variables:>{protocol}
		],
		Example[
			{Options,PrereadAbsorbanceWavelength,"Specify the wavelength used to detect the absorbance of light by the product of the detection reaction:"},
			protocol=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				PrereadAbsorbanceWavelength->{450Nanometer,492Nanometer}
			];
			Download[protocol,PrereadAbsorbanceWavelengths],
			{Quantity[450.`, "Nanometers"], Quantity[492.`, "Nanometers"]},
			Variables:>{protocol}
		],
		Example[
			{Options,AbsorbanceWavelength,"Specify the wavelength used to detect the absorbance of light by the product of the detection reaction:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				AbsorbanceWavelength->{450Nanometer,492Nanometer}
			];
			Lookup[options,AbsorbanceWavelength],
			{450Nanometer,492Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,AbsorbanceWavelength,"Specify the a single AbsorbanceWavelength:"},
			protocol=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				AbsorbanceWavelength->450Nanometer
			];
			Download[protocol,AbsorbanceWavelengths],
			{RangeP[449 Nanometer, 451 Nanometer]},
			Variables:>{protocol}
		],
		Example[
			{Options,SignalCorrection,"Indicate if the absorbance reading should be taken at 620 nm to eliminate the interference of background absorption:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				SignalCorrection->True
			];
			Lookup[options,SignalCorrection],
			True,
			Variables:>{options}
		],
		Example[
			{Options,Standard,"Specify a sample containing known amount of TargetAntigen molecule as the standard sample for the experiment. Standard related options are resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Standard->Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID]
			];
			Lookup[options,{Standard,StandardTargetAntigen,StandardStorageCondition}],
			{ObjectP[Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID]],ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,Standard,"Standard can be set to Null:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Standard->Null
			];
			Lookup[options,{Standard,StandardTargetAntigen,StandardSerialDilutionCurve,StandardDilutionCurve,StandardDiluent,StandardStorageCondition,StandardCoatingAntibody,StandardCoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume,StandardCaptureAntibody,StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume,StandardReferenceAntigen,StandardReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume,StandardPrimaryAntibody,StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume,StandardSecondaryAntibody,StandardSecondaryAntibodyDilutionFactor,StandardSecondaryAntibodyVolume,StandardCoatingVolume,StandardReferenceAntigenCoatingVolume,StandardCoatingAntibodyCoatingVolume,StandardCaptureAntibodyCoatingVolume,StandardBlockingVolume,StandardAntibodyComplexImmunosorbentVolume,StandardImmunosorbentVolume,StandardPrimaryAntibodyImmunosorbentVolume,StandardSecondaryAntibodyImmunosorbentVolume,StandardSubstrateSolution,StandardStopSolution,StandardSubstrateSolutionVolume,StandardStopSolutionVolume}],
			{ListableP[Null]..},
			Variables:>{options},
			Messages:>{Warning::ELISANoStandardForExperiment}
		],
		Example[
			{Options,Standard,"Multiple standard samples can be added to one experiment:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Standard->{Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID]}
			];
			Lookup[options,Standard],
			{ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID]]},
			Variables:>{options}
		],
		Example[
			{Options,StandardTargetAntigen,"Specify the analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the standard samples by antibodies in the ELISA experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				StandardTargetAntigen->Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,{StandardTargetAntigen,StandardPrimaryAntibody}],
			{ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]]},
			Variables:>{options}
		],
		Example[
			{Options,StandardSerialDilutionCurve,"Specify the collection of step-wise serial dilutions that will be preformed on each standard sample:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				StandardSerialDilutionCurve->{120Microliter,{0.5,10}}
			];
			Lookup[options,{StandardSerialDilutionCurve,StandardDilutionCurve,StandardDiluent}],
			{{120Microliter,{0.5,10}},Null,ObjectP[Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"]]},
			Variables:>{options}
		],
		Example[
			{Options,StandardDilutionCurve,"Specify the collection of dilutions that will be preformed on each standard sample:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA,
				StandardDilutionCurve->{{60Microliter,60Microliter},{50Microliter,70Microliter},{40Microliter,80Microliter},{30Microliter,90Microliter},{20Microliter,100Microliter},{10Microliter,110Microliter}}
			];
			Lookup[options,{StandardSerialDilutionCurve,StandardDilutionCurve,StandardDiluent}],
			{Null,{{60Microliter,60Microliter},{50Microliter,70Microliter},{40Microliter,80Microliter},{30Microliter,90Microliter},{20Microliter,100Microliter},{10Microliter,110Microliter}},ObjectP[Model[Sample,"ELISA Blocker Blocking Buffer"]]},
			Variables:>{options}
		],
		Example[
			{Options,StandardDiluent,"Specify the buffer used to perform multiple dilutions of standard samples:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				StandardDiluent->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,StandardDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardStorageCondition,"Specify the condition under which the unused portion of standard sample should be stored after the protocol is completed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				StandardStorageCondition->Freezer
			];
			Lookup[options,StandardStorageCondition],
			Freezer,
			Variables:>{options}
		],
		Example[
			{Options,StandardCoatingAntibody,"Specify the samples containing the antibody that is used for standard coating in FastELISA of standard sample. The related options are resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				StandardCoatingAntibody->Model[Sample, "ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID]
			];
			Lookup[options,{
				StandardCoatingAntibody,StandardCoatingAntibodyDilutionFactor,StandardCoatingAntibodyVolume
			}],
			{ObjectP[Model[Sample, "ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID]],
				0.001,
				Null},
			Variables:>{options}
		],

		Example[
			{Options,StandardCoatingAntibodyDilutionFactor,"Specify StandardCoatingAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				StandardCoatingAntibodyDilutionFactor->0.1
			];
			Lookup[options,StandardCoatingAntibodyDilutionFactor],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,StandardCoatingAntibodyVolume,"Specify StandardCoatingAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				StandardCoatingAntibodyVolume->1Microliter
			];
			Lookup[options,StandardCoatingAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,StandardCaptureAntibody,"Specify the desired sample containing the antibody that is used to pull down the antigen from standard sample solution to the surface of the assay plate well in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				CaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID],
				StandardCaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID]
			];
			Lookup[options,{
				StandardCaptureAntibody,StandardCaptureAntibodyDilutionFactor,StandardCaptureAntibodyVolume
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID]],
				0.001,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,StandardCaptureAntibodyDilutionFactor,"Specify StandardCaptureAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				StandardCaptureAntibodyDilutionFactor->0.1
			];
			Lookup[options,StandardCaptureAntibodyDilutionFactor],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,StandardCaptureAntibodyVolume,"Specify StandardCaptureAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				StandardCaptureAntibodyVolume->1Microliter
			];
			Lookup[options,StandardCaptureAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,StandardReferenceAntigen,"Specify the desired StandardReferenceAntigen containing the antigen used to compete with standard sample for StandardPrimaryAntibody binding in DirectCompetitiveELISA or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				StandardReferenceAntigen->Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID]
			];
			Lookup[options,{
				StandardReferenceAntigen,StandardReferenceAntigenDilutionFactor,StandardReferenceAntigenVolume
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID]],
				0.001,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,StandardReferenceAntigenDilutionFactor,"Specify StandardReferenceAntigenDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				StandardReferenceAntigenDilutionFactor->0.01
			];
			Lookup[options,StandardReferenceAntigenDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,StandardReferenceAntigenVolume,"Specify StandardReferenceAntigenVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				StandardReferenceAntigenVolume->1Microliter
			];
			Lookup[options,StandardReferenceAntigenVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,StandardPrimaryAntibody,"Specify the desired sample containing the antibody that directly binds with the StandardTargetAntigen (analyte). The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				StandardPrimaryAntibody->Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
				StandardCaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID]
			];
			Lookup[options,{
				StandardPrimaryAntibody,StandardPrimaryAntibodyDilutionFactor,StandardPrimaryAntibodyVolume
			}],
			{ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]],
				0.001,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,StandardPrimaryAntibodyDilutionFactor,"Specify StandardPrimaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				StandardPrimaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,StandardPrimaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,StandardPrimaryAntibodyVolume,"Specify StandardPrimaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				StandardPrimaryAntibodyVolume->1Microliter
			];
			Lookup[options,StandardPrimaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,StandardSecondaryAntibody,"Specify the desired sample containing the antibody that binds to StandardPrimaryAntibody in IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				StandardSecondaryAntibody->Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]
			];
			Lookup[options,{
				StandardSecondaryAntibody,StandardSecondaryAntibodyDilutionFactor,StandardSecondaryAntibodyVolume
			}],
			{ObjectP[Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]],
				0.001,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,StandardSecondaryAntibodyDilutionFactor,"Specify StandardSecondaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				StandardSecondaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,StandardSecondaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,StandardSecondaryAntibodyVolume,"Specify StandardSecondaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				StandardSecondaryAntibodyVolume->1Microliter
			];
			Lookup[options,StandardSecondaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,StandardCoatingVolume,"Specify the desired amount of Standard that is aliquoted into the assay plate, in order for the Standard to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				StandardCoatingVolume->50Microliter
			];
			Lookup[options,StandardCoatingVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardReferenceAntigenCoatingVolume,"Specify the amount of StandardReferenceAntigen that is aliquoted into the assay plate, in order for the StandardReferenceAntigen to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectCompetitiveELISA,
				StandardReferenceAntigenCoatingVolume->150Microliter
			];
			Lookup[options,StandardReferenceAntigenCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardCoatingAntibodyCoatingVolume,"Specify the amount of StandardCoatingAntibody that is aliquoted into the assay plate, in order for the StandardCoatingAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				StandardCoatingAntibodyCoatingVolume->150Microliter
			];
			Lookup[options,StandardCoatingAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardCaptureAntibodyCoatingVolume,"Specify the amount of diluted StandardCaptureAntibody that is aliquoted into the assay plate, in order for the StandardCaptureAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA,
				StandardCaptureAntibodyCoatingVolume->150Microliter
			];
			Lookup[options,StandardCaptureAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardBlockingVolume,"Specify the desired amount of BlockingBuffer that is aliquoted into the appropriate standard sample wells of the assay plate, in order to prevent non-specific binding of molecules to the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				StandardBlockingVolume->50Microliter
			];
			Lookup[options,StandardBlockingVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,StandardAntibodyComplexImmunosorbentVolume,"Specify the volume of the standard-antibody complex to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				StandardAntibodyComplexImmunosorbentVolume->150Microliter
			];
			Lookup[options,StandardAntibodyComplexImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardImmunosorbentVolume,"Specify the volume of the Standard to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in sandwich ELISA:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				StandardImmunosorbentVolume->150Microliter
			];
			Lookup[options,StandardImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardPrimaryAntibodyImmunosorbentVolume,"Specify the volume of the StandardPrimaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				StandardPrimaryAntibodyImmunosorbentVolume->150Microliter
			];
			Lookup[options,StandardPrimaryAntibodyImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardSecondaryAntibodyImmunosorbentVolume,"Specify the volume of the StandardSecondaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				StandardSecondaryAntibodyImmunosorbentVolume->150Microliter
			];
			Lookup[options,StandardSecondaryAntibodyImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardSubstrateSolution,"Specify the substrate solution binding to the enzyme conjugated to the antibody of the standard sample for signal detection:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StandardSubstrateSolution->Model[Sample,"ELISA TMB Stabilized Chromogen"]
			];
			Lookup[options,StandardSubstrateSolution],
			ObjectP[Model[Sample,"ELISA TMB Stabilized Chromogen"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardStopSolution,"Specify the reagent that is used to stop the reaction between the enzyme and its substrate for standard sample:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StandardStopSolution->Model[Sample,"ELISA HRP-TMB Stop Solution"]
			];
			Lookup[options,StandardStopSolution],
			ObjectP[Model[Sample,"ELISA HRP-TMB Stop Solution"]],
			Variables:>{options}
		],
		Example[
			{Options,StandardSubstrateSolutionVolume,"Specify the volume of the StandardSubstrateSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StandardSubstrateSolutionVolume->150Microliter
			];
			Lookup[options,StandardSubstrateSolutionVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardStopSolutionVolume,"Specify the volume of StandardStopSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				StandardStopSolutionVolume->150Microliter
			];
			Lookup[options,StandardStopSolutionVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,Blank,"Specify a sample containing no TargetAntigen molecule as a baseline or negative control for the ELISA experiment. Blank related options are resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Blank->Model[Sample,"Milli-Q water"]
			];
			Lookup[options,{Blank,BlankTargetAntigen,BlankStorageCondition}],
			{ObjectP[Model[Sample,"Milli-Q water"]],ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],Refrigerator},
			Variables:>{options}
		],
		Example[
			{Options,Blank,"Blank can be set to Null:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Blank->Null
			];
			Lookup[options,{Blank,BlankTargetAntigen,BlankStorageCondition,BlankCoatingAntibody,BlankCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume,BlankCaptureAntibody,BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume,BlankReferenceAntigen,BlankReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume,BlankPrimaryAntibody,BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume,BlankSecondaryAntibody,BlankSecondaryAntibodyDilutionFactor,BlankSecondaryAntibodyVolume,BlankCoatingVolume,BlankReferenceAntigenCoatingVolume,BlankCoatingAntibodyCoatingVolume,BlankCaptureAntibodyCoatingVolume,BlankBlockingVolume,BlankAntibodyComplexImmunosorbentVolume,BlankImmunosorbentVolume,BlankPrimaryAntibodyImmunosorbentVolume,BlankSecondaryAntibodyImmunosorbentVolume,BlankSubstrateSolution,BlankStopSolution,BlankSubstrateSolutionVolume,BlankStopSolutionVolume}],
			{ListableP[Null]..},
			Variables:>{options},
			Messages:>{Warning::ELISANoBlankForExperiment}
		],
		Example[
			{Options,Blank,"Multiple blank samples can be added to one experiment:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Blank->{Model[Sample,"Milli-Q water"],Model[Sample,StockSolution,"Filtered PBS, Sterile"]}
			];
			Lookup[options,Blank],
			{ObjectP[Model[Sample,"Milli-Q water"]],ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]]},
			Variables:>{options}
		],


		Example[
			{Options,BlankTargetAntigen,"Specify the analyte molecule(e.g., peptide, protein, and hormone) detected and quantified in the blank samples by antibodies in the ELISA experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				BlankTargetAntigen->Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,{BlankTargetAntigen,BlankPrimaryAntibody}],
			{ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],ObjectP[Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]]},
			Variables:>{options}
		],
		Example[
			{Options,BlankStorageCondition,"Specify the condition under which the unused portion of blank sample should be stored after the protocol is completed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlankStorageCondition->Freezer
			];
			Lookup[options,BlankStorageCondition],
			Freezer,
			Variables:>{options}
		],
		Example[
			{Options,BlankCoatingAntibody,"Specify the sample containing the antibody that is used for coating in FastELISA of blank sample. The related options are resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				CoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				BlankCoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				BlankCoatingAntibodyDilutionFactor->0.1
			];
			Lookup[options,{
				BlankCoatingAntibody,BlankCoatingAntibodyDilutionFactor,BlankCoatingAntibodyVolume
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID]],
				0.1,
				Null},
			Variables:>{options}
		],

		Example[
			{Options,BlankCoatingAntibodyDilutionFactor,"Specify BlankCoatingAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				BlankCoatingAntibodyDilutionFactor->0.001
			];
			Lookup[options,BlankCoatingAntibodyDilutionFactor],
			0.001,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlankCoatingAntibodyVolume,"Specify BlankCoatingAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->FastELISA,
				BlankCoatingAntibodyVolume->1Microliter
			];
			Lookup[options,BlankCoatingAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],


		Example[
			{Options,BlankCaptureAntibody,"Specify the desired sample containing the antibody that is used to pull down the antigen from blank sample solution to the surface of the assay plate well in DirectSandwichELISA, IndirectSandwichELISA, and FastELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				CaptureAntibody->Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID],
				BlankCaptureAntibody->Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID],
				BlankCaptureAntibodyDilutionFactor->0.1
			];
			Lookup[options,{
				BlankCaptureAntibody,BlankCaptureAntibodyDilutionFactor,BlankCaptureAntibodyVolume
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID]],
				0.1,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,BlankCaptureAntibodyDilutionFactor,"Specify BlankCaptureAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				BlankCaptureAntibodyDilutionFactor->0.1
			];
			Lookup[options,BlankCaptureAntibodyDilutionFactor],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlankCaptureAntibodyVolume,"Specify BlankCaptureAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				BlankCaptureAntibodyVolume->1Microliter
			];
			Lookup[options,BlankCaptureAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],


		Example[
			{Options,BlankReferenceAntigen,"Specify the desired BlankReferenceAntigen containing the antigen used to compete with blank sample for BlankPrimaryAntibody binding in DirectCompetitiveELISA or IndirectCompetitiveELISA. The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				ReferenceAntigen->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				BlankReferenceAntigen->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				BlankReferenceAntigenDilutionFactor->0.1
			];
			Lookup[options,{
				BlankReferenceAntigen,BlankReferenceAntigenDilutionFactor,BlankReferenceAntigenVolume
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID]],
				0.1,
				Null},
			Variables:>{options}
		],
		Example[
			{Options,BlankReferenceAntigenDilutionFactor,"Specify BlankReferenceAntigenDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				BlankReferenceAntigenDilutionFactor->0.01
			];
			Lookup[options,BlankReferenceAntigenDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlankReferenceAntigenVolume,"Specify BlankReferenceAntigenVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				BlankReferenceAntigenVolume->1Microliter
			];
			Lookup[options,BlankReferenceAntigenVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],

		Example[
			{Options,BlankPrimaryAntibody,"Specify the desired sample containing the antibody that directly binds with the BlankTargetAntigen (analyte). The related options are also resolved automatically:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				BlankPrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				BlankPrimaryAntibodyDilutionFactor->0.1,
				BlankCaptureAntibody->Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID],
				BlankCaptureAntibodyDilutionFactor->0.1
			];
			Lookup[options,{
				BlankPrimaryAntibody,BlankPrimaryAntibodyDilutionFactor,BlankPrimaryAntibodyVolume
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID]],
				0.1,
				Null},
			Variables:>{options}
		],

		Example[
			{Options,BlankPrimaryAntibodyDilutionFactor,"Specify BlankPrimaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				BlankPrimaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,BlankPrimaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlankPrimaryAntibodyVolume,"Specify BlankPrimaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				BlankPrimaryAntibodyVolume->1Microliter
			];
			Lookup[options,BlankPrimaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],


		Example[
			{Options,BlankSecondaryAntibody,"Specify the desired sample containing the antibody that binds to BlankPrimaryAntibody in IndirectELISA, IndirectSandwichELISA, or IndirectCompetitiveELISA:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				SecondaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID],
				BlankSecondaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID],
				BlankSecondaryAntibodyDilutionFactor->0.1
			];
			Lookup[options,{
				BlankSecondaryAntibody,BlankSecondaryAntibodyDilutionFactor,BlankSecondaryAntibodyVolume
			}],
			{ObjectP[Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID]],
				0.1,
				Null},
			Variables:>{options}
		],

		Example[
			{Options,BlankSecondaryAntibodyDilutionFactor,"Specify BlankSecondaryAntibodyDilutionFactor:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				BlankSecondaryAntibodyDilutionFactor->0.01
			];
			Lookup[options,BlankSecondaryAntibodyDilutionFactor],
			0.01,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,BlankSecondaryAntibodyVolume,"Specify BlankSecondaryAntibodyVolume:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectSandwichELISA,
				BlankSecondaryAntibodyVolume->1Microliter
			];
			Lookup[options,BlankSecondaryAntibodyVolume],
			1Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],


		Example[
			{Options,BlankCoatingVolume,"Specify the desired amount of Blank that is aliquoted into the assay plate, in order for the Blank to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlankCoatingVolume->50Microliter
			];
			Lookup[options,BlankCoatingVolume],
			50Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankReferenceAntigenCoatingVolume,"Specify the amount of BlankReferenceAntigen that is aliquoted into the assay plate, in order for the BlankReferenceAntigen to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectCompetitiveELISA,
				BlankReferenceAntigenCoatingVolume->150Microliter
			];
			Lookup[options,BlankReferenceAntigenCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankCoatingAntibodyCoatingVolume,"Specify the amount of BlankCoatingAntibody that is aliquoted into the assay plate, in order for the BlankCoatingAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->FastELISA,
				BlankCoatingAntibodyCoatingVolume->150Microliter
			];
			Lookup[options,BlankCoatingAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankCaptureAntibodyCoatingVolume,"Specify the amount of diluted BlankCaptureAntibody that is aliquoted into the assay plate, in order for the BlankCaptureAntibody to be adsorbed to the surface of the well:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				Method->DirectSandwichELISA,
				BlankCaptureAntibodyCoatingVolume->150Microliter
			];
			Lookup[options,BlankCaptureAntibodyCoatingVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankBlockingVolume,"Specify the desired amount of BlockingBuffer that is aliquoted into the appropriate blank sample wells of the assay plate, in order to prevent non-specific binding of molecules to the assay plate:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Output->Options,
				BlankBlockingVolume->50Microliter
			];
			Lookup[options,BlankBlockingVolume],
			50Microliter,
			Variables:>{options}
		],

		Example[
			{Options,BlankAntibodyComplexImmunosorbentVolume,"Specify the volume of the blank-antibody complex to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectCompetitiveELISA,
				BlankAntibodyComplexImmunosorbentVolume->150Microliter
			];
			Lookup[options,BlankAntibodyComplexImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankImmunosorbentVolume,"Specify the volume of the Blank to be loaded on the ELISAPlate for the target antigen to bind to the capture antibody in sandwich ELISA:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectSandwichELISA,
				BlankImmunosorbentVolume->150Microliter
			];
			Lookup[options,BlankImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankPrimaryAntibodyImmunosorbentVolume,"Specify the volume of the BlankPrimaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->DirectELISA,
				BlankPrimaryAntibodyImmunosorbentVolume->150Microliter
			];
			Lookup[options,BlankPrimaryAntibodyImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankSecondaryAntibodyImmunosorbentVolume,"Specify the volume of the BlankSecondaryAntibody to be loaded on each well of the ELISAPlate:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				Method->IndirectELISA,
				BlankSecondaryAntibodyImmunosorbentVolume->150Microliter
			];
			Lookup[options,BlankSecondaryAntibodyImmunosorbentVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankSubstrateSolution,"Specify the substrate solution binding to the enzyme conjugated to the antibody of the blank sample for signal detection:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				BlankSubstrateSolution->Model[Sample,"ELISA TMB Stabilized Chromogen"]
			];
			Lookup[options,BlankSubstrateSolution],
			ObjectP[Model[Sample,"ELISA TMB Stabilized Chromogen"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankStopSolution,"Specify the reagent that is used to stop the reaction between the enzyme and its substrate for blank sample:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				BlankStopSolution->Model[Sample,"ELISA HRP-TMB Stop Solution"]
			];
			Lookup[options,BlankStopSolution],
			ObjectP[Model[Sample,"ELISA HRP-TMB Stop Solution"]],
			Variables:>{options}
		],
		Example[
			{Options,BlankSubstrateSolutionVolume,"Specify the volume of the BlankSubstrateSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				BlankSubstrateSolutionVolume->150Microliter
			];
			Lookup[options,BlankSubstrateSolutionVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,BlankStopSolutionVolume,"Specify the volume of BlankStopSolution to be added to the corresponding well:"},
			options=ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Output->Options,
				BlankStopSolutionVolume->150Microliter
			];
			Lookup[options,BlankStopSolutionVolume],
			150Microliter,
			Variables:>{options}
		],
		Example[
			{Options,ELISAPlate,"Specify the ELISAPlate:"},
			options=ExperimentELISA[
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,ELISAPlate],
			ObjectP[Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,SecondaryELISAPlate,"Specify the second assay plate, if desired. A second ELISA plate is needed when the total number of samples is over 96:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],NumberOfReplicates->10,
				Output->Options,
				ELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID],
				SecondaryELISAPlate->Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID]
			];
			Lookup[options,SecondaryELISAPlate],
			ObjectP[Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[
			{Options,ELISAPlateAssignment,"Specifies the placement of samples, standards and blanks in the first ELISAPlate and specify the desired ELISA experiment conditions:"},
			customELISAPlateAssignment={
				{
					Unknown,
					Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Standard,
					Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
					Null,
					Null,
					{0.5,0.25,0.125,0.0625,0.03125,0.015625},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Blank,
					Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				}
			};
			protocol=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlateAssignment->customELISAPlateAssignment
			];
			Lookup[Download[protocol,ELISAPlateAssignment],Type],
			{Unknown,Unknown,Standard,Standard,Blank,Blank},
			Variables:>{protocol,customELISAPlateAssignment},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[
			{Options,SecondaryELISAPlateAssignment,"Specifies the placement of samples in the second ELISAPlate:"},
			customELISAPlateAssignment1={
				{
					Unknown,
					Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				}
			};
			customELISAPlateAssignment2={
				{
					Standard,
					Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
					Null,
					Null,
					{0.5,0.25,0.125,0.0625,0.03125,0.015625},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Blank,
					Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				}
			};
			protocol=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlateAssignment->customELISAPlateAssignment1,
				SecondaryELISAPlateAssignment->customELISAPlateAssignment2,
				ELISAPlate->Model[Container,Plate,"96-well Polystyrene Flat-Bottom Plate, Clear"],
				SecondaryELISAPlate->Model[Container,Plate,"96-well Polystyrene Flat-Bottom Plate, Clear"]
			];
			{Lookup[Download[protocol,ELISAPlateAssignment],Type],Lookup[Download[protocol,SecondaryELISAPlateAssignment],Type]},
			{{Unknown,Unknown},{Standard,Standard,Blank,Blank}},
			Variables:>{protocol,customELISAPlateAssignment1,customELISAPlateAssignment2},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],


		(*======Funtopia Shared Option Tests==========*)

		Example[{Options,Template,"Use a template to pass down previous experimental specifications:"},
			oldProtocol=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],BlockingTime->2.5Hour];
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Template->oldProtocol][BlockingTime],
			2.5Hour,
			EquivalenceFunction->Equal,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,Name,"Name the protocol:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Name->"ExperimentELISA test favorite protocol"][Name],
			_String,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PreparatoryPrimitives,"Use the PreparatoryPrimitives option to pre-dilute Sample:"},
			ExperimentELISA["Antibody Container",
				PreparatoryPrimitives->{
					Define[
						Name->"Antibody Container",
						Container->Model[Container,Vessel,"id:3em6Zv9NjjN8"]
					],
					Transfer[
						Source->Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
						Amount->2*Microliter,
						Destination->{"Antibody Container","A1"}
					],
					Transfer[
						Source->Model[Sample,"ELISA Blocker Blocking Buffer"],
						Amount->248*Microliter,
						Destination->{"Antibody Container","A1"}
					]
				}
			],
			ObjectP[Object[Protocol,ELISA]],
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			),
			TimeConstraint -> 1000
		],
		Example[{Options,PreparatoryUnitOperations,"Use the PreparatoryUnitOperations option to pre-dilute Sample:"},
			Module[{protocol},
				protocol=ExperimentELISA["Antibody Container",
					PreparatoryUnitOperations->{
						LabelContainer[
							Label->"Antibody Container",
							Container->Model[Container,Vessel,"id:3em6Zv9NjjN8"]
						],
						Transfer[
							Source->Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
							Amount->2*Microliter,
							Destination->{"A1", "Antibody Container"}
						],
						Transfer[
							Source->Model[Sample,"ELISA Blocker Blocking Buffer"],
							Amount->248*Microliter,
							Destination->{"A1", "Antibody Container"}
						]
					}
				];
				Download[protocol,PreparatoryUnitOperations]
			],
			{SamplePreparationP..},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],

		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Incubate->True,Centrifuge->True,Filtration->True,Aliquot->True,Output->Options];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->240
		],
		(* ExperimentIncubate tests. *)
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Incubate->True,Output->Options];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubationTemperature->40*Celsius,Output->Options];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubationTime->40*Minute,Output->Options];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],MaxIncubationTime->40*Minute,Output->Options];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubationInstrument->Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"],Output->Options];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:WNa4ZjRDVw64"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AnnealingTime->40*Minute,Output->Options];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubateAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,IncubateAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubateAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],

		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],MixType->Shake,Output->Options];
			Lookup[options,MixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		(* Note: Put your sample in a 2mL tube for the following test. *)
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Microfuge 16"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Microfuge 16"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		(* Note: CentrifugeTime cannot go above 5Minute without restricting the types of centrifuges that can be used. *)
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeTime->5*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeTemperature->30*Celsius,CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeTemperature],
			30*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,CentrifugeAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		(* filter options *)
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FiltrationType->Syringe,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterInstrument->Model[Instrument,SyringePump,"NE-1010 Syringe Pump"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,SyringePump,"NE-1010 Syringe Pump"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],FilterMaterial->PES,FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],PrefilterMaterial->GxF,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],FiltrationType->PeristalticPump,FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],Output->Options];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterSterile->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterAliquot->0.5*Milliliter,Output->Options];
			Lookup[options,FilterAliquot],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterContainerOut->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},
			Variables:>{options}
		],
		(* aliquot options *)
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AliquotAmount->0.5*Milliliter,Output->Options];
			Lookup[options,AliquotAmount],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			0.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],TargetConcentration->5*Micromolar,Output->Options];
			Lookup[options,TargetConcentration],
			5*Micromolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option to specify which analyte to achieve the desired TargetConcentration for dilution of aliquots of SamplesIn:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],TargetConcentration->5*Micromolar,TargetConcentrationAnalyte->Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],ConcentratedBuffer->Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"],BufferDilutionFactor->10,AliquotAmount->0.2*Milliliter,AssayVolume->0.5*Milliliter,Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,"Simple Western 10X Sample Buffer"],AliquotAmount->0.1*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,"Simple Western 10X Sample Buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AssayBuffer->Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"],AliquotAmount->0.2*Milliliter,AssayVolume->0.8*Milliliter,Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"Simple Western 0.1X Sample Buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,AliquotContainer],
			{{1,ObjectP[Model[Container,Vessel,"2mL Tube"]]},{2,ObjectP[Model[Container,Vessel,"2mL Tube"]]}},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],IncubateAliquotDestinationWell->"A1",AliquotContainer->Model[Container,Vessel,"2mL Tube"],Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options=ExperimentELISA[
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SamplesInStorageCondition->Refrigerator,
				Output->Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ImageSample,"Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],ImageSample->True,Output->Options];
			Lookup[options,ImageSample],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Indicates if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],MeasureVolume->True,Output->Options];
			Lookup[options,MeasureVolume],
			True,
			Variables:>{options}
		],
		Example[{Options,MeasureWeight,"Indicates if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options=ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],MeasureWeight->True,Output->Options];
			Lookup[options,MeasureWeight],
			True,
			Variables:>{options}
		],


		(*======Messages Tests==========*)

		Example[{Messages,"ObjectDoesNotExist","Throw error is the specified object does not exist:"},
			ExperimentELISA[Object[Sample,"This ELISA sample is not a real thing"]],
			$Failed,
			Messages:>{
				Error::ObjectDoesNotExist,
				Error::InvalidInput
			}
		],
		Example[{Messages,"DiscardedSamples","The input sample cannot have a Status of Discarded:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 3 discarded" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Messages,"NonLiquidSample","The input sample cannot have a State that is not Liquid:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 4 solid" <> $SessionUUID]],
			$Failed,
			Messages:>{
				Error::ELISANoneLiquidSample,
				Error::InvalidInput
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option (e.g., Standard) is set to Null, all corresponding single options to Null:"},
			ExperimentELISA[{
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]
			},
				NumberOfReplicates->3,
				Standard->Null,
				StandardDiluent->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Warning::ELISANoStandardForExperiment,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option (e.g., Blank) is set to Null, all corresponding single options to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				NumberOfReplicates->3,
				Blank->Null,
				BlankCaptureAntibodyVolume->100Microliter
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Warning::ELISANoBlankForExperiment,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Method is set to a certain value (e.g., DirectCompetitiveELISA), the unused antibody single options must be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Method->DirectCompetitiveELISA,
				NumberOfReplicates->3,
				SampleImmunosorbentTemperature->40Celsius
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option SampleAntibodyComplexIncubation is set to False, the related single options must also be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				SampleAntibodyComplexIncubation->False,
				SampleAntibodyComplexIncubationTemperature->40Celsius
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Coating is set to False, the related single options must also be set to Null:"},
			ExperimentELISA[Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
				Coating->False,
				CoatingTemperature->40Celsius,
				(* This is to make sure we have enough pipetting volume for primary antibody. NumberOfReplicates/Standard/Blank resolve to Null when Coating is False *)
				PrimaryAntibodyDilutionFactor->0.1
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Coating is set to False and the option Method is set to a certain value (e.g., DirectSandwichELISA), the related diluent option must also be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Method->DirectSandwichELISA,
				Coating->False,
				CaptureAntibodyDiluent->Model[Sample,"Milli-Q water"]
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option (e.g., Standard) is set to Null, all corresponding index matched options to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				NumberOfReplicates->3,
				Standard->Null,
				StandardPrimaryAntibody->{Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Warning::ELISANoStandardForExperiment,
				Error::StandardOrBlankReagentsNotForSample,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option (e.g., Blank) is set to Null, all corresponding inex matched options to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				NumberOfReplicates->3,
				Blank->Null,
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID],
				BlankPrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Warning::ELISANoBlankForExperiment,
				Error::UnresolvableIndexMatchedOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Method is set to a certain value (e.g., IndirectELISA), the unused antibody index matching options must be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Method->IndirectELISA,
				NumberOfReplicates->3,
				CoatingAntibodyDilutionFactor->0.1
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Blocking is set to False, the related index matching options must also be set to Null:"},
			ExperimentELISA[Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
				Coating->False,
				Blocking->False,
				BlockingVolume->200Microliter,
				(* This is to make sure we have enough pipetting volume for primary antibody. NumberOfReplicates/Standard/Blank resolve to Null when Coating is False *)
				PrimaryAntibodyDilutionFactor->0.1
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingUnullOptions","When the master switch option Coating is set to False and the option Method is set to a certain value (e.g., IndirectELISA), the related index matching options (dilution and coating options) must also be set to Null:"},
			ExperimentELISA[Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
				Method->IndirectELISA,
				Coating->False,
				StandardCoatingVolume->200Microliter,
				(* This is to make sure we have enough pipetting volume for primary antibody. NumberOfReplicates/Standard/Blank resolve to Null when Coating is False *)
				PrimaryAntibodyDilutionFactor->0.1,
				SecondaryAntibodyDilutionFactor->0.1
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingUnullOptions,
				Error::MasterConflictingUnullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option (Method) is set to DirectSandwichELISA, the related single options (e.g., PrimaryAntibodyDiluent) cannot be set to Null:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->DirectSandwichELISA,
				PrimaryAntibodyDiluent->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option SampleAntibodyComplexIncubation is set to True, the related single options cannot be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Method->IndirectCompetitiveELISA,
				SampleAntibodyComplexIncubation->True,
				SampleAntibodyComplexIncubationTemperature->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option Coating is set to True, the related single options cannot be set to Null:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				(* This is to make sure we have enough pipetting volume for primary antibody. NumberOfReplicates/Standard/Blank resolve to Null when Coating is False *)
				PrimaryAntibodyDilutionFactor->0.1,
				Coating->True,
				CoatingTemperature->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option (Method) is set to DirectSandwichELISA, the related index matching options (e.g., SampleImmunosorbentVolume) cannot be set to Null:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->DirectSandwichELISA,
				SampleImmunosorbentVolume->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option Blocking is set to True, the related index matching options cannot be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Coating->True,
				Blocking->True,
				BlockingVolume->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MasterConflictingNullOptions","When the master switch option Coating is set to True and the option Method is set to a certain value (e.g., FastELISA), the related index matching options (dilution and coating options) must also be set to Null:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				Method->FastELISA,
				Coating->True,
				CoatingAntibodyCoatingVolume->Null
			],
			$Failed,
			Messages:>{
				Error::MasterConflictingNullOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IndexedSameNullConflictingOptions","The index-matched options with the same parent (e.g., SubstrateSolution and SubstrateSolutionVolume) should be all Null or all Unull at the same time:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				StopSolution->Null,
				StopSolutionVolume->100 Microliter
			],
			$Failed,
			Messages:>{
				Error::IndexedSameNullConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IndexedSameNullConflictingOptions","The index-matched options with the same parent (e.g., SpikeDilutionFactor and SpikeStorageCondition) should be all Null or all Unull at the same time:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SpikeDilutionFactor->Null,
				SpikeStorageCondition->Freezer
			],
			$Failed,
			Messages:>{
				Error::IndexedSameNullConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EitherOrConflictingOptions","The options (if index-matched, matched to the same parent), should have one and only one specified. Use PrimaryAntibodyDilutionFactor and PrimaryAntibodyVolume as example:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				PrimaryAntibodyDilutionFactor->0.1,
				PrimaryAntibodyVolume->50 Microliter
			],
			$Failed,
			Messages:>{
				Error::EitherOrConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"EitherOrConflictingOptions","The dilution factor and dilution volume options (if index-matched, matched to the same parent), should have one and only one specified. Use PrimaryAntibodyDilutionFactor and PrimaryAntibodyVolume as example:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->FastELISA,
				CoatingAntibodyDilutionFactor->0.1,
				CoatingAntibodyVolume->50 Microliter
			],
			$Failed,
			Messages:>{
				Error::EitherOrConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NotMoreThanOneConflictingOptions","The options (if index-matched, matched to the same parent), should not have more than one populated. Use SampleDilutionCurve and SampleSerialDilutionCurve as example:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SampleDilutionCurve->{{200Microliter,1},{200Microliter,0.5},{200Microliter,0.25}},
				SampleSerialDilutionCurve->{{200Microliter,{1,0.5,0.5}}}
			],
			$Failed,
			Messages:>{
				Error::NotMoreThanOneConflictingOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"MethodConflictingSampleAntibodyIncubationSwitch","SampleAntibodyIncubation should not be true when ELISA method is not DirectCompetitiveELISA, IndirectCompetitiveELISA, or FastELISA:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->DirectELISA,
				SampleAntibodyComplexIncubation->True
			],
			$Failed,
			Messages:>{
				Error::MethodConflictingSampleAntibodyIncubationSwitch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SpecifyDiluentAndDilutionCurveTogether","If within DilutionCurve and SerialDilutionCurve, one is specified and not Null, Diluent must not be Null. If within DilutionCurve and SerialDilutionCurve, both are specified as Null,
			Diluent, if specified must also be Null:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SampleSerialDilutionCurve->{{200Microliter,{1,0.5,0.5}}},
				SampleDiluent->Null
			],
			$Failed,
			Messages:>{
				Error::SpecifyDiluentAndDilutionCurveTogether,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DilutionCurveOptionsTotalVolumeTooLarge","The total volume of each dilution cannot be larger than 1.9 ml:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SampleSerialDilutionCurve->{{2Milliliter,{0.1}}}
			],
			$Failed,
			Messages:>{
				Error::DilutionCurveOptionsTotalVolumeTooLarge,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AntibodyVolumeIncompatibility","The specified antibody or reference antigen volume (for dilutions) should not be larger than its assay volume (after dilution):"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->DirectSandwichELISA,
				PrimaryAntibodyVolume->200Microliter,
				PrimaryAntibodyImmunosorbentVolume->100Microliter
			],
			$Failed,
			Messages:>{
				Error::AntibodyVolumeIncompatibility,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElisaIncompatibleContainer","ELISAPlate And SecondaryELISAPlate must both be 96-well optical microplates that are compatible with the NIMBUS:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlate->Model[Container,Plate,"96-well 2mL Deep Well Plate"]
			],
			$Failed,
			Messages:>{
				Error::ElisaIncompatibleContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnresolvableIndexMatchedOptions","With the provided information, required options should be automatically resolved. PrimaryAntibody is resolved from the presented analyte in the sample:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::UnresolvableIndexMatchedOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnresolvableIndexMatchedOptions","With the provided information, required options should be automatically resolved. SubstrateSolution is resolved from the enzyme conjugated to the secondary antibody:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Method->IndirectELISA,
				SecondaryAntibody->Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
				SecondaryAntibodyDilutionFactor->0.1
			],
			$Failed,
			Messages:>{
				Error::UnresolvableIndexMatchedOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ElisaImproperContainers","Polypropylene and Cycloolefine are low protein-binding materials. Choosing these as ELISA plate is likely to affect results:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlate->Model[Container,Plate,"96-well UV-Star Plate"]
			],
			ObjectP[Object[Protocol,ELISA]],
			Messages:>{
				Warning::ElisaImproperContainers
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PrimaryAntibodyPipettingVolumeTooLow","The pipetting volume of any primary antibody sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				PrimaryAntibodyDilutionFactor->0.0001
			],
			$Failed,
			Messages:>{
				Error::PrimaryAntibodyPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SecondaryAntibodyPipettingVolumeTooLow","The pipetting volume of any secondary antibody sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SecondaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID],
				Method->IndirectSandwichELISA,
				SecondaryAntibodyDilutionFactor->0.0001
			],
			$Failed,
			Messages:>{
				Error::SecondaryAntibodyPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CoatingAntibodyPipettingVolumeTooLow","The pipetting volume of any coating antibody sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				CoatingAntibody->Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
				Method->FastELISA,
				CoatingAntibodyDilutionFactor->0.0001
			],
			$Failed,
			Messages:>{
				Error::CoatingAntibodyPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CaptureAntibodyPipettingVolumeTooLow","The pipetting volume of any capture antibody sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				CaptureAntibody->Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID],
				Method->DirectSandwichELISA,
				CaptureAntibodyDilutionFactor->0.0001
			],
			$Failed,
			Messages:>{
				Error::CaptureAntibodyPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ReferenceAntigenPipettingVolumeTooLow","The pipetting volume of any reference antigen sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ReferenceAntigen->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				Method->DirectCompetitiveELISA,
				ReferenceAntigenDilutionFactor->0.0001
			],
			$Failed,
			Messages:>{
				Error::ReferenceAntigenPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DilutionCurvesPipettingVolumeTooLow","The pipetting volume of the sample to prepare the dilution curves should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SampleSerialDilutionCurve->{200Microliter,{0.001,2}}
			],
			$Failed,
			Messages:>{
				Error::DilutionCurvesPipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SpikePipettingVolumeTooLow","The pipetting volume of the spike sample to mix with the input sample should be larger than 1 Microliter to allow accurate liquid handling:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Spike->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				SpikeDilutionFactor->0.001
			],
			$Failed,
			Messages:>{
				Error::SpikePipettingVolumeTooLow,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SampleVolumeShouldNotBeLargerThan50ml","The total working capacity of two 96 well plates is 48 mL. Throw error is the required aliquot volume of any input sample is larger than 50 mL:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 6 (in liquid handler incompatible container)" <> $SessionUUID],
				SampleDilutionCurve->ConstantArray[{1 Milliliter,100Microliter},45]
			],
			$Failed,
			Messages:>{
				Error::SampleVolumeShouldNotBeLargerThan50ml,
				Error::InvalidOption
			}
		],
		(* The following test is for the error message thrown in the resource packets. There is no corresponding Error::InvalidOption for it. *)
		Example[{Messages,"SampleVolumeShouldNotBeLargerThan50ml","The total working capacity of two 96 well plates is 48 mL. Throw error is the required aliquot volume of any diluent is larger than 50 mL:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				SampleDilutionCurve->ConstantArray[{1 Microliter,1 Milliliter},45]
			],
			$Failed,
			Messages:>{
				Error::SampleVolumeShouldNotBeLargerThan50ml
			}
		],
		Example[{Messages,"PlateAssignmentExceedsAvailableWells","Each ELISA plate can only accept up to 96 samples:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				(* Using NumberOfReplicates to force number of samples to go over 96 *)
				NumberOfReplicates->100
			],
			$Failed,
			Messages:>{
				Error::PlateAssignmentExceedsAvailableWells,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"PlateAssignmentDoesNotMatchOptions","The specified ELISAPlateAssignment options must match the input samples, standards and blanks:"},
			customELISAPlateAssignment={
				{
					Unknown,
					Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Standard,
					Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
					Null,
					Null,
					{0.5,0.25,0.125,0.063,0.031,0.016},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Blank,
					Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				}
			};
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
				ELISAPlateAssignment->customELISAPlateAssignment
			],
			$Failed,
			Variables:>{customELISAPlateAssignment},
			Messages:>{
				Error::PlateAssignmentDoesNotMatchOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"PlateAssignmentDoesNotMatchOptions","The specified ELISAPlateAssignment options must match the individual options provided for input samples, standards and blanks:"},
			customELISAPlateAssignment={
				{
					Unknown,
					Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Standard,
					Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
					Null,
					Null,
					{0.5,0.25,0.125,0.063,0.031,0.016},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				},
				{
					Blank,
					Model[Sample,StockSolution,"1x Carbonate-Bicarbonate Buffer pH10"],
					Null,
					Null,
					{1},
					Null,
					Null,
					Null,
					Null,
					Null,
					Null,
					Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
					0.001,
					Null,
					Null,
					100Microliter,
					100Microliter,
					Null,
					Null,
					100Microliter,
					Null,
					Model[Sample,"ELISA TMB Stabilized Chromogen"],
					Model[Sample,"ELISA HRP-TMB Stop Solution"],
					100Microliter,
					100Microliter
				}
			};
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				ELISAPlateAssignment->customELISAPlateAssignment,
				SampleDilutionCurve->{{50Microliter,50Microliter}}
			],
			$Failed,
			Variables:>{customELISAPlateAssignment},
			Messages:>{
				Error::PlateAssignmentDoesNotMatchOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CoatingButNoBlocking","When Blocking is False, Coating should also be False:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Coating->True,
				Blocking->False
			],
			ObjectP[Object[Protocol,ELISA]],
			Messages:>{
				Warning::CoatingButNoBlocking
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PrecoatedSamplesCannotBeAliquoted","When samples are coated onto ELISA plates, no aliquot should be performed for sample preparation:"},
			ExperimentELISA[Object[Container, Plate, "ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
				PrimaryAntibodyDilutionFactor->0.1,
				Coating->False,
				Aliquot->True
			],
			$Failed,
			Messages:>{
				Error::PrecoatedSamplesCannotBeAliquoted,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SpecifySpikeWithFixedDilutionCurve","When spike is specified, spiked sample cannot be diluted using SampleDilutionCurve. SampleSerialDilutionCurve must be used:"},
			ExperimentELISA[Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
				Spike->Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
				SampleDilutionCurve->{{60Microliter,60Microliter}}
			],
			$Failed,
			Messages:>{
				Error::SpecifySpikeWithFixedDilutionCurve,
				Error::InvalidOption
			}
		],
		Example[{Messages,"Within the same option, an Object[Sample] and its Model[Sample] cannot coexist:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				NumberOfReplicates->10,
				PrimaryAntibody->{Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID]}
			],
			$Failed,
			Messages:>{
				Error::ObjectAndCorrespondingModelMustNotCoexist,
				Error::InvalidOption
			}
		],
		Example[{Messages,"Reagents used for Standard and Blank must be also exist for samples:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				NumberOfReplicates->10,
				PrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
				StandardPrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID],
				BlankPrimaryAntibody->Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::StandardOrBlankReagentsNotForSample,
				Error::InvalidOption
			}
		],
		Example[{Messages,"Within the same option, an Object[Sample] and its Model[Sample] cannot coexist:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample, "ExperimentELISA test object sample 2" <> $SessionUUID]},
				Coating -> False
			],
			$Failed,
			Messages:>{
				Error::PreCoatedSamplesIncompatiblePlates,
				Error::PrimaryAntibodyPipettingVolumeTooLow,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"ELISAInvalidPrereadTimepoints","Timepoins for preread should be shorter than the Substrate Incubate time:"},
			ExperimentELISA[{Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID]},
				PrereadTimepoints->{10Minute,31Minute}
			],
			$Failed,
			Messages:>{
				Error::ELISAInvalidPrereadTimepoints,
				Error::InvalidOption
			},
			Variables:>{options}
		],
		Example[
			{Messages,"ELISAInvalidPrereadOptions","Specify the wavelength used to detect the absorbance of light by the product of the detection reaction:"},
			ExperimentELISA[
				{
					Object[Sample, "ExperimentELISA test object sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentELISA test object sample 2" <> $SessionUUID]
				},
				PrereadTimepoints -> {10 Minute, 20 Minute},
				PrereadAbsorbanceWavelength -> {450 Nanometer},
				PrereadBeforeStop -> False
			],
			$Failed,
			Messages:>{
				Error::ELISAInvalidPrereadOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"Measure620WithCorrection","Throws warning if 620 is specified for AbsorbanceWavelength and SignalCorrection ->True:"},
			ExperimentELISA[
				{
					Object[Sample, "ExperimentELISA test object sample 1" <> $SessionUUID],
					Object[Sample, "ExperimentELISA test object sample 2" <> $SessionUUID]
				},
				AbsorbanceWavelength -> {450 Nanometer,620 Nanometer},
				SignalCorrection -> True
			],
			ObjectP[Object[Protocol,ELISA]],
			Messages:>{
				Warning::Measure620WithCorrection
			}
		]
	},
	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		ClearMemoization[];
		ClearDownload[];

		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Bench for ExperimentELISA tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISA test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 12" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 13 (50 mL)" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 14 (liquid handler incompatible)" <> $SessionUUID],

						(* Tags *)
						Model[Molecule, Protein, "V5 Tag" <> $SessionUUID],

						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 4 solid" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 6 (in liquid handler incompatible container)" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID],

						(*Containers in*)
						Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID],
						(*Coated samples*)
						Object[Sample,"ExperimentELISA test coated object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 3" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];


		Block[{$AllowSystemsProtocols = True},
			Module[{
				testBench,
				container1,
				container2,
				container3,
				container4,
				container5,
				container6,
				container7,
				container8,
				container9,
				container10,
				container11,
				container12,
				container13,
				container14,
				v5tag,
				targetAntigen1,
				antibodyMolecule1,
				antibodyMolecule2,
				antibodyMolecule3,
				antibodyMolecule4,
				antibodyMolecule5,
				antibodyMolecule6,
				antibodyModelSample1,
				antibodyModelSample2,
				antibodyModelSample3,
				antibodyModelSample4,
				antibodyModelSample5,
				antibodyModelSample6,
				testSample1,
				testSample2,
				testSample3,
				testSample4,
				testSample5,
				testSample6,
				testAntigenSample1,
				testAntigenSample2,
				testAntibodySample1,
				testAntibodySample2,
				testAntibodySample3,
				testAntibodySample4,
				testAntibodySample5,
				testAntibodySample6
			},
				(*Test Bench Object*)
				testBench=Upload[
					<|
						Type->Object[Container,Bench],
						Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
						Name->"Bench for ExperimentELISA tests" <> $SessionUUID,
						StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject -> True
					|>
				];

				Block[{$DeveloperUpload = True},
					(*Test Containers*)
					{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						container9,
						container10,
						container11,
						container12
					}=UploadSample[
						ConstantArray[Model[Container,Vessel,"2mL Tube"],12],
						ConstantArray[{"Work Surface", testBench},12],
						Status->ConstantArray[Available,12],
						Name->{
							"ExperimentELISA test container 1" <> $SessionUUID,
							"ExperimentELISA test container 2" <> $SessionUUID,
							"ExperimentELISA test container 3" <> $SessionUUID,
							"ExperimentELISA test container 4" <> $SessionUUID,
							"ExperimentELISA test container 5" <> $SessionUUID,
							"ExperimentELISA test container 6" <> $SessionUUID,
							"ExperimentELISA test container 7" <> $SessionUUID,
							"ExperimentELISA test container 8" <> $SessionUUID,
							"ExperimentELISA test container 9" <> $SessionUUID,
							"ExperimentELISA test container 10" <> $SessionUUID,
							"ExperimentELISA test container 11" <> $SessionUUID,
							"ExperimentELISA test container 12" <> $SessionUUID
						},
						StorageCondition->AmbientStorage
					];

					container13=UploadSample[Model[Container,Vessel,"50mL Tube"],{"Work Surface", testBench},Status->Available,Name->"ExperimentELISA test container 13 (50 mL)" <> $SessionUUID,StorageCondition->AmbientStorage];

					container14=UploadSample[Model[Container, Vessel, "100 mL Glass Bottle"],{"Work Surface", testBench},Status->Available,Name->"ExperimentELISA test container 14 (liquid handler incompatible)" <> $SessionUUID,StorageCondition->AmbientStorage];
				];

				(* Target Antigens Model molecules*)
				{
					targetAntigen1,
					v5tag
				}=UploadProtein[
					{
						"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID,
						"V5 Tag" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					ExpirationHazard->False,
					AffinityLabel -> {False, True},
					DetectionLabel -> {False, False}
				];

				(*Antibody Model molecules*)
				{
					antibodyMolecule1,
					antibodyMolecule2,
					antibodyMolecule3,
					antibodyMolecule4,
					antibodyMolecule5,
					antibodyMolecule6

				}=UploadAntibody[
					{
						"ExperimentELISA test antibody model molecule 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody model molecule 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody model molecule 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody model molecule 4 tagged" <> $SessionUUID,
						"ExperimentELISA test antibody model molecule 5 anti-tag" <> $SessionUUID,
						"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID
					},
					State->Solid,
					BiosafetyLevel->"BSL-1",
					Flammable->False,
					MSDSRequired->False,
					IncompatibleMaterials->{None},
					ExpirationHazard->False,
					Targets->{targetAntigen1}
				];

				(* Model samples *)
				Upload[
					<|
						Name->"ExperimentELISA test model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]}
					|>
				];

				(*Target Antigen Model Samples*)
				Upload[
					<|
						Name->"ExperimentELISA test target antigen model sample 1" <> $SessionUUID,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]}
					|>
				];

				(* Antibody Model samples *)


				{
					antibodyModelSample1,
					antibodyModelSample2,
					antibodyModelSample3,
					antibodyModelSample4,
					antibodyModelSample5,
					antibodyModelSample6
				}=Upload[
					<|
						Name->#,
						Type->Model[Sample],
						DefaultStorageCondition->Link[Model[StorageCondition,"Refrigerator"]],
						State->Liquid
					|>
				]&/@
						{
							"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID,
							"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID,
							"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID,
							"ExperimentELISA test antibody model sample 4 tagged" <> $SessionUUID,
							"ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID,
							"ExperimentELISA test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID
						};

				(*Object samples, Target Antigen Objects, Antibody Objects*)
				{
					testSample1,
					testSample2,
					testSample3,
					testSample4,
					testAntigenSample1,
					testAntigenSample2,
					testAntibodySample1,
					testAntibodySample2,
					testAntibodySample3,
					testAntibodySample4,
					testAntibodySample5,
					testAntibodySample6,
					testSample5,
					testSample6
				}=UploadSample[
					{
						(* Model samples *)
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID]
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",container3},
						{"A1",container4},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12},
						{"A1",container13},
						{"A1",container14}
					},
					Name->{
						"ExperimentELISA test object sample 1" <> $SessionUUID,
						"ExperimentELISA test object sample 2" <> $SessionUUID,
						"ExperimentELISA test object sample 3 discarded" <> $SessionUUID,
						"ExperimentELISA test object sample 4 solid" <> $SessionUUID,
						"ExperimentELISA test target antigen object sample 1" <> $SessionUUID,
						"ExperimentELISA test target antigen object sample 2" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 4 tagged" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID,
						"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID,
						"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID,
						"ExperimentELISA test object sample 6 (in liquid handler incompatible container)" <> $SessionUUID
					},
					InitialAmount->Join[ConstantArray[1.8Milliliter,12], {25Milliliter,100Milliliter}],
					StorageCondition->Refrigerator
				];

				UploadSample[
					ConstantArray[Model[Container, Plate, "96-well Polystyrene Flat-Bottom Plate, Clear"],4],
					ConstantArray[{"Work Surface", testBench},4],
					Status->ConstantArray[Available,4],
					Name->{
						"ExperimentELISA test sample-coated plate-1" <> $SessionUUID,
						"ExperimentELISA test sample-coated plate-2" <> $SessionUUID,
						"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID,
						"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID
					},
					StorageCondition->Refrigerator
				];

				UploadSample[
					{
						(* Model samples *)
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID]

					},
					{
						{"A1",Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID]},
						{"B1",Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID]},
						{"A1",Object[Container,Plate,"ExperimentELISA test sample-coated plate-2" <> $SessionUUID]},
						{"B1",Object[Container,Plate,"ExperimentELISA test sample-coated plate-2" <> $SessionUUID]}
					},
					Name->{
						"ExperimentELISA test coated object sample 1" <> $SessionUUID,
						"ExperimentELISA test coated object sample 2" <> $SessionUUID,
						"ExperimentELISA test coated object sample 3" <> $SessionUUID,
						"ExperimentELISA test coated object sample 4" <> $SessionUUID
					},
					State->ConstantArray[Solid,4],
					StorageCondition->Refrigerator
				];


				Upload[{
					<|Object->antibodyMolecule1,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample1],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]},
						DeveloperObject->True
					|>,
					<|Object->antibodyMolecule2,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample2],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Mouse,
						DeveloperObject->True
					|>,
					<|Object->antibodyMolecule3,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample3],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],Targets]},
						Organism->Rabbit,
						DeveloperObject->True
					|>,
					<|Object->antibodyMolecule4,
						Replace[Targets]->{Link[Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],Antibodies]},
						DefaultSampleModel->Link[antibodyModelSample4],
						Replace[SecondaryAntibodies]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 5 anti-tag" <> $SessionUUID],Targets]},
						Replace[AffinityLabels]->{Link[v5tag]},
						DeveloperObject->True
					|>,
					<|Object->antibodyMolecule5,
						Replace[Targets]->{Link[v5tag, Antibodies]},
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID]],
						DeveloperObject->True
					|>,
					<|Object->antibodyMolecule6,
						Replace[Targets]->{Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 2 non-conjugated" <> $SessionUUID],SecondaryAntibodies],Link[Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 3 non-conjugated" <> $SessionUUID],SecondaryAntibodies]},
						DefaultSampleModel->Link[antibodyModelSample6],
						Replace[DetectionLabels]-> {Link[Model[Molecule, Protein,"Horseradish Peroxidase"]]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample1,
						Replace[Analytes]->{Link[antibodyMolecule1]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample2,
						Replace[Analytes]->{Link[antibodyMolecule2]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample3,
						Replace[Analytes]->{Link[antibodyMolecule3]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample4,
						Replace[Analytes]->{Link[antibodyMolecule4]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample5,
						Replace[Analytes]->{Link[antibodyMolecule5]},
						DeveloperObject->True
					|>,
					<|Object->antibodyModelSample6,
						Replace[Analytes]->{Link[antibodyMolecule6]},
						DeveloperObject->True
					|>,
					<|Object->testSample1,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{Null,Link[targetAntigen1]}},
						DeveloperObject->True
					|>,
					<|Object->testSample2,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{100Micro*Molar,Link[targetAntigen1]}},
						DeveloperObject->True
					|>,
					<|Object->testSample3,Status->Discarded,State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{Null,Link[targetAntigen1]}},
						DeveloperObject->True
					|>,
					<|Object->testSample4,Status->Available,State->Solid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{Null,Link[targetAntigen1]}},
						Volume->Null,
						DeveloperObject->True
					|>,
					<|Object->testSample5,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{Null,Link[targetAntigen1]}},
						DeveloperObject->True
					|>,
					<|Object->testSample6,Status->Available,State->Liquid,
						Replace[Analytes]->{Link[targetAntigen1]},
						Replace[Composition]->{{Null,Link[targetAntigen1]}},
						DeveloperObject->True
					|>,
					<|Object->testAntigenSample1,
						Replace[Analytes]->{Link[targetAntigen1]},
						State->Liquid
					|>,
					<|Object->testAntigenSample2,
						Replace[Analytes]->{Link[targetAntigen1]},
						State->Liquid
					|>,
					<|Object->targetAntigen1,
						DefaultSampleModel->Link[Model[Sample, "ExperimentELISA test target antigen model sample 1" <> $SessionUUID]],
						State->Solid,
						DeveloperObject->True
					|>,
					<|Object->testAntibodySample1,
						Replace[Analytes]->{Link[antibodyMolecule1]},
						State->Liquid
					|>,
					<|Object->testAntibodySample2,
						Replace[Analytes]->{Link[antibodyMolecule2]},
						State->Liquid
					|>,
					<|Object->testAntibodySample3,
						Replace[Analytes]->{Link[antibodyMolecule3]},
						State->Liquid
					|>,
					<|Object->testAntibodySample4,
						Replace[Analytes]->{Link[antibodyMolecule4]},
						State->Liquid
					|>,
					<|Object->testAntibodySample5,
						Replace[Analytes]->{Link[antibodyMolecule5]},
						State->Liquid
					|>,
					<|Object->testAntibodySample6,
						Replace[Analytes]->{Link[Model[Molecule,Protein,Antibody,"HRP-Conjugated Goat-Anti-Mouse-IgG Secondary Antibody"]]},
						State->Liquid
					|>

				}]

			]
		]

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(* Bench *)
						Object[Container,Bench,"Bench for ExperimentELISA tests" <> $SessionUUID],
						(*Containers*)
						Object[Container,Vessel,"ExperimentELISA test container 1" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 2" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 3" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 4" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 5" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 6" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 7" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 8" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 9" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 10" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 11" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 12" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 13 (50 mL)" <> $SessionUUID],
						Object[Container,Vessel,"ExperimentELISA test container 14 (liquid handler incompatible)" <> $SessionUUID],

						(* Tags *)
						Model[Molecule, Protein, "V5 Tag" <> $SessionUUID],
						(*Target Antigens Model molecules*)
						Model[Molecule,Protein,"ExperimentELISA test target antigen model molecule 1" <> $SessionUUID],
						(*Antibody Model molecules*)
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 1 HRP-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 2 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 3 non-conjugated" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 4 tagged" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 5 anti-tag" <> $SessionUUID],
						Model[Molecule,Protein,Antibody,"ExperimentELISA test antibody model molecule 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Model samples *)
						Model[Sample,"ExperimentELISA test model sample 1" <> $SessionUUID],
						(*Target Antigen Model Samples*)
						Model[Sample,"ExperimentELISA test target antigen model sample 1" <> $SessionUUID],
						(* Antibody Model samples *)
						Model[Sample,"ExperimentELISA test antibody model sample 1 HRP-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 2 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 3 non-conjugated" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 4 tagged" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 5 anti-tag" <> $SessionUUID],
						Model[Sample,"ExperimentELISA test antibody model sample 6 HRP-conjugated secondary" <> $SessionUUID],


						(* Object samples *)
						Object[Sample,"ExperimentELISA test object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 3 discarded" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 4 solid" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 5 (semi-large volume)" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test object sample 6 (in liquid handler incompatible container)" <> $SessionUUID],
						(*Target Antigen Object Samples*)
						Object[Sample,"ExperimentELISA test target antigen object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test target antigen object sample 2" <> $SessionUUID],
						(* Antibody Object samples *)
						Object[Sample,"ExperimentELISA test antibody object sample 1 HRP-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 2 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 3 non-conjugated" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 4 tagged" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 5 anti-tag" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test antibody object sample 6 HRP-conjugated secondary" <> $SessionUUID],
						(*Containers in*)
						Object[Container,Plate,"ExperimentELISA test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ExperimentELISA test capture antibody-coated plate-2" <> $SessionUUID],
						(*Coated samples*)
						Object[Sample,"ExperimentELISA test coated object sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 2" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 3" <> $SessionUUID],
						Object[Sample,"ExperimentELISA test coated object sample 4" <> $SessionUUID]


					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	Parallel -> True,
	TurnOffMessages :> {Warning::SamplesOutOfStock, Warning::InstrumentUndergoingMaintenance,Warning::NegativeDiluentVolume}
];


(* ::Subsection::Closed:: *)
(*ELISAReadPlate*)
DefineTests[ELISAReadPlate,
	{
		Example[{Basic,"Build a basic ELISAReadPlate primitive and get the Sample:"},
			Module[{readPlatePrim},
				readPlatePrim = ELISAReadPlate[
					Sample -> {Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID]},
					MeasurementWavelength -> {450 Nanometer, 620 Nanometer},
					ReferenceWavelength -> 620,
					DataFilePath ->
							{{"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_\\450_nanometers_test.csv",
								"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_620_nanometers_test.csv"}}
				];
				readPlatePrim[Sample][[1]][Name]
			],
			"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID
		],

		Example[{Basic,"Build a basic ELISAReadPlate primitive and get the MeasurementWavelength:"},
			Module[{readPlatePrim},
				readPlatePrim = ELISAReadPlate[
					Sample -> {Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID]},
					MeasurementWavelength -> {450 Nanometer, 620 Nanometer},
					ReferenceWavelength -> 620,
					DataFilePath ->
							{{"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_\\450_nanometers_test.csv",
								"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_620_nanometers_test.csv"}}
				];
				readPlatePrim[MeasurementWavelength]
			],
			{450 Nanometer, 620 Nanometer}
		],

		Example[{Basic,"Build a basic ELISAReadPlate primitive and get the ReferenceWavelength:"},
			Module[{readPlatePrim},
				readPlatePrim = ELISAReadPlate[
					Sample -> {Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID]},
					MeasurementWavelength -> {450 Nanometer, 620 Nanometer},
					ReferenceWavelength -> 620,
					DataFilePath ->
							{{"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_\\450_nanometers_test.csv",
								"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_620_nanometers_test.csv"}}
				];
				readPlatePrim[ReferenceWavelength]
			],
			620
		],

		Example[{Basic,"Build a basic ELISAReadPlate primitive and get the DataFilePath:"},
			Module[{readPlatePrim},
				readPlatePrim = ELISAReadPlate[
					Sample -> {Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID]},
					MeasurementWavelength -> {450 Nanometer, 620 Nanometer},
					ReferenceWavelength -> 620,
					DataFilePath ->
							{{"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_\\450_nanometers_test.csv",
								"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_620_nanometers_test.csv"}}
				];
				readPlatePrim[DataFilePath]
			],
			{{"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_\\450_nanometers_test.csv",
				"\\\\10.0.0.105\\public\\Data\\ELISA\\_n80_d_nj1_dn_m5k\\ELISAPlate_620_nanometers_test.csv"}}
		]
	},


	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::NegativeDiluentVolume];
		ClearMemoization[];
		ClearDownload[];

		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{plate1,plate2,plate3,plate4},
			{plate1,plate2,plate3,plate4} = Table[CreateID[Object[Container,Plate]],4];
			Upload[
				{
					<|
						Object->plate1,
						Name->"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID
					|>,
					<|
						Object->plate2,
						Name->"ELISAReadPlate test sample-coated plate-2" <> $SessionUUID
					|>,
					<|
						Object->plate3,
						Name->"ELISAReadPlate test sample-coated plate-3" <> $SessionUUID
					|>,
					<|
						Object->plate4,
						Name->"ELISAReadPlate test sample-coated plate-4" <> $SessionUUID
					|>

				}
			]
		];

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAReadPlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::NegativeDiluentVolume]
		];
	}
];

(* ::Subsection::Closed:: *)
(*ELISAIncubatePlate*)

DefineTests[ELISAIncubatePlate,
	{
		Example[{Basic,"Build a basic ELISAIncubatePlate primitive and get the Sample:"},
			Module[{platePrim},
				platePrim = ELISAIncubatePlate[
					Sample -> {Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID]},
					IncubationTime->1800Second,
					IncubationTemperature->37Celsius,
					ShakingFrequency->1400 Milli Hertz
				];
				platePrim[Sample][[1]][Name]
			],
			"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID
		],

		Example[{Basic,"Build a basic ELISAIncubatePlate primitive and get the IncubationTime:"},
			Module[{platePrim},
				platePrim = ELISAIncubatePlate[
					Sample -> {Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID]},
					IncubationTime->1800Second,
					IncubationTemperature->37Celsius,
					ShakingFrequency->1400 Milli Hertz
				];
				platePrim[IncubationTime]
			],
			1800Second
		],

		Example[{Basic,"Build a basic ELISAIncubatePlate primitive and get the IncubationTemperature:"},
			Module[{platePrim},
				platePrim = ELISAIncubatePlate[
					Sample -> {Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID]},
					IncubationTime->1800Second,
					IncubationTemperature->37Celsius,
					ShakingFrequency->1400 Milli Hertz
				];
				platePrim[IncubationTemperature]
			],
			37Celsius
		],

		Example[{Basic,"Build a basic ELISAIncubatePlate primitive and get the ShakingFrequency:"},
			Module[{platePrim},
				platePrim = ELISAIncubatePlate[
					Sample -> {Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID]},
					IncubationTime->1800Second,
					IncubationTemperature->37Celsius,
					ShakingFrequency->1400 Milli Hertz
				];
				platePrim[ShakingFrequency]
			],
			1400 Milli Hertz
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::NegativeDiluentVolume];
		ClearMemoization[];
		ClearDownload[];

		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{plate1,plate2,plate3,plate4},
			{plate1,plate2,plate3,plate4} = Table[CreateID[Object[Container,Plate]],4];
			Upload[
				{
					<|
						Object->plate1,
						Name->"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID
					|>,
					<|
						Object->plate2,
						Name->"ELISAIncubatePlate test sample-coated plate-2" <> $SessionUUID
					|>,
					<|
						Object->plate3,
						Name->"ELISAIncubatePlate test sample-coated plate-3" <> $SessionUUID
					|>,
					<|
						Object->plate4,
						Name->"ELISAIncubatePlate test sample-coated plate-4" <> $SessionUUID
					|>

				}
			]
		];

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAIncubatePlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::NegativeDiluentVolume]
		];
	}
];

(* ::Subsection::Closed:: *)
(*ELISAWashPlate*)

DefineTests[ELISAWashPlate,
	{
		Example[{Basic,"Build a basic ELISAWashPlate primitive and get the Sample:"},
			Module[{platePrim},
				platePrim = ELISAWashPlate[
					Sample -> {Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID]},
					WashVolume->50Microliter,
					NumberOfWashes->2
				];
				platePrim[Sample][[1]][Name]
			],
			"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID
		],

		Example[{Basic,"Build a basic ELISAWashPlate primitive and get the WashVolume:"},
			Module[{platePrim},
				platePrim = ELISAWashPlate[
					Sample -> {Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID]},
					WashVolume->50Microliter,
					NumberOfWashes->2
				];
				platePrim[WashVolume]
			],
			50Microliter
		],

		Example[{Basic,"Build a basic ELISAWashPlate primitive and get the NumberOfWashes:"},
			Module[{platePrim},
				platePrim = ELISAWashPlate[
					Sample -> {Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID]},
					WashVolume->50Microliter,
					NumberOfWashes->2
				];
				platePrim[NumberOfWashes]
			],
			2
		],

		Example[{Basic,"Build a basic ELISAWashPlate primitive and get the pattern:"},
			Module[{platePrim},
				platePrim = ELISAWashPlate[
					Sample -> {Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID]},
					WashVolume->50Microliter,
					NumberOfWashes->2
				];
				platePrim
			],
			_ELISAWashPlate
		]
	},

	SymbolSetUp:>(
		(* Set $CreatedObjects to {} to catch all of objects created *)
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::NegativeDiluentVolume];
		ClearMemoization[];
		ClearDownload[];

		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]
		];

		Module[{plate1,plate2,plate3,plate4},
			{plate1,plate2,plate3,plate4} = Table[CreateID[Object[Container,Plate]],4];
			Upload[
				{
					<|
						Object->plate1,
						Name->"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID
					|>,
					<|
						Object->plate2,
						Name->"ELISAWashPlate test sample-coated plate-2" <> $SessionUUID
					|>,
					<|
						Object->plate3,
						Name->"ELISAWashPlate test sample-coated plate-3" <> $SessionUUID
					|>,
					<|
						Object->plate4,
						Name->"ELISAWashPlate test sample-coated plate-4" <> $SessionUUID
					|>

				}
			]
		];

	),


	SymbolTearDown:>{
		Module[{allObjects,existingObjects},
			allObjects=
					{
						(*Containers in*)
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-1" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-2" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-3" <> $SessionUUID],
						Object[Container,Plate,"ELISAWashPlate test sample-coated plate-4" <> $SessionUUID]

					};
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::NegativeDiluentVolume]
		];
	}
];