(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*LoadPackage*)


DefineUsage[LoadPackage,
	{
		BasicDefinitions->{
			{"LoadPackage[name]", "name", "loads the source code for the package given by 'name' and adds its context to the $ContextPath."}
		},
		MoreInformation->{
			"If the manifest for the package name has the \"deployed\" key set to true, will load the package from MX files.",
			"If the package is already loaded (it is listed in $Packages) does nothing but add the package context to the $ContextPath.",
			"If the package listed is not an ECL package (passed PackageQ) but is a Mathematica package, calls Needs on that package instead."
		},
		Input:>{
			{"name",_String,"Name of the package to be loaded."}
		},
		Output:>{
			{"name",_String,"Name of the package that was loaded."}
		},
		SeeAlso->{
			"$ContextPath",
			"Needs",
			"LoadDistro",
			"ReloadPackage",
			"NewPackage",
			"PackageQ",
			"PackageMetadata"
		},
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ReloadFile*)

DefineUsage[ReloadFile,
	{
		BasicDefinitions -> {
			{"ReloadFile[package, filepath]", "package", "reloads a file from the source code directory. For example: ReloadFile[\"Experiment`\",\"Centrifuge\\ExperimentNew.m\"]."}
		},
		Input :> {
			{"package", _String, "Name of a package, such as \"Experiment`\"."},
			{"filename", _String, "Path to the file to reload, starting with the sources directory of the package. For example, \"Centrifuge\\ExperimentNew.m\"."}
		},
		Output :> {
			{"package", _Association, "Name of the package that was specified."}
		},
		Author -> {
			"thomas"
		},
		SeeAlso -> {
			"ReloadPackage",
			"ReloadManifest",
			"LoadPackage"
		}
	}];

(* ::Subsubsection::Closed:: *)
(*AppendPackagePath*)

DefineUsage[AppendPackagePath,
	{
		BasicDefinitions->{
			{"AppendPackagePath[directory]", "packages", "adds all 'packages' in 'directory' to the search path for LoadPackage."}
		},
		MoreInformation->{
			"In order for ECL packages to be loaded (using LoadPackage), their manifests must be added to the search path using AppendPackagePath.",
			"AppendPackagePath recursively traverses the given directory, searching for manifest.json files.",
			"All manifests will be added to the list of available packages to be loaded using LoadPackage."
		},
		Input:>{
			{"directory",_String,"Directory to search for packages."}
		},
		Output:>{
			{"packages",{___String},"The list of package names that were found in the given directory."}
		},
		SeeAlso->{
			"AvailablePackages",
			"LoadPackage",
			"PackageMetadata"
		},
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*AvailablePackages*)

DefineUsage[AvailablePackages,
	{
		BasicDefinitions->{
			{"AvailablePackages[]", "packages", "returns the list of ECL 'packages' that can be loaded by LoadPackage."}
		},
		MoreInformation->{
			"AppendPackagePath must first be called to add packages the list of ones available to be loaded."
		},
		Output:>{
			{"packages",{___String},"The list of package names that can be loaded by LoadPackage."}
		},
		SeeAlso->{
			"AppendPackagePath",
			"LoadPackage",
			"PackageMetadata"
		},
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*FunctionPackage*)

DefineUsage[FunctionPackage,
	{
		BasicDefinitions->{
			{"FunctionPackage[symbol]", "package", "returns the 'package' the given 'symbol' is defined in."}
		},
		MoreInformation->{
			"A symbol may be exported from multiple packages. \
			FunctionPackage returns either the first package a symbol was exported from or \
			the first package to define DownValues for a given symbol."
		},
		Output:>{
			{"package",_String,"The package the symbol was defined in."}
		},
		Input:>{
			{"symbol",_Symbol,"Function to find package for."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageMetadata",
			"SymbolPackages"
		},
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*SymbolPackageName*)

DefineUsage[SymbolPackageName,
	{
		BasicDefinitions->{
			{"SymbolPackageName[symbol]", "package", "returns the package the given symbol is defined in."}
		},
		MoreInformation->{},
		Output:>{
			{"package",_String,"The package the symbol was defined in."}
		},
		Input:>{
			{"symbol",_Symbol,"The symbol to find package for."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*LoadUsage*)

DefineUsage[LoadUsage,
	{
		BasicDefinitions->{
			{"LoadUsage[]", "packages", "loads the usage for all loaded 'packages'."},
			{"LoadUsage[package]", "package", "loads the usage for the specific 'package'."}
		},
		MoreInformation->{
			"Loads all files in the docs/references_pages folder of the given package.",
			"The usage files should contain DefineUsage expressions which define \
			 the documentation for symbols in the package"
		},
		Output:>{
			{"packages",{__String},"The list of packages that usage files were loaded for."},
			{"package",_String,"The package usage was loaded for."}
		},
		Input:>{
			{"package",_String,"The package to load usage files for."}
		},
		SeeAlso->{
			"DefineUsage",
			"LoadPackage",
			"PackageMetadata",
			"SymbolPackages"
		},
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ReloadManifest*)

DefineUsage[ReloadManifest,
	{
		BasicDefinitions->{
			{"ReloadManifest[package]", "package", "loads the manifest.json for the specific 'package'."}
		},
		MoreInformation->{
			"Loads all the dependencies, source files and symbols of the given package."
		},
		Output:>{},
		Input:>{
			{"package",_String,"The name of the package to load the manifest.json for."}
		},
		SeeAlso->{
			"DefineUsage",
			"LoadPackage",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*SymbolPackages*)

DefineUsage[SymbolPackages,
	{
		BasicDefinitions->{
			{"SymbolPackages[name]", "package", "returns the package associated with the specified string name of a symbol."},
			{"SymbolPackages[symbol]", "package", "returns the package associated with the specified symbol."}
		},
		MoreInformation->{},
		Output:>{
			{"package", _String, "The package associated with the provided symbol."}
		},
		Input:>{
			{"name",_String,"The name of the symbol to search for."},
			{"symbol",_Symbol,"The name of the symbol to search for."}
		},
		SeeAlso->{
			"SymbolPackageName",
			"PackageSymbols"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*WritePackageMx*)

DefineUsage[WritePackageMx,
	{
		BasicDefinitions->{
			{"WritePackageMx[package]", "path", "creates a MX file for the given package to its package folder."}
		},
		MoreInformation->{},
		Output:>{
			{"path", _String, "The path where the MX file has been written to."}
		},
		Input:>{
			{"package",_String,"The name of the package to create the MX file for."}
		},
		SeeAlso->{
			"OnLoad",
			"PackageDirectory",
			"PackageMetadata"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageDirectory*)

DefineUsage[PackageDirectory,
	{
		BasicDefinitions->{
			{"PackageDirectory[package]", "directory", "returns the path to the package given by package if it exists."}
		},
		MoreInformation->{},
		Output:>{
			{"directory", _String, "The path to the package."}
		},
		Input:>{
			{"package", _String, "The name of the package to check."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageDocumentationDirectory",
			"PackageFunctions"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageFunctions*)

DefineUsage[PackageFunctions,
	{
		BasicDefinitions->{
			{"PackageFunctions[package]", "functions", "returns the list of functions available for a given package."}
		},
		MoreInformation->{},
		Output:>{
			{"functions", {_Symbol..}, "The list of functions available."}
		},
		Input:>{
			{"package", _String, "The name of the package to check."}
		},
		SeeAlso->{
			"PackageSymbols",
			"PackageGraph"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageSymbols*)

DefineUsage[PackageSymbols,
	{
		BasicDefinitions->{
			{"PackageSymbols[package]", "symbols", "returns the list of functions available for a given package."}
		},
		MoreInformation->{},
		Output:>{
			{"symbols", {_Symbol..}, "The list of symbols available."}
		},
		Input:>{
			{"package", _String, "The name of the package to check."}
		},
		SeeAlso->{
			"PackageFunctions",
			"PackageGraph"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*ReloadPackage*)

DefineUsage[ReloadPackage,
	{
		BasicDefinitions->{
			{"ReloadPackage[package]", "", "reloads a given package."}
		},
		MoreInformation->{
			"Internally calls removePackage, AppendPackagePath, LoadPackage, and LoadUsage."
		},
		Output:>{},
		Input:>{
			{"package", _String, "The name of the package to reload."}
		},
		SeeAlso->{
			"AppendPackagePath",
			"LoadPackage",
			"LoadUsage"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageGraph*)

DefineUsage[PackageGraph,
	{
		BasicDefinitions->{
			{"PackageGraph[packages]", "graph", "returns the graph of dependencies for a given package."}
		},
		MoreInformation->{},
		Output:>{
			{"graph", _Graph, "A graphical representation of the dependencies."}
		},
		Input:>{
			{"packages", {___String}, "The name of the list of packages to retrieve the dependencies of."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageMetadata",
			"PackageFunctions"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackagesGraph*)

DefineUsage[PackagesGraph,
	{
		BasicDefinitions->{
			{"PackagesGraph[]", "graph", "returns the graph of dependencies for all packages."}
		},
		MoreInformation->{},
		Output:>{
			{"graph", _Graph, "A graphical representation of all package dependencies."}
		},
		Input:>{},
		SeeAlso->{
			"LoadPackage",
			"PackageMetadata",
			"PackageGraph"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageMetadata*)

DefineUsage[PackageMetadata,
	{
		BasicDefinitions->{
			{"PackageMetadata[package]", "association", "returns information found in the package's manifest.json file for a given package
			Context that the framework knows about."}
		},
		MoreInformation->{},
		Output:>{
			{"association", _Association, "An association form of the manifest.json file."}
		},
		Input:>{
			{"package", _String, "The name of package to retrieve the manifest.json file."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageFunctions",
			"PackageGraph"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageQ*)

DefineUsage[PackageQ,
	{
		BasicDefinitions->{
			{"PackageQ[package]", "exists", "returns true if a package exists."}
		},
		MoreInformation->{},
		Output:>{
			{"exists", BooleanP, "Boolean representing whether a package exists."}
		},
		Input:>{
			{"package", _String, "The name of package to check."}
		},
		SeeAlso->{
			"LoadPackage",
			"PackageMetadata"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageDocumentationDirectory*)

DefineUsage[PackageDocumentationDirectory,
	{
		BasicDefinitions->{
			{"PackageDocumentationDirectory[function]", "path", "returns the path to the ReferencePages of a given symbol."},
			{"PackageDocumentationDirectory[package]", "path", "returns the path to the English documents, tutorials and guides of a given package."},
			{"PackageDocumentationDirectory[package,kind]", "path", "returns the path to the specified documentation type of given by package."}
		},
		MoreInformation->{},
		Output:>{
			{"path", _String, "The path to the documentation."}
		},
		Input:>{
			{"function", _Symbol, "The name of the function to retrieve the ReferencePages for."},
			{"package", _String, "The name of the package to retrieve the documentation for."},
			{"kind", DocumentationKindP, "The type of documentation to retrieve."}
		},
		SeeAlso->{
			"PackageDirectory",
			"PackageFunctions",
			"PackageSources"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackageSources*)

DefineUsage[PackageSources,
	{
		BasicDefinitions->{
			{"PackageSources[metadata]", "list", "returns the location of all sources files for a given metadata (loaded manifest.json)."}
		},
		MoreInformation->{},
		Output:>{
			{"list", {_String..}, "The list of paths to all source files."}
		},
		Input:>{
			{"metadata", _Association, "An association format of a package's manifest.json."}
		},
		SeeAlso->{
			"PackageDirectory",
			"PackageFunctions"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*PackagesRootDirectories*)

DefineUsage[PackagesRootDirectories,
	{
		BasicDefinitions->{
			{"PackagesRootDirectories[]", "list", "returns the location of SLL directory."}
		},
		MoreInformation->{},
		Output:>{
			{"list", {_String..}, "The list of paths to the root SLL directory."}
		},
		Input:>{},
		SeeAlso->{
			"PackageSources",
			"PackageDirectory",
			"PackageFunctions"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*OnLoad*)

DefineUsage[OnLoad,
	{
		BasicDefinitions->{
			{"OnLoad[expression]", "", "adds to the list of expressions stored in onLoadExpressions to be evaluated when a package is loaded."}
		},
		MoreInformation->{
			"OnLoad has a HoldFirst attribute which prevents the expression to be evaluated until LoadPackage is called."
		},
		Output:>{},
		Input:>{
			{"expression", _, "Any expression to be loaded."}
		},
		SeeAlso->{
			"LoadDistro",
			"LoadPackage"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*NewPackage*)

DefineUsage[NewPackage,
	{
		BasicDefinitions->{
			{"NewPackage[folder, package]", "rootDirectory", "create a new package with the provided name inside the provided folder path."},
			{"NewPackage[folder, attributes]", "rootDirectory", "create a new package with the provided attributes inside the provided folder path."}
		},
		MoreInformation->{
			"Creates a new package folder with the expected directory structure and an empty manifest file with a given name."
		},
		Output:>{
			{"rootDirectory", _String, "The path to the created directory."}
		},
		Input:>{
			{"folder",_String,"The name of the folder to create the new package."},
			{"package",_String,"The name of the new package to be created."},
			{"attributes",_Association,"The metadata required for the manifest.json file."}
		},
		SeeAlso->{
			"DistroMetadata",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];


(* ::Subsubsection::Closed:: *)
(*LoadDistro*)

DefineUsage[LoadDistro,
	{
		BasicDefinitions->{
			{"LoadDistro[configFile]", "package", "loads the JSON configuration file for a built distro."}
		},
		MoreInformation->{
			"Loads all information associated with a built distro including the name, which Wolfram versions are supported, and
			 the public and hidden packages."
		},
		Output:>{
			{"config", _Association, "The association including the name, which Wolfram versions are supported, and
			 the public and hidden packages which have been loaded."}
		},
		Input:>{
			{"configFile",_String,"The path to the distro configuration file to be loaded."}
		},
		SeeAlso->{
			"DistroMetadata",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*DistroMetadata*)

DefineUsage[DistroMetadata,
	{
		BasicDefinitions->{
			{"DistroMetadata[configFile]", "package", "reads the JSON configuration file for a built distro."}
		},
		MoreInformation->{},
		Output:>{
			{"rules", _Association, "The association equivalent of the JSON file."}
		},
		Input:>{
			{"configFile",_String,"The path to the distro configuration file to be read."}
		},
		SeeAlso->{
			"LoadDistro",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];

(* ::Subsubsection::Closed:: *)
(*DirectoryPackage*)

DefineUsage[DirectoryPackage,
	{
		BasicDefinitions->{
			{"DirectoryPackage[filePath]", "package", "Returns the package which directory contains the given file path"}
		},
		MoreInformation->{},
		Output:>{
			{"package", _Association, "The package contains the file path."}
		},
		Input:>{
			{"filePath",_String,"The full file path in the SLL."}
		},
		SeeAlso->{
			"LoadDistro",
			"PackageMetadata",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"platform"},
		Tutorials->{"packager"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ListPacletVersions*)

DefineUsage[ListPacletVersions,
	{
		BasicDefinitions->{
			{"ListPacletVersions[pacletName]", "associations", "Returns a list of associations showing {Version,MathematicaVersion,Location} of the specified Paclet or all Paclets."}
		},
		MoreInformation->{},
		Output:>{
			{"associations", {_Association..}, "The list of associations contains contains Version,MathematicaVersion,Location of the specified Paclet or all Paclets."}
		},
		Input:>{
			{"pacletName",_String,"The name of the Paclet in string format."}
		},
		SeeAlso->{
			"LoadDistro",
			"DirectoryPackage",
			"SymbolPackages"
		},
		TestsRequired->False,
		Author->{"weiran"}
	}
];

(* ::Subsubsection::Closed:: *)
(*KernelVersionMatchQ*)

DefineUsage[KernelVersionMatchQ,
	{
		BasicDefinitions->{
			{"KernelVersionMatchQ[version]", "boolean", "check whether or not 'version' matches the current Wolfram Mathematica version."}
		},
		MoreInformation->{},
		Output:>{
			{"boolean", BooleanP, "A boolean to indicate whether or not 'version' matches the current Wolfram Mathematica version."}
		},
		Input:>{
			{"version",_String,"The version number in string format."}
		},
		SeeAlso->{
			"NewPackage",
			"ListPacletVersions",
			"LoadDistro"
		},
		Author->{"weiran"}
	}
];