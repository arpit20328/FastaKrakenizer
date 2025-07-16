# 🧬 FastaKrakenizer
This tool (bash script) describes how to make custom kraken2 index only from a fasta reference file without requierment of  (`names.dmp`) or  (`nodes.dmp`)  or  (`accession_list.txt`).

Further it postprocess a Kraken2 classification report by replacing the **TaxID column** with actual species or sequence names using a custom taxonomy (`names.dmp`) file.

---

## 📄 Importance of This tool 

Kraken2 reports classification results per taxon using **TaxIDs** (typically in column 5). If you're using a **custom Kraken2 database** (e.g., built from a FASTA of specific bacterial or fungal genes), these taxids may not be informative by themselves.

To improve readability, this pipeline maps those taxids back to the **original FASTA headers or species names** using the `names.dmp` file.

---

## 📁 Required Files

1. **Kraken2 Report (`kraken_report.txt`)**  
   This is the default output of Kraken2. Each line typically includes:
   - Percentage of reads
   - Number of reads assigned
   - Number of reads directly assigned
   - Taxonomic rank (e.g. `S` for species)
   - TaxID
   - (optional) blank column or name if available

2. **names.dmp**  
   A custom taxonomy file created during Kraken2 database construction. It links TaxIDs to species names or FASTA headers. Each entry typically looks like:


## Usage

bash custom_kraken2_flat_db.sh

## Sample Output 

| %Reads | #Reads | #DirectReads | Rank | TaxonName           |
| ------ | ------ | ------------ | ---- | ------------------- |
| 60.10  | 60100  | 58000        | S    | Klebsiella\_plasmid |
| 25.40  | 25400  | 25200        | S    | Ecoli\_ARG\_Gene    |
| 10.00  | 10000  | 9900         | S    | Salmonella\_Isolate |
| 4.50   | 4500   | 4400         | U    | unclassified        |

