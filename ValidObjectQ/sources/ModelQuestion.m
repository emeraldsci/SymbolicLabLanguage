(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validModelQuestionQTests*)

validModelQuestionQTests[packet:PacketP[Model[Question]]]:={

	(* General fields filled in *)
	NotNullFieldTest[packet,{
		QuestionText,
		Author,
		GradeAutomatically
	}]

};



(* ::Subsection::Closed:: *)
(*validModelQuestionFreeformQTests*)

validModelQuestionFreeformQTests[packet:PacketP[Model[Question,Freeform]]]:={

	(* required fields *)
	NotNullFieldTest[packet,{
		CorrectAnswer
	}],

	Test["Freeform question is not set to be graded automatically:",
		Lookup[packet,GradeAutomatically],
		False
	]

};


(* ::Subsection::Closed:: *)
(*validModelQuestionMultipleChoiceQTests*)

validModelQuestionMultipleChoiceQTests[packet:PacketP[Model[Question,MultipleChoice]]]:={

	(* required fields *)
	NotNullFieldTest[packet,{
		PossibleResponses,
		CorrectAnswer,
		NumberOfResponses,
		PassingPercentage,
		Boolean,
		ResponseRules
	}],

	(* Currently only one correct response is supported - temp VOQs to enforce this *)

	Test["NumberOfResponses is one. Only one response from a candidate is supported at this time:",
		Lookup[packet,NumberOfResponses],
		Alternatives[1]
	],

	(* End temp VOQs *)

	(* Check that the correct response is a member of the possible responses *)
	Test["The correct responses are members of the possible responses:",
		Module[{possibleResponses,correctResponses},
			{possibleResponses,correctResponses}=Lookup[packet,{PossibleResponses,CorrectAnswer}];
			ContainsAll[possibleResponses,ToList[correctResponses]]
		],
		True
	],

	(* If the question is boolean, make sure the responses make sense *)
	Test["The possible responses and boolean flag are consistent:",
		Lookup[packet,{PossibleResponses,Boolean}],
		Alternatives[{{"True","False"}|{"False","True"},True},{Except[{"True","False"}|{"False","True"}],False}]
	],

	(* Check for duplicates *)
	Test["The possible responses are duplicate free:",
		DuplicateFreeQ[Lookup[packet,PossibleResponses]],
		True
	],

	Test["The reesponses rules are duplicate free:",
		DuplicateFreeQ[Keys[Lookup[packet,ResponseRules]]],
		True
	],

	(* Make sure the response rules match the question *)
	Test["The response rules are consistent with the possible responses:",
		Module[{possibleResponses,responseRules},
			{possibleResponses,responseRules}=Lookup[packet,{PossibleResponses,ResponseRules}];
			ContainsExactly[possibleResponses,Keys[responseRules]]
		],
		True
	]
};


(* ::Subsection:: *)
(*Test Registration *)


registerValidQTestFunction[Model[Question],validModelQuestionQTests];
registerValidQTestFunction[Model[Question,Freeform],validModelQuestionFreeformQTests];
registerValidQTestFunction[Model[Question,MultipleChoice],validModelQuestionMultipleChoiceQTests];
