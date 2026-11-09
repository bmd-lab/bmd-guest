# bmd-guest

On-cluster LLM service for the BMD Lab.

This repository holds the system prompt, SLURM script, and notes for the always-on assistant that runs under the shared guest account on TAU PowerSLURM.

## Role

The model:
- Helps diagnose VASP/SLURM jobs
- Answers questions about approved bmd-compute workflows
- Summarises papers and patents when given the text
- Drafts GitHub issues for proposed improvements

It does **not** modify calculations or submit jobs except through bmd-compute’s validated interface.

## Current setup

- Model: Gemma 4 26B A4B (Apache 2.0)
- Hardware: one full H100
- Serving: vLLM (OpenAI-compatible endpoint)
- Persistence: self-requeuing SLURM job

## Files

- `system_prompt.txt` — instructions given to the model on every start
- `slurm/bmd-llm.slurm` — job script that launches the service and requeues itself

## Usage

Clone this repo on the cluster, adjust paths in the SLURM script if needed, then:

```bash
sbatch slurm/bmd-llm.slurm
