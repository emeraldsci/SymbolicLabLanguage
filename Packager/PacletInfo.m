(* Paclet Info File *)

Paclet[
    Name -> "Packager",
    Version -> "0.2.0",
    MathematicaVersion -> "11+",
    Extensions -> {
        {"Kernel", Root -> "sources", Context -> "Packager`"},
        {"Resource", Root->"sources",
            Resources -> {
                {"Packager","Packager.m"},
                {"Packager","FastLoad.m"}}
        }
    }
]