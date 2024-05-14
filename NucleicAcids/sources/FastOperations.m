

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

monoPolymers = {DNA,RNA,PNA};
monoPolymerP = Alternatives@@monoPolymers;

dimersFast[monoPolymerP,seq_String]:=StringPartition[seq, 2, 1];
dimersFast[pol_,seq_String]:=Dimers[seq,Polymer->pol,FastTrack->True];

sequenceFirstFast[monoPolymerP,h_[s_String,label:Repeated[_String, {0, 1}]]]:=StringFirst[s];
sequenceFirstFast[monoPolymerP,other_]:=SequenceFirst[other,ExplicitlyTyped->False];

sequenceLastFast[monoPolymerP,h_[s_String,label:Repeated[_String, {0, 1}]]]:=StringLast[s];
sequenceLastFast[monoPolymerP,other_]:=SequenceLast[other,ExplicitlyTyped->False];

monomersFast[strand_Strand,ops___]:=Flatten[Map[monomersFast[#,ops]&,List@@strand],1];
monomersFast[(h:monoPolymerP)[s_String,label:Repeated[_String, {0, 1}]],ops___]:=Map[h,Characters[s]];
monomersFast[other_,ops___]:=
	Monomers[other,PassOptions[Monomers,ops]];

sequenceTakeFast[(h:monoPolymerP)[s_String,label:Repeated[_String, {0, 1}]],span_Span,ops___]:=h[StringTake[s,span]];
sequenceTakeFast[other_,span_Span,ops___]:=
	SequenceTake[other,span,PassOptions[SequenceTake,ops]];

motifLength[monoPolymerP[seq_String,label:Repeated[_String, {0, 1}]],ops___]:=StringLength[seq];
motifLength[other_,ops___]:=SequenceLength[other,PassOptions[StrandLength,SequenceLength,ops]];


revCompFast;

sequenceLengthFast;

strandLengthFast;
