import sys

def read_fasta(file_path):
    """Read a FASTA file and return the sequence."""
    with open(file_path, 'r') as file:
        lines = file.readlines()
        sequence = ''.join(line.strip() for line in lines[1:])  # Skip the header
    return sequence

def assign_sequences(seq1, seq2):
    """Assign longer and shorter sequences."""
    if len(seq1) >= len(seq2):
        return seq1, seq2
    return seq2, seq1

def calculate_score(s1, s2, startpoint):
    """Calculate alignment score and generate alignment representation."""
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
    """Find the best alignment for two sequences."""
    my_best_align = None
    my_best_score = -1

    for i in range(len(s1)):
        matched, score = calculate_score(s1, s2, i)
        if score > my_best_score:
            my_best_align = "." * i + s2
            my_best_score = score

    return my_best_align, my_best_score

def main():
    if len(sys.argv) != 3:
        print("Usage: python align_seqs_fasta.py <407228326.fasta> <407228412.fasta>")
        sys.exit(1)

    # Read sequences from the provided fasta files
    seq1 = read_fasta(sys.argv[1])
    seq2 = read_fasta(sys.argv[2])

    # Assign longer and shorter sequences
    s1, s2 = assign_sequences(seq1, seq2)

    # Find the best alignment
    best_align, best_score = find_best_alignment(s1, s2)

    # Output the results
    print("Best Alignment:")
    print(best_align)
    print(s1)
    print(f"Best Score: {best_score}")

if __name__ == "__main__":
    main()
