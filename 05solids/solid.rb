require_relative 'matrix'

def add_box(matrix, *args) # 6 args: x, y, z, width, height, depth (x, y, z represents top-left-front corner)
    x = args[0]
    y = args[1]
    z = args[2]
    nx = args[0] + args[3]
    ny = args[1] - args[4]
    nz = args[2] + args[5] # kinda unsure about this one but it works so lmao
    add_edge(matrix, x, y, z, nx, y, z)
    add_edge(matrix, x, y, z, x, ny, z)
    add_edge(matrix, x, y, z, x, y, nz)
    add_edge(matrix, nx, ny, z, x, ny, z)
    add_edge(matrix, nx, ny, z, nx, y, z)
    add_edge(matrix, nx, ny, z, nx, ny, nz)
    add_edge(matrix, x, ny, nz, nx, ny, nz)
    add_edge(matrix, x, ny, nz, x, y, nz)
    add_edge(matrix, x, ny, nz, x, ny, z)
    add_edge(matrix, nx, y, nz, x, y, nz)
    add_edge(matrix, nx, y, nz, nx, ny, nz)
    add_edge(matrix, nx, y, nz, nx, y, z)
end

def gen_points(type, matrix, *args)
    if type == 'sphere'
        return gen_sphere(matrix, *args)
    elsif type == 'torus'
        return gen_torus(matrix, *args)
    end
end  

def add_sphere(matrix, *args) # 4 args: x, y, z, radius
    gen_points('sphere', matrix, *args).each {|p|
        add_edge(matrix, *p, *(p.map {|x| x + 1})) # increments each coordinate in p by 1
    }
end

def gen_sphere(matrix, *args) # 4 args: x, y, z, radius
    points = Array.new()
    step = 20
    step.times {|phi| 
        step.times {|theta|
            points.push([args[3] * Math.cos(Math::PI / step * theta) + args[0], 
                         args[3] * Math.sin(Math::PI / step * theta) * Math.cos(Math::PI / step * phi * 2)  + args[1],
                         args[3] * Math.sin(Math::PI / step * theta) * Math.sin(Math::PI / step * phi * 2) + args[2]])
        }
    }
    # puts points.length
    return points
end

def add_torus(matrix, *args) # 5 args: x, y, z, cross-section radius, external radius
    gen_points('torus', matrix, *args).each {|p|
        add_edge(matrix, *p, *(p.map {|x| x + 1}))
    }
end

def gen_torus(matrix, *args) # 5 args: x, y, z, cross-section radius, external radius
    points = Array.new()
    step = 20
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




