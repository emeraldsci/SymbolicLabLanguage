DefineObjectType[Object[Data, pHAdjustment], {
	Description->"A summary of the fixed additions and titrations completed before reaching a nominal pH or reaching the MaxAdditionVolume or MaxNumberOfCycles.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		NominalpH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0],
			Units -> None,
			Description -> "The pH specifed as the desired target in the experiment call.",
			Category ->  "General",
			Abstract -> True
		},
		FixedAdditions -> {
			Format -> Multiple,
			Class -> {VariableUnit, Link,Link},
			Pattern :> {GreaterP[0 Milliliter] | GreaterP[0 Gram]| GreaterP[0], _Link,_Link},
			Relation -> {Null, Model[Sample],Object[Sample]},
			Description -> "Describes the desired final concentrations or amounts of each component of this solution.",
			Headers ->  {"Amount","Component Model","Component"},
			Category ->  "General",
			Abstract -> True
		},
		(*Note:these may look redundant to pHLog but they are necessary for searches in AdjustpH resolver*)
		TitratingAcidModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the pH adjustment acid.",
			Category ->  "General",
			Developer -> True
		},
		TitratingBaseModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of the pH adjustment base.",
			Category ->  "General",
			Developer -> True
		},
		(*This may appear unecessary with TemporalLinks, but is actually important if AdjustpH is part of stocksolution*)
		SampleModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The desired model of the sample after the pH adjustment, or after StockSolution preparation if this pH adjustment is a part of StockSolution preparation. This is not applied to SamplesOut if pHAchieved is False.",
			Category ->  "General",
			Developer -> True
		},
		(*This may appear unecessary with TemporalLinks, but we need the working sample's volume right after sample preparation of the corresponding protocol, which is a tricky time point to catch.
		This also reduces the number of downloads one will need running adjustph resolver as we will need to find this time point first.*)
		SampleVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Micro,
			Description -> "The volume of the working sample prior to pH adjustment.",
			Category ->  "General",
			Developer -> True
		},
		ProbeType-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> pHProbeTypeP,
			Description -> "Indicates the style of pH probe used to perform pH readings during the titration.",
			Category -> "General",
			Abstract -> True
		},
		pHAliquot-> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if an aliquot of the solution was taken each time a pH reading needed to be made.",
			Category -> "General",
			Abstract -> True
		},
		Probe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Part,pHProbe],Model[Part,pHProbe]],
			Description -> "The probe which was used to measure the pH.",
			Category ->  "General",
			Abstract -> True
		},
		pH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> pHP,
			Units -> None,
			Description -> "The last pH recorded in the course of the experiment.",
			Category -> "Experimental Results",
			Abstract -> True
		},
		SampleImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An photo of the sample taken immediately after the last step in the experiment.",
			Category -> "Experimental Results"
		},
		pHAchieved -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the desired pHs were achieved without exceeding the volume or iteration limits.",
			Category -> "Experimental Results",
			Developer -> True
		},
		Overshot -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the pH crossed from one side of the nominal pH to the other at some point in the course of the titration before adjusting back.",
			Category -> "Experimental Results",
			Developer -> True
		},
		pHData -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data,pH],
			Description -> "The data associated with the final pH measurement indicating that the sample had reached the desired pH.",
			Category -> "Experimental Results"
		},
		pHLog -> {
			Format -> Multiple,
			Class -> {Link,Link, VariableUnit, Real, Link},
			Pattern :> {_Link,_Link, GreaterP[0 Milliliter]|GreaterP[0 Gram], pHP, _Link},
			Relation -> {Model[Sample],Object[Sample], Null, Null, Object[Data,pH]},
			Description -> "A record of the sample(s) added during pH adjustment and their effect on the pH.",
			Headers -> {"Addition Model","Addition Sample", "Amount", "pH","pH Data"},
			Category -> "Experimental Results"
		}
	}
}]