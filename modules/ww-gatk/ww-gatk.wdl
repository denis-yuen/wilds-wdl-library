## WILDS WDL module for GATK variant calling and analysis tasks.
## Designed to be a modular component within the WILDS ecosystem that can be used
## independently or integrated with other WILDS workflows.

version 1.0

task create_sequence_dictionary {
  meta {
    author: "Taylor Firman"
    email: "tfirman@fredhutch.org"
    description: "Create a sequence dictionary file from a reference FASTA file"
    url: "https://raw.githubusercontent.com/getwilds/wilds-wdl-library/refs/heads/main/modules/ww-gatk/ww-gatk.wdl"
    outputs: {
        sequence_dict: "Sequence dictionary file (.dict) for the reference genome"
    }
  }

  parameter_meta {
    reference_fasta: "Reference genome FASTA file"
    memory_gb: "Memory allocation in GB"
    cpu_cores: "Number of CPU cores to use"
  }

  input {
    File reference_fasta
    Int memory_gb = 8
    Int cpu_cores = 2
  }

  String dict_basename = basename(basename(reference_fasta, ".fa"), ".fasta")

  command <<<
    set -eo pipefail

    gatk --java-options "-Xms~{memory_gb - 2}g -Xmx~{memory_gb - 1}g" \
      CreateSequenceDictionary \
      -R "~{reference_fasta}" \
      -O "~{dict_basename}.dict" \
      --VERBOSITY WARNING
  >>>

  output {
    File sequence_dict = "~{dict_basename}.dict"
  }

  runtime {
    docker: "getwilds/gatk:4.6.1.0"
    memory: "~{memory_gb} GB"
    cpu: cpu_cores
  }
}
