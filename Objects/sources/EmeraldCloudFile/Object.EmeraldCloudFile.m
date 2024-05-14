(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[EmeraldCloudFile], {
	Description->"A cloudfile.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FileName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The user-given name of the file.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		FileType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _String,
			Description -> "The type of data stored in this file.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		FileSize -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*ByteUnit],
			Units -> ByteUnit,
			Category -> "Organizational Information",
			Description -> "The amount of data the file contains."
		},
		CloudFile -> {
			Format -> Single,
			Class -> EmeraldCloudFile,
			Pattern :> EmeraldFileP,
			Description -> "The uploaded file.",
			Category -> "Organizational Information",
			Developer -> True
		},
		OpenCloudFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CloudFile]}, ConstellationViewers`Private`cloudFileButton[Open,Field[CloudFile],""]],
			Pattern :> _Button,
			Description -> "Opens the product web page in the system's default web browser.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		ImportCloudFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CloudFile]}, ConstellationViewers`Private`cloudFileButton[Import,Field[CloudFile],""]],
			Pattern :> _Button,
			Description -> "Opens the product web page in the system's default web browser.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		SaveCloudFile -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CloudFile],Field[FileType]}, ConstellationViewers`Private`cloudFileButton[Save,Field[CloudFile],Field[FileType]]],
			Pattern :> _Button,
			Description -> "Opens the product web page in the system's default web browser.",
			Category -> "Organizational Information",
			Abstract -> False
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
