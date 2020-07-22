#!/usr/bin/env nextflow

params.query = "$baseDir/example/data/sample.fa"
params.db = "$baseDir/example/blast-db/pdb/tiny"
params.results = "cazy_search"
results_path = "$PWD/$params.results"
params.chunkSize = 100 

db_name = file(params.db).name
db_path = file(params.db).parent
Channel
                    .fromPath(params.query)
		    .splitFasta(by: params.chunkSize, file:true)
                    .set { query_file_ch }
//                    .map { file -> tuple(file.baseName, file) }

process blast {
    // publishDir "$results_path/$query_ID", mode: 'copy'

    input:
    //set query_ID, file(query_File) from query_file_ch
    file 'query.fa' from query_file_ch
    file db_path

    output:
    //set query_ID, file("${query_ID}-blast0.fmt") into blast_to_table_ch
    file 'top_hits' into sequences_ch
    script:
    """
    blastp -db $db_path/$db_name -query query.fa -outfmt 0 > top_hits
    """
}
sequences_ch
    .collectFile(name: params.results)
    .view { file } 
//-> "matching sequences:\n ${file.text}" }

//process blast_to_table {
//    publishDir "$results_path", mode: 'copy'

//    input:
//    set query_ID, file(blast0fmt) from blast_to_table_ch

//    output:
//    set query_ID, file("${query_ID}-cazy_blast.txt")

//    script:
//   """
//    perl ${baseDir}/bin/blast2table.pl -hc ${blast0fmt} > ${query_ID}-cazy_blast.txt
//    """
//}
