(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[
	PlotContainerCoverNotebookMismatches,
	{
		BasicDefinitions->{
			{"PlotContainerCoverNotebookMismatches[date]","containerCoverMismatches","Returns the number of mismatches between the notebook of a container and the notebook of its attached cover on the specified `date`."},
			{"PlotContainerCoverNotebookMismatches[startDate,endDate,increment]","containerCoverMismatches","Displays the number of container/cover notebook mismatches between the specified `startDate` and `endDate` at each `increment` within that time period"}
		},
		MoreInformation->{
		},
		Input:>{
			{"date",DateObject[],"The date of interest to search for existing containers."},
			{"startDate",DateObject[],"The beginning date of the time period that will be used to display notebook mismatches."},
			{"endDate",DateObject[],"The end date of the time period that is used to determine containers that existed up until that point."},
			{"increment",TimeP[],"The quantity used to divide up the time period between the start date and end date."}
		},
		Output:>{
		{"containerCoverMismatches",_?ValidGraphicsQ|{DateObject[], Integer, Integer, Integer, Integer, Integer, Integer},"Notebook container/cover mismatch counts. Can be displayed visually or as a data point with a date and a mismatch count"}
		},
		SeeAlso->{
		},
		Author->{"adam.abushaer"}
	}
];