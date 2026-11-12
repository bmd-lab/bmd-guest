# bmd-guest

On-cluster LLM service for the BMD Lab.

Runs Gemma 4 26B A4B (Apache 2.0) under vLLM on one full H100 as a long-lived, self-requeuing SLURM job. Provides an OpenAI-compatible endpoint for diagnosis, standards questions, paper summaries, and issue drafting.

## Current baseline

- Model: `google/gemma-4-26b-a4b-it` (FP8)
- Environment: `/bmd/bmdguest/envs/bmd-llm`
- Endpoint: port 8000 on the compute node
- System prompt: supplied by the client in the `system` message (see `system_prompt.txt`)

## Quick start

```bash
cd /bmd/bmdguest/projects/bmd-guest
sbatch slurm/bmd-llm.slurm
