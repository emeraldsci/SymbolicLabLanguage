(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*Experiment FPLC: Tests*)





(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*FPLC*)


(* ::Subsubsection:: *)
(*ExperimentFPLC*)


DefineTests[
	ExperimentFPLC,
	{
		Example[{Basic, "Generates and returns a protocol object when given samples:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]}],
			ObjectP[Object[Protocol, FPLC]]
		],
		Example[{Basic, "Generates and returns a protocol object when given one unlisted sample:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID]],
			ObjectP[Object[Protocol, FPLC]]
		],
		Example[{Basic, "Generates and returns a protocol object when given a container:"},
			ExperimentFPLC[{Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID]}],
			ObjectP[Object[Protocol, FPLC]]
		],

		(* --- Additional --- *)
		Example[{Additional, "An oligomer sample should resolve to 260 Nanometer for the primary wavelength:"},
			options=ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],Output->Options];
			Lookup[options,Wavelength],
			{260 Nanometer, 280 Nanometer},
			Variables:>{options}
		],
		Example[{Additional, "A protein sample should resolve to 280 Nanometer for the primary wavelength:"},
			options=ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],Output->Options];
			Lookup[options,Wavelength],
			{280 Nanometer, 260 Nanometer},
			Variables:>{options}
		],
		Example[{Additional, "Inject and separate directly from large volume containers. InjectionType should indicate this, and cleaning solutions/cap should requested:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionVolume -> {900*Milliliter, 12*Milliliter, 2*Liter},
				Aliquot -> False
			];
			Download[protocol,{InjectionTypes,SampleCaps,SystemPrimeCleaningBuffers,SystemFlushCleaningBuffers,SystemPrimeBufferContainerPlacements,SystemFlushBufferContainerPlacements}],
			{
				{FlowInjection, FlowInjection, FlowInjection},
				{Null, LinkP[],LinkP[],LinkP[], Null},
				{Null, LinkP[],LinkP[],LinkP[], Null},
				{Null, LinkP[],LinkP[],LinkP[], Null},
				{
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}}
				},
				{
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}},
					{LinkP[], {_String..}}
				}
			},
			Variables:>{protocol}
		],
		Example[{Additional, "Inject and separate large samples, even from the wrong type of container (aliquoted):"},
			protocol=ExperimentFPLC[
				Object[Sample, "FPLC Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID],
				InjectionVolume -> 2*Liter
			];
			Lookup[Download[protocol,ResolvedOptions],Aliquot],
			{True},
			Variables:>{protocol},
			TimeConstraint -> 1000
		],
		Example[{Additional, "The SeparationMode should resolve from the specified column, if supplied:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Blank -> Model[Sample,"Milli-Q water"],
				Standard -> Model[Sample,StockSolution,Standard,"IDT ssDNA Ladder 20-100 nt, 225 ng/uL"],
				Column -> Model[Item, Column, "HiTrap Q HP 5x5mL Column"],
				Output -> Options
			];
			Lookup[options,SeparationMode],
			IonExchange,
			Variables:>{options}
		],
		Example[{Additional, "The Detector option can take a singleton specification:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Blank -> Model[Sample,"Milli-Q water"],
				Standard -> Model[Sample,StockSolution,Standard,"IDT ssDNA Ladder 20-100 nt, 225 ng/uL"],
				Detector -> Absorbance,
				Output -> Options
			];
			Lookup[options,Detector],
			Absorbance,
			Variables:>{options}
		],
		Example[{Additional, "Be able to set the column prime/flush buffers to Null:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Blank -> Model[Sample,"Milli-Q water"],
				Standard -> Model[Sample,StockSolution,Standard,"IDT ssDNA Ladder 20-100 nt, 225 ng/uL"],
				ColumnPrimeGradientA -> Null,
				Output -> Options
			];
			injectionTable=Lookup[options,InjectionTable];
			{MemberQ[injectionTable[[All,1]],ColumnPrime],MemberQ[injectionTable[[All,1]],ColumnFlush]},
			{False,True},
			Variables:>{options, injectionTable}
		],
		Example[{Additional, "Fill in the sample of the injection table even if just automatic:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Sample, Automatic, Autosampler, 25 Microliter, Automatic }
				},
				Output->Options
			];
			Lookup[options,InjectionTable][[1,2]],
			ObjectP[Object[Sample, "FPLC Test Oligo" <> $SessionUUID]],
			Variables:>{options}
		],
		Example[{Additional, "Fill in the automatic entries of the InjectionTable:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{
						ColumnPrime,
						Null,
						Null,
						Automatic,
						Automatic
					},
					{
						Sample,
						Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
						Automatic,
						25 Microliter,
						Automatic
					},
					{
						ColumnFlush,
						Null,
						Null,
						Automatic,
						Automatic
					}
				},
				Column -> Model[Item, Column, "id:1ZA60vwjbbm5"],
				Output->Options
			];
			Lookup[options,InjectionTable][[All,5]],
			List[
				ObjectP[Object[Method,Gradient]],
				ObjectP[Object[Method,Gradient]],
				ObjectP[Object[Method,Gradient]]
			],
			Variables:>{options}
		],
		Example[{Additional, "Fill in the automatic entries of the InjectionTable II:"},
			options=ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{
						ColumnPrime,
						Automatic,
						Automatic,
						Automatic,
						Automatic
					},
					{
						Sample,
						Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
						Autosampler,
						25Microliter,
						Automatic
					},
					{
						ColumnFlush,
						Automatic,
						Automatic,
						Automatic,
						Automatic
					}
				},
				Column -> Model[Item, Column, "id:1ZA60vwjbbm5"],
				Output->Options
			];
			Lookup[options,InjectionTable][[All,2]],
			List[
				Null,
				ObjectP[Object[Sample]],
				Null
			],
			Variables:>{options}
		],
		Example[{Additional, "Number of Replicates should result in an uploadable, expanded Injection table:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Blank -> Model[Sample, "Milli-Q water"],
				Standard ->	Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				NumberOfReplicates -> 2];
			Type/.Download[protocol,InjectionTable],
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables:>{protocol}
		],
		Example[{Additional, "Gradients should be able to be defined as a single percentage:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientA -> 60 Percent,
				Output->Options
			];
			Lookup[options,Gradient],
			{
				{Quantity[0., "Minutes"], Quantity[60, "Percent"], Quantity[40, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
				{Quantity[10, "Minutes"], Quantity[60, "Percent"], Quantity[40, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[1, ("Milliliters")/("Minutes")]}
			},
			Variables:>{options}
		],
		Example[{Additional, "Be able to define a varying flow rate:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient-> {
					{Quantity[0., "Minutes"], Quantity[60, "Percent"], Quantity[40, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"],  Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[10, "Minutes"], Quantity[60, "Percent"], Quantity[40, "Percent"], Quantity[0, "Percent"], Quantity[0, "Percent"], Quantity[2, ("Milliliters")/("Minutes")]}
				},
				Output->Options
			];
			Lookup[options,Gradient][[All,-1]],
			{Quantity[1, ("Milliliters")/("Minutes")], Quantity[2, ("Milliliters")/("Minutes")]},
			Variables:>{options}
		],
		Example[{Additional, "Be able to set a ColumnRefreshFrequency to a number:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnRefreshFrequency->1,
				Output->Options
			];
			Count[Lookup[options,InjectionTable][[All,1]],ColumnPrime],
			2,
			Variables:>{options}
		],

		(*re insert this when we have a high flow rate column*)
		(*Example[{Additional, "Defining a high flow rate should resolve to the 150 Avant:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FlowRate->100 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument, FPLC, "AKTA avant 150"]],
			Variables:>{options}
		],*)

		(*hopefully can improve this absurdity *)
		Example[{Additional, "Be able to use the AKTA10 by placing the Blank into the sample plate:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument->Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				Blank->Object[Sample,  "FPLC Test Water Sample" <> $SessionUUID]
			];
			Download[protocol,Blanks[Model]],
			ListableP[ObjectP[Model[Sample, "Milli-Q water"]]],
			Variables:>{protocol}
		],
		
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentFPLC[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentFPLC[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentFPLC[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentFPLC[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"StandardsBlanksOutside", "Define a Standard when using a different instrument:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument->Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				Output->Options
			];
			Lookup[options,Standard],
			ObjectP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],
			Variables:>{options},
			Messages:>{
				Error::StandardsBlanksOutside,
				Error::InvalidOption
			}
		],
		Example[{Additional, "Define a Blank when using a different instrument:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument->Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				Blank->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			Lookup[options,Blank],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options},
			Messages:>{
				Error::StandardsBlanksOutside,
				Error::InvalidOption
			}
		],
		Example[{Additional, "If the conductivity detector is specified, should resolve to the corresponding units for fraction collection:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMode -> Threshold,
				Detector -> Conductance,
				Output -> Options
			];
			Lookup[options,AbsoluteThreshold],
			GreaterP[0 Millisiemen/Centimeter],
			Variables:>{options}
		],
		Example[{Additional, "If the conductivity detector is specified, should resolve to the corresponding units for fraction collection:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMode -> Peak,
				Detector -> {Conductance},
				Output -> Options
			];
			Lookup[options,PeakSlope],
			GreaterP[0 Millisiemen/Centimeter/Minute],
			Variables:>{options}
		],
		Example[{Additional, "If a value in a supplied gradient is overwritten, then a new gradient method should be made:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient->Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				FlowRate -> 2 Milliliter/Minute
			];
			typesGradients={Type, Gradient} /. Download[protocol, InjectionTable];
			downloadedITGradients=Download[Cases[typesGradients, {Sample, x_} :> x],Object];
			And[
				!MatchQ[downloadedITGradients,{ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]]..}],
				MatchQ[downloadedITGradients,{ObjectP[Object[Method, Gradient]],ObjectP[Object[Method, Gradient]]}]
			],
			True,
			Variables:>{protocol,typesGradients,downloadedITGradients},
			Messages:>{Warning::OverwritingGradient,Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "When FractionCollectionMode -> Threshold, all of the pertinent fraction options should be filled and the others Nulled out:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMode -> Threshold,
				Output -> Options
			];
			Lookup[options,{CollectFractions,FractionCollectionMode,AbsoluteThreshold,PeakEndThreshold,PeakMinimumDuration,PeakSlope,PeakSlopeEnd,FractionCollectionStartTime,FractionCollectionEndTime,MaxFractionVolume,MaxCollectionPeriod}],
			{
				True,
				Threshold,
				UnitsP[AbsorbanceUnit],
				UnitsP[AbsorbanceUnit],
				UnitsP[Second],
				Null,
				Null,
				UnitsP[Second],
				UnitsP[Second],
				UnitsP[Liter],
				UnitsP[Second]
			},
			Variables:>{options}
		],
		Example[{Additional, "When FractionCollectionMode -> Peak, all of the pertinent fraction options should be filled and the others Nulled out:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMode -> Peak,
				Output -> Options
			];
			Lookup[options,{CollectFractions,FractionCollectionMode,AbsoluteThreshold,PeakEndThreshold,PeakMinimumDuration,PeakSlope,PeakSlopeEnd,FractionCollectionStartTime,FractionCollectionEndTime,MaxFractionVolume,MaxCollectionPeriod}],
			{
				True,
				Peak,
				Null,
				Null,
				UnitsP[Second],
				UnitsP[AbsorbanceUnit/Second],
				UnitsP[AbsorbanceUnit/Second],
				UnitsP[Second],
				UnitsP[Second],
				UnitsP[Liter],
				UnitsP[Second]
			},
			Variables:>{options}
		],
		Example[{Additional, "When FractionCollectionMode -> Time, all of the pertinent fraction options should be filled and the others Nulled out:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMode -> Time,
				Output -> Options
			];
			Lookup[options,{CollectFractions,FractionCollectionMode,AbsoluteThreshold,PeakEndThreshold,PeakMinimumDuration,PeakSlope,PeakSlopeEnd,FractionCollectionStartTime,FractionCollectionEndTime,MaxFractionVolume,MaxCollectionPeriod}],
			{
				True,
				Time,
				Null,
				Null,
				Null,
				Null,
				Null,
				UnitsP[Second],
				UnitsP[Second],
				UnitsP[Liter],
				UnitsP[Second]
			},
			Variables:>{options}
		],
		Example[{Additional, "Be able to specify very precise flow rates:"},
			options=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientStart->10 Percent,
				GradientEnd->90 Percent,
				GradientDuration->20 Minute,
				FlowRate -> 0.003 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options,FlowRate],
			0.003 Milliliter/Minute,
			Variables:>{options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "When specifying a gradient method for column prime in the injection table, that should reflect in the column gradient resolution:"},
			sampleGradient = Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID];
			primeGradient = Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID];
			options = ExperimentFPLC[
				Repeat[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], 3],
				InjectionTable -> {
					{ColumnPrime, Null, Null, Null, primeGradient},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, Quantity[10, "Microliters"], sampleGradient},
					{ColumnPrime, Null, Null, Null, primeGradient},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, Quantity[10, "Microliters"], sampleGradient},
					{ColumnPrime, Null, Null, Null, primeGradient},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, Quantity[10, "Microliters"], sampleGradient}
				},
				Output -> Options
			];
			Lookup[options, ColumnPrimeGradient],
			ObjectP[primeGradient],
			Variables :> {options, primeGradient, sampleGradient},
			Messages :> {Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "A direct flow procedure with aliquoting should be smartly reflected in the SampleCaps picked:"},
			protocol=ExperimentFPLC[
				List[Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID]],
				InjectionType -> FlowInjection,
				InjectionTable -> {
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				},
				ConsolidateAliquots -> True,
				Aliquot -> {True, True, True, False}
			];
			requiredResources = Download[protocol, RequiredResources];
			uniqueSampleCapResources = DeleteDuplicates[Cases[requiredResources, {resource_, SampleCaps, _, _} :> Download[resource, Object]]];
			{
				Download[protocol, SampleCaps],
				uniqueSampleCapResources
			},
			{
				{Null, ObjectP[Model[Item, Cap, "id:L8kPEjkYnpYE"]], Null, Null, ObjectP[Model[Item, Cap, "id:L8kPEjkYnpYE"]], Null, Null, ObjectP[Model[Item, Cap, "id:L8kPEjkYnpYE"]], ObjectP[Model[Item, Cap, "id:R8e1Pjewp7an"]], Null},
				{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}
			},
			Variables:>{protocol, requiredResources, uniqueSampleCapResources},
			Messages :> {Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "A direct flow procedure with flow injection blanks should be smartly reflected in the BlankCaps picked:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID]},
				InjectionType -> FlowInjection,
				InjectionTable -> {
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], FlowInjection, 15 Milliliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], FlowInjection, 15 Milliliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID], Automatic, Quantity[10000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				},
				Aliquot -> False
			];
			requiredResources = Download[protocol, RequiredResources];
			uniqueSampleCapResources = DeleteDuplicates[Cases[requiredResources, {resource_, SampleCaps, _, _} :> Download[resource, Object]]];
			{
				Download[protocol, SampleCaps],
				uniqueSampleCapResources
			},
			{
				{Null, ObjectP[Model[Item, Cap]], ObjectP[Model[Item, Cap]], Null, Null, ObjectP[Model[Item, Cap]], ObjectP[Model[Item, Cap]], Null, Null, ObjectP[Model[Item, Cap]], Null},
				{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]}
			},
			Variables:>{protocol, requiredResources, uniqueSampleCapResources},
			Messages :> {Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "If the selected instrument is AKTA avant 25/150, the experiment accepts a mixed sample injection types:"},
			ExperimentFPLC[
				List[Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID]],
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				InjectionTable -> {
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], FlowInjection, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], Autosampler, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID], Autosampler, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				}
			],
			ObjectP[Object[Protocol,FPLC]],
			Messages :> {Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "If the selected instrument is AKTA avant 25/150, the experiment accpets a mixed sample injection types and index mathed sample loop disconnect volume:"},
			ExperimentFPLC[
				List[Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID]],
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				InjectionTable -> {
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], FlowInjection, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID], FlowInjection, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID], Autosampler, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID], Autosampler, Quantity[1000, "Microliters"], Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				},
				SampleLoopDisconnect -> {Null, Null, 11.5 Milliliter, 11.5 Milliliter}
			],
			ObjectP[Object[Protocol,FPLC]],
			Messages :> {Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "Make sure that the Equilibrium time and Flush time update the gradient correctly:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "id:9RdZXvKBeEbJ"],
				BufferB -> Model[Sample, StockSolution, "id:8qZ1VWNmdLbb"],
				InjectionVolume -> 50 Microliter,
				EquilibrationTime -> 10 Minute,
				FlushTime -> 10 Minute,
				GradientStart -> 30 Percent,
				GradientEnd -> 70 Percent,
				GradientDuration -> 45 Minute,
				Wavelength -> 254 Nanometer,
				Column -> Model[Item, Column, "id:eGakld01zKRn"],
				ColumnRefreshFrequency -> Null
			];
			Download[protocol, InjectionTable[[1, Gradient]][Gradient][[All, 1 ;; 3]]],
			{
				{Quantity[0., "Minutes"], Quantity[70., "Percent"], Quantity[30., "Percent"]},
				{Quantity[10., "Minutes"], Quantity[70., "Percent"], Quantity[30., "Percent"]},
				{Quantity[55., "Minutes"], Quantity[30., "Percent"], Quantity[70., "Percent"]},
				{Quantity[55.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"]},
				{Quantity[65.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"]}
			},
			Variables:>{protocol},
			EquivalenceFunction -> Equal,
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Additional, "Request extra buffer when system washing is on:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]},
				Column -> Model[Item, Column, "HiTrap Q HP 5x1mL Column"],
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				ColumnRefreshFrequency -> None,
				Gradient -> {
					{Quantity[0., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[10., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[10.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[20., "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[20.1, "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[30., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[40.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[43., "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[43.1, "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[46., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[46.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[48., "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[48.1, "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[50., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[50.1, "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[51., "Minutes"], Quantity[0., "Percent"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[51.1, "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]},
					{Quantity[66., "Minutes"], Quantity[100., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1, ("Milliliters")/("Minutes")]}
				},
				FullGradientChangePumpDisconnectAndPurge -> True,
				PumpDisconnectOnFullGradientChangePurgeVolume -> Quantity[50, "Milliliters"]
			];
			resourceTuples=Transpose@Quiet[Download[protocol, {RequiredResources[[All, 2]], RequiredResources[[All, 1]][Amount]}]];
			Cases[resourceTuples,{BufferA|BufferB,_}][[All,2]],
			{GreaterP[1*Liter],GreaterP[1*Liter]},
			Variables:>{protocol,resourceTuples}
		],
		Example[{Additional,"Work with a non-standard sample container that we haven't considered for avant 25 without aliquoting:"},
			(
				packet = ExperimentFPLC[
					Object[Sample,  "FPLC Test Oligo in nondefault but compatible tube" <> $SessionUUID],
					Instrument -> Model[Instrument,FPLC,"AKTA avant 25"],
					Aliquot -> False,
					Upload -> False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],
		Example[{Additional,"Work with a non-standard sample container that we haven't considered for avant 150 without aliquoting:"},
			(
				packet=ExperimentFPLC[
					Object[Sample, "FPLC Test Oligo in nondefault but compatible bottle" <> $SessionUUID],
					Instrument->Model[Instrument,FPLC,"AKTA avant 150"],
					InjectionType -> FlowInjection,
					InjectionVolume -> 50 Milliliter,
					Aliquot -> False,
					Upload->False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],

		(* --- Options --- *)

		Example[{Options,Name,"Specify the Name of the created FPLC protocol object:"},
			protocol=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],Name->"Another special FPLC New protocol name"];
			Download[protocol,Name],
			"Another special FPLC New protocol name",
			Variables:>{protocol}
		],
		Example[{Options,NumberOfReplicates,"Indicate the number of times the experiment should be replicated:"},
			options=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],NumberOfReplicates->3,Output->Options];
			Lookup[options,NumberOfReplicates],
			3,
			Variables:>{options}
		],
		Example[{Options, SeparationMode, "Set the SeparationMode option to indicate the type of chromatography:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]}, SeparationMode -> IonExchange, Output -> Options];
			Lookup[options, SeparationMode],
			IonExchange,
			Variables :> {options}
		],
		Example[{Options, SeparationMode, "If SeparationMode is not set, automatically set depending on the type of column (or, if not specified, defaults to SizeExclusion):"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]}, Output -> Options];
			Lookup[options, SeparationMode],
			SizeExclusion,
			Variables :> {options}
		],
		Example[{Options, Column, "Specify a single column object to use:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, Column -> Object[Item, Column, "FPLC Test Column" <> $SessionUUID], Output -> Options];
			Lookup[options, Column],
			ObjectP[Object[Item, Column, "FPLC Test Column" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, Column, "Specify multiple columns to use in sequence:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				Column -> {
					Model[Item, Column, "HiTrap 5x5mL Desalting Column"],
					Model[Item, Column, "HiTrap 5x5mL Desalting Column"],
					Model[Item, Column, "HiTrap 5x5mL Desalting Column"]
				},
				Output -> Options
			];
			Lookup[options, Column],
			{
				ObjectP[Model[Item, Column, "HiTrap 5x5mL Desalting Column"]],
				ObjectP[Model[Item, Column, "HiTrap 5x5mL Desalting Column"]],
				ObjectP[Model[Item, Column, "HiTrap 5x5mL Desalting Column"]]
			},
			Variables:>{options}
		],
		Example[{Options, MaxColumnPressure, "Specify allowable pressure drop across the columns:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, MaxColumnPressure -> 1.5 Megapascal];
			Download[protocol, MaxColumnPressure],
			1.5 Megapascal,
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[{Options, Scale, "Set whether the experiment should be on an analytical or preparative scale:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Scale -> Preparative, Output -> Options];
			Lookup[options, Scale],
			Preparative,
			Variables :> {options}
		],
		Example[{Options, Instrument, "Specify which instrument to use in the course of this FPLC experiment:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Instrument -> Model[Instrument, FPLC, "AKTA avant 25"], Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, FPLC, "AKTA avant 25"]],
			Variables :> {options}
		],
		Example[{Options, Instrument, "If not specified, Instrument option is set to the AKTA avant 25 if Scale -> Analytical, or the AKTA avant 150 if Scale -> Preparative:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Scale -> Preparative, Output -> Options];
			Lookup[options, Instrument],
			ObjectP[Model[Instrument, FPLC, "AKTA avant 150"]],
			Variables :> {options}
		],
		Example[{Options, InjectionType, "Directly have samples being directly introduced into the column without using a sample loop:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> FlowInjection,
				InjectionVolume -> {50 Milliliter, 50 Milliliter}
			];
			Download[protocol, {InjectionTypes,SampleLoop}],
			{{FlowInjection, FlowInjection},Null},
			Variables :> {protocol}
		],
		Example[{Options, InjectionType, "If using FlowInjection, make sure we make the appropriate number of resources for the buffers (i.e., appropriately deal with duplicates):"},
			protocol = ExperimentFPLC[
				{
					Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 4" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID]
				},
				InjectionType -> FlowInjection,
				InjectionVolume -> 30 Milliliter
			];
			requiredResources = Download[protocol, RequiredResources];
			systemPrimeResources = Select[requiredResources, MatchQ[#[[2]], SystemPrimeCleaningBuffers]&];
			systemFlushResources = Select[requiredResources, MatchQ[#[[2]], SystemFlushCleaningBuffers]&];

			{
				Length[DeleteDuplicates[Download[systemPrimeResources[[All, 1]], Object]]],
				Length[DeleteDuplicates[Download[systemFlushResources[[All, 1]], Object]]]
			},
			{5, 5},
			Variables :> {protocol, requiredResources, systemPrimeResources, systemFlushResources}
		],
		Example[{Options, InjectionType, "Can specify autosampler and flow injection in same experiment:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				InjectionType -> {FlowInjection, Autosampler},
				InjectionVolume -> {50 Milliliter, 50 Microliter}
			];
			Download[protocol, {InjectionTypes, SampleLoop}],
			{{FlowInjection, Autosampler},Null (* ??? *)},
			Variables :> {protocol}
		],
		Example[{Options, InjectionType, "Specifying autosampler makes the wash solution resource:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID]},
				InjectionType -> {Autosampler},
				InjectionVolume -> {50 Microliter}
			];
			Download[protocol, {InjectionTypes, AutosamplerWashSolution}],
			{{Autosampler},LinkP[]},
			Variables :> {protocol}
		],
		Example[{Options, FlowInjectionPurgeCycle, "Directly have samples being introduced into the column without using a sample loop:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> FlowInjection,
				FlowInjectionPurgeCycle -> False,
				InjectionVolume -> {50 Milliliter, 50 Milliliter}
			];
			Download[protocol, {InjectionTypes,FlowInjectionPurgeCycle,AutosamplerWashSolution}],
			{{FlowInjection, FlowInjection}, False,Null},
			Variables :> {protocol}
		],
		Example[{Options, SampleLoop, "Fill a superloop with the sample before introducing it to the system:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> Superloop
			];
			Download[protocol, {InjectionTypes, SampleLoop}],
			{{Superloop, Superloop}, ObjectP[Model[Plumbing, SampleLoop]]},
			Variables :> {protocol}
		],
		Example[{Options,SampleLoopVolume,"Specify the volume in the sample loop:"},
			options=ExperimentFPLC[
				{Object[Sample,"FPLC Large-Volume Protein Sample 2" <> $SessionUUID],Object[Sample,"FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType->Superloop,
				SampleLoopVolume->10 Milliliter,
				Output->Options
			];
			Lookup[options,SampleLoopVolume],
			10 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options, SampleFlowRate, "Set the rate at which sample is pumped directly onto the column or from the Superloop:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				SampleFlowRate -> {1. Milliliter/Minute, 2. Milliliter/Minute},
				InjectionVolume -> {50 Milliliter, 50 Milliliter}
			];
			Download[protocol, {InjectionTypes,SampleFlowRate}],
			{
				{FlowInjection, FlowInjection},
				{1. Milliliter/Minute, 2. Milliliter/Minute}
			},
			Variables :> {protocol}
		],
		Example[{Options, Detector, "Specify which detectors to use in data collection for this FPLC experiment:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Detector -> {Absorbance, Pressure, Temperature}, Output -> Options];
			Lookup[options, Detector],
			{Absorbance, Pressure, Temperature},
			Variables :> {options}
		],
		Example[{Options, Detector, "If not specified, Detector option is set to the value of the Detectors field of the model instrument:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Instrument -> Model[Instrument, FPLC, "AKTA avant 150"], Output -> Options];
			Lookup[options, Detector],
			{Absorbance, Pressure, Temperature, Conductance, pH},
			Variables :> {options}
		],
		Example[{Options, MixerVolume, "Specify a different mixer to use for this FPLC experiment:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				MixerVolume -> 5 Milliliter];
			Download[protocol, Mixer],
			ObjectP[Model[Part, Mixer, "Avant Mixer Chamber 5 mL"]],
			Variables :> {protocol}
		],
		Example[{Options, MixerVolume, "Specify NO mixer to use for this FPLC experiment:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				MixerVolume -> 0 Milliliter];
			Download[protocol, Mixer],
			ObjectP[Model[Plumbing,ColumnJoin]],
			Variables :> {protocol}
		],
		Example[{Options, FlowCell, "Specify a different flow cell to use in absorbance measurement for this FPLC experiment:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FlowCell -> 10 Millimeter];
			Download[protocol, FlowCell],
			ObjectP[Model[Part, FlowCell, "UV flow cell US-10"]],
			Variables :> {protocol}
		],
		Example[{Options, InjectionTable, "Specify the order, amount, type, and gradient of every injection using the InjectionTable option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 20 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Standard, Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"], Autosampler, 15 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 30 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Test Oligo2" <> $SessionUUID], Autosampler, 30 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Standard, Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 20 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				},
				Output -> Options
			];
			Lookup[options, InjectionTable],
			{{Sample|Standard|Blank, ObjectP[{Object[Sample], Model[Sample]}], FPLCInjectionTypeP, VolumeP, ObjectP[Object[Method, Gradient]]}..},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, InjectionTable, "If the InjectionTable option is not specified, it is automatically set to the sequence of injections as defined by the other sample, blank, and standard options:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				InjectionVolume -> {10 Microliter, 15 Microliter},
				Standard -> {Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"], Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"], Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]},
				BlankInjectionVolume -> {30 Microliter},
				Output -> Options
			];
			Lookup[options, InjectionTable],
			{
				{ColumnPrime, Null, Null, Null, ObjectP[Object[Method, Gradient]]},
				{Blank, ObjectP[Model[Sample]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Sample, ObjectP[Object[Sample, "FPLC Test Oligo" <> $SessionUUID]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Sample, ObjectP[Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Blank, ObjectP[Model[Sample]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{Standard, ObjectP[Model[Sample, StockSolution, Standard, "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL"]], Autosampler, VolumeP, ObjectP[Object[Method, Gradient]]},
				{ColumnFlush, Null, Null, Null, ObjectP[Object[Method, Gradient]]}
			},
			Variables :> {options}
		],
		Example[{Options, SampleTemperature, "Set the temperature of the autosampler:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, SampleTemperature -> 10 Celsius, Output -> Options];
			Lookup[options, SampleTemperature],
			10 Celsius,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionTemperature, "Set the temperature of the fraction collector:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionTemperature -> 10 Celsius, Output -> Options];
			Lookup[options, FractionCollectionTemperature],
			10 Celsius,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionTemperature, "If not specified but FractionCollectionMethod is specified, FractionCollectionTemperature is automatically set to its value:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionMethod -> Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID], Output -> Options];
			Lookup[options, FractionCollectionTemperature],
			EqualP[8 Celsius],
			Variables :> {options}
		],

		Example[{Options, InjectionVolume, "Specify the volumes which should be injected for each sample:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, InjectionVolume -> {50 Microliter, 25 Microliter}, Output -> Options];
			Lookup[options, InjectionVolume],
			{50 Microliter, 25 Microliter},
			Variables :> {options}
		],
		Example[{Options, BufferA, "Specify BufferA for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferA -> Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferA],
			ObjectP[Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferB, "Specify BufferB for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferB -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferB],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferC, "Specify BufferC for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferC -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferC],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferD, "Specify BufferD for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferD -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferD],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferE, "Specify BufferE for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferE -> Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferE],
			ObjectP[Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferF, "Specify BufferF for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferF -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferF],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferG, "Specify BufferG for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferG -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferG],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, BufferH, "Specify BufferH for the run:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferH -> Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, BufferH],
			ObjectP[Object[Sample, "FPLC Test Water BufferB" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, GradientA, "Specify the composition of BufferA within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
				BufferB -> Model[Sample, StockSolution, "Ion Exchange Buffer B Native"],
				GradientA -> {
					95 Percent,
					{
						{0 Minute, 95 Percent},
						{15 Minute, 50 Percent},
						{30 Minute, 5 Percent}
					}
				},
				Output -> Options
			];
			Lookup[options, GradientA],
			{
				95 Percent,
				{
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				}
			},
			Variables :> {options}
		],
		Example[{Options, GradientA, "Specifying GradientA will automatically set the Gradient option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
				BufferB -> Model[Sample, StockSolution, "Ion Exchange Buffer B Native"],
				GradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				},
				Output -> Options
			];
			Lookup[options, Gradient],
			{
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, GradientB, "Specify the composition of BufferB within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
				BufferB -> Model[Sample, StockSolution, "Ion Exchange Buffer B Native"],
				GradientB -> 95 Percent,
				Output -> Options
			];
			Lookup[options, GradientB],
			95 Percent,
			Variables :> {options}
		],
		Example[{Options, GradientC, "Specify the composition of BufferC within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientC -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {GradientC,BufferC}],
			{45 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, GradientD, "Specify the composition of BufferD within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientD -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {GradientD,BufferD}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, GradientE, "Specify the composition of BufferE within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientE -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {GradientE,BufferE}],
			{45 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, GradientF, "Specify the composition of BufferF within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientF -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {GradientF,BufferF}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, GradientG, "Specify the composition of BufferG within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientG -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {GradientG,BufferG}],
			{45 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, GradientH, "Specify the composition of BufferH within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientH -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {GradientH,BufferH}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, Gradient, "Specify the Gradient either as a method object or manually:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient -> {
					Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
					{
						{0 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
						{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
						{30 Minute, 5 Percent, 95 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute}
					}
				},
				Output -> Options
			];
			Lookup[options, Gradient],
			{
				ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]],
				{
					{0 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
					{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
					{30 Minute, 5 Percent, 95 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, Gradient, "Inherit information about the buffers from the specified gradient method object:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, FlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				FlowRateP
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, Gradient, "If specifying a gradient method object, override the values in it by specifying the option directly:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				FlowRate -> 5 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, FlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				5 Milliliter/Minute
			},
			Variables :> {options},
			Messages :> {Warning::OverwritingGradient,Warning::GradientNotReequilibrated}
		],

		Example[{Options, FlowRate, "Specify flow rate:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FlowRate -> {2 Milliliter / Minute, 1 Milliliter / Minute}, Output -> Options];
			Lookup[options, FlowRate],
			{2 Milliliter / Minute, 1 Milliliter / Minute},
			Variables :> {options}
		],

		Example[{Options, GradientStart, "Specify starting Buffer B composition:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				GradientStart -> 10 Percent,
				GradientEnd -> 10 Percent,
				GradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, GradientStart],
			10 Percent,
			Variables :> {options}
		],
		Example[{Options, GradientEnd, "Specify end Buffer B composition:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				GradientStart -> 0 Percent,
				GradientEnd -> 100 Percent,
				GradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, GradientEnd],
			100 Percent,
			Variables :> {options}
		],
		Example[{Options, GradientDuration, "Specify duration of gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				GradientStart -> 0 Percent,
				GradientEnd -> 100 Percent,
				GradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, GradientDuration],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, EquilibrationTime, "Specify duration of equilibration before gradient starts:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, EquilibrationTime -> 5 Minute, Output -> Options];
			Lookup[options, EquilibrationTime],
			5 Minute,
			Variables :> {options}
		],
		Example[{Options, PreInjectionEquilibrationTime, "Specify duration of equilibration before gradient starts:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, PreInjectionEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, PreInjectionEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, StandardPreInjectionEquilibrationTime, "Specify duration of equilibration before gradient starts for Standard:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, StandardPreInjectionEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, StandardPreInjectionEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, BlankPreInjectionEquilibrationTime, "Specify duration of equilibration before gradient starts for Blank:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, BlankPreInjectionEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, BlankPreInjectionEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, SampleLoopDisconnect, "Specify the volume of buffer at initial conditions to flush the sample loop with:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, SampleLoopDisconnect -> 11.5 Milliliter, Output -> Options];
			Lookup[options, SampleLoopDisconnect],
			11.5 Milliliter,
			Variables :> {options}
		],
		Example[{Options, StandardSampleLoopDisconnect, "Specify the volume of buffer at initial conditions to flush the sample loop with for standards:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, StandardSampleLoopDisconnect -> 11.5 Milliliter, Output -> Options];
			Lookup[options, StandardSampleLoopDisconnect],
			11.5 Milliliter,
			Variables :> {options}
		],
		Example[{Options, BlankSampleLoopDisconnect, "Specify the volume of buffer at initial conditions to flush the sample loop with for blanks:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, BlankSampleLoopDisconnect -> 11.5 Milliliter, Output -> Options];
			Lookup[options, BlankSampleLoopDisconnect],
			11.5 Milliliter,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimePreInjectionEquilibrationTime, "Specify duration of equilibration before gradient starts for ColumnPrime:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, ColumnPrimePreInjectionEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, ColumnPrimePreInjectionEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushPreInjectionEquilibrationTime, "Specify duration of equilibration before gradient starts for ColumnFlush:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, ColumnFlushPreInjectionEquilibrationTime -> 10 Minute, Output -> Options];
			Lookup[options, ColumnFlushPreInjectionEquilibrationTime],
			10 Minute,
			Variables :> {options}
		],
		Example[{Options, FlushTime, "Specify duration of flush after gradient starts:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, FlushTime -> 5 Minute, Output -> Options];
			Lookup[options, FlushTime],
			5 Minute,
			Variables :> {options}
		],
		Example[{Options, FlowDirection, "Specify the direction of the flow going through the column during the sample injection:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, FlowDirection -> Reverse, Output -> Options];
			Lookup[options, FlowDirection],
			Reverse,
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "Specify the storage condition of each provided sample:"},
			options = ExperimentFPLC[
				{Object[Sample,  "ExpFPLC Model-less Oligo for ExperimentFPLC tests" <> $SessionUUID], Object[Sample, "FPLC Test Oligo New Plate" <> $SessionUUID]},
				SamplesInStorageCondition -> {AmbientStorage, Refrigerator},
				Output -> Options
			];
			Lookup[options, SamplesInStorageCondition],
			{AmbientStorage, Refrigerator},
			Variables :> {options}
		],
		Example[{Options, SamplesInStorageCondition, "If two samples are in the same container but have different storage conditions, throw an error:"},
			ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Water Sample" <> $SessionUUID]},
				SamplesInStorageCondition -> {AmbientStorage, Refrigerator}
			],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],
		Example[{Options, SamplesOutStorageCondition, "Specify the storage condition of each SampleOut:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				SamplesOutStorageCondition -> {AmbientStorage, Refrigerator},
				Output -> Options
			];
			Lookup[options, SamplesOutStorageCondition],
			{AmbientStorage, Refrigerator},
			Variables :> {options}
		],
		Example[{Options, CollectFractions, "Specify whether to collect fractions for each sample:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, CollectFractions -> {True, False}, Output -> Options];
			Lookup[options, CollectFractions],
			{True, False},
			Variables :> {options}
		],
		Example[{Options, CollectFractions, "If not specified, CollectFractions is automatically set to False (Scale -> Analytical) or True (Scale -> Preparative):"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]}, Scale -> Preparative, Output -> Options];
			Lookup[options, CollectFractions],
			True,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionMethod, "Specify the FractionCollectionMethod by providing a method object:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionMethod -> Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID], Output -> Options];
			Lookup[options, FractionCollectionMethod],
			ObjectP[Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, FractionCollectionMethod, "Specifying the FractionCollectionMethod automatically sets the other fraction collection options:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionMethod -> Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID], Output -> Options];
			Lookup[options, {FractionCollectionMode, FractionCollectionStartTime, FractionCollectionEndTime, MaxCollectionPeriod, AbsoluteThreshold}],
			{
				Threshold,
				EqualP[5 Minute],
				EqualP[40 Minute],
				EqualP[108 Second],
				EqualP[500 MilliAbsorbanceUnit]
			},
			Variables :> {options}
		],
		Example[{Options, FractionCollectionMethod, "Specify a FractionCollection method object but override a collection specification:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FractionCollectionMethod -> Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID],
				AbsoluteThreshold -> 1000 MilliAbsorbanceUnit,
				Output -> Options
			];
			Lookup[options, AbsoluteThreshold],
			1000 MilliAbsorbanceUnit,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionMethod, "FractionCollectionMethods is populated with Objects and Nulls according to whether each analyte is/is not being collected:"},
			prot = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				FractionCollectionMethod -> Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID],
				CollectFractions -> {True, False, True}
			];
			Download[prot, FractionCollectionMethods],
			{ObjectP[Object[Method, FractionCollection]], Null, ObjectP[Object[Method, FractionCollection]]},
			Variables :> {prot},
			Messages :> {Warning::ConflictFractionOptionSpecification}
		],
		Example[{Options, FractionCollectionMode, "Specify FractionCollectionMode to use:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionMode -> Peak, Output -> Options];
			Lookup[options, FractionCollectionMode],
			Peak,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionStartTime, "Specify FractionCollectionStartTime to use:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionStartTime -> 5 Minute, Output -> Options];
			Lookup[options, FractionCollectionStartTime],
			5 Minute,
			Variables :> {options}
		],
		Example[{Options, FractionCollectionEndTime, "Specify FractionCollectionEndTime to use:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, FractionCollectionEndTime -> 25 Minute, Output -> Options];
			Lookup[options, FractionCollectionEndTime],
			25 Minute,
			Variables :> {options}
		],
		Example[{Options, MaxFractionVolume, "Specify the MaxFractionVolume to use:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> 1.3 Milliliter, Output -> Options];
			Lookup[options, MaxFractionVolume],
			1.3 Milliliter,
			Variables :> {options}
		],
		Example[{Options, MaxFractionVolume, "If multiple different fraction sizes are requested that require different containers, both containers will be used:"},
			Download[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> {20 Milliliter, 1.3 Milliliter}],
				FractionContainers
			],
			Flatten[{ConstantArray[ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]], 3], ConstantArray[ObjectP[Model[Container, Vessel, "50mL Tube"]], 18]}]
		],
		Example[{Options, MaxFractionVolume, "If multiple different fraction sizes are requested that require different containers, both containers will be used (part 2):"},
			Download[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> {10 Milliliter, 2.1 Milliliter}],
				FractionContainers
			],
			Flatten[{ConstantArray[ObjectP[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]], 3], ConstantArray[ObjectP[Model[Container, Vessel, "15mL Tube"]], 45]}]
		],
		Example[{Options, MaxFractionVolume, "If multiple different fraction sizes are requested that require different containers, both containers will be used (part 3):"},
			Download[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID],Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> {30 Milliliter, 8 Milliliter, 4 Milliliter, 0.9 Milliliter}],
				FractionContainers
			],
			Flatten[{ConstantArray[ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]], 1], ConstantArray[ObjectP[Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]], 1], ConstantArray[ObjectP[Model[Container, Vessel, "15mL Tube"]], 30], ConstantArray[ObjectP[Model[Container, Vessel, "50mL Tube"]], 12]}]
		],
		Example[{Options, MaxFractionVolume, "If using 250 mL bottles to collect fractions, make the resource for the single rack:"},
			Download[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> 200 Milliliter],
				{
					FractionContainers,
					FractionContainers[MaxVolume],
					FractionContainerRacks
				}
			],
			{
				ConstantArray[ObjectP[Model[Container, Vessel]], 18],
				ConstantArray[EqualP[250 Milliliter], 18],
				{ObjectP[Model[Container, Rack, "Avant Fraction Collector 250 mL Bottle Rack"]]}
			}
		],
		Example[{Options, MaxFractionVolume, "If using anything besides 250 mL bottles to collect fractions, make the resources for the six racks, and for the cassette rack:"},
			Download[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxFractionVolume -> 45 Milliliter],
				{
					FractionContainers,
					FractionContainerRacks
				}
			],
			{
				ConstantArray[ObjectP[Model[Container, Vessel, "50mL Tube"]], 36],
				{
					ObjectP[Model[Container, Rack, "Avant Fraction Collector Cassette Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]],
					ObjectP[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"]]
				}
			}
		],
		Example[{Options, MaxCollectionPeriod, "Specify the longest period of time to collect in the same fraction:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, MaxCollectionPeriod -> 1 Minute, Output -> Options];
			Lookup[options, MaxCollectionPeriod],
			1 Minute,
			Variables :> {options}
		],
		Example[{Options, AbsoluteThreshold, "Specify AbsoluteThreshold:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				AbsoluteThreshold -> 200 MilliAbsorbanceUnit,
				Output -> Options
			];
			Lookup[options, AbsoluteThreshold],
			200 MilliAbsorbanceUnit,
			Variables :> {options}
		],
		Example[{Options, AbsoluteThreshold, "If not specified, AbsoluteThreshold is automatically set to 500 MilliAbsorbanceUnit if collecting fractions and using Threshold, or Null if not:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				CollectFractions -> {True, False},
				FractionCollectionMode -> {Threshold, Automatic},
				Output -> Options
			];
			Lookup[options, AbsoluteThreshold],
			{500 MilliAbsorbanceUnit, Null},
			Variables :> {options}
		],
		Example[{Options, PeakSlope, "Specify PeakSlope:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				PeakSlope -> 2 MilliAbsorbanceUnit / Second,
				Output -> Options
			];
			Lookup[options, PeakSlope],
			2 MilliAbsorbanceUnit / Second,
			Variables :> {options}
		],
		Example[{Options, PeakSlopeEnd, "Specify the Slope-based value to cease fraction collection:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				PeakSlopeEnd -> 1 MilliAbsorbanceUnit / Second,
				Output -> Options
			];
			Lookup[options, PeakSlopeEnd],
			1 MilliAbsorbanceUnit / Second,
			Variables :> {options}
		],
		Example[{Options, PeakMinimumDuration, "Specify PeakMinimumDuration:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				PeakMinimumDuration -> 0.5 Minute,
				Output -> Options
			];
			Lookup[options, PeakMinimumDuration],
			0.5 Minute,
			Variables :> {options}
		],
		Example[{Options, PeakEndThreshold, "Specify PeakEndThreshold:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				PeakEndThreshold -> 50 MilliAbsorbanceUnit,
				Output -> Options
			];
			Lookup[options, PeakEndThreshold],
			50 MilliAbsorbanceUnit,
			Variables :> {options}
		],
		Example[{Options, StandardFrequency, "Specify the points at which standards will be injected before, after, or between samples:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, StandardFrequency -> 2, Output -> Options];
			Lookup[options, StandardFrequency],
			2,
			Variables :> {options}
		],
		Example[{Options, StandardFrequency, "If not specified (but standards are specified), automatically set to FirstAndLast:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Output -> Options];
			Lookup[options, StandardFrequency],
			FirstAndLast,
			Variables :> {options}
		],
		Example[{Options, Standard, "Specify which samples to inject as standards:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Standard -> {Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]}, Output -> Options];
			Lookup[options, Standard],
			{ObjectP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]], ObjectP[Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]], ObjectP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]]},
			Variables :> {options}
		],
		Example[{Options, StandardInjectionType, "Specify how to inject the standard on the instrument:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardInjectionType -> {Autosampler, FlowInjection},
				StandardInjectionVolume -> {25 Microliter, 11 Milliliter}
			];
			Download[protocol, StandardInjectionTypes],
			{Autosampler, FlowInjection},
			Variables :> {protocol}
		],
		Example[{Options, StandardInjectionVolume, "Specify the volume to inject each standard:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardInjectionVolume -> 25 Microliter,
				Output -> Options
			];
			Lookup[options, StandardInjectionVolume],
			25 Microliter,
			Variables :> {options}
		],
		Example[{Options, StandardGradientA, "Specify the composition of BufferA for standards within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientA -> {
					95 Percent,
					{
						{0 Minute, 95 Percent},
						{15 Minute, 50 Percent},
						{30 Minute, 5 Percent}
					}
				},
				Output -> Options
			];
			Lookup[options, StandardGradientA],
			{
				95 Percent,
				{
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientA, "Specifying StandardGradientA will automatically set the StandardGradient option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				},
				Output -> Options
			];
			Lookup[options, StandardGradient],
			{
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientB, "Specify the composition of BufferB for standard samples within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientB -> {
					50 Percent,
					{
						{0 Minute, 5 Percent},
						{15 Minute, 50 Percent},
						{30 Minute, 95 Percent}
					}
				},
				Output -> Options
			];
			Lookup[options, StandardGradientB],
			{
				50 Percent,
				{
					{0 Minute, 5 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 95 Percent}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientC, "Specify the composition of StandardBufferC within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientC -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientC,BufferC}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientD, "Specify the composition of StandardBufferD within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientD -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientD,BufferD}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientE, "Specify the composition of StandardBufferE within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientE -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientE,BufferE}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientF, "Specify the composition of StandardGradientF within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientF -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientF,BufferF}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientG, "Specify the composition of StandardGradientG within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientG -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientG,BufferG}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradientH, "Specify the composition of StandardGradientH within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradientH -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {StandardGradientH,BufferH}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradient, "Specify the StandardGradient either as a method object or manually:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradient -> {
					Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
					{
						{0 Minute, 95 Percent, 5 Percent,0 Percent, 0 Percent, 1 Milliliter/Minute},
						{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
						{30 Minute, 5 Percent, 95 Percent,0 Percent, 0 Percent, 1 Milliliter/Minute}
					}
				},
				Output -> Options
			];
			Lookup[options, StandardGradient],
			{
				ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]],
				{
					{0 Minute, 95 Percent, 5 Percent,0 Percent, 0 Percent, 1 Milliliter/Minute},
					{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
					{30 Minute, 5 Percent, 95 Percent,0 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, StandardGradient, "Inherit information about the buffers from the specified standard gradient method object:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, StandardFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				FlowRateP
			},
			Variables :> {options}
		],
		Example[{Options, StandardGradient, "If specifying a gradient method object, override the values in it by specifying the option directly:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				StandardFlowRate -> 5 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, StandardFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				5 Milliliter/Minute
			},
			Variables :> {options},
			Messages:>{Warning::OverwritingGradient}
		],
		Example[{Options, StandardFlowRate, "Specify the standard flow rate:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, StandardFlowRate -> {2 Milliliter / Minute, 1 Milliliter / Minute}, Output -> Options];
			Lookup[options, StandardFlowRate],
			{2 Milliliter / Minute, 1 Milliliter / Minute},
			Variables :> {options}
		],
		Example[{Options, StandardGradientDuration, "Specify duration of the standard gradient:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				StandardGradientStart -> 10 Percent,
				StandardGradientEnd -> 90 Percent,
				StandardGradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, StandardGradientDuration],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, StandardGradientStart, "Specify the starting percentage of the standard gradient:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				StandardGradientStart -> 10 Percent,
				StandardGradientEnd -> 90 Percent,
				StandardGradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, StandardGradientStart],
			10 Percent,
			Variables :> {options}
		],
		Example[{Options, StandardGradientEnd, "Specify the ending percentage of the standard gradient:"},
			options = ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]},
				StandardGradientStart -> 10 Percent,
				StandardGradientEnd -> 90 Percent,
				StandardGradientDuration -> 15 Minute,
				Output -> Options
			];
			Lookup[options, StandardGradientEnd],
			90 Percent,
			Variables :> {options}
		],
		Example[{Options, StandardFlowDirection, "Specify the direction of the flow going through the column during the standard injection:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, StandardFlowDirection -> Reverse, Output -> Options];
			Lookup[options, StandardFlowDirection],
			Reverse,
			Variables :> {options}
		],
		Example[{Options, StandardStorageCondition, "Specify the storage condition of each standard:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Standard -> {Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]},
				StandardStorageCondition -> {AmbientStorage, Refrigerator},
				Output -> Options
			];
			Lookup[options, StandardStorageCondition],
			{AmbientStorage, Refrigerator},
			Variables :> {options}
		],
		Example[{Options, Wavelength, "Specify the wavelength of the light passed used in the absorbance detector:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Wavelength -> {280 Nanometer, 260 Nanometer, 330 Nanometer}, Output -> Options];
			Lookup[options, Wavelength],
			{280 Nanometer, 260 Nanometer, 330 Nanometer},
			Variables :> {options}
		],
		Example[{Options, Wavelength, "If not specified, automatically set to {260 Nanometer, 280 Nanometer} for DNA (unless Instrument -> Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], which sets it to 254 Nanometer):"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Output -> Options];
			Lookup[options, Wavelength],
			{260 Nanometer, 280 Nanometer},
			Variables :> {options}
		],
		Example[{Options, BlankFrequency, "Specify the points at which blanks will be injected before, after, or between samples:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, BlankFrequency -> 2, Output -> Options];
			Lookup[options, BlankFrequency],
			2,
			Variables :> {options}
		],
		Example[{Options, BlankFrequency, "If not specified (but blanks are specified), automatically set to FirstAndLast:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Blank -> Model[Sample, "Milli-Q water"], Output -> Options];
			Lookup[options, BlankFrequency],
			FirstAndLast,
			Variables :> {options}
		],
		Example[{Options, Blank, "Specify which samples to inject as blanks (and if they need to be moved, this is indicated):"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Blank -> {Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"], Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID]}, Output -> Options];
			Lookup[options, Blank],
			{ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Model[Sample, "Milli-Q water"]], ObjectP[Object[Sample, "FPLC Test Water BufferA" <> $SessionUUID]]},
			Variables :> {options},
			Messages :> {Warning::SampleMustBeMoved}
		],
		Example[{Options, BlankInjectionType, "Specify how to inject the blank on the instrument:"},
			protocol = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankInjectionType -> {Autosampler, FlowInjection},
				BlankInjectionVolume -> {25 Microliter, 11 Milliliter}
			];
			Download[protocol, BlankInjectionTypes],
			{Autosampler, FlowInjection},
			Variables :> {protocol}
		],
		Example[{Options, BlankInjectionVolume, "Specify the volume to inject each blank:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankInjectionVolume -> 25 Microliter,
				Output -> Options
			];
			Lookup[options, BlankInjectionVolume],
			25 Microliter,
			Variables :> {options}
		],
		Example[{Options, BlankGradientA, "Specify the composition of BufferA for blank samples within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientA -> {
					95 Percent,
					{
						{0 Minute, 95 Percent},
						{15 Minute, 50 Percent},
						{30 Minute, 5 Percent}
					}
				},
				Output -> Options
			];
			Lookup[options, BlankGradientA],
			{
				95 Percent,
				{
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradientA, "Specifying BlankGradientA will automatically set the BlankGradient option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				},
				Output -> Options
			];
			Lookup[options, BlankGradient],
			{
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradientB, "Specify the composition of BlankGradientB within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientB -> {
					50 Percent,
					{
						{0 Minute, 5 Percent},
						{15 Minute, 50 Percent},
						{30 Minute, 95 Percent}
					}
				},
				Output -> Options
			];
			Lookup[options, BlankGradientB],
			{
				50 Percent,
				{
					{0 Minute, 5 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 95 Percent}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradientC, "Specify the composition of BufferC for blank samples within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientC -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {BlankGradientC,BlankBufferC}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradientD, "Specify the composition of BufferD for blank samples within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientD -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {BlankGradientD,BlankBufferD}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options,BlankGradientE,"Specify the composition of BufferE for blank samples within the flow:"},
			options=ExperimentFPLC[
				{Object[Sample,"FPLC Test Oligo" <> $SessionUUID],Object[Sample,"FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientE->95 Percent,
				Output->Options
			];
			Lookup[options,BlankGradientE],
			95 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options,BlankGradientF,"Specify the composition of BufferF for blank samples within the flow:"},
			options=ExperimentFPLC[
				{Object[Sample,"FPLC Test Oligo" <> $SessionUUID],Object[Sample,"FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientF->95 Percent,
				Output->Options
			];
			Lookup[options,BlankGradientF],
			95 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options,BlankGradientG,"Specify the composition of BufferG for blank samples within the flow:"},
			options=ExperimentFPLC[
				{Object[Sample,"FPLC Test Oligo" <> $SessionUUID],Object[Sample,"FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientG->95 Percent,
				Output->Options
			];
			Lookup[options,BlankGradientG],
			95 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options,BlankGradientH,"Specify the composition of BufferH for blank samples within the flow:"},
			options=ExperimentFPLC[
				{Object[Sample,"FPLC Test Oligo" <> $SessionUUID],Object[Sample,"FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradientH->95 Percent,
				Output->Options
			];
			Lookup[options,BlankGradientH],
			95 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradient, "Specify the BlankGradient either as a method object or manually:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradient -> {
					Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
					{
						{0 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
						{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
						{30 Minute, 5 Percent, 95 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute}
					}
				},
				Output -> Options
			];
			Lookup[options, BlankGradient],
			{
				ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]],
				{
					{0 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
					{15 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute},
					{30 Minute, 5 Percent, 95 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, BlankGradient, "Inherit information about the buffers from the specified blank gradient method object:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, BlankFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				FlowRateP
			},
			Variables :> {options}
		],
		Example[{Options, BlankGradient, "If specifying a gradient method object, override the values in it by specifying the option directly:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				BlankGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				BlankFlowRate -> 5 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, BlankFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				5 Milliliter/Minute
			},
			Variables :> {options},
			Messages :> {Warning::OverwritingGradient}
		],
		Example[{Options, BlankFlowRate, "Specify the blank flow rate:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, BlankFlowRate -> {2 Milliliter / Minute, 1 Milliliter / Minute}, Output -> Options];
			Lookup[options, BlankFlowRate],
			{2 Milliliter / Minute, 1 Milliliter / Minute},
			Variables :> {options}
		],
		Example[{Options, BlankGradientDuration, "Specify duration of the blank gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				BlankGradientDuration -> 15 Minute,
				BlankGradientStart -> 15 Percent,
				BlankGradientEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, BlankGradientDuration],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, BlankGradientStart, "Specify starting percentage of the blank gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				BlankGradientDuration -> 15 Minute,
				BlankGradientStart -> 15 Percent,
				BlankGradientEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, BlankGradientStart],
			15 Percent,
			Variables :> {options}
		],
		Example[{Options, BlankGradientEnd, "Specify ending percentage of the blank gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				BlankGradientDuration -> 15 Minute,
				BlankGradientStart -> 15 Percent,
				BlankGradientEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, BlankGradientEnd],
			85 Percent,
			Variables :> {options}
		],
		Example[{Options, BlankFlowDirection, "Specify the direction of the flow going through the column during the blank injection:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, BlankFlowDirection -> Forward, Output -> Options];
			Lookup[options, BlankFlowDirection],
			Forward,
			Variables :> {options}
		],
		Example[{Options, BlankStorageCondition, "Specify the storage condition of each blank:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Blank -> {Model[Sample, StockSolution, "Ion Exchange Buffer A Native"], Model[Sample, "Milli-Q water"]},
				BlankStorageCondition -> {AmbientStorage, Refrigerator},
				Output -> Options
			];
			Lookup[options, BlankStorageCondition],
			{AmbientStorage, Refrigerator},
			Variables :> {options}
		],
		Example[{Options, ColumnRefreshFrequency, "Specify the frequency at which the column will be flushed and primed before more samples are injected:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, ColumnRefreshFrequency -> 2, Output -> Options];
			Lookup[options, ColumnRefreshFrequency],
			2,
			Variables :> {options}
		],
		Example[{Options, ColumnRefreshFrequency, "If not specified, automatically set to FirstAndLast:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, Output -> Options];
			Lookup[options, ColumnRefreshFrequency],
			FirstAndLast,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeGradientA, "Specify the composition of BufferA for the column prime within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				}
				,
				Output -> Options
			];
			Lookup[options, ColumnPrimeGradientA],
			{
				{0 Minute, 95 Percent},
				{15 Minute, 50 Percent},
				{30 Minute, 5 Percent}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientA, "Specifying ColumnPrimeGradientA will automatically set the ColumnPrimeGradient option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				},
				Output -> Options
			];
			Lookup[options, ColumnPrimeGradient],
			{
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, PercentP, FlowRateP}
			},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientB, "Specify the composition of BufferB for column primes within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientB -> 50 Percent,
				Output -> Options
			];
			Lookup[options, ColumnPrimeGradientB],
			50 Percent,
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientC, "Specify the composition of BufferC for column primes within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientC -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientC,ColumnPrimeBufferC}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientD, "Specify the composition of BufferD for column primes within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientD -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientD,ColumnPrimeBufferD}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientE, "Specify the composition of BufferE for columns primes within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientE -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientE,BufferE}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientF, "Specify the composition of BufferF for column primes within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientF -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientF,BufferF}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientG, "Specify the composition of ColumnPrimeGradientG within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientG -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientG,BufferG}],
			{45 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradientH, "Specify the composition of ColumnPrimeGradientH within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradientH -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnPrimeGradientH,BufferH}],
			{95 Percent,Except[Null]},
			Variables :> {options},
			Messages:>{Warning::GradientNotReequilibrated}
		],
		Example[{Options, ColumnPrimeGradient, "Specify the ColumnPrimeGradient either as a method object or manually:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ColumnPrimeGradient],
			ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeGradient, "Inherit information about the buffers from the specified column prime gradient method object:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, ColumnPrimeFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				FlowRateP
			},
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeGradient, "If specifying a gradient method object, override the values in it by specifying the option directly:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnPrimeGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				ColumnPrimeFlowRate -> 5 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, ColumnPrimeFlowRate}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				5 Milliliter/Minute
			},
			Variables :> {options},
			Messages :> {Warning::OverwritingGradient}
		],
		Example[{Options, ColumnPrimeFlowRate, "Specify the column prime flow rate:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, ColumnPrimeFlowRate -> 2 Milliliter / Minute, Output -> Options];
			Lookup[options, ColumnPrimeFlowRate],
			2 Milliliter / Minute,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeStart, "Specify duration of the column prime gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnPrimeDuration -> 15 Minute,
				ColumnPrimeStart-> 10 Percent,
				ColumnPrimeEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnPrimeStart],
			10 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeEnd, "Specify duration of the column prime gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnPrimeDuration -> 15 Minute,
				ColumnPrimeStart-> 10 Percent,
				ColumnPrimeEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnPrimeEnd],
			85 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeDuration, "Specify duration of the column prime gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnPrimeDuration -> 15 Minute,
				ColumnPrimeStart-> 10 Percent,
				ColumnPrimeEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnPrimeDuration],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, ColumnPrimeFlowDirection, "Specify the direction of the flow going through the column during column prime:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnPrimeFlowDirection->Forward,
				Output -> Options
			];
			Lookup[options, ColumnPrimeFlowDirection],
			Forward,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientA, "Specify the composition of BufferA for column flush within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				}
				,
				Output -> Options
			];
			Lookup[options, ColumnFlushGradientA],
			{
				{0 Minute, 95 Percent},
				{15 Minute, 50 Percent},
				{30 Minute, 5 Percent}
			},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientA, "Specifying ColumnFlushGradientA will automatically set the ColumnFlushGradient option:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientA -> {
					{0 Minute, 95 Percent},
					{15 Minute, 50 Percent},
					{30 Minute, 5 Percent}
				},
				Output -> Options
			];
			Lookup[options, ColumnFlushGradient],
			{
				{TimeP, PercentP, PercentP, PercentP, PercentP,PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP,PercentP, PercentP, PercentP, PercentP, FlowRateP},
				{TimeP, PercentP, PercentP, PercentP, PercentP,PercentP, PercentP, PercentP, PercentP, FlowRateP}
			},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientB, "Specify the composition of BufferB for column flushing within the flow, either as a flat percent or a list of values:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientB -> 50 Percent,
				Output -> Options
			];
			Lookup[options, ColumnFlushGradientB],
			50 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientC, "Specify the composition of ColumnFlushBufferC within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientC -> 45 Percent,
				Output -> Options
			];
			Lookup[options, ColumnFlushGradientC],
			45 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientD, "Specify the composition of ColumnFlushBufferD within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientD -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnFlushGradientD,BufferD}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientE, "Specify the composition of ColumnFlushBufferE within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientE -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnFlushGradientE,BufferE}],
			{45 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientF, "Specify the composition of ColumnFlushBufferF within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientF -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnFlushGradientF,BufferF}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientG, "Specify the composition of ColumnFlushGradientG within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientG -> 45 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnFlushGradientG,BufferG}],
			{45 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradientH, "Specify the composition of ColumnFlushGradientH within the flow:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradientH -> 95 Percent,
				Output -> Options
			];
			Lookup[options, {ColumnFlushGradientH,BufferH}],
			{95 Percent,Except[Null]},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradient, "Specify the ColumnFlushGradient either as a method object or manually:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, ColumnFlushGradient],
			ObjectP[Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradient, "Inherit information about the buffers from the specified column flush gradient method object:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Output -> Options
			];
			Lookup[options, {BufferA, BufferB, ColumnFlushFlowRate}],
			{
				ObjectP[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
				ObjectP[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]],
				FlowRateP
			},
			Variables :> {options}
		],
		Example[{Options, ColumnFlushGradient, "If specifying a gradient method object, override the values in it by specifying the option directly:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				ColumnFlushGradient -> Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				ColumnFlushFlowRate -> 5 Milliliter/Minute,
				Output -> Options
			];
			Lookup[options, {ColumnFlushFlowRate}],
			{
				5 Milliliter/Minute
			},
			Variables :> {options},
			Messages :> {Warning::OverwritingGradient}
		],
		Example[{Options, ColumnFlushFlowRate, "Specify the column flush flow rate:"},
			options = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, ColumnFlushFlowRate -> 2 Milliliter / Minute, Output -> Options];
			Lookup[options, ColumnFlushFlowRate],
			2 Milliliter / Minute,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushStart, "Specify duration of the column flush gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnFlushDuration -> 15 Minute,
				ColumnFlushStart-> 10 Percent,
				ColumnFlushEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnFlushStart],
			10 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushEnd, "Specify duration of the column flush gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnFlushDuration -> 15 Minute,
				ColumnFlushStart-> 10 Percent,
				ColumnFlushEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnFlushEnd],
			85 Percent,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushDuration, "Specify duration of the column flush gradient:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnFlushDuration -> 15 Minute,
				ColumnFlushStart-> 10 Percent,
				ColumnFlushEnd -> 85 Percent,
				Output -> Options
			];
			Lookup[options, ColumnFlushDuration],
			15 Minute,
			Variables :> {options}
		],
		Example[{Options, ColumnFlushFlowDirection, "Specify the direction of the flow going through the column during column flush:"},
			options = ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				ColumnFlushFlowDirection->Reverse,
				Output -> Options
			];
			Lookup[options, ColumnFlushFlowDirection],
			Reverse,
			Variables :> {options}
		],

		(* --- Funtopia Shared Options --- *)
		Example[{Options, Template, "Inherit options from a previously made protocol:"},
			templateProtocol=ExperimentFPLC[
				{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Detector->{Conductance},
				CollectFractions->True
			];
			Lookup[
				ExperimentFPLC[
					{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
					Template -> templateProtocol,
					Output -> Options],
				AbsoluteThreshold
			],
			GreaterP[0 (Milli Siemens)/Centimeter],
			Variables :> {templateProtocol}
		],
		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], IncubationTemperature -> 40 * Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], IncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], MaxIncubationTime -> 40 * Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AnnealingTime -> 40 * Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], IncubateAliquot -> 1.5 * Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],IncubateAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentFPLC[Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Test["SampleStowaways error thrown if Centrifuging a plate that has more than just the SamplesIn:",
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			Messages :> {Warning::SampleStowaways}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID], CentrifugeIntensity -> 1000 * RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID], CentrifugeTime -> 40 * Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID], CentrifugeTemperature -> 10 * Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], CentrifugeAliquot -> 1.5 * Milliliter, CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filter prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Filter -> Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample 8" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterPoreSize -> 0.22 * Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 * Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample 8" <> $SessionUUID], PrefilterMaterial -> GxF, PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "FilterHousing option allows specification of filtration housing to use:"},
			options = ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID], Filtration -> True, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 * RPM, FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterIntensity],
			1000 * RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 * Minute, FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterTime],
			20 * Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10 * Celsius, FilterContainerOut -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			10 * Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterAliquot -> 1.5 * Milliliter, FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Convert[Lookup[options, FilterAliquot], Milliliter],
			1.5 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],FilterAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AliquotAmount -> 0.1 * Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.1 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AssayVolume -> 0.08 * Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08 * Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		(* TODO loop back around to this one once sample fest aliquot is merged in *)
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], TargetConcentration -> 5 Micromolar, AssayVolume -> 30 Microliter, AliquotAmount -> 15 Microliter, InjectionVolume -> 10 Microliter,Output -> Options];
			Convert[Lookup[options, TargetConcentration], Micromolar],
			5 * Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte -> Model[Molecule, Oligomer, "Six Monomer Test"], AssayVolume -> 30 Microliter, AliquotAmount -> 15 Microliter, InjectionVolume -> 10 Microliter,Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Six Monomer Test"]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, InjectionVolume -> 10 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, InjectionVolume -> 10 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, InjectionVolume -> 10 Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 30Microliter, AliquotAmount -> 15Microliter, InjectionVolume -> 10 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentFPLC[{Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo" <> $SessionUUID]}, ConsolidateAliquots -> True, Aliquot -> True, AliquotContainer -> Model[Container, Vessel, "HPLC vial (high recovery)"], Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], AliquotContainer -> Model[Container, Vessel, "HPLC vial (high recovery)"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{_Integer, ObjectP[Model[Container, Vessel, "HPLC vial (high recovery)"]]}},
			Variables :> {options}
		],
		Example[{Options,DestinationWell,"Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFPLC[Object[Sample,"FPLC Test Oligo" <> $SessionUUID],DestinationWell->"A1",Output->Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Specify whether volume measurement should be conducted automatically on any samples used in the protocol that belong to the protocol's notebook:"},
			options = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, MeasureVolume],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Specify whether weight measurement should be conducted automatically on any samples used in the protocol that belong to the protocol's notebook:"},
			options = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, MeasureWeight],
			True,
			Variables :> {options}
		],
		Example[{Options, FullGradientChangePumpDisconnectAndPurge, "Specify whether to purge the pumps within gradient:"},
			protocol = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				FullGradientChangePumpDisconnectAndPurge -> True
			];
			Download[protocol, {GradientPurge, PurgeVolume}],
			{True, 15*Milliliter},
			Variables :> {protocol},
			EquivalenceFunction -> Equal
		],
		Example[{Options,PumpDisconnectOnFullGradientChangePurgeVolume,"Specify the amount of buffer used to purge the pumps within gradient:"},
			protocol=ExperimentFPLC[
				Object[Sample,"FPLC Test Oligo" <> $SessionUUID],
				FullGradientChangePumpDisconnectAndPurge->True,
				PumpDisconnectOnFullGradientChangePurgeVolume->20*Milliliter
			];
			Download[protocol,{GradientPurge,PurgeVolume}],
			{True,20*Milliliter},
			Variables:>{protocol},
			EquivalenceFunction->Equal
		],

		(* --- Messages --- *)
		Example[{Messages, "GradientNotReequilibrated", "If the gradient does not reequilibrate before the sample injection, the user is warned:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute}
				}
			],
			ObjectP[Object[Protocol,FPLC]],
			Variables:>{protocol},
			Messages:>{
				Warning::GradientNotReequilibrated
			}
		],
		Example[{Messages, "RecoupPurgeConflict", "FlowInjectionPurgeCycle is only applicable for InjectionType -> FlowInjection:"},
			protocol = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				FlowInjectionPurgeCycle->True,
				InjectionType -> Autosampler
			],
			$Failed,
			Variables:>{protocol},
			Messages:>{
				Error::FlowInjectionPurgeCycleConflict,
				Error::InvalidOption,
				Warning::FPLCFlowInjectionPurgeCycle
			}
		],
		Example[{Messages, "FPLCFlowInjectionPurgeCycle", "Warn that FlowInjectionPurgeCycle leads to potential dilution of sample:"},
			protocol = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				FlowInjectionPurgeCycle->True,
				InjectionType->FlowInjection
			],
			ObjectP[Object[Protocol,FPLC]],
			Variables:>{protocol},
			Messages:>{
				Warning::FPLCFlowInjectionPurgeCycle,
				Warning::FPLCInsufficientSampleVolume,
				Warning::TotalAliquotVolumeTooLarge
			}
		],
		Example[{Messages, "GradientPurgeConflict", "Cannot specify to silence the purging of the pumps within gradient while providing a purge volume:"},
			protocol = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				FullGradientChangePumpDisconnectAndPurge -> Null,
				PumpDisconnectOnFullGradientChangePurgeVolume -> 17 Milliliter
			],
			$Failed,
			Variables:>{protocol},
			Messages:>{
				Error::GradientPurgeConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "RemovedExtraGradientEntries", "Duplicate times in the gradients will be removed but a warning will be thrown:"},
			protocol = ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Gradient -> {
					{0. Second, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{5. Second, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{30. Second, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{30.1 Second, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{35. Second, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{35.1 Second, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute},
					{40. Second, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute}
				}
			];
			Download[protocol, GradientA],
			{{
				{0. Second, 100. Percent},
				{5. Second, 100. Percent},
				{30. Second, 0. Percent},
				{35. Second, 0. Percent},
				{40. Second, 100. Percent}
			}},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::RemovedExtraGradientEntries,
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages, "FlowCellChangedToNearest", "The flow cell pathlength will round to the nearest available one:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				FlowCell -> 1 Millimeter];
			Download[protocol, FlowCell],
			ObjectP[Model[Part, FlowCell, "UV flow cell US-0.5"]],
			Variables :> {protocol},
			Messages:>{
				Warning::FlowCellChangedToNearest
			}
		],
		Example[{Messages, "MixerChangedToNearest", "The mixer volume will round to the nearest available one:"},
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				MixerVolume -> 1 Milliliter,
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"]
			];
			Download[protocol, Mixer],
			ObjectP[Model[Part, Mixer, "Avant Mixer Chamber 1.4 mL"]],
			Variables :> {protocol},
			Messages:>{
				Warning::MixerChangedToNearest
			}
		],
		Example[{Messages,"InjectionTypeLoopConflict", "If the injection type and sample loop are incompatible, throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				InjectionType -> Autosampler,
				SampleLoopVolume -> 10 Milliliter
			],
			$Failed,
			Messages:>{
				Error::InjectionTypeLoopConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SuperloopInjectionVolumesRounded", "Superloop injection volumes are rounded to the nearest 0.01 mL:"},
			protocol=ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> Superloop,
				InjectionVolume -> 1.234 Milliliter
			];
			Download[protocol,SampleVolumes],
			{EqualP[Quantity[1230., "Microliters"]], EqualP[Quantity[1230., "Microliters"]]},
			Variables :> {protocol},
			Messages:>{
				Warning::SuperloopInjectionVolumesRounded
			}
		],
		Example[{Messages,"SampleFlowRateConflict", "If the injection type and sample flow rate are incompatible, throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				SampleFlowRate -> {1 Milliliter/Minute, Null},
				InjectionVolume -> {50 Milliliter, 50 Milliliter}
			],
			$Failed,
			Messages:>{
				Error::SampleFlowRateConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleInjectionVolume", "If too small of volume is specified for injection for direct flow, then throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> FlowInjection,
				InjectionVolume -> 50 Microliter
			],
			$Failed,
			Messages:>{
				Error::InsufficientInjectionVolume,
				Error::InvalidOption
			}
		],
		Example[{Messages,"SuperloopMixedAndMatched", "Superloop cannot be used with a different injection type in the same experiment:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID]},
				InjectionType -> {FlowInjection, Superloop},
				InjectionVolume -> {10 Milliliter, 10 Milliliter}
			],
			$Failed,
			Messages:>{
				Error::SuperloopMixedAndMatched,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FeatureUnavailableFPLCInstrument", "The AKTA 10 system cannot have column prime or flush:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				ColumnRefreshFrequency -> FirstAndLast
			],
			$Failed,
			Messages:>{
				Error::FeatureUnavailableFPLCInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FeatureUnavailableFPLCInstrument", "The AKTA 10 system cannot use a superloop:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				InjectionType -> Superloop
			],
			$Failed,
			Messages:>{
				Error::FeatureUnavailableFPLCInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FeatureUnavailableFPLCInstrument", "The AKTA 10 system cannot fraction collect by time:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				FractionCollectionMode -> Time
			],
			$Failed,
			Messages:>{
				Error::FeatureUnavailableFPLCInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NonBinaryFPLC", "Gradient tables should not have entries with both non-zero A and C percentages:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Gradient->{
					{0 Minute, 5 Percent, 50 Percent, 45 Percent, 0 Percent, 1 Milliliter/Minute},
					{10 Minute, 0 Percent, 50 Percent, 50 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			],
			$Failed,
			Messages:>{
				Error::NonBinaryFPLC,
				Error::InvalidOption,
				Warning::GradientNotReequilibrated
			}
		],
		Example[{Messages,"NonBinaryFPLC", "Gradient tables should not have entries with both non-zero B and D percentages:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				StandardGradient->{
					{0 Minute, 0 Percent, 25 Percent, 50 Percent, 25 Percent, 1 Milliliter/Minute},
					{10 Minute, 0 Percent, 50 Percent, 50 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			],
			$Failed,
			Messages:>{
				Error::NonBinaryFPLC,
				Error::InvalidOption,
				Warning::GradientNotReequilibrated
			}
		],
		Example[{Messages,"ConflictingPeakSlopeOptions", "Both PeakSlope and PeakSlopeEnd must be defined to the same units or not at all:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				PeakSlope->2 MilliAbsorbanceUnit/Second,
				PeakSlopeEnd-> 1 Millisiemen/(Centimeter Second)
			],
			$Failed,
			Messages:>{
				Error::ConflictingPeakSlopeOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingFractionOptions", "Specifying fraction related options in an unclear way should result in error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				CollectFractions->True,
				AbsoluteThreshold->Null,
				PeakSlope->Null,
				PeakMinimumDuration->Null,
				PeakEndThreshold->Null,
				FractionCollectionMode->Null
			],
			$Failed,
			Messages:>{
				Error::ConflictingFractionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"ConflictingFractionCollectionOptions", "Specifying both PeakSlope and AbsoluteThreshold should result in an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID],	Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				CollectFractions->True,
				AbsoluteThreshold -> 500 MilliAbsorbanceUnit,
				PeakSlope -> 2 MilliAbsorbanceUnit/Second
			],
			$Failed,
			Messages:>{
				Error::ConflictingFractionCollectionOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"StandardFrequencyNoStandards","StandardFrequency must not be Automatic, Null, or None when there are Standard samples:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Standard->Null,
				StandardFrequency->2
			],
			$Failed,
			Messages:>{
				Error::StandardFrequencyNoStandards,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"StandardsButNoFrequency","StandardFrequency must not be None when there are Standard samples:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Standard->Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"],
				StandardFrequency->None
			],
			$Failed,
			Messages:>{
				Error::StandardsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"BlankFrequencyNoBlanks","BlankFrequency must be Automatic, Null, or None when there are no Blank samples:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Blank->Null,
				BlankFrequency->FirstAndLast
			],
			$Failed,
			Messages:>{
				Error::BlankFrequencyNoBlanks,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"BlanksButNoFrequency","BlankFrequency must not be None when there are Blank samples:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				Blank->Model[Sample, "Milli-Q water"],
				BlankFrequency->Null
			],
			$Failed,
			Messages:>{
				Error::BlanksButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GradientTooLong", "When a gradient is specified for an unreasonably long duration, an error should be thrown:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				GradientStart -> 60 Percent,
				GradientEnd -> 60 Percent,
				GradientDuration -> 8 Day
			],
			$Failed,
			Messages :> {Error::GradientTooLong, Error::InvalidOption,
				Warning::GradientNotReequilibrated}
		],
		Example[{Messages,"InjectionVolumeConflict", "Throw an error when there is a discrepancy between the injection volume in the injection table and what's defined:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 25 Microliter, Automatic}
				},
				InjectionVolume -> 10 Microliter
			],
			$Failed,
			Messages :> {Error::InjectionVolumeConflict, Error::InvalidOption}
		],
		Example[{Messages,"ColumnPrimeOptionInjectionTableConflict", "Throw an error when the injection indicates no column prime, but the user sets such an option anyway:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 25 Microliter, Automatic}
				},
				ColumnPrimeGradientA -> 20Percent
			],
			$Failed,
			Messages :> {Error::ColumnPrimeOptionInjectionTableConflict, Error::InvalidOption}
		],
		Example[{Messages,"ColumnFlushOptionInjectionTableConflict", "Throw an error when the injection indicates no column flush, but the user sets such an option anyway:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 25 Microliter, Automatic}
				},
				ColumnFlushGradientA ->  20Percent
			],
			$Failed,
			Messages :> {Error::ColumnFlushOptionInjectionTableConflict, Error::InvalidOption}
		],
		Example[{Messages,"BlankOptionConflict", "Throw an error when Blank options are specified but conflicting:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Blank -> Model[Sample,"Milli-Q water"],
				BlankGradient ->  Null
			],
			$Failed,
			Messages :> {Error::BlankOptionConflict, Error::InvalidOption}
		],
		Example[{Messages,"StandardOptionConflict", "Throw an error when Standard options are specified but conflicting:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Standard -> Model[Sample,"Milli-Q water"],
				StandardGradient -> Null
			],
			$Failed,
			Messages :> {Error::StandardOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "DiscardedSamples", "Discarded samples cannot be used as inputs:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Discarded Sample" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::DiscardedSamples, Error::InvalidInput}
		],
		Example[{Messages, "ContainerlessSamples", "Samples without containers cannot be used as inputs:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Containerless Sample" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::ContainerlessSamples, Error::InvalidInput}
		],
		Example[{Messages, "DuplicateName", "If the Name option is specified, it must not be the name of an already-existing FPLC protocol:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Name -> "Existing FPLC test protocol for ExperimentFPLC tests" <> $SessionUUID],
			$Failed,
			Messages :> {Error::DuplicateName, Error::InvalidOption}
		],
		Example[
			{Additional,"Short-cut gradient options provide an easy way to set up an isocratic gradient HPLC run:"},
			(
				protocol = ExperimentFPLC[
					Object[Sample,"FPLC Test Oligo" <> $SessionUUID],
					GradientB->50Percent,GradientDuration->5Minute];
				Download[protocol,GradientMethods[[1]][Gradient]]
			),
			{
				{Quantity[0., "Minutes"], Quantity[50., "Percent"],Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters")/("Minutes")]},
				{Quantity[5., "Minutes"], Quantity[50., "Percent"], Quantity[50., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[0., "Percent"], Quantity[1., ("Milliliters")/("Minutes")]}
			},
			Variables:>{protocol}
		],
		Example[{Messages,"GradientStartEndConflict","If GradientStart is specified but GradientEnd is not, throw error:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				GradientStart -> 70 Percent
			],
			$Failed,
			Messages:>{
				Error::InvalidOption,
				Error::GradientStartEndConflict
			}
		],
		Example[{Messages, "InjectionTableGradientConflict", "The InjectionTable and Gradient options, if both specified, must agree with each other:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]}
				},
				Gradient -> Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID]
			],
			$Failed,
			Messages :> {Error::InjectionTableGradientConflict, Error::InvalidOption,
				Warning::GradientNotReequilibrated}
		],
		Example[{Messages,"GradientShortcutConflict","Shortcut Start/End options can not be used at the same time as the GradientA/B/C/D options when GradientDuration is specified:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				BlankGradientStart -> 50 Percent,
				BlankGradientEnd -> 50 Percent,
				BlankGradientDuration -> 20 Minute,
				BlankGradientA -> 50 Percent
			],
			$Failed,
			Messages:>{
				Error::GradientShortcutConflict,
				Warning::GradientNotReequilibrated,
				Error::InvalidOption
			}
		],
		Example[{Messages,"GradientShortcutAmbiguity","If Shortcut Start/End options and GradientA/B/C/D options are specified but they conflict with each other, throw a warning and resolve the gradient based on the former set of options:"},
			(
				options = ExperimentFPLC[
					Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
					BlankGradientStart -> 20 Percent,
					BlankGradientEnd -> 80 Percent,
					BlankGradientB -> 10 Percent,
					Output -> Options
				];
				Lookup[options,BlankGradient][[All,3]]
			),
			{10Percent..},
			Messages:>{
				Error::NonBinaryFPLC,
				Warning::GradientNotReequilibrated,
				Warning::GradientShortcutAmbiguity,
				Error::InvalidOption
			},
			Variables:>{options}
		],
		Example[{Messages, "GradientSingleton", "If a Gradient is specified manually, it needs at least two tuples:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Gradient -> {
					{0 Minute, 100 Percent, 0 Percent,  0 Percent, 0 Percent,  0 Percent, 0 Percent,  0 Percent, 0 Percent, 1 Milliliter/Minute}
				}
			],
			$Failed,
			Messages :> {Error::GradientSingleton, Error::InvalidOption}
		],
		Example[{Messages, "ReverseFlowDirectionConflict", "If using AKTA10 instrument, FlowDirection cannot be Reverse:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				FlowDirection->Reverse,
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]
			],
			$Failed,
			Messages :> {Error::ReverseFlowDirectionConflict, Error::InvalidOption}
		],
		Example[{Messages, "InvalidGradientComposition", "If a Gradient is specified manually, its percentages must sum to 100%:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Gradient -> {
					{0 Minute, 66 Percent, 5 Percent,  0 Percent, 0 Percent, 1 Milliliter/Minute},
					{15 Minute, 50 Percent, 50 Percent,  0 Percent, 0 Percent, 1 Milliliter/Minute},
					{30 Minute, 5 Percent, 95 Percent, 0 Percent, 0 Percent,  1 Milliliter/Minute}
				}
			],
			$Failed,
			Messages :> {Error::InvalidGradientComposition, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableBlankConflict", "If the Blank option is specified, it must agree with the values specified in the InjectionTable:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Blank -> {Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]},
				InjectionTable -> {
					{Blank, Model[Sample, StockSolution, "Ion Exchange Buffer A Native"], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableBlankConflict, Error::InjectionTableForeignBlanks, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableBlankFrequencyConflict", "BlankFrequency and InjectionTable may not be specified together:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				BlankFrequency -> FirstAndLast,
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableBlankFrequencyConflict, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableStandardConflict", "If the Standard option is specified, it must agree with the values specified in the InjectionTable:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Standard -> {Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]},
				InjectionTable -> {
					{Standard, Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Autosampler, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableStandardConflict, Error::InjectionTableForeignStandards, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableStandardFrequencyConflict", "StandardFrequency and InjectionTable may not be specified together:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				StandardFrequency -> FirstAndLast,
				InjectionTable -> {
					{Standard, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Standard, Model[Sample, "Milli-Q water"], Autosampler, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableStandardFrequencyConflict, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableForeignSamples", "If the InjectionTable is specified, the samples included in it must match the input samples precisely:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				InjectionTable -> {
					{Standard, Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Autosampler, 10 Microliter, Automatic},
					{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Autosampler, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableForeignSamples, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableColumnGradientConflict", "If the InjectionTable option is specified, only one ColumnFlush and one ColumnPrime gradient is allowed:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]},
				InjectionTable -> {
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, StockSolution, "Ion Exchange Buffer A Native"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID]},
					{Sample, Object[Sample, "FPLC Test Oligo2" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{ColumnFlush, Null, Null, Null, Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID]}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableColumnGradientConflict, Error::InvalidOption}
		],
		Example[{Messages, "InvalidFractionCollectionEndTime", "FractionCollectionEndTime may not be longer than the duration of the gradient:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], FractionCollectionEndTime -> 2 Hour, GradientDuration -> 1 Hour, GradientStart -> 5 Percent, GradientEnd -> 95 Percent],
			$Failed,
			Messages :> {Error::InvalidFractionCollectionEndTime, Error::InvalidOption}
		],
		Example[{Messages, "InvalidFractionCollectionEndTime", "FractionCollectionEndTime may not be before the FractionCollectionStartTime:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], FractionCollectionStartTime -> 20 Minute, FractionCollectionEndTime -> 10 Minute, GradientDuration -> 1 Hour, GradientStart -> 5 Percent, GradientEnd -> 95 Percent],
			$Failed,
			Messages :> {Error::InvalidFractionCollectionEndTime, Error::InvalidOption}
		],
		Example[{Messages, "ConflictFractionOptionSpecification", "If CollectFractions -> False and other fraction collection options are specified, a warning is thrown:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], CollectFractions -> False, FractionCollectionStartTime -> 5 Minute],
			ObjectP[Object[Protocol, FPLC]],
			Messages :> {Warning::ConflictFractionOptionSpecification}
		],
		Example[{Messages, "IncompatibleColumnTechnique", "Non-FPLC columns cannot be specified:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Column -> Model[Item, Column, "Acquity UPLC Symmetry C18 Trap Column, 150 mm, for micro-flow"]],
			$Failed,
			Messages :> {Error::IncompatibleColumnTechnique, Error::InvalidOption}
		],
		Example[{Messages, "InvalidFractionCollectionTemperature", "If the FractionCollectionTemperature cannot be set to the specified value for the provided instrument, an error is thrown:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"], FractionCollectionTemperature -> 6 Celsius],
			$Failed,
			Messages :> {Error::InvalidFractionCollectionTemperature, Error::InvalidOption}
		],
		Example[{Messages, "InvalidSampleTemperature", "If the SampleTemperature cannot be set to the specified value for the provided InjectionVolume, an error is thrown:"},
			ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID], InjectionVolume -> 1 Liter, SampleTemperature -> 6 Celsius],
			$Failed,
			Messages :> {Error::InvalidSampleTemperature, Error::InvalidOption}
		],
		Example[{Messages, "FlowRateAboveMax", "If the specified FlowRate is above the allowed value for the provided Column, an error is thrown:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], FlowRate -> 25 Milliliter/Minute, Column -> Model[Item, Column, "HiTrap Q HP 5x5mL Column"]],
			$Failed,
			Messages :> {Error::FlowRateAboveMax, Error::InvalidOption}
		],
		Example[{Messages, "InstrumentDoesNotContainDetector", "The specified detectors must be available on the specified instrument:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"], Detector -> {Absorbance, Pressure, Temperature, pH, Conductance}],
			$Failed,
			Messages :> {Error::InstrumentDoesNotContainDetector, Error::InvalidOption}
		],
		Example[{Messages, "FPLCTooManySamples", "If too many samples were specified to perform in one experiment (including blanks and standards), throw an error:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID]}, InjectionVolume -> 10 Microliter, NumberOfReplicates -> 50, Aliquot -> True, ConsolidateAliquots -> False],
			$Failed,
			Messages :> {Error::FPLCTooManySamples, Error::InvalidOption},
			TimeConstraint -> 500
		],
		Example[{Messages, "FPLCTooManySamples", "If too many samples were specified to perform in one experiment (including blanks and standards), throw an error:"},
			ExperimentFPLC[
				{
					Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 4" <> $SessionUUID],
					Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID]
				},
				InjectionVolume -> {900 Milliliter, 12 Milliliter, 2 Liter, 2 Liter, 2 Liter},
				Blank -> {
					Model[Sample, "Milli-Q water"]
				},
				BlankInjectionVolume -> 100 Milliliter,
				Aliquot -> False
			],
			$Failed,
			Messages :> {Error::FPLCTooManySamples, Error::InvalidOption},
			TimeConstraint -> 500
		],
		Example[{Messages, "FPLCTooManySamples", "If one of the samples/blanks/standards is injecting too much volume to use on the autosampler, the maximum number of samples is only 5:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				Blank -> {
					Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
					Model[Sample, StockSolution, "Ion Exchange Buffer B Native"],
					Model[Sample, "Milli-Q water"]
				},
				Standard -> {
					Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
					Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]
				},
				InjectionVolume -> 500 Milliliter,
				StandardInjectionVolume -> 5 Milliliter,
				BlankInjectionVolume -> 5 Milliliter
			],
			$Failed,
			Messages :> {Error::FPLCTooManySamples, Error::InvalidOption}
		],
		Example[{Messages, "TooManyWavelengths", "If more wavelengths are specified than are supported by the instrument, an error is thrown:"},
			ExperimentFPLC[{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]}, Wavelength -> {280 Nanometer, 260 Nanometer, 215 Nanometer, 430 Nanometer}],
			$Failed,
			Messages :> {Error::TooManyWavelengths, Error::InvalidOption}
		],
		Example[{Messages, "UnsupportedWavelength", "If using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], only 280 Nanometer or 254 Nanometer are supported:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, Wavelength -> 260 Nanometer, Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			$Failed,
			Messages :> {Error::UnsupportedWavelength, Error::InvalidOption}
		],
		Example[{Messages, "FractionVolumeAboveMax", "If using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], MaxFractionVolume cannot be greater than 2 Milliliter:"},
			ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, MaxFractionVolume -> 5 Milliliter, Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			$Failed,
			Messages :> {Error::FractionVolumeAboveMax, Error::InvalidOption}
		],
		Example[{Messages, "TooManyBuffers", "At most four different BufferAs and four different BufferBs may be specified, including Standards/Blanks/ColumnPrime/ColumnFlush (if using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], only one each is allowed):"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				BufferA -> Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
				BufferB -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				BufferC -> Model[Sample, StockSolution, "Hybridization Buffer"]
			],
			$Failed,
			Messages :> {Error::TooManyBuffers, Error::InvalidOption, Warning::FPLCBuffersNotFiltered}
		],
		Example[{Messages, "FPLCBuffersNotFiltered", "Buffers should be filtered before the FPLC experiment:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample, "FPLC Test Oligo2" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID], Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "20% Ethanol"]
			],
			ObjectP[Object[Protocol,FPLC]],
			Messages :> {Warning::FPLCBuffersNotFiltered}
		],
		Example[{Messages, "InjectionTableForeignStandards", "If the InjectionTable is specified and its values do not agree with the standard values, an error is thrown:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				StandardInjectionVolume -> {10 Microliter, 15 Microliter},
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableForeignStandards, Error::InvalidOption}
		],
		Example[{Messages, "InjectionTableForeignBlanks", "If the InjectionTable is specified and its values do not agree with the blank values, an error is thrown:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				BlankInjectionVolume -> {10 Microliter, 15 Microliter},
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic}
				}
			],
			$Failed,
			Messages :> {Error::InjectionTableForeignBlanks, Error::InvalidOption}
		],
		Example[{Messages, "IncompatibleInjectionVolume", "The specified injection volumes must be at or below the maximum allowed injection volume for the provided instrument:"},
			ExperimentFPLC[
				Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				InjectionVolume -> 5 Milliliter,
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]
			],
			$Failed,
			Messages :> {Warning::FPLCInsufficientSampleVolume, Error::IncompatibleInjectionVolume, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingPeakSlopeOptions", "All or none of the peak fraction collections must be specified together:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], PeakMinimumDuration -> 0.15 Minute, PeakSlope -> 1 Millisiemen/(Centimeter Second), PeakSlopeEnd -> Null],
			$Failed,
			Messages :> {Error::ConflictingPeakSlopeOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingFractionCollectionOptions", "If specified, the peak fraction options must have compatible units:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], PeakMinimumDuration -> 0.15 Minute, PeakSlope -> 1 Millisiemen/(Centimeter Second), PeakEndThreshold -> 1 MilliAbsorbanceUnit],
			$Failed,
			Messages :> {Error::ConflictingFractionCollectionOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConflictingFractionCollectionOptions", "Both threshold and peak fraction collection options may not be specified together:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], FractionCollectionMode -> Threshold, PeakSlope -> 1 MilliAbsorbanceUnit/Second],
			$Failed,
			Messages :> {Error::ConflictingFractionCollectionOptions, Error::InvalidOption}
		],
		Example[{Messages, "ConductivityThresholdNotSupported", "If using non-avant instruments, cannot use conductivity threshold values:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID], PeakSlope -> 1 Millisiemen/(Centimeter Second), Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			$Failed,
			Messages :> {Error::ConductivityThresholdNotSupported, Error::InvalidOption}
		],
		Example[{Messages, "SampleLoopDisconnectOptionConflict", "If SampleLoopDisconnect is specified and the injection type is not autosampler, throw an error:"},
			ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
				InjectionType->FlowInjection,
				SampleLoopDisconnect->11.5 Milliliter
			],
			$Failed,
			Messages :> {Error::SampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "SampleLoopDisconnectOptionConflict", "If SampleLoopDisconnect volume is specified and InjectionType, Autosampler, is not index mathced to the volume, throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				InjectionType -> {FlowInjection, Autosampler},
				SampleLoopDisconnect -> {11.5 Milliliter, Null}
			],
			$Failed,
			Messages :> {Error::SampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "StandardSampleLoopDisconnectOptionConflict", "If StandardSampleLoopDisconnect is specified and the injection type is not Autosampler, throw an error:"},
			ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
				StandardInjectionType->FlowInjection,
				StandardInjectionVolume->1 Milliliter,
				StandardSampleLoopDisconnect->11.5 Milliliter
			],
			$Failed,
			Messages :> {Error::StandardSampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "StandardSampleLoopDisconnectOptionConflict", "If StandardSampleLoopDisconnect volume is specified and InjectionType, Autosampler, is not index mathced to the volume, throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				StandardInjectionType -> {FlowInjection, Autosampler},
				StandardSampleLoopDisconnect -> {11.5 Milliliter, Null}
			],
			$Failed,
			Messages :> {Error::StandardSampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "BlankSampleLoopDisconnectOptionConflict", "If BlankSampleLoopDisconnect is specified and the injection type is not autosampler, throw an error:"},
			ExperimentFPLC[Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
				BlankInjectionType->FlowInjection,
				BlankInjectionVolume->1 Milliliter,
				BlankSampleLoopDisconnect->11.5 Milliliter
			],
			$Failed,
			Messages :> {Error::BlankSampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "BlankSampleLoopDisconnectOptionConflict", "If BlankSampleLoopDisconnect volume is specified and InjectionType, Autosampler, is not index mathced to the volume, throw an error:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				BlankInjectionType -> {FlowInjection, Autosampler},
				BlankSampleLoopDisconnect -> {11.5 Milliliter, Null}
			],
			$Failed,
			Messages :> {Error::BlankSampleLoopDisconnectOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "SampleLoopDisconnectInstrumentOptionConflict", "If SampleLoopDisconnect, StandardSampleLoopDisconnect or BlankSampleLoopDisconnect is specified and the instrument is not an Avant 25 or Avant 150, throw an error:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				SampleLoopDisconnect -> 11.5 Milliliter
			],
			$Failed,
			Messages :> {Error::SampleLoopDisconnectInstrumentOptionConflict, Error::InvalidOption}
		],
		Example[{Messages, "LowAutosamplerFlushVolume", "If SampleLoopDisconnect, StandardSampleLoopDisconnect or BlankSampleLoopDisconnect is specified and the value is less than the volume of tubing in the autosampler, warn that the sample loop will not be completely emptied:"},
			ExperimentFPLC[Object[Sample, "FPLC Test Oligo" <> $SessionUUID],
				Instrument -> Model[Instrument, FPLC, "AKTA avant 150"],
				SampleLoopDisconnect -> 5 Milliliter
			],
			ObjectReferenceP[Object[Protocol,FPLC]],
			Messages :> {Warning::LowAutosamplerFlushVolume}
		],
		Example[{Messages,"FPLCInsufficientSampleVolume","If InjectionVolume is greater than sample volume, throw error but continue:"},
			(
				packet = ExperimentFPLC[
					Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],
					Upload->False,
					InjectionVolume -> 96 Milliliter
				][[1]];
				Lookup[packet,Replace[SampleVolumes]]
			),
			{96 Milliliter},
			Messages:>{Warning::FPLCInsufficientSampleVolume,Warning::TotalAliquotVolumeTooLarge,Warning::InsufficientVolume},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[{Messages,"FPLCInsufficientSampleVolume","If InjectionVolume is less than sample volume but greater than sample volume + dead volume, throw error but continue:"},
			(
				packet = ExperimentFPLC[
					Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],
					Upload->False,
					InjectionVolume -> 90 Milliliter
				][[1]];
				Lookup[packet,Replace[SampleVolumes]]
			),
			{90 Milliliter},
			Messages:>{Warning::FPLCInsufficientSampleVolume,Warning::TotalAliquotVolumeTooLarge,Warning::InsufficientVolume},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],


		(* --- Tests --- *)

		(* commenting out these tests for now while I get the bare bones of my function done, and then will uncomment them as necessary *)
		Test["Informs GradientMethods field:",
			Lookup[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, Upload -> False][[1]],
				Replace[GradientMethods]
			],
			{ObjectP[Object[Method, Gradient]]}
		],
		Test["Informs SeparationTime field:",
			Lookup[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, Upload -> False][[1]],
				SeparationTime
			],
			TimeP
		],
		Test["Informs NumberOfInjections field:",
			Lookup[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, Upload -> False][[1]],
				NumberOfInjections
			],
			3
		],
		Test["Informs FractionCollectionMethods, FractionContainers, and FractionContainerRacks fields:",
			protocol = ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, CollectFractions -> True];
			Download[protocol, {FractionCollectionMethods, FractionContainers, FractionContainerRacks}],
			{
				{ObjectP[Object[Method, FractionCollection]]},
				{ObjectP[Model[Container]]..},
				{Repeated[ObjectP[Model[Container, Rack]],{7}]}
			},
			Variables :> {protocol}
		],
		Test["Informs fraction containers into ContainersOut when CollectFractions->True:",
			Lookup[
				ExperimentFPLC[{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]}, CollectFractions -> True, Upload -> False][[1]],
				Replace[ContainersOut]
			],
			{ObjectP[Model[Container]]..}
		],
		Test["Does not upload fraction containers into ContainersOut when CollectFractions->False:",
			Lookup[
				ExperimentFPLC[
					{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
					CollectFractions -> False,
					Upload -> False
				][[1]],
				Replace[ContainersOut]
			],
			{}
		],
		Test["Works effectively on samples without a Model link:",
			ExperimentFPLC[{Object[Sample, "ExpFPLC Model-less Oligo for ExperimentFPLC tests" <> $SessionUUID]}],
			ObjectP[Object[Protocol, FPLC]]
		],


		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		(* ------------ FUNTOPIA SHARED OPTION TESTING ------------ *)
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentFPLC[
				(* Milli-Q water *)
				{Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:8qZ1VWNmdLBD"]},
				PreparedModelAmount -> 1 Milliliter,
				(* 96-well 2mL Deep Well Plate *)
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
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
				(* Milli-Q water *)
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]]..},
				(* 96-well 2mL Deep Well Plate *)
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentFPLC[
				Model[Sample, "Caffeine"],
				PreparedModelAmount -> 5 Milligram,
				MixType -> Vortex, IncubationTime -> 10 Minute,
				AssayBuffer -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, FPLC]]
		],
		Example[{Options, PreparatoryUnitOperations, "Transfer water to use as blanks samples in a column qualification protocol:"},
			ExperimentFPLC[
				"My Blanks Plate",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Blanks Plate",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"A1", "My Blanks Plate"},
						Amount -> 1. * Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"B1", "My Blanks Plate"},
						Amount -> 1. * Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"C1", "My Blanks Plate"},
						Amount -> 1. * Milliliter
					]
				},
				BufferA -> Model[Sample, "Milli-Q water"],
				BufferB -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, FPLC]]
		],
		Example[{Options, PreparatoryUnitOperations, "Describe the preparation of a buffer before using it in an FPLC protocol:"},
			ExperimentFPLC[
				{Object[Sample, "FPLC Test Oligo" <> $SessionUUID]},
				BufferA -> "My Buffer",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Buffer Container",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My Buffer Container",
						Amount -> 1800 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Tris Base"],
						Destination -> "My Buffer Container",
						Amount -> 22 Gram
					],
					LabelSample[
						Label -> "My Buffer",
						Sample -> {"A1", "My Buffer Container"}
					]
				}
			],
			ObjectP[Object[Protocol, FPLC]],
			TimeConstraint -> 600
		],
		Example[{Options, PreparatoryUnitOperations, "Mix a stock solution sample before aliquotting into a deepwell plate that will be loaded onto the FPLC:"},
			ExperimentFPLC[
				{"My 4L Bottle", "My 4L Bottle", "My 4L Bottle"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 4L Bottle",
						Container -> Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> {Model[Sample, StockSolution, "id:R8e1PjpR1k0n"]},
						Destination -> "My 4L Bottle",
						Amount -> 450 Milliliter
					],
					Mix[
						Sample -> "My 4L Bottle",
						MixType -> Roll,
						Time -> 30 Minute
					]
				},
				Aliquot -> True,
				AssayVolume -> {1 Milliliter, 1.25 Milliliter, 1 Milliliter},
				AliquotContainer -> {
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
				},
				ConsolidateAliquots -> False
			],
			ObjectP[Object[Protocol, FPLC]]
		],
		Test["Make resources for the solutions, syringes, and needles for calibrating the pH detector:",
			Download[
				ExperimentFPLC[
					{Object[Sample, "FPLC Test Oligo" <> $SessionUUID], Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID]},
					Instrument -> Model[Instrument, FPLC, "AKTA avant 25"]
				],
				{
					CalibrationWashSolution,
					LowpHCalibrationBuffer,
					HighpHCalibrationBuffer,
					pHCalibrationStorageBuffer,
					CalibrationWashSolutionSyringe,
					LowpHCalibrationBufferSyringe,
					HighpHCalibrationBufferSyringe,
					pHCalibrationStorageBufferSyringe,
					CalibrationWashSolutionSyringeNeedle,
					LowpHCalibrationBufferSyringeNeedle,
					HighpHCalibrationBufferSyringeNeedle,
					pHCalibrationStorageBufferSyringeNeedle,
					LowpHCalibrationTarget,
					HighpHCalibrationTarget
				}
			],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				ObjectP[Model[Container, Syringe]],
				ObjectP[Model[Container, Syringe]],
				ObjectP[Model[Container, Syringe]],
				ObjectP[Model[Container, Syringe]],
				ObjectP[Model[Item, Needle]],
				ObjectP[Model[Item, Needle]],
				ObjectP[Model[Item, Needle]],
				ObjectP[Model[Item, Needle]],
				4.63,
				11.
			}
		],
		Test["Perform system prime and flush for all buffers used in the injection run (requires correct buffers):",
			protocol = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], GradientD->70Percent];
			Download[
				protocol,
				{
					SystemPrimeBufferA, SystemPrimeBufferB, SystemPrimeBufferC, SystemPrimeBufferD, SystemPrimeBufferE, SystemPrimeBufferF, SystemPrimeBufferG, SystemPrimeBufferH,
					SystemFlushBufferA, SystemFlushBufferB, SystemFlushBufferC, SystemFlushBufferD, SystemFlushBufferE, SystemFlushBufferF, SystemFlushBufferG, SystemFlushBufferH
				}
			],
			{
				ObjectP[],ObjectP[],Null,ObjectP[],Null,Null,Null,Null,
				ObjectP[],ObjectP[],Null,ObjectP[],Null,Null,Null,Null
			},
			Variables :> {protocol}
		],
		Test["Perform system prime and flush for all buffers used in the injection run (populates corresponding gradients):",
			protocol = ExperimentFPLC[Object[Sample,  "FPLC Test Oligo" <> $SessionUUID], GradientE->20Percent,GradientH->80Percent];
			Download[
				protocol,
				{SystemPrimeGradient[Gradient][[All,2;;9]],SystemFlushGradient[Gradient][[All,2;;9]]}
			],
			{
				{
					(* A *)
					{EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* E *)
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* B *)
					{EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* H *)
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent]},
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent]}
				},
				{
					(* A *)
					{EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* E *)
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* B *)
					{EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					(* H *)
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent]},
					{EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent],EqualP[100Percent]}
				}
			},
			Variables :> {protocol}
		]
	},
	SetUp :> (
		$CreatedObjects = {};
		ClearDownload[];
		ClearMemoization[];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	HardwareConfiguration -> HighRAM,
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID],
				Object[Container, Plate, "FPLC Test Plate2" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo New Plate" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo in nondefault but compatible tube" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo in nondefault but compatible bottle" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "A test Parent Protocol for ExperimentFPLC testing" <> $SessionUUID],
				Object[Qualification, HPLC, "A test Parent Qualification for ExperimentFPLC testing" <> $SessionUUID],
				Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water BufferA" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water BufferB" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Buffer Bottle A" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Buffer Bottle B" <> $SessionUUID],
				Object[Item, Column, "FPLC Test Column" <> $SessionUUID],
				Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID],
				Object[Sample,  "ExpFPLC Model-less Oligo for ExperimentFPLC tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentFPLC not parseFPLC, Steven!, Test Plate for Model-less Samp" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 1" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 2" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 3" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 4" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 5" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 6 (incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 7" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 8 (nondefault but compatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 9 (nondefault but compatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 10" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 4" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 8" <> $SessionUUID],
				Object[Protocol, FPLC, "Existing FPLC test protocol for ExperimentFPLC tests" <> $SessionUUID],
				Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID],
				Object[Sample, "FPLC Test Containerless Sample" <> $SessionUUID],
				Object[Sample, "FPLC Test Discarded Sample" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Discarded Container" <> $SessionUUID],
				Object[Container, Bench, "FPLC test bench for tests" <> $SessionUUID],
				Model[Item, Cap, "FPLC test 50 mL Aspiration Cap" <> $SessionUUID],
				Object[Item, Cap, "FPLC Test Aspiration Cap 1" <> $SessionUUID],
				Object[Item, Cap, "FPLC Test Aspiration Cap 2" <> $SessionUUID],
				Model[Molecule, Oligomer, "Test DNA IM for FPLC" <> $SessionUUID],
				Model[Sample,"Test DNA oligomer model for FPLC" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];
		Module[
			{testNewModelID, testPlate, testPlate2, testPlate3, testBufferBottle1, testBufferBottle2, testProtocol,
				testQual, testColumn, testMethod, testFCMethod, waterSample, oligoSample, oligoSample2,
				oligoSampleNewPlate, waterBuffer1, waterBuffer2, modLessSamp, testLargeSampleBottle1, largeVolumeSample,
				testLargeSampleBottle2, largeVolumeSample2, testFPLCProtocol, testMethod2, testDiscardedContainer,
				discardedSample, containerlessSample,testLargeSampleBottle3, testLargeSampleBottle4, testLargeSampleBottle5,
				largeVolumeSample3, largeVolumeSample4, largeVolumeSample5, testLargeSampleBottle6, largeVolumeSample6, testLargeSampleBottle7,testLargeSampleBottle8,
				testAspirationCapModel,testBench,testAspirationCap1,testAspirationCap2,dnaIdentityModel,dnaModelPacket,dnaModel,
				largeVolumeSample7, largeVolumeSample8, testSmallTube, testSmallBottle, oligoSample3, oligoSample4},

			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			testNewModelID = CreateID[Model[Container, Vessel]];

			(*create the new identity models for the PNA and DNA used for the test models*)
			(* create some oligomer identity models*)
			dnaIdentityModel = UploadOligomer["Test DNA IM for FPLC" <> $SessionUUID, Molecule -> Strand[DNA["AATTGTTCGGACACT"]], PolymerType -> DNA];

			(*create all of the models*)
			dnaModelPacket = UploadSampleModel["Test DNA oligomer model for FPLC" <> $SessionUUID,
				Composition -> {
					{0.1 Milli * Molar, Model[Molecule, Oligomer, "Test DNA IM for FPLC" <> $SessionUUID]},
					{100 VolumePercent, Model[Molecule, "Water"]}
				},
				MSDSRequired -> False,
				DefaultStorageCondition -> Model[StorageCondition, "id:N80DNj1r04jW"],
				Flammable -> False,
				Acid -> False,
				Base -> False,
				Pyrophoric -> False,
				NFPA -> {0, 0, 0, Null},
				DOTHazardClass -> "Class 0",
				IncompatibleMaterials -> {None},
				Expires -> False,
				State -> Liquid,
				BiosafetyLevel -> "BSL-1",
				Upload -> False
			];

			(* Create some containers *)
			{
				(*1*)testPlate,
				(*2*)testPlate2,
				(*3*)testPlate3,
				(*4*)testSmallTube,
				(*5*)testSmallBottle,
				(*6*)testLargeSampleBottle1,
				(*7*)testLargeSampleBottle2,
				(*8*)testLargeSampleBottle3,
				(*9*)testLargeSampleBottle4,
				(*10*)testLargeSampleBottle5,
				(*11*)testLargeSampleBottle6,
				(*12*)testLargeSampleBottle7,
				(*13*)testLargeSampleBottle8,
				(*14*)testDiscardedContainer,
				(*15*)testBufferBottle1,
				(*16*)testBufferBottle2,
				(*17*)testProtocol,
				(*18*)testQual,
				(*19*)testColumn,
				(*20*)testMethod,
				(*21*)testMethod2,
				(*22*)testFCMethod,
				(*23*)testFPLCProtocol,
				(*24*)testBench,
				(*25*)testAspirationCapModel,
				(*26*)dnaModel
			} = Upload[Flatten@{
				(*1*)<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "FPLC Test Plate" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*2*)<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "FPLC Test Plate2" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*3*)<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "ExperimentFPLC not parseFPLC, Steven!, Test Plate for Model-less Samp" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*4*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "1mL HPLC Vial (total recovery)"], Objects], Name -> "FPLC Test Sample Container 8 (nondefault but compatible)" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*5*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name -> "FPLC Test Sample Container 9 (nondefault but compatible)" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*6*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "FPLC Test Sample Container 1" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*7*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name -> "FPLC Test Sample Container 2" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*8*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "FPLC Test Sample Container 3" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*9*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "FPLC Test Sample Container 4" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*10*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "FPLC Test Sample Container 5" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*11*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "5L Glass Bottle"], Objects], Name -> "FPLC Test Sample Container 6 (incompatible)" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*12*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "100 mL Glass Bottle"], Objects], Name -> "FPLC Test Sample Container 7" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*13*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "FPLC Test Sample Container 10" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*14*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "HPLC vial (high recovery)"], Objects], Name -> "FPLC Test Discarded Container" <> $SessionUUID, Status -> Discarded, Site->Link[$Site], DeveloperObject -> True|>,
				(*15*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"], Objects], Name -> "FPLC Test Buffer Bottle A" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*16*)<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"], Objects], Name -> "FPLC Test Buffer Bottle B" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				(*17*)<|Type -> Object[Protocol, ManualSamplePreparation], Name -> "A test Parent Protocol for ExperimentFPLC testing" <> $SessionUUID, Status -> Processing, Site->Link[$Site], DeveloperObject -> True|>,
				(*18*)<|Type -> Object[Qualification, HPLC], Name -> "A test Parent Qualification for ExperimentFPLC testing" <> $SessionUUID, Status -> Processing, Site->Link[$Site], DeveloperObject -> True|>,
				(*19*)<|Type -> Object[Item, Column], Model -> Link[Model[Item, Column, "HiTrap 5x5mL Desalting Column"], Objects], Name -> "FPLC Test Column" <> $SessionUUID, Status -> Available, Site->Link[$Site], DeveloperObject -> True|>,
				(*20*)<|
					Type -> Object[Method, Gradient],
					Name -> "FPLC Test Method" <> $SessionUUID,
					GradientStart -> 10Percent,
					GradientEnd -> 100Percent,
					GradientDuration -> 50 * Minute,
					EquilibrationTime -> 10 * Minute,
					Replace[Gradient] -> {
						{0 * Minute, 10 * Percent, 90 * Percent, 0 * Percent, 0 * Percent,0 * Percent, 0 * Percent,0 * Percent, 0 * Percent, 1 * Milliliter / Minute},
						{50 * Minute, 100 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute}
					},
					FlushTime -> 15 * Minute,
					DeveloperObject -> True,
					BufferA -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferB -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]],
					BufferC -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferD -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]]
				|>,
				(*21*)<|
					Type -> Object[Method, Gradient],
					Name -> "FPLC Test Method2" <> $SessionUUID,
					GradientStart -> 5 Percent,
					GradientEnd -> 95 Percent,
					GradientDuration -> 50 * Minute,
					EquilibrationTime -> 10 * Minute,
					Replace[Gradient] -> {
						{0 * Minute, 5 * Percent, 95 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute},
						{50 * Minute, 95 * Percent, 5 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute}
					},
					FlushTime -> 15 * Minute,
					DeveloperObject -> True,
					BufferA -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferB -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]],
					BufferC -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferD -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]]
				|>,
				(*22*)<|
					Type -> Object[Method, FractionCollection],
					Name -> "FPLC Test FC Method" <> $SessionUUID,
					FractionCollectionMode -> Threshold,
					AbsoluteThreshold -> 500 * Milli * AbsorbanceUnit,
					FractionCollectionStartTime -> 5. * Minute,
					FractionCollectionEndTime -> 40. * Minute,
					MaxCollectionPeriod -> 1.8 * Minute,
					PeakSlope -> Null,
					DeveloperObject -> True,
					FractionCollectionTemperature -> 8 Celsius
				|>,
				(*23*)<|
					Type -> Object[Protocol, FPLC],
					Name -> "Existing FPLC test protocol for ExperimentFPLC tests" <> $SessionUUID,
					Status -> Completed,
					DeveloperObject -> True
				|>,
				(*24*)<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "FPLC test bench for tests" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>,
				(*25*)<| Type -> Model[Item, Cap], Name -> "FPLC test 50 mL Aspiration Cap" <> $SessionUUID, DeveloperObject -> True |>,
				(*26*)dnaModelPacket
			}][[;;26]];

			(* Create some samples *)
			{
				(*1*)waterSample,
				(*2*)oligoSample,
				(*3*)oligoSample2,
				(*4*)oligoSampleNewPlate,
				(*5*)waterBuffer1,
				(*6*)waterBuffer2,
				(*7*)modLessSamp,
				(*8*)oligoSample3,
				(*9*)oligoSample4,
				(*10*)largeVolumeSample,
				(*11*)largeVolumeSample2,
				(*12*)largeVolumeSample3,
				(*13*)largeVolumeSample4,
				(*14*)largeVolumeSample5,
				(*15*)largeVolumeSample6,
				(*16*)largeVolumeSample7,
				(*17*)largeVolumeSample8,
				(*18*)discardedSample,
				(*19*)containerlessSample,
				(*20*)testAspirationCap1,
				(*21*)testAspirationCap2
			} = UploadSample[
				{
					(*1*)Model[Sample, "Milli-Q water"],
					(*2*)dnaModel,
					(*3*)dnaModel,
					(*4*)dnaModel,
					(*5*)Model[Sample, "Milli-Q water"],
					(*6*)Model[Sample, "Milli-Q water"],
					(*7*)dnaModel,
					(*8*)dnaModel,
					(*9*)dnaModel,
					(*10*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*11*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*12*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*13*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*14*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*15*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*16*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*17*)Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					(*18*)dnaModel,
					(*19*)dnaModel,
					(*20*)Model[Item, Cap, "FPLC test 50 mL Aspiration Cap" <> $SessionUUID],
					(*21*)Model[Item, Cap, "FPLC test 50 mL Aspiration Cap" <> $SessionUUID]
				},
				{
					(*1*){"A1", testPlate},
					(*2*){"B1", testPlate},
					(*3*){"B2", testPlate},
					(*4*){"B1", testPlate2},
					(*5*){"A1", testBufferBottle1},
					(*6*){"A1", testBufferBottle2},
					(*7*){"C3", testPlate3},
					(*8*){"A1", testSmallTube},
					(*9*){"A1", testSmallBottle},
					(*10*){"A1", testLargeSampleBottle1},
					(*11*){"A1", testLargeSampleBottle2},
					(*12*){"A1", testLargeSampleBottle3},
					(*13*){"A1", testLargeSampleBottle4},
					(*14*){"A1", testLargeSampleBottle5},
					(*15*){"A1", testLargeSampleBottle6},
					(*16*){"A1", testLargeSampleBottle7},
					(*17*){"A1", testLargeSampleBottle8},
					(*18*){"A1", testDiscardedContainer},
					(*19*){"A1", testPlate3},
					(*20*){"Work Surface", testBench},
					(*21*){"Work Surface", testBench}
				},
				InitialAmount -> {
					(*1*)1.75 Milliliter,
					(*2*)1.75 Milliliter,
					(*3*)1.75 Milliliter,
					(*4*)1.75 Milliliter,
					(*5*)3.5 Liter,
					(*6*)3.5 Liter,
					(*7*)1.5 Milliliter,
					(*8*)0.9 Milliliter,
					(*9*)90 Milliliter,
					(*10*)1.1 Liter,
					(*11*)95 Milliliter,
					(*12*)3 Liter,
					(*13*)3 Liter,
					(*14*)3 Liter,
					(*15*)3 Liter,
					(*16*)95 Milliliter,
					(*17*)45 Milliliter,
					(*18*)0.5 Milliliter,
					(*19*)0.5 Milliliter,
					(*20*)Null,
					(*21*)Null
				},
				State -> {
					(*1*)Liquid,
					(*2*)Liquid,
					(*3*)Liquid,
					(*4*)Liquid,
					(*5*)Liquid,
					(*6*)Liquid,
					(*7*)Liquid,
					(*8*)Liquid,
					(*9*)Liquid,
					(*10*)Liquid,
					(*11*)Liquid,
					(*12*)Liquid,
					(*13*)Liquid,
					(*14*)Liquid,
					(*15*)Liquid,
					(*16*)Liquid,
					(*17*)Liquid,
					(*18*)Liquid,
					(*19*)Liquid,
					(*20*)Automatic,
					(*21*)Automatic
				},
				StorageCondition -> Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object -> waterSample, Name -> "FPLC Test Water Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSample, Name -> "FPLC Test Oligo" <> $SessionUUID, Status -> Available, DeveloperObject -> True, Replace[Composition] -> {{10 Micromolar, Link[Model[Molecule, Oligomer, "id:O81aEBZnjv6D"]], Now}}|>,
				<|Object -> oligoSample2, Name -> "FPLC Test Oligo2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSampleNewPlate, Name -> "FPLC Test Oligo New Plate" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterBuffer1, Name -> "FPLC Test Water BufferA" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterBuffer2, Name -> "FPLC Test Water BufferB" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> modLessSamp, Name -> "ExpFPLC Model-less Oligo for ExperimentFPLC tests" <> $SessionUUID, Model -> Null, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSample3, Name -> "FPLC Test Oligo in nondefault but compatible tube" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSample4, Name -> "FPLC Test Oligo in nondefault but compatible bottle" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample, Name -> "FPLC Large-Volume Protein Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample2, Name -> "FPLC Large-Volume Protein Sample 2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample3, Name -> "FPLC Large-Volume Protein Sample 3" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample4, Name -> "FPLC Large-Volume Protein Sample 4" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample5, Name -> "FPLC Large-Volume Protein Sample 5" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample6, Name -> "FPLC Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample7, Name -> "FPLC Large-Volume Protein Sample 7" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample8, Name -> "FPLC Large-Volume Protein Sample 8" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> containerlessSample, Name -> "FPLC Test Containerless Sample" <> $SessionUUID, Container -> Null, DeveloperObject -> True|>,
				<|Object -> discardedSample, Name -> "FPLC Test Discarded Sample" <> $SessionUUID, Status -> Discarded, DeveloperObject -> True|>,
				<|Object -> testAspirationCap1, Name -> "FPLC Test Aspiration Cap 1" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> testAspirationCap2, Name -> "FPLC Test Aspiration Cap 2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				(*add the aspiration cap model to the container for the 50 mL tubes*)
				<|Object -> Model[Container, Vessel, "50mL Tube"]|>
			}];

		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLC Test Plate" <> $SessionUUID],
				Object[Container, Plate, "FPLC Test Plate2" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo2" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo New Plate" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo in nondefault but compatible tube" <> $SessionUUID],
				Object[Sample,  "FPLC Test Oligo in nondefault but compatible bottle" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "A test Parent Protocol for ExperimentFPLC testing" <> $SessionUUID],
				Object[Qualification, HPLC, "A test Parent Qualification for ExperimentFPLC testing" <> $SessionUUID],
				Object[Method, Gradient, "FPLC Test Method" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water BufferA" <> $SessionUUID],
				Object[Sample,  "FPLC Test Water BufferB" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Buffer Bottle A" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Buffer Bottle B" <> $SessionUUID],
				Object[Item, Column, "FPLC Test Column" <> $SessionUUID],
				Object[Method, FractionCollection, "FPLC Test FC Method" <> $SessionUUID],
				Object[Sample,  "ExpFPLC Model-less Oligo for ExperimentFPLC tests" <> $SessionUUID],
				Object[Container, Plate, "ExperimentFPLC not parseFPLC, Steven!, Test Plate for Model-less Samp" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 1" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 2" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 3" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 4" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 5" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 6 (incompatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 7" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 8 (nondefault but compatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 9 (nondefault but compatible)" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Sample Container 10" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 2" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 3" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 4" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 5" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 7" <> $SessionUUID],
				Object[Sample, "FPLC Large-Volume Protein Sample 8" <> $SessionUUID],
				Object[Protocol, FPLC, "Existing FPLC test protocol for ExperimentFPLC tests" <> $SessionUUID],
				Object[Method, Gradient, "FPLC Test Method2" <> $SessionUUID],
				Object[Sample, "FPLC Test Containerless Sample" <> $SessionUUID],
				Object[Sample, "FPLC Test Discarded Sample" <> $SessionUUID],
				Object[Container, Vessel, "FPLC Test Discarded Container" <> $SessionUUID],
				Object[Container, Bench, "FPLC test bench for tests" <> $SessionUUID],
				Model[Item, Cap, "FPLC test 50 mL Aspiration Cap" <> $SessionUUID],
				Object[Item, Cap, "FPLC Test Aspiration Cap 1" <> $SessionUUID],
				Object[Item, Cap, "FPLC Test Aspiration Cap 2" <> $SessionUUID],
				Model[Molecule, Oligomer, "Test DNA IM for FPLC" <> $SessionUUID],
				Model[Sample,"Test DNA oligomer model for FPLC" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	),
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]}
];


(* TODO sister functions need to be totally redone from scratch (most notably, the ValidQ function needs to actually test all of the tests that are being generated *)
(* ::Subsubsection:: *)
(*ExperimentFPLCOptions*)


DefineTests[ExperimentFPLCOptions,
	{
		Example[
			{Basic, "Automatically resolve of all options for sample:"},
			ExperimentFPLCOptions[Object[Sample, "FPLCOptions Test Oligo" <> $SessionUUID], OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[
			{Basic, "Specify the injection volume for each sample:"},
			ExperimentFPLCOptions[Object[Sample, "FPLCOptions Test Oligo" <> $SessionUUID], InjectionVolume -> 50 Micro Liter, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[
			{Basic, "Resolve fraction collection fractions:"},
			ExperimentFPLCOptions[Object[Sample, "FPLCOptions Test Oligo" <> $SessionUUID], Scale -> Preparative, OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options for each sample as a list:"},
			ExperimentFPLCOptions[Object[Sample, "FPLCOptions Test Oligo" <> $SessionUUID], OutputFormat -> List],
			{Rule[_Symbol, Except[Automatic | $Failed]]..}
		],
		Example[
			{Options, OutputFormat, "Return the resolved options for each sample as a table:"},
			ExperimentFPLCOptions[Object[Sample, "FPLCOptions Test Oligo" <> $SessionUUID]],
			Graphics_
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLCOptions Test Plate" <> $SessionUUID],
				Object[Sample,  "FPLCOptions Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLCOptions Test Oligo" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];

		Module[
			{testPlateOptions, waterSampleOptions, oligoSampleOptions},
			(* Create some containers *)
			{
				testPlateOptions
			} = Upload[{
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "FPLCOptions Test Plate" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>
			}];

			(* Create some samples *)
			{
				waterSampleOptions,
				oligoSampleOptions
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:rea9jl1X4N3b"]
				},
				{
					{"A1", testPlateOptions},
					{"B1", testPlateOptions}
				},
				InitialAmount -> {
					1.5 Milliliter,
					1.5 Milliliter
				},
				State -> {
					Liquid,
					Liquid
				},
				StorageCondition -> Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object -> waterSampleOptions, Name -> "FPLCOptions Test Water Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSampleOptions, Name -> "FPLCOptions Test Oligo" <> $SessionUUID, Status -> Available, Concentration -> 10 * Nanomolar, DeveloperObject -> True|>
			}];
		]
	},
	Variables :> {waterSampleOptions, oligoSampleOptions},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLCOptions Test Plate" <> $SessionUUID],
				Object[Sample,  "FPLCOptions Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLCOptions Test Oligo" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	}
];


(* ::Subsubsection:: *)
(*ExperimentFPLCPreview*)


DefineTests[ExperimentFPLCPreview,
	{
		Example[
			{Basic, "Generate a preview for an FPLC protocol:"},
			ExperimentFPLCPreview[Object[Sample, "FPLCPreview Test Oligo" <> $SessionUUID]],
			Null
		],
		Example[
			{Basic, "Generate a preview for a protocol that specifies the injection volume for each sample:"},
			ExperimentFPLCPreview[Object[Sample, "FPLCPreview Test Oligo" <> $SessionUUID], InjectionVolume -> 50 Micro Liter],
			Null
		],
		Example[
			{Basic, "Preview will always be Null:"},
			ExperimentFPLCPreview[Object[Sample, "FPLCPreview Test Oligo" <> $SessionUUID], Scale -> Preparative],
			Null
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLCPreview Test Plate" <> $SessionUUID],
				Object[Sample,  "FPLCPreview Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLCPreview Test Oligo" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];

		Module[
			{testPlatePreview, waterSamplePreview, oligoSamplePreview},
			(* Create some containers *)
			{
				testPlatePreview
			} = Upload[{
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "FPLCPreview Test Plate" <> $SessionUUID, Site -> Link[$Site], DeveloperObject -> True|>
			}];

			(* Create some samples *)
			{
				waterSamplePreview,
				oligoSamplePreview
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:rea9jl1X4N3b"]
				},
				{
					{"A1", testPlatePreview},
					{"B1", testPlatePreview}
				},
				InitialAmount -> {
					1.5 Milliliter,
					1.5 Milliliter
				},
				State -> Liquid,
				StorageCondition -> Refrigerator
			];

			(* Secondary uploads *)
			Upload[{
				<|Object -> waterSamplePreview, Name -> "FPLCPreview Test Water Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSamplePreview, Name -> "FPLCPreview Test Oligo" <> $SessionUUID, Status -> Available, Concentration -> 10 * Nanomolar, DeveloperObject -> True|>
			}];
		]
	},
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "FPLCPreview Test Plate" <> $SessionUUID],
				Object[Sample,  "FPLCPreview Test Water Sample" <> $SessionUUID],
				Object[Sample,  "FPLCPreview Test Oligo" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentFPLCQ*)

DefineTests[ValidExperimentFPLCQ,
	{
		Example[{Basic, "Generates and returns a protocol object when given samples:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample,  "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID]}],
			True
		],
		Example[{Basic, "Generates and returns a protocol object when given one unlisted sample:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]],
			True
		],
		Example[
			{Options, Verbose, "Display all tests (or test failures) with the Verbose option:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], InjectionVolume -> 50 Micro Liter, Verbose -> Failures],
			True,
			TimeConstraint -> 240
		],
		Example[
			{Options, OutputFormat, "Toggle the output format of the tests to output a TestSummary:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], InjectionVolume -> 100 Micro Liter, OutputFormat -> TestSummary],
			_EmeraldTestSummary
		],
		Example[{Messages, "DiscardedSamples", "Discarded samples cannot be used as inputs:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Test Discarded Sample" <> $SessionUUID]}],
			False
		],
		Example[{Messages, "ContainerlessSamples", "Samples without containers cannot be used as inputs"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Test Containerless Sample" <> $SessionUUID]}],
			False
		],
		Example[{Messages, "DuplicateName", "If the Name option is specified, it must not be the name of an already-existing FPLC protocol:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Name -> "Existing ValidExperimentFPLCQ test protocol" <> $SessionUUID],
			False
		],
		Example[{Messages, "GradientStartEndConflict", "GradientStart and GradientEnd must either both be specified or both blank:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], GradientStart -> 5 Percent, GradientEnd -> Null],
			False
		],
		Example[{Messages, "InjectionTableGradientConflict", "The InjectionTable and Gradient options, if both specified, must agree with each other:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID]},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID]}
				},
				Gradient -> Object[Method, Gradient, "ValidExperimentFPLCQ Test Method2" <> $SessionUUID]
			],
			False
		],
		Example[{Messages, "InvalidGradientComposition", "If a Gradient is specified manually, its percentages must sum to 100%:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				Gradient -> {
					{0 Minute, 66 Percent, 5 Percent, 1 Milliliter/Minute},
					{15 Minute, 50 Percent, 50 Percent, 1 Milliliter/Minute},
					{30 Minute, 5 Percent, 95 Percent, 1 Milliliter/Minute}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableBlankConflict", "If the Blank option is specified, it must agree with the values specified in the InjectionTable:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				Blank -> {Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]},
				InjectionTable -> {
					{Blank, Model[Sample, StockSolution, "Ion Exchange Buffer A Native"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableBlankFrequencyConflict", "BlankFrequency and InjectionTable may not be specified together:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				BlankFrequency -> FirstAndLast,
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableStandardConflict", "If the Standard option is specified, it must agree with the values specified in the InjectionTable:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				Standard -> {Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]},
				InjectionTable -> {
					{Standard, Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableStandardFrequencyConflict", "StandardFrequency and InjectionTable may not be specified together:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				StandardFrequency -> FirstAndLast,
				InjectionTable -> {
					{Standard, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Standard, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableForeignSamples", "If the InjectionTable is specified, the samples included in it must match the input samples precisely:"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]},
				InjectionTable -> {
					{Standard, Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Standard, Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableColumnGradientConflict", "If the InjectionTable option is specified, only one ColumnFlush and one ColumnPrime gradient is allowed:"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID]},
				InjectionTable -> {
					{ColumnPrime, Null, Automatic, Null, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID]},
					{Blank, Model[Sample, StockSolution, "Ion Exchange Buffer A Native"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{ColumnFlush, Null, Automatic, Null, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID]},
					{ColumnPrime, Null, Automatic, Null, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method2" <> $SessionUUID]},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID], Automatic, 10 Microliter, Automatic},
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{ColumnFlush, Null, Automatic, Null, Object[Method, Gradient, "ValidExperimentFPLCQ Test Method2" <> $SessionUUID]}
				}
			],
			False
		],
		Example[{Messages, "InvalidFractionCollectionEndTime", "FractionCollectionEndTime may not be longer than the duration of the gradient:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], FractionCollectionEndTime -> 2 Hour, GradientDuration -> 1 Hour, GradientStart -> 5 Percent, GradientEnd -> 95 Percent],
			False
		],
		Example[{Messages, "ConflictFractionOptionSpecification", "If CollectFractions -> False and other fraction collection options are specified, a warning is thrown:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], CollectFractions -> False, FractionCollectionStartTime -> 5 Minute],
			True
		],
		Example[{Messages, "IncompatibleColumnTechnique", "Non-FPLC columns cannot be specified:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Column -> Model[Item, Column, "Acquity UPLC Symmetry C18 Trap Column, 150 mm, for micro-flow"]],
			False
		],
		Example[{Messages, "InvalidFractionCollectionTemperature", "If the FractionCollectionTemperature cannot be set to the specified value for the provided instrument, an error is thrown:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"], FractionCollectionTemperature -> 6 Celsius],
			False
		],
		Example[{Messages, "InvalidSampleTemperature", "If the SampleTemperature cannot be set to the specified value for the provided InjectionVolume, an error is thrown:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID], InjectionVolume -> 1 Liter, SampleTemperature -> 6 Celsius],
			False
		],
		Example[{Messages, "FlowRateAboveMax", "If the specified FlowRate is above the allowed value for the provided Column, an error is thrown:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], FlowRate -> 25 Milliliter/Minute, Column -> Model[Item, Column, "HiTrap Q HP 5x5mL Column"]],
			False
		],
		Example[{Messages, "InstrumentDoesNotContainDetector", "The specified detectors must be available on the specified instrument:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"], Detector -> {Absorbance, Pressure, Temperature, pH, Conductance}],
			False
		],
		Example[{Messages, "FPLCTooManySamples", "If too many samples were specified to perform in one experiment (including blanks and standards), throw an error:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID]}, InjectionVolume -> 10 Microliter, NumberOfReplicates -> 50, Aliquot -> True, ConsolidateAliquots -> False],
			False
		],
		Example[{Messages, "FPLCTooManySamples", "If too many samples were specified to perform in one experiment (including blanks and standards), throw an error:"},
			ValidExperimentFPLCQ[
				{
					Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID],
					Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 2" <> $SessionUUID],
					Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 3" <> $SessionUUID],
					Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 4" <> $SessionUUID],
					Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 5" <> $SessionUUID]
				},
				InjectionVolume -> {900 Milliliter, 12 Milliliter, 2 Liter, 2 Liter, 2 Liter},
				Blank -> {
					Model[Sample, "Milli-Q water"]
				},
				BlankInjectionVolume -> 100 Milliliter,
				Aliquot -> False
			],
			False
		],
		Example[{Messages, "FPLCTooManySamples", "If one of the samples/blanks/standards is injecting too much volume to use on the autosampler, the maximum number of samples is only 5:"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID]},
				Blank -> {
					Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
					Model[Sample, StockSolution, "Ion Exchange Buffer B Native"],
					Model[Sample, "Milli-Q water"]
				},
				Standard -> {
					Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
					Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]
				},
				InjectionVolume -> 500 Milliliter,
				StandardInjectionVolume -> 5 Milliliter,
				BlankInjectionVolume -> 5 Milliliter
			],
			False
		],
		Example[{Messages, "TooManyWavelengths", "If more wavelengths are specified than are supported by the instrument, an error is thrown:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID]}, Wavelength -> {280 Nanometer, 260 Nanometer, 215 Nanometer, 430 Nanometer}],
			False
		],
		Example[{Messages, "UnsupportedWavelength", "If using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], only 280 Nanometer or 254 Nanometer are supported:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]}, Wavelength -> 260 Nanometer, Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			False
		],
		Example[{Messages, "FractionVolumeAboveMax", "If using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], MaxFractionVolume cannot be greater than 2 Milliliter:"},
			ValidExperimentFPLCQ[{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]}, MaxFractionVolume -> 5 Milliliter, Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			False
		],
		Example[{Messages, "TooManyBuffers", "At most four different BufferAs and four different BufferBs may be specified, including Standards/Blanks/ColumnPrime/ColumnFlush (if using Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], only one each is allowed):"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID], Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID]},
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"],
				BufferA -> Model[Sample, StockSolution, "Ion Exchange Buffer A Native"],
				BufferB -> Model[Sample, StockSolution, "5M Sodium Chloride"],
				BufferC -> Model[Sample, StockSolution, "Hybridization Buffer"]
			],
			False
		],
		Example[{Messages, "InjectionTableForeignStandards", "If the InjectionTable is specified and its values do not agree with the standard values, an error is thrown:"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]},
				StandardInjectionVolume -> {10 Microliter, 15 Microliter},
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "InjectionTableForeignBlanks", "If the InjectionTable is specified and its values do not agree with the blank values, an error is thrown:"},
			ValidExperimentFPLCQ[
				{Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID]},
				BlankInjectionVolume -> {10 Microliter, 15 Microliter},
				InjectionTable -> {
					{Blank, Model[Sample, "Milli-Q water"], Automatic, 10 Microliter, Automatic},
					{Sample, Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], Automatic, 10 Microliter, Automatic}
				}
			],
			False
		],
		Example[{Messages, "IncompatibleInjectionVolume", "The specified injection volumes must be at or below the maximum allowed injection volume for the provided instrument:"},
			ValidExperimentFPLCQ[
				Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				InjectionVolume -> 5 Milliliter,
				Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]
			],
			False
		],
		Example[{Messages, "ConflictingPeakSlopeOptions", "All or none of the peak fraction collections must be specified together"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], PeakMinimumDuration -> 0.15 Minute, PeakSlope -> 1 Millisiemen/(Centimeter Second), PeakSlopeEnd -> Null],
			False
		],
		Example[{Messages, "ConflictingPeakSlopeOptions", "If specified, the peak fraction options must have compatible units:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], PeakMinimumDuration -> 0.15 Minute, PeakSlope -> 1 Millisiemen/(Centimeter Second), PeakEndThreshold -> 1 MilliAbsorbanceUnit],
			False
		],
		Example[{Messages, "ConflictingFractionCollectionOptions", "Both threshold and peak fraction collection options may not be specified together:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], FractionCollectionMode -> Threshold, PeakSlope -> 1 MilliAbsorbanceUnit/Second],
			False
		],
		Example[{Messages, "ConductivityThresholdNotSupported", "If using non-avant instruments, cannot use conductivity threshold values:"},
			ValidExperimentFPLCQ[Object[Sample, "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID], PeakSlope -> 1 Millisiemen/(Centimeter Second), Instrument -> Model[Instrument, FPLC, "AKTApurifier UPC 10"]],
			False
		]
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate2" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water Sample" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo New Plate" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "A test Parent Protocol for ValidExperimentFPLCQ testing" <> $SessionUUID],
				Object[Qualification, HPLC, "A test Parent Qualification for ValidExperimentFPLCQ testing" <> $SessionUUID],
				Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water BufferA" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water BufferB" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Buffer Bottle A" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Buffer Bottle B" <> $SessionUUID],
				Object[Item, Column, "ValidExperimentFPLCQ Test Column" <> $SessionUUID],
				Object[Method, FractionCollection, "ValidExperimentFPLCQ Test FC Method" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Model-less Oligo" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate for Model-less Samp" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 2" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 3" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 4" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 5" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 6 (incompatible)" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 3" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 4" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 5" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID],
				Object[Protocol, FPLC, "Existing ValidExperimentFPLCQ test protocol" <> $SessionUUID],
				Object[Method, Gradient, "ValidExperimentFPLCQ Test Method2" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Test Containerless Sample" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Test Discarded Sample" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Discarded Container" <> $SessionUUID],
				Object[Container, Bench, "ValidExperimentFPLCQ test bench for tests" <> $SessionUUID],
				Model[Item, Cap, "ValidExperimentFPLCQ test 50 mL Aspiration Cap" <> $SessionUUID],
				Object[Item, Cap, "ValidExperimentFPLCQ Test Aspiration Cap 1" <> $SessionUUID],
				Object[Item, Cap, "ValidExperimentFPLCQ Test Aspiration Cap 2" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		];
		Module[
			{testNewModelID, testPlate, testPlate2, testPlate3, testBufferBottle1, testBufferBottle2, testProtocol,
				testQual, testColumn, testMethod, testFCMethod, waterSample, oligoSample, oligoSample2,
				oligoSampleNewPlate, waterBuffer1, waterBuffer2, modLessSamp, testLargeSampleBottle1, largeVolumeSample,
				testLargeSampleBottle2, largeVolumeSample2, testFPLCProtocol, testMethod2, testDiscardedContainer,
				discardedSample, containerlessSample,testLargeSampleBottle3, testLargeSampleBottle4, testLargeSampleBottle5,
				largeVolumeSample3, largeVolumeSample4, largeVolumeSample5, testLargeSampleBottle6, largeVolumeSample6,
				testBench,testAspirationCap1,testAspirationCap2},

			(* Create an ID for the Model[Container,Vessel] we're gonna make below*)
			testNewModelID = CreateID[Model[Container, Vessel]];

			(* Create some containers *)
			{
				testPlate,
				testPlate2,
				testPlate3,
				testLargeSampleBottle1,
				testLargeSampleBottle2,
				testLargeSampleBottle3,
				testLargeSampleBottle4,
				testLargeSampleBottle5,
				testLargeSampleBottle6,
				testDiscardedContainer,
				testBufferBottle1,
				testBufferBottle2,
				testProtocol,
				testQual,
				testColumn,
				testMethod,
				testMethod2,
				testFCMethod,
				testFPLCProtocol,
				testBench
			} = Upload[{
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "ValidExperimentFPLCQ Test Plate" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "ValidExperimentFPLCQ Test Plate2" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Plate], Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects], Name -> "ValidExperimentFPLCQ Test Plate for Model-less Samp" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 1" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 2" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 3" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 4" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "Amber Glass Bottle 4 L"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 5" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "5L Glass Bottle"], Objects], Name -> "ValidExperimentFPLCQ Test Sample Container 6 (incompatible)" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "HPLC vial (high recovery)"], Objects], Name -> "ValidExperimentFPLCQ Test Discarded Container" <> $SessionUUID, Status -> Discarded, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"], Objects], Name -> "ValidExperimentFPLCQ Test Buffer Bottle A" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Container, Vessel], Model -> Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"], Objects], Name -> "ValidExperimentFPLCQ Test Buffer Bottle B" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Protocol, ManualSamplePreparation], Name -> "A test Parent Protocol for ValidExperimentFPLCQ testing" <> $SessionUUID, Status -> Processing, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Qualification, HPLC], Name -> "A test Parent Qualification for ValidExperimentFPLCQ testing" <> $SessionUUID, Status -> Processing, Site->Link[$Site], DeveloperObject -> True|>,
				<|Type -> Object[Item, Column], Model -> Link[Model[Item, Column, "HiTrap 5x5mL Desalting Column"], Objects], Name -> "ValidExperimentFPLCQ Test Column" <> $SessionUUID, Status -> Available, Site->Link[$Site], DeveloperObject -> True|>,
				<|
					Type -> Object[Method, Gradient],
					Name -> "ValidExperimentFPLCQ Test Method" <> $SessionUUID,
					GradientStart -> 10Percent,
					GradientEnd -> 100Percent,
					GradientDuration -> 50 * Minute,
					EquilibrationTime -> 10 * Minute,
					Replace[Gradient] -> {
						{0 * Minute, 10 * Percent, 90 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute},
						{50 * Minute, 100 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute}
					},
					FlushTime -> 15 * Minute,
					DeveloperObject -> True,
					BufferA -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferB -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]]
				|>,
				<|
					Type -> Object[Method, Gradient],
					Name -> "ValidExperimentFPLCQ Test Method2" <> $SessionUUID,
					GradientStart -> 5 Percent,
					GradientEnd -> 95 Percent,
					GradientDuration -> 50 * Minute,
					EquilibrationTime -> 10 * Minute,
					Replace[Gradient] -> {
						{0 * Minute, 5 * Percent, 95 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute},
						{50 * Minute, 95 * Percent, 5 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 0 * Percent, 1 * Milliliter / Minute}
					},
					FlushTime -> 15 * Minute,
					DeveloperObject -> True,
					BufferA -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer A Native"]],
					BufferB -> Link[Model[Sample, StockSolution, "Ion Exchange Buffer B Native"]]
				|>,
				<|
					Type -> Object[Method, FractionCollection],
					Name -> "ValidExperimentFPLCQ Test FC Method" <> $SessionUUID,
					FractionCollectionMode -> Threshold,
					AbsoluteThreshold -> 500 * Milli * AbsorbanceUnit,
					FractionCollectionStartTime -> 5. * Minute,
					FractionCollectionEndTime -> 40. * Minute,
					MaxCollectionPeriod -> 1.8 * Minute,
					PeakSlope -> Null,
					DeveloperObject -> True,
					FractionCollectionTemperature -> 8 Celsius
				|>,
				<|
					Type -> Object[Protocol, FPLC],
					Name -> "Existing ValidExperimentFPLCQ test protocol" <> $SessionUUID,
					Status -> Completed,
					DeveloperObject -> True
				|>,
				<|Type -> Object[Container, Bench], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects], Name -> "ValidExperimentFPLCQ test bench for tests" <> $SessionUUID, Site->Link[$Site], DeveloperObject -> True, StorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]]|>
			}];

			(* Create some samples *)
			{
				waterSample,
				oligoSample,
				oligoSample2,
				oligoSampleNewPlate,
				waterBuffer1,
				waterBuffer2,
				modLessSamp,
				largeVolumeSample,
				largeVolumeSample2,
				largeVolumeSample3,
				largeVolumeSample4,
				largeVolumeSample5,
				largeVolumeSample6,
				discardedSample,
				containerlessSample,
				testAspirationCap1,
				testAspirationCap2
			} = UploadSample[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Sample, "id:rea9jl1X4N3b"],
					Model[Item, Cap, "50mL Tube Aspiration Cap"],
					Model[Item, Cap, "50mL Tube Aspiration Cap"]
				},
				{
					{"A1", testPlate},
					{"B1", testPlate},
					{"B2", testPlate},
					{"B1", testPlate2},
					{"A1", testBufferBottle1},
					{"A1", testBufferBottle2},
					{"C3", testPlate3},
					{"A1", testLargeSampleBottle1},
					{"A1", testLargeSampleBottle2},
					{"A1", testLargeSampleBottle3},
					{"A1", testLargeSampleBottle4},
					{"A1", testLargeSampleBottle5},
					{"A1", testLargeSampleBottle6},
					{"A1", testDiscardedContainer},
					{"A1", testDiscardedContainer},
					{"Work Surface", testBench},
					{"Work Surface", testBench}
				},
				InitialAmount -> {
					1.75 Milliliter,
					1.75 Milliliter,
					1.75 Milliliter,
					1.75 Milliliter,
					3.5 Liter,
					3.5 Liter,
					1.5 Milliliter,
					1 Liter,
					15 Milliliter,
					3 Liter,
					3 Liter,
					3 Liter,
					3 Liter,
					0.5 Milliliter,
					0.5 Milliliter,
					Null,
					Null
				},
				StorageCondition -> Refrigerator,
				FastTrack -> True
			];

			(* Secondary uploads *)
			Upload[{
				<|Object -> waterSample, Name -> "ValidExperimentFPLCQ Test Water Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSample, Name -> "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID, Status -> Available, DeveloperObject -> True, Replace[Composition] -> {{10 Micromolar, Link[Model[Molecule, Oligomer, "id:O81aEBZnjv6D"]], Now}}|>,
				<|Object -> oligoSample2, Name -> "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> oligoSampleNewPlate, Name -> "ValidExperimentFPLCQ Test Oligo New Plate" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterBuffer1, Name -> "ValidExperimentFPLCQ Test Water BufferA" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> waterBuffer2, Name -> "ValidExperimentFPLCQ Test Water BufferB" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> modLessSamp, Name -> "ValidExperimentFPLCQ Model-less Oligo" <> $SessionUUID, Model -> Null, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample2, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample 2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample3, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample 3" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample4, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample 4" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample5, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample 5" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> largeVolumeSample6, Name -> "ValidExperimentFPLCQ Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> containerlessSample, Name -> "ValidExperimentFPLCQ Test Containerless Sample" <> $SessionUUID, Container -> Null, DeveloperObject -> True|>,
				<|Object -> discardedSample, Name -> "ValidExperimentFPLCQ Test Discarded Sample" <> $SessionUUID, Status -> Discarded, DeveloperObject -> True|>,
				<|Object -> testAspirationCap1, Name -> "ValidExperimentFPLCQ Test Aspiration Cap 1" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				<|Object -> testAspirationCap2, Name -> "ValidExperimentFPLCQ Test Aspiration Cap 2" <> $SessionUUID, Status -> Available, DeveloperObject -> True|>,
				(*add the aspiration cap model to the container for the 50 mL tubes*)
				<|Object -> Model[Container, Vessel, "50mL Tube"]|>
			}];

		];
	),
	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects = {
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate2" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water Sample" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo2" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Oligo New Plate" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "A test Parent Protocol for ValidExperimentFPLCQ testing" <> $SessionUUID],
				Object[Qualification, HPLC, "A test Parent Qualification for ValidExperimentFPLCQ testing" <> $SessionUUID],
				Object[Method, Gradient, "ValidExperimentFPLCQ Test Method" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water BufferA" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Test Water BufferB" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Buffer Bottle A" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Buffer Bottle B" <> $SessionUUID],
				Object[Item, Column, "ValidExperimentFPLCQ Test Column" <> $SessionUUID],
				Object[Method, FractionCollection, "ValidExperimentFPLCQ Test FC Method" <> $SessionUUID],
				Object[Sample,  "ValidExperimentFPLCQ Model-less Oligo" <> $SessionUUID],
				Object[Container, Plate, "ValidExperimentFPLCQ Test Plate for Model-less Samp" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 1" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 2" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 3" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 4" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 5" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Sample Container 6 (incompatible)" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 2" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 3" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 4" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 5" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Large-Volume Protein Sample 6 (in incompatible container)" <> $SessionUUID],
				Object[Protocol, FPLC, "Existing ValidExperimentFPLCQ test protocol" <> $SessionUUID],
				Object[Method, Gradient, "ValidExperimentFPLCQ Test Method2" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Test Containerless Sample" <> $SessionUUID],
				Object[Sample, "ValidExperimentFPLCQ Test Discarded Sample" <> $SessionUUID],
				Object[Container, Vessel, "ValidExperimentFPLCQ Test Discarded Container" <> $SessionUUID],
				Object[Container, Bench, "ValidExperimentFPLCQ test bench for tests" <> $SessionUUID],
				Model[Item, Cap, "ValidExperimentFPLCQ test 50 mL Aspiration Cap" <> $SessionUUID],
				Object[Item, Cap, "ValidExperimentFPLCQ Test Aspiration Cap 1" <> $SessionUUID],
				Object[Item, Cap, "ValidExperimentFPLCQ Test Aspiration Cap 2" <> $SessionUUID]
			};

			EraseObject[
				PickList[namedObjects, DatabaseMemberQ[namedObjects]],
				Force -> True,
				Verbose -> False
			]
		]
	)
];


(* ::Section:: *)
(*End Test Package*)
