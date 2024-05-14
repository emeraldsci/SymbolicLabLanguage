

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, Centrifuge], {
	Description->"A protocol for centrifuging samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Balance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance instrument used to weigh the input containers to ensure the centrifuge is balanced properly.",
			Category -> "Centrifuge Balancing"
		},
		ContainerWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of ContainersIn, data containing the gross weight of the container plus any TareRacks as measured during execution of this centrifugation protocol.",
			Category -> "Centrifuge Balancing",
			IndexMatching -> ContainersIn
		},
		CollectionContainerWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of CollectionContainers, data containing the gross weight of the container plus any TareRacks as measured during execution of this centrifugation protocol.",
			Category -> "Centrifuge Balancing",
			IndexMatching -> CollectionContainers
		},
		TareWeight -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "A data object containing the combined empty weight of any TareRacks required to weigh non-self-standing containers.",
			Category -> "Centrifuge Balancing",
			Developer -> True
		},
		TareRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The rack(s) used to weigh non-self-standing containers.",
			Category -> "Centrifuge Balancing",
			Developer -> True
		},
		Counterbalances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part] | Object[Item], (* TODO: Remove Object[Part] after item migration *)
			Description -> "The weighted containers placed opposite some or all of the experimental containers to ensure balanced centrifugation.",
			Category -> "Centrifuge Balancing"
		},
		CounterbalanceWeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Gram],
			Units->Gram,
			Description->"For each member of SamplesIn, the weight of the item used as a counterweight for the sample, its container and any associated collection container or adapter.",
			Category->"Filtration",
			Developer->True,
			IndexMatching->SamplesIn
		},
		CounterbalanceContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The containers where the counterbalances will be created for ultracentrifugation.",
			Category->"Centrifuge Balancing",
			Developer->True
		},
		CounterbalanceContainerTareWeights->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"For each member of CounterbalanceContainers, data containing the weight of the empty container plus any TareRacks as measured during execution of this centrifugation protocol.",
			Category->"Centrifuge Balancing",
			IndexMatching->CounterbalanceContainers,
			Developer->True
		},
		CounterbalanceContainerWeights->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"For each member of CounterbalanceContainers, data containing the gross weight of the container plus any TareRacks as measured during execution of this centrifugation protocol.",
			Category->"Centrifuge Balancing",
			IndexMatching->CounterbalanceContainers,
			Developer->True
		},
		CounterbalanceContainerTargetWeights->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Gram],
			Units->Gram,
			Description->"For each member of CounterbalanceContainers, the gross weight needed to balance the samples on the balancing position of the rotor.",
			Category->"Centrifuge Balancing",
			IndexMatching->CounterbalanceContainers,
			Developer->True
		},
		CounterbalancePrepManipulation->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation],
			Description->"The set of instructions specifying the transfer of balance solvent to the Counterbalances for balancing the vacuum centrifuge during evaporation.",
			Category->"Centrifuge Balancing",
			Developer->True
		},
		CounterbalancePrepPrimitives->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleManipulationP,
			Description->"The list of manipulations used to generated CounterbalancePrepManipulation.",
			Category->"Centrifuge Balancing",
			Developer->True
		},
		Centrifuges -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument],
				Object[Program]
			],
			Description -> "For each member of SamplesIn, the centrifuge instrument used to spin the sample.",
			Category -> "Centrifuge Setup",
			IndexMatching -> SamplesIn
		},
		Rotors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of SamplesIn, the centrifuge rotor used to spin the sample.",
			Category -> "Centrifuge Setup",
			IndexMatching -> SamplesIn
		},
		Buckets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The centrifuge buckets attached to the rotors used for this centrifugation.",
			Category -> "Centrifuge Setup"
		},
		CentrifugeAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the input samples fit in the centrifuge buckets/rotors or the SecondaryCentrifugeAdapters.",
			Category -> "Centrifuge Setup"
		},
		SecondaryCentrifugeAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the CentrifugeAdapters fit in the centrifuge buckets/rotors or the TertiaryCentrifugeAdapters.",
			Category -> "Centrifuge Setup"
		},
		TertiaryCentrifugeAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the SecondaryCentrifugeAdapters fit in the centrifuge buckets/rotors.",
			Category -> "Centrifuge Setup"
		},
		CounterbalanceAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the counterweight fit in the centrifuge buckets/rotors or the SecondaryCounterbalanceAdapters.",
			Category -> "Centrifuge Setup"
		},
		SecondaryCounterbalanceAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the CounterbalanceAdapters fit in the centrifuge buckets/rotors or the TertiaryCounterbalanceAdapters.",
			Category -> "Centrifuge Setup"
		},
		TertiaryCounterbalanceAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part, CentrifugeAdapter],
				Model[Part, CentrifugeAdapter]
			],
			Description -> "The adapters required to have the SecondaryCounterbalanceAdapters fit in the centrifuge buckets/rotors.",
			Category -> "Centrifuge Setup"
		},
		CollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of WorkingContainers, the container that should be stacked on the bottom of the sample's container to collect the filtrate passing through the filter.",
			Category -> "Centrifugation",
			IndexMatching -> WorkingContainers
		},
		Speeds -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Minute],
			Units -> Revolution/Minute,
			Description -> "For each member of SamplesIn, the rate at which the sample is spun.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		Forces -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "For each member of SamplesIn, the relative centrifugal force applied to the sample.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		Times -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the amount of time for which the sample is centrifuged.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, the temperature at which the centrifuge chamber is held during centrifugation.",
			Category -> "Centrifugation",
			IndexMatching -> SamplesIn
		},
		CentrifugePrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Protocol],
			Description -> "A list of programs describing the set of centrifugations performed for this protocol. Each program corresponds to a single centrifuge spin and contains the specific parameters used for that spin.",
			Category -> "Centrifugation"
		},
		Time -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The amount of time for which samples are spun in this centrifugation.",
			Category -> "Centrifugation"
		},
		RotorGeometry -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> RotorGeometryP,
			Description -> "For each member of Rotors, the geometrical shape that best describes the rotor, whether it's a fixed angle or a swing bucket.",
			Category -> "Centrifuge Setup",
			IndexMatching -> Rotors,
			Developer -> True
		},
		Plier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Plier],Object[Item, Plier]],
			Description -> "The plier used to extract the sample from the centrifuge rotor.",
			Category -> "Centrifugation",
			Developer -> True
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place the containers to be centrifuged in the appropriate (balanced) positions of the centrifuge rotor or buckets.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		CollectionContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of placements used to place the containers to be centrifuged in the appropriate (balanced) positions of the centrifuge rotor or buckets.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		CounterweightPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part] | Model[Part] | Object[Item] | Model[Item] | Object[Container] | Model[Container], Null}, (* TODO: Remove Object[Part] and Model[Part] after item migration *)
			Description -> "A list of placements used to place the containers to be centrifuged in the appropriate (balanced) positions of the centrifuge rotor or buckets.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		StackedCounterweightPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Part] | Model[Part] | Object[Item] | Model[Item] | Object[Container] | Model[Container], Null}, (* TODO: Remove Object[Part] and Model[Part] after item migration *)
			Description -> "A list of placements used to place the containers to be centrifuged in the appropriate (balanced) positions of the centrifuge rotor or buckets.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		BucketPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]| Model[Container], Null},
			Description -> "A list of placements used to place the centrifuge buckets into the appropriate (balanced) positions of the centrifuge rotor.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},

		BucketPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the BucketPlacements batching field.",
			Category -> "Placements",
			Developer -> True
		},
		ContainerPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the ContainerPlacementsBatching batching field.",
			Category -> "Placements",
			Developer -> True
		},
		CollectionContainerPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the ContainerPlacementsBatching batching field.",
			Category -> "Placements",
			Developer -> True
		},
		CounterweightPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the CounterweightPlacementsBatching batching field.",
			Category -> "Placements",
			Developer -> True
		},
		StackedCounterweightPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the StackedCounterweightPlacementsBatching batching field.",
			Category -> "Placements",
			Developer -> True
		},
		BatchParameters -> {
			Format -> Multiple,
			Class -> {
				Time -> Real,
				TimeDisplay -> String,
				Temperature -> Real,
				Centrifuge -> Link,
				Rotor -> Link,
				Rate -> Real,
				Force -> Real,
				CentrifugeType -> Expression,
				BatchIndex -> Integer
			},
			Pattern :> {
				Time -> GreaterP[0*Minute],
				TimeDisplay -> _String,
				Temperature -> GreaterP[0 Kelvin],
				Centrifuge -> _Link,
				Rotor -> _Link,
				Rate -> GreaterP[0*RPM],
				Force -> GreaterP[0*GravitationalAcceleration],
				CentrifugeType ->CentrifugeTypeP,
				BatchIndex -> GreaterP[0,1]
			},
			Units -> {
				Time -> Minute,
				TimeDisplay -> None,
				Temperature -> Celsius,
				Centrifuge -> None,
				Rotor -> None,
				Rate -> RPM,
				Force->GravitationalAcceleration,
				CentrifugeType -> None,
				BatchIndex -> None
			},
			Relation -> {
				Time -> Null,
				TimeDisplay -> Null,
				Temperature -> Null,
				Centrifuge -> Object[Instrument,Centrifuge],
				Rotor -> Object[Container,CentrifugeRotor],
				Rate -> Null,
				Force -> Null,
				CentrifugeType -> Null,
				BatchIndex -> Null
			},
			Description -> "Parameters describing how each batch will be centrifuged.",
			Category -> "Centrifugation",
			Developer->True
		},
		SampleCap -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Cap],
				Model[Item, Cap]
			],
			Description -> "The caps required by the centrifuge tubes used in the protocol.",
			Category -> "Centrifuge Setup",
			Developer -> True
		},
		CounterbalanceCap -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Cap],
				Model[Item, Cap]
			],
			Description -> "The caps required by the centrifuge tubes used in the protocol.",
			Category -> "Centrifuge Setup",
			Developer -> True
		},
		WasteBeaker->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container,Vessel]|Model[Container,Vessel],
			Description->"A vessel that will be used to catch any water transferred out of the counterbalances during weighing.",
			Developer->True,
			Category->"Centrifuge Balancing"
		},
		StickerSheet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Item,Consumable]|Model[Item,Consumable],
			Description->"A laminated sheet that will be used to collect the object stickers for caps and tubes going into the ultracentrifuge.",
			Developer->True,
			Category->"Centrifuge Setup"
		},
		WorkingContainerAppearancesAfterCentrifuge->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			IndexMatching->WorkingContainers,
			Description->"For each member of WorkingContainers, the appearance taken immediately after centrifuge is done.",
			Category->"Sample Post-Processing",
			Developer->True
		}
	}
}];
