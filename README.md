📦 Custom Kraken2 Flat Taxonomy Database Builder
This tool builds a custom Kraken2 database from a FASTA file, assigning each sequence a unique taxonomic ID and treating each one as a separate species — without using NCBI taxonomy files or taxid maps.

It also optionally processes a Kraken2 classification report to replace taxids with human-readable names derived from the FASTA headers.

✅ Features
No need for acc_taxid.map or NCBI taxonomy downloads

Flat taxonomy: each FASTA entry becomes a distinct species

Taxonomic IDs start from a user-specified range (e.g., 9000000+)

FASTA is automatically rewritten to match Kraken2 format

Kraken2 database is fully functional and ready to classify reads

Optional: replaces taxids in Kraken2 report with real names from headers

🛠️ Requirements
kraken2 must be installed and in your PATH

Bash shell (Linux/macOS)

Input FASTA file with unique headers

🚀 Usage
bash
Copy
Edit
./custom_kraken2_flat_db.sh <input_fasta> <kraken_db_dir> <starting_taxid> [<kraken_report>]
Example:
bash
Copy
Edit
./custom_kraken2_flat_db.sh filtered_library.fna kraken_custom_flat 9000000 report.txt
Arguments:
Argument	Description
<input_fasta>	Your multi-sequence FASTA file
<kraken_db_dir>	Output directory for the Kraken2 DB
<starting_taxid>	Starting taxid (e.g., 9000000 to avoid NCBI conflicts)
[kraken_report]	(Optional) Kraken2 report file to post-process (taxid → name)

📂 Output Files
fixed_flat_library.fna – your input FASTA reformatted for Kraken2

kraken_custom_flat/ – folder with full Kraken2 DB

report_with_names.txt – new report where taxids are replaced with FASTA names (if report was provided)

🔁 What Happens Internally
Extracts sequence headers from FASTA

Assigns each a taxid starting from a high number (e.g., 9000000+)

Creates flat nodes.dmp and names.dmp files for Kraken2

Reformats FASTA headers to >kraken:taxid|9000001 original_header

Builds the Kraken2 DB with your custom taxonomy

(Optional) If a Kraken2 report is provided, it:

Replaces 5th column (taxid) with taxon name using names.dmp

Keeps all other columns unchanged

Adds back unclassified lines (taxid = 0)

🧪 Sample Kraken2 Report Before Post-Processing
Copy
Edit
 84.27	235509	91533	S	9000001	sequence_1_header
 15.73	43954	43954	U	0	unclassified
Here, Kraken2 uses raw taxids like 9000001.

✅ Sample Output After Post-Processing
less
Copy
Edit
%Reads	#Reads	#DirectReads	Rank	TaxonName
84.27	235509	91533	S	sequence_1_header
15.73	43954	43954	U	unclassified
The taxid column is now replaced by actual readable names from your FASTA headers (stored in names.dmp).

📌 Notes
Taxonomy is flat — all entries are marked as species under a dummy root (taxid = 1)

Useful for in silico or synthetic genomes, environmental isolates, or controlled simulations

You can later match Kraken2 results easily with your original FASTA entries

🧼 Clean-up (optional)
After database creation, you can remove intermediate files:

bash
Copy
Edit
rm fasta_headers.txt nodes.dmp names.dmp fixed_flat_library.fna
🧑‍💻 Author
Arpit Mathur

Inspired by practical needs in metagenomic simulation and pathogen detection workflows.

