(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(* ItemSelector *)


(* ::Subsubsection::Closed:: *)
(* ItemSelector *)

DefineOptions[ItemSelector,
	Options :> {
		{SelectionType -> Single, Alternatives[Single, Multiple, Automatic], "Indicates if one or multiple items can be selected. Automatic indicates that the dialog automatically returns when the first item is clicked."},
		{WindowTitle -> "Item selector", Alternatives[Automatic, _String], "The text to display in the top toolbar of the item selector dialog."},
		{Selection -> {}, Alternatives[_, {}, Null], "Items that are pre-selected when the dialog is first opened."},
		{AllowNull -> False, BooleanP, "Indicates if the user is allowed to select no items."},
		{Sort -> False, BooleanP, "Indicates if the selections are sorted into alphabetical order."},
		{Pagination -> False, Alternatives[GreaterEqualP[10], False], "Indicates the number of items displayed in the scrolling dialog at one time. Too many items degrades performance. All items are accessible by search."}
	}
];

(* Dialog box for selecting items from a list, returning a single item or list depending on the SelectionType option *)
(* Returns $Canceled if dialog is canceled *)
ItemSelector[items : {__}, myOptions : OptionsPattern[ItemSelector]] := Module[
	{safeOps, windowTitleOption, allowNullSelectionQ},

	(* lookup safe options *)
	safeOps = SafeOptions[ItemSelector, ToList[myOptions]];

	(* Extract the options values *)
	{windowTitleOption, allowNullSelectionQ} = Lookup[safeOps, {WindowTitle, AllowNull}];

	With[{allowNullSelectionQ = allowNullSelectionQ, windowTitleOption = windowTitleOption},
		DialogInput[
			Module[{selection},

				Column[{
					ItemSelectorPanel[selection, items, PassOptions[ItemSelector, ItemSelectorPanel, myOptions]],

					(* Ok and cancel buttons. Ok only active when items are selected *)
					Row[{Button["OK", DialogReturn[selection], Enabled -> If[allowNullSelectionQ, True, Dynamic[!MatchQ[selection, Alternatives["", Null, {}]], TrackedSymbols :> {selection}]]], CancelButton[]}, Spacer[5]]
				}]
			],
			Modal -> True, (* Window should hold the kernel *)
			WindowFloating -> True,
			WindowTitle -> windowTitleOption,

			(* Make sure the table can be scrolled and magnified *)
			WindowElements -> {"HorizontalScrollBar", "VerticalScrollBar", "MagnificationPopUp"},

			(* Make sure the dialog window can be minimized, maximized, zoomed and closed *)
			WindowFrameElements -> {"ResizeArea", "CloseBox", "ZoomBox", "MinimizeBox"}
		]
	]
];


(* ::Subsubsection::Closed:: *)
(* ItemSelectorPanel *)

(* In-line interface for choosing items from a list - provide a variable name to set the value of that variable *)
DefineOptions[ItemSelectorPanel,
	Options :> {
		{SelectionType -> Single, Alternatives[Single, Multiple, Automatic], "Indicates if one or multiple items can be selected. Automatic indicates that the enclosing dialog automatically returns when the first item is clicked."},
		{Selection -> {}, Alternatives[_, {}, Null], "Items that are pre-selected when the interface is first opened."},
		{Sort -> False, BooleanP, "Indicates if the selections are sorted into alphabetical order."},
		{Pagination -> False, Alternatives[GreaterEqualP[10], False], "Indicates the number of items displayed in the scrolling dialog at one time. Too many items degrades performance. All items are accessible by search."}
	}
];

SetAttributes[ItemSelectorPanel, HoldFirst];
ItemSelectorPanel[var : _, items : {__}, myOptions : OptionsPattern[ItemSelectorPanel]] := With[{heldVar := var},
	Module[
		{safeOps, selectionTypeOption, selectionOption, sortOption, paginationOption},

		(* lookup safe options *)
		safeOps = SafeOptions[ItemSelectorPanel, ToList[myOptions]];

		(* Extract the options values *)
		{selectionTypeOption, selectionOption, sortOption, paginationOption} = Lookup[safeOps, {SelectionType, Selection, Sort, Pagination}];


		DynamicModule[
			{
				(* Start with a list of all items *)
				allItems = items,

				(* The filtered list of items that is actually displayed, such as when filtering by the search box contents. Start with everything *)
				filteredItems = items,

				(* The items that have been selected. Initial value defaults to empty but can also be specified by options *)
				selection = Which[
					(* If user can only select a single value, ensure the supplied default selection is valid *)
					MatchQ[selectionTypeOption, Single] && MemberQ[items, selectionOption],
					selectionOption,

					(* If a list was provided, take the last item if it's valid *)
					MatchQ[selectionTypeOption, Single] && MatchQ[selectionOption, {__}] && MemberQ[items, Last[selectionOption]],
					Last[selectionOption],

					(* Otherwise default to Null for single select *)
					MatchQ[selectionTypeOption, Single],
					Null,

					(* For Automatic, auto-select doesn't make sense, so default to Null *)
					MatchQ[selectionTypeOption, Automatic],
					Null,

					(* Otherwise if Multiple select, make sure we have a list of valid choices *)
					MatchQ[selectionTypeOption, Multiple],
					UnsortedIntersection[ToList[selectionOption], items]
				],

				(* String currently typed into search box *)
				searchString = "",

				buttonAction,

				(* Store the pagination amount *)
				originalPaginationAmount = paginationOption,
				displayedPagination = paginationOption,

				(* Create a unique ID for the input box so that we can auto-select it on launch *)
				inputBoxID = "ItemSelectorPanel" <> ToString[Unique[]]
			},

			(* Set the initial value of the selection *)
			Set[heldVar, selection];

			(* Function that's run when an item is clicked *)
			buttonAction[item_] := Switch[selectionTypeOption,
				(* If allowing multi-select, append to/remove from the selection list *)
				Multiple,
				(If[MemberQ[selection, item], selection = DeleteCases[selection, item], selection = Append[selection, item]]; Set[heldVar, selection]),

				(* If Automatic, we also close the dialog and return on first click *)
				Automatic,
				(Set[selection, item];Set[heldVar, selection];DialogReturn[heldVar]),

				(* Otherwise if Single select, select/deselect as appropriate *)
				_,
				(If[MatchQ[selection, item], selection = Null, selection = item];Set[heldVar, selection])
			];

			(* Create the interface *)
			Column[{
				(* Search box to filter by name *)
				Row[{
					EventHandler[
						(* DynamicWrapper to auto-select the input field when the dialog is opened *)
						DynamicWrapper[
							InputField[
								(* Each time string is updated, update the filtered list *)
								Dynamic[
									searchString,
									(* Update both the search string and the filter in real time *)
									(
										Set[searchString, #1];
										Set[filteredItems, PickList[allItems, ToString /@ allItems, _?(StringContainsQ[#, searchString, IgnoreCase -> True]&)]]
									) &,
									TrackedSymbols :> {searchString}
								],
								String,
								ContinuousAction -> True,
								FieldHint -> "Search...",
								BoxID -> inputBoxID
							],

							(* Move the cursor into the box when this dynamic is initially displayed *)
							FrontEnd`MoveCursorToInputField[SelectedNotebook[], inputBoxID],

							(* Never run the cursor move dynamic again once displayed *)
							UpdateInterval -> Infinity,
							TrackedSymbols :> {}
						],
						{
							(* Be able to search by hitting enter *)
							"ReturnKeyDown" :> Set[filteredItems, PickList[allItems, ToString /@ allItems, _?(StringContainsQ[#, searchString, IgnoreCase -> True]&)]]
						}
					],

					(* Also have a manual search button *)
					Button["Search", Set[filteredItems, PickList[allItems, ToString /@ allItems, _?(StringContainsQ[ToString[#], searchString, IgnoreCase -> True]&)]]]
				}],

				(* Create a scrolling pane containing the items to display *)
				Framed[
					Pane[
						(* Dynamic to update the list if we filter items in the list or update the selection *)
						Dynamic[

							(* Show the (filtered/paginated) list of items *)
							Module[{sortedItems, paginatingQ, paginatedItems, styledItems},

								(* Sort the items if requested *)
								sortedItems = If[sortOption, Sort[filteredItems], filteredItems];

								(* Determine if we're paginating - if requested and we have enough items *)
								paginatingQ = MatchQ[displayedPagination, GreaterEqualP[0]] && GreaterQ[Length[sortedItems], displayedPagination];

								(* Paginate the items if required *)
								paginatedItems = If[paginatingQ,
									sortedItems[[;; UpTo[displayedPagination]]],
									sortedItems
								];

								(* Style the items *)
								(* For each item, show the name as a clickable button that adds/removes the item from the selection as appropriate *)
								styledItems = Button[

									(* If the item is already selected, highlight them *)
									If[MemberQ[ToList[selection], #],
										Framed[#, Background -> LightBlue, FrameStyle -> None, FrameMargins -> None],

										(* Temporarily highlight unselected items on mouseover *)
										Mouseover[
											Framed[#, Background -> None, FrameStyle -> None, FrameMargins -> None],
											Framed[#, Background -> LightBlue, FrameStyle -> None, FrameMargins -> None]
										]
									],

									(* Add item to list if not already, otherwise remove from list. Action depends on the SelectionType *)
									buttonAction[#],

									Appearance -> None
								] & /@ paginatedItems;

								Column[
									If[paginatingQ,
										(* Append an extend pagination button if paginating *)
										Append[
											styledItems,
											Button[
												"Show more items...",
												Set[displayedPagination, displayedPagination + originalPaginationAmount],
												Appearance -> None,
												Method -> "Preemptive"
											]
										],
										styledItems
									]

								]
							],
							TrackedSymbols :> {filteredItems, selection, displayedPagination}
						],
						{400, 400},
						Scrollbars -> True
					],
					Background -> White
				]
			}]
		]
	]
];


(* ::Subsection::Closed:: *)
(* DynamicTooltip *)

SetAttributes[DynamicTooltip, HoldAll];
DynamicTooltip[
	item_,
	action_
] := With[{evaluatedItem = item, unevaluatedAction := action},
	DynamicModule[{window},
		EventHandler[
			evaluatedItem,
			{
				(* Open the tooltip notebook when the mouse mouse-overs the trigger expression *)
				"MouseEntered" :> (
					(* Ensure the triggering notebook is the selected one - this avoids weird flickering behavior *)
					SetSelectedNotebook[EvaluationNotebook[]];

					(* Generate the tooltip *)
					Set[

						(* Save the window notebook object *)
						window,

						(* Tooltip is created as a separate notebook - this allows it to extend beyond the boundaries of the triggering notebook, unlike a cell based approach *)
						CreateDialog[
							Framed[unevaluatedAction],

							(* External notebook has no features - purely display the notebook contents *)
							WindowFrameElements -> {},
							WindowElements -> {},
							WindowFrame -> "Frameless",

							(* Create the tooltip with the top left corner at the mouse position when triggered *)
							WindowMargins -> {{MousePosition[][[1]], Automatic}, {Automatic, MousePosition[][[2]]}}
						]
					]
				),
				(* Close the tooltip notebook when the mouse no longer mouse-overs the trigger expression *)
				"MouseExited" :> (
					NotebookClose[window];
					SetSelectedNotebook[EvaluationNotebook[]]
				)
			}
		]
	]
];


(* ::Subsection::Closed:: *)
(* DynamicImageImport *)

DynamicImageImport[myCloudFiles : ListableP[_EmeraldCloudFile]] := DynamicModule[
	{listedCloudFileReferences, displayedImages, imageSize},

	DynamicWrapper[

		(* Cache the cloud file references and ensure it's a list *)
		listedCloudFileReferences = ToList[myCloudFiles];

		(* The actual variable displayed at any one time *)
		(* Start with a progress indicator *)
		displayedImages = Column[
			{
				ProgressIndicator[Appearance -> "Necklace"],
				"Queued..."
			},
			Center
		]& /@ listedCloudFileReferences;

		(* Construct the dynamic grid to display *)
		Dynamic[
			Grid[PartitionRemainder[displayedImages, 2]],
			TrackedSymbols :> {displayedImages},
			SynchronousUpdating -> True
		],


		(* Action to perform when dynamic is first displayed *)
		(* Doing it this way ensures the grid displays immediately, but is empty. Then the user can watch as the images download *)
		(* Resolve the image size based on the number of images *)
		imageSize = If[GreaterQ[Length[PartitionRemainder[displayedImages, 2]], 1],
			(* Smaller images if we have multiple rows *)
			Small,
			Medium
		];

		Map[
			Function[{index},
				Module[{importedImage},

					(* Update the displayed message for the selected image to indicate we're downloading *)
					displayedImages[[index]] = Column[
						{
							ProgressIndicator[Appearance -> "Necklace"],
							"Downloading..."
						},
						Center
					];

					(* Import the image. Note that time constrained will crash telescope so only use it as absolute safeguard to save MM kernel *)
					importedImage = TimeConstrained[
						importCloudFileImage[listedCloudFileReferences[[index]], imageSize],
						45, (* ! Read the comment above before touching this *)
						$Failed
					];

					(* Now display the image or a failure message *)
					displayedImages[[index]] = If[!FailureQ[importedImage],
						importedImage,
						"Download timed out"
					]
				]
			],
			Range[Length[displayedImages]]
		],

		(* Just run this dynamic once *)
		UpdateInterval -> Infinity,
		TrackedSymbols :> {},
		SynchronousUpdating -> False
	]
];

(* Helper for importing the images *)
(* Memoized to prevent re-downloading and handles gifs as an animated list *)
importCloudFileImage[cloudFile_, size_] := (importCloudFileImage[cloudFile, size] = With[{image = ImportCloudFile[cloudFile]},
	(* Memoize this function *)
	If[!MemberQ[$Memoization, Core`Private`importCloudFileImage],
		AppendTo[$Memoization, Core`Private`importCloudFileImage]
	];

	Which[
		MatchQ[image, _Image],
		Image[image, ImageSize -> size],

		(* Gif *)
		MatchQ[image, {_Image..}],
		(* ListAnimate will play the GIF on a loop. The AppearanceElements replacement gets rid of the control bar. *)
		ListAnimate[Image[#, ImageSize -> size]& /@ image] /. HoldPattern[AppearanceElements -> _] -> (AppearanceElements -> None),

		True,
		image
	]
]);
