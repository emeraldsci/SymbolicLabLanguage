(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Software, ManifoldKernel], {
	Description -> "An interactive manifold kernel for remote processing.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		ManifoldJob -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[Notebook, Job]],
			Relation -> Object[Notebook, Job],
			Description -> "The manifold job powering this kernel.",
			Category -> "Organizational Information"
		},
		Commands -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> ObjectP[Object[Software, ManifoldKernelCommand]],
			Relation -> Object[Software, ManifoldKernelCommand][ManifoldKernel],
			Description -> "All commands run, running, or pending in this kernel.",
			Category -> "Organizational Information"
		},
		CurrentCommand -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[Object[Software, ManifoldKernelCommand]],
			Relation -> Object[Software, ManifoldKernelCommand],
			Description -> "The current running command, or Null, if one is not running.",
			Category -> "Organizational Information"
		},
		Distro -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Software, Distro],
			Description -> "The pre-built set of packages for a specific commit of SLL used to generate this maintenance.",
			Category -> "Organizational Information"
		},
		AsanaTaskID -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The ID of an Asana task associated with the kernel.",
			Category -> "Organizational Information"
		},
		Available -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the kernel is available for external commands.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
