def trans(*args) # only takes the first 3 arguments
    new = Array.new(4) {Array.new(4, 0.0)}
    4.times {|i|
        new[3][i] = args[i].to_f
        new[i][i] = 1.0
    }
    return new
end

def scale(*args)
    new = Array.new(4) {Array.new(4, 0.0)}
    3.times {|i|
        new[i][i] = args[i].to_f
    }
    new[3][3] = 1.0
    return new
end

def rot(axis, theta)
    if axis == 'x'
        return rot_x(theta.to_f)
    elsif axis == 'y'
        return rot_y(theta.to_f)
    elsif axis == 'z'
        return rot_z(theta.to_f)
    end
end

def rot_x(_theta)
    new = ident(4)
    theta = _theta * Math::PI / 180.0
    new[1][1] = Math.cos(theta)
    new[1][2] = Math.sin(theta)
    new[2][1] = -Math.sin(theta)
    new[2][2] = Math.cos(theta)
    return new
end

def rot_y(_theta)
    new = ident(4)
    theta = _theta * Math::PI / 180.0
    new[0][0] = Math.cos(theta)
    new[0][2] = -Math.sin(theta)
    new[2][0] = Math.sin(theta)
    new[2][2] = Math.cos(theta)
    return new
end

def rot_z(_theta)
    new = ident(4)
    theta = _theta * Math::PI / 180.0
    new[0][0] = Math.cos(theta)
    new[0][1] = Math.sin(theta)
    new[1][0] = -Math.sin(theta)
    new[1][1] = Math.cos(theta)
    return new
end