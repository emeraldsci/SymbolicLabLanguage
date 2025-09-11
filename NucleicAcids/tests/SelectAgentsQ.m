(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2023-04-19 *)


DefineTests[SelectAgentsQ,
  {
    Example[{Basic, "Test a small DNA sequence to check if it encodes for a select agent or toxin:"},
      SelectAgentsQ[Strand[DNA["AGCTAGCT"]]],
      False,
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    Example[{Basic, "Test a sample object with DNA, RNA, and Peptide molecules to check if anything in the sample encodes for a select agent or toxin:"},
      SelectAgentsQ[Object[Sample, "Test select agents sample " <> uuid]],
      False,
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    Test["Re-test a sample object with DNA, RNA, and Peptide molecules with a different output format to make sure it works:",
      SelectAgentsQ[Object[Sample, "Test select agents sample " <> uuid], OutputFormat -> Report],
      KeyValuePattern[{Result -> False, SelectAgents -> {}, Hits -> {}}],
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    Example[{Basic, "Testing a long DNA sequence (>200 bp) sends multiple blast requests and checks each if they encode for a select agent or toxin:"},
      (
        longStrand = Strand[DNA[StringJoin[
          "ATGTCTATCCCAGAAACTCAAAAAGGTGTTATCTTCTACGAATCCCACGGTAAGTTGGAATACAAAGAT",
          "ATTCCAGTTCCAAAGCCAAAGGCCAACGAATTGTTGATCAACGTTAAATACTCTGGTGTCTGTCACACTG",
          "ACTTGCACGCTTGGCACGGTGACTGGCCATTGCCAGTTAAGCTACCATTAGTCGGTGGTCACG"
        ]]];
        SelectAgentsQ[longStrand]
      ),
      False,
      Variables :> {longStrand},
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithSafeHits[]|>
      }
    ],
    Example[{Basic, "Test a small peptide sequence to check if it encodes for a select agent or toxin:"},
      SelectAgentsQ[Strand[Peptide["MetHisLys"]]],
      False,
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    Example[{Basic, "If a conotoxin sequence is detected in the peptide, then the result will be returned early without sending a request to BLAST:"},
      SelectAgentsQ[Strand[Peptide["GlyArgCysCysHisProAlaCysGlyLysAsnTyrSerCys"]]],
      True,
      TimeConstraint -> 3600
    ],
    Example[{Additional, "Test an identity model representing a RNA molecule to check if it encodes for a select agent or toxin:"},
      SelectAgentsQ[Model[Molecule, Oligomer, "Test RNA for select agents " <> uuid]],
      False,
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    Test["Re-test an identity model representing a RNA molecule with a Report output to check if the final output formatting helper works:",
      SelectAgentsQ[Model[Molecule, Oligomer, "Test RNA for select agents " <> uuid], OutputFormat -> Report],
      KeyValuePattern[{Result -> False, SelectAgents -> {}, Hits -> {}}],
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithNoHits[]|>
      }
    ],
    (* ------- OPTIONS ------- *)
    Example[{Options, OutputFormat, "Changing the OutputFormat to Report generates an association of helpful metadata including the detected agent and matching statistics, which accompanies the Boolean result:"},
      (
        neurotoxinSection = Strand[DNA[StringJoin[
          "ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAG",
          "ATACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTC",
          "CTGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG"
        ]]];
        SelectAgentsQ[neurotoxinSection, OutputFormat -> Report]
      ),
      _Association,
      Variables :> {neurotoxinSection},
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithBadHits[]|>
      }
    ],
    Example[{Options, Retries, "Setting the Retries option controls the number of attempts that the SelectAgentsQ function will re-run in the event of an NCBI server failure:"},
      (
        neurotoxinSection = Strand[DNA[StringJoin[
          "ATGCCAGTTGCAATAAATAGTTTTAATTATAATGACCCTGTTAATGATGATACAATTTTATACATGCAG",
          "ATACCATATAAAGAAAAAAGTAAAAAATATTATAAAGCTTTTGAGATTATGCGTAATGTTTGGATAATTC",
          "CTGAGAGAAATACAATAGGAACGAATCCTAGTGATTTTGATCCACCGGCTTCATTAAAG"
        ]]];
        SelectAgentsQ[neurotoxinSection, Retries -> 4]
      ),
      True,
      Variables :> {neurotoxinSection},
      TimeConstraint -> 3600,
      Stubs :> {
        HTTPRequest[_, _Association] := "postRequest",
        URLRead["postRequest"] := <|"Body" -> testRidRtoeResponse["ABC123"]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=ABC123"] := "pollRequest",
        URLRead["pollRequest"] := <|"Body" -> testStatusCheckBody[]|>,
        HTTPRequest["https://blast.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=ABC123"] := "downloadRequest",
        URLRead["downloadRequest"] := <|"Body" -> testBlastDownloadWithBadHits[]|>
      }
    ],
    Test["Test the Retries option for a hypothetical case where the server is completely down for an extended period:",
      SelectAgentsQ[Strand[DNA["AGCTAGCT"]], Retries -> 5],
      $Failed,
      Messages :> {SelectAgentsQ::NCBIFailure, URLRead::invhttp, General::stop},
      Stubs :> {
        postBlastQuery[___] := {"stuff1", "stuff2"},
        getBlastIDWithRemainingTimeEstimate[___]:={"ABC123", 1},
        pollBlastServer[___] := (Message[URLRead::invhttp, "something went wrong"]; "failed")
      }
    ],
    (* --------------- Messages ----------------- *)
    Example[{Messages, "NCBIFailure", "If the NCBI servers fail, the select agents call can't be completed, and an error is returned:"},
      SelectAgentsQ[Strand[DNA["AGCTAGCT"]]],
      $Failed,
      Messages :> {SelectAgentsQ::NCBIFailure, URLRead::invhttp, General::stop},
      Stubs :> {
        postBlastQuery[___] := {"stuff1", "stuff2"},
        getBlastIDWithRemainingTimeEstimate[___]:={"ABC123", 1},
        pollBlastServer[___] := (Message[URLRead::invhttp, "something went wrong"]; "failed")
      }
    ],
    (* --------------- tests ------------------------ *)
    Test["Test the failure detector that comes from the polling function.",
      Catch[failIfNotReady[{"READY", "READY"}], "fatalerror"],
      Null
    ],
    Test["Test the failure detector that catches an error.",
      Catch[failIfNotReady[{"READY", "not ready"}], "fatalerror"],
      $Failed,
      Messages :> {SelectAgentsQ::NCBIFailure}
    ],
    Test["Test the dangerous agent q on a shortened response from NCBI:",
      dangerousAgentQ[
        {
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"}, "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae YKN1419 DNA, chromosome 15, complete sequence"},
              "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Ricin cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>,
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"},
              "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae YKN1419 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>,
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"},
              "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae YKN1419 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>
        },
        False
      ],
      {False..}
    ],
    Test["Test the dangerous agent q on a shortened response from NCBI when returning a report:",
      dangerousAgentQ[
        {
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"}, "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae YKN1419 DNA, chromosome 15, complete sequence"},
              "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>,
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"},
              "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae YKN1419 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>,
          <|"Hit" -> {
            <|
              "Hit_num" -> {"1"},
              "Hit_id" -> {"gi|2451843151|dbj|AP027358.1|"},
              "Hit_def" -> {"Ricin ricinus YKN1419 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP027358"},
              "Hit_len" -> {"1096786"}
            |>,
            <|
              "Hit_num" -> {"2"},
              "Hit_id" -> {"gi|2313943881|dbj|AP026863.1|"},
              "Hit_def" -> {"Saccharomyces cerevisiae S799 DNA, chromosome 15, complete sequence"}, "Hit_accession" -> {"AP026863"},
              "Hit_len" -> {"1065789"}
            |>
          }|>
        },
        True
      ],
      {"Ricin"}
    ],
    Test["Test that the result returning helper function works correctly for Boolean outputs:",
      returnResults[{False, True, False}, Boolean, <||>],
      True
    ],
    Test["Test that the result returning helper function works correctly for Report outputs:",
      returnResults[{"Ricin ricinus"}, Report, <||>],
      KeyValuePattern[{Hits -> <||>, SelectAgents -> {"Ricin ricinus"}, Result -> True}]
    ],
    Test["Test that the code surrounding the http requests/responses work as intended.",
      postBlastQuery[Strand[DNA["AGCT"]]],
      {_testHTTPResponse..},
      Stubs :> {
        HTTPRequest[___] := testHTTPResponse["blah"],
        URLRead[___] := testHTTPResponse["blahblah"]
      }
    ],
    Test["Test that the protein code surrounding the http requests/responses work as intended.",
      postBlastQuery[Strand[Peptide["HisMetLys"]]],
      {_testHTTPResponse..},
      Stubs :> {
        HTTPRequest[___] := testHTTPRequest["blah"],
        URLRead[___] := testHTTPResponse["blahblah"]
      }
    ],
    Test["Test that we can successfully detect a conotoxin peptide sequence:",
      detectConotoxin[Strand[Peptide["GlyArgCysCysHisProAlaCysGlyLysAsnTyrSerCys"]]],
      True
    ],
    Test["Test that we can successfully reject a sequence close to a conotoxin but not quite:",
      detectConotoxin[Strand[Peptide["GlyArgCysCysHisMetAlaCysGlyLysAsnTyrSerCys"]]],
      False
    ],
    Test["Test out whether a conotoxin report gets returned as a result:",
      Lookup[SelectAgentsQ[Strand[Peptide["GlyArgCysCysHisProAlaCysGlyLysAsnTyrSerCys"]], OutputFormat -> Report], SelectAgents],
      {"Conotoxin"},
      TimeConstraint -> 3600
    ]
  },
  Variables :> {uuid},
  SymbolSetUp :> (
    Module[
      {sample, oligomers},
      sample = CreateID[Object[Sample]];
      uuid = CreateUUID[];
      oligomers = Upload[{
        <|
          Type -> Model[Molecule, Oligomer],
          Name -> "Test DNA for select agents " <> uuid,
          Molecule -> Strand[DNA["AGCTAGCTAGCT"]]
        |>,
        <|
          Type -> Model[Molecule, Oligomer],
          Name -> "Test RNA for select agents " <> uuid,
          Molecule -> Strand[RNA["AGCUAGCUAGCU"]]
        |>,
        <|
          Type -> Model[Molecule, Oligomer],
          Name -> "Test peptide for select agents " <> uuid,
          Molecule -> Strand[Peptide["MetHisLys"]]
        |>
      }];

      (* create the test sample with all these things attached *)
      Upload[<|
        Object -> sample,
        Name -> "Test select agents sample " <> uuid,
        Replace[Composition] -> {
          {10 Millimolar, Link[Model[Molecule, Oligomer, "Test DNA for select agents " <> uuid]], Null},
          {20 Millimolar, Link[Model[Molecule, Oligomer, "Test RNA for select agents " <> uuid]], Null},
          {30 Millimolar, Link[Model[Molecule, Oligomer, "Test peptide for select agents " <> uuid]], Null},
          {100 VolumePercent, Link[Model[Molecule, "Water"]], Null}
        }
      |>]
    ]
  )
];
