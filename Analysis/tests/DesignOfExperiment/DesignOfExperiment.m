(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*AnalyzeDesignOfExperiment Tests*)

DefineTests[
    AnalyzeDesignOfExperiment,
    {
    	ObjectTest[
    		{Basic, "Running AnalyzeDesignOfExperiment on a protocol returns an analysis object:"},
    		AnalyzeDesignOfExperiment[hplcProtocol1, ParameterSpace -> {FlowRate}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Basic, "Running AnalyzeDesignOfExperiment on a list of protocols returns an analysis object:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, ParameterSpace -> {FlowRate}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Basic, "Running AnalyzeDesignOfExperiment on a list of protocols and setting the UpdateAnalysis option will update the existing analysis object and return it:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, UpdateAnalysis -> existingAnalysisObject1],
            existingAnalysisObject1,
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        (* ----- Additional tests ----- *)
        ObjectTest[
    		{Additional, "Setting the UpdateAnalysis option will append objective function evaluations to the existing analysis object:"},
            Module[{updatedObject},
        		updatedObject = AnalyzeDesignOfExperiment[hplcProtocol1, UpdateAnalysis -> existingAnalysisObject2];
                Length[Download[updatedObject, ObjectiveValues]]
            ],
    		2,
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Additional, "Running AnalyzeDesignOfExperiment works on an Absorbance Spectroscopy Protocol:"},
            AnalyzeDesignOfExperiment[{myTestAbsProtocolObject}, ParameterSpace -> {QuantificationWavelength}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Additional, "Running AnalyzeDesignOfExperiment on a protocols with multiple data returns an analysis object:"},
            AnalyzeDesignOfExperiment[{hplcProtocol5}, ParameterSpace -> {FlowRate}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Additional, "Running AnalyzeDesignOfExperiment on a protocols with multiple data on multiple parameters in the parameter space returns an analysis object:"},
            AnalyzeDesignOfExperiment[{hplcProtocol5}, ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Additional, "Running AnalyzeDesignOfExperiment on multiple protocols with multiple data on multiple parameters in the parameter space returns an analysis object:"},
            AnalyzeDesignOfExperiment[{hplcProtocol4, hplcProtocol5}, ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Additional, "Running AnalyzeDesignOfExperiment on multiple protocols with multiple data can update an existing analysis object:"},
            AnalyzeDesignOfExperiment[{hplcProtocol4, hplcProtocol5}, UpdateAnalysis -> existingAnalysisObject3],
    		existingAnalysisObject3,
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        (* ----- Options tests ----- *)
        ObjectTest[
    		{Options, "ParameterSpace", "Setting the ParameterSpace option specifies the independent variables that were used in the design of experiment run:"},
    		AnalyzeDesignOfExperiment[hplcProtocol3, ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Options, "ObjectiveFunction", "Setting the ObjectiveFunction option specifies the scoring function that determines the best experimental parameters used in the design of experiment run:"},
    		AnalyzeDesignOfExperiment[hplcProtocol3, ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak],
    		ObjectReferenceP[Object[Analysis, DesignOfExperiment]],
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Options, "Method", "Setting the Method option specifies the optimization algorithm specified during the design of experiment run:"},
            Module[{packet},
        		packet = AnalyzeDesignOfExperiment[hplcProtocol3, ParameterSpace -> {FlowRate, ColumnTemperature}, ObjectiveFunction -> AreaOfTallestPeak, Method->GridSearch, Upload->False];
                Lookup[packet, Method]
            ],
    		GridSearch,
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        ObjectTest[
    		{Options, "UpdateAnalysis", "The analysis object passed through the UpdateAnalysis option provides a template for all the other options:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, UpdateAnalysis -> existingAnalysisObject1],
            existingAnalysisObject1,
    		TimeConstraint -> 1000,
            CleanupObjects -> False
    	],

        (* ----- Messages tests ----- *)
        Example[
    		{Messages, "NoParameterSpace", "Forgetting to set the ParameterSpace option will result in an error:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, ObjectiveFunction->AreaOfTallestPeak],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::NoParameterSpace]},
            CleanupObjects -> False
    	],

        Example[
    		{Messages, "NoObjectiveFunction", "Forgetting to set the ObjectiveFunction option will result in an error:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, ParameterSpace->{FlowRate}],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::NoObjectiveFunction]},
            CleanupObjects -> False
    	],

        Example[
    		{Messages, "MultipleTypes", "Using protocols with different types will result in a MultipleTypes error:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, nmrProtocol}, ParameterSpace->{FlowRate}, ObjectiveFunction->AreaOfTallestPeak],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::MultipleTypes]},
            CleanupObjects -> False
    	],

        Example[
    		{Messages, "NoOptions", "Calling AnalyzeDesignOfExperiment on a protocol that was generated without explicitly defined options throws an error:"},
    		AnalyzeDesignOfExperiment[noOptionProtocol, ParameterSpace->{FlowRate}, ObjectiveFunction->AreaOfTallestPeak],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::NoOptions]},
            CleanupObjects -> False
    	],

        (* TODO: Remove this test when the LegacySLL integration is complete *)
        Example[
    		{Messages, "UnknownExperiment", "Using an unsupported protocol type in the input will result in an error, sorry:"},
    		AnalyzeDesignOfExperiment[nmrProtocol, ParameterSpace->{Nucleus}, ObjectiveFunction->AreaOfTallestPeak],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::UnknownExperiment]},
            CleanupObjects -> False
    	],

        Example[
    		{Messages, "ParameterNotFound", "Calling AnalyzeDesignOfExperiment on an unknown option/parameter of the input protocol will result in an error:"},
    		AnalyzeDesignOfExperiment[{hplcProtocol1, hplcProtocol2}, ParameterSpace->{taco}, ObjectiveFunction->AreaOfTallestPeak],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::ParameterNotFound]},
            CleanupObjects -> False
    	],

        Example[
    		{Messages, "MismatchedParameterSpace", "Calling AnalyzeDesignOfExperiment with a parameter space that does not match the ParameterSpace of the analysis object to be updated results in an error:"},
    		AnalyzeDesignOfExperiment[hplcProtocol1, ParameterSpace->{ColumnTemperature}, UpdateAnalysis->existingAnalysisObject1],
            $Failed,
    		TimeConstraint -> 1000,
            Messages :> {Message[AnalyzeDesignOfExperiment::MismatchedParameterSpace]},
            CleanupObjects -> False
    	]
    },
    Variables :> {
        hplcProtocol1, hplcProtocol2, hplcProtocol3, existingAnalysisObject1,
        existingAnalysisObject2, noOptionProtocol, nmrProtocol
    },
    SymbolSetUp :> (
        Module[
            {existingAnalysisPacket1, existingAnalysisPacket2, nmrPacket},

            (*
                Creating test objects to work with AnalyzeDesignOfExperiment requires a protocol with (SimulateHPLC does this)
                    -Type/Object
                    -ResolvedOptions
                    -UnresolvedOptions
                    -Append[Data] - Link[Data, Protocol](separate Upload)
                        -Type
                        -DataField
            *)

            (* set the created objects tag *)
            $CreatedObjects = {};

            (* make the test protocols *)
            hplcProtocol = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate->2 Milliliter/Minute];
            hplcProtocol1 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate->1 Milliliter/Minute];
            hplcProtocol2 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate->2 Milliliter/Minute];
            hplcProtocol3 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate->2 Milliliter/Minute, ColumnTemperature->30 Celsius];

            (*Remove resolved options from the protocol*)
            noOptionProtocol = DesignOfExperiment`Private`SimulateHPLC[{cat}];
            Upload[<|Object -> noOptionProtocol, ResolvedOptions -> {}|>];

            (* make the existing analysis objects *)
            existingAnalysisPacket1 = <|
                Type->Object[Analysis,DesignOfExperiment],
    			Method->Custom,
    			ObjectiveFunction->AreaOfTallestPeak,
    			Replace[ParameterSpace]->{FlowRate},
                Replace[ObjectiveValues]->{0` Milli AbsorbanceUnit Minute},
                Replace[ExperimentParameters]->{FlowRate->10` Milliliter/Minute}
            |>;
            existingAnalysisPacket2 = <|
                Type->Object[Analysis,DesignOfExperiment],
    			Method->Custom,
    			ObjectiveFunction->AreaOfTallestPeak,
    			Replace[ParameterSpace]->{FlowRate},
                Replace[ObjectiveValues]->{0` Milli AbsorbanceUnit Minute},
                Replace[ExperimentParameters]->{FlowRate->10` Milliliter/Minute}
            |>;
            existingAnalysisPacket3 = <|
                Type->Object[Analysis,DesignOfExperiment],
    			Method->Custom,
    			ObjectiveFunction->AreaOfTallestPeak,
    			Replace[ParameterSpace]->{FlowRate},
                Replace[ObjectiveValues]->{0` Milli AbsorbanceUnit Minute},
                Replace[ExperimentParameters]->{FlowRate->10` Milliliter/Minute}
            |>;

            (* make empty protocol NMR packet *)
            nmrPacket = <|
                Type -> Object[Protocol,NMR],
                UnresolvedOptions -> {Nucleus->"13C"}
            |>;

            (* upload the packets *)
            {existingAnalysisObject1, existingAnalysisObject2, existingAnalysisObject3, nmrProtocol} = Upload[{existingAnalysisPacket1, existingAnalysisPacket2, existingAnalysisPacket3, nmrPacket}];

            (*Make test protocol with multiple data *)
            (*start with one data*)
            hplcProtocol4 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 2 Milliliter/Minute];
            testData4 = DesignOfExperiment`Private`SimulateHPLCData[Quantity[30, "DegreesCelsius"], Quantity[0.1, "Milliliters"/"Minutes"]];
            (*create another data*)
            chromData4 = Upload[<|
                Type -> Object[Data, Chromatography],
                Replace[ColumnTemperature] -> testData4[ColumnTemperature],
                Replace[FlowRates] -> {testData4[FlowRates]},
                Absorbance -> testData4[Absorbance],
                AbsorbanceWavelength-> 290 Nanometer,
                DeveloperObject -> True
            |>];

            (*Update hplcProtocol4 with that data *)
            Upload[Association[Object -> hplcProtocol4, Append[Data] -> {Link[chromData4, Protocol]}]];

            (*Make another test protocol with multiple data *)
            (*start with one data*)
            hplcProtocol5 = DesignOfExperiment`Private`SimulateHPLC[{cat}, FlowRate -> 1 Milliliter/Minute];
            testData5 = DesignOfExperiment`Private`SimulateHPLCData[Quantity[40, "DegreesCelsius"], Quantity[2, "Milliliters"/"Minutes"]];
            (*create another data*)
            chromData5 = Upload[<|
                Type -> Object[Data, Chromatography],
                Replace[ColumnTemperature] -> testData5[ColumnTemperature],
                Replace[FlowRates] -> {testData5[FlowRates]},
                Absorbance -> testData5[Absorbance],
                AbsorbanceWavelength-> 280 Nanometer,
                DeveloperObject -> True
            |>];

            (*Update hplcProtocol5 with that data and expand the resolved options as index matched *)
            Upload[Association[
                Object -> hplcProtocol5,
                Append[Data] -> {Link[chromData5, Protocol]},
                ResolvedOptions -> {FlowRate -> {2 Milliliter/Minute, 1 Milliliter/Minute}, ColumnTemperature->{30 Celsius, 40 Celsius}}
            ]];

            (* Create a test AbsorbanceSpectroscopy Protocol *)
            (* Create a quantity array for the data object *)
            myAbsSpecData = QuantityArray[
                StructuredArray`StructuredData[{20, 2}, {{{220, 0.03040000000000001}, {221, 0.024899999999999978`}, {222, 0.023799999999999988`}, {223, 0.019799999999999984`},
                {224, 0.015200000000000005`}, {225, 0.013300000000000006`}, {226, 0.011700000000000002`}, {227, 0.0116}, {228, 0.010599999999999998`}, {229, 0.010099999999999998`},
                {230, 0.009300000000000003}, {231, 0.00839999999999999}, {232, 0.008000000000000007}, {233, 0.0068999999999999895`}, {234, 0.006199999999999997}, {235, 0.004500000000000004},
                {236, 0.0030999999999999917`}, {237, 0.0012000000000000066`}, {238, 0.00020000000000000573`}, {239, -0.0003000000000000086}},
                {"Nanometers", IndependentUnit["AbsorbanceUnit"]}, {{1}, {2}}}]];

            (* Create a data object *)
            testAbsorbanceSpectroscopyData = <|
                Type -> Object[Data, AbsorbanceSpectroscopy],
                AbsorbanceSpectrum -> myAbsSpecData
            |>;
            myTestAbsDataObject = Upload[testAbsorbanceSpectroscopyData];

            (* Create the protocol *)
            testAbsorbanceSpectroscopyProtocol = <|
                Type -> Object[Protocol, AbsorbanceSpectroscopy],
                Append[Data] -> Link[myTestAbsDataObject, Protocol],
                ResolvedOptions -> {QuantificationWavelength -> 260 Nanometer},
                UnresolvedOptions -> {QuantificationWavelength -> 260 Nanometer}
            |>;

            myTestAbsProtocolObject = Upload[testAbsorbanceSpectroscopyProtocol]

        ]

    ),
    SymbolTearDown :> (
        (* delete all created objects *)
        EraseObject[$CreatedObjects, Force -> True];
        Unset[$CreatedObjects]
    )
]
