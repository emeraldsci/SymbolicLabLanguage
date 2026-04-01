(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: XuYi *)
(* :Date: 2026-03-09 *)


DefineObjectType[Model[Item, Handle], {
	Description->"Model information for handles that support lifting of racks , items or blocks.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		CompatibleComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container][CompatibleHandle],
				Model[Item][CompatibleHandle],
				Model[Part][CompatibleHandle]
			],
			Description -> "The components (e.g. Racks, Items, Parts, blocks, etc) that this handle is appropriately sized for moving around the lab.",
			Category -> "Model Information",
			Developer -> True
		}
	}
}];