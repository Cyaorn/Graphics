require_relative 'line'
require_relative 'polygon'
require_relative 'vector'

def mult(a, b)
    new = Array.new(b.length) {Array.new(a[0].length, 0)}
    a[0].length.times {|i|
        b.length.times {|j|
            new[j][i] = a.length.times.inject(0) {|total, k| # 0 acts as the initial value for the accumulator
                total += a[k][i] * b[j][k]
            }
        }
    }
    b.replace(new)
end

def ident(size)
    new = Array.new(size) {Array.new(size, 0)}
    size.times {|i|
        new[i][i] = 1.0
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

def add_point(matrix, x, y, z)
    new = matrix.map {|x| x}
    new.append([x, y, z, 1.0]) 
    matrix.replace(new)
end

def add_edge(matrix, x0, y0, z0, x1, y1, z1)
    # puts "#{x0.truncate(3)} #{y0.truncate(3)} #{z0.truncate(3)} #{x1.truncate(3)} #{y1.truncate(3)} #{z1.truncate(3)}"
    add_point(matrix, x0, y0, z0)
    add_point(matrix, x1, y1, z1)
end

def draw_matrix(ary, matrix, type, zbuffer)
    new = ary.map {|a| a}
    if type == 0 # edges
        matrix.each_slice(2) {|s|
            draw_line(new, *(s.map{|z| z.slice(0..-2)}.flatten), zbuffer)
        }
        ary.replace(new)
    elsif type == 1 # triangle
        matrix.each_slice(3) {|t|
            if normal(*(t.map{|x| x.slice(0..-2)}.flatten))[2] > 0 # z component of the normal
                draw_triangle(new, *(t.map{|x| x.slice(0..-2)}.flatten), zbuffer)
            end
        }
        ary.replace(new)
    end
end

p [1, 2, 3, 4].slice(0..-2)
# what if god said write a connect_edge method that repeats the last point and then adds a new point