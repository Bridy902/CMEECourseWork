import csv

def assign_sequences(seq1, seq2):
    if len(seq1) >= len(seq2):
        return seq1, seq2
    return seq2, seq1

def calculate_score(s1, s2, startpoint):
    matched = ""
    score = 0
    l1, l2 = len(s1), len(s2)
    
    for i in range(l2):
        if (i + startpoint) < l1:
            if s1[i + startpoint] == s2[i]:
                matched += "*"
                score += 1
            else:
                matched += "-"
    
    return matched, score

def find_best_alignment(s1, s2):
    my_best_align = None
    my_best_score = -1

    for i in range(len(s1)):
        matched, score = calculate_score(s1, s2, i)
        if score > my_best_score:
            my_best_align = "." * i + s2
            my_best_score = score

    return my_best_align, my_best_score

def main():
    # Read sequences from a CSV file
    with open('sequences.csv', 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            seq1 = row['seq1']
            seq2 = row['seq2']
            break  # Only read the first row

    # Assign the longer and shorter sequences
    s1, s2 = assign_sequences(seq1, seq2)

    # Find the best alignment
    best_align, best_score = find_best_alignment(s1, s2)

    # Write the results to a text file
    with open('best_alignment.txt', 'w') as output_file:
        output_file.write("Best Alignment:\n")
        output_file.write(best_align + "\n")
        output_file.write(s1 + "\n")
        output_file.write(f"Best Score: {best_score}\n")

if __name__ == "__main__":
    main()

