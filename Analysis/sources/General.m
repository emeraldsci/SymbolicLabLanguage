(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(*Source Code*)


(* ::Subsection:: *)
(*Absorbance*)


(* ::Subsubsection::Closed:: *)
(*helper and resolutions*)


Absorbance::WavelengthLowerBoundError="The provided minimum wavelength, `1`, is lower than the lowest wavelength in the given spectrum (`2`). Please ensure that the requested wavelength range is contained within the provided spectrum.";
Absorbance::WavelengthUpperBoundError="The provided maximum wavelength, `1`, is higher than the highest wavelength in the given spectrum (`2`). Please ensure that the requested wavelength range is contained within the provided spectrum.";
Absorbance::InvalidBlankOption="The provided blank option of length `1` does not match the length of the absorbance spectra input (`2`). These lists must match in length in order to properly associate each spectra with its blank (or, provide a single blank to apply to all of the spectra).";
Absorbance::InvalidAbsorbance="The provided absorbance spectrum or wavelength is invalid. Please ensure that the correct data format is provided.";
Absorbance::ListedBlankWithSingleInput="The Blank option was set to a list, but only one input spectrum was provided. Please provide either one blank with one input spectrum, or multiple input spectra with multiple blank spectra.";
Absorbance::WavelengthMismatch="The provided minimum wavelength, `1`, is larger than the max wavelength, `2`.";


absorbanceInputSingleP = Alternatives[
	CoordinatesP,
	{{_?DistanceQ,_?AbsorbanceQ}..},
	QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}],
	ObjectP[Object[Data, AbsorbanceSpectroscopy]]
];


resolveAbsorbanceInput[inList_List]:= Module[
	{downloadList, rule},
	downloadList = Cases[inList, ObjectReferenceP[Object[Data, AbsorbanceSpectroscopy]] | LinkP[Object[Data, AbsorbanceSpectroscopy]]];
	rule = AssociationThread[downloadList, Download[downloadList, AbsorbanceSpectrum]];
	Map[preprocessOneInput, inList/.rule]
];


preprocessOneInput[absSpec:Null]:= Null;
preprocessOneInput[absSpec:CoordinatesP]:= absSpec;
preprocessOneInput[absSpec:({{_?DistanceQ,_?AbsorbanceQ}..} | QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}])]:= Unitless[absSpec,{Nano Meter, AbsorbanceUnit}];
preprocessOneInput[absSpec:PacketP[Object[Data, AbsorbanceSpectroscopy]]]:= Unitless[AbsorbanceSpectrum/.absSpec];


diffAbsorbance[absA_, absB_]:= If[
	MatchQ[absA,$Failed] || MatchQ[absB,$Failed],
	$Failed,
	(absA - absB)*AbsorbanceUnit
];


(* ::Subsubsection::Closed:: *)
(*main functions*)


(* CORE DEFINITION! Takes in a raw set of coordinates and a wavelength range (min, max) *)
absorbanceCore[absorbanceSpectrum:CoordinatesP, waveLength:(_?NumericQ | _Span)]:= Module[
	{minWavelength, maxWavelength, analyteInterpolation, res},

	(* deal with a numeric value or a span *)
	If[MatchQ[waveLength, _?NumericQ],
		minWavelength = waveLength; maxWavelength = waveLength,
		minWavelength = First[waveLength]; maxWavelength = Last[waveLength]
	];

	(* check if the span is valid *)
	If[minWavelength > maxWavelength,
		Message[Absorbance::WavelengthMismatch,minWavelength,maxWavelength];
		Return[$Failed]
	];

	(* make sure the range is actually present in the input coordinate *)
	If[minWavelength < Min[absorbanceSpectrum[[All,1]]],
		Message[Absorbance::WavelengthLowerBoundError,minWavelength*Nano Meter,Min[absorbanceSpectrum[[All,1]]]*Nano Meter];
		Return[$Failed]
	];
	If[maxWavelength > Max[absorbanceSpectrum[[All,1]]],
		Message[Absorbance::WavelengthUpperBoundError,maxWavelength*Nano Meter,Max[absorbanceSpectrum[[All,1]]]*Nano Meter];
		Return[$Failed]
	];

	(* make interpolating functions for the spectrum *)
	analyteInterpolation = Quiet[Interpolation[absorbanceSpectrum]];

	(* pull the absorbance points out of the spectra *)
	res = analyteInterpolation[Range[minWavelength, maxWavelength]];

	If[Length[res]==1,
		First[res],
		res
	]
];


Absorbance[absorbanceSpectrum:CoordinatesP, waveLength:(_?NumericQ | _Span), Null]:= Module[
	{res},
	res = absorbanceCore[absorbanceSpectrum, waveLength];

	If[MatchQ[res, $Failed],
		$Failed,
		res*AbsorbanceUnit
	]
];


Absorbance[absorbanceSpectrum:CoordinatesP, waveLength:(_?NumericQ | _Span), blank: absorbanceInputSingleP]:= diffAbsorbance[absorbanceCore[absorbanceSpectrum, waveLength], absorbanceCore[blank, waveLength]];


Absorbance[in:absorbanceInputSingleP, waveLength:(_?DistanceQ | (_?DistanceQ ;; _?DistanceQ))]:= First[Absorbance[{in}, waveLength, {Null}]];


Absorbance[in:absorbanceInputSingleP, waveLength:(_?DistanceQ | (_?DistanceQ ;; _?DistanceQ)), blank: (absorbanceInputSingleP | Null) ]:= First[Absorbance[{in}, waveLength, {blank}]];


Absorbance[inList:{absorbanceInputSingleP..}, waveLength:(_?DistanceQ | (_?DistanceQ ;; _?DistanceQ)), blank: {(absorbanceInputSingleP | Null)..}]:= Module[
	{minWavelength, maxWavelength, resList, waveLengthUnitless},

	(* make sure the length of blank matches absorbanceSpectra *)
	If[!SameLengthQ[blank, inList],
		Message[Absorbance::InvalidBlankOption,Length[blank],Length[inList]];
		Return[$Failed]
	];

	resList = resolveAbsorbanceInput[Join[inList, blank]];

	(* strip units off of wavelengths *)
	If[MatchQ[waveLength, _?DistanceQ],
		waveLengthUnitless = Unitless[waveLength, Nano Meter],
		waveLengthUnitless = Unitless[First[waveLength], Nano Meter] ;; Unitless[Last[waveLength], Nano Meter]
	];

	MapThread[Absorbance[#1, waveLengthUnitless, #2]&, Partition[resList, Length[resList]/2]]
];


Absorbance[inList:{absorbanceInputSingleP..}, waveLength:(_?DistanceQ | (_?DistanceQ ;; _?DistanceQ))]:= Absorbance[inList, waveLength, Table[Null, Length[inList]]];


(* All other cases *)
Absorbance[in:absorbanceInputSingleP, ___, blank: {(absorbanceInputSingleP | Null)..}]:=(
	Message[Absorbance::ListedBlankWithSingleInput];
	Return[$Failed]
);

(* ::Subsection::Closed:: *)
(*Concentration*)


(* ::Subsubsection::Closed:: *)
(*helper and resolutions*)


Concentration::MismatchedInputLengths="The provided inputs do not match in length and therefore cannot be properly associated for concentration calculation. `1` absorbances, `2` path lengths, and `3` extinction coefficients were provided.";


extinctionCoefficientP = Alternatives[
	ExtinctionCoefficientP,
	MassExtinctionCoefficientP,
	SequenceP,
	StrandP,
	ObjectP[Object[Sample]]
];


resolveExtCoefInput[inList_List]:= Module[
	{downloadList, rule},
	downloadList = Cases[inList, ObjectP[Object[Sample]]];
	rule = AssociationThread[downloadList, Flatten[Download[downloadList, ExtinctionCoefficient]]];
	inList/.rule
];


(* ::Subsubsection:: *)
(*main functions*)


(* CORE FUNCTION, takes an absorbance, path length, and extinction coefficient, and calculates concentration *)
Concentration[absorbance_?AbsorbanceQ, pathLength_?DistanceQ, extinctionCoefficient:extinctionCoefficientP]:= Module[
	{resolvedExtinctionCoefficient, concentration},

	(* resolve the extinction coefficient *)
	resolvedExtinctionCoefficient = Switch[extinctionCoefficient,
		(_?ExtinctionCoefficientQ|_?MassExtinctionCoefficientQ),
			extinctionCoefficient,
		(_?SequenceQ|_?StrandQ|ObjectP[Object[Sample]]),
			ExtinctionCoefficient[extinctionCoefficient]
	];

	(* solve Beer's law to determine the concentration *)
	concentration = Unitless[absorbance, AbsorbanceUnit]/(pathLength*resolvedExtinctionCoefficient);

	If[MatchQ[resolvedExtinctionCoefficient, _?ExtinctionCoefficientQ],
		UnitConvert[concentration, Molar],
		UnitConvert[concentration, (Gram/Liter)]
	]

];


Concentration[absorbances:{_?AbsorbanceQ..},pathLengths:{_?DistanceQ..},extinctionCoefficients:{extinctionCoefficientP..}]:=Module[
	{extCoefList},

	(* make sure the inputs are all the same length *)
	If[!SameLengthQ[absorbances, pathLengths, extinctionCoefficients],
		Message[Concentration::MismatchedInputLengths,Length[absorbances],Length[pathLengths],Length[extinctionCoefficients]];
		Return[$Failed]
	];

	extCoefList = resolveExtCoefInput[extinctionCoefficients];

	MapThread[
		Concentration[#1, #2, #3]&,
		{absorbances, pathLengths, extCoefList}
	]
];


(* ::Subsection:: *)
(*PathLength*)


(* ::Subsubsection:: *)
(*helper and resolutions*)


DefineOptions[PathLength,
	Options :> {
		{MinRamanScattering -> 960 Nanometer, GreaterP[0 Nanometer], "The minimum raman scattering distance where the calibrations are being done."},
		{MaxRamanScattering -> 980 Nanometer, GreaterP[0 Nanometer], "The maximum raman scattering distance where the calibrations are being done."}
	}
];


PathLength::BlankSmallerThanSample="The provided blank distance, `1`, is smaller than the provided sample distance, `2`. As path length is being determined assuming an above-sample reference point, the blank distance is expected to be larger than the sample distance.";
PathLength::MismatchedEmptyAndSampleLenghts="`1` empty absorbance data objects were provided, and `2` sample absorbance objects. These lists must match in length in order for blanking and path length calculation to proceed properly.";
PathLength::NonLinearPathLengthFit="The provided volume calibration object, `1`, contains a fit that is non-linear and not suitable for inversion to create a volume-to-pathlength fit. Please provide a calibration with a linear fit function.";


resolveObjInput[inList_List]:= With[
	{
		downloadList = Quiet[
			Download[inList, {AbsorbanceSpectrum, CalibrationFunction}],
			{Download::FieldDoesntExist}
		]
	},

	{First/@Most[downloadList], Last[Last[downloadList]]}
];


(* ::Subsubsection:: *)
(*main functions*)


PathLength[blankDistance_?DistanceQ, sampleDistance_?DistanceQ, ops: OptionsPattern[]]:= Module[
	{},

	(* warn if the provided blank is smaller than the sample distance *)
	If[blankDistance < sampleDistance,
		Message[PathLength::BlankSmallerThanSample,blankDistance,sampleDistance]
	];

	(* return the blanked path length in milli meters *)
	Convert[(blankDistance - sampleDistance),Centi Meter]
];


(* overload to handle direct volume input *)
PathLength[volume_?VolumeQ, volumeCalibration:ObjectP[Object[Calibration, Volume]], ops: OptionsPattern[]]:= Module[
	{pathLengthToVolumeFunction, volumeToPathLengthFunction, volumeUnitless},

	(* pull out the fit *)
	pathLengthToVolumeFunction = Download[volumeCalibration, CalibrationFunction];

	(* return if it's not linear (we can't reliably invert it if so) *)
	If[!LinearFunctionQ[pathLengthToVolumeFunction],
		Message[PathLength::NonLinearPathLengthFit,volumeCalibration];
		Return[$Failed]
	];

	volumeToPathLengthFunction = InverseFunction[pathLengthToVolumeFunction];

	(* apply this function to the provided volume, which should definitely be Unitless->Micro Liter *)
	volumeUnitless = Unitless[volume, Micro Liter];

	With[{pathLen = volumeToPathLengthFunction[volumeUnitless]},
		Switch[pathLen,
			_Integer, Convert[pathLen*Milli Meter,Centi Meter],
			_Quantity, Convert[Unitless[pathLen]*Milli Meter,Centi Meter]
		]
	]

];


(* Core function, takes Quantity Arrays and a Pure Function *)
PathLength[emptyAbsorbanceData:QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}], sampleAbsorbanceData:QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}], absToPathLenFunc:_?LinearFunctionQ, ops: OptionsPattern[]]:= Module[
	{safeOptions, ramanAbsorbance, ramanAbsorbanceUnitless},

	safeOptions = SafeOptions[PathLength, ToList[ops]];

	(* pull out the absorbance in the raman range where the calibrations are being done *)
	ramanAbsorbance = Mean[Absorbance[sampleAbsorbanceData, (MinRamanScattering/.safeOptions) ;; (MaxRamanScattering/.safeOptions), emptyAbsorbanceData]];

	ramanAbsorbanceUnitless = Unitless[ramanAbsorbance, AbsorbanceUnit];

	Convert[absToPathLenFunc[ramanAbsorbanceUnitless]*Milli Meter, Centi Meter]

];


PathLength[emptyAbsorbanceData:{QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}]..}, sampleAbsorbanceData:{QuantityCoordinatesP[{Nanometer,AbsorbanceUnit}]..}, absToPathLenFunc:_?LinearFunctionQ,ops: OptionsPattern[]]:=
	MapThread[PathLength[#1, #2, absToPathLenFunc, ops]&, {emptyAbsorbanceData, sampleAbsorbanceData}];


(* overload to take an empty and sample abs spec data objects *)
PathLength[emptyAbsorbanceData:ObjectP[Object[Data, AbsorbanceSpectroscopy]], sampleAbsorbanceData:ObjectP[Object[Data, AbsorbanceSpectroscopy]], pathLengthCalibration:ObjectP[Object[Calibration, PathLength]],ops: OptionsPattern[]]:=
	First[PathLength[{emptyAbsorbanceData}, {sampleAbsorbanceData}, pathLengthCalibration, ops]];


PathLength[emptyAbsorbanceList:{ObjectP[Object[Data, AbsorbanceSpectroscopy]]..}, sampleAbsorbanceList:{ObjectP[Object[Data, AbsorbanceSpectroscopy]]..}, pathLengthCalibration:ObjectP[Object[Calibration, PathLength]],ops: OptionsPattern[]]:=Module[
	{resList, absToPathLenFunc, resAbsList, ramanAbsorbance, ramanAbsorbanceUnitless},

	(* return if the two lists aren't the same length *)
	If[!SameLengthQ[emptyAbsorbanceList, sampleAbsorbanceList],
		Message[PathLength::MismatchedEmptyAndSampleLenghts,Length[emptyAbsorbanceList],Length[sampleAbsorbanceList]];
		Return[$Failed]
	];

	(* resolve objects by one download *)
	resList = resolveObjInput[Flatten[{emptyAbsorbanceList, sampleAbsorbanceList, pathLengthCalibration}]];

	absToPathLenFunc = Last[resList];
	resAbsList = Partition[First[resList], Length[First[resList]]/2];

	MapThread[
		PathLength[#1, #2, absToPathLenFunc, ops]&,
		{First[resAbsList], Last[resAbsList]}
	]
];


(* ::Subsection:: *)
(*SequenceAlignmentTable*)


(* ::Subsubsection:: *)
(*Options*)

seqAlignInputP=Alternatives[
	_String,
	SequenceP,
	ObjectP[{Object[Analysis,DNASequencing],Object[Data,DNASequencing]}]
];


(* ::Subsubsection:: *)
(*Options*)

DefineOptions[SequenceAlignmentTable,
	Options:>{
		{
			OptionName->GapPenalty,
			Default->0,
			Description->"The additional cost for each continuous alignment gap. Increasing GapPenalty will result in sequence alignments with fewer gaps, but may result in fewer overall matches.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[0,1]]
		},
		{
			OptionName->Method,
			Default->NeedlemanWunsch,
			Description->"The algorithm to use for sequence alignment. NeedlemanWunsch produces a global alignment, and SmithWaterman produces a local alignment.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>NeedlemanWunsch|SmithWaterman]
		},
		{
			OptionName->SimilarityRules,
			Default->Automatic,
			Description->"Defines a set of rules by which sequence alignment should be scored. See the documentation page ?SimilarityRules for more detailed information.",
			AllowNull->False,
			Widget->Alternatives[
				"Preset"->Widget[Type->Enumeration,Pattern:>Alternatives[
					Automatic,
					"BLAST",
					"BLOSUM62",
					"BLOSUM80",
					"PAM30",
					"PAM70",
					"PAM250"
				]],
				"Patterns"->Widget[Type->Expression,Pattern:>{_Rule..},Size->Paragraph]
			]
		},
		{
			OptionName->PreviewLineWidth,
			Default->60,
			Description->"Number of characters to show per line in the sequence alignment preview.",
			AllowNull->False,
			Widget->Widget[Type->Number,Pattern:>GreaterEqualP[5,1]]
		},
		{
			OptionName->OutputFormat,
			Default->Table,
			Description->"Specify if the alignment summary should be displayed as a table or a list of rules.",
			AllowNull->False,
			Widget->Widget[Type->Enumeration,Pattern:>Table|List]
		}
  }
];


(* ::Subsubsection::Closed:: *)
(*Messages and Errors*)

Error::InvalidInputSequence="Inputs `1` could not be resolved into sequence string(s). Please ensure that oligomer sequences match SequenceP, and/or that the SequencingAssignment field is not empty for DNASequencing objects.";


(* ::Subsubsection::Closed:: *)
(*Main Function*)

SequenceAlignmentTable[seq1:seqAlignInputP,seq2:seqAlignInputP,ops:OptionsPattern[SequenceAlignmentTable]]:=Module[
	{
		resolvedSeq1,resolvedSeq2,resolvedOps,mmOps,seqAlignResult,
		seqPreview,numGaps,seqIdentity,alignedLength
	},

	(* Convert all input types into simple strings *)
	{resolvedSeq1,resolvedSeq2}=resolveSequenceAlignmentInputs[{seq1,seq2}];

	(* Return a fail state if either of the sequences failed to resolve *)
	If[!(MatchQ[resolvedSeq1,_String]&&MatchQ[resolvedSeq2,_String]),
		Return[$Failed];
	];

	(* Options to pass to the MM SequenceAlignment function  *)
	resolvedOps=ReplaceRule[
		SafeOptions[SequenceAlignmentTable,ToList[ops],AutoCorrect->False],
		MergeDifferences->False
	];

	(* Reformat some options to match MM format expectation *)
	mmOps=resolvedOps/.{
		NeedlemanWunsch->"Global",
		SmithWaterman->"Local"
	};

	(* Call the MM SequenceAlignment function *)
	seqAlignResult=SequenceAlignment[
		resolvedSeq1,
		resolvedSeq2,
		PassOptions[SequenceAlignmentTable,SequenceAlignment,mmOps]
	];

	(* Length of the aligned sequences, including gaps *)
	alignedLength=Total@Replace[seqAlignResult,
		{s:_String:>StringLength[s],slist:{_String..}:>Max[StringLength/@slist]},
		1
	];

	(* Calculate the number of gaps *)
	numGaps=Total[Flatten@Cases[seqAlignResult,
		gap:_List?(MemberQ[#,""]&):>StringLength/@DeleteCases[gap, ""],1]
	];

	(* Calculate sequence identity *)
	seqIdentity=Total@Cases[seqAlignResult,match_String:>StringLength[match]];

	(* Generate an ASCII graphical preview of the alignment *)
	seqPreview=sequenceAlignmentGraphic[seqAlignResult,resolvedOps];

	(* List of outputs generated *)
	seqInfo={
		AlignedSequenceLength->alignedLength,
		Method->Lookup[resolvedOps,Method],
		GapPenalty->Lookup[resolvedOps,GapPenalty],
		SequenceIdentity->seqIdentity/alignedLength,
		PercentIdentity->RoundReals[seqIdentity/alignedLength*100.0,3]*Percent,
		GapCount->numGaps,
		GapPercentage->RoundReals[numGaps/alignedLength*100.0,3]*Percent,
		Preview->seqPreview
	};

	(* Return requested output according to output format *)
	If[MatchQ[Lookup[resolvedOps,OutputFormat],Table],
		alignmentResultsTable[seqInfo],
		seqInfo
	]
];

(* Convert the different supported input types into string representations *)
resolveSequenceAlignmentInputs[seqs:{seqAlignInputP..}]:=Module[
	{resolvedSeqs,failPos},

	(* Resolve based on input type *)
	resolvedSeqs=Map[
		Switch[#,
			(* String means we're done already *)
			_String,#,
			(* SequenceP *)
			PolymerP[_String],First[#],
			(* DNASequencing Data *)
			ObjectP[Object[Data,DNASequencing]],Download[#,SequencingAssignments[[-1]]],
			(* DNASequencing Analysis *)
			ObjectP[Object[Analysis,DNASequencing]],Download[#,SequenceAssignment],
			(* If the above cases didn't catch anything, resolution fails *)
			_,$Failed
		]&,
		seqs
	];

	(* Positions of inputs which failed to resolve *)
	failPos=Flatten@Position[resolvedSeqs,$Failed|Null,{1}];

	(* Error message if inputs did not resolve *)
	If[Length[failPos]>0,
		Message[Error::InvalidInputSequence,Flatten@Part[seqs,failPos]];
	];

	(* Return the resolved sequences *)
	resolvedSeqs
];


(* Generate a graphical preview of sequence alignment *)
sequenceAlignmentGraphic[aligns:{(_String|{_String,_String})..},resolvedOps:{_Rule..}]:=Module[
	{
		pitchWidth,leftChars,rightChars,leftString,rightString,
		leftByLine,rightByLine,leftCounts,rightCounts,leftCountLabels,rightCountLabels,
		leftCounters,rightCounters,maxDigits,formattedStrings
	},

	(* Width of sequence before line break *)
	pitchWidth=Lookup[resolvedOps,PreviewLineWidth,60];

	(* Initialize empty lists to reconstruct the alignment *)
	leftChars={};
	rightChars={};

	(* Parse the alignment output to populate the two strings *)
	Map[
		Switch[#,
			(* Aligned *)
			_String,
				(
					leftChars=Append[leftChars,#];
					rightChars=Append[rightChars,#];
				),
			(* Insertion *)
			{Null,_String},
				(
					leftChars=Append[leftChars,StringRepeat["-",StringLength[Last@#]]];
					rightChars=Append[rightChars,Last@#];
				),
			(* Deletion *)
			{_String,Null},
				(
					leftChars=Append[leftChars,First@#];
					rightChars=Append[rightChars,StringRepeat["-",StringLength[First@#]]];
				),
			(* Substitution *)
			{_String,_String},
				With[{alignedLength=Max[StringLength/@#]},
					leftChars=Append[leftChars,StringPadRight[First@#,alignedLength,"-"]];
					rightChars=Append[rightChars,StringPadRight[Last@#,alignedLength,"-"]];
				],
			(* Catch-all *)
			_,Null
		]&,
		aligns/.{""->Null}
	];

	(* Join the listed characters together, then split them into character lists  *)
	leftString=StringSplit[StringJoin[leftChars],""];
	rightString=StringSplit[StringJoin[rightChars],""];

	(* Split the character lists into lines for processing *)
	leftByLine=Partition[leftString,UpTo[pitchWidth]];
	rightByLine=Partition[rightString,UpTo[pitchWidth]];

	(* Cumulative counts for numbering *)
	leftCounts=Accumulate[Length[Cases[#,Except["-"]]]&/@leftByLine];
	rightCounts=Accumulate[Length[Cases[#,Except["-"]]]&/@rightByLine];

	(* The left and right counters for each *)
	leftCounters={Min[First[#]+1,Last[#]],Last[#]}&/@Partition[Prepend[leftCounts,0],2,1];
	rightCounters={Min[First[#]+1,Last[#]],Last[#]}&/@Partition[Prepend[rightCounts,0],2,1];

	(* Maximum number of digits in the counters *)
	maxDigits=Ceiling[Log10[Max[Flatten@{leftCounters,rightCounters}]]];

	(* Make padded strings for number labels *)
	leftCountLabels={
		PadLeft[StringSplit[ToString@First[#],""],maxDigits," "],
		PadRight[StringSplit[ToString@Last[#],""],maxDigits," "]
	}&/@leftCounters;
	rightCountLabels={
		PadLeft[StringSplit[ToString@First[#],""],maxDigits," "],
		PadRight[StringSplit[ToString@Last[#],""],maxDigits," "]
	}&/@rightCounters;

	(* Format the strings *)
	formattedStrings=MapThread[
		Module[{centerChars},
			(* Start a list to handle cross strings *)
			centerChars={};

			(* Update the strings *)
			MapThread[
				Function[{l,r},
					Which[
						l=="-"||r=="-",centerChars=Append[centerChars," "],
						l==r,centerChars=Append[centerChars,"|"],
						l!=r,centerChars=Append[centerChars,"*"]
					]
				],
				{#1,#2}
			];

			(* Add count labels and whitespace *)
			Grid[
				{
					Join[First[#3],{" "," "},#1,{" "," "},Last[#3]],
					Join[Repeat[" ",maxDigits+2],centerChars,Repeat[" ",maxDigits+2]],
					Join[First[#4],{" "," "},#2,{" "," "},Last[#4]]
				},
				Spacings->{0.1,0.2}
			]
		]&,
		{leftByLine,rightByLine,leftCountLabels,rightCountLabels}
	];

	Column[formattedStrings,Spacings->2]
];

(* Generate a grid preview of the alignment results *)
alignmentResultsTable[alignResults:{_Rule..}]:=Module[
	{alignLength,alignString,gapString},

	(* Length of aligned strings *)
	alignLength=Lookup[alignResults,AlignedSequenceLength];

	(* Format alignment string *)
	alignString=StringJoin[
		ToString@Round[alignLength*Lookup[alignResults,SequenceIdentity]]<>"/"<>ToString@alignLength,
		" ("<>StringReplace[ToString@Lookup[alignResults,PercentIdentity]," percent"->"%"]<>")"
	];

	(* Format gap string *)
	gapString=StringJoin[
		ToString@Lookup[alignResults,GapCount]<>"/"<>ToString@alignLength,
		" ("<>StringReplace[ToString@Lookup[alignResults,GapPercentage]," percent"->"%"]<>")"
	];

	(* Generate the table *)
	PlotTable[
		{
			{Lookup[alignResults,AlignedSequenceLength]},
			{Lookup[alignResults,Method]},
			{Lookup[alignResults,GapPenalty]},
			{alignString},
			{gapString},
			{Lookup[alignResults,Preview]}
		},
		TableHeadings->{
			{
				"Aligned Length",
				"Method",
				"Gap Penalty",
				"Identity",
				"Gaps",
				"Preview"
			},
			None
		},
		Title->"Alignment Summary"
	]
];
