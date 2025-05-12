=begin
def draw_line(ary, x0, y0, x1, y1)
    if x0 > x1
        draw_line(ary, x1, y1, x0, y0)
    else
        delta_y = y1 - y0
        delta_x = x1 - x0
        if delta_y.abs > delta_x.abs # steep slope
            if delta_y < 0 # octant 7
                draw_line7(ary, x0, y0, x1, y1)
            else # octant 2
                draw_line2(ary, x0, y0, x1, y1)
            end
        else # shallow slope
            if delta_y < 0 # octant 8
                draw_line8(ary, x0, y0, x1, y1)
            else # octant 1
                draw_line1(ary, x0, y0, x1, y1)
            end
        end
    end
end

def draw_line1(ary, x0, y0, x1, y1)
    x = x0
    y = y0
    a = y1 - y0
    b = x0 - x1
    d = 2 * a + b
    while x <= x1 do
        ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255]
        if d > 0
            y += 1
            d += 2 * b
        end
        x += 1
        d += 2 * a 
    end
    return
end

def draw_line2(ary, x0, y0, x1, y1)
    if y0 > y1
        draw_line2(ary, x1, y1, x0, y0)
    elsif x0 == x1
        y = y0
        while y <= y1 do
            ary[ary.length / 2 - 1 - y][x0 + ary.length / 2 - 1] = [255, 255, 255]
            y += 1
        end
    else
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = 2 * b + a
        while y <= y1
            ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255]
            if d < 0
                x += 1
                d += 2 * a
            end
            y += 1
            d += 2 * b 
        end
    end
end

def draw_line7(ary, x0, y0, x1, y1)
    if y0 < y1
        draw_line7(ary, x1, y1, x0, y0)
    else
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = -2 * b + a
        while y >= y1 do
            ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255]
            if d < 0
                x += 1
                d -= 2 * a
            end
            y -= 1
            d += 2 * b
        end
    end
end

def draw_line8(ary, x0, y0, x1, y1)
    x = x0
    y = y0
    a = y1 - y0
    b = x0 - x1
    d = -2 * a + b
    while x <= x1 do
        ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255]
        if d > 0
            y -= 1
            d += 2 * b
        end
        x += 1
        d -= 2 * a 
    end
end
=end

def draw_line(ary, x0, y0, x1, y1)
    if x0 > x1
        draw_line(ary, x1, y1, x0, y0)
    else
        delta_y = y1 - y0
        delta_x = x1 - x0
        if delta_y.abs > delta_x.abs # steep slope
            if delta_y < 0 # octant 7
                draw_line7(ary, x0, y0, x1, y1)
            else # octant 2
                draw_line2(ary, x0, y0, x1, y1)
            end
        else # shallow slope
            if delta_y < 0 # octant 8
                draw_line8(ary, x0, y0, x1, y1)
            else # octant 1
                draw_line1(ary, x0, y0, x1, y1)
            end
        end
    end
end

def draw_line1(ary, x0, y0, x1, y1)
    x = x0
    y = y0
    a = y1 - y0
    b = x0 - x1
    d = 2 * a + b
    while x <= x1 do
        # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
        ary[ary.length - y - 1][x] = [255, 255, 255]
        if d > 0
            y += 1
            d += 2 * b
        end
        x += 1
        d += 2 * a 
    end
    return
end

def draw_line2(ary, x0, y0, x1, y1)
    if y0 > y1
        draw_line2(ary, x1, y1, x0, y0)
    elsif x0 == x1
        y = y0
        while y <= y1 do
            ary[ary.length - y - 1][x0] = [255, 255, 255]
            y += 1
        end
    else
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = 2 * b + a
        while y <= y1
            # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
            ary[ary.length - y - 1][x] = [255, 255, 255]
            if d < 0
                x += 1
                d += 2 * a
            end
            y += 1
            d += 2 * b 
        end
    end
end

def draw_line7(ary, x0, y0, x1, y1)
    if y0 < y1
        draw_line7(ary, x1, y1, x0, y0)
    else
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = -2 * b + a
        while y >= y1 do
            # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
            ary[ary.length - y - 1][x] = [255, 255, 255]
            if d < 0
                x += 1
                d -= 2 * a
            end
            y -= 1
            d += 2 * b
        end
    end
end

def draw_line8(ary, x0, y0, x1, y1)
    x = x0
    y = y0
    a = y1 - y0
    b = x0 - x1
    d = -2 * a + b
    while x <= x1 do
        # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
        ary[ary.length - y - 1][x] = [255, 255, 255]
        if d > 0
            y -= 1
            d += 2 * b
        end
        x += 1
        d -= 2 * a 
    end
end