# Sequencing_results_analysis_of_CRISPR-cas9_screen
 Next-generation sequencing and analysis in "Genome-wide CRISPR-cas9 screen in human cell line to study cell surface components mediating LCT toxins internalization."
 
>  a.	To align and count sgRNAs in raw sequencing files, two perl scripts **total_numbers_from_fq_file.pl** and **combine_a_b.pl** were wrote. And reference GeCKO2 sgRNA library files (**human_geckov2_library_a.csv** and **human_geckov2_library_b.csv**) were prepared.    
>  b.	3’ and 5’ sequencing primers:
> - i. 3’ sequencing primer:    
> - 5’-AATGGACTATCATATGCTTACCGTAACTTGAAAGTATTTCGATTTCTTGGCTTTATATATCTTGTGGAAAGGACGAAACACCG-3’    
> - ii.	5’ sequencing primer:    
> - 5’- GTTTTAGAGCTAGAAATAGCAAGTTAAAATAAGGCTAGTCCGTTATCAACTTGAAAAAGTGGCACCGAGTCGGTGCTTTTTTA-3’


> c.	Raw sequencing reads are trimed down to the 20 nucleotide sgRNA sequence by \[cutadapt\] (removing the rest of sequencing primers) and two trimmed_raw_reads.fq.gz files are generated.
> d.	The script called **total_numbers_from_fq_file.pl** will align trimmed raw sequencing reads to **human_geckov2_library_a.csv** and **human_geckov2_library_b.csv** files and generate count files of the number of trimmed sequencing reads that align with the **human_geckov2_library_a.csv** or **human_geckov2_library_b.csv** files. To launch the script, use the following bash command on the terminal:   
> `perl total_numbers_from_fq_file.pl trimmed_raw_reads1.fq.gz trimmed_raw_reads2.fq.gz  STEP1_OUTPUTDIR`   
> e.	The script called **combine_a_b.pl** will combine a_library_count and b_library_count files generated by last step. The output file can be opened by Microsoft Excel. To do that, execute the following bash command:   
> `perl combine_a_b.pl -i1 STEP1_OUTPUTDIR -o1 STEP2_OUTPUTDIR`   
> f.	Further data analysis considerations including exclusion of sgRNAs with low counts, normalization and statistical analysis.
  
## Pay attention
1. Please **change your directory to Sequencing_results_analysis_of_CRISPR-cas9_screen pakage** otherwise you cannot use this pakage succesfully.
2. STEP1_OUTPUTDIR and STEP2_OUTPUTDIR are **folder paths** which store output files.
3. Check your file designation: trimmed_raw_reads1.fq.gz and trimmed_raw_reads2.fq.gz should be named **start with "A-" or "B-"** otherwise **total_numbers_from_fq_file.pl** will process data incorrectly.  

Finally, thank you for using this pakage!   

![thank you for using this pakage!](https://raw.githubusercontent.com/liuqinghe-007/Sequencing_results_analysis_of_CRISPR-cas9_screen/main/cell_addwatermark.png)   
