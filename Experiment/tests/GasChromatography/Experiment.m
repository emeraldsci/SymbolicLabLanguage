(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentGasChromatography: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* example injection table:

 {
 {Standard, Model[Sample, "Hexanes"], LiquidInjection, {StandardVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
 {Sample, Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], LiquidInjection, {VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
 {Sample, Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], LiquidInjection, {VortexRate -> 500*RPM}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
 {Blank, Model[Sample, "Hexanes"], LiquidInjection, {BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
 {Blank, Null, Null, {}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]}
 }

 *)


(* ::Subsection:: *)
(*ExperimentGasChromatography*)


(* ::Subsubsection:: *)
(*ExperimentGasChromatography*)

DefineTests[ExperimentGasChromatography,
	{
		Example[
			{Basic, "Automatically resolve options for a set of samples:"},
			protocol = ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]];
			MatchQ[protocol, ObjectP[Object[Protocol,GasChromatography]]],
			True,
			Variables :> {protocol},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "GCPostRunOvenTimeTemperatureConflict","If a post run period is specified but the post run temperature is set to Null, an error will be thrown:"},
			ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				PostRunOvenTime -> 5 Minute,
				PostRunOvenTemperature -> Null
			],
			$Failed,
			Messages:>{Error::GCPostRunOvenTimeTemperatureConflict,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "DetectorOptionsRequired","If a detector is specified, but a required detector parameter is set to Null, an error will be thrown:"},
			ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Detector -> FlameIonizationDetector,
				FIDTemperature -> Null
			],
			$Failed,
			Messages:>{Error::DetectorOptionsRequired,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "GCGasSaverConflict","GasSaverFlowRate and GasSaverActivationTime must be specified if and only if GasSaver is True, otherwise an error will be thrown:"},
			ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				GasSaver -> True,
				GasSaverFlowRate -> Null,
				GasSaverActivationTime -> Null
			],
			$Failed,
			Messages:>{Error::GCGasSaverConflict,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
			options = ExperimentGasChromatography[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "2 mL clear glass GC vial"],
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "id:AEqRl9KmRnj1"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentGasChromatography[
				Model[Sample, "Milli-Q water"],
				PreparedModelAmount -> 0.5 Milliliter,
				Aliquot -> True,
				Mix -> True
			],
			ObjectP[Object[Protocol, GasChromatography]]
		],
		Example[
			{Options,Instrument,"Specify the gas chromatograph used to separate analytes in a sample in the gas phase during this experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Instrument->Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"],
				Output -> Options];
			Lookup[options,Instrument],
			Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,CarrierGas,"Specify the gas to be used to push the vaporized analytes through the column during chromatographic separation of the samples injected into the GC:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				CarrierGas->Helium,
				Output -> Options];
			Lookup[options,CarrierGas],
			Helium,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleWash,"Specify whether the syringe will be washed with the sample prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidSampleWash->True,
				Output -> Options];
			Lookup[options,LiquidSampleWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleWash,"Specify whether the syringe will be washed with the sample prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleWash->True,
				Output -> Options];
			Lookup[options,StandardLiquidSampleWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleWash,"Specify whether the syringe will be washed with the sample prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleWash->Null,
				Output -> Options];
			Lookup[options,BlankLiquidSampleWash],
			Null,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Inlet,"Specify the instrument hardware into which the samples to be analyzed will be injected, and where those samples will be subsequently vaporized and pushed onto the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Inlet->Multimode,
				Output -> Options];
			Lookup[options,Inlet],
			Multimode,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletLiner,"Specify the glass insert into which the sample is injected, which will be installed in the inlet during this experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InletLiner->Model[Item, GCInletLiner, "id:XnlV5jKAYJZP"],
				Output -> Options];
			Lookup[options,InletLiner],
			ObjectP[Model[Item, GCInletLiner, "id:XnlV5jKAYJZP"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LinerORing,"Specify a compressible ring that forms a seal separating the inlet volume from the septum purge volume in the inlet, to be installed in the inlet during this experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LinerORing->Model[Item, ORing, "id:01G6nvwpLBZE"],
				Output -> Options];
			Lookup[options,LinerORing],
			Model[Item, ORing, "id:01G6nvwpLBZE"],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletSeptum,"Specify the barrier that the injection syringe will penetrate to inject the sample into the inlet, to be installed in the inlet during this experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InletSeptum->Model[Item, Septum, "id:XnlV5jKAYJZ8"],
				Output -> Options];
			Lookup[options,InletSeptum],
			Model[Item, Septum, "id:XnlV5jKAYJZ8"],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Column,"Specify the capillary tube(s) in which analytes in an injected sample are separated, in their order of installation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Column->Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"],
				Output -> Options];
			Lookup[options,Column],
			ObjectP[Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TrimColumn,"Specify whether or not a length of the inlet end of the column will be removed, typically to remove suspected contamination from the column inlet if column performance begins to degrade. Trimming can be performed less frequently if a guard column is used:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TrimColumn->False,
				Output -> Options];
			Lookup[options,TrimColumn],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TrimColumnLength,"Specify the length of the inlet end of the column to remove prior to installation of the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TrimColumn->True,
				TrimColumnLength->10*Centimeter,
				Output -> Options];
			Lookup[options,TrimColumnLength],
			10*Centimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConditionColumn,"Specify whether or not the column will be conditioned prior to the separation of samples:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ConditionColumn->True,
				Output -> Options];
			Lookup[options,ConditionColumn],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnConditioningGas,"Specify the carrier gas used to purge the column(s) during the column conditioning step, which occurs when the column is installed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnConditioningGas->Helium,
				Output -> Options];
			Lookup[options,ColumnConditioningGas],
			Helium,
			Variables:>{options}
		],
		(*Example[
			{Options,ColumnConditioningGasFlowRate,"Specify the flow rate of carrier gas used to purge the column(s) during the column conditioning step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnConditioningGasFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,ColumnConditioningGasFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],*)
		Example[
			{Options,ColumnConditioningTime,"Specify the time for which the column will be purged by the column conditioning gas prior to separation of standards and samples in the column during the experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTime->30*Minute,
				Output -> Options];
			Lookup[options,ColumnConditioningTime],
			30*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnConditioningTemperature,"Specify the temperature at which the column will be conditioned prior to separation of standards and samples in the column during the experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTemperature->280*Celsius,
				Output -> Options];
			Lookup[options,ColumnConditioningTemperature],
			280*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidInjectionSyringe,"Specify the syringe that will be used to inject liquid samples onto the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Model[Container, Syringe, "id:dORYzZJxRqER"],
				Output -> Options];
			Lookup[options,LiquidInjectionSyringe],
			ObjectP[Model[Container, Syringe, "id:dORYzZJxRqER"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceInjectionSyringe,"Specify the syringe that will be used to inject headspace samples onto the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspaceInjectionSyringe->Model[Container, Syringe, "id:4pO6dM50O14B"],
				Output -> Options];
			Lookup[options,HeadspaceInjectionSyringe],
			ObjectP[Model[Container, Syringe, "id:4pO6dM50O14B"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,SPMEInjectionFiber,"Specify the Solid Phase MicroExtraction (SPME) fiber that will be used to inject samples onto the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEInjectionFiber->Model[Item, SPMEFiber, "id:54n6evLR3kLG"],
				Output -> Options];
			Lookup[options,SPMEInjectionFiber],
			ObjectP[Model[Item, SPMEFiber, "id:54n6evLR3kLG"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,LiquidHandlingSyringe,"Specify the syringe that will be installed into the liquid handling tool on the autosampler deck:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidHandlingSyringe->Model[Container, Syringe, "id:XnlV5jKMl64P"],
				Output -> Options];
			Lookup[options,LiquidHandlingSyringe],
			ObjectP[Model[Container, Syringe, "id:XnlV5jKMl64P"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,Detector,"Specify the detector used to obtain data during this experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector->FlameIonizationDetector,
				Output -> Options];
			Lookup[options,Detector],
			FlameIonizationDetector,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDMakeupGas,"Specify the desired capillary makeup gas flowed into the Flame Ionization Detector (FID) during sample analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDMakeupGas->Helium,
				Output -> Options];
			Lookup[options,FIDMakeupGas],
			Helium,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,DilutionSolvent,"Specify Dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				DilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,DilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondaryDilutionSolvent,"Specify Secondary dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SecondaryDilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SecondaryDilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiaryDilutionSolvent,"Specify Tertiary dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TertiaryDilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,TertiaryDilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Dilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Dilute->False,
				Output -> Options];
			Lookup[options,Dilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,DilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				DilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,DilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,SecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,TertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Agitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Agitate->False,
				Output -> Options];
			Lookup[options,Agitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,AgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,AgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,AgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,AgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,AgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Vortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Vortex->True,
				Output -> Options];
			Lookup[options,Vortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,VortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				VortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,VortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,VortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				VortexTime->30*Second,
				Output -> Options];
			Lookup[options,VortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,SamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,HeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SyringeWashSolvent,"Specify Syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondarySyringeWashSolvent,"Specify Secondary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SecondarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SecondarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiarySyringeWashSolvent,"Specify Tertiary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TertiarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,TertiarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,QuaternarySyringeWashSolvent,"Specify Quaternary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				QuaternarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,QuaternarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,NumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				NumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,NumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,LiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,LiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,HeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,HeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMECondition->True,
				Output -> Options];
			Lookup[options,SPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,SPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,SPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,SPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,SPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizationPositionOffset,"Specify the distance from the SPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,SPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,AgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,SampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,SampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,SampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,InjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,LiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,SampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,SampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,SPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,InjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,InjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,InjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,PreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,SampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,SPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,PostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,PostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,HeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,SPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				Output -> Options];
			Lookup[options,SeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one InitialColumnFlowRate that matches with the SeparationMethod and one that differs:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				InitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,InitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one BlankInitialColumnFlowRate that matches with the BlankSeparationMethod and one that differs:"},
			options=ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				BlankSeparationMethod -> Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				BlankInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,BlankInitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one StandardInitialColumnFlowRate that matches with the StandardSeparationMethod and one that differs:"},
			options=ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				StandardSeparationMethod -> Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				StandardInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,StandardInitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one InitialColumnFlowRate that matches with the SeparationMethod and one that differs and check if the InitialColumnAverageVelocity,InitialColumnPressure,and InitialColumnResidenceTime are recalculated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				InitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {InitialColumnAverageVelocity,InitialColumnPressure,InitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				Standard -> Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				StandardSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				StandardInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {StandardInitialColumnAverageVelocity,StandardInitialColumnPressure,StandardInitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one BlankInitialColumnFlowRate that matches with the BlankSeparationMethod and one that differs and check if the BlankInitialColumnAverageVelocity,BlankInitialColumnPressure,and BlankInitialColumnResidenceTime are recalculated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				Blank -> Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				BlankSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				BlankInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {BlankInitialColumnAverageVelocity,BlankInitialColumnPressure,BlankInitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,InitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,InletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,InletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SplitRatio->10,
				Output -> Options];
			Lookup[options,SplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,SplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,SplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,InitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,InitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				GasSaver->True,
				Output -> Options];
			Lookup[options,GasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				GasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,GasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				GasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,GasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,SolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnFlowRate,"Specify the initial column gas flow rate setpoint:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,InitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,InitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,InitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnResidenceTime,"Specify the initial column residence time setpoint:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,InitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,ColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,ColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,OvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				OvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,OvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,InitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,OvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				OvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,OvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,PostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,PostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunFlowRate,"Specify the column flow rate setpoint at the end of the sample separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,PostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunFlowRate,"Specify the column flow rate setpoint at the end of the standard separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,StandardPostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunFlowRate,"Specify the column flow rate setpoint at the end of the blank separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,BlankPostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunPressure,"Specify the column pressure setpoint at the end of the sample separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				PostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,PostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunPressure,"Specify the column pressure setpoint at the end of the standard separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,StandardPostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunPressure,"Specify the column pressure setpoint at the end of the blank separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,BlankPostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDTemperature,"Specify the temperature of the Flame Ionization Detector (FID) body during analysis of the samples:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDTemperature->300*Celsius,
				Output -> Options];
			Lookup[options,FIDTemperature],
			300*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDAirFlowRate,"Specify the flow rate of air supplied from a Zero Air generator as an oxidant to the Flame Ionization Detector (FID) during sample analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDAirFlowRate->400*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,FIDAirFlowRate],
			400*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDDihydrogenFlowRate,"Specify the flow rate of dihydrogen gas supplied from a Dihydrogen generator as a fuel the Flame Ionization Detector (FID) during sample analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDDihydrogenFlowRate->40*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,FIDDihydrogenFlowRate],
			40*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDMakeupGasFlowRate,"Specify the desired makeup gas flow rate added to the fuel flow supplied to the Flame Ionization Detector (FID) during sample analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDMakeupGasFlowRate->40*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,FIDMakeupGasFlowRate],
			40*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,CarrierGasFlowCorrection,"Specify Determines how the Flame Ionization Detector (FID) supply gases will be adjusted as the column flow rate changes during the separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				CarrierGasFlowCorrection->None,
				Output -> Options];
			Lookup[options,CarrierGasFlowCorrection],
			None,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,FIDDataCollectionFrequency,"Specify the number of times per second (in Hertz) that data points will be collected by the Flame Ionization Detector (FID):"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FIDDataCollectionFrequency->5*Hertz,
				Output -> Options];
			Lookup[options,FIDDataCollectionFrequency],
			5*Hertz,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TransferLineTemperature,"Specify the temperature at which the segment of column the extends out of the column oven and into the mass spectrometer is held:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				TransferLineTemperature->275*Celsius,
				Output -> Options];
			Lookup[options,TransferLineTemperature],
			275*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IonSource,"Specify the type of charged particle used to ionize the separated analytes inside the mass spectrometer. A beam of electrons (ElectronIonization) or charged methane gas (ChemicalIonization) may be used:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				IonSource->ElectronIonization,
				Output -> Options];
			Lookup[options,IonSource],
			ElectronIonization,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IonMode,"Specify whether positively or negatively charged molecular fragments will be analyzed by the mass spectrometer:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				IonMode->Positive,
				Output -> Options];
			Lookup[options,IonMode],
			Positive,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SourceTemperature,"Specify the temperature at which the ionization source, where the sample is ionized inside the mass spectrometer, is held:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				SourceTemperature->230*Celsius,
				Output -> Options];
			Lookup[options,SourceTemperature],
			230*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,QuadrupoleTemperature,"Specify the temperature at which the parallel metal rods, which select the mass of ion to be analyzed inside the mass spectrometer, are held:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				QuadrupoleTemperature->150*Celsius,
				Output -> Options];
			Lookup[options,QuadrupoleTemperature],
			150*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SolventDelay,"Specify the amount of time into the separation after which the mass spectrometer will turn on its controlling voltages. This time should be set to a point in the separation after which the main solvent peak from the separation has already entered and exited the mass spectrometer to avoid damaging the filament:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				SolventDelay->3*Minute,
				Output -> Options];
			Lookup[options,SolventDelay],
			3*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassDetectionGain,"Specify the linear signal amplification factor applied to the ions detected in the mass spectrometer. A gain factor of 1.0 indicates a signal multiplication of 100,000 by the detector. Higher gain factors raise the signal sensitivity but can also cause a nonlinear detector response at higher ion abundances. It is recommended that the lowest possible gain that allows achieving the desired detection limits be used to avoid damaging the electron multiplier:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassDetectionGain->2,
				Output -> Options];
			Lookup[options,MassDetectionGain],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TraceIonDetection,"Specify whether a set of proprietary algorithms will be used to enhance the detection of trace levels of ion abundance during mass spectral data collection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				TraceIonDetection->True,
				Output -> Options];
			Lookup[options,TraceIonDetection],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AcquisitionWindowStartTime,"Specify the amount of time into the separation after which the mass spectrometer will begin collecting data over the specified MassRange:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				AcquisitionWindowStartTime->{4*Minute},
				Output -> Options];
			Lookup[options,AcquisitionWindowStartTime],
			{4*Minute},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRange,"Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded during analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassRange->{50,250},
				Output -> Options];
			Lookup[options,MassRange],
			{50,250},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRangeScanSpeed,"Specify the speed (in m/z per second) at which the mass spectrometer will collect data:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassRangeScanSpeed->10000,
				Output -> Options];
			Lookup[options,MassRangeScanSpeed],
			10000,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRangeThreshold,"Specify the threshold below which ion abundance data will not be recorded:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassRangeThreshold->250,
				Output -> Options];
			Lookup[options,MassRangeThreshold],
			250,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelection,"Specify the mass-to-charge ratios (m/z) and the time for which data will be collected at each m/z during measurement with the mass spectrometer:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassSelection->{{51,100*Milli*Second},{53,100*Milli*Second}},
				Output -> Options];
			Lookup[options,MassSelection],
			{{51,100*Milli*Second},{53,100*Milli*Second}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelectionResolution,"Specify the m/z range window that may be transmitted through the quadrupole at the selected mass. Low resolution will allow a larger range of masses through the quadrupole and increase sensitivity and repeatability, but is not ideal for comparing adjacent m/z values as there may be some overlap in the measured abundances:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassSelectionResolution->Low,
				Output -> Options];
			Lookup[options,MassSelectionResolution],
			Low,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelectionDetectionGain,"Specify the gain factor that will be used during the collection of the corresponding selectively monitored m/z value(s) in MassSelection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector -> MassSpectrometer,
				MassSelectionDetectionGain->2,
				Output -> Options];
			Lookup[options,MassSelectionDetectionGain],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of identical replicates to run using the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				NumberOfReplicates->3,
				Output -> Options];
			Lookup[options,NumberOfReplicates],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Standard,"Specify a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Standard->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,Standard],
			Model[Sample,"Hexanes"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVial,"Specify the container in which to prepare a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardVial->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options];
			Lookup[options,StandardVial],
			Model[Container, Vessel, "2 mL clear glass GC vial"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAmount,"Specify the amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardAmount->1.5*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardAmount],
			1.5*Milli*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardDilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardDilute->False,
				Output -> Options];
			Lookup[options,StandardDilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardDilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardSecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardTertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardTertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardTertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardAgitate->False,
				Output -> Options];
			Lookup[options,StandardAgitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,StandardAgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,StandardAgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,StandardAgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,StandardAgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,StandardAgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardVortex->True,
				Output -> Options];
			Lookup[options,StandardVortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardVortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,StandardVortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardVortexTime->30*Second,
				Output -> Options];
			Lookup[options,StandardVortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,StandardSamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardHeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,StandardHeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardNumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardNumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,StandardNumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,StandardLiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,StandardLiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardHeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,StandardHeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardHeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,StandardHeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMECondition->True,
				Output -> Options];
			Lookup[options,StandardSPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,StandardSPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizationPositionOffset,"Specify the distance from the StandardSPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardAgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,StandardAgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,StandardSampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,StandardSampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,StandardSampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,StandardInjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardSampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,StandardSampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,StandardSPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,StandardInjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,StandardInjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,StandardInjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,StandardPreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardSampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,StandardSPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,StandardPostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,StandardPostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardHeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,StandardHeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				Output -> Options];
			Lookup[options,StandardSeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,StandardInitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,StandardInletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardInletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSplitRatio->10,
				Output -> Options];
			Lookup[options,StandardSplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardSplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardSplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,StandardInitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardGasSaver->True,
				Output -> Options];
			Lookup[options,StandardGasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardGasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardGasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardGasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,StandardGasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardSolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardSolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnFlowRate,"Specify the initial column gas flow rate setpoint for a Standard:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint for a Standard:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,StandardInitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint for the standard:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,StandardInitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnResidenceTime,"Specify the initial column residence time setpoint for the standard:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,StandardColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,StandardColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardOvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardOvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardOvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,StandardInitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardInitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardOvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardOvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,StandardOvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,StandardPostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardPostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardPostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardFrequency,"Specify Specify the frequency at which Standard measurements will be inserted among samples:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				StandardFrequency->First,
				Output -> Options];
			Lookup[options,StandardFrequency],
			First,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Blank,"Specify the injection method to use for a blank run as a negative control, wherein either no injection is made or a cleaned syringe is used to pierce the inlet septum in the manner of a typical injection but no sample volume is injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Blank->NoInjection,
				Output -> Options];
			Lookup[options,Blank],
			NoInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVial,"Specify the container in which to prepare a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankVial->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options];
			Lookup[options,BlankVial],
			Model[Container, Vessel, "2 mL clear glass GC vial"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAmount,"Specify the amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankAmount->1.5*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankAmount],
			1.5*Milli*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankDilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankDilute->False,
				Output -> Options];
			Lookup[options,BlankDilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankDilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankSecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankTertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankTertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankTertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankAgitate->False,
				Output -> Options];
			Lookup[options,BlankAgitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,BlankAgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,BlankAgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,BlankAgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,BlankAgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,BlankAgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankVortex->True,
				Output -> Options];
			Lookup[options,BlankVortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankVortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,BlankVortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankVortexTime->30*Second,
				Output -> Options];
			Lookup[options,BlankVortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,BlankSamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankHeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,BlankHeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankNumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankNumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,BlankNumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,BlankLiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,BlankLiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankHeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,BlankHeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankHeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,BlankHeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMECondition->True,
				Output -> Options];
			Lookup[options,BlankSPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,BlankSPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizationPositionOffset,"Specify the distance from the BlankSPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankAgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,BlankAgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,BlankSampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,BlankSampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,BlankSampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,BlankInjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankSampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,BlankSampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,BlankSPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,BlankInjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,BlankInjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,BlankInjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,BlankPreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankSampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,BlankSPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,BlankPostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,BlankPostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankHeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,BlankHeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				Output -> Options];
			Lookup[options,BlankSeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,BlankInitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,BlankInletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankInletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSplitRatio->10,
				Output -> Options];
			Lookup[options,BlankSplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankSplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankSplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,BlankInitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankGasSaver->True,
				Output -> Options];
			Lookup[options,BlankGasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankGasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankGasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankGasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,BlankGasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankSolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankSolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnFlowRate,"Specify the initial column gas flow rate setpoint for a Blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint for a Blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,BlankInitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint for the blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,BlankInitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnResidenceTime,"Specify the initial column residence time setpoint for the blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,BlankColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,BlankColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankOvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankOvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankOvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,BlankInitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankInitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankOvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankOvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,BlankOvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,BlankPostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankPostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankPostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankFrequency,"Specify Specify the frequency at which Blank measurements will be inserted among samples:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				BlankFrequency->First,
				Output -> Options];
			Lookup[options,BlankFrequency],
			First,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionTable,"Specify the order of Sample, Standard, and Blank sample loading into the Instrument during measurement:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID]},
				InjectionTable->{
					{Standard, Model[Sample, "Hexanes"], LiquidInjection, {StandardVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], LiquidInjection, {VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], LiquidInjection, {VortexMixRate -> 500*RPM}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
					{Blank, Model[Sample, "Hexanes"], LiquidInjection, {BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
					{Blank, Null, Null, {}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]}
				},
				Output -> Options];
			Lookup[options,InjectionTable],
			_List,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionTable,"Specify the order of Sample (only) loading into the Instrument without any Standard or Blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID]},
				InjectionTable->{
					{Sample, Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], LiquidInjection, {VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], LiquidInjection, {VortexMixRate -> 500*RPM}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGC" <> $SessionUUID]}
				},
				Output -> Options];
			Lookup[options,InjectionTable],
			_List,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentGasChromatography[{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},Template->Null];
			Download[protocol,Template],
			Null,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Name->"My particular ExperimentGasChromatography protocol" <> $SessionUUID
			];
			Download[protocol,Name],
			"My particular ExperimentGasChromatography protocol" <> $SessionUUID,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,Upload,"Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			packets=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Upload->False
			],
			{PacketP[Object[Protocol,GasChromatography]],___},
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation:"},
			protocol=ExperimentGasChromatography["My prepared sample",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label -> "My prepared container",
						Container -> Model[Container, Vessel, "1L Glass Bottle"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol - LCMS grade"],
						Destination -> "My prepared container",
						Amount -> 500 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Heptafluorobutyric acid"],
						Destination -> "My prepared container",
						Amount -> 1 Milliliter
					],
					LabelSample[
						Label -> "My prepared sample",
						Sample -> {"A1", "My prepared container"}
					]
				}
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Variables:>{protocol},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 600
		],

		(*all the sample prep stuff*)
		Example[
			{Options,Incubate,"Specify if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationTemperature,"Specify the temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				IncubationTemperature->40 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationTime,"Specify duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				IncubationTime->40 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			40 Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Mix,"Specify the samples should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MixType,"Specify the style of motion used to mix the samples, prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MixUntilDissolved,"Specify if the samples should be mixed in an attempt dissolve any solute prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				MaxIncubationTime->1 Hour,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				IncubationInstrument->Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AnnealingTime,"Specify minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AnnealingTime->20 Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			20 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquotContainer,"Specify the container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				IncubateAliquot->2*Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			2*Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Centrifuge,"Specify if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeTime->2 Minute,
				Output -> Options
			];
			Lookup[options,CentrifugeTime],
			2 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{_Integer, ObjectP[Model[Container, Vessel, "2mL Tube"]]}..,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentGasChromatography[
				{Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID]},
				CentrifugeAliquot->2 Milliliter,
				Output -> Options
			];
			Lookup[options,CentrifugeAliquot],
			2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options, Filtration, "Specify if the SamplesIn should be filtered prior to starting the experiment or any aliquoting:"},
			options = ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Filtration -> True,
				Output -> Options
			];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages :> {Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FiltrationType->Syringe,
				Output -> Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
			options=ExperimentGasChromatography[Object[Sample, "Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Filter,"Specify whether to filter in order to remove impurities from the input samples prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				Object[Sample,"ExperimentGC Large Test Sample 1" <> $SessionUUID],
				Filter->Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"],
				Output -> Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterMaterial->PES,
				Output -> Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				PrefilterMaterial->GxF,
				Output -> Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterPoreSize->0.22 Micrometer,
				Output -> Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options=ExperimentGasChromatography[
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				PrefilterPoreSize->1.`*Micrometer,
				Output -> Options
			];
			Lookup[options,PrefilterPoreSize],
			1.`*Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
			options=ExperimentGasChromatography[
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				FiltrationType->Syringe,
				FilterSyringe->Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterHousing,"Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterHousing->Null,
				Output -> Options
			];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options},
			Messages:>{},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterTime,"Specify the time for which the samples will be centrifuged during filtration:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterTime->5 Minute,
				FiltrationType -> Centrifuge,
				Output -> Options
			];
			Lookup[options,FilterTime],
			5 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentGasChromatography[
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,FilterTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterContainerOut,"Specify the container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Large Test Sample 1" <> $SessionUUID],
				FilterContainerOut->Model[Container, Vessel, "250mL Glass Bottle"],
				Output -> Options
			];
			Lookup[options,FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquotContainer,"Specify the container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,FilterAliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterAliquot->0.2 Milliliter,
				Output -> Options
			];
			Lookup[options,FilterAliquot],
			0.2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				FilterSterile->True,
				Output -> Options
			];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Aliquot,"Specify if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Aliquot->True,
				Output -> Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				AliquotAmount->2 Milliliter,
				Output -> Options
			];
			Lookup[options,AliquotAmount],
			2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				TargetConcentration -> 45 Micromolar,
				Output -> Options
			];
			Lookup[options,TargetConcentration],
			45 Micromolar,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentGasChromatography[Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Acetone"], InjectionVolume -> 10 Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]],
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				AssayVolume->2*Milliliter,
				Output -> Options
			];
			Lookup[options,AssayVolume],
			2*Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BufferDiluent,"Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				BufferDiluent -> Model[Sample, "Methanol - LCMS grade"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample, "Methanol - LCMS grade"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID]},
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AliquotSampleStorageCondition->Refrigerator,
				Output -> Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,DestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				DestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,DestinationWell],
			{"A1","A1","A1"},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotContainer,"Specify the container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AliquotContainer->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options
			];
			Lookup[options,AliquotContainer],
			{{_Integer, ObjectP[Model[Container, Vessel, "2 mL clear glass GC vial"]]}..},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AliquotPreparation->Manual,
				Output -> Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Aliquot->True, ConsolidateAliquots -> True,
				Output -> Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MeasureWeight,"Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				MeasureWeight->False,
				Output -> Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MeasureVolume,"Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				MeasureVolume->False,
				Output -> Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,ImageSample,"Specify if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ImageSample->False,
				Output -> Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the non-default conditions under which any samples going into this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition:"},
			options=ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplesInStorageCondition->AmbientStorage,
				Output -> Options
			];
			Lookup[options,SamplesInStorageCondition],
			AmbientStorage,
			Variables:>{options},
			TimeConstraint -> 300
		],

		(* --- Messages --- *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentGasChromatography[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentGasChromatography[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentGasChromatography[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentGasChromatography[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"UnneededSyringeComponent","A warning is given if unnecessary syringe components are specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				LiquidInjectionSyringe->Model[Container, Syringe, "id:dORYzZJxRqER"],
				SamplingMethod->HeadspaceInjection
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::UnneededSyringeComponent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"OverwritingSeparationMethod","A warning is given if the SeparationMethod is overwritten:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				SeparationMethod->Object[Method,GasChromatography,"Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				InletSeptumPurgeFlowRate -> 5 Milliliter/Minute
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::OverwritingSeparationMethod
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCColumnMinTemperatureExceeded","A warning is given if the temperature settings in the experiment are lower than the MinTemperature of the GCColumn:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Column->Model[Item, Column,"Column with high MinTemperature for ExperimentGC" <> $SessionUUID],
				InitialOvenTemperature -> 30 Celsius
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::GCColumnMinTemperatureExceeded
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AutomaticallySelectedWashSolvent","A warning is given if solvent washes are specified but no wash solvent is specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				DilutionSolvent->Automatic,
				LiquidPostInjectionNumberOfSolventWashes -> 3
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::AutomaticallySelectedWashSolvent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AutomaticallySelectedDilutionSolvent","A warning is given if a DilutionSolventVolume is specified but no DilutionSolvent is specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				DilutionSolventVolume -> 25 Microliter
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::AutomaticallySelectedDilutionSolvent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCStandardBlankContainer","An error is given if a Blank is in a GC-incompatible container:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter,
				Aliquot -> False
			],
			$Failed,
			Messages :> {
				Error::GCStandardBlankContainer,
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCMismatchedVialsAndAmounts","An error is given if a Blank is in a GC-incompatible container:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnspecifiedVials","An error is given if a Blank is specified but a BlankVial is not:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnneededAmounts","An error is given if a Blank is NoInjection but a BlankAmount is specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCUnneededAmounts,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnneededVials","An error is given if a Blank is NoInjection but a BlankVial is specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"]
			],
			$Failed,
			Messages :> {
				Error::GCUnneededVials,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"InvalidBlankSamplePreparationOptions","An error is given if a Blank is NoInjection but a BlankAmount is specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCUnneededAmounts,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnspecifiedAmounts","An error is given if a Blank is specified but BlankAmount is Null:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID],
				BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"],
				BlankAmount -> Null
			],
			$Failed,
			Messages :> {
				Error::GCUnspecifiedAmounts,
				Error::GCMismatchedVialsAndAmounts,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidAgitateWhileSampling","An error is given if SamplingMethod options are LiquidInjection and AgitateWhileSampling options are True:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				AgitateWhileSampling -> True
			],
			$Failed,
			Messages :> {
				Error::LiquidAgitateWhileSampling,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceWithoutAgitation","An error is given if SamplingMethod options are HeadspaceInjection and Agitate options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SamplingMethod -> HeadspaceInjection,
				Agitate -> False
			],
			$Failed,
			Messages :> {
				Error::HeadspaceWithoutAgitation,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceAgitateWhileSampling","An error is given if SamplingMethod options are HeadspaceInjection and AgitateWhileSampling options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SamplingMethod -> HeadspaceInjection,
				AgitateWhileSampling -> False
			],
			$Failed,
			Messages :> {
				Error::HeadspaceAgitateWhileSampling,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"SPMEDerivatizationOptionsConflict","An error is given if SPMEDerivatizingAgentAdsorptionTime, SPMEDerivatizationPosition, or SPMEDerivatizationPositionOffset options are specified but the corresponding SPMEDerivatizingAgent options are Null:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SPMEDerivatizingAgent -> Null,
				SPMEDerivatizingAgentAdsorptionTime -> 10 Minute
			],
			$Failed,
			Messages :> {
				Error::SPMEDerivatizationOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"SPMEConditionOptionsConflict","An error is given if SPMEConditioningTemperature, SPMEPreConditioningTime, or SPMEPostInjectionConditioningTime options are specified but the corresponding SPMECondition options are not specified:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SPMECondition -> False,
				SPMEConditioningTemperature -> 45 Celsius
			],
			$Failed,
			Messages :> {
				Error::SPMEConditionOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceSyringeFlushingOptionsConflict","An error is given if HeadspacePreInjectionFlushTime or HeadspacePostInjectionFlushTime options are specified but the corresponding HeadspaceSyringeFlushing options are Null:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				HeadspaceSyringeFlushing -> Null,
				HeadspacePreInjectionFlushTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::HeadspaceSyringeFlushingOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PostInjectionSyringeWashOptionsConflict","An error is given if LiquidPostInjectionSyringeWash related options are specified but the corresponding LiquidPostInjectionSyringeWash options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				LiquidPostInjectionSyringeWash -> False,
				LiquidPostInjectionSyringeWashVolume -> 20 Microliter
			],
			$Failed,
			Messages :> {
				Error::PostInjectionSyringeWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"InsufficientSampleVolume","An error is given if InjectionVolume options are greater than the volume of corresponding sample available, including replicates:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				InjectionVolume -> 2 Milliliter
			],
			$Failed,
			Messages :> {
				Error::InsufficientSampleVolume,
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidSampleWashOptionsConflict","An error is given if LiquidSampleWashVolume or NumberOfLiquidSampleWashes options are specified but the corresponding LiquidSampleWash options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				LiquidSampleWash -> False,
				NumberOfLiquidSampleWashes -> 2
			],
			$Failed,
			Messages :> {
				Error::LiquidSampleWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PreInjectionSyringeWashOptionsConflict","An error is given if LiquidPreInjectionSyringeWash related options are specified but the corresponding LiquidPreInjectionSyringeWash options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SyringeWashSolvent -> Model[Sample, "Hexanes"],
				LiquidPreInjectionSyringeWash -> False,
				LiquidPreInjectionNumberOfSolventWashes -> 2
			],
			$Failed,
			Messages :> {
				Error::PreInjectionSyringeWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"VortexOptionsConflict","An error is given if VortexTime or VortexMixRate options are specified but the corresponding Vortex options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				Vortex -> False,
				VortexTime -> 2 Second
			],
			$Failed,
			Messages :> {
				Error::VortexOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ContainersOverfilledByDilution","An error is given if specified Dilution options will result in overfilling the container:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				DilutionSolvent -> Model[Sample, "Hexanes"],
				DilutionSolventVolume -> 2 Milliliter
			],
			$Failed,
			Messages :> {
				Error::ContainersOverfilledByDilution,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AgitationOptionsConflict","An error is given if Agitation related options are specifed and Agitate options are False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				Agitate -> False,
				AgitationTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::AgitationOptionsConflict,
				Error::LiquidInjectionAgitationConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidInjectionAgitationConflict","An error is given if SamplingMethod options are LiquidInjection and Agitate options are True or Agitation options are set:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				AgitationTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::LiquidInjectionAgitationConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ColumnConditioningOptionsConflict","An error is given if ColumnConditioningTime or ColumnConditioningGas are specified and ConditionColumn is False:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID],
				ConditionColumn -> False,
				ColumnConditioningTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::ColumnConditioningOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCColumnMaxTemperatureExceeded","An error is given if the Temperature setpoints exceed the maximum column temperature:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTemperature->400Celsius
			],
			$Failed,
			Messages :> {
				Error::GCColumnMaxTemperatureExceeded,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCSampleVolumeOutOfRange","An error is given if the specified InjectionVolume does not fall between 1% and 100% of the volume of the specified InjectionSyringe:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InjectionVolume -> 250*Microliter,
				LiquidInjectionSyringe -> Model[Container, Syringe, "id:dORYzZJxRqER"]
			],
			$Failed,
			Messages :> {
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CospecifiedInitialColumnConditions","An error is given if options are selected that cannot be specified for any separation simultaneously:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InitialColumnFlowRate->100Milliliter/Minute,
				InitialColumnPressure->50PSI
			],
			$Failed,
			Messages :> {
				Error::CospecifiedInitialColumnConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleInletAndInletOption","An error is given if options are selected that are not compatible with a SplitSplitless inlet:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SolventEliminationFlowRate->100Milliliter/Minute,
				Inlet->SplitSplitless
			],
			$Failed,
			Messages :> {
				Error::IncompatibleInletAndInletOption,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SplitRatioAndFlowRateCospecified","An error is given if SplitRatio and SplitVentFlowRate are specified simultaneously:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SplitRatio->20,
				SplitVentFlowRate->60Milliliter/Minute
			],
			$Failed,
			Messages :> {
				Error::SplitRatioAndFlowRateCospecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCOptionsAreConflicting","An error is given if SplitRatio or SplitVentFlowRate are specified when SolventEliminationFlowRate is also specified:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SplitRatio->20,
				SolventEliminationFlowRate->60Milliliter/Minute
			],
			$Failed,
			Messages :> {
				Error::GCOptionsAreConflicting,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OptionsNotCompatibleWithSamplingMethod","An error is given if Liquid sampling options are specified if the SamplingMethod is not set to LiquidInjection:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				LiquidPreInjectionSyringeWashVolume->60Microliter
			],
			$Failed,
			Messages :> {
				Error::OptionsNotCompatibleWithSamplingMethod,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCContainerIncompatible","An error is given if the containers specified are incompatible with the specified Instrument:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				AliquotContainer->Model[Container,Vessel,"10L Polypropylene Carboy"]
			],
			$Failed,
			Messages :> {
				Error::GCContainerIncompatible,
				Error::CoverNeededForContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OptionValueOutOfBounds","An error is given if the option value it set too high for the instrument:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleAspirationRate->100*Milliliter/Second,
				SamplingMethod->LiquidInjection
			],
			$Failed,
			Messages :> {
				Error::OptionValueOutOfBounds,
				Error::InvalidOption
			}
		],
		Test["An error is given if the option value it set to low for the instrument:",
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SampleInjectionRate->8.3 Microliter/Second,
				SamplingMethod->HeadspaceInjection
			],
			$Failed,
			Messages :> {
				Error::OptionValueOutOfBounds,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DetectorOptionsIncompatible","An error is given if the options are not compatible with a specified detector:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Detector->MassSpectrometer,
				FIDTemperature->200Celsius
			],
			$Failed,
			Messages :> {
				Error::DetectorOptionsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCORingNotCompatible","An error is given if the LinerORing cannot currently be used on instrument:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LinerORing->Model[Item, ORing, "id:aXRlGn6pznXB"]
			],
			$Failed,
			Messages :> {
				Error::GCORingNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCSeptumNotCompatible","An error is given if the InletSeptum cannot currently be used on instrument:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				InletSeptum->Model[Item, Septum,"Example Septum for ExperimentGC " <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::GCSeptumNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleColumn","An error is given if the Column is not a GC column:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				Column->Model[Item, Column, "id:D8KAEvGloNL3"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleColumn,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCTrimColumnConflict","An error is given if a TrimColumnLength is specified if TrimColumn is False:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				TrimColumn->False,
				TrimColumnLength->40Centimeter
			],
			$Failed,
			Messages :> {
				Error::GCTrimColumnConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCLiquidInjectionSyringeRequired","An error is given a LiquidInjection sample has been specified but a LiquidInjectionSyringe has not:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCLiquidInjectionSyringeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleLiquidInjectionSyringe","An error is given if the LiquidInjectionSyringe does not have the correct GCInjectionTypeLiquidInjection:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleLiquidInjectionSyringe,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCHeadspaceInjectionSyringeRequired","An error is given if a HeadspaceInjection sample has been specified but a HeadspaceInjectionSyringe has not:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				HeadspaceInjectionSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCHeadspaceInjectionSyringeRequired,
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleHeadspaceInjectionSyringe","An error is given if the HeadspaceInjectionSyringe does not have the correct GCInjectionType:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				HeadspaceInjectionSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleHeadspaceInjectionSyringe,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCSPMEInjectionFiberRequired","An error is given if a SPMEInjection sample has been specified but a SPMEInjectionFiber has not:"},
			ExperimentGasChromatography[
				{Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGC Test Sample 3" <> $SessionUUID]},
				SamplingMethod->SPMEInjection,
				SPMEInjectionFiber->Null
			],
			$Failed,
			Messages :> {
				Error::GCSPMEInjectionFiberRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCLiquidHandlingSyringeRequired","An error is given if a LiquidHandling step has been specified but a LiquidHandlingSyringe has not:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 5" <> $SessionUUID],
				DilutionSolventVolume->100Microliter,
				DilutionSolvent -> Model[Sample, "Hexanes"],
				LiquidHandlingSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCLiquidHandlingSyringeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleLiquidHandlingSyringe","An error is given if the LiquidHandlingSyringe does not have the correct GCInjectionType:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 5" <> $SessionUUID],
				DilutionSolventVolume->100Microliter,
				DilutionSolvent -> Model[Sample, "Hexanes"],
				LiquidHandlingSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleLiquidHandlingSyringe,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CoverNeededForContainer", "An error is given if a compatible cap cannot be found for the container to be loaded onto the GC autosampler:"},
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				AliquotContainer -> Model[Container, Vessel, "10L Polypropylene Carboy"]
			],
			$Failed,
			Messages :> {
				Error::GCContainerIncompatible,
				Error::CoverNeededForContainer,
				Error::InvalidOption
			}
		],
		Test["Users may use any vial with the correct footprint for the autosampler and with any pierceable cap as long as the sample does not need to move on the GC deck:",
			ExperimentGasChromatography[
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Agitate -> False,
				Vortex -> False
			],
			ObjectP[Object[Protocol, GasChromatography]]
		],
		Test["Aliquoting to a container with a magnetic cap is required, if the sample needs to move on the GC deck:",
			ExperimentGasChromatography[
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Agitate -> False,
				Vortex -> True
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Messages, "CapSwap", "A Warning is surfaced if a sample is in a container that requires its current cover to be replaced with a new cap:"},
			ExperimentGasChromatography[
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {
				Warning::ContainerCapSwapRequired
			}
		],
		Test["A Warning is surfaced if a standard is in a container that requires its current cover to be replaced with a compatible cap:",
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::ContainerCapSwapRequired}
		],
		Test["A Warning is surfaced if a blank is in a container that requires current cover to be replaced with a compatible cap:",
			ExperimentGasChromatography[
				Object[Sample, "ExperimentGC Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::ContainerCapSwapRequired}
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration -> HighRAM,
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 3" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 4" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 5" <> $SessionUUID],
				Object[Sample,"ExperimentGC Large Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGC tests" <> $SessionUUID],
				Object[Sample, "Example sample in a uncovered vial for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 2 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 3 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 4 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 5 for ExperimentGC tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial without a cover for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container,Vessel,"Test large vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test invalid container 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 2 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 3 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 4 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 5 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example large magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-pierceable vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Protocol,GasChromatography,"My particular ExperimentGasChromatography protocol" <> $SessionUUID],
				Object[Method,GasChromatography,"Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 1 for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 2 for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 3 for ExperimentGC" <> $SessionUUID],
				Model[Item, Septum, "Example Septum for ExperimentGC " <> $SessionUUID],
				Model[Item, Column,"Column with high MinTemperature for ExperimentGC" <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, container2, container3, container4, container5,  discardedContainer,
					largeContainer, invalidContainer, containerWithNonPierceableCap, containerWithNonMagneticCap, containerWithoutCover,
					cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap, coverPackets, samplePackets,
					methodPackets, stockedProductPackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGasChromatography tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1, container2, container3, container4, container5, containerWithoutCover,
					discardedContainer, containerWithNonPierceableCap, largeContainer, invalidContainer, containerWithNonMagneticCap,
					cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:jLq9jXvwdnRW"], (*10 mL clear glass GC vial*)
						Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*2mL Tube*)
						Model[Container, Vessel, "id:XnlV5jNXm8oP"], (*Thermo Scientific SureSTART 2 mL Glass Crimp Top Vials, Level 2 High-Throughput Applications*)
						Model[Item, Cap, "id:L8kPEjn1PRww"],(*2 mL GC vial cap, magnetic*)
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:AEqRl9Kmnrqv"],
						Model[Item, Cap, "id:jLq9jXOmYw5q"],(*Thermo Scientific SureSTART 11 mm Crimp Caps, White Silicone/Red PTFE*)
						Model[Item, Cap, "id:6V0npvmo1qX8"](*"Tube Cap, 12x6mm" w/ Pierceable -> False*)
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
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGC tests" <> $SessionUUID,
						"Test vial 2 for ExperimentGC tests" <> $SessionUUID,
						"Test vial 3 for ExperimentGC tests" <> $SessionUUID,
						"Test vial 4 for ExperimentGC tests" <> $SessionUUID,
						"Test vial 5 for ExperimentGC tests" <> $SessionUUID,
						"Example vial without a cover for ExperimentGasChromatography tests " <> $SessionUUID,
						"Test discarded vial 1 for ExperimentGC tests" <> $SessionUUID,
						"Example vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID,
						"Test large vial 1 for ExperimentGC tests" <> $SessionUUID,
						"Test invalid container 1 for ExperimentGC tests" <> $SessionUUID,
						"Example vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example magnetic vial cap 2 for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example magnetic vial cap 3 for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example magnetic vial cap 4 for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example magnetic vial cap 5 for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example large magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example non-magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example non-pierceable vial cap for ExperimentGasChromatography tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1, container2, container3, container4, container5, largeContainer, containerWithNonMagneticCap, containerWithNonPierceableCap},
					Cover -> {cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", largeContainer},
						{"A1", invalidContainer},
						{"A1", discardedContainer},
						{"A1", containerWithoutCover},
						{"A1", containerWithNonMagneticCap},
						{"A1", containerWithNonPierceableCap}
					},
					InitialAmount ->
							{
								2000 Microliter,
								300 Microliter,
								1000 Microliter,
								1000 Microliter,
								100 Microliter,
								4000 Microliter,
								2000 Microliter,
								1800 Microliter,
								1000 Microliter,
								1000 Microliter,
								1000 Microliter
							},
					Name->{
						"ExperimentGC Test Sample 1" <> $SessionUUID,
						"ExperimentGC Test Sample 2" <> $SessionUUID,
						"ExperimentGC Test Sample 3" <> $SessionUUID,
						"ExperimentGC Test Sample 4" <> $SessionUUID,
						"ExperimentGC Test Sample 5" <> $SessionUUID,
						"ExperimentGC Large Test Sample 1" <> $SessionUUID,
						"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID,
						"Test sample for discarded sample for ExperimentGC tests" <> $SessionUUID,
						"Example sample in a uncovered vial for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example sample in a vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID,
						"Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)

				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGC Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						],
						Association[
							Object -> Object[Sample,"ExperimentGC Test Sample 4" <> $SessionUUID],
							Model -> Null
						]
					}
				];

				methodPackets = {
					Association[
						Type -> Object[Method, GasChromatography],
						Name -> "Test SeparationMethod for ExperimentGC" <> $SessionUUID,
						Replace[ColumnLength]->30*Meter,
						Replace[ColumnDiameter]->0.32*Milli*Meter,
						Replace[ColumnFilmThickness]->0.25*Micro*Meter,
						InletLinerVolume->870*Micro*Liter,
						Detector->FlameIonizationDetector,
						CarrierGas->Helium,
						InletSeptumPurgeFlowRate->3*Milli*Liter/Minute,
						InitialInletTemperature->250*Celsius,
						SplitRatio->20,
						InitialInletPressure->25*PSI,
						InitialInletTime->1*Minute,
						GasSaver->True,
						GasSaverFlowRate->25*Milli*Liter/Minute,
						GasSaverActivationTime->3*Minute,
						InitialColumnFlowRate->1.7*Milli*Liter/Minute,
						ColumnFlowRateProfile->ConstantFlowRate,
						OvenEquilibrationTime->2*Minute,
						InitialOvenTemperature->50*Celsius,
						OvenTemperatureProfile->Isothermal,
						PostRunOvenTemperature->35*Celsius,
						PostRunOvenTime->2*Minute
					]
				};

				Upload[methodPackets];

				stockedProductPackets = {
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 1 for ExperimentGC" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					],
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 2 for ExperimentGC" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					],
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 3 for ExperimentGC" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					]
				};

				Upload[stockedProductPackets];

				Upload[{
					<|
						Type->Model[Item, Septum],
						Name->"Example Septum for ExperimentGC " <> $SessionUUID,
						Diameter->1Millimeter
					|>,
					<|
						Type -> Model[Item, Column],
						ChromatographyType -> GasChromatography,
						ColumnFormat -> Quantity[7., "Inches"],
						ColumnLength -> Quantity[30000., "Millimeters"],
						ColumnType -> Analytical,
						Replace[Connectors] -> {{"Column Inlet", Tube, None, Quantity[0.00984251968503937, "Inches"], Quantity[0.015748031496062992, "Inches"], None}, {"Column Outlet", Tube, None, Quantity[0.00984251968503937, "Inches"], Quantity[0.015748031496062992, "Inches"], None}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Diameter -> Quantity[0.25, "Millimeters"],
						Dimensions -> {Quantity[0.1905, "Meters"], Quantity[0.1905, "Meters"], Quantity[0.0635, "Meters"]},
						FilmThickness -> Quantity[0.25, "Micrometers"],
						MaxFlowRate -> Quantity[16000., "Milliliters"/"Minutes"],
						MaxNumberOfUses -> 9999,
						MaxPressure -> Quantity[100., "PoundsForce"/"Inches"^2],
						MaxShortExposureTemperature -> Quantity[350., "DegreesCelsius"],
						MaxTemperature -> Quantity[325., "DegreesCelsius"],
						MinFlowRate -> Quantity[0., "Milliliters"/"Minutes"],
						MinPressure -> Quantity[0., "PoundsForce"/"Inches"^2],
						MinTemperature -> Quantity[40, "DegreesCelsius"],
						PackingType -> WCOT,
						Polarity -> NonPolar,
						SeparationMode -> GasChromatography,
						Size -> Quantity[30., "Meters"],
						Replace[StationaryPhaseBonded] -> {Bonded, Crosslinked},
						Replace[WettedMaterials] -> {Silica},
						DeveloperObject -> True,
						Name -> "Column with high MinTemperature for ExperimentGC" <> $SessionUUID
					|>
				}]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 3" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 4" <> $SessionUUID],
				Object[Sample,"ExperimentGC Test Sample 5" <> $SessionUUID],
				Object[Sample,"ExperimentGC Large Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for invalid container for ExperimentGC tests" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGC tests" <> $SessionUUID],
				Object[Sample, "Example sample in a uncovered vial for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 2 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 3 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 4 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 5 for ExperimentGC tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial without a cover for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-pierceable cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Container,Vessel,"Test large vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test invalid container 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGC tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-magnetic cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 2 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 3 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 4 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 5 for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example large magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-magnetic vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-pierceable vial cap for ExperimentGasChromatography tests " <> $SessionUUID],
				Object[Protocol,GasChromatography,"My particular ExperimentGasChromatography protocol" <> $SessionUUID],
				Object[Method,GasChromatography,"Test SeparationMethod for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 1 for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 2 for ExperimentGC" <> $SessionUUID],
				Object[Item,Cap,"Stocked vial cap 3 for ExperimentGC" <> $SessionUUID],
				Model[Item, Septum,"Example Septum for ExperimentGC " <> $SessionUUID],
				Model[Item, Column,"Column with high MinTemperature for ExperimentGC" <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
	Parallel -> False
];


(* ::Subsubsection:: *)
(*ExperimentGasChromatographyOptions*)

DefineTests[
	ExperimentGasChromatographyOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentGasChromatographyOptions[Object[Sample,"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentGasChromatographyOptions[Object[Sample,"Test sample for discarded sample for ExperimentGasChromatographyOptions tests" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentGasChromatographyOptions[Object[Sample,"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatographyOptions tests " <> $SessionUUID],
				Object[Sample,"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatographyOptions tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, discardedContainer, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGasChromatographyOptions tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					discardedContainer,
					cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID,
						"Test discarded vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGasChromatographyOptions tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", discardedContainer}
					},
					InitialAmount ->
							{
								2000 Microliter,
								1800 Microliter
							},
					Name->{
						"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID,
						"Test sample for discarded sample for ExperimentGasChromatographyOptions tests" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)
				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatographyOptions tests " <> $SessionUUID],
				Object[Sample,"ExperimentGasChromatographyOptions Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGasChromatographyOptions tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatographyOptions tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];

(* ::Subsubsection:: *)
(*ValidExperimentGasChromatographyQ*)

DefineTests[
	ValidExperimentGasChromatographyQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentGasChromatographyQ[Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentGasChromatographyQ[Object[Sample,"Test sample for discarded sample for ValidExperimentGasChromatographyQ tests" <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentGasChromatographyQ[Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentGasChromatographyQ[Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID],Verbose->True],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ValidExperimentGasChromatographyQ tests " <> $SessionUUID],
				Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ValidExperimentGasChromatographyQ tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, discardedContainer, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ValidExperimentGasChromatographyQ tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					discardedContainer,
					cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID,
						"Test discarded vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ValidExperimentGasChromatographyQ tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", discardedContainer}
					},
					InitialAmount ->
							{
								2000 Microliter,
								1800 Microliter
							},
					Name->{
						"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID,
						"Test sample for discarded sample for ValidExperimentGasChromatographyQ tests" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)
				Upload[
					{
						Association[
							Object -> Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ValidExperimentGasChromatographyQ tests " <> $SessionUUID],
				Object[Sample,"ValidExperimentGasChromatographyQ Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ValidExperimentGasChromatographyQ tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ValidExperimentGasChromatographyQ tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];

(* ::Subsubsection:: *)
(*ExperimentGasChromatographyPreview*)

DefineTests[
	ExperimentGasChromatographyPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentGasChromatography:"},
			ExperimentGasChromatographyPreview[Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentGasChromatographyOptions:"},
			ExperimentGasChromatographyOptions[Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentGasChromatographyQ:"},
			ValidExperimentGasChromatographyQ[Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID]],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatographyPreview tests " <> $SessionUUID],
				Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGasChromatographyPreview tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatographyPreview tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGasChromatographyPreview tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1,
					cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGasChromatographyPreview tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGasChromatographyPreview tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"] (*80% Heptane, 20% Ethanol diluent for SFC*)
					},
					{
						{"A1", container1}
					},
					InitialAmount ->
							{
								2000 Microliter
							},
					Name->{
						"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(*sever the link to the model*)
				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGasChromatographyPreview tests " <> $SessionUUID],
				Object[Sample,"ExperimentGasChromatographyPreview Test Sample 1" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGasChromatographyPreview tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGasChromatographyPreview tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];

(* ::Subsection:: *)
(*ExperimentGCMS*)


(* ::Subsubsection:: *)
(*ExperimentGCMS*)

DefineTests[ExperimentGCMS,
	{

		Example[
			{Basic, "Automatically resolve options for a set of samples:"},
			protocol = ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]];
			MatchQ[protocol, ObjectP[Object[Protocol,GasChromatography]]],
			True,
			Variables :> {protocol},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "GCPostRunOvenTimeTemperatureConflict","If a post run period is specified but the post run temperature is set to Null, an error will be thrown:"},
			ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				PostRunOvenTime -> 5 Minute,
				PostRunOvenTemperature -> Null
			],
			$Failed,
			Messages:>{Error::GCPostRunOvenTimeTemperatureConflict,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "DetectorOptionsRequired","If a required detector parameter is set to Null, an error will be thrown:"},
			ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				FIDTemperature -> Null,
				IonSource -> Null
			],
			$Failed,
			Messages:>{Error::DetectorOptionsRequired,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[
			{Messages, "GCGasSaverConflict","GasSaverFlowRate and GasSaverActivationTime must be specified if and only if GasSaver is True, otherwise an error will be thrown:"},
			ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				GasSaver -> True,
				GasSaverFlowRate -> Null,
				GasSaverActivationTime -> Null
			],
			$Failed,
			Messages:>{Error::GCGasSaverConflict,Error::InvalidOption},
			TimeConstraint -> 300
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the amount of an input Model[Sample] and the container in which it is to be prepared:"},
			options = ExperimentGCMS[
				{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container, Vessel, "2 mL clear glass GC vial"],
				PreparedModelAmount -> 1 Milliliter,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				{ObjectP[Model[Container, Vessel, "id:AEqRl9KmRnj1"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "A1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[
			{Options,Instrument,"Specify the gas chromatograph used to separate analytes in a sample in the gas phase during this experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Instrument->Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"],
				Output -> Options];
			Lookup[options,Instrument],
			Model[Instrument, GasChromatograph, "Agilent 8890 GCMS"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,CarrierGas,"Specify the gas to be used to push the vaporized analytes through the column during chromatographic separation of the samples injected into the GC:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				CarrierGas->Helium,
				Output -> Options];
			Lookup[options,CarrierGas],
			Helium,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Inlet,"Specify the instrument hardware into which the samples to be analyzed will be injected, and where those samples will be subsequently vaporized and pushed onto the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Inlet->Multimode,
				Output -> Options];
			Lookup[options,Inlet],
			Multimode,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletLiner,"Specify the glass insert into which the sample is injected, which will be installed in the inlet during this experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InletLiner->Model[Item, GCInletLiner, "id:XnlV5jKAYJZP"],
				Output -> Options];
			Lookup[options,InletLiner],
			ObjectP[Model[Item, GCInletLiner, "id:XnlV5jKAYJZP"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LinerORing,"Specify a compressible ring that forms a seal separating the inlet volume from the septum purge volume in the inlet, to be installed in the inlet during this experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LinerORing->Model[Item, ORing, "id:01G6nvwpLBZE"],
				Output -> Options];
			Lookup[options,LinerORing],
			Model[Item, ORing, "id:01G6nvwpLBZE"],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletSeptum,"Specify the barrier that the injection syringe will penetrate to inject the sample into the inlet, to be installed in the inlet during this experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InletSeptum->Model[Item, Septum, "id:XnlV5jKAYJZ8"],
				Output -> Options];
			Lookup[options,InletSeptum],
			Model[Item, Septum, "id:XnlV5jKAYJZ8"],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Column,"Specify the capillary tube(s) in which analytes in an injected sample are separated, in their order of installation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Column->Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"],
				Output -> Options];
			Lookup[options,Column],
			ObjectP[Model[Item, Column, "HP-5ms Ultra Inert, 30 m, 0.25 mm ID, 0.25 \[Mu]m film thickness, 7 inch cage"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TrimColumn,"Specify whether or not a length of the inlet end of the column will be removed, typically to remove suspected contamination from the column inlet if column performance begins to degrade. Trimming can be performed less frequently if a guard column is used:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TrimColumn->False,
				Output -> Options];
			Lookup[options,TrimColumn],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TrimColumnLength,"Specify the length of the inlet end of the column to remove prior to installation of the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TrimColumn->True,
				TrimColumnLength->10*Centimeter,
				Output -> Options];
			Lookup[options,TrimColumnLength],
			10*Centimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConditionColumn,"Specify whether or not the column will be conditioned prior to the separation of samples:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ConditionColumn->True,
				Output -> Options];
			Lookup[options,ConditionColumn],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnConditioningGas,"Specify the carrier gas used to purge the column(s) during the column conditioning step, which occurs when the column is installed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnConditioningGas->Helium,
				Output -> Options];
			Lookup[options,ColumnConditioningGas],
			Helium,
			Variables:>{options}
		],
		(*Example[
			{Options,ColumnConditioningGasFlowRate,"Specify the flow rate of carrier gas used to purge the column(s) during the column conditioning step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnConditioningGasFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,ColumnConditioningGasFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],*)
		Example[
			{Options,ColumnConditioningTime,"Specify the time for which the column will be purged by the column conditioning gas prior to separation of standards and samples in the column during the experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTime->30*Minute,
				Output -> Options];
			Lookup[options,ColumnConditioningTime],
			30*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnConditioningTemperature,"Specify the temperature at which the column will be conditioned prior to separation of standards and samples in the column during the experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTemperature->280*Celsius,
				Output -> Options];
			Lookup[options,ColumnConditioningTemperature],
			280*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidInjectionSyringe,"Specify the syringe that will be used to inject liquid samples onto the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Model[Container, Syringe, "id:dORYzZJxRqER"],
				Output -> Options];
			Lookup[options,LiquidInjectionSyringe],
			ObjectP[Model[Container, Syringe, "id:dORYzZJxRqER"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceInjectionSyringe,"Specify the syringe that will be used to inject headspace samples onto the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspaceInjectionSyringe->Model[Container, Syringe, "id:4pO6dM50O14B"],
				Output -> Options];
			Lookup[options,HeadspaceInjectionSyringe],
			ObjectP[Model[Container, Syringe, "id:4pO6dM50O14B"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,SPMEInjectionFiber,"Specify the Solid Phase MicroExtraction (SPME) fiber that will be used to inject samples onto the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEInjectionFiber->Model[Item, SPMEFiber, "id:54n6evLR3kLG"],
				Output -> Options];
			Lookup[options,SPMEInjectionFiber],
			ObjectP[Model[Item, SPMEFiber, "id:54n6evLR3kLG"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,LiquidHandlingSyringe,"Specify the syringe that will be installed into the liquid handling tool on the autosampler deck:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidHandlingSyringe->Model[Container, Syringe, "id:XnlV5jKMl64P"],
				Output -> Options];
			Lookup[options,LiquidHandlingSyringe],
			ObjectP[Model[Container, Syringe, "id:XnlV5jKMl64P"]],
			Variables:>{options},
			TimeConstraint -> 300,
			Messages:>{Warning::UnneededSyringeComponent}
		],
		Example[
			{Options,DilutionSolvent,"Specify Dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				DilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,DilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondaryDilutionSolvent,"Specify Secondary dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SecondaryDilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SecondaryDilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiaryDilutionSolvent,"Specify Tertiary dilution solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TertiaryDilutionSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,TertiaryDilutionSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Dilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Dilute->False,
				Output -> Options];
			Lookup[options,Dilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,DilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				DilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,DilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,SecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,TertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Agitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Agitate->False,
				Output -> Options];
			Lookup[options,Agitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,AgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,AgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,AgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,AgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				AgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,AgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Vortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Vortex->True,
				Output -> Options];
			Lookup[options,Vortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,VortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				VortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,VortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,VortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				VortexTime->30*Second,
				Output -> Options];
			Lookup[options,VortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,SamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,HeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SyringeWashSolvent,"Specify Syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SecondarySyringeWashSolvent,"Specify Secondary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SecondarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SecondarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TertiarySyringeWashSolvent,"Specify Tertiary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TertiarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,TertiarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,QuaternarySyringeWashSolvent,"Specify Quaternary syringe wash solvent to be available for dilution/sample modification procedures:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				QuaternarySyringeWashSolvent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,QuaternarySyringeWashSolvent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,LiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,NumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				NumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,NumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,LiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,LiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,HeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,HeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMECondition->True,
				Output -> Options];
			Lookup[options,SPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,SPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,SPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,SPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,SPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,SPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEDerivatizationPositionOffset,"Specify the distance from the SPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				SPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,SPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,AgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,SampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,SampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,SampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,InjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,LiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,SampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,SampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,SPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,InjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,InjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,InjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,PreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,SampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,SPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,PostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,LiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,LiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,LiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,PostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,HeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,HeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,SPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				Output -> Options];
			Lookup[options,SeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one InitialColumnFlowRate that matches with the SeparationMethod and one that differs from the SeparationMethod:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				InitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,InitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one BlankInitialColumnFlowRate that matches with the BlankSeparationMethod and one that differs from the BlankSeparationMethod:"},
			options=ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				BlankSeparationMethod -> Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				BlankInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,BlankInitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one StandardInitialColumnFlowRate that matches with the StandardSeparationMethod and one that differs from the StandardSeparationMethod:"},
			options=ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				StandardSeparationMethod -> Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				StandardInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options,StandardInitialColumnFlowRate],
			{1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one InitialColumnFlowRate that matches with the SeparationMethod and one that differs and check if the InitialColumnAverageVelocity,InitialColumnPressure,and InitialColumnResidenceTime are recalculated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				SeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				InitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {InitialColumnAverageVelocity,InitialColumnPressure,InitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				Standard -> Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				StandardSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				StandardInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {StandardInitialColumnAverageVelocity,StandardInitialColumnPressure,StandardInitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,SeparationMethod,"Specify one BlankInitialColumnFlowRate that matches with the BlankSeparationMethod and one that differs and check if the BlankInitialColumnAverageVelocity,BlankInitialColumnPressure,and BlankInitialColumnResidenceTime are recalculated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				Blank -> Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				BlankSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				BlankInitialColumnFlowRate -> {1.7 Milliliter/Minute, 1.5 Milliliter/Minute},
				Output -> Options];
			Lookup[options, {BlankInitialColumnAverageVelocity,BlankInitialColumnPressure,BlankInitialColumnResidenceTime}],
			{{Quantity[37.32`,("Centimeters")/("Seconds")],Quantity[34.21`,("Centimeters")/("Seconds")]},{Quantity[17.968`,("PoundsForce")/("Inches")^2],Quantity[16.388`,("PoundsForce")/("Inches")^2]},{Quantity[1.34`,"Minutes"],Quantity[1.46`,"Minutes"]}},
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,InitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,InletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,InletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SplitRatio->10,
				Output -> Options];
			Lookup[options,SplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,SplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,SplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,InitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,InitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				GasSaver->True,
				Output -> Options];
			Lookup[options,GasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				GasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,GasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,GasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				GasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,GasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,SolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnFlowRate,"Specify the initial column gas flow rate setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,InitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,InitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,InitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnResidenceTime,"Specify the initial column residence time setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,InitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,ColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,ColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,OvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				OvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,OvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,InitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,InitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,OvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				OvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,OvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,PostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,PostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunFlowRate,"Specify the column flow rate setpoint at the end of the sample separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,PostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunFlowRate,"Specify the column flow rate setpoint at the end of the standard separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,StandardPostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunFlowRate,"Specify the column flow rate setpoint at the end of the blank separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostRunFlowRate->2*Milliliter/Minute,
				Output -> Options];
			Lookup[options,BlankPostRunFlowRate],
			2*Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,PostRunPressure,"Specify the column pressure setpoint at the end of the sample separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				PostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,PostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunPressure,"Specify the column pressure setpoint at the end of the standard separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,StandardPostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunPressure,"Specify the column pressure setpoint at the end of the blank separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostRunPressure->2*PSI,
				Output -> Options];
			Lookup[options,BlankPostRunPressure],
			2*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TransferLineTemperature,"Specify the temperature at which the segment of column the extends out of the column oven and into the mass spectrometer is held:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TransferLineTemperature->275*Celsius,
				Output -> Options];
			Lookup[options,TransferLineTemperature],
			275*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IonSource,"Specify the type of charged particle used to ionize the separated analytes inside the mass spectrometer. A beam of electrons (ElectronIonization) or charged methane gas (ChemicalIonization) may be used:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IonSource->ElectronIonization,
				Output -> Options];
			Lookup[options,IonSource],
			ElectronIonization,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IonMode,"Specify whether positively or negatively charged molecular fragments will be analyzed by the mass spectrometer:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IonMode->Positive,
				Output -> Options];
			Lookup[options,IonMode],
			Positive,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SourceTemperature,"Specify the temperature at which the ionization source, where the sample is ionized inside the mass spectrometer, is held:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SourceTemperature->230*Celsius,
				Output -> Options];
			Lookup[options,SourceTemperature],
			230*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,QuadrupoleTemperature,"Specify the temperature at which the parallel metal rods, which select the mass of ion to be analyzed inside the mass spectrometer, are held:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				QuadrupoleTemperature->150*Celsius,
				Output -> Options];
			Lookup[options,QuadrupoleTemperature],
			150*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SolventDelay,"Specify the amount of time into the separation after which the mass spectrometer will turn on its controlling voltages. This time should be set to a point in the separation after which the main solvent peak from the separation has already entered and exited the mass spectrometer to avoid damaging the filament:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SolventDelay->3*Minute,
				Output -> Options];
			Lookup[options,SolventDelay],
			3*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassDetectionGain,"Specify the linear signal amplification factor applied to the ions detected in the mass spectrometer. A gain factor of 1.0 indicates a signal multiplication of 100,000 by the detector. Higher gain factors raise the signal sensitivity but can also cause a nonlinear detector response at higher ion abundances. It is recommended that the lowest possible gain that allows achieving the desired detection limits be used to avoid damaging the electron multiplier:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassDetectionGain->2,
				Output -> Options];
			Lookup[options,MassDetectionGain],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AcquisitionWindowStartTime,"Specify the amount of time into the separation after which the mass spectrometer will begin collecting data over the specified MassRange:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AcquisitionWindowStartTime->{4*Minute},
				Output -> Options];
			Lookup[options,AcquisitionWindowStartTime],
			{4*Minute},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TraceIonDetection,"Specify whether a set of proprietary algorithms will be used to enhance the detection of trace levels of ion abundance during mass spectral data collection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TraceIonDetection->True,
				Output -> Options];
			Lookup[options,TraceIonDetection],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRangeThreshold,"Specify the threshold below which ion abundance data will not be recorded:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassRangeThreshold->250,
				Output -> Options];
			Lookup[options,MassRangeThreshold],
			250,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRange,"Specify the lowest and the highest mass-to-charge ratio (m/z) to be recorded during analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassRange->{50,250},
				Output -> Options];
			Lookup[options,MassRange],
			{50,250},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassRangeScanSpeed,"Specify the speed (in m/z per second) at which the mass spectrometer will collect data:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassRangeScanSpeed->10000,
				Output -> Options];
			Lookup[options,MassRangeScanSpeed],
			10000,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelection,"Specify the mass-to-charge ratios (m/z) and the time for which data will be collected at each m/z during measurement with the mass spectrometer:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassSelection->{{51,100*Milli*Second},{53,100*Milli*Second}},
				Output -> Options];
			Lookup[options,MassSelection],
			{{51,100*Milli*Second},{53,100*Milli*Second}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelectionResolution,"Specify the m/z range window that may be transmitted through the quadrupole at the selected mass. Low resolution will allow a larger range of masses through the quadrupole and increase sensitivity and repeatability, but is not ideal for comparing adjacent m/z values as there may be some overlap in the measured abundances:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassSelectionResolution->Low,
				Output -> Options];
			Lookup[options,MassSelectionResolution],
			Low,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MassSelectionDetectionGain,"Specify the gain factor that will be used during the collection of the corresponding selectively monitored m/z value(s) in MassSelection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MassSelectionDetectionGain->2,
				Output -> Options];
			Lookup[options,MassSelectionDetectionGain],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,NumberOfReplicates,"Specify the number of identical replicates to run using the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				NumberOfReplicates->3,
				Output -> Options];
			Lookup[options,NumberOfReplicates],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Standard,"Specify a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Standard->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,Standard],
			Model[Sample,"Hexanes"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVial,"Specify the container in which to prepare a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardVial->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options];
			Lookup[options,StandardVial],
			Model[Container, Vessel, "2 mL clear glass GC vial"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAmount,"Specify the amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardAmount->1.5*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardAmount],
			1.5*Milli*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardDilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardDilute->False,
				Output -> Options];
			Lookup[options,StandardDilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardDilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardSecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardTertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardTertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,StandardTertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardAgitate->False,
				Output -> Options];
			Lookup[options,StandardAgitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,StandardAgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,StandardAgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,StandardAgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,StandardAgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->HeadspaceInjection,
				StandardAgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,StandardAgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardVortex->True,
				Output -> Options];
			Lookup[options,StandardVortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardVortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,StandardVortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardVortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardVortexTime->30*Second,
				Output -> Options];
			Lookup[options,StandardVortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,StandardSamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardHeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,StandardHeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardNumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardNumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,StandardNumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,StandardLiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,StandardLiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardHeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,StandardHeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardHeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,StandardHeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMECondition->True,
				Output -> Options];
			Lookup[options,StandardSPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,StandardSPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEDerivatizationPositionOffset,"Specify the distance from the StandardSPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				StandardSPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,StandardSPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardAgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardAgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,StandardAgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,StandardSampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,StandardSampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,StandardSampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,StandardInjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,StandardLiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardSampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,StandardSampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,StandardSPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,StandardInjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,StandardInjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,StandardInjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,StandardPreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardSampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,StandardSPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,StandardPostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardLiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardLiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,StandardLiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,StandardPostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardHeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardHeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,StandardHeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,StandardSPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				Output -> Options];
			Lookup[options,StandardSeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,StandardInitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,StandardInletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardInletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSplitRatio->10,
				Output -> Options];
			Lookup[options,StandardSplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardSplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardSplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,StandardInitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardGasSaver->True,
				Output -> Options];
			Lookup[options,StandardGasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardGasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardGasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardGasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardGasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,StandardGasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardSolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardSolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardSolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnFlowRate,"Specify the initial column gas flow rate setpoint for a Standard:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint for a Standard:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,StandardInitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint for the Standard:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,StandardInitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnResidenceTime,"Specify the initial column residence time setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,StandardColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,StandardColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardOvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardOvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardOvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,StandardInitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardInitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardInitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,StandardInitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardOvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardOvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,StandardOvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,StandardPostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardPostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardPostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,StandardPostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,StandardFrequency,"Specify Specify the frequency at which Standard measurements will be inserted among samples:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				StandardFrequency->First,
				Output -> Options];
			Lookup[options,StandardFrequency],
			First,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Blank,"Specify the injection method to use for a blank run as a negative control, wherein either no injection is made or a cleaned syringe is used to pierce the inlet septum in the manner of a typical injection but no sample volume is injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Blank->NoInjection,
				Output -> Options];
			Lookup[options,Blank],
			NoInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVial,"Specify the container in which to prepare a reference compound to inject into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankVial->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options];
			Lookup[options,BlankVial],
			Model[Container, Vessel, "2 mL clear glass GC vial"][Object],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAmount,"Specify the amount of a reference compound to prepare in a vial for subsequent injection into the instrument, often used for quantification or to check internal measurement consistency:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankAmount->1.5*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankAmount],
			1.5*Milli*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankDilute,"Specify whether or not the sample will be diluted prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankDilute->False,
				Output -> Options];
			Lookup[options,BlankDilute],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankDilutionSolventVolume,"Specify the volume to move from the DilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSecondaryDilutionSolventVolume,"Specify the volume to move from the SecondaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSecondaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankSecondaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankTertiaryDilutionSolventVolume,"Specify the volume to move from the TertiaryDilutionSolvent vial into the sample vial:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankTertiaryDilutionSolventVolume->0.1*Milli*Liter,
				Output -> Options];
			Lookup[options,BlankTertiaryDilutionSolventVolume],
			0.1*Milli*Liter,
			Messages:>{Warning::AutomaticallySelectedDilutionSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitate,"Specify whether or not the sample will be mixed by swirling the container for a specified time at a specified rotational speed and temperature prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankAgitate->False,
				Output -> Options];
			Lookup[options,BlankAgitate],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationTime,"Specify the time that each sample will be incubated in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationTime->5*Minute,
				Output -> Options];
			Lookup[options,BlankAgitationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationTemperature,"Specify the temperature at which each sample will be incubated at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationTemperature->100*Celsius,
				Output -> Options];
			Lookup[options,BlankAgitationTemperature],
			100*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationMixRate,"Specify the rate (in RPM) at which each sample will be swirled at in the agitator prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationMixRate->500*RPM,
				Output -> Options];
			Lookup[options,BlankAgitationMixRate],
			500*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationOnTime,"Specify the amount of time for which the agitator will swirl before switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationOnTime->3*Second,
				Output -> Options];
			Lookup[options,BlankAgitationOnTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitationOffTime,"Specify the amount of time for which the agitator will idle while switching directions:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->HeadspaceInjection,
				BlankAgitationOffTime->3*Second,
				Output -> Options];
			Lookup[options,BlankAgitationOffTime],
			3*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortex,"Specify whether or not the sample will be spun in place (vortexed) prior to sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankVortex->True,
				Output -> Options];
			Lookup[options,BlankVortex],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortexMixRate,"Specify the rate (in RPM) at which the sample will be vortexed in the vortex mixer prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankVortexMixRate->1000*RPM,
				Output -> Options];
			Lookup[options,BlankVortexMixRate],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankVortexTime,"Specify the amount of time for which the sample will be vortex mixed prior to analysis:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankVortexTime->30*Second,
				Output -> Options];
			Lookup[options,BlankVortexTime],
			30*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSamplingMethod,"Specify the sampling method that will be used to extract a mixture of analytes from the sample vial and inject those analytes into the injection port:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSamplingMethod->LiquidInjection,
				Output -> Options];
			Lookup[options,BlankSamplingMethod],
			LiquidInjection,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspaceSyringeTemperature,"Specify the temperature that the headspace syringe will be held at during the sampling task:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankHeadspaceSyringeTemperature->75*Celsius,
				Output -> Options];
			Lookup[options,BlankHeadspaceSyringeTemperature],
			75*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present prior to sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each pre-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionSyringeWashRate->30*Micro*Liter/Second,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionSyringeWashRate],
			30*Micro*Liter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfSolventWashes,"Specify the number of washes to perform using WashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfSolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using SecondaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfSecondarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using TertiaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfTertiarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPreInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using QuaternaryWashSolvent during the pre-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPreInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPreInjectionNumberOfQuaternarySolventWashes],
			3,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankNumberOfLiquidSampleWashes,"Specify the number of washes to perform on the injection syringe using the sample during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankNumberOfLiquidSampleWashes->3,
				Output -> Options];
			Lookup[options,BlankNumberOfLiquidSampleWashes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleWashVolume,"Specify the volume of the sample that will be used to rinse the syringe during the pre-injection sample washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleWashVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleFillingStrokes,"Specify the number of filling strokes to perform when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleFillingStrokes->3,
				Output -> Options];
			Lookup[options,BlankLiquidSampleFillingStrokes],
			3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleFillingStrokesVolume,"Specify the volume of the filling strokes to draw when drawing a sample for injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleFillingStrokesVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleFillingStrokesVolume],
			2*Micro*Liter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidFillingStrokeDelay,"Specify the amount of time the injection tool will idle between filling strokes:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidFillingStrokeDelay->0.5*Second,
				Output -> Options];
			Lookup[options,BlankLiquidFillingStrokeDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspaceSyringeFlushing,"Specify whether the headspace tool will continuously flush the syringe with Helium during the experiment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankHeadspaceSyringeFlushing->Continuous,
				Output -> Options];
			Lookup[options,BlankHeadspaceSyringeFlushing],
			Continuous,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspacePreInjectionFlushTime,"Specify the amount of time the headspace tool will flow Helium through the injection syringe (thus purging the syringe environment) before drawing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankHeadspacePreInjectionFlushTime->5*Second,
				Output -> Options];
			Lookup[options,BlankHeadspacePreInjectionFlushTime],
			5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMECondition,"Specify whether or not the Solid Phase MicroExtraction (SPME) tool will be conditioned prior to sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMECondition->True,
				Output -> Options];
			Lookup[options,BlankSPMECondition],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEConditioningTemperature,"Specify the temperature at which the Solid Phase MicroExtraction (SPME) fiber will be treated in flowing Helium prior to exposure to the sample environment:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEConditioningTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,BlankSPMEConditioningTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEPreConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEPreConditioningTime->20*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEPreConditioningTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizingAgent,"Specify the on-fiber derivatizing agent to be used to modify the sample during sample adsorption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizingAgent],
			ObjectP[Model[Sample,"Hexanes"][Object]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizingAgentAdsorptionTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will adsorb the derivatizing agent before adsorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizingAgentAdsorptionTime->20*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizingAgentAdsorptionTime],
			20*Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizationPosition,"Specify the position in the vial (Top or Bottom) at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizationPosition->Top,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEDerivatizationPositionOffset,"Specify the distance from the BlankSPMEDerivatizationPosition at which the Solid Phase MicroExtraction (SPME) fiber will be treated with the derivatizing agent during fiber preparation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEDerivatizingAgent->Model[Sample,"Hexanes"],
				BlankSPMEDerivatizationPositionOffset->20*Milli*Meter,
				Output -> Options];
			Lookup[options,BlankSPMEDerivatizationPositionOffset],
			20*Milli*Meter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankAgitateWhileSampling,"Specify that the headspace sample will be drawn while the sample is being agitated at the specified AgitationTemperature, AgitationRate, ..:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankAgitateWhileSampling->True,
				Output -> Options];
			Lookup[options,BlankAgitateWhileSampling],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialAspirationPosition,"Specify the position in the vial (Top or Bottom) from which the sample will be aspirated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleVialAspirationPosition->Top,
				Output -> Options];
			Lookup[options,BlankSampleVialAspirationPosition],
			Top,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialAspirationPositionOffset,"Specify the distance of the tip of the injection syringe from the top or bottom of the sample vial (set by SampleVialAspirationPosition) during sample aspiration:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleVialAspirationPositionOffset->20*Millimeter,
				Output -> Options];
			Lookup[options,BlankSampleVialAspirationPositionOffset],
			20*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleVialPenetrationRate,"Specify the speed that the injection tool will penetrate the sample vial septum during sampling:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleVialPenetrationRate->25*Millimeter/Second,
				Output -> Options];
			Lookup[options,BlankSampleVialPenetrationRate],
			25*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionVolume,"Specify the volume of sample to draw into the liquid or headspace tool sample syringe for introduction of the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInjectionVolume->2*Microliter,
				Output -> Options];
			Lookup[options,BlankInjectionVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidSampleOverAspirationVolume,"Specify the volume of air to draw into the liquid sample syringe after aspirating the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidSampleOverAspirationVolume->2*Microliter,
				Output -> Options];
			Lookup[options,BlankLiquidSampleOverAspirationVolume],
			2*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleAspirationRate,"Specify the volumetric rate at which the sample will be drawn during the sampling procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleAspirationRate->1*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankSampleAspirationRate],
			1*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleAspirationDelay,"Specify the amount of time the injection tool will idle after aspirating the sample to allow the pressures in the sample vial and syringe to equilibrate:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleAspirationDelay->0.5*Second,
				Output -> Options];
			Lookup[options,BlankSampleAspirationDelay],
			0.5*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMESampleExtractionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber in contact with the sample for adsorption of analytes onto the SPME fiber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMESampleExtractionTime->10*Minute,
				Output -> Options];
			Lookup[options,BlankSPMESampleExtractionTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionInletPenetrationDepth,"Specify the distance through the inlet septum that the injection tool will position the injection syringe tip during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInjectionInletPenetrationDepth->50*Millimeter,
				Output -> Options];
			Lookup[options,BlankInjectionInletPenetrationDepth],
			50*Millimeter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionInletPenetrationRate,"Specify the speed that the injection tool will penetrate the inlet septum during injection of the sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInjectionInletPenetrationRate->74*Millimeter/Second,
				Output -> Options];
			Lookup[options,BlankInjectionInletPenetrationRate],
			74*Millimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInjectionSignalMode,"Specify whether the instrument will start the run clock before or after the sample has been introduced into the vaporization chamber of the inlet (while the syringe has already been inserted into the inlet) during the injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInjectionSignalMode->PlungerDown,
				Output -> Options];
			Lookup[options,BlankInjectionSignalMode],
			PlungerDown,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPreInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet before the plunger is depressed and the sample is introduced into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPreInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,BlankPreInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSampleInjectionRate,"Specify the injection rate that will be used to dispense a fluid sample into the inlet during the sample injection procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSampleInjectionRate->20*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankSampleInjectionRate],
			20*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMESampleDesorptionTime,"Specify the amount of time the injection tool will leave the Solid Phase MicroExtraction (SPME) fiber exposed in the inlet vaporization chamber:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMESampleDesorptionTime->0.2*Minute,
				Output -> Options];
			Lookup[options,BlankSPMESampleDesorptionTime],
			0.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostInjectionTimeDelay,"Specify the amount of time the syringe will be held in the inlet after the plunger has been completely depressed and before it is withdrawn from the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostInjectionTimeDelay->1*Second,
				Output -> Options];
			Lookup[options,BlankPostInjectionTimeDelay],
			1*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWash,"Specify whether the instrument will rinse the liquid injection syringe with any of the syringe wash solvents in an attempt to remove any impurities present after sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWash->True,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWash],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWashVolume,"Specify the volume of the injection syringe to fill with wash solvent during each post-injection syringe washing step:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWashVolume->2*Micro*Liter,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWashVolume],
			2*Micro*Liter,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionSyringeWashRate,"Specify the aspiration rate that will be used to draw and dispense liquid during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionSyringeWashRate->10*Microliter/Second,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionSyringeWashRate],
			10*Microliter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfSolventWashes,"Specify the number of washes to perform using the syringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfSolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfSolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfSecondarySolventWashes,"Specify the number of washes to perform using the SecondarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfSecondarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfSecondarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfTertiarySolventWashes,"Specify the number of washes to perform using the TertiarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfTertiarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfTertiarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankLiquidPostInjectionNumberOfQuaternarySolventWashes,"Specify the number of washes to perform using the QuaternarySyringeWashSolvent during the post-injection syringe washing procedure:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankLiquidPostInjectionNumberOfQuaternarySolventWashes->3,
				Output -> Options];
			Lookup[options,BlankLiquidPostInjectionNumberOfQuaternarySolventWashes],
			3,
			EquivalenceFunction->Equal,
			Messages:>{Warning::AutomaticallySelectedWashSolvent},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostInjectionNextSamplePreparationSteps,"Specify the sample preparation step up to which the autosampling arm will proceed (as described in Figure X) to prepare to inject the next sample in the injection sequence prior to the completion of the separation of the sample that has just been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostInjectionNextSamplePreparationSteps->NoSteps,
				Output -> Options];
			Lookup[options,BlankPostInjectionNextSamplePreparationSteps],
			NoSteps,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankHeadspacePostInjectionFlushTime,"Specify the amount of time the headspace tool will flow helium through the injection syringe (thus purging the syringe environment) after injecting a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankHeadspacePostInjectionFlushTime->10*Second,
				Output -> Options];
			Lookup[options,BlankHeadspacePostInjectionFlushTime],
			10*Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSPMEPostInjectionConditioningTime,"Specify the amount of time the Solid Phase MicroExtraction (SPME) tool will be conditioned after desorbing a sample:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSPMEPostInjectionConditioningTime->10*Minute,
				Output -> Options];
			Lookup[options,BlankSPMEPostInjectionConditioningTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSeparationMethod,"Specify a collection of inlet, column, and oven parameters that will be used to perform the chromatographic separation after the sample has been injected:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSeparationMethod->Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				Output -> Options];
			Lookup[options,BlankSeparationMethod],
			_Association,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTemperature,"Specify the desired inlet temperature when the InletTemperatureMode is Isothermal, or the temperature at which the InletTemperatureProfile will begin if the InletTemperature is TemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTemperature->250*Celsius,
				Output -> Options];
			Lookup[options,BlankInitialInletTemperature],
			250*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTemperatureDuration,"Specify the amount of time into the separation to hold the Inlet at its InitialInletTemperature before starting the InletTemperatureProfile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialInletTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInletTemperatureProfile,"Specify the ramp rate, temperature set point, and set point hold time that will be applied to the inlet during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInletTemperatureProfile->{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
				Output -> Options];
			Lookup[options,BlankInletTemperatureProfile],
			{{0*Minute,100*Celsius},{2*Minute,200*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInletSeptumPurgeFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet septum purge valve, which will continuously flush the volume inside the inlet between the inlet septum and the inlet liner:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInletSeptumPurgeFlowRate->2*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankInletSeptumPurgeFlowRate],
			2*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitRatio,"Specify the ratio of flow rate out of the inlet vaporization chamber that passes into the inlet split vent to the flow rate out of the inlet vaporization chamber that passes into the capillary column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSplitRatio->10,
				Output -> Options];
			Lookup[options,BlankSplitRatio],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitVentFlowRate,"Specify the desired flow rate through the inlet that will exit the inlet through the inlet split vent during sample injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSplitVentFlowRate->50*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankSplitVentFlowRate],
			50*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSplitlessTime,"Specify the amount of time the split valve will remain closed after injecting the sample into the inlet:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSplitlessTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankSplitlessTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletPressure,"Specify the desired pressure (in psi gauge pressure) that will be held in the inlet at the beginning of the separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialInletPressure->15*PSI,
				Output -> Options];
			Lookup[options,BlankInitialInletPressure],
			15*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialInletTime,"Specify the time after which the column head pressure will be returned from the InitialInletPressure to the column setpoint following a pulsed injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialInletTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialInletTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaver,"Specify whether the gas saver will be used during the experiment. The gas saver reduces flow through the split vent during sample separation, reducing Helium consumption:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankGasSaver->True,
				Output -> Options];
			Lookup[options,BlankGasSaver],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaverFlowRate,"Specify the desired gas flow rate that the total inlet flow will be reduced to when the gas saver is activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankGasSaverFlowRate->25*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankGasSaverFlowRate],
			25*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankGasSaverActivationTime,"Specify the amount of time after the beginning of each run that the gas saver will be activated:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankGasSaverActivationTime->5*Minute,
				Output -> Options];
			Lookup[options,BlankGasSaverActivationTime],
			5*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankSolventEliminationFlowRate,"Specify the flow rate of carrier gas that will be passed through the inlet and out the split vent in an attempt to selectively remove solvent from the inlet during a solvent vented injection:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankSolventEliminationFlowRate->10*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankSolventEliminationFlowRate],
			10*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnFlowRate,"Specify the initial column gas flow rate setpoint for a Blank:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnFlowRate->1.5*Milli*Liter/Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnFlowRate],
			1.5*Milli*Liter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnPressure,"Specify the initial column pressure (in PSI gauge pressure) setpoint for a Blank:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnPressure->12*PSI,
				Output -> Options];
			Lookup[options,BlankInitialColumnPressure],
			12*PSI,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnAverageVelocity,"Specify the initial column average linear gas velocity setpoint for the Blank:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnAverageVelocity->40*Centimeter/Second,
				Output -> Options];
			Lookup[options,BlankInitialColumnAverageVelocity],
			40*Centimeter/Second,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnResidenceTime,"Specify the initial column residence time setpoint:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnResidenceTime->1.2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnResidenceTime],
			1.2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialColumnSetpointDuration,"Specify the amount of time into the method to hold the column at a specified inlet pressure or flow rate before starting a pressure or flow rate profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialColumnSetpointDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialColumnSetpointDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankColumnPressureProfile,"Specify the pressure ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankColumnPressureProfile->ConstantPressure,
				Output -> Options];
			Lookup[options,BlankColumnPressureProfile],
			ConstantPressure,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankColumnFlowRateProfile,"Specify the flow rate ramping profile for the inlet that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankColumnFlowRateProfile->ConstantFlowRate,
				Output -> Options];
			Lookup[options,BlankColumnFlowRateProfile],
			ConstantFlowRate,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankOvenEquilibrationTime,"Specify the duration of time for which the initial OvenTemperature will be held before allowing the instrument to begin the next separation:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankOvenEquilibrationTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankOvenEquilibrationTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialOvenTemperature,"Specify the desired column oven temperature setpoint prior to the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,BlankInitialOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankInitialOvenTemperatureDuration,"Specify the amount of time into the separation to hold the column oven at its OvenInitialTemperature before starting the column oven temperature Profile:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankInitialOvenTemperatureDuration->2*Minute,
				Output -> Options];
			Lookup[options,BlankInitialOvenTemperatureDuration],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankOvenTemperatureProfile,"Specify the temperature profile for the column oven that will be run during sample separation in the column:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankOvenTemperatureProfile->{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
				Output -> Options];
			Lookup[options,BlankOvenTemperatureProfile],
			{{0*Minute,50*Celsius},{10*Minute,250*Celsius},{12*Minute,250*Celsius}},
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunOvenTemperature,"Specify the column oven set point temperature at the end of the sample separation once the run is completed:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostRunOvenTemperature->50*Celsius,
				Output -> Options];
			Lookup[options,BlankPostRunOvenTemperature],
			50*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankPostRunOvenTime,"Specify the amount of time to hold the column oven at its post-run setpoint temperature:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankPostRunOvenTime->2*Minute,
				Output -> Options];
			Lookup[options,BlankPostRunOvenTime],
			2*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BlankFrequency,"Specify Specify the frequency at which Blank measurements will be inserted among samples:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				BlankFrequency->First,
				Output -> Options];
			Lookup[options,BlankFrequency],
			First,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionTable,"Specify the order of Sample, Standard, and Blank sample loading into the Instrument during measurement:"},
			options=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID]},
				InjectionTable->{
					{Standard, Model[Sample, "Hexanes"], LiquidInjection, {StandardVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], LiquidInjection, {VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], LiquidInjection, {VortexMixRate -> 500*RPM}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]},
					{Blank, Model[Sample, "Hexanes"], LiquidInjection, {BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"], VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]},
					{Blank, Null, Null, {}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]}
				},
				Output -> Options];
			Lookup[options,InjectionTable],
			_List,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,InjectionTable,"Specify the order of Sample (only) loading into the Instrument without any Standard or Blank:"},
			options=ExperimentGasChromatography[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID]},
				InjectionTable->{
					{Sample, Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], LiquidInjection, {VortexTime -> 5*Second}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]},
					{Sample, Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], LiquidInjection, {VortexMixRate -> 500*RPM}, Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID]}
				},
				Output -> Options];
			Lookup[options,InjectionTable],
			_List,
			Variables:>{options},
			Messages:>{Warning::OverwritingSeparationMethod},
			TimeConstraint -> 300
		],
		Example[
			{Options,Template,"Specify a template protocol whose methodology should be reproduced in running this experiment:"},
			protocol=ExperimentGCMS[{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},Template->Null];
			Download[protocol,Template],
			Null,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,Name,"Specify a name which should be used to refer to the output object in lieu of an automatically generated ID number:"},
			protocol=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Name->"My particular ExperimentGCMS protocol" <> $SessionUUID
			];
			Download[protocol,Name],
			"My particular ExperimentGCMS protocol" <> $SessionUUID,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,Upload,"Specify if the database changes resulting from this function should be made immediately or if upload packets should be returned:"},
			packets=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Upload->False
			],
			{PacketP[Object[Protocol,GasChromatography]],___},
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,PreparatoryUnitOperations,"Specify a sequence of transferring, aliquoting, consolidating, or mixing of new or existing samples before the main experiment. These prepared samples can be used in the main experiment by referencing their defined name. For more information, please reference the documentation for ExperimentSamplePreparation:"},
			protocol=ExperimentGCMS["My prepared sample",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label -> "My prepared container",
						Container -> Model[Container, Vessel, "1L Glass Bottle"]
					],
					Transfer[
						Source -> Model[Sample, "Methanol - LCMS grade"],
						Destination -> "My prepared container",
						Amount -> 499 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Heptafluorobutyric acid"],
						Destination -> "My prepared container",
						Amount -> 1 Milliliter
					],
					LabelSample[
						Label -> "My prepared sample",
						Sample -> {"A1", "My prepared container"}
					]
				}
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Variables:>{protocol},
			Messages:>{Warning::RoundedTransferAmount,Warning::AliquotRequired},
			TimeConstraint -> 600
		],

		(*all the sample prep stuff*)
		Example[
			{Options,Incubate,"Specify if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationTemperature,"Specify the temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IncubationTemperature->40 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationTime,"Specify duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IncubationTime->40 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			40 Minute,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,Mix,"Specify the samples should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MixType,"Specify the style of motion used to mix the samples, prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MixType->Vortex,
				Output->Options
			];
			Lookup[options,MixType],
			Vortex,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MixUntilDissolved,"Specify if the samples should be mixed in an attempt dissolve any solute prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MaxIncubationTime,"Specify Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen. This occurs prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MaxIncubationTime->1 Hour,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			1 Hour,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubationInstrument,"Specify the instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IncubationInstrument->Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AnnealingTime,"Specify minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AnnealingTime->20 Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			20 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquotContainer,"Specify the container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				IncubateAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquotDestinationWell,"Specify the position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,IncubateAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				IncubateAliquot->2*Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			2*Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Centrifuge,"Specify if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeInstrument,"Specify the centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeInstrument->Model[Instrument, Centrifuge, "Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeIntensity,"Specify the rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeTime,"Specify the amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeTime->2 Minute,
				Output -> Options
			];
			Lookup[options,CentrifugeTime],
			2 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeTemperature,"Specify the temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquotContainer,"Specify the desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				CentrifugeAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{_Integer, ObjectP[Model[Container, Vessel, "2mL Tube"]]}..,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,CentrifugeAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentGCMS[
				{Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID]},
				CentrifugeAliquot->2 Milliliter,
				Output -> Options
			];
			Lookup[options,CentrifugeAliquot],
			2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Filtration,"Specify if the SamplesIn should be filter prior to starting the experiment or any aliquoting:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Filtration->True,
				Output -> Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FiltrationType,"Specify the type of filtration method that should be used to perform the filtration:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FiltrationType->Syringe,
				Output -> Options
			];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterInstrument,"Specify the instrument that should be used to perform the filtration:"},
			options=ExperimentGCMS[Object[Sample, "Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
				Output -> Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Filter,"Specify whether to filter in order to remove impurities from the input samples prior to starting the experiment:"},
			options=ExperimentGCMS[
				Object[Sample,"ExperimentGCMS Large Test Sample 1" <> $SessionUUID],
				Filter->Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"],
				Output -> Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterMaterial,"Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterMaterial->PES,
				Output -> Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,PrefilterMaterial,"Specify the material from which the prefilter filtration membrane should be made of to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGCMS[
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				PrefilterMaterial->GxF,
				Output -> Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterPoreSize,"Specify the pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterPoreSize->0.22 Micrometer,
				Output -> Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,PrefilterPoreSize,"Specify the pore size of the filter; all particles larger than this should be removed during the filtration:"},
			options=ExperimentGCMS[
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				PrefilterPoreSize->1.`*Micrometer,
				Output -> Options
			];
			Lookup[options,PrefilterPoreSize],
			1.`*Micrometer,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterSyringe,"Specify the syringe used to force that sample through a filter:"},
			options=ExperimentGCMS[
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				FiltrationType->Syringe,
				FilterSyringe->Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output -> Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options, FilterHousing, "Specify the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterHousing -> Null,
				Output -> Options
			];
			Lookup[options, FilterHousing],
			Null,
			Variables :> {options},
			Messages :> {},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterIntensity,"Specify the rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterIntensity->1000 RPM,
				Output -> Options
			];
			Lookup[options,FilterIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterTime,"Specify the time for which the samples will be centrifuged during filtration:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterTime->5 Minute,
				FiltrationType -> Centrifuge,
				Output -> Options
			];
			Lookup[options,FilterTime],
			5 Minute,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterTemperature,"Specify the temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentGCMS[
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				FiltrationType -> Centrifuge,
				FilterTemperature->10 Celsius,
				Output -> Options
			];
			Lookup[options,FilterTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterContainerOut,"Specify the container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Large Test Sample 1" <> $SessionUUID],
				FilterContainerOut->Model[Container, Vessel, "250mL Glass Bottle"],
				Output -> Options
			];
			Lookup[options,FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquotDestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterAliquotDestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquotContainer,"Specify the container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterAliquotContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options,FilterAliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {2, ObjectP[Model[Container, Vessel, "2mL Tube"]]}, {3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterAliquot,"Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterAliquot->0.2 Milliliter,
				Output -> Options
			];
			Lookup[options,FilterAliquot],
			0.2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,FilterSterile,"Specify if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				FilterSterile->True,
				Output -> Options
			];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 300
		],
		Example[
			{Options,Aliquot,"Specify if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Aliquot->True,
				Output -> Options
			];
			Lookup[options,Aliquot],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotAmount,"Specify the amount of a sample that should be transferred from the input samples into aliquots:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				AliquotAmount->2 Milliliter,
				Output -> Options
			];
			Lookup[options,AliquotAmount],
			2 Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,TargetConcentration,"Specify the desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				TargetConcentration -> 45 Micromolar,
				Output -> Options
			];
			Lookup[options,TargetConcentration],
			45 Micromolar,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentGCMS[Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, "Acetone"], InjectionVolume -> 10 Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Acetone"]],
			Variables :> {options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AssayVolume,"Specify the desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				AssayVolume->2*Milliliter,
				Output -> Options
			];
			Lookup[options,AssayVolume],
			2*Milliliter,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConcentratedBuffer,"Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BufferDilutionFactor,"Specify the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,BufferDiluent,"Specify the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				BufferDiluent -> Model[Sample, "Methanol - LCMS grade"],
				BufferDilutionFactor -> 10,
				ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample, "Methanol - LCMS grade"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AssayBuffer,"Specify the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotVolume and the total AssayVolume:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID]},
				AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"],
				AssayVolume -> 2000 Microliter,
				AliquotAmount -> 1500 Microliter,
				Output -> Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotSampleStorageCondition,"Specify the non-default conditions under which any aliquot samples generated by this experiment should be stored after the options is completed:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AliquotSampleStorageCondition->Refrigerator,
				Output -> Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,DestinationWell,"Specify the position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				DestinationWell->"A1",
				Output -> Options
			];
			Lookup[options,DestinationWell],
			{"A1","A1","A1"},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotContainer,"Specify the container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AliquotContainer->Model[Container, Vessel, "2 mL clear glass GC vial"],
				Output -> Options
			];
			Lookup[options,AliquotContainer],
			{{_Integer, ObjectP[Model[Container, Vessel, "2 mL clear glass GC vial"]]}..},
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,AliquotPreparation,"Specify the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AliquotPreparation->Manual,
				Output -> Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,ConsolidateAliquots,"Specify if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Aliquot->True, ConsolidateAliquots -> True,
				Output -> Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MeasureWeight,"Specify if any solid samples that are modified in the course of the experiment should have their weights measured and updated after running the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MeasureWeight->False,
				Output -> Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,MeasureVolume,"Specify if any liquid samples that are modified in the course of the experiment should have their volumes measured and updated after running the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				MeasureVolume->False,
				Output -> Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{protocol},
			TimeConstraint -> 300
		],
		Example[
			{Options,ImageSample,"Specify if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ImageSample->False,
				Output -> Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the non-default conditions under which any samples going into this experiment should be stored after the protocol is completed. If left unset, the new samples will be stored according to their Models' DefaultStorageCondition:"},
			options=ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplesInStorageCondition->AmbientStorage,
				Output -> Options
			];
			Lookup[options,SamplesInStorageCondition],
			AmbientStorage,
			Variables:>{options},
			TimeConstraint -> 300
		],
		Example[{Messages,"GCSampleVolumeOutOfRange","An error is given if the specified InjectionVolume does not fall between 1% and 100% of the volume of the specified InjectionSyringe:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InjectionVolume -> 250*Microliter,
				LiquidInjectionSyringe -> Model[Container, Syringe, "id:dORYzZJxRqER"]
			],
			$Failed,
			Messages :> {
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CospecifiedInitialColumnConditions","An error is given if options are selected that cannot be specified for any separation simultaneously:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InitialColumnFlowRate->100Milliliter/Minute,
				InitialColumnPressure->50PSI
			],
			$Failed,
			Messages :> {
				Error::CospecifiedInitialColumnConditions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleInletAndInletOption","An error is given if options are selected that are not compatible with a SplitSplitless inlet:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SolventEliminationFlowRate->100Milliliter/Minute,
				Inlet->SplitSplitless
			],
			$Failed,
			Messages :> {
				Error::IncompatibleInletAndInletOption,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SplitRatioAndFlowRateCospecified","An error is given if SplitRatio and SplitVentFlowRate are specified simultaneously:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SplitRatio->20,
				SplitVentFlowRate->60Milliliter/Minute
			],
			$Failed,
			Messages :> {
				Error::SplitRatioAndFlowRateCospecified,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCOptionsAreConflicting","An error is given if SplitRatio or SplitVentFlowRate are specified when SolventEliminationFlowRate is also specified:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SplitRatio->20,
				SolventEliminationFlowRate->60Milliliter/Minute
			],
			$Failed,
			Messages :> {
				Error::GCOptionsAreConflicting,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OptionsNotCompatibleWithSamplingMethod","An error is given if Liquid sampling options are specified if the SamplingMethod is not set to LiquidInjection:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				LiquidPreInjectionSyringeWashVolume->60Microliter
			],
			$Failed,
			Messages :> {
				Error::OptionsNotCompatibleWithSamplingMethod,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCContainerIncompatible","An error is given if the containers specified are incompatible with the specified Instrument:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				AliquotContainer->Model[Container,Vessel,"10L Polypropylene Carboy"]
			],
			$Failed,
			Messages :> {
				Error::GCContainerIncompatible,
				Error::CoverNeededForContainer,
				Error::InvalidOption
			}
		],
		Example[{Messages,"OptionValueOutOfBounds","An error is given if the option value it set too high for the instrument:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SampleAspirationRate->100*Milliliter/Second,
				SamplingMethod->LiquidInjection
			],
			$Failed,
			Messages :> {
				Error::OptionValueOutOfBounds,
				Error::InvalidOption
			}
		],
		Example[{Messages,"DetectorOptionsIncompatible","An error is given if the options are not compatible with a specified detector:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Detector->MassSpectrometer,
				FIDTemperature->200Celsius
			],
			$Failed,
			Messages :> {
				Error::DetectorOptionsIncompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCORingNotCompatible","An error is given if the LinerORing cannot currently be used on instrument:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LinerORing->Model[Item, ORing, "id:aXRlGn6pznXB"]
			],
			$Failed,
			Messages :> {
				Error::GCORingNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCSeptumNotCompatible","An error is given if the InletSeptum cannot currently be used on instrument:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				InletSeptum->Model[Item, Septum,"Example Septum for ExperimentGCMS " <> $SessionUUID]
			],
			$Failed,
			Messages :> {
				Error::GCSeptumNotCompatible,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleColumn","An error is given if the Column is not a GC column:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				Column->Model[Item, Column, "id:D8KAEvGloNL3"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleColumn,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCTrimColumnConflict","An error is given if TrimColumnLength is specified if TrimColumn is False:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TrimColumn->False,
				TrimColumnLength->40Centimeter
			],
			$Failed,
			Messages :> {
				Error::GCTrimColumnConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCLiquidInjectionSyringeRequired","An error is given if a LiquidInjection sample has been specified but a LiquidInjectionSyringe has not:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCLiquidInjectionSyringeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleLiquidInjectionSyringe","An error is given if the LiquidInjectionSyringe does not have the correct GCInjectionTypeLiquidInjection:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleLiquidInjectionSyringe,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCHeadspaceInjectionSyringeRequired","An error is given if a HeadspaceInjection sample has been specified but a HeadspaceInjectionSyringe has not:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->HeadspaceInjection,
				HeadspaceInjectionSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCHeadspaceInjectionSyringeRequired,
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleHeadspaceInjectionSyringe","An error is given if the HeadspaceInjectionSyringe does not have the correct GCInjectionType:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				HeadspaceInjectionSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleHeadspaceInjectionSyringe,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCSPMEInjectionFiberRequired","An error is given if a SPMEInjection sample has been specified but a SPMEInjectionFiber has not:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				SamplingMethod->SPMEInjection,
				SPMEInjectionFiber->Null
			],
			$Failed,
			Messages :> {
				Error::GCSPMEInjectionFiberRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCLiquidHandlingSyringeRequired","An error is given if a LiquidHandling step has been specified but a LiquidHandlingSyringe has not:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 5" <> $SessionUUID],
				DilutionSolventVolume->100Microliter,
				DilutionSolvent -> Model[Sample, "Hexanes"],
				LiquidHandlingSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCLiquidHandlingSyringeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCIncompatibleLiquidHandlingSyringe","An error is given if the LiquidHandlingSyringe does not have the correct GCInjectionType:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 5" <> $SessionUUID],
				DilutionSolventVolume->100Microliter,
				DilutionSolvent -> Model[Sample, "Hexanes"],
				LiquidHandlingSyringe->Model[Container, Syringe, "id:P5ZnEj4P88P0"]
			],
			$Failed,
			Messages :> {
				Error::GCIncompatibleLiquidHandlingSyringe,
				Error::InvalidOption
			}
		],

		(* --- Messages --- *)
		Example[{Messages,"UnneededSyringeComponent","A warning is given if unnecessary syringe components are specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				LiquidInjectionSyringe->Model[Container, Syringe, "id:dORYzZJxRqER"],
				SamplingMethod->HeadspaceInjection
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::UnneededSyringeComponent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"OverwritingSeparationMethod","A warning is given if the SeparationMethod is overwritten:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				SeparationMethod->Object[Method,GasChromatography,"Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				InletSeptumPurgeFlowRate -> 5 Milliliter/Minute
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::OverwritingSeparationMethod
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCColumnMinTemperatureExceeded","A warning is given if the temperature settings in the experiment are lower than the MinTemperature of the GCColumn:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Column->Model[Item, Column,"Column with high MinTemperature for ExperimentGCMS" <> $SessionUUID],
				InitialOvenTemperature -> 30 Celsius
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::GCColumnMinTemperatureExceeded
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AutomaticallySelectedWashSolvent","A warning is given if solvent washes are specified but no wash solvent is specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				DilutionSolvent->Automatic,
				LiquidPostInjectionNumberOfSolventWashes -> 3
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::AutomaticallySelectedWashSolvent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AutomaticallySelectedDilutionSolvent","A warning is given if a DilutionSolventVolume is specified but no DilutionSolvent is specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				DilutionSolventVolume -> 25 Microliter
			],
			ObjectP[Object[Protocol,GasChromatography]],
			Messages :> {
				Warning::AutomaticallySelectedDilutionSolvent
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCStandardBlankContainer","An error is given if a Blank is in a GC-incompatible container:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter,
				Aliquot -> False
			],
			$Failed,
			Messages :> {
				Error::GCStandardBlankContainer,
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCMismatchedVialsAndAmounts","An error is given if a Blank is in a GC-incompatible container:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnspecifiedVials","An error is given if a Blank is specified but a BlankVial is not:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID],
				BlankVial -> Null,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCMismatchedVialsAndAmounts,
				Error::GCUnspecifiedVials,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnneededAmounts","An error is given if a Blank is NoInjection but a BlankAmount is specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCUnneededAmounts,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnneededVials","An error is given if a Blank is NoInjection but a BlankVial is specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"]
			],
			$Failed,
			Messages :> {
				Error::GCUnneededVials,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"InvalidBlankSamplePreparationOptions","An error is given if a Blank is NoInjection but a BlankAmount is specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> NoInjection,
				BlankAmount -> 50 Microliter
			],
			$Failed,
			Messages :> {
				Error::GCUnneededAmounts,
				Error::InvalidBlankSamplePreparationOptions,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCUnspecifiedAmounts","An error is given if a Blank is specified but BlankAmount is Null:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Blank -> Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID],
				BlankVial -> Model[Container, Vessel, "2 mL clear glass GC vial"],
				BlankAmount -> Null
			],
			$Failed,
			Messages :> {
				Error::GCUnspecifiedAmounts,
				Error::GCMismatchedVialsAndAmounts,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidAgitateWhileSampling","An error is given if SamplingMethod options are LiquidInjection and AgitateWhileSampling options are True:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				AgitateWhileSampling -> True
			],
			$Failed,
			Messages :> {
				Error::LiquidAgitateWhileSampling,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceWithoutAgitation","An error is given if SamplingMethod options are HeadspaceInjection and Agitate options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SamplingMethod -> HeadspaceInjection,
				Agitate -> False
			],
			$Failed,
			Messages :> {
				Error::HeadspaceWithoutAgitation,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceAgitateWhileSampling","An error is given if SamplingMethod options are HeadspaceInjection and AgitateWhileSampling options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SamplingMethod -> HeadspaceInjection,
				AgitateWhileSampling -> False
			],
			$Failed,
			Messages :> {
				Error::HeadspaceAgitateWhileSampling,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"SPMEDerivatizationOptionsConflict","An error is given if SPMEDerivatizingAgentAdsorptionTime, SPMEDerivatizationPosition, or SPMEDerivatizationPositionOffset options are specified but the corresponding SPMEDerivatizingAgent options are Null:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SPMEDerivatizingAgent -> Null,
				SPMEDerivatizingAgentAdsorptionTime -> 10 Minute
			],
			$Failed,
			Messages :> {
				Error::SPMEDerivatizationOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"SPMEConditionOptionsConflict","An error is given if SPMEConditioningTemperature, SPMEPreConditioningTime, or SPMEPostInjectionConditioningTime options are specified but the corresponding SPMECondition options are not specified:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SPMECondition -> False,
				SPMEConditioningTemperature -> 45 Celsius
			],
			$Failed,
			Messages :> {
				Error::SPMEConditionOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"HeadspaceSyringeFlushingOptionsConflict","An error is given if HeadspacePreInjectionFlushTime or HeadspacePostInjectionFlushTime options are specified but the corresponding HeadspaceSyringeFlushing options are Null:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				HeadspaceSyringeFlushing -> Null,
				HeadspacePreInjectionFlushTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::HeadspaceSyringeFlushingOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PostInjectionSyringeWashOptionsConflict","An error is given if LiquidPostInjectionSyringeWash related options are specified but the corresponding LiquidPostInjectionSyringeWash options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				LiquidPostInjectionSyringeWash -> False,
				LiquidPostInjectionSyringeWashVolume -> 20 Microliter
			],
			$Failed,
			Messages :> {
				Error::PostInjectionSyringeWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"InsufficientSampleVolume","An error is given if InjectionVolume options are greater than the volume of corresponding sample available, including replicates:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				InjectionVolume -> 2 Milliliter
			],
			$Failed,
			Messages :> {
				Error::InsufficientSampleVolume,
				Error::GCSampleVolumeOutOfRange,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidSampleWashOptionsConflict","An error is given if LiquidSampleWashVolume or NumberOfLiquidSampleWashes options are specified but the corresponding LiquidSampleWash options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				LiquidSampleWash -> False,
				NumberOfLiquidSampleWashes -> 2
			],
			$Failed,
			Messages :> {
				Error::LiquidSampleWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"PreInjectionSyringeWashOptionsConflict","An error is given if LiquidPreInjectionSyringeWash related options are specified but the corresponding LiquidPreInjectionSyringeWash options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SyringeWashSolvent -> Model[Sample, "Hexanes"],
				LiquidPreInjectionSyringeWash -> False,
				LiquidPreInjectionNumberOfSolventWashes -> 2
			],
			$Failed,
			Messages :> {
				Error::PreInjectionSyringeWashOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"VortexOptionsConflict","An error is given if VortexTime or VortexMixRate options are specified but the corresponding Vortex options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Vortex -> False,
				VortexTime -> 2 Second
			],
			$Failed,
			Messages :> {
				Error::VortexOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ContainersOverfilledByDilution","An error is given if specified Dilution options will result in overfilling the container:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				DilutionSolvent -> Model[Sample, "Hexanes"],
				DilutionSolventVolume -> 2 Milliliter
			],
			$Failed,
			Messages :> {
				Error::ContainersOverfilledByDilution,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"AgitationOptionsConflict","An error is given if Agitation related options are specifed and Agitate options are False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				Agitate -> False,
				AgitationTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::AgitationOptionsConflict,
				Error::LiquidInjectionAgitationConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"LiquidInjectionAgitationConflict","An error is given if SamplingMethod options are LiquidInjection and Agitate options are True or Agitation options are set:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				SamplingMethod -> LiquidInjection,
				AgitationTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::LiquidInjectionAgitationConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"ColumnConditioningOptionsConflict","An error is given if ColumnConditioningTime or ColumnConditioningGas are specified and ConditionColumn is False:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID],
				ConditionColumn -> False,
				ColumnConditioningTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::ColumnConditioningOptionsConflict,
				Error::InvalidOption
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"GCColumnMaxTemperatureExceeded","An error is given if the Temperature setpoints exceed the maximum column temperature:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				ColumnConditioningTemperature->400Celsius
			],
			$Failed,
			Messages :> {
				Error::GCColumnMaxTemperatureExceeded,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCTrimColumnConflict","An error is given if a TrimColumnLength is specified if TrimColumn is False:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				TrimColumn->False,
				TrimColumnLength->40Centimeter
			],
			$Failed,
			Messages :> {
				Error::GCTrimColumnConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GCLiquidInjectionSyringeRequired","An error is given a LiquidInjection sample has been specified but a LiquidInjectionSyringe has not:"},
			ExperimentGCMS[
				{Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 2" <> $SessionUUID], Object[Sample, "ExperimentGCMS Test Sample 3" <> $SessionUUID]},
				LiquidInjectionSyringe->Null
			],
			$Failed,
			Messages :> {
				Error::GCLiquidInjectionSyringeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CoverNeededForContainer", "An error is given if a compatible cap cannot be found for the container to be loaded onto the GC autosampler:"},
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				AliquotContainer -> Model[Container, Vessel, "10L Polypropylene Carboy"]
			],
			$Failed,
			Messages :> {
				Error::GCContainerIncompatible,
				Error::CoverNeededForContainer,
				Error::InvalidOption
			}
		],
		Test["Users may use any vial with the correct footprint for the autosampler and with any pierceable cap as long as the sample does not need to move on the GC deck:",
			ExperimentGCMS[
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Agitate -> False,
				Vortex -> False
			],
			ObjectP[Object[Protocol, GasChromatography]]
		],
		Test["Aliquoting to a container with a magnetic cap is required, if the sample needs to move on the GC deck:",
			ExperimentGCMS[
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Agitate -> False,
				Vortex -> True
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::AliquotRequired}
		],
		Example[{Messages, "CapSwap", "A Warning is surfaced if a sample is in a container that requires its current cover to be replaced with a new cap:"},
			ExperimentGCMS[
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {
				Warning::ContainerCapSwapRequired
			}
		],
		Test["A Warning is surfaced if a standard is in a container that requires its current cover to be replaced with a compatible cap:",
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::ContainerCapSwapRequired}
		],
		Test["A Warning is surfaced if a blank is in a container that requires current cover to be replaced with a compatible cap:",
			ExperimentGCMS[
				Object[Sample, "ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Standard -> Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID]
			],
			ObjectP[Object[Protocol, GasChromatography]],
			Messages :> {Warning::ContainerCapSwapRequired}
		]
	},

	(* un comment this out when Variables works the way we would expect it to *)
	(* Variables :> {$SessionUUID},*)
	Stubs :> {Quiet[_,_] = Quiet[_]},
(*	Stubs :> {Quiet[Download[___],_] = Quiet[Download[___],{Download::FieldDoesntExist, Download::NotLinkField, Download::MissingCacheField, Download::ObjectDoesNotExist,Download::MissingField}]},*)
	SymbolSetUp:> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 4" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 5" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Large Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGCMS tests" <> $SessionUUID],
				Object[Sample, "Example sample in a uncovered vial for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 2 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 3 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 4 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 5 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial without a cover for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container,Vessel,"Test large vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test invalid container 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 2 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 3 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 4 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 5 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example large magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-pierceable vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Protocol, GasChromatography, "My particular ExperimentGCMS protocol" <> $SessionUUID],
				Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 1 for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 2 for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 3 for ExperimentGCMS" <> $SessionUUID],
				Model[Item, Septum, "Example Septum for ExperimentGCMS " <> $SessionUUID],
				Model[Item, Column, "Column with high MinTemperature for ExperimentGCMS" <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, container2, container3, container4, container5,  discardedContainer,
					largeContainer, invalidContainer, containerWithNonPierceableCap, containerWithNonMagneticCap, containerWithoutCover,
					cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap, coverPackets, samplePackets,
					methodPackets, stockedProductPackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGCMS tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1, container2, container3, container4, container5, containerWithoutCover,
					discardedContainer, containerWithNonPierceableCap, largeContainer, invalidContainer, containerWithNonMagneticCap,
					cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Container, Vessel, "id:jLq9jXvwdnRW"], (*10 mL clear glass GC vial*)
						Model[Container, Vessel, "id:3em6Zv9NjjN8"], (*2mL Tube*)
						Model[Container, Vessel, "id:XnlV5jNXm8oP"], (*Thermo Scientific SureSTART 2 mL Glass Crimp Top Vials, Level 2 High-Throughput Applications*)
						Model[Item, Cap, "id:L8kPEjn1PRww"],(*2 mL GC vial cap, magnetic*)
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:L8kPEjn1PRww"],
						Model[Item, Cap, "id:AEqRl9Kmnrqv"],
						Model[Item, Cap, "id:jLq9jXOmYw5q"],(*Thermo Scientific SureSTART 11 mm Crimp Caps, White Silicone/Red PTFE*)
						Model[Item, Cap, "id:6V0npvmo1qX8"](*"Tube Cap, 12x6mm" w/ Pierceable -> False*)
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
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGCMS tests" <> $SessionUUID,
						"Test vial 2 for ExperimentGCMS tests" <> $SessionUUID,
						"Test vial 3 for ExperimentGCMS tests" <> $SessionUUID,
						"Test vial 4 for ExperimentGCMS tests" <> $SessionUUID,
						"Test vial 5 for ExperimentGCMS tests" <> $SessionUUID,
						"Example vial without a cover for ExperimentGCMS tests " <> $SessionUUID,
						"Test discarded vial 1 for ExperimentGCMS tests" <> $SessionUUID,
						"Example vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID,
						"Test large vial 1 for ExperimentGCMS tests" <> $SessionUUID,
						"Test invalid container 1 for ExperimentGCMS tests" <> $SessionUUID,
						"Example vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGCMS tests " <> $SessionUUID,
						"Example magnetic vial cap 2 for ExperimentGCMS tests " <> $SessionUUID,
						"Example magnetic vial cap 3 for ExperimentGCMS tests " <> $SessionUUID,
						"Example magnetic vial cap 4 for ExperimentGCMS tests " <> $SessionUUID,
						"Example magnetic vial cap 5 for ExperimentGCMS tests " <> $SessionUUID,
						"Example large magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID,
						"Example non-magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID,
						"Example non-pierceable vial cap for ExperimentGCMS tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1, container2, container3, container4, container5, largeContainer, containerWithNonMagneticCap, containerWithNonPierceableCap},
					Cover -> {cover1, cover2, cover3, cover4, cover5, largeMagneticCap, nonMagneticCap, nonPierceableCap},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"],
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", container2},
						{"A1", container3},
						{"A1", container4},
						{"A1", container5},
						{"A1", largeContainer},
						{"A1", invalidContainer},
						{"A1", discardedContainer},
						{"A1", containerWithoutCover},
						{"A1", containerWithNonMagneticCap},
						{"A1", containerWithNonPierceableCap}
					},
					InitialAmount ->
							{
								2000 Microliter,
								300 Microliter,
								1000 Microliter,
								1000 Microliter,
								100 Microliter,
								4000 Microliter,
								2000 Microliter,
								1800 Microliter,
								1000 Microliter,
								1000 Microliter,
								1000 Microliter
							},
					Name->{
						"ExperimentGCMS Test Sample 1" <> $SessionUUID,
						"ExperimentGCMS Test Sample 2" <> $SessionUUID,
						"ExperimentGCMS Test Sample 3" <> $SessionUUID,
						"ExperimentGCMS Test Sample 4" <> $SessionUUID,
						"ExperimentGCMS Test Sample 5" <> $SessionUUID,
						"ExperimentGCMS Large Test Sample 1" <> $SessionUUID,
						"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID,
						"Test sample for discarded sample for ExperimentGCMS tests" <> $SessionUUID,
						"Example sample in a uncovered vial for ExperimentGCMS tests " <> $SessionUUID,
						"Example sample in a vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID,
						"Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)

				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGCMS Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						],
						Association[
							Object -> Object[Sample,"ExperimentGCMS Test Sample 4" <> $SessionUUID],
							Model -> Null
						]
					}
				];

				methodPackets = {
					Association[
						Type -> Object[Method, GasChromatography],
						Name -> "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID,
						Replace[ColumnLength]->30*Meter,
						Replace[ColumnDiameter]->0.32*Milli*Meter,
						Replace[ColumnFilmThickness]->0.25*Micro*Meter,
						InletLinerVolume->870*Micro*Liter,
						Detector->FlameIonizationDetector,
						CarrierGas->Helium,
						InletSeptumPurgeFlowRate->3*Milli*Liter/Minute,
						InitialInletTemperature->250*Celsius,
						SplitRatio->20,
						InitialInletPressure->25*PSI,
						InitialInletTime->1*Minute,
						GasSaver->True,
						GasSaverFlowRate->25*Milli*Liter/Minute,
						GasSaverActivationTime->3*Minute,
						InitialColumnFlowRate->1.7*Milli*Liter/Minute,
						ColumnFlowRateProfile->ConstantFlowRate,
						OvenEquilibrationTime->2*Minute,
						InitialOvenTemperature->50*Celsius,
						OvenTemperatureProfile->Isothermal,
						PostRunOvenTemperature->35*Celsius,
						PostRunOvenTime->2*Minute
					]
				};

				Upload[methodPackets];

				stockedProductPackets = {
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 1 for ExperimentGCMS" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					],
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 2 for ExperimentGCMS" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					],
					Association[
						Type->Object[Item,Cap],
						Name->"Stocked vial cap 3 for ExperimentGCMS" <> $SessionUUID,
						Model->Link[Model[Item, Cap, "id:AEqRl9Kmnrqv"],Objects],
						Status->Stocked
					]
				};

				Upload[stockedProductPackets];

				Upload[{
					<|
						Type->Model[Item, Septum],
						Name->"Example Septum for ExperimentGCMS " <> $SessionUUID,
						Diameter->1Millimeter
					|>,
					<|
						Type -> Model[Item, Column],
						ChromatographyType -> GasChromatography,
						ColumnFormat -> Quantity[7., "Inches"],
						ColumnLength -> Quantity[30000., "Millimeters"],
						ColumnType -> Analytical,
						Replace[Connectors] -> {{"Column Inlet", Tube, None, Quantity[0.00984251968503937, "Inches"], Quantity[0.015748031496062992, "Inches"], None}, {"Column Outlet", Tube, None, Quantity[0.00984251968503937, "Inches"], Quantity[0.015748031496062992, "Inches"], None}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Diameter -> Quantity[0.25, "Millimeters"],
						Dimensions -> {Quantity[0.1905, "Meters"], Quantity[0.1905, "Meters"], Quantity[0.0635, "Meters"]},
						FilmThickness -> Quantity[0.25, "Micrometers"],
						MaxFlowRate -> Quantity[16000., "Milliliters"/"Minutes"],
						MaxNumberOfUses -> 9999,
						MaxPressure -> Quantity[100., "PoundsForce"/"Inches"^2],
						MaxShortExposureTemperature -> Quantity[350., "DegreesCelsius"],
						MaxTemperature -> Quantity[325., "DegreesCelsius"],
						MinFlowRate -> Quantity[0., "Milliliters"/"Minutes"],
						MinPressure -> Quantity[0., "PoundsForce"/"Inches"^2],
						MinTemperature -> Quantity[40, "DegreesCelsius"],
						PackingType -> WCOT,
						Polarity -> NonPolar,
						SeparationMode -> GasChromatography,
						Size -> Quantity[30., "Meters"],
						Replace[StationaryPhaseBonded] -> {Bonded, Crosslinked},
						Replace[WettedMaterials] -> {Silica},
						DeveloperObject -> True,
						Name -> "Column with high MinTemperature for ExperimentGCMS" <> $SessionUUID
					|>
				}]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 2" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 3" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 4" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Test Sample 5" <> $SessionUUID],
				Object[Sample,"ExperimentGCMS Large Test Sample 1" <> $SessionUUID],
				Object[Sample,"Test sample for invalid container for ExperimentGCMS tests" <> $SessionUUID],
				Object[Sample,"Test sample for discarded sample for ExperimentGCMS tests" <> $SessionUUID],
				Object[Sample, "Example sample in a uncovered vial for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Sample, "Example sample in a vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container,Vessel,"Test vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 2 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 3 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 4 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test vial 5 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial without a cover for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-pierceable cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Container,Vessel,"Test large vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test invalid container 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded vial 1 for ExperimentGCMS tests" <> $SessionUUID],
				Object[Container, Vessel, "Example vial with a non-magnetic cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 2 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 3 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 4 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 5 for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example large magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-magnetic vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Item, Cap, "Example non-pierceable vial cap for ExperimentGCMS tests " <> $SessionUUID],
				Object[Protocol, GasChromatography, "My particular ExperimentGCMS protocol" <> $SessionUUID],
				Object[Method, GasChromatography, "Test SeparationMethod for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 1 for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 2 for ExperimentGCMS" <> $SessionUUID],
				Object[Item, Cap, "Stocked vial cap 3 for ExperimentGCMS" <> $SessionUUID],
				Model[Item, Septum, "Example Septum for ExperimentGCMS " <> $SessionUUID],
				Model[Item, Column, "Column with high MinTemperature for ExperimentGCMS" <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]

		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
	HardwareConfiguration -> HighRAM
];


(* ::Subsubsection:: *)
(*ExperimentGCMSOptions*)

DefineTests[
	ExperimentGCMSOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentGCMSOptions[Object[Sample,"ExperimentGCMSOptions Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"View any potential issues with provided inputs/options displayed:"},
			ExperimentGCMSOptions[Object[Sample,"Test sample for discarded sample for ExperimentGCMSOptions tests" <> $SessionUUID]],
			_Grid,
			Messages:>{
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentGCMSOptions[Object[Sample,"ExperimentGCMSOptions Test Sample 1" <> $SessionUUID],OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGCMSOptions tests " <> $SessionUUID],
				Object[Sample, "ExperimentGCMSOptions Test Sample 1" <> $SessionUUID],
				Object[Sample, "Test sample for discarded sample for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test discarded vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMSOptions tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			Module[
				{
					testBench, container1, discardedContainer, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGCMSOptions tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1, discardedContainer, cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID,
						"Test discarded vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGCMSOptions tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", discardedContainer}
					},
					InitialAmount ->
							{
								2000 Microliter,
								1800 Microliter
							},
					Name->{
						"ExperimentGCMSOptions Test Sample 1" <> $SessionUUID,
						"Test sample for discarded sample for ExperimentGCMSOptions tests" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)

				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGCMSOptions Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ExperimentGCMSOptions tests " <> $SessionUUID],
				Object[Sample, "ExperimentGCMSOptions Test Sample 1" <> $SessionUUID],
				Object[Sample, "Test sample for discarded sample for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Container, Vessel, "Test discarded vial 1 for ExperimentGCMSOptions tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMSOptions tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];

(* ::Subsubsection:: *)
(*ValidExperimentGCMSQ*)

DefineTests[
	ValidExperimentGCMSQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issues:"},
			ValidExperimentGCMSQ[Object[Sample,"ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentGCMSQ[Object[Sample,"Test sample for discarded sample for ValidExperimentGCMSQ tests" <> $SessionUUID]],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentGCMSQ[Object[Sample,"ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentGCMSQ[Object[Sample,"ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID],Verbose->True],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ValidExperimentGCMSQ tests " <> $SessionUUID],
				Object[Sample, "ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID],
				Object[Sample, "Test sample for discarded sample for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test discarded vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ValidExperimentGCMSQ tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			(*module for creating objects*)
			Module[
				{
					testBench, container1, discardedContainer, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ValidExperimentGCMSQ tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1, discardedContainer, cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID,
						"Test discarded vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ValidExperimentGCMSQ tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"], (*80% Heptane, 20% Ethanol diluent for SFC*)
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"]
					},
					{
						{"A1", container1},
						{"A1", discardedContainer}
					},
					InitialAmount ->
							{
								2000 Microliter,
								1800 Microliter
							},
					Name->{
						"ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID,
						"Test sample for discarded sample for ValidExperimentGCMSQ tests" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(* discard the discarded sample+container by moving to waste *)
				UploadLocation[discardedContainer, Waste];

				(*sever the link to the model*)

				Upload[
					{
						Association[
							Object -> Object[Sample,"ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects={
				Object[Container, Bench, "Example bench for ValidExperimentGCMSQ tests " <> $SessionUUID],
				Object[Sample, "ValidExperimentGCMSQ Test Sample 1" <> $SessionUUID],
				Object[Sample, "Test sample for discarded sample for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Container, Vessel, "Test discarded vial 1 for ValidExperimentGCMSQ tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ValidExperimentGCMSQ tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];

(* ::Subsubsection:: *)
(*ExperimentGCMSPreview*)

DefineTests[
	ExperimentGCMSPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentGCMS:"},
			ExperimentGCMSPreview[Object[Sample,"ExperimentGCMSPreview Test Sample 1" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed, try using ExperimentGCMSOptions:"},
			ExperimentGCMSOptions[Object[Sample,"ExperimentGCMSPreview Test Sample 1" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run using ValidExperimentGCMSQ:"},
			ValidExperimentGCMSQ[Object[Sample,"ExperimentGCMSPreview Test Sample 1" <> $SessionUUID]],
			True
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*module for deleting created objects*)
		Module[{objects, existingObjects},
			objects = {
				Object[Container, Bench, "Example bench for ExperimentGCMSPreview tests " <> $SessionUUID],
				Object[Sample, "ExperimentGCMSPreview Test Sample 1" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ExperimentGCMSPreview tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMSPreview tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		];
		(*module for creating objects*)
		Block[{$AllowPublicObjects = True, $DeveloperUpload = True},
			(*module for creating objects*)
			Module[
				{
					testBench, container1, cover1, coverPackets, samplePackets
				},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Example bench for ExperimentGCMSPreview tests " <> $SessionUUID,
						DeveloperObject -> True,
						StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
						Site -> Link[$Site]
					|>
				];

				{
					container1, cover1
				} = UploadSample[
					{
						Model[Container, Vessel, "id:AEqRl9KmRnj1"],(*2 mL clear glass GC vial*)
						Model[Item, Cap, "id:L8kPEjn1PRww"](*2 mL GC vial cap, magnetic*)
					},
					{
						{"Work Surface", testBench},
						{"Work Surface", testBench}
					},
					Name -> {
						"Test vial 1 for ExperimentGCMSPreview tests" <> $SessionUUID,
						"Example magnetic vial cap 1 for ExperimentGCMSPreview tests " <> $SessionUUID
					}
				];

				coverPackets = UploadCover[
					{container1},
					Cover -> {cover1},
					Upload -> False
				];

				samplePackets = UploadSample[
					{
						Model[Sample, StockSolution, "id:n0k9mG8XGPVn"] (*80% Heptane, 20% Ethanol diluent for SFC*)
					},
					{
						{"A1", container1}
					},
					InitialAmount ->
							{
								2000 Microliter
							},
					Name->{
						"ExperimentGCMSPreview Test Sample 1" <> $SessionUUID
					},
					Upload->False
				];

				Upload[Join[coverPackets, samplePackets]];

				(*sever the link to the model*)

				Upload[
					{
						Association[
							Object -> Object[Sample,"ExperimentGCMSPreview Test Sample 1" <> $SessionUUID],
							Replace[Composition] -> {{100 VolumePercent, Link[Model[Molecule, "Water"]], Now}, {5 Millimolar, Link[Model[Molecule, "Acetone"]], Now}}
						]
					}
				]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects, existingObjects},
			objects = {
				Object[Container, Bench, "Example bench for ExperimentGCMSPreview tests " <> $SessionUUID],
				Object[Sample, "ExperimentGCMSPreview Test Sample 1" <> $SessionUUID],
				Object[Container, Vessel, "Test vial 1 for ExperimentGCMSPreview tests" <> $SessionUUID],
				Object[Item, Cap, "Example magnetic vial cap 1 for ExperimentGCMSPreview tests " <> $SessionUUID]
			};

			existingObjects = PickList[objects, DatabaseMemberQ[#]&/@objects];
			EraseObject[existingObjects, Force -> True, Verbose -> False]
		]
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];
