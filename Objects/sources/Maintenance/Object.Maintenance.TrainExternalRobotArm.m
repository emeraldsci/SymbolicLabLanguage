(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, TrainExternalRobotArm], {
	Description->"A protocol that facilitates programming the path and individual positions a robot arm occupies and actions that the arm takes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The liquid handler instrument whose robot arm is being trained.",
			Category -> "General",
			Developer->True
		},
		RobotArm -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The robot arm that is being trained.",
			Category -> "General",
			Developer->True
		},
		RequiredInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument] | Object[Instrument],
			Description -> "Integrated instruments required for the protocol.",
			Category -> "General"
		},
		CommandChosen->{
			Format -> Single,
			Class -> Expression,
			Pattern :> Forward|Reverse|TrainCurrent|TrainNext|FinishAndPreview|Skip,
			Relation->None,
			Description -> "The command the user has selected for the robot debugger to execute.",
			Category -> "General"
		},
		LatestErrorText->{
			Format -> Single,
			Class -> String,
			Pattern:> _String,
			Relation-> None,
			Description -> "The latest error text we have received, which is stored so it can later be displayed.",
			Category->"General"
		},
		PathIndexCurrentlyTraining->{
			Format->Single,
			Class -> Integer,
			Pattern:>_Integer,
			Relation->None,
			Description->"The index corresponding to the instruction that moves the arm into the position that is currently being trained.",
			Category->"General" (*TODO fix the categories*)
		},
		PathObservedCompletedSuccessfully->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if an operator has assessed that the robotic movement path has completed successfully.",
			Category->"General"
		},
		CurrentPathStartLocation -> {
			Format -> Single,
			Class -> {String, Link},
			Pattern :> LocationContentsP,
			Relation -> {Null, Object[Instrument]|Object[Container]},
			Description -> "The position that the plate will start in when beginning the current path.",
			Headers -> {"Position", "Container"},
			Category -> "General"
		},
		CurrentPathEndLocation -> {
			Format -> Single,
			Class -> {String, Link},
			Pattern :> LocationContentsP,
			Relation -> {Null, Object[Instrument]|Object[Container]},
			Description -> "The position that the plate will end up in at the end of the current path.",
			Headers -> {"Position", "Container"},
			Category -> "General"
		},
		RepeatTrainedPositionDueToWrongElbow->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if an operator needs to repeat the training procedure because the elbow configuration was wrong.",
			Category->"General"
		},
		MovementCompletedWithoutError->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if a robotic movement finished without reporting an error.",
			Category->"General"
		},
		PathTrainingLoopInitialized->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if the procedure has not yet started a path training loop, meaning that the intialization routine still needs to be run.",
			Category->"General"
		},
		PathTrainingLoopCompleted->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if the procedure is finished training a robotic path, and can move on to the next path.",
			Category->"General"
		},
		TrainingContinuationDesire->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if the user wants to continue with robot arm training even though it was successful.",
			Category->"General"
		},
		RepeatMethodInitialization->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if the initialization of the liquid handler method needs to be retried.",
			Category->"General"
		},
		RepeatArmInitialization->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Relation->None,
			Description->"Indicates if the initialization of the liquid handler arm needs to be retried.",
			Category->"General"
		},
		MotionPathGif->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A series of images demonstrating the motion of the robot arm when traversing the current path.",
			Category -> "General"
		},
		NextStepMotionGif->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A series of images demonstrating the motion of the robot arm when taking the next step in the path.",
			Category -> "General"
		},
		DeckPositionImage ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image of the deck position being currently trained highlighted in red in the context of the liquid handler deck.",
			Category -> "General"
		},
		TemporaryExternalRobotArmWaypointOffsets->{
			Format -> Multiple,
			Class -> {
				Name->String,
				XOffset->Real,
				YOffset->Real,
				ZOffset->Real,
				ZRotationOffset->Real,
				RailPositionOffset->Real
			},
			Pattern :> {
				Name->_String,
				XOffset->DistanceP,
				YOffset->DistanceP,
				ZOffset->DistanceP,
				ZRotationOffset->RangeP[-360 AngularDegree, 360 AngularDegree],
				RailPositionOffset->DistanceP

			},
			Relation -> {
				Name->Null,
				XOffset->Null,
				YOffset->Null,
				ZOffset->Null,
				ZRotationOffset->Null,
				RailPositionOffset->Null
			},
			Units -> {
				Name->None,
				XOffset->Millimeter,
				YOffset->Millimeter,
				ZOffset->Millimeter,
				ZRotationOffset->AngularDegree,
				RailPositionOffset->Millimeter
			},
			Description -> "A temporary set of physical offsets for locations of plate positions that can be reached by an external robot arm associated with the liquid handler currently being trained. Positions are measured from the center of the corresponding position in ExternalRobotArmWaypoints. The Rotational location is measured clockwise in the plane perpendicular to the mentioned axis (in xy plane for ZRotation for example) with the rotation axis going through the center of the plate. Rail position offset determines the adjusted position of the robot arm's vertical tower and is positive when approaching the liquid handler. These positions are stored temporarily while training, and uploaded to the liquid handler if training is successful.",
			Category -> "Dimensions & Positions"
		},
		TrainingPlate ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part],
				Model[Part]
			],
			Description -> "The HMotion training plate used in this experiment.",
			Category -> "General"
		},
		TrainingPaths ->{
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of hmotion path names that we will be training.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		LastPathIndexCompletedSuccessfully ->{
			Format->Single,
			Class->Integer,
			Pattern:>_Integer,
			Relation->None,
			Description->"The index of the command in the current path that was successfully completed.",
			Category->"General"
		},
		LastPathIndexBeforeError ->{
			Format->Single,
			Class->Integer,
			Pattern:>_Integer,
			Relation->None,
			Description->"The index of the command in the current path that was successful before the one that had an error.",
			Category->"General"
		},
		MaintenanceKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "String generated from the Maintenance's ID that is used to locate important files, required to use shared procedures and functions.",
			Developer -> True,
			Category -> "General"
		},
		LatestMessageFromInstrument ->{
			Format->Single,
			Class -> Expression,
			Pattern:> {Alternatives[_String->_String|True|False|_?NumericQ]..},
			Description-> "The latest outstanding message, in JSON format, recieved from the instrument.",
			Category->"Notifications"
		}
	}
}];