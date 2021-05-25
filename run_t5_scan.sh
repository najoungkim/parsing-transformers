#!/bin/bash

#SBATCH --account=cds
#SBATCH --gres=gpu:rtx8000:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=200GB
#SBATCH --time=48:00:00
#SBATCH --array=0
#SBATCH --job-name=t5_scan
#SBATCH --output=t5_scan_%A_%a.out

module purge
module load cuda/11.1.74

python -u /scratch/eo41/parsing-transformers/run_translation.py \
    --benchmark SCAN \
    --model_name_or_path t5-small \
    --use_pretrained_weights True \
    --output_dir out_t5_small_scan_addjump_pre \
    --do_train \
    --do_predict \
    --source_lang en \
    --target_lang en \
    --source_prefix "translate English to English: " \
    --train_file data_scan/add_jump/train.json \
    --test_file data_scan/add_jump/test.json \
    --per_device_train_batch_size 32 \
    --per_device_eval_batch_size 32 \
    --overwrite_output_dir \
    --save_steps 2500000000 \
    --max_target_length 1024 \
    --max_source_length 1024 \
    --num_train_epochs 20 \
    --predict_with_generate

echo "Done"
