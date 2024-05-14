(* :: Package:: *)

DefineObjectType[Object[Item,PlateSeal],{
	Description-> "Information for a flexible item that attaches to the top of a plate (in order to protect its contents) via an adhesive, temperature activated adhesive, or press fit.",
	CreatePrivileges->None,
	Cache->Download,
	Fields->{
		CoveredContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :>  _Link,
			Relation -> Object[Container][Cover],
			Description -> "The plate that this plate seal is currently covering.",
			Category -> "Dimensions & Positions"
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this cover can be taken off and replaced multiple times without issue.",
			Category -> "Item Specifications"
		}
	}
}];
