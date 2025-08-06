#!/bin/bash
set -euo pipefail

if [ $# -lt 3 ] || [ $# -gt 5 ]; then
    echo "Usage: $0 <input_fasta> <kraken_db_dir> <starting_taxid> [<kraken_report>] [<threads>]"
    echo "Example: $0 filtered_library.fna kraken_custom_flat 9000000 report.txt 8"
    echo
    echo "If <kraken_report> is provided, script will also convert taxids to taxon names in that report."
    exit 1
fi

INPUT_FASTA=$1
KRAKEN_DB=$2
TAXID_START=$3
REPORT_FILE="${4:-}"
THREADS="${5:-4}"   # Default to 4 threads if not specified

WORKDIR=$(pwd)

echo "[1/9] Extracting headers and assigning taxids..."
grep '^>' "$INPUT_FASTA" | sed 's/^>//' > fasta_headers.txt

echo "[2/9] Creating nodes.dmp..."
awk -v taxid_start=$TAXID_START 'BEGIN {OFS="\t|\t"}
{
    taxid = taxid_start + NR;
    print taxid, "1", "species", "", "", "", "", "", "", "", "", "", "", "", "", ""
}' fasta_headers.txt > nodes.dmp

echo "[3/9] Creating names.dmp..."
awk -v taxid_start=$TAXID_START 'BEGIN {OFS="\t|\t"}
{
    taxid = taxid_start + NR;
    print taxid, $0, $0, "", "scientific name"
}' fasta_headers.txt > names.dmp

echo "[4/9] Rewriting FASTA headers to Kraken2 format..."
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

echo "[5/9] Setting up Kraken2 DB directory..."
mkdir -p "$KRAKEN_DB"/taxonomy
cp nodes.dmp names.dmp "$KRAKEN_DB"/taxonomy/
touch "$KRAKEN_DB"/taxonomy/merged.dmp
touch "$KRAKEN_DB"/taxonomy/delnodes.dmp
touch "$KRAKEN_DB"/taxonomy/acc_taxid.map

echo "[6/9] Adding sequences to Kraken2 DB (threads=$THREADS)..."
kraken2-build --add-to-library fixed_flat_library.fna --db "$KRAKEN_DB" --threads "$THREADS"

echo "[7/9] Building Kraken2 DB (threads=$THREADS)..."
kraken2-build --build --db "$KRAKEN_DB" --threads "$THREADS"

echo "Kraken2 DB build completed: $KRAKEN_DB"

if [ -n "$REPORT_FILE" ]; then
    echo "[8/9] Post-processing Kraken2 report to replace taxids with taxon names..."

    TAXID_TO_NAME="$KRAKEN_DB/taxonomy/taxid_to_name.tsv"
    SORTED_REPORT="report.sorted.txt"
    JOINED="joined.txt"
    OUTPUT_REPORT="report_with_names.txt"

    # Extract taxid-to-name mapping
    awk -F '\t\\|\\t' '{gsub(/\t\\|$/, "", $2); print $1 "\t" $2}' "$KRAKEN_DB/taxonomy/names.dmp" | sort -k1,1 > "$TAXID_TO_NAME"

    # Sort Kraken2 report by 5th column (taxid)
    sort -k5,5 "$REPORT_FILE" > "$SORTED_REPORT"

    # Join on taxid
    join -1 5 -2 1 -t $'\t' "$SORTED_REPORT" "$TAXID_TO_NAME" > "$JOINED"

    # Replace taxid with taxon name, keep other columns same except 5th replaced
    awk -F'\t' '{
      print $2"\t"$3"\t"$4"\t"$5"\t"$7
    }' "$JOINED" > "$OUTPUT_REPORT"

    # Add unclassified lines (taxid=0) if any
    grep -P '\t0\t' "$REPORT_FILE" >> "$OUTPUT_REPORT"

    echo "[9/9] Taxid replacement done. Output saved to $OUTPUT_REPORT"
fi

echo "All done."
