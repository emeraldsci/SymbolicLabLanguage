(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Constellation Utility Functions",
	Abstract -> "Collection of useful development functions for working with Constellation objects.",
	Reference -> {
		"Database Functions" -> {
			{ObjectLog, "Lists all the changes done to a specified sample in chronological order."},
			{Login, "Connects the kernel to Constellation using a provided use ID and Password."},
			{Logout, "Disconnects the kernel from Constellation."},
			{ClearDownload, "Clears any cached object information accumulated from Constellation during the kernel session."},
			{DatabaseMemberQ, "Checks to see if a provided Object ID can be found in Constellation."}
		},
		"Object Utilities" -> {
			{CreateID, "Generates a new Object ID for uploading new Constellation objects."},
			{CreateLinkID, "Generates a new Link ID for uploading new links between Constellation objects."},
			{RemoveLinkID, "Returns the object of the input linked object."},
			{LookupLabeledObject, "Looks up the labeled object associated with a protocol object."},
			{ValidObjectQ, "Checks the validity of a given Constellation object as defined by the Fields it should contain and the relationship between the values in those fields."},
			{ValidUploadQ, "Checks the validity of a given call to Upload to see if it will successfully execute without actually executing the Upload."},
			{SameObjectQ, "Checks to see if two given Object or Link IDs or names represent the same Constellation object."},
			{PacketP, "Is a pattern that can be accepted to modify an object."},
			{TemporalLinkP, "Is a pattern that matches a temporal link of an object."},
			{Field, "Represents a field in an object."},
			{ValidPacketFormatQ, "Checks the validity of a given packet to see if values in it matches type definitions."},
			{ImageFileQ, "Checks to see if the given EmeraldCloudFile is an image."},
			{RenameCloudFileOptions, "Returns resolved options for renaming the cloud file to have a specified new name."}
		},
		"Favorites Utilities" -> {
			{AddFavoriteObject,"Creates a favorite object for the object or model specified by the user inside the specified favorite folder."},
			{EraseFavoriteFolder,"Remove the favorite folder(s) and all the favorite objects within them."},
			{PlotFavoriteFolder, "Displays information about a user's favorite folder."},
			{BookmarkObject, "Creates a bookmark object for the object or model specified."}
		},
		"Barcoding" -> {
			{ToBarcode, "Converts a provided Constellation Object's ID to a 2D data matrix barcode used to label samples in the laboratory."},
			{ToObject, "Given a scanned barcode, converts to the Constellation object that barcode represents."}
		},
		"Compute" -> {
			{Compute, "Generates a manifold job notebook where the input make up the job's template notebook."},
			{AvailableComputationThreads, "Returns the number of unused computation threads to indicate how many simultaneous computations can be run at the current subscription level."},
			{RunScript, "Executes the given script."},
			{PauseScript, "Prevents the script from continuing after currently running protocols have completed."},
			{StopScript, "Stops the script from further execution and cancels any script protocols which have not yet been run."},
			{RunComputation, "Runs the input computation notebook and returns a boolean value to indicate if  the run is successful."},
			{AbortComputation, "Sets the status of the input computation notebook to Aborting and stop the execution."},
			{StopComputation, "Sets the status of one or more computations to Stopping, which will stop the computation(s) after the currently evaluating cell has completed."}
		},
		"Billing" -> {
			{PriceOperatorTime, "Generates a table of the pricing information for all operators who worked on the given protocol."},
			{PriceStorage, "Generates a table of the ongoing storage costs for storing all the samples associated with a given notebook or all the notebook of a given team."},
			{PriceTransactions, "Generates a table of the receiving charges associated with a given transaction or all of the transactions in a given notebook."},
			{ExportBillingData, "Exports the billing data to a spreadsheet."},
			{SyncBilling, "Creates a new billing object for a financing team with no bill but with a pricing scheme."}
		}
	},
	RelatedGuides -> {
		GuideLink["WorkingWithConstellationObjects"],
		GuideLink["ObjectOntology"],
		GuideLink["EmeraldCloudFiles"],
		GuideLink["IncludingLiteratureReferences"]
	}
]
