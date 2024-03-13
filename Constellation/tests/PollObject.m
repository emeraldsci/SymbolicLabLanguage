(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2022-06-08 *)

DefineTests[
	waitForChange,
	{
		Example[{Basic, "Empty case:"},
			waitForChange[<||>],
			<||>
		],
		Example[{Basic, "Returns the objects that have diverged from their particular CAS tokens:"},
			waitForChange[<|$PersonID -> ""|>],
			<|$PersonID -> _ |>
		],
		Example[{Basic, "Waits about a minute for changes. Otherwise returns nothing:"},
			Module[{object, cas},
				object = Upload[<|Type->Object[Example,Data]|>];
				cas = Lookup[Download[object, IncludeCAS->True], CAS, ""];
				waitForChange[<|object->cas|>]
			],
			<||>,
			TimeConstraint -> 180 (* tests run slower *)
		],
		Example[{Messages,"ObjectDoesNotExist","Bad objects result in a Message:"},
			waitForChange[<|Object[User, Emerald, Developer, "id:123"] -> ""|>],
			<||>,
			Messages :> {Message[waitForChange::ObjectDoesNotExist]}
		]
	}
];
