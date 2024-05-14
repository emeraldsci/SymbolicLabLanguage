(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DefineEHSInformation*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[DefineEHSInformation,
	SharedOptions :> {
		ObjectSampleHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[DefineEHSInformation, Object[Sample], {InstallNameOverload -> False, InstallObjectOverload -> True}];
InstallValidQFunction[DefineEHSInformation, Object[Sample]];
InstallOptionsFunction[DefineEHSInformation, Object[Sample]];
