(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2023-02-17 *)
DefineTests[
	WatchProtocol,
	{
		Example[{Basic, "Watch a protocol stream:"},
			WatchProtocol[Object[Protocol, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Protocol, "id:abc"]]  = Null
			}
		],
		Example[{Basic, "Watch a stream from an instrument:"},
			WatchProtocol[Object[Instrument, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Instrument, "id:abc"]] = Null
			}
		],
		Example[{Additional, "Watch a stream from a stream object:"},
			WatchProtocol[Object[Stream, "id:abc"]],
			Null,
			Stubs :> {
				WatchProtocol[Object[Stream, "id:abc"]] = Null
			}
		],
		Example[{Messages, "StreamNotFound", "Returns $Failed if no stream associated with the protocol:"},
			WatchProtocol[protocol],
			$Failed,
			Messages :> {Message[WatchProtocol::StreamNotFound]},
			Variables :> {protocol},
			SetUp :> {
				protocol = Upload[<|Type -> Object[Protocol]|>]
			}
		]
	}
];
