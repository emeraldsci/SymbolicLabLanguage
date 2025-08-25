(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*CompatibleMaterialsQ*)


(* ::Subsubsection::Closed:: *)
(*CompatibleMaterialsQ*)


DefineTests[
	CompatibleMaterialsQ,
	{
		Example[{Basic,"Check if a sample model is chemically compatible with the wetted materials of an instrument model:"},
			CompatibleMaterialsQ[Model[Instrument,HPLC,"UltiMate 3000"],Model[Sample,"Acetone, HPLC Grade"]],
			True
		],
		Example[{Basic,"Check multiple sample models for chemical compatibility with a specific instrument:"},
			CompatibleMaterialsQ[Object[Instrument,HPLC,"id:Y0lXejGKd8Lo"],{Model[Sample,"Acetone, HPLC Grade"],Model[Sample,"Milli-Q water"]}],
			True
		],
		Example[{Basic,"Check chemical compatibility of a mixed list of models and samples with an instrument model:"},
			CompatibleMaterialsQ[Model[Instrument,FPLC,"AKTApurifier UPC 10"],{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]}],
			False,
			Messages:>{Error::IncompatibleMaterials}
		],
		Example[{Basic,"Check chemical compatible of multiple samples and instruments:"},
			CompatibleMaterialsQ[{Model[Instrument,HPLC,"UltiMate 3000"], Model[Instrument, FPLC, "AKTApurifier UPC 10"]},{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]}, OutputFormat -> Boolean],
			{{True, True}, {False, True}},
			Messages:>{Error::IncompatibleMaterials}
		],
		Example[{Additional,"Returns True if given an empty list:"},
			CompatibleMaterialsQ[Model[Instrument,FPLC,"AKTApurifier UPC 10"],{}],
			True
		],
		Example[{Options,Messages,"Indicate if messages reporting any chemical incompatibilities should be returned:"},
			CompatibleMaterialsQ[
				Model[Instrument,FPLC,"AKTApurifier UPC 10"],
				{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]},
				Messages->False
			],
			False
		],
		Example[{Options,Output,"Indicate if tests reporting any chemical incompatibilities should be returned:"},
			CompatibleMaterialsQ[
				Model[Instrument,FPLC,"AKTApurifier UPC 10"],
				{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]},
				Output->Tests
			],
			{_EmeraldTest ..}
		],
		Example[{Options,Output,"Indicate if both the result and tests reporting any chemical incompatibilities should be returned:"},
			CompatibleMaterialsQ[
				Model[Instrument,FPLC,"AKTApurifier UPC 10"],
				{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]},
				Output->{Result,Tests}
			],
			{False,{_EmeraldTest ..}}
		],
		Example[{Options, {Output, OutputFormat},"If having Result and Tests and OutputFormat -> Boolean, make sure we get the right level of listedness:"},
			CompatibleMaterialsQ[
				Model[Instrument,FPLC,"AKTApurifier UPC 10"],
				{Model[Sample,"Acetone, HPLC Grade"],Object[Sample,"17.5% Nitric Acid Sample"]},
				Output->{Result,Tests},
				OutputFormat -> Boolean
			],
			{{False, True},{_EmeraldTest ..}}
		]
	}
];
