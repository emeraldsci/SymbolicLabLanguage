(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ItemSelector*)

DefineUsage[ItemSelector,
	{
		BasicDefinitions -> {
			{"ItemSelector[items]", "selectedItems", "opens an external dialog with searchable scrolling interface where a user can graphically select the 'selectedItems' from the displayed list of 'items'."}
		},
		MoreInformation -> {
			"The SelectionType option specifies whether the dialog allows a user to select one or multiple items from the list. If set to Automatic, the dialog automatically closes when an item is selected, similar to a drop down menu."
		},
		Input :> {
			{"items", _List, "A list of items to allow the user to choose from."}
		},
		Output :> {
			{"selectedItems", ListableP[_], "The item or items selected by the user in the item selector dialog."}
		},
		SeeAlso -> {
			"ItemSelectorPanel"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ItemSelectorPanel*)

DefineUsage[ItemSelectorPanel,
	{
		BasicDefinitions -> {
			{"ItemSelectorPanel[variable, items]", "selectedItems", "displays a searchable scrolling interface where a user can graphically select the 'selectedItems' from the displayed list of 'items' and assigns the value to 'variable'."}
		},
		MoreInformation -> {
			"The SelectionType option specifies whether the interface allows a user to select one or multiple items from the list. If set to Automatic, the enclosing notebook/dialog automatically closes when an item is selected."
		},
		Input :> {
			{"variable", _Symbol, "The variable to assign the value of 'selectedItems' to."},
			{"items", _List, "A list of items to allow the user to choose from."}
		},
		Output :> {
			{"selectedItems", ListableP[_], "The item or items selected by the user in the item selector interface."}
		},
		SeeAlso -> {
			"ItemSelector"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsubsection::Closed:: *)
(* DynamicToolTip *)

DefineUsage[DynamicTooltip,
	{
		BasicDefinitions -> {
			{"DynamicTooltip[expr, dynamicLabel]", "Tooltip", "displays 'dynamicLabel' as a tooltip while the mouse pointer is in the area when 'expr' is displayed."}
		},
		MoreInformation -> {
			"Creates a temporary mathematica notebook in the style of a tooltip, allowing display of arbitrary mathematica code as a tooltip.",
			"Dynamic expressions such as progress indicators and gifs can be displayed."
		},
		Input :> {
			{"expr", _, "The mathematica expression to display in the origin notebook and to display a tooltip for on mouse-over."},
			{"dynamicLabel", _, "A mathematica expression to display as a tooltip."}
		},
		Output :> {
			{"Tooltip", _, "The dynamic tooltip."}
		},
		SeeAlso -> {
			"Tooltip",
			"DynamicImageImport"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsubsection::Closed:: *)
(* DynamicImageImport *)

DefineUsage[DynamicImageImport,
	{
		BasicDefinitions -> {
			{"DynamicImageImport[cloudfiles]", "dynamicImageGrid", "displays a grid of download progress indicators, downloads the image 'cloudFiles' in the background and displays them once downloaded."}
		},
		MoreInformation -> {
		},
		Input :> {
			{"cloudfiles", ListableP[_EmeraldCloudFile], "The emerald cloud file references for the images to display."}
		},
		Output :> {
			{"dynamicImageGrid", _DynamicWrapper, "The dynamic grid interface populated with images as they download."}
		},
		SeeAlso -> {
			"DynamicImageImport",
			"ImportCloudFile"
		},
		Author -> {"david.ascough"}
	}
];