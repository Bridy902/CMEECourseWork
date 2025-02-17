"""
This script processes a tuple of bird data containing Latin names, common names, and masses.
 
It iterates through the data and prints the Latin name, common name, and mass for each bird.
"""

birds = ( 
    ('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
    ('Delichon urbica', 'House martin', 19),
    ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
    ('Junco hyemalis', 'Dark-eyed junco', 19.6),
    ('Tachycineata bicolor', 'Tree swallow', 20.2),
)

# Print details for each bird
for latin_name, common_name, mass in birds:
    print(f"Latin name: {latin_name} Common name: {common_name} Mass: {mass}")
