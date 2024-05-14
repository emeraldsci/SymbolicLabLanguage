(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCloudFile*)


DefineOptions[PlotCloudFile,
  Options:>{

    (*** PlotLabeling Options ***)
    ModifyOptions[ImageOptions,
      {
        {OptionName->RulerPlacement,Default->None},
        {OptionName->Scale},
        {OptionName->MeasurementLabel}
      }
    ],

    (*** Controlling Options ***)
    ModifyOptions[ImageOptions,
      {MeasurementLines,RulerType}
    ],

    (*** Output Option ***)
    OutputOption
  },
  SharedOptions:>{
    {PlotImage,
      {
        TargetUnits,AspectRatio,AlignmentPoint,Axes,AxesLabel,AxesOrigin,AxesStyle,Background,BaselinePosition,
  			BaseStyle,ColorOutput,ContentSelectable,CoordinatesToolOptions,DisplayFunction,Epilog,FormatType,FrameStyle,
        ImageMargins,ImagePadding,ImageSize,ImageSizeRaw,LabelStyle,Method,PlotLabel,PlotRegion,PreserveImageOptions,
        Prolog,RotateLabel,Ticks,TicksStyle
      }
    }
  }
];


PlotCloudFile[input:ObjectP[Object[EmeraldCloudFile]],ops:OptionsPattern[PlotCloudFile]]:=Module[
  {originalOps,safeOps,output},
  (* Convert the original option into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
  safeOps=SafeOptions[PlotCloudFile,checkForNullOptions[originalOps]];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

  (* For listed outputs, we need to take the first element of each of the Result, Options, etc *)
  If[MatchQ[output,_List],
    FirstOrDefault[#]&/@PlotCloudFile[{input},ops],
    FirstOrDefault[PlotCloudFile[{input},ops]]
  ]

];


PlotCloudFile[input:{ObjectP[Object[EmeraldCloudFile]]..},ops:OptionsPattern[PlotCloudFile]]:=Module[

  {
    cloudFiles,fileContents,originalOps,safeOps,output,options,finalOutput
  },

  (* Convert the original option into a list *)
  originalOps=ToList[ops];

  (* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options. *)
  safeOps=SafeOptions[PlotCloudFile,checkForNullOptions[originalOps]];

  (* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
  output=Lookup[safeOps,Output];

  (* Get the cloud file for each input *)
	cloudFiles=Download[input,CloudFile];

	(* Import each cloud file *)
	fileContents=Constellation`Private`importCloudFile[#]&/@cloudFiles;

	(* If the cloud file is an image or graphic, we will call PlotImage. If it is text, we will make a snippet. Otherwise, null. *)
	plot=Switch[#,
		_Graphics|_Image,
    PlotImage[#,Output->Result,PassOptions[PlotCloudFile,PlotImage,ReplaceRule[safeOps,Output->Result]]],

    {(_Graphics|_Image)..},
    PlotImage[FirstOrDefault[#],PassOptions[PlotCloudFile,PlotImage,ReplaceRule[safeOps,Output->Result]]],

    _String,
    Snippet[ContentObject[#],5],

    _,
    Null
	]&/@fileContents;

  (* If the cloud file is an image or graphic, we will call PlotImage. If it is text, we will make a snippet. Otherwise, null. *)
  options=Switch[#,
		_Graphics|_Image,
    PlotImage[#,PassOptions[PlotCloudFile,PlotImage,ReplaceRule[safeOps,Output->Options]]],

    {(_Graphics|_Image)..},
    PlotImage[FirstOrDefault[#],PassOptions[PlotCloudFile,PlotImage,ReplaceRule[safeOps,Output->Options]]],

    _String,
    safeOps,

    _,
    Null
	]&/@fileContents;

  (* Return the result, according to the output option. *)
  output/.{
    Result->plot,
    Preview->plot,
    Tests->{},
    Options->options
  }

];


(* ::Section:: *)
(*End*)
