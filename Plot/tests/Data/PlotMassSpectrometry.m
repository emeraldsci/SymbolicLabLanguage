(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotMassSpectrometry*)


DefineTests[PlotMassSpectrometry,
	{
		Example[
			{Basic,"Display the mass spectrum as a graphical plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic, "Plot the MassSpectrometry data linked to a MassSpectrometry protocol object:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"][Protocol]],
			SlideView[{ValidGraphicsP[] ..}],
			TimeConstraint -> 120
		],
		Example[
			{Basic,"When available, the expected molecular weight is included on the plot by default:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:wqW9BP7LjBl9"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Basic,"Peak picking analysis results are automatically included on the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:jLq9jXvJk7dw"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Additional,"Plot data from ESI-QQQ for ScanMode is MultipleReactionMonitoring:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:6V0npvmVozR1"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Additional,"Plot data from ESI-QQQ for ScanMode is SelectedIonMonitoring:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:BYDOjvGYJPmq"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Additional,"Plot data from ESI-QQQ for other scan mode:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57XMvNd"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,ExpectedMolecularWeight,"Directly specify molecular weights to display on the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:54n6evLEJadv"],ExpectedMolecularWeight->6116.4 Dalton,Truncations->0],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,ExpectedMolecularWeight,"Directly specify a number as the molecular weights to display on the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:54n6evLEJadv"],ExpectedMolecularWeight->6116.4,Truncations->0],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Truncations,"Display 3 truncations of the strand on the plot:"},
			PlotObject[Object[Data, MassSpectrometry, "id:wqW9BP7LjBl9"],Truncations->3],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TargetUnits,"Specify the units to use on the X and Y axes:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:WNa4ZjRr49pZ"],TargetUnits->{Dalton,ArbitraryUnit}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Peaks,"Display peak picking data along with the spectrum:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:WNa4ZjKv5NWq"],Peaks->Object[Analysis, Peaks, "id:L8kPEjndDWjA"]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TickColor,"Change the tick color of the expected molecular weight markers:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:4pO6dM5wjGoM"],TickColor->Orange],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TickStyle,"Change the tick style of the expected molecular weight markers:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:R8e1PjpqY1kd"],Truncations->1,TickStyle->{Thickness[0.01]}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TickSize,"Adjust the tick height of the expected molecular weight markers relative to the total plot height:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:n0k9mG8xK9Ar"],Truncations->1,TickSize->.1],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,TickLabel,"Don't label the primary molecular weight epilogs:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:qdkmxzq31moY"],Truncations->2,TickLabel->False],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,LabelStyle,"Change the plot labeling style:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:o1k9jAK4kWPm"],Truncations->3,LabelStyle->{Bold,14,FontFamily->"Times"}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Map,"Generate a separate graph for each data object:"},
			PlotMassSpectrometry[{Object[Data, MassSpectrometry, "id:qdkmxzq31moY"],Object[Data, MassSpectrometry, "id:AEqRl950qV66"]},Map->True],
			{_?ValidGraphicsQ..},
			TimeConstraint -> 120
		],
		Example[
			{Options,Legend,"Create a custom legend:"},
			PlotMassSpectrometry[{Object[Data, MassSpectrometry, "id:M8n3rx0l58dG"],Object[Data, MassSpectrometry, "id:WNa4ZjKv5NWq"]},Legend->{"Low Mass Range","High Mass Range"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Units,"Specify the units in which the spectrum should be plotted:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:GmzlKjYGzB6X"],Units->{MassSpectrum->{Gram/Mole,ArbitraryUnit}}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,PrimaryData,"Specify the PrimaryData to be plotted:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],PrimaryData -> MassSpectrum],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,SecondaryData,"Specify the SecondaryData to be plotted:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],SecondaryData ->{}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Display,"Specify the Display to be plotted:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],Display ->{Peaks}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,IncludeReplicates,"Specify whether to include replicates for plotting:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],IncludeReplicates ->False],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Zoomable,"Specify whether the plot will be zoomable:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],Zoomable ->True],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,OptionFunctions,"Specify the OptionFunctions to be used for plotting:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],OptionFunctions ->{Plot`Private`molecularWeightEpilogs}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,LegendPlacement,"Specify where the legend is to be placed on the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],LegendPlacement ->Bottom],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Boxes,"Specify whether the legend on the plot will have boxes:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],Boxes ->False],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,FrameLabel,"Specify the label to be used on the frame of the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],FrameLabel ->{"Mass-to-Charge Ratio (m/z)", "Arbitrary Unit", None, None}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,PlotLabel,"Specify the label to be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],PlotLabel ->"id:vXl9j57Yra3N"],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,IonMonitoringIntensity,"Specify whether ion monitoring intensity will be used for plotting:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],IonMonitoringIntensity ->Null],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,IonMonitoringMassChromatogram,"Specify whether ion monitoring mass chromatogram will be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],IonMonitoringMassChromatogram ->Null],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,MassSpectrum,"Specify whether mass spectrum will be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],MassSpectrum ->Null],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,UnintegratedMassSpectra,"Specify whether unintegrated mass spectra will be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],UnintegratedMassSpectra ->Null],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Frame,"Specify the borders of the frame to be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],Frame ->{True,True,False,False}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Example[
			{Options,Filling,"Specify the filling to be used for the plot:"},
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:vXl9j57Yra3N"],Filling ->Bottom],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],

		Test[
			"Plots when given a packet:",
			PlotMassSpectrometry[Download[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"]]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Plot mass spectrometry object in a link:",
			PlotMassSpectrometry[Link[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],Protocol]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Display the mass spectra as a graphical plot:",
			PlotMassSpectrometry[Download[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],MassSpectrum]],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Use the units of the plot data as the units of the input molecular weights. Display Intensity and ExpectedMolecularWeight:",
			PlotMassSpectrometry[{Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],Object[Data, MassSpectrometry, "id:WNa4ZjRr49pZ"]},ExpectedMolecularWeight->{4000 Gram/Mole,2000 Gram/Mole},Truncations->0],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Use the units of the plot data as the units of the input molecular weights:",
			PlotMassSpectrometry[{Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],Object[Data, MassSpectrometry, "id:WNa4ZjRr49pZ"]},ExpectedMolecularWeight->{4000 Gram/Mole,2000 Gram/Mole},Truncations->0],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Display the peaks:",
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],ExpectedMolecularWeight->{Strand[DNA["ATAGATAGATA"]],Strand[DNA["ATAGGAGAAGATAGATA"]]},Truncations->3,TickSize->0.85],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Change the tick size of the expected molecular weight markers:",
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],ExpectedMolecularWeight->{Strand[DNA["ATAGATAGATA"]],Strand[DNA["ATAGGAGAAGATAGATA"]]},Truncations->3,TickSize->0.2],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Change the tick style of the expected molecular weight markers:",
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],ExpectedMolecularWeight->{Strand[DNA["ATAGATAGATA"]],Strand[DNA["ATAGGAGAAGATAGATA"]]},Truncations->3,TickStyle->{Dashed,Thin}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		],
		Test[
			"Change the tick style of the expected molecular weight markers:",
			PlotMassSpectrometry[Object[Data, MassSpectrometry, "id:kEJ9mqaV9Lv3"],ExpectedMolecularWeight->{Strand[DNA["ATAGATAGATA"]],Strand[DNA["ATAGGAGAAGATAGATA"]]},Truncations->3,TickStyle->{CapForm["Round"],Thickness[0.01]}],
			_?ValidGraphicsQ,
			TimeConstraint -> 120
		]
	}
];
