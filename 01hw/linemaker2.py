def main():
    out = [[[0, 0, 0] for x in range(0, 511)] for y in range(0, 511)]
    for i in range(-255, 255, 5):
        draw_line(out, i, 255, (i * 5) % 255, 0)
        draw_line(out, i, -255, (i * 5) % 255, 0)
    with open('image.ppm', 'w') as w:
        w.write('P3\n511\n511\n255\n')
        for i in range(len(out)):
            for j in range(len(out[i])):
                for k in range(3):
                    w.write(str(out[i][j][k]) + ' ')
    return

def draw_line(ary, x0, y0, x1, y1):
    if x0 > x1:
        draw_line(ary, x1, y1, x0, y0)
    else: 
        delta_y = y1 - y0
        delta_x = x1 - x0
        if abs(delta_y) > abs(delta_x): # steep slope
            if delta_y < 0: # octant 7
                draw_line7(ary, x0, y0, x1, y1)
            else: # octant 2
                draw_line2(ary, x0, y0, x1, y1)
        else: # shallow slope
            if delta_y < 0: # octant 8
                draw_line8(ary, x0, y0, x1, y1)
            else: # octant 1
                draw_line1(ary, x0, y0, x1, y1)
    return
    
def draw_line1(ary, x0, y0, x1, y1):
    x = x0
    y = y0
    A = y1 - y0
    B = x0 - x1
    d = 2 * A + B
    while x <= x1:
        ary[len(ary) // 2 - 1 - y][x + len(ary) // 2 - 1] = [abs(x), abs(y), x * y % 255]
        if d > 0:
            y += 1
            d += 2 * B
        x += 1
        d += 2 * A 
    return

def draw_line2(ary, x0, y0, x1, y1):   
    if y0 > y1:
        draw_line2(ary, x1, y1, x0, y0)
    elif x0 == x1:
        y = y0
        while y <= y1:
            ary[len(ary) // 2 - 1 - y][x0 + len(ary) // 2 - 1] = [abs(x0), abs(y), abs(x0 * y % 255)]
            y += 1
        return
    else:
        x = x0
        y = y0
        A = y1 - y0
        B = x0 - x1
        d = 2 * B + A
        while y <= y1:
            ary[len(ary) // 2 - 1 - y][x + len(ary) // 2 - 1] = [abs(x), abs(y), x * y % 255]
            if d < 0:
                x += 1
                d += 2 * A
            y += 1
            d += 2 * B 
        return

def draw_line7(ary, x0, y0, x1, y1):   
    if y0 < y1:
        draw_line7(ary, x1, y1, x0, y0)
    else:
        x = x0
        y = y0
        A = y1 - y0
        B = x0 - x1
        d = -2 * B + A
        while y >= y1:
            ary[len(ary) // 2 - 1 - y][x + len(ary) // 2 - 1] = [abs(x), abs(y), x * y % 255]
            if d < 0:
                x += 1
                d -= 2 * A
            y -= 1
            d += 2 * B 
        return

def draw_line8(ary, x0, y0, x1, y1):
    x = x0
    y = y0
    A = y1 - y0
    B = x0 - x1
    d = -2 * A + B
    while x <= x1:
        ary[len(ary) // 2 - 1 - y][x + len(ary) // 2 - 1] = [abs(x), abs(y), x * y % 255]
        if d > 0:
            y -= 1
            d += 2 * B
        x += 1
        d -= 2 * A 
    return


main()
    