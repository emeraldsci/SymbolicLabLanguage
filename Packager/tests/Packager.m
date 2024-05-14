(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*OnLoad*)

DefineTests[hideFunctionDefinitions,{
	Test["Hide function defnition:",
		(* block this so we don't pollute the real list of hidden functions *)
		Block[{Packager`Private`hiddenFunctionDefinitions=<||>},
			Module[{f,g},
				f[x_] := 1;
				g[x_] := 2;
				(* hiding f should wipe out its downvalues *)
				hideFunctionDefinitions[{f}];
				DownValues/@{f,g}
			]],
		(* g should still have its definition because it wasn't hidden *)
		{{},{_RuleDelayed}}
	]
}];

DefineTests[loadHiddenFunctionDefinitions,{
	Test["Restores definitions for things that have been hidden:",
		Block[{Packager`Private`hiddenFunctionDefinitions=<||>},
			Module[{f,g,afterHiding,afterRestoring},
				f[x_] := 1;
				g[x_] :=2;
				(* hide f AND g *)
				hideFunctionDefinitions[{f,g}];
				afterHiding = DownValues /@ {f,g};
				(* restory ONLY f *)
				loadHiddenFunctionDefinitions[{f}];
				afterRestoring = DownValues /@ {f,g};
				{
					afterHiding,
					afterRestoring
				}
			]
		],
		{
			(* both shoulde be empty *)
			{{}, {}},
			(* f should be restored, with g still empty *)
			{{_RuleDelayed}, {}}
		}
	],

	Test["<<Provisional` triggers call to loadHiddenFunctionDefinitions on $ProvisionalFunctions:",
		Module[{f},
			(* block this with a fake value so we don't depend on real state *)
			Block[{$ProvisionalFunctions = <| f->1|>, loadHiddenFunctionDefinitions},
				(* block this to throw because we only care that it's called with 'f' as its argument*)
				loadHiddenFunctionDefinitions[in_] := Throw[in,"ProvisionalLoaded"];
				(* this effectively loadHiddenFunctionDefinitions[Keys[$ProvisionalFunctions]] *)
				Catch[<<Provisional`,"ProvisionalLoaded"]
			]
		],
		(* f with some garbage after it*)
		{_Symbol?(StringStartsQ[SymbolName[#],"f$"]&)}
	]
}];


DefineTests[
	OnLoad,
	{
		Example[{Basic,"Use OnLoad[...] to install expressions that should be evaluated after the entire package is finished loading:"},
			Block[{Packager`Private`$Package="TestPackage`"},
				OnLoad[1+1]
			],
			Null
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*DistroMetadata*)

DefineTests[
	DistroMetadata,
	{
		Example[{Basic,"Returns metadata for a given distro JSON file:"},
			DistroMetadata[FileNameJoin@{$EmeraldPath, "distros/SLL.json"}],
			_Association
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*WritePackageMx*)

DefineTests[
	WritePackageMx,
	{
		Example[{Basic,"Write a package mx for a package:"},
			WritePackageMx["Widgets`"],
			Null
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*ReloadManifest*)

DefineTests[
	ReloadManifest,
	{
		Example[{Basic,"Export all of the symbols in a manifest:"},
			ReloadManifest["Widgets`"],
			Null
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*ReloadPackage*)

DefineTests[
	ReloadPackage,
	{
		Example[{Basic,"Reload all of the code within a package:"},
			ReloadPackage["Widgets`"],
			Null
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*ReloadFile*)
DefineTests[
	ReloadFile,
	{
		Example[{Basic,"Reload all of the code within a specific file:"},
			ReloadFile["InternalExperiment`", "Centrifuge\\Primitives.m"],
			"InternalExperiment`"
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*NewPackage*)

DefineTests[
	NewPackage,
	{
		Example[{Basic,"Use NewPackage to create a new package:"},
			NewPackage[$EmeraldPath, "Songs`"],
			Null
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*LoadDistro*)

DefineTests[
	LoadDistro,
	{
		Example[{Basic,"Load the SLL distro from the JSON file:"},
			LoadDistro[FileNameJoin@{$EmeraldPath, "distros", "Dev2.json"}],
			_Association
		]
	},
	Skip->"Packager"
];

(* ::Subsubsection::Closed:: *)
(*LoadPackage*)

DefineTests[
	LoadPackage,
	{
		Example[{Basic,"Load the Options` package:"},
			LoadPackage["Options`"],
			"Options`"
		],

		Example[{Basic,"Load a Mathematica package:"},
			LoadPackage["GeneralUtilities`"],
			"GeneralUtilities`",
			Stubs:>{
				$ContextPath=$ContextPath
			}
		],

		Example[{Basic,"Returns $Failed if the package doesn't exist:"},
			LoadPackage["DoesNotExist`"],
			$Failed,
			Messages:>{
				Get::noopen,
				Needs::nocont
			}
		],

		Example[{Messages, "Context", "Messages if there's a context problem:"},
			Hold[xyz],
			_Hold
		],

		Example[{Messages, "MXFailed", "Messages if there's a MX file problem:"},
			Hold[xyz],
			_Hold
		],

		Example[{Messages, "NewSymbol", "Messages if there's a NewSymbol problem:"},
			Hold[xyz],
			_Hold
		],

		Example[{Messages, "NotFound", "Messages if there's a NotFound problem:"},
			Hold[xyz],
			_Hold
		],

		Example[{Messages, "Values", "Messages if there's a Values problem:"},
			Hold[xyz],
			_Hold
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*AppendPackagePath*)

DefineTests[
	AppendPackagePath,
	{
		Example[{Basic,"Add all the packages in SLL to the search path:"},
			AppendPackagePath[$EmeraldPath],
			{__String}
		],

		Example[{Basic,"Returns an empty list of the given directory has no package manifests:"},
			With[
				{path=CreateDirectory[FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]]},
				AppendPackagePath[path]
			],
			{}
		],

		Example[{Messages,"Directory","Returns $Failed if the given path is not a directory:"},
			AppendPackagePath["NotADirectory"],
			$Failed,
			Messages:>{
				AppendPackagePath::Directory
			}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*AvailablePackages*)

DefineTests[
	AvailablePackages,
	{
		Example[{Basic,"List the packages available for loading:"},
			AvailablePackages[],
			{__String}
		],

		Example[{Basic,"If there are no packages available to load, returns an empty list:"},
			AvailablePackages[],
			{},
			Stubs:>{
				packageMetadata=<||>
			}
		],

		Example[{Applications,"Load the first available package:"},
			LoadPackage[First[AvailablePackages[]]],
			_String,
			Stubs:>{
				$ContextPath=$ContextPath
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FunctionPackage*)

DefineTests[
	FunctionPackage,
	{
		Example[{Basic,"Find the package Download is defined in:"},
			FunctionPackage[Download],
			"Constellation`"
		],

		Example[{Basic,"Returns $Failed for Mathematica build-in symbols:"},
			FunctionPackage[Map],
			$Failed
		],

		Example[{Applications,"Get package metadata for the package that the symbol DefineOptions is in:"},
			PackageMetadata[FunctionPackage[DefineOptions]],
			_Association
		],

		Example[{Attributes, HoldFirst, "Holds its first argument:"},
			Hold[FunctionPackage[SOME CRAZY EXPRESSION]],
			_Hold
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*LoadUsage*)

DefineTests[
	LoadUsage,
	{
		Example[{Basic,"Load the usage files for all current loaded packages:"},
			LoadUsage[],
			{__String}
		],

		Example[{Basic,"Load the usage files for the Constellation` package:"},
			LoadUsage["Constellation`"],
			"Constellation`"
		],

		Example[{Messages,"NotFound","Returns $Failed if the given input is not an ECL package:"},
			LoadUsage["NotAPackage`"],
			$Failed,
			Messages:>{
				Message[LoadUsage::NotFound,"NotAPackage`"]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackageDirectory*)

DefineTests[
	PackageDirectory,
	{
		Example[{Basic,"Return the directory of a loaded package:"},
			PackageDirectory["Experiment`"],
			FilePathP
		],

		Example[{Basic,"Use directory to create a filepath:"},
			FileNameJoin[Join[{PackageDirectory["Experiment`"]}, {"sources", "HPLC", "Experiment.m"}]],
			FilePathP
		],

		Example[{Messages,"NotFound","Returns $Failed if the given input is not an ECL package:"},
			PackageDirectory["NotAPackage`"],
			$Failed,
			Messages:>{
				Message[PackageDirectory::NotFound,"NotAPackage`"]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackageDocumentationDirectory*)

DefineTests[
	PackageDocumentationDirectory,
	{
		Example[{Basic,"Return the directory of a loaded package's documentation files:"},
			PackageDocumentationDirectory["Experiment`"],
			FilePathP
		],

		Example[{Basic,"Return the directory of a loaded package's documentation files:"},
			PackageDocumentationDirectory["Core`"],
			FilePathP
		],

		Example[{Messages,"NotFound","Returns $Failed if the given input is not an ECL package:"},
			PackageDocumentationDirectory["NotAPackage`"],
			$Failed,
			Messages:>{
				Message[PackageDirectory::NotFound,"NotAPackage`"]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackageFunctions*)

DefineTests[
	PackageFunctions,
	{
		Example[{Basic,"Return list of all exported functions in a package:"},
			PackageFunctions["Core`"],
			{_String..}
		],

		Example[{Basic,"Return nothing if package is invalid:"},
			PackageFunctions["NotAPackage`"],
			{}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PackageGraph*)

DefineTests[
	PackageGraph,
	{
		Example[{Basic,"Return graph of all package dependencies in SLL:"},
			PackageGraph[],
			_Graph
		],

		Example[{Basic,"Return graph of package dependencies for a specific package(s):"},
			PackageGraph[{"Core`"}],
			_Graph
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PackagesGraph*)

DefineTests[
	PackagesGraph,
	{
		Example[{Basic,"Return graph of all package dependencies in SLL:"},
			PackagesGraph[],
			_Graph
		],

		Example[{Basic,"Return graph of all package dependencies in SLL:"},
			PackagesGraph[],
			_Graph
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackageMetadata*)

DefineTests[
	PackageMetadata,
	{
		Example[{Basic,"Returns all information about a loaded package:"},
			PackageMetadata["Experiment`"],
			_Association
		],

		Example[{Basic,"Keys include many pieces of meta-information related to the package:"},
			Keys[PackageMetadata["Experiment`"]],
			{_String..}
		],

		Example[{Messages,"NotFound","Returns $Failed if the given input is not an ECL package:"},
			PackageMetadata["NotAPackage`"],
			$Failed,
			Messages:>{
				Message[PackageMetadata::NotFound,"NotAPackage`"]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PackageQ*)

DefineTests[
	PackageQ,
	{
		Example[{Basic,"Returns True if package exists in SLL:"},
			PackageQ["Experiment`"],
			True
		],

		Example[{Basic,"Returns False if package does not exist in SLL:"},
			PackageQ["NotAPackage`"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*PackageSources*)

DefineTests[
	PackageSources,
	{
		Example[{Basic,"Returns all source files for a loaded package:"},
			PackageSources[PackageMetadata["Experiment`"]],
			{FilePathP..}
		],

		Example[{Basic,"Does not evaluate on an invalid metadata association:"},
			PackageSources[PackageMetadata["NotAPackage`"]],
			_PackageSources,
			Messages:>{
				Message[PackageMetadata::NotFound,"NotAPackage`"]
			}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackagesRootDirectories*)

DefineTests[
	PackagesRootDirectories,
	{
		Example[{Basic,"Returns the location of all SLL root directory:"},
			PackagesRootDirectories[],
			{FilePathP..}
		],

		Example[{Basic,"Typically just includes a single root, but can include multiple:"},
			PackagesRootDirectories[],
			{FilePathP..}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PackageSymbols*)

DefineTests[
	PackageSymbols,
	{
		Example[{Basic,"Returns all exported symbols from a SLL package:"},
			PackageSymbols["Core`"],
			{_String..}
		],

		Example[{Basic,"Returns all exported symbols from a SLL package:"},
			PackageSymbols["Experiment`"],
			{_String..}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*SymbolPackageName*)

DefineTests[
	SymbolPackageName,
	{
		Example[{Basic,"Returns the package the given symbol is defined in:"},
			SymbolPackageName[Incubate],
			_String
		],

		Example[{Basic,"Returns Failed if symbol does not exist:"},
			Module[{TestSymbol},
				SymbolPackageName[TestSymbol];
				If[MatchQ[SymbolPackageName[TestSymbol],"Packager"],
				$Failed
				]
			],
			$Failed
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*SymbolPackages*)

DefineTests[
	SymbolPackages,
	{
		Example[{Basic,"Returns the package(s) associated with the specified symbol:"},
			SymbolPackages[Experiment],
			{_String..}
		],
		Example[{Basic,"Returns empty list if symbol is not found in any packages:"},
			SymbolPackages[TestSymbol],
			{}
		],
		Example[{Basic,"Returns the package(s) associated with the specified string name:"},
			SymbolPackages["Experiment"],
			{_String..}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*DirectoryPackage*)

DefineTests[
	DirectoryPackage,
	{
		Example[{Basic,"Returns the package of the specified file:"},
			DirectoryPackage[FileNameJoin[{$EmeraldPath, "Experiment", "sources", "AdjustpH", "Experiment.m"}]],
			"Experiment`"
		],
		Example[{Basic,"Returns $Failed if the file is not belongs to any package:"},
			DirectoryPackage[FileNameJoin[{$EmeraldPath, "TestPackage"}]],
			$Failed
		],
		Example[{Basic,"Returns the package of the specified folder:"},
			DirectoryPackage[FileNameJoin[{$EmeraldPath, "InternalExperiment", "sources", "Instruments"}]],
			"InternalExperiment`"
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*ListPacletVersions*)

DefineTests[
	ListPacletVersions,
	{
		Example[{Basic,"Returns a list of associations showing {Version,MathematicaVersion,Location} of the specified Paclet or all Paclets:"},
			Module[{association},
				association=ListPacletVersions["XLTools"];
				MatchQ[association,	{KeyValuePattern["Name" -> "XLTools"]}]
			],
			True
		],
		Example[{Basic,"Returns {} if the Paclet is not loaded:"},
			ListPacletVersions["NonExistingOne"],
			{}
		],
		Example[{Basic,"Returns all loaded Paclets if not specified any inputs:"},
			Module[{association},
				association=ListPacletVersions["XLTools"];
				MatchQ[
					association,
					{<|"Name" -> _, "Version" -> _, "MathematicaVersion" -> _, "Location" -> _|> ..}
				]
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*KernelVersionMatchQ*)

DefineTests[
	KernelVersionMatchQ,
	{
		Example[{Basic,"Return True if the input string match the version we are using:"},
			Module[
				{currentVersion},
				
				(* get the version of what MM is running at  *)
				currentVersion=StringTake[$Version, 6];
				
				KernelVersionMatchQ[currentVersion]
			],
			True
		],
		Example[{Basic,"Return False if input string is not matching:"},
			KernelVersionMatchQ["Non Existing Version"],
			False
		]
	}
];

(*
	These tests rely heavily on the internal structure of loadPaclet,
	and only work by stubbing out throwing from intermediate steps that 
	are hit in different situations

*)
DefineTests[loadPaclet,{
	Test["Already have correct paclet: ",
	Block[{PacletInstall=Null,PacletUninstall=Null},
		Catch[Packager`Private`loadPaclet[<|"Name"->"TestPaclet","Version"->"TestVersion"|>,"TestPath"]]
	],
	True,
	Stubs:>{
		Packager`Private`lookupPacletVersion["TestPaclet"]="TestVersion",
		Packager`Private`lookupPacletByName["TestPaclet"] = True
	}	
],

Test["Have wrong version, but leave it be: ",
	Block[{$ForcePacletVersions=False,FileNameJoin},
		FileNameJoin[args___]:=Throw[True];
		Catch[Packager`Private`loadPaclet[<|"Name"->"TestPaclet","Version"->"TestVersion"|>,"TestPath"]]
	],
	True,
	Stubs:>{
		Packager`Private`lookupPacletVersion[name_]:=("OtherVersion"),
		Packager`Private`lookupPacletByName[name_] := (False),
		PacletUninstall[_] := (Throw[False])
	}	
],

Test["Have wrong version, replace it: ",
	Block[{
		Packager`$ForcePacletVersions = True,
		Packager`$LogPacletChanges = False},
		Catch[Packager`Private`loadPaclet[<|"Name"->"TestPaclet","Version"->"TestVersion"|>,"TestPath"]]
	],
	True,
	Stubs:>{
		Packager`Private`lookupPacletVersion["TestPaclet"]:="OtherVersion",
		Packager`Private`lookupPacletByName["TestPaclet"] := False,
		PacletInstall[_]:= (Throw[False]),
		PacletUninstall[_] := (Throw[True]),
		Scan[PacletUninstall, _] := PacletUninstall["blah"]
	}	
],

Test["Have wrong version, replace it, and log the changes: ",
	Block[
		{
			Packager`$ForcePacletVersions = True,
			Packager`$LogPacletChanges = True,
			$UserBasePacletsDirectory = "/Path/To/Paclets/"
		},
		Packager`Private`loadPaclet[<|"Name" -> "TestPaclet", "Version" -> "TestVersion"|>, "TestPath"]
	],
	(* The test result looks a little wonky because of the blocking/stubbing,
	but the main goal is to check the general format of the return. *)
	<|
		"$ForcePacletVersions" -> True,
		"$UserBasePacletsDirectory" -> "/Path/To/Paclets/",
		"UninstallablePaclets" -> {},
		"InstalledPaclets" -> False
	|>,
	Stubs :> {
		Packager`Private`lookupPacletVersion["TestPaclet"] := "OtherVersion",
		Packager`Private`lookupPacletByName["TestPaclet"] := False,
		PacletInstall[_] := Null,
		PacletUninstall[_] := Null
	}
]

}];



(*
	Check that the FastLoad file was or was not loaded, depending on $FastLoad.
	This is the truest test that things did or didn't happen.
*)
DefineTests[fastLoadMatches,
	{
		Test["$FastLoad flag value matches fastLoadWasLoaded value:",
			(* 
				the SameQ check is the one we actually care about.
				But we include the values of the others as a reference of 
				the actual loading state, and to help diagnose problems if things go wrong 
			*)
			{
				$FastLoad, 
				Packager`Private`fastLoadWasLoaded, 
				SameQ[TrueQ[$FastLoad], Packager`Private`fastLoadWasLoaded]
			},
			{_, _, True}
		]

	}
];
