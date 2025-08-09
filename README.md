# 🧬 FastaKrakenizer

FastaKrakenizer builds a **custom Kraken2 database** from a plain FASTA file — without needing NCBI's `names.dmp`, `nodes.dmp`, or `accession_list.txt`.

It also optionally post-processes a Kraken2 classification report by replacing **TaxIDs** with readable **FASTA header names** using a generated flat taxonomy.

---

## 📄 Why Use This Tool?

Kraken2 reports use TaxIDs (numeric) which are uninformative in custom databases. This tool:

- Creates a **flat taxonomy**, where each FASTA header is treated as its own species.
- Assigns **custom TaxIDs** (e.g. starting from 9000000+).
- Replaces TaxIDs in Kraken2 reports with corresponding species names (FASTA headers).

Ideal for:  
- Simulated reads  
- Plasmids, ARGs, mobile elements  
- Custom isolate genomes

---

## 📁 Required Inputs

1. **FASTA file** — e.g., `custom.fasta`  
2. *(Optional)* **Kraken2 Report (`report.txt`)**

## Prerequisite
1. Kraken2 : Install via conda

```bash

   conda install -c bioconda kraken2

```
2. BBMask : Install via following commands:

```bash
wget https://sourceforge.net/projects/bbmap/files/latest/download -O bbtools.tar.gz
tar -xvzf bbtools.tar.gz
mv bbtools ~/bbtools
echo 'export PATH=$PATH:~/bbtools' >> ~/.bashrc
source ~/.bashrc

```
    
---
## Installation
```bash

git clone https://github.com/arpit20328/FastaKrakenizer.git


```
## 🛠️ Usage

### 🔹 Build Kraken2 DB only:

```bash
bash custom_kraken2_flat_db.sh <input_fasta> <kraken_db_dir> <starting_taxid> [<threads>]

bash custom_kraken2_flat_db.sh custom.fasta kraken_custom_flat 9000000  64

```

---

# Sample Output 

<img width="714" height="397" alt="image" src="https://github.com/user-attachments/assets/a2ca546d-8e5a-4221-baa2-aa32533a6378" />

| Column Index | Meaning                                  | Description                                                                             |
| ------------ | ---------------------------------------- | --------------------------------------------------------------------------------------- |
| 1            | Percentage of reads assigned             | Percentage of total reads classified to this taxon or below it (including descendants). |
| 2            | Number of reads classified to this taxon | Number of reads classified directly to this taxon or its descendants.                   |
| 3            | Number of reads classified directly here | Reads classified exactly to this taxon (not including descendants).                     |
| 4            | Taxonomic rank code                      | Single-letter code indicating taxonomic rank (e.g., `S` = species, `U` = unclassified). |
| 5            | NCBI Taxonomy ID (taxid)                 | Numeric taxonomy identifier assigned by NCBI taxonomy database.                         |
| 6            | Taxon name                               | The scientific name or label for this taxon (e.g., species name, or "unclassified").    |

## Replacing taxid names with Inpur FASTA Headers

If You want to replace the 5th column in a Kraken2 report (or similar file) — which usually contains taxonomic IDs or names — with your input FASTA headers by using the names.dmp file by following command: 

```bash

awk -F '\t' 'NR==FNR { taxid_name[$1]=$3; next } { if ($5 in taxid_name) $5=taxid_name[$5]; print }' names.dmp kraken2_report.txt > kraken2_report_with_names.txt


```

## 📦 Example Kraken2 Index

An example Kraken2 index built using FastaKrakenizer from the complete Homo sapiens genome assembly (T2T-CHM13v2.0) is available at:

🔗 Zenodo Record: https://zenodo.org/records/16459107

## Runtime 

 GCF_009914755.1 (T2T-CHM13v2.0) Index was built in 16m19.733s with 190 CPU Threads

## 📄 License

```text
MIT License

Copyright (c) 2025 Arpit Mathur

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙋 Author & Support

Developed by **Arpit Mathur**, independent researcher.  
📧 Contact: [arpit20328@iiitd.ac.in](mailto:arpit20328@iiitd.ac.in)  

🐛 For bugs, suggestions, or improvements, please open an issue in the **[GitHub Issues](https://github.com/yourusername/FastaKrakenizer/issues)** section.

---
