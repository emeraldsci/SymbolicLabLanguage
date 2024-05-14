(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*PlotData: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*PlotObject*)


(* ::Subsubsection:: *)
(*PlotObject*)


DefineTests[PlotObject,{

	Example[{Basic,"Plot a data object using the default styling and settings for its type. Here chromatography data is displayed using the default styling and settings for an HPLC plot:"},
		PlotObject[Object[Data, Chromatography, "id:eGakld01dzk4"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Plot raw data in the style of an existing ECL data type. This data is displayed as a mass spectrometry plot would be:"},
		PlotObject[MassSpectrometry,Table[{x, 1 + Exp[-0.1` (x - 455)^2]}, {x, 0, 1000, 0.1`}]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Display analysis and simulation objects:"},
		Grid[{{
			PlotObject[Object[Analysis, Fit, "id:pZx9jonGV4Y5"]],
			PlotObject[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"]]
		}}],
		_Grid
	],
	Example[{Basic,"Show images associated with models:"},
		PlotObject[Model[Instrument, NMR, "id:6V0npvK61r8q"]],
		_Image
	],

	Example[{Additional,"Raw Inputs","Plot data with units when expressed as a quantity array:"},
		PlotObject[QuantityArray[Table[{x,1-Exp[-.05*x]},{x,0,100}],{Second,RFU}]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Raw Inputs","A coordinate set is plotted as a list line plot:"},
		PlotObject[Table[{x,x^2},{x,-1,1,0.1}]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Raw Inputs","If multiple coordinate sets are provided, they will be overlaid on the same plot:"},
		PlotObject[Table[Table[{x,x^n},{x,-1,1,0.1}],{n,1,3}]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","A short list of values is plotted as a bar chart:"},
		PlotObject[Range[1,5]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Raw Inputs","Multiple short lists will be placed alongside each other in the same bar chart:"},
		PlotObject[{{0.17,0.52,0.24,0.33},{0.86,0.24,0.68,0.19,0.23}}],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","Plot a long list of values as a histogram:"},
		PlotObject[RandomVariate[NormalDistribution[10,2],1000]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Raw Inputs","If multiple lists are given, the histograms will be overlaid on the same plot:"},
		PlotObject[Table[RandomVariate[NormalDistribution[x,x/10],1000],{x,{3,4,5}}]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","Three layers of lists are shown as a box-whisker chart:"},
		PlotObject[Table[Table[RandomVariate[NormalDistribution[x,x/10],1000],{x,{3,4,5}}],{2}]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","List of triplet pairs plotted as 3D surface:"},
		PlotObject[Flatten[Table[{x, y, Tanh[x] Tanh[y]}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","Multiple sets of 3D data:"},
		PlotObject[{Flatten[Table[{x, y, Tanh[x] Tanh[y]}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1],Flatten[Table[{x, y, -x y /4}, {x, -2, 2, .2}, {y, -2, 2, .2}], 1]}],
		ValidGraphicsP[]
	],

	Example[{Additional,"Raw Inputs","Plot an image with scale bars:"},
		PlotObject[Object[EmeraldCloudFile, "id:eGakldJOE5jE"]],
		plotImageP
	],

	Test["Plots an image:",
		PlotObject[ImportCloudFile[Object[EmeraldCloudFile, "id:eGakldJOE5jE"]]],
		plotImageP
	],

	Example[{Additional,"Data Objects","Plot absorbance spectroscopy as a list line plot, styling the trace based on the max absorbance:"},
		PlotObject[Object[Data, AbsorbanceSpectroscopy, "id:7X104vnnXNRZ"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot data from an absorbance thermodynamics experiment with directional arrows to differentiate the cooling and melting curves:"},
		PlotObject[Object[Data, MeltingCurve, "id:D8KAEvdeK3jY"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot the data generated from an HPLC experiment, automatically including the gradient and pressure trace and overlaying any selected peaks:"},
		PlotObject[Object[Data, Chromatography, "id:eGakld01dzk4"]],
		ValidGraphicsP[]
	],
(*	Example[{Additional,"Data Objects","Display flow cytometry data as a histogram:"},
		PlotObject[Object[Data, FlowCytometry, "id:pZx9jonGBOpM"]],
		ValidGraphicsP[]
	],
*)	Example[{Additional,"Data Objects","Generate a histogram of fluorescence intensity values recorded in a protocol:"},
		PlotObject[Object[Protocol, FluorescenceIntensity, "id:9RdZXvK8De8x"][Data]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Overlay a series of fluorescence kinetics traces:"},
		PlotObject[{Object[Data, FluorescenceKinetics, "id:3em6Zv9zvRwz"],
			Object[Data, FluorescenceKinetics, "id:D8KAEvd4voaY"],
			Object[Data, FluorescenceKinetics, "id:aXRlGnZPn9E9"],
			Object[Data, FluorescenceKinetics, "id:wqW9BP43PbpR"],
			Object[Data, FluorescenceKinetics, "id:J8AY5jwEjqKx"],
			Object[Data, FluorescenceKinetics, "id:8qZ1VWNwWjGD"]}],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot DNA sequencing data as a list line plot, with the 4 bases on the same plot:"},
		PlotObject[Object[Data, DNASequencing, "id:R8e1Pjp8odDX"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot data collected from a fluorescence spectroscopy experiment:"},
		PlotObject[Object[Data, FluorescenceSpectroscopy, "id:6V0npvK7Wldq"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot fluorescence thermodynamics data with arrows to indicate cooling and melting curves:"},
		PlotObject[Object[Data, FluorescenceThermodynamics, "id:3em6Zv9NqVX8"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Mass spectrometry data is displayed with the expected molecular weight(s):"},
		PlotObject[Object[Data, MassSpectrometry, "id:N80DNj11WNxD"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot NMR data:"},
		PlotObject[Object[Data, NMR, "id:3em6Zv9Nqj07"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","PAGE data is automatically plotted with its associated ladder and the raw images:"},
		PlotObject[Object[Data, PAGE, "id:XnlV5jKRBVVZ"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot the applicable normalized and baseline-subtracted amplification curves from qPCR data:"},
		PlotObject[Object[Data, qPCR, "id:bq9LA0JWAV6A"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot the raw droplet distributions from DigitalPCR data:"},
		PlotObject[Object[Data, DigitalPCR, "id:WNa4ZjKJlD8R"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Display the image of a TLC lane above a pixel intensity plot:"},
		PlotObject[Object[Data, TLC, "id:Vrbp1jG806vm"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot a collection of volume recordings as a histogram:"},
		PlotObject[{Object[Data, Volume, "id:qdkmxz0A6W5x"], Object[Data, Volume, "id:O81aEB4kXoAD"], Object[Data, Volume, "id:GmzlKjY50Bpm"],Object[Data, Volume, "id:AEqRl954JVnW"]}],
		ValidGraphicsP[]
	],
	Example[{Additional,"Data Objects","Plot the mass spectrum along with any selected peaks:"},
		PlotObject[Object[Data, Western, "id:qdkmxz0A6p5a"]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Analysis Objects","Plot the absorbance spectroscopy data used to determine sample concentration:"},
		PlotObject[Object[Analysis, AbsorbanceQuantification, "id:qdkmxzqJAmLm"]],
		ValidGraphicsP[]
	],

	(* Resize to keep the help file small byte-wise *)
	Example[{Additional,"Analysis Objects","Display a microscope image with detected cellular region (confluent area):"},
		PlotObject[Object[Analysis, CellCount, "id:J8AY5jDMmLZK"]],
		_TabView
	],
	Example[{Additional,"Analysis Objects","Plot the initial number of target copies in a sample for qPCR, based on a standard curve of quantification cycle vs Log10 copy number:"},
		PlotObject[Object[Analysis, CopyNumber, "id:M8n3rx0ZaMbm"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Show the quality of a line of a curve fitting analysis performed on input coordinates:"},
		PlotObject[Object[Analysis, Fit, "id:eGakldJ4qebG"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Highlight the HPLC fractions selected and displays the corresponding samples on mouse over:"},
		PlotObject[Object[Analysis, Fractions, "id:R8e1PjpRmwla"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Display predicted trajectories after determining the kinetic rates from the provided trajectories and reaction model:"},
		PlotObject[Object[Analysis, Kinetics, "id:jLq9jXY4olea"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Display the fit generated by analyzing a known standard:"},
		PlotObject[Object[Analysis, Ladder, "id:wqW9BP4Yrva9"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Display the melting temperature of the sample as calculated from the melting and cooling curves collected in an absorbance thermodynamics experiment:"},
		PlotObject[Object[Analysis, MeltingPoint, "id:qdkmxz0APk50"],PlotType->Alpha],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Plot the peaks found in a mass spectrum as a pie chart of peak purity:"},
		PlotObject[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Display the microscope image data from multiple fluorescence channels as a single combined image:"},
		PlotObject[Object[Analysis, MicroscopeOverlay, "id:4pO6dMWvYKJz"]],
		ZoomableP
	],
	Example[{Additional,"Analysis Objects","Display the amplification cycle at which the fluorescence in a qPCR reaction can be detected above the background fluorescence:"},
		PlotObject[Object[Analysis, QuantificationCycle, "id:zGj91a7nrpzO"]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Analysis Objects","Show a van't Hoff plot used to calculate thermodynamic properties of the sample:"},
		PlotObject[Object[Analysis, Thermodynamics, "id:n0k9mGzREWbn"]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Model Objects","Display the ribbon structure of the protein:"},
		PlotObject[Model[Molecule, Protein, "A2M"]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Model Objects","Display a 3D schematic of the antibody structure:"},
		PlotObject[Model[Molecule, Protein, Antibody, "AntiBax"]],
		ValidGraphicsP[],
		TimeConstraint->300
	],

	Example[{Additional,"Model Objects","Display the predicted folding of an RNA transcript:"},
		PlotObject[Model[Molecule, Transcript, "GAPDH"]],
		ListableP[_Structure]
	],

	Example[{Additional,"Model Objects","Display each component of a Model[Sample]'s composition:"},
		PlotObject[Model[Sample, "EDTA Oligo"]],
		{Column[{"EDTA", _Image}, ___],	Column[{"DNA 10-mer of Unknown Sequence", _Strand}, ___]}
	],

	Example[{Additional, "Model Objects", "Display a container model image with scale bars, if applicable:"},
		PlotObject[Model[Container, Vessel, "id:3em6Zv9NjjN8"]], (* 2mL Tube *)
		plotImageP
	],
	
	(*
	Delete when $CCD becomes permanent since the patten has changed.
	Test["Scale bars are added to a Model[Container] image plot if the ImageFileScale field is populated:",
		Cases[
			PlotObject[Model[Container, Vessel, "id:3em6Zv9NjjN8"]], (* 2mL Tube *)
			HoldPattern[Rule[FrameLabel, _]],
			Infinity
		],
		{Rule[FrameLabel, {{Style["Centimeters",___],Style["Centimeters",___]}, {Style["Centimeters",___],Style["Centimeters",___]}}]}
	], *)

	Example[{Additional,"Simulation Objects","Plot the result of a kinetics simulation performed on the provided reaction mechanism:"},
		PlotObject[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Instrument Objects","Display the image of an instrument as it appears in the Emerald Cloud Lab:"},
		PlotObject[Object[Instrument, HPLC, "Thorin"]],
		_Image
	],

	Example[{Additional,"Instrument Objects","Display a generic image of the instrument:"},
		PlotObject[Model[Instrument, HPLC, "UltiMate 3000"]],
		_Image
	],

	Example[{Additional,"Container Objects","Display a generic image of the container:"},
		PlotObject[Model[Container, Vessel, "HPLC vial (flat bottom)"]],
		plotImageP
	],

	Test["Displays a list of images:",
		PlotObject[{Model[Instrument, HPLC, "UltiMate 3000"],Object[Instrument, HPLC, "Thorin"]}],
		{_Image..}
	],

	Test["Handles an instrument without an image:",
		PlotObject[Object[Instrument, Thermocycler, "id:KBL5DvYORG8a"]],
		Null
	],

	Test["Handles an instrument without an image in a list:",
		PlotObject[{Object[Instrument, Thermocycler, "id:KBL5DvYORG8a"],Object[Instrument, HPLC, "Thorin"]}],
		{(_Image|Null)..}
	],

	Example[{Additional,"Nucleic Acid Objects","Display a set of reactions:"},
		PlotObject[ReactionMechanism[Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, {Structure[{Strand[DNA[20, "B"], DNA[20, "C"]]}, {}], Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 2}], Bond[{1, 2}, {2, 1}]}]}, 1], Reaction[{Structure[{Strand[DNA[10, "A"], DNA[20, "B"]]}, {}], Structure[{Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {2, 1}]}]}, {Structure[{Strand[DNA[10, "A"], DNA[20, "B"]], Strand[DNA[20, "B"], DNA[20, "C"]], Strand[DNA[20, "B'"], DNA[10, "A'"]]}, {Bond[{1, 1}, {3, 2}], Bond[{2, 1}, {3, 1}]}]}, 1.*^6]]],
		_Graph
	],
	Example[{Additional,"Nucleic Acid Objects","Plot the concentration of all species in a Trajectory versus time:"},
		PlotObject[Trajectory[{"a", "c", "b", "h", "e", "f", "g", "d"}, {{0.001, 0.00001, 0.0001, 0., 0., 0., 0., 0.}, {0.001, 0.000010001, 0.0001, 8.9432*^-11, 0., 0., 0., 0.}, {0.001, 0.000010003, 0.0001, 1.7886*^-10, 0., 0., 0., 0.}, {0.00099888, 0.000011087, 0.00010072, 7.2522*^-8, 0., 0., 0., 0.}, {0.00099776, 0.00001217, 0.00010145, 1.4454*^-7, 0., 0., 0., 0.}, {0.00099664, 0.000013252, 0.00010217, 2.1624*^-7, 0., 0., 0., 0.}, {0.00098686, 0.000022726, 0.00010847, 8.3303*^-7, 0., 0., 0., 0.}, {0.00097718, 0.000032125, 0.00011472, 1.4259*^-6, 0., 0., 0., 0.}, {0.0009676, 0.00004145, 0.0001209, 1.9957*^-6, 0., 0., 0., 0.}, {0.00095811, 0.000050699, 0.00012703, 2.5431*^-6, 0., 0., 0., 0.}, {0.00092586, 0.000082246, 0.00014783, 4.281*^-6, 0., 0., 0., 0.}, {0.00089471, 0.0001129, 0.00016793, 5.7873*^-6, 0., 0., 0., 0.}, {0.00086459, 0.00014269, 0.00018736, 7.0879*^-6, 0., 0., 0., 0.}, {0.0008355, 0.0001716, 0.00020613, 8.2059*^-6, 0., 0., 0., 0.}, {0.00080738, 0.00019967, 0.00022427, 9.1621*^-6, 0., 0., 0., 0.}, {0.00075179, 0.0002555, 0.00026014, 0.000010713, 0., 0., 0., 0.}, {0.00070003, 0.00030787, 0.00029353, 0.000011781, 0., 0., 0., 0.}, {0.00065183, 0.00035693, 0.00032463, 0.000012476, 0., 0., 0., 0.}, {0.00060695, 0.00040284, 0.00035358, 0.000012886, 0., 0., 0., 0.}, {0.00056516, 0.00044579, 0.00038054, 0.000013079, 0., 0., 0., 0.}, {0.00052625, 0.00048593, 0.00040565, 0.00001311, 0., 0., 0., 0.}, {0.00047907, 0.00053476, 0.00043609, 0.000012972, 0., 0., 0., 0.}, {0.00043612, 0.00057937, 0.00046379, 0.000012696, 0., 0., 0., 0.}, {0.00039702, 0.0006201, 0.00048902, 0.000012334, 0., 0., 0., 0.}, {0.00036143, 0.00065725, 0.00051198, 0.000011923, 0., 0., 0., 0.}, {0.00032903, 0.00069113, 0.00053289, 0.000011488, 0., 0., 0., 0.}, {0.00029953, 0.00072202, 0.00055192, 0.000011048, 0., 0., 0., 0.}, {0.00026899, 0.00075404, 0.00057162, 0.000010553, 0., 0., 0., 0.}, {0.00024157, 0.00078282, 0.00058931, 0.000010078, 0., 0., 0., 0.}, {0.00021694, 0.00080869, 0.0006052, 9.63*^-6, 0., 0., 0., 0.}, {0.00019482, 0.00083194, 0.00061947, 9.2129*^-6, 0., 0., 0., 0.}, {0.00017496, 0.00085283, 0.00063228, 8.8277*^-6, 0., 0., 0., 0.}, {0.00015712, 0.00087159, 0.00064379, 8.4743*^-6, 0., 0., 0., 0.}, {0.00013706, 0.0008927, 0.00065673, 8.0695*^-6, 0., 0., 0., 0.}, {0.00011957, 0.00091112, 0.00066802, 7.7111*^-6, 0., 0., 0., 0.}, {0.0001043, 0.0009272, 0.00067787, 7.3949*^-6, 0., 0., 0., 0.}, {0.000090986, 0.00094122, 0.00068646, 7.1168*^-6, 0., 0., 0., 0.}, {0.00007937, 0.00095345, 0.00069395, 6.8728*^-6, 0., 0., 0., 0.}, {0.000069169, 0.0009642, 0.00070054, 6.6576*^-6, 0., 0., 0., 0.}, {0.000060279, 0.00097357, 0.00070627, 6.4694*^-6, 0., 0., 0., 0.}, {0.000052532, 0.00098173, 0.00071127, 6.3051*^-6, 0., 0., 0., 0.}, {0.000048647, 0.00098582, 0.00071378, 6.2225*^-6, 0., 0., 0., 0.}, {0.000045049, 0.00098961, 0.0007161, 6.146*^-6, 0., 0., 0., 0.}}, {0., 4.4605*^-7, 8.921*^-7, 0.00036252, 0.00072414, 0.0010858, 0.0042654, 0.0074451, 0.010625, 0.013804, 0.024847, 0.035891, 0.046934, 0.057977, 0.06902, 0.092032, 0.11504, 0.13806, 0.16107, 0.18408, 0.20709, 0.23739, 0.26769, 0.29799, 0.32829, 0.35859, 0.38888, 0.42357, 0.45826, 0.49295, 0.52763, 0.56232, 0.59701, 0.64107, 0.68512, 0.72918, 0.77324, 0.8173, 0.86168, 0.90605, 0.95043, 0.97521, 1.}, {Quantity[1, "Seconds"], Quantity[1, "Molar"]}]],
		ValidGraphicsP[]
	],

	Example[{Additional,"Sample Objects","Show the most recent appearance data gathered for a sample:"},
		PlotObject[Object[Sample,"id:Z1lqpMzz7WnV"]],
		_Row
	],


	(* Distributions *)

	Example[{Additional,"Distributions","Plot a normal distribution:"},
		PlotObject[NormalDistribution[3,2]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Distributions","Plot an empirical distribution as a histogram:"},
		PlotObject[EmpiricalDistribution[RandomVariate[NormalDistribution[3,2],64]]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Distributions","Plot several empirical distributions as a bar chart:"},
		PlotObject[EmpiricalDistribution/@RandomVariate[NormalDistribution[3, .5], {4, 64}]],
		ValidGraphicsP[]
	],
	Example[{Additional,"Distributions","Indicate that empirical distributions should be plotted as overlaid histograms:"},
		PlotObject[EmpiricalDistribution/@RandomVariate[NormalDistribution[3, .5], {4, 64}],PlotType->Histogram],
		ValidGraphicsP[]
	],


	(*
		OPTIONS
	*)
	Example[{Options,PlotType,"Indicate how the chromatography data should be displayed:"},
		PlotObject[Object[Data, Chromatography, "id:J8AY5jDwDENZ"],PlotType -> ContourPlot],
		g_/;ValidGraphicsQ[First@Cases[g,_Graphics,-1]]
	],

	Example[{Options,PrimaryData,"Display only the recorded conductance trace:"},
		PlotObject[Object[Data, Chromatography, "id:eGakld01q9Az"],PrimaryData -> Conductance, SecondaryData -> {}],
		ValidGraphicsP[]
	],

	Example[{Options,SecondaryData,"Indicate that conductance should be plotted on the secondary y-axis:"},
		PlotObject[Object[Data, Chromatography, "id:E8zoYveXj6v5"],SecondaryData->{Conductance}],
		ValidGraphicsP[]
	],
	Example[{Options,SecondaryData,"View multiple secondary data sets:"},
		PlotObject[Object[Data, Chromatography, "id:Y0lXejM6vKzl"],SecondaryData -> {GradientA, GradientB}],
		ValidGraphicsP[]
	],
	Example[{Options,SecondaryData,"Turn off all secondary data plotting:"},
		PlotObject[Object[Data, Chromatography, "id:Y0lXejGK31LE"],SecondaryData->{}],
		ValidGraphicsP[]
	],
	Test["The first non-Null specification determines the second-y axis label:",
		PlotObject[Object[Data, Chromatography, "id:L8kPEjNLPaeW"],SecondaryData->{GradientB,Pressure}],
		ValidGraphicsP[]
	],
	Example[{Options,Display,"Specify elements to display on the plot:"},
		PlotObject[Object[Data, Chromatography, "id:eGakld01dzk4"],Display->{Peaks,Fractions},SecondaryData->{}],
		ValidGraphicsP[]
	],
	Test["Specify a single display element:",
		PlotObject[Object[Data, Chromatography, "id:rea9jlR1b5k5"],Display -> {Peaks}, SecondaryData -> {}],
		ValidGraphicsP[]
	],
	Example[{Options,Display,"Turn off all display elements:"},
		PlotObject[Object[Data, Chromatography, "id:Y0lXejM6vKzl"],Display->{},SecondaryData->{}],
		ValidGraphicsP[]
	],


	Example[{Options,TargetUnits,"Specify target units for both axes of a list line plot:"},
		PlotObject[Object[Data, FluorescenceKinetics, "id:7X104vnnebq9"],TargetUnits->{Minute,Kilo*RFU}],
		ValidGraphicsP[]
	],
	Example[{Options,TargetUnits,"Indicate the units to use when displaying a bar chart:"},
		PlotObject[{Object[Data, FluorescenceIntensity, "id:M8n3rxYE4aR9"], Object[Data, FluorescenceIntensity, "id:O81aEB4kXrGX"], Object[Data, FluorescenceIntensity, "id:3em6Zv9NGzqz"], Object[Data, FluorescenceIntensity, "id:N80DNjlYVJDk"], Object[Data, FluorescenceIntensity, "id:01G6nvkK5q61"], Object[Data, FluorescenceIntensity, "id:n0k9mGzR6e96"], Object[Data, FluorescenceIntensity, "id:R8e1PjRDOv1v"], Object[Data, FluorescenceIntensity, "id:P5ZnEj4PqKjr"]},PlotType->BarChart,TargetUnits->Kilo*RFU],
		ValidGraphicsP[]
	],
	Test["Convert the input values from centimeters to inches:",
		PlotObject[Range[10]*Centimeter, TargetUnits -> Inch],
		ValidGraphicsP[]
	],
	Test["Specify target unit for a box whisker chart:",
		PlotObject[{
			Download[{Object[Data, Volume, "id:R8e1PjRDGJBJ"],Object[Data, Volume, "id:GmzlKjY51JNe"],Object[Data, Volume, "id:o1k9jAKOMNoA"]}],
			Download[{Object[Data, Volume, "id:lYq9jRzXMNOB"],Object[Data, Volume, "id:E8zoYveRnBOm"],Object[Data, Volume, "id:01G6nvkKXBDm"]}]
		},PlotType->BoxWhiskerChart,TargetUnits->Centimeter],
		ValidGraphicsP[]
	],


	Example[{Options,SecondYUnit,"Specify target units for secondary data:"},
		PlotObject[Object[Data, Chromatography, "id:Y0lXejGK31LE"],SecondaryData->{Temperature},SecondYUnit->Fahrenheit,SecondYRange -> {110 Fahrenheit, 115 Fahrenheit}],
		ValidGraphicsP[]
	],

	Test["Plot the object in a link:",
		PlotObject[Link[Object[Data, Chromatography,"id:1ZA60vwjvR8D"], Protocol]],
		ValidGraphicsP[]
	],

	Test["Null primary data produces an empty plot:",
		PlotObject[Null],
		ValidGraphicsP[]
	],
	Test["Null primary data + PlotRange handles smoothly:",
		PlotObject[Null,Display->{Peaks},Truncations->4,PlotRange->{{750,5000}*(Gram/Mole),Automatic}],
		ValidGraphicsP[]
	],
	Test["Plot a packet:",
		PlotObject[Download[Object[Data, Chromatography, "id:eGakld01dzk4"]]],
		ValidGraphicsP[]
	],

	Test["Data missing fractions:",
		PlotObject[
			Object[Data, Chromatography, "id:J8AY5jDl731D"],
			Display -> {Fractions}
		],
		ValidGraphicsP[]
	],
	Test["Some data with fractions, some without:",
		PlotObject[
			{Object[Data, Chromatography, "id:wqW9BP7vmXk4"],
				Object[Data, Chromatography, "id:J8AY5jDl731D"]},
			Display -> {Fractions}
		],
		ValidGraphicsP[]
	],
	Test["If given an object doesn't have a PlotObject overload, returns Null:",
		PlotObject[Object[Protocol, FluorescenceIntensity, "id:9RdZXvK8De8x"]],
		Null
	],
	Test["The HPLC qualification overload respects the OutputFormat option:",
		{plotResult,plotOps}=PlotObject[Object[Qualification, HPLC, "id:dORYzZJvVAZE"],Output->{Result,Options}],
		{_Legended,{_Rule..}}
	]
}];


(*** Duplicate tests for Builder testing ***)

DefineTests[PlotObjectCC,{

	Example[{Basic,"Plot a data object using the default styling and settings for its type. Here chromatography data is displayed using the default styling and settings for an HPLC plot:"},
		PlotObject[Object[Data, Chromatography, "id:eGakld01dzk4"]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Plot raw data in the style of an existing ECL data type. This data is displayed as a mass spectrometry plot would be:"},
		PlotObject[MassSpectrometry,Table[{x, 1 + Exp[-0.1` (x - 455)^2]}, {x, 0, 1000, 0.1`}]],
		ValidGraphicsP[]
	],
	Example[{Basic,"Display analysis and simulation objects:"},
		Grid[{{
			PlotObject[Object[Analysis, Fit, "id:pZx9jonGV4Y5"]],
			PlotObject[Object[Simulation, Kinetics, "id:WNa4ZjRDWr7V"]]
		}}],
		_Grid
	],
	Example[{Basic,"Show images associated with models:"},
		PlotObject[Model[Instrument, NMR, "id:6V0npvK61r8q"]],
		_Image
	]

}];

(* ::Subsubsection:: *)
(*PlotObject*)


DefineTests[PlotObjectFunction,{

	Example[{Basic,"Return the plot function for chromatography data:"},
		PlotObjectFunction[Object[Data,Chromatography,"id:eGakld01dzk4"]],
		PlotChromatography
	],
	Example[{Basic,"Return the plot function for a fit analysis:"},
		PlotObjectFunction[Object[Analysis, Fit, "id:pZx9jonGV4Y5"]],
		PlotFit
	],
	Example[{Basic,"Return the plot function for an instrument:"},
		PlotObjectFunction[Object[Instrument, HPLC, "Thorin"]],
		plotCloudFile
	],
	Example[{Basic,"Return the plot function for a container:"},
		PlotObjectFunction[Model[Container, Vessel, "id:3em6Zv9NjjN8"]],
		PlotImage
	]

}];


(* ::Section:: *)
(*End Test Package*)
