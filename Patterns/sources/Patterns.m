(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Patterns*)


(* ::Subsection::Closed:: *)
(*Protocol patterns*)


(* ::Subsubsection::Closed:: *)
(*Authors*)


ECL`Authors[NullP]:={"hayley"};
ECL`Authors[OptionCategoryP]:={"hayley", "mohamad.zandian"};
ECL`Authors[PlasticP]:={"hayley", "mohamad.zandian"};
ECL`Authors[WellTypeP]:={"hayley", "mohamad.zandian"};
ECL`Authors[WellP]:={"hayley", "mohamad.zandian"};
ECL`Authors[PeptideSynthesisStrategyP]:={"hayley", "mohamad.zandian"};
ECL`Authors[ProtectingGroupP]:={"hayley"};
ECL`Authors[GradeP]:={"hayley"};
ECL`Authors[FocusingElementP]:={"hayley", "mohamad.zandian"};
ECL`Authors[IonModeP]:={"hayley", "mohamad.zandian"};
ECL`Authors[IonSourceP]:={"hayley", "mohamad.zandian"};
ECL`Authors[AcquisitionModeP]:={"hayley", "mohamad.zandian"};
ECL`Authors[NeedleGaugeP]:={"hayley", "mohamad.zandian"};
ECL`Authors[SpottingMethodP]:={"hayley", "mohamad.zandian"};
ECL`Authors[ContextP]:={"hayley"};
ECL`Authors[XmlFileP]:={"hayley", "mohamad.zandian"};
ECL`Authors[irreversibleReactionP]:={"brad"};
ECL`Authors[ReversibleReactionP]:={"brad"};
ECL`Authors[reversibleReactionP]:={"brad"};
ECL`Authors[ReactionP]:={"brad"};
ECL`Authors[BMGCompatiblePlateP]:={"hayley","wyatt"};
ECL`Authors[VisualInspectionBackgroundP]:={"eunbin.go"};
ECL`Authors[SampleInspectorCompatibleVialsP]:={"eunbin.go"};
ECL`Authors[SolidPhaseExtractionTypeP]:={"nont.kosaisawe"};
ECL`Authors[SolidPhaseExtractionFunctionalGroupP]:={"nont.kosaisawe"};
ECL`Authors[SolidPhaseExtractionMethodP]:={"nont.kosaisawe"};
ECL`Authors[MediaPlatingMethodP]:={"eunbin.go"};
ECL`Authors[CoulterCounterApertureDiameterP]:={"lei.tian"};
ECL`Authors[CoulterCounterStopConditionP]:={"lei.tian"};
ECL`Authors[CoulterCounterContainerFootprintP]:={"lei.tian"};
ECL`Authors[BaselineP]:={"lei.tian"};



(* ::Subsubsection::Closed:: *)
(* MagneticBeadSeparationModeP *)

MagneticBeadSeparationModeP=Alternatives[NormalPhase, ReversePhase, IonExchange, Affinity];

(* ::Subsubsection::Closed:: *)
(*SubcellularProteinFractionP*)


SubcellularProteinFractionP=Alternatives[CytosolicProtein,PlasmaMembraneProtein,NuclearProtein];


(* ::Subsubsection::Closed:: *)
(*VisualInspectionBackgroundP*)


VisualInspectionBackgroundP:=Alternatives[Black,White];



(* ::Subsubsection::Closed:: *)
(*SampleInspectorCompatibleVialsP*)


SampleInspectorCompatibleVialsP:=ObjectP[{
	Model[Container, Vessel, "id:R8e1PjpMxGEX"], (*Model[Container, Vessel, "50mL clear glass vial with stopper"]*)
	Model[Container, Vessel, "id:J8AY5jAxB8Ex"], (*Model[Container, Vessel, "50 mL glass serum bottle with crimp seal"]*)
	Model[Container, Vessel, "id:kEJ9mqR67Zn8"], (*Model[Container, Vessel, "2mL clear fiolax type 1 glass vial (CSL)"]*)
	Model[Container, Vessel, "id:J8AY5jDwZwBB"], (*Model[Container, Vessel, "4mL Screw Cap Clear Glass Vial"]*)
	Model[Container, Vessel, "id:6V0npvmW99k1"], (*Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"]*)
	Model[Container, Vessel, "id:dORYzZRnLnlR"](*Model[Container, Vessel, "5oz clear plastic bottle"]*)
}];



(* ::Subsubsection::Closed:: *)
(*PackageStatusP*)


PackageStatusP=Alternatives[Receiving,Available,PickedUp];



(* ::Subsubsection::Closed:: *)
(*PeptideSynthesisStrategyP*)


PeptideSynthesisStrategyP:=Alternatives@@{Fmoc,Boc};



(* ::Subsubsection::Closed:: *)
(*StockSolutionSubtypeP*)


(* Standard is actually a subtype (i.e., Model[Sample, StockSolution, Standard]), which means it needs to be handled slightly differently but it still needs to be in here *)
StockSolutionSubtypeP=Alternatives[StockSolution,Matrix,Media,Standard];



(* ::Subsubsection::Closed:: *)
(*ProtectingGroupP*)


ProtectingGroupP:=Alternatives@@{Fmoc,Boc,DMT,None};



(* ::Subsubsection::Closed:: *)
(*VoteTypeP*)


VoteTypeP=Alternatives[
	Good,
	Clarity,
	Automation,
	Ordering,
	Processing,
	TimeConsuming
];



(* ::Subsubsection::Closed:: *)
(*DensityMethodP*)


DensityMethodP=Alternatives[
	DensityMeter,
	FixedVolumeWeight
];



(* ::Subsubsection::Closed:: *)
(*OsmolalityMethodP*)


OsmolalityMethodP=Alternatives[
	VaporPressureOsmometry
];



(* ::Subsubsection::Closed:: *)
(*OsmolalityModeP*)


OsmolalityModeP=Alternatives[
	Normal,
	ProcessDelay,
	AutoRepeat
];



(* ::Subsubsection::Closed:: *)
(*PNASynthesisVesselTypeP*)


PNASynthesisVesselTypeP = Alternatives[ReactionVessel, PreactivationVessel];



(* ::Subsubsection::Closed:: *)
(*SolventPositionsP*)


SolventPositionsP = Alternatives@@(("SLVT"<>ToString[#])&/@Range[1, 8]);



(* ::Subsubsection::Closed:: *)
(*AminoAcidPositionsP*)


AminoAcidPositionsP = Alternatives@@(("AA"<>ToString[#])&/@Range[1, 28]);



(* ::Subsubsection::Closed:: *)
(*AminoAcidPositionsP*)


PreactivationTypeP = Alternatives[ExSitu,None];



(* ::Subsubsection::Closed:: *)
(*CollectionPositionsP*)


CollectionPositionsP = Alternatives@@((ToExpression["CV"<>ToString[#]])&/@Range[1, 12]);


(* ::Subsubsection::Closed:: *)
(*SymphonyFileTypeP*)


SymphonyFileTypeP = Alternatives[Synthesis, DownloadResin, Cleavage, Solvent, Monomer, Sequence];


(* ::Subsubsection::Closed:: *)
(*SymphonyInstructionTypeP*)


SymphonyInstructionTypeP = Alternatives[
	TopDelivery,
	BottomDelivery,
	MonomerDelivery,
	CleaveCollect,
	CleaveMix,
	Collect,
	DrainDry,
	Mix,
	Pause,
	PVtoRVTransfer
];




(* ::Subsubsection::Closed:: *)
(*TemperatureCurveP*)


TemperatureCurveP = (Melting|Cooling);


(* ::Subsubsection::Closed:: *)
(*SolventBoilingPointP*)


SolventBoilingPointP = Alternatives[Low, Medium, High];



(* ::Subsubsection::Closed:: *)
(*MultipleChoiceAnswerP*)


MultipleChoiceAnswerP = Alternatives[Yes, No, Unclear];



(* ::Subsubsection::Closed:: *)
(*UnitTestFunctionStatusP*)


UnitTestFunctionStatusP=Enqueued|Running|Passed|Failed|Crashed|TimedOut|Aborted|SuiteTimedOut|ManifoldBackendError|MathematicaError;



(* ::Subsubsection::Closed:: *)
(*UnitTestSuiteStatusP*)


UnitTestSuiteStatusP=Enqueued|Running|Completed|Aborted;


(* ::Subsubsection::Closed:: *)
(*CartDockStatusP*)


CartDockStatusP=Alternatives[
	Ready,
	DangerZone,
	Running
];



(* ::Subsubsection::Closed:: *)
(*InstrumentStatusP*)


InstrumentStatusP=Alternatives[
	Running,
	Available,
	UndergoingMaintenance,
	Retired
];



(* ::Subsubsection::Closed:: *)
(*ProtocolStatusP*)


ProtocolStatusP=Alternatives[
	InCart,
	Backlogged,
	ShippingMaterials,
	Processing,
	Completed,
	Aborted,
	Canceled
];



(* ::Subsubsection::Closed:: *)
(*OperationStatusP*)


OperationStatusP=Alternatives[
	None,
	OperatorStart,
	OperatorProcessing,
	InstrumentProcessing,
	OperatorReady,
	Troubleshooting
];


(* ::Subsubsection::Closed:: *)
(*UserOperationStatusP*)


UserOperationStatusP=Alternatives[
	OnShift,
	OffShift,
	OnBreak,
	InProtocol
];


(* ::Subsubsection::Closed:: *)
(*OperatorStatusP*)


OperatorStatusP=Available|Unavailable|DangerZoneOperating|Operating;



(* ::Subsubsection::Closed:: *)
(*ProtocolEventP*)


ProtocolEventP=Alternatives[
	StateChange,
	TaskStart,
	TaskEnd,
	Error,
	TaskReset,
	Enter,
	Exit,
	Branch,
	ProcessingStart,
	ProcessingEnd,
	CheckIn,
	CompletionCheck,
	CheckpointStart,
	CheckpointEnd,
	Vote,
	OperatorStart,
	OperatorEnd,
	TroubleshootingStart,
	TroubleshootingEnd,
	LogFile,
	StashResources,
	SwapOperator
];


(* ::Subsubsection::Closed:: *)
(*FilterTypeP*)


FilterFormatP=Alternatives[Disk, Membrane, BottleTop, Centrifuge, CrossFlowFiltration];


(* ::Subsubsection::Closed:: *)
(*FluidCategoryP*)


FluidCategoryP=Alternatives[Gas,Liquid,Solid, SupercriticalCO2];


(* ::Subsubsection::Closed:: *)
(*ValveShuttingMechanismP*)


ValveShuttingMechanismP=Alternatives[Gate,Butterfly,Needle,Ball,Check,Pinch];



(* ::Subsubsection::Closed:: *)
(*ValveOperationP*)


ValveOperationP=Alternatives[Manual,Solenoid];


(* ::Subsubsection::Closed:: *)
(*ValvePositionP*)


ValvePositionP=Rule[_String,None|{{ConnectorNameP..}..}];


(* ::Subsubsection::Closed:: *)
(*FilterSizeP*)


FilterSizeP=Alternatives[
	(* This corresponds specifically to Waters Oasis SPE consumables and can be moved once these are transferred over to ExperimentSPE *)
	0.008 Micron,

	0.1 Micron,
	0.2 Micron,
	0.22 Micron,
	0.45 Micron,
	1. Micron,
	1.1 Micron,
	2.5 Micron,
	6. Micron,
	20. Micron,
	30. Micron,
	100. Micron
];


(* ::Subsubsection::Closed:: *)
(*FilterMolecularWeightCutoffP*)


FilterMolecularWeightCutoffP=Alternatives[
	3 (Kilo Dalton),
	3. (Kilo Dalton),
	10 (Kilo Dalton),
	10. (Kilo Dalton),
	30 (Kilo Dalton),
	30. (Kilo Dalton),
	40 (Kilo Dalton),
	40. (Kilo Dalton),
	50 (Kilo Dalton),
	50. (Kilo Dalton),
	100 (Kilo Dalton),
	100. (Kilo Dalton),
	300 (Kilo Dalton),
	300. (Kilo Dalton),
	7 (Kilo Dalton),
	Quantity[7., ("Kilograms")/("Moles")],
	40 (Kilo Dalton),
	40. (Kilo Dalton),
	Quantity[30.8328, ("Kilograms")/("Moles")]
];


(* ::Subsubsection::Closed:: *)
(*FilterMembraneMaterialP*)


FilterMembraneMaterialP=(Cellulose|Cotton|Polyethylene|Polypropylene|PTFE|Nylon|PES|PLUS|PVDF|GlassFiber|GHP|UHMWPE|EPDM|DuraporePVDF|GxF|ZebaDesaltingResin|NickelResin|Silica|HLB);



(* ::Subsubsection::Closed:: *)
(*FunnelTypeP*)


FunnelTypeP=Alternatives[Dry,Wet,Filter];


(* ::Subsubsection::Closed:: *)
(*DialysisMolecularWeightCutoffP*)


DialysisMolecularWeightCutoffP=Alternatives[
	3.5 (Kilo Dalton),
	8 (Kilo Dalton),
	10 (Kilo Dalton),
	14 (Kilo Dalton)
];



(* ::Subsubsection::Closed:: *)
(*DialysisMembraneMaterialP*)


DialysisMembraneMaterialP=Alternatives[
	RegeneratedCellulose,
	CelluloseEster,
	Cellulose
	];



(* ::Subsubsection::Closed:: *)
(*DialysisSoakSolutionP*)


DialysisSoakSolutionP=Alternatives[
	Dialysate,
	Water
];



(* ::Subsubsection::Closed:: *)
(*StirBarShapeP*)


StirBarShapeP=Alternatives[
	Circular,
	Octagonal,
	Egg,
	PlusShape
];



(* ::Subsubsection::Closed:: *)
(*SlotShapeP*)


SlotShapeP=Alternatives[
	Circular,
	SquareShape,
	PlusShape
];



(* ::Subsubsection::Closed:: *)
(*DialysisMethodP*)


DialysisMethodP=Alternatives[
	DynamicDialysis,
	StaticDialysis,
	EquilibriumDialysis
];



(* ::Subsubsection::Closed:: *)
(*DialysisMembranePreservativeP*)


DialysisMembranePreservativeP=Alternatives[
	Glycerin,
	SodiumAzide
];



(* ::Subsubsection::Closed:: *)
(*ADSRouteP*)


ADSRouteP::usage="
DEFINITIONS
	ADSRouteP=_String?(StringMatchQ[#1,
	Repeated[DigitCharacter,{1,3}]~~\".\"~~
	Repeated[DigitCharacter,{1,3}]~~\".\"~~
	Repeated[DigitCharacter,{1,3}]~~\".\"~~
	Repeated[DigitCharacter,{1,3}]~~\".\"~~
	Repeated[DigitCharacter,{1,3}]~~\".\"~~
	Repeated[DigitCharacter,{1,3}]]&)
";

ADSRouteP=_String?(StringMatchQ[#1,
	Repeated[DigitCharacter,{1,3}]~~"."~~
	Repeated[DigitCharacter,{1,3}]~~"."~~
	Repeated[DigitCharacter,{1,3}]~~"."~~
	Repeated[DigitCharacter,{1,3}]~~"."~~
	Repeated[DigitCharacter,{1,3}]~~"."~~
	Repeated[DigitCharacter,{1,3}]]&);


(* ::Subsubsection::Closed:: *)
(*NumericBooleanP*)


NumericBooleanP::usage="
DEFINITIONS
		Matches a numeric boolean (1 indicates True, 0 indicates False).
";

NumericBooleanP=Alternatives@@{1,0};



(* ::Subsubsection::Closed:: *)
(*TissueTypeP*)


TissueTypeP::usage="
DEFINITIONS
	(TLymphocyte|Kidney|PeripheralBlood|Liver|Cornea|Colon|Cervix|BLymphocyte|)
		Matches a tissue type from which a cell line may be derived.
";

TissueTypeP=Alternatives@@{TLymphocyte,Kidney,Breast,PeripheralBlood,Liver,Cornea,Colon,Cervix,BLymphocyte};



(* ::Subsubsection::Closed:: *)
(*ViralGenomeP*)


ViralGenomeP::usage="
DEFINITIONS
	(\"dsDNA\"|\"+ssDNA\"|\"dsRNA\"|\"+ssRNA\"|\"-ssRNA\"|\"ssRNA-RT\"|\"dsDNA-RT\")
		Matches a viral genome classification from the Baltimore system.
";

ViralGenomeP=Alternatives@@{"dsDNA","+ssDNA","dsRNA","+ssRNA","-ssRNA","ssRNA-RT","dsDNA-RT"};



(* ::Subsubsection::Closed:: *)
(*ViralTaxonomyP*)


ViralTaxonomyP=Alternatives@@{Hepadnavirus,Adenovirus,Poxvirus,Herpesvirus,Papillomavirus,Polyomavirus,Parvovirus,Hepadnavirus,Rhabdovirus,Filovirus,Paramyxovirus,Bunyavirus,Arenavirus,Orthomyxovirus,Coronavirus,Flavivirus,Togavirus,Picornavirus,Calicivirus,Astrovirus,Retrovirus,Reovirus};



(* ::Subsubsection::Closed:: *)
(*LatentStateP*)


LatentStateP::usage="
DEFINITIONS
	(Integrated|Episome|Poxvirus)
	Matches a viral latent state.
";

LatentStateP=Alternatives@@{Integrated, Episome};


(* ::Subsubsection::Closed:: *)
(*LCPumpP*)


LCPumpP=Alternatives["A", "B", "Sample"];


(* ::Subsubsection::Closed:: *)
(*ViralLifeCycleP*)


ViralLifeCycleP=Alternatives[
	"Lytic Infection",
	"Latent Infection",
	"Infection",
	"DNA Replication",
	"Gene Expression",
	"Transcriptional Control",
	"Viral Structure",
	"Viral RNA Regulation",
	"Virion Release",
	"Cellular Transformation"
];


(* ::Subsubsection::Closed:: *)
(*DocumentTypeP*)


DocumentTypeP::usage="
DEFINITIONS
	Article|Book|Webpage|ProductDocumentation|MSDS|QCDocumentation|BookSection|Patent
		 Pattern for the type of documentation that a PDF might be.
";

DocumentTypeP=Alternatives[
	JournalArticle,
	Book,
	Webpage,
	ProductDocumentation,
	MSDS,
	QCDocumentation,
	BookSection,
	Patent
];



(* ::Subsubsection::Closed:: *)
(*BarcodeTypeP*)


BarcodeTypeP=Alternatives[
	Barcode,

	(* Retained for backwards compatibility with old sticker models *)
	DataMatrix,

	(* For new sticker models *)
	DataMatrixSquare,
	DataMatrixRectangle,

	QRCode
];



(* ::Subsubsection::Closed:: *)
(*CellularRNAP*)


CellularRNAP=Alternatives[
	TotalRNA,mRNA,tRNA,rRNA,miRNA,CellFreeRNA,ExosomalRNA,ViralRNA,ncRNA,lincRNA,premRNA,npcRNA,nmRNA,fRNA,sRNA,snoRNA,snRNA,exRNA,piRNA,tmRNA,aRNA,crRNA,siRNA,tasiRNA,rasiRNA
];



(* ::Subsubsection::Closed:: *)
(*StickerTypeP*)


StickerTypeP=Alternatives[
	Object,
	Destination
];


(* ::Subsubsection::Closed:: *)
(*StickerSizeP*)


StickerSizeP=Alternatives[
	Small,
	Large
];


(* ::Subsubsection::Closed:: *)
(*PrinterModelP*)


PrinterModelP=Alternatives["Zebra GX430t","Brother Laser"];



(* ::Subsubsection::Closed:: *)
(*CapsidGeometryP*)


CapsidGeometryP=Alternatives[
	Unknown,Icosahedral,Prolate,Helical,Complex
];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskP*)


RosettaTaskP[]:=KeyValuePattern[{"TaskType" -> _, "ID" -> _}];
RosettaTaskP[input__]:=_?(RosettaTaskQ[#,input]&);



(* ::Subsubsection::Closed:: *)
(*RosettaTaskQ*)


RosettaTaskQ[task_Association]:=MatchQ[task, RosettaTaskP[]];
RosettaTaskQ[task_Association,taskTypes:{_Symbol..}]:=Apply[Or,Map[RosettaTaskQ[#,task]&,taskTypes]];
RosettaTaskQ[task_Association,taskType_Symbol]:=Module[
	{taskTypeString,infoAssociation,argKeys,taskArgs},

	(* Used to fetch task meta information *)
	taskTypeString = SymbolName[taskType];

	(* If TaskType key doesnt match input task type, return False *)
	If[MatchQ[ToString[Lookup[task,"TaskType"]],taskTypeString],
		True,
		False
	]
];



(* ::Subsubsection::Closed:: *)
(*RosettaTaskTypeP*)


RosettaTaskTypeP::usage="RosettaTaskTypeP matches all defined Rosetta Task type symbols.";
RosettaTaskTypeP:=Alternatives@@ProcedureFramework`Private`rosettaTaskTypes[];


(* ::Subsubsection::Closed:: *)
(*SafetyInformationP*)


SafetyInformationP = KeyValuePattern[
	{
		"Flammable"->BooleanP,
		"Acid"->BooleanP,
		"Base"->BooleanP,
		"Pyrophoric"->BooleanP,
		"SDSFiles"->{EmeraldCloudFileP...}
	}
];



(* ::Subsubsection::Closed:: *)
(*CellularInteractionP*)


CellularInteractionP=Alternatives[
	Activation,Inhibition
];



(* ::Subsubsection::Closed:: *)
(*CellularRegulationP*)


CellularRegulationP=Alternatives[
	Upstream,Downstream
];



(* ::Subsubsection::Closed:: *)
(*NullP*)


NullP=_?(MatchQ[Flatten[ToList[#]],{Null..}]&);



(* ::Subsubsection::Closed:: *)
(*NonZeroDigitCharacter*)


NonZeroDigitCharacter::usage="
DEFINITIONS
	NonZeroDigitCharacter=\"1\"|\"2\"|\"3\"|\"4\"|\"5\"|\"6\"|\"7\"|\"8\"|\"9\"
		Matches an numbers that are not zeros.
";
NonZeroDigitCharacter="1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9";



(* ::Subsubsection::Closed:: *)
(*OptionCategoryP*)


OptionCategoryP = Alternatives[
	General,
	Method,
	Protocol,
	Location,
	Control,
	Hidden,
	System,
	(* Troubleshooting *)
	Report,
	Ticket,
	(* UploadTransaction *)
	Order,

	(* Sample functions *)
	Shipment,

	(* Plot function option categories *)
	PlotStyle,
	PlotLabeling,
	RawData,
	DataSpecifications,

	(* Experiment function option categories *)
	SamplePrep,
	Aliquoting,
	AliquotPrep,
	PostProcessing,
	SampleStorage,

	(* Common subprotocol option categories *)
	Mixing,
	Incubation,
	Centrifugation,

	(* SPS option categories*)
	Washing,
	Swelling,
	Deprotection,
	Deprotonation,
	Capping,
	MonomerActivation,
	Coupling,
	Cleavage,
	Trituration,
	Resuspension,

	(* Foam option categories*)
	Detectors,
	Agitation,
	Decay,

	(* StockSolution *)
	FormulaSpecification,

	PumpControl,
	Injections,
	Running,

	(* Email notifications *)
	TemplateEmail
];



(* ::Subsubsection::Closed:: *)
(*StyleP*)


StyleP=Alternatives@@
	{
		Bold,
		Italic,
		Underlined,
		Larger,
		Smaller,
		_Integer?Positive,
		Tiny,
		Small,
		Medium,
		Large,
		_RGBColor,
		_CMYKColor,
		_GrayLevel,
		Rule[FontFamily,_String],
		Rule[FontSize,_Integer?Positive],
		Rule[FontWeight,Plain|Bold],
		Rule[FontSlant,Plain|Italic],
		Rule[FontColor,_?ColorQ],
		Rule[FontSlant,Plain|Italic],
		Rule[Background,_?ColorQ],
		Rule[AutoSpacing,BooleanP],
		Rule[LineIndent,_Real?Positive],
		Rule[LineIndentMaxFraction,_Real?(And[GreaterEqual[#,0],LessEqual[#,1]]&)],
		Rule[ScriptMinSize,_Integer?Positive],
		Rule[ScriptSizeMultipliers,_Real?(Less[#,1]&)],
		Rule[ShowContents,BooleanP],
		Rule[SpanLineThickness,Automatic|_Integer?Positive],
		Rule[SpanMaxSize,Automatic|_Integer?Positive],
		Rule[SpanMinSize,Automatic|_Integer?Positive],
		Rule[SpanSymmetric,BooleanP]
	};



(* ::Subsubsection::Closed:: *)
(*EdgeFormP*)


EdgeFormP=Alternatives@@
	{
		None,
		_?ColorQ,
		Thickness[Tiny|Small|Medium|Large],
		Thickness[_?NumericQ],
		AbsoluteThickness[_?NumericQ],
		Opacity[(_Integer|_Real)],
		Dashed,
		_Dashing
	};



(* ::Subsubsection::Closed:: *)
(*LineStyleP*)


LineStyleP=Alternatives@@
	{
		None,
		_?ColorQ,
		Thickness[Tiny|Small|Medium|Large],
		Thickness[_?NumericQ],
		AbsoluteThickness[_?NumericQ],
		Opacity[(_Integer|_Real),_?ColorQ],
		Dashed,
		_Dashing,
		_CapForm
	};



(* ::Subsubsection::Closed:: *)
(*FaceFormP*)


FaceFormP=Alternatives@@
	{
		None,
		_?ColorQ,
		_ColorData,
		_ColorFunction,
		Opacity[(_Integer|_Real)(*?(GreaterEqual[#,0] && LessEqual[#,1]&)*)],
		_Texture
	};



(* ::Subsubsection::Closed:: *)
(*AutoclaveModeP*)


AutoclaveModeP::usage="A pattern that matches a valid mode for autoclave sterilization.";

AutoclaveModeP=(Liquid|Gravity|Vacuum);



(* ::Subsubsection::Closed:: *)
(*AutoclaveProgramP*)


AutoclaveProgramP::usage="A pattern that matches a valid mode for autoclave sterilization.";

AutoclaveProgramP=(Universal|Liquid|Dry);



(* ::Subsubsection::Closed:: *)
(*BalanceModeP*)


BalanceModeP::usage="A pattern that matches a valid mode for types of balances.";

BalanceModeP=(Micro | Analytical | Macro | Bulk);

(*DistanceGaugeModeP*)


DistanceGaugeModeP::usage="A pattern that matches a valid mode for types of distance gauges.";

DistanceGaugeModeP=(Caliper | Height | Depth | Laser);

(* ::Subsubsection::Closed:: *)
(*GasP*)


GasP=Alternatives[Nitrogen, Argon, Carbon, Oxygen, CarbonDioxide, Air];



(* ::Subsubsection::Closed:: *)
(*InertGasP*)


InertGasP=Alternatives[Nitrogen, Argon, Helium];



(* ::Subsubsection::Closed:: *)
(*ColdPackingP *)


ColdPackingP =(Ice | DryIce | None);



(* ::Subsubsection::Closed:: *)
(*IncubationTemperatureP*)


IncubationTemperatureP=((37 Celsius));



(* ::Subsubsection::Closed:: *)
(*AmbientTemperatureP*)


AmbientTemperatureP = (Ambient | RangeP[24.9 Celsius, 25.1 Celsius]);



(* ::Subsubsection::Closed:: *)
(*NeckTypeP*)


NeckTypeP=_String?(StringMatchQ[#,
	(Repeated[DigitCharacter,{1,3}]~~"/"~~("400"|"405"|"410"|"415"|"425"|"430"|"2030"|"2035"))| (* GPI/SPI neck finish convention *)
	("GL"~~Repeated[DigitCharacter,{2,3}])| (* GL thread type convention *)
	("ABISeptumCappedVial")| (* Enumerated neck types *) (*See 'http://www.sks-bottle.com/CapNeck.html', 'http://www.bola.de/en/technical-information/screw-joints/determination-of-thread-types.html', and 'http://www.sigmaaldrich.com/chemistry/solvents/bottles-and-cans.html' for more information. *)
	("PhosphoramiditeVial") (*These vials have a mouth that is compatible with the DNA Synthesizer*)
]&);



(* ::Subsubsection::Closed:: *)
(*GatingChannelsP*)


GatingChannelsP = (FlowCytometryFluorescenceChannelP | SideScatter | ForwardScatter);



(* ::Subsubsection::Closed:: *)
(*GatingDimensionsP*)


GatingDimensionsP = (Area | Height | Width);



(* ::Subsubsection::Closed:: *)
(*PlasticP*)


PlasticP= Alternatives[
	ABS,
	PLA,
	Acrylic,
	AmorphousFluoropolymer,
	CPVC,
	CTFE,
	Cycloolefine,
	COC,
	Delrin,
	ECTFE,
	EPDM,
	ETFE,
	EVA,
	FEP,
	FFKM,
	HDPE,
	Hypalon,
	LDPE,
	NaturalRubber,
	NBR,
	Neoprene,
	Nitrile,
	Noryl,
	Nylon,
	PEEK,
	PEI,
	Perlast,
	PharmaPure,
	Polycarbonate,
	Polyester,
	Polyethylene,
	Polyisoprene,
	Polyolefin,
	Polyoxymethylene,
	Polypropylene,
	Polystyrene,
	Polyurethane,
	PVC,
	PCTFE,
	PETG,
	PF,
	PFA,
	PPS,
	PTFE,
	PVDF,
	SEBS,
	Silicone,
	SyntheticRubber,
	TFM,
	TPE,
	Tygon,
	UVPlastic,
	UVXPO,
	Viton
];



(* ::Subsubsection::Closed:: *)
(*LiquidHandlingScaleP*)


LiquidHandlingScaleP=Alternatives[MacroLiquidHandling,MicroLiquidHandling];


(* ::Subsubsection::Closed:: *)
(*FluorescenceScanTypeP*)


FluorescenceScanTypeP=(Excitation|Emission);



(* ::Subsubsection::Closed:: *)
(*ReadOrderP*)


ReadOrderP=(Serial|Parallel);


(* ::Subsubsection::Closed:: *)
(*ReadPlateTypeP*)


ReadPlateTypeP=Alternatives[
	AbsorbanceIntensity,
	AbsorbanceSpectroscopy,
	AbsorbanceKinetics,
	AlphaScreen,
	FluorescenceIntensity,
	FluorescenceSpectroscopy,
	FluorescenceKinetics,
	LuminescenceIntensity,
	LuminescenceSpectroscopy,
	LuminescenceKinetics
];


(* ::Subsubsection::Closed:: *)
(*AbsorbanceMethodP*)


AbsorbanceMethodP=Alternatives[Microfluidic,Cuvette,PlateReader];


(* ::Subsubsection::Closed:: *)
(*BMGFlowRateP*)


BMGFlowRateP=Alternatives[430 Microliter/Second,400 Microliter/Second,350 Microliter/Second,300 Microliter/Second,260 Microliter/Second,220 Microliter/Second,190 Microliter/Second,170 Microliter/Second,150 Microliter/Second,135 Microliter/Second,115 Microliter/Second,100 Microliter/Second,85 Microliter/Second,65 Microliter/Second,50 Microliter/Second];


(* ::Subsubsection::Closed:: *)
(*BMGSamplingDimensionP*)


BMGSamplingDimensionP=Alternatives[2,3,4,5,6,7,8,9,10,15,20,25,30];




(* ::Subsubsection::Closed:: *)
(*BMGPlateFormatNameP*)


BMGPlateFormatNameP = Alternatives["GREINER 96 F-BOTTOM","GREINER 384","GREINER 384 SMALL VOLUME","GREINER 96 HALF AREA","PE AlphaPlate 384","PE AlphaPlate 384 shallow well"];


(* ::Subsubsection::Closed:: *)
(*PlateReaderSamplingP*)


(* Sample Pattern for BMG readers *)
PlateReaderSamplingP = Matrix|Spiral|Ring|Center;



(* ::Subsubsection::Closed:: *)
(*MixingScheduleP*)


MixingScheduleP=(BeforeReadings|BetweenReadings|AfterInjections);



(* ::Subsubsection::Closed:: *)
(*VacuumEvaporationMethodP*)


 VacuumEvaporationMethodP=Alternatives[VeryLowBoilingPoint, LowBoilingPoint, Aqueous, HighBoilingPoint, VeryLowBoilingPointMix, LowBoilingPointMix, AqueousHCl, HighAndLowBoilingPointMix, HPLC, HPLCLyo];



(* ::Subsubsection::Closed:: *)
(*EvaporationTypeP*)


EvaporationTypeP = Alternatives[RotaryEvaporation, SpeedVac, NitrogenBlowDown];





(* ::Subsubsection::Closed:: *)
(*GelMaterialP*)


GelMaterialP=Alternatives[Polyacrylamide,Agarose];


(* ::Subsubsection::Closed:: *)
(*AgaroseLoadingDyeP*)


AgaroseLoadingDyeP=Alternatives[Model[Sample, "id:o1k9jAGq4WnG"],Model[Sample, "id:zGj91a7PrxAj"], Model[Sample, "id:lYq9jRx40W8O"], Model[Sample, "id:L8kPEjnm3oAA"], Model[Sample, "id:E8zoYvN4XJV5"], Model[Sample, "id:Y0lXejM9pxOx"], Model[Sample, "id:kEJ9mqRpW5Gp"], Model[Sample, "id:P5ZnEjdmK6r0"], Model[Sample, "id:3em6ZvL1zxA8"], Model[Sample, "id:D8KAEvGp4R5m"], Model[Sample, "id:aXRlGn6kPKav"]];


(* ::Subsubsection::Closed:: *)
(*AnalyticalAgaroseGelP*)


AnalyticalAgaroseGelP=Alternatives[Model[Item, Gel, "id:n0k9mG8XeWKr"],Model[Item, Gel, "id:01G6nvwmqxPY"],Model[Item, Gel, "id:1ZA60vLnOxPE"],Model[Item, Gel, "id:Z1lqpMzbVxvo"],Model[Item, Gel, "id:dORYzZJk8AmG"]];


(* ::Subsubsection::Closed:: *)
(*PreparativeAgaroseGelP*)


PreparativeAgaroseGelP=Alternatives[Model[Item,Gel,"id:4pO6dM5ZLxjL"],Model[Item,Gel,"id:Vrbp1jKBnxdq"],Model[Item,Gel,"id:XnlV5jK8dxpo"],Model[Item,Gel,"id:qdkmxzqORWE3"],Model[Item,Gel,"id:R8e1PjpmvxnX"]];


(* ::Subsubsection::Closed:: *)
(*WesternProtocolTypeP*)


WesternProtocolTypeP=Alternatives[
	Western,
	TotalProteinDetection
];



(* ::Subsubsection::Closed:: *)
(*WesternModeP*)


WesternModeP=(Simon|Sally|Peggy|Wes|PeggySue|SallySue|NanoPro);



(* ::Subsubsection::Closed:: *)
(*WesternMolecularWeightRangeP*)


WesternMolecularWeightRangeP=Alternatives[
	LowMolecularWeight,
	MidMolecularWeight,
	HighMolecularWeight
];


(* ::Subsubsection::Closed:: *)
(*WesternMolecularWeightRangeP*)


WesternDetectionP=Alternatives[
	Chemiluminescence
];



(* ::Subsubsection::Closed:: *)
(*AgarosePercentageP*)


AgarosePercentageP=Alternatives[
	0.5*Percent,
	1*Percent,
	1.5*Percent,
	2*Percent,
	3*Percent
];


(* ::Subsubsection::Closed:: *)
(*ProteinQuantificationAssayTypeP*)


ProteinQuantificationAssayTypeP=Alternatives[
	Bradford,
	BCA,
	FluorescenceQuantification,
	Custom
];


(* ::Subsubsection::Closed:: *)
(*ProteinQuantificationAssayTypeP*)


ProteinQuantificationDetectionModeP=Alternatives[
	Fluorescence,
	Absorbance
];


(* ::Subsubsection::Closed:: *)
(*DynamicLightScatteringAssayTypeP*)


DynamicLightScatteringAssayTypeP=Alternatives[
	SizingPolydispersity,
	IsothermalStability,
	MeltingCurve,
	ColloidalStability
];


(* ::Subsubsection::Closed:: *)
(*DynamicLightScatteringAssayTypeP*)


DynamicLightScatteringTemperatureProfileP=Alternatives[
	Linear,
	Stepwise
];


(* ::Subsubsection::Closed:: *)
(*AntibodyAssayCompatibilityP*)


AntibodyAssayCompatibilityP = Alternatives[Western, Microscope, FlowCytometry, Immunohistochemistry, Immunoprecipitation, Immunofluorescence, ELISA, ChromatinImmunoprecipitation];


(* ::Subsubsection::Closed:: *)
(*ELISATypeP*)


ELISATypeP=Alternatives[
	CapillaryELISA,
	SandwichELISA,
	DirectELISA,
	IndirectELISA,
	DirectSandwichELISA,
	IndirectSandwichELISA,
	DirectCompetitiveELISA,
	IndirectCompetitiveELISA,
	FastELISA
];


(* TODO: Remove this when the loading sequence of pattern is corrected *)
CapillaryELISAAnalyteP=Alternatives[
	"Adiponectin/Acrp30, total",
	"AFP",
	"Amphiregulin",
	"Angiogenin",
	"Angiopoietin-1 2nd Gen",
	"Angiopoietin-2",
	"Angiopoietin-like 4 (ANGPTL4)",
	"Axl",
	"BAFF",
	"BCMA/TNFRSF17",
	"BDNF, free",
	"BLC/BCA-1/CXCL13",
	"BMP-2",
	"BMP-9",
	"C-Reactive Protein (CRP)",
	"CA125",
	"CA9",
	"Caspase-1",
	"CCL16/HCC-4",
	"CCL17/TARC",
	"CCL18/PARC",
	"CCL19/MIP-3 beta",
	"CCL2/MCP-1",
	"CCL5/RANTES",
	"CD14",
	"CD163",
	"CD21",
	"CD25/IL-2 R alpha",
	"CD27",
	"CD40/TNFRSF5",
	"Chitinase 3-like 1/YKL-40",
	"CHO HCP 3G",
	"Chromagranin A (CGA)",
	"Clusterin",
	"COMP/Thrombospondin-5",
	"CTGF/CCN2",
	"CTLA-4",
	"CX3CL1/ Fractalkine",
	"CXCL10/IP-10",
	"CXCL12/SDF-1 alpha",
	"CXCL9/MIG",
	"Cyr61 (CCN1)",
	"Cytokeratin 18",
	"D-Dimer",
	"DcR3/TNFSF6B",
	"DKK-1",
	"E-Cadherin",
	"E-Selectin",
	"EGF",
	"ENA-78/CXCL5",
	"Endoglin/CD105",
	"Endothelin-1",
	"ENPP-2",
	"Eotaxin-3/CCL26",
	"EPO",
	"ErbB2",
	"FABP2/I-FABP",
	"FAP",
	"Fas/TNFRSF6",
	"Ferritin",
	"FGF-19",
	"FGF-21",
	"FGF-23",
	"FGF-7/KGF",
	"Follistatin",
	"Fractalkine/CX3CL1",
	"G-CSF",
	"Galectin-3",
	"GAS6",
	"GDF-15",
	"GFAP",
	"GM-CSF",
	"gp130",
	"Granzyme A",
	"Granzyme B",
	"Growth Hormone (hGH) *NEW*",
	"HCC-4/CCL16",
	"HE4/WFDC2",
	"Hepcidin",
	"HGF",
	"HGF R/c-MET",
	"HIV-1 Gag p24",
	"HVEM",
	"ICAM-1",
	"IFN-alpha (multi-subtype)",
	"IFN-alpha 2",
	"IFN-beta",
	"IFN-gamma 2nd Gen",
	"IFN-gamma 3rd Gen",
	"IGFBP-1",
	"IGFBP-2",
	"IL-1-alpha",
	"IL-1-beta",
	"IL-1ra/IL-1F3",
	"IL-2",
	"IL-2 R alpha/CD25",
	"IL-4",
	"IL-5",
	"IL-6",
	"IL-6 2nd Gen",
	"IL-6 2nd gen",
	"IL-6 R-alpha",
	"IL-7",
	"IL-8/CXCL8",
	"IL-10",
	"IL-11",
	"IL-12-p70",
	"IL-13",
	"IL-15",
	"IL-17A",
	"IL-18",
	"IL-18 BPa",
	"IL-19",
	"IL-22",
	"IL-33",
	"IL-34",
	"I-TAC",
	"Insulin",
	"LAG-3",
	"LBP",
	"Leptin",
	"LIGHT",
	"Lipocalin-2/NGAL",
	"M-CSF",
	"MAdCAM-1",
	"MCP-1/CCL2",
	"MCP-2/CCL8",
	"MCP-3/CCL7",
	"MDC/CCL22",
	"Mesothelin",
	"MICA",
	"MIF",
	"MIG/CXCL9",
	"MIP-1 alpha/CCL3",
	"MIP-1 beta/CCL4",
	"MIP-3 alpha/CCL20",
	"MMP-1",
	"MMP-7",
	"MMP-9",
	"Myeloperoxidase (MPO)",
	"Neprilysin/CD10",
	"Neurofilament Heavy (NF-H)",
	"Neurofilament Light (NF-L)",
	"NGF R/TNFRSF16",
	"NGF-beta",
	"Osteopontin (OPN)",
	"Osteoprotegrin/TNFRSF11B (OPG)",
	"PCSK9/PC9",
	"PD-L1/B7-H1",
	"PDGF-BB",
	"Pentraxin 3/TSG-14",
	"Periostin/OSF-2",
	"Placenta Growth Factor (PlGF)",
	"Pro-Gastrin-releasing Peptide",
	"Procalcitonin",
	"RAGE",
	"RANTES/CCL5",
	"Reg-3a",
	"Resistin",
	"SCF",
	"SDF-1 alpha/CXCL12",
	"Serpin A1",
	"Serpin A4/Kallistatin",
	"Serpin E1/PAI-1",
	"Siglec-9",
	"SLPI",
	"SP-D",
	"ST2/IL-1 R4 (IL-33 R)",
	"TACI/TNFRSF13B",
	"TARC/CCL17",
	"TFF3",
	"TGF-beta 1",
	"Thrombospondin-1 (THBS1)",
	"Tie-2",
	"TIM-1/KIM-1/HAVCR",
	"TIM-3",
	"TIMP-1",
	"TNF alpha",
	"TNF alpha 2nd Gen",
	"TNF R1",
	"TNF RII",
	"TRAIL",
	"Trappin-2/Elafin",
	"TREM-1",
	"TREM-2",
	"u-Plasminogen/uPA-1",
	"VCAM-1",
	"VEGF (VEGF-A)",
	"VEGF R1/Flt-1",
	"VEGF R2/KDR",
	"VEGF-B",
	"VEGF-C",
	"CCL4",
	"CXCL1/KC",
	"CXCL2/MIP-2",
	"Cystatin C",
	"IFN-gamma",
	"IP-10/CXCL10",
	"TNF-alpha",
	"Lipocalin 2",
	"TIM-1"
];


(* ::Subsubsection::Closed:: *)
(*ELISACartridgeTypeP*)


ELISACartridgeTypeP=Alternatives[
	SinglePlex72X1,
	MultiAnalyte32X4,
	MultiAnalyte16X4,
	MultiPlex32X8,
	Customizable
];


(* ::Subsubsection::Closed:: *)
(*ELISASampleTypeP*)


ELISASampleTypeP=Alternatives[
	Unknown,
	Standard,
	Spike,
	Blank
];


(* ::Subsubsection::Closed:: *)
(*ELISASpeciesP*)


ELISASpeciesP=Alternatives[
	Human,
	Mouse,
	Rat,
	Other
];


(* ::Subsubsection::Closed:: *)
(*ELISAWellContentsP*)


ELISAWellContentsP=Alternatives[
	Sample,
	Buffer,
	CaptureAntibody,
	DetectionAntibody
];


(* ::Subsubsection::Closed:: *)
(*EllaCartridgeNestPositionP*)


EllaMovementLockPositionP=Alternatives[
	Running,
	Movement,
	Cleaning
];


(* ::Subsubsection::Closed:: *)
(*ELISACartridgeTypeP*)


ELISACartridgeTypeP=Alternatives[
	SinglePlex72X1,
	MultiAnalyte32X4,
	MultiAnalyte16X4,
	MultiPlex32X8,
	Customizable
];




(* ::Subsubsection::Closed:: *)
(*ELISAWellContentsP*)


ELISAWellContentsP=Alternatives[
	Sample,
	Buffer,
	CaptureAntibody,
	DetectionAntibody
];



(* ::Subsubsection::Closed:: *)
(*ELISASampleTypeP*)


ELISASampleTypeP=Alternatives[
	Unknown,
	Standard,
	Spike,
	Blank
];



(* ::Subsubsection::Closed:: *)
(*ELISAMethodP*)


ELISAMethodP =Alternatives[DirectELISA,IndirectELISA,DirectSandwichELISA,IndirectSandwichELISA,DirectCompetitiveELISA, IndirectCompetitiveELISA, FastELISA];


(* ::Subsubsection::Closed:: *)
(*ELISAAntibodyConjugationTypeP*)


ELISAAntibodyConjugationTypeP = (HRP|AP);






ELISAAbsorbanceWavelengthP = (405 Nanometer|450 Nanometer|492 Nanometer|620 Nanometer);



(* ::Subsubsection::Closed:: *)
(*ELISAAbsorbanceWavelength*)


DilutionP = (DirectDilution|SerialDilution);


(* ::Subsubsection::Closed:: *)
(*ShakerIncubatorShakingP*)


ShakerIncubatorShakingP = (Orbital|Linear|Eight|Elliptic|Programmable);






(* ::Subsubsection::Closed:: *)
(*EllaCartridgeWashBufferVolumeP*)


EllaCartridgeWashBufferVolumeP=Alternatives[
	6.0Milliliter,8.0Milliliter,10.0Milliliter,16.0Milliliter
];


(* ::Subsubsection::Closed:: *)
(*ReadLocationP*)


ReadLocationP=(Top|Bottom);



(* ::Subsubsection::Closed:: *)
(*VacuumPumpTypeP*)


VacuumPumpTypeP=(Oil|Diaphragm|Rocker|Scroll);



(* ::Subsubsection::Closed:: *)
(*WasteTypeP*)


WasteTypeP=(Chemical|Biohazard|Sharps|Drain|Lab|Solid|Tip);



(* ::Subsubsection::Closed:: *)
(*ResinMaterialP*)


ResinMaterialP=(CrossLinkedPolystyrene|PolyEthyleneGlycol|ControlledPoreGlass|Tentagel|AminoMethylPolystyrene);



(* ::Subsubsection::Closed:: *)
(*ResinLinkerTypeP*)


ResinLinkerTypeP=(MBHA|Wang|RinkAmide|HMBA|TritylOH|HMPB|PAL|EthyleneGlycolOH|UnySupport|Succinyl|Glycolate|Hydroxyl);



(* ::Subsubsection::Closed:: *)
(*RecirculatingFluidTypeP*)


RecirculatingFluidTypeP=(Water|Oil|Antifreeze|Refrigerant|RefrigerantR404A);



(* ::Subsubsection::Closed:: *)
(*EnclosureTypeP*)


EnclosureTypeP=(Closed35x35x35 | Vented35x35x35 | VentedOpaque35x35x35 | Closed15x19x20 | Vented15x19x20 | Closed22x35x28 | Vented22x35x28 | Closed2Shelf16x31x47 | Vented2Shelf16x31x47);



(* ::Subsubsection::Closed:: *)
(*HazardCategoryP*)


HazardCategoryP=Biological|Chemical|Corrosive|IonizingRadiation|Inflammable|Mechanical|Pressure|Radioactive|Temperature|Toxic|None;


(* ::Subsubsection::Closed:: *)
(*URLP*)


URLP=(_String?(
	StringMatchQ[
		#,
		((("http"|"https"|"ftp"|"ftps")~~"://")|"")~~((LetterCharacter|DigitCharacter|"-")..)~~Repeated["."~~((LetterCharacter|DigitCharacter|"-")..)]~~RepeatedNull[(("/"~~Except[WhitespaceCharacter]...)~~("/"|""))]
	]&
	)
);



(* ::Subsubsection::Closed:: *)
(*PlumbingP*)


PlumbingP = (Nitrogen | Argon | Water | Air | Vacuum | Drain | Power | NaturalGas | CarbonDioxide);



(* ::Subsubsection::Closed:: *)
(*DataConnectorP*)


DataConnectorP = (Serial | USB | GPIB | Ethernet | BNC);



(* ::Subsubsection::Closed:: *)
(*ConnectionMethodP*)


ConnectionMethodP = (USB | Bluetooth);



(* ::Subsubsection::Closed:: *)
(*OperatingSystemP*)


OperatingSystemP = (Windows7 | Windows10 | WindowsXP | Linux | Mac);



(* ::Subsubsection::Closed:: *)
(*OperatingSystemP*)


MathematicaOperatingSystemP = ("Windows" | "MacOSX" | "Unix");



(* ::Subsubsection::Closed:: *)
(*PCICardP*)


PCICardP = (NetworkCard|SerialCard|GigE);



(* ::Subsubsection::Closed:: *)
(*AnalysisStatusP*)


AnalysisStatusP = (Requested | Running | Completed);



(* ::Subsubsection::Closed:: *)
(*NEMADesignationP*)


NEMADesignationP = Alternatives[_String?(StringMatchQ[#,"NEMA "~~"L"|""~~Alternatives["1","2","5","6","7","8","9","10","14","15","16","17","18","21","22","23"]~~"-"~~Alternatives["15","20","30","50","60"]]&), "Industrial"];


(* ::Subsubsection::Closed:: *)
(*AutomaticP*)


AutomaticP = (Manual | Auto);



(* ::Subsubsection::Closed:: *)
(*FlowCytometerTriggerSettingP*)


FlowCytometerTriggerSettingP= (And | Or | First);



(* ::Subsubsection::Closed:: *)
(*FlowCytometerModeP*)


FlowCytometerModeP= (Sorting | Counting);



(* ::Subsubsection::Closed:: *)
(*FlowCytometerAquisitionModeP*)


FlowCytometerAquisitionModeP= (SingleSample | HighThroughput);



(* ::Subsubsection::Closed:: *)
(*FlowCytometryDataFieldsP*)


FlowCytometryDataFieldsP = Alternatives[
	ECL`ForwardScatter488Excitation,
	ECL`ForwardScatter405Excitation,
	ECL`SideScatter488Excitation,
	ECL`Fluorescence488Excitation525Emission,
	ECL`Fluorescence488Excitation593Emission,
	ECL`Fluorescence488Excitation750Emission,
	ECL`Fluorescence488Excitation692Emission,
	ECL`Fluorescence561Excitation750Emission,
	ECL`Fluorescence561Excitation670Emission,
	ECL`Fluorescence561Excitation720Emission,
	ECL`Fluorescence561Excitation589Emission,
	ECL`Fluorescence561Excitation577Emission,
	ECL`Fluorescence561Excitation640Emission,
	ECL`Fluorescence561Excitation615Emission,
	ECL`Fluorescence405Excitation670Emission,
	ECL`Fluorescence405Excitation720Emission,
	ECL`Fluorescence405Excitation750Emission,
	ECL`Fluorescence405Excitation460Emission,
	ECL`Fluorescence405Excitation420Emission,
	ECL`Fluorescence405Excitation615Emission,
	ECL`Fluorescence405Excitation525Emission,
	ECL`Fluorescence355Excitation525Emission,
	ECL`Fluorescence355Excitation670Emission,
	ECL`Fluorescence355Excitation700Emission,
	ECL`Fluorescence355Excitation447Emission,
	ECL`Fluorescence355Excitation387Emission,
	ECL`Fluorescence640Excitation720Emission,
	ECL`Fluorescence640Excitation775Emission,
	ECL`Fluorescence640Excitation800Emission,
	ECL`Fluorescence640Excitation670Emission
];

(* ::Subsubsection::Closed:: *)
(*RowColumnP*)
RowColumnP = (Row|Column);

(* ::Subsubsection::Closed:: *)
(*ReadDirectionP*)


ReadDirectionP =(Row|Column|SerpentineRow|SerpentineColumn);


(* ::Subsubsection::Closed:: *)
(*WavelengthSelectionP*)


WavelengthSelectionP =(Filters|Monochromators);



(* ::Subsubsection::Closed:: *)
(*LuminescenceWavelengthSelectionP*)


LuminescenceWavelengthSelectionP =(NoFilter|Filters|Monochromators);


(* ::Subsubsection::Closed:: *)
(*MechanicalShakingP*)


MechanicalShakingP = (Orbital | DoubleOrbital | Linear );



(* ::Subsubsection:: *)
(*ShakerIncubatorShakingP*)


(* ::Subsubsection::Closed:: *)
(*TemperatureMonitorTypeP*)


TemperatureMonitorTypeP = (ImmersionProbe | CuvetteBlock);



(* ::Subsubsection::Closed:: *)
(*DarkroomCameraTypeP*)


DarkroomCameraTypeP = "Digi Cam 125 Digital Color Camera";



(* ::Subsubsection::Closed:: *)
(*CameraCategoryP*)


CameraCategoryP = Alternatives[Plate,Small,Medium,Large,Overhead];



(* ::Subsubsection::Closed:: *)
(*ResolutionP*)


ResolutionP = _?(StringMatchQ[#,DigitCharacter..~~"x"~~DigitCharacter..]&);



(* ::Subsubsection::Closed:: *)
(*PlateBackingP*)


PlateBackingP = (Glass | Aluminium);


(* ::Subsubsection::Closed:: *)
(*PipettingPositionP*)


PipettingPositionP = (Top|Bottom|LiquidLevel|TouchOff);



(* ::Subsubsection::Closed:: *)
(*TubingTypeP*)


TubingTypeP = (Nitrile | Hypalon | Viton | Silicone | PVC | EPDM | Polyurethane | Rubber|PharmaPure);



(* ::Subsubsection::Closed:: *)
(*ShakerModeP*)


ShakerModeP = (Swirling | Rocking | Rotating | Orbital | Acoustic);


(* ::Subsubsection::Closed:: *)
(*MicroscopeIlluminationTypeP*)


MicroscopeIlluminationTypeP=DeleteDuplicates[Join[LampTypeP,ExcitationSourceP]];


(* ::Subsubsection::Closed:: *)
(*MicroscopeImageCorrectionP*)


MicroscopeImageCorrectionP=Alternatives[BackgroundCorrection,ShadingCorrection,BackgroundAndShadingCorrection];


(* ::Subsubsection::Closed:: *)
(*MicroscopeFluorescentImagingChannelP*)


MicroscopeFluorescentImagingChannelP=Alternatives[DAPI,CFP,FITC,YFP,TRITC,TexasRed,Cy3Cy5FRET,Cy3,Cy5,Cy7];


(* ::Subsubsection::Closed:: *)
(*MicroscopeImagingChannelP*)


MicroscopeImagingChannelP=Alternatives[Sequence@@MicroscopeFluorescentImagingChannelP,CustomChannel,TransmittedLight];


(* ::Subsubsection::Closed:: *)
(*ImagingModeP*)


ImagingModeP=Alternatives[VisibleLightImaging,CrossPolarizedImaging,UVImaging];


(* ::Subsubsection::Closed:: *)
(*MicroscopeFluorescentModeP*)


MicroscopeFluorescentModeP=Alternatives[ConfocalFluorescence,Epifluorescence];


(* ::Subsubsection::Closed:: *)
(*MicroscopeModeP*)


MicroscopeModeP=Alternatives[Sequence@@MicroscopeFluorescentModeP,BrightField,PhaseContrast,DarkField,Polarized];
(* Old pattern: (BrightField | DarkField | Confocal | Epifluorescence | PhaseContrast | DifferentialInterferenceContrast | TotalInternalReflectionFluorescence) *)


(* ::Subsubsection::Closed:: *)
(*MicroscopeSamplingMethodP*)


MicroscopeSamplingMethodP=Alternatives[SinglePoint,Grid,Coordinates,Adaptive];


(* ::Subsubsection::Closed:: *)
(*BandpassFilterTypeP*)


BandpassFilterTypeP=Alternatives[Bandpass,Longpass,Shortpass,Notch,Dichroic,NeutralDensity];


(* ::Subsubsection::Closed:: *)
(*ObjectiveImmersionMediumP*)


ObjectiveImmersionMediumP=Alternatives[Air,Water,Oil,Glycerol,Silicone];


(* ::Subsubsection::Closed:: *)
(*LaserTypeP*)


LaserTypeP=Alternatives[Gas,Liquid,SolidState,Diode];


(* ::Subsubsection::Closed:: *)
(*LaserSafetyClassP*)


LaserSafetyClassP=Alternatives[Class1,Class1M,Class2,Class2M,Class3R,Class3B,Class4];


(* ::Subsubsection::Closed:: *)
(*DistanceFunctionP*)


DistanceFunctionP = Alternatives[ManhattanDistance, EuclideanDistance, SquaredEuclideanDistance, NormalizedSquaredEuclideanDistance, CosineDistance, CorrelationDistance];

(* ::Subsubsection::Closed:: *)
(*robotElbowConfigurationsP*)
(* this is for indicating which direction the elbow should point on a robot that has elbows *)
robotElbowConfigurationsP=Alternatives[RightElbow,LeftElbow];

(* ::Subsubsection::Closed:: *)
(*robotWaypointTypeP*)
(* does a waypoint refer to a real position where a plate can be dropped/picked up or a virtual position that acts as an intermediate *)
robotWaypointTypeP=Alternatives[RealWaypoint,VirtualWaypoint];


(* ::Subsubsection::Closed:: *)
(*robotSequenceP*)


robotSequenceP = _?(Function[testString,
	Module[
		{robotStringPattern,sequencePattern},

		If[!MatchQ[testString,_String],
			Return[False]
		];

		(* establish the basic robot sequence pattern *)
		robotStringPattern = Alternatives[
			((WordCharacter..)~~(("_"~~(WordCharacter..))...)~~","~~(WordCharacter..)),
			((WordCharacter..)~~(("_"~~(WordCharacter..))...))
		];

		(* make the concatenated version of the robot sequnce string pattern *)
		sequencePattern = Alternatives[robotStringPattern~~((";"~~robotStringPattern)...),robotStringPattern~~((";"~~robotStringPattern)...)~~";"];

		(* check if the provided string StringMatches the robot sequence pattern *)
		StringMatchQ[testString,sequencePattern]
	]
]);



(* ::Subsubsection::Closed:: *)
(*robotNumberListP*)


robotNumberListP = _?(Function[testString,
	Module[
		{robotStringPattern,sequencePattern},

		If[!MatchQ[testString,_String],
			Return[False]
		];

		(* establish the basic robot number list pattern: {122,122.5,122.7,123} *)
		robotStringPattern = (NumberString..~~(","~~NumberString..)...);

		(* check if the provided string StringMatches the robot sequence pattern *)
		StringMatchQ[testString,robotStringPattern]
	]
]);



(* ::Subsubsection::Closed:: *)
(*CultureAdhesionP*)


CultureAdhesionP = Alternatives[Adherent, Suspension, SolidMedia];

LiquidCultureAdhesionP = Adherent | Suspension;


(* ::Subsubsection::Closed:: *)
(*CellRemovalTechniqueP*)

CellRemovalTechniqueP = Alternatives[Pellet, AirPressureFilter, CentrifugeFilter];

MediaClarificationTechniqueP = Alternatives[Pellet, AirPressureFilter, CentrifugeFilter, None];


(* -------------------------- *)
(* --- CellCount Patterns --- *)
(* -------------------------- *)



(* ::Subsubsection::Closed:: *)
(*AreaMeasurementAssociationP*)


(* Pattern used for AreaMeasurement field for each individual cell *)
AreaMeasurementAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Count,Area,FilledCount,EquivalentDiskRadius,AreaRadiusCoverage}),
	MatchQ[assoc,
		KeyValuePattern[
			{Count->GreaterEqualP[0]|Null,
			Area->GreaterEqualP[0]|Null,
			FilledCount->GreaterEqualP[0]|Null,
			EquivalentDiskRadius->GreaterEqualP[0]|Null,
			AreaRadiusCoverage->GreaterEqualP[0]|Null}
		]
	]
];
AreaMeasurementAssociationQ[_]:=False;
AreaMeasurementAssociationP:=_?AreaMeasurementAssociationQ;



(* ::Subsubsection::Closed:: *)
(*PerimeterPropertiesAssociationP*)


(* Pattern used for PerimeterProperties field for each individual cell *)
PerimeterPropertiesAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{AuthalicRadius,MaxPerimeterDistance,OuterPerimeterCount,
		PerimeterCount,PerimeterLength,PerimeterPositions,PolygonalLength}),
	MatchQ[assoc,
		KeyValuePattern[
			{AuthalicRadius->GreaterEqualP[0]|Null,
			MaxPerimeterDistance->GreaterEqualP[0]|Null,
			OuterPerimeterCount->GreaterEqualP[0]|Null,
			PerimeterCount->GreaterEqualP[0]|Null,
			PerimeterLength->GreaterEqualP[0]|Null,
			PerimeterPositions->{CoordinatesP..}|Null,
			PolygonalLength->GreaterEqualP[0]|Null}
		]
	]
];
PerimeterPropertiesAssociationQ[_]:=False;
PerimeterPropertiesAssociationP:=_?PerimeterPropertiesAssociationQ;



(* ::Subsubsection::Closed:: *)
(*CentroidPropertiesAssociationP*)


(* Pattern used for CentroidProperties field for each individual cell *)
CentroidPropertiesAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Centroid,Medoid,MeanCentroidDistance,MaxCentroidDistance,
		MinCentroidDistance}),
	MatchQ[assoc,
		KeyValuePattern[
			{Centroid->{GreaterEqualP[0],GreaterEqualP[0]}|Null,
			Medoid->{GreaterEqualP[0],GreaterEqualP[0]}|Null,
			MeanCentroidDistance->GreaterEqualP[0]|Null,
			MaxCentroidDistance->GreaterEqualP[0]|Null,
			MinCentroidDistance->GreaterEqualP[0]|Null}
		]
	]
];
CentroidPropertiesAssociationQ[_]:=False;
CentroidPropertiesAssociationP:=_?CentroidPropertiesAssociationQ;



(* ::Subsubsection::Closed:: *)
(*BestfitEllipseAssociationP*)


(* Pattern used for BestfitEllipse field for each individual cell *)
BestfitEllipseAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Length,Width,SemiAxes,Orientation,Elongation,Eccentricity}),
	MatchQ[assoc,
		KeyValuePattern[
			{Length->GreaterEqualP[0]|Null,
			Width->GreaterEqualP[0]|Null,
			SemiAxes->{GreaterEqualP[0],GreaterEqualP[0]}|Null,
			Orientation->RangeP[-Pi,Pi]|Null,
			Elongation->GreaterEqualP[0]|Null,
			Eccentricity->RangeP[0,1]|Null}
		]
	]
];
BestfitEllipseAssociationQ[_]:=False;
BestfitEllipseAssociationP:=_?BestfitEllipseAssociationQ;


(* ::Subsubsection::Closed:: *)
(*ShapeMeasurementsAssociationP*)


(* Pattern used for ShapeMeasurements field for each individual cell *)
ShapeMeasurementsAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Circularity,FilledCircularity,Rectangularity}),
	MatchQ[assoc,
		KeyValuePattern[
			{Circularity->GreaterEqualP[0]|Null,
			FilledCircularity->GreaterEqualP[0]|Null,
			Rectangularity->GreaterEqualP[0]|Null}
		]
	]
];
ShapeMeasurementsAssociationQ[_]:=False;
ShapeMeasurementsAssociationP:=_?ShapeMeasurementsAssociationQ;


(* ::Subsubsection::Closed:: *)
(*BoundingboxPropertiesAssociationP*)


(* Pattern used for BoundingboxProperties field for each individual cell *)
BoundingboxPropertiesAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Contours,BoundingBox,BoundingBoxArea,MinimalBoundingBox}),
	MatchQ[assoc,
		KeyValuePattern[
			{Contours->_List|Null,
			BoundingBox->{{GreaterEqualP[0],GreaterEqualP[0]},{GreaterEqualP[0],GreaterEqualP[0]}}|Null,
			BoundingBoxArea->_Real,
			MinimalBoundingBox->{{GreaterEqualP[0],GreaterEqualP[0]},{GreaterEqualP[0],GreaterEqualP[0]}}|Null}
		]
	]
];
BoundingboxPropertiesAssociationQ[_]:=False;
BoundingboxPropertiesAssociationP:=_?BoundingboxPropertiesAssociationQ;


(* ::Subsubsection::Closed:: *)
(*TopologicalPropertiesAssociationP*)


(* Pattern used for TopologicalProperties field for each individual cell *)
TopologicalPropertiesAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{Fragmentation,Holes,Complexity,EulerNumber,EmbeddedComponents,
		EmbeddedComponentCount,EnclosingComponents,EnclosingComponentCount}),
	MatchQ[assoc,
		KeyValuePattern[
			{Fragmentation->GreaterEqualP[0,1]|Null,
			Holes->GreaterEqualP[0,1]|Null,
			Complexity->GreaterEqualP[0,1]|Null,
			EulerNumber->RangeP[-Infinity,Infinity,1]|Null,
			EmbeddedComponents->{GreaterP[0,1]..}|Null,
			EmbeddedComponentCount->GreaterEqualP[0,1]|Null,
			EnclosingComponents->{GreaterP[0,1]..}|Null,
			EnclosingComponentCount->GreaterEqualP[0,1]|Null}
		]
	]
];
TopologicalPropertiesAssociationQ[_]:=False;
TopologicalPropertiesAssociationP:=_?TopologicalPropertiesAssociationQ;


(* ::Subsubsection::Closed:: *)
(*ImageIntensityAssociationP*)


(* Pattern used for ImageIntensity field for each individual cell *)
ImageIntensityAssociationQ[assoc_Association]:=And[
	(* Check that all the required keys exist *)
	And@@(KeyExistsQ[assoc,#]&/@{MinIntensity,MaxIntensity,MeanIntensity,MedianIntensity,
		StandardDeviationIntensity,TotalIntensity,Skew,IntensityCentroid}),
	MatchQ[assoc,
		KeyValuePattern[
			{MinIntensity->RangeP[0,1.]|Null|Indeterminate,
			MaxIntensity->RangeP[0,1.]|Null|Indeterminate,
			MeanIntensity->RangeP[0,1.]|Null|Indeterminate,
			MedianIntensity->RangeP[0,1.]|Null|Indeterminate,
			StandardDeviationIntensity->RangeP[0,1.]|Null|Indeterminate,
			TotalIntensity->GreaterEqualP[0]|Null|Indeterminate,
			Skew->Indeterminate|_|Null,
			IntensityCentroid->{GreaterEqualP[0],GreaterEqualP[0]}|Null|Indeterminate}
		]
	]
];
ImageIntensityAssociationQ[_]:=False;
ImageIntensityAssociationP:=_?ImageIntensityAssociationQ;

(* ::Subsubsection::Closed:: *)
(*ElementP*)

(* Engine can't run MM functions, so we need to hardcode the elements. *)
(* One can regenerate these as strings by running ElementData[#, "Name"] & /@ ElementData[] *)
ElementP = Alternatives[Hydrogen, Helium, Lithium, Beryllium, Boron, Carbon,
	Nitrogen, Oxygen, Fluorine, Neon, Sodium, Magnesium, Aluminum,
	Silicon, Phosphorus, Sulfur, Chlorine, Argon, Potassium, Calcium,
	Scandium, Titanium, Vanadium, Chromium, Manganese, Iron, Cobalt,
	Nickel, Copper, Zinc, Gallium, Germanium, Arsenic, Selenium,
	Bromine, Krypton, Rubidium, Strontium, Yttrium, Zirconium, Niobium,
	Molybdenum, Technetium, Ruthenium, Rhodium, Palladium, Silver,
	Cadmium, Indium, Tin, Antimony, Tellurium, Iodine, Xenon, Cesium,
	Barium, Lanthanum, Cerium, Praseodymium, Neodymium, Promethium,
	Samarium, Europium, Gadolinium, Terbium, Dysprosium, Holmium,
	Erbium, Thulium, Ytterbium, Lutetium, Hafnium, Tantalum, Tungsten,
	Rhenium, Osmium, Iridium, Platinum, Gold, Mercury, Thallium, Lead,
	Bismuth, Polonium, Astatine, Radon, Francium, Radium, Actinium,
	Thorium, Protactinium, Uranium, Neptunium, Plutonium, Americium,
	Curium, Berkelium, Californium, Einsteinium, Fermium, Mendelevium,
	Nobelium, Lawrencium, Rutherfordium, Dubnium, Seaborgium, Bohrium, Hassium,
	Meitnerium, Darmstadtium, Roentgenium, Copernicium, Nihonium, Flerovium,
	Moscovium, Livermorium, Tennessine, Oganesson
];

(* Engine can't run MM functions, so we need to hardcode the element abbreviations. *)
(* One can regenerate these by running ElementData[#, "Abbreviation"] & /@ ElementData[] *)
elementAbbreviationStrings = {"H", "He", "Li", "Be", "B", "C", "N", "O", "F", "Ne", "Na", "Mg",	"Al", "Si", "P", "S", "Cl", "Ar", "K", "Ca", "Sc", "Ti", "V", "Cr",	"Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr", "Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe", "Cs", "Ba", "La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu", "Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn", "Fr", "Ra", "Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr", "Rf", "Db", "Sg", "Bh", "Hs", "Mt", "Ds", "Rg", "Cn", "Nh", "Fl", "Mc", "Lv", "Ts", "Og"};
ElementAbbreviationP = Alternatives @@ elementAbbreviationStrings;

IsotopeP = _String?(StringMatchQ[#,	Repeated[DigitCharacter, 3] ~~ ElementAbbreviationP] &);

ElementPropertyP = Alternatives[Element, Abbreviation, Name, MolarMass, Isotopes, IsotopeAbundance, IsotopeMasses, Object];


(*ICPMSElementP*)
ICPMSElementP = Alternatives[Hydrogen, Helium, Lithium, Beryllium, Boron, Carbon,
	Nitrogen, Oxygen, Fluorine, Neon, Sodium, Magnesium, Aluminum,
	Silicon, Phosphorus, Sulfur, Chlorine, Argon, Potassium, Calcium,
	Scandium, Titanium, Vanadium, Chromium, Manganese, Iron, Cobalt,
	Nickel, Copper, Zinc, Gallium, Germanium, Arsenic, Selenium,
	Bromine, Krypton, Rubidium, Strontium, Yttrium, Zirconium, Niobium,
	Molybdenum, Technetium, Ruthenium, Rhodium, Palladium, Silver,
	Cadmium, Indium, Tin, Antimony, Tellurium, Iodine, Xenon, Cesium,
	Barium, Lanthanum, Cerium, Praseodymium, Neodymium, Promethium,
	Samarium, Europium, Gadolinium, Terbium, Dysprosium, Holmium,
	Erbium, Thulium, Ytterbium, Lutetium, Hafnium, Tantalum, Tungsten,
	Rhenium, Osmium, Iridium, Platinum, Gold, Mercury, Thallium, Lead,
	Bismuth, Polonium, Astatine, Radon, Francium, Radium, Actinium,
	Thorium, Protactinium, Uranium, Neptunium, Plutonium, Americium,
	Curium, Berkelium, Californium, Einsteinium, Fermium, Mendelevium,
	Nobelium, Lawrencium, Rutherfordium, Sweep
];

(*ICPMSNucleusP*)
ICPMSNucleusP = Alternatives["1H", "2H", "3H", "3He", "4He", "6Li", "7Li", "9Be",
	"10B", "11B", "12C", "13C", "14C", "14N", "15N", "16O", "17O",
	"18O", "19F", "20Ne", "21Ne", "22Ne", "23Na", "24Mg", "25Mg",
	"26Mg", "27Al", "28Si", "29Si", "30Si", "31P", "32S", "33S", "34S",
	"36S", "35Cl", "37Cl", "36Ar", "37Ar", "38Ar", "39Ar", "40Ar",
	"39K", "40K", "41K", "40Ca", "42Ca", "43Ca", "44Ca", "46Ca",
	"48Ca", "45Sc", "46Ti", "47Ti", "48Ti", "49Ti", "50Ti", "50V",
	"51V", "50Cr", "52Cr", "53Cr", "54Cr", "55Mn", "54Fe", "56Fe",
	"57Fe", "58Fe", "59Co", "58Ni", "60Ni", "61Ni", "62Ni", "64Ni",
	"63Cu", "65Cu", "64Zn", "66Zn", "67Zn", "68Zn", "70Zn", "69Ga",
	"71Ga", "70Ge", "72Ge", "73Ge", "74Ge", "76Ge", "75As", "74Se",
	"76Se", "77Se", "78Se", "80Se", "82Se", "79Br", "81Br", "78Kr",
	"80Kr", "82Kr", "83Kr", "84Kr", "86Kr", "85Rb", "87Rb", "84Sr",
	"86Sr", "87Sr", "88Sr", "89Y", "90Zr", "91Zr", "92Zr", "94Zr",
	"96Zr", "93Nb", "92Mo", "94Mo", "95Mo", "96Mo", "97Mo", "98Mo",
	"100Mo", "97Tc", "98Tc", "99Tc", "96Ru", "98Ru", "99Ru", "100Ru",
	"101Ru", "102Ru", "104Ru", "103Rh", "102Pd", "104Pd", "105Pd",
	"106Pd", "108Pd", "110Pd", "107Ag", "109Ag", "106Cd", "108Cd",
	"110Cd", "111Cd", "112Cd", "113Cd", "114Cd", "116Cd", "113In",
	"115In", "112Sn", "114Sn", "115Sn", "116Sn", "117Sn", "118Sn",
	"119Sn", "120Sn", "122Sn", "124Sn", "121Sb", "123Sb", "120Te",
	"122Te", "123Te", "124Te", "125Te", "126Te", "128Te", "130Te",
	"127I", "124Xe", "126Xe", "128Xe", "129Xe", "130Xe", "131Xe",
	"132Xe", "134Xe", "136Xe", "133Cs", "130Ba", "132Ba", "134Ba",
	"135Ba", "136Ba", "137Ba", "138Ba", "138La", "139La", "136Ce",
	"138Ce", "140Ce", "142Ce", "141Pr", "142Nd", "143Nd", "144Nd",
	"145Nd", "146Nd", "148Nd", "150Nd", "145Pm", "147Pm", "144Sm",
	"147Sm", "148Sm", "149Sm", "150Sm", "152Sm", "154Sm", "151Eu",
	"153Eu", "152Gd", "154Gd", "155Gd", "156Gd", "157Gd", "158Gd",
	"160Gd", "159Tb", "156Dy", "158Dy", "160Dy", "161Dy", "162Dy",
	"163Dy", "164Dy", "165Ho", "162Er", "164Er", "166Er", "167Er",
	"168Er", "170Er", "169Tm", "168Yb", "170Yb", "171Yb", "172Yb",
	"173Yb", "174Yb", "176Yb", "175Lu", "176Lu", "174Hf", "176Hf",
	"177Hf", "178Hf", "179Hf", "180Hf", "180Ta", "181Ta", "180W",
	"182W", "183W", "184W", "186W", "185Re", "187Re", "184Os", "186Os",
	"187Os", "188Os", "189Os", "190Os", "192Os", "191Ir", "193Ir",
	"190Pt", "192Pt", "194Pt", "195Pt", "196Pt", "198Pt", "197Au",
	"196Hg", "198Hg", "199Hg", "200Hg", "201Hg", "202Hg", "204Hg",
	"203Tl", "205Tl", "202Pb", "204Pb", "205Pb", "206Pb", "207Pb",
	"208Pb", "210Pb", "209Bi", "209Po", "210Po", "210At", "211At",
	"211Rn", "220Rn", "222Rn", "223Fr", "223Ra", "224Ra", "226Ra",
	"228Ra", "227Ac", "228Th", "229Th", "230Th", "232Th", "231Pa",
	"232U", "233U", "234U", "235U", "236U", "238U", "237Np", "239Np",
	"238Pu", "239Pu", "240Pu", "241Pu", "242Pu", "244Pu", "241Am",
	"243Am", "243Cm", "244Cm", "245Cm", "246Cm", "247Cm", "248Cm",
	"247Bk", "249Bk", "249Cf", "250Cf", "251Cf", "252Cf", "252Es",
	"257Fm", "258Md", "260Md", "259No", "260Lr", "267Rf", Sweep];

(* ICPMSCollisionCellGasP *)
ICPMSCollisionCellGasP = Alternatives[Helium(*, Oxygen*)];


(* ::Subsubsection::Closed:: *)
(*NucleusP*)


NucleusP = Alternatives["1H", "2H", "13C", "15N", "19F", "31P"];


(* ::Subsubsection::Closed:: *)
(*Nucleus1DP*)


Nucleus1DP = Alternatives["1H", "13C", "19F", "31P"];


(* ::Subsubsection::Closed:: *)
(*DirectNucleus2DP*)


DirectNucleus2DP = Alternatives["1H"];


(* ::Subsubsection::Closed:: *)
(*IndirectNucleus2DP*)


IndirectNucleus2DP = Alternatives["1H", "13C", "15N"];


(* ::Subsubsection::Closed:: *)
(*NMR2DExperimentP*)


NMR2DExperimentP = Alternatives[COSY, DQFCOSY, COSYBeta, TOCSY, HMBC, HSQC, HSQCTOCSY, HMQC, HMQCTOCSY, NOESY, ROESY];


(* ::Subsubsection::Closed:: *)
(*DeuteratedSolventP*)


DeuteratedSolventP = Alternatives[Water, Chloroform, DMSO, Benzene, Acetone, Acetonitrile, Methanol];


(* ::Subsubsection::Closed:: *)
(* NMRSamplingMethodP *)


NMRSamplingMethodP = Alternatives[TraditionalSampling, NonUniformSampling];


(* ::Subsubsection::Closed:: *)
(* WaterSuppressionMethodP *)


WaterSuppressionMethodP = Alternatives[Presaturation, WATERGATE, ExcitationSculpting];



(* ::Subsubsection::Closed:: *)
(* WaterSuppressionMethodP *)


WaterSuppressionMethodP = Alternatives[Presaturation, WATERGATE, ExcitationSculpting];



(* ::Subsubsection::Closed:: *)
(*NMRParametersP*)


NMRParametersP = Alternatives["PROHUMP_ECL","PROSENS_ECL","C13SENS_ECL","F19SENS_ECL","P31SENS_ECL"];


(* ::Subsubsection::Closed:: *)
(*NMRTestP*)


NMRTestP = Alternatives[ECL`Lineshape, ECL`Sensitivity, ECL`SolventSuppression];


(* ::Subsubsection::Closed:: *)
(*NMRSolventP*)


NMRSolventP = Alternatives["CDCl3","Acetone","C6D6","H2O+D2O"];


(* ::Subsubsection::Closed:: *)
(*PipetCapabilitiesP*)


PipetCapabilitiesP = (Aliquoting | VariableSpacing | AutomaticMixing);


(* ::Subsubsection::Closed:: *)
(*QPCRDataCollectionStepP*)


QPCRDataCollectionStepP = ( Denaturation | Annealing | Extension);



(* ::Subsubsection::Closed:: *)
(*ISSNTypeP*)


ISSNTypeP = Alternatives[Print,Electronic];



(* ::Subsubsection::Closed:: *)
(*ISSNP*)


ISSNP =(_String?(
	StringMatchQ[
		#,
		Repeated[DigitCharacter,{4}]~~"-"~~Repeated[DigitCharacter,{3}]~~(DigitCharacter|"X")
	]&
	)
);



(* ::Subsubsection::Closed:: *)
(*UserStatusP*)


UserStatusP::usage="
DEFINITIONS
	UserStatusP=(Active|Historical|Qualifying)
";

UserStatusP=Active|Historical|Qualifying;



(* ::Subsubsection::Closed:: *)
(*ModelStateP*)


ModelStateP = Solid | Liquid | Gas;



(* ::Subsubsection::Closed:: *)
(*ScrapeCellsOrderOfOperationsP*)


ScrapeCellsOrderOfOperationsP = BeforeDissociation | AfterDissociation;


(* ::Subsubsection::Closed:: *)
(*CellSourceSpeciesP*)


CellSourceSpeciesP = Human | Rat | Mouse;



(* ::Subsubsection::Closed:: *)
(*WorkCellIdlingConditionP*)


WorkCellIdlingConditionP = Ambient | Incubator;



(* ::Subsubsection::Closed:: *)
(*HamiltonWorkCellPositionP*)


HamiltonWorkCellPositionP=Alternatives[
	HeaterShaker,
	OffDeckHeaterShaker,
	HeaterCooler,
	HeaterCoolerShaker,
	Liconic,
	FilterPlate,
	CollectionPlate,
	VSpin,
	HiG,
	ImageXpress,
	NEPHELOstar,
	CLARIOstar,
	Omega,
	ATC,
	Tilt,
	Magnet,
	(* NOTE: We use the LowPosition to create plate stacks and to hand-off between the CO-RE and iSWAP. *)
	LowPosition,
	(* NOTE: We use the DockingPosition to move and re-grip plates/plate stacks in portrait mode after moving from the low position with a landscape grip with the iSWAP. *)
	DockingPosition,
	HandOff,
	OnDeck,
	Tips,
	(* NOTE: The TipsHandOff position is used to hand off tip boxes from on deck to the HMotion for movement to/from the tower positions. *)
	TipsHandOff,
	(* NOTE: These are the off deck storage positions. *)
	Tower,
	PlateSealer,
	FlowCytometer
];

(* An off-deck position is anything that requires the iSWAP/HMotion to reach (depending on the work cell). *)
HamiltonWorkCellOffDeckPositionP=Alternatives[
	OffDeckHeaterShaker,
	Liconic,
	FilterPlate,
	CollectionPlate,
	VSpin,
	HiG,
	ImageXpress,
	NEPHELOstar,
	CLARIOstar,
	Omega,
	ATC,
	Tower,
	PlateSealer,
	FlowCytometer,
	HandOff
];



(* ::Subsubsection::Closed:: *)
(*HamiltonWorkCellP*)


HamiltonWorkCellP=HamiltonWorkCell[KeyValuePattern[{
	(* The instrument model that was chosen. *)
	InstrumentModel->ObjectReferenceP[Model[Instrument]],

	(* The instrument object that was chosen. *)
	Instrument->ObjectReferenceP[Object[Instrument]],

	(* A list of SLL deck placements used to set-up the robotic liquid handler deck. This includes both on deck *)
	(* and off deck placements (including the incubator). *)
	(* NOTE: We never really use this programmatically. The only time is to go from Placements to PlacementIDs in the old *)
	(* framework. *)
	(* NOTE: We have additional object in the case where we're placing things off deck (the object that is off deck). *)
	Placements->{{ObjectP[], Alternatives[{LocationPositionP..}, {ObjectP[], LocationPositionP}]}...},

	(* A lookup that uses LiquidHandlerPositionIDs from the decks/racks on this liquid handler to relate SLL position *)
	(* placements to Venus sequence strings. *)
	(* NOTE: There are NOT full venus position strings (what hamiltonPositionSequenceNew does), but instead are base strings. *)
	(* NOTE: If the container is in a rack, it will be in the format {rackString_String, positionString_String} instead of *)
	(* rackString<>"_"<>positionString. *)
	PlacementIDs -> {(Alternatives[{LocationPositionP..}, {ObjectP[], LocationPositionP}]->(_String|{_String, _String}))...},

	(* A list of any placements of vials into a liquid-handler compatible rack before running the method. *)
	(* In the form {{vessel, rack, location}..}. *)
	VesselRackPlacements -> {{ObjectP[],ObjectP[],_String}...},

	(* A list of plates that are sitting on adapters on the deck. *)
	PlateAdapterPlacements -> {{ObjectP[],ObjectP[],_String}...},

	(* A version of the Placements option that refers to PlateAdapters (if used) instead of containers. *)
	ConvertedPlacements -> {{ObjectP[], Alternatives[{LocationPositionP..}, {ObjectP[], LocationPositionP}]}...},

	(* A lookup of the tip objects that are in the work cell to the count of tips that are in that object. *)
	TipCounts -> {(ObjectP[Object[Item, Tips]] -> _Integer)...},

	(* A lookup of the different tip models on the deck to the tip objects that are of that model type. *)
	TipTypes -> {(ObjectP[Model[Item, Tips]] -> {ObjectP[Object[Item, Tips]]..})...},

	(* These fields will be updated via safeMove when things are moved around on/off deck. *)

	(* NOTE: These strings are NOT full venus IDs but instead are the "base" IDs, same as in PlacementIDs. This is *)
	(* Model[Container, Deck][LiquidHandlerIntegrationPositionIDTypes][[All,2]] -- which can also be computed by doing *)
	(* Model[Container, Deck][LiquidHandlerPositionIDs] <> Model[Container,Rack][LiquidHandlerPositionIDs]. To get to the *)
	(* full venus IDs, you have to join the footprint to the start and the well to the end etc. via hamiltonPositionSequenceNew. *)
	(* Ex. PlacementIDs - "Plate_1_1", VenusID - "DWP_Plate_1_1,A1;" *)
	PlateLocations -> {(ObjectReferenceP[]->(_String|{_String, _String}))...},
	LidLocations -> {(ObjectReferenceP[]->(_String))...},
	PrimaryLidStack -> {(ObjectReferenceP[]->(_String))...},
	SecondaryLidStack -> {(ObjectReferenceP[]->(_String))...},

	(* To allow stacking on the LowPosition, multiple plates need to occupy the "same" position. This field tracks which plates in the low position are in the "Top"|"Bottom" of the stack for future movements *)
	LowPositionStack->{(ObjectReferenceP[]->(_String))...},

	(* The incubation positions that are being used residually. *)
	(* These positions are avoided (if possible) by safeMove since we don't want to stop residualIncubations. However, *)
	(* if we need all 4 heater positions, we will move the resdiually incubating plate off of the incubator heater position. *)
	(* safeMove will move the residually incubating plate back to the incubator on moveback of the new plate. *)
	ResidualIncubationLocations -> {(ObjectReferenceP[Object[Container]]->_String)...},

	(* This tracks the type of plate seals that are currently inside of our integrated plate sealer. *)
	(* NOTE: When our plate seal magazine aren't loaded into the plate sealer, we always put the foil plate seals into *)
	(* the foil plate seal magazine on foil park position, and the optically clear seal into the clear plate seal magazine *)
	(* on the clear park position. *)
	LoadedPlateSealType -> HamiltonPlateSealTypeP|Null
}]];

(* ::Subsubsection::Closed:: *)
(*HamiltonLabwareTypeP*)
(* this refers to different types of hamilton specific labware definition files that describe the dimensions of plates,
plate wells, and plate carriers *)

HamiltonLabwareTypeP= HamiltonRack|HamiltonContainer|HamiltonCarrier;

(* ::Subsubsection::Closed:: *)
(*HamiltonLabwareFileAssociationP*)
(* this is a pattern for valid key->value pairs found within hamilton files after reading them with
InternalExperiment`Private`importHamiltonLabware *)

(* generic hamilton file format *)
HamiltonLabwareFileAssociationP=Association[Repeated[
	_?(!StringContainsQ[#,
		Except[
			Flatten@{
				CharacterRange["A", "Z"],
				CharacterRange["a", "z"],
				CharacterRange["0", "9"],
				"_",
				"."
			}
		]
	] &)->_?(!StringContainsQ[#,
		Except[
			Flatten@{
				CharacterRange["A", "Z"],
				CharacterRange["a", "z"],
				CharacterRange["0", "9"],
				"_",
				".",
				"-",
				"*",
				"(",
				")",
				"\\",
				":",
				"/"
			}
		]
	] &)
]];


(* ::Subsubsection::Closed:: *)
(*HamiltonPlateSealTypeP*)

HamiltonPlateSealTypeP = AluminumFoil | Clear;

(* ::Subsubsection::Closed:: *)
(*CellStainingMethodP*)


CellStainingMethodP = Alternatives[GramStain];



(* ::Subsubsection::Closed:: *)
(*FoldingSimulationMethodP*)


FoldingSimulationMethodP = Kinetic | Thermodynamic;



(* ::Subsubsection::Closed:: *)
(*PrimerSetOrientationP*)


PrimerSetOrientationP = Sense | Antisense;



(* ::Subsubsection::Closed:: *)
(*KineticsSimulationMethodP*)


KineticsSimulationMethodP = Deterministic|Stochastic|Analytic;



(* ::Subsubsection::Closed:: *)
(*PrepPurityP*)


PrepPurityP = Crude|Purified;



(* ::Subsubsection::Closed:: *)
(*FractionCollectionModeP*)


FractionCollectionModeP = Time|Peak|Threshold;



(* ::Subsubsection::Closed:: *)
(*FractionStorageP*)


FractionStorageP = _String?(StringMatchQ[#1,DigitCharacter...~~LetterCharacter~~DigitCharacter..]&);



(* ::Subsubsection::Closed:: *)
(*LiquidHandlerConfigurationP*)


LiquidHandlerConfigurationP = Alternatives[
	WashStation1,
	WashStation2,
	TemperatureCarrier1,
	TemperatureCarrier2,
	PlateHandler,
	XLChannel,
	RoboticChannel,
	Cover,
	Autoload,
	Core96Head,
	ImagingChannel,
	TubeGripper,
	GelCardGripper,
	CardHandler,
	CardPuncher,
	NanoDispenser,
	Core384Head,
	PumpStation1,
	PumpStation2,
	PumpStation3
];



(* ::Subsubsection::Closed:: *)
(*PipettingChannelTypeP*)


PipettingChannelTypeP = Alternatives[
	Channel1000uL,
	Channel5mL
];



(* ::Subsubsection::Closed:: *)
(*DeviceChannelP*)


DeviceChannelP = Alternatives[
	MultiProbeHead,
	SingleProbe1,
	SingleProbe2,
	SingleProbe3,
	SingleProbe4,
	SingleProbe5,
	SingleProbe6,
	SingleProbe7,
	SingleProbe8
];



(* ::Subsubsection::Closed:: *)
(*SingleDeviceChannelP*)


SingleDeviceChannelP = Alternatives[
	SingleProbe1,
	SingleProbe2,
	SingleProbe3,
	SingleProbe4,
	SingleProbe5,
	SingleProbe6,
	SingleProbe7,
	SingleProbe8
];


(* ::Subsubsection::Closed:: *)
(*TransferP*)


transferQ[Transfer[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Source,Destination,Amount}),
	And@@(KeyExistsQ[assoc,#]&/@{Source,Destination,Volume})
];
transferQ[_]:=False;

TransferP:=_?transferQ;



(* ::Subsubsection::Closed:: *)
(*AliquotP*)


aliquotQ[Aliquot[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Source,Destinations,Amounts}),
	And@@(KeyExistsQ[assoc,#]&/@{Source,Destinations,Volumes})
];
aliquotQ[_]:=False;

AliquotP:=_?aliquotQ;



(* ::Subsubsection::Closed:: *)
(*ResuspendP*)


resuspendQ[Resuspend[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample,Volume});
resuspendQ[_]:=False;

ResuspendP:=_?resuspendQ;



(* ::Subsubsection::Closed:: *)
(*ConsolidationP*)


consolidationQ[Consolidation[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sources,Destination,Amounts}),
	And@@(KeyExistsQ[assoc,#]&/@{Sources,Destination,Volumes})
];
consolidationQ[_]:=False;

ConsolidationP:=_?consolidationQ;


(* ::Subsubsection::Closed:: *)
(*Cover*)


coverQ[Cover[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample});
coverQ[_]:=False;

CoverP:=_?coverQ;

(* object and model types used to cover containers *)
coveringTypesObjects = {Object[Item,Lid],Object[Item,Cap],Object[Item,PlateSeal]};
coveringTypesModels = {Model[Item,Lid],Model[Item,Cap],Model[Item,PlateSeal]};


(* ::Subsubsection::Closed:: *)
(*Uncover*)


uncoverQ[Uncover[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample});
uncoverQ[_]:=False;

UncoverP:=_?uncoverQ;



(* ::Subsubsection::Closed:: *)
(*ViscosityAssayTypeP*)


ViscosityAssayTypeP = Alternatives[LowViscosity, HighViscosity,HighShearRate];


(* ::Subsubsection::Closed:: *)
(*ViscosityMeasurementMethodP*)


ViscosityMeasurementMethodP = Alternatives[Optimize,FlowRateSweep, RelativePressureSweep,TemperatureSweep,Custom];


(* ::Subsubsection::Closed:: *)
(*VolumeMeasurementStatusP*)


VolumeMeasurementStatusP = Alternatives[ InitialManufacturerVolume, VolumeMeasurement, VolumeMeasurementError, UserSpecified, ComputedVolume];



(* ::Subsubsection::Closed:: *)
(*VolumeMeasurementMethodP*)


VolumeMeasurementMethodP = Alternatives[Ultrasonic, Gravimetric];



(* ::Subsubsection::Closed:: *)
(*VolumeMeasurementTypeP*)


VolumeMeasurementTypeP = Alternatives[Blank, Analyte,Tare];



(* ::Subsubsection::Closed:: *)
(*WeightMeasurementTypeP*)


WeightMeasurementTypeP = Alternatives[Analyte,Tare,Residue,Container];



(* ::Subsubsection::Closed:: *)
(*WeightMeasurementStatusP*)


WeightMeasurementStatusP = Alternatives[InitialManufacturerWeight, WeightMeasurement, WeightMeasurementError, UserSpecified, ComputedWeight];



(* ::Subsubsection::Closed:: *)
(*MixP*)


mixQ[Mix[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
mixQ[_]:=False;

MixP:=_?mixQ;



(* ::Subsubsection::Closed:: *)
(*MixInstrumentModelP*)


MixInstrumentModels={
	Model[Instrument,Roller],
	Model[Instrument,OverheadStirrer],
	Model[Instrument,Vortex],
	Model[Instrument,Shaker],
	Model[Instrument,BottleRoller],
	Model[Instrument,Roller],
	Model[Instrument,Sonicator],
	Model[Instrument,HeatBlock],
	Model[Instrument,Homogenizer],
	Model[Instrument,Disruptor],
	Model[Instrument,Nutator],
	Model[Instrument,Thermocycler],
	Model[Instrument, EnvironmentalChamber],
	Model[Instrument, Pipette]
};


MixInstrumentModelP=ObjectP[MixInstrumentModels];



(* ::Subsubsection::Closed:: *)
(*MixInstrumentP*)


MixInstrumentObjects={
	Object[Instrument,Roller],
	Object[Instrument,OverheadStirrer],
	Object[Instrument,Vortex],
	Object[Instrument,Shaker],
	Object[Instrument,BottleRoller],
	Object[Instrument,Roller],
	Object[Instrument,Sonicator],
	Object[Instrument,HeatBlock],
	Object[Instrument,Homogenizer],
	Object[Instrument,Disruptor],
	Object[Instrument,Nutator],
	Object[Instrument,Thermocycler],
	Object[Instrument, EnvironmentalChamber],
	Object[Instrument, Pipette]
};

MixInstrumentP=ObjectP[MixInstrumentObjects];



(* ::Subsubsection::Closed:: *)
(*CellMixInstrumentModelP*)


CellMixInstrumentModels=
	{
		Model[Instrument,Roller],
		Model[Instrument,OverheadStirrer],
		Model[Instrument,Vortex],
		Model[Instrument,Shaker],
		Model[Instrument,BottleRoller],
		Model[Instrument, Nutator]
	};


CellMixInstrumentModelP=ObjectP[
	CellMixInstrumentModels
];





(* ::Subsubsection::Closed:: *)
(*MixInstrumentP*)


CellMixInstruments=
	{
		Object[Instrument,Roller],
		Object[Instrument,OverheadStirrer],
		Object[Instrument,Vortex],
		Object[Instrument,Shaker],
		Object[Instrument,BottleRoller],
		Object[Instrument, Nutator]
	};


CellMixInstrumentP=ObjectP[
	CellMixInstruments
];



(* ::Subsubsection::Closed:: *)
(*IncubateP*)


incubateQ[Incubate[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
incubateQ[_]:=False;

IncubateP:=_?incubateQ;



(* ::Subsubsection::Closed:: *)
(*FilterP*)


filterQ[Filter[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
filterQ[_]:=False;

FilterP:=_?filterQ;



(* ::Subsubsection::Closed:: *)
(*MoveToMagnetP*)


moveToMagnetQ[MoveToMagnet[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
moveToMagnetQ[_]:=False;

MoveToMagnetP:=_?moveToMagnetQ;



(* ::Subsubsection::Closed:: *)
(*RemoveFromMagnetP*)


removeFromMagnetQ[RemoveFromMagnet[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
removeFromMagnetQ[_]:=False;

RemoveFromMagnetP:=_?removeFromMagnetQ;



(* ::Subsubsection::Closed:: *)
(*CentrifugeP*)


centrifugeQ[Centrifuge[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
centrifugeQ[_]:=False;

CentrifugeP:=_?centrifugeQ;



(* ::Subsubsection::Closed:: *)
(*ReadPlateP*)


readPlateQ[ReadPlate[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
readPlateQ[_]:=False;

ReadPlateP:=_?readPlateQ;



(* ::Subsubsection::Closed:: *)
(*PelletP*)


pelletQ[Pellet[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
pelletQ[_]:=False;

PelletP:=_?pelletQ;




(* ::Subsubsection::Closed:: *)
(*WaitP*)


waitQ[Wait[assoc_Association]]:=KeyExistsQ[assoc,Duration];
waitQ[_]:=False;

WaitP:=_?waitQ;



(* ::Subsubsection::Closed:: *)
(*defineQ*)


defineQ[Define[assoc_Association]]:=KeyExistsQ[assoc,Name];
defineQ[_]:=False;

DefineP:=_?defineQ;


(* ::Subsubsection::Closed:: *)
(*FillToVolumeP*)


fillToVolumeQ[FillToVolume[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Source,Destination,FinalVolume})
];
fillToVolumeQ[_]:=False;

FillToVolumeP:=_?fillToVolumeQ;


(* ::Subsubsection::Closed:: *)
(*FillToVolumeMethodP*)


FillToVolumeMethodP=Alternatives[Ultrasonic,Volumetric];


(* ::Subsubsection::Closed:: *)
(*FillToVolumeTransferTypeP*)


FillToVolumeTransferTypeP=Alternatives[Placeholder,Stepwise,InSituStepwise,BulkVolumetric,FineVolumetric];

(* ::Subsubsection::Closed:: *)
(*MicrowaveDigestionP*)


(*microwaveDigestionQ[MicrowaveDigestion[assoc_Association]]:=Or[
	And@@(KeyExistsQ[assoc,#]&/@{Sample})
];
microwaveDigestionQ[_]:=False;*)

microwaveDigestionQ[mwd_]:= If[MatchQ[mwd, MicrowaveDigestion[_Association]],
	Or[
		And@@(KeyExistsQ[mwd[[1]],#]&/@{Sample})
	],
	False
];

MicrowaveDigestionP:=_?microwaveDigestionQ;



(* ::Subsubsection::Closed:: *)
(*SampleManipulationP*)


SampleManipulationP = Alternatives[TransferP,FillToVolumeP,AliquotP,ResuspendP,ConsolidationP,MixP,IncubateP,WaitP,DefineP,FilterP,MoveToMagnetP,RemoveFromMagnetP,CentrifugeP,ReadPlateP,PelletP,CoverP,UncoverP, MicrowaveDigestionP];




(* ::Subsubsection::Closed:: *)
(*SampleManipulationExpandedP: SampleManipulationP+ELISAPrimitives*)
(*Adding this expanded pattern because ELISA primitives are not used as user inputs.*)


SampleManipulationExpandedP=Alternatives[TransferP,FillToVolumeP,AliquotP,ResuspendP,ConsolidationP,MixP,IncubateP,WaitP,DefineP,FilterP,MoveToMagnetP,RemoveFromMagnetP,CentrifugeP,ReadPlateP,PelletP,CoverP,UncoverP,ELISAWashPlateP,ELISAIncubatePlateP,ELISAReadPlateP];


(* ::Subsubsection::Closed:: *)
(*ELISAWashPlateP*)


elisaWashPlateQ[ELISAWashPlate[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample,WashVolume,NumberOfWashes});
elisaWashPlateQ[_]:=False;

ELISAWashPlateP:=_?elisaWashPlateQ;



(* ::Subsubsection::Closed:: *)
(*ELISAIncubatePlateP*)


elisaIncubatePlateQ[ELISAIncubatePlate[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample,IncubationTime,IncubationTemperature,ShakingFrequency});
elisaIncubatePlateQ[_]:=False;

ELISAIncubatePlateP:=_?elisaIncubatePlateQ;



(* ::Subsubsection::Closed:: *)
(*ELISAReadPlateP*)


elisaReadPlateQ[ELISAReadPlate[assoc_Association]]:=And@@(KeyExistsQ[assoc,#]&/@{Sample,MeasurementWavelength,ReferenceWavelength,DataFilePath});
elisaReadPlateQ[_]:=False;

ELISAReadPlateP:=_?elisaReadPlateQ;



(* ::Subsubsection:: *)
(*ELISAPrimitivesP*)


(* ::Subsubsection::Closed:: *)
(*LiquidHandlerCompatibleFootprintP*)

(* ::Subsubsection::Closed:: *)
(*MovementProfileTypeP*)

MovementProfileTypeP= Alternatives[Slow,Straight,Natural];

(* ::Subsubsection::Closed:: *)
(*GripAngleP*)

GripAngleP=Alternatives[0AngularDegree,90AngularDegree,180AngularDegree,270AngularDegree];

LiquidHandlerCompatibleFootprintP = Alternatives[
	Plate,
	MALDIPlate,
	MicrocentrifugeTube,
	Conical50mLTube,
	CEVial,
	GlassReactionVessel,
	AvantVial,
	PhytipColumn,
	ThermoMatrixTube
];


(* ::Subsubsection::Closed:: *)
(*WorkCellP*)


WorkCellP = Alternatives[STAR, bioSTAR, microbioSTAR, qPix];



(* ::Subsubsection::Closed:: *)
(*PreparationMethodP*)


PreparationMethodP = Alternatives[Manual, Robotic];



(* ::Subsubsection::Closed:: *)
(*UnitOperationTypeP*)


UnitOperationTypeP = Alternatives[Input, Optimized, Calculated, Output, Batched];


(* ::Subsubsection::Closed:: *)
(*ELISAPrimitivesP*)


ELISAPrimitivesP = Alternatives[TransferP,ELISAWashPlateP,ELISAIncubatePlateP,ELISAReadPlateP];



(* ::Subsubsection::Closed:: *)
(*PrimitiveMethodP*)


PrimitiveMethodP = Alternatives[
	Experiment,
	RoboticSamplePreparation,
	ManualSamplePreparation,
	RoboticCellPreparation,
	ManualCellPreparation
];



(* ::Subsubsection::Closed:: *)
(*PDBIDP*)


PDBIDP = _?(And[
	MatchQ[#,_String],
	StringMatchQ[#,Repeated[(LetterCharacter|DigitCharacter),4]]
]&);



(* ::Subsubsection::Closed:: *)
(*FlowCytometryTriggerP*)


FlowCytometryTriggerP = Alternatives[FSC,SSC,None];



(* ::Subsubsection::Closed:: *)
(*GateP*)


GatePacketQ[gate_]:=Or[
	And[
		MatchQ[gate, _Association],
		MatchQ[Sort[Keys[gate]], {Action, Dimensions, Polygon}],
		MatchQ[gate[Dimensions], {_Symbol, _Symbol} | {_Integer,_Integer} | {Null, Null}],
		MatchQ[gate[Polygon], _Polygon],
		MatchQ[gate[Action], IncludeP]
	],
	MatchQ[gate, Null]
];

GateP=_?GatePacketQ;


(* ::Subsubsection::Closed:: *)
(*IncludeP*)


IncludeP = Include|Exclude;



(* ::Subsubsection::Closed:: *)
(*PathLengthMethodP*)


PathLengthMethodP = Alternatives[Ultrasonic, Raman, RamanScattering, Constant];


(* ::Subsubsection::Closed:: *)
(*FiltrationTypeP*)


FiltrationTypeP = Alternatives[
	PeristalticPump,
	Centrifuge,
	Vacuum,
	Syringe,
	AirPressure
];


(* ::Subsubsection::Closed:: *)
(*NotchPositionP*)


NotchPositionP = Alternatives[
	TopLeft,
	TopRight,
	BottomLeft,
	BottomRight
];


(* ::Subsubsection::Closed:: *)
(*EnvironmentalChamberLightTypeP*)


EnvironmentalChamberLightTypeP = UVLight | VisibleLight;


(* ::Subsubsection::Closed:: *)
(*MixTypeP*)


MixTypeP = Alternatives[Roll, Vortex, Sonicate, Pipette, Invert, Stir, Shake, Homogenize, Swirl, Disrupt, Nutate];



(* ::Subsubsection::Closed:: *)
(*CellMixTypeP*)


CellMixTypeP = Alternatives[Roll, Vortex, Pipette, Invert, Shake, Swirl, Nutate];



(* ::Subsubsection::Closed:: *)
(*TransferMixTypeP*)


TransferMixTypeP= Alternatives[Pipette,Swirl];


(* ::Subsubsection::Closed:: *)
(*CellMixTypeP*)


CellMixTypeP = Alternatives[Roll, Vortex, Pipette, Invert, Shake, Swirl, Nutate];


(* ::Subsubsection::Closed:: *)
(*CellMixTypeP*)


GentleCellMixTypeP = Alternatives[Roll, Pipette, Invert, Shake, Swirl, Nutate];


(* ::Subsubsection::Closed:: *)
(*CellIsolationTechniqueP*)


CellIsolationTechniqueP = Alternatives[Pellet, Aspirate];



(* ::Subsubsection::Closed:: *)
(*TemperatureControlP*)


TemperatureControlP = Alternatives[Water, Air, HotPlate, None];


(* ::Subsubsection::Closed:: *)
(*ComputationStatusP*)


ComputationStatusP = Queued|Ready|Staged|WaitingForDistro|Running|Completed|Stopping|Stopped|Aborting|Aborted|TimedOut|Error;


(* ::Subsubsection::Closed:: *)
(*ScriptStatusP*)


ScriptStatusP = Template|InCart|Running|Exception|Paused|Stopped|Completed;
ScriptExceptionTypeP = None|Other|ScriptTimeout;



(* ::Subsubsection::Closed:: *)
(*KernelP*)


OldKernelV1P = Verbatim[Kernel][KeyValuePattern[{DownValues->_List, UpValues->_List, OwnValues->_List}]];
OldKernelV2P = Verbatim[Kernel][{(Hold[_]->Verbatim[Language`DefinitionList][_])..}];
KernelP = Verbatim[Kernel][ObjectP[Object[EmeraldCloudFile]]];



(* ::Subsubsection::Closed:: *)
(*CrossFlowFiltrationModeP*)

CrossFlowFiltrationModeP=Alternatives[Concentration,Diafiltration,ConcentrationDiafiltration, ConcentrationDiafiltrationConcentration];

(* ::Subsubsection::Closed:: *)
(*CrossFlowFiltrationSampleTypeP*)

(*CrossFlowFiltrationSampleTypeP=Alternatives[FilterPrime, Sample, FilterFlush, FilterFlushRinse, FilterPrimeRinse];*)


(* ::Subsubsection::Closed:: *)
(*CrossFlowFiltrationDiafiltrationModeP*)

CrossFlowFiltrationDiafiltrationModeP=Alternatives[Continuous, Discrete];


(* ::Subsubsection::Closed:: *)
(*CrossFlowFiltrationDeadVolumeRecoveryModeP*)

CrossFlowFiltrationDeadVolumeRecoveryModeP=Alternatives[Air, Buffer];


(* ::Subsubsection::Closed:: *)
(*FilterFractionP*)


FilterFractionP=Alternatives[Permeate,Retentate];


(* ::Subsubsection::Closed:: *)
(*CrossFlowPlotTypeP*)


CrossFlowPlotTypeP=Alternatives[Conductivity,Weight,Pressure,Temperature,FlowRate];


(* ::Subsubsection::Closed:: *)
(*ValidCrossFlowCriteriaP*)


(* Valid key patterns for ExperimentCrossFlowFiltration target primitive *)
$ValidCrossFlowPrimitiveKeyPatterns:=<|
	Fraction->FilterFractionP,
	Cutoff->Alternatives[GreaterP[0 Milli Siemens/Centimeter],GreaterP[0 ArbitraryUnit]]
|>;

(* Check that all keys are present and match their expected patterns *)

crossFlowKeyMatchQ[assoc_Association]:=And@@KeyValueMap[
	Function[{key,value},
		If[
			KeyExistsQ[$ValidCrossFlowPrimitiveKeyPatterns,key],
			MatchQ[value,Lookup[$ValidCrossFlowPrimitiveKeyPatterns,key]],
			False
		]
	],
	assoc
];

(* Generate the pattern *)
ValidCrossFlowCriteriaP:=_?crossFlowKeyMatchQ;


(* ::Subsubsection::Closed:: *)
(*CrossFlowFilterCutoffP*)


CrossFlowFilterCutoffP=Alternatives[
	3. Kilo Dalton,
	5. Kilo Dalton,
	10. Kilo Dalton,
	30. Kilo Dalton,
	50. Kilo Dalton,
	100. Kilo Dalton,
	300. Kilo Dalton,
	500. Kilo Dalton,
	0.05 Micron,
	0.2 Micron
];


(* ::Subsubsection::Closed:: *)
(*CrossFlowFilterTypeP*)


CrossFlowFilterTypeP=Alternatives[HollowFiber,Sheet];


(* ::Subsubsection::Closed:: *)
(*CrossFlowFilterModuleP*)


CrossFlowFilterModuleP=Alternatives[MicroKros,MidiKros,MidiKrosTC,MiniKrosSampler,Xampler,CytivaPilotScale,Sartocon];



(* ::Subsubsection::Closed:: *)
(*CrossFlowFiltrationDetectorTypeP*)


CrossFlowFiltrationDetectorTypeP=Alternatives[Temperature,Conductivity,Absorbance,Pressure];


(* ::Subsubsection::Closed:: *)
(*CrossFlowFilterMembraneMaterialP*)


CrossFlowFilterMembraneMaterialP=Alternatives[ModifiedPolyethersulfone,Polyethersulfone,Polysulfone,MixedCelluloseEster,Hydrosart];


(* ::Subsubsection::Closed:: *)
(*CrossFlowModuleConditionP*)


CrossFlowModuleConditionP=Alternatives[Dry,PreWetted,Sterile];


(* ::Subsubsection::Closed:: *)
(*CrossFlowConnectorP*)


CrossFlowConnectorP:=_?(MatchQ[#,{ConnectorGenderP|None,Barbed|LuerLock|TriCloverClamp|Tubing}]&);



(* ::Subsubsection:: *)
(*BufferDilutionStrategyP*)


BufferDilutionStrategyP=Alternatives[Direct,FromConcentrate];


(*::Subsubsection::Closed::*)
(*$ReceiveAllCovers*)


$ReceiveAllCovers=True;



(* ::Subsubsection::Closed:: *)
(*ElectricalPhaseP*)


ElectricalPhaseP=Alternatives[SinglePhase,ThreePhase];


(* ::Subsubsection::Closed:: *)
(*TransformerTypeP*)


TransformerTypeP=Alternatives[Constant,PhaseConversion,StepDown,StepUp];

(* ::Subsubsection::Closed:: *)

(*DislodgeCellsIntensityP*)

DislodgeCellsIntensityP = Alternatives[Gentle , Moderate , Vigorous, Custom];

(* ::Subsubsection::Closed:: *)
(*TransformerTypeP*)


MediaPhaseP=Alternatives[Solid,Liquid,SemiSolid];


(* ::Subsection::Closed:: *)
(*Transaction patterns*)


(* ::Subsubsection::Closed:: *)
(*OrderStatusP*)


OrderStatusP=(Pending|Ordered|Shipped|Received|Backordered|Canceled);



(* ::Subsubsection::Closed:: *)
(*DropShippingStatusP*)


DropShippingStatusP=(Ordered|Shipped|Received|Canceled);


(* ::Subsubsection::Closed:: *)
(*ReturningStatusP *)


ReturningStatusP=(Pending| Shipped | Canceled);



(* ::Subsubsection::Closed:: *)
(*SendingStatusP *)


SendingStatusP =(Pending| Shipped | Received | Canceled);



(* ::Subsubsection::Closed:: *)
(*PostalCodeP*)


PostalCodeP=_String;


(* ::Subsubsection::Closed:: *)
(*ZIPCodeP*)


ZIPCodeP=_String?(StringMatchQ[#1, Repeated[DigitCharacter, 5]] &);


(* ::Subsubsection::Closed:: *)
(*postalCodeRegionP*)


postalCodeRegionP=_?(StringMatchQ[#, Repeated[DigitCharacter, {1,4}]] &);


(* ::Subsubsection::Closed:: *)
(*ShippingSpeedP*)


ShippingSpeedP=(NextDay|ThreeDay|FiveDay);


(* ::Subsubsection::Closed:: *)
(*UnitedStateAbbreviationP*)


UnitedStateAbbreviationP:=Alternatives["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY"];



(* ::Subsubsection::Closed:: *)
(*AustralianStatesP*)


AustralianStatesP:=Alternatives["New South Wales", "Queensland", "South Australia", "Tasmania", "Victoria", "Western Australia","Australian Capital Territory","Jervis Bay Territory","Northern Territory"];



(* ::Subsubsection::Closed:: *)
(*MalaysianStatesP*)


MalaysianStatesP:=Alternatives["Federal Territory of Kuala Lumpur","Federal Territory of Labuan","Federal Territory of Putrajaya","Johor","Kedah","Kelantan","Malacca","Negeri Sembilan","Pahang","Perak","Perlis","Penang","Sabah","Sarawak","Selangor","Terengganu"];



(* ::Subsubsection::Closed:: *)
(*CanadianProvincesP*)


CanadianProvincesP:=Alternatives["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Nunavut","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"];



(* ::Subsubsection::Closed:: *)
(*LocalityP*)


LocalityP:=_String?(StringLength[#] <= 30 &);



(* ::Subsubsection::Closed:: *)
(*CountyP*)


CountyP:=_String?(StringLength[#] <= 30 &);



(* ::Subsubsection::Closed:: *)
(*CityP*)


CityP:=_String?(StringLength[#] <= 30 &);


(* ::Subsubsection::Closed:: *)
(*CountryP*)
(* When adding a new country to the CountryP list make sure properly populate RequiredCountryFieldsLookup, StatePatternLookup and ProvincePatternLookup*)


CountryP:=Alternatives["Australia", "Austria", "Belgium", "Canada", "Czech Republic", "Denmark", "Finland", "France", "Germany", "Greece", "Hungary", "Italy", "Luxembourg", "Malaysia", "Netherlands", "Norway", "Poland", "Portugal", "Puerto Rico", "Ireland", "Romania", "Spain", "Sweden", "Switzerland", "United Kingdom", "United States"];



(* ::Subsubsection::Closed:: *)
(*CountryWithStatesP*)


CountryWithStatesP:=Alternatives["Australia","Malaysia","United States"];



(* ::Subsubsection::Closed:: *)
(*CountryWithProvinceP*)


CountryWithProvincesP:=Alternatives["Canada"];



(* ::Subsubsection::Closed:: *)
(*CountryWithLocalityP*)


CountryWithLocalityP:=Alternatives["Malaysia","Ireland","United Kingdom"];



(* ::Subsubsection::Closed:: *)
(*CountryWithCountyP*)


CountryWithCountyP:=Alternatives["Ireland","United Kingdom"];



(* ::Subsubsection::Closed:: *)
(*StreetAddressP*)


StreetAddressP:=_String?(StringLength[#] <= 35 &);


(* ::Subsubsection::Closed:: *)
(*AttentionNameP*)


AttentionNameP:=_String?(StringLength[#] <= 35 &);


(* ::Subsubsection::Closed:: *)
(*CompanyNameP*)


CompanyNameP:=_String?(StringLength[#] <= 35 &);


(* ::Subsubsection::Closed:: *)
(*UPSAPINameP*)


UPSAPINameP = (Shipping | Pickup | Tracking);


(* ::Subsubsection::Closed:: *)
(*UPSTrackingStatusP*)


UPSTrackingStatusP = (InTransit | Delivered | Exception | Pickup | ManifestPickup);


(*Experiment patterns*)


(* ::Subsection::Closed:: *)
(*Instrument patterns*)


(* ::Subsubsection::Closed:: *)
(*PherastarP*)


PherastarP =Alternatives[
	ObjectP[Model[Instrument, PlateReader, "PHERAstar FS"]],
	ObjectP[Model[Instrument, PlateReader, "id:01G6nvkKr3o7"]]
];



(* ::Subsubsection::Closed:: *)
(*SpottingMethodP*)


SpottingMethodP::usage="
DEFINITIONS
	SpottingMethodP=Alternatives[Sandwich|OpenFace]
	Pattern for the most common spotting techniques used for MALDI MassSpectrometry";
(* we exclude Monolayer from this pattern because it's currently not supported *)
SpottingMethodP=Sandwich|OpenFace;



(* ::Subsubsection::Closed:: *)
(*NeedleGaugeP*)


NeedleGaugeP=Alternatives["7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","22s","23","24","25","26","26s","27","28","29","30","31","32","33","34"];



(* ::Subsubsection::Closed:: *)
(*FocusingElementP*)


FocusingElementP::usage="
DEFINITIONS
	FocusingElementP=Alternatives[GuideWire|ElectrostaticLens]
	Pattern for the most common types of focusing elements in MassSpectrometry";

FocusingElementP=Alternatives[GuideWire,ElectrostaticLens];



(* ::Subsubsection::Closed:: *)
(*FractionP*)


FractionP::usage="
DEFINITIONS
	FractionP={_?NumericQ,_?NumericQ,_String}
		Matches the format of a fraction in Chromatography data
";

FractionP={_?UnitsQ,_?UnitsQ,_String?(StringMatchQ[#1,DigitCharacter...~~LetterCharacter~~DigitCharacter..]&)};


(* ::Subsubsection::Closed:: *)
(*ResourceStatusP*)


ResourceStatusP=(Fulfilled|Canceled|Preparation|InCart|Outstanding|Shipping|InUse);


(* ::Subsubsection::Closed:: *)
(*IonModeP*)


IonModeP::usage="
DEFINITIONS
	IonModeP=Negative|Positive
	Pattern for the most common ion polarity detection modes for MassSpectrometry";

IonModeP=Alternatives[Negative,Positive];



(* ::Subsubsection::Closed:: *)
(*IonSourceP*)


IonSourceP::usage="
DEFINITIONS
	IonSourceP=ESI|MALDI
	Pattern for the most common ion source modes for MassSpectrometry";
(* exclude APCI from pattern since we currently don't support that *)
(* exclude ICP since ExperimentICPMS is defined separately from ExperimentMassSpectrometry. Including ICP in IonSourceP may lead to incorrecly select IonSource -> ICP *)
IonSourceP=ESI|MALDI;



(* ::Subsubsection::Closed:: *)
(*GCIonSourceP*)


GCIonSourceP::usage="
DEFINITIONS
	GCIonSourceP=ElectronIonization|ChemicalIonization
	Pattern for common ion source modes for GCMS";
(* exclude ICP and APCI from pattern since we currently don't support that *)
GCIonSourceP=ElectronIonization|ChemicalIonization;



(* ::Subsubsection::Closed:: *)
(*AcquisitionModeP*)


AcquisitionModeP::usage="
DEFINITIONS
	AcquisitionModeP= MS|MSMS
	Pattern for the most common experiment types for MassSpectrometry";

AcquisitionModeP=MS|MSMS;



(* ::Subsubsection::Closed:: *)
(*InjectionTypeP*)


InjectionTypeP::usage="
DEFINITIONS
	InjectionTypeP= MS|MSMS
	Pattern for the possible types of injection for ionspray MassSpectrometry";

InjectionTypeP = ( DirectInfusion | FlowInjection );



(* ::Subsubsection::Closed:: *)
(*FPLCInjectionTypeP*)


FPLCInjectionTypeP = ( Autosampler | FlowInjection | Superloop );


(* ::Subsubsection::Closed:: *)
(*SpottingPatternP*)


SpottingPatternP::usage="
DEFINITIONS
	SpottingPatternP=Alternatives[Sandwich|OpenFace]
	Pattern for the spot placement in MALDI MassSpectrometry";

SpottingPatternP = All|Spaced;



(* ::Subsubsection::Closed:: *)
(*CentrifugeRotorTypeP*)


CentrifugeRotorTypeP = (FixedAngle|SwingingBucket);



(* ::Subsubsection:: *)
(*CoulterCounterApertureDiameterP*)


CoulterCounterApertureDiameterP=Alternatives[100. Micrometer];


(* ::Subsubsection:: *)
(*CoulterCounterStopConditionP*)


CoulterCounterStopConditionP=Alternatives[Time,Volume,TotalCount,ModalCount];


(* ::Subsubsection:: *)
(*CoulterCounterContainerFootprintP*)


CoulterCounterContainerFootprintP=Alternatives[MS4e25mLCuvette,MS4e100mLBeaker,MS4e200mLBeaker,MS4e400mLBeaker];


(* ::Subsubsection::Closed:: *)
(*DarkroomIlluminationP*)


DarkroomIlluminationP = Overhead | Trans | BrightField;



(* ::Subsubsection::Closed:: *)
(*ExcitationSourceP*)


ExcitationSourceP=Alternatives[XenonFlashLamp,GasLaser,SolidStateLaser];



(* ::Subsubsection::Closed:: *)
(*WavelengthSelectionTypeP*)


WavelengthSelectionTypeP=Alternatives[Filter,Monochromator,Array,BandpassArray,None];



(* ::Subsubsection::Closed:: *)
(*PlateReaderWavelengthSelectionTypeP*)


PlateReaderWavelengthSelectionTypeP=Alternatives[Filters,Monochromators,Array,None];



(* ::Subsubsection::Closed:: *)
(*FumeHoodTypeP*)


FumeHoodTypeP = (Benchtop | WalkIn | Recirculating);



(* ::Subsubsection::Closed:: *)
(*LightSourceTypeP*)


LightSourceTypeP = (Continuous|Flash|LED);



(* ::Subsubsection::Closed:: *)
(*MassAnalyzerTypeP*)


MassAnalyzerTypeP = (TOF|QTOF|TripleQuadrupole|SingleQuadrupole|Orbitrap|LTQFTICR);



(* ::Subsubsection::Closed:: *)
(*OpticalPolarizationP*)


OpticalPolarizationP=Alternatives[Parallel,Perpendicular,Circular,Elliptical];



(* ::Subsubsection::Closed:: *)
(*PlateReaderModeP*)


PlateReaderModeP = Alternatives[
	FluorescenceIntensity,
	FluorescenceKinetics,
	FluorescenceSpectroscopy,
	FluorescencePolarization,
	FluorescencePolarizationKinetics,
	TimeResolvedFluorescence,

	AbsorbanceIntensity,
	AbsorbanceKinetics,
	AbsorbanceSpectroscopy,

	LuminescenceIntensity,
	LuminescenceKinetics,
	LuminescenceSpectroscopy,

	AlphaScreen,

	CircularDichroism
];


(* ::Subsubsection::Closed:: *)
(*FluorescenceModeP*)


FluorescenceModeP = (Fluorescence | FluorescencePolarization | TimeResolvedFluorescence);


(* ::Subsubsection::Closed:: *)
(*OpticalDetectorP*)


OpticalDetectorP = Alternatives[CCDImage,CCDArray,Diode,PhotomultiplierTube,HybridPhotonCoupling];


(* ::Subsubsection::Closed:: *)
(*DiffractionRadiationTypeP*)


DiffractionRadiationTypeP = Alternatives[Electron, Neutron, XRay];



(* ::Subsubsection::Closed:: *)
(*XRDExperimentTypeP*)


XRDExperimentTypeP := SingleCrystal | Powder;



(* ::Subsubsection:: *)
(*PowerTypeP*)


PowerTypeP = (Battery | Plug | PowerOverData | CompressedGas | None);



(* ::Subsubsection::Closed:: *)
(*CleanTypeP*)


CleanTypeP = ("GilsonSPE" | "Centrifuge" | "FlammableCabinet" | "Bench");



(* ::Subsubsection::Closed:: *)
(*VortexTypeP*)


VortexTypeP = (Tube|Plate);


(*pHTemperatureCorrectionP*)
pHTemperatureCorrectionP=Alternatives[Linear,NonLinear,None];


(* ::Subsubsection::Closed:: *)
(*PhaseContrastObjectiveP*)


PhaseContrastObjectiveP=Alternatives[DarkLow,DarkLowLow,ApodizedDarkLow,DarkMedium,ApodizedDarkMedium,BrightMedium,None];



(* ::Subsubsection::Closed:: *)
(*PhaseRingP*)


PhaseRingP=Alternatives[Ph1,Ph2,Ph3,PhL,None];



(* ::Subsubsection::Closed:: *)
(*AberrationCorrectionP*)


AberrationCorrectionP=Alternatives[Achromatic, Fluorite, Apochromatic, None];



(* ::Subsubsection::Closed:: *)
(*LightPathP*)


LightPathP=(N[100] Percent | N[80] Percent | 100 Percent | 80 Percent );



(* ::Subsubsection::Closed:: *)
(*AutoFocusModeP*)


AutoFocusModeP=("None"|"Adaptive"|"Steps in Range");



(* ::Subsubsection::Closed:: *)
(*AutoFocusStartPointP*)


AutoFocusStartPointP=(Fixed|Automatic);



(* ::Subsubsection::Closed:: *)
(*ScanPatternP*)


ScanPatternP=("Tile Grid"|"Random");



(* ::Subsubsection::Closed:: *)
(*ImageFieldP*)


ImageFieldP=(PhaseContrastImage|BlueFluorescenceImage|GreenFluorescenceImage|RedFluorescenceImage);


(* ::Subsubsection::Closed:: *)
(*LiquidHandlerTypeP*)


LiquidHandlerTypeP=Alternatives[LiquidHandling,SolidPhaseSynthesis,SolidPhaseExtraction];


(* ::Subsubsection::Closed:: *)
(*LiquidParticleCountDataTypeP*)


LiquidParticleCountDataTypeP=Alternatives[Sample,DilutedSample];


(* ::Subsubsection::Closed:: *)
(*ImageTypeP*)


ImageTypeP=(PhaseContrastImage|FluorescenceImage|SecondaryFluorescenceImage|TertiaryFluorescenceImage);


(* ::Subsubsection::Closed:: *)
(*ImagingDirectionP*)


(* Exclude 'All' from this pattern because 'All' will be expanded into {Side, Top} at experiment time *)
ImagingDirectionP=Alternatives[Side,Top];



(* ::Subsubsection::Closed:: *)
(*MicroscopeViewOrientationP*)


MicroscopeViewOrientationP= Alternatives[Upright, Inverted];



(* ::Subsubsection::Closed:: *)
(*IntensityFieldP*)


IntensityFieldP=(PhaseContrastIntensity|BlueFluorescenceIntensity|GreenFluorescenceIntensity|RedFluorescenceIntensity);


(* ::Subsubsection::Closed:: *)
(*LiquidHandlerTipTypeP*)


LiquidHandlerTipTypeP = Alternatives[DisposableTip, FixedTip];



(* ::Subsubsection::Closed:: *)
(*TipTypeP*)


TipTypeP = Alternatives[Normal,Barrier,WideBore,GelLoading,Aspirator];



(* ::Subsubsection::Closed:: *)
(*TipConnectionTypeP*)


(* NOTE: All pipettes smaller than P10 use a P10 connection type. *)
TipConnectionTypeP = P10|P20|P200|P1000|P5000|P10000|PosDMR1000|PosDMR100|PosDMR10|PosDMR25|PosDMR50|PosDMR250|Serological|Aspirator|AutoRep|E384P20|E384P100;


(* ::Subsubsection::Closed:: *)
(*CellTypeP*)

CellTypeP = Bacterial | Mammalian | Yeast | Plant | Insect | Fungal;

(* ::Subsubsection::Closed:: *)
(*MicrobialCellTypeP*)

MicrobialCellTypeP = Bacterial | Yeast | Fungal;

(* ::Subsubsection::Closed:: *)
(*NonMicrobialCellTypeP*)

NonMicrobialCellTypeP = Mammalian | Plant | Insect;

(* ::Subsubsection::Closed:: *)
(*CellularComponentP*)

CellularComponentP = CytosolicProtein | PlasmaMembraneProtein | NuclearProtein | SecretoryProtein | TotalProtein | RNA | GenomicDNA | PlasmidDNA | Organelle | Virus;

(* ::Subsubsection::Closed:: *)
(*CultureHandlingP*)

CultureHandlingP = Microbial | NonMicrobial;

(* ::Subsubsection::Closed:: *)
(*CellularComponentP*)

CellularComponentP=Alternatives[
	CytosolicProtein,
	PlasmaMembraneProtein,
	NuclearProtein,
	SecretoryProtein,
	TotalProtein,
	RNA,
	GenomicDNA,
	PlasmidDNA,
	Organelle,
	Virus
];

(* ::Subsubsection::Closed:: *)
(*PipetteTypeP*)


PipetteTypeP = Micropipette|Serological|PositiveDisplacement|Hamilton|QPix;



(* ::Subsubsection::Closed:: *)
(*WaterFilterP*)


WaterFilterP = Alternatives[BioPak,EDSPak,VOCPak,LCPak,MilliPak];



(* ::Subsubsection::Closed:: *)
(*DirectCurrentP*)


DirectCurrentP=Alternatives[Quantity[24, "VoltsDC"], Quantity[12, "VoltsDC"],Quantity[5, "VoltsDC"]];


(* ::Subsubsection::Closed:: *)
(*RatioP*)


RatioP=Alternatives[_Rational,1];


(* ::Subsubsection::Closed:: *)
(*NitrogenStoragePhaseP*)


NitrogenStoragePhaseP=Alternatives[Liquid,Gas];



(* ::Subsubsection::Closed:: *)
(*RelativeApertureP*)


RelativeApertureP=Alternatives[
	"f/5.6", "f/6.3", "f/7.1", "f/8.0", "f/9.0", "f/10.0",
	"f/11.0", "f/13.0", "f/14.0", "f/16.0", "f/18.0", "f/20.0", "f/22.0", "f/25.0", "f/29.0", "f/32.0", "f/36.0"
];



(* ::Subsubsection::Closed:: *)
(*ISOSensitivityP*)


ISOSensitivityP=Alternatives["100", "200", "400", "800", "1600", "3200", "6400", "12800"];



(* ::Subsubsection::Closed:: *)
(*FlowCytometryExcitationWavelengthP*)


FlowCytometryExcitationWavelengthP=Alternatives[
	355 Nanometer,
	405 Nanometer,
	488 Nanometer,
	561 Nanometer,
	640 Nanometer
];



(* ::Subsubsection::Closed:: *)
(*FlowCytometryDetectorP*)


FlowCytometryDetectorP=Alternatives[
	"488 FSC",
	"405 FSC",
	"488 SSC",
	"488 525/35",
	"488 593/52",
	"488 750LP",
	"488 692/80",
	"561 750LP",
	"561 670/30",
	"561 720/60",
	"561 589/15",
	"561 577/15",
	"561 640/20",
	"561 615/24",
	"405 670/30",
	"405 720/60",
	"405 750LP",
	"405 460/22",
	"405 420/10",
	"405 615/24",
	"405 525/50",
	"355 525/50",
	"355 670/30",
	"355 700LP",
	"355 447/60",
	"355 387/11",
	"640 720/60",
	"640 775/50",
	"640 800LP",
	"640 670/30"
];



(* ::Subsubsection::Closed:: *)
(*FlowCytometerAcquisitionModeP*)


FlowCytometerInjectionModeP=Alternatives[
	Individual,
	Continuous
];



(* ::Subsubsection::Closed:: *)
(*FlowCytometryLaserWavelengthP*)


FlowCytometryLaserWavelengthP=_?(Function[
	testWavelength,
	Or@@(Equal[testWavelength,#]&/@{
		355 Nano Meter,
		405 Nano Meter,
		407 Nano Meter,
		488 Nano Meter,
		532 Nano Meter,
		561 Nano Meter,
		592 Nano Meter,
		633 Nano Meter,
		640 Nano Meter,
		642 Nano Meter
	})
]);



(* ::Subsubsection::Closed:: *)
(*FlowCytometryFluorescenceChannelP*)


FlowCytometryFluorescenceChannelP=Alternatives[
	FITC,
	PE,
	APC,
	PECy55
];


(* ::Subsubsection::Closed:: *)
(*LyophilizationCoverP*)


LyophilizationCoverP = Alternatives[BreathableSeal,Chemwipe];


(* ::Subsubsection::Closed:: *)
(*CentrifugeTypeP*)


CentrifugeTypeP=Alternatives[
	Tabletop,
	Micro,
	AutomatedMicro,
	Touch,
	Ultra
];



(* ::Subsubsection::Closed:: *)
(*BlowGunTypeP*)


BlowGunTypeP = Alternatives[ThumbLever, ThumbButton, PistolGrip];



(* ::Subsubsection::Closed:: *)
(*BlowGunGasTypeP*)


BlowGunGasTypeP = Alternatives[Nitrogen, Argon, Air];



(* ::Subsubsection::Closed:: *)
(*NitrogenEvaporatorTypeP*)


NitrogenEvaporatorTypeP = Alternatives[PlateDryer,TubeDryer];


(* ::Subsubsection::Closed:: *)
(*ElectrochemicalParameterP*)


ElectrochemicalParameterP = (pH| Conductivity| Ion| ORP|None);



(* ::Subsubsection::Closed:: *)
(*ConductivityMeasurementTypeP*)


ConductivityMeasurementTypeP = Alternatives[Amperometric, Potentiometric];


(* ::Subsubsection::Closed:: *)
(*AcousticLiquidHandlerCalibrationTypeP*)


AcousticLiquidHandlerCalibrationTypeP=Alternatives[
	DMSO,
	Glycerol,
	AqueousWithSurfactant,
	AqueousWithoutSurfactant
];


(* ::Subsubsection::Closed:: *)
(*AcousticLiquidHandlingOptimizationTypeP*)


AcousticLiquidHandlingOptimizationTypeP=Alternatives[
	OptimizeThroughput,
	SourcePlateCentric,
	DestinationPlateCentric,
	PreserveTransferOrder
];


(* ::Subsubsection::Closed:: *)
(*EnvironmentalControlsP*)


EnvironmentalControlsP=Alternatives[
	Temperature,
	Humidity,
	UVLight,
	VisibleLight
];



(* ::Subsubsection::Closed:: *)
(*StorageTemperatureP*)


StorageTemperatureP=Alternatives[-165Celsius,-80Celsius,-20Celsius,4Celsius,25Celsius,30Celsius,37Celsius];



(* ::Subsubsection::Closed:: *)
(*HumidityP*)


HumidityP=Alternatives[93 Percent, 70 Percent, 65 Percent, 60 Percent];



(* ::Subsubsection::Closed:: *)
(*UVLightIntensityP*)


UVLightIntensityP=Alternatives[36Watt/(Meter^2)];



(* ::Subsubsection::Closed:: *)
(*VisibleLightIntensityP*)


VisibleLightIntensityP=Alternatives[29 Kilo Lumen/(Meter^2)];



(* ::Subsection::Closed:: *)
(*Sensor patterns*)


(* ::Subsubsection::Closed:: *)
(*SensorStatusP*)


SensorStatusP=(UndergoingMaintenance|Inactive| Stocked | Available | InUse | Discarded | Transit | Installed);



(* ::Subsubsection::Closed:: *)
(*SensorDataTypeP*)


SensorDataTypeP=Alternatives[
	Object[Data,CarbonDioxide],
	Object[Data,Conductivity],
	Object[Data,LiquidLevel],
	Object[Data,pH],
	Object[Data,Pressure],
	Object[Data,RelativeHumidity],
	Object[Data,Temperature],
	Object[Data,Volume],
	Object[Data,Weight]
];



(* ::Subsubsection::Closed:: *)
(*SensorMaintenanceTypeP*)


SensorMaintenanceTypeP=Alternatives[maintenance[CalibrateCarbonDioxide],maintenance[CalibrateConductivity], maintenance[CalibrateLevel],maintenance[CalibratepH],maintenance[CalibrateCarbonDioxide], maintenance[CalibrateTemperature], maintenance[CalibrateRelativeHumidity],maintenance[CalibratePressure], maintenance[CalibrateVolume],maintenance[CalibrateWeight]];



(* ::Subsubsection::Closed:: *)
(*SensorLogTypeP*)


SensorLogTypeP=Alternatives["60SecondsLog", "5SecondsLog","0.5SecondsLog"];



(* ::Subsubsection::Closed:: *)
(*SensorOutputTypeP*)


SensorOutputTypeP=Alternatives[Analog4to20mA, Analog0to5V,Analog0to10V, Digital, ContactClosure, PWM, Frequency, RS232, RS485, ResistorBridge];


(* ::Subsubsection::Closed:: *)
(*PLCVariableTypeP*)


PLCVariableTypeP=Alternatives[INT,LREAL,DINT,BOOL,STRING, UDINT];



(* ::Subsubsection::Closed:: *)
(*PLCVariableTypeP*)


(*Pattern for the PLCWrite helper function in the form {Variable Name, Velue to write to PLC, Beckhoff PLC variable}*)
PLCCommandP = {
   	(*Variable*)
   	_?StringQ,
   	(*Command*)
   	NumericP|BooleanP|_?StringQ,
   	(*Variable Type as defined onthe PLC.  IEC61131-3 variable types are defined here: https://infosys.beckhoff.com/english.php?content=../content/1033/tc3_system/html/tcsysmgr_datatypecomparison.htm&id=)*)
   	PLCVariableTypeP
   };


(* ::Subsubsection::Closed:: *)
(*PLCRequestP*)
(*Pattern for the PLCRead helper function in the form {Variable Name, Beckhoff PLC variable}*)


PLCRequestP = {_?StringQ, PLCVariableTypeP};


(* ::Subsection::Closed:: *)
(*Data patterns*)


(* ::Subsubsection::Closed:: *)
(*FluorescenceSpectroscopyDataP*)


FluorescenceSpectroscopyDataP=(StandardCurve|Analyte);



(* ::Subsubsection::Closed:: *)
(*FluorescenceSpectrumTypeP*)


FluorescenceSpectrumTypeP=(EmissionSpectrum|ExcitationSpectrum);



(* ::Subsubsection::Closed:: *)
(*FluorescenceIntensityDataP*)


FluorescenceIntensityDataP=(Blank|Analyte);



(* ::Subsubsection::Closed:: *)
(*FluorescenceThermodynamicsDataP*)


FluorescenceThermodynamicsDataP=(PassiveReference|Analyte);



(* ::Subsubsection::Closed:: *)
(*MassSpectrometryDataTypeP*)


MassSpectrometryDataTypeP=(Matrix|Analyte|Calibrant|SystemPrime|SystemFlush);


(* ::Subsubsection::Closed:: *)
(*MassSpecScanModeP*)


(*SelectedReactionMonitoring was removed, since it's overlaped with MRM*)
MassSpecScanModeP = (FullScan|SelectedIonMonitoring|PrecursorIonScan|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring);


(* ::Subsubsection::Closed:: *)
(*ChromatographyDataTypeP*)


ChromatographyDataTypeP=(Analyte|BatchStandard|Standard|Prime|Flush|Ladder|SystemPrime|SystemFlush|Blank);



(* ::Subsubsection::Closed:: *)
(*ChromatographyMassSpectraP *)


ChromatographyMassSpectraP =(Analyte|BatchStandard|Standard|Prime|Flush|Ladder|SystemPrime|SystemFlush|Blank|Calibrant);



(* ::Subsubsection::Closed:: *)
(*CyclicVoltammetryDataTypeP*)


CyclicVoltammetryDataTypeP=(ElectrodePretreatment|CyclicVoltammetryMeasurement|PostMeasurementStandardAddition);



(* ::Subsubsection::Closed:: *)
(*ElectrochemicalModeP*)


ElectrochemicalModeP = (ConstantVoltage | ConstantCurrent | CyclicVoltammetry);



(* ::Subsubsection::Closed:: *)
(*ElectrodeRoleP*)


ElectrodeRoleP=(WorkingElectrode|ReferenceElectrode|CounterElectrode|Anode|Cathode);



(* ::Subsubsection::Closed:: *)
(*ElectrodeShapeP*)


ElectrodeShapeP=(Disc|Plate|Rod|Foil|Micro);



(* ::Subsubsection::Closed:: *)
(*ReferenceElectrodeTypeP*)


ReferenceElectrodeTypeP=("Bare-Ag" | "Pseudo-Ag" | "Ag/AgCl" | "Ag/Ag+");



(* ::Subsubsection::Closed:: *)
(*ElectrodeCapTypeP*)


ElectrodeCapTypeP=(Regular|ProSeal|Calibration);



(* ::Subsubsection::Closed:: *)
(*GasWashingBottlePorosityP*)


GasWashingBottlePorosityP=(Coarse|ExtraCoarse);



(* ::Subsubsection::Closed:: *)
(*PAGEDataTypeP*)


PAGEDataTypeP=(Analyte|Standard|Ladder);



(* ::Subsubsection::Closed:: *)
(*AbsorbanceSpectroscopyDataTypeP*)


AbsorbanceSpectroscopyDataTypeP=(Empty|Blank|Analyte);



(* ::Subsubsection::Closed:: *)
(*AbsorbanceThermodynamicsDataTypeP*)


AbsorbanceThermodynamicsDataTypeP=(Blank|Analyte);


(* ::Subsubsection::Closed:: *)
(*CircularDichroismDataTypeP*)


CircularDichroismDataTypeP=(Empty|Blank|Analyte);



(* ::Subsubsection::Closed:: *)
(*NephelometryMethodTypeP*)


NephelometryMethodTypeP:=Alternatives[Solubility,CellCount];


(* ::Subsubsection::Closed:: *)
(*EnantiomericExcessDataTypeP*)


EnantiomericExcessDataTypeP=(Analyte|Standard);


(* ::Subsubsection::Closed:: *)
(*ParameterizationMeasurementTypeP*)

ParameterizationMeasurementTypeP=Alternatives[
	PrimaryOuterDimensionsCaliperVerificationLengthMeasurement,
	SecondaryOuterDimensionsCaliperVerificationLengthMeasurement,
	TertiaryOuterDimensionsCaliperVerificationLengthMeasurement,
	PrimaryBottomXMeasurement,
	SecondaryBottomXMeasurement,
	PrimaryBottomYMeasurement,
	SecondaryBottomYMeasurement,
	PrimaryTopXMeasurement,
	SecondaryTopXMeasurement,
	PrimaryTopYMeasurement,
	SecondaryTopYMeasurement,
	PrimaryMiddleXMeasurement,
	SecondaryMiddleXMeasurement,
	PrimaryMiddleYMeasurement,
	SecondaryMiddleYMeasurement,
	PrimaryHeightDimensionsHeightGaugeVerificationLengthMeasurement,
	SecondaryHeightDimensionsHeightGaugeVerificationLengthMeasurement,
	TertiaryHeightDimensionsHeightGaugeVerificationLengthMeasurement,
	PrimaryFlangeHeightMeasurement,
	SecondaryFlangeHeightMeasurement,
	TertiaryFlangeHeightMeasurement,
	QuaternaryFlangeHeightMeasurement,
	PrimaryTotalHeightMeasurement,
	SecondaryTotalHeightMeasurement,
	TertiaryTotalHeightMeasurement,
	QuaternaryTotalHeightMeasurement,
	PrimaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement,
	SecondaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement,
	TertiaryHorizontalWellDimensionsCaliperVerificationLengthMeasurement,
	PrimaryXMarginLeftMeasurement,
	PrimaryXMarginRightMeasurement,
	PrimaryColumnNumberMeasurement,
	PrimaryWellXDimensionMeasurement,
	SecondaryWellXDimensionMeasurement,
	PrimaryWellXSpacingMeasurement,
	SecondaryWellXSpacingMeasurement,
	PrimaryWellXMaxWidthMeasurement,
	PrimaryWellXMinMaxWidthMeasurement,
	PrimaryVerticalWellDimensionsCaliperVerificationLengthMeasurement,
	SecondaryVerticalWellDimensionsCaliperVerificationLengthMeasurement,
	TertiaryVerticalWellDimensionsCaliperVerificationLengthMeasurement,
	PrimaryWellShapeMeasurement,
	PrimaryRowNumberMeasurement,
	PrimaryWellYDimensionMeasurement,
	SecondaryWellYDimensionMeasurement,
	PrimaryWellYSpacingMeasurement,
	SecondaryWellYSpacingMeasurement,
	PrimaryWellYMaxWidthMeasurement,
	PrimaryWellYMinMaxWidthMeasurement,
	PrimaryYMarginTopMeasurement,
	PrimaryYMarginBottomMeasurement,
	PrimaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement,
	SecondaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement,
	TertiaryBottomCavityDimensionsHeightGaugeVerificationLengthMeasurement,
	PrimaryPlateOnNoBlockHeightMeasurement,
	SecondaryPlateOnNoBlockHeightMeasurement,
	TertiaryPlateOnNoBlockHeightMeasurement,
	PrimaryFirstBlockHeightMeasurement,
	SecondaryFirstBlockHeightMeasurement,
	PrimaryPlateOnFirstBlockHeightMeasurement,
	SecondaryPlateOnFirstBlockHeightMeasurement,
	PrimarySecondBlockHeightMeasurement,
	SecondarySecondBlockHeightMeasurement,
	PrimaryPlateOnSecondBlockHeightMeasurement,
	SecondaryPlateOnSecondBlockHeightMeasurement,
	PrimaryThirdBlockHeightMeasurement,
	SecondaryThirdBlockHeightMeasurement,
	PrimaryPlateOnThirdBlockHeightMeasurement,
	SecondaryPlateOnThirdBlockHeightMeasurement,
	PrimaryFourthBlockHeightMeasurement,
	SecondaryFourthBlockHeightMeasurement,
	PrimaryPlateOnFourthBlockHeightMeasurement,
	SecondaryPlateOnFourthBlockHeightMeasurement,
	PrimaryFifthBlockHeightMeasurement,
	SecondaryFifthBlockHeightMeasurement,
	PrimaryPlateOnFifthBlockHeightMeasurement,
	SecondaryPlateOnFifthBlockHeightMeasurement,
	PrimaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement,
	SecondaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement,
	TertiaryWellDepthDimensionsDepthGaugeVerificationLengthMeasurement,
	PrimaryDepthRodHeightMeasurement,
	PrimaryDepthRodPlateHeightMeasurement,
	PrimaryWellDepthMeasurement,
	SecondaryWellDepthMeasurement,
	TertiaryWellDepthMeasurement,
	QuaternaryWellDepthMeasurement,
	QuinaryWellDepthMeasurement,
	PrimaryWellBottomShapeMeasurement,
	PrimaryConicalDepthMeasurement,
	SecondaryConicalDepthMeasurement,
	TertiaryConicalDepthMeasurement
];


(* ::Subsubsection::Closed:: *)
(*dPCRExcitationWavelengthP*)


dPCRExcitationWavelengthP=Alternatives[
	495. Nanometer,
	535. Nanometer,
	538. Nanometer,
	647. Nanometer,
	675. Nanometer
];

(*dPCREmissionWavelengthP*)
dPCREmissionWavelengthP=Alternatives[
	517. Nanometer,
	554. Nanometer,
	556. Nanometer,
	665. Nanometer,
	694. Nanometer
];



(* ::Subsubsection::Closed:: *)
(*qPCRReportingMethodP*)


qPCRReportingMethodP= Alternatives[Dye,MolecularBeacon,ScorpionProbe];


qPCRExcitationWavelengthP=Alternatives[
	470 Nanometer,
	520 Nanometer,
	550 Nanometer,
	580 Nanometer,
	640 Nanometer,
	662 Nanometer
];

qPCREmissionWavelengthP=Alternatives[
	520 Nanometer,
	558 Nanometer,
	586 Nanometer,
	623 Nanometer,
	682 Nanometer,
	711 Nanometer
];



(* ::Subsubsection::Closed:: *)
(*qPCRDataTypeP*)


qPCRDataTypeP= Alternatives[StandardCurve,Analyte,Blank,(*Deprecated past this point*)PassiveReference];


(* ::Subsubsection::Closed:: *)
(*qPCRCurveTypeP*)


qPCRCurveTypeP=Alternatives[PassiveReference,EndogenousControl,PrimaryAmplicon,Unused];


(* ::Subsubsection::Closed:: *)
(*qPCRTemplateOligomerP*)


qPCRTemplateOligomerP= Alternatives[DNA,RNA];





(* ::Subsection::Closed:: *)
(*PDU patterns*)


(* ::Subsubsection:: *)
(*PDUFieldsP*)


PDUFieldsP = Alternatives[PDUInstrument, PDUPart, PDUHeatBlock, PDUVacuumController, PDURotationController, PDUWaterBath,PDUFanFilterUnitController,PDUUVLampController];



(* ::Subsubsection::Closed:: *)
(*NumberOfPDUPortsP*)


NumberOfPDUPortsP = Alternatives[4, 8];



(* ::Subsubsection::Closed:: *)
(*PDUPortP*)


PDUPortP = Alternatives@@Range[1,Max@@NumberOfPDUPortsP];



(* ::Subsubsection::Closed:: *)
(*PDUActionP*)


PDUActionP = Alternatives[On, Off];



(* ::Subsubsection::Closed:: *)
(*PDUPortNameP*)


PDUPortNameP= GreaterP[0,1];



(* ::Subsection::Closed:: *)
(*Regulatory Codes*)


(* ::Subsubsection::Closed:: *)
(*NFPAP*)


NFPAP::usage="
DEFINITIONS
	{
		Health\[Rule]0|1|2|3|4,
		Flammability\[Rule]0|1|2|3|4,
		Reactivity\[Rule]0|1|2|3|4,
		Special\[Rule]\"Oxidizer\"|\"Water Reactive\"|\"Aspyxiant\"|\"Corrosive\"|\"Acid\"|\"Bio\"|\"Poisonous\"|\"Radioactive\"|\"Cryogenic\"|None
	}
		 Pattern for National Fire Protection Association (NFPA) 704 hazard diamond classification.
";

NFPAP={
	Health->0|1|2|3|4,
	Flammability->0|1|2|3|4,
	Reactivity->0|1|2|3|4,
	Special->{(Oxidizer|WaterReactive|Aspyxiant|Corrosive|Acid|Bio|Poisonous|Radioactive|Cryogenic|Null)...}
};



(* ::Subsubsection::Closed:: *)
(*DOTHazardClassP*)


DOTHazardClassP::usage="
DEFINITIONS
	DOTHazardClassP=Alternatives[\[IndentingNewLine]		\"Class 0\",\[IndentingNewLine]		\"Class 1 Division 1.1 Mass Explosion Hazard\",\[IndentingNewLine]		\"Class 1 Division 1.2 Projection Hazard\",\[IndentingNewLine]		\"Class 1 Division 1.3 Fire, Blast, or Projection Hazard\",\[IndentingNewLine]		\"Class 1 Division 1.4 Limited Explosion\",\[IndentingNewLine]		\"Class 1 Division 1.5 Insensitive Mass Explosion Hazard\",\[IndentingNewLine]		\"Class 1 Division 1.6 Insensitive No Mass Explosion Hazard\",\[IndentingNewLine]		\"Class 2 Division 2.1 Flammable Gas Hazard\",\[IndentingNewLine]		\"Class 2 Division 2.2 Non-Flammable Gas Hazard\",\[IndentingNewLine]		\"Class 2 Division 2.3 Toxic Gas Hazard\",\[IndentingNewLine]		\"Class 3 Flammable Liquids Hazard\",\[IndentingNewLine]		\"Class 4 Division 4.1 Flammable Solid Hazard\",\[IndentingNewLine]		\"Class 4 Division 4.2 Spontaneously Combustible Hazard\",\[IndentingNewLine]		\"Class 4 Division 4.3 Dangerous when Wet Hazard\",\[IndentingNewLine]		\"Class 5 Division 5.1 Oxidizers Hazard\",\[IndentingNewLine]		\"Class 5 Division 5.2 Organic Peroxides Hazard\",\[IndentingNewLine]		\"Class 6 Division 6.1 Toxic Substances Hazard\",\[IndentingNewLine]		\"Class 6 Division 6.2 Infectious Substances Hazard\",\[IndentingNewLine]		\"Class 7 Division 7 Radioactive Material Hazard\",\[IndentingNewLine]		\"Class 8 Division 8 Corrosives Hazard\",\[IndentingNewLine]		\"Class 9 Miscellaneous Dangerous Goods Hazard\"\[IndentingNewLine]	]
		 Pattern for Department of Transportation (DOT) hazard classification.
";

DOTHazardClassP=Alternatives[
	"Class 0",
	"Class 1 Division 1.1 Mass Explosion Hazard",
	"Class 1 Division 1.2 Projection Hazard",
	"Class 1 Division 1.3 Fire, Blast, or Projection Hazard",
	"Class 1 Division 1.4 Limited Explosion",
	"Class 1 Division 1.5 Insensitive Mass Explosion Hazard",
	"Class 1 Division 1.6 Insensitive No Mass Explosion Hazard",
	"Class 2 Division 2.1 Flammable Gas Hazard",
	"Class 2 Division 2.2 Non-Flammable Gas Hazard",
	"Class 2 Division 2.3 Toxic Gas Hazard",
	"Class 3 Flammable Liquids Hazard",
	"Class 4 Division 4.1 Flammable Solid Hazard",
	"Class 4 Division 4.2 Spontaneously Combustible Hazard",
	"Class 4 Division 4.3 Dangerous when Wet Hazard",
	"Class 5 Division 5.1 Oxidizers Hazard",
	"Class 5 Division 5.2 Organic Peroxides Hazard",
	"Class 6 Division 6.1 Toxic Substances Hazard",
	"Class 6 Division 6.2 Infectious Substances Hazard",
	"Class 7 Division 7 Radioactive Material Hazard",
	"Class 8 Division 8 Corrosives Hazard",
	"Class 9 Miscellaneous Dangerous Goods Hazard"
];



(* ::Subsubsection::Closed:: *)
(*SampleStorageTypeP*)


SampleStorageTypeP=Alternatives[
	AmbientStorage,
	Refrigerator,
	Freezer,
	DeepFreezer,
	CryogenicStorage,
	YeastIncubation,
	YeastShakingIncubation,
	BacterialIncubation,
	BacterialShakingIncubation,
	MammalianIncubation,
	ViralIncubation,
	CrystalIncubation,
	AcceleratedTesting,
	IntermediateTesting,
	LongTermTesting,
	UVVisLightTesting
];

$IncubatorStorageConditions={
	Model[StorageCondition, "Mammalian Incubation"],
	Model[StorageCondition, "Bacterial Incubation"],
	Model[StorageCondition, "Bacterial Incubation with Shaking"],
	Model[StorageCondition, "Yeast Incubation"],
	Model[StorageCondition, "Yeast Incubation with Shaking"],
	Model[StorageCondition, "Crystal Incubation"]
};

(* ::Subsubsection::Closed:: *)
(*CellStorageTypeP*)


CellStorageTypeP=Alternatives[Freezer,DeepFreezer,CryogenicStorage];




(* ::Subsubsection::Closed:: *)
(*AtmosphereP*)


AtmosphereP=Alternatives[
	Ambient,
	Nitrogen,
	Argon,
	Vacuum
];


(* ::Subsubsection::Closed:: *)
(*FireCodeHazardClassP*)


FireCodeHazardClassP::usage="
DEFINITIONS
	The Unified Program uses the current lists of hazard classes included in Article 80 of the Uniform Fire Code.
	Patterns for the code are:
	\"Class 1: Carcinogen\",
	\"Class 2: Combustible Liquid, Class II\",
	\"Class 3: Combustible Liquid, Class III-A\",
	\"Class 4: Combustible Liquid, Class III-B\",
	\"Class 5: Corrosive\",
	\"Class 6: Cryogen\",
	\"Class 7: Explosive\",
	\"Class 8: Flammable Gas\",
	\"Class 9: Flammable Liquid, Class I-A\",
	\"Class 10: Flammable Liquid, Class I-B\",
	\"Class 11: Flammable Liquid, Class I-C\",
	\"Class 12: Flammable Solid\",
	\"Class 13: Highly Toxic\",
	\"Class 14: Irritant\",
	\"Class 15: Liquified Petroleum Gas\",
	\"Class 16: Magnesium\",
	\"Class 17: Oxidizing, Class 1\",
	\"Class 18: Oxidizing, Class 2\",
	\"Class 19: Oxidizing, Class 3\",
	\"Class 20: Oxidizing, Class 4\",
	\"Class 21: Oxidizing Gas, Gaseous\",
	\"Class 22: Oxidizing Gas, Liquified\",
	\"Class 23: Organic Peroxide, Class I\",
	\"Class 24: Organic Peroxide, Class II\",
	\"Class 25: Organic Peroxide, Class III\",
	\"Class 26: Organic Peroxide, Class IV\",
	\"Class 27: Other Health Hazard\",
	\"Class 28: Pyrophoric\",
	\"Class 29: Radioactive\",
	\"Class 30: Sensitizer\",
	\"Class 31: Toxic\",
	\"Class 32: Unstable (Reactive), Class 1\",
	\"Class 33: Unstable (Reactive), Class 2\",
	\"Class 34: Unstable (Reactive), Class 3\",
	\"Class 35: Unstable (Reactive), Class 4\",
	\"Class 36: Water Reactive, Class 1\",
	\"Class 37: Water Reactive, Class 2\",
	\"Class 38: Water Reactive, Class 3\",
	\"Class 39: Other\"
";

FireCodeHazardClassP=Alternatives[
	"Class 1: Carcinogen",
	"Class 2: Combustible Liquid, Class II",
	"Class 3: Combustible Liquid, Class III-A",
	"Class 4: Combustible Liquid, Class III-B",
	"Class 5: Corrosive",
	"Class 6: Cryogen",
	"Class 7: Explosive",
	"Class 8: Flammable Gas",
	"Class 9: Flammable Liquid, Class I-A",
	"Class 10: Flammable Liquid, Class I-B",
	"Class 11: Flammable Liquid, Class I-C",
	"Class 12: Flammable Solid",
	"Class 13: Highly Toxic",
	"Class 14: Irritant",
	"Class 15: Liquified Petroleum Gas",
	"Class 16: Magnesium",
	"Class 17: Oxidizing, Class 1",
	"Class 18: Oxidizing, Class 2",
	"Class 19: Oxidizing, Class 3",
	"Class 20: Oxidizing, Class 4",
	"Class 21: Oxidizing Gas, Gaseous",
	"Class 22: Oxidizing Gas, Liquified",
	"Class 23: Organic Peroxide, Class I",
	"Class 24: Organic Peroxide, Class II",
	"Class 25: Organic Peroxide, Class III",
	"Class 26: Organic Peroxide, Class IV",
	"Class 27: Other Health Hazard",
	"Class 28: Pyrophoric",
	"Class 29: Radioactive",
	"Class 30: Sensitizer",
	"Class 31: Toxic",
	"Class 32: Unstable (Reactive), Class 1",
	"Class 33: Unstable (Reactive), Class 2",
	"Class 34: Unstable (Reactive), Class 3",
	"Class 35: Unstable (Reactive), Class 4",
	"Class 36: Water Reactive, Class 1",
	"Class 37: Water Reactive, Class 2",
	"Class 38: Water Reactive, Class 3",
	"Class 39: Other"
];



(* ::Subsubsection::Closed:: *)
(*BiosafetyLevelP*)


BiosafetyLevelP::usage="
DEFINITIONS
	\"BSL-1\"|\"BSL-2\"|\"BSL-3\"|\"BSL-4\"
		 Pattern for the centers for disease control and prevention (CDC) BioSafty level classification.
";

BiosafetyLevelP=("BSL-1"|"BSL-2"|"BSL-3"|"BSL-4");



(* ::Subsubsection::Closed:: *)
(*FlammableCabinetCertificationP*)


FlammableCabinetCertificationP=Alternatives[
	"NFPA Flammable Liquid Storage Code 30",
	"OSHA 1910.106 Class I/II/III Liquids"
];


(* ::Subsubsection::Closed:: *)
(*PolymerArrangementP*)


PolymerArrangementP=Alternating|Periodic|Statistical|Block|Grafted;


(* ::Subsubsection::Closed:: *)
(*PolymerTacticityP*)


PolymerTacticityP=Isotactic|Syndiotactic|Atactic;


(* ::Subsubsection::Closed:: *)
(*InChIP*)


InChIP=_String?(StringMatchQ[#,"InChI="~~__]&);


(* ::Subsubsection::Closed:: *)
(*InChIKeyP*)


InChIKeyP=_String?(StringMatchQ[#,WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~WordCharacter~~"-"~~WordCharacter]&);


(* ::Subsubsection::Closed:: *)
(*ThermoFisherURLP*)


ThermoFisherURLP=_String?(MatchQ[#,URLP]&&StringContainsQ[#,"thermofisher.com"]&);


(* ::Subsubsection::Closed:: *)
(*MilliporeSigmaURLP*)


MilliporeSigmaURLP=_String?(MatchQ[#,URLP]&&StringContainsQ[#,"sigmaaldrich.com"]&);


(* ::Subsubsection::Closed:: *)
(*FisherScientificURLP*)


FisherScientificURLP=_String?(MatchQ[#,URLP]&&StringContainsQ[#,"fishersci.com"]&);


(* ::Subsubsection::Closed:: *)
(*PurityP*)


PurityP::usage="
DEFINITIONS
	PurityP={Area->{_?NumericQ..},RelativeArea->{_?PercentQ..},PeakLabels->{_String..}}
		Matches the output of PeakPurity[ ] function
";
PurityP={Area->{_?NumericQ..},RelativeArea->{_?PercentQ..},PeakLabels->{_String..}};



(* ::Subsection::Closed:: *)
(*Maintenance patterns*)


(* ::Subsubsection::Closed:: *)
(*RotationDirectionP*)


RotationDirectionP=Alternatives[Clockwise,Counterclockwise];




(* ::Subsubsection::Closed:: *)
(*LampTypeP*)


LampTypeP=Alternatives[XenonLamp,MercuryLamp,HalogenLamp,DeuteriumLamp,TungstenLamp,Fiber,LED,SiliconCarbide];


(* ::Subsubsection::Closed:: *)
(*LampOperationModeP*)


LampOperationModeP=Alternatives[Arc, Flash];



(* ::Subsubsection:: *)
(*BatteryTypeP*)


BatteryTypeP=Alternatives[AC,C,AA,AAA,D,9V,5VLithiumIon1050mAh,3.7VLithiumPolymer,CR2032,BarcodeScanner,SR44];



(* ::Subsubsection::Closed:: *)
(*TachometerModeP*)


TachometerModeP = Alternatives[Laser, Contact, IR, Surface];



(* ::Subsubsection::Closed:: *)
(*LampWindowMaterialP*)


LampWindowMaterialP = Alternatives[UVGlass, FusedSilica, MgF2, SilicateGlass];



(* ::Subsubsection::Closed:: *)
(*CleaningMethodP*)


(* different cleaning methods available at ECL - all the types of dishwashing and handwash *)
CleaningMethodP = Alternatives[DishwashMethodP, Handwash];



(* ::Subsubsection::Closed:: *)
(*CleaningTypeP*)


(* Used to classify Object[Container, WashBin] *)
CleaningTypeP = Alternatives[NeedleWash, Dishwash, Autoclave];



(* ::Subsubsection::Closed:: *)
(*DishwashMethodP*)


(* different types of dishwashing available *)
DishwashMethodP = Alternatives[DishwashIntensive, DishwashPlastic, DishwashPlateSeals];



(* ::Subsection::Closed:: *)
(*Qualification patterns*)


(* ::Subsubsection::Closed:: *)
(*FluorescenceReaderResultP*)


FluorescenceReaderResultP = Alternatives[Negative,Positive];



(* ::Subsubsection::Closed:: *)
(*SteamIntegratorResultP*)


SteamIntegratorResultP = Alternatives[Accept,Reject];



(* ::Subsubsection::Closed:: *)
(*QualificationResultP*)


QualificationResultP = Alternatives[Pass,Fail];


(* ::Subsubsection::Closed:: *)
(*FailureModeP*)


FailureModeP = Alternatives[Instrument,Operator,Sample,Procedure,Undetermined];



(* ::Subsubsection::Closed:: *)
(*WeightMaterialP*)


WeightMaterialP= Alternatives[
	VacuumMeltedStainlessSteel
];



(* ::Subsubsection::Closed:: *)
(*WeightShapeP*)


WeightShapeP= Alternatives[
	TriangleWire,
	SquareWire,
	PentagonWire,
	KnobbedCylinder
];



(* ::Subsubsection::Closed:: *)
(*OIMLWeightClassP*)


OIMLWeightClassP= Alternatives[
	E1, E2, F1, F2, M1, M12, M2, M23, M3
];



(* ::Subsubsection:: *)
(*Connector patterns*)


(* ::Subsubsection::Closed:: *)
(*ConnectorP*)


ConnectorP = Alternatives[Threaded, Barbed, LuerLock, SlipLuer, Flared, QuickDisconnect, PushToConnect, CompressionFitting, Tube, Fused, TaperGroundGlass, SphericalGroundGlass,TriCloverClamp,Viper];



(* ::Subsubsection::Closed:: *)
(*ConnectorGenderP*)


ConnectorGenderP = Alternatives[Male, Female];



(* ::Subsubsection::Closed:: *)
(*ConnectionTypeP*)


ConnectionTypeP = Alternatives[Plumbing, Wiring];



(* ::Subsubsection::Closed:: *)
(*WiringConnectorP*)


WiringConnectorP = Alternatives[Direct, ExposedWire, AlligatorClipP, ElectrodeConnectorP, PowerPlugTypeP, DataConnectorTypeP];



(* ::Subsubsection::Closed:: *)
(*AlligatorClipP*)


AlligatorClipP = Alternatives[_String?(StringMatchQ[#,Alternatives["Alligator ", "Micro ", "Long Nose ", "Flat ", "Insulation Piercing "]~~Alternatives["Toothed ", "Toothless "]~~Alternatives["3/16\"", "0.22\"", "1/4\"", "5/16\"", "7/16\"", "1/2\"", "1\""]]&)];



(* ::Subsubsection::Closed:: *)
(*ElectrodeConnectorP*)


ElectrodeConnectorP = Alternatives[ElectraSynElectrodeThreadedPlug, ElectraSynElectrodePushPlug, ElectraSynContactElectrode];



(* ::Subsubsection::Closed:: *)
(*PowerPlugTypeP*)


PowerPlugTypeP = Alternatives[NEMADesignationP, InternationalPowerPlugP];



(* ::Subsubsection::Closed:: *)
(*InternationalPowerPlugP*)


InternationalPowerPlugP = Alternatives[_String?(StringMatchQ[#,"Power Type"~~Alternatives["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O"]]&)];



(* ::Subsubsection::Closed:: *)
(*DataConnectorTypeP*)


DataConnectorTypeP = Alternatives[DSUBConnectorP, USBConnectorP, HDMIConnectorP, CoaxialConnectorP, EthernetConnectorP, GPIB];



(* ::Subsubsection::Closed:: *)
(*DSUBConnectorP*)


DSUBConnectorP = Alternatives[DA15, DB25, DC37, DD50, DE9, VGA];



(* ::Subsubsection::Closed:: *)
(*USBConnectorP*)


USBConnectorP = Alternatives[USBA, USBB, USBC, MicroA, MicroB, Minib5, Minib4, USB3A, USB3B, USB3MicroB];



(* ::Subsubsection::Closed:: *)
(*HDMIConnectorP*)


HDMIConnectorP = Alternatives[_String?(StringMatchQ[#,"HDMI Type"~~Alternatives["A","B","C","D","E"]]&)];



(* ::Subsubsection::Closed:: *)
(*CoaxialConnectorP*)


CoaxialConnectorP = Alternatives[BNC, TNC, RCA];



(* ::Subsubsection::Closed:: *)
(*CoaxialConnectorP*)


EthernetConnectorP = Alternatives[RJ45];



(* ::Subsubsection::Closed:: *)
(*MetricThreadP*)


MetricThreadP = Alternatives["M0.25x0.075","M0.3x0.08","M0.3x0.09","M0.35x0.09","M0.4x0.1","M0.45x0.1","M0.5x0.125","M0.55x0.125","M0.6x0.15","M0.7x0.175","M0.8x0.2","M0.9x0.225","M1x0.25","M1x0.2","M1.1x0.25","M1.1x0.2","M1.2x0.25","M1.2x0.2","M1.4x0.3","M1.4x0.2","M1.6x0.35","M1.6x0.3","M1.6x0.2","M1.7x0.35","M1.8x0.35","M1.8x0.2","M2x0.4","M2x0.25","M2.2x0.45","M2.2x0.25","M2.3x0.45","M2.3x0.4","M2.5x0.45","M2.5x0.35","M2.6x0.45","M3x0.5","M3x0.35","M3.5x0.6","M3.5x0.35","M4x0.7","M4x0.5","M4.5x0.75","M4.5x0.5","M5x0.8","M5x0.5","M5.5x0.5","M6x1","M6x0.8","M6x0.75","M6x0.7","M6x0.5","M6.25x0.9","M7x1","M7x0.75","M7x0.5","M8x1.25","M8x1","M8x0.8","M8x0.75","M8x0.5","M9x1.25","M9x1","M9x0.75","M9x0.5","M10x1.5","M10x1.25","M10x1.12","M10x1","M10x0.75","M10x0.5","M11x1.5","M11x1","M11x0.75","M11x0.5","M12x1.75","M12x1.5","M12x1.25","M12x1","M12x0.75","M12x0.5","M14x2","M14x1.5","M14x1.25","M14x1","M14x0.75","M14x0.5","M15x1.5","M15x1","M16x2","M16x1.6","M16x1.5","M16x1.25","M16x1","M16x0.75","M16x0.5","M17x1.5","M17x1","M18x2.5","M18x2","M18x1.5","M18x1.25","M18x1","M18x0.75","M18x0.5","M20x2.5","M20x2","M20x1.5","M20x1","M20x0.75","M20x0.5","M22x3","M22x2.5","M22x2","M22x1.5","M22x1","M22x0.75","M22x0.5","M24x3","M24x2.5","M24x2","M24x1.5","M24x1","M24x0.75","M25x2","M25x1.5","M25x1","M26x1.5","M27x3","M27x2","M27x1.5","M27x1","M27x0.75","M28x2","M28x1.5","M28x1","M30x3.5","M30x3","M30x2.5","M30x2","M30x1.5","M30x1","M30x0.75","M32x2","M32x1.5","M33x3.5","M33x3","M33x2","M33x1.5","M33x1","M33x0.75","M35x1.5","M36x4","M36x3","M36x2","M36x1.5","M36x1","M38x1.5","M39x4","M39x3","M39x2","M39x1.5","M39x1","M40x3","M40x2.5","M40x2","M40x1.5","M42x4.5","M42x4","M42x3","M42x2","M42x1.5","M42x1","M45x4.5","M45x4","M45x3","M45x2","M45x1.5","M45x1","M48x5","M48x4","M48x3","M48x2","M48x1.5","M50x4","M50x3","M50x2","M50x1.5"];



(* ::Subsubsection::Closed:: *)
(*MeasurementMethodP*)


MeasurementMethodP = Alternatives[Temperature, CarbonDioxide, UltrasonicDistance, RelativeHumidity, Weight, pH, Conductivity, LiquidLevel, Pressure, Counter, FlowRate, Moisture, Oxygen, Light, Distance];



(* ::Subsubsection::Closed:: *)
(*NotchPositionP*)


NotchPositionP = Alternatives[TopLeft, TopRight, BottomLeft, BottomRight];



(* ::Subsubsection::Closed:: *)
(*StandardThreadP*)


StandardThreadP = Alternatives["0-80","1-64","2-56","2-64","4-40","4-48","5-40","5-44","6-32","6-40","8-32","8-36","10-24","10-32","1/4-20","1/4-28","5/16-18","5/16-24","3/8-16","3/8-24","7/16-14","7/16-20","7/16-24","1/2-13","1/2-20","9/16-12","9/16-18","5/8-11","5/8-18","3/4-10","3/4-16","7/8-9","7/8-14","1-8","1-14","1 1/8-7","1 1/8-12","1 1/4-7","1 3/8-6","1 1/2-6","1 3/4-5","2-4.5", "83B", "53B"];



(* ::Subsubsection::Closed:: *)
(*PipeThreadP*)


PipeThreadP = Alternatives["1/16 NPT", "1/8 NPT", "1/4 NPT", "3/8 NPT", "1/2 NPT", "3/4 NPT", "1 NPT", "1 1/4 NPT", "1 1/2 NPT", "2 NPT"];



(* ::Subsubsection::Closed:: *)
(*GPIThreadP*)


GPIThreadP = _String?(StringMatchQ[
	#1,
	("GPI" ~~ " " ~~ DigitCharacter ~~ DigitCharacter | "" ~~ "-" ~~ "400" | "410" | "415" | "425" | "430" | "2000")
]&);



(* ::Subsubsection::Closed:: *)
(*ThreadP*)


ThreadP = (StandardThreadP | PipeThreadP | MetricThreadP|GPIThreadP);



(* ::Subsubsection::Closed:: *)
(*MetalP*)


MetalP = Alternatives[
	Aluminum,
	Alloy,
	AnodisedAluminum,
	Brass,
	Bronze,
	CarbonSteel,
	CastIron,
	Chrome,
	Copper,
	(* Elgiloy (Co-Cr-Ni Alloy) is a "super-alloy" consisting of 39-41% Cobalt, 19-21% Chromium,
	14-16% Nickel, 11.3-20.5% Iron, 6-8% Molybdenum, and 1.5-2.5% Manganese. *)
	Elgiloy,
	(*Hastelloy\[RegisteredTrademark] and Incoloy\[RegisteredTrademark] are both members of the \[OpenCurlyDoubleQuote]superalloy\[CloseCurlyDoubleQuote] family, also known as high-performance alloys.
	As such, they have several key characteristics in common. They both possess excellent mechanical strength,
	especially at high temperatures, and they are both highly resistant to corrosion and oxidation.*)
	Gold,
	Hastelloy,
	Lead,
	Magnesium,
	Molybdenum,
	Nickel,
	Niobium,
	Platinum,
	Silver,
	Steel,
	StainlessSteel,
	Titanium,
	Tungsten,
	Zinc
];



(* ::Subsubsection::Closed:: *)
(*MaterialP*)


MaterialP= Alternatives[
	PlasticP,
	MetalP,
	FilterMembraneMaterialP,
	(* ColumnPackingMaterialP = Silica|ResinParticlesWithLatexMicroBeads|CrossLinkedDextranBeads|AerisCoreShell|KinetexCoreShell|CrossLinkedAgarose|Vydac218MS|JordiGel|Styrene|SilicaCompositeTWIN|BEH *)
	ColumnPackingMaterialP,
	Polysulfone,
	Agate,
	AluminiumOxide,
	ZirconiumOxide,
	Cardboard,
	Ceramic,
	Epoxy,
	EpoxyResin,
	BorosilicateGlass,
	Glass,
	GlassyCarbon,
	Graphite,
	OpticalGlass,
	Porcelain,
	Quartz,
	UVQuartz,
	ESQuartz,
	FusedQuartz,
	IRQuartz,
	Oxidizer,
	Ruby,
	Sapphire,
	Silicon,
	Silver,
	(*Viton is a brand of synthetic rubber and fluoropolymer elastomer commonly used in O-rings,
	chemical-resistant gloves, and other molded or extruded goods. The name is a registered
	trademark of The Chemours Company.*)
	Viton,
	Styrofoam,
	WeightMaterialP,
	Wood
];



(* ::Subsubsection::Closed:: *)
(*ActuatorTypeP*)


ActuatorTypeP= Alternatives[Manual,Electrical,Pressure];



(* ::Subsection::Closed:: *)
(*Chromatography*)


(* ::Subsubsection::Closed:: *)
(*ChromatographyDetectorTypeP*)


ChromatographyDetectorTypeP = (Pressure | Temperature | Absorbance  | Conductance | MassSpectrometry | Fluorescence | EvaporativeLightScattering | UVVis | PhotoDiodeArray | CircularDichroism | RefractiveIndex | LightScattering | pH | MultiAngleLightScattering | DynamicLightScattering);


(* ::Subsubsection::Closed:: *)
(*HPLCDetectorTypeP*)


HPLCDetectorTypeP = (Pressure | Temperature  | Conductance | Fluorescence | EvaporativeLightScattering | UVVis | PhotoDiodeArray | CircularDichroism | RefractiveIndex | pH | MultiAngleLightScattering | DynamicLightScattering);

HPLCFractionCollectionDetectorTypeP = ( Fluorescence | UVVis | PhotoDiodeArray | pH | Conductance );

(* ::Subsubsection::Closed:: *)
(*ChromatographyMixerTypeP*)


ChromatographyMixerTypeP = (Static | Dynamic);



(* ::Subsubsection::Closed:: *)
(*ChromatographySampleTypeP*)


ChromatographySampleTypeP = (BatchStandard | Standard | Sample | Shutdown | Prime | Flush | SystemPrime | SystemFlush | Blank | BatchLadder | Ladder);



(* ::Subsubsection::Closed:: *)
(*InjectionTableP*)


InjectionTableP = (Standard | Sample | ColumnPrime | ColumnFlush | Blank );


(* ::Subsubsection::Closed:: *)
(*PurificationScaleP*)


PurificationScaleP = Preparative | Analytical | SemiPreparative;


(* ::Subsubsection::Closed:: *)
(*ColumnCompartmentTypeP *)


ColumnCompartmentTypeP  = Serial | Selector;



(* ::Subsubsection::Closed:: *)
(*ColumnConnectorTypeP *)


ColumnConnectorTypeP  = FemaleMale | FemaleFemale;


(* ::Subsubsection::Closed:: *)
(*ColumnTypeP*)


ColumnTypeP = Preparative | Analytical | Guard | Join | Load;



(* ::Subsubsection::Closed:: *)
(*ChromatographyScaleP*)


ChromatographyScaleP = Preparative | Analytical | Guard | Process;



(* ::Subsubsection::Closed:: *)
(*SeparationModeP*)


SeparationModeP = Alternatives[NormalPhase, ReversePhase, IonExchange, SizeExclusion, Affinity, Chiral];


(* ::Subsubsection::Closed:: *)
(*SolidPhaseExtractionTypeP*)


SolidPhaseExtractionTypeP = Alternatives[NormalPhase, ReversePhase, IonExchange];

(* ::Subsubsection::Closed:: *)
(*SelectionStrategyP*)
SelectionStrategyP = Positive|Negative;

(* ::Subsubsection::Closed:: *)
(*SamplePhaseP*)

SamplePhaseP = Alternatives[Aqueous, Organic, Biphasic, Unknown];

(* ::Subsubsection::Closed:: *)
(*TargetPhaseP*)

TargetPhaseP = Alternatives[Aqueous, Organic];

(* ::Subsubsection::Closed:: *)
(*TargetLayerP*)

TargetLayerP = Alternatives[Top, Bottom];

(* ::Subsubsection::Closed:: *)
(*ExtractionTechniqueP*)

ExtractionTechniqueP = Alternatives[Pipette, PhaseSeparator];


(* ::Subsubsection::Closed:: *)
(*SolidPhaseExtractionFunctionalGroupP*)


SolidPhaseExtractionFunctionalGroupP = Join[ColumnFunctionalGroupP,Alternatives[Silica,Carboxylate,AluminaA, AluminaB, AluminaN,
	Aminopropyl, Diol, Cyanopropyl, Florisil, HLB, WAX, MAX, MCX, WCX, SizeExclusion, Affinity, Chiral, Null]];


(* ::Subsubsection::Closed:: *)
(*SolidPhaseExtractionMethodP*)


SolidPhaseExtractionMethodP = Alternatives[Injection,Gravity,Pressure,Vacuum,Pipette,Centrifuge];


(* ::Subsubsection::Closed:: *)
(*PackingP*)


PackingP= Alternatives[Packed, Unpacked];


(* ::Subsubsection::Closed:: *)
(*ResinFunctionP*)


ResinFunctionP= Alternatives[SolidPhaseSynthesis, Chromatography];



(* ::Subsubsection::Closed:: *)
(*ColumnPackingTypeP*)


ColumnPackingTypeP= Alternatives[Prepacked,HandPacked,Cartridge,PLOT,WCOT,SCOT,Empty];



(* ::Subsubsection::Closed:: *)
(*ColumnPackingMaterialP*)


ColumnPackingMaterialP = Alternatives[Silica,Alumina,ResinParticlesWithLatexMicroBeads,CrossLinkedDextranBeads,CrossLinkedPolystyrene,AerisCoreShell,
	KinetexCoreShell,CrossLinkedAgarose,Vydac218MS,JordiGel,Styrene,SilicaCompositeTWIN,BEH,CSH,HSS,CarboPacPA1,CarboPacPA10,BEH];


(* ::Subsubsection::Closed:: *)
(*ColumnFunctionalGroupP*)


ColumnFunctionalGroupP = Alternatives[QuaternaryAmmoniumIon, C4, C8, C18, C18Aq, C30, DiVinylBenzene, Biphenyl, Amide, Amine, Polysaccharide, ProteinG];



(* ::Subsubsection::Closed:: *)
(*CartridgePackingTypeP*)


CartridgePackingTypeP= Alternatives[Prepacked,HandPacked];



(* ::Subsubsection::Closed:: *)
(*USPDesignationP*)


USPDesignationP = _Symbol?(MatchQ[
	StringSplit[
		ToString[#], {y : {DigitCharacter ..} :> ToExpression[y]}],
	Alternatives[
		{"G", RangeP[1, 51, 1]},
		{"G", 1, "AC"},
		{"L", RangeP[1, 125, 1]},
		{"S", RangeP[1, 12, 1]},
		{"S", 1, Alternatives["A", "AB", "C", "D", "NS"]}
	]] &);



(* ::Subsubsection::Closed:: *)
(*ChromatographyTypeP*)


ChromatographyTypeP = Alternatives[HPLC, FPLC, Flash, SupercriticalFluidChromatography,GasChromatography,IonChromatography];

(* ::Subsection::Closed:: *)
(*ColumnPositionP*)

ColumnPositionP = Alternatives[PositionA,PositionB,PositionC,PositionD,PositionE,PositionF,PositionG,PositionH];

(* ::Subsubsection::Closed:: *)
(*GCColumnPolarityP*)


GCColumnPolarityP = (NonPolar|Intermediate|Polar);


(* ::Subsubsection::Closed:: *)
(*GCColumnBondedP*)


GCColumnBondedP = (Bonded|NonBonded|Crosslinked);


(* ::Subsubsection::Closed:: *)
(*GCCarrierGasP*)


GCCarrierGasP = (Dihydrogen | InertGCCarrierGasP);


(* ::Subsubsection::Closed:: *)
(*InertGCCarrierGasP*)


InertGCCarrierGasP = (Helium | Dinitrogen);


(* ::Subsubsection::Closed:: *)
(*GCInletP*)


GCInletP = (SplitSplitless | Multimode);


(* ::Subsubsection::Closed:: *)
(*GCInletModeP*)


GCInletModeP = (Split|Splitless|PulsedSplit|PulsedSplitless|SolventVent|DirectInjection);


(* ::Subsubsection::Closed:: *)
(*GCDetectorP*)


GCDetectorP = (MassSpectrometer | FlameIonizationDetector);


(* ::Subsubsection::Closed:: *)
(*GCSamplingMethodP*)


GCSamplingMethodP = (LiquidInjection|HeadspaceInjection|SPMEInjection);


(* ::Subsubsection::Closed:: *)
(*GCVialPositionP*)


GCVialPositionP = (Top|Bottom);


(* ::Subsubsection::Closed:: *)
(*GCColumnModeP*)


GCColumnModeP = (ConstantFlowRate | ConstantPressure | FlowRateProfile | PressureProfile);


(* ::Subsubsection::Closed:: *)
(*GCBlankTypeP*)


GCBlankTypeP = (NoInjection|NoInjectionVolume);



(* ::Subsubsection::Closed:: *)
(*GCSamplePreparationOptionsP*)


GCSamplePreparationOptionsP = {
	Alternatives[
		BlankType -> (GCBlankTypeP|Null),
		StandardVial -> (ObjectP[{Model[Container],Object[Container]}]|Null),
		StandardAmount -> (RangeP[0*Milli*Liter,20*Milli*Liter]|Null),
		BlankVial -> (ObjectP[{Model[Container],Object[Container]}]|Null),
		BlankAmount -> (RangeP[0*Milli*Liter,20*Milli*Liter]|Null),
		Dilute -> (BooleanP|Null),
		DilutionSolventVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		SecondaryDilutionSolventVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		TertiaryDilutionSolventVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		Agitate -> (BooleanP|Null),
		AgitationTime -> (RangeP[0*Minute,600*Minute]|Null),
		AgitationTemperature -> (Alternatives[RangeP[30*Celsius,200*Celsius],Ambient]|Null),
		AgitationMixRate -> (RangeP[250*RPM,750*RPM]|Null),
		AgitationOnTime -> (RangeP[0*Second,600*Second]|Null),
		AgitationOffTime -> (RangeP[0*Second,600*Second]|Null),
		Vortex -> (BooleanP|Null),
		VortexMixRate -> (RangeP[0*RPM,2000*RPM]|Null),
		VortexTime -> (RangeP[0*Second,100*Second]|Null),
		HeadspaceSyringeTemperature -> (Alternatives[RangeP[40*Celsius,150*Celsius],Ambient]|Null),
		LiquidPreInjectionSyringeWash -> (BooleanP|Null),
		LiquidPreInjectionSyringeWashVolume -> (RangeP[1*Micro*Liter, 1000*Micro*Liter]|Null),
		LiquidPreInjectionSyringeWashRate -> (RangeP[0.1 Micro * Liter/Second, 100 Micro * Liter/Second]|Null),
		LiquidPreInjectionNumberOfSolventWashes -> (RangeP[0,50,1]|Null),
		LiquidPreInjectionNumberOfSecondarySolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidPreInjectionNumberOfTertiarySolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidPreInjectionNumberOfQuaternarySolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidSampleWash -> (BooleanP|Null),
		NumberOfLiquidSampleWashes -> (RangeP[0, 10]|Null),
		LiquidSampleWashVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		LiquidSampleFillingStrokes -> (RangeP[0, 15]|Null),
		LiquidSampleFillingStrokesVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		LiquidFillingStrokeDelay -> (RangeP[0*Second,10*Second]|Null),
		HeadspaceSyringeFlushing -> (Alternatives[Continuous,ListableP[BeforeSampleAspiration|AfterSampleInjection]]|Null),
		HeadspacePreInjectionFlushTime -> (RangeP[0*Second,60*Second]|Null),
		SPMECondition -> (BooleanP|Null),
		SPMEConditioningTemperature -> (RangeP[40*Celsius,350*Celsius]|Null),
		SPMEPreConditioningTime -> (RangeP[0*Minute,600*Minute]|Null),
		SPMEDerivatizingAgent -> (ObjectP[{Object[Sample],Model[Sample]}]|Null),
		SPMEDerivatizingAgentAdsorptionTime -> (RangeP[0*Minute,600*Minute]|Null),
		SPMEDerivatizationPosition -> (Top|Bottom|Null),
		SPMEDerivatizationPositionOffset -> (RangeP[10*Milli*Meter,70*Milli*Meter]|Null),
		AgitateWhileSampling -> (BooleanP|Null),
		SampleVialAspirationPosition -> (GCVialPositionP|Null),
		SampleVialAspirationPositionOffset -> (RangeP[0.1*Milli*Meter,65*Milli*Meter]|Null),
		SampleVialPenetrationRate -> (RangeP[1*Milli*Meter/Second,75*Milli*Meter/Second]|Null),
		InjectionVolume -> (RangeP[0*Micro*Liter, 2500*Micro*Liter]|Null),
		LiquidSampleOverAspirationVolume -> (RangeP[0*Micro*Liter, 1000*Micro*Liter]|Null),
		SampleAspirationRate -> (RangeP[0.1*Micro * Liter/Second, 100*Milli * Liter/Second]|Null),
		SampleAspirationDelay -> (RangeP[0*Second,10*Second]|Null),
		SPMESampleExtractionTime -> (RangeP[0*Minute,600*Minute]|Null),
		InjectionInletPenetrationDepth -> (RangeP[10*Milli*Meter,73*Milli*Meter]|Null),
		InjectionInletPenetrationRate -> (RangeP[1*Milli*Meter/Second,100*Milli*Meter/Second]|Null),
		InjectionSignalMode -> ((PlungerUp|PlungerDown)|Null),
		PreInjectionTimeDelay -> (RangeP[0*Second,15*Second]|Null),
		SampleInjectionRate -> (RangeP[1*Micro * Liter/Second, 250*Micro * Liter/Second]|Null),
		SPMESampleDesorptionTime -> (RangeP[0*Minute,600*Minute]|Null),
		PostInjectionTimeDelay -> (RangeP[0*Second,15*Second]|Null),
		LiquidPostInjectionSyringeWash -> (BooleanP|Null),
		LiquidPostInjectionSyringeWashVolume -> (RangeP[0.01*Micro*Liter, 100*Micro*Liter]|Null),
		LiquidPostInjectionSyringeWashRate -> (RangeP[0.1 Micro * Liter/Second, 100 Micro * Liter/Second]|Null),
		LiquidPostInjectionNumberOfSolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidPostInjectionNumberOfSecondarySolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidPostInjectionNumberOfTertiarySolventWashes -> (RangeP[0, 50,1]|Null),
		LiquidPostInjectionNumberOfQuaternarySolventWashes -> (RangeP[0, 50,1]|Null),
		PostInjectionNextSamplePreparationSteps -> ((NoSteps|SolventWash|SampleWash|SampleFillingStrokes|SampleAspiration)|Null),
		HeadspacePostInjectionFlushTime -> (RangeP[0*Second,60*Second]|Null),
		SPMEPostInjectionConditioningTime -> (RangeP[0*Minute,600*Minute]|Null)
	]...
}?DuplicateFreeQ;


(* ::Subsubsection::Closed:: *)
(*FPLCDetectorP*)


FPLCDetectorP = Alternatives[Absorbance, Pressure, Temperature, Conductance, pH];



(* ::Subsubsection::Closed:: *)
(*HPLCOpticalDetectorP*)


HPLCOpticalDetectorP = Alternatives[Diode,DiodeArray,VariableWavelength,Fluorescence,EvaporatedLightScattering,RefractiveIndex];



(* ::Subsubsection::Closed:: *)
(*HPLCFluorescenceSamplingRateP*)


HPLCFluorescenceSamplingRateP = Alternatives[VeryFast,Fast,Standard,Slow,VerySlow];



(* ::Subsubsection::Closed:: *)
(*HPLCFluorescenceSamplingRateP*)


HPLCEmissionCutOffFilterP = Alternatives[
	280 Nanometer,
	370 Nanometer,
	435 Nanometer,
	530 Nanometer,
	None
];


(* ::Subsubsection::Closed:: *)
(*HPLCPumpTypeP*)


HPLCPumpTypeP = Alternatives[Binary,Ternary,Quaternary];


(* ::Subsubsection::Closed:: *)
(*hundoP*)


hundoP = _?(MatchQ[#,(100*Percent|100.`*Percent)]&);


(* ::Subsubsection::Closed:: *)
(*InjectorTypeP*)


InjectorTypeP = Alternatives[FlowThroughNeedle,FixedLoop];


(* ::Subsubsection::Closed:: *)
(*AnalysisChannelsP*)


AnalysisChannelP::usage="
DEFINITIONS
	AnalysisChannelP=CationChannel|AnionChannel
	Pattern for the most common separation channels for ion chromatography. Cation Channel separates positively charged species whereas Anion Channel separates negatively charged species.";

AnalysisChannelP=Alternatives[CationChannel, AnionChannel, ElectrochemicalChannel];


(* ::Subsubsection::Closed:: *)
(*InjectionTableSampleTypeP*)


InjectionTableSampleTypeP=Alternatives[Standard,Sample,Blank];


(* ::Subsubsection::Closed:: *)
(*InjectionTableCleaningTypeP*)


InjectionTableCleaningTypeP=Alternatives[ColumnPrime,ColumnFlush];


(* ::Subsubsection::Closed:: *)
(*SuppressorModeP*)


SuppressorModeP=Alternatives[DynamicMode,LegacyMode];


(* ::Subsubsection::Closed:: *)
(*IonChromatographyDetectorTypeP*)


IonChromatographyDetectorTypeP=Alternatives[SuppressedConductivity|UVVis|ElectrochemicalDetector];


(* ::Subsubsection::Closed:: *)
(*IonChromatographyPumpTypeP*)


IonChromatographyPumpTypeP=Alternatives[Isocratic, Quaternary];


(* ::Subsubsection::Closed:: *)
(*ElectrochemicalDetectionModeP*)


ElectrochemicalDetectionModeP=Alternatives[DCAmperometricDetection|PulsedAmperometricDetection|IntegratedPulsedAmperometricDetection];


(* ::Subsubsection::Closed:: *)
(*ReferenceElectrodeModeP*)


ReferenceElectrodeModeP=Alternatives[pH|AgCl];


(* ::Subsection::Closed:: *)
(*Model patterns*)


(* ::Subsubsection::Closed:: *)
(*GradeP*)


GradeP=Alternatives[
	Biosynthesis,
	Anhydrous,
	HPLC,
	Reagent,
	MolecularBiology,
	LCMS,
	Ultrapure,
	RO,
	ACS,
	USP,
	BioUltra,
	Research,
	Beverage,
	Food,
	BoneDry,
	Medical,
	Industrial,
	Pharmaceutical,
	UltraHighPurity,
	UHP,
	OxygenFree,
	ExtraDry,
	HighPurity,
	Chromatography,
	Semiconductor
];


(* ::Subsubsection::Closed:: *)
(*ColorP*)


ColorP = Alternatives@@
	{
		_RGBColor,
		_Hue,
		_CMYKColor,
		_GrayLevel
	};



(* ::Subsubsection::Closed:: *)
(*BackdropColorP*)


BackdropColorP:=Alternatives[Black,White];


(* ::Subsubsection::Closed:: *)
(*PolymerArrangementP*)


PolymerArrangementP=Alternating|Periodic|Statistical|Block|Grafted;


(* ::Subsubsection::Closed:: *)
(*CountP*)


CountP=_Integer;


(* ::Subsubsection::Closed:: *)
(*MoleculeP*)


MoleculeP=_Molecule;



(* ::Subsubsection::Closed:: *)
(*CASNumberQ and CASNumberP *)

CASNumberQ[]:= False;

CASNumberQ[myCAS_] :=
		Module[{output, splitCAS, numbers, coefficients, checkDigit, toCheck},
			(* Output will resolve to True of False*)
			output = Null;

			While[output == Null,
				(*Check that input is a string*)
				If[StringQ[myCAS] == False, output = False; Break[]];

				(*Check that the string only contains hyphens and DigitCharacters*)
				If[StringMatchQ[myCAS, (DigitCharacter | "-") ..] == False, output = False; Break[]];

				(* Split the CAS number *)
				splitCAS = StringSplit[myCAS, "-"];

				(*Check that there were only three sets of digits separated by hyphens*)
				If[Length[splitCAS] != 3, output = False; Break[]];

				(*Check that the first set of digits is 2 or 7 digits long*)
				If[StringLength[splitCAS[[1]]] < 2 || StringLength[splitCAS[[1]]] > 7, output = False;  Break[]];

				(*Check that the second set of digits is 2 long*)
				If[StringLength[splitCAS[[2]]] != 2, output = False;  Break[]];

				(*Check that the final set of digits is a single digit*)
				If[StringLength[splitCAS[[3]]] != 1, output = False;  Break[]];

				(*Extract each digit*)
				numbers = Flatten[ToExpression[Characters[splitCAS]]];

				(*Extract the check digit*)
				checkDigit = Last[numbers];

				(*And the other digits*)
				toCheck = Most[numbers];

				(*Make coefficients for the other digits*)
				coefficients = Reverse[Range[Length[toCheck]]];

				(*Multiply coefficients with the non-check digit CAS number digits and sum. Take the remainder of this sum when divided by 10*)
				If[Mod[Total[coefficients*toCheck], 10] != checkDigit,
					output = False; Break[]];

				(*All checks passed therefore the input is a CAS Number pattern*)
				output = True;
			];
			output
		];

CASNumberP = _?CASNumberQ



(* ::Subsubsection::Closed:: *)
(*MSAcquisitionModeP*)
(*Old: MSAcquisitionModeP=DataIndependent|DataDependent|MS1|MS1MS2;*)


MSAcquisitionModeP=(DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|PrecursorIonScan|MultipleReactionMonitoring);



(* ::Subsubsection::Closed:: *)
(*MSAnalyteGroupP*)


MSAnalyteGroupP=Alternatives[All,Peptide,SmallMolecule,Protein];



(* ::Subsubsection::Closed:: *)
(*ExclusionModeP*)


ExclusionModeP=All|Once;



(* ::Subsubsection::Closed:: *)
(*InclusionModeP*)


InclusionModeP=Only|Preferential|Null;



(* ::Subsubsection::Closed:: *)
(*IsotopeExclusionModeP*)


IsotopeExclusionModeP=ChargedState|MassDifference|Null;



(* ::Subsubsection::Closed:: *)
(*IdentityModelTypes*)


IdentityModelTypes = {
	Model[Molecule],
	Model[Molecule,cDNA],
	Model[Molecule,Oligomer],
	Model[Molecule,Transcript],
	Model[Molecule,Protein],
	Model[Molecule,Protein,Antibody],
	Model[Molecule,Carbohydrate],
	Model[Molecule,Polymer],
	Model[Resin],
	Model[Resin,SolidPhaseSupport],
	Model[Lysate],
	Model[ProprietaryFormulation],
	Model[Virus],
	Model[Cell],
	Model[Cell,Mammalian],
	Model[Cell,Bacteria],
	Model[Cell,Yeast],
	Model[Tissue],
	Model[Material],
	Model[Species]
};



(* ::Subsubsection::Closed:: *)
(*IdentityModelTypeP*)


IdentityModelTypeP=Alternatives @@ IdentityModelTypes;


(* ::Subsubsection::Closed:: *)
(*IdentityModelP*)


IdentityModelP=ObjectP[List@@IdentityModelTypeP];


(* ::Subsubsection::Closed:: *)
(*SampleInputP*)


SampleInputP=ObjectP[
	Flatten[{
		List@@IdentityModelTypeP,
		Object[Sample]
	}]
];


(* ::Subsubsection::Closed:: *)
(*CompositionP*)


CompositionP=ConcentrationP|MassConcentrationP|VolumePercentP|MassPercentP|PercentConfluencyP|CellConcentrationP|CFUConcentrationP|OD600P;
ZeroCompositionP = Alternatives[Alternatives[EqualP[0 Molar], EqualP[0 Gram/Liter], EqualP[0 VolumePercent], EqualP[0 MassPercent], EqualP[0 PercentConfluency], EqualP[0 Cell/Liter], EqualP[0 CFU/Liter], EqualP[0 OD600]]];



(* ::Subsubsection::Closed:: *)
(*ModelCompositionP*)


ModelCompositionP={{CompositionP,IdentityModelP}..};


(* ::Subsubsection::Closed:: *)
(*SampleHandlingP*)


SampleHandlingP=Liquid|Slurry|Powder|Itemized|Viscous|Paste|Brittle|Fabric|Fixed;


(* ::Subsubsection::Closed:: *)
(*EquilibrationCheckP*)


EquilibrationCheckP=ImmersionThermometer|IRThermometer;


(* ::Subsubsection::Closed:: *)
(*TransferDirectionP*)


TransferDirectionP=In|Out;


(* ::Subsubsection::Closed:: *)
(*PhysicalStateP*)


PhysicalStateP=Solid|Liquid|Gas;



(* ::Subsubsection::Closed:: *)
(*FlashChromatographySeparationModeP*)


FlashChromatographySeparationModeP=NormalPhase|ReversePhase;



(* ::Subsubsection::Closed:: *)
(*FlashChromatographyDetectorTypeP*)


FlashChromatographyDetectorTypeP=Alternatives[UV];


(* ::Subsubsection::Closed:: *)
(*FlashChromatographyLoadingTypeP*)


FlashChromatographyLoadingTypeP=Liquid|Solid|Preloaded;


(* ::Subsubsection::Closed:: *)
(*FlashChromatographyPeakWidthP*)


FlashChromatographyPeakWidthP=Alternatives[15 Second,30 Second,1 Minute,2 Minute,4 Minute,8 Minute];


(* ::Subsubsection::Closed:: *)
(*FlashChromatographyCartridgePackingMaterialP*)


FlashChromatographyCartridgePackingMaterialP=Alternatives[Silica];


(* ::Subsubsection::Closed:: *)
(*FlashChromatographyCartridgeFunctionalGroupP*)


FlashChromatographyCartridgeFunctionalGroupP=Alternatives[C18];


(* ::Subsubsection:: *)
(*FragmentAnalysisAnalyteTypeP*)


FragmentAnalysisAnalyteTypeP=Alternatives[DNA,RNA];


(* ::Subsubsection:: *)
(*FragmentAnalysisStrategyP*)


FragmentAnalysisStrategyP=Alternatives[Qualitative,Quantitative];


(* ::Subsubsection:: *)
(*FragmentAnalysisAuthorP*)


FragmentAnalysisAuthorP=Alternatives[User,Manufacturer];


(* ::Subsubsection::Closed:: *)
(*SterilizationMethodP*)


SterilizationMethodP=Autoclave|EthyleneOxide|HydrogenPeroxide;


(* ::Subsubsection::Closed:: *)
(*AutoclaveBagP*)


AutoclaveBagP=ObjectP[{Model[Container,Bag,Autoclave],Object[Container,Bag,Autoclave]}];


(* ::Subsubsection::Closed:: *)
(* AffinityLabelsP, DetectionLablesP*)


DetectionLabelP[]:=ObjectP[Search[Model[Molecule],DetectionLabel===True]];
AffinityLabelP[]:=ObjectP[Search[Model[Molecule],AffinityLabel===True]];


(* ::Subsubsection::Closed:: *)
(*SampleHistoryP*)


$SampleHistoryKeyPatterns:=<|
	Date->_?DateObjectQ,
	ResponsibleParty->ObjectReferenceP[{Object[Protocol],Object[Maintenance],Object[Qualification],Object[User]}],
	Composition->{{Null|CompositionP,Null|IdentityModelP}..},
	Container->ObjectReferenceP[Object[Container]],
	ContainerModel->ObjectReferenceP[Model[Container]],
	Position->LocationPositionP,
	Protocol->ObjectReferenceP[{Object[Protocol],Object[Maintenance],Object[Qualification],Object[User]}],
	Subprotocol->ObjectReferenceP[{Object[Protocol],Object[Maintenance],Object[Qualification],Object[User]}],
	Location -> ObjectReferenceP[{Object[Container], Object[Instrument]}],
	Role->_Symbol,
	StorageCondition->ObjectReferenceP[Model[StorageCondition]],
	InstrumentModel->ObjectReferenceP[Model[Instrument]],
	Time->TimeP,
	Temperature->TemperatureP|Ambient,
	CarbonDioxide -> PercentP,
	RelativeHumidity -> PercentP,
	ShakingRadius -> DistanceP,
	MixType->MixTypeP,
	Method->DesiccationMethodP,
	Data->ListableP[ObjectReferenceP[Object[Data]]]
|>;

(* Helper function that makes sure that if the key exists in the $SampleHistoryKeyPatterns lookup, the value of that key matches the pattern. *)
sampleHistoryKeysMatchPatternQ[assoc_Association]:=And@@KeyValueMap[
	Function[{key, value},
		If[KeyExistsQ[$SampleHistoryKeyPatterns, key],
			MatchQ[value,Lookup[$SampleHistoryKeyPatterns, key]|Null],
			True
		]
	],
	assoc
];
Authors[Initialized] := {"taylor.hochuli", "harrison.gronlund"};
(* Note: We're a little light on the depth of our pattern matching because the user will never make a Sample History Card. They're always uploaded by our internal functions. *)
initializedQ[Initialized[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,ResponsibleParty,Amount,Composition,Model,Container,ContainerModel,Position}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
initializedQ[_]:=False;

InitializedP:=_?initializedQ;

Authors[ExperimentStarted] := {"taylor.hochuli", "harrison.gronlund"};

experimentStartedQ[ExperimentStarted[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,Subprotocol,Role}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
experimentStartedQ[_]:=False;

ExperimentStartedP:=_?experimentStartedQ;

Authors[ExperimentEnded] := {"taylor.hochuli", "harrison.gronlund"};

experimentEndedQ[ExperimentEnded[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,Subprotocol,StorageCondition,Location}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
experimentEndedQ[_]:=False;

ExperimentEndedP:=_?experimentEndedQ;

Authors[Centrifuged] := {"jireh.sacramento", "xu.yi"};

centrifugedQ[Centrifuged[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,Force,Rate,Time,Temperature}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
centrifugedQ[_]:=False;

CentrifugedP:=_?centrifugedQ;

Authors[Incubated] := {"melanie.reschke", "yanzhe.zhu"};

incubatedQ[Incubated[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,MixType,Time,Temperature,NumberOfMixes,MixVolume,Amplitude,DutyCycle,Rate,CarbonDioxide,RelativeHumidity,ShakingRadius}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
incubatedQ[_]:=False;

IncubatedP:=_?incubatedQ;

Authors[Evaporated] := {"jireh.sacramento", "xu.yi"};

evaporatedQ[Evaporated[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,EvaporationType,Temperature,Pressure,Time,PressureRampTime,FlowRateProfile,RotationRate}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
evaporatedQ[_]:=False;

EvaporatedP:=_?evaporatedQ;

Authors[FlashFrozen] := {"charlene.konkankit"};

flashFrozenQ[FlashFrozen[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,Time}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
flashFrozenQ[_]:=False;

FlashFrozenP:=_?flashFrozenQ;

Authors[Degassed] := {"eunbin.go", "thomas"};

degassedQ[Degassed[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,DegasType,FreezeTime,PumpTime,ThawTime,NumberOfCycles,VacuumTime,VacuumSonicate,ThawTemperature,SpargingGas,SpargingTime}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
degassedQ[_]:=False;

DegassedP:=_?degassedQ;

Authors[Desiccated] := {"mohamad.zandian"};

desiccatedQ[Desiccated[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,Method}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
desiccatedQ[_]:=False;

DesiccatedP:=_?desiccatedQ;

Authors[Filtered] := {"jireh.sacramento", "xu.yi"};

filteredQ[Filtered[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Protocol,InstrumentModel,Type,PoreSize,MembraneMaterial,Temperature,Time}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
filteredQ[_]:=False;

FilteredP:=_?filteredQ;

Authors[Restricted] := {"taylor.hochuli", "harrison.gronlund"};

restrictedQ[Restricted[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,ResponsibleParty}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
restrictedQ[_]:=False;

RestrictedP:=_?restrictedQ;

Authors[Unrestricted] := {"taylor.hochuli", "harrison.gronlund"};

unrestrictedQ[Unrestricted[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,ResponsibleParty}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
unrestrictedQ[_]:=False;

UnrestrictedP:=_?unrestrictedQ;

Authors[SetStorageCondition] := {"taylor.hochuli", "harrison.gronlund"};

setStorageConditionQ[SetStorageCondition[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,ResponsibleParty,StorageCondition}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
setStorageConditionQ[_]:=False;

SetStorageConditionP:=_?setStorageConditionQ;

Authors[Measured] := {"taylor.hochuli", "harrison.gronlund"};

measuredQ[Measured[assoc_Association]]:=Length[Complement[Keys[assoc],{Amount,pH,Appearance,Density,Data,Protocol}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
measuredQ[_]:=False;

MeasuredP:=_?measuredQ;

Authors[StateChanged] := {"taylor.hochuli", "harrison.gronlund"};

stateChangedQ[StateChanged[assoc_Association]]:=Length[Complement[Keys[assoc],{Date, Protocol, State, Handling}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
stateChangedQ[_]:=False;

StateChangedP:=_?stateChangedQ;

Authors[Sterilized] := {"taylor.hochuli", "harrison.gronlund"};

sterilizedQ[Sterilized[assoc_Association]]:=Length[Complement[Keys[assoc],{Date, Protocol}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
sterilizedQ[_]:=False;

SterilizedP:=_?sterilizedQ;

Authors[Transferred] := {"olatunde.olademehin", "melanie.reschke"};

transferredQ[Transferred[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Direction,Source,Destination,Amount,Protocol}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
transferredQ[_]:=False;

TransferredP:=_?transferredQ;

Authors[AcquiredData] := {"taylor.hochuli", "harrison.gronlund"};

acquiredDataQ[AcquiredData[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Data,Protocol}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
acquiredDataQ[_]:=False;

AcquiredDataP:=_?acquiredDataQ;

Authors[Shipped] := {"taylor.hochuli", "harrison.gronlund"};

shippedQ[Shipped[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Source,Destination,ResponsibleParty,Transaction}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
shippedQ[_]:=False;

ShippedP:=_?shippedQ;

Authors[DefinedComposition] := {"taylor.hochuli", "harrison.gronlund"};

definedCompositionQ[DefinedComposition[assoc_Association]]:=Length[Complement[Keys[assoc],{Date,Composition,ResponsibleParty}]]==0&&sampleHistoryKeysMatchPatternQ[assoc];
DefinedCompositionQ[_]:=False;

DefinedCompositionP:=_?definedCompositionQ;

Authors[Lysed] := {"tyler.pabst", "daniel.shlian"};

lysedQ[Lysed[assoc_Association]]:=Length[
	Complement[
		Keys[assoc],
		{
			Date,Protocol,LysisSolution,SecondaryLysisSolution,TertiaryLysisSolution,LysisTemperature,
			SecondaryLysisTemperature,TertiaryLysisTemperature,LysisTime,SecondaryLysisTime,TertiaryLysisTime
		}
	]
]==0&&sampleHistoryKeysMatchPatternQ[assoc];
LysedQ[_]:=False;

LysedP:=_?lysedQ;

Authors[Washed] := {"xu.yi"};

washedQ[Washed[assoc_Association]]:=Length[
	Complement[
		Keys[assoc],
		{
			Date,Protocol,WashSolution, ResuspensionMedia, CellIsolationTime, WashIsolationTime, WashMixTime, ResuspensionMixTime, WashSolutionEquilibrationTime, ResuspensionMediaEquilibrationTime, WashSolutionTemperature, WashTemperature, ResuspensionMediaTemperature, ResuspensionTemperature
		}
	]
]==0&&sampleHistoryKeysMatchPatternQ[assoc];
washedQ[_]:=False;

WashedP:=_?washedQ;

SampleHistoryP=Alternatives[
	InitializedP,
	ExperimentStartedP,
	ExperimentEndedP,
	CentrifugedP,
	IncubatedP,
	EvaporatedP,
	FlashFrozenP,
	DegassedP,
	DesiccatedP,
	FilteredP,
	RestrictedP,
	UnrestrictedP,
	SetStorageConditionP,
	MeasuredP,
	StateChangedP,
	SterilizedP,
	TransferredP,
	AcquiredDataP,
	ShippedP,
	DefinedCompositionP,
	WashedP,
	LysedP
];

SampleHistoryTypeP=Alternatives[
	Initialized,
	ExperimentStarted,
	ExperimentEnded,
	Centrifuged,
	Incubated,
	Evaporated,
	FlashFrozen,
	Degassed,
	Filtered,
	Restricted,
	Unrestricted,
	SetStorageCondition,
	Measured,
	StateChanged,
	Sterilized,
	Transferred,
	AcquiredData,
	Shipped,
	DefinedComposition,
	Washed,
	Lysed
];



(* ::Subsubsection::Closed:: *)
(* ValidBLIPrimitiveP *)


(* the pattern for primitives used in ExperimentBioLayerInterferometry *)

$BLIPrimitiveKeyPatterns:=<|
	Buffers -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
	Analytes -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _String, _Link, Null]..},_String, Samples],
	LoadingSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _String, _Link, Null]..},_String, Samples],
	QuenchSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
	ActivationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],  _Link, Null]..}],
	RegenerationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}], _Link, Null]..}],
	NeutralizationSolutions -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],  _Link, Null]..}],
	Controls -> Alternatives[_Link, ObjectP[{Object[Sample], Model[Sample]}], {Alternatives[ObjectP[{Object[Sample], Model[Sample]}],_Link, Null]...}],
	Time -> RangeP[0 Hour, 20 Hour],
	ShakeRate -> Alternatives[RangeP[100 RPM, 1500 RPM], 0 RPM],
	ThresholdCriterion -> Alternatives[Single,All],
	AbsoluteThreshold -> RangeP[-500*Nanometer, 500*Nanometer],
	ThresholdSlope -> GreaterP[0*Nanometer/Minute],
	ThresholdSlopeDuration -> RangeP[0 Hour, 20 Hour]
|>;

(* enforce that if a key is found in the primitive association, the value matches the required pattern *)
bliKeysMatchPatternQ[assoc_Association]:=And@@KeyValueMap[
	Function[{key,value},
		If[KeyExistsQ[$BLIPrimitiveKeyPatterns, key],
			MatchQ[value, Lookup[$BLIPrimitiveKeyPatterns, key]|Null],
			True
		]
	],
	assoc
];

(* --- BLI primitives patterns --- *)

(* check that the primitives have the correct keys and and that the values match the given pattern *)
(* Equilibrate, MeasureBaseline, Wash, Regenerate, Neutralize only have the 3 basic keys *)
validEquilibrateQ[Equilibrate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validMeasureBaselineQ[MeasureBaseline[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validWashQ[Wash[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validRegenerateQ[Regenerate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{RegenerationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validNeutralizeQ[Neutralize[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{NeutralizationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

(* ActivateSurface, Quench, Quantitate have a buffer key *)
validQuantitateQ[Quantitate[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{Analytes, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validQuenchQ[Quench[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{QuenchSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];
validActivateSurfaceQ[ActivateSurface[assoc_Association]]:=And@@(KeyExistsQ[assoc, #]&/@{ActivationSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

(* LoadSurface, MeasureAssociation, and MeasureDissociation all have threshold keys *)
validLoadSurfaceQ[LoadSurface[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
	{absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

	(* check that the required keys are properly informed, and that all given keys match their pattern *)
	basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{LoadingSolutions, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

	(* check that there arent too many blanks *)
	blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

	(* check that the threshold criterion is informed if the other are also *)
	thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

	(* check that the threshold parameters make sense or are not informed at all *)
	thresholdDefinitionCheck = Or@@{
		MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
		MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
		MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
	};

	(* check that all of the criteria are met *)
	And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];

validMeasureAssociationQ[MeasureAssociation[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
	{absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

	(* check that the required keys are properly informed, and that all given keys match their pattern *)
	basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{Analytes, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

	(* check that there arent too many blanks *)
	blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

	(* check that the threshold criterion is informed if the other are also *)
	thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

	(* check that the threshold parameters make sense or are not informed at all *)
	thresholdDefinitionCheck = Or@@{
		MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
		MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
		MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
	};

	(* check that all of the criteria are met *)
	And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];
validMeasureDissociationQ[MeasureDissociation[assoc_Association]]:=Module[{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck, slopeDuration, slope, absolute, criterion},
	{absolute, slope, slopeDuration, criterion}= Lookup[assoc, {AbsoluteThreshold, ThresholdSlope, ThresholdSlopeDuration, ThresholdCriterion}, Null];

	(* check that the required keys are properly informed, and that all given keys match their pattern *)
	basicKeysCheck = And@@(KeyExistsQ[assoc, #]&/@{Buffers, Time, ShakeRate})&&bliKeysMatchPatternQ[assoc];

	(* check that there arent too many blanks *)
	blanksCheck = Length[ToList[Lookup[assoc, Controls]]]<7;

	(* check that the threshold criterion is informed if the other are also *)
	thresholdCriterionCheck = (MemberQ[{absolute, slope, slopeDuration}, Except[Null]]&&MatchQ[criterion, (Single|All)])||!MemberQ[{absolute, slope, slopeDuration}, Except[Null]];

	(* check that the threshold parameters make sense or are not informed at all *)
	thresholdDefinitionCheck = Or@@{
		MatchQ[absolute, Null]&&MatchQ[{slope, slopeDuration}, {Except[Null], Except[Null]}],
		MatchQ[absolute, Except[Null]&&MatchQ[{slope, slopeDuration}, {Null, Null}]],
		MatchQ[{absolute, slope, slopeDuration}, {Null, Null, Null}]
	};

	(* check that all of the criteria are met *)
	And@@{basicKeysCheck, blanksCheck, thresholdCriterionCheck, thresholdDefinitionCheck}
];


(* generate patterns for each of the primitives based on the Q's *)
ValidEquilibrateP:=_?validEquilibrateQ;
ValidMeasureBaselineP:=_?validMeasureBaselineQ;
ValidActivateSurfaceP:=_?validActivateSurfaceQ;
ValidWashP:=_?validWashQ;
ValidLoadSurfaceP:=_?validLoadSurfaceQ;
ValidQuantitateP:=_?validQuantitateQ;
ValidQuenchP:=_?validQuenchQ;
ValidRegenerateP:=_?validRegenerateQ;
ValidNeutralizeP:=_?validNeutralizeQ;
ValidMeasureAssociationP:=_?validMeasureAssociationQ;
ValidMeasureDissociationP:=_?validMeasureDissociationQ;

(* collect all of them together to check any primitive set *)
ValidBLIPrimitiveP = Alternatives[ValidEquilibrateP, ValidMeasureBaselineP, ValidActivateSurfaceP, ValidWashP, ValidLoadSurfaceP,
	ValidQuantitateP, ValidQuenchP, ValidRegenerateP, ValidNeutralizeP, ValidMeasureAssociationP, ValidMeasureDissociationP];



(* ::Subsubsection::Closed:: *)
(*SmokeMethodP*)


SmokeMethodP=Alternatives[WickBurning,WaterVapor,OilVapor,ChemicalFumes];


(* ::Subsubsection::Closed:: *)
(*LighterTypeP*)


LighterTypeP=Alternatives[CigaretteLighter,GrillLighter,TorchLighter,PlasmaLighter];


(* ::Subsubsection::Closed:: *)
(*IgnitionSourceP*)


IgnitionSourceP=Alternatives[Flame,Spark,Plasma];


(* ::Subsubsection::Closed:: *)
(*FuelTypeP*)


FuelTypeP=Alternatives[Butane,Naphtha,Battery,Ethanol];


(* ::Subsection::Closed:: *)
(*MeasurementStatusP*)


MeasurementStatusP=Initialization|Measurement|ErroneousMeasurement|Computed;



(* ::Subsubsection::Closed:: *)
(*TransportColdConditionP*)


TransportColdConditionP=Chilled|Minus40|Minus80|Cryo;


(* ::Subsubsection::Closed:: *)
(*TransportConditionP*)


TransportConditionP=Ambient|Warmed|TransportColdConditionP|OvenDried|LightBox;




(* ::Subsection::Closed:: *)
(*Program patterns*)


(* ::Subsubsection::Closed:: *)
(*TransferTypeP*)


TransferTypeP = Alternatives[
	LiquidTransfer,MassTransfer,Slurry
];

TransferCompletenessP = Alternatives[
	All,Partial
];



(* ::Subsection::Closed:: *)
(*Method patterns*)


(* ::Subsubsection::Closed:: *)
(*CameraFieldOfViewP*)


CameraFieldOfViewP = Alternatives[
	22 Millimeter, 35 Millimeter, 95 Millimeter, 200 Millimeter, 650 Millimeter, 380 Millimeter
];


(* ::Subsubsection::Closed:: *)
(*SingleIlluminationSourceP*)


SingleIlluminationSourceP = Alternatives[Top, Bottom, Side];


(* ::Subsubsection::Closed:: *)
(*IlluminationDirectionP*)


(* Here, 'Ambient' essentially implies no additional illumination and 'All' implies all three of Top, Bottom, and Side *)
IlluminationDirectionP = Alternatives[Top, Bottom, Side, Ambient];(*Alternatives[SingleIlluminationSourceP, Ambient, All]*);


(* ::Subsubsection::Closed:: *)
(*SampleInspectorIlluminationDirectionP*)


SampleInspectorIlluminationDirectionP = Alternatives[Top, Front, Back, All];


(* ::Subsubsection::Closed:: *)
(*ImagingPedestalP*)


ImagingPedestalP = Alternatives[None,Small,Medium,Large,SmallAndMedium,SmallAndLarge,MediumAndLarge];


(* ::Subsubsection::Closed:: *)
(*KaiserResultP*)


KaiserResultP = Alternatives[Negative,Positive];



(* ::Subsection::Closed:: *)
(*Data patterns*)


(* ::Subsubsection::Closed:: *)
(*AppearanceTypeP*)


AppearanceTypeP = Alternatives[
	Ruler, Analyte
];



(* ::Subsection:: *)
(*Organization patterns*)


(* ::Subsubsection::Closed:: *)
(*EmeraldPositionP*)


EmeraldPositionP::usage="
DEFINITIONS
	Pattern that matches any of the possible positions at Emerald.
";
EmeraldPositionP=Alternatives[
	"Co-CEO",
	"Controller",
	"Designer",
	"Director of Design",
	"Director of Engineering",
	"Director of Finance",
	"Director of Laboratory Operations",
	"Director of Operations",
	"Director of Research",
	"Director of Scientific Computing",
	"Director of Scientific Development",
	"Director of Systems Diagnostics",
	"Director of HR",
	"Facilities Technician",
	"General Counsel",
	"Hiring and Culture",
	"Human Resources",
	"Human Resources Associate",
	"Information Technology",
	"Intern",
	"Laboratory Operations Assistant Manager",
	"Laboratory Operations Manager",
	"Laboratory Operations Shift Lead",
	"Laboratory Operator",
	"Operations",
	"Partnership and Engagement Manager",
	"Procurement and Sourcing Specialist",
	"Recruiter",
	"Research Scientist",
	"Sales Leader",
	"Scientific Computing Engineer",
	"Scientific Infrastructure Engineer",
	"Scientific Instrumentation Engineer",
	"Scientific Education Engineer",
	"Scientific Developer",
	"Senior Accountant",
	"Software Engineer",
	"Spokesrooster",
	"Strategic Finance Associate",
	"Systems Diagnostics Scientist",
	"Technology Evangelist",
	"VP of Finance"
];



(* ::Subsubsection::Closed:: *)
(*EmeraldDepartmentP*)


EmeraldDepartmentP=Alternatives[
	BusinessDevelopment,
	Design,
	Development,
	Engineering,
	Fabrication,
	Facilities,
	Finance,
	Founders,
	GeneralAndAdministrative,
	LaboratoryOperations,
	Operations,
	Research,
	Sales,
	ScientificComputing,
	ScientificEducation,
	SystemsDiagnostics,
	User,
	ScientificInfrastructure,
	ScientificInstrumentation,
	ScientificSolutions
];


(* ::Subsubsection::Closed:: *)
(*UserFormatP*)


UserFormatP::usage="
DEFINITIONS
	UserFormatP=Name|Object|AsanaGID|Name|FirstName|LastName|MiddleName
";
UserFormatP=Name|Object|AsanaGID|Name|FirstName|LastName|MiddleName;


(* ::Subsubsection:: *)
(*OperatorSpecializationP*)


OperatorSpecializationP=Alternatives[
	MouseSurgeon
];


(* ::Subsubsection:: *)
(*ShiftTimeP*)


ShiftTimeP::usage="
DEFINITIONS
	ShiftTimeP=Alternatives[Morning,Swing,Night]
	Pattern for the operations shifts that the Laboratory Operations team works.";

ShiftTimeP=Alternatives[Morning,Swing,Night,Evening];


(* ::Subsubsection:: *)
(*ShiftNameP*)


ShiftNameP::usage="
DEFINITIONS
	Pattern for names given to the set of days Laboratory Operations members are set to work.";

ShiftNameP=Alternatives[Alpha, Bravo, Charlie, Delta];


DayNameP=Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday;

(* ::Subsubsection::Closed:: *)
(*PackageSectionP*)


PackageSectionP::usage="
DEFINITIONS
	PackageSectionP=Alternatives[\"Help Files\",\"Source Code\",\"Unit Testing\"]
	Pattern for the three main sections of most Emerald packages: Help Files, Source Code, and Unit Testing";

PackageSectionP=Alternatives["Help Files","Source Code","Unit Testing"];



(* ::Subsection::Closed:: *)
(*Notification patterns*)


(* ::Subsubsection::Closed:: *)
(*TeamMembershipEventP*)


TeamMembershipEventP = Alternatives[
	(* Notifications that are sent to all team members *)
	MemberAdded,
	MemberRemoved,
	AdminAdded,
	AdminRemoved,

	(* Notifications that are sent only to the individuals to whom they apply *)
	MemberInvitation
];



(* ::Subsubsection::Closed:: *)
(*TeamNotebookEventP*)


TeamNotebookEventP = Alternatives[
	NotebookAdded,
	NotebookRemoved
];



(* ::Subsubsection::Closed:: *)
(*TeamEventP*)


TeamEventP = Alternatives[
	TeamMembershipEventP,
	TeamNotebookEventP
];



(* ::Subsubsection::Closed:: *)
(*TroubleshootingEventP*)


TroubleshootingEventP = Alternatives[
	TroubleshootingReported,
	TroubleshootingResolved,
	TroubleshootingReopened,
	TroubleshootingUpdated
];


(* ::Subsubsection::Closed:: *)
(*ScriptEventP*)


ScriptEventP = Alternatives[
	ScriptException,
	ScriptCompleted
];


(* ::Subsubsection::Closed:: *)
(*MaterialsApprovalEventP*)


MaterialsApprovalEventP = Alternatives[
	ModelApproved,
	ProductApproved
];



(* ::Subsubsection::Closed:: *)
(*TransactionEventP*)


TransactionEventP = Alternatives[
	OrderPlaced,
	OrderReceived,
	OrderBackordered,
	OrderCanceled,
	SamplesReturned,
	(* deprecated *)SamplesShipped,
	SamplesReceived
];



(* ::Subsubsection::Closed:: *)
(*MaterialsEventP*)


MaterialsEventP = Alternatives[
	MaterialsApprovalEventP,
	TransactionEventP,
	MaterialsRequired
];



(* ::Subsubsection::Closed:: *)
(*ECLEventP*)


ECLEventP = Alternatives[
	NewFeature,
	SoftwareUpdate
];



(* ::Subsubsection::Closed:: *)
(*VersionNumberP*)


VersionNumberP = _String?(StringMatchQ[#, (DigitCharacter..)~~("."~~(DigitCharacter..))..]&);



(* ::Subsubsection::Closed:: *)
(*NotificationRecipientFilterP*)


NotificationRecipientFilterP = (All | Yours | None);

(*Wells & Plates & Racks & Decks & Vessels*)



(* ::Subsubsection::Closed:: *)
(*WellTypeP*)


WellTypeP::usage="
DEFINITIONS
	WellTypeP=Position|Index|TransposedIndex|SerpentineIndex,StaggeredIndex,TransposedSerpentineIndex,TransposedStaggeredIndex,RowColumnIndex
		Matches a well type.
";
WellTypeP=Position|Index|TransposedIndex|SerpentineIndex|StaggeredIndex|TransposedSerpentineIndex|TransposedStaggeredIndex|RowColumnIndex;



(* ::Subsubsection::Closed:: *)
(*WellIndexTypeP*)


WellIndexTypeP::usage="
DEFINITIONS
	WellIndexTypeP=Index|TransposedIndex|SerpentineIndex,StaggeredIndex,TransposedSerpentineIndex,TransposedStaggeredIndex,RowColumnIndex
		Matches a well type that is an indexed based well (not a position).
";
WellIndexTypeP=Index|TransposedIndex|SerpentineIndex|StaggeredIndex|TransposedSerpentineIndex|TransposedStaggeredIndex|RowColumnIndex;


(* ::Subsubsection::Closed:: *)
(*SLLWellPositionP*)


SLLWellPositionP::usage="
DEFINITIONS
	SLLWellPositionP=_String?(StringMatchQ[#,(DigitCharacter...)~~CharacterRange[\"A\", \"Z\"]..~~(DigitCharacter..)]&)
		Matches an implicitly typed well position that is not split.
";
SLLWellPositionP=Alternatives[
	_String?(StringMatchQ[#,CharacterRange["A", "Z"]..~~(DigitCharacter..)]&&!StringMatchQ[#,CharacterRange["A", "Z"]..~~("0"..)]&),
	_String?(StringMatchQ[#1,NonZeroDigitCharacter~~DigitCharacter...~~CharacterRange["A", "Z"]..~~DigitCharacter...]&&!StringMatchQ[#,DigitCharacter..~~CharacterRange["A", "Z"]..~~("0"..)]&)
];


(* ::Subsubsection::Closed:: *)
(*HeadspaceSubdivisionPositionP*)
(*An example is Drop1 for crystallization plate*)
HeadspaceSubdivisionPositionP=CharacterRange["A","Z"]..~~(CharacterRange["a","z"]...)~~(DigitCharacter...);

(* ::Subsubsection::Closed:: *)
(*WellPositionP*)


WellPositionP::usage="
DEFINITIONS
	WellPositionP=_String|{_String,_String}
		Matches a well position.
";
WellPositionP=Alternatives[
	_String?(StringMatchQ[#,CharacterRange["A", "Z"]..~~(DigitCharacter..)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&&!StringMatchQ[#,CharacterRange["A", "Z"]..~~("0"..)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&),
	_String?(StringMatchQ[#1,NonZeroDigitCharacter~~DigitCharacter...~~CharacterRange["A", "Z"]..~~(DigitCharacter...)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&&!StringMatchQ[#,DigitCharacter..~~CharacterRange["A", "Z"]..~~("0"..)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&),
	{_String?(StringMatchQ[#,NonZeroDigitCharacter~~(DigitCharacter...)]&),_String?(StringMatchQ[#,CharacterRange["A", "Z"]..~~(DigitCharacter..)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&&!StringMatchQ[#,CharacterRange["A", "Z"]..~~("0"..)..~~(EndOfString|HeadspaceSubdivisionPositionP)]&)}];


(* ::Subsubsection::Closed:: *)
(*WellIndexP*)


WellIndexP::usage="
DEFINITIONS
	WellIndexP=_Integer?Positive|{_Integer?Positive,_Integer?Positive}|{_Integer?Positive,{_Integer?Positive,_Integer?Positive}}
		Matches a well index.
";
WellIndexP=_Integer?Positive|{_Integer?Positive,_Integer?Positive}|{_Integer?Positive,{_Integer?Positive,_Integer?Positive}};


(* ::Subsubsection::Closed:: *)
(*WellP*)


WellP::usage="
DEFINITIONS
	WellP=WellIndexP|WellPositionP
		Matchs a well pattern
";
WellP=WellIndexP|WellPositionP;


(* ::Subsubsection::Closed:: *)
(*WellShapeP*)


WellShapeP::usage="
DEFINITIONS
	FlatBottom|RoundBottom|VBottom|Nozzle
		Pattern for the different types of shapes a well bottom can take.
";
WellShapeP=FlatBottom|RoundBottom|VBottom|Nozzle|OpenEnd;



(* ::Subsubsection::Closed:: *)
(*WellNumberP*)


WellNumberP = (6 | 12 | 24 | 48 | 96);



(* ::Subsubsection::Closed:: *)
(*GroundGlassJointSizeP*)


GroundGlassJointSizeP::usage="
DEFINITIONS
	\"7/25\"|\"10/30\"|\"12/30\"|\"14/35\"|\"19/38\"|\"24/40\"|\"29/42\"|\"34/45\"|\"40/50\"|\"45/50\"|\"50/50\"
		Pattern for the designation of the taper ground joint for vessel's mouths or stoppers.
";
GroundGlassJointSizeP="7/15"|"10/30"|"12/30"|"14/20"|"14/35"|"19/22"|"19/38"|"24/25"|"24/40"|"29/26"|"29/42"|"34/45"|"35/20"|"35/25"|"40/50"|"45/50"|"50/50";


(* ::Subsubsection::Closed:: *)
(*PlateColorP*)


PlateColorP=(OpaqueBlack|OpaqueWhite|Clear|Natural);


(* ::Subsubsection::Closed:: *)
(*PartColorP*)


PartColorP=(Red|Yellow|Green|Blue|Black|Orange|White|StainlessSteel);



(* ::Subsubsection::Closed:: *)
(*WellTreatmentP*)


WellTreatmentP:=(TissueCultureTreated|NonTreated|LowBinding|Glass|GlassFilter|PolyethersulfoneFilter|HydrophilicPolypropyleneFilter);


(* ::Subsubsection::Closed:: *)
(*WallType*)


WallTypeP:=(Frosted | Blackwalled | Clear);



(* ::Subsubsection::Closed:: *)
(*CuvetteCapTypeP*)


CuvetteCapTypeP:=(None | Cap | Stopper | Septum | ScrewCap);



(* ::Subsubsection::Closed:: *)
(*ReactionVesselConnectionTypeP*)


ReactionVesselConnectionTypeP:=(LuerLock | LuerSlip);



(* ::Subsubsection::Closed:: *)
(*CuvetteScaleP*)


CuvetteScaleP:=(Standard | SemiMicro |  Micro | SubMicro);



(* ::Subsubsection::Closed:: *)
(*DishRackTypeP*)


DishRackTypeP:=(Active|Passive);


(* ::Subsubsection::Closed:: *)
(*VenusTubeRackP*)


VenusTubeRackP:=Alternatives[
	"Tubes2mL",
	"Tubes50mL",
	"TubesHPLC",
	"Tubes500uLSkirted",
	"Tubes500uLSkirtedDB",
	"Tubes500uLSkirtedShort",
	"Tubes700uLSkirted",
	"MicroCent_1p5mL_Tube"
];


(* ::Subsubsection::Closed:: *)
(*VenusPlatePrefixP*)


VenusPlatePrefixP:=Alternatives[
	"_96_well_equil_dialysis_plate",
	"ABgene_96PCR",
	"AcroPrep_1mL",
	"AcroPrep_2mL",
	"Alpha_384",
	"Alpha_384_shallow",
	"Alpha_96_HalfArea",
	"AVANT_Vials",
	"Chromtech_Filter",
	"conical_500uL_96w_plate",
	"Corning_BlackWall_F_Bottom_384",
	"ddPCR",
	"DWP",
	"DWP_24",
	"DWP_48",
	"DWP_96_1mL",
	"DWP_96_1mL_block",
	"echo_low_vol_384",
	"EllaCustomizable",
	"EllaMultiAnalyte16X4",
	"EllaMultiAnalyte32X4",
	"EllaMultiPlex32X8",
	"EllaSinglePlex72X1",
	"FBottom_96",
	"Greiner_Clear_F_Bot_384",
	"HPLC_Vial",
	"Lunatic",
	"MALDI",
	"MicroAmp_384_PCR",
	"PhyTip_Adapter",
	"QiaQuick_96w",
	"Reservoir",
	"Reservoir_VBottom",
	"Tensiometer_96",
	"Tips_1000ul",
	"Tips_1000ul_Filter",
	"Tips_10ul",
	"Tips_10ul_Filter",
	"Tips_300ul",
	"Tips_300ul_Filter",
	"Tips_50ul",
	"Tips_50ul_Filter",
	"Uncle",
	"UVStar",
	"VBottom_96",
	"Vial_8mm",
	"Wes",
	"XRD",
	"Zeba_Collection",
	"Zeba_Desalting"
];



(* ::Subsubsection::Closed:: *)
(*VenusPositionP*)


VenusPositionP:=_?(StringMatchQ[#,DigitCharacter..]&);

(*Sequences, strands, structures*)



(* ::Subsubsection::Closed:: *)
(*MotifBondP*)


MotifBondP::usage="
DEFINITIONS
	MotifBondP=Bond[{_Integer,_Integer},{_Integer,_Integer}]

";
MotifBondP=Bond[{_Integer,_Integer},{_Integer,_Integer}];


(* ::Subsubsection::Closed:: *)
(*MotifBaseBondP*)


MotifBaseBondP::usage="
DEFINITIONS
	MotifBaseBondP=Bond[{_Integer,_Integer,{_Integer,_Integer}},{_Integer,_Integer,{_Integer,_Integer}}]
		Matches a Structure pair using base information.  Structure pairs with only motif information will not match this.
";
MotifBaseBondP=Bond[{_Integer,_Integer,Span[_Integer,_Integer]},{_Integer,_Integer,Span[_Integer,_Integer]}];



(* ::Subsubsection::Closed:: *)
(*BondP*)


BondP::usage="
DEFINTIIONS
	BondP=Bond[{_Integer,_Integer},{_Integer,_Integer}]|Bond[{_Integer,_Integer,{_Integer,_Integer}},{_Integer,_Integer,{_Integer,_Integer}}]
		Matches all allowed pair patterns in a Structure
";
BondP=MotifBondP|MotifBaseBondP|Bond[{_Integer,Span[_Integer,_Integer]},{_Integer,Span[_Integer,_Integer]}];


(* ::Subsubsection::Closed:: *)
(*AllPolymersP*)


(* Generate all possible oligomers *)
AllPolymersP:=Module[{defaultOligomers,availableOligomers},

	(* Default list of public oligomers *)
	defaultOligomers={DNA,RNA,RNAtom,RNAtbdms,LDNA,LRNA,LNAChimera,PNA,GammaLeftPNA,GammaRightPNA,Peptide,Modification};

	(* Removing all white spaces and numbers and taking the first 10 characters *)
	availableOligomers=If[MatchQ[$PersonID,ObjectP[Object[User]]],
		Join[
			(
				(* Add Global context head if there is a new symbol *)
				Which[
					(* NOTE: We cannot convert a string with spaces into a symbol. *)
					StringContainsQ[#, " "],
						Nothing,
					MemberQ[defaultOligomers,Symbol[#]],
						Symbol[#],
					True,
						Symbol["Global`"<>#]
				]& /@ Download[Search[Model[Physics, Oligomer]], Name]
			),
			{Modification}
		],
		defaultOligomers
	];

	(* If the user is logged-in, Memoize the result so we don't search/download each time this function is called *)
	If[MatchQ[$PersonID,ObjectP[Object[User]]],
		AllPolymersP=availableOligomers,
		availableOligomers
	]

];



(* ::Subsubsection::Closed:: *)
(*OligomerQ*)


(* Checks whether the oligomer type is appropriately chosen *)
PolymerQ[oligomer_Symbol]:=Module[{result},

	(* add this function as memoized *)
	If[!MemberQ[$Memoization, PolymerQ],
		AppendTo[$Memoization, PolymerQ]
	];

	(* Memoize the result so we don't search/download each time this function is called *)
	result=MemberQ[Alternatives@@AllPolymersP,oligomer];

	(* Only memoize if the result is true *)
	(* Logging in could create more polymer types but should never change one from True to False *)
	If[result,
		PolymerQ[oligomer]=result,
		result
	]
];

(* All other types are not acceptable *)
PolymerQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*OligomerP*)


PolymerP=_?PolymerQ;



(* ::Subsubsection::Closed:: *)
(*PolymerP*)


(** TODO: this should be removed once unit test is performed **)
PolymerP::usage="
DEFINITIONS
	PolymerP=Alternatives[DNA,RNA,PNA,Peptide,Modification]
		The allowed polymer types.
";
(* PolymerP=Alternatives[DNA,RNA,RNAtom,RNAtbdms,LDNA,LRNA,LNAChimera,PNA,GammaLeftPNA,GammaRightPNA,Peptide,Modification]; *)


(* ::Subsubsection::Closed:: *)
(*SequenceP*)


SequenceP::usage="
DEFINITIONS
	SequenceP=Any pattern that could match a sequence by structure (without checking actual Monomers in a string).
";

SequenceP:=Alternatives[_String,PolymerP[(_Integer|_String),___]];



(* ::Subsubsection::Closed:: *)
(*MotifP*)


MotifP::usage="
DEFINITIONS
	MotifP=(((PolymerP)[_String|_Integer,_String])|((PolymerP)[_String|_Integer]))
		Matches a motif
";

MotifP=(((PolymerP)[_String|_Integer,_String])|((PolymerP)[_String|_Integer]));

(* MotifP=(((head_)[_String|_Integer,_String])|((head_)[_String|_Integer])) /; MatchQ[head,OligomerP]; *)


(* ::Subsubsection::Closed:: *)
(*StrandP*)


StrandP::usage="
DEFINITIONS
	StrandP=Strand[MotifP..]
		Matches a strand
";
StrandP=Strand[MotifP..];


(* ::Subsubsection::Closed:: *)
(*LoopTypeP*)


LoopTypeP::usage="
DEFINITIONS
	LoopTypeP = Alternatives[StackingLoop, HairpinLoop, BulgeLoop, InternalLoop, MultipleLoop]
		Matches a loop type
";
LoopTypeP = Alternatives[StackingLoop, HairpinLoop, BulgeLoop, InternalLoop, MultipleLoop];



(* ::Subsubsection::Closed:: *)
(*StructureP*)


StructureP::usage="
DEFINITIONS
	StructureP=Structure[{StrandP..},{BondP...}]|Structure[{StrandP..}]
		Matches a Structure
";
StructureP=Structure[{StrandP..},{BondP...}];


(* ::Subsubsection::Closed:: *)
(*HybridizationMethodP*)


HybridizationMethodP::usage="
DEFINITIONS
	HybridizationMethodP=Energy | Bonds
		Whether the Gibbs free energy or number of bonds is considered for optimization
";
HybridizationMethodP=ECL`Energy | Bonds;



(* ::Subsubsection::Closed:: *)
(*MonomerSymbolP*)


MonomerSymbolP="A"|"G"|"T"|"C"|"U"|"Ala"|"Glu"|"Leu"|"Ser"|"Arg"|"Gln"|"Lys"|"Thr"|"Asn"|"Gly"|"Met"|"Trp"|"Asp"|"His"|"Phe"|"Tyr"|"Cys"|"Ile"|"Pro"|"Val"|"Acetylated"|"Phosphorylated"|"Fluorescein"|"LysFAM"|"Dabcyl"|"Tamra"|"Tetramethylrhodamine"|"LysTamra"|"Cythree"|"Cyfive"|"Alkyne"|"Triazole"|"5'-Thiohexyl"|"3'-Thiopropyl"|"Maleimide"|"Bhqtwo"|"Fmoc"|"2-Thio-dT"|"2-Aminopurine"|"Deoxyinosine"|"dP"|"SMCC"|"EMCS"|"Bromoacetylated"|"Iodoacetylated"|"5-Acrylate-dT"|"4-Methylthioacylphenol"|"Cysteinemethylester"|"Azidoacetic acid"|"3'-PropargylGlycine"|"5'-PropargylGlycine"|"3'-R-Propynyl-L-Proline"|"5'-R-Propynyl-L-Proline"|"Maleoyl-beta-Alanine"|"Guanidinylated"|"5'-Propynylamide"|"5'-Hexynyl"|"5'-Bromohexyl"|"AEEA Spacer"|"5'-Amino-C6"|"5'-Amino-5"|"5'-Aminohexyl"|"Azidobutyramide"|"5'-Azido-2-Amido-Pentanoic Acid"|"3`Propanol"|"MetOxidation"|"Hexose"|"Methylation"|"AsnGlnDeamidated"|"CysCarbamidomethylated"|"CysCarboxymethylatedatedated"|"LysAcetylated";



(* ::Subsubsection::Closed:: *)
(*FoldingsP*)


FoldingsP::usage = "
DEFINITIONS
	FoldingsP = Association[FoldedStructures -> _Structure, FoldedEnergies -> EnergyP, FoldedNumberOfBonds -> _Integer, FoldedPercentage -> _?NumberQ]
		Matches the output of SimulateFolding
";
FoldingsFields = {FoldedStructures, FoldedEnergies, FoldedNumberOfBonds, FoldedPercentage};
FoldingsQ[folds_] := And[
	MatchQ[folds, _Association],
	MatchQ[Sort[Keys[folds]], FoldingsFields],
	MatrixQ[Values[folds]]
];
FoldingsP = _?FoldingsQ;



(* ::Subsubsection::Closed:: *)
(*FoldingIntervalP*)


FoldingIntervalP::usage = "
DEFINITIONS
	FoldingIntervalP = Alternatives[All, {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}, {GreaterEqualP[0, 1], {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}}, {GreaterEqualP[0, 1], GreaterEqualP[0, 1], {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}}]
		Matches the FoldingInterval option of SimulateFolding
";
FoldingIntervalP = Alternatives[All, {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}, {GreaterEqualP[0, 1], {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}}, {GreaterEqualP[0, 1], GreaterEqualP[0, 1], {GreaterEqualP[0, 1], GreaterEqualP[0, 1]}}];



(* ::Subsubsection::Closed:: *)
(*HybridizationsP*)


HybridizationsP::usage = "
DEFINITIONS
	HybridizationsP = Association[HybridizedStructures -> _Structure, HybridizedEnergies -> EnergyP, HybridizedNumberOfBonds -> _Integer, HybridizedPercentage -> _?NumberQ]
		Matches the output of SimulateHybridization
";
HybridizationsFields = {HybridizedStructures, HybridizedEnergies, HybridizedNumberOfBonds, HybridizedPercentage};
HybridizationsQ[hybs_] := And[
	MatchQ[hybs, _Association],
	MatchQ[Sort[Keys[hybs]], HybridizationsFields],
	MatrixQ[Values[hybs]]
];
HybridizationsP = _?HybridizationsQ;



(* ::Subsubsection::Closed:: *)
(*ProbeSelectionsP*)


ProbeSelectionsP::usage = "
DEFINITIONS
	ProbeSelectionsP = Association[TargetPosition -> {_Integer, _Integer}, ProbeStrands -> StrandP, BoundProbeConcentration -> GreaterEqualP[0*Molar*Micro], FreeProbeConcentration -> GreaterEqualP[0*Molar*Micro]],
		FalseAmpliconConcentration -> GreaterEqualP[0*Molar*Micro], FoldedBeaconConcentration -> GreaterEqualP[0*Molar*Micro] | Null
		Matches the output of SimulateProbeSelection
";
ProbeSelectionFields = {TargetPosition, ProbeStrands, BoundProbeConcentration, FreeProbeConcentration, FalseAmpliconConcentration, FoldedBeaconConcentration};
ProbeSelectionsQ[ps_] := And[
	MatchQ[ps, _Association],
	MatchQ[Sort[Keys[ps]], ProbeSelectionFields],
	MatrixQ[Values[ps]]
];
ProbeSelectionsP = _?ProbeSelectionsQ;



(* ::Subsection::Closed:: *)
(*States, Reactions, ReactionMechanisms, Trajectory*)


(* ::Subsubsection::Closed:: *)
(*ReactionSpeciesP*)


ReactionSpeciesP::usage="
DEFINITIONS
	SpeciesP=Alternatives[_Symbol,_Strand,_Structure,_String]
		Allowed variable types for model objects such as _State, _Reaction, _ReactionMechanism
";
ReactionSpeciesP=Alternatives[_Symbol,StrandP,StructureP,_String,PolymerP[__]];



(* ::Subsubsection::Closed:: *)
(*StateP*)


StateP::usage="
	StateP=Alternatives[State[{ReactionSpeciesP,_?NumericQ|_?ConcentrationQ}...],State[{ReactionSpeciesP}...]
		Matches a _State
";
StateP=Alternatives[
	State[{ReactionSpeciesP,_?NumericQ|_?ConcentrationQ|_?AmountQ|UnitsP[]}...],
	State[{ReactionSpeciesP}...]
];


(* ::Subsubsection::Closed:: *)
(*RateTypeP*)


RateTypeP::usage="

";
RateTypeP=Alternatives[Folding, Melting, Zipping, Unzipping, DuplexInvasion, StrandInvasion, Hybridization, Dissociation, ToeholdMediatedStrandExchange, ToeholdMediatedDuplexExchange, DualToeholdMediatedDuplexExchange, Unknown, Unchanged];


(* ::Subsubsection::Closed:: *)
(*IrreversibleReactionP*)


IrreversibleReactionP=Alternatives[
(* first order irreversible, with arbitrary number of products *)
	Reaction[{ReactionSpeciesP},{ReactionSpeciesP..},(Rate1P|Folding|Dissociation|Melting|Zipping|Unzipping|Rate2P)],
(* second order irreversible, with arbitrary number of products *)
	Reaction[{ReactionSpeciesP,ReactionSpeciesP},{ReactionSpeciesP..},(Rate2P|Hybridization|DuplexInvasion|StrandInvasion|ToeholdMediatedStrandExchange|ToeholdMediatedDuplexExchange|DualToeholdMediatedDuplexExchange)]
];



(* ::Subsubsection::Closed:: *)
(*ReversibleReactionP*)


ReversibleReactionP=Alternatives[
(* first order forward, first order backward *)
	Reaction[{ReactionSpeciesP},{ReactionSpeciesP},(Rate1P|Folding),(Rate1P|Melting)],
	Reaction[{ReactionSpeciesP},{ReactionSpeciesP},Zipping,Unzipping],
(* first order forward, second order backward *)
	Reaction[{ReactionSpeciesP},{ReactionSpeciesP,ReactionSpeciesP},Rate1P,Rate2P],
(* second order forward, first order backward *)
	Reaction[{ReactionSpeciesP,ReactionSpeciesP},{ReactionSpeciesP},(Rate2P|Hybridization),(Rate1P|Dissociation)],
(* second order forward, second order backward *)
	Reaction[{ReactionSpeciesP,ReactionSpeciesP},{ReactionSpeciesP,ReactionSpeciesP},(Rate2P|DuplexInvasion),(Rate2P|DuplexInvasion)],
	Reaction[{ReactionSpeciesP,ReactionSpeciesP},{ReactionSpeciesP,ReactionSpeciesP},StrandInvasion,StrandInvasion]
];



(* ::Subsubsection::Closed:: *)
(*ReactionP*)


ReactionP = IrreversibleReactionP | ReversibleReactionP;



(* ::Subsubsection::Closed:: *)
(*InitialConditionP*)


InitialConditionP::usage="
DEFINITIONS
	InitialConditionP = Rule[ReactionSpeciesP,_?NumericQ|_?ConcentrationQ]
		Allowed formats for initial conditions for kinetic simulation or ReactionMechanism simulation
";

InitialConditionP = Rule[ReactionSpeciesP,_?NumericQ|_?ConcentrationQ|_?AmountQ|_Quantity];



(* ::Subsubsection::Closed:: *)
(*ReactionMechanismP*)


ReactionMechanismP::usage="
DEFINITIONS
	ReactionMechanismP=ReactionMechanism[ReactionP...]
		Matches a _ReactionMechanism
";

ReactionMechanismP=ReactionMechanism[ReactionP...];



(* ::Subsubsection::Closed:: *)
(*InitialP*)


InitialP::usage="";
InitialP={Rule[ReactionSpeciesP,_?NumericQ|_?ConcentrationQ]...};


(* ::Subsubsection::Closed:: *)
(*KineticsEquationP*)


KineticsEquationP::usage="One first-order ODEs with consistent time-variable naming.";
(*
	name the time symbol to make sure it has the same name in all equations when we do
	{KineticsEquationP..}
  (this does not force it to be a literal 't', we are just referring to it as 't'
*)
KineticsEquationP = Alternatives[
		Equal[Derivative[1][_Symbol][t_Symbol],_],
		Equal[_Symbol[t_Symbol],_],
		WhenEvent[t_==_|t_>_,{___Rule}]
	];


(* ::Subsubsection::Closed:: *)
(*Rate1P*)


Rate1P::usage="
DEFINITIONS
	Rate1P=Alternatives[_?NumericQ,_?FirstOrderRateQ]
		Matches a first order rate
";
Rate1P=Alternatives[_?NumericQ,_?FirstOrderRateQ|_];



(* ::Subsubsection::Closed:: *)
(*Rate2P*)


Rate2P::usage="
DEFINITIONS
	Rate2P=Alternatives[_?NumericQ|_?SecondOrderRateQ]
		Matches a second order rate
";
Rate2P=Alternatives[_?NumericQ|_?SecondOrderRateQ|_];



(* ::Subsubsection::Closed:: *)
(*Rx2P*)


Rx2P::usage="
DEFINITIONS
	Rx2P = Plus[ReactionSpeciesP,ReactionSpeciesP]
		Matches second order reaction.  needs some hold tricks because _Plus is hard to match with
";

Rx2P=HoldPattern[Plus[varvar$,varvar$]]/.varvar$->ReactionSpeciesP;


(* ::Subsubsection::Closed:: *)
(*RxNP*)


RxNP::usage="
DEFINITIONS
		Matches any number of reaction products.
";
RxNP=With[{p = ReactionSpeciesP},
	Alternatives[
		p,
		HoldPattern[Times[p, _Integer?Positive]],
		HoldPattern[Plus[(p | Times[p, _Integer?Positive]) ..]]
	]];



(* ::Subsubsection::Closed:: *)
(*ImplicitReactionP*)


ImplicitReactionP::usage="
DEFINITIONS
		Matches a either a first or second order reaction that can be either reversible or irreversible
";
ImplicitReactionP=Alternatives[
	(* first order, irreversible, arbitrary number of products *)
	{Rule[ReactionSpeciesP,RxNP],Rate1P},
	(* second order, irreversible, arbitrary number of products *)
	{Rule[Times[ReactionSpeciesP,2]|Rx2P,RxNP],Rate2P},
	(* first order reversible *)
	{Equilibrium[ReactionSpeciesP,ReactionSpeciesP],Rate1P,Rate1P},
	(* second order reversible *)
	{Equilibrium[ReactionSpeciesP,Times[ReactionSpeciesP,2]|Rx2P],Rate1P,Rate2P},
	{Equilibrium[Times[ReactionSpeciesP,2]|Rx2P,ReactionSpeciesP],Rate2P,Rate1P},
	{Equilibrium[Times[ReactionSpeciesP,2]|Rx2P,Times[ReactionSpeciesP,2]|Rx2P],Rate2P,Rate2P}
];



(* ::Subsubsection::Closed:: *)
(*KineticTrajectoryP*)


KineticTrajectoryP::usage="";

KineticTrajectoryP=Trajectory[{ReactionSpeciesP..},{{_?NumberQ..}..},{_?NumberQ..},{_?TimeQ,_?ConcentrationQ|_?AmountQ|_?UnitsQ}];



(* ::Subsubsection::Closed:: *)
(*ThermodynamicTrajectoryP*)


ThermodynamicTrajectoryP::usage="";

ThermodynamicTrajectoryP=Trajectory[{ReactionSpeciesP..},{{_?NumberQ..}..},{_?NumberQ..},{_?TemperatureQ,_?ConcentrationQ|_?AmountQ}];



(* ::Subsubsection::Closed:: *)
(*TrajectoryP*)


TrajectoryP::usage="";


TrajectoryP=Alternatives[
	KineticTrajectoryP,
	ThermodynamicTrajectoryP
];



(* ::Subsubsection::Closed:: *)
(*ReactionTypeP*)


ReactionTypeP=Alternatives["Catch","Release","Catch&Release","RSTInteraction","Thresholding","Amplifcation"];



(* ::Subsubsection::Closed:: *)
(*NucleicAcidReactionTypeP*)


NucleicAcidReactionTypeP::usage="
DEFINITIONS
	MNucleicAcidReactionTypeP = Folding | Melting | Zipping | Unzipping | DuplexInvasion | StrandInvasion | Hybridization | Dissociation | ToeholdMediatedStrandExchange | ToeholdMediatedDuplexExchange | DuelToeholdMediatedDuplexExchange
		Matches a nucleic acid reaction type
";
NucleicAcidReactionTypeP = Folding | Melting | Zipping | Unzipping | DuplexInvasion | StrandInvasion | Hybridization | Dissociation | ToeholdMediatedStrandExchange | ToeholdMediatedDuplexExchange | DualToeholdMediatedDuplexExchange |
    Unknown | Unchanged;



(* ::Subsubsection::Closed:: *)
(*ReactionsOptionP*)


ReactionsOptionP::usage="
DEFINITIONS
	ReactionsOptionP = _FoldingReaction | _HybridizationReaction | _MeltingReaction | _ToeholdStrandExchangeReaction | _ToeholdDuplexExchangeReaction | _DualToeholdDuplexExchangeReaction
		Matches a nucleic acid reaction specification
";
ReactionsOptionP = Alternatives[
	FoldingReaction[StructureP],
	FoldingReaction[StructureP, {GreaterP[0, 1], GreaterP[0, 1]}], (* with a specific site *)
	HybridizationReaction[StructureP],
	HybridizationReaction[StructureP, StructureP],
	HybridizationReaction[{StructureP, {GreaterP[0, 1], GreaterP[0, 1]}}, StructureP],
	HybridizationReaction[StructureP, {StructureP, {GreaterP[0, 1], GreaterP[0, 1]}}],
	HybridizationReaction[{StructureP, {GreaterP[0, 1], {GreaterP[0, 1], GreaterP[0, 1]}}}, StructureP],
	HybridizationReaction[StructureP, {StructureP, {GreaterP[0, 1], {GreaterP[0, 1], GreaterP[0, 1]}}}],
	HybridizationReaction[{StructureP, {GreaterP[0, 1], GreaterP[0, 1]}}, {StructureP, {GreaterP[0, 1], GreaterP[0, 1]}}],
	MeltingReaction[StructureP],
	ToeholdStrandExchangeReaction[StructureP, StructureP],
	ToeholdDuplexExchangeReaction[StructureP, StructureP],
	DualToeholdDuplexExchangeReaction[StructureP, StructureP]
];



(* ::Subsection::Closed:: *)
(*Inventory*)


(* ::Subsubsection::Closed:: *)
(*SampleStatusP*)


SampleStatusP=(Stocked|Available|InUse|Discarded|Transit|Installed|PickedUp|Receiving|PostProcessing);

(* ::Subsubsection::Closed:: *)
(*SampleStatusP*)


StorageFormatP:=(Open|Pile|Undefined|Footprinted);

(* ::Subsubsection::Closed:: *)
(*SampleStatusP*)


StorageAvailabilityStatusP:=(InUse|Available|Discarded|Restricted|Reserved|Inactive|Invalid|Missing|Unsynced|Overflow);


(* ::Subsubsection::Closed:: *)
(*SensorArrayInstrumentStatusP*)


SensorArrayInstrumentStatusP=(Ready|Running|Standby|Error);



(* ::Subsubsection::Closed:: *)
(*BulletinStatusP*)


BulletinStatusP::usage="
DEFINITIONS
	BulletinStatusP=(Active|Inactive)
";
BulletinStatusP=Active|Inactive;



(* ::Subsubsection::Closed:: *)
(*PackagingP*)


PackagingP = Alternatives[Case,Pack,Single];



(* ::Subsubsection::Closed:: *)
(*SampleDescriptionP*)


SampleDescriptionP = Alternatives[
	ExquisiteGoatHairBrush,
	TransferTube,
	ChippingHammer,
	Scissors,
	AccessPoint,
	Adapter,
	Ampoule,
	BacterialPlug,
	Bag,
	BarcodeReader,
	Battery,
	Beaker,
	Blade,
	BlowGun,
	Board,
	Bottle,
	Box,
	Bracket,
	Bulb,
	Cable,
	Camera,
	Can,
	Cap,
	UncleCapillaryStrip,
	Carboy,
	Card,
	Cartridge,
	Clip,
	Column,
	Computer,
	ComputerCase,
	Cryotube,
	Cuvette,
	Cylinder,
	DIMM,
	Disk,
	DosingHead,
	Drive,
	Drum,
	Electrode,
	Envelope,
	FaceShield,
	Fan,
	Filter,
	FilterPlate,
	Fitting,
	Flask,
	Frit,
	Funnel,
	FurnitureEquipment,
	GelCassette,
	Glove,
	GraduatedCylinder,
	HeatGun,
	Hub,
	IceScraper,
	Indicator,
	Instrument,
	Inverter,
	Item,
	Keyboard,
	Kit,
	Lamp,
	Mallet,
	MicrofluidicChip,
	MicrofluidicChipFilter,
	Monitor,
	MountArm,
	Mouse,
	Needle,
	Pack,
	Packet,
	Pad,
	Pail,
	Part,
	Phone,
	Pipette,
	Plate,
	PlateCover,
	Plug,
	PowerSupply,
	Printer,
	Processor,
	ProductKey,
	Rack,
	ReactionVessel,
	Reservoir,
	Roll,
	Roller,
	Router,
	SafetyGlasses,
	Screwdriver,
	Sensor,
	Sheet,
	Sleeve,
	Sock,
	Spatula,
	Spigot,
	Stand,
	StirBar,
	Strip,
	Switch,
	Syringe,
	Tank,
	Tower,
	Tray,
	Tub,
	Tube,
	Tweezer,
	Valve,
	Vial,
	WasteBin,
	Weight,
	WeightHandle,
	Wrench
];



(* ::Subsubsection::Closed:: *)
(*UsageFrequencyP*)


UsageFrequencyP = (VeryLow | Low | High | VeryHigh);



(* ::Subsection:: *)
(*Parts*)


(* ::Subsubsection::Closed:: *)
(*ScrewdriveTypeP*)


ScrewdriveTypeP = Alternatives[Slotted, Phillips, Torx, Hex, Pozidriv, Square];



(* ::Subsubsection::Closed:: *)
(*ScrewdriverBitFootprintP*)


ScrewdriverBitFootprintP = Alternatives[Hexagonal6mm];



(* ::Subsubsection::Closed:: *)
(*ScrewdriveSizeCodeP*)


ScrewdriveSizeCodeP = Alternatives[
	(* Phillips *)
	ScrewdriveSizeCodePhillipsP,

	(* Slotted - fully covered by tip measurement *)

	(* Torx *)
	ScrewdriveSizeCodeTorxP,

	(* Pozidriv *)
	ScrewdriveSizeCodePozidrivP
];


(* ::Subsubsection::Closed:: *)
(*ScrewdriveSizeCodePhillipsP*)


ScrewdriveSizeCodePhillipsP = Alternatives["#0000","#000","#00","#0","#1","#2","#3","#4","#5"];


(* ::Subsubsection::Closed:: *)
(*ScrewdriveSizeCodeTorxP*)


ScrewdriveSizeCodeTorxP = Alternatives["T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T15","T20","T25","T27","T30","T40","T45","T50"];


(* ::Subsubsection::Closed:: *)
(*ScrewdriveSizeCodePozidrivP*)


ScrewdriveSizeCodePozidrivP = Alternatives["PZ0","PZ1","PZ2","PZ3","PZ4","PZ5"];


(* ::Subsubsection::Closed:: *)
(*TweezerTipTypeP*)


TweezerTipTypeP = Alternatives[
	StraightPointTip,
	SlantPointTip,
	StraightFlat,
	StraightDuckBill,
	OffsetFlat,
	VialGrippingTip
];



(* ::Subsubsection::Closed:: *)
(*MalletHandleMaterialP*)


MalletHandleMaterialP = Alternatives[Fiberglass, Hickory];


(* ::Subsubsection::Closed:: *)
(*MalletHeadColorP*)


MalletHeadColorP = Alternatives[White, Black];


(* ::Subsubsection::Closed:: *)
(*WrenchTypeP*)


WrenchTypeP = Alternatives[Socket, BoxEnd, OpenEnd, Adjustable, Hex, Torx];



(* ::Subsubsection:: *)
(*PlierTypeP*)
(* This should be a growing list if ever need to objectify more types of Pliers but for now this basic list should be good. *)


PlierTypeP=Alternatives[SlipJoint,Diagonal,Lineman,NeedleNose,BentNose,RoundNose,FlatNose,TongueAndGroove];



(* ::Subsubsection::Closed:: *)
(*VisorPropertiesP*)


VisorPropertiesP=(AntiFog|AntiScratch|Uncoated|Coated|Clear|Shaded);



(* ::Subsubsection::Closed:: *)
(*GloveSizeP*)


GloveSizeP=(ExtraSmall|Small|Medium|Large|ExtraLarge|Universal);



(* ::Subsubsection::Closed:: *)
(*GloveTypeP*)


GloveTypeP=(Cryogenic|Autoclave);



(* ::Subsubsection::Closed:: *)
(*GloveCoverageP*)


GloveCoverageP=(Wrist|MidArm|Elbow|Shoulder);



(* ::Subsubsection::Closed:: *)
(*FinShapeP*)


FinShapeP=(Rectangular|Triangular|Trapezoidal|Pin);



(* ::Subsubsection::Closed:: *)
(*ReactorConditionsP*)


ReactorConditionsP =(HighPressure|Cryogenic|Digestion);


(* ::Subsubsection::Closed:: *)
(*ReactorTypeP*)


ReactorTypeP =(Flow|Electrochemical|Microwave|Batch|SolidPhase|Robotic|Photochemical);


(* ::Subsubsection::Closed:: *)
(*ElectrophoresisRigP*)


ElectrophoresisRigP=Alternatives[Robotic, Precast];



(* ::Subsubsection::Closed:: *)
(*WaveformP*)


WaveformP = Alternatives[Sine, Square];



(* ::Subsubsection:: *)
(*BatteryMaterialsP*)


BatteryMaterialsP=Alternatives[SilverZinc,Alkaline,LeadAcid,LithiumIon];


(* ::Subsubsection:: *)
(*BrakeEngagementP*)


BrakeEngagementP=Alternatives[HandPedal,FootPedal,Electronic];


(* ::Subsubsection:: *)
(*FragmentAnalyzerNumberOfCapillariesP*)


FragmentAnalyzerNumberOfCapillariesP=Alternatives[96];


(* ::Subsubsection:: *)
(*FragmentAnalyzerCapillaryArrayLengthP*)


FragmentAnalyzerCapillaryArrayLengthP=Alternatives[Short];


(* ::Subsection::Closed:: *)
(*Locations*)


(* ::Subsubsection::Closed:: *)
(*Location object type groups*)


LocationContainerTypes = {Object[Container], Object[Instrument]};

(* TODO: Remove Object[Part], Object[Plumbing] and Object[Wiring] when item migration is completed *)
LocationNonContainerTypes = {Object[Sample], Object[Part], Object[Plumbing], Object[Wiring], Object[Item], Object[Sensor],Object[Package]};

LocationTypes = Join[LocationContainerTypes, LocationNonContainerTypes];

LocationContainerModelTypes = {Model[Container], Model[Instrument]};



(* ::Subsubsection::Closed:: *)
(*HandlingCategoryP*)


HandlingCategoryP = Alternatives[Radioactive, Sterile, Standard];



(* ::Subsubsection::Closed:: *)
(*LabAreaP*)


LabAreaP = Alternatives[Chemistry,Microbiology,Mammalian];



(* ::Subsubsection::Closed:: *)
(*LocationAssociationP*)


LocationAssociationP = KeyValuePattern[{
	"Object" -> ObjectP[],
	"Name" -> _String,
	"Position" -> _String
}];



(* ::Subsubsection::Closed:: *)
(*LocationPositionP*)


LocationPositionP = _String?(StringMatchQ[#,Alternatives[

	(* ---------- For general named slots ---------- *)

	(* e.g. MALDI Plate Slot *)
	___~~" Slot",
	(* e.g. Bench Slot 1 *)
	___~~"Slot "~~Repeated[DigitCharacter,3],
	(* e.g. Bench Slot A2-1 *)
	___~~"Slot "~~Repeated[LetterCharacter,3]~~Repeated[DigitCharacter,3]~~"-"~~Repeated[DigitCharacter,3],
	(* e.g. Slot A3 *)
	___~~"Slot "~~Repeated[LetterCharacter,3]~~Repeated[DigitCharacter,3],


	(* For Well Format (e.g. "A1") *)
	Repeated[LetterCharacter,3]~~Repeated[DigitCharacter,3]~~(EndOfString|HeadspaceSubdivisionPositionP),

	(* For interiors of enclosures and shipping boxes *)
	"Interior"~~___,

	(* For work surfaces of hoods and receiving benches *)
	"Work Surface",

	(* For stackable instruments or instruments that can hold things on top of them (e.g. TC hood) *)
	"Top "~~___~~"of Instrument",

	(* For digit-only position numbering, e.g. Hamilton tube racks *)
	Repeated[DigitCharacter],

	(* For freezer shelves *)
	"Shelf "~~Repeated[DigitCharacter],

	(* For sink cabinets and drawers *)
	___~~("Cabinet"|"Drawer"),

	(* For empty rooms to still plot properly *)
	"Placeholder Position",

	(* For Dionex Autosampler deck slots *)
	LetterCharacter,

	(* For leftover spaces on VLM Shelves *)
	("Left"|"Right"|"Top"|"Bottom")~~" margin",

	(* For MTP slots on STARlet racks *)
	"MTP "~~DigitCharacter,

	(* For S&R *)
	"Temporary Holding",

	(* For Syringes *)
	"Needle",

	(* For Gas Vents*)
	"Gas Valve "~~Repeated[DigitCharacter,3],

	(* For SymphonyX synthesizer *)
	SolventPositionsP,

	(* for plumbing ports *)
	___~~" Port "~~___

]]&);




(* ::Subsubsection::Closed:: *)
(*ConnectorNameP*)


ConnectorNameP = _String?(StringMatchQ[#,Alternatives[
	(* ---------- MUST SAY INLET?OUTLET ---------- *)
	___~~"Inlet"~~___,
	___~~"Outlet"~~___,
	___~~"Port"~~___
]]&);


(* ::Subsubsection::Closed:: *)
(* NOTE: ConnectorNameP and WiringConnectorNameP should not overlap *)
(*WiringConnectorNameP*)


WiringConnectorNameP = _String?(StringMatchQ[#,Alternatives[
	___~~"Wiring Connector"~~___,
	"Circuit " ~~ NumberString ~~ (", " ~~ NumberString)... ~~ " Hot " ~~ DigitCharacter ~~ " Terminal",
	"Circuit " ~~ NumberString ~~ (", " ~~ NumberString)... ~~ " Neutral Terminal",
	"Hot " ~~ DigitCharacter ~~ " Wire In",
	"Hot " ~~ DigitCharacter ~~ " Wire Out",
	"Neutral Wire In",
	"Neutral Wire Out",
	"Hot " ~~ DigitCharacter ~~ " Terminal",
	"Neutral Terminal",
	"Socket" ~~ ("" |" Top" | " Bottom" | " Top Left" | " Top Right" | " Bottom Left" | " Bottom Right" |" " ~~ DigitCharacter),
	"Wall Side Plug",
	"Instrument Side Plug",
	"Power Port",
	"Direct Power Cable"
]]&);


(* ::Subsubsection::Closed:: *)
(*LocationPositionPairP*)


LocationPositionPairP = {LocationPositionP,LocationPositionP};



(* ::Subsubsection::Closed:: *)
(*LocationContentsP*)


LocationContentsP = {LocationPositionP,ObjectP[{Object[Container],Object[Instrument],Object[Sample]}]};



(* ::Subsubsection::Closed:: *)
(*ContainerShape2DP*)


ContainerShape2DP = Alternatives[Rectangle,Circle,_Polygon];



(* ::Subsubsection::Closed:: *)
(*ContainerShape3DP*)


ContainerShape3DP = Alternatives[Cuboid,Cylinder,_Polygon];


(* ::Subsubsection::Closed:: *)
(*CrossSectionalShapeP*)


CrossSectionalShapeP = Alternatives[Circle,Rectangle,Oval,Triangle];


(* ::Subsubsection:: *)
(*FootprintP*)


FootprintP = Alternatives[
	HamiltonFilterTip,
	HamiltonNonFilterTip,
	Erlenmeyer50mLFlask,
	Erlenmeyer125mLFlask,
	Erlenmeyer250mLFlask,
	Erlenmeyer500mLFlask,
	Erlenmeyer1000mLFlask,
	PearShaped500mLFlask,
	PearShaped1000mLFlask,
	PearShaped2000mLFlask,
	PearShaped3000mLFlask,
	RoundBottom10mLFlask,
	RoundBottom25mLFlask,
	RoundBottom50mLFlask,
	RoundBottom100mLFlask,
	RoundBottom250mLFlask,
	RoundBottom300mLFlask,
	RoundBottom500mLFlask,
	RoundBottom2000mLFlask,
	SmallNonSelfStandingFlasks,
	MediumNonSelfStandingFlasks,
	LargeNonSelfStandingFlasks,
	Conical15mLTube,
	Conical50mLTube,
	Conical100mLTube,
	Conical250mLTube,
	Conical500mLTube,
	MicrocentrifugeTube,
	Round5mLTube,
	Round9mLTube,
	Round27mLTube,
	Round32mLTube,
	Round50mLTube,
	Round55mLTube,
	Round95mLTube,
	Round15mLBottle,
	Round10mLBottle,
	Round70mLBottle,
	Round2LBottle,
	Round4LBottle,
	CEVial,
	ThermoMatrixTube,
	HeadspaceVial,
	MALDIPlate,
	LunaticChip,
	SwingingBucket,
	PeptideSynthesizerReactionVessel,
	PeptideSynthesizerMonomerVessel,
	DNASynthesisColumn,
	DNASynthesizerReagentBottle,
	DNASynthesizerCartridge,
	DNASynthesizerValve,
	SPECartridge,
	SPE500uLCartridge,
	SPE1mLCartridge,
	SPE3mLCartridge,
	SPE6mLCartridge,
	GlassReactionVessel,
	AvantVial,
	PhytipColumn,
	Goniometer,
	XtalCheck,
	NMRTube,
	NMRTube3mm,
	NMRTubeInsert,
	UncleCapillaryClip,
	UncleCapillaryStrip,
	SelfStanding1mLTube,
	EchoPlate,
	TurboVapRack,
	CryogenicVial,
	ControlledRateFreezerRack,
	Round94mLUltraClearTube,
	Round32mLOptiTube,
	Round9mLOptiTube,
	Sachet,
	PCR12TubeStrip,
	PCRTube,
	BumpTrap250mL,
	NEBExpressVessel,
	QIAquick2mLTube,
	ReactionVessel10mL,
	ReagentBottle10mL,
	ReagentBottle13mL,
	ReagentBottle25mL,
	MatrixTube,
	CapillaryTube,
	(* === Centrifuge footprints === *)
	(* Naming convention:
		Rotors: <CentrifugeModelName>Rotor
		Buckets: <RotorModelName>Bucket (use centrifuge model name if rotor is not named separately or is nonremovable) *)
	(* Benchtop (new) *)
	AvantiJ15Rotor,
	AvantiJ15FixedAngleRotor,
	JS4750Bucket,
	Eppendorf5920RRotor,
	S4xUniversalBucket,
	(* Microcentrifuge *)
	Microfuge16Rotor,
	Microfuge20RRotor,
	(* Vacuum centrifuge *)
	GenevacEZ2Rotor,
	GenevacEZ2Bucket,
	SorvallX4RProMDRotor,
	TX750Bucket,
	SPD2030Rotor,
	SPD2030Bucket,
	PRO20Bucket,
	(* Ultracentrifuge *)
	XPN80Rotor,
	SW32Bucket,
	(* Benchtop (old) *)
	Allegra6Rotor,
	GH38Bucket,
	(* Robotic Centrifuge *)
	VSpinRotor,
	HiG4Rotor,
	(* ProteinSimple Maurice *)
	MauriceCartridge,
	MauriceCartridgeInsert,
	MauriceRunningBufferVial,
	(* ddPCR - QXOne *)
	QXONELargeBottle,
	QXONESmallBottle,
	(* Osmometer - Vapro 5600 *)
	Vapro5600SupplyContainer,
	Vapro5600WasteContainer,
	Vapro5600DesiccantCartridge,
	TorreyPinesShakerAdapter,
	(* qPCR array card *)
	ArrayCard,
	(* Lancer Dishwasher Racks *)
	LancerRack,
	(*Dynamic Foam Analyzer*)
	FoamAgitationModule,
	FoamFilter,
	FoamColumn,
	FoamStirBlade,
	FoamLiquidConductivityModule,
	FoamImagingModule,
	FoamORing,
	(*Flow Cytometer ZE5*)
	ZE5Tube5mL,
	(* microscope *)
	MicroscopeSlide,
	(* Hamilton *)
	HamiltonDeepWellPlateCarrier,
	HamiltonHeaterCoolerCarrier,
	HamiltonLightTableCarrier,
	HamiltonNimbusCarrier,
	HamiltonShakerCarrier,
	HamiltonTipTransportCarrier,
	HamiltonTrough200mLCarrier,
	HamiltonTrough50mLCarrier,
	HamiltonTube2mLCarrier,
	HamiltonVacuumManifoldCarrier,
	(* Avant FPLC *)
	AvantAutosampler,
	AvantFractionCollector,
	(* Agilent HPLC *)
	AgilentAutosamplerRack,
	(* Gilson *)
	Gilson201,
	Gilson345,
	GilsonMobile,
	GilsonPreactivation,
	GilsonWaste,
	(*Cell Incubator contents*)
	(*Decks*)
	CytomatTurntable,
	CytomatReservoir,
	Innova44PlateHotel,
	Innova44Flasks,
	MultitronPro3mm,
	MultitronPro25mm,
	Liconic,
	LiconicShaking,
	IncubatorShelf,
	(*Racks*)
	Cytomat18Position,
	Cytomat21Position,
	MicroplateHolderStack,
	Liconic10Position,
	Liconic8Position,
	(*Storage Organization*)
	AutoclaveTray,
	Bin3Position,
	Bin5Position,
	Minus20Rack,
	Minus80Rack,
	StandardAkroBin,
	LargeAkroBin,
	DeepStoreBox,
	HangingRack10Position,
	HangingRack2Position,
	InventoryContainerLarge,
	InventoryContainerMedium,
	InventoryContainerSmall,
	MrFrosty,
	NeedleBox,
	PortableChillerRackLarge,
	PortableChillerRackSmall,
	ShippingReceivingRack,
	SpillTray,
	StorageRack4x2,
	StorageRack5x2,
	StorageRack5x3,
	TackleBox,
	WireRack,
	Tube50mLRack24,
	MagnumHopperBin17x24x11,
    StrongHold48InchCabinetShelf,
	(*Container Holders*)
	SmallVessel,
	MediumVessel,
	LargeVessel,
	SmallTube,
	MediumTube,
	LargeTube,
	TubeRack,
	Plate,
	Carboy,
	Carboy2Position,
	CaryCuvette,
	CrossFlowBottle,
	DNASynthesizerColumnRack,
	LuerRack12Position,
	LuerRack1Position,
	OrbitalShaker,
	ReactionVesselRack,
	VialRack24Position,
	CuvetteRack,
	CombiFlashRack,
	(*Caps*)
	CapRack,
	ColumnCapRack,
	(*Optics*)
	BMGOpticsHolder,
	NikonObjectiveTuret,
	NikonOpticsTuret,
	(*IT*)
	HardDriveCase20Position,
	HardDriveCase5Position,
	(**)
	IKAElectrodeHolder,
	(*Miele Dishwasher*)
	MieleInjector,
	(*Ranger*)
	RagerElectrophoresisPedesdatl,
	(*Rheosense*)
	RheosenseAutosampler,
	(*Rotary Evaporator*)
	RotaryEvaporator,
	(*Sartorius*)
	SartoconSlice50Holder,
	(*Sonicator*)
	SonicationFloat50mL,
	SonicatorFloat15mL,
	SonicatorFloat2mL,
	(*SP-D 80*)
	SPD80ReactionVesselRack,
	(*Vacuum Manifold*)
	VacuumManifoldCollectionRack,
	VacuumManifoldTubeRack,
	(*ViiA7*)
	ViiA7,
	(*Vortex*)
	VortexInsert,
	(*ZE5*)
	ZE5Lifter,
	(*CrimpingJig*)
	Vial16mm,
	(* Syringes *)
	Syringe1mL,
	Syringe3mL,
	Syringe5mL,
	Syringe10mL,
	Syringe20mL,
	Syringe50mL,
	Syringe60mL,
	Syringe100mL,
	Syringe2mLGlass,
	Syringe10mLGlass,
	Syringe50mLGlass,
	Syringe1uLGC,
	Syringe5uLGC,
	Syringe10uLGC,
	Syringe25uLGC,
	Syringe100uLGC,
	Syringe2500uLGC,
	(* Dynamic Dialysis *)
	DialysisTubeMaxi,
	DialysisTubeMidi,
	DialysisTubeMini,
	(* Solid Phase Reactors *)
	SolidPhaseReactor10mL,
	SolidPhaseReactor25mL,
	SolidPhaseReactor50mL,
	SolidPhaseReactor100mL,
	SolidPhaseReactor250mL,
	(* Base Rod support *)
	RodClamp,
	(*special single position open*)
	SingleItem,
	(* Crimp Vials *)
	CrimpVial2mL13mm,
	CrimpVial50mL20mm,
	(* Kruss Single Fiber Tensiometer liquid container *)
	KrussSV10GlassSampleVessel,
	KrussSV20GlassSampleVessel,
	(* Other, to prevent using Open in Footprint fields *)
	UndefinedFootprint,
	(*Biotage PRESSURE+ pressure manifold*)
	PressurePlusDeck,
	PressurePlusCartridgeRack,
	(*GLSciences Gravity Rack Instrument System*)
	GravityRackCollectionTray,
	GravityRackGlasswareWide,
	GravityRackGlasswareNarrow,
	(*Biotage GravityRack Instrument*)
	BiotageGravityRackCartridgePlatform,
	(* uPulse Cross Flow *)
	MicroPulseBalance,
	BiotageGravityRackCartridgePlatform,
	(* pipette footprints *)
	Pipetus,
	PipetteLarge,
	PipetteMedium,
	PipetteSmall,
	PipetteMultiChannel,
	Cuvette1cm,
	(* MS4e *)
	ApertureTube,
	MS4e25mLCuvette,
	MS4e100mLBeaker,
	MS4e200mLBeaker,
	MS4e400mLBeaker,
	MS4eElectrolyteSolutionContainer,
	MS4eParticleWasteContainer,
	MS4eParticleInternalWasteContainer,
	MS4eParticleTrapContainer,
	SoftShell20LCarboy,
	(* QPix *)
	QPixTrack,
	QPixWashBath,
	QPixWashBathBristle,
	QTray,
	QPixLightTable,
	ColonyHandlerHeadCassette,
	(* Footprint specifically used by QualificationEngineBenchmark for re-racking/storage tests *)
	BenchmarkTestFootprint,
	(* storage container footprints *)
	StockPickerShelf,
	BenchShelf,
	FreezerShelf,
	AvantcoRefrigeratorShelf,
	MoTakCenterRefrigeratorShelf,
	MoTakSideRefrigeratorShelf,
	PlateRack,
	CartShelf,
	AcidCabinetShelf,
	FlammableCabinetShelf,
	AmbientVLMShelf,
	ColdVLMShelf,
	(* Freezers *)
	EnvironmentalSensorProbe,
	(*Desiccators have a generic slot for their loose desiccant *)
	StorageDesiccant,
	(*pH probe slots*)
	pHMeterProbe,
	pHMeterProbeHolder,
	pHMeterModule
];

(*CellIncubatorDeckP*)
CellIncubatorDeckP=Alternatives[
	CytomatTurntable,
	Innova44PlateHotel,
	Innova44Flasks,
	MultitronPro3mm,
	MultitronPro25mm,
	Liconic,
	LiconicShaking,
	IncubatorShelf
];

(*CellIncubatorRackP*)
CellIncubatorRackP=Alternatives[
	Cytomat18Position,
	Cytomat21Position,
	MicroplateHolderStack,
	Liconic10Position,
	Liconic8Position
];



(* ::Subsubsection::Closed:: *)
(*RotorGeometryP*)


RotorGeometryP=Alternatives[
	FixedAngleRotor,
	SwingingBucketRotor
];


(* ::Subsubsection::Closed:: *)
(*RotorAngleP*)


RotorAngleP=Alternatives[
	Degree23,
	Degree24,
	Degree90
];



(* ::Subsubsection::Closed:: *)
(*CentrifugeableFootprintP*)


(* Define a pattern of footprints that can be centrifuged *)
CentrifugeableFootprintP = Alternatives[
	Plate,
	Conical15mLTube,
	Conical50mLTube,
	MicrocentrifugeTube,
	SelfStanding1mLTube,
	Round95mLTube,
	Round32mLTube,
	Round9mLTube,
	Round94mLUltraClearTube,
	Round32mLOptiTube,
	Round9mLOptiTube,
	ArrayCard,
	CEVial
];


(* ::Subsection:: *)
(*Troubleshooting patterns*)


(* ::Subsubsection::Closed:: *)
(*TroubleshootingActionP*)


TroubleshootingActionP = Alternatives[
	Escalate,
	Ping
];



(* ::Subsubsection::Closed:: *)
(*TroubleshootingReportTypeP*)


TroubleshootingReportTypeP =  (Protocol | Application | Function | Transaction | General | Script);



(* ::Subsubsection::Closed:: *)
(*TroubleshootingTicketTypeP*)


TroubleshootingTicketTypeP =  (Protocol | General | Transaction | LongTask | QueueReordering | ForceQuit);



(* ::Subsubsection::Closed:: *)
(*RootCauseCategoryP*)


RootCauseCategoryP =  Alternatives[
	Alerts,
	Analysis,
	NoProblem,
	Duplicate,
	OperatorError,
	UserError,
	DeveloperIncorrectAction,
	(* Experiment, Compiler, Parser, Exporter, helper functions *)
	ProtocolCode,
	MaintenanceCode,
	QualificationCode,
	(* Upload functions, Resource functions, ReadyCheck, ShippingMaterials, Transaction code *)
	FrameworkCode,
	InstrumentSoftware,
	InstrumentHardware,
	CommandCenter,
	(* java script stuff *)
	EngineFrontEnd,
	(* mathematica tasks *)
	EngineBackEnd,
	Constellation,
	Network,
	IT,
	Facilities,
	FeatureRequest,
	Procedure,
	InsufficientVolume,
	SensorNet,
	Inventory,
	LostAndFound,
	Other
];

(* ::Subsubsection::Closed:: *)
(*ReadyCheckLogP*)

ReadyCheckLogP = {_?DateObjectQ, BooleanP, _Association};


(* ::Subsubsection::Closed:: *)
(*TroubleshootingKeywordsP*)


(* A list of keywords that can be used to tag tickets/reports/solutions for categorization *)
TroubleshootingKeywordsP = Alternatives[
	(* === Naming Conventions === *)
	(*
	- Use Singular rather than Plural (Resource, rather than Resources)
	- Adhere to experiment naming conventions when possible (Mix rather than Mixing)
	- Avoid -ing forms when it makes sense
	- Keywords can be multiple words or even a phrase (use CamelCase to combine them)
 *)
	AbsorbanceIntensity,
	AbsorbanceKinetics,
	AbsorbanceQuantification,
	AbsorbanceSpectroscopy,
	AgaroseGelElectrophoresis,
	AirInLine,
	Aliquot,
	AlternativePreparations,
	Ampoule,
	AspirationCap,
	Aspirator,
	Autoclave,
	ShippingMaterials,
	Balance,
	Balancing,
	BioLayerInterferometer,
	BioLayerInterferometry,
	BiosafetyCabinet,
	BlockingHardwareError,
	BlowGun,
	BottleRoller,
	BottleTopDispenser,
	Branch,
	Bug,
	Calibration,
	Camera,
	cDNAPrep,
	CellFreeze,
	CellMediaChange,
	CellSplit,
	CellThaw,
	Centrifuge,
	CheckIn,
	Checkpoint,
	CheckValve,
	CleanUp,
	ColonyHandler,
	Consolidation,
	Container,
	ControlledRateFreezer,
	CryogenicFreezer,
	Cuvette,
	CuvetteWasher,
	DangerZone,
	Darkroom,
	Deck,
	DensityMeter,
	Desiccator,
	DifferentialScanningCalorimeter,
	DifferentialScanningCalorimetry,
	Diffractometer,
	Dishwasher,
	Dispenser,
	Dispensing,
	DispensingHead,
	DNASynthesis,
	DNASynthesizer,
	Download,
	Electrophoresis,
	EmbeddedPC,
	Enclosure,
	Engine,
	ESI,
	Evaporate,
	Evaporation,
	Evaporator,
	FeatureRequest,
	FillToVolume,
	Filter,
	FilterBlock,
	FilterHousing,
	FlammableCabinet,
	FlashChromatography,
	FlowCytometer,
	FluorescenceIntensity,
	FluorescenceKinetics,
	FluorescenceSpectroscopy,
	FluorescenceThermodynamics,
	FPLC,
	Freezer,
	FrontEnd,
	FumeHood,
	Fuming,
	Funnel,
	GasFlowSwitch,
	GelBox,
	HandPump,
	Hardcoding,
	HeatBlock,
	HeatExchanger,
	Homogenizer,
	HPLC,
	HumanError,
	ImageSample,
	Incubate,
	Incubator,
	InformationTechnology,
	Instruction,
	InstrumentAvailability,
	Inventory,
	Inverter,
	IRSpectroscopy,
	Kernel,
	Kit,
	Lamp,
	LCMS,
	Lid,
	Lidding,
	LightMeter,
	LiquidHandler,
	LiquidLevelDetector,
	Logic,
	LuminescenceIntensity,
	LuminescenceKinetics,
	LuminescenceSpectroscopy,
	Lyophilize,
	Lyophilizer,
	MALDI,
	Matrix,
	MassSpectrometer,
	MassSpectrometry,
	MeasureCount,
	MeasureDensity,
	MeasurepH,
	MeasureSurfaceTension,
	MeasureVolume,
	MeasureWeight,
	Media,
	Microscope,
	Microwave,
	Misplacement,
	MissingObject,
	Mix,
	Movement,
	NamingConvention,
	NMR,
	NMR2D,
	NMRProbe,
	NonFulfillableResource,
	Nozzle,
	Objective,
	Operator,
	OperatorCart,
	OverheadStirrer,
	PAGE,
	PCR,
	Pellet,
	PeptideSynthesis,
	PeptideSynthesizer,
	PeristalticPump,
	pHMeter,
	Pipette,
	Placement,
	Plate,
	PlateImager,
	PlatePourer,
	PlateReader,
	PNASynthesis,
	PowderXRD,
	PowerDistributionUnit,
	PowerSupply,
	Preparation,
	PressureManifold,
	Processing,
	ProcessingStage,
	ProcessingStorage,
	ProteinPrep,
	ProtocolStatus,
	Purge,
	qPCR,
	Rack,
	Reactor,
	Receiving,
	RecordEnvironmentalData,
	RecordSensor,
	Refrigerator,
	Resource,
	ResourceThaw,
	Roller,
	RotaryEvaporator,
	Rotor,
	SampleImager,
	SampleLoss,
	SampleManipulation,
	Script,
	SensorArray,
	SensorNet,
	Shaker,
	Shipping,
	SilentHardwareError,
	SolidDispenser,
	SolidPhaseExtraction,
	SonicationHorn,
	Sonicator,
	Spectrophotometer,
	SpeedVac,
	Spill,
	StirrerShaft,
	StockSolution,
	Storage,
	StyleGuide,
	Subprotocol,
	SupercriticalFluidChromatography,
	Syringe,
	SyringePump,
	Tachometer,
	TemperatureProbe,
	Tensiometer,
	TensiometerProbe,
	Thermocycler,
	Timer,
	TotalProteinDetection,
	TotalProteinQuantification,
	Tracking,
	Transfection,
	Ultrasonic,
	UltrasonicIncompatible,
	Upload,
	UVMelting,
	VacuumCentrifuge,
	VacuumEvaporation,
	VacuumManifold,
	VacuumPump,
	VaporTrap,
	Ventilated,
	VerifyObject,
	VerticalLift,
	Vessel,
	Vortex,
	WaitAndSee,
	WaterPrep,
	WaterPurifier,
	Western

];


(* ::Subsubsection::Closed:: *)
(*SolutionStatusP*)


(* Possible solution states of Object[SupportTicket,Operations]s*)
SolutionStatusP = Open|Closed|Cold;


(* ::Subsubsection::Closed:: *)
(*PriorityP*)


PriorityP=(P1|P2|P3|P5);



(* ::Subsubsection::Closed:: *)
(*ECLApplicationP*)


ECLApplicationP=(Engine|CommandCenter|Nexus|Mathematica|DistroBuilder|Manifold);


(* ::Subsubsection::Closed:: *)
(*DatabaseRefreshStatusP*)


DatabaseRefreshStatusP=(Requested|Running|Failed|Suceeded|TimedOut|ManualInterventionRequired|NoDBCloneAvailable);


(* ::Subsection:: *)
(*Files*)


(* ::Subsubsection::Closed:: *)
(*FastFileTypeP*)


FastFileTypeP := Alternatives @@ $ImportFormats;


(* ::Subsubsection::Closed:: *)
(*XmlFileP*)


XmlFileP:=_String?(StringMatchQ[#,___~~".xml",IgnoreCase->True]&);



(* ::Subsection:: *)
(*Biology Patterns*)


(* ::Subsubsection::Closed:: *)
(*BaseMediumP*)


BaseMediumP=Alternatives["DMEM","DMEM/F12","MEM","RPMI","IMDM","LB","YPD"];

(* ::Subsubsection::Closed:: *)
(*RoboticMixTypeP*)


RoboticMixTypeP=Pipette | Shake;


(* ::Subsubsection::Closed:: *)
(*MammalianCellMorphologyP*)


MammalianCellMorphologyP:=Alternatives[Epithelial,Lymphoblast];



(* ::Subsubsection::Closed:: *)
(*AntibodyIsotypeP*)


AntibodyIsotypeP:=Alternatives[IgA,IgA1,IgA2,IgD,IgE,IgG,IgG1,IgG2a,IgG2b,IgG3,IgG4,IgM];



(* ::Subsubsection::Closed:: *)
(*AntibodyOrganismP*)


AntibodyOrganismP:=Alternatives[Cow,Donkey,Goat,Hamster,Human,Mouse,Rabbit,Rat,Chicken];



(* ::Subsubsection::Closed:: *)
(*AntibodyClonalityP*)


AntibodyClonalityP:=Alternatives[Monoclonal,Polyclonal];



(* ::Subsubsection::Closed:: *)
(*BacterialMorphologyP*)


BacterialMorphologyP:=Alternatives[
	Cocci, Diplocci, Pneumococci, Staphlycocci, Streptococci, Sarcina, Tetrad,
	Coccobacilli, Bacilli, Diplobacilli, Palisades, Streptobacilli,
	Vibrio, Spirillum, Spirochete, Other
];



(* ::Subsubsection::Closed:: *)
(*BacterialMorphologyP*)


BacterialFlagellaTypeP:=Monotrichous|Lophotrichous|Amphitrichous|Peritrichous;


(* ::Subsubsection::Closed:: *)
(*SubscriptionTypeP*)


SubscriptionTypeP:=Subscription|AlaCarte;



(* ::Subsubsection::Closed:: *)
(*BillStatusP*)


(*Open == In Progress*)
BillStatusP:=Open|Paid|Outstanding|Invoiced;


(* ::Subsubsection::Closed:: *)
(*CommitmentLengthP*)


CommitmentLengthP:=1 Month|3 Month|12 Month;


(* ::Subsubsection::Closed:: *)
(*AccountTypeP*)


AccountTypeP:=(Academia|Startup|Enterprise);


(* ::Subsubsection::Closed:: *)
(*CertificationLevelP*)


CertificationLevelP:="Level 1"|"Level 2"|"Level 3"|"Level 4";


(* ::Subsubsection::Closed:: *)
(*CleaningP*)


CleaningP:=Alternatives[
	"Dishwash glass/plastic bottle",
	"Dishwash plate seals",
	"Handwash large labware",
	"Autoclave sterile labware"
];


(* ::Subsubsection::Closed:: *)
(*BLIProbeTypeP*)


BLIProbeTypeP = Alternatives[APS,AR2G,SSA,AHC,AMC,SA,SAX,SAX2,AHQ,AMQ,HIS1K,HIS2,ProA,ProL,ProG,FAB2G,GST,NTA,GlyS,HCP,RPA,Custom];


(* ::Subsubsection::Closed:: *)
(*BLIAnalyteTypeP*)


BLIAnalyteTypeP = Alternatives[Lipids,Lyposomes,Antibodies,Antigens,HydrophobicProteins,Proteins,Amines,SmallMolecules,Fragments,LargeMolecules,HumanIgG,MouseIgG,HumanFcFusion,MouseFcFusion,BiotinylatedMolecules,HISTaggedProteins,GeneralIgG,HumanFabFragments,GSTTaggedProteins,SialicAcid,CHOHCP,ProteinA];


(* ::Subsubsection::Closed:: *)
(*BLIApplicationsP*)


BLIApplicationsP = Alternatives[Kinetics, EpitopeBinning, Quantitation, AssayDevelopment];



(* ::Subsubsection::Closed:: *)
(*BLIPrimitivenameP*)


BLIPrimitiveNameP = Alternatives[Equilibrate, Wash, ActivateSurface, Quench, LoadSurface, Regenerate, Neutralize, MeasureBaseline, MeasureAssociation, MeasureDissociation, Quantitate];


(* ::Subsubsection::Closed:: *)
(*TraceMetalGradeDigestionAgentP*)


TraceMetalGradeDigestionAgentP = Alternatives[
	ObjectP[Model[Sample,"Nitric Acid 70% (TraceMetal Grade)"]],
	ObjectP[Model[Sample,"Hydrochloric Acid 37%, (TraceMetal Grade)"]],
	ObjectP[Model[Sample,"Sulfuric Acid 96% (TraceMetal Grade)"]],
	ObjectP[Model[Sample,"Phosphoric Acid 85% (>99.999% trace metals basis)"]],
	ObjectP[Model[Sample,"Hydrogen Peroxide 30% for ultratrace analysis"]],
	ObjectP[Model[Sample,"Milli-Q water"]]
];



(* ::Subsubsection::Closed:: *)
(*OrganismTypeP*)


OrganismTypeP:=Alternatives[Mammalian,Microbial];


(* ::Subsubsection::Closed:: *)
(*FreezeCellMethodP*)


FreezeCellMethodP=Alternatives[InsulatedCooler,ControlledRateFreezer];



(* ::Subsubsection::Closed:: *)
(*FreezingTypeP*)


FreezingTypeP=Discard|FlashFreeze|FreezeCells;



(* ::Subsection:: *)
(*Analysis*)


(* ::Subsubsection::Closed:: *)
(*MeltingPointMethodP*)


MeltingPointMethodP = MidPoint | InflectionPoint | Derivative;



(* ::Subsubsection::Closed:: *)
(*PeaksMethodP*)


PeaksMethodP = Derivative | AbsoluteThreshold | RelativeThreshold;



(* ::Subsubsection::Closed:: *)
(*DataPointsP*)


DataPointsP = MatrixP[NumericP]|MatrixP[UnitsP[]]|MatrixP[_?DistributionParameterQ]| MatrixP[UnitsP[]|_?DistributionParameterQ] | _?QuantityMatrixQ;


(* ::Subsubsection::Closed:: *)
(*FitExpressionP*)


fitTypeSymbolP = Linear | Cubic | Polynomial | Exponential | Gaussian | Sigmoid | Log | LogLinear | LinearLog | LogPolynomial | Tanh | ArcTan | Erf | Logistic | LogisticBase10 | GeneralizedLogistic | LogisticFourParam | Exp4 | SinhCosh;

FitExpressionP = fitTypeSymbolP | Other;


(* ::Subsubsection::Closed:: *)
(*FitTypeP*)


(* FitTypeP is for function input. FitExpressionP is for object field. *)
FitTypeP = fitTypeSymbolP | _Function;



(* ::Subsubsection::Closed:: *)
(*SmoothingMethodP*)


SmoothingMethodP = Gaussian | Mean | MeanShift | TrimmedMean | Median | Bilateral | SavitzkyGolay | LowpassFilter | HighpassFilter;


(* ::Subsubsection::Closed:: *)
(*SmoothingInputDataTypesP*)


(* SmoothingInputDataTypesP = {
  Object[Data,Chromatography],
  Object[Data,AbsorbanceSpectroscopy],
  Object[Data,MassSpectrometry],
  Object[Data,NMR],
  Object[Data,FluorescenceSpectroscopy],
  Object[Data,LuminescenceSpectroscopy],
  Object[Data,IRSpectroscopy],
  Object[Data,AgaroseGelElectrophoresis],
  Object[Data, DifferentialScanningCalorimetry]
}; *)



(* ::Subsubsection::Closed:: *)
(*NumberP*)


NumberP::usage="
DEFINITIONS
	NumberP = Alternatives[_Real,_Rational,_Integer]
		Matches an integer, rational, or real number.
";
NumberP=Alternatives[_Real,_Rational,_Integer];


(* ::Subsubsection::Closed:: *)
(*NVectorP*)


NumberP::usage="
DEFINITIONS
	NVectorP:={_?NumericQ..}
		Matches an integer, rational, or real number.
";
NVectorP:={_?NumericQ..};


(* ::Subsubsection::Closed:: *)
(*CoordinatesP*)


CoordinatesP::usage="
DEFINITIONS
	{{NumericP,NumericP}..}
		Matches a list of number pairs
";
CoordinatesP={{NumericP,NumericP}..};


(* ::Subsubsection::Closed:: *)
(*Coordinates3DP*)


Coordinates3DP::usage="
DEFINITIONS
	{{NumericP,NumericP,NumericP}..}
		Matches a list of number triples
";
Coordinates3DP={{NumericP,NumericP,NumericP}..};



(* ::Subsubsection::Closed:: *)
(*NumericP*)


NumericP = _?NumericQ;



(* ::Subsubsection::Closed:: *)
(*SquareNumericMatrixP*)


SquareNumericMatrixP = _?(And[SquareMatrixQ[#],MatrixQ[#,NumericQ]]&);



(* ::Subsubsection::Closed:: *)
(*DateCoordinateP*)


DateCoordinateP::usage="
DEFINITIONS
	{{(DateListP|_?DateObjectQ),NumberP}..}
		Matches a list of number pairs
";
DateCoordinateP={{(DateListP|_?DateObjectQ),NumberP}..};



(* ::Subsubsection::Closed:: *)
(*DistributionCoordinatesP*)


DistributionCoordinatesP::usage="A set of coordinates where each point is a distribution.";
DistributionCoordinatesP = Alternatives[
	{{_?DistributionParameterQ,_?DistributionParameterQ}..},
	{{_?NumericQ,_?DistributionParameterQ}..},
	{{_?DistributionParameterQ,_?NumericQ}..}
];



(* ::Subsubsection::Closed:: *)
(*AutoP*)


AutoP::usage="
DEFINITIONS
	Automatic|Full|All
		For Grids, PlotRanges etc.
";
AutoP=Automatic|Full|All;



(* ::Subsubsection::Closed:: *)
(*PlotRangeP*)


PlotRangeP=Alternatives[
	Automatic,
	All,
	Full,
	{ Automatic|All|Full|_?UnitsQ | { Automatic|All|Full|_?UnitsQ, Automatic|All|Full|_?UnitsQ },Automatic|All|Full|_?UnitsQ| { Automatic|All|Full|_?UnitsQ, Automatic|All|Full|_?UnitsQ }}
];


(* ::Subsubsection::Closed:: *)
(*ItemSizeP*)


ItemSizeP::usage="
DEFINITIONS
	AutoP|_Integer|{_Integer|AutoP},{_Integer|AutoP,_Integer|AutoP},{{_Integer|AutoP..},{_Integer|AutoP..}}
		For Grids, PlotRanges etc.
";
ItemSizeP=Alternatives[
	AutoP|_Integer,
	{_Integer|AutoP,_Integer|AutoP},
	{{_Integer..},{_Integer..}}
];


(* ::Subsubsection::Closed:: *)
(*GraphicsSizeP*)


GraphicsSizeP = (Tiny | Small | Medium | Large | GreaterP[0]);



(* ::Subsubsection::Closed:: *)
(*ImageSizeP*)


ImageSizeP::usage="
DEFINITIONS
	Alternatives[_?NumericQ,{_?NumericQ},{_?NumericQ|Automatic,_?NumericQ|Automatic},{{_?NumericQ,_?NumericQ},{_?NumericQ,_?NumericQ}},Automatic,Tiny,Small,Medium,Large,Full,Scaled[_?NumericQ],All]
		possible input into Mathematica's ImageSize option for Rasterize and other Mathematica image functions.
";
imageSizeP=Alternatives[
	_?NumericQ,
	{_?NumericQ},
	{_?NumericQ,_?NumericQ},
	Automatic,
	Tiny,
	Small,
	Medium,
	Large,
	Full,
	Scaled[_?NumericQ],
	All
];
ImageSizeP=imageSizeP|{imageSizeP,imageSizeP};


(* ::Subsubsection::Closed:: *)
(*FunctionP*)


FunctionP::usage="
DEFINITIONS
	FunctionP = _Function|_InterpolatingFunction|_InverseFunction
		Matches a pure function or inverse function or interpolating function
";
FunctionP:=(_Function|_InterpolatingFunction|_InverseFunction);


(* ::Subsubsection::Closed:: *)
(*MetricP*)


MetricP::usage="
DEFINITION
	MetricP = Yotta|Zetta|Exa|Peta|Tera|Giga|Mega|Kilo|Hecto|Deca|Deci|Centi|Milli|Micro|Nano|Pico|Femto|Atto|Zepto|Yocto}
		Matches a pure function or inverse function or interpolating function
";

MetricP=Alternatives[Yotta,Zetta,Exa,Peta,Tera,Giga,Mega,Kilo,Hecto,Deca,Deci,Centi,Milli,Micro,Nano,Pico,Femto,Atto,Zepto,Yocto];


(* ::Subsubsection::Closed:: *)
(*InequalityP*)


(* In order to match, the pattern needs to be held. *)
InequalityP=_RangeP|_GreaterP|_LessP|_GreaterEqualP|_LessEqualP;


CommandBuilderOutputP=Result | Options | Preview | Tests;



(* ::Subsubsection::Closed:: *)
(*OneDimensionalGateP*)


OneDimensionalGateP={
	_Integer,
	_?NumericQ,
	Below|Above
};


(* ::Subsubsection::Closed:: *)
(*TwoDimensionalGateP*)


TwoDimensionalGateP={
	_Integer,
	_Integer,
	_Polygon,
	Include|Exclude
};


(* ::Subsubsection::Closed:: *)
(*ThreeDimensionalGateP*)


ThreeDimensionalGateP={
	_Integer,
	_Integer,
	_Integer,
	_Polygon|_Ellipsoid,
	Include|Exclude
};


(* ::Subsubsection::Closed:: *)
(*ClusteringAlgorithmP*)


ClusteringAlgorithmP::usage="A recognized ClusteringAlgorithm for AnalyzeClusters.";
ClusteringAlgorithmP=Alternatives[
	Automatic,

	(* Mathematica built-in methods *)
	Agglomerate,
	DBSCAN,
	JarvisPatrick,
	KMeans,
	KMedoids,
	MeanShift,
	NeighborhoodContraction,
	SpanningTree,
	Spectral,

	(* Custom implementations *)
	GaussianMixture,
	SPADE
];


(* ::Subsubsection::Closed:: *)
(*ClusterCriterionFunctionP*)


ClusterCriterionFunctionP::usage="A recognized CriterionFunction used by AnalyzeClusters to determine an appropriate NumberOfClusters.";
ClusterCriterionFunctionP=Alternatives[
	StandardDeviation,
	RSquared,
	VarianceRatio,
	Dunn,
	DaviesBouldin,
	Silhouette
];


(* ::Subsubsection::Closed:: *)
(*CovarianceTypeP*)


CovarianceTypeP::usage="A recognized CovarianceType used by AnalyzeClusters to fit a GaussianMixture model.";
CovarianceTypeP=Alternatives[
	Full,FullShared,Diagonal,Spherical
];


(* ::Subsubsection::Closed:: *)
(*ClusterDissimilarityFunctionP*)


ClusterDissimilarityFunctionP::usage="A recognized ClusterDissimilarityFunction used by AnalyzeClusters to evaluate the separation distance between neighboring partitions during agglomerative clustering.";
ClusterDissimilarityFunctionP=Alternatives[
	Single,Complete,Average,Centroid,Median,Ward,WeightedAverage
];


(* ::Subsubsection:: *)
(*BaselineP*)


BaselineP::usage="Available methods for computing peak baselines in AnalyzePeaks.";
BaselineP=Alternatives[
	LocalConstant,LocalLinear,DomainConstant,DomainLinear,DomainNonlinear,EndpointLinear,GlobalConstant,GlobalLinear,GlobalNonlinear
];



(* ::Subsection:: *)
(*Training*)


(* ::Subsubsection::Closed:: *)
(*SafetyTrainingP*)


SafetyTrainingP::usage="Safety Trainings in the ECL.";
SafetyTrainingP = Biosafety|ChemicalHandling|BloodbornePathogen;



(* ::Subsubsection::Closed:: *)
(*LabTechniqueTrainingP*)


LabTechniqueTrainingP::usage="Lab Technique Trainings in the ECL.";
LabTechniqueTrainingP = Cart|IT|VLM|Pipette|GraduatedCylinder|Balance|Needle|InstrumentInteraction|ShippingAndReceiving;


(* ::Subsection:: *)
(* Cell Incubation Patterns *)

CellIncubationCarbonDioxideP = Alternatives[5 Percent];

CellIncubationTemperatureP = Alternatives[30 Celsius, 37 Celsius];

CellIncubationRelativeHumidityP = Alternatives[93 Percent];

CellIncubatorShakingRadiusP=Alternatives[3 Millimeter, 25 Millimeter, 25.4 Millimeter];

CellIncubationShakingRateP=Alternatives[200 RPM, 250 RPM, 400 RPM]

IncubationStrategyP=Alternatives[Time, QuantificationTarget];

QuantificationMethodP=Alternatives[Confluency, OpticalDensity, Nephelometry, CellCount, ColonyCount];

(* ::Subsubsection::Closed:: *)
(*CrimpTypeP*)


CrimpTypeP = Alternatives[
	FlipOff,
	Aluminium
];



(* ::Subsubsection:: *)
(*CoverFootprintP*)


CoverFootprintP::usage="The footprint of the cover that is to be placed on a container.";
CoverFootprintP = Alternatives[
	CapPlace130x8, CapScrewBottle47x26, Cap13425, Cap1420PlaceFlask, Cap15425, Cap20400, Cap20415, Cap22400,
	Cap24400, Cap2440PlaceFlask, Cap24415, Cap28400, Cap28410, Cap38430,
	Cap83B, CapBODPlaceFlask, CapBottleScrew15x10, CapCrimpBottle14x7,
	CapCrimpBottle21x7, CapCrimpBottle21x8, CapCrimpBottle22x9,
	CapCrimpBottle27x8, CapCrimpVial11x6, CapCrimpVial20x8,
	CapCrimp23x43,Cap42x32,Cap22x8,
	CapScrewBottle36x29, CapSnap8x23, CapSnap8x38, CapScrewBottle60x15, CapScrewBottle64x37, CapScrewBottle123x19,
	CapGL14Cuvette, CapGL45, CapPlace1x4, CapPlace4x8, CapPlace7x6,CapPlace7x8,
	CapPlace8x126,CapPlace8x4, CapPlace8x7, CapPlace12x2, CapPlace104x7, CapPlace12x33, CapPlace37x8, CapPlace38x8, CapPlace94x85, CapPlace94x7,CapPlace95x6,
	CapPlaceBottle64x68, CapPlaceTube16x15, CapPlaceTube26x18,CapScrewBottle32x149,
	CapPlaceTube40x31, CapPlaceTubeBellTop26x18, CapScrewBottle103x34,
	CapScrewBottle104x20, CapScrewBottle113x17, CapScrewBottle122x25,
	CapScrewBottle127x267, CapScrewBottle127x67, CapScrewBottle12x18,
	CapScrewBottle12x7, CapScrewTube15x7, CapScrewBottle15x9, CapScrewBottle166x48,
	CapScrewBottle16x19, CapScrewBottle16x9, CapScrewBottle175x35,
	CapScrewBottle17x13, CapScrewBottle18x10, CapScrewBottle19x20,
	CapScrewBottle19x26, CapScrewBottle21x11, CapScrewBottle21x12,
	CapScrewBottle21x13, CapScrewBottle21x15, CapScrewBottle21x16,
	CapScrewBottle21x21, CapScrewBottle22x10, CapScrewBottle22x11, CapScrewBottle22x12,
	CapScrewBottle22x15, CapScrewBottle22x16, CapScrewBottle23x11,
	CapScrewBottle23x12, CapScrewBottle23x14, CapScrewBottle23x15,
	CapScrewBottle24x11, CapScrewBottle24x15, CapScrewBottle24x16,
	CapScrewBottle24x17, CapScrewBottle24x18, CapScrewBottle24x19, CapScrewBottle24x20,
	CapScrewBottle24x21, CapScrewBottle25x10, CapScrewBottle25x11,
	CapScrewBottle25x12, CapScrewBottle25x14, CapScrewBottle25x20,
	CapScrewBottle25x52, CapScrewBottle26x12, CapScrewBottle26x20,
	CapScrewBottle26x21, CapScrewBottle26x22, CapScrewBottle27x11,
	CapScrewBottle27x12, CapScrewBottle27x15, CapScrewBottle27x20,
	CapScrewBottle28x12, CapScrewBottle28x13, CapScrewBottle28x15, CapScrewBottle28x16,
	CapScrewBottle28x18, CapScrewBottle28x40, CapScrewBottle29x17,
	CapScrewBottle29x24, CapScrewBottle30x11, CapScrewBottle30x12,
	CapScrewBottle30x19, CapScrewBottle30x20, CapScrewBottle30x21, CapScrewBottle30x30, CapScrewBottle30x60,
	CapScrewBottle30x80, CapScrewBottle31x11, CapScrewBottle31x12,
	CapScrewBottle31x14, CapScrewBottle31x16, CapScrewBottle31x17,
	CapScrewBottle31x18, CapScrewBottle31x19, CapScrewBottle31x21,
	CapScrewBottle31x25, CapScrewBottle31x26, CapScrewBottle32x13,
	CapScrewBottle32x15, CapScrewBottle32x16, CapScrewBottle32x19,
	CapScrewBottle32x20, CapScrewBottle32x22, CapScrewBottle32x23,CapScrewBottle32x27, CapScrewBottle32x32,
	CapScrewBottle32x71, CapScrewBottle32x76, CapScrewBottle33x19,CapScrewBottle33x26,CapScrewBottle34x11,
	CapScrewBottle34x13, CapScrewBottle34x17, CapScrewBottle34x20, CapScrewBottle35x11,
	CapScrewBottle35x12, CapScrewBottle35x175, CapScrewBottle36x12, CapScrewBottle36x16,
	CapScrewBottle36x19, CapScrewBottle36x21, CapScrewBottle36x23, CapScrewBottle37x17,
	CapScrewBottle37x22, CapScrewBottle37x23, CapScrewBottle37x25,
	CapScrewBottle37x30, CapScrewBottle38x19, CapScrewBottle38x20,
	CapScrewBottle38x25, CapScrewBottle38x27, CapScrewBottle38x29,
	CapScrewBottle40x11, CapScrewBottle40x12, CapScrewBottle40x16,
	CapScrewBottle40x28, CapScrewBottle40x34, CapScrewBottle41x12, CapScrewBottle41x14,
	CapScrewBottle41x16, CapScrewBottle41x30, CapScrewBottle42x15,
	CapScrewBottle42x16, CapScrewBottle42x26, CapScrewBottle42x27,
	CapScrewBottle42x30, CapScrewBottle43x13, CapScrewBottle43x16,
	CapScrewBottle43x26, CapScrewBottle43x29, CapScrewBottle43x41, CapScrewBottle43x84,
	CapScrewBottle44x11,
	CapScrewBottle44x36, CapScrewBottle45x17, CapScrewBottle45x20,
	CapScrewBottle46x11, CapScrewBottle46x15, CapScrewBottle46x16,CapScrewBottle46x20,
	CapScrewBottle46x23, CapScrewBottle47x21, CapScrewBottle48x16,
	CapScrewBottle48x24, CapScrewBottle48x25, CapScrewBottle48x29,
	CapScrewBottle49x24, CapScrewBottle49x27, CapScrewBottle49x37, CapScrewBottle49x38, CapScrewBottle50x11,
	CapScrewBottle50x12, CapScrewBottle50x28, CapScrewBottle50x32, CapScrewBottle50x38,
	CapScrewBottle51x12, CapScrewBottle51x16, CapScrewBottle51x22, CapScrewBottle51x47,
	CapScrewBottle52x25, CapScrewBottle52x38, CapScrewBottle53x18,
	CapScrewBottle54x19, CapScrewBottle54x26, CapScrewBottle55x12, CapScrewBottle55x19,
	CapScrewBottle55x31, CapScrewBottle57x17, CapScrewBottle58x17,
	CapScrewBottle58x79, CapScrewBottle59x11, CapScrewBottle59x39,
	CapScrewBottle60x13, CapScrewBottle60x19, CapScrewBottle60x30,
	CapScrewBottle60x38, CapScrewBottle61x21, CapScrewBottle61x22, CapScrewBottle62x21,
	CapScrewBottle63x22, CapScrewBottle64x27, CapScrewBottle65x18,
	CapScrewBottle66x27, CapScrewBottle67x11, CapScrewBottle68x17, CapScrewBottle68x18,
	CapScrewBottle68x27, CapScrewBottle68x37, CapScrewBottle70x40, CapScrewBottle72x12,
	CapScrewBottle73x12, CapScrewBottle78x30, CapScrewBottle78x32,
	CapScrewBottle79x28, CapScrewBottle80x30, CapScrewBottle84x43,
	CapScrewBottle86x27, CapScrewBottle87x28, CapScrewBottle87x30,
	CapScrewBottle92x15, CapScrewBottle92x18, CapScrewBottle92x21,
	CapScrewBottle93x15, CapScrewBottle99x88, CapScrewBucket127x60, CapScrewBottle111x99,
	CapScrewCarboy104x31, CapScrewCarboy74x23, CapScrewCartridge12x10,
	CapScrewColumn7x13, CapScrewCuvette18x17, CapScrewDropletBottle18x25,
	CapScrewDrum42x14, CapScrewFlask26x16, CapScrewFlask32x20,
	CapScrewFlask34x22, CapScrewFlask38x30, CapScrewFlask49x30,
	CapScrewReactor20x17, CapScrewReactor32x40, CapScrewReactor41x25,
	CapScrewReservoir145x27, CapScrewTank168x110, CapScrewTube9x7, CapScrewTube10x17,
	CapScrewTube10x18, CapScrewTube10x7, CapScrewTube11x13, CapScrewTube11x17,
	CapScrewTube11x21, CapScrewTube11x30, CapScrewTube12x6, CapScrewTube12x9, CapScrewTube12x10,
	CapScrewTube12x15, CapScrewTube12x17, CapScrewTube12x18,
	CapScrewTube12x27, CapScrewTube12x5, CapScrewTube13x10, CapScrewTube13x2,
	CapScrewTube13x11, CapScrewTube13x14, CapScrewTube13x15,
	CapScrewTube13x17, CapScrewTube13x20, CapScrewTube13x21, CapScrewTube13x5,
	CapScrewTube13x6, CapScrewTube13x6Brown, CapScrewTube13x8, CapScrewTube13x9,
	CapScrewTube14x14, CapScrewTube14x15, CapScrewTube14x20,
	CapScrewTube14x25, CapScrewTube14x31, CapScrewTube15x12,
	CapScrewTube15x27, CapScrewTube16x8, CapScrewTube16x9, CapScrewTube16x17, CapScrewTube16x18, CapScrewTube16x21, CapScrewTube17x10,
	CapScrewTube18x9, CapScrewTube18x10, CapScrewTube18x12, CapScrewTube18x13, CapScrewTube18x16, CapScrewTube18x24,
	CapScrewTube19x15, CapScrewTube19x27, CapScrewTube19x54,
	CapScrewTube1x2, CapScrewTube20x104, CapScrewTube20x11,
	CapScrewTube20x13, CapScrewTube20x14, CapScrewTube20x25,
	CapScrewTube20x26, CapScrewTube20x27, CapScrewTube20x34,
	CapScrewTube21x22, CapScrewTube22x10, CapScrewTube24x15,
	CapScrewTube2x1, CapScrewTube31x27, CapScrewTube35x13, MembraneCapScrewTube35x13,
	CapScrewTube35x23, CapScrewTube50x21, CapScrewTube5x12,
	CapScrewTube6x13, CapScrewTube7x10, CapScrewTube8x7, CapScrewTube8x14,
	CapScrewTube9x10, CapScrewTube9x14, CapScrewTube34x25, CapScrewVial12x6,
	CapScrewVial16x10, CapScrewVial16x9, CapScrewVial17x9,
	CapScrewVial19x11, CapScrewVial19x13, CapScrewVial21x12,
	CapScrewVial24x12, CapScrewVial31x12, CapScrewVial40x38,
	CapScrewVial40x44, CapScrewVial40x45, CapScrewVial40x52,
	CapSize10RubberStopper, CapSize13PlaceFlask, CapSize16PlaceFlask,
	CapSize19PlaceFlask, CapSize1RubberStopper, CapSize22PlaceFlask,
	CapSize27PlaceFlask, CapSize38PlaceFlask, CapSize5RubberStopper,
	CapSize6RubberStopper, CapSize7RubberStopper, CapSize8RubberStopper,
	CapSize9PlaceFlask, CapSize9RubberStopper, CapSnap7x6, CapSnap12x1, CapSnap13x1,CapSnap13x2,CapSnap13x3,CapSnap12x35,
	CapSnap12x61,CapSnap20x4,CapSnap36x27, CapSnap95x7, CapSnap130x150,CapSnap85x8, CapSnapBottle115x9,
	CapSnapBottle12x12, CapSnapBottle131x10, CapSnapBottle19x9,
	CapSnapBottle22x9, CapSnapBottle25x11, CapSnapBottle37x38,
	CapSnapBottle55x5, CapSnapCan76x8, CapSnapCartridge13x8,
	CapSnapCartridge17x6, CapSnapFlask43x9, CapSnapTub119x40,
	CapSnapTub90x21, CapSnapTube19x12, CapSnapTube22x12,
	CapSnapTube22x19, CapSnapTube38x8, CapSnapTube8x10, CapSnapTube8x16,
	CapSnapTube8x5, CapSnapTube9x5, CapSnapVial12x6, CapSnapVial31x16,
	CapSnapVial8x11, CapSnapVial8x7, Cap250milOD, Crimped8mmCap, Crimped11mmCap, Crimped13mmCap, Crimped20mmCap,
	Crimped30mmCap, Crimped32mmCap, Crimped328mmCap, DLSPlateSeal, Lid0x2, Lid0x8, Lid0x9, Lid100mLDish,
	Lid1WellDish, Lid1x10, Lid35mLDish, LidBox257x200, LidBranson1800,
	LidBranson5800, LidCuvette12x12, LidCuvette13x5, LidDelta8WashTray, LidLabArmorChillBucket,
	LidPlace8x126, LidPlace133x9, LidSBS12WellTC, LidSBS24WellTC, LidSBS6WellTC,
	LidSBSCellvis12WellTC, LidSBSCellvis6WellTC, LidSBSGreiner96Well,
	LidSBSNunc12WellTC, LidSBSNunc24WellTC, LidSBSNunc48WellTC,
	LidSBSNunc6WellTC, LidSBSNunc96WellTC, LidSBSUniversal, SBSPlateLid,
	SealGCR96, SealSBS, SealSBS24SquareWell, SealSBS48SquareWell,
	SealSBS96RoundWell, SealSBS96SquareWell, SealSBS96Well,
	SealStrip12Well, Septum12x12, Septum1420Flask, Septum19x9,
	Septum2440Flask, Septum31x16, TubeCap50mL, CrossFlowContainerCap50mL,
	CrossFlowContainerCap250mL,CrossFlowContainerCap500mL, SIQualCap,CapSnap27x21,CapScrewTube18x14,Cap11x27,CapSnap38x6,
	Cap57x83, CapScrewSpigotCarboy20L
];



(* ::Subsubsection::Closed:: *)
(*CoverTypeP*)


CoverTypeP::usage="The different types of covers that are supported in the ECL.";
CoverTypeP = Crimp | Seal | Screw | Snap | Place | Pry;



(* ::Subsubsection::Closed:: *)
(*SealTypeP*)


SealTypeP = Adhesive|TemperatureActivatedAdhesive|PressFit;


(* ::Subsubsection::Closed:: *)
(*pHP*)


pHP::usage="Possible pH values";
pHP=RangeP[0,14];


(* ::Subsubsection::Closed:: *)
(*ConductivityP*)


ConductivityP::usage="Possible conductivity values";
ConductivityP=GreaterEqualP[0*Micro Siemens/Centimeter];


(* ::Subsubsection::Closed:: *)
(*IpP*)


IpP::usage="
DEFINITIONS
	IpP=_String?(StringMatchQ[#1,
    Repeated[DigitCharacter, {1, 3}] ~~ \".\" ~~
     Repeated[DigitCharacter, {1, 3}] ~~ \".\" ~~
     Repeated[DigitCharacter, {1, 3}] ~~ \".\" ~~
     Repeated[DigitCharacter, {1, 3}]] &)
";

IpP=_String?(StringMatchQ[#1,
    Repeated[DigitCharacter, {1, 3}] ~~ "." ~~
     Repeated[DigitCharacter, {1, 3}] ~~ "." ~~
     Repeated[DigitCharacter, {1, 3}] ~~ "." ~~
     Repeated[DigitCharacter, {1, 3}]] &);



(* ::Subsubsection::Closed:: *)
(*UUIDP*)


(* Typically, UUIDs look like: 89047381-9f12-484d-97aa-35859bcd0fe7 *)
(* Here, we allow any combination of 1 or more substrings like "abcdef123-" with optional "-" to be a UUID *)
UUIDP=_String?(StringMatchQ[#1,
    Repeated[HexadecimalCharacter..~~Repeated["-",{0,1}]]] &);



(* ::Subsubsection::Closed:: *)
(*PhoneNumberP*)


PhoneNumberP=_String?(StringMatchQ[#,

	(*US format*)
	(DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"")|

	(*International 8 digit format*)
	("+" ~~ DigitCharacter .. ~~ "-"~~DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"")|

	(*International 9 digit format*)
	("+" ~~ DigitCharacter .. ~~ "-"~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~"")|

	(*International 10 digit format*)
	("+" ~~ DigitCharacter .. ~~ "-"~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"")|

	(*International 11 digit format*)
	("+" ~~ DigitCharacter .. ~~ "-"~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"-"~~ DigitCharacter~~DigitCharacter~~DigitCharacter~~DigitCharacter~~"")|

	(" x"~~DigitCharacter__)
]&);



(* ::Subsubsection::Closed:: *)
(*EmailP*)


EmailP::usage="
	DEFINITIONS: Matches the pattern of an email address
";

EmailP= (_String?(
	StringMatchQ[
		#,
		((LetterCharacter|DigitCharacter|"."|"-"|"_"|"+"|"&")..)~~"\\@"~~(((LetterCharacter|DigitCharacter)..) ~~ ".").. ~~ ((LetterCharacter|DigitCharacter)..)]&
	)
);



(* ::Subsubsection::Closed:: *)
(*EmailTemplateNameP*)


EmailTemplateNameP = Alternatives[
	"admin-added",
	"admin-removed",
	"ecl-invite",
	"ecl-welcome",
	"general-message",
	"materials-required",
	"model-approved",
	"notebook-added",
	"notebook-removed",
	"order-backordered",
	"order-canceled",
	"order-placed",
	"order-received",
	"order-partially-received",
	"product-approved",
	"protocol-aborted",
	"protocol-added-to-cart",
	"protocol-canceled",
	"protocol-completed",
	"protocol-enqueued",
	"protocol-processing",
	"protocol-awaiting-materials",
	"protocol-awaiting-backordered-materials",
	"samples-returned",
	"samples-shipped",
	"samples-received",
	"software-new-features",
	"software-update",
	"software-new-features-url",
	"software-update-url",
	"team-member-added",
	"team-member-removed",
	"troubleshooting-reported",
	"troubleshooting-report-reopened",
	"troubleshooting-report-resolved",
	"troubleshooting-report-updated",
	"script-exception",
	"script-completed"
];



(* ::Subsubsection::Closed:: *)
(*DateListP*)


DateListP::usage="
	DEFINITIONS
		{_Integer,_Integer,_Integer,_Integer,_Integer,_Real}
			Matches the pattern of a DateList[]
";

DateListP={_Integer,_Integer,_Integer,_Integer,_Integer,_?NumericQ};



(* ::Subsubsection::Closed:: *)
(*BooleanP*)


BooleanP::usage="
DEFINITIONS
	(True|False)
		Matches a boolean.
";

BooleanP=Alternatives@@{True,False};



(* ::Subsubsection::Closed:: *)
(*DomainP*)


DomainP[patt_]:=
	PatternTest[
		{patt,patt},
		Function[{minmax},
			LessEqual@@minmax
		]
	];


(* ::Subsubsection::Closed:: *)
(*ThermodynamicCycleP*)


ThermodynamicCycleP = {Heating,Cooling} | {Cooling,Heating};



(* ::Subsubsection::Closed:: *)
(*OptionDefinitionP*)


OptionDefinitionP = {
	(* OptionName -> default *)
	_Rule,
	(* Pattern *)
	_,
	(* Description *)
	Alternatives[
		{(_String..)},_String
	],
	(* Can add category or map thread *)
	___Symbol
};



(* ::Subsubsection::Closed:: *)
(*FieldCategoryP*)


FieldCategoryP=Alternatives[
	"Analysis & Reports",
	"Qualifications & Maintenance",
	"Experiments & Simulations",
	"General",
	"Preparatory Incubation",
	"Preparatory Filtering",
	"Preparatory Centrifugation",
	"Preparatory Dilution",

	"Experimental Results",
	"Simulation Results",
	"Method Saving",

	(*Design of Experiments*)
	"Optimization",
	"GridOptimization",
	"Results",

	"General",
	"Container Information",
	"Cover Information",
	"Method Information",
	"Model Information",
	"Usage Information",
	"Optical Information", (* laser, light, optics modules, lamp, microscope, objectives  *)
	"Organizational Information",
	"Personal Information",
	"Sensor Information",
	"Training Information",
	"Statistical Information",
	"Storage Information", (* Storage Category etc *)
	"Storage & Handling",
	"Plumbing Information",
	"Wiring Information",
	"Operations Information",
	"Temperature Compensation",
	"Preparatory Incubation",
	"Preparatory Filtering",
	"Preparatory Centrifugation",
	"Flush System",
	"Prime System",

	"Container Specifications",
	"Imaging Specifications",
	"Instrument Specifications",
	"Imaging Specifications",
	"Item Specifications",
	"Part Specifications",
	"Product Specifications",
	"Sensor Information",
	"Sensor Monitoring",
	"Queue Information",
	"Backlog Information",

	"VisibleLightImaging Specifications",
	"UVImaging Specifications",
	"CrossPolarizedImaging Specifications",

	(* History *)
	"Container History",
	"Item History",
	"Sample History",
	"Environmental Data",

	(* Sample Prep *)
	"Sample Preparation",
	"Preparatory Centrifugation",
	"Preparatory Filtering",
	"Aliquoting",
	"Sample Post-Processing",
	"Analytes",

	"Batching",
	"Pooling",

	"Reagents",
	"Formula",
	"Fill to Volume",
	"Inventory",
	"Health & Safety",
	"Dimensions & Positions", (* Container/Instrument/ModelInstrument *)
	"Physical Properties", (* Container/Sample: pH, weight, color, material, treatment *)
	"References",
	"Resources",
	"Option Handling",
	"Replicate Experiments",
	"Operating Limits",
	"Compatibility",
	"Troubleshooting",
	"Protocol Support",
	"pH Titration",
	"Pre-Tritrated Additions",
	"pHing Limits",
	"Operating Limits", (* Container/Instrument/ModelInstrument/Sample: To describe max/min fields, allowable types*)
	"Data Processing", (* Data: To describe post results processing, not done with a specific analysis, e.g. blanking*)
	"Autoclaving",
	"Temperature Compensation",
	"InjectionOrder",
	"Reagent Addition",
	"Compensation",
	"Stopping Conditions",
	"Trigger",
	"Priming",
	"Flushing",
	"Container Covering",
	"Phase Mixing",
	"Collection",
	"Settling",
	"Grinding",
	"Desiccation",
	"Packing",
	"Precipitation",

	(* For Object[Report,Inventory] and Object[Transaction] *)
	"Order Activity",
	"Pricing Information",
	"Shipping Information",
	"Document Feeder",

	(* for permissions system *)
	"Team Information",
	"Company Information",

	ProtocolCategoryP,

	(* Odd cases*)
	"Equilibration",
	"Evaporation",
	"Incubation",
	"Mixing",
	"Integrations",
	"Literature Information",
	"Migration Support",
	"Robotic Liquid Handling",
	"Acceptance Criteria",
	"Calibration",
	"Degas",
	"Standard Curve Statistics",
	"NMR Peak Splitting",
	"Isotope Properties",
	"Particle Size Measurements", (* For ExperimentCountLiquidParticles *)
	"Capillary Conditioning",
	"Capillary Flush",
	"Capillary Equilibration",
	"Pre-Marker Rinse",
	"Marker Injection",
	"Pre-Sample Rinse",
	"Sample Injection",
	"Separation",

	(* for Notifications *)
	"Notifications",
	"Notification Information",

	(* Object[Journal]*)
	"Journal Information",

	"Supernatant Aspiration",

	"Versioning",

	(* Object[Package]*)
	"Receiving Information",
	"Sender Information",

	(* Biology *)
	"Thawing",
	"Washing",
	"Media Addition and Plating",
	"Pelleting",
	"Freezing",
	"Dissociation Inactivation",
	"Cell Scraping",
	"Dissociation",
	"Predissociation Wash",
	"Splitting",
	"Coating Wash",
	"Stain Preparation",
	"Staining",
	"Stain Washing",
	"Mordant Preparation",
	"Mordanting",
	"Mordant Washing",
	"Decolorizer Preparation",
	"Decolorizing",
	"Decolorizer Washing",
	"CounterStain Preparation",
	"CounterStaining",
	"CounterStain Washing",
	"Plate Pouring",
	"Media Preparation",
	"Lysis Solution Addition",
	"Growth Information",
	"Growth Media",
	"Lysis Solution Addition",
	"Cell Lysis",
	"Neutralization",
	"Purification",
	"Liquid-liquid Extraction",
	"Solid Phase Extraction",
	"Precipitation",
	"Magnetic Bead Separation",
	"Lysate Homogenization",
	"Dehydration",
	"Cell Removal",
	"Media Clarification",
	"Media Homogenization",
	"Cell Wall Digestion",
	"Media Mix",
	"Stab",
	"Incubation Condition",
	"Fractionation",

	(* QPIX *)
	"Picking",
	"Placing",
	"Spreading",
	"Streaking",
	"Sanitization",
	"Selection",
	"Deposit",
	"Aspirate",

	(* Transfer *)
	"Temperature Equilibration",
	"Pipetting Parameters",
	"Resuspension Mix",
	"Intermediate Decanting",
	"Container Covering",
	"Tip Rinsing",
	"Hermetic Transfers",
	"Quantitative Transfers",
	"Transfer Technique",

	(* Manifold *)
	"Task Definition",
	"Computation Conditions",
	"Computations",
	"Manifold Tracking",
	"Status",

	(* User Quals *)
	"Pipetting Skills",
	"Graduated Cylinder Skills",
	"Weighing Skills",
	"Imaging Skills",
	"Filtering Skills",
	"Placement Skills",
	"Transferring Skills",
	"Volume Checking Skills",
	"Instruction Reading Skills",
	"Interactive Training",
	"Question Information",
	"Answer Information",
	"Quiz Information",
	"Interactive Training Information",
	"Decanting Skills",
	"Hermetic Sealed Transfer Skills",
	"StrayDroplets Skills",
	"DeckPlacement Skills",
	"Stickering Skills",
	"Storage Skills",
	"Object Identifier Skills",
	"Volumetric Flask Skills",
	"Ampoule Skills",
	"Transfer Tubes Skills",
	"Fumehood Transfer Skills",
	"Tablet Crushing Skills",
	"Sample States Skills",

	(* Quizzing *)
	"Question Information",
	"Answer Information",

	(* Cell Count categories *)
	"Input Image",
	"Output Image",
	"Image Properties",
	"Counting Properties",
	"Morphological Properties",
	"Component Properties",
	"Image Acquisition",
	"Time Lapse Imaging",
	"Z-Stack Imaging",
	"Fluorescence Imaging",
	"BrightField and PhaseContrast Imaging",

	(* ImageCells *)
	"Image Acquisition",
	"Time Lapse Imaging",
	"Z-Stack Imaging",
	"Fluorescence Imaging",
	"BrightField and PhaseContrast Imaging",
	"Environmental Controls",
	"Sampling",
	"Sampling Regions",
	"Adaptive Sampling",

	(* WashCells/ChangeMedia *)
	"Media Aspiration",
	"Media Replenishment",

	(* 3rd Party Data Integrations *)
	"Data Integrations",

	"Test Results",

	(* Qualifications and Maintenances *)
	"Qualification Parameters",
	"Passing Criteria"
];



(* ::Subsubsection::Closed:: *)
(*ProtocolCategoryP*)


ProtocolCategoryP::usage="DEFINITIONS: Pattern that matches any of the possible protocol field categories.";
ProtocolCategoryP=Alternatives[

	"Reagents",
	"Instrument Processing",
	"Instrument Setup",
	"Mixing",
	"Incubation and Mixing",
	"Placements",
	"Workup",
	"Sample Storage",
	"Density Measurement",
	"Pooling",
	"System Suitability Check",

	(* -------------------------------------*)
	(* -------------- CHEMISTRY --------------*)
	(* -------------------------------------*)

	(* Solid Phase Synthesis Cats: PNASynthesis, DNASynthesis, RNASynthesis, Download, Cleavage *)
	"Swelling",
	"Deprotection",
	"Deprotonation",
	"Activation",
	"Coupling",
	"Capping",
	"Cleavage",
	"Washing",
	"Kaiser Tests",
	"Resin Swelling",
	"Resin Loading",
	"Trituration",
	"Resin Storage",
	"Resuspension",
	"Resin Storage",
	"Downloading",
	"Monomer Activation",
	"Monomer Recovery",
	"Oxidation",
	"Synthesis",
	"Reaction Monitoring",
	"RNA Deprotection",
	"Post Cleavage Desalting",
	"Post RNA Deprotection Desalting",

	(*Absorbance Spectroscopy*)
	(*Absorbance Quantification*)
	"Buffer Preparation",
	"Absorbance Measurement",

	(*Absorbance Thermodynamics*)
	"Cuvette Preparation",
	"Blanking",
	(*Fluorescence Thermodynamics*)
	"Thermocycling",

	(*MeasureDensity*)
	"DensityMeter Measurement",
	"FixedVolumeWeight Measurement",

	(*AlphaScreen*)
	"Optics Optimization",
	"Sample Handling",

	(*CircularDichroism*)
	"CircularDichroism Measurement",
	"Enantiomeric Excess Measurement",
	"Enantiomeric Excess Analysis",

	(*Desiccate*)
	"Desiccant",
	"Drying",

	(*Fluorescence Kinetics/ Fluorescence Intensity *)
	"Injection",
	"Injection Preparation",
	"Injector Cleaning",
	"Optics",

	(* Luminescence Intensity/Kinetics/Spectroscopy *)
	"Luminescence Measurement",
	"Injections",

	(* Mass Spectrometry *)
	"Mass Analysis",
	"Ionization",
	"Plate Cleaning",


	(* Raman Spectroscopy *)
	"Scattering Measurement",

	(* SolidPhaseExtraction *)
	"PreFlush",
	"Equilibration",
	"Loading",
	"Elution",
	"PreFlush",

	(* PAGE *)
	"Running the Gel",
	"Staining & Imaging",

	(* AgaroseGelElectrophoresis *)
	"Loading",
	"Separation",

	(* HPLC *)
	"System Prime",
	"Column Installation",
	"Column Prime",
	"Gradient",
	"Fraction Collection",
	"Standards",
	"Column Flush",
	"Purging",

	(* Vacuum Evaporation *)
	(*"Equilibration", already mentioned in SolidPhaseExtraction *)
	"Evaporation",

	(* Measure Weight *)
	"Tare",
	"Transfer",
	"Weighing",

	(* Microwave Digestion *)
	"Digestion",

	(* Centrifuge *)
	"Centrifuge Balancing",
	"Centrifuge Setup",
	"Centrifugation",

	(* Cyclic Voltammetry *)
	"Electrode Polishing",
	"Electrode Cleaning",
	"Solution Preparation",
	"Electrolyte Solution Preparation",
	"Reference Solution Preparation",
	"Reference Electrode Preparation",
	"Electrode Pretreatment",
	"Sparging",
	"Stirring",
	"Electrochemical Synthesis",
	"Cyclic Voltammetry",
	"Post Measurement Internal Standard Addition",

	(* MeasurepH*)
	"pH Measurement",

	(* Measure Conductivity *)
	"Calibration",
	"Preparation",
	"Measurement",

	(* Dynamic Light Scattering *)
	"Sample Dilution",
	"Isothermal Stability",
	"Sample Recovery",
	"Light Scattering",
	"Colloidal Stability",

	(* -------------------------------------*)
	(* -------------- BIOLOGY  --------------*)
	(* -------------------------------------*)

	(*Mitochondrial Integrity Assay*)
	"Trypsinization",
	"Filtration",
	"Mitochondrial Staining",

	(* TotalProteinQuantification *)
	"Quantification",
	"Reagent Preparation",
	"Assay Plate Preparation",

	(* Western *)
	"Denaturation",
	"Blocking",
	"Matrix Removal",
	"Incubation",
	"Seperation",
	"Detection",
	"Lysate Filtration",

	(* CapillaryELISA *)
	"Capture Antibody Preparation",
	"Detection Antibody Preparation",
	"Standard Capture Antibody Preparation",
	"Standard Detection Antibody Preparation",
	"Standard Preparation",
	"Cartridge Loading",

	(* CoulterCount *)
	"Electrical Resistance Measurement",

	(* ELISA *)
	"Sample Assembly",
	"Antibody Preparation",
	"Antibody Antigen Preparation",
	"Coating",
	"Sample Antibody Complex Incubation",
	"Immunosorbent Assay",
	"Detection", "Immunosorbent Step", "Standard",
	"Blank", "Assay Plate",

	(*Microscope*)
	"Imaging",
	"AutoFocus",
	"Exposure",
	"Scan Area",

	(* CalibrateVolume, CalibratePathLength *)
	"Path Length Measurement",

	(* dPCR categories*)
	"Reference Amplification",
	"Polymerase Degradation",
	"Plate Seal",

	(* qPCR data categories *)
	"Cycle Parameters",
	"Melting Curve",
	"Copy Number",
	"Quantification Cycle",
	"Endogenous Control",
	"Cycle Parameters",
	"Dye Assay",
	"Probe Assay",
	"Passive Control",
	"Target Amplification",
	"Reverse Transcription",
	"Polymerase Activation",
	"Denaturation",
	"Annealing",
	"Extension",
	"Standard Curve",
	"Sample Loading",

	(* Extraction, Harvest, cDNA and Protein Prep categories *)
	"Cell Washing",
	"Cell Lysis",
	"Reverse Transcription",
	"Liquid-liquid Extraction",
	"Precipitation",
	"Solid Phase Extraction",
	"Magnetic Bead Separation",
	"Media Clarification",
	"Cell Removal",
	"Purification",

	(* Transfection categories *)
	"Transfection",
	"Calibration Parameters",

	(* Cell Bleaching *)
	"Cell Bleaching",

	(* Fluorescence Intensity *)
	"Fluorescence Measurement",

	(* Autoclave *)
	"Autoclave Setup",
	"Sterilizing",

	(* PCR categories *)
	"Primer Annealing",
	"Primer Gradient Annealing",
	"Strand Extension",
	"Cycling",
	"Final Extension",
	"Infinite Hold",

	(* COVID19Test categories *)
	"RNA Extraction",
	"RT-qPCR",

	(* MagneticBeadSeparation categories*)
	"Pre-Wash",
	"Wash",

	(* CapillaryGelElectrophoresisSDS categories *)
	"Standards",
	"Blanks",
	"Ladders",
	"Separation",
	"Cartridge Cleanup",

	(* Transform/Transfect/Transduce/MakeCompetent/Electroporate *)
	"Heat Shock",
	"Recovery",
	"Transfection Enhancer",
	"Transfection Reagent",
	"Complexation",
	"Chemical Transfection",
	"Cargo",
	"Electroporation",

	(* -----------------------------------------*)
	(* -------------- Maintenance --------------*)
	(* -----------------------------------------*)

	(* Clean *)
	"Cleaning",
	(* Dishwash *)
	"Dishwasher Setup",
	"Loading",
	"Unloading",

	(* Handwash *)
	"Cleaning Setup",
	"Cleaning",

	(* MeasureVolume *)
	"Centrifugation",
	"Volume Measurement",

	(* RefillReservoir *)
	"Refilling",

	(* Decontaminate *)
	"Incubator Setup",
	"Incubator Takedown",
	"Decontaminating",
	"Draining",

	(* Parameterize Container *)
	"Parameterization Measurements",

	(* -------------------------------------*)
	(* -------------- Qualification --------------*)
	(* -------------------------------------*)

	(* EngineBenchmark *)
	"Scanning Tests",
	"PDU Tests",
	"Sensor Tests",
	"DangerZone Tests",
	"Storage Tests",
	"Movement Tests",
	"Subprotocol Tests",
	"Looping Tests",
	"User Input Tests",
	"Aliquot Tests",

	(* Qualification HPLC/FPLC *)
	"Absorbance Accuracy Test",
	"Autosampler Test",
	"Detector Linearity Test",
	"Flow Linearity Test",
	"Fraction Collection Test",
	"Gradient Proportioning Test",
	"Stray Light Test",
	"Wavelength Accuracy Test",
	"Flow Injection Test",

	(*Qualification SFC MS*)
	"Mass Accuracy Test",

	(*Qualification IonChromatography *)
	"Eluent Generator Cartridge Test",
	"Suppressor Voltage Test",

	(* Qualification NMR *)
	"Sensitivity Test",
	"Lineshape Test",
	"Solvent Suppression Test",

	(* Western and TotalProteinDetection *)
	"Matrix & Sample Loading",
	"Separation & Immobilization",
	"Total Protein Labeling",
	"Antibody Labeling",

	(* Fluorescence Polarization *)
	"Polarization Test",

	(* AlphaScreen *)
	"AlphaScreen Test",

	(* Bioconjugation*)
	"PreWash",
	"Conjugation",
	"Quenching",
	"Post-Conjugation Workup",

	(* Qualification ELISA*)
	"Plate Washer Test",
	"Liquid Transfer Test",
	"Shaker Incubator Test",

	(* Circular Dichroism *)
	"Circular Dichroism Qualification",

	(* Nephelometry *)
	"Nephelometer Qualification"

];



(* ::Subsection::Closed:: *)
(*Widgets*)


TextBoxSizeP=Word|Line|Paragraph;
OrientationP=Vertical|Horizontal;


(* ::Subsection::Closed:: *)
(*Unit coordinate comparisons*)


DateCoordinatesComparisonP::InvalidComparisonPattern="Comparison criteria must be an unevaluated comparison expression.";

SetAttributes[DateCoordinatesComparisonP,HoldFirst];
DateCoordinatesComparisonP[yComp_]:=
	_?(DateCoordinatesComparisonQ[#,yComp]&);

(* needs HoldRest to parse the comparison pattern *)
SetAttributes[DateCoordinatesComparisonQ,HoldRest];

(* given coordinates with date and unit, put in QA *)
DateCoordinatesComparisonQ[coords:{{_DateObject,_Quantity}..},yComp_]:=
	DateCoordinatesComparisonQ[QuantityArray[coords],yComp];

(* given QA, compare x & y separately *)
DateCoordinatesComparisonQ[qa:QuantityArrayP[],yComp_]:=Module[
	{yC,yUnit,xRaw,yRaw},
	(* parse unit and comparison function from comparison pattern *)
	{yC,yUnit} = parseQuantityComparison[yComp];
	(* exit if pattern parsing failed *)
	If[MatchQ[yC,$Failed],Return[$Failed]];
	(* convert to comparison unit and separate x & y *)
	{xRaw,yRaw} = Quiet[Transpose[Unitless[qa,{1,yUnit}]],Quantity::compat];
	(* compare x & y *)
	And[
		AllTrue[xRaw,DateObjectQ],
		AllTrue[yRaw,yC]
	]
];

(* given coordinates with date and number, compare x & y separately *)
DateCoordinatesComparisonQ[coords:{{_DateObject,_?NumericQ}..},yComp_]:=Module[
	{yC,yUnit,xRaw,yRaw},
(* parse unit and comparison function from comparison pattern *)
	{yC,yUnit} = parseQuantityComparison[yComp];
	(* convert to comparison unit and separate x & y *)
	{xRaw,yRaw} = Transpose[coords];
	(* exit if comparison pattern unit is a unit *)
	If[!MatchQ[yUnit,"DimensionlessUnit"],Return[False]];
	(* compare x & y *)
	And[
		AllTrue[xRaw,DateObjectQ],
		AllTrue[yRaw,yC]
	]
];

SetAttributes[parseQuantityComparison,HoldFirst];
parseQuantityComparison[(f:(GreaterP|GreaterEqualP|LessP|LessEqualP))[q_]]:=With[
	{qm=QuantityMagnitude[q],qu=QuantityUnit[q]},
	{MatchQ[#,f[qm]]&,qu}
];
parseQuantityComparison[(f:(GreaterP|GreaterEqualP|LessP|LessEqualP))[q_,inc_]]:=With[
	{qm=QuantityMagnitude[q],qu=QuantityUnit[q],incn=Unitless[inc,QuantityUnit[q]]},
	{MatchQ[#,f[qm,incn]]&,qu}
];
parseQuantityComparison[(f:RangeP)[q1_,q2_]]:=With[
	{q1m=QuantityMagnitude[q1],q1u=QuantityUnit[q1],q2m=Unitless[q2,QuantityUnit[q1]]},
	{MatchQ[#,f[q1m,q2m]]&,q1u}
];
parseQuantityComparison[(f:RangeP)[q1_,q2_,dq_]]:=With[
	{q1m=QuantityMagnitude[q1],q1u=QuantityUnit[q1],q2m=Unitless[q2,QuantityUnit[q1]],dqm=Unitless[dq,QuantityUnit[q1]]},
	{MatchQ[#,f[q1m,q2m,dq]]&,q1u}
];

parseQuantityComparison[_]:= (
	Message[DateCoordinatesComparisonP::InvalidComparisonPattern];
	{$Failed,$Failed}
);


(* ::Subsection:: *)
(*Journals*)


(* ::Subsubsection::Closed:: *)
(*JournalSubjectAreaP*)


Unprotect[JournalSubjectAreaP];
JournalSubjectAreaP=Alternatives[Multidiscipline,Biochemistry,Bioinformatics,Biology,Biophysics,Biotechnology,Cancer,CellBiology,Chemistry,
	ClinicalMedicine,Computing, Dentistry,Development,DrugDiscovery,Earth,Environment,EvolutionAndEcology,Engineering,Genetics,
	Genomics,Immunology,Materials,Methods,Protocols,Physics,Medicine,MolecularBiology,MolecularCellBiology,Nanoscience,Nanotechnology,Neuroscience,
	Oncology,Pharmacology,PhysicalScience,Physics,Proteomics,SystemBiology
];
Protect[JournalSubjectAreaP];


(* ::Subsubsection::Closed:: *)
(*PublicationFrequencyP*)


Unprotect[PublicationFrequencyP];
PublicationFrequencyP=Alternatives[Weekly,Biweekly,Monthly,Quarterly,Annually];
Protect[PublicationFrequencyP];


(* ::Subsection:: *)
(*Pricing*)


(* ::Subsubsection::Closed:: *)
(*PricingCategoryP*)


PricingCategoryP=Alternatives[
	(* Acoustic Liquid Handling *)
	"Acoustic Liquid Handler",

	(* Autoclave *)
	"Autoclave",
	"Sterilization Indicator",

	(* Balances *)
	"Analytical Balance",
	"Lab Balance",
	"Microbalance",
	"Microcentrifuge",

	(*Distance gauges *)
	"Distance Gauge",

	(* Bio Layer Interferometry *)
	"Bio Layer Interferometer",

	(* Calorimetry *)
	"Capillary Dynamic Scanning Calorimeter (DSC)",

	(* Capillary ELISA *)
	"Capillary Enzyme-Linked Immunosorbent Assay (ELISA)",

	(* Capillary Isoelectric Focusing / Gel Electrophoresis SDS *)
	"cIEF System",

	(* Cell Maintenance *)
	"Cell Freezing Robotics",
	"Cell Thawing Robotics",
	"Colony Picker",
	"Cryostore",
	"Plate Pourer",

	(* Centrifuge *)
	"Centrifuge",
	"Integrated Centrifuge",
	"Integrated High Speed Centrifuge",

	(* Chromatography *)
	"Analytical UPLC (UV/Vis PDA)",
	"Fast Protein Liquid Chromatography (FPLC) Instrument",
	"HPLC",
	"Semi-Preparative HPLC",
	"Preparative HPLC",
	"Supercritical Fluid Chromatography",
	"Flash Chromatography System",
	"Gas Chromatography",
	"Ion Chromatography System",

	(* Distance Gauge *)
	"Distance Gauge",

	(* Crimping *)
	"Crimper",

	(* Degasser *)
	"Vacuum Degasser",
	"Sparging Apparatus",
	"Freeze-Pump-Thaw Apparatus",

	(* Density Meter *)
	"Density Meter",

	(* Desiccator *)
	"Desiccator",

	(* Dialyzer *)
	"Dialyzer",

	(* Dispenser *)
	"Dispenser",

	(* Dishwasher *)
	"Commercial Dishwasher",
	"Cuvette Washer",

	(* Dynamic Foam Analyzer *)
	"Foam Analyzer",
	"Foam Analyzer Filter Cleaner",

	(* Electroporator *)
	"Electroporator",

	(* Electrochemical Reactor *)
	"Electrochemical Reactor",

	(* Environmental Chamber *)
	"Environmental Chamber",

	(* Filtration *)
	"Filter Block",
	"Positive Pressure Processor",
	"Syringe Pump",
	"Cross-Flow Filtration",

	(* Flow Cytometry *)
	"Flow Cytometer (Counting)",

	(* FragmentAnalyzer*)
	"Fragment Analyzer",

	(* Fume Hoods *)
	"Fume Hood",
	"Vapor Trap",

	(* Gas Blowers *)
	"Blow Gun",

	(* Gas Generators *)
	"Gas Generation",

	(* Gas Flow Switch *)
	"Gas Flow Switch",

	(* GC-MS *)
	"GC-MS",

	(* Gel Electrophoresis *)
	"Gel Electrophoresis Robotics",

	(* Genetic Analyzer *)
	"Genetic Analyzer",

	(* Glove Box *)
	"Glove Box",

	(* High Content Imager *)
	"High Content Imager",

	(* Imaging *)
	"Darkroom",
	"Sample Imaging Robotics",
	"Sample Inspector",

	(* Incubator *)
	"Custom Condition Incubator",
	"Heat Block",
	"Incubator",
	"Integrated Incubator",
	"Liquid Nitrogen Dewar",

	(* Liquid Handler Robotics *)
	"Buffer Prep Robotics",
	"Post-Processing Robotics",
	"Robotic Liquid Handler",
	"Solid Phase Extraction Robotics",

	(* LC-MS *)
	"LC-MS",

	(*Liquid Liquid Extraction*)
	"Liquid Liquid Extraction",

	(* Mass Spectrometry *)
	"MALDI Mass Spectrometer",
	"ESI Mass Spectrometer",
	"ESI-QQQ MassSpectrometer",

	(* Microscope *)
	"Epifluorescence Microscope",
	"Inverted Microscope",
	"High Content Imager",

	(* Microwave *)
	"Microwave",

	(* Mixing *)
	"Bottle Roller",
	"Shaker",
	"Vortex",

	(* NMR *)
	"500Mhz NMR",

	(* Meters *)
	"Light Meter",
	"pH Meter",
	"Tachometer",
	"Conductivity Meter",
	"Dissolved Oxygen Meter",
	"Anemometer",

	(* Osmometers *)
	"Osmometer",

	(* PCR *)
	"PCR Thermocycler",
	"Real Time PCR Thermocycler",
	"ddPCR",
	"Plate Sealer",

	(* Pipetting *)
	"Aspirator",
	"Pipette",

	(* Plate Reader *)
	"Fluorescence Plate Reader (w/Injectors)",
	"Fluorescence Plate Reader (w/Pipetting)",
	"Fluorescence Plate Reader (w/Polarization)",
	"Plate Reader",
	"Nephelometer",

	(* Pumps *)
	"Peristaltic Pump",
	"Recirculating Pump",

	(* Purifiers *)
	"Water Purifier",

	(* Refractometer *)
	"Refractometer",

	(* Robot Arm *)
	"Robot Arm",

	(* Storage *)
	"Biosafety Cabinet",
	"Desiccator",
	"Dispenser",
	"Freezer",

	(* Portable instruments *)
	"Portable Heater",
	"Portable Cooler",

	(* Solid Dispensor *)
	"Solid Dispenser",

	(* Sonication *)
	"Sonicator",

	(* Synthesizers *)
	"DNA Synthesizer",
	"Organic Synthesis (milligram scale)",
	"Peptide Synthesizer",
	"Solid Phase Synthesis Robotics",

	(* Spectrophotemetry *)
	"Microfluidic UV/Vis Spectrometer",
	"UV/Vis Spectrophotometer (w/Melting)",
	"IR Spectrophotometer",
	"Raman Spectrophotometer",

	(*Surface Tension Measurement *)
	"Tensiometer",

	(* Vacuums and Evaporators *)
	"Needle Dryer",
	"Nitrogen Tube Blower",
	"Rotary Evaporator",
	"Speed Vac",
	"Vacuum Manifold",
	"Vacuum Pump",
	"Lyophilizer",

	(* Viscometer *)
	"Viscometer",

	(* Volume Measurement *)
	"Liquid Level Detector Robotics",
	"Liquid Level Detector",

	(* VLM - it's not charged but we need the PricingCategory for VOQ test *)
	"Vertical Lift",

	(* Western Blotting *)
	"Western Blotting Robotics",

	(* XRD *)
	"X-Ray Diffractometer",

	(* SLS and DLS *)
	"Multimode Spectrophotometer",

	(* Schlenk line: vacuum and gas dual manifold*)
	"Schlenk Line",

	(* Circular Dichroism PlateReader*)
	"Circular Dichroism",

	(* HIAC Liquid Particle Counter*)
	"Liquid Particle Counter"

];


(* ::Subsubsection::Closed:: *)
(*pHProbeTypeP*)


pHProbeTypeP = (Immersion | Surface);



(* ::Subsubsection::Closed:: *)
(*ConductivityProbeTypeP*)


ConductivityProbeTypeP = (Contacting | Inductive);


(* ::Subsubsection::Closed:: *)
(*TemperatureCorrectionP*)


TemperatureCorrectionP=Alternatives[Linear,NonLinear,None,PureWater,Off];



(* ::Subsubsection::Closed:: *)
(*ElectromagneticRangeP*)


ElectromagneticRangeP = (Visible | UV | Infrared);



(* ::Subsubsection::Closed:: *)
(*SpectrophotometerModuleP*)


SpectrophotometerModuleP=Alternatives[Reflection](*Transmission - not supported *);

(*ReportStyleP*)
ReportStyleP =Alternatives[
	Title,
	Subtitle,
	Subsubtitle,
	Chapter,
	Subchapter,
	Section,
	Subsection,
	Subsubsection,
	Subsubsubsection,
	Subsubsubsubsection,
	Text,
	SmallText,
	Code,
	Input,
	Output,
	Subtitle,
	Subsubtitle,
	Item,
	ItemParagraph,
	Subitem,
	SubitemParagraph,
	ItemNumbered,
	SubItemNumbered,
	InlineFormula,
	DisplayFormula,
	Program
];



(* ::Subsubsection::Closed:: *)
(*ColumnOrientationP*)


ColumnOrientationP=(Forward|Reverse);


(* ::Subsubsection::Closed:: *)
(*FluorescenceLabelingTargetTypeP*)


FluorescenceLabelingTargetTypeP=Alternatives[ssDNA, dsDNA, RNA, Protein];



(* ::Subsubsection::Closed:: *)
(*LaserPowerFilterP*)


LaserPowerFilterP = Alternatives[0*Percent, 13*Percent, 25*Percent, 32*Percent, 50*Percent, 100*Percent];



(* ::Subsubsection::Closed:: *)
(*SLSExcitationWavelengthP*)


SLSExcitationWavelengthP = Alternatives[266*Nano*Meter, 473*Nano*Meter];



(* ::Subsubsection::Closed:: *)
(*SpectrophotometerDetectorP*)


SpectrophotometerDetectorP = Alternatives[CCDArray, AvalanchePhotodiode];



(* ::Subsubsection::Closed:: *)
(*MeltCurveUnitP*)


MeltCurveUnitP = Alternatives[AbsorbanceUnit, RFU, None];



(* ::Subsubsection::Closed:: *)
(*ComputerComponentP*)


ComputerComponentP = Alternatives[
	ComputerCase,
	Processor,
	RAM,
	Motherboard,
	PowerSupply,
	GraphicsCard,
	SolidStateDrive,
	SolidStateBracket,
	PCICard,
	HardDiskDrive,
	OpticalDrive,
	CaseFan
];


(* ::Subsubsection::Closed:: *)
(*ComputerTypeP*)


ComputerTypeP = Alternatives[InstrumentComputer, WorkstationComputer, TabletComputer];


(* ::Subsubsection::Closed:: *)
(*LaserOptimizationResultP*)


LaserOptimizationResultP = Alternatives[Success,FailureLowSignal,FailureSaturatedSignal];


(* ::Subsubsection::Closed:: *)
(*CartridgeTypeP*)


CartridgeTypeP = Alternatives[
	Column,
	DNASequencing,
	ProteinCapillaryElectrophoresis,
	Osmolality
];


(* ::Subsubsection::Closed:: *)
(*SchlenkGasP*)


SchlenkGasP=Alternatives[Nitrogen, Helium, Argon];



(* ::Subsubsection::Closed:: *)
(*DegasGasP*)


DegasGasP=Alternatives[Nitrogen, Helium, Argon];



(* ::Subsubsection::Closed:: *)
(*DegasTypeP*)


DegasTypeP = Alternatives[FreezePumpThaw, Sparging, VacuumDegas];



(* ::Subsubsection::Closed:: *)
(*SchlenkGasP*)


SchlenkGasP=Alternatives[Nitrogen, Helium, Argon];



(* ::Subsubsection::Closed:: *)
(* CECartridgeTypeP *)


CECartridgeTypeP = Alternatives[cIEF,CESDS,CESDSPlus];


(* ::Subsubsection::Closed:: *)
(* CECoatingP *)


CECoatingP = Alternatives[None,Fluorocarbon];


(* ::Subsubsection::Closed:: *)
(* CEApplicationP *)


CEApplicationP = Alternatives[cIEF,CESDS,CESDSPlus];


(* ::Subsubsection::Closed:: *)
(* CEDetectionP *)


CEDetectionP = Alternatives[UVAbsorbance,NativeFluorescence];



(* ::Subsubsection::Closed:: *)
(*FavoriteStatusP*)


FavoriteStatusP = (Active | Inactive);



(* ::Subsubsection::Closed:: *)
(*NotebookScriptTypeP*)


NotebookScriptTypeP := (Null | ScriptTemplate | ScriptInstance);



(* ::Subsubsection::Closed:: *)
(* FoamAgitationTypeP *)


FoamAgitationTypeP = Alternatives[Stir,Sparge];



(* ::Subsubsection::Closed:: *)
(* FoamSpargeGasP *)


FoamSpargeGasP = Alternatives[Nitrogen,Air];



(* ::Subsubsection::Closed:: *)
(* FoamDetectionMethodP *)


FoamDetectionMethodP = Alternatives[HeightMethod,ImagingMethod,LiquidConductivityMethod];


(* ::Subsubsection::Closed:: *)
(*DynamicFoamAnalysisDataTypeP*)


DynamicFoamAnalysisPlotTypeP=Alternatives[FoamHeight,FoamVolume,BubbleCount,MeanBubbleArea,AverageBubbleRadius,LiquidContent];



(* ::Subsubsection::Closed:: *)
(* PlateImagerSoftwareP *)


PlateImagerSoftwareP=Alternatives["VisionM3","Vision M4 Advanced"];


(* ::Subsubsection::Closed:: *)
(* HemocytometerGridPatternP *)


HemocytometerGridPatternP=Alternatives[Neubauer,Burker,BurkerTurk,FuchsRosenthal,Malassez];


(* ::Subsubsection::Closed:: *)
(* SlideTreatmentP *)


SlideTreatmentP=Alternatives[Electrostatic,PolyLLysine,Silane,Gelatin];


(* ::Subsubsection::Closed:: *)
(* MicroscopeContainerOrientationP *)


MicroscopeContainerOrientationP=Alternatives[UpsideDown,RightSideUp];


(* ::Subsubsection::Closed:: *)
(* ImageCellsTimelapseAcquitionOrderP *)


ImageCellsTimelapseAcquitionOrderP=Alternatives[Parallel,Serial,RowByRow,ColumnByColumn];


(* ::Subsubsection::Closed:: *)
(* LumencorWavelengthNameP *)


LumencorWavelengthNameP=Alternatives[VIOLET,BLUE,CYAN,TEAL,GREEN,RED,NIR];


(* ::Subsubsection::Closed:: *)
(* InstrumentSoftwareP *)


InstrumentSoftwareP = Alternatives[AcqirisSoftware,
	ACQUITYConvergenceManager,
	ACQUITYUPC2BinarySolventManager,
	ADVANCE,
	AdvantagePro,
	AgilentCaryWinUVAnalysis,
	AgilentG1033ANIST2017LibraryNIST17L,
	AgilentLabAdvisor,
	AgilentLCControlSoftware,
	AgilentMassHunterGCMSDataAcquisition,
	AgilentMassHunterGCMSTranslator,
	AgilentMassHunterWorkstationAquisitionMethodOptimizationTools,
	AgilentMassHunterWorkstationQualitativeAnalysis100,
	AgilentMassHunterWorkstationQuantitativeAnalysis100,
	AgilentMassHunterWorkstationReportBuilder101,
	AgilentMSDChemstationClassicDataAnalysisG1701FA,
	AgilentOAL3SampleSoftwareControl21forGCMassHunter,
	AgilentOpenLABCDSChemStation35900AD,
	AgilentOpenLABCDSChemStationEdition,
	AgilentOpenLABCDSChemStationELSDDriver,
	AgilentOpenLABCDSChemStationGCDrivers,
	AgilentOpenLABCDSChemStationLCandCEDriver,
	AgilentOpenLABCDSChemStationMicroDriver,
	AgilentOpenLABCDSControlPanelChemStationPlugin,
	AgilentOpenLabCDSControlPanelHelp,
	AgilentOpenLabDataProviderforChemStatio,
	AgilentOpenLabDataRepository,
	AgilentOpenLabECMStoragePlugin,
	AgilentOpenLabPlatform,
	AgilentOpenLabServer,
	AgilentOpenLabSharedServices,
	AgilentOpenLabStorageClientServices,
	AgilentPartsFinder,
	AgilentSoftwareVerificationToolB0101,
	AgilentTechnologies597xGCMSMassHunterSoftwareDocumentation,
	AgilentTechnologiesGCandGCMSUsersManualsInstaller,
	AgilentTechnologiesGCFirmwareUpdateTool,
	AgilentTechnologiesGCMSSoftwareInformationandManuals,
	AgilentTechnologiessharedGCMSMassHunterSoftwareDocumentation,
	AliasServiceManager,
	ALPHA,
	Analyst,
	AndorDriverPack2,
	AndorDriverPack3,
	AntonPaarInstrumentViewer,
	AntonPaarLIMSBridge,
	Apogee32bitSoftware,
	ApogeeUsb64bitDriver,
	ApogeeUSB64BitDriver,
	Astra,
	ATC,
	ATCDemo,
	AutomationStudio,
	BiacoreT200ControlSoftware,
	BiacoreT200EvaluationSoftware,
	BinarySolventManager,
	BioMedEReaderVenusDriver,
	BioMicroLabVolumeCheck,
	BioNexBeeSureIntegratioFiles,
	BioNexHiGIntegrationFiles,
	BioRadZE5Firmware,
	BioRadZE5ServiceTool,
	BitFlowSDK,
	BMGInstaller,
	BMGLABTECHMARSDataAnalysis,
	BRiCareAgentApplet,
	BrukerCMCa,
	BrukerDaltonicsflexAnalysis,
	BrukerDaltronicsCompassXprot,
	BrukerDaltronicsflexControl,
	BrukerDaltronicsMALDIDetectorCheck,
	BrukerDiskless,
	BrukerFLEXlm,
	BrukerIconNMR,
	BrukerMICS,
	BrukerNMRGUIDE,
	BrukerNMRSim,
	BrukerTopSpin,
	CanonUtilitiesDigitalPhotoProfessional4,
	CanonUtilitiesEOSWebServiceRegistrationTool,
	CanonUtilitiesLensRegistrationTool,
	CaryUVWorkstation,
	CDMicroPlateReader,
	CDReader,
	CETACRackFileManager,
	Chromeleon,
	Chromeleon7,
	ChromeleonServer,
	CLARIOstar,
	CodeMeterRuntimeKit,
	ColumnManager,
	ColumnsCalculator,
	CompactConnect,
	Compass,
	CompassAuthorizationServer,
	CompassforiCE,
	CompassForiCE,
	CompassForSW,
	ComTestSerial,
	ConEmu,
	ConvergenceManager,
	CrysAlisPro,
	CrysAlisProStructureExplorer,
	CryoConnector,
	CyberComm2700,
	CytivaRemoteDeploymentService,
	CytivaSoftwareLicensingServer,
	CytivaVirtualControlUnit,
	DataAcquisition,
	DataAnalysis,
	Delta8Manager,
	Delta8SDK,
	Delta8YScreen,
	digiCamControl,
	DinoCapture20,
	DionexChromeleon,
	DionexIPUtility,
	DionexLicenseServer,
	DionexUserManagement,
	DO2700,
	DocITColonyCounter,
	DocITLSAcquisitionAnalysis,
	DSCControlSoftware,
	DYNAMICS,
	easyCodeII,
	EasyDirectpH,
	Echo650,
	ElectraSyn,
	Ella,
	ELSDetector,
	ELSDetector2424,
	EOSUtility,
	FlexControl,
	FLRDetector,
	FLRDetector2475,
	FlyCapture,
	FractionManagerAnalytica,
	GEHealthcareLSGateway,
	GEHealthcareRemoteDeploymentService,
	GEHealthcareSoftwareLicensingServer,
	GEHealthcareVirtualControlUnit,
	GeneForge3900,
	Geneforge3900DNASynthesizer,
	Genevac,
	GilsonGEARS,
	GilsonGX27XSeriesOffsetUtilitiy,
	GilsonServer,
	GilsonTRILUTIONLH30,
	GilsonTRILUTIONLH30ServicePack2,
	GilsonTRILUTIONLH30ServicePack3,
	GilsonTRILUTIONLH30Special2417,
	GilsonUSBDrivers64,
	GilsonVERITY4000SeriesSyringePumpGEARSPlugins,
	HamiltonAgilentCentrifugeVenusDriver,
	HamiltonASWGlobal,
	HamiltonBioNexHiGVenusDriver,
	HamiltonBioRadZE5VenusDriver,
	HamiltonBMGReaderVenusDriver,
	HamiltondaisychainedTiltModule,
	HamiltonDriverforBMGLabtechPHERAstar,
	HamiltonDriverforBMGLabtechPlateReader,
	HamiltonDriverforHamiltonHMotion,
	HamiltonDriverforHamiltonMultiDaisyChainedTiltModuleAmbient,
	HamiltonDriverforInhecoIncubator,
	HamiltonDriverforInhecoTECcontroller,
	HamiltonDriverforLiconicSTX,
	HamiltonDriverfortheInhecoMTECController,
	HamiltonDriverTools,
	HamiltoneasyPickII,
	HamiltonHeaterCoolerSiLADriver,
	HamiltonHeaterCoolerVenusDriver,
	HamiltonHSLExtension,
	HamiltonHSLJSONLibrary,
	HamiltonLonzaNucleofectorVenusDriver,
	HamiltonMDImageXpressVectorDriver,
	HamiltonMicrolabSTARSoftwareVENUS,
	HamiltonMicrolabSTARSoftwareVENUSfour,
	HamiltonMicrolabSTARSoftwareVENUSfourbasepackage,
	HamiltonMicrolabSTARSoftwareVENUSTADMFeature,
	HamiltonMicrolabSTARSoftwareVENUStwo,
	HamiltonMicrolabSTARSoftwareVENUStwoServicePack1,
	HamiltonMPE2HSLDriver,
	HamiltonMPEHSLDriver,
	HamiltonPlateSealerHSLDriver,
	HamiltonSerialInterface,
	HamiltonThermoATCVenusDriver,
	HamiltonTraceLevel,
	HamiltonWasherVenusDriver,
	HamiltonWasteChute,
	HEPAHoodFanController,
	HiGCentrifugeDriver,
	HighResolutionMeltSoftware,
	HSLLabwrAccess,
	HSLVolumeCheckLib,
	IDSuEye,
	ImageXpress,
	InhecoIncubatorShaker,
	Initium1Plus,
	IsocraticSolventManager,
	IXXATVCI,
	KRUSSADVANCE,
	LabcyteEchoClientUtility,
	LabcyteEchoPlateReformat,
	Labworldsoft6,
	LabX,
	LibraryStudio,
	LocalConsoleController,
	LunaticAnalysis,
	LunaticClient,
	ManageEngineDesktopCentralAgent,
	MassHunter,
	MassLynx,
	Maurice,
	MetaXpress,
	MetaXpressPowercoreClient,
	MetaXpressPowerCoreServer,
	MettlerToledoiCFBRM,
	MettlerToledoiCFBRMServer,
	METTLERTOLEDOiCIR,
	METTLERTOLEDOiControl,
	MettlerToledoiCVision,
	METTLERTOLEDOUSBSerialPortDriver,
	MicroCalVPCapillartyDSCSoftware20,
	MicroCalVPCapillartyDSCSoftware20DataAnalysis,
	MicrolabSTARService,
	MicromassLibraryBarcodeSupport,
	MosChipMultiIOController,
	MPE,
	MVS,
	MVSSDKRuntimex64,
	MVSSDKRuntimex86,
	NationalInstrumentsSoftware,
	NikonTiSetupTools,
	Nimbus8,
	Nimbus8TADMfeature,
	NimbusCORE96Software,
	NISElements97157HCATools,
	NISElementsLO,
	NucleofectorSwitch,
	OctetDataAcquisition,
	Omega,
	OndaxSAMSpectraAnalyzerandMapper,
	OndaxSpectraXplorer,
	OndaxWPS,
	OPUS,
	PCIetoPeripheralAdapter,
	PDADetector,
	PDADetector2998,
	PeakTrak,
	PharmSpec,
	PHERAstar,
	PuTTY,
	QtegraiCAPQiCAPRQ,
	Quadport,
	QuantStudio,
	QuaternarySolventManager,
	QuaternarySolventManagerR,
	QXOne,
	QXONESoftware110StandardEdition,
	RASClientforBenchtopSystems,
	ReaderControl,
	RheoSenseClariti,
	RIDetector,
	RIDetector2414,
	RockImager,
	RockMaker,
	SampleManager,
	SampleManagerFTN,
	SampleManagerFTNR,
	SCIEXOS,
	SeqScapeSoftware,
	SeqStudioGeneticAnalyzerPlateManagerSoftware,
	SeqStudioPlateManager,
	SequencingAnalysisSoftware,
	SetupFileDirectoryLib,
	SevenExcellence,
	ShuttleSoftware96well,
	SimplePlexExplorer,
	SimplePlexRunner,
	SizeSelection,
	SourceTree,
	SparkLink,
	SparkLinkAliasDriver,
	SPECTROstarNano,
	SSR,
	STXPanel,
	SXVirtualLink,
	SynergyD,
	SystemRequirementsLabforIntel,
	TeledyneCETACAutomation,
	ThermoChromeleon,
	TopSpin,
	Trilution,
	TUVDetector,
	UncleAnalysis,
	UncleClient,
	Unicorn,
	UNICORN,
	UNICORNCommonComponents,
	UNICORNDatabase,
	UNICORNServiceTool,
	UPC2BinarySolventManager,
	UVVisDetector2489,
	VaproLabReport,
	VENUS,
	VIAFreeze,
	VISASharedComponente,
	VisionM3,
	VisionM4,
	VisualNTRlibrary,
	VolumeCheck,
	VspinwithAccess2,
	VWorksActiveXControls,
	Waters2487Software,
	Waters2488Software,
	Waters25X5QuaternaryGradientModule,
	Waters2796Software,
	WatersA7890Software,
	WatersChromaLynx,
	WatersDiversityBrowser,
	WatersEmpowereSATINSoftware,
	WatersFractionLynx,
	WatersMassLynx,
	WatersOALogin,
	WatersOAToolkit,
	WatersProfileLynx,
	WatersPumpControlSoftware,
	WatersQuanLynx,
	WatersTargetLynx,
	WindowsDriverPackageAndorTechnologyAndorTechnology,
	WindowsDriverPackageAndorTechnologyUSBDevices,
	WindowsDriverPackageAndorTechnologywin32Devices,
	WindowsDriverPackageApogeeImagingSystemsInc,
	WindowsDriverPackageDeVaSysDeVaSysUSBI2CIODriversandDlls,
	WindowsDriverPackageDionexCorporationCmUsb64DionexDevices,
	WindowsDriverPackageFTDICDMDriverPackage,
	WindowsDriverPackageFTDICDMDriverPackageBusD2XXDriver,
	WindowsDriverPackageFTDICDMDriverPackageVCPDriver,
	WindowsDriverPackageHamiltonBonaduzAGHeaterShakerusbHamiltonUSBDevices,
	WindowsDriverPackageMettlerToledoAutoChemHIDClass,
	WindowsDriverPackageMettlerToledoHIDClass,
	WindowsDriverPackageNikonCorporationMicusbImage,
	WindowsDriverPackageSYSTECelectronicGmbH,
	WindowsDriverPackageThermoFisherScientificIncthermousbx64Ports,
	WyattTechnologyASTRA,
	xPonent42forMagpix,
	ZaberConsole,
	ZurichInstrumentsLabOne
];


(* ::Subsubsection::Closed:: *)
(*UserQualificationFrequencyP*)


UserQualificationFrequencyP = Alternatives[Quarterly,SemiAnnual];


(* ::Subsubsection::Closed:: *)
(*UserQualificationModulesP*)


UserQualificationModulesP = Alternatives[Pipetting,Weighing,InteractiveTraining,Decanting,Condenser,PlateSealing,GraduatedCylinder,StickyRack,
	HermeticSealedTransfer,StrayDroplets,RacksAndBins,DeckPlacementQual,EngineTimeOutQual,DangerZoneUserQual,CountTipsQual,CoverUncoverQual,AspiratorUsageQual,AmpouleQual,FunnelQual,ResourceQual,
	TransferTubes,VolumetricFlasks,Stickering,Storage,ObjectIdentifier,Discarding,FumehoodTransfer,Scanning,TabletCrushing,FirstAid,GeneralSafety,GeneralLabSafety,ExposureSafety,
	WasteHandling,SafeStorage,BioSafety,InstrumentSafety,LabLayout,Carts,Scanner,KVMSwitchQual,SampleStates,TabletHandling
];


(* ::Subsubsection::Closed:: *)
(* CircuitBreakerTypeP *)


CircuitBreakerTypeP=Alternatives[OnePoleCircuitBreaker, TwoPoleCircuitBreaker, ThreePoleCircuitBreaker, FourPoleCircuitBreaker];


(* ::Subsubsection::Closed:: *)
(* CellPreparationMethodP *)


CellPreparationMethodP=Alternatives[RoboticCellPreparation,ManualCellPreparation];


(* ::Subsubsection::Closed:: *)
(* SystemsProtocolObjectTypes *)


SystemsProtocolObjectTypes=Alternatives[Object[Qualification],Object[Maintenance]];


(* ::Subsubsection::Closed:: *)
(* SystemsProtocolModelTypes *)


SystemsProtocolModelTypes=Alternatives[Model[Qualification],Model[Maintenance]];


(* ::Subsubsection::Closed:: *)
(* QualificationTargetObjectTypes *)


QualificationTargetObjectTypes=Alternatives[Object[Instrument],Object[Container],Object[Sample],Object[Sensor],Object[Part],Object[User],Object[Item]];


(* ::Subsubsection::Closed:: *)
(* QualificationTargetModelTypes *)


QualificationTargetModelTypes=Alternatives[Model[Instrument],Model[Container],Model[Sample],Model[Sensor],Model[Part],Model[User],Model[Item]];


(* ::Subsubsection::Closed:: *)
(* MaintenanceTargetObjectTypes *)


MaintenanceTargetObjectTypes=Alternatives[Object[Instrument],Object[Container],Object[Sample],Object[Sensor],Object[Part],Object[Item],Object[User]];


(* ::Subsubsection::Closed:: *)
(* MaintenanceTargetModelTypes *)


MaintenanceTargetModelTypes=Alternatives[Model[Instrument],Model[Container],Model[Sample],Model[Sensor],Model[Part],Model[Item]];


(* ::Subsubsection::Closed:: *)
(* SystemsProtocolTargetObjectTypes *)


SystemsProtocolTargetObjectTypes=DeleteDuplicates[Flatten[Alternatives[QualificationTargetObjectTypes,MaintenanceTargetObjectTypes]]];


(* ::Subsubsection::Closed:: *)
(* HIACSyringeSizeP *)


HIACSyringeSizeP=Alternatives[1 Milliliter, 10 Milliliter];


(* ::Subsubsection::Closed:: *)
(* SystemsProtocolTargetModelTypes *)


SystemsProtocolTargetModelTypes=DeleteDuplicates[Flatten[Alternatives[QualificationTargetModelTypes,MaintenanceTargetModelTypes]]];


(* ::Subsubsection::Closed:: *)
(* ExtensionCategoryP *)


ExtensionCategoryP=Alternatives[
	UndergoingMaintenance,
	ResourceConstrained,
	SupplierNotificationOfChange,
	Other
];

QualificationExtensionCategoryP=Flatten[Alternatives[QualificationRevisionRequired,ExtensionCategoryP]];

MaintenanceExtensionCategoryP=Flatten[Alternatives[MaintenanceRevisionRequired,ExtensionCategoryP]];


(* ::Subsubsection::Closed:: *)
(* SupplierStatusP *)


SupplierStatusP:=Alternatives[Active,Blacklisted,OutOfBusiness,Transferred];



(* ::Subsubsection::Closed:: *)
(* SupplierRoleP *)


SupplierRoleP := Sales | Services | TechnicalSupport;



(* ::Subsubsection::Closed:: *)
(* DisputeStatusP *)


DisputeStatusP := Open | Closed;



(* ::Subsubsection::Closed:: *)
(* DisputeP *)


DisputeP := FinancialViolation | QualityAgreementViolation | ContractViolation | ShippingFailures;


(* ::Subsubsection::Closed:: *)
(* QuestionCategoriesP *)


QuestionTagsP=Alternatives["General","Operator Training","General Safety","Chemical Safety","Bio Safety","Physical and Instrumental Safety",
	"Weighing","Pippetting","Liquid Transfers","General Lab Skills","Engine Skills","Organizational Information","App/Software Usage","External Training",
	"Quality Operations"];


(* ::Subsubsection::Closed:: *)
(* QuestionResultP *)


QuestionResultP=Alternatives[Correct,Incorrect];


(* ::Subsubsection::Closed:: *)
(* RefractiveIndexReadingModeP *)

RefractiveIndexReadingModeP = Alternatives[FixedMeasurement,TemperatureScan,TimeScan];

(* ::Subsection:: *)
(*MagneticBeadSeparationSelectionStrategyP*)
MagneticBeadSeparationSelectionStrategyP=Alternatives[Positive,Negative];

(* ::Subsection:: *)
(* MagneticBeadSeparationProcessingOrderP *)
MagneticBeadSeparationProcessingOrderP=Alternatives[Parallel,Batch,Serial];

(* ::Subsubsection::Closed:: *)
(* PartStatusP *)

PartStatusP=(Stocked|Available|InUse|Discarded|Transit|Installed|PickedUp|Receiving|UndergoingMaintenance);

(* ::Subsubsection::Closed:: *)
(* ScannerTypeP *)

ScannerTypeP=Alternatives[FlatbedScanner,OverheadScanner,DocumentFeederScanner];

(* ::Subsubsection::Closed:: *)
(* OpticalSensorP *)

OpticalSensorP=Alternatives[ContactImageSensor];

(* ::Subsubsection::Closed:: *)
(* SensorColorTypeP *)

SensorColorTypeP=Alternatives[Color,Grayscale];

(* ::Subsubsection::Closed:: *)
(* storageRerackMoveP *)

(* three pieces of a storage move, 1) starting vessel 2) destination object or numbered rack, 3) string position of destination *)
StorageRerackMoveP = {
	ObjectP[Object[Container, Vessel]],
	Alternatives[
		ObjectP[Object[Container, Rack]],
		{_Integer, ObjectP[Model[Container, Rack]]}
	],
	_String
};

(* ::Subsubsection::Closed:: *)
(* ColonySelectionFeatureP *)

ColonySelectionFeatureP=Alternatives[Fluorescence,Absorbance,Diameter,Isolation,Regularity,Circularity,BrightField];

(* ::Subsubsection::Closed:: *)
(* QPixFluorescenceWavelengthsP *)

QPixFluorescenceWavelengthsP=Alternatives[{377 Nanometer,447 Nanometer},{457 Nanometer, 536 Nanometer},{531 Nanometer, 593 Nanometer},{531 Nanometer, 624 Nanometer},{628 Nanometer, 692 Nanometer}];

(* ::Subsubsection::Closed:: *)
(* QPixFluorescenceWavelengthsP *)

QPixAbsorbanceWavelengthsP=Alternatives[400 Nanometer];

(* ::Subsubsection::Closed:: *)
(* QPixImagingChannelsP *)

QPixImagingChannelsP = QPixFluorescenceWavelengthsP | QPixAbsorbanceWavelengthsP | BrightField;

(* ::Subsubsection::Closed:: *)
(* InoculationSourceP *)
InoculationSourceP=SolidMedia|LiquidMedia|AgarStab;

(* ::Subsubsection::Closed:: *)
(* InoculationSourceProtocolObjectP *)
InoculationSourceProtocolObjectP=LiquidMedia|AgarStab;

(* ::Subsubsection::Closed:: *)
(* InoculationMixTypeP *)
InoculationMixTypeP=Shake|Pipette|Swirl;

(* ::Subsubsection::Closed:: *)
(* ColonyHandlerHeadCassetteTypeP *)
ColonyHandlerHeadCassetteTypeP=Pick|Spread|Streak;

(* ::Subsubsection::Closed:: *)
(* DestinationFillDirectionP *)
DestinationFillDirectionP=Row|Column|CustomCoordinates;

(* ::Subsubsection::Closed:: *)
(* DestinationMediaTypeP *)
DestinationMediaTypeP=SolidMedia|LiquidMedia;

(* ::Subsubsection::Closed:: *)
(* DilutionTypeP *)
DilutionTypeP=SerialDilution|LinearDilution;

(* ::Subsubsection::Closed:: *)
(* SpreadPatternP *)
SpreadPatternP=Spiral | VerticalZigZag | HorizontalZigZag | Custom;


(* storageRerackMoveP *)

(* three pieces of a storage move, 1) starting vessel 2) destination object or numbered rack, 3) string position of destination *)
StorageRerackMoveP = {
	ObjectP[Object[Container, Vessel]],
	Alternatives[
		ObjectP[Object[Container, Rack]],
		{_Integer, ObjectP[Model[Container, Rack]]}
	],
	_String
};

(* ::Subsubsection::Closed:: *)
(* StreakPatternP *)
StreakPatternP=RotatedHatches | LinearHatches | Radiant | Custom;

(* ::Subsubsection::Closed:: *)
(* AmbiguousNestedResolutionP *)
AmbiguousNestedResolutionP = SingletonOptionPreferred | IndexMatchingOptionPreferred;

(* FirstAidKitClassP *)
FirstAidKitClassP=Alternatives[A,B];

(* ::Subsubsection::Closed:: *)
(* FirstAidKitTypeP *)

FirstAidKitTypeP=Alternatives[1,2,3,4];

(* ::Subsubsection::Closed:: *)
(* FireExtinguisherClassP *)

FireExtinguisherClassP=Alternatives[A,B,C,D,K];

(* ::Subsubsection::Closed:: *)
(* FireExtinguisherPurposeP *)

FireExtinguisherPurposeP=Alternatives["Ordinary Combustibles","Flammable Liquids","Electrical Equipment","Combustible Metal","Combustible Cooking Media"];

(* ::Subsubsection::Closed:: *)
(* FireExtinguisherAgentP *)

FireExtinguisherAgentP=Alternatives["ABC Dry Chemical","BC Dry Chemical","Carbon Dioxide","Water","Foam","Halogenated","Dry Powder","Wet Chemical"];

(* ::Subsubsection::Closed:: *)
(* FireExtinguisherColorP *)

FireExtinguisherColorP=Alternatives[Red,Yellow,Black,Blue,LightBrown];

(* ::Subsubsection::Closed:: *)
(* AlarmActivationMethodP *)

AlarmActivationMethodP=Alternatives[Lever,Glass];

(* ::Subsubsection::Closed:: *)
(* AlarmTypeP *)

AlarmTypeP=Alternatives[Fire,Oxygen];

(* ::Subsubsection::Closed:: *)
(* FacepieceMaterialP *)

FacepieceMaterialP=Alternatives["Silicone","Thermoplastic Elastomer (TPE)"];

(* ::Subsubsection::Closed:: *)
(* RespiratorSizeP *)

RespiratorSizeP=Alternatives[Small,Medium,Large];

(* ::Subsubsection::Closed:: *)
(* NIOSHFilterRatingP *)

NIOSHFilterRatingP=Alternatives[N95,SurgicalN95,N99,N100,R95,P95,P99,P100];

(* ::Subsubsection::Closed:: *)
(* NIOSHFilterRatingP *)

ParticulateTypeP=Alternatives[Ammonia,Asbestos,Formaldehyde,Methylamine,Mold,OrganicVapor,Silica];

(* ::Subsubsection::Closed:: *)
(* FloodLightSizeP *)

FloodLightSizeP=Alternatives[Small,Medium,Large];

(* ::Subsubsection::Closed:: *)
(* AlarmWarningMethodP *)

AlarmWarningMethodP=Alternatives[Audio,Visual,Both];

(* ::Subsubsection::Closed:: *)
(* LightObscurationSensorsP *)

LightObscurationSensorsP:=(LightObscurationSensor400Micrometer|LightObscurationSensor100Micrometer);


(* ::Subsubsection::Closed:: *)
(* TimesheetStatusP *)

TimesheetStatusP=Alternatives[Complete,Incomplete];

(* ::Subsubsection::Closed:: *)
(* TimesheetDiscrepancyTypeP *)

TimesheetDiscrepancyTypeP=Alternatives[Pending,Excused,Unexecused];

(* ::Subsubsection::Closed:: *)
(* BreakTypeP *)

BreakTypeP=Alternatives[Meal,Standard];

(* ::Subsubsection::Closed:: *)
(* BladeTypeP *)

BladeTypeP=Alternatives[VeeBlade,FlatBlade,ScissorBlade,ScoringBlade];

(* ::Subsubsection::Closed:: *)
(*GravityRackPlatformTypeP*)

GravityRackPlatformTypeP = Alternatives[BasePlatform,CollectionVesselBasePlatform,CollectionVesselRack,CartridgePlatform];

(* ::Subsection::Closed:: *)
(*GrinderTypeP*)

GrinderTypeP::usage = "
DEFINITION
GrinderTypeP = BallMill|KnifeMill|MortarGrinder.
A pattern that matches different types of grinders. BallMill consists of a rotating or vibrating grinding container with sample and hard balls inside in which the size reduction occurs through impact/friction of hard balls on/with the solid particles. KnifeMill consists of rotating sharp blades in which size reduction occurs through cutting of the solid particles into smaller pieces. Automated MortarGrinder consists of a rotating bowl (mortar) with the sample inside and an angled revolving column (pestle) in which size reduction occurs through pressure and friction between mortar, pestle, and sample particles.";

GrinderTypeP = Alternatives[BallMill, KnifeMill, MortarGrinder];

(* ::Subsection::Closed:: *)
(*GrindingMaterialP*)

GrindingMaterialP::usage = "
DEFINITION
GrindingMaterialP = Dry|Wet.
A pattern that matches different types of grinding conditions. Dry indicates reducing the size of solid powder particles in the absence of any liquid substances or liquid grinding aids. Wet indicates reducing the size of solid powder particles in the presence of a liquid substance or a liquid grinding aid.
";

GrindingMaterialP = Alternatives[Dry, Wet];

(* ::Subsection::Closed:: *)
(*DesiccationMethodP*)

DesiccationMethodP::usage = "
DEFINITION
DesiccationMethodP = StandardDesiccant|DesiccantUnderVacuum|Vacuum.
A pattern that matches different methods of desiccation (drying the sample via removing water or solvent molecules from the solid sample). StandardDesiccant involves utilizing a sealed bell jar desiccator that exposes the sample to a chemical desiccant that absorbs water molecules from the exposed sample. DesiccantUnderVacuum is similar to StandardDesiccant but includes creating a vacuum inside the bell jar via pumping out the air by a vacuum pump. Vacuum just includes creating a vacuum by a vacuum pump and desiccant is NOT used inside the desiccator.
";
DesiccationMethodP = Alternatives[StandardDesiccant, DesiccantUnderVacuum, Vacuum];

(* ::Subsubsection::Closed:: *)
(* ChillerTypeP *)

ChillerTypeP=Alternatives[VaporCompression,ThermoElectric];

(* ::Subsubsection::Closed:: *)
(* ChillerCoolingMechanismP *)

ChillerCoolingMechanismP=Alternatives[AirCooled,WaterCooled];

(* ::Subsubsection::Closed:: *)
(* CrystallizationTechniqueP *)
CrystallizationTechniqueP=Alternatives[SittingDropVaporDiffusion,MicrobatchWithoutOil,MicrobatchUnderOil];

(* ::Subsubsection::Closed:: *)
(* CrystallizationWellContentsP *)

CrystallizationWellContentsP=Alternatives[Drop1,Drop2,Drop3,Drop4,Drop5,Drop6,Reservoir];

(* ::Subsubsection::Closed:: *)
(* CrystallizationStepP *)

CrystallizationStepP=Alternatives[SetDrop,AirDryCoCrystallizationReagent,FillReservoir,CoverWithOil];

(* ::Subsubsection::Closed:: *)
(* CrystallizationStrategyP *)

CrystallizationStrategyP=Alternatives[Screening,Optimization,Preparation];

(* ::Subsubsection::Closed:: *)
(* CellConcentrationUnitsP *)

CellConcentrationUnitsP=Alternatives[OD600, Cell / Milliliter, CFU / Milliliter, RelativeNephelometricUnit, NephelometricTurbidityUnit, FormazinTurbidityUnit];

(* Also define the usage for the OD600 unit *)
OD600::usage = "The optical density of a sample measured at a wavelength of 600 Nanometer and with a path length of 1 Centimeter.";


(* ::Subsubsection::Closed:: *)
(*GantryTypeP*)
(* the type of positioning system used for a robot arm *)

GantryTypeP:=Alternatives[Cartesian,SCARA,Delta];

(* ::Subsubsection::Closed:: *)
(*GripperTypeP*)
(* the type of gripping mechanism employed by a robot arm *)

GripperTypeP:=Alternatives[Paddle,ExtendedReachPaddle,RoundJaw];

(* ::Subsubsection::Closed:: *)
(*StorageOrientationP*)


StorageOrientationP:=Alternatives[Upright,Side,Face,Any];

(* ::Subsubsection::Closed:: *)
MicroscopeQualSampleTypeP:=Alternatives[Sample,Adjustment];

(* ::Subsubsection::Closed:: *)
(*MediaPlatingMethodP*)
MediaPlatingMethodP:=Alternatives[Pump,Pour];

(* ::Subsubsection::Closed:: *)
(*DilutionTypeP*)
DilutionTypeP:=Alternatives[Serial,Linear];

(* ::Subsubsection::Closed:: *)
(*DilutionStrategyP*)
DilutionStrategyP:=Alternatives[Series,Endpoint];

(* ::Subsubsection::Closed:: *)
(*CommandCenterActivityP*)
CommandCenterActivityP := Alternatives[
	Login,Logout,
	Download,Search,Upload,
	CommandBuilder,Documentation,Experiments,Favorites,Inventory,NotebookCC,Notifications,ReloadKernel,Settings,Shipments
];

(* ::Subsubsection::Closed:: *)
(* SystemsProtocolDuplicateFields *)
SystemsProtocolDuplicateFields = <|
	Object[ECL`Qualification, ECL`Pipette] -> {ECL`RequestedPipettes, ECL`QualifiedPipettes},
	Object[ECL`Maintenance, ECL`Dishwash] -> {ECL`DirtyLabware},
	Object[ECL`Maintenance, ECL`StorageUpdate] -> {ECL`ScheduledMoves},
	Object[ECL`Maintenance, ECL`Handwash] -> {ECL`DirtyLabware},
	Object[ECL`Maintenance, ECL`EmptyWaste] -> {ECL`CheckedWasteBins},
	Object[ECL`Maintenance, ECL`ReceiveInventory] -> {ECL`Orders},
	Object[ECL`Maintenance, ECL`Autoclave] -> {ECL`Labware},
	Object[ECL`Maintenance, ECL`Clean, ECL`OperatorCart] -> {ECL`CartsToMaintain},
	Object[ECL`Maintenance, ECL`Shipping] -> {ECL`SamplesIn}
|>;

(* ::Subsubsection::Closed:: *)
(* LevelSensorTypeP *)
LevelSensorTypeP = Alternatives[
	CapV1,HexCap
];

(* ::Subsubsection::Closed:: *)
(* ECLSiteP *)
(* function for keeping track of all the sites we have for ECL *)
ECLSites := eclSite["Memoization"];
eclSite[testString_String] := eclSite[testString] = Module[{sites},
	If[!MemberQ[$Memoization, Patterns`Private`eclSite],
		AppendTo[$Memoization, Patterns`Private`eclSite]
	];

	sites = Search[Object[Container, Site], ECL`EmeraldFacility == True && ECL`DeveloperObject != True]
];

(* ::Subsubsection::Closed:: *)
(* DayObjectQ *)

(* Matches a day DateObject (Today, Yesterday, etc.) but not a date time or time (Now, etc.) *)
DayObjectQ[myDay_] := DateObjectQ[myDay] && EqualQ[Length[myDay[[1]]], 3];
