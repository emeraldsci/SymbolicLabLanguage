(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,VerifyHamiltonLabware], {
	Description->"A protocol that verifies the labware definitions of the liquid handler target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* LiquidHandler field is added here in Object[Qualification,VerifyHamiltonLabware] so we can share procedures with RSP/SM more easily *)
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The liquid handler deck on which the Hamilton labware definitions verifications are being performed (same as Target).",
			Category -> "General",
			Developer -> True
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "The specific container plates that this qualification is verifying.",
			Category -> "General",
			Abstract -> True
		},
		VerificationModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Plate][LabwareVerifications],
			Description -> "For each member of Containers, the model of the container plate that this qualification is verifying.",
			Category -> "General",
			IndexMatching -> Containers,
			Abstract -> True
		},
		VerifiedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,LiquidHandler][LabwareVerifications],
			Description -> "The liquid handler deck on which the Hamilton labware definitions are verified.",
			Category -> "General",
			Abstract -> True
		},
		Filters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container,Plate,Filter],
				Model[Container,Plate,Filter]
			],
			Description -> "For each member of Containers, the filter plate used to be loaded into the MPE filter plate slot to provide access to the MPE collection plate slot for verification testing.",
			Category -> "General",
			IndexMatching -> Containers
		},
		CollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Plate],
				Object[Container,Plate]
			],
			Description -> "For each member of Containers, the collection plate used with the filter plate to test the stacked filter plate positions on the low position carrier.",
			Category -> "General",
			IndexMatching -> Containers
		},
		LiquidHandlerAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack]|Object[Container, Rack],
			Description -> "For each member of Containers, the rack necessary to hold the plate on a liquid handler deck.",
			Developer -> True,
			Category -> "General",
			IndexMatching -> Containers
		},
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Integrated instruments required for this qualification.",
			Category -> "General"
		},
		Scale -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> (Full|FirstAndLast|First|Last|Single),
			Description -> "The portion of the deck positions that should be tested with transfer verification tests in this qualification.",
			Category -> "General"
		},
		DeviceChannel -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SingleDeviceChannelP,
			Description -> "The channel(s) of the liquid handler that are used to test the pipetting positions in this qualification.",
			Category -> "General"
		},
		RunTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?TimeQ,
			Description -> "The estimated time for completion of the on-deck manipulations of each member of Containers.",
			Category -> "Instrument Processing",
			Developer -> True
		},
		(* ProtocolKey field is used here instead of QualificationKey here in Object[Qualification,VerifyHamiltonLabware] so we can share procedures with RSP/SM more easily *)
		ProtocolKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The protocol key used to identify the method file name.",
			Category -> "Instrument Processing",
			Developer -> True
		},
		Solvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample]|Object[Sample],
			Description -> "The solvent used to perform the transfers into and out of the Containers.",
			Category -> "General",
			Developer -> True
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Tips]|Object[Item, Tips],
			Description -> "The tips used to perform the transfers into and out of the Containers.",
			Category -> "General",
			Abstract -> True
		},
		TipRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container] | Model[Container]),
			Description -> "Sterile hamilton tip transporters that will be used to transport tips from the VLM to the sterile Hamilton enclosure.",
			Category -> "General",
			Developer -> True
		},
		TipPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP...}},
			(* NOTE: We need to put Object[Container] here because we can place tip boxes onto the deck. *)
			Relation -> {Model[Item]|Object[Item]|Object[Container], Null},
			Description -> "A list of tip placements used to set-up the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		Lid->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Lid]|Object[Item,Lid],
			Description -> "For each member of Containers, the lid used to test covering the container in this qualification.",
			Category -> "General",
			Developer -> True
		},
		LidSpacer->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,LidSpacer]|Object[Item,LidSpacer],
			Description -> "For each member of Containers, the spacer placed on top of the plate during automated liquid handling to prevent the plate lid from contacting samples in the plate.",
			Category -> "General",
			Developer -> True
		},
		LidPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP...}},
			Relation -> {Object[Item,Lid]| Model[Item,Lid], Null},
			Description -> "A list of placements used to place lids on the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		PlateAdapterPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]),(Object[Container]|Model[Container]),Null},
			Description -> "List of placements of plates on automation-friendly adapter racks.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place","Destination Object","Destination Position"}
		},
		LidSpacerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP...}},
			Relation -> {Object[Item, LidSpacer]| Model[Item, LidSpacer], Null},
			Description -> "A list of placements used to place lid spacers on the robotic liquid handler deck.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		Align -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the Target liquid handler is aligned before starting labware verification.",
			Category -> "General",
			Developer -> True
		},
		Alignment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Qualification,MeasureLiquidHandlerDevicePrecision],
			Description -> "The align qualification performed on the Target liquid handler before starting labware verification.",
			Category -> "General",
			Developer -> True
		},
		DeckPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]|Object[Sample]|Object[Item], Null},
			Description -> "A list of container placements used to set-up the robotic liquid handler deck for labware verification.",
			Headers ->  {"Object to Place", "Placement Tree"},
			Category -> "Placements",
			Developer -> True
		},
		ProcessRecording -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A video recording taken during the entire robotic execution of this protocol.",
			Category -> "Experimental Results"
		},
		LiquidHandlerMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The location of the robotic liquid handler method file to check the deck layout.",
			Category -> "Instrument Processing",
			Developer -> True
		},
		VerificationResult->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Containers, the result of the verification.",
			IndexMatching -> Containers,
			Category -> "Experimental Results"
		},
		TeachingProbeVerificationResults -> {
			Format->Multiple,
			Class->{Boolean,Boolean,Boolean,Boolean},
			Pattern:>{BooleanP,BooleanP,BooleanP,BooleanP},
			Description->"For each member of Containers, the result of the verification from teaching probe testing.",
			IndexMatching -> Containers,
			Category -> "Experimental Results",
			Headers->{"First Position X/Y","First Position Z","Last Position X/Y","Last Position Z"}
		},
		HamiltonManipulationsFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The method file used to perform the robotic manipulations in the Hamilton liquid handler.",
			Category -> "General",
			Developer->True
		},
		HamiltonDeckFiles -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The archive containing labware and deck file used in this method.",
			Category -> "General",
			Developer->True
		},
		LiquidHandlingPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "For each member of Containers, the instrumentation trace file that monitored and recorded the pressure curves during aspiration and dispense of the robotic liquid handling running the deck verification tests.",
			Category -> "Experimental Results"
		},
		AspirationPressure->{
			Format->Multiple,
			Class->Expression,
			Pattern:> {QuantityArrayP[{{Second, Pascal}..}]..},
			Description->"For each member of Containers, the pressure data measured by the liquid handler during aspiration of the solvent into the labware on different deck positions.",
			Category -> "Experimental Results",
			IndexMatching -> Containers
		},
		DispensePressure->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{QuantityArrayP[{{Second, Pascal}..}]..},
			Description->"For each member of Containers, the pressure data measured by the liquid handler during dispensing of the solvent into the labware on different deck positions.",
			Category -> "Experimental Results",
			IndexMatching -> Containers
		},
		CurrentVerificationResult->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "The result of the verification for the current container.",
			Developer->True,
			Category -> "Experimental Results"
		},
		Modules -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[TeachingProbe, Movement, Transfer],
			Relation -> Null,
			Description -> "A list of the verification tests that this qualification performs.",
			Category -> "General"
		},
		PartialEvaluation->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the transfer verification test should be skipped after the teaching probe test failure.",
			Developer->True,
			Category -> "Instrument Processing"
		},
		InitializationStartTime->{
			Format->Single,
			Class->Expression,
			Pattern:>_?DateObjectQ,
			Description->"The time we start to initialize the liquid handler at the beginning of the method. We wait a maximum of 20 minutes after this time for a success or failure message from the instrument before further troubleshooting steps are performed.",
			Category->"Instrument Processing",
			Developer->True
		},
		Comments -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Containers, the comment from the scientific instrumentation team regarding the labware verification result, updated during the qualification evaluation process.",
			IndexMatching -> Containers,
			Category -> "Experimental Results"
		},
		VerificationCode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The object used to verify that the run was completed on the instrument.",
			Category -> "Instrument Processing",
			Developer -> True
		}
	}
}];
