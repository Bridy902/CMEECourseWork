taxa = [ 
    ('Myotis lucifugus', 'Chiroptera'),
    ('Gerbillus henleyi', 'Rodentia'),
    ('Peromyscus crinitus', 'Rodentia'),
    ('Mus domesticus', 'Rodentia'),
    ('Cleithrionomys rutilus', 'Rodentia'),
    ('Microgale dobsoni', 'Afrosoricida'),
    ('Microgale talazaci', 'Afrosoricida'),
    ('Lyacon pictus', 'Carnivora'),
    ('Arctocephalus gazella', 'Carnivora'),
    ('Canis lupus', 'Carnivora'),
]

# Populate the dictionary using a loop
taxa_dic = {}

for taxon, order in taxa:
    if order not in taxa_dic:
        taxa_dic[order] = set()
    taxa_dic[order].add(taxon)

# Print the resulting dictionary
for order, taxa_set in taxa_dic.items():
    print(f"'{order}': {taxa_set}")

# Using a dictionary comprehension
taxa_dic_comprehension = {}
for taxon, order in taxa:
    taxa_dic_comprehension.setdefault(order, set()).add(taxon)

# Print the resulting dictionary
for order, taxa_set in taxa_dic_comprehension.items():
    print(f"'{order}': {taxa_set}")

# Printing using a list comprehension for display
print("\n".join([f"'{order}': {taxa_set}" for order, taxa_set in taxa_dic_comprehension.items()]))
