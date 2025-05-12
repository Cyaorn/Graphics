import sys
import random

# By default generates random purple colors for each pixel

def main(width=500, height=500, scale=255):
    out = ''
    for i in range(width):
        for j in range(height):
            for k in range(3):
                if k == 2:
                    out += str(scale) + ' '
                elif k == 0:
                    out += str(scale // 2) + ' '
                else:
                    out += str(random.randrange(scale)) + ' '
    with open('image.ppm', 'w') as w:
        w.write('P3\n' + str(width) + ' ' + str(height) + '\n' + str(scale) + '\n' + out)

args = sys.argv
if len(args) == 4:
    main(int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3]))
elif len(args) == 3:
    main(int(sys.argv[1]), int(sys.argv[2]))
elif len(args) == 2:
    main(500, 500, int(sys.argv[1]))
else:
    main()