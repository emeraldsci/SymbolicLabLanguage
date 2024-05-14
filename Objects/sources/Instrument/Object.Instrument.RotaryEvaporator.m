(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, RotaryEvaporator], {
	Description->"Rotary evaporator device for concentrating samples by removing solvent through lowering pressure, increased temperature, and rotating the vessel to avoid bumping.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		BathFluid -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BathFluid]],
			Pattern :> Water | Oil,
			Description -> "Conducting fluid type Stocked in the heat bath.",
			Category -> "Instrument Specifications"
		},
		VaporTrapType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VaporTrapType]],
			Pattern :> Coil | Finger,
			Description -> "The type of secondary solvent condenser placed directly upstream of the vacuum pump as a protective measure. Options include: Flow Coil and Cold Finger.",
			Category -> "Instrument Specifications"
		},
		VaporTrapCapacity -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],VaporTrapCapacity]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Maximum volume of condensation the cold trap can hold.",
			Category -> "Operating Limits"
		},
		BathVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],BathVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Volume of bath fluid required to fill the heat bath.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinBathTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature at which the rotovap can incubate.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxBathTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature at which the rotovap can incubate.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[0*RPM],
			Description -> "Maximum rotational speed of the rotovap.",
			Category -> "Operating Limits"
		},
		MaxFlaskVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxFlaskVolume]],
			Pattern :> GreaterP[0*Liter],
			Description -> "Maximum volume of evaporating flask that fits into the rotovap.",
			Category -> "Operating Limits"
		},
		RecirculatingPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, RecirculatingPump][RotaryEvaporator],
			Description -> "The pump that chills fluid and flows it through this rotary evaporator's condensing coil in order to condensor evaporated solvent.",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VacuumPump][RotaryEvaporator],
			Description -> "The pump which is connected to this rotary evaporator and is responsible for evacuating the rotovap and maintaining a vacuum in the instrument.",
			Category -> "Instrument Specifications"
		},
		VaporTrap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, VaporTrap][RotaryEvaporator],
			Description -> "The secondary vapor trap that is connected between this rotary evaporator and its connected vacuum pump as a secondary protection measure against evaporated solvent.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		PDUVacuumController -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUVacuumControllerIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUVacuumController]}, Download[Field[PDUVacuumController],IP]],
			Pattern :> IpP,
			Description -> "The PDU IP that the HeatBlock component is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUVacuumControllerPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUVacuumController], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDUVacuumController], PDUVacuumController]],
			Pattern :> PDUPortP,
			Description -> "The PDU port that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDURotationController -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDURotationControllerIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDURotationController]}, Download[Field[PDURotationController],IP]],
			Pattern :> IpP,
			Description -> "The PDU IP that the HeatBlock component is connected to.",
			Category -> "Instrument Specifications"
		},
		PDURotationControllerPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDURotationController], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDURotationController], PDURotationController]],
			Pattern :> PDUPortP,
			Description -> "The PDU port that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUWaterBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, PowerDistributionUnit][ConnectedInstruments, 1],
			Description -> "The PDU that this instrument is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUWaterBathIP -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUWaterBath]}, Download[Field[PDUWaterBath],IP]],
			Pattern :> IpP,
			Description -> "The PDU IP that the HeatBlock component is connected to.",
			Category -> "Instrument Specifications"
		},
		PDUWaterBathPort -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[PDUWaterBath], Field[Object]}, Computables`Private`getPDUPort[Field[Object], Field[PDURotationController], PDUWaterBath]],
			Pattern :> PDUPortP,
			Description -> "The PDU port that this instrument is connected to.",
			Category -> "Instrument Specifications"
		}
	}
}];
