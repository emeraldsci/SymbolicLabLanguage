(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListLinePlot*)


DefineTests[EmeraldListLinePlot,

	{

		Example[{Basic,"Plot a single trace:"},
			EmeraldListLinePlot[chrom1],
			ValidGraphicsP[]
		],
		Example[{Basic,"Overlay multiple traces on one plot:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Multiple primary traces:"},
			EmeraldListLinePlot[{{chrom1,chrom1b},{chrom2,chrom2b}}],
			ValidGraphicsP[]
		],


		(*
			REPLICATES
		*)
		Example[{Additional,"Replicates","Specify replicate data:"},
			EmeraldListLinePlot[Replicates@@Table[Table[{x,x^3+RandomVariate[NormalDistribution[0,.1]]},{x,-1,1,0.1}],{16}]],
			ValidGraphicsP[]
		],
		Example[{Additional,"Replicates","Mixture of replicates and non-replicates:"},
			Module[{xyA,xyB,xyC},
				xyA=Table[{x,x^2},{x,-1,1,0.05}];
				xyB=Table[Table[{x,x^3+RandomVariate[NormalDistribution[0,.1]]},{x,-1,1,0.1}],{16}];
				xyC=Table[{x,x},{x,-1,1,0.1}];
				EmeraldListLinePlot[{xyA,Replicates@@xyB,xyC}]
			],
			ValidGraphicsP[]
		],

	(*
			DISTRIBUTIONS
		*)
		Example[{Additional,"Distributions","Data points can be distributions:"},
			EmeraldListLinePlot[{{100, 0.05 }, {200 ,
				EmpiricalDistribution[{0.2, 0.3, 0.1, 0.25} ]}, {400 ,
				NormalDistribution[0.3 , 0.05 ]}, {NormalDistribution[600 , 25 ],
				EmpiricalDistribution[{0.7, 0.8, 0.9} ]}, {1000 , 1 }}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Distributions","Distribution units must match other data units:"},
			EmeraldListLinePlot[{
				{100 Microliter, 0.1 Gram},
				{200 Microliter,
					EmpiricalDistribution[{0.2, 0.3, 0.1,
						0.25} Gram]}, {400 Microliter,
					NormalDistribution[0.3 Gram, 0.05 Gram]}, {NormalDistribution[
					600 Microliter, 25 Microliter],
					EmpiricalDistribution[{0.7, 0.8, 0.9} Gram]}, {1000 Microliter,
					1 Gram}}],
			ValidGraphicsP[]
		],

		(*
			UNITS
		*)
		Example[{Additional,"Units","Units of associated data sets must be compatible, but do not need to be the same:"},
			EmeraldListLinePlot[
				{chrom1,Convert[chrom2,{Hour,Milli*AbsorbanceUnit}]},
				SecondYCoordinates->{
					{Convert[temp1,{Minute,Fahrenheit}],press1},
					{temp2,Convert[press2,{Year,Torr}]}
				}
			],
			ValidGraphicsP[]
		],
		Test["Second-y data with incompatible x-unit:",
			EmeraldListLinePlot[chrom1,SecondYCoordinates->Unitless[press1]],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],


		Example[{Additional,"PrimaryData","Specify additional primary data along with secondary data and legend:"},
			EmeraldListLinePlot[
				{{chrom1,chrom1b},{chrom2,chrom2b},{chrom3,chrom3b}},
				SecondYCoordinates->{{temp1,press1},{temp2,press2},{temp3,press3}},
				Legend->{{"Chrom1A","Chrom1B"},{"Chrom2A","Chrom2B"},{"Chrom3A","Chrom3B"}},
				Boxes->True,LegendPlacement->Right
			],
			ValidGraphicsP[]
		],

		(*
			MISSING DATA
		*)
		Example[{Additional,"Missing Data","Null values in a coordinate list are ignored and not connected:"},
			EmeraldListLinePlot[{{0,3},{1,1},{2,2},{3,Null},{3,3},{4,4},{5,2}}],
			ValidGraphicsP[]?(MatchQ[Cases[#[[1]],_Line,Infinity],{Line[{{0.`,3.`},{1.`,1.`},{2.`,2.`}}],Line[{{3.`,3.`},{4.`,4.`},{5.`,2.`}}]}]&)
		],
		Test["Nulls are acceptable for x, y, or both, and are ignored and not connected:",
			EmeraldListLinePlot[{{0,3},{1,1},{Null,2},{3,3},{4,4},{5,Null},{6,3},{7,4},{Null,Null},{9,6},{10,3}}],
			ValidGraphicsP[]?(MatchQ[Cases[#[[1]],_Line,Infinity],{Line[{{0.`,3.`},{1.`,1.`}}],Line[{{3.`,3.`},{4.`,4.`}}],Line[{{6.`,3.`},{7.`,4.`}}],Line[{{9.`,6.`},{10.`,3.`}}]}]&)
		],
		Example[{Additional,"Missing Data","Null values in primary data set are ignored:"},
			EmeraldListLinePlot[{chrom1,Null,chrom3}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values in secondary data set are ignored:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{{temp1,press1},{Null,press2}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null values at top level of secondary data set skip that data entirely:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{Null,{temp2,press2}}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Null is also the placeholder for absent Peaks:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->{Null,pks2}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Secondary axis is labeled with first signal that is not completely null:"},
			EmeraldListLinePlot[{Null,chrom2,chrom3},SecondYCoordinates->{{Null,press1},{Null,Null},Null}],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","An empty plot is returned if no data is given:"},
			EmeraldListLinePlot[Null],
			ValidGraphicsP[]
		],
		Example[{Additional,"Missing Data","Can specify secondary data without primary data:"},
			EmeraldListLinePlot[Null,SecondYCoordinates->press1],
			ValidGraphicsP[]
		],



		(*
			OPTIONS
		*)
		Example[{Options,Zoomable,"Make the plot zoomable:"},
			EmeraldListLinePlot[chrom1,Zoomable->True],
			ZoomableP
		],
		Test["Zoomable->False produces regular plot:",
			EmeraldListLinePlot[chrom1,Zoomable->False],
			Except[ZoomableP]
		],

		Example[{Options,Frame,"Specify which parts of the plot's frame should be visible. Frame is specified in the format {{Left Frame, Right Frame},{Bottom Frame, Top Frame}}. In the following example, all frame borders are visible:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, Frame -> {{True, True}, {True, True}}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],

		Example[{Options,Frame,"Specify which parts of the plot's frame should be visible. Frame is specified in the format {{Left Frame, Right Frame},{Bottom Frame, Top Frame}}. In the following example, only the left and bottom frame borders are visible:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, Frame -> {{True, False}, {True, False}}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, FrameStyle -> DotDashed],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, FrameStyle -> Dotted],
			ValidGraphicsP[]
		],

		Example[{Options,FrameStyle,"Specify the style of the plot's frame. FrameStyle can be set to any valid graphics directive. For more information, evaluate ?FrameStyle in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, FrameStyle -> Dashed],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicksStyle,"Specify the style of the plot's frame ticks. FrameTicksStyle can be set to any valid graphics directive. For more information, evaluate ?FrameTicksStyle in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, FrameTicksStyle -> Directive[Orange, 12]],
			ValidGraphicsP[]
		],

		Example[{Options,GridLines,"Specify the grid lines of this plot. Setting GridLines->None shows no grid lines, this is the default value for GridLines. For more information, evaluate ?GridLines in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, GridLines -> None],
			ValidGraphicsP[]
		],

		Example[{Options,GridLinesStyle,"Specify the style of the plot's grid lines. GridLinesStyle can be set to any valid graphics directive. For more information, evaluate ?GridLinesStyle in the notebook:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, GridLines -> Automatic, GridLinesStyle -> Orange],
			ValidGraphicsP[]
		],

		Example[{Options,LabelStyle,"Specify how the plot's label should be styled. Evaluate ?LabelStyle in the notebook for more information:"},
			EmeraldListLinePlot[chrom1,LabelStyle -> Orange],
			ValidGraphicsP[]
		],

		Example[{Options,Background,"Specify the background of the plot using a Color directive:"},
			EmeraldListLinePlot[chrom1, Background -> Lighter[Gray, 0.5]],
			ValidGraphicsP[]
		],
		Example[{Options,RotateLabel,"Specify whether to rotate the label of the Y-Axis on the plot:"},
			EmeraldListLinePlot[chrom1, RotateLabel -> False],
			ValidGraphicsP[]
		],
		Example[{Options,RotateLabel,"Specify whether to rotate the label of the Y-Axis on the plot:"},
			EmeraldListLinePlot[chrom1, RotateLabel -> True],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Specify plot range for primary data.  Units in PlotRange must be compatible with primary data units:"},
			EmeraldListLinePlot[chrom1,PlotRange->{{Automatic,0.7*Minute},{0.1*AbsorbanceUnit,400Milli*AbsorbanceUnit}}],
			ValidGraphicsP[]
		],
		Example[{Options,PlotRange,"Can mix explicit specification with Automatic resolution:"},
			Module[{pts},
				pts=Replace[Table[{x,x^2},{x,-1,1,0.1}],{1.,1.}->{1.,200.},{1}];
				{
					EmeraldListLinePlot[pts,PlotRange->{Automatic,Automatic},ImageSize->350],
					EmeraldListLinePlot[pts,PlotRange->{{-1,0.8},Automatic},ImageSize->350]
				}
			],
			{
				ValidGraphicsP[]?(MatchQ[AbsoluteOptions[#,PlotRange],{PlotRange->{{-1.`,1.`},{-14.999999999999991`,215.`}}}]&),
				ValidGraphicsP[]?(MatchQ[AbsoluteOptions[#,PlotRange],{PlotRange->{{-1.`,0.8`},{-0.07499999999999996`,1.075`}}}]&)
			}
		],
		Example[{Options,PlotRange,"Automatic resolution of Y-range depends on the values remaining after filtering based on X-range:"},
			EmeraldListLinePlot[chrom1,PlotRange->{{Automatic,0.7*Minute},Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRange,"Automatic resolution of Y-range depends on the values remaining after filtering based on X-range:"},
			EmeraldListLinePlot[chrom1,PlotRange->{{Automatic,0.7*Minute},Automatic}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"PlotRangeClipping specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange or should be allowed to extend to the actual edge of the image. In the following example, the data extends past the actual PlotRange of the image:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, PlotRange -> {{0, 50}, {0, 0.6}}, PlotRangeClipping -> False],
			ValidGraphicsP[]
		],

		Example[{Options,PlotRangeClipping,"PlotRangeClipping specifies whether graphics objects should be clipped at the edge of the region defined by PlotRange or should be allowed to extend to the actual edge of the image. In the following example, the data is cutoff at 50, since that is the maximum x-value set by the PlotRange:"},
			EmeraldListLinePlot[{chrom1, chrom2, chrom3}, PlotRange -> {{0, 50}, {0, 0.6}}, PlotRangeClipping -> True],
			ValidGraphicsP[]
		],

		Example[{Options,InterpolationOrder,"InterpolationOrder specifes the degree of polynomial that should be used to fit data points:"},
			Table[EmeraldListLinePlot[{{0, 0}, {1, 2}, {3, 4}, {4, 2}, {6, 0}}, InterpolationOrder -> n], {n, {0, 1, 3}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,Filling,"Fill the area above the data of the plot:"},
			EmeraldListLinePlot[chrom1, Filling -> Top],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill the area below the data of the plot:"},
			EmeraldListLinePlot[chrom1, Filling -> Bottom],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill the area between the data of the plot and the axis:"},
			EmeraldListLinePlot[chrom1, Filling -> Axis],
			ValidGraphicsP[]
		],

		Example[{Options,Filling,"Fill the area between the data of the plot and the line y=0.3:"},
			EmeraldListLinePlot[chrom1, Filling -> 0.3],
			ValidGraphicsP[]
		],

		Example[{Options,FillingStyle,"Use FillingStyle to specify the style of the plot filling. To see more example of possible styles, evaluate ?FillingStyle in the notebook:"},
			EmeraldListLinePlot[chrom1,Filling->Bottom,FillingStyle->Directive[Orange,Opacity[0.5]]],
			ValidGraphicsP[]
		],

		Example[{Options,LabelingFunction,"Specify a pure function that generates labels for each point in the plot. This function should take in coordinates and return graphics primitives. For more information, evaluate ?LabelingFunction in the notebook:"},
			EmeraldListLinePlot[chrom1, LabelingFunction -> (Placed[Panel[#1, FrameMargins -> 0], Automatic] &), PlotMarkers -> \[FilledSquare]],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldListLinePlot[chrom1, ColorFunction -> "BlueGreenYellow"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldListLinePlot[chrom1, ColorFunction -> "ThermometerColors"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunction,"Specify a coloring function for the lines in our plot. To see all of the built in ColorFunctions, evaluate ColorData[\"Gradients\"] in the notebook:"},
			EmeraldListLinePlot[chrom1, ColorFunction -> "DeepSeaColors"],
			ValidGraphicsP[]
		],

		Example[{Options,ColorFunctionScaling,"Specify if the coloring function should be scaled to the range of this plot:"},
			EmeraldListLinePlot[chrom1, ColorFunction -> "TemperatureMap", ColorFunctionScaling -> False],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Specify how clipped values should be styled in the plot. For more information, evaluate ?ClippingStyle in the notebook:"},
			EmeraldListLinePlot[chrom1, ClippingStyle -> Red, PlotRange -> {{0, 60}, {0, 0.5}}],
			ValidGraphicsP[]
		],

		Example[{Options,ClippingStyle,"Specify how clipped values should be styled in the plot. For more information, evaluate ?ClippingStyle in the notebook:"},
			EmeraldListLinePlot[chrom1, ClippingStyle -> Opacity[0.5], PlotRange -> {{0, 60}, {0, 0.5}}],
			ValidGraphicsP[]
		],

		Example[{Options,PlotMarkers,"Specify how data points on the plot should be marked:"},
			EmeraldListLinePlot[chrom1, PlotMarkers->\[FilledSquare]],
			ValidGraphicsP[]
		],

		Example[{Options,PlotMarkers,"Specify how data points on the plot should be marked:"},
			EmeraldListLinePlot[chrom1, PlotMarkers->\[FilledDiamond]],
			ValidGraphicsP[]
		],

		Example[{Options,PlotMarkers,"Specify how data points on the plot should be marked:"},
			EmeraldListLinePlot[chrom1, PlotMarkers->\[FilledCircle]],
			ValidGraphicsP[]
		],

		Example[{Options,PlotStyle,"Specify the style of the data to be plotted:"},
			EmeraldListLinePlot[chrom1,PlotStyle->Orange],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabels,"When multiple datasets are plotted, provide a label for each plot:"},
			EmeraldListLinePlot[{temp1,temp2,temp3},PlotLabels->{"C","B","A"}],
			ValidGraphicsP[]
		],
		Example[{Options,PlotLabels,"Add styling to the PlotLabels for each dataset:"},
			EmeraldListLinePlot[{temp1, temp2, temp3},
 				PlotLabels->{Style["C",Blue,12],Style["B",Orange,25],Style["A",Green,40]}
			],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Specify the AspectRatio of our plot. The AspectRatio is the ratio of the height to the width:"},
			EmeraldListLinePlot[chrom1,AspectRatio -> 2],
			ValidGraphicsP[]
		],

		Example[{Options,AspectRatio,"Specify the AspectRatio of our plot. The AspectRatio is the ratio of the height to the width:"},
			EmeraldListLinePlot[chrom1,AspectRatio -> 1/2],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLabel,"Specify the label of our plot:"},
			EmeraldListLinePlot[chrom1, PlotLabel -> "Chromatography Data from Run #4"],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYCoordinates,"Specify data for second-y axis:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->temp1],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYCoordinates,"Specify multiple data sets for second-y axis:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->{temp1,press1}],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYCoordinates,"Specify second-y data for multilpe primary data sets:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},SecondYCoordinates->{{temp1,press1},{temp2,press2},{temp3,press3}}],
			ValidGraphicsP[]
		],


		Example[{Options,SecondYColors,"Specify colors for second-y data:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->{temp1,press1},SecondYColors->{Orange,Purple}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYUnit,"Unit for secondary data axis:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{temp1,temp2},SecondYUnit->Kelvin],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYRange,"Plot range for secondary data axis:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{temp1,temp2},SecondYRange->{-50Celsius,200Celsius}],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYRange,"Plot range for all sets of secondary data:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->{temp1,press1},SecondYRange->{{-50Celsius,200Celsius},{-10*Kilopascal,10*Kilopascal}}],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYRange,"SecondYRange can be a mixture of explicit ranges and Automatics:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->{temp1,press1},SecondYRange->{{-50Celsius,200Celsius},Automatic}],
			ValidGraphicsP[]
		],
		Example[{Options,SecondYRange,"Unspecified plot ranges for secondary data are padded as Automatic:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->{temp1,press1},SecondYRange->{{-50Celsius,200Celsius}}],
			ValidGraphicsP[]
		],

		Example[{Options,SecondYStyle,"Change the style for the secondary data to dashed:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{temp1,temp2},SecondYStyle->Dashed],
			ValidGraphicsP[]
		],

		Example[{Options,Peaks,"Specify peaks for one data:"},
			EmeraldListLinePlot[chrom1,Peaks->pks1],
			ValidGraphicsP[]
		],
		Example[{Options,Peaks,"Specify peaks for each data:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->{pks1,pks2}],
			ValidGraphicsP[]
		],
		Example[{Options,Peaks,"SecondY values get highlighted on peak mouseover:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},Peaks->{pks1,pks2,pks3},SecondYCoordinates->{{temp1,press1},{temp2,press2},{temp3,press3}}],
			ValidGraphicsP[]
		],
		Test["Pad the peaks with Null to match the primary data input size:",
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->pks1],
			ValidGraphicsP[]
		],
		Example[{Options,Peaks,"By default any labels included in the peaks specification will be plotted:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->Append[pks1,PeakLabel->{"Spike","Rover","Spot"}]],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabels,"Directly specify the peak labels:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->pks1,PeakLabels->{"1","2","3"}],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabels,"Provide labels for each set of peaks:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->{pks1,pks2},PeakLabels->{{"1A","2A","3A"},{"1B","2B","3B"}}],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabels,"Don't include any peak labels:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->Append[pks1,PeakLabel->{"Spike","Rover","Spot"}],PeakLabels->Null],
			ValidGraphicsP[]
		],
		Example[{Options,PeakLabelStyle,"Set the appearance of the peak label text:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->{pks1,pks2},PeakLabels->{{"1A","2A","3A"},{"1B","2B","3B"}},PeakLabelStyle->{14,Darker[Green],FontFamily->"Arial"}],
			ValidGraphicsP[]
		],

		Example[{Options,Ladder,"Specify ladder sizes for one data set:"},
			EmeraldListLinePlot[chrom1,Ladder->{{1,11},{5,30},{25,50}}],
			ValidGraphicsP[]
		],
		Example[{Options,Ladder,"Specify ladder sizes for two data sets:"},
			EmeraldListLinePlot[{chrom1,chrom2},Ladder->{{{1,11},{5,30},{25,50}},{{1,9},{5,27},{25,46}}}],
			ValidGraphicsP[]
		],

		Example[{Options,Fractions,"Specify fractions for one data:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1],
			ValidGraphicsP[]
		],
		Example[{Options,Fractions,"Specify fractions for each data:"},
			EmeraldListLinePlot[{chrom1,chrom2},Fractions->{fracs1,fracs2}],
			ValidGraphicsP[]
		],

		Example[{Options,FractionHighlights,"Specify fractions and fraction highlights for one data:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1,FractionHighlights->fracHighlights1],
			ValidGraphicsP[]
		],
		Example[{Options,FractionHighlights,"Specify fractions and highlights for each data:"},
			EmeraldListLinePlot[{chrom1,chrom2},Fractions->{fracs1,fracs2},FractionHighlights->{fracHighlights1,fracHighlights2}],
			ValidGraphicsP[]
		],
		Test["Single highlight set, list of fraction sets:",
			EmeraldListLinePlot[{chrom1,chrom2},Fractions->{fracs1,fracs2},FractionHighlights->fracHighlights1],
			ValidGraphicsP[]
		],

		Example[{Options,FractionColor,"Specify fraction color:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1,FractionColor->Blue],
			ValidGraphicsP[]
		],

		Example[{Options,FractionHighlightColor,"Specify fractions and fraction highlights for one data:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1,FractionHighlights->fracHighlights1,FractionHighlightColor->Yellow],
			ValidGraphicsP[]
		],

		Example[{Options,Prolog,"Any graphics passed to the Prolog option are drawn before the plot and any epilogs created by EmeraldListLinePlot:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1,Peaks->pks1,Prolog->{Style[Disk[{30, 0.4`},{25, 0.35`}],Yellow]}],
			ValidGraphicsP[]
		],
		Example[{Options,Epilog,"Epilogs explicitly specified are joined onto any epilogs created by EmeraldListLinePlot:"},
			EmeraldListLinePlot[chrom1,Fractions->fracs1,Peaks->pks1,Epilog->{Disk[{30,0.4},{3,0.05}]}],
			ValidGraphicsP[]
		],

		Example[{Options,ImageSize,"Adjust the size of the plot:"},
			Table[EmeraldListLinePlot[{chrom1,chrom2,chrom3},ImageSize->s],{s,{200,400}}],
			{ValidGraphicsP[]..}
		],
		Example[{Options,ImageSize,"Specify the plot size as a {width,height} pair:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},ImageSize->{400,500}],
			ValidGraphicsP[]
		],
		Example[{Options,ImageSize,"Set the plot size using keywords Small, Medium, or Large:"},
			Table[EmeraldListLinePlot[{chrom1,chrom2,chrom3},ImageSize->s],{s,{Small,Medium,Large}}],
			{ValidGraphicsP[]..}
		],

		Example[{Options,InsetImages,"Inset an image over the data trace:"},
			EmeraldListLinePlot[Download[Object[Data, PAGE, "id:pZx9jonGoxqE"],OptimalLaneIntensity],InsetImages->Download[Object[Data, PAGE, "id:pZx9jonGoxqE"],OptimalLaneImage]],
			ValidGraphicsP[]
		],
		Example[{Options,InsetImages,"Inset multiple images:"},
			EmeraldListLinePlot[Download[{Object[Data, PAGE, "id:pZx9jonGoxqE"],Object[Data, PAGE, "id:54n6evKxDXRB"]},OptimalLaneIntensity],InsetImages->Download[{Object[Data, PAGE, "id:pZx9jonGoxqE"],Object[Data, PAGE, "id:54n6evKxDXRB"]},OptimalLaneImage]],
			ValidGraphicsP[]
		],

		Example[{Options,ErrorBars,"Show error bars over averaged replicated data:"},
			EmeraldListLinePlot[Replicates@@Table[Table[{x,x^3+RandomVariate[NormalDistribution[0,.1]]},{x,-1,1,0.1}],{16}],ErrorBars->True],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorBars,"Do not show error bars over averaged replicated data:"},
			EmeraldListLinePlot[Replicates@@Table[Table[{x,x^3+RandomVariate[NormalDistribution[0,.1]]},{x,-1,1,0.1}],{16}],ErrorBars->False],
			ValidGraphicsP[]
		],

		Example[{Options,ErrorType,"Show error bars corresponding to StandardDeviation:"},
			EmeraldListLinePlot[Replicates@@Table[Table[{x,a*x},{x,0,5}],{a,0.8,1.2,0.05}],ErrorType->StandardDeviation],
			ValidGraphicsP[]
		],
		Example[{Options,ErrorType,"Show error bars corresponding to StandardError:"},
			EmeraldListLinePlot[Replicates@@Table[Table[{x,a*x},{x,0,5}],{a,0.8,1.2,0.05}],ErrorType->StandardError],
			ValidGraphicsP[]
		],
		Test["ErrorType option changes something:",
			SameQ[EmeraldListLinePlot[Replicates@@Table[Table[{x,a*x},{x,0,5}],{a,0.8,1.2,0.05}],ErrorType->StandardDeviation],EmeraldListLinePlot[Replicates@@Table[Table[{x,a*x},{x,0,5}],{a,0.8,1.2,0.05}],ErrorType->StandardError]],
			False
		],


		Example[{Options,Scale,"Plot data using a log scale on the y-axis:"},
			EmeraldListLinePlot[Table[{x^5,5^x},{x,1,5,0.1}],Scale->Log],
			ValidGraphicsP[]?logFrameTicksQ
		],
		Example[{Options,Scale,"Plot data using a log scale on the x-axis:"},
			EmeraldListLinePlot[Table[{x^5,5^x},{x,1,5,0.1}],Scale->LogLinear],
			ValidGraphicsP[]?loglinearFrameTicksQ
		],
		Example[{Options,Scale,"Plot data using log scales on both x and y axes:"},
			EmeraldListLinePlot[Table[{x^5,5^x},{x,1,5,0.1}],Scale->LogLog],
			ValidGraphicsP[]?loglogFrameTicksQ
		],
		Example[{Options,Scale,"Negative values are excluded from a log plot:"},
			EmeraldListLinePlot[{{0,100},{1,1},{2,10},{3,-5},{4,100},{5,1000},{6,10}},Scale->Log],
			ValidGraphicsP[]?(MatchQ[Cases[#[[1]],_Line,Infinity],{Line[{{0.`,2.`},{1.`,0.`},{2.`,1.`}}],Line[{{4.`,2.`},{5.`,3.`},{6.`,1.`}}]}]&)
		],

		Example[{Options,TargetUnits,"Specify the desired output {x,y}-units for the plot:"},
			{
				EmeraldListLinePlot[{temp1,temp2,temp3},ImageSize->300,PlotLabel->"TargetUnits->Automatic"],
				EmeraldListLinePlot[{temp1,temp2,temp3},ImageSize->300,TargetUnits->{Minute,Kelvin},PlotLabel->"TargetUnits changed"]
			},
			{ValidGraphicsP[]..}
		],
		Example[{Options,TargetUnits,"EmeraldListLinePlot will fail and trigger an error message if the input data cannot be converted into the requested TargetUnits:"},
			EmeraldListLinePlot[{temp1,temp2,temp3},ImageSize->300,TargetUnits->{Meter,Joule}],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],

		Example[{Options,FrameLabel,"Specify frame labels for unitless data:"},
			EmeraldListLinePlot[Unitless[chrom1],FrameLabel->{"Elapsed Time","Distance Traveled"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Override a default label:"},
			EmeraldListLinePlot[chrom1,FrameLabel->{"Elapsed Time",Automatic}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"When specifying a flat list, frame order is {bottom, left, top, right}:"},
			EmeraldListLinePlot[Unitless[chrom1],SecondYCoordinates->Unitless[temp1],FrameLabel->{"Elapsed Time","Distance Traveled",None,"Fluorescence Measured"}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"When specifying a pair of lists, frame order is {{left, right},{bottom, top}}:"},
			EmeraldListLinePlot[Unitless[chrom1],SecondYCoordinates->Unitless[temp1],FrameLabel->{{"Elapsed Time","Fluorescence Measured"},{"Distance Traveled",None}}],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Must turn on top frame to see top label:"},
			EmeraldListLinePlot[Unitless[chrom1],SecondYCoordinates->Unitless[temp1],FrameLabel->{{"Elapsed Time","Fluorescence Measured"},{"Distance Traveled","Top Label"}},Frame->True],
			ValidGraphicsP[]
		],
		Example[{Options,FrameLabel,"Labels are only displayed for frames that are turned on:"},
			EmeraldListLinePlot[Unitless[chrom1],SecondYCoordinates->Unitless[temp1],FrameLabel->{{"Elapsed Time","Fluorescence Measured"},{"Distance Traveled","Top Label"}},Frame->{{True,False},{False,True}}],
			ValidGraphicsP[]
		],

		Example[{Options,FrameTicks,"Turn off all frame ticks:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->temp1,FrameTicks->None],
			ValidGraphicsP[]
		],
		Example[{Options,FrameTicks,"Turn off right frame ticks:"},
			EmeraldListLinePlot[chrom1,SecondYCoordinates->temp1,FrameTicks->{{Automatic,None},{Automatic,None}}],
			ValidGraphicsP[]
		],
		Test["FrameTicks option resolves correctly:",
			Lookup[EmeraldListLinePlot[chrom1,SecondYCoordinates->temp1,FrameTicks->{{Automatic,None},{Automatic,None}}][[2]],FrameTicks],
			{{True,None},{True,None}}
		],



		Example[{Options,FrameUnits,"Specify a label and automatically append the data's units:"},
			EmeraldListLinePlot[chrom1,FrameUnits->Automatic,FrameLabel->{"Elapsed Time","Predicted Absorbance"}],
			ValidGraphicsP[]
		],

		Example[{Options,Legend,"Specify a legend:"},
			EmeraldListLinePlot[
				{chrom1,chrom2,chrom3},
				Legend->{"chrom1","chrom2","chrom3"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Legend can be nested to match the shape of the primary input:"},
			EmeraldListLinePlot[
				{{chrom1,chrom1b},{chrom2,chrom2b},{chrom3,chrom3b}},
				Legend->{{"Chrom1A","Chrom1B"},{"Chrom2A","Chrom2B"},{"Chrom3A","Chrom3B"}}
			],
			ValidGraphicsP[]
		],
		Example[{Options,Legend,"Legend elements can be styled:"},
			EmeraldListLinePlot[
				{chrom1,chrom2},
				Legend->{Style["First Data",Italic,Purple,16],"Second Data"}
			],
			ValidGraphicsP[]
		],
		Example[{Options,LegendPlacement,"Specify legend position:"},
			{
				EmeraldListLinePlot[{chrom1,chrom2,chrom3},Legend->{"chrom1","chrom2","chrom3"},LegendPlacement->Top],
				EmeraldListLinePlot[{chrom1,chrom2,chrom3},Legend->{"chrom1","chrom2","chrom3"},LegendPlacement->Right]
			},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Options,Boxes,"Use swatch boxes instead of lines in the legend:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},Legend->{"chrom1","chrom2","chrom3"},Boxes->True],
			ValidGraphicsP[]
		],
		Example[{Options,LegendLabel,"Put a label on the plot legend:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},Legend->{"chrom1","chrom2","chrom3"},LegendLabel->"My Label"],
			ValidGraphicsP[]
		],

		Example[{Options,VerticalLine,"Specify vertical line at a position:"},
			EmeraldListLinePlot[chrom1,VerticalLine->35*Second],
			ValidGraphicsP[]
		],
		Example[{Options,VerticalLine,"Specify x-position and relative y-height:"},
			EmeraldListLinePlot[chrom1,VerticalLine->{{35*Second,80Percent}}],
			ValidGraphicsP[]
		],
		Example[{Options,VerticalLine,"Specify x-position, relative y-height, and label:"},
			EmeraldListLinePlot[chrom1,VerticalLine->{{35*Second,80Percent,"Line Label"}}],
			ValidGraphicsP[]
		],
		Example[{Options,VerticalLine,"Full specification for a vertical line epilog: x-position, relative y-height, label, style__:"},
			EmeraldListLinePlot[chrom1,VerticalLine->{35*Second,25Percent,"Line Label",Blue,Thick}],
			ValidGraphicsP[]
		],
		Example[{Options,VerticalLine,"Specify multiple vertical lines in a list.  Can mix different levels of specification detail:"},
			EmeraldListLinePlot[chrom1,
				VerticalLine->{0.1Minute,{30Second,25Percent,"Label",Darker[Green],Thin},45Second,{20Second,0.8}
			}],
			ValidGraphicsP[]
		],

		Example[{Options,Normalize,"Normalize all primary traces, and any primary epilogs, to a specified value:"},
			EmeraldListLinePlot[{chrom1,chrom2},Normalize->35*Milli*AbsorbanceUnit,Peaks->{pks1,pks2}],
			ValidGraphicsP[]
		],
		Example[{Options,Normalize,"Units on Normalize option must be compatible with primary data units:"},
			EmeraldListLinePlot[{chrom1,chrom2},Normalize->35*Meter],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],


		Example[{Options,Reflected,"Reflect data about the x-axis, but retain the original tick values:"},
			EmeraldListLinePlot[chrom1,Reflected->True],
			ValidGraphicsP[]
		],
		Example[{Options,Reflected,"Secondary data and epilogs also get reflected:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{temp1,temp2},Peaks->{pks1,pks2},Reflected->True],
			ValidGraphicsP[]
		],


		Example[{Options,Tooltip,"Specify tooltips for primary data:"},
			EmeraldListLinePlot[Table[Table[{x,x^p},{x,-1,1,0.1}],{p,{1,2,3}}],Tooltip->{{"A","B","C"}}],
			{Tooltip[_,"A"],Tooltip[_,"B"],Tooltip[_,"C"],___},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],
		Example[{Options,Tooltip,"Specify tooltips for grouped primary data:"},
			EmeraldListLinePlot[Table[Table[Table[{x,a*x^p},{x,-1,1,0.1}],{a,{0.9,1.1}}],{p,{1,2,3}}],Tooltip->{{"A1","A2"},{"B1","B2"},{"C1","C2"}}],
			{Tooltip[_,"A1"],Tooltip[_,"A2"],Tooltip[_,"B1"],Tooltip[_,"B2"],Tooltip[_,"C1"],Tooltip[_,"C2"],___},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],
		Example[{Options,Tooltip,"Incomplete tooltip specification is padded with Nulls:"},
			EmeraldListLinePlot[Table[Table[{x,x^p},{x,-1,1,0.1}],{p,{1,2,3}}],Tooltip->{{"A","B"}}],
			{(Tooltip[_,"A"]|Tooltip[_,"B"])..},
			EquivalenceFunction->(MatchQ[Cases[#1,_Tooltip,Infinity],#2]&)
		],


		Example[{Options,Joined,"If Joined->False, data points are not connected by lines:"},
			EmeraldListLinePlot[{{1,1},{2,4},{3,9},{4,16},{5,25}},Joined->False],
			ValidGraphicsP[]
		],
		Example[{Options,Joined,"If Joined->Automatic, data points are connected only if their x-values are monotonically increasing:"},
			EmeraldListLinePlot[{{1,1},{2,4},{3,9},{4,16},{5,25}},Joined->Automatic],
			{Line[{{1.`,1.`},{2.`,4.`},{3.`,9.`},{4.`,16.`},{5.`,25.`}}]},
			EquivalenceFunction->(RoundMatchQ[8][Cases[#1[[1]],_Line,Infinity],#2]&)
		],
		Example[{Options,Joined,"If Joined->Automatic and x-values are out of order, points are left unconnected:"},
			EmeraldListLinePlot[{{2,4},{1,1},{4,16},{5,25},{3,9}},Joined->Automatic],
			{Point[{{2.`,4.`},{1.`,1.`},{4.`,16.`},{5.`,25.`},{3.`,9.`}}]},
			EquivalenceFunction->(RoundMatchQ[8][Cases[#1[[1]],_Point,Infinity],#2]&)
		],
		Example[{Options,Joined,"Specify a Joined value for each data set:"},
			EmeraldListLinePlot[Table[Table[{x,x^p},{x,-1,1,0.1}],{p,{1,2,3,4}}],Joined->{True,False,False,True}],
			{Line[{{-1.`,-1.`},{-0.9`,-0.9`},{-0.8`,-0.8`},{-0.7`,-0.7`},{-0.6`,-0.6`},{-0.5`,-0.5`},{-0.3999999999999999`,-0.3999999999999999`},{-0.29999999999999993`,-0.29999999999999993`},{-0.19999999999999996`,-0.19999999999999996`},{-0.09999999999999998`,-0.09999999999999998`},{0.`,0.`},{0.10000000000000009`,0.10000000000000009`},{0.20000000000000018`,0.20000000000000018`},{0.30000000000000004`,0.30000000000000004`},{0.40000000000000013`,0.40000000000000013`},{0.5`,0.5`},{0.6000000000000001`,0.6000000000000001`},{0.7000000000000002`,0.7000000000000002`},{0.8`,0.8`},{0.9000000000000001`,0.9000000000000001`},{1.`,1.`}}],Line[{{-1.`,1.`},{-0.9`,0.6561000000000001`},{-0.8`,0.4096000000000002`},{-0.7`,0.24009999999999992`},{-0.6`,0.1296`},{-0.5`,0.0625`},{-0.3999999999999999`,0.025599999999999973`},{-0.29999999999999993`,0.008099999999999993`},{-0.19999999999999996`,0.0015999999999999983`},{-0.09999999999999998`,0.0000999999999999999`},{0.`,0.`},{0.10000000000000009`,0.00010000000000000036`},{0.20000000000000018`,0.0016000000000000057`},{0.30000000000000004`,0.008100000000000005`},{0.40000000000000013`,0.025600000000000036`},{0.5`,0.0625`},{0.6000000000000001`,0.12960000000000008`},{0.7000000000000002`,0.24010000000000026`},{0.8`,0.4096000000000002`},{0.9000000000000001`,0.6561000000000005`},{1.`,1.`}}],Point[{{-1.`,1.`},{-0.9`,0.81`},{-0.8`,0.6400000000000001`},{-0.7`,0.48999999999999994`},{-0.6`,0.36`},{-0.5`,0.25`},{-0.3999999999999999`,0.15999999999999992`},{-0.29999999999999993`,0.08999999999999996`},{-0.19999999999999996`,0.03999999999999998`},{-0.09999999999999998`,0.009999999999999995`},{0.`,0.`},{0.10000000000000009`,0.010000000000000018`},{0.20000000000000018`,0.04000000000000007`},{0.30000000000000004`,0.09000000000000002`},{0.40000000000000013`,0.16000000000000011`},{0.5`,0.25`},{0.6000000000000001`,0.3600000000000001`},{0.7000000000000002`,0.49000000000000027`},{0.8`,0.6400000000000001`},{0.9000000000000001`,0.8100000000000003`},{1.`,1.`}}],Point[{{-1.`,-1.`},{-0.9`,-0.7290000000000001`},{-0.8`,-0.5120000000000001`},{-0.7`,-0.3429999999999999`},{-0.6`,-0.216`},{-0.5`,-0.125`},{-0.3999999999999999`,-0.06399999999999996`},{-0.29999999999999993`,-0.02699999999999998`},{-0.19999999999999996`,-0.007999999999999995`},{-0.09999999999999998`,-0.0009999999999999994`},{0.`,0.`},{0.10000000000000009`,0.0010000000000000026`},{0.20000000000000018`,0.008000000000000021`},{0.30000000000000004`,0.02700000000000001`},{0.40000000000000013`,0.06400000000000007`},{0.5`,0.125`},{0.6000000000000001`,0.21600000000000008`},{0.7000000000000002`,0.34300000000000025`},{0.8`,0.5120000000000001`},{0.9000000000000001`,0.7290000000000003`},{1.`,1.`}}]},
			EquivalenceFunction->(RoundMatchQ[8][Cases[#1[[1]],_Line|_Point,Infinity],#2]&)
		],
		Example[{Options,Joined,"Specify a Joined value for each data set when grouped primary data is present:"},
			EmeraldListLinePlot[Table[Table[Table[{x,a*x^p},{x,-1,1,0.1}],{a,{0.9,1.1}}],{p,{1,2,3}}],Joined->{True,True,False}],
			{Line[{{-1.`,-0.9`},{-0.9`,-0.81`},{-0.8`,-0.7200000000000001`},{-0.7`,-0.63`},{-0.6`,-0.54`},{-0.5`,-0.45`},{-0.3999999999999999`,-0.35999999999999993`},{-0.29999999999999993`,-0.26999999999999996`},{-0.19999999999999996`,-0.17999999999999997`},{-0.09999999999999998`,-0.08999999999999998`},{0.`,0.`},{0.10000000000000009`,0.09000000000000008`},{0.20000000000000018`,0.18000000000000016`},{0.30000000000000004`,0.2700000000000001`},{0.40000000000000013`,0.36000000000000015`},{0.5`,0.45`},{0.6000000000000001`,0.5400000000000001`},{0.7000000000000002`,0.6300000000000002`},{0.8`,0.7200000000000001`},{0.9000000000000001`,0.8100000000000002`},{1.`,0.9`}}],Line[{{-1.`,-1.1`},{-0.9`,-0.9900000000000001`},{-0.8`,-0.8800000000000001`},{-0.7`,-0.77`},{-0.6`,-0.66`},{-0.5`,-0.55`},{-0.3999999999999999`,-0.43999999999999995`},{-0.29999999999999993`,-0.32999999999999996`},{-0.19999999999999996`,-0.21999999999999997`},{-0.09999999999999998`,-0.10999999999999999`},{0.`,0.`},{0.10000000000000009`,0.11000000000000011`},{0.20000000000000018`,0.22000000000000022`},{0.30000000000000004`,0.33000000000000007`},{0.40000000000000013`,0.44000000000000017`},{0.5`,0.55`},{0.6000000000000001`,0.6600000000000001`},{0.7000000000000002`,0.7700000000000002`},{0.8`,0.8800000000000001`},{0.9000000000000001`,0.9900000000000002`},{1.`,1.1`}}],Line[{{-1.`,0.9`},{-0.9`,0.7290000000000001`},{-0.8`,0.5760000000000002`},{-0.7`,0.44099999999999995`},{-0.6`,0.324`},{-0.5`,0.225`},{-0.3999999999999999`,0.14399999999999993`},{-0.29999999999999993`,0.08099999999999996`},{-0.19999999999999996`,0.03599999999999998`},{-0.09999999999999998`,0.008999999999999996`},{0.`,0.`},{0.10000000000000009`,0.009000000000000017`},{0.20000000000000018`,0.03600000000000007`},{0.30000000000000004`,0.08100000000000003`},{0.40000000000000013`,0.1440000000000001`},{0.5`,0.225`},{0.6000000000000001`,0.3240000000000001`},{0.7000000000000002`,0.4410000000000002`},{0.8`,0.5760000000000002`},{0.9000000000000001`,0.7290000000000003`},{1.`,0.9`}}],Line[{{-1.`,1.1`},{-0.9`,0.8910000000000001`},{-0.8`,0.7040000000000002`},{-0.7`,0.5389999999999999`},{-0.6`,0.396`},{-0.5`,0.275`},{-0.3999999999999999`,0.17599999999999993`},{-0.29999999999999993`,0.09899999999999996`},{-0.19999999999999996`,0.043999999999999984`},{-0.09999999999999998`,0.010999999999999996`},{0.`,0.`},{0.10000000000000009`,0.01100000000000002`},{0.20000000000000018`,0.04400000000000008`},{0.30000000000000004`,0.09900000000000003`},{0.40000000000000013`,0.17600000000000013`},{0.5`,0.275`},{0.6000000000000001`,0.39600000000000013`},{0.7000000000000002`,0.5390000000000004`},{0.8`,0.7040000000000002`},{0.9000000000000001`,0.8910000000000003`},{1.`,1.1`}}],Point[{{-1.`,-0.9`},{-0.9`,-0.6561000000000001`},{-0.8`,-0.4608000000000001`},{-0.7`,-0.3086999999999999`},{-0.6`,-0.1944`},{-0.5`,-0.1125`},{-0.3999999999999999`,-0.057599999999999964`},{-0.29999999999999993`,-0.02429999999999998`},{-0.19999999999999996`,-0.0071999999999999955`},{-0.09999999999999998`,-0.0008999999999999994`},{0.`,0.`},{0.10000000000000009`,0.0009000000000000024`},{0.20000000000000018`,0.007200000000000019`},{0.30000000000000004`,0.02430000000000001`},{0.40000000000000013`,0.05760000000000007`},{0.5`,0.1125`},{0.6000000000000001`,0.19440000000000007`},{0.7000000000000002`,0.30870000000000025`},{0.8`,0.4608000000000001`},{0.9000000000000001`,0.6561000000000003`},{1.`,0.9`}}],Point[{{-1.`,-1.1`},{-0.9`,-0.8019000000000002`},{-0.8`,-0.5632000000000001`},{-0.7`,-0.3772999999999999`},{-0.6`,-0.2376`},{-0.5`,-0.1375`},{-0.3999999999999999`,-0.07039999999999996`},{-0.29999999999999993`,-0.02969999999999998`},{-0.19999999999999996`,-0.008799999999999995`},{-0.09999999999999998`,-0.0010999999999999994`},{0.`,0.`},{0.10000000000000009`,0.0011000000000000029`},{0.20000000000000018`,0.008800000000000023`},{0.30000000000000004`,0.029700000000000015`},{0.40000000000000013`,0.07040000000000009`},{0.5`,0.1375`},{0.6000000000000001`,0.23760000000000012`},{0.7000000000000002`,0.3773000000000003`},{0.8`,0.5632000000000001`},{0.9000000000000001`,0.8019000000000004`},{1.`,1.1`}}]},
			EquivalenceFunction->(RoundMatchQ[8][Cases[#1[[1]],_Line|_Point,Infinity],#2]&)
		],
		Example[{Options,Joined,"Incomplete Joined speciication is padded right with the last value:"},
			EmeraldListLinePlot[Table[Table[{x,x^p},{x,-1,1,0.1}],{p,{1,2,3,4}}],Joined->{True,False}],
			{Line[{{-1.`,-1.`},{-0.9`,-0.9`},{-0.8`,-0.8`},{-0.7`,-0.7`},{-0.6`,-0.6`},{-0.5`,-0.5`},{-0.3999999999999999`,-0.3999999999999999`},{-0.29999999999999993`,-0.29999999999999993`},{-0.19999999999999996`,-0.19999999999999996`},{-0.09999999999999998`,-0.09999999999999998`},{0.`,0.`},{0.10000000000000009`,0.10000000000000009`},{0.20000000000000018`,0.20000000000000018`},{0.30000000000000004`,0.30000000000000004`},{0.40000000000000013`,0.40000000000000013`},{0.5`,0.5`},{0.6000000000000001`,0.6000000000000001`},{0.7000000000000002`,0.7000000000000002`},{0.8`,0.8`},{0.9000000000000001`,0.9000000000000001`},{1.`,1.`}}],Point[{{-1.`,1.`},{-0.9`,0.81`},{-0.8`,0.6400000000000001`},{-0.7`,0.48999999999999994`},{-0.6`,0.36`},{-0.5`,0.25`},{-0.3999999999999999`,0.15999999999999992`},{-0.29999999999999993`,0.08999999999999996`},{-0.19999999999999996`,0.03999999999999998`},{-0.09999999999999998`,0.009999999999999995`},{0.`,0.`},{0.10000000000000009`,0.010000000000000018`},{0.20000000000000018`,0.04000000000000007`},{0.30000000000000004`,0.09000000000000002`},{0.40000000000000013`,0.16000000000000011`},{0.5`,0.25`},{0.6000000000000001`,0.3600000000000001`},{0.7000000000000002`,0.49000000000000027`},{0.8`,0.6400000000000001`},{0.9000000000000001`,0.8100000000000003`},{1.`,1.`}}],Point[{{-1.`,-1.`},{-0.9`,-0.7290000000000001`},{-0.8`,-0.5120000000000001`},{-0.7`,-0.3429999999999999`},{-0.6`,-0.216`},{-0.5`,-0.125`},{-0.3999999999999999`,-0.06399999999999996`},{-0.29999999999999993`,-0.02699999999999998`},{-0.19999999999999996`,-0.007999999999999995`},{-0.09999999999999998`,-0.0009999999999999994`},{0.`,0.`},{0.10000000000000009`,0.0010000000000000026`},{0.20000000000000018`,0.008000000000000021`},{0.30000000000000004`,0.02700000000000001`},{0.40000000000000013`,0.06400000000000007`},{0.5`,0.125`},{0.6000000000000001`,0.21600000000000008`},{0.7000000000000002`,0.34300000000000025`},{0.8`,0.5120000000000001`},{0.9000000000000001`,0.7290000000000003`},{1.`,1.`}}],Point[{{-1.`,1.`},{-0.9`,0.6561000000000001`},{-0.8`,0.4096000000000002`},{-0.7`,0.24009999999999992`},{-0.6`,0.1296`},{-0.5`,0.0625`},{-0.3999999999999999`,0.025599999999999973`},{-0.29999999999999993`,0.008099999999999993`},{-0.19999999999999996`,0.0015999999999999983`},{-0.09999999999999998`,0.0000999999999999999`},{0.`,0.`},{0.10000000000000009`,0.00010000000000000036`},{0.20000000000000018`,0.0016000000000000057`},{0.30000000000000004`,0.008100000000000005`},{0.40000000000000013`,0.025600000000000036`},{0.5`,0.0625`},{0.6000000000000001`,0.12960000000000008`},{0.7000000000000002`,0.24010000000000026`},{0.8`,0.4096000000000002`},{0.9000000000000001`,0.6561000000000005`},{1.`,1.`}}]},
			EquivalenceFunction->(RoundMatchQ[8][Cases[#1[[1]],_Line|_Point,Infinity],#2]&)
		],

		Example[{Options,ScaleY,"Remove the plot range padding in the y-direction:"},
			EmeraldListLinePlot[chrom1, Filling -> Bottom,ScaleY->1],
			ValidGraphicsP[]
		],
		Example[{Options,ScaleX,"Add plot range padding in the x-direction:"},
			EmeraldListLinePlot[chrom1, Filling -> Bottom,ScaleX->1.25],
			ValidGraphicsP[]
		],

		Example[{Options,PlotLayout,"Use PlotLayout->\"Stacked\" to cumulatively sum input datasets from left to right. For a full list of possible arguments to PlotLayout, please run ?PlotLayout in the notebook:"},
			{
				EmeraldListLinePlot[{stackedData1,stackedData2},ImageSize->250,Filling->Bottom,PlotLayout->Automatic],
				EmeraldListLinePlot[{stackedData1,stackedData2},ImageSize->250,Filling->{1->Bottom,2->{1}},PlotLayout->"Stacked"]
			},
			{ValidGraphicsP[]..}
		],


		(*
			MESSAGES
		*)
		Example[{Messages,"InvalidSecondYSpecification","Invalid dimensions in SecondYCoordinates option:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},SecondYCoordinates->{{temp1,press1},{press2},{temp3,press3}}],
			$Failed,
			Messages:>{EmeraldListLinePlot::InvalidSecondYSpecification}
		],
		Example[{Messages,"InvalidSecondYSpecification","Invalid dimensions in SecondYCoordinates option:"},
			EmeraldListLinePlot[{chrom1,chrom2,chrom3},SecondYCoordinates->{{temp1,press1},{temp3,press3}}],
			$Failed,
			Messages:>{EmeraldListLinePlot::InvalidSecondYSpecification}
		],
		Example[{Messages,"InvalidSecondYSpecification","Invalid dimensions in SecondYCoordinates option:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{{},{temp2,press2}}],
			$Failed,
			Messages:>{EmeraldListLinePlot::InvalidSecondYSpecification}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units amongst primary data set:"},
			EmeraldListLinePlot[{chrom1,Unitless[chrom2]}],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units amongst secondary data set:"},
			EmeraldListLinePlot[{chrom1,chrom2},SecondYCoordinates->{{temp1,press1},{Unitless[temp2],press2}}],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units in Peaks option:"},
			EmeraldListLinePlot[QuantityArray[Unitless[chrom1],{Meter,RFU}],Peaks->pks1],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],
		Example[{Messages,"IncompatibleUnits","Incompatible units in Fractions option:"},
			EmeraldListLinePlot[chrom1,Fractions->{{1,2,"A1"}}],
			$Failed,
			Messages:>{EmeraldListLinePlot::IncompatibleUnits}
		],
		Example[{Messages,"InvalidPrimaryDataSpecification","Inconsistent dimensions in primary data specification:"},
			EmeraldListLinePlot[{chrom1,{chrom2,chrom2b},chrom3}],
			$Failed,
			Messages:>{EmeraldListLinePlot::InvalidPrimaryDataSpecification}
		],
		Example[{Messages,"PeakLabels","Label list size must match peak size:"},
			EmeraldListLinePlot[{chrom1,chrom2},Peaks->{pks1,pks2},PeakLabels->{{"1A","2A","3A"},{"1B","3B"}}],
			ValidGraphicsP[],
			Messages:>{EmeraldListLinePlot::PeakLabels}
		],
		Example[{Messages,"NullPrimaryData","Internal helper function packetToELLP[] throws an error and returns Null if the input object has empty data fields:"},
			badPacket=<|Object->Object[Data,NMR,"nonexistent data"],Type->Object[Data,NMR]|>;
			packetToELLP[badPacket,PlotNMR,{}],
			Null,
			Messages:>{Error::NullPrimaryData}
		],
		Example[{Messages,"MixedDataTypes","Internal helper function packetToELLP[] requires a list of objects of the same type:"},
			packetToELLP[{NMRPacket,chromPacket},PlotNMR,{}],
			Null,
			Messages:>{Warning::MixedDataTypes},
			SetUp:>(
				NMRPacket=<|Object->Object[Data,NMR,"nonexistent data"],Type->Object[Data,NMR]|>;
				chromPacket=<|Object->Object[Data,Chromatography,"nonexistent chromatography data"],Type->Object[Data, Chromatography]|>;
			)
		],
		Example[{Messages,"NonMappableOption","When internal helper function packetToELLP[] receives listed option values with Map->True, the length of the listed options must match the length of the inputs:"},
			packetToELLP[{nmrObj1,nmrObj2,nmrObj3},PlotNMR,{Reflected->{True,False},Map->True}],
			{ValidGraphicsP[]..},
			Messages:>{Warning::NonMappableOption},
			SetUp:>(
				{nmrObj1,nmrObj2,nmrObj3}=Download[{Object[Data,NMR,"id:pZx9jonGr7RM"],Object[Data,NMR,"id:aXRlGnZm8OK9"],Object[Data,NMR,"id:Vrbp1jG8Zd9o"]}]
			)
		],

		Example[{Issues,"Reflected","Some display elements, such as this Polygon epilog, are not affected by the Reflected option:"},
			{EmeraldListLinePlot[Unitless[chrom1],Epilog->{Polygon[{{-5,0.1},{-5,0.5},{5,0.25}}]}],EmeraldListLinePlot[Unitless[chrom1],Epilog->{Polygon[{{-5,0.1},{-5,0.5},{5,0.25}}]},Reflected->True]},
			{ValidGraphicsP[],ValidGraphicsP[]}
		],
		Example[{Issues,"Reflected","Specified x-range normally when using Reflected option:"},
			EmeraldListLinePlot[chrom1,Reflected->True,PlotRange->{{10,35},Automatic}],
			ValidGraphicsP[]
		],
		Test["X-range properly handled when Reflected->True:",
			Lookup[EmeraldListLinePlot[chrom1,Reflected->True,PlotRange->{{10,35},Automatic}][[2]],PlotRange],
			(* First pattern is for 12.0, second for 13.2. *)
			{{-35,-10},{NumericP,NumericP}} | {{-35.,-10.},{NumericP,NumericP}}
		],

		(*
			TESTS
		*)
		Test["Flat second-y data scales appropriately:",
			Module[{chrom1,tempFlat},
				chrom1=QuantityArray[Table[{x,0.25Exp[-(x-10)^2]+0.5Exp[-(x-20)^2]+0.8Exp[-(x-45)^2]},{x,Range[0,55,0.2]}],{Second,AbsorbanceUnit}];
				tempFlat = QuantityArray[Table[{x,35.0},{x,Range[0,55,0.2]}],{Second,Celsius}];
				EmeraldListLinePlot[chrom1,SecondYCoordinates->tempFlat]
			],
			ValidGraphicsP[]
		],
		Test["Make sure error bar epilogs are accounted for in PlotRange:",
			Module[{ymin1,ymax1,ymin2,ymax2},
				{ymin1,ymax1}=Last[Lookup[EmeraldListLinePlot[Replicates@@Table[Table[{x,x^3+p},{x,-1,1,0.1`}],{p,1,4}],ErrorBars->True][[2]],PlotRange]];
				{ymin2,ymax2}=Last[Lookup[EmeraldListLinePlot[Replicates@@Table[Table[{x,x^3+p},{x,-1,1,0.1`}],{p,1,4}],ErrorBars->False][[2]],PlotRange]];
				And[ymin2>ymin1,ymax2<ymax1]
			],
			True
		],

		Test["Given coordinates with units on x only:",
			EmeraldListLinePlot[Transpose[{{1,2,3,6,7}*Meter,{1,2,3,4,5}}]],
			ValidGraphicsP[]
		],
		Test["Given QA with units on x only:",
			EmeraldListLinePlot[QuantityArray@Transpose[{{1,2,3,6,7}*Meter,{1,2,3,4,5}}]],
			ValidGraphicsP[]
		],
		Test["Correctly resolve PlotStyle in singleton case:",
			EmeraldListLinePlot[Table[{x,x^2},{x,1,10}],PlotStyle->Blue,Legend->{"Result"}],
			ValidGraphicsP[]
		],
		Test["Compound untis work with error bars:",
			EmeraldListLinePlot[
				Transpose[{{1, 2, 3},EmpiricalDistribution /@ Table[Table[RandomReal[10], 3], 3]}*Minute^2],
				Joined -> False
			],
			ValidGraphicsP[]
		],
		Test["scaleUnitlessPeaksLogLinear helper converts the x coordinate of data:",
			plotPacket = Plot`Private`scaleUnitlessPeaksLogLinear[loglinearPks, LogLinear, Null];
			Lookup[plotPacket, {Position, WidthRangeStart}],
			{{2.726599600746833`,2.8587704250180566`},{2.693183680344637`,2.832766924695473`}},
			EquivalenceFunction -> RoundMatchQ[5,Force->True]
		],
		Test["logSecondData helper converts the data based on the scale option:",
			logData = Plot`Private`logSecondData[EmeraldListLinePlot,loglinearData, LogLinear];
			logData[[1,1,-1]],
			{5.`,5.`},
			EquivalenceFunction -> RoundMatchQ[5,Force->True]
		]

	},

	Variables:>{xvals,temp1,temp2,temp3,press1,press2,press3,chrom1,chrom2,chrom3,
		pks1,pks2,pks3,fracs1,fracs2,chrom1b,chrom2b,chrom3b,fracHighlights1,fracHighlights2,
		loglinearData, loglinearPks},
	SetUp:>(
		xvals = Range[0,55,0.2];
		chrom1=QuantityArray[Table[{x,0.25Exp[-(x-11)^2]+0.5Exp[-(x-30)^2]+0.8Exp[-(x-50)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		chrom1b=QuantityArray[Table[{x,0.2Exp[-3(x-11)^2]+0.3Exp[-3(x-30)^2]+0.6Exp[-3(x-50)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		chrom2=QuantityArray[Table[{x,0.2Exp[-(x-9)^2]+0.4Exp[-(x-27)^2]+0.75Exp[-(x-46)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		chrom2b=QuantityArray[Table[{x,0.18Exp[-3(x-9)^2]+0.35Exp[-3(x-27)^2]+0.7Exp[-3(x-46)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		chrom3=QuantityArray[Table[{x,0.18Exp[-(x-7)^2]+0.375Exp[-(x-24)^2]+0.7Exp[-(x-42)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		chrom3b=QuantityArray[Table[{x,0.15Exp[-3(x-7)^2]+0.3Exp[-3(x-24)^2]+0.6Exp[-3(x-42)^2]},{x,xvals}],{Second,AbsorbanceUnit}];
		temp1=QuantityArray[Table[{x,1*x+35},{x,xvals}],{Second,Celsius}];
		temp2=QuantityArray[Table[{x,2*x+32},{x,xvals}],{Second,Celsius}];
		temp3=QuantityArray[Table[{x,3*x+30},{x,xvals}],{Second,Celsius}];
		press1=QuantityArray[Table[{x,Sin[.07*x]},{x,xvals}],{Second,Kilopascal}];
		press2=QuantityArray[Table[{x,.8Sin[.06*x]},{x,xvals}],{Second,Kilopascal}];
		press3=QuantityArray[Table[{x,.6Sin[.05*x]},{x,xvals}],{Second,Kilopascal}];
		stackedData1=Table[{i, 2.0*i + 0.3 + RandomReal[0.5]}, {i, 0, 10, 0.1}];
		stackedData2=Table[{i, 0.2*i + 0.3 + RandomReal[0.5]}, {i, 0, 10, 0.1}];
		pks1=<|Type->Object[Analysis,Peaks],Position->{Quantity[11.`,"Seconds"],Quantity[30.`,"Seconds"],Quantity[50.`,"Seconds"]},Height->{Quantity[0.25`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.5`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.8`,IndependentUnit["AbsorbanceUnit"]]},HalfHeightWidth->{Quantity[1.5999999999999996`,"Seconds"],Quantity[1.5999999999999979`,"Seconds"],Quantity[1.6000000000000014`,"Seconds"]},Area->{Quantity[0.4431134627263791`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[0.8862269254527579`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[1.4179630807229735`,"Seconds" IndependentUnit["AbsorbanceUnit"]]},PeakRangeStart->{Quantity[0.`,"Seconds"],Quantity[20.400000000000002`,"Seconds"],Quantity[40.`,"Seconds"]},PeakRangeEnd->{Quantity[20.400000000000002`,"Seconds"],Quantity[40.`,"Seconds"],Quantity[55.`,"Seconds"]},WidthRangeStart->{Quantity[10.200000000000001`,"Seconds"],Quantity[29.200000000000003`,"Seconds"],Quantity[49.2`,"Seconds"]},WidthRangeEnd->{Quantity[11.8`,"Seconds"],Quantity[30.8`,"Seconds"],Quantity[50.800000000000004`,"Seconds"]},BaselineIntercept->{Quantity[7.051925221150338`*^-54,IndependentUnit["AbsorbanceUnit"]],Quantity[7.051925221150338`*^-54,IndependentUnit["AbsorbanceUnit"]],Quantity[7.051925221150338`*^-54,IndependentUnit["AbsorbanceUnit"]]},BaselineSlope->{Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")]}, TangentWidthLines -> {}, TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {}, TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {}, RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {}, HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {},BaselineFunction ->
				QuantityFunction[Function[x, 0.`*x + 7.051925221150338`*^-54],
					Second, AbsorbanceUnit],PeakLabel->{"A","B","C"}|>;
		pks2=<|Type->Object[Analysis,Peaks],Position->{Quantity[9.`,"Seconds"],Quantity[27.`,"Seconds"],Quantity[46.`,"Seconds"]},Height->{Quantity[0.2`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.4`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.75`,IndependentUnit["AbsorbanceUnit"]]},HalfHeightWidth->{Quantity[1.5999999999999996`,"Seconds"],Quantity[1.5999999999999979`,"Seconds"],Quantity[1.6000000000000014`,"Seconds"]},Area->{Quantity[0.35449077018110314`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[0.7089815403622064`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[1.3293403881791368`,"Seconds" IndependentUnit["AbsorbanceUnit"]]},PeakRangeStart->{Quantity[0.`,"Seconds"],Quantity[18.`,"Seconds"],Quantity[36.4`,"Seconds"]},PeakRangeEnd->{Quantity[18.`,"Seconds"],Quantity[36.4`,"Seconds"],Quantity[55.`,"Seconds"]},WidthRangeStart->{Quantity[8.200000000000001`,"Seconds"],Quantity[26.200000000000003`,"Seconds"],Quantity[45.2`,"Seconds"]},WidthRangeEnd->{Quantity[9.8`,"Seconds"],Quantity[27.8`,"Seconds"],Quantity[46.800000000000004`,"Seconds"]},BaselineIntercept->{Quantity[1.7605341248062113`*^-39,IndependentUnit["AbsorbanceUnit"]],Quantity[1.7605341248062113`*^-39,IndependentUnit["AbsorbanceUnit"]],Quantity[1.7605341248062113`*^-39,IndependentUnit["AbsorbanceUnit"]]},BaselineSlope->{Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")]}, TangentWidthLines -> {}, TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {}, TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {}, RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {}, HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {},BaselineFunction ->
				QuantityFunction[Function[x, 0.`*x + 1.7605341248062113`*^-39],
					Second, AbsorbanceUnit],PeakLabel->{"X","Y","Z"}|>;
		pks3=<|Type->Object[Analysis,Peaks],Position->{Quantity[7.`,"Seconds"],Quantity[24.`,"Seconds"],Quantity[42.`,"Seconds"]},Height->{Quantity[0.18`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.375`,IndependentUnit["AbsorbanceUnit"]],Quantity[0.7`,IndependentUnit["AbsorbanceUnit"]]},HalfHeightWidth->{Quantity[1.6000000000000005`,"Seconds"],Quantity[1.5999999999999979`,"Seconds"],Quantity[1.6000000000000014`,"Seconds"]},Area->{Quantity[0.319041693162993`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[0.6646701940895685`,"Seconds" IndependentUnit["AbsorbanceUnit"]],Quantity[1.2407176956338613`,"Seconds" IndependentUnit["AbsorbanceUnit"]]},PeakRangeStart->{Quantity[0.`,"Seconds"],Quantity[15.4`,"Seconds"],Quantity[33.`,"Seconds"]},PeakRangeEnd->{Quantity[15.4`,"Seconds"],Quantity[33.`,"Seconds"],Quantity[55.`,"Seconds"]},WidthRangeStart->{Quantity[6.2`,"Seconds"],Quantity[23.200000000000003`,"Seconds"],Quantity[41.2`,"Seconds"]},WidthRangeEnd->{Quantity[7.800000000000001`,"Seconds"],Quantity[24.8`,"Seconds"],Quantity[42.800000000000004`,"Seconds"]},BaselineIntercept->{Quantity[2.8140421510203484`*^-74,IndependentUnit["AbsorbanceUnit"]],Quantity[2.8140421510203484`*^-74,IndependentUnit["AbsorbanceUnit"]],Quantity[2.8140421510203484`*^-74,IndependentUnit["AbsorbanceUnit"]]},BaselineSlope->{Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")],Quantity[0.`,IndependentUnit["AbsorbanceUnit"]/("Seconds")]}, TangentWidthLines -> {}, TangentWidthLineRanges -> {}, TangentNumberOfPlates -> {}, TangentResolution -> {}, TailingFactor -> {}, RelativeArea -> {}, RelativePosition -> {}, PeakLabel -> {}, TangentWidth -> {}, HalfHeightResolution -> {}, HalfHeightNumberOfPlates -> {},BaselineFunction ->
				QuantityFunction[Function[x, 0.`*x + 2.8140421510203484`*^-74],
					Second, AbsorbanceUnit], PeakLabel->{"Cat","Dog","Fish"}|>;
		fracs1={{27*Second,28*Second,"A1"},{28*Second,29*Second,"A2"},{29*Second,1/2*Minute,"A3"},{30*Second,31*Second,"A4"},{31*Second,32*Second,"A5"},{32*Second,33*Second,"A6"}};
		fracHighlights1={{29*Second,1/2*Minute,"A3"},{30*Second,31*Second,"A4"}};
		fracs2={{46*Second,5/6*Minute,"C4"},{50*Second,52*Second,"C5"},{52*Second,54*Second,"C6"}};
		fracHighlights2={{50*Second,52*Second,"C5"}};
		loglinearData = {{Table[{10^x, x}, {x, 0, 5, 0.1}]}};
		loglinearPks = <|
			Position -> {532.843412190357`, 722.387836935161`},
 			Height -> {262.80951487401256`, 155.08648049106458`},
 			HalfHeightWidth -> {82.50062083428497`, 85.16977771422`},
			Area -> {36368.008638693595`, 19027.846111043025`},
		 	PeakRangeStart -> {427.95345692596493`, 655.661743561833`},
		 	PeakRangeEnd -> {655.661743561833`, 865.521489503915`},
		 	WidthRangeStart -> {493.382430813042`, 680.404104327162`},
		 	WidthRangeEnd -> {575.883051647327`, 765.573882041382`},
		 	BaselineIntercept -> {28.815196561612435`, 28.815196561612435`},
		 	BaselineSlope -> {0.`, 0.`}, AsymmetryFactor -> {},
		 	TailingFactor -> {1.0453442610237809`, 1.0143187899638175`},
		 	RelativeArea -> {0.04478487883083343`, 0.023431576662906833`},
		 	RelativePosition -> {0.028023461681605206`, 0.03799203932050886`},
		 	PeakLabel -> {"1", "2"}, TangentWidth -> {}, TangentWidthLines -> {},
		  	TangentWidthLineRanges -> {}, Type -> Object[Analysis, Peaks]
		|>
	)
];
