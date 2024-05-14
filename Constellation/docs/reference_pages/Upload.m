(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Upload *)
DefineUsage[Upload,
	{
		BasicDefinitions -> {
			{"Upload[packet]", "object", "creates object of 'packet' key Type, or modifies existing object of 'packet' key Object."},
			{"Upload[packets]", "objects", "sequentially creates or modifies the elements of 'packets'."}
		},
		MoreInformation -> {
			"Append[myField] -> add a new value to myField.",
			"Replace[myField] -> remove existing elements of myField, and set myField with the provided data.",
			"Erase[myField] -> delete a row, row-column pair, or nested list of rows from myField.",
			"EraseCases[myField] -> delete any element of myField that matches the value.",
			"The keys for multiple fields must be wrapped in Append or Replace to denote whether to append to that field or replace it entirely.",
			"Any delayed rules in a packet will be ignored.",
			"Upload will fail if any fields being modified are specified as rules and are computable fields (see LookupTypeDefinition to investigate field types)."
		},
		Input :> {
			{"packet", PacketP[], "An association describing an object to be created or modified."},
			{"packets", {___PacketP[]}, "A list of associations, each describing a database update."}
		},
		Output :> {
			{"object", ObjectReferenceP[], "The object that was created or modified by the upload."},
			{"objects", {ObjectReferenceP[]...}, "The list of objects which were created or modified by the upload."}
		},
		SeeAlso -> {"Download", "ValidUploadQ", "LookupTypeDefinition", "ObjectP", "LinkP", "PacketP", "ObjectReferenceP"},
		Tutorials -> {"Named Fields"},
		Author -> {"platform", "thomas"}
	}];

(* RollbackTransaction *)
DefineUsage[RollbackTransaction,
	{
		BasicDefinitions -> {
			{"RollbackTransaction[transaction]", "list", "reverts the changes made to any objects and fields that are within the provided transaction."}
		},
		MoreInformation -> {
			"RollbackTransaction will fail if the transaction contains the last update to their field. This can be bypassed by using the Force option.",
			"RollbackTransaction on a parent transaction will also revert the contents of its children transactions.",
			"RollbackTransaction of a child transaction will revert the field values to those of its parents. The rolled back upload will also contain the parent transaction id.",
			"RollbackTransaction can only be called by Emerald developers."
		},
		Input :> {
			{"transaction", _String, "A string representing a unique transaction id."}
		},
		Output :> {
			{"list", _List, "The objects and fields that were rolled back for the provided transaction."}
		},
		SeeAlso -> {"Download", "Upload", "ObjectLog"},
		Author -> {"platform"}
	}];

(* SuperUpload *)
DefineUsage[SuperUpload,
	{
		BasicDefinitions -> {
			{"SuperUpload[uploadPacket]", "objectChangeTable", "uploads the 'uploadPacket' to each database and returns the corresponding 'objectChange' for each database."},
			{"SuperUpload[uploadPackets]", "objectChangesTable", "uploads the 'uploadPackets' to each database and returns the corresponding 'objectChanges' for each database."},
			{"SuperUpload[uploadPacket, OutputAsTable -> False]", "objectChange", "uploads the 'uploadPacket' to each database and returns the corresponding 'objectChange' for each database."},
			{"SuperUpload[uploadPackets, OutputAsTable -> False]", "objectChanges", "uploads the 'uploadPackets' to each database and returns the corresponding 'objectChanges' for each database."}
		},
		Input :> {
			{"uploadPacket", PacketP[], "The upload packet that will be uploaded to each database."},
			{"uploadPackets", {PacketP[]..}, "The upload packets that will be uploaded to each database."}
		},
		Output :> {
			{"objectChangeTable", _Panel, "The object that was created or modified on each database where the packet was uploaded."},
			{"objectChangesTable", _Panel, "The objects that were created or modified on each database where the packets were uploaded."},
			{"objectChange", {Rule[(_String | _Symbol), ObjectP[]]..}, "The object that was created or modified on each database where the packet was uploaded."},
			{"objectChanges", {Rule[(_String | _Symbol), {ObjectP[]..}]..}, "The objects that were created or modified on each database where the packets were uploaded."}
		},
		SeeAlso -> {"Upload"},
		Author -> {"taylor.hochuli"}
	}
]