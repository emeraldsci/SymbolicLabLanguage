(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAbsorbanceKinetics : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AbsorbanceKinetics*)


(* ::Subsubsection:: *)
(*ExperimentAbsorbanceKinetics*)


DefineTests[ExperimentAbsorbanceKinetics,
	{
		Example[{Basic,"Takes a sample object:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceKinetics]]
		],
		Example[{Basic,"Accepts a list of sample objects:"},
			ExperimentAbsorbanceKinetics[{Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 2 "<>$SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceKinetics]]
		],
		Example[{Basic,"Generate protocol for measuring absorbance of samples in a plate object:"},
			ExperimentAbsorbanceKinetics[Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID]],
			ObjectP[Object[Protocol, AbsorbanceKinetics]]
		],
		Example[{Additional,"Specify the input as {Position,Container}:"},
			ExperimentAbsorbanceKinetics[{"A1",Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, AbsorbanceKinetics]]
		],
		Example[{Additional,"Specify the input as a mixture of everything}:"},
			ExperimentAbsorbanceKinetics[{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], {"A1",Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID]}}],
			ObjectP[Object[Protocol, AbsorbanceKinetics]],
			Messages:>{Warning::SinglePlateRequired}
		],
		Test["If an object does not exist, then throw an error and return $Failed cleanly:",
			ExperimentAbsorbanceKinetics[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "DiscardedSamples", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceKinetics[{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Example[{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"Test Label for ExperimentAbsorbanceKinetics 1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"Test Label for ExperimentAbsorbanceKinetics 1"},
			Variables:>{options}
		],
		Example[{Options, Preparation, "Set whether to use the liquid handlers or manual pipettes to perform this aliquot:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Preparation -> Manual,
				Output -> Options
			];
			Lookup[options, Preparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options,BlankLabel,"Specify a label for the blank sample:"},
			options=ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				BlankLabel->"Test Blank Label for ExperimentAbsorbanceKinetics 1",
				Output->Options
			];
			Lookup[options,BlankLabel],
			"Test Blank Label for ExperimentAbsorbanceKinetics 1",
			Variables:>{options}
		],
		Example[{Options, WorkCell, "If Preparation->Robotic, set WorkCell to STAR:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Preparation -> Robotic,
				Output -> Options
			];
			Lookup[options, WorkCell],
			STAR,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],ImageSample->True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,ImageSample,"Indicate that the ContainersIn should be imaged after absorbance readings:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],ImageSample->True];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,ImageSample,"If not specified, ImageSample resolves to True:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]];
			Download[protocol, ImageSample],
			True,
			Variables :> {protocol}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"], Output -> Options];
			Lookup[options, Instrument],
			Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"],
			Variables :> {options}
		],
		Example[{Options,Instrument,"Specify which plate reader instrument will be used during the protocol:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Instrument -> Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]];
			Download[protocol, Instrument],
			ObjectP[Object[Instrument, PlateReader, "id:KBL5DvwA9kZN"]],
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1"];
			Download[protocol, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {protocol}
		],
		Example[{Options, Name, "Provide a name for the protocol:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Name -> "Absorbance Spectroscopy protocol with sample 1", Output -> Options];
			Lookup[options, Name],
			"Absorbance Spectroscopy protocol with sample 1",
			Variables :> {options}
		],
		Example[{Messages, "DuplicateName", "If the specified Name option already exists as a protocol object, throw an error and return $Failed:"},
			ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]},
				Name -> "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID
			],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Options, Template, "Set the Template option:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, Template],
			ObjectP[Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID], Output -> Options];
			Lookup[options, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, Template, "Set the Template option:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, Template],
			ObjectP[Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]],
			Variables :> {protocol}
		],
		Example[{Options, Template, "Inherit the resolved options of a previous protocol:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Template -> Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]];
			Download[protocol, EquilibrationTime],
			46*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
	(* TODO make sure you add a test for ParentProtocol *)
		Test["If Confirm -> True, immediately confirm the protocol without sending it into the cart:",
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Confirm -> True];
			Download[protocol, Status],
			Processing|ShippingMaterials|Backlogged,
			Variables :> {protocol}
		],
		Test["Specify the CanaryBranch on which the protocol is run:",
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], CanaryBranch -> "d1cacc5a-948b-4843-aa46-97406bbfc368"];
			Download[protocol, CanaryBranch],
			"d1cacc5a-948b-4843-aa46-97406bbfc368",
			Variables :> {protocol},
			Stubs:>{GitBranchExistsQ[___] = True, $PersonID = Object[User, Emerald, Developer, "id:n0k9mGkqa6Gr"]}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius];
			Download[protocol, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius];
			Download[protocol, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {protocol}
		],
		Example[{Options,Temperature,"Specify the temperature at which the plates should be read in the plate reader:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Temperature -> 45*Celsius, Output -> Options];
			Lookup[options, Temperature],
			45*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Temperature,"Rounds specified Temperature to the nearest 0.1 degree Celsius:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Temperature -> 40.22*Celsius, Output -> Options];
			Lookup[options, Temperature],
			40.2*Celsius,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables :> {options}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute];
			Download[protocol, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			protocol = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second];
			Download[protocol, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Specify the time for which the plates of samples should be equilibrated at the Temperature:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 7*Minute, Output -> Options];
			Lookup[options, EquilibrationTime],
			7*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options,EquilibrationTime,"Rounds specified EquilibrationTime to the nearest second:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], EquilibrationTime -> 31.5*Second, Output -> Options];
			Lookup[options, EquilibrationTime],
			32*Second,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision},
			Variables :> {options, protocol}
		],
		Example[{Options, Instrument, "Instrument is automatically set to Model[Instrument, PlateReader, \"id:zGj91a7Ll0Rv\"] if TargetCarbonDioxideLevel/TargetOxygenLevel is set:"},
			Lookup[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], TargetCarbonDioxideLevel -> 5 * Percent, Output -> Options],
				Instrument
			],
			ObjectP[Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]]
		],
		Example[{Options, TargetCarbonDioxideLevel, "TargetCarbonDioxideLevel is automatically set to 5 Percent if sample contains Mammalian cells:"},
			Lookup[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics Test Mammalian Sample, no model" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"], Output -> Options],
				TargetCarbonDioxideLevel
			],
			Messages :> {Warning::ExtCoeffNotFound},
			5 * Percent
		],
		Example[{Options,NumberOfReadings,"Indicate that 50 flashes should be performed in order to gather 50 measurements which are averaged together to produce a single reading:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],NumberOfReadings->50][NumberOfReadings],
			50
		],
		Example[{Options,ReadOrder,"Indicates if all measurements and injections are done for one well before advancing to the next (Serial) or in cycles in which each well is read once per cycle (Parallel):"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Wavelength -> 220 Nanometer,
				ReadOrder->Serial,
				PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				Output -> Options
			];
			Lookup[options, ReadOrder],
			Serial,
			Variables :> {options}
		],
		Example[{Options,RunTime,"Indicate the length of time for which absorbance measurements are made:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				RunTime -> 3 Hour,
				Output -> Options
			];
			Lookup[options, RunTime],
			3 Hour,
			EquivalenceFunction->Equal,
			Variables :> {options}
		],
		Example[{Options,PrimaryInjectionSample,"Indicate that you'd like to inject water into every input sample:"},
			ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]},
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,PrimaryInjectionVolume,"If you'd like to skip the injection for a subset of you samples, use Null as a placeholder in the injection samples list and injection volumes list. Here the 2nd sample will not receive injections:"},
			Download[
				ExperimentAbsorbanceKinetics[
					{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
					PrimaryInjectionSample->{Model[Sample, "Milli-Q water"],Null},
					PrimaryInjectionVolume->{4 Microliter,Null},
					PrimaryInjectionTime->10 Minute
				],
				PrimaryInjections
			],
			{
				{10.` Minute, LinkP[Model[Sample, "Milli-Q water"]], 4.` Microliter},
				{10.` Minute, Null, 0.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionTime,"Indicate that injections should begin 10 minutes into the read:"},
			Download[
				ExperimentAbsorbanceKinetics[
					{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
					PrimaryInjectionSample->{Model[Sample, "Milli-Q water"],Null},
					PrimaryInjectionVolume->{4 Microliter,Null},
					PrimaryInjectionTime->10 Minute
				],
				PrimaryInjections
			],
			{
				{10.` Minute, LinkP[Model[Sample, "Milli-Q water"]], 4.` Microliter},
				{10.` Minute, Null, 0.` Microliter}
			}
		],
		Example[{Options,SecondaryInjectionSample,"Specify the sample to inject in the second round of injections:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
				SecondaryInjectionVolume->3 Microliter,
				SecondaryInjectionTime->20 Minute
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,SecondaryInjectionVolume,"Specify that 3\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the second injection round:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute
				],
				SecondaryInjections
			],
			{
				{20.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,SecondaryInjectionTime,"Indicate that the secondary injections should begin 20 minutes into the read:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute
				],
				SecondaryInjections
			],
			{
				{20.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,TertiaryInjectionSample,"Specify the sample to inject in the third round of injections:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				SecondaryInjectionVolume->3 Microliter,
				SecondaryInjectionTime->20 Minute,
				TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
				TertiaryInjectionVolume->4 Microliter,
				TertiaryInjectionTime->30 Minute
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,TertiaryInjectionVolume,"Specify that 4\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the third injection round:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute
				],
				TertiaryInjections
			],
			{
				{30.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],4.` Microliter}
			}
		],
		Example[{Options,TertiaryInjectionTime,"Indicate that the tertiary injections should begin 30 minutes into the read:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute
				],
				TertiaryInjections
			],
			{
				{30.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],4.` Microliter}
			}
		],
		Example[{Options,QuaternaryInjectionSample,"Specify the sample to inject in the fourth round of injections:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				SecondaryInjectionVolume->3 Microliter,
				SecondaryInjectionTime->20 Minute,
				TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				TertiaryInjectionVolume->4 Microliter,
				TertiaryInjectionTime->30 Minute,
				QuaternaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
				QuaternaryInjectionVolume->3 Microliter,
				QuaternaryInjectionTime->40 Minute
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,QuaternaryInjectionVolume,"Specify that 3\[Micro]L of \"Injection test sample 2\" should be injected into the input sample in the fourth injection round:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					QuaternaryInjectionVolume->3 Microliter,
					QuaternaryInjectionTime->40 Minute
				],
				QuaternaryInjections
			],
			{
				{40.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,QuaternaryInjectionTime,"Indicate that the quaternary injections should begin 40 minutes into the read:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					QuaternaryInjectionVolume->3 Microliter,
					QuaternaryInjectionTime->40 Minute
				],
				QuaternaryInjections
			],
			{
				{40.` Minute, LinkP[Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID]],3.` Microliter}
			}
		],
		Example[{Options,PrimaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the first round of injection:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					PrimaryInjectionFlowRate->400 Microliter/Second
				],
				PrimaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,SecondaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the second round of injection:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					SecondaryInjectionFlowRate->400 Microliter/Second
				],
				SecondaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,TertiaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the third round of injection:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute,
					TertiaryInjectionFlowRate->400 Microliter/Second
				],
				TertiaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,QuaternaryInjectionFlowRate,"Set the speed at which samples should be injected into the plate of assay samples during the fourth round of injection:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					SecondaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					SecondaryInjectionVolume->3 Microliter,
					SecondaryInjectionTime->20 Minute,
					TertiaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					TertiaryInjectionVolume->4 Microliter,
					TertiaryInjectionTime->30 Minute,
					QuaternaryInjectionSample->Object[Sample,"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
					QuaternaryInjectionVolume->4 Microliter,
					QuaternaryInjectionTime->40 Minute,
					QuaternaryInjectionFlowRate->400 Microliter/Second
				],
				QuaternaryInjectionFlowRate
			],
			400.` Microliter/Second
		],
		Example[{Options,InjectionSampleStorageCondition,"Indicate that the injection samples should be stored at room temperature after the experiment completes:"},
			Download[
				ExperimentAbsorbanceKinetics[
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute,
					InjectionSampleStorageCondition->AmbientStorage
				],
				InjectionStorageCondition
			],
			AmbientStorage
		],
		Example[{Options,ReadDirection,"To decrease the time it takes to read the plate minimize plate carrier movement by setting ReadDirection to SerpentineColumn:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],ReadDirection->SerpentineColumn][ReadDirection],
			SerpentineColumn
		],
		Example[{Options, BlankAbsorbance, "Indicate whether the absorbance spectrum should be blanked:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Output -> Options];
			Lookup[options, BlankAbsorbance],
			False,
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			protocol = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			protocol = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]}
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Test["If Blanks is specified and we're also Aliquoting, still successfully makes a protocol object:",
			ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID]},
				Blanks -> {Model[Sample, "Milli-Q water"]},
				Aliquot -> True
			],
			ObjectP[Object[Protocol, AbsorbanceKinetics]]
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			protocol = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True
			];
			Download[protocol, Blanks],
			{ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to empty list:"},
			protocol = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False
			];
			Download[protocol, Blanks],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Blanks -> Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"],
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "Indicate what the blank(s) should be for this experiment, expanded for multiple samples:"},
			options = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
				Blanks -> {Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"], Model[Sample, "Milli-Q water"]},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectP[Model[Sample, StockSolution, "50% Methanol in MilliQ Water, Filtered"]], ObjectP[Model[Sample, "Milli-Q water"]]},
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> True and Blanks is not specified, resolve to Milli-Q water:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> True,
				Output -> Options
			];
			Lookup[options, Blanks],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options, protocol}
		],
		Example[{Options, Blanks, "If BlankAbsorbance -> False and Blanks is not specified, resolve to Null:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, Blanks],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			protocol = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumes}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			protocol = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumes}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified resolve BlankVolumes to the volume of the corresponding sample:"},
			protocol = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 90 "<>$SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{200*Microliter, 199*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to empty list:"},
			protocol = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 90 "<>$SessionUUID]},
				BlankAbsorbance -> False
			];
			Download[protocol, BlankVolumes],
			{},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			protocol = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"]
			];
			Download[protocol, BlankVolumes],
			{0.1111*Milliliter},
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::NotEqualBlankVolumes},
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.1*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			0.1*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumes}
		],
		Example[{Options, BlankVolumes, "Indicate the volume of blank to use for each sample, using multiple samples:"},
			options = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID]},
				BlankVolumes -> {0.1*Milliliter, 0.15*Milliliter},
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			{0.1*Milliliter, 0.15*Milliliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol},
			Messages :> {Warning::NotEqualBlankVolumes}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> True, BlankVolumes is not specified resolve BlankVolumes to the volume of the corresponding sample:"},
			options = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 90 "<>$SessionUUID]},
				BlankAbsorbance -> True,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			{200*Microliter, 199*Microliter},
			EquivalenceFunction -> Equal,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "If BlankAbsorbance -> False and BlankVolumes is not specified, resolve BlankVolumes to Null:"},
			options = ExperimentAbsorbanceKinetics[
				{Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 2 "<>$SessionUUID]},
				BlankAbsorbance -> False,
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			Null,
			Variables :> {options, protocol}
		],
		Example[{Options, BlankVolumes, "Rounds specified BlankVolumes to the nearest 0.1 microliter:"},
			options = ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				BlankVolumes -> 0.111112544771*Milliliter,
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Output -> Options
			];
			Lookup[options, BlankVolumes],
			0.1111*Milliliter,
			EquivalenceFunction -> Equal,
			Messages :> {Warning::InstrumentPrecision,Warning::NotEqualBlankVolumes},
			Variables :> {options, protocol}
		],
		Example[{Options,PlateReaderMix,"Set PlateReaderMix to True to shake the input plate in the reader before the assay begins:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMix->True],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 30.` Second}
		],
		Example[{Options,PlateReaderMixSchedule,"Indicate that the plate should be mixed after every read cycle:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixSchedule->BetweenReadings],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime,PlateReaderMixSchedule}
			],
			{True,700.` RPM,30.` Second,BetweenReadings}
		],
		Example[{Options,PlateReaderMixMode,"Specify how the plate should be moved to perform the mixing:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixMode->Orbital],
				PlateReaderMixMode
			],
			Orbital
		],
		Example[{Options,PlateReaderMixRate,"If PlateReaderMixRate is specified, it will automatically turn mixing on and resolve PlateReaderMixTime:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->100 RPM],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,100.` RPM, 30.` Second}
		],
		Example[{Options,PlateReaderMixTime,"Specify PlateReaderMixTime to automatically turn mixing on and resolve PlateReaderMixRate:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->1 Hour],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{True,700.` RPM, 1 Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,MeasureVolume,"Specify MeasureVolume to indicate if the samples should have their volume measured after the protocol:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],MeasureVolume -> True],
				MeasureVolume
			],
			True
		],
		Example[{Options,MeasureWeight,"Specify MeasureWeight to indicate if the samples should have their weight measured after the protocol:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],MeasureWeight -> True],
				MeasureWeight
			],
			True
		],
		Example[{Options,MoatSize,"Indicate the first two columns and rows and the last two columns and rows of the plate should be filled with water to decrease evaporation of the inner assay samples:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				MoatSize->2,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,MoatVolume,"Indicate the volume which should be used to fill each moat well:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				MoatVolume->150 Microliter,
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,MoatBuffer,"Indicate that each moat well should be filled with water:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				MoatBuffer->Model[Sample,"Milli-Q water"],
				Aliquot->True
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,RetainCover,"Indicate that the existing lid or plate seal should be left on during the read:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]]
		],
		Example[{Options,SamplingPattern,"Indicate that a grid of readings should be taken for each well and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Wavelength->600Nanometer,SamplingPattern->Matrix],
				SamplingPattern
			],
			Matrix
		],
		Test["Matrix SamplingPattern is not allowed if we do not have discrete wavelengths:",
			ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Wavelength->All,SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::AbsorbanceSamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Options,SamplingDimension,"Indicate that 16 readings (4x4) should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],SamplingDimension->4],
				SamplingDimension
			],
			4
		],
		Example[{Options,SamplingDistance,"Indicate the length of the region over which sampling measurements should be taken and averaged together to determine the intensity for each sample:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],SamplingPattern->Ring,SamplingDistance->5 Millimeter],
				SamplingDistance
			],
			5.` Millimeter
		],
		Example[{Messages,"AbsorbanceSamplingCombinationUnavailable","SamplingDimension is only supported when SamplingPattern->Matrix:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				SamplingPattern->Ring,
				SamplingDimension->4
			],
			$Failed,
			Messages:>{Error::AbsorbanceSamplingCombinationUnavailable,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedInstrumentSamplingPattern","The Omega can't sample wells using a Matrix pattern:"},
			ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Matrix],
			$Failed,
			Messages:>{Error::UnsupportedInstrumentSamplingPattern,Error::InvalidOption}
		],
		Example[{Messages,"SamplingPatternMismatch","When using an instrument capable of sampling the SamplingPattern can't be set to Null:"},
			ExperimentAbsorbanceKinetics[Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],SamplingPattern->Null],
			$Failed,
			Messages:>{Error::SamplingPatternMismatch,Error::InvalidOption}
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMix->False causes other mix values to resolve to Null:",
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMix->False],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixTime->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixTime->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Test["PlateReaderMixRate->Null causes other mix values to resolve to Null/False:",
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],PlateReaderMixRate->Null],
				{PlateReaderMix,PlateReaderMixRate,PlateReaderMixTime}
			],
			{False,Null,Null},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"MixingParametersRequired","Throws an error if PlateReaderMix->True and PlateReaderMixTime has been set to Null:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->True,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersRequired,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixingParametersUnneeded","Throws an error if PlateReaderMix->False and PlateReaderMixTime has been specified:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime->3 Minute
			],
			$Failed,
			Messages:>{
				Error::MixingParametersUnneeded,
				Error::InvalidOption
			}
		],

		Example[{Messages,"MixingParametersConflict","Throws an error if PlateReaderMix cannot be resolved because one mixing parameter was specified and another was set to Null:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PlateReaderMixRate->200 RPM,
				PlateReaderMixTime->Null
			],
			$Failed,
			Messages:>{
				Error::MixingParametersConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw an error and return early if an input object doesn't exist:"},
			ExperimentAbsorbanceKinetics[{Object[Sample, "Nonexistent object for ExperimentAbsorbanceKinetics testing" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "InvalidInput", "Throw an error if one or multiple of the input samples are discarded:"},
			ExperimentAbsorbanceKinetics[{Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID], Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader model is deprecated:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Instrument -> Model[Instrument, PlateReader, "FlexStation 3"]],
			$Failed,
			Messages :> {Error::DeprecatedInstrument, Error::InvalidInput},
			Variables :> {options, protocol}
		],
		Example[{Messages, "UnsupportedPlateReader", "Returns an error if the specified plate reader object is retired:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], Instrument -> Object[Instrument, PlateReader, "Flexstation"]],
			$Failed,
			Messages :> {Error::UnsupportedPlateReader, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> True and Blanks -> Null:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> True, Blanks -> Null, Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{True, Null},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and BlankVolumes is set:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, BlankVolumes -> 200 Microliter, Output -> Options];
			Lookup[options, {BlankAbsorbance, BlankVolumes}],
			{False, 200 Microliter},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "IncompatibleBlankOptions", "Returns an error if BlankAbsorbance -> False and Blanks is specified:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID], BlankAbsorbance -> False, Blanks -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, {BlankAbsorbance, Blanks}],
			{False, ObjectP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::IncompatibleBlankOptions, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "BlanksContainSamplesIn", "If the specified Blanks option contains samples that are also inputs, throw an error and return $Failed:"},
			options = ExperimentAbsorbanceKinetics[
				{
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 2 "<>$SessionUUID]
				},
				Blanks -> {
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Automatic
				},
				Output -> Options
			];
			Lookup[options, Blanks],
			{ObjectReferenceP[Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID]], ObjectReferenceP[Model[Sample, "Milli-Q water"]]},
			Messages :> {Error::BlanksContainSamplesIn, Error::InvalidOption},
			Variables :> {options, protocol}
		],
		Example[{Messages, "CoveredInjections", "As injections are made into the top of the plate, RetainCover cannot be set to True:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				RetainCover->True,
				PrimaryInjectionSample->Model[Sample, "Milli-Q water"],
				PrimaryInjectionTime->5 Minute,
				PrimaryInjectionVolume->5 Microliter
			],
			$Failed,
			Messages :> {Error::CoveredInjections,Error::InvalidOption}
		],
		Example[{Messages, "AliquotRequired", "If the sample must be aliquoted but no aliquot options are specified, throw a warning telling the user:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], Output -> Options],
			{__Rule},
			Messages :> {Warning::AliquotRequired}
		],
		Test["If Output -> Tests, return a list of tests:",
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID], Output -> Tests],
			{__EmeraldTest},
			Variables :> {options, protocol}
		],
		Test["If Output -> Options, return a list of resolved options:",
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> Options],
			{__Rule},
			Variables :> {options, protocol}
		],
		Test["If Output is to all values, return all of these values:",
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],EquilibrationTime->10 Minute, Output -> {Result, Tests, Options, Preview}],
			{
				ObjectP[Object[Protocol, AbsorbanceKinetics]],
				{__EmeraldTest},
				{__Rule},
				Null
			}
		],

		Example[{Options, SamplesInStorageCondition, "Populate the SamplesInStorage field:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID], SamplesInStorageCondition -> Refrigerator],
				SamplesInStorage
			],
			{Refrigerator}
		],

		Example[{Options, NumberOfReplicates, "Populate SamplesIn in accordance with NumberOfReplicates:"},
			Download[
				ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], NumberOfReplicates -> 2, Aliquot->True],
				SamplesIn[Object]
			],
			{ObjectP[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID]], ObjectP[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID]]}
		],


		(* -- Primitive tests -- *)
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with Preparation->Robotic:",
			Experiment[{
				AbsorbanceKinetics[
					Sample->Object[Sample,"ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate an AbsorbanceKinetics protocol object based on a single primitive with Preparation->Manual:",
			Experiment[{
				AbsorbanceKinetics[
					Sample -> Object[Sample,"ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Manual
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a single primitive with injection options specified:",
			Experiment[{
				AbsorbanceKinetics[
					Sample->Object[Sample,"ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
					Preparation -> Robotic,
					PrimaryInjectionSample->Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
					PrimaryInjectionVolume->4 Microliter,
					PrimaryInjectionTime->10 Minute
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],
		Test["Generate a RoboticSamplePreparation protocol object based on a primitive with multiple samples and Preparation->Robotic:",
			Experiment[{
				AbsorbanceKinetics[
					Sample-> {
						Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
						Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]
					},
					Preparation -> Robotic
				]
			}],
			ObjectP[Object[Protocol,RoboticSamplePreparation]]
		],

		(* sample prep tests *)
		Example[{Additional, "Perform all sample prep experiments on one sample:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], Incubate -> True, Mix -> True, Centrifuge -> True, Filtration -> True, Aliquot -> True],
			ObjectP[Object[Protocol, AbsorbanceKinetics]],
			TimeConstraint -> 2000
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentAbsorbanceKinetics[
				(* Red food dye *)
				{Model[Sample, "id:BYDOjvG9z6Jl"], Model[Sample, "id:BYDOjvG9z6Jl"]},
				(* UV-Star Plate*)
				PreparedModelContainer -> Model[Container, Plate, "id:n0k9mGzRaaBn"],
				PreparedModelAmount -> 200 Microliter,
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				{ObjectP[Model[Sample, "id:BYDOjvG9z6Jl"]]..},
				{ObjectP[Model[Container, Plate, "id:n0k9mGzRaaBn"]]..},
				{EqualP[200 Microliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparatoryUnitOperations, "Use PreparatoryUnitOperations option to create test standards prior to running the experiment:"},
			protocol = ExperimentAbsorbanceKinetics[
				"red dye sample",
				PreparatoryUnitOperations -> {
					LabelContainer[Label -> "red dye sample", Container -> Model[Container, Plate, "96-well UV-Star Plate"]],
					Transfer[Source -> Model[Sample, "Red Food Dye"], Amount -> 200*Microliter, Destination -> {"A1","red dye sample"}]
				}
			];
			Download[protocol, PreparatoryUnitOperations],
			{SamplePreparationP..},
			Variables :> {protocol}
		],
		(* incubate options *)
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotDestinationWell, "Indicates the position in the incubate aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], IncubateAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, IncubateAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquot -> 100*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

	(* centrifuge options *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotDestinationWell, "Indicates the position in the centrifuge aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], CentrifugeAliquotDestinationWell -> "A2", Output -> Options];
			Lookup[options, CentrifugeAliquotDestinationWell],
			"A2",
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Aliquot->True, Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID], CentrifugeTime -> 40*Minute, Aliquot->True, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquot -> 100*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired}
		],

	(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Filtration -> True, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterInstrument -> Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, VacuumPump, "Rocker 300 for Filtration, Non-sterile"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterAliquotDestinationWell, "Indicates the position in the filter aliquot container that the sample should be moved into:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], FilterAliquotDestinationWell -> "A2", Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotDestinationWell],
			"A2",
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterMaterial -> PES,Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterMaterial -> GxF, FilterMaterial -> PTFE, Aliquot->True, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], PrefilterPoreSize -> 1.*Micrometer, FilterMaterial -> PTFE, Aliquot->True, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force the sample through a filter:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterHousing, "FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, Aliquot->True, Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID], FilterSterile -> True, Aliquot->True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquot -> 100*Microliter, Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquot],
			100*Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 500,
			Messages :> {Warning::AliquotRequired,Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages :> {Warning::AliquotRequired}
		],
	(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, DestinationWell, "Indicates the position in the AliquotContainer that we want to move the sample into:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], DestinationWell -> "A2", Output -> Options];
			Lookup[options, DestinationWell],
			{"A2"},
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AbsSpecInsufficientSampleVolume},
			TimeConstraint -> 500
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :> {Warning::AbsSpecInsufficientSampleVolume}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 300*Microliter, Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,TargetConcentrationAnalyte,"The specific analyte to get to the specified target concentration:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], TargetConcentration -> 1*Millimolar, AssayVolume -> 300*Microliter,Output -> Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Water"]],
			Variables:>{options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 100*Microliter, AssayVolume -> 200*Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Aliquots should not be consolidated so that the can be read individually and two replicate points can be recorded:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], ConsolidateAliquots -> False, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			False,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], AliquotContainer -> Model[Container, Plate, "96-well UV-Star Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well UV-Star Plate"]]}},
			Variables :> {options}
		],
		Example[{Options, Wavelength, "When the Wavelength option is a span that specified as low;;high values, the MinWavelength and MaxWavelength are resolved correctly:"},
			options = ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Wavelength->220 Nanometer;;500 Nanometer,Upload->False];
			Lookup[options[[1]], {MinWavelength,MaxWavelength}],
			{220 Nanometer,500 Nanometer},
			Variables :> {options}
		],
		Example[{Messages, "SpanWavelengthOrder", "If Wavelength is a span, a warning is thrown if it is specified as high-wavelength;;low-wavelength:"},
			ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Wavelength->500 Nanometer;;220 Nanometer,Upload->False],
			_?ValidUploadQ,
			Messages:>{Warning::SpanWavelengthOrder}
		],
		Example[{Options, Wavelength, "When the Wavelength option is a span that specified as high;;low values, the MinWavelength and MaxWavelength are resolved correctly:"},
			options = Quiet[ExperimentAbsorbanceKinetics[Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Wavelength->500 Nanometer;;220 Nanometer,Upload->False],{Warning::SpanWavelengthOrder}];
			Lookup[options[[1]], {MinWavelength,MaxWavelength}],
			{220 Nanometer,500 Nanometer},
			Variables :> {options}
		],
		Example[{Messages, "MultipleWavelengthsUnsupported", "Due to limitations of the instrumentation, readings at multiple wavelengths are not possible in serial mode:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				ReadOrder->Serial,
				PrimaryInjectionSample->Model[Sample,"id:8qZ1VWNmdLBD"],
				PrimaryInjectionVolume->4 Microliter,
				PrimaryInjectionTime->10 Minute,
				Wavelength->All
			],
			$Failed,
			Messages:>{Error::MultipleWavelengthsUnsupported,Error::InvalidOption}
		],
		Example[{Messages, "TooManyWavelength", "Due to limitations of the instrumentation, the number of discrete wavelengths cannot exceed 8:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Wavelength->{220 Nanometer,300 Nanometer,400 Nanometer,500 Nanometer,600 Nanometer,605 Nanometer,606 Nanometer,607 Nanometer,608 Nanometer,700 Nanometer,712 Nanometer}
			],
			$Failed,
			Messages:>{Error::TooManyWavelength,Error::InvalidOption}
		],
		Example[{Messages,"InvalidBlankContainer","Throws an error because no blank volume has been specified but blank Buffer 1 is in a 50mL tube and must be transferred into the assay container to be read:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID],
				BlankVolumes->Null
			],
			$Failed,
			Messages:>{Error::InvalidBlankContainer,Error::InvalidOption}
		],
		Example[{Messages,"BlankStateWarning","If the blanks have a state of non-liquid, a warning is given:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Blanks->Object[Sample, "ExperimentAbsorbanceKinetics New Test Peptide oligomer 1 (220 uL)" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::BlankStateWarning}
		],
		Example[{Messages,"UnnecessaryBlankTransfer","Specifying a blank volume indicates that an aliquot of the blank should be taken and read. Gives a warning if this is set to happen even though the blank is already in a valid container:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
				Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 3" <> $SessionUUID],
				BlankVolumes->200 Microliter
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::UnnecessaryBlankTransfer}
		],
		Example[{Messages,"ReplicateAliquotsRequired","Throws an error if replicates are specified and Aliquot->False since replicates are performed by reading multiple aliquots of the same sample:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				Aliquot->False,
				NumberOfReplicates->2
			],
			$Failed,
			Messages:>{Error::ReplicateAliquotsRequired,Error::InvalidOption}
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Throws an error if the same sample is repeated multiple times and Aliquot->False since repeat readings are performed by reading multiple aliquots of the same sample:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]
				},
				Aliquot->False,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			$Failed,
			Messages:>{Error::RepeatedPlateReaderSamples,Error::InvalidOption}
		],
		Example[{Messages,"ReplicateAliquotsRequired","Prints a warning if aliquots will be generated in order to make replicate readings:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				NumberOfReplicates->2
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::ReplicateAliquotsRequired}
		],
		Example[{Messages,"RepeatedPlateReaderSamples","Prints a warning if aliquots will be generated in order to make repeat readings of the same sample:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID],
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID]
				},
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::RepeatedPlateReaderSamples}
		],
		Test["When Blanks are already in a valid container, resolves BlankVolume to match the volume of the sample:",
			Lookup[
				ExperimentAbsorbanceKinetics[
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
					Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID],
					Output->Options
				],
				BlankVolumes
			],
			0.0002` Liter
		],
		Test["When Blanks are already in a valid container, resolves BlankVolume->Null:",
			Lookup[
				ExperimentAbsorbanceKinetics[
					Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
					Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
					Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 3" <> $SessionUUID],
					Output->Options
				],
				BlankVolumes
			],
			Null
		],
		Example[{Messages,"BlankAliquotRequired","Returns $Failed if the blank needs to be aliquoted into a new container but no blank volume was given:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
				Blanks->Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 2 "<>$SessionUUID],
				BlankVolumes->Null,
				Aliquot->True
			],
			$Failed,
			Messages:>{Error::InvalidBlankContainer,Error::InvalidOption}
		],
		Example[{Messages,"InsufficientBlankSpace","Prints a message and returns $Failed if Aliquot->False and samples need to be aliquoted because there's not enough room in the assay container:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 2 "<>$SessionUUID],
					Object[Sample,"ExperimentAbsorbanceKinetics Full Plate Sample 3 "<>$SessionUUID]
				},
				Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID],
				BlankVolumes->{199 Microliter, 200 Microliter, 201 Microliter},
				Aliquot->False
			],
			$Failed,
			Messages:>{Error::InsufficientBlankSpace,Error::InvalidOption}
		],
		Example[{Messages,"InsufficientBlankSpace","Gives a warning if samples needs to be aliquoted because there's not enough room in the assay container. Note that by specifying a constant value for the blank volume, it becomes possible to avoid the aliquot:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 87 "<>$SessionUUID],
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Object[Sample,"ExperimentAbsorbanceKinetics Full Plate Sample 91 "<>$SessionUUID]
				},
				Blanks->Object[Sample,"ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID]
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::InsufficientBlankSpace}
		],
		Example[{Messages,"SinglePlateRequired","Prints a message and returns $Failed if samples are in multiple plates and must be aliquoted in order to consolidate them into a single plate:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]
				},
				Aliquot->False,
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			$Failed,
			Messages:>{Error::SinglePlateRequired,Error::InvalidOption}
		],
		Example[{Messages,"SinglePlateRequired","Gives a warning if samples need to be consolidated into a single plate:"},
			ExperimentAbsorbanceKinetics[
				{
					Object[Sample, "ExperimentAbsorbanceKinetics Full Plate Sample 1 "<>$SessionUUID],
					Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID]
				},
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"]
			],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::SinglePlateRequired}
		],
		Example[{Messages,"AbsorbanceKineticsTooManySamples","Print a message and returns $Failed if there are too many samples and blanks for a single run:"},
			ExperimentAbsorbanceKinetics[
				Object[Container,Plate,"Test container 11 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID]
			],
			$Failed,
			Messages:>{Error::AbsorbanceKineticsTooManySamples,Error::InvalidOption},
			TimeConstraint->300
		],
		Example[{Messages,"InjectionSampleStateError","Print a message and returns $Failed if there are non-liquid injection samples:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionSample -> Object[Sample,"ExperimentAbsorbanceKinetics New Test Peptide oligomer 1 (220 uL)" <> $SessionUUID],
				PrimaryInjectionVolume -> 30 Microliter,
				PrimaryInjectionTime -> 30 Minute],
			$Failed,
			Messages:>{Error::InjectionSampleStateError,Error::InvalidOption}
		],
		Example[{Messages,"SkippedInjectionError","Print a message and returns $Failed if any injections are skipped:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				SecondaryInjectionSample -> Model[Sample,"Milli-Q water"],
				SecondaryInjectionVolume -> 30 Microliter,
				SecondaryInjectionTime -> 30 Minute],
			$Failed,
			Messages:>{Error::SkippedInjectionError,Error::InvalidOption}
		],
		Example[{Messages,"NotEqualBlankVolumesWarning","Print a warning message if the blank volume is not equal to the volume of the sample:"},
			Quiet[ExperimentAbsorbanceKinetics[
				{Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Object[Sample,"ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID]},
				Blanks -> Model[Sample, "Milli-Q water"],
				BlankVolumes -> 200 Microliter],{Warning::SinglePlateRequired}],
			ObjectP[Object[Protocol,AbsorbanceKinetics]],
			Messages:>{Warning::NotEqualBlankVolumes}
		],
		Example[{Messages,"InvalidSimultaneousInjections","Print a message and returns $Failed if subsequent injections are set to occur at the same time using same pump or unsupported plate reader:"},
			ExperimentAbsorbanceKinetics[
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				PrimaryInjectionVolume -> 10 Microliter,
				PrimaryInjectionTime -> 10 Minute,
				PrimaryInjectionSample -> Model[Sample, "id:GmzlKjY5E0ke"],
				SecondaryInjectionVolume -> 10 Microliter,
				SecondaryInjectionTime -> 10 Minute,
				SecondaryInjectionSample -> Model[Sample, "id:GmzlKjY5E0ke"],
				TertiaryInjectionVolume -> 10 Microliter,
				TertiaryInjectionTime -> 20 Minute,
				TertiaryInjectionSample -> Model[Sample, "id:GmzlKjY5E0ke"],
				QuaternaryInjectionVolume -> 10 Microliter,
				QuaternaryInjectionTime -> 20 Minute,
				QuaternaryInjectionSample -> Model[Sample, "id:GmzlKjY5E0ke"]],
			$Failed,
			Messages:>{Error::InvalidSimultaneousInjections,Error::InvalidOption}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentAbsorbanceKinetics[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentAbsorbanceKinetics[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentAbsorbanceKinetics[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentAbsorbanceKinetics[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAbsorbanceKinetics[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container,Vessel,"50mL Tube"],
					{"Work Surface", Object[Container, Bench, "The Bench of Testing"]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					Simulation -> simulationToPassIn,
					InitialAmount -> 25 Milliliter
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentAbsorbanceKinetics[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule},
			Messages:>{Warning::AliquotRequired}
		]
	},
	(* every time a test is run reset $CreatedObjects and erase things at the end *)
	SetUp :> ($CreatedObjects = {}),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{standardObjs,plateSamples,allObjs,existingObjs},
			ClearMemoization[];
			standardObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceKinetics New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceKinetics New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Fake container 10 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 12 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Peptide oligomer 1 (220 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Test Mammalian Sample, no model" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],

				Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]

			};

			plateSamples=Object[Sample,"ExperimentAbsorbanceKinetics Full Plate Sample "<>ToString[#]<>" "<>$SessionUUID]&/@Range[94];

			allObjs=Join[plateSamples,standardObjs];

			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					fakeBench,
					container, container2, container3, container4, container5, container6, container7, container8, container9, container10, container11,
					container12, container13, container14, sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
					sample13, sample14, sample15, sample16, plateSamples, allObjs
				},

				fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,DeveloperObject->True|>];
				{
					container,
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
					container14
				}=UploadSample[
					{
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "2mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"],
						Model[Container, Plate, "96-well UV-Star Plate"]
					},
					{
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench},
						{"Work Surface",fakeBench}
					},
					Name->{
						"Fake container 1 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Plate 1" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Plate 2" <> $SessionUUID,
						"Fake container 2 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 3 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 4 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 5 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 6 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 7 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 8 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 9 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Fake container 10 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Test container 11 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID,
						"Test container 12 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID
					}
				];
				{
					sample,
					sample2,
					sample3,
					sample4,
					sample5,
					sample6,
					sample7,
					sample8,
					sample9,
					sample10,
					sample11,
					sample12,
					sample13,
					sample14,
					sample15,
					sample16
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample, "Acetone, HPLC Grade"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample, "Red Food Dye"],
						Model[Sample, "Somatostatin 28"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"],
						{{1000 * EmeraldCell / Milliliter, Model[Cell, Mammalian, "id:eGakldJvLvzq"]}, {100 * VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}}
					},
					{
						{"A1",container},
						{"A1",container2},
						{"A1",container3},
						{"A2",container2},
						{"A1",container4},
						{"A2",container},
						{"A1",container5},
						{"A1",container6},
						{"A1",container7},
						{"A1",container8},
						{"A1",container9},
						{"A1",container10},
						{"A1",container11},
						{"A1",container12},
						{"A3",container},
						{"A1",container14}
					},
					InitialAmount->{
						200*Microliter,
						200*Microliter,
						300*Microliter,
						300*Microliter,
						200*Microliter,
						200*Microliter,
						15*Milliliter,
						1.5*Milliliter,
						200*Microliter,
						220*Microliter,
						20 Milliliter,
						20 Milliliter,
						20 Milliliter,
						20 Milliliter,
						220*Microliter,
						200*Microliter
					},
					Name->{
						"ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Chemical 1 (red food dye)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics New Test Peptide oligomer 1 (220 uL)" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Blank Buffer 2" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Blank Buffer 3" <> $SessionUUID,
						"ExperimentAbsorbanceKinetics Test Mammalian Sample, no model" <> $SessionUUID
					},
					Living -> False
				];

				plateSamples=UploadSample[
					ConstantArray[Model[Sample,"Milli-Q water"],94],
					{#,container13}&/@Take[Flatten[AllWells[]], 94],
					InitialAmount->Join[ConstantArray[200 Microliter,86],ConstantArray[199 Microliter,4],ConstantArray[198 Microliter,4]],
					Name->("ExperimentAbsorbanceKinetics Full Plate Sample "<>ToString[#]<>" "<>$SessionUUID&/@Range[94])
				];


				allObjs = Join[
					{
						container, container2, container3, container4, container5, container6, container7, container8,
						sample, sample2, sample3, sample4, sample5, sample6, sample7, sample8, sample9, sample10, sample11, sample12,
						sample13,sample14,sample15
					},
					plateSamples
				];

				Upload[Flatten[{
					<|Object->#,DeveloperObject->True|>&/@allObjs,
					<|
						Type -> Object[Protocol, AbsorbanceKinetics],
						Name -> "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID,
						ResolvedOptions -> {
							Instrument -> Model[Instrument, PlateReader, "FLUOstar Omega"],
							Temperature -> Ambient,
							EquilibrationTime -> 46*Minute,
							NumberOfReplicates -> Null,
							BlankAbsorbance -> True,
							Blanks -> Model[Sample, "Milli-Q water"],
							BlankVolumes -> 200*Microliter,
							Confirm -> False,
							ImageSample -> False,
							Name -> Null,
							Template -> Null
						},
						UnresolvedOptions -> {EquilibrationTime -> 46*Minute}
					|>,
					<|Object -> Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID], Replace[Composition] -> {{5 Millimolar, Link[Model[Molecule, "Water"]], Now}}|>
				}]];
				UploadSampleStatus[sample4, Discarded, FastTrack -> True]

			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{standardObjs, plateSamples, allObjs, existingObjs},
			standardObjs = {
				Object[Container, Bench, "Fake bench for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],

				Object[Container, Plate, "Fake container 1 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceKinetics New Test Plate 1" <> $SessionUUID],
				Object[Container, Plate, "ExperimentAbsorbanceKinetics New Test Plate 2" <> $SessionUUID],
				Object[Container, Plate, "Fake container 2 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 3 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 4 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 5 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 6 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 7 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 8 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Vessel, "Fake container 9 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Fake container 10 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 11 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],
				Object[Container, Plate, "Test container 12 for ExperimentAbsorbanceKinetics tests" <> $SessionUUID],

				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (200 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2 (300 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (Discarded)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Acetone Test Chemical 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (15 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (1.5 mL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Chemical 1 (red food dye)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics New Test Peptide oligomer 1 (220 uL)" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Injection 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Injection 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 1" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 2" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Blank Buffer 3" <> $SessionUUID],
				Object[Sample, "ExperimentAbsorbanceKinetics Test Mammalian Sample, no model" <> $SessionUUID],

				Object[Protocol, AbsorbanceKinetics, "Old Absorbance Kinetics Protocol with 1 Hour of equilibration time" <> $SessionUUID]

			};
			plateSamples=Object[Sample,"ExperimentAbsorbanceKinetics Full Plate Sample "<>ToString[#]<>" "<>$SessionUUID]&/@Range[94];
			allObjs=Join[plateSamples,standardObjs];

			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	),
	Variables :> {allObjsWeCreate, existingObjs},
	Stubs:> {
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"],
		$AllowSystemsProtocols = True
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceKineticsPreview*)
DefineTests[
	ExperimentAbsorbanceKineticsPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentAbsorbanceKinetics:"},
			ExperimentAbsorbanceKineticsPreview[Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsPreview "<>$SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluroescenceKineticsOptions:"},
			ExperimentAbsorbanceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsPreview "<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsPreview "<>$SessionUUID],Verbose->Failures],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{platePacket,plate1,samples},

			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Site->Link[$Site],
				Name->"Test plate 1 for ExperimentAbsorbanceKineticsPreview "<>$SessionUUID
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ExperimentAbsorbanceKineticsPreview "<>$SessionUUID,
				InitialAmount->200 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentAbsorbanceKineticsOptions*)
DefineTests[
	ExperimentAbsorbanceKineticsOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentAbsorbanceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsOptions "<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentAbsorbanceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsOptions "<>$SessionUUID],
				ReadOrder->Serial,
				Wavelength->400 Nanometer;;500 Nanometer
			],
			_Grid,
			Messages:>{Error::MultipleWavelengthsUnsupported,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentAbsorbanceKineticsOptions[{Object[Sample,"Test sample 1 for ExperimentAbsorbanceKineticsOptions "<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{platePacket,plate1,samples},
			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Site->Link[$Site],
				Name->"Test plate 1 for ExperimentAbsorbanceKineticsOptions "<>$SessionUUID
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ExperimentAbsorbanceKineticsOptions "<>$SessionUUID,
				InitialAmount->200 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentAbsorbanceKineticsQ*)

DefineTests[
	ValidExperimentAbsorbanceKineticsQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID],Verbose->True],
			True
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure for a plate input:"},
			ValidExperimentAbsorbanceKineticsQ[Object[Container,Plate,"Test plate 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID]],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
			plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
			numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Name->"Test plate 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID,
				Site -> Link[$Site]
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ValidExperimentAbsorbanceKineticsQ "<>$SessionUUID,
				InitialAmount->100 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
]


(* ::Section:: *)
(*End Test Package*)
