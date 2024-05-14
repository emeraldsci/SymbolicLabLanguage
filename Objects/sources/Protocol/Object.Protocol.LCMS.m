(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, LCMS], {
	Description->"The protocol describing the separation, ionization, selection, fragmentation (sometimes), and detection of analytes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Instrument Information ---*)
		MassSpectrometryInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The device containing a pump, column oven, and columns used to separate the analytes.",
			Category -> "General",
			Abstract -> True
		},
		ChromatographyInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The device containing a pump, column oven, and columns used to separate the analytes.",
			Category -> "General",
			Abstract -> True
		},
		MassAnalyzer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MassAnalyzerTypeP,
			Description -> "The type of the component of the mass spectrometer that performs ion separation based on m/z (mass-to-charge ratio). SingleQuadrupole selects ions individually for measurement.",
			Category -> "General",
			Abstract -> True
		},
		IonSource -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonSourceP,
			Description -> "For experiments with MassSpectrometry available, the type of ionization used to create gas phase ions from the molecules in the sample. Electrospray ionization (ESI) produces ions using an electrospray in which a high voltage is applied to a liquid to create an aerosol, and gas phase ions are formed from the fine spray of charged droplets as a result of solvent evaporation and Coulomb fission.",
			Category -> "General",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation that categorizes the mobile and stationary phase used, ideally for optimal sample separation and resolution.",
			Category -> "General"
		},
		Detectors -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "The types of measurements performed for the experiment and available on the ChromatographyInstrument.",
			Category -> "General"
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
		PurgeWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The container used to collect purged buffer liquid.",
			Category -> "General",
			Developer -> True
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

		(* Instrument set up for ESI-QQQ as MassSpectrometry Analyzer *)
		SyringeDisconnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing syringe connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		SyringeConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The connection information for the  syringe connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCDisconnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The disconnection information for removing existing HPLC connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Instrument], Null, Object[Part]|Object[Plumbing], Null},
			Description -> "The connection information for the HPLC connection from mass spectrometer.",
			Headers -> {"Instrument", "Connector", "Mixer or Join", "Part Inlet"},
			Category -> "Instrument Setup",
			Developer -> True
		},
		HPLCDisconnectionSlot -> {
			Format -> Single,
			Class -> {Link, String},
			Pattern :> {_Link, _String},
			Relation -> {Model[Container] | Object[Container] | Model[Instrument] | Object[Instrument], Null},
			Description -> "The destination information for the disconnected HPLC tubing from the MassSpectrometer.",
			Headers -> {"Container", "Position"},
			Category -> "Instrument Setup",
			Developer -> True
		},

		(* --- Cleaning --- *)
		TubingRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse buffers lines before and after and the experiment.",
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
		SystemPrimeFlushPlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container],Model[Container]],
			Description -> "The empty plate used for fake as the sample for running system prime and flush for ESI-QQQ.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeFlushPlatePlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing blank 96-well plate into the autosampler of the HPLC instrument used as fake sample for running system prime and flush.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		SystemPrimeBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer A line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer B line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer C line at the start of the protocol before column installation.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer D line at the start of the protocol before column installation.",
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
		BufferLineConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing], Null, Object[Item,Cap], Null},
			Description -> "The instructions for attaching the inlet lines to the system prime buffer and sample caps.",
			Headers -> {"Instrument Buffer Inlet Line", "Inlet Line Connection", "Buffer Cap", "Buffer Cap Connector"},
			Category -> "General",
			Developer -> True
		},

		InitialSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferA as measured by ultrasonics before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferB as measured by ultrasonics before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferC as measured by ultrasonics before priming the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemPrimeBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferD as measured by ultrasonics before priming the instrument.",
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

		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The solvent composition over time for the system prime.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeMassAcquisitionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The operation of the mass analyzer during initial cleaning.",
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

		SystemPrimeInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the prime file into the instrument software prior to installation of the column.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemPrimeExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system prime methods to the server.",
			Category -> "Cleaning",
			Developer -> True
		},

		(*--- Column Information ---*)
		ColumnSelection->{
			Format->Multiple,
			Class->{
				GuardColumn->Link,
				GuardColumnJoin->Link,
				Column->Link,
				ColumnJoin->Link,
				SecondaryColumn->Link,
				SecondaryColumnJoin->Link,
				TertiaryColumn->Link
			},
			Pattern:>{
				GuardColumn->ObjectP[{Object[Item,Column],Model[Item,Column]}],
				GuardColumnJoin->ObjectP[{Object[Plumbing,ColumnJoin],Model[Plumbing,ColumnJoin]}],
				Column->ObjectP[{Object[Item,Column],Model[Item,Column]}],
				ColumnJoin->ObjectP[{Object[Plumbing,ColumnJoin],Model[Plumbing,ColumnJoin]}],
				SecondaryColumn->ObjectP[{Object[Item,Column],Model[Item,Column]}],
				SecondaryColumnJoin->ObjectP[{Object[Plumbing,ColumnJoin],Model[Plumbing,ColumnJoin]}],
				TertiaryColumn->ObjectP[{Object[Item,Column],Model[Item,Column]}]
			},
			Relation->{
				GuardColumn->Alternatives[
					Object[Item,Column],
					Model[Item,Column]
				],
				GuardColumnJoin->Alternatives[
					Object[Plumbing,ColumnJoin],
					Model[Plumbing,ColumnJoin]
				],
				Column->Alternatives[
					Object[Item,Column],
					Model[Item,Column]
				],
				ColumnJoin->Alternatives[
					Object[Plumbing,ColumnJoin],
					Model[Plumbing,ColumnJoin]
				],
				SecondaryColumn->Alternatives[
					Object[Item,Column],
					Model[Item,Column]
				],
				SecondaryColumnJoin->Alternatives[
					Object[Plumbing,ColumnJoin],
					Model[Plumbing,ColumnJoin]
				],
				TertiaryColumn->Alternatives[
					Object[Item,Column],
					Model[Item,Column]
				]
			},
			Description -> "The configurations of stationary phase devices used for analyte separation.",
			Category -> "General",
			Abstract -> True
		},
		ColumnAssemblyConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Item,Column],Null},
			Description -> "The instructions for assembling all the components with ColumnSelection before placing into the Instrument.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Item, Column],Null,Object[Plumbing]|Object[Item, Column],Null},
			Description -> "The connection information for attaching columns to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnDisconnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Item, Column], Null, Object[Plumbing]|Object[Item, Column], Null},
			Description -> "The connection information for disconnecting column joins prior to attaching columns to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector", "Column Connector Name", "Column", "Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnJoinConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing],Null,Object[Item,Column]|Object[Plumbing, ColumnJoin],Null},
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
		Column -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The stationary phase device(s) through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, column material, and column temperature.",
			Category -> "Column Installation"
		},
		SecondaryColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The second stationary phase device(s) through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, column material, and column temperature.",
			Category -> "Column Installation"
		},
		TertiaryColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The third stationary phase device(s) through which the Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, column material, and column temperature.",
			Category -> "Column Installation"
		},
		ColumnJoins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing,ColumnJoin],
				Model[Plumbing,ColumnJoin]
			],
			Description -> "The connections used to link multiple columns.",
			Category -> "General"
		},
		GuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "A protective device placed in the flow path before the Column in order to adsorb fouling contaminants and, thus, preserve the Column lifetime. If GuardColumnOrientation is ReverseOrientation, the GuardColumn will be placed after Columns in the flow path.",
			Category -> "Column Installation"
		},
		GuardCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "A module that holds the adsorbent within the GuardColumn.",
			Category -> "Column Installation"
		},
		ColumnTighteningWrench -> {
			Format -> Single,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Model[Item,Wrench]|Object[Item,Wrench],Model[Item,Wrench]|Object[Item,Wrench]},
			Description -> "The wrenches used to untighten and tighten the Guard Column to install Guard Cartridges.",
			Category->"Column Installation",
			Developer -> True,
			Headers -> {"Column Tightening Wrench 1","Column Tightening Wrench 2"}
		},
		ResinLoading -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Gram],
			Units -> Gram,
			Description -> "The amount (in grams) of adsorbent that is loaded into the GuardColumn.",
			Category -> "Column Installation"
		},
		GuardColumnJoin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing,ColumnJoin],
				Model[Plumbing,ColumnJoin]
			],
			Description -> "The connection used to link the column and guard column employed in this HPLC purification.",
			Category -> "Column Installation"
		},
		LeakTestFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to test the connections for leaks after the column has been installed and before starting the column prime.",
			Category -> "Column Installation",
			Developer -> True
		},
		LeakTestInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the files into the instrument software after the column has been installed and before starting the column prime to test the connections for leaks.",
			Category -> "Column Installation",
			Developer -> True
		},
		LeakTestExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's leak test raw data to the server.",
			Category -> "Cleaning",
			Developer -> True
		},
		(*Buffer information*)
		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position A, the flow of which is directed by GradientA compositions.",
			Category -> "General"
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position B, the flow of which is directed by GradientB compositions.",
			Category -> "General"
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position C, the flow of which is directed by GradientC compositions.",
			Category -> "General"
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent connected to position D, the flow of which is directed by GradientD compositions.",
			Category -> "General"
		},

		BufferACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
(*			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],*)
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate BufferA during this protocol.",
			Category -> "General"
		},
		BufferBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate BufferB during this protocol.",
			Category -> "General"
		},
		BufferCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate BufferC during this protocol.",
			Category -> "General"
		},
		BufferDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The cap used to aspirate BufferD during this protocol.",
			Category -> "General"
		},

		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferA taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferB taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferC taken immediately before the experiment was started.",
			Category -> "General"
		},
		InitialBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferD taken immediately before the experiment was started.",
			Category -> "General"
		},
		MaxAcceleration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute / Minute],
			Units -> (Liter Milli) / Minute / Minute,
			Description -> "The maximum rate at which it's safe to increase the flow rate for the column and instrument during the run.",
			Category -> "General"
		},

		(*--Injection sequence--*)

		InjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				InjectionVolume->Real,
				Gradient->Link,
				MassSpectrometry->Link,
				DilutionFactor->Real,
				ColumnTemperature->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				Gradient->ObjectP[Object[Method]],
				MassSpectrometry->ObjectP[Object[Method]],
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
				Gradient->Object[Method],
				MassSpectrometry->Object[Method],
				DilutionFactor->Null,
				ColumnTemperature->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				InjectionVolume->Micro Liter,
				Gradient->None,
				MassSpectrometry->None,
				DilutionFactor->None,
				ColumnTemperature->Celsius,
				Data->None
			},
			Description -> "The sequence of samples injected for a given experiment run including for ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category -> "General",
			Abstract -> True
		},

		ExperimentInjectionTableFilePath ->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the experimental LC runs into the instrument software.",
			Category -> "General",
			Developer -> True
		},
		ExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to convert and export data gathered by the instrument to the network drive.",
			Category -> "General",
			Developer -> True
		},
		RawFileExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the export script file used to export the raw data and method files gathered by the instrument to the network drive.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		RawFileImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the import script file used to convert procedure JSON file from the network drive to the method file that can be ran by the Instrument .",
			Category -> "Mass Analysis",
			Developer -> True
		},
		ImportScriptFilePaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The files used to perform any data transcription and movement to the public path. This field is appended to multiple times in the procedure for (1) system prime, (2) user data, and (3) system flush respectively.",
			Category -> "Cleaning",
			Developer -> True
		},
		WIFFDataFileNemes -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The data file generated from this protocol by using ESI-QQQ as the mass spectrometer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		GeneralDataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path where data files are stored on along the public path.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		GeneralMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path where method files are stored on along the public path.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		(*column prime block*)
		ColumnPrimeGradientMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of the buffers within the flow, defined for specific time points during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column prime, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column prime, the constant percentage of BufferA in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column prime, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column prime, the constant percentage of BufferB in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column prime, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column prime, the constant percentage of BufferC in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column prime, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column prime, the constant percentage of BufferD in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For column prime, the total rate of mobile phase pumped through the instrument for each column prime. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Prime"
		},
		ColumnPrimeFlowRateConstant ->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For column prime, the constant rate of mobile phase pumped through the instrument for each column prime. Compositions of Buffers in the flow adds up to 100%.",
			Units -> (Milli * Liter) / Minute,
			Category -> "Column Prime"
		},
		ColumnPrimeTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For column prime, the nominal temperature of the column compartment during a run.",
			Category -> "Column Prime"
		},

		ColumnPrimeMassAcquisitionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "A redundant set of operating instructions for the mass analysis device during the priming of the column. This method file can be used for future experiments.",
			Category -> "Column Prime"
		},
		ColumnPrimeIonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The polarity of the charged analyte.",
			Category -> "Column Prime"
		},
		ColumnPrimeESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
			Category -> "Column Prime"
		},
		ColumnPrimeDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Column Prime"
		},
(*		ColumnPrimeDesolvationGasFlow -> {*)
(*			Format -> Single,*)
(*			Class -> Real,*)
(*			Pattern :> GreaterP[(1*Liter)/Hour],*)
(*			Units -> Liter/Hour,*)
(*			Description -> "The rate of nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray.",*)
(*			Category -> "Column Prime"*)
(*		},*)
		ColumnPrimeDesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The rate of nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Column Prime"
		},
		ColumnPrimeSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			Category -> "Column Prime"
		},
		ColumnPrimeDeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			Category -> "Column Prime"
		},
		ColumnPrimeConeGasFlow -> {
			Format -> Single,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The rate of nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directs the spray into the ion block while keeping the sample cone clean.",
			Category -> "Column Prime"
		},
		ColumnPrimeStepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage between the two stages of the ion filter.",
			Category -> "Column Prime"
		},
		ColumnPrimeIonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			Category -> "Column Prime"
		},
		ColumnPrimeAcquisitionWindows -> {
			Format -> Multiple,
			Class -> {
				StartTime->Real,
				EndTime->Real
			},
			Pattern :> {
				StartTime->GreaterEqualP[0*Second],
				EndTime->GreaterEqualP[0*Second]
			},
			Units -> {
				StartTime->Minute,
				EndTime->Minute
			},
			Description -> "The time blocks to acquire measurements for each column prime run.",
			Category -> "Column Prime"
		},
		ColumnPrimeAcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MSAcquisitionModeP,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the manner of scanning and/or fragmenting intact and resultant ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFragmentations -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFragmentMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> ListableP[UnitsP[0Volt]],
			Units -> Volt,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the applied potential that accelerates ions into an inert gas for induced dissociation.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeDwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of ColumnPrimeAcquisitionWindows, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeCollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Volt],
			Units -> Volt,
			Description ->"For each member of ColumnPrimeAcquisitionWindows, in ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of ColumnPrimeAcquisitionWindows, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of ColumnPrimeAcquisitionWindows, if using ESI-QQQ as the mass spectrometry, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Class->Expression,
			Pattern :> {(<|
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			|>|{Null})..},
			Category -> "Column Prime"
		},
		ColumnPrimeNeutralLosses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of ColumnPrimeAcquisitionWindows, if the sample will be scanned in NeutralIonLoss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeFragmentScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the duration of time allowed to pass between each spectral acquisition for the product ions when ColumnPrimeAcquisitionMode -> DataDependent.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeAcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeMinimumThresholds -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeAcquisitionLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the maximum number of measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeCycleTimeLimits -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0Volt]..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0Volt]..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0,1]..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0*Second]..
			},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeInclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeChargeStateLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[1,1]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeIsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Dalton]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeIsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeIsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*1/Second]..},
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeIsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeIsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnPrimeAcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> ColumnPrimeAcquisitionWindows,
			Category -> "Column Prime"
		},
		ColumnPrimeAbsorbanceSelection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "All the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector for each column prime.",
			Category -> "Column Prime"
		},
		ColumnPrimeMinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Prime"
		},
		ColumnPrimeMaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Prime"
		},
		ColumnPrimeWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Prime"
		},
		ColumnPrimeUVFilter -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PDA detector.",
			Category -> "Column Prime"
		},
		ColumnPrimeAbsorbanceSamplingRate -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "Indicates the frequency of measurement for UVVis or PDA detectors.",
			Category -> "Column Prime"
		},

		AutosamplerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "List of autosampler container deck placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		AutosamplerRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "List of autosampler container rack placements.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},

		(* --- Sample Preparation--- *)

		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the chamber input samples are incubated in prior to injection on the column.",
			Category -> "Sample Preparation"
		},
		SampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume taken from the sample and injected onto the column.",
			IndexMatching -> SamplesIn,
			Category -> "Sample Preparation"
		},
		PlateSeal -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "The package of piercable, adhesive film used to cover plates of injection samples in this experiment in order to mitigate sample evaporation.",
			Category -> "Sample Preparation"
		},

		GradientAs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		IsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferA in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientBs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		IsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferB in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientCs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		IsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferC in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		GradientDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of SamplesIn, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		IsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferD in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient"
		},
		FlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For each member of SamplesIn, the time dependent rate at which mobile phase is pumped through the instrument.Compositions of Buffers in the flow adds up to 100%.",
			IndexMatching -> SamplesIn,
			Category -> "Instrument Setup"
		},
		FlowRateConstant -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of SamplesIn, the constant rate at which mobile phase is pumped through the instrument.Compositions of Buffers in the flow adds up to 100%.",
			IndexMatching -> SamplesIn,
			Units -> (Milli * Liter) / Minute,
			Category -> "Instrument Setup"
		},
		GradientMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the buffer gradient used for purification.",
			IndexMatching -> SamplesIn,
			Category -> "Gradient",
			Abstract -> True
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

		Calibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "A sample with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			Category -> "Mass Analysis"
		},

		(*QQQ specific calibrant fields*)
		SecondCalibrant -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "An additional samples with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			Category -> "Mass Analysis"
		},
		UniqueCalibrants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For the analysis, all unique samples with known m/z (mass-to-charge ratios) used to calibrate the mass spectrometer.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "For each member of UniqueCalibrants, the syringe used in ESI-QQQ instrument for direct infusion the unique calibrants via syringe pump.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringeNeedles->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "For each member of UniqueCalibrants, the needle used by the syringe in the DirectInfusion process for unique calibrants used in ESI-QQQ instrument via syringe pump.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"For each member of UniqueCalibrants, the unique calibrants of sample being injected into the mass spectrometer by using syringe pumps, this is a unique field of ESI-QQQ.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used in ESI-QQQ instrument for direct infusion the first calibrants via syringe pump.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		SecondCalibrantInfusionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Syringe],
				Object[Container, Syringe]
			],
			Description -> "The syringe used in ESI-QQQ instrument for direct infusion the second calibrants via syringe pump.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		CalibrantInfusionSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle used by the syringe in the calibration process for ESI-QQQ instrument.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		SecondCalibrantInfusionSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Needle],
				Object[Item, Needle]
			],
			Description -> "The needle used by the syringe in the calibration process for ESI-QQQ instrument.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		MassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		SampleMassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		BlankMassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		StandardMassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		ColumnPrimeMassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		ColumnFlushMassSpectrometryScans->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[UnitOperation, MassSpectrometryScan]]..},
			Description -> "The entire mass spectrometry analysis scan for this LCMS experiment.",
			Category -> "Mass Analysis"
		},
		(* End of QQQ specific calibrant fields*)
		CalibrantPlacement -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "Instructions for placing the calibrant solution onto the instrument.",
			Category -> "Mass Analysis",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		CalibrationMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the settings used to calibrate the instrument.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CalibrantMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the calibration tune file used during the calibration.",
			Category -> "Experimental Results",
			Developer -> True
		},
		CalibrantReportsFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the folder to which the calibration reports are stored after the calibration.",
			Category -> "Experimental Results",
			Developer -> True
		},
		CalibrantStorage -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "The storage conditions under which any Calibrant to this experiment should be stored after their usage in this experiment.",
			Category -> "Mass Analysis"
		},
		MassAcquisitionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,MassAcquisition],
			Description -> "For each member of SamplesIn, a redundant set of operating instructions for the mass analysis device during separation and detection. Can be used for future experiments.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "The estimated amount of time remaining until when the current round of instrument processing is projected to finish.",
			Category -> "Mass Analysis",
			Units -> Minute,
			Developer -> True
		},
		InfusionSyringeTubing->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing, Tubing]
			],
			Description -> "The tubing we used to connect the syringe from the syring pump to the mass spectrometer.",
			Category -> "Mass Analysis"
		},
		IonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of SamplesIn, the polarity of the charged analyte.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		ESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		DesolvationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		DesolvationGasFlows -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray. This setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the desolvation gas flow). Please refer to the documentation for details.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		SourceTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		DeclusteringVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		ConeGasFlows -> {
			Format -> Multiple,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		StepwaveVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the applied voltage between the two stages of the ion filter.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		IonGuideVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of SamplesIn, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		AcquisitionWindows -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0*Second],GreaterEqualP[0*Second]}..},
			Description -> "For each member of SamplesIn, the time blocks to acquire measurement for each sample.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		AcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {MSAcquisitionModeP..},
			Description -> "For each member of SamplesIn, the manner of scanning and/or fragmenting intact and resultant ions.",
			Category -> "Mass Analysis",
			IndexMatching -> SamplesIn
		},
		Fragmentations -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{BooleanP..},
			Description -> "For each member of SamplesIn, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			Category -> "Mass Analysis",
			IndexMatching -> SamplesIn
		},
		MinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of SamplesIn, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			Category -> "Mass Analysis",
			IndexMatching -> SamplesIn
		},
		MaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of SamplesIn, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of SamplesIn, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Second]..},
			Description -> "For each member of SamplesIn, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentMinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of SamplesIn, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of SamplesIn, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of SamplesIn, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ListableP[(UnitsP[0Volt]|Null)]..},
			Description -> "For each member of SamplesIn, the applied potential that accelerates ions into an inert gas for induced dissociation.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		LowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of SamplesIn, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		HighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of SamplesIn, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of SamplesIn, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of SamplesIn, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		DwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of SamplesIn, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(UnitsP[0 Volt]|Null)..},
			Description ->"For each member of SamplesIn, in ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of SamplesIn, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of SamplesIn, if using ESI-QQQ as the mass spectrometry, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> SamplesIn,
			Class->Expression,
			Pattern :> {(<|
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			|>|{Null})..},
			Category -> "Mass Analysis"
		},
		NeutralLosses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of SamplesIn, if the sample will be scanned in NeutralIonLoss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		FragmentScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of SamplesIn, the duration of time allowed to pass between each spectral acquisition for the product ions when AcquistionMode -> DataDependent.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		AcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of SamplesIn, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		MinimumThresholds -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of SamplesIn, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		AcquisitionLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of SamplesIn, the maximum number of measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		CycleTimeLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of SamplesIn, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of SamplesIn, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..}|Null)..},
			Description -> "For each member of SamplesIn, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of SamplesIn, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of SamplesIn, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of SamplesIn, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			}|Null)..},
			Description -> "For each member of SamplesIn, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of SamplesIn, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of SamplesIn, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0,1]..
			}|Null)..},
			Description -> "For each member of SamplesIn, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0*Second]..
			}|Null)..},
			Description -> "For each member of SamplesIn, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		InclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of SamplesIn, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ChargeStateLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[0, 1]|Null)..},
			Description -> "For each member of SamplesIn, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterEqualP[1,1]..}|Null)..},
			Description -> "For each member of SamplesIn, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		ChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of SamplesIn, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		IsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0 Dalton]..}|Null)..},
			Description -> "For each member of SamplesIn, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		IsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0]..}|Null)..},
			Description -> "For each member of SamplesIn, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		IsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*1/Second]..}|Null)..},
			Description -> "For each member of SamplesIn, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		IsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0*Percent]|Null)..},
			Description -> "For each member of SamplesIn, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
		},
		IsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of SamplesIn, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> SamplesIn,
			Category -> "Mass Analysis"
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
		StandardGradientAs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the constant percentage of BufferA in the mobile phase composition over time.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientBs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the constant percentage of BufferB in the mobile phase composition over time.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientCs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the constant percentage of BufferC in the mobile phase composition over time.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradientDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Standards, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the constant percentage of BufferD in the mobile phase composition over time.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For each member of Standards, the total time dependent rate of mobile phase pumped through the instrument. Compositions of Buffers in the flow adds up to 100%.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFlowRateConstant -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Standards, the constant rate of mobile phase pumped through the instrument. Compositions of Buffers in the flow adds up to 100%.",
			Units -> (Milli * Liter) / Minute,
			IndexMatching -> Standards,
			Category -> "Standards"
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
		StandardMassAcquisitionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,MassAcquisition],
			Description -> "For each member of Standards, a redundant set of operating instructions for the mass analysis device during separation and detection. Can be used for future experiments.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of Standards, the polarity of the charged analyte.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardDesolvationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Standards, the temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardDesolvationGasFlows -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray. This setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the desolvation gas flow). Please refer to the documentation for details.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
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
		StandardDeclusteringVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardConeGasFlows -> {
			Format -> Multiple,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		StandardStepwaveVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the applied voltage between the two stages of the ion filter.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIonGuideVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Standards, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAcquisitionWindows -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0*Second],GreaterEqualP[0*Second]}..},
			Description -> "For each member of Standards, the time blocks to acquire measurement for each sample.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {MSAcquisitionModeP..},
			Description -> "For each member of Standards, the manner of scanning and/or fragmenting intact and resultant ions.",
			Category -> "Standards",
			IndexMatching -> Standards
		},
		StandardFragmentations -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{BooleanP..},
			Description -> "For each member of Standards, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			Category -> "Standards",
			IndexMatching -> Standards
		},
		StandardMinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Standards, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			Category -> "Standards",
			IndexMatching -> Standards
		},
		StandardMaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Standards, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of Standards, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Second]..},
			Description -> "For each member of Standards, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFragmentMinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Standards, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Standards, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of Standards, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ListableP[(UnitsP[0Volt]|Null)]..},
			Description -> "For each member of Standards, the applied potential that accelerates ions into an inert gas for induced dissociation.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Standards, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Standards, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Standards, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Standards, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardDwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of Standards, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardCollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(UnitsP[0 Volt]|Null)..},
			Description ->"For each member of Standards, in ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of Standards, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of SamplesIn, if using ESI-QQQ as the mass spectrometry, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> SamplesIn,
			Class->Expression,
			Pattern :> {(<|
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			|>|{Null})..},
			Category -> "Standards"
		},
		StandardNeutralLosses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of Standards, if the sample will be scanned in NeutralIonLoss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardFragmentScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Standards, the duration of time allowed to pass between each spectral acquisition for the product ions when AcquistionMode -> DataDependent.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Standards, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardMinimumThresholds -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Standards, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAcquisitionLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Standards, the maximum number of measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardCycleTimeLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Standards, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of Standards, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..}|Null)..},
			Description -> "For each member of Standards, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Standards, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Standards, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of Standards, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			}|Null)..},
			Description -> "For each member of Standards, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of Standards, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of Standards, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0,1]..
			}|Null)..},
			Description -> "For each member of Standards, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0*Second]..
			}|Null)..},
			Description -> "For each member of Standards, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardInclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Standards, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardChargeStateLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[0, 1]|Null)..},
			Description -> "For each member of Standards, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterEqualP[1,1]..}|Null)..},
			Description -> "For each member of Standards, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Standards, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0 Dalton]..}|Null)..},
			Description -> "For each member of Standards, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0]..}|Null)..},
			Description -> "For each member of Standards, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*1/Second]..}|Null)..},
			Description -> "For each member of Standards, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0*Percent]|Null)..},
			Description -> "For each member of Standards, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardIsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Standards, the range of m/z to consider for exclusion by ionic state property.",
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


		(*--- Blanks ---*)

		Blanks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "Samples with known profiles used to calibrate peak integrations and retention times for a given run.",
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
		BlankGradientAs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the constant percentage of BufferA in the mobile phase composition over time.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankGradientBs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the constant percentage of BufferB in the mobile phase composition over time.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankGradientCs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the constant percentage of BufferC in the mobile phase composition over time.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankGradientDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For each member of Blanks, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the constant percentage of BufferD in the mobile phase composition over time.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]|GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Blanks, the total time dependent rate of mobile phase pumped through the instrument. Compositions of Buffers in the flow adds up to 100%.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankFlowRateConstant -> {
			Format -> Multiple,
			Class -> Real,
			Units -> (Milli*Liter)/Minute,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of Blanks, the constant rate of mobile phase pumped through the instrument. Compositions of Buffers in the flow adds up to 100%.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
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
		BlankMassAcquisitionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,MassAcquisition],
			Description -> "For each member of Blanks, a redundant set of operating instructions for the mass analysis device during separation and detection. Can be used for future experiments.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIonModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "For each member of Blanks, the polarity of the charged analyte.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankESICapillaryVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankDesolvationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "For each member of Blanks, the temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankDesolvationGasFlows -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray. This setting affects sensitivity and is usually adjusted according to InfusionFlowRates (the higher the flow rate, the higher the desolvation gas flow). Please refer to the documentation for details.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
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
		BlankDeclusteringVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankConeGasFlows -> {
			Format -> Multiple,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "For each member of SamplesIn, the nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean.",
			IndexMatching -> SamplesIn,
			Category -> "Ionization"
		},
		BlankStepwaveVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the applied voltage between the two stages of the ion filter.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIonGuideVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "For each member of Blanks, the absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAcquisitionWindows -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{GreaterEqualP[0*Second],GreaterEqualP[0*Second]}..},
			Description -> "For each member of Blanks, the time blocks to acquire measurement for each sample.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {MSAcquisitionModeP..},
			Description -> "For each member of Blanks, the manner of scanning and/or fragmenting intact and resultant ions.",
			Category -> "Blanking",
			IndexMatching -> Blanks
		},
		BlankFragmentations -> {
			Format->Multiple,
			Class->Expression,
			Pattern:>{BooleanP..},
			Description -> "For each member of Blanks, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			Category -> "Blanking",
			IndexMatching -> Blanks
		},
		BlankMinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Blanks, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			Category -> "Blanking",
			IndexMatching -> Blanks
		},
		BlankMaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Blanks, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of Blanks, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Second]..},
			Description -> "For each member of Blanks, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFragmentMinMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Blanks, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[(0*Gram)/Mole]|Null)..},
			Description -> "For each member of Blanks, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[(0*Gram)/Mole]..}|Null)..},
			Description -> "For each member of Blanks, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ListableP[(UnitsP[0Volt]|Null)]..},
			Description -> "For each member of Blanks, the applied potential that accelerates ions into an inert gas for induced dissociation.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Blanks, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Blanks, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Blanks, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0Volt]|Null)..},
			Description -> "For each member of Blanks, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankDwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of Blanks, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankCollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(UnitsP[0 Volt]|Null)..},
			Description ->"For each member of Blanks, in ESI-QQQ analysis, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of Blanks, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of SamplesIn, if using ESI-QQQ as the mass spectrometry, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> SamplesIn,
			Class->Expression,
			Pattern :> {(<|
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			|>|{Null})..},
			Category -> "Blanking"
		},
		BlankNeutralLosses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[(0*Gram)/Mole]|Null)..},
			Description ->"For each member of Blanks, if the sample will be scanned in NeutralIonLoss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankFragmentScanTimes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Blanks, the duration of time allowed to pass between each spectral acquisition for the product ions when AcquistionMode -> DataDependent.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Blanks, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankMinimumThresholds -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Blanks, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAcquisitionLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0, 1]|Null)..},
			Description -> "For each member of Blanks, the maximum number of measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankCycleTimeLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Blanks, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of Blanks, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..}|Null)..},
			Description -> "For each member of Blanks, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Blanks, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Second]|Null)..},
			Description -> "For each member of Blanks, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{UnitsP[Minute],UnitsP[Minute]}..
			}|Null)..},
			Description -> "For each member of Blanks, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			}|Null)..},
			Description -> "For each member of Blanks, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of Blanks, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0Volt]..
			}|Null)..},
			Description -> "For each member of Blanks, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0,1]..
			}|Null)..},
			Description -> "For each member of Blanks, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({
				GreaterEqualP[0*Second]..
			}|Null)..},
			Description -> "For each member of Blanks, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankInclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Blanks, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankChargeStateLimits -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterEqualP[0, 1]|Null)..},
			Description -> "For each member of Blanks, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterEqualP[1,1]..}|Null)..},
			Description -> "For each member of Blanks, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Blanks, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0 Dalton]..}|Null)..},
			Description -> "For each member of Blanks, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0]..}|Null)..},
			Description -> "For each member of Blanks, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*1/Second]..}|Null)..},
			Description -> "For each member of Blanks, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0*Percent]|Null)..},
			Description -> "For each member of Blanks, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankIsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {(GreaterP[0 Dalton]|Null)..},
			Description -> "For each member of Blanks, the range of m/z to consider for exclusion by ionic state property.",
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
			Description -> "For each member of Blanks, indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for Absorbance detectors (PDA).",
			IndexMatching -> Blanks,
			Category -> "Blanking"
		},
		BlankAbsorbanceSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Blanks, indicates the frequency of measurement for PDA detectors.",
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
		ColumnFlushGradientMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For column flush (when solvent is run through without injection), the method used to describe the gradient used.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column flush, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column flush, the constant percentage of BufferA in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column flush, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column flush, the constant percentage of BufferB in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column flush, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column flush, the constant percentage of BufferC in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}|RangeP[0 Percent,100 Percent]),
			Description -> "For column flush, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For column flush, the constant percentage of BufferD in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For column flush, the time dependent rate of mobile phase pumped through the instrument for each column flush. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Flush"
		},
		ColumnFlushFlowRateConstant -> {
			Format -> Multiple,
			Class -> Real,
			Units -> (Milli * Liter)/ Minute,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For column flush, the constant rate of mobile phase pumped through the instrument for each column flush. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Flush"
		},
		ColumnFlushTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For column flush, the nominal temperature of the column compartment during a run.",
			Category -> "Column Flush"
		},
		ColumnFlushMassAcquisitionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,MassAcquisition],
			Description -> "A redundant set of operating instructions for the mass analysis device during the cleaning of the columns. Can be used for future experiments.",
			Category -> "Blanking"
		},
		ColumnFlushIonMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IonModeP,
			Description -> "The polarity of the charged analyte.",
			Category -> "Column Flush"
		},
		ColumnFlushESICapillaryVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage differential between the injector and the inlet for the mass spectrometry in order to ionize analyte molecules.",
			Category -> "Column Flush"
		},
		ColumnFlushDesolvationTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Column Flush"
		},
		ColumnFlushDesolvationGasFlow -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[(1*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The rate of nitrogen gas flow ejected around the ESI (electrospray ionization) capillary, used for solvent evaporation to produce single gas phase ions from the ion spray.",
			Category -> "Column Flush"
		},
		ColumnFlushSourceTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Celsius],
			Units -> Celsius,
			Description -> "The temperature that the source block is set to in order to discourage condensation and decrease solvent clustering in the reduced vacuum region of the source.
				The source block is the metallic chamber with reduced pressure separating the sprayer (at atmospheric pressure) and the inside of the mass spectrometer (at 10^-7 Torr of pressure). It consists of the sampling cone, the isolation valve, and the ion block. The source temperature setting affects sensitivity.",
			Category -> "Column Flush"
		},
		ColumnFlushDeclusteringVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage between the sample inlet on the mass spectrometry and the first stage of the ion filter.",
			Category -> "Column Flush"
		},
		ColumnFlushConeGasFlow -> {
			Format -> Single,
			(* L/Hour for ESI-QTOF, PSI for ESI-QQQ *)
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[(0*Liter)/Hour], GreaterP[0 PSI]],
			Units -> None,
			Description -> "The rate of nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate on the source block, acting as a first gate between the sprayer and the reduced-pressure ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directs the spray into the ion block while keeping the sample cone clean.",
			Category -> "Column Flush"
		},
		ColumnFlushStepwaveVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "The applied voltage between the two stages of the ion filter.",
			Category -> "Column Flush"
		},
		ColumnFlushIonGuideVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> UnitsP[0Volt],
			Units -> Volt,
			Description -> "The absolute voltage applied to the tip of the stainless steel ESI (electrospray ionization) capillary tubing in order to produce charged droplets. This option is diagrammed as IonSprayVoltage for ESI-QQQ.",
			Category -> "Blank"
		},
		ColumnFlushAcquisitionWindows -> {
			Format -> Multiple,
			Class -> {
				StartTime->Real,
				EndTime->Real
			},
			Pattern :> {
				StartTime->GreaterEqualP[0*Second],
				EndTime->GreaterEqualP[0*Second]
			},
			Units -> {
				StartTime->Minute,
				EndTime->Minute
			},
			Description -> "The time blocks to acquire measurement for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushAcquisitionModes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MSAcquisitionModeP,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the manner of scanning and/or fragmenting intact and resultant ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFragmentations -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnFlushAcquisitionWindows, indicates whether the intact ions collide with inert gas to dissociate into product ions. Also known as Tandem mass spectrometry or MS/MS.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) intact ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the duration of time allowed to pass between each spectral acquisition.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFragmentMinMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the lowest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFragmentMaxMasses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the highest measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFragmentMassSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[(0*Gram)/Mole]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, all of the measured or selected mass-to-charge ratio (m/z) dissociation product ions.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> ListableP[(UnitsP[0Volt])],
			Units -> Volt,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the applied potential that accelerates ions into an inert gas for induced dissociation.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFinalLowCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnFlushAcquisitionWindows, at the end of the spectral scan, the lowest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFinalHighCollisionEnergies -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Volt],
			Units -> Volt,
			Description -> "For each member of ColumnFlushAcquisitionWindows, at the end of the spectral scan, the highest value of the linear function for applied potential as mapped to the MinMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushDwellTimes->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {({GreaterP[0*Millisecond]..}|GreaterP[0*Millisecond]|Null)..},
			Description->"For each member of ColumnFlushAcquisitionWindows, if the sample will be scan in SelectedIonMonitoring mode or MultipleReactionMonitoring mode, the length of time for each mass selection or mass selection pairs.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushCollisionCellExitVoltages -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0 Volt],
			Units -> Volt,
			Description ->"For each member of ColumnFlushAcquisitionWindows, if the sample will be scanned in tandem mass spectrometry mode in ESI-QQQ, the value of the potential applied between collision cell and the second Quadrupole mass analyzer (MS2) to guide and focus the ion beam into MS2.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMassDetectionStepSizes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of ColumnFlushAcquisitionWindows, the mass-to-charge value at which the mass spectrometer will record a data of the mass scan.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMultipleReactionMonitoringAssays->{
			Format->Multiple,
			Description ->"For each member of ColumnFlushAcquisitionWindows, if using ESI-QQQ as the mass spectrometry, that firstly targets the ion corresponding to the compound of interest with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and dwell time (length of time of each scan).",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Class->Expression,
			Pattern :> {(<|
				MS1Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				CollisionEnergy-> {UnitsP[0Volt]..}|Null,
				MS2Mass->{GreaterP[(0*Gram)/Mole]..}|Null,
				DwellTime->{GreaterP[0*Millisecond]..}|Null
			|>|{Null})..},
			Category -> "Column Flush"
		},
		ColumnFlushNeutralLosses -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Mole],
			Units -> Gram/Mole,
			Description ->"For each member of ColumnFlushAcquisitionWindows, if the sample will be scanned in NeutralIonLoss mode, the value for the mass offset values between MS1 and MS2 (neutral ion loss value.).",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushFragmentScanTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the duration of time allowed to pass between each spectral acquisition for the product ions when ColumnFlushAcquisitionMode -> DataDependent.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushAcquisitionSurveys -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnFlushAcquisitionWindows, indicates the number of intact ions to consider for fragmentation and acquisition in DataDependent acquistion mode.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushMinimumThresholds -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the least number of total intact ions needed to be measured to elicit an acquisition program.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushAcquisitionLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the maximum number of measured ions allowed during a fragmentation measurement of a survey ion. Will proceed to the next intact ion/fragmentation once reached.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushCycleTimeLimits -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the maximum duration allowable for a survey. Will proceed to the next cycle once reached.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushExclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the time blocks within to consider for specific mass exclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushExclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {{ExclusionModeP,GreaterP[(0*Gram)/Mole]}..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, indicates the manner of omitting intact ions for acquisition survey.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushExclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range above and below each ion in ExclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushExclusionRetentionTimeTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range above and below each retention time in ExclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionDomains -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{UnitsP[Minute],UnitsP[Minute]}..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the time blocks within to consider for specific mass inclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionMasses -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				{
					InclusionModeP,
					GreaterP[(0*Gram)/Mole]
				}..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the intact ions to prioritize during survey acquisition.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionCollisionEnergies-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0Volt]..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the overriding collision energy to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionDeclusteringVoltages-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0Volt]..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the overriding source voltage to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionChargeStates-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0,1]..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the charge state isotopes to also consider for inclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionScanTimes-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {
				GreaterEqualP[0*Second]..
			},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the overriding scan time to use for the corresponding InclusionMass.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushInclusionMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range above and below each ion in InclusionMassSelection to consider for omission.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushChargeStateLimits -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the number of ions to survey before excluding for ion state properties.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushChargeStateSelections -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterEqualP[1,1]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushChargeStateMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushIsotopeMassDifferences -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0 Dalton]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the delta between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushIsotopeRatios -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the minimum relative magnitude between monoisotopic ions as a criterion for survey exclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushIsotopeDetectionMinimums -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {GreaterP[0*1/Second]..},
			Description -> "For each member of ColumnFlushAcquisitionWindows, the acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushIsotopeRatioTolerances-> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range of relative magnitude around IsotopeRatio and SecondaryIsotopeRatio to consider for isotope exclusion.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushIsotopeMassTolerances -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Dalton],
			Units -> Dalton,
			Description -> "For each member of ColumnFlushAcquisitionWindows, the range of m/z to consider for exclusion by ionic state property.",
			IndexMatching -> ColumnFlushAcquisitionWindows,
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceSelection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {GreaterP[0*Centimeter]..},
			Description -> "All the wavelengths of light absorbed in the detector's flow cell for a PhotoDiodeArray (PDA) detector for each column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushMinAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Flush"
		},
		ColumnFlushMaxAbsorbanceWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The maximum wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Flush"
		},
		ColumnFlushWavelengthResolution -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "The increment in wavelength of light absorbed in the detector's flow cell for a PDA detector.",
			Category -> "Column Flush"
		},
		ColumnFlushUVFilter -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates whether or not to block UV wavelengths (less than 210 nm) from being transmitted through the sample for PDA detector.",
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceSamplingRate -> {
			Format->Single,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "Indicates the frequency of measurement for UVVis or PDA detectors.",
			Category -> "Column Flush"
		},

		(* --- Experimental Results --- *)
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
			Description -> "For each member of Standards, the chromatography traces generated for the standard's injection.",
			IndexMatching -> Standards,
			Category -> "Experimental Results"
		},
		BlankData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of Blanks, the chromatography traces generated for the blank's injection.",
			IndexMatching -> Blanks,
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
		CalibrationData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Mass spectra of calibrants used in this protocol.",
			Category -> "Experimental Results"
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

		(*--- Final Buffer state ---*)

		FinalBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately after the experiment was completed.",
			Category -> "Gradient"
		},

		FinalBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferA taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferB taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferC taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},
		FinalBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of BufferD taken immediately after the experiment was completed.",
			Category -> "Gradient"
		},

		(*--- SystemFlush ---*)

		SystemFlushBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel A used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel B used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel C used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent through channel D used to clean the instrument and lines after column removal.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system flush buffers needed to run the flush protocol onto the instrument buffer deck.",
			Category -> "Cleaning",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		SystemFlushInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the flush file into the instrument software after removing the column.",
			Category -> "Cleaning",
			Developer -> True
		},

		InitialSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferA immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferB immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferC immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferD immediately before the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},

		InitialSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushBufferA taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushBufferB taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushBufferC taken immediately before flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		InitialSystemFlushBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the SystemFlushBufferD taken immediately before flushing the instrument.",
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
		SystemFlushMassAcquisitionMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The operation of the mass analyzer during final cleaning.",
			Category -> "Cleaning",
			Developer -> True
		},
		SystemFlushExportScriptLocation -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system flush methods to the instrument computer.",
			Category -> "Cleaning",
			Developer -> True
		},

		FinalSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferA immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferB immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferC immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferD immediately after the flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushBufferA taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushBufferB taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushBufferC taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		FinalSystemFlushBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of SystemFlushBufferD taken immediately after flushing the instrument.",
			Category -> "Cleaning",
			Developer -> True
		},
		SampleQueueFileNames-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each injection the InjectionTable, the full method name of the sample queue used to execute the acquisition of the samples via direct infusion.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SampleQueueFilePaths-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each injection the InjectionTable, the full file path of the sample queue used to execute the acquisition of the samples via direct infusion (ESI-QQQ and ESI-QTOF) and flow injection (ESI-QQQ).",
			Category -> "Experimental Results",
			Developer -> True
		},
		AbsorbanceFilePaths-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For every injection in the InjectionTable and system prime and flush, the full file path used to save the absorbance data acquired by Analyst software.",
			Category -> "Experimental Results",
			Developer -> True
		},
		FlowInjectionBatchMethodFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For ESI-QQQ in using flow injection method, the path for a separate batch method file containing information for batch sample submission.",
			Category -> "Experimental Results",
			Developer -> True
		},
		CalibrantMethodImportPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The full file path of the batch file used transfer the JSON to the instrument acquisition method file (DAM) file for the calibration, this is a used only for ESI-QQQ for now.",
			Category -> "General",
			Developer -> True
		},
		UserCalibrantPasteTable -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The table of information that should be pasted to the Analyst software when using user-specified calibrants. This allows the instrument to be tuned.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		UserCalibrantPasteList -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The table of Mass Velues that should be pasted to the Analyst software when using user-specified calibrants. This allows the instrument to be tuned.",
			Category -> "Mass Analysis",
			Developer -> True
		},
		ImageFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs and screenshots obtained during the execution of procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		NitrogenPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "A measurement of nitrogen gas pressure used for branching troubleshooting procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		ArgonPressure -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "A measurement of argon gas pressure used for branching troubleshooting procedures.",
			Category -> "Operations Information",
			Developer -> True
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, MassSpectrometer], Object[Instrument, MassSpectrometer]],
			Description -> "A field used to support cross-compatibility of LCMS and MassSpectrometry procedures. The field should link to the same mass spectrometer as the MassSpectrometryInstrument field.",
			Category -> "Operations Information",
			Developer -> True
		}
	}
}];
