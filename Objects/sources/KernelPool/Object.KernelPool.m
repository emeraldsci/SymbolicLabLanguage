(* Mathematica Source File *)
(* Created by the Wolfram Language Plugin for IntelliJ, see http://wlplugin.halirutan.de/ *)
(* :Author: tharr *)
(* :Date: 2024-01-09 *)
DefineObjectType[Object[KernelPool], {
  Description -> "A collection of interactive manifold kernels that are used to support specific web applications that need SLL code execution.",
  CreatePrivileges -> None,
  Cache -> Session,
  Fields -> {
    DeveloperObject -> {
      Format -> Single,
      Class -> Expression,
      Pattern :> True|False,
      Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
      Category -> "Organizational Information"
    },
    Kernels -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Object[Software, ManifoldKernel],
      Description -> "The collection of Symbolic Lab Language (SLL) Mathematica kernels running in the cloud.",
      Category -> "Organizational Information",
      Abstract -> True
    },
    Size -> {
      Format -> Single,
      Class -> Integer,
      Pattern :> GreaterP[0, 1],
      Description -> "The number of kernels in the pool object.",
      Category -> "Organizational Information",
      Abstract -> True
    }
  }
}];
