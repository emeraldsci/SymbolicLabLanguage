(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: pavanshah *)
(* :Date: 2022-09-08 *)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* TODO: more descriptive descriptions that actually say what the field represents and not be self-referential. No Max Length *)
(* TODO: acronyms are spelled out if it makes it more understandable *)
(* TODO: parent group of Object[Stream] that is called object[Stream], and then rename this object to be Object[CameraStream] *)
(* TODO: Result needs better name, maybe finished video or video file *)
DefineObjectType[Object[Stream], {
	Description->"A video stream of something in the lab.",
	CreatePrivileges -> None,
	Cache->Download,
	Fields -> {
		StreamID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The unique Amazon Resource Number representing the stream.",
			Category -> "General"
		},
		StreamName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The named alias for the stream as shown within the Amazon Web Service.",
			Category -> "General"
		},
		VideoCaptureComputer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Computer],
			Description -> "The source computer of the stream.",
			Category -> "General"
		},
		StartTime->{
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date when the stream started.",
			Category -> "General"
		},
		EndTime->{
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date when the stream ended.",
			Category -> "General"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Running | Error | Completed,
			Description -> "The status indicates whether the stream is currently recording.",
			Category -> "General"
		},
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][Streams],
				Object[Maintenance][Streams],
				Object[Qualification][Streams]
			],
			Description -> "The protocol recorded by the stream.",
			Category -> "General"
		},
		VideoFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The cloudfile containing a video that represents the full stream.",
			Category -> "General"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "General",
			Developer -> True
		}
	}
}];
