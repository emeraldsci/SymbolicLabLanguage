(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol,FlashFreeze],
	{
		Description->"A protocol for flash freezing samples.",
		CreatePrivileges->None,
		Cache->Session,
		Fields->{

			(*---Object---*)
			Instrument->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument],Model[Instrument]],
				Description->"The dewar instrument used to flash freeze the provided samples.",
				Category->"General"
			},
			FumeHood->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Instrument],Object[Instrument]],
				Description->"The fume hood instrument in which flash freezing is performed.",
				Category->"General"
			},
			LiquidNitrogenDoser->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Object[Instrument],Model[Instrument]],
				Description->"The liquid nitrogen doser used to fill the dewar instrument with liquid nitrogen.",
				Category->"Instrument Specifications"
			},
			LiquidNitrogenDoseTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0*Second],
				Units->Second,
				Description->"The amount of time that the liquid nitrogen doser will have its solenoid actuated to allow for liquid nitrogen to be dispensed out of the nozzle. This is calculated based off of the nozzle size and dose rate of the liquid nitrogen doser, and the volume of the liquid nitrogen dewar.",
				Category->"Instrument Specifications"
			},
			CryoGlove->{
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Object[Item, Glove],
					Model[Item, Glove]
				],
				Description -> "The cryo gloves worn to protect the hands from ultra low temperature surfaces/fluids.",
				Category -> "General",
				Developer->True
			},
			CryoTransporterPlacements->{
				Format->Multiple,
				Class->{Link,Expression},
				Pattern:>{_Link,{LocationPositionP..}},
				Relation->{Alternatives[Object[Part,FillRod],Model[Part,FillRod],Object[Part,Funnel],Model[Part,Funnel]],Null},
				Description->"A list of placements used to place the cryopod parts into the cryopod.",
				Category->"Placements",
				Developer->True,
				Headers->{"CryoPod Part to Place","Placement"}
			},
			Tweezer->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Item],Object[Item]],
				Description->"The tweezer that will be used to immerse the sample container into the liquid nitrogen dewar during flash freezing.",
				Category->"General"
			},
			CryoTransporter -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Alternatives[
					Model[Instrument, PortableCooler],
					Object[Instrument, PortableCooler],
					(* Older protocols use: *)
					Model[Instrument, CryogenicFreezer],
					Object[Instrument, CryogenicFreezer]
				],
				Description -> "The transportable cryogenic freezer that will hold the sample during transportation.",
				Category -> "Instrument Specifications"
			},
			Funnel->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,Funnel],Object[Part,Funnel]],
				Description->"The funnel that will be used to fill the Cryotransporter with liquid nitrogen, to prepare it for the flash freezing protocol.",
				Category->"Instrument Specifications"
			},
			FillRod->{
				Format->Single,
				Class->Link,
				Pattern:>_Link,
				Relation->Alternatives[Model[Part,FillRod],Object[Part,FillRod]],
				Description->"The fill rod that will be used when filling the Cryotransporter with liquid nitrogen, to prepare it for the flash freezing protocol.",
				Category->"Instrument Specifications"
			},

			(*Freezing specific*)
			FreezingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"For each member of SamplesIn, the amount of time it takes to achieve freezing of the sample during the freeze step.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			FreezeUntilFrozen->{
				Format->Multiple,
				Class->Boolean,
				Pattern:>BooleanP,
				Description->"For each member of SamplesIn, indicates if freezing should be continued until the sample is entirely frozen, up to the MaxFreezingTime.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			MaxFreezingTime->{
				Format->Multiple,
				Class->Real,
				Pattern:>GreaterEqualP[0*Hour],
				Units->Hour,
				Description->"For each member of SamplesIn, the maximum amount of time allowed for flash freezing the sample.",
				Category->"General",
				IndexMatching->SamplesIn
			},
			EstimatedFreezingTime->{
				Format->Single,
				Class->Real,
				Pattern:>GreaterEqualP[0*Minute],
				Units->Second,
				Description->"An estimate of the total amount of freezing time required in this protocol, used for estimating Danger Zone time in the procedure.",
				Category->"General",
				Developer->True
			},

			(*Organizational*)
			FreezingStartTimes -> {
				Format -> Multiple,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "For each member of SamplesIn, the date when FreezingTime began.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> SamplesIn
			},
			FreezingEndTimes -> {
				Format -> Multiple,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Description -> "For each member of SamplesIn, the date when FreezingTime ended.",
				Category -> "General",
				Developer -> True,
				IndexMatching -> SamplesIn
			},
			TotalFreezingTimes -> {
				Format -> Multiple,
				Class -> Real,
				Pattern :> TimeP,
				Description -> "For each member of SamplesIn, the total amount of time that elapsed during freezing.",
				Category -> "General",
				Developer -> True,
				Units -> Minute,
				IndexMatching->SamplesIn
			},
			FlashFreezeLengths -> {
				Format -> Multiple,
				Class -> Integer,
				Pattern :> GreaterP[0],
				Description -> "The list of sizes corresponding to number of containers per batch, used for looping.",
				Category -> "Batching",
				Developer -> True
			},
			FlashFreezeParameters->{
				Format->Multiple,
				Class->{
					FreezingTime->Real,
					FreezeUntilFrozen->Boolean,
					MaxFreezingTime->Real
				},
				Pattern:>{
					FreezingTime->GreaterP[0*Minute],
					FreezeUntilFrozen->BooleanP,
					MaxFreezingTime->GreaterP[0*Hour]
				},
				Relation->{
					FreezingTime->Null,
					FreezeUntilFrozen->Null,
					MaxFreezingTime->Null
				},
				Units->{
					FreezingTime->Second,
					FreezeUntilFrozen->None,
					MaxFreezingTime->Hour
				},
				Headers->{
					FreezingTime->"Freezing Time",
					FreezeUntilFrozen->"Freeze Until Frozen",
					MaxFreezingTime->"Max Freezing Time"
				},
				IndexMatching->FlashFreezeLengths,
				Description->"For each member of FlashFreezeLengths, the experiment setup values given to perform the flash freeze experiment.",
				Category->"Batching",
				Developer->True
			},

			(* --- Cleanup Fields --- *)
			FullyFrozen -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "For each member of SamplesIn, indicates if the sample appears fully frozen upon visual inspection.",
				Category -> "Experimental Results",
				IndexMatching->SamplesIn
			},
			CurrentFullyFrozen -> {
				Format -> Multiple,
				Class -> Expression,
				Pattern :> BooleanP,
				Description -> "A field that will temporarily hold Lab Operator responses to whether samples are fully frozen before the information is transfered to the field FullyEvaporated.",
				Category -> "Experimental Results",
				Developer -> True
			}
		}
	}
];