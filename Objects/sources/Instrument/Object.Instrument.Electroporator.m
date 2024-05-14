

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Electroporator], {
	Description -> "A device which allows biological molecules, such as DNA or RNA, to enter a cell by use of electric fields.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		IntegratedLiquidHandler -> {
			Format-> Single,
			Class-> Link,
			Pattern:> _Link,
			Relation-> Object[Instrument,LiquidHandler][IntegratedElectroporator],
			Description-> "The liquid handler that is associated with this electroporator such that samples may be passed between the two instruments robotically.",
			Category-> "Integrations"
		}
	}
}];