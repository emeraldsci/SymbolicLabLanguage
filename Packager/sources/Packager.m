(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


BeginPackage["Packager`"];


Needs["JSONTools`"];
Needs["PacletManager`"];

$AllowDataUpdates=False;

NewPackage;
AppendPackagePath;
PackageMetadata;
PackageDirectory;
DirectoryPackage;
PackageDocumentationDirectory;
PackageQ;
KernelVersionMatchQ;
ListPacletVersions;
IncludeContexts;
SearchRemote;
LoadPackage;
ReloadFile;
ReloadPackage;
OnLoad;
FunctionPackage;
SymbolPackageName;
AvailablePackages;
PackageGraph;
PackageSymbols;
SymbolPackages;
PackageFunctions;
PackageSources;
PackagesRootDirectories;
PackagesGraph;
LoadUsage;
DistroMetadata;
LoadDistro;
ReloadManifest;
$ForcePacletVersions;

WritePackageMx;

$DebugLoading;
$DebugLoadingThreshold;

$FastLoad;
$LoadLog;
$LogPacletChanges;
$LoadTimings;
$LoadMetadata;

$FastGit;

(* If $AllowPublicObjects is set to False, every new object must be linked to a notebook *)
$AllowPublicObjects=False;
Protect[$AllowPublicObjects];

Begin["`Private`"];

If[Not[ValueQ[$DebugLoading]],
	$DebugLoading = False;
];

If[Not[ValueQ[$DebugLoadingThreshold]],
	$DebugLoadingThreshold = 0.01;
];

KernelVersionMatchQ[prefix_]:=Module[
	{foundVersion},

	foundVersion = StringTake[$Version, 6];

	StringStartsQ[foundVersion, prefix]
];

(*Creates a new package folder with the expected directory structure
and an empty manifest file with a given name.*)
NewPackage::FolderMissing="`1` does not exist, cannot create a new package in this directory.";
NewPackage::PackageExists="`1` already exists in `2`.";
NewPackage::Package="No package name specified.";

ECL`Authors[NewPackage] := {"platform"};

NewPackage[folder_String, package_String] := NewPackage[
	folder,
	Association[
		"Package"->package
	]
];
NewPackage[folder_String, attributes_Association] := Module[
	{json,rootDirectory,package},

	(*Return if the given directory does not exist*)
	If[!DirectoryQ[folder],
		Message[NewPackage::FolderMissing, folder];
		Return[$Failed]
	];

	package = Lookup[attributes,"Package"];
	If[Not[MatchQ[package,_String]],
		Message[NewPackage::Package];
		Return[$Failed]
	];

	(*Return if a folder already exists with the package name*)
	rootDirectory = FileNameJoin[{folder, StringReplace[package,"`"->""]}];
	If[DirectoryQ[rootDirectory],
		Message[NewPackage::PackageExists, package, folder];
		Return[$Failed];
	];

	CreateDirectory[rootDirectory];

	(*JSON metadata for the manifest file.*)
	json = ToJSON[{
	 "context" -> Lookup[attributes,"Context","ECL`"],
	 "description" -> Lookup[attributes,"Description","Description of the package goes here."],
	 "dependencies" -> Lookup[attributes,"Dependencies",{}],
	 "sources" -> Lookup[attributes,"Sources",{}],
	 "symbols" -> Lookup[attributes,"Symbols",{}],
	 "legacySymbols" -> Lookup[attributes,"LegacySymbols",{}],
	 "conflictSymbols" -> Lookup[attributes,"ConflictSymbols",{}]
	 }];

	(*Generate manifest.json file*)
	Export[FileNameJoin[{rootDirectory, "manifest.json"}], json, "Text"];

	(*Create all expected sub-directories*)
	CreateDirectory[FileNameJoin[{rootDirectory, "tests"}]];
	CreateDirectory[FileNameJoin[{rootDirectory, "docs", "tutorials"}], CreateIntermediateDirectories -> True];
	CreateDirectory[FileNameJoin[{rootDirectory, "docs", "guides"}], CreateIntermediateDirectories -> True];
	CreateDirectory[FileNameJoin[{rootDirectory, "docs", "reference_pages"}], CreateIntermediateDirectories -> True];
	CreateDirectory[FileNameJoin[{rootDirectory, "sources"}]];
	CreateDirectory[FileNameJoin[{rootDirectory, "resources"}]];
	CreateDirectory[FileNameJoin[{rootDirectory, "FrontEnd", "StyleSheets"}], CreateIntermediateDirectories -> True];

	(*Return the path to the created directory*)
	rootDirectory
];

(*Add a path to the package search path. Parses all manifest.json files which are found
in any sub-directories of the given path and caches their metadata in the packageMetadata associaton.*)
AppendPackagePath::Directory = "`1` is not a directory.";

AppendPackagePath[path_String]:=Module[
	{manifestFiles,associations},

	(*If given path is not a directory, return $Failed*)
	If[!DirectoryQ[path],
		Message[AppendPackagePath::Directory, path];
		Return[$Failed]
	];

	manifestFiles = FileNames[
		"manifest.json",
		path,
		Infinity
	];

	(*Parse all manifest files to associations*)
	associations = Map[
		manifestFileToAssociation,
		manifestFiles
	];

	(* Load symbols from an external symbols file if they exist. *)
	associations = Map[
		Append[
			#,
			{
				"CombinedSymbols"->loadCombinedSymbols[#],
				"Name"->StringReplace[Lookup[#,"Package"],"`"->""]
			}
		]&,
		associations
	];

	(*Add entries for all found packages to the packageMetadata association
	with their packages as keys*)
	AssociateTo[
		packageMetadata,
		Map[
			Rule[
				Lookup[#,"Package"],
				#
			]&,
			associations
		]
	];

	(*Return a list of the newly added contexts*)
	associations[[All,"Package"]]
];


(*Convert a manifest file to JSON and add a key for the directory
where that file was found. Converts all lowercase JSON keys to
capitalized strings.*)
manifestFileToAssociation[path_String]:=Association[
	KeyValueMap[
		Function[{key,value},
			Capitalize[key]->If[key==="sources",
				Flatten[Map[expandSourceEntry[DirectoryName[path], #]&, value]],
				value
			]
		],
		Apply[
			Association,
			Join[
				Import[
					path,
					"JSON"
				],
				{
					"directory" -> DirectoryName[path],
					"package" -> FileBaseName[FileNameDrop[path]] <> "`"
				}
			]
		]
	]
];

expandSourceEntry[packagePath_String, sourceEntry_String]:=Module[
	{sourcesPath, fullFilePath},
	sourcesPath=FileNameJoin[{packagePath, "sources"}];
	fullFilePath=FileNameJoin[{sourcesPath, sourceEntry}];

	(* if the source entry is a directory, expand out the .m files under that directory. *)
	SortBy[Map[
		StringReplace[#, (sourcesPath<>$PathnameSeparator)->""]&,

		If[!DirectoryQ[fullFilePath],
			{fullFilePath},
			FileNames[FileNameJoin[{fullFilePath, "*.m"}]]
		]
	],
	StringCount[#, "."] &
	]
];

loadCombinedSymbols[metadata_Association]:=Module[
	{},
	DeleteDuplicates[
		Join[
			Lookup[metadata,"Symbols",{}],
			If[$VersionNumber<12,
				(* symbols we don't need to define after 11.3 *)
				Lookup[metadata,"LegacySymbols",{}],
				(* otherwise... *)
				{}
			],

			If[$VersionNumber<12.2,
				(* symbols that collide with new symbols in 12.2 *)
				Lookup[metadata,"ConflictSymbols",{}],
				(* otherwise... *)
				{}
			],

			If[$VersionNumber<13.1,
				(* symbols we don't need to define after 13.1 *)
				Lookup[metadata,"Mathematica13.1ConflictSymbols",{}],
				(* otherwise... *)
				{}
			],

			If[$VersionNumber>=13.2,
				(* symbols we NEED to define after 13.2 because they're no longer exported *)
				Lookup[metadata,"Mathematica13.2AdditionalSymbols",{}],
				(* otherwise... *)
				{}
			]
		]
	]
];

(*Association from Context -> metadata association for all known packages*)
packageMetadata = Association[];

(*Returns an association of information found in the package's manifest.json file
for a given package Context that the framework knows about (has been found by using AppendPackagePath)*)
PackageMetadata::NotFound="The package `1` could not be found. Ensure it is on the search path by using AppendPackagePath.";

ECL`Authors[PackageMetadata] := {"platform"};

PackageMetadata[package_String]:=Module[
	{association},

	association = Lookup[
		packageMetadata,
		package,
		$Failed
	];

	If[association === $Failed,
		Message[PackageMetadata::NotFound, package]
	];

	association
];

(*Returns the path to the package given by package if it exists*)
PackageDirectory::NotFound="The package `1` could not be found. Ensure it is on the search path by using AppendPackagePath.";

ECL`Authors[PackageDirectory] := {"platform"};

PackageDirectory[package_String]:=With[
	{metadata=Lookup[packageMetadata,package,$Failed]},

	If[metadata === $Failed,
		Message[PackageDirectory::NotFound,package];
		Return[$Failed]
	];

	Lookup[
		metadata,
		"Directory"
	]
];

ECL`Authors[PackageQ] := {"platform"};

PackageQ[package_String]:=KeyExistsQ[
	packageMetadata,
	package
];


(*Returns the package which directory contains the given file path*)

Authors[DirectoryPackage]:={"platform"};

DirectoryPackage[path_String]:=Module[
	{matchingPackages},

	matchingPackages = Select[
		packageMetadata,
		StringMatchQ[
			path,
			#Directory ~~ ___
		]&
	];

	If[MatchQ[matchingPackages,Association[]],
		$Failed,
		First[Keys[matchingPackages]]
	]
];

ECL`Authors[PackageDocumentationDirectory] := {"platform"};

DocumentationKindP="ReferencePages"|"Index"|"SpellIndex"|"Guides"|"Tutorials"|Null;
PackageDocumentationDirectory[function_Symbol]:=PackageDocumentationDirectory[FunctionPackage[function], "ReferencePages"];
PackageDocumentationDirectory[package_String]:=PackageDocumentationDirectory[package, Null];
PackageDocumentationDirectory[package_String, kind:DocumentationKindP]:=With[
	{
		packageDir=PackageDirectory[package],
		lastDirectory=Switch[kind,
			"ReferencePages",
				{"ReferencePages","Symbols"},
			Null,
				Nothing,
			_,
				{kind}
		]
	},
	If[packageDir===$Failed,
		$Failed,
		FileNameJoin[Flatten[{packageDir, "Documentation", "English", lastDirectory}]]
	]
];

missingSymbols=Association[];

(*Attempts to load the definitions for a package with the given context.
If a package is not found, call Needs on the context instead.
This way LoadPackage can be used to load ALL dependencies.*)
LoadPackage::NotFound="The package `1` could not be found. Ensure it is on the search path by using AppendPackagePath.";
LoadPackage::NewSymbol="Symbol `1` was created in the private context for `2`";
LoadPackage::Values="Symbols `1` are not defined in package `2` but had values assigned after package was loaded.";
LoadPackage::Context="Unable to load package `3`: symbols `1` are already defined in a different context than `2`.";
LoadPackage::MXFailed="Unable to load package: `1` from MX file: `2`";

LoadPackage[package_String]:=Module[
	{metadata, directory, context, mxPath, timing, previousValueQ,
	loadFromMx, mxLoadSuccess},

	(* 
		these values are initialized in LoadDistro, but packages can be loaded without going through LoadDistro,
		so also initializing here if necessary.
		(not only initializing here because we want to reset it if LoadDistro is called)
	*)
	If[Not[ValueQ[tOnLoadRelease]],
		initializeTimers[];
	];

	(*If Package has already been loaded, do nothing and return the package*)
	If[MemberQ[$Packages,package],
		$ContextPath = If[PackageQ[package],
			With[
				{md = PackageMetadata[package]},
				DeleteDuplicates[
					Prepend[$ContextPath,md["Context"]]
				]
			],
			DeleteDuplicates[Prepend[$ContextPath,package]]
		];

		Return[package];
	];

	(*If a package cannot be found for the given context,
	call Needs on the context instead*)
	If[!PackageQ[package],
		If[TrueQ[$DebugLoading],
			Return[Needs[package]],
			Quiet[
				Return[Needs[package]],
				{General::shdw}
			]
		]
	];

	(*Get the metadata for the package and its directory*)
	metadata = PackageMetadata[package];
	context = metadata["Context"];
	directory = Lookup[metadata, "Directory"];
	mxPath = FileNameJoin[{directory,"package.mx"}];

	(*Reset context path while loading to be only System` and the given context*)
	Block[{$ContextPath,$Package},
		$ContextPath = {"System`",context};
		(*Used by OnLoad to associate expressions to be executed with the loading package*)
		$Package = package;
		loadFromMx = Lookup[metadata,"Deployed",False];

		(*Load all definitions in the private context*)
		Begin[package<>"Private`"];

		(*Load all dependencies in the manifest*)
		Scan[
			LoadPackage,
			Lookup[metadata,"Dependencies"]
		];

		(*Define all the symbols in the manifest inside the public context*)
		Block[{$Context=context},
			With[
				{
					outOfContextSymbols=Select[
						metadata["CombinedSymbols"],
						Quiet[
							Check[
								Context[#]=!=context,
								False
							]
						]&
					]
				},

				If[Length[outOfContextSymbols]>0,
					Message[LoadPackage::Context,outOfContextSymbols,context,package];
					Abort[]
				];

				(* use hasValueQ to define (manifest) symbol exports in this context *)
				{timing, previousValueQ} = AbsoluteTiming[
					AssociationMap[
						hasValueQ,
						If[TrueQ[$DebugLoading],
							Join[Names[context<>"*"],metadata["CombinedSymbols"]],
							metadata["CombinedSymbols"]
						]
					]
				]
			];
			debugLoadPrint[package, "Defined Symbols:", timing];
		];
		tMakeSymbols += timing;

		If[loadFromMx,
			(
				(*Load MX file *)
				{timing, mxLoadSuccess} = AbsoluteTiming[
					Quiet[
						Check[
							MatchQ[Get[mxPath], Null],
							False,
							{DumpGet::bgcor,Get::noopen}
						],
						{DumpGet::bgcor,Get::noopen}
					]
				];
				If[mxLoadSuccess,
					debugLoadPrint[package, "Loaded from MX file:", timing],
					Message[LoadPackage::MXFailed, package, mxPath];
					Return[$Failed]
				];
			),
			(
				(*Load source files *)
				Block[{$NewSymbol},
					$NewSymbol=printSymbolWarning[package];
					packagePackage = package;
					{timing, ignoreMe} = AbsoluteTiming[
						Scan[(
								packageFile = #;
								Get[FileNameJoin[{directory,"sources",#}]]
							)&,
							Lookup[metadata,"Sources"]
						];
						packageFile = Null;
						packagePackage = Null;
					]
				];
				debugLoadPrint[package, "Loaded source files:", timing];
			)
		];
		tLoadFiles += timing;

		(* Set SymbolPackages & FunctionPackage for all symbols *)
		tSetPackage += First[AbsoluteTiming[
			Scan[
				setPackage[#,package,previousValueQ[#]]&,
				metadata["CombinedSymbols"]
			];
		]];

		If[TrueQ[$DebugLoading],
			With[
				{
					nonPackageDownValues=Select[
						Complement[Names[context<>"*"],metadata["CombinedSymbols"]],
						And[
							hasValueQ[#],
							Not[previousValueQ[#]]
						]&
					]
				},
				If[Length[nonPackageDownValues]>0,
					Message[LoadPackage::Values,nonPackageDownValues,package]
				]
			]
		];

		(*Evaluate all expressions set up by OnLoad.
		If loading from an MX file these expressions are stored
		in packagerOnLoadExpressions in the private context.*)
		{timing, ignoreMe} = AbsoluteTiming[If[loadFromMx,
			ReleaseHold[
				Symbol[StringJoin[package,"Private`","packagerOnLoadExpressions"]]
			];,
			ReleaseHold[
				Lookup[onLoadExpressions, package, {}]
			];
		];];
		tOnLoadRelease += timing;
		debugLoadPrint[package, "Executing OnLoad Expressions:", timing];

		(*Reset the $Context back to what it was before LoadPackage*)
		End[];
	];
	(*Append the given context to the $ContextPath and $Packages*)
	$ContextPath = DeleteDuplicates[Prepend[$ContextPath,context]];
	Unprotect[$Packages];
	$Packages = Union[$Packages,{package}];
	Protect[$Packages];

	If[!loadFromMx,
		writePacletInfo[metadata];
	];

	tPacletDirectoryAdd += First[AbsoluteTiming[
		If[KernelVersionMatchQ["12.0"],
			PacletDirectoryAdd[metadata["Directory"]],
			PacletDirectoryLoad[metadata["Directory"]]
		];
	]];

	(*Return the loaded package*)
	package
];

printSymbolWarning[package_String]:=With[
	{privateContext=package<>"Private`"},

	If[TrueQ[$DebugLoading],
		Function[{name,context},
			If[And[UpperCaseQ[StringTake[name,1]],context===privateContext],
				AppendTo[
					missingSymbols,
					package->Append[Lookup[missingSymbols,package,{}],name]
				];
				Message[LoadPackage::NewSymbol,name,package]
			]
		]
	]
];

debugLoadPrint[package_String, text_String, timing_Real]:=If[And[$DebugLoading, timing>$DebugLoadingThreshold],
	Print["["<>package<>"] ", text, " ", timing];
];

doNotDefineSymbols:={"Test","TestRun", "ErrorMessage" };

setPackage[symbolName_String,package_String,previousValueQ:True|False]:=Apply[
	setPackage,
	Append[
		Append[
			Quiet[
				MakeExpression[symbolName,StandardForm],
				{General::shdw}
			],
			package
		],
		previousValueQ
	]
];
setPackage[symbol_Symbol,package_String,previousValueQ:True|False]:=With[
	{
		protectedQ=MemberQ[Attributes[symbol],Protected],
		valueQ=hasValueQ[symbol]
	},

	(*If this is the first creation of this symbol or
	it has newly set Down/OwnValues set its function package*)
	If[
		Or[
			!MatchQ[FunctionPackage[symbol],_String],
			And[hasValueQ[symbol],Not[previousValueQ]]
		],
		(
			If[protectedQ,
				Unprotect[symbol]
			];
			FunctionPackage[symbol]^=package;
			If[protectedQ,
				Protect[symbol]
			];
		)
	]
];

hasValueQ[symbolName_String]:=Apply[
	hasValueQ,
	Quiet[
		MakeExpression[symbolName,StandardForm],
		{General::shdw}
	]
];
hasValueQ[symbol_Symbol]:=Or[
	Length[DownValues[symbol]]>0,
	Length[OwnValues[symbol]]>0
];

ECL`Authors[ReloadManifest] := {"platform"};

ReloadManifest[package_String]:=Module[{metadata,context,directory,mxPath,loadFromMx,timing, previousValueQ},
	(* Remove the loading of the manifest.json file. *)
	AppendPackagePath[PackageDirectory[package]];

	(*Get the metadata for the package and its directory*)
	metadata = PackageMetadata[package];
	context = metadata["Context"];
	directory = Lookup[metadata, "Directory"];
	mxPath = FileNameJoin[{directory,"package.mx"}];

	(*Reset context path while loading to be only System` and the given context*)
	Block[{$ContextPath,$Package},
		$ContextPath = {"System`",context};
		(*Used by OnLoad to associate expressions to be executed with the loading package*)
		$Package = package;
	
		loadFromMx = Lookup[metadata,"Deployed",False];

		(*Load all definitions in the private context*)
		Begin[context];

		With[{symbol=ToExpression[#]},
			If[!(hasValueQ[#]),
				FunctionPackage[symbol]^=package
			];
		]&/@metadata["CombinedSymbols"];

		(* Reset the context back to what it was before LoadPackage*)
		End[];
	];
];


(* Developer function - does not do any error checking, reloading of dependencies, or clearing of Up/Down/OwnValues in the package. $DebugLoading is not supported. MX Loading is also not supported. *)
(* Assumes that you've ALREADY loaded the package that this file exists in. *)
(* Simply overwrites values with the correct context path for a given file. *)
(* assuming if you only give one input, we're in the Experiment package because that's where this is used most frequently *)
ReloadFile[fileName_String]:=ReloadFile["Experiment`", fileName];
ReloadFile[package_String,fileName_String]:=Module[
	{metadata, directory, context, mxPath, timing, previousValueQ,
	loadFromMx, mxLoadSuccess},
	(* Reload the manifest first. *)
	ReloadManifest[package];

	(*Get the metadata for the package and its directory*)
	metadata = PackageMetadata[package];
	context = metadata["Context"];
	directory = Lookup[metadata, "Directory"];
	mxPath = FileNameJoin[{directory,"package.mx"}];

	(* If we are profiling, first re-generate the file from regular SLL into the profiling directory. *)
	If[MatchQ[ECL`$Profiling, True],
		Instrumentation`Profile`Private`generate[
			FileNameJoin[{$HomeDirectory, "SLL", StringTake[package, 1;;-2], "sources", fileName}],
			FileNameJoin[{$HomeDirectory, "SLL"}],
			FileNameJoin[{$HomeDirectory, "SLL_profiling", "SLL"}]
		]
	];

	(*Reset context path while loading to be only System` and the given context*)
	Block[{$ContextPath,$Package},
		$ContextPath = {"System`",context};
		(*Used by OnLoad to associate expressions to be executed with the loading package*)
		$Package = package;

		(*Load all definitions in the private context*)
		Begin[package<>"Private`"];

		(*Load all dependencies in the manifest*)
		Scan[
			LoadPackage,
			Lookup[metadata,"Dependencies"]
		];

		(*Define all the symbols in the manifest inside the public context*)
		Block[{$Context=context},
			With[
				{
					outOfContextSymbols=Select[
						metadata["CombinedSymbols"],
						Quiet[
							Check[
								Context[#]=!=context,
								False
							]
						]&
					]
				},

				If[Length[outOfContextSymbols]>0,
					Message[LoadPackage::Context,outOfContextSymbols,context,package];
					Abort[]
				];

				{timing, previousValueQ} = AbsoluteTiming[
					AssociationMap[
						hasValueQ,
						If[TrueQ[$DebugLoading],
							Join[Names[context<>"*"],metadata["CombinedSymbols"]],
							metadata["CombinedSymbols"]
						]
					]
				]
			];
			debugLoadPrint[package, "Defining Symbols:", timing];
		];

		(*Load source files *)
		Block[{$NewSymbol},
			$NewSymbol=printSymbolWarning[package];

			Get[FileNameJoin[{directory,"sources",fileName}]]
		];

		(* Set SymbolPackages & FunctionPackage for all symbols *)
		Scan[
			setPackage[#,package,previousValueQ[#]]&,
			metadata["CombinedSymbols"]
		];

		(*Evaluate all expressions set up by OnLoad.
		If loading from an MX file these expressions are stored
		in packagerOnLoadExpressions in the private context.*)
		ReleaseHold[
				Lookup[onLoadExpressions, package, {}]
		];

		(*Reset the $Context back to what it was before LoadPackage*)
		End[];
	];

	(*Return the loaded package*)
	package
];


SetAttributes[hasValueQ,HoldFirst];
SetAttributes[setPackage,HoldFirst];

ECL`Authors[WritePackageMx] := {"platform"};

(*Write the MX file for the given package to its package folder*)
WritePackageMx[package_String]:=Module[
	{path, privateContext, symbols, metadata, originalContextPath},

	(*Save OnLoad expressions to symbol in private context for package
	so that it will be saved in the MX file*)
	With[
		{
			expressions=Lookup[onLoadExpressions,package,{}],
			heldSymbol=MakeExpression[StringJoin[package,"Private`","packagerOnLoadExpressions"],StandardForm]
		},

		(*If package was loaded from an MX file already,
		do not need to re-assign symbol as expressions will be empty*)
		If[!Apply[ValueQ,heldSymbol],
			Apply[
				Set,
				Append[heldSymbol,expressions]
			]
		]
	];

	path = FileNameJoin[{PackageDirectory[package], "package.mx"}];
	privateContext = package <> "Private`";
	metadata = PackageMetadata[package];
	symbols = metadata["CombinedSymbols"];
	originalContextPath = $ContextPath;

	Block[
		(* even if our symbols are in a hidden context, temporarily prepend that context so we can dump them *)
		{$ContextPath = DeleteDuplicates[Prepend[originalContextPath, Lookup[PackageMetadata[package], "Context"]]], ECL`$SessionUUID},

		(* Make sure that $SessionUUID isn't initialized. *)
		ECL`$SessionUUID := ECL`$SessionUUID = CreateUUID[];

		With[{toDump = Append[symbols, privateContext]},
			(*DumpSave all public symbols for the package and its private context*)
			DumpSave[path, toDump]
		]
	];

	path
];

writePacletInfo[metadata_Association]:=Module[
	{package, name, directory, infoFile},

	package=Lookup[metadata,"Package"];
	name=Lookup[metadata,"Name"];
	directory=Lookup[metadata,"Directory"];

	infoFile = FileNameJoin@{directory,"PacletInfo.m"};

	Export[infoFile, pacletString[package, name], "Text"]
];

pacletString[package_String, name_String]:=StringJoin[
	Riffle[
		{
			"Paclet[",
			"  Name -> \"" <> name <> "\",",
			"  Version -> \"0.1.0\",",
			"  MathematicaVersion -> \"11+\",",
			"  Extensions -> {",
			"    {\"Documentation\", Language -> \"English\"},",
			"    {\"Kernel\", Context -> \"" <> package <> "\"},",
			"    {FrontEnd}",
			"  }",
			"]"
		},
		"\n"
	]
];
ECL`Authors[ReloadPackage] := {"platform"};

ReloadPackage[package_String]:=With[
	{},
	(*If a package cannot be found for the given context,
	do nothing*)
	If[!PackageQ[package],
		Return[$Failed]
	];

	(* If we are profiling, first re-generate the file from regular SLL into the profiling directory. *)
	If[MatchQ[ECL`$Profiling, True],
		(
			Quiet@Instrumentation`Profile`Private`generate[
				#,
				FileNameJoin[{$HomeDirectory, "SLL"}],
				FileNameJoin[{$HomeDirectory, "SLL_profiling", "SLL"}]
			]
		&)/@FileNames["*", FileNameJoin[{$HomeDirectory, "SLL", StringTake[package, 1;;-2]}], Infinity]
	];

	removePackage[package];

	AppendPackagePath[PackageDirectory[package]];
	LoadPackage[package];
	LoadUsage[package];
];

removePackage[package_String]:=Module[
	{metadata=PackageMetadata[package]},

	Block[{$Context=metadata["Context"]},
		Scan[
			Function[symbolName,
				Unprotect[symbolName];
				ClearAll[symbolName];
			],
			(*All private symbols and public functions in this package*)
			Join[
				Select[
					Names[metadata["Context"]<>"*"],
					FunctionPackage[#]===package&
				],
				Names[package<>"Private`*"]
			]
		]
	];

	Unprotect[$Packages];
	$Packages = DeleteCases[$Packages, package];
	Protect[$Packages];

	$ContextPath = DeleteCases[$ContextPath, package];
];

onLoadExpressions = Association[];

SetAttributes[OnLoad, HoldFirst];

ECL`Authors[OnLoad] := {"platform"};

OnLoad[expression_]:=With[
	{existing = Lookup[onLoadExpressions, $Package, {}]},

	AppendTo[
		onLoadExpressions,
		$Package -> Append[existing, Hold[expression]]
	];
];


(* The following lines quiet the Internal`AddHandler::string message thrown when caling EvaluationData.
   Starting around Feb 15, '23 or so, Mathematica 12.0 and 12.2 started generating this message.  Perhaps there was
   a bad paclet push by WRI that affected 12.0 and 12.2.
 *)
patchEvaluationData[]:=If[$VersionNumber < 13.0,
	Unprotect[EvaluationData];
	DownValues[EvaluationData] = Replace[
		DownValues[EvaluationData],
		Verbatim[RuleDelayed][pattern_, body_] :>
			RuleDelayed[pattern, Quiet[body, {Internal`AddHandler::string}]],
		{1}
	];
	Protect[EvaluationData];
];


(*The following lines revert the 13.2 behavior of AbsoluteOptions to the 12.0 one.  Issues affecting Emerald
functionality are as follows:
	1.  AbsoluteOptions called over the link crashes the front end.  This is fixed in 13.3.
	2.  AbsoluteOptions no longer returns a list of ticks for an empty Graphics[{}], which causes
		unit tests to fail
*)

installAbsoluteGraphicsPatch[]:=(
	Unprotect[AbsoluteOptions];
	DownValues[AbsoluteOptions] =
		{
			HoldPattern[
				AbsoluteOptions[
					System`Dump`x_List /;
						VectorQ[System`Dump`x, System`Dump`StrmTest], System`Dump`y_]] :>
				Flatten[(AbsoluteOptions[#1, System`Dump`y] & ) /@ System`Dump`x,
					1], HoldPattern[
			AbsoluteOptions[System`Dump`x_List,
				System`Dump`y_]] :> (AbsoluteOptions[#1, System`Dump`y] & ) /@
			System`Dump`x,
			HoldPattern[AbsoluteOptions[System`Dump`x_, System`Dump`y_List]] :>
				Flatten[(AbsoluteOptions[System`Dump`x, #1] & ) /@ System`Dump`y,
					1], HoldPattern[
			AbsoluteOptions[
				System`Dump`x_List /;
					VectorQ[System`Dump`x, System`Dump`StrmTest]]] :>
			Flatten[AbsoluteOptions /@ System`Dump`x, 1],
			HoldPattern[
				AbsoluteOptions[
					System`Dump`x_ /; System`Dump`StrmTest[System`Dump`x],
					System`Dump`y_]] :>
				Module[{System`Dump`names},
					System`Dump`names = First /@ Options[System`Dump`x];
					If[MemberQ[System`Dump`names,
						System`Dump`y], {System`Dump`y -> (System`Dump`y /.
						AbsoluteOptions[System`Dump`x])},
						Message[AbsoluteOptions::optnf, System`Dump`y,
							System`Dump`x]; {}]],
			HoldPattern[
				AbsoluteOptions[
					System`Dump`x_ /; System`Dump`StrmTest[System`Dump`x]]] :>
				Module[{System`Dump`trueCharEnc},
					System`Dump`trueCharEnc =
						Replace[BinaryFormat /. Options[System`Dump`x], {True -> {},
							False -> "ASCII", _ -> $Failed}];
					Replace[Options[
						System`Dump`x], (Rule | RuleDelayed)[CharacterEncoding,
						Automatic] ->
						CharacterEncoding -> System`Dump`trueCharEnc, {1}]],
			HoldPattern[
				AbsoluteOptions[(System`Dump`g_)?GraphQ, System`Dump`prop___]] :>
				Module[{System`Dump`res},
					System`Dump`res =
						GraphComputation`GraphAbsoluteOptions[System`Dump`g,
							System`Dump`prop];
					System`Dump`res /; System`Dump`res =!= $Failed],
			HoldPattern[
				AbsoluteOptions[
					System`Dump`args___]] :> $Failed /; (System`Private`Arguments[
				AbsoluteOptions[System`Dump`args], {1, 2}]; False),
			HoldPattern[
				AbsoluteOptions[
					System`Dump`x0_ /; System`Dump`GTest[Head[System`Dump`x0]],
					PlotRange]] :>
				Module[{System`Dump`x, System`Dump`pr},
					System`Dump`pr =
						OptionValue[Head[System`Dump`x0], Options[System`Dump`x0],
							PlotRange];
					System`Dump`x =
						Show[System`Dump`x0,
							PlotRange ->
								System`Dump`simplifyPlotRange[System`Dump`pr]]; {PlotRange ->
						PlotRange[System`Dump`x]}],
			HoldPattern[
				AbsoluteOptions[
					System`Dump`x_ /; System`Dump`GTest[Head[System`Dump`x]],
					System`Dump`y_]] :>
				Module[{System`Dump`names},
					System`Dump`names = First /@ Options[Head[System`Dump`x]];
					If[MemberQ[System`Dump`names,
						System`Dump`y], {System`Dump`y -> (System`Dump`y /.
						AbsoluteOptions[System`Dump`x])},
						Message[AbsoluteOptions::optnf, System`Dump`y,
							System`Dump`x]; {}]],
			HoldPattern[AbsoluteOptions[System`Dump`x0_]] :>
				Module[{System`Dump`plrng, System`Dump`opts, System`Dump`names,
					System`Dump`vals, System`Dump`asp, System`Dump`axes,
					System`Dump`x},
					System`Dump`x =
						System`Dump`x0 /. {HoldPattern[
							Axes -> {System`Dump`a_, System`Dump`a_}] :>
							Axes -> System`Dump`a,
							HoldPattern[
								Frame -> {{System`Dump`a_,
									System`Dump`a_}, {System`Dump`a_, System`Dump`a_}}] :>
								Frame -> System`Dump`a,
							HoldPattern[PlotRange -> System`Dump`range_] :>
								PlotRange ->
									System`Dump`simplifyPlotRange[System`Dump`range]};
					System`Dump`plrng = PlotRange[System`Dump`x];
					System`Dump`names = First /@ Options[Head[System`Dump`x]];
					System`Dump`opts =
						Flatten[If[Length[System`Dump`x] == 0, {},
							Drop[List @@ System`Dump`x, 1]]];
					System`Dump`opts =
						Select[System`Dump`opts,
							Head[#1] == RuleDelayed || Head[#1] == Rule & ];
					System`Dump`opts =
						Join[System`Dump`opts, Options[Head[System`Dump`x]]];
					System`Dump`opts =
						System`Dump`CheckGopt[System`Dump`x, System`Dump`opts,
							System`Dump`plrng];
					System`Dump`opts =
						Prepend[System`Dump`opts, PlotRange -> System`Dump`plrng];
					System`Dump`axes = FullAxes[System`Dump`x];
					If[ListQ[System`Dump`axes],
						System`Dump`opts = Join[System`Dump`axes, System`Dump`opts]];
					System`Dump`opts =
						Join[System`Dump`GetMesh[System`Dump`x, System`Dump`opts],
							System`Dump`opts];
					System`Dump`vals = System`Dump`names /. System`Dump`opts;
					System`Dump`opts =
						Transpose[{System`Dump`names, System`Dump`vals}];
					System`Dump`opts =
						Apply[{#1,
							If[MemberQ[{AxesLabel, FrameLabel, PlotLabel}, #1], #2,
								N[#2]]} & , System`Dump`opts, {1}]; (Rule @@ #1 & ) /@
						System`Dump`opts] /;
					System`Dump`GTest[Head[System`Dump`x0]] &&
						Length[System`Dump`x0] =!= 0,
			HoldPattern[
				AbsoluteOptions[
					GraphicsArray[System`Dump`x_, System`Dump`opts___],
					System`Dump`y___]] :>
				With[{System`Dump`res =
					Graphics[GraphicsArray[System`Dump`x, System`Dump`opts]]},
					AbsoluteOptions[System`Dump`res, System`Dump`y] /;
						System`Dump`GRTest[System`Dump`res]],
			HoldPattern[
				AbsoluteOptions[
					Internal`RasterGraphics[System`Dump`x_, System`Dump`opts___],
					System`Dump`y___]] :>
				With[{System`Dump`res =
					DensityGraphics[
						Internal`RasterGraphics[System`Dump`x, System`Dump`opts]]},
					AbsoluteOptions[System`Dump`res, System`Dump`y] /;
						System`Dump`DGTest[System`Dump`res]]
		};

	DownValues[System`Dump`GTest] =
		{
			HoldPattern[System`Dump`GTest[System`Dump`x_]] :>
				MemberQ[{Graphics, Graphics3D, SurfaceGraphics, DensityGraphics,
					ContourGraphics}, System`Dump`x]
		};

	Protect[AbsoluteOptions];
);


(*
The following lines serve to TEMPORARILY patch three changes Mathematica 13.2 with regards to temperature
unit conversions.
	1.  Quantity["DegreesCelcius"] is redefined so that it is always measured relative to absolute zero.
		This affects the addition / subtraction of Quantity["DegreesCelcius"].
	2.  All arithmetic operations involving Quantity["DegreesCelcius"] get automatically converted to
		Quantity["Kelvin"].
	3.  UnitDimensions["Micro" IndependentUnit["EmeraldUnit"]] now returns an extra pair of { }.

Tracking down the changes in the source code was done manually using GeneralUtilities`PrintDefinitions,
As such There is no guarantee that this reverts ALL of Mathematica 13.2's behvaior.
This patch should be removed once the issue is resolved with WRI and a more permanent solution is found.

For further details see:   https://redmine.wolfram.com/redmine/issues/2728
*)

installUnitConversionPatch[]:=
	Module[{},
		(*Autoload unit package*)
		Quantity[1, "DegreesCelsius"] + Quantity[1, "DegreesCelsius"];

		(*Fix issue #3 above*)
		Unprotect[UnitDimensions];
		UnitDimensions[expr : Times[pre_String, unit_IndependentUnit]] /;
			KnownUnitQ[expr] := UnitDimensions[unit];
		Protect[UnitDimensions];

		(*Partially Fix issue #1 and #2 for addition/subtraction of Quantity["DegreesCelcius"]*)
		QuantityUnits`Private`$absTempUnitPattern = Alternatives[];
		DownValues[QuantityUnits`Private`hasNonZeroTempUnitQ] = {};
		QuantityUnits`Private`hasNonZeroTempUnitQ[_] = False;

		(*Fix issue #2 for multiplication of Quantity["DegreesCelcius"] with other Quantity*)
		DownValues[
			QuantityUnits`Private`iqTimesNormalize] = {HoldPattern[
			QuantityUnits`Private`iqTimesNormalize[
				QuantityUnits`Private`q_List]] :>
			Module[{QuantityUnits`Private`res},
				QuantityUnits`Private`res =
					QuantityUnits`Private`q /.
						QuantityUnits`Private`mixed_?
							QuantityUnits`Private`MixedUnitQ :>
							QuantityUnits`Private`unmixMixedUnitQuantity[
								QuantityUnits`Private`mixed]]};

		(*Fix issue #2 for multiplication of Quantity["DegreesCelcius"] with constants*)
		HoldPattern[
			QuantityUnits`Private`qqTimes[(QuantityUnits`Private`temp_)?
				QuantityUnits`Private`temperatureQuantityQ,
				QuantityUnits`Private`y___]] :=
			With[{QuantityUnits`Private`v =
				QuantityMagnitude[QuantityUnits`Private`temp],
				QuantityUnits`Private`inunit =
					QuantityUnit[QuantityUnits`Private`temp]},
				Quantity[QuantityUnits`Private`v*QuantityUnits`Private`y,
					QuantityUnits`Private`inunit]];

		(*Partially Fix issue #2 above*)
		QuantityUnits`$AutoNormalizeCompoundTemperatureUnits = False;
	];




revertQuantityUnitsPaclet[sllDir_]:=
	Module[{},


		(* force install MM to use old units paclet *)
		Unprotect[Internal`PacletFindFile];

		packagerFileGet[name_] := Get[FileNameJoin[{sllDir,"Packager","sources",name}]];

		oldQuantityUnitsFile = FileNameJoin[{sllDir,"Packager","resources","WolframPaclets","QuantityUnits-3.1.0","Kernel","QuantityUnits.m"}];

		Internal`PacletFindFile["QuantityUnits`"] := (
			oldQuantityUnitsFile
		);


		(*
			don't load the QuantityUnits paclet specified in manifest
		*)
		Packager`Private`loadPaclet[paclet:KeyValuePattern[{Name->"QuantityUnits"}], _] := Null;

		(*
			load the old units paclet
		*)
		Unprotect[QuantityUnits`$UnitAlternateStandardNameReplacements];
		Get[oldQuantityUnitsFile];

		(*
			fix some stuff that gets broken by old paclet
		*)
		Unprotect[Quantity];
		(* TimeConstrained with second argument as quantity gets broken by paclet reversion *)
		(* tmp patching via Quantity UpValue, which strips units *)
		Quantity /: TimeConstrained[arg_, q_Quantity, rest___] := With[
			{qs = QuantityMagnitude[q, "Seconds"]}, 
  			TimeConstrained[arg, qs, rest]
		];

		Protect[Quantity];


	(*
		Solve with units doesn't work because it relies on stuff in new unit paclet and stuff outside of units paclet.		
		Tmp patch by turning quantities into magnitudes * unit-terms, solveing, and then swapping units back in.  
		Just be careful about real-ness of solutions and independent untis
	*)
	Unprotect[Solve];
	Solve[expr_, vars_] /; Not[FreeQ[expr, _Quantity]] := unitlessSolve[expr, vars];
	Protect[Solve];

	unitlessSolve[exprOrig_,vars_] := Module[{expr, exprSubbed, unitlessSol, indepStrings},
		
		(* make problem easier by converting to base units first *)
		expr = exprOrig /. q_Quantity:>UnitConvert[q];
		(* Replace Quantity[mag, unit] with Times[mag,unit], leaving 'unit' as an algebraic expression of strings and _IndependentUnits	*)
		(* Zero is a special case because 0 * units resolves to 0, we substitute it back in the end when we return quantities *)
		exprSubbed = ReplaceAll[
			expr,
			{
				Quantity[0, x_] -> "ZeroIntegerPlaceholder" * x,
				Quantity[0., x_] -> "ZeroRealPlaceholder" * x,
				Quantity->Times
			}
		];
		(* 
			solve this unitless expression, removing non-real solutions.
		*)
		unitlessSol = Quiet[
			DeleteCases[Solve[exprSubbed,vars],MemberQ[#,_Complex,Infinity]&],
			Solve::nongen
		];
		
		(* replace the strings and independent units wtih unity-magnitude quantities of that unit *)
		(* need a little extra care to get IndependentUnits correct, since they contain strings *)
		indepStrings = Alternatives @@ Union[Cases[exprSubbed,IndependentUnit[s_]:>s,Infinity]];
		
		ReplaceAll[
			unitlessSol, 
			{
				"ZeroIntegerPlaceholder" :> 0,
				"ZeroRealPlaceholder" :> 0.,
				s:Except[indepStrings, _String] :> Quantity[1,s],
				iu_IndependentUnit :> Quantity[1,iu]
			}
		]
	];



	];




installOtherUnitFixes[]:=
	Module[{},

		(*Autoload unit package*)
		Quantity[1, "DegreesCelsius"] + Quantity[1, "DegreesCelsius"];

		Unprotect[Quantity];
	
		(* 
			Quieting the message that appears on
				Between[Quantity[1., "Liters"], {Quantity[0., "Liters"], Quantity[12., "Liters"]}]
			Doesn't appear without units.  Doesn't appear with certain base units.
		*)
		$MM13$QuietBetweenMessage = True;
		PrependTo[UpValues[Quantity],HoldPattern[Between[x_Quantity,{a:Quantity[0.,_],b_}]/;TrueQ[$MM13$QuietBetweenMessage]]:>Block[{$MM13$QuietBetweenMessage=False},Quiet[Between[x,{a,b}],General::munfl]]];
		PrependTo[UpValues[Quantity],HoldPattern[Between[x_Quantity,{a_,b:Quantity[0.,_]}]/;TrueQ[$MM13$QuietBetweenMessage]]:>Block[{$MM13$QuietBetweenMessage=False},Quiet[Between[x,{a,b}],General::munfl]]];
		Protect[Quantity];


		Unprotect[Differences];
		Differences[list:{__Quantity}]/;Not[DuplicateFreeQ[list]] := Rest[list]-Most[list];
		Protect[Differences];

		(*
			temporarily revert Quantity[{1},{"Meters"}] until we can accomodate it
		*)
		Unprotect[Quantity];
		$MM13$QUnitsInList=True;
		Quantity[a_,b:{_?KnownUnitQ}]/;$MM13$QUnitsInList := Block[{$MM13$QUnitsInList=False},Quiet[Quantity[a,b],Quantity::unkunit]];
		Protect[Quantity];


		Unprotect[Quantity];
		Quantity[a_,1] := a;
		Protect[Quantity];


		(*
			MM 13.2 allows 
				Dozen > 50  [1]
			but not 
				50 < Dozen  [2]
			To get around this, we add overloads to comparison functions
			that match on first arugment being numeric and second being quantity,
			then  we just flip the sign and swap the arguments,
			turning [2] into [1]
		*)
		Unprotect[Quantity];
		Quantity /: Greater[x_?NumericQ,y_Quantity] := Less[y,x];
		Quantity /: Less[x_?NumericQ,y_Quantity] := Greater[y,x];
		Quantity /: Equal[x_?NumericQ,y_Quantity] := Equal[y,x];
		Quantity /: GreaterEqual[x_?NumericQ,y_Quantity] := LessEqual[y,x];
		Quantity /: LessEqual[x_?NumericQ,y_Quantity] := GreaterEqual[y,x];


		(* Negative infinity and compound units cause these to be different, so need ot enumerate all permutations *)
		Quantity /: Less[Quantity[Infinity,un_],Quantity[Except[Infinity],un_]] := False;
		Quantity /: LessEqual[Quantity[Infinity,un_],Quantity[Except[Infinity],un_]] := False;
		Quantity /: Greater[Quantity[Infinity,un_],Quantity[Except[Infinity],un_]] := True;
		Quantity /: GreaterEqual[Quantity[Infinity,un_],Quantity[Except[Infinity],un_]] := True;

		Quantity /: Less[Quantity[-Infinity,un_],Quantity[Except[-Infinity],un_]] := True;
		Quantity /: LessEqual[Quantity[-Infinity,un_],Quantity[Except[-Infinity],un_]] := True;
		Quantity /: Greater[Quantity[-Infinity,un_],Quantity[Except[-Infinity],un_]] := False;
		Quantity /: GreaterEqual[Quantity[-Infinity,un_],Quantity[Except[-Infinity],un_]] := False;

		Quantity /: Less[Quantity[Except[Infinity],un_],Quantity[Infinity,un_]] := True;
		Quantity /: LessEqual[Quantity[Except[Infinity],un_],Quantity[Infinity,un_]] := True;
		Quantity /: Greater[Quantity[Except[Infinity],un_],Quantity[Infinity,un_]] := False;
		Quantity /: GreaterEqual[Quantity[Except[Infinity],un_],Quantity[Infinity,un_]] := False;

		Quantity /: Less[Quantity[Except[-Infinity],un_],Quantity[-Infinity,un_]] := False;
		Quantity /: LessEqual[Quantity[Except[-Infinity],un_],Quantity[-Infinity,un_]] := False;
		Quantity /: Greater[Quantity[Except[-Infinity],un_],Quantity[-Infinity,un_]] := True;
		Quantity /: GreaterEqual[Quantity[Except[-Infinity],un_],Quantity[-Infinity,un_]] := True;

		Protect[Quantity];
		
		(*
			Add upvalues to Quantity to catch comparisons of temperature units
			This is not the best but works.
			If it turns to be slow we can try to fix at lower level
		*)
		If[$VersionNumber > 13.2,
			(
				containsTemperatureQ[x_Quantity]:= MemberQ[UnitDimensions[x],{"TemperatureUnit",_}];
				containsTemperatureQ[_] := False;
				
				Unprotect[Quantity];
				
				(* two argument unit comparison *)
				Quantity /: (h : (Greater | GreaterEqual | Equal | Less | LessEqual))[
					qa : Quantity[x_, unA_], qb : Quantity[y_, unB_]/; containsTemperatureQ[qb]
				] := h[QuantityMagnitude@qa, QuantityMagnitude@UnitConvert[qb, unA]];
				
				(* three argument unit comparison *)
				Quantity /: (h : (Greater | GreaterEqual | Equal | Less | LessEqual))[
					qa : Quantity[x_, unA_], qb : Quantity[y_, unB_]/; containsTemperatureQ[qb], qc : Quantity[z_, unC_]/; containsTemperatureQ[qc]
				] := h[QuantityMagnitude@qa, QuantityMagnitude@UnitConvert[qb, unA], QuantityMagnitude@UnitConvert[qc, unA]];
				
				Protect[Quantity];
			);
		];

		(*
			Add upvalues to Quantity to catch comparisons of temperature units
			This is not the best but works.
			If it turns to be slow we can try to fix at lower level
		*)
		If[$VersionNumber > 13.2,
			(
				containsTemperatureQ[x_Quantity]:= MemberQ[UnitDimensions[x],{"TemperatureUnit",_}];
				containsTemperatureQ[_] := False;

				Unprotect[Quantity];

				(* two argument unit comparison *)
				Quantity /: (h : (Greater | GreaterEqual | Equal | Less | LessEqual))[
					qa : Quantity[x_, unA_], qb : Quantity[y_, unB_]/; containsTemperatureQ[qb]
				] := h[QuantityMagnitude@qa, QuantityMagnitude@UnitConvert[qb, unA]];

				(* three argument unit comparison *)
				Quantity /: (h : (Greater | GreaterEqual | Equal | Less | LessEqual))[
					qa : Quantity[x_, unA_], qb : Quantity[y_, unB_]/; containsTemperatureQ[qb], qc : Quantity[z_, unC_]/; containsTemperatureQ[qc]
				] := h[QuantityMagnitude@qa, QuantityMagnitude@UnitConvert[qb, unA], QuantityMagnitude@UnitConvert[qc, unA]];

				Protect[Quantity];
			);
		];
	];




SetAttributes[FunctionPackage,HoldFirst];
FunctionPackage[name_String]:=Quiet[
	Apply[
		FunctionPackage,
		MakeExpression[name,StandardForm]
	]
];
FunctionPackage[sym_Symbol]:=With[
	{
		packagePrivateContexts=Association[
			Map[
				StringJoin[#,"Private`"] -> #&,
				Select[
					$Packages,
					PackageQ
				]
			]
		]
	},

	Lookup[
		packagePrivateContexts,
		Context[sym],
		$Failed
	]
];
FunctionPackage[type_ECL`Object]:="ProcedureSimulation`";
FunctionPackage[___]:=$Failed;

SetAttributes[SymbolPackages,HoldFirst];

ECL`Authors[SymbolPackages] := {"platform"};

SymbolPackages[name_String]:=Select[
	$Packages,
	And[
		PackageQ[#],
		MemberQ[
			Lookup[PackageMetadata[#],"CombinedSymbols"],
			name
		]
	]&
];
SymbolPackages[sym_Symbol]:=SymbolPackages[
	Evaluate[SymbolName[Unevaluated[sym]]]
];
SymbolPackages[___]:=$Failed;

ECL`Authors[PackageSymbols] := {"platform"};

PackageSymbols[package_String]:=With[
	{metadata=PackageMetadata[package]},
	Lookup[metadata, "CombinedSymbols", $Failed]
];

symbolFunctionQ[HoldComplete[symbol_Symbol]]:=Greater[
	Length[DownValues[symbol]],
	0
];

Options[PackageFunctions]:={
	Output->Automatic
};

ECL`Authors[PackageFunctions] := {"platform"};

PackageFunctions[package_String, opts:OptionsPattern[PackageFunctions]]:=Module[
	{heldSymbols,context,packageFunctions},

	If[!PackageQ[package],
		Return[{}]
	];

	context=Lookup[PackageMetadata[package],"Context"];
	heldSymbols = MakeExpression[
		Map[context<>#&,PackageSymbols[package]],
		StandardForm
	];
	packageFunctions=Select[
		heldSymbols,
		And[symbolFunctionQ[#], Apply[FunctionPackage,#]===package]&
	];

	Switch[
		OptionValue[PackageFunctions, opts, Output],
		Automatic,
			Apply[SymbolName,#]&/@packageFunctions,
		Symbol,
			Quiet[
				ReleaseHold[packageFunctions],
				{General::shdw}
			],
		_,
			$Failed
	]
];

ECL`Authors[PackageSources] := {"platform"};

PackageSources[metadata_Association]:=With[
	{
		sourceDir=FileNameJoin[{Lookup[metadata, "Directory"],"sources"}],
		sourceFiles=Lookup[metadata, "Sources"]
	},
	Map[FileNameJoin[{sourceDir, #}]&, sourceFiles]
];

ECL`Authors[SymbolPackageName] := {"platform"};

SymbolPackageName[sym_Symbol]:=With[
	{package=FunctionPackage[sym]},

	If[FailureQ[package],
		package,
		PackageMetadata[package][["Name"]]
	]
];

AvailablePackages[]:=Keys[packageMetadata];
ECL`Authors[PackagesGraph] := {"platform"};

PackagesGraph[]:=Graph[
 Flatten[
	Map[
	 Function[{package},
		Map[
		 Function[{dependency},
			DirectedEdge[package, dependency]
			],
		 Lookup[PackageMetadata[package], "Dependencies"]]
		],
	 AvailablePackages[]
	 ]
	]
];
ECL`Authors[PackagesRootDirectories] := {"platform"};
PackagesRootDirectories[]:=DeleteDuplicates@Map[
		DirectoryName,
		Lookup[Map[PackageMetadata, AvailablePackages[]], "Directory"]
];



(* ::Subsubsection:: *)
(*LoadUsage*)


LoadUsage::NotFound="The package `1` could not be found or is not an ECL package.";

(*Load all m-files in the docs/reference_pages directory for the given package.
These files will define the usage rules for functions in the package.*)
LoadUsage[]:=With[
	{packages=Select[$Packages,PackageQ]},
	Scan[LoadUsage,packages];
	packages
];

LoadUsage[package_String]:=Module[
	{metadata, directory, context, usageFiles},

	(*Try and load metadata for the package, if not found return $Failed*)
	metadata = Quiet[
		PackageMetadata[package],
		{PackageMetadata::NotFound}
	];

	If[metadata === $Failed,
		Message[LoadUsage::NotFound,package];
		Return[$Failed]
	];

	directory = Lookup[metadata,"Directory"];
	context = Lookup[metadata,"Context"];

	(*Find all m-files which define usage rules*)
	usageFiles = FileNames[
		"*.m",
		FileNameJoin[{directory,"docs","reference_pages"}],
		Infinity
	];

	(*Load all dependencies for the package and load the usage definition files
	in the `Private` context for the given package.*)
	Block[{$ContextPath,$Context},
		$ContextPath = {"System`",context,"Packager`"};
		$Context=package<>"Private`";

		(*Load dependencies*)
		LoadPackage["Usage`"];
		Scan[
			LoadPackage,
			Lookup[metadata,"Dependencies"]
		];

		(*Load usage m-files*)
		Scan[
			Get,
			usageFiles
		];
	];

	package
];


Options[PackageGraph] = {Tests -> False};

ECL`Authors[PackageGraph] := {"platform"};

PackageGraph[options:OptionsPattern[]]:=PackageGraph[AvailablePackages[], options];
PackageGraph[packages: {___String}, options:OptionsPattern[]]:=Graph[
  Apply[
    Join,
    Map[
      Function[{package},
        With[{metadata = PackageMetadata[package]},
          Map[
            package -> # &,
            Lookup[metadata, "Dependencies", {}]
          ]
        ]
      ],
			packages
    ]
  ],
  VertexLabels -> "Name"
];

summarizePaclet[paclet_, includeDetails:True|False]:=Module[
	{basics, extensions, contexts, symbols, extraDetails},

	basics = <|
		"Name" -> paclet["Name"],
		"Version" -> paclet["Version"],
		"MathematicaVersion" -> paclet["MathematicaVersion"],
		"Location" -> paclet["Location"]
	|>;

	If[includeDetails===False,
		Return[basics]
	];

	extensions = Flatten[paclet["Extensions"]];
	contexts = extensions // Select[MatchQ["Context" -> _]] // Map[Last] // Flatten;
	symbols = extensions // Select[MatchQ["Symbols" -> _]] // Map[Last] // Flatten;

	extraDetails = <|
		"Contexts" -> contexts,
		"Symbols" -> symbols
	|>;

	Join[basics, extraDetails]
];

Options[ListPacletVersions]:={
	(* include Context and Symbols when summarizing each paclet listed *)
	IncludeContexts -> False,

	(* use PacletFindRemote instead of PacletFind to search servers *)
	SearchRemote -> False
};

(* given a pattern, summarize all paclets with names matching that pattern, or just all packages *)
ListPacletVersions[options:OptionsPattern[]]:=ListPacletVersions["*", options];
ListPacletVersions[pattern_String, options:OptionsPattern[]]:=Module[
	{remote, includeContexts, paclets, summaries},

	remote = TrueQ[OptionValue[SearchRemote]];
	includeContexts = TrueQ[OptionValue[IncludeContexts]];

	paclets = If[remote,
		(*
			Some shortcomings of PacletFindRemote:
				* it doesn't list higher versions that supported by your kernel,
				* it doesn't list lower minor versions (e.g., 2.3 is latest, but 2.2 exists but may be hidden),
				* it doesn't list paclets like StructuredArrayPatch where the server-side MM version is Null.

			In successful builds we'll store ALL versions of all paclets in the build metadata JSON, so
			if you can't find the version you need but it was implicitly loaded before we can dig it up.
		*)
		PacletFindRemote[pattern],
		PacletFind[pattern]
	];

	summaries = Map[
		summarizePaclet[#, includeContexts]&,
		paclets
	];

	ReplaceAll[summaries, _Missing -> Null]
];

(* given a paclet name, return the _Paclet (12.0) or _PacletObject (12.1+) *)
lookupPacletByName[name_String]:=Module[
	{paclets},
	If[KernelVersionMatchQ["12.0"],
		(* are these always sorted by version: latest first? *)
		paclets = PacletFind[name];
		If[Length[paclets] === 0,
			Return[Failure["Missing paclet", <||>]]
		];
		Return[First[paclets]]
	];

	(* this can return a _Failure, too *)
	PacletObject[name]
];

(* given a paclet name, return the current version of it *)
lookupPacletVersion[name_String]:=Module[
	{paclet},

	paclet = lookupPacletByName[name];

	If[FailureQ[paclet],
		Return[paclet]
	];

	paclet["Version"]
];



(* just get this shadowing error message out of the way on 12.0 *)
Off[General::shdw];
$CursedFutureSymbols = {
	System`PacletInstall::newervers
};
On[General::shdw];


getPacletVersion[pacName_]:=If[KernelVersionMatchQ["12.0"],
	Lookup[PacletInformation[pacName],"Version"],
	Information[PacletObject[pacName]]["Version"]
];

(*
	note, each paclet version declaration passed to this should contain:
		* "Name",
		* "Version" of the paclet (optional on MM 12.1+),
		* "MathematicaVersion" for which we want to require this paclet (optional)

	also: between 12.0 and 12.1, PacletInstall and friends moved from PacletManager` to System` contexts...
*)
(* this function is also called by a script on WEPC, so don't change it without checking that *)
loadPaclet[paclet_Association,sllDir_String]:=Module[
	{pacletName, pacletVersion, expectedKernelVersion, pacletFullname, previousVersion, uninstallablePaclets, localRepoPacletFolder},

	(* specified in the distro config file *)
	pacletName = Lookup[paclet, "Name"];
	pacletVersion = Lookup[paclet, "Version", AnyVersion];
	expectedKernelVersion = Lookup[paclet, "MathematicaVersion", AnyVersion];
	pacletFullname = pacletName <> "-" <> pacletVersion;

	(* present in the system (or _Failure) *)
	previousVersion = lookupPacletVersion[pacletName];

	(* If paclet expects a specific version of MM, and user is not running that versions, exit. *)
	If[expectedKernelVersion =!= AnyVersion && !KernelVersionMatchQ[expectedKernelVersion],
		(* paclet specified for some other Mathematica kernel version, carry on *)
		Return[]
	];

	(* If existing version matches expected version, return the paclet or paclet object. *)
	If[previousVersion === pacletVersion,
		Return[lookupPacletByName[pacletName]]
	];

	(* Find all uninstallable paclets of the same name. If $ForcePacletVersion= True, uninstall existing paclets. *)
	uninstallablePaclets = Select[
		PacletFind[pacletName],
		StringStartsQ[
			Lookup[PacletInformation[#], "Location"],
			$UserBasePacletsDirectory
		]&
	];
	If[TrueQ[$ForcePacletVersions],
		Scan[PacletUninstall, uninstallablePaclets];
	];

	(* 
		install our local copy of the paclet. 
		if there is a bad version that was not forcibly removed, this line will generate a message 
		and will retain the old paclet.
	*)
	localRepoPacletFolder = FileNameJoin[{sllDir, "Packager","resources","WolframPaclets",pacletFullname}]<>".paclet";
	(* 
		newer MM versions retain the old paclet and complain about it.  Need to force version in that case.
	 	This forcing option does not exist in 12.0 
	*)
	If[$VersionNumber>12.0,
		PacletInstall[localRepoPacletFolder, ForceVersionInstall->True],
		PacletInstall[localRepoPacletFolder]
	];

	If[$LogPacletChanges,
		Return[
			<|
				"$ForcePacletVersions" -> $ForcePacletVersions,
				"$UserBasePacletsDirectory" -> $UserBasePacletsDirectory,
				"UninstallablePaclets" -> uninstallablePaclets,
				"InstalledPaclets" -> lookupPacletByName[pacletName]
			|>
		],
		Return[
			lookupPacletByName[pacletName]
		]
	]
];


ECL`Authors[DistroMetadata] := {"platform"};

DistroMetadata[configFile_String]:=Module[
	{rules},
	rules = Import[configFile, "RawJSON"];

	If[Not[MatchQ[rules, _Association]],
		Return[$Failed];
	];

	rules
];

initializeTimers[] := (
	$LoadTimings = <||>;
	$LoadMetadata=<||>;
	(* these are incrementally added to from LoadPackage, so not module-scoped *)
	tOnLoadRelease = 0.;
	tLoadFiles = 0.;
	tSetPackage = 0.;
	tPacletDirectoryAdd = 0.;
	tMakeSymbols = 0.;
);

(* calling this here also to make sure loading from an mx distro doesn't import the wrong saved values*)
initializeTimers[];

LoadDistro::Cycle = "Dependencies are cyclic: `1`";
LoadDistro::Dependencies = "In distro `1`, there's a problem listing the packages.";
LoadDistro::Loop = "Dependencies are looping: `1`";
LoadDistro::MisconfiguredPackages = "In distro `1`, these packages are both hidden and visible: `2`";
LoadDistro::MismatchedMathematicaVersion="Mismatched Mathematica version found at runtime: `1`. Distro was built with version: `2`.";
LoadDistro::UnsupportedMathematicaVersion="Unsupported Mathematica version found at runtime: `1`.  Expected: `2`";
LoadDistro::MissingConfigFile = "Distro config file `1` was not found.";
LoadDistro::MissingPackages = "Packages `1` are missing, but are required by packages `2`.";
LoadDistro::TrustedPath="SLL package folder is not on the TrustedPath, documentation notebooks may not function correctly.";
LoadDistro::MissingIndices="Packages `1` are missing search indices.";
LoadDistro::MismatchedPaclets="Paclet `1` version `2` could not be loaded.  Version `3` was present.  Consider updating the SLL Distro definition for Mathematica `4` and see ListPacletVersions.  Debug info: `5`";
LoadDistro::HiddenContextECL="One of your HiddenPackages has ECL context, meaning all of ECL will be removed from $ContextPath.  This is probably not something you want.";
Options[LoadDistro]:={
	PackagesRoot->Automatic
};

ECL`Authors[LoadDistro] := {"platform"};

LoadDistro[configFile_String, options:OptionsPattern[]]:=Module[
	{metadataFile, metadata, builtVersion, supportedWolframVersions,
	 packagesRoot, config, name, packages, hiddenPackages, misconfiguredPackages, missingIndices,
	hiddenContexts, ticLoadDistro, tocLoadDistro, isDeployed, sllDir, pacletVersions,
	 tLoadPackages, ticPaclets, tocPaclets, tPreload, tLoadUsage, tLoadTests,
	 ticConfig, tocConfig, ticPatch13, tocPatch13, tAppendPackagePach, tTrustedPath },

	tPreload = SessionTime[];
	ticLoadDistro = AbsoluteTime[];

	(* for MM 13.3.1 this quiets new shadowing errors by quietly loading the symbols *)
	Quiet[
		(* avoid shadow error for SymbolQ *)
		ResourceSystemClient`DefinitionUtilities`SymbolQ;
		Developer`SymbolQ;

		(* avoid shadowing for ContextQ *)
		ResourceSystemClient`DefinitionUtilities`ContextQ;
		ECL`ContextQ;
		
		(* avoid shadowing for Reference *)
		CompileUtilities`Reference`Reference;
		ECL`Reference;

		(* avoid shadowing for compile utilities *)
		CompileUtilities`ClassSystem`Class;
		ECL`Class;

		(* 1/0 to get early errors out because it generates unexpected errors the first time it is run in MM 13.3.1 *)
		1/0
	];

	(*
		this is intentionally not scoped to this module because it is updated from LoadPackage.
	*)

	initializeTimers[];
	
	If[Not[FileExistsQ[configFile]],
		Message[LoadDistro::MissingConfigFile, configFile];
		Return[$Failed]
	];

	$AllowDataUpdates=False;



	(* For the unit system to use metric by default. *)
	$UnitSystem="Metric";



	(* read the distro config file *)
	ticConfig = AbsoluteTime[];
	config = DistroMetadata[configFile];
	name = Lookup[config, "DistroName", {}];
	packages = Lookup[config, "Packages", {}];
	hiddenPackages = Lookup[config, "HiddenPackages", {}];

	(* error when a package is both hidden and visible *)
	misconfiguredPackages = Intersection[packages, hiddenPackages];
	If[Length[misconfiguredPackages] > 0,
		Message[LoadDistro::MisconfiguredPackages, configFile, misconfiguredPackages];
		Return[$Failed]
	];
	tocConfig = AbsoluteTime[];

	sllDir = ParentDirectory[DirectoryName[configFile]];

	supportedWolframVersions = Lookup[config, "WolframVersions", {}];

	metadataFile = FileNameJoin@{ParentDirectory[DirectoryName[configFile]], "metadata.json"};
	isDeployed = FileExistsQ[metadataFile];
	If[isDeployed,
		metadata = Import[metadataFile, "RawJSON"];
		builtVersion = StringTake[Lookup[Lookup[metadata, "Mathematica"], "Version"], 6];

		(* warn if built version and found version differ *)
		If[!KernelVersionMatchQ[builtVersion|"12.0.1"],
			(* warn users if this isn't one of our expected oddities *)
			Message[LoadDistro::MismatchedMathematicaVersion, $Version, builtVersion]
		];

		(* warn if Mathematica version is unsupported *)
		If[!KernelVersionMatchQ[Apply[Alternatives, supportedWolframVersions]],
			Message[LoadDistro::UnsupportedMathematicaVersion, $Version, supportedWolframVersions]
		]
	];

	ticPaclets = AbsoluteTime[];
	pacletVersions = Lookup[config, "PacletVersions", {}];
	(* only consider paclets for this MM version *)
	pacletVersions = Select[pacletVersions,KernelVersionMatchQ[Lookup[#, "MathematicaVersion", ""]] &];
	(*
		Manifold starts mathematica with the flag -nopaclet, which disables paclet installation.
		Mathematica looks at $CommandLine to check whether this flag is present.
		The disabling happens inside RestartPacletManager.
		Ideally we would Block $CommandLine and re-run RestartPacletManager,
		but $CommandLine is a Locked symbol so we aren't allowed to Block it.
		So instead we create our own function that does exactly what RestartPacletManager does,
		except we swap out $CommandLine in the DownValues for something without -nopaclet.
		This is complete insanity but it works.
	*)
	If[ (PacletManager`Package`$pmMode == "ReadOnly") || ( PacletManager`Package`isPMReadOnly[] == True ),
		With[
			(* remove -nopaclet from the commandline flags *)
			{myCommandLine = DeleteCases[$CommandLine, "-nopaclet"|"-pacletreadonly"]},
			(* define our own function that copies its definition from the internals of RestartPacletManager *)
			DownValues[myInitializePacletManager] = ReplaceAll[
				DownValues[PacletManager`Package`initializePacletManager],
				{
					HoldPattern[$CommandLine] -> myCommandLine,
					PacletManager`Package`initializePacletManager -> myInitializePacletManager
				}
			]
		]
	];
	myInitializePacletManager[];


	Scan[loadPaclet[#,sllDir];&,pacletVersions];

(* reload any new paclets *)
	If[$VersionNumber< 12.2,
			RebuildPacletData[];,
			PacletDataRebuild[];
	];

	(* re-run paclet manager initialization to re-disable when on Manifold *)
	PacletManager`Package`initializePacletManager[];
	tocPaclets = AbsoluteTime[];

	ticPatch13 = AbsoluteTime[];
	If[Not[ValueQ[ $MM13$RevertQuantityUnits]],
		$MM13$RevertQuantityUnits = True;
	];

	If[
		$VersionNumber >= 13.2`,
		If[True,
			revertQuantityUnitsPaclet[sllDir],
			installUnitConversionPatch[]
		];
		installOtherUnitFixes[]; (* always *)
		installAbsoluteGraphicsPatch[]; (* always *)
	];
	tocPatch13=AbsoluteTime[];



		(* top-level SLL, for now *)
	packagesRoot = OptionValue[PackagesRoot];
	packagesRoot = If[packagesRoot === Automatic,
		ParentDirectory[DirectoryName[configFile]],
		packagesRoot
	];

	(* message if the package directory is not on the trusted path, so we can have dynamics in docs *)
	tTrustedPath = First[AbsoluteTiming[
		If[isDesktopMathematica[] && !isPrivateCloud[],
			If[Not[MemberQ[
						Replace[
							CurrentValue[$FrontEnd, {"NotebookSecurityOptions", "TrustedPath"}],
							FrontEnd`FileName -> FileNameJoin,
							{2},
							Heads -> True
						],
						packagesRoot
				]],
				Message[LoadDistro::TrustedPath];
			]
		];
	]];


	(* load package metadata *)
	tAppendPackagePach = First[AbsoluteTiming[
		AppendPackagePath[packagesRoot];
	]];

	(* fail if there is a dependency cycle, missing dependencies, or some other trouble *)
	Check[
		listDependencies[Join[packages, hiddenPackages]],
		(
			Message[LoadDistro::Dependencies];
			Return[$Failed]
		)
	];
	
	(* load packages *)
	tLoadPackages = First[AbsoluteTiming[
		Scan[LoadPackage, Join[packages, hiddenPackages]];
	]];

	(* add logging after all definitions have been loaded, but before hidden packages removed  *)
	Core`Private`addLogging[];

	hiddenContexts = Map[packageContext, hiddenPackages];

	(* there should never be a case where ECL` is supposed to be a hidden context *)
	If[MemberQ[hiddenContexts,"ECL`"],
		Message[LoadDistro::HiddenContextECL];
	];
	(* hide unnecessary contexts *)
	$ContextPath=DeleteCases[$ContextPath, Alternatives@@hiddenContexts];

	(* load usage for all $Packages *)
	tLoadUsage = First[AbsoluteTiming[
		LoadUsage[];
	]];

	missingIndices = Select[DocumentationSearch`Private`missingTextSearchIndexes[], StringStartsQ[AbsoluteFileName[packagesRoot]]];
	If[Length[missingIndices] > 0,
		Message[LoadDistro::MissingIndices, missingIndices]
	];

	(* TODO: Ideally, we would ReadProtect our symbols, but this has weird interplay with Options. *)
	(* Prevent the help file system from finding downvalues/upvalues for any function. *)
	System`InformationDump`getInformationData[input_]:=(
		If[StringQ[input],
			With[{sym=Symbol[input]},ECL`Usage[sym]],
			ECL`Usage[input]
		];
		InformationData[
		Append[
			System`InformationDump`iInformationFromExpr[input],
			<|
				"DownValues"->None,
				"OwnValues"->None,
				"UpValues"->None,
				"SubValues"->None
			|>
		]
	]);

	(* At the very end, load the tests so that we can access them in our built distros. *)
	tLoadTests = First[AbsoluteTiming[
		Quiet@ECL`LoadTests[];
	]];
	
	(* 
		If we don't want the provisional functions loaded, then hide them.
		Easier to load and hide, and then reload if requested after startup, 
		versus not loading, then loading when requested later.
		Cost of this is very small
	*)
	If[
		(* always keep them loaded for distro builder (so the definitions get saved) *)
		Not[MatchQ[ECL`$ECLApplication, ECL`DistroBuilder]],
		
		(* hide the provisional functions, which can be reloaded later if needed *)
		hideFunctionDefinitions[Keys[ECL`$ProvisionalFunctions]];
		
	];
	(* make sure provisional loader can be seen *)
	AppendTo[$Path,FileNameJoin[{sllDir, "Packager", "resources", "Provisional"}]];


	tocLoadDistro = AbsoluteTime[];
	

	(*
		these details get logged via TraceExpression at the end of Login call
	*)
	$LoadMetadata = <|
		"DateString" -> DateString[],
		"DistroName" -> name,
		"LazyLoading" -> TrueQ[ECL`$LazyLoading],
		"FastLoad" -> TrueQ[$FastLoad],
		"$VersionNumber"->$VersionNumber,
		"$OperatingSystem" -> $OperatingSystem,
		"Deployed" -> isDeployed,
		(*
			RuleDelayed because its value can't be known until Git package is loaded,
			but that will have happened by the time this is ready to be logged during Login
		*)
		"FastGit" :> $FastGit
	|>;
	
	$LoadTimings = <|
		"LoadDistro" -> tocLoadDistro - ticLoadDistro,
		"Paclets" -> tocPaclets-ticPaclets,
		"PreLoad" -> tPreload,
		"LoadPackages" -> tLoadPackages,
		"LoadFiles" -> tLoadFiles,
		"OnLoadRelesase" -> tOnLoadRelease,
		"SetPackage" -> tSetPackage,
		"PacletDirectoryAdd" -> tPacletDirectoryAdd,
		"MakeSymbols" -> tMakeSymbols,
		"LoadTests" -> tLoadTests,
		"LoadUsage" -> tLoadUsage,
		"DistroConfig" -> tocConfig - ticConfig,
		"Patch13" -> tocPatch13 - ticPatch13,
		"AppendPackagePath" -> tAppendPackagePach,
		"TrustedPath" -> tTrustedPath
	|>;



	config
];


(*
	Place to save definitions that will be hidden, and possibly reloaded later
*)
hiddenFunctionDefinitions = <||>;



hideFunctionDefinitions[funcs:{___Symbol}] := Module[{},
	Map[
		Module[{},
			(* stash the full definition information *)
			hiddenFunctionDefinitions[#] = <|
				"SymbolName" -> #, 
				"FullDefinitions" -> Language`ExtendedDefinition[#]
			|>;
			(* 
				If symbol is already exported and exists as a Field symbol, then it should have
				a few UpValues and SubValues, which we don't want to clear.
				But LazyLoading also adds things to UpValues which we DO want to clear.
			*)
			OwnValues[#]={};
			DownValues[#]={};
			UpValues[#] = DeleteCases[ UpValues[#],  upValuesToDeleteP[#] ];
			NValues[#]={};
			FormatValues[#]={};
			DefaultValues[#]={};
			Messages[#]={};
			Attributes[#]={};
			(* not using Remove here because it does weird things (puts Removed[f] in some places) *)
		]&,
		funcs
	]
];



(*
	functions that add UpValues to symbols.  These are the ones we want to delete.
	There's a few other UpVaules for field symbols that we want to preserve.
*)
upvaluedFunctions = {
	ECL`OptionsHandling`SafeOptions , ECL`OptionsHandling`ValidOptions , 
	ECL`Usage , ECL`OptionDefaults , ECL`OptionDefinition , 
	Options , OptionValue , 
	Packager`FunctionPackage
};

(* generate one pattern for all of the upvalues we want to remove *)
upValuesToDeleteP[callee_] := upValuesToDeleteP[ Alternatives @@ upvaluedFunctions, callee];

(*	pattern for an individual upvalue *)
upValuesToDeleteP[caller_, callee_] :=  Alternatives[
	(*
		Our UpValues look like 
			HoldPattern[SafeOptions[symbol, args] :> rhs
	*)
	(Rule|RuleDelayed)[  Verbatim[HoldPattern] [ caller[callee, ___] ] , _ ] ,
	(*
		or, with LazyLoading enabled, like
			HoldPattern[Condition[SafeOptions[symbol, args], tag ]  :> rhs
	*)
	(Rule|RuleDelayed)[  Verbatim[HoldPattern] [ Verbatim[Condition][ caller[callee, ___], _ ] ], _  ]
];


(*
	If requested, load the provisional symbols by adding back their previously saved definitions 
*)
loadHiddenFunctionDefinitions[funcs:{___Symbol}]:=(	Map[Function[
  	(Language`ExtendedDefinition[#SymbolName] = #FullDefinitions);], 
	KeyTake[hiddenFunctionDefinitions,funcs]
];);


(* this is also used by BuildDistroArchives to log its details *)
(* make sure at least one value exists, otherwise don't match because there's nothing to log *)
logMetadataAndTiming[name_String,metadata:KeyValuePattern[{"DateString"->_}], timings_Association] := Module[{},

	ECL`Web`TraceExpression[
	
		name,
	
		(* tag the trace with metadata *)
		KeyValueMap[
			ECL`Web`TagTrace[
				#1,
				If[StringQ[#2],#2,ToString[#2]]
			]&,
			metadata
		];
		
		(* tag the trace with timings *)
		(* timings get converted to integer centiseconds, with -cs appened to key names*)
		KeyValueMap[
			ECL`Web`TagTrace[
				#1<>"-cs",
				Round[#2*10]
			]&,
			timings
		];

	];

];

(* memoize so only runs at once *)
logLoadDetails[] := logLoadDetails[] = Module[{},
	logMetadataAndTiming["LoadDistro", $LoadMetadata, $LoadTimings];
];


(*
	This changes the help-file-link button to our custom "question mark" image.
	FormatValues[InformationData] uses this to generate the documentation link button
*)
Information[Map]; (* make sure Information's FormatValues are loaded *)
changeHelpIcon = True; (* use this to get our definition to the top, and then block it *)
System`InformationDump`documentationLinkButton[a_] /; changeHelpIcon :=
  Block[{changeHelpIcon = False},
  ReplaceAll[
   System`InformationDump`documentationLinkButton[a], (* their 'i' image *)
   {
    FEPrivate`FrontEndResource["FEBitmaps", "InformationHelpIcon"] ->ToBoxes[questionMarkHelpIcon],
    FEPrivate`FrontEndResource["FEBitmaps", "InformationHelpIconHot"] -> ToBoxes[questionMarkHoverHelpIcon]
    }
   ]
  ];

questionMarkHelpIcon := questionMarkHelpIcon =
		Show[Import[FileNameJoin[{PackageDirectory["Packager`"],"resources","help.png"}],"PNG"],ImageSize->11];

questionMarkHoverHelpIcon := questionMarkHoverHelpIcon =
		Show[Import[FileNameJoin[{PackageDirectory["Packager`"],"resources","help-hover.png"}],"PNG"],ImageSize->11];


isDesktopMathematica[]:=$FrontEnd =!= Null && CurrentValue[$FrontEnd, "PluginEnabled"] === False;

isPrivateCloud[] := Not[MatchQ[$CloudVersion, None]];

findLoops[graph_Graph]:=Module[
	{edges},
	edges = EdgeList[graph];
	Select[edges, First[#] === Last[#]&]
];

listDependencies[packages:{___String}]:=Module[
	{graph, dependencyPackages, missingPackages},

	graph = PackageGraph[packages];

	(* find cycles *)
	If[Not[AcyclicGraphQ[graph]],
		Message[LoadDistro::Cycle, FindCycle[graph]];
		Return[$Failed]
	];

	(* find loops *)
	If[Not[LoopFreeGraphQ[graph]],
		Message[LoadDistro::Loop, findLoops[graph]];
		Return[$Failed]
	];

	dependencyPackages = dependenciesOfPackages[packages, graph];

	missingPackages = Complement[dependencyPackages, packages];
	If[Length[missingPackages] > 0,

		Message[
			LoadDistro::MissingPackages,
			missingPackages,
			Map[Complement[VertexInComponent[graph, #, 1], {#}]&, missingPackages]
		];
		Return[$Failed]
	];

	dependencyPackages
];

dependenciesOfPackages[packages: {_String ...}, graph_Graph]:=Select[
	VertexOutComponent[graph, packages],
	PackageQ
];

packageContext[package_String]:=Lookup[PackageMetadata[package], "Context"];

(*Always append Packager` to the package path*)
AppendPackagePath[ParentDirectory[DirectoryName[$InputFileName]]];


(* Set FunctionPackage for all public symbols in Packager`*)
Map[
	Set[FunctionPackage[#],"Packager`"]&,
	{
		NewPackage,
		AppendPackagePath,
		PackageMetadata,
		PackageDirectory,
		DirectoryPackage,
		PackageDocumentationDirectory,
		PackageQ,
		KernelVersionMatchQ,
   		ListPacletVersions,
		IncludeContexts,
		SearchRemote,
		LoadPackage,
		ReloadPackage,
		OnLoad,
		FunctionPackage,
		SymbolPackageName,
		AvailablePackages,
		PackageGraph,
		PackageSymbols,
		SymbolPackages,
		PackageFunctions,
		PackageSources,
		PackagesRootDirectories,
		PackagesGraph,
		LoadUsage,
		DistroMetadata,
		LoadDistro,
		WritePackageMx,
		$DebugLoading,
		$DebugLoadingThreshold,
		ReloadManifest
	}
];



(*
	Load the FastLoad file.  
*)
packagerDirectory = DirectoryName[$InputFileName];
fastLoadFile = FileNameJoin[{packagerDirectory, "FastLoad.m"}];
(* force it to Boolean, defaulting to False *)
$FastLoad = TrueQ[$FastLoad];
(* this gets set to True in FastLoad file (for testing/logging purposes) *) 
fastLoadWasLoaded = False; 

If[	TrueQ[$FastLoad], 
	Get[fastLoadFile]
];


End[];
EndPackage[];
