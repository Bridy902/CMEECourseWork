import sys
import pickle

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

def find_best_alignments(s1, s2):
    """Find all the best alignments for two sequences."""
    best_alignments = []
    my_best_score = -1

    for i in range(len(s1)):
        matched, score = calculate_score(s1, s2, i)
        if score > my_best_score:
            best_alignments = [("." * i + s2, s1)]  # Start a new list of best alignments
            my_best_score = score
        elif score == my_best_score:
            best_alignments.append(("." * i + s2, s1))  # Add to existing best alignments

    return best_alignments, my_best_score

def main():
    if len(sys.argv) != 3:
        print("Usage: python align_seqs_better.py <407228326.fasta> <407228412.fasta>")
        sys.exit(1)

    # Read sequences from the provided fasta files
    seq1 = read_fasta(sys.argv[1])
    seq2 = read_fasta(sys.argv[2])

    # Assign longer and shorter sequences
    s1, s2 = assign_sequences(seq1, seq2)

    # Find the best alignments
    best_alignments, best_score = find_best_alignments(s1, s2)

    # Save the results using pickle
    with open('best_alignments.pkl', 'wb') as output_file:
        pickle.dump((best_alignments, best_score), output_file)

    # Output the results to the console
    print(f"Best Score: {best_score}")
    for alignment in best_alignments:
        print("Alignment:")
        print(alignment[0])
        print(alignment[1])
        print()

if __name__ == "__main__":
    main()
