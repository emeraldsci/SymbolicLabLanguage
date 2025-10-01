(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, HPLC], {
	Description->"A protocol describing the separation of samples using High Performance Liquid Chromatography (HPLC).",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Instrument Information ---*)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, HPLC],
				Object[Instrument, HPLC]
			],
			Description -> "The device containing a pump, column oven, detector(s), and possible fraction collector that executes this experiment.",
			Category -> "General"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PurificationScaleP,
			Description -> "Indicates if the HPLC is intended to separate sample (Preparative or SemiPreparative) and therefore collect fractions and/or analyze properties of the sample (Analytical). Preparative stands for large separations on Agilent 1290 Infinity II while SemiPrepartive stands for separation on Dionex instruments.",
			Category -> "General",
			Abstract -> True
		},
		SeparationMode -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SeparationModeP,
			Description -> "The type of chromatographic separation that categorizes the mobile and stationary phase used, ideally for optimal sample separation and resolution.",
			Category -> "Separation",
			Abstract -> True
		},
		Detectors -> { (* Make PDA and UVVis non-exchangeable *)
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ChromatographyDetectorTypeP,
			Description -> "The types of measurment devices on the instrument downstream of the column that are used to measure a physical properties of the sample in the flow.",
			Category -> "Detection",
			Abstract -> True
		},
		IncubateColumn -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description->"Indicates if the columns are placed inside the column oven compartment of the HPLC instrument during the experiment.",
			Category -> "Column Installation"
		},
		InjectionTableFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name for the file containing the order of samples to run for the Instrument software.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		InjectionTableFileDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The directory to which the file containing the order of samples to run for the instrument is stored.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		ImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The digital location of compiled file that is imported as protocol into the instrument software.",
			Category -> "General",
			Developer -> True
		},
		ImportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The directory to which all import files are written. Import files contain protocol information needed by the instrument.",
			Category -> "General",
			Developer -> True
		},
		SeparationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Minute,
			Description -> "The estimated time that the protocol will take to complete.", (* Migrate and SyncType *)
			Category -> "Separation",
			Developer -> True
		},
		(* --- Cleaning --- *)
		PurgeSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "The syringe used to pull air and buffer from the buffer lines to clear them of air bubbles.",
			Category -> "Prime System"
		},
		PurgeWasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Vessel],
				Model[Container,Vessel]
			],
			Description -> "The container used to hold waste from air bubble removal procedures for buffer lines. It is also used to hold waste from rinsing plumbing connections.",
			Category -> "Prime System"
		},
		TubingRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to rinse buffers lines before and after and the experiment.",
			Category -> "Prime System"
		},
		NeedleWashSolution ->  { 
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to wash the injection needle and pumps before, during, and after the experiment.",
			Category -> "Prime System",
			Abstract -> True
		},
		NeedleWashPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing the NeedleWashSolution needed to wash the injection needle.",
			Category -> "Prime System",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		CapWashAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Plumbing],
				Model[Plumbing]
			],
			Description -> "Buffer cap plumbing adapter used to clean the tubing interior of used buffer caps.",
			Category -> "Prime System"
		},

		(*--- System Prime Information ---*)

		SystemPrimeBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer A line at the start of the protocol before column installation.",
			Category -> "Prime System"
		},
		SystemPrimeBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer B line at the start of the protocol before column installation.",
			Category -> "Prime System"
		},
		SystemPrimeBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer C line at the start of the protocol before column installation.",
			Category -> "Prime System"
		},
		SystemPrimeBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent used to purge the buffer D line at the start of the protocol before column installation.",
			Category -> "Prime System"
		},
		SystemPrimeBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "A list of deck placements used for placing system prime buffers needed to run the prime protocol onto the instrument buffer deck.",
			Category -> "Prime System",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferA immediately before the priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferB immediately before the priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferC immediately before the priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of SystemPrimeBufferD immediately before the priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},

		InitialSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of SystemPrimeBufferA taken immediately before priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of SystemPrimeBufferB taken immediately before priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of SystemPrimeBufferC taken immediately before priming the instrument as read from integrated volume sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		InitialSystemPrimeBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of SystemPrimeBufferD taken immediately before priming the instrument as taken by the integrated camera.",
			Category -> "Prime System",
			Developer -> True
		},

		SystemPrimeGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The solvent composition over time for the system prime.",
			Category -> "Prime System"
		},

		FinalSystemPrimeBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferA immediately after the system prime as read by the integrated sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferB immediately after the system prime as read by the integrated sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferC immediately after the system prime as read by the integrated sensor.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemPrimeBufferD immediately after the system prime as read by the integrated sensor.",
			Category -> "Prime System",
			Developer -> True
		},

		FinalSystemPrimeBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemPrimeBufferA taken immediately after priming the instrument as taken by the integrated camera.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemPrimeBufferB taken immediately after priming the instrument as taken by the integrated camera.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemPrimeBufferC taken immediately after priming the instrument as taken by the integrated camera.",
			Category -> "Prime System",
			Developer -> True
		},
		FinalSystemPrimeBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemPrimeBufferD taken immediately after priming the instrument as taken by the integrated camera.",
			Category -> "Prime System",
			Developer -> True
		},
		SystemPrimeImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that can import the protocol into the software for the system prime.",
			Category -> "Prime System",
			Developer -> True
		},
		SystemPrimeExportScriptFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system prime raw data to the server.",
			Category -> "Prime System",
			Developer -> True
		},
		SystemPrimeArchiveScriptFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data to the public drive and archives the data from virtual computer after system prime data export.",
			Category -> "Prime System",
			Developer -> True
		},
		SystemPrimeInjectionTableFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the file containaining the injection table to be used by the instrument software during the system prime step.",
			Category -> "Prime System",
			Developer -> True
		},
		SystemPrimeInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the file used to load the prime injection table into the instrument software prior to installation of the column.",
			Category -> "Prime System",
			Developer -> True
		},

		(*--- Column Information ---*)
		ColumnSelector->{
			Format->Single,
			Class->Boolean,
			Pattern:> BooleanP,
			Description -> "To indicate whether to use different column for each sample from the columns that are installed on the Instrument's column selector and can be switched from within the software .",
			Category -> "General"
		},
		Column -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "When ColumnSelector is not in use, indicate the stationary phase through which the mobile phase including Buffers and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the Buffers, samples, column material, and column temperature.",
			Category -> "Column Installation",
			Abstract -> True
		},
		SecondaryColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For a batch of SamplesIn, the second stationary phase device through which the Buffers and input samples flow.",
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
			Description -> "For a batch of SamplesIn, the third stationary phase device through which the Buffers and input samples flow.",
			Category -> "Column Installation"
		},
		ColumnAssemblyConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {Object[Plumbing]|Object[Item,Column],Null,Object[Plumbing]|Object[Item,Column],Null},
			Description -> "The list of connections for assembling the components of a Column before placing into the Instrument's column compartment.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnSelectorAssembly -> {
			Format -> Multiple,
			Class -> {
				ColumnPosition -> Expression,
				GuardColumn -> Link,
				GuardColumnOrientation -> Expression,
				GuardColumnJoin -> Link,
				Column -> Link,
				ColumnOrientation -> Expression,
				ColumnJoin -> Link,
				SecondaryColumn -> Link,
				SecondaryColumnJoin -> Link,
				TertiaryColumn -> Link
			},
			Pattern :> {
				ColumnPosition -> ColumnPositionP,
				GuardColumn -> _Link,
				GuardColumnOrientation -> ColumnOrientationP,
				GuardColumnJoin -> _Link,
				Column -> _Link,
				ColumnOrientation -> ColumnOrientationP,
				ColumnJoin -> _Link,
				SecondaryColumn -> _Link,
				SecondaryColumnJoin -> _Link,
				TertiaryColumn -> _Link
			},
			Relation -> {
				ColumnPosition -> Null,
				GuardColumn -> Object[Item,Column]|Model[Item,Column],
				GuardColumnOrientation -> Null,
				GuardColumnJoin -> Object[Plumbing,ColumnJoin]|Model[Plumbing,ColumnJoin],
				Column -> Object[Item,Column]|Model[Item,Column],
				ColumnOrientation -> Null,
				ColumnJoin -> Object[Plumbing,ColumnJoin]|Model[Plumbing,ColumnJoin],
				SecondaryColumn -> Object[Item,Column]|Model[Item,Column],
				SecondaryColumnJoin -> Object[Plumbing,ColumnJoin]|Model[Plumbing,ColumnJoin],
				TertiaryColumn -> Object[Item,Column]|Model[Item,Column]
			},
			Description -> "For a particular column setup, the plumbing connection of all stationary phase devices used for analyte separation, including guard columns and column joins.",
			Headers -> {
				ColumnPosition -> "Column Position",
				GuardColumn -> "Guard Column",
				GuardColumnOrientation -> "Guard Column Orientation",
				GuardColumnJoin -> "Guard Column Join",
				Column -> "Column",
				ColumnOrientation -> "Column Orientation",
				ColumnJoin -> "Column Join",
				SecondaryColumn -> "Secondary Column",
				SecondaryColumnJoin -> "Secondary Column Join",
				TertiaryColumn -> "Tertiary Column"
			},
			Category -> "Column Installation"
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
			Relation -> {Object[Plumbing],Null,Object[Item,Column],Null},
			Description -> "The connection information for attaching columns joins to the flow path coming from the sample manager.",
			Headers -> {"Instrument Column Connector","Column Connector Name","Column","Column End"},
			Category -> "Column Installation",
			Developer -> True
		},
		ColumnJoinStorage -> {
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
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"The direction of the Column, SecondaryColumn and TertiaryColumn for the protocol with respect to the flow. Usually reverse orientation is used to clean the column to get rid of impurities.",
			Category->"Column Installation"
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
			Category -> "Column Installation"
		},
		ColumnAssembly -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {Object[Item,Column]|Object[Plumbing,ColumnJoin], Object[Item,Column]|Object[Plumbing,ColumnJoin]},
			Description -> "A list of column and join connections listed in the order that they should be used to construct a column setup on the selected instrument.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Upstream", "Downstream"}
		},
		GuardCartridge -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For a particular guard column, the module that holds the adsorbent within the GuardColumn.",
			Category -> "Column Installation"
		},
		GuardColumn -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For a particular column, the protective device placed in the flow path before the Column in order to adsorb fouling contaminants and, thus, preserve the Column lifetime. If GuardColumnOrientation is Reverse, the GuardColumn is placed after Columns in the flow path.",
			Category -> "Column Installation",
			Abstract -> True
		},
		GuardColumnOrientation -> {
			Format->Single,
			Class->Expression,
			Pattern :>ColumnOrientationP,
			Description->"For a particular column setup, the placement of the GuardColumn for the protocol. If a Column is used and GuardColumnOrientation is Reverse, then the GuardColumn is placed after the column relative to the direction of the flow path.",
			Category->"Column Installation"
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
		ColumnHolders -> {
			Format -> Single,
			Class -> {Link,Link,Link},
			Pattern :> {_Link,_Link,_Link},
			Relation -> {Model[Item,ColumnHolder]|Object[Item,ColumnHolder],Model[Item,ColumnHolder]|Object[Item,ColumnHolder],Model[Item,ColumnHolder]|Object[Item,ColumnHolder]},
			Description -> "The column holders used to hook the columns during the HPLC run when they are placed outside the column oven compartment of the instrument.",
			Category->"Column Installation",
			Developer -> True,
			Headers -> {"Column Holder 1","Column Holder 2","Column Holder 3"}
		},
		ColumnTighteningWrench -> {
			Format -> Single,
			Class -> {Link,Link},
			Pattern :> {_Link,_Link},
			Relation -> {Model[Item,Wrench]|Object[Item,Wrench],Model[Item,Wrench]|Object[Item,Wrench]},
			Description -> "The wrenches used to untighten and tighten the Guard Column to install Guard Cartridges. The two wrenches are used in tandem, one to hold and the other one to turn.",
			Category->"Column Installation",
			Developer -> True,
			Headers -> {"Column Tightening Wrench 1","Column Tightening Wrench 2"}
		},
		ColumnAssemblyWrenches -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Model[Item, Wrench], Object[Item, Wrench]],
				Alternatives[Model[Item, Wrench], Object[Item, Wrench]]
			},
			Description -> "For each member of ColumnAssemblyConnections, a wrench to connect a column, join, or fitting in series with another column component.  A wrench in the first index should be compatible with the object in the first index of the ColumnAssemblyConnections field. A wrench in the second index should be compatible with the object in the third index of the ColumnAssemblyConnections field. Null indicates that fingers should be used.",
			Category->"Column Installation",
			Developer -> True,
			Headers -> {"Connector 1 Wrench", "Connector 2 Wrench"}
		},
		ColumnConnectionWrenches -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Model[Item, Wrench], Object[Item, Wrench]],
				Alternatives[Model[Item, Wrench], Object[Item, Wrench]]
			},
			Description -> "For each member of ColumnConnections, a wrench to connect a column, join, or fitting in series with the instrument. A wrench in the first index should be compatible with the object in the first index of the ColumnConnections field. A wrench in the second index should be compatible with the object in the third index of the ColumnConnections field. Null indicates that fingers should be used.",
			Category->"Column Installation",
			Developer -> True,
			Headers -> {"Connector 1 Wrench", "Connector 2 Wrench"}
		},
		LeakTestFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of  the file used to test the connections for leaks after the column has been installed and before starting the column prime.",
			Category -> "Column Installation",
			Developer -> True
		},
		LeakTestInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the file used to load the files which contians a sequence of samples into the instrument software after the column has been installed and before starting the column prime to test the connections for leaks.",
			Category -> "Column Installation",
			Developer -> True
		},

		(*--- Buffer information ---*)

		BufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent in Buffer A bottle and pumped through the instrument as mobile phase by itself or in combination with Buffer B, Buffer C and Buffer D. Some instrument models only have Buffer A and Buffer B.",
			Category -> "Separation",
			Abstract -> True
		},
		BufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent in Buffer B bottle and pumped through the instrument by itself or in combination with other solvent.",
			Category -> "Separation",
			Abstract -> True
		},
		BufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent in Buffer C bottle and pumped through the instrument by itself or in combination with other solvent.",
			Category -> "Separation",
			Abstract -> True
		},
		BufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent in Buffer D bottle and pumped through the instrument by itself or in combination with other solvent.",
			Category -> "Separation",
			Abstract -> True
		},
		BufferACap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The special caps that have a ultrasonic sensor Assembly to detect level of the solvent A before and after the protocol is run. These are quick connect caps with fixed length rigid tubing to maintain a contant dead volume.",
			Category -> "Prime System"
		},
		BufferBCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The special caps that have a ultrasonic sensor Assembly to detect level of the solvent B before and after the protocol is run. These are quick connect caps with fixed length rigid tubing to maintain a contant dead volume.",
			Category -> "Prime System"
		},
		BufferCCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The special caps that have a ultrasonic sensor Assembly to detect level of the solvent C before and after the protocol is run. These are quick connect caps with fixed length rigid tubing to maintain a contant dead volume.",
			Category -> "Prime System"
		},
		BufferDCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item,Cap],Model[Item,Cap]],
			Description -> "The special caps that have a ultrasonic sensor Assembly to detect level of the solvent D before and after the protocol is run. These are quick connect caps with fixed length rigid tubing to maintain a contant dead volume.",
			Category -> "Prime System"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container],Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "Prime System",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},

		InitialBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA after column prime and immediately before the sample injection is started as measured by the integrated ultrasonic liquid level detection sensor.",
			Category -> "Prime System"
		},
		InitialBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately before the experiment is started as measured by the integrated sensor.",
			Category -> "Prime System"
		},
		InitialBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately before the experiment is started as measured by the integrated sensor.",
			Category -> "Prime System"
		},
		InitialBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately before the experiment is started as measured by the integrated sensor.",
			Category -> "Prime System"
		},

		InitialBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The side on image of BufferA bottle taken immediately before the experiment is started as taken by the integrated camera.",
			Category -> "Prime System"
		},
		InitialBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The side on image of BufferB taken immediately before the experiment is started as taken by the integrated camera.",
			Category -> "Prime System"
		},
		InitialBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The side on image of BufferC taken immediately before the experiment is started as taken by the integrated camera.",
			Category -> "Prime System"
		},
		InitialBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The side on image of BufferD taken immediately before the experiment is started as taken by the integrated camera.",
			Category -> "Prime System"
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
		MaxAcceleration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute / Minute],
			Units -> (Liter Milli) / Minute / Minute,
			Description -> "The maximum rate at which it is safe to increase the flow rate for the column and instrument during the run. The instrument does not support higher values than what is specified here.",
			Category -> "Instrument Setup"
		},

		(*--Injection sequence--*)

		InjectionTable->{
			Format->Multiple,
			Class->{
				Type->Expression,
				Sample->Link,
				InjectionVolume->Real,
				ColumnPosition -> Expression,
				ColumnTemperature->Real,
				Gradient->Link,
				DilutionFactor->Real,
				Data->Link
			},
			Pattern:>{
				Type->InjectionTableP,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				InjectionVolume->GreaterEqualP[0*Micro*Liter],
				ColumnPosition -> ColumnPositionP,
				ColumnTemperature->GreaterP[0*Celsius],
				Gradient->ObjectP[Object[Method]],
				DilutionFactor->GreaterP[0],
				Data->_Link
			},
			Relation->{
				Type->Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				InjectionVolume->Null,
				ColumnPosition->Null,
				ColumnTemperature->Null,
				Gradient->Object[Method],
				DilutionFactor->Null,
				Data->Object[Data]
			},
			Units->{
				Type->Null,
				Sample->None,
				InjectionVolume->Micro Liter,
				ColumnPosition->Null,
				ColumnTemperature->Celsius,
				Gradient->None,
				DilutionFactor->None,
				Data->None
			},
			Description -> "The sequence of samples injected for a given experiment run, including the ColumnPrime, SamplesIn, Standards, Blanks, and ColumnFlush.",
			Category -> "General"
		},
		ExperimentMethodsFilePaths->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location where the files containing the protocol infromation used to execute the HPLC runs are stored.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		DetectorMethodFilePath->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location where method files to be imported in ASTRA software to execute the Multi-Angle Light Scattering (MALS), Dynamic Light Scattering (DLS) and Refractive Index (RI) detections are stored.",
			Category -> "Detection",
			Developer -> True
		},
		InternalDetectorMethodFilePath->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location where method files stored in ASTRA method builder database to execute the Multi-Angle Light Scattering (MALS), Dynamic Light Scattering (DLS) and Refractive Index (RI) detections are stored.",
			Category -> "Detection",
			Developer -> True
		},
		DetectionMethodWorklist->{
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The sequence containing sample information to be imported in ASTRA software to control the method profile.",
			Category -> "Detection",
			Developer -> True
		},
		DetectionMethodWorklistLength->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "The number of samples in DetectionMethodWorklist.",
			Category -> "Detection",
			Developer -> True
		},
		WorklistFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location where compiled file describing the protocol imported onto the system is stored.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		ExperimentInjectionTableFilePath ->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location where the file used to load the sequence of samples for experiment HPLC runs into the instrument software is stored.",
			Category -> "Instrument Setup",
			Developer -> True
		},

		(*---ColumnPrime---*)

		ColumnPrimeGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of ColumnSelectorAssembly, the composition of the buffers within the flow, defined for specific time points during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature of the column compartment for each column prime run.",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientAs -> {
			Format -> Multiple,
			Class -> Expression, 
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientAs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferA in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientBs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientBs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferB in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientCs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientCs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferC in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeGradientDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeIsocraticGradientDs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferD in the mobile phase composition over time during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For each member of ColumnSelectorAssembly, the total rate of mobile phase pumped through the instrument for each column prime. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Prime"
		},
		ColumnPrimeFlowRateConstant ->{
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelectorAssembly, the constant rate of mobile phase pumped through the instrument for each column prime. Compositions of Buffers in the flow adds up to 100%.",
			Units -> (Milli * Liter) / Minute,
			Category -> "Column Prime"
		},
		ColumnPrimeAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the wavelength of light absorbed in the detector's flow cell for UVVis detectors during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the minimum wavelength of light absorbed in the detector's flow cell for the Photo Diode Array (PDA) detector during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the maximum wavelength of light absorbed in the detector's flow cell for the Photo Diode Array (PDA) detector during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the increment in wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeUVFilters -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, indicates if UV wavelengths (less than 210 nm) is blocked from being transmitted through the sample for Absorbance detectors (UVVis or PhotoDiodeArray) during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeAbsorbanceSamplingRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelectorAssembly, the frequency of measurement for UVVis or Photo Diode Array (PDA) detectors during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeSmoothingTimeConstants -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of ColumnSelectorAssembly during the equilibration of the Columns (column prime), the time window used for data filtering with UVVis or Photo Diode Array (PDA) detectors, which controls the degree of baseline smoothing and the impact on peak height degradation.",
			Category -> "Column Prime"
		},
		ColumnPrimeExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 1st of upto 4 monochromator/filter wavelengths used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeSecondaryExcitationWavelengths -> { 
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 2nd or upto 4 monochromator/filter wavelengths used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeTertiaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 3rd of upto 4 monochromator/filter wavelengths used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeQuaternaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 4th of upto 4 monochromator/filter wavelengths used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 1st of upto 4 monochromator/filter wavelengths used to filter emitted light in the fluorescence flow cell during column prime before it is measured in the Fluorescence detector.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeSecondaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 2nd of upto 4 monochromator/filter wavelengths used to filter emitted light in the fluorescence flow cell during column prime before it is measured in the Fluorescence detector.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeTertiaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 3rd of upto 4 monochromator/filter wavelengths used to filter emitted light in the fluorescence flow cell during column prime before it is measured in the Fluorescence detector.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeQuaternaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 4th of upto 4 monochromator/filter wavelengths used to filter emitted light in the fluorescence flow cell during column prime before it is measured in the Fluorescence detector.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeEmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Nanometer],
			Units -> Nanometer,
			Description ->"For each member of ColumnSelectorAssembly, the cut-off wavelength(s) to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percentage of maximum amplification of ColumnPrimeExcitationWavelengths/ColumnPrimeEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			
			Category -> "Column Prime"
		},
		ColumnPrimeSecondaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the signal amplification of ColumnPrimeSecondaryExcitationWavelengths/ColumnPrimeSecondaryEmissionWavelengths channel during column prime on the Fluorescence detector. It is a unitless factor from 0 to 1000 used by the instrument to modulate the voltage to the Photomultiplier Tube.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeTertiaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the signal amplification of ColumnPrimeTertiaryExcitationWavelengths/ColumnPrimeTertiaryEmissionWavelengths channel during column prime on the Fluorescence detector. It is a unitless factor from 0 to 1000 used by the instrument to modulate the voltage to the Photomultiplier Tube.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeQuaternaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the signal amplification of ColumnPrimeQuaternaryExcitationWavelengths/ColumnPrimeQuaternaryEmissionWavelengths channel during column prime on the Fluorescence detector. It is a unitless factor from 0 to 1000 used by the instrument to modulate the voltage to the Photomultiplier Tube.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeFluorescenceFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the fluorescence flow cell chamber of the fluorescence detector during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeLightScatteringLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the laser power used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeLightScatteringFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell chamber during column prime.",
			
			Category -> "Column Prime"
		}, 
		ColumnPrimeRefractiveIndexMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "For each member of ColumnSelectorAssembly, the type of refractive index measurement for the refractive index (RI) detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeRefractiveIndexFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the refractive index flow cell chamber of the refractive index (RI) detector during column prime.",
			
			Category -> "Column Prime"
		},
		ColumnPrimeNebulizerGases -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, indicates if sheath gas is turned on for the Evaporative Light Scattering Detector (ELSD) during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeNebulizerGasPressures -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*PSI],
			Units->PSI,
			Description -> "For each member of ColumnSelectorAssembly, if NebulizerGas is True, the applied pressure to the sheath gas during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeNebulizerGasHeatings -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, if NebulizerGas is True, indicates if sheath gas is heated or not for the Evaporative Light Scattering Detector (ELSD) during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeNebulizerHeatingPowers -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the relative magnitude of the heating element used to heat the sheath gas during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeDriftTubeTemperatures -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the temperature of the chamber through which the sprayed analyte travels during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},
		ColumnPrimeELSDGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			Category -> "Column Prime"
		},
		ColumnPrimeELSDSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelectorAssembly, the number of times ELSD measurement is made per second by the detector on the instrument for the Evaporative Light Scattering Detector (ELSD) during the equilibration of the Columns (column prime).",
			Category -> "Column Prime"
		},

		(*--Autosampler information--*)

		AutosamplerLayoutFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the file used to load the system files describing the autosampler layout into the instrument software.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		AutosamplerLayoutImage->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image that imitates what the autosampler configuration on the instrument software to help the operators confirm the correct layout settings.",
			Category -> "Instrument Setup",
			Developer -> True
		},
		AutosamplerDeckPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "The list of placements intended for the sample containers to be placed on the instrument's autosampler deck.",
			Category -> "Instrument Setup",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		AutosamplerRackPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "The list of placements intended for the autosampler container rack on the instument.",
			Category -> "Instrument Setup",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},

		(* --- Sample Preparation--- *)

		SampleTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Kelvin],
			Units -> Celsius,
			Description -> "The nominal temperature of the chamber input samples are incubated in prior to injection into the column.",
			Category -> "Sample Preparation"
		},
		InjectionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume taken from the sample and injected into the column.",
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
		GradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of SamplesIn, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run such that total of Gradient A, B, C and D amounts to 100%.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		IsocraticGradientA -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferA in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		GradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of SamplesIn, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run such that total of Gradient A, B, C and D amounts to 100%.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		IsocraticGradientB -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferB in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		GradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of SamplesIn, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run such that total of Gradient A, B, C and D amounts to 100%.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		IsocraticGradientC -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferC in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		GradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of SamplesIn, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run such that total of Gradient A, B, C and D amounts to 100%.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		IsocraticGradientD -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the constant percentage of BufferD in the mobile phase composition over time.",
			IndexMatching -> SamplesIn,
			Category -> "Separation"
		},
		Gradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the buffer gradient used for purification.",
			IndexMatching -> SamplesIn,
			Category -> "Separation",
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

		(*Detector specific options*)

		AbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		MinAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		MaxAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the maximum wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		WavelengthResolution -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the increment in wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		UVFilter -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if UV wavelengths (less than 210 nm) is blocked from being transmitted through the sample for Absorbance detectors (UVVis or PhotoDiodeArray).",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		AbsorbanceSamplingRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of SamplesIn, the frequency of measurement for UVVis or Photo Diode Array (PDA) detectors.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		SmoothingTimeConstants -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, the time window used for data filtering with UVVis or Photo Diode Array (PDA) detectors, which controls the degree of baseline smoothing and the impact on peak height degradation.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the primary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the sample.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		SecondaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the secondary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the sample.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		TertiaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the v monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the sample.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		QuaternaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the quaternary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the sample.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		EmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the 1st of upto 4 monochromator/filter wavelength used to filter emitted light from the sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		SecondaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the 2nd of upto 4 monochromator/filter wavelength used to filter emitted light from the sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		TertiaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the 3rd of upto 4 monochromator/filter wavelength used to filter emitted light from the sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		QuaternaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of SamplesIn, the 4th of upto 4 monochromator/filter wavelength used to filter emitted light from the sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		EmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Nanometer],
			Units -> Nanometer,
			Description ->"For each member of SamplesIn, the cut-off wavelength(s) to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection.",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		FluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the percentage of maximum amplification of ExcitationWavelengths/EmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		SecondaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the percentage of maximum amplification of ExcitationWavelengths/EmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		TertiaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the percentage of maximum amplification of ExcitationWavelengths/EmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		QuaternaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the percentage of maximum amplification of ExcitationWavelengths/EmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->SamplesIn,
			Category -> "Detection"
		},
		FluorescenceFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the nominal temperature setting inside the fluorescence flow cell of the fluorescence detector during the fluorescence measurement of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		LightScatteringLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[10*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the laser power used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		LightScatteringFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell during the MALS and/or DLS measurement of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		RefractiveIndexMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "For each member of SamplesIn, the type of refractive index measurement of the Refractive Index (RI) Detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		RefractiveIndexFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the nominal temperature setting inside the refractive index flow cell of the refractive index (RI) detector during the refractive index measurement of the sample.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		pHCalibration -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if 2-point calibration of the pH probe is performed before the experiment starts.",
			Category -> "Calibration"
		},
		LowpHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The low pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The high pH reference buffer used to calibrate the pH probe in the 2-point calibration.",
			Category -> "Calibration"
		},
		LowpHCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The pH of the LowpHCalibrationBuffer that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Calibration"
		},
		HighpHCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>RangeP[0,14],
			Description->"The pH of the HighpHCalibrationBuffer that used to calibrate the pH probe in the 2-point calibration.",
			Units -> None,
			Category -> "Calibration"
		},
		pHTemperatureCompensation -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if the measured pH value is automatically corrected according to the temperature inside the pH flow cell.",
			Category -> "Calibration"
		},
		ConductivityCalibration -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if 1-point calibration of the conductivity probe is performed before the experiment starts.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Object[Sample],Model[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The buffer that is used to calibrate the conductivity probe in the 1-point calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationTarget->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0Milli*Siemens/Centimeter],
			Description->"The conductivity value of the ConductivityCalibrationBuffer used to calibrate the conductivity probe in the 1-point calibration.",
			Units -> Milli*Siemens/Centimeter,
			Category -> "Calibration"
		},
		ConductivityTemperatureCompensation -> {
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if the measured conductivity value is automatically corrected according to the temperature inside the conductivity flow cell.",
			Category -> "Calibration"
		},
		NebulizerGas -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of SamplesIn, indicates if sheath gas is turned on for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		NebulizerGasPressure -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[20*PSI,60*PSI,1*PSI],
			Units->PSI,
			Description -> "For each member of SamplesIn, if NebulizerGas is True, the applied pressure to the sheath gas.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		NebulizerGasHeating -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of SamplesIn, if NebulizerGas is True, indicates if sheath gas is heated or not for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		NebulizerHeatingPower -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the relative magnitude of the heating element used to heat the sheath gas.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		DriftTubeTemperature -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ELSDGain -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "For each member of SamplesIn, the percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},
		ELSDSamplingRate -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of SamplesIn, the frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurment.",
			IndexMatching -> SamplesIn,
			Category -> "Detection"
		},

		(* Syringes, Needles and other Accessories required to do pH/Conductivity Calibration *)
		LowpHCalibrationBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container,Syringe],Object[Container,Syringe]}],
			Relation -> Model[Container,Syringe]|Object[Container,Syringe],
			Description -> "The syringe used to load LowpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		LowpHCalibrationBufferSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item,Needle],Object[Item,Needle]}],
			Relation -> Model[Item,Needle]|Object[Item,Needle],
			Description -> "The needle used by the LowpHCalibrationBufferSyringe to load LowpHCalibrationBuffer into the pH into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		LowpHCalibrationBufferFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The speed at which the LowpHCalibrationBuffer is injected into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		LowpHCalibrationBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of the LowpHCalibrationBuffer injected into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container,Syringe],Object[Container,Syringe]}],
			Relation -> Model[Container,Syringe]|Object[Container,Syringe],
			Description -> "The syringe used to load HighpHCalibrationBuffer into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBufferSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item,Needle],Object[Item,Needle]}],
			Relation -> Model[Item,Needle]|Object[Item,Needle],
			Description -> "The needle used by the HighpHCalibrationBufferSyringe to load HighpHCalibrationBuffer into the pH into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBufferFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The speed at which the HighpHCalibrationBuffer is injected into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		HighpHCalibrationBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of the HighpHCalibrationBuffer injected into the instrument's pH detector's flow cell via syringe pump for pH calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBufferSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container,Syringe],Object[Container,Syringe]}],
			Relation -> Model[Container,Syringe]|Object[Container,Syringe],
			Description -> "The syringe used to load ConductivityCalibrationBuffer into the instrument's conductivity detector's flow cell via syringe pump for conductivity calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBufferSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item,Needle],Object[Item,Needle]}],
			Relation -> Model[Item,Needle]|Object[Item,Needle],
			Description -> "The needle used by the ConductivityCalibrationBufferSyringe to load ConductivityCalibrationBuffer into the instrument's conductivity detector's flow cell via syringe pump for conductivity calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBufferFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The speed at which the ConductivityCalibrationBuffer is injected into the instrument's conductivity detector's flow cell via syringe pump for conductivity calibration.",
			Category -> "Calibration"
		},
		ConductivityCalibrationBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of the ConductivityCalibrationBuffer injected into the instrument's conductivity detector's flow cell via syringe pump for conductivity calibration.",
			Category -> "Calibration"
		},
		CalibrationWashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Sample],Object[Sample]}],
			Relation->Object[Sample]|Model[Sample],
			Description->"The sample that is used to wash the pH and/or conductivity flow cell(s) of the instrument between using each different calibration buffer and at the end of calibration process.",
			Category -> "Calibration"
		},
		CalibrationWashSolutionSyringe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Container,Syringe],Object[Container,Syringe]}],
			Relation -> Model[Container,Syringe]|Object[Container,Syringe],
			Description -> "The syringe used to load CalibrationWashSolution into the instrument's pH and/or conductivity detector's flow cell(s) via syringe pump during the calibration process.",
			Category -> "Calibration"
		},
		CalibrationWashSolutionSyringeNeedle->{
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Model[Item,Needle],Object[Item,Needle]}],
			Relation -> Model[Item,Needle]|Object[Item,Needle],
			Description -> "The needle used by the CalibrationWashSolutionrSyringe to load CalibrationWashSolution into the instrument's pH and/or conductivity detector's flow cell(s) via syringe pump during the calibration process.",
			Category -> "Calibration"
		},
		CalibrationWashSolutionFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter/Minute],
			Units -> Milliliter/Minute,
			Description -> "The speed at which the CalibrationWashSolution is injected into the instrument's pH and/or conductivity detector's flow cell(s) via syringe pump during the calibration process.",
			Category -> "Calibration"
		},
		CalibrationWashSolutionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description ->"The volume of the CalibrationWashSolution injected into the instrument's pH and/or conductivity detector's flow cell(s) via syringe pump during the calibration process.",
			Category -> "Calibration"
		},
		CalibrationWasteContainer -> {
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Container, Vessel],Object[Container,Vessel]}],
			Relation->Model[Container, Vessel]|Object[Container,Vessel],
			Description->"The vessel used to collect the waste calibration buffers and wash solution during the calibration process.",
			Category -> "Calibration"
		},
		CalibrationSyringePump -> {
			Format->Single,
			Class->Link,
			Pattern:>ObjectP[{Model[Instrument,SyringePump],Object[Instrument,SyringePump]}],
			Relation->Model[Instrument,SyringePump]|Object[Instrument,SyringePump],
			Description->"The syringe pump used to inject the calibration buffers and wash solution into the pH and/or conductivity detector's flow cell(s) during the calibration process.",
			Category -> "Calibration"
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
			Description -> "The samples with known properties used to calibrate peak integrations and retention times for a given run.",
			Category -> "Standards"
		},
		StandardSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Standards, the volume taken from the standard and introduced into the sample which is then introduced into the flow.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Standards, the method that describes the time based compositions of different buffers in the flow which is used for separation.",
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
		StandardGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Standards, the percentage of BufferA in the mobile phase composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
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
		StandardGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Standards, the percentage of BufferB in the mobile phase composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
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
		StandardGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Standards, the percentage of BufferC in the mobile phase composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
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
		StandardGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Standards, the percentage of BufferD in the mobile phase composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
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
		StandardAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the wavelength of light passing through the detector's flow cell and monitored for UVVis detectors.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardMinAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the minimum wavelength of light passing through the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardMaxAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the maximum wavelength of light passing through the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardWavelengthResolution -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Standards, the increment in wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardUVFilter -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Standards, indicates if UV wavelengths (less than 210 nm) is blocked from being transmitted to the flow cell through the sample for Absorbance detectors (UVVis or PhotoDiodeArray).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardAbsorbanceSamplingRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Standards, the frequency of measurement for UVVis or Photo Diode Array (PDA) detectors.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardSmoothingTimeConstants -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of Standards, the time window used for data filtering with UVVis or Photo Diode Array (PDA) detectors, which controls the degree of baseline smoothing and the impact on peak height degradation.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 1st of up to 4 of monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the standard sample.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardSecondaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 2nd of up to 4 of monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the standard sample.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardTertiaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 3rd of up to 4 of monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the standard sample.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardQuaternaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 4th of upto 4 of monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the standard sample.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 1st of up to 4 of monochromator/filter wavelength used to filter emitted light from the standard sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardSecondaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 2nd of up to 4 of monochromator/filter wavelength used to filter emitted light from the standard sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardTertiaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 3rd of up to 4 monochromator/filter wavelength used to filter emitted light from the standard sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardQuaternaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Standards, the 4th of upto 4 monochromator/filter wavelength used to filter emitted light from the standard sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardEmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description ->"For each member of Standards, the cut-off wavelength(s) to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection.",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the percentage of maximum amplification of StandardExcitationWavelengths/StandardEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardSecondaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the percentage of maximum amplification of StandardExcitationWavelengths/StandardEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardTertiaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the percentage of maximum amplification of StandardExcitationWavelengths/StandardEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardQuaternaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the percentage of maximum amplification of StandardExcitationWavelengths/StandardEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Standards,
			Category -> "Standards"
		},
		StandardFluorescenceFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Standards, the nominal temperature setting inside the fluorescence flow cell chamber of the fluorescence detector during the fluorescence measurement of the standard sample.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardLightScatteringLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the laser power used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the standard sample.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardLightScatteringFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Standards, the nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell chamber during the MALS and/or DLS measurement of the standard sample.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardRefractiveIndexMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "For each member of Standards, the type of refractive index measurement of the Refractive Index (RI) Detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardRefractiveIndexFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Standards, the nominal temperature setting inside the refractive index flow cell chamber of the refractive index (RI) detector during the refractive index measurement of the standard sample.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardNebulizerGas -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Standards, indicates if sheath gas is turned on for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardNebulizerGasPressure -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 PSI],
			Units->PSI,
			Description -> "For each member of Standards, the applied pressure to the sheath gas to the nebulizer.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardNebulizerGasHeating -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Standards, if NebulizerGas is True, indicates if sheath gas is heated or not for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardNebulizerHeatingPower -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the relative magnitude of the heating element used to heat the sheath gas.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardDriftTubeTemperature -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of Standards, the set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardELSDGain -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Percent, 100 Percent],
			Units -> Percent,
			Description -> "For each member of Standards, the percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			IndexMatching -> Standards,
			Category -> "Standards"
		},
		StandardELSDSamplingRate -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Standards, the frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurment.",
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
			Description -> "The samples with known properties used to calibrate background signal.",
			Category -> "Blanks"
		},
		BlankSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "For each member of Blanks, the volume taken from the blank and injected onto the column.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of Blanks, the method that describes the gradient used for purification.",
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
		BlankGradientA -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Blanks, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
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
		BlankGradientB -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Blanks, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
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
		BlankGradientC -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Blanks, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
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
		BlankGradientD -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of Blanks, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for the entire run.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
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
		BlankAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the wavelength of light absorbed in the detector's flow cell for UVVis detectors.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankMinAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankMaxAbsorbanceWavelength -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the maximum wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankWavelengthResolution -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the increment in wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankUVFilter -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Blanks, indicates if UV wavelengths (less than 210 nm) is blocked from being transmitted through the sample for Absorbance detectors (UVVis or PhotoDiodeArray).",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankAbsorbanceSamplingRate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Blanks, the frequency of measurement for UVVis or Photo Diode Array (PDA) detectors.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankSmoothingTimeConstants -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of Blanks, the time window used for data filtering with UVVis or Photo Diode Array (PDA) detectors, which controls the degree of baseline smoothing and the impact on peak height degradation.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the primary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the blank sample.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankSecondaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the secondary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the blank sample.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankTertiaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the tertiary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the blank sample.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankQuaternaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the quaternary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds in the blank sample.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the 1st of upto 4 monochromator/filter wavelength used to filter emitted light from the blank sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankSecondaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the 2nd of upto 4 monochromator/filter wavelength used to filter emitted light from the blank sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankTertiaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the 3rd of upto 4 monochromator/filter wavelength used to filter emitted light from the blank sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankQuaternaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of Blanks, the 4th of upto 4 monochromator/filter wavelength used to filter emitted light from the blank sample inside the fluorescence flow cell before it is measured in the Fluorescence detector.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankEmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Nanometer],
			Units -> Nanometer,
			Description ->"For each member of Blanks, the cut-off wavelength(s) to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection.",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the percentage of maximum amplification of BlankExcitationWavelengths/BlankEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankSecondaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the percentage of maximum amplification of BlankExcitationWavelengths/BlankEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankTertiaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of Blanks, the percentage of maximum amplification of BlankExcitationWavelengths/BlankEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankQuaternaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the percentage of maximum amplification of BlankExcitationWavelengths/BlankEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			IndexMatching->Blanks,
			Category -> "Blanks"
		},
		BlankFluorescenceFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Blanks, the nominal temperature setting inside the fluorescence flow cell of the fluorescence detector during the fluorescence measurement of the blank sample.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankLightScatteringLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[10*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the laser power used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the blank sample.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankLightScatteringFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Blanks, the nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell during the MALS and/or DLS measurement of the blank sample.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankRefractiveIndexMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "For each member of Blanks, the type of refractive index measurement of the Refractive Index (RI) Detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankRefractiveIndexFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of Blanks, the nomial temperature setting inside the refractive index flow cell of the refractive index (RI) detector during the refractive index measurement of the blank sample.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankNebulizerGas -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Blanks, indicates if sheath gas is turned on for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankNebulizerGasPressure -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[20*PSI,60*PSI],
			Units->PSI,
			Description -> "For each member of Blanks, if NebulizerGas is True, the applied pressure to the sheath gas.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankNebulizerGasHeating -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of Blanks, if NebulizerGas is True, indicates if sheath gas is heated or not for the Evaporative Light Scattering Detector (ELSD).",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankNebulizerHeatingPower -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the relative magnitude of the heating element used to heat the sheath gas.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankDriftTubeTemperature -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of Blanks, the set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankELSDGain -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of Blanks, the percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlankELSDSamplingRate -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of Blanks, the frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurment.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},
		BlanksStorageConditions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleStorageTypeP|Disposal,
			Description -> "For each member of Blanks, the storage conditions under which the blank samples should be stored after the protocol is completed.",
			IndexMatching -> Blanks,
			Category -> "Blanks"
		},

		(* --- Fraction Collection --- *)

		FractionCollection -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if column effluent is collected and stored or let go to waste.",
			Category -> "Fraction Collection"
		},
		FractionCollectionDetector -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> HPLCFractionCollectionDetectorTypeP,
			Description -> "The type of measurement that is used as signal to trigger fraction collection.",
			Category -> "Fraction Collection"
		},
		FractionCollectionMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of SamplesIn, the collection parameters used for any samples that require fraction collection.",
			Category -> "Fraction Collection",
			Abstract -> True,
			IndexMatching -> SamplesIn
		},
		FractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers in which the mobile phase is collected downstream of the column during the protocol.",
			Category -> "Fraction Collection"
		},
		NumberOfFractionContainers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The count of fraction containers used in this protocol before new additional fraction containers are picked to replace the filled fraction containers.",
			Category -> "Fraction Collection",
			Developer -> True
		},
		FractionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {Object[Container],Object[Container],Null},
			Description -> "The list of fraction container placements.",
			Category -> "Fraction Collection",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		AwaitingFractionContainers -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the four fraction containers have been filled and another set of containers must be loaded thus during protocol check-in. This value is turned to False if fraction container replacement is successful.",
			Category -> "Fraction Collection",
			Developer -> True
		},
		FractionContainerReplacement -> {
			Format -> Multiple,
			Class -> {Link,Link,String},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {Object[Container],Object[Container],Null},
			Description -> "Indicates if the original four fraction containers have been filled and a second set of containers is loaded.",
			Category -> "Fraction Collection",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		ReplacementFractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "Additional fraction containers used to replace the original fraction containers after these have been filled.",
			Category -> "Fraction Collection",
			Developer -> True
		},
		CurrentFractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The fraction containers that are currently loaded on the instrument for collecting the fraction samples.",
			Category -> "Fraction Collection",
			Developer -> True
		},
		UnusedFractionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Fraction containers that did not collect samples during the protocol. Their status are verified by operators before they are officially discarded in the protocol.",
			Category -> "Fraction Collection",
			Developer -> True
		},
		CheckInFrequency->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"The amount of time between each check-in on the instrument while a protocol is in progress.",
			Category -> "General",
			Developer -> True
		},
		SamplesOutUltrasonicIncompatible->{
			Format -> Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the UltrasonicIncompatible field of the SamplesOut should be overwritten.",
			Category->"Fraction Collection"
		},

		(*--- Column Flush ---*)
		ColumnFlushGradients -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of ColumnSelectorAssembly, the method that describes the gradient used for during each column flush (when solvent is run through without injection).",
			Category -> "Column Flush"
		},
		ColumnFlushTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature of the column compartment for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientAs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferA in the composition over time, in the form: {Time, % Buffer A} or a single % Buffer A for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientAs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferA in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientBs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferB in the composition over time, in the form: {Time, % Buffer B} or a single % Buffer B for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientBs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferB in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientCs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferC in the composition over time, in the form: {Time, % Buffer C} or a single % Buffer C for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientCs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferC in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushGradientDs -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ({{GreaterEqualP[0 Minute],RangeP[0 Percent,100 Percent]}...}),
			Description -> "For each member of ColumnSelectorAssembly, the percentage of BufferD in the composition over time, in the form: {Time, % Buffer D} or a single % Buffer D for each column flush run.",
			Category -> "Column Flush"
		},
		ColumnFlushIsocraticGradientDs -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the constant percentage of BufferD in the mobile phase composition over time during the column flush step.",
			Category -> "Column Flush"
		},
		ColumnFlushFlowRateVariable -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}],
			Description -> "For each member of ColumnSelectorAssembly, the time dependent rate of mobile phase pumped through the instrument for each column flush. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Flush"
		},
		ColumnFlushFlowRateConstant -> {
			Format -> Multiple,
			Class -> Real,
			Units -> (Milli * Liter)/ Minute,
			Pattern :> GreaterEqualP[(0 * Milli * Liter) / Minute],
			Description -> "For each member of ColumnSelectorAssembly, the constant rate of mobile phase pumped through the instrument for each column flush. Compositions of Buffers in the flow adds up to 100%.",
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the wavelength of light absorbed in the detector's flow cell for UVVis detectors during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushMinAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushMaxAbsorbanceWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the maximum wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushWavelengthResolutions -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the increment in wavelength of light absorbed in the detector's flow cell for a Photo Diode Array (PDA) detector during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushUVFilters -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, indicates if UV wavelengths (less than 210 nm) is blocked from being transmitted through the sample for Absorbance detectors (UVVis or PhotoDiodeArray) during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushAbsorbanceSamplingRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelectorAssembly, the frequency of measurement for UVVis or Photo Diode Array (PDA) detectors during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushSmoothingTimeConstants -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "For each member of SamplesIn during column flush, the time window used for data filtering with UVVis or Photo Diode Array (PDA) detectors, which controls the degree of baseline smoothing and the impact on peak height degradation.",
			Category -> "Column Flush"
		},
		ColumnFlushExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the primary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushSecondaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the secondary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushTertiaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the tertiary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushQuaternaryExcitationWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the quaternary monochromator/filter wavelength used to filter the lamp light before it is passed into the fluorescence flow cell to excite fluorescent compounds during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 1st of upto 4 monochromator/filter wavelength used to filter emitted light from the fluorescence flow cell during column flush before it is measured in the Fluorescence detector.",
			Category -> "Column Flush"
		},
		ColumnFlushSecondaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 2nd of upto 4 monochromator/filter wavelength used to filter emitted light from the fluorescence flow cell during column flush before it is measured in the Fluorescence detector.",
			Category -> "Column Flush"
		},
		ColumnFlushTertiaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 3rd of upto 4 monochromator/filter wavelength used to filter emitted light from the fluorescence flow cell during column flush before it is measured in the Fluorescence detector.",
			Category -> "Column Flush"
		},
		ColumnFlushQuaternaryEmissionWavelengths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 * Nanometer],
			Units -> Nanometer,
			Description -> "For each member of ColumnSelectorAssembly, the 4th of upto 4 monochromator/filter wavelength used to filter emitted light from the fluorescence flow cell during column flush before it is measured in the Fluorescence detector.",
			Category -> "Column Flush"
		},
		ColumnFlushEmissionCutOffFilters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0Nanometer],
			Units -> Nanometer,
			Description ->"For each member of ColumnSelectorAssembly, the cut-off wavelength(s) to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass before the light enters emission monochromator for final wavelength selection during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percentage of maximum amplification of ColumnFlushExcitationWavelengths/ColumnFlushEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Column Flush"
		},
		ColumnFlushSecondaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percentage of maximum amplification of ColumnFlushExcitationWavelengths/ColumnFlushEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Column Flush"
		},
		ColumnFlushTertiaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percentage of maximum amplification of ColumnFlushExcitationWavelengths/ColumnFlushEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Column Flush"
		},
		ColumnFlushQuaternaryFluorescenceGains -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "For each member of ColumnSelectorAssembly, the percentage of maximum amplification of ColumnFlushExcitationWavelengths/ColumnFlushEmissionWavelengths channel during column prime on the Fluorescence detector. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the Photo Multiplier Tube (PMT).",
			Category -> "Column Flush"
		},
		ColumnFlushFluorescenceFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the fluorescence flow cell of the fluorescence detector during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushLightScatteringLaserPowers -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[10*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the laser power used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushLightScatteringFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) flow cell during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushRefractiveIndexMethods -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[RefractiveIndex,DifferentialRefractiveIndex],
			Description -> "For each member of ColumnSelectorAssembly, the type of refractive index measurement of the Refractive Index (RI) Detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
			Category -> "Column Flush"
		},
		ColumnFlushRefractiveIndexFlowCellTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the nominal temperature setting inside the refractive index flow cell of the refractive index (RI) detector during column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushNebulizerGases -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, indicates if sheath gas is turned on for the Evaporative Light Scattering Detector (ELSD) during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushNebulizerGasPressures -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[20*PSI,60*PSI],
			Units->PSI,
			Description -> "For each member of ColumnSelectorAssembly, if NebulizerGas is True, the applied pressure to the sheath gas during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushNebulizerGasHeatings -> {
			Format->Multiple,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "For each member of ColumnSelectorAssembly, if NebulizerGas is True, indicates if sheath gas is heated or not for the Evaporative Light Scattering Detector (ELSD) during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushNebulizerHeatingPowers -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0*Percent,100*Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the relative magnitude of the heating element used to heat the sheath gas during the column flush.",
			Category -> "Column Flush"
		},
		ColumnFlushDriftTubeTemperatures -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "For each member of ColumnSelectorAssembly, the set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
			Category -> "Column Flush"
		},
		ColumnFlushELSDGains -> {
			Format->Multiple,
			Class->Real,
			Pattern:>RangeP[0 Percent,100 Percent],
			Units -> Percent,
			Description -> "For each member of ColumnSelectorAssembly, the percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
			Category -> "Column Flush"
		},
		ColumnFlushELSDSamplingRates -> {
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0*1/Second],
			Units -> 1/Second,
			Description -> "For each member of ColumnSelectorAssembly, the frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurment.",
			Category -> "Column Flush"
		},
		(*--- Final Buffer state ---*)

		FinalBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferA immediately after the experiment is completed as detected by the integrated ultrasonic liquid level sensor.",
			Category -> "Column Flush"
		},
		FinalBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferB immediately after the experiment is completed as detectoed by the integrated ultrasonic liquid level sensor.",
			Category -> "Column Flush"
		},
		FinalBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferC immediately after the experiment is completed as detected by the integrated ultrasonic liquid level sensor.",
			Category -> "Column Flush"
		},
		FinalBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of BufferD immediately after the experiment is completed as detected by the integrated ultrasonic liquid level sensor.",
			Category -> "Column Flush"
		},

		FinalBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferA taken immediately after the experiment is completed as captured by the integrated camera on the instrument.",
			Category -> "Column Flush"
		},
		FinalBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferB taken immediately after the experiment is completed as captured by the integrated camera on the instrument.",
			Category -> "Column Flush"
		},
		FinalBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferC taken immediately after the experiment is completed as captured by the integrated camera on the instrument.",
			Category -> "Column Flush"
		},
		FinalBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of BufferD taken immediately after the experiment is completed as captured by the integrated camera on the instrument.",
			Category -> "Column Flush"
		},

		(* --- Experimental Results --- *)

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
			Description -> "The chromatography traces generated for any column prime runs.",
			Category -> "Experimental Results"
		},
		FlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for any column flush runs.",
			Category -> "Experimental Results"
		},
		SystemPrimeData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the system prime run whereby the system is flushed with solvent before the column is connected.",
			Category -> "Experimental Results",
			Developer->True
		},
		SystemFlushData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The chromatography traces generated for the system flush run whereby the system is flushed with solvent after the column has been disconnected.",
			Category -> "Experimental Results",
			Developer->True
		},
		InitialAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured prior to injection.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		FinalAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) measured at the end of the protocol.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		InjectedAnalyteVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter Micro,
			Description -> "For each member of SamplesIn, the volume of each analyte sample (SamplesIn if drawn directly or AliquotSamples if instructed to aliquot prior to the assay) that is injected during the protocol, calculated as the difference between InitialAnalyteVolumes and FinalAnalyteVolumes.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		ExportDirectory -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The local directory on the instrument computer to which data are saved while being generated before being parsed and uploaded to the cloud.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's raw data from the instrument computer to the server for the Ultimate 3000 instruments.",
			Category -> "Experimental Results",
			Developer -> True
		},
		ArchiveScriptFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data to the public drive. In addition, for protocols using ChemStation software, the file archives the data from virtual computer after data export.",
			Category -> "Experimental Results",
			Developer -> True
		},
		LampDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The raw data files in xps format of the Lamp History Report from MassLynx software for the Waters instruments.",
			Category -> "Experimental Results",
			Developer -> True
		},
		DetectorDataFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path to store internal data files of the Multi-Angle Light Scattering (MALS), Dynamic Light Scattering (DLS), RefractiveIndex (RI) detections from Astra software.",
			Category -> "General",
			Developer -> True
		},
		DetectorAstraDataFilePath->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the raw data files in afe7 format of the Multi-Angle Light Scattering (MALS), Dynamic Light Scattering (DLS), RefractiveIndex (RI) detections from Astra software. Only one file is generated per injection on the instrument.",
			Category -> "Experimental Results",
			Developer -> True
		},
		DetectorCSVDataFilePath->{
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The location of the exported raw data files in text format of the Multi-Angle Light Scattering (MALS), Dynamic Light Scattering (DLS), RefractiveIndex (RI) detections from Astra software. Only one file is generated per injection on the instrument.",
			Category -> "Experimental Results",
			Developer -> True
		},


		(* Fields related to extenuating circumstances (e.g. pressure limit hit) *)

		MinPressure-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "The lower limit of the pump pressure which if reached during the run will cause the current injection to be paused. At which point the team checks for leaks or air bubbles, if found they are fixed and the protocol resumes with next injection. Otherwise the protocol is aborted early, and it proceeds directly to flush and column storage.",
			Category -> "Separation"
		},
		MaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * PSI],
			Units -> PSI,
			Description -> "The upper limit of the pump pressure which if reached during the run will cause the current injection to be paused. At which point the team checks for any clogs in the lines, if found they are fixed and the protocol resumes with next injection. Otherwiset the protocol is aborted early, and it proceeds directly to flush and column storage.",
			Category -> "Separation"
		},
		DisplayedMaxPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Bar],
			Units -> Bar,
			Description -> "The upper limit of the pump pressure in Bar which if reached during the run will cause the current injection to be paused.",
			Category -> "Separation",
			Developer -> True
		},
		PressureFailure-> {
			Format -> Single,
			Class -> Boolean,
			Pattern:> BooleanP,
			Description-> "Indicates if pressure limit was hit and the team was unable to fix it resulting in the run to be aborted without remainder of the injection going through.",
			Category -> "Separation"
		},
		LowPressureError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the back pressure of the pump falls below the MinPressure for this Instrument.",
			Category -> "Separation"
		},
		HighPressureError -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the flow cell pressure rises above the MaxPressure for this Instrument.",
			Category -> "Separation"
		},
		LeakDetectionInjection -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0],
			Description -> "Indicates the injections during which a leak was detected which was later fixed by the team followed by remaining injections proceeding normally.",
			Category -> "Separation"
		},
		LeakLocation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Column,UVVis,Valve,Autosampler,None],
			Description -> "The location of any leaks detected while the separation was running, in the order in which they were found. Leaks can be detected in multiple places.",
			Category -> "Separation"
		},
		LeakFalseAlarm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a leak alarm went off but there is no detectable leak in the instrument upon closer inspection.",
			Category -> "Separation"
		},
		InstrumentAlarm -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether each detected leak activated the instrument's leak alarm, in the order in which the leaks were found. This indicates if an error message is thrown by the instrument software.",
			Category -> "Separation",
			Developer -> True
		},
		LeakDetectionLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Expression, Boolean, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, Alternatives[Column,UVVis,Valve,Autosampler,None], BooleanP, BooleanP, _Link},
			Relation -> {Null, Null, Null, Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A Log of any leaks detected during this protocol in the form of {Date, Low Pressure Error, Leak Location, Instrument Alarm, False Alarm, Reporting Party}.",
			Category -> "Separation",
			Headers -> {"Date", "Low Pressure Error","Leak Location","Instrument Alarm","False Alarm","Reporting Party"}
		},
		ShutdownMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of buffers over time performed when the Instrument errors for low pressure.",
			Category -> "Separation",
			Developer -> True
		},
		ShutdownFilename -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The specific filename used to employ the ShutdownMethod.",
			Category -> "Separation",
			Developer -> True
		},

		(*--- SystemFlush ---*)

		SystemFlushBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent flowed through channel A used to clean the instrument and lines after column removal.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent flowed through channel B used to clean the instrument and lines after column removal.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent flowed through channel C used to clean the instrument and lines after column removal.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solvent flowed through channel D used to clean the instrument and lines after column removal.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushBufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,{LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Model[Sample],Null},
			Description -> "The list of deck placements used for placing system flush buffers needed to run the flush protocol onto the instrument buffer deck.",
			Category -> "Flush System",
			Developer -> True,
			Headers -> {"Object to Place","Placement Tree"}
		},
		InitialSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferA immediately before the flushing the instrument as detected by integrated ultrasonic liquid sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferB immediately before the flushing the instrument as detected by integrated ultrasonic liquid sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferC immediately before the flushing the instrument as detected by integrated ultrasonic liquid sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferD immediately before the flushing the instrument as detected by integrated ultrasonic liquid sensor.",
			Category -> "Flush System",
			Developer -> True
		},

		InitialSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the SystemFlushBufferA taken immediately before flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the SystemFlushBufferB taken immediately before flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the SystemFlushBufferC taken immediately before flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		InitialSystemFlushBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the SystemFlushBufferD taken immediately before flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushGradient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "The composition of solvents over time used to purge the instrument lines at the end.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushImportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that imports the protocol from the server into the instrument software for the system flush.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushExportScriptFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The compiled file that exports the protocol's system flush raw data from the instrument software to the server.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushArchiveScriptFilePath-> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path and name of the .bat file which transfers data to the public drive and archives the data from virtual computer after system flush data export.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SystemFlushInjectionTableFileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file name of the injection table file that is loaded into the instrument software during system flush.",
			Category -> "Flush System",
			Developer -> True
		},
		SystemFlushInjectionTableFilePath->{
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file used to load the flush injection table file into the instrument software after removing the column.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferA immediately after the flushing the instrument as measured by the integrated sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferB immediately after the flushing the instrument as measured by the integrated sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferCVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferC immediately after the flushing the instrument as measured by the integrated sensor.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferDVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "The volume of the SystemFlushBufferD immediately after the flushing the instrument as measured by the integrated sensor.",
			Category -> "Flush System",
			Developer -> True
		},

		FinalSystemFlushBufferAAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemFlushBufferA taken immediately after flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferBAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemFlushBufferB taken immediately after flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferCAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemFlushBufferC taken immediately after flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		FinalSystemFlushBufferDAppearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "The image of SystemFlushBufferD taken immediately after flushing the instrument as captured by the integrated camera.",
			Category -> "Flush System",
			Developer -> True
		},
		AlternateOptions -> {
			Format -> Multiple,
			Class -> Compressed,
			Pattern :> {_Rule...},
			Units -> None,
			Description -> "The set of options for each potential, alternate instrument.",
			Category -> "Option Handling",
			Developer -> True
		},
		InjectionSampleCentrifugeOptions -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {_Rule...},
			Description -> "The set of options for centrifuging samples, standards, and blanks prior to being loaded on the autosampler. An empty list indicates that options should take their default values for ExperimentCentrifuge. Null indicates that no centrifugation is to take place.",
			Category -> "Sample Preparation",
			Developer -> True
		}
	}
}];