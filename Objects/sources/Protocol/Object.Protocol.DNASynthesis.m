

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, DNASynthesis], {
	Description -> "A protocol for phosphoramidite-based synthesis of DNA oligomers using a DNA synthesizer.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {

		VerifiedSelectAgentFree->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates that the strands in this synthesis protocol have been verified to not contain any harmful sequences as defined by the Select Agents and Toxins List issued by the Food & Drug Administration (FDA).",
			Category->"Synthesis",
			Developer->True,
			AdminWriteOnly->True
		},

		Strands->{
			Format->Multiple,
			Class->Expression,
			Pattern:>({StrandP..}|Null),
			Description->"The sequence of monomers and modifications that make up the oligomers being synthesized.",
			Category->"Synthesis",
			Abstract->True
		},
		StrandModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The oligomer models that will be synthesized in this protocol.",
			Category -> "Synthesis"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The synthesizer instrument used to conduct the synthesis.",
			Category -> "Synthesis"
		},
		Scale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Micro * Mole],
			Units -> Micro Mole,
			Description -> "The theoretical amount of reaction sites available for synthesis.",
			Category -> "Synthesis"
		},
		Columns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample], (* TODO: Remove Object[Sample] here after item migration *)
				Object[Sample],
				Model[Item],
				Object[Item]
			],
			Description -> "For each member of StrandModels, the solid support on which the synthesis of the strand is carried out.",
			Category -> "Synthesis",
			IndexMatching -> StrandModels
		},
		ColumnPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}}, (* TODO: Remove Object[Sample] here after item migration *)
			Relation -> {Object[Sample] | Model[Sample] | Object[Item] | Model[Item] | Object[Container] | Model[Container], Null},
			Description -> "A list of deck placements used to place the solid supports onto the synthesizer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Column","Placement"}
		},
		PhosphoramiditeDilutionManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,SampleManipulation],Object[Protocol,ManualSamplePreparation]],
			Description -> "The set of instructions to transfer the phosphoramidite dilution solution to the undissolved phosphoramidites.",
			Category -> "Coupling"
		},
		PhosphoramiditeDilutionPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> Alternatives[SampleManipulationP, ManualSamplePreparationP],
			Description -> "The set of instructions specifying the transfers of solvent to the undissolved phosphoramidites.",
			Category -> "Coupling",
			Developer->True
		},
		PhosphoramiditeMixingProtocol -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The mix protocols used to dissolve the phosphoramidites.",
			Category -> "Coupling"
		},
		Phosphoramidites -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {SequenceP, _Link},
			Relation -> {Null, Object[Sample] | Model[Sample]},
			Description -> "The phosphoramidite used for each monomer.",
			Category -> "Coupling",
			Headers -> {"Monomer Type","Phosphoramidite"}
		},
		PhosphoramiditeConcentrations -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {SequenceP, GreaterP[0 * Molar]},
			Units -> {None, Molar},
			Description -> "The phosphoramidite concentration used for each monomer.",
			Category -> "Coupling",
			Headers -> {"Monomer Type","Concentration"}
		},
		PhosphoramiditeSolvents -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {SequenceP, _Link},
			Relation -> {Null, Object[Sample] | Model[Sample]},
			Description -> "The solvent used to dilute the phosphoramidite for each monomer.",
			Category -> "Coupling",
			Headers -> {"Monomer Type","Solvent"}
		},
		PhosphoramiditeCosolvents -> {
			Format -> Multiple,
			Class -> {Expression, Real, Link},
			Pattern :> {SequenceP, RangeP[0.`,1.`], _Link},
			Relation -> {Null, Null, Object[Sample] | Model[Sample]},
			Description -> "The cosolvent used to dilute the phosphoramidite for each monomer, along with its ratio with respect to the corresponding PhosphoramiditeSolvent.",
			Category -> "Coupling",
			Headers -> {"Monomer Type","Cosolvent Fraction","Solvent"}
		},
		WashSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent used for washing the solid supports between reagent additions.",
			Category -> "Washing"
		},
		WashSolutionDesiccants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],(* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of WashSolution, the desiccant used to keep the wash solution dry.",
			Category -> "Washing",
			IndexMatching -> WashSolution
		},
		NumberOfInitialWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of washes at the start of the synthesis.",
			Category -> "Washing"
		},
		InitialWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with wash solution at the start of the synthesis.",
			Category -> "Washing"
		},
		InitialWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of each wash at the start of the synthesis.",
			Category -> "Washing"
		},
		ReplaceWashSolution -> {
			Format -> Multiple,
			Class ->{
				Position->Expression,
				ReplaceReagent->Boolean
			},
			Pattern :> {
				Position->LocationPositionP,
				ReplaceReagent->BooleanP
			},
			Description -> "A list of wash solution positions in the instrument deck and whether they need to be replaced.",
			Category -> "Washing",
			Developer -> True
		},
		DeprotectionSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to remove the trityl protecting group.",
			Category -> "Deprotection"
		},
		NumberOfDeprotections -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times that the deprotection solution is added to the solid support after each cycle.",
			Category -> "Deprotection"
		},
		DeprotectionTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with deprotection solution.",
			Category -> "Deprotection"
		},
		DeprotectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of deprotection solvent used in each deprotection iteration.",
			Category -> "Deprotection"
		},
		FinalDeprotection -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of StrandModels, indicates if a final deprotection (detritylation) step is done following the last synthesis cycle.",
			Category -> "Deprotection",
			IndexMatching -> StrandModels
		},
		NumberOfDeprotectionWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of times the solid support is washed after deprotection.",
			Category -> "Deprotection"
		},
		DeprotectionWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "The amount of time that the solid supports are incubated with wash solution following deprotection.",
			Category -> "Deprotection"
		},
		DeprotectionWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of each post-deprotection wash.",
			Category -> "Deprotection"
		},
		ReplaceDeprotectionSolution -> {
			Format -> Single,
			Class ->{
				Position->Expression,
				ReplaceReagent->Boolean
			},
			Pattern :> {
				Position->LocationPositionP,
				ReplaceReagent->BooleanP
			},
			Description -> "The deprotection solution position in the instrument deck and an indication of whether it needs to be replaced.",
			Category -> "Deprotection",
			Developer -> True
		},
		SynthesisCycles -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {SequenceP, _Link},
			Relation -> {Null, Object[Method]},
			Description -> "A list of synthesis cycle methods (controlling coupling conditions) for each monomer type.",
			Category -> "Coupling",
			Headers -> {"Monomer Type","Method"}
		},
		ActivatorSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution that activates the phosphoramidite prior to coupling by protonating the diisopropylamino group of the phosphoramidite, thereby making the diisopropylamino group a good leaving group that is readily displaced by the 5' hydroxyl group on the growing oligomer.",
			Category -> "Coupling"
		},
		ActivatorSolutionDesiccants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],(* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of ActivatorSolution, the desiccant used to keep the activator solution dry.",
			Category -> "Coupling",
			IndexMatching->ActivatorSolution
		},
		ActivatorVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of activator solution used to activate the phosphoramidite prior to coupling.",
			Category -> "Coupling"
		},
		CapASolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution (used in conjunction with Cap B Solution) used to cap unreacted sites by acetylating free hydroxy sites.",
			Category -> "Capping"
		},
		CapBSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution (used in conjunction with Cap A Solution) used to cap unreacted sites by acetylating free hydroxy sites.",
			Category -> "Capping"
		},
		NumberOfCappings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of capping iterations.",
			Category -> "Capping"
		},
		CapTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with Cap A solution and Cap B solution.",
			Category -> "Capping"
		},
		CapAVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of Cap A solution used in each capping iteration.",
			Category -> "Capping"
		},
		CapBVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of Cap B solution used in each capping iteration.",
			Category -> "Capping"
		},
		OxidationSolution -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to oxidize the DNA backbone, thereby converting the phosphite triester to a more stable phosphate triester.",
			Category -> "Oxidation"
		},
		NumberOfOxidations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of oxidation iterations.",
			Category -> "Oxidation"
		},
		OxidationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with oxidation solution.",
			Category -> "Oxidation"
		},
		OxidationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of oxidation solution used in each oxidation iteration.",
			Category -> "Oxidation"
		},
		NumberOfOxidationWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of washes following oxidation.",
			Category -> "Oxidation"
		},
		OxidationWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with wash solution following oxidation.",
			Category -> "Oxidation"
		},
		OxidationWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash solution for each post-oxidation wash.",
			Category -> "Oxidation"
		},
		NumberOfFinalWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of washes at the end of the synthesis.",
			Category -> "Washing"
		},
		FinalWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with wash solution at the end of the synthesis.",
			Category -> "Washing"
		},
		FinalWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of each wash at the end of the synthesis.",
			Category -> "Washing"
		},
		Cleavage -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of StrandModels, indicates if the oligomer will be cleaved and filtered from the solid support after synthesis.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageMethods -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method],
			Description -> "For each member of StrandModels, the cleavage method specifying conditions used to cleave the oligomer from the solid support.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of StrandModels, the solution used to cleave the oligomer from the solid-phase support.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageTimes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "For each member of StrandModels, the time that the oligomer will be incubated in cleavage solution.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Celsius],
			Units -> Celsius,
			Description -> "For each member of StrandModels, the temperature at which the oligomer will be incubated in cleavage solution.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageSolutionVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milli * Liter],
			Units -> Liter Milli,
			Description -> "For each member of StrandModels, the volume of cleavage solution in which the oligomer is cleaved.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageWashVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milli * Liter],
			Units -> Liter Milli,
			Description -> "For each member of StrandModels, volume of solvent used to wash the solid support following cleavage. The wash filtrate is pooled with the filtered cleavage solution.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageWashSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of StrandModels, the solvent used to wash the solid support following cleavage. The wash filtrate is pooled with the filtered cleavage solution.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		CleavageIncubations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol,Incubate],Object[Protocol,ManualSamplePreparation]],
			Description -> "The thermal incubation protocols used to cleave the oligomers from the solid support.",
			Category -> "Cleavage"
		},
		CleavageBatchingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageBatchingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "The container used to cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageBatchingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of solution used to cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageBatchingTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Tips], Model[Item, Tips]],
			Description -> "Tips used to cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageBatchingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette],Object[Instrument, Pipette]],
			Description -> "Pipettes used to cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageBatchingEnvironments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "The fume hood used to perform manipulations which cleave oligomers from the solid support for columns with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		CleavageColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "The columns holding the solid support with Cleavage -> True.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingSolutions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Model[Sample]],
			Description -> "The solution used to cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "The container used to cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume of solution used to cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingTips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Tips], Model[Item, Tips]],
			Description -> "Tips used to cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingPipettes -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Pipette],Object[Instrument, Pipette]],
			Description -> "Pipettes used to cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageBatchingEnvironments -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "The fume hood used to perform manipulations which cleave oligomers from the solid support for columns with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		NoCleavageColumns -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "The columns holding the solid support with Cleavage -> False.",
			Category -> "Cleavage",
			Developer -> True
		},
		ResinPlacements -> {
			Format -> Multiple,
			Class -> {Link,Link,Expression},
			Pattern :> {_Link,_Link,LocationPositionP},
			Relation -> {(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),(Object[Container]|Object[Sample]|Model[Container]|Model[Sample]),Null},
			Description -> "For each member of StrandModels, the placement used to transfer the solid supports from the synthesis reaction vessels into containers after synthesis.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Solid Support","Destination Container","Destination Position"},
			IndexMatching -> StrandModels
		},

		StorageSolvents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "For each member of StrandModels, the solution that the uncleaved oligomer (still on the solid support) is stored in following synthesis.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		StorageSolventVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "For each member of StrandModels, the amount of solvent that the uncleaved oligomer (still on the solid support) is stored in post-synthesis.",
			Category -> "Cleavage",
			IndexMatching -> StrandModels
		},
		ResinContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "For each member of StrandModels, the containers in which the solid support is transferred to post-synthesis.",
			Category -> "Cleavage",
			Developer->True,
			IndexMatching->StrandModels
		},
		Filters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],(* TODO: Remove Object[Sample] here after item migration *)
				Model[Sample],
				Object[Container],
				Model[Container],
				Object[Item],
				Model[Item]
			],
			Description -> "The filters used to filter oligomers and cleavage solution from the solid support post-cleavage.",
			Category -> "Cleavage"
		},
		CleavageSolutionManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of cleavage solution to the solid support.",
			Category -> "Cleavage"
		},
		FilterTransferManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of cleaved oligomers and cleavage solution from the solid support to a filter.",
			Category -> "Cleavage"
		},
		ResinWashManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of cleavage wash solution to the solid support.",
			Category -> "Cleavage"
		},
		FilterWashManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of cleavage wash solution from the solid support to a filter.",
			Category -> "Cleavage"
		},
		(*TODO update to Lyophilize as default, leave the choice though*)
		CleavageEvaporationProtocol -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol,VacuumEvaporation],
				Object[Protocol,Evaporate]
			],
			Description -> "The set of instructions specifying the evaporation of the cleavage solution and cleavage wash solution from the cleaved oligomers.",
			Category -> "Cleavage"
		},
		StorageSolventManipulation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of storage solution to uncleaved oligomers (still attached to the solid support).",
			Category -> "Cleavage"
		},
		StorageSolventPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of storage solution to uncleaved oligomers (still attached to the solid support).",
			Category -> "Cleavage",
			Developer->True
		},
		PhosphoramiditeDesiccants -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of PhosphoramiditePlacements, the desiccants, used to keep the phosphoramidite solution dry, added as the phosphoramidite bottle is loaded onto the instrument.",
			Category -> "Coupling",
			IndexMatching->PhosphoramiditePlacements
		},
		PhosphoramiditePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sample] | Object[Container] | Model[Sample], Null},
			Description -> "A list of deck placements used to place the phosphoramidite solution vessels onto the synthesizer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Phosphoramidite","Placement"}
		},
		PlaceholderPhosphoramiditePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used to place the phosphoramidite vessel placeholders on the instrument in between protocols and during instrument cleaning.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Placeholder","Placement"}
		},
		BottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Sample] | Object[Container] | Model[Sample], Null},
			Description -> "A list of deck placements used to place the activator, cap A, cap B, and oxidizer solution vessels onto the synthesizer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Reagent","Placement"}
		},
		PrimedValves -> {
			Format -> Multiple,
			Class ->String,
			Pattern :> _String,
			Description -> "A list of ABI3900 valves to prime and wash during DNA synthesis.",
			Category -> "Placements",
			Developer -> True
		},
		PlaceholderBottlePlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used to place the activator, cap A, cap B, and oxidizer vessel placeholders on the instrument in between protocols and during instrument cleaning.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Placeholder","Placement"}
		},
		WashPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Model[Sample] | Object[Sample], Null},
			Description -> "A list of deck placements used to place the wash solution vessels onto the synthesizer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Reagent","Placement"}
		},
		PlaceholderWashPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used to place the wash vessel placeholders on the instrument in between protocols and during instrument cleaning.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Placeholder","Placement"}
		},
		DeblockPlacement -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container]| Model[Sample] | Object[Sample], Null},
			Description -> "A list of deck placements used to place the deblock solution vessels onto the synthesizer deck.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Reagent","Placement"}
		},
		PlaceholderDeblockPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container], Null},
			Description -> "A list of deck placements used to place the deblock vessel placeholders on the instrument in between protocols and during instrument cleaning.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Placeholder","Placement"}
		},
		SynthesizerWashSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to clean the synthesizer.",
			Category -> "Qualifications & Maintenance"
		},
		CleaningPrepManipulation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,SampleManipulation],
			Description -> "The set of instructions specifying the transfers of synthesizer wash solution to the placeholder bottles.",
			Category -> "Qualifications & Maintenance",
			Developer->True
		},
		CleaningPrepPrimitives->{
			Format->Multiple,
			Class -> Expression,
			Pattern :> SampleManipulationP,
			Description -> "The set of instructions specifying the transfers of synthesizer wash solution to the placeholder bottles.",
			Category -> "Qualifications & Maintenance",
			Developer->True
		},
		WashSolutionVolumeEstimate -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milli*Liter],
			Units -> Milli*Liter,
			Description -> "The weight of wash solution (including bottle) that is necessary for the entire protocol.",
			Category -> "Washing",
			Developer -> True
		},
		DeblockSolutionVolumeEstimate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Milli*Liter],
			Units -> Milli*Liter,
			Description -> "The weight of deprotection solution (including bottle) that is necessary for the entire protocol.",
			Category -> "Deprotection",
			Developer -> True
		},
		EstimatedSynthesisTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "The estimated time needed to synthesize the samples.",
			Category -> "Synthesis",
			Developer -> True
		},
		CycleFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the excel file that contains the cycle information for this protocol.",
			Category -> "General",
			Developer -> True
		},
		CycleFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the cycle information.",
			Category -> "General",
			Developer->True
		},
		SequenceFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the text file that contains the sequence information for this protocol.",
			Category -> "General",
			Developer -> True
		},
		SequenceFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The file containing the sequence information.",
			Category -> "General",
			Developer->True
		},
		SynSequenceFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The filepath of the .syn file that contains the sequence information for this protocol.",
			Category -> "General",
			Developer -> True
		},
		DeblockSolutionWeightData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the DNA Synthesizer deprotection solution bottle, measured at the start of the protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},
		WashSolutionWeightData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The weight of the DNA Synthesizer wash solution bottles, measured at the start of the protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},
		InitialPurgePressure -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "The pressure of the argon gas connected to the synthesizer, measured at the start of the protocol.",
			Category -> "Sensor Information",
			Developer -> True
		},
		PressureLogStartTime -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _?DateObjectQ,
			Description -> "A specific timepoint of interest. In particular, this field is used in this protocol to specify the initial timepoint of the pressure log.",
			Category -> "Sensor Information",
			Developer -> True
		},
		ChamberPressureTestLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Pressure of the synthesis chamber monitored during the chamber pressure test.",
			Category -> "Sensor Information",
			Developer -> True
		},
		PressureTestResult -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Passed | Failed,
			Description -> "The result of the DNA Synthesizer chamber pressure test. The test is considered Passed, if the chamber holds pressures of equal to or greater than 2 PSI for 30 seconds or more.",
			Category -> "General",
			Developer -> True
		},
		ChamberPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Pressure of the synthesis chamber monitored throughout the synthesis.",
			Category -> "Sensor Information"
		},
		PurgePressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Purge pressure monitored throughout the synthesis.",
			Category -> "Sensor Information"
		},
		AmiditeAndACNPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Delivery pressure for the Amidites and Acetonitrile lines monitored throughout the synthesis.",
			Category -> "Sensor Information"
		},
		CapAndActivatorPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Delivery pressure for the Cap and Activator lines monitored throughout the synthesis.",
			Category -> "Sensor Information"
		},
		DeblockAndOxidizerPressureLog -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data][Protocol],
			Description -> "Delivery pressure for the Deblock and Oxidizer lines monitored throughout the synthesis.",
			Category -> "Sensor Information"
		},
		CleavageBatching->{
			Format->Multiple,
			Class->{
				Strand->Link,
				CleavageContainer->Link,
				Filter->Link,
				Time->Real,
				Temperature->Real,
				CleavageSolutionPrimitive->Expression,
				FilterTransferPrimitive->Expression,
				ResinWashPrimitive->Expression,
				FilterWashPrimitive->Expression
			},
			Pattern:>{
				Strand->_Link,
				CleavageContainer->_Link,
				Filter->_Link,
				Time->GreaterP[0*Minute],
				Temperature->GreaterP[0*Kelvin],
				CleavageSolutionPrimitive->SampleManipulationP,
				FilterTransferPrimitive->SampleManipulationP,
				ResinWashPrimitive->SampleManipulationP,
				FilterWashPrimitive->SampleManipulationP
			},
			Relation->{
				Strand->Model[Sample],
				CleavageContainer->Object[Container],
				Filter->Alternatives[Object[Container],Object[Sample],Object[Item]], (* TODO: Remove Object[Sample] here after item migration *)
				Time->Null,
				Temperature->Null,
				CleavageSolutionPrimitive->Null,
				FilterTransferPrimitive->Null,
				ResinWashPrimitive->Null,
				FilterWashPrimitive->Null
			},
			Units->{
				Strand->None,
				CleavageContainer->None,
				Filter->None,
				Time->Minute,
				Temperature->Celsius,
				CleavageSolutionPrimitive->None,
				FilterTransferPrimitive->None,
				ResinWashPrimitive->None,
				FilterWashPrimitive->None
			},
			Description-> "Parameters describing how each each sample will be cleaved.",
			Category->"Cleavage",
			Developer->True
		},
		CleavageBatchingTempTesting->{
			Format->Multiple,
			Class->{
				Strand->Link,
				CleavageContainer->Link,
				Filter->Link,
				Time->Real,
				Temperature->Real,
				Pipette->Link,
				Tips->Link,
				CleavageSolutionPrimitive->Expression,
				FilterTransferPrimitive->Expression,
				ResinWashPrimitive->Expression,
				FilterWashPrimitive->Expression
			},
			Pattern:>{
				Strand->_Link,
				CleavageContainer->_Link,
				Filter->_Link,
				Time->GreaterP[0*Minute],
				Temperature->GreaterP[0*Kelvin],
				Pipette->_Link,
				Tips->_Link,
				CleavageSolutionPrimitive->SampleManipulationP,
				FilterTransferPrimitive->SampleManipulationP,
				ResinWashPrimitive->SampleManipulationP,
				FilterWashPrimitive->SampleManipulationP
			},
			Relation->{
				Strand->Model[Sample],
				CleavageContainer->Object[Container],
				Filter->Alternatives[Object[Container],Object[Item]],
				Time->Null,
				Temperature->Null,
				Pipette->Alternatives[Object[Instrument,Pipette],Model[Instrument,Pipette]],
				Tips->Alternatives[Object[Item,Tips],Model[Item,Tips]],
				CleavageSolutionPrimitive->Null,
				FilterTransferPrimitive->Null,
				ResinWashPrimitive->Null,
				FilterWashPrimitive->Null
			},
			Units->{
				Strand->None,
				CleavageContainer->None,
				Filter->None,
				Time->Minute,
				Temperature->Celsius,
				Pipette->None,
				Tips->None,
				CleavageSolutionPrimitive->None,
				FilterTransferPrimitive->None,
				ResinWashPrimitive->None,
				FilterWashPrimitive->None
			},
			Description-> "Parameters describing how each each sample will be cleaved.",
			Category->"Cleavage",
			Developer->True
		},
		CleavageBatchLengths->{
			Format->Multiple,
			Class->Integer,
			Pattern:>GreaterP[0],
			Description->"The length of each cleavage batch.",
			Category->"Cleavage",
			Developer->True
		},
		CleavageBatchingDurations -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "Estimated duration of each cleavage batch.",
			Category -> "Cleavage",
			Developer->True
		},
		TotalCleavageDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Hour],
			Units -> Hour,
			Description -> "Estimated total duration of each the cleavage.",
			Category -> "Cleavage",
			Developer->True
		},
		EvaporationInstruments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument,VacuumCentrifuge],
				Object[Instrument,VacuumCentrifuge],
				Model[Instrument,Evaporator],
				Object[Instrument,Evaporator]
			],
			Description -> "The devices used to remove cleavage solvents and dry the synthesized material after cleavage incubation.",
			Category -> "Cleavage"
		},
		CleavageIncubationInstruments->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives@@Join[MixInstrumentModels,MixInstrumentObjects],
			Description -> "The devices used to incubate oligomer solution with cleavage solution.",
			Category -> "Cleavage"
		},

		(*== new fields for allow 2 oxidizers ==*)
		SecondaryOxidationSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solution used to oxidize the DNA backbone, thereby converting the phosphite triester to a more stableform; used by the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		SecondaryNumberOfOxidations -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of oxidation iterations for the secondary set of cycle parameters.",
			Category -> "Oxidation"
		},
		SecondaryOxidationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with secondary oxidation solution.",
			Category -> "Oxidation"
		},
		SecondaryOxidationVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of the secondary oxidation solution used in each oxidation iteration specified in the secondary set of the cycle parameters.",
			Category -> "Oxidation"
		},
		SecondaryNumberOfOxidationWashes -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of washes following oxidation for the secondary set of the cycle parameters.",
			Category -> "Oxidation"
		},
		SecondaryOxidationWashTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * Second],
			Units -> Second,
			Description -> "Amount of time that the solid supports are incubated with wash solution following oxidation for  the secondary set of the cycle parameters.",
			Category -> "Oxidation"
		},
		SecondaryOxidationWashVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Micro * Liter],
			Units -> Liter Micro,
			Description -> "The volume of wash solution for each post-oxidation wash for the secondary set of the cycle parameters.",
			Category -> "Oxidation"
		},

		SecondaryCyclePositions -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[_Integer],
			Description -> "Positions that should use the secondary cycle parameters (Lower Case).",
			Category -> "Oxidation"
		},

		FinalSequences -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule, Oligomer],
			Description -> "Oligomer models that the final samples should have once the experiment was completed.",
			Category -> "Synthesis"
		},
		ActivatorSolutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"The non-default storage condition for the ActivatorSolutionStorageCondition once the experiment is set up.",
			Category->"Storage Information"
		},
		CapASolutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"The non-default storage condition for the CapASolutionStorageCondition once the experiment is set up.",
			Category->"Storage Information"
		},
		CapBSolutionStorageConditions->{
			Format->Multiple,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"The non-default storage condition for the CapBSolutionStorageCondition once the experiment is set up.",
			Category->"Storage Information"
		},
		OxidationSolutionStorageConditions->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"The non-default storage condition for the OxidationSolutionStorageCondition once the experiment is set up.",
			Category->"Storage Information"
		},
		SecondaryOxidationSolutionStorageConditions->{
			Format->Single,
			Class->Expression,
			Pattern:>Alternatives[SampleStorageTypeP,Disposal],
			Description->"The non-default storage condition for the SecondaryOxidationSolutionStorageCondition once the experiment is set up.",
			Category->"Storage Information"

		}
	}
}
];
