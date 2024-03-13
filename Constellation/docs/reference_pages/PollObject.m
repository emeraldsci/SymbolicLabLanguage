(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2022-06-08 *)

DefineUsage[waitForChange,
	{
		BasicDefinitions -> {
			{"waitForChange[assoc]", "changed", "Given an association of objects to CAS tokens, wait up to a minute for changes and returns the changed objects."}
		},
		Input :> {
			{"assoc", _Association, "An association of ObjectP[] to CAS tokens."}
		},
		Output :> {
			{"changed", _Association, "An Association of the changed ObjectP[] alongside their new CAS tokens."}
		},
		SeeAlso -> {
			"Download",
			"InteractiveManifold"
		},
		Author -> {"platform"}
	}];