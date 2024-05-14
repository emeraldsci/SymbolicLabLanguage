(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: andrey *)
(* :Date: 2023-04-04 *)

DefineObjectType[Object[Instrument, DistanceGauge], {
	Description->"Device for high precision measurement of distance.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		DistanceSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet distance sensor used by this distance measuring instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		}
	}
}];