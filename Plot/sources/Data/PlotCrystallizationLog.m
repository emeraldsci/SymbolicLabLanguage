(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCrystallizationImagingLog*)


DefineOptions[PlotCrystallizationImagingLog,
	Options :> {
		(* Hide these options *)
		(* Set default ImageSize to 500 *)
		ModifyOptions[ListPlotOptions, {{OptionName -> ImageSize, Default -> 500}}],
		OutputOption
	}
];

(* Single input *)
PlotCrystallizationImagingLog[sample: ObjectP[Object[Sample]], inputOptions: OptionsPattern[]] := PlotCrystallizationImagingLog[{sample}, inputOptions];
(* Core *)
PlotCrystallizationImagingLog[samples: ListableP[ObjectP[Object[Sample]]], inputOptions: OptionsPattern[]] := Module[
	{
		originalOps, safeOps, output, plotOption, downloadPackets, combinedCache, fastCache, parsedData,
		nonNullHeadings, stringHeadings, tabulatedData, plot
	},

	(* Convert the original options into a list *)
	originalOps = ToList[inputOptions];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps = SafeOptions[PlotCrystallizationImagingLog, ToList[inputOptions]];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = Lookup[safeOps, Output];
	(* Look up plot options *)
	plotOption = Lookup[safeOps, ImageSize];

	(* Perform our download *)
	downloadPackets = Quiet[
		Download[
			samples,
			{
				Packet[CrystallizationImagingLog],
				Packet[CrystallizationImagingLog[[All, 2]][{VisibleLightImageFile, CrossPolarizedImageFile, UVImageFile}]]
			}
		],
		{Download::FieldDoesntExist, Download::NotLinkField}
	];

	(* Combine the cache *)
	combinedCache = Experiment`Private`FlattenCachePackets[downloadPackets];

	(* Make the fast cache *)
	fastCache = Experiment`Private`makeFastAssocFromCache[combinedCache];

	(* Extract image files and collection dates *)
	parsedData = Flatten@Map[
		Function[{sample},
			Map[
				Module[{appearanceData},
					appearanceData = #[[2]];
					<|
						Sample -> sample,
						Date -> #[[1]],
						VisibleLightImaging -> Download[Experiment`Private`fastAssocLookup[fastCache, appearanceData, VisibleLightImageFile], Object],
						CrossPolarizedImaging -> Download[Experiment`Private`fastAssocLookup[fastCache, appearanceData, CrossPolarizedImageFile], Object],
						UVImaging -> Download[Experiment`Private`fastAssocLookup[fastCache, appearanceData, UVImageFile], Object]
					|>
				]&,
				Experiment`Private`fastAssocLookup[fastCache, sample, CrystallizationImagingLog]
				]
		],
		samples
	];

	(* Extract non Null keys from parsedData *)
	nonNullHeadings = If[MatchQ[parsedData, {}],
		{},
		{Sample, Date, VisibleLightImaging, CrossPolarizedImaging, UVImaging}
	];

	(*Convert headings to a list of string*)
	stringHeadings = ToString[#]& /@ nonNullHeadings;

	(*Tabulate the data*)
	tabulatedData = Map[
		Function[{dataPoint},
			Flatten[
				Map[
					If[MatchQ[#, Date|Sample],
						Lookup[dataPoint, #],
						If[MatchQ[Lookup[dataPoint, #], Null],
							Null,
							ImageResize[ImportCloudFile[Lookup[dataPoint, #]], plotOption]
						]
					]&,
					nonNullHeadings
				]
			]
		],
		parsedData
	];

	(* Call PlotTable *)
	plot = If[!MatchQ[tabulatedData, {}],
		PlotTable[tabulatedData, TableHeadings -> {None, stringHeadings}, Alignment -> Center],
		Null
	];

	(* Return the requested outputs *)
	output /. {
		Result -> plot,
		Options -> {ImageSize -> plotOption},
		Preview -> plot /. If[MemberQ[originalOps, ImageSize -> _], {}, {Rule[ImageSize, _] :> Rule[ImageSize, Full]}],
		Tests -> {}
	}
];
