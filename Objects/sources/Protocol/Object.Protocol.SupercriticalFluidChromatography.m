(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, SupercriticalFluidChromatography], {
	Description->"A protocol describing the separation of materials using supercritical CO2 fluid chromatography (SFC).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Information ---*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The device containing a pump, column oven, and detector(s) that executes this experiment.",
			Category -> "General"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates if the SFC is intended to separate material (Preparative) and therefore collect fractions and/or analyze properties of the material (Analytical).",
			Category -> "General",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation that categorizes the mobile and stationary phase used, ideally for optimal sample separation and resolution.",
			Category -> "General",
			Abstract -> True
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "Indicates the types of measurements performed for the experiment and available on the Instrument.",
			Category -> "General",
			Abstract -> True
		},
		AcquisitionMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AcquisitionModeP,
			Description -> "For experiments with MassSpectrometry available, the type of acquisition being performed in this protocol. MS mode measures the masses of the intact analytes, whereas MSMS measures the masses of the analytes fragmented by collision-induced dissociation.",
			Category -> "General",
			Abstract -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "For experiments with MassSpectrometry available, the type of the component of the mass spectrometer that performs ion separation based on m/z (mass-to-charge ratio). SingleQuadrupole selects ions individually for measurement.",
			Category -> "General",
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "For experiments with MassSpectrometry available, the type of ionization used to create gas-phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas-phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission.",
			Category -> "General",
			Abstract -> True
		},

		ImportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory to which all import files will be written.",
			Category -> "General",
			Developer -> True
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterP[0*Second],
			Description -> "The estimated completion time for the protocol.",
			Category -> "General",
			Developer -> True
		},
		PurgeWasteContainerA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Model[Container,Vessel]
			],
			Description -> "The container used to hold waste from air bubble removal procedures for buffer lines. It is also used to hold waste from rinsing plumbing connections.",
			Category -> "General"
		},
		PurgeWasteContainerB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Model[Container,Vessel]
			],
			Description -> "The container used to hold waste from air bubble removal procedures for buffer lines.",
			Category -> "General"
		},
		PurgeSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Consumable],
				Model[Item, Consumable]
			],
			Description -> "The syringe used to pull air and buffer from the buffer lines to clear them of air bubbles.",
			Category -> "General",
			Developer -> True
		},

		(* --- Cleaning --- *)

		ExternalNeedleWashSolution ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to wash the outside of the injection needle and pumps before, during, and after the experiment.",
			Category -> "Cleaning"
		},
		NeedleWashSolution ->  {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to wash the inside of the injection needle and pumps before, during, and after the experiment.",
			Category -> "Cleaning"
		},
		NeedleWashPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing the ExternalNeedleWashSolution and NeedleWashSolution needed to wash the injection needle.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},

		(*--- System Prime Information ---*)

		SystemPrimeBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge buffer A line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge buffer B line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge buffer C line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge buffer D line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeMakeupSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the makeup line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},

		InitialSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferA as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferB as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferC as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferD as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeMakeupSolvent as measured by ultrasonics before the priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		InitialSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferA taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferB taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferC taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeBufferD taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of SystemPrimeMakeupSolvent taken immediately before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The solvent composition over time for the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},

		FinalSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferA as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferB as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferC as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferD as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeMakeupSolvent as measured by ultrasonics after the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},

		FinalSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeBufferA taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeBufferB taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeBufferC taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeBufferD taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemPrimeMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemPrimeMakeupSolvent taken immediately after priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system prime raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the prime file into the instrument software prior to installation of the column.",
			Category -> "Cleaning",
			Developer -> True
		},

		(*--- Column Information ---*)
		ColumnSelection -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The stationary phase device(s) through which the Cosolvents and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Cosolvents, samples, column material, and ColumnTemperature.",
			Category -> "Column Installation",
			Abstract -> True
		},
		ColumnConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Item,Column],Null},
			Description -> "The connection information for attaching columns to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Item,Column]|Object[Plumbing],Null},
			Description -> "The connection information for attaching columns joins to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container], Null},
			Description -> "The destination information for the disconnected column joins.",
			Headers -> {"Container", "Position"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnOrientation -> {
			Format->Multiple,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"For each member of ColumnSelection, the direction of the Column for the protocol with respect to the flow.",
			IndexMatching -> ColumnSelection,
			Category->"Column Installation"
		},

		(*--- Cosolvent information ---*)

		CosolventA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position A, the flow of which is directed by GradientA compositions.",
			Category -> "General",
			Abstract -> True
		},
		CosolventB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position B, the flow of which is directed by GradientB compositions.",
			Category -> "General",
			Abstract -> True
		},
		CosolventC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position C, the flow of which is directed by GradientC compositions.",
			Category -> "General",
			Abstract -> True
		},
		CosolventD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position D, the flow of which is directed by GradientD compositions.",
			Category -> "General",
			Abstract -> True
		},
		MakeupSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution pumped and supplementing the column effluent on entry to the mass spectrometer.",
			Category -> "General",
			Abstract -> True
		},
		CosolventACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate CosolventA during this protocol.",
			Category -> "General"
		},
		CosolventBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate CosolventB during this protocol.",
			Category -> "General"
		},
		CosolventCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate CosolventC during this protocol.",
			Category -> "General"
		},
		CosolventDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate CosolventD during this protocol.",
			Category -> "General"
		},
		MakeupSolventCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate MakeupSolvent during this protocol.",
			Category -> "General"
		},
		Calibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "A sample with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			Category -> "Sample Preparation"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "A list of deck placements used for placing cosolvents needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},

		InitialCosolventAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventA immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventB immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventC immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventD immediately before the experiment was started.",
			Category -> "General"
		},
		InitialMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of MakeupSolvent immediately before the experiment was started.",
			Category -> "General"
		},

		InitialCosolventAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventA taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventB taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventC taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialCosolventDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventD taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of MakeupSolvent taken immediately before the experiment was started.",
			Category -> "General"
		},
		MaxAcceleration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute / Minute],
			Units -> (Liter Milli) / Minute / Minute,
			Description -> "The maximum rate at which it's safe to increase the flow rate for the column and instrument during the run.",
			Category -> "General",
			Abstract -> False
		},

		(*--Injection sequence--*)

		InjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				InjectionVolume->Real,
				Column->Link,
				Gradient->Link,
				DilutionFactor->Real,
				ColumnTemperature->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				Column->ObjectP[{Object[Item],Model[Item]}],
				Gradient->ObjectP[Object[Method]],
				DilutionFactor->GreaterP[0],
				ColumnTemperature->GreaterP[0*Celsius],
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				InjectionVolume->Null,
				Column->Alternatives[
					Object[Item],
					Model[Item]
				],
				Gradient->Object[Method],
				DilutionFactor->Null,
				ColumnTemperature->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				InjectionVolume->Micro Liter,
				Column->None,
				Gradient->None,
				DilutionFactor->None,
				ColumnTemperature->Celsius,
				Data->None
			},
			Description -> "The sequence of samples injected for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category -> "General"
		},

		ExperimentInjectionTableFilePath ->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the experimental SFC runs into the instrument software.",
			Category -> "General",
			Developer -> True
		},


		(*---ColumnPrime---*)

		ColumnPrimeGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of ColumnSelection, the composition of the CO2 and cosolvents within the flow, defined for specific time points during the equilibration of the columns (column prime).",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeCO2Gradient -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventA in the composition over time, in the form: {Time, % Cosolvent A} or a single % Cosolvent A for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventB in the composition over time, in the form: {Time, % Cosolvent B} or a single % Cosolvent B for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventC in the composition over time, in the form: {Time, % Cosolvent C} or a single % Cosolvent C for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventD in the composition over time, in the form: {Time, % Cosolvent D} or a single % Cosolvent D for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeBackPressure -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "For each member of ColumnSelection, the applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelection, the total rate of mobile phase pumped through the instrument for each column prime.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the nominal temperature of the column compartment for each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},

		ColumnPrimeIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of ColumnSelection, indicates if positively or negatively charged ions are analyzed each column prime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMakeupFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelection, the total rate of MakeupSolvent pumped through the instrument for each column prime.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnSelection, the all of the mass-to-charge ratio (m/z) measured via mass spectrometry.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnSelection, the lowest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnSelection, the highest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the temperature of the needle that sprays column effluent into the ionization chamber for each ColumnPrime run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeSourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of ColumnSelection, the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeSamplingConeVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of ColumnSelection, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnSelection, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of ColumnSelection, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},

		ColumnPrimeAbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "For each member of ColumnSelection, all the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector for each column prime.",
			IndexMatching->ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeUVFilter -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelection, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},
		ColumnPrimeAbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelection, indicates the frequency of measurement for UVVis or PDA detectors.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Prime"
		},

		(* --- Sample Preparation--- *)

		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the autosampler where the input samples are incubated prior to injection on the column.",
			Category -> "Sample Preparation"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume taken from the sample and injected onto the column.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation",
			Abstract -> True
		},
		PlateSeal -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of WorkingContainers, the piercable, adhesive film to cover plate(s) of injection sample(s) in this experiment in order to mitigate sample evaporation. For non-plate containers, the plate seal is Null.",
			Category -> "Sample Preparation"
		},

		(*--Autosampler information--*)

		AutosamplerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing SamplesIn, Blanks, and Standards onto the Instrument.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		AutosamplerRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing the holder containers (racks) for SamplesIn, Blanks, and Standards on to the Instrument.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},

		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the CO2 and solvent gradient used for purification.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient",
			Abstract -> True
		},
		CO2Gradient -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of CosolventA in the composition over time, in the form: {Time, % Cosolvent A} or a single % Cosolvent A for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of CosolventB in the composition over time, in the form: {Time, % Cosolvent B} or a single % Cosolvent B for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of CosolventC in the composition over time, in the form: {Time, % Cosolvent C} or a single % Cosolvent C for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of CosolventD in the composition over time, in the form: {Time, % Cosolvent D} or a single % Cosolvent D for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		BackPressures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "For each member of SamplesIn, the applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		FlowRate -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of SamplesIn, the total rate of mobile phase pumped through the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient",
			Abstract -> True
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of SamplesIn, the column used from the column selector for the separation and measurement.",
			Category -> "Gradient",
			IndexMatching -> SamplesIn
		},
		ColumnTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the nominal temperature of the column compartment during a run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},

		(*Detector specific options*)

		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of SamplesIn, indicates if positively or negatively charged ions are analyzed each column prime run.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		MakeupFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of SamplesIn, the total rate of MakeupSolvent pumped through the instrument for each column prime.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		MassSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of SamplesIn, all of the mass-to-charge ratio (m/z) measured via mass spectrometry.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		MinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of SamplesIn, the lowest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		MaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of SamplesIn, the highest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature of the needle that sprays column effluent into the ionization chamber.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		SourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		SamplingConeVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		MassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of SamplesIn, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},

		AbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "For each member of SamplesIn, all the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		MinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the minimum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		MaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		WavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		UVFilters -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of SamplesIn, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for Absorbance detectors (PDA).",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		AbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of SamplesIn, indicates the frequency of measurement for PDA detectors.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},

		(*--- Standards ---*)

		Standards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Samples with known profiles used to calibrate peak integrations and retention times for a given run.",
			Category -> "Standards"
		},
		StandardSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Standards, the volume taken from the standard and injected onto the column.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Standards, the method used to describe the gradient used for purification.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardCO2Gradient -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of CosolventA in the composition over time, in the form: {Time, % Cosolvent A} or a single % Cosolvent A for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of CosolventB in the composition over time, in the form: {Time, % Cosolvent B} or a single % Cosolvent B for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of CosolventC in the composition over time, in the form: {Time, % Cosolvent C} or a single % Cosolvent C for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of CosolventD in the composition over time, in the form: {Time, % Cosolvent D} or a single % Cosolvent D for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardBackPressures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "For each member of Standards, the applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Standards, the total rate of mobile phase pumped through the instrument.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of Standards, the column used from the column selector for the separation and measurement.",
			Category -> "Standards",
			IndexMatching -> Standards
		},
		StandardColumnTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Standards, the nominal temperature of the column compartment during a run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},

		StandardIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of Standards, indicates if positively or negatively charged ions are analyzed each column prime run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMakeupFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Standards, the total rate of MakeupSolvent pumped through the instrument for each column prime.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMassSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of Standards, all of the mass-to-charge ratio (m/z) measured via mass spectrometry.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of Standards, the lowest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of Standards, the highest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Standards, the temperature of the needle that sprays column effluent into the ionization chamber.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardSourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Standards, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardSamplingConeVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of Standards, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of Standards, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "For each member of Standards, all the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardUVFilters -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Standards, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for Absorbance detectors (PDA).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Standards, indicates the frequency of measurement for PDA detectors.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardsStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of Standards, the storage conditions under which the standard samples should be stored after the protocol is completed.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},

		(* --- Blanks --- *)
		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Buffer only samples injected to asses background signal from the buffers and column in the absence of injected analyte.",
			Category -> "Blanking"
		},
		BlankSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Blanks, the volume taken from the blank and injected onto the column.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Blanks, the method used to describe the gradient used for purification.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankCO2Gradient -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of CosolventA in the composition over time, in the form: {Time, % Cosolvent A} or a single % Cosolvent A for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of CosolventB in the composition over time, in the form: {Time, % Cosolvent B} or a single % Cosolvent B for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of CosolventC in the composition over time, in the form: {Time, % Cosolvent C} or a single % Cosolvent C for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of CosolventD in the composition over time, in the form: {Time, % Cosolvent D} or a single % Cosolvent D for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankBackPressures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "For each member of Blanks, the applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Blanks, the total rate of mobile phase pumped through the instrument.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of Blanks, the column used from the column selector for the separation and measurement.",
			Category -> "Blanking",
			IndexMatching -> Blanks
		},
		BlankColumnTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Blanks, the nominal temperature of the column compartment during a run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},

		BlankIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of Blanks, indicates if positively or negatively charged ions are analyzed each column prime run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMakeupFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Blanks, the total rate of MakeupSolvent pumped through the instrument for each column prime.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMassSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of Blanks, all of the mass-to-charge ratio (m/z) measured via mass spectrometry.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of Blanks, the lowest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of Blanks, the highest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Blanks, the temperature of the needle that sprays column effluent into the ionization chamber.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankSourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Blanks, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankSamplingConeVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of Blanks, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of Blanks, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "For each member of Blanks, all the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector.",
			IndexMatching->Blanks,
			Category -> "Blanking"
		},
		BlankMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Blanks,
			Category -> "Blanking"
		},
		BlankMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Blanks,
			Category -> "Blanking"
		},
		BlankWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching->Blanks,
			Category -> "Blanking"
		},
		BlankUVFilters -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Blanks, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for Absorbance detectors (UVVis or PDA).",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Blanks, indicates the frequency of measurement for UVVis or PDA detectors.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlanksStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of Blanks, the storage conditions under which the blank samples should be stored after the protocol is completed.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},

		(*--- Column Flush ---*)
		ColumnFlushGradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of ColumnSelection, the composition of the CO2 and cosolvents within the flow, defined for specific time points during the washing of the columns (column flush).",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushCO2Gradient -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of supercritical CO2 in the composition over time, in the form: {Time, % CO2} or a single % CO2 for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventA in the composition over time, in the form: {Time, % Cosolvent A} or a single % Cosolvent A for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventB in the composition over time, in the form: {Time, % Cosolvent B} or a single % Cosolvent B for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventC in the composition over time, in the form: {Time, % Cosolvent C} or a single % Cosolvent C for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of ColumnSelection, the percentage of CosolventD in the composition over time, in the form: {Time, % Cosolvent D} or a single % Cosolvent D for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushBackPressures -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],GreaterP[0 PSI]}...}|GreaterP[0 PSI]),
			Description -> "For each member of ColumnSelection, the applied pressure between the atmosphere and the PhotoDiodeArray detector exit, in the form: {Time, BackPressure} or a single BackPressure for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelection, the total rate of mobile phase pumped through the instrument for each column flush.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the nominal temperature of the column compartment for each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},

		ColumnFlushIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of ColumnSelection, indicates if positively or negatively charged ions are analyzed each column flush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMakeupFlowRates -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelection, the total rate of MakeupSolvent pumped through the instrument for each column flush.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnSelection, the all of the mass-to-charge ratio (m/z) measured via mass spectrometry.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnSelection, the lowest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnSelection, the highest measured mass-to-charge ratio (m/z) value.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushProbeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the temperature of the needle that sprays column effluent into the ionization chamber for each ColumnFlush run.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushSourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelection, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of ColumnSelection, the applied voltage differential between the injector and the inlet plate for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushSamplingConeVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Volt],
			Units -> Volt,
			Description -> "For each member of ColumnSelection, the voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone (the metal shield covering the front of the source block), towards the quadrupole mass analyzer.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnSelection, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMassDetectionGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0.01,1000.00,0.01],
			Description -> "For each member of ColumnSelection, indicates the arbitrary-scaled signal amplification of the mass spectrometry measurement.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceSelection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "For each member of ColumnSelection, all the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector.",
			IndexMatching->ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelection, the increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushUVFilters -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelection, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PDA detector.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelection, indicates the frequency of measurement for UVVis or PDA detectors.",
			IndexMatching -> ColumnSelection,
			Category -> "Column Flush"
		},

		(* --- Experimental Results --- *)

		ExportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory to which data will be saved.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's raw data to the server.",
			Category -> "Experimental Results",
			Developer -> True
		},
		StandardData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the standard's injection.",
			Category -> "Experimental Results"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the blank's injection.",
			Category -> "Experimental Results"
		},
		PrimeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for any column prime runs.",
			Category -> "Experimental Results"
		},
		FlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for any column flush runs.",
			Category -> "Experimental Results"
		},
		SystemPrimeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for the system prime run whereby the system is flushed with solvent before the column is connected.",
			Category -> "Experimental Results",
			Developer->True
		},
		SystemFlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Chromatography traces generated for the system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category -> "Experimental Results",
			Developer->True
		},
		LampDataFile->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The raw data files in xps format of the Lamp History Report from MassLynx software.",
			Category -> "Experimental Results",
			Developer -> True
		},
		InitialAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured prior to injection.",
			Category -> "Experimental Results"
		},
		FinalAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured at the end of the protocol.",
			Category -> "Experimental Results"
		},
		InjectedAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "The volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) that was injected during the protocol, calculated as the difference between InitialAnalyteVolumes and FinalAnalyteVolumes.",
			Category -> "Experimental Results"
		},

		(*--- Final Cosolvent state ---*)

		FinalCosolventAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventA immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventB immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventC immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of CosolventD immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of MakeupSolvent immediately after the experiment was started.",
			Category -> "Gradient"
		},

		FinalCosolventAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventA taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventB taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventC taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalCosolventDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of CosolventD taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of MakeupSolvent taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},

		(*--- SystemFlush ---*)

		SystemFlushCosolventA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel A used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushCosolventB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel B used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushCosolventC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel C used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushCosolventD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel D used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushMakeupSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through the makeup solvent channel used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system flush buffers needed to run the flush protocol onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},

		InitialSystemFlushCosolventAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventA immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventB immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventC immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventD immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the MakeupSolvent immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		InitialSystemFlushCosolventAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushCosolventA taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushCosolventB taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushCosolventC taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushCosolventDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushCosolventD taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushMakeupSolvent taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of solvents over time used to purge the instrument lines at the end.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system flush raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the flush file into the instrument software after removing the column.",
			Category -> "Cleaning",
			Developer -> True
		},


		FinalSystemFlushCosolventAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventA immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventB immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventC immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushCosolventD immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushMakeupSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushMakeupSolvent immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		FinalSystemFlushCosolventAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushCosolventA taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushCosolventB taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushCosolventC taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushCosolventDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushCosolventD taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushMakeupSolventAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushMakeupSolvent taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		WasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight data of the waste carboy after the SFC protocol is complete.",
			Category -> "Experimental Results",
			Developer -> True
		}

	}
}];
