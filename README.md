# Deep learning kaggle03 (學號409504010)
* step 1: 下載所需資料

1. 下載GitHub專案
```
git clone https://github.com/s87315teve/deep_learning_HW3.git
git clone https://github.com/tloen/alpaca-lora.git
```
2. 到[Kaggle](https://www.kaggle.com/competitions/deep-learningnycu-2023-large-language-models/data?select=lora-alpaca)下載lora-alpaca資料夾，並將裡面的檔案全部移動到alpaca-lora/裡面
* step 2: 安裝環境
```
cd alpaca-lora
conda activate llama
conda create --name llama python=3.9
conda install cudatoolkit
pip install -r requirements.txt
pip install scipy
```
* step 3: 資料前處理

移動到deep_learning_HW3/
執行test_set_process.py把AI1000.xlsx變成answr.josn(測試資料)
```
python train_set_process.py
```
執行train_set_process.py把AI.xlsx變成data.json(訓練資料)
```
python test_set_process.py
```
* step 4: 把檔案移動到指定位置

1. 把data.json移動到alpaca-lora/train_data/裡面(需自己建立train_data資料夾)
2. 把answr.josn移動到alpaca-lora/裡面
3. 把train.sh移動到alpaca-lora/裡面
4. 把generate.py移動到alpaca-lora/裡面 (取代原本的檔案)
5. 把finetune.py移動到alpaca-lora/裡面 (取代原本的檔案)

* step 5: 訓練模型

移動到alpaca-lora/
```
bash train.sh
```
* step 6: 輸出答案
```
python generate.py --load_8bit --base_model 'decapoda-research/llama-7b-hf'  --lora_weights './lora-alpaca'
```

---
* 結果與討論

public score: 0.46
private score: 0.49714

本次模型使用RTX3090來進行訓練，最後finetune之參數為：
batch_size 256
micro_batch_size 1 
num_epochs 4 
learning_rate 1e-4 
cutoff_len 1600 
val_set_size 1000 
lora_r 8 
lora_alpha 16 
lora_dropout 0.1

&emsp;&emsp;其中比較需要注意的是epoch、learning rate、dropout。

&emsp;&emsp;首先是epoch，即使是用到RTX3090，訓練一個epoch也大概需要用約4小時，非常花費時間，而且當epoch不夠的時候會發現訓練出來的模型沒辦法穩定輸出1\~4的數字，造成答案的準確度非常低(大約0.25)，因此為了確保輸出結果保持在1\~4，我有在generate.py中增加判斷式，如果發現輸出的值不是1\~4的話會隨機生成1\~4作為結果，而最終epoch=4的模型是可以穩定輸出1\~4的，不需要隨機。

&emsp;&emsp;接下來是learning rate，因為本次主要做的事情是finetune，所以learning rate不需要太大，如果把learning rate調大的話反而會讓模型更難收斂，因此我最後採用的是1e-4。

&emsp;&emsp;最後是dropout，原本預設是0.05，但我發現在0.1的情況下模型的結果表現得更不錯，因此最後選擇了0.1。

