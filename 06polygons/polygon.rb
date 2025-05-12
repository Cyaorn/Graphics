require_relative 'line'
require_relative 'matrix'

def add_triangle(matrix, x0, y0, z0, x1, y1, z1, x2, y2, z2)
    add_point(matrix, x0, y0, z0)
    add_point(matrix, x1, y1, z1)
    add_point(matrix, x2, y2, z2)
end

def draw_triangle(ary, x0, y0, x1, y1, x2, y2)
    draw_line(ary, x0, y0, x1, y1) 
    draw_line(ary, x1, y1, x2, y2) 
    draw_line(ary, x2, y2, x0, y0) 
end