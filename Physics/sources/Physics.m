(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Section:: *)
(*Physical Relationships*)


(* ::Subsection::Closed:: *)
(*Conservation Laws*)


(* ::Subsubsection::Closed:: *)
(*ConservationOfMass*)


ConservationOfMass=(C1*V1==C2*V2);


(* ::Subsection::Closed:: *)
(*Optics*)


(* ::Subsubsection::Closed:: *)
(*BeersLaw*)


BeersLaw:=(Abs== \[CurlyEpsilon] C b );


(* ::Subsection::Closed:: *)
(*Thermodynamics*)


(* ::Subsubsection::Closed:: *)
(*GibbsFreeEnergy*)


GibbsFreeEnergy=(\[CapitalDelta]G==\[CapitalDelta]H-T \[CapitalDelta]S);


(* ::Subsubsection::Closed:: *)
(*GibbsEquilibrium*)


GibbsEquilibrium=(\[CapitalDelta]G==-R T Log[Keq]);


(* ::Subsubsection::Closed:: *)
(*TwoStateEquilibrium*)


TwoStateEquilibrium=(ABeq==(1+2 Ct Keq-Sqrt[1+4 Ct Keq])/(2 Keq));


(* ::Subsubsection::Closed:: *)
(*TwoStateEquilibriumFull*)


TwoStateEquilibriumFull=(ABeq==1/2 E^(-(\[CapitalDelta]S/R)) ((A0+B0) E^(\[CapitalDelta]S/R)-E^(\[CapitalDelta]H/(R T)) (-1+Sqrt[1+2 (A0+B0) E^((-\[CapitalDelta]H+T \[CapitalDelta]S)/(R T))+(A0-B0)^2 E^((2 (-\[CapitalDelta]H+T \[CapitalDelta]S))/(R T))])));


(* ::Subsubsection::Closed:: *)
(*TwoStateEquilibriumFullWithKeq*)


TwoStateEquilibriumFullWithKeq=(ABeq==(A0/2+B0/2+1/2 1/Keq-1/2 1/Keq Sqrt[1+2 (A0+B0)Keq+(A0-B0)^2 Keq^2]));


(* ::Subsubsection::Closed:: *)
(*BimolecularMelting*)


BimolecularMelting=(Tm==\[CapitalDelta]H/(\[CapitalDelta]S-R Log[2 Molar /Ct]));


(* ::Subsection::Closed:: *)
(*Kinetcs*)


(* ::Subsubsection::Closed:: *)
(*DetailedBalance*)


DetailedBalanceExpression=(Keq==kf/kb);


(* ::Subsubsection::Closed:: *)
(*FirstOrderIrreversible*)


FirstOrderIrreversible={{A->B},{A0 E^(-k t),E^(-k t) (-A0+A0 E^(k t)+B0 E^(k t))}};


(* ::Subsubsection::Closed:: *)
(*FirstOrderReversible*)


FirstOrderReversible={{A\[Equilibrium]B},{(A0 kb+B0 kb-B0 E^((-kb-kf) t) kb+A0 E^((-kb-kf) t) kf)/(kb+kf),(B0 E^((-kb-kf) t) kb+A0 kf+B0 kf-A0 E^((-kb-kf) t) kf)/(kb+kf)}};


(* ::Subsubsection::Closed:: *)
(*FirstOrderIrreversibleHeterogeneous*)


FirstOrderIrreversibleHeterogeneous={{A->B+C},{A0/E^(k1*t), A0 + B0 - A0/E^(k1*t), A0 + C0 - A0/E^(k1*t)}};


(* ::Subsubsection::Closed:: *)
(*FirstOrderReversibleHeterogeneous*)


FirstOrderReversibleHeterogeneous={{A\[Equilibrium]B+C},{((2*A0 + B0 + C0)*kb1 + kf1 + Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*    Tan[(Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*t)/2 -       ArcTan[((B0 + C0)*kb1 + kf1)/Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]]])/(2*kb1),  -(-(B0*kb1) + C0*kb1 + kf1 + Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*     Tan[(Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*t)/2 -        ArcTan[((B0 + C0)*kb1 + kf1)/Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]]])/(2*kb1),  -(B0*kb1 - C0*kb1 + kf1 + Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*Tan[(Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]*t)/2 -        ArcTan[((B0 + C0)*kb1 + kf1)/Sqrt[-((B0 - C0)^2*kb1^2) - 2*(2*A0 + B0 + C0)*kb1*kf1 - kf1^2]]])/(2*kb1)}};


(* ::Subsubsection::Closed:: *)
(*FirstOrderIrreversibleHomogeneous*)


FirstOrderIrreversibleHomogeneous={{A->2B},{A0 E^(-k1 t),E^(-k1 t) (-2 A0+2 A0 E^(k1 t)+B0 E^(k1 t))}};


(* ::Subsubsection::Closed:: *)
(*FirstOrderReversibleHomogeneous*)


FirstOrderReversibleHomogeneous={{A\[Equilibrium]2B},{(k1 + 4*(2*A0 + B0)*k2 - Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2]*Tanh[(Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2]*t)/2 +       ArcTanh[(k1 + 4*B0*k2)/(Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2])]])/(8*k2),  (-k1 + Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2]*Tanh[(Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2]*t)/2 + ArcTanh[(k1 + 4*B0*k2)/(Sqrt[k1]*Sqrt[k1 + 8*(2*A0 + B0)*k2])]])/(4*k2)}};SecondOrderHeterogeneousIrreversible={{A+B->C},If[A0==B0,{A0-(A0^2 k t)/(1+A0 k t),A0-(A0^2 k t)/(1+A0 k t),C0+(A0^2 k t)/(1+A0 k t)},{(A0 (A0-B0) E^((A0-B0) k t))/(-B0+A0 E^((A0-B0) k t)),((A0-B0) B0)/(-B0+A0 E^((A0-B0) k t)),B0+C0+((A0-B0) B0)/(B0-A0 E^((A0-B0) k t))}]};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousIrreversibleFirstOrder*)


SecondOrderHeterogeneousIrreversibleFirstOrder={{A+B->C},{(A0*(A0 - B0))/(A0 - B0*E^((-A0 + B0)*k1*t)), ((A0 - B0)*B0)/(-B0 + A0*E^((A0 - B0)*k1*t)),  B0 + C0 + ((A0 - B0)*B0)/(B0 - A0*E^((A0 - B0)*k1*t))}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousReversibleFirstOrder*)


SecondOrderHeterogeneousReversibleFirstOrder={{A+B\[Equilibrium]C},{A0+(2 (-C0 kb+A0 B0 kf))/(-kb-(A0+B0) kf-Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] t]),B0+(2 (-C0 kb+A0 B0 kf))/(-kb-(A0+B0) kf-Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] t]),C0-(2 (-C0 kb+A0 B0 kf))/(-kb-(A0+B0) kf-Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 kf (-C0 kb+A0 B0 kf)+(-kb-(A0+B0) kf)^2] t])}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousIrreversibleSecondOrderHeterogeneous*)


SecondOrderHeterogeneousIrreversibleSecondOrderHeterogeneous={{A+B->C+D},{(A0*(A0 - B0))/(A0 - B0*E^((-A0 + B0)*k1*t)), ((A0 - B0)*B0)/(-B0 + A0*E^((A0 - B0)*k1*t)),  B0 + C0 + ((A0 - B0)*B0)/(B0 - A0*E^((A0 - B0)*k1*t)), B0 + D0 + ((A0 - B0)*B0)/(B0 - A0*E^((A0 - B0)*k1*t))}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousReversibleSecondOrderHeterogeneous*)


SecondOrderHeterogeneousReversibleSecondOrderHeterogeneous={{A+B\[Equilibrium]C+D},{A0+(2 (-C0 D0 kb+A0 B0 kf))/(-(C0+D0) kb-(A0+B0) kf-Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] t]),B0+(2 (-C0 D0 kb+A0 B0 kf))/(-(C0+D0) kb-(A0+B0) kf-Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] t]),C0-(2 (-C0 D0 kb+A0 B0 kf))/(-(C0+D0) kb-(A0+B0) kf-Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] t]),D0-(2 (-C0 D0 kb+A0 B0 kf))/(-(C0+D0) kb-(A0+B0) kf-Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] Coth[1/2 Sqrt[-4 (-kb+kf) (-C0 D0 kb+A0 B0 kf)+(-(C0+D0) kb-(A0+B0) kf)^2] t])}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousIrreversibleSecondOrderHomogeneous*)


SecondOrderHeterogeneousIrreversibleSecondOrderHomogeneous={{A+B->2C},{(A0*(A0 - B0))/(A0 - B0*E^((-A0 + B0)*k1*t)), ((A0 - B0)*B0)/(-B0 + A0*E^((A0 - B0)*k1*t)),  2*B0 + C0 + (2*(A0 - B0)*B0)/(B0 - A0*E^((A0 - B0)*k1*t))}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHeterogeneousReversibleSecondOrderHomogeneous*)


SecondOrderHeterogeneousReversibleSecondOrderHomogeneous={{A+B\[Equilibrium]2C},{(8*A0*kb1 + 4*C0*kb1 - A0*kf1 + B0*kf1 - Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*    Tanh[(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*t)/2 +       ArcTanh[(4*C0*kb1 + (A0 + B0)*kf1)/(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1])]])/  (8*kb1 - 2*kf1), (8*B0*kb1 + 4*C0*kb1 + A0*kf1 - B0*kf1 - Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*    Tanh[(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*t)/2 +       ArcTanh[(4*C0*kb1 + (A0 + B0)*kf1)/(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1])]])/  (8*kb1 - 2*kf1), (-((A0 + B0 + C0)*kf1) + Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*    Tanh[(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1]*t)/2 +       ArcTanh[(4*C0*kb1 + (A0 + B0)*kf1)/(Sqrt[kf1]*Sqrt[4*(2*A0 + C0)*(2*B0 + C0)*kb1 + (A0 - B0)^2*kf1])]])/(4*kb1 - kf1)}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousIrreversible*)


SecondOrderHomogeneousIrreversible={{2A->B},{A0/(1+2 A0 k t),(B0+A0^2 k t+2 A0 B0 k t)/(1+2 A0 k t)}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousReversibleFirstOrder*)


SecondOrderHomogeneousReversibleFirstOrder={{2A\[Equilibrium]B},{(-kb+Sqrt[kb] Sqrt[kb+8 A0 kf+16 B0 kf] Tanh[1/2 Sqrt[kb] Sqrt[kb+8 (A0+2 B0) kf] t+ArcTanh[(kb+4 A0 kf)/(Sqrt[kb] Sqrt[kb+8 (A0+2 B0) kf])]])/(4 kf),1/(8 kf) (kb+4 A0 kf+8 B0 kf-Sqrt[kb] Sqrt[kb+8 A0 kf+16 B0 kf] Tanh[1/2 Sqrt[kb] Sqrt[kb+8 (A0+2 B0) kf] t+ArcTanh[(kb+4 A0 kf)/(Sqrt[kb] Sqrt[kb+8 (A0+2 B0) kf])]])}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousIrreversibleSecondOrderHeterogeneous*)


SecondOrderHomogeneousIrreversibleSecondOrderHeterogeneous={{2A->B+C},{A0/(1 + 2*A0*k1*t), (B0 + A0*(A0 + 2*B0)*k1*t)/(1 + 2*A0*k1*t), (C0 + A0*(A0 + 2*C0)*k1*t)/(1 + 2*A0*k1*t)}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousReversibleSecondOrderHeterogeneous*)


SecondOrderHomogeneousReversibleSecondOrderHeterogeneous={{2A\[Equilibrium]B+C},{1/(kb-4 kf) (A0 kb+B0 kb+C0 kb-Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] Tanh[1/2 Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] t+ArcTanh[((B0+C0) kb+4 A0 kf)/(Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf])]]),1/(2 (kb-4 kf)) (B0 kb-C0 kb-4 A0 kf-8 B0 kf+Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] Tanh[1/2 Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] t+ArcTanh[((B0+C0) kb+4 A0 kf)/(Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf])]]),1/(2 (kb-4 kf)) (-B0 kb+C0 kb-4 A0 kf-8 C0 kf+Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] Tanh[1/2 Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf] t+ArcTanh[((B0+C0) kb+4 A0 kf)/(Sqrt[kb] Sqrt[(B0-C0)^2 kb+4 (A0+2 B0) (A0+2 C0) kf])]])}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousIrreversibleSecondOrderHomogenous*)


SecondOrderHomogeneousIrreversibleSecondOrderHomogenous={{2A->2B},{A0/(1 + 2*A0*k1*t), A0 + B0 - A0/(1 + 2*A0*k1*t)}};


(* ::Subsubsection::Closed:: *)
(*SecondOrderHomogeneousReversibleSecondOrderHomogeneous*)


SecondOrderHomogeneousReversibleSecondOrderHomogeneous={{2A\[Equilibrium]2B},"DSolve incomplete"};


(* ::Subsubsection::Closed:: *)
(*CompetitiveFirstOrderIrreversible*)


CompetitiveFirstOrderIrreversible={{A->B,A->C},{A0 E^(-(k1+k2) t),B0-(A0 (-1+E^(-(k1+k2) t)) k1)/(k1+k2),C0-(A0 (-1+E^(-(k1+k2) t)) k2)/(k1+k2)}};


(* ::Subsubsection::Closed:: *)
(*CompetitiveFirstOrderReversible*)


CompetitiveFirstOrderReversible={{A\[Equilibrium]B,A\[Equilibrium]C},{A0+(2 E^(-(1/2) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (C0 kb2 (-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t)) kb1^3+kb1^2 (-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (2 kb2-3 kf1+2 kf2)+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (2 kb2-3 kf1+2 kf2)+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])+kf1 (2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])+kb1 (2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2^2+3 kf1^2+kf2^2+2 kb2 (-2 kf1+kf2))-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2^2+3 kf1^2+kf2^2+2 kb2 (-2 kf1+kf2))-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))+kf2 (B0 kb1 (-kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))))+A0 (-kb1^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb1 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) kb1 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) kb1 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))))))/(((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))) (kb1+kb2+kf1+kf2-Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))+(2 E^(-(1/2) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (B0 kb1 (-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t)) kb1^2 (kb2+kf2)+2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2+kf2) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2+kf2) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)+kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 (-4 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2+kf2) (kb2-kf1+kf2)+2 (1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2+kf2) (kb2-kf1+kf2)-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))+kf1 (C0 kb2 (-kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))))+A0 (kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) kb2 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) kb2 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))))))/(((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))) (kb1+kb2+kf1+kf2-Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])),B0-(2 E^(-(1/2) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (B0 kb1 (-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t)) kb1^2 (kb2+kf2)+2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2+kf2) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2+kf2) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)+kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 (-4 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2+kf2) (kb2-kf1+kf2)+2 (1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2+kf2) (kb2-kf1+kf2)-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))+kf1 (C0 kb2 (-kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))))+A0 (kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) kb2 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) kb2 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))))))/(((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))) (kb1+kb2+kf1+kf2-Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])),C0-(2 E^(-(1/2) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (C0 kb2 (-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t)) kb1^3+kb1^2 (-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (2 kb2-3 kf1+2 kf2)+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (2 kb2-3 kf1+2 kf2)+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])+kf1 (2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2^2+2 kb2 (-kf1+kf2)+(kf1+kf2)^2)-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))])+kb1 (2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) (kb2^2+3 kf1^2+kf2^2+2 kb2 (-2 kf1+kf2))-(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) (kb2^2+3 kf1^2+kf2^2+2 kb2 (-2 kf1+kf2))-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))+kf2 (B0 kb1 (-kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))))+A0 (-kb1^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1^2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kb2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-kb1 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+2 kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb2 kf1 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]+kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t) kb1 kf2 Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]-2 E^(1/2 (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) t) kb1 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))+(1+E^(Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))] t)) kb1 ((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2)))))))/(((kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))) (kb1+kb2+kf1+kf2-Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]) (kb1+kb2+kf1+kf2+Sqrt[(kb1+kb2+kf1+kf2)^2-4 (kb2 kf1+kb1 (kb2+kf2))]))}};


(* ::Subsubsection::Closed:: *)
(*CompetitiveSecondOrderHeterogeneousIrreversible*)


CompetitiveSecondOrderHeterogeneousIrreversible={{A+B->C,A+D->F},"DSolve failed"};


(* ::Subsubsection::Closed:: *)
(*CompetitiveSecondOrderHomogeneousIrreversible*)


CompetitiveSecondOrderHomogeneousIrreversible={{2A-> B,2A->C},{A0/(1 + 2*A0*(k1 + k2)*t), (B0 + A0*(A0*k1 + 2*B0*(k1 + k2))*t)/(1 + 2*A0*(k1 + k2)*t), (C0 + A0*(A0*k2 + 2*C0*(k1 + k2))*t)/  (1 + 2*A0*(k1 + k2)*t)}};


(* ::Subsubsection::Closed:: *)
(*CompetitiveSecondOrderHeterogeneousReversibleFirstOrder*)


CompetitiveSecondOrderHeterogeneousReversibleFirstOrder={{A+B\[Equilibrium]C,A+D\[Equilibrium]F},"DSolve Incomplete"};


(* ::Subsubsection::Closed:: *)
(*ConsecutiveFirstOrderIrreversibleFirstOrderIrreversible*)


ConsecutiveFirstOrderIrreversibleFirstOrderIrreversible={{A->B,B->C},{A0 E^(-k1 t),-((E^(-k1 t-k2 t) (-A0 E^(k1 t) k1-B0 E^(k1 t) k1+A0 E^(k2 t) k1+B0 E^(k1 t) k2))/(k1-k2)),C0+(B0 E^(-k2 t) (-1+E^(k2 t)) (k1-k2)+A0 (k1-E^(-k2 t) k1+(-1+E^(-k1 t)) k2))/(k1-k2)}};


(* ::Subsubsection::Closed:: *)
(*ConsecutiveFirstOrderIrreversibleFirstOrderIrreversibleFirstOrderIrreversible*)


ConsecutiveFirstOrderIrreversibleFirstOrderIrreversibleFirstOrderIrreversible={{A->B,B->C,C->D},{A0 E^(-k1 t),-((E^(-k1 t-k2 t) (-A0 E^(k1 t) k1-B0 E^(k1 t) k1+A0 E^(k2 t) k1+B0 E^(k1 t) k2))/(k1-k2)),C0+(B0 E^(-k2 t) (-1+E^(k2 t)) (k1-k2)+A0 (k1-E^(-k2 t) k1+(-1+E^(-k1 t)) k2))/(k1-k2)-1/((k1-k2) (k1-k3) (k2-k3)) E^(-(k1+k2+k3) t) (A0 (E^((k1+k2) t) k1 k2 (-k1+k2)+E^((k1+k2+k3) t) (k1-k2) (k1-k3) (k2-k3)+E^((k1+k3) t) k1 (k1-k3) k3+E^((k2+k3) t) k2 k3 (-k2+k3))+E^(k1 t) (-k1+k2) ((B0+C0) E^((k2+k3) t) (k2-k3) (-k1+k3)+(k1-k3) (-B0 E^(k3 t) k3+E^(k2 t) ((B0+C0) k2-C0 k3)))),D0+1/((k1-k2) (k1-k3) (k2-k3)) E^(-(k1+k2+k3) t) (A0 (E^((k1+k2) t) k1 k2 (-k1+k2)+E^((k1+k2+k3) t) (k1-k2) (k1-k3) (k2-k3)+E^((k1+k3) t) k1 (k1-k3) k3+E^((k2+k3) t) k2 k3 (-k2+k3))+E^(k1 t) (-k1+k2) ((B0+C0) E^((k2+k3) t) (k2-k3) (-k1+k3)+(k1-k3) (-B0 E^(k3 t) k3+E^(k2 t) ((B0+C0) k2-C0 k3))))}};


(* ::Subsubsection::Closed:: *)
(*ConsecutiveSecondOrderIrreversibleFirstOrder*)


ConsecutiveSecondOrderIrreversibleFirstOrder={{A+B->C,C->D},"Crash"};


(* ::Subsection::Closed:: *)
(*Thermodynamics*)


(*
(* P + A Overscript[\[Equilibrium], Subscript[K, A]] PA, P + B Overscript[\[Equilibrium], Subscript[K, B]] PB *)
TwoStateCompetitiveEquilibriumSub1=(\[Chi]->(2*Sqrt[(\[Alpha]^2-3\[Beta])]Cos[\[Theta]/3]-\[Alpha]));
TwoStateCompetitiveEquilibriumSub2=(\[Theta]->ArcCos[(-2 \[Alpha]^3+9\[Alpha] \[Beta]-27gamma)/(2*Sqrt[(\[Alpha]^2-3\[Beta])^3])]);
TwoStateCompetitiveEquilibriumSub3={\[Alpha]->(Ka+Kb+A0+B0-P0),\[Beta]->(Kb(A0-P0)+Ka(B0-P0)+Ka Kb),gamma->(-Ka Kb P0)};

TwoStateCompetitiveEquilibrium=((({P==-(\[Chi]/3),PA==(A0 \[Chi])/(3 Ka+\[Chi]),PB==(B0 \[Chi])/(3 Kb+\[Chi]),A==A0-(A0 \[Chi])/(3 Ka+\[Chi]),B==B0-(B0 \[Chi])/(3 Kb+\[Chi])}/.TwoStateCompetitiveEquilibriumSub1)/.TwoStateCompetitiveEquilibriumSub2)/.TwoStateCompetitiveEquilibriumSub3);
*)


(*
EqFirstOrderIrreversible={{A->B},{0,A0+B0}};
EqFirstOrderReversible={{A\[Equilibrium]B},{((A0 + B0)*kb1)/(kb1 + kf1), ((A0 + B0)*kf1)/(kb1 + kf1)}};
EqFirstOrderIrreversibleHeterogeneous={{A->B+C},{0, A0 + B0, A0 + C0}};
EqFirstOrderReversibleHeterogeneous={{A\[Equilibrium]B+C},Null};
EqFirstOrderIrreversibleHomogeneous={{A->2B},{0, 2*A0 + B0}};
EqFirstOrderReversibleHomogeneous={{A\[Equilibrium]2B},{(2*B0^2*kb1 + A0*(4*B0*kb1 - kf1 + Sqrt[kf1*(16*A0*kb1 + 8*B0*kb1 + kf1)]))/  (4*B0*kb1 + kf1 + Sqrt[kf1*(16*A0*kb1 + 8*B0*kb1 + kf1)]),  (4*A0*kf1 + B0*(kf1 + Sqrt[kf1*(16*A0*kb1 + 8*B0*kb1 + kf1)]))/  (4*B0*kb1 + kf1 + Sqrt[kf1*(16*A0*kb1 + 8*B0*kb1 + kf1)])}};
*)


(*
EqSecondOrderHeterogeneousIrreversibleFirstOrder={{A+B->C},Null};
EqSecondOrderHeterogeneousReversibleFirstOrder={{A+B\[Equilibrium]C},Null}
EqSecondOrderHeterogeneousIrreversibleSecondOrderHeterogeneous={{A+B->C+D},Null};
EqSecondOrderHeterogeneousReversibleSecondOrderHeterogeneous={{A+B\[Equilibrium]C+D},Null};
EqSecondOrderHeterogeneousIrreversibleSecondOrderHomogeneous={{A+B->2C},Null};
EqSecondOrderHeterogeneousReversibleSecondOrderHomogeneous={{A+B\[Equilibrium]2C},Null};
EqSecondOrderHomogeneousIrreversible={{2A->B},{0, A0/2 + B0}};
EqSecondOrderHomogeneousReversibleFirstOrder={{2A\[Equilibrium]B},{(4*B0*kb1 + A0*(kb1 + Sqrt[kb1*(kb1 + 8*(A0 + 2*B0)*kf1)]))/  (kb1 + 4*A0*kf1 + Sqrt[kb1*(kb1 + 8*(A0 + 2*B0)*kf1)]),  (2*A0^2*kf1 + B0*(-kb1 + 4*A0*kf1 + Sqrt[kb1*(kb1 + 8*(A0 + 2*B0)*kf1)]))/  (kb1 + 4*A0*kf1 + Sqrt[kb1*(kb1 + 8*(A0 + 2*B0)*kf1)])}};
EqSecondOrderHomogeneousIrreversibleSecondOrderHeterogeneous={{2A->B+C},Null};
EqSecondOrderHomogeneousReversibleSecondOrderHeterogeneous={{2A\[Equilibrium]B+C},Null};
EqSecondOrderHomogeneousIrreversibleSecondOrderHomogenous={{2A->2B},{0, A0 + B0}};
EqSecondOrderHomogeneousReversibleSecondOrderHomogeneous={{2A\[Equilibrium]2B},"DSolve incomplete"};
*)


(*
EqCompetitiveFirstOrderIrreversible={{A->B,A->C},{0, (A0*k1 + B0*(k1 + k2))/(k1 + k2), (A0*k2 + C0*(k1 + k2))/(k1 + k2)}};
EqCompetitiveFirstOrderReversible={{A\[Equilibrium]B,A\[Equilibrium]C},Null};
EqCompetitiveSecondOrderHeterogeneousIrreversible={{A+B->C,A+D->F},"DSolve failed"};
EqCompetitiveSecondOrderHomogeneousIrreversible={{2A-> B,2A->C},{0, (A0*k1 + 2*B0*(k1 + k2))/(2*(k1 + k2)), (A0*k2 + 2*C0*(k1 + k2))/(2*(k1 + k2))}};
EqCompetitiveSecondOrderHeterogeneousReversibleFirstOrder={{A+B\[Equilibrium]C,A+D\[Equilibrium]F},"DSolve Incomplete"};
*)


(*
EqConsecutiveFirstOrderIrreversibleFirstOrderIrreversible={{A->B,B->C},{0, 0, A0 + B0 + C0}};
EqConsecutiveFirstOrderIrreversibleFirstOrderIrreversibleFirstOrderIrreversible={{A->B,B->C,C->D},Null};
EqConsecutiveSecondOrderIrreversibleFirstOrder={{A+B->C,C->D},"Crash"}
*)


(* ::Subsection::Closed:: *)
(*Combinatorics*)


(* Maximum length per fold/repeat level *)
debruijnMaximums={
	{2,1},
	{7,2},
	{34,3},
	{117,4},
	{516,5},
	{1961,6},
	{8198,7},
	{32281,8},
	{131080,9},
	{521745,10}
};

debruijnFunction=Interpolation[debruijnMaximums,InterpolationOrder->0];


(* ::Section:: *)
(*Physical Parameters*)


(* ::Subsection::Closed:: *)
(*Private Units*)


GramPerMole = Gram/Mole;
LiterPerCentimeterMole=Liter/Centimeter/Mole;
KilocaloriePerMole=KilocaloriesThermochemical/Mole;
CaloriePerMoleKelvin=Calorie/(Mole*Kelvin);
PerSecond = Second^-1;
PerMolarSecond = Molar^-1 Second^1;
PerMolarPerSecond = Molar^-1 Second^-1;


(* ::Subsection::Closed:: *)
(*Measurements*)


(* ::Subsubsection:: *)
(*Thermodynamics*)


(* ::Subsubsection::Closed:: *)
(*Kinetics*)


DNAkf37=10^6 Molar^-1 PerSecond;


(* ::Subsection::Closed:: *)
(*Molecular Weights*)


(* ::Subsubsection::Closed:: *)
(*DNAPhosphoramiditeMolecularWeights*)


DNAPhosphoramiditeMolecularWeights[]:= {
	"A" -> 857.85 GramPerMole,
	"G" -> 824.92 GramPerMole (*dmf-dG*),
	"C" -> 771.85 GramPerMole,
	"T" -> 744.83 GramPerMole
};


(* ::Subsubsection::Closed:: *)
(*ModifierPhosphoramiditeMolecularWeights*)


ModifierPhosphoramiditeMolecularWeights[]:={
	"Fluorescein" -> 1176.35 GramPerMole,
	"Dabcyl" -> 568.69 GramPerMole,
	"Tamra" -> 713.33 GramPerMole,
	"BHQ-1" -> 1401.56 GramPerMole,
	"Bhqtwo" -> 678.72 GramPerMole,
	"Cythree" -> 953.64 GramPerMole,
	"Cyfive" -> 979.68 GramPerMole,
	"Phosphorylated"-> 722.82 GramPerMole,
	"3'ThiolC3"->90.14 GramPerMole,
	"2-Thio-dT"->879.02 GramPerMole,
	"2-Aminopurine"->809.01 GramPerMole,
	"Deoxyinosine"->754.79 GramPerMole,
	"dP"->771.85 GramPerMole,
	"Amino-Serinol"->224.15 GramPerMole
};


(* ::Subsubsection::Closed:: *)
(*PNAMolecularWeights*)


PNAMolecularWeights[pnaType:(Boc|Fmoc|Gamma)]:=
Which[pnaType===Boc,{"Boc-A(Cbz)"->527.53 GramPerMole,"Boc-G(Cbz)"->543.53GramPerMole,"Boc-C(Cbz)"->503.51 GramPerMole,"Boc-T"->384.38 GramPerMole,"HBTU"->379.24 GramPerMole,"HATU"->380.2 GramPerMole,"NMM"-> 101.15 GramPerMole,"NMMDensity"-> 0.92 Gram/(Milli Liter),"Boc-Lys(2-Cl-Cbz)"->414.88  GramPerMole,"Fmoc-Lys(Cbz)"->502.56 GramPerMole},
	pnaType===Fmoc,{"Fmoc-A(Bhoc)"->725.75 GramPerMole,"Fmoc-G(Bhoc)"->741.75 GramPerMole,"Fmoc-C(Bhoc)"->701.72 GramPerMole,"Fmoc-T"->506.51 GramPerMole,"Fmoc-Lys(Boc)"->468.54  GramPerMole,"HBTU"->379.24 GramPerMole,"HATU"->380.2 GramPerMole,"NMM"-> 101.15 GramPerMole,"NMMDensity"-> 0.92 Gram/(Milli Liter)},
	pnaType===Gamma,{"Boc-gammaA(Cbz)"->659.69 GramPerMole,"Boc-gammaG(Cbz)"->675.69 GramPerMole,"Boc-gammaC(Cbz)"->635.66 GramPerMole,"Boc-gammaT"->516.54 GramPerMole,"Boc-Lys(2-Cl-Cbz)"->414.88  GramPerMole,"Fmoc-Lys(Cbz)"->502.56 GramPerMole,"HBTU"->379.24 GramPerMole,"HATU"->380.2 GramPerMole,"NMM"-> 101.15 GramPerMole,"NMMDensity"-> 0.92 Gram/(Milli Liter)}
];

PNAMolecularWeights[]:=Join[PNAMolecularWeights[Boc],PNAMolecularWeights[Fmoc],PNAMolecularWeights[Gamma]];


(* ::Subsection:: *)
(*Polymer Parameters*)


(* ::Subsubsection::Closed:: *)
(*ValidPolymerQ*)


(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[ValidPolymerQ,
	Options :> {
		{Verbose -> Failures, True | False | Failures, "If True, prints the result of each individual challenge to validity."}
	},
	SharedOptions :> {
		RunValidQTest
	}];

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)


(* Overload for a single model physics object *)
ValidPolymerQ[
	lookups:ObjectP[Model[Physics,Oligomer]]|{ObjectP[Model[Physics,Oligomer]]..},
	ops:OptionsPattern[ValidPolymerQ]
]:=Module[
	{exist,names},

	(* Clear the cache *)
	clearModelPhysicsCache[];

	(* If the object with this name doesn't exist, fail at start *)
	exist=Map[
		Quiet[
			Check[
				(Download[#,Object];True),
				(Message[Error::ObjectDoesNotExist,#];False),
				Download::ObjectDoesNotExist
			],
			Download::ObjectDoesNotExist
		]&,
		ToList[lookups]
	];

	(* Return if any of the objects does not exist *)
	names=If[!And@@exist,
		Null;Return[exist],
		Download[lookups,Name]
	];

	(** TODO: this is assuming the name of the oligomer is possible to be used as a symbol - this could be improved in the future **)
	RunValidQTest[
		Symbol[names],
		{validPolymerTests},
		ops
	]
];

(* Overload for The Modification *)
ValidPolymerQ[Modification, ops:OptionsPattern[ValidPolymerQ]] :=Module[
	{},

	(* Clear the cache *)
	clearModelPhysicsCache[];

	(* Run all ValidQ tests *)
	RunValidQTest[
		Modification,
		{validPolymerTests},
		ops
	]
];

(* Overload for a single symbol *)
ValidPolymerQ[lookups:_Symbol|{_Symbol...}, ops:OptionsPattern[ValidPolymerQ]] :=Module[
	{exist},

	(* Clear the cache *)
	clearModelPhysicsCache[];

	(* If the object with this name doesn't exist, fail at start *)
	exist=Map[
		Quiet[
			Check[
				Download[Model[Physics,Oligomer,SymbolName[#]],Object];True,
				Message[Error::ObjectDoesNotExist,Model[Physics,Oligomer,SymbolName[#]]];False,
				Download::ObjectDoesNotExist
			],
			Download::ObjectDoesNotExist
		]&,
		lookups
	];

	(* Return if any of the objects does not exist *)
	If[!And@@exist,Return[exist]];

	RunValidQTest[
		lookups,
		{validPolymerTests},
		ops
	]
];

(* All polymer tests *)
validPolymerTests[lookup:_Symbol]:=
	Join[
		validPolymerFieldTests[lookup],
		validPolymerAlphabetTests[lookup],
		validPolymerParameterUnitsTests[lookup]
	];


(* All tests for the major fields of the model modification *)
validPolymerAlphabetTests[Modification]:=With[
	{
		alphabet=lookupModelOligomer[Modification,Alphabet],
		degenerateAlphabet=lookupModelOligomer[Modification,DegenerateAlphabet],
		wildcardMonomer=lookupModelOligomer[Modification,WildcardMonomer],
		nullMonomer=lookupModelOligomer[Modification,NullMonomer],
		complements=lookupModelOligomer[Modification,Complements]
	},
	{
		Test["Alphabet does not contain any two monomers that make another monomer or does not contain duplicates:",
			unambiguousAlphabet[alphabet],
			True
		],
		Test["Wildcard exist in the degenerate alphabet:",
			MemberQ[(degenerateAlphabet)[[All,1]],(wildcardMonomer)],
			True

		],
		Test["Wildcard contains all of the Monomers in the alphabet:",
			Sort[(wildcardMonomer)/.(degenerateAlphabet)],
			Sort[alphabet]

		],
		Test["Null monomer exists:",
			MemberQ[(degenerateAlphabet)[[All,1]],(nullMonomer)],
			True
		],
		Test["Null monomer refers to an empty list:",
			(nullMonomer)/.(degenerateAlphabet),
			{}
		],
		Test["Complements are all members of the alphabet and doublely linked:",
			Or[
				And[
					MatchQ[(complements)[[All,1]],{Alternatives@@(alphabet)...}],
					MatchQ[((alphabet)/.(complements))/.Reverse/@(complements),alphabet]
				],
				MatchQ[(complements),Verbatim[{_->""}]]
			],
			True
		]
	}
];


(* These fields need to be available for Modification determined in modelOligomerParameters *)
requiredPolymerParameterFieldsModification = {Alphabet,DegenerateAlphabet,WildcardMonomer,NullMonomer,MonomerMolecule,MonomerMass};

(* These fields are optional parameters of Modifications determined in modelOligomerParameters that can't be empty or Null *)
optionalPolymerParameterFieldsModification = {AlternativeEncodings,AlternativeDegenerateEncodings,InitialMass,TerminalMass};

(* All tests for the fields of the model oligomer *)
validPolymerFieldTests[Modification]:=
	With[
		{
			existingFields = Keys@Select[modelOligomerParameters[Modification], !MatchQ[#, Null]&],
			requiredFieldTestDescription="Required fields exist: "<>ToString[requiredPolymerParameterFieldsModification]
		},
		{
			Test[requiredFieldTestDescription,
				MatchQ[Complement[requiredPolymerParameterFieldsModification,existingFields],{}],
				True
			],
			Test["All fields are allowed:",
				MatchQ[Complement[Join[requiredPolymerParameterFieldsModification,optionalPolymerParameterFieldsModification],existingFields],{}],
				True
			]
		}
	];

(* All tests for testing the units of the fields of the model modification *)
validPolymerParameterUnitsTests[Modification]:=With[
	{
		mass=lookupModelOligomer[Modification,MonomerMass],
		sigma=lookupModelExtinctionCoefficients[Modification,ExtinctionCoefficients],
		stackingEnthalpy=lookupModelThermodynamics[Modification, \[CapitalDelta]H, Stacking],
		stackingEntropy=lookupModelThermodynamics[Modification, \[CapitalDelta]S, Stacking],
		stackingEnergy=lookupModelThermodynamics[Modification, \[CapitalDelta]G, Stacking]
	},
	{
		Test["Correct units on Mass parameters:",
			MatchQ[(mass)[[All,2]],{(_?MolecularWeightQ|_?NumericQ)...}],
			True
		],
		Test["Correct units on \[CapitalSigma] parameters:",
			MatchQ[sigma[[All,2]],{(_?ExtinctionCoefficientQ|_?NumericQ)...}],
			True
		],
		Test["Enthalpy stacking parameters correct format:",
			MatchQ[stackingEnthalpy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EnergyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..},_Function|Null}
				]
			],
			True
		],
		Test["Entropy stacking parameters correct format:",
			MatchQ[stackingEntropy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EntropyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EntropyP}..},_Function|Null}
				]
			],
			True
		],
		Test["Energy stacking parameters correct format:",
			MatchQ[stackingEnergy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EnergyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..},_Function|Null}
				]
			],
			True
		]
	}
];

(* These fields need to be available in the model oligomer *)
requiredPolymerParameterFields = {Alphabet,DegenerateAlphabet,WildcardMonomer,NullMonomer,MonomerMass};
(* These fields are optional parameters in the model oligomer that can't be empty or Null *)
optionalPolymerParameterFields = {AlternativeEncodings,AlternativeDegenerateEncodings,InitialMass,TerminalMass};

(* All tests for the fields of the model oligomer *)
validPolymerFieldTests[polymerType_Symbol]:=
	With[
		{
			existingFields = Keys@Select[Download[Model[Physics,Oligomer,SymbolName[polymerType]]], !MatchQ[#, Null]&]
		},
		{
			Test["Required fields exist: "<>ToString[requiredPolymerParameterFields],
				MatchQ[Complement[requiredPolymerParameterFields,existingFields],{}],
				True
			],
			Test["All fields are allowed:",
				MatchQ[Complement[Join[requiredPolymerParameterFields,optionalPolymerParameterFields],existingFields],{}],
				True
			]
		}
	];

(* All tests for the major fields of the model oligomer *)
validPolymerAlphabetTests[polymerType_Symbol]:=With[
	{
		alphabet=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],Alphabet],
		degenerateAlphabet=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],DegenerateAlphabet],
		wildcardMonomer=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],WildcardMonomer],
		nullMonomer=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],NullMonomer],
		complements=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],Complements]
	},
	{
		Test["Alphabet does not contain any two monomers that make another monomer or does not contain duplicates:",
			unambiguousAlphabet[alphabet],
			True
		],
		Test["Wildcard exist in the degenerate alphabet:",
			MemberQ[(degenerateAlphabet)[[All,1]],(wildcardMonomer)],
			True

		],
		Test["Wildcard contains all of the Monomers in the alphabet:",
			Sort[(wildcardMonomer)/.(degenerateAlphabet)],
			Sort[alphabet]

		],
		Test["Null monomer exists:",
			MemberQ[(degenerateAlphabet)[[All,1]],(nullMonomer)],
			True
		],
		Test["Null monomer refers to an empty list:",
			(nullMonomer)/.(degenerateAlphabet),
			{}
		],
		Test["Complements are all members of the alphabet or empty (\"\"):",
			Or[
				MatchQ[(complements)[[All,2]],{(Alternatives@@(alphabet)|"")...}],
				MatchQ[(complements),Verbatim[{_->""}]]
			],
			True
		]
	}
];

(* All tests for testing the units of the fields of the model oligomer *)
validPolymerParameterUnitsTests[polymerType_Symbol]:=With[
	{
		mass=lookupModelOligomer[Model[Physics,Oligomer,SymbolName[polymerType]],MonomerMass],
		sigma=lookupModelExtinctionCoefficients[Model[Physics,Oligomer,SymbolName[polymerType]],ExtinctionCoefficients],
		stackingEnthalpy=lookupModelThermodynamics[Model[Physics,Oligomer,SymbolName[polymerType]], \[CapitalDelta]H, Stacking],
		stackingEntropy=lookupModelThermodynamics[Model[Physics,Oligomer,SymbolName[polymerType]], \[CapitalDelta]S, Stacking],
		stackingEnergy=lookupModelThermodynamics[Model[Physics,Oligomer,SymbolName[polymerType]], \[CapitalDelta]G, Stacking]
	},
	{
		Test["Correct units on Mass parameters:",
			MatchQ[(mass)[[;;,2]],{(_?MolecularWeightQ|_?NumericQ)...}],
			True
		],
		Test["Correct units on \[CapitalSigma] parameters:",
			MatchQ[sigma[[;;,2]],{(_?ExtinctionCoefficientQ|_?NumericQ)...}],
			True
		],
		Test["Enthalpy stacking parameters correct format:",
			MatchQ[stackingEnthalpy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EnergyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..},_Function|Null}
				]
			],
			True
		],
		Test["Entropy stacking parameters correct format:",
			MatchQ[stackingEntropy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EntropyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EntropyP}..},_Function|Null}
				]
			],
			True
		],
		Test["Energy stacking parameters correct format:",
			MatchQ[stackingEnergy,
				(* For some cases, Verbatim[_Symbol[_String]] is used to pattern match explicit usage _Symbol[_String] *)
				Alternatives[
					{{{_Symbol[_String],_Symbol[_String],EnergyP}..},_Function|Null},
					{{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..},_Function|Null}
				]
			],
			True
		]
	}
];

(* A helper function to determine if the alphabet is not ambigous specially when using Monomers *)
unambiguousAlphabet[alphabet:{_String..}]:=Module[
	{allDimers,allTrimers,sortedAlphabet},

	(* All possible dimers based on the alphabet *)
	allDimers=Permutations[alphabet,{2}];

	(* All possible trimers based on the alphabet *)
	allTrimers=Permutations[alphabet,{3}];

	(* Reverse the order of the alphabets *)
	sortedAlphabet=Reverse[SortBy[alphabet,StringLength]];

	(** TODO: technically speaking, we need to check all dimers trimers tetramers etc. if they are the same as any of the alphabet. but since this may get cumbersome we just do the StringContainsQ **)
	And[
		(* No duplicates in the alphabet is allowed *)
		DuplicateFreeQ[alphabet],
		(* The joined alphabet is the same as the joined alphabet that is splitted based on sortedAlphabet and then rejoined *)
		StringJoin[alphabet]==StringJoin[StringCases[StringJoin[alphabet], sortedAlphabet]],
		(* The combination of any two monomers can't constitute another monomer *)
		And@@(
			Nor@@StringContainsQ[alphabet,StringJoin[#]]&/@allDimers
		),
		(* The combination of any three monomers can't constitute another monomer *)
		And@@(
			Nor@@StringContainsQ[alphabet,StringJoin[#]]&/@allTrimers
		)
	]
];

prefixFreeMonomer[monomer_String,alphabet:{_String..}]:=Module[{monoCheck},

	(* Check each member of the alphabet to see if it starts with the monomer *)
	monoCheck=(!StringMatchQ[#,monomer~~___])&/@alphabet;

	(* Return true if all of the members passed *)
	And@@monoCheck
];

prefixFreeAlphabet[alphabet:{_String..}]:=Module[{monomerSortedLists,validMonomers},

	(* Generate a list of all rotations of the alphabet *)
	monomerSortedLists=Table[RotateRight[alphabet,n],{n,0,Length[alphabet]-1}];

	(* Now check to see if each monomer does not conflict the rest of the set *)
	validMonomers=prefixFreeMonomer[First[#],Rest[#]]&/@monomerSortedLists;

	(* return true if all Monomers pass *)
	And@@validMonomers
];


(* ::Subsubsection::Closed:: *)
(*validModificationQ*)

(* Helper Function:  Tests the validity of a modfication object explicitly or by looking up its name *)

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[validModificationQ,
	Options :> {
		{Verbose -> Failures, True | False | Failures, "If True, prints the result of each individual challenge to validity."}
	},
	SharedOptions :> {
		RunValidQTest
	}];

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

validModificationQ[lookups:_String|{_String...}|ObjectP[Model[Physics,Modification]], ops:OptionsPattern[validModificationQ]] := RunValidQTest[
	lookups,
	{validModificationTests},
	ops
];
validModificationTests[lookup:_String|ObjectP[Model[Physics,Modification]]]:=Join[
	validModificationFieldTests[lookup],
	validModificationParameterUnitsTests[lookup]
];

(* All fields needed for a Modification to pass validModificationTest *)
requiredModificationParameterFields = {Mass,ExtinctionCoefficients,LambdaMax};

(* Helper Function: Tests the availability of all required fields. Overload for packet physics modification objects *)
validModificationFieldTests[modificationType:ObjectP[Model[Physics,Modification]]]:=
	With[
		{
			existingFields = Module[
				{packets},
				packets=stripAppendReplaceKeyHeads[modificationType];
				If[!MatchQ[packets,$Failed|Null|{}],
					Keys@Select[packets, !MatchQ[#, Null | {}]&],
					{}
				]
			]
		},
		{
			Test["Required fields exist:",
				MatchQ[Complement[requiredModificationParameterFields,existingFields],{}],
				True
			]
		}
	];

(* Overload for strings *)
validModificationFieldTests[modificationType_String]:=
	With[
		{
			existingFields = Module[
				{packets},
				packets=Download[Model[Physics,Modification,modificationType]];
				If[!MatchQ[packets,$Failed|Null|{}],
					Keys@Select[packets, !MatchQ[#, Null | {}]&],
					{}
				]
			]
		},
		{
			Test["Required fields exist:",
				MatchQ[Complement[requiredModificationParameterFields,existingFields],{}],
				True
			]
		}
	];

(* Helper Function: Tests the units of extinction coefficient and thermodynamic properties for a modification *)
validModificationParameterUnitsTests[modificationType:(_String|ObjectP[Model[Physics,Modification]])]:=With[
	{
		mass=lookupModelModification[modificationType,Mass],
		sigma = lookupModelModification[modificationType,ExtinctionCoefficients],
		lambdaMax = lookupModelModification[modificationType,LambdaMax]
	},
	{
		Test["Correct units on Mass parameters:",
			MatchQ[mass,(_?MolecularWeightQ|_?NumericQ)],
			True
		],
		Test["Correct units on \[CapitalSigma] parameters:",
			MatchQ[sigma[[All,2]],{(_?ExtinctionCoefficientQ|_?NumericQ)...}],
			True
		],
		Test["Correct units on LambdaMax parameter:",
			MatchQ[lambdaMax,(UnitsP[Nanometer]|_?NumericQ)],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ModelOligmoerLookup*)

(* Helper Function: lookup the Model[Physics,Oligomer] properties *)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

(* Striping off the Replaced and Append heads *)
stripAppendReplaceKeyHeads[assoc_Association]:=KeyMap[stripAppendReplaceHead,assoc];
stripAppendReplaceKeyHeads[assocs:{_Association..}]:=stripAppendReplaceKeyHeads/@assocs;
stripAppendReplaceKeyHeads[other_]:=other;

stripAppendReplaceHead[Append[f_]]:=f;
stripAppendReplaceHead[Replace[f_]]:=f;
stripAppendReplaceHead[f_]:=f;

(* All different properties for modifications *)
modificationPropertyP=(Mass|ExtinctionCoefficients|LambdaMax|SyntheticMonomer|Molecule|MoleculeAdjustment);

(* Required functions for the validPhysicsOligomerQTests *)
(* Adapted from existing tests *)
monomer[myMonomer_String,myAlphabet:{_String..}]:=Module[{monoCheck},

  (* Check each member of the myAlphabet to see if it starts with the myMonomer *)
  monoCheck=(!StringMatchQ[#,myMonomer~~___])&/@myAlphabet;
  (* Return true if all of the members passed *)
  And@@monoCheck
];


(* Helper Function: lookup Model[Physics,Modification] for a specific modification *)

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* Overload for an explicit object *)
lookupModelModification[modificationTypes:ListableP[ObjectP[Model[Physics,Modification]]],property:modificationPropertyP]:=
	Module[{results,packets},

		(* If the input is a packet, then make sure to remove the Replaced[]/Append[] headers *)
		packets = stripAppendReplaceKeyHeads[modificationTypes];

		(* Downloading a specific property for modification *)
		results = Download[packets, property];

		(* Memoization of the lookupModelModification[modificationTypes,property] *)
		lookupModelModification[modificationTypes, property] = results;

		If[MatchQ[modificationTypes, {ObjectP[]..}],
			(* Memoization of each of the modification types *)
			MapThread[
				(lookupModelModification[#1, property] = #2)&,
				{modificationTypes, results}
			]
		];

		(* Output is the packets *)
		results

	];

(* Overload for a specific modification name *)
lookupModelModification[modificationTypes:ListableP[_?ModificationQ],property:modificationPropertyP]:=
	Module[
		{modificationNames,modificationObjects,results},

		modificationNames=modificationTypes /. (Modification[x_String]:>x);

		(* The model physics objects associated with the modifications *)
		modificationObjects=If[MatchQ[modificationTypes,{_?ModificationQ..}],
			Model[Physics,Modification,#]& /@ modificationNames,
			Model[Physics,Modification,modificationNames]
		];

		(* Downloading a specific property for modification *)
		results=Download[modificationObjects,property];

		(* Memoization of the lookupModelModification[modificationTypes,property] *)
		lookupModelModification[modificationTypes,property]=results;

		If[MatchQ[modificationTypes,{_?ModificationQ..}],
			(* Memoization of each of the modification types *)
			MapThread[
				(lookupModelModification[#1,property]=#2)&,
				{modificationTypes,results}
			]
		];

		(* Output is the packets *)
		results
	];

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

(* All major model physics oligomer properties *)
oligomerProperties={Alphabet,DegenerateAlphabet,Complements,Pairing,AlternativeEncodings,AlternativeDegenerateEncodings,WildcardMonomer,NullMonomer,MonomerMass,MonomerMolecule,InitialMass,TerminalMass,InitialMolecule,TerminalMolecule,SyntheticMonomers,DownloadMonomers,AlternativeParameterization};
oligomerPropertyP=Alternatives@@Append[oligomerProperties,MoleculeAdjustment];

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

Warning::DeprecatedModel="The object `1` is deprecated and results may be incorrect. Please specify a physics model which is still in use.";
Error::ObjectDoesNotExist="The object `1` can not be found in the database. Please inspect the object to ensure that the object exist in the database.";
Error::ModelDoesNotExist="For monomer `1`, a model for the given strategy `2` does not exist. Please inspect the Model[Physics,Oligomer] object `3` for available SyntheticMonomers or DownloadMonomers.";

Authors[lookupModelOligomer]={"dirk.schild", "clayton.schwarz", "amir.saadat", "kevin.hou"};

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[lookupModelOligomer,
	Options :> {
		{Product -> False, BooleanP, "If True, then the function only returns that Model[Samples] that have a non-zero length Product field."},
		{Head -> False, BooleanP, "If True, then the oligomer and modification heads will be added when constructing the lookup tables."},
		{SynthesisStrategy -> Automatic, Automatic|Boc|Fmoc|Phosphoramidite|_String, "For SyntheticMonomers and DownloadMonomers, the synthesis strategy."}
	}
];

(* Overload for multiple polymerTypes *)
lookupModelOligomer[
	polymerTypes:{PolymerP|ObjectP[Model[Physics,Oligomer]]..},
	properties:{oligomerPropertyP|MoleculeAdjustment..},
	myOptions:OptionsPattern[lookupModelOligomer]
]:=lookupModelOligomer[#,properties,myOptions]&/@polymerTypes;

(* Overload for multiple properties *)
lookupModelOligomer[
	polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],
	properties:{oligomerPropertyP|MoleculeAdjustment..},
	myOptions:OptionsPattern[lookupModelOligomer]
]:=lookupModelOligomer[polymerType,#,myOptions]&/@properties;

(* Overload for multiple polymerTypes *)
lookupModelOligomer[
	polymerTypes:{(PolymerP|ObjectP[Model[Physics,Oligomer]])..},
	property:oligomerPropertyP|MoleculeAdjustment,
	myOptions:OptionsPattern[lookupModelOligomer]
]:=lookupModelOligomer[#,property,myOptions]&/@polymerTypes;

(* Overload for a single property (core function) *)
lookupModelOligomer[
	polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],
	property:oligomerPropertyP|MoleculeAdjustment,
	myOptions:OptionsPattern[lookupModelOligomer]
]:=lookupModelOligomer[polymerType,property,myOptions]=
	Module[
		{safeOptions,parameters},

		(* add this function as memoized *)
		If[!MemberQ[$Memoization, Physics`Private`lookupModelOligomer],
			AppendTo[$Memoization, Physics`Private`lookupModelOligomer]
		];

		(* Call SafeOptions to make sure all options match pattern *)
		safeOptions = SafeOptions[lookupModelOligomer, ToList[myOptions]];

		(* Check if the input object is deprecated *)
		If[MatchQ[polymerType,ObjectP[Model[Physics,Oligomer]]]&&MatchQ[Quiet[Download[polymerType,Deprecated]],True],
			Message[Warning::DeprecatedModel,polymerType]
		];

		(* Take all of the available model oligomer parameters *)
		parameters=modelOligomerParameters[polymerType];

		(* Return with failed if the object does not exist *)
		If[MatchQ[parameters,$Failed],Return[$Failed]];

		Switch[property,
			(* For Alphabet directly take it from modelOligomerParameters *)
			Alphabet|WildcardMonomer|NullMonomer|InitialMass|TerminalMass|AlternativeEncodings|AlternativeDegenerateEncodings|AlternativeParameterization,
			Lookup[parameters,property],

			(* For DegenerateAlphabet make the proper rules *)
			DegenerateAlphabet,
			degenerateRules[polymerType],

			(* For Complements, make the rules using Alphabet and Complements *)
			Complements,
			Switch[polymerType,
				(* For Peptide, there are no pairs *)
				Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|Modification,
				Lookup[parameters,Complements],

				(* All other types, Alphabet and Complements are matched *)
				_,
				If[!MatchQ[Lookup[modelOligomerParameters[polymerType],Complements],Null|{}],
					MapThread[
						safeRule[#1,#2,Lookup[safeOptions,Head],polymerType]&,
						Lookup[parameters,{Alphabet,Complements}]
					],
					Lookup[parameters,Complements]
				]
			],

			(* For Pairing, make the rules using Alphabet and Complements *)
			Pairing,
			Switch[polymerType,
				(* For Peptide, there are no pairs just return empty list index matched with the alphabet *)
				Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|Modification,
				MapThread[
					Rule[#1,#2]&,
					Lookup[parameters,{Alphabet,property}]
				],

				(* Form the pairing rules based on the Alphabet and the Pairing field *)
				_,
				If[!MatchQ[Lookup[modelOligomerParameters[polymerType],Pairing],Null|{}],
					Map[
						Rule[First[#],Last[#]]&,
						(* Form all sets of {alphabet,pair} based on the Alphabet and Pairing field *)
						(
							Flatten[MapThread[
								Tuples[{{#1},#2}]&,
								Lookup[parameters,{Alphabet,Pairing}]
							],1]
						)
					],
					(* Return empty list index matched with alphabet if the field is not available *)
					Map[
						Rule[#1,{}]&,
						Lookup[parameters,Alphabet]
					]
				]
			],

			(* The output of all these would be Alphabet->(parameter value) *)
			MonomerMass|MonomerMolecule,
			If[!MatchQ[Lookup[modelOligomerParameters[polymerType],property],Null|{}],
				MapThread[
					safeRule[#1,#2,Lookup[safeOptions,Head],polymerType]&,
					Lookup[parameters,{Alphabet,property}]
				],
				Lookup[parameters,property]
			],

			(* The output of all these would be Alphabet->(parameter value) *)
			SyntheticMonomers|DownloadMonomers,
			If[!MatchQ[Lookup[modelOligomerParameters[polymerType],property],Null|{}],

				(* For modifications *)
				If[MatchQ[polymerType,Modification]&&!MatchQ[Lookup[modelOligomerParameters[polymerType],property],Null|{}],
					MapThread[
						Catch[
							Module[
								{model},

								(* Return Nothing for the case that we didn't find any Synthetic info *)
								If[MatchQ[#2,_Missing|Null|{}], Throw[Nothing]];

								(* Find the exact model based on the strategy and concentration options *)
								model=Which[
									(* If SynthesisStrategy is automatic and only one strategy is available then take that one *)
									MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic] && Length[#2]==1,
									(StockSolutionModel /. #2),

									(** TODO: If SynthesisStrategy is automatic and more than one strategy is available then take the first one for now **)
									MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic] && Length[#2]>1,
									(StockSolutionModel /. #2),

									(* If SynthesisStrategy is given but concentration is not given just find the first available strategy *)
									!MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic],
									(StockSolutionModel /.
										Select[#2,
											Function[
												modelTuple,
												(modelTuple[Strategy]==Lookup[safeOptions,SynthesisStrategy])
											]
										]
									)
								];

								(* Throw an error and exit if model is not a link to the model sample or model molecule *)
								If[MatchQ[model,$Failed] || !MatchQ[model,{ObjectP[{Model[Sample],Model[Molecule]}]..}],
									Throw[Nothing],
									(* The option Product is True but the field Products is not populated so we don't have it *)
									If[Lookup[safeOptions,Product] && MatchQ[(First@model)[Products],Null|{}],
										Nothing,
										safeRule[#1,(First@model)[Object],Lookup[safeOptions,Head],polymerType]
									]
								]
							]
						]&,
						Lookup[parameters,{Alphabet,property}]
					],

					(* For oligomers *)
					Map[
						(* If SynthesisStrategy is populated, then find the model associated with it *)
						Module[
							{monomerModels,model},

							(* All models available to thie specific monomer #1 *)
							monomerModels=Select[Lookup[parameters,property],Function[modelTuple,modelTuple[Monomer]==#] ];

							(* Find the exact model based on the strategy and concentration options *)
							model=Which[
								(* If SynthesisStrategy is automatic and only one strategy is available then take that one *)
								MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic] && Length[monomerModels]==1,
								(StockSolutionModel /. monomerModels),

								(** TODO: If SynthesisStrategy is automatic and more than one strategy is available then take the first one for now **)
								MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic] && Length[monomerModels]>1,
								(StockSolutionModel /. monomerModels),

								(* If SynthesisStrategy is given but concentration is not given just find the first available strategy *)
								!MatchQ[Lookup[safeOptions,SynthesisStrategy],Automatic],
								(StockSolutionModel /.
									Select[monomerModels,
										Function[
											modelTuple,
											(modelTuple[Strategy]==Lookup[safeOptions,SynthesisStrategy])
										]
									]
								)
							];
							(* Throw an error and exit if model is not a link to the model sample or model molecule *)
							If[MatchQ[model,$Failed] || !MatchQ[model,{ObjectP[{Model[Sample],Model[Molecule]}]|Null..}],
								Message[Error::ModelDoesNotExist,
									#,
									Lookup[safeOptions,SynthesisStrategy],
									polymerType
								];
								$Failed,
								safeRule[#,If[!NullQ[model],(First@model)[Object]],Lookup[safeOptions,Head],polymerType]
							]
						]&,
						Lookup[parameters,Alphabet]
					]
				],
				Lookup[parameters,property]
			],

			InitialMolecule|TerminalMolecule,
			If[!MatchQ[Lookup[modelOligomerParameters[polymerType],property],Null|{}],
				MapThread[Rule[#1,#2]&,{{"Addition","Removal"},Lookup[parameters,property]}],
				Lookup[parameters,property]
			],

			(* Only used for Modifications *)
			MoleculeAdjustment,
			If[MatchQ[polymerType,Modification]&&!MatchQ[Lookup[modelOligomerParameters[polymerType],property],Null|{}],
				MapThread[
					safeRule[#1,#2,Lookup[safeOptions,Head],polymerType]&,
					Lookup[parameters,{Alphabet,property}]
				],
				Null
			]

		]

	];

(* A helper function to add heads for the alphabet if needed *)
safeRule[myKey_,myValue_,head:BooleanP,polymerType: PolymerP|ObjectP[Model[Physics,Oligomer]]]:=
	Which[
		(* Add headers to the alphabet *)
		head && MatchQ[polymerType,PolymerP],
		Rule[polymerType[myKey],myValue],

		(* Add headers to the alphabet *)
		head && MatchQ[polymerType,ObjectP[Model[Physics,Oligomer]]],
		Rule[Symbol[polymerType[Name]][myKey],myValue],

		True,
		Rule[myKey,myValue]
	];

(** TODO: If the number of Modification increases significatly, then it is better to just look for a particular modification insread of forming the rules for all modifications **)

(* Helper Function: download the model oligomer packet and memoize results *)
modelOligomerParameters[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]]]:=modelOligomerParameters[polymerType]=Module[
	{modifications, modificationAdjs},

	(* add this function as memoized *)
	If[!MemberQ[$Memoization, Physics`Private`modelOligomerParameters],
		AppendTo[$Memoization, Physics`Private`modelOligomerParameters]
	];

	(* Find all modifications available in the database *)
	(* DeveloperObject!=True is used to ensure that even if after memoization, if DeveloperSearch turns false after the first call to the function, we get the correct objects when memoized results are used *)
	modifications=
		If[polymerType===Modification,
			Quiet[
				Check[
					Download[Search[Model[Physics, Modification],Deprecated!=True&&DeveloperObject!=True],{Name,Mass,LambdaMax,Molecule,MoleculeAdjustment,SyntheticMonomer,DownloadMonomer}],
					Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
					{Download::ObjectDoesNotExist}
				],
				{Download::ObjectDoesNotExist}
			],
			{}
		];

	(* Handle mass adjustments in the modifications if they are present *)
	modificationAdjs=If[modifications===$Failed,
		(* If for any reason the download returns failed (like not logged in or download failed gracefully return failed )*)
		$Failed,
		Map[
			Function[{adj},
				If[MatchQ[adj,Null],
					Null,
					{"Addition"->First[adj],"Removal"->Last[adj]}
				]
			],
			modifications[[All,5]]
		]
	];

	(** NOTE: we don't need to check if the fields exist as they should be checked each time a new public polymer is created **)
	Switch[polymerType,
		ObjectP[Model[Physics,Oligomer,"Peptide"]],
		Module[{packet},
			(* Return with $Failed if the object does not exist *)
			packet=Quiet[
				Check[
					Download[polymerType],
					Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
					Download::ObjectDoesNotExist
				],
				Download::ObjectDoesNotExist
			];
			(* If for any reason the download returns failed (like not logged in or download failed gracefully return failed )*)
			If[packet===$Failed,
				$Failed,
				Join[
					Association@@Map[(#->Lookup[packet,#])&,oligomerProperties],
					<|Complements->{_->""},Pairing->ConstantArray[{},Length[Lookup[packet,Alphabet]]]|>
				]
			]
		],

		(* For model physics objects, directly download *)
		ObjectP[Model[Physics,Oligomer]],
		Module[{packet,parameters},
			(* Return with $Failed if the object does not exist *)
			packet=Quiet[
				Check[
					Download[polymerType],
					Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
					Download::ObjectDoesNotExist
				],
				Download::ObjectDoesNotExist
			];
			(* If for any reason the download returns failed (like not logged in or download failed gracefully return failed )*)
			If[packet===$Failed,
				$Failed,
				Association@@Map[(#->Lookup[packet,#])&,oligomerProperties]
			]
		],

		(* For modifications Alphabet is all names *)
		Modification,
		If[modifications===$Failed,
			(* If for any reason the download returns failed (like not logged in or download failed gracefully return failed )*)
			$Failed,
			<|
				Alphabet->modifications[[All,1]],
				DegenerateAlphabet->{"Any"->modifications[[All,1]],"None"->{}},
				AlternativeEncodings->{},
				AlternativeDegenerateEncodings->{},
				NullMonomer->"None",
				WildcardMonomer->"Any",
				Complements->{_->""},
				Pairing->ConstantArray[{},First@Dimensions[modifications,1]],
				MonomerMass->modifications[[All,2]],
				MoleculeAdjustment->modificationAdjs,
				MonomerMolecule->modifications[[All,4]],
				InitialMass-> 0 GramPerMole,
				InitialMolecule->Null,
				TerminalMass-> 0 GramPerMole,
				TerminalMolecule->Null,
				ExtinctionCoefficients->modelExtinctionCoefficientsParameters[Modification],
				LambdaMax->modifications[[All,3]],
				SyntheticMonomers->modifications[[All,6]],
				DownloadMonomers->modifications[[All,7]]
			|>
		],

		(* For Peptide, Complements and Pairing need to be added *)
		Peptide,
		Module[{packet},
			(* Return with $Failed if the object does not exist *)
			packet=Quiet[
				Check[
					Download[Model[Physics,Oligomer,SymbolName[polymerType]]],
					Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
					Download::ObjectDoesNotExist
				],
				Download::ObjectDoesNotExist
			];
			(* If for any reason the download returns failed (like not logged in or download failed gracefully return failed )*)
			If[packet===$Failed,
				$Failed,
				Join[
					Association@@Map[(#->Lookup[packet,#])&,oligomerProperties],
					<|Complements->{_->""},Pairing->ConstantArray[{},Length[Lookup[packet,Alphabet]]]|>
				]
			]
		],

		(* For all other types, it should have all fields *)
		_,
		Download[Model[Physics,Oligomer,SymbolName[polymerType]],Evaluate[Packet@@oligomerProperties]]
	]
];

(* Helper Function: finds the degerate rules based on the polymer type *)
degenerateRules[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]]]:=Module[
	{degenerateAlphabet,groupedDegenerates,degenerateRulesBase},

	(* DegenerateAlphabet associated with the type of polymer *)
	degenerateAlphabet=Lookup[modelOligomerParameters[polymerType],DegenerateAlphabet];

	Switch[polymerType,
		(* For modifications, take the degenerateAlphabet directly *)
		Modification,
		Join[
			(#->{#}& /@ Lookup[modelOligomerParameters[polymerType],Alphabet]),
			degenerateAlphabet
		],

		(* For all others, create the rules based on the degenerateAlphabet *)
		_,
		Module[{groupedDegenerates,degenerateRulesBase},
			(* Grouping the degenerateAlphabet to form a proper rule used in finding the average mass value of a monomer *)
			groupedDegenerates=GroupBy[degenerateAlphabet,First];

			(* Pull out the degenerate alphabet and the alphabet *)
			degenerateRulesBase=Join[
				(#->{#}& /@ Lookup[modelOligomerParameters[polymerType],Alphabet]),
				MapThread[Rule[#1,#2[[All,2]]]&,{Keys[groupedDegenerates],Values[groupedDegenerates]}]
			];

			(* Replace {Null} with {} *)
			ReplaceAll[degenerateRulesBase,(monomer_->{Null}) :> (monomer->{})]
		]
	]
];



(* ::Subsubsection::Closed:: *)
(* lookupModelExtinctionCoefficients *)



(* Helper Function: lookup the Model[Physics,ExtinctionCoefficients] properties *)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

(* Checks if the extinction coefficients model is valid *)
validExtinctionCoefficientsModelQ[object:ObjectP[Model[Physics,ExtinctionCoefficients]]]:=Module[{packet},
	(* Removing Replace and Append heads if the input is a packet *)
	packet=stripAppendReplaceKeyHeads[object];
	And@@
		Join[
			(* These fields need to be available *)
			(!MatchQ[Quiet[Download[packet,#]],Null|{}|$Failed]& /@ {Wavelengths,MolarExtinctions}),
			(* The units need to be correct for extinction coefficents *)
			{MatchQ[Quiet[Download[packet,MolarExtinctions]][[;;,;;,2]],{{(_?ExtinctionCoefficientQ|_?NumericQ)...}}]}
		]
];
(* Anything other than Model ExtinctionCoefficients will be False *)
validExtinctionCoefficientsModelQ[_]:=False;

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[lookupModelExtinctionCoefficients,
	Options :> {
		{ExtinctionCoefficientsModel -> Automatic, Automatic | ObjectP[Model[Physics,ExtinctionCoefficients]], "The model that is used for extracting the extinction coefficient. Automatic will match the public one."}
	}
];

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(** TODO: Make this flexible by adding Wavelength option. It is now 260. nm since that is the only thing we have. **)
(* Overload for modifications *)
lookupModelExtinctionCoefficients[polymerType:Modification|ObjectP[Model[Physics,Modification]],monomers:{_String..}]:=lookupModelExtinctionCoefficients[polymerType,monomers]=
	Module[
		{wavelengthIndex,extinctions},

		(* Finding the index of the wavelength in the model extinction coefficent *)
		wavelengthIndex=Flatten@Position[Lookup[modelExtinctionCoefficientsParameters[polymerType,monomers],Wavelengths],(260. Nano Meter)];

		(* Extract the extinction values used in the calculation *)
		extinctions=First@Part[Lookup[modelExtinctionCoefficientsParameters[polymerType,monomers],MolarExtinctions],wavelengthIndex];

		(* Rule to specify the extinction coefficient for the monomers *)
		Map[Rule[First[#],Last[#]]&,extinctions]
	];

(** TODO: Make this flexible by adding Wavelength option. It is now 260. nm since that is the only thing we have. **)
(* Overload for all other types than modification *)
lookupModelExtinctionCoefficients[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],property:ExtinctionCoefficients|HyperchromicityCorrections, myOptions: OptionsPattern[lookupModelExtinctionCoefficients]]:=lookupModelExtinctionCoefficients[polymerType,property,myOptions]=
	Module[
		{safeOptions,parameters,wavelengthIndex,extinctions,corrections},

		(* Call SafeOptions to make sure all options match pattern *)
		safeOptions = SafeOptions[lookupModelExtinctionCoefficients, ToList[myOptions]];

		(* Take all of the available extinction coefficient parameters *)
		parameters=modelExtinctionCoefficientsParameters[polymerType,safeOptions];

		(* Return with failed if the object does not exist *)
		If[MatchQ[parameters,$Failed],Return[$Failed]];

		(* Finding the index of the wavelength in the model extinction coefficent *)
		wavelengthIndex=
			Flatten@Position[Lookup[parameters,Wavelengths],(260. Nano Meter)];

		(* Extract the extinction values used in the calculation *)
		extinctions=
			First@Part[Lookup[parameters,MolarExtinctions],wavelengthIndex];

		(* Extract the corrections used in the calculation *)
		corrections=
			First@Part[Lookup[parameters,HyperchromicityCorrections],wavelengthIndex];

		(* The rules that specify the extinction coefficents for all units *)
		Switch[property,
			ExtinctionCoefficients,
			Map[Rule[First[#],Last[#]]&,extinctions],

			HyperchromicityCorrections,
			Join[
				(* The rule for the extinctions *)
				Map[Rule[First[#],Last[#]]&,extinctions],

				Flatten[
					If[MatchQ[polymerType,LNAChimera],
						{
							(* The correction values are the same for all variants of A and T *)
							{Rule[HyperchromicityAT,Lookup[corrections,"mA"]]},
							(* The correction values are the same for all variants of G and C *)
							{Rule[HyperchromicityGC,Lookup[corrections,"mG"]]}
						},
						{
							(* The correction values are the same for A and T *)
							{Rule[HyperchromicityAT,Lookup[corrections,"A"]]},
							(* The correction values are the same for G and C *)
							{Rule[HyperchromicityGC,Lookup[corrections,"G"]]}
						}

					],1
				]
			]
		]

	];

(* Helper Function: download the model extinction coefficent packet and memoize results *)

(* Overload for modifications *)
modelExtinctionCoefficientsParameters[polymerType:Modification,monomers:{_String..}]:=modelExtinctionCoefficientsParameters[polymerType,monomers]=Module[
	{extinctionPairs,monomersWavelengthIndices},

	(* For a specific modification, lookup their specific model physics *)
	(** TODO: make it read directly from the links in the polymer type **)
	(** TODO: Make this flexible by adding Wavelength option. It is now 260. nm since that is the only thing we have. **)
	(* All {wavelength,molarextinction} pairs *)
	extinctionPairs=Lookup[Download[(Model[Physics,Modification,#]& /@ monomers)],ExtinctionCoefficients];

	(* The wavelengths to use for all modifications *)
	wavelengths={260. Nanometer};

	(* Finding the indices of the wavelengths for each of the modifications *)
	monomersWavelengthIndices=
		Map[
			Flatten@Position[#[[;;,1]],(260. Nanometer)]&,
			extinctionPairs
		];

	(* Storing the wavelength and molarextinction in the form provided for DNA/RNA/etc. *)
	<|
		Wavelengths->wavelengths,
		(* Mapping over wavelength *)
		MolarExtinctions->
			Map[
				Function[wavelengthIndex,
					(* Mapping over the monomers *)
					MapThread[
						(#1->#2[[#3[[wavelengthIndex]],2]])&,
						{monomers,extinctionPairs,monomersWavelengthIndices}
					]
				],
				Range[Length[wavelengths]]
			]

	|>
];

(* Overload for any types other than modification *)
(** TODO: Consider removing reading the extinction coefficents as they are not needed for hyperchromacity **)
(** TODO: If the number of Modification increases significatly, then it is better to just look for a particular modification insread of forming the rules for all modifications **)

modelExtinctionCoefficientsParameters[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],safeOptions:{(_Rule|_RuleDelayed)..}]:=modelExtinctionCoefficientsParameters[polymerType,safeOptions]=Module[
	{modifications,extinctionCoefficientsModel},

	(* Find all modifications available in the database *)
	(* DeveloperObject!=True is used to ensure that even if after momoization, if DeveloperSearch turns false after the first call to the function, we get the correct objects when memoized results are used *)
	modifications=
		If[polymerType===Modification,
			Download[Search[Model[Physics, Modification],DeveloperObject!=True],{Name,ExtinctionCoefficients}],
			{}
		];

	(* Extinction coefficient model as provided in the options and remove Replace and Append heads for input packets *)
	extinctionCoefficientsModel=stripAppendReplaceKeyHeads[Lookup[safeOptions,ExtinctionCoefficientsModel]];

	(* If extinctionCoefficientsModel is Automatic take information from ExtinctionCoefficients field *)
	If[extinctionCoefficientsModel===Automatic,
		Switch[polymerType,

			(* For arbitrary object, we should check if the object exist and we may not have the HyperchromicityCorrections *)
			ObjectP[Model[Physics,Oligomer]],
			(* Add all zeros HyperchromicityCorrections if it doesn't exist in the object *)
			Module[
				{packet},
				(* Return with failed if the object does not exist *)
				packet=Quiet[
					Check[
						Download[polymerType],
						Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
						Download::ObjectDoesNotExist
					],
					Download::ObjectDoesNotExist
				];
				Which[
					(* ExtinctionCoefficients field is not available *)
					MatchQ[polymerType[ExtinctionCoefficients],Null|{}|$Failed],
					<|
						Wavelengths->{260. Nanometer},
						MolarExtinctions->{{_->0}},
						HyperchromicityCorrections->{{"A"->0.,"T"->0.,"G"->0.,"C"->0.}}
					|>,

					(* ExtinctionCoefficients is available but HyperchromicityCorrections may or may not be available *)
					True,
					Join[
						Download[polymerType[ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions]],
						If[MatchQ[Quiet[polymerType[ExtinctionCoefficients][HyperchromicityCorrections]],Null|{}|$Failed],
							<|HyperchromicityCorrections->{{"A"->0.,"T"->0.,"G"->0.,"C"->0.}}|>,
							<|HyperchromicityCorrections->polymerType[ExtinctionCoefficients][HyperchromicityCorrections]|>
						]
					]
				]
			],

			(* For DNA, all information is stored in the model physics for DNA *)
			DNA,
			Download[Model[Physics,Oligomer,SymbolName[polymerType]][ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions,HyperchromicityCorrections]],

			(* For RNA, we take the extinctions from RNA and the correction from DNA *)
			RNA|RNAtom|RNAtbdms,
			Join[
				Download[Model[Physics,Oligomer,SymbolName[RNA]][ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions]],
				Download[Model[Physics,Oligomer,"DNA"][ExtinctionCoefficients],Packet[HyperchromicityCorrections]]
			],

			(* For Peptide the corrections are zeros *)
			Peptide,
			Join[
				Download[Model[Physics,Oligomer,SymbolName[polymerType]][ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions]],
				<|HyperchromicityCorrections->{{"A"->0.,"T"->0.,"G"->0.,"C"->0.}}|>
			],

			(* For Locked DNA/RNA, we take the extinctions from LDNA/LRNA and the correction from DNA *)
			LDNA|LRNA,
			Join[
				Download[Model[Physics,Oligomer,SymbolName[polymerType]][ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions]],
				Download[Model[Physics,Oligomer,"DNA"][ExtinctionCoefficients],Packet[HyperchromicityCorrections]]
			],

			(* For modifications, lookup their specific model physics *)
			(** TODO: make it read directly from the links in the polymer type **)
			(** TODO: add actual molar extinctions if needed **)
			Modification,
			<|
				(* Take the wavelength from the first modification *)
				Wavelengths->{260. Nanometer},
				MolarExtinctions->{{_->0}},
				HyperchromicityCorrections->{{"A"->0.,"T"->0.,"G"->0.,"C"->0.}}
			|>,

			(* All other polymer types *)
			_,
			Download[Model[Physics,Oligomer,SymbolName[polymerType]][ExtinctionCoefficients],Packet[Wavelengths,MolarExtinctions,HyperchromicityCorrections]]

		],

		(* If the extinctionCoefficientsModel is not Automatic take the data from the ExtinctionCoefficientsModel *)
		Join[
			Download[extinctionCoefficientsModel,Packet[Wavelengths,MolarExtinctions]],
			(* Lookup HyperchromicityCorrections and if not available set it to zero *)
			If[MatchQ[Quiet[Download[extinctionCoefficientsModel,HyperchromicityCorrections]],Null|{}|$Failed],
				(* If polymerType is DNA/RNA based, use DNA Hyperchromicity corrections otherwise use all zeros *)
				If[MatchQ[polymerType,RNA|RNAtom|RNAtbdms|LDNA|LRNA],
					Download[Model[Physics,Oligomer,"DNA"][ExtinctionCoefficients],Packet[HyperchromicityCorrections]],
					<|HyperchromicityCorrections->{{"A"->0.,"T"->0.,"G"->0.,"C"->0.}}|>
				],
				<|HyperchromicityCorrections->Download[extinctionCoefficientsModel,HyperchromicityCorrections]|>
			]
		]

	]

];


(* ::Subsubsection::Closed:: *)
(* lookupModelThermodynamics *)

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

(** TODO: The oligomer is currently manually selected in many of the switch statements. make it automatic **)

(* Pattern for different types of thermo property *)
thermoPropertyP=(\[CapitalDelta]G|\[CapitalDelta]H|\[CapitalDelta]S);

(* Pattern for different types of thermo property associated with RNA interacting with DNA *)
thermoDNAPropertyP=(DNA\[CapitalDelta]G | DNA\[CapitalDelta]H | DNA\[CapitalDelta]S);

(* Pattern for different types of thermo property associated with DNA interacting with RNA *)
thermoRNAPropertyP=(RNA\[CapitalDelta]G | RNA\[CapitalDelta]H| RNA\[CapitalDelta]S);

(* Pattern for different types of thermo property associated with DNA|RNA interacting with LNAChimera *)
thermoLNAChimeraPropertyP=(LNAChimera\[CapitalDelta]G | LNAChimera\[CapitalDelta]H| LNAChimera\[CapitalDelta]S);

(* Pattern for different types of thermo subproperty (arrangements) *)
thermoSubPropertyP=( Stacking | Mismatch | TriLoop | TetraLoop | InternalLoop | BulgeLoop | HairpinLoop | MultipleLoop );

(* The units for Energy, Enthalpy and Entropy *)
thermoUnit[(\[CapitalDelta]H | DNA\[CapitalDelta]H | RNA\[CapitalDelta]H)]:=KilocaloriePerMole;
thermoUnit[(\[CapitalDelta]G | DNA\[CapitalDelta]G | RNA\[CapitalDelta]G)]:=KilocaloriePerMole;
thermoUnit[(\[CapitalDelta]S | DNA\[CapitalDelta]S | RNA\[CapitalDelta]S)]:=CaloriePerMoleKelvin;

(* Pattern for different correction parameters *)
thermoCorrectionP=
	(InitialEnergyCorrection | InitialEnthalpyCorrection | InitialEntropyCorrection |
	SymmetryEnergyCorrection | SymmetryEnthalpyCorrection | SymmetryEntropyCorrection |
	TerminalEnergyCorrection | TerminalEnthalpyCorrection | TerminalEntropyCorrection);

(* General property types *)
propertyTypes={Energy,Enthalpy,Entropy};

(* subProperty types for each of the general types *)
subPropertyTypes={Stacking,Mismatch,TriLoop,TetraLoop,InternalLoop,BulgeLoop,HairpinLoop,MultipleLoop};

(* All thermodynamic parameters *)
allThermoParameters=
	Packet@@Join[
		Map[Symbol[SymbolName[First[#]]<>SymbolName[Last[#]]]&,Distribute[{subPropertyTypes,propertyTypes},List]],
		{
			InternalLoopEnergyFunction,InternalLoopEnthalpyFunction,InternalLoopEntropyFunction,
			BulgeLoopEnergyFunction,BulgeLoopEnthalpyFunction,BulgeLoopEntropyFunction,
			HairpinLoopEnergyFunction,HairpinLoopEnthalpyFunction,HairpinLoopEntropyFunction
		},
		{
			InitialEnergyCorrection,InitialEnthalpyCorrection,InitialEntropyCorrection,
			SymmetryEnergyCorrection,SymmetryEntropyCorrection,
			TerminalEnergyCorrection,TerminalEnthalpyCorrection,TerminalEntropyCorrection
		}
	];

(* Helper Function: If True, the oligomer model object does not have a Thermodynamics field *)
emptyThermoObjectQ[object:PolymerP]:=False;
emptyThermoObjectQ[object:ObjectP[Model[Physics,Oligomer]]]:=
	MatchQ[Quiet[Download[object,Thermodynamics]],Null|{}|$Failed];
emptyThermoObjectP=_?emptyThermoObjectQ;

(* Helper Function: zeroing all thermo properties values *)
zeroThermodynamicParameter[property:thermoPropertyP,subProperty:(thermoSubPropertyP|thermoCorrectionP)]:=
	Switch[subProperty,
		(Stacking|Mismatch|TetraLoop),
		{{_Symbol[_String],_Symbol[_String],0.0 thermoUnit[property]}},

		TriLoop,
		{_Symbol[_String],0.0 thermoUnit[property]},

		(InternalLoop|BulgeLoop|HairpinLoop),
		{{_Integer,0.0 thermoUnit[property]}},

		MultipleLoop,
		{{{_Integer,_Integer},0.0 thermoUnit[property]}}
	];

(* All thermodynamic parameters that are required for a correct thermodynamics model pattern *)
(** TODO: This list needs to get expanded as we extend to have a better database **)
allRequiredThermoParameters=
	{StackingEnergy,StackingEnthalpy,StackingEntropy};

(* A function to validate the thermodynamics model *)
validThermodynamicsModelQ[object:ObjectP[Model[Physics,Thermodynamics]]]:=Module[{packet},
	(* Removing Replace and Append heads if the input is a packet *)
	packet=stripAppendReplaceKeyHeads[object];
	And@@
		Join[
			(* These fields need to be available *)
			(!MatchQ[Quiet[Download[packet,#]],Null|{}|$Failed]& /@ allRequiredThermoParameters),
			(* The units need to be correct for extinction coefficents *)
			{
				(* Correct units for StackingEnthalpy *)
				MatchQ[Quiet[Download[packet,StackingEnthalpy]],
					Alternatives[
						{{_Symbol[_String],_Symbol[_String],EnergyP}..},
						{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..}
					]
				],
				(* Correct units for StackingEnthalpy *)
				MatchQ[Quiet[Download[packet,StackingEntropy]],
					Alternatives[
						{{_Symbol[_String],_Symbol[_String],EntropyP}..},
						{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EntropyP}..}
					]
				],
				(* Correct units for StackingEnergy *)
				MatchQ[Quiet[Download[packet,StackingEnergy]],
					Alternatives[
						{{_Symbol[_String],_Symbol[_String],EnergyP}..},
						{{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],EnergyP}..}
					]
				]
			}
		]
];

(* Anything other than Model Thermodynamics will be False *)
validThermodynamicsModelQ[_]:=False;

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[lookupModelThermodynamics,
	Options :> {
		{AlternativeParameterization -> False, BooleanP, "If True, the thermodynamics model in the ReferenceOligomer field of the AlternativeParameterization field will be used with the SubstitutionRules given in the AlternativeParameterization field."},
		{ThermodynamicsModel -> Automatic, Automatic | None | ObjectP[Model[Physics,Thermodynamics]], "The model that is used for extracting the thermodynamic parameters. Automatic will match the public one."}
	}
];

Authors[lookupModelThermodynamics]={"dirk.schild", "clayton.schwarz", "amir.saadat"};

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* Helper Function: lookup the Model[Physics,Thermodynamics] properties *)

lookupModelThermodynamics[
	polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],
	property:thermoPropertyP,
	subProperty:(thermoSubPropertyP|thermoCorrectionP),
	myOptions:OptionsPattern[lookupModelThermodynamics]
]:=lookupModelThermodynamics[polymerType,property,subProperty,myOptions]=Module[

	{
		safeOptions,parameter,thermodynamicParameters,parameterValues,parameterFunction,referenceOligomer,
		alternativeParameterizationModel,alternativeThermodynamicParameters,alternativeParameterValues,
		alternativeParameterFunction,alternativeParameterizationModels
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[lookupModelThermodynamics, ToList[myOptions]];

	(* The parameter corresponding to the property and the subProperty *)
	parameter=
		Switch[subProperty,
			(* Add suffix Energy, Enthalpy, or Entropy for subproperties *)
			thermoSubPropertyP,
			Switch[property,
				(\[CapitalDelta]G),
				Symbol[SymbolName[subProperty]<>"Energy"],

				(\[CapitalDelta]H),
				Symbol[SymbolName[subProperty]<>"Enthalpy"],

				(\[CapitalDelta]S),
				Symbol[SymbolName[subProperty]<>"Entropy"]
			],
			(* Add no suffix for correction parameters *)
			thermoCorrectionP,
			subProperty
		];

	(* Take all of the available thermodynamic parameters *)
	thermodynamicParameters=modelThermodynamicsParameters[polymerType,safeOptions];

	(* Return with failed if the object does not exist *)
	If[MatchQ[thermodynamicParameters,$Failed],Return[{$Failed,$Failed}]];

	(* Call and find all alternative parameterization models *)
	alternativeParameterizationModels=Physics`Private`lookupModelOligomer[polymerType,AlternativeParameterization];

	(* Find the alternativeParameterization model to find the reference oligomer *)
	alternativeParameterizationModel=If[!MatchQ[alternativeParameterizationModels,$Failed|Null|{}],
		Select[alternativeParameterizationModels,(#[Model] == Thermodynamics &)],
		{}
	];

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
		polymerType
	];

	(* Take all of the available thermodynamic parameters for referenceOligomer *)
	alternativeThermodynamicParameters=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		modelThermodynamicsParameters[referenceOligomer,safeOptions],
		{}
	];

	(* For the original polymer type *)
	parameterValues=Switch[polymerType,
		(* We don't have these information yet *)
		(Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|PNA|ObjectP[Model[Physics,Oligomer,"PNA"]]|GammaRightPNA|ObjectP[Model[Physics,Oligomer,"GammaRightPNA"]]|GammaLeftPNA|ObjectP[Model[Physics,Oligomer,"GammaLeftPNA"]]|Modification),
		(* Don't add zeros if alternativeParameterization is true - will be added below *)
		If[!Lookup[safeOptions,AlternativeParameterization],
			zeroThermodynamicParameter[property,subProperty],
			{}
		],
		(* For general oligomer objects *)
		ObjectP[Model[Physics,Oligomer]],
		(* Don't add zeros if alternativeParameterization is true - will be added below *)
		If[MatchQ[emptyThermoObjectQ[polymerType],True] && !Lookup[safeOptions,AlternativeParameterization],
			zeroThermodynamicParameter[property,subProperty],
			Lookup[thermodynamicParameters,parameter]
		],
		(* Anything other than the modifications or peptide, pull these from modelThermodynamicsParameters *)
		_,
		Lookup[thermodynamicParameters,parameter]
	];

	(* For the referenceOligomer if AlternativeParameterization *)
	alternativeParameterValues=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Switch[referenceOligomer,
			(* We don't have these information yet *)
			(Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|PNA|ObjectP[Model[Physics,Oligomer,"PNA"]]|GammaRightPNA|ObjectP[Model[Physics,Oligomer,"GammaRightPNA"]]|GammaLeftPNA|ObjectP[Model[Physics,Oligomer,"GammaLeftPNA"]]|Modification),
			zeroThermodynamicParameter[property,subProperty],
			(* For general oligomer objects *)
			ObjectP[Model[Physics,Oligomer]],
			If[MatchQ[emptyThermoObjectQ[referenceOligomer],True],
				zeroThermodynamicParameter[property,subProperty],
				Lookup[alternativeThermodynamicParameters,parameter]
			],
			(* Anything other than the modifications or peptide, pull these from modelThermodynamicsParameters *)
			_,
			Lookup[alternativeThermodynamicParameters,parameter]
		],
		{}
	];

	(* For the original polymer type *)
	parameterFunction=Switch[polymerType,
		(* We don't have these information yet *)
		Modification|Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|PNA|ObjectP[Model[Physics,Oligomer,"PNA"]]|GammaRightPNA|ObjectP[Model[Physics,Oligomer,"GammaRightPNA"]]|GammaLeftPNA|ObjectP[Model[Physics,Oligomer,"GammaLeftPNA"]],
		Function[n,0.0 thermoUnit[property]],
		(* For general oligomer objects *)
		ObjectP[Model[Physics,Oligomer]],
		If[MatchQ[emptyThermoObjectQ[polymerType],True],
			Function[n,0.0 thermoUnit[property]],
			Lookup[thermodynamicParameters,Symbol[SymbolName[parameter]<>"Function"],Null]
		],
		(* Anything other than the modifications or peptide, pull these from modelThermodynamicsParameters *)
		_,
		Lookup[thermodynamicParameters,Symbol[SymbolName[parameter]<>"Function"],Null]
	];

	(* For the referenceOligomer if AlternativeParameterization *)
	alternativeParameterFunction=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Switch[referenceOligomer,
			(* We don't have these information yet *)
			Modification|Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|PNA|ObjectP[Model[Physics,Oligomer,"PNA"]]|GammaRightPNA|ObjectP[Model[Physics,Oligomer,"GammaRightPNA"]]|GammaLeftPNA|ObjectP[Model[Physics,Oligomer,"GammaLeftPNA"]],
			Function[n,0.0 thermoUnit[property]],
			(* For general oligomer objects *)
			ObjectP[Model[Physics,Oligomer]],
			If[MatchQ[emptyThermoObjectQ[referenceOligomer],True],
				Function[n,0.0 thermoUnit[property]],
				Lookup[alternativeThermodynamicParameters,Symbol[SymbolName[parameter]<>"Function"],Null]
			],
			(* Anything other than the modifications or peptide, pull these from modelThermodynamicsParameters *)
			_,
			Lookup[alternativeThermodynamicParameters,Symbol[SymbolName[parameter]<>"Function"],Null]
		],
		{}
	];

	If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		{Join[parameterValues,alternativeParameterValues],parameterFunction,alternativeParameterFunction},
		{parameterValues,parameterFunction}
	]

];

(* Helper Function: download the model thermodynamics packet and memoize results *)
modelThermodynamicsParameters[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],safeOptions:{(_Rule|_RuleDelayed)..}]:=modelThermodynamicsParameters[polymerType,safeOptions]=Module[
	{thermodynamicsModel},

	(* Thermodynamics model as provided in the options and remove Replace and Append head if it is a packet *)
	thermodynamicsModel=stripAppendReplaceKeyHeads[Lookup[safeOptions,ThermodynamicsModel]];

	(* If thermodynamicsModel is Automatic take information from Thermodynamics field *)
	If[MatchQ[thermodynamicsModel,Automatic|None],

		(* Find all modifications available in the database *)
		(** TODO: update this once we have the thermo parameters for other oligomers and modifications **)

		Switch[polymerType,
			(* For DNA, RNA, and LNAChimera, all thermodynamic data is stored in the model thermodynamics *)
			(DNA|RNA|LRNA|LNAChimera|ObjectP[Model[Physics,Oligomer]]),
			Module[{mainParameters},
				mainParameters=Switch[polymerType,
					ObjectP[Model[Physics,Oligomer]],
					Module[
						{packet},
						(* Return with failed if the object does not exist *)
						packet=Quiet[
							Check[
								Download[polymerType],
								Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
								Download::ObjectDoesNotExist
							],
							Download::ObjectDoesNotExist
						];
						(* Take the parameters from the Thermodynamics field *)
						If[MatchQ[Lookup[packet,Thermodynamics,Null],Null|{}],
							<||>,
							Download[Lookup[packet,Thermodynamics],allThermoParameters]
						]
					],
					_,
					Download[Download[Model[Physics,Oligomer,SymbolName[polymerType]],Thermodynamics],allThermoParameters]
				];
				(* Join the main parameters with the correction parameters that are currenly missing *)
				Join[
					mainParameters,
					(** TODO: This information doesn't exist currently and should be added. **)
					Switch[polymerType,
						DNA,
						<|SymmetryEnthalpyCorrection->{{DNA,DNA,0.0 KilocaloriePerMole},{DNA,RNA,0.0 KilocaloriePerMole}}|>,
						RNA,
						<|SymmetryEnthalpyCorrection->{{RNA,RNA,0.0 KilocaloriePerMole},{RNA,DNA,0.0 KilocaloriePerMole}}|>,
						LNAChimera,
						<||>,
						_,
						<|SymmetryEnthalpyCorrection->{{DNA,DNA,0.0 KilocaloriePerMole},{DNA,RNA,0.0 KilocaloriePerMole},{RNA,RNA,0.0 KilocaloriePerMole},{RNA,DNA,0.0 KilocaloriePerMole}}|>
					],
					<|HairpinLoopEnthalpyFunction->Function[n,0.0 KilocaloriePerMole]|>
				]
			],
			(* For anything else, we don't have the thermodynamic parameters now *)
			_,
			<||>
		],

		(* If the thermodynamicsModel is not Automatic take the data from the ThermodynamicsModel *)
		Join[
			Quiet[
				Download[thermodynamicsModel,allThermoParameters],
				{Download::MissingField}
			],
			(** TODO: This information doesn't exist currently and should be added. **)
			Switch[polymerType,
				DNA,
				<|SymmetryEnthalpyCorrection->{{DNA,DNA,0.0 KilocaloriePerMole},{DNA,RNA,0.0 KilocaloriePerMole}}|>,
				RNA,
				<|SymmetryEnthalpyCorrection->{{RNA,RNA,0.0 KilocaloriePerMole},{RNA,DNA,0.0 KilocaloriePerMole}}|>,
				LNAChimera,
				<||>,
				_,
				<|SymmetryEnthalpyCorrection->{{DNA,DNA,0.0 KilocaloriePerMole},{DNA,RNA,0.0 KilocaloriePerMole},{RNA,RNA,0.0 KilocaloriePerMole},{RNA,DNA,0.0 KilocaloriePerMole}}|>
			],
			<|HairpinLoopEnthalpyFunction->Function[n,0.0 KilocaloriePerMole]|>
		]
	]
];


(* ::Subsubsection:: *)
(*lookupModelThermodynamicsCorrection*)


(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[lookupModelThermodynamicsCorrection,
	Options :> {
		{AlternativeParameterization -> False, BooleanP, "If True, the thermodynamics model in the ReferenceOligomer field of the AlternativeParameterization field will be used with the SubstitutionRules given in the AlternativeParameterization field."},
		{ThermodynamicsModel -> Automatic, Automatic | None| ObjectP[Model[Physics,Thermodynamics]], "The model that is used for extracting the thermodynamic parameters. Automatic will match the public one."}
	}
];

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* Helper Function: finds the correction parameter using lookupModelThermodynamics *)
lookupModelThermodynamicsCorrection[
	polymerType:PolymerP,
	property:(thermoPropertyP|thermoDNAPropertyP|thermoRNAPropertyP|thermoLNAChimeraPropertyP),
	correctionType:(Initial|Terminal|Symmetry),
	myOptions:OptionsPattern[lookupModelThermodynamicsCorrection]
]:=lookupModelThermodynamicsCorrection[polymerType,property,correctionType,myOptions]=Module[

	{safeOptions,passOptions,referenceOligomer,alternativeParameterizationModel},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[lookupModelThermodynamics, ToList[myOptions]];

	(* Options to pass to lookupModelThermodynamics *)
	passOptions=PassOptions[lookupModelThermodynamicsCorrection, lookupModelThermodynamics, myOptions];

	(* Find the alternativeParameterization model to find the reference oligomer *)
	alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[polymerType,AlternativeParameterization],(#[Model] == Thermodynamics &)];

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
		polymerType
	];

	correctionValue=Switch[{polymerType,property},
		(* Two strands of DNA *)
		{DNA,\[CapitalDelta]G}|{DNA,\[CapitalDelta]H}|{DNA,\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,property,correctionParameter[property,correctionType],passOptions][[1]],
			{DNA, DNA, x_Quantity} :> x
		],

		(* Binding of DNA to RNA *)
		{DNA,RNA\[CapitalDelta]G}|{DNA,RNA\[CapitalDelta]H}|{DNA,RNA\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,Symbol[StringDelete[SymbolName[property],"RNA"]],correctionParameter[property,correctionType],passOptions][[1]],
			{DNA, RNA, x_Quantity} :> x
		],

		(* Two strands of RNA *)
		{RNA,\[CapitalDelta]G}|{RNA,\[CapitalDelta]H}|{RNA,\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,property,correctionParameter[property,correctionType],passOptions][[1]],
			{RNA, RNA, x_Quantity} :> x
		],

		(* Binding of RNA to DNA *)
		{RNA,DNA\[CapitalDelta]G}|{RNA,DNA\[CapitalDelta]H}|{RNA,DNA\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,Symbol[StringDelete[SymbolName[property],"DNA"]],correctionParameter[property,correctionType],passOptions][[1]],
			{RNA, DNA, x_Quantity} :> x
		],

		(* Binding of LRNA to LRNA *)
		{LRNA,\[CapitalDelta]G}|{LRNA,\[CapitalDelta]H}|{LRNA,\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,property,correctionParameter[property,correctionType],passOptions][[1]],
			{LRNA, LRNA, x_Quantity} :> x
		],

		(* Binding of LNAChimera to LNAChimera *)
		{LNAChimera,\[CapitalDelta]G}|{LNAChimera,\[CapitalDelta]H}|{LNAChimera,\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,property,correctionParameter[property,correctionType],passOptions][[1]],
			{LNAChimera, LNAChimera, x_Quantity} :> x
		],

		(* Binding of LRNA to LRNA *)
		{PolymerP,\[CapitalDelta]G}|{PolymerP,\[CapitalDelta]H}|{PolymerP,\[CapitalDelta]S},
		Cases[
			lookupModelThermodynamics[polymerType,property,correctionParameter[property,correctionType],passOptions][[1]],
			{polymerType, polymerType, x_Quantity} :> x
		],

		_,
		0.0 thermoUnit[property]
	];

	(* For referenceOligomer of AlternativeParameterization *)
	alternativeCorrectionValue=If[Lookup[safeOptions,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Switch[{referenceOligomer,property},
			(* Two strands of DNA *)
			{DNA,\[CapitalDelta]G}|{DNA,\[CapitalDelta]H}|{DNA,\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,property,correctionParameter[property,correctionType],passOptions][[1]],
				{DNA, DNA, x_Quantity} :> x
			],

			(* Binding of DNA to RNA *)
			{DNA,RNA\[CapitalDelta]G}|{DNA,RNA\[CapitalDelta]H}|{DNA,RNA\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,Symbol[StringDelete[SymbolName[property],"RNA"]],correctionParameter[property,correctionType],passOptions][[1]],
				{DNA, RNA, x_Quantity} :> x
			],

			(* Two strands of RNA *)
			{RNA,\[CapitalDelta]G}|{RNA,\[CapitalDelta]H}|{RNA,\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,property,correctionParameter[property,correctionType],passOptions][[1]],
				{RNA, RNA, x_Quantity} :> x
			],

			(* Binding of RNA to DNA *)
			{RNA,DNA\[CapitalDelta]G}|{RNA,DNA\[CapitalDelta]H}|{RNA,DNA\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,Symbol[StringDelete[SymbolName[property],"DNA"]],correctionParameter[property,correctionType],passOptions][[1]],
				{RNA, DNA, x_Quantity} :> x
			],

			(* Binding of LRNA to LRNA *)
			{LRNA,\[CapitalDelta]G}|{LRNA,\[CapitalDelta]H}|{LRNA,\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,property,correctionParameter[property,correctionType],passOptions][[1]],
				{LRNA, LRNA, x_Quantity} :> x
			],

			(* Binding of LNAChimera to LNAChimera *)
			{LNAChimera,\[CapitalDelta]G}|{LNAChimera,\[CapitalDelta]H}|{LNAChimera,\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,property,correctionParameter[property,correctionType],passOptions][[1]],
				{LNAChimera, LNAChimera, x_Quantity} :> x
			],

			(* Binding of LRNA to LRNA *)
			{PolymerP,\[CapitalDelta]G}|{PolymerP,\[CapitalDelta]H}|{PolymerP,\[CapitalDelta]S},
			Cases[
				lookupModelThermodynamics[referenceOligomer,property,correctionParameter[property,correctionType],passOptions][[1]],
				{referenceOligomer, referenceOligomer, x_Quantity} :> x
			],

			_,
			0.0 thermoUnit[property]
		],
		{}
	];

	Switch[correctionValue,
		(* If not available set it to zero *)
		{},
		If[MatchQ[alternativeCorrectionValue,{}],
			0.0 thermoUnit[property],
			alternativeCorrectionValue
		],

		(* Delist the value found using Cases[] *)
		_List, First@correctionValue,

		_,correctionValue
	]
];


(* Helper Function: finds the correction parameter based on the property *)
correctionParameter[property:thermoPropertyP,correctionType:(Initial|Terminal|Symmetry)]:=correctionParameter[property,correctionType]=
	Switch[property,
		(* All variations related to free energy *)
		\[CapitalDelta]G | DNA\[CapitalDelta]G | RNA\[CapitalDelta]G,
		Symbol[SymbolName[correctionType]<>"EnergyCorrection"],

		(* All variations related to enthalpy *)
		\[CapitalDelta]H | DNA\[CapitalDelta]H | RNA\[CapitalDelta]H,
		Symbol[SymbolName[correctionType]<>"EnthalpyCorrection"],

		(* All variations related to entropy *)
		\[CapitalDelta]S | DNA\[CapitalDelta]S | RNA\[CapitalDelta]S,
		Symbol[SymbolName[correctionType]<>"EntropyCorrection"]
	];


(* ::Subsubsection::Closed:: *)
(*thermodynamicParameters*)

(* Helper Function: Takes the thermodynamic parameters for Model[Physics,Thermodynamics] but also provides a distribution for degenerate cases *)

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[thermodynamicParameters,
	Options :> {
		{Degeneracy -> True, True | False, "If True, include parameters for degenerative bases."},
		{Unitless -> Automatic, Automatic | False | UnitsP[], "If True, strips units off parameters.  If Unitless->unit, converts to that unit and then strips off units.  If Unitless->Automatic, converts to standard unit for specific parameter and then strips units."},
		{AlternativeParameterization -> False, BooleanP, "If True, the thermodynamics model in the ReferenceOligomer field of the AlternativeParameterization field will be used with the SubstitutionRules given in the AlternativeParameterization field."},
		{ThermodynamicsModel -> Automatic, Automatic | None | ObjectP[Model[Physics,Thermodynamics]], "The model that is used for extracting the thermodynamic parameters. Automatic will match the public one."}
	}];

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

thermoParameterTypeP = (\[CapitalDelta]G|\[CapitalDelta]H|\[CapitalDelta]S);
dimerP = _String?(StringLength[#]===2&);

(* download the packet and pull from that *)
(* if this function be changed we should be good for the whole thermo stuff*)

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* memoize results *)
(** NOTE: If AlternativeParameterization, the thermo properties of referenceOligomer is returned since we are stripping off the head **)
thermodynamicParameters[pol:PolymerP,type:thermoParameterTypeP,Stacking,ops:OptionsPattern[thermodynamicParameters]]:= Module[
	{
		safeOps,dimerParams,degenMonos,allTranslations,combinations,degenDimers,degenDimerLists,allParams,allParamsFinal,

		dimerParamsTuples,unavailableDimerRule,corrections,passLookupOptions,passLookupCorrectionOptions,

		(* AlternativeParameterization variables *)
		referenceOligomer,alternativeParameterizationModel,alternativeDimerParamsTuples,alternativeunavailableDimerRule
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOps=SafeOptions[thermodynamicParameters, ToList[ops]];

	(* Find the alternativeParameterization model to find the reference oligomer *)
	alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)];

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[safeOps,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
		pol
	];

	(* Options to pass to lookupModelThermodynamics *)
	passLookupOptions=PassOptions[thermodynamicParameters, lookupModelThermodynamics, ops];

	(* Options to pass to lookupModelThermodynamicsCorrection *)
	passLookupCorrectionOptions=PassOptions[thermodynamicParameters, lookupModelThermodynamicsCorrection, ops];

	(* Find the relationships between bot and top dimers excluding the cross terms *)

	dimerParamsTuples =
		Switch[referenceOligomer,
			DNA|RNA,
			DeleteCases[First@lookupModelThermodynamics[referenceOligomer,type,Stacking,passLookupOptions],{DNA[_],RNA[_],x_Quantity}|{RNA[_],DNA[_],x_Quantity}],
			LRNA|LNAChimera,
			First@lookupModelThermodynamics[referenceOligomer,type,Stacking,passLookupOptions],
			PolymerP,
			First@lookupModelThermodynamics[referenceOligomer,type,Stacking,passLookupOptions],
			_,
			{_String->{_String->0.0*thermoUnit[type]}}
		];

	(* This is only present for DNA and RNA and their free energy *)
	(** TODO: check the support for all oligomers **)
	unavailableDimerRule=
		If[(MatchQ[referenceOligomer,DNA|RNA|LRNA|LNAChimera] && MatchQ[type,\[CapitalDelta]G]),
			{_String->{_String->0.4 KilocaloriePerMole}},
			{}
		];

	(* The initial terminal and symmetry corrections *)
	corrections=
		{
			Init->lookupModelThermodynamicsCorrection[referenceOligomer,type,Initial,passLookupCorrectionOptions],
			Term->lookupModelThermodynamicsCorrection[referenceOligomer,type,Terminal,passLookupCorrectionOptions],
			Symmetry->lookupModelThermodynamicsCorrection[referenceOligomer,type,Symmetry,passLookupCorrectionOptions]
		};

	(** TODO: this may be written more efficient by adjusting degenDimers to the way data comes out of model thermodynamics **)
	(** TODO: add the support for all oligomers **)
	(* The format _Symbol[_String] is generated in the lookup and needs to be removed here *)
	dimerParams = DeleteCases[
		Join[
			Switch[referenceOligomer,
				DNA,
				dimerParamsTuples /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> bot -> {top -> x,_String->0.0*thermoUnit[type]} ),
				RNA,
				dimerParamsTuples /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> bot -> {top -> x} ),
				LRNA,
				dimerParamsTuples /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> bot -> {top -> x} ),
				LNAChimera,
				dimerParamsTuples /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> bot -> {top -> x} ),
				_,
				dimerParamsTuples
			],
			unavailableDimerRule,
			corrections
		],
		{Verbatim[_Symbol[_String]],Verbatim[_Symbol[_String]],_}
	];

	(* Generate a list of all translations from a monomer to its possible interperations *)
	allTranslations=lookupModelOligomer[referenceOligomer,DegenerateAlphabet];

	(* Generate every possible dimer combination of Monomers including the degenerate alphabet *)
	combinations=Tuples[allTranslations[[All,1]],2];

	(* Generate a list of all possible degenerate Dimers as a rule pointing to the list of known Dimers (without any degeneracy) they could represent *)
	degenDimerLists=StringJoin[#]->Flatten[Outer[StringJoin,First[#]/.allTranslations,Last[#]/.allTranslations]]&/@combinations;

	degenDimers=If[TrueQ[Lookup[safeOps,Degeneracy]],
		degenDimerLists/.{
			Rule[base_String,matches:{_String..}]:>Rule[base,{_String -> wrapUnit[Map[firstMatchingParam[#]&,matches/.dimerParams], Lookup[safeOps,Unitless], thermoUnit[type]]}],
			Rule[base_String,{}]:>Rule[base,{_String->0.0*thermoUnit[type]}]
		},
		(* set all degen dimers to 0 *)
		MapAt[{_String->0.0*thermoUnit[type]}&,degenDimerLists,{;;,2}]
	];

	allParams = Join[dimerParams,degenDimers];

	allParamsFinal = Switch[Lookup[safeOps,Unitless],
		False, allParams,
		Automatic, Unitless[allParams,thermoUnit[type]],
		UnitsP[], Unitless[allParams, Lookup[safeOps,Unitless]]
	];

	(* memoize *)
	thermodynamicParameters[pol,type,Stacking,ops]=allParamsFinal;

	allParamsFinal
];

wrapUnit[num_, unitless: False, unit_] := QuantityDistribution[EmpiricalDistribution[Unitless[num, unit]], unit];
wrapUnit[num_, unitless: Automatic, unit_] := EmpiricalDistribution[Unitless[num, unit]];
wrapUnit[num_, unitless: UnitsP[], unit_] := EmpiricalDistribution[Unitless[num, unitless]];

firstMatchingParam[q_Quantity]:=q;
firstMatchingParam[{Rule[_,q_Quantity],___Rule}]:=q;
firstMatchingParam[_]:=0.0*thermoUnit[type];

(* addDash[base_String]:=StringInsert[base, "-", 2]; *)

(* Find the monomers and use a dash to separate them *)
addDash[base_String]:=(#[[1]]<>"-"<>#[[2]]&) @ Monomers[base];

thermodynamicParameters[pol:PolymerP,type:thermoParameterTypeP,Mismatch,ops:OptionsPattern[thermodynamicParameters]]:= Module[
	{
		safeOps,mismatchLookup,mismatchParams,out,

		mismatchTuples,passLookupOptions,referenceOligomer,alternativeParameterizationModel
	},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOps=SafeOptions[thermodynamicParameters, ToList[ops]];

	(* Find the alternativeParameterization model to find the reference oligomer *)
	alternativeParameterizationModel=Select[Physics`Private`lookupModelOligomer[pol,AlternativeParameterization],(#[Model] == Thermodynamics &)];

	(* Find the reference oligomer which is used for alternative parameterization *)
	referenceOligomer=If[Lookup[safeOps,AlternativeParameterization] && !MatchQ[alternativeParameterizationModel,{}],
		Symbol[First[alternativeParameterizationModel][ReferenceOligomer][Name]],
		pol
	];

	(* Options to pass to lookupModelThermodynamics *)
	passLookupOptions=PassOptions[thermodynamicParameters, lookupModelThermodynamics, ops];

	(* Find the relationships between bot and top dimers excluding the cross terms *)
	(** TODO: add the support for all oligomers **)
	mismatchTuples =
		Switch[referenceOligomer,
			DNA|RNA,
			Module[{mismatchTuplesBase},
				mismatchTuplesBase=DeleteCases[First@lookupModelThermodynamics[referenceOligomer,type,Mismatch,passLookupOptions],{DNA[_],RNA[_],x_Quantity}|{RNA[_],DNA[_],x_Quantity}];
				(* Removing the DNA or RNA headers *)
				mismatchTuplesBase /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> {bot,top,x} )
			],
			LRNA|LNAChimera,
			Module[
				{mismatchTuplesBase},
				mismatchTuplesBase=First@lookupModelThermodynamics[referenceOligomer,type,Mismatch,passLookupOptions];
				(* Removing the DNA or RNA headers *)
				mismatchTuplesBase /. ( {_Symbol[bot_String], _Symbol[top_String], x_Quantity} :> {bot,top,x} )
			],
			_,
			{_String->{_String->0.0*thermoUnit[type]}}
		];

	(* This is only present for RNA *)
	(** TODO: add the support for all oligomers **)
	unavailableDimerRule=
		If[(MatchQ[referenceOligomer,RNA]),
			{_String->{_String-> \[Infinity] thermoUnit[type]}},
			{}
		];

	(** TODO: this may be written more efficient by adjusting degenDimers to the way data comes out of model thermodynamics **)
	(** TODO: add the support for all oligomers **)
	mismatchLookup = Join[
		Switch[referenceOligomer,
			DNA|RNA|LRNA|LNAChimera,
			Module[
				{groupedMismatchTuples},

				groupedMismatchTuples=GroupBy[mismatchTuples,First];
				MapThread[
					Function[{bot,topTuples},
						Rule[addDash[bot],Map[(addDash[#[[2]]]->#[[3]])&,topTuples]]
					],
					{Keys[groupedMismatchTuples],Values[groupedMismatchTuples]}
				]
			],
			_,
			mismatchTuples
		],
		unavailableDimerRule
	];

	mismatchParams=If[MatchQ[mismatchLookup,_Missing],
		{_String -> {_String -> 0.0 * thermoUnit[type]} },
		mismatchLookup
	];

	out = Switch[Lookup[safeOps,Unitless],
		False, mismatchParams,
		Automatic, Unitless[mismatchParams,thermoUnit[type]],
		UnitsP[], Unitless[mismatchParams, Lookup[safeOps,Unitless]]
	];

	(* memoize *)
	thermodynamicParameters[pol,type,Mismatch,ops]=out;

	out
];



(* ::Subsubsection::Closed:: *)
(*lookupModelKinetics*)

(* -------------------------- *)
(* --- Option Definitions --- *)
(* -------------------------- *)

DefineOptions[lookupModelKinetics,
	Options :> {
		{KineticsModel -> Automatic, Automatic | ObjectP[Model[Physics,Kinetics]], "The model that is used for extracting the thermodynamic parameters. Automatic will match the public one."}
	}];

(* -------------------------------------- *)
(* --- Main Definitions and Variables --- *)
(* -------------------------------------- *)

kineticPropertiesP=(ForwardHybridization | StrandExchange | DuplexExchange | DualToeHoldStrandExchange | FoldingRate);

allKineticParameters=Packet@@{ForwardHybridization,StrandExchange,DuplexExchange,DualToeHoldStrandExchange};

(* Helper Function: If True, the oligomer model object does not have a emptyKineticsObjectQ field *)
emptyKineticsObjectQ[object:PolymerP]:=False;
emptyKineticsObjectQ[object:ObjectP[Model[Physics,Oligomer]]]:=
	MatchQ[Quiet[Download[object,Kinetics]],Null|{}|$Failed];
emptyKineticsObjectP=_?emptyKineticsObjectQ;

(* Helper Function: zeroing all thermo properties values *)
zeroKineticParameter[property:kineticPropertiesP]:=
	Switch[property,
		ForwardHybridization,
		0.0 Second/Molar,

		DuplexExchange,
		0.0 PerSecond,

		FoldingRate,
		0.0 PerSecond,

		StrandExchange|DualToeHoldStrandExchange,
		Function[toeHoldLength,0.0 PerMolarSecond]
	];

allRequiredKineticParameters={ForwardHybridization,StrandExchange,DuplexExchange,DualToeHoldStrandExchange};

(* A function to validate the thermodynamics model *)
validKineticsModelQ[object:ObjectP[Model[Physics,Kinetics]]]:=Module[{packet},
	(* Removing Replace and Append heads if the input is a packet *)
	packet=stripAppendReplaceKeyHeads[object];
	And@@
		Join[
			(* These fields need to be available *)
			(!MatchQ[Quiet[Download[packet,#]],Null|{}|$Failed]& /@ allRequiredKineticParameters),
			(* The units need to be correct for extinction coefficents *)
			{
				(* Correct units for ForwardHybridization *)
				MatchQ[Quiet[Download[packet,ForwardHybridization]],UnitsP[PerMolarSecond]],
				(* Correct units for DuplexExchange *)
				MatchQ[Quiet[Download[packet,DuplexExchange]],UnitsP[PerSecond]]
			}
		]
];
(* Anything other than Model Thermodynamics will be False *)
validKineticsModelQ[_]:=False;

(* ---------------------- *)
(* --- Core Functions --- *)
(* ---------------------- *)

(* Overload for multiple properties *)
lookupModelKinetics[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],properties:kineticPropertiesP,myOptions:OptionsPattern[lookupModelKinetics]]:=lookupModelKinetics[polymerType,#,myOptions]& /@ properties;

(* Overload for a single property (core function) *)
lookupModelKinetics[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],property:kineticPropertiesP,myOptions:OptionsPattern[lookupModelKinetics]]:=lookupModelKineticsMemoized[polymerType,property,myOptions]=Module[
	{safeOptions,kineticParameters},

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[lookupModelKinetics, ToList[myOptions]];

	(* Take all of the available kinetic parameters *)
	kineticParameters=modelKineticsParameters[polymerType,safeOptions];

	(* Return with failed if the object does not exist *)
	If[MatchQ[kineticParameters,$Failed],Return[$Failed]];

	Switch[polymerType,
		(* We don't have these information yet *)
		(RNA|ObjectP[Model[Physics,Oligomer,"RNA"]]|Peptide|ObjectP[Model[Physics,Oligomer,"Peptide"]]|PNA|ObjectP[Model[Physics,Oligomer,"PNA"]]|GammaRightPNA|ObjectP[Model[Physics,Oligomer,"GammaRightPNA"]]|GammaLeftPNA|ObjectP[Model[Physics,Oligomer,"GammaLeftPNA"]]|Modification),
		zeroKineticParameter[property],
		(* For general oligomer objects *)
		ObjectP[Model[Physics,Oligomer]],
		If[MatchQ[emptyKineticsObjectQ[polymerType],True],
			zeroKineticParameter[property],
			Lookup[kineticParameters,property]
		],
		(* Anything other than these models (currently only DNA), pull these from modelKineticsParameters *)
		_,
		Lookup[kineticParameters,property]
	]

];

modelKineticsParameters[polymerType:PolymerP|ObjectP[Model[Physics,Oligomer]],safeOptions:{(_Rule|_RuleDelayed)..}]:=modelKineticsParametersMemoized[polymerType,safeOptions]=Module[
	{kineticsModel},

	(* Kinetics model as provided in the options *)
	kineticsModel=Lookup[safeOptions,KineticsModel];

	(* Find all modifications available in the database *)
	(** TODO: update this once we have the thermo parameters for modifications **)

	(* If kineticsModel is Automatic take information from Kinetics field *)
	If[MatchQ[kineticsModel,Automatic|None],
		Switch[polymerType,
			(* For DNA and RNA, all thermodynamic data is stored in the model thermodynamics *)
			(DNA|ObjectP[Model[Physics,Oligomer]]),
			Switch[polymerType,
				ObjectP[Model[Physics,Oligomer]],

				Module[{packet,parameters},
					(* Return with $Failed if the object does not exist *)
					packet=Quiet[
						Check[
							Download[polymerType],
							Message[Error::ObjectDoesNotExist,polymerType];Return[$Failed],
							Download::ObjectDoesNotExist
						],
						Download::ObjectDoesNotExist
					];

					(* The parameters to search in the object *)
					If[MatchQ[Download[Lookup[packet,Kinetics,Null]],Null|{}],
						<||>,
						Download[Download[Lookup[packet,Kinetics,Null]],allKineticParameters]
					]
				],

				(* We have the information for DNA *)
				_,
				Join[
					Download[Download[Model[Physics,Oligomer,SymbolName[polymerType]],Kinetics],allKineticParameters],
					(* Hardcoding these for now *)
					<|
						FoldingRate->1.4*10^4 /Second
					|>
				]
			],

			(* For anything else, we don't have the kinetic parameters now *)
			_,
			<||>
		],

		(* If the kineticsModel is not Automatic take the data from the KineticsModel *)
		Join[
			Download[kineticsModel,allKineticParameters],
			<|
				FoldingRate->1.4*10^4 /Second
			|>
		]
	]

];



(* ::Subsection:: *)
(*Modification upload and update*)



(* ::Subsubsection::Closed:: *)
(*uploadModification*)

(* Helper Function: uploads the modification with a particular mass (molecular weight) *)

DefineOptions[UploadModification,
	Options :> {

		{
			OptionName->Name,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>_String,Size->Word],
			Description->"The name of the modification which replaces the name of the preexisiting model.",
			Category->"Model Information"
		},
		{
			OptionName->Molecule,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>MoleculeP,Size->Paragraph],
			Description->"The molecule (structure) of the modification specified with mathematica's Molecule[] function.",
			Category->"Physical Property"
		},
		{
			OptionName->MoleculeAdjustment,
			Default->{None,None},
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>{MoleculeP|None,MoleculeP|None},Size->Paragraph],
			Description->"Changes to the molecular structure when the modification is incorporated into an oligomer. It is specified with mathematica's Molecule[] function.",
			Category->"Physical Property"
		},
		{
			OptionName->Mass,
			Default->0 Gram/Mole,
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Gram/Mole],Units->Gram/Mole],
			Description->"The mass (molecular weight).",
			Category->"Physical Property"
		},
		{
			OptionName->LambdaMax,
			Default->0 Nanometer,
			AllowNull->False,
			Widget->Widget[Type->Quantity,Pattern:>GreaterEqualP[0 Nanometer],Units->Nanometer],
			Description->"The wavelength of the maximum absorbance value.",
			Category->"Physical Property"
		},
		{
			OptionName->QuantumYield,
			Default->Null,
			AllowNull->True,
			Widget->Widget[Type->Expression,Pattern:>{{GreaterP[0*Nanometer], GreaterP[0*Nanometer], RangeP[0,1]}..},Size->Paragraph],
			Description->"The ratio of photons emitted over photons absorbed at a particular ExcitationPeakWavelength and EmissionPeakWavelength.",
			Category->"Physical Property"
		},
		{
			OptionName->ExtinctionCoefficients,
			Default->{{260 Nanometer, 0 Liter/Centimeter/Mole}},
			AllowNull->False,
			Widget->Widget[Type->Expression,Pattern:>{{GreaterP[0*Nanometer], GreaterEqualP[0*Liter/Centimeter/Mole]}..},Size->Paragraph],
			Description->"The wavelength and the corresponding extinction coefficent.",
			Category->"Physical Property"
		},
		{
			OptionName->Oligomers,
			Default->All,
			AllowNull->False,
			Widget->Alternatives[
				"Single Known Type"->Widget[Type->Enumeration,Pattern:>All | Alternatives@@DeleteCases[AllPolymersP,Modification]],
				"Single Other Type"->Widget[Type->Expression,Pattern:>ObjectP[Model[Physics,Oligomer]],Size->Line],
				"Multiple Known Types"->Adder[
					Widget[Type->Enumeration,Pattern:>All | Alternatives@@DeleteCases[AllPolymersP,Modification]]
				],
				"Multiple Other Types"->Adder[
					Widget[Type->Expression,Pattern:>ObjectP[Model[Physics,Oligomer]],Size->Line]
				]
			],
			Description->"If All, the modification will be linked to all polymer types, otherwise to a specific polymer.",
			Category->"Model Information"
		},
		{
			OptionName->SyntheticMonomer,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				"Single Model"->
					{
						"Strategy" -> Alternatives[
							"Known Strategies"->Widget[Type->Enumeration,Pattern:>None|Boc|Fmoc|Phosphoramidite],
							"Other Strategies"->Widget[Type->Expression,Pattern:>_String,Size->Word]
						],
						"StockSolutionModel" -> Alternatives[
							"N/A"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
							Widget[Type->Object,Pattern:>ObjectP[Model[Sample,StockSolution]]]
						]
					},
				"Multiple Models" -> Adder[
					{
						"Strategy" -> Alternatives[
							"Known Strategies"->Widget[Type->Enumeration,Pattern:>None|Boc|Fmoc|Phosphoramidite],
							"Other Strategies"->Widget[Type->Expression,Pattern:>_String,Size->Word]
						],
						"StockSolutionModel" -> Alternatives[
							"N/A"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
							Widget[Type->Object,Pattern:>ObjectP[Model[Sample,StockSolution]]]
						]
					}
				]
			],
			Description->"Specifies the model of sample that will be utilized if this modification is specified to be used in an experiment. The inputs are the synthesis strategy, concentration and the sample model, respectively.",
			Category->"Model Information"
		},
		{
			OptionName->DownloadMonomer,
			Default->Null,
			AllowNull->True,
			Widget->Alternatives[
				"Single Model"->
					{
						"Strategy" -> Alternatives[
							"Known Strategies"->Widget[Type->Enumeration,Pattern:>None|Boc|Fmoc|Phosphoramidite],
							"Other Strategies"->Widget[Type->Expression,Pattern:>_String,Size->Word]
						],
						"StockSolutionModel" -> Alternatives[
							"N/A"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
							Widget[Type->Object,Pattern:>ObjectP[Model[Sample,StockSolution]]]
						]
					},
				"Multiple Models" -> Adder[
					{
						"Strategy" -> Alternatives[
							"Known Strategies"->Widget[Type->Enumeration,Pattern:>None|Boc|Fmoc|Phosphoramidite],
							"Other Strategies"->Widget[Type->Expression,Pattern:>_String,Size->Word]
						],
						"StockSolutionModel" -> Alternatives[
							"N/A"->Widget[Type->Enumeration,Pattern:>Alternatives[Null]],
							Widget[Type->Object,Pattern:>ObjectP[Model[Sample,StockSolution]]]
						]
					}
				]
			],
			Description->"Specifies the model of sample that will be utilized if this modification is specified to be used in an experiment. The inputs are the synthesis strategy, concentration and the sample model, respectively.",
			Category->"Model Information"
		},
		OutputOption,
		UploadOption
	}];

Error::ModificationDoesNotExist="The selected modification model does not exist. Please use a string to create a new modification model.";


UploadModification[name : _String, myOptions : OptionsPattern[UploadModification]] := Module[
	{safeOptions, output, modification, packetToUpload, packetToCheck, validModificationTest, preExist, listedOptions, createSynthesisField,
		authors, modificationObj, modificationExistsQ, uploadedModification, updatedOligomer},

	listedOptions = ToList[myOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[UploadModification, listedOptions];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = Lookup[safeOptions, Output];

	(* determine if the object exists *)
	modificationObj = Model[Physics, Modification, name];
	modificationExistsQ = DatabaseMemberQ[Model[Physics, Modification, name]];

	(* Find the modifications based on the name *)
	modification = Which[
		Not[modificationExistsQ], $Failed,
		Lookup[safeOptions, Upload], Quiet[Download[modificationObj]],
		True,
			(* Renaming the multiple fields if Upload is False - so the user can upload the output packet directly *)
			Module[{packet, updatedLinksPacket},
				packet = Quiet[Download[modificationObj]];

				(* Taking the objects and refreshing the link to avoid later issues in Uploading the packet by the user *)
				updatedLinksPacket = If[!MatchQ[packet, $Failed | Null | {}],
					Append[packet,
						{
							Authors -> (Link[#]& /@ packet[Authors][Object]),
							SyntheticMonomer -> If[!MatchQ[packet[SyntheticMonomer], Null | {}],
								(Association @@ {Strategy -> #[Strategy], StockSolutionModel -> If[!NullQ[#[StockSolution]], Link[#[StockSolution][Object]]]}& /@ packet[SyntheticMonomer]),
								packet[SyntheticMonomer]
							]
						}
					],
					packet
				];

				(* Remove the Notebook field as it won't allow upload if later on the packet needs to be uploaded *)
				If[!MatchQ[updatedLinksPacket, $Failed | Null | {}],
					KeyDrop[
						keyRename[updatedLinksPacket,
							(
								(# -> Replace[#])& /@
									Join[
										{Authors, LiteratureReferences},
										Keys@DeleteCases[safeOptions, Rule[Output | Upload, _]]
									]
							)
						],
						{Notebook}
					],
					updatedLinksPacket
				]
			]
	];

	(* The authors to use later below *)
	authors = Which[
		(* Not preexisting packet *)
		MatchQ[modification, $Failed | Null | {}], {},

		(* We have the Author key *)
		MemberQ[Keys@modification, Authors], modification[Authors][Object],

		(* We have Replace keyword *)
		MemberQ[Keys@modification, Replace[Authors]], modification[Replace[Authors]][Object],

		True, {}
	];

	(* True, if the modification already exist *)
	preExist = MatchQ[modification, ObjectP[Model[Physics, Modification]]];

	(* A helper function to create the synthesis fields SyntheticMonomer and SyntheticSty *)
	createSynthesisField[fieldName : SyntheticMonomer | DownloadMonomer] := Module[
		{synthesisModels},

		(* The synthesis model set provided in the options - if single add it to a list *)
		synthesisModels = If[Length[Dimensions[Lookup[safeOptions, fieldName]]] == 1,
			{Lookup[safeOptions, fieldName]},
			Lookup[safeOptions, fieldName]
		];

		Map[
			Function[
				synthesisModel,
				Association @@ ({Strategy -> synthesisModel[[1]], StockSolutionModel -> If[!NullQ[synthesisModel[[2]]], Link[synthesisModel[[2]]]] })
			],
			synthesisModels
		]
	];

	(* Creating the packet associated with the modification with user defined inputs *)
	packetToUpload = If[preExist,
		(* If preExist just update the ones that are specified in the options *)
		Join[
			(* If the author already mentioned, don't add again *)
			If[MemberQ[authors, $PersonID],
				<|
					Object -> modification[Object],
					Type -> Model[Physics, Modification]
				|>,
				<|
					Object -> modification[Object],
					Type -> Model[Physics, Modification],
					Append[Authors] -> Link[$PersonID]
				|>
			],
			Association @@ ((Replace[First[#]] -> Lookup[safeOptions, First[#]])& /@ DeleteCases[listedOptions, Rule[Output | Upload | Oligomers | SyntheticMonomer, _]]),
			(* SyntheticMonomer need to be used inside a link wrapper *)
			Association @@ Map[
				Function[
					synthesisOption,
					Replace[First[synthesisOption]] -> createSynthesisField[First[synthesisOption]]
				],
				Select[listedOptions, MatchQ[First[#], SyntheticMonomer]&]
			]
		],
		(* If not pre exisiting, populate all fields *)
		Join[
			<|
				Replace[Name] -> name,
				Type -> Model[Physics, Modification],
				Replace[Authors] -> Link[$PersonID],
				Replace[Molecule] -> Lookup[safeOptions, Molecule],
				Replace[MoleculeAdjustment] -> Lookup[safeOptions, MoleculeAdjustment],
				Replace[Mass] -> Lookup[safeOptions, Mass],
				Replace[SyntheticMonomer] -> If[MatchQ[Lookup[safeOptions, SyntheticMonomer], Null], Null, createSynthesisField[SyntheticMonomer]],
				Replace[DownloadMonomer] -> If[MatchQ[Lookup[safeOptions, DownloadMonomer], Null], Null, createSynthesisField[DownloadMonomer]],
				Replace[LambdaMax] -> Lookup[safeOptions, LambdaMax],
				Replace[QuantumYield] -> Lookup[safeOptions, QuantumYield],
				Replace[ExtinctionCoefficients] -> Lookup[safeOptions, ExtinctionCoefficients]
			|>
		]
	];

	(* Creating the packet associated with the modification with user defined inputs *)
	packetToCheck = If[preExist,
		Append[modification, packetToUpload],
		packetToUpload
	];

	(* Testing if the modification passes the valid criteria *)
	validModificationTest = validModificationQ[packetToCheck];

	(* Clearing the cache associated with all model physics related functions in this file *)
	(* Upload if the modification object is valid *)
	(* Also return Null if validModificationQ didn't evaluate *)
	uploadedModification = If[MatchQ[validModificationTest, BooleanP],
		If[validModificationTest,
			clearModelPhysicsCache[];
			If[Lookup[safeOptions, Upload],
				Upload[packetToUpload],
				packetToCheck
			],
			Null
		],
		Null
	];

	(* Update the oligomer if the modification is valid and if it does not preexist *)
	updatedOligomer = If[Lookup[safeOptions, Upload],
		(* If Upload is true - we have the object and should upload the changes to the Constellation *)
		If[!MatchQ[uploadedModification, Null],
			(* Reset the oligomer types *)
			Upload[
				Join[
					<|
						Object -> Download[uploadedModification, Object]
					|>,
					If[MatchQ[Lookup[safeOptions, Oligomers], All],
						(* Add to all polymers *)
						<|Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ DeleteCases[AllPolymersP, Modification])|>,
						(* Add to only the ones specified *)
						<|Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ ToList[Lookup[safeOptions, Oligomers]])|>
					]
				]
			],
			$Failed
		],
		(* If Upload is false - dealing with the pure packet *)
		If[!MatchQ[uploadedModification, Null],
			(* Reset the oligomer types *)
			Append[
				uploadedModification,
				If[MatchQ[Lookup[safeOptions, Oligomers], All],
					(* Add to all polymers *)
					Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ DeleteCases[AllPolymersP, Modification]),
					(* Add to only the ones specified *)
					Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ ToList[Lookup[safeOptions, Oligomers]])
				]
			],
			$Failed
		]
	];

	(* Return the result, options, or tests according to the output option. *)
	output /. {
		Result -> updatedOligomer,
		Preview -> updatedOligomer,
		Tests -> {},
		Options -> safeOptions
	}

];

(* Overload for a model physics - which means the object preExists *)
UploadModification[model : ObjectP[Model[Physics, Modification]], myOptions : OptionsPattern[UploadModification]] := Module[
	{safeOptions, output, modification, packetToUpload, packetToCheck, validModificationTest, listedOptions, authors, createSynthesisField,
		uploadedModification, updatedOligomer},

	listedOptions = ToList[myOptions];

	(* Call SafeOptions to make sure all options match pattern *)
	safeOptions = SafeOptions[UploadModification, listedOptions];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output = Lookup[safeOptions, Output];

	(* Find the modifications based on the name *)
	modification = Quiet[
		Check[
			If[Lookup[safeOptions, Upload],
				Download[model],

				(* Renaming the multiple fields if Upload is False - so the user can upload the output packet directly *)
				Module[{packet, updatedLinksPacket},
					packet = Quiet[Download[model]];

					(* Taking the objects and refreshing the link to avoid later issues in Uploading the packet by the user *)
					updatedLinksPacket = If[!MatchQ[packet, $Failed | Null | {}],
						Append[packet,
							{
								Authors -> (Link[#]& /@ packet[Authors][Object]),
								SyntheticMonomer -> If[!MatchQ[packet[SyntheticMonomer], Null | {}],
									(Association @@ {Strategy -> #[Strategy], StockSolutionModel -> If[!NullQ[#[StockSolutionModel]], Link[#[StockSolutionModel][Object]]]}& /@ packet[SyntheticMonomer]),
									packet[SyntheticMonomer]
								],
								DownloadMonomer -> If[!MatchQ[packet[DownloadMonomer], Null | {}],
									(Association @@ {Strategy -> #[Strategy], StockSolutionModel -> If[!NullQ[#[StockSolutionModel]], Link[#[StockSolutionModel][Object]]]}& /@ packet[DownloadMonomer]),
									packet[DownloadMonomer]
								]
							}
						],
						packet
					];

					(* Remove the Notebook field as it won't allow upload if later on the packet needs to be uploaded *)
					If[!MatchQ[updatedLinksPacket, $Failed | Null | {}],
						KeyDrop[
							keyRename[updatedLinksPacket,
								(
									(# -> Replace[#])& /@
										Join[
											{Authors, LiteratureReferences},
											Keys@DeleteCases[safeOptions, Rule[Output | Upload, _]]
										]
								)
							],
							{Notebook}
						],
						updatedLinksPacket
					]
				]
			],
			Message[Error::ModificationDoesNotExist];Return[$Failed],
			{Download::ObjectDoesNotExist}
		],
		{Download::ObjectDoesNotExist}
	];

	(* The authors to use later below *)
	authors = Which[
		(* Not preexisting packet *)
		MatchQ[modification, $Failed | Null | {}],
		{},

		(* We have the Author key *)
		MemberQ[Keys@modification, Authors],
		modification[Authors][Object],

		(* We have Replace keyword *)
		MemberQ[Keys@modification, Replace[Authors]],
		modification[Replace[Authors]][Object],

		True,
		{}
	];

	(* A helper function to create the synthesis fields SyntheticMonomer and DownloadMonomer *)
	createSynthesisField[fieldName : SyntheticMonomer | DownloadMonomer] := Module[
		{synthesisModels},

		(* The synthesis model set provided in the options - if single add it to a list *)
		synthesisModels = If[Length[Dimensions[Lookup[safeOptions, fieldName]]] == 1,
			{Lookup[safeOptions, fieldName]},
			Lookup[safeOptions, fieldName]
		];

		Map[
			Function[
				synthesisModel,
				Association @@ ({Strategy -> synthesisModel[[1]], StockSolutionModel -> If[!NullQ[synthesisModel[[2]]], Link[synthesisModel[[2]]]] })
			],
			synthesisModels
		]
	];

	(* Creating the packet associated with the modification with user defined inputs *)
	packetToUpload =
		If[Lookup[safeOptions, Upload],
			Join[

				(* If the author already mentioned, don't add again *)
				If[MemberQ[authors, $PersonID],
					<|
						Object -> modification[Object],
						Type -> Model[Physics, Modification]
					|>,
					<|
						Object -> modification[Object],
						Type -> Model[Physics, Modification],
						Append[Authors] -> Link[$PersonID]
					|>
				],

				Association @@ ((Replace[First[#]] -> Lookup[safeOptions, First[#]])& /@ DeleteCases[listedOptions, Rule[Output | Upload | Oligomers | SyntheticMonomer | DownloadMonomer, _]]),
				(* SyntheticMonomer need to be used inside a link wrapper *)
				Association @@ Map[
					Function[
						synthesisOption,
						Replace[First[synthesisOption]] -> createSynthesisField[First[synthesisOption]]
					],
					Select[listedOptions, MatchQ[First[#], SyntheticMonomer]&]
				]
			],
			(* For packets, just use what is preexisting and add the user options as needed *)
			Append[
				modification,
				Join[
					((Replace[First[#]] -> Lookup[safeOptions, First[#]])& /@ DeleteCases[listedOptions, Rule[Output | Upload | Oligomers | SyntheticMonomer | DownloadMonomer, _]]),
					Map[
						Function[
							synthesisOption,
							Replace[First[synthesisOption]] -> createSynthesisField[First[synthesisOption]]
						],
						Select[listedOptions, MatchQ[First[#], SyntheticMonomer]&]
					],
					Map[
						Function[
							synthesisOption,
							Replace[First[synthesisOption]] -> createSynthesisField[First[synthesisOption]]
						],
						Select[listedOptions, MatchQ[First[#], DownloadMonomer]&]
					]
				]
			]
		];

	(* Creating the packet associated with the modification with user defined inputs - we append to the modification as the pakcet pre-exist *)
	packetToCheck = Append[modification, packetToUpload];

	(* Testing if the modification passes the valid criteria *)
	validModificationTest = validModificationQ[packetToCheck];

	(* Clearing the cache associated with all model physics related functions in this file *)
	(* Upload if the modification object is valid *)
	(* Also return Null if validModificationQ didn't evaluate *)
	uploadedModification = If[MatchQ[validModificationTest, BooleanP],
		If[validModificationTest,
			clearModelPhysicsCache[];
			If[Lookup[safeOptions, Upload],
				Upload[packetToUpload],
				packetToCheck
			],
			Null
		],
		Null
	];

	(* Update the oligomer if the modification is valid and if it does not preexist *)
	updatedOligomer = If[Lookup[safeOptions, Upload],
		(* If Upload is true - we have the object and should upload the changes to the Constellation *)
		If[!MatchQ[uploadedModification, Null],
			(* Reset the oligomer types *)
			Upload[
				Join[
					<|
						Object -> uploadedModification[Object]
					|>,
					If[MatchQ[Lookup[safeOptions, Oligomers], All],
						(* Add to all polymers *)
						<|Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ DeleteCases[AllPolymersP, Modification])|>,
						(* Add to only the ones specified *)
						<|Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ ToList[Lookup[safeOptions, Oligomers]])|>
					]
				]
			],
			$Failed
		],
		(* If Upload is false - dealing with the pure packet *)
		If[!MatchQ[uploadedModification, Null],
			(* Reset the oligomer types *)
			Append[
				uploadedModification,
				If[MatchQ[Lookup[safeOptions, Oligomers], All],
					(* Add to all polymers *)
					Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ DeleteCases[AllPolymersP, Modification]),
					(* Add to only the ones specified *)
					Replace[Oligomers] -> (Link[Model[Physics, Oligomer, SymbolName[#]], Modifications]& /@ ToList[Lookup[safeOptions, Oligomers]])
				]
			],
			$Failed
		]
	];

	(* Return the result, options, or tests according to the output option. *)
	output /. {
		Result -> updatedOligomer,
		Preview -> updatedOligomer,
		Tests -> {},
		Options -> safeOptions
	}

];

(* A helper function to replace the key in an association *)
keyRename[asc_?AssociationQ,key_->key_] := asc;
keyRename[asc_?AssociationQ,old_->new_] := (KeyDrop[old]@Insert[asc,new->asc[old],Key[old]]) /; KeyExistsQ[asc,old];
(* If the key doesn't exist return the association *)
keyRename[asc_?AssociationQ,old_->new_] := asc;
(* For multiple rule overload fold the function with the inputs *)
keyRename[asc_?AssociationQ,list:{_Rule..}] := Fold[keyRename,asc,list];
keyRename[$Failed,__] := $Failed;

(* Helper Function: to clear all memoized functions used in this file *)
clearModelPhysicsCache[]:=Module[{},

	(ReloadPackage["Physics`"];LoadUsage["Physics`"]);

	(* Clearning the memoization of the model physics related functions *)
	ClearMemoization[#]& /@
	{
		Physics`Private`lookupModelOligomer
	};

];

(* Authors definition for Physics`Private`lookupModelExtinctionCoefficients *)
Authors[Physics`Private`lookupModelExtinctionCoefficients]:={"scicomp", "brad"};


(* Authors definition for Physics`Private`lookupModelThermodynamicsCorrection *)
Authors[Physics`Private`lookupModelThermodynamicsCorrection]:={"scicomp", "brad"};


(* Authors definition for Physics`Private`lookupModelKinetics *)
Authors[Physics`Private`lookupModelKinetics]:={"scicomp", "brad"};