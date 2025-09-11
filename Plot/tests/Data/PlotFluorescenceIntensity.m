(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceIntensity*)


DefineTests[PlotFluorescenceIntensity,
	{

		Example[{Basic,"Plot a histogram of intensities:"},
			PlotFluorescenceIntensity[objs96a],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Test["Given a packet:",
			PlotFluorescenceIntensity[Download[objs96a]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Plot a histogram of intensities from links:"},
			PlotFluorescenceIntensity[links96a],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Plot data objects linked to a given FluorescenceIntensity protocol object:"},
			PlotFluorescenceIntensity[Object[Data, FluorescenceIntensity, "id:lYq9jRxzlObV"][Protocol]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Compare intensities across datasets using a BoxWhiskerChart:"},
			PlotFluorescenceIntensity[Download/@{objs96a,objs96b,objs96c,objs96d}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],


		(*
			ADDITIONAL
		*)
		Example[{Additional,"Input Type","List of info packets:"},
			PlotFluorescenceIntensity[Download[objs96a]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Basic,"Input Type","Grouped lists of info packets:"},
			PlotFluorescenceIntensity[Download/@{objs96a,objs96b,objs96c,objs96d}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Input Type","List of intensity values:"},
			PlotFluorescenceIntensity[RandomVariate[NormalDistribution[500,10],1000]*RFU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Input Type","Grouped lists of intensity values:"},
			PlotFluorescenceIntensity[Map[RandomVariate[NormalDistribution[#,50],1000]&,{400,500,600}]*RFU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		(*
			QAs
		*)
		Example[{Additional,"Quantity Arrays","QuantityArray of intensities:"},
			PlotFluorescenceIntensity[QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],RFU]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Quantity Arrays","A list of intensity quantity arrays:"},
			PlotFluorescenceIntensity[{QuantityArray[RandomVariate[NormalDistribution[50, 5], 1000],RFU],QuantityArray[RandomVariate[NormalDistribution[40, 8], 1000],RFU]}],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Additional,"Quantity Arrays","Given a QuantityArray containing a single group of intensity data sets:"},
			PlotFluorescenceIntensity[QuantityArray[{RandomVariate[NormalDistribution[50,5],1000],RandomVariate[NormalDistribution[40, 8],1000]},RFU]],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],


		(*
			OPTIONS
		*)
		Example[{Options,DataSet,"Use the intensity data measured at the primary wavelength:"},
			PlotFluorescenceIntensity[objs96f,DataSet->Intensities],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,DataSet,"Use the intensity data measured at the secondary wavelength:"},
			PlotFluorescenceIntensity[objs96f,DataSet->DualEmissionIntensities],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,EmissionWavelength,"Use the intensity data measured at the specified wavelength:"},
			{
				PlotFluorescenceIntensity[multiIntensities,EmissionWavelength->665 Nanometer],
				PlotFluorescenceIntensity[multiIntensities,EmissionWavelength->620 Nanometer]
			},
			{ValidGraphicsP[],ValidGraphicsP[]},
			TimeConstraint -> 120
		],

		Example[{Options,ExcitationWavelength,"Use the intensity data measured at the specified wavelength:"},
			PlotFluorescenceIntensity[multiIntensities,ExcitationWavelength->337 Nanometer],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,PlotType,"A flat list of intensities defaults to a Histogram diplsay:"},
			PlotFluorescenceIntensity[objs96a],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"A flat list of intensities can also be displayed as a BarChart or BoxWhiskerChart:"},
			Grid[{{PlotFluorescenceIntensity[objs96a[[;;24]],PlotType->BarChart],PlotFluorescenceIntensity[objs96a,PlotType->BoxWhiskerChart]}}],
			Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"Grouped lists of intensities defaults to a BoxWhiskerChart diplsay:"},
			PlotFluorescenceIntensity[Download/@(Transpose[Partition[objs96a,12]][[1;;-1;;2]])],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,PlotType,"Grouped lists of intensities can also be displayed as a BarChart or Histogram:"},
			Grid[{{
				PlotFluorescenceIntensity[Transpose[Partition[Download[objs96a],12]][[1;;-1;;2]],PlotType->BarChart],
				PlotFluorescenceIntensity[Map[Flatten,Partition[Transpose[Partition[Download[objs96a],12]],6]],PlotType->Histogram]}}],
			Grid[{{ValidGraphicsP[], ValidGraphicsP[]}}],
			TimeConstraint -> 120
		],


		Example[{Options,TargetUnits,"TargetUnits default to the unit on the data:"},
			PlotFluorescenceIntensity[RandomVariate[NormalDistribution[500000,10000],1000]*Milli*RFU,TargetUnits->Automatic],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit:"},
			PlotFluorescenceIntensity[RandomVariate[NormalDistribution[500000,10000],1000]*Milli*RFU,TargetUnits->RFU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit when given data objects:"},
			PlotFluorescenceIntensity[Download[objs96a[[;;10]]],TargetUnits->Kilo*RFU],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit when given grouped data objects:"},
			PlotFluorescenceIntensity[
				{
					Download[objs96a],
					Download[objs96b],
					Download[objs96c],
					Download[objs96d]
				},
				TargetUnits->Kilo*RFU
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,TargetUnits,"Specify a TargetUnit for a BarChart:"},
			PlotFluorescenceIntensity[objs96a[[;;24]],TargetUnits->Kilo*RFU,PlotType->BarChart],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,Legend,"Create a plot legend:"},
			PlotFluorescenceIntensity[Download/@{objs96a,objs96b,objs96c,objs96d},
				PlotType->Histogram,
				Legend->{"A","B","C","D"}
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,BoxWhiskerType,"Use BoxWhiskerChart options to show additional information, here a mean confidence interval diamond:"},
			PlotFluorescenceIntensity[Download/@{objs96a,objs96b,objs96c,objs96d},
				PlotType->BoxWhiskerChart,
				BoxWhiskerType->"Diamond"
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],

		Example[{Options,ChartLabels,"Label the plot:"},
			PlotFluorescenceIntensity[
				Download/@{objs96a,objs96b,objs96c,objs96d},
				ChartLabels->{"A","B","C","D"}
			],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return a plot when Output->Preview:"},
			PlotFluorescenceIntensity[objs96a, Output->Preview],
			ValidGraphicsP[],
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return a list of resolved options when Output->Options:"},
			Lookup[PlotFluorescenceIntensity[objs96a, Output->Options],Output],
			Options,
			TimeConstraint -> 120
		],
		Example[{Options,Output,"Return an empty list when Output->Tests:"},
			PlotFluorescenceIntensity[objs96a, Output->Tests],
			{},
			TimeConstraint -> 120
		],

		Example[{Messages,"MismatchedWavelengthsAndIntensities","Print a message and returns $Failed if the length of emission wavelengths does not match the length of the recorded intensities:"},
			PlotFluorescenceIntensity[Object[Data, FluorescenceIntensity, "id:dORYzZJnXMnR"]],
			$Failed,
			Messages:>{Error::MismatchedWavelengthsAndIntensities}
		],

		Example[{Messages,"DuplicateWavelengths","Prints a warning and uses the first value if there are multiple readings at the same wavelength:"},
			PlotFluorescenceIntensity[Object[Data, FluorescenceIntensity, "id:AEqRl9K5Dwqw"]],
			ValidGraphicsP[],
			Messages:>{Warning::DuplicateWavelengths}
		],

		Example[{Messages,"NoDataAtWavelength","Print a message and returns $Failed if no data was found at the requested wavelength:"},
			PlotFluorescenceIntensity[multiIntensities,EmissionWavelength->450 Nanometer],
			$Failed,
			Messages:>{Error::NoDataAtWavelength,Error::NoDataAtWavelength,Error::NoDataAtWavelength,General::stop}
		]

	},


	Variables:>{objs8a,objs8b,objs96a,objs96b,objs96c,objs96d,objs96f,links96a,multiIntensities},
	SetUp:>(
		objs8a=Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582253,582277];
		objs8b=Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@Range[57749,57756];
		objs96a = Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582601,582641];
		objs96b = Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582278,582308];
		objs96c = Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582309,582359];
		objs96d = Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582360,582403];
		objs96f = Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582404,582511];
		links96a = Map[Link[#,Protocol]&,Object[Data, FluorescenceIntensity, "LegacyID:" <> ToString[#]] & /@ Range[582601,582641]];
		multiIntensities={
			Object[Data, FluorescenceIntensity, "id:lYq9jRxzlObV"],
			Object[Data, FluorescenceIntensity, "id:L8kPEjnNqO7w"],
			Object[Data, FluorescenceIntensity, "id:E8zoYvNeZOwA"],
			Object[Data, FluorescenceIntensity, "id:Y0lXejMG3rRv"],
			Object[Data, FluorescenceIntensity, "id:kEJ9mqRaz8r3"],
			Object[Data, FluorescenceIntensity, "id:P5ZnEjd4Ax14"],
			Object[Data, FluorescenceIntensity, "id:3em6ZvL9qrVL"],
			Object[Data, FluorescenceIntensity, "id:D8KAEvGd1DaK"]
		};
	)

];
