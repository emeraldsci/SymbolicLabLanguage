

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Item, Cap, ElectrodeCap], {
	Description->"A polymer cap that holds electrodes and connects them to an electrochemical reactor for electrochemical synthesis and cyclic voltammetry experiments. This cap also covers the reaction vessel used for the experiment. There are usually one or more openings on the electrode cap for sample addition and gas sparging purposes, which are covered by smaller caps equipped with septum membranes.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ElectrodeCapType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ElectrodeCapType]],
			Pattern :> ElectrodeCapTypeP,
			Description -> "Indicates the manufacturer model type information of this electrode cap object.",
			Category -> "General",
			Abstract -> True
		}
	}
}];
