(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Evaporate], {
	Description->"A protocol for concentrating samples via solvent evaporation in a low pressure environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {


		(* --- Shared Fields --- *)
		EvaporationTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> EvaporationTypeP,
			Description -> "For each member of PooledSamplesIn, the form of evaporation used to condense the sample.",
			Category -> "Evaporation"
		},
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The vacuum centrifuge, rotary evaporator, or nitrogen blower instruments used to evaporate the provided samples.",
			Category -> "Evaporation"
		},
		PressureRampTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "For each member of PooledSamplesIn, the amount of time it takes to evacuate the chamber until EquilibrationPressure is achieved.",
			Category -> "Equilibration",
			Abstract -> False,
			IndexMatching->PooledSamplesIn
		},
		EquilibrationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Minute],
			Units -> Minute,
			Description -> "For each member of PooledSamplesIn, the amount of time the samples are incubated in the instrument at the EvaporationTemperature.",
			Category -> "Equilibration",
			IndexMatching -> PooledSamplesIn,
			Abstract -> False
		},
		EvaporationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of PooledSamplesIn, the temperature that is maintained in the sample chamber of a speedvac or in the heatbath of a rotovap or nitrogen blower for the duration of the evaporation. Due to evaporative cooling, samples can become colder than this temperature during a run (but not warmer).",
			IndexMatching -> PooledSamplesIn,
			Category -> "Evaporation"
		},
		EvaporationPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Bar Milli,
			Description -> "For each member of PooledSamplesIn, the pressure at which the samples will be dried and concentrated after equilibration is completed.",
			IndexMatching -> PooledSamplesIn,
			Category -> "Evaporation",
			Abstract -> True
		},
		EvaporationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "For each member of PooledSamplesIn, the amount of time, after equilibration is achieved, that the samples continue to undergo evaporation and concentration at the specified Temperatures and EvaporationPressures.",
			IndexMatching -> PooledSamplesIn,
			Category -> "Evaporation",
			Abstract -> True
		},
		EvaporateUntilDry ->{
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of PooledSamplesIn, indicates if the final evaporation step should be continued up to the MaxEvaporationTime, in an attempt fully dry the sample.",
			Category->"Evaporation",
			IndexMatching->PooledSamplesIn
		},
		MaxEvaporationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "For each member of PooledSamplesIn, maximum duration of time for which the samples will be evaporated in an attempt to fully dry the sample, if EvaporateUntilDry is True.",
			Category -> "Evaporation",
			IndexMatching->PooledSamplesIn
		},


		(* --- Vacuum Centrifugation Specific --- *)
		VacuumEvaporationMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,VacuumEvaporation],
			Description -> "For each member of PooledSamplesIn, the method used to concentrate samples during this evaporation experiment.",
			Category -> "General",
			Developer->True,
			IndexMatching->PooledSamplesIn
		},
		CentrifugalForces -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "For each member of PooledSamplesIn, the forces (RCF) exerted on the samples as a result of centrifuging them to prevent sample bumping.",
			Category -> "Instrument Specifications",
			IndexMatching->PooledSamplesIn
		},
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The balance instrument used to weigh the centrifuge buckets to ensure the vacuum centrifuge is balanced properly.",
			Category -> "Instrument Specifications"
		},
		BucketWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weights of the centrifuge buckets, with all sample containers loaded.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Counterbalances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The weighted containers placed opposite the unbalanced container to ensure balanced centrifugation.",
			Category -> "Instrument Specifications"
		},
		CounterbalancePrepManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,SampleManipulation],
				Object[Protocol, RoboticSamplePreparation],
				Object[Protocol, ManualSamplePreparation],
				Object[Notebook, Script]
			],
			Description -> "The set of instructions specifying the transfer of balance solvent to the Counterbalances for balancing the vacuum centrifuge during evaporation.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		CounterbalancePrepPrimitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleManipulationP, SamplePreparationP],
			Description -> "The list of manipulations used to generated CounterbalancePrepManipulation.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		CentrifugeBuckets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The centrifuge buckets used to place containers into the vacuum centrifuge.",
			Category -> "Instrument Specifications"
		},
		BucketBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of centrifuge rack holders (aka centrifgue buckets) that are needed per evaporation batch.",
			Developer -> True,
			Category -> "Batching"
		},
		CentrifugeRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The centrifuge racks used to hold tubes or vials in the centrifuge buckets that are placed in the vacuum centrifuge.",
			Category -> "Instrument Specifications"
		},
		RackBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of centrifuge container holders, per batch, needed to hold containers inside the centrifuge buckets.",
			Developer -> True,
			Category -> "Batching"
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Object[Container],Model[Container]], Alternatives[Object[Container],Model[Container]], Null},
			Description -> "A list of placements used to place the containers to be evaporated in the appropriate positions of the vacuum centrifuge buckets for the current batch.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Destination Object","Destination Position"}
		},
		ContainerPlacementLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of movement of containers into other containers per batch, in order to situate the balanced containers in the proper locations.",
			Developer -> True,
			Category -> "Batching"
		},
		BucketPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Object[Container],Model[Container]], Alternatives[Object[Container],Model[Container],Object[Instrument],Model[Instrument]], Null},
			Description -> "A list of placements used to place the centrifuge buckets in the appropriate positions of the vacuum centrifuge rotor.",
			Category -> "Instrument Specifications",
			Developer -> True,
			Headers->{"Object to Place", "Destination Object","Destination Position"}
		},
		BalancingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to counterbalance samples during evaporation, if a counterbalance is needed. The solution will be exposed to the vacuum chamber and will evaporate during the course of the evaporation.",
			Category -> "Instrument Specifications"
		},

		(* --- Rotary Evaporation ---*)
		BathFluids -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "For each member of PooledSamplesIn, solution to be used at the heating medium and will be added to the instrument's heatbath at the start of the evaporation process.",
			Category -> "Instrument Specifications",
			IndexMatching -> PooledSamplesIn
		},
		EvaporationFlasks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description -> "For each member of PooledSamplesIn, the container that will hold the sample mixture and rotate while partially submerged in the instrument's heatbath.",
			Category -> "Container Specifications",
			IndexMatching -> PooledSamplesIn
		},
		CondensationFlasks  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description -> "For each member of PooledSamplesIn, the container used to collect any condensate generated by cooling solvent vapors evaporated out of the evaporated sample.",
			Category -> "Container Specifications",
			IndexMatching -> PooledSamplesIn,
			Developer -> True
		},
		CondensationFlaskClamp -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part,Clamp],
				Object[Part,Clamp]
			],
			Description -> "The metal clamp that is used to hold the CondensationFlask together with the Condensor for RotaryEvaporation protocols.",
			Category -> "Container Specifications",
			Developer -> True
		},
		EvaporationFlaskClamp -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item,Clamp],
				Object[Item,Clamp]
			],
			Description -> "The plastic keck clamp that is used to hold the BumpTrap/EvporationFlask together with the instrument arm for RotaryEvaporation protocols.",
			Category -> "Container Specifications",
			Developer -> True
		},
		BumpTraps -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,BumpTrap],
				Object[Container,BumpTrap]
			],
			Description -> "For each member of PooledSamplesIn, the glassware used to collect material that boils out of the evaporation flask during rotovap evaporation.",
			Category -> "Container Specifications",
			IndexMatching -> PooledSamplesIn
		},
		RotationRates -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "For each member of PooledSamplesIn, the rotation speeds at which samples are rotated during evaporation to prevent sample bumping.",
			Category -> "Evaporation"
		},
		CondenserTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "For each member of PooledSamplesIn, the temperature of the cooling coil used to condense solvent vapors created by evaporation of the sample.",
			Category -> "Evaporation",
			IndexMatching -> PooledSamplesIn
		},
		CollectEvaporatedSolvent -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of PooledSamplesIn, determines whether any condensed solvent that has been evaporated from the pooled samples will be stored or disposed of at the end of the run.",
			Category -> "Storage Information",
			IndexMatching -> PooledSamplesIn
		},
		BumpTrapRinseSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Sample,StockSolution],
				Object[Sample],
				Object[Sample]
			],
			Description -> "For each member of PooledSamplesIn, indicates which solution will be used to resuspend or dissolve any solid material that has accumulated in the BumpTrap.",
			Category -> "Storage Information",
			IndexMatching -> PooledSamplesIn
		},
		BumpTrapRinseVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "For each member of PooledSamplesIn, indicates how much BumpTrapRinseSolution will be used to resuspend or dissolve any solid material that has accumulated in the BumpTrap.",
			Category -> "Storage Information",
			IndexMatching -> PooledSamplesIn
		},

		BumpTrapSampleContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of PooledSamplesIn, the container into which recouped sample from the bump trap is collected.",
			Category -> "Experimental Results",
			IndexMatching -> PooledSamplesIn
		},
		CondensateRecoveryContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of PooledSamplesIn, the container into which condensate is transferred.",
			Category -> "Experimental Results",
			IndexMatching -> PooledSamplesIn
		},
		TransferAllPlaceholder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> All,
			Description -> "The amount of sample that is transferred from CondensationFlask to CondensateRecoveryContainers if RecoupCondensate is True.",
			Category -> "Storage Information",
			Developer -> True
		},

		(* --- Nitrogen Blower --- *)

		FlowRateProfiles -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[{GreaterP[0*(Liter/Minute)], GreaterP[0*Second]}],
			Description -> "For each member of PooledSamplesIn, the rate of Nitrogen flow through the nitrogen blower instrument.",
			Category -> "General"
		},

		(* --- Nitrogen Blower/TurboVap Specific --- *)
		NitrogenBlowerRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The sample racks used to hold samples when placed in the Nitrogen blower instrument.",
			Category -> "Instrument Specifications"
		},

		NozzlePlugs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part],
				Object[Part]
			],
			Description -> "The rubber plugs used to stop gas flow from nozzles corresponding to empty positions on the Tube Dryer instrument.",
			Category -> "Instrument Specifications"
		},

		DrainTube -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Plumbing,Tubing],
				Object[Plumbing,Tubing]
			],
			Description -> "The drain tube used to empty the water bath of the Tube Dryer instrument at the end of the experiment run.",
			Category -> "Instrument Specifications"
		},

		Funnel -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,GraduatedCylinder],
				Object[Container,GraduatedCylinder]
			],
			Description -> "The plastic device used to divert water through the tube rack hole and into the water bath of the Tube Dryer instrument.",
			Category -> "Instrument Specifications"
		},

		WasteContainer ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Vessel],
				Object[Container,Vessel]
			],
			Description -> "The vessel used to contain the waste bathwater.",
			Category -> "Instrument Specifications"
		},

		(* --- Parallelization and Batching Fields --- *)
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of containers per batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Units -> None,
			Description -> "The list of containers that will have their contents dried simultaneously as part of the same 'batch'.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Units -> None,
			Description -> "The list of samples that will be dried simultaneously as part of the same 'batch'.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedSampleLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The number of samples per 'batch' in an evaporation group.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedCounterbalances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "The weighted containers placed opposite the unbalanced container to ensure balanced centrifugation.",
			Category -> "Batching"
		},
		BatchCounterbalanceLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of counterbalances per batch.",
			Category -> "Batching",
			Developer -> True
		},
		BucketRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Alternatives[Object[Container],Model[Container]], Alternatives[Object[Container],Model[Container]], Null},
			IndexMatching -> BatchedContainers,
			Description -> "For each member of BatchedContainers, placement instructions specifying the locations in the tube rack where the target containers are placed.",
			Category -> "Batching",
			Headers -> {"Object to Place","Destination Object","Destination Position"},
			Developer->True
		},
		BatchedEvaporationParameters -> {
			Format -> Multiple,
			Class -> {
				EvaporationType -> Expression,
				Instrument -> Link,
				EquilibrationTime -> Real,
				EvaporationTime -> Real,
				EvaporationTemperature -> Real,
				EvaporateUntilDry -> Boolean,
				MaxEvaporationTime -> Real,

				(* Shared SV and RV not NB *)
				PressureRampTime -> Real,
				EvaporationPressure -> Real,

				(* Shared RV and NB not SV *)
				BathFluid -> Link,

				(* Rotovap *)
				RotationRate -> Real,
				CondenserTemperature -> Real,
				BumpTrap -> Link,
				EvaporationFlask -> Link,
				CondensationFlask -> Link,
				CollectEvaporatedSolvent -> Boolean,
				RinseSolution -> Link,
				RinseVolume -> Real,
				BumpTrapRinseSolution -> Link,
				BumpTrapRinseVolume -> Real,

				(* Speed Vac *)
				Balance -> Link,
				BalancingSolution -> Link,
				VacuumEvaporationMethod -> Link,

				(* Nitrogen Blower *)
				FlowRateProfile -> Expression,

				(* Organizational *)
				BatchNumber -> Integer,

				(* added later, seemingly must be added at the end *)
				BumpTrapSampleContainer -> Link,
				CondensateRecoveryContainer -> Link,
				EvaporationPressureProfile -> Expression,
				EvaporationPressureProfileImage -> Link
			},
			Pattern :> {
				EvaporationType -> EvaporationTypeP,
				Instrument -> _Link,
				EquilibrationTime -> GreaterEqualP[0 Minute],
				EvaporationTime -> GreaterP[0 Minute],
				EvaporationTemperature -> GreaterP[0 Kelvin],
				EvaporateUntilDry -> BooleanP,
				MaxEvaporationTime -> GreaterP[0 Minute],

				(* Shared SV and RV not NB *)
				PressureRampTime -> GreaterP[0 Minute],
				EvaporationPressure -> GreaterEqualP[0 Milli Bar],

				(* Shared RV and NB not SV *)
				BathFluid -> _Link,

				(* Rotovap *)
				RotationRate -> GreaterEqualP[0*RPM],
				CondenserTemperature -> GreaterP[0*Kelvin],
				BumpTrap -> _Link,
				EvaporationFlask -> _Link,
				CondensationFlask -> _Link,
				CollectEvaporatedSolvent -> BooleanP,
				RinseSolution -> _Link,
				RinseVolume -> GreaterEqualP[0*Milliliter],
				BumpTrapRinseSolution -> _Link,
				BumpTrapRinseVolume -> GreaterEqualP[0*Milliliter],

				(* Speed Vac *)
				Balance -> _Link,
				BalancingSolution -> _Link,
				VacuumEvaporationMethod -> _Link,

				(* Nitrogen Blower *)
				FlowRateProfile -> ListableP[{GreaterP[0*(Liter/Minute)], GreaterP[0*Second]}],

				(* Organizational *)
				BatchNumber -> GreaterP[0,1],

				(* added later, seemingly must be added at the end *)
				BumpTrapSampleContainer -> _Link,
				CondensateRecoveryContainer -> _Link,
				EvaporationPressureProfile -> {{GreaterEqualP[0 Milli Bar], GreaterEqualP[0*RPM], GreaterEqualP[0 Minute]}...},
				EvaporationPressureProfileImage -> _Link
			},
			Relation -> {
				EvaporationType -> Null,
				Instrument -> Alternatives[
					Model[Instrument,VacuumCentrifuge],
					Object[Instrument,VacuumCentrifuge],
					Model[Instrument,RotaryEvaporator],
					Object[Instrument,RotaryEvaporator],
					Model[Instrument,NeedleDryer],
					Object[Instrument,NeedleDryer],
					Model[Instrument,Evaporator],
					Object[Instrument,Evaporator]
				],
				EquilibrationTime -> Null,
				EvaporationTime -> Null,
				EvaporationTemperature -> Null,
				EvaporateUntilDry -> Null,
				MaxEvaporationTime -> Null,

				(* Shared SV and RV not NB *)
				PressureRampTime -> Null,
				EvaporationPressure -> Null,

				(* Shared RV and NB not SV *)
				BathFluid -> Alternatives[Model[Sample],Object[Sample]],

				(* Rotovap *)
				RotationRate -> Null,
				CondenserTemperature -> Null,
				BumpTrap -> Alternatives[Model[Container,BumpTrap],Object[Container,BumpTrap]],
				EvaporationFlask -> Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
				CondensationFlask -> Alternatives[Model[Container,Vessel],Object[Container,Vessel]],
				CollectEvaporatedSolvent -> Null,
				RinseSolution -> Alternatives[Model[Sample,StockSolution],Object[Sample],Model[Sample],Object[Sample]],
				RinseVolume -> Null,
				BumpTrapRinseSolution -> Alternatives[Model[Sample,StockSolution],Object[Sample],Model[Sample],Object[Sample]],
				BumpTrapRinseVolume -> Null,

				(* Speed Vac *)
				Balance -> Alternatives[Model[Instrument,Balance],Object[Instrument,Balance]],
				BalancingSolution -> Alternatives[Model[Sample,StockSolution],Object[Sample],Model[Sample],Object[Sample]],
				VacuumEvaporationMethod -> Alternatives[Object[Method,VacuumEvaporation]],

				(* Nitrogen Blower *)
				FlowRateProfile -> Null,

				(* Organizational *)
				BatchNumber -> Null,

				(* added later, seemingly must be added at the end *)
				BumpTrapSampleContainer -> Alternatives[Model[Container], Object[Container]],
				CondensateRecoveryContainer -> Alternatives[Model[Container], Object[Container]],
				EvaporationPressureProfile -> Null,
				EvaporationPressureProfileImage -> Object[EmeraldCloudFile]
			},
			Units -> {
				EvaporationType -> None,
				Instrument -> None,
				EquilibrationTime -> Minute,
				EvaporationTime -> Hour,
				EvaporationTemperature -> Celsius,
				EvaporateUntilDry -> None,
				MaxEvaporationTime -> Hour,

				(* Shared SV and RV not NB *)
				PressureRampTime -> Hour,
				EvaporationPressure -> Milli*Bar,

				(* Shared RV and NB not SV *)
				BathFluid -> None,

				(* Rotovap *)
				RotationRate -> RPM,
				CondenserTemperature -> Celsius,
				BumpTrap -> None,
				EvaporationFlask -> None,
				CondensationFlask -> None,
				CollectEvaporatedSolvent -> None,
				RinseSolution -> None,
				RinseVolume -> Milliliter,
				BumpTrapRinseSolution -> None,
				BumpTrapRinseVolume -> Milliliter,

				(* Speed Vac *)
				Balance -> None,
				BalancingSolution -> None,
				VacuumEvaporationMethod -> None,

				(* Nitrogen Blower *)
				FlowRateProfile -> None,

				(* Organizational *)
				BatchNumber -> None,

				(* added later, seemingly must be added at the end *)
				BumpTrapSampleContainer -> None,
				CondensateRecoveryContainer -> None,
				EvaporationPressureProfile -> None,
				EvaporationPressureProfileImage -> None
			},
			Headers -> {
				EvaporationType -> "Type",
				Instrument -> "Instrument",
				EquilibrationTime -> "Temperature Equilibration Time",
				EvaporationTime -> "Evaporation Time",
				EvaporationTemperature -> "Evaporation Temperature",
				EvaporateUntilDry -> "Evaporate Until Dry",
				MaxEvaporationTime -> "Max Evaporation Time",

				(* Shared SV and RV not NB *)
				PressureRampTime -> "PressureRampTime",
				EvaporationPressure -> "EvaporationPressure",

				(* Shared RV and NB not SV *)
				BathFluid -> "BathFluid",

				(* Rotovap *)
				RotationRate -> "RotationRate",
				CondenserTemperature -> "CondenserTemperature",
				BumpTrap -> "BumpTrap",
				EvaporationFlask -> "EvaporationFlask",
				CondensationFlask -> "CondensationFlask",
				CollectEvaporatedSolvent -> "CollectEvaporatedSolvent",
				RinseSolution -> "RinseSolution",
				RinseVolume -> "RinseVolume",
				BumpTrapRinseSolution -> "BumpTrapRinseSolution",
				BumpTrapRinseVolume -> "BumpTrapRinseVolume",

				(* Speed Vac *)
				Balance -> "Balance",
				BalancingSolution -> "BalancingSolution",
				VacuumEvaporationMethod -> "VacuumEvaporationMethod",

				(* Nitrogen Blower *)
				FlowRateProfile -> "FlowRateProfile",

				(* Organizational *)
				BatchNumber -> "BatchNumber",

				(* added later, seemingly must be added at the end *)
				BumpTrapSampleContainer -> "BumpTrapSampleContainer",
				CondensateRecoveryContainer -> "CondensateRecoveryContainer",
				EvaporationPressureProfile -> "EvaporationPressureProfile",
				EvaporationPressureProfileImage -> "PressureGradientImage"

			},
			IndexMatching -> BatchLengths,
			Description -> "For each member of BatchLengths, the measurement setup values shared by each container in the batch, no matter the evaporation type.",
			Category -> "Batching",
			Developer -> True
		},

		(*TODO: Need transfer primitives from WorkingSamples into EvapFlask??*)
		BatchedConnectionLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of connections per batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedConnections -> {
			Format -> Multiple,
			Class -> {Link,String,Link,String},
			Pattern :> {_Link,ConnectorNameP,_Link,ConnectorNameP},
			Relation -> {
				Alternatives[Object[Instrument],Object[Plumbing],Object[Container],Object[Item],Model[Instrument],Model[Plumbing],Model[Container],Model[Item]],
				Null,
				Alternatives[Object[Instrument],Object[Plumbing],Object[Container],Object[Item],Model[Instrument],Model[Plumbing],Model[Container],Model[Item]],
				Null
			},
			Description -> "The plumbing connections that will be made during the experiment, as organized for evaporation batch.",
			Headers -> {"Plumbing A","Plumbing A Connector Name","Plumbing B","Plumbing B Connector Name"},
			Category -> "Batching",
			Developer -> True
		},
		BatchedContainerIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedSampleIndexes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The index in WorkingContainers of each container in BatchedContainer lengths.",
			Category -> "Batching",
			Developer -> True
		},
		BathActualTemperature -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "A field used to record the actual temperature of the heat block while the instrument is incubating the sample.",
			Category -> "Evaporation",
			Developer -> True
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "The estimated amount of time remaining until when the current round of instrument processing is projected to finish.",
			Category -> "Batching",
			Units -> Hour,
			Developer -> True
		},
		(* The following are required to determine when a particular evaporation run was started when running multiple evaporations in parallel *)
		EvaporationStartTimes -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "For each member of BatchLengths, the date when EquilibrationTemperatureTimes (if relevant) or EvaporationTime began.",
			Category -> "Batching",
			Developer -> True,
			IndexMatching -> BatchLengths
		},
		EvaporationEndTimes -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "For each member of BatchLengths, the date when EquilibrationTemperatureTimes (if relevant) or EvaporationTime began.",
			Category -> "Batching",
			Developer -> True,
			IndexMatching -> BatchLengths
		},
		TotalEvaporationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "For each member of BatchLengths, total amount of time that elapsed during evaporation.",
			Category -> "Batching",
			Developer -> True,
			Units -> Hour,
			IndexMatching -> BatchLengths
		},
		EvaporationReady -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchLengths, indicates whether the Batch has may begin.",
			Category -> "Batching",
			IndexMatching -> BatchLengths,
			Developer -> True
		},
		CleanUpReady -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchLengths, indicates whether the Batch has completed evaporation, the instrument can be cleaned, and samples can be put away.",
			Category -> "Batching",
			IndexMatching -> BatchLengths,
			Developer -> True
		},
		EvaporationComplete -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of BatchLengths, indicates whether the Batch has fully completed Evaporation.",
			Category -> "Batching",
			Developer -> True
		},
		CurrentEquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Description -> "Indicates what the current wait time is required for an instrument to reach temperature, and will be updated once per batch.",
			Category -> "Batching",
			Developer -> True,
			Units -> Hour
		},
		ReadyCheckResourcePlaceholders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "A list of temporary resources built to make sure the operators can actually begin the protocol.",
			Category -> "Batching",
			Developer -> True
		},

		(* --- Cleanup Fields --- *)
		FullyEvaporated -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of PooledSamplesIn, indicates if the sample appears fully dried upon visual inspection.",
			Category -> "Experimental Results",
			IndexMatching -> PooledSamplesIn
		},
		CurrentFullyEvaporated -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "A field that will temporarily hold Lab Operator responses to whether samples are fully evaporated before the information is transfered to the field FullyEvaporated.",
			Category -> "Experimental Results",
			Developer -> True
		},
		CurrentWasteWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the waste solvent container of the rotovap or speedvac at the start of the current evaporation batch.",
			Category -> "Sensor Information",
			Developer -> True
		},
		WasteWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the waste solvent container of the rotovap or speedvac at the start of the evaporation protocol.",
			Category -> "Sensor Information",
			Developer -> True
		}
	}
}];
