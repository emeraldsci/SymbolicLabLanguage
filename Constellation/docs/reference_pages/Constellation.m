(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*CreateID*)

DefineUsage[CreateID,
	{
		BasicDefinitions -> {
			{"CreateID[type]", "object", "creates an object ID of the given 'type'."},
			{"CreateID[types]", "objects", "creates object IDs of the given 'types'."}
		},
		MoreInformation -> {
			"This creates 'empty' objects on the backend of the specified types."
		},
		Input :> {
			{"type", TypeP[], "The type with which to create the object for."},
			{"types", {TypeP[]...}, "The types with which to create the object for."}
		},
		Output :> {
			{"object", ObjectReferenceP[] | $Failed, "The Object's reference."},
			{"objects", {(ObjectReferenceP[] | $Failed)...}, "The Objects' reference."}
		},
		SeeAlso -> {"Download", "ValidPacketFormatQ", "Upload"},
		Author -> {"platform", "thomas"}
	}];

(* ::Subsection:: *)
(*PinObject*)

DefineUsage[PinObject,
	{
		BasicDefinitions -> {
			{"PinObject[object]", "pin", "creates a pin for 'object'."},
			{"PinObject[objects]", "pin", "creates a pin for 'objects'."}
		},
		Input :> {
			{"object", ObjectP[], "Any valid object or model in Constellation."},
			{"objects", {ObjectP[]..}, "Any valid object or model in Constellation."}
		},
		Output :> {
			{"pin", Null, "The Constellation pin that is returned."}
		},
		SeeAlso -> {"Download", "ValidPacketFormatQ", "Upload"},
		Author -> {"melanie.reschke", "hanming.yang", "thomas"}
	}];


(* ::Subsection:: *)
(*CreateLinkID*)

DefineUsage[CreateLinkID,
	{
		BasicDefinitions -> {
			{"CreateLinkID[]", "linkid", "creates a LinkID which can be used in modifications and updates."},
			{"CreateLinkID[count]", "linkids", "creates 'count' LinkIDs which can be used in modifications and updates."}
		},
		MoreInformation -> {
			"LinkIDs are strings which can be used as the Last Part of Link values in Upload calls."
		},
		Input :> {
			{"count", _Integer?Positive, "The number of LinkIDs to create at once."}
		},
		Output :> {
			{"linkid", _String | $Failed, "The generated LinkID."},
			{"linkids", {(_String | $Failed)..}, "A List of generated LinkIDs."}
		},
		SeeAlso -> {"Upload", "CreateID"},
		Author -> {"platform", "thomas"}
	}];


(* ::Subsection:: *)
(*EraseLink*)

DefineUsage[EraseLink,
	{
		BasicDefinitions -> {
			{"EraseLink[link]", "output", "erases a link. If the link is bi-directional the reverse link is removed as well."},
			{"EraseLink[links]", "outputs", "erase a link. If any of the links are bi-directional its reverse link is removed as well."}
		},
		MoreInformation -> {
			"This is a distructive action and cannot be undone."
		},
		Input :> {
			{"link", LinkP[], "The reference to the Link to earse."},
			{"links", {LinkP[]...}, "The references to the Links to earse."}
		},
		Output :> {
			{"output", True | $Failed, "True if the erase completed successfully, $Failed otherwise."},
			{"outputs", {(True | $Failed)...}, "A List of True if the erase completed successfully, $Faileds otherwise."}
		},
		SeeAlso -> {"Upload", "Download", "EraseObject", "LinkP"},
		Author -> {"platform", "thomas"}
	}];

(* ::Subsection:: *)
(*Download*)

DefineUsage[Download,
	{
		BasicDefinitions -> {
			{"Download[objects]", "packets", "download the 'objects'."},
			{"Download[objects, fields]", "values", "downloads only the specified 'fields' of the 'objects'."},
			{"Download[objects, fieldLists]", "values", "downloads the sub-list of fields from 'fieldLists' for each of 'objects' at the same position in the list."},
			{"Download[references]", "values", "downloads the values from the fields in the given field 'references'."}
		},
		MoreInformation -> {
			"Downloading from a packet, instead of an object, will not fetch any new data from the server and will instead lookup values in that packet.",
			"Downloading a _Packet head and a sequence of fields, instead of a list of fields, will cause a partial packet of values to be returned.",
			"When the PaginationLength option is specifed and a multiple field has a length greater then that number, the resulting key-value pair is a RuleDelayed call to Download.",
			"Downloading Null at any index will return Null for that index.",
			"Downloading $Failed at any index will return $Failed for all fields at that index.",
			"Download can traverse links using a special syntax: ProtocolsAuthored[Status] will download the Status field from all the objects linked in the ProtocolsAuthored field.",
			"Download can extract a specific index from an indexed multiple field: StatusLog[[All,2]] will Download all values at index 2 in an indexed multiple field.",
			"The above can be combined to an arbitrary depth, for example: ProtocolsAuthored[Resources][[All,1]][Model]",
			"If a Null value is encountered at any point in the link traversal, it will stop and return Null for that node.",
			"Using the special field \"All\" will download all the fields in the related packet (for example, Model[All]).",
			"All must be the last field requested in a change, it cannot be used in the middle of a traversal (Model[All][Name] is invalid).",
			(*TODO: remove after migration*)
			"The part syntax Contents[[2]] & Contents[[All,2]] are equivalent.",
			"$CacheSize controls the maximum size (in bytes) of previously downloaded objects which will be cached."
		},
		Input :> {
			{"objects", ObjectP[] | {ObjectP[]...}, "The reference to the Object(s) to download."},
			{"fields", _ | _List | _Packet, "The field, list of fields, or _Packet of fields from the Object to download."},
			{"fieldLists", {___List} | {___Packet}, "List of lists (or list of packets) of fields to download."},
			{"references", FieldReferenceP[] | {FieldReferenceP[]...}, "List of field references (or a single reference) to download."}
		},
		Output :> {
			{"packets", _Association | {___Association}, "The Assocation packet(s), or a $Failed if there was an error."},
			{"values", _ | {__}, "Values from the specific fields requested."},
			{"filePaths", _?FileExistsQ | {_?FileExistsQ ..}, "Path(s) of files to which files have been downloaded."}
		},
		SeeAlso -> {"Field", "Upload", "ValidUploadQ", "ValidPacketFormatQ"},
		Tutorials -> {"Named Fields"},
		Author -> {
			"platform", "thomas"
		}
	}];

(* ::Subsection:: *)
(*EraseObject*)

DefineUsage[ClearDownload,
	{
		BasicDefinitions -> {
			{"ClearDownload[]", "Null", "removes all objects from the Download cache."},
			{"ClearDownload[objects]", "removed", "removes the specified 'objects' from the Download cache."},
			{"ClearDownload[ids]", "removed", "removes all the objects from the Download cache with the given 'ids'."}
		},
		MoreInformation -> {
			"Only objects that were already in the cache and removed will be returned."
		},
		Input :> {
			{"objects", ObjectReferenceP[] | {ObjectReferenceP[]..}, "The specific objects to remove from the cache."},
			{"ids", _String | {__String}, "The string IDs of the specific objects to remove from the cache."}
		},
		Output :> {
			{"removed", {ObjectReferenceP[]...}, "The list of objects that were removed from the cache."}
		},
		SeeAlso -> {"Upload", "Download", "ObjectReferenceP"},
		Author -> {"platform", "thomas"}
	}];

(* ::Subsection:: *)
(*EraseObject*)

DefineUsage[EraseObject,
	{
		BasicDefinitions -> {
			{"EraseObject[object]", "result", "deletes the object from the database."},
			{"EraseObject[objects]", "result", "deletes the objects from the database."}
		},
		MoreInformation -> {
			"Makes destructive changes (replacements) to an object's fields.",
			"This function prompts the user to confirm they want to go through with the deletion.",
			"EraseObject is listable. Prompting is for the entire list of objects."
		},
		Input :> {
			{"object", ObjectReferenceP[], "An Object or Model reference reference to delete."},
			{"objects", {ObjectReferenceP[] ...}, "A list of Object or Model references to delete."}
		},
		Output :> {
			{"result", True | $Failed | $Canceled, "True if the operation succeeded, $Failed otherwise, or $Canceled if the user canceled."}
		},
		SeeAlso -> {"Upload", "Download", "EraseLink", "ValidPacketFormatQ"},
		Author -> {"platform", "thomas"}
	}];

(* DatabaseMemberQ *)
DefineUsage[DatabaseMemberQ,
	{
		BasicDefinitions -> {
			{"DatabaseMemberQ[object]", "bool", "returns True if the 'object' exists."},
			{"DatabaseMemberQ[objects]", "bools", "returns True for each of the 'objects' which exists."}
		},
		Input :> {
			{"object", ObjectP[], "The object to check if it exists in the database."},
			{"objects", {ObjectP[]...}, "A list of objects to check if they exist in the database."}
		},
		Output :> {
			{"bool", True | False, "True if the object exists, False otherwise."},
			{"bools", {(True | False)...}, "True at each index where the objects exist, False at each index they do not."}
		},
		SeeAlso -> {"Download", "Upload", "ObjectP", "LinkP", "PacketP", "ObjectReferenceP", "MemberQ", "List"},
		Author -> {"platform", "thomas"}
	}];

(* Field *)
DefineUsage[Field,
	{
		BasicDefinitions -> {
			{"Field[spec]", "Field[spec]", "represents a field in an object or a sequence of links through multiple objects."}
		},
		MoreInformation -> {
			"References can be SubValues of fields, SubValues of Repeated fields, and Part expressions",
			"Common Field expressions include:",
			Grid[{
				{"Field[Container[Model][Name]]", "Name of the Model of the Container"},
				{"Field[Model[{Name, Synonyms}]]", "Name and Synonyms of the Model"},
				{"Field[(Container..)[Materials]]", "The Materials of the Container found after a series of Container references"},
				{"Field[LocationLog[[All, 4]]]", "The fourth element of each LocationLog"},
				{"Field[LocationLog[[1;;5]]]", "The first 4 LocationLogs"}
			}]
		},
		Input :> {
			{"spec", _, "A sequence of SubValue and Part expressions."}
		},
		Output :> {
			{"spec", _, "A sequence of SubValue and Part expressions."}
		},
		SeeAlso -> {"Download", "Link", "Search", "Part"},
		Author -> {"platform", "thomas"}
	}];

(*GetNumOwnedObjects*)
DefineUsage[GetNumOwnedObjects,
	{
		BasicDefinitions -> {
			{"GetNumOwnedObjects[{financingTeams}]", "json", "returns a 'json' string representation of the list of associations containing team_id and object count."}
		},
		Input :> {
			{"financingTeams", {ObjectP[Object[Team, Financing]]..}, "The list of financing teams for which we need the find the count of owned objects."}
		},
		Output :> {
			{"json", _String, "A JSON string containing list of associations with team_id and object count."}
		},
		Sync -> Automatic,
		SeeAlso -> {"Download", "Search"},
		Author -> {
			"platform"
		}
	}];


(*TraceHistory*)
DefineUsage[TraceHistory,
	{
		BasicDefinitions -> {
			{"TraceHistory[]", "communicationHistory", "returns the record showing the communication history with the laboratory's database"}
		},
		Output :> {
			{"communicationHistory", {_Rule...}, "Return a list of rules showing {traceID, label}->timeOfExecution"}
		},
		SeeAlso -> {"Download", "Search"},
		Author -> {"axu", "dirk.schild", "weiran.wang", "thomas"}
	}];
(* ::Subsubsection::Closed:: *)