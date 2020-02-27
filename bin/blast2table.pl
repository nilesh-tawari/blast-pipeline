#!/usr/bin/perl -w
# Written by Shrinivas Mane on Sept 07, 2017
use strict;
use warnings;
use Bio::SearchIO;
use Getopt::Std;
use vars qw($opt_p $opt_b $opt_e $opt_c $opt_h);
getopts('p:b:e:ch');
my $PERCENT = $opt_p ? $opt_p : 0;
my $BITS    = $opt_b ? $opt_b : 0;
my $EXPECT  = $opt_e ? $opt_e : 1e30;



my $infile = shift or die "Usage: perl $0\n$! " ;

if (defined $opt_h){
	my @header=qw/query_id q_length subject_id subj_length pct_identity aln_length aln_length_pct n_of_mismatches gaps q_start q_end s_start s_end e_value bit_score/;
	push @header,"description" if defined $opt_c;
	print join("\t", @header),"\n";
}




my $in = Bio::SearchIO->new(-format => 'blast', -file => $infile);
while ( my $result = $in->next_result ) {
	# the name of the query sequence
   	#print $result->query_name , "\t";
	#print $result->query_length,"\n";
	if ( $result->num_hits > 0 ){
		my $count = 0;
		while (my $hit = $result->next_hit) {
			while (my $hsp = $hit->next_hsp) {
				return if $hsp->percent_identity  < $PERCENT;
    			return if $hit->bits     < $BITS;
    			return if $hit->significance   > $EXPECT;
    			if (defined $opt_c){
    				print $result->query_name,"\t";
    				print $result->query_length,"\t";
					print $hit->accession,"\t";
					print $hit->length,"\t";
					print sprintf("%.2f", $hsp->percent_identity),"\t";
					print $hsp->hsp_length,"\t"; # hit length
					print sprintf("%.2f", 100*$hsp->hsp_length/$result->query_length),"\t";
					print $hsp->hsp_length-($hsp->frac_identical * $hsp->hsp_length) - $hsp->gaps(),"\t"; # mismatches
					print $hsp->gaps,"\t"; # gaps
					print $hsp->start('query') , "\t" ;
					print $hsp->end('query'), "\t";
					print $hsp->start('hit') , "\t" ;
					print $hsp->end('hit'), "\t";
					print $hit->significance,"\t";
					print $hit->bits,"\t";
					#print $hit->description,"\n";
					print $result->query_description,"\n";
    			}else{
    				print $result->query_name,"\t";
					print $hit->accession,"\t";
					print sprintf("%.2f", $hsp->percent_identity),"\t";
					print $hsp->hsp_length,"\t"; # hit length
					print $hsp->hsp_length-($hsp->frac_identical * $hsp->hsp_length) - $hsp->gaps(),"\t"; # mismatches
					print $hsp->gaps(),"\t"; # gaps
					print $hsp->start('query') , "\t" ;
					print $hsp->end('query'), "\t";
					print $hsp->start('hit') , "\t" ;
					print $hsp->end('hit'), "\t";
					print $hit->significance,"\t";
					print $hit->bits,"\n";
					
    			}
				
			}
		}
		
	}
}
