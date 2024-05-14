(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,FreezeCells],{
	Description->"A protocol for gradual freezing of cells for long-term storage in the cryogenic freezer.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		
		(* ---------- Experiment/Instrument Setup ---------- *)
		
		Batches->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{ObjectP[Object[Sample]]..},
			Description->"Describes the group of cells that are frozen together.",
			Category->"General"
		},
		
		FreezingMethods->{
			Format->Multiple,
			Class->Expression,
			Pattern:>FreezeCellMethodP,
			Description->"For each member of Batches, describes which process is used to freeze the cells.",
			Category->"General",
			IndexMatching->Batches
		},
		
		Instruments->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,ControlledRateFreezer],
				Object[Instrument,ControlledRateFreezer],
				Model[Instrument,Freezer],
				Object[Instrument,Freezer]
			],
			Description->"For each member of Batches, the cooling device that is used to lower the temperature of samples.",
			Category->"General",
			IndexMatching->Batches
		},
		
		(* ---------- ControlledRateFreezer ---------- *)
		
		FreezingProfiles->{
			Format->Multiple,
			Class->Expression,
			Pattern:>{{GreaterEqualP[0 Kelvin],GreaterEqualP[0 Minute]}..},
			Description->"For each member of Batches, describes the series of steps that are taken to cool the cells.",
			Category->"General",
			IndexMatching->Batches
		},
		
		FreezingRates->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Celsius/Minute],
			Units->Celsius/Minute,
			Description->"For each member of Batches, the decrease in temperature per unit time if cooling at a constant rate is desired.",
			Category->"General",
			IndexMatching->Batches
		},
		
		Durations->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Minute],
			Units->Minute,
			Description->"For each member of Batches, the amount of time the cells are cooled at FreezingRate.",
			Category->"General",
			IndexMatching->Batches
		},
		
		ResidualTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of Batches, the final temperature at which the cells are kept before moving to final storage.",
			Category->"General",
			IndexMatching->Batches
		},
		
		(* ---------- InsulatedCooler ---------- *)
		
		FreezingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Rack,InsulatedCooler],
				Object[Container,Rack,InsulatedCooler]
			],
			Description->"For each member of Batches, the cooling apparatus that is used to freeze the cells.",
			Category->"General",
			IndexMatching->Batches
		},
		
		Coolants->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"For each member of Batches, liquid that is used to transport heat away from the samples during freezing. This liquid controls the rate of cooling during the experiment.",
			Category->"General",
			IndexMatching->Batches
		},
		
		(* ---------- Transport ---------- *)
		
		TransportFreezers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,PortableCooler],
				Object[Instrument,PortableCooler]
			],
			Description->"For each member of Batches, the portable freezer in which the samples are transported from the instrument to the final storage container.",
			Category->"General",
			IndexMatching->Batches
		},
		
		(* ---------- Miscellaneous ---------- *)
		
		Tweezer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item,Tweezer],
				Object[Item,Tweezer]
			],
			Description->"Tweezer that is used to move frozen cell containers.",
			Category->"General",
			Developer->True
		},
		
		AdditionalProcessingTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"After ControlledRateFreezer methods are completed, any extra time needed to finish the freezing of InsulatedCooler batches.",
			Category->"General",
			Developer->True
		},
		
		(* ---------- Batching ---------- *)
		
		ControlledRateFreezerBatches->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"Describes the group of cells that are frozen together in the ControlledRateFreezer methods.",
			Category->"Batching",
			Developer->True
		},
		
		ControlledRateFreezerBatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"For each member of ControlledRateFreezerBatches, parameters describing the length of each ControlledRateFreezer batch.",
			Category->"Batching",
			IndexMatching->ControlledRateFreezerBatches,
			Developer->True
		},
		
		ControlledRateFreezerInstrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,ControlledRateFreezer],
				Object[Instrument,ControlledRateFreezer]
			],
			Description->"The cooling device that is used to lower the temperature of samples.",
			Category->"Batching",
			Developer->True
		},
		
		ControlledRateFreezerTransportCoolers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,PortableCooler],
				Object[Instrument,PortableCooler]
			],
			Description->"The portable freezer in which the samples are transported from the instrument to the final storage container.",
			Category->"Batching",
			Developer->True
		},
		
		ControlledRateFreezerTransportTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of ControlledRateFreezerTransportCoolers, the temperature setting for the portable freezer which transport the samples from the instrument to the final storage container.",
			Category->"Batching",
			IndexMatching->ControlledRateFreezerTransportCoolers,
			Developer->True
		},
		
		ControlledRateFreezerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP,
			Description->"For each member of ControlledRateFreezerBatches, describes the final storage destination for each sample.",
			Category->"Batching",
			IndexMatching->ControlledRateFreezerBatches,
			Developer->True
		},
		
		RunTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0 Minute],
			Units->Minute,
			Description->"Describes how long each ControlledRateFreezer batch takes to freeze.",
			Category->"Batching",
			Developer->True
		},
		
		MethodNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"File names used for the ControlledRateFreezer methods.",
			Category->"Batching",
			Developer->True
		},
		
		InsulatedCoolerBatches->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"Describes the group of cells that are frozen together in the InsulatedCooler methods.",
			Category->"Batching",
			Developer->True
		},
		
		InsulatedCoolerBatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"For each member of InsulatedCoolerBatches, parameters describing the length of each InsulatedCooler batch.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerBatches,
			Developer->True
		},
		
		InsulatedCoolerFreezingContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Rack,InsulatedCooler],
				Object[Container,Rack,InsulatedCooler]
			],
			Description->"The cooling apparatus that is used to freeze the cells.",
			Category->"Batching",
			Developer->True
		},
		
		InsulatedCoolerCoolants->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description->"For each member of InsulatedCoolerFreezingContainers, liquid that is used to transport heat away from the samples during freezing. This liquid controls the rate of cooling during the experiment.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerFreezingContainers,
			Developer->True
		},
		
		InsulatedCoolerCoolantContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description->"For each member of InsulatedCoolerFreezingContainers, containers in which both the coolants and the freezing containers are placed in.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerFreezingContainers,
			Developer->True
		},
		
		InsulatedCoolerFreezingConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP,
			Description->"For each member of InsulatedCoolerFreezingContainers, the manner in which the samples are stored during freezing.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerFreezingContainers,
			Developer->True
		},
		
		InsulatedCoolerTransportCoolers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Instrument,PortableCooler],
				Object[Instrument,PortableCooler]
			],
			Description->"For each member of InsulatedCoolerFreezingContainers, the portable freezer in which the samples are transported from the instrument to the final storage container.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerFreezingContainers,
			Developer->True
		},
		
		InsulatedCoolerTransportTemperatures->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Kelvin],
			Units->Celsius,
			Description->"For each member of InsulatedCoolerTransportCoolers, the temperature setting for the portable freezer which transport the samples from the instrument to the final storage container.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerTransportCoolers,
			Developer->True
		},
		
		InsulatedCoolerStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>SampleStorageTypeP,
			Description->"For each member of InsulatedCoolerBatches, describes the final storage destination for each sample.",
			Category->"Batching",
			IndexMatching->InsulatedCoolerBatches,
			Developer->True
		}
	}
}];




