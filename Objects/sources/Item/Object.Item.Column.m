(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,Column], {
	Description->"A separatory column used for chromatography.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		(* --- Method Information--- *)
		ColumnCartridge -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cartridge, Column][ColumnCartridge],
			Description -> "The column cartridge that is loaded into this column.",
			Category -> "Compatibility",
			Abstract -> True
		},
		StorageBufferComposition -> {
			Format -> Multiple,
			Class -> {VariableUnit, Link},
			Pattern :> {
				CompositionP,
				_Link
			},
			Relation -> {
				Null,
				IdentityModelTypeP
			},
			Headers -> {
				"Amount",
				"Identity Model"
			},
			Description -> "The chemical makeup of the buffer or solvent currently stored in the column from the last run or from the manufacturer.",
			Category -> "General",
			Abstract -> True
		},
		InjectionLog ->{
			Format->Multiple,
			Class->{
				DateInjected -> Date,
				Sample->Link,
				Protocol->Link,
				Type->Expression,
				Gradient->Link,
				InjectionVolume->Real,
				ColumnTemperature->Real,
				Orientation->Expression,
				Data->Link
			},
			Pattern:>{
				DateInjected -> _?DateObjectQ,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				Protocol->_Link,
				Type->InjectionTableP,
				Gradient->ObjectP[Object[Method]],
				InjectionVolume->GreaterEqualP[0*Micro Liter],
				ColumnTemperature->GreaterP[0*Celsius],
				Orientation->ColumnOrientationP,
				Data->_Link
			},
			Relation->{
				DateInjected -> Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Protocol ->Object[Protocol],
				Type->Null,
				Gradient->Object[Method],
				InjectionVolume->Null,
				ColumnTemperature->Null,
				Orientation->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected -> None,
				Sample->None,
				Protocol->None,
				Type->Null,
				Gradient->None,
				InjectionVolume->Micro Liter,
				ColumnTemperature->Celsius,
				Orientation->Null,
				Data->None
			},
			Description -> "The historical usage of the column.",
			Category -> "General"
		},
		StandardLog->{
			Format->Multiple,
			Class->{
				DateInjected -> Date,
				InjectionIndex ->Integer,
				Data->Link
			},
			Pattern:>{
				DateInjected -> _?DateObjectQ,
				InjectionIndex -> GreaterP[0,1],
				Data->_Link
			},
			Relation->{
				DateInjected -> Null,
				InjectionIndex->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected -> None,
				InjectionIndex -> None,
				Data->None
			},
			Description -> "Historical record of standard samples injected into column. InjectionIndex indicates where in the overall measurement queue, the sample was injected.",
			Category -> "General"
		},
		BlankLog->{
			Format->Multiple,
			Class->{
				DateInjected -> Date,
				InjectionIndex ->Integer,
				Data->Link
			},
			Pattern:>{
				DateInjected -> _?DateObjectQ,
				InjectionIndex -> GreaterP[0,1],
				Data->_Link
			},
			Relation->{
				DateInjected -> Null,
				InjectionIndex->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected -> None,
				InjectionIndex -> None,
				Data->None
			},
			Description -> "Historical record of blank samples injected into column. InjectionIndex indicates where in the overall measurement queue, the sample was injected.",
			Category -> "General"
		},
		StorageBufferLog ->{
			Format->Multiple,
			Class->{
				DateStored -> Date,
				Composition -> Expression,
				Protocol->Link,
				Gradient->Link,
				Data->Link
			},
			Pattern:>{
				DateStored -> _?DateObjectQ,
				Composition -> {{
					(CompositionP|Null),
					(_Link|Null)
				}..},
				Protocol->_Link,
				Gradient->ObjectP[Object[Method]],
				Data->_Link
			},
			Relation->{
				DateStored -> Null,
				Composition -> Null,
				Protocol ->Object[Protocol],
				Gradient->Object[Method],
				Data->Object[Data]
			},
			Units->{
				DateStored -> None,
				Composition -> None,
				Protocol->None,
				Gradient->None,
				Data->None
			},
			Description -> "The historical buffer storage within the column after runs.",
			Category -> "General"
		},

		(* --- GC Column Tracking --- *)
		GCInjectionLog ->{
			Format->Multiple,
			Class->{
				DateInjected -> Date,
				Sample->Link,
				Protocol->Link,
				Type->Expression,
				SamplePreparationOptions->Expression,
				SeparationMethod->Link,
				SamplingMethod->Expression,
				Data->Link
			},
			Pattern:>{
				DateInjected -> _?DateObjectQ,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				Protocol->_Link,
				Type->InjectionTableP,
				SamplePreparationOptions->{_Rule...},
				SeparationMethod->ObjectP[Object[Method]],
				SamplingMethod->GCSamplingMethodP,
				Data->_Link
			},
			Relation->{
				DateInjected -> Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Protocol->Object[Protocol],
				Type->Null,
				SamplePreparationOptions->Null,
				SeparationMethod->Object[Method],
				SamplingMethod->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected -> None,
				Sample->None,
				Protocol->None,
				Type->Null,
				SamplePreparationOptions->None,
				SeparationMethod->None,
				SamplingMethod->Null,
				Data->None
			},
			Description -> "The historical usage of the GC column.",
			Category -> "General"
		}
	}
}];
