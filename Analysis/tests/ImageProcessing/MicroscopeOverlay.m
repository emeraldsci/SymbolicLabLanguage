(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*MicroscopeOverlay: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*AnalyzeMicroscopeOverlay*)


(* ::Subsubsection:: *)
(*AnalyzeMicroscopeOverlay*)

DefineTests[AnalyzeMicroscopeOverlay, {

(* ---- Basic ---- *)

	Example[{Basic, "Overlay images from one Microscope data:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], Upload -> False], Overlay],
		_Image
	],

	Example[{Basic, "Analyze all data from a Microscope protocol:"},
		Lookup[AnalyzeMicroscopeOverlay[Object[Protocol, Microscope, "id:aXRlGnZPeoJp"], Upload -> False], Overlay],
		{_Image}
	],

	Example[{Basic, "Analyze a list of Microscope data:"},
		Lookup[AnalyzeMicroscopeOverlay[{Object[Data, Microscope, "id:kEJ9mqaV6XL3"], Object[Data, Microscope, "id:O81aEB4kXLDD"]}, Upload -> False], Overlay],
		{_Image, _Image}
	],

(*	need to find the correct protocols*)
	Example[{Basic, "Analyze all data from a list of Microscope protocols:"},
		Lookup[AnalyzeMicroscopeOverlay[{Object[Protocol, Microscope, "id:aXRlGnZPeoJp"], Object[Data,Microscope,"id:XnlV5jmbZpPb"]}, Upload -> False], Overlay],
		{_Image..}
	],

(* ---- Additional ---- *)

	Example[{Additional, "Overlay a microscope image containing Red, Green, and Blue channels:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:O81aEB4kXLDD"], Upload -> False], Overlay],
		_Image
	],

	Example[{Additional, "Overlay a microscope image containing Red and Green channels:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:aXRlGnZmO05p"], Upload -> False], Overlay],
		_Image
	],

	Example[{Additional, "Overlay a microscope image containing only Green channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:XnlV5jmbZpPb"], Upload -> False], Overlay],
		_Image
	],

	Example[{Additional, "Analyze all data from a list of mixed Microscope protocol (one without data, one with data, and one data object):"},
		Lookup[AnalyzeMicroscopeOverlay[
			{
				Object[Protocol, Microscope, "id:rea9jl1oGnqb"],
				Object[Protocol, Microscope, "id:aXRlGnZPeoJp"],
				Object[Data, Microscope, "id:O81aEB4kXLDD"]
			},
			FalseColorRed -> Purple, Upload -> False], Overlay],
		{_Image..},
		Messages:>{Message[Warning::NoData,{Object[Protocol,Microscope,"id:rea9jl1oGnqb"]}]}
	],

(* ---- Options ---- *)

	Example[{Options, BrightnessRed, "Adjust brightness of the FalseRed channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], BrightnessRed -> 0.5, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, BrightnessGreen, "Adjust brightness of the FalseGreen channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], BrightnessGreen -> -0.3, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, BrightnessBlue, "Adjust brightness of the FalseBlue channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], BrightnessBlue -> 0.5, Upload -> False], Overlay],
		_Image
	],

	Example[{Options, ContrastRed, "Adjust contrast of the FalseRed channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], ContrastRed -> 0.1, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, ContrastGreen, "Adjust contrast of the FalseGreen channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], ContrastGreen -> 0.3, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, ContrastBlue, "Adjust contrast of the FalseBlue channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:eGakld01znMo"], ContrastBlue -> 1, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, FalseColorRed, "Adjust color base of the Green and Red channels:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], FalseColorGreen -> Purple, FalseColorRed -> Orange, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, FalseColorGreen, "Adjust color base of the FalseRed channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], FalseColorGreen -> Orange, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, FalseColorBlue, "Adjust color base of the FalseBlue channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:O81aEB4kXLDD"], FalseColorBlue -> Yellow, ChannelsOverlaid->{Blue,PhaseContrast}, Upload -> False], Overlay],
		_Image
	],

	Example[{Options, Transparency, "Increase transparency of the fluorescent image, making phase contrast image more visible:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], Transparency -> 0.85, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, ChannelsOverlaid, "Only overlay Red channel:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], ChannelsOverlaid -> {Red,PhaseContrast}, Upload -> False], Overlay],
		_Image
	],

	Example[{Options, Output, "Return the packet:"},
		First@AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], ChannelsOverlaid -> {Red,PhaseContrast}, Upload -> False, Output -> Result],
		PacketP[]
	],

	Example[{Options, Output, "Return the options:"},
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], ChannelsOverlaid -> {Red,PhaseContrast}, Output -> Options],
		OptionsPattern[]
	],

	Example[{Options, Output, "Return the preview:"},
		AnalyzeMicroscopeOverlay[{Object[Protocol, Microscope, "id:aXRlGnZPeoJp"], Object[Data, Microscope, "id:O81aEB4kXLDD"]}, Output -> Preview, FalseColorRed -> Purple, Upload -> False],
		_SlideView
	],

	Example[{Options, Output, "Return the tests:"},
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], ChannelsOverlaid -> {Red,PhaseContrast}, Output -> Tests],
		{TestP ..}
	],

	Example[{Options, Template, "Use options from previous MicroscopeOverlay analysis:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], Template -> Object[Analysis, MicroscopeOverlay, "id:AEqRl9KVz4Xp"], Upload -> False], Overlay],
		_Image

	],

	Example[{Options, Template, "Explicitly specify Transparency option, and pull remaining options from previous MicroscopeOverlay analysis:"},
		First@Lookup[AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], Template -> Object[Analysis, MicroscopeOverlay, "id:AEqRl9KVz4Xp"], Transparency -> 0.7`, Upload -> False], Overlay],
		_Image

	],

	Example[{Options, Template, "Explicitly specify different options for a list of inputs:"},
		Lookup[AnalyzeMicroscopeOverlay[{Object[Data, Microscope, "id:eGakld01znMo"], Object[Data, Microscope, "id:jLq9jXY43nza"], Object[Data, Microscope, "id:kEJ9mqaV6XL3"]},
			Transparency -> {0.1, 0.5, 0.9}, FalseColorGreen -> {Yellow, Green, Purple}, Upload -> False], Overlay],
		{_Image,_Image,_Image}

	],

(* ----------- MESSAGES ------------- *)

(*	This should be taken care of by the options resolver *)

	Example[{Messages, "NoOverlayChannels", "There must be at least one overlay channel specified/available:"},
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], ChannelsOverlaid -> {Blue}, Upload -> False, Output -> Result],
		$Failed,
		Messages:>{
			Message[Warning::InvalidOverlayChannels,{Object[Data,Microscope,"id:jLq9jXY43nza"]}],
			Message[Error::NoOverlayChannels,{Object[Data,Microscope,"id:jLq9jXY43nza"]}],
			Message[Error::InvalidInput,"{Object[Data, Microscope, \"LegacyID:49058\"]}"],
			Message[Error::InvalidOption,{ChannelsOverlaid}]}
	],
	Example[{Messages, "InvalidOverlayChannels", "The specified channels must be available in the data object:"},
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:aXRlGnZmO05p"], ChannelsOverlaid -> {PhaseContrast, Blue, Green}, Upload -> False],
		{PacketP[]},
		Messages:>{Message[Warning::InvalidOverlayChannels,{Object[Data, Microscope, "id:aXRlGnZmO05p"]}]}
	],
	Example[{Messages,"NoFluorescentChannel","PhaseContrast cannot be only channel specified:"},
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"],Upload->False,ChannelsOverlaid->{PhaseContrast}],
		$Failed,
		Messages:>{
			Message[Error::NoFluorescentChannel,{Object[Data,Microscope,"id:jLq9jXY43nza"]}],
			Message[Error::InvalidInput,"{Object[Data, Microscope, \"LegacyID:49058\"]}"],
			Message[Error::InvalidOption,{ChannelsOverlaid}]
		}
	],
	Example[{Messages,"NoData","Provided Protocols must include at least one data:"},
		AnalyzeMicroscopeOverlay[{Object[Protocol, Microscope, "id:R8e1PjRvqrld"], Object[Protocol, Microscope, "id:O81aEB4r6pAN"]},Upload->False],
		$Failed,
		Messages:>{Message[Warning::NoData,{Object[Protocol,Microscope,"id:R8e1PjRvqrld"],Object[Protocol,Microscope,"id:O81aEB4r6pAN"]}],Message[Error::NoData]}
	],

(* ---- Tests ---- *)

	Test["Given a packet:",
		First@Lookup[AnalyzeMicroscopeOverlay[Download[Object[Data, Microscope, "id:jLq9jXY43nza"]], Upload -> False], Overlay],
		_Image
	],
	Test["Given a link:",
		First@Lookup[AnalyzeMicroscopeOverlay[Link[Object[Data, Microscope, "id:jLq9jXY43nza"]], Upload -> False], Overlay],
		_Image
	],
	Test["Upload result:",
		AnalyzeMicroscopeOverlay[Object[Data, Microscope, "id:jLq9jXY43nza"], Upload -> True],
		{ObjectP[Object[Analysis, MicroscopeOverlay]]..}
	],
	Test["Use a previous overlay as a template for a protocol:",
		Lookup[AnalyzeMicroscopeOverlay[Object[Protocol, Microscope, "id:4pO6dMWvLzpB"], Template -> Object[Analysis, MicroscopeOverlay, "id:AEqRl9KVz4Xp"], Upload -> False], Overlay],
		{_Image..},
		TimeConstraint->1000
	]
}
];

(* ::Section:: *)
(*End Test Package*)

DefineTests[AnalyzeMicroscopeOverlayPreview, {
(* ---- Basic ---- *)
	Example[{Basic, "Preview images from one Microscope data:"},
		AnalyzeMicroscopeOverlayPreview[Object[Data, Microscope, "id:jLq9jXY43nza"]],
		_DynamicModule
	],
	Example[{Basic, "Preview a list of Microscope data:"},
		AnalyzeMicroscopeOverlayPreview[{Object[Data, Microscope, "id:kEJ9mqaV6XL3"], Object[Data, Microscope, "id:O81aEB4kXLDD"]}],
		_SlideView
	],
	Example[{Basic, "Preview all data from a Microscope protocol:"},
		AnalyzeMicroscopeOverlayPreview[Object[Protocol, Microscope, "id:aXRlGnZPeoJp"]],
		_DynamicModule
	]
}
];

DefineTests[AnalyzeMicroscopeOverlayOptions, {
(* ---- Basic ---- *)
	Example[{Basic, "Get options from one Microscope data:"},
		AnalyzeMicroscopeOverlayOptions[Object[Data, Microscope, "id:jLq9jXY43nza"], FalseColorBlue -> Purple, ChannelsOverlaid -> {Green, PhaseContrast}],
		OptionsPattern[]
	],
	Example[{Basic, "Get options from a list of Microscope data:"},
		AnalyzeMicroscopeOverlayOptions[{Object[Data, Microscope, "id:kEJ9mqaV6XL3"], Object[Data, Microscope, "id:O81aEB4kXLDD"]}],
		OptionsPattern[]
	],
	Example[{Basic, "Get options from one Microscope protocol:"},
		AnalyzeMicroscopeOverlayOptions[Object[Protocol, Microscope, "id:aXRlGnZPeoJp"], FalseColorRed -> Purple, ChannelsOverlaid -> {Green, PhaseContrast}],
		OptionsPattern[],
		Stubs:>{
			Object[Protocol, Microscope, "id:aXRlGnZPeoJp"][Data] = {Object[Data, Microscope, "id:eGakld01znMo"],Object[Data, Microscope, "id:jLq9jXY43nza"],Object[Data, Microscope, "id:kEJ9mqaV6XL3"]}
		}
	]
}
];

DefineTests[ValidAnalyzeMicroscopeOverlayQ, {
(* ---- Basic ---- *)
	Example[{Basic, "Check validity of one Microscope data:"},
		ValidAnalyzeMicroscopeOverlayQ[Object[Data, Microscope, "id:kEJ9mqaV6XL3"]],
		BooleanP
	],
	Example[{Basic, "Check validity of a list of Microscope data:"},
		ValidAnalyzeMicroscopeOverlayQ[{Object[Data, Microscope, "id:kEJ9mqaV6XL3"], Object[Data, Microscope, "id:O81aEB4kXLDD"]}],
		BooleanP
	],
	Example[{Basic, "Check validity of one Microscope protocol:"},
		ValidAnalyzeMicroscopeOverlayQ[Object[Protocol, Microscope, "id:4pO6dMWvLzpB"]],
		BooleanP
	],
(* ---- Options ---- *)
	Example[{Options, OutputFormat, "Change output format to TestSummary:"},
		ValidAnalyzeMicroscopeOverlayQ[Object[Data, Microscope, "id:eGakld01znMo"], OutputFormat -> TestSummary],
		_EmeraldTestSummary
	],
	Example[{Options, Verbose, "Output TestSummary and Verbose->True:"},
		ValidAnalyzeMicroscopeOverlayQ[Object[Data, Microscope, "id:O81aEB4kXLDD"], OutputFormat -> TestSummary, Verbose -> True],
		_EmeraldTestSummary
	]
}
];
