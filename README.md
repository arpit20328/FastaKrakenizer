# 🧬 FastaKrakenizer

This tool (a Bash script) builds a **custom Kraken2 index** directly from a FASTA file — without requiring NCBI's `names.dmp`, `nodes.dmp`, or `accession_list.txt`.

It also optionally post-processes a Kraken2 classification report by replacing **TaxID** values with the actual **FASTA headers** using a generated `names.dmp`.

---

## 📄 Why Use This Tool?

Kraken2 reports use **numerical TaxIDs** that may be meaningless when using custom references (e.g. ARGs, plasmids, isolate genomes).

This tool:
- Creates a **flat taxonomy** where each FASTA sequence is treated as a unique species.
- Assigns **custom TaxIDs** (e.g., starting from 9000000).
- Replaces TaxIDs in Kraken2 reports with readable names from your FASTA headers.

---

## 📁 Required Inputs

1. **FASTA file**  
   A file like `custom.fasta`, with headers like `>Klebsiella_plasmid`.

2. **(Optional) Kraken2 Report (`report.txt`)**  
   This is the output of `kraken2 --report`, which this tool can enhance by replacing TaxIDs with species names.

---

## 🛠️ Usage

### 🔹 Build Kraken2 Database (No Report):

```bash
bash custom_kraken2_flat_db.sh custom.fasta kraken_custom_flat 9000000
