(* Quieting mathematica invalid input messages *)
Once[Get[FileNameJoin[{System`Private`$MessagesDir, $Language, "Messages.m"}]]];
Map[
  Function[functionName,
    (* All the known messages *)
    Off[functionName::imginv];Off[functionName::argr];Off[functionName::argt];Off[functionName::arg1];Off[functionName::argrx];Off[functionName::argtu];Off[functionName::argb];Off[functionName::argbu];Off[functionName::optx];
    Switch[functionName,
      Image,
        Off[functionName::imgarray];Unprotect[Image]
    ];
    (* All messages we get from the notebook listed in the top *)
    Messages[functionName]=ReplaceAll[Messages[functionName],RuleDelayed[left_,right_] :> If[!MatchQ[right,$Off[___]],RuleDelayed[left,$Off[right]],RuleDelayed[left,right]]]
  ],
  {
    Image,ImageAdjust,Binarize,ColorSeparate,ColorNegate,GradientFilter,GaussianFilter,LaplacianGaussianFilter,BilateralFilter,
    StandardDeviationFilter,MorphologicalBinarize,TopHatTransform,BottomHatTransform,HistogramTransform,FillingTransform,
    BrightnessEqualize,ImageMultiply,RidgeFilter,ImageTrim,EdgeDetect,Erosion,Dilation,Closing,Opening,Inpaint,
    DistanceTransform,MinDetect,MaxDetect,WatershedComponents,MorphologicalComponents,SelectComponents
  }
];

OnLoad[Packager`Private`patchEvaluationData[]];
