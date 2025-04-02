# Artifact Submission Template

The submission is done in two parts: metadata to provide in HotCRP, and an artifact description to provide in the [DARTS format](https://drops.dagstuhl.de/entities/journal/DARTS#author).

## Metadata to provide during artifact submission in HotCRP

**No need to provide them again in the submission!**

- Title of the accepted paper
- PDF of the accepted paper
- OS and resource (mandatory: CPU, memory, disk, optional: GPU) used by the authors to run the artifact
- Precise estimation of the required hardware resources for evaluation. In case the evaluation takes multiple days or requires huge resources, please provide a scaled-down evaluation.
- Known compatibility issues of the container/VM.
- Which badges do you claim for your artifact? Functional? Reusable?
- Available badge will be awarded automatically for artifacts submitted to [DARTS](https://drops.dagstuhl.de/opus/institut_darts.php).

## Artifact description

:warning: Please provide this description as a PDF file following the [DARTS template](https://drops.dagstuhl.de/entities/journal/DARTS#author). We add additional guidance for the various mandatory parts of the DARTS description.

### Scope

This additional guidance only applies if you are claiming a functional/reusable badge.

Please quote/reference **all** experimental claims made in the paper.

### Content

Please list for each distinct component of your artifact:

- type of artifact (data, code, proof, etc.);
- format (e.g., CSV, source code, binary, etc.);
- location in the container/VM.

#### If you are claiming the reusable badge

If some parts of your artifacts contains software:

- is your implementation open-source?
- how to recompile the software?

If you use benchmarks: are the benchmarks public and open-source?

Please list any reuse scenarios that you envision for your artifact, i.e., state how the artifact can be reused or repurposed beyond its role in the submitted paper. Example:

> “The implementation can easily be modified to use a different algorithm than the one described in section 4.1 of our paper by implementing a corresponding module. We provide an interface specification in ...”

### Getting

Please add a quick-start guide, describing how reviewers can check the artifact's integrity and basic functionality during the kick-the-tires phase.

### Platforms

Please specify:
- OS and resource (mandatory: CPU, memory, disk, optional: GPU) used by the authors to run the artifact
- precise estimation of the required hardware resources for evaluation.
- Known compatibility issues of the container/VM.

### Appendix

For **all** experimental claims made in the paper, please explain how this claim can be reproduced with the artifact

For example: “The data in table 1 can be obtained by running script ‘generate_table1.sh’”

Please note:

- we highly advise authors to provide a push-button evaluation (cf. call for artifacts);
- only artifacts allowing reproduction of all experimental claims will receive the functional badge.
