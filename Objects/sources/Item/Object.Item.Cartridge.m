(* :: Package:: *)

DefineObjectType[Object[Item,Cartridge],{
	Description-> "Object information for cartridge associated with various instruments and applications.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		CartridgeType->{
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]},Download[Field[Model],CartridgeType]],
			Pattern:>CartridgeTypeP,(* Column|DNASequencing|ProteinCapillaryElectrophoresis|Osmolality *)
			Description->"The instrument this cartridge is compatible with.",
			Category->"Organizational Information",
			Abstract->True
		}
	}
}];