(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
  Title->"ECL Packaging",
  Abstract->"Functions for working with packages in the ECL system.",
  Reference->{
		"Loading Packages"->{
			{LoadPackage,"Load a package by its name."},
(*
			{ReloadPackage,"Reload a package after making changes to the source files."},
*)
			{AvailablePackages,"Get the list of packages that can be loaded."},
			{AppendPackagePath,"Add directories to the package search path"},
			{LoadUsage,"Load documentation for a package."}
(*
			,
			{LoadDistro,"Load a pre-defined collection of packages"}
*)
		},
(*
		"Creating Packages"->{
			{NewPackage,"Generate a new package folder and expected sub-folders."},
			{OnLoad,"Define an expression to be loaded every time a package is loaded."}
		},
*)
(*
		"Information About Packages"->{
			{PackageMetadata, DistroMetadata},
			{PackageFunctions, PackageSymbols},
			{PackageDirectory, PackageSources, PackageDocumentationDirectory},
			{PackageQ}
		},
*)
		"Package Membership"->{
			{(* SymbolPackages, *) FunctionPackage}
		},
(*
		"Package Building"->{
			{WritePackageMx, PackageGraph, DirectoryPackage}
		},
*)
		"Documentation Generation"->{
			{FunctionPackage (* , SymbolPackageName *) },
			{LoadUsage (* ,PackageDocumentationDirectory *) }
		}
	},
	RelatedGuides -> {}
]
