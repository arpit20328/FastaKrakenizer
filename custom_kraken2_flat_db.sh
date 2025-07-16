#!/bin/bash
set -euo pipefail

if [ $# -ne 3 ]; then
    echo "Usage: $0 <input_fasta> <kraken_db_dir> <starting_taxid>"
    echo "Example: $0 filtered_library.fna kraken_custom_flat 9000000"
    exit 1
fi

INPUT_FASTA=$1
KRAKEN_DB=$2
TAXID_START=$3

WORKDIR=$(pwd)

echo "[1/7] Extracting headers and assigning taxids..."
grep '^>' "$INPUT_FASTA" | sed 's/^>//' > fasta_headers.txt

echo "[2/7] Creating nodes.dmp..."
awk -v taxid_start=$TAXID_START 'BEGIN {OFS="\t|\t"}
{
    taxid = taxid_start + NR;
    print taxid, "1", "species", "", "", "", "", "", "", "", "", "", "", "", "", ""
}' fasta_headers.txt > nodes.dmp

echo "[3/7] Creating names.dmp..."
awk -v taxid_start=$TAXID_START 'BEGIN {OFS="\t|\t"}
{
    taxid = taxid_start + NR;
    print taxid, $0, $0, "", "scientific name"
}' fasta_headers.txt > names.dmp

echo "[4/7] Rewriting FASTA headers to Kraken2 format..."
awk -v taxid_start=$TAXID_START '
BEGIN { i = 0 }
{
    if ($0 ~ /^>/) {
        i++
        header = substr($0, 2)
        print ">kraken:taxid|" taxid_start + i " " header
    } else {
        print
    }
}
' "$INPUT_FASTA" > fixed_flat_library.fna

echo "[5/7] Setting up Kraken2 DB directory..."
mkdir -p "$KRAKEN_DB"/taxonomy
cp nodes.dmp names.dmp "$KRAKEN_DB"/taxonomy/
touch "$KRAKEN_DB"/taxonomy/merged.dmp
touch "$KRAKEN_DB"/taxonomy/delnodes.dmp
touch "$KRAKEN_DB"/taxonomy/acc_taxid.map

echo "[6/7] Adding sequences to Kraken2 DB..."
kraken2-build --add-to-library fixed_flat_library.fna --db "$KRAKEN_DB"

echo "[7/7] Building Kraken2 DB..."
kraken2-build --build --db "$KRAKEN_DB"

echo "Done. Your Kraken2 flat taxonomy DB is ready at: $KRAKEN_DB"
echo "Run classification with:"
echo "  kraken2 --db $KRAKEN_DB --report report.txt --output output.txt your_reads.fastq"
