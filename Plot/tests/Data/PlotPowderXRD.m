(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPowderXRD*)


DefineTests[PlotPowderXRD,
	{
		Example[{Basic, "Plot the diffraction spectrum of a single object:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "PlotObject calls PlotPowderXRD to plot the diffraction spectrum of a single object:"},
			PlotObject[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot the diffraction spectrum of multiple objects:"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]}],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot the diffraction spectrum of a set of raw data:"},
			PlotPowderXRD[Download[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], DiffractionSpectrum]],
			_?ValidGraphicsQ
		],
		Example[{Options,Map,"Generate a seperate plot for each data object given:"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]},Map->True],
			{_?ValidGraphicsQ,_?ValidGraphicsQ},
			TimeConstraint->120
		],
		Example[{Options,Legend,"Provide a custom legend for the data:"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]}, Legend->{"Data 219098","Data 219097"}],
			_?Core`Private`ValidLegendedQ,
			TimeConstraint->120
		],
		Example[{Options,Units,"Specify relevant units:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Units -> {DiffractionSpectrum -> {AngularDegrees, ArbitraryUnit}}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,PrimaryData,"Indicate that the intensity of a given 2\[Theta] angle should be plotted on the y-axis:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],PrimaryData->DiffractionSpectrum],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,SecondaryData,"There is no secondary data for PowderXRD:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,Display,"By default picked peaks are displayed on top of the plot. Hide peaks by clearing the display:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],Display->{}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,PlotTheme,"Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],PlotTheme -> "Marketing"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,Zoomable,"To improve performance indicate that the plot should not allow interactive zooming:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],Zoomable->False],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,PlotLabel,"Provide a title for the plot:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],PlotLabel->"PowderXRD Spectrum"],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,Peaks,"Provide peaks for the plot:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],Peaks->Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis"]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,FrameLabel,"Specify custom x and y-axis labels:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],FrameLabel -> {"Intensity (cps)", "2 Theta (degrees)", None, None}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,OptionFunctions,"Turn off formatting based on the intensity value at a given 2\[Theta] by clearing the option functions:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],OptionFunctions -> {}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,DiffractionSpectrum,"Provide a new value for the DiffractionSpectrum instead of using the value recorded in the object being plotted:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],DiffractionSpectrum->Download[Object[Data, XRayDiffraction, "PowderXRD Data Object 2"], DiffractionSpectrum]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,BlankedDiffractionSpectrum,"Provide a new value for the BlankedDiffractionSpectrum instead of using the value recorded in the object being plotted:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],BlankedDiffractionSpectrum->Download[Object[Data, XRayDiffraction, "PowderXRD Data Object 2"], DiffractionSpectrum]],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,IncludeReplicates,"Indicate that replicate data should be averaged together and shown with error bars:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object Including Replicates"], IncludeReplicates->True],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,TargetUnits,"Plot the x-axis in units of radians:"},
			PlotPowderXRD[Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],TargetUnits->{Radian,ArbitraryUnit}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]}, LegendPlacement -> Right],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]}, Boxes -> True],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options,Output,"Depending on the Output option, return a plot, a list of resolved options, or the tests (in this case, {}):"},
			PlotPowderXRD[{Object[Data, XRayDiffraction, "PowderXRD Data Object 1"], Object[Data, XRayDiffraction, "PowderXRD Data Object 2"]}, Output -> {Result, Preview, Options, Tests}],
			{
				_?ValidGraphicsQ,
				_?ValidGraphicsQ,
				{__Rule},
				{}
			},
			TimeConstraint->120
		]
	},
	SymbolSetUp :> {
		Module[
			{testObjs, existingTestObjs},

			testObjs = {
				Object[Container, OperatorCart, "Fake cart for PlotPowderXRD tests"],
				Object[Container, Vessel, "Fake container 1 for PlotPowderXRD tests"],
				Object[Container, Vessel, "Fake container 2 for PlotPowderXRD tests"],
				Object[Container, Plate, "Fake crystallization plate for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 1 for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 2 for PlotPowderXRD tests"],
				Object[Protocol, PowderXRD, "Fake PowderXRD protocol for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 3 for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 4 for PlotPowderXRD tests"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object 2"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object Including Replicates"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis 2"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis 3"]
			};
			existingTestObjs = PickList[testObjs, DatabaseMemberQ[testObjs], True];
			EraseObject[existingTestObjs, Force -> True, Verbose -> False]
		];
		Module[
			{fakeCart, fakeProt, crystallizationPlate1, container1, sample1, container2, sample2, allCloudFiles, allFileNames,
				sample3, sample4, graphDataFilePaths, rawImportedDataFiles, dataQuantityArrays, dataIDs, protID, dataPackets},

			(* make all the file structures in question *)
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "movie"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q2"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q2", "movie"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "movie"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "plots_red"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q2", "plots_red"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "plots_red"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "frames"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "frames", "DTREK_images"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q2", "frames"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q2", "frames", "DTREK_images"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "frames"}]]];
			Quiet[CreateDirectory[FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "frames", "DTREK_images"}]]];

			allCloudFiles = {
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "704b98e1fa9d285586e2989eec987572.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "de5a81cab489e2a6c4c92441ecf9ada4.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "768a6618f2ff58e6ce5361f84cdab951.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "9bad3b4a6f42b55ff9e5f2e98e390e6f.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "dc7adffeac1391d5410236f8250de1e8.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "d550f054ee59ec3fe6ab6f911d0b5b06.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "c5d549a085991bb13bf7856bb9dbb672.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "9d461da16eee698af7e96e1b4ca7554d.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "037d8f1dbadec3b181786edb47044e9e.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "dca6f5b945c1e581308b73ef7abad2b5.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "a0c42b60a9a62988f9db9320f82dc676.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "22423a41b9633878e52803b1449cd8c9.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "35f16c0633ea219a1e0c431eeba8bf8a.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "44f54a217cb9602b349a4ee4c71df808.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "f3bf9169f9c094ce10693c26f087f337.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "0ec7ea7ff4c934deff51470115754f11.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "80b1f3d98a68b3e219082e6dc48ded13.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "9624ac6ad639f87336153dac850608c6.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "d34374d8253cc6b5ecc0e6fdb77d2fbf.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "8a744c58db57dd5030ee391ec49fe4ea.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "ed4a600ef31d0dcb7ace8233bca0cc60.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "77eb849625d64e12a26f6a5abad92fcb.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "33a0ab00bae8f64b81c4da42ffa606d4.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "66c27dd28d6193ea8dbf76e09126a722.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "f1f0a4c9db1831ae79a41cf146847c74.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "6da4afc9bc4dd99d910173a83af5d76b.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "8a746be65916ae4f71d9c50d333b2af1.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "d7cec2b6dbed490a8e72ba1fd7dad020.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "2580470189a30cb7348efda46bfddbcb.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "3ed2d79f419b5238311fea3a141c2ef9.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "80b74a316852a9ccc4bdd80114a7be90.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "166c5373b4d07506e04aaefc64e510e9.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "d588836d19cdb57364163f4cdd1bc0e8.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "1d9a0575af80ce67d579467cfcb9ab7c.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "5433e3b3bff60f92f3a831be95a46aaf.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "8afaf9d8320c9ccb8f7122464cd47ad4.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "dd65929da5f6da5e5248f57f39e3aea3.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "90a8b5158523153a8882c8323d2919c8.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "540ca5ac06767bc4ca7605b2be82e3c7.jpg"],
				ECL`EmeraldCloudFile[ "AmazonS3", "emeraldsci-ecl-blobstore-stage", "e33984c0a1e1161795f189f3801fd0bc.jpg"],

				ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "e02552df985f072ba07638b0819ee3a9.txt"],
				ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "442a990f1e5ba1b847ca9aed1436721e.csv"],
				ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "e02552df985f072ba07638b0819ee3a9.txt"],
				ECL`EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "442a990f1e5ba1b847ca9aed1436721e.csv"]
			};

			allFileNames = {
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_10.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_11.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_12.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_13.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_14.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_15.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_16.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_17.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_18.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_19.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_1.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_20.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_2.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_3.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_4.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_5.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_6.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_7.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_8.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","movie","XtalCheckQ1_1_9.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_10.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_11.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_12.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_13.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_14.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_15.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_16.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_17.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_18.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_19.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_1.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_20.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_2.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_3.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_4.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_5.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_6.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_7.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_8.jpg"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","movie","XtalCheckQ3_1_9.jpg"}],

				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","plots_red","practiceFile.txt"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A1_D1","Thu-Jan-24-17-02-25-2019_Q1","plots_red","practiceFile.csv"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","plots_red","practiceFile.txt"}],
				FileNameJoin[{$TemporaryDirectory, "Data","XRD","executeTest","A2_D1","Thu-Jan-24-17-02-25-2019_Q3","plots_red","practiceFile.csv"}]
			};

			MapThread[
				If[FileExistsQ[#2],
					Null,
					Constellation`Private`downloadCloudFile[#1, #2]
				]&,
				{allCloudFiles, allFileNames}
			];

			{fakeCart} = Upload[{
				<|
					Type -> Object[Container, OperatorCart],
					Model -> Link[Model[Container, OperatorCart, "Chemistry Lab Cart"], Objects],
					DeveloperObject -> True,
					Name -> "Fake cart for PlotPowderXRD tests"
				|>
			}];
			{
				sample1,
				sample2,
				sample3,
				sample4,
				crystallizationPlate1,
				container1,
				container2
			} = CreateID[{
				Object[Sample],
				Object[Sample],
				Object[Sample],
				Object[Sample],
				Object[Container, Plate],
				Object[Container, Vessel],
				Object[Container, Vessel]
			}];
			Upload[{
				<|
					Object -> sample1,
					DeveloperObject -> True,
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Position -> "A1",
					Status -> InUse,
					Volume -> 1.8*Milliliter,
					Name -> "Fake sample 1 for PlotPowderXRD tests"
				|>,
				<|
					Object -> sample2,
					DeveloperObject -> True,
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Position -> "A1",
					Status -> InUse,
					Volume -> 1.8*Milliliter,
					Name -> "Fake sample 2 for PlotPowderXRD tests"
				|>,
				<|
					Object -> sample3,
					DeveloperObject -> True,
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Position -> "A1",
					Status -> InUse,
					Volume -> 10*Microliter,
					Name -> "Fake sample 3 for PlotPowderXRD tests"
				|>,
				<|
					Object -> sample4,
					DeveloperObject -> True,
					Model -> Link[Model[Sample, "Milli-Q water"], Objects],
					Position -> "A2",
					Status -> InUse,
					Volume -> 10*Microliter,
					Name -> "Fake sample 4 for PlotPowderXRD tests"
				|>,
				<|
					Object -> crystallizationPlate1,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Plate, "In Situ-1 Crystallization Plate"], Objects],
					Container -> Link[fakeCart, Contents, 2],
					Position -> "Tray Slot",
					Status -> InUse,
					Name -> "Fake crystallization plate for PlotPowderXRD tests",
					Replace[Contents] -> {
						{"A1", Link[sample3, Container]},
						{"A2", Link[sample4, Container]}
					}
				|>,
				<|
					Object -> container1,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Container -> Link[fakeCart, Contents, 2],
					Position -> "Tray Slot",
					Status -> InUse,
					Name -> "Fake container 1 for PlotPowderXRD tests",
					Replace[Contents] -> {{"A1", Link[sample1, Container]}}
				|>,
				<|
					Object -> container2,
					DeveloperObject -> True,
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Container -> Link[fakeCart, Contents, 2],
					Position -> "Tray Slot",
					Status -> InUse,
					Name -> "Fake container 2 for PlotPowderXRD tests",
					Replace[Contents] -> {{"A1", Link[sample2, Container]}}
				|>
			}];

			graphDataFilePaths = {
				FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "plots_red", "practiceFile.txt"}],
				FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "plots_red", "practiceFile.txt"}]
			};
			rawImportedDataFiles = Map[
				FastImport[#, "CSV"]&,
				graphDataFilePaths
			];
			dataQuantityArrays = {
				QuantityArray[ToExpression[rawImportedDataFiles[[1, 3;;]]], {AngularDegree, ArbitraryUnit}],
				QuantityArray[ToExpression[rawImportedDataFiles[[2, 3;;]]] * (ConstantArray[{1, 0.5}, Length[rawImportedDataFiles[[2, 3;;]]]]), {AngularDegree, ArbitraryUnit}]
			};
			dataIDs = CreateID[Table[Object[Data, XRayDiffraction], 3]];
			protID = CreateID[Object[Protocol, PowderXRD]];
			dataPackets = {
				<|
					Object -> dataIDs[[1]],
					Type -> Object[Data, XRayDiffraction],
					DeveloperObject -> True,
					Name -> "PowderXRD Data Object 1",
					DiffractionSpectrum -> dataQuantityArrays[[1]],
					Protocol -> Link[protID, Data],
					Instrument -> Link[Object[Instrument, Diffractometer, "Rosalind"]],
					DateCreated -> Now,
					ExperimentType -> Powder,
					BeamPower -> 1200*Watt,
					Current -> 30*Milliampere,
					Voltage -> 40*Kilovolt,
					ExposureTime -> 0.5*Second,
					Replace[SamplesIn] -> {Link[sample1, Data]},
					Replace[SamplesOut] -> {Link[sample3, Data]}
				|>,
				<|
					Object -> dataIDs[[2]],
					Type -> Object[Data, XRayDiffraction],
					DeveloperObject -> True,
					Name -> "PowderXRD Data Object 2",
					DiffractionSpectrum -> dataQuantityArrays[[2]],
					Protocol -> Link[protID, Data],
					Instrument -> Link[Object[Instrument, Diffractometer, "Rosalind"]],
					DateCreated -> Now,
					ExperimentType -> Powder,
					BeamPower -> 1200*Watt,
					Current -> 30*Milliampere,
					Voltage -> 40*Kilovolt,
					ExposureTime -> 0.5*Second,
					Replace[SamplesIn] -> {Link[sample2, Data]},
					Replace[SamplesOut] -> {Link[sample4, Data]}
				|>,
				<|
					Object -> dataIDs[[3]],
					Type -> Object[Data, XRayDiffraction],
					DeveloperObject -> True,
					Name -> "PowderXRD Data Object Including Replicates",
					DiffractionSpectrum -> dataQuantityArrays[[1]],
					Replace[Replicates] -> {Link[dataIDs[[2]], Replicates]},
					Protocol -> Link[protID, Data],
					Instrument -> Link[Object[Instrument, Diffractometer, "Rosalind"]],
					DateCreated -> Now,
					ExperimentType -> Powder,
					BeamPower -> 1200*Watt,
					Current -> 30*Milliampere,
					Voltage -> 40*Kilovolt,
					ExposureTime -> 0.5*Second,
					Replace[SamplesIn] -> {Link[sample1, Data]},
					Replace[SamplesOut] -> {Link[sample3, Data]}
				|>
			};

			Upload[Flatten[{
				<|Object -> #, DeveloperObject -> True|>& /@ {crystallizationPlate1, container1, sample1, container2, sample2},
				<|
					Object -> protID,
					Type -> Object[Protocol, PowderXRD],
					DeveloperObject -> True,
					Name -> "Fake PowderXRD protocol for PlotPowderXRD tests",
					CrystallizationPlate -> Link[crystallizationPlate1],
					PlateFileName -> "executeTest",
					Instrument -> Link[Object[Instrument, Diffractometer, "Rosalind"]],
					Current -> 30*Milliampere,
					Replace[ExposureTimes] -> {0.5*Second, 0.5*Second},
					Replace[SamplesIn] -> {
						Link[sample1, Protocols],
						Link[sample2, Protocols]
					},
					Replace[WorkingSamples] -> {
						Link[sample1],
						Link[sample2]
					},
					Replace[ContainersIn] -> {
						Link[container1, Protocols],
						Link[container2, Protocols]
					},
					Replace[WorkingContainers] -> {
						Link[container1],
						Link[container2]
					},
					ActiveCart -> Link[fakeCart],
					Replace[Resources] -> {
						Link[sample1, CurrentProtocol],
						Link[sample2, CurrentProtocol],
						Link[container1, CurrentProtocol],
						Link[container2, CurrentProtocol],
						Link[crystallizationPlate1, CurrentProtocol]
					},
					Replace[SamplesInStorage] -> {Refrigerator, Null},
					Replace[SamplesOutStorage] -> {Refrigerator, Refrigerator},
					Replace[MethodFilePaths] -> {
						FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "XtalCheckQ1.par"}],
						FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "XtalCheckQ3.par"}]
					},
					Replace[DataFilePaths] -> {
						FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A1_D1", "Thu-Jan-24-17-02-25-2019_Q1", "plots_red", "practiceFile"}],
						FileNameJoin[{$TemporaryDirectory, "Data", "XRD", "executeTest", "A2_D1", "Thu-Jan-24-17-02-25-2019_Q3", "plots_red", "practiceFile"}]
					}
				|>,
				dataPackets
			}]];
			AnalyzePeaks[Object[Protocol, PowderXRD, "Fake PowderXRD protocol for PlotPowderXRD tests"], Name -> "Fake PowderXRD Peak Analysis"]
		]
	},
	SymbolTearDown :> {
		Module[{testObjs, existingObjs},
			testObjs = {
				Object[Container, OperatorCart, "Fake cart for PlotPowderXRD tests"],
				Object[Container, Vessel, "Fake container 1 for PlotPowderXRD tests"],
				Object[Container, Vessel, "Fake container 2 for PlotPowderXRD tests"],
				Object[Container, Plate, "Fake crystallization plate for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 1 for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 2 for PlotPowderXRD tests"],
				Object[Protocol, PowderXRD, "Fake PowderXRD protocol for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 3 for PlotPowderXRD tests"],
				Object[Sample, "Fake sample 4 for PlotPowderXRD tests"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object 1"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object 2"],
				Object[Data, XRayDiffraction, "PowderXRD Data Object Including Replicates"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis 2"],
				Object[Analysis, Peaks, "Fake PowderXRD Peak Analysis 3"]
			};
			existingObjs = PickList[testObjs, DatabaseMemberQ[testObjs]];
			EraseObject[existingObjs, Force -> True]
		]
	}
];
