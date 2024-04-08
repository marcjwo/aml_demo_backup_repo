project_name: "demo_aml_ai"


## INSTRUCTION: COMMENT IN THE LINE REQUIRED DEPENDING ON WHAT DATASET TO BE USED. FIRST ROW FOR OLD DATASET, SECOND ROW FOR NEW DATASET


constant: input_dataset {
  # value: "public_dataset" ## old dataset
  value: "Input_New" ## new dataset
}

constant: output_dataset {
  # value: "outputs" ## old dataset
  value: "Output_new" ## new dataset
}

# remote_dependency: gauge {
#   url: "https://github.com/looker-open-source/viz-gauge-marketplace.git"
#   ref: "master"
# }

# remote_dependency: venn_diagram {
#   url: "https://github.com/gcalvo1/looker-custom-visualizations/tree/master/venn_diagram"
# }
