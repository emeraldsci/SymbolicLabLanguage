(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software,Distro], {
	Description->"A pre-built set of packages for a specific commit of SLL.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Packages -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The set of packages that are loaded onto the $ContextPath.",
			Category -> "Organizational Information"
		},
		HiddenPackages -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The set of packages that are loaded, but hidden from the $ContextPath.",
			Category -> "Organizational Information"
		},
		Archive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The archive containing the built versions of all the packages in this distro.",
			Category -> "Organizational Information"
		},
		TestArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The archive containing all the tests for the packages in this distro.",
			Category -> "Organizational Information"
		},
		DocumentationArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The archive containing all the documentation notebooks for all the packages in this distro.",
			Category -> "Organizational Information"
		},
		PacletsArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The archive containing all the fix paclets for all the packages in this distro.",
			Category -> "Organizational Information"
		},
		ProfilerArchive -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[EmeraldCloudFile]],
			Relation->Object[EmeraldCloudFile],
			Description -> "The archive containing the parsed version of the code base with source map information used for profiling.",
			Category -> "Organizational Information",
			AdminViewOnly -> True (* this is essentially a source code, we should never give this to the user *)
		},
		RefreshRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if any open Mathematica kernels must be quit and the most recent code changes fetched before work can continue to avoid errors that may be caused by working with an older version of the codebase.",
			Category -> "Organizational Information"
		}
	}
}];
