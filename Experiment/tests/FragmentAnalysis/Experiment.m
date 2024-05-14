(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentFragmentAnalysis*)


DefineTests[ExperimentFragmentAnalysis,

	{
		(*===Basic===*)

		
		Example[{Basic,"Accepts a sample object:"},
			ExperimentFragmentAnalysis[
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID]
			],
			ObjectP[Object[Protocol, FragmentAnalysis]]
		],
		Example[{Basic,"Accepts a container object:"},
			ExperimentFragmentAnalysis[Object[Container,Vessel,"Container 5 for ExperimentFragmentAnalysis tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, FragmentAnalysis]]
		],
		Example[{Basic,"Accepts a prepared plate container object:"},
			ExperimentFragmentAnalysis[
				Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
				PreparedPlate->True
			],
			ObjectP[Object[Protocol, FragmentAnalysis]]
		],
		Example[{Basic,"Accepts a list of samples:"},
			ExperimentFragmentAnalysis[{
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID],
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID]
			}],
			ObjectP[Object[Protocol, FragmentAnalysis]]
		],
		
		(*===Additional===*)
		Example[{Messages, "DiscardedSamples", "Discarded Samples cannot be used as inputs:"},
			ExperimentFragmentAnalysis[Object[Sample,"ExperimentFragmentAnalysis Test Sample Discarded" <> $SessionUUID],SampleAnalyteType->DNA,MinReadLength->10,MaxReadLength->100],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Test["AnalysisMethod is resolved appropriately when Sample Composition has analyte models that have Amounts that match MassConcentrationP or ConcentrationP:",
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			],
			ObjectP[Object[Method, FragmentAnalysis, "RNA (200 - 6000 nt) - High Sensitivity (pg/uL) - Qualitative, Short"]]
		],

		(*===Options===*)
		(*PreparedPlate Option*)
		Example[{Options,PreparedPlate,"PreparedPlate is successfully set to True if input is a compatible container:"},
			Lookup[
				ExperimentFragmentAnalysis[
				Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
				PreparedPlate->True,
				Output->Options
				],
				PreparedPlate
			],
			True
		],
		
		(*AnalysisMethodName Option*)
		Example[
			{Options,AnalysisMethodName,"If a FragmentAnalysis Method of the same name as AnalysisMethodName already exists in the Database, throw error:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],AnalysisMethodName->"dsDNA (75 - 20000 bp) - Standard Sensitivity (ng/uL) - Short",Output->Options],
				AnalysisMethodName
			],
			"dsDNA (75 - 20000 bp) - Standard Sensitivity (ng/uL) - Short",
			Messages :> {
				Error::DuplicateName,
				Error::InvalidOption
			}
		],

		(*Capillary Flush Options*)
		Example[
			{Options,CapillaryFlush,"CapillaryFlush is automatically set to False if NumberOfCapillaryFlushes is not specified:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Output->Options],
				CapillaryFlush
			],
			False
		],
		Example[
			{Options,CapillaryFlush,"CapillaryFlush is automatically set to True if NumberOfCapillaryFlushes is not Null:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->1,Output->Options],
				CapillaryFlush
			],
			True
		],
		Example[
			{Options,NumberOfCapillaryFlushes,"If CapillaryFlush is set to True, NumberOfCapillaryFlushes is automatically set to 1.:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],CapillaryFlush->True,Output->Options],
				NumberOfCapillaryFlushes
			],
			1
		],
		Example[
			{Options,NumberOfCapillaryFlushes,"If CapillaryFlush is Automatic, NumberOfCapillaryFlushes is Null.:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Output->Options],
				{CapillaryFlush,NumberOfCapillaryFlushes}
			],
			{False,Null}
		],
		Example[
			{Options,PrimaryCapillaryFlushSolution,"If NumberOfCapillaryFlushes is greater or equal to 1, PrimaryCapillaryFlushSolution is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					PrimaryCapillaryFlushSolution
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,PrimaryCapillaryFlushPressure,"If NumberOfCapillaryFlushes is greater or equal to 1, PrimaryCapillaryFlushPressure is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					PrimaryCapillaryFlushPressure
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,PrimaryCapillaryFlushFlowRate,"If NumberOfCapillaryFlushes is greater or equal to 1, PrimaryCapillaryFlushFlowRate is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					PrimaryCapillaryFlushFlowRate
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,PrimaryCapillaryFlushTime,"If NumberOfCapillaryFlushes is greater or equal to 1, PrimaryCapillaryFlushTime is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					PrimaryCapillaryFlushTime
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,SecondaryCapillaryFlushSolution,"If NumberOfCapillaryFlushes is greater or equal to 2, SecondaryCapillaryFlushSolution is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					SecondaryCapillaryFlushSolution
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,SecondaryCapillaryFlushPressure,"If NumberOfCapillaryFlushes is greater or equal to 2, SecondaryCapillaryFlushPressure is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					SecondaryCapillaryFlushPressure
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,SecondaryCapillaryFlushFlowRate,"If NumberOfCapillaryFlushes is greater or equal to 2, SecondaryCapillaryFlushFlowRate is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					SecondaryCapillaryFlushFlowRate
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,SecondaryCapillaryFlushTime,"If NumberOfCapillaryFlushes is greater or equal to 2, SecondaryCapillaryFlushTime is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->2,Output->Options],
					SecondaryCapillaryFlushTime
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,TertiaryCapillaryFlushSolution,"If NumberOfCapillaryFlushes is equal to 3, TertiaryCapillaryFlushSolution is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->3,Output->Options],
					TertiaryCapillaryFlushSolution
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,TertiaryCapillaryFlushPressure,"If NumberOfCapillaryFlushes is equal to 3, TertiaryCapillaryFlushPressure is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->3,Output->Options],
					TertiaryCapillaryFlushPressure
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,TertiaryCapillaryFlushFlowRate,"If NumberOfCapillaryFlushes is equal to 3, TertiaryCapillaryFlushFlowRate is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->3,Output->Options],
					TertiaryCapillaryFlushFlowRate
				],
				Except[Null]
			],
			True
		],
		Example[
			{Options,TertiaryCapillaryFlushTime,"If NumberOfCapillaryFlushes is equal to 3, TertiaryCapillaryFlushTime is not Null.:"},
			MatchQ[
				Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],NumberOfCapillaryFlushes->3,Output->Options],
					TertiaryCapillaryFlushTime
				],
				Except[Null]
			],
			True
		],
		(*AnalysisStrategy Option*)
		Example[
			{Options,AnalysisStrategy,"If AnalysisStrategy is not specified, it is automatically set to Qualitative.:"},
			Lookup[
					ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Output->Options],
					AnalysisStrategy
			],
			Qualitative
		],
		(*CapillaryArrayLength Option*)
		Example[
			{Options,CapillaryArrayLength,"If CapillaryArrayLength is not specified, it is automatically set to Short.:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Output->Options],
				CapillaryArrayLength
			],
			Short
		],

		(*SampleAnalyteType Option*)
		Example[
			{Options,SampleAnalyteType,"SampleAnalyteType is resolved based on PolymerType(s) of Models under Composition:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Output->Options],
				SampleAnalyteType
			],
			DNA
		],
		Example[
			{Options,SampleAnalyteType,"SampleAnalyteType is resolved based on PolymerType(s) of Models under Composition:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],Output->Options],
				SampleAnalyteType
			],
			RNA
		],

		Example[
			{Options,SampleAnalyteType,"SampleAnalyteType is resolved based on PolymerType(s) of Models under Composition, defaults to DNA if RNA=DNA:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Mixed" <> $SessionUUID],Output->Options],
				SampleAnalyteType
			],
			DNA
		],
		(*MinReadLength Option*)
		Example[
			{Options,MinReadLength,"MinReadLength is resolved based on SequenceLength of Models of PolymerType=SampleAnalyteType under Composition:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],Output->Options],
				MinReadLength
			],
			12
		],
		(*MaxReadLength Option*)
		Example[
			{Options,MaxReadLength,"MaxReadLength is resolved based on SequenceLength of Models of PolymerType=SampleAnalyteType under Composition:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],Output->Options],
				MaxReadLength
			],
			100
		],
		Example[
			{Options,MinReadLength,"MinReadLength and MaxReadLength is resolved based on SequenceLength of Models of PolymerType=SampleAnalyteType under Composition:"},
			Quiet[Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID],Output->Options],
				{MinReadLength,MaxReadLength}
			]],
			{Null,Null}
		],
		(*AnalysisMethod Option*)
		Example[
			{Options,AnalysisMethod,"AnalysisMethod is resolved based on Sample Composition information:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			],
			ObjectP[Object[Method, FragmentAnalysis,"RNA (200 - 6000 nt) - High Sensitivity (pg/uL) - Qualitative, Short"]]
		],
		(*CapillaryEquilibration Option*)
		Example[
			{Options,CapillaryEquilibration,"CapillaryEquilibration is resolved based on the resolved AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				CapillaryEquilibration
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][CapillaryEquilibration]
		],
		(*EquilibrationVoltage Option*)
		Example[
			{Options,EquilibrationVoltage,"EquilibrationVoltage is resolved based on the resolved AnalysisMethod if CapillaryEquilibration is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				EquilibrationVoltage
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][EquilibrationVoltage]
		],
		(*EquilibrationTime Option*)
		Example[
			{Options,EquilibrationTime,"EquilibrationVoltage is resolved based on the resolved AnalysisMethod if CapillaryEquilibration is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				EquilibrationTime
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][EquilibrationTime]
		],
		(*PreMarkerRinse Option*)
		Example[
			{Options,PreMarkerRinse,"PreMarkerRinse is resolved based on the resolved AnalysisMethod if NumberOfPreMarkerRinses is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				PreMarkerRinse
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][PreMarkerRinse]
		],
		Example[
			{Options,PreMarkerRinse,"PreMarkerRinse is True if NumberOfPreMarkerRinses is set to a Number:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Small RNA" <> $SessionUUID],NumberOfPreMarkerRinses->2, Output->Options],
				PreMarkerRinse
			],
			True
		],
		Example[
			{Options,PreMarkerRinse,"PreMarkerRinse is False if NumberOfPreMarkerRinses is set to a Null:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID],NumberOfPreMarkerRinses->Null, Output->Options],
				PreMarkerRinse
			],
			False
		],
		(*NumberOfPreMarkerRinses Option*)
		Example[
			{Options,NumberOfPreMarkerRinses,"NumberOfPreMarkerRinses is resolved based on AnalysisMethod if PreMarkerRinse is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				NumberOfPreMarkerRinses
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][NumberOfPreMarkerRinses]
		],
		(*MarkerInjection Option*)
		Example[
			{Options,MarkerInjection,"MarkerInjection is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				MarkerInjection
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][MarkerInjection]
		],
		(*MarkerInjectionTime Option*)
		Example[
			{Options,MarkerInjectionTime,"MarkerInjectionTime is resolved based on AnalysisMethod if MarkerInjection is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				MarkerInjectionTime
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][MarkerInjectionTime]
		],
		(*MarkerInjectionVoltage Option*)
		Example[
			{Options,MarkerInjectionVoltage,"MarkerInjectionVoltage is resolved based on AnalysisMethod if MarkerInjection is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				MarkerInjectionVoltage
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][MarkerInjectionVoltage]
		],
		(*PreSampleRinse Option*)
		Example[
			{Options,PreSampleRinse,"PreSampleRinse is resolved based on the resolved AnalysisMethod if NumberOfPreSampleRinses is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				PreSampleRinse
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][PreSampleRinse]
		],

		Example[
			{Options,PreSampleRinse,"PreSampleRinse is True if NumberOfPreSampleRinses is set to a Number:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID],NumberOfPreSampleRinses->2, Output->Options],
				PreSampleRinse
			],
			True
		],
		Example[
			{Options,PreSampleRinse,"PreSampleRinse is False if NumberOfPreSampleRinses is set to a Null:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID],NumberOfPreSampleRinses->Null, Output->Options],
				PreSampleRinse
			],
			False
		],
		(*NumberOfPreSampleRinses Option*)
		Example[
			{Options,NumberOfPreSampleRinses,"NumberOfPreSampleRinses is resolved based on AnalysisMethod if PreSampleRinse is Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				NumberOfPreSampleRinses
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][NumberOfPreSampleRinses]
		],
		(*SampleInjectionTime Option*)
		Example[
			{Options,SampleInjectionTime,"SampleInjectionTime is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleInjectionTime
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleInjectionTime]
		],
		(*SampleInjectionVoltage Option*)
		Example[
			{Options,SampleInjectionVoltage,"SampleInjectionVoltage is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleInjectionVoltage
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleInjectionVoltage]
		],
		(*SeparationTime Option*)
		Example[
			{Options,SeparationTime,"SeparationTime is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SeparationTime
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SeparationTime]
		],
		(*SeparationVoltage Option*)
		Example[
			{Options,SeparationVoltage,"SeparationVoltage is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SeparationVoltage
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SeparationVoltage]
		],
		(*Blank Option*)
		Example[
			{Options,Blank,"Blank is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				Blank
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][Blank]
		],
		(*BlankRunningBuffer Option*)
		Example[
			{Options,Blank,"BlankRunningBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				BlankRunningBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][BlankRunningBuffer]
		],
		(*BlankMarker Option*)
		Example[
			{Options,Blank,"BlankMarker is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				BlankMarker
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][BlankMarker]
		],
		(*SeparationGel Option*)
		Example[
			{Options,SeparationGel,"SeparationGel is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SeparationGel
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SeparationGel]
		],
		(*Dye Option*)
		Example[
			{Options,Dye,"Dye is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				Dye
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][Dye]
		],
		(*ConditioningSolution Option*)
		Example[
			{Options,ConditioningSolution,"ConditioningSolution is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				ConditioningSolution
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][ConditioningSolution]
		],
		(*PreMarkerRinseBuffer Option*)
		Example[
			{Options,PreMarkerRinseBuffer,"PreMarkerRinseBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				PreMarkerRinseBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][PreMarkerRinseBuffer]
		],
		(*PreSampleRinseBuffer Option*)
		Example[
			{Options,PreSampleRinseBuffer,"PreSampleRinseBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				PreSampleRinseBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][PreSampleRinseBuffer]
		],
		(*Ladder Option*)
		Example[
			{Options,Ladder,"Ladder is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				Ladder
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][Ladder]
		],
		(*LadderLoadingBuffer Option*)
		Example[
			{Options,LadderLoadingBuffer,"LadderLoadingBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				LadderLoadingBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][LadderLoadingBuffer]
		],
		(*LadderLoadingBufferVolume Option*)
		Example[
			{Options,LadderLoadingBufferVolume,"LadderLoadingBufferVolume is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				LadderLoadingBufferVolume
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][LadderLoadingBufferVolume]
		],
		(*LadderRunningBuffer Option*)
		Example[
			{Options,LadderRunningBuffer,"LadderRunningBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				LadderRunningBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][LadderRunningBuffer]
		],
		(*LadderMarker Option*)
		Example[
			{Options,LadderMarker,"LadderMarker is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				LadderMarker
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][LadderMarker]
		],
		(*SampleVolume Option*)
		Example[
			{Options,SampleVolume,"SampleVolume is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleVolume
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][TargetSampleVolume]
		],
		(*SampleLoadingBuffer Option*)
		Example[
			{Options,SampleLoadingBuffer,"SampleLoadingBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleLoadingBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleLoadingBuffer]
		],
		(*SampleLoadingBufferVolume Option*)
		Example[
			{Options,SampleLoadingBufferVolume,"SampleLoadingBufferVolume is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleLoadingBufferVolume
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleLoadingBufferVolume]
		],
		(*SampleRunningBuffer Option*)
		Example[
			{Options,SampleRunningBuffer,"SampleRunningBuffer is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleRunningBuffer
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleRunningBuffer]
		],
		(*SampleMarker Option*)
		Example[
			{Options,SampleMarker,"SampleMarker is resolved based on AnalysisMethod:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				SampleMarker
			],
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"  <> $SessionUUID], Output->Options],
				AnalysisMethod
			][SampleMarker]
		],

		(*MarkerPlateStorageCondition Option*)
		Example[
			{Options,MarkerPlateStorageCondition,"MarkerPlateStorageCondition is set to Refrigerator if MarkerInjection is True:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID], Output->Options],
				MarkerPlateStorageCondition
			],
			Refrigerator
		],
		(*NumberOfCapillaries Option*)
		Example[
			{Options,NumberOfCapillaries,"NumberOfCapillaries is set to 96 if total number of samples is less than 96 and Ladder and Blank is left Automatic:"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID], Output->Options],
				NumberOfCapillaries
			],
			96
		],
		(*CapillaryArray Option*)
		Example[
			{Options,CapillaryArray,"CapillaryArray is set based on NumberOfCapillaries and CapillaryArrayLength:"},
			Download[Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID],
					NumberOfCapillaries->96,
					CapillaryArrayLength->Short,
					Output->Options
				],
				CapillaryArray
			],
				{NumberOfCapillaries,CapillaryArrayLength}
			],
			{96,Short}
		],
		Example[
			{Options,CapillaryArray,"CapillaryArray resolves to CapillaryArray linked to selected Instrument if left Automatic:"},
			options= ExperimentFragmentAnalysis[
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID],
				Instrument->Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
				Output->Options
			];
			{instrument,capillaryArray}=Lookup[options,{Instrument,CapillaryArray}];
			MatchQ[capillaryArray[Instrument],ObjectP[instrument]],
			True,
			Variables :> {options,instrument,capillaryArray}
		],
		(*Instrument Option*)
		Example[
			{Options,Instrument,"Instrument resolves to Instrument linked to selected CapillaryArray if left Automatic:"},
			options= ExperimentFragmentAnalysis[
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA"  <> $SessionUUID],
				CapillaryArray->Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
				Output->Options
			];
			{instrument,capillaryArray}=Lookup[options,{Instrument,CapillaryArray}];
			MatchQ[instrument[CapillaryArray],ObjectP[capillaryArray]],
			True,
			Variables :> {options,instrument,capillaryArray}
		],
		(*PreparedRunningBufferPlate Option*)
		Example[
			{Options,PreparedRunningBufferPlate,"PreparedRunningBufferPlate resolves to supplied PreparedRunningBufferPlate:"},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedRunningBufferPlate->Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					Output->Options],
				PreparedRunningBufferPlate
			],
			ObjectP[Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID]]
		],
		(*PreparedMarkerPlate Option*)
		Example[
			{Options,PreparedMarkerPlate,"PreparedMarkerPlate resolves to supplied PreparedRunningBufferPlate:"},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedMarkerPlate->Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					Output->Options],
				PreparedMarkerPlate
			],
			ObjectP[Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID]]
		],

		(*===Messages===*)
		Example[
			{Messages,"AnalysisMethodAnalysisStrategyMismatchWarning","If the AnalysisMethod selected is not optimal for Quantitative Analysis and AnalysisStrategy is Quantitative, throw a Warning:"},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"<>$SessionUUID],AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - High Sensitivity (pg/uL) - Qualitative, Short"],AnalysisStrategy->Quantitative,Output->Options],AnalysisStrategy],
			Quantitative,
			Messages :> {
				Warning::AnalysisMethodAnalysisStrategyMismatchWarning
			}
		],
		Example[
			{Messages,"SampleAnalyteTypeAnalysisMethodMismatch","If the SampleAnalyteType of the following sample(s) do(es) not match the TargetAnalyteType of the AnalysisMethod,throw a Warning:"},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis RNA Low Concentration"<>$SessionUUID],AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (75 -15000 bp) - Standard Sensitivity (ng/uL) - Short"],Output->Options],SampleAnalyteType],
			RNA,
			Messages :> {
				Warning::SampleAnalyteTypeAnalysisMethodMismatch
			}
		],
		(*Capillary Flush Messages*)
		Example[{Messages, "CapillaryFlushNumberOfCapillaryFlushesMismatchError", "If CapillaryFlush is set to False and NumberOfCapillaryFlushes is not Null, throw an error:"},
			ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],CapillaryFlush->False, NumberOfCapillaryFlushes->2,AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]],
			$Failed,
			Messages :> {
				Error::CapillaryFlushNumberOfCapillaryFlushesMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CapillaryFlushNumberOfCapillaryFlushesMismatchError", "If CapillaryFlush is set to True and NumberOfCapillaryFlushes is Null, throw an error:"},
			ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],CapillaryFlush->True, NumberOfCapillaryFlushes->Null,AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]],
			$Failed,
			Messages :> {
				Error::CapillaryFlushNumberOfCapillaryFlushesMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PrimaryCapillaryFlushMismatchError", "If CapillaryFlush is False, and any of the options PrimaryCapillaryFlushSolution, PrimaryCapillaryFlushPressure, PrimaryCapillaryFlushFlowRate and PrimaryCapillaryFlushTime is not Null, throw an error:"},
			ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],CapillaryFlush->False, PrimaryCapillaryFlushPressure->200 PSI,AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]],
			$Failed,
			Messages :> {
				Error::PrimaryCapillaryFlushMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SecondaryCapillaryFlushMismatchError", "If NumberOfCapillaryFlushes is less 1 or Null, and any of the options SecondaryCapillaryFlushSolution, SecondaryCapillaryFlushPressure, SecondaryCapillaryFlushFlowRate and SecondaryCapillaryFlushTime is not Null, throw an error:"},
			ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID], SecondaryCapillaryFlushPressure->200 PSI,AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]],
			$Failed,
			Messages :> {
				Error::SecondaryCapillaryFlushMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TertiaryCapillaryFlushMismatchError", "If NumberOfCapillaryFlushes is less 2 or Null, and any of the options TertiaryCapillaryFlushSolution, TertiaryCapillaryFlushPressure, TertiaryCapillaryFlushFlowRate and TertiaryCapillaryFlushTime is not Null, throw an error:"},
			ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID], NumberOfCapillaryFlushes->2,TertiaryCapillaryFlushPressure->200 PSI,AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"]],
			$Failed,
			Messages :> {
				Error::TertiaryCapillaryFlushMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CantDetermineSampleAnalyteType", "If SampleAnalyteType cannot be determined based on Sample Composition information,default to DNA and throw a warning"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID],Output->Options],
				{SampleAnalyteType,MinReadLength,MaxReadLength}
			],
			{DNA,Null,Null},
			Messages :> {
				Warning::CantDetermineSampleAnalyteType,
				Warning::CantDetermineReadLengths
			}
		],
		Example[{Messages, "CantDetermineReadLengths", "If MaxReadLength or MinReadLength cannot be determined based on Sample Composition information,default to Null and throw a warning"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID],Output->Options],
				{MinReadLength,MaxReadLength}
			],
			{Null,Null},
			Messages :> {
				Warning::CantDetermineSampleAnalyteType,
				Warning::CantDetermineReadLengths
			}
		],
		Example[{Messages, "AnalysisMethodNotOptimized", "If the determined AnalysisMethod optimized for one or more of the sample(s) does not match the final resolvedAnalysisMethod, throw a warning"},
			Lookup[
				ExperimentFragmentAnalysis[{Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID]},Output->Options],
				AnalysisMethod
			],
			ObjectP[Object[Method,FragmentAnalysis]],
			Messages :> {
				Warning::AnalysisMethodNotOptimized
			}
		],
		Example[{Messages, "AnalysisMethodOptionsMismatch", "If any specified options do not match the field value of the resolved AnalysisMethod, throw a Warning"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					SeparationGel->Model[Sample,"Milli-Q water"],
					Dye->Model[Sample,"Milli-Q water"],
					ConditioningSolution->Model[Sample,"Milli-Q water"],
					PreMarkerRinseBuffer->Model[Sample,"Milli-Q water"],
					CapillaryEquilibration->False,
					PreMarkerRinse->True,
					MarkerInjection->True,
					PreSampleRinse->False,
					SampleInjectionTime->10 Second,
					SampleInjectionVoltage->10 Kilovolt,
					SeparationTime->40 Minute,
					SeparationVoltage->8 Kilovolt,
					Output->Options
				],
				AnalysisMethod
			],
			ObjectP[Object[Method,FragmentAnalysis]],
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodSampleOptionsMismatch
			}
		],
		Example[{Messages, "BlankRunningBufferMismatch", "If Blank is Not Null and BlankRunningBuffer is Null, throw an error."},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
				AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
				BlankRunningBuffer->Null,
				Output->Options
			],
				BlankRunningBuffer
			],
			Null,
			Messages :> {
				Error::BlankRunningBufferMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BlankRunningBufferMismatch", "If Blank is Null and BlankRunningBuffer is not Null, throw an error."},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
				AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
				Blank->Null,
				BlankRunningBuffer->Model[Sample,StockSolution,"1x Running Buffer for ExperimentFragmentAnalysis"],
				Output->Options
			],
				Blank
			],
			Null,
			Messages :> {
				Error::BlankRunningBufferMismatch,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BlankMarkerMismatch", "If Blank is Null and BlankMarker is not Null, throw an error."},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
				AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
				Blank->Null,
				BlankMarker->Model[Sample,"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],
				Output->Options
			],
				Blank
			],
			Null,
			Messages :> {
				Error::BlankMarkerMismatch,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CapillaryEquilibrationOptionsMismatchErrors", "If CapillaryEquilibration is False and any of EquilibrationVoltage and EquilibrationTime is Not Null OR If CapillaryEquilibration is True and any of EquilibrationVoltage and EquilibrationTime is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					CapillaryEquilibration->True,
					EquilibrationVoltage->Null,
					EquilibrationTime->Null,
					Output->Options],
				{CapillaryEquilibration,EquilibrationVoltage,EquilibrationTime}
			],
			{True,Null,Null},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::CapillaryEquilibrationOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CapillaryEquilibrationOptionsMismatchErrors", "If CapillaryEquilibration is False and any of EquilibrationVoltage and EquilibrationTime is Not Null OR If CapillaryEquilibration is True and any of EquilibrationVoltage and EquilibrationTime is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					CapillaryEquilibration->False,
					EquilibrationVoltage->8 Kilovolt,
					EquilibrationTime->3 Second,
					Output->Options],
				{CapillaryEquilibration,EquilibrationVoltage,EquilibrationTime}
			],
			{False,8 Kilovolt,3 Second},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::CapillaryEquilibrationOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreMarkerRinseOptionsMismatchErrors", "If PreMarkerRinse is False and any of NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition is Not Null OR If PreMarkerRinse is True and any of NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreMarkerRinse->False,
					NumberOfPreMarkerRinses->2,
					PreMarkerRinseBuffer->Model[Sample,"0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
					PreMarkerRinseBufferPlateStorageCondition->AmbientStorage,
					Output->Options],
				{PreMarkerRinse,NumberOfPreMarkerRinses,PreMarkerRinseBuffer,PreMarkerRinseBufferPlateStorageCondition}
			],
			{False,2,ObjectP[Model[Sample,"0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]],AmbientStorage},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::PreMarkerRinseOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreMarkerRinseOptionsMismatchErrors", "If PreMarkerRinse is False and any of NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition is Not Null OR If PreMarkerRinse is True and any of NumberOfPreMarkerRinses, PreMarkerRinseBuffer and PreMarkerRinseBufferPlateStorageCondition is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreMarkerRinse->True,
					NumberOfPreMarkerRinses->Null,
					PreMarkerRinseBuffer->Null,
					PreMarkerRinseBufferPlateStorageCondition->Null,
					Output->Options],
				{PreMarkerRinse,NumberOfPreMarkerRinses,PreMarkerRinseBuffer,PreMarkerRinseBufferPlateStorageCondition}
			],
			{True,Null,Null,Null},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::PreMarkerRinseOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MarkerInjectionOptionsMismatchErrors", "If MarkerInjection is False and any of MarkerInjectionTime and MarkerInjectionVoltage is Not Null OR If MarkerInjection is True and any of MarkerInjectionTime and MarkerInjectionVoltage is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					MarkerInjection->True,
					MarkerInjectionTime->Null,
					MarkerInjectionVoltage->Null,
					Output->Options],
				{MarkerInjection,MarkerInjectionTime,MarkerInjectionVoltage}
			],
			{True,Null,Null},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::MarkerInjectionOptionsMismatchErrors,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MarkerInjectionOptionsMismatchErrors", "If MarkerInjection is False and any of MarkerInjectionTime and MarkerInjectionVoltage is Not Null OR If MarkerInjection is True and any of MarkerInjectionTime and MarkerInjectionVoltage is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					MarkerInjection->True,
					MarkerInjectionTime->Null,
					MarkerInjectionVoltage->Null,
					Output->Options],
				{MarkerInjection,MarkerInjectionTime,MarkerInjectionVoltage}
			],
			{True,Null,Null},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::MarkerInjectionOptionsMismatchErrors,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MarkerInjectionOptionsMismatchErrors", "If MarkerInjection is False and any of MarkerInjectionTime and MarkerInjectionVoltage is Not Null OR If MarkerInjection is True and any of MarkerInjectionTime and MarkerInjectionVoltage is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					MarkerInjection->False,
					MarkerInjectionTime->5 Second,
					MarkerInjectionVoltage->10 Kilovolt,
					Output->Options],
				{MarkerInjection,MarkerInjectionTime,MarkerInjectionVoltage}
			],
			{False,5 Second,10 Kilovolt},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::MarkerInjectionOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MarkerInjectionPreparedMarkerPlateMismatchErrors", "If MarkerInjection is False and PreparedMarkerPlate is Not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedMarkerPlate->Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					MarkerInjection->False,
					Output->Options],
				{MarkerInjection,PreparedMarkerPlate}
			],
			{False,ObjectP[]},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::MarkerInjectionPreparedMarkerPlateMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreSampleRinseOptionsMismatchErrors", "If PreSampleRinse is False and any of NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition is Not Null OR If PreSampleRinse is True and any of NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreSampleRinse->True,
					NumberOfPreSampleRinses->Null,
					PreSampleRinseBuffer->Null,
					PreSampleRinseBufferPlateStorageCondition->Null,
					Output->Options],
				{PreSampleRinse,NumberOfPreSampleRinses,PreSampleRinseBuffer,PreSampleRinseBufferPlateStorageCondition}
			],
			{True,Null,Null,Null},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::PreSampleRinseOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreSampleRinseOptionsMismatchErrors", "If PreSampleRinse is False and any of NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition is Not Null OR If PreSampleRinse is True and any of NumberOfPreSampleRinses, PreSampleRinseBuffer and PreSampleRinseBufferPlateStorageCondition is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreSampleRinse->False,
					NumberOfPreSampleRinses->2,
					PreSampleRinseBuffer->Model[Sample,"0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
					PreSampleRinseBufferPlateStorageCondition->AmbientStorage,
					Output->Options],
				{PreSampleRinse,NumberOfPreSampleRinses,PreSampleRinseBuffer,PreSampleRinseBufferPlateStorageCondition}
			],
			{False,2,ObjectP[Model[Sample,"0.25x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]],AmbientStorage},
			Messages :> {
				Warning::AnalysisMethodOptionsMismatch,
				Error::PreSampleRinseOptionsMismatchErrors,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderPreparedPlateMismatchError", "If PreparedPlate is True and Ladder is an object OR if PreparedPlate is False and Ladder is a WellPosition, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->True,
					Ladder->Model[Sample,"200-6000 nt RNA Ladder for ExperimentFragmentAnalysis"],
					Output->Options],
				{PreparedPlate,Ladder}
			],
			{True,ObjectP[Model[Sample,"200-6000 nt RNA Ladder for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::PreparedPlateModelError,
				Error::LadderPreparedPlateMismatchError,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderPreparedPlateMismatchError", "If PreparedPlate is True and Ladder is an object OR if PreparedPlate is False and Ladder is a WellPosition, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->False,
					Ladder->"H12",
					Output->Options],
				{PreparedPlate,Ladder}
			],
			{False,"H12"},
			Messages :> {
				Error::LadderPreparedPlateMismatchError,
				Warning::AnalysisMethodLadderMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderVolumeMismatchError", "If Ladder is a specified Object and LadderVolume is Null or if Ladder is Null and LadderVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					LadderVolume->Null,
					Output->Options],
				{LadderVolume}
			],
			{Null},
			Messages :> {
				Error::LadderVolumeMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderVolumeMismatchError", "If Ladder is a specified Object and LadderVolume is Null or if Ladder is Null and LadderVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Ladder->Null,
					LadderVolume->2 Microliter,
					Output->Options],
				{LadderVolume}
			],
			{2 Microliter},
			Messages :> {
				Error::LadderVolumeMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodLadderMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderOptionsPreparedPlateMismatchError", "If PreparedPlate is True and ladder related options including LadderVolume,LadderLoadingBuffer, and LadderLoadingBufferVolume are not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->True,
					Ladder->{"H12"},
					LadderVolume->2 Microliter,
					LadderLoadingBuffer->Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"],
					LadderLoadingBufferVolume->22 Microliter,
					Output->Options],
				{PreparedPlate,Ladder,LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume}
			],
			{True,{"H12"},2 Microliter,ObjectP[Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"]],22 Microliter},
			Messages :> {
				Error::PreparedPlateModelError,
				Error::LadderOptionsPreparedPlateMismatchError,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderLoadingBufferMismatchError", "If Ladder is a specified Object and LadderVolume is Null or if Ladder is Null and LadderVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Ladder->Null,
					LadderLoadingBuffer->Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"],
					Output->Options],
				{LadderLoadingBuffer}
			],
			{ObjectP[Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::LadderLoadingBufferMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodLadderMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderLoadingBufferVolumeMismatchError", "If LadderLoadingBuffer is a specified Object and LadderLoadingBufferVolume is Null or if LadderLoadingBuffer is Null and LadderLoadingBufferVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					LadderLoadingBuffer->Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"],
					LadderLoadingBufferVolume->Null,
					Output->Options],
				{LadderLoadingBuffer,LadderLoadingBufferVolume}
			],
			{ObjectP[Model[Sample,"Loading Buffer with 15 nt RNA Marker for ExperimentFragmentAnalysis"]],Null},
			Messages :> {
				Error::LadderLoadingBufferVolumeMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderLoadingBufferVolumeMismatchError", "If LadderLoadingBuffer is a specified Object and LadderLoadingBufferVolume is Null or if LadderLoadingBuffer is Null and LadderLoadingBufferVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					LadderLoadingBuffer->Null,
					LadderLoadingBufferVolume->22 Microliter,
					Output->Options],
				{LadderLoadingBuffer,LadderLoadingBufferVolume}
			],
			{Null, 22 Microliter},
			Messages :> {
				Error::LadderLoadingBufferVolumeMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MaxLadderVolumeError", "If the total volume for LadderVolume and LadderLoadingBufferVolume is greater than 200 Microliter, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					LadderVolume->100 Microliter,
					LadderLoadingBufferVolume->110 Microliter,
					Output->Options],
				{LadderVolume,LadderLoadingBufferVolume}
			],
			{100 Microliter,110 Microliter},
			Messages :> {
				Error::MaxLadderVolumeError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderRunningBufferMismatchError", "If Ladder is specified and LadderRunningBuffer is Null OR If Ladder is Null and LadderRunningBuffer is specified, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					LadderRunningBuffer->Null,
					Output->Options],
				{LadderRunningBuffer}
			],
			{Null},
			Messages :> {
				Error::LadderRunningBufferMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderRunningBufferMismatchError", "If Ladder is specified and LadderRunningBuffer is Null OR If Ladder is Null and LadderRunningBuffer is specified, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Ladder->Null,
					LadderRunningBuffer->Model[Sample,StockSolution,"1x Running Buffer for ExperimentFragmentAnalysis"],
					Output->Options],
				{LadderRunningBuffer}
			],
			{ObjectP[Model[Sample,StockSolution,"1x Running Buffer for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::LadderRunningBufferMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodLadderMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderRunningBufferMismatchError", "If Ladder is specified and LadderRunningBuffer is Null OR If Ladder is Null and LadderRunningBuffer is specified, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->True,
					Ladder->"H12",
					LadderRunningBuffer->Null,
					Output->Options],
				{LadderRunningBuffer}
			],
			{Null},
			Messages :> {

				Error::PreparedPlateModelError,
				Error::LadderRunningBufferMismatchError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderRunningBufferMismatchError", "If Ladder is specified and LadderRunningBuffer is Null OR If Ladder is Null and LadderRunningBuffer is specified, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->True,
					LadderRunningBuffer->Model[Sample,StockSolution,"1x Running Buffer for ExperimentFragmentAnalysis"],
					Output->Options],
				{LadderRunningBuffer}
			],
			{ObjectP[Model[Sample,StockSolution,"1x Running Buffer for ExperimentFragmentAnalysis"]]},
			Messages :> {

				Error::PreparedPlateModelError,
				Error::LadderRunningBufferMismatchError,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderMarkerMismatchError", "If the determined AnalysisMethod optimized for one or more of the sample(s) does not match the final resolvedAnalysisMethod, throw a warning"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					Ladder->Null,
					LadderMarker->Model[Sample,"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{Ladder,LadderMarker}
			],
			{Null,ObjectP[Model[Sample,"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::LadderMarkerMismatchError,
				Warning::AnalysisMethodLadderMismatch,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "LadderMarkerMismatchError", "If the determined AnalysisMethod optimized for one or more of the sample(s) does not match the final resolvedAnalysisMethod, throw a warning"},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					PreparedPlate->True,
					Ladder->Null,
					LadderMarker->Model[Sample,"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{Ladder,LadderMarker}
			],
			{Null,ObjectP[Model[Sample,"35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::LadderMarkerMismatchError,
				Error::PreparedPlateModelError,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AnalysisMethodLadderOptionsMismatch", "For PreparedPlate is False, if the indicated values for the ladder-related options are not the same as the corresponding field values in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					LadderVolume-> 30 Microliter,
					LadderLoadingBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					LadderLoadingBufferVolume->30 Microliter,
					LadderRunningBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					LadderMarker->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume,LadderRunningBuffer,LadderMarker}
			],
			{30 Microliter,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],30 Microliter,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Warning::AnalysisMethodLadderOptionsMismatch
			}
		],
		Example[{Messages, "AnalysisMethodLadderOptionsMismatch", "For PreparedPlate is True, if the indicated values for the ladder-related options are not the same as the corresponding field values in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],95],
					PreparedPlate->True,
					Ladder->"H12",
					LadderRunningBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					LadderMarker->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{LadderVolume,LadderLoadingBuffer,LadderLoadingBufferVolume,LadderRunningBuffer,LadderMarker}
			],
			{Null,Null,Null,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::PreparedPlateModelError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AnalysisMethodLadderMismatch", "If the indicated Ladder not the same as the corresponding field value in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					Ladder->Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"],
					Output->Options],
				{Ladder}
			],
			{ObjectP[Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Warning::AnalysisMethodLadderMismatch
			}
		],
		Example[{Messages, "AnalysisMethodLadderMismatch", "If the indicated Ladder not the same as the corresponding field value in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					Ladder->{Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"],Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"]},
					Output->Options],
				{Ladder}
			],
			{{ObjectP[Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"]],ObjectP[Model[Sample,"15-200 nt RNA HS Ladder for ExperimentFragmentAnalysis"]]}},
			Messages :> {
				Warning::AnalysisMethodLadderMismatch
			}
		],
		Example[{Messages, "CantCalculateSampleVolume", "If SampleDilution is True and the SampleVolume cannot be calculated because on limited information, set a default value and throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					Output->Options],
				{SampleVolume,SampleDiluentVolume}
			],
			{EqualP[2 Microliter], EqualP[2 Microliter]},
			Messages :> {
				Warning::CantCalculateSampleVolume,
				Warning::CantCalculateSampleDiluentVolume,
				Warning::AnalysisMethodSampleOptionsMismatch
			}
		],
		Example[{Messages, "CantCalculateSampleVolume", "If SampleDilution is True and the SampleVolume cannot be calculated because on limited information, set a default value and throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleDiluentVolume->Null,
					Output->Options],
				{SampleVolume,SampleDiluentVolume}
			],
			{EqualP[2 Microliter], Null},
			Messages :> {
				Warning::CantCalculateSampleVolume,
				Error::SampleDilutionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CantCalculateSampleDiluentVolume", "If the SampleDiluentVolume cannot be calculated (because SampleVolume is Null or not less than target SampleVolume), set to a default value and throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleVolume->3 Microliter,
					Output->Options],
				{SampleVolume,SampleDiluentVolume}
			],
			{EqualP[3 Microliter], EqualP[2 Microliter]},
			Messages :> {
				Warning::CantCalculateSampleDiluentVolume,
				Warning::AnalysisMethodSampleOptionsMismatch
			}
		],
		Example[{Messages, "CantCalculateSampleDiluentVolume", "If the SampleDiluentVolume cannot be calculated (because SampleVolume is Null or not less than target SampleVolume), set to a default value and throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleVolume->Null,
					Output->Options],
				{SampleVolume,SampleDiluentVolume}
			],
			{Null, EqualP[2 Microliter]},
			Messages :> {
				Warning::CantCalculateSampleDiluentVolume,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::SampleVolumeError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleVolumeError", "If PreparedPlate is False and SampleVolume is Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleVolume->Null,
					Output->Options],
				{SampleVolume,SampleDiluentVolume}
			],
			{Null, EqualP[2 Microliter]},
			Messages :> {
				Warning::CantCalculateSampleDiluentVolume,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::SampleVolumeError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleOptionsPreparedPlateMismatchError", "If PreparedPlate is True, SampleDilution must be False and sample-related options (SampleDiluent,SampleVolume,SampleDiluentVolume,SampleLoadingBuffer,SampleLoadingBufferVolume) must be Null. If not, throw an error."},
			ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],96],
				PreparedPlate->True,
				SampleDilution->True,
				SampleVolume->2 Microliter,
				SampleDiluentVolume->2 Microliter,
				SampleDiluent->Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
				SampleLoadingBuffer->Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
				SampleLoadingBufferVolume->22 Microliter]
			,
			$Failed,
			Messages :> {
				Error::PreparedPlateModelError,
				Error::SampleOptionsPreparedPlateMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleDilutionMismatch", "If SampleDilution is True and SampleDiluent or SampleDiluentVolume is Null, set a default value and throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleDiluent->Null,
					SampleDiluentVolume->Null,
					Output->Options],
				{SampleDiluent,SampleDiluentVolume}
			],
			{Null, Null},
			Messages :> {
				Warning::CantCalculateSampleVolume,
				Error::SampleDilutionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleDilutionMismatch", "If SampleDilution is False and SampleDiluent or SampleDiluentVolume is not Null, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->False,
					SampleDiluent->Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
					SampleDiluentVolume->2 Microliter,
					Output->Options],
				{SampleDiluent,SampleDiluentVolume}
			],
			{ObjectP[Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]], EqualP[2 Microliter]},
			Messages :> {
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::SampleDilutionMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleLoadingBufferVolumeMismatchError", "If SampleLoadingBuffer is Null and SampleLoadingBufferVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleLoadingBuffer->Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
					SampleLoadingBufferVolume->Null,
					Output->Options],
				{SampleLoadingBuffer,SampleLoadingBufferVolume}
			],
			{ObjectP[Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]], Null},
			Messages :> {
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::SampleLoadingBufferVolumeMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "SampleLoadingBufferVolumeMismatchError", "If SampleLoadingBuffer is Null and SampleLoadingBufferVolume is not Null, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleLoadingBuffer->Null,
					SampleLoadingBufferVolume->22 Microliter,
					Output->Options],
				{SampleLoadingBuffer,SampleLoadingBufferVolume}
			],
			{Null, EqualP[22 Microliter]},
			Messages :> {
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::SampleLoadingBufferVolumeMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MaxSampleVolumeError", "If the total of SampleVolume, SampleDiluentVolume and SampleLoadingBufferVolume is greater than 200 Microliter, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleVolume->22 Microliter,
					SampleLoadingBufferVolume->200 Microliter,
					Output->Options],
				{SampleVolume,SampleLoadingBufferVolume}
			],
			{EqualP[22 Microliter],EqualP[200 Microliter]},
			Messages :> {
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::MaxSampleVolumeError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MaxSampleVolumeError", "If the total of SampleVolume, SampleDiluentVolume and SampleLoadingBufferVolume is greater than 200 Microliter, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleDilution->True,
					SampleLoadingBufferVolume->200 Microliter,
					Output->Options],
				{SampleVolume,SampleDiluentVolume,SampleLoadingBufferVolume}
			],
			{EqualP[2 Microliter],EqualP[2 Microliter],EqualP[200 Microliter]},
			Messages :> {
				Warning::CantCalculateSampleVolume,
				Warning::CantCalculateSampleDiluentVolume,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::MaxSampleVolumeError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AnalysisMethodSampleOptionsMismatch", "For PreparedPlate is False, if the indicated values for the sample-related options are not the same as the corresponding field values in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					SampleVolume-> 30 Microliter,
					SampleLoadingBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					SampleLoadingBufferVolume->30 Microliter,
					SampleRunningBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					SampleMarker->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,SampleRunningBuffer,SampleMarker}
			],
			{30 Microliter,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],30 Microliter,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Warning::AnalysisMethodSampleOptionsMismatch
			}
		],
		Example[{Messages, "AnalysisMethodSampleOptionsMismatch", "For PreparedPlate is True, if the indicated values for the sample-related options are not the same as the corresponding field values in the AnalysisMethod, throw a Warning."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],96],
					PreparedPlate->True,
					SampleRunningBuffer->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					SampleMarker->Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"],
					Output->Options],
				{SampleVolume,SampleLoadingBuffer,SampleLoadingBufferVolume,SampleRunningBuffer,SampleMarker}
			],
			{Null,Null,Null,ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]],ObjectP[Model[Sample,"Loading Buffer with 1 bp and 1500 bp DNA Markers for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::PreparedPlateModelError,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "AllOrNothingMarkerError", "For all samples, Ladder or Blank that are not Null, SampleMarker, LadderMarker and BlankMarker must be either all Null OR all Objects or Models. Otherwise, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],94],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					BlankMarker->Null,
					Output->Options],
				BlankMarker
			],
			Null,
			Messages :> {
				Error::AllOrNothingMarkerError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "FragmentAnalysisTooManySamples", "If number of SamplesIn is greater than 96, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],97],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Output->Options],
				NumberOfCapillaries
			],
			96,
			Messages :> {
				Error::InvalidInput,
				Error::FragmentAnalysisTooManySamples,
				Warning::AnalysisMethodLadderMismatch,
				Warning::AnalysisMethodLadderOptionsMismatch
			}
		],
		Example[{Messages, "TooManySolutionsForInjection", "If PreparedPlate is False and the total number of SamplesIn + Ladder + Blank is greater than 96, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],96],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Ladder->Model[Sample,"200-6000 nt RNA Ladder for ExperimentFragmentAnalysis"],
					Output->Options],
				Ladder
			],
			ObjectP[Model[Sample,"200-6000 nt RNA Ladder for ExperimentFragmentAnalysis"]],
			Messages :> {
				Error::TooManySolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NotEnoughSolutionsForInjection", "If PreparedPlate is False and the total number of SamplesIn + Ladder + Blank is less than 96, throw an error."},
			Lookup[ExperimentFragmentAnalysis[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
				AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
				Blank->Null,
				Output->Options
			],
				Blank
			],
			Null,
			Messages :> {
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BlankPreparedPlateMismatchError", "If PreparedPlate is True and Blank is an object OR if PreparedPlate is False and Blank is a WellPosition, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],95],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					Blank->"H12",
					Output->Options],
				{PreparedPlate,Blank}
			],
			{False,"H12"},
			Messages :> {
				Error::BlankPreparedPlateMisMatchError,
				Error::TooManySolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BlankPreparedPlateMismatchError", "If PreparedPlate is True and Blank is an object OR if PreparedPlate is False and Blank is a WellPosition, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[Table[Object[Sample,"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],95],
					AnalysisMethod->Object[Method,FragmentAnalysis,"RNA (200 - 6000 nt) - Standard Sensitivity (ng/uL) - Qualitative, Short"],
					PreparedPlate->True,
					Blank->Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"],
					Output->Options],
				{PreparedPlate,Blank}
			],
			{True,ObjectP[Model[Sample,"1x Tris-EDTA (TE) Buffer for ExperimentFragmentAnalysis"]]},
			Messages :> {
				Error::PreparedPlateModelError,
				Error::BlankPreparedPlateMisMatchError,
				Error::NotEnoughSolutionsForInjection,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedMarkerPlateError", "If PreparedMarkerPlate is an object, and any member of supplied SampleMarkers, LadderMarkers or BlankMarkers do not match the corresponding well content(s), throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedMarkerPlate->Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					LadderMarker->Object[Sample,"Test MarkerSample 3 for ExperimentFragmentAnalysis" <> $SessionUUID],
					Output->Options],
				PreparedMarkerPlate
			],
			ObjectP[Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID]],
			Messages :> {
				Error::PreparedMarkerPlateError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedRunningBufferPlateError", "If PreparedRunningBufferPlate is an object, and any member of supplied SampleRunningBuffers, LadderRunningBuffers or BlankRunningBuffers do not match the corresponding well content(s), throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedRunningBufferPlate->Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					LadderRunningBuffer->Object[Sample,"Test RunningBufferSample 3 for ExperimentFragmentAnalysis" <> $SessionUUID],
					Output->Options],
				PreparedRunningBufferPlate
			],
			ObjectP[Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID]],
			Messages :> {
				Error::PreparedRunningBufferPlateError,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DuplicateWells","All wells assigned to SamplesIn, Ladder and Blank are unique. Otherwise, throw an error.:"},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					PreparedPlate->True,
					Ladder->"H12",
					Blank->"H12",
					Output->Options
				],
				{Ladder,Blank}
			],
			{"H12","H12"},
			Messages :> {
				Error::DuplicateWells,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedPlateModelError", "If PreparedPlate is set to True, and the input container is not a compatible plate, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Container, Plate, "RunningBufferPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedPlate->True,
					Output->Options
				],
				PreparedPlate
			],
			True,
			Messages :> {
				Error::PreparedPlateModelError,
				Error::InvalidOption
			}
		],
		Example[{Messages,"PreparedPlateAliquotMismatchError","PreparedPlate is successfully set to True if input is a compatible container:"},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					PreparedPlate->True,
					Aliquot->True,
					Output->Options
				],
				PreparedPlate
			],
			True,
			Messages :> {
				Error::PreparedPlateAliquotMismatchError,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedRunningBufferPlateModelError", "If PreparedRunningBufferPlate is an object, and the container is not a compatible plate, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedRunningBufferPlate->Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					Output->Options
				],
				PreparedRunningBufferPlate
			],
			ObjectP[Object[Container,Plate]],
			Messages :> {
				Error::PreparedRunningBufferPlateModelError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "PreparedMarkerPlateModelError", "If PreparedMarkerPlate is an object, and the container is not a compatible plate, throw an error."},
			Lookup[
				ExperimentFragmentAnalysis[
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
					PreparedMarkerPlate->Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
					Output->Options
				],
				PreparedMarkerPlate
			],
			ObjectP[Object[Container,Plate]],
			Messages :> {
				Error::PreparedMarkerPlateModelError,
				Warning::AnalysisMethodLadderOptionsMismatch,
				Warning::AnalysisMethodSampleOptionsMismatch,
				Error::InvalidOption
				
			}
		],
		Example[{Additional, "Create a simulation protocol for given samples when Output->Simulation:"},
			ExperimentFragmentAnalysis[
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID],
				Output->Simulation
			],
			SimulationP
		],
		Example[{Additional, "Return a simulation even when returning early with failed options when Output->Simulation:"},
			ExperimentFragmentAnalysis[
				Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
				AnalysisMethod->Object[Method,FragmentAnalysis,"dsDNA (35 -5000 bp) - Standard Sensitivity (ng/uL) - Short"],
				PreparedMarkerPlate->Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests"<>$SessionUUID],
				LadderMarker->Object[Sample,"Test MarkerSample 3 for ExperimentFragmentAnalysis" <> $SessionUUID],
				Output->Simulation
			],
			SimulationP,
			Messages :> {
				Error::PreparedMarkerPlateError,
				Error::InvalidOption
			}
		]
		
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$AllowPublicObjects = True
	},
	SetUp:>(
		$CreatedObjects = {};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{
			objects,
			existsFilter,
			runningBufferObjectNames,
			runningBufferPlateObjects,
			markerObjectNames,
			markerPlateObjects,
			capillaryStorageSolutionObjectNames,
			capillaryStorageSolutionPlateObjects,
			preparedSamplePlateObjectNames,
			preparedSamplePlateObjects
		},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			preparedSamplePlateObjectNames=Map[
				"Test Sample " <> ToString[#] <> " for ExperimentFragmentAnalysis PreparedPlate" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			preparedSamplePlateObjects=Map[Object[Sample, #] &, preparedSamplePlateObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysis tests" <> $SessionUUID],

					(*CapillaryArray*)
					Model[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Model for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],

					(* Instrument *)
					Model[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Model for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysis" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysis Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Mixed" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Small RNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,
					preparedSamplePlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 12mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 500mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 4000mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 7 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 8 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Rack, "Test Local Cache for ExperimentFragmentAnalysis Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];

		(*Module for creating objects*)
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench,
					testCapillaryArrayObject,
					testLocalCache,
					testInstrumentObject,
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap,
					container1,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					runningBufferPlateObjects,
					runningBufferObjectNames,
					markerPlateObjects,
					markerObjectNames,
					separationGel,
					dye,
					ladder,
					marker,
					capillaryStorageSolutionObjectNames,
					capillaryStorageSolutionPlateObjects,
					capillaryStorageSolutionPlate,
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer,
					preparedSamplePlate,
					preparedSamplePlateObjectNames,
					preparedSamplePlateObjects
				},

				(*Upload Test Bench*)
				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentFragmentAnalysis tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(*Upload CapillaryArray*)
				testCapillaryArrayObject=Upload[
					<|
						Type->Object[Part,CapillaryArray],
						Model->Link[Model[Part, CapillaryArray, "id:bq9LA09PPdwb"],Objects],(*Model[Part, CapillaryArray, "96-Capillary Array Short"]*)
						Name->"Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID
					|>
				];
				
				testLocalCache=UploadSample[
					Model[Container, Rack, "id:dORYzZn0ooME"], (*Model[Container, Rack, "1-position Akro-Grid Tote"]*)
					{"Work Surface", testBench},
					Name->"Test Local Cache for ExperimentFragmentAnalysis Tests" <> $SessionUUID
				];

				(*Upload Instrument*)
				testInstrumentObject = Upload[
					<|
						Type -> Object[Instrument, FragmentAnalyzer],
						Model -> Link[Model[Instrument, FragmentAnalyzer, "id:6V0npv033KB1"], Objects],(*Model[Instrument, FragmentAnalyzer, "Agilent Fragment Analyzer 5300"]*)
						Name -> "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID,
						Site -> Link[$Site],
						MethodFilePath->"Instrument Methods\\FragmentAnalyzer\\",
						DataFilePath->"Data\\FragmentAnalyzer\\",
						InstrumentDataFilePath->"C:\\Agilent Technologies\\Data",
						Software->"FragmentAnalyzer",
						CapillaryArray->Link[testCapillaryArrayObject,Instrument],
						Replace[LocalCache]->Link[testLocalCache]
					|>
				];

				(*Upload ConditioningLinePlaceholderContainer,PrimaryGelLinePlaceholderContainer,SecondaryGelLinePlaceholderContainer,WasteContainer,*)
				{
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(*Model[Container, Vessel, "50mL Tube"]*)
						Model[Container, Vessel, "id:xRO9n3OqONnw"](*Model[Container, Vessel, "500mL Nalgene Bottle For ExperimentFragmentAnalysis"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->InUse,
					Name->{
						"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test WasteContainer for ExperimentFragmentAnalysis" <> $SessionUUID
					}
				];

				(*Upload Cap for Lines*)
				{
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				}=UploadSample[
					{
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:E8zoYvzZmK87"](*Model[Item, Cap, "50mL Blue Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:eGakldaqLzMx"](*]Model[Item, Cap, "500mL Waste Bottle Replacement Cap for FragmentAnalyzer Lines"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->Available,
					Name->{
						"Test Conditioning Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test Primary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test Secondary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID,
						"Test Waste Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID
					}
				];

				Upload[<|
					Object -> #,
					Reusable -> True,
					Restricted->True
				|>] & /@ {
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				};

				(*Upload Instrument Caps to Instrument Containers*)
				UploadCover[
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID]
         		];
				UploadCover[
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID]
				];

				(*Update fields in Test Instrument Object*)
				Upload[<|
					Object->testInstrumentObject,
					ConditioningLineCap->Link[conditioningLineCap],
					PrimaryGelLineCap->Link[primaryGelLineCap],
					SecondaryGelLineCap->Link[secondaryGelLineCap],
					WasteLineCap->Link[wasteLineCap],
					ConditioningLinePlaceholderContainer->Link[conditioningLinePlaceholderContainer],
					PrimaryGelLinePlaceholderContainer->Link[primaryGelLinePlaceholderContainer],
					SecondaryGelLinePlaceholderContainer->Link[secondaryGelLinePlaceholderContainer],
					WasteContainer->Link[wasteContainer]
				|>];

				(* Upload Test Containers*)
				{
					container1,
					container2,
					container3,
					container4,
					container5,
					container6,
					container7,
					container8,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					capillaryStorageSolutionPlate,
					preparedSamplePlate
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "100ul small narrow clear plastic tube"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "id:Vrbp1jb6R1dx"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"],
						Model[Container, Vessel, "50mL Centrifuge Tube (VWR)"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 2 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 3 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 4 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 5 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 6 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 7 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container 8 for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"RunningBufferPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"MarkerPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container for SeparationGel for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container for Dye for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container for Ladder for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"Container for Marker for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID,
						"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID
					}
				];

				(*Model Oligomers*)
				Quiet[Upload[
					{
						(*RNA Models*)
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "U", "G", "C"}, 3]]]],
							PolymerType-> RNA,
							Name-> "ExperimentFragmentAnalysis 12mer RNA Model Molecule" <> $SessionUUID,
							MolecularWeight->3795.35*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "U", "G", "C"}, 25]]]],
							PolymerType-> RNA,
							Name-> "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID,
							MolecularWeight->32082.3*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "U", "G", "C"}, 125]]]],
							PolymerType-> RNA,
							Name-> "ExperimentFragmentAnalysis 500mer RNA Model Molecule" <> $SessionUUID,
							MolecularWeight->160659.*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "U", "G", "C"}, 1000]]]],
							PolymerType-> RNA,
							Name-> "ExperimentFragmentAnalysis 4000mer RNA Model Molecule" <> $SessionUUID,
							MolecularWeight->1.28571*10^6*(Gram/Mole),
							DeveloperObject->True
						|>,
						(*DNA Models*)
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 20]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysis 80mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->24653.8*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 100]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->123517.*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 500]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->617833.*(Gram/Mole),
							DeveloperObject->True
						|>
					}
				]];

				(*Test Samples*)
				{
					sample1,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					separationGel,
					dye,
					ladder,
					marker
				}=UploadSample[
					{
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{50 Picogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID]},
							{0.25 Micromolar, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 12mer RNA Model Molecule" <> $SessionUUID]}
						},
						{
							{300 Picomolar,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 500mer RNA Model Molecule" <> $SessionUUID]},
							{100 Picogram/Microliter,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 4000mer RNA Model Molecule" <> $SessionUUID]}
						},
						{
							{2 Nanogram/Microliter,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID]},
							{Null,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{2 Nanogram/Microliter,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID]},
							{Null,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{2 Nanogram/Microliter,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID]},
							{0.25 Micromolar,Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 12mer RNA Model Molecule" <> $SessionUUID]}
						},
						{
							{Null,Null}
						},
						{
							{1 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID]},
							{2 Nanogram/ Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID]}
						},
						Model[Sample, "id:N80DNj0Dr9nk"],(*Model[Sample, "Separation Gel for ExperimentFragmentAnalysis DNA (35 - 1500 bp), DNA (35 - 5000 bp) and CRISPR"],*)
						Model[Sample, "id:P5ZnEjZnV0Rn"],(*Model[Sample, "Intercalating Dye for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:GmzlKjzlk67M"],(*Model[Sample, "100-3000 bp DNA Ladder for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:54n6evn6E14q"](*Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]*)
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
						{"A1",separationGelContainer},
						{"A1",dyeContainer},
						{"A1",ladderContainer},
						{"A1",markerContainer}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> {
						300 Microliter,
						300 Microliter,
						300 Microliter,
						300 Microliter,
						300 Microliter,
						300 Microliter,
						300 Microliter,
						300 Microliter,
						45 Milliliter,
						100 Microliter,
						100 Microliter,
						3.2 Milliliter
					},
					Name-> {
						"ExperimentFragmentAnalysis Test Sample Discarded" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis RNA Low Concentration" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Mixed" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Small RNA" <> $SessionUUID,
						"Test SeparationGel for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Dye for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Ladder for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Marker for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID
					}
				];

				(*PreparedPlate for Samples*)
				preparedSamplePlateObjectNames=Map[
					"Test Sample " <> ToString[#] <> " for ExperimentFragmentAnalysis PreparedPlate" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				preparedSamplePlateObjects=UploadSample[
					ConstantArray[
						{
							{
								2 Nanogram/Microliter,
								Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID]},
							{
								2 Nanogram/Microliter,
								Model[Molecule,Oligomer,"ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID]}
						},
						96
					],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedSamplePlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[24 Microliter,96],
					Name->preparedSamplePlateObjectNames
				];

				(*PreparedRunningBufferPlate*)
				runningBufferObjectNames=Map[
					"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				runningBufferPlateObjects=UploadSample[
					Table[Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedRunningBufferPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->runningBufferObjectNames
				];

				(*PreparedMarkerPlate*)
				markerObjectNames=Map[
					"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				markerPlateObjects=UploadSample[
					Table[Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedMarkerPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->markerObjectNames
				];

				(*CapillaryStorageSolutionPlate*)
				capillaryStorageSolutionObjectNames=Map[
					"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				capillaryStorageSolutionPlateObjects=UploadSample[
					Table[Model[Sample, "Capillary Storage Solution for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[capillaryStorageSolutionPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[200 Microliter,96],
					Name->capillaryStorageSolutionObjectNames
				];

				(*Update to *)
				Upload[<|
					Object -> #,
					DeveloperObject -> True,
					AwaitingStorageUpdate -> Null
				|> & /@ Cases[Flatten[
					{
						container1,
						container2,
						container3,
						container4,
						container5,
						container6,
						container7,
						container8,
						sample1,
						sample2,
						sample3,
						sample4,
						sample5,
						sample6,
						sample7,
						sample8,
						runningBufferPlateObjects,
						markerPlateObjects,
						capillaryStorageSolutionPlateObjects,
						separationGelContainer,
						dyeContainer,
						ladderContainer,
						markerContainer,
						separationGel,
						dye,
						ladder,
						marker,
						preparedSamplePlate,
						preparedSamplePlateObjects
					}
				], ObjectP[]]];

				Upload[<|Object->sample1,Status->Discarded|>];

				Upload[<|
					Object->#,
					DeveloperObject->False
				|>]&/@{testInstrumentObject,testCapillaryArrayObject}

			]
		]
	),

	SymbolTearDown :> (
		(*Module for deleting objects created in SymbolSetUp*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysis" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysis tests" <> $SessionUUID],

					(*CapillaryArray*)
					Model[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Model for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],

					(* Instrument *)
					Model[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Model for ExperimentFragmentAnalysis Tests" <> $SessionUUID],
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysis Tests" <> $SessionUUID],

					(*Item Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysis" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysis" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysis" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysis Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType RNA" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType DNA for Aliquot" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Mixed" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Null" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis RNA Low Concentration" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysis SampleAnalyteType Small RNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysis DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 12mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 100mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 500mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 4000mer RNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 400mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysis 2000mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 3 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 4 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 5 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 6 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 7 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 8 for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container,Plate,"PreparedSamplePlate for ExperimentFragmentAnalysis tests" <> $SessionUUID],
					Object[Container, Rack, "Test Local Cache for ExperimentFragmentAnalysis Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
];

(* ::Subsection::Closed:: *)
(*ExperimentFragmentAnalysisOptions*)


DefineTests[
	ExperimentFragmentAnalysisOptions,
	{
		Example[{Basic,"Display the option values which will be used in the FragmentAnalysis experiment:"},
			ExperimentFragmentAnalysisOptions[
				Object[Sample,
					"Test Sample for ExperimentFragmentAnalysisOptions SampleAnalyteType DNA" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentFragmentAnalysisOptions[Object[Sample,"ExperimentFragmentAnalysisOptions Test Sample Discarded" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentFragmentAnalysisOptions[Object[Sample,"Test Sample for ExperimentFragmentAnalysisOptions SampleAnalyteType DNA" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysisOptions Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysisOptions SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Rack, "Test Local Cache for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];

		(*Module for creating objects*)
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench,
					testCapillaryArrayObject,
					testLocalCache,
					testInstrumentObject,
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap,
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					sample1,
					sample2,
					runningBufferPlateObjects,
					runningBufferObjectNames,
					markerPlateObjects,
					markerObjectNames,
					separationGel,
					dye,
					ladder,
					marker,
					capillaryStorageSolutionObjectNames,
					capillaryStorageSolutionPlateObjects,
					capillaryStorageSolutionPlate,
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				},

				(*Upload Test Bench*)
				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(*Upload CapillaryArray*)
				testCapillaryArrayObject=Upload[
					<|
						Type->Object[Part,CapillaryArray],
						Model->Link[Model[Part, CapillaryArray, "id:bq9LA09PPdwb"],Objects],(*Model[Part, CapillaryArray, "96-Capillary Array Short"]*)
						Name->"Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID
					|>
				];
				
				testLocalCache=UploadSample[
					Model[Container, Rack, "id:dORYzZn0ooME"], (*Model[Container, Rack, "1-position Akro-Grid Tote"]*)
					{"Work Surface", testBench},
					Name->"Test Local Cache for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID
				];

				(*Upload Instrument*)
				testInstrumentObject = Upload[
					<|
						Type -> Object[Instrument, FragmentAnalyzer],
						Model -> Link[Model[Instrument, FragmentAnalyzer, "id:6V0npv033KB1"], Objects],(*Model[Instrument, FragmentAnalyzer, "Agilent Fragment Analyzer 5300"]*)
						Name -> "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID,
						Site -> Link[$Site],
						MethodFilePath->"Instrument Methods\\FragmentAnalyzer\\",
						DataFilePath->"Data\\FragmentAnalyzer\\",
						InstrumentDataFilePath->"C:\\Agilent Technologies\\Data",
						Software->"FragmentAnalyzer",
						CapillaryArray->Link[testCapillaryArrayObject,Instrument],
						Replace[LocalCache]->Link[testLocalCache]
					|>
				];

				(*Upload ConditioningLinePlaceholderContainer,PrimaryGelLinePlaceholderContainer,SecondaryGelLinePlaceholderContainer,WasteContainer,*)
				{
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(*Model[Container, Vessel, "50mL Tube"]*)
						Model[Container, Vessel, "id:xRO9n3OqONnw"](*Model[Container, Vessel, "500mL Nalgene Bottle For ExperimentFragmentAnalysis"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->InUse,
					Name->{
						"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test WasteContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID
					}
				];

				(*Upload Cap for Lines*)
				{
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				}=UploadSample[
					{
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:E8zoYvzZmK87"](*Model[Item, Cap, "50mL Blue Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:eGakldaqLzMx"](*Model[Item, Cap, "500mL Waste Bottle Replacement Cap for FragmentAnalyzer Lines"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->Available,
					Name->{
						"Test Conditioning Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test Primary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID,
						"Test Waste Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID
					}
				];

				Upload[<|
					Object -> #,
					Reusable -> True,
					Restricted->True
				|>] & /@ {
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				};

				(*Upload Instrument Caps to Instrument Containers*)
				UploadCover[
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID]
				];

				(*Update fields in Test Instrument Object*)
				Upload[<|
					Object->testInstrumentObject,
					ConditioningLineCap->Link[conditioningLineCap],
					PrimaryGelLineCap->Link[primaryGelLineCap],
					SecondaryGelLineCap->Link[secondaryGelLineCap],
					WasteLineCap->Link[wasteLineCap],
					ConditioningLinePlaceholderContainer->Link[conditioningLinePlaceholderContainer],
					PrimaryGelLinePlaceholderContainer->Link[primaryGelLinePlaceholderContainer],
					SecondaryGelLinePlaceholderContainer->Link[secondaryGelLinePlaceholderContainer],
					WasteContainer->Link[wasteContainer]
				|>];

				(* Upload Test Containers*)
				{
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					capillaryStorageSolutionPlate
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container,Plate,"96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"],
						Model[Container, Vessel, "50mL Centrifuge Tube (VWR)"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"Container 2 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"RunningBufferPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"MarkerPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"Container for SeparationGel for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"Container for Dye for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"Container for Ladder for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"Container for Marker for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID,
						"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID
					}
				];

				(*Model Oligomers*)
				Quiet[Upload[
					{
						(*DNA Models*)
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 20]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysisOptions 80mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->24653.8*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 100]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysisOptions 400mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->123517.*(Gram/Mole),
							DeveloperObject->True
						|>
					}
				]];

				(*Test Samples*)
				{
					sample1,
					sample2,
					separationGel,
					dye,
					ladder,
					marker
				}=UploadSample[
					{
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						Model[Sample, "id:N80DNj0Dr9nk"],(*Model[Sample, "Separation Gel for ExperimentFragmentAnalysis DNA (35 - 1500 bp), DNA (35 - 5000 bp) and CRISPR"]*)
						Model[Sample, "id:P5ZnEjZnV0Rn"],(*Model[Sample, "Intercalating Dye for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:GmzlKjzlk67M"],(*Model[Sample, "100-3000 bp DNA Ladder for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:54n6evn6E14q"](*Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]*)
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",separationGelContainer},
						{"A1",dyeContainer},
						{"A1",ladderContainer},
						{"A1",markerContainer}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> {
						100 Microliter,
						100 Microliter,
						45 Milliliter,
						100 Microliter,
						100 Microliter,
						3.2 Milliliter
					},
					Name-> {
						"ExperimentFragmentAnalysisOptions Test Sample Discarded" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysisOptions SampleAnalyteType DNA" <> $SessionUUID,
						"Test SeparationGel for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Dye for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Ladder for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Marker for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID
					}
				];

				(*PreparedRunningBufferPlate*)
				runningBufferObjectNames=Map[
					"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				runningBufferPlateObjects=UploadSample[
					Table[Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedRunningBufferPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->runningBufferObjectNames
				];

				(*PreparedMarkerPlate*)
				markerObjectNames=Map[
					"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				markerPlateObjects=UploadSample[
					Table[Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedMarkerPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->markerObjectNames
				];

				(*CapillaryStorageSolutionPlate*)
				capillaryStorageSolutionObjectNames=Map[
					"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				capillaryStorageSolutionPlateObjects=UploadSample[
					Table[Model[Sample, "Capillary Storage Solution for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[capillaryStorageSolutionPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[200 Microliter,96],
					Name->capillaryStorageSolutionObjectNames
				];

				(*Update to *)
				Upload[<|
					Object -> #,
					DeveloperObject -> True,
					AwaitingStorageUpdate -> Null
				|> & /@ Cases[Flatten[{
					container1,
					container2,
					sample1,
					sample2,
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					separationGel,
					dye,
					ladder,
					marker}
				], ObjectP[]]];

				Upload[<|Object->sample1,Status->Discarded|>];

				Upload[<|
					Object->#,
					DeveloperObject->False
				|>]&/@{testInstrumentObject,testCapillaryArrayObject}

			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisOptions" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisOptions" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisOptions" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysisOptions Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysisOptions SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysisOptions DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisOptions 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysisOptions tests" <> $SessionUUID],
					Object[Container,Rack, "Test Local Cache for ExperimentFragmentAnalysisOptions Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)
];

(* ::Subsection:: *)
(*ValidExperimentFragmentAnalysisQ*)

DefineTests[ValidExperimentFragmentAnalysisQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of a FragmentAnalysis experiment:"},
			ValidExperimentFragmentAnalysisQ[Object[Sample, "Test Sample for ValidExperimentFragmentAnalysisQ SampleAnalyteType DNA" <> $SessionUUID]],
			True,
			Stubs:>{
			}
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFragmentAnalysisQ[Object[Sample, "ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID]],
			False
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentFragmentAnalysisQ[Object[Sample, "ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID],
				Verbose->True
			],
			False
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentFragmentAnalysisQ[Object[Sample, "ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={};
		ClearMemoization[];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ValidExperimentFragmentAnalysisQ SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Rack,"Test Local Cache for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];

		(*Module for creating objects*)
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench,
					testCapillaryArrayObject,
					testLocalCache,
					testInstrumentObject,
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap,
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					sample1,
					sample2,
					runningBufferPlateObjects,
					runningBufferObjectNames,
					markerPlateObjects,
					markerObjectNames,
					separationGel,
					dye,
					ladder,
					marker,
					capillaryStorageSolutionObjectNames,
					capillaryStorageSolutionPlateObjects,
					capillaryStorageSolutionPlate,
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				},

				(*Upload Test Bench*)
				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(*Upload CapillaryArray*)
				testCapillaryArrayObject=Upload[
					<|
						Type->Object[Part,CapillaryArray],
						Model->Link[Model[Part, CapillaryArray, "id:bq9LA09PPdwb"],Objects],(*Model[Part, CapillaryArray, "96-Capillary Array Short"]*)
						Name->"Test FragmentAnalyzer CapillaryArray Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID
					|>
				];
				
				testLocalCache=UploadSample[
					Model[Container, Rack, "id:dORYzZn0ooME"], (*Model[Container, Rack, "1-position Akro-Grid Tote"]*)
					{"Work Surface", testBench},
					Name->"Test Local Cache for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID
				];

				(*Upload Instrument*)
				testInstrumentObject = Upload[
					<|
						Type -> Object[Instrument, FragmentAnalyzer],
						Model -> Link[Model[Instrument, FragmentAnalyzer, "id:6V0npv033KB1"], Objects],(*Model[Instrument, FragmentAnalyzer, "Agilent Fragment Analyzer 5300"]*)
						Name -> "Test FragmentAnalyzer Instrument Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID,
						Site -> Link[$Site],
						MethodFilePath->"Instrument Methods\\FragmentAnalyzer\\",
						DataFilePath->"Data\\FragmentAnalyzer\\",
						InstrumentDataFilePath->"C:\\Agilent Technologies\\Data",
						Software->"FragmentAnalyzer",
						CapillaryArray->Link[testCapillaryArrayObject,Instrument],
						Replace[LocalCache]->Link[testLocalCache]
					|>
				];

				(*Upload ConditioningLinePlaceholderContainer,PrimaryGelLinePlaceholderContainer,SecondaryGelLinePlaceholderContainer,WasteContainer,*)
				{
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(*Model[Container, Vessel, "50mL Tube"]*)
						Model[Container, Vessel, "id:xRO9n3OqONnw"](*Model[Container, Vessel, "500mL Nalgene Bottle For ExperimentFragmentAnalysis"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->InUse,
					Name->{
						"Test ConditioningLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test PrimaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test SecondaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test WasteContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID
					}
				];

				(*Upload Cap for Lines*)
				{
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				}=UploadSample[
					{
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:E8zoYvzZmK87"](*Model[Item, Cap, "50mL Blue Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:eGakldaqLzMx"](*Model[Item, Cap, "500mL Waste Bottle Replacement Cap for FragmentAnalyzer Lines"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->Available,
					Name->{
						"Test Conditioning Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test Primary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test Secondary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID,
						"Test Waste Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID
					}
				];

				Upload[<|
					Object -> #,
					Reusable -> True,
					Restricted->True
				|>] & /@ {
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				};

				(*Upload Instrument Caps to Instrument Containers*)
				UploadCover[
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Conditioning Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Primary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Secondary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test WasteContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Waste Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID]
				];

				(*Update fields in Test Instrument Object*)
				Upload[<|
					Object->testInstrumentObject,
					ConditioningLineCap->Link[conditioningLineCap],
					PrimaryGelLineCap->Link[primaryGelLineCap],
					SecondaryGelLineCap->Link[secondaryGelLineCap],
					WasteLineCap->Link[wasteLineCap],
					ConditioningLinePlaceholderContainer->Link[conditioningLinePlaceholderContainer],
					PrimaryGelLinePlaceholderContainer->Link[primaryGelLinePlaceholderContainer],
					SecondaryGelLinePlaceholderContainer->Link[secondaryGelLinePlaceholderContainer],
					WasteContainer->Link[wasteContainer]
				|>];

				(* Upload Test Containers*)
				{
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					capillaryStorageSolutionPlate
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container,Plate,"96-well 2mL Deep Well Plate"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"],
						Model[Container, Vessel, "50mL Centrifuge Tube (VWR)"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"Container 2 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"RunningBufferPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"MarkerPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"Container for SeparationGel for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"Container for Dye for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"Container for Ladder for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"Container for Marker for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID,
						"CapillaryStorageSolutionPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID
					}
				];

				(*Model Oligomers*)
				Quiet[Upload[
					{
						(*DNA Models*)
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 20]]]],
							PolymerType-> DNA,
							Name-> "ValidExperimentFragmentAnalysisQ 80mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->24653.8*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 100]]]],
							PolymerType-> DNA,
							Name-> "ValidExperimentFragmentAnalysisQ 400mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->123517.*(Gram/Mole),
							DeveloperObject->True
						|>
					}
				]];

				(*Test Samples*)
				{
					sample1,
					sample2,
					separationGel,
					dye,
					ladder,
					marker
				}=UploadSample[
					{
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						Model[Sample, "id:N80DNj0Dr9nk"],(*Model[Sample, "Separation Gel for ExperimentFragmentAnalysis DNA (35 - 1500 bp), DNA (35 - 5000 bp) and CRISPR"]*)
						Model[Sample, "id:P5ZnEjZnV0Rn"],(*Model[Sample, "Intercalating Dye for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:GmzlKjzlk67M"],(*Model[Sample, "100-3000 bp DNA Ladder for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:54n6evn6E14q"](*Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]*)
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",separationGelContainer},
						{"A1",dyeContainer},
						{"A1",ladderContainer},
						{"A1",markerContainer}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> {
						100 Microliter,
						100 Microliter,
						45 Milliliter,
						100 Microliter,
						100 Microliter,
						3.2 Milliliter
					},
					Name-> {
						"ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID,
						"Test Sample for ValidExperimentFragmentAnalysisQ SampleAnalyteType DNA" <> $SessionUUID,
						"Test SeparationGel for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Dye for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Ladder for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Marker for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID
					}
				];

				(*PreparedRunningBufferPlate*)
				runningBufferObjectNames=Map[
					"Test RunningBufferSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				runningBufferPlateObjects=UploadSample[
					Table[Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedRunningBufferPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->runningBufferObjectNames
				];

				(*PreparedMarkerPlate*)
				markerObjectNames=Map[
					"Test MarkerSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				markerPlateObjects=UploadSample[
					Table[Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedMarkerPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->markerObjectNames
				];

				(*CapillaryStorageSolutionPlate*)
				capillaryStorageSolutionObjectNames=Map[
					"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				capillaryStorageSolutionPlateObjects=UploadSample[
					Table[Model[Sample, "Capillary Storage Solution for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[capillaryStorageSolutionPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[200 Microliter,96],
					Name->capillaryStorageSolutionObjectNames
				];

				(*Update to *)
				Upload[<|
					Object -> #,
					DeveloperObject -> True,
					AwaitingStorageUpdate -> Null
				|> & /@ Cases[Flatten[{
					container1,
					container2,
					sample1,
					sample2,
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					separationGel,
					dye,
					ladder,
					marker}
				], ObjectP[]]];

				Upload[<|Object->sample1,Status->Discarded|>];

				Upload[<|
					Object->#,
					DeveloperObject->False
				|>]&/@{testInstrumentObject,testCapillaryArrayObject}

			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ValidExperimentFragmentAnalysisQ" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ValidExperimentFragmentAnalysisQ" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ValidExperimentFragmentAnalysisQ Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ValidExperimentFragmentAnalysisQ SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ValidExperimentFragmentAnalysisQ DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ValidExperimentFragmentAnalysisQ 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ValidExperimentFragmentAnalysisQ tests" <> $SessionUUID],
					Object[Container,Rack,"Test Local Cache for ValidExperimentFragmentAnalysisQ Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)

];

(* ::Subsection::Closed:: *)
(*ExperimentFragmentAnalysisPreview*)

DefineTests[
	ExperimentFragmentAnalysisPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFragmentAnalysis:"},
			ExperimentFragmentAnalysisPreview[Object[Sample, "Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentFragmentAnalysisOptions:"},
			ExperimentFragmentAnalysisOptions[Object[Sample, "Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentFragmentAnalysisQ:"},
			ValidExperimentFragmentAnalysisQ[Object[Sample, "Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID]],
			True
		]
	},
	Stubs:>{ (* Set global Variables *)
		$EmailEnabled=False,
		$AllowSystemsProtocols=True
	},
	SetUp:>( (* before and after EVERY test *)
		$CreatedObjects={}
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (

		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::AliquotRequired];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysisPreview Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Rack,"Test Local Cache for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];

		(*Module for creating objects*)
		Block[{$DeveloperUpload = True, $AllowPublicObjects = True},
			Module[
				{
					testBench,
					testCapillaryArrayObject,
					testLocalCache,
					testInstrumentObject,
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap,
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					sample1,
					sample2,
					runningBufferPlateObjects,
					runningBufferObjectNames,
					markerPlateObjects,
					markerObjectNames,
					separationGel,
					dye,
					ladder,
					marker,
					capillaryStorageSolutionObjectNames,
					capillaryStorageSolutionPlateObjects,
					capillaryStorageSolutionPlate,
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				},

				(*Upload Test Bench*)
				testBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Bench for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID, DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>];

				(*Upload CapillaryArray*)
				testCapillaryArrayObject=Upload[
					<|
						Type->Object[Part,CapillaryArray],
						Model->Link[Model[Part, CapillaryArray, "id:bq9LA09PPdwb"],Objects],(*Model[Part, CapillaryArray, "96-Capillary Array Short"]*)
						Name->"Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID
					|>
				];
				
				testLocalCache=UploadSample[
					Model[Container, Rack, "id:dORYzZn0ooME"], (*Model[Container, Rack, "1-position Akro-Grid Tote"]*)
					{"Work Surface", testBench},
					Name->"Test Local Cache for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID
				];

				(*Upload Instrument*)
				testInstrumentObject = Upload[
					<|
						Type -> Object[Instrument, FragmentAnalyzer],
						Model -> Link[Model[Instrument, FragmentAnalyzer, "id:6V0npv033KB1"], Objects],(*Model[Instrument, FragmentAnalyzer, "Agilent Fragment Analyzer 5300"]*)
						Name -> "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID,
						Site -> Link[$Site],
						MethodFilePath->"Instrument Methods\\FragmentAnalyzer\\",
						DataFilePath->"Data\\FragmentAnalyzer\\",
						InstrumentDataFilePath->"C:\\Agilent Technologies\\Data",
						Software->"FragmentAnalyzer",
						CapillaryArray->Link[testCapillaryArrayObject,Instrument],
						Replace[LocalCache]->Link[testLocalCache]
					|>
				];

				(*Upload ConditioningLinePlaceholderContainer,PrimaryGelLinePlaceholderContainer,SecondaryGelLinePlaceholderContainer,WasteContainer,*)
				{
					conditioningLinePlaceholderContainer,
					primaryGelLinePlaceholderContainer,
					secondaryGelLinePlaceholderContainer,
					wasteContainer
				}=UploadSample[
					{
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:dORYzZRqJrzR"],(*Model[Container, Vessel, "250mL Centrifuge Tube For ExperimentFragmentAnalysis"]*)
						Model[Container, Vessel, "id:bq9LA0dBGGR6"],(*Model[Container, Vessel, "50mL Tube"]*)
						Model[Container, Vessel, "id:xRO9n3OqONnw"](*Model[Container, Vessel, "500mL Nalgene Bottle For ExperimentFragmentAnalysis"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->InUse,
					Name->{
						"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test WasteContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID
					}
				];

				(*Upload Cap for Lines*)
				{
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				}=UploadSample[
					{
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:lYq9jRqla6r4"](*Model[Item, Cap, "250mL Orange Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:E8zoYvzZmK87"](*Model[Item, Cap, "50mL Blue Tube Replacement Cap for FragmentAnalyzer Lines"]*),
						Model[Item, Cap, "id:eGakldaqLzMx"](*Model[Item, Cap, "500mL Waste Bottle Replacement Cap for FragmentAnalyzer Lines"]*)
					},
					{
						{"Conditioning Solution Slot",testInstrumentObject},
						{"Separation Gel 1 Slot",testInstrumentObject},
						{"Separation Gel 2 Slot",testInstrumentObject},
						{"Waste Container Slot",testInstrumentObject}
					},
					Status->Available,
					Name->{
						"Test Conditioning Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test Primary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID,
						"Test Waste Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID
					}
				];

				Upload[<|
					Object -> #,
					Reusable -> True,
					Restricted->True
				|>] & /@ {
					conditioningLineCap,
					primaryGelLineCap,
					secondaryGelLineCap,
					wasteLineCap
				};

				(*Upload Instrument Caps to Instrument Containers*)
				UploadCover[
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID]
				];
				UploadCover[
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Cover->Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID]
				];

				(*Update fields in Test Instrument Object*)
				Upload[<|
					Object->testInstrumentObject,
					ConditioningLineCap->Link[conditioningLineCap],
					PrimaryGelLineCap->Link[primaryGelLineCap],
					SecondaryGelLineCap->Link[secondaryGelLineCap],
					WasteLineCap->Link[wasteLineCap],
					ConditioningLinePlaceholderContainer->Link[conditioningLinePlaceholderContainer],
					PrimaryGelLinePlaceholderContainer->Link[primaryGelLinePlaceholderContainer],
					SecondaryGelLinePlaceholderContainer->Link[secondaryGelLinePlaceholderContainer],
					WasteContainer->Link[wasteContainer]
				|>];

				(* Upload Test Containers*)
				{
					container1,
					container2,
					preparedRunningBufferPlate,
					preparedMarkerPlate,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					capillaryStorageSolutionPlate
				}=UploadSample[
					{
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Plate, "id:Vrbp1jb6R1dx"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"],
						Model[Container, Vessel, "50mL Centrifuge Tube (VWR)"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "id:vXl9j5lLdjW5"]
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Status -> Available,
					Name->{
						"Container 1 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"Container 2 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"RunningBufferPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"MarkerPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"Container for SeparationGel for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"Container for Dye for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"Container for Ladder for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"Container for Marker for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID,
						"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID
					}
				];

				(*Model Oligomers*)
				Quiet[Upload[
					{
						(*DNA Models*)
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 20]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysisPreview 80mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->24653.8*(Gram/Mole),
							DeveloperObject->True
						|>,
						<|
							Type->Model[Molecule,Oligomer],
							Molecule->ToStructure[StringJoin[Flatten[ConstantArray[{"A", "T", "G", "C"}, 100]]]],
							PolymerType-> DNA,
							Name-> "ExperimentFragmentAnalysisPreview 400mer DNA Model Molecule" <> $SessionUUID,
							MolecularWeight->123517.*(Gram/Mole),
							DeveloperObject->True
						|>
					}
				]];

				(*Test Samples*)
				{
					sample1,
					sample2,
					separationGel,
					dye,
					ladder,
					marker
				}=UploadSample[
					{
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						{
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 80mer DNA Model Molecule" <> $SessionUUID]},
							{100 Nanogram / Microliter, Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 400mer DNA Model Molecule" <> $SessionUUID]}
						},
						Model[Sample, "id:N80DNj0Dr9nk"],(*Model[Sample, "Separation Gel for ExperimentFragmentAnalysis DNA (35 - 1500 bp), DNA (35 - 5000 bp) and CRISPR"]*)
						Model[Sample, "id:P5ZnEjZnV0Rn"],(*Model[Sample, "Intercalating Dye for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:GmzlKjzlk67M"],(*Model[Sample, "100-3000 bp DNA Ladder for ExperimentFragmentAnalysis"]*)
						Model[Sample, "id:54n6evn6E14q"](*Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"]*)
					},
					{
						{"A1",container1},
						{"A1",container2},
						{"A1",separationGelContainer},
						{"A1",dyeContainer},
						{"A1",ladderContainer},
						{"A1",markerContainer}
					},
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> {
						100 Microliter,
						100 Microliter,
						45 Milliliter,
						100 Microliter,
						100 Microliter,
						3.2 Milliliter
					},
					Name-> {
						"ExperimentFragmentAnalysisPreview Test Sample Discarded" <> $SessionUUID,
						"Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID,
						"Test SeparationGel for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Dye for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Ladder for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID,
						"Test Marker for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID
					}
				];

				(*PreparedRunningBufferPlate*)
				runningBufferObjectNames=Map[
					"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				runningBufferPlateObjects=UploadSample[
					Table[Model[Sample, StockSolution, "1x Running Buffer for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedRunningBufferPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->runningBufferObjectNames
				];

				(*PreparedMarkerPlate*)
				markerObjectNames=Map[
					"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				markerPlateObjects=UploadSample[
					Table[Model[Sample, "35 bp and 5000 bp Markers for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[preparedMarkerPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[1 Milliliter,96],
					Name->markerObjectNames
				];

				(*CapillaryStorageSolutionPlate*)
				capillaryStorageSolutionObjectNames=Map[
					"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
					Table[i + 1, {i, 0, 95}]
				];
				capillaryStorageSolutionPlateObjects=UploadSample[
					Table[Model[Sample, "Capillary Storage Solution for ExperimentFragmentAnalysis"],96],
					Transpose[{Flatten[AllWells["A1", "H12"]], ConstantArray[capillaryStorageSolutionPlate, 96]}],
					StorageCondition->Model[StorageCondition, "id:7X104vnR18vX"],
					State->Liquid,
					Status->Available,
					InitialAmount-> Table[200 Microliter,96],
					Name->capillaryStorageSolutionObjectNames
				];

				(*Update to *)
				Upload[<|
					Object -> #,
					DeveloperObject -> True,
					AwaitingStorageUpdate -> Null
				|> & /@ Cases[Flatten[{
					container1,
					container2,
					sample1,
					sample2,
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,
					separationGelContainer,
					dyeContainer,
					ladderContainer,
					markerContainer,
					separationGel,
					dye,
					ladder,
					marker}
				], ObjectP[]]];

				Upload[<|Object->sample1,Status->Discarded|>];

				Upload[<|
					Object->#,
					DeveloperObject->False
				|>]&/@{testInstrumentObject,testCapillaryArrayObject}

			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::AliquotRequired];
		ClearMemoization[];

		(*Module for deleting objects that we failed to erase in the last unit test*)
		Module[{objects, existsFilter, runningBufferObjectNames, runningBufferPlateObjects, markerObjectNames, markerPlateObjects,capillaryStorageSolutionObjectNames,capillaryStorageSolutionPlateObjects},

			runningBufferObjectNames = Map[
				"Test RunningBufferSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			runningBufferPlateObjects=Map[Object[Sample, #] &, runningBufferObjectNames];

			markerObjectNames = Map[
				"Test MarkerSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			markerPlateObjects=Map[Object[Sample, #] &, markerObjectNames];

			capillaryStorageSolutionObjectNames = Map[
				"Test CapillaryStorageSolutionSample " <> ToString[#] <> " for ExperimentFragmentAnalysisPreview" <> $SessionUUID &,
				Table[i + 1, {i, 0, 95}]
			];

			capillaryStorageSolutionPlateObjects=Map[Object[Sample, #] &, capillaryStorageSolutionObjectNames];

			(* List of Test Objects*)
			objects=Quiet[Cases[Flatten[
				{
					(*Test Bench*)
					Object[Container, Bench, "Bench for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],

					(*CapillaryArray*)
					Object[Part, CapillaryArray, "Test FragmentAnalyzer CapillaryArray Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID],

					(* Instrument *)
					Object[Instrument, FragmentAnalyzer, "Test FragmentAnalyzer Instrument Object for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID],

					(*Instrument Caps*)
					Object[Item,Cap,"Test Conditioning Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Primary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Secondary Gel Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Item,Cap,"Test Waste Line Cap for ExperimentFragmentAnalysisPreview" <> $SessionUUID],

					(*Instrument Containers*)
					Object[Container,Vessel,"Test ConditioningLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test PrimaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test SecondaryGelLinePlaceholderContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],
					Object[Container,Vessel,"Test WasteContainer for ExperimentFragmentAnalysisPreview" <> $SessionUUID],

					(*Object Samples*)
					Object[Sample, "ExperimentFragmentAnalysisPreview Test Sample Discarded" <> $SessionUUID],
					Object[Sample, "Test Sample for ExperimentFragmentAnalysisPreview SampleAnalyteType DNA" <> $SessionUUID],
					Object[Sample,"Test SeparationGel for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Dye for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Ladder for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					Object[Sample,"Test Marker for ExperimentFragmentAnalysisPreview DNA (35 - 1500 bp)" <> $SessionUUID],
					runningBufferPlateObjects,
					markerPlateObjects,
					capillaryStorageSolutionPlateObjects,

					(*Model Molecules*)
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 80mer DNA Model Molecule" <> $SessionUUID],
					Model[Molecule, Oligomer, "ExperimentFragmentAnalysisPreview 400mer DNA Model Molecule" <> $SessionUUID],

					(*Containers*)
					Object[Container, Vessel, "Container 1 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container, Vessel, "Container 2 for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"RunningBufferPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"MarkerPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Plate,"CapillaryStorageSolutionPlate for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for SeparationGel for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Dye for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Ladder for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Vessel,"Container for Marker for ExperimentFragmentAnalysisPreview tests" <> $SessionUUID],
					Object[Container,Rack,"Test Local Cache for ExperimentFragmentAnalysisPreview Tests" <> $SessionUUID]

				}
			], ObjectP[]]];

			(* Check whether the names we want to give below already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force -> True, Verbose -> False]];
		];
	)

];