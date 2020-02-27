#!/usr/bin/env nextflow

params.query = "$baseDir/data/sample.fa"
params.db = "$baseDir/blast-db/pdb/tiny"
params.results = "results"
params.chunkSize = 100 

db_name = file(params.db).name
db_path = file(params.db).parent

Channel
    .fromPath(params.query)
    .splitFasta(by: params.chunkSize)
    .set { fasta }

process blast {

    input:
    file query from fasta
    file db_path

    output:
    file "${outName}.out" into blast_result
    
    script:
    outName = query.baseName
    """
    blastp -db $db_path/$db_name -query ${query} -outfmt 6 > ${outName}.out

    """
}


blast_result
    .collectFile(sort: true, storeDir: params.results)
