(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


(* ::Subsection::Closed:: *)
(*PlotFreezeCells*)


DefineTests[PlotFreezeCells,
	{
		Example[
			{Basic,"Plot the results of an ExperimentFreezeCells using a protocol object as input:"},
			PlotFreezeCells[Object[Protocol,FreezeCells,"ControlledRateFreezer Test Protocol"]],
			TabView[{"Batch 1"->_?ValidGraphicsQ,"Batch 2"->_?ValidGraphicsQ}]
		],
		
		Example[
			{Basic,"Plot the results of an FreezeCells using a data object as input:"},
			PlotFreezeCells[Object[Data,FreezeCells,"ControlledRateFreezer Test Protocol"]],
			TabView[{"Batch 1"->_?ValidGraphicsQ,"Batch 2"->_?ValidGraphicsQ}]
		],
		
		Test[
			"Previews generate slides:",
			PlotFreezeCells[Object[Data,FreezeCells,"ControlledRateFreezer Test Protocol"],Output->Preview],
			SlideView[{_?ValidGraphicsQ,_?ValidGraphicsQ}]
		],
		
		Example[
			{Messages,"PlotFreezeCellsObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
			PlotFreezeCells[
				Object[Protocol,FreezeCells,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsObjectNotFound
		],
		
		Example[
			{Messages,"PlotFreezeCellsObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
			PlotFreezeCells[
				Object[Data,FreezeCells,"Not In Database For Sure"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsObjectNotFound
		],
		
		Example[
			{Messages,"PlotFreezeCellsNoAssociatedObject","An error will be shown if the specified protocol object has no associated data object:"},
			PlotFreezeCells[
				Object[Protocol,FreezeCells,"FreezeCells Protocol Without Data"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsNoAssociatedObject
		],
		
		Example[
			{Messages,"PlotFreezeCellsNoAssociatedObject","A error will be shown if the specified data object has no associated protocol object:"},
			PlotFreezeCells[
				Object[Data,FreezeCells,"FreezeCells Data Without Protocol"]
			],
			$Failed,
			Messages:>Error::PlotFreezeCellsNoAssociatedObject
		]
	},
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter},
			
			(* Initialize $CreatedObjects *)
			$CreatedObjects={};
			
			(* Test objects we will create *)
			namedObjects={
				Object[Protocol,FreezeCells,"FreezeCells Protocol Without Data"],
				Object[Data,FreezeCells,"FreezeCells Data Without Protocol"]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];
			
			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];
			
			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Object[Protocol,FreezeCells],
						Name->"FreezeCells Protocol Without Data",
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,FreezeCells],
						Name->"FreezeCells Data Without Protocol",
						DeveloperObject->True
					|>
				}
			];
		]
	},
	
	SymbolTearDown:>{
		
		(* Erase all created objects *)
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		
		(* Unset $CreatedObjects *)
		$CreatedObjects=.;
	},
	
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];