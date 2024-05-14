(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Container, BumpTrap], {
	Description->"A container that holds a single sample.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		TaperGroundJointSize -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], TaperGroundJointSize]],
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designation of the mouth on this vessel.",
			Category -> "Container Specifications"
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Milli*Meter],GreaterP[0*Milli*Meter]},
			Description ->  "Interior size of the vessel's contents holding cavity in {X (left-to-right), Y (front-to-back)} directions.",
			Category -> "Dimensions & Positions"
		},
		InternalDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Interior diameter of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions"
		},
		InternalDepth -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalDepth]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Maximum interior depth of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		InternalBottomShape -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], InternalBottomShape]],
			Pattern :> WellShapeP,
			Description -> "Shape of the bottom of the vessel's contents holding cavity.",
			Category -> "Dimensions & Positions"
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
