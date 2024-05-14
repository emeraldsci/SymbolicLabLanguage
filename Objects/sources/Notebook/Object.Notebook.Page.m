(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notebook, Page], {
	Description -> "A page asset in a lab notebook.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> {
		Contents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification],
				Object[Analysis],
				Object[Data],
				Object[Transaction]
			],
			Description -> "References to protocols, analysis, and data that were created on this page.",
			Category -> "Organizational Information"
		},
		HiddenContents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification],
				Object[Analysis],
				Object[Data],
				Object[Transaction]
			],
			Description -> "References to object in the Contents field but that should be hidden in user interfaces.",
			Category -> "Organizational Information"
		},
		SectionsJSON -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The Base64 encoded JSON object representing the section/object hierarchy of the page.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Sidebar -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {
				Alternatives[
					Object[Protocol],
					Object[Maintenance],
					Object[Qualification],
					Object[Analysis],
					Object[Data],
					Object[Transaction]
				],
				Null
			},
			Headers -> {
				"Object",
				"ExpressionUUID"
			},
			Description -> "References to protocols, analysis, and data that were created on this page and the ExpressionUUID of the cells in which they were created.",
			Category -> "Organizational Information"
		},
		StoragePrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD/Month],
			Units -> USD/Month,
			Description -> "The total monthly price for warehousing all user owned items associated with this notebook page in an ECL facility under the storage conditions specified by each item.",
			Category -> "Storage Information"
		},
		StoragePrices -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> UnitsP[0*USD/Month],
			Units -> USD/Month,
			Description -> "The running tally of the total monthly price for warehousing all user owned items associated with this page in an ECL facility under the storage conditions specified by each item.  To find the current price, sum all values of this field.",
			Category -> "Storage Information"
		},
		StoredObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Item]
			],
			Description -> "List of all physical items associated with this notebook page that are currently being warehoused in an ECL facility.",
			Category -> "Storage Information"
		},
		PDFFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The latest exported PDF file of the notebook. This file gets updated whenever ExportNotebookPage is called or when the \"Export to PDF\" button is clicked in Command Center.",
			Category -> "Organizational Information"
		},
		ManifoldJobs -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Notebook, Job][TemplateNotebook],
			Description -> "The list of Manifold jobs that are being run using the commands in this notebook page.",
			Category -> "Organizational Information"
		},
		DateModified -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the Notebook Page was modified.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
