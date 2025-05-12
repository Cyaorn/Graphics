require_relative 'matrix'
require_relative 'polygon'

def add_box(matrix, *args) # 6 args: x, y, z, width, height, depth (x, y, z represents top-left-front corner)
    x = args[0]
    y = args[1]
    z = args[2]
    nx = args[0] + args[3]
    ny = args[1] - args[4]
    nz = args[2] - args[5] 
    add_triangle(matrix, x, y, z, nx, ny, z, nx, y, z) # front face
    add_triangle(matrix, x, y, z, x, ny, z, nx, ny, z)
    add_triangle(matrix, nx, y, z, nx, ny, z, nx, ny, nz) # right face
    add_triangle(matrix, nx, y, z, nx, ny, nz, nx, y, nz)
    add_triangle(matrix, nx, y, nz, x, ny, nz, x, y, nz) # back face
    add_triangle(matrix, nx, y, nz, nx, ny, nz, x, ny, nz)
    add_triangle(matrix, x, y, nz, x, ny, z, x, y, z) # left face
    add_triangle(matrix, x, y, nz, x, ny, nz, x, ny, z)
    add_triangle(matrix, x, y, nz, nx, y, z, nx, y, nz) # top face
    add_triangle(matrix, x, y, nz, x, y, z, nx, y, z)
    add_triangle(matrix, x, ny, z, nx, ny, nz, nx, ny, z) # bottom face
    add_triangle(matrix, x, ny, z, x, ny, nz, nx, ny, nz)
end

def gen_points(type, matrix, step, *args)
    if type == 'sphere'
        return gen_sphere(matrix, step, *args)
    elsif type == 'torus'
        return gen_torus(matrix, step, *args)
    end
end  

def add_sphere(matrix, step, *args) # 4 args: x, y, z, radius
    points = gen_points('sphere', matrix, step, *args)
    (-points.length...0).each_slice(step) {|p| # each semicircle
        p.slice(0..-2).each { |q| # every point in the semicircle but the last 
            unless q == p[0]
                add_triangle(matrix, *points[q], *points[q + 1], *points[q + step])
            end
            unless q == p[step-2]
                add_triangle(matrix, *points[q + 1], *points[q + step + 1], *points[q + step])
            end
        }
        # add_triangle(matrix, *points[p[-2]], *points[p[-1]], *points[p[-1] + step])
    }
end

def gen_sphere(matrix, step, *args) # 4 args: x, y, z, radius
    points = Array.new()
    step.times {|phi| 
        step.times {|theta|
            points.push([args[3] * Math.cos(Math::PI / (step - 1) * theta) + args[0], 
                         args[3] * Math.sin(Math::PI / (step - 1) * theta) * Math.cos(Math::PI / (step - 1) * phi * 2) + args[1],
                         args[3] * Math.sin(Math::PI / (step - 1) * theta) * Math.sin(Math::PI / (step - 1) * phi * 2) + args[2]])
        }
    }
    # puts points.length
    return points
end

def add_torus(matrix, step, *args) # 5 args: x, y, z, cross-section radius, external radius
    points= gen_points('torus', matrix, step, *args)
    (-points.length..0).each_slice(step) {|p| # each circle
        p.slice(0..-2).each { |q| # every point in the circle
            add_triangle(matrix, *points[q], *points[q + 1], *points[q + step])
            add_triangle(matrix, *points[q + 1], *points[q + step + 1], *points[q + step])
        }
        add_triangle(matrix, *points[p[-1]], *points[p[0]], *points[p[-1] + step]) # weird cases when the indices wrap around the torus
        add_triangle(matrix, *points[p[0]], *points[p[0] + step], *points[p[0] + step + step - 1])
    }
end

def gen_torus(matrix, step, *args) # 5 args: x, y, z, cross-section radius, external radius
    points = Array.new()
    step.times {|phi| 
        step.times {|theta|
            points.push([Math.cos(Math::PI / step * phi * 2) * (args[3] * Math.cos(Math::PI / step * theta * 2) + args[4]) + args[0], 
                         args[3] * Math.sin(Math::PI / step * theta * 2) + args[1],
                         -(Math.sin(Math::PI / step * phi * 2)) * (args[3] * Math.cos(Math::PI / step * theta * 2) + args[4]) + args[4]])
        }
    }
    # puts points.length
    return points
end




