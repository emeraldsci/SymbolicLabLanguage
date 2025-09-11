(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*ExperimentCrossFlowFiltration*)


DefineTests[ExperimentCrossFlowFiltration,
	{
		
		(* ---------- Basic Examples ---------- *)
		Example[
			{Basic,"Filter a sample using cross-flow filtration:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID]],
			ObjectP[Object[Protocol,CrossFlowFiltration]]
		],
		
		Example[
			{Basic,"Containers that hold the samples can be specified instead of explicit sample objects:"},
			ExperimentCrossFlowFiltration[Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (I) "<> $SessionUUID]],
			ObjectP[Object[Protocol,CrossFlowFiltration]]
		],
		
		Example[
			{Additional,"Diafiltration buffer volumes can be specified through Targets. In this case, the diafiltration step will run with 250 mL of buffer:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				SampleInVolume->200 Milliliter,
				DiafiltrationTarget->2.5, 
				PrimaryConcentrationTarget->4
			],
			ObjectP[Object[Protocol,CrossFlowFiltration]]
		],

		Example[
			{Additional,"Return simulation when Output->Simulation:"},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Simulation
			],
			SimulationP
		],

		(* ---------- Tests ---------- *)

		Test[
			"Containers and samples both resolve to the same options:",
			ExperimentCrossFlowFiltration[Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (I) "<> $SessionUUID],Output->Options],
			{_Rule..}
		],

		Test[
			"List overload works properly (important for CC):",
			ExperimentCrossFlowFiltration[{Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID]}],
			ObjectP[Object[Protocol,CrossFlowFiltration]]
		],
		
		Test[
			"Sample volume accounts for sample prep aliquoting:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				AssayVolume->250 Milliliter,
				Output->Options
			];
			Lookup[options,SampleInVolume],
			250 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Sample volume accounts for sample prep aliquoting:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				IncubateAliquot->50 Milliliter,
				Output->Options
			];
			Lookup[options,SampleInVolume],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Sample volume accounts for sample prep aliquoting:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				FilterAliquot->250 Milliliter,
				Output->Options
			];
			Lookup[options,SampleInVolume],
			250 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Sample volume accounts for sample prep aliquoting:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				PrimaryConcentrationTarget->10,
				CentrifugeAliquot->15 Milliliter,
				Output->Options
			];
			Lookup[options,SampleInVolume],
			15 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Targets are properly calculated from RetentateVolumeOut:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				RetentateAliquotVolume->3 Milliliter,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				Output->Options
			];
			Lookup[options,{PrimaryConcentrationTarget, DiafiltrationTarget, SecondaryConcentrationTarget}],
			{1,5,5},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Targets are properly scaled to account for multiple concentration steps:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				Output->Options
			];
			Lookup[options,{PrimaryConcentrationTarget, DiafiltrationTarget, SecondaryConcentrationTarget}],
			{1,5,5},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"Targets are properly calculated from RetentateVolumeOut if using uPulse as the Instrument:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
					Output->Options
			];
			Lookup[options,{PrimaryConcentrationTarget, DiafiltrationTarget, SecondaryConcentrationTarget}],
			{5,5,2},
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{
				Warning::CrossFlowSampleVolumeExceedsCapacity,
				Warning::AliquotRequired
			}
		],
		
		Test[
			"Targets are properly scaled to account for multiple concentration steps if using uPulse as the Instrument:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,{PrimaryConcentrationTarget, DiafiltrationTarget, SecondaryConcentrationTarget}],
			{5,5,2},
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{
				Warning::CrossFlowSampleVolumeExceedsCapacity,
				Warning::AliquotRequired
			}
		],
		
		Test[
			"FilterPrimeRinse is turned on if the rinse buffer is not water:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeBuffer->Model[Sample,StockSolution,"20% Ethanol"],
				Output->Options
			];
			Lookup[options,FilterPrimeRinse],
			True,
			Variables:>{options}
		],
		
		Test[
			"FilterFlush is turned on if a related option is specified:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushBuffer->Model[Sample,StockSolution,"20% Ethanol"],
				Output->Options
			];
			Lookup[options,FilterFlush],
			True,
			Variables:>{options}
		],
		
		Test[
			"FilterFlushRinse is turned on if the rinse buffer is not water:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushBuffer->Model[Sample,StockSolution,"20% Ethanol"],
				Output->Options
			];
			Lookup[options,FilterFlushRinse],
			True,
			Variables:>{options}
		],
		
		Test[
			"PermeateAliquotVolume are properly capped to account for minimum container or filter volume:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				SampleInVolume->100 Milliliter,
				PrimaryConcentrationTarget->2,
				Output->Options
			];
			Lookup[options,PermeateAliquotVolume],
			All,
			Variables:>{options}
		],
		
		Test[
			"Targets are properly capped to account for minimum container or filter volume:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->5 Milliliter,
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			3.3,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		Test[
			"Targets are properly capped to account for minimum container or filter volume if using uPulse:",
			options=ExperimentCrossFlowFiltration[
				{Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID], Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID], Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]},
				SampleInVolume->10 Milliliter,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			6.7,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"If a sample with a single component is specified, returns the largest filter in the database:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample Single Component "<> $SessionUUID],
				Output->Options
			];
			allFilters=Search[Model[Item,CrossFlowFilter]];
			largestFilterCutoff=Max[Select[Download[allFilters,SizeCutoff],MatchQ[#,UnitsP[1 Micron]]&]];
			MatchQ[Lookup[options,SizeCutoff],largestFilterCutoff],
			True,
			Variables:>{options,allFilters,largestFilterCutoff}
		],
		
		Test[
			"A warning will be shown if Targets in sample fold volume units is specified beyond the capacity of the instrument, indicating that it has been rounded to the instrument specifications:",
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PrimaryConcentrationTarget -> {24.9876 Milliliter, 2.1, 25.0229 Milliliter},
				Output -> Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			{Quantity[25, "Milliliters"], 2.1, Quantity[25, "Milliliters"]},
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		
		Test[
			"A warning will be shown if Targets in milliliters is specified beyond the capacity of the instrument, indicating that it has been rounded to the instrument specifications:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->124.9999 Milliliter,
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			125 Milliliter,
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options}
		],
		
		Test[
			"A warning will be shown if Targets in grams is specified beyond the capacity of the instrument, indicating that it has been rounded to the instrument specifications:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->124.9999 Gram,
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			125 Gram,
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options}
		],
		
		
		Test[
			"Resolves to 0.2 micron filters for mammalian cells if using KR2i:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID],
				Output->Options
			];
			If[
				MatchQ[Lookup[options,SizeCutoff],UnitsP[1 Micron]],
				Lookup[options,SizeCutoff]<=Lookup[options,SizeCutoff],
				True
			],
			True,
			Variables:>{options}
		],
		
		Test[
			"Resolves to <0.1 micron filters for bacterial samples if using KR2i:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Bacteria Test Sample "<> $SessionUUID],
				Output->Options
			];
			If[
				MatchQ[Lookup[options,SizeCutoff],UnitsP[1 Micron]],
				Lookup[options,SizeCutoff]<=0.1 Micron,
				True
			],
			True,
			Variables:>{options}
		],
		
		Test[
			"Resolves to <0.1 micron filters for yeast samples if using KR2i:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Yeast Test Sample "<> $SessionUUID],
				Output->Options
			];
			If[
				MatchQ[Lookup[options,SizeCutoff],UnitsP[1 Micron]],
				Lookup[options,SizeCutoff]<=Lookup[options,SizeCutoff],
				True
			],
			True,
			Variables:>{options}
		],
		
		Test[
			"Calculates density from solvent field of the sample for a single solvent, and thereby PermeateAliquotVolume and RetentateAliquotVolume:",
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample With Single Solvent "<> $SessionUUID],
				PrimaryConcentrationTarget->100 Gram,
				Output->Options
			];
			Lookup[options,{PermeateAliquotVolume,RetentateAliquotVolume}],
			{All,All},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"PermeateAliquotVolume and RetentateAliquotVolume correctly resolved from PrimaryConcentrationTarget:",
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PrimaryConcentrationTarget->30 Gram,
				Output->Options
			];
			Lookup[options,{PermeateAliquotVolume,RetentateAliquotVolume}],
			{All,Null},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Test[
			"ScaleAlarms are calculated correctly for multi-step experiments (but allows close to 0 retentate if dead volume is greater than retentate out volume):",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				PrimaryConcentrationTarget->2.6,
				DiafiltrationTarget->4,
				SecondaryConcentrationTarget->2
			];
			Download[protocol,ScaleAlarms],
			{EqualP[Quantity[585, "Grams"]], EqualP[Quantity[3.1, "Grams"]]},
			Variables:>{protocol}
		],

		Test[
			"ScaleAlarms are calculated correctly for multi-step experiments:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (III) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				PrimaryConcentrationTarget->4,
				DiafiltrationTarget->4,
				SecondaryConcentrationTarget->2
			];
			Download[protocol,ScaleAlarms],
			{Quantity[1869, "Grams"], Quantity[79.8, "Grams"]},
			Variables:>{protocol},
			EquivalenceFunction->Equal
		],

		Test[
			"A filter holder resource is generated for sheet filters:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				CrossFlowFilter->Model[Item,CrossFlowFilter,"Sartocon Slice 50 ECO Hydrosart 10 kDa"],
				FiltrationMode->Diafiltration,
				DiafiltrationTarget ->2.5
			];
			Download[protocol,FilterHolder],
			ObjectP[Model[Container,Rack]],
			Variables:>{protocol}
		],
		
		Test[
			"A filter holder resource is not generated for hollow fiber filters:",
			protocol=ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID]];
			Download[protocol,FilterHolder],
			Null,
			Variables:>{protocol}
		],
		
		Test[
			"SampleReservoirRack is populated:",
			protocol=ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID]];
			Download[protocol,SampleReservoirRack],
			ObjectP[Model[Container,Rack]],
			Variables:>{protocol}
		],
		
		Test[
			"WashReservoirRacks are populated for FilterPrime:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->True
			];
			Download[protocol,WashReservoirRacks],
			{ObjectP[Model[Container,Rack]],Null,ObjectP[Model[Container,Rack]]},
			Variables:>{protocol}
		],
		
		Test[
			"WashReservoirRacks are populated for FilterFlush:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->False,
				FilterFlush->True
			];
			Download[protocol,WashReservoirRacks],
			{Null,ObjectP[Model[Container,Rack]],ObjectP[Model[Container,Rack]]},
			Variables:>{protocol}
		],
		
		Test[
			"WashReservoirRacks are populated for FilterPrime and FilterFlush:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->True,
				FilterFlush->True
			];
			Download[protocol,WashReservoirRacks],
			{ObjectP[Model[Container,Rack]],ObjectP[Model[Container,Rack]],ObjectP[Model[Container,Rack]]},
			Variables:>{protocol}
		],
		
		Test[
			"FittingImageFiles are populated properly when there are no Diafiltration steps:",
			protocol=ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]];
			Download[protocol,FittingImageFiles],
			{
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				Null,
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				Null,
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				Null,
				Null,
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]]
			},
			Variables:>{protocol}
		],
		
		Test[
			"FittingImageFiles are populated properly when there are Diafiltration steps:",
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]
			];
			Download[protocol,FittingImageFiles],
			{
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]],
				Null,
				Null,
				LinkP[Object[EmeraldCloudFile]],
				LinkP[Object[EmeraldCloudFile]]
			},
			Variables:>{protocol}
		],
		
		(* ---------- Options ---------- *)

		Example[
			{Options,SampleLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				SampleLabel -> {"Sample 1", "Sampl 2", "Sample 3"},
				Output -> Simulation
			];
			LookupObjectLabel[simulation, #] & /@ Download[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Object
			],
			{"Sample 1", "Sampl 2", "Sample 3"},
			Variables:>{simulation}
		],
		Example[
			{Options,SampleContainerLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				SampleContainerLabel -> {"Container 1", "Container 2", "Container 3"},
				Output -> Simulation
			];
			LookupObjectLabel[simulation, #] & /@ Download[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Container[Object]
			],
			{"Container 1", "Container 2", "Container 3"},
			Variables:>{simulation}
		],
		Example[
			{Options,RetentateContainerOutLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				RetentateContainerOut -> {Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"]},
				RetentateContainerOutLabel -> {"Container 1", "Container 2", "Container 3"},
				Output -> Simulation
			];
			Download[
				Lookup[simulation[[1]][Labels],
					{"Container 1", "Container 2", "Container 3"}
				],
				Model[Object],
				Simulation -> simulation
			],
			{
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]]
			},
			Variables:>{simulation}
		],
		Example[
			{Options,PermeateContainerOutLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PermeateContainerOut -> {Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"]},
				PermeateContainerOutLabel -> {"Container 1", "Container 2", "Container 3"},
				Output -> Simulation
			];
			Download[
				Lookup[simulation[[1]][Labels],
					{"Container 1", "Container 2", "Container 3"}
				],
				Model[Object],
				Simulation -> simulation
			],
			{
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
				ObjectReferenceP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]]
			},
			Variables:>{simulation}
		],
		Example[
			{Options,PermeateSampleOutLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PermeateContainerOut -> {
					Model[Container, Vessel, "id:jLq9jXvA8ewR"],
					Model[Container, Vessel, "id:jLq9jXvA8ewR"],
					Model[Container, Vessel, "id:jLq9jXvA8ewR"]
				},
				PermeateSampleOutLabel -> {"Sample 1", "Sample 2", "Sample 3"},
				Output -> Simulation
			];
			Download[Lookup[
				simulation[[1]][Labels],
				{"Sample 1", "Sample 2", "Sample 3"}],
				Model[Composition][[All, 2]][Object],
				Simulation -> simulation
			],
			{
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				},
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				},
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				}
			},
			Variables:>{simulation}
		],
		Example[
			{Options,RetentateSampleOutLabel,"Specify label of samples for scripts:"},
			simulation=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				RetentateContainerOut -> {
					Model[Container, Vessel, "id:jLq9jXvA8ewR"],
					Model[Container, Vessel, "id:jLq9jXvA8ewR"],
					Model[Container, Vessel, "id:jLq9jXvA8ewR"]
				},
				RetentateSampleOutLabel -> {"Sample 1", "Sample 2", "Sample 3"},
				Output -> Simulation
			];
			Download[Lookup[
				simulation[[1]][Labels],
				{"Sample 1", "Sample 2", "Sample 3"}],
				Model[Composition][[All, 2]][Object],
				Simulation -> simulation
			],
			{
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				},
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				},
				{
					ObjectReferenceP[Model[Molecule, "Water"]],
					ObjectReferenceP[Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
					ObjectReferenceP[Model[Molecule, Protein, "PARP"]]
				}
			},
			Variables:>{simulation}
		],
		Example[
			{Options,SampleInVolume,"Specify amount of sample that will be filtered in this experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->245 Milliliter,
				Output->Options
			];
			Lookup[options,SampleInVolume],
			245 Milliliter,
			Variables:>{options}
		],
		Example[
			{Options,SampleInVolume,"SampleInVolume should be auto resolved based on specified instrument:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,SampleInVolume],
			45 Milliliter,
			Variables:>{options},
			Messages:>{
				Warning::CrossFlowSampleVolumeExceedsCapacity,
				Warning::AliquotRequired
			}
		],
		Example[
			{Options,SampleInVolume,"Specify amount of sample that will be filtered in this experiment for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				SampleInVolume->{34Milliliter,35Milliliter,33Milliliter},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,SampleInVolumes],
			{34Milliliter,35Milliliter,33Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,Sterile,"Specify whether the experiment will be performed under aseptic conditions:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Sterile->True,
				SizeCutoff->50.Kilodalton,
				Output->Options
			];
			Lookup[options,Sterile],
			True,
			Variables:>{options},
			Messages:>Warning::CrossFlowNonSterileSampleReservoir
		],
		Example[
			{Options,Sterile,"Specify whether the experiment will be performed under aseptic conditions for uPulse:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
				Sterile->True,
				SizeCutoff->50. Kilodalton,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,Sterile],
			True,
			Variables:>{options},
			Messages:> {Warning::CrossFlowFilterUnavailableFilters}
		],
		
		Example[
			{Options,FiltrationMode,"Specify the sequence of concentration and diafiltration steps performed in the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				Output->Options
			];
			Lookup[options,FiltrationMode],
			ConcentrationDiafiltration,
			Variables:>{options}
		],
		Example[
			{Options,FiltrationMode,"Specify the sequence of concentration and diafiltration steps performed in the experiment for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FiltrationMode->{Concentration,ConcentrationDiafiltration,ConcentrationDiafiltrationConcentration},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FiltrationModes],
			{Concentration,ConcentrationDiafiltration,ConcentrationDiafiltrationConcentration},
			Variables:>{protocol}
		],
		Example[
			{Options,PrimaryConcentrationTarget,"Specify how much liquid will be moved through the filter in each filtration step:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->2,
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryConcentrationTarget,"Specify how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PrimaryConcentrationTarget->{2,3,4},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,PrimaryConcentrationTargets],
			{2,3,4},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,PrimaryConcentrationTarget,"Specify, by volume, how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationTarget->1.1,
				PrimaryConcentrationTarget->{0Milliliter,20Milliliter,30Milliliter},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			{0Milliliter,20Milliliter,30Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,PrimaryConcentrationTarget,"Specify, by weight, how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationTarget->1.1,
				PrimaryConcentrationTarget->{0Gram,20Gram,30Gram},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,PrimaryConcentrationTarget],
			{0Gram,20Gram,30Gram},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryConcentrationTarget,"Specify how much liquid will be moved through the filter in each filtration step:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->2,
				SecondaryConcentrationTarget->2,
				Output->Options
			];
			Lookup[options,SecondaryConcentrationTarget],
			2,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryConcentrationTarget,"Specify how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PrimaryConcentrationTarget->6,
				SecondaryConcentrationTarget-> {1.5,2,2.5},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,SecondaryConcentrationTargets],
			{1.5,2,2.5},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,SecondaryConcentrationTarget,"Specify, by volume, how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationTarget->1.1,
				PrimaryConcentrationTarget->{0Milliliter,20Milliliter,30Milliliter},
				SecondaryConcentrationTarget->{30Milliliter,10Milliliter,0Milliliter},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,SecondaryConcentrationTarget],
			{30Milliliter,10Milliliter,0Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,SecondaryConcentrationTarget,"Specify, by weight, how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationTarget->1.1,
				PrimaryConcentrationTarget->{0Gram,20Gram,30Gram},
				SecondaryConcentrationTarget->{30Gram,10Gram,0Gram},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				Output->Options
			];
			Lookup[options,SecondaryConcentrationTarget],
			{30Gram,10Gram,0Gram},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,DiafiltrationTarget,"Specify how much liquid will be moved through the filter in each filtration step:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->2,
				DiafiltrationTarget->2,
				Output->Options
			];
			Lookup[options,DiafiltrationTarget],
			2,
			Variables:>{options}
		],
		Example[
			{Options,DiafiltrationTarget,"Specify how much liquid will be moved through the filter in each filtration step for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PrimaryConcentrationTarget->2,
				DiafiltrationTarget-> {1.75,2,2.25},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,DiafiltrationTargets],
			EquivalenceFunction->Equal,
			{1.75,2,2.25},
			Variables:>{protocol}
		],
		Example[
			{Options,TransmembranePressureTarget,"Specify the amount of pressure maintained across the filter during the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				TransmembranePressureTarget->5 PSI,
				Output->Options
			];
			Lookup[options,TransmembranePressureTarget],
			5 PSI,
			Variables:>{options}
		],
		
		Example[
			{Options,PermeateContainerOut,"Specify the container used to store the permeate after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PermeateContainerOut->Model[Container,Vessel,"50mL Tube"],
				Output->Options
			];
			Lookup[options,PermeateContainerOut],
			ObjectP[Model[Container,Vessel,"50mL Tube"]],
			Variables:>{options}
		],
		Example[
			{Options,PermeateContainerOut,"Specify the container used to store the permeate after the experiment:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PermeateContainerOut->Model[Container, Vessel, "50mL Tube"],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, PermeateContainersOut],
			{
				LinkP[Model[Container, Vessel, "50mL Tube"]],
				LinkP[Model[Container, Vessel, "50mL Tube"]],
				LinkP[Model[Container, Vessel, "50mL Tube"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,PermeateStorageCondition,"Specify how the permeate solution will be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PermeateStorageCondition->DeepFreezer,
				Output->Options
			];
			Lookup[options,PermeateStorageCondition],
			DeepFreezer,
			Variables:>{options}
		],
		Example[
			{Options,PermeateStorageCondition,"Specify how the permeate solution will be kept after the experiment when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				PermeateStorageCondition -> {DeepFreezer, CryogenicStorage, Freezer},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, PermeateStorageConditions],
			{
				DeepFreezer,
				CryogenicStorage,
				Freezer
			},
			Variables:>{protocol}
		],
		Example[
			{Options,PermeateStorageCondition,"Specify how the permeate solution will be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				PermeateStorageCondition->CryogenicStorage,
				Output->Options
			];
			Lookup[options,PermeateStorageCondition],
			CryogenicStorage,
			Variables:>{options}
		],
		
		Example[
			{Options,DiafiltrationBuffer,"Specify the type of solution added to the feed in the buffer exchange steps:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				DiafiltrationBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,DiafiltrationBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			Variables:>{options}
		],
		Example[
			{Options,DiafiltrationBuffer,"Specify the type of solution added to the feed in the buffer exchange steps for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationBuffer-> {Automatic, Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "Filtered PBS, Sterile"]},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, {FiltrationModes, DiafiltrationBuffers}],
			{
				{
					Concentration,
					ConcentrationDiafiltration,
					ConcentrationDiafiltration
				},
				{
					Null,
					LinkP[Model[Sample]],
					LinkP[Model[Sample, StockSolution]]
				}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,CrossFlowFilter,"Specify the filter module used to separate the sample during the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				CrossFlowFilter->Model[Item,CrossFlowFilter,"Dry Xampler PS 10 kDa"],
				Output->Options
			];
			Lookup[options,CrossFlowFilter],
			ObjectP[Model[Item,CrossFlowFilter,"Dry Xampler PS 10 kDa"]],
			Variables:>{options}
		],
		Example[
			{Options,CrossFlowFilter,"Specify the filter module used to separate the sample during the experiment for each sample when using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Automatic,
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, CrossFlowFilters],
			{
				LinkP[Model[Item, Filter, MicrofluidicChip, "id:M8n3rxnoDY79"]],
				LinkP[Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID]],
				LinkP[Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,PermeateAliquotVolume,"Specify the amount of permeate solution to be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PermeateAliquotVolume->1 Milliliter,
				Output->Options
			];
			Lookup[options,PermeateAliquotVolume],
			1 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,PermeateAliquotVolume,"PermeateAliquotVolume are properly filled when using uPulse as the instrument:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				PermeateAliquotVolume->2 Milliliter
			];
			Download[protocol,PermeateAliquotVolumes],
			{2 Milliliter,2 Milliliter,2 Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,PrimaryPumpFlowRate,"Specify the volume of feed pumped through the system per minute:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryPumpFlowRate->200 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,PrimaryPumpFlowRate],
			200 Milliliter/Minute,
			Variables:>{options}
		],
		
		Example[
			{Options,SizeCutoff,"Specify the largest diameter or molecular weight of the molecules that can cross the membrane:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SizeCutoff->10. Kilodalton,
				Output->Options
			];
			Lookup[options,SizeCutoff],
			10. Kilodalton,
			EquivalenceFunction -> Equal,
			Variables:>{options}
		],
		Example[
			{Options,SizeCutoff,"Specify the largest diameter or molecular weight of the molecules that can cross the membrane for uPulse:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				SizeCutoff-> {10. Kilodalton,5. Kilodalton,30. Kilodalton},
				Output->Options
			];
			Lookup[options,SizeCutoff],
			{10. Kilodalton,5. Kilodalton,30. Kilodalton},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,Instrument,"Specify the cross-flow filtration apparatus that will be used to perform the filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Instrument->Object[Instrument,CrossFlowFiltration,"Shawn Spencer"],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Object[Instrument,CrossFlowFiltration,"Shawn Spencer"]],
			Variables:>{options}
		],
		Example[
			{Options,Instrument,"Specify uPulse as the Instrument:"},
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Instrument->Object[Instrument,CrossFlowFiltration,"Tau Cross"]
			];
			Download[protocol,Instrument],
			ObjectP[Object[Instrument,CrossFlowFiltration,"Tau Cross"]],
			Variables:>{protocol},
			Messages:>{Warning::CrossFlowSampleVolumeExceedsCapacity,Warning::AliquotRequired}
		],
		
		Example[{Options,Instrument,"Instrument is auto resolved based on sample prep aliquoting (1):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				FilterAliquot->250 Milliliter,
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "id:vXl9j57jJnoD"]],
			Variables:>{options}
		],
		
		Example[{Options,Instrument,"Instrument is auto resolved based on sample prep aliquoting (2):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				PrimaryConcentrationTarget->10,
				CentrifugeAliquot->15 Milliliter,
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument, CrossFlowFiltration, "id:vXl9j5lJXvnJ"]],
			Variables:>{options}
		],
		
		Example[
			{Options,SampleReservoir,"Specify the container used to store the sample during the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleReservoir->Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 500mL Tube"],
				Output->Options
			];
			Lookup[options,SampleReservoir],
			ObjectP[Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 500mL Tube"]],
			Variables:>{options}
		],
		Example[
			{Options,SampleReservoir,"Specify the container used to store the sample during the experiment:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				SampleReservoir->Model[Container,Vessel,"50mL Tube"]
			];
			Download[protocol,SampleReservoirs],
			{
				LinkP[Model[Container,Vessel,"50mL Tube"]],
				LinkP[Model[Container,Vessel,"50mL Tube"]],
				LinkP[Model[Container,Vessel,"50mL Tube"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrime,"Specify if the filter will be rinsed before the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->False,
				Output->Options
			];
			Lookup[options,FilterPrime],
			False,
			Variables:>{options}
		],
		Example[
			{Options,FilterPrime,"Specify if the filter will be rinsed before the experiment using uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterPrime->True
			];
			Download[protocol,FilterPrime],
			True,
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		
		Example[
			{Options,FilterPrimeBuffer,"Specify the solution used to wet the membrane and rinse the system:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,FilterPrimeBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterPrimeBuffer,"By default, each new filter will be assigned a new FilterPrimeBuffer for uPulse (1):"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Automatic,
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeBuffers],
			{
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]],
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]],
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrimeBuffer,"Specify the buffer used to clean the filter before each run:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"],
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				FilterPrimeBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeBuffers],
			{
				LinkP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]],
				LinkP[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrimeVolume,"Specify volume of solution that is pumped into the system to prime the system:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeVolume->360 Milliliter,
				Output->Options
			];
			Lookup[options,FilterPrimeVolume],
			360 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,FilterPrimeVolume,"Specify volume of solution that is pumped into the system to prime the system for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterPrimeVolume->50 Milliliter,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeVolume],
			50 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrimeRinse,"Specify Indicates if there will be a water wash step after the filter priming:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeRinse->True,
				Output->Options
			];
			Lookup[options,FilterPrimeRinse],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterPrimeRinse,"FilterPrimeRinse is turned on if the rinse buffer is not water:"},
			options=ExperimentCrossFlowFiltration[
				{
					Object[Sample,"Cross Flow Test Sample For uPulse 1"<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample For uPulse 2"<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample For uPulse 3"<> $SessionUUID]
				},
				FilterPrimeBuffer->Model[Sample,StockSolution,"20% Ethanol"],
				Output->Options
			];
			Lookup[options,FilterPrimeRinse],
			True,
			Variables:>{options}
		],
		Example[
			{Options,FilterPrimeRinse,"Specify Indicates if there will be a water wash step after the filter priming for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterPrimeRinse->True,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeRinse],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrimeRinseBuffer,"Specify the buffer to be used to rinse the filter after priming:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Diafiltration,
				FilterPrimeRinseBuffer->Model[Sample, "Milli-Q water"],
				SampleInVolume->100 Milliliter,
				Output->Options
			];
			Lookup[options,FilterPrimeRinseBuffer],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterPrimeRinseBuffer,"By default, each new filter will be assigned a new FilterPrimeRinseBuffer for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Automatic,
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				FilterPrimeRinseBuffer->Model[Sample, "Milli-Q water"],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeBuffers],
			{
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]],
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]],
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterPrimeFlowRate,"Specify the volume of priming buffer pumped through the system per minute:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeFlowRate->200 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,FilterPrimeFlowRate],
			200 Milliliter/Minute,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterPrimeTransmembranePressureTarget,"Specify the amount of pressure maintained across the filter during the filter prime step:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeTransmembranePressureTarget->12 PSI,
				Output->Options
			];
			Lookup[options,FilterPrimeTransmembranePressureTarget],
			12 PSI,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterFlush,"Specify if the filter will be rinsed after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlush->True,
				Output->Options
			];
			Lookup[options,FilterFlush],
			True,
			Variables:>{options}
		],
		Example[
			{Options,FilterFlush,"Specify if the filter will be rinsed after the experiment for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterFlush->True,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeRinse],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,FilterFlush,"Specify if the filter will not be rinsed after the experiment for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterFlush->False,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeRinse],
			True,
			Variables:>{protocol}
		],
		Example[
			{Options,FilterFlushBuffer,"Specify the solution used to flush the membrane after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Output->Options
			];
			Lookup[options,FilterFlushBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			Variables:>{options}
		],
		Example[
			{Options,FilterPrimeRinseBuffer,"Specify if the filter will be rinsed by one more buffer solution after FilterPrime process and before running the sample:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Automatic,
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				FilterPrimeRinseBuffer->Model[Sample, "Milli-Q water"],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeRinseBuffers],
			{
				LinkP[Model[Sample, "Milli-Q water"]],
				LinkP[Model[Sample, "Milli-Q water"]],
				LinkP[Model[Sample, "Milli-Q water"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterFlushBuffer,"By default, each new filter will be assigned a new FilterFlushBuffer for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter-> {
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"],
					Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
					Model[Item, Filter, MicrofluidicChip, "id:xRO9n3Oxjvmx"]
				},
				FilterFlushBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterPrimeBuffers],
			{
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]],
				LinkP[Model[Sample, StockSolution, "id:M8n3rxYE54VP"]]
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterFlushVolume,"Specify volume of solution that is pumped into the system to flush the filter:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushVolume->200 Milliliter,
				Output->Options
			];
			Lookup[options,FilterFlushVolume],
			200 Milliliter,
			Variables:>{options}
		],
		Example[
			{Options,FilterFlushVolume,"Specify volume of solution that is pumped into the system to prime the system for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FilterFlushVolume->40 Milliliter,
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterFlushVolume],
			40 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[
			{Options,FilterFlushRinse,"Specify if there will be a water wash step after the filter flush:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushRinse->True,
				Output->Options
			];
			Lookup[options,FilterFlushRinse],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterFlushRinse,"Specify if there will be a water wash step after the filter flush for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
				FilterFlushRinse->False,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol,FilterFlushRinse],
			False,
			Variables:>{protocol}
		],
		
		Example[
			{Options,FilterFlushFlowRate,"Specify the volume of flushing buffer pumped through the system per minute:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushFlowRate->200 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,FilterFlushFlowRate],
			200 Milliliter/Minute,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterFlushTransmembranePressureTarget,"Specify the amount of pressure maintained across the filter during the filter flush step:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlush->True,
				FilterFlushTransmembranePressureTarget->12 PSI,
				Output->Options
			];
			Lookup[options,FilterFlushTransmembranePressureTarget],
			12 PSI,
			Variables:>{options}
		],
		
		Example[
			{Options,RetentateContainerOut,"Specify the container used to store the retentate after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				RetentateContainerOut->Model[Container,Vessel,"50mL Tube"],
				Output->Options
			];
			Lookup[options,RetentateContainerOut],
			ObjectP[Model[Container,Vessel,"50mL Tube"]],
			Variables:>{options}
		],
		Example[
			{Options,RetentateContainerOut,"By default, when using uPulse, we don't use any retentate"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, {RetentateContainersOut, RetentateAliquotVolumes, RetentateStorageConditions}],
			{{Null, Null, Null}, {Null, Null, Null}, {Null, Null, Null}},
			Variables:>{protocol}
		],
		Example[
			{Options,RetentateContainerOut,"Specify the container used to store the retentate after the experiment:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				RetentateContainerOut->Model[Container, Vessel, "id:jLq9jXvA8ewR"]
			];
			Download[protocol, {RetentateContainersOut, RetentateAliquotVolumes, RetentateStorageConditions}],
			{
				{
					LinkP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
					LinkP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]],
					LinkP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]]
				},
				{
					All,
					All,
					All
				},
				{
					Refrigerator,
					Refrigerator,
					Refrigerator
				}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,RetentateAliquotVolume,"Specify the amount of retentate to be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				RetentateAliquotVolume->10 Milliliter,
				Output->Options
			];
			Lookup[options,RetentateAliquotVolume],
			10 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[
			{Options,RetentateAliquotVolume,"Specify the amount of retentate to be kept after the experiment for uPulse:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				RetentateAliquotVolume-> {2 Milliliter,3 Milliliter,4 Milliliter},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, {RetentateContainersOut, RetentateAliquotVolumes, RetentateStorageConditions}],
			{
				{
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
				},
				{
					Quantity[2., "Milliliters"],
					Quantity[3., "Milliliters"],
					Quantity[4., "Milliliters"]
				},
				{
					Refrigerator,
					Refrigerator,
					Refrigerator
				}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,RetentateStorageCondition,"Specify how the retentate will be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				RetentateStorageCondition->DeepFreezer,
				Output->Options
			];
			Lookup[options,RetentateStorageCondition],
			DeepFreezer,
			Variables:>{options}
		],
		Example[
			{Options,RetentateStorageCondition,"Specify how the retentate will be kept after the experiment:"},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				RetentateStorageCondition-> {Refrigerator, Freezer, AmbientStorage},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, {RetentateContainersOut, RetentateAliquotVolumes, RetentateStorageConditions}],
			{
				{
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]],
					LinkP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
				},
				{
					All,
					All,
					All
				},
				{Refrigerator, Freezer, AmbientStorage}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterStorageCondition,"Specify how the filter will be kept after the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterStorageCondition->DeepFreezer,
				Output->Options
			];
			Lookup[options,FilterStorageCondition],
			DeepFreezer,
			Variables:>{options}
		],
		Example[
			{Options,FilterStorageCondition,"When using uPulse, the filter cheap will be auto stored in Ambient condition: "},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			];
			Download[protocol, FilterStorageConditions],
			{AmbientStorage, AmbientStorage, AmbientStorage},
			Variables:>{protocol}
		],
		Example[
			{Options,FilterStorageCondition,"When using uPulse, specify the filter storage condition: "},
			protocol=ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument->Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				FilterStorageCondition->Disposal
			];
			Download[protocol, FilterStorageConditions],
			{Disposal, Disposal, Disposal},
			Variables:>{protocol}
		],
		Example[
			{Options,Name,"Specify the name for the generated protocol:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Name->"My Test Cross Flow Experiment",
				Output->Options
			];
			Lookup[options,Name],
			"My Test Cross Flow Experiment",
			Variables:>{options}
		],
		
		Example[
			{Options,Template,"Inherit the resolved options of a previous protocol:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Template->Object[Protocol,CrossFlowFiltration,"Cross Flow Test Template Protocol "<> $SessionUUID],
				Output->Options
			];
			Lookup[options,Template],
			ObjectP[Object[Protocol,CrossFlowFiltration,"Cross Flow Test Template Protocol "<> $SessionUUID]],
			Variables:>{options},
			Messages:>{Warning::CrossFlowFilterSpecifiedMismatch}
		],

		Example[
			{Options,PreparatoryUnitOperations,"Specify a series of manipulations to be performed before the experiment:"},
			ExperimentCrossFlowFiltration[
				"My Sample",
				PreparatoryUnitOperations->{
					LabelContainer[Label->"My Sample",Container->Model[Container,Vessel,"1L Glass Bottle"]],
					Transfer[Source->Model[Sample, "Milli-Q water"],Amount->250 Milliliter,Destination->"My Sample"]
				}
			],
			ObjectP[Object[Protocol,CrossFlowFiltration]]
		],
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Specify the container in which an input Model[Sample] should be prepared:"},
			options = ExperimentCrossFlowFiltration[
				{Model[Sample, "Milli-Q water"]},
				PreparedModelContainer -> Model[Container,Vessel,"1L Glass Bottle"],
				PreparedModelAmount -> 250 Milliliter,
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
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]},
				{ObjectP[Model[Container,Vessel,"1L Glass Bottle"]]},
				{EqualP[250 Milliliter]},
				{"A1"},
				{_String}
			},
			Variables :> {options, prepUOs}
		],

		(* ----- Sample Prep Unit Tests ----- *)
		
		(* THIS TEST IS BRUTAL BUT DO NOT REMOVE IT. MAKE SURE YOUR FUNCTION DOESN'T BUG ON THIS. *)
		Example[
			{Additional,"Use the sample preparation options to prepare samples before the main experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				Incubate->True,
				Centrifuge->True,
				Filtration->True,
				Aliquot->True,
				Output->Options
			];
			{Lookup[options,Incubate],Lookup[options,Centrifuge],Lookup[options,Filtration],Lookup[options,Aliquot]},
			{True,True,True,True},
			Variables:>{options},
			TimeConstraint->300
		],
		
		(* Incubate Tests *)
		Example[
			{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubationTemperature->37 Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			37 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubationTime->22 Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			22 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				MaxIncubationTime->27 Minute,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			27 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		(* Note: This test requires your sample to be in some type of 50mL tube or 96-well plate. Definitely not bigger than a 250mL bottle. *)
		Example[
			{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubationInstrument->Model[Instrument,HeatBlock,"AHP-1200CPV"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"AHP-1200CPV"]],
			Variables:>{options}
		],
		
		Example[
			{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				AnnealingTime->32 Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			32 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubateAliquot->240 Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			240 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Mix->True,
				Output->Options
			];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		
		(* Note: You CANNOT be in a plate for the following test. *)
		Example[
			{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				MixType->Shake,
				Output->Options
			];
			Lookup[options,MixType],
			Shake,
			Variables:>{options}
		],
		
		Example[
			{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				MixUntilDissolved->True,
				Output->Options
			];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],
		
		(* Filter Tests *)
		Example[
			{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Filtration->True,
				Output->Options
			];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FiltrationType->Vacuum,
				Output->Options
			];
			Lookup[options,FiltrationType],
			Vacuum,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterInstrument->Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"],
				Output->Options
			];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"]],
			Variables:>{options}
		],
		
		(* For some reason, this test goes super slow in the sample prep resolver *)
		Example[
			{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Filter->Model[Item,Filter,"BottleTop Filter, PES, 0.22um, 90mm"],
				Output->Options
			];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"BottleTop Filter, PES, 0.22um, 90mm"]],
			Variables:>{options},
			TimeConstraint->1000
		],
		
		Example[
			{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterMaterial->PES,
				FilterContainerOut->Model[Container,Vessel,"250mL Glass Bottle"],
				Output->Options
			];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample For uPulse 1"<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FilterSterile->True,
				Output->Options
			];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterAliquot->240 Milliliter,
				Output->Options
			];
			Lookup[options,FilterAliquot],
			240 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterAliquotContainer->Model[Container,Vessel,"250mL Glass Bottle"],
				Output->Options
			];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"250mL Glass Bottle"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterContainerOut->Model[Container,Vessel,"250mL Glass Bottle"],
				Output->Options
			];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"250mL Glass Bottle"]]},
			Variables:>{options}
		],
		
		Example[
			{Options,FilterHousing,"The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options=ExperimentCrossFlowFiltration[Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FiltrationType->PeristalticPump,
				FilterHousing->Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"],
				Output->Options
			];
			Lookup[options,FilterHousing],
			ObjectP[Model[Instrument,FilterHousing,"Filter Membrane Housing, 142 mm"]],
			Variables:>{options}
		],
		
		Example[
			{Options,TubingType,"The type of the material of tubes used to transport solutions during the experiment can only be PharmPure right now."},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				TubingType->PharmaPure,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				Output->Options
			];
			Lookup[options,TubingType],
			PharmaPure,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FiltrationType->Centrifuge,
				FilterTime->12 Minute,
				Output->Options
			];
			Lookup[options,FilterTime],
			12 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FiltrationType->Centrifuge,
				FilterIntensity->1100 RPM,
				Output->Options
			];
			Lookup[options,FilterIntensity],
			1100 RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FiltrationType->Centrifuge,
				FilterTemperature->11 Celsius,
				Output->Options];
			Lookup[options,FilterTemperature],
			11 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->300,
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,FilterSyringe,"The syringe used to force that sample through a filter:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FiltrationType->Syringe,
				FilterSyringe->Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"],
				Output->Options
			];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container,Syringe,"20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables:>{options},
			TimeConstraint->300
		],
		
		Example[
			{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				PrefilterMaterial->GxF,
				Output->Options
			];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		
		Example[
			{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				FilterPoreSize->0.22 Micrometer,
				Output->Options
			];
			Lookup[options,FilterPoreSize],
			0.22 Micrometer,
			Variables:>{options}
		],
		
		Example[
			{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				PrefilterPoreSize->1. Micrometer,
				FilterMaterial->PTFE,
				Output->Options
			];
			Lookup[options,PrefilterPoreSize],
			1. Micrometer,
			Variables:>{options}
		],
		
		(* Aliquot Tests *)
		
		Example[
			{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Aliquot->True,
				Output->Options
			];
			Lookup[options,Aliquot],
			True,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				AliquotAmount->240 Milliliter,
				Output->Options
			];
			Lookup[options,AliquotAmount],
			240 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,AliquotSampleLabel,"Specify a label for the aliquoted sample:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Aliquot->True,
				AliquotSampleLabel->"mySample1",
				Output->Options
			];
			Lookup[options,AliquotSampleLabel],
			{"mySample1"},
			Variables:>{options}
		],
		
		Example[
			{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				AssayVolume->240 Milliliter,
				Output->Options
			];
			Lookup[options,AssayVolume],
			240 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				TargetConcentration->1 Molar,
				Output->Options
			];
			Lookup[options,TargetConcentration],
			1 Molar,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>Warning::AmbiguousAnalyte
		],
		
		Example[
			{Options,TargetConcentrationAnalyte,"Set the TargetConcentrationAnalyte option:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				TargetConcentration->0.5 Molar,
				TargetConcentrationAnalyte->Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Output->Options
			];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],
			Variables:>{options}
		],
		
		
		Example[
			{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				AliquotAmount->10 Milliliter,
				AssayVolume->250 Milliliter,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				PrimaryConcentrationTarget -> 2,
				Output->Options
			];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				BufferDiluent->Model[Sample,"Milli-Q water"],
				BufferDilutionFactor->10,
				ConcentratedBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				AliquotAmount->100 Milliliter,
				AssayVolume->250 Milliliter,
				PrimaryConcentrationTarget -> 2,
				Output->Options
			];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options},
			TimeConstraint->500
		],
		
		Example[
			{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				AssayBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				AliquotAmount->100 Milliliter,
				AssayVolume->250 Milliliter,
				PrimaryConcentrationTarget -> 2,
				Output->Options
			];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			Variables:>{options}
		],
		
		Example[
			{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				AliquotSampleStorageCondition->AmbientStorage,
				Output->Options
			];
			Lookup[options,AliquotSampleStorageCondition],
			AmbientStorage,
			Variables:>{options}
		],
		
		Example[
			{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				ConsolidateAliquots->True,
				Output->Options
			];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		
		Example[
			{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				Aliquot->True,
				AliquotPreparation->Manual,
				Output->Options
			];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		
		Example[
			{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentCrossFlowFiltration[Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				AliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output->Options
			];
			Lookup[options,AliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]}},
			Variables:>{options}
		],
		
		Example[
			{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				IncubateAliquotDestinationWell->"A1",
				AliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		
		Example[
			{Options,FilterAliquotDestinationWell,"Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				FilterAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		
		Example[
			{Options,DestinationWell,"Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				DestinationWell->"A1",
				Output->Options
			];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		
		Example[
			{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (VII) "<> $SessionUUID],
				ConcentratedBuffer->Model[Sample,StockSolution,"Filtered PBS, Sterile"],
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				BufferDilutionFactor->10,
				AliquotAmount->10 Milliliter,
				AssayVolume->250 Milliliter,
				PrimaryConcentrationTarget -> 2,
				Output->Options
			];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"Filtered PBS, Sterile"]],
			Variables:>{options}
		],
		
		Example[
			{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample For uPulse 1"<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		
		(* Centrifuge Tests *)
		
		Example[
			{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				Centrifuge->True,
				Output->Options
			];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeIntensity->950 RPM,
				Output->Options
			];
			Lookup[options,CentrifugeIntensity],
			950 RPM,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		(* Note: CentrifugeTime cannot go above 5 Minute without restricting the types of centrifuges that can be used. *)
		Example[
			{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeTime->4 Minute,
				Output->Options
			];
			Lookup[options,CentrifugeTime],
			4 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeTemperature->17 Celsius,
				Output->Options
			];
			Lookup[options,CentrifugeTemperature],
			17 Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeAliquot->14 Milliliter,
				Output->Options
			];
			Lookup[options,CentrifugeAliquot],
			14 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		
		Example[
			{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeAliquotContainer->Model[Container,Vessel,"15mL Tube"],
				Output->Options
			];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"15mL Tube"]]},
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		Example[
			{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (V) "<> $SessionUUID],
				PrimaryConcentrationTarget->1.1,
				CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],
				Output->Options
			];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],
		
		(* ----- Post Processing Options ----- *)
		
		Example[{Options,ImageSample,"Specify whether the samples should be imaged after the protocol completes:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				ImageSample->False,
				Output->Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				MeasureVolume->False,
				Output->Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options=ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				MeasureWeight->False,
				Output->Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		
		(* ---------- Messages ---------- *)

		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentCrossFlowFiltration[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentCrossFlowFiltration[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentCrossFlowFiltration[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentCrossFlowFiltration[Object[Container, Vessel, "id:12345678"]],
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

				ExperimentCrossFlowFiltration[sampleID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
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

				ExperimentCrossFlowFiltration[containerID, Simulation -> simulationToPassIn, Output -> Options]
			],
			{__Rule}
		],
		
		(* ----- Main Function ----- *)
		
		Example[
			{Messages,"CrossFlowKR2ICannotRunMultipleSamples","When using KR2i as the instrument, an error will be shown if more than one sample is specified:"},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]
			],
			$Failed,
			Messages:> {Error::CrossFlowKR2ICannotRunMultipleSamples, Error::InvalidInput}
		],
		
		Example[
			{Messages,"CrossFlowTooManySamples","When using uPulse as the instrument, an error will be shown if more than one sample is specified:"},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample,"Cross Flow Test Sample (I) "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample (III) "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
					Object[Sample,"Cross Flow Bacteria Test Sample "<> $SessionUUID],
					Object[Sample,"Cross Flow Yeast Test Sample "<> $SessionUUID],
					Object[Sample,"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample Single Component "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample For uPulse 1"<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample For uPulse 2"<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample For uPulse 3"<> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:> {Error::CrossFlowTooManySamples, Warning::CrossFlowSampleVolumeExceedsCapacity, Warning::AliquotRequired, Error::InvalidInput}
		],
		
		(* ----- Options Resolver ----- *)
		
		(* ----- Input Validation Checks ----- *)
		
		Example[
			{Messages,"InputContainsTemporalLinks","An warning will be shown if the sample is a temporal link:"},
			ExperimentCrossFlowFiltration[
				Link[Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],Now-1Second],
				Output->Options
			],
			_List,
			Messages:>Warning::InputContainsTemporalLinks
		],
		
		Example[
			{Messages,"CrossFlowSampleVolumeExceedsCapacity","An warning will be shown if the specified sample has a volume that exceeds the capacity of the instrument:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				Output->Options
			],
			_List,
			Messages:>Warning::CrossFlowSampleVolumeExceedsCapacity
		],
		
		Example[
			{Messages,"DiscardedSamples","An error will be shown if the sample is discarded:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample Discarded "<> $SessionUUID]],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		
		Example[
			{Messages,"CrossFlowCannotResolveSampleVolume","An error will be shown if neither the sample nor its container has volume information:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample Without Container Volume "<> $SessionUUID]],
			$Failed,
			Messages:>{Error::CrossFlowCannotResolveSampleVolume,Error::InvalidInput}
		],
		
		Example[
			{Messages,"CrossFlowMissingCompositionInformation","An error will be shown if the sample has no composition information:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample Without Composition "<> $SessionUUID]],
			$Failed,
			Messages:>{Error::CrossFlowMissingCompositionInformation,Error::InvalidInput}
		],
		
		Example[
			{Messages,"CrossFlowSampleNotLiquid","An error will be shown if the sample is not in a liquid state:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample Solid "<> $SessionUUID]],
			$Failed,
			Messages:>{Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		
		(* ----- Option Precision Check ----- *)
	
		Example[
			{Messages,"CrossFlowInstrumentalPrecision","A warning will be shown if an option is specified beyond the capacity of the instrument, indicating that the option has been rounded to the instrument specifications:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->249.9876 Milliliter,
				Output->Options
			],
			_List,
			Messages:>{Warning::InstrumentPrecision}
		],
		
		(* ----- Miscellaneous Options Checks ----- *)
		
		Example[
			{Messages,"CrossFlowUnsupportedInstrument","An error will be shown if the specified instrument is deprecated or retired:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Instrument->Object[Instrument,CrossFlowFiltration,"Cross Flow Test Retired Instrument "<> $SessionUUID]
			],
			$Failed,
			Messages:>{Error::CrossFlowUnsupportedInstrument,Error::InvalidOption}
		],
		
		(* ----- Conflicting Options Checks ----- *)

		Example[
			{Messages,"CrossFlowConcentrationFactorExceedsUnity","An error will be shown if the specified targets for concentration steps cumulatively exceed 1, indicating that the sample needs to be concentrated beyond 100%:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->100 Milliliter,
				FiltrationMode->Concentration,
				PrimaryConcentrationTarget->200 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowConcentrationFactorExceedsUnity,Error::CrossFlowInvalidTarget,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowConcentrationFactorExceedsUnity","An error will be shown if the specified targets for concentration steps cumulatively exceed 1, indicating that the sample needs to be concentrated beyond 100%:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->100 Milliliter,
				FiltrationMode->Concentration,
				PrimaryConcentrationTarget->200 Gram
			],
			$Failed,
			Messages:>{Error::CrossFlowConcentrationFactorExceedsUnity,Error::CrossFlowInvalidTarget,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowInvalidTarget","An error will be shown if the specified target for a concentration step exceeds 1, indicating that the sample needs to be concentrated beyond 100%:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Concentration,
				PrimaryConcentrationTarget->300 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowConcentrationFactorExceedsUnity,Error::CrossFlowInvalidTarget,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowInvalidTarget","An error will be shown if the specified target for a concentration step exceeds 1, indicating that the sample needs to be concentrated beyond 100%:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Concentration,
				PrimaryConcentrationTarget->300 Gram
			],
			$Failed,
			Messages:>{Error::CrossFlowConcentrationFactorExceedsUnity,Error::CrossFlowInvalidTarget,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowInsufficientSampleVolume","An error will be shown if the specified sample volume is greater than the available sample volume:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleInVolume->300 Milliliter,
				RetentateAliquotVolume->20 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowInsufficientSampleVolume,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowReservoirIncompatibleWithVolume","An error will be shown if the specified sample volume is greater or less than the capacity of the specified sample reservoir:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SampleReservoir->Model[Container,Vessel,CrossFlowContainer,"Flat Bottom 2L Bottle"],
				SampleInVolume->10 Milliliter,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]
			],
			$Failed,
			Messages:>{Error::CrossFlowReservoirIncompatibleWithVolume,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowReservoirIncompatibleWithVolume","An error will be shown if the specified sample volume is greater or less than the capacity of the specified sample reservoir:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (III) "<> $SessionUUID],
				SampleReservoir->Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 250mL Tube"],
				SampleInVolume->300 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowReservoirIncompatibleWithVolume,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowFilterIncompatibleWithVolume","An error will be shown if the specified sample volume is greater or less than the capacity of the specified filter:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				CrossFlowFilter->Model[Item,CrossFlowFilter,"Dry MidiKros mPES 300 kDa"],
				SampleInVolume->10 Milliliter,
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterIncompatibleWithVolume,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowFilterIncompatibleWithVolume","An error will be shown if the specified sample volume is greater or less than the capacity of the specified filter:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (III) "<> $SessionUUID],
				CrossFlowFilter->Model[Item,CrossFlowFilter,"Dry MicroKros mPES 50 kDa"],
				SampleInVolume->200 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterIncompatibleWithVolume,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowPermeateVolumeExceedsContainer","An error will be shown if the specified PermeateAliquotVolume is greater than the capacity of the specified PermeateContainerOut:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PermeateAliquotVolume->200 Milliliter,
				PermeateContainerOut->Model[Container,Vessel,"50mL Tube"]
			],
			$Failed,
			Messages:>{Error::CrossFlowPermeateVolumeExceedsContainer,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowRetentateExceedsSample","An error will be shown if the specified RetentateAliquotVolume exceeds SampleInVolume:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				RetentateAliquotVolume->300 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowRetentateExceedsSample,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowPermeateExceedsSample","An error will be shown if the total of specified PermeateAliquotVolume for concentration steps exceeds SampleInVolume:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Concentration,
				PrimaryConcentrationTarget -> 100
			],
			$Failed,
			Messages:>{Error::CrossFlowRetentateVolumeTooLow,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowPrimeOptionSpecifiedWithoutPrime","An error will be shown if any filter priming option is specified while FilterPrime is False:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->False,
				FilterPrimeRinse->True
			],
			$Failed,
			Messages:>{Error::CrossFlowPrimeOptionSpecifiedWithoutPrime,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowPrimeOptionSpecifiedWithoutPrime","An error will be shown if any filter priming option is specified while FilterPrime is False:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrime->False,
				FilterPrimeRinse->True,
				FilterPrimeVolume->400 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowPrimeOptionSpecifiedWithoutPrime,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowFlushOptionSpecifiedWithoutFlush","An error will be shown if any filter flushing option is specified while FilterFlush is False:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlush->False,
				FilterFlushRinse->True
			],
			$Failed,
			Messages:>{Error::CrossFlowFlushOptionSpecifiedWithoutFlush,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowFlushOptionSpecifiedWithoutFlush","An error will be shown if any filter flushing option is specified while FilterFlush is False:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlush->False,
				FilterFlushRinse->True,
				FilterFlushVolume->100 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowFlushOptionSpecifiedWithoutFlush,Error::InvalidOption}
		],
		
		(* ----- Option Resolver ----- *)
		
		Example[
			{Messages,"CrossFlowNonSterileSampleReservoir","A warning will be shown if sterile was specified and the resolved SampleReservoir is not available in a sterile format:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SizeCutoff->50. Kilodalton,
				Sterile->True,
				Output->Options
			],
			_List,
			Messages:>{Warning::CrossFlowNonSterileSampleReservoir}
		],
		
		Example[
			{Messages,"CrossFlowAssumedDensity","A warning will be shown if the density of the solvent is not known, and was assumed to be 1 g/mL:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample Without Density "<> $SessionUUID],
				PrimaryConcentrationTarget->100 Gram,
				Output->Options
			],
			_List,
			Messages:>{Warning::CrossFlowAssumedDensity}
		],
		
		Example[
			{Messages,"CrossFlowAssumedDensity","A warning will be shown if the density of the solvent is not known, and was assumed to be 1 g/mL:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID],
				PrimaryConcentrationTarget->100 Gram,
				Output->Options
			],
			_List,
			Messages:>{Warning::CrossFlowAssumedDensity}
		],
		
		Example[
			{Messages,"CrossFlowInvalidDiafiltrationBuffer","An error will be shown if Null was specified as the diafiltration buffer for a diafiltration step:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltration,
				DiafiltrationBuffer->Null
			],
			$Failed,
			Messages:>{Error::CrossFlowInvalidDiafiltrationBuffer,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowInvalidSampleReservoir","An error will be shown if Null was specified as the diafiltration buffer for a diafiltration step:"},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				SampleReservoir->Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 500mL Tube"]
			],
			$Failed,
			Messages:>{Error::CrossFlowInvalidSampleReservoir,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowNonOptimalSizeCutoff","A warning will be shown if sample components do not have :"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID],
				Output->Options
			],
			_List,
			Messages:>{Warning::CrossFlowNonOptimalSizeCutoff}
		],
		
		Example[
			{Messages,"CrossFlowFilterSpecifiedMismatch","A warning will be shown if an option related to the filter and the specified filter are inconsistent:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				CrossFlowFilter->Model[Item,CrossFlowFilter,"Dry Xampler PS 50 kDa"],
				SizeCutoff->10. Kilo Dalton,
				Output->Options
			],
			_List,
			Messages:>{Warning::CrossFlowFilterSpecifiedMismatch}
		],
		
		Example[
			{Messages,"CrossFlowInvalidOutputVolumes","An error will be shown if a combination of Targets, RetentateAliquotVolume and PermeateAliquotVolume are inconsistent amongst each other (RetentateAliquotVolume exceeds the retentate volume specified by Targets):"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				PrimaryConcentrationTarget->2,
				DiafiltrationTarget->3,
				SecondaryConcentrationTarget->1.5,
				RetentateAliquotVolume->100 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowInvalidOutputVolumes,Error::InvalidOption,Error::CrossFlowRetentateExceedsSample}
		],
		
		Example[
			{Messages,"CrossFlowInvalidOutputVolumes","An error will be shown if a combination of Targets, RetentateAliquotVolume and PermeateAliquotVolume are inconsistent amongst each other (PermeateAliquotVolume exceeds the permeate volume specified by Targets):"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				PrimaryConcentrationTarget->2,
				DiafiltrationTarget->3,
				SecondaryConcentrationTarget->2,
				PermeateAliquotVolume->700 Milliliter,
				RetentateAliquotVolume->50 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowPermeateExceedsSample,Error::CrossFlowInvalidOutputVolumes,Error::InvalidOption}
		],

		Example[
			{Messages,"CrossFlowInvalidOutputVolumes","An error will be shown if a combination of Targets, RetentateAliquotVolume and PermeateAliquotVolume are inconsistent amongst each other (Both RetentateAliquotVolume and PermeateAliquotVolume exceed the volumes specified by Targets):"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->ConcentrationDiafiltrationConcentration,
				PrimaryConcentrationTarget->2,
				DiafiltrationTarget->3,
				SecondaryConcentrationTarget->2,
				PermeateAliquotVolume->600 Milliliter,
				RetentateAliquotVolume->60 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowPermeateExceedsSample,Error::CrossFlowInvalidOutputVolumes,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowRetentateVolumeTooLow","An error will be shown if the specified experiment would create a retentate volume that is below the capacity of the specified or smallest database filter and/or sample reservoir:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->248 Milliliter
			],
			$Failed,
			Messages:>{Error::CrossFlowRetentateVolumeTooLow,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowRetentateVolumeTooLow","An error will be shown if the specified experiment would create a retentate volume that is below the capacity of the specified or smallest database filter and/or sample reservoir:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->248 Gram
			],
			$Failed,
			Messages:>{Error::CrossFlowRetentateVolumeTooLow,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowRetentateVolumeTooLow","An error will be shown if the specified experiment would create a retentate volume that is below the capacity of the specified or smallest database filter and/or sample reservoir:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				PrimaryConcentrationTarget->100
			],
			$Failed,
			Messages:>{Error::CrossFlowRetentateVolumeTooLow,Error::InvalidOption,Error::CrossFlowSampleDeadVolume}
		],
		
		Example[
			{Messages,"CrossFlowPermeateExceedsCapacity","An error will be shown if the permeate volume exceeds the instrument's capacity:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Diafiltration,
				DiafiltrationTarget->20 Kilogram
			],
			$Failed,
			Messages:>{Error::CrossFlowPermeateExceedsCapacity,Error::InvalidOption}
		],
		
		Example[
			{Messages,"CrossFlowDiafiltrationBufferIgnored","A warning will be shown if a diafiltration buffer was specified for a concentration step:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Concentration,
				DiafiltrationBuffer->Model[Sample,"Milli-Q water"],
				Output->Options
			],
			_List,
			Messages:>Warning::CrossFlowDiafiltrationBufferIgnored
		],
		
		Example[
			{Messages,"CrossFlowDefaultFilterReturned","A warning will be shown if a default filter is returned:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SizeCutoff->3. Kilodalton,
				Output->Options
			],
			_List,
			Messages:>Warning::CrossFlowDefaultFilterReturned
		],
		
		Example[
			{Messages,"CrossFlowFilterSizeCutoffUnavailable","A warning will be shown if a filter with the specified SizeCutoff cannot be found:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				SizeCutoff->0.05 Micron,
				Output->Options
			],
			_List,
			Messages:>Warning::CrossFlowFilterUnavailableFilters
		],
		
		Example[
			{Messages,"CrossFlowPrimeBuffersIncompatible","A warning will be shown if the specified FilterPrimeRinseBuffer is not of the same model as the first DiafiltrationBuffer:"},
			ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Diafiltration,
				FilterPrimeRinseBuffer->Model[Sample, StockSolution,"1x PBS from 10X stock"],
				SampleInVolume -> 100 Milliliter,
				Output->Options
			],
			_List,
			Messages:>Warning::CrossFlowPrimeBuffersIncompatible
		],
		
		(* ----- Compatibility Checks -----*)
		
		Example[
			{Messages,"CrossFlowIncompatibleSample","An error will be shown if the specified sample is incompatible with the instrument:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample in Acetone "<> $SessionUUID]],
			$Failed,
			Messages:>{Error::IncompatibleMaterials,Error::InvalidInput}
		],
		
		Example[
			{Messages,"IncompatibleMaterials","An error will be shown if a specified diafiltration buffer is incompatible with the instrument:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FiltrationMode->Diafiltration,
				DiafiltrationBuffer->Model[Sample,"Acetone, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::IncompatibleMaterials,Error::InvalidOption}
		],
		
		Example[
			{Messages,"IncompatibleMaterials","An error will be shown if a specified filter prime buffer is incompatible with the instrument:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterPrimeBuffer->Model[Sample,"Acetone, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::IncompatibleMaterials,Error::InvalidOption}
		],
		
		Example[
			{Messages,"IncompatibleMaterials","An error will be shown if a specified filter flush buffer is incompatible with the instrument:"},
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				FilterFlushBuffer->Model[Sample,"Acetone, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::IncompatibleMaterials,Error::InvalidOption}
		],
		
		(* ----- Other Checks ----- *)
		
		Test[
			"An error will be shown if the specified protocol name exists in the database:",
			ExperimentCrossFlowFiltration[
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Name->"Cross Flow Test Protocol "<> $SessionUUID
			],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption}
		],

		Example[
			{Messages,"CrossFlowSampleDeadVolume","An error will be shown if the SampleIn or the expected retentate volume is lower than the system's dead volume + the sample reservoir minimum volume:"},
			ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (II) "<> $SessionUUID],
				CrossFlowFilter -> Model[Item, CrossFlowFilter,"Sartocon Slice 50 ECO Hydrosart 10 kDa"],
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				FiltrationMode -> ConcentrationDiafiltration,
				SampleInVolume -> 100 Milliliter,
				PrimaryConcentrationTarget -> 5,
				DiafiltrationTarget -> 2.5,
				Output->Options
			],
			_List,
			Messages:>{Error::CrossFlowSampleDeadVolume,Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilteConflictingFilterStorageCondition","One filter cannot be specified multiple storage conditions: "},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"],
				FilterStorageCondition -> {Refrigerator, Automatic, Disposal}
			],
			$Failed,
			Messages:>{Error::CrossFlowFilteConflictingFilterStorageCondition, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFiltrationUnneededOptions","Instrument specific options are not specified: "},
			ExperimentCrossFlowFiltration[
				Object[Sample, "Cross Flow Test Sample (II) " <> $SessionUUID],
				Instrument -> Model[Instrument, CrossFlowFiltration, "KrosFlo KR2i"],
				PrimaryPumpFlowRate -> Null
			],
			$Failed,
			Messages:>{Error::CrossFlowFiltrationRequiredOptions, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilterDoesNotMatchInstrument","Instrument specific options are not specified: "},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				CrossFlowFilter -> Model[Item, CrossFlowFilter, "Dry Xampler PS 100 kDa"],
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterDoesNotMatchInstrument, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilterInvalidDiafiltrationMode","If FiltrationMode requires diafiltration and instrument is uPulse, the DiafiltrationMode cannot be Null"},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FiltrationMode -> ConcentrationDiafiltration,
				DiafiltrationMode -> Null,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterInvalidDiafiltrationMode, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilterInvalidDiafiltrationMode","Instrument specific options are not specified: "},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FiltrationMode -> Concentration,
				DiafiltrationMode -> Discrete,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterInvalidDiafiltrationMode, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilterDiaFiltrationExchangeCount","If Instrument is specified as uPulse, and filtration mode is resolved to include Diafiltration, DiafiltrationExchangeCount needs to be specified."},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				FiltrationMode->ConcentrationDiafiltration,
				DiafiltrationMode -> Discrete,
				DiafiltrationExchangeCount -> Null,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterDiaFiltrationExchangeCount, Error::InvalidOption}
		],
		Example[
			{Messages,"CrossFlowFilterDiaFiltrationExchangeCount","Instrument specific options are not specified: "},
			ExperimentCrossFlowFiltration[
				{
					Object[Sample, "Cross Flow Test Sample For uPulse 1" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 2" <> $SessionUUID],
					Object[Sample, "Cross Flow Test Sample For uPulse 3" <> $SessionUUID]
				},
				DiafiltrationMode -> Null,
				DiafiltrationExchangeCount -> 3,
				Instrument -> Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]
			],
			$Failed,
			Messages:>{Error::CrossFlowFilterDiaFiltrationExchangeCount, Error::InvalidOption}
		]
	},
	SetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolSetUp :> (
		Module[{namedObjects,existsFilter},
			(* Clear memoization and download cache *)
			ClearDownload[];
			ClearMemoization[];

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Object[Container,Bench,"Test bench for ExperimentCrossFlowFiltration tests"<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
				Model[Sample,"Cross Flow Bacteria Test Sample "<> $SessionUUID],
				Model[Sample,"Cross Flow Yeast Test Sample "<> $SessionUUID],
				Model[Sample,"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample Single Component "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample in Acetone "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample in Acetic Acid "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample Without Density "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample With Single Solvent "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID],
				Model[Sample,"Cross Flow Mixed Test Sample "<> $SessionUUID],
				Model[Sample,"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID],
				Object[Item, Filter, MicrofluidicChip, "Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID],
				Model[Molecule,"Solvent Without Density (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 15 mL Tube "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (I) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (II) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (III) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (IV) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (V) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VI) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VII) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VIII) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (IX) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (X) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XI) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XII) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XIII) "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 2L Bottle "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow Test 10L Carboy "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow 15mL Tube for Sample Prep "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 1 "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 2 "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 3 "<> $SessionUUID],
				Object[Container,Vessel,"Cross Flow 250mL Bottle for Sample Prep "<> $SessionUUID],
				Object[Instrument,CrossFlowFiltration,"Cross Flow Test Retired Instrument "<> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow Test Protocol "<> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow Test Template Protocol "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Without Composition "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Solid "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Without Density "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (I) "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (III) "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (IV) "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (V) "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample For uPulse 1"<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample For uPulse 2"<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample For uPulse 3"<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample (VII) "<> $SessionUUID],
				Object[Sample,"Cross Flow Bacteria Test Sample "<> $SessionUUID],
				Object[Sample,"Cross Flow Yeast Test Sample "<> $SessionUUID],
				Object[Sample,"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Single Component "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Discarded "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Without Volume "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Without Container Volume "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample in Acetone "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample in Acetic Acid "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample With Single Solvent "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID],
				Object[Sample,"Cross Flow Mixed Test Sample "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
		];
		Block[{$DeveloperUpload = True},
			Module[{testBench},

				testBench = Upload[
					<|
						Type -> Object[Container, Bench],
						Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects],
						Name -> "Test bench for ExperimentCrossFlowFiltration tests"<> $SessionUUID,
						Site -> Link[$Site]
					|>,
					AllowPublicObjects -> True
				];

				(* Upload molecule without density for Targets *)
				Upload[
					<|
						Type->Model[Molecule],
						Name -> "Solvent Without Density (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
            Notebook -> Null
					|>,
					AllowPublicObjects -> True
				];

				(* Create test 40mer for sample compositions *)
				Upload[
					<|
						Type -> Model[Molecule, Oligomer],
						Name -> "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
						ExactMass -> Quantity[12167., ("Grams")/("Moles")],
						Replace[ExtinctionCoefficients] -> {
							<|
								Wavelength -> Quantity[260, "Nanometers"],
							ExtinctionCoefficient -> Quantity[369600, ("Liters")/("Centimeters" "Moles")]
							|>
						},
						Replace[IncompatibleMaterials] -> {None},
						MolecularWeight -> Quantity[12167.8, ("Grams")/("Moles")],
						Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["CCGTTCGGACGATATCTTCTCCCGCACGTTAGACGCCTAA"]]}, {}],
						MSDSRequired -> False,
						PolymerType -> DNA,
						State -> Solid,
						Replace[Synonyms] -> {Null},
						Notebook -> Null
					|>,
					AllowPublicObjects -> True
				];

				(* Upload sample models *)
				Block[{$AllowPublicObjects = True},
					UploadSampleModel[
						{
							"Cross Flow Test Sample "<> $SessionUUID,
							"Cross Flow Bacteria Test Sample "<> $SessionUUID,
							"Cross Flow Yeast Test Sample "<> $SessionUUID,
							"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID,
							"Cross Flow Test Sample Single Component "<> $SessionUUID,

							(* Non-aqueous solutions *)
							"Cross Flow Test Sample in Acetone "<> $SessionUUID,
							"Cross Flow Test Sample in Acetic Acid "<> $SessionUUID,
							(* Sample without density *)
							"Cross Flow Test Sample Without Density "<> $SessionUUID,

							(* Samples with specified solvent field *)
							"Cross Flow Test Sample With Single Solvent "<> $SessionUUID,
							"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID,

							"Cross Flow Mixed Test Sample "<> $SessionUUID,
							"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID
						},
						Composition -> {
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Cell,Bacteria,"E.coli MG1655"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Cell,Yeast,"S. cerevisiae S288C"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Cell,Mammalian,"HEK293"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Acetone"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Acetic acid"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Solvent Without Density (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]}
							},
							{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{50 VolumePercent,Link[Model[Molecule,"Water"]]},
								{50 VolumePercent,Link[Model[Molecule,"Ethanol"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{50 VolumePercent,Link[Model[Molecule,"Water"]]},
								{50 VolumePercent,Link[Model[Molecule,"Ethanol"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							{
								{99 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 VolumePercent,Link[Model[Molecule,"Solvent Without Density (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]}
							}
						},
						IncompatibleMaterials -> {
							{None},
							{None},
							{None},
							{None},
							{None},
							{ABS,Nitrile,CPVC,Noryl,Polycarbonate,Polyurethane,PVC,PVDF,Silicone,Tygon,Viton},
							{ABS,Delrin,Brass,CarbonSteel,CastIron,Nylon,Polyurethane,PVC,StainlessSteel,Tygon},
							{None},
							{None},
							{None},
							{None},
							{None}
						},
						State -> {
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid,
							Liquid
						},
						DefaultStorageCondition -> {
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition, "Ambient Storage, Flammable"],
							Model[StorageCondition, "Ambient Storage, Flammable Acid"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"],
							Model[StorageCondition,"Ambient Storage"]
						},
						Solvent -> {
							Null,
							Null,
							Null,
							Null,
							Null,
							Null,
							Null,
							Null,
							Model[Sample, "Milli-Q water"],
							Model[Sample, StockSolution, "50% Ethanol"],
							Null,
							Null
						},
						Expires -> False,
						BiosafetyLevel -> "BSL-1",
						Flammable -> {
							False,
							False,
							False,
							False,
							False,
							True,
							True,
							False,
							False,
							False,
							False,
							False
						},
						MSDSRequired -> {
							False,
							False,
							False,
							False,
							False,
							True,
							True,
							False,
							False,
							False,
							False,
							False
						},
						NFPA -> {
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{2, 3, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null},
							{0, 0, 0, Null}
						},
						DOTHazardClass -> {
							"Class 0",
							"Class 0",
							"Class 0",
							"Class 0",
							"Class 0",
							"Class 3 Flammable Liquids Hazard",
							"Class 8 Division 8 Corrosives Hazard",
							"Class 0",
							"Class 0",
							"Class 0",
							"Class 0",
							"Class 0"
						},
						MSDSFile -> {
							Null,
							Null,
							Null,
							Null,
							Null,
							Object[EmeraldCloudFile, "id:R8e1Pjpnb1bp"],
							Object[EmeraldCloudFile, "id:3em6ZvL7j6OL"],
							Null,
							Null,
							Null,
							Null,
							Null
						},
						Living -> False
					]
				];

				(* Upload containers *)
				Block[{$AllowPublicObjects = True},
					UploadSample[
						{
							Model[Container,Vessel,"15mL Tube"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"250mL Glass Bottle"],
							Model[Container,Vessel,"2L Glass Bottle"],
							Model[Container,Vessel,"10L Polypropylene Carboy"],
							Model[Container,Vessel,"15mL Tube"],
							Model[Container,Vessel,"50mL Tube"],
							Model[Container,Vessel,"50mL Tube"],
							Model[Container,Vessel,"50mL Tube"],
							Model[Container,Vessel,"250mL Glass Bottle"]
						},
						ConstantArray[{"Work Surface",testBench},21],
						Name -> {
							"Cross Flow Test 15 mL Tube "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (I) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (II) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (III) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (IV) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (V) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (VI) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (VII) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (VIII) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (IX) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (X) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (XI) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (XII) "<> $SessionUUID,
							"Cross Flow Test 250 mL Bottle (XIII) "<> $SessionUUID,
							"Cross Flow Test 2L Bottle "<> $SessionUUID,
							"Cross Flow Test 10L Carboy "<> $SessionUUID,
							"Cross Flow 15mL Tube for Sample Prep "<> $SessionUUID,
							"Cross Flow 50mL Tube for Sample Prep 1 "<> $SessionUUID,
							"Cross Flow 50mL Tube for Sample Prep 2 "<> $SessionUUID,
							"Cross Flow 50mL Tube for Sample Prep 3 "<> $SessionUUID,
							"Cross Flow 250mL Bottle for Sample Prep "<> $SessionUUID
						}
					]
				];

				(* Miscellaneous uploads *)
				Upload[
					{
						(* Test Microfluidic chip *)
						<|
							Type->Object[Item, Filter, MicrofluidicChip],
							Name->"Test CrossFlowFiltration Microfluidic Chip"<> $SessionUUID,
							Site->Link[$Site],
							Model->Link[Model[Item, Filter, MicrofluidicChip, "Formulatrix MicroPulse Filter Chip 5 kDa"],Objects]
						|>,

						(* Retired instrument *)
						<|
							Type->Object[Instrument,CrossFlowFiltration],
							Model->Link[Model[Instrument,CrossFlowFiltration,"KrosFlo KR2i"],Objects],
							Name->"Cross Flow Test Retired Instrument "<> $SessionUUID,
							Site->Link[$Site],
							Status->Retired
						|>,

						(* Protocol for duplicate name check *)
						<|
							Type->Object[Protocol,CrossFlowFiltration],
							Name->"Cross Flow Test Protocol "<> $SessionUUID,
							Site->Link[$Site],
							DeveloperObject->True
						|>
					},
					AllowPublicObjects -> True
				];

				(* Make the samples *)
				Block[{$AllowPublicObjects = True},
					UploadSample[
						{
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Bacteria Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Yeast Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample Single Component "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample in Acetone "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample in Acetic Acid "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample Without Density "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample With Single Solvent "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID],
							Model[Sample,"Cross Flow Mixed Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID],
							Model[Sample,"Cross Flow Test Sample "<> $SessionUUID]
						},
						{
							{"A1",Object[Container,Vessel,"Cross Flow Test 15 mL Tube "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (I) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 2L Bottle "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 10L Carboy "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (II) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (III) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (IV) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (V) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VI) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VII) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (VIII) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (IX) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (X) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XI) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XII) "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow 15mL Tube for Sample Prep "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 1 "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 2 "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow 50mL Tube for Sample Prep 3 "<> $SessionUUID]},
							{"A1",Object[Container,Vessel,"Cross Flow 250mL Bottle for Sample Prep "<> $SessionUUID]}
						},
						Name->{
							"Cross Flow Test Sample (I) "<> $SessionUUID,
							"Cross Flow Test Sample (II) "<> $SessionUUID,
							"Cross Flow Test Sample (III) "<> $SessionUUID,
							"Cross Flow Test Sample (IV) "<> $SessionUUID,
							"Cross Flow Bacteria Test Sample "<> $SessionUUID,
							"Cross Flow Yeast Test Sample "<> $SessionUUID,
							"Cross Flow Mammalian Cell Test Sample "<> $SessionUUID,
							"Cross Flow Test Sample Single Component "<> $SessionUUID,
							"Cross Flow Test Sample in Acetone "<> $SessionUUID,
							"Cross Flow Test Sample in Acetic Acid "<> $SessionUUID,
							"Cross Flow Test Sample Without Density "<> $SessionUUID,
							"Cross Flow Test Sample With Single Solvent "<> $SessionUUID,
							"Cross Flow Test Sample With Multiple Solvents "<> $SessionUUID,
							"Cross Flow Mixed Test Sample "<> $SessionUUID,
							"Cross Flow Test Sample Without Molecular Weight "<> $SessionUUID,
							"Cross Flow Test Sample (V) "<> $SessionUUID,
							"Cross Flow Test Sample For uPulse 1"<> $SessionUUID,
							"Cross Flow Test Sample For uPulse 2"<> $SessionUUID,
							"Cross Flow Test Sample For uPulse 3"<> $SessionUUID,
							"Cross Flow Test Sample (VII) "<> $SessionUUID
						},
						InitialAmount->{
							10 Milliliter,
							250 Milliliter,
							1 Liter,
							10 Liter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							250 Milliliter,
							15 Milliliter,
							40 Milliliter,
							40 Milliliter,
							40 Milliliter,
							250 Milliliter
						},
						Status->{
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
							Available,
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
						}
					]
				];

				(* Upload sample objects that do not pass ValidObjectQ *)

				Upload[
					{
						(* Upload sample without volume -- we need the container so we are uploading separately *)
						<|
							Type->Object[Sample],
							Name->"Cross Flow Test Sample Without Volume "<> $SessionUUID,
							State->Liquid,
							Replace[Composition]->{
								{100 VolumePercent,Link[Model[Molecule,"Water"]],Now},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]],Now},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]],Now}
							},
							Replace[IncompatibleMaterials]->None,
							Container->Link[Object[Container,Vessel,"Cross Flow Test 250 mL Bottle (XIII) "<> $SessionUUID],Contents,2],
							Status->Available,
							Site->Link[$Site]
						|>,
						(* Sample without composition *)
						<|
							Type->Object[Sample],
							Name->"Cross Flow Test Sample Without Composition "<> $SessionUUID,
							Volume->250 Milliliter,
							Replace[IncompatibleMaterials]->None,
							Site->Link[$Site],
							DeveloperObject->True
						|>,

						(* Solid sample *)
						<|
							Type->Object[Sample],
							Name->"Cross Flow Test Sample Solid "<> $SessionUUID,
							State->Solid,
							Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now}},
							Replace[IncompatibleMaterials]->None,
							Volume->250 Milliliter,
							Site->Link[$Site],
							DeveloperObject->True
						|>,

						(* Discarded sample *)
						<|
							Type->Object[Sample],
							Name->"Cross Flow Test Sample Discarded "<> $SessionUUID,
							State->Liquid,
							Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now}},
							Replace[IncompatibleMaterials]->None,
							Volume->250 Milliliter,
							Status->Discarded,
							Site->Link[$Site],
							DeveloperObject->True
						|>,

						(* Sample without container volume *)
						<|
							Type->Object[Sample],
							Name->"Cross Flow Test Sample Without Container Volume "<> $SessionUUID,
							State->Liquid,
							Replace[Composition]->{{100 VolumePercent,Link[Model[Molecule,"Water"]],Now}},
							Replace[IncompatibleMaterials]->None,
							Site->Link[$Site],
							Status->Available,
							DeveloperObject->True
						|>
					},
					AllowPublicObjects -> True
				];

				(* Generate a template protocol *)
				Block[{$AllowPublicObjects = True},
					Quiet[
						ExperimentCrossFlowFiltration[
							Object[Sample,"Cross Flow Test Sample (II) "<> $SessionUUID],
							FiltrationMode->ConcentrationDiafiltration,
							SampleInVolume->200 Milliliter,
							DiafiltrationTarget->2.5,
							PrimaryConcentrationTarget->4,
							SizeCutoff->50.Kilogram/Mole,
							Name->"Cross Flow Test Template Protocol "<> $SessionUUID
						],
						Warning::CrossFlowFilterUnavailableFilters
					]
				];

			]
		]
	),
	TearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	},
	SymbolTearDown:>(
		{

			(* Erase all created objects *)
			EraseObject[$CreatedObjects,Force->True,Verbose->False];

			(* Unset $CreatedObjects *)
			$CreatedObjects=.;
		}
	),
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"],
		$DeveloperUpload=True
	},
	Parallel -> True
];


(* ::Subsection::Closed:: *)
(*ExperimentCrossFlowFiltrationOptions*)


DefineTests[ExperimentCrossFlowFiltrationOptions,
	{
		Example[
			{Basic,"Return a table with the resolved options of a ExperimentCrossFlowFiltration call:"},
			ExperimentCrossFlowFiltrationOptions[Object[Sample,"Cross Flow Test Sample Options "<> $SessionUUID]],
			_Grid
		],
		
		Example[
			{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentCrossFlowFiltrationOptions[
				Object[Sample,"Cross Flow Test Sample Options "<> $SessionUUID],
				RetentateAliquotVolume->300 Milliliter
			],
			_Grid,
			Messages:>{Error::CrossFlowRetentateExceedsSample,Error::InvalidOption}
		],
		
		Example[
			{Options,OutputFormat,"Indicates if the output is a list or a table:"},
			ExperimentCrossFlowFiltrationOptions[Object[Sample,"Cross Flow Test Sample Options "<> $SessionUUID],OutputFormat->List],
			_List
		]
	},
	
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[{namedObjects,existsFilter},

				(* Initialize $CreatedObjects *)
				$CreatedObjects={};

				(* Test objects we will create *)
				namedObjects={
					Model[Sample,"Cross Flow Test Sample Model Options "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample Options "<> $SessionUUID],
					Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
					Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube Options "<> $SessionUUID]
				};

				(* Check whether the names already exist in the database *)
				existsFilter=DatabaseMemberQ[namedObjects];

				(* Erase any objects that exists in the database *)
				EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

				(* Create test 40mer for sample compositions *)
				Upload[
					<|
						Type -> Model[Molecule, Oligomer],
						Name -> "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
						ExactMass -> Quantity[12167., ("Grams")/("Moles")],
						Replace[ExtinctionCoefficients] -> {
							<|
								Wavelength -> Quantity[260, "Nanometers"],
								ExtinctionCoefficient -> Quantity[369600, ("Liters")/("Centimeters" "Moles")]
							|>
						},
						Replace[IncompatibleMaterials] -> {None},
						MolecularWeight -> Quantity[12167.8, ("Grams")/("Moles")],
						Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["CCGTTCGGACGATATCTTCTCCCGCACGTTAGACGCCTAA"]]}, {}],
						MSDSRequired -> False,
						PolymerType -> DNA,
						State -> Solid,
						Replace[Synonyms] -> {Null},
						Notebook -> Null
					|>,
					AllowPublicObjects -> True
				];

				(* Upload the objects *)
				Upload[
					{
						<|
							Type->Model[Sample],
							Name->"Cross Flow Test Sample Model Options "<> $SessionUUID,
							Replace[Composition]->{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							Replace[IncompatibleMaterials]->None,
							State->Liquid,
							DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
							DeveloperObject->True
						|>,
						<|
							Type->Object[Container,Vessel,CrossFlowContainer],
							Name->"Cross Flow Test 250 mL Tube Options "<> $SessionUUID,
							Model->Link[Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 250mL Tube"],Objects],
							DeveloperObject->True,
							Site->Link[$Site]
						|>
					}
				];

				ECL`InternalUpload`UploadSample[
					Model[Sample,"Cross Flow Test Sample Model Options "<> $SessionUUID],
					{"A1",Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube Options "<> $SessionUUID]},
					Name->"Cross Flow Test Sample Options "<> $SessionUUID,
					InitialAmount->250 Milliliter,
					Status->Available
				];
			]
		}
	),
	
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		{

			(* Erase all created objects *)
			EraseObject[$CreatedObjects,Force->True,Verbose->False];

			(* Unset $CreatedObjects *)
			$CreatedObjects=.;
		}
	),
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ValidExperimentCrossFlowFiltrationQ*)


DefineTests[ValidExperimentCrossFlowFiltrationQ,
	{
		
		Example[
			{Basic,"Check if an ExperimentCrossFlowFiltration call is valid:"},
			ValidExperimentCrossFlowFiltrationQ[Object[Sample,"Cross Flow Test Sample ValidQ "<> $SessionUUID]],
			True
		],
		
		Example[
			{Options,OutputFormat,"Indicates whether the function returns a boolean or the test summaries:"},
			ValidExperimentCrossFlowFiltrationQ[Object[Sample,"Cross Flow Test Sample ValidQ "<> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		
		Example[
			{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentCrossFlowFiltrationQ[Object[Sample,"Cross Flow Test Sample ValidQ "<> $SessionUUID],Verbose->Failures],
			True
		]
	},
	
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		{
			Module[{namedObjects,existsFilter},

				(* Initialize $CreatedObjects *)
				$CreatedObjects={};

				(* Test objects we will create *)
				namedObjects={
					Model[Sample,"Cross Flow Test Sample Model ValidQ "<> $SessionUUID],
					Object[Sample,"Cross Flow Test Sample ValidQ "<> $SessionUUID],
					Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
					Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube ValidQ "<> $SessionUUID]
				};

				(* Check whether the names already exist in the database *)
				existsFilter=DatabaseMemberQ[namedObjects];

				(* Erase any objects that exists in the database *)
				EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

				(* Create test 40mer for sample compositions *)
				Upload[
					<|
						Type -> Model[Molecule, Oligomer],
						Name -> "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
						ExactMass -> Quantity[12167., ("Grams")/("Moles")],
						Replace[ExtinctionCoefficients] -> {
							<|
								Wavelength -> Quantity[260, "Nanometers"],
								ExtinctionCoefficient -> Quantity[369600, ("Liters")/("Centimeters" "Moles")]
							|>
						},
						Replace[IncompatibleMaterials] -> {None},
						MolecularWeight -> Quantity[12167.8, ("Grams")/("Moles")],
						Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["CCGTTCGGACGATATCTTCTCCCGCACGTTAGACGCCTAA"]]}, {}],
						MSDSRequired -> False,
						PolymerType -> DNA,
						State -> Solid,
						Replace[Synonyms] -> {Null},
						Notebook -> Null
					|>,
					AllowPublicObjects -> True
				];

				(* Upload the objects *)
				Upload[
					{
						<|
							Type->Model[Sample],
							Name->"Cross Flow Test Sample Model ValidQ "<> $SessionUUID,
							Replace[Composition]->{
								{100 VolumePercent,Link[Model[Molecule,"Water"]]},
								{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
								{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
							},
							Replace[IncompatibleMaterials]->None,
							State->Liquid,
							DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
							DeveloperObject->True
						|>,
						<|
							Type->Object[Container,Vessel,CrossFlowContainer],
							Name->"Cross Flow Test 250 mL Tube ValidQ "<> $SessionUUID,
							Model->Link[Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 250mL Tube"],Objects],
							DeveloperObject->True,
							Site->Link[$Site]
						|>
					}
				];

				ECL`InternalUpload`UploadSample[
					Model[Sample,"Cross Flow Test Sample Model ValidQ "<> $SessionUUID],
					{"A1",Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube ValidQ "<> $SessionUUID]},
					Name->"Cross Flow Test Sample ValidQ "<> $SessionUUID,
					InitialAmount->250 Milliliter,
					Status->Available
				];
			]
		}
	),
	
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	),
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*ExperimentCrossFlowFiltrationPreview*)


DefineTests[ExperimentCrossFlowFiltrationPreview,
	{
		Example[
			{Basic,"No preview is currently available for ExperimentCrossFlowFiltration:"},
			ExperimentCrossFlowFiltrationPreview[Object[Sample,"Cross Flow Test Sample Preview "<> $SessionUUID]],
			Null
		],
		
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentCrossFlowFiltrationOptions:"},
			ExperimentCrossFlowFiltrationOptions[Object[Sample,"Cross Flow Test Sample Preview "<> $SessionUUID]],
			_Grid
		],
		
		Example[{Additional,"For ExperimentCrossFlowFiltration, Preview output returns Null:"},
			ExperimentCrossFlowFiltration[Object[Sample,"Cross Flow Test Sample Preview "<> $SessionUUID],Output->Preview],
			Null
		]
	},
	
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects,existsFilter},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Sample,"Cross Flow Test Sample Model Preview "<> $SessionUUID],
				Object[Sample,"Cross Flow Test Sample Preview "<> $SessionUUID],
				Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube Preview "<> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Create test 40mer for sample compositions *)
			Upload[
				<|
					Type -> Model[Molecule, Oligomer],
					Name -> "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
					ExactMass -> Quantity[12167., ("Grams")/("Moles")],
					Replace[ExtinctionCoefficients] -> {
						<|
							Wavelength -> Quantity[260, "Nanometers"],
							ExtinctionCoefficient -> Quantity[369600, ("Liters")/("Centimeters" "Moles")]
						|>
					},
					Replace[IncompatibleMaterials] -> {None},
					MolecularWeight -> Quantity[12167.8, ("Grams")/("Moles")],
					Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["CCGTTCGGACGATATCTTCTCCCGCACGTTAGACGCCTAA"]]}, {}],
					MSDSRequired -> False,
					PolymerType -> DNA,
					State -> Solid,
					Replace[Synonyms] -> {Null},
					Notebook -> Null
				|>,
				AllowPublicObjects -> True
			];

			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Model[Sample],
						Name->"Cross Flow Test Sample Model Preview "<> $SessionUUID,
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
							{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
						},
						Replace[IncompatibleMaterials]->None,
						State->Liquid,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject->True
					|>,
					<|
						Type->Object[Container,Vessel,CrossFlowContainer],
						Name->"Cross Flow Test 250 mL Tube Preview "<> $SessionUUID,
						Model->Link[Model[Container,Vessel,CrossFlowContainer,"Non-Irradiated Conical 250mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site]
					|>
				}
			];

			ECL`InternalUpload`UploadSample[
				Model[Sample,"Cross Flow Test Sample Model Preview "<> $SessionUUID],
				{"A1",Object[Container,Vessel,CrossFlowContainer,"Cross Flow Test 250 mL Tube Preview "<> $SessionUUID]},
				Name->"Cross Flow Test Sample Preview "<> $SessionUUID,
				InitialAmount->250 Milliliter,
				Status->Available
			];
		]
	),
	
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects, Force->True, Verbose->False];

		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	),
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];


(* ::Subsection::Closed:: *)
(*CrossFlowFiltration*)

DefineTests[CrossFlowFiltration,
	{
		Example[
			{Basic,"Generate a Protocol with multiple samples based on CrossFlowFiltration unit operation:"},
			ExperimentSamplePreparation[
				CrossFlowFiltration[
					Sample -> {
						Object[Sample, "CrossFlowFiltration Sample 2 " <> $SessionUUID],
						Object[Sample, "CrossFlowFiltration Sample 3 " <> $SessionUUID],
						Object[Sample, "CrossFlowFiltration Sample 1 " <> $SessionUUID]
					}
				]
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Basic,"Generate a Protocol based on a single CrossFlowFiltration unit operation:"},
			ExperimentManualSamplePreparation[{
				CrossFlowFiltration[
					Sample ->Object[Sample, "CrossFlowFiltration Sample 2 " <> $SessionUUID],
					PrimaryConcentrationTarget -> 5, SecondaryConcentrationTarget -> 2.5,
					DiafiltrationBuffer->Model[Sample,StockSolution,"0.2M FITC"]
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],

		Example[{Basic,"Generate a Protocol using CrossFlowFiltration in a series of unit operations:"},
			ExperimentManualSamplePreparation[
				{
					LabelSample[
						Sample -> Model[Sample, "Milli-Q water"],
						Amount -> 40 Milliliter,
						Label -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"}
					],
					CrossFlowFiltration[
						Sample -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"},
						DiafiltrationBuffer -> Model[Sample, StockSolution, "0.2M FITC"],
						RetentateContainerOut -> {Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"], Model[Container, Vessel, "id:jLq9jXvA8ewR"]},
						RetentateSampleOutLabel -> {"Retentate Out Sample 1", "Retentate Out Sample 2", "Retentate Out Sample 3"}
					],
					Transfer[
						Source -> {"my cff sample 1", "my cff sample 2", "my cff sample 3"},
						Destination -> Object[Container, Vessel, "CrossFlowFiltration Test 250 mL Bottle 1 "<> $SessionUUID],
						Amount -> All
					]
				}
			],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],

		Test["Generate a Protocol using MagneticBeadSeparation for a mixture of sample and container inputs:",
			ExperimentManualSamplePreparation[{
				LabelContainer[
					Label->{"my cff container 1","my cff container 2","my cff container 3"},
					Container->Model[Container, Vessel, "50mL Tube"]
				],
				Transfer[
					Source->Model[Sample, "Milli-Q water"],
					Amount->40 Milliliter,
					Destination->{"my cff container 1","my cff container 2","my cff container 3"},
					DestinationLabel-> {"my cff sample 1","my cff sample 2","my cff sample 3"}
				],
				CrossFlowFiltration[
					Sample ->{"my cff sample 1","my cff sample 2","my cff sample 3"}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		]
	},

	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects,existsFilter},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Sample, "CrossFlowFiltration Test Sample Model "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 2 "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 3 "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 1 "<> $SessionUUID],
				Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 2 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 1 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 3 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 250 mL Bottle 1 "<> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Create test 40mer for sample compositions *)
			Upload[
				<|
					Type -> Model[Molecule, Oligomer],
					Name -> "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID,
					ExactMass -> Quantity[12167., ("Grams")/("Moles")],
					Replace[ExtinctionCoefficients] -> {
						<|
							Wavelength -> Quantity[260, "Nanometers"],
							ExtinctionCoefficient -> Quantity[369600, ("Liters")/("Centimeters" "Moles")]
						|>
					},
					Replace[IncompatibleMaterials] -> {None},
					MolecularWeight -> Quantity[12167.8, ("Grams")/("Moles")],
					Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["CCGTTCGGACGATATCTTCTCCCGCACGTTAGACGCCTAA"]]}, {}],
					MSDSRequired -> False,
					PolymerType -> DNA,
					State -> Solid,
					Replace[Synonyms] -> {Null},
					Notebook -> Null
				|>,
				AllowPublicObjects -> True
			];

			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Model[Sample],
						Name->"CrossFlowFiltration Test Sample Model "<> $SessionUUID,
						Replace[Composition]->{
							{100 VolumePercent,Link[Model[Molecule,"Water"]]},
							{1 Molar,Link[Model[Molecule,Oligomer,"Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID]]},
							{1 Molar,Link[Model[Molecule,Protein,"PARP"]]}
						},
						Replace[IncompatibleMaterials]->None,
						State->Liquid,
						DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
						DeveloperObject->True
					|>,
					<|
						Type->Object[Container,Vessel],
						Name->"CrossFlowFiltration Test 50 mL Tube 1 "<> $SessionUUID,
						Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site]
					|>,
					<|
						Type->Object[Container,Vessel],
						Name->"CrossFlowFiltration Test 50 mL Tube 2 "<> $SessionUUID,
						Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site]
					|>,
					<|
						Type->Object[Container,Vessel],
						Name->"CrossFlowFiltration Test 50 mL Tube 3 "<> $SessionUUID,
						Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
						DeveloperObject->True,
						Site->Link[$Site]
					|>,
					<|
						Type->Object[Container,Vessel],
						Name->"CrossFlowFiltration Test 250 mL Bottle 1 "<> $SessionUUID,
						Model->Link[Model[Container, Vessel, "250mL Glass Bottle"],Objects],
						DeveloperObject->True,
						Site->Link[$Site]
					|>
				}
			];

			ECL`InternalUpload`UploadSample[
				{
					Model[Sample, "CrossFlowFiltration Test Sample Model " <> $SessionUUID],
					Model[Sample, "CrossFlowFiltration Test Sample Model " <> $SessionUUID],
					Model[Sample, "CrossFlowFiltration Test Sample Model " <> $SessionUUID]
				},
				{
					{"A1",Object[Container,Vessel,"CrossFlowFiltration Test 50 mL Tube 1 "<> $SessionUUID]},
					{"A1",Object[Container,Vessel,"CrossFlowFiltration Test 50 mL Tube 2 "<> $SessionUUID]},
					{"A1",Object[Container,Vessel,"CrossFlowFiltration Test 50 mL Tube 3 "<> $SessionUUID]}
				},
				Name-> {
					"CrossFlowFiltration Sample 1 " <> $SessionUUID,
					"CrossFlowFiltration Sample 2 " <> $SessionUUID,
					"CrossFlowFiltration Sample 3 " <> $SessionUUID
				},
				InitialAmount->40 Milliliter,
				Status->Available
			];
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all created objects *)
		EraseObject[$CreatedObjects, Force->True, Verbose->False];

		(* Unset $CreatedObjects *)
		Unset[$CreatedObjects];

		Module[{namedObjects,existsFilter},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Model[Sample, "CrossFlowFiltration Test Sample Model "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 2 "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 3 "<> $SessionUUID],
				Object[Sample, "CrossFlowFiltration Sample 1 "<> $SessionUUID],
				Model[Molecule, Oligomer, "Test 40mer (Test for ExperimentCrossFlowFiltration) " <> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 2 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 1 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 50 mL Tube 3 "<> $SessionUUID],
				Object[Container, Vessel, "CrossFlowFiltration Test 250 mL Bottle 1 "<> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

		];
	),

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];
