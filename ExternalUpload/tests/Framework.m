(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[approximateDensity,
	{
		Test["Approximates density when provided composition with 2 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 VolumePercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 2 MassPercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 MassPercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.5 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 1 MassPercent and 1 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided volumes for both components being mixed:",
			Round[UnitConvert[approximateDensity[{
				{1 Milliliter,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample1"], ID->"id:testSample1"|>},
				{1 Milliliter,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when transferring 0 mL to 0 mL to not freak out and just pick water's density:",
			Round[UnitConvert[approximateDensity[{
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample1"], ID -> "id:testSample1"|>},
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample2"], ID -> "id:testSample2"|>}
			}], "Grams" / "Milliliters"], 0.01],
			(1. Gram / Milliliter),
			EquivalenceFunction -> Equal
		]
	}
];