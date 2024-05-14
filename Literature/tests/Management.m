

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


literatureContents = {"(* ::Package:: *)", "", "(* ::Title:: *)", "(*Literature.m*)", "", \
"", "(* Emerald Therapeutics Mathematica Package *)", "(* \
::Section::Closed:: *)", "(*Journals*)", "", "", "(* \
::Subsubsection::Closed:: *)", "(*JournalP*)", "", "", \
"Unprotect[JournalP];", "JournalP::usage=\"All of the known journal \
names in the form of full names with captial letters on each word \
(except articles, eg. of), abreviated only when the journal publisher \
lists their name as abrivated (e.g. ACS Nano), and resolving & vs. \
and as the journal publisher lists their name. (e.g. Cancer Biology & \
Therapy).\";", "JournalP=Alternatives[", "	\"Accounts of Chemical \
Research\",", "	\"ACM Transactions on Mathematical Software\",", "	\
\"ACS applied materials & interfaces\",", "	\"ACS chemical \
biology\",", "	\"ACS Nano\",", "	\"Acta Pharmacologica Sinica\",", "	\
\"Acta Societatis Ophthalmologicae Japonicae\",", "	\"Advanced \
Materials\",", "	\"Advances in Chemistry Series\",", "	\"Advances in \
Experimental Medicine and Biology\",", "	\"Advances in Virus Research\
\",", "	\"Aldrichimica Acta\",", "	\"Algorithms\",", "	\"Algorithms \
for Molecular Biology\",", "	\"Analytical and Bioanalytical Chemistry\
\",", "	\"Analytical biochemistry\",", "	\"Analytical \
Biochemistry\",", "	\"Analytical Chemistry\",", "	\"Angewandte Chemie \
International Edition\",", "	\"Animal Genetics\",", "	\"Annals of \
Internal Medicine\",", "	\"Annals of the New York Academy of Sciences\
\",", "	\"Annual Review Biophysics\",", "	\"Annual Review of \
Biochemistry\",", "	\"Annual Review of Biophysics and \
Bioengineering\",", "	\"Annual Review of Biophysics and Biomolecular \
Structure\",", "	\"Annual Review of Microbiology\",", "	\"Annual \
Review of Pharmacology and Toxicology\",", "	\"Annual Review of \
Physical Chemistry\",", "	\"Antiviral Research\",", "	\"Applied \
Materials & Interfaces\",", "	\"Applied Microbiology and \
Biotechnology\",", "	\"Applied Physics Letters\",", "	\"Archives of \
Pathology and Laboratory Medicine\",", "	\"Archives of Pharmacal \
Research\",", "	\"Archives of Virology\",", "	\"Artificial DNA, PNA & \
XNA\",", "	\"Asian Pacific Journal of Cancer Prevention\",", "	\"Best \
Pratice & Research Clinical Haematology\",", "	\"Biochemical and \
Biophysical Research Communications\",", "	\"Biochemical pharmacology\
\",", "	\"Biochemical Society Symposia\",", "	\"Biochemical Society \
Transactions\",", "	\"Biochemistry\",", "	\"Biochemistry and Cell \
Biology\",", "	\"Biochimica et Biophysica Acta\",", "	\"Biochimica et \
Biophysica Acta - Gene Structure and Expression\",", "	\
\"Biochimie\",", "	\"Bioconjugate Chemistry\",", "	\"Bioessays\",", "	\
\"Bioinformatics\",", "	\"Biology Direct\",", "	\"Biomolecular \
Engineering\",", "	\"Bioorganic Chemistry\",", "	\"Bioorganic & \
Medicinal Chemistry\",", "	\"Bioorganic & Medicinal Chemistry Letters\
\",", "	\"Biophysical Chemistry\",", "	\"Biophysical Journal\",", "	\
\"Biopolymers\",", "	\"BioSystems\",", "	\"BioTechniques\",", "	\
\"Biotechnology Journal\",", "	\"Biotechnology Progress\",", "	\
\"Blood\",", "	\"Blood Cells, Molecules, and Diseases\",", "	\"BMB \
Reports\",", "	\"BMC Bioinformatics\",", "	\"BMC Cancer\",", "	\"BMC \
Evolutionary Biology\",", "	\"BMC Genomics\",", "	\"BMC Molecular \
Biology\",", "	\"BMC Neuroscience\",", "	\"Brain Research\",", "	\
\"Breast Cancer Research and Treatment\",", "	\"British Journal of \
Cancer\",", "	\"British Medical Bulletin\",", "	\"Bulletin of \
Mathematical Biology\",", "	\"Bulletin of Mathematical \
Biophysics\",", "	\"Bulletin of the Chemical Society of Japan\",", "	\
\"Canadian Medical Association Journal\",", "	\"Cancer Biology & \
Therapy\",", "	\"Cancer Cell International\",", "	\"Cancer Detection \
and Prevention\",", "	\"Cancer Gene Therapy\",", "	\"Cancer \
Letters\",", "	\"Cancer Research\",", "	\"Cancer Science\",", "	\
\"Carcinogenesis\",", "	\"Cell\",", "	\"Cell Communication and \
Signaling\",", "	\"Cell Cycle\",", "	\"Cell Death & \
Differentiation\",", "	\"Cell Death & Disease\",", "	\"Cell \
Research\",", "	\"Cellular and Molecular Life Sciences\",", "	\
\"ChemBioChem\",", "	\"Chemical Communications\",", "	\"Chemical \
Reviews\",", "	\"Chemical Society Reviews\",", "	\"Chemistry\",", "	\
\"Chemistry - A European Journal\",", "	\"Chemistry & \
Biodiversity\",", "	\"Chemistry & Biology\",", "	\"Chinese Journal of \
Cancer\",", "	\"Chinese Journal of Chromatography\",", "	\
\"Chirality\",", "	\"Chromosoma\",", "	\"Chromosome Research\",", "	\
\"Clinical and Developmental Immunology\",", "	\"Clinical Cancer \
Research\",", "	\"Clinical Science\",", "	\"Cold Spring Harbor \
Symposia on Quantitative Biology\",", "	\"Comment. Academiae Sci. I. \
Petropolitanae\",", "	\"Communications of the ACM\",", "	\
\"Computational Biology and Chemistry\",", "	\"Computational Systems \
Bioinformatics Conference\",", "	\"Computer Applications in the \
Biosciences\",", "	\"Computer Journal\",", "	\"Computing\",", "	\
\"Critical Reviews in Biochemistry and Molecular Biology\",", "	\
\"Current Alzheimer Research\",", "	\"Current medicinal \
chemistry\",", "	\"Current Medicinal Chemistry\",", "	\"Current \
Opinion in Biotechnology\",", "	\"Current Opinion in Chemical Biology\
\",", "	\"Current Opinion in Microbiology\",", "	\"Current Opinion in \
Structural Biology\",", "	\"Current protocols in chemical \
biology\",", "	\"Current Protocols in Nucleic Acid Chemistry\",", "	\
\"Current topics in medicinal chemistry\",", "	\"Cytogenetic and \
Genome Research\",", "	\"Dalton Transations\",", "	\"Developmental \
Biology\",", "	\"Developmental Dynamics\",", "	\"DNA Research\",", "	\
\"Doklady Akademii Nauk\",", "	\"Drug Discovery Today\",", "	\
\"Electrophoresis\",", "	\"EMBO Journal\",", "	\"EMBO Reports\",", "	\
\"European Journal of Biochemistry\",", "	\"European Journal of \
Cancer\",", "	\"European Journal of Immunology\",", "	\"European \
Journal of Obstetrics & Gynecology and Reproductive Biology\",", "	\
\"European Journal of Organic Chemistry\",", "	\"Evolution\",", "	\
\"Experimental and Molecular Pathology\",", "	\"Experimental Cell \
Research\",", "	\"Experimental Dermatology\",", "	\"F1000 Biology \
Reports\",", "	\"FASEB journal : official publication of the \
Federation of American Societies for Experimental Biology\",", "	\
\"FEBS Letters\",", "	\"Folding and Design\",", "	\"Frontiers in \
Bioscience\",", "	\"Frontiers in Immunology\",", "	\"Frontiers in \
Oncology\",", "	\"Gene\",", "	\"Gene Expression Patterns\",", "	\
\"Genes & Development\",", "	\"Genesis\",", "	\"Genes to Cells\",", "	\
\"Gene Therapy\",", "	\"Genetica\",", "	\"Genetic Programming and \
Evolvable Machines\",", "	\"Genetics\",", "	\"Genome Biology\",", "	\
\"Genome Research\",", "	\"Genomic Medicine\",", "	\"Genomics\",", "	\
\"Helvetica Chimica Acta\",", "	\"Human Genetics\",", "	\"Human \
Molecular Genetics\",", "	\"IEEE Transactions on NanoBioscience\",", \
"	\"Immunity\",", "	\"Immunology & Cell Biology\",", "	\"Immunology \
Today\",", "	\"Inorganica Chimica Acta\",", "	\"Inorganic \
Chemistry\",", "	\"Insect Molecular Biology\",", "	\"International \
Journal of Cancer\",", "	\"International Journal of Molecular \
Sciences\",", "	\"International Journal of Oncology\",", "	\"Journal \
of Antimicrobial Chemotherapy\",", "	\"Journal of AOAC \
International\",", "	\"Journal of Bacteriology\",", "	\"Journal of \
Basic Microbiology\",", "	\"Journal of Biochemistry\",", "	\"Journal \
of Biological Chemistry\",", "	\"Journal of Biomedical Research\",", \
"	\"Journal of Biomolecular Structure and Dynamics\",", "	\"Journal \
of biomolecular techniques\",", "	\"Journal of Cell Science\",", "	\
\"Journal of Cellular and Molecular Medicine\",", "	\"Journal of \
Chemical Physics\",", "	\"Journal of Child Psychology and Psychiatry \
and Allied Disciplines\",", "	\"Journal of Chromatography A\",", "	\
\"Journal of Chromatography B\",", "	\"Journal of Clinical \
Microbiology\",", "	\"Journal of Clinical Oncology\",", "	\"Journal \
of Colloid and Interface Science\",", "	\"Journal of Computational \
Biology\",", "	\"Journal of Drug Targeting\",", "	\"Journal of \
General Virology\",", "	\"Journal of Heart and Lung \
Transplantation\",", "	\"Journal of Human Genetics\",", "	\"Journal \
of Immunological Methods\",", "	\"Journal of Immunology\",", "	\
\"Journal of Inorganic Biochemistry\",", "	\"Journal of Internal \
Medicine\",", "	\"Journal of Leukocyte Biology\",", "	\"Journal of \
Luminescence\",", "	\"Journal of Mathematical Biology\",", "	\
\"Journal of Medical Virology\",", "	\"Journal of Medicinal Chemistry\
\",", "	\"Journal of Molecular Biology\",", "	\"Journal of Molecular \
Cell Biology\",", "	\"Journal of Molecular Evolution\",", "	\"Journal \
of Molecular Structure\",", "	\"Journal of nanobiotechnology\",", "	\
\"Journal of Neural Transmission\",", "	\"Journal of nucleic \
acids\",", "	\"Journal of Oncology\",", "	\"Journal of Organic \
Chemistry\",", "	\"Journal of Physical Chemistry A\",", "	\"Journal \
of Physical Chemistry B\",", "	\"Journal of Plant Physiology\",", "	\
\"Journal of Separation Science\",", "	\"Journal of Southern Medical \
University\",", "	\"Journal of the American Chemical Society\",", "	\
\"Journal of Theoretical Biology\",", "	\"Journal of Veterinary \
Medical Science\",", "	\"Journal of Virological Methods\",", "	\
\"Journal of Virology\",", "	\"Journal of Zhejiang University. \
Science. B\",", "	\"Koninklijke Nederlandse Akademie v. Wetenschappen\
\",", "	\"Lancet\",", "	\"Lecture Notes in Computer Science\",", "	\
\"Letters in Peptide Science\",", "	\"Luminescence\",", "	\
\"Mathematical Biosciences\",", "	\"Medical Hypotheses\",", "	\
\"Metabolic Engineering\",", "	\"Methods\",", "	\"Methods in \
Enzymology\",", "	\"Methods in Molecular Biology\",", "	\"Microbial \
Pathogenesis\",", "	\"Microbiological Reviews\",", "	\"Molecular and \
Biochemical Parasitology\",", "	\"Molecular and Cellular Biology\",", \
"	\"Molecular and Cellular Probes\",", "	\"Molecular and General \
Genetics\",", "	\"Molecular Aspects of Medicine\",", "	\"Molecular \
BioSystems\",", "	\"Molecular Brain Research\",", "	\"Molecular \
Cancer\",", "	\"Molecular Cancer Therapeutics\",", "	\"Molecular Cell\
\",", "	\"Molecular Interventions\",", "	\"Molecular \
Microbiology\",", "	\"Molecular Physics\",", "	\"Molecular Systems \
Biology\",", "	\"Molecular Therapy\",", "	\"Mutation Research\",", "	\
\"Nano letters\",", "	\"Nano Letters\",", "	\"Nanotechnology\",", "	\
\"Natural Computing\",", "	\"Natural Product Research\",", "	\"Nature\
\",", "	\"Nature Biotechnology\",", "	\"Nature Cell Biology\",", "	\
\"Nature Chemical Biology\",", "	\"Nature Genetics\",", "	\"Nature \
Medicine\",", "	\"Nature Methods\",", "	\"Nature Nanotechnology\",", \
"	\"Nature Protocols\",", "	\"Nature Reviews Cancer\",", "	\"Nature \
Reviews Drug Discovery\",", "	\"Nature Reviews Genetics\",", "	\
\"Nature Reviews Immunology\",", "	\"Nature Reviews Microbiology\",", \
"	\"Nature Reviews Molecular Cell Biology\",", "	\"Nature Structural \
Biology\",", "	\"Nature Structural & Molecular Biology\",", "	\
\"Naturwissenschaften\",", "	\"Neoplasia\",", "	\"Neuroscience\",", "	\
\"Neuroscience Letters\",", "	\"New Journal of Chemistry\",", "	\
\"Nucleic Acids Research\",", "	\"Nucleic acids symposium series\",", \
"	\"Nucleic Acids Symposium Series\",", "	\"Nucleic acids symposium \
series (2004)\",", "	\"Nucleosides, Nucleotides and Nucleic \
Acids\",", "	\"Oligonucleotides\",", "	\"Oncogene\",", "	\"Organic & \
Biomolecular Chemistry\",", "	\"Organic Letters\",", "	\"Organic \
Preparations and Procedures International\",", "	\"Pacific Symposium \
on Biocomputing\",", "	\"Pharmacology\",", "	\"Physica D\",", "	\
\"Physical Review A\",", "	\"Physical Review E\",", "	\"Physical \
Review Letters\",", "	\"Phytochemistry\",", "	\"Pigment Cell Research\
\",", "	\"Planta Medica\",", "	\"Plant and Cell Physiology\",", "	\
\"PLoS Biology\",", "	\"PLoS Computational Biology\",", "	\"PLoS \
Genet\",", "	\"PLoS Neglected Tropical Diseases\",", "	\"PLoS \
One\",", "	\"PLoS Pathogens\",", "	\"Postepy Biochemii\",", "	\
\"Proceedings IEEE Computational Systems Bioinformatics \
Conference\",", "	\"Proceedings International Conference on \
Intelligent Systems for Molecular Biology\",", "	\"Proceedings of the \
London Mathematical Society\",", "	\"Proceedings of the National \
Academy of Sciences of the United States of America\",", "	\"Progress \
in Molecular Biology and Translational Science\",", "	\
\"Prostaglandins, Leukotrienes and Essential Fatty Acids\",", "	\
\"Protein, Nucleic Acid and Enzyme\",", "	\"Protein Science\",", "	\
\"Protein science : a publication of the Protein Society\",", "	\
\"Proteins: Structure, Function and Bioinformatics\",", "	\"Pure and \
Applied Chemistry\",", "	\"Quarterly Review of Biology\",", "	\
\"Quarterly Reviews of Biophysics\",", "	\"RNA\",", "	\"RNA \
Biology\",", "	\"Science\",", "	\"Scientific American\",", "	\
\"Seminars in Cancer Biology\",", "	\"Small\",", "	\"Structure\",", "	\
\"Supramolecular Chemistry\",", "	\"Synlett\",", "	\"Synthesis\",", "	\
\"Talanta\",", "	\"Tetrahedron\",", "	\"Tetrahedron Asymmetry\",", "	\
\"Tetrahedron Letters\",", "	\"The Biochemical Journal\",", "	\"The \
EMBO Journal\",", "	\"The Journal of Antimicrobial Chemotherapy\",", \
"	\"The Journal of Biological Chemistry\",", "	\"The Journal of \
Clinical Investigation\",", "	\"The Journal of Experimental \
Medicine\",", "	\"The Journal of organic chemistry\",", "	\"The New \
England Journal of Medicine\",", "	\"Theoretical Biology and Medical \
Modeling\",", "	\"Toxicological Sciences\",", "	\"Toxicology\",", "	\
\"Trends in Analytical Chemistry\",", "	\"Trends in Biochemical \
Sciences\",", "	\"Trends in Biotechnology\",", "	\"Trends in Genetics\
\",", "	\"Trends in Pharmacological Sciences\",", "	\"Vaccine\",", "	\
\"Virology\",", "	\"Virology Journal\",", "	\"Viruses\",", "	\"Virus \
Research\",", "	\"World Journal of Gastroenterology\",", "	\
\"Zeitschrift fur Naturforschung C\"", "];", "Protect[JournalP];", \
"", "", "(* ::Subsubsection::Closed:: *)", "(*JournalConversions*)", \
"", "", "JournalConversions::usage=\"List of rules converting any \
varients of a journal's name to its canonical name in JournalP.\";", \
"JournalConversions={", "	\"Acc Chem Res\"->\"Accounts of Chemical \
Research\",", "	\"Accounts of chemical research\"->\"Accounts of \
Chemical Research\",", "	\"ACM Trans. Math. Soft\"->\"ACM \
Transactions on Mathematical Software\",", "	\"Acta pharmacologica \
Sinica\"->\"Acta Pharmacologica Sinica\",", "	\"Nippon Ganka Gakkai \
Zasshi. Acta Societatis Ophthalmologicae Japonicae\"->\"Acta \
Societatis Ophthalmologicae Japonicae\",", "	\"Adv \
Mater\"->\"Advanced Materials\",", "	\"Advances in virus research\"\
->\"Advances in Virus Research\",", "	\"Algorithms Mol \
Biol\"->\"Algorithms for Molecular Biology\",", "	\"Anal Bioanal Chem\
\"->\"Analytical and Bioanalytical Chemistry\",", "	\"Analytical \
chemistry\"->\"Analytical Chemistry\",", "	\"Angewandte Chemie. \
International Ed. In English\"->\"Angewandte Chemie International \
Edition\",", "	\"Angewandte Chemie (International ed. in English)\"\
->\"Angewandte Chemie International Edition\",", "	\"Angew Chem Int \
Ed Engl\"->\"Angewandte Chemie International Edition\",", "	\"Annals \
of internal medicine\"->\"Annals of Internal Medicine\",", "	\"Annu \
Rev Biophys\"->\"Annual Review Biophysics\",", "	\"Annual Review of \
microbiology\"->\"Annual Review of Microbiology\",", "	\"Archives of \
virology\"->\"Archives of Virology\",", "	\"Artificial DNA, PNA \
&amp;amp; XNA\"->\"Artificial DNA, PNA & XNA\",", "	\"Asian Pacific \
journal of cancer prevention : APJCP\"->\"Asian Pacific Journal of \
Cancer Prevention\",", "	\"Best Pract Res Clin Haematol\"->\"Best \
Pratice & Research Clinical Haematology\",", "	\"Biochimica et \
biophysica acta\"->\"Biochimica et Biophysica Acta\",", "	\
\"Bioconjugate chemistry\"->\"Bioconjugate Chemistry\",", "	\
\"Bioconjugate Chemisty\"->\"Bioconjugate Chemistry\",", "	\
\"Bioinformatics (Oxford, England)\"->\"Bioinformatics\",", "	\"Biol \
Direct\"->\"Biology Direct\",", "	\"Biomol Eng\"->\"Biomolecular \
Engineering\",", "	\"Bioorg Chem\"->\"Bioorganic Chemistry\",", "	\
\"Bioorganic and Medicinal Chemistry\"->\"Bioorganic & Medicinal \
Chemistry\",", "	\"Bioorganic &amp;amp; medicinal chemistry letters\"\
->\"Bioorganic & Medicinal Chemistry Letters\",", "	\"Bioorganic and \
Medicinal Chemistry Letters\"->\"Bioorganic & Medicinal Chemistry \
Letters\",", "	\"Biotechnol J\"->\"Biotechnology Journal\",", "	\"BMB \
reports\"->\"BMB Reports\",", "	\"BMC cancer\"->\"BMC Cancer\",", "	\
\"BMC Evol Biol\"->\"BMC Evolutionary Biology\",", "	\"BMC Mol Biol\"\
->\"BMC Molecular Biology\",", "	\"BMC Neurosci\"->\"BMC Neuroscience\
\",", "	\"British journal of cancer\"->\"British Journal of \
Cancer\",", "	\"British medical bulletin\"->\"British Medical \
Bulletin\",", "	\"CMAJ\"->\"Canadian Medical Association Journal\",", \
"	\"Cancer biology & therapy\"->\"Cancer Biology & Therapy\",", "	\
\"Cancer cell international\"->\"Cancer Cell International\",", "	\
\"Cancer gene therapy\"->\"Cancer Gene Therapy\",", "	\"Cancer \
research\"->\"Cancer Research\",", "	\"Cancer Sci\"->\"Cancer Science\
\",", "	\"Cell communication and signaling : CCS\"->\"Cell \
Communication and Signaling\",", "	\"Cell cycle (Georgetown, Tex.)\"\
->\"Cell Cycle\",", "	\"Cell death and differentiation\"->\"Cell \
Death & Differentiation\",", "	\"Cell death and disease\"->\"Cell \
Death & Disease\",", "	\"Cell research\"->\"Cell Research\",", "	\
\"Chem Commun (Camb)\"->\"Chemical Communications\",", "	\"Chemical \
reviews\"->\"Chemical Reviews\",", "	\"Chemical Society \
reviews\"->\"Chemical Society Reviews\",", "	\"Chemistry- A European \
Journal\"->\"Chemistry - A European Journal\",", "	\"Chemistry \
(Weinheim an der Bergstrasse, Germany)\"->\"Chemistry - A European \
Journal\",", "	\"Chem Biodivers\"->\"Chemistry & Biodiversity\",", "	\
\"Chemistry and Biology\"->\"Chemistry & Biology\",", "	\"Chemistry & \
biology\"->\"Chemistry & Biology\",", "	\"Chinese journal of cancer\"\
->\"Chinese Journal of Cancer\",", "	\"Se Pu\"->\"Chinese Journal of \
Chromatography\",", "	\"Clinical & developmental \
immunology\"->\"Clinical and Developmental Immunology\",", "	\
\"Clinical cancer research : an official journal of the American \
Association for Cancer Research\"->\"Clinical Cancer Research\",", "	\
\"Clinical science (London, England : 1979)\"->\"Clinical \
Science\",", "	\"Comput Biol Chem\"->\"Computational Biology and \
Chemistry\",", "	\"Comput Syst Bioinformatics Conf\"->\"Computational \
Systems Bioinformatics Conference\",", "	\"Curr Alzheimer \
Res\"->\"Current Alzheimer Research\",", "	\"Current opinion in \
chemical biology\"->\"Current Opinion in Chemical Biology\",", "	\
\"Current opinion in structural biology\"->\"Current Opinion in \
Structural Biology\",", "	\"Curr Protoc Nucleic Acid \
Chem\"->\"Current Protocols in Nucleic Acid Chemistry\",", "	\
\"Cytogenet Genome Res\"->\"Cytogenetic and Genome Research\",", "	\
\"Dalton Trans\"->\"Dalton Transations\",", "	\"The EMBO \
journal\"->\"EMBO Journal\",", "	\"EMBO Rep\"->\"EMBO Reports\",", "	\
\"EMBO reports\"->\"EMBO Reports\",", "	\"Eur J Obstet Gynecol Reprod \
Biol\"->\"European Journal of Obstetrics & Gynecology and \
Reproductive Biology\",", "	\"European journal of organic chemistry\"\
->\"European Journal of Organic Chemistry\",", "	\"F1000 Biol Rep\"\
->\"F1000 Biology Reports\",", "	\"Frontiers in \
immunology\"->\"Frontiers in Immunology\",", "	\"Frontiers in \
oncology\"->\"Frontiers in Oncology\",", "	\"Gene Expr \
Patterns\"->\"Gene Expression Patterns\",", "	\"Genome \
Biol\"->\"Genome Biology\",", "	\"Genomic Med\"->\"Genomic \
Medicine\",", "	\"IEEE Trans Nanobioscience\"->\"IEEE Transactions on \
NanoBioscience\",", "	\"Immunology and cell biology\"->\"Immunology & \
Cell Biology\",", "	\"Inorg Chem\"->\"Inorganic Chemistry\",", "	\
\"International journal of cancer. Journal international du cancer\"\
->\"International Journal of Cancer\",", "	\"International journal of \
molecular sciences\"->\"International Journal of Molecular \
Sciences\",", "	\"J Bac\"->\"Journal of Bacteriology\",", "	\"J \
Biochem\"->\"Journal of Biochemistry\",", "	\"Journal of biomedical \
research\"->\"Journal of Biomedical Research\",", "	\"Journal of cell \
science\"->\"Journal of Cell Science\",", "	\"Journal of cellular and \
molecular medicine\"->\"Journal of Cellular and Molecular \
Medicine\",", "	\"J Chromatogr B Analyt Technol Biomed Life \
Sci\"->\"Journal of Chromatography B\",", "	\"Journal of clinical \
oncology : official journal of the American Society of Clinical \
Oncology\"->\"Journal of Clinical Oncology\",", "	\"Journal of \
immunology (Baltimore, Md. : 1950)\"->\"Journal of Immunology\",", "	\
\"Journal of internal medicine\"->\"Journal of Internal Medicine\",", \
"	\"Journal of leukocyte biology\"->\"Journal of Leukocyte \
Biology\",", "	\"Journal of molecular cell biology\"->\"Journal of \
Molecular Cell Biology\",", "	\"Journal of oncology\"->\"Journal of \
Oncology\",", "	\"J Phys Chem A\"->\"Journal of Physical Chemistry \
A\",", "	\"J Phys Chem B\"->\"Journal of Physical Chemistry B\",", "	\
\"J Plant Physiol\"->\"Journal of Plant Physiology\",", "	\"J Sep Sci\
\"->\"Journal of Separation Science\",", "	\"Nan Fang Yi Ke Da Xue \
Xue Bao\"->\"Journal of Southern Medical University\",", "	\"Journal \
of the american chemical society\"->\"Journal of the American \
Chemical Society\",", "	\"Journal of virological methods\"->\"Journal \
of Virological Methods\",", "	\"Journal of virology\"->\"Journal of \
Virology\",", "	\"Lec. Notes in Computer Science\"->\"Lecture Notes \
in Computer Science\",", "	\"Metab Eng\"->\"Metabolic \
Engineering\",", "	\"Methods in enzymology\"->\"Methods in Enzymology\
\",", "	\"Methods in molecular biology (Clifton, N.J.)\"->\"Methods \
in Molecular Biology\",", "	\"Molecular and cellular \
biology\"->\"Molecular and Cellular Biology\",", "	\"Molecular \
aspects of medicine\"->\"Molecular Aspects of Medicine\",", "	\"Mol \
Biosyst\"->\"Molecular BioSystems\",", "	\"Brain Research. Molecular \
Brain Research\"->\"Molecular Brain Research\",", "	\"Mol \
Cancer\"->\"Molecular Cancer\",", "	\"Molecular cancer\"->\"Molecular \
Cancer\",", "	\"Molecular cancer therapeutics\"->\"Molecular Cancer \
Therapeutics\",", "	\"Molecular cell\"->\"Molecular Cell\",", "	\"Mol \
Phys\"->\"Molecular Physics\",", "	\"Molecular systems \
biology\"->\"Molecular Systems Biology\",", "	\"Molecular therapy : \
the journal of the American Society of Gene Therapy\"->\"Molecular \
Therapy\",", "	\"Nano Lett\"->\"Nano Letters\",", "	\"Nat Prod Res\"\
->\"Natural Product Research\",", "	\"Nature \
biotechnology\"->\"Nature Biotechnology\",", "	\"Nat Cell \
Biol\"->\"Nature Cell Biology\",", "	\"Nat Chem Biol\"->\"Nature \
Chemical Biology\",", "	\"Nature medicine\"->\"Nature Medicine\",", "	\
\"Nat Nanotechnol\"->\"Nature Nanotechnology\",", "	\"Nature \
nanotechnology\"->\"Nature Nanotechnology\",", "	\"Nat \
Protoc\"->\"Nature Protocols\",", "	\"Nat Rev Cancer\"->\"Nature \
Reviews Cancer\",", "	\"Nature Reviews: Cancer\"->\"Nature Reviews \
Cancer\",", "	\"Nature reviews. Drug discovery\"->\"Nature Reviews \
Drug Discovery\",", "	\"Nat Rev Genet\"->\"Nature Reviews \
Genetics\",", "	\"Nature reviews. Genetics\"->\"Nature Reviews \
Genetics\",", "	\"Nature reviews. Immunology\"->\"Nature Reviews \
Immunology\",", "	\"Nature reviews. Microbiology\"->\"Nature Reviews \
Microbiology\",", "	\"Nat Rev Mol Cell Biol\"->\"Nature Reviews \
Molecular Cell Biology\",", "	\"Nature reviews. Molecular cell \
biology\"->\"Nature Reviews Molecular Cell Biology\",", "	\"Nat \
Struct Mol Biol\"->\"Nature Structural & Molecular Biology\",", "	\
\"Neoplasia (New York, N.Y.)\"->\"Neoplasia\",", "	\"Nucleic Acids \
Res\"->\"Nucleic Acids Research\",", "	\"Nucleic acids \
research\"->\"Nucleic Acids Research\",", "	\"Nucleic Acids Symp Ser \
(Oxf)\"->\"Nucleic Acids Symposium Series\",", "	\"Nucleosides, \
nucleotides &amp;amp; nucleic acids\"->\"Nucleosides, Nucleotides and \
Nucleic Acids\",", "	\"Nucleosides Nucleotides Nucleic \
Acids\"->\"Nucleosides, Nucleotides and Nucleic Acids\",", "	\"Org \
Biomol Chem\"->\"Organic & Biomolecular Chemistry\",", "	\"Organic \
letters\"->\"Organic Letters\",", "	\"Org Lett\"->\"Organic \
Letters\",", "	\"Phys Rev A\"->\"Physical Review A\",", "	\"Physical \
Review E: Statistical Physics, Plasmas, Fluids, and Related \
Interdisciplinary Topics\"->\"Physical Review E\",", "	\"Phys Rev E \
Stat Nonlin Soft Matter Phys\"->\"Physical Review E\",", "	\"Phys Rev \
E Stat Phys Plasmas Fluids Relat Interdiscip Topics\"->\"Physical \
Review E\",", "	\"Phys Rev Lett\"->\"Physical Review Letters\",", "	\
\"PLoS Biol\"->\"PLoS Biology\",", "	\"PLoS biology\"->\"PLoS Biology\
\",", "	\"PLoS Negl Trop Dis\"->\"PLoS Neglected Tropical \
Diseases\",", "	\"PloS one\"->\"PLoS One\",", "	\"PLoS \
pathogens\"->\"PLoS Pathogens\",", "	\"Proc IEEE Comput Syst \
BioUpload Conf\"->\"Proceedings IEEE Computational Systems \
Bioinformatics Conference\",", "	\"Proc Int Conf Intell Syst Mol Biol\
\"->\"Proceedings International Conference on Intelligent Systems for \
Molecular Biology\",", "	\"Prog Mol Biol Transl Sci\"->\"Progress in \
Molecular Biology and Translational Science\",", "	\"Prostaglandins \
Leukotrienes and Essential Fatty Acids\"->\"Prostaglandins, \
Leukotrienes and Essential Fatty Acids\",", "	\"Tanpakushitsu Kakusan \
Koso. Protein, Nucleic Acid, Enzyme\"->\"Protein, Nucleic Acid and \
Enzyme\",", "	\"Proteins: Structure, Function & \
Bioinformatics\"->\"Proteins: Structure, Function and \
Bioinformatics\",", "	\"RNA Biol\"->\"RNA Biology\",", "	\"Science \
(New York, N.Y.)\"->\"Science\",", "	\
\"Tethrahedron\"->\"Tetrahedron\",", "	\"The Biochemical \
journal\"->\"The Biochemical Journal\",", "	\"The EMBO \
journal\"->\"The EMBO Journal\",", "	\"The Journal of antimicrobial \
chemotherapy\"->\"The Journal of Antimicrobial Chemotherapy\",", "	\
\"The Journal of Antimicrobial Chemotherapy\"->\"The Journal of \
Antimicrobial Chemotherapy\",", "	\"The Journal of biological \
chemistry\"->\"The Journal of Biological Chemistry\",", "	\"The \
Journal of clinical investigation\"->\"The Journal of Clinical \
Investigation\",", "	\"The Journal of experimental medicine\"->\"The \
Journal of Experimental Medicine\",", "	\"The New England journal of \
medicine\"->\"The New England Journal of Medicine\",", "	\"Theor Biol \
Med Model\"->\"Theoretical Biology and Medical Modeling\",", "	\
\"Toxicological sciences : an official journal of the Society of \
Toxicology\"->\"Toxicological Sciences\",", "	\"Virol J\"->\"Virology \
Journal\",", "	\"Virology journal\"->\"Virology Journal\",", "	\
\"World journal of gastroenterology : WJG\"->\"World Journal of \
Gastroenterology\",", "	\"Z Naturforsch C\"->\"Zeitschrift fur \
Naturforschung C\"", "};", "", "", "(* ::Section:: *)", \
"(*Keywords*)", "", "", "(* ::Subsubsection::Closed:: *)", \
"(*KeywordP*)", "", "", "Unprotect[KeywordP];", \
"KeywordP::usage=\"Keywords for Journals\";", \
"KeywordP=Alternatives[", "	\"abl\",", "	\"abt-737\",", "	\
\"adenovirus\",", "	\"akt\",", "	\"aminophospholipid_translocase\",", \
"	\"ampk\",", "	\"antisense\",", "	\"apoptosis\",", "	\
\"apoptosome\",", "	\"aptamer\",", "	\"autophagy\",", "	\"bacarbazine\
\",", "	\"bad\",", "	\"bak\",", "	\"bax\",", "	\"bc-2\",", "	\"b_cell\
\",", "	\"bcl-2\",", "	\"bcl-xl\",", "	\"bh3_mimetic\",", "	\
\"bid\",\"bim\",", "	\"boc\",", "	\"burkitts_lymphoma\",", "	\
\"calreticulin\",", "	\"cancer\",", "	\"caspase\",", "	\
\"caspase-3\",", "	\"caspase-9\",", "	\"caspase_activation\",", "	\
\"cd47\",", "	\"cell_death\",", "	\"cell_line\",", "	\
\"chelerythrine\",", "	\"chemokine\",", "	\"chemoresistance\",", "	\
\"ciap\",", "	\"computational_model\",", "	\"conjugation\",", "	\
\"copy_number\",", "	\"cure\",", "	\"cytochrome_c\",", "	\"ddpcr\",", \
"	\"deamidation\",", "	\"death_receptor\",", "	\"degradation\",", "	\
\"dengue\",", "	\"detection\",", "	\"eat-me_signal\",", "	\"eber\",", \
"	\"ebna\",", "	\"ebna-2\",", "	\"ebv\",", "	\"e_coli\",", "	\
\"engulfment\",", "	\"find-me_signal\",", "	\"flip\",", "	\"flu\",", \
"	\"fmoc\",", "	\"g3139\",", "	\"gene_expression\",", "	\
\"genotype\",", "	\"hbv\",", "	\"hcv\",", "	\"hiv\",", "	\
\"hodgkins_disease\",", "	\"hpv\",", "	\"htlv\",", "	\"htlv-1\",", "	\
\"htlv-2\",", "	\"htlv-3\",", "	\"immune_response\",", "	\
\"inhibitor\",", "	\"inhibitor_of_apoptosis_proteins\",", "	\
\"kshv\",", "	\"latent\",", "	\"livin\",", "	\"leukemia\",", "	\"lmp1\
\",", "	\"lymphoma\",", "	\"mcl-1\",", "	\"melanoma\",", "	\
\"mesothelioma\",", "	\"mirna\",", "	\"mitochondria\",", "	\
\"mitochondrial_outer_membrane_permeabilization\",", "	\"mitosis\",", \
"	\"mliap\",", "	\"modeling\",", "	\"necrosis\",", "	\"nfkb\",", "	\
\"nucleotide\",", "	\"oncogene\",", "	\"p53\",", "	\"parp\",", "	\
\"pcr\",", "	\"peptide_nucleic_acid\",", "	\"phagocytosis\",", "	\
\"phenotype\",", "	\"phosphatidylserine\",", "	\"pi_cyclization\",", \
"	\"phospholipid_scramblase\",", "	\"pna\",", "	\
\"protein_kinase_c\",", "	\"qpcr\",", "	\"quantitation\",", "	\
\"radiation\",", "	\"rip1\",", "	\"ripoptosome\",", "	\"rnai\",", "	\
\"screen\",", "	\"sirna\",", "	\"smac\",", "	\"small-cell_lung_cancer\
\",", "	\"solid-phase_synthesis\",", "	\"sphingolipid\",", "	\"stress\
\",", "	\"survivin\",", "	\"therapy\",", "	\"tnfalpha\",", "	\
\"toxicology\",", "	\"traf2\",", "	\"trail\",", "	\
\"transformation\",", "	\"ubiquitin\",", "	\
\"unfolded_protein_response\",", "	\"valinomycin\",", "	\"virus\",", \
"	\"xiap\"", "];", "Protect[KeywordP];", "", "", "(* \
::Section::Closed:: *)", "(*End*)"};



(* ::Subsubsection::Closed:: *)
(*FindJournal*)


DefineTests[FindJournal,
	{
		(* Basic examples *)
		Example[
			{Basic,"Searching for a journal in JournalP returns that journal's title:"},
			FindJournal["Journal of Bacteriology"],
			"Journal of Bacteriology"
		],
		Example[
			{Basic,"Searching for a journal in JournalConversions returns the corresponding entry from JournalP:"},
			FindJournal["J Bac"],
			"Journal of Bacteriology"
		],
		Example[
			{Basic,"Searching for a journal absent from JournalP and JournalConversions opens a dialog for the user to choose an existing entry or create a new entry in JournalP:"},
			Hold[FindJournal["Bacteriology"]],
			_Hold
		],

		(* Options examples *)
		Example[
			{Options,ExactMatch,"If ExactMatch->True and there's no exact match in JournalP or JournalConversions, returns $Failed:"},
			FindJournal["Journal of Fake Results",ExactMatch->True],
			$Failed
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*nearestString*)


DefineTests[
	nearestString,
	{
		(* Basic examples *)
		Example[{Basic,"Returns the closest members of the library to the provided string:"},
			nearestString["Cat",{"Fish","Taco","Bat","Cow"}],
			{"Bat"}
		],
		Example[{Basic,"If more than one equidistant nearest string is in the library, then all of these strings will be returned:"},
			nearestString["Cat",{"Fish","Rat","Taco","Bat","Cow"}],
			{"Bat","Rat"}
		],

		(* Options examples *)
		Example[{Options,MaxResults,"If MaxResults contains a levelspec 'N', the best N levels of matches will be returned:"},
			nearestString["Cat",{"Fish","Rats","Taco","Bat","Cow"},MaxResults->{2}],
			{"Bat","Rats","Cow","Taco"}
		],
		Example[{Options,MaxResults,"If MaxResults contains an integer 'N', the best N matches will be returned:"},
			nearestString["Cat",{"Fish","Rats","Taco","Bat","Cow"},MaxResults->3],
			{"Bat","Rats","Cow"}
		],
		Example[{Options,Unique,"If a unique response is requested, only the nearest string in the library will be returned:"},
			nearestString["Cat",{"Fish","Taco","Bat","Cow"},Unique->True],
			"Bat"
		],
		Example[{Options,ComparisonFunction,"The Mathematica function used to compare one string to another can be specified:"},
			nearestString["Cat",{"Fish","Taco","Bat","Cow"},ComparisonFunction->EditDistance],
			{"Bat"}
		],
		Example[{Options,ComparisonFunction,"Certain comparison functions do a better job matching certain types of strings:"},
			nearestString["apop",{"abl","akt","ampk","boc","ciap","flip","fmoc","hpv","p53","parp","pcr","pna","qpcr","xiap","apoptosis","apoptosome","inhibitor_of_apoptosis_proteins"},ComparisonFunction->SmithWatermanSimilarity],
			{"apoptosis","apoptosome","inhibitor_of_apoptosis_proteins"}
		],
		Example[{Options,IgnoreCase,"Case can be taken into account in the determining the nearest string:"},
			nearestString["cAT",{"cat","CAT","cAT","caT"},MaxResults->{1},IgnoreCase->False],
			{"cAT"}
		],

		(* Messages examples *)
		Example[{Messages,"NotUnique","If a unique match is requested, but more than equidistant result exists in the library, the NotUnique message is thrown:"},
			nearestString["Cat",{"Fish","Rat","Taco","Bat","Cow"},Unique->True],
			"Bat",
			Messages:>Message[nearestString::NotUnique]
		],

		(* Attributes examples *)
		Example[{Attributes,"Listable","The function is listable by input strings:"},
			nearestString[{"Wish","Cat"},{"Fish","Taco","Bat","Cow"},Unique->True],
			{"Fish","Bat"}
		],
		Example[{Attributes,"Listable","The function is also listable by libaries:"},
			nearestString["Cat",{{"Fish","Rat","Taco","Bat","Cow"},{"Stat","Format","MouseRat"}}],
			{{"Bat","Rat"},{"Format","MouseRat","Stat"}}
		],

		(* Tests *)
		Test["Symbolic input remains unevaluated:",
			nearestString[taco,{"Fish","Taco","Bat","Cow"}],
			_nearestString
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*FindKeyword*)


DefineTests[FindKeyword,
	{
		(* Basic examples *)
		Example[
			{Basic,"Searching for a keyword that already matches KeywordP returns that keyword:"},
			FindKeyword["apoptosis"],
			"apoptosis"
		],
		Example[
			{Basic,"Searching for a keyword absent from KeywordP opens a dialog for the user to choose an existing entry or create a new entry in KeywordP:"},
			Hold[FindKeyword["nonexistent_keyword"]],
			_Hold
		],

		(* Options examples *)
		Example[
			{Options,ExactMatch,"If ExactMatch->True and there's no exact match in KeywordP, returns 'KEYWORD LOOKUP FAILED':"},
			FindKeyword["nonexistent_keyword",ExactMatch->True],
			$Failed
		]
	}
];
