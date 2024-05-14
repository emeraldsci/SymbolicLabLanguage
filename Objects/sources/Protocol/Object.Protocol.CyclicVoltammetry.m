(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, CyclicVoltammetry], {
	Description->"A protocol to perform cyclic voltammetry measurements of the input samples, using an electrochemical reactor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* Instrument Setup *)
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Reactor, Electrochemical],
				Object[Instrument, Reactor, Electrochemical]
			],
			Description -> "The instrument scans the potential (within a practical range) applied between the WorkingElectrode and the CounterElectrode inserted in the LoadingSample solution, and measures the potential difference between the WorkingElectrode and the ReferenceElectrode, and therefore performs the cyclic voltammetry measurements.",
			Category -> "General"
		},
		ReactionVesselHolder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The part attached to the cyclic voltammetry instrument that fix and support the reaction vessel(s) stable during the measurements.",
			Category -> "General"
		},
		Analytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "For each member of SamplesIn, indicates the molecule whose cyclic voltammograms are measured.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		WorkingElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Electrode],
				Object[Item, Electrode]
			],
			Description -> "The electrode whose potential is linearly and periodically swept to trigger the local reduction and oxidation of the target analyte (SamplesIn for solid inputs) during the cyclic voltammetry measurement.",
			Category -> "General"
		},
		CounterElectrode -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Electrode],
				Object[Item, Electrode]
			],
			Description -> "The electrode inserted into the same LoadingSample solution as the WorkingElectrode to form a complete electrical circuit.",
			Category -> "General"
		},
		ReferenceElectrodes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Electrode, ReferenceElectrode],
				Object[Item, Electrode, ReferenceElectrode]
			],
			Description -> "For each member of SamplesIn, indicates the electrode whose potential stays constant during the cyclic voltammetry measurement, and therefore can be used as reference point for the WorkingElectrode.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		ElectrodeCap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Cap, ElectrodeCap], Object[Item, Cap, ElectrodeCap]],
			Description -> "The cap of the ReactionVessel, which holds the WorkingElectrode, ReferenceElectrode, and CounterElectrode, and conductively connects them to the Instrument.",
			Category -> "General"
		},
		ReactionVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, ReactionVessel, ElectrochemicalSynthesis],
				Object[Container, ReactionVessel, ElectrochemicalSynthesis]
			],
			Description -> "For each member of SamplesIn, indicates the container used to hold the LoadingSample solution to be measured, which the WorkingElectrode, ReferenceElectrode, and CounterElectrode are inserted into.",
			Category -> "General",
			IndexMatching -> SamplesIn
		},
		WorkingElectrodeWiringConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "Indicates the wiring connection information for attaching the working electrode to the electrode cap.",
			Headers -> {"Working Electrode to Connect","Electrode Wiring Connector Name","Electrode Cap to Connect","Cap Wiring Connector Name"},
			Category -> "General",
			Developer -> True
		},
		CounterElectrodeWiringConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "Indicates the wiring connection information for attaching the counter electrode to the electrode cap.",
			Headers -> {"Counter Electrode to Connect","Electrode Wiring Connector Name","Electrode Cap to Connect","Cap Wiring Connector Name"},
			Category -> "General",
			Developer -> True
		},
		ReferenceElectrodeWiringConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Wiring],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "For each member of SamplesIn, indicates the wiring connection information for attaching the reference electrode to the electrode cap.",
			Headers -> {"Reference Electrode to Connect","Electrode Wiring Connector Name","Electrode Cap to Connect","Cap Wiring Connector Name"},
			Category -> "General",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, FumeHood], Object[Instrument, FumeHood]],
			Description -> "Indicates the fume hood where the electrode polishing and washing tasks are performed.",
			Category -> "General",
			Developer -> True
		},
		ElectrodeImagingRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "Indicates the rack to hold the working, counter and reference electrodes when they are imaged.",
			Category -> "General",
			Developer -> True
		},
		ReferenceElectrodeRack -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Rack], Object[Container, Rack]],
			Description -> "Indicates the rack used to hold the reference electrodes upwards during the course of the current protocol.",
			Category -> "General",
			Developer -> True
		},

		(* Working Electrode Polishing *)
		PrimaryPolishings -> {
			Format -> Multiple,
			Class -> {
				PolishingPad -> Link,
				PolishingSolution -> Link,
				PolishingPlate -> Link,
				NumberOfDroplets -> Integer,
				NumberOfPolishings -> Integer
			},
			Pattern :> {
				PolishingPad -> _Link,
				PolishingSolution -> _Link,
				PolishingPlate -> _Link,
				NumberOfDroplets -> GreaterP[0, 1],
				NumberOfPolishings -> GreaterP[0, 1]
			},
			Relation -> {
				PolishingPad -> Alternatives[Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]],
				PolishingSolution -> Alternatives[Model[Sample], Object[Sample]],
				PolishingPlate -> Alternatives[Model[Item, ElectrodePolishingPlate], Object[Item, ElectrodePolishingPlate]],
				NumberOfDroplets -> Null,
				NumberOfPolishings -> Null
			},
			Headers -> {
				PolishingPad -> "Polishing Pad",
				PolishingSolution -> "Polishing Solution",
				PolishingPlate -> "Polishing Plate",
				NumberOfDroplets -> "Number Of Polishing Solution Droplets",
				NumberOfPolishings -> "Number Of Polishings"
			},
			Description -> "For each member of SamplesIn, indicates the polishing pad, polishing solution, the number of polishing solution droplets added onto the polishing pad, and the number of polishings for the first polishing in the working electrode polishing process.",
			Category -> "Electrode Polishing",
			IndexMatching -> SamplesIn
		},
		SecondaryPolishings -> {
			Format -> Multiple,
			Class -> {
				PolishingPad -> Link,
				PolishingSolution -> Link,
				PolishingPlate -> Link,
				NumberOfDroplets -> Integer,
				NumberOfPolishings -> Integer
			},
			Pattern :> {
				PolishingPad -> _Link,
				PolishingSolution -> _Link,
				PolishingPlate -> _Link,
				NumberOfDroplets -> GreaterP[0, 1],
				NumberOfPolishings -> GreaterP[0, 1]
			},
			Relation -> {
				PolishingPad -> Alternatives[Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]],
				PolishingSolution -> Alternatives[Model[Sample], Object[Sample]],
				PolishingPlate -> Alternatives[Model[Item, ElectrodePolishingPlate], Object[Item, ElectrodePolishingPlate]],
				NumberOfDroplets -> Null,
				NumberOfPolishings -> Null
			},
			Headers -> {
				PolishingPad -> "Polishing Pad",
				PolishingSolution -> "Polishing Solution",
				PolishingPlate -> "Polishing Plate",
				NumberOfDroplets -> "Number Of Polishing Solution Droplets",
				NumberOfPolishings -> "Number Of Polishings"
			},
			Description -> "For each member of SamplesIn, indicates the polishing pad, polishing solution, the number of polishing solution droplets added onto the polishing pad, and the number of polishings for the second polishing in the working electrode polishing process.",
			Category -> "Electrode Polishing",
			IndexMatching -> SamplesIn
		},
		TertiaryPolishings -> {
			Format -> Multiple,
			Class -> {
				PolishingPad -> Link,
				PolishingSolution -> Link,
				PolishingPlate -> Link,
				NumberOfDroplets -> Integer,
				NumberOfPolishings -> Integer
			},
			Pattern :> {
				PolishingPad -> _Link,
				PolishingSolution -> _Link,
				PolishingPlate -> _Link,
				NumberOfDroplets -> GreaterP[0, 1],
				NumberOfPolishings -> GreaterP[0, 1]
			},
			Relation -> {
				PolishingPad -> Alternatives[Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]],
				PolishingSolution -> Alternatives[Model[Sample], Object[Sample]],
				PolishingPlate -> Alternatives[Model[Item, ElectrodePolishingPlate], Object[Item, ElectrodePolishingPlate]],
				NumberOfDroplets -> Null,
				NumberOfPolishings -> Null
			},
			Headers -> {
				PolishingPad -> "Polishing Pad",
				PolishingSolution -> "Polishing Solution",
				PolishingPlate -> "Polishing Plate",
				NumberOfDroplets -> "Number Of Polishing Solution Droplets",
				NumberOfPolishings -> "Number Of Polishings"
			},
			Description -> "For each member of SamplesIn, indicates the polishing pad, polishing solution, the number of polishing solution droplets added onto the polishing pad, and the number of polishings for the third polishing in the working electrode polishing process.",
			Category -> "Electrode Polishing",
			IndexMatching -> SamplesIn
		},
		WorkingElectrodePolishWashingSolutions -> {
			Format -> Multiple,
			Class -> {
				Primary -> Link,
				Secondary -> Link
			},
			Pattern :> {
				Primary -> _Link,
				Secondary -> _Link
			},
			Relation -> {
				Primary -> Alternatives[Model[Sample], Object[Sample]],
				Secondary -> Alternatives[Model[Sample], Object[Sample]]
			},
			Headers -> {
				Primary -> "Primary Washing Solution",
				Secondary -> "Secondary Washing Solution"
			},
			Description -> "For each member of SamplesIn, indicates if the solutions used to wash the working electrode after the working electrode is polished. The washing process includes \"Milli-Q\" water and methanol squirted from a wash bottle against the electrode in sequence. For the working electrode, a chemwipe damped with the methanol is used to carefully wipe its bottom surface. The electrode is blow dried with nitrogen gas at the end.",
			Category -> "Electrode Polishing",
			IndexMatching -> SamplesIn
		},
		UniquePolishingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Indicates the unique polishing solutions used during the working electrode polishing process.",
			Category -> "Electrode Polishing"
		},
		UniquePolishingSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of UniquePolishingSolutions, indicates the volume required by this protocol.",
			Category -> "Electrode Polishing",
			IndexMatching -> UniquePolishingSolutions
		},
		UniquePolishingPads -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, ElectrodePolishingPad], Object[Item, ElectrodePolishingPad]],
			Description -> "Indicates the unique polishing pads used during the working electrode polishing process.",
			Category -> "Electrode Polishing"
		},
		UniquePolishingPlates -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, ElectrodePolishingPlate], Object[Item, ElectrodePolishingPlate]],
			Description -> "For each member of UniquePolishingPads, indicates the plate used to support the polishing pad during the working electrode polishing process.",
			Category -> "Electrode Polishing",
			IndexMatching -> UniquePolishingPads
		},

		(* Working Electrode Sonication *)
		(* TODO: subprotocols for sonications *)
		WorkingElectrodeSonicationTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Second],
			Units -> Second,
			Description -> "For each member of SamplesIn, indicates the duration for each working electrode sonication process. If the current sonication time is 0 second, the sonication process is skipped.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn
		},
		WorkingElectrodeSonicationTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Kelvin],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, indicates the sonication bath temperature for each working electrode sonication process.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn
		},
		WorkingElectrodeSonicationContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "The container to hold the working electrode during the working electrode sonication process.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},
		WorkingElectrodeSonicationSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "The type of solvent to put into the WorkingElectrodeSonicationContainer along with the working electrode during the working electrode sonication process.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},
		WorkingElectrodeSonicationSolventVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of solvent to put into the WorkingElectrodeSonicationContainer along with the working electrode during the working electrode sonication process.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},

		(* Working and Counter Electrodes Washing *)
		WorkingElectrodeWashingSolutions -> {
			Format -> Multiple,
			Class -> {
				Primary -> Link,
				Secondary -> Link
			},
			Pattern :> {
				Primary -> _Link,
				Secondary -> _Link
			},
			Relation -> {
				Primary -> Alternatives[Model[Sample], Object[Sample]],
				Secondary -> Alternatives[Model[Sample], Object[Sample]]
			},
			Headers -> {
				Primary -> "Primary Washing Solution",
				Secondary -> "Secondary Washing Solution"
			},
			Description -> "For each member of SamplesIn, indicates if the working electrode washing is performed. An electrode washing process includes \"Milli-Q\" water and methanol squirted from a wash bottle against the electrode in sequence. For the working electrode, a Chemwipe damped with the methanol is used to carefully wipe its bottom surface. After the washing, the electrode is blow tap dried with a piece of Chemwipe.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn
		},
		CounterElectrodeWashingSolutions -> {
			Format -> Multiple,
			Class -> {
				Primary -> Link,
				Secondary -> Link
			},
			Pattern :> {
				Primary -> _Link,
				Secondary -> _Link
			},
			Relation -> {
				Primary -> Alternatives[Model[Sample], Object[Sample]],
				Secondary -> Alternatives[Model[Sample], Object[Sample]]
			},
			Headers -> {
				Primary -> "Primary Washing Solution",
				Secondary -> "Secondary Washing Solution"
			},
			Description -> "For each member of SamplesIn, indicates if the counter electrode washing is performed. An electrode washing process includes \"Milli-Q\" water and methanol squirted from a wash bottle against the electrode in sequence. After the washing, the electrode is blow tap dried with a piece of Chemwipe.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn
		},
		WorkingElectrodeWashingCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0, 10, 1],
			Description -> "For each member of SamplesIn, indicates the number of washing cycles performed in the working electrode washing process. A washing cycle includes going through all the washing solutions specified in the WorkingElectrodeWashingSolutions option.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn
		},
		UniqueElectrodeWashingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Unique washing solution samples to wash the working-, counter-, reference electrodes.",
			Category -> "Electrode Cleaning"
		},
		UniqueElectrodeWashingSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of UniqueElectrodeWashingSolutions, the volume used during this protocol.",
			Category -> "Electrode Cleaning",
			IndexMatching -> UniqueElectrodeWashingSolutions
		},
		WashingSolutionsCollectionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "For each member of UniqueElectrodeWashingSolutions, the temporary container collects the electrode washing solution before the used solution is transferred into the waste container.",
			Category -> "Electrode Cleaning",
			IndexMatching -> UniqueElectrodeWashingSolutions
		},
		WashingWaterCollectionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "The temporary container collects the electrode washing water before the used solution is transferred into the waste container.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},
		WashingMethanolCollectionContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "The temporary container collects the electrode washing methanol before the used solution is transferred into the waste container.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},
		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Tweezer],
				Object[Item, Tweezer]
			],
			Description -> "The tweezers used to move the electrodes in and out of their containers.",
			Category -> "Electrode Cleaning",
			Developer -> True
		},
		DryWorkingElectrode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the working electrode should be dried with a piece of Chemwipe before the optional pretreatment or the cyclic voltammetry measurements.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		DryCounterElectrode -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the counter electrode should be dried with a piece of Chemwipe before the optional pretreatment or the cyclic voltammetry measurements.",
			Category -> "Electrode Cleaning",
			IndexMatching -> SamplesIn,
			Developer -> True
		},

		(* Reference Electrode Preparation *)
		RefreshReferenceElectrodes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the ReferenceElectrode is refreshed using the ReferenceSolution defined in the ReferenceElectrode.",
			Category -> "Reference Electrode Preparation",
			IndexMatching -> SamplesIn
		},
		ReferenceElectrodeSoakTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, the duration for which the soaking of the ReferenceElectrode within the ElectrolyteSolution or LoadingSample solution lasts.",
			Category -> "Reference Electrode Preparation",
			IndexMatching -> SamplesIn
		},
		CurrentReferenceElectrodeVesselContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "Indicates the current vessel container that holds the reference electrode after the reference electrode refresh. This is a helper field to store which container the reference electrode should be stored after the electrode is used, and will be updated for each reference electrode.",
			Category -> "Reference Electrode Preparation",
			Developer -> True
		},

		(* Electrode Pretreatment *)
		ElectrolyteSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the solution that contains a Solvent and an Electrolyte to be used during the electrodes pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		ElectrolyteSolutionLoadingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the loading volume of the ElectrolyteSolution into the ReactionVessel.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentReactionVessels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, ReactionVessel, ElectrochemicalSynthesis],
				Object[Container, ReactionVessel, ElectrochemicalSynthesis]
			],
			Description -> "For each member of SamplesIn, indicates the container used to hold the ElectrolyteSolution for the electrode pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> InertGasP,
			Description -> "For each member of SamplesIn, indicates the type of inert gas used for the sparging process before the cyclic voltammetry measurement.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, indicates the duration of the inert gas sparging of the ElectrolyteSolution for the electrode pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "For each member of SamplesIn, indicates the inert gas sparging pressure of the ElectrolyteSolution for the electrode pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingPressureLogs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure logs for the pretreatment sparging gas source for each SamplesIn.",
			Category -> "Electrode Pretreatment"
		},
		PretreatmentSpargingPreBubblers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel, GasWashingBottle], Object[Container, Vessel, GasWashingBottle]],
			Description -> "For each member of SamplesIn, indicates if a prebubbler is used before the electrode pretreatment reaction vessel. A prebubbler is a container containing the same Solvent used to prepare the LoadingSample, which is hooked in series with the reaction vessel, such that the gas is first bubbled through the prebubbler solution and then bubbled into the reaction vessel. This helps to ensure the reaction vessel doesn't excessively evaporate during the sparging, since the sparging gas is saturated by the solvent inside the prebubbler before travelling into the reaction vessel.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingPreBubblerSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the solvent sample loaded into the PreBubbler for ElectrolyteSolution sparging before the ElectrolyteSolution is used for the electrodes pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSpargingPreBubblerSolventVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the volume of Solvent is loaded into the PreBubbler for ElectrolyteSolution sparging before the ElectrolyteSolution is used for the electrodes pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentPrimaryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the electrode pretreatment potential details of the first pretreatment cycle. A pretreatment cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentSecondaryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the electrode pretreatment potential details of the second pretreatment cycle. A pretreatment cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentTertiaryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the electrode pretreatment potential details of the third pretreatment cycle. A pretreatment cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentQuaternaryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the electrode pretreatment potential details of the fourth pretreatment cycle. A pretreatment cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		PretreatmentNumberOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0, 4, 1],
			Description -> "For each member of SamplesIn, indicates the number of electrode pretreatment cycle performed. A pretreatment cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn
		},
		InstallPretreatmentSpargingPreBubblers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates the if the pre-bubbler assembly should be installed for the electrode pretreatment process.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		ElectrodePretreatmentDataPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, indicates the folder path in which the electrode pretreatment cyclic voltammetry data files generated by this protocol are stored.",
			Category -> "Electrode Pretreatment",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		ElectrodePretreatmentData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, indicates the data object containing the cyclic voltammetry results obtained during the electrode pretreatment process. The measures are performed using the parameters specified by PretreatmentPrimaryPotentials, PretreatmentSecondaryPotentials, PretreatmentTertiaryPotentials, and PretreatmentQuaternaryPotentials.",
			Category -> "Electrode Pretreatment"
		},
		ProtocolPath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Indicates the folder name in which the cyclic voltammetry data files generated by this protocol are stored.",
			Category -> "Experimental Results",
			Developer -> True
		},
		SamplesInPathPrefixes -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, indicates the unique file path prefix to identify the data files belong to the SamplesIn.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},

		(* Sample Preparation *)
		SampleDilutions -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the current SamplesIn is not fully prepared and further sample preparation steps are performed to generate the LoadingSample solution, which contains a Solvent, an Electrolyte, the SamplesIn, and an optional InternalStandard.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		SolidSampleAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the mass amount of solid SamplesIn used to prepare the LoadingSample solution.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleTargetConcentrations -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Millimolar], GreaterP[0 Milligram/Milliliter]],
			Description -> "For each member of SamplesIn, the concentration of SamplesIn in the prepared LoadingSample solution.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		Solvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the solvent sample identified from prepared liquid SamplesIn, or the solvent sample used to dissolve the solid SamplesIn, Electrolyte, and the optional InternalStandard to prepare the LoadingSample solution.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		RequestedSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Indicates the solvent sample requested to dissolve the solid SamplesIn, Electrolyte, and the optional InternalStandard to prepare the LoadingSample solution.",
			Category -> "Sample Preparation"
		},
		SolventVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the volume of solvent used to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		Electrolytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the chemical to be dissolved into the Solvent solution along with the solid SamplesIn and optional InternalStandard to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		RequestedElectrolytes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Indicates the electrolyte sample requested to be dissolved with the solid SamplesIn and the optional InternalStandard within the Solvent to prepare the LoadingSample solution.",
			Category -> "Sample Preparation"
		},
		LoadingSampleElectrolyteAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, the mass amount of electrolyte used to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		ElectrolyteTargetConcentrations -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Millimolar], GreaterP[0 Milligram/Milliliter]],
			Description -> "For each member of SamplesIn, the concentration of the electrolyte in the prepared LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},

		InternalStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the chemical used as a potential reference point and being dissolved in the same Pretreatment solution as the SamplesIn to prepare the LoadingSample solution, if the InternalStandardAdditionOrder if Before. If the InternalStandardAdditionOrder is After, the InternalStandard is added into the LoadingSample solution after the cyclic voltammetry measurements, In this case, the LoadingSample solution added with InternalStandard is measured again with the same potential parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		RequestedInternalStandards -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Indicates the internal standard sample requested to be dissolved with the solid SamplesIn and the Electrolyte to within the Solvent prepare the LoadingSample solution.",
			Category -> "Sample Preparation"
		},
		InternalStandardAdditionOrders -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Before | After,
			Description -> "For each member of SamplesIn, indicates the InternalStandard is added into LoadingSample solution before or after the cyclic voltammetry measurements. If the InternalStandardAdditionOrder is After, the LoadingSample solution added with InternalStandard is measured again with the same potential parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		InternalStandardAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milligram],
			Units -> Milligram,
			Description -> "For each member of SamplesIn, if InternalStandardAdditionOrder is Before for an unprepared solid SamplesIn, indicates the mass amount of InternalStandard added into LoadingSample solution during the LoadingSample preparation process. If InternalStandardAdditionOrder is Before for a prepared liquid SamplesIn, InternalStandardAmount is Null and please refer to SamplesIn for InternalStandard information.
			 If the InternalStandardAdditionOrder is After, the LoadingSample solution is added with this amount of InternalStandard and is measured again with the same potential parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		InternalStandardTargetConcentrations -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterP[0 Millimolar], GreaterP[0 Milligram/Milliliter]],
			Description -> "For each member of SamplesIn, if InternalStandardAdditionOrder is Before for an unprepared solid SamplesIn, indicates the target concentration of InternalStandard added into LoadingSample solution during the LoadingSample preparation process. If InternalStandardAdditionOrder is Before for a prepared liquid SamplesIn, InternalStandardTargetConcentration is Null and please refer to SamplesIn for InternalStandard information.
			 If the InternalStandardAdditionOrder is After, the LoadingSample solution is added with InternalStandard to match the InternalStandardTargetConcentration and is measured again with the same potential parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},

		LoadingSamplePreparationContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container], Object[Container]],
			Description -> "For each member of SamplesIn, indicates the container used to perform the preparation of LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the solution is mixed after the addition of the analyte, the electrolyte (if added) and the optional internal standard (addition order is before) into the solvent.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[Shake, Pipette, Invert],
			Description -> "For each member of SamplesIn, indicates the mixing method to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[25 Celsius, 75 Celsius],
			Units -> Celsius,
			Description -> "For each member of SamplesIn, indicates the temperature at which the LoadingSample solution from solid SamplesIn is mixed.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, indicates the duration that the LoadingSample solution from solid SamplesIn is mixed.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0, 50, 1],
			Description -> "For each member of SamplesIn, indicates the number of mixes to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> RangeP[1 Milliliter, 20 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the solution volume that is pipetted up and down (if the MixType is Pipette) to prepare the LoadingSample solution from solid SamplesIn.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMixUntilDissolveds -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the mixing of the LoadingSample solution continues until the solid sample is dissolved, up to the LoadingSampleMaxMixTime or the LoadingSampleMaxNumberOfMixes.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMaxNumberOfMixes -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[0, 50, 1],
			Description -> "For each member of SamplesIn, indicates the maximum number of mixes to prepare the LoadingSample solution from solid SamplesIn, in attempt to dissolve all the solids.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},
		LoadingSampleMaxMixTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, indicates the maximum duration of mixing to prepare the LoadingSample solution from solid SamplesIn, in attempt to dissolve all the solids.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},

		LoadingSamplePreparationPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "Instructions specifying the preparation of LoadingSamples solutions. First the Electrolyte is dissolved into the Solvent solution to prepare the ElectrolyteSolution. The ElectrolyteSolution is then used to mix the ReferenceCouplingSample to prepare the ReferenceSolution. The ElectrolyteSolution is also used to mix the solid SamplesIn and an optional InternalStandard to prepare the LoadingSample solution.",
			Category -> "Sample Preparation"
		},
		LoadingSamplePreparationManipulations -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The specific subprotocol to prepare the LoadingSamples solutions. First the Electrolyte is dissolved into the Solvent solution to prepare the ElectrolyteSolution. The ElectrolyteSolution is then used to mix the ReferenceCouplingSample to prepare the ReferenceSolution. The ElectrolyteSolution is also used to mix the solid SamplesIn and an optional InternalStandard to prepare the LoadingSample solution.",
			Category -> "Sample Preparation"
		},

		LoadingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the prepared solution including the solid SamplesIn, an Electrolyte, an optional InternalStandard dissolved in the Solvent solution. The LoadingSample solution is loaded into the ReactionVessel and measured by the cyclic voltammetry cycles.",
			Category -> "Sample Preparation",
			IndexMatching -> SamplesIn
		},

		(* Sparging *)
		SpargingGases -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> InertGasP,
			Description -> "For each member of SamplesIn, indicates the type of inert gas used for the sparging process before the cyclic voltammetry measurement.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},
		SpargingTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Minute],
			Units -> Minute,
			Description -> "For each member of SamplesIn, indicates the duration used for the sparging process before the cyclic voltammetry measurement.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},
		SpargingPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 PSI],
			Units -> PSI,
			Description -> "For each member of SamplesIn, indicates the inert gas sparging pressure before the cyclic voltammetry measurement.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},
		SpargingPressureLogs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure logs for the sparging gas source for each SamplesIn.",
			Category -> "Sparging"
		},
		SpargingPreBubblers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel, GasWashingBottle], Object[Container, Vessel, GasWashingBottle]],
			Description -> "For each member of SamplesIn, indicates the prebubbler used before the reaction vessel. A prebubbler is a container containing the same solvent used in the electrolyte solution, which is hooked in series with the reaction vessel, such that the gas is first bubbled through the prebubbler solution and then bubbled into the reaction vessel. This helps to ensure the reaction vessel doesn't excessively evaporate during the sparging, since the sparging gas is saturated by the solvent inside the prebubbler before travelling into the reaction vessel.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},
		SpargingPreBubblerSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of SamplesIn, indicates the solvent sample loaded into the PreBubbler for LoadingSample solution sparging before the LoadingSample is measured by cyclic voltammetry cycles.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},
		SpargingPreBubblerSolventVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the volume of solvent sample loaded into the PreBubbler for LoadingSample solution sparging before the LoadingSample is measured by cyclic voltammetry cycles.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn
		},

		(* Developer fields for the sparing/pretreatment-sparging process *)
		RequireSchlenkLines -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates if the SchlenkLine system is required. If any SamplesIn requires pretreatment sparging or main sparging, this is set to True.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		SchlenkLines -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "For each member of SamplesIn, the SchlenkLine system is used for the sparging process. If the corresponding RequireSchlenkLines is True, this is set to a model or object of a SchlenkLine.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		PostMeasurementStandardAdditionSchlenkLines -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "For each member of SamplesIn, the SchlenkLine system is used for the post measurement internal standard standard addition sample sparging process.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		ReactionVesselVentingNeedle -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			Description -> "The needle that pierces through the electrode cap's septum and vents the sparging gas from the enclosed reaction vessel.",
			Category -> "Sparging",
			Developer -> True
		},
		ReactionVesselInletTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Plumbing], Object[Plumbing]],
			Description -> "The piece of tubing that directs the inert gas into the reaction vessel for the sparging purpose, not index-matched to the SamplesIn.",
			Category -> "Sparging",
			Developer -> True
		},
		ReactionVesselInletTubingConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "The connection information for attaching the ReactionVesselInletTubing to the inert gas outlet.",
			Headers -> {"Plumbing A","Plumbing A Connector","Plumbing B","Plumbing B Connector"},
			Category -> "Sparging",
			Developer -> True
		},
		ReactionVesselInletNeedles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Needle], Object[Item, Needle]],
			Description -> "For each member of SamplesIn, indicates the needle that pierces through the electrode cap's septum and introduces the sparging gas into the enclosed reaction vessel. The ReactionVesselInletNeedle connects to the ReactionVesselInletTubing.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},

		PreBubblerInletTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Plumbing], Object[Plumbing]],
			Description -> "The piece of tubing that directs the inert gas into the pre-bubbler for the sparging purpose, not index-matched to the SamplesIn.",
			Category -> "Sparging",
			Developer -> True
		},
		PreBubblerInletTubingConnection -> {
			Format -> Single,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "The connection information for attaching the PreBubblerInletTubing to the inert gas outlet.",
			Headers -> {"Plumbing A","Plumbing A Connector","Plumbing B","Plumbing B Connector"},
			Category -> "Sparging",
			Developer -> True
		},
		PreBubblerOutletTubing -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Plumbing], Object[Plumbing]],
			Description -> "Indicates the piece of tubing that directs the inert gas out from the pre-bubbler and into the reaction vessel for the sparging purpose.",
			Category -> "Sparging",
			Developer -> True
		},
		UniquePreBubblers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel, GasWashingBottle], Object[Container, Vessel, GasWashingBottle]],
			Description -> "Indicates the pre-bubblers used before the reaction vessel or the electrode pretreatment reaction vessel for the sparging/pretreatment-sparging purpose. Each unique pre-bubbler is used to hold each unique solvent sample.",
			Category -> "Sparging",
			Developer -> True
		},
		UniquePreBubblerSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "For each member of UniquePreBubblers, indicates the solvent sample loaded into the PreBubbler.",
			Category -> "Sparging",
			IndexMatching -> UniquePreBubblers,
			Developer -> True
		},
		UniquePreBubblerSolventLoadingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of UniquePreBubblers, indicates the volume of solvent sample loaded into the PreBubbler.",
			Category -> "Sparging",
			IndexMatching -> UniquePreBubblers,
			Developer -> True
		},
		InstallSpargingPreBubblers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates the if the pre-bubbler assembly should be installed for the LoadingSample sparging process.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		UninstallPreBubblers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of SamplesIn, indicates the if the pre-bubbler assembly should be uninstalled after the sparging/pretreatment-sparging process.",
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		PreBubblerInletConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "For each member of SamplesIn, The connection information for attaching the PreBubblerInletTubing onto the pre-bubbler's gas inlet port.",
			Headers -> {"PreBubbler","PreBubbler Inlet Connector","PreBubbler Inlet Tubing","PreBubbler Inlet Tubing Connector"},
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		PreBubblerOutletConnections -> {
			Format -> Multiple,
			Class -> {Link, String, Link, String},
			Pattern :> {_Link, ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null,
				Alternatives[Object[Plumbing],Object[Instrument],Object[Container],Object[Part],Object[Item]],
				Null
			},
			Description -> "For each member of SamplesIn, The connection information for attaching the PreBubblerOutletTubing onto the pre-bubbler's gas outlet port.",
			Headers -> {"PreBubbler","PreBubbler Outlet Connector","PreBubbler Outlet Tubing","PreBubbler Outlet Tubing Connector"},
			Category -> "Sparging",
			IndexMatching -> SamplesIn,
			Developer -> True
		},

		(* Cyclic Voltammetry Measurement *)
		LoadingSampleVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SamplesIn, indicates the volume of prepared LoadingSample solution loaded into the ReactionVessel before the cyclic voltammetry measurements.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		PrimaryCyclicVoltammetryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the potential (voltage) details of the first cyclic voltammetry measurement, which starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		SecondaryCyclicVoltammetryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the potential (voltage) details of the second cyclic voltammetry measurement, which starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		TertiaryCyclicVoltammetryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the potential (voltage) details of the third cyclic voltammetry measurement, which starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		QuaternaryCyclicVoltammetryPotentials -> {
			Format -> Multiple,
			Class -> {
				InitialPotential -> Real,
				FirstPotential -> Real,
				SecondPotential -> Real,
				FinalPotential -> Real,
				SweepRate -> Real
			},
			Pattern :> {
				InitialPotential -> VoltageP,
				FirstPotential -> VoltageP,
				SecondPotential -> VoltageP,
				FinalPotential -> VoltageP,
				SweepRate -> GreaterP[0 Millivolt/Second]
			},
			Units -> {
				InitialPotential -> Millivolt,
				FirstPotential -> Millivolt,
				SecondPotential -> Millivolt,
				FinalPotential -> Millivolt,
				SweepRate -> Millivolt/Second
			},
			Headers -> {
				InitialPotential -> "Initial Potential",
				FirstPotential -> "First Potential",
				SecondPotential -> "Second Potential",
				FinalPotential -> "Final Potential",
				SweepRate -> "Sweep Rate"
			},
			Description -> "For each member of SamplesIn, indicates the potential (voltage) details of the fourth cyclic voltammetry measurement, which starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		NumberOfCycles -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> RangeP[1, 4, 1],
			Description -> "For each member of SamplesIn, indicates the number of cyclic voltammetry measurement cycles performed. A cyclic voltammetry measurement cycle starts at the InitialPotential, then to FirstPotential, then to SecondPotential, and stops at the FinalPotential. During this process, the WorkingElectrode potential is linearly swept between these potential points with a speed specified by the SweepRate.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		CyclicVoltammetryDataPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, indicates the folder path in which the cyclic voltammetry data files generated by this protocol are stored.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		CyclicVoltammetryData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, indicates the data object containing the cyclic voltammetry measurement results. The measurements are performed using the parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn
		},
		InitialLoadingSampleAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the LoadingSample solution within the reaction vessel taken immediately before the cyclic voltammetry measurements.",
			Category -> "Experimental Results"
		},
		FinalLoadingSampleAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the LoadingSample solution within the reaction vessel taken immediately after the cyclic voltammetry measurements.",
			Category -> "Experimental Results"
		},

		(* Post CV Internal Standard Addition *)
		PostMeasurementStandardAdditionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel], Object[Container, Vessel]],
			Description -> "For each member of SamplesIn, the container for the addition and mixing of the internal standard after the cyclic voltammetry measurements.",
			Category -> "Post Measurement Internal Standard Addition",
			IndexMatching -> SamplesIn
		},
		CurrentPostMeasurementStandardAdditionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "Instructions specifying the mix of InternalStand into the current LoadingSample solution after the cyclic voltammetry measurements, but before the solution is measured again with the same parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Post Measurement Internal Standard Addition",
			Developer -> True
		},
		PostMeasurementStandardAdditionPrimitives -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "Accumulated instructions specifying the mix of InternalStand into the LoadingSamples solutions after the cyclic voltammetry measurements of the LoadingSamples.",
			Category -> "Post Measurement Internal Standard Addition"
		},
		PostMeasurementStandardAdditionManipulations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The subprotocols performed to mix the InternalStandard into the LoadingSamples solution after the cyclic voltammetry measurements of the LoadingSamples, but before the solution is measured again with the same parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Post Measurement Internal Standard Addition"
		},
		PostMeasurementStandardAdditionSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "For each member of SamplesIn, if the InternalStandardAdditional order is After, the sample object after the InternalStandard is mixed into the LoadingSamples after the cyclic voltammetry measurements.",
			Category -> "Post Measurement Internal Standard Addition",
			IndexMatching -> SamplesIn
		},
		PostMeasurementStandardAdditionSpargingPressureLogs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure logs for the sparging gas source during the post measurement internal standard addition sparging process for each SamplesIn.",
			Category -> "Post Measurement Internal Standard Addition"
		},
		PostMeasurementStandardAdditionDataPaths -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of SamplesIn, indicates the folder path in which the PostMeasurementStandardAdditionSamples cyclic voltammetry data files generated by this protocol are stored.",
			Category -> "Experimental Results",
			IndexMatching -> SamplesIn,
			Developer -> True
		},
		PostMeasurementStandardAdditionData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "For each member of SamplesIn, indicates the data object containing the cyclic voltammetry measurement results after the addition of InternalStandard into the LoadingSamples. The measurements are performed with the same parameters specified in Primary/Secondary/Tertiary/Quaternary-CyclicVoltammetryPotentials.",
			Category -> "Experimental Results"
		},
		InitialPostMeasurementStandardAdditionSampleAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the PostMeasurementStandardAdditionSamples solution within the reaction vessel taken immediately before the cyclic voltammetry measurements.",
			Category -> "Experimental Results"
		},
		FinalPostMeasurementStandardAdditionSampleAppearances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The image of the PostMeasurementStandardAdditionSamples solution within the reaction vessel taken immediately after the cyclic voltammetry measurements.",
			Category -> "Experimental Results"
		},

		WorkingElectrodeRustCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[None, Both, WorkingPart, NonWorkingPart],
			Description -> "Indicates if rust is present on the working electrode and the location of the observed rust.",
			Category -> "Usage Information",
			Developer -> True
		},
		WorkingElectrodeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Indicates the current working electrode image captured at the end of the current protocol.",
			Category -> "Usage Information",
			Developer -> True
		},
		CounterElectrodeRustCheck -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Alternatives[None, Both, WorkingPart, NonWorkingPart],
			Description -> "Indicates if rust is present on the counter electrode and the location of the observed rust.",
			Category -> "Usage Information",
			Developer -> True
		},
		CounterElectrodeImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Indicates the current counter electrode image captured at the end of the current protocol.",
			Category -> "Usage Information",
			Developer -> True
		},
		ReferenceElectrodeRustChecks -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> Alternatives[None, Both, WorkingPart, NonWorkingPart],
			Description -> "For each member of ReferenceElectrodes, indicates if rust is present on each reference electrodes and the location of the observed rust.",
			Category -> "Usage Information",
			IndexMatching -> ReferenceElectrodes,
			Developer -> True
		},
		ReferenceElectrodeImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Indicates the current image for each reference electrode captured at the end of the current protocol.",
			Category -> "Usage Information",
			Developer -> True
		}
	}
}];
