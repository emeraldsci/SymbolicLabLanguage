# Packager
## Working With Packages
### Context vs Packages
Previously, _Context_ & _Package_ were synonymous. Now, however, all functions we create will be in the _ECL\`_ context and the idea of a _Package_ is a construct we have created to organize our code. So the _Package_ Options\` defines all the functions for dealing with options (DefineOptions, OptionDefaults, etc) and all those symbols have the Mathematica _Context_ ECL\`.

### Find the packages which defines a function
When looking to update a function you may first need to determine which package it is defined in. With _SLL\`_ loaded, use the function _FunctionPackage_ to determine which package a function was defined in.
If the symbol has no OwnValues or DownValues, this will return the first package to list the symbol in its manifest. You can then use the function _PackageDirectory_ to find the folder that the package lives in. The sources files for this package will then be in the sub-folder _sources_.

```mathematica
In[1] := Get["SLL`"]
Out[1] = "SLL`"

In[2] := FunctionPackage[ExperimentHPLC]
Out[2] = "Experiment`"

In[3] := PackageDirectory["Experiment`"]
Out[3] = "/Users/sean/Repositories/SLL/Experiment"
```

The folder structure of the SLL repository looks something like this:

```
| - SLL
	| - docs
	| - resources
	| - sources
		| - SLL.m
		| - Inventory.m
		...
	| - tests
	| - manifest.json
...
```

The function _Download_ is defined in `/Users/sean/Repositories/SLL/Constellation/sources/SLL.m` which is one of the source files of the _Constellation\`_ package. To open this in Mathematica directly, you can use the function _OpenSourceCode_ to open the notebook for a function definition.

```mathematica
In[1] := OpenSourceCode[Download]
Out[1] = NotebookObject[1]
```

### Find the packages a symbol belongs to

While any given symbol will only ever have _one_ "FunctionPackage" (the package which defines its DownValues/OwnValues), it may be listed in _multiple_ packages. For example, some fields in objects (such as _BindingEnthalpy_) are also functions:

```mathematica
In[1] := FunctionPackage[BindingEnthalpy]
Out[1] = "Simulation`"

In[2] := SymbolPackages[BindingEnthalpy]
Out[2] = {"Simulation`", "Objects`"}
```

### Add a function to a package
#### Define the public symbol
In the Packager framework, we must be explicit about the symbols that are exported publicly from a package. These symbols are listed in the _manifest_ file for the package location in the <package directory>/manifest.json. For example, the manifest for the _Emerald\`Either\`_ package looks like so:

```json
{
    "package": "Either`",
    "context": "ECL`",
    "description": "Either",
    "dependencies": [
        "Options`",
        "Usage`"
    ],
    "sources": [
        "Either.m"
    ],
    "symbols": [
        "Either",
        "EitherError",
        "EitherErrorQ",
        "EitherValue",
        "EitherValueQ",
        "ErrorComposition",
        "ErrorFold",
        "ErrorIfFalse",
        "ErrorIfMessages",
        "PassError",
        "ToMessage",
        "ToValue"
    ]
}
```

All the publicly exported symbols for this package are listed as strings in the _"symbols"_ list. If we want to add a new _public_ function, we must add it's name to this list.

#### Add the function definition
The implementation for all functions in a package are in the .m files in the <package directory>/sources folder. These files must be listed in the _"sources"_ list of the package manifest. These can be nested within as many folders _inside_ the sources directory as desired and the path listed in the _"sources"_ list assumes <package directory>/sources folder as the root. For example, if I created a new source file at SLL/Either/sources/MyNewFolder/MyNewFile.m then the sources list in the manifest would look like the following:

```json
{
    "package": "Either`",
    "context": "ECL`",
    "description": "Either",
    "dependencies": [
        "Options`",
        "Usage`"
    ],
    "sources": [
        "Either.m",
        "MyNewFolder/MyNewFile.m"
    ],
    "symbols": [
        "Either",
        "EitherError",
        "EitherErrorQ",
        "EitherValue",
        "EitherValueQ",
        "ErrorComposition",
        "ErrorFold",
        "ErrorIfFalse",
        "ErrorIfMessages",
        "PassError",
        "ToMessage",
        "ToValue"
    ]
}
```

This file will now be loaded when the _Emerald\`Either\`_ package is loaded. Add your code to the .m files as normal except do _not_ use any of `BeginPackage`, `EndPackage`, `Begin`, or `End` in the source files. The framework takes care of loading all the source files in the order specified in the _"sources"_ list inside a private context for the package.

#### Add Documentation
Usage rules for public functions no longer exists in a "Help Files" section at the top of the source files. Now, all usage rules should be defined in a .m file in the _docs_ directory which mirrors the name of the source file the function is defined in. For example, the function _EitherError_ defined in the source file _SLL/Either/sources/Either.m_ should have a corresponding documentation file at _SLL/Either/docs/reference\_pages/Either.m_. Inside this file the usage rules for the function should be defined as normal using _DefineUsage_. These usage rules will be loaded when appropriate by the Packager framework.

Once the usage rules for a function are defined, you can use the function _LoadUsage_ to reload the usage for your package and then call _SyncDocumentation_ on your new function to generate the documentation notebook.

#### Add Tests
Defining tests is almost the same as before, however, the tests files should be located inside the package directory inside the _tests_ sub-folder. For example, there is a test file _SLL/Either/tests/Either.m_ that contains the test files for the functions defined in _SLL/Either/sources/Either.m_.

### Remove a function from a package
Removing a _public function_ from a package involves deleting things from a few different places.

1. Remove the function name from the _"symbols"_ list in the manifest for the package (`package directory>/manifest.json`).
2. Remove the function implementation from the source files in the `<package directory>/sources` folder.
3. Remove the tests for the function from the test files in the `<package directory>/tests` folder.
4. Remove the usage rules for the function from the documentation files in the `<package directory>/docs/reference_pages` folder.
5. Remove the documentation notebook `<package directory>/Documentation/English/ReferencePages/Symbols/<function name>.nb`

### Side-Effects on load
In certain circumstances, you may need to execute some piece of code _every time a package is loaded_. This comes up when modifying the state of Mathematica built-in functions (such as MakeBoxes for summary blobs). In the Packager framework, it is necessary to to be explicit about this since automatic generation of MX files means the source files are not re-evaluate once the packages have been built for distribution. This means that any functions in those source files which have side-effects will not be re-evaluated. For example, setting the _$OutputSizeLimit_ configuration variable:

```mathematica
$OutputSizeLimit = 2048;
```

If we want this to guarantee this happens whenever the package is loaded, then we can wrap the expression in the function _OnLoad_. To do this, you must first add the _Packager\`_ package to the dependencies list manifest for the package you are working on. Then, in the source file do the following:


```mathematica
OnLoad[$OutputSizeLimit = 2048];
```

Now, whenever _Emerald\`Core\`_ is loaded, `$OutputSizeLimit = 2048` will be evaluated. It is important to note that this is not evaluated until _after_ all the source files are loaded for that package.

### Reloading Packages
In the past, you may have had some success reloading only a specific context without reloading all of _SLL\`_. This is convenient for iterating on function definitions, however, you can never be certain you will end up in an correct state given that many packages have side-effects on load. This continues to be true with the Packager framework, however, there exist tools to facilitate this. You can only use _Get_ to load _SLL\`_, to load specific packages in the Packager framework, you _must use LoadPackage_. In this case, however, it will not work:

```mathematica
In[1] := <<SLL`
Out[1] = "SLL`"

In[2] := LoadPackage["Experiment`"]
Out[2] = "Experiment`"
```

This will not work because _LoadPackage_ does not re-load any source files if the package has already been loaded. To get around this, we can use the function _ReloadPackage_. This clears the symbols in the package and reload all the source files. This is done outside of the normal load-order of all the packages so you can still end up in an inconsistent state.

***Use With Caution!***

```mathematica
In[1] := <<SLL`
Out[1] = "SLL`"

In[2] := ReloadPackage["Experiment`"]
Out[2] = "Experiment`"
```

### Loading Specific Packages

Since we have built a system on top of the Mathematica context/paclet systems, one cannot simply use Get/Needs to load individual packages (as one can for Mathematica packages). Whenever you need to load a package, use the function _LoadPackage_ defined in the _Packager`_ context. The only exceptions to this are for _SLL\`_, and _SLL\`Dev\`_ as these have all been set up to load the necessary packages. If, however, there was a specific package you were working on and you didn't want to load everything (for example if you were working on the options functions in _Options\`_ or something similar), you could just load that package and the framework will take care of loading the necessary dependencies.

In order for packages to be found, they must first be added to the _Package Path_. To do this, use the function _AppendPackagePath_ which takes a directory as input and finds all packages defined inside that directory and its sub-directories. LoadPackage will look on the _Package Path_ to try and find a package which defines _"Options`"_ and load all its symbols and dependencies. If it cannot find a package, it will fall back to the Mathematica function _Needs_ (this way, _LoadPackage_ can be used for both Mathematica paclets and Packager packages).

```mathematica
In[1] := AppendPackagePath["/Users/emerald/Repositories/SLL"]
Out[1] = {"Usage`", "Options`", "Objects`"}
```

Now that the _"Options`"_ package is on the path, it can be loaded using _LoadPackage_:

```mathematica
In[2] := LoadPackage["Options`"]
Out[2] = "Options`"
```

Now that the _Options\`_ package is loaded, all symbols defined in that package can be used.

## Creating a New Package
### Using NewPackage
To create a new package, one should use the function _NewPackage_ (defined in the _Packager\`_ context). This will create a skeleton folder structure for your new package with a given name. For example:

```mathematica
In[1] := NewPackage["/Users/emerald/Repositories/SLL", "Songs`"]
Out[1] = "/Users/emerald/Repositories/SLL/Songs"
```

This creates a new folder _Songs_ in the directory provided as the first argument. Looking at the contents of the _Songs_ directory, one will see the following:

```mathematica
| - Songs
	| - FrontEnd
	| - docs
		| - guides
		| - reference_pages
		| - tutorials
	| - manifest.json
	| - resources
	| - sources
	| - tests
```

The following sections will go into greater detail about each of the activities associated with creating a new package.

### Edit context & package name
Open the _manifest.json_ file (this is where all the metadata for a package is defined). It should look like the following:

```json
{
    "package": "Song`",
    "context": "ECL`",
    "description": "Insert Description Here",
    "dependencies": [],
    "sources": [],
    "symbols": []
}
```
The above is a set of key/value pairs which define everything about the package we are creating. First we need to decide what _context_ all the symbols in our package should be defined in. Typically, we want all our symbols to exist in the _ECL\`_ context (this is the default). There are only a handful of cases right now where we will use a different context than SLL` for things like the ISE but every function that will be called by a user needs to be in the _ECL\`_ context. For the purposes of this exercise, lets put them in the _ECL\`Songs\`_ context. Edit the _"context"_ entry to reflect this:

```json
{
    "package": "Songs`",
    "context": "ECL`Songs`",
    "description": "Insert Description Here",
    "dependencies": [],
    "sources": [],
    "symbols": []
}
```

Next lets add a description to the package to give consumers of the package an idea what its purpose is. Edit the _"description"_ entry to reflect this:

```json
{
    "package": "Songs`",
    "context": "SLL`Songs`",
    "description": "This is where we put goofy stuff that should never be seen by users or loaded normally.",
    "dependencies": [],
    "sources": [],
    "symbols": []
}
```

We now have a functioning package that effectively loads nothing! Lets move on and add some functions to our package.

### Defining public symbols
We're going to add 2 functions to our package: _SeemsReasonableQ_ & _PumpUp_. To do this, we must define these two symbols as public symbols for our package. Open up the _manifest.json_ and edit the _"symbols"_ entry as follows to add these two functions as public symbols:

```json
{
    "package": "Songs`",
    "context": "SLL`Songs`",
    "description": "This is where we put goofy stuff that should never be seen by users or loaded normally.",
    "dependencies": [],
    "sources": [],
    "symbols": [
	    "PumpUp",
		"SeemsReasonableQ"
    ]
}
```

If you were now to load this package, you would see these two symbols each with the context _ECL\`Songs\`_.

Starting from a clean launch of Mathematica, load the _Packager\`_ framework:

```mathematica
In[1] := <<SLL`Packager`
Out[1] = "SLL`Packager`"
```

Next add the package we just created to the _Package Path_:


```mathematica
In[2] := AppendPackagePath["/Users/emerald/Repositories/SLL"]
Out[2] = {"Songs`"}
```

Load the package _Songs\`_:

```mathematica
In[3] := LoadPackage["Songs`"]
Out[3] = "Songs`"
```

Verify the context of _SeemsReasonableQ_ is _ECL\`Songs\`_:

```mathematica
In[4] := Context[SeemsReasonableQ]
Out[4] = "ECL`Songs`"
```

Neither _SeemsReasonableQ_ or _PumpUp_ do anything yet as we have no source files implementing either of these functions. We will add those next.

### Adding source files
Lets add a new source file to implement _SeemsReasonableQ_. Create a new .m file in Songs/sources/Goofy.m (this file can have any name you want). Your folder structure should now look like this:

```
| - Songs
	| - FrontEnd
	| - docs
		| - guides
		| - reference_pages
		| - tutorials
	| - manifest.json
	| - resources
	| - sources
		| - Goofy.m
	| - tests
```

Now open up Goofy.m and add the following implementation:

```mathematica
SeemsReasonableQ[_String]:=RandomChoice[{True,False}];
```

Finally, open up the _manifest.json_ again and add "Goofy.m" to the _"sources"_ entry of the manifest:

```json
{
    "package": "Songs`",
    "context": "ECL`Songs`",
    "description": "This is where we put goofy stuff that should never be seen by users or loaded normally.",
    "dependencies": [],
    "sources": [
    	"Goofy.m"
    ],
    "symbols": [
        "PumpUp",
    	"SeemsReasonableQ"
    ]
}
```

Now when we load the _Songs`_ package, Goofy.m will be loaded to define the implementation of _SeemsReasonableQ_ (defining the function _PumpUp_ is left as an exercise to the reader).

You can have as many source files as you need and they will be loaded in the order specified in the _"sources"_ list (they must all be inside the _sources_ directory of the package). Even though all these source files are loaded in the same context, order is still important! You cannot use a function before it is defined or the symbol/expression will remain unevaluated.

**Note:** one _should not_ use any of the functions _BeginPackage_,_EndPackage_,_Begin_, or _End_ as all the manipulations of the _$ContextPath_ and _$Context_ are now done by the _Packager\`_ framework based on what is specified in the manifest file.


### Adding Function Documentation
Documentation for functions exists in a different .m file (which can be optionally loaded) from the function source file. The documentation for individual functions exists in .m files inside the _docs/reference\_pages_ directory. Add a new documentation file _docs/reference\_pages/Goofy.m_, the folder structure should now look like this:

```
| - Songs
	| - FrontEnd
	| - docs
		| - guides
		| - reference_pages
			| - Goofy.m
		| - tutorials
	| - manifest.json
	| - resources
	| - sources
		| - Goofy.m
	| - tests
```

Inside _docs/reference_pages/Goofy.m_ add some Usage rules for _SeemsReasonableQ_:

```mathematica
(* ::Subsubsection::Closed:: *)
(*SeemsReasonableQ*)


DefineUsage[SeemsReasonableQ,
{
	BasicDefinitions->
		{
			{"SeemsReasonableQ[question]","bool","returns True if the 'question' posed seems \"reasonable\"."}
		},
	Input:>
		{
			{"question",_String,"Question to ask"}
		},
	Output:>
	{
			{"bool", True|False, "Boolean value representing \"reasonable-ness\" of the question."}
	},
	SeeAlso->
		{
		"RandomChoice"
		},
	Author->{"you"}
}];
```

You should now be able to sync the documentation for the _SeemsReasonableQ_ function after re-loading the _Songs\`_ package. This will generate a documentation notebook inside the _Songs/Documentation_ folder which will be accessible via the standard Mathematica help system.


### Adding Tests
Similar to the function documentation, tests for functions should exist in a separate file in the package directory. All test files should be nested under the _tests_ directory. Lets add a file _tests/Goofy.m_ to hold our tests for _SeemsReasonableQ_. The folder structure should now look like this:

```
| - Songs
	| - FrontEnd
	| - docs
		| - guides
		| - reference_pages
			| - Goofy.m
		| - tutorials
	| - manifest.json
	| - resources
	| - sources
		| - Goofy.m
	| - tests
		| - Goofy.m
```

Open the _tests/Goofy.m_ file and add a test for _SeemsReasonableQ_:

```mathematica
(* ::Subsubsection::Closed:: *)
(*SeemsReasonableQ*)


DefineTests[
	SeemsReasonableQ,
	{
		Test["Returns a True|False response for the reasonable-ness of a question string:"],
			SeemsReasonableQ["Delete all the objects?"],
			True|False
		]
	}
];
```

If you reload the package, you should now be able to run the unit tests for _SeemsReasonableQ_:

```mathematica
In[1] := RunUnitTest[SeemsReasonableQ][Passed]
Out[1] = True
```

### Adding Dependencies

Lets assume that to implement the function _PumpUp_, one needs access to the database. To do this, we will need to depend on another package for the functions required to access the database (Download, etc.). We need to make sure that this package is both loaded and all the symbols defined in that package are accessible via the _$ContextPath_ while loading the source files for for the _Songs\`_ package. To do this, we must list the package we are depending upon (_Constellation\`_ in this case) in the manifest file. Open up the _manifest.json_ file and add _"Constellation\`"_ to the _"dependencies"_ section:

```json
{
    "package": "Songs`",
    "context": "ECL`Songs`",
    "description": "This is where we put goofy stuff that should never be seen by users or loaded normally.",
    "dependencies": [
    	"Constellation`"
    ],
    "sources": [
    	"Goofy.m"
    ],
    "symbols": [
        "PumpUp",
    	"SeemsReasonableQ"
    ]
}
```

We are now free to use the functions in the _Constellation\`_ package inside Goofy.m and any other source files we may add in the _Songs\`_ package. All packages listed as dependencies will be loaded in the order listed and will be available for all source files listed in the manifest.


## General Concepts
### Package
A package in the Packager framework consists of a standard folder structure containing source files (function implementations), documentation files, test files, and a _manifest_ file that describes everything about the package. This manifest includes information about what other packages are required to function correctly and what order everything should be loaded in. Packages contain conceptually related groups of functionality (in the form of Mathematica symbols) which can be loaded/deployed independently.

### Package Manifest
Every package has a _manifest_ file which exists at the root of each package directory. This file describes all the metadata about the package that the Packager framework uses to load everything correctly. The manifest declares a number of things:

- Package Identifier (_Options`_ for example)
- Context of symbols in the package (_ECL`_ for example)
- Package description
- Other packages this package depends on
- All source files this package should load and the order they should be loaded
- All symbols defined by this package

### Contexts
Every symbol in Mathematica has a _Context_ (This can be determined by evaluating the function **Context** on a symbol):

```mathematica
In[1] := Context[Upload]
Out[1] = "ECL`"
```

A context is just a string of words delimited by the \` character. All the symbols built into Mathematica exist in the _System\`_ context and generally contexts are used to group symbols with similar functionality (such as _QuantityArray\`_ or _DocumentationSearch\`_).

A fully qualified symbol looks like _Context\`SymbolName_ (_ECL\`Upload_ for example). It is possible for multiple symbols to have the same short name and exist in different contexts (for example the symbols **System\`Times** and **ECL\`Times** may both exist and do drastically different things).

When Mathematica evaluates any expression (either in the notebook or from loading a source file), it must interpret all the short names for symbols to decide which _Context_ they belong to in order to perform the correct operations. The way Mathematica does this is by using two global variables: _$ContextPath_ and _$Context_. When searching for a symbol's context, it first looks through all the contexts listed in _$ContextPath_ trying to find a symbol with the same name (using the first match it finds). If no symbol is found _a new symbol is created with the context $Context_. For example, lets assume that the _$ContextPath_ contains _System\`_ and _ECL\`_ and the current _$Context_ is _MyNewContext\`_. The symbol _Download_ exists in _ECL\`_ so its context is returned as _SLL`_. The symbol _Thingy_ does **not** exist yet so it is created in the context _MyNewContext\`_ at the time of evaluating _Context[Thingy]_

```mathematica
In[1] := $ContextPath
Out[1] = {"System`", "ECL`"}

In[2] := $Context
Out[2] = "MyNewContext`"

In[3] := Context[Download]
Out[3] = "ECL`"

In[4] := Context[Thingy]
Out[4] = "MyNewContext`"
```

Each package we define will explicitly specify _one context_ in which all the public symbols for that package will be created. Loading that package will then add the context specified by the package to the _$ContextPath_.

### Dependencies
As with any programming environment, we must load the definitions for our functions before they can be executed. The order in which these definitions are loaded is important since normally one will be writing functions _which call other functions_. In this case, the definitions for the functions which are being called must be loaded _before_ the caller (otherwise behaviour may not be what one would expect). This is especially important in Mathematica because the symptom of definitions being loaded in the incorrect order is often _non-evaluation_. For example, if the definition for the function _Download_ uses the function _ObjectP_:

```mathematica
Download[object:ObjectP[]]:="Does some stuff";
ObjectP[]:=Object[__Symbol,_String];
```

If the definition of _Download_ is loaded **before** _ObjectP_, then the pattern that the definition expects is going to be the _literal uneavluated form of ObjectP_:

```mathematica
In[1] := Object[Data,Example,"id:aac8z"]
Out[1] = Object[Data,Example,"id:aac8z"]

In[2] := Download[Unevaluated[ObjectP[]]]
Out[2] := "Does some stuff"
```

This can generally be solved without too much effort when everything is contained in a single file but as soon as you move to multiple files and (potentially) symbols in multiple contexts, this can become very tricky to detect and fix.

Another failure mode is when a symbol from a _different context_ has not yet been loaded and cannot be found on the _$ContextPath_. For example if you have some function being defined that calls _ECL\`Download_, you must make sure that the context _ECL\`_ has been loaded and that it is on the _$ContextPath_ at the time your new function is defined. For example:

```mathematica
PersonName[object_]:=Download[object,Name];
```

If at the time of evaluating the above definition, _Download_ cannot be found on the _$ContextPath_ it will be created in _$Context_ at the time of evaluating the above definition (assume that is _ECL\`Person\`Private\`_ for this example). When you go to evaluate _PersonName_ the symbol _Download_ referenced will be in the wrong context and you will get something like the following:

```mathematica
In[1] := PersonName[Object[User,Emerald,Developer,"id:xasddf"]]
Out[1] = SLL`Person`Private`Download[Object[User,Emerald,Developer,"id:xasddf"], Name]
```

The way we mitigate these issues is by defining an explicit load order for our source files and which contexts we need to be on the _$ContextPath_ while we are loading our source files (and what order they should be loaded in). Packager will make sure all the source files are loaded in the order defined and that all dependent packages are loaded and on the _$ContextPath_ when loading the source files for a package (this will cascade down the dependency tree). For example, if the package _Experiment\`_ depends on the _Constellation\`_ which depends on the options functions in _Options\`_, then packager will make sure to load _Options\`_ first, before loading _Constellation\`_ and then finally loading _Experiment\`_.

### Public Symbols
Every package has an explicit list of symbols which are "exported" by the package (that is, they are created in the context defined by the package). When you load the package, these are the new symbols (and their functionality) which you will have access to. All other symbols which are created during loading of a package will be created inside a _private_ context which will **not** be loaded onto the _$ContextPath_. In this way we can hide the implementations of the functions any given package defines and not pollute the public symbol space or cause any undue conflicts between symbol names.

The public symbols for a package are defined in the _manifest_ file for the package.
