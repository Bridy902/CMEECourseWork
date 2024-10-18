birds = ( 
    ('Passerculus sandwichensis', 'Savannah sparrow', 18.7),
    ('Delichon urbica', 'House martin', 19),
    ('Junco phaeonotus', 'Yellow-eyed junco', 19.5),
    ('Junco hyemalis', 'Dark-eyed junco', 19.6),
    ('Tachycineata bicolor', 'Tree swallow', 20.2),
)

# List comprehensions
latin_names = [bird[0] for bird in birds]
common_names = [bird[1] for bird in birds]
mean_body_masses = [bird[2] for bird in birds]

print("Latin names:", latin_names)
print("Common names:", common_names)
print("Mean body masses:", mean_body_masses)

# Conventional loops
latin_names_loop = []
common_names_loop = []
mean_body_masses_loop = []

for bird in birds:
    latin_names_loop.append(bird[0])
    common_names_loop.append(bird[1])
    mean_body_masses_loop.append(bird[2])

print("Latin names (loop):", latin_names_loop)
print("Common names (loop):", common_names_loop)
print("Mean body masses (loop):", mean_body_masses_loop)

 