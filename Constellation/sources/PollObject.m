(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2022-06-07 *)

waitForChange::ObjectDoesNotExist = "`1`";

waitForChange[objectsCASAssoc_Association] := Module[{objectIdsWithCAS, requestBody, response, error, changedObjects},
	requestBody = <|"ObjectCAS"->KeyMap[Download[#, ID]&, objectsCASAssoc]|>;

	response=GoCall["PollObject", requestBody];

	error = Lookup[response, "Error", ""];
	If[!MatchQ[error, ""],
		Message[waitForChange::ObjectDoesNotExist, error];
		(* TODO: return Empty Association on error, or $Failed temporarily just to simplify error scenarios *)
		Return[<||>];
	];
	changedObjects = Lookup[response, "Changed", <||>];

	If[MatchQ[changedObjects, Null] || MatchQ[changedObjects, {}], Return[<||>]];

	KeyMap[Download[Object[#], Object]&, changedObjects]
];