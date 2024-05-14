(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotImage*)


DefineTests[PlotImage,{

	Example[{Basic,"Create a zoomable image with rulers around the frame:"},
		PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		plotImageP
	],

	Example[{Basic,"Overlay several images:"},
		PlotImage[{Object[EmeraldCloudFile, "id:N80DNj149v1o"], Object[EmeraldCloudFile, "id:xRO9n3Be0EOY"]}],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a raw image:"},
		With[{img=ImportCloudFile[Object[EmeraldCloudFile, "id:N80DNj149v1o"]]},
		PlotImage[img]
			],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a cloud file image:"},
		PlotImage[Object[EmeraldCloudFile, "id:eGakldJOE5jE"]],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a gel image from Object[Data,PAGE]:"},
		PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a BrightField cell image from Object[Data,Microscope]:"},
		PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"]],
		plotImageP,
		Stubs:>{
			PlotImage[
				Object[Data, Microscope, "id:AEqRl954GZpp"]
			]=PlotImage[
				Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"],PhaseContrastImage],2],
				Scale->Quantity[0.75, IndependentUnit["Pixels"]/("Micrometers")]
			]
		}
	],
	Test["BrightField cell image from Object[Data,Microscope]:",
		PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"]],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a tube image from Object[Data,Appearance]:"},
		PlotImage[Object[Data, Appearance, "id:dORYzZn0YDDG"]],
		plotImageP,
		Stubs:>{
			PlotImage[
				Object[Data, Appearance, "id:dORYzZn0YDDG"]
			]=PlotImage[
				Downsample[Download[Object["id:dORYzZn0YDDG"], Image],10],
				Scale -> Quantity[116., IndependentUnit["Pixels"]/("Centimeters")]
			]
		}
	],
	Test["PlotImage works with Object[Data,Appearance]:",
		PlotImage[Object[Data, Appearance, "id:dORYzZn0YDDG"]],
		plotImageP
	],


	

	Example[{Options,RulerPlacement,"Place a ruler only on the left frame:"},
		PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"],RulerPlacement->Left],
		ZoomableP,
		Stubs:>{
			PlotImage[
				Object[Data, Microscope, "id:AEqRl954GZpp"],
				RulerPlacement->Left
			]=PlotImage[
				Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"],PhaseContrastImage],2],
				RulerPlacement->Left,
				Scale->Quantity[0.75, IndependentUnit["Pixels"]/("Micrometers")]
			]
		}
	],

	Example[{Options,Scale,"Specify the scale of the image in terms of pixels/distance:"},
		PlotImage[Object[Data, Appearance, "id:dORYzZn0YDDG"],Scale->100*Pixel/Inch],
		plotImageP,
		Stubs:>{
			PlotImage[
				Object[Data, Appearance, "id:dORYzZn0YDDG"],
				Scale->100*Pixel/Inch
			]=PlotImage[
				Downsample[Download[Object["id:dORYzZn0YDDG"], Image],10],
				Scale->10*Pixel/Inch
			]
		}
	],

	Example[{Options,ImageSize,"Specify the image size:"},
		PlotImage[Object[EmeraldCloudFile, "id:eGakldJOE5jE"], ImageSize -> 300],
		plotImageP
	],

	Test["Given packet:",
		PlotImage[Download[Object[Data, PAGE, "id:D8KAEvdqvldl"]]],
		plotImageP
	],

	Test["Given link:",
		PlotImage[Link[Object[Data, PAGE, "id:D8KAEvdqvldl"],Reference]],
		plotImageP
	],

  (* Output tests *)
  Test[
    "Setting Output to Result displays the image:",
    PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"],Output->Result],
    plotImageP
    ],

  Test[
    "Setting Output to Preview displays the image:",
    PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"],Output->Preview],
    plotImageP
    ],

  Test[
    "Setting Output to Options returns the resolved options:",
    PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"],Output->Options],
    ops_/;MatchQ[ops,OptionsPattern[PlotImage]]
    ],

  Test[
    "Setting Output to Tests returns a list of tests:",
    PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"],Output->Tests],
    {(_EmeraldTest|_Example)...}
    ],

  Test[
    "Setting Output to {Result,Options} displays the image and returns all resolved options:",
    PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"],Output->{Result,Options}],
    output_List/;MatchQ[First@output,ZoomableP]&&MatchQ[Last@output,OptionsPattern[PlotImage]]
    ],
	
	
	(* Flag controlled tests by ECL`$CCD *)
	Sequence@@If[Not@ECL`$CCD,
		(* Old Zoomable Tests *)
		{
			
			Example[{Additional, "Input Types", "Plot an image from a Model[Container, Vessel] with scale bars, if applicable:"},
				PlotImage[Model[Container, Vessel, "id:3em6Zv9NjjN8"]], (* 2mL Tube *)
				plotImageP,
				Stubs :> {
					PlotImage[
						Model[Container, Vessel, "id:3em6Zv9NjjN8"]
					] = Staticize@PlotImage[
						Downsample[ImportCloudFile@Download[Model[Container, Vessel, "id:3em6Zv9NjjN8"], ImageFile], 10],
						Scale -> Quantity[48.013245033112594`, IndependentUnit["Pixels"] / ("Centimeters")]
					]
				}
			],
			
			Example[{Messages, "MixedMeasurementLineDimensions", "Specifying MeasurementLine points with mixed dimensions throws an error:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{2 Meter, 100}, {2 Meter, 5 Meter}}}],
				$Failed,
				Messages :> {Error::MixedMeasurementLineDimensions, Error::InvalidOption}
			],
			
			Example[{Options, RulerType, "Absolute ruler type preserves the absolute positions in the image during zooming:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], RulerType -> Absolute],
				plotImageP,
				Stubs :> {
					PlotImage[
						Object[Data, Microscope, "id:AEqRl954GZpp"],
						RulerPlacement -> Absolute
					] = PlotImage[
						Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"], PhaseContrastImage], 2],
						RulerPlacement -> Absolute,
						Scale -> Quantity[0.75, IndependentUnit["Pixels"] / ("Micrometers")]
					]
				}
			],
			
			Example[{Options, MeasurementLines, "Add a measurement line to the image. Use Ctrl+LeftClick+Dragging (Cmd+LeftClick+Dragging on Mac) to move the points:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}}],
				plotImageP
			],
			
			Example[{Options, TargetUnits, "Display the side rulers in Inches and the top and bottom rulers in Centimeters:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], TargetUnits -> {Inch, Centimeter}],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Centimeters", GrayLevel[0], Bold, 13], Style["Centimeters", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], Rule[FrameLabel, f_] :> f, Infinity], #2]&)
			],
			
			Example[{Options, TargetUnits, "Specify distance unit for frame rulers:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], TargetUnits -> Inch],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], Rule[FrameLabel, f_] :> f, Infinity], #2]&)
			],
			
			Example[{Options, TargetUnits, "Specify a different distance unit for each frame ruler:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], TargetUnits -> {{Centimeter, Meter}, {Inch, Foot}}],
				{{{Style["Centimeters", GrayLevel[0], Bold, 13], Style["Meters", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Feet", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], Rule[FrameLabel, f_] :> f, Infinity], #2]&)
			],
			
			Example[{Options, MeasurementLines, "Specify two measurement lines.  Use Ctrl+LeftClick to add (Cmd+LeftClick on Mac) and Ctrl+RightClick to remove (Cmd+RightClick on Mac) measurement lines:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}, {{70, 125}, {430, 125}}}],
				{Disk[{425, 230}, 4.375`], Disk[{425, 100}, 4.375`], Disk[{70, 125}, 4.375`], Disk[{430, 125}, 4.375`]},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], _Disk, Infinity], #2]&)
			],
			
			Example[{Options, MeasurementLines, "Label measurement lines with distance:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}, {{70, 125}, {430, 125}}}, MeasurementLabel -> True],
				{Text[Row[{" ", _NumberForm, " "}], {425, 165}, Background -> GrayLevel[1]], Text[Row[{" ", _NumberForm, " "}], {250, 125}, Background -> GrayLevel[1]]},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], _Text, Infinity], #2]&)
			],
			
			Example[{Options, MeasurementLines, "Measurement line labels appear on mouseover:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}, {{70, 125}, {430, 125}}}, MeasurementLabel -> False],
				{},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], _Text, Infinity], #2]&)
			],
			
			Example[{Options, MeasurementLabel, "Measurement line labels appear only on mouseover, and are hidden otherwise:"},
				{
					PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}}, MeasurementLabel -> False],
					PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], MeasurementLines -> {{{425, 230}, {425, 100}}}, MeasurementLabel -> True]
				},
				g_ /; Length@Cases[Staticize[g], _Text, Infinity] == 1
			],
			
			Example[{Options, AspectRatio, "Specify the height-to-width ratio of the image:"},
				PlotImage[Object[Data, PAGE, "id:D8KAEvdqvldl"], AspectRatio -> 2],
				g_ /; (MatchQ[g, ZoomableP] && (First@Cases[Staticize[g], Rule[AspectRatio, ar_] :> ar, Infinity]) == 2)
			],
			
			Example[{Options, RulerPlacement, "Place rulers on the top and right frames:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], RulerPlacement -> {Top, Right}],
				{{{False, True}, {False, True}}},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], Rule[Frame, f_] :> f, Infinity], #2]&)
			],
			
			Example[{Options, RulerType, "Relative ruler type resets each ruler to start at zero during every zoom:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], RulerType -> Relative],
				plotImageP,
				Stubs :> {
					PlotImage[
						Object[Data, Microscope, "id:AEqRl954GZpp"],
						RulerPlacement -> Relative
					] = PlotImage[
						Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"], PhaseContrastImage], 2],
						RulerPlacement -> Relative,
						Scale -> Quantity[0.75, IndependentUnit["Pixels"] / ("Micrometers")]
					]
				}
			],
			
			Test["Set the scale of the image in pixels/distance:",
				PlotImage[Object[Data, Appearance, "id:dORYzZn0YDDG"], Scale -> 100 * Pixel / Inch],
				{{{Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}, {Style["Inches", GrayLevel[0], Bold, 13], Style["Inches", GrayLevel[0], Bold, 13]}}},
				EquivalenceFunction -> (MatchQ[Cases[Staticize[#1], Rule[FrameLabel, f_] :> f, Infinity], #2]&)
			]
			
		},
			
	
  	(* New Zoomable Tests *)
		
		{
			Example[{Additional, "Input Types", "Plot an image from a Model[Container, Vessel] with scale bars, if applicable:"},
				PlotImage[Model[Container, Vessel, "id:3em6Zv9NjjN8"]],
				plotImageP
			],
			
			(* add messages test for unused option *)
			(* Example[{Messages, "UnusedPlotImageOption", "A warning is thrown if an option is not used in PlotImage:"},
				PlotImage[Model[Container, Vessel, "id:3em6Zv9NjjN8"], AlignmentPoint->{5,5}],
				plotImageP,
				Messages:>{Warning::UnusedPlotImageOption}
			], *)
			
			(* Target Units example *)
			Example[{Options, TargetUnits, "TargetUnits sets the units for the rulers on the image edge:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], TargetUnits -> Millimeter],
				plotImageP
			],
			
			Example[{Options, TargetUnits, "TargetUnits need a Scale to properly set ruler units:"},
				PlotImage[Object[EmeraldCloudFile, "id:N80DNj149v1o"], TargetUnits -> Centimeter, Scale -> 0.4 Millimeter/Pixel],
				plotImageP
			],
			
			(* PlotRange example *)
			Example[{Options, PlotRange, "Use PlotPlotRange to zoom in on a selected portion of the image. PlotRange will scale based on the TargetUnits of the image:"},
				PlotImage[Object[EmeraldCloudFile, "id:N80DNj149v1o"], TargetUnits -> Centimeter, Scale -> 0.4 Millimeter/Pixel, PlotRange -> {{5, 15}, {5, 10}}],
				plotImageP
			],
			
			(* frame label example, with scale units *)
			Example[{Options, FrameLabel, "FrameLabel will add titles to the x and y axes of the image. If there are units in the image, they will be appended to the titles:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], FrameLabel -> {"Bottom", "Left"}],
				plotImageP
			],
			
			Example[{Options, FrameLabel, "FrameLabel will leave off title specified with None:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], FrameLabel -> {"Bottom", None}],
				plotImageP
			],
			
			(* ZoomMethod *)
			Example[{Options, ScrollZoom, "By default, ScrollZoom allows zooming with the mouse wheel, but when turned off, the option will restrict the type of zooming allowed:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], ScrollZoom -> False],
				plotImageP
			],
			
			(* PreserveAspectRatio *)
			Example[{Options, PreserveAspectRatio, "Set PreserveAspectRatio to False to allow zooming that does not keep the same height to width ratio as the original image:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], PreserveAspectRatio -> False],
				plotImageP
			],
			
			(* AutoDownsampling *)
			Example[{Options, AutoDownsampling, "Set AutoDownsampling to False to retain maximum resolution at all zooming levels, although this may slow down zooming performance:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], AutoDownsampling -> False],
				plotImageP
			],
			
			(* ImageSize Large *)
			Example[{Options, ImageSize, "Set ImageSize using the relative sizing:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], ImageSize -> Large],
				plotImageP
			],
			
			(* ImageSize one number *)
			Example[{Options, ImageSize, "Set ImageSize using a single number to control the image dimensions, while preserving the original aspect ratio:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], ImageSize -> 400],
				plotImageP
			],
			
			
			(* ImageSize two numbers *)
			Example[{Options, ImageSize, "Set ImageSize using two numbers to control both the size the aspect ratio:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], ImageSize -> {400, 200}],
				plotImageP
			],
			
			(* Plot Title *)
			Example[{Options, PlotLabel, "PlotLabel adds a title to the top of the image:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], PlotLabel->"My Plot Title"],
				plotImageP
			],
			
			(* Background *)
			Example[{Options, Background, "Set Background to a color to shade around the image:"},
				PlotImage[Object[Data, Microscope, "id:AEqRl954GZpp"], Background -> Red],
				plotImageP
			]
		}
		
	]
	
	

}];



(* ::Subsection:: *)
(*PlotImagePreview*)


DefineTests[PlotImagePreview,{

	Example[{Basic,"Create a zoomable image with rulers around the frame:"},
		PlotImagePreview[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		plotImageP
	],

	Example[{Basic,"Overlay several images:"},
		PlotImagePreview[{Object[EmeraldCloudFile, "id:N80DNj149v1o"], Object[EmeraldCloudFile, "id:xRO9n3Be0EOY"]}],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a raw image:"},
		With[{img=ImportCloudFile[Object[EmeraldCloudFile, "id:N80DNj149v1o"]]},
			PlotImagePreview[img]
		],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a cloud file image:"},
		PlotImagePreview[Object[EmeraldCloudFile, "id:eGakldJOE5jE"]],
		plotImageP
	],

	Example[{Additional,"Input Types","Plot a gel image from Object[Data,PAGE]:"},
		PlotImagePreview[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		plotImageP
	],
	
	Sequence@@If[Not[ECL`$CCD],
		
		{
			
			Example[{Additional, "Input Types", "Plot a BrightField cell image from Object[Data,Microscope]:"},
				PlotImagePreview[Object[Data, Microscope, "id:AEqRl954GZpp"]],
				plotImageP,
				Stubs :> {
					PlotImagePreview[
						Object[Data, Microscope, "id:AEqRl954GZpp"]
					] = Staticize@PlotImagePreview[
						Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"], PhaseContrastImage], 2],
						Scale -> Quantity[0.75, IndependentUnit["Pixels"] / ("Micrometers")]
					]
				}
			],
			Example[{Additional, "Input Types", "Plot a tube image from Object[Data,Appearance]:"},
				PlotImagePreview[Object[Data, Appearance, "id:dORYzZn0YDDG"]],
				plotImageP,
				Stubs :> {
					PlotImagePreview[
						Object[Data, Appearance, "id:dORYzZn0YDDG"]
					] = Staticize@PlotImagePreview[
						Downsample[Download[Object["id:dORYzZn0YDDG"], Image], 10],
						Scale -> Quantity[116., IndependentUnit["Pixels"] / ("Centimeters")]
					]
				}
			]
		},
		
		Nothing
		
	]

}];



(* ::Subsection:: *)
(*PlotImageOptions*)


DefineTests[PlotImageOptions,{

	Example[{Basic,"Create a zoomable image with rulers around the frame:"},
		PlotImageOptions[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		_List
	],

	Example[{Basic,"Overlay several images:"},
		PlotImageOptions[{Object[EmeraldCloudFile, "id:N80DNj149v1o"], Object[EmeraldCloudFile, "id:xRO9n3Be0EOY"]}],
		_List
	],

	Example[{Additional,"Input Types","Plot a raw image:"},
		With[{img=ImportCloudFile[Object[EmeraldCloudFile, "id:N80DNj149v1o"]]},
			PlotImageOptions[img]
		],
		_List
	],

	Example[{Additional,"Input Types","Plot a cloud file image:"},
		PlotImageOptions[Object[EmeraldCloudFile, "id:eGakldJOE5jE"]],
		_List
	],

	Example[{Additional,"Input Types","Plot a gel image from Object[Data,PAGE]:"},
		PlotImageOptions[Object[Data, PAGE, "id:D8KAEvdqvldl"]],
		_List
	],

	Example[{Additional,"Input Types","Plot a BrightField cell image from Object[Data,Microscope]:"},
		PlotImageOptions[Object[Data, Microscope, "id:AEqRl954GZpp"]],
		_List,
		Stubs:>{
			PlotImageOptions[
				Object[Data, Microscope, "id:AEqRl954GZpp"]
			]=PlotImageOptions[
				Downsample[Download[Object[Data, Microscope, "id:AEqRl954GZpp"],PhaseContrastImage],2],
				Scale->Quantity[0.75, IndependentUnit["Pixels"]/("Micrometers")]
			]
		}
	],
	Example[{Additional,"Input Types","Plot a tube image from Object[Data,Appearance]:"},
		PlotImageOptions[Object[Data, Appearance, "id:dORYzZn0YDDG"]],
		_List,
		Stubs:>{
			PlotImageOptions[
				Object[Data, Appearance, "id:dORYzZn0YDDG"]
			]=PlotImageOptions[
				Downsample[Download[Object["id:dORYzZn0YDDG"], Image],10],
				Scale -> Quantity[116., IndependentUnit["Pixels"]/("Centimeters")]
			]
		}
	]

}];
(* ::Section:: *)
(*End Test Package*)
