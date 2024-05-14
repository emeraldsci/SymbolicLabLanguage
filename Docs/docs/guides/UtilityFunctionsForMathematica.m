(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Utility Functions For Mathematica",
	Abstract -> "Collection of functions that is useful for miscellaneous operations on Mathematica.",
	Reference -> {
		"List Manipulation" -> {
			{AllGreaterEqual, "Checks if every element of an array is greater than or equal to a given value."},
			{ToList, "Wraps the provided expression in List unless it is already a List."},
			{Repeat, "Generates a list consisting a specified number of repeated items."},
			{RepeatedQ, "Checks if all items in the provided list are identical."},
			{ListableP, "Is a pattern which matches both single or a list of provided input pattern."},
			{SameLengthQ, "Checks if all provided inputs have the same length."},
			{Unflatten, "Restructures the provided flat list so it has the same structure as a specified list."},
			{Middle, "Returns the middle element of the provided expression."},
			{DeleteNestedDuplicates, "Deletes redundant non-List items across an arbitrary-depth list of lists such that a flattened version of the input list will contain no duplicates."},
			{ExpandDimensions, "Generates a list from the provided item by repeating or padding such that its dimension matches the specified list."},
			{RiffleAlternatives, "Generates a list by selecting elements from two provided lists in an order specified by a list of Booleans."},
			{PartitionRemainder, "Generates a list of sublists by splitting the provided list into lists with specified length."},
			{SetDifference, "Returns a list of objects that are not in two provided lists."},
			{FirstOrDefault, "Returns the first element of the input unless it has no length."},
			{LastOrDefault, "Returns the last element of the input unless it has no length."},
			{RestOrDefault, "Removes the first element from the input unless it has no length."},
			{MostOrDefault, "Removes the last element from the input unless it has no length."},
			{GroupByTotal, "Groups the values in the provided list such that the total summation of a each grouping is as close to the specified target value as possible without going over."},
			{PickList,"Picks elements of list for which the corresponding element matches pattern, and returns a list of those elements."}
		},
		"String Functions" -> {
			{StringFirst, "Returns the first character of the provided string."},
			{StringLast, "Returns the last character of the provided string."},
			{StringRest,"Returns a string that contains the all but the first character from the input string."},
			{StringMost, "Returns a string that contains the all but the last character from the input string."},
			{StringPartitionRemainder, "Generates a list of strings by splitting the provided string into substrings with specified length."}
		},
		"Associations" -> {
			{AssociationMatchQ, "Checks if each key-value pair in the provided association matches the specified pattern association."},
			{AssociationMatchP, "Is a pattern that matches an association with key-value patterns matching the patterns specified in the input."},
			{ReplaceRule, "Replaces the rules in the provided list of rules with the specified new rules with the same left-hand side."},
			{ExtractRule, "Extracts the first rule whose left-hand side matches the specified expression."},
			{KeyPatternsQ, "Checks if the keys in the provided association or list of rules matches the patterns specified in an association or list of rules with the same keys."}
		},
		"Helpful Patterns" -> {
			{NullQ, "Checks if the provided expression is Null or a list of Null."},
			{ValidGraphicsQ, "Checks if the provided expression is a valid Graphics."},
			{PDFFileQ, "Checks if the given file is a PDF."},
			{ModificationQ, "Checks if the given change is a valid sequence of modifications."}
		},
		"Documentation" -> {
			{Tests, "Returns defined tests and examples for the input."},
			{EmeraldTest, "Represents the results of a test."},
			{EmeraldTestSummary, "Represents the results of a group of tests."}
		},
		"Graphics and Images" -> {
			{ColorFade, "Generates a series of colors from the dark to light based on the provided color."}
		},
		"Low Level" -> {
			{ClearMemoization, "Clears all functions whose results have been saved, so those functions will have to be run fresh again."}

		},
		"Input" ->{
			{FastImport, "Imports the input file of specified file type using the fastest method available."}
		},
		"Output" -> {
			{FastExport, "Writes given content to a file using the fastest method available."}

		},
		"Miscellaneous" -> {
			{OptionDefinition, "Returns a list of associations with the option name, default value, head, pattern, description, category, symbol and index matching status for each option of the input symbol."},
			{SafeEvaluate, "Evaluates the input expression if no members of input list match NullP or empty set, otherwise returns Null."},
			{UnsortedComplement, "Returns the elements that are in first input but not second input in the order they are present in the first input."},
			{ValidComputationQ, "Checks if the mathematica commands in the input can be converted into a computation."}
		}
	},
	RelatedGuides -> {
		GuideLink["WorkingWithConstellationObjects"],
		GuideLink["ConstellationUtilityFunctions"]
	}
]
