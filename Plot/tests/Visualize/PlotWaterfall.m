(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*PlotWaterfall: Tests*)


(* ::Section:: *)
(*Unit Testing*)

(* ::Subsection:: *)
(*PlotWaterfall*)


DefineTests[PlotWaterfall,
	{

	(* Example Input: synthetic Data*)
	Example[
		{Basic, "PlotWaterfall accepts numerical data in stacked form:"},
		PlotWaterfall[hillyData],
		_?ValidGraphicsQ
		],

	(* Test dimensionless 2D input data *)
	Test["Function runs for 2D list:",
		PlotWaterfall[list2D],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D list without stack index:",
		PlotWaterfall[{list2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D list with stack index:",
		PlotWaterfall[{1, list2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for multi-layer stacked 2D list:",
		PlotWaterfall[{{1,list2D}, {2,list2D}}],
		_?ValidGraphicsQ
		],

	(* Test 2D input data - lists of quantities *)
	Test["Function runs for 2D list of quantities:",
		PlotWaterfall[unitslist2D],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D list of quantities without stack index:",
		PlotWaterfall[{unitslist2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D list of quantities with stack index:",
		PlotWaterfall[{1,unitslist2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for multi-layer stacked 2D list of quantities:",
		PlotWaterfall[{{1,unitslist2D},{2,unitslist2D}}],
		_?ValidGraphicsQ
		],

		(* Test 2D input data - quantity arrays *)
	Test["Function runs for 2D quantity array:",
		PlotWaterfall[qArray2D],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D quantity array without stack index:",
		PlotWaterfall[{qArray2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for single-layer stacked 2D quantity array with stack index:",
		PlotWaterfall[{1,qArray2D}],
		_?ValidGraphicsQ
		],

	Test["Function runs for multi-layer stacked 2D quantity array:",
		PlotWaterfall[{{1,qArray2D},{2,qArray2D}}],
		_?ValidGraphicsQ
		],

	(* Options tests *)
	Example[
		{Options,ContourLabelPositions,"ContourLabelPositions specifies where the annotations appear with respect to the waterfall:"},
		PlotWaterfall[wavyData,ContourLabelPositions->After],
		g_/;ValidGraphicsQ[g]&&Cases[g,_Text,-1][[1,2,2]]>0
		],

	Test[
		"Setting ContourLabelPositions to Before places the annotations on the left side of the waterfall:",
		PlotWaterfall[hillyData,ContourLabelPositions->Before],
		g_/;ValidGraphicsQ[g]&&Cases[g,_Text,-1][[1,2,2]]<0
		],

	Example[
		{Options,ContourLabels,"Annotations are inferred from the input data when ContourLabels is set to Automatic:"},
		PlotWaterfall[hillyData,ContourLabels->Automatic],
		g_/;ValidGraphicsQ[g]&&Length@Cases[First@g,_Text,-1]>0
		],

	Example[
		{Options,ContourLabels,"Setting ContourLabels to a list of strings directly sets the annotation text:"},
		PlotWaterfall[hillyData,ContourLabels->Characters["ABCDE"]],
		g_/;ValidGraphicsQ[g]&&MatchQ[Cases[g,_Text,-1][[1,1,1,1]],"A"]
		],

	Example[
		{Options,ContourLabels,"Setting ContourLabels to None hides the annotations:"},
		PlotWaterfall[hillyData,ContourLabels->None],
		g_/;ValidGraphicsQ[g]&&Length@Cases[First@g,_Text]==0
		],

	Example[
		{Options,ContourLabelStyle,"Setting ContourLabelStyle to a list of directives formats each annotation:"},
		PlotWaterfall[hillyData,ContourLabelStyle->{Red,Large}],
		g_/;ValidGraphicsQ[g]&&MatchQ[First@Cases[g,_Text,-1][[All,1,2,1]],Red]
		],

	Example[
		{Options,ContourSpacing,"When ContourSpacing is set to Index, the waterfall lines are spaced by their index:"},
		PlotWaterfall[nonlinearlySpacedData,ContourSpacing->Index],
		g_/;ValidGraphicsQ[g]&&First@Differences@First@PlotRange[g]==4
		],

	Example[
		{Options,ContourSpacing,"When ContourSpacing is set to Value, the waterfall lines are spaced by Z-coordinate value:"},
		PlotWaterfall[nonlinearlySpacedData,ContourSpacing->Value],
		g_/;ValidGraphicsQ[g]&&MatchQ[Round@Sqrt@Min@#[[1,All,1]]&/@Cases[g,_Line,-1],Range[5]]
		],

	Example[
		{Options, WaterfallProjection,"Depth is visualized isometrically when WaterfallProjection is set to Orthographic:"},
		PlotWaterfall[hillyData,WaterfallProjection->Orthographic],
		g_/;ValidGraphicsQ[g]&&SameQ[ViewProjection/.Options@g,"Orthographic"]
		],

	Example[
		{Options,WaterfallProjection,"Depth is visualized using an oblique cabinet projection when WaterfallProjection is set to Parallel:"},
		PlotWaterfall[hillyData,WaterfallProjection->Parallel],
		g_/;ValidGraphicsQ[g]&&MatchQ[ViewMatrix/.Options@g,{_List,_List}]
		],

	Test[
		"ProjectionAngle sets the correct angle between the X and Z axes:",
		PlotWaterfall[hillyData,WaterfallProjection->Parallel,ProjectionAngle->Pi/8],
		g_/;ValidGraphicsQ[g]&&MatchQ[(ViewMatrix/.Options@g)[[-1,1,1]],1/Sqrt[1+GoldenRatio^2 Tan[\[Pi]/8]^2]]
		],

	Test[
		"ProjectionDepth sets the correct spacing between contours when WaterfallProjection is set to Perspective:",
		PlotWaterfall[hillyData,WaterfallProjection->Perspective,ProjectionDepth->2],
		g_/;ValidGraphicsQ[g]&&First@(BoxRatios/.Options@g)==2
		],

	Example[{Options,ProjectionDepth,"ProjectionDepth sets the spacing between contours:"},
		Manipulate[
			PlotWaterfall[hillyData,ProjectionDepth->depth],
			{{depth,1,"ProjectionDepth"},0.1,3}
		],
		_Manipulate
		],

	Example[{Options,ProjectionAngle,"ProjectionAngle sets the angle between the X and Z axes when WaterfallProjection is set to Parallel:"},
		Manipulate[
			PlotWaterfall[hillyData,WaterfallProjection->Parallel,ProjectionAngle->angle],
			{{angle,Pi/6,"ProjectionAngle"},0,Pi/3}
		],
		_Manipulate
		],

	Example[
		{Options,AspectRatio,"AspectRatio sets the relative x- and y-axis lengths:"},
		PlotWaterfall[wavyData,AspectRatio->1/3],
		g_/;ValidGraphicsQ[g]&&((BoxRatios/.Options@g)[[-2]]/(BoxRatios/.Options@g)[[-1]])==3
		],

	Test[
		"AspectRatio is passed to EmeraldListPointPlot3D:",
		g=PlotWaterfall[unitslist2D,AspectRatio->2];
		AspectRatio/.Options@g,
		2,
		Variables:>{g}
		],

	Example[
		{Options,PlotRange,"PlotRange sets the lower and upper bounds for all three dimensions:"},
		PlotWaterfall[hillyData,PlotRange->{All,{0.35,Automatic},{0,10}}],
		g_/;ValidGraphicsQ[g]&&(PlotRange/.Last@g)[[2,1]]==0.35
		],

	Example[
		{Options,PlotLabel,"PlotLabel sets the title text that appears above the waterfall:"},
		PlotWaterfall[hillyData,PlotLabel->"Example Title"],
		g_/;ValidGraphicsQ[g]&&(PlotLabel/.Last@g)=="Example Title"
		],

	Test[
		"PlotLabel is not added to top of the waterfall plot when PlotLabel is None:",
		g=PlotWaterfall[unitslist2D];
		SameQ[PlotLabel/.Last@g,None],
		True,
		Variables:>{g}
		],

	Example[
		{Options,ViewPoint,"ViewPoint sets the position of the observer with respect to the center of the plot:"},
		PlotWaterfall[hillyData,ViewPoint->{6, 0, 0.5}],
		_?ValidGraphicsQ
		],

	Example[
		{Options,ViewPoint,"Quantities appearing in ViewPoint are automatically converted to match the input data:"},
		PlotWaterfall[{{1 Hour,singleContourData}},ViewPoint->{250 Minute, 0, 0.5}, ContourSpacing->Value],
		_?ValidGraphicsQ
		],

	Example[
		{Options,ViewPoint,"Specify the position in ZXY space from which the waterfall is viewed:"},
		PlotWaterfall[wavyData,ViewPoint->{3,1,2}],
		g_/;ValidGraphicsQ[g]&&SameQ[ViewPoint/.Last@g,{3,1,2}]
		],

	Example[
		{Options,ViewVector,"Specify the position and direction in ZXY space from which the waterfall is viewed:"},
		PlotWaterfall[wavyData,ViewVector->{{10,5,2},{3,1,0}}],
		g_/;ValidGraphicsQ[g]&&MatchQ[ViewVector/.Last@g,{{10,5,2},{3,1,0}}]
		],

	Example[
		{Options,Axes,"Setting Axes to False hides all axes, axes labels, and tick marks:"},
		PlotWaterfall[hillyData,Axes->False],
		g_/;ValidGraphicsQ[g]&&!(Axes/.Last@g)
		],

	Example[
		{Options,Axes,"Setting Axes to a list of boolean values independently toggles whether the Z,X, and Y axes are displayed:"},
		PlotWaterfall[hillyData,Axes->{False,False,True}],
		g_/;ValidGraphicsQ[g]&&MatchQ[Axes/.Last@g,{False,False,True}]
		],

	Example[
		{Options,AxesEdge,"AxesEdge specifies on which edges of the bounding box axes should be drawn:"},
		PlotWaterfall[hillyData,AxesEdge->{{1, 1},{1,-1},{1,1}}],
		g_/;ValidGraphicsQ[g]&&MatchQ[AxesEdge/.Last@g,{{1,1},{1,-1},{1,1}}]
		],

	Example[
		{Options,AxesLabel,"Set the Z, X, and Y axis labels:"},
		PlotWaterfall[wavyData,AxesLabel->{"Z Axis","X Axis", "Y Axis"},Axes->{True,True,True}],
		g_/;ValidGraphicsQ[g]&&MatchQ[ToString[First[Flatten[#]]]&/@(AxesLabel/.Last@g),{"Z Axis","X Axis","Y Axis"}]
		],
		
	Example[
		{Options,AxesUnits,"Set the Z, X, and Y axis label units:"},
		PlotWaterfall[wavyData,AxesUnits->{Minute,Inch,None},Axes->{True,True,True}],
		g_/;ValidGraphicsQ[g]&&StringContainsQ[StringJoin@Cases[AxesLabel/.Last@g,_String,-1],"Inches"]
		],

	Example[
		{Options,Boxed,"Boxed specifies whether the edges of the bounding box are drawn:"},
		PlotWaterfall[hillyData,Boxed->True],
		g_/;ValidGraphicsQ[g]&&(Boxed/.Last@g)
		],

	Example[
		{Options,Filling,"Filling specifies what content is drawn below each contour in the waterfall:"},
		PlotWaterfall[wavyData,Filling->Axis,ViewPoint->{5,0,0}],
		g_/;ValidGraphicsQ[g]&&(Length@Cases[First@g,_Polygon,-1]>0)
		],

	Example[
		{Options,Legend, "Legend takes a list of strings:"},
		PlotWaterfall[wavyData2,Legend->{"A","B","C","D","E"}],
		g_/;ValidGraphicsQ[g]&&MatchQ[Head@g,Legended]
		],

	Example[
		{Options,TargetUnits,"Set the display units for the Z, X, and Y axes:"},
		PlotWaterfall[
			Table[{z Hour,Table[{x Minute,Sin[2*x]/z Meter},{x,-1,7,.05}]},{z,2,5}],
			TargetUnits->{Second,Second,Inch}
		],
		g_/;ValidGraphicsQ[g]&&First@Differences@(PlotRange/.Last@g)[[2]]==480
		],

	(* Messages tests *)
	Example[
		{Messages, "ParallelProjectionInvalid","Parallel projection of a single contour throws warning:"},
		PlotWaterfall[singleContourData,WaterfallProjection->Parallel],
		g_/;ValidGraphicsQ[g]&&(ViewProjection/.Options@g)=="Perspective",
		Messages:>{Warning::ParallelProjectionInvalid}
		],

	Example[
		{Messages, "LabelsLengthMismatch","Mismatched number of contour labels throws warning:"},
		PlotWaterfall[singleContourData,ContourLabels->{"A", "B"}],
		g_/;ValidGraphicsQ[g]&&Length@Cases[g,_Text,-1]==1,
		Messages:>{Warning::LabelsLengthMismatch}
		],

	Example[
		{Messages, "ViewPointUnitMismatch","Mismatched ViewPoint units throws warning:"},
		PlotWaterfall[{{1,singleContourData}},ViewPoint->{3,0 Hour,1}],
		_?ValidGraphicsQ,
		Messages:>{Warning::ViewPointUnitMismatch}
		],

	(* Object[Data] Overload Input Tests *)
	Example[
		{Basic, "PlotWaterfall accepts a list of Object[Data] objects:"},
		PlotWaterfall[{Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"]},Reflected->True],
		_?ValidGraphicsQ
		],

	Example[
		{Basic,"PlotWaterfall accepts a list of Object[Data] object IDs:"},
		PlotWaterfall[{"id:7X104vK9Av6X","id:7X104vK9Av6X","id:7X104vK9Av6X"}],
		_?ValidGraphicsQ
		],

	Test[
		"PlotWaterfall accepts a list of Object[Data] object links:",
		PlotWaterfall[{Link@nmrObject}],
		_?ValidGraphicsQ
		],

	Test[
		"PlotWaterfall accepts a list of Object[Data] object packets:",
		PlotWaterfall[{nmrPacket}],
		_?ValidGraphicsQ
		],

	Test[
		"PlotWaterfall accepts a list of mixed Object[Data] object reference types:",
		PlotWaterfall[{nmrObject, Link@nmrObject, nmrPacket, nmrObject[ID]}],
		_?ValidGraphicsQ
		],

	(* Object[Data] Overload Options Tests *)
	Example[
		{Options,PrimaryData,"PrimaryData sets which object data field is used to generate the contours:"},
		PlotWaterfall[{chromatographyObject},PrimaryData->Pressure],
		g_/;ValidGraphicsQ[g]&&
      (* First Case is for 12.0, Second for 13.2*)
      (StringContainsQ[First@First@Last@(AxesLabel/.Last@g),"Pressure"] || StringContainsQ[First@First@First@Last@(AxesLabel/.Last@g),"Pressure"])
		],

	Example[
		{Options,LabelField,"LabelField sets the field from which contour Z-coordinate values are generated:"},
		PlotWaterfall[{nmrObject,nmrObject},LabelField->AcquisitionTime,ContourSpacing->Value,Reflected->True],
		g_/;ValidGraphicsQ[g]&&First@Cases[First@g,_Line,-1][[1,1,1]]!=1
		],

	Example[
		{Options, LabelField,"LabelField sets the value of ContourLabels when set to a field that contains non-numeric values:"},
		PlotWaterfall[{nmrObject,nmrObject},LabelField->DateCreated,Reflected->True],
		g_/;ValidGraphicsQ[g]&&Length@Cases[First@g,_Text,-1]>0,
		Messages:>{Warning::NonNumericLabelField}
		],

	(* Object[Data] Overload Messages Tests *)
	Example[
		{Messages,"MixedDataTypes","Input containing mixed data types throws warning:"},
		PlotWaterfall[{chromatographyObject, nmrObject}],
		$Failed,
		Messages:>{Error::MixedDataTypes,Error::InvalidInput}
		],

	Example[
		{Messages,"UnsupportedDataObject","One or more objecs lacking a valid PrimaryData field throws error:"},
		PlotWaterfall[{Object[Data, Viscosity, "id:Z1lqpMz1vdPV"]}],
		$Failed,
		Messages:>{Error::UnsupportedDataObject,Error::InvalidInput}
		],

	Example[
		{Messages,"PrimaryDataEmpty","One or more objecs having an empty PrimaryData field throws error:"},
		PlotWaterfall[{nmrPacket,Association@ReplaceRule[Normal@nmrPacket, NMRSpectrum->{}]},Reflected->True],
		$Failed,
		Messages:>{Error::PrimaryDataEmpty,Error::InvalidInput}
		],

	Example[
		{Messages,"PrimaryDataInvalid","Invalid PrimaryData field throws warning and defaults to a valid alternative:"},
		PlotWaterfall[{nmrObject},PrimaryData->Other,Reflected->True],
		_?ValidGraphicsQ,
		Messages:>{Warning::PrimaryDataInvalid}
		],

	Example[
		{Messages,"LabelFieldNotFound","LabelField not found throws warning:"},
		PlotWaterfall[{nmrObject},LabelField->Test,Reflected->True],
		_?ValidGraphicsQ,
		Messages:>{Warning::LabelFieldNotFound}
		],

	Example[
		{Messages,"NonNumericLabelField","LabelField containing a non-numeric and non-quantity type throws warning:"},
		PlotWaterfall[{nmrObject},LabelField->Type,Reflected->True],
		_?ValidGraphicsQ,
		Messages:>{Warning::NonNumericLabelField}
		],

	Example[
		{Messages,"LabelFieldInvalid", "LabelField not containing a list throws warning:"},
		PlotWaterfall[kineticNMRObject,LabelField->AcquisitionTime,Reflected->True],
		_?ValidGraphicsQ,
		Messages:>{Warning::LabelFieldInvalid}
		],

	Example[
		{Messages,"LabelFieldLengthMismatch", "LabelField containing a list whose length does not match the number of contours throws warning:"},
		PlotWaterfall[kineticNMRObject,LabelField->SmoothingAnalyses,Reflected->True],
		_?ValidGraphicsQ,
		Messages:>{Warning::LabelFieldLengthMismatch}
		],

	Test[
		"Missing object data throws invalid input error:",
		PlotWaterfall[Object[Data,NMR,"taco"]],
		$Failed,
		Messages:>{Download::ObjectDoesNotExist,Error::InvalidInput}
		],

	Test[
		"Repeated options throws error and returns $Failed:",
		PlotWaterfall[{{1,{{1,1},{2,2}}}},Reflected->True,Reflected->True],
		$Failed,
		Messages:>{Error::RepeatedOption}
		],

	(* Standalone 3D Object[Data] Overload Input Tests *)
	Example[
		{Basic,"Plotwaterfall accepts standalone 3D data objects, including Kinetic NMR data:"},
		PlotWaterfall[Object[Data,NMR,"id:7X104vnMY0PZ"],Reflected->True],
		_?ValidGraphicsQ
		],

	Test[
		"Plotwaterfall accepts a standalone 3D data object link:",
		PlotWaterfall[Link@kineticNMRObject],
		_?ValidGraphicsQ
		],

	Test[
		"Plotwaterfall accepts a standalone 3D data object packet:",
		PlotWaterfall[kineticNMRPacket],
		_?ValidGraphicsQ
		],

	Test[
		"Plotwaterfall accepts a standalone 3D data object ID:",
		PlotWaterfall[kineticNMRObject[ID]],
		_?ValidGraphicsQ
		],

	(* Output tests *)
	Test[
		"Setting Output to Result returns a waterfall plot for the input data:",
		PlotWaterfall[hillyData,Output->Result],
		_?ValidGraphicsQ
		],

	Test[
		"Setting Output to Options returns a complete set of options for the input data:",
		PlotWaterfall[hillyData,Output->Options],
		ops_/;MatchQ[ops,OptionsPattern[PlotWaterfall]]
		],

	Test[
		"Setting Output to Preview returns a waterfall plot for the input data:",
		PlotWaterfall[hillyData,Output->Preview],
		_?ValidGraphicsQ
		],

	Test[
		"Setting Output to Tests returns a list of tests for PlotWaterfall:",
		PlotWaterfall[hillyData,Output->Tests],
		{(_EmeraldTest|_Example)...}
		],

	Test[
		"Setting Output to {Result,Options} returns a waterfall plot and all resolved options for the input data:",
		PlotWaterfall[hillyData,Output->{Result,Options}],
		output_List/;ValidGraphicsQ[First@output]&&MatchQ[Last@output,OptionsPattern[PlotWaterfall]]
		]

	},

	Variables:>{
		list2D,unitslist2D,qArray2D,
		hillyData,wavyData,wavyData2,nonlinearlySpacedData,singleContourData,
		chromatographyObject,nmrObject,nmrPacket,
		kineticNMRObject,kineticNMRPacket
		},

	SetUp:>(

		(* Define trivial synthetic test data *)
		list2D=Table[{x,x},{x,0,5}];
		unitslist2D=Table[{x Unit, x Unit},{x,0,5}];
		qArray2D=QuantityArray[Table[{x,x},{x,0,5}],{Unit,Unit}];

		(* Define synthetic data for examples *)
		singleContourData=N@Table[{x,Sin[x]*Cos[x^2]},{x,Pi,3Pi,0.01}];
		hillyData=N@Table[{(z-1)/4,Table[{x/7,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];
		wavyData=N@Table[{z,Table[{x,Sin[2*x]/z},{x,-1,7,.05}]},{z,5}];
		wavyData2=N@Table[{z,Table[{x,x*Sin[2*x]},{x,-1,7,.05}]},{z,5}];
		nonlinearlySpacedData=N@Table[{z^2,Table[{x,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];

		(* Sample Chromatography data *)
		chromatographyObject=Object[Data,Chromatography,"id:7X104vK9Av6X"];

		(* Sample NMR data *)
		nmrObject=Object[Data,NMR,"id:GmzlKjY5eMlp"];
		nmrPacket=Download@nmrObject;

		(* Sample Kinetic NMR data *)
		kineticNMRObject=Object[Data,NMR,"id:7X104vnMY0PZ"];
		kineticNMRPacket=Download@kineticNMRObject;

		)
	];



(* ::Subsection:: *)
(*PlotWaterfallPreview*)


DefineTests[PlotWaterfallPreview,
	{

		(* Example Input: synthetic Data*)
		Example[
			{Basic, "PlotWaterfallPreview accepts numerical data in stacked form:"},
			PlotWaterfallPreview[hillyData],
			_?ValidGraphicsQ
		],

		(* Test dimensionless 2D input data *)
		Test["Function runs for 2D list:",
			PlotWaterfallPreview[list2D],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D list without stack index:",
			PlotWaterfallPreview[{list2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D list with stack index:",
			PlotWaterfallPreview[{1, list2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for multi-layer stacked 2D list:",
			PlotWaterfallPreview[{{1,list2D}, {2,list2D}}],
			_?ValidGraphicsQ
		],

		(* Test 2D input data - lists of quantities *)
		Test["Function runs for 2D list of quantities:",
			PlotWaterfallPreview[unitslist2D],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D list of quantities without stack index:",
			PlotWaterfallPreview[{unitslist2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D list of quantities with stack index:",
			PlotWaterfallPreview[{1,unitslist2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for multi-layer stacked 2D list of quantities:",
			PlotWaterfallPreview[{{1,unitslist2D},{2,unitslist2D}}],
			_?ValidGraphicsQ
		],

		(* Test 2D input data - quantity arrays *)
		Test["Function runs for 2D quantity array:",
			PlotWaterfallPreview[qArray2D],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D quantity array without stack index:",
			PlotWaterfallPreview[{qArray2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for single-layer stacked 2D quantity array with stack index:",
			PlotWaterfallPreview[{1,qArray2D}],
			_?ValidGraphicsQ
		],

		Test["Function runs for multi-layer stacked 2D quantity array:",
			PlotWaterfallPreview[{{1,qArray2D},{2,qArray2D}}],
			_?ValidGraphicsQ
		],
		(* Object[Data] Overload Input Tests *)
		Example[
			{Basic, "PlotWaterfallPreview accepts a list of Object[Data] objects:"},
			PlotWaterfallPreview[{Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"]},Reflected->True],
			_?ValidGraphicsQ
		],

		Example[
			{Basic,"PlotWaterfallPreview accepts a list of Object[Data] object IDs:"},
			PlotWaterfallPreview[{"id:7X104vK9Av6X","id:7X104vK9Av6X","id:7X104vK9Av6X"}],
			_?ValidGraphicsQ
		],

		Test[
			"PlotWaterfallPreview accepts a list of Object[Data] object links:",
			PlotWaterfallPreview[{Link@nmrObject}],
			_?ValidGraphicsQ
		],

		Test[
			"PlotWaterfallPreview accepts a list of Object[Data] object packets:",
			PlotWaterfallPreview[{nmrPacket}],
			_?ValidGraphicsQ
		]

	},

	Variables:>{
		list2D,unitslist2D,qArray2D,
		hillyData,wavyData,wavyData2,nonlinearlySpacedData,singleContourData,
		chromatographyObject,nmrObject,nmrPacket,
		kineticNMRObject,kineticNMRPacket
	},

	SetUp:>(

		(* Define trivial synthetic test data *)
		list2D=Table[{x,x},{x,0,5}];
		unitslist2D=Table[{x Unit, x Unit},{x,0,5}];
		qArray2D=QuantityArray[Table[{x,x},{x,0,5}],{Unit,Unit}];

		(* Define synthetic data for examples *)
		singleContourData=N@Table[{x,Sin[x]*Cos[x^2]},{x,Pi,3Pi,0.01}];
		hillyData=N@Table[{(z-1)/4,Table[{x/7,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];
		wavyData=N@Table[{z,Table[{x,Sin[2*x]/z},{x,-1,7,.05}]},{z,5}];
		wavyData2=N@Table[{z,Table[{x,x*Sin[2*x]},{x,-1,7,.05}]},{z,5}];
		nonlinearlySpacedData=N@Table[{z^2,Table[{x,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];

		(* Sample Chromatography data *)
		chromatographyObject=Object[Data,Chromatography,"id:7X104vK9Av6X"];

		(* Sample NMR data *)
		nmrObject=Object[Data,NMR,"id:GmzlKjY5eMlp"];
		nmrPacket=Download@nmrObject;

		(* Sample Kinetic NMR data *)
		kineticNMRObject=Object[Data,NMR,"id:7X104vnMY0PZ"];
		kineticNMRPacket=Download@kineticNMRObject;

	)
];



(* ::Subsection:: *)
(*PlotWaterfallOptions*)


DefineTests[PlotWaterfallOptions,
	{

		(* Example Input: synthetic Data*)
		Example[
			{Basic, "PlotWaterfallOptions accepts numerical data in stacked form:"},
			PlotWaterfallOptions[hillyData],
			_List
		],

		(* Test dimensionless 2D input data *)
		Test["Function runs for 2D list:",
			PlotWaterfallOptions[list2D],
			_List
		],

		Test["Function runs for single-layer stacked 2D list without stack index:",
			PlotWaterfallOptions[{list2D}],
			_List
		],

		Test["Function runs for single-layer stacked 2D list with stack index:",
			PlotWaterfallOptions[{1, list2D}],
			_List
		],

		Test["Function runs for multi-layer stacked 2D list:",
			PlotWaterfallOptions[{{1,list2D}, {2,list2D}}],
			_List
		],

		(* Test 2D input data - lists of quantities *)
		Test["Function runs for 2D list of quantities:",
			PlotWaterfallOptions[unitslist2D],
			_List
		],

		Test["Function runs for single-layer stacked 2D list of quantities without stack index:",
			PlotWaterfallOptions[{unitslist2D}],
			_List
		],

		Test["Function runs for single-layer stacked 2D list of quantities with stack index:",
			PlotWaterfallOptions[{1,unitslist2D}],
			_List
		],

		Test["Function runs for multi-layer stacked 2D list of quantities:",
			PlotWaterfallOptions[{{1,unitslist2D},{2,unitslist2D}}],
			_List
		],

		(* Test 2D input data - quantity arrays *)
		Test["Function runs for 2D quantity array:",
			PlotWaterfallOptions[qArray2D],
			_List
		],

		Test["Function runs for single-layer stacked 2D quantity array without stack index:",
			PlotWaterfallOptions[{qArray2D}],
			_List
		],

		Test["Function runs for single-layer stacked 2D quantity array with stack index:",
			PlotWaterfallOptions[{1,qArray2D}],
			_List
		],

		Test["Function runs for multi-layer stacked 2D quantity array:",
			PlotWaterfallOptions[{{1,qArray2D},{2,qArray2D}}],
			_List
		],
		(* Object[Data] Overload Input Tests *)
		Example[
			{Basic, "PlotWaterfallOptions accepts a list of Object[Data] objects:"},
			PlotWaterfallOptions[{Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"],Object[Data, NMR, "id:GmzlKjY5eMlp"]},Reflected->True],
			_List
		],

		Example[
			{Basic,"PlotWaterfallOptions accepts a list of Object[Data] object IDs:"},
			PlotWaterfallOptions[{"id:7X104vK9Av6X","id:7X104vK9Av6X","id:7X104vK9Av6X"}],
			_List
		],

		Test[
			"PlotWaterfallOptions accepts a list of Object[Data] object links:",
			PlotWaterfallOptions[{Link@nmrObject}],
			_List
		],

		Test[
			"PlotWaterfallOptions accepts a list of Object[Data] object packets:",
			PlotWaterfallOptions[{nmrPacket}],
			_List
		]

	},

	Variables:>{
		list2D,unitslist2D,qArray2D,
		hillyData,wavyData,wavyData2,nonlinearlySpacedData,singleContourData,
		chromatographyObject,nmrObject,nmrPacket,
		kineticNMRObject,kineticNMRPacket
	},

	SetUp:>(

		(* Define trivial synthetic test data *)
		list2D=Table[{x,x},{x,0,5}];
		unitslist2D=Table[{x Unit, x Unit},{x,0,5}];
		qArray2D=QuantityArray[Table[{x,x},{x,0,5}],{Unit,Unit}];

		(* Define synthetic data for examples *)
		singleContourData=N@Table[{x,Sin[x]*Cos[x^2]},{x,Pi,3Pi,0.01}];
		hillyData=N@Table[{(z-1)/4,Table[{x/7,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];
		wavyData=N@Table[{z,Table[{x,Sin[2*x]/z},{x,-1,7,.05}]},{z,5}];
		wavyData2=N@Table[{z,Table[{x,x*Sin[2*x]},{x,-1,7,.05}]},{z,5}];
		nonlinearlySpacedData=N@Table[{z^2,Table[{x,PDF[NormalDistribution[z,.3],x]},{x,-1,7,.05}]},{z,5}];

		(* Sample Chromatography data *)
		chromatographyObject=Object[Data,Chromatography,"id:7X104vK9Av6X"];

		(* Sample NMR data *)
		nmrObject=Object[Data,NMR,"id:GmzlKjY5eMlp"];
		nmrPacket=Download@nmrObject;

		(* Sample Kinetic NMR data *)
		kineticNMRObject=Object[Data,NMR,"id:7X104vnMY0PZ"];
		kineticNMRPacket=Download@kineticNMRObject;

	)
];
(* ::Section:: *)
(*End Test Package*)
