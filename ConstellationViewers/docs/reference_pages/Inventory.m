(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[PlotInventory,
	{
		BasicDefinitions -> {
			{"PlotInventory[]", "Table", "Plot the inventory dashboard."},
			{"PlotInventory[Name]", "Table", "Plot the inventory dashboard, restricting to items with name matching the supplied variable."},
			{"PlotInventory[Notebook]", "Table", "Plot the inventory dashboard for the given notebook."},
			{"PlotInventory[Notebooks]", "Table", "Plot the inventory dashboard for the given notebooks."},
			{"PlotInventory[Notebook, Name]", "Table", "Plot the inventory dashboard for the given notebook, restricting to items with name matching the supplied variable."},
			{"PlotInventory[Notebooks, Name]", "Table", "Plot the inventory dashboard for the given notebooks, restricting to items with name matching the supplied variable."}
		},
		MoreInformation -> {
			"Output of the inventory dashboards pane in command center for export to other applications or programmatic analysis."
		},
		Input :> {
			{"Notebook", ObjectP[Object, LaboratoryNotebook], "The notebook to limit the dashboard to."},
			{"Notebooks", {ObjectP[Object, LaboratoryNotebook]..}, "The notebooks to limit the dashboard to."},
			{"Name", _String, "The string to search object names with."}
		},
		Output :> {
			{"Table", TableForm, "The requested table of the inventory dashboard."}
		},
		SeeAlso -> {
			"Upload",
			"Download",
			"PlotFavoriteFolder",
			"PlotFavoriteBookmarksOnNotebook"
		},
		Author -> {
			"platform"
		}
	}
];
