(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*PersonFunctions*)


(* 
inspectSendMailTemplateFieldConfig: Fetches the current list of templates and expected fields from the Constellation 
	
	Input: nothing
	Output: Association containing templateName -> {Fields->{required fields} and other information}
*)
inspectSendMailTemplateFieldConfig[]:=ConstellationRequest[
	<|
		"Path"->"ise/send-email/v2/fields",
		"Method"->"GET"
	|>
];


(* ::Subsubsection:: *)
(*$EmailEnabled*)


(* Session constant that can be used to disable emailing for a given session (or for a given command, if Block is used) *)
$EmailEnabled = True;


(* ::Subsubsection:: *)
(*Email*)


DefineOptions[
	Email,
	Options :> {
		{Subject -> "", _String, "The text that will appear in the Subject line of the email."},
		{Cc -> {}, {(EmailP | ObjectP[Object[User]])...}, "List of email addresses or ECL User Objects to Cc."},
		{Bcc -> {}, {(EmailP | ObjectP[Object[User]])...}, "List of email addresses or ECL User Objects to Bcc."},
		{Sender -> "notifications@emeraldcloudlab.com", EmailP, "Email address from which this email should be sent."},
		{SenderName -> "Emerald Cloud Lab", _String, "Name of the sender (e.g. John Smith)."},
		{Attachments -> Null, Null | {_String...}, "A list of local file paths to add to the email as attachments."},
		
		{Template -> "general-message", EmailTemplateNameP, "The name of the HTML form to be used for this email.",Category->TemplateEmail},
		{UserName->Null, Null | _String, "For templated notification emails, the name of the ECL User to whom the notification applies.",Category->TemplateEmail},
		{AuthorName->Null, Null | _String, "For templated notification emails, the name of the ECL User who authored the Object to which the notification applies.",Category->TemplateEmail},
		{TeamName->Null, Null | _String, "For templated notification emails, the name of the ECL Team to which the notification applies.",Category->TemplateEmail},
		{ProtocolObject->Null, Null | ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification], Object[Transaction]}], "For templated notification emails, the Protocol or Transaction Object to which the notification applies.",Category->TemplateEmail},
		{TroubleshootingObject->Null, Null | ObjectP[Object[SupportTicket]], "For templated notification emails, the Troubleshooting Object to which the notification applies.",Category->TemplateEmail},
		{ScriptObject->Null, Null | ObjectP[{Object[Notebook, Script]}], "For templated notification emails, the Script Object to which the notification applies.",Category->TemplateEmail},
		{ModelObject->Null, Null | ObjectP[Model], "For templated notification emails, the Model Object to which the notification applies.",Category->TemplateEmail},
		{ProductObject->Null, Null | ObjectP[Object[Product]], "For templated notification emails, the Product Object to which the notification applies.",Category->TemplateEmail},
		{TransactionObject->Null, Null | ObjectP[Object[Transaction]], "For templated notification emails, the Transaction Object to which the notification applies.",Category->TemplateEmail},
		{MaterialsObjects->Null, Null | {ObjectP[Object[Product]]..}, "For templated notification emails, the Product Objects corresponding to the required materials.",Category->TemplateEmail},
		{TroubleshootingHeadline->Null, Null | _String, "For templated notification emails, the headline of the Troubleshooting Report to which the notification applies.",Category->TemplateEmail},
		{TroubleshootingDescription->Null, Null | _String, "For templated notification emails, the desccription of the Troubleshooting Report to which the notification applies.",Category->TemplateEmail},
		{TroubleshootingComments->Null, Null|_String, "For templated notification emails, the log of all comments that have been made on troubleshooting report.", Category->TemplateEmail},
		{AffectedItem->Null, Null | ObjectP[{Object[Protocol], Object[Maintenance], Object[Qualification], Object[Transaction],Object[Notebook,Script]}] | _Symbol | _String, "For templated notification emails, the item affected by the Troubleshooting Report to which the notification applies.",Category->TemplateEmail},
		{ScriptMessage->Null, Null | _String, "For templated notification emails, the message(s) thrown by the script to which the notification applies.",Category->TemplateEmail},
		{ScriptExpression->Null, Null | _String, "For templated notification emails, the expression being evaluated when messages were thrown by the script to which the notification applies.",Category->TemplateEmail},
		{FeatureDescription->Null, Null | _String, "For templated notification emails, the description of the feature(s) the notification announces.",Category->TemplateEmail},
		{Application->Null, Null | _Symbol, "For templated notification emails, the ECL Application to which the notification applies.",Category->TemplateEmail},
		{VersionNumber->Null, Null | VersionNumberP, "For templated notification emails, the version number of the ECL Application to which the notification applies.",Category->TemplateEmail},
		{URL->Null, Null | URLP | {URLP..}, "For templated notification emails, a URL containing more information about the notification.",Category->TemplateEmail},
		{Notebook->Null, Null | ObjectP[Object[LaboratoryNotebook]], "For templated notification emails, the Laboratory Notebook most relevant to the notification.",Category->TemplateEmail},
		{SectionDetails->Null, Null | _String, "For templated notification emails, the Notebook Page and section/subsection in which the relevant Object appears.",Category->TemplateEmail},
		{DateExpected->Null, Null | _String, "For templated notification emails, the expected arrival date for the Transaction to which the notification applies.",Category->TemplateEmail},
		{TrackingNumber->Null, Null | _String | {_String..}, "For templated notification emails, the carrier tracking number for the Transaction to which the notification applies.",Category->TemplateEmail},
		{Headline -> Automatic, Automatic | _String, "For templated free-text emails, the headline to be displayed above the body of the message. If Automatic and Template->'general-message', resolves to the same value as 'Subject'.",Category->TemplateEmail},
		{Message -> "", _String, "For templated free-text emails, the main body of the message.",Category->TemplateEmail},
		{RegistrationKey -> Null, Null|_String, "For templated invitation emails, the string representing a registration token required to access ECL products."},
		
		{Force->False, BooleanP, "Allows user to force sending of email even if pointed at stage database.", Category->Hidden},
		
		CacheOption
	}
];

Email::MailServerError = "The server returned an error in response to the request to send email: `1`. Please confirm that specified input includes all required information and is formatted properly.";
Email::IncompleteTemplateFields = "The specified email template, '`2`', requires non-Null values for the options `1`, but one or more of these options is Null: `3`. Please verify that all of the required information has been provided.";
Email::InvalidTemplate = "The specified email template, '`1`', is not a valid email template name. Please confirm that the provided email template matches EmailTemplateNameP.";
Email::AttachmentFileDoesNotExist = "The attached file(s) `1` does not exist. Please check the file path provided and try again.";
Email::AttachmentFileTypeNotSupported = "The attached file(s) `1` is not supported. Please check the list of supported file types by calling SupportedEmailAttachmentTypeP.";

Email[emailAddress:(EmailP | ObjectP[Object[User]]), ops:OptionsPattern[]] := FirstOrDefault[Email[{emailAddress}, ops], $Failed];
Email[emailAddresses:{(EmailP | ObjectP[Object[User]])..}, ops:OptionsPattern[]] := Module[
	{templateNameOptionLookup, safeOps, subject, body, templateName, ccList, bccList, response, sender, senderName,
	objectEmailAddressLookup, toEmailAddresses,	ccEmailAddresses, bccEmailAddresses, request, incomingCache, updatedSafeOps, attachments, emailAttachments},
	
	(* If a nonexistent template has been provided, there is no reasonable course forward; throw a hard error.
	 	Do this in advance of calling SafeOptions to avoid a double error message. *)
	If[!MatchQ[OptionValue[Template], Null | EmailTemplateNameP],
		(
			Message[Email::InvalidTemplate, OptionValue[Template]];
			Return[$Failed]
		)
	];

	safeOps = SafeOptions[Email, ToList[ops]];
	
	(* Resolve 'Headline' to match 'Subject' if it has not been specified and we're sending a free-text email *)
	updatedSafeOps = If[MatchQ[Lookup[safeOps, {Template, Headline}], {"general-message", Automatic}],
		ReplaceRule[safeOps, Headline->Lookup[safeOps, Subject]],
		safeOps
	];

	(* Lookup table that stores the fields required for a given template name
	 	These are the pieces of information that SendGrid expects to receive for each template *)
	templateNameOptionLookup = Association[
		"admin-added" -> {UserName, TeamName}, 
		"admin-removed" -> {UserName, TeamName}, 
		"ecl-invite" -> {UserName, TeamName, RegistrationKey, URL},
		"ecl-welcome" -> {URL},
		"general-message" -> {Headline, Message},
		"materials-required" -> {Notebook, SectionDetails, MaterialsObjects}, 
		"model-approved" -> {Notebook, SectionDetails, ModelObject},
		"notebook-added" -> {Notebook, TeamName},
		"notebook-removed" -> {Notebook, TeamName}, 
		"order-backordered" -> {Notebook, SectionDetails, TransactionObject, DateExpected}, 
		"order-canceled" -> {Notebook, SectionDetails, TransactionObject},
		"order-partially-received" -> {Notebook, SectionDetails, TransactionObject},
		"order-placed" -> {Notebook, SectionDetails, TransactionObject},
		"order-received" -> {Notebook, SectionDetails, TransactionObject},
		"product-approved" -> {Notebook, SectionDetails, ProductObject},
		"protocol-aborted" -> {Notebook, SectionDetails, ProtocolObject, AuthorName, TroubleshootingHeadline}, 
		"protocol-added-to-cart" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-canceled" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-completed" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-enqueued" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-processing" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-awaiting-materials" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"protocol-awaiting-backordered-materials" -> {Notebook, SectionDetails, ProtocolObject, AuthorName}, 
		"samples-returned" -> {Notebook, SectionDetails, TransactionObject, AuthorName, TrackingNumber, URL}, 
		(* deprecated *)"samples-shipped" -> {Notebook, SectionDetails, TransactionObject, AuthorName}, 
		"samples-received" -> {Notebook, SectionDetails, TransactionObject, AuthorName},
		"software-new-features" -> {FeatureDescription}, 
		"software-update" -> {Application, VersionNumber, FeatureDescription}, 
		"software-new-features-url" -> {FeatureDescription, URL}, 
		"software-update-url" -> {Application, VersionNumber, FeatureDescription, URL}, 
		"team-member-added" -> {UserName, TeamName}, 
		"team-member-removed" -> {UserName, TeamName}, 
		"troubleshooting-reported" -> {Notebook, SectionDetails, AffectedItem, AuthorName, TroubleshootingObject, TroubleshootingHeadline, TroubleshootingDescription}, 
		"troubleshooting-report-reopened" -> {Notebook, SectionDetails, AffectedItem, AuthorName, TroubleshootingObject, TroubleshootingHeadline, TroubleshootingDescription}, 
		"troubleshooting-report-resolved" -> {Notebook, SectionDetails, AffectedItem, AuthorName, TroubleshootingObject, TroubleshootingHeadline, TroubleshootingDescription}, 
		"troubleshooting-report-updated" -> {Notebook, SectionDetails, AffectedItem, AuthorName, TroubleshootingObject, TroubleshootingHeadline, TroubleshootingDescription, TroubleshootingComments},
		"script-exception" -> {Notebook, SectionDetails, AuthorName, ScriptObject, ScriptMessage, ScriptExpression},
		"script-completed" -> {Notebook, SectionDetails, AuthorName, ScriptObject}
	];

	(* Pull relevant parameters from options, except template field options to be handled later *)
	{subject, sender, senderName, templateName, ccList, bccList, incomingCache} = Lookup[updatedSafeOps, 
		{Subject, Sender, SenderName, Template, Cc, Bcc, Cache}
	];

	(* Download email addresses for all recipients (To and CC) specified by Object *)
	objectEmailAddressLookup = With[
		{inputObjects = Cases[Join[emailAddresses, ccList, bccList], ObjectP[]]},
		AssociationThread[inputObjects, Download[inputObjects, Email, Cache->incomingCache]]
	];

	(* Convert any attachments to the appropriate format *)
	attachments = Lookup[updatedSafeOps, Attachments];
	emailAttachments={};
	Map[
		AppendTo[
			emailAttachments,
			createAttachment[#]
		]&, attachments];

	If[MemberQ[emailAttachments, Email::AttachmentFileDoesNotExist],
		Message[Email::AttachmentFileDoesNotExist, Extract[attachments, Position[emailAttachments, Email::AttachmentFileDoesNotExist]]];
		Return[$Failed]
	];

	If[MemberQ[emailAttachments, Email::AttachmentFileTypeNotSupported],
		Message[Email::AttachmentFileTypeNotSupported, Extract[attachments, Position[emailAttachments, Email::AttachmentFileTypeNotSupported]]];
		Return[$Failed]
	];
	
	(* Convert any Object references in To or Cc to email addresses *)
	toEmailAddresses = ReplaceAll[emailAddresses, objectEmailAddressLookup];
	ccEmailAddresses = ReplaceAll[ccList, objectEmailAddressLookup];
	bccEmailAddresses = ReplaceAll[bccList, objectEmailAddressLookup];
	
	(* Assemble an appropriate email request depending on whether sending a templated or plain text email *)
	request = Module[
		{requiredTemplateFieldOptions, requiredTemplateFieldValues, templateFieldAssociation},
		
		(* Get the names and values of all template field options that are expected for the given template name *)
		requiredTemplateFieldOptions = Lookup[templateNameOptionLookup, templateName];
		requiredTemplateFieldValues = Lookup[updatedSafeOps, requiredTemplateFieldOptions];
		
		(* Throw an error and return $Failed if all required template fields are not populated;
			Superflouous template field options are ignored;
		 	Exclude Notebook from this check because it will sometimes be Null, particularly in unit tests *)
		If[MemberQ[Transpose[{requiredTemplateFieldOptions,requiredTemplateFieldValues}], {Except[Notebook], Null}],
			(
				Message[Email::IncompleteTemplateFields, requiredTemplateFieldOptions, templateName, requiredTemplateFieldValues];
				Return[$Failed]
			)
		];
		
		(* Assemble template fields association in a form that is ready to send to the Object Store *)
		templateFieldAssociation = AssociationThread[
			convertWhitespaceCharacters[ToString[#]]& /@ requiredTemplateFieldOptions, 
			convertWhitespaceCharacters[toEmailCompatibleString[#]]& /@ requiredTemplateFieldValues
		];
		
		(* Generate the body of an ConstellationRequest to send the email *)
		emailRequestBody[
			senderName, sender,	toEmailAddresses, ccEmailAddresses, bccEmailAddresses, subject, 
			templateName, templateFieldAssociation, emailAttachments
		]
	];
	
	(* Make the request to the Constellation ONLY if pointed at the production database and $EmailEnabled->True, or if Force->True (overrides everything) *)
	response = If[Or[And[ProductionQ[], TrueQ[$EmailEnabled]], TrueQ[OptionValue[Force]]],
		ConstellationRequest[
			<|
				"Path"->"ise/send-email/v2",
				"Method"->"POST",
				"Body"->ExportAssociationToJSON[request]
			|>,
			(* Retry a small number of times to overcome momentary connectivity issues or service outages, 
				but avoid holding the kernel for an excessive amount of time *)
			Retries->4,
			RetryMode->Write
		],
		Null
	];
	
	(* Surface errors and return $Failed if sending failed; return recipients list if succeeded *)
	If[MatchQ[response,_HTTPError],
		(
			Message[Email::MailServerError,Last[response]];
			$Failed
		),
		Join[toEmailAddresses, ccEmailAddresses]
	]
];

SupportedEmailAttachmentTypeP = "txt" | "csv" | "jpg" | "png" | "pdf" | "tar" | "gz" | "zip" | "nb" | "cdf" | "doc" | "docx" | "ppt" | "pptx" | "xls" | "xlsx";
Authors[createAttachment]:={"platform"};

createAttachment[filePath_String]:=Module[
	{fileName,fileFormat,mimeType,byteArray,encodedData},

	If[!FileExistsQ[filePath],
		Return[Email::AttachmentFileDoesNotExist];
	];

	(* Grab basic file information *)
	fileName = Last[FileNameSplit[filePath]];

	(* NOTE: Have to use FileExtension as FileFormat does not support Windows documents *)
	fileFormat = FileExtension[filePath];

	(* Throw an error notifying the user that the file type is not supported *)
	If[!MatchQ[fileFormat, SupportedEmailAttachmentTypeP],
		Return[Email::AttachmentFileTypeNotSupported]
	];

	(* MM uses a special MIME type for notebooks: https://www.wolfram.com/technologies/nb/ *)
	(* NOTE: MM does have a MIME type interpreter, however it returns the incorrect type:
	         https://reference.wolfram.com/language/ref/interpreter/MIMETypeString.html *)
	mimeType = Switch[fileFormat,
		"txt",  "text/plain",
		"csv",  "text/csv",
		"jpg",  "image/jpeg",
		"jpeg", "image/jpeg",
		"png",  "image/png",
		"pdf",  "application/pdf",
		"tar",  "application/x-tar",
		"gz",   "application/gzip",
		"zip",  "application/zip",
		"nb",   "application/vnd.wolfram.mathematica",
		"cdf",  "application/vnd.wolfram.cdf.text",
		"doc",  "application/msword",
		"docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
		"ppt",  "application/vnd.ms-powerpoint",
		"pptx", "application/vnd.openxmlformats-officedocument.presentationml.presentation",
		"xls",  "application/vnd.ms-excel",
		"xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
	];

	(* Base64 encode the data *)
	byteArray = ReadByteArray[filePath];
	encodedData = BaseEncode[byteArray];

	(* Add an attachment to the email. This must modified if we want inline attachments *)
	Association[
		"content"->encodedData,
		"type"->mimeType,
		"filename"->fileName,
		"disposition"->"attachment"
	]
];

(*
	emailRequestBody: Generates the 'body' section of an ConstellationRequest that will send an email.

	Input:
		Sender's name
		Sender's email address
		List of primary recipient email addresses
		List of Cc email addresses
		List of Bcc email addresses
		Subject of the email
		(plain-text overload only) Plain-text body of the email
		(template overload only) Email template name
		(template overload only) Email template fields for filling in template with relevant information
		
	Output:
		An association that, when converted into JSON, can be used as the "Body" of an Constellation request to send an email
*)

(* Plain text email (not currently used; all emails are templated) *)
Authors[emailRequestBody]:={"platform"};

emailRequestBody[
   senderName_String,
	 senderEmail:EmailP,
   toEmail:{EmailP...},
	 ccEmail:{EmailP...},
	 bccEmail:{EmailP...},
   subject_String,
   body_String
] := DeleteCases[
	Association[
		"from" -> Association["name"->senderName, "email"->senderEmail],
		"to" -> (Association["name"->"", "email"->#]& /@ toEmail),
		"cc" -> (Association["name"->"", "email"->#]& /@ ccEmail),
		"bcc" -> (Association["name"->"", "email"->#]& /@ bccEmail),
		"subject" -> subject,
		"text_body" -> body
  ],
	None | Null | {}
];

(* Templated email overload *)
emailRequestBody[
   senderName_String,
	 senderEmail:EmailP,
   toEmail:{EmailP...},
	 ccEmail:{EmailP...},
	 bccEmail:{EmailP...},
   subject_String,
   templateName:EmailTemplateNameP, 
   templateFields_Association,
	 attachments_List
] := DeleteCases[
	Association[
		"from" -> Association["name"->senderName, "email"->senderEmail],
		"to" -> (Association["name"->"", "email"->#]& /@ toEmail),
		"cc" -> (Association["name"->"", "email"->#]& /@ ccEmail),
		"bcc" -> (Association["name"->"", "email"->#]& /@ bccEmail),
		"subject" -> subject,
		"template_name" -> templateName,
		"substitutions" -> templateFields,
		If[Length[attachments]>0,"attachments"->attachments,Nothing]
	],
	None | Null | {}
];


(* Convert to string an item that may or may not be an SLL Object.
	For Packets or Links, Download Object to be sure of having ObjectReference
	rather than Packet or Link, then run ToString.
	For all other items, ToString directly. *)
toEmailCompatibleString[obj:(PacketP[] | LinkP[])] := ToString[Download[obj, Object]];
toEmailCompatibleString[other_] := With[
	{str = ToString[other]},
	(* Truncate long strings to comply with SendGrid 10000 byte limit per template field *)
	If[StringLength[str] > 7000,
		StringJoin[StringTake[str, ;;7000], " <br /><br /><i>[Message truncated; max length 7000 characters]</i>"],
		str
	]
];

(* Perform the following conversions:
	- \n newlines to <br /> newlines
	- \\n to \n 
	- \t tabs to &emsp
*)
convertWhitespaceCharacters[str_String] := StringReplace[
	str, 
	{
		"\\n" -> "\n", 
		"\n" -> "<br />",
		"\t" -> "&emsp;"
	}
];


(* ::Section:: *)
(*End Package*)
