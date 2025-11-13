(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[User], {
	Description -> "A user with login information on the ECL.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Note certain fields are marked Developer so that External users cannot see that information when viewing Emeraldians via troubleshooting reports *)

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "This person's ECL username.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Email -> {
			Format -> Single,
			Class -> String,
			Pattern :> EmailP,
			Description -> "The controlling email address associated with this user's account.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		CommandCenterActivityHistory -> {
			Format -> Multiple,
			Class -> {
				ActivityDate -> Date,
				ActivityType -> Expression
			},
			Pattern :> {
				ActivityDate -> _?DateObjectQ,
				ActivityType -> CommandCenterActivityP
			},
			Description -> "A history of the user's activity in Command Center.
				Login and Logout activity types refer to when the user log into or log out of or close the app.
				Download, Search, and Upload activity types refer to when the user interacts with the database in Command Center
				but somehow those can't be categorized under any UI view listed below.
				CommandBuilder, Documentation, Experiments, Favorites, Inventory, NotebookCC (including library view),
				Notifications, ReloadKernel, Settings, Shipments activity types all refer to when the user interacts with Command Center in a specific UI view.",
			Headers -> {
				ActivityDate -> "Activity Date",
				ActivityType -> "Command Center Activity Type"
			},
			Category -> "Organizational Information",
			Developer -> True
		},
		Department -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> EmeraldDepartmentP | _String,
			Description -> "The department or function to which the user belongs in their parent organization.",
			Category -> "Organizational Information",
			Abstract -> True
		},

		(* --- Personal Information --- *)
		FirstName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The person's given name.",
			Category -> "Personal Information",
			Abstract -> True
		},
		MiddleName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Any names placed between the first and last name of the person.",
			Category -> "Personal Information",
			Abstract -> False,
			Developer -> True
		},
		LastName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The person's family name (surname).",
			Category -> "Personal Information",
			Abstract -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UserStatusP,
			Description -> "Indicates if a user has an active ECL account open or the account has been retired and retained for historical authorship information.",
			Category -> "Personal Information",
			Abstract -> True
		},
		CloudCertification -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CertificationLevelP,
			Description -> "The level of expertise using the ECL.",
			Category -> "Personal Information",
			Abstract -> True
		},
		TrainingModules->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[TrainingModule][User],
			Description->"The skills the person has or is working on obtaining.",
			Category->"Operations Information"
		},
		Certifications->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Certification][User],
			Description->"The skill sets this person has or is working on obtaining.",
			Category->"Operations Information"
		},


		(* --- Team Information --- *)
		FinancingTeams -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][Members],
			Description -> "Teams to which this users belongs which provide budget for membership, notebooks storage, and conducting experiments.",
			Category -> "Team Information"
		},
		SharingTeams -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Sharing][Members],
			Description -> "Teams to which this users belongs which provide sharing access rights to notebooks.",
			Category -> "Team Information"
		},

		(* --- Experiments & Simulations --- *)
		ProtocolsAuthored -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol][Author],
			Description -> "Any experiments that the user has executed commands to run on the ECL.",
			Category -> "Experiments & Simulations"
		},
		SimulationsAuthored -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Simulation][Author],
			Description -> "Any Simulations executed by the user.",
			Category -> "Experiments & Simulations"
		},
		ProtocolsArchived -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "Any experiments that the user has dismissed and does not want to track in dashboards.",
			Category -> "Experiments & Simulations",
			Developer -> True
		},

		(* --- Inventory --- *)
		TransactionsCreated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][Creator],
			Description -> "List of orders created by the user.",
			Category -> "Inventory"
		},
		TransactionsArchived -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "Any transactions that the user has dismissed and does not want to track in dashboards.",
			Category -> "Inventory",
			Developer -> True
		},

		(* --- Notifications --- *)
		TeamEmailPreference -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "User preference for whether to receive email notifications for changes in team membership, team administration, and notebook creation / deletion / collaboration.",
			Category -> "Notifications"
		},
		NotebookEmailPreferences -> {
			Format -> Multiple,
			Class -> {Notebook -> Link, Protocol -> Expression, Troubleshooting -> Expression, Materials -> Expression},
			Pattern :> {Notebook -> _Link, Protocol -> NotificationRecipientFilterP, Troubleshooting -> NotificationRecipientFilterP, Materials -> NotificationRecipientFilterP},
			Relation -> {Notebook -> Object[LaboratoryNotebook], Protocol -> Null, Troubleshooting -> Null, Materials -> Null},
			Headers -> {Notebook -> "Laboratory Notebook", Protocol -> "Protocol Updates", Troubleshooting -> "Troubleshooting Updates", Materials -> "Materials Updates"},
			Description -> "Notebook-specific user preferences for whether to receive email notifications relating to their own or others' protocols, troubleshootings, and materials.",
			Category -> "Notifications"
		},

		(* --- General --- *)
		LibraryPreferences -> {
			Format -> Multiple,
			Class -> {
				ColumnWidth -> String,
				ColumnSortField -> String,
				ColumnSortMethod -> String
			},
			Pattern :> {
				ColumnWidth -> _String,
				ColumnSortField -> _,
				ColumnSortMethod -> "Ascending" | "Descending" | "Manual"
			},
			Relation -> {
				ColumnWidth -> Null,
				ColumnSortField -> Null,
				ColumnSortMethod -> Null
			},
			Description -> "Any modifications user makes to the library view that need to be saved as preferences.",
			Category -> "General"
		},
		FavoriteObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Favorite][Authors],
			Description -> "All the objects that this user marked as favorite or bookmark.",
			Category -> "General"
		},
		FavoriteFolderPreferences -> {
			Format -> Multiple,
			Class -> {
				FavoriteFolder -> Link,
				ColumnObjectType -> String,
				ColumnOrder -> String,
				ColumnWidth -> String,
				ColumnSortField -> String,
				ColumnSortMethod -> String,
				RowOrder -> String
			},
			Pattern :> {
				FavoriteFolder -> _Link,
				ColumnObjectType -> _,
				ColumnOrder -> _String,
				ColumnWidth -> _String,
				ColumnSortField -> _,
				ColumnSortMethod -> "Ascending" | "Descending" | "Manual",
				RowOrder -> _String (* ids will be comma separated string *)
			},
			Relation -> {
				FavoriteFolder -> Object[Favorite, Folder],
				ColumnObjectType -> Null,
				ColumnOrder -> Null,
				ColumnWidth -> Null,
				ColumnSortField -> Null,
				ColumnSortMethod -> Null,
				RowOrder -> Null
			},
			Description -> "Any modifications user makes to the favorite folders view that need to be saved as preferences.",
			Category -> "General"
		},
		FavoriteBookmarkPreferences -> {
			Format -> Multiple,
			Class -> {
				LaboratoryNotebook -> Link,
				ColumnObjectType -> String,
				ColumnOrder -> String,
				ColumnWidth -> String,
				ColumnSortField -> String,
				ColumnSortMethod -> String,
				RowOrder -> String
			},
			Pattern :> {
				LaboratoryNotebook -> _Link,
				ColumnObjectType -> _,
				ColumnOrder -> _String,
				ColumnWidth -> _String,
				ColumnSortField -> _,
				ColumnSortMethod -> "Ascending" | "Descending" | "Manual",
				RowOrder -> _String (* ids will be comma separated string *)
			},
			Relation -> {
				LaboratoryNotebook -> Object[LaboratoryNotebook],
				ColumnObjectType -> Null,
				ColumnOrder -> Null,
				ColumnWidth -> Null,
				ColumnSortField -> Null,
				ColumnSortMethod -> Null,
				RowOrder -> Null
			},
			Description -> "Any modifications user makes to the bookmarks view that need to be saved as preferences.",
			Category -> "General"
		},
		LaboratoryNotebookOrder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook],
			Description -> "Manual sort order defined by the user for the list of notebooks across all views.",
			Category -> "General"
		},
		LaboratoryNotebookOrderByTeam -> {
			Format -> Multiple,
			Class -> {
				Team -> String,
				RowOrder -> String
			},
			Pattern :> {
				Team -> _String,
				RowOrder -> _String (* ids will be comma separated string *)
			},
			Description -> "Manual sort order defined by the user for laboratory notebooks by team.",
			Category -> "General"
		},
		FavoriteFolderOrder -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Favorite, Folder],
			Description -> "Sort order selected by the user for favorite folders in the sidebar of favorites dashboard.",
			Category -> "General"
		},
		RecentlySelectedFavorite -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[LaboratoryNotebook],
				Object[Favorite, Folder]
			],
			Description -> "SLL Id of the last selected favorite folder or bookmark notebook in the favorites dashboard by the user.",
			Category -> "General"
		},
		InventoryPreferences -> {
			Format -> Multiple,
			Class -> {
				LaboratoryNotebook -> Link,
				ColumnObjectType -> String,
				ColumnOrder -> String,
				ColumnWidth -> String,
				ColumnSortField -> String,
				ColumnSortMethod -> String,
				RowOrder -> String
			},
			Pattern :> {
				LaboratoryNotebook -> _Link,
				ColumnObjectType -> _,
				ColumnOrder -> _String,
				ColumnWidth -> _String,
				ColumnSortField -> _,
				ColumnSortMethod -> "Ascending" | "Descending" | "Manual",
				RowOrder -> _String (* ids will be comma separated string *)
			},
			Relation -> {
				LaboratoryNotebook -> Object[LaboratoryNotebook],
				ColumnObjectType -> Null,
				ColumnOrder -> Null,
				ColumnWidth -> Null,
				ColumnSortField -> Null,
				ColumnSortMethod -> Null,
				RowOrder -> Null
			},
			Description -> "Any modifications user makes to the inventory view that need to be saved as preferences.",
			Category -> "General"
		},
		RecentlySelectedInventoryNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook],
			Description -> "SLL Id of the last selected inventory notebook in the inventory dashboard by the user.",
			Category -> "General"
		},
		LastSelectedObjects -> {
			Format -> Multiple,
			Class -> {
				ObjectUsed -> Link,
				DateSelected -> Date,
				UsedIn -> String
			},
			Pattern :> {
				ObjectUsed -> _Link,
				DateSelected -> _?DateObjectQ,
				UsedIn -> _String
			},
			Relation -> {
				ObjectUsed -> Alternatives[
					Object[],
					Model[]
				],
				DateSelected -> Null,
				UsedIn -> Null
			},
			Developer->True,
			Description -> "Last objects selected by user in object selector view in Command Center.",
			Category -> "General"
		},
		LastSelectedExperiments -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last experiments selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		LastSelectedSamples -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last samples selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		LastSelectedPlots -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last plots selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		LastSelectedAnalyses -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last analyses selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		LastSelectedSimulations -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last simulations selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		LastSelectedUploads -> {
			Format -> Multiple,
			Class -> {
				DateSelected -> Date,
				Function -> Expression,
				Index -> Integer
			},
			Pattern :> {
				DateSelected -> _?DateObjectQ,
				Function -> _Symbol,
				Index -> _Integer
			},
			Relation -> {
				DateSelected -> Null,
				Function -> Null,
				Index -> Null
			},
			Developer->True,
			Description -> "Last uploads selected by user in command builder view in Command Center.",
			Category -> "General"
		},
		DefaultNotebookScaling -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "User preference for default zoom scale for notebooks.",
			Category -> "General"
		},
		DefaultNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[LaboratoryNotebook],
			Description -> "User preference in Command Center Desktop for the default laboratory notebook set by the user.",
			Category -> "General"
		},
		ShowProtocolToolbar -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the protocol toolbar within a notebook is visible when notebooks are initially opened. This toolbar shows all protocols within the notebook and displays information about them.",
			Category -> "General",
			Developer -> True
		},
		HideCompletedProtocols -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if we should hide protocols in status of Completed within the protocols toolbar.",
			Category -> "General",
			Developer -> True
		},
		ShowFunctionToolbar -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the function toolbar within a notebook is visible when notebooks are initially opened. This toolbar allows users to reload the function(s) defined in the notebook as well as if it can autoload.",
			Category -> "General",
			Developer -> True
		},
		ShowScriptToolbar -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the script toolbar within a notebook is visible when notebooks are initially opened. This toolbar controls state of scripts via Run / Pause / Stop and will display exceptions that happen within script runs.",
			Category -> "General",
			Developer -> True
		},
		PageSaveType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ManualSave|Reminder|AutoSave,
			Description -> "User preference for saving pages.",
			Category -> "General"
		},
		PageSaveTimer -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0*Millisecond],
			Units -> Millisecond,
			Description -> "User preference for timer on save reminder or autosave.",
			Category -> "General"
		},
		ScratchPageSave -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "User preference for scratch page on save reminder or autosave.",
			Category -> "General"
		},

		(* --- Operations Information --- *)
		PrintStickersLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Alternatives[Object[Sample],Object[Container],Object[Instrument],Object[Part],Object[Sensor],Object[Plumbing],Object[Wiring],Object[Item],Object[Package]]},
			Description -> "Indicates times at which this user printed stickers.",
			Headers -> {"Date", "Object"},
			Category -> "Operations Information",
			Developer -> True
		},

		(* --- Operations & Maintenance --- *)
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Qualification]], GreaterP[0*Day] | Null}...},
			Description -> "The frequencies of the Qualifications targeting this user.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model","Time Interval"},
			Developer -> True
		},
		RecentQualifications -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of the most recent Qualifications run for this user.",
			Headers -> {"Date","Qualification","Qualification Model"},
			Category -> "Qualifications & Maintenance",
			Abstract -> True
		},
		QualificationLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "All Qualifications run for this user over time.",
			Headers -> {"Date","Qualification","Qualification Model"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		NextQualificationDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Qualification], Null},
			Description -> "A list of the dates on which the next qualifications will be enqueued for this user.",
			Headers -> {"Qualification Model","Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Qualified -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this user has passed its most recent qualification.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		QualificationResultsLog -> {
			Format -> Multiple,
			Class -> {
				Date -> Date,
				Qualification -> Link,
				Result -> Expression
			},
			Pattern :> {
				Date -> _?DateObjectQ,
				Qualification -> _Link,
				Result -> QualificationResultP
			},
			Relation -> {
				Date -> Null,
				Qualification -> Object[Qualification],
				Result -> Null
			},
			Headers -> {
				Date -> "Date Evaluated",
				Qualification -> "Qualification",
				Result -> "Result"
			},
			Description -> "A record of the qualifications run on this user and their results.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular qualification schedule of this user, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		}
	}
}]
