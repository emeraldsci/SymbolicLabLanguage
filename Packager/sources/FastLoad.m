

interceptLoadDistro=True;
LoadDistro[distro_String,ops:OptionsPattern[]]/;interceptLoadDistro := Module[{resetFunctions, out},

    (* 
        initialize container for loading details, messages, and timings 
    *)
	$LoadLog=<| 
        "$LazyLoading" -> ECL`$LazyLoading,
        "$FastLoad" -> Packager`$FastLoad,
        "Timings"-><| 
            "Packages" -> <||>
        |>, 
       "StartTime" ->AbsoluteTime[]
    |>;
	

    (* 
        modify some definitions of other SLL things to be faster
        ModifyFunction returns a pure function that, when run, will reset the modifications.
        So after loading we can evaluate all 'resetFunctions' to get back to normal state
    *)
	resetFunctions = {
		ModifyFunction[Packager`LoadDistro],
		ModifyFunction[Packager`OnLoad],
		ModifyFunction[Packager`LoadPackage],
		ModifyFunction[ECL`LoadTests],
		ModifyFunction[ECL`Fields]
	};

    (* 
        run regular LoadDistro, with all of our speed modifications in place 
    *)
    $LoadLog["Timings"]["LoadDistro"] = First[AbsoluteTiming[
        Block[{PacletDirectoryAdd,interceptLoadDistro=False},
		    out = Packager`LoadDistro[distro, ops] 
	    ]
    ]];
	
    (* 
        Evaluate each reset function, which undoes the changes
        made by ModifyFunction
    *)
	Through[resetFunctions[]];

    (* total time inside this function *)
    $LoadLog["TotalTiming"] = AbsoluteTime[] - $LoadLog["StartTime"];

    out

];





(*
    * Change AppendTo to Sow -- MUCH faster 
    * this needs corresponding change in LoadPackage to catch these with Reap
*)
ModifyFunction[OnLoad] := Module[{dvOld},

	dvOld = DownValues[OnLoad];

	OnLoad[expression_]:= Module[{},
        (* accumulate list of held onload expressions, tagged by package that requested it *)
   		Sow[
            Hold[expression],
            "OnLoad-"<>Packager`Private`$Package
        ]
 	]; 

    (* go back to original definitions *)
    (DownValues[OnLoad] = dvOld)&

];


(*
    Prevent test loading 
*)
ModifyFunction[LoadDistro] := Module[{dvOld},

	dvOld = DownValues[LoadDistro];

	DownValues[LoadDistro] = ReplaceAll[dvOld,{
        (* don't load tests during loading, because they already load on demand when requested *)
        HoldPattern[ECL`LoadTests[]]:>Null
	}];

     (* go back to original definitions *)
    (DownValues[LoadDistro] = dvOld)&

];


(*
    - add timings
    - add Reap for new OnLoad Sowing
*)
ModifyFunction[LoadPackage] := Module[{dvOld, loadResult, reapedOnLoad},

    dvOld = DownValues[LoadPackage];

    (*
        here we're directly modifying the DownValues to change behavior.
        We're adding a timing call around the file 'Get's, and
        adding the Reap to catch the new OnLoad Sows
    *)
    DownValues[LoadPackage] =ReplaceAll[
        dvOld,
        {
            (* this matches the code that reads in the source files for a package *)
		    getFiles:HoldPattern[Scan[Function[CompoundExpression[_,_Get]],_]] :> 
                Module[{loadTiming, loadResult},
                     (* add Reap and AbsoluteTiming to the file loading *)
                    {{loadTiming, loadResult}, reapedOnLoad} = Reap[AbsoluteTiming[getFiles], "OnLoad-"<>Packager`Private`$Package];
                    (* also store them here for WritePackageMx *)
                    onLoadExpressions[Packager`Private`$Package] = Flatten[reapedOnLoad];
                    (* log the loading time *)
                    $LoadLog["Timings"]["Packages"][Packager`Private`$Package] = <|"GetFiles" -> loadTiming |>;
               ],

            (* 
                this matches the part that releaeses the OnLoad-ed expressions.
                adding timing
            *)
		    HoldPattern[ReleaseHold[Lookup[onLoadExpressions,_,{}]]]:> 
                Module[{timing,result},
                    (* add AbsoluteTiming *)
                    {timing,result} = AbsoluteTiming[ReleaseHold[Flatten[reapedOnLoad]]];
                    (* log the timing *)
                    $LoadLog["Timings"]["Packages"][Packager`Private`$Package]["OnLoad"] = timing;

                    result
               ]
	    }
    ];

     (* go back to original definitions *)
    (DownValues[LoadPackage] = dvOld)&

];



(*
    Prevent massively repeated loading from Procedures
*)
ModifyFunction[ECL`LoadTests] := Module[{intercept=True, testsAlreadyLoaded},

    (* if intercept===True, LoadTests[] does nothing *)
    ECL`LoadTests[] /; intercept := Null;

    (* 
        Memoize test loading at the package level.
        Must disable this when loading is finished to allow developers
        to modify tests without needing to reload SLL
    *)
    ECL`LoadTests[package_String] /; intercept := If[
        TrueQ[testsAlreadyLoaded[package]],
        Null,
        (
            testsAlreadyLoaded[package]=True;
            Block[{intercept=False}, ECL`LoadTests[package]];
        )
    ];

    (* disable this definition *)
    (intercept=False)&

];


(*
    memo after all objects loaded
*)
ModifyFunction[ECL`Fields] := Module[{intercept=True},

    (* 
        If Objects` already loaded (meaning no more Type definitions coming), 
        then save the list of all Fields (with any Output format option) 
    *)
    ECL`Fields[ops:OptionsPattern[]] /; And[intercept,MemberQ[$Packages,"Objects`"]] :=  
        ECL`Fields[ops] = Block[{intercept=False}, ECL`Fields[ops]];

    (*  disable this definition  *)
    (intercept=False)&

];

fastLoadWasLoaded = True;