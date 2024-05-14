(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Maintenance,TrainInternalRobotArm],{
	Description->"Definition of a set of parameters for a maintenance protocol that measured a set of x,y,z positions of the internal robot arm attached of a liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		TrainingPlate ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Plate],
			Description -> "The model of the plate used to train positions of the internal robot arm.",
			Category -> "General"
		}
	}
}]