(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentFillToVolume*)

DefineTests[ExperimentFillToVolume,
	{
		Example[{Basic, "Given samples, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}],
			ObjectP[Object[Protocol, FillToVolume]]
		],
		Example[{Basic, "Given containers, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ExperimentFillToVolume[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}],
			ObjectP[Object[Protocol, FillToVolume]]
		],
		Example[{Basic, "Given containers and positions, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ExperimentFillToVolume[{"A8", Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, 1 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, FillToVolume]]
		],
		Example[{Options, DestinationWell, "Specify the position in the container where the sample to be filled to volume is; if not specified, selects the current position of the specified sample:"},
			options = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}, Output -> Options];
			Lookup[options, DestinationWell],
			{"A1", "A8"},
			Variables :> {options}
		],
		Example[{Options, DestinationWell, "The specified value in the input overrides the DestinationWell option"},
			options = ExperimentFillToVolume[{"A8", Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, 1 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> "A1", Output -> Options];
			Lookup[options, DestinationWell],
			{"A8"},
			Variables :> {options}
		],
		Example[{Options, Method, "Specify the way by which the volume will be measured in this fill to volume experiment.  If not specified, automatically set to Volumetric if in a volumetric flask, or Ultrasonic otherwise:"},
			options = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 100 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], Method -> {Ultrasonic, Automatic}, Output -> Options];
			Lookup[options, Method],
			{Ultrasonic, Volumetric},
			Variables :> {options}
		],
		Example[{Options, Method, "If Method -> Ultrasonic, the first transfer volume should be 0.9 * (TotalVolume - current volume).  If Method -> Volumetric, first transfer volume should be required solvent volume:"},
			protocol = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 100 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], Method -> {Ultrasonic, Volumetric}];
			Download[protocol, BatchedUnitOperations[TransferUnitOperations][[1]][AmountVariableUnit]],
			{
				{LessP[30 Milliliter]},
				{EqualP[99 Milliliter]}
			},
			Variables :> {protocol}
		],
		Example[{Options, Method, "If Method -> Ultrasonic, then LiquidLevelDetector is populated in the BatchedUnitOperations:"},
			protocol = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 100 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], Method -> {Ultrasonic, Volumetric}];
			Download[protocol, BatchedUnitOperations[LiquidLevelDetector]],
			{
				{ObjectP[Model[Instrument, LiquidLevelDetector]]},
				{Null}
			},
			Variables :> {protocol}
		],
		Test["If filling multiple samples to volume, make sure the unit operations are prepared properly:",
			protocol = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 100 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], Method -> {Ultrasonic, Volumetric}];
			Download[protocol, BatchedUnitOperations[SampleLabel]],
			{{_String}, {_String}},
			Variables :> {protocol}
		],
		Example[{Options, Solvent, "Specify the solvent that will be added to the specified sample.  If not specified, automatically set to the Solvent of the input sample:"},
			options = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 25 Milliliter}, Solvent -> {Model[Sample, "Milli-Q water"], Automatic}, Output -> Options];
			Lookup[options, Solvent],
			{ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Tetrahydrofuran, Anhydrous"]]},
			Variables :> {options}
		],
		Example[{Options, SolventContainer, "Specify the container that the solvent to be added to the specified sample.  If not specified, automatically set to the container of the specified sample, or the PreferredContainer of that volume, or the container in which the Solvent arrives when ordered:"},
			options = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 25 Milliliter}, Solvent -> {Model[Sample, "Milli-Q water"], Automatic}, SolventContainer -> {Automatic, Model[Container, Vessel, "1L Glass Bottle"]}, Output -> Options];
			Lookup[options, SolventContainer],
			{ObjectP[Model[Container, Vessel, "50mL Tube"]], ObjectP[Model[Container, Vessel, "1L Glass Bottle"]]},
			Variables :> {options}
		],
		Example[{Options, SolventLabel, "Specify a string label for the specified solvent:"},
			protocol = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], SolventLabel -> "FillToVolume solvent label 1"];
			Download[protocol, BatchedUnitOperations[[1]][SolventLabel][[1]]],
			"FillToVolume solvent label 1",
			Variables :> {protocol}
		],
		Example[{Options, SolventContainerLabel, "Specify a string label for the specified solvent's container:"},
			protocol = ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 25 Milliliter}, Solvent -> {Model[Sample, "Milli-Q water"], Automatic}, SolventContainerLabel -> {"solvent container 1", "solvent container 2"}];
			Download[protocol, BatchedUnitOperations[SolventContainerLabel][[1]]],
			{"solvent container 1", "solvent container 2"},
			Variables :> {protocol}
		],
		Example[{Options, Tolerance, "Specify the allowed tolerance of the final volume.  If not specified, automatically set to the Precision field of the volumetric flask, or according to the most recent volume calibration of the ultrasonic sensor:"},
			options = ExperimentFillToVolume[
				{
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]
				},
				{
					100 Milliliter,
					100 Milliliter,
					30 Milliliter
				},
				Solvent -> {Model[Sample, "Milli-Q water"], Model[Sample, "Toluene, Reagent Grade"], Model[Sample, "Milli-Q water"]},
				Tolerance -> {
					0.1 Milliliter,
					Automatic,
					Automatic
				},
				Output -> Options
			];
			Lookup[options, Tolerance],
			{
				0.1 Milliliter,
				0.08 Milliliter,
				UnitsP[Milliliter]
			},
			Variables :> {options}
		],
		Example[{Options, SolventStorageCondition, "Specify the storage condition of the solvents used perform this fill to volume:"},
			protocol = ExperimentFillToVolume[
				{
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 3 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]
				},
				{
					100 Milliliter,
					25 Milliliter,
					30 Milliliter
				},
				Solvent -> {Model[Sample, "Milli-Q water"], Model[Sample, "Tetrahydrofuran, Anhydrous"], Model[Sample, "Milli-Q water"]},
				SolventStorageCondition -> {Null, Disposal, Refrigerator}
			];
			Download[protocol, SolventStorage],
			{Null, Disposal, Refrigerator},
			Variables :> {protocol}
		],
		Example[{Options, SamplesOutStorageCondition, "Specify the storage condition of the SamplesOut of this fill to volume:"},
			protocol = ExperimentFillToVolume[
				{
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 3 for ExperimentFillToVolume" <> $SessionUUID],
					Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]
				},
				{
					100 Milliliter,
					25 Milliliter,
					30 Milliliter
				},
				Solvent -> {Model[Sample, "Milli-Q water"], Model[Sample, "Tetrahydrofuran, Anhydrous"], Model[Sample, "Milli-Q water"]},
				SamplesOutStorageCondition -> {Null, Freezer, Refrigerator}
			];
			Download[protocol, SamplesOutStorage],
			{Null, Freezer, Refrigerator},
			Variables :> {protocol}
		],
		(* Shared options with ExperimentTransfer *)
		Example[{Options, Instrument, "Specify the instrument with which to perform the transfer. Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another instrument may be used:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Instrument -> Model[Container, GraduatedCylinder, "100 mL polypropylene graduated cylinder"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Model[Container, GraduatedCylinder, "100 mL polypropylene graduated cylinder"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "For Volumetric FillToVolume, resolve Instrument to a GraduatedCylinder for large volume transfer and Null to a small volume transfer (meaning that FillToVolume will directly use the Disposable Transfer Pipet:"},
			options1 = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Output -> Options];
			options2 = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], PreparatoryUnitOperations -> {Transfer[Source->Model[Sample, "Milli-Q water"],Destination->Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],Amount->95Milliliter]}, Output -> Options];
			{Lookup[options1, Instrument], Lookup[options2, Instrument]},
			{
				ObjectP[Model[Container, GraduatedCylinder, "250 mL polypropylene graduated cylinder"]],
				Null
			},
			Variables :> {options1,options2}
		],
		Example[{Options, TransferEnvironment, "Specify the transfer environment in which to perform the transfer. Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another instrument may be used:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], TransferEnvironment -> Model[Container, Bench, "Emerald two-shelf bench frame"], Output -> Options];
			Lookup[options, TransferEnvironment],
			ObjectP[Model[Container, Bench, "Emerald two-shelf bench frame"]],
			Variables :> {options}
		],
		Example[{Options, TransferEnvironment, "Resolve TransferEnvironment to the transfer bench (with IR probe) when volumetric flask FillToVolume is requested:"},
			protocol = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]];
			Download[protocol, BatchedUnitOperations[TransferEnvironment]],
			{{ObjectP[Model[Container, Bench, "Emerald two-shelf bench frame for Ohaus EX124 analytical balance"]]}},
			Variables :> {protocol}
		],
		Example[{Options, TransferEnvironment, "Resolve TransferEnvironment to the fume hood (with IR probe) when volumetric flask FillToVolume is requested on a :"},
			protocol = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Isopropanol"]];
			Download[protocol, BatchedUnitOperations[[1]][TransferUnitOperations][[1]][TransferEnvironment]],
			{ObjectP[Model[Instrument, FumeHood, "Labconco Premier 6 Foot Variant A"]]},
			Variables :> {protocol}
		],
		Example[{Options, Tips, "Specify the tips with which to perform the transfer. Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another tip may be used for the final transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], Output -> Options];
			Lookup[options, Tips],
			ObjectP[Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"]],
			Variables :> {options}
		],
		Example[{Options, Tips, "For Volumetric FillToVolume, resolve Tips to the Disposable Transfer Pipet:"},
			options = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Method -> Volumetric, Output -> Options];
			Lookup[options, {Tips, TipType,TipMaterial}],
			(* VWR Disposable Transfer Pipet *)
			{ObjectP[Model[Item, Consumable, "id:bq9LA0J1xmBd"]], Normal, Polyethylene},
			Variables :> {options}
		],
		Example[{Options, TipType, "Specify the type of tip with which to perform the transfer. Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another tip may be used for the final transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], TipType -> Barrier, Output -> Options];
			Lookup[options, TipType],
			Barrier,
			Variables :> {options}
		],
		Example[{Options, TipMaterial, "Specify the material of the tip with which to perform the transfer. Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another tip may be used for the final transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], TipMaterial -> Glass, Output -> Options];
			Lookup[options, TipMaterial],
			Glass,
			Variables :> {options}
		],
		Example[{Options, ReversePipetting, "Specify if additional solvent should be aspirated (past the first stop of the pipette) to reduce the chance of bubble formation when dispensing into the destination:"},
			options = Quiet[ExperimentFillToVolume[Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 0.5 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], ReversePipetting -> True, Output -> Options], Warning::ReversePipettingSampleVolume];
			Lookup[options, ReversePipetting],
			True,
			Variables :> {options}
		],
		Example[{Options, Needle, "Specify the needle with which to perform the transfer.  Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another needle may be used for the final transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 0.5 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Needle -> Model[Item,Needle,"Reusable Stainless Steel Non-Coring 6 in x 18G Needle"], Output -> Options];
			Lookup[options, Needle],
			ObjectP[Model[Item,Needle,"Reusable Stainless Steel Non-Coring 6 in x 18G Needle"]],
			Variables :> {options}
		],
		Example[{Options, Funnel, "Specify the funnel with which to perform the transfer.  Note that this refers to the _first_ transfer; if transferring a large amount and then transferring a small amount to reach the proper volume, another funnel may be used for the final transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Funnel -> Model[Part, Funnel, "9mm Stem OD, 180mm Height - Plastic Wet Funnel"], Output -> Options];
			Lookup[options, Funnel],
			ObjectP[Model[Part, Funnel, "9mm Stem OD, 180mm Height - Plastic Wet Funnel"]],
			Variables :> {options}
		],
		Example[{Options, HandPump, "Specify the hand pump to use to obtain the specified solvent:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Toluene, Reagent Grade"], HandPump -> Model[Part, HandPump, "Polyethylene Carboy Hand Pump"], Output -> Options];
			Lookup[options, HandPump],
			ObjectP[Model[Part, HandPump, "Polyethylene Carboy Hand Pump"]],
			Variables :> {options}
		],
		Example[{Options, UnsealHermeticSource, "Specify whether the solvent source's hermetic container should be unsealed before the solvent is transferred out of it:"},
			options = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID], 25 Milliliter, Solvent -> Model[Sample, "Tetrahydrofuran, Anhydrous"], UnsealHermeticSource -> True, Output -> Options];
			Lookup[options, UnsealHermeticSource],
			True,
			Variables :> {options}
		],
		Example[{Options, BackfillNeedle, "Specify the needle used to backfill the solvent's hermetic container with BackfillGas:"},
			options = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID], 25 Milliliter, Solvent -> Model[Sample, "Tetrahydrofuran, Anhydrous"], BackfillNeedle -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"], Output -> Options];
			Lookup[options, BackfillNeedle],
			ObjectP[Model[Item, Needle, "21g x 1 Inch Single-Use Needle"]],
			Variables :> {options}
		],
		Example[{Options, BackfillGas, "Specify the inert gas that is used to equalize the pressure in the solvent's hermetic container while the transfer out occurs:"},
			options = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID], 25 Milliliter, Solvent -> Model[Sample, "Tetrahydrofuran, Anhydrous"], BackfillGas -> Argon, Output -> Options];
			Lookup[options, BackfillGas],
			Argon,
			Variables :> {options}
		],
		Example[{Options, TipRinse, "Indicates if the Tips should first be rinsed with a TipRinseSolution before they are used to aspirate from the solvent sample:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], TipRinse -> True, Output -> Options];
			Lookup[options, TipRinse],
			True,
			Variables :> {options}
		],
		Example[{Options, TipRinseSolution, "The solution that the Tips should be rinsed before they are used to aspirate from the solvent sample:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], TipRinseSolution -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, TipRinseSolution],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, TipRinseVolume, "The volume of the solution that the Tips should be rinsed before they are used to aspirate from the solvent sample:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], TipRinseVolume -> 10 Milliliter, Output -> Options];
			Lookup[options, TipRinseVolume],
			EqualP[10 Milliliter],
			Variables :> {options}
		],
		Example[{Options, NumberOfTipRinses, "The number of times that the Tips should be rinsed before they are used to aspirate from the solvent sample:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], NumberOfTipRinses -> 3, Output -> Options];
			Lookup[options, NumberOfTipRinses],
			EqualP[3],
			Variables :> {options}
		],
		Example[{Options, AspirationMix, "Indicates if mixing should occur during aspiration from the solvent sample:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Tips -> Model[Item, Tips, "50 mL glass barrier serological pipets, sterile"], AspirationMix -> True, Output -> Options];
			Lookup[options, AspirationMix],
			True,
			Variables :> {options}
		],
		Example[{Options, AspirationMixType, "The type of mixing that should occur during aspiration:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], AspirationMixType -> Swirl, Output -> Options];
			Lookup[options, AspirationMixType],
			Swirl,
			Variables :> {options}
		],
		Example[{Options, NumberOfAspirationMixes, "The number of times that the solvent sample should be mixed during aspiration:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], NumberOfAspirationMixes -> 10, Output -> Options];
			Lookup[options, NumberOfAspirationMixes],
			EqualP[10],
			Variables :> {options}
		],
		Example[{Options, DispenseMix, "Indicates if mixing should occur after the solvent is dispensed into the destination container:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], DispenseMix -> True, Output -> Options];
			Lookup[options, DispenseMix],
			True,
			Variables :> {options}
		],
		Example[{Options, DispenseMixType, "The type of mixing that should occur after the solvent is dispensed into the destination container:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], DispenseMixType -> Swirl, Output -> Options];
			Lookup[options, DispenseMixType],
			Swirl,
			Variables :> {options}
		],
		Example[{Options, NumberOfDispenseMixes, "The number of times that the destination sample should be mixed after the sample is dispensed into the destination container:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], NumberOfDispenseMixes -> 10, Output -> Options];
			Lookup[options, NumberOfDispenseMixes],
			EqualP[10],
			Variables :> {options}
		],
		Example[{Options, IntermediateDecant, "Indicates if the sample will need to be decanted into an intermediate container in order for the precise amount requested to be transferred via pipette:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, StockSolution, "70% Ethanol"], IntermediateDecant -> True, Output -> Options];
			Lookup[options, IntermediateDecant],
			True,
			Variables :> {options}
		],
		Example[{Options, IntermediateContainer, "The container that the sample will be decanted into in order to make the final transfer via pipette into the final destination:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, StockSolution, "70% Ethanol"], IntermediateContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, IntermediateContainer],
			ObjectP[Model[Container, Vessel, "50mL Tube"]],
			Variables :> {options}
		],
		Example[{Options, IntermediateContainer, "For Volumetric FillToVolume, resolve IntermediateContainer for Disposable Transfer Pipet transfer so that it can reach the bottom of the container:"},
			options1 = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Output -> Options];
			options2 = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Object[Sample, "Example solvent sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], PreparatoryUnitOperations -> {Transfer[Source->Model[Sample, "Milli-Q water"],Destination->Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],Amount->95Milliliter]}, Output -> Options];
			options3 = ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Solvent -> Object[Sample, "Example solvent sample 2 for ExperimentFillToVolume tests" <> $SessionUUID], PreparatoryUnitOperations -> {Transfer[Source->Model[Sample, "Milli-Q water"],Destination->Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],Amount->95Milliliter]}, Output -> Options];
			{
				Lookup[options1, IntermediateContainer],
				Lookup[options2, IntermediateContainer],
				Lookup[options3, IntermediateContainer]
			},
			{
				(* Graduated Cylinder *)
				ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]],
				(* Small InternalDepth Solvent Container *)
				Null,
				(* Large InternalDepth Solvent Container *)
				ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]] (*Model[Container, Vessel, "20mL Pyrex Beaker"]*)
			},
			Variables :> {options1,options2}
		],
		Example[{Options, IntermediateFunnel, "The funnel that is used to guide the solvent into the intermediate container when pouring:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, StockSolution, "70% Ethanol"], IntermediateFunnel -> Model[Part, Funnel, "9mm Stem OD, 180mm Height - Plastic Wet Funnel"], Output -> Options];
			Lookup[options, IntermediateFunnel],
			ObjectP[Model[Part, Funnel, "9mm Stem OD, 180mm Height - Plastic Wet Funnel"]],
			Variables :> {options}
		],

		Example[{Options, SourceTemperature, "Indicates the temperature at which the solvent should be at during the transfer:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], SourceTemperature -> 40 Celsius, Output -> Options];
			Lookup[options, SourceTemperature],
			40 Celsius,
			Variables :> {options}
		],
		Example[{Options, SourceEquilibrationTime, "Indicates the duration of time for which the solvent will be heated/cooled to the target SourceTemperature:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], SourceTemperature -> 40 Celsius, SourceEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, SourceEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, MaxSourceEquilibrationTime, "Indicates the maximum duration of time for which the solvents will be heated/cooled to the target SourceTemperature, if they do not reach the SourceTemperature after SourceEquilibrationTime:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				SourceTemperature -> 40 Celsius,
				SourceEquilibrationTime -> 10 Minute,
				MaxSourceEquilibrationTime -> 30 Minute,
				Output -> Options
			];
			Lookup[options, MaxSourceEquilibrationTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, SourceEquilibrationCheck, "Indictes the method by which to verify the temperature of the solvent before the transfer is performed:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				SourceTemperature -> 40 Celsius,
				SourceEquilibrationTime -> 10 Minute,
				SourceEquilibrationCheck -> ImmersionThermometer,
				Output -> Options
			];
			Lookup[options, SourceEquilibrationCheck],
			ImmersionThermometer,
			Variables :> {options}
		],
		Example[{Options, DestinationTemperature, "Indicates the temperature at which the destination sample should be at during the transfer:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				DestinationTemperature -> 40 Celsius,
				Output -> Options
			];
			Lookup[options, DestinationTemperature],
			40 Celsius,
			Variables :> {options}
		],
		Example[{Options, DestinationEquilibrationTime, "Indicates the duration of time for which the solvent will be heated/cooled to the target DestinationTemperature:"},
			options = ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], DestinationTemperature -> 40 Celsius, DestinationEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, DestinationEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, MaxDestinationEquilibrationTime, "Indicates the maximum duration of time for which the solvents will be heated/cooled to the target DestinationTemperature, if they do not reach the DestinationTemperature after DestinationEquilibrationTime:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				DestinationTemperature -> 40 Celsius,
				DestinationEquilibrationTime -> 10 Minute,
				MaxDestinationEquilibrationTime -> 30 Minute,
				Output -> Options
			];
			Lookup[options, MaxDestinationEquilibrationTime],
			30 Minute,
			Variables :> {options}
		],
		Example[{Options, DestinationEquilibrationCheck, "Indictes the method by which to verify the temperature of the solvent before the transfer is performed:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				DestinationTemperature -> 40 Celsius,
				DestinationEquilibrationTime -> 10 Minute,
				DestinationEquilibrationCheck -> ImmersionThermometer,
				Output -> Options
			];
			Lookup[options, DestinationEquilibrationCheck],
			ImmersionThermometer,
			Variables :> {options}
		],
		Example[{Options, SterileTechnique, "Indicates if sterile instruments and a sterile transfer environment should be used for the transfer:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				100 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				SterileTechnique -> True,
				Output -> Options
			];
			Lookup[options, SterileTechnique],
			True,
			Variables :> {options}
		],
		Example[{Options, RNaseFreeTechnique, "Indicates that RNase free technique should be followed when performing the transfer (spraying RNase away on surfaces, using RNaseFree tips, etc):"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				RNaseFreeTechnique -> True,
				Output -> Options
			];
			Lookup[options, RNaseFreeTechnique],
			True,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates whether the output sample should be imaged after filling to volume:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				ImageSample -> True,
				Output -> Options
			];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates whether the output sample should be imaged after filling to volume:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				ImageSample -> True,
				Output -> Options
			];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates whether the output sample should be weighed after filling to volume:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				MeasureWeight -> True,
				Output -> Options
			];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates whether the output sample should be volume-measured after completion of the filling to volume:"},
			options = ExperimentFillToVolume[
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				30 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				MeasureVolume -> True,
				Output -> Options
			];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, Name, "Indicate the name of the protocol object by specifying the Name option:"},
			ExperimentFillToVolume[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter}, Name -> "Test ExperimentFillToVolume protocol object", Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}],
			Object[Protocol, FillToVolume, "Test ExperimentFillToVolume protocol object"]
		],
		Example[{Options, Template, "Inherit options from the specified template:"},
			protocol = ExperimentFillToVolume[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter}, Template -> Object[Protocol, FillToVolume, "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID]];
			Download[protocol, {Solvents, BatchedUnitOperations[DestinationWell]}],
			{{ObjectP[Model[Sample, "Milli-Q water"]]}, {{"A1"}}},
			Variables :> {protocol}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentFillToVolume[
				Model[Sample, "Sodium Chloride"],
				40 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 10 Milligram,
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
				{ObjectP[Model[Sample, "Sodium Chloride"]]},
				{ObjectP[Model[Container, Vessel, "50mL Tube"]]},
				{EqualP[10 Milligram]},
				{"A1"},
				{_String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared and upload the PreparatoryUnitOperations to protocol:"},
			protocol = ExperimentFillToVolume[
				Model[Sample, "Sodium Chloride"],
				40 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 10 Milligram
			];
			Download[protocol, PreparatoryUnitOperations],
			{ManualSamplePreparation[_LabelSample]},
			Variables :> {protocol}
		],
		Example[{Options, MaxNumberOfOverfillingRepreparations, "When the inputs of ExperimentFillToVolume are all Model[Sample], resolve MaxNumberOfOverfillingRepreparations to 3 to allow re-preparation in the event of overfilling:"},
			protocol = ExperimentFillToVolume[
				Model[Sample, "Sodium Chloride"],
				40 Milliliter,
				Solvent -> Model[Sample, "Milli-Q water"],
				PreparedModelContainer -> Model[Container, Vessel, "50mL Tube"],
				PreparedModelAmount -> 10 Milligram
			];
			Download[protocol, MaxNumberOfOverfillingRepreparations],
			3,
			Variables :> {protocol}
		],
		(* Messages *)
		Example[{Messages, "DuplicateName", "If the specified name is already taken, an error is thrown:"},
			ExperimentFillToVolume[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}, Name -> "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[{Messages, "ReplicateFillToVolumeSamples", "If sample replicates (or sample/container combinations that correspond to the same positions in the container) are provided, an error is thrown:"},
			ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {30 Milliliter, 30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", "A1"}],
			$Failed,
			Messages :> {Error::ReplicateFillToVolumeSamples, Error::InvalidInput}
		],
		Example[{Messages, "MissingDestinationWell", "If the specified container has more than one position and and the DestinationWell option is not specified, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID], 1 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::MissingDestinationWell, Error::InvalidOption}
		],
		Example[{Messages, "SampleNotInDestinationWell", "If DestinationWell is specified to a position that the sample is not currently in, an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 1 Milliliter, DestinationWell -> "B1", Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::SampleNotInDestinationWell, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeEmptyPosition", "If DestinationWell is specified to a position that is empty, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID], 1 Milliliter, DestinationWell -> "B1", Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::FillToVolumeEmptyPosition, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeIncompatibleMethod", "Method must only be set to Volumetric if in a volumetric flask, or else an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 50 Milliliter, Method -> Volumetric, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::FillToVolumeIncompatibleMethod, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeIncompatibleMethod", "Method must only be set to Volumetric if in a volumetric flask, or else an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID], 100 Milliliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::FillToVolumeIncompatibleMethod, Error::FillToVolumeUltrasonicIncompatibleContainer, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeSolventDefaulted", "If Solvent is not set and the Solvent field of the input samples is not populated, defaults to Milli-Q water and throws a warning:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter],
			ObjectP[Object[Protocol, FillToVolume]],
			Messages :> {Warning::FillToVolumeSolventDefaulted}
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleSample", "If the input sample has UltrasonicIncompatible set to True and Method is set to Ultrasonic, an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 2 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Method -> Ultrasonic],
			$Failed,
			Messages :> {Error::FillToVolumeUltrasonicIncompatibleSample, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleSample", "If the specified Solvent has UltrasonicIncompatible set to True and Method is set to Ultrasonic, an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Methanol"], Method -> Ultrasonic],
			$Failed,
			Messages :> {Error::FillToVolumeUltrasonicIncompatibleSample, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleContainer", "If the specified sample is in a container that cannot be measured ultrasonically because UltrasonicIncompatible -> True, but Method is set to Ultrasonic, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolume" <> $SessionUUID], 20 Milliliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::FillToVolumeUltrasonicIncompatibleContainer, Error::InvalidOption}
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleContainer", "If the specified sample is in a container that cannot be measured ultrasonically because UltrasonicIncompatible -> Null but VolumeCalibrations is empty, but Method is set to Ultrasonic, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Vessel, "Example container 3 for ExperimentFillToVolume tests" <> $SessionUUID], 500 Microliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::FillToVolumeUltrasonicIncompatibleContainer, Error::InvalidOption}
		],
		Example[{Messages, "ToleranceTooSmall", "If the specified Tolerance is less than the minimum possible for the specified container, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID], 100 Milliliter, Tolerance -> 0.05 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::ToleranceTooSmall, Error::InvalidOption}
		],
		Example[{Messages, "SampleVolumeAboveRequestedVolume", "If the specified volume to fill to is less than the volume of the input sample, an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 2 for ExperimentFillToVolume tests" <> $SessionUUID], 15 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Method -> Ultrasonic],
			$Failed,
			Messages :> {Error::FillToVolumeUltrasonicIncompatibleSample, Error::SampleVolumeAboveRequestedVolume, Error::InvalidInput, Error::InvalidOption}
		],
		Example[{Messages, "VolumetricWrongVolume", "If the volume specified does not correspond to the resolved volumetric flask, an error is thrown:"},
			ExperimentFillToVolume[Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID], 80 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Error::VolumetricWrongVolume, Error::InvalidOption}
		],
		Example[{Messages, "TransferEnvironmentUltrasonicForbidden", "If Method -> Ultrasonic and TransferEnvironment is set to a GlobeBox or BiosafetyCabinet, an error is thrown:"},
			ExperimentFillToVolume[Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "2-Methyltetrahydrofuran, Anhydrous"], Method -> Ultrasonic, UnsealHermeticSource -> True, TransferEnvironment -> Model[Instrument, GloveBox, "NexGen Glove Box"]],
			$Failed,
			Messages :> {Error::TransferEnvironmentUltrasonicForbidden, Error::InvalidOption}
		],
		Example[{Messages, "AliquotRequired", "If the requested fill volume exceeds the MaxVolume of the container, automatic aliquoting is performed and a warning is thrown:"},
			ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {51 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"]],
			ObjectP[Object[Protocol, FillToVolume]],
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the requested fill volume exceeds the MaxVolume of the container, automatic aliquoting is performed and a warning is thrown:",
			Download[ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID]}, {51 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"]], AliquotSamplePreparation[[All,1]]],
			{True, False},
			Messages :> {Warning::AliquotRequired}
		],
		Test["If the transfers use the same source, consolidate the IntermediateContainer:",
			protocol=ExperimentFillToVolume[
				{
					Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
					Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID]
				},
				{
					100 Milliliter,
					25 Milliliter
				},
				Solvent -> Model[Sample,"Milli-Q water"]
			];
			requiredObjects = Flatten[Quiet[Download[protocol,RequiredResources[[All,1]][Models]]]];
			numberOfIntermediateContainers = Count[requiredObjects,ObjectP[Model[Container, Vessel, "id:kEJ9mqaVPPD8"]]],
			1,
			Variables:>{protocol,requiredObjects,numberOfIntermediateContainers}
		],
		Example[{Messages, "InvalidTransferWellSpecification", "If the requested fill volume exceeds the MaxVolume of the container and automatic aliquoting results in a mismatch between the specified position and post-aliquot position, return $Failed:"},
			ExperimentFillToVolume[{Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID], {"A8", Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID][Container][Object]}}, {30 Milliliter, 3 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"]],
			$Failed,
			Messages :> {Warning::AliquotRequired, Error::InvalidTransferWellSpecification, Error::InvalidInput}
		],
		Example[{Messages, "InvalidMaxNumberOfOverfillingRepreparations", "When the inputs of ExperimentFillToVolume are not all Model[Sample], disallow MaxNumberOfOverfillingRepreparations option since we cannot re-do FillToVolume for an Object[Sample]:"},
			ExperimentFillToVolume[
				{
					Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
					Model[Sample,"Milli-Q water"]
				},
				{
					100 Milliliter,
					25 Milliliter
				},
				Solvent -> Model[Sample,"Milli-Q water"],
				MaxNumberOfOverfillingRepreparations -> 2
			],
			$Failed,
			Messages :> {Error::InvalidMaxNumberOfOverfillingRepreparations, Error::InvalidOption},
			Variables :> {protocol}
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolSetUp :> (
		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 3 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example solvent container 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example solvent container 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example solvent sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example solvent sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID],
				Object[Protocol, FillToVolume, "Test ExperimentFillToVolume protocol object"],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					exampleBench,
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, volumetricFlask3, ultrasonicIncompatible1, plate1, solventContainer1, solventContainer2,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, ultrasonicIncompatibleSample1, volumetricFlaskSample2, plateSample1, volumetricFlaskSample3, solventSample1, solventSample2,
					templateProtocol,
					allObjs
				},

				exampleBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Example bench for ExperimentFillToVolume tests" <> $SessionUUID, DeveloperObject -> True|>];
				{
					tube1,
					tube2,
					tube3,
					volumetricFlask1,
					volumetricFlask2,
					volumetricFlask3,
					ultrasonicIncompatible1,
					plate1,
					solventContainer1,
					solventContainer2
				} = UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1mg brown thin tube"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "25 mL Glass Volumetric Flask"],
						Model[Container, Vessel, "T25 EasYFlask, TC Surface, Filter Cap"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1L Glass Bottle"]
					},
					{
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example container 2 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example container 3 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID,
						"Example volumetric flask 2 for ExperimentFillToVolume" <> $SessionUUID,
						"Example volumetric flask 3 for ExperimentFillToVolume" <> $SessionUUID,
						"Example UltrasonicIncompatible container 1 for ExperimentFillToVolume" <> $SessionUUID,
						"Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example solvent container 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example solvent container 2 for ExperimentFillToVolume tests" <> $SessionUUID
					}
				];
				{
					tubeSample1,
					tubeSample2,
					tubeSample3,
					volumetricFlaskSample1,
					volumetricFlaskSample2,
					volumetricFlaskSample3,
					ultrasonicIncompatibleSample1,
					plateSample1,
					solventSample1,
					solventSample2
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Methanol"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", volumetricFlask1},
						{"A1", volumetricFlask2},
						{"A1", volumetricFlask3},
						{"A1", ultrasonicIncompatible1},
						{"A8", plate1},
						{"A1", solventContainer1},
						{"A1", solventContainer2}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example sample 2 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example sample 3 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example ultrasonic incompatible sample 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example solvent sample 1 for ExperimentFillToVolume tests" <> $SessionUUID,
						"Example solvent sample 2 for ExperimentFillToVolume tests" <> $SessionUUID
					},
					InitialAmount -> {
						500 Milligram,
						20 Milliliter,
						1 Milligram,
						500 Milligram,
						1 Milliliter,
						1 Milliliter,
						500 Milligram,
						10 Milligram,
						40 Milliliter,
						950 Milliliter
					}
				];

				(* make a template protocol *)
				templateProtocol = ExperimentFillToVolume[tubeSample1, 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Name -> "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID];

				allObjs = Cases[Flatten[{
					tube1, tube2, tube3,tube4, volumetricFlask1, volumetricFlask2, volumetricFlask3, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, tubeSample4,volumetricFlaskSample1, volumetricFlaskSample2, volumetricFlaskSample3,
					ultrasonicIncompatibleSample1, plateSample1,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]],
					<|Object -> tubeSample1, Anhydrous -> True|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 3 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolume" <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example solvent container 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Container, Vessel, "Example solvent container 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 3 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example solvent sample 1 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Sample, "Example solvent sample 2 for ExperimentFillToVolume tests" <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolume Template Protocol 1" <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];



(* ::Subsection::Closed:: *)
(*ExperimentFillToVolumeOptions*)

DefineTests[ExperimentFillToVolumeOptions,
	{
		Example[{Basic, "Given samples, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ExperimentFillToVolumeOptions[{Object[Sample, "Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Basic, "Given containers, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ExperimentFillToVolumeOptions[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options for each sample as a list:"},
			ExperimentFillToVolumeOptions[{Object[Sample, "Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[{Options, OutputFormat, "Return the resolved options for each sample as a table:"},
			ExperimentFillToVolumeOptions[{Object[Sample, "Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}],
			Graphics_
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolumeOptions Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolumeOptions Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					exampleBench,
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, ultrasonicIncompatibleSample1, volumetricFlaskSample2, plateSample1,
					templateProtocol,
					allObjs
				},

				exampleBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Example bench for ExperimentFillToVolumeOptions tests " <> $SessionUUID, DeveloperObject -> True|>];
				{
					tube1,
					tube2,
					tube3,
					volumetricFlask1,
					volumetricFlask2,
					ultrasonicIncompatible1,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1mg brown thin tube"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, "T25 EasYFlask, TC Surface, Filter Cap"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example container 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example container 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example container 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example volumetric flask 1 for ExperimentFillToVolumeOptions " <> $SessionUUID,
						"Example volumetric flask 2 for ExperimentFillToVolumeOptions " <> $SessionUUID,
						"Example UltrasonicIncompatible container 1 for ExperimentFillToVolumeOptions " <> $SessionUUID,
						"Example plate 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID
					}
				];
				{
					tubeSample1,
					tubeSample2,
					tubeSample3,
					volumetricFlaskSample1,
					volumetricFlaskSample2,
					ultrasonicIncompatibleSample1,
					plateSample1
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Methanol"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", volumetricFlask1},
						{"A1", volumetricFlask2},
						{"A1", ultrasonicIncompatible1},
						{"A8", plate1}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example sample 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example volumetric flask sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example volumetric flask sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example ultrasonic incompatible sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID,
						"Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID
					},
					InitialAmount -> {
						500 Milligram,
						20 Milliliter,
						1 Milligram,
						500 Milligram,
						1 Milliliter,
						500 Milligram,
						10 Milligram
					}
				];

				(* make a template protocol *)
				templateProtocol = ExperimentFillToVolume[tubeSample1, 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Name -> "ExperimentFillToVolumeOptions Template Protocol 1 " <> $SessionUUID];

				allObjs = Cases[Flatten[{
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, volumetricFlaskSample2, ultrasonicIncompatibleSample1, plateSample1,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]],
					<|Object -> tubeSample1, Anhydrous -> True|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolumeOptions " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolumeOptions tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolumeOptions Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolumeOptions Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFillToVolumeQ*)

DefineTests[ValidExperimentFillToVolumeQ,
	{
		Example[{Basic, "Given samples, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ValidExperimentFillToVolumeQ[{Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], Object[Sample, "Example plate sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}],
			True
		],
		Example[{Basic, "Given containers, volumes, and solvents, create a protocol object to fill the samples to the specified volume:"},
			ValidExperimentFillToVolumeQ[{Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}],
			True
		],
		Example[{Options,Verbose,"Indicate whether all tests, no tests, or failures only are shown:"},
			ValidExperimentFillToVolumeQ[{Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}, Name -> "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID],
			False
		],
		(* Messages *)
		Example[{Messages, "DuplicateName", "If the specified name is already taken, an error is thrown:"},
			ValidExperimentFillToVolumeQ[{Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}, Name -> "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID],
			False
		],
		Example[{Messages, "ReplicateFillToVolumeSamples", "If sample replicates (or sample/container combinations that correspond to the same positions in the container) are provided, an error is thrown:"},
			ValidExperimentFillToVolumeQ[{Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID]}, {30 Milliliter, 30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", "A1"}],
			False
		],
		Example[{Messages, "MissingDestinationWell", "If the specified container has more than one position and and the DestinationWell option is not specified, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Plate, "Example plate 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 1 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "SampleNotInDestinationWell", "If DestinationWell is specified to a position that the sample is not currently in, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example plate sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 1 Milliliter, DestinationWell -> "B1", Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "FillToVolumeEmptyPosition", "If DestinationWell is specified to a position that is empty, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Plate, "Example plate 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 1 Milliliter, DestinationWell -> "B1", Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "FillToVolumeIncompatibleMethod", "Method must only be set to Volumetric if in a volumetric flask, or else an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 30 Milliliter, Method -> Volumetric, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "FillToVolumeIncompatibleMethod", "Method must only be set to Volumetric if in a volumetric flask, or else an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example volumetric flask sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 100 Milliliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "FillToVolumeSolventDefaulted", "If Solvent is not set and the Solvent field of the input samples is not populated, defaults to Milli-Q water and throws a warning:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 30 Milliliter],
			True
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleSample", "If the input sample has UltrasonicIncompatible set to True and Method is set to Ultrasonic, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Method -> Ultrasonic],
			False
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleSample", "If the specified Solvent has UltrasonicIncompatible set to True and Method is set to Ultrasonic, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "Methanol"], Method -> Ultrasonic],
			False
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleContainer", "If the specified sample is in a container that cannot be measured ultrasonically because UltrasonicIncompatible -> True, but Method is set to Ultrasonic, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID], 20 Milliliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "FillToVolumeUltrasonicIncompatibleContainer", "If the specified sample is in a container that cannot be measured ultrasonically because UltrasonicIncompatible -> Null but VolumeCalibrations is empty, but Method is set to Ultrasonic, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Vessel, "Example container 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 500 Microliter, Method -> Ultrasonic, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "ToleranceTooSmall", "If the specified Tolerance is less than the minimum possible for the specified container, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID], 100 Milliliter, Tolerance -> 0.05 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "VolumetricWrongVolume", "If the specified Tolerance is less than the minimum possible for the specified container, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID], 80 Milliliter, Solvent -> Model[Sample, "Milli-Q water"]],
			False
		],
		Example[{Messages, "TransferEnvironmentUltrasonicForbidden", "If Method -> Ultrasonic and TransferEnvironment is set to a GlobeBox or BiosafetyCabinet, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 30 Milliliter, Solvent -> Model[Sample, "2-Methyltetrahydrofuran, Anhydrous"], UnsealHermeticSource -> True, Method -> Ultrasonic, TransferEnvironment -> Model[Instrument, GloveBox, "NexGen Glove Box"]],
			False
		],
		Example[{Messages, "SampleVolumeAboveRequestedVolume", "If the specified volume to fill to is less than the volume of the input sample, an error is thrown:"},
			ValidExperimentFillToVolumeQ[Object[Sample, "Example sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID], 15 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Method -> Ultrasonic],
			False
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					exampleBench,
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, ultrasonicIncompatibleSample1, volumetricFlaskSample2, plateSample1,
					templateProtocol,
					allObjs
				},

				exampleBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Example bench for ValidExperimentFillToVolumeQ tests " <> $SessionUUID, DeveloperObject -> True|>];
				{
					tube1,
					tube2,
					tube3,
					volumetricFlask1,
					volumetricFlask2,
					ultrasonicIncompatible1,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1mg brown thin tube"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, "T25 EasYFlask, TC Surface, Filter Cap"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example container 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example container 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example volumetric flask 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID,
						"Example volumetric flask 2 for ValidExperimentFillToVolumeQ " <> $SessionUUID,
						"Example UltrasonicIncompatible container 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID,
						"Example plate 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID
					}
				];
				{
					tubeSample1,
					tubeSample2,
					tubeSample3,
					volumetricFlaskSample1,
					volumetricFlaskSample2,
					ultrasonicIncompatibleSample1,
					plateSample1
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Methanol"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", volumetricFlask1},
						{"A1", volumetricFlask2},
						{"A1", ultrasonicIncompatible1},
						{"A8", plate1}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example sample 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example volumetric flask sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example volumetric flask sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example ultrasonic incompatible sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID,
						"Example plate sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID
					},
					InitialAmount -> {
						500 Milligram,
						20 Milliliter,
						1 Milligram,
						500 Milligram,
						1 Milliliter,
						500 Milligram,
						10 Milligram
					}
				];

				(* make a template protocol *)
				templateProtocol = ExperimentFillToVolume[tubeSample1, 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Name -> "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID];

				allObjs = Cases[Flatten[{
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, volumetricFlaskSample2, ultrasonicIncompatibleSample1, plateSample1,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]],
					<|Object -> tubeSample1, Anhydrous -> True|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ValidExperimentFillToVolumeQ " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ValidExperimentFillToVolumeQ tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ValidExperimentFillToVolumeQ Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentFillToVolumePreview*)

DefineTests[ExperimentFillToVolumePreview,
	{
		Example[{Basic, "Always returns Null:"},
			ExperimentFillToVolumePreview[{Object[Sample, "Example sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID], Object[Sample, "Example plate sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID]}, {30 Milliliter, 1 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1", Automatic}],
			Null
		],
		Example[{Basic, "Always returns Null:"},
			ExperimentFillToVolumePreview[{Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID]}, {30 Milliliter}, Solvent -> Model[Sample, "Milli-Q water"], DestinationWell -> {"A1"}],
			Null
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolumePreview Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolumePreview Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					exampleBench,
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, ultrasonicIncompatibleSample1, volumetricFlaskSample2, plateSample1,
					templateProtocol,
					allObjs
				},

				exampleBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Example bench for ExperimentFillToVolumePreview tests " <> $SessionUUID, DeveloperObject -> True|>];
				{
					tube1,
					tube2,
					tube3,
					volumetricFlask1,
					volumetricFlask2,
					ultrasonicIncompatible1,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1mg brown thin tube"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, "T25 EasYFlask, TC Surface, Filter Cap"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example container 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example container 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example container 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example volumetric flask 1 for ExperimentFillToVolumePreview " <> $SessionUUID,
						"Example volumetric flask 2 for ExperimentFillToVolumePreview " <> $SessionUUID,
						"Example UltrasonicIncompatible container 1 for ExperimentFillToVolumePreview " <> $SessionUUID,
						"Example plate 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID
					}
				];
				{
					tubeSample1,
					tubeSample2,
					tubeSample3,
					volumetricFlaskSample1,
					volumetricFlaskSample2,
					ultrasonicIncompatibleSample1,
					plateSample1
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Methanol"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", volumetricFlask1},
						{"A1", volumetricFlask2},
						{"A1", ultrasonicIncompatible1},
						{"A8", plate1}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example sample 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example volumetric flask sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example volumetric flask sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example ultrasonic incompatible sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID,
						"Example plate sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID
					},
					InitialAmount -> {
						500 Milligram,
						20 Milliliter,
						1 Milligram,
						500 Milligram,
						1 Milliliter,
						500 Milligram,
						10 Milligram
					}
				];

				(* make a template protocol *)
				templateProtocol = ExperimentFillToVolume[tubeSample1, 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Name -> "ExperimentFillToVolumePreview Template Protocol 1 " <> $SessionUUID];

				allObjs = Cases[Flatten[{
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, volumetricFlaskSample2, ultrasonicIncompatibleSample1, plateSample1,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]],
					<|Object -> tubeSample1, Anhydrous -> True|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for ExperimentFillToVolumePreview " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for ExperimentFillToVolumePreview tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "ExperimentFillToVolumePreview Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "ExperimentFillToVolumePreview Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];



(* ::Subsection:: *)
(*FillToVolume*)


DefineTests[FillToVolume,
	{
		Example[{Basic, "Fill the samples to the specified volume:"},
			Experiment[{
				FillToVolume[
					Sample -> {Object[Sample, "Example sample 1 for FillToVolume tests "<>$SessionUUID], Object[Sample, "Example plate sample 1 for FillToVolume tests "<>$SessionUUID]},
					TotalVolume -> {30 Milliliter, 1 Milliliter},
					Solvent -> Model[Sample, "Milli-Q water"],
					DestinationWell -> {"A1", Automatic}
				]
			}],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Fill the samples in the vessel to the specified volume:"},
			Experiment[{
				FillToVolume[
					Sample -> {Object[Container, Vessel, "Example container 1 for FillToVolume tests " <> $SessionUUID]},
					TotalVolume -> {30 Milliliter},
					Solvent -> Model[Sample, "Milli-Q water"],
					DestinationWell -> {"A1"}
				]
			}],
			ObjectP[Object[Protocol]]
		]
	},
	Stubs:>{
		$EmailEnabled=False,
		$AllowSystemsProtocols = True,
		$PersonID = Object[User, Emerald, Developer, "id:Y0lXejMmX69l"]
	},
	SetUp:>($CreatedObjects={}),
	TearDown:>(
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for FillToVolume " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for FillToVolume " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for FillToVolume " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "FillToVolume Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "FillToVolume Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Block[{$AllowSystemsProtocols = True},
			Module[
				{
					exampleBench,
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, ultrasonicIncompatibleSample1, volumetricFlaskSample2, plateSample1,
					templateProtocol,
					allObjs
				},

				exampleBench = Upload[<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "Example bench for FillToVolume tests " <> $SessionUUID, DeveloperObject -> True|>];
				{
					tube1,
					tube2,
					tube3,
					volumetricFlask1,
					volumetricFlask2,
					ultrasonicIncompatible1,
					plate1
				} = UploadSample[
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "1mg brown thin tube"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						Model[Container, Vessel, "T25 EasYFlask, TC Surface, Filter Cap"],
						Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					},
					{
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench},
						{"Work Surface", exampleBench}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example container 1 for FillToVolume tests " <> $SessionUUID,
						"Example container 2 for FillToVolume tests " <> $SessionUUID,
						"Example container 3 for FillToVolume tests " <> $SessionUUID,
						"Example volumetric flask 1 for FillToVolume " <> $SessionUUID,
						"Example volumetric flask 2 for FillToVolume " <> $SessionUUID,
						"Example UltrasonicIncompatible container 1 for FillToVolume " <> $SessionUUID,
						"Example plate 1 for FillToVolume tests " <> $SessionUUID
					}
				];
				{
					tubeSample1,
					tubeSample2,
					tubeSample3,
					volumetricFlaskSample1,
					volumetricFlaskSample2,
					ultrasonicIncompatibleSample1,
					plateSample1
				} = UploadSample[
					{
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Methanol"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Borane-dimethyl sulfide complex, 2M in THF"],
						Model[Sample, "Sodium Chloride"],
						Model[Sample, "Sodium Chloride"]
					},
					{
						{"A1", tube1},
						{"A1", tube2},
						{"A1", tube3},
						{"A1", volumetricFlask1},
						{"A1", volumetricFlask2},
						{"A1", ultrasonicIncompatible1},
						{"A8", plate1}
					},
					Status -> {
						Available,
						Available,
						Available,
						Available,
						Available,
						Available,
						Available
					},
					Name -> {
						"Example sample 1 for FillToVolume tests " <> $SessionUUID,
						"Example sample 2 for FillToVolume tests " <> $SessionUUID,
						"Example sample 3 for FillToVolume tests " <> $SessionUUID,
						"Example volumetric flask sample 1 for FillToVolume tests " <> $SessionUUID,
						"Example volumetric flask sample 2 for FillToVolume tests " <> $SessionUUID,
						"Example ultrasonic incompatible sample 1 for FillToVolume tests " <> $SessionUUID,
						"Example plate sample 1 for FillToVolume tests " <> $SessionUUID
					},
					InitialAmount -> {
						500 Milligram,
						20 Milliliter,
						1 Milligram,
						500 Milligram,
						1 Milliliter,
						500 Milligram,
						10 Milligram
					}
				];

				(* make a template protocol *)
				templateProtocol = ExperimentFillToVolume[tubeSample1, 30 Milliliter, Solvent -> Model[Sample, "Milli-Q water"], Name -> "FillToVolume Template Protocol 1 " <> $SessionUUID];

				allObjs = Cases[Flatten[{
					tube1, tube2, tube3, volumetricFlask1, volumetricFlask2, ultrasonicIncompatible1, plate1,
					tubeSample1, tubeSample2, tubeSample3, volumetricFlaskSample1, volumetricFlaskSample2, ultrasonicIncompatibleSample1, plateSample1,
					templateProtocol, Download[templateProtocol, {ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]
				}], ObjectP[]];

				(* get rid of the Model field for these samples so that we can make sure everything works when that is the case *)
				Upload[Flatten[{
					<|Object -> #, DeveloperObject -> True|>& /@ PickList[allObjs, DatabaseMemberQ[allObjs]],
					<|Object -> tubeSample1, Anhydrous -> True|>
				}]];
			]
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[
			{allObjs, existingObjs},
			allObjs = Cases[Flatten[{
				Object[Container, Bench, "Example bench for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 1 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 2 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, "Example container 3 for FillToVolume tests " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 1 for FillToVolume " <> $SessionUUID],
				Object[Container, Vessel, VolumetricFlask, "Example volumetric flask 2 for FillToVolume " <> $SessionUUID],
				Object[Container, Vessel, "Example UltrasonicIncompatible container 1 for FillToVolume " <> $SessionUUID],
				Object[Container, Plate, "Example plate 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 2 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example sample 3 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example volumetric flask sample 2 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example ultrasonic incompatible sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Sample, "Example plate sample 1 for FillToVolume tests " <> $SessionUUID],
				Object[Protocol, FillToVolume, "FillToVolume Template Protocol 1 " <> $SessionUUID],
				Quiet[Download[Object[Protocol, FillToVolume, "FillToVolume Template Protocol 1 " <> $SessionUUID], {ProcedureLog[Object], RequiredResources[[All, 1]][Object], Primitives[Object]}]]
			}], ObjectP[]];
			existingObjs = PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		]
	)
];

