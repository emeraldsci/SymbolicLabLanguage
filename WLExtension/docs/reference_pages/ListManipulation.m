(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*FirstOrDefault*)


DefineUsage[FirstOrDefault,
{
	BasicDefinitions->
		{
			{"FirstOrDefault[expression]","result","returns the first element of 'expression' unless it has no length then returns Null."},
			{"FirstOrDefault[expression,default]","result","returns the first element of 'expression' unless it has no length, then returns 'default'."}
		},
	Input:>
		{
			{"expression",_,"An expression to take the first element of."},
			{"default",_,"Default value to return when input expression is length 0."}
		},
	Output:>
		{
			{"result",_,"Either the first element of the input expression or the specified default value."}
		},
	Sync->Automatic,
	SeeAlso->
		{
			"First",
			"LastOrDefault",
			"MostOrDefault",
			"RestOrDefault"
		},
	Author->{"scicomp", "brad"}
}];


(* ::Subsection::Closed:: *)
(*LastOrDefault*)


DefineUsage[LastOrDefault,
{
	BasicDefinitions->
		{
			{"LastOrDefault[expression]","result","returns the last element of 'expression' unless it has no length then returns Null."},
			{"LastOrDefault[expression,default]","result","returns the last element of 'expression' unless it has no length, then returns 'default'."}
		},
	Input:>
		{
			{"expression",_,"An expression to take the last element of."},
			{"default",_,"Default value to return when input expression is length 0."}
		},
	Output:>
		{
			{"result",_,"Either the last element of the input expression or the specified default value."}
		},
	Sync->Automatic,
	SeeAlso->
		{
			"Last",
			"FirstOrDefault",
			"MostOrDefault",
			"RestOrDefault"
		},
	Author->{"scicomp", "brad"}
}];

(* ::Subsection::Closed:: *)
(*MostOrDefault*)


DefineUsage[MostOrDefault,
{
	BasicDefinitions->
		{
			{"MostOrDefault[expression]","result","returns the 'expression' with the last element removed or Null if 'expression' is length 0."},
			{"MostOrDefault[expression,default]","result","returns the 'expression' with the last element removed or 'default' if 'expression' is length 0."}
		},
	Input:>
		{
			{"expression",_,"An expression to remove the last element from."},
			{"default",_,"Default value to return when input expression is length 0."}
		},
	Output:>
		{
			{"result",_,"Either the expression with the last element remove or the specified default value."}
		},
	Sync->Automatic,
	SeeAlso->
		{
			"Most",
			"FirstOrDefault",
			"LastOrDefault",
			"RestOrDefault"
		},
	Author->{"scicomp", "brad"}
}];

(* ::Subsection::Closed:: *)
(*RestOrDefault*)


DefineUsage[RestOrDefault,
{
	BasicDefinitions->
		{
			{"RestOrDefault[expression]","result","returns the 'expression' with the first element removed or Null if 'expression' is length 0."},
			{"RestOrDefault[expression,default]","result","returns the 'expression' with the first element removed or 'default' if 'expression' is length 0."}
		},
	Input:>
		{
			{"expression",_,"An expression to remove the first element from."},
			{"default",_,"Default value to return when input expression is length 0."}
		},
	Output:>
		{
			{"result",_,"Either the expression with the first element remove or the specified default value."}
		},
	Sync->Automatic,
	SeeAlso->
		{
			"Rest",
			"FirstOrDefault",
			"LastOrDefault",
			"MostOrDefault"
		},
	Author->{"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)


DefineUsage[PartitionRemainder,
{
	BasicDefinitions->
		{
			{"PartitionRemainder[list,n]","lists","partitions 'list' into nonoverlapping sublists of length 'n' with remaining items that don't divide evenly into a final sublist."},
			{"PartitionRemainder[list,n,d]","lists","generates overlapping sublists with offset 'd'."}
		},
	Input:>
		{
			{"list",_List,"The List to be Partitioned."},
			{"n",_Integer?Positive,"The number of elements in each partitioned group."},
			{"d",_Integer?Positive,"The offset for which each partition should be separated by."}
		},
	Output:>
		{
			{"lists",{_List..},"List of sublists partitions."}
		},
	SeeAlso->
		{
			"Partition",
			"Split"
		},
	Author->{"yanzhe.zhu", "kelmen.low", "harrison.gronlund", "josh.kenchel", "steven", "Frezza"}
}];


(* ::Subsubsection::Closed:: *)
(*LookupPath*)


DefineUsage[LookupPath,
{
	BasicDefinitions->
		{
			{"LookupPath[data,path]","value","given a nested 'data' structure that can have Lookup or Part called on it, traverse a 'path' through it and return the value at the path."}
		},
	Input:>
		{
			{"data",LookupPathDataP|_List,"The data structure to lookup into."},
			{"path",{(_String|_Symbol|_Key|_Integer)..},"The path through the data structure to traverse, represented as a list."}
		},
	Output:>
		{
			{"value",_,"The value in the data structure at that path."},
			{"value",_Missing,"If some of the path references keys / indexes that are not there, Missing is returned."},
			{"value",$Failed,"If an inner component of the path references a data structure that cannot be looked into, a Message is display and $Failed is returned."}
		},
	SeeAlso->
		{
			"Lookup",
			"Part",
			"Missing"
		},
	Author->{"platform"}
}];



(* ::Subsubsection::Closed:: *)
(*ToList*)


DefineUsage[ToList,
{
	BasicDefinitions->
		{
			{"ToList[expr]","list","wraps 'expr' in List unless it is already a List."}
		},
	MoreInformation->{},
	Input:>
		{
			{"expr",_,"Any expression to wrap in a List."}
		},
	Output:>
		{
			{"list",_List,"The input expression wrapped in a List (unless it was already a List)."}
		},
	SeeAlso->
		{
			"Sequence",
			"List"
		},
	Author->{"scicomp", "brad"}
}];