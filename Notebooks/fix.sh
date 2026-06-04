#!/bin/bash
python3 -c "
import json
with open('Copy_of_E03_Intro_to_Control.ipynb', 'r') as f:
    nb = json.load(f)
nb.get('metadata', {}).pop('widgets', None)
with open('Copy_of_E03_Intro_to_Control.ipynb', 'w') as f:
    json.dump(nb, f)
"
