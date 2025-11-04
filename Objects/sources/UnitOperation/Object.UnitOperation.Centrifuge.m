(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[UnitOperation,Centrifuge],
	{
		Description->"A detailed set of parameters that specifies a single transfer step in a larger protocol.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{
			SampleLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Sample],
					Model[Sample],
					Model[Container],
					Object[Container]
				],
				Description -> "The sample that is to be centrifuged during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleString -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "The sample that is to be centrifuged during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {LocationPositionP, ObjectP[{Model[Container], Object[Container]}]|_String},
				Relation -> Null,
				Description -> "The sample that is to be centrifuged during this unit operation.",
				Category -> "General",
				Migration->SplitField
			},
			SampleLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, a user defined word or phrase used to identify the sample that is used in the experiment, for use in downstream unit operations.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			SampleContainerLabel -> {
				Format -> Multiple,
				Class -> String,
				Pattern :> _String,
				Relation -> Null,
				Description -> "For each member of SampleLink, a user defined word or phrase used to identify the container of the sample that is used in the experiment, for use in downstream unit operations.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			Instrument -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, Centrifuge],
					Object[Instrument, Centrifuge]
				],
				Description -> "For each member of SampleLink, the centrifuge that will be used to spin the provided samples.",
				Category -> "General",
				IndexMatching -> SampleLink
			},
			
			(* For ultracentrifuge *)
			ChilledRotor -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Relation -> Null,
				Description -> "For each member of SampleLink, indicates if the ultracentrifuge rotor is stored in refrigirator between usage thus it is prechilled on loading into the ultracentrifuge.",
				Category -> "Centrifuge Setup",
				IndexMatching -> SampleLink
			},
			(* Geometry parameters *)
			RotorGeometry -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> RotorGeometryP,
				Relation -> Null,
				Description -> "For each member of SampleLink, indicates if the provided samples will be spun at a fixed angle or freely pivot.",
				Category -> "Centrifuge Setup",
				IndexMatching -> SampleLink
			},
			RotorAngle -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> RotorAngleP,
				Relation -> Null,
				Description -> "For each member of SampleLink, the angle of the samples in the rotor that will be applied to spin the provided samples if ultracentrifuge instrument is selected.",
				Category -> "Centrifuge Setup",
				IndexMatching -> SampleLink
			},
			
			(* For batched unitoperations *)
			Rotor -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Container,CentrifugeRotor],
					Object[Container,CentrifugeRotor]
				],
				Description -> "For each member of SampleLink, the centrifuge rotor used to spin the sample.",
				Category -> "Centrifuge Setup",
				IndexMatching -> SampleLink
			},
			(* End of bathced unit operations*)
			(* Centrifugation parameters*)
			Intensity -> {
				Format -> Multiple,
				Class -> VariableUnit,
				Pattern :> GreaterP[0*RPM]|GreaterP[0*GravitationalAcceleration],
				Description -> "For each member of SampleLink, the rotational speed or the force that will be applied to the samples by centrifugation.",
				Category -> "Centrifugation",
				IndexMatching -> SampleLink
			},
			Time -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Minute],
				Units -> Minute,
				Description -> "For each member of SampleLink, the amount of time for which samples are spun in this centrifugation.",
				Category -> "Centrifugation",
				IndexMatching -> SampleLink
			},
			TemperatureReal -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> GreaterP[0*Kelvin],
				Units -> Celsius,
				Description -> "For each member of SampleLink, the temperature in real value at which the centrifuge chamber is held during centrifugation.",
				Category -> "Centrifugation",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			TemperatureExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> Alternatives[Ambient],
				Description -> "For each member of SampleLink, the temperature (if it's ambient) at which the centrifuge chamber is held during centrifugation.",
				Category -> "Centrifugation",
				Migration-> SplitField,
				IndexMatching->SampleLink
			},
			(* Collection container *)
			CollectionContainerLink -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Container],
					Model[Container]
				],
				Description -> "For each member of SampleLink, the container (as a link) that should be stacked on the bottom of the sample's container to collect the filtrate passing through the filter container.",
				Category -> "Organizational Information",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			CollectionContainerExpression -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> {_Integer, ObjectP[{Model[Container], Object[Container]}]},
				Relation -> Null,
				Description -> "For each member of SampleLink, the container (as {position, Container}) that should be stacked on the bottom of the sample's container to collect the filtrate passing through the filter container.",
				Category -> "Centrifugation",
				Migration->SplitField,
				IndexMatching->SampleLink
			},
			BatchIndex -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0,1],
				Units -> None,
				Relation -> Null,
				Description -> "Parameters describing the index of batch.",
				Category -> "Centrifugation",
				Developer->True
			},
			CentrifugeType->{
				Format -> Multiple,
				Class -> Expression,
				Pattern :> CentrifugeTypeP,
				Description -> "The type of centrifugation used for this unit operation.",
				Category -> "Centrifugation"
			},
			(* Balancing *)
			CounterbalanceWeights->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Gram],
				Units->Gram,
				Description->"For each member of SampleLink, the weight of the item used as a counterweight for the sample, its container and any associated collection container or adapter.",
				Category->"Filtration",
				Developer->True,
				IndexMatching->SampleLink
			},
			Counterweight->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation -> Alternatives[Model[Item, Counterweight], Object[Item, Counterweight]],
				Description->"For each member of SampleLink, the counterweight to the input container.",
				Category->"Filtration",
				Developer->True,
				IndexMatching->SampleLink
			},

			(* Fields that are used to batch looped in the procedure*)
			(* All of them are marked as developer object *)
			CollectionContainerWeights -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data],
				Description -> "For each member of CollectionContainerLink, data containing the gross weight of the container plus any TareRacks as measured during execution of this centrifugation protocol.",
				Category -> "Centrifuge Balancing",
				IndexMatching -> CollectionContainerLink,
				Developer -> True
			},
			ContainerWeights -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Data],
				Description -> "For each member of ContainersIn, data containing the gross weight of the container plus any TareRacks as measured during execution of this centrifugation protocol.",
				Category -> "Centrifuge Balancing",
				Developer -> True
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
			StackedCounterweightPlacementsBatching -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Units -> None,
				Description -> "The batch lengths corresponding to the StackedCounterweightPlacementsBatching batching field.",
				Category -> "Placements",
				Developer -> True
			},
			CounterbalanceContainers->{
				Format->Multiple,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[
					Object[Container],
					Model[Container],
					Model[Item, Counterweight],
					Object[Item, Counterweight]
				],
				Description->"The containers where the counterbalances will be created for ultracentrifugation.",
				Category->"Centrifuge Balancing",
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
			StickerSheet->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Object[Item,Consumable]|Model[Item,Consumable],
				Description->"A laminated sheet that will be used to collect the object stickers for caps and tubes going into the ultracentrifuge.",
				Developer->True,
				Category->"Centrifuge Setup"
			},
			
			
			(* Batching fields below are excluded from the new unit operations*)
			(*BucketPlacementsBatching,ContainerPlacementsBatching,CollectionContainerPlacementsBatching,CounterweightPlacementsBatching*)
			
			
			(* Buckets and adapters*)
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
				Category -> "Centrifugation"
			},
			Sterile -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Relation -> Null,
				Description -> "Indicates if this unit operation should be performed in a sterile environment.",
				Category -> "General"
			},
			WeightStabilityDuration -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Second],
				Units -> Second,
				Description -> "The duration for which the balance reading needs to stay within a range defined by MaxWeightVariation before being considered stable and measured.",
				Category -> "General"
			},
			MaxWeightVariation -> {
				Format -> Single,
				Class -> Real,
				Pattern :> GreaterEqualP[0 Milligram],
				Units -> Milligram,
				Description -> "The max allowed amplitude the balance readings can fluctuate with for a duration defined by WeightStabilityDuration before being considered stable and measured.",
				Category -> "General"
			}
		}
	}
];
