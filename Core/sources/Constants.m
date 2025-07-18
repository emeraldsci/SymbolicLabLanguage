(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Source Code*)


(* ::Subsubsection::Closed:: *)
(*DefineConstant*)


SetAttributes[DefineConstant, HoldAll];
DefineConstant[sym_Symbol, expression_, usage:_String:None]:=With[
	{
		func=Function[
			Unprotect[sym];
			sym=expression;
			(*If usage is specified, define the usage message for the symbol*)
			If[usage =!= None,
				sym::usage=usage
			];
			Protect[sym];
			sym
		]
	},

	(*Setup assignment to be called OnLoad of the package the constant is defined in*)
	OnLoad[func[]];

	(*Define the constant immediately and return the value*)
	func[]
];

(* ::Subsection::Closed:: *)
(*File Paths*)


(* ::Subsubsection::Closed:: *)
(*$PublicPath*)

If[StringStartsQ[$OperatingSystem,"Mac"],
	DefineConstant[
		$PublicPath,
		"/Volumes/public/",
		"The path to ECL's main public server used to store shared information, data and instrument methods."
	],
	Module[{},
		$PublicPath:=publicpathP["Memoization"];
		(* define using delayed equals and memoization so that we can download stuff, but only once *)
		publicpathP[fakeString_String]:=publicpathP[fakeString]=Module[{publicPath},
			If[!MemberQ[$Memoization, Core`Private`publicpathP],
				AppendTo[$Memoization, Core`Private`publicpathP]
			];
			publicPath = Download[$Site,PublicPath]
		];
		$PublicPath::usage="The path to ECL's main public server used to store shared information, data and instrument methods.";
	]
];


(* ::Subsubsection::Closed:: *)
(*$WindowSitePublicPath & $ManifoldSitePublicPath*)


	Module[{},
		DefineConstant[
			$ManifoldSitePublicPath,
			"/Volumes/Public/",
			"The path to ECL's Manifold public server, used to store shared information, data and instrument methods."
		];
		$WindowSitePublicPath := publicpathP["Memoization"];
		(* define using delayed equals and memoization so that we can download stuff, but only once *)
		publicpathP[fakeString_String]:=publicpathP[fakeString]=Module[{publicPath},
			If[!MemberQ[$Memoization, Core`Private`publicpathP],
				AppendTo[$Memoization, Core`Private`publicpathP]
			];
			publicPath = Download[$Site,PublicPath]
		];
		$WindowSitePublicPath::usage="The path to ECL's Windows public server used to store shared information, data and instrument methods.";
];
(* Disable printing of messages related to unavailable front end objects *)
Off[FrontEndObject::notavail];

(* ::Subsubsection::Closed:: *)
(*$EmeraldPath*)


DefineConstant[
	$EmeraldPath,
	ParentDirectory[PackageDirectory["Core`"]]
];


(* ::Subsubsection::Closed:: *)
(*$Distro*)


(* this is not defined with DefineConstant because it doesn't work that way, FWIW... *)
$Distro:=Module[
	{obj},
	(*
		the path should be something like
		C:\Users\kevin\AppData\Roaming\ECL\cc-stage\sll\id_6V0npvm0ZYJ1\SLL,
		so we can derive the distro from it
	*)
	obj=Object@StringReplace[
		FileBaseName@FileNameDrop@$EmeraldPath,
		"_" -> ":"
	];
	If[Not@MatchQ[obj, ObjectP[Object[Software, Distro]]],
		Return[$Failed]
	];
	obj
];


(* ::Subsubsection::Closed:: *)
(*$AcidStorageThreshold*)

DefineConstant[
	$AcidStorageThreshold,
	5 Milliliter,
	"The minimum volume threshold that must be reached in order for a sample with Acid->True be required to be stored in acid storage."
];

(* ::Subsubsection::Closed:: *)
(*$BaseStorageThreshold*)


DefineConstant[
	$BaseStorageThreshold,
	5 Milliliter,
	"The minimum volume threshold that must be reached in order for a sample with Acid->True be required to be stored in base storage."
];

(* ::Subsubsection::Closed:: *)
(*$FlammableStorageThreshold*)


DefineConstant[
	$FlammableStorageThreshold,
	5 Milliliter,
	"The minimum volume threshold that must be reached in order for a sample with Acid->True be required to be stored in flammable storage."
];

(* ::Subsubsection::Closed:: *)
(*$PyrophoricStorageThreshold*)


DefineConstant[
	$PyrophoricStorageThreshold,
	5 Milliliter,
	"The minimum volume threshold that must be reached in order for a sample with Acid->True be required to be stored in pyrophoric storage."
];

(* ::Subsubsection::Closed:: *)
(*$PHERAstarProtocolPath*)


DefineConstant[
	$PHERAstarProtocolPath,
	"C:\\Program Files (x86)\\BMG\\PHERAstar\\User\\Definit",
	"Indicates the software directory containing user-defined BMG protocols created for the PHERAstar."
];


(* ::Subsubsection::Closed:: *)
(*$PriceSystemSwitchDate*)


(*DefineConstant[*)
(*	$PriceSystemSwitchDate,*)
(*	*)
(*	Now - 1 Month*)
(*];*)


(* ::Subsubsection::Closed:: *)
(*$OmegaProtocolPath*)


DefineConstant[
	$OmegaProtocolPath,
	"C:\\Program Files (x86)\\BMG\\Omega\\User\\Definit",
	"Indicates the software directory containing user-defined BMG protocols created for the Omega."
];


(* ::Subsubsection::Closed:: *)
(*$CLARIOstarProtocolPath*)


DefineConstant[
	$CLARIOstarProtocolPath,
	"C:\\Program Files (x86)\\BMG\\CLARIOstar\\User\\Definit",
	"Indicates the software directory containing user-defined BMG protocols created for the CLARIOstar."
];



(* ::Subsection:: *)
(*SLL*)


(* ::Subsubsection::Closed:: *)
(*$Site*)


DefineConstant[
	$Site,
	Object[Container, Site, "id:kEJ9mqJxOl63"] (* Object[Container, Site, "ECL-2"] *),
	"The active location in which commands are being executed."
];

(* function for keeping track of all the sites we have for ECL *)
ECLSiteP:=eclSiteP["Memoization"];
eclSiteP[fakeString_String]:=eclSiteP[fakeString]=Module[{sites},
	If[!MemberQ[$Memoization, Core`Private`eclSiteP],
		AppendTo[$Memoization, Core`Private`eclSiteP]
	];
	sites = ObjectP[Search[Object[Container, Site], EmeraldFacility == True]]
];

(* ::Subsubsection::Closed:: *)
(*$OutputNamedObjects*)


DefineConstant[
	$OutputNamedObjects,
	True,
	"Indicates if any Objects in the output should be displayed with their Name instead of the ID."
];

(* ::Subsubsection::Closed:: *)
(*$MicroWaterMaximum*)


DefineConstant[
	$MicroWaterMaximum,
	1.5 Milliliter,
	"The maximum amount of water operators will be asked to prepare."
];


(* ::Subsubsection::Closed:: *)
(*$WeighBoatThreshold*)


DefineConstant[
	$WeighBoatThreshold,
	250 Gram,
	"The maximum amount of solid operators should be asked to weigh into a large weigh boat. Any volumes larger than this must be partitioned into multiple weighings."
];

(* ::Subsubsection::Closed:: *)
(*$WeighBoatSmallQuantityThreshold*)


DefineConstant[
	$WeighBoatSmallQuantityThreshold,
	50 Milligram,
	"The solid mass threshold below which recovery from the weighing container may require QuantitativeTransfer to minimize loss due to residual material."
];


(* ::Subsubsection::Closed:: *)
(*$TCMaxInoculationVolume*)


DefineConstant[
	$TCMaxInoculationVolume,
	90 Milliliter,
	"The maximum volume of single well tissue culture plates. This is the maximum volume that can be transferred in cell based experiments."
];


(* ::Subsubsection::Closed:: *)
(* Incubate pattern constants *)

(* $MinMixRate *)
DefineConstant[
	$MinMixRate,
	0.2 RPM,
	"The minimum frequency of rotation of the mixing instruments."
];

(* $MinBioSTARMixRate *)
DefineConstant[
	$MinBioSTARMixRate,
	100 RPM,
	"The minimum frequency of rotation of the robotically integrated shakers on the bioSTAR/microbioSTAR at ECL."
];

(* $MaxBioSTARMixRate *)
DefineConstant[
	$MaxBioSTARMixRate,
	2000 RPM,
	"The maximum frequency of rotation of the robotically integrated shakers on the bioSTAR/microbioSTAR at ECL."
];

(* $MinRoboticMixRate *)
DefineConstant[
	$MinRoboticMixRate,
	30 RPM,
	"The minimum frequency of rotation of the robotically integrated shakers on the robotic liquid handlers at ECL."
];

(* $MaxRoboticMixRate *)
DefineConstant[
	$MaxRoboticMixRate,
	2500 RPM,
	"The maximum frequency of rotation of the robotically integrated shakers on the robotic liquid handlers at ECL."
];

(* $MaxMixRate *)
DefineConstant[
	$MaxMixRate,
	3200 RPM,
	"The maximum frequency of rotation of the mixing instruments."
];

(* $MaxMixProfileMixRate *)
DefineConstant[
	$MaxMixProfileMixRate,
	1000 RPM,
	"The maximum frequency of rotation of the mixing instruments for which a mixing profile can be set."
];

(* $MaxNumberOfMixes *)
DefineConstant[
	$MaxNumberOfMixes,
	100,
	"The maximum number of times to mix a sample by inversion or pipetting to attempt to dissolve any solute."
];

(* $MaxNumberOfDilutions *)
DefineConstant[
	$MaxNumberOfDilutions,
	100,
	"The maximum number to dilute a sample by serial dilution or linear dilution."
];

(* $MinIncubationTemperature *)
DefineConstant[
	$MinIncubationTemperature,
	-20 Celsius,
	"The minimum temperature that can be achieved by incubation instruments."
];

(* $MaxIncubationTemperature *)
DefineConstant[
	$MaxIncubationTemperature,
	500 Celsius,
	"The maximum temperature that can be achieved by incubation instruments."
];

(* $MinTemperatureProfileTemperature *)
DefineConstant[
	$MinTemperatureProfileTemperature,
	-20 Celsius,
	"The minimum temperature that can be achieved by incubation instruments for which a temperature profile can be set."
];

(* $MaxTemperatureProfileTemperature *)
DefineConstant[
	$MaxTemperatureProfileTemperature,
	110 Celsius,
	"The maximum temperature that can be achieved by incubation instruments for which a temperature profile can be set."
];



(* ::Subsubsection:: *)
(*Centrifuge pattern constants*)

(* $MaxCentrifugeSpeed *)

DefineConstant[
	$MaxCentrifugeSpeed,
	80000 RPM,
	"The maximum rotation speed that can be achieved by centrifuge instruments."
];

(* $MaxRoboticCentrifugeSpeed *)

DefineConstant[
	$MaxRoboticCentrifugeSpeed,
	5703 RPM,
	"The maximum spinning speed that can be achieved by centrifuge instrument when performing centrifugation."
];


(* $MaxRelativeCentrifugeForce *)

DefineConstant[
	$MaxRelativeCentrifugalForce,
	504000 GravitationalAcceleration,
	"The maximum rotation speed that can be achieved by centrifuge instruments."
];

DefineConstant[
	$MaxRoboticRelativeCentrifugalForce,
	(* FIXME::This should actually be 4000 Gs, but assumed max radius in CentrifugeDevices lowers this. Fix is currently in the works. *)
	3600 GravitationalAcceleration,
	"The maximum rotation speed that can be achieved by centrifuge instruments."
];

(* $LivingMammalianCentrifugeIntensity *)

DefineConstant[
	$LivingMammalianCentrifugeIntensity,
	300 GravitationalAcceleration,
	"The default rotation speed for living mammalian cells when performing centrifugation."
];

(* $LivingBacterialCentrifugeIntensity *)

DefineConstant[
	$LivingBacterialCentrifugeIntensity,
	2000 GravitationalAcceleration,
	"The default rotation speed for living bacterial cells when performing centrifugation."
];

(* $LivingYeastCentrifugeIntensity *)

DefineConstant[
	$LivingYeastCentrifugeIntensity,
	1000 GravitationalAcceleration,
	"The default rotation speed for living yeast cells when performing centrifugation."
];

(* $MaxCentrifugeTemperature *)

DefineConstant[
	$MaxCentrifugeTemperature,
	40 Celsius,
	"The maximum temperature that can be achieved by centrifuge instruments when performing centrifugation."
];

(* $MinCentrifugeTemperature *)

DefineConstant[
	$MinCentrifugeTemperature,
	-11 Celsius,
	"The minimum temperature that can be achieved by centrifuge instruments when performing centrifugation."
];

(* $MaxRoboticAspirationAngle *)

DefineConstant[
	$MaxRoboticAspirationAngle,
	10 AngularDegree,
	"The maximum angle that can be achieved by tilt plate module when aspirating or dispensing on liquid handler."
];

(* $MaxRoboticAirPressure *)

DefineConstant[
	$MaxRoboticAirPressure,
	40 PSI,
	"The maximum amount of force that is applied via positive pressure when using the positive pressure filtration device (MPE2) on the liquid handling robots."
];

(* $MaxNumberOfWells *)

DefineConstant[
	$MaxNumberOfWells, (* If you change this constant, make sure you change the $MaxWellPosition as well *)
	384,
	"The maximum number of wells in a 384-well deep well plate."
];

(* $MaxWellPosition*)

DefineConstant[
	$MaxWellPosition,
	"P24", (*ConvertWell[$MaxNumberOfWells, NumberOfWells -> $MaxNumberOfWells]*)
	"The maximum well position of a 384-well deep well plate."
];

(* --- Cell Incubation Constants --- *)

(* $MaxCellIncubationTemperature *)
DefineConstant[
	$MaxCellIncubationTemperature,
	80 Celsius,
	"The maximum temperature a cell incubator can sustain."
];

(* $MinCellIncubationTemperature *)
DefineConstant[
	$MinCellIncubationTemperature,
	28 Celsius,
	"The minimum temperature a cell incubator can sustain."
];

(* $MaxCellIncubationCarbonDioxide *)
DefineConstant[
	$MaxCellIncubationCarbonDioxide,
	20 Percent,
	"The maximum carbon dioxide percentage a cell incubator can sustain."
];

(* $MinCellIncubationShakingRate *)
DefineConstant[
	$MinCellIncubationShakingRate,
	20 RPM,
	"The minimum shaking rate a cell incubator can sustain when shaking is turned on."
];

(* $MinCellIncubationShakingRate *)
DefineConstant[
	$MaxCellIncubationShakingRate,
	1000 RPM,
	"The maximum shaking rate a cell incubator can sustain when shaking is turned on."
];


(* ::Subsubsection:: *)
(*$StorageConditions*)


DefineConstant[
	$StorageConditions,
	<|
		AmbientStorage -> <|Temperature -> 25 Celsius|>,
		Refrigerator -> <|Temperature -> 4 Celsius|>,
		Freezer -> <|Temperature -> -20 Celsius|>,
		DeepFreezer -> <|Temperature -> -80 Celsius|>,
		CryogenicStorage -> <|Temperature -> -165 Celsius|>,

		(* NOTE: No RH control by default. *)
		YeastIncubation -> <|Temperature -> 30 Celsius|>,
		YeastShakingIncubation -> <|Temperature -> 30 Celsius, ShakingRate -> 200 RPM, PlateShakingRate -> 200 RPM, VesselShakingRate -> 200 RPM|>,

		(* NOTE: No RH control by default. *)
		BacterialIncubation -> <|Temperature -> 37 Celsius|>,
		BacterialShakingIncubation -> <|Temperature -> 37 Celsius, ShakingRadius -> 1 Inch, ShakingRate -> 200 RPM, PlateShakingRate -> 200 RPM, VesselShakingRate -> 200 RPM|>,

		MammalianIncubation -> <|Temperature -> 37 Celsius, Humidity -> 93 Percent, CarbonDioxide -> 5 Percent|>,

		(* NOTE: Same as MammalianIncubation, but for mammalian cells with viruses. *)
		ViralIncubation -> <|Temperature -> 37 Celsius, Humidity -> 93 Percent, CarbonDioxide -> 5 Percent|>,

		(* NOTE: CrystalIncubation inside of the crystal incubator generates daily image data. *)
		(* No Humidity control or CO2 control are required since all crystallization plates are sealed. *)
		CrystalIncubation -> <|Temperature -> 4 Celsius|>,


		AcceleratedTesting -> <|Temperature -> 40 Celsius, Humidity -> 75 Percent|>,
		IntermediateTesting -> <|Temperature -> 30 Celsius, Humidity -> 65 Percent|>,
		LongTermTesting -> <|Temperature -> 25 Celsius, Humidity -> 50 Percent|>,
		UVVisLightTesting -> <|Temperature -> 25 Celsius, Humidity -> 60 Percent, UVLightIntensity -> 36 Watt / Meter^2, VisibleLightIntensity -> 29 Kilo Lumen / Meter^2|>
	|>,
	"A lookup relating storage condition symbols to their implied condition values."
];



(* ::Subsubsection::Closed:: *)
(*$MaxNumberOfFulfillmentPreps*)

DefineConstant[
	$MaxNumberOfFulfillmentPreps,
	10,
	"The maximum number of times a stock solution will be prepared if a request exceeds the largest VolumeIncrements.  For instance, if the largest VolumeIncrements is 10 Milliliter and $MaxNumberOfFulfillmentPreps is 10, a request of up to 100 Milliliter will be fulfilled."
];


(* ::Subsubsection::Closed:: *)
(*$BufferbotSolutions*)


DefineConstant[
	$BufferbotSolutions,
	{(*
		Model[Sample,StockSolution,"id:BYDOjv1VA7Zr"],Model[Sample,StockSolution,"id:AEqRl954GJVl"],Model[Sample,StockSolution,"id:AEqRl954GJb6"],Model[Sample,StockSolution,"id:E8zoYveRlK1a"],Model[Sample,StockSolution,"id:Z1lqpMGjeepz"],
		Model[Sample,StockSolution,"id:jLq9jXvJWb4W"],Model[Sample,StockSolution,"id:WNa4ZjKqxbLR"],Model[Sample,StockSolution,"id:R8e1PjpqxVR4"],Model[Sample,StockSolution,"id:eGakldJZr6Dn"],Model[Sample,StockSolution,"id:R8e1PjpqxKop"],
		Model[Sample,StockSolution,"id:O81aEBZ6obO1"],Model[Sample,StockSolution,"id:n0k9mG8xWbj6"],Model[Sample,StockSolution,"id:M8n3rxYE54VP"],Model[Sample,StockSolution,"id:N80DNjlYwVV6"],Model[Sample,StockSolution,"id:wqW9BP4Y06EA"],
		Model[Sample,StockSolution,"id:WNa4ZjRr5l94"],Model[Sample,StockSolution,"id:9RdZXvKBe7xl"],Model[Sample,StockSolution,"id:D8KAEvdqzbXm"],Model[Sample,StockSolution,"id:9RdZXvKBeEAL"]
	*)},
	"A temporary listing of stock solution model IDs that may be prepared using an automated macro liquid handler."
];

(* ::Subsubsection::Closed:: *)
(*$MaxTransferVolume*)


DefineConstant[
	$MaxTransferVolume,
	20 Liter,
	"Maximum amount of volume that we can transfer in the ECL."
];

DefineConstant[
	$MaxMicropipetteVolume,
	5 Milliliter,
	"Maximum amount of volume that can be transferred in the ECL using a micropipette."
];

DefineConstant[
	$MaxSerologicalPipetVolume,
	50 Milliliter,
	"Maximum amount of volume that can be transferred in the ECL using a serological pipet."
];

(* ::Subsubsection::Closed:: *)
(*$MaxPipetteVolume*)


DefineConstant[
	$MaxPipetteVolume,
	5 Milliliter,
	"Maximum amount of volume that can be transferred via pipette (excluding serological pipettes) in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$MaxRoboticTransferVolume*)

DefineConstant[
	$MaxRoboticTransferVolume,
	200 Milliliter,
	"Maximum amount of volume that we can transfer on a robotic liquid handler in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$MinRoboticTransferVolume*)

DefineConstant[
	$MinRoboticTransferVolume,
	0.5 Microliter,
	"Minimum amount of volume that we can transfer on a robotic liquid handler in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$RoboticReservoirDeadVolume*)

DefineConstant[
	$RoboticReservoirDeadVolume,
	30 Milliliter,
	"The minimum volume required to create a uniform layer at the bottom of a robotic liquid handling reservoir, indicating the smallest volume needed to reliably aspirate from the container, measure spectral properties, etc."
];

(* ::Subsubsection::Closed:: *)
(*$MaxRoboticSingleTransferVolume*)

DefineConstant[
	$MaxRoboticSingleTransferVolume,
	970 Microliter,
	"The maximum amount of volume that can be transferred in a single pipetting step on a robotic liquid handler in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$LiquidHandlerVolumeTransferPrecision*)

DefineConstant[
	$LiquidHandlerVolumeTransferPrecision,
	0.1 Microliter,
	"The precision that is used for rounding transfer volume when using Hamilton LiquidHandler in th ECL."
];


(* ::Subsubsection::Closed:: *)
(*$AcousticLiquidHandlerVolumeTransferPrecision*)

DefineConstant[
	$AcousticLiquidHandlerVolumeTransferPrecision,
	5 Nanoliter,
	"The precision that is used for rounding transfer volume when using Echo AcousticLiquidHandler in th ECL."
];

(* ::Subsubsection::Closed:: *)
(*$MinRoboticIncubationTemperature*)

(* NOTE: The bioSTAR/microbioSTAR can achieve the full 0 C - 110 C temperature range. The STARs/STARlets can only do 0 C - 105 C. *)

DefineConstant[
	$MinRoboticIncubationTemperature,
	0 Celsius,
	"The minimum temperature of the robotically integrated heat/cold blocks on the robotic liquid handlers in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$MaxRoboticIncubationTemperature*)

DefineConstant[
	$MaxRoboticIncubationTemperature,
	110 Celsius,
	"The maximum temperature of the robotically integrated heat/cold blocks on the robotic liquid handlers in the ECL."
];

(* ::Subsubsection::Closed:: *)
(*$MinSTARIncubationTemperature*)

DefineConstant[
	$MinSTARIncubationTemperature,
	0 Celsius,
	"The minimum temperature of the robotically integrated heat/cold blocks on the STAR robotic liquid handlers in the ECL."
];

DefineConstant[
	$MaxSTARIncubationTemperature,
	105 Celsius,
	"The maximum temperature of the robotically integrated heat/cold blocks on the STAR robotic liquid handlers in the ECL."
];


(* ::Subsubsection::Closed:: *)
(*$MaxTransferMass*)


DefineConstant[
	$MaxTransferMass,
	60 Kilogram,
	"Maximum amount of mass that we can transfer in the ECL."
];


DefineConstant[
	$MaxTransferAmount,
	100,
	"Maximum discrete quantity that we can transfer in the ECL."
];


(* ::Subsubsection::Closed:: *)
(*$MaxExperimentTime*)


DefineConstant[
	$MaxExperimentTime,
	72 Hour,
	"Maximum amount of time that can be used in an experiment option."
];

(* ::Subsubsection::Closed:: *)
(*$MaxCellIncubationTime*)


DefineConstant[
	$MaxCellIncubationTime,
	72 Hour,
	"Maximum amount of time that can be used in an experiment option."
];

(* ::Subsubsection::Closed:: *)
(*$MaxCrystallizationPlateDropVolume*)

DefineConstant[
	$MaxCrystallizationPlateDropVolume,
	20 Microliter,
	"The max drop well volume of all the SBS format crystallization plates in lab."
];

DefineConstant[
	$MaxCrystallizationPlateReservoirVolume,
	300 Microliter,
	"The max reservoir well volume of all the SBS format crystallization plates in lab."
];

(* ::Subsubsection::Closed:: *)
(*$MaxFlashChromatographyGradientTime*)

DefineConstant[
	$MaxFlashChromatographyGradientTime,
	999 Minute,
	"The maximum amount of time allowed for a gradient in ExperimentFlashChromatography."
];

(* ::Subsubsection::Closed:: *)
(*$MaxFlashChromatographyBufferVolume*)

(* If you are changing this, also change the container requested for the buffer resources in flashChromatographyResourcePackets *)
DefineConstant[
	$MaxFlashChromatographyBufferVolume,
	4 Liter,
	"The maximum volume of buffer allowed for an ExperimentFlashChromatography protocol."
];

(* ::Subsubsection::Closed:: *)
(*$AmbientTemperature*)


DefineConstant[
	$AmbientTemperature,
	25 Celsius,
	"The temperature an experiment in the lab is performed at without heating or cooling."
];


(* ::Subsubsection::Closed:: *)
(*$LiquidNitrogenTemperature*)


DefineConstant[
	$LiquidNitrogenTemperature,
	-195.8 Celsius,
	"The boiling point of liquid nitrogen at standard pressure (1 bar)."
];


(* ::Subsubsection::Closed:: *)
(*$50uLTipShortage*)


DefineConstant[
	$50uLTipShortage,
	False,
	"Indicates if we have a limited supply of Model[Item,Tips,\"50 uL Hamilton tips, non-sterile\"] and Model[Item,Tips,\"300 uL Hamilton tips, non-sterile\"] should be substituted whenever the pipetting volume is <= 270 uL."
];


(* ::Subsubsection::Closed:: *)
(*$ddPCRNoMultiplex*)


DefineConstant[
	$ddPCRNoMultiplex,
	False,
	"Indicates that the multiplex options are currently unavailable."
];


(* ::Subsubsection::Closed:: *)
(*$ddPCRMasterMixes*)


DefineConstant[
	$ddPCRMasterMixes,
	{
		Model[Sample, StockSolution, "Bio-Rad One-Step RT-ddPCR Advanced Kit for Probes, 2x Master Mix"],
		Model[Sample, "Bio-Rad ddPCR Multiplex Supermix"],
		Model[Sample, "Bio-Rad ddPCR Supermix for Probes"],
		Model[Sample, "Bio-Rad ddPCR Supermix for Probes (No dUTP)"],
		Model[Sample, "Bio-Rad ddPCR Supermix for Residual DNA Quantification"]
	},
	"A listing of master mixes supported by ExperimentDigitalPCR for Bio-Rad QXONE."
];


(* ::Subsubsection::Closed:: *)
(*$BuilderPreviewNoCallouts*)


DefineConstant[
	$BuilderPreviewNoCallouts,
	True,
	"Indicates that Placed[] and Callout[] are not supported in command builder previews."
];


(* ::Subsubsection::Closed:: *)
(*$DoubleDownload*)


DefineConstant[
	$DoubleDownload,
	False,
	"Indicates if two consequent Download calls are allowed in Experiment functions to avoid downloading information for duplicate containers."
];


(* ::Subsubsection::Closed:: *)
(*$ObjectSelectorWorkaround*)


DefineConstant[
	$ObjectSelectorWorkaround,
	True,
	"Indicates that a redundant expression widget is to be provided in order to circumvent long object selector widget load times."
];

(* ::Subsubsection::Closed:: *)
(*$SharedPricingFields*)


DefineConstant[
	$SharedPricingFields,
	{
		(* account info fields *)
		Site, AccountType, CommitmentLength,  PlanType, LabAccessFee, NumberOfBaselineUsers, NumberOfThreads,
		(* pricing and included discounts *)
		CleanUpPricing, IncludedCleaningFees,IncludedCleanings,
		CommandCenterPrice,
		ConstellationPrice,
		InstrumentPricing, IncludedInstrumentHours,
		IncludedPriorityProtocols,
		IncludedShipmentFees,
		StockingPricing, IncludedStockingFees,
		StoragePricing, IncludedStorageFees, IncludedStorage,
		WastePricing, IncludedWasteDisposalFees,
		OperatorTimePrice, OperatorPriorityTimePrice,OperatorModelPrice,
		PricePerExperiment, PricePerPriorityExperiment,
		PrivateTutoringFee},
	"A list of fields shared between Model[Pricing] and Object[Bill] and used for the creation of the new bills."
];

(* ::Subsubsection::Closed:: *)
(*$MaxUpFunctionsRequired*)


DefineConstant[
	$MaxUpFunctionsRequired,
	200,
	"The maximum number of up-function tests needed for a successful ValidPullRequestQ is determined by $MaxUpFunctionsRequired. If the number of up-functions exceeds $MaxUpFunctionsRequired, ManifoldRunUnitTestUp will select a reproducible subset of $MaxUpFunctionsRequired up-functions for testing. Selection is reproducible as long as the input functions remain unchanged; and the associated up-functions for each function remain constant, i.e., no new up-function is added or deleted."
];


(* ::Subsection::Closed:: *)
(*Sequences*)


(* ::Subsubsection::Closed:: *)
(*$MaximumSequences*)


DefineConstant[
	$MaximumSequences,
	100000000,
	"Maximum number of sequences that can be generated."
];


(* ::Subsection::Closed:: *)
(*Colors*)


(* ::Subsubsection::Closed:: *)
(*$MotifColors*)


DefineConstant[
	$MotifColors,
	{
		RGBColor[{85 / 255, 125 / 255, 253 / 255}],
		RGBColor[{64 / 255, 90 / 255, 94 / 255}],
		RGBColor[{180 / 255, 71 / 255, 229 / 255}],
		RGBColor[{42 / 255, 209 / 255, 242 / 255}],
		RGBColor[{219 / 255, 15 / 255, 161 / 255}],
		RGBColor[{52 / 255, 2 / 255, 106 / 255}],
		RGBColor[{116 / 255, 101 / 255, 60 / 255}],
		RGBColor[{255 / 255, 102 / 255, 0 / 255}],
		RGBColor[{255 / 255, 0 / 255, 0 / 255}],
		RGBColor[{0 / 255, 0 / 255, 255 / 255}],
		RGBColor[{0 / 255, 255 / 255, 0 / 255}]
	},
	"Print friendly color list used in motif labeling."
];



(* ::Subsubsection::Closed:: *)
(*$SciDevTeam*)


DefineConstant[
	$SciDevTeam,
	"steven",
	"Scientific Development team."
];

(* ::Subsubsection::Closed:: *)
(*$VideoPC*)


DefineConstant[
	$VideoPC,
	True,
	"Indicates if video recording should be performed on the specialized video-1-pc rather than on the local instrument computer."
];


(* ::Subsection::Closed:: *)
(*System Information*)


OnLoad[
	Unprotect[System`$OutputSizeLimit];
	System`$OutputSizeLimit=1024 * 1024 * 4;
];

(* ::Subsubsection::Closed:: *)
(*$RackPicking*)


DefineConstant[
	$RackPicking,
	True,
	"Indicate if racks will be required to pick non-selfstanding containers, enforced in validatePicking."
];


(* ::Subsubsection::Closed:: *)
(*$CartRectification*)


DefineConstant[
	$CartRectification,
	True,
	"Indicates if CartRectification tasks should be run."
];


(* ::Subsubsection::Closed:: *)
(*$PositionLowerTolerance*)

DefineConstant[
	$PositionUpperTolerance,
	0.0001 Meter,
	"The amount by which a position's dimension must exceed the dimension of an object it holds in order to ensure that the position is not too snug to physically fit the object."
];

(* ::Subsubsection::Closed:: *)
(*$PositionUpperTolerance*)

DefineConstant[
	$PositionLowerTolerance,
	0.005 Meter,
	"The amount by which a position's dimension may exceed the dimensions of an object which is contains, such that an object that is not capable of maintaining its standing orientation is held upright."
];

(* ::Subsubsection::Closed:: *)
(*$DimensionTolerance*)

DefineConstant[
	$DimensionTolerance,
	0.005 Meter,
	"A default tolerance that is used when comparing two physical distance measurements, such as dimensions."
];

(* ::Subsubsection::Closed:: *)
(*$FullMovementValidation*)


DefineConstant[
	$FullMovementValidation,
	True,
	"Indicates if ValidUploadLocationQ will be called during validateMovement in Movement and Storage tasks."
];

(* ::Subsubsection::Closed:: *)
(*$AutomatedStorage*)

DefineConstant[
	$AutomatedStorage,
	True,
	"Indicates if storage tasks are fully prescriptive or allow operators to select any available position suitable for storage."
];


(* ::Subsubsection::Closed:: *)
(*$AutomatedStorage*)

DefineConstant[
	$StorageOverflowThreshold,
	1.2,
	"Indicates the amount by which the contents must exceed the capacity of a position in order to consider it over full."
];


(* ::Subsubsection::Closed:: *)
(*$LargeVolumeDisposalThreshold*)

DefineConstant[
	$LargeVolumeDisposalThreshold,
	4 Liter,
	"Indicates the volume above which a liquid sample must be disposed of into a 55 Gallon drum instead of a 4L satellite waste collection."
];

(* ::Subsubsection::Closed:: *)
(*$CoverSubsRequired*)

(*when True, no logic will be performed that could replace a Cover sub with a VerifyObject task*)
DefineConstant[
	$CoverSubsRequired,
	False,
	"When True, no logic will be performed that could replace a Cover sub with a VerifyObject tasks."
];

(* ::Subsubsection::Closed:: *)
(*$ScanPositionsOnly*)

DefineConstant[
	$ScanPositionsOnly,
	True,
	"When True, stringToMovement will only allow movements and returns Failed when passed an object ID string."
];


(* ::Subsubsection::Closed:: *)
(*$CrossFlowMeasureAbsorbance*)


DefineConstant[
	$CrossFlowMeasureAbsorbance,
	False,
	"Indicate if absorbance measurement feature for crossflow filtration is turned on."
];



(* ::Subsubsection::Closed:: *)
(*$ImmobileTypes*)

DefineConstant[
	$ImmobileTypes,
	{
		Object[Container, Building],
		Object[Container, Cabinet],
		Object[Container, FlammableCabinet],
		Object[Container, Enclosure],
		Object[Container, Floor],
		Object[Container, Bench],
		Object[Container, OperatorCart],
		Object[Container, Room],
		Object[Container, Site]
	},
	"Types of objects that cant be moved using the Engine dropdown or in movement tasks in Engine."
];

(* ::Subsubsection::Closed:: *)
(*$RestrictRackUsage*)


DefineConstant[
	$RestrictRackUsage,
	False,
	"Indicates if the status of a rack impacts which object may be placed into or removed from it."
];

(* ::Subsubsection::Closed:: *)
(*$RequireModelDimensions*)

DefineConstant[
	$RequireModelDimensions,
	True,
	"Indicates if ValidUploadLocationQ will require that the Model of the moved Object has Dimensions populated when called in Engine."
];

(* ::Subsubsection::Closed:: *)
(*$CountLiquidParticlesAllowHandSwirl*)

DefineConstant[
	$CountLiquidParticlesAllowHandSwirl,
	False
];


(* ::Subsubsection::Closed:: *)
(*$MaxConsolidationNumber*)
DefineConstant[
	$MaxConsolidationNumber,
	10,
	"Indicates the max number of containers which can be used when consolidating samples to create a single sample with sufficient volume during resource picking."
];


(* ::Subsubsection::Closed:: *)
(*$MinConsolidationVolume*)
DefineConstant[
	$MinConsolidationVolume,
	50 Microliter,
	"Indicates the minimum volume as sample must have in order to be a candidate for consolidation."
];

(* ::Subsubsection::Closed:: *)
(*$ConsolidationCutOff*)
DefineConstant[
	$ConsolidationCutOff,
	0.1,
	"Indicates the minimum percentage volume of the entire request as sample must have in order to be a candidate for consolidation."
];

(* ::Subsubsection::Closed:: *)
(*$SPERoboticOnly*)

(* feature flag temporarily forcing only robotic SPE *)
DefineConstant[
	$SPERoboticOnly,
	False,
	"Feature flag forcing SolidPhaseExtraction to only allow Robotic."
];


(* ::Subsubsection::Closed:: *)
(*$GrowCrystalPreparedOnly*)
(* feature flag temporarily forcing only accept Prepared CrystallizationPlate *)
DefineConstant[
	$GrowCrystalPreparedOnly,
	True,
	"Feature flag forcing GrowCrystal to only allow Prepared CrystallizationPlate."
];

(* ::Subsubsection::Closed:: *)
(*$IncubateCellsIncubateOnly*)
(* feature flag temporarily forcing only perform cell incubation without quantification or target for IncubateCells V1 *)
DefineConstant[
	$IncubateCellsIncubateOnly,
	True,
	"Feature flag forcing IncubateCells to only only perform cell incubation without quantification or target."
];

(* ::Subsubsection::Closed:: *)
(*$QuantifyColoniesPreparedOnly*)
(* feature flag temporarily forcing only accept Prepared Sample for QuantifyColonies V1 *)
DefineConstant[
	$QuantifyColoniesPreparedOnly,
	False,
	"Feature flag forcing QuantifyColonies to only allow prepared samples."
];

(* ::Subsubsection::Closed:: *)
(*$QPixImageScale*)

DefineConstant[
	$QPixImageScale,
	219 Pixel/(Centi Meter),
	"The image scale of brightfield/absorbance/fluorescence images taken by QPix colony handler."
];

(* ::Subsubsection::Closed:: *)
(*$QPixMinDiameter*)

DefineConstant[
	$QPixMinDiameter,
	0.2 Millimeter,
	"The minimum colonies detected by AnalyzeColonies from images taken by QPix colony handler."
];

(* ::Subsubsection::Closed:: *)
(*$MaxNumberOfWashes*)

DefineConstant[
	$MaxNumberOfWashes,
	20,
	"The maximum number of times to wash a sample by adding solution or buffer and then aspirating to remove debris, residue, and impurities."
];

(* ::Subsubsection::Closed:: *)
(*$MinRoboticTransferRate*)

DefineConstant[
	$MinRoboticTransferRate,
	1 Microliter / 1 Minute,
	"The minimum rate at which liquid is aspirated/dispensed from the robotic pipettes when using a liquid handler."
];

(* ::Subsubsection::Closed:: *)
(*$MaxRoboticTransferRate*)

DefineConstant[
	$MaxRoboticTransferRate,
	500 Microliter / 1 Minute,
	"The maximum rate at which liquid is aspirated/dispensed from the robotic pipettes when using a liquid handler."
];

(* ::Subsubsection::Closed:: *)
(*$MaxRoboticIncubationTime*)

DefineConstant[
	$MaxRoboticIncubationTime,
	3 Hour,
	"The maximum duration of time for which a liquid-handler integrated incubator can be used by a single protocol."
];

(* ::Subsubsection::Closed:: *)
(*$OptimizedPostProcessing*)

DefineConstant[
	$OptimizedPostProcessing,
	False,
	"Indicates if post-processing subprotocols are enqueued globally, not individually."
];

(* ::Subsubsection::Closed:: *)
(*$StorageSpider*)

DefineConstant[
	$StorageSpider,
	False,
	"Indicates if items are stored via a temporary holding area instead of directly to inventory."
];

(* ::Subsubsection::Closed:: *)
(*$AllowedShutdownTypes*)
(* TEMPORARY variable to allow only key protocols to run while the SSF facility is closing. This should be reverted as soon a we want to run all maintenance and quals in Austin *)
$AllowedShutdownTypes={Object[Maintenance,EmptyWaste],Object[Maintenance,Handwash],Object[Maintenance,Dishwash],Object[Maintenance,Clean],Object[Maintenance,RefillReservoir],Object[Maintenance,Defrost],Object[Maintenance,Replace],Object[Maintenance,Lubricate],Object[Maintenance,Decontaminate],Object[Maintenance,AuditGasCylinders]};


(* ::Subsubsection::Closed:: *)
(*$MaxNumberOfWashes*)

DefineConstant[
	$OperatorGasCylinderTrainingQ,
	False,
	"Indicates if operators are trained to safely handle gas cylinders (note that cylinder != dewar tank)."
];


(* ::Subsubsection::Closed:: *)
(*$SupportObject*)

DefineConstant[
	$SupportObject,
	True,
	"Indicates if troubleshooting objects have been migrated to support objects."
];


(* ::Subsubsection::Closed:: *)
(*$UnifiedSupportTicketStatusField*)

DefineConstant[
	$UnifiedSupportTicketStatusField,
	False,
	"Indicates if existing support ticket status fields, such as Blocked have been migrated into the new combined Status field."
];


(* ::Subsubsection::Closed:: *)
(*$CustomerProtocolWarningTime*)

DefineConstant[
	$CustomerProtocolWarningTime,
	4 Hour,
	"The amount of time a customer can be blocked before PlotSupportManager will display a warning."
];


(* ::Subsubsection::Closed:: *)
(*$SystemsProtocolWarningTime*)

DefineConstant[
	$SystemsProtocolWarningTime,
	16 Hour,
	"The amount of time an internal protocol, qualification or maintenance can be blocked before PlotSupportManager will display a warning."
];

(* ::Subsubsection::Closed:: *)
(*$MaxNumberOfItemsInAsepticBag*)

DefineConstant[
	$MaxNumberOfItemsInAsepticBag,
	15,
	"The maximum number of items we will put into an Object[Container,Bag,Aseptic] when doing a bulk rebagging inside a bsc."
];

(* ::Subsubsection::Closed:: *)
(*$BaselineOperator*)

DefineConstant[
	$BaselineOperator,
	Model[User, Emerald, Operator, "id:9RdZXv1DrGja"],
	"The model of Baseline operator."
];

(* ::Subsubsection::Closed:: *)
(*$CuvetteMaxVolume*)

DefineConstant[
	$CuvetteMaxVolume,
	4.0 Milliliter,
	"The maximum volume that can be contained by a Model[Container, Cuvette] in the ECL."
];


(* ::Subsubsection::Closed:: *)
(*$MaxVolumetricFlaskShakeRate*)

DefineConstant[
	$MaxVolumetricFlaskShakeRate,
	250 RPM,
	"The maximum mix rate that can be reached to shake volumetric flasks."
];