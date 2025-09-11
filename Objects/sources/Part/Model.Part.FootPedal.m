DefineObjectType[Model[Part,FootPedal], {
	Description -> "Model information for a set of food pedals that allow for hand free input to a computer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		NumberOfPedals -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0,1],
			Description -> "The number of unique pedals that can be used as input.",
			Category -> "Part Specifications"
		}
	}
}];