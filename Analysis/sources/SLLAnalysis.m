(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*app helpers*)


(* ::Subsubsection::Closed:: *)
(*appWindow*)


Options[appWindow]={
	WindowTitle->Null,
	WindowSize->{910,580},
	Deployed->True,
	WindowFrame->"Normal",
	WindowFrameElements->{"CloseBox","ResizeArea"},
	WindowElements->{"VerticalScrollBar","HorizontalScrollBar","MagnificationPopUp"},
	Return:>Null,
	Window->DialogInput
};
SetAttributes[appWindow,HoldFirst];
appWindow[{displayPanel_,controlPanel_,outputPanel_},ops:OptionsPattern[appWindow]]:=EmeraldDialog[
	appPanel[displayPanel,controlPanel,outputPanel],
	WindowTitle->OptionValue[WindowTitle],
	WindowSize->OptionValue[WindowSize],
	Deployed->OptionValue[Deployed],
	WindowFrame->OptionValue[WindowFrame],
	WindowFrameElements->OptionValue[WindowFrameElements],
	WindowElements->OptionValue[WindowElements],
	NotebookEventActions -> {"ReturnKeyDown":> EmeraldDialogReturn[OptionValue[Return]], "EscapeKeyDown":>EmeraldDialogReturn[$Canceled], "WindowClose":>EmeraldDialogReturn[$Canceled]},
	KernelModal->MatchQ[OptionValue[Window],DialogInput]
];


(* ::Subsubsection::Closed:: *)
(*appPanel*)


appPanel[display_,control_,output_]:=Module[{},
	Grid[{{display,control},{output,SpanFromLeft}},Alignment->Top]
];


(* ::Subsubsection:: *)
(*appOutputPanel*)


SetAttributes[appOutputPanel,HoldAll];
Options[appOutputPanel]={
	QCListOut -> Null,
	FitExpressionType -> Other,
	Cancel->$Canceled,
	Skip->Null,
	ImageSize->Automatic,
	Enabled->True,
	Method->"Preemptive",
	AppVar:>Unique["var"],
	ReturnVar->Object,
	ReturnOptions->{}
};
appOutputPanel[resolvedOps_,OptionsPattern[appOutputPanel]]:=Module[
	{imageSize,var,returnVar=OptionValue[ReturnVar],returnOptions,out},

	out[]:=ReplaceRule[
			resolvedOps,
			{
				Upload->var[Upload],
				ApplyAll->var[ApplyAll],
				Return->returnVar,
				Output->returnVar
			}
		];

	var[Upload]=Lookup[resolvedOps,Upload,False];
	var[ApplyAll]=Lookup[resolvedOps,ApplyAll,False];
	returnVar = Lookup[resolvedOps, Output, Object];

	imageSize=Switch[OptionValue[ImageSize],
		{_?NumberQ,_?NumberQ},OptionValue[ImageSize],
		_?NumberQ,{OptionValue[ImageSize],65},
		Automatic,{800,65}
	];

	returnOptions = Join[OptionValue[ReturnOptions],{Object, Packet}];

	Panel[
		Grid[{{
			Text["Analyzing " <> ToString[Lookup[resolvedOps, Index, {1, 1}][[1]]] <> " of " <> ToString[Lookup[resolvedOps, Index, {1, 1}][[2]]]],
			(* CancelAll button returns OptionValue[Cancel].  Should be caught by mapping definition of app function. *)
			Button["Cancel",EmeraldDialogReturn[OptionValue[Cancel]],ImageSize->{65,50}, Method->"Preemptive"],
			(* Skip button returns OptionValue[Skip]. *)
			Button["Skip",EmeraldDialogReturn[OptionValue[Skip]],ImageSize->{50,50}, Method->"Preemptive", Enabled -> !MatchQ[Lookup[resolvedOps, Index, {1, 1}][[2]], 1]],
			(* Spacer *)
			Null,
			(* Evaluate returnExpression *)
			Button["Return",EmeraldDialogReturn[out[]],ImageSize->{75,50}, Method->"Preemptive"],
			"       ",
			Grid[{
				{Style["Return Value",14]},
				{PopupMenu[Dynamic[returnVar],returnOptions]}
			}],
			Null,
			Grid[{
					{Row[{Checkbox[Dynamic[var[Upload]]],"Update Database"},"  "]},
					{Row[{Checkbox[Dynamic[var[ApplyAll]], Enabled -> !MatchQ[Lookup[resolvedOps, Index, {1, 1}][[2]], 1]],"Apply options to rest"},"  "]}
				},Alignment->Left,Spacings->{Automatic,1}
			]
		}}],
		Alignment->Center,
		ImageSize->imageSize,
		FrameMargins->1
	]

];


(* ::Subsubsection:: *)
(*makeAppWindow*)


Options[makeAppWindow]={
	FitExpressionType -> Other,
	WindowTitle->Null,
	WindowSize->{910,580},
	Deployed->True,
	WindowFrame->"Normal",
	WindowFrameElements->{"CloseBox","ResizeArea"},
	WindowElements->{"VerticalScrollBar","HorizontalScrollBar","MagnificationPopUp"},
	Return:>Null,
	Cancel :> $Canceled,
	Skip :> Null,
	DisplayPanel -> Null,
	ControlPanel -> Null,
	AppTest -> False,
	ReturnOptions -> {}
};

makeAppWindow[resolvedOps_, ops:OptionsPattern[makeAppWindow]]:= OptionValue[Cancel] /; MatchQ[OptionValue[AppTest],Cancel];
makeAppWindow[resolvedOps_, ops:OptionsPattern[makeAppWindow]]:= OptionValue[Skip] /; MatchQ[OptionValue[AppTest],Skip];
makeAppWindow[resolvedOps_, ops:OptionsPattern[makeAppWindow]]:= OptionValue[Return] /; MatchQ[OptionValue[AppTest],Return];


(*SetAttributes[makeAppWindow,HoldFirst];*)
makeAppWindow[ops:OptionsPattern[makeAppWindow]]:=With[{
		displayPanel = OptionValue[DisplayPanel],
		controlPanel = OptionValue[ControlPanel],
		outputPanel = appOutputPanel[OptionValue[Return], Cancel->OptionValue[Cancel],Skip->OptionValue[Skip], ReturnOptions -> OptionValue[ReturnOptions]]
	},

	EmeraldDialog[
		Grid[{{displayPanel,controlPanel},{outputPanel,SpanFromLeft}},Alignment->Top],
		WindowTitle->OptionValue[WindowTitle],
		WindowSize->OptionValue[WindowSize],
		Deployed->OptionValue[Deployed],
		WindowFrame->OptionValue[WindowFrame],
		WindowFrameElements->OptionValue[WindowFrameElements],
		WindowElements->OptionValue[WindowElements],
		NotebookEventActions -> {
			"ReturnKeyDown" :> EmeraldDialogReturn[OptionValue[Return]],
			"EscapeKeyDown" :> EmeraldDialogReturn[$Canceled],
			"WindowClose" :> EmeraldDialogReturn[$Canceled]
		},
		KernelModal->True
	]
];


