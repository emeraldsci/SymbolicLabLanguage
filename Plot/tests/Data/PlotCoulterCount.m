(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCoulterCount*)


DefineTests[PlotCoulterCount,
	{
		Example[{Basic, "Given an Object[Data,CoulterCount] from ExperimentCoulterCount, PlotCoulterCount returns an plot:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 2 for PlotCoulterCount unit test"<>$SessionUUID]],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Basic, "Given multiple Object[Data,CoulterCount]s from ExperimentCoulterCount, PlotCoulterCount returns an stacked plot:"},
			PlotCoulterCount[{Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID], Object[Data, CoulterCount, "test coulter count data 2 for PlotCoulterCount unit test"<>$SessionUUID]}],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],

		Example[{Options, Legend, "Add a legend:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				Legend -> {"My legend"}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Frame, "Specify a frame:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				Frame -> {True, True, False, False}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, LabelStyle, "Specify a label style:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				LabelStyle -> {Bold, 20, FontFamily -> "Times"}
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Scale, "Specify a scale:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				Scale -> Linear
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, Joined, "Specify if the points are joined:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				Joined -> False
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options, FrameLabel, "Specify a frame label:"},
			PlotCoulterCount[Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
				FrameLabel -> "Custom Label"
			],
			ValidGraphicsP[],
			SetUp :> (
				$CreatedObjects = {}
			),
			TearDown :> (
				EraseObject[$CreatedObjects, Force -> True];
				Unset[$CreatedObjects]
			)
		]
	},
	SymbolSetUp :> {
		plotCoulterCountTestCleanup[];
		Block[{$DeveloperUpload = True},
			(* Only need two raw data packets *)
			Upload[{<|
				Replace[DiameterDistribution] -> {QuantityArray[{{2, 2}, {2.01708, 0}, {2.0343, 3}, {2.05167, 1}, {2.06919, 8}, {2.08686, 5}, {2.10468, 2}, {2.12266, 9}, {2.14078, 10}, {2.15906, 8}, {2.1775, 8}, {2.19609, 9}, {2.21485, 11}, {2.23376, 5}, {2.25283, 4}, {2.27207, 5}, {2.29147, 8}, {2.31104, 5}, {2.33078, 9}, {2.35068, 4}, {2.37075, 12}, {2.391, 4}, {2.41141, 6}, {2.432, 16}, {2.45277, 7}, {2.47372, 13}, {2.49484, 8}, {2.51614, 8}, {2.53763, 5}, {2.5593, 5}, {2.58116, 8}, {2.6032, 4}, {2.62543, 7}, {2.64784, 8}, {2.67046, 4}, {2.69326, 6}, {2.71626, 7}, {2.73945, 6}, {2.76285, 3}, {2.78644, 0}, {2.81023, 12}, {2.83423, 8}, {2.85843, 2}, {2.88284, 6}, {2.90746, 13}, {2.93228, 7}, {2.95732, 8}, {2.98258, 3}, {3.00805, 11}, {3.03373, 11}, {3.05964, 4}, {3.08577, 4}, {3.11212, 5}, {3.13869, 2}, {3.16549, 6}, {3.19252, 3}, {3.21979, 2}, {3.24728, 8}, {3.27501, 3}, {3.30298, 4}, {3.33118, 8}, {3.35963, 5}, {3.38832, 1}, {3.41725, 7}, {3.44643, 5}, {3.47586, 3}, {3.50554, 3}, {3.53548, 4}, {3.56567, 5}, {3.59611, 5}, {3.62682, 7}, {3.65779, 2}, {3.68903, 4}, {3.72053, 6}, {3.7523, 0}, {3.78434, 8}, {3.81666, 1}, {3.84925, 5}, {3.88212, 3}, {3.91527, 2}, {3.9487, 6}, {3.98242, 2}, {4.01643, 2}, {4.05072, 3}, {4.08531, 3}, {4.1202, 0}, {4.15538, 2}, {4.19087, 0}, {4.22665, 0}, {4.26275, 1}, {4.29915, 4}, {4.33586, 6}, {4.37288, 5}, {4.41022, 5}, {4.44788, 3}, {4.48587, 2}, {4.52417, 3}, {4.5628, 4}, {4.60177, 5}, {4.64106, 4}, {4.68069, 25}, {4.72066, 62}, {4.76098, 171}, {4.80163, 441}, {4.84263, 798}, {4.88399, 1044}, {4.92569, 1092}, {4.96775, 1055}, {5.01017, 1126}, {5.05296, 935}, {5.0961, 646}, {5.13962, 501}, {5.18351, 353}, {5.22777, 250}, {5.27241, 221}, {5.31744, 190}, {5.36284, 148}, {5.40864, 154}, {5.45482, 179}, {5.5014, 153}, {5.54838, 170}, {5.59576, 171}, {5.64354, 173}, {5.69174, 142}, {5.74034, 81}, {5.78936, 49}, {5.83879, 32}, {5.88865, 12}, {5.93894, 28}, {5.98965, 14}, {6.0408, 17}, {6.09238, 22}, {6.14441, 28}, {6.19688, 39}, {6.24979, 28}, {6.30316, 40}, {6.35699, 38}, {6.41127, 32}, {6.46602, 21}, {6.52123, 27}, {6.57692, 18}, {6.63308, 18}, {6.68972, 14}, {6.74685, 6}, {6.80446, 11}, {6.86256, 3}, {6.92117, 2}, {6.98027, 1}, {7.03987, 1}, {7.09999, 2}, {7.16062, 1}, {7.22176, 2}, {7.28343, 3}, {7.34563, 3}, {7.40835, 2}, {7.47161, 1}, {7.53542, 1}, {7.59976, 1}, {7.66466, 0}, {7.73011, 0}, {7.79612, 0}, {7.86269, 1}, {7.92983, 0}, {7.99755, 1}, {8.06584, 0}, {8.13472, 1}, {8.20418, 1}, {8.27424, 1}, {8.3449, 0}, {8.41615, 0}, {8.48802, 1}, {8.5605, 0}, {8.6336, 1}, {8.70733, 0}, {8.78168, 0}, {8.85667, 1}, {8.9323, 0}, {9.00858, 0}, {9.0855, 0}, {9.16309, 1}, {9.24133, 1}, {9.32025, 0}, {9.39983, 0}, {9.4801, 0}, {9.56105, 1}, {9.6427, 1}, {9.72504, 1}, {9.80808, 2}, {9.89184, 0}, {9.97631, 1}, {10.0615, 0}, {10.1474, 0}, {10.2341, 0}, {10.3215, 0}, {10.4096, 1}, {10.4985, 0}, {10.5881, 1}, {10.6785, 0}, {10.7697, 1}, {10.8617, 0}, {10.9545, 0}, {11.048, 0}, {11.1423, 0}, {11.2375, 0}, {11.3334, 0}, {11.4302, 1}, {11.5278, 0}, {11.6263, 0}, {11.7255, 0}, {11.8257, 0}, {11.9267, 1}, {12.0285, 0}, {12.1312, 0}, {12.2348, 0}, {12.3393, 0}, {12.4446, 0}, {12.5509, 0}, {12.6581, 0}, {12.7662, 0}, {12.8752, 1}, {12.9851, 0}, {13.096, 0}, {13.2079, 0}, {13.3206, 0}, {13.4344, 0}, {13.5491, 0}, {13.6648, 1}, {13.7815, 0}, {13.8992, 0}, {14.0179, 0}, {14.1376, 0}, {14.2583, 0}, {14.38, 0}, {14.5028, 0}, {14.6267, 0}, {14.7516, 0}, {14.8776, 0}, {15.0046, 0}, {15.1327, 0}, {15.2619, 0}, {15.3923, 0}, {15.5237, 0}, {15.6563, 0}, {15.79, 0}, {15.9248, 0}, {16.0608, 0}, {16.1979, 0}, {16.3363, 0}, {16.4757, 0}, {16.6164, 0}, {16.7583, 0}, {16.9014, 0}, {17.0458, 0}, {17.1913, 0}, {17.3381, 0}, {17.4862, 0}, {17.6355, 0}, {17.7861, 0}, {17.938, 0}, {18.0911, 0}, {18.2456, 0}, {18.4014, 0}, {18.5586, 0}, {18.717, 0}, {18.8769, 0}, {19.0381, 0}, {19.2006, 0}, {19.3646, 0}, {19.53, 0}, {19.6967, 0}, {19.8649, 0}, {20.0346, 0}, {20.2056, 0}, {20.3782, 0}, {20.5522, 0}, {20.7277, 0}, {20.9047, 0}, {21.0832, 0}, {21.2632, 0}, {21.4448, 0}, {21.6279, 0}, {21.8126, 0}, {21.9989, 0}, {22.1867, 0}, {22.3762, 0}, {22.5673, 0}, {22.76, 0}, {22.9543, 0}, {23.1503, 0}, {23.348, 0}, {23.5474, 0}, {23.7485, 0}, {23.9513, 0}, {24.1558, 0}, {24.3621, 0}, {24.5701, 0}, {24.7799, 0}, {24.9915, 0}, {25.2049, 0}, {25.4202, 0}, {25.6372, 0}, {25.8561, 0}, {26.0769, 0}, {26.2996, 0}, {26.5242, 0}, {26.7507, 0}, {26.9791, 0}, {27.2095, 0}, {27.4418, 0}, {27.6762, 0}, {27.9125, 0}, {28.1509, 0}, {28.3913, 0}, {28.6337, 0}, {28.8782, 0}, {29.1248, 0}, {29.3735, 0}, {29.6243, 0}, {29.8773, 0}, {30.1324, 0}, {30.3897, 0}, {30.6492, 0}, {30.911, 0}, {31.1749, 0}, {31.4411, 0}, {31.7096, 0}, {31.9804, 0}, {32.2535, 0}, {32.5289, 0}, {32.8067, 0}, {33.0868, 0}, {33.3694, 0}, {33.6543, 0}, {33.9417, 0}, {34.2315, 0}, {34.5238, 0}, {34.8186, 0}, {35.116, 0}, {35.4158, 0}, {35.7183, 0}, {36.0233, 0}, {36.3309, 0}, {36.6411, 0}, {36.954, 0}, {37.2696, 0}, {37.5878, 0}, {37.9088, 0}, {38.2325, 0}, {38.559, 0}, {38.8882, 0}, {39.2203, 0}, {39.5552, 0}, {39.893, 0}, {40.2337, 0}, {40.5772, 0}, {40.9237, 0}, {41.2732, 0}, {41.6256, 0}, {41.9811, 0}, {42.3396, 0}, {42.7011, 0}, {43.0657, 0}, {43.4335, 0}, {43.8044, 0}, {44.1784, 0}, {44.5557, 0}, {44.9362, 0}, {45.3199, 0}, {45.7069, 0}, {46.0972, 0}, {46.4908, 0}, {46.8878, 0}, {47.2882, 0}, {47.692, 0}, {48.0993, 0}, {48.51, 0}, {48.9242, 0}, {49.342, 0}, {49.7633, 0}, {50.1883, 0}, {50.6169, 0}, {51.0491, 0}, {51.485, 0}, {51.9247, 0}, {52.368, 0}, {52.8152, 0}, {53.2662, 0}, {53.7211, 0}, {54.1798, 0}, {54.6425, 0}, {55.1091, 0}, {55.5797, 0}, {56.0543, 0}, {56.5329, 0}, {57.0157, 0}, {57.5026, 0}, {57.9936, 0}, {58.4888, 0}, {58.9883, 0}, {59.492, 0}, {60, 0}}, {Micrometer, 1}]},
				Type -> Object[Data, CoulterCount],
				Name -> "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID
			|>,
			<|
				Replace[DiameterDistribution] -> {QuantityArray[{{2, 2}, {2.01708, 0}, {2.0343, 3}, {2.05167, 1}, {2.06919, 8}, {2.08686, 5}, {2.10468, 2}, {2.12266, 9}, {2.14078, 10}, {2.15906, 8}, {2.1775, 8}, {2.19609, 9}, {2.21485, 11}, {2.23376, 5}, {2.25283, 4}, {2.27207, 5}, {2.29147, 8}, {2.31104, 5}, {2.33078, 9}, {2.35068, 4}, {2.37075, 12}, {2.391, 4}, {2.41141, 6}, {2.432, 16}, {2.45277, 7}, {2.47372, 13}, {2.49484, 8}, {2.51614, 8}, {2.53763, 5}, {2.5593, 5}, {2.58116, 8}, {2.6032, 4}, {2.62543, 7}, {2.64784, 8}, {2.67046, 4}, {2.69326, 6}, {2.71626, 7}, {2.73945, 6}, {2.76285, 3}, {2.78644, 0}, {2.81023, 12}, {2.83423, 8}, {2.85843, 2}, {2.88284, 6}, {2.90746, 13}, {2.93228, 7}, {2.95732, 8}, {2.98258, 3}, {3.00805, 11}, {3.03373, 11}, {3.05964, 4}, {3.08577, 4}, {3.11212, 5}, {3.13869, 2}, {3.16549, 6}, {3.19252, 3}, {3.21979, 2}, {3.24728, 8}, {3.27501, 3}, {3.30298, 4}, {3.33118, 8}, {3.35963, 5}, {3.38832, 1}, {3.41725, 7}, {3.44643, 5}, {3.47586, 3}, {3.50554, 3}, {3.53548, 4}, {3.56567, 5}, {3.59611, 5}, {3.62682, 7}, {3.65779, 2}, {3.68903, 4}, {3.72053, 6}, {3.7523, 0}, {3.78434, 8}, {3.81666, 1}, {3.84925, 5}, {3.88212, 3}, {3.91527, 2}, {3.9487, 6}, {3.98242, 2}, {4.01643, 2}, {4.05072, 3}, {4.08531, 3}, {4.1202, 0}, {4.15538, 2}, {4.19087, 0}, {4.22665, 0}, {4.26275, 1}, {4.29915, 4}, {4.33586, 6}, {4.37288, 5}, {4.41022, 5}, {4.44788, 3}, {4.48587, 2}, {4.52417, 3}, {4.5628, 4}, {4.60177, 5}, {4.64106, 4}, {4.68069, 25}, {4.72066, 62}, {4.76098, 171}, {4.80163, 441}, {4.84263, 798}, {4.88399, 1044}, {4.92569, 1092}, {4.96775, 1055}, {5.01017, 1126}, {5.05296, 935}, {5.0961, 646}, {5.13962, 501}, {5.18351, 353}, {5.22777, 250}, {5.27241, 221}, {5.31744, 190}, {5.36284, 148}, {5.40864, 154}, {5.45482, 179}, {5.5014, 153}, {5.54838, 170}, {5.59576, 171}, {5.64354, 173}, {5.69174, 142}, {5.74034, 81}, {5.78936, 49}, {5.83879, 32}, {5.88865, 12}, {5.93894, 28}, {5.98965, 14}, {6.0408, 17}, {6.09238, 22}, {6.14441, 28}, {6.19688, 39}, {6.24979, 28}, {6.30316, 40}, {6.35699, 38}, {6.41127, 32}, {6.46602, 21}, {6.52123, 27}, {6.57692, 18}, {6.63308, 18}, {6.68972, 14}, {6.74685, 6}, {6.80446, 11}, {6.86256, 3}, {6.92117, 2}, {6.98027, 1}, {7.03987, 1}, {7.09999, 2}, {7.16062, 1}, {7.22176, 2}, {7.28343, 3}, {7.34563, 3}, {7.40835, 2}, {7.47161, 1}, {7.53542, 1}, {7.59976, 1}, {7.66466, 0}, {7.73011, 0}, {7.79612, 0}, {7.86269, 1}, {7.92983, 0}, {7.99755, 1}, {8.06584, 0}, {8.13472, 1}, {8.20418, 1}, {8.27424, 1}, {8.3449, 0}, {8.41615, 0}, {8.48802, 1}, {8.5605, 0}, {8.6336, 1}, {8.70733, 0}, {8.78168, 0}, {8.85667, 1}, {8.9323, 0}, {9.00858, 0}, {9.0855, 0}, {9.16309, 1}, {9.24133, 1}, {9.32025, 0}, {9.39983, 0}, {9.4801, 0}, {9.56105, 1}, {9.6427, 1}, {9.72504, 1}, {9.80808, 2}, {9.89184, 0}, {9.97631, 1}, {10.0615, 0}, {10.1474, 0}, {10.2341, 0}, {10.3215, 0}, {10.4096, 1}, {10.4985, 0}, {10.5881, 1}, {10.6785, 0}, {10.7697, 1}, {10.8617, 0}, {10.9545, 0}, {11.048, 0}, {11.1423, 0}, {11.2375, 0}, {11.3334, 0}, {11.4302, 1}, {11.5278, 0}, {11.6263, 0}, {11.7255, 0}, {11.8257, 0}, {11.9267, 1}, {12.0285, 0}, {12.1312, 0}, {12.2348, 0}, {12.3393, 0}, {12.4446, 0}, {12.5509, 0}, {12.6581, 0}, {12.7662, 0}, {12.8752, 1}, {12.9851, 0}, {13.096, 0}, {13.2079, 0}, {13.3206, 0}, {13.4344, 0}, {13.5491, 0}, {13.6648, 1}, {13.7815, 0}, {13.8992, 0}, {14.0179, 0}, {14.1376, 0}, {14.2583, 0}, {14.38, 0}, {14.5028, 0}, {14.6267, 0}, {14.7516, 0}, {14.8776, 0}, {15.0046, 0}, {15.1327, 0}, {15.2619, 0}, {15.3923, 0}, {15.5237, 0}, {15.6563, 0}, {15.79, 0}, {15.9248, 0}, {16.0608, 0}, {16.1979, 0}, {16.3363, 0}, {16.4757, 0}, {16.6164, 0}, {16.7583, 0}, {16.9014, 0}, {17.0458, 0}, {17.1913, 0}, {17.3381, 0}, {17.4862, 0}, {17.6355, 0}, {17.7861, 0}, {17.938, 0}, {18.0911, 0}, {18.2456, 0}, {18.4014, 0}, {18.5586, 0}, {18.717, 0}, {18.8769, 0}, {19.0381, 0}, {19.2006, 0}, {19.3646, 0}, {19.53, 0}, {19.6967, 0}, {19.8649, 0}, {20.0346, 0}, {20.2056, 0}, {20.3782, 0}, {20.5522, 0}, {20.7277, 0}, {20.9047, 0}, {21.0832, 0}, {21.2632, 0}, {21.4448, 0}, {21.6279, 0}, {21.8126, 0}, {21.9989, 0}, {22.1867, 0}, {22.3762, 0}, {22.5673, 0}, {22.76, 0}, {22.9543, 0}, {23.1503, 0}, {23.348, 0}, {23.5474, 0}, {23.7485, 0}, {23.9513, 0}, {24.1558, 0}, {24.3621, 0}, {24.5701, 0}, {24.7799, 0}, {24.9915, 0}, {25.2049, 0}, {25.4202, 0}, {25.6372, 0}, {25.8561, 0}, {26.0769, 0}, {26.2996, 0}, {26.5242, 0}, {26.7507, 0}, {26.9791, 0}, {27.2095, 0}, {27.4418, 0}, {27.6762, 0}, {27.9125, 0}, {28.1509, 0}, {28.3913, 0}, {28.6337, 0}, {28.8782, 0}, {29.1248, 0}, {29.3735, 0}, {29.6243, 0}, {29.8773, 0}, {30.1324, 0}, {30.3897, 0}, {30.6492, 0}, {30.911, 0}, {31.1749, 0}, {31.4411, 0}, {31.7096, 0}, {31.9804, 0}, {32.2535, 0}, {32.5289, 0}, {32.8067, 0}, {33.0868, 0}, {33.3694, 0}, {33.6543, 0}, {33.9417, 0}, {34.2315, 0}, {34.5238, 0}, {34.8186, 0}, {35.116, 0}, {35.4158, 0}, {35.7183, 0}, {36.0233, 0}, {36.3309, 0}, {36.6411, 0}, {36.954, 0}, {37.2696, 0}, {37.5878, 0}, {37.9088, 0}, {38.2325, 0}, {38.559, 0}, {38.8882, 0}, {39.2203, 0}, {39.5552, 0}, {39.893, 0}, {40.2337, 0}, {40.5772, 0}, {40.9237, 0}, {41.2732, 0}, {41.6256, 0}, {41.9811, 0}, {42.3396, 0}, {42.7011, 0}, {43.0657, 0}, {43.4335, 0}, {43.8044, 0}, {44.1784, 0}, {44.5557, 0}, {44.9362, 0}, {45.3199, 0}, {45.7069, 0}, {46.0972, 0}, {46.4908, 0}, {46.8878, 0}, {47.2882, 0}, {47.692, 0}, {48.0993, 0}, {48.51, 0}, {48.9242, 0}, {49.342, 0}, {49.7633, 0}, {50.1883, 0}, {50.6169, 0}, {51.0491, 0}, {51.485, 0}, {51.9247, 0}, {52.368, 0}, {52.8152, 0}, {53.2662, 0}, {53.7211, 0}, {54.1798, 0}, {54.6425, 0}, {55.1091, 0}, {55.5797, 0}, {56.0543, 0}, {56.5329, 0}, {57.0157, 0}, {57.5026, 0}, {57.9936, 0}, {58.4888, 0}, {58.9883, 0}, {59.492, 0}, {60, 0}}, {Micrometer, 1}], QuantityArray[{{2, 2}, {2.01708, 0}, {2.0343, 3}, {2.05167, 1}, {2.06919, 8}, {2.08686, 5}, {2.10468, 2}, {2.12266, 9}, {2.14078, 10}, {2.15906, 8}, {2.1775, 8}, {2.19609, 9}, {2.21485, 11}, {2.23376, 5}, {2.25283, 4}, {2.27207, 5}, {2.29147, 8}, {2.31104, 5}, {2.33078, 9}, {2.35068, 4}, {2.37075, 12}, {2.391, 4}, {2.41141, 6}, {2.432, 16}, {2.45277, 7}, {2.47372, 13}, {2.49484, 8}, {2.51614, 8}, {2.53763, 5}, {2.5593, 5}, {2.58116, 8}, {2.6032, 4}, {2.62543, 7}, {2.64784, 8}, {2.67046, 4}, {2.69326, 6}, {2.71626, 7}, {2.73945, 6}, {2.76285, 3}, {2.78644, 0}, {2.81023, 12}, {2.83423, 8}, {2.85843, 2}, {2.88284, 6}, {2.90746, 13}, {2.93228, 7}, {2.95732, 8}, {2.98258, 3}, {3.00805, 11}, {3.03373, 11}, {3.05964, 4}, {3.08577, 4}, {3.11212, 5}, {3.13869, 2}, {3.16549, 6}, {3.19252, 3}, {3.21979, 2}, {3.24728, 8}, {3.27501, 3}, {3.30298, 4}, {3.33118, 8}, {3.35963, 5}, {3.38832, 1}, {3.41725, 7}, {3.44643, 5}, {3.47586, 3}, {3.50554, 3}, {3.53548, 4}, {3.56567, 5}, {3.59611, 5}, {3.62682, 7}, {3.65779, 2}, {3.68903, 4}, {3.72053, 6}, {3.7523, 0}, {3.78434, 8}, {3.81666, 1}, {3.84925, 5}, {3.88212, 3}, {3.91527, 2}, {3.9487, 6}, {3.98242, 2}, {4.01643, 2}, {4.05072, 3}, {4.08531, 3}, {4.1202, 0}, {4.15538, 2}, {4.19087, 0}, {4.22665, 0}, {4.26275, 1}, {4.29915, 4}, {4.33586, 6}, {4.37288, 5}, {4.41022, 5}, {4.44788, 3}, {4.48587, 2}, {4.52417, 3}, {4.5628, 4}, {4.60177, 5}, {4.64106, 4}, {4.68069, 25}, {4.72066, 62}, {4.76098, 171}, {4.80163, 441}, {4.84263, 798}, {4.88399, 1044}, {4.92569, 1092}, {4.96775, 1055}, {5.01017, 1126}, {5.05296, 935}, {5.0961, 646}, {5.13962, 501}, {5.18351, 353}, {5.22777, 250}, {5.27241, 221}, {5.31744, 190}, {5.36284, 148}, {5.40864, 154}, {5.45482, 179}, {5.5014, 153}, {5.54838, 170}, {5.59576, 171}, {5.64354, 173}, {5.69174, 142}, {5.74034, 81}, {5.78936, 49}, {5.83879, 32}, {5.88865, 12}, {5.93894, 28}, {5.98965, 14}, {6.0408, 17}, {6.09238, 22}, {6.14441, 28}, {6.19688, 39}, {6.24979, 28}, {6.30316, 40}, {6.35699, 38}, {6.41127, 32}, {6.46602, 21}, {6.52123, 27}, {6.57692, 18}, {6.63308, 18}, {6.68972, 14}, {6.74685, 6}, {6.80446, 11}, {6.86256, 3}, {6.92117, 2}, {6.98027, 1}, {7.03987, 1}, {7.09999, 2}, {7.16062, 1}, {7.22176, 2}, {7.28343, 3}, {7.34563, 3}, {7.40835, 2}, {7.47161, 1}, {7.53542, 1}, {7.59976, 1}, {7.66466, 0}, {7.73011, 0}, {7.79612, 0}, {7.86269, 1}, {7.92983, 0}, {7.99755, 1}, {8.06584, 0}, {8.13472, 1}, {8.20418, 1}, {8.27424, 1}, {8.3449, 0}, {8.41615, 0}, {8.48802, 1}, {8.5605, 0}, {8.6336, 1}, {8.70733, 0}, {8.78168, 0}, {8.85667, 1}, {8.9323, 0}, {9.00858, 0}, {9.0855, 0}, {9.16309, 1}, {9.24133, 1}, {9.32025, 0}, {9.39983, 0}, {9.4801, 0}, {9.56105, 1}, {9.6427, 1}, {9.72504, 1}, {9.80808, 2}, {9.89184, 0}, {9.97631, 1}, {10.0615, 0}, {10.1474, 0}, {10.2341, 0}, {10.3215, 0}, {10.4096, 1}, {10.4985, 0}, {10.5881, 1}, {10.6785, 0}, {10.7697, 1}, {10.8617, 0}, {10.9545, 0}, {11.048, 0}, {11.1423, 0}, {11.2375, 0}, {11.3334, 0}, {11.4302, 1}, {11.5278, 0}, {11.6263, 0}, {11.7255, 0}, {11.8257, 0}, {11.9267, 1}, {12.0285, 0}, {12.1312, 0}, {12.2348, 0}, {12.3393, 0}, {12.4446, 0}, {12.5509, 0}, {12.6581, 0}, {12.7662, 0}, {12.8752, 1}, {12.9851, 0}, {13.096, 0}, {13.2079, 0}, {13.3206, 0}, {13.4344, 0}, {13.5491, 0}, {13.6648, 1}, {13.7815, 0}, {13.8992, 0}, {14.0179, 0}, {14.1376, 0}, {14.2583, 0}, {14.38, 0}, {14.5028, 0}, {14.6267, 0}, {14.7516, 0}, {14.8776, 0}, {15.0046, 0}, {15.1327, 0}, {15.2619, 0}, {15.3923, 0}, {15.5237, 0}, {15.6563, 0}, {15.79, 0}, {15.9248, 0}, {16.0608, 0}, {16.1979, 0}, {16.3363, 0}, {16.4757, 0}, {16.6164, 0}, {16.7583, 0}, {16.9014, 0}, {17.0458, 0}, {17.1913, 0}, {17.3381, 0}, {17.4862, 0}, {17.6355, 0}, {17.7861, 0}, {17.938, 0}, {18.0911, 0}, {18.2456, 0}, {18.4014, 0}, {18.5586, 0}, {18.717, 0}, {18.8769, 0}, {19.0381, 0}, {19.2006, 0}, {19.3646, 0}, {19.53, 0}, {19.6967, 0}, {19.8649, 0}, {20.0346, 0}, {20.2056, 0}, {20.3782, 0}, {20.5522, 0}, {20.7277, 0}, {20.9047, 0}, {21.0832, 0}, {21.2632, 0}, {21.4448, 0}, {21.6279, 0}, {21.8126, 0}, {21.9989, 0}, {22.1867, 0}, {22.3762, 0}, {22.5673, 0}, {22.76, 0}, {22.9543, 0}, {23.1503, 0}, {23.348, 0}, {23.5474, 0}, {23.7485, 0}, {23.9513, 0}, {24.1558, 0}, {24.3621, 0}, {24.5701, 0}, {24.7799, 0}, {24.9915, 0}, {25.2049, 0}, {25.4202, 0}, {25.6372, 0}, {25.8561, 0}, {26.0769, 0}, {26.2996, 0}, {26.5242, 0}, {26.7507, 0}, {26.9791, 0}, {27.2095, 0}, {27.4418, 0}, {27.6762, 0}, {27.9125, 0}, {28.1509, 0}, {28.3913, 0}, {28.6337, 0}, {28.8782, 0}, {29.1248, 0}, {29.3735, 0}, {29.6243, 0}, {29.8773, 0}, {30.1324, 0}, {30.3897, 0}, {30.6492, 0}, {30.911, 0}, {31.1749, 0}, {31.4411, 0}, {31.7096, 0}, {31.9804, 0}, {32.2535, 0}, {32.5289, 0}, {32.8067, 0}, {33.0868, 0}, {33.3694, 0}, {33.6543, 0}, {33.9417, 0}, {34.2315, 0}, {34.5238, 0}, {34.8186, 0}, {35.116, 0}, {35.4158, 0}, {35.7183, 0}, {36.0233, 0}, {36.3309, 0}, {36.6411, 0}, {36.954, 0}, {37.2696, 0}, {37.5878, 0}, {37.9088, 0}, {38.2325, 0}, {38.559, 0}, {38.8882, 0}, {39.2203, 0}, {39.5552, 0}, {39.893, 0}, {40.2337, 0}, {40.5772, 0}, {40.9237, 0}, {41.2732, 0}, {41.6256, 0}, {41.9811, 0}, {42.3396, 0}, {42.7011, 0}, {43.0657, 0}, {43.4335, 0}, {43.8044, 0}, {44.1784, 0}, {44.5557, 0}, {44.9362, 0}, {45.3199, 0}, {45.7069, 0}, {46.0972, 0}, {46.4908, 0}, {46.8878, 0}, {47.2882, 0}, {47.692, 0}, {48.0993, 0}, {48.51, 0}, {48.9242, 0}, {49.342, 0}, {49.7633, 0}, {50.1883, 0}, {50.6169, 0}, {51.0491, 0}, {51.485, 0}, {51.9247, 0}, {52.368, 0}, {52.8152, 0}, {53.2662, 0}, {53.7211, 0}, {54.1798, 0}, {54.6425, 0}, {55.1091, 0}, {55.5797, 0}, {56.0543, 0}, {56.5329, 0}, {57.0157, 0}, {57.5026, 0}, {57.9936, 0}, {58.4888, 0}, {58.9883, 0}, {59.492, 0}, {60, 0}}, {Micrometer, 1}]},
				Type -> Object[Data, CoulterCount],
				Name -> "test coulter count data 2 for PlotCoulterCount unit test"<>$SessionUUID
			|>}]
		]
	},
	SymbolTearDown :> {
		plotCoulterCountTestCleanup[];
	}
];

plotCoulterCountTestCleanup[] := Module[{objects, objectsExistQ},
	(* List all test objects to erase. Can use SetUpTestObjects[]+ObjectToString[] to get the comprehensive list. *)
	objects = Flatten[{
		Object[Data, CoulterCount, "test coulter count data 1 for PlotCoulterCount unit test"<>$SessionUUID],
		Object[Data, CoulterCount, "test coulter count data 2 for PlotCoulterCount unit test"<>$SessionUUID],
		If[MatchQ[$CreatedObjects, _List], $CreatedObjects, Nothing]
	}];
	(* Check whether the names we want to give below already exist in the database *)
	objectsExistQ = DatabaseMemberQ[objects];
	(* Erase any objects that we failed to erase in the last unit test. *)
	Quiet[EraseObject[PickList[objects, objectsExistQ], Force -> True, Verbose -> False]];

	Unset[$CreatedObjects];
]

