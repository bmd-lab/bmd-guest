#!/bin/bash
#SBATCH -p gpu-leeburton-pool
#SBATCH --account=power-leeburton-users_v2
#SBATCH --job-name=bmd-llm
#SBATCH --gres=gpu:H100:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=7-00:00:00
#SBATCH --signal=B:TERM@300
#SBATCH --open-mode=append
#SBATCH --output=logs/bmd-llm-%j.out

# Adjust these paths to match your environment
source /path/to/your/conda/or/venv/bin/activate
export HF_HOME=/scratch/bmdguest/hf_cache
export VLLM_CACHE_ROOT=/scratch/bmdguest/vllm_cache

SYSTEM_PROMPT=$(cat system_prompt.txt)

vllm serve google/gemma-4-26b-a4b-it \
  --quantization fp8 \
  --host 0.0.0.0 \
  --port 8000 \
  --served-model-name gemma-4-26b \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.90 \
  --chat-template-content-format openai \
  --default-chat-template-kwargs "{\"system_message\": \"$SYSTEM_PROMPT\"}" &

VLLM_PID=$!

trap 'echo "Walltime approaching, shutting down"; kill $VLLM_PID; wait $VLLM_PID; scontrol requeue $SLURM_JOB_ID; exit 0' TERM

wait $VLLM_PID
