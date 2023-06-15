#OBJECTIVE:
#Convert the dart format to structure format, to be used in programs such as Structure and Bayescan.


#DART FORMAT: 		
#		0 = reference homozygote 
#		1 = alternative homozygote 
#		2 = heterozygote
#	- = missing data


#STRUCTURE FORMAT:	
#		0  0 = reference homozygote 
#		1  1 = alternative homozygote 
#		0  1 = heterozygote		       
#	       -9 -9 = missing data

#Think of alleles as frequencies, so the most frequent allele is considered the reference allele.
#For example, if at a locus x, there is a SNP where 80% of the population has a G allele and the remaining 20% has a T allele, the individuals can be classified as:
#Reference homozygotes with G alleles on both copies
#Alternative homozygotes with T alleles on both copies
#Heterozygotes with G allele on one copy and T allele on the otheror the data can be missing

#!/bin/bash

# Function to perform the substitutions
perform_substitutions() {
  case "$1" in
    0)
      echo "0 0"
      ;;
    1)
      echo "1 1"
      ;;
    2)
      echo "0 1"
      ;;
    -)
      echo "-9 -9"
      ;;
    *)
      echo "Invalid number: $1"
      ;;
  esac
}

# File path to be uploaded
file_path="/path/to/file.txt"

# Upload server URL
upload_url="http://example.com/upload"

# Read the file contents
file_contents=$(cat "$file_path")

# Perform the substitutions
substituted_contents=""
for number in $file_contents; do
  substituted_number=$(perform_substitutions "$number")
  substituted_contents+=" $substituted_number"
done

# Upload the substituted contents to the server
response=$(curl -X POST -F "file=@$file_path" -F "substituted_contents=$substituted_contents" "$upload_url")

# Check if the upload was successful
if [[ $response == "Upload successful" ]]; then
  echo "Substituted file contents uploaded successfully."
else
  echo "Failed to upload substituted file."
fi
