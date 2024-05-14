DefineUsage[UploadUnitOperation,
  {
    BasicDefinitions -> {
      {
        Definition -> {"UploadUnitOperation[unitOperationPrimitives]", "unitOperationObjects"},
        Description -> "generates 'unitOperationObjects' given a list of 'unitOperationPrimitives'.",
        Inputs :> {
          IndexMatching[
            {
              InputName -> "unitOperationPrimitives",
              Description -> "The unit operation primitives that should be converted into unit operation objects",
              Widget -> Widget[
                Type -> Expression,
                Pattern :> UnitOperationPrimitiveP,
                Size -> Paragraph
              ],
              Expandable -> False
            },
            IndexName -> "unit operations"
          ]
        },
        Outputs :> {
          {
            OutputName -> "unitOperationObjects",
            Description -> "The unit operation objects that were uploaded to Constellation.",
            Pattern :> ObjectP[Object[UnitOperation]]
          }
        }
      }
    },
    SeeAlso -> {
      "Upload",
      "Download",
      "Experiment"
    },
    Author -> {
      "thomas"
    }
  }
]