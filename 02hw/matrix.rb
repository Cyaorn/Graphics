=begin
a = Array.new(4) {Array.new(4, 0)}
a.length.times do |x|
    a[x][x] = 2
end
p a
=end

=begin
a = Array.new(2) {Array.new(2, 0)}
a.length.times {|x|
    a[x][x] = 2
}
p a

b = Array.new(2) {Array.new(3, 0)}
count = 1
b.length.times {|x|
    b[x].length.times {|y|
        b[x][y] = count
        count += 1
    }
}
p b
=end

def main()
    out = Array.new(601) {Array.new(601, [0, 0, 0])}
    matrix = Array.new(0)
    (-300..300).step(30) {|x| 
        (-300..300).step(50) {|y|
            add_edge(matrix, x, y, rand(-300..300), rand(-300..300))
        }
    }
    draw_matrix(out, matrix)
    File.open('image.ppm', 'w') {|file|
        file.write("P3\n601\n601\n255\n")
        out.length.times {|i|
            out[i].length.times{|j|
                3.times {|k|
                    file.write(out[i][j][k].to_s + ' ')
                }
            }
        }
    }
end

def mult(a, b)
    new = Array.new(b.length) {Array.new(a[0].length, 0)}
    a[0].length.times {|i|
        b.length.times {|j|
            total = 0
            a.length.times {|k|
                # puts "row: #{i}, col: #{j}, index: #{k}, a: #{a[k][i]}, b: #{b[j][k]}" 
                # p b
                total += a[k][i] * b[j][k]
            new[j][i] = total
            }  
        }
        # print_matrix(new)
    }
    b.replace(new)
end

def ident(size)
    new = Array.new(size) {Array.new(size, 0)}
    size.times {|i|
        new[i][i] = 1
    }
    return new
end

def print_matrix(matrix)
    out = ""
    if matrix.length == 0
        return out
    end
    matrix[0].length.times {|x|
        matrix.length.times {|y|
            out = out + matrix[y][x].to_s + ' '
        }
        out = out + "\n"
    }
    puts out + "\n"
end

def add_point(matrix, x, y)
    new = matrix.map {|x| x}
    new.append([x, y, 0, 1]) # this will most likely be changed later
    matrix.replace(new)
end

def add_edge(matrix, x0, y0, x1, y1)
    add_point(matrix, x0, y0)
    add_point(matrix, x1, y1)
end

def draw_matrix(ary, matrix)
    new = ary.map {|a| a}
    matrix.each_slice(2) {|s|
        draw_line(new, s[0][0], s[0][1], s[1][0], s[1][1])
    }
    ary.replace(new)
end

# drawline stuff

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
        ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255, 1]
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
            ary[ary.length / 2 - 1 - y][x0 + ary.length / 2 - 1] = [255, 255, 255, 1]
            y += 1
        end
    else
        x = x0
        y = y0
        a = y1 - y0
        b = x0 - x1
        d = 2 * b + a
        while y <= y1
            ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255, 1]
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
            ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255, 1]
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
        ary[ary.length / 2 - 1 - y][x + ary.length / 2 - 1] = [255, 255, 255, 1]
        if d > 0
            y -= 1
            d += 2 * b
        end
        x += 1
        d -= 2 * a 
    end
end


test_matrix = []
puts "Testing append: Appending [1, 2, 3, 4] to empty matrix M"
test_matrix.append([1, 2, 3, 4])
print_matrix(test_matrix)
puts "Testing append: Appending [5, 6, 7, 8], [9, 10, 11, 12] to M"
test_matrix.append([5, 6, 7, 8])
test_matrix.append([9, 10, 11, 12])
print_matrix(test_matrix)
puts "Creating 4 x 4 identity matrix, I:"
iden = ident(4)
print_matrix(iden)
puts "Testing identity multiplication: I * M"
mult(iden, test_matrix)
print_matrix(test_matrix)
puts "New array L: "
L = [[1, 2, 3], [2, 4, 6], [3, 6, 9], [4, 8, 12]]
print_matrix(L)
puts "Testing standard multiplication: L * M"
mult(L, test_matrix)
print_matrix(test_matrix)

main()
