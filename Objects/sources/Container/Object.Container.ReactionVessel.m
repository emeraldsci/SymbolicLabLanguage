(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, ReactionVessel], {
	Description->"A vessel used to hold various solutions or substances and house controlled reactions. Reaction vessels are used in different experiments, including solid phase synthesis and electrochemical synthesis.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Skirted -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has walls that extend below the vessel's well geometry to allow the vessel to stand upright on a flat surface without use of a rack.",
			Category -> "Container Specifications"
		},
		MinPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinPressure]],
			Pattern :> GreaterEqualP[0*PSI],
			Description -> "The minimum pressure to which the reaction vessel can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		MaxPressure -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxPressure]],
			Pattern :> GreaterP[0*PSI],
			Description -> "The maximum pressure to which the reaction vessel can be exposed without becoming damaged.",
			Category -> "Operating Limits"
		},
		SelfStandingContainers->{
			Format->Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SelfStandingContainers]],
			Pattern:>ObjectP[Model[Container,Rack]],
			Description->"Model of a container capable of holding this type of vessel upright.",
			Category->"Compatibility"
		}
	}
}];
