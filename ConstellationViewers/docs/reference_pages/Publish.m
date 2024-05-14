(* ::Subsubsection::Closed:: *)
(*Publish*)

(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[Publish, {
	BasicDefinitions -> {
		{"Publish[Notebook]", "URL", "publish a laboratory notebook and all of its contents publically within ECL and on the web."},
		{"Publish[NotebookPage]", "URL", "publish a notebook page publically within ECL and on the web."},
		{"Publish[Object]", "URL", "publish an object publically within ECL and on the web."}
	},
	MoreInformation -> {
		"A published object will appear in all searches and downloads by all users, but will not be editable by people outside the owning financing team."
	},
	Input :> {
		{"Notebook", ObjectP[Object[LaboratoryNotebook]], "The notebook to publish."},
		{"NotebookPage", ObjectP[Object[Notebook]], "The notebook page to publish.  This can be a normal notebook page, a script, or a function page."},
		{"Object", ObjectP[], "The object to publish."}
	},
	Output :> {
		{"URL", _URL, "The URL where the published object is available on the web."}
	},
	SeeAlso -> {
		"Unpublish",
		"Inspect",
		"Search",
		"Download"
	},
	Author -> {
		"platform"
	}
}];

DefineUsage[Unpublish, {
	BasicDefinitions -> {
		{"Unpublish[object]", "result", "unpublishes an object.  This will remove it from the web and make it so users of ECL who do not have access via sharing or financing team cannot see it."}
	},
	MoreInformation -> {
		"This will do nothing if the object was never published."
	},
	Input :> {
		{"object", ObjectP[], "The object to unpublish."}
	},
	Output :> {
		{"result", True|$Failed|$Cancelled, "Whether or not unpublishing suceeded."}
	},
	SeeAlso -> {
		"Publish",
		"Inspect",
		"Search",
		"Download"
	},
	Author -> {
		"platform"
	}
}];

DefineUsage[ConvertNotebookToPackageFile, {
	BasicDefinitions -> {
		{"ConvertNotebookToPackageFile[Notebook]", "PackageFileText", "convert the supplied notebook (either page, script, or function) into human readable plain text that can be written as a .m file."},
		{"ConvertNotebookToPackageFile[FilePath, AssetFile]", "PackageFileText", "convert the .nb file at the supplied file path into human readable plain text that can be written as a .m file.  The asset file should be the cloud file where the .nb file is stored for later retrieval and will not be downloaded as part of the conversion."}
	},
	MoreInformation -> {
		"The .m file text can we be written out to the file system via Export"
	},
	Input :> {
		{"Notebook", ObjectP[Object[Notebook]], "The notebook to convert."},
		{"FilePath", _String, "The file path of the .nb file to convert."},
		{"AssetFile", ObjectP[Object[EmeraldCloudFile]], "The emerald cloud file that the .nb file is stored in."}
	},
	Output :> {
		{"PackageFileText", _String, "Human readable version of the .nb file that is suitable for writing to a .m file."}
	},
	SeeAlso -> {
		"ConvertPackageFileToNotebook",
		"Publish"
	},
	Author -> {
		"platform"
	}
}];

DefineUsage[ConvertPackageFileToNotebook, {
	BasicDefinitions -> {
		{"ConvertPackageFileToNotebook[PackageFilePath]", "NotebookFilePath", "convert the supplied .m file to a .nb file."}
	},
	Input :> {
		{"PackageFilePath", _String, "The path to the .m file."}
	},
	Output :> {
		{"NotebookFilePath", _String, "The path to the generated .nb file."}
	},
	SeeAlso -> {
		"ConvertNotebookToPackageFile",
		"Publish"
	},
	Author -> {
		"platform"
	}
}];
