(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*UploadProduct*)


(* ::Subsubsection:: *)
(*Helper Parser Functions*)

(* Define this global variable to determine whether we memoize result from these parsers. Could be useful to set to False in testing/debugging *)
$MemoizeProductParseResult = True;

(* Define this feature flag to switch between python and MM parser *)
(* TODO turn on this feature flag once new pyECL is released *)
$UsePyeclProductParser = True;

(* Define this feature flag to switch between regular and ai-aided parsing for python *)
(* Options are True, False First and Last *)
(* First will try AI parser, if it fails then try regular one; Last functions oppositely *)
$UseAIProductParser = Last;

(* ::Subsubsection::Closed:: *)
(*ThermoFisher to Product Association (parseThermoProductURL)*)
(* small helper *)
thermoProductIDFromURL[url_String] := First[StringCases[url, "/catalog/product/"~~x:(DigitCharacter | WordCharacter | "-" | ".").. :> x]];


(* Given a thermofisher URL, return as association of parsed information from the URL. *)
parseThermoProductURL[url_String]:=Module[
	{
		result, thermoProductID, thermoFisherAPI, productInformationJSON, productInformation, thermoName,
		productSize, productPrice, thermoWebsite, productImage, isCase, productInformation2, productAmountString2,
		productAmount2, catalogDescription, sampleType, cleanedURL
	},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	(* Parse out the product ID from the URL. *)
	thermoProductID=thermoProductIDFromURL[url];

	(* Make a request to the ThermoFisher API for the information about this product. *)
	(* Error: This is reverse engineered and ThermoFisher may change how this works! *)
	thermoFisherAPI="https://www.thermofisher.com/api/store/sku/price/";

	productInformationJSON=Quiet[
		HTTPRequestJSON[{<|
			"URL" -> thermoFisherAPI,
			"Method" -> "POST",
			"Body" -> {"items" -> {{"catalogNumber" -> thermoProductID, "quantity" -> 1}}}
		|>}]
	];

	productInformation = Quiet[Check[
		First[First[productInformationJSON]["products"]],
		$Failed
	]];

	If[MatchQ[productInformation, $Failed],
		Return[$Failed]
	];

	(* Do a GET request to get the content of the thermo URL. *)
	thermoWebsite=HTTPRequestJSON[{<|
		"URL" -> url,
		"Method" -> "GET"
	|>}];

	(* Attempt to pull out the name of the product from the association. *)
	thermoName=Quiet[Check[
		Module[{rawStringName},
			(* Pull out the string within the <title> ... </title> *)
			rawStringName=First[First[StringCases[thermoWebsite, Shortest["<title>"~~x__~~"</title>"] :> x]]];

			(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
			cleanUpHTMLString[StringReplace[rawStringName, {"&#"~~(DigitCharacter | WordCharacter)..~~";" :> "", "&"~~(DigitCharacter | WordCharacter)..~~";" :> ""}]]
		],
		Null
	]];

	If[!MatchQ[thermoName, _String|Null],
		Return[$Failed];
	];

	(* Attempt to pull out the size of the product from the association. *)
	productSize=Quiet[Check[
		Module[{amounts},
			amounts=StringCases[thermoWebsite, "\"Quantity\",\"value\":\""~~stringAmount:RegularExpression["[A-Za-z0-9, ]+"]~~"\"" :> stringAmount];

			(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
			(* need to handle the Null case if it can't find anything *)
			Quiet[Check[
				FirstCase[StringToQuantity[#, Server -> False]& /@ Flatten[amounts], VolumeP | MassP, Null],
				If[StringMatchQ[First[Flatten[amounts]], Repeated[NumberString]~~" "~~Repeated[WordCharacter]],
					ToExpression[StringReplace[First[Flatten[amounts]], x:Repeated[NumberString]~~" "~~Repeated[WordCharacter] :> x]],
					Null
				]
			]]
		],
		Null
	]];

	(* Attempt to pull out the price of the product from the association. *)
	productPrice= Quiet[Check[
		Module[{finalPriceFloat, currency},
			finalPriceFloat = productInformation["unFormattedPrice"]["finalPrice"];
			currency = productInformation["currency"];

			(* Convert all HTML entities into empty strings (Mathematica can't handle these) *)
			If[MatchQ[finalPriceFloat, _?NumericQ],
				Quantity[finalPriceFloat, currency],
				Null
			]
		],
		Null
	]];

	If[!MatchQ[productPrice, UnitsP[USD]],
		Return[$Failed];
	];

	(* If the product uom is "EA" (each), then it's a single item, otherwise it's a case of potentially multiple items *)
	isCase = If[MatchQ[productInformation["uom"], "EA"],
		False,
		True
	];

	(* Extract product information from an alternative source, and cross-check *)
	productInformation2 = Quiet[Check[
		ImportJSONToAssociation[First[StringCases[First[thermoWebsite], "<script type=\"application/ld+json\"> "~~x:Shortest[___]~~"</script>" :> x]]],
		Null
	]];

	productAmountString2 = If[MatchQ[productInformation2, _Association],
		Lookup[productInformation2, "size", Null],
		Null
	];

	(* extract amount from the second info block *)
	productAmount2 = Which[
		(* If we can't find the size in the info block, set to Null *)
		NullQ[productAmountString2],
			Null,
		(* If we see "xx of n" (e.g., box of 10, case of 200), extract the number *)
		StringMatchQ[productAmountString2, ___~~Repeated[NumberString]],
			ToExpression[StringReplace[productAmountString2,  ___~~"of "~~x:Repeated[NumberString]:>x]],
		(* If we see number + unit (e.g., 50 g, 100 ml), extract the number and unit *)
		StringMatchQ[productAmountString2, Repeated[NumberString]~~" "~~__],
			Quiet[Check[
				StringToQuantity[StringReplace[productAmountString2, {"&micro;" -> "micro ", "&mu;" -> "micro "}]], (* Fix the format of 'micro' notation from thermo *)
				Null
			]],
		True,
			Null
	];

	catalogDescription = Quiet[Check[
		cleanUpHTMLString[First[StringCases[First[thermoWebsite], "<div class=\"short-description\">"~~x:Shortest[___]~~"</div>" :> x]]],
		Null
	]];

	(* Attempt to pull out the description of the product from the association. *)
	productImage=Quiet[Check[
		Module[{rawStringDescriptionWithMetaTag},
			(* Get the file name of the image out of the website *)
			rawStringDescriptionWithMetaTag=First[First[StringCases[thermoWebsite, "/TFS-Assets/LSG/product-images/"~~x:Shortest[Repeated[(DigitCharacter | WordCharacter | "-" | "_" | "." | " ")]]~~"\" as=" :> x]]];

			(* Form the full image *)
			"https://www.thermofisher.com/TFS-Assets/LSG/product-images/"<>rawStringDescriptionWithMetaTag
		],
		Null
	]];

	If[!MatchQ[productImage, _String|Null],
		Return[$Failed];
	];

	sampleType = resolveSampleTypesFromString[thermoName, catalogDescription];

	cleanedURL = StringReplace[url, x:___~~"?"~~___ :> x];

	(* Return an association of our information. *)
	result = <|
		Name -> thermoName,
		Supplier -> Object[Company, Supplier, "Thermo Fisher Scientific"],
		CatalogNumber -> thermoProductID,
		ProductURL -> cleanedURL,
		Amount -> If[NullQ[productSize] && MatchQ[productAmount2, _Quantity],
			productAmount2,
			productSize
		],
		Price -> productPrice,
		ImageFile -> productImage,
		Packaging -> If[isCase,
			Case,
			Single
		],
		NumberOfItems -> If[isCase,
			productAmount2,
			1
		],
		CatalogDescription -> catalogDescription,
		SampleType -> sampleType
	|>;

	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed] && TrueQ[$MemoizeProductParseResult],
		parseThermoProductURL[url]=result;
	];

	(* Return our result. *)
	result
];


(* ::Subsubsection::Closed:: *)
(*Sigma to Association (parseSigmaProductURL)*)


parseSigmaProductURL[url_String]:=Module[
	{
		result, sigmaWebsite, websiteJSON, sigmaName, productID, skus, productVendor, pricingJSON, rawPackageSize,
		rawPrice, caseQ, samplesPerCase, stringIndividualContainerSize, rawIndividualContainerSize, individualContainerSize,
		price, rawDescription, cleanedUpDescription, sampleType, imageURL, completeImageURL, sigmaNameRaw, rawIndividualContainerSizeCorrected,
		productInfo
	},
	
	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	(* Download the HTML for the website -- this is not true HTML because Sigma uses AJAX to execute JavaScript for all the details. Sizes, prices, etc are dynamically pulled from the API with a JavaScript call, which MM won't execute. So we basically do not get the data we want from this. However, it gives us the information we need to make a call to the API for pricing info *)
	sigmaWebsite = Quiet[
		HTTPRequestJSON[
			<|
				"URL" -> url,
				"Method" -> "GET",
				(* this is a header that we found can work to get a response for now, but just so people keep an eye sigma may block us at any time b/c we run unit tests and ping their website too often *)
				"Headers" -> <|
					"accept" -> "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
					"user-agent" -> "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
				|>
			|>
		]
	];

	(* Import the website details as a JSON -- we are grabbing the jsonLD "key" from the website, which has the details we need, and converting it into an association. The default condition for First will return an empty association, so if we cannot get what we want, we will get a bunch of Nulls below. I am also adding a string replacement for links, which contain "&quot;" and break JSON conversion. There is some weird escaping happening there so just removing "&quot;" does not work, and since we aren't going to parse the links, we can just clear them wholesale here *)
	websiteJSON = Quiet[
		ImportJSONToAssociation[
			First@StringCases[
				sigmaWebsite,
				Shortest["<script id=\"__NEXT_DATA__\" type=\"application/json\">" ~~ json : ("{" ~~ __ ~~ "}") ~~ "</script>"] /; StringCount[json, "{"] == StringCount[json, "}"] :> json
			]
		]
	];

	If[!MatchQ[websiteJSON, _Association],
		Return[$Failed, Module]
	];

	(* extract the product information *)
	productInfo = Lookup[Lookup[Lookup[Lookup[websiteJSON, "props"], "pageProps"], "data"], "getProductDetail"];

	(* Parse the name of this chemical and its ID from the page *)
	sigmaNameRaw=StringRiffle[Lookup[productInfo, {"name", "description"}], " "];

	If[!MatchQ[sigmaNameRaw, _String],
		Return[$Failed];
	];

	(* Remove any formatting from HTML, and also remove non-ASCII characters *)
	sigmaName = cleanUpHTMLString[sigmaNameRaw];

	productID=Lookup[productInfo, "productNumber"];

	If[!MatchQ[productID, _String],
		Return[$Failed];
	];

	skus=Lookup[productInfo, "materialIds"];

	(* Get the vendor from the URL *)
	productVendor=Lookup[Lookup[productInfo, "brand"], "key"];

	(* Construct a HTTP Request to get pricing information -- the post request below is a GraphQL query for their database and returns the price and sizes of available SKUs *)
	(* CAUTION: This is reverse engineered so Sigma-Aldrich may change their APIs at any point *)
	pricingJSON=HTTPRequestJSON[
		<|
			"URL"->"https://www.sigmaaldrich.com/api?operation=PricingAndAvailability",
			"Method"->"POST",
			"Headers"-><|
				"accept"->"*/*",
				"user-agent"->"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36",
				"x-gql-operation-name"->"PricingAndAvailability",
				"x-gql-access-token"->"ea816e21-7d19-11ef-90f5-8321289a8c21",
				"x-gql-country"->"US"
			|>,
			"Body"-><|
				"operationName"->"PricingAndAvailability",
				"query"->"query PricingAndAvailability($productNumber:String!,$brand:String,$quantity:Int!,$materialIds:[String!]) {
							getPricingForProduct(input:{productNumber:$productNumber,brand:$brand,quantity:$quantity,materialIds:$materialIds}) {
								materialPricing {
									packageSize
									price
								}
							}
						}",
				"variables"-><|
					"brand"->productVendor,
					"materialIds"->skus,
					"productNumber"->productID,
					"quantity"->1
				|>
			|>
		|>
	];

	(* Get the raw package size and the price from the api call *)
	{rawPackageSize,rawPrice}=First[Lookup[Lookup[Lookup[Lookup[pricingJSON,"data"],"getPricingForProduct"],"materialPricing"],{"packageSize","price"}]];

	(* Does this contain an X? If so, it means CaseQuantityXIndividualSize *)
	{caseQ,samplesPerCase,stringIndividualContainerSize}=If[
		StringContainsQ[rawPackageSize,"X"],
		Module[{splitString},

			(* This is a case. Split by X *)
			splitString=StringSplit[rawPackageSize,"X"];

			(* Return the parsed values *)
			{True,ToExpression[splitString[[1]]],splitString[[2]]}
		],

		(* This is not a case. No splitting is needed. *)
		{False,Null,rawPackageSize}
	];

	rawIndividualContainerSize= Quiet[Check[
		StringToQuantity[ToLowerCase[stringIndividualContainerSize]],
		If[MatchQ[stringIndividualContainerSize, _String] && StringMatchQ[stringIndividualContainerSize, Repeated[DigitCharacter]~~" "~~___],
			ToExpression[StringReplace[stringIndividualContainerSize, x:Repeated[DigitCharacter]~~" "~~___ :> x]],
			Null
		]
	]];

	(* Note that we may often misinterpret 1 pak/case/kit/... as 1 count, which is not correct. To avoid that, if our size is 1 Unit, set that to Null instead *)
	rawIndividualContainerSizeCorrected = If[MatchQ[rawIndividualContainerSize, 1],
		Null,
		rawIndividualContainerSize
	];

	(* If our container size came out with weird units, convert to Unit -- this happens because Sigma sells certain items in units that Quantity understands but the Amount field won't accept. For example, pH strips are sold as "100 strips", which will become a quantity in MM but can't be uploaded to the Amount field, so we need to make it "100 Units" *)
	individualContainerSize=If[MatchQ[rawIndividualContainerSizeCorrected,UnitsP[1 Liter]|UnitsP[1 Gram]|UnitsP[1 Unit]],
		rawIndividualContainerSizeCorrected,
		Null
	];

	(* Convert price to dollars *)
	price=Check[ToExpression[rawPrice]*USD, Null];

	(* Find product description *)
	rawDescription = Quiet[Check[
		StringJoin@@Lookup[First[Lookup[productInfo, "descriptions"]], "values"],
		Null
	]];

	cleanedUpDescription = If[MatchQ[rawDescription, _String],
		cleanUpHTMLString[rawDescription],
		Null
	];

	sampleType = resolveSampleTypesFromString[sigmaName, cleanedUpDescription];

	imageURL = Quiet[Check[
		Lookup[First[Lookup[productInfo, "images"]], "smallUrl"],
		Null
	]];
	completeImageURL = If[MatchQ[imageURL, _String],
		StringJoin["https://www.sigmaaldrich.com", imageURL],
		Null
	];

	(* Return an association with the information that we parsed out. *)
	result = <|
		Name->sigmaName,
		Supplier->Object[Company,Supplier,"Sigma Aldrich"],
		CatalogNumber->productID,
		ProductURL->url,
		(* If this item is a case, return Case, if not, return Single. *)
		Packaging->If[caseQ,
			Case,
			Single
		],
		(* If this item is a case, return the number of samples in the case. If not, there is only 1 sample per item. *)
		NumberOfItems->If[caseQ,
			samplesPerCase,
			1
		],
		Amount->individualContainerSize,
		Price->price,
		CatalogDescription -> cleanedUpDescription,
		SampleType -> sampleType,
		(* MM seem to have problem importing image from Sigma. Setting this to Null for now *)
		ImageFile -> Null
	|>;
	
	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or lock us out if we're making too many requests *)
	If[!SameQ[result, $Failed] && TrueQ[$MemoizeProductParseResult],
		parseSigmaProductURL[url] = result;
	];
	
	(* Return our result *)
	result
];


(* ::Subsubsection::Closed:: *)
(*FisherSci to Association (parseFisherProductURL)*)


parseFisherProductURL[url_String]:=Module[
	{
		result, body, name, productID, amount, numberOfItems, isCase, price, catalogDescription, displayUnitString,
		amountFromQuantity, amountFromUnitString, sampleType, imageFile, cleanedURL
	},

	(* Wrap our computation with Quiet[] and Check[] because sometimes contacting the web server can result in an error. *)
	(* Download the HTML for the website. *)
	body = Quiet[Check[
		URLRead[HTTPRequest[url, <|Method -> "GET"|>]]["Body"],
		$Failed
	]];

	If[MatchQ[body, $Failed],
		Return[$Failed]
	];

	(* Scrape information from the website. *)
	name=Quiet[Check[
		StringTrim[StringReplace[StringCases[body, "<title>"~~x:Except["\""]..~~"</title>" :> x][[1]], "\n" -> ""]],
		Null
	]];

	(* The following information in under the <scripts> section in a JS array. Since we can't import the JS to JSON.stringify it, just regex it out. *)
	productID=Quiet[Check[
		StringCases[body, "\"partNumber\":\""~~x:Except["\""]..~~"\"" :> x][[1]],
		Null
	]];

	If[!MatchQ[productID, _String|Null],
		Return[$Failed];
	];

	(* Try to read the Amount. If this fails, we will use other method *)
	amountFromQuantity = Quiet[Check[
		Quantity[StringCases[body, "\"Quantity\":{\"value\":\""~~x:Except["\""]..~~"\"" :> x][[1]]],
		Null
	]];

	{numberOfItems, isCase, price, displayUnitString}=Quiet[Check[
		(* If we got the product ID, send a request to the fisher endpoint for pricing information. *)
		If[MatchQ[productID, _String],
			Module[{pricingAssociation, cleanedProductID},
				(* CAUTION: This is reverse engineered so FisherSci may change their APIs at any point. *)
				pricingAssociation=ImportString[URLRead[HTTPRequest["https://www.fishersci.com/shop/products/service/pricing?partNumber="<>productID<>"&callerId=products-ui-single-page", <|Method -> "POST"|>]]["Body"], "RawJSON"];
				cleanedProductID = StringDelete[productID, "-"];
				{
					ToExpression[pricingAssociation["priceAndAvailability"][cleanedProductID][[1]]["quantity"]],
					!MatchQ[pricingAssociation["priceAndAvailability"][cleanedProductID][[1]]["displayUnitString"], "Each"],
					Quantity[pricingAssociation["priceAndAvailability"][cleanedProductID][[1]]["price"]],
					pricingAssociation["priceAndAvailability"][cleanedProductID][[1]]["displayUnitString"]
				}
			],
			{Null, False, Null, Null}
		],
		{Null, False, Null, Null}
	]];

	(* Attempt to parse Catalog Description *)
	catalogDescription = Quiet[Check[
		(* First see if there's any <p id=\"unauth_3p_item_desc_text\"> in the html *)
		cleanUpHTMLString[First[StringCases[body, "<p id=\"unauth_3p_item_desc_text\">"~~x:Repeated[Except["\n"]]~~"</p>" :> x]]],
		(* If not, then attempt to parse from the Description Tab *)
		Quiet[Check[
			cleanUpHTMLString[StringRiffle[
				StringCases[First[StringCases[body, "<!-- Description Tab  starts -->"~~___~~"<!-- Description Tab ends-->"]], "<p"~~Alternatives[">", " id="~~Shortest[___]~~">"]~~x:Shortest[___]~~"</p>":>x ]
			]],
			Null
		]]
	]];

	(* Resolve Amount *)
	amount = Which[
		(* If we have already figured out the Amount from html body, use that *)
		!MatchQ[amountFromQuantity, Null],
			amountFromQuantity,
		(* Otherwise turn to the 'displayUnitString' *)
		(* If displayUnitString is Null, set Amount to Null *)
		NullQ[displayUnitString],
			Null,
		(* If there's no digit character from displayUnitString, set amount to Null *)
		!StringContainsQ[displayUnitString, DigitCharacter],
			Null,
		(* Finally, try to interpret the displayed unit *)
		True,
		(* Extract the quantity part of displayUnitString *)
			amountFromUnitString = First[StringCases[displayUnitString, Repeated[Alternatives[DigitCharacter, "."]]~~___]];
			Quiet[Check[
				(* Call StringToQuantity to try interpreting the quantity *)
				StringToQuantity[amountFromUnitString],
				(* If failed, don't give up yet. It could be that there's actually no unit, so the string is a number, not quantity *)
				Quiet[Check[
					ToExpression[First[StringCases[amountFromUnitString, Repeated[Alternatives[DigitCharacter, "."]]]]],
					Null
				]]
			]]
	];

	(* Try to parse SampleType *)
	sampleType = resolveSampleTypesFromString[name, catalogDescription];

	imageFile = Quiet[Check[
		First[StringCases[body, "imagesrcset=\""~~x:Shortest[__]~~"\" " :> x]],
		Null
	]];

	cleanedURL = StringReplace[url, x:___~~"#?"~~___ :> x];

	(* Return an association with the information that we parsed out. *)
	result = <|
		Name -> name,
		Supplier -> Object[Company, Supplier, "Fisher Scientific"],
		CatalogNumber -> productID,
		ProductURL -> cleanedURL,
		(* If this item is a case, return Case, if not, return Single. *)
		Packaging -> If[isCase,
			Case,
			Single
		],
		(* If this item is a case, return the number of samples in the case. If not, there is only 1 sample per item. *)
		NumberOfItems -> If[isCase,
			numberOfItems,
			1
		],
		Amount -> amount,
		Price -> price,
		CatalogDescription -> catalogDescription,
		SampleType -> sampleType,
		ImageFile -> imageFile
	|>;


	(* Only memoize if the result wasn't Null. This is because the Fisher server can sometimes fail or *)
	(* lock us out if we're making too many requests. *)
	If[!SameQ[result, $Failed] && TrueQ[$MemoizeProductParseResult],
		parseFisherProductURL[url]=result;
	];

	(* Return our result. *)
	result
];

(* This helper below removes formatting from HTML and also removes non-ASCII characters *)
cleanUpHTMLString[myString_String] := StringDelete[
	StringDelete[myString, Alternatives["<"~~Shortest[___]~~">", "&"~~Shortest[__]~~";"]],
	Except[Alternatives @@ CharacterRange[0, 128]]
];

cleanUpHTMLString[_] := Null;

(* ::Subsubsection::Closed:: *)
(*new parser using pyECL*)

Authors[parseProductURL] := {"hanming.yang"};

parseProductURL[url:(Null | _String)] := Module[
	{
		pyECLReturn, supplierInput, cleanedName, cleanedDescription, cleanedAssoc, result,
		cleanedPrice, cleanedAmount, cleanedNumberOfItems, firstAttemptResults, correctedPrice,
		timeLimit
	},

	supplierInput = Switch[url,
		FisherScientificURLP,
			"fisher",
		ThermoFisherURLP,
			"thermo",
		MilliporeSigmaURLP,
			"sigma",
		_,
			"other"
	];

	(* If we don't allow AI-parser and the URL does not belong to any of the 3 suppliers, return $Failed early *)
	If[MatchQ[supplierInput, "other"] && MatchQ[$UseAIProductParser, False],
		Return[$Failed]
	];

	(* If URL is Null, return $Failed now *)
	If[NullQ[url],
		Return[$Failed]
	];

	(* ping the endpoint for parsing. Impose a 30 second time constraint just in case this is taking forever *)
	pyECLReturn = TimeConstrained[
		Switch[{$UseAIProductParser, supplierInput},
			(* If the supplier is not one of the 3 vendors with parser defined, we'll have to only use ai-based parser *)
			{_, "other"},
				Quiet[
					PyECLRequest[
						"/ccd/ai/extract-product",
						<|"url" -> url|>,
						Retries -> 3
					]
				],
			(* All cases below we should have supplierInput != "other" *)
			(* $UseAIProductParser == True: Use ai parser only *)
			{True, _},
				Quiet[
					PyECLRequest[
						"/ccd/ai/extract-product",
						<|"url" -> url|>,
						Retries -> 3
					]
				],

			(* $UseAIProductParser == Last: Try regular parser first *)
			{Last, _},
				firstAttemptResults = TimeConstrained[
					Quiet[
						PyECLRequest[
							"/ccd/extract-product",
							<|"url" -> url, "supplier" -> supplierInput|>,
							Retries -> 3
						]
					],
					40
				];
				If[MatchQ[firstAttemptResults, _Association],
					firstAttemptResults,
					Quiet[
						PyECLRequest[
							"/ccd/ai/extract-product",
							<|"url" -> url|>,
							Retries -> 3
						]
					]
				],

			(* $UseAIProductParser == First: Try ai parser first *)
			{First, _},
				firstAttemptResults = TimeConstrained[
					Quiet[
						PyECLRequest[
							"/ccd/ai/extract-product",
							<|"url" -> url|>,
							Retries -> 3
						]
					],
					40
				];
				If[MatchQ[firstAttemptResults, _Association],
					firstAttemptResults,
					Quiet[
						PyECLRequest[
							"/ccd/extract-product",
							<|"url" -> url, "supplier" -> supplierInput|>,
							Retries -> 3
						]
					]
				],

			(* Any other cases use regular parser *)
			{_, _},
				Quiet[
					PyECLRequest[
						"/ccd/extract-product",
						<|"url" -> url, "supplier" -> supplierInput|>,
						Retries -> 3
					]
				]
		],
		80
	];

	If[!MatchQ[pyECLReturn, _Association],
		Return[$Failed]
	];

	cleanedName = cleanUpHTMLString[Lookup[pyECLReturn, "title"]];

	cleanedDescription = cleanUpHTMLString[Lookup[pyECLReturn, "description"]];

	cleanedPrice = Quiet[Check[
		ToExpression[Lookup[pyECLReturn, "price"]],
		Null
	]];

	(* Sometimes, the price returns 0. This is especially common for ai parser, presumably because the price is not stored in html *)
	(* In that case, make a second attempt using pricing API from suppliers. If that's not available, at least change the price to Null instead of 0, so we make sure to ask user/developer to correct it *)
	correctedPrice = If[TrueQ[cleanedPrice == 0] && StringQ[Lookup[pyECLReturn, "catalog_number"]],
		findProductPriceAgain[Lookup[pyECLReturn, "catalog_number"], supplierInput],
		cleanedPrice
	];

	cleanedAmount = Quiet[Check[
		(* Call StringToQuantity to try interpreting the quantity *)
		StringToQuantity[Lookup[pyECLReturn, "unit"]],
		(* If failed, don't give up yet. It could be that there's actually no unit, so the string is a number, not quantity *)
		Quiet[Check[
			ToExpression[First[StringCases[Lookup[pyECLReturn, "unit"], Repeated[Alternatives[DigitCharacter, "."]]]]],
			Null
		]]
	]];

	cleanedNumberOfItems = Quiet[Check[
		ToExpression[First[StringCases[Lookup[pyECLReturn, "quantity"], Repeated[DigitCharacter]]]],
		Null
	]];

	cleanedAssoc = Join[
		pyECLReturn,
		<|
			"title" -> cleanedName,
			"description" -> cleanedDescription,
			ProductURL -> url,
			Supplier -> Switch[supplierInput,
				"fisher", Object[Company, Supplier, "Fisher Scientific"],
				"thermo", Object[Company, Supplier, "Thermo Fisher Scientific"],
				"sigma", Object[Company, Supplier, "Sigma Aldrich"],
				_, Null
			],
			"price" -> If[MatchQ[correctedPrice, _?NumberQ],
				correctedPrice * 1 USD,
				Null
			],
			"unit" -> If[MatchQ[cleanedAmount, (_Integer | MassP | VolumeP)],
				cleanedAmount,
				Null
			],
			"quantity" -> If[MatchQ[cleanedNumberOfItems, _Integer],
				cleanedNumberOfItems,
				Null
			],
			(* TODO for now do not export image because image option does not support url or local file path *)
			(* once current release is merged, we will be able to get the improved framework function and should be able to take care of that *)
			"image" -> Null
		|>
	];

	result = KeyReplace[
		cleanedAssoc,
		{
			"title" -> Name,
			"unit" -> Amount,
			"price" -> Price,
			"quantity" -> NumberOfItems,
			"description" -> CatalogDescription,
			"catalog_number" -> CatalogNumber,
			"image" -> ImageFile
		}
	];

	(* Only memoize if the result wasn't Null. This is because the ThermoFisher server can sometimes fail or lock us out if we're making too many requests *)
	If[!SameQ[pyECLReturn, $Failed] && TrueQ[$MemoizeProductParseResult] && !MemberQ[$Memoization, ExternalUpload`Private`parseProductURL],
		AppendTo[$Memoization, ExternalUpload`Private`parseProductURL];
		parseProductURL[url] = result;
	];

	result

];

(* Helper to do a second attempt to find price, if the price is 0 *)
findProductPriceAgain[catalogNumber_String, supplier_String] := Switch[supplier,
	(* If we are not dealing with the 3 suppliers, just set to Null *)
	"other",
		Null,
	"thermo",
		Module[{productInformationJSON, productInformation, finalPriceFloat},
			productInformationJSON=Quiet[
				HTTPRequestJSON[{<|
					"URL" -> "https://www.thermofisher.com/api/store/sku/price/",
					"Method" -> "POST",
					"Body" -> {"items" -> {{"catalogNumber" -> catalogNumber, "quantity" -> 1}}}
				|>}]
			];
			productInformation = Quiet[Check[
				First[First[productInformationJSON]["products"]],
				$Failed
			]];

			If[MatchQ[productInformation, $Failed],
				Return[Null, Module]
			];

			finalPriceFloat = productInformation["unFormattedPrice"]["finalPrice"];

			If[MatchQ[finalPriceFloat, _?NumericQ],
				finalPriceFloat,
				Null
			]
		],
	"fisher",
		Module[{pricingAssociation, cleanedProductID, rawPrice},
			pricingAssociation = Quiet[Check[
				ImportString[URLRead[HTTPRequest["https://www.fishersci.com/shop/products/service/pricing?partNumber="<>catalogNumber<>"&callerId=products-ui-single-page", <|Method -> "POST"|>]]["Body"], "RawJSON"],
				$Failed
			]];
			If[MatchQ[pricingAssociation, $Failed],
				Return[Null, Module]
			];
			cleanedProductID = StringDelete[catalogNumber, "-"];

			rawPrice = pricingAssociation["priceAndAvailability"][cleanedProductID][[1]]["price"];

			Quiet[Check[
				ToExpression[StringCases[rawPrice, NumberString]],
				Null
			]]
		],
	(* We are not attempting to find price for sigma products. This is because sigma pricing API requires more than just catalog number as input *)
	(* It also needs the sku number and vendor (brand), which essentially means we need to re-run the entire parser in order to get the pricing *)
	_,
		Null
];


(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineOptions[UploadProduct,
	Options :> {
		{
			OptionName -> Synonyms,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				]
			],
			Description -> "List of possible alternative names this product goes by.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ProductModel,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Sample],
					Model[Container],
					Model[Sensor],
					Model[Part],
					Model[Plumbing],
					Model[Wiring],
					Model[Item]
				}]
			],
			Description -> "The model for the samples that this product generates when purchased.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> ImageFile,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> URLP,
				PatternTooltip -> "The URL of the catalog image of this product.",
				Size -> Line
			],
			Description -> "The URL of the catalog image of this product.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> ProductListing,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				PatternTooltip -> "Full name under which the product is listed, including make and model where relevant.",
				Size -> Line
			],
			Description -> "Full name under which the product is listed, including make and model where relevant.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> CatalogDescription,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				PatternTooltip -> "The full description of the item as it is listed in the supplier's catalog including any relevant information on the number of samples per item, the sample type, and/or the amount per sample if that information is included in the suppliers catalog list and necessary to place an order for the correct unit of the item which this product represents.",
				Size -> Line
			],
			Description -> "The full description of the item as it is listed in the supplier's catalog including any relevant information on the number of samples per item, the sample type, and/or the amount per sample if that information is included in the suppliers catalog list and necessary to place an order for the correct unit of the item which this product represents.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Supplier,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Company, Supplier]]
			],
			Description -> "Company that supplies this product.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> CatalogNumber,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				PatternTooltip -> "Number or code that should be used to purchase this item from the supplier.",
				Size -> Word
			],
			Description -> "Number or code that should be used to purchase this item from the supplier.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Manufacturer,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Company, Supplier]]
			],
			Description -> "The company that manufactures this product, when different from the supplier.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> ManufacturerCatalogNumber,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				PatternTooltip -> "Number or code that the manufacturer uses to refer to this product, when the manufacturer is different from the supplier.",
				Size -> Word
			],
			Description -> "Number or code that the manufacturer uses to refer to this product, when the manufacturer is different from the supplier.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> ProductURL,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> URLP,
				PatternTooltip -> "Supplier webpage for the product.",
				Size -> Line
			],
			Description -> "Supplier webpage for the product.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Packaging,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PackagingP
			],
			Description -> "Specify whether this product comes in a case (which contains multiple items) or comes in a single item.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> SampleType,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> SampleDescriptionP
			],
			Description -> "The description of a single sample contained within an item of this product.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> NumberOfItems,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterP[0, 1]
			],
			Description -> "Number of samples in each order of one unit of the catalog number, e.g. 24 (plates per case).",
			Category -> "Product Specifications"
		},
		{
			OptionName -> DefaultContainerModel,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{
					Model[Container, Vessel],
					Model[Container, ReactionVessel],
					Model[Container, GasCylinder],
					Model[Container, Bag],
					Model[Container, Shipping],
					Model[Container, Plate],
					Model[Container, MicroscopeSlide]
				}]
			],
			Description -> "The model of the container that the sample arrives in upon delivery. If a Model[Container,Plate] is given, the plate must only have 1 well.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Amount,
			Default -> Null,
			AllowNull -> True,
			Widget -> Alternatives[
				"Volume" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 20 Liter],
					Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
				],
				"Mass" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Picogram, 20 Kilogram],
					Units -> {1, {Milligram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}
				],
				"Count" -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Unit, 1 Unit],
					Units -> {1, {Unit, {Unit}}}
				]
			],
			Description -> "Amount that comes with each sample.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Density,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 Milligram / Liter, 1 Kilogram / Milliliter],
				Units -> CompoundUnit[{1, {Gram, {Milligram, Gram, Kilogram}}}, {-1, {Microliter, {Microliter, Milliliter, Liter}}}]
			],
			Description -> "Relation between mass of the product and volume.",
			Category -> "Product Specification"
		},
		{
			OptionName -> CountPerSample,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterP[0]
			],
			Description -> "Count of individual items that comes with each sample (e.g. 100 for a 100 frits in a bag).",
			Category -> "Product Specifications"
		},
		{
			OptionName -> KitComponents,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				{
					"NumberOfItems" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[1, 1]
					],
					"ProductModel" -> Widget[
						Type -> Object,
						Pattern :> ObjectP[{
							Model[Sample],
							Model[Container],
							Model[Item],
							Model[Sensor],
							Model[Part],
							Model[Plumbing],
							Model[Wiring]
						}]
					],
					"DefaultContainerModel" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Model[Container]]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					],
					"Amount" -> Alternatives[
						"Volume" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Nanoliter, 20 Liter],
							Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
						],
						"Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[1 Nanogram, 20 Kilogram],
							Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
						],
						"Count" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Unit, 1 Unit],
							Units -> {1, {Unit, {Unit}}}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					],
					"Position" -> Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
							PatternTooltip -> "Enumeration must be any well from A1 to P24."
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					],
					"ContainerIndex" -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> GreaterEqualP[1, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					],
					"DefaultCoverModel"->Alternatives[
						Widget[
							Type->Object,
							Pattern:>ObjectP[{Model[Item,Cap],Model[Item,Lid]}]
						],
						Widget[
							Type->Enumeration,
							Pattern:>Alternatives[Null]
						]
					],
					"OpenContainer"->Widget[
						Type->Enumeration,
						Pattern:>BooleanP
					]
				}
			],
			Description -> "All information about the components of this kit product.  For every entry, the indices refer to 1.) The number of copies of the given kit component in the kit, 2.) The model for the samples that this component of the kit will generate, 3.) The model of the container that this kit component arrives in, 4.) The amount that comes with each sample, 5.) The position in the DefaultContainerModel in which this arrives, 6.) The index of the container in which it appears (such that if two different kit components share a ContainerIndex, they will go into the same container, like with a plate), 7) The model of the lid or cap the default container model accepts, and 8) whether the container can be covered.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> ShippedClean,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates that samples of this product arrive ready to be used without needing to be dishwashed.",
			Category -> "Inventory"
		},
		{
			OptionName -> Sterile,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates that samples of this product arrive sterile from the manufacturer.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> Price,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 * USD],
				Units -> {1, {USD, {USD}}}
			],
			Description -> "Supplier listed price for one unit of this product.",
			Category -> "Pricing Information"
		},
		{
			OptionName -> Site,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Container, Site]]
			],
			Description -> "The ECL facility at which the product can be purchased. Null indicates that the product can be purchased at any ECL location.",
			Category -> "Pricing Information"
		},
		{
			OptionName -> OpenContainer,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates that the container contents are exposed to the open environment when in use and can not be sealed off via capping.",
			Category -> "Hidden"
		},
		{
			OptionName -> UsageFrequency,
			Default -> High,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> UsageFrequencyP
			],
			Description -> "An estimate of how often this product is purchased from ECL's inventory for use in experiments and subsequently restocked. Products which are used more frequently carry smaller stocking fees as they must be stored in inventory for a shorter period of time then more rarely consumed items.",
			Category -> "Hidden"
		},
		{
			OptionName -> Template,
			Default -> Null,
			Description -> "A template Object[Product] whose values will be used as defaults for any options not specified by the user.",
			AllowNull -> True,
			Category -> "Product Specifications",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Product]],
				ObjectTypes -> {Object[Product]}
			]
		},
		{
			OptionName -> SealedContainer,
			Default -> Null,
			Description -> "Indicates whether the items of this product arrive as sealed containers with caps or lids. If SealedContainer -> True, no special storage handling will be performed, even if Sterile -> True.",
			AllowNull -> True,
			Category -> "Product Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> AsepticShippingContainerType,
			Default -> Null,
			Description -> "The manner in which an aseptic product is packed and shipped by the manufacturer. A value of None indicates that the product is not shipped in any specifically aseptic packaging, while a value of Null indicates no available information.",
			AllowNull -> True,
			Category -> "Product Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> AsepticShippingContainerTypeP
			]
		},
		{
			OptionName -> AsepticRebaggingContainerType,
			Default -> Null,
			Description -> "Describes the type of container items of this product will be transferred to if they arrive in a non-resealable aseptic shipping container.",
			AllowNull -> True,
			Category -> "Product Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> AsepticTransportContainerTypeP
			]
		},
		NameOption,
		UploadOption,
		OutputOption,
		CacheOption
	}
];


(* ::Subsubsection:: *)
(*Code*)


(* ::Subsubsection::Closed:: *)
(*resolveUploadProductOptions*)

DefineOptions[resolveUploadProductOptions, Options :> {
	HelperOutputOption
}];

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadProductOptions[myURL:(URLP | Null), myNewModelType:(TypeP[] | Null), myOptions_, myRawOptions_, fastAssoc_Association, myResolveOptions:OptionsPattern[]]:=Module[
	{
		listedOptions, outputOption, myOptionsAssociation, testsRule, resultRule, parsedInput, myMergedOptions,
		myFinalizedOptions, optionsWithAuthor, optionsWithType, resolvedKitComponents, kitQ,
		allKitModelPackets, optionsWithCorrectKitComponents, productModelPacket, resolvedDensity, optionsWithNotebook,
		resolvedSynonyms, unresolvedName, unresolvedSynonyms, resolvedName, productModel, unresolvedDensity, allKitModels,
		productModelConflictQ, productModelConflictOptions, productModelConflicTests, containerCoverConflictQ,
		defaultCoverModel, defaultContainerModel, containerCoverConflictOptions, containerCoverConflictTests,
		allTests, allFailingOptions, kitContainerCoverConflictQs, kitContainerCoverConflictOptions,
		kitContainerCoverConflictTests, resolvedAmount, unresolvedAmount, rawOptionsNoAutomatic,
		unresolvedImageFile, imageFilePath, validImageURLQ, validImagePathQ, resolvedImageFile,
		imageFilePacket, resolvedImageFileObject, templateOp, templatePacket, templatedSafeOps,
		parsedOptions
	},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* Convert the options to an association. *)
	myOptionsAssociation=Association @@ myOptions;

	(* -- AutoFill based on the information we're given. -- *)

	(* First, download all of the information that we have from the internet *)
	parsedInput = If[TrueQ[$UsePyeclProductParser],
		parseProductURL[myURL],
		Switch[myURL,
			(* UploadProduct[] *)
			Null,
			{},

			(* UploadProduct[thermoURL], if we could not retrieve anything from website after trying 10 times, return an empty association *)
			ThermoFisherURLP,
			With[{rawParsedInput=retryConnection[parseThermoProductURL[myURL], 3]}, If[MatchQ[rawParsedInput,$Failed], {}, rawParsedInput]],

			(* UploadProduct[fisherSciURL], if we could not retrieve anything from website after trying 10 times, return an empty association *)
			FisherScientificURLP,
			With[{rawParsedInput=retryConnection[parseFisherProductURL[myURL], 3]}, If[MatchQ[rawParsedInput,$Failed], {}, rawParsedInput]],

			(* UploadProduct[sigmaURL], if we could not retrieve anything from website after trying 3 times, return an empty association *)
			(* decreased retry times here since sigma website may block us b/c we retried too often *)
			MilliporeSigmaURLP,
			With[{rawParsedInput=retryConnection[parseSigmaProductURL[myURL], 3]}, If[MatchQ[rawParsedInput,$Failed], {}, rawParsedInput]]
		]
	];

	(* Remove all parsed options with value = Null *)
	parsedOptions = If[MatchQ[parsedInput, ($Failed | {} | <||>)],
		{},
		KeyValueMap[
			Function[{key, value},
				If[NullQ[value],
					Nothing,
					key -> value
				]
			],
			parsedInput
		]
	];

	(* -- Make sure that we do not overwrite any of the user's supplied OPTIONS. -- *)
	rawOptionsNoAutomatic = Select[myRawOptions, !MatchQ[Values[#], Automatic]&];

	(* We use a double Replace Rule to fulfill the purpose. First, take the SafeOptions and replace with auto-parsed option *)
	(* Then, replace that with user-supplied option (EVEN IF it's Null, so that user can correct an incorrectly-parsed option) *)
	(* However, exclude XX -> Automatic from the raw options. *)
	myMergedOptions = ReplaceRule[
		ReplaceRule[
			myOptions,
			parsedOptions
		],
		rawOptionsNoAutomatic
	];

	(* Resovle Name and Synonyms. *)
	unresolvedName = Lookup[myMergedOptions, Name];
	unresolvedSynonyms = Lookup[myMergedOptions, Synonyms];

	{resolvedName, resolvedSynonyms} = Which[
		(* If Name is Null but Synonyms is not, use the first entry from Synonyms as Name *)
		NullQ[unresolvedName] && MatchQ[unresolvedSynonyms, _List] && Length[unresolvedSynonyms] > 0,
			{First[unresolvedSynonyms], unresolvedSynonyms},
		(* If both Name and Synonyms are Null or {}, keep that unchanged *)
		NullQ[unresolvedName] && MatchQ[unresolvedSynonyms, (Null | {})],
			{Null, Null},
		(* If Name is not Null but Synonyms is, use Name as Synonyms *)
		MatchQ[unresolvedSynonyms, (Null | {})],
			{unresolvedName, {unresolvedName}},
		(* If both are not Null and Synonyms already contain the name, do not change *)
		MemberQ[unresolvedSynonyms, unresolvedName],
			{unresolvedName, unresolvedSynonyms},
		(* Only remaining possibility is that both are not Null and Synonyms do not contain Name. Add Name to Synonyms *)
		True,
			{unresolvedName, Prepend[unresolvedSynonyms, unresolvedName]}
	];

	(* get a packet of the Object[Sample] this Product is associated with *)
	productModel = Lookup[myMergedOptions, ProductModel];

	productModelPacket=If[MatchQ[productModel, ObjectP[Model[Sample]]],
		Experiment`Private`fetchPacketFromFastAssoc[productModel, fastAssoc]
	];

	(* resolve density *)
	unresolvedDensity = Lookup[myMergedOptions, Density, Null];

	resolvedDensity = Which[
		(* if user specified Density, use it *)
		!NullQ[unresolvedDensity],
			unresolvedDensity,
		(* if we have density in the model packet, use it *)
		!NullQ[productModelPacket] && !NullQ[Lookup[productModelPacket, Density, Null]],
			Lookup[productModelPacket, Density],
		(* Otherwise, return Null *)
		True,
			Null
	];

	(* Make sure not to overwrite any of the user's specified options. *)
	myFinalizedOptions = ReplaceRule[
		myMergedOptions,
		{
			Name -> resolvedName,
			Synonyms -> resolvedSynonyms,
			Density -> resolvedDensity
		}
	];

	(* pull out KitComponents because that changes a lot of what we do below *)
	resolvedKitComponents=Lookup[myFinalizedOptions, KitComponents];
	kitQ=Not[NullQ[resolvedKitComponents]];

	(* If we have to return Result from this function, compute our result. *)
	resultRule=Result -> If[MemberQ[ToList[outputOption], Result],

		(* Return our list of options. *)
		myFinalizedOptions,

		(* We don't have to return the Output. Return Null. *)
		Null
	];

	(* If we have to return Tests from this function, gather up our list of tests. *)
	testsRule=Tests -> If[MemberQ[ToList[outputOption], Tests],
		(* We have to return Tests. Construct a list of Tests. *)
		(* Add the Author->___ rule to our option set such that the validQ tests work (they are expecting an already formed packet. *)
		optionsWithAuthor=Append[myFinalizedOptions, Append[Author] -> Link[$PersonID]];

		(* Append Type->Object[Product] to make this a valid packet. *)
		optionsWithType=Append[optionsWithAuthor, Type -> Object[Product]];

		(* if KitComponents is Null, replace that with {} here *)
		optionsWithCorrectKitComponents=If[NullQ[Lookup[optionsWithType, KitComponents]],
			Append[optionsWithType, KitComponents -> {}],
			optionsWithType
		];

		(* need to add Notebook in based on $Notebook *)
		optionsWithNotebook=Append[optionsWithCorrectKitComponents, Notebook -> Link[$Notebook, Objects]];

		(* Return the Model[Sample] and Model[Sample] tests. *)
		Join[
			{Test["The Name of this Object[Product] is unique in Constellation if a Name is specified:",
				!SameQ[Lookup[optionsWithNotebook, Name], Null] && Length[Search[Object[Product], Name == Lookup[optionsWithNotebook, Name]]] >= 1,
				False
			]},
			ValidObjectQ`Private`validProductQTests[optionsWithNotebook]
		],
		(* We don't have to return Tests. Return Null. *)
		Null
	];

	(* Return the output. *)
	outputOption /. {testsRule, resultRule, Preview -> Null}
];


(* ::Subsubsection::Closed:: *)
(*Public Function*)


Error::FailedTestForProduct="The following tests have failed, resulting in an invalid product: `1`.";


(* Overload for the case of no input arguments *)
UploadProduct[myOptions:OptionsPattern[]]:=UploadProduct[Null, myOptions];

UploadProduct[myInput_, myOptions:OptionsPattern[UploadProduct]]:=Module[
	{listedOptions, safeOptions, safeOptionTests, validLengths, validLengthTests, outputSpecification, output,
		gatherTests, voqTests, resolvedOptionsResult, optionsWithValidAmount, passedQ, resolvedOptions, optionsRule, previewRule, testsRule,
		resultRule, optionsWithAuthors, optionsWithType, optionsWithoutNulls, linkFields, optionsWithLinkFields,
		relationFields, relationFieldToTwoWayField, optionsWithTwoWayLinkFields, multipleFields, optionsWithMultiples, optionsWithDeprecated,
		optionswithStructureImage, functionSpecificOptions, optionsWithoutFunctionOptions, finalizedPacket, templateOp,
		templateObj, templatedSafeOps, optionsWithTemplate, optionsWithKitComponents, kitComponents, failedTestDescriptions, savedMessageList,
		objectsToDownload, downloadedStuff, fastAssoc, cache, packetsToUpload
	},

	(* Make sure we are working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=If[MatchQ[Lookup[listedOptions, Output], Missing["KeyAbsent", Output]],
		Result,
		Lookup[listedOptions, Output]
	];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadProduct, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadProduct, listedOptions, AutoCorrect -> False], Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=Switch[myInput,
		(* UploadProduct[myThermoFisherURL] *)
		ThermoFisherURLP,
		ValidInputLengthsQ[UploadProduct, {myInput}, listedOptions, 1, Output -> {Result, Tests}],

		(* UploadProduct[myMilliporeSigmaURL] *)
		MilliporeSigmaURLP,
		ValidInputLengthsQ[UploadProduct, {myInput}, listedOptions, 2, Output -> {Result, Tests}],

		(* UploadProduct[myFisherScientificURL] *)
		FisherScientificURLP,
		ValidInputLengthsQ[UploadProduct, {myInput}, listedOptions, 3, Output -> {Result, Tests}],

		(* UploadProduct[] *)
		Null,
		ValidInputLengthsQ[UploadProduct, {}, listedOptions, 4, Output -> {Result, Tests}]
	];

	(* If the specified options do not match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[Lookup[listedOptions, Output] /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Store the value from the Template option *)
	templateOp=Lookup[safeOptions, Template];

	(* Gather information on the provided Objects *)
	templateObj=Download[
		templateOp
	];

	(* Replaces any rules that were not specified by the user with a value from the template *)
	templatedSafeOps=resolveTemplateOptions[
		UploadProduct,
		templateObj,
		listedOptions,
		safeOptions,
		Exclude -> {
			Name,
			Synonyms,
			ImageFile,
			ProductListing,
			CatalogNumber,
			ManufacturerCatalogNumber,
			ProductURL,
			KitComponents
		}
	];

	(* Do a big download here on all Objects in the options *)
	objectsToDownload = Cases[Flatten[Values[templatedSafeOps]], ObjectP[]];

	downloadedStuff = Download[objectsToDownload, Packet[All]];

	cache = Lookup[safeOptions, Cache, {}];

	fastAssoc = Experiment`Private`makeFastAssocFromCache[
		Experiment`Private`FlattenCachePackets[{cache, downloadedStuff}]
	];

	(* Call resolveUploadCompanySupplierOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we cannot actually return the standard result *)
	resolvedOptionsResult=Check[
		resolvedOptions=resolveUploadProductOptions[myInput, Null, templatedSafeOps, listedOptions, fastAssoc],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* generate the beginning of the packet *)

	(* Add unit to Amount if we are given integer directly *)
	optionsWithValidAmount = ReplaceRule[
		resolvedOptions,
		Amount -> If[MatchQ[Lookup[resolvedOptions,Amount,Null],_Integer],
			Lookup[resolvedOptions,Amount,Null]*Unit,
			Lookup[resolvedOptions,Amount,Null]
		]
	];

	(* Add Author to be $PersonID *)
	optionsWithAuthors = Join[optionsWithValidAmount, {Author -> $PersonID}];

	(* Add Type to be Object[Product] *)
	optionsWithType = Append[optionsWithAuthors, Type -> Object[Product]];

	(* Add Template option value *)
	optionsWithTemplate = Append[optionsWithType, Template -> Lookup[resolvedOptions, Template]];

	(* Remove any options that are Null. *)
	optionsWithoutNulls = (If[SameQ[#[[2]], Null], Nothing, #]&) /@ optionsWithType;

	(* For fields that are links, wrap a link head around the value. *)
	linkFields = {Author, Site};
	optionsWithLinkFields = Map[
		If[MemberQ[linkFields, #[[1]]],
			#[[1]] -> Link[#[[2]]],
			#
		]&,
		optionsWithoutNulls
	];

	(* For fields that are links and have relations, make a two-way link. *)
	relationFields = {ProductModel, Supplier, Manufacturer, DefaultContainerModel, Orders, Template};
	relationFieldToTwoWayField = <|
		ProductModel -> Products,
		Supplier -> Products,
		Manufacturer -> Products,
		DefaultContainerModel -> ProductsContained,
		Orders -> Products,
		Template -> ProductsTemplated
	|>;
	optionsWithTwoWayLinkFields = Map[
		If[MemberQ[relationFields, #[[1]]],
			#[[1]] -> Link[#[[2]], relationFieldToTwoWayField[#[[1]]]],
			#
		]&,
		optionsWithLinkFields
	];

	(* pull out the KitComponents right now *)
	kitComponents = Lookup[optionsWithTwoWayLinkFields, KitComponents, {}];

	(* change the options explicitly rather than the bonkers stuff above to have the KitComponents option populate the field properly *)
	optionsWithKitComponents = ReplaceRule[
		optionsWithTwoWayLinkFields,
		KitComponents -> Map[
			<|
				NumberOfItems -> #[[1]],
				ProductModel -> Link[#[[2]], KitProducts],
				DefaultContainerModel -> Link[#[[3]]],
				Amount -> If[MatchQ[#[[4]],_Integer],#[[4]]*Unit,#[[4]]],
				Position -> #[[5]],
				ContainerIndex -> #[[6]],
				DefaultCoverModel -> Link[#[[7]]],
				OpenContainer -> #[[8]]
			|>&,
			(* don't want to map over a Null since this is a multiple field and it has to be {}, not Null *)
			If[NullQ[kitComponents], {}, kitComponents]
		]
	];

	(* Put Append around any keys that are a multiple field. *)
	multipleFields = {Synonyms, KitComponents};
	optionsWithMultiples = (If[MemberQ[multipleFields, #[[1]]], Append[#[[1]]] -> #[[2]], #]&) /@ optionsWithKitComponents;

	(* Download the Structure image separately to make sure it has a valid image extension. Some pages serve it as a .cgi *)
	(* Import the image before uploading it. This will auUploadProductObjecttomatically make the file extension the correct format. *)
	(* TODO for now this may upload image file with invalid format, but later once the next release happens, we'll change this to the improved downloadAndValidateURL function *)
	optionswithStructureImage = Map[
		(
			If[SameQ[ImageFile, #[[1]]],
				With[{insertMe = #[[2]]}, #[[1]] -> Link[UploadCloudFile[Import[insertMe]]]],
				#
			]&
		),
		optionsWithMultiples
	];

	(* Add Deprecated\[Rule]False *)
	optionsWithDeprecated = Append[optionswithStructureImage, Deprecated -> False];

	(* Remove function specific options. *)
	functionSpecificOptions = {Upload, Output, Cache, Strict};
	optionsWithoutFunctionOptions = (If[MemberQ[functionSpecificOptions, #[[1]]], Nothing, #]&) /@ optionsWithDeprecated;

	(* Convert to an Association (packets are associations) *)
	finalizedPacket = Association @@ optionsWithoutFunctionOptions;

	(* Clear $MessageList so that we can dump the error messages for the next line -- this is necessary because the errors for bad options are being thrown in VOQ, which we need to harvest and convert to options here. MM will record all thrown message for an evaluation in $MessageList. We are dumping all existing messages up to this point, so that we can hijack MM's internal message setup to return a nice list of messages thrown in the VOQ below *)
	savedMessageList = $MessageList;
	Unprotect[$MessageList];
	$MessageList = {};
	Protect[$MessageList];

	(* need to add Notebook to the finalized packets because otherwise we'll get weird errors about $Notebook missing *)
	(* although only append $Notebook when it is actually an object, otherwise just let raw Upload handles it *)
	{{passedQ, failedTestDescriptions}, voqTests} =If[gatherTests,
		ValidObjectQMessages[
			myInput,
			If[MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
				Append[finalizedPacket,
					Notebook->Link[$Notebook]
				],
				finalizedPacket
			],
			ToList[myOptions],
			Output -> {Result, Tests}
		],
		{
			ValidObjectQMessages[
				myInput,
				If[MatchQ[$Notebook, ObjectP[Object[LaboratoryNotebook]]],
					Append[finalizedPacket,
						Notebook->Link[$Notebook]
					],
					finalizedPacket
				],
				ToList[myOptions],
				Output -> Result
			],
			{}
		}
	];

	(* Throw an error if we have any failed tests *)
	Which[

		(* If VOQ threw an error because of bad options *)
		!passedQ && !gatherTests && MatchQ[$MessageList, Except[{}]], Module[{errorNames, invalidOptions},

		(* Get the error messages *)
		errorNames=ToString /@ Cases[$MessageList, HoldForm[MessageName[Error | Warning, _String]]];

		(* Lookup the error options *)
		invalidOptions=Flatten[Lookup[ValidObjectQ`Private`errorToOptionMap[Object[Product]], errorNames, Nothing]];

		(* Throw a message with our error *)
		Message[Error::InvalidOption, invalidOptions]
	],

		(* If VOQ did not throw an error but we are about to return Null because we failed a VOQ test *)
		!passedQ && !gatherTests && MatchQ[failedTestDescriptions, Except[{}]], Message[Error::FailedTestForProduct, StringRiffle[StringReplace[failedTestDescriptions, ":" -> ""], {"\"", "\", \"", "\""}]]
	];

	(* Add any messages we had from before to $MessageList *)
	Unprotect[$MessageList];
	$MessageList=Join[savedMessageList, $MessageList];
	Protect[$MessageList];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[UploadProduct, resolvedOptions],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	(* There is no preview for this function. *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all existing tests generated by helper functions with any additional tests *)
		Flatten[Join[safeOptionTests, validLengthTests, voqTests]],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed] && passedQ,

		(* Check the Upload option. If Upload\[Rule]True, upload the object. If Upload\[Rule]False, return the packet. *)
		If[Lookup[resolvedOptions, Upload],
			(* Note: Upload will change our RuleDelayeds into Rules. *)
			Upload[finalizedPacket],
			(* Otherwise, leave the RuleDelayed in place such that we are not unnecessarily uploading Cloud Files. *)
			finalizedPacket
		],
		Null
	];
	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*Valid Function*)


DefineOptions[ValidUploadProductQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadProduct}
];


ValidUploadProductQ[myOptions:OptionsPattern[]]:=ValidUploadProductQ[Null, myOptions];

ValidUploadProductQ[myInput_, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadProduct[myInput, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadProductQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadProductQ"]
];


(* ::Subsubsection::Closed:: *)
(*Option Function*)


DefineOptions[UploadProductOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadProduct}
];


UploadProductOptions[myOptions:OptionsPattern[]]:=UploadProductOptions[Null, myOptions];

UploadProductOptions[myInput:_, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadProduct[myInput, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadProduct],
		options
	]
];




(* ::Subsection::Closed:: *)
(*UploadInventory*)

(* ::Subsubsection::Closed:: *)
(*UploadInventory*)

DefineOptions[UploadInventory,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "inputs",
			{
				OptionName -> ModelStocked,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The model associated with the product being kept above the given threshold.",
				ResolutionDescription -> "If the input is a standard product, this is automatically set to the ProductModel field. For products associated with kits, the ProductModel of the first entry of the KitComponents field is used. This option is not used when the input is a stock solution.",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Model[Container], Model[Part], Model[Item], Model[Plumbing], Model[Wiring], Model[Sensor]}],
					PreparedSample->False,
					PreparedContainer->False
				]
			},
			{
				OptionName -> Name,
				Default -> Automatic,
				AllowNull -> False,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name which should be used to refer to the output inventory object in lieu of an automatically generated ID number.",
				ResolutionDescription -> "Name is set automatically using the name of the product being kept in stock.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Status,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates if this inventory object is set to active and will place orders as needed, or if it is no longer needed and no new orders need to be placed.",
				ResolutionDescription -> "If creating a new inventory object, automatically set to Active.  If editing an existing inventory object, automatically set to the current status.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> InventoryStatusP
				]
			},
			{
				OptionName -> StockingMethod,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates if this inventory will count the number of currently-stocked containers or the total amount (mass/volume/count/number of objects) of the model available for use.",
				ResolutionDescription -> "If creating a new inventory object for a sample, automatically set to NumberOfStockedContainers when ReorderThreshold or ReorderAmount are specified as integers. If ReorderThreshold or ReorderAmount are specified as masses or volumes then this is set to TotalAmount. New inventory objects for reusable objects default to use TotalAmount if no other information is given. If editing an existing inventory object, the StockingMethod will be unchanged.",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> InventoryStockingMethodP
				]
			},
			{
				OptionName -> ReorderThreshold,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates the point below which the current amount of this item must fall for a new order to be triggered.",
				ResolutionDescription -> "If creating a new inventory object automatically set to reorder items only when the current amount is 0.  If editing an existing inventory object, automatically set to the current value.",
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterEqualP[0., 1.]
					],
					"Number of Units" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					]
				]
			},
			{
				OptionName -> ReorderAmount,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates the amount that will be automatically ordered if the current amount available in the lab falls below ReorderThreshold.",
				ResolutionDescription -> "If creating a new inventory object, ReorderAmount is automatically set to 1 Unit for Object[Product] or when StockingMethod is NumberOfStockedContainers. For stock solutions, it defaults to the greater of the ReorderThreshold, TotalVolume of Model[Sample], or 1 Milliliter/Gram (if TotalVolume is not available). If editing an existing inventory, it is set to the current value for Object[Product], and to the greater of the current value and ReorderThreshold for Model[Sample].",
				Category -> "Restocking",
				Widget -> Alternatives[
					"Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Microliter, 20 Liter],
						Units -> {1, {Microliter, {Microliter, Milliliter, Liter}}}
					],
					"Mass" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[1 Milligram, 20 Kilogram],
						Units -> {1, {Milligram, {Milligram, Gram, Kilogram}}}
					],
					"Count" -> Widget[
						Type -> Number,
						Pattern :> GreaterP[0., 1.]
					],
					"Number of Units" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Unit, 1 Unit],
						Units -> {1, {Unit, {Unit}}}
					]
				]
			},
			{
				OptionName -> Site,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "Indicates the lab where this item is kept in stock.",
				ResolutionDescription -> "If creating a new inventory object, automatically set to the user's default site ($Site).",
				Category -> "Organizational Information",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Container, Site]],
						PreparedSample -> False,
						PreparedContainer -> False
					],
					Widget[
						Type->Enumeration,
						Pattern:>Alternatives[All]
					]
				]
			},
			(* Note: These options will be removed when UploadInventory is reviewed as part of the Sample Intake updates *)
			{
				OptionName -> Expires,
				Default -> Automatic,
				Description -> "Indicates if the samples this inventory keeps in stock expire after the time specified in ShelfLife/UnsealedShelfLife.",
				ResolutionDescription -> "Automatically set to True if ShelfLife or UnsealedShelfLife are populated or if Expires -> True for the specified ModelStocked.  Automatically set to False otherwise.",
				AllowNull -> True,
				Category -> "Expiration",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ShelfLife,
				Default -> Automatic,
				Description -> "The length of time after the DateCreated of the sample this inventory keeps in stock is recommended for use before it should be discarded.",
				ResolutionDescription -> "Automatically set to the ShelfLife of the ModelStocked.",
				AllowNull -> True,
				Category -> "Expiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Day],
					Units -> Day
				]
			},
			{
				OptionName -> UnsealedShelfLife,
				Default -> Automatic,
				Description -> "The length of time after the DateUnsealed of the sample this inventory keeps in stock is recommended for use before it should be discarded.",
				ResolutionDescription -> "Automatically set to the UnsealedShelfLife of the ModelStocked.",
				AllowNull -> True,
				Category -> "Expiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Day],
					Units -> Day
				]
			},
			{
				OptionName -> MaxNumberOfUses,
				Default -> Automatic,
				Description -> "The number of times the ModelStocked can be used before needing to be discarded and/or replaced.",
				ResolutionDescription -> "Automatically set to the MaxNumberOfUses of ModelStocked if that field exists, or Null otherwise.",
				AllowNull -> True,
				Category -> "Expiration",
				Widget -> Widget[
					Type -> Number,
					Pattern :> GreaterP[0., 1.]
				]
			},
			{
				OptionName -> MaxNumberOfHours,
				Default -> Automatic,
				Description -> "The number of hours the ModelStocked can be used before needing to be discarded and/or replaced.",
				ResolutionDescription -> "Automatically set to the MaxNumberOfHours of ModelStocked if that field exists, or Null otherwise.",
				AllowNull -> True,
				Category -> "Expiration",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Hour],
					Units -> Hour
				]
			}
		],
		UploadOption,
		CacheOption,
		OutputOption
	}
];

Error::DeprecatedProducts="The following specified product(s) or model(s) `1` are deprecated and no longer supported at ECL. Please specify only active products or models to create new inventories.";
Error::ModelStockedRequired="For the following input(s) `1`, ModelStocked was set to an invalid value. If creating or editing an inventory object for a stock solution or product, ModelStocked must be Null. Please set ModelStocked accordingly, or allow it to be set automatically.";
Error::ModelStockedNotAllowed="For the following product(s) `1`, ModelStocked was set to model(s) `2`.  However, these model(s) are not supplied by the specified products.  Please set ModelStocked to a value contained in the ProductModel or KitComponents fields of these products, or allow ModelStocked to be set automatically.";
Error::InvalidReorderAmount="ReorderAmount must be set to an integer value if creating or editing an inventory object for a product. Please use a model if you wish to specify an amount";
Error::StockingMethodInvalid="If StockingMethod is set to NumberOfStockedContainers, ReorderThreshold and ReorderAmount must be set to an integer value.  If creating or editing an inventory object for a product, ReorderAmount must also be an integer value.  Please set StockingMethod, ReorderThreshold, and/or ReorderAmount accordingly for the following inputs: `1`.";
Error::ReorderStateMismatch="For the following input(s) `1`, the state of the samples in question are `2`, but the ReorderThreshold and/or ReorderAmount options are incompatible with this state.  Please specify these options in units matching the state of the sample, or allow them to be set automatically.";
Warning::ReorderAmountUpdated = "ReorderAmount was updated for `1` from `2` to `3`. When creating or updating an inventory for Object[Product], ReorderAmount must be specified in integer units. For stock solutions, ReorderAmount must be greater than or equal to ReorderThreshold.";
Error::InventorySiteNotResolved="For the following input(s) `1`, it was not possible to determine an eligible site. Please ensure your financing team has ExperimentSites set.";
Error::InvalidInventorySite="For the following input(s) `1`, the provided Site `2` is not usable for the team financing the input object. Please select a site from the team's ExperimentSites or leave Site as Automatic.";
Error::IndividualSiteRequired="For the following input(s) `1`, multiple sites were specified (via All) for a single inventory object. Please use a specific Site or set the Site option to Automatic.";
Error::LowReorderAmount = "ReorderAmount cannot be less than ReorderThreshold. Please change ReorderAmount (`1`) to values greater than or equal to ReorderThreshold (`2`) for input(s) `3`.";
Error::AuthorNotFinancerMember = "`1`";
Error::InventorySiteCannotBeChanged="For the following input(s) `1`, the Site at which this inventory will be stocked is requested to be changed to `2`. Site changes are not permitted for existing inventories - please create a new inventory with the same parameters using UploadInventory.";

(* Follow messages will be removed with Sample Intake mods *)
Error::ExpirationDateMismatch="For the following input(s) `1`, the Expires, ShelfLife, and UnsealedShelfLife options are incompatible.  If Expires is set to True, then at least one of ShelfLife and UnsealedShelfLife must be specified.  If set to False, both must not be specified.  Please adjust these options, or allow them to be set automatically.";
Error::MaxNumberOfUsesInvalid="For the following input(s) `1`, the MaxNumberOfUses option was specified.  However, if creating or editing an inventory object for a stock solution, or if creating or editing one for a product whose ModelStocked lacks the MaxNumberOfUses field, then this option must not be specified.  Please set it to Null, or allow it to be set automatically.";
Error::MaxNumberOfHoursInvalid="For the following input(s) `1`, the MaxNumberOfUses option was specified.  However, if creating or editing an inventory object for a stock solution, or if creating or editing one for a product whose ModelStocked lacks the MaxNumberOfHours field, then this option must not be specified.  Please set it to Null, or allow it to be set automatically.";


(* empty list overload; always return {}*)
UploadInventory[{}, myOptions:OptionsPattern[UploadInventory]]:={};

(* existing inventory overload *)
UploadInventory[myExistingInventory:ObjectP[Object[Inventory]], myOptions:OptionsPattern[UploadInventory]]:=UploadInventory[{myExistingInventory}, myOptions];
UploadInventory[myExistingInventories:{ObjectP[Object[Inventory]]..}, myOptions:OptionsPattern[UploadInventory]]:=Module[
	{listedOptions, safeOptions, safeOptionTests, validLengths, validLengthTests, outputSpecification, output, expandedOptions,
		gatherTests, resolvedOptionsResult, resolvedOps, resolvedOptionsTests, allTests, upload, returnEarlyQ,
		mapThreadFriendlyOptions, newInventoryPackets, testRule, previewRule, optionsRule, resultRule, filteredMapThreadFriendlyOptions, safeFieldUpdate},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadInventory, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadInventory, listedOptions, Output -> Result, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Determine the requested return value from the function *)
	upload = Lookup[safeOptions, Upload];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[UploadInventory, {myExistingInventories}, listedOptions, 2, Output -> {Result, Tests}],
		{ValidInputLengthsQ[UploadInventory, {myExistingInventories}, listedOptions, 2, Output -> Result], Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* expand the options to be the proper length *)
	expandedOptions = Last[ExpandIndexMatchedInputs[UploadInventory, {myExistingInventories}, safeOptions, 2]];

	(* get the resolved options *)
	(* note that since this is the edit-existing-inventory overload, pass Null for the input that refers to the product this wants to be created from (can derive that later) *)
	resolvedOptionsResult = Check[
		{resolvedOps, resolvedOptionsTests} = If[gatherTests,
			resolveUploadInventoryOptions[ConstantArray[Null, Length[myExistingInventories]], myExistingInventories, expandedOptions, Output -> {Result, Tests}],
			{resolveUploadInventoryOptions[ConstantArray[Null, Length[myExistingInventories]], myExistingInventories, expandedOptions, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* combine all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, validLengthTests, resolvedOptionsTests}], TestP];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {Result -> $Failed, Options -> resolvedOps, Preview -> Null, Tests -> allTests}]
	];

	(* MapThread-ify the resolved options *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[UploadInventory, resolvedOps];

	(* Filter the resolved options so that we only retain the ones that are being changed *)
	filteredMapThreadFriendlyOptions = MapThread[
		(* Map over all inputs *)
		Function[{newFieldPacket, oldFieldPacket},

			(* Map over every one of the resolved option -> value for the given input *)
			Association@@KeyValueMap[

				(* If the resolved option value doesn't match the existing field value, keep the option. Otherwise remove it *)
				If[!MatchQ[#2, Alternatives[Lookup[oldFieldPacket, #1], Lookup[oldFieldPacket, #1] /. {x : LinkP[] :> Download[x, Object]}]],
					#1 -> #2,
					Nothing
				] &,
				newFieldPacket
			]
		],
		{mapThreadFriendlyOptions, Download[myExistingInventories]}
	];

	(* ------------------ *)
	(* -- Make packets -- *)
	(* ------------------ *)

	(* Little helpers to add each field change to the upload packet, only if the option is present in the resolved options (and therefore field value is being changed) *)
	(* Overload for simple options where we just upload a value to the field of the same name *)
	safeFieldUpdate[options_Association, Rule[field_, value_]] := If[KeyExistsQ[options, field],
		field -> value,
		Nothing
	];
	(* Overload for more complex options where that's not the case. For example where we upload both to the named field and a log field *)
	safeFieldUpdate[options_Association, field_Symbol, fieldSpecification_List] := If[KeyExistsQ[options, field],
		Sequence@@fieldSpecification,
		Nothing
	];

	(* generate the packets for the new inventory objects *)
	(*note that here each packet is per site*)
	newInventoryPackets = MapThread[
		Function[{existingInventory, options},
			options;
			<|
				Object -> Download[existingInventory, Object],
				If[MatchQ[existingInventory, ObjectP[Object[Inventory, Product]]],
					safeFieldUpdate[options, ModelStocked -> Link[Lookup[options, ModelStocked]]],
					Nothing
				],
				safeFieldUpdate[options, Name -> Lookup[options, Name]],
				safeFieldUpdate[options, Status -> Lookup[options, Status]],
				safeFieldUpdate[options, Site -> Link[Lookup[options, Site]]],
				safeFieldUpdate[options, StockingMethod -> Lookup[options, StockingMethod]],
				safeFieldUpdate[options, ReorderThreshold,
					{
						ReorderThreshold -> Replace[Lookup[options, ReorderThreshold], x_Integer :> x * Unit, {0}],
						Append[ReorderThresholdLog] -> {Now, Replace[Lookup[options, ReorderThreshold], x_Integer :> x * Unit, {0}]}
					}
				],
				safeFieldUpdate[options, ReorderAmount,
					{
						ReorderAmount -> Replace[Lookup[options, ReorderAmount], x_Integer :> x * Unit, {0}],
						Append[ReorderAmountLog] -> {Now, Replace[Lookup[options, ReorderAmount], x_Integer :> x * Unit, {0}]}
					}
				],
				safeFieldUpdate[options, Expires -> Lookup[options, Expires]],
				safeFieldUpdate[options, ShelfLife -> Lookup[options, ShelfLife]],
				safeFieldUpdate[options, UnsealedShelfLife -> Lookup[options, UnsealedShelfLife]],
				safeFieldUpdate[options, MaxNumberOfUses -> Lookup[options, MaxNumberOfUses]],
				safeFieldUpdate[options, MaxNumberOfHours -> Lookup[options, MaxNumberOfHours]]
			|>
		],
		{myExistingInventories, filteredMapThreadFriendlyOptions}
	];

	(* make the output rules*)
	testRule = Tests -> If[gatherTests,
		allTests,
		Null
	];
	previewRule = Preview -> Null;
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOps,
		Null
	];
	resultRule = Result -> Which[
		MemberQ[output, Result] && upload,
			(* doing this to return the proper with-name form of the objects if desired*)
			With[{outputObjs = Upload[newInventoryPackets]},
				MapThread[
					If[NullQ[#2],
						#1,
						Append[Most[#1], #2]
					]&,
					{outputObjs, Lookup[filteredMapThreadFriendlyOptions, Name, Null]}
				]
			],
		MemberQ[output, Result], newInventoryPackets,
		True, Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testRule}

];

(* new inventory overload *)
UploadInventory[myProductOrModel:ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}], myOptions:OptionsPattern[UploadInventory]]:=UploadInventory[{myProductOrModel}, myOptions];
UploadInventory[myProductsOrModels:{ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]..}, myOptions:OptionsPattern[UploadInventory]]:=Module[
	{listedOptions, safeOptions, safeOptionTests, validLengths, validLengthTests, outputSpecification, output, expandedOptions,
		gatherTests, resolvedOptionsResult, resolvedOpsForDisplay, rawResolvedOps, resolvedOptionsTests, returnEarlyQ, mapThreadFriendlyOptions, newInventoryPackets,
		inventoryObjTypes, inventoryIDs, now, allTests, upload, testRule, previewRule, optionsRule, resultRule, resolvedSite, resolvedSitesNames},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* determine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[UploadInventory, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadInventory, listedOptions, Output -> Result, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Determine the requested return value from the function *)
	upload = Lookup[safeOptions, Upload];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[UploadInventory, {myProductsOrModels}, listedOptions, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[UploadInventory, {myProductsOrModels}, listedOptions, 1, Output -> Result], Null}
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* expand the options to be the proper length *)
	expandedOptions = Last[ExpandIndexMatchedInputs[UploadInventory, {myProductsOrModels}, safeOptions, 1]];

	(* get the resolved options *)
	(* note that since this is the create-new-inventory overload, pass Null for the input that refers to the existing object *)
	resolvedOptionsResult = Check[
		{rawResolvedOps, resolvedOptionsTests} = If[gatherTests,
			resolveUploadInventoryOptions[myProductsOrModels, ConstantArray[Null, Length[myProductsOrModels]], expandedOptions, Output -> {Result, Tests}],
			{resolveUploadInventoryOptions[myProductsOrModels, ConstantArray[Null, Length[myProductsOrModels]], expandedOptions, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption, Error::AuthorNotFinancerMember}
	];

	(* Because we resolved Site to a list of Object[Container, Site]s we need to reset this to All for the user to see. *)
	resolvedOpsForDisplay = ReplaceRule[rawResolvedOps, {Site -> (Lookup[rawResolvedOps, Site]/.{ObjectP[]...}->All)}];

	(* we are pulling out Site because the option value shown to the user is All, not the actual list of sites *)
	(* make sure to convert any single sites into lists *)
	resolvedSite = ToList/@Lookup[rawResolvedOps, Site];
	resolvedSitesNames = Unflatten[Download[Flatten[resolvedSite], Name],ToList/@resolvedSite];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this because if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolvedOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* combine all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, validLengthTests, resolvedOptionsTests}], TestP];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {Result -> $Failed, Options -> resolvedOpsForDisplay, Preview -> Null, Tests -> allTests}]
	];

	(* MapThread-ify the resolved options *)
	mapThreadFriendlyOptions = OptionsHandling`Private`mapThreadOptions[UploadInventory, resolvedOpsForDisplay];

	(* get the type of the objects we are going to make *)
	inventoryObjTypes = Map[
		If[MatchQ[#, ObjectP[Object[Product]]],
			Object[Inventory, Product],
			Object[Inventory, StockSolution]
		]&,
		myProductsOrModels
	];
	inventoryIDs = CreateID[inventoryObjTypes];

	(* set Now so that all these guys have the same DateCreated *)
	now = Now;

	(* generate the packets for the new inventory objects. Site will be a multiple at this point, as All has resolved to {site1, site2..} so there may need ot be identical updates for multiple sites  *)
	newInventoryPackets = MapThread[
		Function[{prodOrModel, inventoryID, options, sites, siteNames},
			MapThread[
				<|
					Type -> inventoryID,
					If[MatchQ[inventoryID, Object[Inventory, Product]],
						ModelStocked -> Link[Lookup[options, ModelStocked]],
						Nothing
					],
					Replace[StockedInventory] -> {Link[prodOrModel, Inventories]},
					Status -> Lookup[options, Status],
					Notebook -> Link[Lookup[options, Notebook]],
					Author -> Link[$PersonID],
					Site -> Link[#1],
					StockingMethod -> Lookup[options, StockingMethod],
					ReorderThreshold -> Replace[Lookup[options, ReorderThreshold], x_Integer :> x * Unit, {0}],
					Append[ReorderThresholdLog] -> {Now, Replace[Lookup[options, ReorderThreshold], x_Integer :> x * Unit, {0}]},
					ReorderAmount -> Replace[Lookup[options, ReorderAmount], x_Integer :> x * Unit, {0}],
					Append[ReorderAmountLog] -> {Now, Replace[Lookup[options, ReorderAmount], x_Integer :> x * Unit, {0}]},
					(* set these to be zero now; will get updated by SyncInventory but it's dumb to leave it Null now and then make it be invalid *)
					CurrentAmount -> Switch[Lookup[options, ReorderThreshold],
						MassP, 0 Gram,
						VolumeP, 0 Milliliter,
						_, 0 Unit
					],
					Append[CurrentAmountLog] -> Switch[Lookup[options, ReorderThreshold],
						MassP, {Now, 0 Gram},
						VolumeP, {Now, 0 Milliliter},
						_, {Now, 0 Unit}
					],
					OutstandingAmount -> Switch[Lookup[options, ReorderThreshold],
						MassP, 0 Gram,
						VolumeP, 0 Milliliter,
						_, 0 Unit
					],
					Append[OutstandingAmountLog] -> Switch[Lookup[options, ReorderThreshold],
						MassP, {Now, 0 Gram},
						VolumeP, {Now, 0 Milliliter},
						_, {Now, 0 Unit}
					],
					Expires -> Lookup[options, Expires],
					ShelfLife -> Lookup[options, ShelfLife],
					UnsealedShelfLife -> Lookup[options, UnsealedShelfLife],
					MaxNumberOfUses -> Lookup[options, MaxNumberOfUses],
					MaxNumberOfHours -> Lookup[options, MaxNumberOfHours],
					Name -> Lookup[options, Name]<>" "<>#2
				|>&,
				{sites, siteNames}
			]
		],
		{myProductsOrModels, inventoryObjTypes, mapThreadFriendlyOptions, resolvedSite, resolvedSitesNames}
	];

	(* make the output rules*)
	testRule = Tests -> If[gatherTests,
		allTests,
		Null
	];
	previewRule = Preview -> Null;
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOpsForDisplay,
		Null
	];

	resultRule = Result -> Which[
		MemberQ[output, Result] && upload,
		(* we now potentially return multiple packets for one product. If the user want so convert to named form for they are free to use NamedObject.*)
		(* we want to allow this to be public because we could be making public reorder inventories here *)
		Block[{$AllowPublicObjects = True},
			Upload[Flatten[newInventoryPackets]]
		],

		MemberQ[output, Result], Flatten[newInventoryPackets],

		True, Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testRule}

];

(* only do this memoized search if we need to, remove ECL-1 *)
allECLSites[string:_String]:=allECLSites[string]=Module[{},
	AppendTo[$Memoization, ExternalUpload`Private`allECLSites];

	DeleteCases[Search[Object[Container, Site], EmeraldFacility==True], Object[Container, Site, "id:1ZA60vLrXG4M"]]
];


(* resolve the options *)
resolveUploadInventoryOptions[
	myProductsOrModels:{(Null | ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}])..},
	myExistingInventories:{(Null | ObjectP[Object[Inventory]])..},
	myOptions:{_Rule..},
	myResolutionOptions:OptionsPattern[]
]:=Module[
	{
		listedOptions, output, allDownloadValues, productOrStockSolutionPackets, potentialModelStockedPackets,
		productModelPackets, kitProductModelPackets, existingInventoryPackets, modelsStockedPacketsNoAutoNoNull,
		specifiedModelsStockedNoAutoNoNull, resolvedModelStocked, mapThreadFriendlyOptions, modelStockedNotNullInvalidQs,
		resolvedStatus, resolvedSite, resolvedStockingMethod, resolvedReorderThreshold, resolvedReorderAmount,
		existingInventoryPossibleModelPackets, existingInventoryProdPackets, modelStockedNotAllowedQs, invalidReorderAmountTests,
		stockingMethodInvalidQs, stockingMethodInvalidThresholdQs, reorderStateMismatchQs, reorderStateMismatchOptions, types, productFinancerPackets,
		maxNumUsesInvalidOptions, maxNumUsesInvalidTests, reorderStateMismatchTests, expiresShelfLifeMismatchOptions,
		expiresShelfLifeMismatchTests, expiresShelfLifeMismatchQs, resolvedExpires, resolvedShelfLife, authorTests,
		resolvedUnsealedShelfLife, resolvedMaxNumberOfUses, resolvedMaxNumberOfHours, maxNumHoursInvalidOptions,
		maxNumHoursInvalidQs, maxNumUsesInvalidQs, inputsToUse, gatherTests, messages, maxNumHoursInvalidTests,
		modelStockedNotNullInvalidOptions, modelStockedNotNullInvalidTests, modelStockedNotAllowedOptions, personIDNotebooks,
		modelStockedNotAllowedTests, stockingMethodInvalidOptions, stockingMethodInvalidTests, cache, resolvedNotebook,
		potentialFutureObjs, nameAlreadyExistsQs, productModelDeprecatedQ, productModelDeprecatedInputs, productModelDeprecatedTests,
		resolvedState, invalidOptions, allTests, resolvedOptions, testsRule, resultRule, outputSpecification,
		resolvedName, conflictingNameQs, productToSiteLookup, inventoryToSiteLookup, userSitesForProducts, userSitesForInventories,
		noSiteQs, siteChangeQs, invalidSiteQs, existingInventoryToAllQs, noSiteTests, invalidSiteTests, reorderAmountTests,
		badAllSiteTests, noSiteOptions, invalidSiteOptions, badAllSiteOptions,allowedNotebooksForProducts, allowedMembersForProducts,
		lowReorderAmountQs, reorderAmountOptions, invalidSiteChangeOptions, reorderAmountChangeQs, reorderAmountModificationTests
	},

	(* -------------------- *)
	(* -- Set Up Options -- *)
	(* -------------------- *)

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolutionOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputSpecification=Lookup[listedOptions, Output, Result];
	output=ToList[outputSpecification];
	gatherTests=MemberQ[output, Tests];
	messages=Not[gatherTests];

	(* pull out the cache options *)
	cache=Lookup[myOptions, Cache];

	(* pull out the ModelStocked but delete the Null or Automatic values *)
	specifiedModelsStockedNoAutoNoNull=DeleteCases[Lookup[myOptions, ModelStocked], Automatic | Null];

	(* -------------- *)
	(* -- Download -- *)
	(* -------------- *)

	(* Download values from the products, models, and existing inventories *)
	allDownloadValues=Quiet[Download[
		{
			myProductsOrModels,
			myExistingInventories,
			specifiedModelsStockedNoAutoNoNull,
			{$PersonID}
		},
		{
			{
				Packet[ProductModel, KitComponents, State, Expires, ShelfLife, UnsealedShelfLife, CountPerSample, Amount, TotalVolume, NumberOfItems, Deprecated, Name, Site, Notebook],
				Packet[ProductModel[{State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours, Reusable}]],
				Packet[KitComponents[[All, ProductModel]][{State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours, Reusable}]],
				Packet[Notebook[Financers][{ExperimentSites, NotebooksFinanced, Members}]]
			},
			{
				Packet[StockedInventory, Status, Site, Notebook, StockingMethod, ReorderThreshold, ReorderAmount, ModelStocked, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours, Name],
				Packet[StockedInventory[{ProductModel, KitComponents, State, Expires, ShelfLife, UnsealedShelfLife, CountPerSample, Amount, TotalVolume, NumberOfItems}]],
				Notebook[Financers][ExperimentSites][Object],
				Packet[StockedInventory[ProductModel][{State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours}]],
				Packet[StockedInventory[KitComponents][[All, ProductModel]][{State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours}]],
				Packet[ModelStocked[{State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours}]]
			},
			{
				Packet[State, Tablet, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours]
			},
			{
				FinancingTeams[NotebooksFinanced]
			}
		},
		Cache -> cache
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* pull out the different relevant packets*)
	{productOrStockSolutionPackets, productModelPackets, kitProductModelPackets, productFinancerPackets}=If[MatchQ[myProductsOrModels, {Null..}],
		ConstantArray[myProductsOrModels, 4],
		{allDownloadValues[[1, All, 1]], allDownloadValues[[1, All, 2]], allDownloadValues[[1, All, 3]], allDownloadValues[[1, All, 4]]}
	];
	{existingInventoryPackets, existingInventoryProdPackets, userSitesForInventories, existingInventoryPossibleModelPackets}=If[MatchQ[myExistingInventories, {Null..}],
		ConstantArray[myExistingInventories, 4],
		{allDownloadValues[[2, All, 1]], allDownloadValues[[2, All, 2]], allDownloadValues[[2, All, 3]], Flatten[allDownloadValues[[2, All, 4;;]]]}
	];
	modelsStockedPacketsNoAutoNoNull=Flatten[allDownloadValues[[3]]];

	(* look up the notebooks that the user is part of *)
	personIDNotebooks = Cases[Flatten[allDownloadValues[[4]]], ObjectP[Object[LaboratoryNotebook]]];

	(* lookup notebook-related values *)
	(* lookup available experiment sites *)
	userSitesForProducts = If[MatchQ[Flatten[productFinancerPackets], NullP],
		ConstantArray[Null, Length[myProductsOrModels]],
		Download[Lookup[#, ExperimentSites], Object]& /@ productFinancerPackets
	];

	(* Lookup allowed notebooks *)
	allowedNotebooksForProducts = If[MatchQ[Flatten[productFinancerPackets], NullP],
		ConstantArray[{}, Length[myProductsOrModels]],
		Download[Lookup[Flatten[productFinancerPackets], NotebooksFinanced, {}], Object]
	];

	(* lookup allowed members *)
	allowedMembersForProducts = If[MatchQ[Flatten[productFinancerPackets], NullP],
		ConstantArray[{}, Length[myProductsOrModels]],
		Download[Lookup[Flatten[productFinancerPackets], Members, {}], Object]
	];


	(* create lookups to navigate from productsOrModels or Inventory to valid sites *)
	(* the Financers field is multiple, so just make sure to get all valid sites as a flat list *)
	productToSiteLookup = MapThread[(#1-> DeleteDuplicates[Flatten[ToList[#2]]])&,{Download[myProductsOrModels, Object], userSitesForProducts}];
	inventoryToSiteLookup = MapThread[(#1-> DeleteDuplicates[Flatten[ToList[#2]]])&,{Download[myExistingInventories, Object], userSitesForInventories}];

	(* combine the packets that could be used for what the ModelStocked could resolve to *)
	potentialModelStockedPackets=Cases[Flatten[{productModelPackets, kitProductModelPackets, modelsStockedPacketsNoAutoNoNull, existingInventoryPossibleModelPackets}], PacketP[]];

	(* ------------------------ *)
	(* -- Input error checks -- *)
	(* ------------------------ *)

	(* figure out if the product is Deprecated *)
	productModelDeprecatedQ=Map[
		If[NullQ[#],
			False,
			TrueQ[Lookup[#, Deprecated, Null]]
		]&,
		productOrStockSolutionPackets
	];

	(* throw a message if ModelStocked is specified but needs to be Null *)
	productModelDeprecatedInputs=If[MemberQ[productModelDeprecatedQ, True] && messages,
		(
			Message[Error::DeprecatedProducts, ToString[Download[PickList[productOrStockSolutionPackets, productModelDeprecatedQ], Object]]];
			Message[Error::InvalidInput, ToString[Download[PickList[productOrStockSolutionPackets, productModelDeprecatedQ], Object]]];
			Download[PickList[productOrStockSolutionPackets, productModelDeprecatedQ], Object]
		),
		{}
	];

	(* generate the ModelStockedRequired tests *)
	productModelDeprecatedTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=Download[PickList[productOrStockSolutionPackets, productModelDeprecatedQ], Object];

			(* get the inputs that pass this test *)
			passingInputs=Download[PickList[productOrStockSolutionPackets, productModelDeprecatedQ, False], Object];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["The following products or models "<>ToString[failingInputs]<>" are not Deprecated and can be used for new inventories:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[DeleteCases[passingInputs, Null]] > 0,
				Test["The following products or models "<>ToString[passingInputs]<>" are not Deprecated and can be used for new inventories:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* Throw an error if $PersonID is not a member of $Notebook financer members *)
	resolvedNotebook = Which[

		(* do not change Notebook for existing inventories. For existing inventories, the Notebook is not updated in the inventory packet, so it does not matter what the notebook is resolved to here. *)
		MatchQ[myExistingInventories, {ObjectP[Object[Inventory]]..}],
			Nothing,

		(* allowedNotebooksForProducts and allowedMembersForProducts are concordant since both come from product/inventory Notebook. in other words, if one is populated, the other should be populated too; if one is empty, the other should be empty too *)

	(* allowedMembersForProducts and allowedNotebooksForProducts are both empty for all products/inventories *)
		(* if an emerald person runs the function and $Notebook is empty, return Null *)
		And[
			MatchQ[Flatten[allowedMembersForProducts], {}],
			MatchQ[Flatten[allowedNotebooksForProducts], {}],
			MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
			MatchQ[$Notebook, Null]
		],
			Null,

		(* $Notebook is always populated for a customer, so the case of a customer with empty $Notebook does not exist unless an emerald user uses the customer's $PersonID, so throw an error *)
		And[
			MatchQ[Flatten[allowedMembersForProducts], {}],
			MatchQ[Flatten[allowedNotebooksForProducts], {}],
			!MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
			MatchQ[$Notebook, Null]
		],
			Message[Error::AuthorNotFinancerMember, "$Notebook is Null but your $PersonID is" <> ECL`InternalUpload`ObjectToString[$PersonID] <>". Please make sure you have selected a working notebook"

			];
			Null,

		(* when an emerald person runs the function and $Notebook is populated, throw an error; they probably used a customer Notebook. *)
		And[
			MatchQ[Flatten[allowedMembersForProducts], {}],
			MatchQ[Flatten[allowedNotebooksForProducts], {}],
			MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
			MatchQ[$Notebook, ObjectP[]]
		],
			Message[Error::AuthorNotFinancerMember, "$Notebook is " <> ECL`InternalUpload`ObjectToString[$Notebook] <> ". If you intend to create an Inventory for a customer, please use the tutoring account associated with their financing team. If this is a public inventory, set $Notebook to Null."];
			Null,

		(* if customer runs the function, return their $Notebook. make sure $Notebook belongs to $PersonID *)
		And[
			MatchQ[Flatten[allowedMembersForProducts], {}],
			MatchQ[Flatten[allowedNotebooksForProducts], {}],
			!MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
			MatchQ[$Notebook, ObjectP[]]
		],
			If[MatchQ[$Notebook, ObjectP[personIDNotebooks]],
				$Notebook,
				Message[Error::AuthorNotFinancerMember, "$Notebook " <> ECL`InternalUpload`ObjectToString[$Notebook] <> " does not belong to this $PersonID: " <> ECL`InternalUpload`ObjectToString[$PersonID] <> ". Please use the correct $PersonID or $Notebook."]
			],

	(* allowedMembersForProducts and allowedNotebooksForProducts are both populated at least for one product or inventory *)
		(* if $PersonID and $Notebook are member of allowedMembersForProducts and allowedNotebooksForProducts for all products/inventories that have notebooks, return $Notebook *)
		And[
			And @@ (MatchQ[$PersonID, ObjectP[#]] || MatchQ[#, {}]& /@ allowedMembersForProducts),
			And @@ (MatchQ[$Notebook, ObjectP[#]] || MatchQ[#, {}]& /@ allowedNotebooksForProducts)
		],
			$Notebook,

		(* if $PersonID or $Notebook are not members of allowedMembersForProducts or allowedNotebooksForProducts for any products/inventories that have notebooks, throw an error *)
		Or[
			MemberQ[(MatchQ[$PersonID, ObjectP[#]] || MatchQ[#, {}])& /@ allowedMembersForProducts, False],
			MemberQ[(MatchQ[$Notebook, ObjectP[#]] || MatchQ[#, {}])& /@ allowedNotebooksForProducts, False]
		],
			Message[Error::AuthorNotFinancerMember, "Some of the products/stock solutions are not associated with your team. Please check $PersonID and $Notebook. Currently $PersonID is " <> ECL`InternalUpload`ObjectToString[$PersonID] <> " and $Notebook is " <> ECL`InternalUpload`ObjectToString[$Notebook] <> "."];
			Null,

		(* all cases should be addressed before here, but if something made their way here, throw an error for further investigation *)
		(* unknown error. please contact infrastructure *)
		True,
			Message[Error::AuthorNotFinancerMember, "The consistency check between the Notebook of the products/stock solutions, $PersonID, and $Notebook returned unexpected results. Please check $PersonID and $Notebook and make sure you have access to these products/stock solutions."];
			Null
	];

	(* tests for AuthorNotFinancerMember error *)
	authorTests = If[MatchQ[myExistingInventories, {ObjectP[Object[Inventory]]}],

		Nothing,

		Test["The input products belong to the user or are public:",
			Or[
				And[
					MatchQ[Flatten[allowedMembersForProducts], {}],
					MatchQ[Flatten[allowedNotebooksForProducts], {}],
					MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
					MatchQ[$Notebook, Null]
				],
				And[
					MatchQ[Flatten[allowedMembersForProducts], {}],
					MatchQ[Flatten[allowedNotebooksForProducts], {}],
					!MatchQ[$PersonID, ObjectP[Object[User, Emerald]]],
					MatchQ[$Notebook, ObjectP[personIDNotebooks]]
				],
				And[
					!MatchQ[Flatten[allowedMembersForProducts], {}],
					!MatchQ[Flatten[allowedNotebooksForProducts], {}],
					And @@ (MatchQ[$PersonID, ObjectP[#]] || MatchQ[#, {}]& /@ allowedMembersForProducts),
					And @@ (MatchQ[$Notebook, ObjectP[#]] || MatchQ[#, {}]& /@ allowedNotebooksForProducts)
				]
			]
		]
	];

	(* --------------------------- *)
	(* --- Resolve the options --- *)
	(* --------------------------- *)

	(* MapThread the options so that we can do our big MapThread *)
	mapThreadFriendlyOptions=OptionsHandling`Private`mapThreadOptions[UploadInventory, myOptions];

	{
		resolvedModelStocked,
		resolvedStatus,
		resolvedSite,
		resolvedStockingMethod,
		resolvedReorderThreshold,
		resolvedReorderAmount,
		resolvedExpires,
		resolvedShelfLife,
		resolvedUnsealedShelfLife,
		resolvedMaxNumberOfUses,
		resolvedMaxNumberOfHours,
		modelStockedNotNullInvalidQs,
		modelStockedNotAllowedQs,
		stockingMethodInvalidQs,
		stockingMethodInvalidThresholdQs,
		reorderStateMismatchQs,
		lowReorderAmountQs,
		expiresShelfLifeMismatchQs,
		maxNumUsesInvalidQs,
		maxNumHoursInvalidQs,
		resolvedState,
		resolvedName,
		noSiteQs,
		siteChangeQs,
		invalidSiteQs,
		existingInventoryToAllQs,
		reorderAmountChangeQs
	}=Transpose[MapThread[
		Function[{prodOrModel, existingInventory, options, existingInventoryProdPacketsPerInventory},
			Module[
				{specifiedModelStocked, modelStocked, modelStockedNotNullInvalidQ, modelStockedPacket, specifiedStatus, status,
					specifiedSite, site, specifiedStockingMethod, specifiedReorderThreshold, specifiedReorderAmount, stockingMethod,
					reorderThreshold, reorderAmount, state, allowedModelsStocked, modelStockedNotAllowedQ, stockingMethodInvalidQ,stockingMethodInvalidThresholdQ,
					reorderStateMismatchQ, specifiedExpires, specifiedShelfLife, lowReorderAmountQ,
					specifiedUnsealedShelfLife, specifiedMaxNumberOfUses, specifiedMaxNumberOfHours,
					expires, shelfLife, unsealedShelfLife, maxNumberOfHours, reorderAmountChangeQ,
					expiresShelfLifeMismatchQ, maxNumberOfUses, maxNumUsesInvalidQ, maxNumHoursInvalidQ, modelFields,
					newName, noSiteQ, siteChangeQ, invalidSiteQ, existingInventoryToAllQ
				},

				(* set our error tracking variables *)
				{
					modelStockedNotNullInvalidQ,
					modelStockedNotAllowedQ,
					stockingMethodInvalidQ,
					stockingMethodInvalidThresholdQ,
					reorderStateMismatchQ,
					lowReorderAmountQ,
					expiresShelfLifeMismatchQ,
					maxNumUsesInvalidQ,
					maxNumHoursInvalidQ,
					reorderAmountChangeQ
				} = {False, False, False, False, False, False, False, False, False, False};

				(* pull out the specified option values *)
				{
					specifiedModelStocked,
					specifiedStatus,
					specifiedSite,
					specifiedStockingMethod,
					specifiedReorderThreshold,
					specifiedReorderAmount,
					specifiedExpires,
					specifiedShelfLife,
					specifiedUnsealedShelfLife,
					specifiedMaxNumberOfUses,
					specifiedMaxNumberOfHours
				} = Lookup[options, {ModelStocked, Status, Site, StockingMethod, ReorderThreshold, ReorderAmount, Expires, ShelfLife, UnsealedShelfLife, MaxNumberOfUses, MaxNumberOfHours}];

				(* need to resolve ModelStocked immediately *)
				(* obviously if people specify whatever go with that *)
				(* if we have an existing Object[Inventory, Product] object, pick the value that is in there *)
				(* if we have an existing Object[Inventory, StockSolution] object, set to Null *)
				(* if we have a Model[Sample] as the input, then this is always Null *)
				(* if we have a ProductModel pick that one *)
				(* if we have a product that is a kit pick the first value that does NOT have KitProductContainers as the backlink *)
				modelStocked=Which[
					Not[MatchQ[specifiedModelStocked, Automatic]], specifiedModelStocked,
					MatchQ[existingInventory, ObjectP[Object[Inventory, Product]]], Download[Lookup[existingInventory, ModelStocked], Object],
					MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]], Null,
					MatchQ[prodOrModel, ObjectP[Model[Sample]]], Null,
					MatchQ[Lookup[prodOrModel, ProductModel], ObjectP[]], Download[Lookup[prodOrModel, ProductModel], Object],
					MatchQ[Lookup[prodOrModel, KitComponents], {_Association..}], Download[Lookup[SelectFirst[Lookup[prodOrModel, KitComponents], Not[MatchQ[Lookup[#, ProductModel][[2]], KitProductContainers]]&], ProductModel], Object],
					True, Null
				];

				(* flip the error switch if modelStocked is resolved to Null but it needs to have a value (i.e., if we are dealing with a product) or a value if it needs to be Null (i.e., if we have a stock solution) *)
				modelStockedNotNullInvalidQ=Or[
					NullQ[modelStocked] && (MatchQ[existingInventory, ObjectP[Object[Inventory, Product]]] || MatchQ[prodOrModel, ObjectP[Object[Product]]]),
					MatchQ[modelStocked, ObjectP[]] && (MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]] || MatchQ[prodOrModel, ObjectP[Model[Sample]]])
				];

				(* get the modelStocked packet *)
				modelStockedPacket=FirstCase[potentialModelStockedPackets, ObjectP[modelStocked], Null];

				(* get all the allowed ModelStocked values*)
				allowedModelsStocked=Which[
					MatchQ[prodOrModel, ObjectP[Model[Sample]]], {},
					MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]], {},
					MatchQ[existingInventoryProdPacketsPerInventory, {ObjectP[Object[Product]]..}] && MatchQ[Lookup[First[existingInventoryProdPacketsPerInventory], KitComponents], {_Association..}], Lookup[Lookup[First[existingInventoryProdPacketsPerInventory], KitComponents], ProductModel],
					MatchQ[existingInventoryProdPacketsPerInventory, {ObjectP[Object[Product]]..}], ToList[Lookup[First[existingInventoryProdPacketsPerInventory], ProductModel]],
					MatchQ[prodOrModel, ObjectP[Object[Product]]] && MatchQ[Lookup[prodOrModel, KitComponents], {_Association..}], Lookup[Lookup[prodOrModel, KitComponents], ProductModel],
					MatchQ[prodOrModel, ObjectP[Object[Product]]], ToList[Lookup[prodOrModel, ProductModel]],
					True, {}
				];

				(* flip an error switch if ModelStocked is not a member of the product's KitComponents or ProductModel *)
				(* if the modelStockedNotNullInvalidQ switch has already been flipped, then don't flip this one too *)
				modelStockedNotAllowedQ=Not[modelStockedNotNullInvalidQ] && Not[NullQ[modelStocked]] && Not[MemberQ[allowedModelsStocked, ObjectP[modelStocked]]];

				(* figure out the state of the thing we are stocking; if it is not a sample then it just becomes Null (also if it is a counted sample) *)
				state=Which[
					MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]] && VolumeQ[Lookup[existingInventory, ReorderAmount]], Liquid,
					MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]] && MassQ[Lookup[existingInventory, ReorderAmount]], Solid,
					MatchQ[prodOrModel, ObjectP[Model[Sample]]], Lookup[prodOrModel, State],
					NullQ[modelStockedPacket], Null,
					TrueQ[Lookup[modelStockedPacket, Tablet]], Null,
					MatchQ[Lookup[modelStockedPacket, State], PhysicalStateP], Lookup[modelStockedPacket, State],
					True, Null
				];

				(* resolve the Status; if you're making a new object then set to Active; if you're updating an old one, use what that is; otherwise obviously use what was set *)
				status=Which[
					Not[MatchQ[specifiedStatus, Automatic]], specifiedStatus,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, Status],
					True, Active
				];

				(* resolve Site *)
				site=Which[
					(* Option was populated, use the specified option *)
					MatchQ[specifiedSite, ObjectP[Object[Container, Site]]],
						specifiedSite,

					(* inventory object, use existing site *)
					MatchQ[existingInventory, ObjectP[Object[Inventory]]],
						Download[Lookup[existingInventory, Site], Object],

					(* product with site - use that *)
					MatchQ[prodOrModel, ObjectP[Object[Product]]]&&MatchQ[Lookup[prodOrModel, Site], ObjectP[]],
						Download[Lookup[prodOrModel, Site], Object],

					(* private product - use ExperimentSites if Site is set to ALl *)
					MatchQ[specifiedSite, All] && MatchQ[Lookup[prodOrModel, Notebook], ObjectP[]],
						Lookup[productToSiteLookup, Download[prodOrModel, Object]],

					(* For public product with option specified to All, use all ECL sites *)
					MatchQ[specifiedSite, All],
						allECLSites["Memoization"],

					(* for all other cases, including public/private products with Automatic Site Option, use $Site *)
					True,
						$Site
				];

				(* -- Site error checking -- *)

				(* were we unable to resolve a site? *)
				noSiteQ = MatchQ[site, Except[ListableP[ObjectP[Object[Container, Site]]]]];

				(* Is the site different than what was in the existing object? *)
				siteChangeQ = If[MatchQ[existingInventory, ObjectP[Object[Inventory]]],
					!MatchQ[Download[Lookup[existingInventory, Site], Object], site],
					False
				];

				(* make sure the site is an ECL site that is accessible for that financing team *)
				invalidSiteQ =
					If[MatchQ[prodOrModel, ObjectP[]],

						(* Product or model, check accessibility *)
						If[MatchQ[Lookup[prodOrModel, Notebook], ObjectP[]],
							(*this traverses the Notebook/Financers/ExperimentSites link*)
							!SubsetQ[Lookup[productToSiteLookup, Lookup[prodOrModel, Object]], Download[ToList[site], Object]],
							!SubsetQ[allECLSites["Memoization"], Download[ToList[site], Object]]
						],

						(* Inventory object, check that the site is allowed *)
						If[MatchQ[Lookup[existingInventory, Notebook], ObjectP[]],
							(*this traverses the Notebook/Financers/ExperimentSites link*)
							!SubsetQ[Lookup[inventoryToSiteLookup, Lookup[existingInventory, Object]], Download[ToList[site], Object]],
							!SubsetQ[allECLSites["Memoization"], Download[ToList[site], Object]]
						]
				];

				(* when uploading a specific inventory object, can use All *)
				existingInventoryToAllQ = If[MatchQ[existingInventory, ObjectP[Object[Inventory]]],
					MatchQ[specifiedSite, All],
					False
				];


				(* resolve StockingMethod; it's kind of complicated *)
				(* 0.) Obviously if already specified, pick that *)
				(* 1.) If an existing inventory, pick that value*)
				(* 2.) If a new inventory and CountPerSample is populated in the product, set to TotalAmount *)
				(* 3.) If a new inventory and the model stocked is not a sample, set to TotalAmount for reusable objects (assume types without this field are reusable), NumberOfStockedContainers otherwise *)
				(* 4.) If a new inventory and ReorderThreshold or ReorderAmount are integers/UnitsP[Unit], set to NumberOfStockedContainers*)
				(* 5.) Otherwise, set to TotalAmount *)
				stockingMethod=Which[
					Not[MatchQ[specifiedStockingMethod, Automatic]], specifiedStockingMethod,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, StockingMethod],
					MatchQ[prodOrModel, ObjectP[Object[Product]]] && (IntegerQ[Lookup[prodOrModel, CountPerSample]] || (Not[NullQ[modelStockedPacket]] && TrueQ[Lookup[modelStockedPacket, Tablet]])), TotalAmount,
					MatchQ[prodOrModel, ObjectP[Object[Product]]] && Not[MatchQ[modelStockedPacket, ObjectP[Model[Sample]]]] && MatchQ[Lookup[modelStockedPacket, Reusable],True|$Failed], TotalAmount,
					MatchQ[prodOrModel, ObjectP[Object[Product]]] && Not[MatchQ[modelStockedPacket, ObjectP[Model[Sample]]]], NumberOfStockedContainers,
					(* by the time we get to this part, we should be dealing with only Samples (and not Parts/Items/etc since those should have been caught by the above)*)
					MatchQ[specifiedReorderThreshold, UnitsP[Unit]] || MatchQ[specifiedReorderAmount, UnitsP[Unit]], NumberOfStockedContainers,
					True, TotalAmount
				];

				(* resolve ReorderThreshold *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If a new inventory and StockingMethod is NumberOfStockedContainers, set to 0 Unit *)
				(* 3.) If a new inventory and StockingMethod is TotalAmount and the sample is counted, set to 0 Unit*)
				(* 4.) If a new inventory and StockingMethod is TotalAmount and the sample is a Solid, set to 0 Gram*)
				(* 5.) If a new inventory and StockingMethod is TotalAmount and the sample is a Liquid, set to 0 Milliliter *)
				(* 6.) Otherwise, set to 0 Unit*)
				reorderThreshold=Which[
					Not[MatchQ[specifiedReorderThreshold, Automatic]], specifiedReorderThreshold,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, ReorderThreshold],
					MatchQ[prodOrModel, ObjectP[Object[Product]]], 0 Unit,
					MatchQ[stockingMethod, NumberOfStockedContainers], 0 Unit,
					MatchQ[stockingMethod, TotalAmount] && (IntegerQ[Lookup[prodOrModel, CountPerSample]] || (Not[NullQ[modelStockedPacket]] && TrueQ[Lookup[modelStockedPacket, Tablet]])), 0 Unit,
					MatchQ[stockingMethod, TotalAmount] && MatchQ[state, Solid], 0 Gram,
					MatchQ[stockingMethod, TotalAmount] && MatchQ[state, Liquid], 0 Milliliter,
					True, 0 Unit
				];

				(* resolve ReorderAmount *)
				{reorderAmount, reorderAmountChangeQ} = Which[
					(* if it's already specified, pick that *)
					Not[MatchQ[specifiedReorderAmount, Automatic]],
						{specifiedReorderAmount, False},

					(* existing inventories *)
					(* Object[Inventory, Product]: pick from the existing object with no change *)
					MatchQ[existingInventory, ObjectP[Object[Inventory, Product]]],
						(* ReorderAmount is always in integer units regardless of StockingMethod *)
						If[MatchQ[Lookup[existingInventory, ReorderAmount], UnitsP[Unit]],
							{Lookup[existingInventory, ReorderAmount], False},
							{1 Unit, True}
						],

					(* Object[Inventory, StockSolution: greater of the existing value and updated ReorderThreshold *)
					MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]],
						If[CompatibleUnitQ[Lookup[existingInventory, ReorderAmount], reorderThreshold],

							{Max[Lookup[existingInventory, ReorderAmount], reorderThreshold], Lookup[existingInventory, ReorderAmount] < reorderThreshold},

							(* if ReorderAmount does not have the same unit as ReorderThreshold, don't change it. Not sure which one has the correct unit. state check will be done later *)
							{Lookup[existingInventory, ReorderAmount], False}
						],

					(* new inventories *)
					(* new inventory from a product: always set to 1 Unit *)
					MatchQ[prodOrModel, ObjectP[Object[Product]]],
						{1 Unit, False},

					(* new inventory from a stock solution with StockingMethod of NumberOfStockedContainers: set to 1 Unit*)
					MatchQ[stockingMethod, NumberOfStockedContainers],
						{1 Unit, False},

					(* new inventory from a liquid stock solution with TotalVolume, set to the greater of TotalVolume and ReorderThreshold *)
					MatchQ[prodOrModel, ObjectP[Model[Sample]]] && MatchQ[Lookup[prodOrModel, {State, TotalVolume}], {Liquid, VolumeP}],
						If[CompatibleUnitQ[Lookup[prodOrModel, TotalVolume], reorderThreshold],

							{Max[Lookup[prodOrModel, TotalVolume], reorderThreshold], False},

							(* if TotalVolume does not have the same unit as ReorderThreshold, choose TotalVolume because it has the correct unit *)
							{Lookup[prodOrModel, TotalVolume], False}
						],

					(* new inventory from a solid stock solution (this is almost never going to happen): set to the greater of 1 Gram and reorderThreshold *)
					MatchQ[state, Solid],
						If[MassQ[reorderThreshold],

							{Max[1 Gram, reorderThreshold], False},

							(* if reorderThreshold is not in mass units, use 1 Gram because that is the correct unit *)
							{1 Gram, False}
						],

					(* catch all *)
					True,
						{1 Milliliter, False}
				];

				(* flip an error switch if StockingMethod -> NumberOfStockedContainers but ReorderThreshold and ReorderAmount are not integers *)
				stockingMethodInvalidQ = If[
					MatchQ[stockingMethod, NumberOfStockedContainers],
					Not[MatchQ[reorderThreshold, UnitsP[Unit]]] || Not[MatchQ[reorderAmount, UnitsP[Unit]]]
				];

				(* flip an error switch if dealing with a product and ReorderAmount is unitless *)
				stockingMethodInvalidThresholdQ = If[
					MatchQ[existingInventory, ObjectP[Object[Inventory, Product]]] || MatchQ[prodOrModel, ObjectP[Object[Product]]],
					Not[MatchQ[reorderAmount, UnitsP[Unit]]]
				];

				(* flip an error switch if ReorderThreshold and ReorderAmount units don't match the state of the model stocked *)
				reorderStateMismatchQ=Or[
					(MassQ[reorderThreshold] || MassQ[reorderAmount]) && Not[MatchQ[state, Solid]],
					(VolumeQ[reorderThreshold] || VolumeQ[reorderAmount]) && Not[MatchQ[state, Liquid]]
				];

				(* Throw an error if ReorderAmount is less than ReorderThreshold for stock solutions. No need to throw this error if they're not compatible. *)
				lowReorderAmountQ = If[
					Or[
						!CompatibleUnitQ[reorderAmount, reorderThreshold],
						!Or[
							MatchQ[prodOrModel, ObjectP[Model[Sample]]],
							MatchQ[existingInventory, ObjectP[Object[Inventory, StockSolution]]]
						]
					],
					False,
					reorderAmount < reorderThreshold
				];

				(* Resolve the Expires option *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If the ShelfLife or UnsealedShelfLife options were specified, then this becomes True *)
				(* 3.) If ModelStocked is a sample or if we're dealing with a stock solution, set to True if Expires is True already *)
				(* 4.) Otherwise, say False *)
				expires=Which[
					MatchQ[specifiedExpires, BooleanP], specifiedExpires,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, Expires],
					TimeQ[specifiedShelfLife] || TimeQ[specifiedUnsealedShelfLife], True,
					MatchQ[modelStockedPacket, ObjectP[]], TrueQ[Lookup[modelStockedPacket, Expires]] || TimeQ[Lookup[modelStockedPacket, ShelfLife]] || TimeQ[Lookup[modelStockedPacket, UnsealedShelfLife]],
					MatchQ[prodOrModel, ObjectP[Model[Sample]]], TrueQ[Lookup[prodOrModel, Expires]] || TimeQ[Lookup[prodOrModel, ShelfLife]] || TimeQ[Lookup[prodOrModel, UnsealedShelfLife]],
					True, False
				];

				(* Resolve the ShelfLife option *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If Expires is set to False, then set to Null *)
				(* 3.) If Expires is set to True, then pull ShelfLife from ModelStocked or the specified stock solution *)
				(* 4.) Otherwise, set to Null*)
				shelfLife=Which[
					MatchQ[specifiedShelfLife, Except[Automatic]], specifiedShelfLife,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, ShelfLife],
					Not[expires], Null,
					expires && MatchQ[modelStockedPacket, ObjectP[]], Replace[Lookup[modelStockedPacket, ShelfLife], {Except[TimeP] -> Null}, {0}],
					expires && MatchQ[prodOrModel, ObjectP[Model[Sample]]], Replace[Lookup[prodOrModel, ShelfLife], {Except[TimeP] -> Null}, {0}],
					True, Null
				];

				(* Resolve the UnsealedShelfLife option *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If Expires is set to False, then set to Null *)
				(* 3.) If Expires is set to True, then pull ShelfLife from ModelStocked or the specified stock solution *)
				(* 4.) Otherwise, set to Null*)
				unsealedShelfLife=Which[
					MatchQ[specifiedUnsealedShelfLife, Except[Automatic]], specifiedUnsealedShelfLife,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, UnsealedShelfLife],
					Not[expires], Null,
					expires && MatchQ[modelStockedPacket, ObjectP[]], Replace[Lookup[modelStockedPacket, UnsealedShelfLife], {Except[TimeP] -> Null}, {0}],
					expires && MatchQ[prodOrModel, ObjectP[Model[Sample]]], Replace[Lookup[prodOrModel, UnsealedShelfLife], {Except[TimeP] -> Null}, {0}],
					True, Null
				];

				(* flip a switch if Expires is True and ShelfLife and UnsealedShelfLife are Null, or if Expires is False and ShelfLife or UnsealedShelfLife are specified *)
				expiresShelfLifeMismatchQ=Or[
					expires && NullQ[shelfLife] && NullQ[unsealedShelfLife],
					Not[expires] && (TimeQ[shelfLife] || TimeQ[unsealedShelfLife])
				];

				(* Resolve the MaxNumberOfUses option *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If MaxNumberOfUses is an integer in ModelStocked, then use that *)
				(* 3.) Otherwise, set to Null *)
				maxNumberOfUses=Which[
					MatchQ[specifiedMaxNumberOfUses, UnitsP[Unit]], specifiedMaxNumberOfUses,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, MaxNumberOfUses],
					MatchQ[modelStockedPacket, ObjectP[]] && IntegerQ[Lookup[modelStockedPacket, MaxNumberOfUses]], Lookup[modelStockedPacket, MaxNumberOfUses],
					True, Null
				];

				(* Resolve the MaxNumberOfHours option *)
				(* 0.) Obviously if it's already specified, pick that *)
				(* 1.) If an existing inventory, pick that value *)
				(* 2.) If MaxNumberOfHours is an integer in ModelStocked, then use that *)
				(* 3.) Otherwise, set to Null *)
				maxNumberOfHours=Which[
					MatchQ[specifiedMaxNumberOfHours, UnitsP[Hour]], specifiedMaxNumberOfHours,
					MatchQ[existingInventory, ObjectP[Object[Inventory]]], Lookup[existingInventory, MaxNumberOfHours],
					MatchQ[modelStockedPacket, ObjectP[]] && TimeQ[Lookup[modelStockedPacket, MaxNumberOfHours]], Lookup[modelStockedPacket, MaxNumberOfHours],
					True, Null
				];

				(* pull out the type definition for the relevant model *)
				modelFields=Which[
					MatchQ[modelStockedPacket, ObjectP[]], ECL`Fields[Lookup[modelStockedPacket, Type], Output -> Short],
					MatchQ[existingInventoryProdPacketsPerInventory, {ObjectP[Model[Sample]]..}], ECL`Fields[Lookup[First[existingInventoryProdPacketsPerInventory], Type], Output -> Short],
					True, ECL`Fields[Lookup[prodOrModel, Type], Output -> Short]
				];

				newName = Which[
					Not[MatchQ[Lookup[options, Name], Automatic]], Lookup[options, Name],
					NullQ[prodOrModel], Lookup[existingInventory, Name],
					True, Lookup[prodOrModel, Name]
				];

				(* flip an error switch if MaxNumberOfUses is specified but there is no relevant field for the model *)
				maxNumUsesInvalidQ=IntegerQ[maxNumberOfUses] && Not[MemberQ[modelFields, MaxNumberOfUses]];
				maxNumHoursInvalidQ=TimeQ[maxNumberOfHours] && Not[MemberQ[modelFields, MaxNumberOfHours]];

				(* what to return*)
				{
					modelStocked,
					status,
					site,
					stockingMethod,
					reorderThreshold,
					reorderAmount,
					expires,
					shelfLife,
					unsealedShelfLife,
					maxNumberOfUses,
					maxNumberOfHours,
					modelStockedNotNullInvalidQ,
					modelStockedNotAllowedQ,
					stockingMethodInvalidQ,
					stockingMethodInvalidThresholdQ,
					reorderStateMismatchQ,
					lowReorderAmountQ,
					expiresShelfLifeMismatchQ,
					maxNumUsesInvalidQ,
					maxNumHoursInvalidQ,
					state,
					newName,
					noSiteQ,
					siteChangeQ,
					invalidSiteQ,
					existingInventoryToAllQ,
					reorderAmountChangeQ
				}
			]
		],
		{productOrStockSolutionPackets, existingInventoryPackets, mapThreadFriendlyOptions, existingInventoryProdPackets}
	]];

	(* ---------------------- *)
	(* --- Error Checking --- *)
	(* ---------------------- *)

	(* get the type we're creating *)
	types = MapThread[
		Which[
			MatchQ[#2, ObjectP[]], Download[#2, Type],
			MatchQ[#1, ObjectP[Object[Product]]], Object[Inventory, Product],
			MatchQ[#1, ObjectP[Model[Sample]]], Object[Inventory, StockSolution]
		]&,
		{myProductsOrModels, myExistingInventories}
	];

	(* make the potential objects that we need to run DatabaseMemberQ on *)
	(*because we might generate multiple objects, need to make sure there is no name overlap with Site name appended either*)
	potentialFutureObjs = MapThread[
		Function[{type, name, sites, inventoryObj},
			If[NullQ[name],
				Object[Inventory, "id:123"], (* this is an object that won't ever exist so it will return False to DatabaseMemberQ which is what I want *)
				If[MatchQ[inventoryObj, ObjectP[]],
					(*if we have an existing inventory, don't bother with appending site, just use the name*)
					Append[type, name],
					Prepend[Map[Append[type, name<>" "<>#]&, {sites}], Append[type,name]]
				]
			]
		],
		{types, resolvedName, Unflatten[Download[Flatten[resolvedSite], Name],resolvedSite], myExistingInventories}
	];


	(* -- Name errors -- *)

	(*because we automatically append an ECL site to the end of the names, need to make sure that this is going to wo*)

	(* figure out if the names already exist, and whether we care if they do (i.e., if we're editing an existing one, then that's fine) *)
	nameAlreadyExistsQs = Unflatten[DatabaseMemberQ[Flatten[potentialFutureObjs]], potentialFutureObjs];
	conflictingNameQs = MapThread[
		TrueQ[#1] && Not[MatchQ[#2, ObjectP[#3]]]&,
		{nameAlreadyExistsQs, potentialFutureObjs, myExistingInventories}
	];

	resolvedName = If[MemberQ[conflictingNameQs, True],
		Map[# <> " " <> StringDelete[CreateUUID[],"-"]&,resolvedName],
		resolvedName];

	(* get the actual inputs we want to use for the messages that we should be PickList-ing*)
	inputsToUse=If[MatchQ[myProductsOrModels, {Null..}],
		myExistingInventories,
		myProductsOrModels
	];


	(* -- Site errors -- *)

	(* throw an error for missing (unresolvable) site *)
	noSiteOptions=If[MemberQ[noSiteQs, True]&&messages,
		(
			Message[Error::InventorySiteNotResolved, ToString[PickList[inputsToUse, noSiteQs]]];
			{Site}
		),
		{}
	];
	(* throw an error for invalid site *)
	invalidSiteOptions=If[MemberQ[invalidSiteQs, True]&&messages,
		(
			Message[Error::InvalidInventorySite, ToString[PickList[inputsToUse, invalidSiteQs]], ToString[PickList[resolvedSite, invalidSiteQs]]];
			{Site}
		),
		{}
	];
	(* throw a message for missing (unresolvable) site *)
	badAllSiteOptions=If[MemberQ[existingInventoryToAllQs, True]&&messages,
		(
			Message[Error::IndividualSiteRequired, ToString[PickList[inputsToUse, existingInventoryToAllQs]]];
			{Site}
		),
		{}
	];

	(* Also throw an error for switching sites *)
	invalidSiteChangeOptions = If[MemberQ[siteChangeQs, True]&&messages,
		(
			Message[Error::InventorySiteCannotBeChanged, ToString[PickList[inputsToUse, siteChangeQs]], ToString[PickList[resolvedSite, siteChangeQs]]];
			{Site}
		),
		{}
	];

	(* generate NoSite tests*)
	noSiteTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, noSiteQs];
			passingInputs=PickList[inputsToUse, noSiteQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", a valid Site could be determined:", False, True],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", a valid Site could be determined:", True, True],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}
		]
	];
	(* generate NoSite tests*)
	invalidSiteTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, invalidSiteQs];
			passingInputs=PickList[inputsToUse, invalidSiteQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", a Site was provided or resolved that is consistent with the ownership for the inventory object:", False, True],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", a Site was provided or resolved that is consistent with the ownership for the inventory object:", True, True],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}
		]
	];
	(* generate badAllSiteOptions tests*)
	badAllSiteTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, existingInventoryToAllQs];
			passingInputs=PickList[inputsToUse, existingInventoryToAllQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", a single inventory object was not specified for multiple sites:", False, True],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", a single inventory object was not specified for multiple sites:", True, True],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}
		]
	];


	(* -- invalid model stocked -- *)

	(* throw a message if ModelStocked is specified but needs to be Null *)
	modelStockedNotNullInvalidOptions=If[MemberQ[modelStockedNotNullInvalidQs, True] && messages,
		(
			Message[Error::ModelStockedRequired, ToString[PickList[inputsToUse, modelStockedNotNullInvalidQs]]];
			{ModelStocked}
		),
		{}
	];

	(* generate the ModelStockedRequired tests *)
	modelStockedNotNullInvalidTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, modelStockedNotNullInvalidQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, modelStockedNotNullInvalidQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", ModelStocked is Null if and only if the inventory is stocking a stock solution:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", ModelStocked is Null if and only if the inventory is stocking a stock solution:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* throw a message if ModelStocked is set to a model that is not supplied by that product*)
	modelStockedNotAllowedOptions=If[MemberQ[modelStockedNotAllowedQs, True] && messages,
		(
			Message[Error::ModelStockedNotAllowed, ToString[PickList[inputsToUse, modelStockedNotAllowedQs]], ToString[PickList[resolvedModelStocked, modelStockedNotAllowedQs]]];
			{ModelStocked}
		),
		{}
	];

	(* generate ModelStockedNotAllowed tests*)
	modelStockedNotAllowedTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, modelStockedNotAllowedQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, modelStockedNotAllowedQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", ModelStocked is set to a model that is supplied by the specified inventories or product:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", ModelStocked is set to a model that is supplied by the specified inventories or product:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* -- Invalid Stocking Method -- *)

	(* throw a message if ModelStocked is set to a model that is not supplied by that product*)
	stockingMethodInvalidOptions=Which[
		And[MemberQ[stockingMethodInvalidQs, True], messages],
		(
			Message[Error::StockingMethodInvalid, ToString[PickList[inputsToUse, stockingMethodInvalidQs]]];
			{StockingMethod, ReorderThreshold, ReorderAmount}
		),
		And[MemberQ[stockingMethodInvalidThresholdQs, True], messages],
		(
			Message[Error::InvalidReorderAmount];
			{ReorderAmount}
		),
		True, {}
	];

	(* generate StockingMethodInvalid tests*)
	stockingMethodInvalidTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, stockingMethodInvalidQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, stockingMethodInvalidQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", if StockingMethod is set to NumberOfStockedContainers, ReorderThreshold and ReorderAmount are set to integer values: ",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", if StockingMethod is set to NumberOfStockedContainers, ReorderThreshold and ReorderAmount are set to integer values: ",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* generate InvalidReorderAmount tests*)
	invalidReorderAmountTests = If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs = PickList[inputsToUse, stockingMethodInvalidThresholdQs];

			(* get the inputs that pass this test *)
			passingInputs = PickList[inputsToUse, stockingMethodInvalidThresholdQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests = If[Length[failingInputs] > 0,
				Test["ReorderAmount is in integer units for the following products/product inventories: " <> ToString[failingInputs] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests = If[Length[passingInputs] > 0,
				Test["ReorderAmount is in integer units for the following products/product inventories: " <> ToString[failingInputs] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* -- ReorderAmount change warning -- *)
	(* throw a warning if ReorderAmount was automatically changed for an existing inventory *)
	If[MemberQ[reorderAmountChangeQs, True] && messages,
		Message[
			Warning::ReorderAmountUpdated,
			ToString[PickList[inputsToUse, reorderAmountChangeQs]],
			ToString[Lookup[PickList[existingInventoryPackets, reorderAmountChangeQs], ReorderAmount]],
			ToString[PickList[resolvedReorderThreshold, reorderAmountChangeQs]]
		];
	];

	(* generate ReorderAmountUpdated tests*)
	reorderAmountModificationTests = If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs = PickList[inputsToUse, reorderAmountChangeQs];

			(* get the inputs that pass this test *)
			passingInputs = PickList[inputsToUse, reorderAmountChangeQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests = If[Length[failingInputs] > 0,
				Test["For the following inputs, ReorderAmount is either an integer (for Object[Inventory, Product]) or greater than or equal to ReorderThreshold (for Object[Inventory, StockSolution]): " <> ToString[failingInputs] <> ":",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests = If[Length[passingInputs] > 0,
				Test["For the following inputs, ReorderAmount is either an integer (for Object[Inventory, Product]) or greater than or equal to ReorderThreshold (for Object[Inventory, StockSolution]): " <> ToString[passingInputs] <> ":",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}
		]
	];

	(* -- ReorderThreshold/Amount unit-state mismatch -- *)
	(* throw a message if ReorderThreshold/ReorderAmount states are mismatched *)
	reorderStateMismatchOptions=If[MemberQ[reorderStateMismatchQs, True] && messages,
		(
			Message[Error::ReorderStateMismatch, ToString[PickList[inputsToUse, reorderStateMismatchQs]], ToString[PickList[resolvedState, reorderStateMismatchQs]]];
			{ModelStocked, ReorderThreshold, ReorderAmount}
		),
		{}
	];

	(* generate ReorderStateMismatch tests*)
	reorderStateMismatchTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, reorderStateMismatchQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, reorderStateMismatchQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", the state of the sample to be stocked matches the units of the ReorderThreshold and ReorderAmount options:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", the state of the sample to be stocked matches the units of the ReorderThreshold and ReorderAmount options:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* throw a message if ReorderAmount is less than ReorderThreshold *)
	reorderAmountOptions = If[MemberQ[lowReorderAmountQs, True] && messages,
		(
			Message[Error::LowReorderAmount, ToString[PickList[resolvedReorderAmount, lowReorderAmountQs]], ToString[PickList[resolvedReorderThreshold, lowReorderAmountQs]], ECL`InternalUpload`ObjectToString[PickList[inputsToUse, lowReorderAmountQs]]];
			{ReorderThreshold, ReorderAmount}
		),
		{}
	];

	(* generate ReorderStateMismatch tests*)
	reorderAmountTests = If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs = PickList[inputsToUse, lowReorderAmountQs];

			(* get the inputs that pass this test *)
			passingInputs = PickList[inputsToUse, lowReorderAmountQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests = If[Length[failingInputs] > 0,
				Test["For the provided inputs " <> ToString[failingInputs] <> ", the specified ReorderAmount is equal to or greater than the specified ReorderThreshold:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests = If[Length[passingInputs] > 0,
				Test["For the provided inputs " <> ToString[passingInputs] <> ", the specified ReorderAmount is equal to or greater than the specified ReorderThreshold:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* -- Invalid expiration -- *)

	(* throw a message if the Expiration options don't agree with themselves *)
	expiresShelfLifeMismatchOptions=If[MemberQ[expiresShelfLifeMismatchQs, True] && messages,
		(
			Message[Error::ExpirationDateMismatch, ToString[PickList[inputsToUse, expiresShelfLifeMismatchQs]]];
			{Expires, ShelfLife, UnsealedShelfLife}
		),
		{}
	];

	(* generate ExpirationDateMismatch tests*)
	expiresShelfLifeMismatchTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, expiresShelfLifeMismatchQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, expiresShelfLifeMismatchQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", the Expires, ShelfLife, and UnsealedShelfLife options are compatible with each other:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", the Expires, ShelfLife, and UnsealedShelfLife options are compatible with each other:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* -- Invalid MaxNumberOfUses -- *)

	(* throw a message if MaxNumberOfUses is set for a type that doesn't have it*)
	maxNumUsesInvalidOptions=If[MemberQ[maxNumUsesInvalidQs, True] && messages,
		(
			Message[Error::MaxNumberOfUsesInvalid, ToString[PickList[inputsToUse, maxNumUsesInvalidQs]]];
			{MaxNumberOfUses}
		),
		{}
	];

	(* generate MaxNumberOfUsesInvalid tests*)
	maxNumUsesInvalidTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, maxNumUsesInvalidQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, maxNumUsesInvalidQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", MaxNumberOfUses is specified if and only if MaxNumberOfUses exists in the specified ModelStocked:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", MaxNumberOfUses is specified if and only if MaxNumberOfUses exists in the specified ModelStocked:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];

	(* -- Invalid MaxNumberOfHours -- *)

	(* throw a message if MaxNumberOfHours is set for a type that doesn't have it*)
	maxNumHoursInvalidOptions=If[MemberQ[maxNumHoursInvalidQs, True] && messages,
		(
			Message[Error::MaxNumberOfHoursInvalid, ToString[PickList[inputsToUse, maxNumHoursInvalidQs]]];
			{MaxNumberOfHours}
		),
		{}
	];

	(* generate MaxNumberOfHoursInvalid tests*)
	maxNumHoursInvalidTests=If[gatherTests,
		Module[{failingInputs, passingInputs, failingInputTests, passingInputTests},

			(* get the inputs that fail this test *)
			failingInputs=PickList[inputsToUse, maxNumHoursInvalidQs];

			(* get the inputs that pass this test *)
			passingInputs=PickList[inputsToUse, maxNumHoursInvalidQs, False];

			(* create a test for the non-passing inputs *)
			failingInputTests=If[Length[failingInputs] > 0,
				Test["For the provided inputs "<>ToString[failingInputs]<>", MaxNumberOfHours is specified if and only if MaxNumberOfHours exists in the specified ModelStocked:",
					False,
					True
				],
				Nothing
			];

			(* create a test for the passing inputs *)
			passingInputTests=If[Length[passingInputs] > 0,
				Test["For the provided inputs "<>ToString[passingInputs]<>", MaxNumberOfHours is specified if and only if MaxNumberOfHours exists in the specified ModelStocked:",
					True,
					True
				],
				Nothing
			];

			(* return the created tests *)
			{passingInputTests, failingInputTests}

		]
	];


	(* --------------- *)
	(* --- Clean up ---*)
	(* --------------- *)

	(* combine all the invalid options*)
	invalidOptions=DeleteDuplicates[Flatten[{
		modelStockedNotNullInvalidOptions,
		modelStockedNotAllowedOptions,
		stockingMethodInvalidOptions,
		reorderStateMismatchOptions,
		reorderAmountOptions,
		expiresShelfLifeMismatchOptions,
		maxNumUsesInvalidOptions,
		maxNumHoursInvalidOptions,
		noSiteOptions,
		invalidSiteOptions,
		badAllSiteOptions,
		invalidSiteChangeOptions
	}]];

	(* throw the InvalidOption error if necessary *)
	If[Not[MatchQ[invalidOptions, {}]] && messages,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* gather all the tests together *)
	allTests=Cases[Flatten[{
		productModelDeprecatedTests,
		authorTests,
		modelStockedNotNullInvalidTests,
		modelStockedNotAllowedTests,
		stockingMethodInvalidTests,
		invalidReorderAmountTests,
		reorderAmountModificationTests,
		reorderStateMismatchTests,
		reorderAmountTests,
		expiresShelfLifeMismatchTests,
		maxNumUsesInvalidTests,
		maxNumHoursInvalidTests,
		noSiteTests,
		invalidSiteTests,
		badAllSiteTests
	}], _EmeraldTest];

	(* combine all the resolved options*)
	resolvedOptions={
		ModelStocked -> resolvedModelStocked,
		Status -> resolvedStatus,
		Site -> resolvedSite,
		StockingMethod -> resolvedStockingMethod,
		ReorderThreshold -> resolvedReorderThreshold,
		ReorderAmount -> resolvedReorderAmount,
		Expires -> resolvedExpires,
		ShelfLife -> resolvedShelfLife,
		UnsealedShelfLife -> resolvedUnsealedShelfLife,
		MaxNumberOfUses -> resolvedMaxNumberOfUses,
		MaxNumberOfHours -> resolvedMaxNumberOfHours,
		Name -> resolvedName,
		Upload -> Lookup[myOptions, Upload],
		Cache -> cache,
		Output -> Lookup[myOptions, Output],
		Notebook -> resolvedNotebook
	};

	(* generate the tests rule *)
	testsRule=Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just Null *)
	resultRule=Result -> If[MemberQ[output, Result],
		resolvedOptions,
		Null
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
];


(* ::Subsubsection::Closed:: *)
(*UploadInventoryOptions*)

DefineOptions[UploadInventoryOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadInventory}
];

(* existing inventory overload*)
UploadInventoryOptions[myExistingInventory:ObjectP[Object[Inventory]], myOptions:OptionsPattern[UploadInventoryOptions]]:=UploadInventoryOptions[{myExistingInventory}, myOptions];
UploadInventoryOptions[myExistingInventories:{ObjectP[Object[Inventory]]..}, myOptions:OptionsPattern[UploadInventoryOptions]]:=Module[
	{listedOptions, optionsWithoutOutput, resolvedOptions, resolvedOptionsWithNotebook},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadInventory options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved options *)
	resolvedOptionsWithNotebook=UploadInventory[myExistingInventories, Append[optionsWithoutOutput, Output -> Options]];

	(* since Notebook is not an option, LegacySLL`Private`optionsToTable throws an error. so remove the Notebook from resolved options *)
	resolvedOptions = Normal[KeyDrop[resolvedOptionsWithNotebook, Notebook]];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions, $Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
			LegacySLL`Private`optionsToTable[resolvedOptions, UploadInventory],
			resolvedOptions
		]
	]
];

(* new product or model overload *)
UploadInventoryOptions[myProductOrModel:ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}], myOptions:OptionsPattern[UploadInventoryOptions]]:=UploadInventoryOptions[{myProductOrModel}, myOptions];
UploadInventoryOptions[myProductsOrModels:{ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]..}, myOptions:OptionsPattern[UploadInventoryOptions]]:=Module[
	{listedOptions, optionsWithoutOutput, resolvedOptions, resolvedOptionsWithNotebook},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadInventory options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _)];

	(* add back in explicitly just the Options Output option for passing to core function to get just resolved options *)
	resolvedOptionsWithNotebook=UploadInventory[myProductsOrModels, Append[optionsWithoutOutput, Output -> Options]];

	(* since Notebook is not an option, LegacySLL`Private`optionsToTable throws an error. so remove the Notebook from resolved options *)
	resolvedOptions = Normal[KeyDrop[resolvedOptionsWithNotebook, Notebook]];

	(* Return the option as a list or table; OutputFormat may be legit missing, so just default weirdly to Table;
	 	also handle that we might have a $Failed result if SafeOptions failed *)
	If[MatchQ[resolvedOptions, $Failed],
		$Failed,
		If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
			LegacySLL`Private`optionsToTable[resolvedOptions, UploadInventory],
			resolvedOptions
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadInventoryQ*)


DefineOptions[ValidUploadInventoryQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadInventory}
];


(* Overload 1 - Existing inventory *)
ValidUploadInventoryQ[myExistingInventory:ObjectP[Object[Inventory]], myOptions:OptionsPattern[ValidUploadInventoryQ]]:=ValidUploadInventoryQ[{myExistingInventory}, myOptions];
ValidUploadInventoryQ[myExistingInventories:{ObjectP[Object[Inventory]]..}, myOptions:OptionsPattern[ValidUploadInventoryQ]]:=Module[
	{listedOptions, optionsWithoutOutput, tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadInventory options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests=UploadInventory[myExistingInventories, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadInventoryQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadInventoryQ"]

];

(* Overload 2 - New inventory *)
ValidUploadInventoryQ[myProductsOrModel:ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}], myOptions:OptionsPattern[ValidUploadInventoryQ]]:=ValidUploadInventoryQ[{myProductsOrModel}, myOptions];
ValidUploadInventoryQ[myProductsOrModels:{ObjectP[{Model[Sample, StockSolution], Model[Sample, Media], Model[Sample, Matrix], Object[Product]}]..}, myOptions:OptionsPattern[ValidUploadInventoryQ]]:=Module[
	{listedOptions, optionsWithoutOutput, tests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* since Output option is in UploadInventory options, we want to ignore that if present somehow *)
	optionsWithoutOutput=DeleteCases[listedOptions, (OutputFormat -> _) | (Output -> _) | (Verbose -> _)];

	(* add back in explicitly just the Tests Output option for passing to core function to get just tests *)
	tests=UploadInventory[myProductsOrModels, Append[optionsWithoutOutput, Output -> Tests]];

	(* determine the Verbose and OutputFormat options *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadInventoryQ" -> tests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadInventoryQ"]

];



(* ::Subsection::Closed:: *)
(*UploadCompanySupplier*)


(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineOptions[UploadCompanySupplier,
	Options :> {
		{
			OptionName -> Phone,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> PhoneNumberP, Size -> Line, PatternTooltip -> "In the format XXX-XXX-XXXX where X is a number between 0-9."],
			Description -> "The company's primary phone line.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> Website,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> URLP, Size -> Line, PatternTooltip -> "In the format of a valid web address that can include or exclude http://."],
			Description -> "The company's website URL.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> OutOfBusiness,
			Default -> False,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if the company is no longer operational.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> Status,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> SupplierStatusP],
			Description -> "The company's current status.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> AccountTransfer,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Company, Supplier]]],
			Description -> "The company which now acts as the supplier for this company as a result of a merger or acquisition or other transfer process.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> NewDispute,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Expression, Pattern :> {_DateObject, DisputeStatusP, DisputeP, _String}, Size -> Line],
			Description -> "A new conflict made with this supplier.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ModifiedDisputes,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> Expression, Pattern :> {_DateObject, DisputeStatusP, DisputeP, _String}, Size -> Line]],
			Description -> "All conflicts made with this supplier.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ActiveSupplierQualityAgreement,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Description -> "Indicates if there exists an active agreement with this supplier regarding quality of their products.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> SupplierQualityAgreements,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]],
			Description -> "Any active quality agreement documents.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactStatus,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> UserStatusP, Size -> Line]],
			Description -> "The contact's current status.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactRole,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> SupplierRoleP, Size -> Line]],
			Description -> "The role of a contact in a supplier's organization.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactServicedSite,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> _Link, Size -> Line]],
			Description -> "The site where a contact serves his duties.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactEmail,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> EmailP, Size -> Line]],
			Description -> "The contact's current email.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactPhone,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> PhoneP, Size -> Line]],
			Description -> "The contact's current phone number.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactFirstName,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
			Description -> "The contact's first name.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> ContactLastName,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
			Description -> "The contact's last name.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> Orders,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Transaction, Order]]]],
			Description -> "A list of order transactions placed with the supplier company.",
			Category -> "Order Activity"
		},
		{
			OptionName -> Receipts,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Report, Receipt]]]],
			Description -> "A list of receipt reports for orders placed with the supplier company.",
			Category -> "Order Activity"
		},
		{
			OptionName -> Products,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[Product]]]],
			Description -> "Products offered by this supplier.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> InstrumentsManufactured,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Model[Instrument]]]],
			Description -> "Instruments manufactured by this supplier.",
			Category -> "Product Specifications"
		},
		{
			OptionName -> SensorsManufactured,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Model[Sensor]]]],
			Description -> "Sensors manufactured by this supplier.",
			Category -> "Product Specifications"
		},
		UploadOption,
		OutputOption
	}
];


(* ::Subsubsection:: *)
(*Code*)


(* ::Subsubsection::Closed:: *)
(*resolveUploadCompanySupplierOptions*)


UploadCompanySupplier::UnderspecifiedInformation="At least one of the fields {Phone, Website, OutOfBusiness} must not be Null. Please double check the values of these fields.";
UploadCompanySupplier::SupplierNameAlreadyExists="An Object[Company,Supplier] of the name `1` already exists.";
UploadCompanySupplier::ObjectDoesNotExist="A given object for option `1` does not exist in the database. Please check that all of the objects specified for Field `1` exist.";

(* Helper function to resolve the options to our function. *)
(* Takes in a list of inputs and a list of options, return a list of resolved options. *)
resolveUploadCompanySupplierOptions[myInput_, myOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, testsRule, resultRule, objectsToDownload, downloadedObjects, orderPositions, receiptPositions,
		productsPositions, instrumentsPositions, sensorPositions},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* If we have to return Tests from this function, gather up our list of tests. *)
	testsRule=Tests -> If[MemberQ[ToList[outputOption], Tests],
		(* We have to return Tests. Construct a list of Tests. *)
		{
			Test[
				"One of the fields - Phone, Website, OutOfBusiness - is not Null for this supplier:",
				SameQ[Union[{Phone, Website, OutOfBusiness} /. myOptions], {Null}],
				False
			],
			Test[
				"The name of the Supplier has not yet been used:",
				Or[MatchQ[myInput, ObjectP[]], SameQ[Quiet[Download[Object[Company, Supplier, myInput]]], $Failed]],
				True
			],
			Test[
				"All of the given objects in the Orders field exists, unless it is Null:",
				!SameQ[(Orders /. myOptions), Null] && MemberQ[Quiet[Download[(Orders /. myOptions)]], $Failed],
				False
			],
			Test[
				"All of the given objects in the Receipts field exists, unless it is Null:",
				!SameQ[(Receipts /. myOptions), Null] && MemberQ[Quiet[Download[(Receipts /. myOptions)]], $Failed],
				False
			],
			Test[
				"All of the given objects in the Products field exists, unless it is Null:",
				!SameQ[(Products /. myOptions), Null] && MemberQ[Quiet[Download[(Products /. myOptions)]], $Failed],
				False
			],
			Test[
				"All of the given objects in the InstrumentsManufactured field exists, unless it is Null:",
				!SameQ[(InstrumentsManufactured /. myOptions), Null] && MemberQ[Quiet[Download[(InstrumentsManufactured /. myOptions)]], $Failed],
				False
			],
			Test[
				"All of the given objects in the SensorsManufactured field exists, unless it is Null:",
				!SameQ[(SensorsManufactured /. myOptions), Null] && MemberQ[Quiet[Download[(SensorsManufactured /. myOptions)]], $Failed],
				False
			]
		},
		(* We don't have to return Tests. Return Null. *)
		Null
	];

	(* If we have to return Result from this function, compute our result. *)
	resultRule=Result -> If[MemberQ[ToList[outputOption], Result],
		(* We have to return the Result. Compute the Result. *)
		(* Check that one of {Phone, Website, OutOfBusiness} is not Null. *)
		If[SameQ[Union[{Phone, Website, OutOfBusiness} /. myOptions], {Null}],
			Message[UploadCompanySupplier::UnderspecifiedInformation];
			Message[Error::InvalidOption, {Phone, Website, OutOfBusiness}];
		];

		(* Create a download call. *)
		objectsToDownload=Join[
			If[MatchQ[myInput, ObjectP[]],
				{myInput},
				{Object[Company, Supplier, myInput]}
			],
			ToList[(Orders /. myOptions)],
			ToList[(Receipts /. myOptions)],
			ToList[(Products /. myOptions)],
			ToList[(InstrumentsManufactured /. myOptions)],
			ToList[(SensorsManufactured /. myOptions)]
		];
		downloadedObjects=Quiet[Download[objectsToDownload]];

		(* Check that the name of the supplier has not yet been used. *)
		If[!MatchQ[myInput, ObjectP[]] && !SameQ[First[downloadedObjects], $Failed],
			Message[UploadCompanySupplier::SupplierNameAlreadyExists, myInput];
			Message[Error::InvalidInput, "supplierName"];
		];

		(* Check that for all of the multiple options, they exist in the database. *)
		(* Check for Orders. *)
		If[!SameQ[(Orders /. myOptions), Null],
			(* Get the downloaded objects out of our packet. *)
			orderPositions=Flatten[Position[objectsToDownload, Alternatives @@ (ToList[Orders /. myOptions])]];
			If[MemberQ[downloadedObjects[[orderPositions]], $Failed],
				Message[UploadCompanySupplier::ObjectDoesNotExist, "Orders"];
				Message[Error::InvalidOption, Orders];
			];
		];

		(* Check for Receipts. *)
		If[!SameQ[(Receipts /. myOptions), Null],
			(* Get the downloaded objects out of our packet. *)
			receiptPositions=Flatten[Position[objectsToDownload, Alternatives @@ (ToList[Receipts /. myOptions])]];
			If[MemberQ[downloadedObjects[[receiptPositions]], $Failed],
				Message[UploadCompanySupplier::ObjectDoesNotExist, "Receipts"];
				Message[Error::InvalidOption, Receipts];
			];
		];

		(* Check for Products. *)
		If[!SameQ[(Products /. myOptions), Null],
			(* Get the downloaded objects out of our packet. *)
			productsPositions=Flatten[Position[objectsToDownload, Alternatives @@ (ToList[Products /. myOptions])]];
			If[MemberQ[downloadedObjects[[productsPositions]], $Failed],
				Message[UploadCompanySupplier::ObjectDoesNotExist, "Products"];
				Message[Error::InvalidOption, Products];
			];
		];

		(* Check for InstrumentsManufactured. *)
		If[!SameQ[(InstrumentsManufactured /. myOptions), Null],
			(* Get the downloaded objects out of our packet. *)
			instrumentsPositions=Flatten[Position[objectsToDownload, Alternatives @@ (ToList[InstrumentsManufactured /. myOptions])]];
			If[MemberQ[downloadedObjects[[instrumentsPositions]], $Failed],
				Message[UploadCompanySupplier::ObjectDoesNotExist, "InstrumentsManufactured"];
				Message[Error::InvalidOption, InstrumentsManufactured];
			];
		];

		(* Check for SensorsManufactured. *)
		If[!SameQ[(SensorsManufactured /. myOptions), Null],
			(* Get the downloaded objects out of our packet. *)
			sensorPositions=Flatten[Position[objectsToDownload, Alternatives @@ (ToList[SensorsManufactured /. myOptions])]];
			If[MemberQ[downloadedObjects[[sensorPositions]], $Failed],
				Message[UploadCompanySupplier::ObjectDoesNotExist, "SensorsManufactured"];
				Message[Error::InvalidOption, SensorsManufactured];
			];
		];

		(* There is no resolving to do here. *)
		myOptions,
		(* We don't have to return the Result. Return Null. *)
		Null
	];

	(* Return the output. *)
	outputOption /. {testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*Public Function*)


UploadCompanySupplier[myName:(_String | ObjectP[]), myOptions:OptionsPattern[UploadCompanySupplier]]:=Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, validLengths, validLengthTests,
		resolvedOptionsResult, optionsRule, previewRule, testsRule, resultRule, resolvedOptions, resolvedOptionsTests},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=SafeOptions[UploadCompanySupplier, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths, validLengthTests}=ValidInputLengthsQ[UploadCompanySupplier, {myName}, listedOptions, Output -> {Result, Tests}];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[Lookup[listedOptions, Output] /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[safeOptions, Output];
	output=ToList[outputSpecification];
	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call resolveUploadCompanySupplierOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions, resolvedOptionsTests}=If[gatherTests,
			resolveUploadCompanySupplierOptions[myName, safeOptions, Output -> {Result, Tests}],
			{resolveUploadCompanySupplierOptions[myName, safeOptions], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		RemoveHiddenOptions[UploadCompanySupplier, resolvedOptions],
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	(* There is no preview for this function. *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Join[safeOptionTests, validLengthTests, resolvedOptionsTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed],
		Module[{multipleFields, packet, packetWithMultipleFields,
			multipleOptionsAsLinks, expandToLength, resolvedContactEmail, contacts},

			(* Gather the values of the multiple fields. *)
			multipleFields=<|
				Orders -> (Orders /. resolvedOptions),
				Receipts -> (Receipts /. resolvedOptions),
				Products -> (Products /. resolvedOptions),
				InstrumentsManufactured -> (InstrumentsManufactured /. resolvedOptions),
				SensorsManufactured -> (SensorsManufactured /. resolvedOptions)
			|>;

			(* Convert each multiple field's option value into a link, iff it is not Null. *)
			multipleOptionsAsLinks=KeyValueMap[
				Function[{optionName, optionValue},
					If[SameQ[optionValue, Null],
						(* If the option is Null, don't do anything. *)
						Nothing,
						(* Otherwise, convert it into a Link based on the option name. *)
						Switch[optionName,
							Orders,
							Append[optionName] -> (Link[#, Supplier]&) /@ ToList[optionValue],
							Receipts,
							Append[optionName] -> (Link[#, Supplier]&) /@ ToList[optionValue],
							Products,
							Append[optionName] -> (Link[#, Supplier]&) /@ ToList[optionValue],
							InstrumentsManufactured,
							Append[optionName] -> (Link[#, Manufacturer]&) /@ ToList[optionValue],
							SensorsManufactured,
							Append[optionName] -> (Link[#, Manufacturer]&) /@ ToList[optionValue]
						]
					]
				],
				multipleFields
			];

			expandToLength[value:Except[_List], targetLength_Integer]:=Table[value, targetLength];
			expandToLength[value_, targetLength_Integer]:=value;

			resolvedContactEmail=Switch[ContactEmail /. resolvedOptions,
				Null,
				Null,
				_String,
				{ContactEmail /. resolvedOptions},
				_,
				ContactEmail /. resolvedOptions
			];

			contacts=If[!NullQ[resolvedContactEmail],
				MapThread[
					{
						Status -> #1,
						Role -> #2,
						ServicedSite -> Link[#3],
						Email -> #4,
						Phone -> #5,
						FirstName -> #6,
						LastName -> #7
					}&,
					{
						expandToLength[ContactStatus /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactRole /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactServicedSite /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactEmail /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactPhone /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactFirstName /. resolvedOptions, Length[resolvedContactEmail]],
						expandToLength[ContactLastName /. resolvedOptions, Length[resolvedContactEmail]]
					}
				],
				Null
			];

			(* Create the packet of this supplier. *)
			packet=<|
				Type -> Object[Company, Supplier],
				If[MatchQ[myName, _String],
					Name -> myName,
					Object -> myName
				],
				Phone -> (Phone /. resolvedOptions),
				Website -> (Website /. resolvedOptions),
				OutOfBusiness -> (OutOfBusiness /. resolvedOptions),
				If[!NullQ[Status /. resolvedOptions],
					Status -> (Status /. resolvedOptions),
					Nothing
				],
				If[!NullQ[AccountTransfer /. resolvedOptions],
					AccountTransfer -> Link[(AccountTransfer /. resolvedOptions)],
					Nothing
				],
				If[!NullQ[ActiveSupplierQualityAgreement /. resolvedOptions],
					ActiveSupplierQualityAgreement -> (ActiveSupplierQualityAgreement /. resolvedOptions),
					Nothing
				],
				If[!NullQ[SupplierQualityAgreements /. resolvedOptions],
					Append[SupplierQualityAgreements] -> Link[(SupplierQualityAgreements /. resolvedOptions)],
					Nothing
				],
				If[!NullQ[NewDispute /. resolvedOptions],
					Append[Disputes] -> (NewDispute /. resolvedOptions),
					Nothing
				],
				If[!NullQ[ModifiedDisputes /. resolvedOptions],
					Replace[Disputes] -> (ModifiedDisputes /. resolvedOptions),
					Nothing
				],
				If[!NullQ[contacts],
					Replace[EmployeeContacts] -> contacts,
					Nothing
				]
			|>;

			(* Add these fields to the packet. *)
			packetWithMultipleFields=Append[packet, multipleOptionsAsLinks];

			(* Upload if requested, returning object by name if specified *)
			If[Upload /. safeOptions,
				(* We were asked to upload this object. Upload it. Upload returns the object type and ID. *)
				Upload[packetWithMultipleFields],
				(* We were asked to not upload this object. Simply return its packet. *)
				packetWithMultipleFields
			]
		],
		Null
	];
	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*Valid Function*)


DefineOptions[ValidUploadCompanySupplierQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadCompanySupplier}
];


ValidUploadCompanySupplierQ[myInput_, myOptions:OptionsPattern[]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadCompanySupplier[myInput, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadCompanySupplierQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadCompanySupplierQ"]
];


(* ::Subsubsection::Closed:: *)
(*Option Function*)


DefineOptions[UploadCompanySupplierOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadCompanySupplier}
];


UploadCompanySupplierOptions[myInput:_, myOptions:OptionsPattern[]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[SafeOptions[UploadCompanySupplierOptions, listedOps], (OutputFormat -> _) | (Output -> _)];

	options=UploadCompanySupplier[myInput, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadCompanySupplier],
		options
	]

];


(* ::Subsection::Closed:: *)
(*UploadCompanyService*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadCompanyService,
	Options :> {
		{
			OptionName -> Phone,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> PhoneNumberP,
				Size -> Line,
				PatternTooltip -> "In the format XXX-XXX-XXXX where X is a number between 0-9."
			],
			Description -> "The company's primary phone line.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> Website,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Line,
				PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
			],
			Description -> "The company's website URL.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> OutOfBusiness,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the company is no longer operational.",
			Category -> "Organizational Information"
		},
		{
			OptionName -> CustomSynthesizes,
			Default -> Null,
			AllowNull -> True,
			Description -> "Custom models of samples that this company synthesized for users.",
			Category -> "Organizational Information",
			Widget -> Adder[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Sample]]
				]
			]
		},
		{
			OptionName -> PreferredContainers,
			Default -> Null,
			AllowNull -> True,
			Description -> "Known container models that this company tends to ship the samples they supply in.",
			Category -> "Organizational Information",
			Widget -> Adder[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Model[Container]]
				]
			]
		},
		UploadOption,
		OutputOption
	}
];


Error::CompanyNameAlreadyExists="An Object[Company,Service] of the Name: `1` already exists. Please consider use the existing company object, or create a new company object with an alternative name.";
Error::UnderspecifiedInformation="Phone: `1` or Website: `2` of the company must be provided. Please check the values of these options and specify one of these options.";
Error::ObjectDoesNotExist="The following object(s): `1` does not exist in the database. Please run DatabaseMemberQ on the object and consider provide another existing object.";


(* ::Subsubsection::Closed:: *)
(*UploadCompanyService*)


UploadCompanyService[myName_String, myOps:OptionsPattern[UploadCompanyService]]:=Module[
	{
		listedOps, safeOps, safeOptionTests, validLengths, validLengthTests, outputSpecification, output, gatherTestsQ, resolvedOps,
		resolvedOptionsTests, resolvedOptionsResult, result, userSpecifiedResolvedOps, allTests
	},

	(* get listed options *)
	listedOps=ToList[myOps];

	(* get SafeOptions *)
	{safeOps, safeOptionTests}=SafeOptions[UploadCompanyService, listedOps, Output -> {Result, Tests}, AutoCorrect -> False];

	(* check whether all options are the right length *)
	{validLengths, validLengthTests}=ValidInputLengthsQ[UploadCompanySupplier, {myName}, listedOps, Output -> {Result, Tests}];

	(* determine the requested return value from the function *)
	outputSpecification=Lookup[safeOps, Output];
	output=ToList[outputSpecification];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* check whether we should return Tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* get resolved options *)
	(* note: if all the specified options are valid, will return the given options *)
	resolvedOptionsResult=Check[
		{resolvedOps, resolvedOptionsTests}=If[gatherTestsQ,
			resolveUploadCompanyServiceOptions[myName, safeOps, Output -> {Result, Tests}],
			{resolveUploadCompanyServiceOptions[myName, safeOps, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* get the result *)
	(* note: if something went wrong during option resolving, resolvedOps = $Failed *)
	result=If[And[MemberQ[output, Result], !MatchQ[resolvedOptionsResult, $Failed]],
		Module[{companyObj, companyPkt},

			(* create an ID for Object[Company,Service] *)
			companyObj=CreateID[Object[Company, Service]];

			(* get upload packet *)
			companyPkt=<|
				Object -> companyObj,
				Type -> Object[Company, Service],
				Name -> myName,
				Phone -> Lookup[resolvedOps, Phone],
				Website -> Lookup[resolvedOps, Website],
				OutOfBusiness -> Lookup[resolvedOps, OutOfBusiness],
				Replace[CustomSynthesizes] -> Link[Lookup[resolvedOps, CustomSynthesizes], ServiceProviders],
				Replace[PreferredContainers] -> Link[Lookup[resolvedOps, PreferredContainers], ServiceProviders]
			|>;

			(* upload the packet if Upload->True *)
			If[TrueQ[Lookup[resolvedOps, Upload]],
				Upload[companyPkt],
				companyPkt
			]
		],
		$Failed
	];

	(* get output options, i.e. remove the hidden options *)
	userSpecifiedResolvedOps=RemoveHiddenOptions[UploadCompanyService, resolvedOps];

	(* combine all the tests *)
	allTests=Join[safeOptionTests, validLengthTests, resolvedOptionsTests];

	(* output *)
	outputSpecification /. {Preview -> Null, Options -> userSpecifiedResolvedOps, Result -> result, Tests -> allTests}

];


(* ::Subsubsection::Closed:: *)
(*resolveUploadCompanyServiceOptions*)


resolveUploadCompanyServiceOptions[
	myName_String,
	myOps:OptionsPattern[UploadCompanyService],
	myOutputOps:(Output -> CommandBuilderOutputP) | (Output -> {CommandBuilderOutputP ..})]:=Module[
	{listedOps, listedOutputOps, gatherTestsQ, tests, phone, website, outOfBusiness, customSynthesizes, result, preferredContainers},

	(* convert the options into a list *)
	listedOps=ToList[myOps];
	listedOutputOps=ToList[myOutputOps];

	(* get option values *)
	{phone, website, outOfBusiness, customSynthesizes, preferredContainers}=Lookup[listedOps, {Phone, Website, OutOfBusiness, CustomSynthesizes, PreferredContainers}];

	(* check whether we are collecting tests *)
	gatherTestsQ=MemberQ[Lookup[listedOutputOps, Output], Tests];

	{tests, result}=Module[{allTests,
		(* Messages Bools *)
		nameMsgBool, informationBool, chemicalModelBool,
		(* Tests *)
		nameTest, informationTest, chemicalModelTest
		, containerModelBool, containerModelTest},

		(* --- Name Option: check whether the name has been taken --- *)
		nameMsgBool=MatchQ[Search[Object[Company, Service], Name == myName], {}];

		If[!TrueQ[gatherTestsQ],
			If[!TrueQ[nameMsgBool],
				(
					Message[Error::CompanyNameAlreadyExists, myName];
					Message[Error::InvalidInput, Name]
				)
			]
		];

		nameTest=Test["The name of the Company has not yet been used:",
			nameMsgBool,
			True
		];

		(* --- Phone and Website Option: Phone or Website should be provided if the company is valid --- *)
		(* note: OutOfBusinese -> False should be rare when calling the upload function *)
		informationBool=If[MatchQ[outOfBusiness, False],
			True,
			Or[!NullQ[phone], !NullQ[website]]
		];

		If[!TrueQ[gatherTestsQ],
			If[!TrueQ[informationBool],
				(
					Message[Error::UnderspecifiedInformation, phone, website];
					Message[Error::InvalidOption, {Phone, Website}];
				)
			]
		];

		informationTest=Test["Phone or Website of the Company is provided:",
			informationBool,
			True
		];

		(* --- CustomSynthesizes Option: the provided custom synthesized chemical model(s) exists --- *)
		chemicalModelBool=If[MatchQ[customSynthesizes, {}],
			True,
			!MemberQ[DatabaseMemberQ[customSynthesizes], False]
		];

		If[!TrueQ[gatherTestsQ],
			If[!TrueQ[chemicalModelBool],
				(
					Message[Error::ObjectDoesNotExist, PickList[customSynthesizes, DatabaseMemberQ[customSynthesizes], False]];
					Message[Error::InvalidOption, CustomSynthesizes]
				)
			]
		];

		chemicalModelTest=Test["The provided custom synthesized chemical model(s) exists in the database:",
			chemicalModelBool,
			True
		];

		(* --- PreferredContainers Option: the provided container model(s) exists --- *)
		containerModelBool=If[MatchQ[preferredContainers, {}],
			True,
			!MemberQ[DatabaseMemberQ[preferredContainers], False]
		];

		If[!TrueQ[gatherTestsQ],
			If[!TrueQ[containerModelBool],
				(
					Message[Error::ObjectDoesNotExist, PickList[preferredContainers, DatabaseMemberQ[preferredContainers], False]];
					Message[Error::InvalidOption, PreferredContainers]
				)
			]
		];

		containerModelTest=Test["The provided container model(s) exists in the database:",
			containerModelBool,
			True
		];

		(* output all the tests *)
		allTests={nameTest, informationTest, chemicalModelTest, containerModelTest};

		{allTests, listedOps}

	];


	(* return the output *)
	Lookup[myOutputOps, Output] /. {Tests -> tests, Result -> result}

];


(* ::Subsubsection::Closed:: *)
(*UploadCompanyServiceOptions*)


DefineOptions[UploadCompanyServiceOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadCompanyService}
];


UploadCompanyServiceOptions[myName_String, myOpts:OptionsPattern[UploadCompanyServiceOptions]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOpts];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadCompanyService[myName, Join[outOps, {Output -> Options}]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadCompanyService],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*ValidUploadCompanyServiceQ*)


DefineOptions[ValidUploadCompanyServiceQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadCompanyService}
];


ValidUploadCompanyServiceQ[myName_String, myOpts:OptionsPattern[ValidUploadCompanyServiceQ]]:=Module[
	{listedOps, preparedOptions, returnTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOps=ToList[myOpts];

	(* remove the Output, Verbose option before passing to the core function *)
	preparedOptions=DeleteCases[listedOps, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for StoreSamples *)
	returnTests=UploadCompanyService[myName, Join[preparedOptions, {Output -> Tests}]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[returnTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, returnTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadCompanyServiceQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadCompanyServiceQ"]


];


(* ::Subsection::Closed:: *)
(*UploadLiterature*)


(* ::Subsubsection::Closed:: *)
(*DefineOptions*)


DefineOptions[UploadLiterature,
	Options :> {
		{
			OptionName -> LiteratureFiles,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Line,
					PatternTooltip -> "A .pdf file (either a URL or a local file path) that is associated with this Object[Report, Literature] object such as article, supplementary information, etc."
				]
			],
			Description -> "A list of .pdf files (either a URL or a local file path) that is associated with this Object[Report, Literature] object such as article, supplementary information, etc.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Keywords,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word,
					PatternTooltip -> "The keywords that help users find this journal article."
				]
			],
			Description -> "Key descriptive words about this literature that have been manually assigned.",
			Category -> "Literature Information"
		},
		{
			OptionName -> DocumentType,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> DocumentTypeP],
			Description -> "The category of document to which this literature belongs.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Title,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The title of the piece of literature.", Size -> Line],
			Description -> "The title of the piece of literature.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Authors,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				Widget[Type -> String, Pattern :> _String, PatternTooltip -> "One of the names of the authors that wrote this piece of literature.", Size -> Line]
			],
			Description -> "The list of names of the authors of the literature.",
			Category -> "Literature Information"
		},
		{
			OptionName -> ContactInformation,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "Contact information for the corresponding author.", Size -> Line],
			Description -> "Contact information for the corresponding author.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Journal,
			Default -> Automatic,
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[Type -> Enumeration, Pattern :> JournalP],
				Widget[Type -> String, Pattern :> _String, Size -> Line, PatternTooltip -> "The Journal that this piece of literature was published in."]
			],
			Description -> "The title of the journal in which this PDF is found. If Automatic, it will Parse the journal name from the Pubmed citation and throw an error if the journal name does not match JournalP.  Otherwise, the user can set the journal name using this option.",
			Category -> "Literature Information"
		},
		{
			OptionName -> PublicationDate,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector -> False],
			Description -> "The date on which the literature was published.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Volume,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The journal volume in which this article appears.", Size -> Word],
			Description -> "The journal volume in which this article appears.",
			Category -> "Literature Information"
		},
		{
			OptionName -> StartPage,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The page on which the article begins.", Size -> Word],
			Description -> "The page on which the article begins.",
			Category -> "Literature Information"
		},
		{
			OptionName -> EndPage,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The page on which the article ends.", Size -> Word],
			Description -> "The page on which the article ends.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Issue,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The journal issue in which this document appears.", Size -> Word],
			Description -> "The journal issue in which this document appears.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Edition,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The edition of this document.", Size -> Word],
			Description -> "The edition of this document.",
			Category -> "Literature Information"
		},
		{
			OptionName -> ISSN,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> ISSNP, PatternTooltip -> "The international Standard Serial Number (ISSN) for this document.", Size -> Line],
			Description -> "The international Standard Serial Number (ISSN) for this document.",
			Category -> "Literature Information"
		},
		{
			OptionName -> ISSNType,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> ISSNTypeP],
			Description -> "The International Standard Serial Number (ISSN) type for this document.",
			Category -> "Literature Information"
		},
		{
			OptionName -> DOI,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
			Description -> "The digital Object Identifer (DOI) for this document.",
			Category -> "Literature Information"
		},
		{
			OptionName -> URL,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> URLP, Size -> Line],
			Description -> "The Uniform resource locator (URL) for where this document is published on the web.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Abstract,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, PatternTooltip -> "The abstract written by the authors of the literature and summarizing its contents.", Size -> Paragraph],
			Description -> "The abstract written by the authors of the literature and summarizing its contents.",
			Category -> "Literature Information"
		},
		{
			OptionName -> PubmedID,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> _String, Size -> Word],
			Description -> "The Pubmed Object for the document.",
			Category -> "Literature Information"
		},
		{
			OptionName -> References,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Model[]]]],
			Description -> "Any SLL objects that should point to this report[Literature] object as a Literature Reference.",
			Category -> "Literature Information"
		},
		{
			OptionName -> Automated,
			Default -> True,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[BooleanP]],
			Description -> "Specifies whether or not this Parse operation is being overseen by a human (Automated->False). If Automated->True, no dialog windows will be opened even if there is no Journal or Keyword match -- these Parse operations will return {}.",
			Category -> "Hidden"
		},
		UploadOption,
		OutputOption
	}
];


DefineOptions[resolvedUploadLiteratureOptions,
	SharedOptions :> {UploadLiterature}
];


(* ::Subsubsection::Closed:: *)
(*UploadLiterature*)


(* UploadLiterature[] overload *)
(* For some reason, without the Except[{Rule[_String,{_String...}]..}], it matches on EndNote inputs. *)
UploadLiterature[myOptions__:PatternUnion[OptionsPattern[UploadLiterature], Except[{Rule[_String, {_String...}]..}]]]:=UploadLiterature[Null, myOptions];


UploadLiterature[myInput:(PubMed[_Integer] | {Rule[_String, {_String...}]..} | XmlFileP | Null), myOptions:OptionsPattern[UploadLiterature]]:=Module[
	{listedOptions, rawOutputSpecification, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, resolvedOptionsResult,
		resolvedOptions, resolvedOptionsTests, previewRule, optionsRule, testsRule, resultRule, packetWithNulls, packet, packetWithLiteratureFiles},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	rawOutputSpecification=Lookup[listedOptions, Output];

	(* If Output wasn't specified explicitly, it will default to Output. We do this because SafeOptions isn't called yet. *)
	outputSpecification=If[MatchQ[Lookup[listedOptions, Output], _Missing],
		Result,
		rawOutputSpecification
	];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadLiterature, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadLiterature, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed (or the tests up to this point)  *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call resolve<Function>Options *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		(* Always gather tests since we want to check for object validity later. *)
		{resolvedOptions, resolvedOptionsTests}=resolvedUploadLiteratureOptions[myInput, safeOptions, Output -> {Result, Tests}],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		resolvedOptions,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Join[safeOptionTests, resolvedOptionsTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed],
		(* First, construct the packet from the resolved options. *)

		(* Throw all of the resolved options in first, including nulls. *)
		packetWithNulls=<|
			Type -> Object[Report, Literature],
			Title -> Lookup[resolvedOptions, Title],
			ContactInformation -> Lookup[resolvedOptions, ContactInformation],
			Journal -> Lookup[resolvedOptions, Journal],
			PublicationDate -> Lookup[resolvedOptions, PublicationDate],
			Volume -> Lookup[resolvedOptions, Volume],
			StartPage -> Lookup[resolvedOptions, StartPage],
			EndPage -> Lookup[resolvedOptions, EndPage],
			DocumentType -> Lookup[resolvedOptions, DocumentType],
			Issue -> Lookup[resolvedOptions, Issue],
			ISSN -> Lookup[resolvedOptions, ISSN],
			ISSNType -> Lookup[resolvedOptions, ISSNType],
			DOI -> Lookup[resolvedOptions, DOI],
			URL -> Lookup[resolvedOptions, URL],
			Abstract -> Lookup[resolvedOptions, Abstract],
			PubmedID -> Lookup[resolvedOptions, PubmedID],
			Append[Authors] -> Lookup[resolvedOptions, Authors],
			Append[References] -> If[SameQ[Lookup[resolvedOptions, References], Null],
				Null,
				(Link[#,LiteratureReferences]&)/@Lookup[resolvedOptions, References]
        ]
		|>;

		(* Filter out the nulls. *)
		packet=Association@KeyValueMap[
			Function[{key, value},
				If[SameQ[value, Null],
					Nothing,
					key -> value
				]
			],
			packetWithNulls
		];

		(* Append the literature files. *)
		packetWithLiteratureFiles=If[MatchQ[Lookup[resolvedOptions, LiteratureFiles, Null], Null | {}],
			(* There are no literature files. Do not append the Literature Files. *)
			packet,
			(* There are literature files, append them. *)
			Append[
				packet,
				Append[LiteratureFiles] -> (Link[UploadCloudFile[#]]& /@ Lookup[resolvedOptions, LiteratureFiles])
			]
		];

		(* Make sure that the object is valid before we allow an upload or return a packet. *)

		If[OptionValue[Upload],
			Upload[packetWithLiteratureFiles],
			packetWithLiteratureFiles
		],
		Null
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsection:: *)
(*resolvedUploadLiteratureOptions*)


(* ::Subsubsection::Closed:: *)
(*Tests and Messages*)


UploadLiterature::TitleCannotBeNull="The Title option cannot be Null. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::AuthorsCannotBeNull="The Authors option cannot be Null. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::PublicationDateCannotBeNull="The PublicationDate option cannot be Null. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::DocumentTypeCannotBeNull="The DocumentType option cannot be Null. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::EditionMustBeNull="The Edition option must be set to Null if the DocumentType is not a Book or Book Section. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::RequiredTogetherOptions="The following options {ContactInformation,Journal} are required together. Currently, the options `1` are set to Null. Please include non-Null values for all of these options or none of these options.";
UploadLiterature::NullJournalFields="If DocumentType is set to JournalArticle, the following fields {ContactInformation, Journal} must not be Null. Currently, the field(s) `1` are set to Null. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::FuturePublicationDate="PublicationDate must be set to a date in the past. It is currently set to `1`. Please change the value of this option in order to upload a valid Object[Report, Literature].";
UploadLiterature::InvalidPubmedID="The inputted PubmedID is invalid or does not exist. Please check your input.";

(* Given a set of options, generate tests for those options. *)
(* This code is put into a helper function because it is called from several resolve options overloads, depending on the type of input given. *)
generateTests[myOptions_]:=With[{packet=Append[Association[myOptions], Type -> Object[Report, Literature]]},
	Flatten@{
		(* unique fields not null *)
		ECL`NotNullFieldTest[packet, {
			Title,
			Authors,
			PublicationDate,
			DocumentType
		}],

		(* book editions *)
		Test[
			"If DocumentType is not Book or Book Section, Edition should be Null:",
			If[
				MatchQ[Lookup[packet, DocumentType], (Book | BookSection)],
				True,
				NullQ[Lookup[packet, Edition]]
			],
			True
		],

		(* scientific papers *)
		ECL`RequiredTogetherTest[packet, {ContactInformation, Journal}],

		(* if document type is JournalArticle, above Fields must be informed *)
		Test[
			"If DocumentType is JournalArticle, journal-related Fields must be informed:",
			If[MatchQ[Lookup[packet, DocumentType], JournalArticle],
				!MemberQ[Lookup[packet, {ContactInformation, Journal}], Null],
				True
			],
			True
		]
	}
];

(* Given a set of options, check them for validity. Throw messages if problems are found. *)
(* This code is put into a helper function because it is called from several resolve options overloads, depending on the type of input given. *)
checkOptionsForValidity[myOptions_]:=Module[
	{requiredTogetherOptions, nullOptions, journalFields, nullJournalFields},

	(* Title cannot be Null. *)
	If[SameQ[Lookup[myOptions, Title], Null],
		Message[UploadLiterature::TitleCannotBeNull];
		Message[Error::InvalidOption, "Title"];
	];

	(* Authors cannot be Null. *)
	If[SameQ[Lookup[myOptions, Authors], Null],
		Message[UploadLiterature::AuthorsCannotBeNull];
		Message[Error::InvalidOption, "Authors"];
	];

	(* PublicationDate cannot be Null. *)
	If[SameQ[Lookup[myOptions, PublicationDate], Null],
		Message[UploadLiterature::PublicationDateCannotBeNull];
		Message[Error::InvalidOption, "PublicationDate"];
	];

	(* DocumentType cannot be Null. *)
	If[SameQ[Lookup[myOptions, DocumentType], Null],
		Message[UploadLiterature::DocumentTypeCannotBeNull];
		Message[Error::InvalidOption, "DocumentType"];
	];

	(* If DocumentType is not Book or Book Section, Edition should be Null: *)
	If[!MatchQ[Lookup[myOptions, DocumentType], (Book | BookSection)] && !NullQ[Lookup[myOptions, Edition]],
		Message[UploadLiterature::EditionMustBeNull];
		Message[Error::InvalidOption, "Edition"];
	];

	(* The options {ContactInformation,Journal,Volume,StartPage,EndPage,PubmedID} are required together. None of them can be Null or all of them must be Null. *)
	requiredTogetherOptions=Lookup[myOptions, {ContactInformation, Journal}];
	If[!MatchQ[Length[Cases[requiredTogetherOptions, Null]], 0 | Length[requiredTogetherOptions]],
		(* Figure out the options that are set to Null. *)
		nullOptions=PickList[{ContactInformation, Journal}, NullQ /@ requiredTogetherOptions];

		(* Throw a message telling the user which options are Null. *)
		Message[UploadLiterature::RequiredTogetherOptions, ToString[nullOptions]];
		Message[Error::InvalidOption, ToString[nullOptions]];
	];

	(* If DocumentType is JournalArticle, journal-related Fields must be informed: *)
	If[MatchQ[Lookup[myOptions, DocumentType], JournalArticle],
		(* Lookup all of the journal-related fields. *)
		journalFields=Lookup[myOptions, {ContactInformation, Journal}];

		(* Figure out the options that are set to Null. *)
		nullJournalFields=PickList[{ContactInformation, Journal}, NullQ /@ journalFields];

		(* If there are Null journal fields, throw a message. *)
		If[Length[nullJournalFields] != 0,
			Message[UploadLiterature::NullJournalFields, ToString[nullJournalFields]];
			Message[Error::InvalidOption, ToString[nullJournalFields]];
		];
	];

	(* PublicationDate is in the past. *)
	If[!SameQ[Lookup[myOptions, PublicationDate], Null] && Lookup[myOptions, PublicationDate] > Now,
		Message[UploadLiterature::FuturePublicationDate, DateString[Lookup[myOptions, PublicationDate]]];
		Message[Error::InvalidOption, "PublicationDate"];
	];

];


(* ::Subsubsection::Closed:: *)
(*Nothing (UploadLiterature[])*)


resolvedUploadLiteratureOptions[myInput:Null, myOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, optionsWithoutAutomatic},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* Replace all Automatic options with Null. *)
	optionsWithoutAutomatic=myOptions /. {Automatic -> Null};

	(* Check the resolved options for validity and throw messages if they are not valid. *)
	checkOptionsForValidity[optionsWithoutAutomatic];

	(* Merge the options and return them. *)
	outputOption /. {Result -> optionsWithoutAutomatic, Tests -> generateTests[myOptions]}
];


(* ::Subsubsection::Closed:: *)
(*PubMed*)


(* ::Subsubsection:: *)
(*importPubMedResponse*)
(* helper to parse information from pubmed ID, we need to memoize to decrease number of trips to API calls for PubMed *)

(* Code below was tested with PubMed E-utilities API v16.6. For future maintainence, please check the latest API documentation. *)
(* Release Notes: https://www.ncbi.nlm.nih.gov/books/NBK564895/ *)
(* API Documentation: https://www.ncbi.nlm.nih.gov/books/NBK25501/ *)

importPubMedResponse[pubmedID:PubMed[_Integer?(GreaterQ[#1, 0] &)]] := Module[
	{response, validResponseQ},

	retryConnection[
		Module[{},
			(* import response from pubmed ID *)
			response = ManifoldEcho[
				Quiet[Import["https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&apiKey="<>Web`Private`$eUtilAPIKey<>"&id="<>ToString[FirstOrDefault[pubmedID]]<>"&retmode=xml", "TSV"]],
				"Import[\"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&apiKey="<>Web`Private`$eUtilAPIKey<>"&id="<>ToString[FirstOrDefault[pubmedID]]<>"&retmode=xml\", \"TSV\"]"
			];

			(* check if the response is valid that we get the information xml we want *)
			validResponseQ = Quiet[MatchQ[response[[3]], {"<PubmedArticleSet>"}] && MatchQ[response[[1]], {_?(StringContainsQ[#, "xml version"]&)}]];

			(* return $Failed until we get a valid response *)
			If[
				!validResponseQ,
				$Failed
			]
		],
		5
	];

	(* only memoize when we actually get a valid response *)
	If[validResponseQ,
		If[!MemberQ[$Memoization, ExternalUpload`Private`importPubMedResponse],
			AppendTo[$Memoization, ExternalUpload`Private`importPubMedResponse]
		];
		importPubMedResponse[pubmedID] = {response, validResponseQ}
	];

	(* return the raw response anyway *)
	{response, validResponseQ}
];


(* Resolve the UploadLiterature options from a PubMed ID. *)
(* PubMed API accepts negative integer and remove - symbol; it also accepts mixed Letters/Numbers and only take the first integer number as input, e.g. x1954y9891z will become 1954. To simplify, here only take positive integers as PubMed ID. *)
resolvedUploadLiteratureOptions[pubmedID:PubMed[_Integer?(GreaterQ[#1, 0] &)], myOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, validURLResponseQ, pubMedTest, xmlFile, validPubMedQ, website, rawJournal, journal, title, pages, abstract, affiliation, year, month, day, authorsLast, authorsFirst, rawKeywords, keywords, issnType, issn, vol, issue, doi, authorsNames, firstNamesWithPeriod, keywordsJoined,
		authors, parsedOptions, allOptions, manualOptions, finalizedOptions},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* Import the xml version of the citation from PubMed's website. *)
	{xmlFile, validURLResponseQ} = importPubMedResponse[pubmedID];

	(* If PubMed ID is invalid, a XML file will be returned with an empty <PubmedArticleSet></PubmedArticleSet> tag *)
	(* we quiet the message here b/c sometimes when api is down, xmlFile will not necessarily have a length of 3, in which case we still think it is more of an api issue instead of complaining about PubMed ID *)
	validPubMedQ = !Quiet[SameQ[xmlFile[[3]], {"<PubmedArticleSet></PubmedArticleSet>"}]];

	(* We only test that we were given a valid PubMed ID. Other than that, all information in the PubMed ID is assumed to be correct. *)
	pubMedTest=Test[
		"The given PubMed ID is valid:",
		validPubMedQ,
		True
	];

	(* If PubMed ID does not exist, throw message and return *)
	If[!validPubMedQ,
		Message[UploadLiterature::InvalidPubmedID];
		Message[Error::InvalidInput, ToString[pubmedID]]
	];

	(* No option resolving can be done if we are not getting a valid response. Just return the default options. *)
	If[!validURLResponseQ,
		Return[outputOption /. {Result -> myOptions, Tests -> Append[generateTests[myOptions], pubMedTest]}];
	];

	(* Parse together the website for the citation *)
	website="http://www.ncbi.nlm.nih.gov/pubmed/"<>ToString[FirstOrDefault[pubmedID]];

	(* pull out all that we can for the raw[PDF] object from the xml file *)
	rawJournal=If[MatchQ[( Journal /. myOptions), Automatic],
		FindJournal[FirstOrDefault[Flatten[StringCases[#, "<Title>"~~x__~~"</Title>" :> x]& /@ xmlFile]], ExactMatch -> ( Automated /. myOptions)],
		FindJournal[(Journal /. myOptions), ExactMatch -> (Automated /. myOptions)]
	];

	(* If the journal lookup failed, set it to Null. *)
	journal=If[MatchQ[rawJournal, $Failed],
		If[MatchQ[( Journal /. myOptions), Automatic],
			FirstOrDefault[Flatten[StringCases[#, "<Title>"~~x__~~"</Title>" :> x]& /@ xmlFile]],
			(Journal /. myOptions)
		],
		rawJournal
	];

	(* Parse out all the rest of the things *)
	title=Flatten[StringCases[#, "<ArticleTitle>"~~x__~~"</ArticleTitle>" :> x]& /@ xmlFile];
	pages=ToExpression /@ StringSplit[FirstOrDefault[Flatten[StringCases[#, "<MedlinePgn>"~~x__~~"</MedlinePgn>" :> x]& /@ xmlFile], ""], "-"];
	abstract=Flatten[StringCases[#, "<AbstractText>"~~x__~~"</AbstractText>" :> x]& /@ xmlFile];
	affiliation=Flatten[StringCases[#, "<Affiliation>"~~x__~~"</Affiliation>" :> x]& /@ xmlFile];
	year=FirstOrDefault[Flatten[StringCases[#, "<Year>"~~Shortest[x__]~~"</Year>" :> x]& /@ xmlFile]];
	month=FirstOrDefault[Flatten[StringCases[#, "<Month>"~~Shortest[x__]~~"</Month>" :> x]& /@ xmlFile]];
	day=FirstOrDefault[Flatten[StringCases[#, "<Day>"~~Shortest[x__]~~"</Day>" :> x]& /@ xmlFile]];
	authorsLast=Flatten[StringCases[#, "<LastName>"~~Shortest[x__]~~"</LastName>" :> x]& /@ xmlFile];
	authorsFirst=Flatten[StringCases[#, "<ForeName>"~~Shortest[x__]~~"</ForeName>" :> x]& /@ xmlFile];
	authorsNames=StringSplit[#, " "]& /@ authorsFirst;
	keywords=Flatten[StringCases[#, "<Keyword MajorTopicYN=\"N\">"~~x__~~"</Keyword>" :> x]& /@ xmlFile];
	{issnType, issn}=Module[{tempStrings},
		tempStrings=Flatten[StringCases[#, "<ISSN IssnType=\""~~x__~~"\">"~~y__~~"</ISSN>" :> {x, y}]& /@ xmlFile];

		If[Length[tempStrings]!=2,
			{Null, Null},
			tempStrings
		]
	];
	vol=Flatten[StringCases[#, "<Volume>"~~x__~~"</Volume>" :> x]& /@ xmlFile];
	issue=Flatten[StringCases[#, "<Issue>"~~x__~~"</Issue>" :> x]& /@ xmlFile];
	doi=Flatten[StringCases[#, "<ArticleId IdType=\"doi\">"~~Shortest[x__]~~"</ArticleId>" :> x]& /@ xmlFile];

	(* Turn authors into single strings *)
	firstNamesWithPeriod=Map[
		With[
			{nameList=#},
			Map[
				#<>". "&,
				nameList
			]
		]&,
		authorsNames
	];

	authors=Map[
		StringJoin[Flatten[#]]&,
		Transpose[{firstNamesWithPeriod, authorsLast}]
	];

	(* join keywords *)
	rawKeywords=(Keywords /. myOptions);
	keywordsJoined=If[SameQ[rawKeywords, Null],
		keywords,
		Join[rawKeywords, keywords]
	];

	(* Gather up our parsed options. *)
	parsedOptions=<|
		LiteratureFiles -> (LiteratureFiles /. myOptions),
		Title -> FirstOrDefault[title],
		ContactInformation -> FirstOrDefault[affiliation],
		Journal -> journal,
		PublicationDate -> Quiet[DateObject[month<>"/"<>day<>"/"<>year]],
		Volume -> FirstOrDefault[vol],
		StartPage -> ToString[FirstOrDefault[pages, "Null"]] /. "Null" -> Null,
		EndPage -> ToString[Total[pages]] /. "0" -> Null,
		DocumentType -> (DocumentType /. myOptions),
		Issue -> FirstOrDefault[issue],
		ISSN -> issn,
		ISSNType -> ToExpression[issnType],
		DOI -> FirstOrDefault[doi],
		URL -> website,
		Abstract -> FirstOrDefault[abstract],
		PubmedID -> ToString[FirstOrDefault[pubmedID]],
		Keywords -> keywordsJoined,
		References -> If[MatchQ[(References /. myOptions), Null], {}, Link[#, LiteratureReferences]& /@ ToList[References /. myOptions]],
		Authors -> authors
	|>;

	(* Make sure that all of the options are present. If an option is not in parsedOptions but is in myOptions, this will include it. *)
	allOptions=Append[Association[myOptions], parsedOptions];

	(* No not overwrite out given options. If something is not Null or Automatic, use that instead. *)
	manualOptions=(If[!MatchQ[#[[2]], Null | Automatic], #, Nothing]&) /@ myOptions;

	(* Merge the manual options over the parsed options. *)
	finalizedOptions=Normal[Append[allOptions, manualOptions]];

	(* Check the resolved options for validity and throw messages if they are not valid. *)
	checkOptionsForValidity[finalizedOptions];

	(* Merge the options and return them. *)
	outputOption /. {Result -> finalizedOptions, Tests -> Append[generateTests[finalizedOptions], pubMedTest]}
];


(* ::Subsubsection::Closed:: *)
(*EndNote*)


UploadLiterature::InvalidXMLFile="The given XML file path `1` does not exist. Please give a valid XML file to upload a literature object.";

(* Parses directly from an XML-formatted EndNote library. First extracts the desired fields, then calls the main definition of parseEndNote to put those fields into SLL objects *)
resolvedUploadLiteratureOptions[library_String, myOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, testRule, fields, refs, importedRefs},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* We only test that we were given a valid XML file. Other than that, all information in the PubMed ID is assumed to be correct. *)
	testRule=Test -> Test[
		"The given XML file is valid:",
		FileExistsQ[library],
		True
	];

	(* If the file does not exist, return the default options. *)
	If[!FileExistsQ[library],
		Message[UploadLiterature::InvalidXMLFile, library];
		Message[Error::InvalidInput, "endNoteFile"];

		Return[outputOption /. {Result -> myOptions, Tests -> testRule}]
	];

	(* Otherwise, our XML file exists. *)

	(* Define the fields to be parsed out of the EndNote database *)
	fields={"ref-type", "author", "auth-address", "title", "full-title", "pages", "SampleVolume", "number", "edition", "keyword", "date", "year", "isbn", "accession-num", "abstract", "notes", "url", "electronic-resource-num", "pub-location", "publisher", "section", "pdf-urls", "research-notes"};

	(* Pull all of the XMLElement["record",__] entries from the XML-formatted EndNote database *)
	refs=Cases[Import[library], XMLElement["record", __], Infinity];

	(* Import all of the requested fields from the references above *)
	importedRefs=Transpose[Table[Rule[fields[[i]], #1]& /@ (readXMLField[#, fields[[i]]]& /@ refs), {i, 1, Length[fields]}]];

	(* Parse the imported reference fields into valid raw[PDF] and/or report[Literature] info packets *)

	(* Append the XML valid file test to our result if we're returning tests. *)
	resolvedUploadLiteratureOptions[importedRefs, myOptions, myResolveOptions] /. {(myTests:{_EmeraldTest..}) :> (Append[myTests, testRule])}
];


(* Resolve the UploadLiterature options from EndNote references, listable version. *)
resolvedUploadLiteratureOptions[refs:{{Rule[_String, {_String...}]..}..}, myOptions_, myResolveOptions:OptionsPattern[]]:=Module[{},
	(* Pass each reference to the single-reference version of parseEndNote *)
	Flatten[resolvedUploadLiteratureOptions[#, myOptions, myResolveOptions]& /@ refs, 1]
];

(* Takes a single reference that has already been extracted from EndNote XML (a list of fields in the form fieldTitle->fieldContents) and builds and returns the appropriate SLL object(s) *)
resolvedUploadLiteratureOptions[myReference:{Rule[_String, {_String...}]..}, myOptions_, myResolveOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputOption, startPage, endPage, journal, authors, refType, ISBNField, ISBNType, date, literatureFiles, allOptions, parsedOptions, manualOptions, finalizedOptions},

	(* Convert the options to this function into a list. *)
	listedOptions=ToList[myResolveOptions];

	(* Extract the Output option. If we were not given the Output option, default it to Result. *)
	outputOption=If[MatchQ[listedOptions, {}],
		Result,
		Output /. listedOptions
	];

	(* Parse out the type of reference *)
	refType=FirstOrDefault["ref-type" /. myReference] /. {"Journal Article" -> JournalArticle, "Book" -> Book, "Book Section" -> BookSection, "Web Page" -> Webpage, "Patent" -> Patent};

	(* Call helper function to Parse the page numbers *)
	If[MatchQ["pages" /. myReference, {}],
		{startPage, endPage}={Null, Null},
		{startPage, endPage}=formatPageNumbers[FirstOrDefault["pages" /. myReference]]
	];

	(* Attempt to find the journal in the JournalP and JournalConversions database *)
	(* It's ok if there's ACTUALLY no journal title (e.g., a book), so in that case just keep journal as Null *)
	journal=If[!NullQ[FirstOrDefault["full-title" /. myReference]], FindJournal[FirstOrDefault["full-title" /. myReference], Export -> True, ExactMatch -> (OptionValue[Automated])], Null];

	(* Call helper function to Parse author names *)
	authors=If[MatchQ["author" /. myReference, {}],
		{Null},
		formatAuthor[#]& /@ ("author" /. myReference)
	];

	(* Put together the PublicationDate from the date and year fields *)
	date=If[MatchQ["date" /. myReference, {}],
		If[MatchQ["year" /. myReference, {}],
			(* If both date and year are empty, set PublicationDate to Null *)
			Null,
			(* If date is empty but year exists, set PublicationDate to Jan 1 of that year *)
			DateObject[FirstOrDefault["year" /. myReference]]
		],
		If[StringMatchQ[FirstOrDefault["date" /. myReference], LetterCharacter..~~" "~~DigitCharacter..],
			(* If year and date both exist and date is in a reasonable format for (Month Day), put the PublicationDate together and SLL format it *)
			DateObject[StringJoin @@ Riffle[Flatten[{"date", "year"} /. myReference], " "]],
			If[MatchQ["year" /. myReference, {}],
				(* If date exists in a screwy format and year doesn't exist, set PublicationDate to Null *)
				Null,
				(* If year and date both exist but date is in some screwy format that doesn't look like a (Month,Day), set PublicationDate to Jan 1 of that year *)
				DateObject[FirstOrDefault["year" /. myReference]]
			]
		]
	];

	(* Figure out ISBN type *)
	ISBNField=FirstOrDefault["isbn" /. myReference];
	If[MatchQ[ISBNField, Null],
		ISBNType=Null,
		ISBNType=ToExpression[FirstOrDefault[StringCases[ISBNField, "("~~type:Except[")"]..~~")" :> type]]]
	];

	(* Parse out the literature files. *)
	literatureFiles=If[
		!MatchQ["pdf-urls" /. myReference, {}],
		{FileNameJoin[{$PublicPath, "PDFs", Last[StringSplit[FirstOrDefault["pdf-urls" /. myReference], "/"]]}]},
		{}
	];

	(* Build the report[Literature] object *)
	parsedOptions=<|
		LiteratureFiles -> literatureFiles,
		Title -> FirstOrDefault["title" /. myReference],
		ContactInformation -> FirstOrDefault["auth-address" /. myReference],
		Journal -> journal,
		PublicationDate -> date,
		Volume -> FirstOrDefault["SampleVolume" /. myReference],
		StartPage -> startPage,
		EndPage -> endPage,
		DocumentType -> refType,
		Issue -> FirstOrDefault["number" /. myReference],
		ISSN -> If[MatchQ[ISBNField, Null], Null, FirstOrDefault[StringSplit[ISBNField, " "]]],
		ISSNType -> ISBNType,
		DOI -> FirstOrDefault["electronic-resource-num" /. myReference],
		URL -> FirstOrDefault["url" /. myReference],
		Abstract -> FirstOrDefault["abstract" /. myReference],
		PubmedID -> FirstOrDefault["accession-num" /. myReference],
		Authors -> authors,
		References -> If[MatchQ[(References /. myOptions), Null], {}, Link[#, LiteratureReferences]& /@ ToList[References /. myOptions]]
	|>;

	(* Make sure that all of the options are present. If an option is not in parsedOptions but is in myOptions, this will include it. *)
	allOptions=Append[Association[myOptions], parsedOptions];

	(* No not overwrite out given options. If something is not Null or Automatic, use that instead. *)
	manualOptions=(If[!MatchQ[#[[2]], Null | Automatic], #, Nothing]&) /@ myOptions;

	(* Merge the manual options over the parsed options. *)
	finalizedOptions=Normal[Append[allOptions, manualOptions]];

	(* Check the resolved options for validity and throw messages if they are not valid. *)
	checkOptionsForValidity[finalizedOptions];

	(* Merge the options and return them. *)
	outputOption /. {Result -> finalizedOptions, Tests -> generateTests[finalizedOptions], Preview -> Null}
];


(* ::Subsubsection::Closed:: *)
(*Helper function: readXMLField*)


readXMLField[record:XMLElement[___], field:_String]:=Module[{fieldRules},

	(* Get the rules describing characteristics of the field, if any *)
	fieldRules=Cases[record, XMLElement[field, stuff_List, ___] :> stuff, Infinity];

	(* If there are field rules, just grab the name. Otherwise, grab the content itself from the "style" element. *)
	If[MatchQ[Flatten[fieldRules], {}],
		Cases[record, XMLElement[field, {}, {XMLElement[_, _, {stuff_String}]}] :> stuff, Infinity],
		"name" /. fieldRules
	]

];


(* ::Subsubsection::Closed:: *)
(*Helper function: formatPageNumbers*)


(* Convert single strings of page numbers into start and end pages *)
formatPageNumbers[nums:_String]:=Module[{trimmedPages, splitPages, startPage, endPage},

	trimmedPages=StringReplace[ToLowerCase[nums], ("pps." | "pps" | "pp." | "pp" | "pgs." | "pgs" | "pg." | "pg" | "p." | "p" | " ") -> ""];

	If[StringMatchQ[nums, ___~~"-"~~___~~"-"~~___],

		(* If the pages string contains multiple dashes, give up and stash it as-is in both startPage and endPage*)
		{startPage, endPage}={nums, nums},

		splitPages=StringTrim /@ StringSplit[nums, "-"];
		If[Length[splitPages] > 1,

			startPage=FirstOrDefault[splitPages];
			If[StringLength[FirstOrDefault[splitPages]] > StringLength[Last[splitPages]],
				endPage=StringDrop[FirstOrDefault[splitPages], -StringLength[Last[splitPages]]]<>Last[splitPages],
				endPage=Last[splitPages]
			],

			startPage=FirstOrDefault[splitPages];
			endPage=FirstOrDefault[splitPages]
		];
	];

	{startPage, endPage}
];


(* ::Subsubsection::Closed:: *)
(*Helper function: formatAuthor*)


(* Convert single strings of page numbers into start and end pages *)
formatAuthor[name:_String]:=Module[{trimmedName, splitName},

	(* Convert periods to spaces for splitting purposes *)
	trimmedName=StringTrim[StringReplace[name, ("." -> " ")], (";" | Whitespace)..];

	(* If there is a comma in the name, assume that it's in the form Last,First,Middle *)
	If[StringMatchQ[trimmedName, __~~","~~__],
		(* Replace the comma with a space and split on spaces, then RotateLeft to get {First, (Middle,) Last} *)
		splitName=RotateLeft[StringSplit[StringReplace[trimmedName, "," -> " "], Whitespace..], 1],
		splitName=StringSplit[trimmedName, Whitespace..]
	];

	StringJoin[Riffle[splitName, " "]]
];


(* ::Subsubsection::Closed:: *)
(*Valid Function*)


DefineOptions[ValidUploadLiteratureQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadLiterature}
];


(* Overload for the case of no input arguments *)
ValidUploadLiteratureQ[myOptions__:PatternUnion[OptionsPattern[ValidUploadLiteratureQ], Except[{Rule[_String, {_String...}]..}]]]:=ValidUploadLiteratureQ[Null, myOptions];

ValidUploadLiteratureQ[myInput:(PubMed[_Integer] | {Rule[_String, {_String...}]..} | XmlFileP | Null), myOptions:OptionsPattern[ValidUploadLiteratureQ]]:=Module[
	{preparedOptions, functionTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Remove the Verbose option and add Output->Tests to get the options ready for <Function> *)
	preparedOptions=Normal@KeyDrop[Append[ToList[myOptions], Output -> Tests], {Verbose, OutputFormat}];

	(* Call the function to get a list of tests *)
	functionTests=UploadLiterature[myInput, preparedOptions];

	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[functionTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, functionTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	RunUnitTest[<|"ValidUploadLiteratureQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose]["ValidUploadLiteratureQ"]
];


(* ::Subsubsection::Closed:: *)
(*Option Function*)


DefineOptions[UploadLiteratureOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadLiterature}
];


UploadLiteratureOptions[myOptions__:PatternUnion[OptionsPattern[UploadLiteratureOptions], Except[{Rule[_String, {_String...}]..}]]]:=UploadLiteratureOptions[Null, myOptions];

UploadLiteratureOptions[myInput:(PubMed[_Integer] | {Rule[_String, {_String...}]..} | XmlFileP | Null), myOptions:OptionsPattern[UploadLiteratureOptions]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOptions];

	outOps=DeleteCases[SafeOptions[UploadLiteratureOptions, listedOps], (OutputFormat -> _) | (Output -> _)];

	options=UploadLiterature[myInput, Append[outOps, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadLiterature],
		options
	]
];


(* ::Subsection::Closed:: *)
(*UploadPipettingMethod*)


(* ::Subsubsection::Closed:: *)
(*Options & Messages*)


DefineOptions[UploadPipettingMethod,
	Options :> {
		{
			OptionName -> Model,
			Default -> Null,
			Description -> "The models for which these pipetting parameters will be used as default unless they are directly specified in manipulation primitives.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Alternatives[
				Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Adder[
					Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
					Orientation -> Horizontal
				]
			]
		},
		{
			OptionName -> AspirationRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be drawn up into the pipette tip.",
			ResolutionDescription -> "Automatically resolves from DispenseRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter / Second, 500 Microliter / Second],
				Units -> CompoundUnit[
					{1, {Milliliter, {Microliter, Milliliter, Liter}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseRate,
			Default -> Automatic,
			Description -> "The speed at which liquid should be expelled from the pipette tip.",
			ResolutionDescription -> "Automatically resolves from AspirationRate if it is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter / Second, 500 Microliter / Second],
				Units -> CompoundUnit[
					{1, {Milliliter, {Microliter, Milliliter, Liter}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> OverAspirationVolume,
			Default -> Automatic,
			Description -> "The volume of air drawn into the pipette tip at the end of the aspiration of a liquid.",
			ResolutionDescription -> "Automatically resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 50 Microliter],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		},
		{
			OptionName -> OverDispenseVolume,
			Default -> Automatic,
			Description -> "The volume of air blown out at the end of the dispensing of a liquid.",
			ResolutionDescription -> "Automatically resolves to 5 Microliter.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Microliter, 300 Microliter],
				Units -> {Microliter, {Microliter, Milliliter}}
			]
		},
		{
			OptionName -> AspirationWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after an aspiration.",
			ResolutionDescription -> "Automatically resolves from DispenseWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter / Second, 160 Millimeter / Second],
				Units -> CompoundUnit[
					{1, {Millimeter, {Millimeter, Micrometer}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseWithdrawalRate,
			Default -> Automatic,
			Description -> "The speed at which the pipette is removed from the liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationWithdrawalRate if it is specified, otherwise resolves to 2 Millimeter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.3 Millimeter / Second, 160 Millimeter / Second],
				Units -> CompoundUnit[
					{1, {Millimeter, {Millimeter, Micrometer}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after aspirating before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from DispenseEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second, {Second, Minute}}
			]
		},
		{
			OptionName -> DispenseEquilibrationTime,
			Default -> Automatic,
			Description -> "The delay length the pipette waits after dispensing before it is removed from the liquid.",
			ResolutionDescription -> "Automatically resolves from AspirationEquilibrationTime if it is specified, otherwise resolves to 1 Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 9.9 Second],
				Units -> {Second, {Second, Minute}}
			]
		},
		{
			OptionName -> AspirationMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid before it is aspirated.",
			ResolutionDescription -> "Automatically resolves from DispenseMixRate or AspirationRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter / Second, 500 Microliter / Second],
				Units -> CompoundUnit[
					{1, {Milliliter, {Microliter, Milliliter, Liter}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> DispenseMixRate,
			Default -> Automatic,
			Description -> "The speed at which liquid is aspirated and dispensed in a liquid after a dispense.",
			ResolutionDescription -> "Automatically resolves from AspirationMixRate or DispenseRate if either is specified, otherwise resolves to 100 Microliter/Second.",
			AllowNull -> False,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.4 Microliter / Second, 500 Microliter / Second],
				Units -> CompoundUnit[
					{1, {Milliliter, {Microliter, Milliliter, Liter}}},
					{-1, {Second, {Second, Minute}}}
				]
			]
		},
		{
			OptionName -> AspirationPosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be aspirated. Top will aspirate AspirationPositionOffset below the Top of the container, Bottom will aspirate AspirationPositionOffset above the Bottom of the container, LiquidLevel will aspirate AspirationPositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified AspirationPositionOffset above the bottom of the container to start aspirate the sample.",
			ResolutionDescription -> "If AspirationPositionOffset is specified, resolve to LiquidLevel, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> DispensePosition,
			Default -> Automatic,
			Description -> "The location from which liquid should be dispensed. Top will dispense DispensePositionOffset below the Top of the container, Bottom will dispense DispensePositionOffset above the Bottom of the container, LiquidLevel will dispense DispensePositionOffset below the liquid level of the sample in the container, and TouchOff will touch the bottom of the container before moving the specified DispensePositionOffset above the bottom of the container to start dispensing the sample.",
			ResolutionDescription -> "If DispensePositionOffset is specified, resolve to LiquidLevel, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",			AllowNull -> True,
			Category->"Instrument Specifications",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PipettingPositionP
			]
		},
		{
			OptionName -> AspirationPositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on AspirationPosition, from which liquid should be aspirated.",
			ResolutionDescription -> "Automatically resolves from DispensePositionOffset if it is specified, or if AspirationPosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter, {Millimeter}}
			]
		},
		{
			OptionName -> DispensePositionOffset,
			Default -> Automatic,
			Description -> "The distance from the top or bottom of the container, depending on DispensePosition, from which liquid should be dispensed.",
			ResolutionDescription -> "Automatically resolves from AspirationPositionOffset if it is specified, or if DispensePosition is not Null resolves to 2 Millimeter, otherwise resolves to Null and is determined at runtime by inspecting a sample's container type.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Millimeter],
				Units -> {Millimeter, {Millimeter}}
			]
		},
		{
			OptionName -> CorrectionCurve,
			Default -> {
				{0 Microliter, 0 Microliter},
				{20 Microliter, 23.2 Microliter},
				{50 Microliter, 55.1 Microliter},
				{100 Microliter, 107.2 Microliter},
				{200 Microliter, 211 Microliter},
				{300 Microliter, 313.5 Microliter},
				{500 Microliter, 521.7 Microliter},
				{1000 Microliter, 1034 Microliter}
			},
			AllowNull -> True,
			Description -> "The relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume. The default correction is the empirically determined curve for water.",
			Category -> "Pipetting",
			Widget -> Adder[
				{
					"Target Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 1000 Microliter],
						Units -> {Microliter, {Microliter, Milliliter}}
					],
					"Actual Volume" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Microliter, 1250 Microliter],
						Units -> {Microliter, {Microliter, Milliliter}}
					]
				},
				Orientation -> Vertical
			]
		},
		{
			OptionName -> DynamicAspiration,
			Default -> False,
			Description -> "Indicates if droplet formation should be prevented during liquid transfer. This should only be used for solvents that have high vapor pressure.",
			ResolutionDescription -> "Defaults to False unless explicitly turned on.",
			AllowNull -> True,
			Category -> "Pipetting",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		OutputOption,
		CacheOption,
		UploadOption
	}
];



(* ::Subsubsection::Closed:: *)
(* UploadPipettingMethod *)


Warning::ExistingPipettingMethod="The model(s) `1` already have the default pipetting method(s) `2`. This existing method will be overwritten.";
Warning::ModelNotLiquid="Specified model(s) `1` do not have a Liquid State. Pipetting parameters specified may not perform as specified when manipulating non-liquid models.";
Warning::CorrectionCurveNotMonotonic="The specified CorrectionCurve `1` (at index `2`) has actual values that are not monotonically increasing.";
Warning::CorrectionCurveIncomplete="The specified CorrectionCurve `1` (at index `2`) does not cover the full transfer volume range of 0 uL - 1000 uL. When used in robotic liquid transfers, our experiment will fit the correction curve and extend the range to the 1000 uL target volume.";
Error::InvalidCorrectionCurveZeroValue="The specified CorrectionCurve's actual volume corresponding to a target volume of 0 Microliter (`1`) must be 0 Microliter at index `2`. Please correct the CorrectionCurve such that a target volume of 0 Microliter has an actual volume of 0 Microliter.";
Warning::RoundedCorrectionCurve="CorrectionCurve values cannot exceed a precision of 0.1 Microliter. The specified values `1` will be rounded to the nearest 0.1 Microliter.";


UploadPipettingMethod[ops:OptionsPattern[UploadPipettingMethod]]:=UploadPipettingMethod[Null, ops];

UploadPipettingMethod[myName:(_String | Null), ops:OptionsPattern[UploadPipettingMethod]]:=Module[
	{listedOptions, outputSpecification, output, gatherTestsQ, safeOptions, safeOptionTests, specifiedModels,
		packets, allPackets, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, optionsRule, testsRule,
		resultRule},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[ops];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTestsQ,
		SafeOptions[UploadPipettingMethod, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadPipettingMethod, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Extract any objects in Model option *)
	specifiedModels=DeleteCases[ToList[Lookup[safeOptions, Model]], Null];

	(* Download required fields for options resolution *)
	packets=Quiet[
		Download[specifiedModels, Packet[State, PipettingMethod]],
		{Download::MissingField, Download::FieldDoesntExist}
	];

	(* Join existing cache list with downloaded packets *)
	allPackets=Flatten[{Lookup[safeOptions, Cache], packets}];

	(* Call resolveUploadPipettingMethodModel *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions, resolvedOptionsTests}=If[gatherTestsQ,
			resolveUploadPipettingMethodModel[myName, safeOptions, Output -> {Result, Tests}, Cache -> allPackets],
			{resolveUploadPipettingMethodModel[myName, safeOptions, Cache -> allPackets], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		Normal[resolvedOptions],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		DeleteCases[Flatten[{safeOptionTests, resolvedOptionsTests}], Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed],
		Module[{listedModels, roundedCorrectionCurve, methodPacket},

			(* Get list of models if specified *)
			listedModels=If[NullQ[Lookup[resolvedOptions, Model]],
				{},
				ToList[Download[Lookup[resolvedOptions, Model], Object]]
			];

			(* Round all correction curve values to nearest 0.1ul *)
			roundedCorrectionCurve=Map[
				Round[Convert[#, Microliter], 0.1]&,
				Lookup[resolvedOptions, CorrectionCurve]
			];

			(* Construct the new gradient method packet *)
			methodPacket=Association[
				Type -> Model[Method, Pipetting],
				Name -> myName,
				Replace[Models] -> Link[listedModels, PipettingMethod],
				AspirationRate -> Lookup[resolvedOptions, AspirationRate],
				OverAspirationVolume -> Lookup[resolvedOptions, OverAspirationVolume],
				AspirationWithdrawalRate -> Lookup[resolvedOptions, AspirationWithdrawalRate],
				AspirationEquilibrationTime -> Lookup[resolvedOptions, AspirationEquilibrationTime],
				AspirationMixRate -> Lookup[resolvedOptions, AspirationMixRate],
				AspirationPosition -> Lookup[resolvedOptions, AspirationPosition],
				AspirationPositionOffset -> Lookup[resolvedOptions, AspirationPositionOffset],
				DispenseRate -> Lookup[resolvedOptions, DispenseRate],
				OverDispenseVolume -> Lookup[resolvedOptions, OverDispenseVolume],
				DispenseWithdrawalRate -> Lookup[resolvedOptions, DispenseWithdrawalRate],
				DispenseEquilibrationTime -> Lookup[resolvedOptions, DispenseEquilibrationTime],
				DispenseMixRate -> Lookup[resolvedOptions, DispenseMixRate],
				DispensePosition -> Lookup[resolvedOptions, DispensePosition],
				DispensePositionOffset -> Lookup[resolvedOptions, DispensePositionOffset],
				Replace[CorrectionCurve] -> roundedCorrectionCurve,
				DynamicAspiration -> Lookup[resolvedOptions, DynamicAspiration]
			];

			(* Upload the packets and return the transaction objects, or return the packets *)
			If[Lookup[safeOptions, Upload],
				Upload[methodPacket],
				methodPacket
			]
		],
		$Failed
	];

	outputSpecification /. {
		optionsRule,
		testsRule,
		resultRule,
		Preview -> Null
	}
];


(* ::Subsubsection::Closed:: *)
(* resolveUploadPipettingMethodModel *)


DefineOptions[resolveUploadPipettingMethodModel,
	Options :> {
		OutputOption,
		CacheOption
	}
];

resolveUploadPipettingMethodModel[myName:(_String | Null), myUnresolvedOptions:{_Rule...}, ops:OptionsPattern[resolveUploadPipettingMethodModel]]:=Module[
	{outputSpecification, output, gatherTestsQ, messagesQ, testOrNull, warningOrNull, fetchPacketFromCache,
		optionsAssociation, resolvedAspirationRate, resolvedDispenseRate, resolvedAspirationMixRate,
		resolvedDispenseMixRate, resolvedOverAspirationVolume, resolvedOverDispenseVolume,
		resolvedAspirationWithdrawalRate, resolvedDispenseWithdrawalRate, resolvedAspirationEquilibrationTime,
		resolvedDispenseEquilibrationTime, resolvedAspirationPosition, resolvedDispensePosition,
		resolvedAspirationPositionOffset, resolvedDispensePositionOffset, models, modelStates, nonLiquidModels,
		stateTest, modelPipettingMethods, modelsWithExistingPipettingMethods, existingMethodTest, validNameQ,
		validNameTest, correctionCurveOptionValue, sortedCorrectionCurve, sortedActualValues,
		monotonicCorrectionCurveTest, incompleteCorrectionCurveTest, validZeroCorrectionTest, roundedCorrectionCurve, roundedCorrectionCurveValuesBools,
		roundedCorrectionCurveValues, roundedCorrectionCurveTest, allTests, resolvedOptionsAssociation},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* Determine if we should throw messages *)
	messagesQ=!gatherTestsQ;

	testOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTestsQ,
		Test[testDescription, True, Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTestsQ,
		Warning[testDescription, True, Evaluate[passQ]],
		Null
	];

	fetchPacketFromCache[myObject:ObjectP[], myCachedPackets:{PacketP[]...}]:=FirstCase[myCachedPackets, KeyValuePattern[{Object -> Download[myObject, Object]}]];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual *)
	optionsAssociation=Association[myUnresolvedOptions];

	(* If AspirationRate is directly specified, use that value. If not,
	resolve to DispenseRate if specified, otherwise 100ul/s. *)
	resolvedAspirationRate=If[MatchQ[Lookup[optionsAssociation, AspirationRate], FlowRateP],
		Lookup[optionsAssociation, AspirationRate],
		If[MatchQ[Lookup[optionsAssociation, DispenseRate], FlowRateP],
			Lookup[optionsAssociation, DispenseRate],
			100 Microliter / Second
		]
	];

	(* If DispenseRate is directly specified, use that value. If not,
	resolve to resolved AspirationRate *)
	resolvedDispenseRate=If[MatchQ[Lookup[optionsAssociation, DispenseRate], FlowRateP],
		Lookup[optionsAssociation, DispenseRate],
		resolvedAspirationRate
	];

	(* If not specified, resolve AspirationMixRate to:
		1. DispenseMixRate if specified
		2. Resolved AspirationRate *)
	resolvedAspirationMixRate=If[MatchQ[Lookup[optionsAssociation, AspirationMixRate], FlowRateP],
		Lookup[optionsAssociation, AspirationMixRate],
		If[MatchQ[Lookup[optionsAssociation, DispenseMixRate], FlowRateP],
			Lookup[optionsAssociation, DispenseMixRate],
			resolvedAspirationRate
		]
	];

	(* If not specified, resolve DispenseMixRate to resolved DispenseRate *)
	resolvedDispenseMixRate=If[MatchQ[Lookup[optionsAssociation, DispenseMixRate], FlowRateP],
		Lookup[optionsAssociation, DispenseMixRate],
		resolvedDispenseRate
	];

	(* If not specified, resolve OverAspirationVolume aka AirTranportVolume to 5 ul *)
	resolvedOverAspirationVolume=If[MatchQ[Lookup[optionsAssociation, OverAspirationVolume], VolumeP],
		Lookup[optionsAssociation, OverAspirationVolume],
		5 Microliter
	];

	(* If not specified, resolve OverDispenseVolume aka DispenseBlowOutVolume to 5 microliter *)
	resolvedOverDispenseVolume=If[MatchQ[Lookup[optionsAssociation, OverDispenseVolume], VolumeP],
		Lookup[optionsAssociation, OverDispenseVolume],
		5 Microliter
	];

	(* If not specified, resolve AspirationWithdrawalRate to:
		1. DispenseWithdrawalRate if specified
		2. 2 Millimeter/Second *)
	resolvedAspirationWithdrawalRate=If[MatchQ[Lookup[optionsAssociation, AspirationWithdrawalRate], SpeedP],
		Lookup[optionsAssociation, AspirationWithdrawalRate],
		If[MatchQ[Lookup[optionsAssociation, DispenseWithdrawalRate], SpeedP],
			Lookup[optionsAssociation, DispenseWithdrawalRate],
			2 Millimeter / Second
		]
	];

	(* If not specified, resolve DispenseWithdrawalRate to resolved AspirationWithdrawalRate *)
	resolvedDispenseWithdrawalRate=If[MatchQ[Lookup[optionsAssociation, DispenseWithdrawalRate], SpeedP],
		Lookup[optionsAssociation, DispenseWithdrawalRate],
		resolvedAspirationWithdrawalRate
	];

	(* If not specified, resolve AspirationEquilibrationTime to:
		1. DispenseEquilibrationTime if specified
		2. 1 Second *)
	resolvedAspirationEquilibrationTime=If[MatchQ[Lookup[optionsAssociation, AspirationEquilibrationTime], TimeP],
		Lookup[optionsAssociation, AspirationEquilibrationTime],
		If[MatchQ[Lookup[optionsAssociation, DispenseEquilibrationTime], TimeP],
			Lookup[optionsAssociation, DispenseEquilibrationTime],
			1 Second
		]
	];

	(* If not specified, resolve DispenseEquilibrationTime to resolved AspirationEquilibrationTime *)
	resolvedDispenseEquilibrationTime=If[MatchQ[Lookup[optionsAssociation, DispenseEquilibrationTime], TimeP],
		Lookup[optionsAssociation, DispenseEquilibrationTime],
		resolvedAspirationEquilibrationTime
	];

	(* If not specified, resolve AspirationPosition to:
		1. If AspirationPositionOffset is not Null, LiquidLevel
		2. Null (signifying runtime determination from sample's container) *)
	resolvedAspirationPosition=If[MatchQ[Lookup[optionsAssociation, AspirationPosition], PipettingPositionP],
		Lookup[optionsAssociation, AspirationPosition],
		(* If an offset is specified, assume LiquidLevel *)
		If[MatchQ[Lookup[optionsAssociation, AspirationPositionOffset], DistanceP],
			LiquidLevel,
			Null
		]
	];

	(* If not specified, resolve DispensePosition to:
		1. If DispensePositionOffset is not Null, LiquidLevel
		2. Null (signifying runtime determination from sample's container) *)
	resolvedDispensePosition=If[MatchQ[Lookup[optionsAssociation, DispensePosition], PipettingPositionP],
		Lookup[optionsAssociation, DispensePosition],
		(* If an offset is specified, assume LiquidLevel *)
		If[MatchQ[Lookup[optionsAssociation, DispensePositionOffset], DistanceP],
			LiquidLevel,
			Null
		]
	];

	(* If not specified, resolve AspirationPositionOffset to:
		1. If AspirationPosition is not Null, DispensePositionOffset if specified
		2. If AspirationPosition is not Null, 2 Millimeter
		3. Null (signifying runtime determination from sample's container) *)
	resolvedAspirationPositionOffset=If[MatchQ[Lookup[optionsAssociation, AspirationPositionOffset], DistanceP],
		Lookup[optionsAssociation, AspirationPositionOffset],
		If[!NullQ[resolvedAspirationPosition],
			If[MatchQ[Lookup[optionsAssociation, DispensePositionOffset], DistanceP],
				Lookup[optionsAssociation, DispensePositionOffset],
				2 Millimeter
			],
			Null
		]
	];

	(* If not specified, resolve DispensePositionOffset to:
		1. If DispensePosition is Null, Null
		2. If resolvedDispensePosition is not Null and resolvedAspirationPosition is not Null, resolvedAspirationPosition
		3. If resolvedDispensePosition is not Null and resolvedAspirationPosition is Null, 2 mm
		4. Null (signifying runtime determination from sample's container) *)
	resolvedDispensePositionOffset=If[MatchQ[Lookup[optionsAssociation, DispensePositionOffset], DistanceP],
		Lookup[optionsAssociation, DispensePositionOffset],
		If[!NullQ[resolvedDispensePosition],
			(* Is DispensePosition is _something_, inherit from resolved AspirationPositionOffset
			or default to 2 mm *)
			If[!NullQ[resolvedAspirationPositionOffset],
				resolvedAspirationPositionOffset,
				2 Millimeter
			],
			Null
		]
	];

	(* Fetch list of models specified for this pipetting method *)
	models=If[NullQ[Lookup[optionsAssociation, Model]],
		{},
		DeleteDuplicates[Download[ToList[Lookup[optionsAssociation, Model]], Object]]
	];

	(* Fetch models' states *)
	modelStates=Map[
		Lookup[fetchPacketFromCache[#, OptionValue[Cache]], State]&,
		models
	];

	(* Extract any models that are not liquids *)
	nonLiquidModels=PickList[models, modelStates, Except[Liquid]];

	(* Warning if models are not liquid *)
	stateTest=If[Length[nonLiquidModels] > 0,
		(
			If[messagesQ,
				Message[Warning::ModelNotLiquid, nonLiquidModels];
			];
			warningOrNull["Specified models have a State of Liquid:", False]
		),
		warningOrNull["Specified models have a State of Liquid:", True]
	];

	(* Fetch models' PipettingMethod *)
	modelPipettingMethods=Map[
		Lookup[fetchPacketFromCache[#, OptionValue[Cache]], PipettingMethod]&,
		models
	];

	(* Extract any models that already have pipetting methods specified *)
	modelsWithExistingPipettingMethods=PickList[models, modelPipettingMethods, ObjectP[]];

	(* If models already have a default method, warn that it will be overwritten *)
	existingMethodTest=If[Length[modelsWithExistingPipettingMethods] > 0,
		(
			If[messagesQ,
				Message[Warning::ExistingPipettingMethod, modelsWithExistingPipettingMethods, Cases[modelPipettingMethods, ObjectP[]]];
			];
			warningOrNull["Specified models do not have an existing PipettingMethod that will be overwritten:", False]
		),
		warningOrNull["Specified models do not have an existing PipettingMethod that will be overwritten:", True]
	];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[myName, _String],
		!DatabaseMemberQ[Model[Method, Pipetting, myName]],
		True
	];

	(* Generate Test for Name check *)
	validNameTest=If[validNameQ,
		testOrNull["Name is not already a pipetting method name:", True],
		testOrNull["Name is not already a pipetting method name:", False]
	];

	(* If Name is invalid, throw error *)
	If[messagesQ && !validNameQ,
		Message[Error::InvalidInput, Name];
		Message[Error::DuplicateName,myName];
	];

	(* Fetch CorrectionCurve value *)
	correctionCurveOptionValue=Lookup[optionsAssociation, CorrectionCurve];

	(* Sort curve by target volume values *)
	sortedCorrectionCurve=SortBy[correctionCurveOptionValue, First];

	(* Sort only actual values *)
	sortedActualValues=Sort[sortedCorrectionCurve[[All, 2]]];

	(* If sorted actual values do not match actual values sorted by target volumes,
	the correction curve is not monotonically increasing. *)
	monotonicCorrectionCurveTest=If[!MatchQ[sortedActualValues, sortedCorrectionCurve[[All, 2]]],
		(
			If[messagesQ,
				Message[Warning::CorrectionCurveNotMonotonic,correctionCurveOptionValue,1];
			];
			warningOrNull["Specified CorrectionCurve has monotonically increasing actual volume values:", False]
		),
		warningOrNull["Specified CorrectionCurve has monotonically increasing actual volume values:", True]
	];

	(* If the correction curve does not go all the way to 1000 uL, it cannot cover the allowed pipetting amount in Hamilton. Throw a warning. *)
	incompleteCorrectionCurveTest=If[!MatchQ[LastOrDefault[sortedCorrectionCurve], {GreaterEqualP[1000Microliter],_}]||!MatchQ[FirstOrDefault[sortedCorrectionCurve], {EqualP[0Microliter],_}],
		(
			If[messagesQ,
				Message[Warning::CorrectionCurveIncomplete,correctionCurveOptionValue,1];
			];
			warningOrNull["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:", False]
		),
		warningOrNull["The specified CorrectionCurve covers the full transfer volume range of 0 uL - 1000 uL:", True]
	];

	(* If a 0-point is specified, both target and actual value must be 0 *)
	validZeroCorrectionTest=If[
		And[
			Length[correctionCurveOptionValue] > 0,
			sortedCorrectionCurve[[1, 1]] == 0 Microliter,
			sortedCorrectionCurve[[1, 2]] != 0 Microliter
		],
		(
			If[messagesQ,
				Message[Error::InvalidOption, CorrectionCurve];
				Message[Error::InvalidCorrectionCurveZeroValue, sortedCorrectionCurve[[1, 2]],1]
			];
			testOrNull["CorrectionCurve's specified actual volume for a target volume of 0 Microliter is also 0 Microliter:", False]
		),
		testOrNull["CorrectionCurve's specified actual volume for a target volume of 0 Microliter is also 0 Microliter:", True]
	];

	(* Round all values to nearest 0.1ul *)
	roundedCorrectionCurve=Map[
		Round[Convert[#, Microliter], 0.1]&,
		correctionCurveOptionValue
	];

	(* If specified value is not equal to the rounded value, it has been rounded *)
	roundedCorrectionCurveValuesBools=MapThread[
		{!(#1[[1]] == #2[[1]]), !(#1[[2]] == #2[[2]])}&,
		{correctionCurveOptionValue, roundedCorrectionCurve}
	];

	(* Extract all specified values that have been rounded *)
	roundedCorrectionCurveValues=PickList[
		Flatten[correctionCurveOptionValue],
		Flatten[roundedCorrectionCurveValuesBools],
		True
	];

	(* CorrectionCurve must not exceed a precision of 0.1ul. If it does, the value will be rounded. *)
	roundedCorrectionCurveTest=If[Length[roundedCorrectionCurveValues] > 0,
		(
			If[messagesQ && !MatchQ[$ECLApplication,Engine],
				Message[Warning::RoundedCorrectionCurve, roundedCorrectionCurveValues]
			];
			warningOrNull["CorrectionCurve values do not exceed a precision of 0.1 Microliter and will not be rounded:", False]
		),
		warningOrNull["CorrectionCurve values do not exceed a precision of 0.1 Microliter and will not be rounded:", True]
	];

	(* Join all tests together *)
	allTests=DeleteCases[
		Flatten[{
			stateTest,
			existingMethodTest,
			validNameTest,
			monotonicCorrectionCurveTest,
			incompleteCorrectionCurveTest,
			validZeroCorrectionTest,
			roundedCorrectionCurveTest
		}],
		Null
	];

	(* Build resolved options association *)
	resolvedOptionsAssociation=Association[
		Model -> Lookup[optionsAssociation, Model],
		AspirationRate -> resolvedAspirationRate,
		OverAspirationVolume -> resolvedOverAspirationVolume,
		AspirationWithdrawalRate -> resolvedAspirationWithdrawalRate,
		AspirationEquilibrationTime -> resolvedAspirationEquilibrationTime,
		AspirationMixRate -> resolvedAspirationMixRate,
		AspirationPosition -> resolvedAspirationPosition,
		AspirationPositionOffset -> resolvedAspirationPositionOffset,
		DispenseRate -> resolvedDispenseRate,
		OverDispenseVolume -> resolvedOverDispenseVolume,
		DispenseWithdrawalRate -> resolvedDispenseWithdrawalRate,
		DispenseEquilibrationTime -> resolvedDispenseEquilibrationTime,
		DispenseMixRate -> resolvedDispenseMixRate,
		DispensePosition -> resolvedDispensePosition,
		DispensePositionOffset -> resolvedDispensePositionOffset,
		CorrectionCurve -> correctionCurveOptionValue,
		DynamicAspiration -> Lookup[optionsAssociation, DynamicAspiration]
	];

	(* return requested form *)
	outputSpecification /. {
		Tests -> allTests,
		Result -> Normal[resolvedOptionsAssociation]
	}
];




(* ::Subsubsection::Closed:: *)
(*UploadPipettingMethodModelOptions*)


DefineOptions[UploadPipettingMethodModelOptions,
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	},
	SharedOptions :> {UploadPipettingMethod}
];

UploadPipettingMethodModelOptions[ops:OptionsPattern[]]:=UploadPipettingMethodModelOptions[Null, ops];

UploadPipettingMethodModelOptions[myName:_String | Null, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions=ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for UploadGradientMethod *)
	options=UploadPipettingMethod[myName, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadPipettingMethod],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodPreview*)


DefineOptions[UploadPipettingMethodModelPreview,
	SharedOptions :> {UploadPipettingMethod}
];

UploadPipettingMethodModelPreview[ops:OptionsPattern[]]:=UploadPipettingMethodModelPreview[Null, ops];

UploadPipettingMethodModelPreview[myName:_String | Null, ops:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[ops];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

	(* return only the preview for UploadGradientMethod *)
	UploadPipettingMethod[myName, Append[noOutputOptions, Output -> Preview]]
];




(* ::Subsubsection::Closed:: *)
(*ValidUploadGradientMethodQ*)


DefineOptions[ValidUploadPipettingMethodModelQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadPipettingMethod}
];

ValidUploadPipettingMethodModelQ[ops:OptionsPattern[]]:=ValidUploadPipettingMethodModelQ[Null, ops];

ValidUploadPipettingMethodModelQ[myName:_String | Null, ops:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, uploadPipettingMethodModelTests, initialTestDescription,
		allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[ops];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for UploadGradientMethod *)
	uploadPipettingMethodModelTests=UploadPipettingMethod[myName, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[uploadPipettingMethodModelTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription, True, True];

			(* get all the tests/warnings *)
			Flatten[{initialTest, uploadPipettingMethodModelTests}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=Quiet[
		OptionDefault[OptionValue[ValidUploadPipettingMethodModelQ, ops, {Verbose, OutputFormat}]],
		OptionValue::nodef
	];

	(* run all the tests as requested *)
	Lookup[
		RunUnitTest[
			<|"ValidUploadPipettingMethodModelQ" -> allTests|>,
			OutputFormat -> outputFormat,
			Verbose -> verbose
		],
		"ValidUploadPipettingMethodModelQ"
	]
];


(* ::Subsection::Closed:: *)
(*UploadFractionCollectionMethod*)


(* ::Subsubsection::Closed:: *)
(*Options & Messages*)


DefineOptions[UploadFractionCollectionMethod,
	Options :> {
		(* Overall the default option values match ExperimentHPLC *)
		{
			OptionName -> FractionCollectionStartTime,
			Default -> Automatic,
			Description -> "The time at which fraction collection should begin.",
			ResolutionDescription -> "Automatically resolves to Null or inherited from a method specified by the Template option.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> FractionCollectionEndTime,
			Default -> Automatic,
			Description -> "The time at which fraction collection should end.",
			ResolutionDescription -> "Automatically resolves to Null or inherited from a method specified by the Template option.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> FractionCollectionMode,
			Default -> Automatic,
			Description -> "The method by which fractions collection should be triggered (peak detection, a constant threshold, or a fixed fraction time). In Peak detection mode, the fraction collection is triggered when a change in slope of the FractionCollectionDetector signal is observed for a specified PeakSlopeDuration time. In constant Threshold mode, whenever the signal from the FractionCollectionDetector is above the specified value, fraction collection is triggered. In fixed fraction Time mode, fractions are collected during the whole time interval specified.",
			ResolutionDescription -> "Automatically inherited from a method specified by the Template option, or implicitly resolved from other fraction collection options. If AbsoluteThreshold is specified, set to Threshold. If PeakSlope is specified, set to Peak. If MaxCollectionPeriod is specified, set to Time. Otherwise defaults to Threshold.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> FractionCollectionModeP
			]
		},
		{
			OptionName -> MaxFractionVolume,
			Default -> Automatic,
			Description -> "The maximum amount of sample to be collected in a single fraction. If fraction detection trigger is not off, the collector moves position to the next container. For example, if AbsorbanceThreshold is set to 180 MilliAbsorbanceUnit and at MaxFractionVolume the absorbance value is still above 180 MilliAbsorbanceUnit, the fraction collector continues to collect fractions in the next container in line.",
			ResolutionDescription -> "Automatically resolves to Null if FractionCollectionMode is Time, or inherited from a method specified by the Template option. Otherwise defaults to 1.8 Milliliter.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Microliter, 250 Milliliter],
				Units -> {Milliliter, {Milliliter, Microliter}}
			]
		},
		{
			OptionName -> MaxCollectionPeriod,
			Default -> Automatic,
			Description -> "The amount of time after which a new fraction will be generated (Fraction Collector moves to the next vial) when FractionCollectionMode is Time. For example, if MaxCollectionPeriod is 120 Second, the fraction collector continues to collect fractions in the next container in line after 120 Second.",
			ResolutionDescription -> "Automatically inherited from a method specified by the Template option, or defaults to 30s FractionCollectionMode is set to Time. Otherwise defaults to Null.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Second],
				Units -> {Second, {Second, Minute}}
			]
		},
		{
			OptionName -> AbsoluteThreshold,
			Default -> Automatic,
			Description -> "The signal value from FractionCollectionDetector above which fractions will always be collected, when FractionCollectionMode is Threshold.",
			ResolutionDescription -> "Automatically resolves to 500 mAU when FractionCollectionMode is Threshold, or is inherited from a method specified by the Template option. Otherwise defaults to Null.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> (GreaterEqualP[0 AbsorbanceUnit] | GreaterEqualP[0 RFU] | GreaterEqualP[10 Micro Siemens / Centimeter]),
				Units -> Alternatives[
					{1, {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}},
					{1, {RFU * Milli, {RFU * Milli, RFU}}},
					CompoundUnit[
						{1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
						{-1, {Centimeter, {Centimeter}}}
					]
				]
			]
		},
		{
			OptionName -> PeakSlope,
			Default -> Automatic,
			Description -> "The minimum slope (signal change per second) required for PeakSlopeDuration to trigger peak detection and start fraction collection. Fraction collection end slope is defined as the opposite of PeakSlope and fraction collection will continue until the slope exceeds the negative of the PeakSlope. For instance, if PeakSlope is set to 1 Milli Absorbance Unit/Second, fraction collection begins when the slope surpasses this value and ends when the slope falls below -1 Milli Absorbance Unit/Second. If a PeakEndThreshold is specified, both the PeakEndThreshold and PeakSlope conditions must be satisfied to stop fraction collection. A new peak and corresponding fraction can be registered when the slope exceeds the PeakSlope again.",
			ResolutionDescription -> "Automatically inherited from a method specified by the Template option or set to 1 Milli AbsorbanceUnit/Second if FractionCollectionMode is Peak.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> (GreaterEqualP[0 AbsorbanceUnit / Second] | GreaterEqualP[0 RFU / Second] | GreaterEqualP[10 Micro (Siemens / Centimeter) / Second]),
				Units -> Alternatives[
					CompoundUnit[
						{1, {AbsorbanceUnit, {AbsorbanceUnit, MilliAbsorbanceUnit}}},
						{-1, {Second, {Second, Millisecond}}}
					],
					CompoundUnit[
						{1, {RFU * Milli, {RFU * Milli, RFU}}},
						{-1, {Second, {Second, Millisecond}}}
					],
					CompoundUnit[
						{1, {Micro Siemens, {Micro Siemens, Milli Siemens, Siemens}}},
						{-1, {Centimeter, {Centimeter}}},
						{-1, {Second, {Second, Millisecond}}}
					]
				]
			]
		},
		(* Default to Null if not in the template method, since we don't require this in experiment (basically Null means 0 Second) *)
		{
			OptionName -> PeakSlopeDuration,
			Default -> Automatic,
			Description -> "The minimum duration that changes in slopes must be maintained before fraction collection is registered or ended.",
			ResolutionDescription -> "Automatically inherited from a method specified by the Template option.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Second, 4 Second],
				Units -> {Second, {Second, Millisecond}}
			]
		},
		(* Default to Null if not in the template method, since we don't require this in experiment (basically Null means 0 signal unit) *)
		{
			OptionName -> PeakEndThreshold,
			Default -> Automatic,
			Description -> "The signal value below which the end of a peak is marked and fraction collection stops when FractionCollectionMode is Peak. Both the PeakEndThreshold and PeakSlope conditions must be satisfied to stop fraction collection.",
			ResolutionDescription -> "Automatically inherited from a method specified by the Template option.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> (GreaterEqualP[0 AbsorbanceUnit] | GreaterEqualP[0 RFU] | GreaterEqualP[10 Micro Siemens / Centimeter]),
				Units -> Alternatives[
					{1, {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}},
					{1, {RFU * Milli, {RFU * Milli, RFU}}},
					CompoundUnit[
						{1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
						{-1, {Centimeter, {Centimeter}}}
					]
				]
			]
		},
		{
			OptionName -> Template,
			Default -> Null,
			Description -> "A template Object[Method,FractionCollection] whose values will be used as defaults for any options not specified by the user.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[Object[Method, FractionCollection]],
				ObjectTypes -> {Object[Method, FractionCollection]}
			]
		},
		NameOption,
		UploadOption,
		OutputOption,
		CacheOption
	}
];


Error::MethodNameAlreadyExists="A method Object with the name `1` already exists.";
Error::FractionCollectionTiming="The FractionCollectionStartTime must be less than the FractionCollectionEndTime.";
Error::FractionCollectionMode="If FractionCollectionMode is set to `1`, `2` must be provided and `3` must be Null.";


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethod*)


UploadFractionCollectionMethod[myOptions:OptionsPattern[UploadFractionCollectionMethod]]:=UploadFractionCollectionMethod[Null, myOptions];
UploadFractionCollectionMethod[myInput:ObjectP[Object[Method, FractionCollection]] | Null, myOptions:OptionsPattern[UploadFractionCollectionMethod]]:=Module[
	{listedOptions, outputSpecification, output, gatherTestsQ, safeOps, safeOptionTests, validLengthsQ, validLengthTests,
		resolvedOptionsResult, resolvedOps, resolvedOptionsTests, optionsRule, previewRule, testsRule, resultRule, resolveUpload,
		suppliedCache, templateOp, toDownload, inputObj, templateObj, downloadedPackets, cache, conflictingTemplatesQ,
		conflictingTemplatesTest, referenceObj, templatedSafeOps},

	(* Make sure we are working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Lookup[listedOptions, Output, Result];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOptionTests}=If[gatherTestsQ,
		SafeOptions[UploadFractionCollectionMethod, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadFractionCollectionMethod, listedOptions, AutoCorrect -> False], Null}
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengthsQ, validLengthTests}=Switch[myInput,

		(* UploadFractionCollectionMethod[obj] *)
		ObjectP[Object[Method, FractionCollection]],
		ValidInputLengthsQ[UploadFractionCollectionMethod, {myInput}, listedOptions, 2, Output -> {Result, Tests}],

		(* UploadFractionCollectionMethod[] *)
		Null,
		ValidInputLengthsQ[UploadFractionCollectionMethod, {}, listedOptions, 1, Output -> {Result, Tests}],

		_,
		{$Failed, Null}
	];

	(* If the specified options do not match their patterns return $Failed (or the tests up to this point)  *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengthsQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* --- Download explicit cache to get information needed by resolve<Type>Options/<type>ResourcePackets --- *)
	suppliedCache=Lookup[listedOptions, Cache, {}];

	(* Store the value from the Template option *)
	templateOp=Lookup[safeOps, Template];

	(* Create a list of objects to gather information on *)
	toDownload=Join[ToList[myInput], ToList[Lookup[safeOps, Template]]];

	(* Gather information on the provided Objects *)
	{inputObj, templateObj}=Download[
		toDownload,
		Cache -> suppliedCache
	];

	(* Trim nulls *)
	downloadedPackets=DeleteCases[{inputObj, templateObj}, Null, 1];

	(* Create one single cache *)
	cache=Join[suppliedCache, Flatten[downloadedPackets]];

	(* Determine if the objects provided as templates conflict *)
	conflictingTemplatesQ=And[
		!NullQ[inputObj] && !NullQ[templateObj],
		!MatchQ[inputObj, templateObj]
	];

	(* Create a test that ensures there was no conflict between objects provided as templates *)
	conflictingTemplatesTest=Test["Only one object was provided as a potential Template, either as an input or via the Template option:",
		!conflictingTemplatesQ,
		True
	];

	(* If the templates provided are invalid return $Failed *)
	If[conflictingTemplatesQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests, {conflictingTemplatesTest}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Resolve which object to use as a template *)
	referenceObj=If[
		(* If there were no downloaded packets *)
		MatchQ[downloadedPackets, {}],

		(* referenceObj = Null *)
		Null,

		(* Otherwise decide which source to pull from *)
		If[

			(* Provide preference to Input *)
			MatchQ[inputObj, ObjectP[Object[Method, FractionCollection]]],

			(* Return input *)
			inputObj,

			(* Otherwise only a template was provided *)
			templateObj
		]
	];

	(* Replaces any rules that were not specified by the user with a value from the template *)
	templatedSafeOps=resolveTemplateOptions[UploadFractionCollectionMethod, referenceObj, listedOptions, safeOps, Exclude -> {Name, Template}];

	(* Call resolveUploadMethodFractionCollectionOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating the standard results cannot be returned *)
	resolvedOptionsResult=Check[
		{resolvedOps, resolvedOptionsTests}=If[gatherTestsQ,
			resolveUploadMethodFractionCollectionObjectOptions[templatedSafeOps, Output -> {Result, Tests}],
			{resolveUploadMethodFractionCollectionObjectOptions[templatedSafeOps, Output -> Result], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		resolvedOps,
		Null
	];

	(* Prepare the Preview result if we were asked to do so *)
	(* Since this is an Upload function, there is no preview *)
	previewRule=Preview -> Null;

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper funcctions with any additional tests *)
		Join[safeOptionTests, validLengthTests, resolvedOptionsTests],
		Null
	];

	(* Build a helper that will decide whether to upload the object packet and determine how to return any uploaded objects *)
	resolveUpload[myPack_Association]:=Module[
		{objByName, resolvedOutput},

		(* Generate the objects id in the form Object[Method,FractionCollection,<NameProvided>] *)
		objByName=Object[Method, FractionCollection, Lookup[resolvedOps, Name]];

		(* If Upload->True *)
		resolvedOutput=If[Lookup[resolvedOps, Upload],
			(* Upload the packet *)
			Upload[myPack],
			(* Otherwise just return the packet *)
			myPack
		];

		(* Decide what to return *)
		If[
			And[
				(* If Object was uploaded *)
				MatchQ[resolvedOutput, ObjectReferenceP[Object[Method, FractionCollection]]],
				(* And a name was provided *)
				!NullQ[Lookup[resolvedOps, Name]]
			],

			(* Return the object as Object[Method,FractionCollection,<NameProvided>] *)
			objByName,

			(* Otherwise, return the output resolved earlier *)
			resolvedOutput
		]
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[
		(* If Result has been requested and options were successfully resolved *)
		MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed],

		Module[{packet, methodObj, templateLink},

			(* Create an ID for Object[Method,FractionCollection] *)
			methodObj=CreateID[Object[Method, FractionCollection]];

			(* Create a link to any Template found *)
			templateLink=Which[

				(* If a template object was provided as input, and the Template option was left Null *)
				MatchQ[myInput, ObjectP[Object[UploadFractionCollectionMethod]]],
				Link[myInput, MethodsTemplated],

				(* If no input was provided but the Template option was specified *)
				NullQ[myInput] && MatchQ[Lookup[resolvedOps, Template], ObjectP[Object[Method, FractionCollection]]],
				Link[Lookup[resolvedOps, Template], MethodsTemplated],

				(* If no method was provided, Template must be set to Null *)
				True,
				Null
			];

			(* If generating an object, make sure to fill in standard fields in addition to all the user specifications *)
			packet=<|
				Object -> methodObj,
				Type -> Object[Method, FractionCollection],
				Name -> Lookup[resolvedOps, Name],
				AbsoluteThreshold -> Lookup[resolvedOps, AbsoluteThreshold],
				FractionCollectionEndTime -> Lookup[resolvedOps, FractionCollectionEndTime],
				FractionCollectionMode -> Lookup[resolvedOps, FractionCollectionMode],
				FractionCollectionStartTime -> Lookup[resolvedOps, FractionCollectionStartTime],
				MaxCollectionPeriod -> Lookup[resolvedOps, MaxCollectionPeriod],
				MaxFractionVolume -> Lookup[resolvedOps, MaxFractionVolume],
				PeakEndThreshold -> Lookup[resolvedOps, PeakEndThreshold],
				PeakSlope -> Lookup[resolvedOps, PeakSlope],
				PeakSlopeDuration -> Lookup[resolvedOps, PeakSlopeDuration],
				Template -> templateLink
			|>;

			(* If the user specified indicated the object should be uploaded *)
			resolveUpload[packet]
		],

		(* Otherwise return no Result *)
		$Failed
	];

	outputSpecification /. {previewRule, optionsRule, testsRule, resultRule}
];


(* ::Subsubsection::Closed:: *)
(*resolvedUploadMethodFractionCollectionObjectOptions*)


resolveUploadMethodFractionCollectionObjectOptions[
	myOps:OptionsPattern[UploadFractionCollectionMethod],
	myOutputOps:(Output -> CommandBuilderOutputP) | (Output -> {CommandBuilderOutputP..})
]:=Module[
	{
		(* Setup vars *)
		listedOps, listedOutputOps,

		(* Option names *)
		myName, absThreshold, collectEnd, mode, collectStart, maxPeriod, maxVol, endThreshold, peakSlope, slopeDuration,

		(* Option resolution defaults for cases when Automatic cannot be resolved to Null *)
		defaultAbsThreshold=(500 * Milli * AbsorbanceUnit),
		defaultMaxPeriod=30 * Second,
		defaultMaxVol=1.8 * Milliliter,
		defaultPeakSlope=(1 * Milli * AbsorbanceUnit/Second),

		(* Resolved option values *)
		resolvedMode, resolvedAbsThreshold, resolvedMaxPeriod, resolvedMaxVol, resolvedCollectStart,
		resolvedCollectEnd, resolvedEndThreshold, resolvedPeakSlope, resolvedSlopeDuration, resolvedOps,

		(* Resolution bools *)
		nameBool, startStopBool,

		(* Tests and Messages *)
		modeInvalidNullOptions, modeInvalidNotNullOptions, modeOptionRequirementTuples, gatherTestsQ, nameTest, modeOptionTest, startStopTest, allTests
	},

	(* convert the options into a list *)
	listedOps=ToList[myOps];
	listedOutputOps=ToList[myOutputOps];

	(* check whether we are collecting tests *)
	gatherTestsQ=MemberQ[Lookup[listedOutputOps, Output], Tests];

	(* Store the values of the provided options *)
	myName=Lookup[listedOps, Name, Null];
	{absThreshold, collectEnd, mode, collectStart, maxPeriod, maxVol, endThreshold, peakSlope, slopeDuration}=Lookup[
		listedOps,
		{
			AbsoluteThreshold,
			FractionCollectionEndTime,
			FractionCollectionMode,
			FractionCollectionStartTime,
			MaxCollectionPeriod,
			MaxFractionVolume,
			PeakEndThreshold,
			PeakSlope,
			PeakSlopeDuration
		},
		Automatic (* Default to Automatic if Value is missing *)
	];

	(* If the specified Name is not in the database, it is valid *)
	nameBool=If[MatchQ[myName, _String],
		!DatabaseMemberQ[Object[Method, FractionCollection, myName]],
		True (* If Name is Null|Automatic then there are no checks needed *)
	];

	(* If the name is invalid and we are not gathering tests, return errors *)
	If[!TrueQ[gatherTestsQ],
		If[!TrueQ[nameBool],
			(
				Message[Error::MethodNameAlreadyExists, myName];
				Message[Error::InvalidOption, Name]
			)
		]
	];

	(* Generate a test to confirm the Name was valid *)
	nameTest=Test["The name of the FractionCollection method has not yet been used:",
		nameBool,
		True
	];

	(* FractionCollectionStart and FractionCollectionEnd default to Null *)
	{resolvedCollectStart, resolvedCollectEnd}=ReplaceAll[{collectStart, collectEnd}, Automatic -> Null];

	(* Check that the start and end times are valid *)
	startStopBool=Or[
		(* Either end time is Null, in which case we do not care what the start value is *)
		MatchQ[resolvedCollectEnd, Null],
		(* Or they are both times and collectStart is before collectEnd *)
		And[
			And[MatchQ[resolvedCollectStart, TimeP], MatchQ[resolvedCollectEnd, TimeP]],
			Less[resolvedCollectStart, resolvedCollectEnd]
		]
	];

	(* If the FractionCollectionEndTime is less than the FractionCollectionStartTime, return errors *)
	If[!TrueQ[gatherTestsQ],
		If[!TrueQ[startStopBool],
			(
				Message[Error::FractionCollectionTiming];
				Message[Error::InvalidOption, FractionCollectionStartTime]
			)
		]
	];

	(* Build a test to report whether the start time was before the end time *)
	startStopTest=Test["The FractionCollectionStartTime is before the FractionCollectionEndTime, or both are Null:",
		startStopBool,
		True
	];

	(* Resolve the FractionCollectionMode option *)
	(* Respect user option first *)
	(* If MaxCollectionPeriod is provided, set it to Time *)
	(* If any Peak option (PeakEndThreshold, PeakSlope, PeakSlopeDuration) is provided, set it to Peak *)
	resolvedMode=Which[
		MatchQ[mode, FractionCollectionModeP], mode,
		MatchQ[maxPeriod, TimeP], Time,
		MatchQ[absThreshold, UnitsP[]], Threshold,
		!MatchQ[{endThreshold, peakSlope, slopeDuration}, {(Automatic|Null)..}], Peak,
		True, Threshold
	];

	(* Resolve AbsoluteThreshold *)
	resolvedAbsThreshold=Which[
		(* If a valid AbsoluteThreshold was provided, use it *)
		MatchQ[absThreshold, UnitsP[]], absThreshold,
		(* If AbsoluteThreshold->Automatic and CollectionMode->Threshold, default Automatic to the hardcoded default *)
		MatchQ[absThreshold, Automatic] && MatchQ[resolvedMode, Threshold], defaultAbsThreshold,
		(* Otherwise set to Null *)
		True, Null
	];

	(* Resolve MaxCollectionPeriod *)
	resolvedMaxPeriod=Which[
		(* If a valid MaxCollectionPeriod was provided, ust it *)
		MatchQ[maxPeriod, TimeP], maxPeriod,
		(* If MaxCollectionPeriod->Automatic and CollectionMode->Threshold or Peak, default Automatic to Null *)
		MatchQ[maxPeriod, Automatic] && MatchQ[resolvedMode, Threshold | Peak], Null,
		(* If MaxCollectionPeriod->Automatic and CollectionMode->Time, default Automatic to the hardcoded default *)
		MatchQ[maxPeriod, Automatic] && MatchQ[resolvedMode, Time], defaultMaxPeriod,
		(* If User specified Null, resolve to Null *)
		NullQ[maxPeriod], Null
	];

	(* Resolve MaxCollectionVolume *)
	resolvedMaxVol=Which[
		(* If a valid MaxCollectionPeriod was provided, ust it *)
		MatchQ[maxVol, VolumeP], maxVol,
		(* If MaxCollectionPeriod->Automatic and CollectionMode->Threshold or Peak, default Automatic to hardcoded default value *)
		MatchQ[maxVol, Automatic] && MatchQ[resolvedMode, Threshold | Peak], defaultMaxVol,
		(* If MaxCollectionPeriod->Automatic and CollectionMode->Time, default Automatic to Null *)
		MatchQ[maxVol, Automatic] && MatchQ[resolvedMode, Time], Null,
		(* If User specified Null, resolve to Null *)
		NullQ[maxVol], Null
	];

	(* Resolve PeakSlope *)
	resolvedPeakSlope=Which[
		(* If a valid PeakSlope was provided, ust it *)
		MatchQ[peakSlope, UnitsP[]], peakSlope,
		(* If PeakSlope->Automatic and CollectionMode->Threshold or Time, default Automatic to Null *)
		MatchQ[peakSlope, Automatic] && MatchQ[resolvedMode, Threshold | Time], Null,
		(* If PeakSlope->Automatic and CollectionMode->Peak, default Automatic to the hardcoded default *)
		MatchQ[peakSlope, Automatic] && MatchQ[resolvedMode, Peak], defaultPeakSlope,
		(* If User specified Null, resolve to Null *)
		NullQ[peakSlope], Null
	];

	(* PeakSlopeDuration and defaults to Null *)
	{resolvedSlopeDuration, resolvedEndThreshold}=ReplaceAll[{slopeDuration, endThreshold}, Automatic -> Null];

	(* Options that are Null but should be specified *)
	modeInvalidNullOptions=Switch[resolvedMode,
		Time,
		If[NullQ[resolvedMaxPeriod],
			{MaxCollectionPeriod},
			{}
		],
		Peak,
		If[NullQ[resolvedPeakSlope],
			{PeakSlope},
			{}
		],
		Threshold,
		If[NullQ[resolvedAbsThreshold],
			{AbsoluteThreshold},
			{}
		]
	];

	(* Options that are not Null but should not be specified *)
	modeInvalidNotNullOptions=Switch[resolvedMode,
		Time,
		PickList[{AbsoluteThreshold,PeakSlope,PeakSlopeDuration,PeakEndThreshold},{resolvedAbsThreshold,resolvedPeakSlope,resolvedSlopeDuration,resolvedEndThreshold},Except[Null]],
		Peak,
		PickList[{AbsoluteThreshold,MaxCollectionPeriod},{resolvedAbsThreshold,resolvedMaxPeriod},Except[Null]],
		Threshold,
		PickList[{MaxCollectionPeriod,PeakSlope,PeakSlopeDuration,PeakEndThreshold},{resolvedMaxPeriod,resolvedPeakSlope,resolvedSlopeDuration,resolvedEndThreshold},Except[Null]]
	];


	(* Check that FractionCollectionMode and AbsoluteThreshold or MaxCollectionPeriod are informed together properly *)
	If[!TrueQ[gatherTestsQ]&&!MatchQ[Join[modeInvalidNullOptions,modeInvalidNotNullOptions],{}],
		(
			Message[Error::FractionCollectionMode, resolvedMode, modeInvalidNullOptions, modeInvalidNotNullOptions];
			Message[Error::InvalidOption, Join[modeInvalidNullOptions,modeInvalidNotNullOptions]]
		)
	];

	(* Set up tuples for required and required Null options for test setup *)
	modeOptionRequirementTuples=Switch[resolvedMode,
		Time,
		{{MaxCollectionPeriod},{AbsoluteThreshold,PeakSlope,PeakSlopeDuration,PeakEndThreshold}},
		Peak,
		{{PeakSlope},{AbsoluteThreshold,MaxCollectionPeriod}},
		Threshold,
		{{AbsoluteThreshold},{MaxCollectionPeriod,PeakSlope,PeakSlopeDuration,PeakEndThreshold}}
	];

	(* If mode is set to Time, make sure MaxCollectionPeriod*)
	modeOptionTest=Test["For the collection mode of "<>ToString[resolvedMode]<>", the options "<>ToString[modeOptionRequirementTuples[[1]]]<>" must not be Null and the options "<>ToString[modeOptionRequirementTuples[[2]]]<>" cannot be specified:",
		MatchQ[Join[modeInvalidNullOptions,modeInvalidNotNullOptions],{}],
		True
	];

	(* Join all tests together and cleanse all Nulls *)
	allTests={nameTest, modeOptionTest, startStopTest};

	(* Join all option resolutions *)
	resolvedOps=ReplaceRule[
		listedOps,
		{
			Name -> myName,
			AbsoluteThreshold -> resolvedAbsThreshold,
			FractionCollectionEndTime -> resolvedCollectEnd,
			FractionCollectionMode -> resolvedMode,
			FractionCollectionStartTime -> resolvedCollectStart,
			MaxCollectionPeriod -> resolvedMaxPeriod,
			MaxFractionVolume -> resolvedMaxVol,
			PeakEndThreshold -> resolvedEndThreshold,
			PeakSlope -> resolvedPeakSlope,
			PeakSlopeDuration -> resolvedSlopeDuration
		}
	];

	(* Return the requested outputs *)
	Lookup[myOutputOps, Output] /. {
		Tests -> allTests,
		Result -> resolvedOps
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadFractionCollectionMethodOptions*)


DefineOptions[UploadFractionCollectionMethodOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadFractionCollectionMethod}
];

UploadFractionCollectionMethodOptions[myOps:OptionsPattern[UploadFractionCollectionMethodOptions]]:=UploadFractionCollectionMethodOptions[Null, myOps];
UploadFractionCollectionMethodOptions[myInput:ObjectP[Object[Method, FractionCollection]] | Null, myOps:OptionsPattern[UploadFractionCollectionMethodOptions]]:=Module[
	{listedOps, outOps, options, outputFormat},

	(* gGet the options as a list *)
	listedOps=ToList[myOps];
	outputFormat=OptionValue[OutputFormat];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadFractionCollectionMethod[myInput, Join[outOps, {Output -> Options}]];

	(* Return the option as a list or table *)
	If[MatchQ[outputFormat, Table],
		LegacySLL`Private`optionsToTable[options, UploadFractionCollectionMethod],
		options
	]
];



(* ::Subsubsection::Closed:: *)
(*ValidUploadFractionCollectionMethodQ*)


DefineOptions[ValidUploadFractionCollectionMethodQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadFractionCollectionMethod}
];

ValidUploadFractionCollectionMethodQ[myOps:OptionsPattern[ValidUploadFractionCollectionMethodQ]]:=ValidUploadFractionCollectionMethodQ[Null, myOps];
ValidUploadFractionCollectionMethodQ[myInput:ObjectP[Object[Method, FractionCollection]] | Null, myOps:OptionsPattern[ValidUploadFractionCollectionMethodQ]]:=Module[
	{listedOps, preparedOptions, returnTests, initialTestDescription, allTests, verbose, outputFormat},

	(* Get the options as a list *)
	listedOps=ToList[myOps];

	(* Remove the Output, Verbose option before passing to the core function *)
	preparedOptions=DeleteCases[listedOps, (Output | Verbose | OutputFormat) -> _];

	(* Return only the tests for StoreSamples *)
	returnTests=UploadFractionCollectionMethod[myInput, Join[preparedOptions, {Output -> Tests}]];

	(* Define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* If the option resolution failed, throw an initial test error to indicate some options were provided wrong *)
	allTests=If[MatchQ[returnTests, $Failed],

		(* If the Upload call returned $Failed, provide the general test as an exaplanation *)
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			(* Build the first test *)
			initialTest=Test[initialTestDescription, True, True];

			(* Put it at the front of the tests returned by the earlier Upload call *)
			Prepend[returnTests, initialTest]
		]
	];

	(* Determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadFractionCollectionMethodQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadFractionCollectionMethodQ"]
];


(* ::Subsection::Closed:: *)
(*UploadGradientMethod*)


(* ::Subsubsection::Closed:: *)
(*UploadGradientMethod Options *)


DefineOptions[UploadGradientMethod,
	Options :> {

		(* --- Buffers --- *)
		{
			OptionName -> BufferA,
			Default -> Automatic,
			Description -> "The buffer A used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferB,
			Default -> Automatic,
			Description -> "The buffer B used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferC,
			Default -> Automatic,
			Description -> "The buffer C used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferD,
			Default -> Automatic,
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			Description -> "The buffer D used in the gradient.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferE,
			Default -> Automatic,
			Description -> "The buffer E used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferF,
			Default -> Automatic,
			Description -> "The buffer F used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferG,
			Default -> Automatic,
			Description -> "The buffer G used in the gradient.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},
		{
			OptionName -> BufferH,
			Default -> Automatic,
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified.",
			Description -> "The buffer H used in the gradient.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Model[Sample, StockSolution]}]
			]
		},

		{
			OptionName -> Temperature,
			Default -> Automatic,
			Description -> "The column's temperature at which the gradient is run.",
			ResolutionDescription -> "Automatically resolves from Gradient option if a gradient method object is specified, otherwise resolves to 25 Celsius.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[5 Celsius, 90 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			]
		},

		{
			OptionName -> GradientA,
			Default -> Automatic,
			Description -> "Definition of Buffer A domains in the form {Time, % Buffer A}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientB, GradientC, and GradientD options.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientB,
			Default -> Automatic,
			Description -> "Definition of Buffer B domains in the form {Time, % Buffer B}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientC, and GradientD options. If no other gradient options are specified, a Buffer B gradient of 10% to 100% over 45 minutes is used.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientC,
			Default -> Automatic,
			Description -> "Definition of Buffer C domains in the form {Time, % Buffer C}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, and GradientD options.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientD,
			Default -> Automatic,
			Description -> "Definition of Buffer D domains in the form {Time, % Buffer D}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, and GradientC options.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientE,
			Default -> Automatic,
			Description -> "Definition of Buffer E domains in the form {Time, % Buffer E}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, GradientC, etc. options.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer E Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientF,
			Default -> Automatic,
			Description -> "Definition of Buffer F domains in the form {Time, % Buffer F}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, GradientC, etc. options.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer F Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientG,
			Default -> Automatic,
			Description -> "Definition of Buffer G domains in the form {Time, % Buffer G}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, GradientC, etc. options.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer G Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientH,
			Default -> Automatic,
			Description -> "Definition of Buffer H domains in the form {Time, % Buffer H}.",
			ResolutionDescription -> "Automatically resolves from Gradient option or implicitly resolved from GradientA, GradientB, GradientC, etc. options.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer H Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> FlowRate,
			Default -> Automatic,
			Description -> "The flow rate at which the gradient is run in the form {Time, Flow Rate}.",
			ResolutionDescription -> "Automatically resolves from the Gradient option or, if Gradient is not specified, to 1 mL/min.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Microliter, Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Microliter, Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> Gradient,
			Default -> Automatic,
			Description -> "A list of parameters or a method object that describes a gradient's buffer composition over time. Specific parameters of an object can be overridden by specific options.",
			ResolutionDescription -> "Automatically resolved based on other options in the Gradient category.",
			AllowNull -> False,
			Category -> "Gradient",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, Gradient]]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer E Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer F Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer G Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer H Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> GradientStart,
			Default -> Null,
			Description -> "A shorthand option to specify the starting Buffer B composition. This option must be specified with GradientEnd and GradientDuration.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> GradientEnd,
			Default -> Null,
			Description -> "A shorthand option to specify the final Buffer B composition. This option must be specified with GradientStart and GradientDuration.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> GradientDuration,
			Default -> Null,
			Description -> "A shorthand option to specify the duration of a gradient.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> EquilibrationTime,
			Default -> Null,
			Description -> "A shorthand option to specify the duration of equilibration at the starting buffer composition at the start of a gradient.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> FlushTime,
			Default -> Null,
			Description -> "A shorthand option to specify the duration of Buffer B flush at the end of a gradient.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},

		OutputOption,
		UploadOption
	}
];



(* ::Subsubsection::Closed:: *)
(* Messages *)


Error::ShorthandGradientInvalid="GradientStart, GradientEnd, and GradientDuration must all be specified or all Null.";
Error::FlushTimeInvalid="FlushTime may only be specified if GradientStart, GradientEnd, and GradientDuration are all specified.";
Error::EquilibrationTimeInvalid="EquilibrationTime may only be specified if GradientStart, GradientEnd, and GradientDuration are all specified.";
Error::GradientInvalid="The specified gradient composition does not sum to 100% at all timepoints. Please check your inputs for these options: `1`.";



(* ::Subsubsection::Closed:: *)
(* UploadGradientMethod *)


UploadGradientMethod[myOptions:OptionsPattern[]]:=UploadGradientMethod[Null, myOptions];

UploadGradientMethod[myName:_String | Null, myOptions:OptionsPattern[]]:=Module[{listedOptions, outputSpecification, output,
	gatherTests, safeOptions, safeOptionTests, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests,
	optionsRule, testsRule, resultRule, specifiedGradient, gradientPacket, temperature
},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests}=If[gatherTests,
		SafeOptions[UploadGradientMethod, listedOptions, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[UploadGradientMethod, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Pull out the gradient option *)
	specifiedGradient=Lookup[safeOptions, Gradient];

	(* If the gradient is specified as an object, download stuff about the gradient *)
	gradientPacket=If[MatchQ[specifiedGradient, ObjectP[Object[Method, Gradient]]],
		Download[specifiedGradient, Packet[Temperature, FlowRate, InitialFlowRate, BufferA, BufferB,
			BufferC, BufferD, Gradient, GradientStart, GradientEnd, GradientDuration, EquilibrationTime, FlushTime]],
		{}
	];

	(* Call resolveUploadGradientMethodOptions *)
	(* Check will return $Failed if InvalidInput/InvalidOption is thrown, indicating we can't actually return the standard result *)
	resolvedOptionsResult=Check[
		{resolvedOptions, resolvedOptionsTests}=If[gatherTests,
			resolveUploadGradientMethodOptions[myName, gradientPacket, safeOptions, Output -> {Result, Tests}],
			{resolveUploadGradientMethodOptions[myName, gradientPacket, safeOptions], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* --- Generate rules for each possible Output value ---  *)

	(* Prepare the Options result if we were asked to do so *)
	optionsRule=Options -> If[MemberQ[output, Options],
		Normal[resolvedOptions],
		Null
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests -> If[MemberQ[output, Tests],
		DeleteCases[Flatten[{safeOptionTests, resolvedOptionsTests}], Null],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result -> If[MemberQ[output, Result] && !MatchQ[resolvedOptionsResult, $Failed],
		Module[{gradient, gradientMethodPacket, expandedGradient},

			(* Get the gradient from the resolved options *)
			gradient=Lookup[resolvedOptions, Gradient];

			(*convert to an expanded gradient -- add the columns for E, F, G, and H buffers*)
			(*based on the type that its, we'll convert accordingly*)
			expandedGradient=Switch[gradient,
				Experiment`Private`binaryGradientP,
				Transpose@Nest[Insert[#, Repeat[0 Percent, Length[gradient]], -2] &, Transpose@gradient, 6],
				Experiment`Private`gradientP,
				Transpose@Nest[Insert[#, Repeat[0 Percent, Length[gradient]], -2] &, Transpose@gradient, 4],
				_,
				gradient
			];

			(* Update the temperature if needed *)
			temperature=If[
				MatchQ[Lookup[resolvedOptions, Temperature], Ambient],
				Null,
				Lookup[resolvedOptions, Temperature]
			];

			(* Construct the new gradient method packet *)
			gradientMethodPacket=Association[
				Type -> Object[Method, Gradient],
				Name -> myName,
				Temperature -> temperature,
				InitialFlowRate -> expandedGradient[[1, -1]],
				GradientA -> expandedGradient[[All, {1, 2}]],
				GradientB -> expandedGradient[[All, {1, 3}]],
				GradientC -> expandedGradient[[All, {1, 4}]],
				GradientD -> expandedGradient[[All, {1, 5}]],
				GradientE -> expandedGradient[[All, {1, 6}]],
				GradientF -> expandedGradient[[All, {1, 7}]],
				GradientG -> expandedGradient[[All, {1, 8}]],
				GradientH -> expandedGradient[[All, {1, 9}]],
				FlowRate -> expandedGradient[[All, {1, 10}]],
				BufferA -> Link[Lookup[resolvedOptions, BufferA]],
				BufferB -> Link[Lookup[resolvedOptions, BufferB]],
				BufferC -> Link[Lookup[resolvedOptions, BufferC]],
				BufferD -> Link[Lookup[resolvedOptions, BufferD]],
				BufferE -> Link[Lookup[resolvedOptions, BufferE]],
				BufferF -> Link[Lookup[resolvedOptions, BufferF]],
				BufferG -> Link[Lookup[resolvedOptions, BufferG]],
				BufferH -> Link[Lookup[resolvedOptions, BufferH]],
				Replace[Gradient] -> expandedGradient,
				GradientStart -> Lookup[resolvedOptions, GradientStart],
				GradientEnd -> Lookup[resolvedOptions, GradientEnd],
				GradientDuration -> Lookup[resolvedOptions, GradientDuration],
				EquilibrationTime -> Lookup[resolvedOptions, EquilibrationTime],
				FlushTime -> Lookup[resolvedOptions, FlushTime]
			];

			(* Upload the packets and return the transaction objects, or return the packets *)
			If[Lookup[safeOptions, Upload],
				Upload[gradientMethodPacket],
				gradientMethodPacket
			]
		],
		$Failed
	];

	outputSpecification /. {optionsRule, testsRule, resultRule, Preview -> Null}
];


(* ::Subsubsection::Closed:: *)
(* resolveUploadGradientMethodOptions *)


DefineOptions[resolveUploadGradientMethodOptions,
	Options :> {
		{Output -> Result, ListableP[Result | Tests], "Indicates the return value of the function."}
	}
];


(* ::Subsubsection::Closed:: *)
(* resolveUploadGradientMethodOptions *)


resolveUploadGradientMethodOptions[myName:_String | Null, myGradientPacket:PacketP[Object[Method, Gradient]] | {}, myGradientMethodOptions:{_Rule...}, myOptions:OptionsPattern[resolveUploadGradientMethodOptions]]:=Module[
	{outputSpecification, output, gatherTestsQ, messagesQ, testOrNull, warningOrNull, optionsAssociation, specifiedGradientStart,
		specifiedGradientEnd, specifiedGradientDuration, specifiedGradientA, specifiedGradientB, specifiedGradientC,
		specifiedGradientD, specifiedGradient, specifiedEquilibrationTime, specifiedFlushTime, specifiedFlowRate, specifiedBufferA,
		specifiedBufferB, specifiedBufferC, specifiedBufferD, specifiedTemperature, validNameQ, validNameTest,
		resolvedBufferA, resolvedBufferB, resolvedBufferC, resolvedBufferD, resolvedTemperature, specifiedGradientLookup,
		defaultedFlowRate, gradient, gradientStart, gradientEnd, gradientA, gradientB, gradientC, gradientD,
		flowRate, gradientShorthandTest, gradientOptionTuples, gradientCompositionTestString, gradientCompositionValidQ, gradientCompositionTest,
		resolvedOptions, allTests, requiredTogetherShorthandBools, flushTimeTest, removedExtraTest,
		equilibrationTimeTest, specifiedCompositionOptionNames, roundedOptionsAssociation, nonGradientRoundedOptions,
		nonGradientRoundingTests, gradientOptionsForRounding, roundedGradientOptions, roundedGradientTests, optionsToRound,
		valuesToRoundTo, gradientReturned, removedExtrasQ, invalidInputs, invalidOptions, invalidNameInputs,
		invalidGradientShortHandOptions, flushTimeInvalidOption, equilibrationTimeInvalidOption,
		specifiedGradientE, specifiedGradientF, specifiedGradientG, specifiedGradientH, specifiedBufferE,
		specifiedBufferF, specifiedBufferG, specifiedBufferH, resolvedBufferE, resolvedBufferF, resolvedBufferG, resolvedBufferH,
		semiResolvedGradientA, semiResolvedGradientC, semiResolvedGradientE, semiResolvedGradientG,
		semiResolvedGradientB, semiResolvedGradientD, semiResolvedGradientF, semiResolvedGradientH,
		gradientE, gradientF, gradientG, gradientH
	},

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* Determine if we should throw messages *)
	messagesQ=!gatherTestsQ;

	testOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTestsQ,
		Test[testDescription, True, Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String, passQ:BooleanP]:=If[gatherTestsQ,
		Warning[testDescription, True, Evaluate[passQ]],
		Null
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual *)
	optionsAssociation=Association[myGradientMethodOptions];

	(* specify the option to pass to roundGradientOptions *)
	gradientOptionsForRounding={
		Gradient,
		GradientA,
		GradientB,
		GradientC,
		GradientD,
		GradientE,
		GradientF,
		GradientG,
		GradientH,
		GradientStart,
		GradientEnd,
		FlowRate,
		GradientDuration,
		EquilibrationTime,
		FlushTime
	};

	(*round the gradient relate options*)
	(*use the helper function to round all of the gradient options collectively*)
	{roundedGradientOptions, roundedGradientTests}=Experiment`Private`roundGradientOptions[gradientOptionsForRounding, optionsAssociation, gatherTestsQ,
		FlowRatePrecision -> 10^-3 Milliliter / Minute,
		TimePrecision -> 1 Second
	];

	(* Options which need to be rounded *)
	optionsToRound={
		Temperature
	};

	(* values to round to *)
	valuesToRoundTo={
		1 Celsius
	};

	(* Fetch association with volumes rounded *)
	{nonGradientRoundedOptions, nonGradientRoundingTests}=If[gatherTestsQ,
		RoundOptionPrecision[optionsAssociation, optionsToRound, valuesToRoundTo, Output -> {Result, Tests}],
		{RoundOptionPrecision[optionsAssociation, optionsToRound, valuesToRoundTo], {}}
	];

	(* Join all rounded associations together, with rounded values overwriting existing values *)
	roundedOptionsAssociation=Join[
		optionsAssociation,
		nonGradientRoundedOptions,
		roundedGradientOptions
	];

	(* Pull out specified options *)
	{
		specifiedGradientStart,
		specifiedGradientEnd,
		specifiedGradientDuration,
		specifiedGradientA,
		specifiedGradientB,
		specifiedGradientC,
		specifiedGradientD,
		specifiedGradientE,
		specifiedGradientF,
		specifiedGradientG,
		specifiedGradientH,
		specifiedGradientLookup,
		specifiedEquilibrationTime,
		specifiedFlushTime,
		specifiedFlowRate,
		specifiedBufferA,
		specifiedBufferB,
		specifiedBufferC,
		specifiedBufferD,
		specifiedBufferE,
		specifiedBufferF,
		specifiedBufferG,
		specifiedBufferH,
		specifiedTemperature
	}=Lookup[roundedOptionsAssociation, {
		GradientStart,
		GradientEnd,
		GradientDuration,
		GradientA,
		GradientB,
		GradientC,
		GradientD,
		GradientE,
		GradientF,
		GradientG,
		GradientH,
		Gradient,
		EquilibrationTime,
		FlushTime,
		FlowRate,
		BufferA,
		BufferB,
		BufferC,
		BufferD,
		BufferE,
		BufferF,
		BufferG,
		BufferH,
		Temperature
	}
	];

	(*have to remove duplicate entries after rounding otherwise, things will blow up*)
	specifiedGradient=Which[
		MatchQ[specifiedGradientLookup, ObjectP[]], specifiedGradientLookup,
		MatchQ[specifiedGradientLookup, Except[Automatic]], DeleteDuplicatesBy[specifiedGradientLookup, First[# * 1.] &],
		True, specifiedGradientLookup
	];

	(* ----- Name ----- *)

	(* If the specified Name is not in the database, it is valid *)
	validNameQ=If[MatchQ[myName, _String],
		!DatabaseMemberQ[Object[Method, Gradient, myName]],
		True
	];

	(* Generate Test for Name check *)
	validNameTest=If[validNameQ,
		testOrNull["Name is not already a gradient method name:", True],
		testOrNull["Name is not already a gradient method name:", False]
	];

	(* If Name is invalid, throw error *)
	invalidNameInputs=If[messagesQ && !validNameQ,
		Message[Error::DuplicateName,myName];
		{myName},
		{}
	];


	(* ----- Buffers ----- *)

	(*resolve the buffers from the options*)
	{
		resolvedBufferA,
		resolvedBufferB,
		resolvedBufferC,
		resolvedBufferD,
		resolvedBufferE,
		resolvedBufferF,
		resolvedBufferG,
		resolvedBufferH
	}=MapThread[
		Function[{specifiedOption, fieldName},
			If[!MatchQ[specifiedOption, Automatic],
				specifiedOption,
				If[!NullQ[Lookup[myGradientPacket, fieldName, Null]],
					Download[Lookup[myGradientPacket, fieldName], Object],
					Null
				]
			]
		],
		{
			{specifiedBufferA, specifiedBufferB, specifiedBufferC, specifiedBufferD, specifiedBufferE, specifiedBufferF, specifiedBufferG, specifiedBufferH},
			{ BufferA, BufferB, BufferC, BufferD, BufferE, BufferF, BufferG, BufferH }
		}
	];

	(* ----- Temperature ----- *)
	(* Resolve temperature based on option value, gradient packet, or default to room temp *)
	resolvedTemperature=If[!MatchQ[specifiedTemperature, Automatic],

		(* If option is specified, take option value *)
		specifiedTemperature,

		(* If gradient object is specified, inherit Temperature from gradient object *)
		If[MatchQ[specifiedGradient, ObjectP[Object[Method, Gradient]]],
			Lookup[myGradientPacket, Temperature],

			(* Default to ambient *)
			Ambient
		]
	];

	(* ----- Gradient ----- *)

	(* GradientStart,GradientEnd,GradientDuration must all be provided together *)
	requiredTogetherShorthandBools={MatchQ[specifiedGradientStart, PercentP], MatchQ[specifiedGradientEnd, PercentP], MatchQ[specifiedGradientDuration, TimeP]};

	(*figure out which ones are null if at least one is specified*)
	invalidGradientShortHandOptions=If[!MatchQ[requiredTogetherShorthandBools, {False, False, False} | {True, True, True}],
		If[messagesQ,
			Message[Error::ShorthandGradientInvalid];
		];
		PickList[{GradientStart, GradientEnd, GradientDuration}, Map[Not, requiredTogetherShorthandBools]],
		{}
	];

	gradientShorthandTest=testOrNull["GradientStart, GradientEnd, and GradientDuration are all specified or all Null:",
		Length[invalidGradientShortHandOptions] == 0
	];

	(* FlushTime may only be provided if GradientStart,GradientEnd,GradientDuration are provided *)
	flushTimeInvalidOption=If[!(And @@ requiredTogetherShorthandBools) && MatchQ[specifiedFlushTime, TimeP],
		If[messagesQ, Message[Error::FlushTimeInvalid]];
		{FlushTime},
		{}
	];

	flushTimeTest=testOrNull["FlushTime may only be specified if GradientStart, GradientEnd, and GradientDuration are all specified:",
		Length[flushTimeInvalidOption] == 0
	];

	(* EquilibrationTime may only be provided if GradientStart,GradientEnd,GradientDuration are provided *)
	equilibrationTimeInvalidOption=If[!(And @@ requiredTogetherShorthandBools) && MatchQ[specifiedEquilibrationTime, TimeP],
		If[messagesQ, Message[Error::EquilibrationTimeInvalid]];
		{EquilibrationTime},
		{}
	];

	equilibrationTimeTest=testOrNull["EquilibrationTime may only be specified if GradientStart, GradientEnd, and GradientDuration are all specified:",
		Length[equilibrationTimeInvalidOption] == 0
	];

	(* Extract or default GradientStart values *)
	gradientStart=
		If[MatchQ[{specifiedGradientStart, specifiedGradientEnd, specifiedGradientDuration}, {PercentP, _, _} | {Null, Null, Null | TimeP}],
			(* Explicitly specified or valid Null *)
			specifiedGradientStart,
			(* Default to 0 Percent if something is wrong *)
			0 Percent
		];

	(* Extract or default GradientEnd values *)
	gradientEnd=
		If[MatchQ[{specifiedGradientStart, specifiedGradientEnd, specifiedGradientDuration}, {_, PercentP, _} | {Null, Null, Null | TimeP}],
			(* Explicitly specified or valid Null *)
			specifiedGradientEnd,
			(* Default to starting composition if something is wrong *)
			specifiedGradientStart
		];


	(* If Gradient option is an object, pull Gradient value from packet *)
	gradientOptionTuples=If[MatchQ[specifiedGradient, ObjectP[Object[Method, Gradient]]],
		Lookup[myGradientPacket, Gradient],
		(*expand the gradient if need be*)
		Switch[specifiedGradient,
			Experiment`Private`binaryGradientP,
			Transpose@Nest[Insert[#, Repeat[0 Percent, Length[specifiedGradient]], -2] &, Transpose@specifiedGradient, 6],
			Experiment`Private`gradientP,
			Transpose@Nest[Insert[#, Repeat[0 Percent, Length[specifiedGradient]], -2] &, Transpose@specifiedGradient, 4],
			_,
			specifiedGradient
		]
	];

	(* Default FlowRate to option value, gradient tuple values, or 1mL/min *)
	defaultedFlowRate=If[!MatchQ[specifiedFlowRate, Automatic],
		specifiedFlowRate,
		If[MatchQ[gradientOptionTuples, Experiment`Private`expandedGradientP],
			gradientOptionTuples[[All, {1, -1}]],
			1 Milliliter / Minute
		]
	];

	(*if gradient C, E, or G is set, we want A to go to 0*)
	semiResolvedGradientA=If[MatchQ[specifiedGradientA, Automatic] && MemberQ[{specifiedGradientC, specifiedGradientE, specifiedGradientG}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientA
	];
	semiResolvedGradientC=If[MatchQ[specifiedGradientC, Automatic] && MemberQ[{specifiedGradientA, specifiedGradientE, specifiedGradientG}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientC
	];
	semiResolvedGradientE=If[MatchQ[specifiedGradientE, Automatic] && MemberQ[{specifiedGradientA, specifiedGradientC, specifiedGradientG}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientE
	];
	semiResolvedGradientG=If[MatchQ[specifiedGradientG, Automatic] && MemberQ[{specifiedGradientA, specifiedGradientC, specifiedGradientE}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientG
	];

	(*if gradient D, F, or H is set, we want H to go to 0*)
	semiResolvedGradientB=If[MatchQ[specifiedGradientB, Automatic] && MemberQ[{specifiedGradientD, specifiedGradientF, specifiedGradientH}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientB
	];
	semiResolvedGradientD=If[MatchQ[specifiedGradientD, Automatic] && MemberQ[{specifiedGradientB, specifiedGradientF, specifiedGradientH}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientD
	];
	semiResolvedGradientF=If[MatchQ[specifiedGradientF, Automatic] && MemberQ[{specifiedGradientD, specifiedGradientB, specifiedGradientH}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientF
	];
	semiResolvedGradientH=If[MatchQ[specifiedGradientH, Automatic] && MemberQ[{specifiedGradientD, specifiedGradientF, specifiedGradientB}, GreaterP[0 * Percent]],
		0 Percent,
		specifiedGradientH
	];

	(* For each analyte run, build gradient from gradient-related options *)
	(* If no gradient parameters are specified, use the default gradient *)
	gradientReturned=If[MatchQ[{gradientOptionTuples, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE, semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, gradientStart, gradientEnd, specifiedGradientDuration}, {(Null | Automatic)..}],
		Experiment`Private`resolveGradient[defaultGradient[], semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE, semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedFlowRate, gradientStart, gradientEnd, specifiedGradientDuration, specifiedFlushTime, specifiedEquilibrationTime],
		Experiment`Private`resolveGradient[gradientOptionTuples, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE, semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedFlowRate, gradientStart, gradientEnd, specifiedGradientDuration, specifiedFlushTime, specifiedEquilibrationTime]
	];

	(*remove extra entries*)
	gradient=DeleteDuplicatesBy[gradientReturned, First[# * 1.] &];

	(*if it's not the same note that*)
	removedExtrasQ=Or[!MatchQ[gradientReturned, gradient], !MatchQ[specifiedGradient, specifiedGradientLookup]];

	If[messagesQ && removedExtrasQ,
		Message[Warning::RemovedExtraGradientEntries, {Gradient}]
	];

	(* generate the test testing for this issue *)
	removedExtraTest=If[gatherTestsQ,
		Warning["If Gradient is specified, the gradient entries do not have duplicate times:",
			removedExtrasQ,
			False
		],
		Nothing
	];

	(* If the gradient timepoints' buffer compositions gradient compositions do not equal 100%, it is invalid *)
	gradientCompositionValidQ=MatchQ[Map[Total[#] == 100 Percent &, gradient[[All, {2, 3, 4, 5, 6, 7, 8, 9}]]], {True..}];

	gradientCompositionTestString="Gradient buffer compositions sum to 100% at all timepoints:";
	specifiedCompositionOptionNames=If[!gradientCompositionValidQ,
		PickList[
			{Gradient, GradientA, GradientB, GradientC, GradientD, GradientE, GradientF, GradientG, GradientH, GradientStart, GradientEnd},
			{
				!MatchQ[specifiedGradient, Null | Automatic],
				!MatchQ[specifiedGradientA, Null | Automatic],
				!MatchQ[specifiedGradientB, Null | Automatic],
				!MatchQ[specifiedGradientC, Null | Automatic],
				!MatchQ[specifiedGradientD, Null | Automatic],
				!MatchQ[specifiedGradientE, Null | Automatic],
				!MatchQ[specifiedGradientF, Null | Automatic],
				!MatchQ[specifiedGradientG, Null | Automatic],
				!MatchQ[specifiedGradientH, Null | Automatic],
				!MatchQ[specifiedGradientStart, Null | Automatic],
				!MatchQ[specifiedGradientEnd, Null | Automatic]
			}
		],
		{}
	];
	gradientCompositionTest=If[gradientCompositionValidQ,
		testOrNull[gradientCompositionTestString, True],
		If[messagesQ,
			Message[Error::GradientInvalid, specifiedCompositionOptionNames];
		];
		testOrNull[gradientCompositionTestString, False]
	];

	(* Helper to collapse gradient into single percentage value if the option is Automatic
	and all values are the same at each timepoint *)
	collapseGradient[gradientTimepoints:{{TimeP, PercentP | FlowRateP}...}]:=If[
		SameQ @@ (gradientTimepoints[[All, 2]]),
		gradientTimepoints[[1, 2]],
		gradientTimepoints
	];

	(* Extract the tuples for analytes' GradientA/B/C/D/E/F/G/H and FlowRate *)
	{
		gradientA,
		gradientB,
		gradientC,
		gradientD,
		gradientE,
		gradientF,
		gradientG,
		gradientH
	}=MapIndexed[Function[{gradientSpecification, index},
		If[MatchQ[gradientSpecification, Automatic],
			collapseGradient[gradient[[All, {1, First[index] + 1}]]],
			gradientSpecification
		]
	],
		{
			specifiedGradientA,
			specifiedGradientB,
			specifiedGradientC,
			specifiedGradientD,
			specifiedGradientE,
			specifiedGradientF,
			specifiedGradientG,
			specifiedGradientH
		}
	];

	flowRate=If[MatchQ[specifiedFlowRate, Automatic],
		collapseGradient[gradient[[All, {1, -1}]]],
		specifiedFlowRate
	];

	(* Join resolved Experiment-specific options and resolved shared options *)
	resolvedOptions=Join[
		roundedOptionsAssociation,
		Association[
			BufferA -> resolvedBufferA,
			BufferB -> resolvedBufferB,
			BufferC -> resolvedBufferC,
			BufferD -> resolvedBufferD,
			BufferE -> resolvedBufferE,
			BufferF -> resolvedBufferF,
			BufferG -> resolvedBufferG,
			BufferH -> resolvedBufferH,
			Temperature -> resolvedTemperature,

			FlowRate -> flowRate,
			GradientStart -> gradientStart,
			GradientEnd -> gradientEnd,
			GradientDuration -> specifiedGradientDuration,
			EquilibrationTime -> specifiedEquilibrationTime,
			FlushTime -> specifiedFlushTime,
			Gradient -> gradient,
			GradientA -> gradientA,
			GradientB -> gradientB,
			GradientC -> gradientC,
			GradientD -> gradientD,
			GradientE -> gradientE,
			GradientF -> gradientF,
			GradientG -> gradientG,
			GradientH -> gradientH
		]
	];

	invalidInputs=DeleteDuplicates[Flatten[{
		invalidNameInputs
	}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		invalidGradientShortHandOptions,
		flushTimeInvalidOption,
		equilibrationTimeInvalidOption,
		specifiedCompositionOptionNames
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && messagesQ,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && messagesQ,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Join all tests *)
	allTests=DeleteCases[
		Flatten[{
			ToList[validNameTest],
			ToList[gradientShorthandTest],
			ToList[gradientCompositionTest],
			ToList[flushTimeTest],
			ToList[equilibrationTimeTest],
			roundedGradientTests,
			nonGradientRoundingTests,
			ToList[removedExtraTest]
		}],
		{Null}
	];

	outputSpecification /. {
		Tests -> allTests,
		Result -> resolvedOptions
	}
];


(* ::Subsubsection::Closed:: *)
(* resolveUploadGradientMethod helpers*)


(* This is the default gradient that will be used if all gradient-relation options are Null or Automatic *)
defaultGradient[]:={
	{Quantity[0., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[5., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[30., Minute], Quantity[35., Percent], Quantity[65., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[30.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[35., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[35.1, Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]},
	{Quantity[40., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[1., Milliliter / Minute]}
};



(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodOptions*)


DefineOptions[UploadGradientMethodOptions,
	SharedOptions :> {UploadGradientMethod},
	{
		OptionName -> OutputFormat,
		Default -> Table,
		AllowNull -> False,
		Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Table, List]],
		Description -> "Determines whether the function returns a table or a list of the options."
	}
];

UploadGradientMethodOptions[myOptions:OptionsPattern[]]:=UploadGradientMethodOptions[Null, myOptions];

UploadGradientMethodOptions[myName:_String | Null, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for UploadGradientMethod *)
	options=UploadGradientMethod[myName, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadGradientMethod],
		options
	]

];



(* ::Subsubsection::Closed:: *)
(*UploadGradientMethodPreview*)


DefineOptions[UploadGradientMethodPreview,
	SharedOptions :> {UploadGradientMethod}
];

UploadGradientMethodPreview[myOptions:OptionsPattern[]]:=UploadGradientMethodPreview[Null, myOptions];

UploadGradientMethodPreview[myName:_String | Null, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it does't make sense here *)
	noOutputOptions=DeleteCases[listedOptions, Output -> _];

	(* return only the preview for UploadGradientMethod *)
	UploadGradientMethod[myName, Append[noOutputOptions, Output -> Preview]]

];




(* ::Subsubsection::Closed:: *)
(*ValidUploadGradientMethodQ*)


DefineOptions[ValidUploadGradientMethodQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadGradientMethod}
];

ValidUploadGradientMethodQ[myOptions:OptionsPattern[]]:=ValidUploadGradientMethodQ[Null, myOptions];

ValidUploadGradientMethodQ[myName:_String | Null, myOptions:OptionsPattern[]]:=Module[
	{listedOptions, preparedOptions, uploadGradientMethodTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions=ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions=DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for UploadGradientMethod *)
	uploadGradientMethodTests=UploadGradientMethod[myName, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests=If[MatchQ[uploadGradientMethodTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest=Test[initialTestDescription, True, True];

			(* get all the tests/warnings *)
			Flatten[{initialTest, uploadGradientMethodTests}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=Quiet[OptionDefault[OptionValue[ValidUploadGradientMethodQ, myOptions, {Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadGradientMethodQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadGradientMethodQ"]

];


(* ::Subsection::Closed:: *)
(*UploadJournal*)


(* ::Subsubsection::Closed:: *)
(*Options and Messages*)


DefineOptions[UploadJournal,
	Options :> {
		(* ---Journal Information --- *)
		{
			OptionName -> Synonyms,
			Default -> Null,
			AllowNull -> True,
			Description -> "A list of possible alternative names of this journal.",
			Category -> "Journal Information",
			Widget -> Adder[
				Widget[
					Type -> String,
					Pattern :> _String,
					Size -> Word
				]
			]
		},
		{
			OptionName -> Website,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> URLP,
				Size -> Line,
				PatternTooltip -> "In the format of a valid web address that can include or exclude http://."
			],
			Description -> "The journal's website URL.",
			Category -> "Journal Information"
		},
		{
			OptionName -> SubjectAreas,
			Default -> Null,
			AllowNull -> True,
			Widget -> Adder[
				Widget[
					Type -> Enumeration,
					Pattern :> JournalSubjectAreaP
				]
			],
			Description -> "The main subject areas that this journal contains.",
			Category -> "Journal Information"
		},
		{
			OptionName -> OpenAccess,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates that the articles published in this journal can be accessed for free.",
			Category -> "Journal Information"
		},
		{
			OptionName -> PublicationFrequency,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PublicationFrequencyP
			],
			Description -> "Indicates how often this journal publishes a new issue.",
			Category -> "Journal Information"
		},
		{
			OptionName -> ISSN,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> ISSNP,
				Size -> Word
			],
			Description -> "The international Standard Serial Number (ISSN) for this journal.",
			Category -> "Journal Information"
		},
		{
			OptionName -> OnlineISSN,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> String,
				Pattern :> ISSNP,
				Size -> Word
			],
			Description -> "The online international Standard Serial Number (ISSN-Online) for this journal.",
			Category -> "Journal Information"
		},
		{
			OptionName -> Address,
			Default -> Null,
			AllowNull -> True,
			Description -> "The address of the journal's main offices.",
			Category -> "Journal Information",
			Widget -> Widget[
				Type -> String,
				Pattern :> _String,
				Size -> Line
			]
		},
		{
			OptionName -> Discontinued,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the journal does no longer publish new issues.",
			Category -> "Journal Information"
		},
		UploadOption,
		OutputOption
	}
];


(* ::Subsubsection::Closed:: *)
(*UploadJournal*)


UploadJournal[myName_String, myOps:OptionsPattern[UploadJournal]]:=Module[
	{
		listedOps, safeOps, safeOptionTests, validLengths, validLengthTests, outputSpecification, output, gatherTestsQ, resolvedOps,
		resolvedOptionsTests, resolvedOptionsResult, result, userSpecifiedResolvedOps, allTests
	},

	(* get listed options *)
	listedOps=ToList[myOps];

	(* get SafeOptions *)
	{safeOps, safeOptionTests}=SafeOptions[UploadJournal, listedOps, Output -> {Result, Tests}, AutoCorrect -> False];

	(* check whether all options are the right length *)
	{validLengths, validLengthTests}=ValidInputLengthsQ[UploadJournal, {myName}, listedOps, Output -> {Result, Tests}];

	(* determine the requested return value from the function *)
	outputSpecification=Lookup[safeOps, Output];
	output=ToList[outputSpecification];

	(* If the specified options don't match their patterns return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* If option lengths are invalid return $Failed *)
	If[!validLengths,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOptionTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* check whether we should return Tests *)
	gatherTestsQ=MemberQ[output, Tests];

	(* get resolved options *)
	(* note: if all the specified options are valid, will return the given options *)
	resolvedOptionsResult=Check[
		{resolvedOps, resolvedOptionsTests}=If[gatherTestsQ,
			resolveUploadJournalOptions[myName, safeOps, Output -> {Result, Tests}],
			{resolveUploadJournalOptions[myName, safeOps, Output -> Result], {}}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* get the result *)
	(* note: if something went wrong during option resolving, resolvedOps = $Failed *)
	result=If[And[MemberQ[output, Result], !MatchQ[resolvedOptionsResult, $Failed]],
		Module[{journalObj, journalPkt},

			(* create an ID for Object[Journal] *)
			journalObj=CreateID[Object[Journal]];

			(* get upload packet *)
			journalPkt=<|
				Object -> journalObj,
				Type -> Object[Journal],
				Name -> myName,
				Replace[Synonyms] -> Lookup[resolvedOps, Synonyms],
				Website -> Lookup[resolvedOps, Website],
				Replace[SubjectAreas] -> Lookup[resolvedOps, SubjectAreas],
				OpenAccess -> Lookup[resolvedOps, OpenAccess],
				PublicationFrequency -> Lookup[resolvedOps, PublicationFrequency],
				ISSN -> Lookup[resolvedOps, ISSN],
				OnlineISSN -> Lookup[resolvedOps, OnlineISSN],
				Replace[Address] -> Lookup[resolvedOps, Address],
				Discontinued -> Lookup[resolvedOps, Discontinued]
			|>;

			(* upload the packet if Upload->True *)
			If[TrueQ[Lookup[resolvedOps, Upload]],
				Upload[journalPkt],
				journalPkt
			]
		],
		$Failed
	];

	(* get output options, i.e. remove the hidden options *)
	userSpecifiedResolvedOps=RemoveHiddenOptions[UploadJournal, resolvedOps];

	(* combine all the tests *)
	allTests=Join[safeOptionTests, validLengthTests, resolvedOptionsTests];

	(* output *)
	outputSpecification /. {Preview -> Null, Options -> userSpecifiedResolvedOps, Result -> result, Tests -> allTests}

];


(* ::Subsubsection::Closed:: *)
(*resolveUploadJournalOptions*)


Error::JournalNameAlreadyExists="An Object[Journal] of the Name or Synonym: `1` already exists. Please consider use the existing journal: `2`.";


resolveUploadJournalOptions[
	myName_String,
	myOps:OptionsPattern[UploadJournal],
	myOutputOps:(Output -> CommandBuilderOutputP) | (Output -> {CommandBuilderOutputP ..})]:=Module[
	{listedOps, listedOutputOps, gatherTestsQ, tests, synonyms, website, result, subjectAreas, openAccess, iSSN, onlineISSN, address, publicationFrequency, discontinued, existingJournal},

	(* convert the options into a list *)
	listedOps=ToList[myOps];
	listedOutputOps=ToList[myOutputOps];

	(* get option values *)
	{synonyms, website, subjectAreas, openAccess, iSSN, onlineISSN, address, publicationFrequency, discontinued}=Lookup[listedOps,
		{Synonyms, Website, SubjectAreas, OpenAccess, ISSN, OnlineISSN, Address, PublicationFrequency, Discontinued}];

	(* check whether we are collecting tests *)
	gatherTestsQ=MemberQ[Lookup[listedOutputOps, Output], Tests];

	{tests, result}=Module[{nameTest, nameMsgBool, resolvedSynonyms, resolvedOps},

		(* --- Name Option: check whether the name has been taken --- *)
		existingJournal=Search[Object[Journal], Or[Name == myName, Synonyms == myName]];
		nameMsgBool=MatchQ[existingJournal, {}];

		If[!TrueQ[gatherTestsQ],
			If[!TrueQ[nameMsgBool],
				(
					Message[Error::JournalNameAlreadyExists, myName, existingJournal];
					Message[Error::InvalidInput, Name]
				)
			]
		];

		nameTest=Test["The Journal has not yet been created:",
			nameMsgBool,
			True
		];

		(* Resolve Synonyms *)
		resolvedSynonyms=If[MatchQ[synonyms, Null],
			ToList[myName],
			DeleteDuplicates[Append[synonyms, myName]]
		];

		(* get resolved options *)
		resolvedOps=ReplaceRule[listedOps, {Synonyms -> resolvedSynonyms}];

		(* output the tests and listed options *)
		{{nameTest}, resolvedOps}

	];

	(* return the output *)
	Lookup[myOutputOps, Output] /. {Tests -> tests, Result -> result}

];


(* ::Subsubsection::Closed:: *)
(*UploadJournalOptions*)


DefineOptions[UploadJournalOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {UploadJournal}
];


UploadJournalOptions[myName_String, myOpts:OptionsPattern[UploadJournalOptions]]:=Module[
	{listedOps, outOps, options},

	(* get the options as a list *)
	listedOps=ToList[myOpts];

	outOps=DeleteCases[listedOps, (OutputFormat -> _) | (Output -> _)];

	options=UploadJournal[myName, Join[outOps, {Output -> Options}]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOps, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, UploadJournalOptions],
		options
	]

];


(* ::Subsubsection::Closed:: *)
(*ValidUploadJournalQ*)


DefineOptions[ValidUploadJournalQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {UploadJournal}
];


ValidUploadJournalQ[myName_String, myOpts:OptionsPattern[ValidUploadJournalQ]]:=Module[
	{listedOps, preparedOptions, returnTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOps=ToList[myOpts];

	(* remove the Output, Verbose option before passing to the core function *)
	preparedOptions=DeleteCases[listedOps, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for StoreSamples *)
	returnTests=UploadJournal[myName, Join[preparedOptions, {Output -> Tests}]];

	(* define the general test description *)
	initialTestDescription="All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	allTests=If[MatchQ[returnTests, $Failed],
		{Test[initialTestDescription, False, True]},

		Module[{initialTest},
			initialTest=Test[initialTestDescription, True, True];

			Join[{initialTest}, returnTests]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	{verbose, outputFormat}=OptionDefault[OptionValue[{Verbose, OutputFormat}]];

	(* Run the tests as requested *)
	Lookup[RunUnitTest[<|"ValidUploadJournalQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidUploadJournalQ"]


];



(* ::Subsection::Closed:: *)
(*ExportReport*)


DefineOptions[ExportReport,
	Options :> {
		{
			OptionName -> SaveToCloud,
			Default -> True,
			Description -> "Indicates if the report should be uploaded to Constellation as a cloud file.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> SaveLocally,
			Default -> False,
			Description -> "Indicates if the report should be exported and saved to the input file path.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> SaveToNotebook,
			Default -> False,
			Description -> "Indicates if the report should be saved as a new page in the current laboratory notebook.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> CloseSections,
			Default -> False,
			Description -> "Indicates if the report's sections should be closed.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> Stylesheet,
			Default -> "CommandCenter.nb",
			Description -> "The Mathematica stylesheet containing the font, font size, font color, etc. to use for the newly made notebook.",
			AllowNull -> False,
			Category -> "Method",
			Widget -> Widget[
				Type -> String,
				Pattern :> FilePathP,
				Size -> Line
			]
		}
	}
];

ExportReport::FileExists=" The file `1` already exists. Please choose a different file path.";

(* Core overload take in a list of cell contents or {style, content}s *)
ExportReport[myFileName:FilePathP, myInputs:{({ReportStyleP, _} | _) ..}, myOptions:OptionsPattern[]]:=Module[
	{safeOptions, saveToCloud, saveLocally, saveToNotebook, stylesheet, listedInputs, expandedContentsWithStyles, notebookCells,
		fileName, fileExtension, fileDirectory, filePath, potentiallyClosedNotebookCells, notebook, cloudFile},

	(* --- Get the options --- *)
	safeOptions=SafeOptions[ExportReport, ToList[myOptions]];
	{saveToCloud, saveLocally, saveToNotebook, stylesheet}=Lookup[safeOptions, {SaveToCloud, SaveLocally, SaveToNotebook, Stylesheet}];


	(* --- Assemble the notebook contents --- *)

	(* Get each input into a list *)
	listedInputs=ToList /@ myInputs;

	(* If an input contains a list of contents, put each content in its own cell with the designated style for those contents.
	 	If a style is specified for that list of contents, use the specified style.
	 	Otherwise, use Text if the content is a string and Output otherwise. *)
	expandedContentsWithStyles=Flatten[
		Map[Function[section,
			If[MatchQ[section, {ReportStyleP, ___}],
				Map[{ToString[section[[1]]], #}&, Drop[section, 1]],
				Map[{If[MatchQ[#, _String], "Text", "Output"], #}&, section]
			]
		], listedInputs
		], 1];

	(* Assemble the notebook cells. *)
	notebookCells=Map[Function[section,
		Cell[
			(* If the contents are not text, put them in a box *)
			If[MatchQ[section[[2]], _String],
				section[[2]],
				BoxData[ToBoxes[section[[2]]]]
			],
			(* Use the specified style *)
			ToString[section[[1]]]
		]], expandedContentsWithStyles];


	(* --- Assemble the file path --- *)

	(* Figure out the file name. (They may have given us the file name with or without an extension and with or without a path.) *)
	fileName=FileBaseName[myFileName];

	(* Figure out the file extension. If they gave us one, use it. Otherwise, use .nb. *)
	fileExtension=With[{extension=FileExtension[myFileName]},
		If[MatchQ[extension, ""],
			"nb",
			extension
		]
	];

	(* Figure out the directory. If they gave us a directory AND they want us to save the file locally, use it. Otherwise, use $TemporaryDirectory. *)
	fileDirectory=With[{directory=DirectoryName[myFileName]},
		If[MatchQ[directory, ""] || MatchQ[saveLocally, False],
			$TemporaryDirectory,
			directory
		]
	];

	(* Assemble the full file path *)
	filePath=FileNameJoin[{fileDirectory, StringJoin[fileName, ".", fileExtension]}];

	(* If the directory does not exist, make the directory.
		(The directory path is $TemporaryDirectory if we are not saving locally, even if they gave us a directory,
		so we don't need to worry about making a directory that needs to be cleaned up later.)
	*)
	If[!DirectoryQ[fileDirectory],
		CreateDirectory[fileDirectory]
	];

	(* Check that the file does not already exist. If it does, throw an error and stop here. *)
	If[FileExistsQ[filePath] && (TrueQ[saveLocally] || !MatchQ[fileDirectory,$TemporaryDirectory]),
		Message[ExportReport::FileExists, filePath];
		Return[$Failed]
	];

	(* Export the notebook to the file path.
			We can't export PDFs, so first export as a .nb and use NotebookPrint to export as a pdf.
			(NotebookPrint works on just the Notebook[...] input in a normal notebook, but not in a CommandCenter notebook, so we include the extra steps of exporting as a .nd first.)
			(Even if SaveLocally is False, we still need to do this to make the cloud file. We are exporting to $TemporaryDirectory in this case.) *)
	If[StringMatchQ[fileExtension, "pdf", IgnoreCase -> True],
		Module[{exportedNb},
			(* Export as a notebook *)
			Export[filePath<>".nb", Notebook[notebookCells, StyleDefinitions -> stylesheet]];
			(* Open the notebook to get the notebook object *)
			exportedNb=NotebookOpen[filePath<>".nb"];
			(* NotebookPrint to essentially export the pdf *)
			NotebookPrint[exportedNb, filePath];
			(* Close the notebook *)
			NotebookClose[exportedNb];
			(* Delete the .nb file that we exported *)
			Quiet[DeleteFile[filePath<>".nb"]];
		],
		Export[filePath, Notebook[notebookCells]]
	];
	
	potentiallyClosedNotebookCells = If[TrueQ[Lookup[safeOptions,CloseSections]],
		Map[
			If[MatchQ[First[#],Cell[_,("Section")]],
				Cell[CellGroupData[#,Closed]],
				#
			]&,
			Split[notebookCells,!MatchQ[#2,Cell[_,("Section")]]&]
		],
		notebookCells
	];

	(* Export the notebook to the file path.
		(Even if SaveLocally is False, we still need to do this to make the cloud file. We are exporting to $TemporaryDirectory in this case.) *)
	notebook = Notebook[potentiallyClosedNotebookCells, StyleDefinitions -> stylesheet];
	Export[filePath,notebook];

	(* If SaveToCloud or SaveToNotebook is True, call UploadCloudFile. (We need to make a cloud file to save it to the notebook.) *)
	cloudFile=If[TrueQ[saveToCloud] || TrueQ[saveToNotebook],
		UploadCloudFile[filePath]
	];

	(* If SaveToNotebook is True, call OpenCloudFile. This will open the report in a new tab in the current notebook. *)
	If[TrueQ[saveToNotebook],
		OpenCloudFile[cloudFile]
	];

	(* If SaveLocally is false, try to delete the exported file.
		Quiet error messages (e.g. if we don't have permissions) since this is not essential, just a nice thing to do so we don't clutter the user's computer.
		We always use $TemporaryDirectory in these cases, so we don't need to worry about deleting the directory as well.
	*)
	If[MatchQ[saveLocally, False],
		Quiet[DeleteFile[filePath]]
	];

	(* Return the file path if SaveLocally was True and cloud file if SaveToCloud was True. Otherwise just return Null. (We are already opening a notebook if saveToNotebook is True.) *)
	Switch[{saveLocally, saveToCloud},
		{True, True}, {filePath, cloudFile},
		{True, _}, filePath,
		{_, True}, cloudFile,
		___, Null
	]
];


(* ::Subsection::Closed:: *)
(*UploadSite*)


DefineOptions[UploadSite,
	Options :> {
		{
			OptionName -> DefaultMailingAddress,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> True | Null],
			Description -> "Indicates if the address in this site is the default address used for shipping samples to/from the team.",
			ResolutionDescription -> "For new sites, if the team does not have DefaultMailingAddress populated, this option is automatically set to True; otherwise, it is set to Null. For existing sites, this option is automatically set to Null to indicate that the team's DefaultMailingAddress will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> BillingAddress,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Enumeration, Pattern :> True | Null],
			Description -> "Indicates if the address in this site is the billing address for the team.",
			Category -> "General",
			ResolutionDescription -> "For new sites, if the team does not have BillingAddress populated and the user is team administrator, this option is automatically set to True; otherwise, it is set to Null. For existing sites, this option is automatically set to Null to indicate that the team's BillingAddress will not be changed."
		},
		{
			OptionName -> StreetAddress,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> StreetAddressP, Size -> Line, PatternTooltip -> "Maximum length is 35 characters."],
			Description -> "The street address where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the street address of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> City,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> CityP, Size -> Word, PatternTooltip -> "Maximum length is 30 characters."],
			Description -> "The city where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the city of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> State,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> UnitedStateAbbreviationP | AustralianStatesP | MalaysianStatesP, Size -> Word, PatternTooltip -> "Two letter all-caps state abbreviation for the US, full form of the state or territory for Australia and Malaysia."],
			Description -> "The state where this site is located: two letter abbreviation of the US and full form for Australia and Malaysia.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the state of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> Province,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> CanadianProvincesP, Size -> Word, PatternTooltip -> "Full form of canadian province name."],
			Description -> "The province where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the province of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> Locality,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> LocalityP, Size -> Word, PatternTooltip -> "Maximum length is 30 characters."],
			Description -> "The locality where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the locality of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> County,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> CountyP, Size -> Word, PatternTooltip -> "Maximum length is 30 characters."],
			Description -> "The county where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the county of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> PostalCode,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> PostalCodeP, Size -> Word, PatternTooltip -> "The digit dip code."],
			Description -> "The postal code where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the postal code code of the site will not be changed",
			Category -> "General"
		},
		{
			OptionName -> Country,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> CountryP, Size -> Word, PatternTooltip -> "The country which SLL supports shipping to."],
			Description -> "The country where this site is located.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the country of the site will not be changed.",
			Category -> "General"
		},
		{
			OptionName -> PhoneNumber,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> PhoneNumberP, Size -> Word, PatternTooltip -> "In the format XXX-XXX-XXXX."],
			Description -> "The phone number of this site.",
			ResolutionDescription -> "This option is required for new sites. For existing sites, this option is automatically set to Null to indicate that the phone number of the site will not be changed",
			Category -> "General"
		},
		{
			OptionName -> AttentionName,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> AttentionNameP, Size -> Line, PatternTooltip -> "Maximum length is 35 characters."],
			Description -> "The person to whom packages should be addressed when shipping to this site.",
			Category -> "General"
		},
		{
			OptionName -> CompanyName,
			Default -> Null,
			AllowNull -> True,
			Widget -> Widget[Type -> String, Pattern :> CompanyNameP, Size -> Line, PatternTooltip -> "Maximum length is 35 characters."],
			Description -> "The company to whom packages should be addressed when shipping to this site.",
			Category -> "General"
		},
		{
			OptionName -> Notebook,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[Type -> Object, Pattern :> ListableP[ObjectP[Object[LaboratoryNotebook]]]],
			Description -> "The notebook to link this site to.",
			ResolutionDescription -> "For new sites, this option is automatically set to the first notebook in the list of teams. For existing sites, this option is automatically set to Null to indicate that the notebook of the site will not be changed",
			Category -> "Hidden"
		},
		NameOption,
		UploadOption,
		OutputOption,
		CacheOption
	}
];

Error::OptionsRequired="The options `1` must be specified when creating a new site. Please specify these options.";
Error::NotebookOwnership="The specified notebook `1` does not belong to the input team. Please select a notebook that belongs to the input team, or allow this option to be automatically set.";
Error::InvalidBillingAddressOption="Only team administrators are allowed to set the billing address of the team. Please have a team administrator set the billing address, or allow this option to be automatically set.";
Error::BillingAddressPermissions="Only team administrators are allowed to edit the billing address of the team. Please have a team administrator edit the billing address, or choose another address to edit.";

(*lookup table for the required fields for each country*)
RequiredCountryFieldsLookup=<|
	"Australia" -> {StreetAddress, PostalCode, State, City},
	"Austria" -> {StreetAddress, PostalCode, City},
	"Belgium" -> {StreetAddress, PostalCode, City},
	"Canada" -> {StreetAddress, PostalCode, Province, City},
	"Czech Republic" -> {StreetAddress, PostalCode, City},
	"Denmark" -> {StreetAddress, PostalCode, City},
	"Finland" -> {StreetAddress, PostalCode, City},
	"France" -> {StreetAddress, PostalCode, City},
	"Germany" -> {StreetAddress, PostalCode, City},
	"Greece" -> {StreetAddress, PostalCode, City},
	"Hungary" -> {StreetAddress, PostalCode, City},
	"Italy" -> {StreetAddress, PostalCode, City},
	"Luxembourg" -> {StreetAddress, PostalCode, City},
	"Malaysia" -> {StreetAddress, PostalCode, State, Locality},
	"Netherlands" -> {StreetAddress, PostalCode, City},
	"Norway" -> {StreetAddress, PostalCode, City},
	"Poland" -> {StreetAddress, PostalCode, City},
	"Portugal" -> {StreetAddress, PostalCode, City},
	"Puerto Rico" -> {StreetAddress, PostalCode, City},
	"Ireland" -> {StreetAddress, PostalCode, Locality, County},
	"Romania" -> {StreetAddress, PostalCode, City},
	"Spain" -> {StreetAddress, PostalCode, City},
	"Sweden" -> {StreetAddress, PostalCode, City},
	"Switzerland" -> {StreetAddress, PostalCode, City},
	"United Kingdom" -> {StreetAddress, PostalCode, City, Locality, County},
	"United States" -> {StreetAddress, PostalCode, State, City}
|>;

StatePatternLookup=<|
	"Australia" -> AustralianStatesP,
	"Austria" -> Null,
	"Belgium" -> Null,
	"Canada" -> Null,
	"Czech Republic" -> Null,
	"Denmark" -> Null,
	"Finland" -> Null,
	"France" -> Null,
	"Germany" -> Null,
	"Greece" -> Null,
	"Hungary" -> Null,
	"Italy" -> Null,
	"Luxembourg" -> Null,
	"Malaysia" -> MalaysianStatesP,
	"Netherlands" -> Null,
	"Norway" -> Null,
	"Poland" -> Null,
	"Portugal" -> Null,
	"Puerto Rico" -> Null,
	"Ireland" -> Null,
	"Romania" -> Null,
	"Spain" -> Null,
	"Sweden" -> Null,
	"Switzerland" -> Null,
	"United Kingdom" -> Null,
	"United States" -> UnitedStateAbbreviationP
|>;

ProvincePatternLookup=<|
	"Australia" -> Null,
	"Austria" -> Null,
	"Belgium" -> Null,
	"Canada" -> CanadianProvincesP,
	"Czech Republic" -> Null,
	"Denmark" -> Null,
	"Finland" -> Null,
	"France" -> Null,
	"Germany" -> Null,
	"Greece" -> Null,
	"Hungary" -> Null,
	"Italy" -> Null,
	"Luxembourg" -> Null,
	"Malaysia" -> Null,
	"Netherlands" -> Null,
	"Norway" -> Null,
	"Poland" -> Null,
	"Portugal" -> Null,
	"Puerto Rico" -> Null,
	"Ireland" -> Null,
	"Romania" -> Null,
	"Spain" -> Null,
	"Sweden" -> Null,
	"Switzerland" -> Null,
	"United Kingdom" -> Null,
	"United States" -> Null
|>;



(* Authors definition for GetAddressLookupTableJSON *)
Authors[GetAddressLookupTableJSON]:={"platform"};

GetAddressLookupTableJSON[]:=Module[{countries, requiredCountryFields, statePattern, provincePattern},
	countries=List @@ CountryP;

	requiredCountryFields=Association[
		KeyValueMap[
			If[! NullQ[#2],
				#1 -> Map[ToString@# &, #2],
				Nothing
			]&,
			RequiredCountryFieldsLookup
		]
	];

	statePattern=Association[
		KeyValueMap[
			If[!NullQ[#2],
				#1 -> List @@ #2,
				Nothing
			]&,
			StatePatternLookup
		]
	];

	provincePattern=Association[
		KeyValueMap[
			If[!NullQ[#2],
				#1 -> List @@ #2,
				Nothing
			]&,
			ProvincePatternLookup
		]
	];

	ExportJSON[<|
		"countryList" -> countries,
		"requiredCountryFields" -> requiredCountryFields,
		"statePattern" -> statePattern,
		"provincePattern" -> provincePattern
	|>]
];

(* Overload for making a new site *)
UploadSite[team:ObjectP[Object[Team, Financing]], myOptions:OptionsPattern[]]:=Module[{
	listedOptions, outputSpecification, output, gatherTests, safeOps, safeOpsTests, sitePacket, teamPacket, uploadPackets,
	uploadResult, downloadedStuff, cacheBall, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests}=If[gatherTests,
		SafeOptions[UploadSite, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[UploadSite, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* single download call *)
	downloadedStuff=Download[team, Packet[NotebooksFinanced, DefaultMailingAddress, BillingAddress, Administrators], Cache -> (Cache /. safeOps)];

	(* Download dump *)
	cacheBall=Join[(Cache /. safeOps), Cases[Flatten[{downloadedStuff}], PacketP[]]];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests}=resolveUploadSiteOptions[team, safeOps, Cache -> cacheBall, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests}={resolveUploadSiteOptions[team, safeOps, Cache -> cacheBall], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[UploadSite, resolvedOptions],
			Preview -> Null
		}]
	];

	(* Generate a site with the required VOQ information *)
	sitePacket=<|
		Type -> Object[Container, Site],
		Object -> CreateID[Object[Container, Site]],
		Name -> Lookup[resolvedOptions, Name],
		StreetAddress -> Lookup[resolvedOptions, StreetAddress],
		City -> Lookup[resolvedOptions, City],
		State -> Lookup[resolvedOptions, State],
		Province -> Lookup[resolvedOptions, Province],
		Locality -> Lookup[resolvedOptions, Locality],
		County -> Lookup[resolvedOptions, County],
		Country -> Lookup[resolvedOptions, Country],
		PostalCode -> Lookup[resolvedOptions, PostalCode],
		PhoneNumber -> Lookup[resolvedOptions, PhoneNumber],
		AttentionName -> Lookup[resolvedOptions, AttentionName],
		CompanyName -> Lookup[resolvedOptions, CompanyName],
		Model -> Link[Model[Container, Site, "Generic model site"], Objects],
		Transfer[Notebook] -> Link[Lookup[resolvedOptions, Notebook], Objects],
		Replace[Teams] -> {Link[team, Sites]},
		Status -> Available,
		Append[StatusLog] -> {{Now, Available, Link[$PersonID]}},
		DateLastUsed -> Now,
		DateLastUsed -> Now,
		DateUnsealed -> Now
	|>;

	(* If the DefaultMailingAddress or BillingAddress option is True, populate the address info for the team and link it to the site *)
	teamPacket=If[TrueQ[Lookup[resolvedOptions, DefaultMailingAddress]] || TrueQ[Lookup[resolvedOptions, BillingAddress]],
		<|
			Object -> team,
			If[TrueQ[Lookup[resolvedOptions, DefaultMailingAddress]],
				DefaultMailingAddress -> Link[Lookup[sitePacket, Object]],
				Nothing
			],
			If[TrueQ[Lookup[resolvedOptions, BillingAddress]],
				BillingAddress -> Link[Lookup[sitePacket, Object]],
				Nothing
			]
		|>,
		Nothing
	];

	(* If we are uploading, upload. Just return the uploaded site, not the team that was changed. *)
	uploadPackets=Flatten[{sitePacket, teamPacket}];
	uploadResult=If[Lookup[safeOps, Upload],
		Upload[uploadPackets];Lookup[sitePacket, Object],
		uploadPackets
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> uploadResult,
		Tests -> Flatten[{safeOpsTests, resolvedOptionsTests}],
		Options -> RemoveHiddenOptions[UploadSite, resolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(*resolveUploadSiteOptions - making new site *)


DefineOptions[
	resolveUploadSiteOptions,
	Options :> {HelperOutputOption, CacheOption}
];

(* Overload for making a new site *)
resolveUploadSiteOptions[team:ObjectP[Object[Team, Financing]], myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveUploadSiteOptions]]:=Module[
	{outputSpecification, output, gatherTests, cache, admins, isAdmin, resolvedBilling, resolvedMailing, nameOption, nameUniquenessTest, nameInUse,
		currentMailing, currentBilling, requiredOptionSymbols, nullRequiredOptions, addressOptionsTest, notebookValid, resolvedNotebook,
		notebookValidTest, notebooks, notebookOption, invalidInputs, invalidOptions, invalidBillingPermissions,
		billingPermissionTest},

	(* Determine the requested output format of this function. *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache=Quiet[OptionValue[Cache]];

	(* Extract the packets that we need from our downloaded cache. *)
	{notebooks, currentMailing, currentBilling, admins}=Download[team, {NotebooksFinanced[Object], DefaultMailingAddress[Object], BillingAddress[Object], Administrators[Object]}, Cache -> cache];

	(* - Address Options Validation -*)

	(* Address-related options are non-optional for this overload. Find any that are Null and throw an error or make a test. *)
	requiredOptionSymbols={StreetAddress, City, State, PostalCode, PhoneNumber};
	nullRequiredOptions=If[MatchQ[Lookup[myOptions, #], Alternatives[Null, Automatic]], #, Nothing] & /@ {StreetAddress, City, Country, PostalCode, PhoneNumber};

	If[Length[nullRequiredOptions] != 0 && !gatherTests,
		Message[Error::OptionsRequired, nullRequiredOptions]
	];

	addressOptionsTest=If[gatherTests,
		If[Length[nullRequiredOptions] != 0,
			Test["Address-related options are all specified.", True, False],
			Test["Address-related options are all specified.", True, True]
		],
		Nothing
	];

	(* - Notebook Validation -*)

	(* We have to link the site to a notebook so that the team has permissions for the site object. Error if there are no notebooks. *)
	notebookOption=Lookup[myOptions, Notebook];
	notebooks=Download[team, NotebooksFinanced[Object]];

	(* If a notebook option was specified, validate that the notebook belongs to the team. Since this is a hidden option, only make a test if it was specified. *)
	notebookValid=MatchQ[notebookOption, Automatic] || MemberQ[notebooks, notebookOption];

	notebookValidTest=If[notebookValid,

		(* Give a passing test or do nothing if the notebook belongs to the team. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[notebookOption],
			Test["The specified notebook belongs to the team.", True, True],
			Nothing
		],

		(* Give a failing test or throw a message if the user specified a notebook that does not belong to the team *)
		If[gatherTests,
			Test["The specified notebook belongs to the team.", False, True],
			Message[Error::NotebookOwnership, notebookOption];
			Nothing
		]
	];

	(* If a notebook was specified (hidden option), use that notebook. Otherwise, link to the first notebook owned by the team. *)
	resolvedNotebook=If[MatchQ[notebookOption, Automatic],
		FirstOrDefault[notebooks],
		notebookOption
	];

	(* - Name Validation -*)

	(* Get the name option *)
	nameOption=Lookup[myOptions, Name];

	(* Check if the name is used already. *)
	nameInUse=TrueQ[DatabaseMemberQ[Append[Object[Container, Site], nameOption]]];

	nameUniquenessTest=If[nameInUse,

		(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.", False, True],
			Message[Error::DuplicateName, Object[Container, Site]];
			Nothing
		],

		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[nameOption],
			Test["The specified name is unique.", True, True],
			Nothing
		]
	];

	(* - Default Billing/Mailing Resolution -*)

	(* Only admins are allowed to set the billing address *)
	isAdmin=MemberQ[admins, $PersonID] || MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]];

	(* If the user is not an admin and the set BillingAddress to True, error *)
	invalidBillingPermissions=!isAdmin && TrueQ[Lookup[myOptions, BillingAddress]];

	If[invalidBillingPermissions && !gatherTests,
		Message[Error::InvalidBillingAddressOption]
	];

	billingPermissionTest=If[gatherTests,
		If[invalidBillingPermissions,
			Test["If billing address is being set, it is done by a team administrator:", True, False],
			Test["If billing address is being set, it is done by a team administrator:", True, True]
		],
		Nothing
	];

	(* If BillingAddress is non populated for the team and the person is not an admin, resolve to True, otherwise, resolve to False *)
	resolvedBilling=If[MatchQ[Lookup[myOptions, BillingAddress], Automatic],
		NullQ[currentBilling] && isAdmin,
		Lookup[myOptions, BillingAddress]
	];

	(* If DefaultMailingAddress is populated for the team, resolve to False, otherwise, resolve to True *)
	resolvedMailing=If[MatchQ[Lookup[myOptions, DefaultMailingAddress], Automatic],
		NullQ[currentMailing],
		Lookup[myOptions, DefaultMailingAddress]
	];

	(* Throw a single InvalidOptions error if applicable *)
	invalidOptions=Flatten[{nullRequiredOptions, If[nameInUse, Name, Nothing], If[!notebookValid, Notebook, Nothing], If[invalidBillingPermissions, BillingAddress, Nothing]}];
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Throw a single InvalidInput error if applicable *)
	invalidInputs=Flatten[{If[Length[notebooks] == 0, team, Nothing]}];
	If[!gatherTests && Length[invalidInputs] > 0,
		Message[Error::InvalidInput, invalidInputs]
	];

	(* Return the resolved options and/or tests. *)
	outputSpecification /. {
		Result -> ReplaceRule[myOptions, {
			DefaultMailingAddress -> resolvedMailing,
			BillingAddress -> resolvedBilling,
			Notebook -> resolvedNotebook
		}],
		Tests -> Flatten[{addressOptionsTest, notebookValidTest, nameUniquenessTest, billingPermissionTest}]
	}
];


(* Overload for editing an existing site *)
UploadSite[team:ObjectP[Object[Team, Financing]], site:ObjectP[Object[Container, Site]], myOptions:OptionsPattern[]]:=Module[{
	listedOptions, outputSpecification, output, gatherTests, safeOps, safeOpsTests, sitePacket, teamPacket, uploadPackets,
	uploadResult, downloadedStuff, cacheBall, resolvedOptionsResult, resolvedOptions, resolvedOptionsTests},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOps, safeOpsTests}=If[gatherTests,
		SafeOptions[UploadSite, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[UploadSite, listedOptions, AutoCorrect -> False], {}}
	];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* single download call *)
	downloadedStuff=Download[site, Packet[Teams[{Administrators, NotebooksFinanced, BillingAddress}]], Cache -> (Cache /. safeOps)];

	(* Download dump *)
	cacheBall=Join[(Cache /. safeOps), Cases[Flatten[{downloadedStuff}], PacketP[]]];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests}=resolveUploadSiteOptions[site, safeOps, Cache -> cacheBall, Output -> {Result, Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			{resolvedOptions, resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests}={resolveUploadSiteOptions[site, safeOps, Cache -> cacheBall], {}},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[UploadSite, resolvedOptions],
			Preview -> Null
		}]
	];

	(* Generate a site with the required VOQ information *)
	sitePacket=<|
		Object -> Download[site, Object],
		If[NullQ[Lookup[resolvedOptions, Name]], Nothing, Name -> Lookup[resolvedOptions, Name]],
		If[NullQ[Lookup[resolvedOptions, StreetAddress]], Nothing, StreetAddress -> Lookup[resolvedOptions, StreetAddress]],
		If[NullQ[Lookup[resolvedOptions, City]], Nothing, City -> Lookup[resolvedOptions, City]],
		If[NullQ[Lookup[resolvedOptions, State]], Nothing, State -> Lookup[resolvedOptions, State]],
		If[NullQ[Lookup[resolvedOptions, Province]], Nothing, Province -> Lookup[resolvedOptions, Province]],
		If[NullQ[Lookup[resolvedOptions, Locality]], Nothing, Locality -> Lookup[resolvedOptions, Locality]],
		If[NullQ[Lookup[resolvedOptions, County]], Nothing, County -> Lookup[resolvedOptions, County]],
		If[NullQ[Lookup[resolvedOptions, Country]], Nothing, Country -> Lookup[resolvedOptions, Country]],
		If[NullQ[Lookup[resolvedOptions, PostalCode]], Nothing, PostalCode -> Lookup[resolvedOptions, PostalCode]],
		If[NullQ[Lookup[resolvedOptions, AttentionName]], Nothing, AttentionName -> Lookup[resolvedOptions, AttentionName]],
		If[NullQ[Lookup[resolvedOptions, CompanyName]], Nothing, CompanyName -> Lookup[resolvedOptions, CompanyName]],
		If[NullQ[Lookup[resolvedOptions, Notebook]], Nothing, Transfer[Notebook] -> Link[Lookup[resolvedOptions, Notebook], Objects]],
		If[NullQ[Lookup[resolvedOptions, StreetAddress]], Nothing, StreetAddress -> Lookup[resolvedOptions, StreetAddress]],
		If[NullQ[Lookup[resolvedOptions, PhoneNumber]], Nothing, PhoneNumber -> Lookup[resolvedOptions, PhoneNumber]]
	|>;

	(* If the DefaultMailingAddress or BillingAddress option is True, populate the address info for the team and link it to the site *)
	teamPacket=If[TrueQ[Lookup[resolvedOptions, DefaultMailingAddress]] || TrueQ[Lookup[resolvedOptions, BillingAddress]],
		<|
			Object -> team,
			If[TrueQ[Lookup[resolvedOptions, DefaultMailingAddress]],
				DefaultMailingAddress -> Link[Lookup[sitePacket, Object]],
				Nothing
			],
			If[TrueQ[Lookup[resolvedOptions, BillingAddress]],
				BillingAddress -> Link[Lookup[sitePacket, Object]],
				Nothing
			]
		|>,
		Nothing];

	(* If we are uploading, upload. Just return the uploaded site, not the team that was changed. *)
	uploadPackets=Flatten[{sitePacket, teamPacket}];
	uploadResult=If[Lookup[safeOps, Upload],
		Upload[uploadPackets];Lookup[sitePacket, Object],
		uploadPackets
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> uploadResult,
		Tests -> Flatten[{safeOpsTests, resolvedOptionsTests}],
		Options -> RemoveHiddenOptions[UploadSite, resolvedOptions],
		Preview -> Null
	}
];


(* ::Subsubsection:: *)
(*resolveUploadSiteOptions *)


DefineOptions[
	resolveUploadSiteOptions,
	Options :> {HelperOutputOption, CacheOption}
];

(* Overload for editing an existing site *)
resolveUploadSiteOptions[site:ObjectP[Object[Container, Site]], myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveUploadSiteOptions]]:=Module[
	{outputSpecification, output, gatherTests, cache, admins, isAdmin, nameOption, nameUniquenessTest, nameInUse, notebookValid, notebooks, notebookValidTest, notebookOption, invalidOptions, billingPermissionTest, billingAddresses, invalidBillingOptionValue, billingOptionTest, invalidBillingSiteEdit},

	(* Determine the requested output format of this function. *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests=MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache=Quiet[OptionValue[Cache]];

	(* Extract the info that we need from our downloaded cache. *)
	{admins, notebooks, billingAddresses}=Flatten /@ Download[site, {Teams[Administrators][Object], Teams[NotebooksFinanced][Object], Teams[BillingAddress][Object]}, Cache -> cache];

	(* - Notebook Validation -*)

	(* If a notebook option was specified, validate that the notebook belongs to the team. Since this is a hidden option, only make a test if it was specified. *)
	notebookOption=Lookup[myOptions, Notebook];
	notebookValid=MatchQ[notebookOption, Automatic] || MemberQ[notebooks, notebookOption];

	notebookValidTest=If[notebookValid,

		(* Give a passing test or do nothing if the notebook belongs to the team. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[notebookOption],
			Test["The specified notebook belongs to the team.", True, True],
			Nothing
		],

		(* Give a failing test or throw a message if the user specified a notebook that does not belong to the team *)
		If[gatherTests,
			Test["The specified notebook belongs to the team.", False, True],
			Message[Error::NotebookOwnership, notebookOption];
			Nothing
		]
	];

	(* - Name Validation -*)

	(* Get the name option *)
	nameOption=Lookup[myOptions, Name];

	(* Check if the name is used already. *)
	nameInUse=TrueQ[DatabaseMemberQ[Append[Object[Container, Site], nameOption]]];

	nameUniquenessTest=If[nameInUse,

		(* Give a failing test or throw a message if the user specified a name that is in use *)
		If[gatherTests,
			Test["The specified name is unique.", False, True],
			Message[Error::DuplicateName, Object[Container, Site]];
			Nothing
		],

		(* Give a passing test or do nothing otherwise. If the user did not specify a name, do nothing since this test is irrelevant. *)
		If[gatherTests && !NullQ[nameOption],
			Test["The specified name is unique.", True, True],
			Nothing
		]
	];

	(* - Billing Validation -*)

	(* Only admins are allowed to set the billing address *)
	isAdmin=MemberQ[admins, $PersonID] || MatchQ[$PersonID, ObjectP[Object[User, Emerald, Developer]]];

	(* If the user is not an admin and they set BillingAddress to True, error *)
	invalidBillingOptionValue=!isAdmin && TrueQ[Lookup[myOptions, BillingAddress]];

	If[invalidBillingOptionValue && !gatherTests,
		Message[Error::InvalidBillingAddressOption]
	];

	billingOptionTest=If[gatherTests,
		If[invalidBillingOptionValue,
			Test["If billing address is being set, it is done by a team administrator:", True, False],
			Test["If billing address is being set, it is done by a team administrator:", True, True]
		],
		Nothing
	];

	(* If the user is not an admin and site they are trying to edit is a billing address, error *)
	invalidBillingSiteEdit=!isAdmin && MemberQ[billingAddresses, Download[site, Object]];

	If[invalidBillingSiteEdit && !gatherTests,
		Message[Error::BillingAddressPermissions]
	];

	billingPermissionTest=If[gatherTests,
		If[invalidBillingOptionValue,
			Test["If billing address is being set, it is done by a team administrator:", True, False],
			Test["If billing address is being set, it is done by a team administrator:", True, True]
		],
		Nothing
	];

	(* Throw a single InvalidOptions error if applicable *)
	invalidOptions=Flatten[{If[nameInUse, Name, Nothing], If[!notebookValid, Notebook, Nothing], If[invalidBillingOptionValue, BillingAddress, Nothing]}];
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Throw a single InvalidInput error if applicable *)
	invalidOptions=Flatten[{If[invalidBillingSiteEdit, site, Nothing]}];
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidInput, invalidOptions]
	];

	(* Return the resolved options and/or tests. *)
	outputSpecification /. {
		(* All Automatic options are resolved to Null in this overload to indicate that they won't change *)
		Result -> myOptions /. Automatic -> Null,
		Tests -> Flatten[{notebookValidTest, nameUniquenessTest, billingOptionTest, billingPermissionTest}]
	}
];

(* ::Subsection::Closed:: *)
(*UploadStorageProperties*)

DefineOptions[UploadStorageProperties,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "inputs",
			{
				OptionName -> Fragile,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP | Null],
				Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a homogeneous pile. Fragile objects are stored by themselves or in positions for which the objects are unlikely to contact each other.",
				Category -> "General"
			},
			{
				OptionName -> StorageOrientation,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> StorageOrientationP | Null],
				Description -> "Indicates how the object is situated while in storage. Upright indicates that the footprint dimension of the stored object is Width x Depth, Side indicates Depth x Height, Face indicates Width x Height, and Any indicates that there is no preferred orientation during storage.",
				Category -> "General"
			},
			{
				OptionName -> StorageOrientationImage,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]],
				Description -> "A file containing an image of showing the designated orientation of this object in storage as defined by the StorageOrientation.",
				Category -> "General"
			},
			{
				OptionName -> Dimensions,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Expression, Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]}|Null, Size -> Line],
				Description -> "The external dimensions of this model of container.",
				Category -> "General"
			}
		],
		UploadOption,
		OutputOption,
		CacheOption
	}
];

Error::ContainerDimensionsAlreadyVerified="The containers `2` are already verified (VerifiedContainerModel->True) so the specified dimensions `1` cannot be set. Please file a troubleshooting report to change and re-verify these objects.";

UploadStorageProperties[myModel:ObjectP[{Model[Container], Model[Item], Model[Part], Model[Plumbing], Model[Wiring]}], ops:OptionsPattern[]]:=Module[
	{return},
	
	return = UploadStorageProperties[{myModel}, ops];
	
	If[MatchQ[return,{ObjectP[myModel]}],
		First[return],
		return
	]
];
UploadStorageProperties[myModels:{ObjectP[{Model[Container], Model[Item], Model[Part], Model[Plumbing], Model[Wiring]}]...},ops:OptionsPattern[]]:=Module[
	{
		listedOptions,outputSpecification,output,gatherTests,safeOps,safeOpsTests,resolvedOptionsResult,
		resolvedOptions,resolvedOptionsTests,packets,uploadResult,validLengths,validLengthTests,expandedOptions,
		allPackets,storageAvailabilityPackets,storageAvailabilityToUpdate
	},
	
 (* Make sure we're working with a list of options *)
 listedOptions = ToList[ops];

 (* Determine the requested return value from the function *)
 outputSpecification = Quiet[OptionValue[Output]];
 output = ToList[outputSpecification];

 (* Determine if we should keep a running list of tests *)
 gatherTests = MemberQ[output, Tests];

 (* Call SafeOptions to make sure all options match pattern *)
 {safeOps, safeOpsTests}=If[gatherTests,
	 SafeOptions[UploadStorageProperties, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
	 {SafeOptions[UploadStorageProperties, listedOptions, AutoCorrect -> False], {}}
 ];

 (* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
 If[MatchQ[safeOps, $Failed],
	 Return[outputSpecification /. {
		 Result -> $Failed,
		 Tests -> safeOpsTests,
		 Options -> $Failed,
		 Preview -> Null
	 }]
 ];
 
 
 	(* Call ValidInputLengthsQ to make sure all options are the right length *)
 	{validLengths, validLengthTests} = If[gatherTests,
 		ValidInputLengthsQ[UploadStorageProperties, {myModels}, listedOptions, 1, Output -> {Result, Tests}],
 		{ValidInputLengthsQ[UploadStorageProperties, {myModels}, listedOptions, 1, Output -> Result], Null}
 	];

 	(* If option lengths are invalid return $Failed *)
 	If[!validLengths,
 		Return[outputSpecification /. {
 			Result -> $Failed,
 			Tests -> Join[safeOptionTests, validLengthTests],
 			Options -> $Failed,
 			Preview -> Null
 		}]
 	];

 	(* expand the options to be the proper length *)
 	expandedOptions = Last[ExpandIndexMatchedInputs[UploadStorageProperties, {myModels}, safeOps, 1]];
 
 (* Build the resolved options *)
 resolvedOptionsResult=If[gatherTests,
	 (* We are gathering tests. This silences any messages being thrown. *)
	 {resolvedOptions, resolvedOptionsTests}=resolveUploadStoragePropertiesOptions[myModels, expandedOptions, Output -> {Result, Tests}];

	 (* Therefore, we have to run the tests to see if we encountered a failure. *)
	 If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		 {resolvedOptions, resolvedOptionsTests},
		 $Failed
	 ],

	 (* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
	 Check[
		 {resolvedOptions, resolvedOptionsTests}={resolveUploadStoragePropertiesOptions[myModels, expandedOptions], {}},
		 $Failed,
		 {Error::InvalidInput, Error::InvalidOption}
	 ]
 ];

 (* If option resolution failed, return early. *)
 If[MatchQ[resolvedOptionsResult, $Failed],
	 Return[outputSpecification /. {
		 Result -> $Failed,
		 Tests -> Join[safeOpsTests, resolvedOptionsTests],
		 Options -> RemoveHiddenOptions[UploadStorageProperties, resolvedOptions],
		 Preview -> Null
	 }]
 ];
 
 
 (* UPLOAD *)
 
 packets = MapThread[
 	Function[{model,dimensions,storageOrientation,storageOrientationImage,fragileQ},
		Association[
			Object -> model,
			If[!NullQ[dimensions],
				Replace[Dimensions] -> dimensions,
				Nothing
			],
			If[!NullQ[storageOrientation],
				StorageOrientation -> storageOrientation,
				Nothing
			],
			If[!NullQ[storageOrientationImage],
				StorageOrientationImage -> Link[storageOrientationImage],
				Nothing
			],
			If[!NullQ[fragileQ],
				Fragile -> fragileQ,
				Nothing
			]
		]
	],
 	{
		myModels,
		Lookup[resolvedOptions,Dimensions],
		Lookup[resolvedOptions,StorageOrientation],
		Lookup[resolvedOptions,StorageOrientationImage],
		Lookup[resolvedOptions,Fragile]
	}
 ];

 (* -- Storage Availability Sync -- *)

 (* if any fields have changed, sync associated storage availability objects *)

 {storageAvailabilityPackets, storageAvailabilityToUpdate} = Module[
	 {
		 inputFields,existingParameters,modelChangedBools,modelsToUpdate,
		 queries,searchTypes,possibleObjectsToUpdate,possiblePositionTuples,allSAToUpdate
	 },

	 (* -- Check for changes -- *)
	 inputFields = {Dimensions, StorageOrientation, Fragile};

	 existingParameters = Download[myModels, inputFields];
	 modelChangedBools = MapThread[
		 (* if any of the non null values do not match the db val, then *)
		 Which[
			 (* no fields were updated *)
			 MatchQ[#2, {Null..}],
			 False,

			 (* updates were specified but are the same as existing values *)
			 MatchQ[Cases[#2, Except[Null]],PickList[#1, #2, Except[Null]]],
			 False,

			 (* something material has changed *)
			 True,
			 True
		 ]&,
		 {existingParameters, Transpose[Lookup[resolvedOptions,inputFields]]}
	 ];

	 (* fin any models that have been altered in a way that will impact packing. If there are non, return early *)
	 modelsToUpdate = PickList[myModels, modelChangedBools, True];
	 If[MatchQ[modelsToUpdate, {}],
		 Return[{{},{}}, Module]
	 ];

	 (* -- find all impacted objects -- *)

	 (* for each model find real instances in lab (any site) *)
	 queries = Hold[And[Model==#,Status==(Available|Stocked|InUse),Container!=Null&&Missing!=True]]&/@modelsToUpdate;
	 searchTypes = {Object@@Most[#]}&/@modelsToUpdate;
	 possibleObjectsToUpdate = Flatten[Search[searchTypes, Evaluate[queries]]];

	 (* -- find all impacted positions -- *)
	 possiblePositionTuples = Download[possibleObjectsToUpdate, {Position, Container[StorageAvailability]}];

	 allSAToUpdate = DeleteDuplicates[
		 Map[
			 FirstCase[#[[2]], {pos:#[[1]], sa_}:>Download[sa, Object], Nothing]&,
			 possiblePositionTuples
		 ]
	 ];

	 (* Set the storage availability objects to Unsynced, and then let them get picked up by the syncing job *)
	 (*Note that there is a script that syncs these, so even if something happens, like you call this with Upload->False from another function, it still works *)
	 {
		 If[MatchQ[allSAToUpdate, {ObjectP[]..}],
			 Map[<|Object-> #, Status-> Unsynced, Append[StatusLog]-> {Now, Unsynced,Link[Object[User, Emerald, Developer, "service+lab-infrastructure"]]}|>&,allSAToUpdate],
			 {}
		 ],
		 allSAToUpdate
	 }
 ];


 allPackets = Join[packets, storageAvailabilityPackets];


 (* if we are uploading, also make a computation to recalculate the storageAvailabilities *)
 uploadResult = If[Lookup[safeOps, Upload],
	 Join[
		 Upload[allPackets],
		 (* only do the computation if we are in engine, or in a Null notebook. Dont make Customers do this computation *)
		 If[MatchQ[storageAvailabilityToUpdate, {ObjectP[]..}]&&MatchQ[$Notebook,Null]&&MatchQ[ProductionQ[], True],
			 Compute[
				 Block[
					 {$Notebook=Null},
					 InternalUpload`UploadStorageAvailability[#, Force->True]&/@PartitionRemainder[storageAvailabilityToUpdate, 50]
				 ],
				 RunAsUser -> Object[User, Emerald, Developer, "service+lab-infrastructure"]
			 ],
			 {}
		 ]
	 ],
	 allPackets
 ];



 (* Return requested output *)
 outputSpecification /. {
	 Result -> uploadResult,
	 Tests -> Flatten[{safeOpsTests, resolvedOptionsTests}],
	 Options -> RemoveHiddenOptions[UploadStorageProperties, resolvedOptions],
	 Preview -> Null
 }
];


(* ::Subsubsection:: *)
(*resolveUploadStoragePropertiesOptions *)


DefineOptions[
	resolveUploadStoragePropertiesOptions,
	Options :> {HelperOutputOption, CacheOption}
];

(* Overload for editing an existing model *)
resolveUploadStoragePropertiesOptions[myModels:{ObjectP[{Model[Container], Model[Item], Model[Part], Model[Plumbing], Model[Wiring]}]...}, myOptions:{_Rule...}, myResolutionOptions:OptionsPattern[resolveUploadStoragePropertiesOptions]]:=Module[
	{outputSpecification,output,gatherTests,cache,verifiedContainerModelBools,specifiedDimensions,
	validDimensionsBools,invalidDimensions,invalidDimensionsModels,dimensionsTest,invalidOptions},
		
	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionValue[Output]];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache = Quiet[OptionValue[Cache]];
	
	verifiedContainerModelBools = Quiet[Download[myModels,VerifiedContainerModel,Cache->cache],Download::FieldDoesntExist];

	specifiedDimensions= Lookup[myOptions,Dimensions];
	 
	 validDimensionsBools = MapThread[
 		If[
			And[
				MatchQ[#1,ObjectP[Model[Container]]],
				TrueQ[#2],
				!NullQ[#3]
			],
			False,
			True
		]&,
 		{myModels,verifiedContainerModelBools,specifiedDimensions}
 	];
 	
 	invalidDimensions = PickList[specifiedDimensions,validDimensionsBools,False];
	invalidDimensionsModels = PickList[myModels,validDimensionsBools,False];
 	
 	dimensionsTest = If[Length[invalidDimensions]>0,
			If[gatherTests,
				Test["Dimensions are only specified for containers that are not already Verified:",True,False],
				(
					Message[Error::ContainerDimensionsAlreadyVerified,invalidDimensions,invalidDimensionsModels];
					Null
				)
			],
			If[gatherTests,
				Test["Dimensions are only specified for containers that are not already Verified:",True,True],
				Null
			]
 	];
	
	(* Throw a single InvalidInput error if applicable *)
	invalidOptions = If[Length[invalidDimensions]>0,
		{Dimensions},
		{}
	];
	If[!gatherTests && Length[invalidOptions] > 0,
		Message[Error::InvalidOption, invalidOptions]
	];
	
	(* Return the resolved options and/or tests. *)
	outputSpecification /. {
		Result -> myOptions,
		Tests -> {dimensionsTest}
	}
];

(* Helper to resolve SampleType option from the parsed description *)
resolveSampleTypesFromString[myProductName:(Null | _String), myProductDescription:(Null | _String)] := Module[
	{
		allAllowedSampleTypesString, commonSampleTypes, weightedSampleTypesString, nameStringMatching,
		nameMatchedTypes, descriptionStringMatching, descriptionMatchedTypes, commonSampleTypesLookup
	},

	allAllowedSampleTypesString = ToString /@ (List @@ SampleDescriptionP);
	commonSampleTypes = {Tube, Vial, Plate, Bottle, Pack, Kit, Column, Cap};
	commonSampleTypesLookup = {
		"Lid" -> PlateCover,
		"Film" -> PlateCover
	};

	(* We construct this list of SampleDescriptions which put the common ones in front. *)
	weightedSampleTypesString = Join[
		ToString /@ commonSampleTypes,
		Keys[commonSampleTypesLookup],
		allAllowedSampleTypesString
	];

	(* Find whether our product name contains any of the SampleTypes string *)
	nameStringMatching = If[NullQ[myProductName],
		ConstantArray[False, Length[weightedSampleTypesString]],
		StringContainsQ[myProductName, #, IgnoreCase -> True]& /@ weightedSampleTypesString
	];
	nameMatchedTypes = PickList[weightedSampleTypesString, nameStringMatching, True];

	(* Find whether our product description contains any of the SampleTypes string *)
	descriptionStringMatching = If[NullQ[myProductDescription],
		ConstantArray[False, Length[weightedSampleTypesString]],
		StringContainsQ[myProductDescription, #, IgnoreCase -> True]& /@ weightedSampleTypesString
	];
	descriptionMatchedTypes = PickList[weightedSampleTypesString, descriptionStringMatching, True];

	Which[
		Length[nameMatchedTypes] > 0,
		(* If we found the product's name contains any string that matches SampleDescriptionP, use that *)
			ToExpression[Replace[First[nameMatchedTypes], commonSampleTypesLookup]],
		(* Otherwise, we'll use what we found from product description *)
		Length[descriptionMatchedTypes] > 0,
			ToExpression[Replace[First[descriptionMatchedTypes], commonSampleTypesLookup]],
		(* Lastly, if we can't find anything, set to Null *)
		True,
			Null
	]
];