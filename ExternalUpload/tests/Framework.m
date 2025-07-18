(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[approximateDensity,
	{
		Test["Approximates density when provided composition with 2 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 VolumePercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 2 MassPercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 MassPercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.5 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided composition with 1 MassPercent and 1 VolumePercent components:",
			Round[UnitConvert[approximateDensity[{
				{50 MassPercent,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample1"], ID->"id:testSample1"|>},
				{50 VolumePercent,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Model[Molecule], Object->Model[Molecule, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when provided volumes for both components being mixed:",
			Round[UnitConvert[approximateDensity[{
				{1 Milliliter,<|State->Liquid, Density->(1 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample1"], ID->"id:testSample1"|>},
				{1 Milliliter,<|State->Liquid, Density->(2 Gram/Milliliter), Type->Object[Sample], Object->Object[Sample, "id:testSample2"], ID->"id:testSample2"|>}
			}],"Grams"/"Milliliters"],0.01],
			(1.67 Gram/Milliliter),
			EquivalenceFunction->Equal
		],
		Test["Approximates density when transferring 0 mL to 0 mL to not freak out and just pick water's density:",
			Round[UnitConvert[approximateDensity[{
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample1"], ID -> "id:testSample1"|>},
				{0 Milliliter, <|State -> Liquid, Density -> Null, Type -> Object[Sample], Object -> Object[Sample, "id:testSample2"], ID -> "id:testSample2"|>}
			}], "Grams" / "Milliliters"], 0.01],
			(1. Gram / Milliliter),
			EquivalenceFunction -> Equal
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*findSDS*)

DefineTests[
	findSDS,
	{
		(* Integration test - pings ChemicalSafety.com (data is memoized between tests) *)
		Example[{Basic, "Return the URL to a potential SDS file for a compound with the supplied CAS number:"},
			findSDS["58-08-2", Output -> URL],
			URLP
		],
		Example[{Basic, "Return the URL to a potential SDS file for a compound with the supplied name:"},
			findSDS["caffeine", Output -> URL],
			URLP
		],
		(* Integration test - downloads SDS from Thermo. (data is memoized between tests) *)
		Example[{Options, Output, "Confirm that the URL returned is valid and points to a pdf:"},
			findSDS["58-08-2", Output -> ValidatedURL],
			URLP
		],
		Example[{Options, Output, "Download an SDS for the requested compound and return the filepath to the downloaded file:"},
			findSDS["58-08-2", Output -> TemporaryFile],
			_File
		],
		Example[{Options, Output, "Download an SDS for the requested compound and open it:"},
			findSDS["58-08-2", Output -> Open],
			Null,
			Stubs :> {SystemOpen[___] := Null}
		],
		Example[{Options, Output, "Download an SDS for the requested compound and upload it to constellation:"},
			findSDS["58-08-2", Output -> CloudFile],
			ObjectP[Object[EmeraldCloudFile]]
		],
		Example[{Options, Vendor, "Specify a preferred vendor to obtain the SDS from. Vendor names should match part of the vendor's URL:"},
			findSDS["58-08-2", Output -> URL, Vendor -> "Thermofisher"],
			URLP
		],
		Example[{Options, Vendor, "Specify a preferred manufacturer to obtain the SDS for. Manufacturer names should match the name of the manufacturer used by ChemicalSafety:"},
			findSDS["58-08-2", Output -> URL, Manufacturer -> "Thermofisher"],
			URLP
		],
		Example[{Options, Product, "Specify the preferred product ID to obtain the SDS for. The ID must match part of the vendor's URL:"},
			findSDS["58-08-2", Output -> URL, Product -> "ALFAA39214"],
			URLP
		],
		Test["Default vendor, manufacturer and product prioritization works as expected:",
			findSDS["Test", Output -> URL],
			"http://www.thermofisher.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Product ID prioritization works as expected:",
			findSDS["Test", Product -> "123v3", Output -> URL],
			"http://www.sigmaaldrich.com/product123v3-url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Vendor prioritization works as expected:",
			findSDS["Test", Vendor -> "emerald", Output -> URL],
			"http://www.emeraldcloudlab.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Manufacturer prioritization works as expected:",
			findSDS["Test", Manufacturer -> "random", Output -> URL],
			"http://www.sigmaaldrich.com/url1.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		],
		Test["Combining Manufacturer and Vendor prioritization works as expected:",
			findSDS["Test", Manufacturer -> "Fisher", Vendor -> "sigma", Output -> URL],
			"http://www.sigmaaldrich.com/url4.pdf",
			Stubs :> {
				searchChemicalSafetySDS["Test"] := {
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma", "URL" -> "http://www.sigmaaldrich.com/product123v3-url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Sigma Aldrich", "URL" -> "http://www.sigmaaldrich.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Aldrich", "URL" -> "http://www.sigmaaldrich.com/url3.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.sigmaaldrich.com/url4.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermofisher", "URL" -> "http://www.thermofisher.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Thermo", "URL" -> "http://www.thermofisher.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Fisher Scientific", "URL" -> "http://www.fishersci.com/url2.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "VWR", "URL" -> "http://www.emeraldcloudlab.com/url1.pdf"|>,
					<|"CAS" -> "58-08-2", "Manufacturer" -> "Random", "URL" -> "http://www.sigmaaldrich.com/url1.pdf"|>
				}
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*downloadAndValidateURL*)

DefineTests[downloadAndValidateURL,
	{
		Example[{Basic, "Download and memoize a website and check that the downloaded version contains valid HTML:"},
			downloadAndValidateURL[
				"www.emeraldcloudlab.com",
				"site.html",
				MatchQ[FileFormat[#], "HTML"] &
			],
			_File
		],
		Example[{Basic, "Returns and memoizes $Failed if the downloaded file doesn't pass validation:"},
			downloadAndValidateURL[
				"www.emeraldcloudlab.com/",
				"site.pdf",
				MatchQ[FileFormat[#], "PDF"] &
			],
			$Failed
		],
		Test["Function result is memoized:",
			downloadAndValidateURL[
				"www.emeraldcloudlab.com",
				"site.html",
				MatchQ[FileFormat[#], "HTML"] &
			];

			AbsoluteTiming[
				downloadAndValidateURL[
					"www.emeraldcloudlab.com",
					"site.html",
					MatchQ[FileFormat[#], "HTML"] &
				]
			],
			{LessP[0.001], _File}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*validateLocalFile*)

DefineTests[validateLocalFile,
	{
		Example[{Basic, "Validate a local file, memoize the result and return the valid file:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				ImageQ[Import[#]] &
			],
			_File
		],
		Example[{Basic, "Returns and memoizes $Failed if the file doesn't pass validation:"},
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				MatchQ[FileFormat[#], "PDF"] &
			],
			$Failed
		],
		Test["Function result is memoized:",
			validateLocalFile[
				FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
				ImageQ[Import[#]] &
			];

			AbsoluteTiming[
				validateLocalFile[
					FileNameJoin[{$TemporaryDirectory, "testfile.png"}],
					ImageQ[Import[#]] &
				]
			],
			{LessP[0.001], _File}
		]
	},
	SymbolSetUp :> {
		DownloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/a9557e8d9b5ce7efacaa523b5e87b17a.png"],
			FileNameJoin[{$TemporaryDirectory, "testfile.png"}]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*pathToCloudFilePacket*)


DefineTests[pathToCloudFilePacket,
	{
		Example[{Basic, "Validate a local file, memoize the result and return the valid file:"},
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]],
			PacketP[]
		],
		Test["The packet generated is a valid upload:",
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]],
			_?ValidUploadQ
		],
		Test["Function result is memoized:",
			pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]];

			AbsoluteTiming[pathToCloudFilePacket[FileNameJoin[{$TemporaryDirectory, "testfile.png"}]]],
			{LessP[0.001], PacketP[]}
		]
	},
	SetUp :> {ClearMemoization[]},
	SymbolSetUp :> {
		DownloadCloudFile[
			EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-blobstore-stage", "shard4/a9557e8d9b5ce7efacaa523b5e87b17a.png"],
			FileNameJoin[{$TemporaryDirectory, "testfile.png"}]
		]
	}
];