#' Perform LD clumping on SNP data
#'
#' Uses PLINK clumping method, where SNPs in LD within a particular window will be pruned. The SNP with the lowest p-value is retained.
#'
#' @md
#' @param dat Output from [`format_data`]. Must have a SNP name column (SNP), SNP chromosome column (chr_name), SNP position column (chrom_start). If id.exposure or pval.exposure not present they will be generated.
#' @param clump_kb Clumping window, default is `10000`.
#' @param clump_r2 Clumping r2 cutoff. Note that this default value has recently changed from `0.01` to `0.001`.
#' @param clump_p1 Clumping sig level for index SNPs, default is `1`.
#' @param clump_p2 Clumping sig level for secondary SNPs, default is `1`.
#' @param pop Super-population to use as reference panel. Default = "EUR". Options are EUR, SAS, EAS, AFR, AMR
#'
#' @export
#' @return Data frame
clump_data <- function(dat, clump_kb=10000, clump_r2=0.001, clump_p1=1, clump_p2=1, pop="EUR")
{
	# .Deprecated("ieugwasr::ld_clump()")

	if(missing(clump_r2))
	{
		message("Warning: since v0.4.2 the default r2 value for clumping has changed from 0.01 to 0.001")
	}
	if(!is.data.frame(dat))
	{
		stop("Expecting data frame returned from format_data")
	}

	if(! "pval.exposure" %in% names(dat))
	{
		dat$pval.exposure <- 0.99
	}

	if(! "id.exposure" %in% names(dat))
	{
		dat$id.exposure <- random_string(1)
	}

	d <- data.frame(rsid=dat$SNP, pval=dat$pval.exposure, id=dat$id.exposure)
	out <- ieugwasr::ld_clump(d, clump_kb=clump_kb, clump_r2=clump_r2, clump_p=clump_p1, pop=pop)
	keep <- paste(dat$SNP, dat$id.exposure) %in% paste(out$rsid, out$id)
	return(dat[keep, ])
}


#' Get LD matrix for list of SNPs
#'
#' This function takes a list of SNPs and searches for them in 502 European samples from 1000 Genomes phase 3 data.
#' It then creates an LD matrix of r values (signed, and not squared).
#' All LD values are with respect to the major alleles in the 1000G dataset. You can specify whether the allele names are displayed.
#'
#' @param snps List of SNPs.
#' @param with_alleles Whether to append the allele names to the SNP names. The default is `TRUE`.
#' @param pop Super-population to use as reference panel. Default = "EUR". Options are EUR, SAS, EAS, AFR, AMR
#'
#' @export
#' @return Matrix of LD r values
ld_matrix <- function(snps, with_alleles=TRUE, pop="EUR")
{
	# .Deprecated("ieugwasr::ld_matrix()")
	ieugwasr::ld_matrix(variants=snps, with_alleles=with_alleles, pop=pop)
}

