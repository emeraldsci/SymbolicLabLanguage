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


installDefaultUploadFunction[DefineEHSInformation, Object[Sample], InstallNameOverload -> False, InstallObjectOverload -> True];
installDefaultValidQFunction[DefineEHSInformation, Object[Sample]];
installDefaultOptionsFunction[DefineEHSInformation, Object[Sample]];
