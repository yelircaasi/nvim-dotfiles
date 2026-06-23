from collections import Counter
from pathlib import Path
import re

config_dir = Path.home() / ".config/nvim"
# seqs = config_dir / "scratch/seqs_local_parsed.txt"
seqs = config_dir / "scratch/seqs_parsed.txt"

pattern = re.compile(r"(?<=\n)[^=\s][^ ]+")
seqs = re.findall(pattern, seqs.read_text())

for k, v in Counter(seqs).most_common():
    if v > 1:
        print(f"{k} {v}")
