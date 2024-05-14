(* ::Package:: *)

(* ..Package.. *)

(* ..Text.. *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ..Subsection.. *)
(*PlotFluorescenceKinetics*)


DefineTests[PlotFluorescenceKinetics,
	{
		Example[
			{Basic,"Plot the fluorescence trajectory for a given data object:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"]],
			ValidGraphicsP[]
		],
		Example[
			{Basic,"Plot multiple data objects:"},
			PlotFluorescenceKinetics[{Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Object[Data,FluorescenceKinetics,"id:4pO6dMWvG8aX"]}],
			ValidGraphicsP[]
		],
		Example[
			{Basic,"Plot the fluorescence trajectory and temperature trace of the data of interest:"},
			PlotFluorescenceKinetics[Object[Data, FluorescenceKinetics, "id:lYq9jRzX38AY"],SecondaryData->{Temperature}],
			ValidGraphicsP[]
		],
		Example[
			{Basic,"Plot raw data downloaded from an object:"},
			PlotFluorescenceKinetics[Download[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],EmissionTrajectories]],
			ValidGraphicsP[]
		],
		Test["Wavelength options resolve to Null if raw data is provided:",
			Lookup[
				PlotFluorescenceKinetics[Download[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],EmissionTrajectories],Output->Options],
				{ExcitationWavelength,EmissionWavelength,DualEmissionWavelength}
			],
			{Null,Null,Null}
		],
		Example[
			{Options,PrimaryData,"Indicate that the temperature should be plotted on the y-axis:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],PrimaryData->Temperature],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,SecondaryData,"Indicate that temperature should be plotted on the second y-axis:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],SecondaryData->{Temperature}],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Display,"There is no additional display data:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],Display->{}],
			ValidGraphicsP[]
		],
		Example[{Options,Units,"Specify the units to use when plotting the emission trajectory:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],Units->{EmissionTrajectories->{Nanometer,Kilo*RFU}}],
			ValidGraphicsP[]
		],
		Example[
			{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],PlotTheme -> "Marketing"],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Zoomable->False],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,TargetUnits,"Specify units for the XY axes:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],TargetUnits->{Second,RFU}],
			ValidGraphicsP[]
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotFluorescenceKinetics[{Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Object[Data,FluorescenceKinetics,"id:4pO6dMWvG8aX"]},LegendPlacement->Right],
			ValidGraphicsP[]
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],PlotLabel -> "Fluorescence Spectrum"],
			ValidGraphicsP[]
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],FrameLabel -> {"Wavelength", "Recorded Fluorescence", None, None}],
			ValidGraphicsP[]
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotFluorescenceKinetics[
				{Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Object[Data,FluorescenceKinetics,"id:4pO6dMWvG8aX"]},
				Boxes -> True
			],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[
			{Options,Temperature,"Include temperature data on the plot:"},
			Module[{myData,myTemp},
				{myTemp,myData}=Download[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],{Temperature,EmissionTrajectories}];
				PlotFluorescenceKinetics[myData,
					Temperature->myTemp
				]
			],
			_DynamicModule
		],
		Example[
			{Options,Map,"Indicate that multiple plots should be created instead of overlaying data:"},
			PlotFluorescenceKinetics[{Object[Data, FluorescenceKinetics, "id:9RdZXvKBLw49"],Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"]},PlotLabel->{"1","2"},Map->True],
			{ValidGraphicsP[]..}
		],
		Example[
			{Options,Legend,"Display a legend with the plot:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],Legend->{"My Data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzXRAr3"],PrimaryData->Temperature,IncludeReplicates->True],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,ExcitationWavelength,"Display the trajectory generated by exciting the sample at the specified wavelength:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],ExcitationWavelength->485 Nanometer],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionWavelength,"Display the trajectory measured at the specified emission wavelength:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],EmissionWavelength->590 Nanometer],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,DualEmissionWavelength,"Display the trajectory measured at the specified emission wavelength:"},
			PlotFluorescenceKinetics[Object[Data, FluorescenceKinetics, "id:9RdZXvKBLw49"],DualEmissionWavelength->520 Nanometer],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,EmissionTrajectories,"Provide a new value for the trajectory instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"],EmissionTrajectories->QuantityArray[Table[{x,Sqrt[x]/100},{x,250,1000,10}],{Nanometer,RFU}]],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Options,DualEmissionTrajectories,"Provide a new value for the secondary trajectory instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceKinetics[Object[Data, FluorescenceKinetics, "id:9RdZXvKBLw49"],DualEmissionTrajectories->QuantityArray[Table[{x, Sqrt[x]/100}, {x, 250, 1000, 10}], {Nanometer, RFU}],PrimaryData -> DualEmissionTrajectories],
			ValidGraphicsP[],
			TimeConstraint->120
		],
		Example[{Messages,"NoTrajectory","Provide a new value for the secondary trajectory instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],ExcitationWavelength->69 Nanometer],
			$Failed,
			Messages:>{PlotFluorescenceKinetics::NoTrajectory}
		],
		Example[{Messages,"NullPrimaryData","Provide a new value for the secondary trajectory instead of using the value recorded in the object being plotted:"},
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:XnlV5jK76e4B"],PrimaryData->DualEmissionTrajectories],
			$Failed,
			Messages:>{Error::NullPrimaryData}
		],
		Test["Plots data when given a packet:",
			PlotFluorescenceKinetics[Download[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"]]],
			ValidGraphicsP[]
		],
		Test["Plots data when given a quantity array:",
			PlotFluorescenceKinetics[Download[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],EmissionTrajectories]],
			ValidGraphicsP[]
		],
		Test["Plot the Fluorescence trajectory of the data of interest:",
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:lYq9jRzX38AY"]],
			ValidGraphicsP[]
		],
		Test["Plot multiple raw traces for multiple data sets on the primary axis:",
			PlotFluorescenceKinetics[(Download[{Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Object[Data,FluorescenceKinetics,"id:4pO6dMWvG8aX"]},{EmissionTrajectories[[1]],DualEmissionTrajectories[[1]]}]),PrimaryData->{EmissionTrajectories,DualEmissionTrajectories}],
			ValidGraphicsP[]
		],
		Test["Plot multiple raw data traces for a single listed data set on the primary axis:",
			PlotFluorescenceKinetics[(Download[{Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"]},{EmissionTrajectories[[1]],DualEmissionTrajectories[[1]]}]),PrimaryData->{EmissionTrajectories,DualEmissionTrajectories}],
			ValidGraphicsP[]
		],
		Test["Plot multiple raw data traces for a single unlisted data set on the primary axis:",
			PlotFluorescenceKinetics[(Download[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],{EmissionTrajectories[[1]],DualEmissionTrajectories[[1]]}]),PrimaryData->{EmissionTrajectories,DualEmissionTrajectories}],
			ValidGraphicsP[]
		],
		Test["Plot a single trace for a multiple listed data primary axis:",
			PlotFluorescenceKinetics[Download[{Object[Data,FluorescenceKinetics,"id:rea9jl1oMwAx"],Object[Data,FluorescenceKinetics,"id:M8n3rxYEVZDR"]},EmissionTrajectories]],
			ValidGraphicsP[]
		],
		Test["Command builder preview returns a valid graphic:",
			PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"]],
			ValidGraphicsP[]
		],
		Test["Function properly resolves wavelength options:",
			Lookup[
				PlotFluorescenceKinetics[Object[Data,FluorescenceKinetics,"id:9RdZXvKBLw49"],Output->Options],
				{ExcitationWavelength,EmissionWavelength,DualEmissionWavelength}
			],
			{UnitsP[],UnitsP[],UnitsP[]}
		]
	}
];
