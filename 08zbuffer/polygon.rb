require_relative 'line'
require_relative 'matrix'

def add_triangle(matrix, x0, y0, z0, x1, y1, z1, x2, y2, z2)
    add_point(matrix, x0, y0, z0)
    add_point(matrix, x1, y1, z1)
    add_point(matrix, x2, y2, z2)
end

def draw_triangle(ary, x0, y0, z0, x1, y1, z1, x2, y2, z2, zbuffer)
    # draw_line(ary, x0, y0, x1, y1) 
    # draw_line(ary, x1, y1, x2, y2) 
    # draw_line(ary, x2, y2, x0, y0) 
    scanlines(ary, x0, y0, z0, x1, y1, z1, x2, y2, z2, zbuffer, rand(50..256).to_i, rand(50..256).to_i, rand(50..256).to_i)
end

=begin
def scanlines(screen, x0, y0, x1, y1, x2, y2, r, g, b)
    min_y = [y0, y1, y2].min
    points = [[x0, y0], [x1, y1], [x2, y2]] 
    start_p = points.select {|p| p[1] == min_y}[0]
    max_y = [y0, y1, y2].max
    end_p = points.select {|p| p[1] == max_y}[0]
    mid_p = points.reject {|p| p == start_p or p == end_p}[0]
    _x0 = start_p[0]
    _x1 = start_p[0]
    ((start_p[1] + 0.5).to_i..(end_p[1] + 0.5).to_i).each {|i| 
        draw_line(screen, (_x0 + 0.5).to_i, i, (_x1 + 0.5).to_i, i, r, g, b)
        _x0 += (end_p[0] - start_p[0]) / (end_p[1] - start_p[1])
        _x1 += i < mid_p[1]? (mid_p[0] - start_p[0]) / (mid_p[1] - start_p[1]) : (end_p[0] - mid_p[0]) / (end_p[1] - mid_p[1])
    } # ternary statement ^
=begin
    puts "nut--------------------------------------"
    ((mid_p[1] + 0.5).to_i..(end_p[1] + 0.5).to_i).each {|i|
        # puts i
        draw_line(screen, _x0, i, _x1, i)
        _x0 += (end_p[0] - start_p[0]) / (end_p[1] - start_p[1])
        _x1 += (end_p[0] - mid_p[0]) / (end_p[1] - mid_p[1])
    }
    puts "end--------------------------------------------"
end
=end


def scanlines(screen, x0, y0, z0, x1, y1, z1, x2, y2, z2, zbuffer, r, g, b)
    # puts "#{x0}, #{y0} // #{x1}, #{y1} // #{x2}, #{y2}"
    min_y = [y0, y1, y2].min
    points = [[x0, y0, z0], [x1, y1, z1], [x2, y2, z2]] 
    start_p = points.select {|p| p[1] == min_y}[0]
    max_y = [y0, y1, y2].max
    end_p = points.select {|p| p[1] == max_y}[0]
    mid_p = points.reject {|p| p == start_p or p == end_p}[0]
    other_mid = [(mid_p[1] - start_p[1]) / (end_p[1] - start_p[1]) * (end_p[0] - start_p[0]) + start_p[0], mid_p[1], (mid_p[1] - start_p[1]) / (end_p[1] - start_p[1]) * (end_p[2] - start_p[2]) + start_p[2]]
    other_mid.map! {|j| (j + 0.5).to_i}
    if start_p[1] == mid_p[1] or mid_p[1] == end_p[1]
        if start_p[1] == mid_p[1]
            # puts 'a'
            scanlines_u(screen, *(start_p + mid_p + end_p), zbuffer, r, g, b) # add z
        elsif mid_p[1] == end_p[1]
            # puts 'c'
            scanlines_d(screen, *(start_p + mid_p + end_p), zbuffer, r, g, b) # add z
        end
    else
        # puts 'b'
        scanlines_d(screen, *(start_p + mid_p + other_mid), zbuffer, r, g, b) # add z
        # puts 'd'
        scanlines_u(screen, *(mid_p + other_mid + end_p), zbuffer, r, g, b) # add z
    end
end

def scanlines_d(screen, x0, y0, z0, x1, y1, z1, x2, y2, z2, zbuffer, r, g, b)
    _x1 = x0
    _x2 = x0
    _z1 = z0
    _z2 = z0
    # puts "#{x0} // #{x1} // #{x2}"
    ((y0 + 0.5).to_i..(y2 + 0.5).to_i).each {|i| 
        draw_line(screen, (_x1 + 0.5).to_i, i, (_z1 + 0.5).to_i, (_x2 + 0.5).to_i, i, (_z2 + 0.5).to_i, zbuffer, r, g, b)
        # puts "#{_x1} || #{_x2}"
        _x1 += (x1 - x0) / (y1 - y0)
        _x2 += (x2 - x0) / (y2 - y0)
        _z1 += (z1 - z0) / (y1 - y0)
        _z2 += (z2 - z0) / (y2 - y0)
    }
    # puts "#{x0} // #{x1} // #{x2}"
end

def scanlines_u(screen, x0, y0, z0, x1, y1, z1, x2, y2, z2, zbuffer, r, g, b)
    _x1 = x0
    _x2 = x1
    _z1 = z0
    _z2 = z1
    ((y0 + 0.5).to_i..(y2 + 0.5).to_i).each {|i| 
        draw_line(screen, (_x1 + 0.5).to_i, i, (_z1 + 0.5).to_i, (_x2 + 0.5).to_i, i, (_z2 + 0.5).to_i, zbuffer, r, g, b)
        _x1 += (x2 - x0) / (y2 - y0)
        _x2 += (x2 - x1) / (y2 - y1)
        _z1 += (z2 - z0) / (y2 - y0)
        _z2 += (z2 - z1) / (y2 - y1)
    }
end

# puts 1 > 0? "a":"b"
# puts rand(100...255)
# (1..5).each {|i| puts i}
# s = [141.0, 254.0]
# t = [116.0, 298.0]
# m = [73.0, 273.0]
# puts (m[1] - s[1]) / (t[1] - s[1]) * (t[0] - s[0]) + s[0]