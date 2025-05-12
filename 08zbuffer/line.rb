XRES = 500 # variables with capital first letter are constants
YRES = 500

def draw_line(ary, x0, y0, z0, x1, y1, z1, zbuffer, r=255, g=255, bl=255)
    if x0 > x1
        draw_line(ary, x1, y1, z1, x0, y0, z0, zbuffer, r, g, bl)
    else
        delta_y = y1 - y0
        delta_x = x1 - x0
        if delta_y.abs > delta_x.abs # steep slope
            if delta_y < 0 # octant 7
                draw_line7(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
            else # octant 2
                draw_line2(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
            end
        else # shallow slope
            if delta_y < 0 # octant 8
                draw_line8(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
            else # octant 1
                draw_line1(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
            end
        end
    end
end

def draw_line1(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
    _zbuffer = zbuffer.map{|x| x}
    x = x0
    y = y0
    z = z0
    a = y1 - y0
    b = x0 - x1
    d = 2 * a + b
    while x <= x1 do # you could do this with a foreach loop but whatever dude
        # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
        if (ary.length - y - 1) < YRES and (ary.length - y - 1) >= 0 and x < XRES and x > 0
            if _zbuffer[ary.length - y - 1][x].nil? or _zbuffer[ary.length - y - 1][x] < z
                ary[ary.length - y - 1][x] = [r, g, bl]
                _zbuffer[ary.length - y - 1][x] = z
            end
        end 
        if d > 0
            y += 1
            d += 2 * b
        end
        x += 1
        z += (z1 - z0) / ((x1 - x0).abs + 1)
        d += 2 * a 
    end
    zbuffer.replace(_zbuffer)
end

def draw_line2(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
    if y0 > y1
        draw_line2(ary, x1, y1, z1, x0, y0, z0, zbuffer, r, g, bl)
    elsif x0 == x1
        _zbuffer = zbuffer.map{|x| x}
        y = y0
        while y <= y1 do
            if (ary.length - y - 1) < YRES and (ary.length - y - 1) >= 0 and x < XRES and x > 0
                if _zbuffer[ary.length - y - 1][x].nil? or _zbuffer[ary.length - y - 1][x] < z
                    ary[ary.length - y - 1][x] = [r, g, bl]
                    _zbuffer[ary.length - y - 1][x] = z
                end
            end 
            y += 1
        end
    else
        _zbuffer = zbuffer.map{|x| x}
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = 2 * b + a
        while y <= y1
            # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
            if (ary.length - y - 1) < YRES and (ary.length - y - 1) >= 0 and x < XRES and x > 0
                if _zbuffer[ary.length - y - 1][x].nil? or _zbuffer[ary.length - y - 1][x] < z
                    ary[ary.length - y - 1][x] = [r, g, bl]
                    _zbuffer[ary.length - y - 1][x] = z
                end
            end 
            if d < 0
                x += 1
                d += 2 * a
            end
            y += 1
            z += (z1 - z0) / (y1 - y0).abs + 1
            d += 2 * b 
        end
    end
    zbuffer.replace(_zbuffer)
end

def draw_line7(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
    if y0 < y1
        draw_line7(ary, x1, y1, z1, x0, y0, z0, zbuffer, r, g, bl)
    else
        _zbuffer = zbuffer.map{|x| x}
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = -2 * b + a
        while y >= y1 do
            # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
            if (ary.length - y - 1) < YRES and (ary.length - y - 1) >= 0 and x < XRES and x > 0
                if _zbuffer[ary.length - y - 1][x].nil? or _zbuffer[ary.length - y - 1][x] < z
                    ary[ary.length - y - 1][x] = [r, g, bl]
                    _zbuffer[ary.length - y - 1][x] = z
                end
            end             
            if d < 0
                x += 1
                d -= 2 * a
            end
            y -= 1
            z += (z1 - z0) / (y1 - y0).abs + 1
            d += 2 * b
        end
    end
    zbuffer.replace(_zbuffer)
end

def draw_line8(ary, x0, y0, z0, x1, y1, z1, zbuffer, r, g, bl)
    _zbuffer = zbuffer.map{|x| x}
    x = x0
    y = y0
    a = y1 - y0
    b = x0 - x1
    d = -2 * a + b
    while x <= x1 do
        # puts "coords: #{(ary.length - y).truncate(3)}, #{x.truncate(3)}"
        if (ary.length - y - 1) < YRES and (ary.length - y - 1) >= 0 and x < XRES and x > 0
            if _zbuffer[ary.length - y - 1][x].nil? or _zbuffer[ary.length - y - 1][x] < z
                ary[ary.length - y - 1][x] = [r, g, bl]
                _zbuffer[ary.length - y - 1][x] = z
            end
        end 
        if d > 0
            y -= 1
            d += 2 * b
        end
        x += 1
        z += (z1 - z0) / (x1 - x0).abs + 1
        d -= 2 * a 
    end
    zbuffer.replace(_zbuffer)
end