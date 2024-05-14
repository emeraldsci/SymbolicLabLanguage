(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Usage[ExportqPCR]:={
	Definition->{
		{"ExportqPCR[processObj]","assayFile","uses information found in the 'processObj' to create a TSV file that can be imported into the qPCR machine software as a plate template."},
		{"ExportqPCR[{{targetName,sampleName,reporter,quencher}->wells..}]","assayFile","uses raw input to create a TSV file that can be imported into the qPCR machine software as a plate template."}
	},
	MoreInformation->{"The second defintion above (the raw input definition) will become private after protocol[FluorescenceThermodynamics] and ExperimentFluorescenceThermodynamics are updated."},
	Input:>{
		{"processObj",SLLInfoP[protocol[qPCR]]|SLLObjectP[protocol[qPCR]]|SLLInfoP[protocol[FluorescenceThermodynamics]]|SLLObjectP[protocol[FluorescenceThermodynamics]],"The protocol object for which a plate set up file will be generated."},
		{"targetName",_String,"The name of the target being detected by qPCR."},
		{"sampleName",(_?NumericQ|_String),"The name of the sample being run in the qPCR assay."},
		{"reporter",ReporterP,"The fluorophore reporter used in the qPCR assay."},
		{"quencher",QuencherP,"The fluorescence quencher being used in the qPCR assay."},
		{"wells",{WellP..},"The wells in the plate containing this qPCR sample."}
	},
	Output:>{
		{"assayFile",_String|{{(_String|_Integer)..}..},"When Export is set to True, the function will return the assay file name.  When Export is set to False, the function will return a list of list of strings."}
	},
	Options:>{
		{Export, BooleanP, True, "If Export->True, the assay file will be exported; if Export->False, a string of the assay file will be outputted.  If Inform is set to True, the assay file will be exported no matter what the value of Export."},
		{FileName,(Automatic|_String),Automatic,"Sets the file name for the plate setup file."}
	},
	SeeAlso:>{ExperimentqPCR,ExportWestern},
	Author->{"cheri","Catherine","Collin","frezza"}
};


(* ::Section::Closed:: *)
(*Begin Private*)


Begin["`Private`"];


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*CompileqPCR*)


(* ::Subsubsection:: *)
(*CompileqPCR*)


(* ::Subsubsection::Closed:: *)
(*ExportqPCR*)


Options[ExportqPCR]=OptionDefaults[ExportqPCR];

(* --- CORE FUNCTION --- *)
(* to become private once ExperimentFluorescenceThermodynamics is updated *)
(*sampleInfo:{Rule[{targetName_String,sampleName:(_?NumericQ|_String),reporter_String,quencher_String},{WellP..}]..}*)
ExportqPCR[sampleInfo:{Rule[{_String,(_?NumericQ|_String),_String,_String},{WellP..}]..},opts:OptionsPattern[ExportqPCR]] :=
		Module[
			{defaultedOptions,sampleRules,header,footer, wells,columnNames,defaultPlateSetupParameters,fileOut,filename},

		(* default the options *)
			defaultedOptions = SafeOptions[ExportqPCR,opts];

			(* parse the input list so that it is now a list of rules that can easily be put into the format for the final file *)
			sampleRules = Flatten[Map[
				Table[{
					Rule["Well",ConvertWell[#[[2,i]],InputFormat->Position,OutputFormat->Index,Model->modelContainer[18,Plate]]],
					Rule["Sample Name",#[[1,2]]],
					Rule["Reporter",ToString[#[[1,3]]]],
					Rule["Quencher",ToString[#[[1,4]]]],
					Rule["Target Name",ToString[#[[1,1]]]]
				},{i,1,Length[#[[2]]]}
				]&,
				sampleInfo],1];

			(* create the footer for the file *)
			footer =  {{"\n"}};

			(* get the list of column names for the header of the file *)
			columnNames = {
				"Well",
				"Well Position",
				"Sample Name",
				"Sample Color",
				"Biogroup Name",
				"Biogroup Color",
				"Target Name",
				"Target Color",
				"Task",
				"Reporter",
				"Quencher",
				"Quantity",
				"Comments"
			};

			(* create the header for the file *)
			header = {
				{"[Sample Setup]"},
				columnNames
			};

			(* assign the defaults to be filled into the file *)
			defaultPlateSetupParameters = {
				"Well Position"->"Well Position",
				"Sample Color" -> "\"RGB(0,0,255)\"",
				"Biogroup Name" -> "",
				"Biogroup Color"-> "",
				"Target Color" -> "\"RGB(98,25,0)\"",
				"Task" -> "UNKNOWN",
				"Quantity" -> "",
				"Comments" -> ""
			};

			(* make the body of the final file by subbing in the list of user provided information and defaults *)
			wells = Table[columnNames/.sampleRules[[well]]/.defaultPlateSetupParameters, {well, 1, Length[sampleRules], 1}];

			(* combine the header, body, and footer of the file *)
			fileOut = Join[header, wells, footer];

			(* figure out the file name *)
			filename = If[MatchQ[FileName/.defaultedOptions,Automatic],
				DateString[]<>"_qPCR",
				FileName/.defaultedOptions
			];

			(* export if we're exporting *)
			If[OptionValue[Export],
				Export[StringTrim[$PublicPath<>"Data\\qPCR\\PlateSetupFiles\\"<>StringReplace[filename,{"[","]",", ",",",":"}->"_"],".txt"]<>".txt", fileOut, "TSV"],
				fileOut
			]
		];


(* --- error messages --- *)
ExportqPCR[processObject:(SLLObjectP[protocol[qPCR]]|SLLObjectP[protocol[FluorescenceThermodynamics]]),opts:OptionsPattern[ExportqPCR]]:=
		Message[Generic::DatabaseFail,ExportWestern,processObject]/;!DatabaseMemberQ[processObject];


(* --- SLLified[protocol[qPCR]] --- *)
ExportqPCR[processObject:(SLLInfoP[protocol[qPCR]]|SLLInfoP[protocol[FluorescenceThermodynamics]]),opts:OptionsPattern[ExportqPCR]] := Module[
	{defaultedOptions,protocolOptions,reactionNames,targetNames,reporter,quencher,gatheredReactions,sampleRules,filename},

(* default the options *)
	defaultedOptions = SafeOptions[ExportqPCR,opts];

	(* pull the protocol options out of the protocol object *)
	protocolOptions = ResolvedOptions/.processObject;

	(* pull out the reaction names, target names, reporter, and quencher from the protocol options *)
	reactionNames = ThreadRule[ReactionNames/.protocolOptions];
	targetNames = If[MatchQ[processObject,SLLInfoP[protocol[qPCR]]],
		ThreadRule[TargetNames/.protocolOptions],
		reactionNames
	];
	reporter = Reporter/.protocolOptions;
	quencher = Quencher/.protocolOptions;

	(* gather the reaction names and target names by their destination wells *)
	gatheredReactions = Gather[Join[reactionNames,targetNames],MatchQ[#1[[2]],#2[[2]]]&];

	(* arrange the assay file information into a list of rules for each field *)
	sampleRules = Map[Rule[{#[[1,1]],#[[2,1]],reporter,quencher},{#[[1,2]]}]&,gatheredReactions];

	(* handle the automatic file name option *)
	filename = If[MatchQ[FileName/.defaultedOptions,Automatic],
		ToString[(Object/.processObject)],
		FileName/.defaultedOptions
	];

	(* pass to core function *)
	ExportqPCR[sampleRules,FileName->filename,Sequence@@defaultedOptions]

];

(* --- SLLObjectP --- *)
ExportqPCR[processObject:(SLLObjectP[protocol[qPCR]]|SLLObjectP[protocol[FluorescenceThermodynamics]]),opts:OptionsPattern[ExportqPCR]]:=
		ExportqPCR[Info[processObject],opts];

(* --- Listable --- *)
ExportqPCR[processObject:{((SLLObjectP[protocol[qPCR]]|SLLObjectP[protocol[FluorescenceThermodynamics]])|(SLLInfoP[protocol[qPCR]]|SLLInfoP[protocol[FluorescenceThermodynamics]]))..},opts:OptionsPattern[ExportqPCR]]:=
		ExportqPCR[#,opts]&/@processObject;


(* ::Section::Closed:: *)
(*End Private*)
