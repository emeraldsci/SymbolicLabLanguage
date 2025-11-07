(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)

(* ::Subsubsection:: *)
(*MakeBoxes for cloud files *)

OnLoad[
	$CloudFileBlobs=True;
	With[{
		(* Cloud file packets that have all the info we need already *)
		singlePacket=KeyValuePattern[{Type -> Object[EmeraldCloudFile], Object -> ObjectP[Object[EmeraldCloudFile]], FileName -> Except[$Failed], FileType -> Except[$Failed], CloudFile -> Except[$Failed]}],
		(* Cloud files that are not already a complete packet *)
		nonPackets=LinkP[Object[EmeraldCloudFile]] | ObjectReferenceP[Object[EmeraldCloudFile]],
		(* Packets that might reference a cloud file in one of the fields *)
		nonCloudFilePackets=Except[PacketP[Object[EmeraldCloudFile]], PacketP[]]},
		(* This overload is for a single packet and does all the formatting that we want for cloud file blobs. No downloading is required. *)
		MakeBoxes[
			cloudFilePacket:singlePacket,
			StandardForm
		]:=With[
			{boxes=Module[{name, type, object, file, watchCloudFileButton, importButton},
				(* Get the file name and type. *)
				object=Lookup[cloudFilePacket, Object];
				name=Lookup[cloudFilePacket, FileName, "Untitled"] /. Null | $Failed -> "Untitled";
				type=ToLowerCase[Lookup[cloudFilePacket, FileType, ""] /. Null | $Failed -> ""];
				file=Lookup[cloudFilePacket, CloudFile];

				(* TODO: currently only supporting MP4*)
				watchCloudFileButton = If[StringEndsQ[type, "mp4"],
					cloudFileButton[Watch, file, type],
					Nothing
				];

				(* import is currently meaningless on videos and Mathematica cannot handle in current version *)
				importButton = If[StringEndsQ[type, "mp4"],
					Nothing,
					cloudFileButton[Import, file, type]
				];

				ToBoxes[
					(* Frame it instead of using the built in grid frame so that we can have rounded edges *)
					Framed[
						Grid[
							{
								{
									(* Image indicating the file type *)
									emeraldCloudFileIcon[ToLowerCase[type]],
									(* Inner grid with the other info *)
									Grid[{
										(* File Name*)
										{Style[name<>If[MatchQ[type, ""], "", "."]<>type, FontSize -> 14, FontFamily -> "Helvetica"], SpanFromLeft},
										(* Link *)
										{linkButton[Link[object]], SpanFromLeft},
										(* Open/Save/Import buttons *)
										{
											watchCloudFileButton,
											cloudFileButton[Open, file, type],
											cloudFileButton[Save, file, type],
											importButton
										}
									}, Alignment -> Left, Spacings -> {0.5, 0.5}]}}, Alignment -> Top
						], FrameStyle -> RGBColor[238 / 255, 238 / 255, 238 / 255], RoundingRadius -> 2, Background -> RGBColor[247 / 255, 247 / 255, 247 / 255], ContentPadding -> False, FrameMargins -> 10
					]
				]
			]
			},
			InterpretationBox[boxes, Lookup[cloudFilePacket, Object], SelectWithContents -> False]
		]/;TrueQ[$CloudFileBlobs];

		(* This is the overload that takes non-packets, downloads them in one call, then passes to the overload that does the formatting *)
		MakeBoxes[
			cloudFileObjects:nonPackets,
			StandardForm
		]:=With[{packets=Quiet[Download[cloudFileObjects, Packet[FileName, FileType, CloudFile]]]},
			If[MatchQ[packets, KeyValuePattern[{Type -> Object[EmeraldCloudFile], Object -> ObjectP[Object[EmeraldCloudFile]], FileName -> Except[$Failed], FileType -> Except[$Failed], CloudFile -> Except[$Failed]}]],
				MakeBoxes[
					packets,
					StandardForm
				],
				Block[{$CloudFileBlobs=False}, MakeBoxes[cloudFileObjects]]
			]
		]/;TrueQ[$CloudFileBlobs];

		(* This is to speed up the display of packets that have cloud files *)
		MakeBoxes[
			packets:nonCloudFilePackets,
			StandardForm
		]:=Block[{$CloudFileBlobs=False},
			Module[{cloudObjects, cloudPackets, findCloudPacket, cloudFilePackets, finalPacket},

				cloudObjects=DeleteDuplicates[Flatten[Download[Cases[#, ObjectP[Object[EmeraldCloudFile]], Infinity], Object]& /@ ToList[packets]]];
				cloudPackets=Download[cloudObjects, Packet[FileName, FileType, CloudFile]];

				(* Make a helper to find the packet for a corresponding cloud object since we don't want to map download *)
				findCloudPacket[object_]:=FirstCase[cloudPackets, KeyValuePattern[Object -> Download[object, Object]], object];

				(* Convert any cloud file objects in the packet to their corresponding packets. MakeBoxes will take care of doing the display, but this will prevent mapping download. *)
				(* ReplaceAll doesn't work on associations like named singles, so do replace to infinity instead *)
				cloudFilePackets=Replace[#, x:LinkP[Object[EmeraldCloudFile]] :> findCloudPacket[x], Infinity]& /@ ToList[packets];

				(* If we are displaying a single packet, get it out of list form *)
				finalPacket=If[MatchQ[packets, _List], cloudFilePackets, cloudFilePackets[[1]]];

				ToBoxes[finalPacket]
			]
		]/;TrueQ[$CloudFileBlobs]
	]
];

OnLoad[
	With[{},
		MakeBoxes[
			cloudFile:EmeraldCloudFile["AmazonS3", bucket_String, key_String, cloudFileId:(_String | None):None],
			StandardForm
		]:=With[
			{boxes=Module[{},

				ToBoxes[
					(* Frame it instead of using the built in grid frame so that we can have rounded edges *)
					Framed[
						Grid[
							{
								{
									(*  Inner grid that contains the EmeraldCloudFile header and help icon*)
									Grid[{
										{
											(* Text "EmeraldCloudFile" *)
											Style["EmeraldCloudFile", FontSize -> 14, FontFamily -> "Consolas", RGBColor[106 / 255, 117 / 255, 128 / 255]],
											(* Question mark button that opens the EmeraldCloudFile guide page *)
											cloudFileButton[Help, cloudFile, ToLowerCase[FileExtension[key]]]
										}
									}, Alignment -> {Left, Center}
									],
									SpanFromLeft},
								(* Image indicating the file type *)
								{emeraldCloudFileIcon[ToLowerCase[FileExtension[key]]],
									(* Inner grid with the file name and buttons *)
									Grid[
										{
											{},
											(* Open/Import/Download buttons. There is a known issue where grid cuts off images, but ImagePad fixes this. *)
											{
												cloudFileButton[Open, cloudFile, ToLowerCase[FileExtension[key]]],
												cloudFileButton[Save, cloudFile, ToLowerCase[FileExtension[key]]],
												cloudFileButton[Import, cloudFile, ToLowerCase[FileExtension[key]]]
											}
										}, Alignment -> {Left, Bottom}, Spacings -> {0.5, 0.5}
									]
								}
							}, Alignment -> {Left, Bottom}, Background -> RGBColor[247 / 255, 247 / 255, 247 / 255]
						], FrameStyle -> RGBColor[238 / 255, 238 / 255, 238 / 255], RoundingRadius -> 2, Background -> RGBColor[247 / 255, 247 / 255, 247 / 255], ContentPadding -> False, FrameMargins -> 10
					]
				]
			]
			},
			InterpretationBox[boxes, cloudFile, SelectWithContents -> False]
		]/;TrueQ[$CloudFileBlobs]
	]
];

(* ::Subsubsection:: *)
(*Cloud File Images*)


(* File type icons *)
emeraldCloudFileIcon[format:"pdf"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_pdf.png"}], "PNG"], ImageSize->{50,50}]
];
emeraldCloudFileIcon[format:"nb" | "m" | "cdf" | "mx"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_mathematica.png"}], "PNG"], ImageSize->{50,50}]
];
emeraldCloudFileIcon[format:"txt" | "trc" | "rtf" | "tsl" | "au3" | "prm"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_text.png"}], "PNG"], ImageSize->{50,50}]
];
emeraldCloudFileIcon[format:"png" | "jpg" | "jpeg" | "gif" | "tiff" | "bmp" | "mgf"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_image.png"}], "PNG"], ImageSize->{50,50}]
];
emeraldCloudFileIcon[format:"xls" | "xlsx" | "csv" | "tsv"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_excel.png"}], "PNG"], ImageSize->{50,50}]
];
emeraldCloudFileIcon[format:"doc" | "docx"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_word.png"}], "PNG"], ImageSize->{50,50}]
];

emeraldCloudFileIcon[format:"mp4"]:=Set[
	emeraldCloudFileIcon[format],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_video.png"}], "PNG"], ImageSize->{50,50}]
];

(* All other file types are generic *)
emeraldCloudFileIcon[_]:=Set[
	emeraldCloudFileIcon[_],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "File_Generic.png"}], "PNG"], ImageSize->{50,50}]
];

(* info icon *)
emeraldCloudFileActionIcon[Help]:=Set[
	emeraldCloudFileActionIcon[Help],
	Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "ic_help_normal.png"}], "PNG"]
];
emeraldCloudFileActionIcon[Help, Hover]:=Set[
	emeraldCloudFileActionIcon[Help, Hover],
	Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "ic_help_hover.png"}], "PNG"]
];

(* The action button icons *)
emeraldCloudFileActionIcon[Open]:=Set[
	emeraldCloudFileActionIcon[Open],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Open-Normal.png"}], "PNG"], ImageSize->65]
];
emeraldCloudFileActionIcon[Open, Hover]:=Set[
	emeraldCloudFileActionIcon[Open, Hover],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Open-Hover.png"}], "PNG"], ImageSize->65]
];
emeraldCloudFileActionIcon[Save]:=Set[
	emeraldCloudFileActionIcon[Save],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Save-Normal.png"}], "PNG"], ImageSize->60]
];
emeraldCloudFileActionIcon[Save, Hover]:=Set[
	emeraldCloudFileActionIcon[Save, Hover],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Save-Hover.png"}], "PNG"], ImageSize->60]
];
emeraldCloudFileActionIcon[Download]:=Set[
	emeraldCloudFileActionIcon[Download],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Download-Normal.png"}], "PNG"], ImageSize->85]
];
emeraldCloudFileActionIcon[Download, Hover]:=Set[
	emeraldCloudFileActionIcon[Download, Hover],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Download-Hover.png"}], "PNG"], ImageSize->85]
];
emeraldCloudFileActionIcon[Import]:=Set[
	emeraldCloudFileActionIcon[Import],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Import-Normal.png"}], "PNG"], ImageSize->65]
];
emeraldCloudFileActionIcon[Import, Hover]:=Set[
	emeraldCloudFileActionIcon[Import, Hover],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "Import-Hover.png"}], "PNG"], ImageSize->65]
];

emeraldCloudFileActionIcon[Watch]:=Set[
	emeraldCloudFileActionIcon[Watch],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "WatchVideo-Normal.png"}], "PNG"], ImageSize->96]
];
emeraldCloudFileActionIcon[Watch, Hover]:=Set[
	emeraldCloudFileActionIcon[Watch, Hover],
	Image[Import[FileNameJoin[{PackageDirectory["Plot`"], "resources", "WatchVideo-Hover.png"}], "PNG"], ImageSize->96]
];


(* ::Subsubsection::Closed:: *)
(*Summary Blob*)


(* ObjectP isn't loaded by the time this function loads, so not pattern matching cloudFile*)
cloudFileButton[action:Open | Import | Save | Help | Watch, cloudFile:EmeraldFileP, type_String]:=With[{
	onClick=Switch[action,
		Open, Inactivate[Constellation`Private`openCloudFile[cloudFile]],
		Save, Inactivate[If[MatchQ[$ECLApplication, Mathematica],
			(* If we are in mathematica, bring up a dialog to get the file path from the user, then save the file to that path *)
			With[{path=SystemDialogInput["FileSave", FileNameJoin[{$UserDocumentsDirectory, type}]]},
				Constellation`Private`downloadCloudFile[cloudFile, path]
			],
			(* Otherwise, assume we are in one of the apps, and call postJSON.
				 expr needs to be the key.
				 Must have the protocol (in this case 'saveAs') as the first thing in the value. *)
			AppHelpers`Private`postJSON[{"expr" -> "saveAs:"<>ToString[cloudFile]}]
		]],
		Import, Inactivate[Print[Constellation`Private`importCloudFile[cloudFile]]],
		Help, Inactivate[Documentation`HelpLookup["paclet:Docs/guide/EmeraldCloudFiles"]],
		Watch, Inactivate[launchCloudFileVideoHTML[cloudFile]]
	]},

	Mouseover @@ {
		Button[Item[emeraldCloudFileActionIcon[action], ItemSize -> Scaled[0.015]], Activate[onClick], Appearance -> "Frameless", Method -> "Queued"],
		Button[Item[emeraldCloudFileActionIcon[action, Hover], ItemSize -> Scaled[0.015]], Activate[onClick], Appearance -> "Frameless", Method -> "Queued"]
	}
];

(* ::Subsection::Closed:: *)

launchCloudFileVideoHTML[cloudFile:EmeraldFileP] := Module[{html,bucket,url, filename},
	filename = generateCloudFileVideoHTML[cloudFile];
	SafeOpen[filename];
];

launchCloudFileVideoHTML[cloudFile: EmeraldFileP, startTimeInSeconds_Integer, endTimeInSeconds:Alternatives[Null, _Integer], playbackSpeed:GreaterP[0]:1] := Module[{html,bucket,url, filename},
	filename = generateCloudFileVideoHTML[cloudFile, startTimeInSeconds, endTimeInSeconds, playbackSpeed];
	SafeOpen[filename];
];

getCloudFrontURL::Error = "`1`";

(* Authors definition for ConstellationViewers`Private`getCloudFrontURL *)
Authors[ConstellationViewers`Private`getCloudFrontURL]:={"xu.yi"};

getCloudFrontURL[cloudFile:EmeraldFileP] := Module[{resp, url},
	resp = ConstellationRequest[<|"Path" -> "blobsign/sign_cloudfront", "Method" -> "POST",
		"Body" -> <|"bucket" -> cloudFile[[3]]|>|>];
	If[MatchQ[resp, _HTTPError],
		Message[getCloudFrontURL::Error, Last[resp]];
		Return[$Failed];
	];
	url = Lookup[resp, "Url", $Failed];
	If[MatchQ[url, $Failed],
		Message[getCloudFrontURL::Error, "Could not generate URL"];
		Return[$Failed];
	];
	url
];

generateCloudFileVideoHTML[cloudFile:EmeraldFileP, startTimeInSeconds_Integer: 0, endTimeInSeconds:Alternatives[Null, _Integer]: Null, playbackSpeed:GreaterP[0]: 1] := Module[{html,bucket,url, filename},
	url = getCloudFrontURL[cloudFile]<> "#t="<>ToString[startTimeInSeconds] <> If[NullQ[endTimeInSeconds], "", "," <> ToString[endTimeInSeconds]];
	If[MatchQ[url, $Failed],
		Return[$Failed]
	];
	html="<!DOCTYPE html>
			<html>
				<body>
				    <video id=\"myVideo\" width=\"640\" height=\"480\" autoplay=\"autoplay\" controls=\"controls\">
  				    <source src=\""<>ToString@url<>"\" type=\"video/mp4\">
							Your browser does not support the video tag.
						</video>
						<script>
							let vid = document.getElementById(\"myVideo\");
							vid.playbackRate = " <> ToString[playbackSpeed] <> ";
						</script>
			    </body>
			</html>";
	filename=FileNameJoin[{$TemporaryDirectory,CreateUUID[]}]<>".html";
	Export[filename,html,"String"];
	filename
];
