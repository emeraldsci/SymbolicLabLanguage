(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCrossFlowFiltration*)


DefineTests[PlotCrossFlowFiltration,
	{
		Example[
			{Basic,"Plot the results of an ExperimentCrossFlowFiltration using a protocol object as input:"},
			PlotCrossFlowFiltration[Object[Protocol,CrossFlowFiltration,"Test KR2i Protocol Object For PlotCFF " <> $SessionUUID]],
			TabView[
				{
					"ConcentrationDiafiltration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@(ToString/@(List@@CrossFlowPlotTypeP))]
				}
			]
		],
		
		Example[
			{Basic,"Plot the results of an ExperimentCrossFlowFiltration using a data object as input:"},
			PlotCrossFlowFiltration[Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID]],
			TabView[
				{
					"ConcentrationDiafiltration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@(ToString/@(List@@CrossFlowPlotTypeP))]
				}
			]
		],

		Example[
			{Basic,"Plot the results of an ExperimentCrossFlowFiltration using a list of data objects as input:"},
			PlotCrossFlowFiltration[{Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID]}],
			{TabView[
				{
					"ConcentrationDiafiltration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@(ToString/@(List@@CrossFlowPlotTypeP))]
				}
			]}
		],
		Example[
			{Additional,"Plot the results of an ExperimentCrossFlowFiltration using a data object as input for uPulse:"},
			PlotCrossFlowFiltration[Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID]],
			TabView[
				{
					"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
				}
			]
		],

		Example[
			{Additional,"Plot the results of an ExperimentCrossFlowFiltration using a list of data objects as input:"},
			PlotCrossFlowFiltration[{
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 2 " <> $SessionUUID]}],
			{
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				],
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				]
			}
		],
		Example[
			{Additional,"Plot the results of an ExperimentCrossFlowFiltration using a protocol with multiple data as the input for uPulse:"},
			PlotCrossFlowFiltration[Object[Protocol,CrossFlowFiltration,"Test uPulse Protocol Object For PlotCFF " <> $SessionUUID]],
			{
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				],
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				]
			}
		],
		Test[
			"Plot the results of an ExperimentCrossFlowFiltration with missing data fields:",
			PlotCrossFlowFiltration[Object[Data,CrossFlowFiltration,"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID]],
			TabView[
				{
					"ConcentrationDiafiltration"->TabView[
						{
 							"Conductivity"->"No data available",
							"Weight"->"No data available",
							"Pressure"->"No data available",
							"Temperature"->Column[{_,_?ValidGraphicsQ},__],
							"FlowRate"->"No data available"
						}
					]
				}
			]
		],
		

		
		Example[
			{Options,"PlottedMeasurementTypes","Specify which types of data collected during the experiment is plotted:"},
			PlotCrossFlowFiltration[
				Object[Protocol,CrossFlowFiltration,"Test KR2i Protocol Object For PlotCFF " <> $SessionUUID],
				PlottedMeasurementTypes->{Absorbance,Conductivity}
			],
			TabView[
				{
					"ConcentrationDiafiltration"->TabView[{"Absorbance"->Column[{_,_?ValidGraphicsQ},__],"Conductivity"->Column[{_,_?ValidGraphicsQ},__]}]
				}
			]
		],
		Example[
			{Options,Cache,"Specify packets of information for the plotting:"},
			PlotCrossFlowFiltration[
				Object[Protocol, CrossFlowFiltration, "Test uPulse Protocol Object For PlotCFF " <> $SessionUUID],
				Cache -> ToList[
					Download[
						Object[Protocol, CrossFlowFiltration, "Test uPulse Protocol Object For PlotCFF " <> $SessionUUID],
						Packet[All]
					]
				]
			],
			{
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				],
				TabView[
					{
						"ConcentrationDiafiltrationConcentration"->TabView[#->HoldPattern[Column[{_,_?ValidGraphicsQ},__]]&/@({"Weight","Pressure"})]
					}
				]
			}
		],
		Test[
			"Previews generate slides:",
			PlotCrossFlowFiltration[Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID],Output->Preview],
			SlideView[ConstantArray[HoldPattern[Column[{_,_?ValidGraphicsQ},__]],4]]
		],
		
		Test[
			"Previews can handle missing data:",
			PlotCrossFlowFiltration[Object[Data,CrossFlowFiltration,"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID],Output->Preview],
			SlideView[ConstantArray[HoldPattern[Column[{_,_?ValidGraphicsQ},__]],1]]
		],

		Example[
			{Messages,"PlotCrossFlowObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
			PlotCrossFlowFiltration[
				Object[Protocol,CrossFlowFiltration,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotCrossFlowObjectNotFound
		],
	
		Example[
			{Messages,"PlotCrossFlowObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
			PlotCrossFlowFiltration[
				Object[Data,CrossFlowFiltration,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotCrossFlowObjectNotFound
		],
	
		Example[
			{Messages,"PlotCrossFlowNoAssociatedObject","An error will be shown if the specified protocol object is not associated with a data object:"},
			PlotCrossFlowFiltration[
				Object[Protocol,CrossFlowFiltration,"Cross Flow Protocol Without Data" <> $SessionUUID]
			],
			$Failed,
			Messages:>Error::PlotCrossFlowNoAssociatedObject
		]
	},
	
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter},
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};
			
			(* Test objects we will create *)
			namedObjects={
				Object[Protocol,CrossFlowFiltration,"Cross Flow Protocol Without Data" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data Without Protocol" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow KR2i Protocol With Only Temp Data" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data With Mixed Missing Data KR2i " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow KR2i Protocol With Mixed Missing Data" <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Test KR2i Protocol Object For PlotCFF " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Test uPulse Protocol Object For PlotCFF " <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 2 " <> $SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];


			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Object[Protocol,CrossFlowFiltration],
						Name->"Cross Flow Protocol Without Data" <> $SessionUUID,
						Replace[FiltrationModes]->ConcentrationDiafiltration,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,CrossFlowFiltration],
						Name->"Cross Flow Data Without Protocol" <> $SessionUUID,
						DeveloperObject->True,
						Replace[FiltrationMode]->ConcentrationDiafiltration
					|>,
					<|
						Type -> Object[Data, CrossFlowFiltration],
						Name -> "Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID,
						Protocol -> Link[Object[Protocol, CrossFlowFiltration, "id:P5ZnEjd3MNxL"], Data],
						Replace[FiltrationMode] -> {ConcentrationDiafiltration},
						Replace[InletPressureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.05}, {0.48333333333333334, 1.45}, {1., 0.25}, {1.5166666666666666, -0.04}, {2., 1.47}, {2.5, 1.68}, {3.0166666666666666, 2.6}, {3.5, 3.24}, {4., 4.35}, {4.5, 4.32}}, {"Minutes", "PoundsForce"/"Inches"^2}, {{1}, {2}}}]]
						},
						Replace[PermeateAbsorbanceData]->{
							{
								QuantityArray[StructuredArray`StructuredData[{10, 3}, {{{0.25, 350, 0.004930660594}, {0.25, 349, 0.004438700154}, {0.25, 348, 0.003975039348}, {0.25, 347, 0.004626772832}, {0.25, 346, 0.004319777712}, {0.25, 345, 0.004158233292}, {0.25, 344, 0.004033613484}, {0.25, 343, 0.003662526142}, {0.25, 342, 0.004356015939}, {0.25, 341, 0.004244722426}}, {"Minutes", "Nanometers", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]],
								QuantityArray[StructuredArray`StructuredData[{10, 3}, {{{0.5, 350, 0.00519289542}, {0.5, 349, 0.004880263936}, {0.5, 348, 0.004311332945}, {0.5, 347, 0.004656312056}, {0.5, 346, 0.004536362365}, {0.5, 345, 0.004350106698}, {0.5, 344, 0.00418902142}, {0.5, 343, 0.004539527465}, {0.5, 342, 0.005053023808}, {0.5, 341, 0.004682634957}}, {"Minutes", "Nanometers", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]],
								QuantityArray[StructuredArray`StructuredData[{10, 3}, {{{0.75, 350, 0.005489603151}, {0.75, 349, 0.004869949538}, {0.75, 348, 0.004162074998}, {0.75, 347, 0.005124787334}, {0.75, 346, 0.004313162994}, {0.75, 345, 0.004850290716}, {0.75, 344, 0.004273896106}, {0.75, 343, 0.004453397822}, {0.75, 342, 0.005154517945}, {0.75, 341, 0.004409018904}}, {"Minutes", "Nanometers", IndependentUnit["ArbitraryUnits"]}, {{1}, {2}}}]]
							}
						},
						Replace[PermeateConductivityData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.}, {0.48333333333333334, 0.}, {1., 0.}, {1.5166666666666666, 0.}, {2., 3.}, {2.5, 6.}, {3.0166666666666666, 9.}, {3.5, 6.}, {4., 3.}, {4.5, 0.}}, {"Minutes", "Millisiemens"/"Centimeters"}, {{1}, {2}}}]]
						},
						Replace[PermeatePressureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., -0.01}, {0.48333333333333334, 0.}, {1., 0.}, {1.5166666666666666, -0.01}, {2., -0.01}, {2.5, -0.01}, {3.0166666666666666, -0.35}, {3.5, -0.32}, {4., -0.28}, {4.5, -0.27}}, {"Minutes", "PoundsForce"/"Inches"^2}, {{1}, {2}}}]]
						},
						Replace[PermeateWeightData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.2}, {0.48333333333333334, 0.2}, {1., 0.2}, {1.5166666666666666, 0.2}, {2., 0.2}, {2.5, 0.2}, {3.0166666666666666, 13.4}, {3.5, 47.2}, {4., 105.4}, {4.5, 166.1}}, {"Minutes", "Grams"}, {{1}, {2}}}]]
						},
						Replace[PrimaryPumpFlowRateData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 100.}, {0.48333333333333334, 100.}, {1., 0.}, {1.5166666666666666, 0.}, {2., 100.}, {2.5, 110.}, {3.0166666666666666, 110.}, {3.5, 110.}, {4., 110.}, {4.5, 110.}}, {"Minutes", "Milliliters"/"Minutes"}, {{1}, {2}}}]]
						},
						Replace[RetentateConductivityData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.}, {0.48333333333333334, 0.}, {1., 5.}, {1.5166666666666666, 0.}, {2., 10.}, {2.5, 15.}, {3.0166666666666666, 10.}, {3.5, 5.}, {4., 0.}, {4.5, 0.}}, {"Minutes", "Millisiemens"/"Centimeters"}, {{1}, {2}}}]]
						},
						Replace[RetentatePressureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.01}, {0.48333333333333334, 1.}, {1., -0.11}, {1.5166666666666666, -0.4}, {2., 1.02}, {2.5, 1.22}, {3.0166666666666666, 2.13}, {3.5, 2.77}, {4., 3.88}, {4.5, 3.85}}, {"Minutes", "PoundsForce"/"Inches"^2}, {{1}, {2}}}]]
						},
						Replace[RetentateWeightData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 638.4}, {0.48333333333333334, 625.2}, {1., 625.1}, {1.5166666666666666, 625.1}, {2., 624.5}, {2.5, 624.5}, {3.0166666666666666, 609.1}, {3.5, 575.1}, {4., 516.7}, {4.5, 455.7}}, {"Minutes", "Grams"}, {{1}, {2}}}]]
						},
						Replace[SecondaryPumpFlowRateData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.}, {0.48333333333333334, 0.}, {1., 0.}, {1.5166666666666666, 0.}, {2., 0.}, {2.5, 0.}, {3.0166666666666666, 0.}, {3.5, 0.}, {4., 0.}, {4.5, 0.}}, {"Minutes", "Milliliters"/"Minutes"}, {{1}, {2}}}]]
						},
						Replace[TemperatureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 24.}, {0.48333333333333334, 24.}, {1., 24.}, {1.5166666666666666, 24.}, {2., 23.9}, {2.5, 23.9}, {3.0166666666666666, 23.9}, {3.5, 23.9}, {4., 23.9}, {4.5, 23.8}}, {"Minutes", "DegreesCelsius"}, {{1}, {2}}}]]
						},
						Replace[TransmembranePressureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 0.04}, {0.48333333333333334, 1.225}, {1., 0.07}, {1.5166666666666666, -0.21}, {2., 1.2550000000000001}, {2.5, 1.46}, {3.0166666666666666, 2.7150000000000003}, {3.5, 3.3249999999999997}, {4., 4.3950000000000005}, {4.5, 4.355}}, {"Minutes", "PoundsForce"/"Inches"^2}, {{1}, {2}}}]]
						},
						DeveloperObject -> True
					|>,
					<|
						Type->Object[Data,CrossFlowFiltration],
						Name->"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID,
						Replace[FiltrationMode]->ConcentrationDiafiltration,
						Replace[InletPressureData]->Null,
						Replace[RetentatePressureData]->Null,
						Replace[PermeatePressureData]->Null,
						Replace[TransmembranePressureData]->Null,
						Replace[RetentateWeightData]->Null,
						Replace[PermeateWeightData]->Null,
						Replace[PrimaryPumpFlowRateData]->Null,
						Replace[SecondaryPumpFlowRateData]->Null,
						Replace[RetentateConductivityData]->Null,
						Replace[PermeateConductivityData]->Null,
						Replace[TemperatureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 24.}, {0.48333333333333334, 24.}, {1., 24.}, {1.5166666666666666, 24.}, {2., 23.9}, {2.5, 23.9}, {3.0166666666666666, 23.9}, {3.5, 23.9}, {4., 23.9}, {4.5, 23.8}}, {"Minutes", "DegreesCelsius"}, {{1}, {2}}}]]
						},
						Replace[RetentateAbsorbanceData]->Null,
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,CrossFlowFiltration],
						Name->"Cross Flow Data With Mixed Missing Data KR2i " <> $SessionUUID,
						Replace[FiltrationMode]->ConcentrationDiafiltration,
						Replace[InletPressureData]->Null,
						Replace[RetentatePressureData]->Null,
						Replace[PermeatePressureData]->Null,
						Replace[TransmembranePressureData]->Null,
						Replace[RetentateWeightData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 638.4}, {0.48333333333333334, 625.2}, {1., 625.1}, {1.5166666666666666, 625.1}, {2., 624.5}, {2.5, 624.5}, {3.0166666666666666, 609.1}, {3.5, 575.1}, {4., 516.7}, {4.5, 455.7}}, {"Minutes", "Grams"}, {{1}, {2}}}]]
						},
						Replace[PermeateWeightData]->Null,
						Replace[PrimaryPumpFlowRateData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 100.}, {0.48333333333333334, 100.}, {1., 0.}, {1.5166666666666666, 0.}, {2., 100.}, {2.5, 110.}, {3.0166666666666666, 110.}, {3.5, 110.}, {4., 110.}, {4.5, 110.}}, {"Minutes", "Milliliters"/"Minutes"}, {{1}, {2}}}]]
						},
						Replace[SecondaryPumpFlowRateData]->Null,
						Replace[RetentateConductivityData]->Null,
						Replace[PermeateConductivityData]->Null,
						Replace[TemperatureData]->{
							QuantityArray[StructuredArray`StructuredData[{10, 2}, {{{0., 24.}, {0.48333333333333334, 24.}, {1., 24.}, {1.5166666666666666, 24.}, {2., 23.9}, {2.5, 23.9}, {3.0166666666666666, 23.9}, {3.5, 23.9}, {4., 23.9}, {4.5, 23.8}}, {"Minutes", "DegreesCelsius"}, {{1}, {2}}}]]
						},
						Replace[RetentateAbsorbanceData]->Null,
						DeveloperObject->True
					|>,
					<|
						Type -> Object[Data, CrossFlowFiltration],
						Name->"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID,
						Replace[FiltrationMode] -> ConcentrationDiafiltrationConcentration,
						Replace[InletPressureData]->QuantityArray[
							{
								{0, -12.87},
								{10, -12.87},
								{20, -12.87},
								{30, -12.87},
								{40, -12.87},
								{50, -12.87},
								{60, -12.87},
								{70, -12.87},
								{80, -12.87}
							},
							{Second, PSI}
						],
						Replace[RetentatePressureData]->QuantityArray[
							{
								{0, 45.88},
								{10, 45.88},
								{20, 45.88},
								{30, 45.88},
								{40, 45.88},
								{50, 45.88},
								{60, 45.88},
								{70, 45.88},
								{80, 45.88}
							},
							{Second, PSI}
						],
						Replace[PermeatePressureData]->QuantityArray[
							{
								{0, 7.07},
								{10, 6.07},
								{20, 5.07},
								{30, 5.07},
								{40, 3},
								{50, 2},
								{60, 1},
								{70, 0.5},
								{80, 0.1}
							},
							{Second, PSI}
						],
						Replace[TransmembranePressureData]->QuantityArray[
							{
								{0, 7.07},
								{10, 6.07},
								{20, 5.07},
								{30, 5.07},
								{40, 3},
								{50, 2},
								{60, 1},
								{70, 0.5},
								{80, 0.1}
							},
							{Second, PSI}
						],
						Replace[RetentateWeightData]->QuantityArray[
							{
								{0, 40},
								{10, 35},
								{20, 30},
								{30, 25},
								{40, 20},
								{50, 15},
								{60, 10},
								{70, 5},
								{80, 0}
							},
							{Second, Gram}
						],
						Replace[DiafiltrationWeightData]->QuantityArray[
							{
								{0, 20},
								{10, 20},
								{20, 20},
								{30, 15},
								{40, 10},
								{50, 10},
								{60, 5},
								{70, 5},
								{80, 0}
							},
							{Second, Gram}
						],
						Replace[FiltrationCycleLog]->{
							{Quantity[0., "Seconds"], "Setup", "Start"},
							{Quantity[0.04999999999999999, "Seconds"], "Preparing", "Start"},
							{Quantity[0.06, "Seconds"], "Priming", "Preparing"},
							{Quantity[0.06, "Seconds"], "Priming", "Pressurizing"},
							{Quantity[15.190000000000001, "Seconds"], "Priming", "InProgress"},
							{Quantity[29.42, "Seconds"], "Priming", "Pressurized"},
							{Quantity[29.42, "Seconds"], "Priming", "Start"},
							{Quantity[36.46, "Seconds"], "Priming", "Complete"},
							{Quantity[36.480000000000004, "Seconds"], "Concentrate", "Start"},
							{
								Quantity[36.480000000000004, "Seconds"],
								"Concentrate",
								"Pressurizing"
							},
							{
								Quantity[37.84, "Seconds"],
								"Concentrate",
								"Pressurized"
							},
							{Quantity[52.84, "Seconds"], "Concentrate", "InProgress"},
							{Quantity[60, "Seconds"], "Concentrate", "Complete"},
							{Quantity[70, "Seconds"], "Diafiltration", "Start"},
							{
								Quantity[70, "Seconds"],
								"Diafiltration",
								"Pressurizing"
							},
							{Quantity[70, "Seconds"], "Diafiltration", "Pressurized"},
							{Quantity[71, "Seconds"], "Diafiltration", "InProgress"},
							{Quantity[80, "Seconds"], "Diafiltration", "Complete"},
							{Quantity[80, "Seconds"], "Concentrate", "Preparing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Preparing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Pressurizing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Pressurized"},
							{Quantity[100, "Seconds"], "AirRecovery", "Start"},
							{Quantity[100, "Seconds"], "AirRecovery", "InProgress"},
							{Quantity[110, "Seconds"], "AirRecovery", "Complete"},
							{Quantity[110, "Seconds"], "AirRecovery", "Continue"},
							{Quantity[120, "Seconds"], "Setup", "Complete"}
						},
						Instrument -> Link[Object[Instrument, CrossFlowFiltration, "Tau Cross"]],
						SampleType -> Sample,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Data, CrossFlowFiltration],
						Name->"PlotCrossFlowFiltration Test uPulse Data 2 " <> $SessionUUID,
						Replace[FiltrationMode] -> ConcentrationDiafiltrationConcentration,
						Replace[InletPressureData]->QuantityArray[
							{
								{0, -12.87},
								{10, -12.87},
								{20, -12.87},
								{30, -12.87},
								{40, -12.87},
								{50, -12.87},
								{60, -12.87},
								{70, -12.87},
								{80, -12.87}
							},
							{Second, PSI}
						],
						Replace[RetentatePressureData]->QuantityArray[
							{
								{0, 45.88},
								{10, 45.88},
								{20, 45.88},
								{30, 45.88},
								{40, 45.88},
								{50, 45.88},
								{60, 45.88},
								{70, 45.88},
								{80, 45.88}
							},
							{Second, PSI}
						],
						Replace[PermeatePressureData]->QuantityArray[
							{
								{0, 7.07},
								{10, 6.07},
								{20, 5.07},
								{30, 5.07},
								{40, 3},
								{50, 2},
								{60, 1},
								{70, 0.5},
								{80, 0.1}
							},
							{Second, PSI}
						],
						Replace[TransmembranePressureData]->QuantityArray[
							{
								{0, 7.07},
								{10, 6.07},
								{20, 5.07},
								{30, 5.07},
								{40, 3},
								{50, 2},
								{60, 1},
								{70, 0.5},
								{80, 0.1}
							},
							{Second, PSI}
						],
						Replace[RetentateWeightData]->QuantityArray[
							{
								{0, 40},
								{10, 35},
								{20, 30},
								{30, 25},
								{40, 20},
								{50, 15},
								{60, 10},
								{70, 5},
								{80, 0}
							},
							{Second, Gram}
						],
						Replace[DiafiltrationWeightData]->QuantityArray[
							{
								{0, 20},
								{10, 20},
								{20, 20},
								{30, 15},
								{40, 10},
								{50, 10},
								{60, 5},
								{70, 5},
								{80, 0}
							},
							{Second, Gram}
						],
						Replace[FiltrationCycleLog]->{
							{Quantity[0., "Seconds"], "Setup", "Start"},
							{Quantity[0.04999999999999999, "Seconds"], "Preparing", "Start"},
							{Quantity[0.06, "Seconds"], "Priming", "Preparing"},
							{Quantity[0.06, "Seconds"], "Priming", "Pressurizing"},
							{Quantity[15.190000000000001, "Seconds"], "Priming", "InProgress"},
							{Quantity[29.42, "Seconds"], "Priming", "Pressurized"},
							{Quantity[29.42, "Seconds"], "Priming", "Start"},
							{Quantity[36.46, "Seconds"], "Priming", "Complete"},
							{Quantity[36.480000000000004, "Seconds"], "Concentrate", "Start"},
							{
								Quantity[36.480000000000004, "Seconds"],
								"Concentrate",
								"Pressurizing"
							},
							{
								Quantity[37.84, "Seconds"],
								"Concentrate",
								"Pressurized"
							},
							{Quantity[52.84, "Seconds"], "Concentrate", "InProgress"},
							{Quantity[60, "Seconds"], "Concentrate", "Complete"},
							{Quantity[70, "Seconds"], "Diafiltration", "Start"},
							{
								Quantity[70, "Seconds"],
								"Diafiltration",
								"Pressurizing"
							},
							{Quantity[70, "Seconds"], "Diafiltration", "Pressurized"},
							{Quantity[71, "Seconds"], "Diafiltration", "InProgress"},
							{Quantity[80, "Seconds"], "Diafiltration", "Complete"},
							{Quantity[80, "Seconds"], "Concentrate", "Preparing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Preparing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Pressurizing"},
							{Quantity[100, "Seconds"], "AirRecovery", "Pressurized"},
							{Quantity[100, "Seconds"], "AirRecovery", "Start"},
							{Quantity[100, "Seconds"], "AirRecovery", "InProgress"},
							{Quantity[110, "Seconds"], "AirRecovery", "Complete"},
							{Quantity[110, "Seconds"], "AirRecovery", "Continue"},
							{Quantity[120, "Seconds"], "Setup", "Complete"}
						},
						Instrument -> Link[Object[Instrument, CrossFlowFiltration, "Tau Cross"]],
						SampleType -> Sample,
						DeveloperObject -> True
					|>

				}
			];
			
			(* Secondary uploads *)
			Upload[{
				<|
					Type -> Object[Protocol, CrossFlowFiltration],
					AbsorbanceChannel -> Permeate,
					AbsorbanceWavelength -> {Quantity[341, "Nanometers"], Quantity[350, "Nanometers"]},
					Replace[FiltrationModes] -> ConcentrationDiafiltration,
					Replace[Data]->{
						Link[Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID], Protocol]
					},
					DeveloperObject -> True,
					Name -> "Test KR2i Protocol Object For PlotCFF " <> $SessionUUID
				|>,
				<|
					Type -> Object[Protocol, CrossFlowFiltration],
					Replace[FiltrationModes] -> {ConcentrationDiafiltrationConcentration, ConcentrationDiafiltrationConcentration},
					Replace[Data]->{
						Link[Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID], Protocol],
						Link[Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 2 " <> $SessionUUID], Protocol]
					},
					DeveloperObject -> True,
					Name -> "Test uPulse Protocol Object For PlotCFF " <> $SessionUUID
				|>,
				<|
					Type->Object[Protocol,CrossFlowFiltration],
					Name->"Cross Flow KR2i Protocol With Only Temp Data" <> $SessionUUID,
					Replace[Data]->{Link[Object[Data,CrossFlowFiltration,"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID],Protocol]},
					AbsorbanceChannel->Retentate,
					AbsorbanceWavelength->280 Nanometer,
					Replace[FiltrationModes]-> {ConcentrationDiafiltration},
					DeveloperObject->True
				|>,
				<|
					Type->Object[Protocol,CrossFlowFiltration],
					Name->"Cross Flow KR2i Protocol With Mixed Missing Data" <> $SessionUUID,
					Replace[Data]->{Link[Object[Data,CrossFlowFiltration,"Cross Flow Data With Mixed Missing Data KR2i " <> $SessionUUID],Protocol]},
					AbsorbanceChannel->Retentate,
					AbsorbanceWavelength->341 Nanometer,
					Replace[FiltrationModes]-> {ConcentrationDiafiltration},
					DeveloperObject->True
				|>
			}];
		]
	},
	
	SymbolTearDown:>{

		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		
		(* Unset $CreatedObjects *)
		$CreatedObjects=.;

		Module[{namedObjects,existsFilter},

			(* Test objects we will create *)
			namedObjects={
				Object[Protocol,CrossFlowFiltration,"Cross Flow Protocol Without Data" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data Without Protocol" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data With Only Temp Data KR2i " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow KR2i Protocol With Only Temp Data" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Cross Flow Data With Mixed Missing Data KR2i " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Cross Flow KR2i Protocol With Mixed Missing Data" <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Test KR2i Protocol Object For PlotCFF " <> $SessionUUID],
				Object[Protocol,CrossFlowFiltration,"Test uPulse Protocol Object For PlotCFF " <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"Test Data Object For KR2i Cross Flow Data Analysis" <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 1 " <> $SessionUUID],
				Object[Data,CrossFlowFiltration,"PlotCrossFlowFiltration Test uPulse Data 2 " <> $SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

		]
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];
