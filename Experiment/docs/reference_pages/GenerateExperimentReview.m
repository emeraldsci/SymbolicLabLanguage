(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*GenerateExperimentReview*)


(* ::Section:: *)
(*Definition*)


(* ::Subsection:: *)
(* GenerateExperimentReview *)


DefineUsage[
    GenerateExperimentReview,
    {
        BasicDefinitions -> {
            {"GenerateExperimentReview[protocol]", "cloudFile", "Compiles primary data and meta-data connected to the input 'protocol' and outputs a formatted 'cloudFile'."}
        },
        MoreInformation -> {
        },
        Input :> {
            {"protocol", ObjectP[Object[Protocol]], "The experiment to be reviewed."}
        },
        Output :> {
            {"cloudFile", ObjectP[Object[EmeraldCloudFile]], "The formatted page that is uploaded as a cloud file."}
        },
        SeeAlso -> {
            "PlotObject",
            "RequestSupport",
            "Inspect",
            "OpenCloudFile"
        },
        Author -> {"malav.desai"}
    }
];