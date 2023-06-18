python finetune.py \
    --base_model 'decapoda-research/llama-7b-hf' \
    --data_path './train_data/data.json' \
    --output_dir './lora-alpaca' \
    --batch_size 256\
    --micro_batch_size 1 \
    --num_epochs 4 \
    --learning_rate 1e-4 \
    --cutoff_len 1600 \
    --val_set_size 1000 \
    --lora_r 8 \
    --lora_alpha 16 \
    --lora_dropout 0.1 \
    --lora_target_modules '[q_proj, k_proj, v_proj, o_proj]' \
    --train_on_inputs \
    --group_by_length \
    --resume_from_checkpoint ./lora-alpaca