(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*UploadStockSolution*)


(* ::Subsubsection:: *)
(*UploadStockSolution*)


(*
	The filter tests specifically have DeveloperSearch on False because resolveFilterOptions just can't do anything unless allowed to Search and find like a billion different things
*)
DefineTests[UploadStockSolution,
	{
		Example[{Basic,"Create a model for a salt solution filled to a total volume of 1L with deionized water:"},
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Basic,"Create a model for a 50% (v/v) methanol/water solution:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Basic,"Create a model for a 50% (v/v) methanol/water solution:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Basic,"Create a model for a solution of multiple solid components with a total volume of 1L:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Basic,"Create a model for a stock solution based on unit operations:"},
			UploadStockSolution[
				{
					LabelContainer[Label->"tube", Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Sodium Chloride"],Destination->"tube", Amount->100 Milligram],
					Transfer[Source-> Model[Sample,"Milli-Q water"], Destination->"tube",Amount->500 Microliter]
				}
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Additional,"Create a model for a stock solution based on various unit operations:"},
			UploadStockSolution[
				{
					LabelContainer[Label->"output container",Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"output container", Amount->1 Milliliter],
					Mix[Sample->"output container", MixType->Vortex, Time->10 Minute]
				}
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Additional,"Template Input","A template stock solution may also be provided directly as an input; this template specification will use the Formula from the template solution as the new solution's formula, as well as using preparation parameters in the template for option defaults:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				Name->"New 10% MeOH v/v"<>$SessionUUID
			];
			Download[{Model[Sample,StockSolution,"New 10% MeOH v/v"<>$SessionUUID],Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"]},Formula],
			{
				{
					{10. Milliliter,ObjectP[Model[Sample,"Methanol"]]},
					{90. Milliliter,ObjectP[Model[Sample,"Milli-Q water"]]}
				},
				{
					{10. Milliliter,ObjectP[Model[Sample,"Methanol"]]},
					{90. Milliliter,ObjectP[Model[Sample,"Milli-Q water"]]}
				}
			}
		],
		Test["If a template is provided as input with no other information, the same model should be returned:",
			UploadStockSolution[Model[Sample,StockSolution,"70% Ethanol"]],
			ObjectP[Model[Sample,StockSolution,"70% Ethanol"]]
		],
		Test["A stock solution with a single liquid component and no solvent should not resolve to Fill-To-Volume (and break as a result):",
			UploadStockSolution[Model[Sample,StockSolution,"UploadStockSolutionModel Test Model (No Solvent) "<>$SessionUUID]],
			ObjectP[Model[Sample,StockSolution]],
			(* This one needs to be $DeveloperSearch = True so it can find the existing solution and its existing alterantive solution *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestSearchName="UploadStockSolutionModel Test Model (No Solvent) ",
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=False
			}
		],
		Test["If a template is provided as input with no other information, but a new Name forces new model creation, the AlternativePreparations point at each other:",
			UploadStockSolution[Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"], Name->"New 10% MeoH"<>$SessionUUID];
			Download[Model[Sample,StockSolution,"New 10% MeoH"<>$SessionUUID], AlternativePreparations],
			{ObjectP[Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"]]},
			(* This one needs to be $DeveloperSearch = True so it can find the existing solution and its existing alterantive solution *)
			Stubs :> {
				$DeveloperSearch = True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			}
		],
		Example[{Additional,"Liquid components can be specified with amounts that have units of mass:"},
			UploadStockSolution[
				{
					{100 Gram,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				}
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Additional,"The Formula, FillToVolumeSolvent, and TotalVolume fields in the uploaded stock solution model are populated with the provided inputs for a fill-to-volume style solution:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				{Formula[[All,2]][Name],Formula[[All,1]],FillToVolumeSolvent[Name],TotalVolume}
			],
			{
				{"Sodium Chloride","Potassium Chloride","Dibasic Sodium Phosphate","Potassium Phosphate"},
				{80 Gram,2 Gram,14.4 Gram,2.4 Gram},
				"Milli-Q water",
				1. Liter
			}
		],
		Example[{Additional,"Only the Formula field is populated for a stock solution with no specified solvent or fill-to volume:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]},
						{10 Gram,Model[Sample,"Sodium Chloride"]}
					}
				],
				{Formula[[All,2]][Name],Formula[[All,1]],FillToVolumeSolvent,TotalVolume}
			],
			{
				{"Milli-Q water","Methanol","Sodium Chloride"},
				{500 Milliliter,500 Milliliter,10 Gram},
				Null,
				Null
			}
		],
		Example[{Additional,"The solvent of a solution may itself be a stock solution:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,StockSolution,"70% Ethanol"],
					1 Liter
				],
				FillToVolumeSolvent[Name]
			],
			"70% Ethanol"
		],
		Example[{Additional,"Formula components may themselves be stock solutions:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
					}
				],
				Formula[[All,2]][Name]
			],
			{"Milli-Q water","70% Ethanol"}
		],
		Example[{Additional,"If an existing stock solution model is found in Constellation that has the exact same formula components in the same ratios, as well as identical preparation parameters, that model is returned in lieu of generating a new model:"},
			Download[
				UploadStockSolution[
					{
						{10 Milliliter,Model[Sample,"Methanol"]},
						{90 Milliliter,Model[Sample,"Milli-Q water"]}
					}
				],
				Name
			],
			(* This could end up being a $SessionUUID one too so want to cover both bases *)
			"Existing Solution of 10% v/v Methanol in Water" ~~ ___,
			EquivalenceFunction->StringMatchQ,
			(* want this to be $DeveloperSearch = True because we need it to find a not-real object properly *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True,
				Experiment`Private`$StockSolutionUnitTestSearchName="Existing Solution of 10% v/v Methanol in Water"
			},
			SetUp:>(
				(* Model[Sample,"Milli-Q water"] has a ShelfLife of 1Year and our stock solution is resolved to have a shelf life of 1 Year. We only think the stock solution is a match when expiration information is the same. Make sure we reset the ShelfLife and UnsealedShelfLife if they get reset by other tests *)
				Upload[<|Object->Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water"],ShelfLife->1Year,UnsealedShelfLife->1Year|>]
			)
		],
		Example[{Additional,"Create a model for a solution in which a solid component is a tablet by specifying a particular count of tablets to be included in the mixture:"},
			UploadStockSolution[
				{
					{2,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Additional,"A stock solution formula including a tablet component will not have a unit associated with the component amount:"},
			Download[
				UploadStockSolution[
					{
						{2,Model[Sample,"Acetaminophen (tablet)"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				Formula
			],
			{{2 Unit,ObjectP[Model[Sample,"Acetaminophen (tablet)"]]}}
		],
		Example[{Additional,"A stock solution including a tablet component will automatically be marked as only preparable in multiples that require equal or less than the lowest of all tablet counts:"},
			Download[
				UploadStockSolution[
					{
						{2,Model[Sample,"Acetaminophen (tablet)"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				VolumeIncrements
			],
			{0.5 Liter,1 Liter},
			EquivalenceFunction->Equal
		],
		Example[{Additional, "A stock solution including a fixed-aliquot sample populates the VolumeIncrements field:"},
			Download[UploadStockSolution[
				{
					{ 5*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				}
			], VolumeIncrements],
			{2*Milliliter},
			EquivalenceFunction->Equal
		],
		Example[{Additional, "A stock solution including a fixed amounts sample has the Resuspension resolved to True automatically:"},
			Download[UploadStockSolution[
				{
					{ 5*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				}
			], Resuspension],
			True,
			EquivalenceFunction->MatchQ
		],
		Example[{Additional, "Safety information of the stock solution is automatically resolved based on the formula components:"},
			Module[{modelInfo, ventilatedQ, flammableQ, fumingQ, incompatibleMaterials, ssModel},
				(* download from model info *)
				modelInfo = Transpose[Download[
					{Model[Sample,"PETG powder"], Model[Sample,"DMSO, anhydrous"]},
					{Ventilated, Flammable, Fuming, IncompatibleMaterials}
				]];

				(* expected value *)
				ventilatedQ = If[NullQ[modelInfo[[1]]], Null, MemberQ[modelInfo[[1]], True]];
				flammableQ = If[NullQ[modelInfo[[2]]], Null, MemberQ[modelInfo[[2]], True]];
				fumingQ = If[NullQ[modelInfo[[3]]], Null, MemberQ[modelInfo[[3]], True]];
				incompatibleMaterials = Module[{combinedIncompatibleMaterials},
					combinedIncompatibleMaterials = Cases[Flatten[modelInfo[[4]]], MaterialP];
					If[Length[combinedIncompatibleMaterials] == 0, {None}, combinedIncompatibleMaterials]
				];

				ssModel = UploadStockSolution[
					{
						{6 Milligram, Model[Sample, "PETG powder"]},
						{2 Milliliter, Model[Sample, "DMSO, anhydrous"]}
					}
				];

				MatchQ[
					Download[ssModel, {Ventilated, Flammable, Fuming, IncompatibleMaterials}],
					{ventilatedQ, flammableQ, fumingQ, incompatibleMaterials}
				]
			],
			True
		],
		Example[{Additional,"Formula Issues","Formula components must be unique:"},
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				}
			],
			$Failed,
			Messages:>{Error::DuplicatedComponents,Error::InvalidInput}
		],
		Example[{Additional,"Formula Issues","Formula components cannot be deprecated:"},
			UploadStockSolution[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter
			],
			$Failed,
			Messages:>{Error::DeprecatedComponents,Error::InvalidInput}
		],
		Example[{Additional,"Formula Issues","If no solvent is explicitly provided, the mixture of all solids will be a new stock solution with State->Solid:"},
			Download[UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				}
			], State],
			Solid
		],
		Example[{Additional,"Formula Issues","The solvent must be a liquid if explicitly provided:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::SolventNotLiquid,Error::InvalidInput}
		],
		Example[{Additional,"Formula Issues","Only solids and liquids are supported as formula components:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentStateInvalid,Error::InvalidInput}
		],
		Example[{Additional,"Formula Issues","Tablet components must be specified in amounts that are tablet counts, not masses:"},
			UploadStockSolution[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentRequiresTabletCount,Error::InvalidInput}
		],
		Example[{Additional,"Formula Issues","The sum of the volumes of any formula components should not exceed the requested total volume of the solution:"},
			UploadStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption}
		],

		Test["If making two separate stock solutions, one defined by mass and one defined by volume, just because the numbers are the same doesn't mean that the ratios are the same so two different stock solutions are created:",
			stockSolution1 = UploadStockSolution[
				{
					{1 Gram, Model[Sample, "Methanol"]},
					{1.234 Gram, Model[Sample, "Milli-Q water"]},
					{1.2345 Gram, Model[Sample,"Ethyl acetate, HPLC Grade"]}
				}
			];

			stockSolution2 = UploadStockSolution[
				{
					{1 Milliliter, Model[Sample, "Methanol"]},
					{1.234 Milliliter, Model[Sample, "Milli-Q water"]},
					{1.2345 Milliliter, Model[Sample,"Ethyl acetate, HPLC Grade"]}
				}
			];

			stockSolution1 === stockSolution2,
			False,
			Variables :> {stockSolution1, stockSolution2},
			TimeConstraint -> 500
		],
		(* --- Messages --- *)
		Example[{Options,PrepareInResuspensionContainer, "Use PrepareInResuspensionContainer options to indicate if the stock solution should be prepared in the original container of the fixed amounts component in the formula:"},
			Download[UploadStockSolution[
				{
					{ 5*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				},
				PrepareInResuspensionContainer->True
			], PrepareInResuspensionContainer],
			True,
			EquivalenceFunction->MatchQ
		],
		Example[{Messages, "InvalidPreparationInResuspensionContainer", "If there is no fixed amounts sample in the formula, PrepareInResuspensionContainer cannot be True:"},
			UploadStockSolution[
				{
					{ 10*Milligram,Model[Sample,"Sodium Chloride"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				},
				PrepareInResuspensionContainer->True
			],
			$Failed,
			Messages:>{Error::InvalidPreparationInResuspensionContainer,Error::InvalidOption}
		],
		Example[{Messages, "InvalidResuspensionAmounts", "When PrepareInResuspensionContainer is True, the amount of the fixed amounts component in the formula has to be a member of its FixedAmounts field:"},
			UploadStockSolution[
				{
					{ 7*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				},
				PrepareInResuspensionContainer->True
			],
			$Failed,
			Messages:>{Error::InvalidResuspensionAmounts,Error::InvalidOption}
		],
		Example[{Options,Resuspension, "Use Resuspension options to indicate if the stock solution has a fixed amount component that should be resuspended in its original container first:"},
			Download[UploadStockSolution[
				{
					{ 5*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Resuspension->True
			], Resuspension],
			True,
			EquivalenceFunction->MatchQ
		],
		Example[{Messages, "InvalidResuspensionOption", "A stock solution including a fixed-aliquot sample cannot have the Resuspension set to False:"},
			UploadStockSolution[
				{
					{ 5*Milligram,Model[Sample,"Fake Fixed Aliquot Solid Model for StockSolution Testing"]},
					{ 2*Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Resuspension->False
			],
			$Failed,
			Messages:>{Error::InvalidResuspensionOption,Error::InvalidOption}
		],
		Example[{Messages,"DeprecatedTemplate","A template model used as input cannot be deprecated:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"],
				Name->"New Version of 20% Methanol v/v"<>$SessionUUID
			],
			$Failed,
			Messages:>{Error::DeprecatedTemplate,Error::InvalidInput}
		],
		Example[{Messages,"NoNominalpH","A pHingBase cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->False,
				pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"]
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Example[{Options, SafetyOverride, "If the order of the components are such that liquid acids are added before other liquid components and the solution is safe to create, specify a safety override:"},
			Download[
				UploadStockSolution[
					{
						{0.001 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{10 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					SafetyOverride->True
				],
				Formula
			],
			{
				{RangeP[0.0005 Milliliter, 0.005 Milliliter],ObjectP[Model[Sample,"Trifluoroacetic acid"]]},
				{RangeP[9 Milliliter, 11 Milliliter] ,ObjectP[Model[Sample,"Milli-Q water"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Messages, "ComponentOrder", "If the order of the components are such that liquid acids are added before other liquid components, throw a warning and change the order:"},
			Download[
				UploadStockSolution[
					{
						{19 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{6 Milliliter,Model[Sample,"Milli-Q water"]}
					}
				],
				Formula
			],
			{
				{RangeP[6 Milliliter, 6 Milliliter] ,ObjectP[Model[Sample,"Milli-Q water"]]},
				{RangeP[19 Milliliter, 19 Milliliter],ObjectP[Model[Sample,"Trifluoroacetic acid"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Messages, "ComponentOrder", "If in a fill-to-volume stock solution and using an acid, alter the formula to add some of the fill-to-volume solvent before adding the acid, and filling to the requested volume after:"},
			Download[
				UploadStockSolution[
					{
						{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					Model[Sample,"Milli-Q water"],
					25*Milliliter
				],
				Formula
			],
			{
				{UnitsP[Milliliter],ObjectP[Model[Sample,"Milli-Q water"]]},
				{RangeP[20 Milliliter, 20 Milliliter],ObjectP[Model[Sample,"Trifluoroacetic acid"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Messages, "ComponentOrder", "If in a formula-only stock solution and using an acid and there is UsedAsSolvent liquid added before the acid to a sufficient amount, no warning is thrown and the input order is respected:"},
			Download[
				UploadStockSolution[
					{
						{100 Milliliter, Model[Sample,"Milli-Q water"]},
						{58.44 Gram, Model[Sample, "Sodium Chloride"]},(* component not considered, put here just to test the robustness of all the positions calculation *)
						{20 Milliliter, Model[Sample, "Trifluoroacetic acid"]}
					}
				],
				Formula
			],
			{
				{EqualP[100 Milliliter], ObjectP[Model[Sample,"Milli-Q water"]]},
				{EqualP[58.44 Gram], ObjectP[Model[Sample, "Sodium Chloride"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Trifluoroacetic acid"]]}
			}
		],
		Example[{Messages, "ComponentOrder", "If in a formula-only stock solution and using more than one acid, if at the addition of any acid and there is not sufficient UsedAsSolvent liquid added before for the combined acid volume, but we are not adding more liquid to it, no warning is thrown and the input order is respected:"},
			Download[
				UploadStockSolution[
					{
						{100 Milliliter, Model[Sample, "Milli-Q water"]},
						{58.44 Gram, Model[Sample, "Sodium Chloride"]},(* component not considered, put here just to test the robustness of all the positions calculation *)
						{20 Milliliter, Model[Sample, "Trifluoroacetic acid"]},
						{20 Milliliter, Model[Sample, "Formic Acid, LCMS Grade"]}
					}
				],
				Formula
			],
			{
				{EqualP[100 Milliliter],ObjectP[Model[Sample,"Milli-Q water"]]},
				{EqualP[58.44 Gram], ObjectP[Model[Sample, "Sodium Chloride"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Trifluoroacetic acid"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Formic Acid, LCMS Grade"]]}
			}
		],
		Example[{Messages, "ComponentOrder", "If in a formula-only stock solution and using more than one acid, if at the addition of any acid and there is not sufficient UsedAsSolvent liquid added before for the combined acid volume, and we are adding more liquid to it, throw a warning and adjust the order:"},
			Download[
				UploadStockSolution[
					{
						{100 Milliliter, Model[Sample, "Milli-Q water"]},
						{58.44 Gram, Model[Sample, "Sodium Chloride"]},(* component not considered, put here just to test the robustness of all the positions calculation *)
						{20 Milliliter, Model[Sample, "Trifluoroacetic acid"]},
						{20 Milliliter, Model[Sample, "Formic Acid, LCMS Grade"]},
						{100 Milliliter, Model[Sample, "Acetonitrile, Anhydrous"]}
					}
				],
				Formula
			],
			{
				{EqualP[100 Milliliter],ObjectP[Model[Sample,"Milli-Q water"]]},
				{EqualP[58.44 Gram], ObjectP[Model[Sample, "Sodium Chloride"]]},
				{EqualP[100 Milliliter], ObjectP[Model[Sample, "Acetonitrile, Anhydrous"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Trifluoroacetic acid"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Formic Acid, LCMS Grade"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Messages, "ComponentOrder", "If in a fill-to-volume stock solution and using an acid and there is another UsedAsSolvent liquid added before the acid to a sufficient amount, no warning is thrown and the input order is respected:"},
			Download[
				UploadStockSolution[
					{
						{100 Milliliter, Model[Sample, "Acetonitrile, Anhydrous"]},
						{58.44 Gram, Model[Sample, "Sodium Chloride"]},(* component not considered, put here just to test the robustness of all the positions calculation *)
						{20 Milliliter, Model[Sample, "Trifluoroacetic acid"]}
					},
					Model[Sample, "Milli-Q water"],
					150 * Milliliter
				],
				Formula
			],
			{
				{EqualP[100 Milliliter], ObjectP[Model[Sample, "Acetonitrile, Anhydrous"]]},
				{EqualP[58.44 Gram], ObjectP[Model[Sample, "Sodium Chloride"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Trifluoroacetic acid"]]}
			}
		],
		Example[{Messages, "ComponentOrder", "If in a fill-to-volume stock solution and using more than one acid, if at the addition of any acid and there is not sufficient UsedAsSolvent liquid added before for the combined acid volume, throw a warning and adjust the order:"},
			Download[
				UploadStockSolution[
					{
						{100 Milliliter, Model[Sample, "Acetonitrile, Anhydrous"]},
						{58.44 Gram, Model[Sample, "Sodium Chloride"]},(* component not considered, put here just to test the robustness of all the positions calculation *)
						{20 Milliliter, Model[Sample, "Trifluoroacetic acid"]},
						{20 Milliliter, Model[Sample, "Formic Acid, LCMS Grade"]}
					},
					Model[Sample, "Milli-Q water"],
					200 * Milliliter
				],
				Formula
			],
			{
				{EqualP[100 Milliliter], ObjectP[Model[Sample, "Acetonitrile, Anhydrous"]]},
				{EqualP[58.44 Gram], ObjectP[Model[Sample, "Sodium Chloride"]]},
				{UnitsP[Milliliter],ObjectP[Model[Sample,"Milli-Q water"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Trifluoroacetic acid"]]},
				{EqualP[20 Milliliter], ObjectP[Model[Sample, "Formic Acid, LCMS Grade"]]}
			},
			Messages :> {
				Warning::ComponentOrder
			}
		],
		Example[{Messages, "MixTimeIncubateTimeMismatch", "If MixTime and IncubationTime are both specified, they must be the same:"},
			UploadStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				MixTime->20 Minute,
				IncubationTime->30 Minute
			],
			$Failed,
			Messages :> {
				Error::MixTimeIncubateTimeMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NoNominalpH","MinpH cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MinpH->6.5,
				AdjustpH->False
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Example[{Messages,"AcidBaseConflict","Acid and Base storage cannot be simultaneously required for a stock solution:"},
			UploadStockSolution[
				{
					{5 Milliliter,Model[Sample,"Milli-Q water"]},
					{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
				},
				Acid->True,
				Base->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::StorageCombinationUnsupported,Error::InvalidOption}
		],
		Example[{Messages,"ComponentRequiresTabletCount","Tablet components must be specified in amounts that are tablet counts, not masses:"},
			UploadStockSolution[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentRequiresTabletCount,Error::InvalidInput}
		],
		Example[{Messages,"ComponentStateInvalid","Only solids and liquids are supported as formula components:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::ComponentStateInvalid,Error::InvalidInput}
		],
		Example[{Messages,"DeprecatedComponents","Formula components cannot be deprecated:"},
			UploadStockSolution[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter
			],
			$Failed,
			Messages:>{Error::DeprecatedComponents,Error::InvalidInput}
		],
		Example[{Messages,"DeprecatedTemplate","If a provided template model is deprecated, it will not be used as a source of default option values:"},
			UploadStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"New Version of 10% Methanol v/v"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"]
			];
			Download[{Model[Sample,StockSolution,"New Version of 10% Methanol v/v"<>$SessionUUID],Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"]},MixTime],
			{15. Minute,20. Minute},
			Messages:>{Warning::DeprecatedTemplate}
		],
		Example[{Messages,"DeprecatedTemplate","A template model used as input cannot be deprecated:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"],
				Name->"New Version of 20% Methanol v/v"<>$SessionUUID
			],
			$Failed,
			Messages:>{Error::DeprecatedTemplate,Error::InvalidInput}
		],
		Example[{Messages,"DuplicatedComponents","Formula components must be unique:"},
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				}
			],
			$Failed,
			Messages:>{Error::DuplicatedComponents,Error::InvalidInput}
		],
		Example[{Messages,"ExpirationShelfLifeConflict","If Expires is set to False, ShelfLife/UnsealedShelfLife cannot also be set:"},
			UploadStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year
			],
			$Failed,
			Messages:>{Error::ExpirationShelfLifeConflict,Error::InvalidOption}
		],
		Example[{Messages,"FilterOptionConflictUSS","This boolean option must be set to True in order to set specific filtration parameters:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				FilterMaterial->Cellulose
			],
			$Failed,
			Messages:>{Error::FilterOptionConflictUSS,Error::InvalidOption}
		],
		Example[{Messages,"FormulaVolumeTooLarge","The sum of the volumes of any formula components should not exceed the requested total volume of the solution:"},
			UploadStockSolution[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption}
		],
		Example[{Messages,"IncubateOptionConflict","Setting Incubate to False but specifying incubation parameters results in an error:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubate->False,
				IncubationTemperature->40*Celsius
			],
			$Failed,
			Messages:>{Error::IncubateOptionConflict,Error::InvalidOption},
			TimeConstraint->1000(*,
			ConstellationDebug->True*)
		],
		Example[{Messages,"MixOptionConflict","Setting Mix to False but specifying mixing parameters results in an error:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Mix->False,
				MixTime->5 Minute
			],
			$Failed,
			Messages:>{Error::MixOptionConflict,Error::InvalidOption}
		],
		Example[{Messages,"pHOrderInvalidUSS","The NominalpH, MinpH, and MaxpH options should be in appropriate numerical order:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->7,
				MinpH->7.1,
				MaxpH->6.9
			],
			$Failed,
			Messages:>{Error::pHOrderInvalidUSS,Error::InvalidOption}
		],
		Example[{Messages,"SolventNotLiquid","The solvent must be a liquid if explicitly provided:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter
			],
			$Failed,
			Messages:>{Error::SolventNotLiquid,Error::InvalidInput}
		],
		Example[{Messages,"StockSolutionNameInUse","If a Name is already in use in Constellation, a new stock solution cannot also get that Name:"},
			UploadStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"Existing Solution of 10% v/v Methanol in Water"
			],
			$Failed,
			Messages:>{Error::StockSolutionNameInUse,Error::InvalidOption}
		],
		Example[{Messages,"StorageCombinationUnsupported","Acid and Base storage cannot be simultaneously required for a stock solution:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Hydroxide"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Base->True,
				Acid->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::StorageCombinationUnsupported,Error::InvalidOption}
		],
		Example[{Messages,"VolumeBelowFiltrationMinimum","The total preparation volume of the stock solution must exceed a minimum threshold for filtration to ensure that a method with low enough dead volume is available:"},
			UploadStockSolution[
				{
					{2 Milligram,Model[Sample,"Sodium Chloride"]},
					{1.5 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Filter->True
			],
			$Failed,
			Messages:>{Error::VolumeBelowFiltrationMinimum,Error::InvalidOption}
		],
		Example[{Messages,"VolumeBelowpHMinimum","If pH titration is requested, the preparation volume of the provided stock solution formula must exceed the minimum threshold to ensure the smallest pH probe can fit in any container in which this formula can be combined:"},
			UploadStockSolution[
				{
					{4 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				10 Milliliter,
				NominalpH->7
			],
			$Failed,
			Messages:>{Error::VolumeBelowpHMinimum,Error::InvalidOption}
		],
		Example[{Messages, "BelowFillToVolumeMinimum", "The solvent volume in a FillToVolume stock solution may not be outside of RangeP[$MinStockSolutionUltrasonicSolventVolume, $MaxStockSolutionComponentVolume]:"},
			UploadStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				4 Milliliter
			],
			$Failed,
			Messages :> {
				Error::BelowFillToVolumeMinimum,
				Error::InvalidOption
			}
		],
		Example[{Messages, "BelowFillToVolumeMinimum", "The solvent volume in a FillToVolume stock solution for Volumetric method has lower limits:"},
			UploadStockSolution[
				{
					{0.1 Gram, Model[Sample, "Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				2 Milliliter,
				FillToVolumeMethod->Volumetric
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Messages,"TemplateOptionUnused","If BOTH the template input and option are used, and the option differs from the input, the option will be ignored in favor of the direct input:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				Name->"New Version of 10% Methanol v/v"<>$SessionUUID,
				ShelfLife->2 Year,
				StockSolutionTemplate->Model[Sample,StockSolution,"10% ACN v/v"]
			];
			Download[{Model[Sample,StockSolution,"New Version of 10% Methanol v/v"<>$SessionUUID],Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],Model[Sample,StockSolution,"10% ACN v/v"]},MixTime],
			{15 Minute,15 Minute,1 Hour},
			EquivalenceFunction->Equal,
			Messages:>{Warning::TemplateOptionUnused}
		],
		Example[{Messages,"UnsealedShelfLifeLonger","A warning is provided if the provided UnsealedShelfLife is longer than the provided ShelfLife:"},
			UploadStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				ShelfLife->1 Year,
				UnsealedShelfLife->2 Year
			],
			ObjectP[Model[Sample,StockSolution]],
			Messages:>{Warning::UnsealedShelfLifeLonger}
		],
		Example[{Messages, "ComponentAmountOutOfRange", "If the provided liquid amount is above the maximum allowed in the ECL, throw an error:"},
			UploadStockSolution[
				{
					{5 Gram, Model[Sample,"Sodium Chloride"]},
					{30 Liter, Model[Sample,"Milli-Q water"]}
				}
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput},
			TimeConstraint->80
		],
		Example[{Messages,"ComponentAmountOutOfRange","If the provided solid amount is above the maximum allowed in the ECL, throw an error:"},
			UploadStockSolution[
				{
					{15 Kilogram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Liter
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput}
		],
		Example[{Messages,"ComponentAmountOutOfRange","If the provided solid amount is below the minimum allowed in the ECL, throw an error:"},
			UploadStockSolution[
				{
					{5.6 Microgram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages :> {Error::ComponentAmountOutOfRange, Error::InvalidInput}
		],
		Example[{Messages, "MixTypeRequired", "If MixRate is specified, MixType must also be specified:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixRate->100*RPM
			],
			$Failed,
			Messages :> {
				Error::MixTypeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MixTypeRequired", "If Mixer is specified, MixType must also be specified:"},
			UploadStockSolution[
				{
					{50 Milliliter,Model[Sample,"Milli-Q water"]},
					{50 Milliliter,Model[Sample,"Methanol"]}
				},
				Mixer->Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]
			],
			$Failed,
			Messages :> {
				Error::MixTypeRequired,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidUltrasonicFillToVolumeMethod","An error will be thrown when the FillToVolumeMethod is incompatible with the stock solution being prepared (Methanol is UltrasonicIncompatible):"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				FillToVolumeMethod->Ultrasonic
			],
			$Failed,
			Messages:>{Error::InvalidUltrasonicFillToVolumeMethod,Error::InvalidOption}
		],
		Example[{Messages, "InvalidVolumetricFillToVolumeMethod", "The solvent volume in a Volumetric FillToVolume stock solution cannot exceed the volume of the largest volumetric flask:"},
			UploadStockSolution[
				{
					{5 Milligram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				8 Liter,
				FillToVolumeMethod->Volumetric
			],
			$Failed,
			Messages :> {
				Error::VolumeTooLargeForInversion,
				Error::InvalidVolumetricFillToVolumeMethod,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidVolumetricFillToVolumeMethod", "The solvent volume in a Volumetric FillToVolume light-sensitive stock solution cannot exceed the volume of the largest opaque volumetric flask:"},
			Module[
				{lightSensitiveReturn,nonLightSensitiveReturn},
				lightSensitiveReturn=UploadStockSolution[
					{
						{5 Milligram,Model[Sample, "Reserpine, USP Reference Standard"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					LightSensitive->True,
					FillToVolumeMethod->Volumetric,
					(* Use name to force creation of new model *)
					Name->"UploadStockSolution test light-sensitive volumetric FTV stock solution model"<>$SessionUUID<>CreateUUID[]
				];
				nonLightSensitiveReturn=UploadStockSolution[
					{
						{5 Milligram,Model[Sample, "Reserpine, USP Reference Standard"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					LightSensitive->False,
					FillToVolumeMethod->Volumetric,
					(* Use name to force creation of new model *)
					Name->"UploadStockSolution test non-light-sensitive volumetric FTV stock solution model"<>$SessionUUID<>CreateUUID[],
					Upload->False
				];
				{lightSensitiveReturn,nonLightSensitiveReturn}
			],
			{$Failed,PacketP[]},
			Messages :> {
				Error::InvalidVolumetricFillToVolumeMethod,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidVolumetricFillToVolumeMethod", "The solvent volume in a Volumetric FillToVolume stock solution that is incompatible with Glass cannot exceed the volume of the largest polypropylene volumetric flask:"},
			Module[
				{incompatibleMaterialsReturn,nonIncompatibleMaterialsReturn},
				incompatibleMaterialsReturn=UploadStockSolution[
					{
						{5 Milligram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					IncompatibleMaterials -> {Glass},
					FillToVolumeMethod->Volumetric,
					(* Use name to force creation of new model *)
					Name->"UploadStockSolution test volumetric FTV stock solution model incompatible with Glass"<>$SessionUUID<>CreateUUID[]
				];
				nonIncompatibleMaterialsReturn=UploadStockSolution[
					{
						{5 Milligram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					IncompatibleMaterials -> {None},
					FillToVolumeMethod->Volumetric,
					(* Use name to force creation of new model *)
					Name->"UploadStockSolution test volumetric FTV stock solution model without incompatible materials"<>$SessionUUID<>CreateUUID[],
					Upload->False
				];
				{incompatibleMaterialsReturn,nonIncompatibleMaterialsReturn}
			],
			{$Failed,PacketP[]},
			Messages :> {
				Error::InvalidVolumetricFillToVolumeMethod,
				Error::InvalidOption
			}
		],
		Example[{Messages, "InvalidFillToVolumeMethodNoSolvent", "Solvent must be specified if a fill to volume method is specified:"},
			UploadStockSolution[
				{
					{5 Milliliter, Model[Sample, "Milli-Q water"]},
					{5 Milliliter, Model[Sample, "Ethanol, Reagent Grade"]}
				},
				FillToVolumeMethod -> Volumetric
			],
			$Failed,
			Messages :> {
				Error::InvalidFillToVolumeMethodNoSolvent,
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperations","FixedReagentAddition must occur first:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				OrderOfOperations->{Incubation,FixedReagentAddition,FillToVolume}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperations","Incubation (if present) must occur after any pHTitration/FillToVolume:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				OrderOfOperations->{FixedReagentAddition,Incubation,FillToVolume}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperations","Filtration must occur last (if present):"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				OrderOfOperations->{FixedReagentAddition,Filtration,FillToVolume}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperations","OrderOfOperations should not have duplicates:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				OrderOfOperations->{FixedReagentAddition,FixedReagentAddition,FillToVolume,Filtration}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperations","OrderOfOperations should be consistent with other options:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				AdjustpH->True,
				OrderOfOperations->{FixedReagentAddition,FillToVolume,Incubation}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperations,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidOrderOfOperationsForpH","pHTitration must occur after any liquid is added:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				AdjustpH->True,
				OrderOfOperations->{FixedReagentAddition,pHTitration,FillToVolume,Incubation}
			],
			$Failed,
			Messages :> {
				Error::InvalidOrderOfOperationsForpH,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NewModelCreation","A warning will be thrown if a new model is created when using template model input:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				MixUntilDissolved->True
			],
			ObjectP[Model[Sample,StockSolution]],
			Messages:>{Warning::NewModelCreation}
		],
		Example[{Messages,"ExistingModelReplacesInput","A warning will be thrown if an existing model fulfills the input template model with specified options:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				MixTime->30 Minute
			],
			ObjectP[Model[Sample,StockSolution,"Existing Alternative Solution of 10% v/v Methanol in Water"]],
			Messages:>{Warning::ExistingModelReplacesInput},
			(* This one needs to be $DeveloperSearch = True so it can find the existing solution and its existing alterantive solution *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			},
			SetUp:>(
				(* Model[Sample,"Milli-Q water"] has a ShelfLife of 1Year and our stock solution is resolved to have a shelf life of 1 Year. We only think the stock solution is a match when expiration information is the same. Make sure we reset the ShelfLife and UnsealedShelfLife if they get reset by other tests. We will make the changes permanent eventually *)
				Upload[<|Object->Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water"],ShelfLife->1Year,UnsealedShelfLife->1Year|>];
				Upload[<|Object->Model[Sample,StockSolution,"Existing Alternative Solution of 10% v/v Methanol in Water"],ShelfLife->1Year,UnsealedShelfLife->1Year|>];
			)
		],
		Example[{Messages,"ConflictingUnitOperationsOptions","An error will be thrown if a preparation option is specified when using the unit operations input:"},
			UploadStockSolution[
				{
					LabelContainer[Label->"output container",Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"output container", Amount->1 Milliliter],
					Mix[Sample->"output container", MixType->Vortex, Time->10 Minute]
				},
				Autoclave->True
			],
			$Failed,
			Messages:>{Error::ConflictingUnitOperationsOptions,Error::InvalidOption},
			SetUp:>(
				ClearMemoization[]
			),
			TearDown:>(
				ClearMemoization[];
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"InvalidLabelContainerUnitOperationInput","An error will be thrown if a the unit operations input does not start with a LabelContainer unit operation:"},
			UploadStockSolution[
				{
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"output container", Amount->1 Milliliter],
					LabelContainer[Label->"output container",Container->Model[Container, Vessel, "2mL Tube"]],
					Mix[Sample->"output container", MixType->Vortex, Time->10 Minute]
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabelContainerUnitOperationInput,Error::InvalidInput},
			SetUp:>(
				ClearMemoization[]
			),
			TearDown:>(
				ClearMemoization[];
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"UnitOperationsContainObject","An error will be thrown if unit operations have objects in them:"},
			UploadStockSolution[
				{
					LabelContainer[Label->"tube", Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Sodium Chloride"],Destination->"tube", Amount->10 Milligram],
					Transfer[Source->Object[Sample,"Fake sample object for UnitOperationsContainObject tests"], Destination->"tube",Amount->400 Microliter]
				}
			],
			$Failed,
			Messages:>{Error::UnitOperationsContainObject,Error::InvalidInput},
			SetUp:>(
				$CreatedObjects={};
				(* make a bench *)
				Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Unit Test bench for UnitOperationsContainObject tests",DeveloperObject->True,StorageCondition->Link[Model[StorageCondition,"Ambient Storage"]]|>];
				(* make a container for a water sample *)
				UploadSample[Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],{"Work Surface",Object[Container, Bench, "Unit Test bench for UnitOperationsContainObject tests"]} ,Status->Available,Name->"Unit Test container for UnitOperationsContainObject tests" ];
				(* make a water sample *)
				UploadSample[Model[Sample,"Milli-Q water"],{"A1",Object[Container, Vessel, "Unit Test container for UnitOperationsContainObject tests"]} ,Status->Available,InitialAmount->500*Microliter,Name->"Unit Test sample object for UnitOperationsContainObject tests" ];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"UnitOperationInvalidVolumeIncrement","An error will be thrown the specified VolumeIncrements are not multiples of the total volume of the resulting sample:"},
			UploadStockSolution[
				{
					LabelContainer[Label->"output container",Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"],Destination->"output container", Amount->1 Milliliter],
					Mix[Sample->"output container", MixType->Vortex, Time->10 Minute]
				},
				Name->"Test Stock solution model for UnitOperationInvalidVolumeIncrement test"<>$SessionUUID,
				VolumeIncrements->{1.1Milliliter, 2.2Milliliter}
			],
			$Failed,
			Messages:>{Error::UnitOperationInvalidVolumeIncrement,Error::InvalidOption},
			SetUp:>(
				ClearMemoization[]
			),
			TearDown:>(
				ClearMemoization[];
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"FormulaVolumeTooLarge","An error will be thrown if the input formula has the combined total volume of its components equal to or exceeds the model's TotalVolume:"},
			UploadStockSolution[
				{
					{80 Gram, Model[Sample, "Sodium Chloride"]},
					{1000 Milliliter, Model[Sample, "Milli-Q water"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter
			],
			$Failed,
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption},
			SetUp:>(
				ClearMemoization[]
			),
			TearDown:>(
				ClearMemoization[];
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Messages,"SpecifedMixRateNotSafe","If given formula, a warning will be thrown if the specified mix rate is over the safe mix rate of the container:"},
			protocol = UploadStockSolution[
				{
					{700 Milliliter, Model[Sample, "Milli-Q water"]}
				},
				MixRate -> 750 RPM, MixType -> Stir
			];
			Download[protocol, MixRate],
			EqualP[750 RPM],
			Messages:>{Warning::SpecifedMixRateNotSafe},
			Variables:>{protocol}
		],
		Example[{Messages,"SpecifedMixRateNotSafe","If given model stock solution, a warning will be thrown if the specified mix rate is over the safe mix rate of the container, and a new model will be generated with the specified mix rate:"},
			protocol = UploadStockSolution[
				Model[Sample, StockSolution, "Existing Solution of 10% v/v Methanol in Water"],
				MixRate -> 780 RPM, MixType -> Stir
			];
			Download[protocol, MixRate],
			EqualP[780 RPM],
			Messages:>{Warning::SpecifedMixRateNotSafe, Warning::NewModelCreation},
			Variables:>{protocol}
		],
		(* --- Options --- *)
		Example[{Options,Type,"Specify the SLL type of the new stock solution model being created:"},
			Lookup[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Type->Matrix,
					(* Since this test keep messing up ExpMS unit test by this test matrix, we changed this test to be Upload -> False *)
					Upload->False
				],
				Type
			],
			Model[Sample,Matrix]
		],
		Example[{Options,Type,"Specify the SLL type of the new stock solution model being created, which works for Standards too:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Type->Standard
				],
				Type
			],
			Model[Sample,StockSolution,Standard]
		],
		Example[{Options,Type,"Specify the SLL type of the new media model being created, with the UsedAsMedia field automatically set to True:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Type->Media
				],
				{Type,UsedAsMedia}
			],
			{Model[Sample,Media],True}
		],
		Example[{Options,StockSolutionTemplate,"The type of the new stock solution matches the type of the input sample:"},
			Download[
				UploadStockSolution[Model[Sample,StockSolution,Standard, "Bioneer Dye-free 10bp DNA Ladder, 52.2ng/uL in 0.185M NaOH"], MixTime->40*Minute],
				Type
			],
			Model[Sample,StockSolution,Standard],
			Messages:>{Warning::NewModelCreation}
		],
		Example[{Options,StockSolutionTemplate,"Provide a stock solution model from which to draw default options:"},
			UploadStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"New Version of Existing Solution of 10% v/v Methanol in Water with Different ShelfLife"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				ShelfLife->2 Year
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Options,StockSolutionTemplate,"Use preparation defaults from an existing solution for a different formula:"},
			UploadStockSolution[
				{
					{20 Milliliter,Model[Sample,"Acetonitrile, HPLC Grade"]},
					{80 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"20% ACN v/v"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"]
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Options,StockSolutionTemplate,"A template may also be provided directly as an input; this template specification will use the Formula from the template solution as the new solution's formula:"},
			{
				Download[
					UploadStockSolution[
						Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
						Name->"10% MeOH v/v"<>$SessionUUID
					],
					Formula
				],
				Download[
					Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
					Formula
				]
			},
			{
				{
					{10. Milliliter,ObjectP[Model[Sample,"Methanol"]]},
					{90. Milliliter,ObjectP[Model[Sample,"Milli-Q water"]]}
				},
				{
					{10. Milliliter,ObjectP[Model[Sample,"Methanol"]]},
					{90. Milliliter,ObjectP[Model[Sample,"Milli-Q water"]]}
				}
			}
		],
		Example[{Options,StockSolutionTemplate,"If the template is not specified but a model is provided, the Template option resolves to that model:"},
			Lookup[
				UploadStockSolution[
					Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
					Output->Options
				],
				StockSolutionTemplate
			],
			ObjectP[Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"]]
		],
		Example[{Options,StockSolutionTemplate,"Draw filtration defaults from an existing template, overriding the filter and material with new values:"},
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Name->"New Filtered Salt Water (15 g/L)"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"Filtered Dilute Salt Water"],
				Filter->True,
				FilterMaterial->PTFE
			];
			Download[{Model[Sample,StockSolution,"New Filtered Salt Water (15 g/L)"<>$SessionUUID],Model[Sample,StockSolution,"Filtered Dilute Salt Water"]},{FilterMaterial,FilterSize}],
			{
				{PTFE,0.22 Micron},
				{PES,0.22 Micron}
			}
		],
		Example[{Options,StockSolutionTemplate,"Draw incubation defaults from an existing template, overriding the incubation parameters with new values:"},
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Name->"New Filtered Salt Water (15 g/L)"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"Filtered Dilute Salt Water"],
				Incubate->True,
				IncubationTime->30 Minute,
				MixTime->30 Minute
			];
			Download[{Model[Sample,StockSolution,"New Filtered Salt Water (15 g/L)"<>$SessionUUID],Model[Sample,StockSolution,"Filtered Dilute Salt Water"]},{IncubationTime,IncubationTemperature,MixTime}],
			{
				{Quantity[30., "Minutes"], Quantity[40., "DegreesCelsius"], Quantity[30., "Minutes"]},
				{Quantity[15., "Minutes"], Quantity[40., "DegreesCelsius"], Quantity[15., "Minutes"]}
			}
		],
		Example[{Options,StockSolutionTemplate,"If BOTH the template input and option are used, and the option differs from the input, the option will be ignored in favor of the direct input:"},
			UploadStockSolution[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				Name->"New Version of 10% Methanol v/v"<>$SessionUUID,
				ShelfLife->2 Year,
				StockSolutionTemplate->Model[Sample,StockSolution,"10% ACN v/v"]
			];
			Download[{Model[Sample,StockSolution,"New Version of 10% Methanol v/v"<>$SessionUUID],Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],Model[Sample,StockSolution,"10% ACN v/v"]},MixTime],
			{15 Minute,15 Minute,1 Hour},
			EquivalenceFunction->Equal,
			Messages:>{Warning::TemplateOptionUnused}
		],
		Example[{Options,StockSolutionTemplate,"If a provided template model is deprecated, it will not be used as a source of default option values:"},
			UploadStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"New Version of 10% Methanol v/v"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"]
			];
			Download[{Model[Sample,StockSolution,"New Version of 10% Methanol v/v"<>$SessionUUID],Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"]},MixTime],
			{15. Minute,20. Minute},
			Messages:>{Warning::DeprecatedTemplate}
		],
		Example[{Options,Name,"Name the new stock solution model being created:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Name->"Special Salt in Water Mixture"<>$SessionUUID
				],
				Name
			],
			"Special Salt in Water Mixture"<>$SessionUUID
		],
		Example[{Options,Name,"If a Name is already in use in Constellation, a new stock solution cannot also get that Name:"},
			UploadStockSolution[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"Existing Solution of 10% v/v Methanol in Water"
			],
			$Failed,
			Messages:>{Error::StockSolutionNameInUse,Error::InvalidOption}
		],
		Example[{Options,FillToVolumeMethod,"Specify the method by which the fill to volume stock solution should be prepared:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Methanol"],
				1 Liter,
				FillToVolumeMethod->Volumetric
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		Example[{Options,Synonyms,"Provide synonyms by which this solution can also be found via Search or ObjectSelect. Note that the provided Name will always be duplicated as a synonym:"},
			Download[
				UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Name->"Special Salt in Water Mixture"<>$SessionUUID,
					Synonyms->{"1 M NaCL in water"<>$SessionUUID}
				],
				Synonyms
			],
			{"Special Salt in Water Mixture"<>$SessionUUID,"1 M NaCL in water"<>$SessionUUID}
		],
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent; if the resulting stock solution is resolved to mix AND incubate, MixTime and IncubationTime will be populated with the same thing:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Incubate->True,
					IncubationTemperature->37*Celsius
				],
				{IncubationTemperature,IncubationTime, MixTime}
			],
			{Quantity[37., "DegreesCelsius"], 15*Minute, 15*Minute},
			EquivalenceFunction->Equal
		],
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent; if the resulting stock solution has Mix->False but Incubate->True, IncubationTime will be populated:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Incubate->True,
					Mix->False,
					IncubationTemperature->37*Celsius
				],
				{IncubationTemperature,IncubationTime, MixTime}
			],
			{Quantity[37., "DegreesCelsius"], 60*Minute, Null},
			EquivalenceFunction->Equal
		],
		Example[{Options,Incubate,"Indicate if the stock solution should be incubated following component combination and filling to volume with solvent; if Mix->True and Incubate->True, will resolve to 30 Celsius:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Incubate->True,
					Mix->True
				],
				{IncubationTemperature,IncubationTime, MixTime}
			],
			{30*Celsius, 15*Minute, 15*Minute},
			EquivalenceFunction->Equal
		],
		Example[{Options,Incubate,"Indicate if the stock solution should NOT be incubated following component combination; the resulting stock solution model will have no incubation information:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Incubate->False
				],
				{IncubationTemperature,IncubationTime}
			],
			{Null, Null}
		],
		Example[{Options,Incubate,"Setting Incubate to False but specifying incubation parameters results in an error:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Incubate->False,
				IncubationTemperature->40*Celsius
			],
			$Failed,
			Messages:>{Error::IncubateOptionConflict,Error::InvalidOption},
			TimeConstraint->1000(*,
			ConstellationDebug->True*)
		],
		Example[{Options,IncubationTime,"Set the duration for which the stock solution should be incubated following component combination and filling to volume with solvent, while mixing:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					IncubationTime->15 Minute
				],
				IncubationTime
			],
			15. Minute
		],
		Example[{Options,IncubationTemperature,"Set the temperature at which the stock solution should be incubated following component combination, filling to volume with solvent, and mixint:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					IncubationTemperature->40Celsius
				],
				IncubationTemperature
			],
			40. Celsius
		],
		Example[{Options,Mix,"Indicate if the stock solution should be mixed following component combination and filling to volume with solvent; the resulting stock solution model will have default mixing parameters assigned:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Mix->True
				],
				{MixTime}
			],
			{15. Minute}
		],
		Example[{Options,Autoclave,"Use Autoclave option to indicate if the stock solution should be autoclaved:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Autoclave->True
				],
				Autoclave
			],
			True
		],
		Example[{Options,AutoclaveProgram,"Use AutoclaveProgram option to specify the autoclave program:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					AutoclaveProgram->Universal
				],
				AutoclaveProgram
			],
			Universal
		],
		Example[{Options,{PostAutoclaveMix,PostAutoclaveMixType,PostAutoclaveMixUntilDissolved,PostAutoclaveMixer,PostAutoclaveMixTime,PostAutoclaveMaxMixTime},"Use PostAutoclaveMix and related options to specify the autoclave program:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Autoclave -> True,
					PostAutoclaveMix -> True,
					PostAutoclaveMixType ->	Stir,
					PostAutoclaveMixUntilDissolved -> True,
					PostAutoclaveMixer ->	Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"],
					PostAutoclaveMixTime ->	15 Minute,
					PostAutoclaveMaxMixTime -> 30 Minute
				],
				{PostAutoclaveMixType,PostAutoclaveMixUntilDissolved,PostAutoclaveMixer,PostAutoclaveMixTime,PostAutoclaveMaxMixTime}
			],
			{Stir, True, ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]], 15. Minute, 30. Minute}
		],
		Example[{Options,{PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes},"Use PostAutoclaveNumberOfMixes and related options to specify the autoclave program:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Autoclave -> True,
					PostAutoclaveMixType ->	Invert,
					PostAutoclaveNumberOfMixes -> 10,
					PostAutoclaveMaxNumberOfMixes -> 30
				],
				{PostAutoclaveNumberOfMixes, PostAutoclaveMaxNumberOfMixes}
			],
			{10, 30}
		],
		Example[{Options,{PostAutoclaveIncubate, PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature},"Use PostAutoclaveIncubate and related options to specify the autoclave program:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Autoclave -> True,
					PostAutoclaveIncubate -> True,
					PostAutoclaveIncubationTime -> 10 Minute,
					PostAutoclaveIncubationTemperature -> 55 Celsius
				],
				{PostAutoclaveIncubationTime, PostAutoclaveIncubationTemperature}
			],
			{10. Minute, 55. Celsius}
		],
		Example[{Options,Composition,"Use Composition option to specify the composition:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Composition-> {{50 VolumePercent, Model[Molecule, "id:vXl9j57PmP5D"]}, {50 VolumePercent, Model[Molecule, "id:M8n3rx0676xR"]}}
				],
				Composition
			],
			{OrderlessPatternSequence[
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:vXl9j57PmP5D"]]},
				{EqualP[50 VolumePercent], LinkP[Model[Molecule, "id:M8n3rx0676xR"]]}
			]}
		],
		Example[{Options, Composition, "Calculate the composition correctly from the formula:"},
			Lookup[
				UploadStockSolution[
					{
						{0.79 Gram, Model[Sample, "id:n0k9mGzRa6o4"](*"Sodium Phosphate Monobasic Monohydrate"*)},
						{7.88 Gram, Model[Sample, "id:qdkmxzqrzYLx"](*"Sodium Phosphate Dibasic Dihydrate"*)},
						{800 Milliliter, Model[Sample, "id:8qZ1VWNmdLBD"](*"Milli-Q water"*)}
					},
					Model[Sample, "id:8qZ1VWNmdLBD"](*"Milli-Q water"*),
					1 Liter,
					Upload -> False,
					Output -> Options
				],
				Composition
			],
			{OrderlessPatternSequence[
				{GreaterP[99 VolumePercent], ObjectP[Model[Molecule, "id:vXl9j57PmP5D"]]},
				{RangeP[43 Millimolar, 44 Millimolar], ObjectP[Model[Molecule, "id:54n6evLRv8n7"]]},
				{RangeP[5.5 Millimolar, 6 Millimolar], ObjectP[Model[Molecule, "id:D8KAEvGwmAbL"]]}
			]}
		],
		(* TODO this does not work. Not sure if we even need this option - it is not getting uploaded in a field *)
		(*Example[{Options,FulfillmentScale,"FulfillmentScale is defaulted to Dynamic:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					FulfillmentScale->Fixed,
					VolumeIncrements->{1*Liter, 0.5*Liter}
				],
				VolumeIncrements
			],
			{1*Liter, 0.5*Liter}
		],*)
		Example[{Options, OrderOfOperations, "Indicate the order in which the stock solution should be prepared:"},
			Download[
				UploadStockSolution[
					{
						{300 Milliliter,Model[Sample,"Methanol"]},
						{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
					},
					Model[Sample,"Milli-Q water"],
					1000 Milliliter,
					Incubate->True,
					NominalpH->7,
					OrderOfOperations->{FixedReagentAddition, pHTitration, FillToVolume, Incubation}
				],
				OrderOfOperations
			],
			{FixedReagentAddition, pHTitration, FillToVolume, Incubation}
		],
		Example[{Options,Mix,"Indicate if the stock solution should NOT be mixed following component combination; the resulting stock solution model will have no mixing information:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Mix->False
				],
				{MixUntilDissolved,MixTime,MaxMixTime}
			],
			{Null,Null,Null}
		],
		Example[{Options,Mix,"Setting Mix to False but specifying mixing parameters results in an error:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Mix->False,
				MixTime->5 Minute
			],
			$Failed,
			Messages:>{Error::MixOptionConflict,Error::InvalidOption}
		],
		Example[{Options,MixUntilDissolved,"Indicate if the stocksolution should be mixed in an attempt to completed dissolve any solid components following component combination and filling to volume with solvent:"},
			Download[
				UploadStockSolution[
					{
						{250 Milliliter,Model[Sample,"Milli-Q water"]},
						{250 Milliliter,Model[Sample,"Methanol"]}
					},
					MixUntilDissolved->True
				],
				MixUntilDissolved
			],
			True
		],
		Example[{Options,MixTime,"Set the duration for which the stock solution should be mixed following component combination and filling to volume with solvent:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					MixTime->15 Minute
				],
				MixTime
			],
			15. Minute
		],
		Example[{Options,MaxMixTime,"Set a maximum duration for which the stock solution should be mixed in an attempt to dissolve any solid components following component combination and filling to volume with solvent:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					MixUntilDissolved->True,
					MixTime->15 Minute,
					MaxMixTime->30 Minute
				],
				{MixUntilDissolved,MixTime,MaxMixTime}
			],
			{True,15. Minute,30. Minute}
		],
		Example[{Options,MaxMixTime,"An upper bound on mixing time should only be provided if mixing until dissolution with MixTime specified:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				MixUntilDissolved->False,
				MixTime->15 Minute,
				MaxMixTime->30 Minute
			],
			$Failed,
			Messages:>{Error::MixUntilDissolvedMaxOptions,Error::InvalidOption}
		],
		Example[{Options,MaxMixTime,"This maximum will resolve automatically if a mix time to start with is provided:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					MixUntilDissolved->True,
					MixTime->15 Minute
				],
				MaxMixTime
			],
			300. Minute
		],
		Example[{Options,MixType,"Specify the type of mixing by which you want this stock solution to be mixed:"},
			Download[
				UploadStockSolution[
					{
						{250 Milliliter,Model[Sample,"Milli-Q water"]},
						{250 Milliliter,Model[Sample,"Methanol"]}
					},
					MixUntilDissolved->True,
					MixTime->15 Minute,
					MixType->Stir
				],
				MixType
			],
			Stir
		],
		Example[{Options,MixRate,"Specify the rate of mixing by which you want this stock solution to be mixed.  In order to specify this, MixType must also be specified:"},
			Download[
				UploadStockSolution[
					{
						{250 Milliliter,Model[Sample,"Milli-Q water"]},
						{250 Milliliter,Model[Sample,"Methanol"]}
					},
					MixType->Stir,
					MixRate->100*RPM
				],
				MixRate
			],
			100*RPM,
			EquivalenceFunction->Equal
		],
		Example[{Options,Mixer,"Specify the model of mixer with which you want this stock solution to be mixed.  In order to specify this, MixType must also be specified:"},
			Download[
				UploadStockSolution[
					{
						{50 Milliliter,Model[Sample,"Milli-Q water"]},
						{50 Milliliter,Model[Sample,"Methanol"]}
					},
					MixType->Stir,
					Mixer->Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]
				],
				Mixer
			],
			ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]]
		],
		Example[{Options,NumberOfMixes,"Specify the number of mixes. If specified, MixType must be Invert or Pipette:"},
			Download[
				UploadStockSolution[
					{
						{20 Milliliter,Model[Sample,"Milli-Q water"]},
						{20 Milliliter,Model[Sample,"Methanol"]}
					},
					MixType->Invert,
					NumberOfMixes->15
				],
				NumberOfMixes
			],
			15,
			EquivalenceFunction->Equal
		],
		Example[{Options,MaxNumberOfMixes,"Specify the max number of mixes. If specified, MixType must be Invert or Pipette and MixUntilDissolved must be True:"},
			Download[
				UploadStockSolution[
					{
						{20 Milliliter,Model[Sample,"Milli-Q water"]},
						{20 Milliliter,Model[Sample,"Methanol"]}
					},
					MixType->Invert,
					MaxNumberOfMixes->15
				],
				MaxNumberOfMixes
			],
			15,
			EquivalenceFunction->Equal
		],
		Test["If a template is provided and the MixType/MixRate/Mixer options are specified, populate those fields properly in the new model:",
			Download[
				UploadStockSolution[
					Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
					MixType->Stir,
					MixRate->100*RPM,
					Mixer->Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]
				],
				{MixType, MixRate, Mixer}
			],
			{Stir, RangeP[100*RPM, 100*RPM], ObjectP[Model[Instrument, OverheadStirrer, "MINISTAR 40 with C-MAG HS 10 Hot Plate"]]},
			Messages:>{Warning::NewModelCreation}
		],
		(* pH Titration *)
		Example[{Options, AdjustpH, "Specify whether to adjust the pH following component combination and mixing; if AdjustpH->True and NominalpH is not specified, it is automatically set to 7:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					AdjustpH->True
				],
				NominalpH
			],
			7.
		],
		Example[{Options,NominalpH,"Specify the pH to which this solution should be adjusted following component combination and mixing:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7
				],
				NominalpH
			],
			7.
		],
		Example[{Options,NominalpH,"If MinpH and MaxpH are specified, choose the mean between them to resolve NominalpH:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					MinpH->7,
					MaxpH->9
				],
				NominalpH
			],
			EqualP[8]
		],
		Test["If NominalpH, MinpH, and MaxpH are all specified, don't change any of the values:",
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7,
					MinpH->6.5,
					MaxpH->7.9
				],
				{MinpH, MaxpH}
			],
			{6.5, 7.9}
		],
		Example[{Options,NominalpH,"If pH titration is requested, the preparation volume of the provided stock solution formula must exceed the minimum threshold to ensure the smallest pH probe can fit in any container in which this formula can be combined:"},
			UploadStockSolution[
				{
					{4 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				10 Milliliter,
				NominalpH->7
			],
			$Failed,
			Messages:>{Error::VolumeBelowpHMinimum,Error::InvalidOption}
		],
		Example[{Options,NominalpH,"The MinpH, MaxpH, pHingAcid and pHingBase can be automatically resolved if a NominalpH is set:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->10
				],
				{NominalpH,MinpH,MaxpH,pHingAcid[Name],pHingBase[Name]}
			],
			{10.,9.9,10.1,"2 M HCl","1.85 M NaOH"}
		],
		Example[{Options,NominalpH,"The NominalpH, MinpH, and MaxpH options should be in appropriate numerical order:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->7,
				MinpH->7.1,
				MaxpH->6.9
			],
			$Failed,
			Messages:>{Error::pHOrderInvalidUSS,Error::InvalidOption}
		],
		Example[{Options,MinpH,"Specify the minimum pH this solution should be allowed to have following component combination and mixing:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7,
					MinpH->6.5
				],
				MinpH
			],
			6.5
		],
		Example[{Options,MinpH,"MinpH will automatically resolve to 0.1 below the NominalpH if that option is specified:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7
				],
				MinpH
			],
			6.9
		],
		Example[{Options,MinpH,"MinpH cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MinpH->6.5,
				AdjustpH->False
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Example[{Options,MaxpH,"Specify the maximum pH this solution should be allowed to have following component combination and mixing:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7,
					MaxpH->7.5
				],
				MaxpH
			],
			7.5
		],
		Example[{Options,MaxpH,"MaxpH will automatically resolve to 0.1 above the NominalpH if that option is specified:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7
				],
				MaxpH
			],
			7.1
		],
		Example[{Options,MaxpH,"MaxpH cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MaxpH->7.5,
				AdjustpH->False
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Example[{Options,pHingAcid,"Specify the solution that should be used to adjust the pH of this solution downwards following component combination and mixing:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7,
					pHingAcid->Model[Sample,StockSolution,"10% Nitric Acid Solution"]
				],
				pHingAcid[Name]
			],
			"10% Nitric Acid Solution"
		],
		Example[{Options,pHingAcid,"The pHingAcid will automatically resolve to 2 M HCl if a NominalpH is specified:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7
				],
				pHingAcid[Name]
			],
			"2 M HCl"
		],
		Example[{Options,pHingAcid,"A pHingAcid cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Mix->False,
				AdjustpH->False,
				pHingAcid->Model[Sample,StockSolution,"6N hydrochloric acid"]
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Example[{Options,pHingBase,"Specify the solution that should be used to adjust the pH of this solution upwards following component combination and mixing:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7,
					pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"]
				],
				pHingBase[Name]
			],
			"0.1 M NaOH"
		],
		Example[{Options,pHingBase,"The pHingBase will automatically resolve to 1.85 M NaOH if a NominalpH is specified:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->7
				],
				pHingBase[Name]
			],
			"1.85 M NaOH"
		],
		Example[{Options,pHingBase,"A pHingBase cannot be specified if AdjustpH is set to False:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->False,
				pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"]
			],
			$Failed,
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],

		Example[{Options,MaxNumberOfpHingCycles,"Returns specified MaxNumberOfpHingCycles:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->True,
				NominalpH->8.0,
				MaxNumberOfpHingCycles->15
			][MaxNumberOfpHingCycles],

			15,

			EquivalenceFunction->Equal
		],
		Example[{Options,MaxpHingAdditionVolume,"Returns specified MaxpHingAdditionVolume:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->True,
				NominalpH->8.0,
				MaxpHingAdditionVolume->10Milliliter
			][MaxpHingAdditionVolume],

			10Milliliter,

			EquivalenceFunction->Equal
		],
		Example[{Options,MaxAcidAmountPerCycle,"Returns specified MaxAcidAmountPerCycle:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->True,
				NominalpH->8.0,
				MaxAcidAmountPerCycle->2Milliliter
			][MaxAcidAmountPerCycle],

			2Milliliter,

			EquivalenceFunction->Equal
		],
		Example[{Options,MaxBaseAmountPerCycle,"Returns specified MaxBaseAmountPerCycle:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->True,
				NominalpH->8.0,
				MaxBaseAmountPerCycle->3Milliliter
			][MaxBaseAmountPerCycle],

			3Milliliter,

			EquivalenceFunction->Equal
		],


		(* PreferredContainers and storage *)
		Example[{Options,PreferredContainers,"Specify the containers you'd like the sample to be stored and prepared in, whenever possible:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					10 Milliliter,
					PreferredContainers->{Model[Container, Vessel, "id:9RdZXvKBeeqL"],Model[Container, Vessel, "id:M8n3rxYE55b5"],Model[Container, Vessel, "id:n0k9mGzRaa3r"]}
				],
				PreferredContainers[Object]
			],
			{Model[Container, Vessel, "id:9RdZXvKBeeqL"],Model[Container, Vessel, "id:M8n3rxYE55b5"],Model[Container, Vessel, "id:n0k9mGzRaa3r"]}
		],
		Example[{Options,VolumeIncrements,"Specify the volumes at which a given stock solution might be prepared:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					10 Milliliter,
					VolumeIncrements->{10*Milliliter, 15*Milliliter}
				],
				VolumeIncrements
			],
			{10*Milliliter, 15*Milliliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,VolumeIncrements,"Single VolumeIncrements are allowed:"},
			Download[
				UploadStockSolution[
					{
						{1.32 Gram,Model[Sample,"Potassium Chloride"]},
						{2.41 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					15 Milliliter,
					VolumeIncrements ->  20*Milliliter,
					Name -> "KCl + KPO " <> $SessionUUID
				],
				VolumeIncrements
			],
			{20*Milliliter},
			EquivalenceFunction -> Equal
		],
		Example[{Options,Preparable,"Specify whether a stock solution might be preparable in ExperimentStockSolution:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					10 Milliliter,
					Preparable->False
				],
				Preparable
			],
			False
		],
		Example[{Options,Preparable,"If Preparable->False, skip error checking that is only relevant to preparation in ExperimentStockSolution:"},
			UploadStockSolution[
				{
					{2 Nanogram,Model[Sample,"Potassium Chloride"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				10 Milliliter,
				Preparable->False
			],
			ObjectP[Model[Sample,StockSolution]]
		],
		(* Filtration *)
		Example[{Options,Filter,"Indicate if the stock solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration; the resulting stock solution model will have default filtration parameters assigned:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Filter->True
				],
				{FilterMaterial,FilterSize}
			],
			{FilterMembraneMaterialP, FilterSizeP}
		],
		Example[{Options,Filter,"Indicate if the stock solution should NOT be filtered following component combination, filling to volume with solvent, mixing, and/or pH adjustment; the resulting stock solution model will not have any filtration parameters populated:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{500 Milliliter,Model[Sample,"Methanol"]}
					},
					Filter->False
				],
				{FilterMaterial,FilterSize}
			],
			{Null,Null}
		],
		Example[{Options,Filter,"The total preparation volume of the stock solution must exceed a minimum threshold for filtration to ensure that a method with low enough dead volume is available:"},
			UploadStockSolution[
				{
					{2 Milligram,Model[Sample,"Sodium Chloride"]},
					{1.5 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Filter->True
			],
			$Failed,
			Messages:>{Error::VolumeBelowFiltrationMinimum,Error::InvalidOption}
		],
		Example[{Options,Filter,"This boolean option must be set to True in order to set specific filtration parameters:"},
			UploadStockSolution[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				FilterMaterial->Cellulose
			],
			$Failed,
			Messages:>{Error::FilterOptionConflictUSS,Error::InvalidOption}
		],
		Example[{Options,FilterMaterial,"Specify a filter material through which this solution should be filtered following component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Filter->True,
					FilterMaterial->PES
				],
				FilterMaterial
			],
			PES
		],
		Example[{Options,FilterSize,"Specify the size of the pores through which this solution should be filtered after component combination, filling to volume with solvent, mixing, and/or pH titration:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Filter->True,
					FilterSize->0.22 Micron
				],
				FilterSize
			],
			0.22 Micron
		],
		Example[{Options,LightSensitive,"Indicate if a solution is sensitive to light exposure and should be stored in light-blocking containers when possible:"},
			Download[
				UploadStockSolution[
					{
						{200 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					500 Milliliter,
					LightSensitive->True
				],
				LightSensitive
			],
			True
		],
		Example[{Options,LightSensitive,"This option automatically resolves to True if any components in the provided formula are themselves marked as LightSensitive:"},
			Download[
				UploadStockSolution[
					{
						{1.2 Gram,Model[Sample,"L-Arginine Hydrochloride,U.S.P.,Multi-Compendial"]}
					},
					Model[Sample,"Milli-Q water"],
					50 Milliliter
				],
				LightSensitive
			],
			True
		],
		Example[{Options,Expires,"Indicate if stock solution samples of this model expire after a given amount of time (specifiable via the ShelfLife option). Expired samples may be subjected to automated disposal:"},
			Download[
				UploadStockSolution[
					{
						{1.2 Gram,Model[Sample,"L-Arginine Hydrochloride,U.S.P.,Multi-Compendial"]}
					},
					Model[Sample,"Milli-Q water"],
					50 Milliliter,
					Expires->True,
					ShelfLife->30 Day
				],
				{Expires,ShelfLife}
			],
			{True,30. Day}
		],
		Example[{Options,Expires,"If the stock solution is stable and should never be automatically disposed, set Expires to False:"},
			Download[
				UploadStockSolution[
					{
						{1.67 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Expires->False
				],
				{Expires,ShelfLife}
			],
			{False,Null}
		],
		Example[{Options,Expires,"If Expires is set to False, ShelfLife/UnsealedShelfLife cannot also be set:"},
			UploadStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year
			],
			$Failed,
			Messages:>{Error::ExpirationShelfLifeConflict,Error::InvalidOption}
		],
		Example[{Options,ShelfLife,"Specify the length of time after preparation (but without being used) that samples of this stock solution are recommended for use before they should be discarded:"},
			Download[
				UploadStockSolution[
					{
						{1.96 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					ShelfLife->90 Day
				],
				ShelfLife
			],
			90. Day
		],
		Example[{Options,ShelfLife,"Automatically resolves to 5 years if Expires is set to True and no formula components have shelf lives:"},
			Download[
				UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					(* RO Water does not have ShelfLife *)
					Model[Sample, "RO Water"],
					1 Liter,
					Expires->True,
					(* Give a special name so we don't try to find an existing stock solution model *)
					Name->"Special Salt in Water Mixture"<>$SessionUUID<>CreateUUID[]
				],
				ShelfLife
			],
			5 Year,
			EquivalenceFunction->Equal
		],
		Example[{Options,ShelfLife,"Automatically resolves to the shortest of the shelf lives of any formula components:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					Expires->True
				],
				ShelfLife
			],
			1 Year,
			EquivalenceFunction->Equal
		],
		Example[{Options,UnsealedShelfLife,"Specify the length of time after first use that samples of this stock solution are recommended for use before they should be discarded:"},
			Download[
				UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					UnsealedShelfLife->1 Year,
					ShelfLife->5 Year
				],
				UnsealedShelfLife
			],
			1 Year,
			EquivalenceFunction->Equal
		],
		Example[{Options,UnsealedShelfLife,"Automatically resolves to match ShelfLife if Expires is set to True and no formula components have unsealed shelf lives:"},
			Module[
				{stockSolutionModel},
				stockSolutionModel=UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Dichloromethane, Reagent Grade"],
					1 Liter,
					Expires->True
				];
				EqualQ[Download[stockSolutionModel,ShelfLife],Download[stockSolutionModel,UnsealedShelfLife]]
			],
			True
		],
		Example[{Options,UnsealedShelfLife,"Automatically resolves to the shortest of the unsealed shelf lives of any formula components:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					Expires->True
				],
				UnsealedShelfLife
			],
			1 Day,
			EquivalenceFunction->Equal
		],
		Example[{Options,UnsealedShelfLife,"A warning is provided if the provided UnsealedShelfLife is longer than the provided ShelfLife:"},
			UploadStockSolution[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				ShelfLife->1 Year,
				UnsealedShelfLife->2 Year
			],
			ObjectP[Model[Sample,StockSolution]],
			Messages:>{Warning::UnsealedShelfLifeLonger}
		],
		Example[{Options,DiscardThreshold,"Specify the percentage of the prepared stock solution volume below which the sample will be automatically marked as AwaitingDisposal:"},
			Download[
				UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DiscardThreshold -> 4 Percent
				],
				DiscardThreshold
			],
			EqualP[4 Percent]
		],
		Example[{Options,DefaultStorageCondition,"Indicate the temperature conditions in which samples of this stock solution should be stored. This default condition can be overridden for specific samples using the function StoreSamples:"},
			Download[
				UploadStockSolution[
					{
						{8 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					DefaultStorageCondition->Refrigerator,
					Name->"Refrigerated Salt Water (example)"<>$SessionUUID
				],
				DefaultStorageCondition[StorageCondition]
			],
			Refrigerator
		],
		Example[{Options,DefaultStorageCondition,"Automatically resolves based on the lowest required temperature of any formula components:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter
				],
				DefaultStorageCondition[StorageCondition]
			],
			AmbientStorage
		],
		Example[{Options, UltrasonicIncompatible, "Automatically resolves to True if 50% or more of the volume consists of UltrasonicIncompatible chemicals:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{501 Milliliter,Model[Sample,"Methanol"]}
					}
				],
				UltrasonicIncompatible
			],
			True
		],
		Example[{Options, UltrasonicIncompatible, "Override automatic resolution if specifying UltrasonicIncompatible manually:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{501 Milliliter,Model[Sample,"Methanol"]}
					},
					UltrasonicIncompatible->False
				],
				UltrasonicIncompatible
			],
			Null
		],
		Example[{Options,UltrasonicIncompatible,"Automatically resolves to True if 50% or more of the volume consists of UltrasonicIncompatible chemicals (including the solvent in FillToVolume solutions):"},
			Download[
				UploadStockSolution[
					{
						{20*Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Model[Sample,"Methanol"],
					50 Milliliter
				],
				UltrasonicIncompatible
			],
			True
		],
		Example[{Options, UltrasonicIncompatible, "Pass the UltrasonicIncompatible option down from the provided template:"},
			Download[
				UploadStockSolution[
					Model[Sample,StockSolution,"Old and Boring 90% Methanol"<>$SessionUUID],
					Name->"New and exciting 90% methanol solution"<>$SessionUUID
				],
				UltrasonicIncompatible
			],
			True
,
			SetUp:>{
				UploadStockSolution[{{Quantity[0.9`, "Liters"],	Model[Sample,"id:vXl9j5qEnnRD"]}, {Quantity[0.1`, "Liters"],Model[Sample,"id:8qZ1VWNmdLBD"]}}, Name->"Old and Boring 90% Methanol"<>$SessionUUID]
			}
		],
		Example[{Options, CentrifugeIncompatible, "Specify that a stock solution model is centrifuge incompatible:"},
			Download[
				UploadStockSolution[
					{
						{500 Milliliter,Model[Sample,"Milli-Q water"]},
						{501 Milliliter,Model[Sample,"Methanol"]}
					},
					CentrifugeIncompatible->True
				],
				CentrifugeIncompatible
			],
			True
		],
		Example[{Options,TransportTemperature,"Indicate at what temperature samples of this stock solution should be refrigerated during transport when used in experiments:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					TransportTemperature->4 Celsius
				],
				TransportTemperature
			],
			EqualP[4 Celsius]
		],
		Example[{Options,TransportTemperature,"Indicate at what temperature samples of this stock solution should be refrigerated during transport when used in experiments:"},
			Download[
				UploadStockSolution[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					TransportTemperature->50*Celsius
				],
				TransportTemperature
			],
			EqualP[50 Celsius]
		],
		Example[{Options,Density,"If known explicitly, specify the density that should be associated with this mixture. This will allow samples of this stock solution model to have their volumes measured via the gravimetric method:"},
			Download[
				UploadStockSolution[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Density->(1.069 Gram/Milliliter),
					Name->"1M NaCl Solution (example, density populated)"<>$SessionUUID
				],
				Density
			],
			(1.069 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Example[{Options,ExtinctionCoefficients,"Indicate how strongly this chemical absorbs light at a given wavelength:"},
			Download[
				UploadStockSolution[
					{
						{10 Milliliter,Model[Sample,"Milli-Q water"]},
						{10 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					ExtinctionCoefficients->{
						{260*Nanometer, 100*Liter/(Centimeter*Mole)},
						{330*Nanometer, 10000*Liter/(Centimeter*Mole)}
					}
				],
				ExtinctionCoefficients
			],
			{
				<|Wavelength->UnitsP[Nanometer], ExtinctionCoefficient->UnitsP[Liter/(Centimeter*Mole)]|>,
				<|Wavelength->UnitsP[Nanometer], ExtinctionCoefficient->UnitsP[Liter/(Centimeter*Mole)]|>
			}
		],
		Example[{Options,Ventilated,"Indicate if samples of this stock solution should be handled in a ventilated enclosure:"},
			Download[
				UploadStockSolution[
					{
						{10 Milliliter,Model[Sample,"Milli-Q water"]},
						{10 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					Ventilated->True
				],
				Ventilated
			],
			True
		],
		Example[{Options,Flammable,"Indicates if samples of this stock solution are easily set aflame under standard conditions:"},
			Download[
				UploadStockSolution[
					{
						{950 Milliliter,Model[Sample,"Absolute Ethanol, Anhydrous"]},
						{50 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Flammable->True
				],
				Flammable
			],
			True
		],
		Example[{Options,Acid,"Indicates if this stock solution is a strong acid (pH <= 2) and samples of this stock solution model require dedicated secondary containment during storage:"},
			Download[
				UploadStockSolution[
					{
						{5 Milliliter,Model[Sample,"Milli-Q water"]},
						{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
					},
					Acid->True
				],
				Acid
			],
			True
		],
		Example[{Options,Acid,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			UploadStockSolution[
				{
					{5 Milliliter,Model[Sample,"Milli-Q water"]},
					{20 Milliliter,Model[Sample,"Trifluoroacetic acid"]}
				},
				Acid->True,
				Base->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::StorageCombinationUnsupported,Error::InvalidOption}
		],
		Example[{Options,Base,"Indicates if this stock solution is a strong base (pH >= 12) and samples of this stock solution model require dedicated secondary containment during storage:"},
			Download[
				UploadStockSolution[
					{
						{80 Gram,Model[Sample,"Sodium Hydroxide"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Base->True
				],
				Base
			],
			True
		],
		Example[{Options,Base,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			UploadStockSolution[
				{
					{80 Gram,Model[Sample,"Sodium Hydroxide"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Base->True,
				Acid->True
			],
			$Failed,
			Messages:>{Error::AcidBaseConflict,Error::StorageCombinationUnsupported,Error::InvalidOption}
		],
		Example[{Options,Fuming,"Indicates if samples of this stock solution emit fumes spontaneously when exposed to air:"},
			Download[
				UploadStockSolution[
					{
						{4 Milliliter,Model[Sample,"Trifluoroacetic acid"]},
						{4 Milliliter,Model[Sample,"Trifluoromethanesulfonic acid"]}
					},
					Fuming->True
				],
				Fuming
			],
			True
		],
		Example[{Options,IncompatibleMaterials,"Provide a list of materials which may be damaged when wetted by this stock solution:"},
			Download[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					IncompatibleMaterials->{CastIron,CarbonSteel},
					Name->"Salt Water with IncompatibleMaterials listing"<>$SessionUUID
				],
				IncompatibleMaterials
			],
			{CastIron,CarbonSteel}
		],
		Test["Return options:",
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Output->Options
			],
			{__Rule}
		],
		Test["Return tests:",
			MatchQ[
				UploadStockSolution[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Filter->True,
					Mix->True,
					Output->Tests
				],
				{TestP..}
			],
			True
		],
		Test["Return tests even if options don't match their patterns:",
			MatchQ[
				UploadStockSolution[
					{
						{2,Model[Sample,"Acetaminophen (tablet)"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->6 Milliliter,
					Output->Tests
				],
				{TestP..}
			],
			True
		],
		Test["Return a template model with Upload->False when the template is not mixed at all (and thus MixUntilDissolved Null field should be matched against Null resolved option):",
			UploadStockSolution[Model[Sample,StockSolution,"Unmixed Salt Solution (example)"], Upload->False],
			ObjectP[Model[Sample,StockSolution,"Unmixed Salt Solution (example)"]],
			(* This one needs to be $DeveloperSearch = True so it can find the existing solution and its existing alterantive solution *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			}
		],
		Test["If using a stock solution with MixUntilDissolved->True as the template, pass that along properly:",
			UploadStockSolution[Model[Sample,StockSolution,"Concentrated Saline mix until dissolved (example)"], Upload->False],
			ObjectP[Model[Sample,StockSolution,"Concentrated Saline mix until dissolved (example)"]],
			(* This one needs to be $DeveloperSearch = True so it can find the existing solution and its existing alterantive solution *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			}
		],
		Test["If Autoclave is set to or default to True, the resulted Model[Sample, StockSolution] is automatically populated with Sterile and AsepticHandling as True:",
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter,
				Autoclave -> True,
				Name -> "NaCl in Waster Autoclaved for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "NaCl in Waster Autoclaved for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		],
		Test["If filtering with size at or below 0.22 Micrometer, the resulted Model[Sample, StockSolution] is automatically populated with Sterile and AsepticHandling as True:",
			UploadStockSolution[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample, "Milli-Q water"],
				1 Liter,
				Autoclave -> False,
				Filter -> True,
				FilterSize -> 0.22 Micrometer,
				Name -> "NaCl in Waster Filtered for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "NaCl in Waster Filtered for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		],
		Test["Using the formula with solvent overload, if all components have Sterile -> True, the resulted Model[Sample, StockSolution] is automatically populated with Sterile and AsepticHandling as True:",
			UploadStockSolution[
				{
					{50 Milliliter,Model[Sample, StockSolution,"id:xRO9n3ExxAPx"]}(*"2 mg/mL Ampicillin in Water, Filtered"*)
				},
				Model[Sample, Media, "id:jLq9jXqbAn9E"],(*"LB (Liquid)"*)
				1 Liter,
				Autoclave -> False,
				Filter -> False,
				Name -> "Filtered ampicillin stock in autoclaved LB broth 1 for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "Filtered ampicillin stock in autoclaved LB broth 1 for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		],
		Test["Using the plain formula overload, if all components have Sterile -> True, the resulted Model[Sample, StockSolution] is automatically populated with Sterile and AsepticHandling as True:",
			UploadStockSolution[
				{
					{50 Milliliter,Model[Sample, StockSolution,"id:xRO9n3ExxAPx"]}(*"2 mg/mL Ampicillin in Water, Filtered"*),
					{950 Milliliter,Model[Sample, Media, "id:jLq9jXqbAn9E"]}(*"LB (Liquid)"*)
				},
				Autoclave -> False,
				Filter -> False,
				Name -> "Filtered ampicillin stock in autoclaved LB broth 2 for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "Filtered ampicillin stock in autoclaved LB broth 2 for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		],
		Test["Using the template model overload, if the template model is sterile but Autoclave and Filter are turned off, the resulted Model[Sample, StockSolution] does not get populated with Sterile and AsepticHandling as True:",
			UploadStockSolution[
				Model[Sample, StockSolution,"id:xRO9n3ExxAPx"],(*"2 mg/mL Ampicillin in Water, Filtered"*)
				Autoclave -> False,
				Filter -> False,
				FilterMaterial -> Null,
				FilterSize -> Null,
				Name -> "Unfiltered ampicillin stock for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "Unfiltered ampicillin stock for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{Null, Null}
		],
		Test["Using the unit operation overload, if all components have Sterile -> True, the resulted Model[Sample, StockSolution] is automatically populated with Sterile as True, AsepticHandling as True because individual UnitOperation takes care of potential aseptic handling needs:",
			UploadStockSolution[
				{
					LabelContainer[
						Label->"test tube",
						Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"](*50mL tube*)
					],
					Transfer[
						Source->Model[Sample, StockSolution,"id:xRO9n3ExxAPx"],(*"2 mg/mL Ampicillin in Water, Filtered"*)
						Destination->"test tube",
						Amount-> 1 Milliliter,
						MeasureVolume -> False, ImageSample -> False, MeasureWeight -> False
					],
					Transfer[
						Source->Model[Sample, Media, "id:jLq9jXqbAn9E"](*"LB (Liquid)"*),
						Destination->"test tube",
						Amount->39 Milliliter,
						MeasureVolume -> False, ImageSample -> False, MeasureWeight -> False
					]
				},
				Name -> "Filtered ampicillin stock in autoclaved LB broth 3 for UploadStockSolution test of Sterile field" <> $SessionUUID
			];
			Download[
				Model[Sample, StockSolution, "Filtered ampicillin stock in autoclaved LB broth 3 for UploadStockSolution test of Sterile field" <> $SessionUUID],
				{Sterile, AsepticHandling}
			],
			{True, True}
		]
	},
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]] = Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	},
	SymbolSetUp :> (
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objs, existingObjs, fakeBench},
			objs = {
				Model[Sample, StockSolution, "UploadStockSolutionModel Test Model (No Solvent) " <> $SessionUUID],
				Object[Container,Vessel,"Test container for sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Container,Bench,"Fake bench for UploadStockSolution tests"<>$SessionUUID],
				Object[Sample,"Test sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True];

			fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for UploadStockSolution tests"<>$SessionUUID,DeveloperObject->True|>];
			Module[{ss1},
				ss1 = UploadStockSolution[{{Quantity[2.`, "Liters"], Model[Sample, "Glycerol"]}}, Name -> "UploadStockSolutionModel Test Model (No Solvent) " <> $SessionUUID];
				Upload[<|Object -> #, DeveloperObject -> True|>& /@ Flatten[{ss1}]]
			];
			UploadSample[
				Model[Container,Vessel, "50mL Tube"],
				{"Work Surface",Object[Container,Bench,"Fake bench for UploadStockSolution tests"<>$SessionUUID]},
				Name->"Test container for sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
			UploadSample[
				Model[Sample,"Methanol - LCMS grade"],
				{"A1",Object[Container,Vessel,"Test container for sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID]},
				Name->"Test sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
			(* Wipe out the model for the Object[Sample] with missing model *)
			Upload[<|Object->Object[Sample,"Test sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],Model->Null|>]
		];
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		Module[{objs, existingObjs},
			objs = {
				Model[Sample, StockSolution, "UploadStockSolutionModel Test Model (No Solvent) " <> $SessionUUID],
				Object[Container,Vessel,"Test container for sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Container,Bench,"Fake bench for UploadStockSolution tests"<>$SessionUUID],
				Object[Sample,"Test sample for UploadStockSolution (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};
			existingObjects = PickList[objects, DatabaseMemberQ[objects]];
			EraseObject[existingObjects, Force->True]
		]
	),
	SetUp :> (
		$CreatedObjects = {};
	),
	TearDown :> (
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force->True, Verbose->False];
		Unset[$CreatedObjects]
	)
];


(* ::Subsubsection::Closed:: *)
(*UploadStockSolutionOptions*)


DefineTests[UploadStockSolutionOptions,
	{
		Example[{Basic,"Return options for creating a model for a salt solution filled to a total volume of 1L with deionized water:"},
			UploadStockSolutionOptions[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			_Grid
		],
		Example[{Basic,"Return options for creating a model for a 50% (v/v) methanol/water solution:"},
			UploadStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			_Grid
		],
		Example[{Basic,"Return options for creating a model for a solution of multiple solid components with a total volume of 1L:"},
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			_Grid
		],
		Example[{Basic,"Create a model for a solution with a component that does not have a model information"},
			UploadStockSolutionOptions[
				{
					{1 Gram,Model[Sample,"Sodium Chloride"]},
					{5 Milliliter, Object[Sample,"Test sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID]}
				},
				Model[Sample,"Milli-Q water"],
				50 Milliliter
			],
			_Grid
		],
		Example[{Additional,"Return options for creating a model for a solution in which a solid component is a tablet:"},
			UploadStockSolutionOptions[
				{
					{2,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			_Grid
		],
		Example[{Additional,"Return resolved options with a template model provided:"},
			UploadStockSolutionOptions[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				Name->"New 10% MeOH v/v"<>$SessionUUID
			],
			_Grid
		],
		Example[{Additional,"If a provided option does not match its pattern, no resolved options will be returned:"},
			UploadStockSolutionOptions[
				{
					{2,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->6 Milliliter
			],
			$Failed,
			Messages:>{Error::Pattern}
		],
		Test["Return resolved options even if the NominalpH, MinpH, and MaxpH options are not in appropriate numerical order:",
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->7,
				MinpH->7.1,
				MaxpH->6.9,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::pHOrderInvalidUSS,Error::InvalidOption}
		],
		Test["Return resolved options even if a provided template is deprecated:",
			UploadStockSolutionOptions[
				Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"],
				Name->"New Version of 20% Methanol v/v"<>$SessionUUID,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::DeprecatedTemplate,Error::InvalidInput}
		],
		Test["Return options even if tablet amount is wrong:",
			UploadStockSolutionOptions[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::ComponentRequiresTabletCount,Error::InvalidInput}
		],
		Example[{Options,StockSolutionTemplate,"Return resolved options when a template model is used via the Template option:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{10 Milliliter,Model[Sample,"Methanol"]},
						{90 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Name->"New Version of Existing Solution of 10% v/v Methanol in Water with Different ShelfLife"<>$SessionUUID,
					StockSolutionTemplate->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
					ShelfLife->2 Year,
					OutputFormat->List
				],
				{StockSolutionTemplate, Name, ShelfLife}
			],
			{ObjectP[Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"]], "New Version of Existing Solution of 10% v/v Methanol in Water with Different ShelfLife"<>$SessionUUID, RangeP[2*Year, 2*Year]}
		],
		Example[{Options,StockSolutionTemplate,"Return resolved options when a template model is used via the Template option, with additional options added in:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{10 Milliliter,Model[Sample,"Methanol"]},
						{90 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Name->"New Version of Existing Solution of 10% v/v Methanol in Water with Different ShelfLife"<>$SessionUUID,
					StockSolutionTemplate->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
					NominalpH->7,
					OutputFormat->List
				],
				{MixTime, NominalpH}
			],
			{EqualP[15*Minute], EqualP[7]}
		],
		Test["Return options list for creating a model for a solution of multiple solid components with a total volume of 1L:",
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			{__Rule}
		],
		Test["Resolved options are still returned with non-unique formula:",
			UploadStockSolutionOptions[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::DuplicatedComponents,Error::InvalidInput}
		],
		Test["Return resolved options if formula components are deprecated:",
			UploadStockSolutionOptions[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::DeprecatedComponents,Error::InvalidInput}
		],
		Test["Return options even if no solvent is explicitly provided and none of the formula components are specified in units of volume:",
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				OutputFormat->List
			],
			{__Rule}
		],
		Example[{Additional,"Resolved options are still returned even if an error is encountered. In this case, the solvent is not a liquid. As a result, these options are not guaranteed to be valid once the error is corrected:"},
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::SolventNotLiquid,Error::InvalidInput}
		],
		Test["Return options even if given non-solid/liquid components:",
			UploadStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::ComponentStateInvalid,Error::InvalidInput}
		],
		Test["Return options when liquid components are specified with amounts that have units of mass:",
			UploadStockSolutionOptions[
				{
					{100 Milliliter,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				},
				OutputFormat->List
			],
			{__Rule}
		],
		Test["Return options when formula volume is too large:",
			UploadStockSolutionOptions[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::FormulaVolumeTooLarge,Error::InvalidOption}
		],
		Example[{Options,Name,"Return resolved options when specifying a Name for the new stock solution:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{15 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Name->"Special Salt in Water Mixture"<>$SessionUUID,
					OutputFormat->List
				],
				Name
			],
			"Special Salt in Water Mixture"<>$SessionUUID
		],
		Example[{Options,Name,"Return a resolved Name option even if the Name is already in use; however, this Name option cannot be used in an UploadStockSolution call:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{10 Milliliter,Model[Sample,"Methanol"]},
						{90 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Name->"Existing Solution of 10% v/v Methanol in Water for UploadStockSolutionOptions"<>$SessionUUID,
					OutputFormat->List
				],
				Name
			],
			"Existing Solution of 10% v/v Methanol in Water for UploadStockSolutionOptions"<>$SessionUUID,
			Messages:>{Error::StockSolutionNameInUse,Error::InvalidOption},
			(* This one needs to be $DeveloperSearch = True *)
			Stubs:>{
				$DeveloperSearch=True,
				Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
			},
			SetUp:>(
				UploadStockSolution[
					{
						{10 Milliliter,Model[Sample,"Methanol"]},
						{90 Milliliter,Model[Sample,"Milli-Q water"]}
					},
					Name->"Existing Solution of 10% v/v Methanol in Water for UploadStockSolutionOptions"<>$SessionUUID
				];
				Upload[<|Object->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water for UploadStockSolutionOptions"<>$SessionUUID], DeveloperObject->True|>]
			),
			TearDown :> (
				EraseObject[Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water for UploadStockSolutionOptions"<>$SessionUUID], Force->True]
			)
		],
		Example[{Options,Synonyms,"Return the resolved Synonyms option when specifically provided. Note that the Name is automatically included as a synonym:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{58.44 Gram,Model[Sample,"Sodium Chloride"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					Name->"Special Salt in Water Mixture"<>$SessionUUID,
					Synonyms->{"1 M NaCL in water"<>$SessionUUID},
					OutputFormat->List
				],
				Synonyms
			],
			{"Special Salt in Water Mixture"<>$SessionUUID,"1 M NaCL in water"<>$SessionUUID}
		],
		Example[{Additional,"Preparative options are also returned by this function when mix and filter are requested with all defaults:"},
			UploadStockSolutionOptions[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				},
				Mix->True,
				Filter->True
			],
			_Grid
		],
		Example[{Additional,"Return resolved pHing options when specifying a NominalpH:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{80 Gram,Model[Sample,"Sodium Chloride"]},
						{2 Gram,Model[Sample,"Potassium Chloride"]},
						{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
						{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
					},
					Model[Sample,"Milli-Q water"],
					1 Liter,
					NominalpH->10,
					OutputFormat->List
				],
				{NominalpH,MinpH,MaxpH,pHingAcid,pHingBase}
			],
			{
				10,
				9.9,
				10.1,
				Model[Sample,StockSolution,"2 M HCl"],
				Model[Sample,StockSolution,"1.85 M NaOH"]
			}
		],
		Test["Return resolved options even after a pH sub-option specification error:",
			UploadStockSolutionOptions[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->False,
				MinpH->6.5,
				pHingBase->Model[Sample,StockSolution,"1.85 M NaOH"],
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::NoNominalpH,Error::InvalidOption}
		],
		Test["Return options even with Expires/ShelfLife conflict:",
			UploadStockSolutionOptions[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Expires->False,
				ShelfLife->1 Year,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::ExpirationShelfLifeConflict,Error::InvalidOption}
		],
		Example[{Additional,"Set and return options specifying safety/storage information for a new stock solution model:"},
			Lookup[
				UploadStockSolutionOptions[
					{
						{2 Gram,Model[Sample,"2-Amino-dA-CE Phosphoramidite"]}
					},
					Model[Sample,"Acetonitrile, Biosynthesis Grade"],
					25 Milliliter,
					OutputFormat->True,
					TransportTemperature->4 Celsius,
					Flammable->True,
					Ventilated->True
				],
				{TransportTemperature,Flammable,Ventilated}
			],
			{EqualP[4 Celsius],True,True}
		],
		Example[{Options,OutputFormat,"Return a list of resolved options instead of a grid:"},
			UploadStockSolutionOptions[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->List
			],
			{__Rule}
		],
		Test["Return all resolved filter options even if filter resolution failed:",
			UploadStockSolutionOptions[
				{
					{58.44 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Mix->False,
				Filter->True,
				FilterMaterial->GlassFiber,
				FilterSize->0.22 Micron,
				OutputFormat->List
			],
			{__Rule},
			Messages:>{Error::InvalidOption,Error::NoFilterAvailable}
		]
	},
	SymbolSetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,fakeBench},
			objects = {
				Object[Container,Vessel,"Test container for sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Container,Bench,"Fake bench for UploadStockSolutionOptions tests"<>$SessionUUID],
				Object[Sample,"Test sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];

			fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for UploadStockSolutionOptions tests"<>$SessionUUID,DeveloperObject->True|>];

			UploadSample[
				Model[Container,Vessel, "50mL Tube"],
				{"Work Surface",Object[Container,Bench,"Fake bench for UploadStockSolutionOptions tests"<>$SessionUUID]},
				Name->"Test container for sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
			UploadSample[
				Model[Sample,"Methanol - LCMS grade"],
				{"A1",Object[Container,Vessel,"Test container for sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID]},
				Name->"Test sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
		]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects = {
				Object[Container,Bench,"Fake bench for UploadStockSolutionOptions tests"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Sample,"Test sample for UploadStockSolutionOptions (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	},
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]]=Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadStockSolutionQ*)


DefineTests[ValidUploadStockSolutionQ,
	{
		Example[{Basic,"Validate creation of a salt solution filled to a total volume of 1L with deionized water:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			True
		],
		Example[{Basic,"Validate creation of a model for a 50% (v/v) methanol/water solution:"},
			ValidUploadStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Milli-Q water"]},
					{500 Milliliter,Model[Sample,"Methanol"]}
				}
			],
			True
		],
		Example[{Basic,"Validate creation of a model for a solution of multiple solid components with a total volume of 1L:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			True
		],
		Example[{Basic,"Validate creation for a model for a solution with a component that does not have model information:"},
			ValidUploadStockSolutionQ[
				{
					{1 Gram,Model[Sample,"Sodium Chloride"]},
					{5 Milliliter,Object[Sample,"Test sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID]}
				},
				Model[Sample,"Milli-Q water"],
				50 Milliliter
			],
			True
		],
		Example[{Basic,"Validate creation of a model for a solution made by unit operations:"},
			ValidUploadStockSolutionQ[
				{
					LabelContainer[Label->"test tube", Container->Model[Container, Vessel, "2mL Tube"]],
					Transfer[Source->Model[Sample,"Milli-Q water"], Destination->"test tube",Amount->100 Microliter],
					Transfer[Source->Model[Sample,"Methanol"], Destination->"test tube",Amount->100 Microliter]
				}
			],
			True
		],
		Example[{Additional,"Validate creation of a new stock solution model based on a template:"},
			ValidUploadStockSolutionQ[
				Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				Name->"New 10% MeOH v/v"<>$SessionUUID
			],
			True
		],
		Example[{Additional,"A template model used as input cannot be deprecated:"},
			ValidUploadStockSolutionQ[
				Model[Sample,StockSolution,"20% MeOH Solution (deprecated)"],
				Name->"New Version of 20% Methanol v/v"<>$SessionUUID
			],
			False
		],
		Example[{Additional,"Validate creation of a model for a solution in which a solid component is a tablet:"},
			ValidUploadStockSolutionQ[
				{
					{2,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			True
		],
		Example[{Additional,"Validate creation of a stock solution that is mixed, incubated, and filtered:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Mix->True,
				Filter->True,
				Incubate->True
			],
			True
		],
		Example[{Additional,"Options must match their option patterns:"},
			ValidUploadStockSolutionQ[
				{
					{2,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->6 Milliliter
			],
			False
		],
		Example[{Options,StockSolutionTemplate,"Validate creation of a new stock solution model when using the Template option:"},
			ValidUploadStockSolutionQ[
				{
					{10 Milliliter,Model[Sample,"Methanol"]},
					{90 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Name->"New Version of Existing Solution of 10% v/v Methanol in Water with Different ShelfLife"<>$SessionUUID,
				StockSolutionTemplate->Model[Sample,StockSolution,"Existing Solution of 10% v/v Methanol in Water"],
				ShelfLife->2 Year
			],
			True
		],
		Example[{Options,Mix,"Specifying Mix->False but providing mix parameters is invalid:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Mix->False,
				MixTime->10 Minute
			],
			False
		],
		Example[{Options,Mix,"Invalid mix option combinations are checked:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				MaxMixTime->10 Minute,
				MixUntilDissolved->False
			],
			False
		],
		Example[{Options,Incubate,"Specifying Incubate->False but providing incubation parameters is invalid:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Incubate->False,
				IncubationTemperature->40*Celsius
			],
			False
		],
		Example[{Options,NominalpH,"If pH titration is requested, the preparation volume of the provided stock solution formula must exceed the minimum threshold to ensure the smallest pH probe can fit in any container in which this formula can be combined:"},
			ValidUploadStockSolutionQ[
				{
					{4 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter,
				NominalpH->7
			],
			False
		],
		Example[{Options,NominalpH,"The NominalpH, MinpH, and MaxpH options should be in appropriate numerical order:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->7,
				MinpH->7.1,
				MaxpH->6.9
			],
			False
		],
		Example[{Options,Filter,"The total preparation volume of the stock solution must exceed a minimum threshold for filtration to ensure that a method with low enough dead volume is available:"},
			ValidUploadStockSolutionQ[
				{
					{2 Milligram,Model[Sample,"Sodium Chloride"]},
					{1.5 Milliliter,Model[Sample,"Milli-Q water"]}
				},
				Filter->True
			],
			False
		],
		Example[{Options,Filter,"Leaving Filter->False but specifying filtration parameters is invalid:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Filter->False,
				FilterMaterial->PES
			],
			False
		],
		Example[{Options,Filter,"Invalid filter option combinations are checked:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				FilterMaterial->GlassFiber,
				FilterSize->0.22 Micron
			],
			False
		],
		Example[{Additional,"Formula Issues","Formula components must be unique:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{15 Gram,Model[Sample,"Sodium Chloride"]},
					{100 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				}
			],
			False
		],
		Example[{Additional,"Formula Issues","Formula components cannot be deprecated:"},
			ValidUploadStockSolutionQ[
				{
					{50 Milligram,Model[Sample,"Alumina, Basic"]}
				},
				Model[Sample,"Milli-Q water"],
				15 Milliliter
			],
			False
		],
		Example[{Additional,"Formula Issues","If no solvent is explicitly provided, that is acceptable and the mixture will just be a solid:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				}
			],
			True
		],
		Example[{Additional,"Formula Issues","The solvent must be a liquid if explicitly provided:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]}
				},
				Model[Sample,"Potassium Phosphate"],
				500 Milliliter
			],
			False
		],
		Example[{Additional,"Formula Issues","Only solids and liquids are supported as formula components:"},
			ValidUploadStockSolutionQ[
				{
					{500 Milliliter,Model[Sample,"Nitrogen, Gas"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			False
		],
		Example[{Additional,"Liquid components can be specified with amounts that have units of mass:"},
			ValidUploadStockSolutionQ[
				{
					{100 Gram,Model[Sample,"Sodium Chloride"]},
					{80 Gram,Model[Sample,"Milli-Q water"]}
				}
			],
			True
		],
		Example[{Additional,"Formula Issues","Tablet components must be specified in amounts that are tablet counts, not masses:"},
			ValidUploadStockSolutionQ[
				{
					{21 Gram,Model[Sample,"Acetaminophen (tablet)"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter
			],
			False
		],
		Example[{Additional,"Formula Issues","The sum of the volumes of any formula components should not exceed the requested total volume of the solution:"},
			ValidUploadStockSolutionQ[
				{
					{300 Milliliter,Model[Sample,"Methanol"]},
					{250 Milliliter,Model[Sample,StockSolution,"70% Ethanol"]}
				},
				Model[Sample,"Milli-Q water"],
				500 Milliliter
			],
			False
		],
		Example[{Options,Name,"Validate an UploadStockSolution call when specifying a Name for the new stock solution model:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Name->"Special Salt in Water Mixture"<>$SessionUUID
			],
			True
		],
		Example[{Additional,"Validate a call for generating a new stock solution model requiring pHing:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				NominalpH->10
			],
			True
		],
		Test["A pHingBase cannot be specified if AdjustpH is False:",
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Chloride"]},
					{2 Gram,Model[Sample,"Potassium Chloride"]},
					{14.4 Gram,Model[Sample,"Dibasic Sodium Phosphate"]},
					{2.4 Gram,Model[Sample,"Potassium Phosphate"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				AdjustpH->False,
				pHingBase->Model[Sample,StockSolution,"0.1 M NaOH"]
			],
			False
		],
		Example[{Additional,"Acid and Base storage cannot be simultaneously required for a stock solution:"},
			ValidUploadStockSolutionQ[
				{
					{80 Gram,Model[Sample,"Sodium Hydroxide"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Base->True,
				Acid->True
			],
			False
		],
		Example[{Options,Verbose,"Print all validity tests performed for a given UploadStockSolution call:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"Control the return value of the validity-checking function:"},
			ValidUploadStockSolutionQ[
				{
					{15 Gram,Model[Sample,"Sodium Chloride"]}
				},
				Model[Sample,"Milli-Q water"],
				1 Liter,
				OutputFormat->Boolean
			],
			True
		]
	},
	(* need to do this because we still want the StorageCondition search to return the real objects and not the fake ones even if $DeveloperSearch = True *)
	Stubs :> {
		Search[Model[StorageCondition]]=Search[Model[StorageCondition], DeveloperObject != True],
		Experiment`Private`$StockSolutionUnitTestFilterOutNewlyCreatedObjects=True
	},
	SymbolSetUp :> {
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,fakeBench},
			objects = {
				Object[Container,Vessel,"Test container for sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Container,Bench,"Fake bench for ValidUploadStockSolutionQ tests"<>$SessionUUID],
				Object[Sample,"Test sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];

			fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ValidUploadStockSolutionQ tests"<>$SessionUUID,DeveloperObject->True|>];

			UploadSample[
				Model[Container,Vessel, "50mL Tube"],
				{"Work Surface",Object[Container,Bench,"Fake bench for ValidUploadStockSolutionQ tests"<>$SessionUUID]},
				Name->"Test container for sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
			UploadSample[
				Model[Sample,"Methanol - LCMS grade"],
				{"A1",Object[Container,Vessel,"Test container for sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID]},
				Name->"Test sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID
			];
		]
	},
	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter},
			objects = {
				Object[Container,Bench,"Fake bench for ValidUploadStockSolutionQ tests"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID],
				Object[Sample,"Test sample for ValidUploadStockSolutionQ (Formula with Object[Sample] with no Model)"<>$SessionUUID]
			};

			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects, existsFilter], Force->True, Verbose->False]];
		]
	}
];
