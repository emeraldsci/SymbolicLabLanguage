(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeDownsampling*)


(* Define Tests *)
DefineTests[AnalyzeDownsampling,
	{
		(*** Basic Usage ***)
		Example[{Basic,"Downsample the IonAbundance3D field in a ChromatographyMassSpectra data object and store the result in a Downsampling analysis object:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{5 Second,0.2 Gram/Mole}
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Example[{Basic,"Downsample the IonAbundance3D field in a ChromatographyMassSpectra data object and extract the sparse array and sampling points directly into the notebook:"},
			Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{5 Second,0.2 Gram/Mole},
					Upload->False
				],
				DownsampledData
			],
			_SparseArray
		],
		(*** Options ***)
		Example[{Options,DownsamplingRate,"Specify the downsampling rate to use, using None to specify no downsampling should be done in a dimension. Data will be downsampled so that the spacing of the downsampled data is greater than or equal to these specifications:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{None,0.5 Gram/Mole}
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Test["Downsampling only X direction produces correct dimensions:",
			Dimensions@Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{5 Second,None},
					Upload->False
				],
				DownsampledData
			],
			{14,8689}
		],
		Test["Downsampling only Y direction produces correct dimensions:",
			Dimensions@Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{None,0.2 Gram/Mole},
					Upload->False
				],
				DownsampledData
			],
			{543,4345}
		],
		Test["Downsampling in both the X and Y directions produces correct dimensions:",
			Dimensions@Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{5 Second,0.2 Gram/Mole},
					Upload->False
				],
				DownsampledData
			],
			{14,4345}
		],
		Example[{Options,ReorderDimensions,"Swap the X and Y dimensions in a data object containing 3D data as a list of {x,y,z} data points:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object 2 for AnalyzeDownsampling"],
				IonAbundance3D,
				ReorderDimensions->{2,1,3}
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Test["Reorder dimensions correctly swaps dimensions:",
			Dimensions@Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object 2 for AnalyzeDownsampling"],
					IonAbundance3D,
					ReorderDimensions->{2,1,3},
					Upload->False
				],
				DownsampledData
			],
			{503,8785}
		],
		Example[{Options,DownsamplingFunction,"Specify what function to use when reducing data points which get downsampled to the same point:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{5 Second,0.2 Gram/Mole},
				DownsamplingFunction->{Total,Max}
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Example[{Options,NoiseThreshold,"Specify a threshold for sparsification. Input data with a downsapmled Z-value (dependent variable, e.g intensity) smaller than this threshold will be treated as zero:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				NoiseThreshold->31337
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Example[{Options,NoiseThreshold,"Setting NoiseThreshold->Automatic is equivalent to using OtsuThreshold, which uses a threshold which clusters log-intensity values into noise and non-noise groups:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				NoiseThreshold->OtsuThreshold
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Test["Noise threshold of test data is in the correct range:",
			Lookup[
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					Upload->False
				],
				NoiseThreshold
			],
			1.5578151741502678`*10^6,
			EquivalenceFunction->RoundMatchQ[6]
		],
		Example[{Options,Template,"Set the Template option to use the resolved options from an existing downsampling analysis:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				Template->Object[Analysis,Downsampling,"Downsampling Template for AnalyzeDownsampling testing"]
			],
			ObjectP[Object[Analysis,Downsampling]]
		],
		Test["Template inherits options from the template analysis object:",
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				Template->Object[Analysis,Downsampling,"Downsampling Template for AnalyzeDownsampling testing"],
				Upload->False,
				Output->Options
			],
			{
				DownsamplingRate -> {Quantity[5, "Seconds"],Quantity[0.2, ("Grams")/("Moles")]},
				DownsamplingFunction -> {Total, Max},
				NoiseThreshold -> 7.11720815313791`*^6,
				ReorderDimensions -> Null,
				LoadingBars -> False,
				Template -> Object[Analysis, Downsampling, "Downsampling Template for AnalyzeDownsampling testing"]
			}
		],
		Example[{Options,LoadingBars,"True indicates that loading bars should be shown during evaluation. Note that for very long computations, loading bars may have a small negative impact on performance:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				LoadingBars->True
			],
			ObjectP[Object[Analysis,Downsampling]]
		],

		(*** Messages ***)
		Example[{Messages,"FieldNotFound","Show an error and return $Failed if the requested field to downsample either cannot be downloaded:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				Taco
			],
			$Failed,
			Messages:>{Error::FieldNotFound}
		],
		Example[{Messages,"InvalidDataFormat","Show an error and return $Failed if the requested field to downsample was downloaded, but did not resolve to a list of data points:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object 2 for AnalyzeDownsampling"],
				DateCreated
			],
			$Failed,
			Messages:>{Error::InvalidDataFormat}
		],
		Example[{Messages,"UnsupportedDimension","AnalyzeDownsampling only suppors two- and three-dimensional data:"},
			$Failed,
			$Failed
		],
		Example[{Messages,"InvalidReordering","Show an error and return $Failed if the indices requested for reordering dimension are not consecutive indices in range (e.g. for 3 dimensional data, some permutation of {1,2,3}):"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				ReorderDimensions->{4,5,6}
			],
			$Failed,
			Messages:>{Error::InvalidReordering}
		],
		Example[{Messages,"UnevenData3D","The resolved input data must be evenly spaced in its first dimension. If it is not, additional pre-processing is required before downsampling can be performed:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				ReorderDimensions->{3,1,2}
			],
			$Failed,
			Messages:>{Error::UnevenData3D}
		],
		Example[{Messages,"InvalidDownsamplingSpec","Show and error and return $Failed if the downsampling rate specification is not a list of length n-1, where n is the dimensionality of input data:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{1 Second, 1 Second, 1 Second, 1 Second}
			],
			$Failed,
			Messages:>{Error::InvalidDownsamplingSpec}
		],
		Example[{Messages,"InvalidDownsamplingSpec","Show and error and return $Failed if the downsampling function specification is not a list of length n-1, where n is the dimensionality of input data:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingFunction->{Mean}
			],
			$Failed,
			Messages:>{Error::InvalidDownsamplingSpec}
		],
		Example[{Messages,"IncompatibleUnits","Show a warning and strip units if the provided downsampling rate has incompatible units with the input data:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{0.01 Joule,None}
			],
			ObjectP[Object[Analysis,Downsampling]],
			Messages:>{Warning::IncompatibleUnits}
		],
		Example[{Messages,"DownsamplingRateTooSmall","Show a warning and default to no downsampling if the provided downsampling rate is smaller than the data spacing in that dimension:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{1 Microsecond,None}
			],
			ObjectP[Object[Analysis,Downsampling]],
			Messages:>{Warning::DownsamplingRateTooSmall}
		],
		Example[{Messages,"DownsamplingRateTooLarge","Show a warning and default to no downsampling if the provided downsampling rate is larger the span of data in that dimension:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{1 Year,None}
			],
			ObjectP[Object[Analysis,Downsampling]],
			Messages:>{Warning::DownsamplingRateTooLarge}
		],
		Example[{Messages,"LongComputation","Show a warning if the input data object is large and the calculation is expected to take more than a few minutes:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "id:M8n3rx06AY5R"],
				IonAbundance3D,
				Upload->False
			],
			PacketP[Object[Analysis,Downsampling]],
			Messages:>{Warning::LongComputation}
		],
		Example[{Messages,"DebugEcho","Developer error messages used only when downsampling jobs are run remotely on Manifold:"},
			True,
			True,
			Message:>{Error::DebugEcho}
		],
		Example[{Options,Streaming,"When raw data is large, use Streaming option to stream data during downsampling:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{5 Second,0.2 Gram/Mole},
				Streaming->True
			],
			ObjectP[Object[Analysis,Downsampling]],
			TimeConstraint -> 500
		],
		Example[{Options,Parallel,"When raw data file is large, downsampling can be carried out on manifold in parallel:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{5 Second,0.2 Gram/Mole},
				Streaming->True,
				Parallel->True
			],
			ObjectP[Object[Analysis,Downsampling]],
			Stubs:>{
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{5 Second,0.2 Gram/Mole},
					Streaming->True,
					Parallel->True
				]=Module[{obj,objID,p1,p2,lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink,downsamplePacket,finalDSObj},
					obj=Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"];
					objID=obj[ID];
					field=IonAbundance3D;
					p1=Quiet[Analysis`Private`downsamplingByParts[obj,field,DownsamplingRate->{5 Second,(0.2` Gram)/Mole},Range->{1,648354}]];
					p2=Quiet[Analysis`Private`downsamplingByParts[obj,field,DownsamplingRate->{5 Second,(0.2` Gram)/Mole},Range->{648654,1296708}]];
					{lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink}=Analysis`Private`combineParallelParts[obj,{p1,p2},2];
					downsamplePacket=Association@@Join[
						{Author->Link[Object[User,"Test user for notebook-less test protocols"]],UnresolvedOptions->{DownsamplingRate->{Quantity[5,"Seconds"],Quantity[0.2`,("Grams")/("Moles")]}}},
						{
							Type->Object[Analysis,Downsampling],
							Replace[Reference]->Link[obj,DownsamplingAnalyses],
							ReferenceField->field,
							ResolvedOptions->resolvedDownsamplingOptions,
							Replace[OriginalDimension]->{1,2,3},
							Replace[DataUnits]->{Quantity[1, "Minutes"], Quantity[1, "Grams"/"Moles"], Quantity[1, IndependentUnit["ArbitraryUnits"]]},
							Replace[SamplingGridPoints]->Append[lastRanges,Null],
							NoiseThreshold->finalNoiseThreshold,
							DownsampledData->lastDS,
							DownsampledDataFile->cloudFileLink
						}];
					finalDSObj=Upload[downsamplePacket];
					Upload[Association[Object->obj,Replace[DownsamplingAnalyses]->{Link[finalDSObj,Reference]}]];
					finalDSObj
				]
			},
			TimeConstraint -> 1000
		],
		Example[{Options,Threads,"The number of parallel processing threads can be specified:"},
			AnalyzeDownsampling[
				Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
				IonAbundance3D,
				DownsamplingRate->{5 Second,0.2 Gram/Mole},
				Streaming->True,
				Parallel->True,
				Threads->3
			],
			ObjectP[Object[Analysis,Downsampling]],
			Stubs:>{
				AnalyzeDownsampling[
					Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"],
					IonAbundance3D,
					DownsamplingRate->{5 Second,0.2 Gram/Mole},
					Streaming->True,
					Parallel->True,
					Threads->3
				]=Module[{obj,objID,p1,p2,p3,lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink,downsamplePacket,finalDSObj},
					obj=Object[Data, ChromatographyMassSpectra, "Test Object for AnalyzeDownsampling"];
					objID=obj[ID];
					field=IonAbundance3D;
					p1=Quiet[Analysis`Private`downsamplingByParts[obj,field,DownsamplingRate->{5 Second,(0.2` Gram)/Mole},Range->{1,432236}]];
					p2=Quiet[Analysis`Private`downsamplingByParts[obj,field,DownsamplingRate->{5 Second,(0.2` Gram)/Mole},Range->{432236,864472}]];
					p3=Quiet[Analysis`Private`downsamplingByParts[obj,field,DownsamplingRate->{5 Second,(0.2` Gram)/Mole},Range->{864472,1296708}]];
					{lastDS,resolvedDownsamplingOptions,lastRanges,finalNoiseThreshold,cloudFileLink}=Analysis`Private`combineParallelParts[obj,{p1,p2,p3},3];
					downsamplePacket=Association@@Join[
						{Author->Link[Object[User,"Test user for notebook-less test protocols"]],UnresolvedOptions->{DownsamplingRate->{Quantity[5,"Seconds"],Quantity[0.2`,("Grams")/("Moles")]}}},
						{
							Type->Object[Analysis,Downsampling],
							Replace[Reference]->Link[obj,DownsamplingAnalyses],
							ReferenceField->field,
							ResolvedOptions->resolvedDownsamplingOptions,
							Replace[OriginalDimension]->{1,2,3},
							Replace[DataUnits]->{Quantity[1, "Minutes"], Quantity[1, "Grams"/"Moles"], Quantity[1, IndependentUnit["ArbitraryUnits"]]},
							Replace[SamplingGridPoints]->Append[lastRanges,Null],
							NoiseThreshold->finalNoiseThreshold,
							DownsampledData->lastDS,
							DownsampledDataFile->cloudFileLink
						}];
					finalDSObj=Upload[downsamplePacket];
					Upload[Association[Object->obj,Replace[DownsamplingAnalyses]->{Link[finalDSObj,Reference]}]];
					finalDSObj
				]
			},
			TimeConstraint -> 2000
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{$CreatedObjects={}},

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*streamAndUploadAbsorbanceSlices*)


(* Define Tests *)
DefineTests[streamAndUploadAbsorbanceSlices,
	{
		(*** Basic Usage ***)
		Example[{Basic,"Stream and upload Absorbance slices of multiple Object[Data,ChromatographyMassSpectra]:"},
			(streamAndUploadAbsorbanceSlices[{
				Object[Data, ChromatographyMassSpectra, "id:E8zoYvNZ1oAB"],
				Object[Data, ChromatographyMassSpectra, "id:n0k9mG8Eo9Aw"]
			}];
			Download[
				{Object[Data, ChromatographyMassSpectra, "id:E8zoYvNZ1oAB"], Object[Data, ChromatographyMassSpectra, "id:n0k9mG8Eo9Aw"]},
				Absorbance
			]),
			{QuantityArrayP[]..}
		],
		Example[{Basic,"Stream and upload Absorbance slices of all the data from one LCMS protocol:"},
			(streamAndUploadAbsorbanceSlices[Object[Protocol, LCMS, "id:4pO6dM5RYaxz"]];
			Download[Object[Protocol, LCMS, "id:4pO6dM5RYaxz"], Data[Absorbance]]),
			{QuantityArrayP[]..}
		],
		Example[{Basic,"Stream and upload Absorbance slices of all the data from one Object[Data,ChromatographyMassSpectra]:"},
			(streamAndUploadAbsorbanceSlices[Object[Data, ChromatographyMassSpectra, "id:lYq9jRxlG9E4"]];
			Download[Object[Data, ChromatographyMassSpectra, "id:lYq9jRxlG9E4"], Absorbance]),
			QuantityArrayP[]
		]
	},

	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>{$CreatedObjects={}},

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];
