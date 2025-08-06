(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, PNASynthesis], {
	Description->"A protocol for synthesizing Peptide Nucleic Acid (PNA) oligomers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{

		Strands->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({StrandP..}|Null),
			Description->"The sequence of monomers and modifications that make up the oligomers being synthesized.",
			Category->"Synthesis",
			Abstract->True
		},
		StrandModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"Oligomers that will be synthesized by this protocol.",
			Category->"Synthesis",
			Abstract->True
		},
		CleavedStrandModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The oligomers that will undergo cleavage following the end of the synthesis.",
			Category->"Synthesis"
		},
		UncleavedStrandModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The oligomers that will be left covalently attached to their resins support following the end of the synthesis.",
			Category->"Synthesis"
		},
		Scale->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterP[0 Micromole],
			Units->Micromole,
			Description->"For each member of StrandModels, the amount of the synthesis reagents employed by this synthesis.",
			Category->"Synthesis",
			IndexMatching->StrandModels
		},
		SynthesisStrategy->{
			Format->Single,
			Class->Expression,
			Pattern:>PeptideSynthesisStrategyP,
			Description->"The protecting group strategy for solid phase peptide synthesis cycles.",
			Category->"Synthesis"
		},
		Instrument->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"The synthesizer instrument used to conduct the synthesis.",
			Category->"Synthesis"
		},
		Resin->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Sample],Model[Sample]],
			Description->"For each member of StrandModels, the resin sample used for solid support for the synthesis.",
			Category->"Synthesis",
			IndexMatching->StrandModels
		},
		RunTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Day],
			Units->Day,
			Description->"The estimated time that the samples will take to synthesize.",
			Category->"Synthesis",
			Developer->True
	},

		Primitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {SynthesisCycleStepP..},
			Description -> "For each member of StrandModels, a complete list of all chemical steps, including resin swelling, resin downloading, synthesis and cleavage, used to synthesize that strand.",
			Category -> "General",
			IndexMatching->StrandModels,
			Abstract -> True
		},

		FumeHood->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Instrument],Model[Instrument]],
			Description->"The fume hood used to conduct sample manipulations of hazardous chemicals.",
			Category->"Instrument Setup"
		},
		SeptumCaps->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item],
				Object[Item]
			],
			Description->"Pierceable silicon caps used to cap vessel to prevent evaporation of reagents.",
			Category->"Resin Swelling",
			Developer->True
		},
		ReagentContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description->"Containers that need to be uncapped and loaded on the instrument.",
			Category->"Instrument Setup",
			Developer->True
		},
		ReagentContainerCaps->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Item],
				Object[Item]
			],
			Description->"Caps on containers that need to be loaded on the instrument.",
			Category->"Instrument Setup",
			Developer->True
		},
		PlaceholderContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Object[Container]
			],
			Description->"Containers that need to be removed from the instrument and capped with the same caps in ReagentContainerCaps.",
			Category->"Instrument Setup",
			Developer->True
		},
		SeptumSheet->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Item],
				Object[Item]
			],
			Description->"A pierceable silicon sheet used to cap vessel to prevent evaporation of reagents.",
			Category->"Resin Swelling",
			Developer->True
		},
		SeptumSheetPlacement->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Alternatives[Object[Sample],Object[Item],Object[Container]], Null},
			Description->"A deck placement used to place the septa sheet onto the synthesizer deck.",
			Category->"Resin Swelling",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		SolventBottlePlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used to place all of the solvent solution vessels onto the synthesizer deck.",
			Category->"Resin Swelling",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		PlaceholderSolventBottlePlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used for placing of solvent bottle placeholders onto the synthesizer deck.",
			Category->"Resin Swelling",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		BottleReplacements->{
			Format->Multiple,
			Class->{Sample->Link,Container->Link,Destination->Link,Funnel->Link,FumeHood->Link},
			Pattern:>{Sample->_Link,Container->_Link,Destination->_Link,Funnel->_Link,FumeHood->_Link},
			Relation-> {
				Sample -> (Object[Sample] | Model[Sample]),
				Container -> Object[Container],
				Destination -> (Object[Container] | Model[Container]),
				Funnel -> (Object[Part, Funnel] | Model[Part, Funnel]),
				FumeHood -> (Object[Instrument, FumeHood] | Model[Instrument,FumeHood])
			},
			Description -> "The solvent Samples that had their Containers checked for damage in a FumeHood. Damaged containers have their Sample transferred via Funnel to replacement Destinations.",
			Category->"Instrument Setup",
			Developer->True
		},
		SynthesisFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of StrandModels, the name of the file that contains instrument methods for synthesizing the strand.",
			Category->"Instrument Setup",
			Developer->True,
			IndexMatching->StrandModels
		},
		SolventsFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name of the file that contains information for all solvent samples used during the synthesis and their positions on the instrument deck.",
			Category->"Instrument Setup",
			Developer->True
		},
		MonomersFileName->{
			Format->Single,
			Class->String,
			Pattern:>_String,
			Description->"The name of the file that contains information for all monomer samples used during the synthesis and their positions on the instrument deck.",
			Category->"Instrument Setup",
			Developer->True
		},
		ResinTransferPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description->"A set of instructions specifying the transfer of resins into the reaction vessels prior to synthesis.",
			Category->"Resin Swelling",
			Developer->True
		},
		ResinManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol,ManualSamplePreparation],
			Description->"A sample manipulation protocol used to transfer resin into the reaction vessels prior to synthesis.",
			Category->"Resin Swelling",
			Developer->True
		},
		ReactionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"For each member of StrandModels, the container used as the reaction vessel for that reaction.",
			Category->"Resin Swelling",
			Developer->True,
			IndexMatching->StrandModels
		},
		ReactionVesselStopcocks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description->"For each member of ReactionVessels, the stopcock consumable used to cap the bottom of the reaction vessel that resin sample is in.",
			Category->"Resin Swelling",
			Developer->True,
			IndexMatching->ReactionVessels
		},
		ReactionVesselWeights->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol, MeasureWeight],
			Description->"Weighing protocol used to determine the weight of reaction vessels after the addition of the resin.",
			Category->"Resin Swelling",
			Developer->True
		},
		ReactionVesselRacks->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Container],
				Object[Container]
			],
			Description->"The racks used to hold the reaction vessels and stopcocks during SampleManipulations.",
			Category->"Resin Swelling",
			Developer->True
		},
		ReactionVesselPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Sample] | Object[Item] | Object[Container], Null},
			Description->"A list of deck placements used to for placing the reaction vessels onto the synthesizer deck.",
			Category->"Resin Swelling",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		PlaceholderReactionVesselPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used for placing of reaction vessel placeholders onto the synthesizer deck in the form {container to place, list of nested positions in which to place container}.",
			Category->"Resin Swelling",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},

		SwellResin->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if the resin is swollen in swell solution prior to first synthesis cycle.",
			Category->"Resin Swelling",
			IndexMatching->StrandModels
		},
		SwellSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to swell the resin prior to the start of synthesis to increase the accessibility of active sites.",
			Category->"Resin Swelling"
		},
		SwellVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Liter],
			Units->Liter Milli,
			Description->"The volume of swell solution dispensed to each reaction vessel during the swell step.",
			Category->"Resin Swelling",
			Developer->True
		},
		SwellTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Hour,
			Description->"The length of time for which the resins are swollen for prior to first synthesis cycle.",
			Category->"Resin Swelling",
			Developer->True
		},
		SwellPurgeTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Hour,
			Description->"The length of time that for which the swell solution is purged into the reaction vessels.",
			Category->"Resin Swelling"
		},
		NumberOfSwellCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"Number of times the resin is incubated in the SwellSolution prior to the start of synthesis.",
			Category->"Resin Swelling",
			Developer->True
		},

		TargetLoadings->{
			Format->Multiple,
			Class->Real,
			Pattern :>GreaterEqualP[(0*Mole)/Gram],
			Units->Mole/Gram,
			Description->"For each member of Resin, the target amount of active sites per gram of downloaded resin.",
			Category->"Downloading",
			IndexMatching->Resin
		},
		DownloadResins -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the resins are downloaded prior to the start of the synthesis.",
			Category -> "Downloading"
		},
		DownloadedStrandModels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample],
			Description->"The oligomers that will undergo resin downloading using the C terminal monomer of their sequence prior to the start of the synthesis.",
			Category->"Downloading"
		},
		DownloadMonomers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"For each member of DownloadedStrandModels, the monomer sample used to download the resin when preloading the resin.",
			Category->"Downloading",
			IndexMatching->DownloadedStrandModels
		},
		DownloadActivationSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"A mix of preactivation and base solutions used to activate the monomers for coupling when preloading the resin.",
			Category->"Monomer Activation"
		},

		Deprotonation->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if a deprotonation step is performed between the coupling steps.",
			Category->"Deprotonation",
			IndexMatching->StrandModels
		},
		DeprotonationSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The deprotonation solution used to neutralize the resin prior to the coupling step.",
			Category->"Deprotonation"
		},

		DeprotectionSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The deprotection solution used to remove protecting groups from the growing strand during the deprotection step.",
			Category->"Deprotection"
		},
		InitialDeprotection->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if an initial deprotection step is done are part of resin download.",
			Category->"Deprotection",
			IndexMatching->StrandModels
		},
		FinalDeprotection->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if a final deprotection step is done following last synthesis cycle.",
			Category->"Deprotection",
			IndexMatching->StrandModels
		},
		MonomerPreactivations->{
			Format->Multiple,
			Class->Expression,
			Pattern:>PreactivationTypeP,
			Description->"For each member of StrandModels, indicates if the monomer is preactivated in a separate reaction vessel, in the reaction vessel with the resin, or not at all.",
			Category->"Monomer Activation",
			IndexMatching->StrandModels
		},
		SynthesisMonomers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Model[Sample] | Object[Sample],
			Description->"A list of all monomers samples used to synthesize the sequence.",
			Category->"Monomer Activation"
		},
		MonomerBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used for placing monomer solutions onto the synthesizer deck.",
			Category -> "Monomer Activation",
			Developer -> True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		PlaceholderMonomerBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used for placing of monomer vessel placeholders onto the synthesizer deck.",
			Category -> "Monomer Activation",
			Developer -> True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		PreactivationVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The vessel used to preactivate the monomers for that strand's synthesis.",
			Category->"Monomer Activation"
		},
		PreactivationVesselPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used to for placing of the preactivation vessels onto the synthesizer deck.",
			Category->"Monomer Activation",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		ActivationSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"A mix of preactivation and base solutions used to activate the monomers for coupling.",
			Category->"Monomer Activation"
		},

		InitialCapping -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if an initial capping step is done prior to the first synthesis cycle.",
			Category->"Capping",
			IndexMatching->StrandModels
		},
		FinalCapping->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if a final capping step is done following last synthesis cycle.",
			Category->"Capping",
			IndexMatching->StrandModels
		},
		CappingSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The capping solution used to cap any remaining uncoupled sites from growing further during the synthesis to aid in later purification of the truncations.",
			Category->"Capping"
		},

		DoubleCoupling->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The cycle at which the synthesis begins to double couple by exposing each resin to fresh coupling for two consecutive incubations.",
			Category->"Coupling"
		},
		DoubleCouplings->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The cycle at which the synthesis begins to double couple by exposing each resin to fresh coupling for two consecutive incubations.",
			Category->"Coupling"
		},

		WashSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The primary solution used for washing the resin between reagent additions.",
			Category->"Washing"
		},
		WashSolutionWeightData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The weight data of the currently installed wash solution drum.",
			Category->"Washing",
			Developer->True
		},
		MethanolWash->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the reaction vessels are washed with primary shrink solution during the second to last step of the last synthesis cycle.",
			Category->"Washing",
			Developer->True
		},
		MethanolWashVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"The volume of primary shrink solution that will be used to shrink the resin after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True
		},
		MethanolWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration of the shrinking of resin with primary resin shrink solution after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True
		},

		IsopropanolWash->{
			Format->Single,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"Indicates if the resins are washed with secondary shrink solution during the last step of the last synthesis cycle.",
			Category->"Washing",
			Developer->True
		},
		IsopropanolWashVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"The volume of secondary shrink solution that will be used to shrink the resin after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True
		},
		IsopropanolWashTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The duration of the shrinking of resin with secondary resin shrink solution after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True
		},

		Cleavage->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if the oligomer will be cleaved from the resin after synthesis.",
			Category->"Cleavage",
			IndexMatching->StrandModels
		},
		CleavedReactionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"The subset of reaction vessels which will undergo cleaved and have the oligomer strands cleaved after the end of the synthesis.",
			Category->"Cleavage",
			Developer->True
		},
		CleavageSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to cleave the strands from the resins post synthesis resin.",
			Category->"Cleavage"
		},
		CleavageVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"The volume of cleavage solution that will be used to cleave the strands from the resin.",
			Category->"Cleavage",
			Developer->True
		},
		CleavageTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The length of time for which the strands will be cleaved.",
			Category->"Cleavage",
			Developer->True
		},
		NumberOfCleavageCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The number of repeated times the resin will be incubated with the cleavage solution and the filtrate collected.",
			Category->"Cleavage",
			Developer->True
		},
		PlaceholderCleavageBottle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container],
			Description->"Cleavage vessel placeholder kept on the instrument in between protocols and used during instrument cleaning.",
			Category->"Cleavage",
			Developer->True
		},
		CollectionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"For each member of CleavedStrandModels, ihe temporary vessel used to collect the cleavage strands prior to trituration.",
			Category->"Cleavage",
			IndexMatching->CleavedStrandModels
		},
		CollectionVesselPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used for placing of cleavage vessels onto the synthesizer deck.",
			Category->"Cleavage",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		PlaceholderCollectionVesselPlacements->{
			Format->Multiple,
			Class->{Link, Expression},
			Pattern:>{_Link, {LocationPositionP..}},
			Relation->{Object[Container], Null},
			Description->"A list of deck placements used for placing of cleavage vessel placeholders onto the synthesizer deck.",
			Category->"Cleavage",
			Developer->True,
			Headers-> {"Object to Place", "Placement Tree"}
		},
		WashSyringe->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The syringe used to dispense cleavage swell solutions into reaction vessels during cleavage.",
			Category->"Cleavage"
		},
		WashNeedle->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample],Model[Item],Object[Item]], (* TODO: Remove after item migration *)
			Description->"The needle installed onto the syringe used to dispense cleavage swell solution into reaction vessels during cleavage.",
			Category->"Cleavage"
		},
		CleavageSyringes->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"The syringes used to dispense cleavage solution into reaction vessels during cleavage.",
			Category->"Cleavage"
		},
		WashNeedles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample],Model[Item],Object[Item]], (* TODO: Remove after item migration *)
			Description->"The needles installed onto the syringes used to dispense cleavage solution into reaction vessels during cleavage.",
			Category->"Cleavage"
		},
		CleavageNeedles->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample],Model[Item],Object[Item]], (* TODO: Remove after item migration *)
			Description->"The needles installed onto the syringes used to dispense cleavage solution into reaction vessels during cleavage.",
			Category->"Cleavage"
		},
		VacuumManifold->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description->"The vacuum manifold used to conduct the cleavage and trituration part of this protocol.",
			Category->"Cleavage"
		},
		CleavageFileNames->{
			Format->Multiple,
			Class->String,
			Pattern:>_String,
			Description->"For each member of StrandModels, the name of the file that contains instrument methods for cleaving the strand from resin.",
			Category->"Cleavage",
			Developer->True,
			IndexMatching->StrandModels
		},

		Pipette -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette], Object[Instrument, Pipette]],
			Description -> "The pipette controller used to transfer resin from reaction vessels into cleavage syringes.",
			Category->"Cleavage"
		},
		PipetteTips -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation->Alternatives[Model[Sample],Object[Sample],Model[Item],Object[Item]], (* TODO: Remove after item migration *)
			Description -> "Pipette tips used for the protocol.",
			Category->"Cleavage"
		},

		TriturationPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description->"A set of instructions specifying the transfers required to add trituration solution to the cleavage vessels.",
			Category->"Trituration"
		},
		TriturationManipulations->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol, ManualSamplePreparation]|Object[Protocol, RoboticSamplePreparation]|Object[Notebook, Script],
			Description->"Sample manipulations protocols used to add trituration solution to the cleavage vessels.",
			Category->"Trituration"
		},
		TriturationSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solution used to purify the PNA strands after cleavage from the resin by using the solubility differences between PNA strands, which should crash out of solution and impurities which remain soluble.",
			Category->"Trituration"
		},
		TriturationVolume->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"The volume of TriturationSolution that used to crash the strands out of solution during trituration.",
			Category->"Trituration"
		},
		TriturationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The length of time for which the cleaved strands will be triturated with TriturationSolution.",
			Category->"Trituration"
		},
		TriturationTemperature->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Kelvin],
			Units->Celsius,
			Description->"The temperature at which the cleaved strands are triturated with TriturationSolution.",
			Category->"Trituration"
		},
		TriturationBeaker->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Model[Container]
			],
			Description->"A waste beaker used to collect ether while trituration in case the pellet escapes from the trituration tubes.",
			Category->"Trituration",
			Developer->True
		},
		TriturationCentrifugationTime->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"The length of time for which the insoluble cleaved strands are spun down and pelleted during each trituration cycle.",
			Category->"Trituration"
		},
		TriturationCentrifugationForce->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*GravitationalAcceleration],
			Units->GravitationalAcceleration,
			Description->"The centrifugal force at which the insoluble cleaved strands are spun down and pelleted during each trituration cycle.",
			Category->"Trituration"
		},
		TriturationCentrifugationRate->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*RPM],
			Units->RPM,
			Description->"The centrifuge rate for which the insoluble cleaved strands are spun down and pelleted during each trituration cycle.",
			Category->"Trituration"
		},
		NumberOfTriturationCycles->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"The number of times the cleaved PNA strands are triturated with TriturationSolution.",
			Category->"Trituration"
		},
		TriturationMixing->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description->"The mix protocols that will be executed during trituration to resuspend the pellet into the trituration solution.",
			Category->"Trituration"
		},
		TriturationCentrifuging->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Protocol,Centrifuge], Object[Protocol,ManualSamplePreparation]],
			Description->"The centrifuge protocols that will be executed during trituration to pellet the strands prior to decanting of supernatant.",
			Category->"Trituration"
		},

		ResuspensionBuffer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The buffer used to resuspend the strands after cleavage from the resin.",
			Category->"Resuspension"
		},
		ResuspensionVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"For each member of CleavedStrandModels, the volume of resuspension buffer used to resuspend the strand after cleavage from the resin.",
			Category->"Resuspension",
			IndexMatching->CleavedStrandModels
		},
		ResuspensionMixPrimitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ResuspensionPrimitiveP..},
			Description->"A set of instructions specifying the mixing of the strands in resuspension buffer prior to the transfer into the final ContainersOut.",
			Category->"Resuspension",
			Developer->True
		},
		ResuspensionPrimitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description->"A set of instructions specifying the transfers required to resuspended the strands into the final ContainersOut.",
			Category->"Resuspension",
			Developer->True
		},
		ResuspensionManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation] | Object[Protocol, ManualSamplePreparation],
			Description->"A sample preparation protocol used to transfer the resuspended strands into the final ContainersOut.",
			Category->"Resuspension",
			Developer->True
		},
		NumberOfResuspensionMixes->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[1, 1],
			Units->None,
			Description->"The number of times to mix the sample by pipetting up and down when resuspending the final material.",
			Category->"Resuspension",
			Developer->True
		},

		StorageSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The sample or model of solution used to store any uncleaved resin samples.",
			Category->"Resin Storage"
		},
		UncleavedReactionVessels->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"For each member of UncleavedStrandModels, the reaction vessel which has its resins contents stored in a storage solution without undergoing cleavage.",
			Category->"Resin Storage",
			Developer->True,
			IndexMatching->UncleavedStrandModels
		},
		StorageVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"For each member of UncleavedStrandModels, the volume of storage solution in which to store the resin.",
			Category->"Resin Storage",
			IndexMatching->UncleavedStrandModels
		},
		StoragePrimitives->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP|SamplePreparationP,
			Description->"A set of instructions specifying the transfers required to store the uncleaved resin samples into the storage containers.",
			Category->"Resuspension",
			Developer->True
		},
		StorageManipulation->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Protocol,SampleManipulation]|Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation]|Object[Notebook,Script],
			Description->"A sample manipulation protocol used to manipulate the uncleaved resin samples into the storage containers.",
			Category->"Resin Storage",
			Developer->True
		},
		CleaningSolutions->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The solutions used to clean the instrument after the synthesis has been completed.",
			Category->"Cleaning",
			Developer->True
		},
		Neutralizer->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description->"The chemical used to neutralize the remaining cleavage solutions before its disposal into chemical waste.",
			Category->"Cleaning",
			Developer->True
		},

		RecoupMonomers->{
			Format->Single,
			Class -> Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if any leftover monomer solutions will be stored at the conclusion of the synthesis.",
			Category->"Monomer Recovery"
		},
		RecoupedMonomers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Sample],
			Description->"For each member of SynthesisMonomers, the leftover monomer solution transferred to a new container for storage.",
			Category->"Monomer Recovery",
			IndexMatching->SynthesisMonomers
		},
		RecoupedMonomersContainers->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Object[Container],Model[Container]],
			Description->"For each member of SynthesisMonomers, the container the leftover monomer solution was stored in.",
			Category->"Monomer Recovery",
			IndexMatching->SynthesisMonomers,
			Developer->True
		},

		InitialPurgePressure->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The pressure data of the nitrogen gas connected to the synthesizer before starting the run.",
			Category->"Sensor Information",
			Developer->True
		},
		SynthesisPositions->{
			Format -> Multiple,
			Class -> Expression,
			Pattern :> _String,
			Description -> "For each member of StrandModels, the instrument position in which each of the strands will be synthesized.",
			Category -> "Instrument Setup",
			IndexMatching->StrandModels,
			Developer->True
		},
		PurgePressureData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The pressure data of the nitrogen gas connected to the synthesizer at the start of the synthesis.",
			Category->"Instrument Setup",
			Developer->True
		},
		PurgePressureLog->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The pressure log for the nitrogen gas connected to the synthesizer.",
			Category->"Sensor Information",
			Developer->True
		},
		PrimaryWasteWeightData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The weight data of the waste carboys installed on the instrument taken at the start of the protocol.",
			Category->"Sensor Information",
			Developer->True
		},
		SecondaryWasteWeightData->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Data][Protocol],
			Description->"The weight data of the waste carboys installed on the instrument taken at the start of the protocol.",
			Category->"Sensor Information",
			Developer->True
		},

	(* Resin swelling Multiple *)

		SwellTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Hour,
			Description->"For each member of StrandModels, the length of time for which the resins are swollen for prior to first synthesis cycle.",
			Category->"Resin Swelling",
			Developer->True,
			IndexMatching->StrandModels
		},

		SwellVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Milli*Liter],
			Units->Liter Milli,
			Description->"For each member of StrandModels, the volume of swell solution dispensed to each reaction vessel during the swell step.",
			Category->"Resin Swelling",
			Developer->True,
			IndexMatching->StrandModels
		},

		NumbersOfSwellCycles->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"For each member of StrandModels, the number of times the resin is incubated in the SwellSolution prior to the start of synthesis.",
			Category->"Resin Swelling",
			Developer->True,
			IndexMatching->StrandModels
		},

(* Cleavage Multiple *)

		CleavageVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"For each member of StrandModels, the volume of cleavage solution that will be used to cleave the strands from the resin.",
			Category->"Cleavage",
			Developer->True,
			IndexMatching->StrandModels
		},

		CleavageTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"For each member of StrandModels, the length of time for which the strands will be cleaved.",
			Category->"Cleavage",
			Developer->True,
			IndexMatching->StrandModels
		},
		NumbersOfCleavageCycles->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[0, 1],
			Units->None,
			Description->"For each member of StrandModels, the number of repeated times the resin will be incubated with the cleavage solution and the filtrate collected.",
			Category->"Cleavage",
			Developer->True,
			IndexMatching->StrandModels
		},

(* Washing Multiple *)
		PrimaryResinShrinkSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The sample of primary shrink solution used to shrink the resin prior to cleavage.",
			Category->"Washing"
		},
		SecondaryResinShrinkSolution->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[Model[Sample],Object[Sample]],
			Description->"The sample of secondary shrink solution used to shrink the resin prior to cleavage.",
			Category->"Washing"
		},
		PrimaryResinShrinks->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if the reaction vessels are washed with primary shrink solution during after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},
		PrimaryResinShrinkVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"For each member of StrandModels, the volume of primary shrink solution that will be used to shrink the resin after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},
		PrimaryResinShrinkTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"For each member of StrandModels, the duration that the resin is washed with primary shrink solution after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},

		SecondaryResinShrinks->{
			Format->Multiple,
			Class->Expression,
			Pattern:>BooleanP,
			Description->"For each member of StrandModels, indicates if the resins are washed with secondary shrink solution during the last step of the last synthesis cycle prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},

		SecondaryResinShrinkVolumes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Micro*Liter],
			Units->Milliliter,
			Description->"For each member of StrandModels, the volume of secondary shrink solution that will be used to shrink the resin after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},
		SecondaryResinShrinkTimes->{
			Format->Multiple,
			Class->Real,
			Pattern:>GreaterEqualP[0*Minute],
			Units->Minute,
			Description->"For each member of StrandModels, the duration that the resin is washed with secondary shrink solution after synthesis and prior to cleavage of the strands from the resin.",
			Category->"Washing",
			Developer->True,
			IndexMatching->StrandModels
		},
		NumbersOfResuspensionMixes->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterEqualP[1, 1],
			Units->None,
			Description->"For each member of StrandModels, the number of times to mix the sample by pipetting up and down when resuspending the final material.",
			Category->"Resuspension",
			Developer->True,
			IndexMatching->StrandModels
		},

		BatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"Parameters describing the length of each batch.",
			Category->"Batching",
			Developer->True

		}
	}
}];
