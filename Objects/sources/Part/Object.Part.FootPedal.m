DefineObjectType[Object[Part,FootPedal], {
	Description -> "A set of food pedals that allow for hand free input to a computer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		KeyboardMap -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {_String, _String},
			Description -> "The mapping from foot pedal to keyboard input that is sent to the connected computer.",
			Category -> "Part Specifications",
			Headers -> {"FootPedal", "Keyboard Input"}
		}
	}
}];

