
awk '{OFS="\t"}{print $F , "\t", FILENAME}' pbccs_results/*txt | grep "Success" | grep "generated" | perl -lane '@Z = split /\s+|,/, $_; print "$Z[5]\t$Z[4]\t$Z[-1]"' | perl -lane '$_ =~ s/\.report\.txt//g; print' | perl -lane '$_ =~ s/%//g; print' |  perl -lane '@Z = split /\/|-/, $_; print "$F[0]\t$F[1]\t$Z[-2]\t$Z[-1]"' > cc2_pass.stats.txt

awk '{OFS="\t"}{print $F , "\t", FILENAME}' pbccs_results/*txt | grep "Success" | grep "Used" | perl -lane '@Z = split /\s+|,/, $_; print "$Z[6]\t$Z[5]\t$Z[4]\t$Z[-1]"' | perl -lane '$_ =~ s/\.report\.txt//g; print' | perl -lane '$_ =~ s/%//g; print' |  perl -lane '@Z = split /\/|-/, $_; print "$F[0]\t$F[1]\t$Z[-2]\t$Z[-1]"' > subreads_pass.stats.txt


