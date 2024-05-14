(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDNASequencing*)


(* ::Subsection::Closed:: *)
(*PlotDNASequencing*)


DefineTests[PlotDNASequencing,{

	Example[
		{Basic,"Plot the results of an ExperimentDNASequencing using a protocol object as input:"},
		PlotDNASequencing[Object[Protocol,DNASequencing,"PlotDNASequencing Test Protocol with data"]],
		{ValidGraphicsP[]..}
	],

	Example[
		{Basic,"Plot the results of an DNASequencing using a data object as input:"},
		PlotDNASequencing[Object[Data,DNASequencing,"PlotDNASequencing Test Data"]],
		ValidGraphicsP[]
	],

	Example[
		{Messages,"PlotDNASequencingObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
		PlotDNASequencing[
			Object[Protocol,DNASequencing,"Not In Database For Sure"]
		],
		$Failed,
		Messages:>Error::PlotDNASequencingObjectNotFound
	],

	Example[
		{Messages,"PlotDNASequencingObjectNotFound","An error will be shown if the specified input cannot be found in the database:"},
		PlotDNASequencing[
			Object[Data,DNASequencing,"Not In Database For Sure"]
		],
		$Failed,
		Messages:>Error::PlotDNASequencingObjectNotFound
	],

	Example[
		{Messages,"PlotDNASequencingNoAssociatedObject","An error will be shown if the specified protocol object has no associated data object:"},
		PlotDNASequencing[
			Object[Protocol,DNASequencing,"DNASequencing Protocol Without Data"]
		],
		$Failed,
		Messages:>Error::PlotDNASequencingNoAssociatedObject
	],

	Example[
		{Messages,"PlotDNASequencingNoAssociatedObject","A error will be shown if the specified data object has no associated protocol object:"},
		PlotDNASequencing[
			Object[Data,DNASequencing,"DNASequencing Data Without Protocol"]
		],
		$Failed,
		Messages:>Error::PlotDNASequencingNoAssociatedObject
	]
},
	SymbolSetUp:>{
		Module[{namedObjects,existsFilter, testData},

			(* Initialize $CreatedObjects *)
			$CreatedObjects={};

			(* Test objects we will create *)
			namedObjects={
				Object[Protocol,DNASequencing,"DNASequencing Protocol Without Data"],
				Object[Data,DNASequencing,"DNASequencing Data Without Protocol"],
				Object[Protocol,DNASequencing,"PlotDNASequencing Test Protocol with data"],
				Object[Data,DNASequencing,"PlotDNASequencing Test Data"]
			};

			(* Check whether the names already exist in the database *)
			existsFilter=DatabaseMemberQ[namedObjects];

			(* Erase any objects that exists in the database *)
			EraseObject[PickList[namedObjects,existsFilter],Force->True,Verbose->False];

			(* Upload the objects *)
			Upload[
				{
					<|
						Type->Object[Protocol,DNASequencing],
						Name->"DNASequencing Protocol Without Data",
						DeveloperObject->True
					|>,
					<|
						Type->Object[Data,DNASequencing],
						Name->"DNASequencing Data Without Protocol",
						DeveloperObject->True
					|>
				}
			];

			testData = Upload[<|
				Type->Object[Data,DNASequencing],
				Name->"PlotDNASequencing Test Data",
				Protocol -> Link[Object[Protocol,DNASequencing, "DNASequencing Protocol Without Data"], Data],
				Well -> "A1",
				SequencingElectropherogramChannel1 -> QuantityArray[{{503, 1}, {504, 1}, {505, 1}, {506, 0}, {507, 0}, {508, 0}, {509,
					1}, {510, 1}, {511, 0}, {512, 0}, {513, 0}, {514, 3}, {515,
					21}, {516, 59}, {517, 122}, {518, 215}, {519, 340}, {520,
					495}, {521, 672}, {522, 856}, {523, 1029}, {524, 1170}, {525,
					1258}, {526, 1280}, {527, 1229}, {528, 1114}, {529, 951}, {530,
					761}, {531, 567}, {532, 391}, {533, 245}, {534, 136}, {535,
					64}, {536, 22}, {537, 3}, {538, 0}, {539, 0}, {540, 1}, {541,
					4}, {542, 8}, {543, 13}, {544, 17}, {545, 20}, {546, 21}, {547,
					20}, {548, 16}, {549, 11}, {550, 5}, {551, 0}, {552, 0}, {553,
					0}, {554, 11}, {555, 37}, {556, 81}, {557, 147}, {558, 233}, {559,
					338}, {560, 453}, {561, 569}, {562, 676}, {563, 759}, {564,
					809}, {565, 816}, {566, 777}, {567, 697}, {568, 585}, {569,
					455}, {570, 326}, {571, 211}, {572, 120}, {573, 57}, {574,
					20}, {575, 3}, {576, 0}, {577, 0}, {578, 0}, {579, 1}, {580,
					4}, {581, 8}, {582, 13}, {583, 19}, {584, 23}, {585, 25}, {586,
					23}, {587, 18}, {588, 13}, {589, 8}, {590, 6}, {591, 6}, {592,
					7}, {593, 9}, {594, 10}, {595, 9}, {596, 6}, {597, 4}, {598,
					2}, {599, 1}, {600, 1}, {601, 2}, {602, 2}, {603, 2}},{ArbitraryUnit,ArbitraryUnit}],
				SequencingElectropherogramChannel2 -> QuantityArray[{{503, 362}, {504, 313}, {505, 258}, {506, 200}, {507, 145}, {508,
					96}, {509, 56}, {510, 27}, {511, 9}, {512, 1}, {513, 0}, {514,
					0}, {515, 0}, {516, 1}, {517, 1}, {518, 0}, {519, 1}, {520,
					1}, {521, 2}, {522, 3}, {523, 4}, {524, 4}, {525, 4}, {526,
					5}, {527, 7}, {528, 9}, {529, 11}, {530, 12}, {531, 12}, {532,
					11}, {533, 9}, {534, 7}, {535, 6}, {536, 4}, {537, 4}, {538,
					4}, {539, 4}, {540, 3}, {541, 2}, {542, 1}, {543, 0}, {544,
					0}, {545, 0}, {546, 0}, {547, 1}, {548, 2}, {549, 2}, {550,
					3}, {551, 3}, {552, 3}, {553, 3}, {554, 3}, {555, 2}, {556,
					1}, {557, 1}, {558, 0}, {559, 0}, {560, 0}, {561, 0}, {562,
					0}, {563, 1}, {564, 2}, {565, 2}, {566, 3}, {567, 3}, {568,
					3}, {569, 2}, {570, 1}, {571, 1}, {572, 0}, {573, 0}, {574,
					0}, {575, 0}, {576, 1}, {577, 1}, {578, 2}, {579, 2}, {580,
					1}, {581, 1}, {582, 0}, {583, 0}, {584, 0}, {585, 0}, {586,
					0}, {587, 0}, {588, 0}, {589, 0}, {590, 4}, {591, 16}, {592,
					40}, {593, 77}, {594, 127}, {595, 187}, {596, 251}, {597,
					314}, {598, 367}, {599, 404}, {600, 422}, {601, 418}, {602,
					392}, {603, 348}},{ArbitraryUnit,ArbitraryUnit}],
				SequencingElectropherogramChannel3 -> QuantityArray[{{503, 15}, {504, 35}, {505, 67}, {506, 112}, {507, 167}, {508,
					230}, {509, 293}, {510, 349}, {511, 392}, {512, 416}, {513,
					417}, {514, 396}, {515, 356}, {516, 300}, {517, 236}, {518,
					172}, {519, 112}, {520, 64}, {521, 30}, {522, 10}, {523, 1}, {524,
					0}, {525, 0}, {526, 0}, {527, 0}, {528, 4}, {529, 16}, {530,
					38}, {531, 72}, {532, 118}, {533, 173}, {534, 234}, {535,
					294}, {536, 347}, {537, 386}, {538, 406}, {539, 405}, {540,
					382}, {541, 344}, {542, 298}, {543, 256}, {544, 227}, {545,
					220}, {546, 237}, {547, 275}, {548, 327}, {549, 382}, {550,
					430}, {551, 459}, {552, 463}, {553, 441}, {554, 394}, {555,
					328}, {556, 253}, {557, 177}, {558, 110}, {559, 59}, {560,
					25}, {561, 6}, {562, 0}, {563, 0}, {564, 0}, {565, 1}, {566,
					0}, {567, 0}, {568, 0}, {569, 1}, {570, 3}, {571, 5}, {572,
					6}, {573, 5}, {574, 4}, {575, 1}, {576, 0}, {577, 0}, {578,
					0}, {579, 4}, {580, 14}, {581, 34}, {582, 66}, {583, 115}, {584,
					181}, {585, 261}, {586, 350}, {587, 437}, {588, 513}, {589,
					566}, {590, 589}, {591, 575}, {592, 527}, {593, 451}, {594,
					358}, {595, 259}, {596, 168}, {597, 94}, {598, 43}, {599, 13}, {600,
					0}, {601, 0}, {602, 0}, {603, 1}},{ArbitraryUnit,ArbitraryUnit}],
				SequencingElectropherogramChannel4 -> QuantityArray[{{503, 3}, {504, 2}, {505, 2}, {506, 1}, {507, 0}, {508, 0}, {509,
					0}, {510, 0}, {511, 0}, {512, 0}, {513, 0}, {514, 0}, {515,
					0}, {516, 0}, {517, 0}, {518, 0}, {519, 0}, {520, 0}, {521,
					0}, {522, 0}, {523, 0}, {524, 0}, {525, 0}, {526, 0}, {527,
					0}, {528, 0}, {529, 0}, {530, 0}, {531, 0}, {532, 0}, {533,
					0}, {534, 0}, {535, 0}, {536, 0}, {537, 0}, {538, 0}, {539,
					0}, {540, 0}, {541, 0}, {542, 0}, {543, 0}, {544, 0}, {545,
					0}, {546, 0}, {547, 0}, {548, 0}, {549, 0}, {550, 0}, {551,
					0}, {552, 0}, {553, 0}, {554, 0}, {555, 0}, {556, 0}, {557,
					0}, {558, 0}, {559, 0}, {560, 0}, {561, 0}, {562, 0}, {563,
					0}, {564, 0}, {565, 0}, {566, 3}, {567, 15}, {568, 39}, {569,
					78}, {570, 132}, {571, 198}, {572, 271}, {573, 344}, {574,
					409}, {575, 456}, {576, 480}, {577, 476}, {578, 446}, {579,
					392}, {580, 322}, {581, 245}, {582, 171}, {583, 108}, {584,
					60}, {585, 30}, {586, 16}, {587, 13}, {588, 16}, {589, 21}, {590,
					25}, {591, 27}, {592, 26}, {593, 23}, {594, 18}, {595, 13}, {596,
					8}, {597, 3}, {598, 0}, {599, 0}, {600, 3}, {601, 18}, {602,
					47}, {603, 97}},{ArbitraryUnit,ArbitraryUnit}],
				Channel1BaseAssignment -> "A",
				Channel2BaseAssignment -> "T",
				Channel3BaseAssignment -> "G",
				Channel4BaseAssignment -> "C",
				DeveloperObject->True
			|>];

			Upload[<|
				Type->Object[Protocol,DNASequencing],
				Name->"PlotDNASequencing Test Protocol with data",
				Replace[Data] -> Link[testData, Protocol],
				DeveloperObject->True
			|>];

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