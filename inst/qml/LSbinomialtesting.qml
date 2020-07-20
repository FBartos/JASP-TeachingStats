	//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//
import QtQuick 2.8
import QtQuick.Layouts 1.3
import JASP.Controls 1.0
import JASP.Widgets 1.0
import JASP.Theme 1.0
import "../qml" as LS

Form {
	id: form

	LS.LSdatainput{}

	Section
	{
		expanded: true
		title: qsTr("Model")

		InputListView
		{
			height: 200
			title				: qsTr("Name")
			name				: "priors"
			optionKey			: "name"
			placeHolder			: qsTr("New hypothesis")
			rowComponentsTitles: [qsTr("Parameter (θ)                        "), "Hypothesis                                                "]


			rowComponents:
			[
				Component
				{
					FormulaField
					{
						label: "P(H)"
						name: "PH"
						value: "1"
						min: 0
						inclusive: JASP.None
						fieldWidth: 70
						Layout.rightMargin: width
						useExternalBorder: false
						showBorder: true
					}
				},
				Component
				{
					DropDown
					{
						name: "type"
						values: ["beta", "spike"]
						Layout.rightMargin: 2
					}
				},
				Component
				{
					FormulaField
					{
						label: "α"
						name: "parAlpha"
						visible: fromRowComponents["type"].currentText === "beta"
						value: "1"
						min: 0
						inclusive: JASP.None
						fieldWidth: 70
						useExternalBorder: false
						showBorder: true
					}
				},
				Component
				{
					FormulaField
					{
						label: "β"
						name: "parBeta"
						visible: fromRowComponents["type"].currentText === "beta"
						value: "1"
						min: 0
						inclusive: JASP.None
						fieldWidth: 70
						useExternalBorder: false
						showBorder: true
					}
				},
				Component
				{
					FormulaField
					{
						label: "θ"
						name: "parPoint"
						visible: fromRowComponents["type"].currentText === "spike"
						Layout.rightMargin: width
						value: "0.5"
						min: 0
						max: 1
						inclusive: JASP.None
						fieldWidth: 70
						useExternalBorder: false
						showBorder: true
					}
				}
			]
		}

	}

	Section
	{
		expanded: true
		title: qsTr("Inference")
		columns: 2


		DropDown
		{
			name: "colorPalette"
			label: qsTr("Color palette")
			indexDefaultValue: 0
			Layout.columnSpan:	2
			values:
				[
				{ label: qsTr("Colorblind"),		value: "colorblind"		},
				{ label: qsTr("Colorblind Alt."),	value: "colorblind3"	},
				{ label: qsTr("Viridis"),			value: "viridis"		},
				{ label: qsTr("ggplot2"),			value: "ggplot2"		},
				{ label: qsTr("Gray"),				value: "gray"			}
				]
		}

		CheckBox
		{
			name: "plotsPrior"; label: qsTr("Prior distribution"); checked: false	;
			RadioButtonGroup
			{
				name: "plotsPriorType"

				RadioButton 
				{
					value: "conditional"
					label: qsTr("Conditional")
					checked: true

					CheckBox
					{
						name: "plotsPriorCI"
						label: qsTr("CI")
						id: plotsPriorCI
						childrenOnSameRow: true

						DropDown
						{
							name: "plotsPriorTypeCI"
							label: ""
							values: ["central", "HPD", "custom"]
							id: plotsPriorTypeCI
						}
					}

					Group
					{
						columns: 2
						CIField
						{
							visible: plotsPriorTypeCI.currentText == "central" |
									 plotsPriorTypeCI.currentText == "HPD"
							enabled: plotsPriorCI.checked
							name: "plotsPriorCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						DoubleField
						{
							visible: plotsPriorTypeCI.currentText == "custom"
							enabled: plotsPriorCI.checked
							name: "plotsPriorLower"
							label: qsTr("lower")
							id: plotsPriorLower
							fieldWidth: 50
							defaultValue: 0.25; min: 0; max: plotsPriorUpper.value; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPriorTypeCI.currentText == "custom"
							enabled: plotsPriorCI.checked
							name: "plotsPriorUpper"
							label: qsTr("upper")
							id: plotsPriorUpper
							fieldWidth: 50
							defaultValue: 0.75; min: plotsPriorLower.value; max: 1; inclusive: JASP.MinMax
						}
					}
				}

				RadioButton 
				{
					value: "joint"
				 	label: qsTr("Joint")
					
					RadioButtonGroup
					{
						name:  "plotsPriorJointType"

						RadioButton
						{
							value: "overlying"
				 			label: qsTr("Overlying")
							checked: true
						}

						RadioButton
						{
							value: "stacked"
				 			label: qsTr("Stacked")	
						}	
					
					}
					
				}

				RadioButton
				{ 
					value: "marginal";	
					label: qsTr("Marginal")	
					
					CheckBox
					{
						name: "plotsPriorMarginalCI"
						label: qsTr("CI")
						id: plotsPriorMarginalCI
						childrenOnSameRow: true

						DropDown
						{
							name: "plotsPriorMarginalType"
							label: ""
							values: ["central", "HPD", "custom"]
							id: plotsPriorMarginalType
						}
					}

					Group
					{
						columns: 2
						CIField{
							visible: plotsPriorMarginalType.currentText == "central" |
									 plotsPriorMarginalType.currentText == "HPD"
							enabled: plotsPriorMarginalCI.checked
							name: "plotsPriorMarginalCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						DoubleField
						{
							visible: plotsPriorMarginalType.currentText == "custom"
							enabled: plotsPriorMarginalCI.checked
							name: "plotsPriorMarginalLower"
							label: qsTr("lower")
							id: plotsMarginalPriorLower
							fieldWidth: 50
							defaultValue: 0.25; min: 0; max: plotsPriorMarginalUpper.value; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPriorMarginalType.currentText == "custom"
							enabled: plotsPriorMarginalCI.checked
							name: "plotsPriorMarginalUpper"
							label: qsTr("upper")
							id: plotsPriorMarginalUpper
							fieldWidth: 50
							defaultValue: 0.75; min: plotsPriorMarginalLower.value; max: 1; inclusive: JASP.MinMax
						}
					}					


				}

			}
		}


		CheckBox
		{
			name: "plotsPredictions"; label: qsTr("Prior predictive distribution"); checked: false	;
			RadioButtonGroup
			{
				name: "plotsPredictionType"
				RadioButton
				{
					value: "conditional"
					label: qsTr("Conditional")
					checked: true

					CheckBox
					{
						name: "plotsPredictionCI"
						label: qsTr("CI")
						id: plotsPredictionCI
						childrenOnSameRow: true

						DropDown
						{
							visible: plotsPredictionCI.checked
							name: "plotsPredictionTypeCI"
							label: ""
							values: ["central", "HPD", "custom"]
							id: plotsPredictionTypeCI
						}
					}

					Group
					{
						columns: 2

						CIField
						{
							visible: plotsPredictionTypeCI.currentText == "central" |
									 plotsPredictionTypeCI.currentText == "HPD"
							enabled: plotsPredictionCI.checked
							name: "plotsPredictionCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						IntegerField
						{
							visible: plotsPredictionTypeCI.currentText == "custom"
							enabled: plotsPredictionCI.checked
							name: "plotsPredictionLower"
							label: qsTr("lower")
							id: plotsPredictionLower
							fieldWidth: 50
							defaultValue: 0; min: 0; max: plotsPredictionUpper.value; inclusive: JASP.MinMax
						}

						IntegerField
						{
							visible: plotsPredictionTypeCI.currentText == "custom"
							enabled: plotsPredictionCI.checked
							name: "plotsPredictionUpper"
							label: qsTr("upper")
							id: plotsPredictionUpper
							fieldWidth: 50
							defaultValue: 1
							min: plotsPredictionLower.value; inclusive: JASP.MinMax
						}

					}
				}

				RadioButton
				{
					value: "joint"
				 	label: qsTr("Joint")
					
					RadioButtonGroup
					{
						name: "plotsPredictionJointType"

						RadioButton
						{
							value: "overlying"
				 			label: qsTr("Overlying")
							checked: true
						}

						RadioButton
						{
							value: "stacked"
				 			label: qsTr("Stacked")	
						}	
					
					}
					
				}

				RadioButton 
				{
					value: "marginal";	
					label: qsTr("Marginal")	
					
					CheckBox
					{
						name: "plotsPredictionMarginalCI"
						label: qsTr("CI")
						id: plotsPredictionMarginalCI
						childrenOnSameRow: true

						DropDown
						{
							name: "plotsPredictionMarginalType"
							label: ""
							values: ["central", "HPD", "custom"]
							id: plotsPredictionMarginalType
						}
					}

					Group
					{
						columns: 2
						CIField
						{
							visible: plotsPredictionMarginalType.currentText == "central" |
									 plotsPredictionMarginalType.currentText == "HPD"
							enabled: plotsPredictionMarginalCI.checked
							name: "plotsPredictionMarginalCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						DoubleField
						{
							visible: plotsPredictionMarginalType.currentText == "custom"
							enabled: plotsPredictionMarginalCI.checked
							name: "plotsPredictionMarginalLower"
							label: qsTr("lower")
							id: plotsMarginalPredictionLower
							fieldWidth: 50
							defaultValue: 0; min: 0; max: plotsPredictionMarginalUpper.value; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPredictionMarginalType.currentText == "custom"
							enabled: plotsPredictionMarginalCI.checked
							name: "plotsPredictionMarginalUpper"
							label: qsTr("upper")
							id: plotsPredictionMarginalUpper
							fieldWidth: 50
							defaultValue: 1; min: plotsPredictionMarginalLower.value; inclusive: JASP.MinOnly
						}
					}	
				}

			}

			CheckBox{name: "plotsPredictionsObserved"; label: qsTr("Observed data"); checked: false	}
		}


		CheckBox
		{
			Layout.columnSpan: 2
			name: "plotsPredictiveAccuracy"; label: qsTr("Predictive Accuracy"); checked: false	;
			RadioButtonGroup
			{
				name: "predictiveAccuracyType"
				RadioButton { value: "conditional"; label: qsTr("Conditional"); checked: true}
				RadioButton { value: "joint";		label: qsTr("Joint")}
				RadioButton { value: "marginal"; 	label: qsTr("Normalized")}

			}
		}


		CheckBox
		{
			name: "plotsPosterior"; label: qsTr("Posterior distribution"); checked: false;

			RadioButtonGroup
			{
				name: "plotsPosteriorType"
				RadioButton
				{
					checked: true
					value: "conditional"
					label: qsTr("Conditional")

					CheckBox
					{
						name: "plotsPosteriorCI"
						label: qsTr("CI")
						id: plotsPosteriorCI
						childrenOnSameRow: true

						DropDown
						{
							visible: plotsPosteriorCI.checked
							name: "plotsPosteriorTypeCI"
							label: ""
							values: ["central", "HPD", "custom","support"]
							id: plotsPosteriorTypeCI
						}
					}

					Group
					{
						columns: 2
						CIField
						{
							visible: plotsPosteriorTypeCI.currentText == "central" |
									 plotsPosteriorTypeCI.currentText == "HPD"
							enabled: plotsPosteriorCI.checked
							name: "plotsPosteriorCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						DoubleField
						{
							visible: plotsPosteriorTypeCI.currentText == "custom"
							enabled: plotsPosteriorCI.checked
							name: "plotsPosteriorLower"
							label: qsTr("lower")
							id: plotsPosteriorLower
							fieldWidth: 50
							defaultValue: 0; min: 0; max: plotsPosteriorUpper.value; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPosteriorTypeCI.currentText == "custom"
							enabled: plotsPosteriorCI.checked
							name: "plotsPosteriorUpper"
							label: qsTr("upper")
							id: plotsPosteriorUpper
							fieldWidth: 50
							defaultValue: 1; min: plotsPosteriorLower.value; max: 1; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPosteriorTypeCI.currentText == "support"
							enabled: plotsPosteriorCI.checked
							name: "plotsPosteriorBF"
							label: qsTr("BF")
							fieldWidth: 50
							defaultValue: 1; min: 0; inclusive: JASP.None
						}
					}

				}

				RadioButton 
				{
					value: "joint"
				 	label: qsTr("Joint")
					
					RadioButtonGroup
					{
						name: "plotsPosteriorJointType"

						RadioButton
						{
							value: "overlying"
				 			label: qsTr("Overlying")
							checked: true
						}

						RadioButton
						{
							value: "stacked"
				 			label: qsTr("Stacked")	
						}	
					
					}
					
				}

				RadioButton
				{ 
					value: "marginal";	
					label: qsTr("Marginal")	
					
					CheckBox
					{
						name: "plotsPosteriorMarginalCI"
						label: qsTr("CI")
						id: plotsPosteriorMarginalCI
						childrenOnSameRow: true

						DropDown
						{
							name: "plotsPosteriorMarginalType"
							label: ""
							values: ["central", "HPD", "custom","support"]
							id: plotsPosteriorMarginalType
						}
					}

					Group
					{
						columns: 2
						CIField
						{
							visible: plotsPosteriorMarginalType.currentText == "central" |
									 plotsPosteriorMarginalType.currentText == "HPD"
							enabled: plotsPosteriorMarginalCI.checked
							name: "plotsPosteriorMarginalCoverage"
							label: qsTr("probability")
							fieldWidth: 40
							defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
						}

						DoubleField
						{
							visible: plotsPosteriorMarginalType.currentText == "custom"
							enabled: plotsPosteriorMarginalCI.checked
							name: "plotsPosteriorMarginalLower"
							label: qsTr("lower")
							id: plotsMarginalPosteriorLower
							fieldWidth: 50
							defaultValue: 0.25; min: 0; max: plotsPosteriorMarginalUpper.value; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPosteriorMarginalType.currentText == "custom"
							enabled: plotsPosteriorMarginalCI.checked
							name: "plotsPosteriorMarginalUpper"
							label: qsTr("upper")
							id: plotsPosteriorMarginalUpper
							fieldWidth: 50
							defaultValue: 0.75; min: plotsPosteriorMarginalLower.value; max: 1; inclusive: JASP.MinMax
						}

						DoubleField
						{
							visible: plotsPosteriorMarginalType.currentText == "support"
							enabled: plotsPosteriorMarginalCI.checked
							name: "plotsPosteriorMarginalBF"
							label: qsTr("BF")
							fieldWidth: 50
							defaultValue: 1; min: 0; inclusive: JASP.None
						}
					}					


				}

			}

		}


		CheckBox
		{
			name: "plotsBoth"
			label: qsTr("Prior and posterior distribution")
			checked: false

			RadioButtonGroup
			{
				name: "plotsBothType"
				RadioButton
				{
					checked: true
					value: "conditional"
					label: qsTr("Conditional")
				}

				RadioButton
				{ 
					value: "joint";	
					label: qsTr("Joint")	
				}

				RadioButton
				{ 
					value: "marginal";	
					label: qsTr("Marginal")	
				}

			}

			CheckBox{name: "plotsBothSampleProportion"; label: qsTr("Sample proportion"); checked: false}
		}

	}

	Section
	{
		expanded: false
		title: qsTr("Sequential analysis")
		enabled: dataTypeB.checked || dataTypeC.checked

		CheckBox
		{
			name: "plotsIterative"
			label: qsTr("Test results")
			checked: false

			RadioButtonGroup
			{
				name: "plotsIterativeType"
				RadioButton { value: "conditional";		label: qsTr("Conditional"); checked: true}
				RadioButton { value: "joint";			label: qsTr("Joint")}
				RadioButton { value: "marginal";		label: qsTr("Normalized")}
				RadioButton 
				{
					value: "BF"
					label: qsTr("Bayes factor")
					
					DropDown
						{
						name: "BF_comparison"
						label: qsTr("Against")
						indexDefaultValue: 0
						source: "priors"
					}

					CheckBox
					{
						name: "BF_log"
						label: qsTr("log(BF)")
						checked: false
					}

				}
			}

			CheckBox
			{
				name:  "plotsIterativeUpdatingTable"
				label: qsTr("Updating table")
			}

		}

	}

	Section
	{
		expanded: false
		title: qsTr("Posterior prediction")

		Group
		{
			IntegerField
			{
				name: "predictionN"
				label: qsTr("Future observations")
				id: predictionN
				min: 1
				defaultValue: 1
			}

			CheckBox
			{
				name: "predictionTable"
				label: qsTr("Summary")
			}


			Group
			{
				title: qsTr("Plots")

				DropDown
				{
					name: "colorPalettePrediction"
					label: qsTr("Color palette")
					indexDefaultValue: 0
					values:
						[
						{ label: qsTr("Colorblind"),		value: "colorblind"		},
						{ label: qsTr("Colorblind Alt."),	value: "colorblind3"	},
						{ label: qsTr("Viridis"),			value: "viridis"		},
						{ label: qsTr("ggplot2"),			value: "ggplot2"		},
						{ label: qsTr("Gray"),				value: "gray"			}
						]
				}

				CheckBox
				{
					name: "plotsPredictionsPost"; label: qsTr("Posterior predictive distribution"); checked: false	;
					RadioButtonGroup
					{
						name: "plotsPredictionPostType"
						RadioButton
						{
							value: "conditional"
							label: qsTr("Conditional")
							checked: true

							CheckBox
							{
								name: "plotsPredictionPostCI"
								label: qsTr("CI")
								id: plotsPredictionPostCI
								childrenOnSameRow: true

								DropDown
								{
									visible: plotsPredictionPostCI.checked
									name: "plotsPredictionPostTypeCI"
									label: ""
									values: ["central", "HPD", "custom"]
									id: plotsPredictionPostTypeCI
								}
							}

							Group
							{
								columns: 2

								CIField
								{
									visible: plotsPredictionPostTypeCI.currentText == "central" |
											 plotsPredictionPostTypeCI.currentText == "HPD"
									enabled: plotsPredictionPostCI.checked
									name: "plotsPredictionPostCoverage"
									label: qsTr("probability")
									fieldWidth: 40
									defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
								}

								IntegerField
								{
									visible: plotsPredictionPostTypeCI.currentText == "custom"
									enabled: plotsPredictionPostCI.checked
									name: "plotsPredictionPostLower"
									label: qsTr("lower")
									id: plotsPredictionPostLower
									fieldWidth: 50
									defaultValue: 0; min: 0; max: plotsPredictionPostUpper.value; inclusive: JASP.MinMax
								}

								IntegerField
								{
									visible: plotsPredictionPostTypeCI.currentText == "custom"
									enabled: plotsPredictionPostCI.checked
									name: "plotsPredictionPostUpper"
									label: qsTr("upper")
									id: plotsPredictionPostUpper
									fieldWidth: 50
									defaultValue: 1
									min: plotsPredictionPostLower.value; inclusive: JASP.MinMax
								}

							}
						}

						RadioButton 
						{
							value: "joint"
						 	label: qsTr("Joint")

							RadioButtonGroup
							{
								name: "plotsPredictionPostJointType"	

								RadioButton
								{
									value: "overlying"
						 			label: qsTr("Overlying")
									checked: true
								}

								RadioButton
								{
									value: "stacked"
						 			label: qsTr("Stacked")	
								}	

							}
					
						}

						RadioButton 
						{
							value: "marginal";	
							label: qsTr("Marginal")	
					
							CheckBox
							{
								name: "plotsPredictionPostMarginalCI"
								label: qsTr("CI")
								id: plotsPredictionPostMarginalCI
								childrenOnSameRow: true

								DropDown
								{
									name: "plotsPredictionPostMarginalTypeCI"
									label: ""
									values: ["central", "HPD", "custom"]
									id: plotsPredictionPostMarginalTypeCI
								}
							}

							Group
							{
								columns: 2
								CIField
								{
									visible: plotsPredictionPostMarginalTypeCI.currentText == "central" |
											 plotsPredictionPostMarginalTypeCI.currentText == "HPD"
									enabled: plotsPredictionPostMarginalCI.checked
									name: "plotsPredictionPostMarginalCoverage"
									label: qsTr("probability")
									fieldWidth: 40
									defaultValue: 95; min: 0; max: 100; inclusive: JASP.MaxOnly
								}

								DoubleField
								{
									visible: plotsPredictionPostMarginalTypeCI.currentText == "custom"
									enabled: plotsPredictionPostMarginalCI.checked
									name: "plotsPredictionPostMarginalLower"
									label: qsTr("lower")
									id: plotsMarginalPredictionPostLower
									fieldWidth: 50
									defaultValue: 0; min: 0; max: plotsPredictionPostMarginalUpper.value; inclusive: JASP.MinMax
								}

								DoubleField
								{
									visible: plotsPredictionPostMarginalTypeCI.currentText == "custom"
									enabled: plotsPredictionPostMarginalCI.checked
									name: "plotsPredictionPostMarginalUpper"
									label: qsTr("upper")
									id: plotsPredictionPostMarginalUpper
									fieldWidth: 50
									defaultValue: 1; min: plotsPredictionPostMarginalLower.value; inclusive: JASP.MinOnly
								}
							}	
						}

						CheckBox{ name: "predictionPostPlotProp"; label: qsTr("Show sample proportions")}
					}

				}
			}
		}
	}
}
