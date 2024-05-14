(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotMolecule*)


(* ::Subsection:: *)
(*Option Definitions*)

DefineOptions[PlotMolecule,
	Options:>{
		ModifyOptions[ListPlotOptions,{PlotLabel}],
		{
			OptionName->AtomFontSize,
			Default->10,
			Description->"The font size of letters representing atoms, in units of points.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->BondSpacing,
			Default->0.18,
			Description->"The amount of space between parallel lines in double/triple bonds, as a fraction of the bond length.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->LineWidth,
			Default->0.6,
			Description->"The thickness of bond lines, in units of points.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterP[0.0]],
			Category->"General"
		},
		{
			OptionName->MarginWidth,
			Default->1.6,
			Description->"The amount of space to leave between bonds and atom characters.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0.0]],
			Category->"General"
		}
	}
];

(* ::Subsection:: *)
(*Overloads*)

(* Listable overload *)
PlotMolecule[mols:{_Molecule..},ops:OptionsPattern[PlotMolecule]]:=PlotMolecule[#,ops]&/@mols;


(* ::Subsection:: *)
(*Main Function*)

PlotMolecule[mol_Molecule,ops:OptionsPattern[PlotMolecule]]:=Module[
	{
		validMol,safeOps,bondThick,fsize,margin,spacing,rawSize,smiles,
		molPlot,scaleRule,intermediatePlot,finalPlot
	},

	(* False if molecule isn't valid *)
	validMol=Quiet[
		Check[MoleculeValue[mol],False,{MoleculeValue::mol,Molecule::nintrp}],
		{MoleculeValue::mol, MoleculeValue::argtu}
	];

	(* Quit early if the molecule is invalid *)
	If[validMol===False,
		Return[$Failed];
	];

	(* Sub in default values for options *)
	safeOps=SafeOptions[PlotMolecule,ToList[ops]];

	(* Extract values from options *)
	bondThick=Lookup[safeOps,LineWidth];
	fsize=Lookup[safeOps,AtomFontSize];
	margin=Lookup[safeOps,MarginWidth];
	spacing=Lookup[safeOps,BondSpacing];

	(* SMILES form of this molecule *)
	smiles=MoleculeValue[mol,"SMILES"];

	(* Bypass for cases with multiple molecules, or with non-standard isotopes, since these don't place properly *)
	If[StringContainsQ[smiles,"["~~DigitCharacter~~LetterCharacter..~~"]"]||StringContainsQ[smiles,"."],
		Return@MoleculePlot[mol,
			PlotTheme->{"Monochrome","HeavyAtom"},
			Method->{"DoubleBondOffset"->spacing,"DoubleBondOffsetInRing"->spacing,"FontScaleFactor"->0.035},
			PlotLabel->Lookup[safeOps,PlotLabel]
		]
	];

	(*** PlotMolecule is a workaround; the following Check[] defaults output to MoleculePlot if something breaks ***)
	finalPlot=Check[

		(* Start with the graphic from MM's MoleculePlot Function *)
		molPlot=MoleculePlot[mol,
			PlotTheme->{"Monochrome","HeavyAtom"},
			Method->{"DoubleBondOffset"->spacing,"DoubleBondOffsetInRing"->spacing},
			PlotLabel->Lookup[safeOps,PlotLabel]
		];

		(* Raw image size, needed for scaling the line thickness *)
		rawSize=ImageSizeRaw/.Last[List@@molPlot];

		(* Graphics replacement rule for text sizes *)
		scaleRule=If[$VersionNumber==12.0,
			(g:_GeometricTransformation:>rescaleGeometricTextTransform[g,0.18*fsize]),
			(f:(Tooltip[{{_FilledCurve..}..},_]|{{_FilledCurve..}..}):>rescaleFilledCurve[f,0.18*fsize])
		];

		(* Adjust the scale of atom font *)
		intermediatePlot=molPlot/.scaleRule;

		(* Adjust the bond/atom margins *)
		shortenBonds[intermediatePlot,margin,bondThick],
		$Failed
	];

	(* Return the final plot *)
	If[MatchQ[finalPlot,$Failed],
		MoleculePlot[mol,
			PlotTheme->{"Monochrome","HeavyAtom"},
			Method->{"DoubleBondOffset"->spacing,"FontScaleFactor"->0.0055*fsize},
			PlotLabel->Lookup[safeOps,PlotLabel]
		],
		finalPlot
	]
];


(* ::Subsection:: *)
(*Subfunctions*)


(* ::Subsubsection:: *)
(*rescaleFilledCurve *)

(* Rescale the FilledCurve[] graphics created by MoleculePlot[] while preserving letter centering *)
rescaleFilledCurve[f:{_FilledCurve..}, scale_]:=Module[
	{textCenter},

	(* Center of the coordinates comprising this filled curve atomic name *)
	textCenter=Mean/@CoordinateBounds[Flatten[f[[All,-1]],1]];

	(* Return the transformed curve *)
	GeometricTransformation[f,
		ScalingTransform[{scale,scale},textCenter]
	]
];

(* Collapse lists by one level, since the MM plot code will do this sometimes *)
rescaleFilledCurve[f:{{_FilledCurve..}..}, scale_]:=rescaleFilledCurve[Flatten[f,1], scale];

(* Strip off tooltip *)
rescaleFilledCurve[t_Tooltip, scale_]:=Tooltip[
	rescaleFilledCurve[First[t], scale],
	Last[t]
];


(* ::Subsubsection:: *)
(*rescaleGeometricTextTransform*)

(* Rescale the GeometricTransformation[] graphics created by MoleculePlot while preserving centering of letters *)
rescaleGeometricTextTransform[transform_, scale_]:=Module[
	{textColor,filledCurves,tfs,tmatrices,curvePts,coords,boxCenter,newCurves,newTransforms},

	(* Extract the text color of atoms *)
	textColor=transform[[1,1]];

	(* Extract all filled curves which represent the atom *)
	filledCurves=transform[[1,-1,All]];

	(* Extract the transformation functions used to place letters *)
	tfs=transform[[-1]];

	(* Convert to matrix form *)
	tmatrices=TransformationMatrix/@tfs;

	(* Extract the consituents of the FilledCurve object *)
	{curvePts,coords}=Transpose[List@@@filledCurves];

	(* The center of the coordinate bound box for the original text graphic object *)
	boxCenter=Mean/@CoordinateBounds[Normal[Join@@Flatten[coords]]];

	(* Make a new, fixed FilledCurve where all of the original atoms are centered at 0,0 *)
	newCurves=MapThread[
		Function[{oldFC,pts,cds},
			Append[Most@oldFC,
				Map[(#-boxCenter)&,Normal[cds],{2}]
			]
		],
		{filledCurves,curvePts,coords}
	];

	(* Rescale the new transforms *)
	newTransforms=Map[
		Module[{m},
			m=#;
			m[[1,-1]]=m[[1,-1]]+m[[1,1]]*First[boxCenter];
			m[[2,-1]]=m[[2,-1]]+m[[1,1]]*Last[boxCenter];
			m[[1,1]]=m[[1,1]]*scale;
			m[[2,2]]=m[[2,2]]*scale;
			m
		]&,
		tmatrices
	];

	(* Reconstruct the geometric transformation *)
	GeometricTransformation[
		{textColor,newCurves},
		TransformationFunction/@newTransforms
	]
];




(* ::Subsubsection:: *)
(*shortenBonds*)

(* Shorten bonds next to lettered atoms by a distance d *)
shortenBonds[rawPlot_Graphics,d:GreaterEqualP[0.0],thick:GreaterEqualP[0.0]]:=Module[
	{
		lengthPerPt,plotWidthFactor,thicknessLevel,thickRule,emMolPlot,spacingCutoff,
		lineComplex,textGraphics,textPoints,linePoints,textTransformMatrices,
		textScale,textCenters,textPolygons,textAdjacentPoints,bondLines,movePoint,shortenWedge,
		shortenLineHelper,shortenedLines,newLineGraphic,nearFinalPlot,slightlyLargerPolygons,
		wedgeUpBonds,wedgeDownBonds,newWedgeDownBonds,newWedgeUpBonds,wedgeToLine,wedgeUpLines
	},

	(* Coordinate length which corresponds to 1 pt in the final graphic, using 14.4p for bond length as reference *)
	(* KH - I obtained this from reverse engineering output plots of MoleculePlot[] *)
	lengthPerPt=0.06947;

	(* Calculate a plot width factor to scale thickness by, with a correction for small molecules *)
	plotWidthFactor=With[{rawWidth=PlotRange[rawPlot][[1,-1]]-PlotRange[rawPlot][[1,1]]},
		rawWidth*Exp[Max[2.0-rawWidth,0.0]]
	];

	(* Coordinate length corresponding to specified thickness option *)
	thicknessLevel=(lengthPerPt*thick)/plotWidthFactor;

	(* Graphics replacement rule for modifying line thickness *)
	thickRule=(l:_Line:>{Thickness[thicknessLevel],l});

	(* Apply the thickness rule to the plot *)
	emMolPlot=rawPlot/.thickRule;

	(* Distance in coordinate space corresponding to the requested margin width *)
	spacingCutoff=lengthPerPt*d;

	(* Extract the lines and text graphics from the plot *)
	lineComplex=Part[List@@emMolPlot,1,1];
	textGraphics=Cases[List@@emMolPlot,_GeometricTransformation,10];

	(* The points defining each text graphic. I'm so sorry - KH *)
	textPoints=If[$VersionNumber==12.0,
		Join@@@Join@@@textGraphics[[All,1,-1,All,-1]],
		Join@@@Join@@@textGraphics[[All,1,All,-1]]
	];

	(* The points between which lines are drawn *)
	linePoints=If[$VersionNumber==12.0,
		First[lineComplex],
		Cases[lineComplex,{NumericP,NumericP},10]
	];

	(* The transformation function matrices applied to each text graphic *)
	textTransformMatrices=If[$VersionNumber==12.0,
		Map[
			TransformationMatrix,
			textGraphics[[All,-1]],
			{2}
		],
		Map[
			Function[{raggedArr},
				{Append[MapThread[Append,raggedArr],{0.,0.,1.}]}
			],
			textGraphics[[All,-1]]
		]
	];

	(* The scaling applied to each text graphic *)
	textScale=Mean[Flatten@Map[Part[#,1,1]&,textTransformMatrices,{2}]];

	(* Coordinates of the center of each atom text in the final object *)
	textCenters=Map[Part[#,1;;2,-1]&,textTransformMatrices,{2}];

	(* Rectangles bounding each text entity *)
	textPolygons=Flatten@MapThread[
		Function[{centers,pts},
			BoundingRegion[pts*textScale+Repeat[#,Length[pts]],"MinConvexPolygon"]&/@centers
		],
		{textCenters,textPoints}
	];

	(* After 12.2, BoundingRegion returns polygons instead of BoundaryMeshRegions *)
	If[$VersionNumber>=12.2,
		textPolygons=textPolygons/.{p:_Polygon:>BoundaryMeshRegion[p]}
	];

	(* Select all line end points within the cutoff radius of the text graphics *)
	textAdjacentPoints=Select[linePoints,Function[{p},
		Min[RegionDistance[#,p]&/@textPolygons]<=1.5*spacingCutoff
	]];

	(* list of all Line graphics representing bonds (search five levels deep; infinity is dangerous) *)
	bondLines=Cases[Normal[lineComplex],_Line,5];

	(* For compound lines *)
	shortenLineHelper[multiline:{{{NumericP,NumericP},{NumericP,NumericP}}..}]:=shortenLineHelper/@multiline;

	(* Check if each line in the graphic connects to a text-adjacent point. If so, shorten the line at that point *)
	shortenLineHelper[{p1:{NumericP,NumericP},p2:{NumericP,NumericP}}]:=Which[
		(* Both points are atom points *)
		MemberQ[textAdjacentPoints,p1]&&MemberQ[textAdjacentPoints,p2],{movePoint[p1,Midpoint[{p1,p2}]],movePoint[p2,Midpoint[{p1,p2}]]},
		(* Only the first point is an atom point *)
		MemberQ[textAdjacentPoints,p1],{movePoint[p1,p2],p2},
		(* Only the second point is an atom point *)
		MemberQ[textAdjacentPoints,p2],{p1,movePoint[p2,p1]},
		(* Neither point is an atom point *)
		True,{p1,p2}
	];

	(* Return the coordinates of a new point {x3,y3} obtained by moving {x1,y1} towards {x2,y2} by Euclidean distance d *)
	movePoint[{x1:NumericP,y1:NumericP},{x2:NumericP,y2:NumericP}]:=Module[
		{dist,closestBox,closestAtomDist,boxCoords,boxEdge,intersection,xnew,ynew,moveAmount,moveRatio,solx,soly},

		(* The atom box closest to the point, and the dsitance to it *)
		closestBox=FirstOrDefault@MinimalBy[textPolygons,RegionDistance[#,{x1,y1}]&];
		closestAtomDist=Min[RegionDistance[#,{x1,y1}]&/@textPolygons];

		(* Coordinates of the polygonal bounding box, and line describing its boundary *)
		boxCoords=MeshCoordinates[closestBox];
		boxEdge=Line[Append[boxCoords,First[boxCoords]]];

		(* Intersection of the line {{x1,y1},{x2,y2}} with the closest box *)
		intersection=If[MatchQ[closestBox,Null],
			Null,
			getIntersection[Line[{{x1,y1},{x2,y2}}],boxEdge]
		];

		(* Get the new start point (intersection of line with region) if the point is inside the region already *)
		{xnew,ynew}=If[MatchQ[intersection,Null]||closestAtomDist>0.0,
			{x1,y1},
			intersection
		];

		(* Distance between the two input points *)
		dist=N@EuclideanDistance[{xnew,ynew},{x2,y2}];

		(* Distance to move the point by *)
		moveAmount=Min[Max[0.0,spacingCutoff-closestAtomDist],1.0];

		(* # of inter-point distances to move one point towards the other *)
		moveRatio=If[MatchQ[dist,0|0.0],0.0,N[moveAmount/dist]];

		(* New point *)
		{
			xnew+moveRatio*(x2-xnew),
			ynew+moveRatio*(y2-ynew)
		}
	];

	(* Shorten lines by the given distance *)
	shortenedLines=Map[shortenLineHelper,bondLines,{2}];

	(* Create a new graphic for the lines in the plot *)
	newLineGraphic=If[$VersionNumber==12.0,
		Normal[lineComplex]/.{
			bondLines->shortenedLines
		},
		Append[shortenedLines/.thickRule,Cases[Normal@lineComplex,_Polygon,-1]]
	];

	(* Return the original plot with the old line graphic replaced by the new one *)
	nearFinalPlot=Normal[emMolPlot/.{lineComplex->newLineGraphic}];

	(* Extract wedge up bonds *)
	wedgeUpBonds=If[$VersionNumber==12.0,
		(* Extract polygons with gray level set *)
		Cases[nearFinalPlot,{GrayLevel[0],_Polygon},-1],
		(* Extract triangles *)
		Cases[nearFinalPlot,Polygon[{Repeated[{NumericP,NumericP},3]}],-1]
	];

	(* Extract wedge down bonds *)
	wedgeDownBonds=If[$VersionNumber==12.0,
		(* Extract multi-lines with gray levels set *)
		Cases[nearFinalPlot,{GrayLevel[0],{Thickness[Small],{_Thickness,{_Line..}}}},-1],
		(* Extract compound lines with at least four lines *)
		Cases[nearFinalPlot,
			{
					Thickness[_],
					Line[{
						Repeated[{{NumericP,NumericP},{NumericP,NumericP}},{4,Infinity}]
					}]
			},
			-1
		]
	];

	(* Make the text polygonal bounding boxes 7% larger for edge detection with wedges *)
	slightlyLargerPolygons=RegionResize[#,Scaled[1.28]]&/@textPolygons;

	(* Remove dash bonds which overlap with atom text graphics which have been enlarged *)
	newWedgeDownBonds=wedgeDownBonds/.{
		lineList:{_Line..}:>Select[lineList,Function[{line},And@@(RegionDisjoint[line,#]&/@slightlyLargerPolygons)]],
		If[$VersionNumber>=12.2,
			{t_Thickness,l_Line}:>{t,Select[Line/@First[l],Function[{line},And@@(RegionDisjoint[line,#]&/@slightlyLargerPolygons)]]},
			Nothing
		]
	};

	(* Convert the wedge up bonds (triangles) into the equivalent non-wedged bonds *)
	wedgeToLine[triangle_Polygon]:=Module[
		{pts,allCombos,minSplit},

		(* Pull coordinates out of the polygon *)
		pts=First[triangle];

		(* All three splits of points into 2-1 *)
		allCombos=RotateRight[pts,#]&/@Range[Length[pts]];

		(* Select the 2-1 split with the shortest distance between the two *)
		minSplit=First@MinimalBy[allCombos,EuclideanDistance[#[[1]],#[[2]]]&];

		(* Return a line from the midpoint of the to close points to the long one *)
		Line[{Midpoint[{minSplit[[1]],minSplit[[2]]}],minSplit[[3]]}]
	];

	(* A list of lines representing the wedge bonds, with the fat end first *)
	wedgeUpLines=If[$VersionNumber==12.0,
		Map[wedgeToLine[#]&,Last/@wedgeUpBonds],
		Map[wedgeToLine[#]&,wedgeUpBonds]
	];

	(* Given a polygon representing a bond, the line that represents it, and a distance to shorten by, create a new graphic *)
	shortenWedge[p_,l_Line,dist:NumericP]:=Module[
		{shortenDist,polyPts,bondAxis,shortenRatio,scaleMatrix},

		(* Backwards compatibility with 12.0 *)
		poly=If[MatchQ[p,_Polygon],
			{Null,p},
			p
		];

		(* Handle edge cases *)
		shortenDist=Max[0.0,spacingCutoff-dist];

		(* Extract triangle points from the polygon *)
		polyPts=poly[[-1,1]];

		(* vector describing the bond axis *)
		bondAxis=l[[1,1]]-l[[1,-1]];

		(* Ratio of the amount to shorten by to the length of the bond axis *)
		shortenRatio=shortenDist/Norm[bondAxis];

		(* Return unchanged if *)
		If[shortenDist==0||shortenRatio>=1.0,Return[poly]];

		(* Matrix describing the rescaling of the wedge bond *)
		scaleMatrix=TransformationMatrix[ScalingTransform[1.0-shortenRatio,bondAxis,Midpoint[l]]];

		(* Translate so we are centered at the right-most point of the wefge*)
		scaleMatrix[[1;;2,-1]]=scaleMatrix[[1;;2,-1]]-bondAxis*shortenRatio/Sqrt[2];

		(* Transform the input polygon *)
		GeometricTransformation[poly,TransformationFunction[scaleMatrix]]
	];

	(* Up wedges which overlap with atom fonts *)
	newWedgeUpBonds=MapThread[
		Function[{polygonGraphic,line},
			shortenWedge[
				polygonGraphic,
				line,
				Min[SignedRegionDistance[#,line[[1,1]]]&/@textPolygons]/.{Infinity->0}
			]
		],
		{wedgeUpBonds,wedgeUpLines}
	];

	(* Apply replacement rules to fix the length of wedge bonds *)
	nearFinalPlot/.{
		Sequence@@Thread[wedgeDownBonds->newWedgeDownBonds],
		Sequence@@Thread[wedgeUpBonds->newWedgeUpBonds]
	}
];



(* ::Subsubsection:: *)
(*findIntersect*)

(* Find the intersection between two lines defined by pairs of points *)
findIntersect[{{x1_,y1_},{x2_,y2_}},{{x3_,y3_},{x4_,y4_}}]:=Module[
	{m1,m2,xs,ys,inSeg1,inSeg2},

	(* solve the system *)
	Quiet[
		m1=N[(y2-y1)/(x2-x1)];
		m2=N[(y4-y3)/(x4-x3)];

		(* Handle vertical and horizontal lines *)
		{xs,ys}=Which[
			x1==x2&&x3==x4,{Indeterminate,Indeterminate},
			y1==y2&&y3==y4,{Indeterminate,Indeterminate},
			x1==x2,{x1,m2*(x1-x3)+y3},
			x3==x4,{x3,m1*(x3-x1)+y1},
			True,{(m1*x1-m2*x3+y3-y1)/(m1-m2),m1*(xs-x1)+y1}
		];
	];

	(* Booleans if the solution is within line segments 1 and 2 *)
	inSeg1=And[xs=!=Indeterminate,ys=!=Indeterminate,Min[x1,x2]<=xs<=Max[x1,x2],Min[y1,y2]<=ys<=Max[y1,y2]];
	inSeg2=And[xs=!=Indeterminate,ys=!=Indeterminate,Min[x3,x4]<=xs<=Max[x3,x4],Min[y3,y4]<=ys<=Max[y3,y4]];

	(* Return solution *)
	If[m1==m2||!(inSeg1&&inSeg2),
		Nothing,
		{xs,ys}
	]
];



(* ::Subsubsection:: *)
(*getIntersect*)

(* Find the intersection of a line segment and *)
getIntersection[singleLine_Line,multiLine_Line]:=Module[
	{oneLinePts,manyLinePts,intersects,xmin,xmax},

	(* Extract points *)
	oneLinePts=First[singleLine];
	manyLinePts=Partition[First[multiLine],2,1];

	(* Solve for intersection points *)
	intersects=findIntersect[oneLinePts,#]&/@manyLinePts;

	(* Safe solution*)
	FirstOrDefault[intersects]
];
