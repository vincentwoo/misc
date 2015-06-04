import sys

def longest_common_substring(s1, s2):
   m = [[0] * (1 + len(s2)) for i in xrange(1 + len(s1))]
   longest, x_longest = 0, 0
   for x in xrange(1, 1 + len(s1)):
       for y in xrange(1, 1 + len(s2)):
           if s1[x - 1] == s2[y - 1]:
               m[x][y] = m[x - 1][y - 1] + 1
               if m[x][y] > longest:
                   longest = m[x][y]
                   x_longest = x
           else:
               m[x][y] = 0
   return s1[x_longest - longest: x_longest]


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print "./%s <sequence_file_name.txt> <experiment_file_name.txt> <out_file.txt>" % sys.argv[0]

    sequence_filename = sys.argv[1]
    experiment_filename = sys.argv[2]
    out_filename = sys.argv[3]

    outfile = open(out_filename, 'w+')

    with open(sequence_filename, 'r+') as f: 
        sequence = f.read()

    experiment_file = open(experiment_filename, 'r+')
    for line in experiment_file:
        pattern, num1, num2 = line.split()
        substr = longest_common_substring(pattern, sequence)
        if len(substr) >= 20:
            outfile.write("{pattern}\t{match}\t{num1}\t{num2}\n".format(pattern=pattern, match=substr, num1=num1, num2=num2))
            outfile.flush()
