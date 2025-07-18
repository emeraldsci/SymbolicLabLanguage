(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AllWells*)


DefineTests[
	AllWells,
	{
		Example[{Basic,"If provided with a range of wells, the function gives all wells in the provided range:"},
			AllWells["A1","B12"],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"}}
		],
		Example[{Basic,"If provided with only an end well, the function gives wells from the first well to the provided end well:"},
			AllWells["C12"],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}}
		],
		Example[{Basic,"If provided with no input, the function gives a plate worth of wells:"},
			AllWells[],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"}}
		],
		Example[{Basic,"If provided with a plate model, the function give a full plate worth of wells:"},
			AllWells[Model[Container, Plate, "24-well Tissue Culture Plate"]],
			{{"A1","A2","A3","A4","A5","A6"},{"B1","B2","B3","B4","B5","B6"},{"C1","C2","C3","C4","C5","C6"},{"D1","D2","D3","D4","D5","D6"}}
		],
		Example[{Basic, "If provided with a plate object, this function gives a full plate worth of wells based on the plate's model:"},
			AllWells[Object[Container, Plate, "96 Well Plate"]],
			{
				{"A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12"},
				{"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12"},
				{"C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12"},
				{"D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12"},
				{"E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12"},
				{"F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"},
				{"G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "G10", "G11", "G12"},
				{"H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "H10", "H11", "H12"}
			}
		],
		Example[{Additional,"Well inputs can be in any valid well form including implicitly typed well indexes:"},
			AllWells[24],
			{{1,2,3,4,5,6,7,8,9,10,11,12},{13,14,15,16,17,18,19,20,21,22,23,24}}
		],
		Example[{Options,PlateOrientation,"The PlateOrientation option can be used to control the sublisting of the oToput to either be in Landscape (\"A1\" in Topper left hand corner) or Portrait (\"A1\" in bottom left hand corner) form:"},
			{AllWells[PlateOrientation->Landscape],AllWells[PlateOrientation->Portrait]},
			{{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"}},{{"A12","B12","C12","D12","E12","F12","G12","H12"},{"A11","B11","C11","D11","E11","F11","G11","H11"},{"A10","B10","C10","D10","E10","F10","G10","H10"},{"A9","B9","C9","D9","E9","F9","G9","H9"},{"A8","B8","C8","D8","E8","F8","G8","H8"},{"A7","B7","C7","D7","E7","F7","G7","H7"},{"A6","B6","C6","D6","E6","F6","G6","H6"},{"A5","B5","C5","D5","E5","F5","G5","H5"},{"A4","B4","C4","D4","E4","F4","G4","H4"},{"A3","B3","C3","D3","E3","F3","G3","H3"},{"A2","B2","C2","D2","E2","F2","G2","H2"},{"A1","B1","C1","D1","E1","F1","G1","H1"}}}
		],
		Example[{Options,PlateOrientation,"If None is requested for the PlateOrientation, a flat list of wells will be provided:"},
			AllWells["C10","D12",PlateOrientation->None],
			{"C10","C11","C12","D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}
		],
		Example[{Options,Model,"A plate model can be provided to AllWells to be used for determining the AspectRatio and NumberOfWells:"},
			AllWells[Model->Model[Container, Plate, "24-well Tissue Culture Plate"]],
			{{"A1","A2","A3","A4","A5","A6"},{"B1","B2","B3","B4","B5","B6"},{"C1","C2","C3","C4","C5","C6"},{"D1","D2","D3","D4","D5","D6"}}
		],
		Example[{Options,NumberOfWells,"The maximum NumberOfWells can be directly provided for the function as an option:"},
			AllWells[NumberOfWells->384],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","A13","A14","A15","A16","A17","A18","A19","A20","A21","A22","A23","A24"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12","B13","B14","B15","B16","B17","B18","B19","B20","B21","B22","B23","B24"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12","C13","C14","C15","C16","C17","C18","C19","C20","C21","C22","C23","C24"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12","D13","D14","D15","D16","D17","D18","D19","D20","D21","D22","D23","D24"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12","E13","E14","E15","E16","E17","E18","E19","E20","E21","E22","E23","E24"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","F16","F17","F18","F19","F20","F21","F22","F23","F24"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15","G16","G17","G18","G19","G20","G21","G22","G23","G24"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12","H13","H14","H15","H16","H17","H18","H19","H20","H21","H22","H23","H24"},{"I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12","I13","I14","I15","I16","I17","I18","I19","I20","I21","I22","I23","I24"},{"J1","J2","J3","J4","J5","J6","J7","J8","J9","J10","J11","J12","J13","J14","J15","J16","J17","J18","J19","J20","J21","J22","J23","J24"},{"K1","K2","K3","K4","K5","K6","K7","K8","K9","K10","K11","K12","K13","K14","K15","K16","K17","K18","K19","K20","K21","K22","K23","K24"},{"L1","L2","L3","L4","L5","L6","L7","L8","L9","L10","L11","L12","L13","L14","L15","L16","L17","L18","L19","L20","L21","L22","L23","L24"},{"M1","M2","M3","M4","M5","M6","M7","M8","M9","M10","M11","M12","M13","M14","M15","M16","M17","M18","M19","M20","M21","M22","M23","M24"},{"N1","N2","N3","N4","N5","N6","N7","N8","N9","N10","N11","N12","N13","N14","N15","N16","N17","N18","N19","N20","N21","N22","N23","N24"},{"O1","O2","O3","O4","O5","O6","O7","O8","O9","O10","O11","O12","O13","O14","O15","O16","O17","O18","O19","O20","O21","O22","O23","O24"},{"P1","P2","P3","P4","P5","P6","P7","P8","P9","P10","P11","P12","P13","P14","P15","P16","P17","P18","P19","P20","P21","P22","P23","P24"}}
		],
		Example[{Options,AspectRatio,"An alternative aspect ratio can be directly provided to the function as an option as well:"},
			AllWells[AspectRatio->1,NumberOfWells->100],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10"},{"I1","I2","I3","I4","I5","I6","I7","I8","I9","I10"},{"J1","J2","J3","J4","J5","J6","J7","J8","J9","J10"}}
		],
		Example[{Options,OutputFormat,"Any output format known to ConvertWell is a valid output format for AllWells:"},
			AllWells["B12",OutputFormat->TransposedIndex],
			{{1,9,17,25,33,41,49,57,65,73,81,89},{2,10,18,26,34,42,50,58,66,74,82,90}}
		],
		Example[{Options,InputFormat,"The InputFormat of the well's can be provided to the function for non-explicitly typed wells:"},
			AllWells[90,InputFormat->TransposedIndex],
			{{1,9,17,25,33,41,49,57,65,73,81,89},{2,10,18,26,34,42,50,58,66,74,82,90}}
		],
		Example[{Options,MultiplePlates,"The MultiplePlates option can be used to spesify how to hanle wells beyond a single plate and works as it does in ConvertWell:"},
			AllWells["1A1","2B12",MultiplePlates->Joined],
			{{"1A1","1A2","1A3","1A4","1A5","1A6","1A7","1A8","1A9","1A10","1A11","1A12"},{"1B1","1B2","1B3","1B4","1B5","1B6","1B7","1B8","1B9","1B10","1B11","1B12"},{"1C1","1C2","1C3","1C4","1C5","1C6","1C7","1C8","1C9","1C10","1C11","1C12"},{"1D1","1D2","1D3","1D4","1D5","1D6","1D7","1D8","1D9","1D10","1D11","1D12"},{"1E1","1E2","1E3","1E4","1E5","1E6","1E7","1E8","1E9","1E10","1E11","1E12"},{"1F1","1F2","1F3","1F4","1F5","1F6","1F7","1F8","1F9","1F10","1F11","1F12"},{"1G1","1G2","1G3","1G4","1G5","1G6","1G7","1G8","1G9","1G10","1G11","1G12"},{"1H1","1H2","1H3","1H4","1H5","1H6","1H7","1H8","1H9","1H10","1H11","1H12"},{"2A1","2A2","2A3","2A4","2A5","2A6","2A7","2A8","2A9","2A10","2A11","2A12"},{"2B1","2B2","2B3","2B4","2B5","2B6","2B7","2B8","2B9","2B10","2B11","2B12"}}
		],
		Example[{Options,MultiplePlates,"For example, if MultiplePlates is set to Wrap, it will generate all positions from the start to the finish plate but drop the plate numbering from the position:"},
			AllWells["1A1","2B12",MultiplePlates->Wrap],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"},{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"}}
		],
		Example[{Options,MultiplePlates,"Alternatively, if MultiplePlates is told to Ingore the maximum position, it will roll past H12 in generating wells Top to 2B12:"},
			AllWells["1A1","2B12",MultiplePlates->Ignore],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"},{"I1","I2","I3","I4","I5","I6","I7","I8","I9","I10","I11","I12"},{"J1","J2","J3","J4","J5","J6","J7","J8","J9","J10","J11","J12"}}
		],
		Example[{Options,MultiplePlates,"Or MultiplePlates can be set to Split the oToput into a list of plate and position:"},
			AllWells["1A1","2B12",MultiplePlates->Split],
			{{{"1","A1"},{"1","A2"},{"1","A3"},{"1","A4"},{"1","A5"},{"1","A6"},{"1","A7"},{"1","A8"},{"1","A9"},{"1","A10"},{"1","A11"},{"1","A12"}},{{"1","B1"},{"1","B2"},{"1","B3"},{"1","B4"},{"1","B5"},{"1","B6"},{"1","B7"},{"1","B8"},{"1","B9"},{"1","B10"},{"1","B11"},{"1","B12"}},{{"1","C1"},{"1","C2"},{"1","C3"},{"1","C4"},{"1","C5"},{"1","C6"},{"1","C7"},{"1","C8"},{"1","C9"},{"1","C10"},{"1","C11"},{"1","C12"}},{{"1","D1"},{"1","D2"},{"1","D3"},{"1","D4"},{"1","D5"},{"1","D6"},{"1","D7"},{"1","D8"},{"1","D9"},{"1","D10"},{"1","D11"},{"1","D12"}},{{"1","E1"},{"1","E2"},{"1","E3"},{"1","E4"},{"1","E5"},{"1","E6"},{"1","E7"},{"1","E8"},{"1","E9"},{"1","E10"},{"1","E11"},{"1","E12"}},{{"1","F1"},{"1","F2"},{"1","F3"},{"1","F4"},{"1","F5"},{"1","F6"},{"1","F7"},{"1","F8"},{"1","F9"},{"1","F10"},{"1","F11"},{"1","F12"}},{{"1","G1"},{"1","G2"},{"1","G3"},{"1","G4"},{"1","G5"},{"1","G6"},{"1","G7"},{"1","G8"},{"1","G9"},{"1","G10"},{"1","G11"},{"1","G12"}},{{"1","H1"},{"1","H2"},{"1","H3"},{"1","H4"},{"1","H5"},{"1","H6"},{"1","H7"},{"1","H8"},{"1","H9"},{"1","H10"},{"1","H11"},{"1","H12"}},{{"2","A1"},{"2","A2"},{"2","A3"},{"2","A4"},{"2","A5"},{"2","A6"},{"2","A7"},{"2","A8"},{"2","A9"},{"2","A10"},{"2","A11"},{"2","A12"}},{{"2","B1"},{"2","B2"},{"2","B3"},{"2","B4"},{"2","B5"},{"2","B6"},{"2","B7"},{"2","B8"},{"2","B9"},{"2","B10"},{"2","B11"},{"2","B12"}}}
		],
		Example[{Attributes,"Listable","The function is listable by wells:"},
			AllWells[{"B12","C12","D12"}],
			{{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"}},{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}}}
		],
		Example[{Attributes,"Listable","The function is also listable when provided with a fixed starting well and two different ending wells, it will run the function on both combinations of start to end:"},
			AllWells["B1",{"C12","D12"}],
			{{{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}}}
		],
		Example[{Attributes,"Listable","If provided with lists of both start and end wells of the same length, the function will MapThread over the start, end pairs:"},
			AllWells[{"A1","B1"},{"C12","D12"}],
			{{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}}}
		],
		Example[{Attributes,"Listable","If provided with lists of start and end wells of different lengths, the function will execute for each possible combination of start, end pairs:"},
			AllWells[{"A1","B1","C1"},{"C12","D12"}],
			{{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}},{{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}},{{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"}},{{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"}}}
		],
		Example[{Attributes,"SLLified","The Function is SLLified to take plate model IDs and packets as arguments:"},
			AllWells[Model[Container, Plate, "96-well UV-Star Plate"]],
			{{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12"},{"B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},{"C1","C2","C3","C4","C5","C6","C7","C8","C9","C10","C11","C12"},{"D1","D2","D3","D4","D5","D6","D7","D8","D9","D10","D11","D12"},{"E1","E2","E3","E4","E5","E6","E7","E8","E9","E10","E11","E12"},{"F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"},{"G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12"},{"H1","H2","H3","H4","H5","H6","H7","H8","H9","H10","H11","H12"}}
		],
		Example[{Messages,"BadOrder","If a range is provided where the starting well's position exceeds the ending wells position, the BadOrder message will be thrown:"},
			AllWells["C10","B12"],
			$Failed,
			Messages:>Message[AllWells::BadOrder,"C10","B12"]
		],
		Example[{Messages,"ModelMismatch","If a plate model is provided as both an argument and an option, and they do not agree, the ModelMismatch error will be thrown:"},
			AllWells[Model[Container, Plate, "96-well UV-Star Plate"], Model -> Model[Container, Plate, "384-well UV-Star Plate"]],
			$Failed,
			Messages:>{
				AllWells::ModelMismatch
			}
		],
		Example[{Messages, "ObjectModelMismatch", "If a plate object is provided as an argument and its model does not match the model specified as an option, then the ObjectModelMismatch error will be thrown:"},
			AllWells[Object[Container, Plate, "id:9RdZXv16VKVj"], Model -> Model[Container, Plate, "384-well UV-Star Plate"]],
			$Failed,
			Messages :> {
				AllWells::ObjectModelMismatch
			}
		],
		Example[{Messages,"MissingModel","If the plate object does not have its model specified, the MissingModel error will be thrown:"},
			AllWells[Object[Container, Plate, "id:qdkmxzqJlOB4"]],
			$Failed,
			Messages:>{
				AllWells::MissingModel
			}
		],
		Example[{Messages,"AspectRatioConflict","If a plate model is provided as input and its AspectRatio doesn't match what was provided, return an error:"},
			AllWells[Model[Container, Plate, "96-well UV-Star Plate"], AspectRatio -> 1],
			$Failed,
			Messages:>{
				ConvertWell::AspectRatioConflict
			}
		],
		Example[{Messages,"AspectRatioConflict","If a plate model is provided as an option and its AspectRatio doesn't match what was provided as a separate option, return an error:"},
			AllWells[Model -> Model[Container, Plate, "96-well UV-Star Plate"], AspectRatio -> 1],
			$Failed,
			Messages:>{
				ConvertWell::AspectRatioConflict
			}
		],
		Example[{Messages, "AspectRatioConflict", "If a plate object is provided as an input and its AspectRatio doesn't match what was provided, return an error:"},
			AllWells[Object[Container, Plate, "96 Well Plate"], AspectRatio -> 1],
			$Failed,
			Messages :> {
				ConvertWell::AspectRatioConflict
			}
		],
		Example[{Messages,"AspectRatioConflict","If a plate object is provided as an input and its AspectRatio doesn't match what was provided as a separate option, return an error:"},
			AllWells[Model -> Model[Container, Plate, "96-well UV-Star Plate"], AspectRatio -> 1],
			$Failed,
			Messages:>{
				ConvertWell::AspectRatioConflict
			}
		],
		Example[{Messages,"NumberOfWellsConflict","If a plate model is provided as input and its NumberOfWells doesn't match what was provided, return an error:"},
			AllWells[Model[Container, Plate, "96-well UV-Star Plate"], NumberOfWells -> 48],
			$Failed,
			Messages:>{
				ConvertWell::NumberOfWellsConflict
			}
		],
		Example[{Messages,"NumberOfWellsConflict","If a plate model is provided as an option and its AspectRatio doesn't match what was provided as a separate option, return an error:"},
			AllWells[Model -> Model[Container, Plate, "96-well UV-Star Plate"], NumberOfWells -> 48],
			$Failed,
			Messages:>{
				ConvertWell::NumberOfWellsConflict
			}
		],
		Example[{Messages, "NumberOfWellsConflict", "If a plate object is provided as an input and its NumberOfWells doesn't match what was provided, return an error:"},
			AllWells[Object[Container, Plate, "96 Well Plate"], NumberOfWells -> 6],
			$Failed,
			Messages :> {
				ConvertWell::NumberOfWellsConflict
			}
		],
		Test["Checking for strange error with the special case of two wells:",
			AllWells[2],
			{{1,2}}
		],
		Test["Tests the edgecase of short sublist runs:",
			AllWells["B7","B10"],
			{{"B7","B8","B9","B10"}}
		]
	}
];


(* ::Subsection::Closed:: *)
(*ConvertWell*)


DefineTests[ConvertWell,
{
	Example[{Basic,"Convert a well position into a well index:"},
		ConvertWell["B4"],
		16
	],
	Example[{Basic,"Convert a well index into a well position:"},
		ConvertWell[16,InputFormat->Index],
		"B4"
	],
	Example[{Basic,"Convert from one well index format to another:"},
		ConvertWell[13,InputFormat->Index,OutputFormat->TransposedIndex],
		2
	],
	Example[{Additional,"Position denotes wells as Letter-Digit strings (eg A1, C12, H4). They ascend Left to Right, then Top to Bottom:"},
		ConvertWell[Range[24],InputFormat->Index,OutputFormat->Position],
		{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"}
	],
	Example[{Additional,"Index dontes wells as digits. They ascend Left to Right, then Top to Bottom:"},
		ConvertWell[{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","B1","B2","B3","B4","B5","B6","B7","B8","B9","B10","B11","B12"},InputFormat->Position,OutputFormat->Index],
		Range[24]
	],
	Example[{Additional,"SerpentineIndex format denotes wells as digits. They ascend in alternating Left to Right and Right to Left patterns, but maintain the Top to Bottom order. For exmaple:"},
		ConvertWell[Range[24],InputFormat->SerpentineIndex,OutputFormat->Position],
		{"A1","A2","A3","A4","A5","A6","A7","A8","A9","A10","A11","A12","B12","B11","B10","B9","B8","B7","B6","B5","B4","B3","B2","B1"}
	],
	Example[{Additional,"StaggeredIndex format denotes wells as digits. They ascend every other well in a row, but once they reach the end of a row they return to the beginning of the row to do even numbered wells. After that, they move to the next row:"},
		ConvertWell[Range[24],InputFormat->StaggeredIndex,OutputFormat->Position],
		{"A1","A3","A5","A7","A9","A11","A2","A4","A6","A8","A10","A12","B1","B3","B5","B7","B9","B11","B2","B4","B6","B8","B10","B12"}
	],
	Example[{Additional,"TransposedIndex format denotes wells as digits. They ascend in alternating Left to Right and Right to Left patterns:"},
		ConvertWell[Range[24],InputFormat->TransposedIndex,OutputFormat->Position],
		{"A1","B1","C1","D1","E1","F1","G1","H1","A2","B2","C2","D2","E2","F2","G2","H2","A3","B3","C3","D3","E3","F3","G3","H3"}
	],
	Example[{Additional,"TransposedSerpentineIndex denotes wells as digits. They ascend in alternating Top to Bottom and Bottom to Top patterns:"},
		ConvertWell[Range[24],InputFormat->TransposedSerpentineIndex,OutputFormat->Position],
		{"A1","B1","C1","D1","E1","F1","G1","H1","H2","G2","F2","E2","D2","C2","B2","A2","A3","B3","C3","D3","E3","F3","G3","H3"}
	],
	Example[{Additional,"TransposedStaggeredIndex format denotes wells in the Digit format. They ascend every other well in a column, but once they reach the end of a column they return to the beginning of the column to do even numbered wells. After that, they move to the next column:"},
		ConvertWell[Range[24],InputFormat->TransposedStaggeredIndex,OutputFormat->Position],
		{"A1","C1","E1","G1","B1","D1","F1","H1","A2","C2","E2","G2","B2","D2","F2","H2","A3","C3","E3","G3","B3","D3","F3","H3"}
	],
	Example[{Additional,"RowColumnIndex format denotes wells in the {Digit,Digit} format (eg A1=={1,1},H12=={8,12}). The first digit is the row, and the second is the column. They ascend Left to Right then Top to Bottom:"},
		ConvertWell[{"A1","A2","A3","A4","B1","C1","D1"},InputFormat->Position,OutputFormat->RowColumnIndex],
		{{1,1},{1,2},{1,3},{1,4},{2,1},{3,1},{4,1}}
	],
	Example[{Additional, "If given an empty list, returns an empty list:"},
		ConvertWell[{}],
		{}
	],
	Example[{Issues,"A list of two integers will assume the input is a list of two separate wells if InputFormat is specified as Index, TransposedIndex, SerpentineIndex, StaggeredIndex, TransposedSerpentineIndex, or TransposedStaggeredIndex:"},
		ConvertWell[{3,97}, InputFormat -> Index, MultiplePlates -> Split],
		{{"1", "A3"}, {"2", "A1"}}
	],
	Example[{Issues, "A list of two integers will assume the input is an ordered pair if InputFormat is specified as RowColumnIndex:"},
		ConvertWell[{1,11}, InputFormat -> RowColumnIndex],
		"A11"
	],
	Example[{Issues, "A list of two integers will assume the input is an ordered pair if InputFormat is not specified at all:"},
		ConvertWell[{1,11}],
		"A11"
	],
	Example[{Attributes,"Listable","The function is listable by wells:"},
		ConvertWell[{"A1","B1","C1"}],
		{1,13,25}
	],
	Example[{Options,InputFormat,"The input format can be provided via the InputFormat option:"},
		ConvertWell[13,InputFormat->TransposedIndex],
		"E2"
	],
	Example[{Options,OutputFormat,"The desired output format can be provided as well:"},
		ConvertWell["B1",OutputFormat->SerpentineIndex],
		24
	],
	Example[{Options,MultiplePlates,"If MultiplePlates is left on Automatic and converting to positions, if the well's position exceeds the NumberOfWells, Joined is assumed:"},
		{ConvertWell[96,MultiplePlates->Automatic],ConvertWell[97,MultiplePlates->Automatic]},
		{"H12","2A1"}
	],
	Example[{Options,MultiplePlates,"If MultiplePlates is left on Automatic and converting to indexes, if the well's position exceeds the NumberOfWells, Split is assumed:"},
		{ConvertWell["H12"],ConvertWell["I1"]},
		{96,{"2",1}}
	],
	Example[{Options, Model, "If Model is specified, convert the well using the AspectRatio and NumberOfWells present in that model:"},
		ConvertWell[5, Model -> Model[Container, Plate, "6-well Tissue Culture Plate"]],
		"B2"
	],
	Example[{Options, AspectRatio, "Convert the well assuming the plate has the specified AspectRatio.  Often ought to be specified with NumberOfWells:"},
		ConvertWell["B2", AspectRatio -> 1, NumberOfWells -> 4],
		4
	],
	Example[{Options, NumberOfWells, "Convert the well assuming the plate has the specified NumberOfWells:"},
		ConvertWell["B2", NumberOfWells -> 6],
		5
	],
	Example[{Messages, "NumberOfWellsConflict", "When the model's information regarding NumberOfWells conflicts with the given options, the NumberOfWellsConflict error is thrown:"},
		ConvertWell["A1", Model -> Model[Container, Plate, "6-well Tissue Culture Plate"], NumberOfWells -> 5],
		$Failed,
		Messages :> {ConvertWell::NumberOfWellsConflict}
	],
	Example[{Messages,"AspectRatioConflict","When the model's information regarding AspectRatio conflicts with the given options, the AspectRatioConflict error is thrown:"},
		ConvertWell["A1", Model->Model[Container, Plate, "6-well Tissue Culture Plate"], AspectRatio->1],
		$Failed,
		Messages:>{Message[ConvertWell::AspectRatioConflict,Model[Container, Plate, "6-well Tissue Culture Plate"],3/2,1]}
	],
	Example[{Messages,"BadRatio","If the provided AspectRatio and NumberOfWells would lead to a non-rectangular plate, the BadRatio message is thrown:"},
		ConvertWell[96,AspectRatio->3/2,NumberOfWells->100],
		$Failed,
		Messages:>{Message[ConvertWell::BadRatio,3/2,100]}
	],
	Example[{Messages,"BadRatio","If the provided AspectRatio and NumberOfWells would lead to a non-rectangular plate, the BadRatio message is thrown:"},
		ConvertWell[96,AspectRatio->2,NumberOfWells->96],
		$Failed,
		Messages:>{Message[ConvertWell::BadRatio,2,96]}
	],
	Example[{Messages, "JoinedIndex", "If MultiplePlates is set to Joined, OutputFormat should be Position; otherwise a warning is thrown:"},
		ConvertWell[96, MultiplePlates -> Joined, OutputFormat -> Index],
		{"1", 96},
		Messages :> {Message[ConvertWell::JoinedIndex]}
	],
	Example[{Messages, "Strict", "If MultiplePlates is set to Strict, the inputted well must not exceed the maximum NumberOfWells:"},
		ConvertWell[7, MultiplePlates -> Strict, NumberOfWells -> 6],
		$Failed,
		Messages :> {Message[ConvertWell::Strict]}
	],
	Example[{Messages, "InputFormatConflict", "If InputFormat is specified but does not agree with the input well format, return an error:"},
		ConvertWell[{1,11}, InputFormat -> Position],
		$Failed,
		Messages :> {Message[ConvertWell::InputFormatConflict]}
	],
	Test["Testing conversion of letter followed by 0 and then a number:",
		ConvertWell["A09"],
		9
	],
	Test["Non-rationalized AspectRatio input of sufficient precision is rationalized to avoid BadRatio errors:",
		ConvertWell["A1", NumberOfWells->48, AspectRatio->1.3333333333333`],
		1
	],
	Test["Non-rationalized AspectRatio input of insufficient precision will result in BadRatio errors:",
		ConvertWell["A1", NumberOfWells->48, AspectRatio->1.33333`],
		$Failed,
		Messages :> {ConvertWell::BadRatio}
	]
}
];



(* ::Subsection::Closed:: *)
(*centrifugeBalance *)


DefineTests[
	centrifugeBalance,
	{
		Example[{Basic,"Returns the paired and unpaired containers when not all containers can be paired:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[7,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[8.5,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[4.5,"Grams"], {1}},
				{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[9,"Grams"], {1}},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[3,"Grams"], {1}},
				{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[5,"Grams"], {1}},
				{Object[Container,Plate,"id:pZx9jo875rvE"],Quantity[6.5,"Grams"], {1}},
				{Object[Container,Plate,"id:4pO6dM59N7BX"],Quantity[10,"Grams"], {1}}
			}],
			{
				{
					{Object[Container,Plate,"id:n0k9mG84xJNo"],Object[Container,Plate,"id:dORYzZJ5KlNb"]},
					{Object[Container,Plate,"id:qdkmxzql3bNm"],Object[Container,Plate,"id:pZx9jo875rvE"]},
					{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Object[Container,Plate,"id:1ZA60vLNMWBq"]},
					{Object[Container,Plate,"id:01G6nvwoVWBE"],Object[Container,Plate,	"id:eGakldJXZLNz"]}
				},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Object[Container,Plate,"id:4pO6dM59N7BX"]}
			}
		],
		Example[{Basic,"Returns the paired and unpaired containers (empty list) when all containers can be paired:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[1.1,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:pZx9jo875rvE"],Quantity[1,"Grams"], {1}},
				{Object[Container,Plate,"id:4pO6dM59N7BX"],Quantity[0.7,"Grams"], {1}}
			}],
			{
				{
					{Object[Container, Plate, "id:qdkmxzql3bNm"],Object[Container, Plate, "id:n0k9mG84xJNo"]},
					{Object[Container,Plate, "id:01G6nvwoVWBE"],Object[Container, Plate, "id:1ZA60vLNMWBq"]},
					{Object[Container,Plate, "id:Z1lqpMzdA4W4"],Object[Container, Plate, "id:dORYzZJ5KlNb"]},
					{Object[Container,Plate, "id:eGakldJXZLNz"],Object[Container, Plate, "id:pZx9jo875rvE"]},
					{Object[Container,Plate, "id:R8e1Pjp6q7Jj"],Object[Container, Plate, "id:4pO6dM59N7BX"]}
				},
				{}
			}
		],
		Example[{Additional,"When only one container is given, returns that container in the unpaired list; the paired list returns empty:"},
			centrifugeBalance[{{Object[Container,Plate,"id:4pO6dM59N7BX"],Quantity[10,"Grams"]}}],
			{{},{Object[Container,Plate,"id:4pO6dM59N7BX"]}}
		],
		Example[{Basic,"Returns the paired (empty list) and unpaired containers when no containers can be paired:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[10,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[8.5,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[4,"Grams"], {1}}
			}],
			{
				{},
				{Object[Container, Plate, "id:qdkmxzql3bNm"],
					Object[Container, Plate, "id:R8e1Pjp6q7Jj"],
					Object[Container, Plate, "id:n0k9mG84xJNo"],
					Object[Container, Plate, "id:01G6nvwoVWBE"]}}
		],
		Example[{Options,AllowedImbalance,"Specify the allowed mass difference within container pairs as a weight:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[0.1,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[0.3,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3.1,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[3.2,"Grams"], {1}},
				{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[3.3,"Grams"], {1}},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[3.5,"Grams"], {1}},
				{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[5.5,"Grams"], {1}},
				{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[5.2,"Grams"], {1}}
			},AllowedImbalance->1Gram],
			{
				{
					{Object[Container, Plate, "id:01G6nvwoVWBE"], Object[Container, Plate, "id:1ZA60vLNMWBq"]},
					{Object[Container, Plate, "id:qdkmxzql3bNm"], Object[Container, Plate, "id:R8e1Pjp6q7Jj"]},
					{Object[Container, Plate, "id:dORYzZJ5KlNb"], Object[Container, Plate, "id:eGakldJXZLNz"]},
					{Object[Container, Plate, "id:n0k9mG84xJNo"], Object[Container, Plate, "id:Z1lqpMzdA4W4"]}
				},
				{}}
		],
		Example[{Options,AllowedImbalance,"Specify the allowed mass difference within container pairs as a percentage of the heaviest input container weight:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[0.1,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[0.3,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3.1,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[3.2,"Grams"], {1}},
				{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[3.3,"Grams"], {1}},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[3.5,"Grams"], {1}},
				{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[5.5,"Grams"], {1}},
				{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[5.2,"Grams"], {1}}
			},AllowedImbalance->0.2],
			{
				{
					{Object[Container, Plate, "id:01G6nvwoVWBE"], Object[Container, Plate, "id:1ZA60vLNMWBq"]},
					{Object[Container, Plate, "id:qdkmxzql3bNm"], Object[Container, Plate, "id:R8e1Pjp6q7Jj"]},
					{Object[Container, Plate, "id:dORYzZJ5KlNb"], Object[Container, Plate, "id:eGakldJXZLNz"]},
					{Object[Container, Plate, "id:n0k9mG84xJNo"], Object[Container, Plate, "id:Z1lqpMzdA4W4"]}
				},
				{}}
		],
		Example[{Options,AllowedImbalance,"Decreasing the allowable imbalance increases pairing stringency:"},
			centrifugeBalance[{
				{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[0.1,"Grams"], {1}},
				{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[0.3,"Grams"], {1}},
				{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3.1,"Grams"], {1}},
				{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[3.2,"Grams"], {1}},
				{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[3.3,"Grams"], {1}},
				{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[3.5,"Grams"], {1}},
				{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[5.5,"Grams"], {1}},
				{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[5.2,"Grams"], {1}}
			},AllowedImbalance->0.2Gram],
			{
				{
					{Object[Container, Plate, "id:01G6nvwoVWBE"],Object[Container, Plate, "id:1ZA60vLNMWBq"]},
					{Object[Container,Plate, "id:qdkmxzql3bNm"],Object[Container, Plate, "id:R8e1Pjp6q7Jj"]}
				},
				{Object[Container,Plate, "id:n0k9mG84xJNo"],
					Object[Container, Plate, "id:Z1lqpMzdA4W4"],
					Object[Container, Plate, "id:dORYzZJ5KlNb"],
					Object[Container, Plate, "id:eGakldJXZLNz"]}
			}
		],

	Example[{Options,ReturnMasses,"Returns the paired and unpaired containers along with their masses:"},
		centrifugeBalance[{
			{Object[Container,Plate,"id:qdkmxzql3bNm"],Quantity[7,"Grams"], {1}},
			{Object[Container,Plate,"id:R8e1Pjp6q7Jj"],Quantity[8.5,"Grams"], {1}},
			{Object[Container,Plate,"id:n0k9mG84xJNo"],Quantity[3,"Grams"], {1}},
			{Object[Container,Plate,"id:01G6nvwoVWBE"],Quantity[4.5,"Grams"], {1}},
			{Object[Container,Plate,"id:1ZA60vLNMWBq"],Quantity[9,"Grams"], {1}},
			{Object[Container,Plate,"id:Z1lqpMzdA4W4"],Quantity[1,"Grams"], {1}},
			{Object[Container,Plate,"id:dORYzZJ5KlNb"],Quantity[3,"Grams"], {1}},
			{Object[Container,Plate,"id:eGakldJXZLNz"],Quantity[5,"Grams"], {1}},
			{Object[Container,Plate,"id:pZx9jo875rvE"],Quantity[6.5,"Grams"], {1}},
			{Object[Container,Plate,"id:4pO6dM59N7BX"],Quantity[10,"Grams"], {1}}
		},ReturnMasses -> True],
		{
			{
				{{Object[Container, Plate, "id:n0k9mG84xJNo"], Quantity[3, "Grams"], {1}}, {Object[Container, Plate, "id:dORYzZJ5KlNb"], Quantity[3, "Grams"], {1}}},
				{{Object[Container, Plate, "id:qdkmxzql3bNm"], Quantity[7, "Grams"], {1}}, {Object[Container, Plate, "id:pZx9jo875rvE"], Quantity[6.5, "Grams"], {1}}},
				{{Object[Container, Plate, "id:R8e1Pjp6q7Jj"], Quantity[8.5, "Grams"], {1}}, {Object[Container, Plate, "id:1ZA60vLNMWBq"], Quantity[9, "Grams"], {1}}},
				{{Object[Container, Plate, "id:01G6nvwoVWBE"], Quantity[4.5, "Grams"], {1}}, {Object[Container, Plate, "id:eGakldJXZLNz"], Quantity[5, "Grams"], {1}}}},
			{
				{Object[Container, Plate, "id:Z1lqpMzdA4W4"], Quantity[1, "Grams"], {1}},
				{Object[Container, Plate, "id:4pO6dM59N7BX"], Quantity[10, "Grams"], {1}}
			}
		}
	]
	}
];



(* ::Subsection:: *)
(*PreferredContainer*)


(* ::Subsubsection::Closed:: *)
(*PreferredContainer*)


DefineTests[PreferredContainer,
	{
		Example[{Basic,"Returns the most suitable container to contain a volume:"},
			PreferredContainer[1 Milliliter],
			ObjectP[Model[Container,Vessel]]
		],
		Example[{Basic,"Input volume will be less than the MaxVolume of the preferred container:"},
			Download[
				PreferredContainer[3 Liter],
				MaxVolume
			],
			GreaterEqualP[3 Liter]
		],
		Example[{Basic,"Provide a model and volume to help resolve compatible container criteria such as LightSensitive and Sterile:"},
			Download[
				PreferredContainer[Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],1.5 Liter],
				{MaxVolume,Sterile}
			],
			{GreaterEqualP[1.5 Liter],True}
		],
		Example[{Additional,"Provide multiple models and volumes to help resolve compatible container criteria such as LightSensitive and Sterile:"},
			PreferredContainer[{Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]},{1.5 Liter,1.6 Liter}],
			{ObjectP[Model[Container,Vessel]],ObjectP[Model[Container,Vessel]]}
		],
		Example[{Additional,"Return the vessels that can be heated to 150 Celsius and hold at least 25 mL:"},
			PreferredContainer[25 Milliliter, MaxTemperature -> 150 Celsius, All -> True],
			{ObjectP[Model[Container,Vessel]],ObjectP[Model[Container,Vessel]],ObjectP[Model[Container,Vessel]]}
		],
		RunTest[Example[{Additional,
			"Return the vessels that can be cooled to -195 Celsius and hold at least 1.5 mL:"},
			PreferredContainer[1.5 Milliliter, MinTemperature -> -195 Celsius,All -> True],
			{ObjectP[Model[Container, Vessel]],	ObjectP[Model[Container, Vessel]]}]
		],
		Example[{Additional,"Return all vessels that may be selected for a given option combination:"},
			PreferredContainer[All],
			{
				Model[Container, Vessel, "id:o1k9jAG00e3N"],
				Model[Container, Vessel, "id:eGakld01zzpq"],
				Model[Container, Vessel, "id:3em6Zv9NjjN8"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				Model[Container, Vessel, "id:jLq9jXvA8ewR"],
				Model[Container, Vessel, "id:01G6nvwPempK"],
				Model[Container, Vessel, "id:J8AY5jwzPPR7"],
				Model[Container, Vessel, "id:aXRlGnZmOONB"],
				Model[Container, Vessel, "id:zGj91aR3ddXJ"],
				Model[Container, Vessel, "id:3em6Zv9Njjbv"],
				Model[Container, Vessel, "id:Vrbp1jG800Zm"],
				Model[Container, Vessel, "id:dORYzZJpO79e"],
				Model[Container, Vessel, "id:mnk9jOkn6oMZ"],
				Model[Container, Vessel, "id:Vrbp1jG800lE"],
				Model[Container, Vessel, "id:aXRlGnZmOOB9"],
				Model[Container, Vessel, "id:3em6Zv9NjjkY"]
			}
		],
		Example[{Additional,"Returns the most suitable container to contain a mass:"},
			PreferredContainer[1 Kilogram],
			ObjectP[Model[Container,Vessel]]
		],
		(* Example and tests for Model and Sample overload with or without IncompatibleMaterial option *)
		Example[{Additional, "Function takes single Object[Sample] as input:"},
			PreferredContainer[Object[Sample, "Test sample for PreferredContainers"<>$SessionUUID], 30 Milliliter],
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]] (* "100 mL Glass Bottle" *)
		],
		Example[{Additional, "Function takes a list of Object[Sample] as input:"},
			PreferredContainer[{Object[Sample, "Test sample for PreferredContainers"<>$SessionUUID], Object[Sample, "Test sample for PreferredContainers"<>$SessionUUID]}, 30 Milliliter],
			{ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]], ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]]}
		],
		Example[{Additional, "If IncompatibleMaterials option is not specified for Model[Sample] input, it will read from the IncompatibleMaterials field of the Model[Sample] input:"},
			PreferredContainer[Model[Sample, "id:eGakld01zzZn"], 30 Milliliter, IncompatibleMaterials -> Automatic], (* Model[Sample, "Nitric Acid 70%"] *)
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]] (* "100 mL Glass Bottle" *)
		],
		Example[{Additional, "If IncompatibleMaterials option is specified for Model[Sample] input, it will be combined with the IncompatibleMaterials field from the input Model[Sample] to determine the final container:"},
			PreferredContainer[Model[Sample, "id:eGakld01zzZn"], 30 Milliliter, IncompatibleMaterials -> {None}], (* Model[Sample, "Nitric Acid 70%"] *)
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]] (* "100 mL Glass Bottle" *)
		],
		Example[{Additional, "If IncompatibleMaterials option is not specified for Object[Sample] input, it will read from the IncompatibleMaterials field of the Object[Sample] input:"},
			PreferredContainer[Object[Sample, "Test sample for PreferredContainers"<>$SessionUUID], 30 Milliliter, IncompatibleMaterials -> Automatic], (* Model[Sample, "Nitric Acid 70%"] *)
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]] (* "100 mL Glass Bottle" *)
		],
		Test["If input is a list of Model[Sample] while IncompatibleMaterials is a single List, function can automatically expand to index-match",
			PreferredContainer[{Model[Sample, "id:8qZ1VWNmdLBD"], Model[Sample, "id:8qZ1VWNmdLBD"]}, 20 Milliliter, IncompatibleMaterials -> {Polystyrene, Polypropylene}, CellType -> Bacterial],
			{ObjectP[Model[Container, Vessel, "id:N80DNjlYwwjo"]], ObjectP[Model[Container, Vessel, "id:N80DNjlYwwjo"]]}
		],
		(* Basic example for a hidden overload using Volume and a list of desired containers *)
		Test["When given a volume and a list of compatible containers, it picks the first non-deprecated container provided with the lowest usable MaxVolume:",
			PreferredContainer[10*Milliliter,{Model[Container, Vessel, "id:M8n3rxYE55b5"],Model[Container, Vessel, "id:9RdZXvKBeeqL"],Model[Container, Vessel, "id:n0k9mGzRaa3r"]}],
			Model[Container, Vessel, "id:9RdZXvKBeeqL"]
		],
		Test["When given a volume and a list of incompatible containers, it defaults to using the public list of preferred vessels:",
			PreferredContainer[10*Milliliter,{Model[Container, Vessel, "id:9RdZXvKBeeqL"],Model[Container, Vessel, "id:M8n3rxYE55b5"],Model[Container, Vessel, "id:n0k9mGzRaa3r"]},LightSensitive->True],
			PreferredContainer[10*Milliliter,LightSensitive->True]
		],
		Test["When given a volume and an empty list, it defaults to using the public list of preferred vessels:",
			PreferredContainer[10*Milliliter,{},LightSensitive->True],
			PreferredContainer[10*Milliliter,LightSensitive->True]
		],
		Example[{Options,LightSensitive,"Vessels compatible with light sensitive contents can be toggled:"},
			Download[
				PreferredContainer[1 Milliliter, LightSensitive -> True],
				Opaque
			],
			True
		],
		Example[{Options,All,"If All->True, all potential preferred vessels that can hold the volume of our sample are returned:"},
			PreferredContainer[1 Milliliter, All->True],
			{ObjectP[Model[Container,Vessel]]..}
		],
		Example[{Options,Sterile,"Sterile vessels can be toggled:"},
			Download[
				PreferredContainer[200 Milliliter, Sterile -> True],
				Sterile
			],
			True
		],
		Example[{Options,Messages,"Messages are not thrown if Messages->False:"},
			PreferredContainer[1 Gigaliter, Messages->False],
			$Failed
		],
		Example[{Options,Density,"Use Density option to assist the function in determing appropriate vessels for mass inputs:"},
			Convert[
				Download[
					PreferredContainer[350 Gram, Density -> 2*(Gram/Milliliter)],
					MaxVolume
				],
				Milliliter
			],
			250.`*Milliliter
		],
		Test["Ensure that density determined volume that falls exactly on 150mL picks the vessel with MaxVolume at 150mL:",
			Convert[
				Download[
					PreferredContainer[300 Gram, Density -> 2*(Gram/Milliliter)],
					MaxVolume
				],
				Milliliter
			],
			150.`*Milliliter
		],
		Example[{Options,Type,"Specify that a plate should be returned:"},
			PreferredContainer[1 Milliliter, Type->Plate],
			ObjectP[Model[Container,Plate]]
		],
		Example[{Options,Type,"Specify that a list of plates and vessels should be returned:"},
			PreferredContainer[1 Milliliter, Type->All, All->True],
			{
				Model[Container, Vessel, "id:eGakld01zzpq"],
				Model[Container, Vessel, "id:3em6Zv9NjjN8"],
				Model[Container, Vessel, "id:bq9LA0dBGGR6"],
				Model[Container, Vessel, "id:jLq9jXvA8ewR"],
				Model[Container, Vessel, "id:01G6nvwPempK"],
				Model[Container, Vessel, "id:J8AY5jwzPPR7"],
				Model[Container, Vessel, "id:aXRlGnZmOONB"],
				Model[Container, Vessel, "id:zGj91aR3ddXJ"],
				Model[Container, Vessel, "id:3em6Zv9Njjbv"],
				Model[Container, Vessel, "id:Vrbp1jG800Zm"],
				Model[Container, Vessel, "id:dORYzZJpO79e"],
				Model[Container, Vessel, "id:mnk9jOkn6oMZ"],
				Model[Container, Vessel, "id:Vrbp1jG800lE"],
				Model[Container, Vessel, "id:aXRlGnZmOOB9"],
				Model[Container, Vessel, "id:3em6Zv9NjjkY"],
				Model[Container, Plate, "id:L8kPEjkmLbvW"],
				Model[Container, Plate, "id:E8zoYveRllM7"],
				Model[Container, Plate, "id:lYq9jRqw70m4"],
				Model[Container, Plate, "id:AEqRl9qmr111"]
			}],
		Example[{Options, VacuumFlask, "Specify that a vacuum flask that supports the given volume should be returned:"},
			PreferredContainer[50 Milliliter, VacuumFlask -> True],
			ObjectP[Model[Container, Vessel, "125 mL Filter Flask"]]
		],
		Example[{Options, CultureAdhesion, "Specify a Bacterial CellType and a SolidMedia CultureAdhesion :"},
			PreferredContainer[35 Milliliter, Type->Plate, CellType->Bacterial, CultureAdhesion->SolidMedia],
			ObjectP[Model[Container, Plate, "id:O81aEBZjRXvx"]] (* Model[Container, Plate, "Omni Tray Sterile Media Plate"] *)
		],
		Example[{Options, IncompatibleMaterials, "Specify a list of incompatible materials that container should avoid:"},
			PreferredContainer[1 Milliliter, IncompatibleMaterials -> {Polypropylene}],
			ObjectP[Model[Container, Vessel, "id:jLq9jXvA8ewR"]] (* "100 mL Glass Bottle" *)
		],
		Test["When given a volume and a list of compatible containers and VacuumFlask is set to True, then filter out the non-vacuum flasks before returning the smallest usable one:",
			PreferredContainer[10*Milliliter,{Model[Container, Vessel, "id:M8n3rxYE55b5"],Model[Container, Vessel, "id:9RdZXvKBeeqL"],Model[Container, Vessel, "id:n0k9mGzRaa3r"], Model[Container, Vessel, "125 mL Filter Flask"], Model[Container, Vessel, "500 mL Filter Flask"]}, VacuumFlask -> True],
			ObjectP[Model[Container, Vessel, "125 mL Filter Flask"]]
		],
		Test["Given the complexity of estimating a mass's packing density, density should default to 1g/ml:",
			Convert[
				Download[
					PreferredContainer[300 Gram],
					MaxVolume
				],
				Milliliter
			],
			500.`*Milliliter
		],
		Test["If a Model[Sample] is LightSensitive, PreferredContainer will default LightSensitive to True:",
			Download[
				PreferredContainer[Model[Sample, "id:O81aEB4kJXxx"],100 Microliter],
				Opaque
			],
			True
		],
		Test["Even if a Model[Sample] is LightSensitive, PreferredContainer will defer to LightSensitive provided as an option:",
			{
				Download[
					PreferredContainer[Model[Sample, "id:O81aEB4kJXxx"],100 Microliter],
					Opaque
				],
				Download[
					PreferredContainer[Model[Sample, "id:O81aEB4kJXxx"], 100 Microliter, LightSensitive -> False],
					Opaque
				]
			},
			{True,False}
		],
		Example[{Messages,"ContainerNotFound","Returns $Failed when no vessel was found for the given volume and compatibility criteria:"},
			PreferredContainer[30 Liter],
			$Failed,
			Messages:>{PreferredContainer::ContainerNotFound}
		],
		Test["If multiple models are provided but the options provided aren't properly index matched, all options are defaulted:",
			Download[
				PreferredContainer[{Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]},{1Liter,1.5Liter,1.9Liter},LightSensitive->{True,True}],
				{MaxVolume,Opaque}
			],
			{{GreaterEqualP[1 Liter],False},{GreaterEqualP[1.5 Liter],False},{GreaterEqualP[1.9 Liter],False}}
		],
		Test["If inputs are not properly indexed, return $Failed:",
			PreferredContainer[{Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],Model[Sample, StockSolution, "id:4pO6dMWvnA0X"],Model[Sample, StockSolution, "id:4pO6dMWvnA0X"]},{1Liter,1.5Liter}],
			$Failed,
			Messages:>{Error::InputLengthMismatch}
		],
		Test["When provided an empty list, return an empty list:",
			PreferredContainer[{},LightSensitive->True,Sterile->True],
			{}
		],
		Test["When provided an empty list for both inputs, return an empty list:",
			PreferredContainer[{},{},LightSensitive->True,Sterile->True],
			{}
		],
		Test["When provided an empty list and a list of volumes, return an empty list:",
			PreferredContainer[{},{200*Milliliter,5*Milliliter},LightSensitive->{True,False},Sterile->{True,False}],
			{}
		],
		Test["When asking for an amount that is below a sample's PreferredContainer's MinVolume, default to a container from the base container lists instead:",
			PreferredContainer[Model[Sample, StockSolution, "id:L8kPEjnN3zww"],0.9 Milliliter],
			PreferredContainer[0.9 Milliliter]
		]
	},
	SymbolSetUp :> Module[{allObjects, existingObjects},
		allObjects = {
			Object[Sample, "Test sample for PreferredContainers"<>$SessionUUID]
		};
		existingObjects = PickList[allObjects, DatabaseMemberQ[allObjects], True];
		EraseObject[existingObjects, Verbose -> False, Force -> True];
		$CreatedObjects = {};
		(* Cannot use UploadSample to create test sample, because LegacySLL package load before InternalUpload *)
		Upload[<|
			Type -> Object[Sample],
			Name -> "Test sample for PreferredContainers"<>$SessionUUID,
			Replace[IncompatibleMaterials] -> {Polypropylene},
			DeveloperObject -> True
		|>]
	],
	SymbolTearDown :> (
		EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects], True], Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	)
];
