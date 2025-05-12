require_relative 'matrix'

# arbitrary arguments are easier to insert into the function directly
def add_circle(matrix, *args) # 4 arguments: x, y, z, radius
    new = matrix.map {|x| x}
    (0..1).step(0.002).to_a.each_cons(2) {|n| # iterates through all values of t in 2's with overlap of elements
        i = n.map {|m| m.to_f.truncate(3) } # weird error where stepping by 0.002 is not entirely exact -> truncate the float to 3 decimal places
        add_edge(new, args[3] * Math.cos(2 * Math::PI * i[0]) + args[0], 
                      args[3] * Math.sin(2 * Math::PI * i[0]) + args[1], args[2],
                      args[3] * Math.cos(2 * Math::PI * i[1]) + args[0], 
                      args[3] * Math.sin(2 * Math::PI * i[1]) + args[1], args[2], )                     
    }
    matrix.replace(new)
end 

def add_hermite(matrix, *args) # 8 arguments: x0, y0, x1, y1, rx0, ry0, rx1, ry1
    hermite_matrix = [[2.0, -3.0, 0.0, 1.0], [-2.0, 3.0, 0.0, 0.0], [1.0, -2.0, 1.0, 0.0], [1.0, -1.0, 0.0, 0.0]]
    x_ = [[]] # must be 2D
    y_ = [[]]
    (0..7).each {|i|
        if i.even?
            x_[0].append(args[i])
        else
            y_[0].append(args[i])
        end
    }
    mult(hermite_matrix, x_)
    mult(hermite_matrix, y_)
    new = matrix.map {|x| x}
    (0..1).step(0.005).to_a.each_cons(2) {|n|
        # puts calc(x_, n[0]), calc(y_, n[0])
        add_edge(new, calc(x_, n[0]), calc(y_, n[0]), 0, 
                      calc(x_, n[1]), calc(y_, n[1]), 0)
    }
    matrix.replace(new)
end

def calc(coeffs_, t)
    coeffs = coeffs_.flatten
    return (coeffs[0] * (t ** 3)) + (coeffs[1] * (t ** 2)) + (coeffs[2] * t) + coeffs[3]
end

def add_bezier(matrix, *args) # 8 arguments: x0, y0, x1, y1, x2, y2, x3, y3
    # bezier_matrix = [[-1.0, 3.0, -3.0, 1.0], [3.0, -6.0, 3.0, 0.0], [-3.0, 3.0, 0.0, 0.0], [3.0, 0.0, 0.0, 0.0]]
    bezier_matrix = [[-1.0, 3.0, -3.0, 1.0], [3.0, -6.0, 3.0, 0.0], [-3.0, 3.0, 0.0, 0.0], [1.0, 0.0, 0.0, 0.0]]
    x_ = [[]] # must be 2D
    y_ = [[]]
    (0..7).each {|i|
        if i.even?
            x_[0].append(args[i])
        else
            y_[0].append(args[i])
        end
    }
    mult(bezier_matrix, x_)
    mult(bezier_matrix, y_)
    new = matrix.map {|x| x}
    (0..1).step(0.005).to_a.each_cons(2) {|n|
        # puts calc(x_, n[0]), calc(y_, n[0])
        add_edge(new, calc(x_, n[0]), calc(y_, n[0]), 0, 
                      calc(x_, n[1]), calc(y_, n[1]), 0)
    }
    matrix.replace(new)
end