# Custom Kraken2 Flat Taxonomy Database Builder

This script creates a **Kraken2 database with a flat taxonomy** from a FASTA file without needing NCBI taxonomy or taxid mappings.

Each FASTA sequence is treated as a unique species with a custom taxid assigned starting from a user-defined range.

---

## Features

- No dependency on NCBI taxonomy or `acc_taxid.map`.
- Flat taxonomy: each sequence is its own species.
- Custom taxids assigned starting from a large number (default 9,000,000+).
- Kraken2-compatible FASTA header format.
- Generates necessary taxonomy files (`nodes.dmp`, `names.dmp`) automatically.
- Prepares Kraken2 DB for classification.

---

## Usage

```bash
./custom_kraken2_flat_db.sh <input_fasta> <kraken_db_dir> <starting_taxid>
