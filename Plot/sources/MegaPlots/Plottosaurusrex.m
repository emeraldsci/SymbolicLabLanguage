(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Plottosaurusrex *)

DefineOptions[Plottosaurusrex,Options:>{}];

Plottosaurusrex[___]:=Constellation`Private`importCloudFile[EmeraldCloudFile["AmazonS3","emeraldsci-ecl-blobstore-stage","aa7a960e19e62ad11cb06c9ea67dbcee.png"]]
