(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Resource, Sample], {
	Description->"A set of parameters describing the attributes of a sample required to complete the requesting protocol.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		 Models -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Model[Part],
				Model[Plumbing],
				Model[Item],
				Model[Sensor],
				Model[Wiring]
			],
			Description -> "The requested model to be fulfilled by picking of a sample.",
			Category -> "Resources"
		},
		RequestedModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample][RequestedResources],
				Model[Container][RequestedResources],
				Model[Part][RequestedResources],
				Model[Plumbing][RequestedResources],
				Model[Item][RequestedResources],
				Model[Sensor][RequestedResources],
				Model[Wiring][RequestedResources]
			],
			Description -> "The requested models that are reserved to fulfill this resource request.",
			Category -> "Resources"
		},
		Sample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Item],
				Object[Sensor],
				Object[Wiring]
			],
			Description -> "The sample picked to fulfill this resource.",
			Category -> "Resources"
		},
		RequestedSample -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample][RequestedResources],
				Object[Item][RequestedResources],
				Object[Container][RequestedResources],
				Object[Part][RequestedResources],
				Object[Plumbing][RequestedResources],
				Object[Sensor][RequestedResources],
				Object[Wiring][RequestedResources]
			],
			Description -> "The sample that is reserved to fulfill this resource request.",
			Category -> "Resources"
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container in which the requested resource resided.",
			Category -> "Resources"
		},
		ContainerModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of container in which the requested resource must reside.",
			Category -> "Resources"
		},
		ContainerName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "A unique label of the container in which the requested resource resided.",
			Category -> "Resources"
		},
		Well->{
			Format->Single,
			Class->String,
			Pattern:>WellP|LocationPositionP,
			Description->"The microplate well in which this requested resource is physically located.",
			Category->"Container Information"
		},
		Amount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0 Millimeter] | GreaterEqualP[0*Unit, 1*Unit],
			Description -> "The amount of sample that was used by the given protocol.",
			Category -> "Resources"
		},
		ExactAmount -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the sample used to fulfill this resource must have the exact same mass/volume/count as the Amount requested (+/- Tolerance, if provided), instead of greater than or equal to the Amount specified.",
			Category -> "Resources"
		},
		Tolerance -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterEqualP[0*Milliliter] | GreaterEqualP[0*Milligram] | GreaterEqualP[0*Unit, 1*Unit],
			Description -> "The mass/volume/count that the sample is allowed to deviate from the requested Amount when fulfilling the sample, if ExactAmount->True.",
			Category -> "Resources"
		},
		Rent -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this resource is being used temporarily and the requested item will be charged based on the duration of the rental instead of permanently purchased.",
			Category -> "Resources"
		},
		RentContainer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a container gathered as part of fulfilling this sample resource according to its ContainerModels request is being used temporarily and the requested container will be charged based on the duration of the rental instead of permanently purchased.",
			Category -> "Resources"
		},
		UpdateCount -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the count of the selected sample should be updated when the resource is fulfilled or if independent code is responsible for determining the new count.",
			Category -> "Resources"
		},
		Untracked -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the amount of the requested item requested by this resource is not explicitly known and thus the resource is not purchased.",
			Category -> "Resources"
		},
		Purchase -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the user who requested this resource is purchasing the sample in question from the inventory.",
			Category -> "Resources",
			AdminWriteOnly -> True
		},
		ThawRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the resource requires thawing upon removal from storage.",
			Category -> "Resources"
		},
		Preparation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP[{Object[Protocol,StockSolution],Object[Protocol,Transfer],Object[Protocol,SampleManipulation],Object[Protocol,PrepareReferenceElectrode]}],
			Relation -> Alternatives[
				Object[Protocol,StockSolution][PreparedResources],
				Object[Protocol,ManualSamplePreparation][PreparedResources],
				Object[Protocol,RoboticSamplePreparation][PreparedResources],
				Object[Protocol,ManualCellPreparation][PreparedResources],
				Object[Protocol,RoboticCellPreparation][PreparedResources],
				Object[Protocol,SampleManipulation][PreparedResources],
				Object[Protocol,Transfer][PreparedResources],
				Object[Protocol,PrepareReferenceElectrode][PreparedResources],
				Object[Protocol,AssembleCrossFlowFiltrationTubing][PreparedResources]
			],
			Description -> "The protocol that prepares a sample meeting the amount and container model requirements of this resource request.",
			Category -> "Resources"
		},
		ContainerResource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP[{Object[Resource,Sample]}],
			Relation -> Object[Resource,Sample][SampleResource],
			Description -> "The resource requesting an empty container to satisfy this resource's ContainerModels request and serve as destination for the fulfilled Sample of this resource.",
			Category -> "Resources"
		},
		SampleResource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> LinkP[{Object[Resource,Sample]}],
			Relation -> Object[Resource,Sample][ContainerResource],
			Description -> "The resource requesting a sample that is contained by this empty container resource.",
			Category -> "Resources"
		},
		Fresh -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a fresh sample was used when fulfilling this resource.",
			Category -> "Resources"
		},
		NumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of times the requested resource will be used for. An object cannot be picked in fulfillment unless it has at least this many uses remaining.",
			Category -> "Resources"
		},
		VolumeOfUses -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Milliliter],
			Units -> Milliliter,
			Description -> "The number of times the requested resource will be used for. An object cannot be picked in fulfillment unless it has at least this many uses remaining.",
			Category -> "Resources"
		},
		AutomaticDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that samples prepared in exact amounts specifically to satisfy this resource should be automatically discarded at the end of the protocol. If an existing sample is picked it will not be flagged for disposal regardless of this value.",
			Category -> "Organizational Information",
			Developer -> True
		},
		(* TransportCondition relevant fields *)
		TransporterModels -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument]
				],
				Description -> "The requested model container or instrument used to transport the sample.",
				Category -> "Resources"
		},

		Transporter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument]
			],
			Description -> "The actual container or instrument request to transport the sample at a certain temperature.",
			Category -> "Resources"
		},

		TransporterResource -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Resource,Instrument]
			],
			Description -> "The fulfilled resource of the container or instrument used to transport the sample at a certain temperature.",
			Category -> "Resources"
		},
		Sterile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the sample fulfilling this resources should be should be free of microbial contamination. If the sample contains living microbial cell components, it must be free of non-sample microbial contamination. Otherwise, the sample must be either certified by manufactures without microbial life forms, or handled with AsepticHandling which includes sanitization, autoclaving, sterile filtration, or transferring in biosafety cabinet during the course of experiments, as well as during sample storage and handling.",
			Category -> "Resources"
		}
	}
}];
