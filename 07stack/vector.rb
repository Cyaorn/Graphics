def norm(v)
    scale = (v[0]**2 + v[1]**2 + v[2]**2) ** 0.5
    return v.map {|x| x / scale}
end

def dot(v1, v2)
    zipped = v1.zip(v2)
    return zipped.inject(0) {|sum, x| sum + x.inject(1) {|pro, y| pro * y} }
end

def normal(x0, y0, z0, x1, y1, z1, x2, y2, z2)
    a = [x1 - x0, y1 - y0, z1 - z0]
    b = [x2 - x0, y2 - y0, z2 - z0]
    return [a[1]*b[2] - a[2]*b[1], a[2]*b[0] - a[0]*b[2], a[0]*b[1] - a[1]*b[0]]
end

