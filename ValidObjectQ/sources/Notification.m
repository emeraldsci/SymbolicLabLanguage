

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*validNotificationQTests*)


validNotificationQTests[packet:PacketP[Object[Notification]]] := {
	(* General fields filled in *)
	NotNullFieldTest[packet,{DateCreated, Message}]
};


(* ::Subsection::Closed:: *)
(*validNotificationECLTests*)

validNotificationECLQTests[packet:PacketP[Object[Notification, ECL]]] := {
	(* Required fields *)
	NotNullFieldTest[packet, {Recipients, Acknowledgements, ECLEvent, Team}],
	
	(* Required together *)
	RequiredTogetherTest[packet, {Application, VersionNumber}],
	
	(* Software update notifications must have information on the application and version numbers *)
	If[MatchQ[Lookup[packet, ECLEvent], SoftwareUpdate],
		Test[
			"For SoftwareUpdate notifications, both Application and VersionNumber must be populated:",
			Lookup[packet, {Application, VersionNumber}],
			{Except[Null], Except[Null]}
		],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validNotificationExperimentTests*)

validNotificationExperimentQTests[packet:PacketP[Object[Notification, Experiment]]] := {
	(* Required fields *)
	NotNullFieldTest[packet, {Recipients, Acknowledgements, ObjectAuthor}],
	
	(* Either StatusChange OR TroubleshootingEvent OR ScriptEvent must be populated *)
	AnyInformedTest[packet, {StatusChange, TroubleshootingEvent, ScriptEvent}],
	
	(* If this is a protocol notification, StatusChange must be populated *)
	RequiredTogetherTest[packet, {StatusChange, Protocol}],
	
	(* If this is a troubleshooting notification, Troubleshooting must be populated *)
	RequiredTogetherTest[packet, {TroubleshootingEvent, Troubleshooting}],
	
	(* If this is a script notification, Script must be populated *)
	RequiredTogetherTest[packet, {ScriptEvent, Script}]
};


(* ::Subsection::Closed:: *)
(*validNotificationLabBulletinQTests*)

validNotificationLabBulletinQTests[packet:PacketP[Object[Notification, LabBulletin]]]:={
	(* Required fields *)
	NotNullFieldTest[packet, {Message, Author, Status, StatusLog}],
	
	(* Required Null by shared field shaping *)
	NullFieldTest[packet, {Recipients, Acknowledgements}],
	
	(* Test that Reference is made up of AbsorbanceSpectraEmpty, AbsorbanceSpectraBlank, AbsorbanceSpectra *)
	Test["Last entry in StatusLog must match Status:",
		MatchQ[
			Lookup[packet,Status],
			LastOrDefault[Lookup[packet,StatusLog]][[2]]
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validNotificationMaterialsTests*)

validNotificationMaterialsQTests[packet:PacketP[Object[Notification, Materials]]] := {
	(* Required fields *)
	NotNullFieldTest[packet, {Recipients, Acknowledgements, MaterialsEvent, Requestor}],
	
	(* If notification relates to an order, Order must be populated *)
	(* May want to add SamplesShipped and SamplesReceived to this if that system also uses Order objects *)
	Test[
		"If and only if the notification relates to an order (MaterialsEvent->OrderPlaced|OrderReceived|OrderBackordered|OrderCanceled), Order must be populated:",
		Lookup[packet, {MaterialsEvent, Order}],
		Alternatives[
			{OrderPlaced|OrderReceived|OrderBackordered|OrderCanceled, Except[Null]},
			{Except[OrderPlaced|OrderReceived|OrderBackordered|OrderCanceled], _}
		]
	],
	
	(* If notification relates to approval of a Model or a Product, ObjectApproved field must be populated *)
	Test[
		"If and only if the notification relates to approval of a Model or a Product, ObjectApproved must be populated:",
		Lookup[packet, {MaterialsEvent, ObjectApproved}],
		Alternatives[
			{ModelApproved|ProductApproved, Except[Null]},
			{Except[ModelApproved|ProductApproved], Null}
		]
	],
	
	(* If notification relates to a protocol that needs materials, Protocol and MaterialsRequired must be populated *)
	Test[
		"If and only if the notification relates to a protocol that needs materials, Protocol and MaterialsRequired must be populated:",
		Lookup[packet, {MaterialsEvent, Protocol}],
		Alternatives[
			{MaterialsRequired, Except[Null]},
			{Except[MaterialsRequired], Null}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validNotificationTeamTests*)

validNotificationTeamQTests[packet:PacketP[Object[Notification, Team]]] := {
	(* Required fields *)
	NotNullFieldTest[packet, {Recipients, Acknowledgements, TeamEvent, Team}],
	
	(* If notification relates directly to a user (e.g. MemberInvitation), User must be populated *)
	Test[
		"If and only if the notification relates directly to a user, User must be populated:",
		Lookup[packet, {TeamEvent, Member}],
		Alternatives[
			{MemberAdded|MemberRemoved|AdminAdded|AdminRemoved, Except[Null]},
			{Except[MemberAdded|MemberRemoved|AdminAdded|AdminRemoved], Null}
		]
	]
};



registerValidQTestFunction[Object[Notification],validNotificationQTests];
registerValidQTestFunction[Object[Notification, ECL],validNotificationECLQTests];
registerValidQTestFunction[Object[Notification, Experiment],validNotificationExperimentQTests];
registerValidQTestFunction[Object[Notification, LabBulletin],validNotificationLabBulletinQTests];
registerValidQTestFunction[Object[Notification, Materials],validNotificationMaterialsQTests];
registerValidQTestFunction[Object[Notification, Team],validNotificationTeamQTests];
