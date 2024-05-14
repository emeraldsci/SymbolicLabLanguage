(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*RCFToRPM*)


(*converts RPM to RCF(Gs) given RPMs and radius*)

RCFToRPM[rcf:AccelerationP, rotor:ObjectP[Object[Container, CentrifugeRotor]]]:=RCFToRPM[rcf, Download[rotor, Model]];
RCFToRPM[rcf:AccelerationP, rotorModel:ObjectP[Model[Container, CentrifugeRotor]]]:=RCFToRPM[rcf, Download[rotorModel, MaxRadius]];

(* memoize to make things faster on repeated searches in experiment centrifuge *)
RCFToRPM[rcf:AccelerationP, radius:_?DistanceQ]:=RCFToRPM[rcf, radius]=Module[
	{},
	(*Add RCFToRPM to the list of Memoized functions*)
	If[!MemberQ[$Memoization, Core`Private`RCFToRPM],
		AppendTo[$Memoization, Core`Private`RCFToRPM]
	];

	(* calculate the RCF *)
	(* Formula Note: Relative centrifugal force (RCF) is defined as: RCF= (r*w^2)/g, where r is the rotational radius in meter, w is the angular velocity in radians per second,
	g is gravitational acceleration (m/s^2); For the convenience, we can convert the units to: RCF = (r (in meter)*(2*Pi*RPM/60)^2)/g, where RPM is revolution per minute*)
	Round[Quantity[Sqrt[N@Unitless[rcf, GravitationalAcceleration] * UnitConvert[GravitationalAcceleration] / (UnitConvert[radius, Meter] * ((2 * Pi / 60) * (1 / Second))^2)],
		RPM], 0.01]

];


(* ::Subsubsection::Closed:: *)
(*RPMToRCF*)


(*converts RCF(Gs) to RPM given RCF(Gs) and radius *)

RPMToRCF[rpm:RPMP, rotor:ObjectP[Object[Container, CentrifugeRotor]]]:=RPMToRCF[rpm, Download[rotor, Model]];
RPMToRCF[rpm:RPMP, rotorModel:ObjectP[Model[Container, CentrifugeRotor]]]:=RPMToRCF[rpm, Download[rotorModel, MaxRadius]];

(* memoize to make things faster on repeated searches in experiment centrifuge *)
RPMToRCF[rpm:RPMP, radius:_?DistanceQ]:=RPMToRCF[rpm, radius]=Module[
	{},
	(*Add RPMToRCF to the list of Memoized functions*)
	If[!MemberQ[$Memoization, Core`Private`RPMToRCF],
		AppendTo[$Memoization, Core`Private`RPMToRCF]
	];

	(* calculate the RPM *)
	(* Formula Note: Relative centrifugal force (RCF) is defined as: RCF= (r*w^2)/g, where r is the rotational radius in meter, w is the angular velocity in radians per second,
	g is gravitational acceleration (m/s^2); For the convenience, we can convert the units to: RCF = (r (in meter)*(2*Pi*RPM/60)^2)/g, where RPM is revolution per minute*)
	Round[Quantity[N@(UnitConvert[radius, Meter] * (2 * Pi * (Unitless[rpm, RPM] / 60) * (1 / Second))^2) / UnitConvert[GravitationalAcceleration],
		GravitationalAcceleration], 0.01]

];
