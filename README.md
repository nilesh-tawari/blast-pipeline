# Blast example 

Blast pipeline using Nextflow 

## Get started 

Install Nextflow 

    curl https://get.nextflow.io | bash 

Run the script 

    nextflow run nilesh-tawari/blast-pipeline -with-dag blast-pipeline.png
    nextflow run nilesh-tawari/blast-pipeline -c ~/.nextflow/config-blast --query "example/data/sample*.fa" --db example/blast-db/pdb/tiny -with-report blast-example.html 

## Dependencies 

* Java 8 or later 
* Blast 
* Perl 
