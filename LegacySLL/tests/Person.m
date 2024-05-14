(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*PersonFunctions*)


(* ::Subsubsection:: *)
(*Email*)


DefineTests[
	Email,
	{

		(* --- Basic Examples --- *)
		Example[
			{Basic, "Send an Email with an explicit Email address:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test 1", Message->"hello, this is the first test"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Basic, "Send an Email referencing an ECL User Object:"},
			Email[Object[User, Emerald, Developer, "service+lab-infrastructure"], Subject->"Email test 2", Message->"hello, this is the second test"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Basic, "Send an email to multiple recipients:"},
			Email[{"hendrik@emeraldtherapeutics.com", "hendrik+2@emeraldtherapeutics.com"}, Subject->"Email test 3", Message->"hello, this is the third test"],
			{EmailP, EmailP},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send`-email/v2"], ___] = "OK"
			}
		],

		(* --- Additional Examples --- *)
		Example[
			{Additional, "Send an email to multiple recipients referenced by ECL User Object:"},
			Email[{Object[User,Emerald,Developer,"hendrik"],Object[User,Emerald,Developer,"hendrik+2"]}, Subject->"Email test 3", Message->"hello, this is the third test"],
			{EmailP, EmailP},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send`-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Additional, "Send an email to multiple recipients using a mixture of email addresses and ECL User Objects:"},
			Email[{Object[User,Emerald,Developer,"hendrik"],"hendrik+2@emeraldtherapeutics.com"}, Subject->"Email test 3", Message->"hello, this is the third test"],
			{EmailP, EmailP},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send`-email/v2"], ___] = "OK"
			}
		],


		(* --- Options Examples --- *)
		Example[
			{Options, Subject, "Specify the subject of the email:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, Headline, "Specify the headline of a free-text email:"},
			Email["ben@emeraldtherapeutics.com", Headline->"Lorem ipsum dolor sit amet"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, Message, "Specify the body of a free-text email:"},
			Email["ben@emeraldtherapeutics.com", Message->"Lorem ipsum dolor sit amet"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, Cc, "Send an Email and Cc some else:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test", Message->"hello, this is a test", Cc->{"fake@fake.com"}],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, Bcc, "Send an Email and Bcc some else:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test", Message->"hello, this is a test", Bcc->{"fake@fake.com"}],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, Sender, "Specify email address of the sender:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test", Message->"hello, this is a test", Sender->"ben@emeraldtherapeutics.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[
			{Options, SenderName, "Specify name of the sender:"},
			Email["ben@emeraldtherapeutics.com", Subject->"Email test", Message->"hello, this is a test", SenderName->"Emerald Cloud Lab"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		(* Template option examples *)
		Example[
			{Options, Template, "Specify the name of the email template to be used:"},
			Email["ben@emeraldtherapeutics.com", Subject -> "ECL Notification Email", Template -> "admin-added", UserName -> "Frank Reynolds", TeamName -> "Mantis Toboggan's team"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, UserName, "Specify the name of the user associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject -> "ECL Notification Email", Template -> "admin-added", UserName -> "Frank Reynolds", TeamName -> "Mantis Toboggan's team"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, AuthorName, "Specify the name of the author associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"protocol-aborted", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProtocolObject->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingHeadline->"Protocol delayed due to instrument destruction by zombie apocalypse"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TeamName, "Specify the name of the team associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject -> "ECL Notification Email", Template -> "admin-added", UserName -> "Frank Reynolds", TeamName -> "Mantis Toboggan's team"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, ProtocolObject, "Specify the protocol object associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"protocol-aborted", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProtocolObject->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingHeadline->"Protocol delayed due to instrument destruction by zombie apocalypse"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TroubleshootingObject, "Specify the troubleshooting object associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"troubleshooting-report-reopened", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", AffectedItem->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingObject->Object[SupportTicket,UserCommunication,"Test TSR 1 for Notifications"], TroubleshootingHeadline->"Something went wrong", TroubleshootingDescription->"Zombies invaded the lab, temporarily preventing advancement of the protocol"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, ModelObject, "Specify the model object associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"model-approved", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ModelObject->Model[Sample,"Test model for Notifications"]],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, ProductObject, "Specify the product object associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"product-approved", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProductObject->Object[Product,"Test product for Notifications"]],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TransactionObject, "Specify the order object associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"order-backordered", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", TransactionObject->Object[Transaction,Order,"Test order for Notifications"], DateExpected->DateString[DateObject[Today+Week]]],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, MaterialsObjects, "Specify the product objects corresponding to materials associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"materials-required", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", MaterialsObjects->{Object[Product,"Test product for Notifications"]}],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TroubleshootingHeadline, "Specify the headline of the troubleshooting associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"protocol-aborted", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProtocolObject->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingHeadline->"Protocol delayed due to instrument destruction by zombie apocalypse"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TroubleshootingDescription, "Specify the description of the troubleshooting associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"troubleshooting-report-reopened", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", AffectedItem->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingObject->Object[SupportTicket,UserCommunication,"Test TSR 1 for Notifications"], TroubleshootingHeadline->"Something went wrong", TroubleshootingDescription->"Zombies invaded the lab, temporarily preventing advancement of the protocol"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TroubleshootingComments, "Specify an updated CommentsLog for the troubleshooting associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"troubleshooting-report-updated", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", AffectedItem->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingObject->Object[SupportTicket,UserCommunication,"Test TSR 1 for Notifications"], TroubleshootingHeadline->"Something went wrong", TroubleshootingDescription->"Zombies invaded the lab, temporarily preventing advancement of the protocol", TroubleshootingComments->"Alex Yoshikawa (Wed 2 May 2018 13:53:59): We have pushed the zombie menace back into Waste Holding using the improvised liquid nitrogen guns."],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, FeatureDescription, "Specify the description of the feature associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject -> "ECL Notification Email", Template -> "software-new-features", FeatureDescription -> "Whole cell simulation is now available!", URL -> "https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, Application, "Specify the ECL application associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"software-update",Application->CommandCenter, VersionNumber->"1.2.3.4", FeatureDescription -> "Notifications can now be viewed in the Notifications Inbox.",URL->"https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, VersionNumber, "Specify the ECL application version number associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"software-update",Application->CommandCenter, VersionNumber->"1.2.3.4", FeatureDescription -> "Notifications can now be viewed in the Notifications Inbox.",URL->"https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, URL, "Specify the URL associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"software-update",Application->CommandCenter, VersionNumber->"1.2.3.4", FeatureDescription -> "Notifications can now be viewed in the Notifications Inbox.",URL->"https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, URL, "Specify the URLs associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"software-update",Application->CommandCenter, VersionNumber->"1.2.3.4", FeatureDescription -> "Notifications can now be viewed in the Notifications Inbox.",URL->{"https://www.emeraldcloudlab.com","https://www.emeraldcloudlab.com"}],
			EmailP,
			Stubs:>{
			(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, Notebook, "Specify the laboratory notebook associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"protocol-aborted", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProtocolObject->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingHeadline->"Protocol delayed due to instrument destruction by zombie apocalypse"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, SectionDetails, "Specify the laboratory notebook page / section / subsection associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"protocol-aborted", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", ProtocolObject->Object[Protocol,HPLC,"Test protocol 1 for Notifications"], AuthorName->"Mantis Toboggan", TroubleshootingHeadline->"Protocol delayed due to instrument destruction by zombie apocalypse"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, DateExpected, "Specify the expected ship date of the order associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"order-backordered", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", TransactionObject->Object[Transaction,Order,"Test order for Notifications"], DateExpected->DateString[DateObject[Today+Week]]],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TrackingNumber, "Specify the tracking number for the order associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"samples-shipped", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", TransactionObject->Object[Transaction,Order,"Test order for Notifications"], AuthorName->"Frank Reynolds", TrackingNumber->"1Z2134259FDLMN34LSWSD", URL->"https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, TrackingNumber, "Specify tracking numbers for the order associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"samples-shipped", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", TransactionObject->Object[Transaction,Order,"Test order for Notifications"], AuthorName->"Frank Reynolds", TrackingNumber->{"1Z2134259FDLMN34LSWSD","12dffrtrd2"}, URL->"https://www.emeraldcloudlab.com"],
			EmailP,
			Stubs:>{
			(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, AffectedItem, "Specify the item that is the subject of the troubleshooting report associated with the notification:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Template->"troubleshooting-report-reopened", Notebook->Object[LaboratoryNotebook, "Dr. Mantis Toboggan's magnum opus"], SectionDetails->"Section->Subsection->Position", AffectedItem->CommandCenter, AuthorName->"Mantis Toboggan", TroubleshootingObject->Object[SupportTicket,UserCommunication,"Test TSR 1 for Notifications"], TroubleshootingHeadline->"Something went wrong", TroubleshootingDescription->"Zombies invaded the lab, temporarily preventing advancement of the protocol"],
			EmailP,
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Options, Attachments, "Add an attachment to the email:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Attachments->{filePath}],
			EmailP,
			SetUp:>{
				filePath=FileNameJoin[{$TemporaryDirectory, "test.txt"}];
				stream=OpenWrite[filePath];
				Write[stream, "hello, world!"];
				Close[stream];
			},
			TearDown:>{
				If[FileExistsQ[filePath],
					DeleteFile[filePath];
				];
			},
			Variables :> {filePath,stream},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		Example[{Messages, "MailServerError", "If there was an error sending emails, return $Failed:"},
			Email["ben@emeraldtherapeutics.com", Subject->""],
			$Failed,
			Messages:>{
				Email::MailServerError
			},
			Stubs:>{
				ConstellationRequest[
					KeyValuePattern["Path"->"ise/send-email/v2"],
					___
				] = HTTPError[None,"Email Error"],
				(* Force "sending" of email even if pointing at test database *)
				ProductionQ[] := True
			}
		],
		Example[
			{Messages, "IncompleteTemplateFields", "An error is thrown and $Failed is returned if not all required template field options have been specified:"},
			Email["ben@emeraldtherapeutics.com", Subject -> "ECL Notification Email", Template -> "admin-added", UserName -> "Frank Reynolds"],
			$Failed,
			Messages :> {Email::IncompleteTemplateFields},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				(* ConstellationRequest shouldn't actually be reached in this case, but stub to avoid sending email in case of failure *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Messages, "InvalidTemplate", "A hard error is thrown if an invalid template name is provided:"},
			Email["ben@emeraldtherapeutics.com", Template->"nonexistent-template"],
			$Failed,
			Messages :> {Email::InvalidTemplate},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				(* ConstellationRequest shouldn't actually be reached in this case, but stub to avoid sending email in case of failure *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Messages, "AttachmentFileTypeNotSupported", "A hard error is thrown if an invalid file type is attached:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Attachments->{file}],
			$Failed,
			Messages :> {Email::AttachmentFileTypeNotSupported},
			SetUp:>{
				If[FileExistsQ[FileNameJoin[{$HomeDirectory, "test.js"}]],
					DeleteFile[FileNameJoin[{$HomeDirectory, "test.js"}]];
				];

				file=CreateFile[FileNameJoin[{$HomeDirectory, "test.js"}]];
			},
			TearDown:>{
				If[FileExistsQ[file],
					DeleteFile[file];
				];
			},
			Variables :> {file},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],
		Example[
			{Messages, "AttachmentFileDoesNotExist", "A hard error is thrown if a non-existant file is attached:"},
			Email["ben@emeraldtherapeutics.com", Subject->"ECL Notification Email", Attachments->{"asdfdsa.txt"}],
			$Failed,
			Messages :> {Email::AttachmentFileDoesNotExist},
			Stubs:>{
				(* Prevent the email request from being submitted to the Constellation to avoid actually sending email in Examples *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = "OK"
			}
		],

		(* --- Tests --- *)
		Test[
			"Free-text email requests are carried out successfully:",
			Email["notifications@emeraldcloudlab.com", Subject->"ECL Unit Testing Subject", Message->"ECL Unit Testing Body"],
			"notifications@emeraldcloudlab.com"
		],

		Test[
			"Email is sent if ProductionQ[] = True and $EmailEnabled = True:",
			(
				Email["notifications@emeraldcloudlab.com", Subject->"ECL Unit Testing Subject", Message->"ECL Unit Testing Body"];
				emailSent
			),
			True,
			Stubs :> {
				emailSent = False,
				
				ProductionQ[] = True,
				$EmailEnabled = True,
				(* If ConstellationRequest is reached, email has been "sent"; change local variable to reflect this *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = (emailSent = True; "OK")
			}
		],		
		Test[
			"Email is not sent if ProductionQ[] = False:",
			(
				Email["notifications@emeraldcloudlab.com", Subject->"ECL Unit Testing Subject", Message->"ECL Unit Testing Body"];
				emailSent
			),
			False,
			Stubs :> {
				emailSent = False,
				
				ProductionQ[] = False,
				$EmailEnabled = True,
				(* If ConstellationRequest is reached, email has been "sent"; change local variable to reflect this *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = (emailSent = True; "OK")
			}
		],
		Test[
			"Email is not sent if $EmailEnabled = False:",
			(
				Email["notifications@emeraldcloudlab.com", Subject->"ECL Unit Testing Subject", Message->"ECL Unit Testing Body"];
				emailSent
			),
			False,
			Stubs :> {
				emailSent = False,
				
				ProductionQ[] = True,
				$EmailEnabled = False,
				(* If ConstellationRequest is reached, email has been "sent"; change local variable to reflect this *)
				ConstellationRequest[KeyValuePattern["Path"->"ise/send-email/v2"], ___] = (emailSent = True; "OK")
			}
		]
		
		(* Add tests for each template name *)
	}
];

DefineTests[
	emailRequestBody,
	{
		Test[
			"Cc and Bcc are correctly omitted when emtpy:",
			emailRequestBody[
				"From",
				"from@emeraldtherapeutics.com",
				{"to@emeraldtherapeutics.com"},
				{},
				{},
				"test subject",
				"test email body"
			],
			KeyValuePattern[{
				"from" -> KeyValuePattern[{"name" -> _String, "email" -> _String}],
				"to" -> {KeyValuePattern[{"name" -> _String, "email" -> _String}] ..},
				"subject" -> _String,
				"text_body" -> _String
			}]
		],
		Test["Cc is formatted properly when included:",
			emailRequestBody[
				"From",
				"from@emeraldtherapeutics.com",
				{"to@emeraldtherapeutics.com"},
				{"cc@emeraldtherapeutics.com"},
				{},
				"test subject",
				"test email body"
			],
			KeyValuePattern[{
				"from" -> KeyValuePattern[{"name" -> _String, "email" -> _String}],
				"to" -> {KeyValuePattern[{"name" -> _String, "email" -> _String}] ..},
				"cc" -> {KeyValuePattern[{"name" -> _String, "email" -> _String}] ..},
				"subject" -> _String,
				"text_body" -> _String
			}]
		],
		Test["Bcc is formatted properly when included:",
			emailRequestBody[
				"From",
				"from@emeraldtherapeutics.com",
				{"to@emeraldtherapeutics.com"},
				{},
				{"bcc@emeraldtherapeutics.com"},
				"test subject",
				"test email body"
			],
			KeyValuePattern[{
				"from" -> KeyValuePattern[{"name" -> _String, "email" -> _String}],
				"to" -> {KeyValuePattern[{"name" -> _String, "email" -> _String}] ..},
				"bcc" -> {KeyValuePattern[{"name" -> _String, "email" -> _String}] ..},
				"subject" -> _String,
				"text_body" -> _String
			}]
		],
		Test["Template request is formatted properly:",
			emailRequestBody[
				"From",
				"from@emeraldtherapeutics.com",
				{"to@emeraldtherapeutics.com"},
				{},
				{},
				"test subject",
				"admin-added",
				Association["field1"->"value1"],
				{}
			],
			KeyValuePattern[{
				"from" -> KeyValuePattern[{"name" -> _String, "email" -> _String}],
				"subject" -> _String,
				"template_name" -> _String,
				"substitutions" -> Association["field1"->"value1"]
			}]
		]
	}
];
