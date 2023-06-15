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

import requests

# Function to perform the substitutions
def perform_substitutions(number):
    if number == '0':
        return '0 0'
    elif number == '1':
        return '1 1'
    elif number == '2':
        return '0 1'
    elif number == '-':
        return '-9 -9'
    else:
        return 'Invalid number: ' + number

# File path to be uploaded
file_path = "/path/to/file.txt"

# Upload server URL
upload_url = "http://example.com/upload"

# Read the file contents
with open(file_path, 'r') as file:
    file_contents = file.read()

# Perform the substitutions
substituted_contents = ' '.join(perform_substitutions(number) for number in file_contents.split())

# Upload the substituted contents
files = {'file': open(file_path, 'rb')}
response = requests.post(upload_url, files=files)

# Check if the upload was successful
if response.status_code == 200:
    # Display the substituted contents
    print("Substituted file contents:", substituted_contents)
else:
    print("File upload failed.")
