#Convert Ipyrad's outfile to the dart format to use in PCA. The required outfile formats are *.ugeno and *vcf, which can be found in the *_outfiles folder where Ipyrad was run. The conversion is done in two steps: first to the dart format, and then using a table model where the dart format will be included as input for PCA. This process is done in RStudio (a script in the CMD folder).

#About ugeno
# Files *.geno & *.u.geno - This is a SNP based format. Each line corresponds to one snp with one column per sample. The value in the sample column indicates the number of copies of the reference allele each individual has. 9 indicates missing data. This format is used by EIGENSTRAT, SMARTPCA, and ADMIXTURE, among other programs.


#!/bin/bash

# Function to perform the conversions
convert_numbers() {
  case "$1" in
    9)
      echo -
      ;;
    0)
      echo 8
      ;;
    1)
      echo 9
      ;;
    2)
      echo 0
      ;;
    8)
      echo 1
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

# Upload the file using curl
response=$(curl -X POST -F "file=@$file_path" "$upload_url")

# Check if the upload was successful
if [[ $response == "Upload successful" ]]; then
  # Read the content of the uploaded file
  file_contents=$(curl -s "$upload_url/$file_path")

  # Perform the substitutions on the numbers
  converted_contents=""
  for number in $file_contents; do
    converted_number=$(convert_numbers "$number")
    converted_contents+=" $converted_number"
  done

  # Display the result
  echo "Converted file content: $converted_contents"
else
  echo "File upload failed."
fi

