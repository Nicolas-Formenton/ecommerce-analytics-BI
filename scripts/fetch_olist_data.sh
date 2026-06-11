#!/bin/bash
set -e

echo "Downloading Olist Brazilian E-Commerce Dataset..."
kaggle datasets download -d olistbr/brazilian-ecommerce -p data/raw/ --unzip

echo "Done! Files saved to data/raw/"
ls -la data/raw/
