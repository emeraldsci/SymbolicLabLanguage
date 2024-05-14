(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*CellCount: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*Main Functions*)

(* ::Subsubsection:: *)
(*AnalyzeCellCount*)


DefineTests[AnalyzeCellCount,

	{

		(* Basic *)

		Example[{Basic,"Confluency measurement using a short-hand notation, MeasureConfluency->True:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
					ImageAdjustment->{ImageAdjust[Correction->{0,20}]},
					ImageSelection->{ImageSelect[ImagingSite->7]},
					MeasureConfluency->True
				],
				Confluency
			],
			{18.62676441669464` Percent},
			EquivalenceFunction->RoundMatchQ[12]
		],

		Example[{Basic,"Visualize the area covered by cells which is used for confluency measurement:"},
			AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				ImageScale->0.679 Micrometer/Pixel,
				Output->Preview
			],
			_Pane|_DynamicModule,
			Stubs:>{
				AnalyzeCellCount[
					myLowDensityConfluencyMeasurementCloudFile,
					MeasureConfluency->True,
					ImageScale->0.679 Micrometer/Pixel,
					Output->Preview
				]=DynamicModule[{localSymbol},
					AnalyzeCellCount[
						myLowDensityConfluencyMeasurementCloudFile,
						MeasureConfluency->True,
						ImageScale->0.679 Micrometer/Pixel,
						PreviewSymbol->localSymbol,
						Output->Preview
					]
				]
			}
		],

		Example[{Basic,"Count cell numbers for a hemocytometer images stored in a microscope data object and selecting all steps automatically:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
					Hemocytometer->True,
					HemocytometerSquarePosition->{1,1},
					MinCellRadius->2 Pixel,
					MaxCellRadius->6 Pixel,
					PropertyMeasurement->{
						AreaProperties,Centroid,PerimeterProperties
					}
				],
				ComponentDiameter
			],
			{{Quantity[13.430081684687499`,"Micrometers"],Quantity[8.580164454381757`,"Micrometers"],Quantity[17.37350887021296`,"Micrometers"],
				Quantity[17.160328908763514`,"Micrometers"],Quantity[18.402402601168315`,"Micrometers"],Quantity[8.998952398510607`,"Micrometers"],
				Quantity[8.998952398510607`,"Micrometers"],Quantity[11.350490677165164`,"Micrometers"],Quantity[20.752649206204534`,"Micrometers"],
				Quantity[16.944467122058487`,"Micrometers"],Quantity[12.726440529123593`,"Micrometers"],Quantity[13.430081684687499`,"Micrometers"],
				Quantity[11.350490677165164`,"Micrometers"]}},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint->600
		],

		Example[{Basic,"Segmentation of tissue culture cells using the default algorithm:"},
			AnalyzeCellCount[
				microscopeDense,
				ImageScale->0.66 Micrometer/Pixel,
				Output->Preview
			],
			_DynamicModule,
			Stubs:>{
				AnalyzeCellCount[
					microscopeDense,
					ImageScale->0.66 Micrometer/Pixel,
					Output->Preview
				]=DynamicModule[{localSymbol2},
					AnalyzeCellCount[
						microscopeDense,
						ImageScale->0.66 Micrometer/Pixel,
						PreviewSymbol->localSymbol2,
						Output->Preview
					]
				]
			}
		],

		(*Test failed on local RunUnitTest but passed ManifoldRunUnitTest.
		Calculated value is 38.3838% locally. Might due to version difference.
		*)
		Example[{Basic,"Measure the viability of the cells from the colored image:"},
			Download[
				AnalyzeCellCount[
					myTrypanCloudFile,
					MeasureCellViability->True,
					CellViabilityThreshold->0.45
				],
				CellViability
			],
			{38. Percent},
			(* depending on MM version we get numerical differences that waffle the number to either 38.3% and 37.7%. this is
			due to an underlying cell count being either 38 or 39, so the percent difference ends up being dramatic, but there's really a small change in the numerical classification *)
			EquivalenceFunction->RoundMatchQ[2],
			TimeConstraint->600
		],

		(** Additional **)

		Example[{Additional,"Interactive apps","Open AnalyzeCellCount in the command builder to access the interactive app for manual counting:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Method->Manual,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],
		Example[{Additional,"Interactive apps","Open AnalyzeCellCount in the command builder to access the interactive app for image selection:"},
			Defer@AnalyzeCellCount[
				Object[Data,Microscope,"id:wqW9BP7DOv04"],
				ImageSelection->Preview,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		Example[{Additional,"Hemocytometer processing steps","A: The adjustment steps are:
     1- increasing the brightness of the image (given our camera setup the images are a little dark) and
     2- trimming the image to select a sepecific square in the hemocytometer grid which depending on the type of the grid, is a pair of number {r,c} where r and c are between 1-3 or 1-4. In this case we are selecting square position {1,3}. The pixel coordinates can be determined by first plotting the input like PlotImage[myCloudFile]:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					ImageAdjustment->{
						ImageAdjust[Correction->{0,2}],
						ImageTrim[ROI->{{85,1409},{669,1995}}]
					},
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				AreaProperties
			],
			{_Association..},
			TimeConstraint->600
		],

		Example[{Additional,"Hemocytometer processing steps","B: As for the standard segmentation procedure, we perform:
      1- edge detection for the adjusted image so we will detect the contours of all components,
      2- we close the detected lines (all circles) using Closing primitive which calls mathematica's Closing,
      3,4- We perform dilation and erosion with the same kernel so for the detected components any holes will be filled remove any extremely small component will be removed:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				ImageSegmentation->{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Dilation[Kernel->DiskMatrix[2]],
					Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		Example[{Additional,"Hemocytometer processing steps","C: After we find all components we need to remove the hemocytometer grid lines. For that we first use ridge filter to detect the grid lines and then binarize and finally remove the detected lines:
      5- Use RidgeFilter to further use to find the mask (background grid) and ImageAdjust ing the result,
      6- MorphologicalBinarize the result of ridge filter with a low threshold (0.05-0.5) to find the background grid mask,
      7- Remove the background grid using Inpaint with the method Diffusion which is a compromise between time and quality:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				ImageSegmentation->{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		Example[{Additional,"Hemocytometer processing steps","D: Finally after removing the background grid lines, we use a standard process to avoid any overlap between the cells. This is done by first finding the distance of the cell boundary relative to their centers and then using watershed algorithm:
      8- Find the distance transform which normalize the pixels according to their distance to edges of black and white boundary,
      9- Find the maximum of the distance transform which indicates the centers of the components,
      10- Find the regions of rapid pixel value change with gradient filter to indicate the regions associated with the components,
      11- Finally perform the watershed algorithm on the result of the gradient filter with the marker set as the result of MaxDetect:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				ImageSegmentation->{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"],
					DistanceTransform[Image->"inpainted",Padding->0,ImageAdjust->True],
					MaxDetect[Height->0.02,OutputImageLabel->"marker"],
					GradientFilter[Image->"inpainted",GaussianParameters->3],
					WatershedComponents[Marker->"marker",Method->Basins],
					SelectComponents[]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		Example[{Additional,"Confluency measurement steps","A: The adjustment only contains brightening the image by two levels (each pixel intensity value increased by twice its pixel intensity value):"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				ImageAdjustment->{
					ImageAdjust[Correction->{0,2}]
				},
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Confluency measurement steps","B: For the segmentation, we perform standard deviation filter to detect the more homogenous regions which are the cell free medium:"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				ImageSegmentation->{
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True],
					Binarize[Threshold->0.1]
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Confluency measurement steps","C: We perform the denuded area (cell-free zone) detection with two standard deviation sizes and call them small and big window:
      1- standard deviation filter with a small window,
      2- binarize the image using the small window filtered image,
      3- standard deviation filter using a big window,
      4- binarize the image using the big window filtered image,
      5- dilate the binarized image with big window:"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				ImageSegmentation->{
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
					Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"]
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Confluency measurement steps","D: Finally, we determine the intersect of the cellular regions to indicate our final culture cell area and will perform a subsequent closing and opening to remove any holes and very small components:
      1- standard deviation filter with a small window,
      2- binarize the image using the small window filtered image,
      3- standard deviation filter using a big window,
      4- binarize the image using the big window filtered image,
      5- dilate the binarized image with big window,
      6- find the intersect of the dilated image with the small window binaized,
      7- perform closing followed by opening with the intersect result:"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				ImageSegmentation->{
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
					StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
					Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
					ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
					Closing[Kernel->ConstantArray[1,{6,6}]],
					Opening[Kernel->ConstantArray[1,{6,6}]]
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Confluency measurement for multiple sites","Measuring the confluency of multiple sites in a data object and with a more aggressive brightening:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				MeasureConfluency->True,
				ImageSelection->{ImageSelect[ImagingSite->1;;2]},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				},
				Output->Preview
			],
			_Defer
		],

		(* Nuclear labeling *)

		Example[{Additional,"Neat examples for cell segmentation","A: Segmenting the cells that are stained in one channel:"},
			Defer@AnalyzeCellCount[
				myNuclearLabelingMainCloudFile,
				ImageAdjustment->{
					ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
					BilateralFilter[Radius->1,PixelValueSpread->1/12]
				},
				ImageSegmentation->{
					MorphologicalBinarize[OutputImageLabel->"imageBackground"],
					LaplacianGaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
					MinDetect[OutputImageLabel->"extendedMinima"],
					ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
					WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
				},
				PropertyMeasurement->{
					Area,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Neat examples for cell segmentation","B: Standard segmentation of red blood cells taken from the mathematica guide pages:"},
			Defer@AnalyzeCellCount[
				myRBCCloudFile,
				ImageAdjustment->{
					Binarize[],
					ColorNegate[]
				},
				ImageSegmentation->{
					DistanceTransform[OutputImageLabel->"distance transform"],
					MaxDetect[Height->1,OutputImageLabel->"marker"],
					WatershedComponents[Image->"distance transform",Marker->"marker",ColorNegate->True,BitMultiply->"ImageAdjustment Result"]
				},
				PropertyMeasurement->{
					Area,Centroid
				},
				HighlightedCellsFormat->Colorize,
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Neat examples for cell segmentation","C: Analyzing the deformation and morphology of the detected RBCs. We extract echinocytes cells by selecting cells of a certain size that exhibit tentacles of more than 5% of their total area:"},
			Defer@AnalyzeCellCount[
				myRBCCloudFile,
				ImageAdjustment->{
					Binarize[],
					ColorNegate[]
				},
				ImageSegmentation->{
					DistanceTransform[OutputImageLabel->"distance transform"],
					MaxDetect[Height->1,OutputImageLabel->"marker"],
					WatershedComponents[Image->"distance transform",Marker->"marker",ColorNegate->True,BitMultiply->"ImageAdjustment Result",OutputImageLabel->"segments"],
					Image[Image->"segments",Type->Bit,OutputImageLabel->"mask"],
					TopHatTransform[Image->"mask",Kernel->DiskMatrix[8],OutputImageLabel->"spikes"],
					SelectComponents[Image->{"spikes","segments"},Criteria->(500<#Area<1500&&0.05<#Mean<1 &)]
				},
				PropertyMeasurement->{
					Area,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Neat examples for cell segmentation","Segmentation of Epifluorescence channel of Mammalian, HeLa-dsRed/GFP model cells:"},
			Defer@AnalyzeCellCount[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"],
				Images->{
					MicroscopeImage[
						InputObject->Automatic,
						Mode->Epifluorescence,
						ObjectiveMagnification->10.,
						ImageTimepoint->1,
						ImageZStep->1,
						ImagingSite->3,
						ExcitationWavelength->405. Nanometer,
						EmissionWavelength->452. Nanometer,
						DichroicFilterWavelength->421. Nanometer,
						ExcitationPower->100. Percent,
						TransmittedLightPower->Null,
						ExposureTime->73.21 Millisecond,
						FocalHeight->10947.1 Micrometer,
						ImageBitDepth->16,
						PixelBinning->1,
						ImagingSiteRow->1,
						ImagingSiteColumn->3
					]
				},
				Output->Preview
			],
			_Defer
		],

		Example[{Additional,"Neat examples for cell segmentation","Segmentation of small sparse tissue culture cells using the default algorithm:"},
			Defer@AnalyzeCellCount[
				{microscopeSmallSparse,microscopeMediumSparse},
				ImageScale->0.66 Micrometer/Pixel,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		Example[{Additional,"Viability measurement","Measure the viability of the cells from the colored image where blue indicates dead cells:"},
			Defer@AnalyzeCellCount[
				myTrypanCloudFile,
				MeasureCellViability->True,
				CellViabilityThreshold->0.45,
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		(** Options **)

		(* Method *)
		Example[{Options,Method,"Manual counting pane as the preview specifically used for user builder interaction:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Method->Manual,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		(* Hemocytometer *)

		Example[{Options,Hemocytometer,"Explicitly informing that the raw image is taken from a hemocytometer instrument:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					HemocytometerSquarePosition->{1,3},
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfComponents
			],
			{28.},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint->600
		],
		Example[{Options,Hemocytometer,"If a data object is given, the hemocytometer will be populated based on the data object protocol's ContaintersIn field:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[2]],
				Hemocytometer->Automatic,
				HemocytometerSquarePosition->{1,3},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				Output->Options
			],
			ops_/;Lookup[ops,Hemocytometer],
			TimeConstraint->600
		],
		Example[{Options,Hemocytometer,"Cell count analysis of a hemocytometer image with a short-hand notation, Hemocytometer->True:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					HemocytometerSquarePosition->{1,3}
				],
				NumberOfComponents
			],
			{28.},
			EquivalenceFunction->RoundMatchQ[12],
			TimeConstraint->600
		],

		Example[{Options,GridPattern,"Explicitly informing that the grid pattern of the hemocytometer from the data object which affects the default square specification:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[2]],
				Hemocytometer->True,
				GridPattern->Burker,
				HemocytometerSquarePosition->{1,3},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,GridPattern],Burker],
			TimeConstraint->600
		],
		Example[{Options,GridPattern,"Automatically specifying the grid pattern from the Object[Container,Hemocytometer] in the field ContainersIn of the protocol object:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[2]],
				GridPattern->Automatic,
				HemocytometerSquarePosition->{1,3},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,GridPattern],Neubauer],
			TimeConstraint->600
		],

		Example[{Options,HemocytometerSquarePosition,"Explicitly informing the square position to use for counting the cells of the hemocytometer. By default {1,1} which is the left bottom square will be selected:"},
			Mean[First[
				Download[
					AnalyzeCellCount[
						Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[2]],
						MinCellRadius->3 Pixel,
						HemocytometerSquarePosition->{1,3}
					],
					ComponentAreaDistribution
				]
			]],
			275.646 Micrometer^2,
			EquivalenceFunction->RoundMatchQ[3],
			TimeConstraint->600
		],

		(* Confluency measurement *)

		Example[{Options,MeasureConfluency,"Explicitly provide the MeasureConfluency master switch to automatically determine the adjustment and segmentation steps:"},
			Download[
				AnalyzeCellCount[
					myLowDensityConfluencyMeasurementCloudFile,
					MeasureConfluency->True
				],
				Confluency
			],
			{21.84130847454071` Percent},
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Options,MeasureConfluency,"For the CellType Mammalian and CultureAdhesion Adherent, the MeasureConfluency is set to True:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				MeasureConfluency->True,
				ImageSelection->{
					ImageSelect[ImagingSite->7]
				},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				},
				ImageSegmentation->{
					StandardDeviationFilter[Image->"adjusted",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
					StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
					Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
					Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
					ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
					Closing[Kernel->ConstantArray[1,{6,6}]],
					Opening[Kernel->ConstantArray[1,{6,6}]]
				},
				Output->Preview
			],
			_Defer
		],

		(* Specifying cell type or culture adhesion type *)

		Example[{Options,CellType,"Explicitily specifying the type of the cell:"},
			AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				CellType->Mammalian,
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,CellType],Mammalian]
		],
		Example[{Options,CellType,"If set as Automatic for data object, it will be taken from the CellModels field of the data object if it is Bacterial, Mammalian, Yeast, Plant, or Insect:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				MeasureConfluency->True,
				CellType->Automatic,
				ImageSelection->{
					ImageSelect[ImagingSite->5]
				},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				},
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,CellType],Mammalian]
		],

		Example[{Options,CultureAdhesion,"Explicitly specifying the type of the type of cell adhesion to the substrate if it is adherent or suspension:"},
			AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				CellType->Mammalian,
				CultureAdhesion->Adherent,
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,CultureAdhesion],Adherent]
		],
		Example[{Options,CultureAdhesion,"If CultureAdhesion is Automatic and the input is a data object CultureAdhesion will be determined from the field CellModels:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				MeasureConfluency->True,
				CultureAdhesion->Automatic,
				ImageSelection->{
					ImageSelect[ImagingSite->5]
				},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				},
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,CultureAdhesion],Null]
		],

		Example[{Options,ImageScale,"Specifying the image scale if the input is not a data object:"},
			Download[
				AnalyzeCellCount[
					myLowDensityConfluencyMeasurementCloudFile,
					MeasureConfluency->True,
					ImageScale->0.679 Micrometer/Pixel
				],
				ComponentDiameter
			],
			componentDiameter_/;MatchQ[componentDiameter[[1]],6.200768013548644` Micrometer],
			EquivalenceFunction->RoundMatchQ[12]
		],

		(* Thresholding *)

		Example[{Options,IntensityThreshold,"Adding a criteria to exclude cells with fluoresent intensity less than the threshold:"},
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{3,3},
				IntensityThreshold->0.2,
				Output->Options
			],
			ops_/;MatchQ[Lookup[ops,IntensityThreshold],0.2],
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,AreaThreshold,"Adding a criteria to exclude cells smaller than 90 Pixel squared:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					ImageScale->0.679 Micrometer/Pixel,
					HemocytometerSquarePosition->{3,3},
					AreaThreshold->40 Micrometer^2,
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfComponents
			],
			{11.},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MinComponentRadius,"Adding a criteria to exclude components with radius smaller than 2 Pixels:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					HemocytometerSquarePosition->{3,1},
					MinComponentRadius->1.5 Micrometer,
					ImageScale->0.679 Micrometer/Pixel,
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfComponents
			],
			{20.},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MaxComponentRadius,"Adding a criteria to exclude components with radius larger than 10 Pixels:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					HemocytometerSquarePosition->{3,1},
					MaxComponentRadius->4 Micrometer,
					ImageScale->0.679 Micrometer/Pixel,
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfComponents
			],
			{10.},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MinCellRadius,"Specifying the minimum cell radius used for calculating the cell count distribution when there are multiple cells per component:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
					ImageSelection->{ImageSelect[ImagingSite->7]},
					MinCellRadius->2.5 Micrometer,
					MeasureConfluency->True,
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfCells
			],
			{NormalDistribution[731.4387438142031,215.12904229829505`]},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,MaxCellRadius,"Specifying the maximum cell radius used for calculating the cell count distribution when there are multiple cells per component:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
					ImageSelection->{ImageSelect[ImagingSite->7]},
					MinCellRadius->9.5 Micrometer,
					MeasureConfluency->True,
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfCells
			],
			{NormalDistribution[408.49075705786646`,6.978160107427454`]},
			EquivalenceFunction->RoundMatchQ[3]
		],

		(* Output format of the highlighted cells *)
		Example[{Options,HighlightedCellsFormat,"Showing cells using their contour:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{3,3},
				MaxCellRadius->10 Pixel,
				HighlightedCellsFormat->Contour,
				Output->Preview
			],
			_Defer
		],
		Example[{Options,HighlightedCellsFormat,"Showing cells with labeled circles:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{3,3},
				HighlightedCellsFormat->Circle,
				Output->Preview
			],
			_Defer
		],

		(*Test failed on local RunUnitTest but passed ManifoldRunUnitTest.
		Calculated value is 38.3838% locally. Might due to version difference.
		*)
		Example[{Options,MeasureCellViability,"Measure the viability of the cells:"},
			Download[
				AnalyzeCellCount[
					myTrypanCloudFile,
					MeasureCellViability->True,
					CellViabilityThreshold->0.45
				],
				CellViability
			],
			(* depending on MM version we get numerical differences that waffle the number to either 38.3% and 37.7%. this is
			due to an underlying cell count being either 38 or 39, so the percent difference ends up being dramatic, but there's really a small change in the numerical classification *)
			{38. Percent},
			EquivalenceFunction -> RoundMatchQ[2],
			TimeConstraint->600
		],

		Example[{Options,CellViabilityThreshold,"Measure the viability of the cells with specifying threshold:"},
			Download[
				AnalyzeCellCount[
					myTrypanCloudFile,
					MeasureCellViability->True,
					CellViabilityThreshold->0.44
				],
				CellViability
			],
			viability_/;MatchQ[viability,{GreaterP[30 Percent]}],
			TimeConstraint->600
		],

		(* Primitive sets *)

		Example[{Options,ImageSelection,"Explicitly provide the ImageSelection to select specific sites available in the data object:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
					MeasureConfluency->True,
					ImageSelection->{
						ImageSelect[ImagingSite->1]
					},
					ImageAdjustment->{
						ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
					}
				],
				Confluency
			],
			{22.85875976085663` Percent},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,Images,"Explicitly provide the image specification in the data object. This should be useful only to pick a specific item that is autopopulated by ImageSelection:"},
			Download[
				AnalyzeCellCount[
					Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
					MeasureConfluency->True,
					Images->{
						MicroscopeImage[InputObject->Automatic,Mode->BrightField,ObjectiveMagnification->10.,ImageTimepoint->1,
							ImageZStep->1,ImagingSite->10,ExcitationWavelength->Null,EmissionWavelength->Null,DichroicFilterWavelength->Null,
							ExcitationPower->Null,TransmittedLightPower->Quantity[20.,"Percent"],ExposureTime->Quantity[8.55,"Milliseconds"],
							FocalHeight->Quantity[9230.26,"Micrometers"],ImageBitDepth->16,PixelBinning->1,ImagingSiteRow->2,ImagingSiteColumn->5
						]
					},
					ImageAdjustment->{
						ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
					}
				],
				Confluency
			],
			{15.572705864906311` Percent},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,ImageAdjustment,"Explicitly provide the image adjustment steps including trimming the image:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					ImageAdjustment->{
						ImageAdjust[Correction->{0,2}],
						ImageTrim[ROI->{{85,1409},{669,1996}}]
					},
					PropertyMeasurement->{
						AreaProperties,Centroid
					}
				],
				NumberOfComponents
			],
			{28.},
			EquivalenceFunction->RoundMatchQ[3]
		],

		Example[{Options,ImageSegmentation,"Explicitly provide the image segmentation steps for confluency measurement of low density cultured cells:"},
			Download[
				AnalyzeCellCount[
					myLowDensityConfluencyMeasurementCloudFile,
					MeasureConfluency->True,
					ImageSegmentation->{
						StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
						Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
						StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
						Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
						Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
						ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
						Closing[Kernel->ConstantArray[1,{6,6}]],
						Opening[Kernel->ConstantArray[1,{6,6}]]
					}
				],
				Confluency
			],
			{21.84130847454071` Percent},
			EquivalenceFunction->RoundMatchQ[3]
		],
		Example[{Options,ImageSegmentation,"Explicitly provide the image segmentation steps for confluency measurement of high density cultured cells:"},
			Download[
				AnalyzeCellCount[
					myHighDensityConfluencyMeasurementCloudFile,
					MeasureConfluency->True,
					ImageSegmentation->{
						StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
						Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
						StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
						Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
						Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
						ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
						Closing[Kernel->ConstantArray[1,{6,6}]],
						Opening[Kernel->ConstantArray[1,{6,6}]]
					}
				],
				Confluency
			],
			{98.25343489646912` Percent},
			EquivalenceFunction->RoundMatchQ[3]
		],

		(* Property Measurement *)
		Example[{Options,PropertyMeasurement,"Measuring all properties associated with the pattern ComponentPropertiesAreaP, ComponentPropertiesPerimeterP, ComponentPropertiesCentroidP, ComponentPropertiesEllipseP:"},
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				PropertyMeasurement->{
					AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse
				},
				Upload->False
			],
			output_Association/;(MatchQ[Lookup[output,Replace[AreaProperties]],{(_Association)..}]&&Length[Lookup[output,Replace[AreaProperties]]]==28),
			EquivalenceFunction->RoundMatchQ[3]
		],

		(* Output *)
		Example[{Options,PlotProcessingSteps,"For plotting the results of all middle steps in the adjustment and segmentation of the images:"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				Upload->False,
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],

		(* Interactive app options *)
		Example[{Options,ManualCoordinates,"The manual coordinates stores the coordinates of the selected (clicked) cell positions:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Method->Manual,
				ManualCoordinates->{{{{500,500},{700,700}}}},
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],
		Example[{Options,NumberOfManualCells,"The number of manual cells is automatically calculated in the app after clicking Update Table button. This can be checked with PreviewValue[PreviewSymbol[AnalyzeCellCount], NumberOfManualCells].:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Method->Manual,
				ManualCoordinates->{{{{500,500},{700,700}}}},
				NumberOfManualCells->Null,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],
		Example[{Options,ManualSampleCellDensity,"The number of manual cells is automatically calculated in the app after clicking Update Table button. This can be checked with PreviewValue[PreviewSymbol[AnalyzeCellCount], ManualSampleCellDensity].:"},
			Defer@AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Method->Manual,
				ManualCoordinates->{{{{500,500},{700,700}}}},
				ManualSampleCellDensity->Null,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],
		Example[{Options,HistogramType,"Change the default histogram shown on the statistics panel:"},
			Defer@AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				HistogramType->ComponentArea,
				Output->Preview
			],
			_Defer,
			TimeConstraint->600
		],

		(* Template *)
		Example[{Options,Template,"Use a generated analysis object as the template:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Template->AnalyzeCellCount[
					(First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"]),
					Hemocytometer->True,
					HemocytometerSquarePosition->{1,3},
					PropertyMeasurement->{
						AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse
					},
					Upload->False
				]
			],
			ObjectP[Object[Analysis,CellCount]]
		],

		(** Messages **)
		Example[{Messages,"InvalidPrimitiveLabels","Requested label is not avaialable:"},
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				ImageAdjustment->{
					ImageAdjust[Image->"myLabel",Correction->{0,3}]
				}
			],
			$Failed,
			Messages:>{
				Message[Error::InvalidPrimitiveLabels,
					{ImageAdjust[Association[Image->"myLabel",Correction->{0,3}]]},{1},ImageAdjustment,{"myLabel"}
				],
				Message[Error::InvalidPrimitiveLabels,
					{ImageAdjust[Association[Image->"myLabel",OutputImageLabel->Null,Correction->{0,3},InputRange->Null,OutputRange->Null]]},{1},ImageSegmentation,{"myLabel"}
				],
				Message[Error::InvalidOption,Object[EmeraldCloudFile,"id:WNa4ZjK4Pm0R"]]
			}
		],

		Example[{Messages,"IncompleteMicroscopeImageKeys","The keys in the MicroscopeImage primitive is not complete:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[1]],
				MeasureConfluency->True,
				Images->{
					MicroscopeImage[
						InputObject->Link[Object[Data,Microscope,"id:xRO9n3B96b0Y"],Protocol,"wqW9BPDbNAYw"],ImageTimepoint->1,ImageZStep->1,ImagingSite->1
					]
				},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				}
			],
			$Failed,
			Messages:>{
				Message[Error::IncompleteMicroscopeImageKeys,
					Link[Object[Data,Microscope,"id:xRO9n3B96b0Y"],Protocol,"wqW9BPDbNAYw"],
					{
						DichroicFilterWavelength,EmissionWavelength,ExcitationPower,ExcitationWavelength,ExposureTime,
						FocalHeight,ImageBitDepth,ImagingSiteColumn,ImagingSiteRow,Mode,ObjectiveMagnification,PixelBinning,
						TransmittedLightPower
					}
				],
				Message[Error::InvalidOption,Link[Object[Data,Microscope,"id:xRO9n3B96b0Y"],Protocol,"wqW9BPDbNAYw"]]
			}
		],

		Example[{Messages,"SelectComponentsNotSpecified","SelectComponents is not specified to take the max radius into effect:"},
			Download[
				AnalyzeCellCount[
					myHemocytometerCloudFile,
					Hemocytometer->True,
					HemocytometerSquarePosition->{3,3},
					MaxComponentRadius->10 Pixel,
					ImageSegmentation->{
						EdgeDetect[Image->"ImageAdjustment Result"],
						Closing[Kernel->3],
						Dilation[Kernel->DiskMatrix[2]],
						Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
						RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
						MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
						Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"],
						DistanceTransform[Image->"inpainted",Padding->0,ImageAdjust->True],
						MaxDetect[Height->0.02,OutputImageLabel->"marker"],
						GradientFilter[Image->"inpainted",GaussianParameters->3],
						WatershedComponents[Marker->"marker",Method->Basins]
					}
				],
				NumberOfComponents
			],
			{25.},
			Messages:>{
				Message[Warning::SelectComponentsNotSpecified,Object[EmeraldCloudFile,"id:WNa4ZjK4Pm0R"],1]
			}
		],

		Example[{Messages,"InvalidImagesPrimitive","The primitives provided for images option do not correspond to a valid image in the data object:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				Images->{
					MicroscopeImage[InputObject->Automatic,Mode->BrightField,ObjectiveMagnification->10.,ImageTimepoint->1,
						ImageZStep->1,ImagingSite->10,ExcitationWavelength->Null,EmissionWavelength->Null,DichroicFilterWavelength->Null,
						ExcitationPower->Null,TransmittedLightPower->Quantity[20.1,"Percent"],ExposureTime->Quantity[8.55,"Milliseconds"],
						FocalHeight->Quantity[9230.26,"Micrometers"],ImageBitDepth->16,PixelBinning->1,ImagingSiteRow->2,ImagingSiteColumn->5
					]
				}
			],
			$Failed,
			Messages:>{
				Message[Error::InvalidImagesPrimitive,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"],1],
				Message[Error::InvalidOption,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"]]
			}
		],

		Example[{Messages,"InvalidMethod","Manual and Hybrid methods are used for hemocytometer images:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				Method->Manual
			],
			$Failed,
			Messages:>{
				Message[Error::InvalidMethod,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"]],
				Message[Error::InvalidOption,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"]]
			}
		],
		Example[{Messages,"InvalidNestedIndexMatchingOption","Pooled options should be indexed with the number of images in the object:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageSelection->{ImageSelect[ImagingSite->1;;2]},
				MinComponentRadius->{{3,4,5}*Micrometer}
			],
			$Failed,
			Messages:>{
				Message[Error::InvalidNestedIndexMatchingOption,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"],{MinComponentRadius},2],
				Message[Error::InvalidOption,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"]]
			}
		],
		Example[{Messages,"ConflictingComponentRadiusOptions","If the minimum component radius is larger than maximum:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageSelection->{ImageSelect[ImagingSite->1]},
				MinComponentRadius->3 Micrometer,
				MaxComponentRadius->2 Micrometer
			],
			ObjectP[Object[Analysis,CellCount]],
			Messages:>{
				Message[Warning::ConflictingComponentRadiusOptions,Link[Object[Data,Microscope,"id:6V0npvmnzjZ8"],Protocol,"J8AY5j4qnRzK"],1,3 Micrometer,2 Micrometer]
			}
		],
		Example[{Messages,"ConflictingCellRadiusOptions","If the minimum cell radius is larger than maximum:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageSelection->{ImageSelect[ImagingSite->1]},
				MinCellRadius->3 Micrometer,
				MaxCellRadius->2 Micrometer
			],
			ObjectP[Object[Analysis,CellCount]],
			Messages:>{
				Message[Warning::ConflictingCellRadiusOptions,3 Micrometer,2 Micrometer]
			}
		],
		Example[{Messages,"ConflictingDefaultCellRadius","If the minimum cell radius is larger than maximum. One is specified and the other is set to the default:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageSelection->{ImageSelect[ImagingSite->1]},
				MinCellRadius->3 Micrometer,
				MaxCellRadius->2 Micrometer
			],
			ObjectP[Object[Analysis,CellCount]],
			Messages:>{
				Message[Warning::ConflictingCellRadiusOptions,3 Micrometer,2 Micrometer]
			}
		],
		Example[{Messages,"ImagesNotAvailable","If the Images field is empty:"},
			AnalyzeCellCount[
				Object[Data,Microscope,"Empty microscope data" <> $SessionUUID]
			],
			$Failed,
			Messages:>{
				Error::ImagesNotAvailable,
				Error::InvalidInput
			}
		],
		Example[{Messages,"ConflictingAlgorithms","If the algorithms Hemocytometer and MeasureConfluency are set at the same time, the latter will be enforced to False:"},
			AnalyzeCellCount[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True,
				Hemocytometer->True
			],
			ObjectP[Object[Analysis,CellCount]],
			Messages:>{
				Message[Warning::ConflictingAlgorithms,Hemocytometer,MeasureConfluency,Object[EmeraldCloudFile,"id:n0k9mG8G8nNW"]]
			}
		],
		Example[{Messages,"UnusedSquarePosition","If Method is Manual or Hybrid, the HemocytometerSquarePosition is set to All:"},
			AnalyzeCellCount[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Hemocytometer->True,
				Method->Manual,
				HemocytometerSquarePosition->{1,2},
				Upload->False
			],
			_Association,
			Messages:>{
				Message[Warning::UnusedSquarePosition,Link[Object[Data,Microscope,"id:zGj91a796Bej"],Protocol,"bq9LA0ZjAbda"]]
			}
		],

		(** Tests **)

		(* Testing the output object *)
		Test["Testing the details of the output packet for a cellcount analysis of a hemocytometer raw image:",
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				ImageAdjustment->{
					ImageAdjust[Correction->{0,2}],
					ImageTrim[ROI->{{85.07541514219665,1409.3406812576043},{669.3403975455118,1995.9398619108547}}]
				},
				ImageSegmentation->{
					(* Detecting the cell boundary lines and some post processing *)
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Dilation[Kernel->DiskMatrix[2]],
					Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
					(* Remove the background mesh *)
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"],
					DistanceTransform[Image->"inpainted",Padding->0,ImageAdjust->True],
					MaxDetect[Height->0.02,OutputImageLabel->"marker"],
					GradientFilter[Image->"inpainted",GaussianParameters->3],
					WatershedComponents[Marker->"marker",Method->Basins],
					SelectComponents[Criteria->(#EquivalentDiskRadius>=3&&#EquivalentDiskRadius<6 &)]
				},
				PropertyMeasurement->{
					AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse
				},
				Upload->False
			],
			Analysis`Private`validAnalysisPacketP[Object[Analysis,CellCount],
				{
					Replace[NumberOfComponents]->11
				},
				NonNullFields->{AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse},
				Round->12
			],
			TimeConstraint->600
		],

		(* Testing the output result, test and options *)
		Test[
			"Setting Output to Preview displays the image:",
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				Output->Preview
			],
			_Pane
		],
		Test[
			"Setting Output to Options returns the resolved options:",
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				Output->Options
			],
			ops_/;MatchQ[ops,OptionsPattern[AnalyzeCellCount]]
		],
		Test[
			"Setting Output to Tests returns a list of tests or Null if it is empty:",
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				Output->Tests
			],
			{(_EmeraldTest|_Example)...}|Null
		],
		Test[
			"Setting Output to {Result,Options} displays the image and returns all resolved options:",
			AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3},
				Output->{Result,Options},
				Upload->False
			],
			output_List/;MatchQ[First@output,{PacketP[Object[Analysis,CellCount]]..}]&&MatchQ[Last@output,OptionsPattern[AnalyzeCellCount]]
		]
	},

	Variables:>{
		myHemocytometerCloudFile,myLowDensityConfluencyMeasurementCloudFile,myHighDensityConfluencyMeasurementCloudFile,
		myNuclearLabelingMainCloudFile,myRBCCloudFile,myTrypanCloudFile
	},

	SetUp:> (
		(* Clear memoization for download stability *)
		ClearMemoization[];
		$PersonID = Object[User, "Test user for notebook-less test protocols"];
		$CreatedObjects = {};

		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerCloudFile = Object[EmeraldCloudFile, "id:WNa4ZjK4Pm0R"];

		(* The confluency data object *)
		myLowDensityConfluencyMeasurementCloudFile = Object[EmeraldCloudFile, "id:n0k9mG8G8nNW"];
		myHighDensityConfluencyMeasurementCloudFile = Object[EmeraldCloudFile, "id:vXl9j5757VAJ"];

		(* Nuclear labeling example *)
		myNuclearLabelingMainCloudFile = Object[EmeraldCloudFile, "id:rea9jlRlRdqo"];

		(* RBC peripheral blood smear image *)
		myRBCCloudFile = Object[EmeraldCloudFile, "id:P5ZnEjdjr17O"];

		(* RBC peripheral blood smear image *)
		myTrypanCloudFile = Object[EmeraldCloudFile, "id:M8n3rx0xw3kG"];

		(* Old microscope files *)
		{microscopeDense, microscopeMediumSparse, microscopeSmallSparse} = Download[
			{Object[Data, Microscope, "8E5 Batch 131 Split"], Object[Data, Microscope, "id:bq9LA0dB8pbL"], Object[Data, Microscope, "id:XnlV5jmbZO0B"]},
			PhaseContrastImageFile
		];
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				emptyMicroscopeDataObject
			},

			(* All objects for XNA *)
			emptyMicroscopeDataObject = Object[Data, Microscope, "Empty microscope data" <> $SessionUUID];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[emptyMicroscopeDataObject, Force -> True, Verbose -> False]]
		];
		Module[{emptyMicroscopeDataPacket, emptyMicroscopeDataObject},
			(* Creating the packet associated with the thermodyanmic properties of XNA *)
			emptyMicroscopeDataPacket = <|
				Name -> "Empty microscope data" <> $SessionUUID,
				Type -> Object[Data, Microscope],
				DeveloperObject -> True
			|>;

			(* Creating the XNA model thermodynamics object *)
			emptyMicroscopeDataObject = Upload[emptyMicroscopeDataPacket];

		]
	),

	SymbolTearDown:> (
		Module[
			{
				emptyMicroscopeDataObject
			},

			(* All objects for XNA *)
			emptyMicroscopeDataObject = Object[Data, Microscope, "Empty microscope data" <> $SessionUUID];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[emptyMicroscopeDataObject, Force -> True, Verbose -> False]]
		];
	)

];


(* ::Subsubsection:: *)
(*AnalyzeCellCountOptions*)

DefineTests[AnalyzeCellCountOptions,

	{

		Example[{Basic,"Options for cell count analysis of the confluency measurement using a short-hand notation, MeasureConfluency->True:"},
			AnalyzeCellCountOptions[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True
			],
			_Grid,
			TimeConstraint->600
		],

		Example[{Basic,"Options for cell count analysis of the microscope data object and selecting all steps automatically:"},
			AnalyzeCellCountOptions[
				Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,1},
				MinCellRadius->2 Pixel,
				MaxCellRadius->6 Pixel
			],
			_Grid,
			TimeConstraint->600
		],

		Example[{Basic,"Options for the cell count analysis of a hemocytometer image with a short-hand notation, Hemocytometer->True:"},
			AnalyzeCellCountOptions[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3}
			],
			_Grid,
			TimeConstraint->600
		]

	},

	Variables:>{
		myHemocytometerCloudFile,myLowDensityConfluencyMeasurementCloudFile,myHighDensityConfluencyMeasurementCloudFile,myNuclearLabelingMainCloudFile
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"];

		(* The confluency data object *)
		myLowDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Low density confluency measurement test"];
		myHighDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="High density confluency measurement test"];

		(* Nuclear labeling example *)
		myNuclearLabelingMainCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Nuclear labeling for cellcount test - main image"];
	}

];

(* ::Subsubsection:: *)
(*AnalyzeCellCountPreview*)

DefineTests[AnalyzeCellCountPreview,

	{

		Example[{Basic,"Preview for cell count analysis of the confluency measurement using a short-hand notation, MeasureConfluency->True:"},
			AnalyzeCellCountPreview[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True
			],
			_Pane,
			TimeConstraint->600
		],

		Example[{Basic,"Preview for cell count analysis of the microscope data object and selecting all steps automatically:"},
			AnalyzeCellCountPreview[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageAdjustment->{ImageAdjust[Correction->{0,20}]},
				ImageSelection->{ImageSelect[ImagingSite->7]},
				MeasureConfluency->True
			],
			_Pane,
			TimeConstraint->600
		],

		Example[{Basic,"Preview for the cell count analysis of a hemocytometer image with a short-hand notation, Hemocytometer->True:"},
			AnalyzeCellCountPreview[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3}
			],
			_Pane,
			TimeConstraint->600
		]

	},

	Variables:>{
		myHemocytometerCloudFile,myLowDensityConfluencyMeasurementCloudFile,myHighDensityConfluencyMeasurementCloudFile,myNuclearLabelingMainCloudFile
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"];

		(* The confluency data object *)
		myLowDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Low density confluency measurement test"];
		myHighDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="High density confluency measurement test"];

		(* Nuclear labeling example *)
		myNuclearLabelingMainCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Nuclear labeling for cellcount test - main image"];
	}

];


(* ::Subsubsection:: *)
(*ValidAnalyzeCellCountQ*)

DefineTests[ValidAnalyzeCellCountQ,

	{

		Example[{Basic,"ValidAnalyzeCellCountQ for cell count analysis of the confluency measurement using a short-hand notation, MeasureConfluency->True:"},
			ValidAnalyzeCellCountQ[
				myLowDensityConfluencyMeasurementCloudFile,
				MeasureConfluency->True
			],
			True,
			TimeConstraint->600
		],

		Example[{Basic,"ValidAnalyzeCellCountQ for cell count analysis of the microscope data object and selecting all steps automatically:"},
			ValidAnalyzeCellCountQ[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				ImageAdjustment->{ImageAdjust[Correction->{0,20}]},
				ImageSelection->{ImageSelect[ImagingSite->7]},
				MeasureConfluency->True
			],
			True,
			TimeConstraint->600
		],

		Example[{Basic,"ValidAnalyzeCellCountQ for the cell count analysis of a hemocytometer image with a short-hand notation, Hemocytometer->True:"},
			ValidAnalyzeCellCountQ[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				HemocytometerSquarePosition->{1,3}
			],
			True,
			TimeConstraint->600
		],

		Example[{Basic,"ValidAnalyzeCellCountQ for the cell count analysis of a hemocytometer image with a short-hand notation, Hemocytometer->True with failed results:"},
			ValidAnalyzeCellCountQ[
				Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
				MeasureConfluency->True,
				ImageSelection->{
					ImageSelect[
						InputObject->Automatic,ImageTimepoint->1,ImageZStep->1,ImagingSite->1
					]
				},
				ImageAdjustment->{
					ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
				}
			],
			True,
			TimeConstraint->600
		]

	},

	Variables:>{
		myHemocytometerCloudFile,myLowDensityConfluencyMeasurementCloudFile,myHighDensityConfluencyMeasurementCloudFile,myNuclearLabelingMainCloudFile
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"];

		(* The confluency data object *)
		myLowDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Low density confluency measurement test"];
		myHighDensityConfluencyMeasurementCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="High density confluency measurement test"];

		(* Nuclear labeling example *)
		myNuclearLabelingMainCloudFile=First@Search[Object[EmeraldCloudFile],FileName=="Nuclear labeling for cellcount test - main image"];
	}

];





(* ::Subsection:: *)
(*ImageSelection Primitives*)

(* ::Subsubsection:: *)
(*MicroscopeImage*)

DefineTests[MicroscopeImage,
	{
		(* Basic *)
		Example[{Basic,"Make a MicroscopeImage Unit Operation:"},
			MicroscopeImage[],
			_MicroscopeImage
		],
		Example[{Basic,"Make a MicroscopeImage Unit Operation with a specified input data Object:"},
			unitOperation=MicroscopeImage[InputObject->Object[Data,Microscope,"id:1ZA60vL7NKLD"]];
			unitOperation[InputObject],
			ObjectP[Object[Data,Microscope]],
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a MicroscopeImage Unit Operation within AnalyzeCellCount to select a specific image from a microscope data Object and segment the nuclei in that image:"},
			analysis=AnalyzeCellCount[
				Object[Data,Microscope,"id:1ZA60vL7NKLD"],
				Images->{
					MicroscopeImage[
						InputObject->Automatic,
						Mode->Epifluorescence,
						ObjectiveMagnification->10.,
						ImageTimepoint->1,
						ImageZStep->1,
						ImagingSite->3,
						ExcitationWavelength->405. Nanometer,
						EmissionWavelength->452. Nanometer,
						DichroicFilterWavelength->421. Nanometer,
						ExcitationPower->100. Percent,
						TransmittedLightPower->Null,
						ExposureTime->73.21 Millisecond,
						FocalHeight->10947.1 Micrometer,
						ImageBitDepth->16,
						PixelBinning->1,
						ImagingSiteRow->1,
						ImagingSiteColumn->3
					]
				}
			];
			Download[analysis,NumberOfComponents],
			{1504.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		(* Options *)
		Example[{Options,Mode,"Make a MicroscopeImage Unit Operation with the imaging Mode specified to Epifluorescence:"},
			unitOperation=MicroscopeImage[Mode->Epifluorescence];
			unitOperation[Mode],
			Epifluorescence,
			Variables:>{unitOperation}
		],
		Example[{Options,Mode,"Make a MicroscopeImage Unit Operation with the ObjectiveMagnification specified to 10x:"},
			unitOperation=MicroscopeImage[ObjectiveMagnification->10.];
			unitOperation[ObjectiveMagnification],
			10.,
			EquivalenceFunction->Equal,
			Variables:>{unitOperation}
		]
	}
];

(* ::Subsection:: *)
(*ImageAdjustment Primitives*)

(* ::Subsubsection:: *)
(*Image*)

DefineTests[Image,
	{
		(* Basic *)
		Example[{Basic,"Converting the matrix output to a binary image:"},
			Image[
				Image->"Reference Image"
			],
			_Image
		],
		Example[{Basic,"Converting the matrix output to a binary image by automatically populating the image label:"},
			Image[
				Type->Bit
			],
			_Image
		],
		Example[{Basic,"Converting the matrix output to a binary image by explicitly providing the image:"},
			Image[
				Image->myHemocytometerImage,
				OutputImageLabel->"Adjusted Image",
				Type->Bit
			],
			_Image
		],

		(* Options *)
		Example[{Options,OutputImageLabel,"Specifying the label of the image:"},
			Image[
				Image->myHemocytometerImage,
				OutputImageLabel->"Adjusted Image",
				Type->Bit
			],
			_Image
		]

	},

	Variables:>{
		myHemocytometerImage
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"]];
	}

];

(* ::Subsubsection:: *)
(*ImageAdjust*)


DefineTests[ImageAdjust,
	{
		(* Basic *)
		Example[{Basic,"Adjusting the image using automatic settings of mathematica ImageAdjust:"},
			ImageAdjust[
				Image->"Reference Image"
			],
			_ImageAdjust
		],
		Example[{Basic,"Correcting the contrast, brightness and gamma features of the image with {c,b,g} tuple:"},
			{
				ImageAdjust[
					Image->"Reference Image",
					Correction->{0,2},
					OutputImageLabel->"brightness corrected"
				],
				ImageAdjust[
					Image->"Reference Image",
					Correction->{1,0,1},
					OutputImageLabel->"cotrast corrected"
				],
				ImageAdjust[
					Image->"Reference Image",
					Correction->{0,1,1},
					OutputImageLabel->"brightness corrected"
				],
				ImageAdjust[
					Image->"Reference Image",
					Correction->{0,0,2},
					OutputImageLabel->"gamma corrected"
				]
			},
			{_ImageAdjust..}
		],
		Example[{Basic,"Rescaling the input range in the image so it varies between 0-1:"},
			ImageAdjust[
				Image->myHemocytometerImage,
				InputRange->{100,500}
			],
			_ImageAdjust
		],
		Example[{Basic,"Rescaling the input range in the image so it varies according to output range:"},
			ImageAdjust[
				Image->myHemocytometerImage,
				InputRange->{100,500},
				OutputRange->{0.2,0.7}
			],
			_ImageAdjust
		],

		(* Options *)
		Example[{Options,OutputImageLabel,"Specifying the label of the image:"},
			ImageAdjust[
				Image->"Reference Image",
				Correction->{1,1},
				OutputImageLabel->"contrast and brightness corrected"
			],
			_ImageAdjust
		]

	},

	Variables:>{
		myHemocytometerImage
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"]];
	}

];

(* ::Subsubsection:: *)
(*ColorNegate*)


DefineTests[ColorNegate,
	{
		(* Basic *)
		Example[{Basic,"Negating the color of an image so each pixel value v is replaced by 1-v:"},
			ColorNegate[
				Image->"Reference Image"
			],
			_ColorNegate
		],
		Example[{Basic,"Specifying the name of the output image:"},
			ColorNegate[
				Image->"Reference Image",
				OutputImageLabel->"color negated"
			],
			_ColorNegate
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			ColorNegate[
			],
			_ColorNegate
		]

	}

];

(* ::Subsubsection:: *)
(*ColorSeparate*)


DefineTests[ColorSeparate,
	{
		(* Basic *)
		Example[{Basic,"Negating the color of an image so each pixel value v is replaced by 1-v:"},
			ColorSeparate[
				Image->"Reference Image"
			],
			_ColorSeparate
		],
		Example[{Basic,"Specifying the name of the output image:"},
			ColorSeparate[
				Image->myRBCImage,
				Color->Red,
				OutputImageLabel->"color negated"
			],
			_ColorSeparate
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			ColorSeparate[
				Color->Green
			],
			_ColorSeparate
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*Binarize*)


DefineTests[Binarize,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			Binarize[
				Image->"Reference Image"
			],
			_Binarize
		],
		Example[{Basic,"Specifying the name of the output image:"},
			Binarize[
				Image->myRBCImage,
				Threshold->{1,100},
				OutputImageLabel->"binarized image"
			],
			_Binarize
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			Binarize[
				Threshold->1
			],
			_Binarize
		],

		(* Options *)
		Example[{Options,Method,"Specifying the method by which the binarization is performed:"},
			Binarize[
				Image->"reference",
				Threshold->0.5,
				Method->Entropy
			],
			_Binarize
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*MorphologicalBinarize*)


DefineTests[MorphologicalBinarize,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			MorphologicalBinarize[
				Image->"Reference Image"
			],
			_MorphologicalBinarize
		],
		Example[{Basic,"Specifying the name of the output image:"},
			MorphologicalBinarize[
				Image->myTrypanImage,
				Threshold->{1,100},
				OutputImageLabel->"binarized image"
			],
			_MorphologicalBinarize
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			MorphologicalBinarize[
				Threshold->1
			],
			_MorphologicalBinarize
		],

		(* Options *)
		Example[{Options,Method,"Specifying the method by which the binarization is performed:"},
			MorphologicalBinarize[
				Image->"reference",
				Threshold->0.5,
				Method->Entropy
			],
			_MorphologicalBinarize
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*TopHatTransform*)


DefineTests[TopHatTransform,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			TopHatTransform[
				Image->"Reference Image",
				Kernel->1
			],
			_TopHatTransform
		],
		Example[{Basic,"Specifying the name of the output image:"},
			TopHatTransform[
				Image->myTrypanImage,
				Kernel->BoxMatrix[1],
				OutputImageLabel->"binarized image"
			],
			_TopHatTransform
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			TopHatTransform[
				Kernel->DiskMatrix[2]
			],
			_TopHatTransform
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*BottomHatTransform*)


DefineTests[BottomHatTransform,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			BottomHatTransform[
				Image->"Reference Image",
				Kernel->1
			],
			_BottomHatTransform
		],
		Example[{Basic,"Specifying the name of the output image:"},
			BottomHatTransform[
				Image->myTrypanImage,
				Kernel->BoxMatrix[1],
				OutputImageLabel->"binarized image"
			],
			_BottomHatTransform
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			BottomHatTransform[
				Kernel->DiskMatrix[2]
			],
			_BottomHatTransform
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*HistogramTransform*)


DefineTests[HistogramTransform,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			HistogramTransform[
				Image->"Reference Image",
				Distribution->NormalDistribution[1,0.1]
			],
			_HistogramTransform
		],
		Example[{Basic,"Specifying the name of the output image:"},
			HistogramTransform[
				Image->myTrypanImage,
				Distribution->NormalDistribution[2,0.1],
				OutputImageLabel->"histogram transformed"
			],
			_HistogramTransform
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			HistogramTransform[
				Image->myRBCImage,
				ReferenceImage->myTrypanImage
			],
			_HistogramTransform
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*FillingTransform*)


DefineTests[FillingTransform,
	{
		(* Basic *)
		Example[{Basic,"Binarizing the image with the automatic threshold:"},
			FillingTransform[
				Image->"Reference Image",
				Depth->0.5
			],
			_FillingTransform
		],
		Example[{Basic,"Specifying the name of the output image:"},
			FillingTransform[
				Image->myTrypanImage,
				Depth->0.8,
				OutputImageLabel->"filled"
			],
			_FillingTransform
		],
		Example[{Basic,"Automatically choosing the name of the image from the previous primitives:"},
			FillingTransform[
				Image->myRBCImage,
				Marker->"marker image"
			],
			_FillingTransform
		]

	},

	Variables:>{
		myRBCImage,myTrypanImage
	},

	SetUp:>{

		(* CLear memoization for download stability *)
		ClearMemoization[];
		(* Track created objects *)
		$CreatedObjects={};

		(* RBC peripheral blood smear image *)
		myRBCImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="RBC image for cell count testing"]];

		(* RBC peripheral blood smear image *)
		myTrypanImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Viability test for cell count analysis"]];

	},

	TearDown:>(
		(* Erase created objects *)
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects]
	)

];

(* ::Subsubsection:: *)
(*ImageTrim*)

DefineTests[ImageTrim,
	{
		(* Basic *)
		Example[{Basic,"Adjusting the image using automatic settings of mathematica ImageAdjust:"},
			ImageTrim[
				Image->"Adjusted Image"
			],
			_ImageTrim
		],
		Example[{Basic,"Correcting the contrast, brightness and gamma features of the image with {c,b,g} tuple:"},
			ImageTrim[
				Image->myHemocytometerImage,
				ROI->{{10,10},{20.5,100}}
			],
			_ImageTrim
		],
		Example[{Basic,"Adding a margin of 1 pixel to each side:"},
			ImageTrim[
				Image->myHemocytometerImage,
				ROI->{{10,10},{20.5,100}},
				Margin->1
			],
			_ImageTrim
		],

		(* Options *)
		Example[{Options,DataRange,"Scale the coordinate according to the DataRange before trimming with ROI:"},
			ImageTrim[
				ImageTrim->"Reference Image",
				ROI->{{0,0.5},{0.75,0.75}},
				DataRange->{{0,1},{0,1}}
			],
			_ImageTrim
		],
		Example[{Options,Padding,"Specifying the padding scheme when trimming the image:"},
			ImageTrim[
				ImageTrim->"adjusted image",
				ROI->{{10,10},{20.5,100}},
				Padding->None
			],
			_ImageTrim
		]

	},

	Variables:>{
		myHemocytometerImage
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"]];
	}

];

(* ::Subsection:: *)
(*ImageSegmentation Primitives*)

(* ::Subsubsection:: *)
(*Erosion*)

DefineTests[Erosion,
	{
		(* Basic *)
		Example[{Basic,"Adjusting the image using automatic settings of mathematica ImageAdjust:"},
			Erosion[
				Image->"Adjusted Image"
			],
			_Erosion
		],
		Example[{Basic,"Using the BoxMatrix[1] to use for erosion kernel:"},
			Erosion[
				Image->myHemocytometerImage,
				Kernel->1
			],
			_Erosion
		],
		Example[{Basic,"Using a disk element matrix with radius 2 to specify the erosion kernel:"},
			Erosion[
				Image->myHemocytometerImage,
				Kernel->DiskMatrix[2]
			],
			_Erosion
		]

	},

	Variables:>{
		myHemocytometerImage
	},

	SetUp:>{
		(* The hemocytometer raw EmeraldCloudFile object *)
		myHemocytometerImage=ImportCloudFile[First@Search[Object[EmeraldCloudFile],FileName=="Hemocytometer cellcount test"]];
	}

];

(* ::Subsubsection:: *)
(*MaxDetect*)

DefineTests[MaxDetect,
	{
		(* Basic *)
		Example[{Basic,"Make a MaxDetect Unit Operation:"},
			MaxDetect[],
			_MaxDetect
		],
		Example[{Basic,"Make a MaxDetect Unit Operation with a Height of 0.1:"},
			unitOperation=MaxDetect[Height->0.1];
			unitOperation[Height],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Make a MaxDetect Unit Operation with an image of nuclei:"},
			unitOperation=MaxDetect[Image->ImportCloudFile[Object[EmeraldCloudFile,"Test Nuclear Image for MaxDetect"<>$SessionUUID]]];
			unitOperation[Image],
			_Image,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a MaxDetect Unit Operation within AnalyzeCellCount to segment an image of nuclei:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for MaxDetect"<>$SessionUUID],
				ImageSegmentation->{MaxDetect[Height->0.1]}
			];
			Download[analysis,NumberOfComponents],
			{51.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		(* Options *)
		Example[{Options,Padding,"Make a MaxDetect Unit Operation with Periodic Padding:"},
			unitOperation=MaxDetect[Height->0.1,Padding->Periodic];
			unitOperation[Padding],
			Periodic,
			Variables:>{unitOperation}
		],
		Example[{Options,CornerNeighbors,"Make a MaxDetect Unit Operation with CornerNeighbors set to False:"},
			unitOperation=MaxDetect[Height->0.1,CornerNeighbors->False];
			unitOperation[CornerNeighbors],
			False,
			Variables:>{unitOperation}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MaxDetect"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MaxDetect"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e75e336ed0752d0b097644ae37d908b5.jpg","vXl9j5757VAEHK9PekRveY9pI5qxvXRvePAZ"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Nuclear Image for MaxDetect"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MaxDetect"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MaxDetect"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];

(* ::Subsubsection:: *)
(*MinDetect*)

DefineTests[MinDetect,
	{
		(* Basic *)
		Example[{Basic,"Make a MinDetect Unit Operation:"},
			MinDetect[],
			_MinDetect
		],
		Example[{Basic,"Make a MinDetect Unit Operation with a Height of 0.1:"},
			unitOperation=MinDetect[Height->0.1];
			unitOperation[Height],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Make a MinDetect Unit Operation with an inverted image of nuclei:"},
			unitOperation=MinDetect[
				Image->ColorNegate[ImportCloudFile[Object[EmeraldCloudFile,"Test Nuclear Image for MinDetect"<>$SessionUUID]]]
			];
			unitOperation[Image],
			_Image,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a MinDetect Unit Operation within AnalyzeCellCount to segment an inverted image of nuclei:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for MinDetect"<>$SessionUUID],
				ImageAdjustment->{ColorNegate[]},
				ImageSegmentation->{MinDetect[Height->0.1]}
			];
			Download[analysis,NumberOfComponents],
			{51.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		(* Options *)
		Example[{Options,Padding,"Make a MinDetect Unit Operation with Periodic Padding:"},
			unitOperation=MinDetect[Height->0.1,Padding->Periodic];
			unitOperation[Padding],
			Periodic,
			Variables:>{unitOperation}
		],
		Example[{Options,CornerNeighbors,"Make a MinDetect Unit Operation with CornerNeighbors set to False:"},
			unitOperation=MinDetect[Height->0.1,CornerNeighbors->False];
			unitOperation[CornerNeighbors],
			False,
			Variables:>{unitOperation}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MinDetect"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MinDetect"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e75e336ed0752d0b097644ae37d908b5.jpg","vXl9j5757VAEHK9PekRveY9pI5qxvXRvePAZ"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Nuclear Image for MinDetect"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MinDetect"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MinDetect"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];

DefineTests[DistanceTransform,
	{
		(* Basic *)
		Example[{Basic, "Make a DistanceTransform Unit Operation:"},
			DistanceTransform[],
			_DistanceTransform
		],
			Example[{Basic, "Make a DistanceTransform Unit Operation with a Threshold of 0.1:"},
			unitOperation = DistanceTransform[Threshold -> 0.1];
			unitOperation[Threshold], 0.1, EquivalenceFunction -> Equal,
			Variables :> {unitOperation}
		],
		Example[{Basic,
			"Make a DistanceTransform Unit Operation with an image of nuclei:"},
			unitOperation = DistanceTransform[Image -> ImportCloudFile[Object[EmeraldCloudFile, "Test Nuclear Image for DistanceTransform" <> $SessionUUID]]];
			unitOperation[Image],
			_Image,
			Variables :> {unitOperation}
		],
		Example[{Basic, "Use a DistanceTransform Unit Operation within AnalyzeCellCount to segment an image of nuclei:"},
			analysis = AnalyzeCellCount[
				Object[EmeraldCloudFile, "Test Nuclear Image for DistanceTransform" <> $SessionUUID],
				ImageSegmentation -> {DistanceTransform[Threshold -> 0.1]}
			];
			Download[analysis, NumberOfComponents],
			{145.},
			EquivalenceFunction -> Equal,
			Variables :> {analysis}
		]
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for DistanceTransform"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for DistanceTransform"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e75e336ed0752d0b097644ae37d908b5.jpg","vXl9j5757VAEHK9PekRveY9pI5qxvXRvePAZ"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Nuclear Image for DistanceTransform"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for DistanceTransform"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for DistanceTransform"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];



(* ::Subsubsection:: *)
(*MorphologicalComponents*)

DefineTests[MorphologicalComponents,
	{
		(* Basic *)
		Example[{Basic,"Make a MorphologicalComponents Unit Operation:"},
			MorphologicalComponents[],
			_MorphologicalComponents
		],
		Example[{Basic,"Make a MorphologicalComponents Unit Operation with a Threshold of 0.1:"},
			unitOperation=MorphologicalComponents[Threshold->0.1];
			unitOperation[Threshold],
			0.1,
			EquivalenceFunction->Equal,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Make a MorphologicalComponents Unit Operation with an image of nuclei:"},
			unitOperation=MorphologicalComponents[
				Image->ImportCloudFile[Object[EmeraldCloudFile,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID]]
			];
			unitOperation[Image],
			_Image,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a MorphologicalComponents Unit Operation within AnalyzeCellCount to count the number of nuclei (using the Default Connected Method):"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID],
				ImageSegmentation->{MorphologicalComponents[Threshold->0.1]}
			];
			Download[analysis,NumberOfComponents],
			{145.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		Example[{Basic,"Use a MorphologicalComponents Unit Operation within AnalyzeCellCount to count the number of nuclei using the Convex Method:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID],
				ImageSegmentation->{MorphologicalComponents[Threshold->0.1,Method->Convex]}
			];
			Download[analysis,NumberOfComponents],
			{141.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		(* Options *)
		Example[{Options,Padding,"Make a MorphologicalComponents Unit Operation with Periodic Padding:"},
			unitOperation=MorphologicalComponents[Threshold->0.1,Padding->Periodic];
			unitOperation[Padding],
			Periodic,
			Variables:>{unitOperation}
		],
		Example[{Options,CornerNeighbors,"Make a MorphologicalComponents Unit Operation with CornerNeighbors set to False:"},
			unitOperation=MorphologicalComponents[Threshold->0.1,CornerNeighbors->False];
			unitOperation[CornerNeighbors],
			False,
			Variables:>{unitOperation}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e75e336ed0752d0b097644ae37d908b5.jpg","vXl9j5757VAEHK9PekRveY9pI5qxvXRvePAZ"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for MorphologicalComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];
(* ::Subsubsection:: *)
(*SelectComponents*)

DefineTests[SelectComponents,
	{
		(* Basic *)
		Example[{Basic,"Make a SelectComponents Unit Operation:"},
			SelectComponents[],
			_SelectComponents
		],
		Example[{Basic,"Make a SelectComponents Unit Operation for the Area component property:"},
			unitOperation=SelectComponents[Property->Area];
			unitOperation[Property],
			Area,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Make a SelectComponents Unit Operation with an image of nuclei:"},
			unitOperation=SelectComponents[
				Image->ImportCloudFile[Object[EmeraldCloudFile,"Test Nuclear Image for SelectComponents"<>$SessionUUID]]
			];
			unitOperation[Image],
			_Image,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a SelectComponents Unit Operation within AnalyzeCellCount to select only Components with areas between 500 and 3000 square pixels:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for SelectComponents"<>$SessionUUID],
				ImageSegmentation->{
					MaxDetect[Height->0.05],
					SelectComponents[Criteria->(500<#Area&&3000>#Area &)]
				}
			];
			areas=Download[analysis,ComponentArea];
			AllTrue[areas,500 Pixel^2<#<3000 Pixel^2 &],
			True,
			Variables:>{analysis,areas}
		],
		Example[{Basic,"Use a SelectComponents Unit Operation within AnalyzeCellCount to select only Components with Circularity greater than 0.8:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Nuclear Image for SelectComponents"<>$SessionUUID],
				ImageSegmentation->{
					MaxDetect[Height->0.05],
					SelectComponents[Criteria->(0.8<#Circularity &)]
				}
			];
			circularities=Download[analysis,ComponentCircularity];
			AllTrue[circularities,0.8<# &],
			True,
			Variables:>{analysis,circularities}
		],
		(* Options *)
		Example[{Options,CornerNeighbors,"Make a SelectComponents Unit Operation with CornerNeighbors set to False:"},
			unitOperation=SelectComponents[CornerNeighbors->False];
			unitOperation[CornerNeighbors],
			False,
			Variables:>{unitOperation}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for SelectComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for SelectComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e75e336ed0752d0b097644ae37d908b5.jpg","vXl9j5757VAEHK9PekRveY9pI5qxvXRvePAZ"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Nuclear Image for SelectComponents"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Nuclear Image for SelectComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Nuclear Image for SelectComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];
(* ::Subsubsection:: *)
(*WatershedComponents*)

DefineTests[WatershedComponents,
	{
		(* Basic *)
		Example[{Basic,"Make a WatershedComponents Unit Operation:"},
			WatershedComponents[],
			_WatershedComponents
		],
		Example[{Basic,"Make a WatershedComponents Unit Operation with the Basins Method:"},
			unitOperation=WatershedComponents[Method->Basins];
			unitOperation[Method],
			Basins,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Make a WatershedComponents Unit Operation with an image of cells:"},
			unitOperation=WatershedComponents[
				Image->ImportCloudFile[Object[EmeraldCloudFile,"Test Cell Image for WatershedComponents"<>$SessionUUID]]
			];
			unitOperation[Image],
			_Image,
			Variables:>{unitOperation}
		],
		Example[{Basic,"Use a WatershedComponents Unit Operation within AnalyzeCellCount to count the number of cells in an image using the default Watershed Method:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Cell Image for WatershedComponents"<>$SessionUUID],
				ImageAdjustment->{
					Binarize[],
					ColorNegate[]
				},
				ImageSegmentation->{
					WatershedComponents[ColorNegate->True]
				}
			];
			Download[analysis,NumberOfComponents],
			{65.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		Example[{Basic,"Use a WatershedComponents Unit Operation within AnalyzeCellCount to count the number of cells in an image using the default Watershed Method with CornerNeighbors set to False:"},
			analysis=AnalyzeCellCount[
				Object[EmeraldCloudFile,"Test Cell Image for WatershedComponents"<>$SessionUUID],
				ImageAdjustment->{
					Binarize[],
					ColorNegate[]
				},
				ImageSegmentation->{
					WatershedComponents[ColorNegate->True,CornerNeighbors->False]
				}
			];
			Download[analysis,NumberOfComponents],
			{66.},
			EquivalenceFunction->Equal,
			Variables:>{analysis}
		],
		(* Options *)
		Example[{Options,CornerNeighbors,"Make a WatershedComponents Unit Operation with CornerNeighbors set to False:"},
			unitOperation=WatershedComponents[Threshold->0.1,CornerNeighbors->False];
			unitOperation[CornerNeighbors],
			False,
			Variables:>{unitOperation}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Module[{objects,existsFilter,nuclearFileName,nuclearFile,nuclearObject},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Cell Image for WatershedComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Cell Image for WatershedComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];

			(* Get the Emerald Cloud File with the nuclear image *)
			nuclearFile=EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","e4e9b8ac7864f8a016990bfa231cc004.jpg","8qZ1VW0WzGX5SXEmJvOVLq3zIWbNaGeq47Dp"];

			(* Download the nuclear image *)
			DownloadCloudFile[nuclearFile,nuclearFileName];

			(* Upload an Object[EmeraldCloudFile] with the nuclear image *)
			nuclearObject=UploadCloudFile[nuclearFileName];

			(* Update the name of the created Object[EmeraldCloudFile] *)
			Upload[<|
				Object->nuclearObject,
				Name->"Test Cell Image for WatershedComponents"<>$SessionUUID
			|>];
		]
	},
	SymbolTearDown:>{
		Module[{objects,existsFilter,nuclearFileName},
			(* list of test objects*)
			objects={
				Object[EmeraldCloudFile,"Test Cell Image for WatershedComponents"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* The file name the nuclear image is Downloaded to *)
			nuclearFileName=FileNameJoin[{$TemporaryDirectory,"Test Cell Image for WatershedComponents"<>$SessionUUID<>".jpg"}];

			(* If a file with this name exists, delete it *)
			Quiet[DeleteFile[nuclearFileName],DeleteFile::fdnfnd];
		]
	}
];

(* ::Subsubsection:: *)
(*Opening*)

DefineTests[Opening,
  {
    Example[{Basic,"Gives the morphological opening of Image:"},
			Opening[Kernel -> ConstantArray[1, {6, 6}]],
			_Opening
		],
		Example[{Basic,"Use Opening in a cell count analysis:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"adjusted",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
  		_Pane,
      SetUp:>($CreatedObjects={}),
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
		]
  }
];

(* ::Subsubsection:: *)
(*Closing*)

DefineTests[Closing,
  {
    Example[{Basic,"Gives the morphological opening of Image:"},
      Closing[Kernel -> ConstantArray[1, {6, 6}]],
      _Closing
    ],
    Example[{Basic,"Use Closing in a cell count analysis using a protocol:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"adjusted",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
      _Pane,
      SetUp:>($CreatedObjects={}),
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ],

    Example[{Basic,"Use Closing in a cell count analysis using a raw data file:"},
      Download[
        AnalyzeCellCount[
          myHighDensityConfluencyMeasurementCloudFile,
          MeasureConfluency->True,
          ImageSegmentation->{
            StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
            Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
            StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
            Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
            Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
            ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
            Closing[Kernel->ConstantArray[1,{6,6}]],
            Opening[Kernel->ConstantArray[1,{6,6}]]
          }
        ],
        Confluency
      ],
      {98.25343489646912` Percent},
      EquivalenceFunction -> RoundMatchQ[3],
      SetUp:> {
        $CreatedObjects = {},
        myHighDensityConfluencyMeasurementCloudFile = First@Search[Object[EmeraldCloudFile], FileName == "High density confluency measurement test"]
      },
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ]
  }
];

(* ::Subsubsection:: *)
(*Dilation*)

DefineTests[Dilation,
  {
    Example[{Basic,"Gives the morphological dilation of the image by expanding/adding pixels to the boundary of the components. This addition is performed with respect to a structuring element specified as Kernel:"},
      Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
      _Dilation
    ],
    Example[{Basic,"Use Dilation in a cell count analysis using a protocol:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"adjusted",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
      _Pane,
      SetUp:>($CreatedObjects={}),
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ],

    Example[{Basic,"Use Dilation in a cell count analysis using a raw data file:"},
      Download[
        AnalyzeCellCount[
          myHighDensityConfluencyMeasurementCloudFile,
          MeasureConfluency->True,
          ImageSegmentation->{
            StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
            Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
            StandardDeviationFilter[Image->"ImageAdjustment Result",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
            Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
            Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
            ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
            Closing[Kernel->ConstantArray[1,{6,6}]],
            Opening[Kernel->ConstantArray[1,{6,6}]]
          }
        ],
        Confluency
      ],
      {98.25343489646912` Percent},
      EquivalenceFunction -> RoundMatchQ[3],
      SetUp:> {
        $CreatedObjects = {},
        myHighDensityConfluencyMeasurementCloudFile = First@Search[Object[EmeraldCloudFile], FileName == "High density confluency measurement test"]
      },
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ]
  }
];

(* ::Subsubsection:: *)
(*EdgeDetect*)

DefineTests[EdgeDetect,
  {
    Example[{Basic,"Detects the edges of an image that are a set of points between image regions and are typically computed by linking high-gradient pixels:"},
      EdgeDetect[Image->"ImageAdjustment Result"],
      _EdgeDetect
    ],
    Example[{Additional, "Use EdgeDetect in Hemocytometer processing steps", "B: As for the standard segmentation procedure, we perform:
      1- edge detection for the adjusted image so we will detect the contours of all components,
      2- we close the detected lines (all circles) using Closing primitive which calls mathematica's Closing,
      3,4- We perform dilation and erosion with the same kernel so for the detected components any holes will be filled remove any extremely small component will be removed:"},
      Defer@AnalyzeCellCount[
        myHemocytometerCloudFile,
        Hemocytometer->True,
        ImageSegmentation->{
          EdgeDetect[Image->"ImageAdjustment Result"],
          Closing[Kernel->3],
          Dilation[Kernel->DiskMatrix[2]],
          Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      TimeConstraint -> 600,
      SetUp:>{
        (* The hemocytometer raw EmeraldCloudFile object *)
        myHemocytometerCloudFile=First@Search[Object[EmeraldCloudFile], FileName == "Hemocytometer cellcount test"];
      }
    ],

    Test["Testing the details of the output packet for a cellcount analysis of a hemocytometer raw image using EdgeDetect:",
      AnalyzeCellCount[
        myHemocytometerCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction -> {0, 2}],
          ImageTrim[ROI->{{85.07541514219665, 1409.3406812576043},{669.3403975455118,1995.9398619108547}}]
        },
        ImageSegmentation->{
          (* Detecting the cell boundary lines and some post processing *)
          EdgeDetect[Image->"ImageAdjustment Result"],
          Closing[Kernel->3],
          Dilation[Kernel->DiskMatrix[2]],
          Erosion[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
          RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
          MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
          (* Remove the background mesh *)
          Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"],
          DistanceTransform[Image->"inpainted",Padding->0,ImageAdjust->True],
          MaxDetect[Height->0.02,OutputImageLabel->"marker"],
          GradientFilter[Image->"inpainted",GaussianParameters->3],
          WatershedComponents[Marker->"marker",Method->Basins],
          SelectComponents[Criteria->(#EquivalentDiskRadius>=3 && #EquivalentDiskRadius<6 &)]
        },
        PropertyMeasurement->{
          AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse
        },
        Upload->False
      ],
      Analysis`Private`validAnalysisPacketP[Object[Analysis,CellCount],
        {
          Replace[NumberOfComponents] -> 11
        },
        NonNullFields -> {AreaProperties,PerimeterProperties,CentroidProperties,BestfitEllipse},
        Round -> 12
      ],
      TimeConstraint -> 600,
      SetUp:>{
        (* The hemocytometer raw EmeraldCloudFile object *)
        myHemocytometerCloudFile=First@Search[Object[EmeraldCloudFile], FileName == "Hemocytometer cellcount test"];
      }
    ]
  }
];

    (* ::Subsubsection:: *)
(*BilateralFilter*)

DefineTests[BilateralFilter,
  {
    Example[{Basic,"Nonlinear local filter used for edge-preserving smoothing:"},
      BilateralFilter[Image->"ImageAdjustment Result"],
      _BilateralFilter
    ],
    Example[{Additional, "Neat examples for cell segmentation using BilateralFilter", "A: Segmenting the cells that are stained in one channel:"},
      Defer@AnalyzeCellCount[
        myNuclearLabelingMainCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          LaplacianGaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          Area,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      SetUp:>{
        (* Nuclear labeling example *)
        myNuclearLabelingMainCloudFile=First@Search[Object[EmeraldCloudFile], FileName == "Nuclear labeling for cellcount test - main image"];
      }
    ],
    Example[{Additional, "Neat examples for cell segmentation using BilateralFilter", "A: Segmenting the cells that are stained in one channel:"},
      Defer@AnalyzeCellCount[
        myNuclearLabelingMainCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->2,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          LaplacianGaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          Area,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      SetUp:>{
        (* Nuclear labeling example *)
        myNuclearLabelingMainCloudFile=First@Search[Object[EmeraldCloudFile], FileName == "Nuclear labeling for cellcount test - main image"];
      }
    ]
  }
];

(* ::Subsubsection:: *)
(*BrightnessEqualize*)

DefineTests[BrightnessEqualize,
  {
    Example[{Basic,"Gives local brightness adjustment which is also known as flat fielding, and is used for removing image artifacts caused by nonuniform lighting or variations in sensor sensitivities:"},
      BrightnessEqualize[Image->"ImageAdjustment Result"],
      _BrightnessEqualize
    ],
    Example[{Basic,"Use BrightnessEqualize in a cell count analysis:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"],
          BrightnessEqualize[Image->"adjusted",OutputImageLabel->"brightness"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"brightness",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
      _Pane,
      SetUp:>($CreatedObjects={}),
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ],
    Example[{Basic,"Use BrightnessEqualize in a cell count analysis:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"],
          BrightnessEqualize[Image->"adjusted",DarkField->1,OutputImageLabel->"brightness"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"brightness",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
      _Pane,
      SetUp:>($CreatedObjects={}),
      TearDown:>(EraseObject[$CreatedObjects,Force->True];$CreatedObjects=.)
    ]
  }
];

(* ::Subsubsection:: *)
(* ImageSelect *)

DefineTests[ImageSelect,
  {
    Example[{Basic, "Make a ImageSelect Unit operations with the microscope data object:"},
      ImageSelect[
        InputObject -> Object[Data,Microscope,"Test empty microscope data "<>$SessionUUID]
      ],
      _ImageSelect
    ],
    Example[{Basic, "Make a ImageSelect Unit operations with single site:"},
      ImageSelect[
        InputObject -> Object[Data,Microscope,"Test empty microscope data "<>$SessionUUID],
        ImagingSite -> 1
      ],
      _ImageSelect
    ],
    Example[{Basic, "Make a ImageSelect Unit operations with multiple sites:"},
      ImageSelect[
        InputObject -> Object[Data,Microscope,"Test empty microscope data "<>$SessionUUID],
        ImagingSite -> 1;;5
      ],
      _ImageSelect
    ],
    Example[{Basic, "When Automatic, the object will be autofilled based on the input:"},
      AnalyzeCellCount[
        Object[Protocol, ImageCells, "ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency -> True,
        ImageSelection -> {
          ImageSelect[
            InputObject -> Automatic,
            ImagingSite -> 1
          ]
        },
        ImageAdjustment -> {
          ImageAdjust[
            Correction -> {0, 20},
            OutputImageLabel -> "adjusted"
          ]
        },
        Output -> Preview
      ],
      _Pane
    ]
  },
  SymbolSetUp:>{
    $CreatedObjects={};
    Module[{allObject,existingObject,emptyDataPacket},
      allObject = {Object[Data,Microscope,"Test empty microscope data "<>$SessionUUID]};
      existingObject = PickList[allObject,DatabaseMemberQ[allObject]];
      EraseObject[existingObject,Force->True,Verbose->False];

      emptyDataPacket = <|
        Type -> Object[Data, Microscope],
        Name -> "Test empty microscope data " <> $SessionUUID
      |>;
      Upload[emptyDataPacket];
    ];
  },
  SymbolTearDown:>{
    EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];  }
];

(* ::Subsubsection:: *)
(* StandardDeviationFilter *)

DefineTests[StandardDeviationFilter,
  {
    Example[{Basic, "Make a StandardDeviationFilter Unit Operations with input image:"},
      StandardDeviationFilter[
        Image -> "Input image",
        Radius ->5
      ],
      _StandardDeviationFilter
    ],
    Example[{Basic, "Make a StandardDeviationFilter Unit Operations with given output image label:"},
      StandardDeviationFilter[
        Image -> "Input image",
        Radius -> 1,
        OutputImageLabel -> "STD Filtered image"
      ],
      _StandardDeviationFilter
    ],
    Example[{Basic, "Use StandardDeviationFilter in AnalyzeCellCount using a protocol:"},
      AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells protocol for analysis function"][Data][[2]],
        MeasureConfluency->True,
        ImageSelection->{
          ImageSelect[ImagingSite->7]
        },
        ImageAdjustment->{
          ImageAdjust[Correction->{0,20},OutputImageLabel->"adjusted"]
        },
        ImageSegmentation->{
          StandardDeviationFilter[Image->"adjusted",Radius->6,ImageAdjust->True,OutputImageLabel->"small window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"small window binarized"],
          StandardDeviationFilter[Image->"adjusted",Radius->12,ImageAdjust->True,OutputImageLabel->"big window"],
          Binarize[Image->"small window",Threshold->0.1,OutputImageLabel->"big window binarized"],
          Dilation[Image->"big window binarized",Kernel->ConstantArray[1,{5,5}],OutputImageLabel->"dilated big window"],
          ImageMultiply[Image->"small window binarized",SecondImage->"dilated big window",OutputImageLabel->"intersect"],
          Closing[Kernel->ConstantArray[1,{6,6}]],
          Opening[Kernel->ConstantArray[1,{6,6}]]
        },
        Output->Preview
      ],
      _Pane
    ],
    Example[{Basic, "Use StandardDeviationFilter in AnalyzeCellCount using a raw data file:"},
      Defer@AnalyzeCellCount[
        myFile,
        MeasureConfluency -> True,
        ImageSegmentation -> {
          StandardDeviationFilter[
            Image -> "Input Image",
            Radius -> 7,
            ImageAdjust -> True
          ],
          Binarize[Threshold->0.1]
        },
        PlotProcessingSteps -> True,
        Output -> Preview
      ],
      _Defer,
      Variables:>{myFile},
      SetUp:>{
        $CreatedObjects = {};
        myFile =Object[EmeraldCloudFile,"id:n0k9mG8G8nNW"];
      },
      TearDown:>{EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False]}
    ]
  }
];

(* ::Subsubsection:: *)
(* RidgeFilter *)

DefineTests[RidgeFilter,
  {
    Example[{Basic, "Make a RidgeFilter Unit Operations with input image:"},
      RidgeFilter[
        Image -> "Input image"
      ],
      _RidgeFilter
    ],
    Example[{Basic,"Make a RidgeFilter Unit Operations with output image label:"},
      RidgeFilter[
        Image -> "Input image",
        Scale -> 1.5,
        ImageAdjustment -> True,
        OutputImageLabel -> "RidgeFilterd image"
      ],
      _RidgeFilter
    ],
    Example[{Basic, "Use RidgeFilter in AnalyzeCellCount using a protocol:"},
      Defer@AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
        Hemocytometer -> True,
        ImageSegmentation->{
          EdgeDetect[Image->"ImageAdjustment Result"],
          Closing[Kernel->3],
          Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
          RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
          MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
          Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer
    ],
    Example[{Basic,"Use RidgeFilter in AnalyzeCellCount using a raw data file:"},
      Defer@AnalyzeCellCount[
        myHemocytometerCloudFile,
        Hemocytometer->True,
        ImageSegmentation->{
          EdgeDetect[Image->"ImageAdjustment Result"],
          Closing[Kernel->3],
          Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
          RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
          MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
          Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      Variables:>{myHemocytometerCloudFile},
      SetUp:>{
        $CreatedObjects={};
        myHemocytometerCloudFile=Object[EmeraldCloudFile,"id:WNa4ZjK4Pm0R"];
      },
      TearDown:>{
        EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
      }
    ]
  }
];

(* ::Subsubsection:: *)
(* GaussianFilter *)

DefineTests[GaussianFilter,
  {
    Example[{Basic, "Make a GaussianFilter Unit Operations with input image and radius:"},
      GaussianFilter[
        Image -> "Input image",
        GaussianParameters -> 1
      ],
      _GaussianFilter
    ],
    Example[{Basic,"Make a GaussianFilter Unit Operations with input image and parameters that are radius and standard deviation:"},
      GaussianFilter[
        Image -> "Input image",
        GaussianParameters -> {5,2}
      ],
      _GaussianFilter
    ],
    Example[{Basic,"Make a GaussianFilter Unit Operations with output image label:"},
      GaussianFilter[
        Image -> "Input image",
        GaussianParameters -> {5,2},
        OutputImageLabel -> "GaussianFiltered image"
      ],
      _GaussianFilter
    ],
    Example[{Basic, "Use GaussianFilter in AnalyzeCellCount using a protocol object:"},
      Defer@AnalyzeCellCount[
        Object[Protocol, ImageCells, "ImageCells protocol for analysis function"][Data][[2]],
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer
    ],
    Example[{Basic,"Use GaussianFilter in AnalyzeCellCount using a raw data file:"},
      Defer@AnalyzeCellCount[
        myNuclearLabelingMainCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      Variables:>{myNuclearLabelingMainCloudFile},
      SetUp:>{
        $CreatedObjects={};
        myNuclearLabelingMainCloudFile=Object[EmeraldCloudFile, "id:rea9jlRlRdqo"];
      },
      TearDown:>{
        EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
      }
    ]
  }
];

(* ::Subsubsection:: *)
(* LaplacianGaussianFilter *)

DefineTests[LaplacianGaussianFilter,
	{
		Example[{Basic, "Make a LaplacianGaussianFilter Unit Operations with input image and radius:"},
			LaplacianGaussianFilter[
				Image -> "Input image",
				GaussianParameters -> 1
			],
			_LaplacianGaussianFilter
		],
		Example[{Basic,"Make a LaplacianGaussianFilter Unit Operations with input image and parameters that are radius and standard deviation:"},
			LaplacianGaussianFilter[
				Image -> "Input image",
				GaussianParameters -> {5,2}
			],
			_LaplacianGaussianFilter
		],
		Example[{Basic,"Make a LaplacianGaussianFilter Unit Operations with output image label:"},
			LaplacianGaussianFilter[
				Image -> "Input image",
				GaussianParameters -> {5,2},
				OutputImageLabel -> "GaussianFiltered image"
			],
			_LaplacianGaussianFilter
		],
		Example[{Basic, "Use LaplacianGaussianFilter in AnalyzeCellCount using a protocol object:"},
			Defer@AnalyzeCellCount[
				Object[Protocol, ImageCells, "ImageCells protocol for analysis function"][Data][[2]],
				ImageAdjustment->{
					ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
					BilateralFilter[Radius->1,PixelValueSpread->1/12]
				},
				ImageSegmentation->{
					MorphologicalBinarize[OutputImageLabel->"imageBackground"],
					LaplacianGaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
					MinDetect[OutputImageLabel->"extendedMinima"],
					ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
					WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],
		Example[{Basic,"Use LaplacianGaussianFilter in AnalyzeCellCount using a raw data file:"},
			Defer@AnalyzeCellCount[
				myNuclearLabelingMainCloudFile,
				ImageAdjustment->{
					ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
					BilateralFilter[Radius->1,PixelValueSpread->1/12]
				},
				ImageSegmentation->{
					MorphologicalBinarize[OutputImageLabel->"imageBackground"],
					LaplacianGaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
					MinDetect[OutputImageLabel->"extendedMinima"],
					ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
					WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			Variables:>{myNuclearLabelingMainCloudFile},
			SetUp:>{
				$CreatedObjects={};
				myNuclearLabelingMainCloudFile=Object[EmeraldCloudFile, "id:rea9jlRlRdqo"];
			},
			TearDown:>{
				EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
			}
		]
	}
];

(* ::Subsubsection:: *)
(* Inpaint *)

DefineTests[Inpaint,
	{
		Example[{Basic,"Make a Inpaint Unit Operations with output image label:"},
			Inpaint[
				Image -> "Input image",
				Method -> Diffusion,
				OutputImageLabel -> "GaussianFiltered image"
			],
			_Inpaint
		],
		Example[{Basic, "Use Inpaint in AnalyzeCellCount using a protocol object:"},
			Defer@AnalyzeCellCount[
				Object[Protocol, ImageCells, "ImageCells protocol for analysis function"][Data][[2]],
				ImageAdjustment->{
					ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
					BilateralFilter[Radius->1,PixelValueSpread->1/12]
				},
				ImageSegmentation->{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer
		],
		Example[{Basic,"Use Inpaint in AnalyzeCellCount using a raw data file:"},
			Defer@AnalyzeCellCount[
				myHemocytometerCloudFile,
				Hemocytometer->True,
				ImageSegmentation->{
					EdgeDetect[Image->"ImageAdjustment Result"],
					Closing[Kernel->3],
					Closing[Kernel->DiskMatrix[2],OutputImageLabel->"processedCells"],
					RidgeFilter[Scale->1.5,ImageAdjust->True,OutputImageLabel->"ridges"],
					MorphologicalBinarize[Threshold->{0.05,0.5},OutputImageLabel->"mask"],
					Inpaint[Image->"processedCells",Region->"mask",Method->Diffusion,OutputImageLabel->"inpainted"]
				},
				PropertyMeasurement->{
					AreaProperties,Centroid
				},
				PlotProcessingSteps->True,
				Output->Preview
			],
			_Defer,
			Variables:>{myHemocytometerCloudFile},
			SetUp:>{
				$CreatedObjects={};
				myHemocytometerCloudFile=Object[EmeraldCloudFile,"id:WNa4ZjK4Pm0R"];
			},
			TearDown:>{
				EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
			}
		]
	}
];

(* ::Subsubsection:: *)
(* GradientFilter *)

DefineTests[GradientFilter,
  {
    Example[{Basic, "Make a GradientFilter Unit Operations with input image and radius:"},
      GradientFilter[
        Image -> "Input image",
        GaussianParameters -> 1
      ],
      _GradientFilter
    ],
    Example[{Basic,"Make a GradientFilter Unit Operations with input image and parameters that are radius and standard deviation:"},
      GradientFilter[
        Image -> "Input image",
        GaussianParameters -> {5,2}
      ],
      _GradientFilter
    ],
    Example[{Basic,"Make a GradientFilter Unit Operations with output image label:"},
      GradientFilter[
        Image -> "Input image",
        GaussianParameters -> {5,2},
        OutputImageLabel -> "GradientFiltered image"
      ],
      _GradientFilter
    ],
    Example[{Basic, "Use GradientFilter in AnalyzeCellCount using a protocol object:"},
      Defer@AnalyzeCellCount[
        Object[Protocol, ImageCells, "ImageCells protocol for analysis function"][Data][[2]],
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer
    ],
    Example[{Basic,"Use GradientFilter in AnalyzeCellCount using a raw data file:"},
      Defer@AnalyzeCellCount[
        myNuclearLabelingMainCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      Variables:>{myNuclearLabelingMainCloudFile},
      SetUp:>{
        $CreatedObjects={};
        myNuclearLabelingMainCloudFile=Object[EmeraldCloudFile, "id:rea9jlRlRdqo"];
      },
      TearDown:>{
        EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
      }
    ]
  }
];

(* ::Subsubsection:: *)
(* ImageMultiply *)

DefineTests[ImageMultiply,
  {
    Example[{Basic, "Make a ImageMultiply Unit Operations with single input image:"},
      ImageMultiply[
        Image -> "Input image"
      ],
      _ImageMultiply
    ],
    Example[{Basic,"Make a ImageMultiply Unit Operations with second image:"},
      ImageMultiply[
        Image -> "Input image",
        SecondImage -> "Second image"
      ],
      _ImageMultiply
    ],
    Example[{Basic,"Make a ImageMultiply Unit Operations with output image label:"},
      ImageMultiply[
        Image -> "Input image",
        SecondImage -> "Second image",
        OutputImageLabel -> "Output image"
      ],
      _ImageMultiply
    ],
    Example[{Basic, "Use ImageMultiply in AnalyzeCellCount using a protocol:"},
      Defer@AnalyzeCellCount[
        Object[Protocol,ImageCells,"ImageCells hemocytometer protocol for analysis function"][Data][[1]],
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer
    ],
    Example[{Basic,"Use ImageMultiply in AnalyzeCellCount using a raw data file:"},
      Defer@AnalyzeCellCount[
        myNuclearLabelingMainCloudFile,
        ImageAdjustment->{
          ImageAdjust[Correction->{0,3},OutputImageLabel->"adjusted"],
          BilateralFilter[Radius->1,PixelValueSpread->1/12]
        },
        ImageSegmentation->{
          MorphologicalBinarize[OutputImageLabel->"imageBackground"],
          GaussianFilter[Image->"ImageAdjustment Result",GaussianParameters->15*{3,1}],
          MinDetect[OutputImageLabel->"extendedMinima"],
          ImageMultiply[Image->"imageBackground",SecondImage->"extendedMinima",OutputImageLabel->"cellSeeds"],
          WatershedComponents[Image->"ImageAdjustment Result",Marker->"cellSeeds",Method->Basins,ColorNegate->True,BitMultiply->"imageBackground"]
        },
        PropertyMeasurement->{
          AreaProperties,Centroid
        },
        PlotProcessingSteps->True,
        Output->Preview
      ],
      _Defer,
      Variables:>{myNuclearLabelingMainCloudFile},
      SetUp:>{
        $CreatedObjects={};
        myNuclearLabelingMainCloudFile=Object[EmeraldCloudFile, "id:rea9jlRlRdqo"];
      },
      TearDown:>{
        EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
      }
    ]
  }

];
