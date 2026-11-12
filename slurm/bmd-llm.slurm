#!/bin/bash
#SBATCH -p gpu-leeburton-pool
#SBATCH --account=power-leeburton-users_v2
#SBATCH --gres=gpu:nvidia_h100_80gb_hbm3:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00
#SBATCH --signal=B:TERM@300
#SBATCH --open-mode=append
#SBATCH --output=logs/bmd-llm-%j.out

ENV=/bmd/bmdguest/envs/bmd-llm
export PATH="$ENV/bin:$PATH"

export HF_HOME=/bmd/bmdguest/projects/bmd-guest/hf_cache
export VLLM_CACHE_ROOT=/bmd/bmdguest/projects/bmd-guest/vllm_cache
mkdir -p "$HF_HOME" "$VLLM_CACHE_ROOT"

$ENV/bin/vllm serve google/gemma-4-26b-a4b-it \
  --quantization fp8 \
  --host 0.0.0.0 \
  --port 8000 \
  --served-model-name gemma-4-26b \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.90 &

VLLM_PID=$!

trap 'echo "Walltime approaching, shutting down"; kill $VLLM_PID; wait $VLLM_PID; scontrol requeue $SLURM_JOB_ID; exit 0' TERM
wait $VLLM_PID
