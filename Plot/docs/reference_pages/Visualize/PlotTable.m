(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotTable*)


DefineUsage[PlotTable,
{
	BasicDefinitions -> {
		(* custom table input *)
		{
			Definition -> {"PlotTable[values]", "table"},
			Description -> "displays 'values' in a grid 'table' similar to TableForm.",
			Inputs :> {
				{
					InputName -> "values",
					Description -> "Table data (in the form of a matrix).",
					Widget -> Alternatives[
						"Single Row"->Adder[Widget[Type->Expression, Pattern:>_List, Size->Line]],
						"All Rows"->Widget[Type->Expression, Pattern:>{_List..}, Size->Paragraph]						
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "table",
					Description -> "A formatted table containing the field values from the given objects.",
					Pattern :> _Pane
				}
			}
		},

		(* object+field inputs *)
		{
			Definition -> {"PlotTable[objects,fields]", "table"},
			Description -> "creates a 'table' containing the values of 'fields' from 'objects'.",
			Inputs :> {
				{
					InputName -> "objects",
					Description -> "Object whose field values will be displayed in the table.",
					Widget -> If[
						TrueQ[$ObjectSelectorWorkaround],
						Alternatives[
							"Enter Object(s):"->Widget[Type->Expression,Pattern:>ObjectP[Types[]],Size->Line],
							"Select Object(s):"->Adder[
								With[{types = Select[Types[],Length@#==1&]},
									Widget[
										Type->Object,
										Pattern:>ObjectP[Types[types]],
										ObjectTypes->Types[types],
										PreparedSample->False,
										PreparedContainer->False,
										PatternTooltip->"Must match ObjectP[]."
									]
								]
							]
						],
						Adder[
							With[{types = Select[Types[],Length@#==1&]},
								Widget[
									Type->Object,
									Pattern:>ObjectP[Types[types]],
									ObjectTypes->Types[types],
									PreparedSample->False,
									PreparedContainer->False,
									PatternTooltip->"Must match ObjectP[]."
								]
							]
						]
					]
				},
				{
					InputName -> "fields",
					Description -> "Fields to display in the table.",
					Widget -> Alternatives[
						(* this Links -> True option is truly dumb.  If we do FieldQ[Horse[Zebra], Output -> Short, Links -> True], it will return True because it recognizes the link syntax despite there obviously being no horse or zebra options *)
						(* to add onto it, FieldP does NOT have a links option, and neither does Fields *)
						(* so there is literally zero error checking of anything if we allow this Links -> True thing to be here.  But we do need it here regardless if we want to allow through-links support (which I assume we do) *)
						"Enter Fields:"->Widget[Type->Expression,Pattern:>ListableP[FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&)],Size->Line],
						"Enter Individual Fields:"->Adder[
							Widget[Type->Expression,Pattern:>FieldP[Output->Short]|_?(FieldQ[#,Output->Short,Links->True]&),Size->Word]
						]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "table",
					Description -> "A formatted table containing the field values from the given objects.",
					Pattern :> _Pane
				}
			}
		}

	},
	MoreInformation -> {
			"TableForm is represented strangely in Mathematica's Front End. To ease these troubles, PlotTable can be used.",
			"PlotTable can take any Grid options as well as the options listed below."
		},

	SeeAlso -> {
			"Inspect",
			"PlotObject",
			"TableForm"
		},
	Author -> {"malav.desai", "waseem.vali", "sebastian.bernasek", "brad", "robert"},
	Preview->True
}];


(* ::Subsubsection::Closed:: *)
(*PlotTableOptions*)


DefineUsage[PlotTableOptions,
{
	BasicDefinitions -> {
		(* one input *)
		{
			Definition -> {"PlotTableOptions[values]", "options"},
			Description -> "returns all resolved 'options' for PlotTable['values'].",
			Inputs :> {
				{
					InputName -> "values",
					Description -> "Table data (in the form of a matrix).",
					Widget -> Widget[Type->Expression, Pattern:>{_List..}, Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the PlotTable call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		},


		(* two inputs *)
		{
			Definition -> {"PlotTableOptions[objects, fields]", "options"},
			Description -> "returns all resolved 'options' for PlotTable['objects', 'fields'].",
			Inputs :> {
				{
					InputName -> "objects",
					Description -> "Object whose field values will be displayed in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[ObjectP[]], Size->Paragraph]
				},
				{
					InputName -> "fields",
					Description -> "Fields to display in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[FieldP[Output->Short]], Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "options",
					Description -> "The resolved options in the PlotTable call.",
					Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]..}
				}
			}
		}

	},

	SeeAlso -> {
		"PlotTable",
		"PlotObject"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*PlotTablePreview*)


DefineUsage[PlotTablePreview,
{
	BasicDefinitions -> {
		(* one input *)
		{
			Definition -> {"PlotTablePreview[values]", "preview"},
			Description -> "returns a graphical display representing PlotTable['values'] output.",
			Inputs :> {
				{
					InputName -> "values",
					Description -> "Table data (in the form of a matrix).",
					Widget -> Widget[Type->Expression, Pattern:>{_List..}, Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the PlotTable call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
		},

		(* two inputs *)
		{
			Definition -> {"PlotTablePreview[objects, fields]", "preview"},
			Description -> "returns a graphical display representing PlotTable['objects', 'fields'] output.",
			Inputs :> {
				{
					InputName -> "objects",
					Description -> "Object whose field values will be displayed in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[ObjectP[]], Size->Paragraph]
				},
				{
					InputName -> "fields",
					Description -> "Fields to display in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[FieldP[Output->Short]], Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "preview",
					Description -> "The graphical display representing the PlotTable call output.",
					Pattern :> (ValidGraphicsP[] | Null)
				}
			}
		}

	},

	SeeAlso -> {
		"PlotFit",
		"PlotFitPreview"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidPlotTableQ*)


DefineUsage[ValidPlotTableQ,
{
	BasicDefinitions -> {
		(* one input *)
		{
			Definition -> {"ValidPlotTableQ[values]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of PlotTable['values'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "values",
					Description -> "Table data (in the form of a matrix).",
					Widget -> Widget[Type->Expression, Pattern:>{_List..}, Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of PlotTable['values'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		},

		(* two inputs *)
		{
			Definition -> {"ValidPlotTableQ[objects, fields]", "testSummary"},
			Description -> "returns an EmeraldTestSummary which contains the test results of PlotTable['objects', 'fields'] for all the gathered tests/warnings or a single Boolean indicating validity.",
			Inputs :> {
				{
					InputName -> "objects",
					Description -> "Object whose field values will be displayed in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[ObjectP[]], Size->Paragraph]
				},
				{
					InputName -> "fields",
					Description -> "Fields to display in the table.",
					Widget -> Widget[Type->Expression, Pattern:>ListableP[FieldP[Output->Short]], Size->Paragraph]
				}
			},
			Outputs :> {
				{
					OutputName -> "testSummary",
					Description -> "The EmeraldTestSummary of PlotTable['values', 'fields'].",
					Pattern :> (EmeraldTestSummary| Boolean)
				}
			}
		}

	},

	SeeAlso -> {
		"PlotTable",
		"PlotTableOptions"
	},
	Author -> {"scicomp", "brad"}
}];