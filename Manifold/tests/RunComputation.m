(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*RunComputation*)


DefineTests[RunComputation,
	{
		Example[{Basic,"Run a computation generated from a notebook page:"},
			RunComputation[notebookComputation, CreateTickets->False],
      		True,
			Variables:>{notebookComputation},
			SetUp:>{
				$CreatedObjects = {};
				notebookComputation=Last@Manifold`Private`enqueueOneTimeComputation@Compute[
					Object[Notebook,Page,"Manifold Test Notebook"],
					Computation->Cloud,
					Name->"Computation from Notebook for RunComputation tests "<>CreateUUID[]
		    	];
			},
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo=List,
				Print=List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_,{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}]=(Echo["Used!"];{Running,Now-15 Minute,Null,Null,Null}),
				Download[_,Status]=Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute}
			}
		],
    Example[{Basic,"Run a computation generated from a series of expressions:"},
			RunComputation[expressionComputation, CreateTickets->False],
      		True,
			Variables:>{expressionComputation},
			SetUp:>{
				$CreatedObjects = {};
		    expressionComputation=Last@Manifold`Private`enqueueOneTimeComputation@Compute[
		      (1+1),
		      Computation->Cloud,
		      Name->"Computation from Expressions for RunComputation tests "<>CreateUUID[]
		    ];
			},
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo=List,
				Print=List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_,Status]=Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute},
				Download[
					_,
					{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}
				]={Running,Now-15 Minute,Null,Null,Null}
			}
		],
		Example[{Basic, "Computations which throw messages run to completion:"},
			RunComputation[errorComputation, CreateTickets->False],
			True,
			Variables:>{errorComputation},
			Messages:>{First::nofirst},
			SetUp:>{
				$CreatedObjects = {};
				errorComputation = Last@Manifold`Private`enqueueOneTimeComputation@Compute[
					First[{}],
					Computation->Cloud,
					Name->"Computation with Error for RunComputation tests " <> CreateUUID[]
				];
			},
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects, Force->True, Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID = Object[User, "Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo = List,
				Print = List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_, Status] = Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute},
				Download[
					_,
					{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}
				]={Running,Now-15 Minute,Null,Null,Null}
			}
		],
		Test["Makes an Object[Notebook,Page] from the CompletedNotebookFile and adds to the requested lab notebook:",
			RunComputation[notebookComputation, CreateTickets->False];
			Download[Object[LaboratoryNotebook,"RunComputation Test CC Notebook "<>$SessionUUID],{Pages,Pages[DisplayName],Pages[AssetFile]}],
			{
				{ObjectP[Object[Notebook,Page]]},
				{_String},
				{ObjectP[Object[EmeraldCloudFile]]}
			},
			Variables:>{notebookComputation},
			SetUp:>Module[{notebookPacket},

				$CreatedObjects = {};

				(* Make a little test notebook *)
				notebookPacket=<|
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"RunComputation Test CC Notebook "<>$SessionUUID
				|>;

				Upload[notebookPacket];

				notebookComputation=Last@Manifold`Private`enqueueOneTimeComputation@Compute[
					Object[Notebook,Page,"Manifold Test Notebook"],
					Computation->Cloud,
					Name->"Computation from Notebook for RunComputation tests "<>CreateUUID[],
					DestinationNotebook->Object[LaboratoryNotebook,"RunComputation Test CC Notebook "<>$SessionUUID],
					DestinationNotebookNamingFunction->("Operations Report" <> DateString["ISODate"] &)
				];
			],
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo=List,
				Print=List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_,Status]=Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute},
				Download[
					_,
					{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}
				]={Running,Now-15 Minute,Object[LaboratoryNotebook,"RunComputation Test CC Notebook "<>$SessionUUID],("Operations Report" <> DateString["ISODate"] &),Object[EmeraldCloudFile, "id:zGj91ajwNXOv"]}
			}
		],
		Test["If DestinationNotebook is not set no notebook page will be created:",
			RunComputation[notebookComputation, CreateTickets->False];
			Download[Object[LaboratoryNotebook,"RunComputation Test No CC "<>$SessionUUID],{Pages,Pages[DisplayName],Pages[AssetFile]}],
			{
				{},
				{},
				{}
			},
			Variables:>{notebookComputation},
			SetUp:>Module[{notebookPacket,notebookComputation},

				$CreatedObjects = {};

				(* Make a little test notebook *)
				notebookPacket=<|
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"RunComputation Test No CC "<>$SessionUUID
				|>;

				Upload[notebookPacket];

				notebookComputation=Last@Manifold`Private`enqueueOneTimeComputation@Compute[
					Object[Notebook,Page,"Manifold Test Notebook"],
					Computation->Cloud,
					Name->"Computation from Notebook for RunComputation tests "<>CreateUUID[],
					DestinationNotebook->Object[LaboratoryNotebook,"RunComputation Test No CC "<>$SessionUUID],
					DestinationNotebookNamingFunction->("Operations Report" <> DateString["ISODate"] &)
				];
			],
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo=List,
				Print=List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_,Status]=Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute},
				Download[
					_,
					{Status,DateStarted,Job[DestinationNotebook][Object],Job[DestinationNotebookNamingFunction],CompletedNotebookFile}
				]={Running,Now-15 Minute,Object[LaboratoryNotebook,"RunComputation Test No CC "<>$SessionUUID],("Operations Report" <> DateString["ISODate"] &),Object[EmeraldCloudFile, "id:zGj91ajwNXOv"]}
			}
		]
		(* Temporarily disable this test
    Example[{Basic,"The computation will not run if it is not a valid object. Here, the maximum time limit is too small:"},
			RunComputation[badComputation, CreateTickets->False],
      False,
			Variables:>{badJob,badComputation},
			SetUp:>{
				$CreatedObjects = {};
		    badJob=Compute[
		      Pause[60],
		      Computation->Cloud,
		      Name->"Computation with 5-second time limit for RunComputation tests "<>CreateUUID[]
		    ];
				Upload[<|Object->badJob,MaximumRunTime->(5 Second)|>];
				badComputation=Last@Manifold`Private`enqueueOneTimeComputation[badJob];
			},
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
		    (* Disable echos and prints for unit testing *)
		    Echo=List,
		    Print=List,

				(* NOTE: We need these stubs because the manifold runner tries to change these statuses for us. *)
				Download[_,Status]=Running,
				Download[_,{Status,DateStarted}]={Running,Now-15 Minute}			}
		] *)
	}
];

(* ::Subsection::Closed:: *)
(* finishComputation *)
DefineTests[finishComputation,
    {
		Test["If DestinationNotebook is not set no notebook page will be created and we make updates only to the computation:",
			finishComputation[Object[Notebook,Computation,"finishComputation test computation "<>$SessionUUID]];uploadPackets,
			{PacketP[Object[Notebook,Computation]]},
			Variables:>{notebookComputation},
			SetUp:>Module[{notebookPacket,computationPacket},
				$CreatedObjects = {};

				(* Make a little test notebook *)
				notebookPacket=<|
					Type->Object[LaboratoryNotebook],
					DeveloperObject->True,
					Name->"finishComputation test notebook "<>$SessionUUID
				|>;

				computationPacket=<|
					Type -> Object[Notebook,Computation],
					DateStarted->Now,
					Status->Running,
					Name -> "finishComputation test computation "<>$SessionUUID
				|>;

				Upload[{notebookPacket,computationPacket}];
			],
			TearDown:>{
				Module[{},
					EraseObject[$CreatedObjects,Force->True,Verbose->False];
					Unset[$CreatedObjects];
				]
			},
			Stubs:>{
				$PersonID=Object[User,"Test user for notebook-less test protocols"],
				(* Disable echos and prints for unit testing *)
				Echo=List,
				Print=List,

				(* Track what was sent into Upload *)
				uploadPackets=Null,
				Upload[packets___]:=(Echo[2]; uploadPackets=packets)
			}
		]
    },
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
	]
]
